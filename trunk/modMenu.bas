Attribute VB_Name = "modMenu"
'Using the Menu APIs to Grow or Shrink a Menu During Run-time
'(c) Jon Vote, 2003
'
'Idioma Software Inc.
'jon@idioma-software.com
'www.idioma-software.com
'www.skycoder.com


'Adapted to StealthBot
' 2007-06-10, Andy T

Option Explicit

'Possible values for wFlags
Public Const MF_BITMAP = &H4&        'Menu item is bitmap. lpNewItem = handle to bitmap.
Public Const MF_CHECKED = &H8&       'Check flag.
Public Const MF_DISABLED = &H2&      'Disable flag.
Public Const MF_ENABLED = &H0&       'Enable flag.
Public Const MF_GRAYED = &H1&        'Greyed flag.
Public Const MF_MENUBARBREAK = &H20& 'Separator - verticle line if popup.
Public Const MF_MENUBREAK = &H40&    'Separator - no columns.
Public Const MF_OWNERDRAW = &H100&   'Owner drawn.
Public Const MF_POPUP = &H10&        'Popup menu (Sub-menu).
Public Const MF_SEPARATOR = &H800&   'Seperator - dropdown only.
Public Const MF_STRING = &H0&        'Item is a string.
Public Const MF_UNCHECKED = &H0&     'Un-check flag.
 
'Refer to menu item by position or command (ID).
Public Const MF_BYCOMMAND = &H0&
Public Const MF_BYPOSITION = &H400&

'First run-time menu item ID.
Private Const FIRST_MENU_NUMBER = 200

Public dctCallbacks As Dictionary
Public colDynamicMenus As Collection

'Menu Action Enum - possible user responses
Public Enum MenuAction
   ACTION_CONTINUE = 0
   ACTION_INSERT_ITEM_BEFORE = 1
   ACTION_INSERT_ITEM_AFTER = 2
   ACTION_INSERT_SUBMENU_BEFORE = 3
   ACTION_INSERT_SUBMENU_AFTER = 4
   ACTION_DELETE = 5
End Enum

'GetMenu returns a handle to the menu
Public Declare Function GetMenu Lib "user32" (ByVal hWnd As Long) As Long

'Get Submenu handle
Public Declare Function GetSubMenu Lib "user32" _
  (ByVal hMenu As Long, ByVal nPos As Long) As Long

'Refresh menu display
Public Declare Function DrawMenuBar Lib "user32" (ByVal hWnd As Long) As Long

'Creates a new popup menu or sub-menu
Public Declare Function CreatePopupMenu Lib "user32" () As Long

'Get menu item caption
Public Declare Function GetMenuString Lib "user32" Alias "GetMenuStringA" _
  (ByVal hMenu As Long, ByVal wIDItem As Long, ByVal lpString As String, _
   ByVal nMaxCount As Long, ByVal wFlag As Long) As Long

'Returns ItemID by Position
Public Declare Function GetMenuItemID Lib "user32" _
  (ByVal hMenu As Long, ByVal nPos As Long) As Long

'Returns number of menu items at this level
Public Declare Function GetMenuItemCount Lib "user32" (ByVal hMenu As Long) As Long

'Gets information about a menu item (at)
Private Declare Function GetMenuItemInfo Lib "user32" _
   Alias "GetMenuItemInfoA" _
   (ByVal hMenu As Long, ByVal uItemID As Long, ByVal ByPosition As Boolean, _
   lpMenuItemInfo As MENUITEMINFO) As Long

'Append menu item to end of list
Public Declare Function AppendMenu Lib "user32" Alias "AppendMenuA" _
    (ByVal hMenu As Long, ByVal wFlags As Long, _
     ByVal wIDNewItem As Long, ByVal lpNewItem As Any) As Long
    
'Toggle checkmark on an item (at)
Public Declare Function CheckMenuItem Lib "user32" _
    (ByVal hMenu As Long, ByVal wIDCheckItem As Long, _
     ByVal wCheck As Long) As Long
     
'Modify an existing menu (at)
Public Declare Function ModifyMenu Lib "user32" Alias "ModifyMenuA" _
    (ByVal hMenu As Long, ByVal uPosition As Long, _
     ByVal uFlags As Long, ByVal uIDNewItem As Long, _
     ByVal lpNewItemStr As Any) As Long

'Insert a menu item at nPosition
Public Declare Function InsertMenu Lib "user32" Alias "InsertMenuA" _
  (ByVal hMenu As Long, ByVal nPosition As Long, ByVal wFlags As Long, _
   ByVal wIDNewItem As Long, ByVal lpNewItem As Any) As Long

