VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmDBManager 
   AutoRedraw      =   -1  'True
   BackColor       =   &H80000007&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Database Manager"
   ClientHeight    =   6255
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   6735
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "frmDBManager"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6255
   ScaleWidth      =   6735
   StartUpPosition =   1  'CenterOwner
   WhatsThisHelp   =   -1  'True
   Begin MSComDlg.CommonDialog CommonDialog 
      Left            =   2880
      Top             =   4680
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      Filter          =   "*.txt"
   End
   Begin VB.CommandButton btnCreateGroup 
      Caption         =   "Create Group"
      Height          =   375
      Left            =   1800
      Picture         =   "frmDBManager.frx":0000
      TabIndex        =   2
      ToolTipText     =   "Create Group"
      Top             =   5378
      Width           =   1695
   End
   Begin VB.CommandButton btnCreateUser 
      Caption         =   "Create User"
      Height          =   375
      Left            =   120
      MaskColor       =   &H00000000&
      Picture         =   "frmDBManager.frx":0468
      TabIndex        =   1
      ToolTipText     =   "Create User"
      Top             =   5378
      Width           =   1695
   End
   Begin MSComctlLib.TabStrip tbsTabs 
      Height          =   320
      Left            =   120
      TabIndex        =   5
      Top             =   120
      Width           =   2813
      _ExtentX        =   4974
      _ExtentY        =   556
      MultiRow        =   -1  'True
      Style           =   1
      TabMinWidth     =   176
      _Version        =   393216
      BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
         NumTabs         =   3
         BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Users and Groups"
            Object.ToolTipText     =   "User entries identify individual users which can be grouped for easier control"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Clans"
            Object.ToolTipText     =   "Clan entries allow access to be given based on WarCraft III clan membership"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab3 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Games"
            Object.ToolTipText     =   "Game entries allow access to be given based on game type"
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
   Begin VB.CommandButton btnSave 
      Caption         =   "Apply and Cl&ose"
      Height          =   300
      Index           =   0
      Left            =   5280
      TabIndex        =   4
      Top             =   5880
      Width           =   1335
   End
   Begin VB.CommandButton btnCancel 
      Caption         =   "&Cancel"
      Height          =   300
      Left            =   4560
      TabIndex        =   3
      Top             =   5880
      Width           =   735
   End
   Begin MSComctlLib.TreeView trvUsers 
      Height          =   4845
      Left            =   120
      TabIndex        =   0
      Top             =   480
      Width           =   3375
      _ExtentX        =   5953
      _ExtentY        =   8546
      _Version        =   393217
      HideSelection   =   0   'False
      Indentation     =   575
      LineStyle       =   1
      Style           =   7
      ImageList       =   "icons"
      Appearance      =   1
      OLEDragMode     =   1
      OLEDropMode     =   1
   End
   Begin VB.Frame frmDatabase 
      BackColor       =   &H80000007&
      Caption         =   "Eric[nK]"
      ForeColor       =   &H00FFFFFF&
      Height          =   5415
      Left            =   3600
      TabIndex        =   6
      Top             =   360
      Width           =   3025
      Begin VB.ComboBox cbxGroups 
         BackColor       =   &H00993300&
         ForeColor       =   &H00FFFFFF&
         Height          =   315
         ItemData        =   "frmDBManager.frx":0889
         Left            =   240
         List            =   "frmDBManager.frx":0890
         Style           =   2  'Dropdown List
         TabIndex        =   23
         Top             =   2520
         Width           =   2570
      End
      Begin VB.CommandButton btnSave 
         Caption         =   "Save"
         Enabled         =   0   'False
         Height          =   300
         Index           =   1
         Left            =   1920
         TabIndex        =   9
         Top             =   4845
         Width           =   855
      End
      Begin VB.CommandButton btnDelete 
         Caption         =   "Delete"
         Enabled         =   0   'False
         Height          =   300
         Left            =   1080
         TabIndex        =   10
         Top             =   4845
         Width           =   855
      End
      Begin VB.TextBox txtBanMessage 
         BackColor       =   &H00993300&
         ForeColor       =   &H00FFFFFF&
         Height          =   285
         Left            =   240
         TabIndex        =   21
         Top             =   4440
         Width           =   2535
      End
      Begin MSComctlLib.ListView lvGroups 
         Height          =   1200
         Left            =   240
         TabIndex        =   19
         Top             =   2920
         Width           =   2565
         _ExtentX        =   4524
         _ExtentY        =   2117
         View            =   3
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         HideColumnHeaders=   -1  'True
         Checkboxes      =   -1  'True
         _Version        =   393217
         ForeColor       =   16777215
         BackColor       =   10040064
         Appearance      =   1
         NumItems        =   1
         BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            Object.Width           =   3969
         EndProperty
      End
      Begin VB.TextBox txtFlags 
         BackColor       =   &H00993300&
         Enabled         =   0   'False
         ForeColor       =   &H00FFFFFF&
         Height          =   285
         Left            =   1560
         MaxLength       =   25
         TabIndex        =   8
         Top             =   580
         Width           =   1215
      End
      Begin VB.TextBox txtRank 
         BackColor       =   &H00993300&
         Enabled         =   0   'False
         ForeColor       =   &H00FFFFFF&
         Height          =   285
         Left            =   240
         MaxLength       =   25
         TabIndex        =   7
         Top             =   580
         Width           =   1215
      End
      Begin VB.Label Label3 
         BackColor       =   &H00000000&
         Caption         =   "Ban message:"
         ForeColor       =   &H00FFFFFF&
         Height          =   255
         Left            =   240
         TabIndex        =   22
         Top             =   4200
         Width           =   2535
      End
      Begin VB.Label lblModifiedOn 
         BackColor       =   &H00000000&
         Caption         =   "(not applicable)"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   135
         Left            =   360
         TabIndex        =   16
         Top             =   1845
         Width           =   2415
      End
      Begin VB.Label Label1 
         BackColor       =   &H00000000&
         Caption         =   "Group(s):"
         ForeColor       =   &H00FFFFFF&
         Height          =   255
         Left            =   240
         TabIndex        =   20
         Top             =   2280
         Width           =   2535
      End
      Begin VB.Label lblModifiedBy 
         BackColor       =   &H00000000&
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   135
         Left            =   480
         TabIndex        =   18
         Top             =   2005
         Width           =   2415
      End
      Begin VB.Label lblCreatedBy 
         BackColor       =   &H00000000&
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   135
         Left            =   480
         TabIndex        =   17
         Top             =   1375
         Width           =   2415
      End
      Begin VB.Label lblFlags 
         BackColor       =   &H00000000&
         Caption         =   "Flags:"
         ForeColor       =   &H00FFFFFF&
         Height          =   255
         Left            =   1560
         TabIndex        =   12
         Top             =   340
         Width           =   1215
      End
      Begin VB.Label lblRank 
         BackColor       =   &H00000000&
         Caption         =   "Rank (1 - 200):"
         ForeColor       =   &H00FFFFFF&
         Height          =   255
         Left            =   240
         TabIndex        =   11
         Top             =   340
         Width           =   1215
      End
      Begin VB.Label lblCreatedOn 
         BackColor       =   &H00000000&
         Caption         =   "(not applicable)"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   135
         Left            =   360
         TabIndex        =   13
         Top             =   1215
         Width           =   2415
      End
      Begin VB.Label Label2 
         BackColor       =   &H00000000&
         Caption         =   "Created on:"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   135
         Index           =   0
         Left            =   240
         TabIndex        =   15
         Top             =   1005
         Width           =   2535
      End
      Begin VB.Label Label2 
         BackColor       =   &H00000000&
         Caption         =   "Last modified on:"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   135
         Index           =   1
         Left            =   240
         TabIndex        =   14
         Top             =   1630
         Width           =   2535
      End
   End
   Begin MSComctlLib.ImageList icons 
      Left            =   4080
      Top             =   4080
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   3
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmDBManager.frx":089C
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmDBManager.frx":0DEE
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmDBManager.frx":1340
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
      Visible         =   0   'False
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "Help"
      Visible         =   0   'False
   End
   Begin VB.Menu mnuContext 
      Caption         =   "mnuContext"
      Visible         =   0   'False
      Begin VB.Menu mnuRename 
         Caption         =   "Rename"
         Enabled         =   0   'False
      End
      Begin VB.Menu mnuDelete 
         Caption         =   "Delete"
         Enabled         =   0   'False
      End
   End
