Attribute VB_Name = "modSystray"
Option Explicit

Public Declare Function Shell_NotifyIcon Lib "shell32.dll" Alias "Shell_NotifyIconA" (ByVal dwMessage As Long, ByRef lpData As NOTIFYICONDATA) As Long

Public Type NOTIFYICONDATA
    cbSize           As Long
    hWnd             As Long
    uId              As Long
    uFlags           As Long
    uCallBackMessage As Long
    hIcon            As Long
    szTip            As String * 64
End Type
    
Public Type MENUITEMINFO
    cbSize        As Long
    fMask         As Long
    fType         As Long
    fState        As Long
    wID           As Long
    hSubMenu      As Long
    hbmpChecked   As Long
    hbmpUnchecked As Long
    dwItemData    As Long
    dwTypeData    As String
    cch           As Long
End Type

'constants required by Shell_NotifyIcon API call:
Public Const NIM_ADD = &H0
Public Const NIM_MODIFY = &H1
Public Const NIM_DELETE = &H2
Public Const NIF_MESSAGE = &H1
Public Const NIF_ICON = &H2
Public Const NIF_TIP = &H4
Public Const WM_MOUSEMOVE = &H200
Public Const WM_LBUTTONDOWN = &H201     'Button down
Public Const WM_LBUTTONUP = &H202       'Button up
Public Const WM_LBUTTONDBLCLK = &H203   'Double-click
Public Const WM_RBUTTONDOWN = &H204     'Button down
Public Const WM_RBUTTONUP = &H205       'Button up
Public Const WM_RBUTTONDBLCLK = &H206   'Double-click

Public nid As NOTIFYICONDATA