'Remove menu item
Public Declare Function RemoveMenu Lib "user32" _
  (ByVal hMenu As Long, ByVal nPosition As Long, ByVal wFlags As Long) As Long


'ProcessMenu: Called when the user has clicked a menu item.
Public Sub ProcessMenu(hWnd As Long, lngMenuCommand As Long)
    Dim s As String
  
  
    ' Call the callback function installed with this menu item
    If dctCallbacks.Exists(CStr(lngMenuCommand)) Then
        s = dctCallbacks.Item(CStr(lngMenuCommand))
    End If
    
    If LenB(s) > 0 Then
        frmChat.SControl.Run s
    End If
End Sub


'Written by Andy
Public Function GetMenuFlags(ByVal MenuID As Long, ByVal MenuCommandID As Long) As Long
    Const MIIM_STATE As Long = &H1&

    Dim l As Long
    Dim MII As MENUITEMINFO
    
    MII.cbSize = LenB(MII)
    MII.fMask = MIIM_STATE
    
    l = GetMenuItemInfo(MenuID, MenuCommandID, False, MII)
    
    GetMenuFlags = MII.fState
End Function


'GetMenuCaptionByCommand: Returns caption for menu item attached to hWnd
'with ID = lngMenuCommand.
Public Function GetMenuCaptionByCommand(ByVal hWnd As Long, _
                                     lngMenuCommand As Long) As String
 
  Dim lngRC As Long
  Dim lngMenuCount As Long
  Dim hMenu As Long
  Dim hSubMenu As Long
  Dim lngItem As Long
  Dim strString As String
  Dim lngMaxCount As Long
  Dim lngFlag As Long
  
  'Get the form's menu bar
  hMenu = GetMenu(hWnd)
  If hMenu <> 0 Then
    'Initialize the buffer
    strString = Space$(256)
    'lngRC gets the number of characters returned...
    lngRC = _
         GetMenuString(hMenu, lngMenuCommand, strString, Len(strString), MF_BYCOMMAND)
    'Return the item caption
    GetMenuCaptionByCommand = Left$(strString, lngRC)
  Else
    'Something went wrong here - nothing found.
    GetMenuCaptionByCommand = ""
  End If
     
End Function



'GetNextMenuNumber: Return the next menu number starting from FIRST_MENU_NUMBER
Public Function GetNextMenuNumber() As Integer
    
  Static intNextNumber As Integer
  
  If intNextNumber = 0 Then
    intNextNumber = FIRST_MENU_NUMBER
  Else
      intNextNumber = intNextNumber + 1
  End If
  GetNextMenuNumber = intNextNumber
  
End Function



'GetSubMenuCaptions: Prompts user for sub-menu and menu item captions.
'Returns FALSE if user cancel, else returns TRUE, updates strSubMenuCaption, strMenuItemCaption
Public Function GetSubMenuCaptions(ByRef strSubMenuCaption As String, _
                                     ByRef strMenuItemCaption As String) As Boolean
  
  strSubMenuCaption = GetDefaultSubMenuCaption()
  strSubMenuCaption = InputBox$("Please enter the new menu caption:", _
                                   "Add menu", strSubMenuCaption)
  
  If strSubMenuCaption <> "" Then
    strMenuItemCaption = GetDefaultMenuItemCaption()
    strMenuItemCaption = InputBox$("Please enter the new sub menu caption:", _
                                     "Add menu", strMenuItemCaption)
  End If
  
  'Return TRUE if both are non-null
  GetSubMenuCaptions = (strSubMenuCaption <> "") And (strMenuItemCaption <> "")
  
End Function



'GetMenuItemCaption: Prompts user for menu item caption.
'Returns FALSE if user cancel, else returns TRUE, updates strMenuItemCaption
Public Function GetMenuItemCaption(ByRef strMenuItemCaption As String)

  strMenuItemCaption = GetDefaultMenuItemCaption()
  strMenuItemCaption = InputBox$("Please enter the new menu caption:", _
                                    "Add menu", strMenuItemCaption)
                                    
  'Return TRUE if not null.
  GetMenuItemCaption = strMenuItemCaption <> ""
  
End Function



'GetDefaultItemCaption: Returns a default menu item caption.
Private Function GetDefaultMenuItemCaption() As String

  Static intCaptionNumber As Integer
  intCaptionNumber = intCaptionNumber + 1
  GetDefaultMenuItemCaption = "Item_" & Format$(intCaptionNumber, "00")
  