End
Attribute VB_Name = "frmDBManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' frmDBManager.frm
' Copyright (C) 2008 Eric Evans
Option Explicit

Public m_game          As String

Private m_DB()         As udtDatabase
Private m_modified     As Boolean
Private m_new_entry    As Boolean
Private m_DBDate       As Long
Private m_group_index  As Integer
Private m_group_change As Boolean

Private Sub cbxGroups_Click()
    Dim i As Integer
    
    For i = 1 To lvGroups.ListItems.Count
        If (StrComp(cbxGroups.Text, lvGroups.ListItems(i), vbTextCompare) = 0) Then
            lvGroups.ListItems(i).Checked = False
            Exit For
        End If
    Next i
    
    ' enable entry save command
    btnSave(1).Enabled = True
    
    m_group_change = True
End Sub

Private Sub Form_Load()
    Me.Icon = frmChat.Icon
    ' has our database been loaded?
    If (DB(0).Username = vbNullString) Then
        ' load database, if for some reason that hasn't been done
        Call LoadDatabase
    End If
    
    ' store temporary copy of database
    m_DB() = DB()
    
    ' show database for default tab
    Call tbsTabs_Click
End Sub ' end function Form_Load

Public Sub ImportDatabase(strPath As String, dbType As Integer)
    Dim f    As Integer
    Dim buf  As String
    Dim n    As node
    Dim i    As Integer
    
    f = FreeFile

    If (dbType = 0) Then
    
        Open strPath For Input As #f
            Do While (EOF(f) = False)
                Line Input #f, buf
                
                If (buf <> vbNullString) Then
                    If (GetAccess(buf, "USER").Username <> vbNullString) Then
                        For i = 0 To UBound(m_DB)
                            If ((StrComp(m_DB(i).Username, buf, vbTextCompare) = 0) And _
                                (StrComp(m_DB(i).Type, "USER", vbTextCompare) = 0)) Then
                            
                                With m_DB(i)
                                    .Username = buf
                                    .Type = "USER"
                                    .ModifiedBy = "(console)"
                                    .ModifiedOn = Now
                                    
                                    If (InStr(1, .Flags, "S", vbBinaryCompare) = 0) Then
                                        .Flags = .Flags & "S"
                                    End If
                                    
                                    If (Not (trvUsers.DropHighlight Is Nothing)) Then
                                        If (StrComp(trvUsers.DropHighlight.Tag, "Group", vbTextCompare) = 0) Then
                                            .Groups = .Groups & "," & trvUsers.DropHighlight.Text
                                        End If
                                    End If
                                    
                                    If (.Groups = vbNullString) Then
                                        .Groups = "%"
                                    End If
                                End With
                                
                                Exit For
                            End If
                        Next i
                    Else
                        ' redefine array to support new entry
                        ReDim Preserve m_DB(UBound(m_DB) + 1)
                        
                        ' create new database entry
                        With m_DB(UBound(m_DB))
                            .Username = buf
                            .Type = "USER"
                            .AddedBy = "(console)"
                            .AddedOn = Now
                            .ModifiedBy = "(console)"
                            .ModifiedOn = Now
                            .Flags = "S"
                            
                            If (Not (trvUsers.DropHighlight Is Nothing)) Then
                                If (StrComp(trvUsers.DropHighlight.Tag, "Group", vbTextCompare) = 0) Then
                                    If (IsInGroup(buf, trvUsers.DropHighlight.Text) = False) Then
                                        .Groups = .Groups & "," & trvUsers.DropHighlight.Text
                                    End If
                                End If
                            End If
                            
                            If (.Groups = vbNullString) Then
                                .Groups = "%"
                            End If
                        End With
                    End If
                End If
            Loop ' end loop
        Close #f
        
    ElseIf ((dbType = 1) Or (dbType = 2)) Then
        
        Dim user As String
        Dim Msg  As String
    
        Open strPath For Input As #f
            Do While (EOF(f) = False)
                Line Input #f, buf
                
                If (buf <> vbNullString) Then
                    If (Not InStr(1, buf, Space$(1), vbBinaryCompare) = 0) Then
                        user = Left$(buf, InStr(1, buf, Space$(1), vbBinaryCompare) - 1)
                        
                        Msg = Mid$(buf, Len(user) + 1)
                    Else
                        user = buf
                    End If
                
                    If (GetAccess(user, "USER").Username <> vbNullString) Then
                        For i = 0 To UBound(m_DB)
                            If ((StrComp(m_DB(i).Username, user, vbTextCompare) = 0) And _
                                (StrComp(m_DB(i).Type, "User", vbTextCompare) = 0)) Then
                                
                                With m_DB(i)
                                    .Username = user
                                    .Type = "USER"
                                    .ModifiedBy = "(console)"
                                    .ModifiedOn = Now
                                    
                                    If (InStr(1, .Flags, "B", vbBinaryCompare) = 0) Then
                                        .Flags = .Flags & "B"
                                    End If
                                    
                                    If (Not (trvUsers.DropHighlight Is Nothing)) Then
                                        If (StrComp(trvUsers.DropHighlight.Tag, "Group", vbTextCompare) = 0) Then
                                            If (IsInGroup(user, trvUsers.DropHighlight.Text) = False) Then
                                                .Groups = .Groups & "," & trvUsers.DropHighlight.Text
                                            End If
                                        End If
                                    End If
                                    
                                    If (.Groups = vbNullString) Then
                                        .Groups = "%"
                                    End If
                                End With
                            End If
                        Next i
                    Else
                        ' redefine array to support new entry
                        ReDim Preserve m_DB(UBound(m_DB) + 1)
                        
                        ' create new database entry
                        With m_DB(UBound(m_DB))
                            .Username = user
                            .Type = "USER"
                            .AddedBy = "(console)"
                            .AddedOn = Now
                            .ModifiedBy = "(console)"
                            .ModifiedOn = Now
                            .Flags = "B"
                            .BanMessage = Msg
                            
                            If (Not (trvUsers.DropHighlight Is Nothing)) Then
                                If (StrComp(trvUsers.DropHighlight.Tag, "Group", vbTextCompare) = 0) Then
                                    .Groups = trvUsers.DropHighlight.Text
                                End If
                            End If
                            
                            If (.Groups = vbNullString) Then
                                .Groups = "%"
                            End If
                        End With
                    End If
                End If
            Loop ' end loop
        Close #f
        
    End If
    
    tbsTabs_Click
End Sub

Private Sub btnCreateUser_Click()
    Static userKey   As Integer
    Dim userCount    As Integer
    Dim newNode      As node
    Dim gAcc         As udtGetAccessResponse
    Dim Username     As String
    
    userKey = userKey + 1
    
    Do
        userCount = userCount + 1
        Username = "New_User_#" & userCount
    Loop While (LenB(GetAccess(Username, "User").Username) > 0)
        
    ' redefine array to support new entry
    ReDim Preserve m_DB(UBound(m_DB) + 1)
    
    ' create new database entry
    With m_DB(UBound(m_DB))
        .Username = Username
        .Type = "USER"
        .AddedBy = "(console)"
        .AddedOn = Now
        .ModifiedBy = "(console)"
        .ModifiedOn = Now
    End With

    ' do we have an item (hopefully a group) selected?
    If (Not (trvUsers.SelectedItem Is Nothing)) Then
        ' is the item really just the root item?
        If (trvUsers.SelectedItem.Index = 1) Then
            Set newNode = trvUsers.nodes.Add(trvUsers.SelectedItem.Key, _
                tvwChild, "User: " & Username, Username, 3)
                
        Else
            ' is the item a group?
            If (StrComp(trvUsers.SelectedItem.Tag, "Group", vbTextCompare) = 0) Then
                ' create new node under group node
                Set newNode = trvUsers.nodes.Add(trvUsers.SelectedItem.Key, tvwChild, "User" & userKey, Username, 3)
    
                With m_DB(UBound(m_DB))
                    .Groups = trvUsers.SelectedItem.Text
                End With
            Else
                ' is our parent a group?
                If (StrComp(trvUsers.SelectedItem.Parent.Tag, "Group", vbTextCompare) = 0) Then
                    ' create new node under group node
                    Set newNode = trvUsers.nodes.Add(trvUsers.SelectedItem.Parent.Key, tvwChild, "User" & userKey, Username, 3)
                
                    ' set group settings on new database entry
                    With m_DB(UBound(m_DB))
                        .Groups = trvUsers.SelectedItem.Parent.Text
                    End With
                Else
                    ' create new node under root
                    Set newNode = trvUsers.nodes.Add("Database", tvwChild, "User" & userKey, Username, 3)
                End If
            End If
        End If
    Else
        ' lets just create the node under the root node
        Set newNode = trvUsers.nodes.Add("Database", tvwChild, "User" & userKey, Username, 3)
    End If
    
    If (Not (newNode Is Nothing)) Then
        ' change misc. settings
        With newNode
            .Tag = "User"
            .Selected = True
        End With
        
        m_new_entry = True
        
        ' open entry name for editing
        Call trvUsers.StartLabelEdit
    End If
End Sub

Private Sub btnCreateGroup_Click()
    Static groupCount As Integer
    Static clanCount  As Integer
    
    Dim newNode       As node
    
    If (tbsTabs.SelectedItem.Index = 1) Then ' Users and Groups Tab
        Dim GroupName As String
    
        Do
            GroupName = "New_Group_#" & (groupCount + 1)
        Loop While (GetAccess(GroupName, "Group").Username <> vbNullString)
        
        ReDim Preserve m_DB(UBound(m_DB) + 1)
        
        With m_DB(UBound(m_DB))
            .Username = GroupName
            .Type = "GROUP"
            .AddedBy = "(console)"
            .AddedOn = Now
            .ModifiedBy = "(console)"
            .ModifiedOn = Now
        End With
    
        ' do we have an item (hopefully a group) selected?
        If (Not (trvUsers.SelectedItem Is Nothing)) Then
            ' is the item reall just the root node?
            If (trvUsers.SelectedItem.Index = 1) Then
                Set newNode = trvUsers.nodes.Add(trvUsers.SelectedItem.Key, _
                    tvwChild, "Group: " & GroupName, GroupName, 1)
            Else
                If (StrComp(trvUsers.SelectedItem.Tag, "Group", vbTextCompare) = 0) Then
                    Set newNode = trvUsers.nodes.Add(trvUsers.SelectedItem.Key, _
                        tvwChild, "Group: " & GroupName, GroupName, 1)
    
                    With m_DB(UBound(m_DB))
                        .Groups = trvUsers.SelectedItem.Text
                    End With
                Else
                    Set newNode = trvUsers.nodes.Add(trvUsers.SelectedItem.Parent.Key, _
                        tvwChild, "Group: " & GroupName, GroupName, 1)
                        
                    If (StrComp(trvUsers.SelectedItem.Parent.Tag, "Group", vbTextCompare) = 0) Then
                        With m_DB(UBound(m_DB))
                            .Groups = trvUsers.SelectedItem.Parent.Text
                        End With
                    End If
                End If
            End If
        Else
            Set newNode = trvUsers.nodes.Add("Database", tvwChild, _
                "Group: " & GroupName, GroupName, 1)
        End If
        
        If (Not (newNode Is Nothing)) Then
            ' change misc. settings
            newNode.Tag = "Group"
            
            ' increment group counter
            groupCount = (groupCount + 1)
        End If
        
    ElseIf (tbsTabs.SelectedItem.Index = 2) Then ' Clan Tab
        Dim ClanName As String
    
        Do
            ClanName = "New Clan #" & (clanCount + 1)
        Loop While (GetAccess(GroupName, "Group").Username <> vbNullString)
        
        ReDim Preserve m_DB(UBound(m_DB) + 1)
        
        With m_DB(UBound(m_DB))
            .Username = ClanName
            .Type = "CLAN"
            .AddedBy = "(console)"
            .AddedOn = Now
            .ModifiedBy = "(console)"
            .ModifiedOn = Now
        End With
        
        Set newNode = trvUsers.nodes.Add("Database", tvwChild, "Clan: " & _
            ClanName, ClanName, 2)
        
        If (Not (newNode Is Nothing)) Then
            ' change misc. settings
            newNode.Tag = "Clan"
            
            ' increment clan counter
            clanCount = (clanCount + 1)
        End If
        
    ElseIf (tbsTabs.SelectedItem.Index = 3) Then ' Game Tab
        Call frmGameSelection.Show(vbModal, frmDBManager)
        
        If (m_game <> vbNullString) Then
            If (GetAccess(m_game, "GAME").Username = vbNullString) Then
                ReDim Preserve m_DB(UBound(m_DB) + 1)
                
                With m_DB(UBound(m_DB))
                    .Username = m_game
                    .Type = "GAME"
                    .AddedBy = "(console)"
                    .AddedOn = Now
                    .ModifiedBy = "(console)"
                    .ModifiedOn = Now
                End With
                
                Set newNode = trvUsers.nodes.Add("Database", tvwChild, "Game: " & _
                    m_game, m_game, 2)
                
                If (Not (newNode Is Nothing)) Then
                    ' change misc. settings
                    With newNode
                        .Tag = "Game"
                    End With
                End If
            Else
                ' alert user that game entry already exists
                MsgBox "There is already an entry of this type matching " & _
                    "the specified name."
            End If
        End If
    End If
    
    If (Not (newNode Is Nothing)) Then
        ' change misc. settings
        With newNode
            .Selected = True
        End With

        If ((tbsTabs.SelectedItem.Index = 1) Or (tbsTabs.SelectedItem.Index = 2)) Then
            m_new_entry = True
        
            Call trvUsers.StartLabelEdit
        End If
    End If