End Function



'GetDefaultSubMenuCaption: Returns a default sub menu caption.
Private Function GetDefaultSubMenuCaption() As String

  Static intSubMenuNumber As Integer
  intSubMenuNumber = intSubMenuNumber + 1
  GetDefaultSubMenuCaption = "Submenu_" & Format$(intSubMenuNumber, "00")
  
End Function



'FindMenuByID: Returns TRUE if lngFindMenuID is found.
'Updates hFoundMenu, lngFoundPosition
Public Function FindMenuByID(ByVal hMenu As Long, ByVal lngFindMenuID As Long, _
    ByRef hFoundMenu As Long, ByRef lngFoundPosition As Long) As Boolean
  
  Dim lngPosition As Long
  Dim lngCount As Long
  Dim lngMenuID As Long
  Dim hSubMenu As Long
  
  FindMenuByID = False
  
  'Get the number of items at this level
  lngCount = GetMenuItemCount(hMenu)
  
  'Loop for each item
  For lngPosition = 0 To lngCount - 1
    
    'Get the menu ID for the item at this position
    lngMenuID = GetMenuItemID(hMenu, lngPosition)
    
    'We are done if tnis ID matches lngFindMenuID
    If lngMenuID = lngFindMenuID Then
       hFoundMenu = hMenu
       lngFoundPosition = lngPosition
       FindMenuByID = True
       Exit Function
    'No match here - is this a sub-menu?
    ElseIf lngMenuID = -1 Then
       'We have a sub-menu here get the sub-menu handle.
       hSubMenu = GetSubMenu(hMenu, lngPosition)
       
       'Recurse back with the sub-menu handle.
       'We are done if we got a hit.
       If FindMenuByID(hSubMenu, lngFindMenuID, hFoundMenu, lngFoundPosition) Then
         FindMenuByID = True
         Exit For
       End If
    End If
  Next lngPosition
  
End Function

'AddParentMenu: Append or Insert a new menu/sub-menu pair to hMenu.
' Modified to return the menu ID it creates.
Public Function AddParentMenu(ByVal hMenu As Long, strItemCaption As String, _
                        Optional ByVal strSubItemCaption As String, Optional varPosition As Variant) As Long
  
  Dim hPopupMenu As Long
  Dim lngRC As Long, lngMenuID As Long
  
  'Create a new popup menu handle
  hPopupMenu = CreatePopupMenu()
  lngMenuID = GetNextMenuNumber()
  
  'Append the new item to the new sub-menu
  If LenB(strSubItemCaption) > 0 Then
    lngRC = AppendMenu(hPopupMenu, MF_STRING, lngMenuID, _
                     strSubItemCaption)
  End If
  
  'Append the new sub-menu if no position passed, else insert at varPosition
  If IsMissing(varPosition) Then
    lngRC = AppendMenu(hMenu, MF_POPUP, hPopupMenu, strItemCaption)
  Else
    lngRC = InsertMenu(hMenu, varPosition, MF_POPUP + MF_BYPOSITION, _
                       hPopupMenu, strItemCaption)
  End If
  
  ' Looks as if lngMenuID is internal to the program, whereas hPopupMenu is the Win32 handle to the menu
  
  AddParentMenu = hPopupMenu
End Function


' Written by Andy
Public Function AddMenuItem(ByVal hMenu As Long, ByVal strItemCaption As String, Optional ByVal Separator As Boolean = False, Optional ByVal Checked As Boolean = False, Optional ByVal Disabled As Boolean = False)
    Dim lngRC As Long, lngMenuID As Long, lngFlags As Long
    
    lngMenuID = GetNextMenuNumber()
    
    lngFlags = MF_STRING
    
    If Disabled Then lngFlags = lngFlags Or MF_GRAYED
    If Checked Then lngFlags = lngFlags Or MF_CHECKED
    If Separator Then lngFlags = MF_STRING Or MF_SEPARATOR  ' Overrides disabled & checked
    
    lngRC = AppendMenu(hMenu, lngFlags, lngMenuID, strItemCaption)
    
    AddMenuItem = lngMenuID
End Function