End Sub

Private Sub btnCancel_Click()
    Call Unload(frmDBManager)
End Sub

Private Sub btnSave_Click(Index As Integer)
    Dim i As Integer
    Dim j As Integer

    ' are we looking at a single entry or are we saving it all?
    If (Index = 1) Then
        ' if we have no selected user... escape quick!
        If (trvUsers.SelectedItem Is Nothing) Then
            ' break from function
            Exit Sub
        End If
    
        ' look for selected user in database
        For i = LBound(m_DB) To UBound(m_DB)
            ' is this the user we were looking for?
            If (StrComp(trvUsers.SelectedItem.Text, m_DB(i).Username, vbTextCompare) = 0) Then
                If (StrComp(trvUsers.SelectedItem.Tag, m_DB(i).Type, vbTextCompare) = 0) Then
                    ' modifiy user data
                    With m_DB(i)
                        .Rank = Val(txtRank.Text)
                        .Flags = txtFlags.Text
                        .ModifiedBy = "(console)"
                        .ModifiedOn = Now
                        .BanMessage = txtBanMessage.Text
                        
                        If (cbxGroups.ListIndex > 0) Then
                            .Groups = cbxGroups.Text
                        Else
                            .Groups = vbNullString
                        End If
                        
                        .Groups = .Groups & ","
                        
                        For j = 1 To lvGroups.ListItems.Count
                            If (lvGroups.ListItems(j).Checked) Then
                                .Groups = .Groups & lvGroups.ListItems(j).Text & ","
                            End If
                        Next j
                        
                        If (Len(.Groups) > 1) Then
                            .Groups = Left$(.Groups, Len(.Groups) - 1)
                        End If
                    End With
                    
                    'If (m_group_change) Then
                    '    If (m_group_index > -1) Then
                    '        m_DB(i).Groups = lstGroups.List(m_group_index)
                    '
                    '        If (tbsTabs.SelectedItem.index = 1) Then
                    '            Set trvUsers.SelectedItem.Parent = _
                    '                    trvUsers.Nodes(Exists(m_DB(i).Groups, "Group"))
                    '        End If
                    '    Else
                    '        m_DB(i).Groups = vbNullString
                    '
                    '        If (tbsTabs.SelectedItem.index = 1) Then
                    '            Set trvUsers.SelectedItem.Parent = trvUsers.Nodes(1)
                    '        End If
                    '    End If
                    '
                    '    If (lstGroups.SelCount > 1) Then
                    '        For j = 0 To (lstGroups.ListCount - 1)
                    '            If (j <> m_group_index) Then
                    '                If (lstGroups.Selected(j) = True) Then
                    '                    m_DB(i).Groups = m_DB(i).Groups & "," & _
                    '                        lstGroups.List(j)
                    '                End If
                    '            End If
                    '        Next j
                    '    End If
                    '
                    '    m_group_change = False
                    'End If
                    
                    ' break loop
                    Exit For
                End If
            End If
        Next i
        
        ' disable entry save command
        btnSave(1).Enabled = False
        
        If (m_group_change) Then
            tbsTabs_Click
        
            m_group_change = False
        End If
    Else
        ' write temporary database to official
        DB() = m_DB()
        
        ' save database
        Call WriteDatabase(GetFilePath("Users.txt"))
        
        ' check channel to find potential banned users
        Call g_Channel.CheckUsers
        
        ' close database form
        Call Unload(frmDBManager)
    End If
End Sub

Private Sub lvGroups_Click()
    Dim i As Integer
    
    For i = 1 To lvGroups.ListItems.Count
        If (lvGroups.ListItems(i).Selected) Then
            With lvGroups.ListItems(i)
                .Checked = Not .Checked
            End With
        End If
    
        If (StrComp(cbxGroups.Text, lvGroups.ListItems(i), vbTextCompare) = 0) Then
            With lvGroups.ListItems(i)
                .Checked = False
                .Selected = False
            End With
        End If
    Next i
    
    ' enable entry save command
    btnSave(1).Enabled = True
    
    Set trvUsers.DropHighlight = Nothing
    Set lvGroups.SelectedItem = Nothing
End Sub

'Private Sub lstGroups_Click()
'    m_group_change = True
'
'    If (lstGroups.SelCount = 0) Then
'        m_group_index = -1
'    ElseIf (lstGroups.SelCount = 1) Then
'        m_group_index = lstGroups.ListIndex
'    Else
'        MsgBox lstGroups.ListIndex
'    End If
'
'    btnSave(1).Enabled = True
'End Sub

Private Sub mnuDelete_Click()
    If (Not (trvUsers.SelectedItem Is Nothing)) Then
        Call HandleDeleteEvent(trvUsers.SelectedItem)
    End If
End Sub

Private Sub btnDelete_Click()
    If (Not (trvUsers.SelectedItem Is Nothing)) Then
        Call HandleDeleteEvent(trvUsers.SelectedItem)
    End If
End Sub

Private Sub mnuOpenDatabase_Click()
    ' open file dialog
    Call CommonDialog.ShowOpen
End Sub

Private Sub mnuRename_Click()
    ' open selected entry for editing
    Call trvUsers.StartLabelEdit
End Sub

' handle tab clicks and initial loading
Private Sub tbsTabs_Click()
    On Error GoTo ERROR_HANDLER

    Dim newNode As node

    Dim i       As Integer
    Dim grp     As String
    Dim j       As Integer
    Dim pos     As Integer
    Dim blnDuplicateFound As Boolean

    ' clear treeview
    Call trvUsers.nodes.Clear
    
    ' create root node
    Call trvUsers.nodes.Add(, , "Database", "Database")

    ' which tab index are we on?
    Select Case (tbsTabs.SelectedItem.Index)
        Case 1: ' Users and Groups
            For i = LBound(m_DB) To UBound(m_DB)
                ' we're handling groups first; is this entry a group?
                If (StrComp(m_DB(i).Type, "GROUP", vbBinaryCompare) = 0) Then
                    ' is this group a member of other groups?
                    If (Len(m_DB(i).Groups) And (m_DB(i).Groups <> "%")) Then
                        ' is entry member of multiple groups?
                        If (InStr(1, m_DB(i).Groups, ",", vbBinaryCompare) <> 0) Then
                            ' split up multiple groupings
                            grp = Split(m_DB(i).Groups, ",", 2)(0)
                        Else
                            ' no need for special handling...
                            grp = m_DB(i).Groups
                        End If
                    
                        ' has the group already been added or is database in an
                        ' incorrect order?
                        pos = Exists(grp, "Group")
                        ' well, does it exist?
                        If (pos) Then
                            ' make node a child of existing group
                            Set newNode = trvUsers.nodes.Add(trvUsers.nodes(pos).Key, _
                                tvwChild, "Group: " & m_DB(i).Username, m_DB(i).Username, 1)
                        Else
                            ' lets make this guy a parent node for now until we can find
                            ' his real parent.
                            Set newNode = trvUsers.nodes.Add("Database", tvwChild, _
                                "Group: " & m_DB(i).Username, m_DB(i).Username, 1)
                        End If
                    Else
                        Dim K   As Integer
                        Dim bln As Boolean
                    
                        ' Okay, is the group a lone ranger?  Or does he have children
                        ' that are already in the list?
                        For j = LBound(m_DB) To (i - 1)
                            ' we're only concerned with groups, atm.
                            If (StrComp(m_DB(j).Type, "GROUP", vbBinaryCompare) = 0) Then
                                ' we only need to check for groups that are members of
                                ' other groups
                                If (Len(m_DB(j).Groups) And (m_DB(j).Groups <> "%")) Then
                                    ' is entry member of multiple groups?
                                    If (InStr(1, m_DB(j).Groups, ",", vbBinaryCompare) <> 0) Then
                                        ' split up multiple groupings
                                        grp = Split(m_DB(j).Groups, ",", 2)(0)
                                    Else
                                        ' no need for special handling...
                                        grp = m_DB(j).Groups
                                    End If
                                
                                    ' is the current group a member of our group?
                                    If (StrComp(grp, m_DB(i).Username, vbTextCompare) = 0) Then
                                        ' indicate that we've found a match
                                        bln = True
                                        
                                        ' break from loop
                                        Exit For
                                    End If
                                End If
                            End If
                        Next j
                        
                        ' create node
                        Set newNode = trvUsers.nodes.Add("Database", tvwChild, "Group: " & _
                            m_DB(i).Username, m_DB(i).Username, 1)
                    
                        ' is this node a baby's daddy?
                        If (bln) Then
                            ' move node
                            Set trvUsers.nodes(Exists(m_DB(j).Username, "Group")).Parent = _
                                newNode
                        End If

                        ' reset boolean
                        bln = False
                    End If
                    
                    If (Not (newNode Is Nothing)) Then
                        ' change misc. settings
                        With newNode
                            .Tag = "Group"
                        End With
                    End If
                End If
            Next i

            ' loop through database... this time looking for users.
            For i = LBound(m_DB) To UBound(m_DB)
                ' is the entry a user?
                If (StrComp(m_DB(i).Type, "USER", vbTextCompare) = 0) Then
                    ' is the user a member of any groups?
                    If (Len(m_DB(i).Groups) And (m_DB(i).Groups <> "%")) Then
                        ' is entry member of multiple groups?
                        If (InStr(1, m_DB(i).Groups, ",", vbBinaryCompare) <> 0) Then
                            ' split up multiple groupings
                            grp = Split(m_DB(i).Groups, ",", 2)(0)
                        Else
                            ' no need for special handling...
                            grp = m_DB(i).Groups
                        End If
                        
                        If (grp = vbNullString) Then
                            pos = False
                        Else
                            ' search for our group
                            pos = Exists(grp, "Group")
                                
                            ' does our group exist?
                            If (pos) Then
                                ' create user node and move into group
                                Set newNode = trvUsers.nodes.Add(trvUsers.nodes(pos).Key, _
                                    tvwChild, "User: " & m_DB(i).Username, m_DB(i).Username, 3)
                            End If
                        End If
                    End If
                    
                    If (pos = False) Then
                        ' create new user node under root
                        Set newNode = trvUsers.nodes.Add("Database", tvwChild, _
                            "User: " & m_DB(i).Username, m_DB(i).Username, 3)
                    End If
                    
                    If (Not (newNode Is Nothing)) Then
                        ' change misc. settings
                        With newNode
                            .Tag = "User"
                        End With
                    End If
                End If
                
                ' reset our variables
                pos = False
            Next i
            
            ' enable create user button
            btnCreateUser.Enabled = True
            
        Case 2: ' Clans
            ' loop through database searching for clans
            For i = LBound(m_DB) To UBound(m_DB)
                ' is entry a clan?
                If (StrComp(m_DB(i).Type, "CLAN", vbBinaryCompare) = 0) Then
                    ' create new node
                    Set newNode = trvUsers.nodes.Add("Database", tvwChild, _
                        "Clan: " & m_DB(i).Username, m_DB(i).Username, 2)
                    
                    If (Not (newNode Is Nothing)) Then
                         ' change misc. settings
                         With newNode
                             .Tag = "Clan"
                         End With
                     End If
                End If
            Next i

            ' disable create user button
            btnCreateUser.Enabled = False
            
        Case 3: ' Games
            ' loop through database searching for games
            For i = LBound(m_DB) To UBound(m_DB)
                ' is entry a game?
                If (StrComp(m_DB(i).Type, "GAME", vbBinaryCompare) = 0) Then
                    ' create new node
                    Set newNode = trvUsers.nodes.Add("Database", tvwChild, _
                        "Group: " & m_DB(i).Username, m_DB(i).Username, 2)
                    
                    If (Not (newNode Is Nothing)) Then
                        ' change misc. settings
                        With newNode
                            .Tag = "Game"
                        End With
                    End If
                End If
            Next i
            
            ' disable create user button
            btnCreateUser.Enabled = False
    End Select
    
    ' does our treeview contain any nodes?  hope so...
    If (trvUsers.nodes.Count) Then
        ' change misc. settings for root node
        With trvUsers.nodes(1)
            .Expanded = True
            .Image = 1
        End With
        
        ' refresh treeview
        Call trvUsers.Refresh
    End If
    
    Call UpdateGroupListBox
    Call LockGUI
    
    If (blnDuplicateFound = True) Then
        MsgBox "There were one or more duplicate database entries found which could not be loaded.", _
            vbExclamation, "Error"
    End If
    
    Exit Sub
    
ERROR_HANDLER:
    If (Err.Number = 35602) Then
        DB_remove m_DB(i).Username, m_DB(i).Type
        blnDuplicateFound = True
        Resume Next
    End If

    Exit Sub
End Sub

Private Sub LockGUI()
    Dim i As Integer
    
    ' set our default frame caption
    With frmDatabase
        .Caption = "Database"
    End With

    ' disable & clear rank
    txtRank.Enabled = False
    txtRank.Text = vbNullString
    
    ' disable & clear flags
    txtFlags.Enabled = False
    txtFlags.Text = vbNullString
    
    ' loop through listbox and clear selected items
    Call ClearGroupList
    
    ' disable group lists
    lvGroups.Enabled = False
    cbxGroups.Enabled = False
    
    ' disable & clear ban message
    txtBanMessage.Enabled = False
    txtBanMessage.Text = vbNullString
    
    ' reset created on & modified on labels
    lblCreatedOn.Caption = "(not applicable)"
    lblModifiedOn.Caption = "(not applicable)"
    
    ' reset created by & modified by labels
    lblCreatedBy.Caption = vbNullString
    lblModifiedBy.Caption = vbNullString
    
    ' disable entry buttons
    btnSave(1).Enabled = False
    btnDelete.Enabled = False
End Sub

Private Sub ClearGroupList()
    Dim i As Integer
    
    cbxGroups.ListIndex = 0

    ' loop through listbox and clear selected items
    For i = 1 To lvGroups.ListItems.Count
        With lvGroups.ListItems(i)
            .Checked = False
            .Ghosted = False
        End With
    Next i
End Sub