'DumpMenu: Accepts a Menu Handle,
'Recursively dumps all items and sub-menu items to debug window.
Public Sub DumpMenu(ByVal hMenu As Long)
  
  Dim lngPosition As Long
  Dim lngCount As Long
  Dim lngMenuID As Long
  Dim hSubMenu As Long
  Dim strMenuCaption As String
  Dim lngStrLen As Long
  
  'Get the number of items at this level
  lngCount = GetMenuItemCount(hMenu)
    
  'Loop for each item
  For lngPosition = 0 To lngCount - 1
    
    'Get the menu caption for this item
    strMenuCaption = Space$(256)
    lngStrLen = GetMenuString(hMenu, lngPosition, strMenuCaption, _
            Len(strMenuCaption), MF_BYPOSITION)
    strMenuCaption = Left$(strMenuCaption, lngStrLen)
    
    'Get the Menu ID for this item
    lngMenuID = GetMenuItemID(hMenu, lngPosition)
            
    'Dump the menu handle, menu ID, position, caption and item count.
    Debug.Print strMenuCaption, hMenu, lngMenuID, lngPosition
    
    'A -1 means this entry is itself another menu
    'If so, we will recursively call this routine,
    'passing the sub-menu handle.
    If lngMenuID = -1 Then
       'We have a sub-menu here,
       'get the sub-menu handle and recurse
       hSubMenu = GetSubMenu(hMenu, lngPosition)
       Call DumpMenu(hSubMenu)
       'Just a menu item here -
    End If
    
  Next lngPosition
  
End Sub

'DeleteMenuItem: Delete's a menu item and recursivly
'deletes any orphaned parents.
Public Sub DeleteMenuItem(ByVal hMenuBar As Long, hDeleteMenu As Long, _
                                                       lngDeletePosition As Long)
  Dim lngItemCount As Long
  Dim hParentMenu As Long
  Dim lngParentPosition As Long
  Dim bDeleteParent As Boolean
  Dim lngRC As Long
   
  'If the item count is 1, this is the last
  'menu item and we want to also delete the parent.
  If GetMenuItemCount(hDeleteMenu) = 1 Then
     'We want to delete the parent here, grab the
     'parent's menu handle and position.
     'We should always get a TRUE here...
     bDeleteParent = GetParentMenu(hMenuBar, hDeleteMenu, hParentMenu, lngParentPosition)
  Else
     bDeleteParent = False
  End If
  
  'Delete this item and recurse to delete the parent if applicable.
  lngRC = RemoveMenu(hDeleteMenu, lngDeletePosition, MF_BYPOSITION)
  If bDeleteParent Then
     DeleteMenuItem hMenuBar, hParentMenu, lngParentPosition
  End If

End Sub

' Written by Andy, 2007-06-11
Public Sub DeleteMenuItemByID(ByVal lId As Long)
    Dim hMenuBar As Long
    Dim l As Long
    Dim lngParentPosition As Long
    Dim hParentMenu As Long
    
    hMenuBar = GetMenu(frmChat.hWnd)
    
    l = GetMenuItemCount(lId)
    
    For l = 0 To l
        RemoveMenu lId, 0, MF_BYPOSITION
    Next l
    
    DeleteMenuItem ScriptMenu_ParentID, lId, lngParentPosition
End Sub


'GetParentMenu: Begins search at hMenuBar.
'Returns TRUE if parent menu found, updates hParentMenu, hParentPosition -
'else returns FALSE
Public Function GetParentMenu(ByVal hMenuBar As Long, ByVal hChildMenu As Long, _
                          ByRef hParentMenu As Long, ByRef hParentPosition As Long) As Long
  
  Dim lngPosition As Long
  Dim lngCount As Long
  Dim lngMenuID As Long
  Dim hSubMenu As Long
  Const NO_PARENT = -1
  
  'Default to no parent
  GetParentMenu = NO_PARENT
  
  'Get the number of items at this level
  lngCount = GetMenuItemCount(hMenuBar)
    
  'Loop for each item
  For lngPosition = 0 To lngCount - 1
    
    'Check each sub-menu looking for hChildMenu
    lngMenuID = GetMenuItemID(hMenuBar, lngPosition)
    If lngMenuID = -1 Then
       'We have a sub-menu here. We are done
       'if the sub-menu handle matches...
       hSubMenu = GetSubMenu(hMenuBar, lngPosition)
       If hSubMenu = hChildMenu Then
          hParentMenu = hMenuBar
          hParentPosition = lngPosition
          GetParentMenu = True
       Else
          'Didn't match here, recurse back to check this sub-menu.
          GetParentMenu = GetParentMenu(hSubMenu, hChildMenu, hParentMenu, hParentPosition)
       End If
    End If
    
  Next lngPosition
  
End Function