Private Sub UnlockGUI()
    Dim i As Integer

    ' enable rank field
    txtRank.Enabled = True

    ' enable flags field
    txtFlags.Enabled = True
    
    ' enable ban message field
    txtBanMessage.Enabled = True
    
    ' disable entry save button
    btnSave(1).Enabled = False
    
    ' enable entry delete button
    btnDelete.Enabled = True
    
    ' enable group lists
    lvGroups.Enabled = True
    cbxGroups.Enabled = True
End Sub

' handle node collapse
Private Sub trvUsers_Collapse(ByVal node As node)
    ' refresh tree view
    Call trvUsers.Refresh
End Sub

' handle node expand
Private Sub trvUsers_Expand(ByVal node As node)
    ' refresh tree view
    Call trvUsers.Refresh
End Sub

Private Sub trvUsers_NodeClick(ByVal node As MSComctlLib.node)
    Dim tmp As udtGetAccessResponse
    Dim i   As Integer
    
    If (node Is Nothing) Then
        Exit Sub
    End If
    
    Call LockGUI
    
    m_group_index = -1

    If (node.Index > 1) Then
        Call ClearGroupList
    
        frmDatabase.Caption = node.Text
        
        tmp = GetAccess(node.Text, node.Tag)
        
        ' does entry have a rank?
        If (tmp.Rank > 0) Then
            ' write rank to text box
            txtRank.Text = tmp.Rank
        Else
            ' clear rank from text box
            txtRank.Text = vbNullString
        End If
        
        ' clear flags from text box
        txtFlags.Text = tmp.Flags
        
        If ((tmp.AddedBy = vbNullString) Or (tmp.AddedBy = "%")) Then
            lblCreatedOn = "unknown"
            lblCreatedBy = "by unknown"
        Else
            lblCreatedOn = tmp.AddedOn & " Local Time"
            lblCreatedBy = "by " & tmp.AddedBy
        End If
        
        If ((tmp.ModifiedBy = vbNullString) Or (tmp.ModifiedBy = "%")) Then
            lblModifiedOn = "unknown"
            lblModifiedBy = "by unknown"
        Else
            lblModifiedOn = tmp.ModifiedOn & " Local Time"
            lblModifiedBy = "by " & tmp.ModifiedBy
        End If
        
        ' is entry a member of a group?
        If (Len(tmp.Groups) And (tmp.Groups <> "%")) Then
            Dim Splt() As String
            Dim j      As Integer
        
            ' is entry a member of multiple groups?
            If (InStr(1, tmp.Groups, ",", vbBinaryCompare) <> 0) Then
                ' store working copy of group memberships, splitting up
                ' multiple groupings by the ',' delimiter.
                Splt() = Split(tmp.Groups, ",")
            Else
                ' redefine array size to store group name
                ReDim Preserve Splt(0)
                
                ' store working copy of group membership
                Splt(0) = tmp.Groups
            End If
            
            ' loop through entry's group memberships
            For i = LBound(Splt) To UBound(Splt)
                If (i = 0) Then
                    ' loop through our group listing, checking to see if we have any
                    ' matches (since the entry is a member of a group, we better!)
                    For j = 1 To lvGroups.ListItems.Count
                        ' is entry a member of group?
                        If (StrComp(Splt(i), cbxGroups.List(j), vbTextCompare) = 0) Then
                            cbxGroups.ListIndex = j
                            
                            Exit For
                        End If
                    Next j
                Else
                    ' loop through our group listing, checking to see if we have any
                    ' matches (since the entry is a member of a group, we better!)
                    For j = 1 To lvGroups.ListItems.Count
                        If (StrComp(Splt(i), lvGroups.ListItems(j), vbTextCompare) = 0) Then
                            ' select group if entry is a member
                            lvGroups.ListItems(j).Checked = True
                        End If
                    Next j
                End If
            Next i
        End If
        
        If ((tmp.BanMessage <> vbNullString) And (tmp.BanMessage <> "%")) Then
            txtBanMessage.Text = tmp.BanMessage
        End If
        
        Call UnlockGUI
    End If
    
    Set trvUsers.SelectedItem = node

    ' refresh tree view
    Call trvUsers.Refresh
End Sub

Private Sub trvUsers_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    If (Button = vbLeftButton) Then
        Set trvUsers.SelectedItem = trvUsers.HitTest(x, y)
        Call trvUsers_NodeClick(trvUsers.SelectedItem)
    End If
End Sub

Private Sub trvUsers_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    If (Button = vbRightButton) Then
        Dim gAcc As udtGetAccessResponse
        If (Not (trvUsers.SelectedItem Is Nothing)) Then
            If (trvUsers.SelectedItem.Index > 1) Then
                If (StrComp(trvUsers.SelectedItem.Tag, "Group", vbTextCompare) = 0) Then
                    mnuRename.Enabled = True
                Else
                    mnuRename.Enabled = False
                End If
                
                mnuDelete.Enabled = True
            Else
                mnuRename.Enabled = False
                mnuDelete.Enabled = False
            End If
            
            Call Me.PopupMenu(mnuContext)
        End If
    End If
End Sub

Private Sub trvUsers_OLEDragOver(Data As MSComctlLib.DataObject, Effect As Long, Button As Integer, _
    Shift As Integer, x As Single, y As Single, State As Integer)
    
    Set trvUsers.DropHighlight = trvUsers.HitTest(x, y)
End Sub

Private Sub trvUsers_OLEDragDrop(Data As MSComctlLib.DataObject, Effect As Long, Button As Integer, _
    Shift As Integer, x As Single, y As Single)
    
    On Error GoTo ERROR_HANDLER
    
    Dim nodePrev As node
    Dim nodeNow  As node

    Dim strKey   As String
    Dim res      As Integer
    Dim i        As Integer
    Dim found    As Integer

    If (Data.GetFormat(15) = True) Then
        With frmDBType
            .setFilePath Data.Files(1)
            .Show
        End With
    Else
        Set nodeNow = trvUsers.DropHighlight
        
        Set nodePrev = trvUsers.SelectedItem
            
        If (nodeNow.Index = 1) Then
            For i = LBound(m_DB) To UBound(m_DB)
                If (StrComp(m_DB(i).Username, nodePrev.Text, vbTextCompare) = 0) Then
                    If (StrComp(m_DB(i).Type, nodePrev.Tag, vbTextCompare) = 0) Then
                        If ((Len(m_DB(i).Groups) > 0) And (m_DB(i).Groups <> "%")) Then
                            Set nodePrev.Parent = nodeNow
                        End If
                        
                        m_DB(i).Groups = vbNullString
                        Exit For
                    End If
                End If
            Next i
        Else
            If (Not nodePrev.Index = 1) Then
                If (Not StrComp(nodeNow.Tag, "Group", vbTextCompare) = 0) Then
                    Set nodeNow = nodeNow.Parent
                    
                    If (nodeNow.Index = 1) Then
                        Set trvUsers.DropHighlight = nodeNow
                    
                        Call trvUsers_OLEDragDrop(Data, Effect, Button, Shift, x, y)
                        Exit Sub
                    End If
                End If
            
                If (IsInGroup(nodePrev.Text, nodeNow.Text) = False) Then
                    For i = LBound(m_DB) To UBound(m_DB)
                        If (StrComp(m_DB(i).Username, nodePrev.Text, vbTextCompare) = 0) Then
                            If (StrComp(m_DB(i).Type, nodePrev.Tag, vbTextCompare) = 0) Then
                                m_DB(i).Groups = nodeNow.Text
                                Exit For
                            End If
                        End If
                    Next i
                    
                    Set nodePrev.Parent = nodeNow
                End If
            End If
        End If
        
        Call trvUsers_NodeClick(nodePrev)
        Set trvUsers.DropHighlight = Nothing
    End If
    
    Exit Sub

ERROR_HANDLER:
    ' potential cycle introduction error
    If (Err.Number = 35614) Then
        MsgBox Err.description, vbCritical, "Error"
    End If
    
    Set trvUsers.DropHighlight = Nothing
    
    Exit Sub
End Sub

Private Sub trvUsers_KeyDown(KeyCode As Integer, Shift As Integer)
    If (KeyCode = vbKeyDelete) Then
        If (Not (trvUsers.SelectedItem Is Nothing)) Then
            Call HandleDeleteEvent(trvUsers.SelectedItem)
        End If
    End If
End Sub

Private Sub trvUsers_BeforeLabelEdit(Cancel As Integer)
    ' is this a new entry that requires a name?
    If (m_new_entry) Then
        ' break from function
        Exit Sub
    End If

    ' is entry a group? if not, disallow edit.
    If (Not StrComp(trvUsers.SelectedItem.Tag, "Group", vbTextCompare) = 0) Then
        ' disallow editing of entry label
        Cancel = 1
    End If
End Sub

Private Sub trvUsers_AfterLabelEdit(Cancel As Integer, NewString As String)
    Dim i As Integer
    
    If (trvUsers.SelectedItem Is Nothing) Then
        Exit Sub
    End If
    
    If ((NewString = vbNullString) Or (Len(NewString) > 30)) Then
        MsgBox "The specified name is of an invalid Length."
        Call trvUsers.StartLabelEdit
        
        Cancel = 1
    
        Exit Sub
    End If
    
    If (Not InStr(1, NewString, Space$(1), vbBinaryCompare) = 0) Or _
       (Not InStr(1, NewString, "%", vbBinaryCompare) = 0) Then
    
        MsgBox "The specified name contains one or more invalid characters."
        
        Call trvUsers.StartLabelEdit
        
        Cancel = 1
    
        Exit Sub
    End If
    
    If (m_new_entry) Then
        If (GetAccess(NewString, trvUsers.SelectedItem.Tag).Username = vbNullString) Then
            With m_DB(UBound(m_DB))
                .Username = NewString
            End With
            
            If (StrComp(m_DB(UBound(m_DB)).Type, "Group", vbTextCompare) = 0) Then
                Call UpdateGroupListBox
            End If
            
            m_new_entry = False
        Else
            MsgBox "There is already an entry of this type matching the specified name."
            
            Call trvUsers.StartLabelEdit
            
            Cancel = 1
        End If
    Else
        For i = LBound(m_DB) To UBound(m_DB)
            If (StrComp(trvUsers.SelectedItem.Text, m_DB(i).Username, vbTextCompare) = 0) Then
                If (StrComp(trvUsers.SelectedItem.Tag, m_DB(i).Type, vbTextCompare) = 0) Then
                    m_DB(i).Username = NewString
            
                    Exit For
                End If
            End If
        Next i
        
        If (StrComp(m_DB(i).Type, "Group", vbTextCompare) = 0) Then
            For i = LBound(m_DB) To UBound(m_DB)
                If ((Len(m_DB(i).Groups) > 0) And (Not m_DB(i).Groups = "%")) Then
                    Dim Splt() As String
                    Dim j      As Integer
                
                    If (Not InStr(1, m_DB(i).Groups, ",", vbTextCompare) = 0) Then
                        Splt() = Split(m_DB(i).Groups, ",")
                    Else
                        ReDim Preserve Splt(0)
                        
                        Splt(0) = m_DB(i).Groups
                    End If
                    
                    For j = LBound(Splt) To UBound(Splt)
                        If (StrComp(Splt(j), trvUsers.SelectedItem.Text, vbTextCompare) = 0) Then
                            Splt(j) = NewString
                        End If
                    Next j
                    
                    m_DB(i).Groups = Join(Splt(), ",")
                End If
            Next i
        End If
    End If
End Sub

Private Function IsInGroup(ByVal Username As String, ByVal GroupName As String) As Boolean
    Dim i      As Integer
    Dim j      As Integer
    Dim Splt() As String
    
    For i = LBound(m_DB) To UBound(m_DB)
        If (StrComp(m_DB(i).Username, Username, vbTextCompare) = 0) Then
            If ((Len(m_DB(i).Groups) > 0) And (Not m_DB(i).Groups = "%")) Then
                If (Not InStr(1, m_DB(i).Groups, "%", vbBinaryCompare) = 0) Then
                    Splt() = Split(m_DB(i).Groups, "%")
                Else
                    ReDim Splt(0)
                    Splt(0) = m_DB(i).Groups
                End If
                
                For j = LBound(Splt) To UBound(Splt)
                    If (StrComp(GroupName, Splt(j), vbTextCompare) = 0) Then
                        IsInGroup = True
                        
                        Exit Function
                    End If
                Next j
            End If
        End If
    Next i
End Function

Private Sub HandleDeleteEvent(ByRef NodeToDelete As node)
    Dim temp As node
    
    Set temp = NodeToDelete

    If (temp Is Nothing) Then
        Exit Sub
    End If

    If (temp.Index > 1) Then
        Dim response As Integer
        Dim isGroup  As Boolean
        
        isGroup = (StrComp(temp.Tag, "Group", vbTextCompare) = 0)
    
        If (isGroup) Then
            response = MsgBox("Are you sure you wish to delete this group and " & _
                "all of its members?", vbYesNo + vbInformation, "Information")
        End If
        
        If ((isGroup = False) Or ((isGroup) And (response = vbYes))) Then
            Call DB_remove(temp.Text, temp.Tag)
            
            If (temp.Next Is Nothing) Then
                If (temp.Previous Is Nothing) Then
                    trvUsers.nodes(temp.Parent.Index).Checked = True
                Else
                    trvUsers.nodes(temp.Previous.Index).Checked = True
                End If
            Else
                trvUsers.nodes(temp.Next.Index).Checked = True
            End If
            
            Call trvUsers.nodes.Remove(temp.Index)
            
            Call trvUsers_NodeClick(trvUsers.SelectedItem)
            
            Call UpdateGroupListBox
        End If
    End If
End Sub

Private Sub UpdateGroupListBox()
    Dim i As Integer

    ' clear group selection listing
    Call lvGroups.ListItems.Clear
    
    Call cbxGroups.Clear
    
    Call cbxGroups.AddItem("[none]", 0)

    ' go through group listing
    For i = LBound(m_DB) To UBound(m_DB)
        If (StrComp(m_DB(i).Type, "Group", vbTextCompare) = 0) Then
            ' add group to group selection listbox
            Call lvGroups.ListItems.Add(, , m_DB(i).Username)
            
            Call cbxGroups.AddItem(m_DB(i).Username)
        End If
    Next i
End Sub

Private Function Exists(ByVal nodeName As String, Optional Tag As String = vbNullString) As Integer
    Dim i As Integer
    
    For i = 1 To trvUsers.nodes.Count
        If (StrComp(trvUsers.nodes(i).Text, nodeName, vbTextCompare) = 0) Then
            If (LenB(Tag) > 0) Then
                If (StrComp(trvUsers.nodes(i).Tag, Tag, vbTextCompare) = 0) Then
                    Exists = i
                    Exit Function
                End If
            Else
                Exists = i
            
                Exit Function
            End If
        End If
    Next i
    
    Exists = False
End Function

Private Sub txtBanMessage_Change()
    ' enable entry save button
    btnSave(1).Enabled = True
End Sub

Private Sub txtFlags_KeyPress(KeyAscii As Integer)
    
    Const AZ As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    ' disallow entering space
    If (KeyAscii = 32) Then KeyAscii = 0
    
    ' if key is A-Z, then make uppercase
    If (InStr(1, AZ, Chr$(KeyAscii), vbTextCompare) > 0) Then
        If (BotVars.CaseSensitiveFlags = False) Then
            If (KeyAscii > 90) Then ' lowercase if greater than "Z"
                KeyAscii = Asc(UCase(Chr(KeyAscii)))
            End If
        End If
    ' else disallow entering that character (if not a control character)
    ElseIf (KeyAscii > 32) Then
        KeyAscii = 0
    End If
    
End Sub

Private Sub txtFlags_Change()
    ' enable entry save button
    btnSave(1).Enabled = True
End Sub

Private Sub txtRank_KeyPress(KeyAscii As Integer)
    Const n09 As String = "0123456789"
    
    ' disallow entering space
    If (KeyAscii = 32) Then KeyAscii = 0
    
    ' if key is not 0-9, disallow entering that character (if not a control character)
    If (InStr(1, n09, Chr$(KeyAscii), vbTextCompare) = 0 And KeyAscii > 32) Then
        KeyAscii = 0
    End If
    
End Sub

Private Sub txtRank_Change()
    Dim selStart As Long
    
    If (Val(txtRank.Text) > 200) Then
        With txtRank
            selStart = .selStart
            .Text = "200"
            .selStart = selStart
        End With
    End If

    ' enable entry save button
    btnSave(1).Enabled = True
End Sub

Private Function GetAccess(ByVal Username As String, Optional dbType As String = _
    vbNullString) As udtGetAccessResponse
    
    Dim i   As Integer
    Dim bln As Boolean
    
    dbType = UCase$(dbType)

    For i = LBound(m_DB) To UBound(m_DB)
        If (StrComp(m_DB(i).Username, Username, vbTextCompare) = 0) Then
            If (Len(dbType) > 0) Then
                If (StrComp(m_DB(i).Type, dbType, vbTextCompare) = 0) Then
                    bln = True
                End If
            Else
                bln = True
            End If
                
            If (bln = True) Then
                With GetAccess
                    .Username = m_DB(i).Username
                    .Rank = m_DB(i).Rank
                    .Flags = m_DB(i).Flags
                    .AddedBy = m_DB(i).AddedBy
                    .AddedOn = m_DB(i).AddedOn
                    .ModifiedBy = m_DB(i).ModifiedBy
                    .ModifiedOn = m_DB(i).ModifiedOn
                    .Type = m_DB(i).Type
                    .Groups = m_DB(i).Groups
                    .BanMessage = m_DB(i).BanMessage
                End With
                
                Exit Function
            End If
        End If
        
        bln = False
    Next i

    GetAccess.Rank = -1
End Function

Public Function DB_remove(ByVal entry As String, Optional ByVal dbType As String = _
    vbNullString) As Boolean
    
    On Error GoTo ERROR_HANDLER

    Dim i     As Integer
    Dim found As Boolean
    
    dbType = UCase$(dbType)
    
    For i = LBound(m_DB) To UBound(m_DB)
        If (StrComp(m_DB(i).Username, entry, vbTextCompare) = 0) Then
            Dim bln As Boolean
        
            If (Len(dbType)) Then
                If (StrComp(m_DB(i).Type, dbType, vbTextCompare) = 0) Then
                    bln = True
                End If
            Else
                bln = True
            End If
            
            If (bln) Then
                found = True
                
                Exit For
            End If
        End If
        
        bln = False
    Next i
    
    If (found) Then
        Dim bak As udtDatabase
        
        Dim j   As Integer
        
        bak = m_DB(i)

        ' we aren't removing the last array
        ' element, are we?
        If (UBound(m_DB) = 0) Then
            ReDim m_DB(0)
            
            With m_DB(0)
                .Username = vbNullString
                .Flags = vbNullString
                .Rank = 0
                .Groups = vbNullString
                .AddedBy = vbNullString
                .ModifiedBy = vbNullString
                .AddedOn = Now
                .ModifiedOn = Now
            End With
        Else
            For j = i To UBound(m_DB) - 1
                m_DB(j) = m_DB(j + 1)
            Next j
            
            ' redefine array size
            ReDim Preserve m_DB(UBound(m_DB) - 1)
            
            ' if we're removing a group, we need to also fix our
            ' group memberships, in case anything is broken now
            If (StrComp(bak.Type, "GROUP", vbBinaryCompare) = 0) Then
                Dim res As Boolean
            
                ' if we remove a user from the database during the
                ' execution of the inner loop, we have to reset our
                ' inner loop variables, otherwise we create errors
                ' due to incorrect database indexes.  Because of this,
                ' we have to dual-loop until our inner loop runs out
                ' of matching users.
                Do
                    ' reset loop variable
                    res = False
                
                    ' loop through database checking for users that
                    ' were members of the group that we just removed
                    For i = LBound(m_DB) To UBound(m_DB)
                        If (Len(m_DB(i).Groups) And m_DB(i).Groups <> "%") Then
                            If (InStr(1, m_DB(i).Groups, ",", vbBinaryCompare) <> 0) Then
                                Dim Splt()     As String
                                Dim innerfound As Boolean
                                
                                Splt() = Split(m_DB(i).Groups, ",")
                                
                                For j = LBound(Splt) To UBound(Splt)
                                    If (StrComp(bak.Username, Splt(j), vbTextCompare) = 0) Then
                                        innerfound = True
                                    
                                        Exit For
                                    End If
                                Next j
                            
                                If (innerfound) Then
                                    Dim K As Integer
                                    
                                    For K = (j + 1) To UBound(Splt)
                                        Splt(K - 1) = Splt(K)
                                    Next K
                                    
                                    ReDim Preserve Splt(UBound(Splt) - 1)
                                    
                                    m_DB(i).Groups = Join(Splt(), vbNullString)
                                End If
                            Else
                                If (StrComp(bak.Username, m_DB(i).Groups, vbTextCompare) = 0) Then
                                    res = DB_remove(m_DB(i).Username, m_DB(i).Type)
                                    
                                    Exit For
                                End If
                            End If
                        End If
                    Next i
                Loop While (res)
            End If
        End If
        
        ' commit modifications
        'Call WriteDatabase(GetFilePath("Users.txt"))
        
        DB_remove = True
        
        Exit Function
    End If
    
    DB_remove = False
    
    Exit Function
    
ERROR_HANDLER:
    Call frmChat.AddChat(RTBColors.ErrorMessageText, _
        "Error (#" & Err.Number & "): " & Err.description & " in DB_remove().")
        
    DB_remove = False
    
    Exit Function
End Function
