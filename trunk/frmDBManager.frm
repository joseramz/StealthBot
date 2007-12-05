VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmDBManager 
   Caption         =   "Database Manager"
   ClientHeight    =   5415
   ClientLeft      =   60
   ClientTop       =   750
   ClientWidth     =   7215
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
   ScaleHeight     =   5415
   ScaleWidth      =   7215
   StartUpPosition =   1  'CenterOwner
   Begin MSComctlLib.ImageList icons 
      Left            =   360
      Top             =   3720
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   2
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmDBManager.frx":0000
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmDBManager.frx":015A
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.CommandButton btnCreateGroup 
      Caption         =   "Create Group"
      Height          =   375
      Left            =   2047
      TabIndex        =   12
      Top             =   4550
      Width           =   1943
   End
   Begin MSComctlLib.TreeView trvUsers 
      Height          =   4350
      Left            =   120
      TabIndex        =   10
      Top             =   105
      Width           =   3850
      _ExtentX        =   6800
      _ExtentY        =   7673
      _Version        =   393217
      HideSelection   =   0   'False
      Indentation     =   575
      LabelEdit       =   1
      LineStyle       =   1
      Sorted          =   -1  'True
      Style           =   7
      ImageList       =   "icons"
      Appearance      =   1
      OLEDragMode     =   1
   End
   Begin VB.TextBox txtFlags 
      BackColor       =   &H00993300&
      Enabled         =   0   'False
      ForeColor       =   &H00FFFFFF&
      Height          =   285
      Left            =   5640
      MaxLength       =   25
      TabIndex        =   5
      Top             =   580
      Width           =   1215
   End
   Begin VB.TextBox txtRank 
      BackColor       =   &H00993300&
      Enabled         =   0   'False
      ForeColor       =   &H00FFFFFF&
      Height          =   285
      Left            =   4320
      MaxLength       =   25
      TabIndex        =   3
      Top             =   580
      Width           =   1215
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancel"
      Height          =   255
      Index           =   0
      Left            =   4920
      TabIndex        =   2
      Top             =   5040
      Width           =   855
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Apply and Cl&ose"
      Height          =   255
      Index           =   0
      Left            =   5760
      TabIndex        =   1
      Top             =   5040
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Create User"
      Height          =   375
      Index           =   3
      Left            =   110
      TabIndex        =   13
      Top             =   4550
      Width           =   1943
   End
   Begin VB.Frame frmDatabase 
      Caption         =   "Database"
      Height          =   4920
      Left            =   4080
      TabIndex        =   0
      Top             =   8
      Width           =   3025
      Begin VB.ListBox lstGroups 
         Enabled         =   0   'False
         Height          =   3180
         Left            =   240
         MultiSelect     =   1  'Simple
         TabIndex        =   11
         Top             =   1275
         Width           =   2535
      End
      Begin VB.CommandButton cmdCancel 
         Caption         =   "Delete"
         Enabled         =   0   'False
         Height          =   255
         Index           =   1
         Left            =   1080
         TabIndex        =   9
         Top             =   4530
         Width           =   855
      End
      Begin VB.CommandButton cmdSave 
         Caption         =   "Save"
         Height          =   255
         Index           =   1
         Left            =   1930
         TabIndex        =   8
         Top             =   4530
         Width           =   855
      End
      Begin VB.Label Label1 
         Caption         =   "Group(s):"
         Height          =   255
         Index           =   3
         Left            =   240
         TabIndex        =   7
         Top             =   1030
         Width           =   1215
      End
      Begin VB.Label Label1 
         Caption         =   "Flags:"
         Height          =   255
         Index           =   2
         Left            =   1560
         TabIndex        =   6
         Top             =   320
         Width           =   1215
      End
      Begin VB.Label Label1 
         Caption         =   "Rank (1 - 200):"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   4
         Top             =   320
         Width           =   1215
      End
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
      Begin VB.Menu mnuOpenDB 
         Caption         =   "Open Database"
      End
   End
End
Attribute VB_Name = "frmDBManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_dragging As Boolean ' ...
Private m_selnode  As Node    ' ...

Private Sub btnCreateGroup_Click()
    Call frmGroupSelection.Show(vbModal, Me)
End Sub

Private Sub Form_Load()
    Dim i      As Integer ' ...
    Dim Splt() As String  ' ...
    Dim j      As Integer ' ...
    Dim Pos    As Integer ' ...
    
    Call trvUsers.Nodes.Clear

    If (DB(0).Username = vbNullString) Then
        Call LoadDatabase
    End If
    
    Call trvUsers.Nodes.Add(, , "Database", "Database")
    
    For i = LBound(DB) To UBound(DB)
        If (StrComp(DB(i).Type, "GROUP", vbBinaryCompare) = 0) Then
            If (Len(DB(i).Groups) And (DB(i).Groups <> "%")) Then
                If (InStr(1, DB(i).Groups, ",", vbBinaryCompare) <> 0) Then
                    Splt() = Split(DB(i).Groups, ",")
                Else
                    ReDim Preserve Splt(0)
                    
                    Splt(0) = DB(i).Groups
                End If
                
                For j = LBound(Splt) To UBound(Splt)
                    Pos = Exists(Splt(j))
                    
                    If (Pos) Then
                        Call trvUsers.Nodes.Add(trvUsers.Nodes(Pos).Key, _
                            tvwChild, DB(i).Username, DB(i).Username, 2)
                    End If
                Next j
            Else
                If (Not (Exists(DB(i).Username))) Then
                    Call trvUsers.Nodes.Add("Database", tvwChild, DB(i).Username, _
                        DB(i).Username, 2)
                End If
            End If
        End If
    Next i
    
    If (trvUsers.Nodes.Count > 1) Then
        For i = 2 To trvUsers.Nodes.Count
            Call lstGroups.AddItem(trvUsers.Nodes(i).text)
        Next i
    End If
    
    For i = LBound(DB) To UBound(DB)
        If ((StrComp(DB(i).Type, "USER", vbBinaryCompare) = 0) Or _
            (StrComp(DB(i).Type, "CLAN", vbBinaryCompare) = 0) Or _
            (StrComp(DB(i).Type, "GAME", vbBinaryCompare) = 0)) Then

            If (Len(DB(i).Groups) And (DB(i).Groups <> "%")) Then
                If (InStr(1, DB(i).Groups, ",", vbBinaryCompare) <> 0) Then
                    Splt() = Split(DB(i).Groups, ",")
                Else
                    ReDim Preserve Splt(0)
                    
                    Splt(0) = DB(i).Groups
                End If
                
                For j = LBound(Splt) To UBound(Splt)
                    Pos = Exists(Splt(j))
                    
                    If (Pos) Then
                        Call trvUsers.Nodes.Add(trvUsers.Nodes(Pos).Key, _
                            tvwChild, DB(i).Username, DB(i).Username)
                    End If
                Next j
            Else
                Call trvUsers.Nodes.Add("Database", tvwChild, , DB(i).Username)
            End If
            
            If (StrComp(DB(i).Type, "GAME", vbBinaryCompare) = 0) Then
                trvUsers.Nodes(i + 1).Image = 1
            Else
                
            End If
        End If
    Next i
    
    With trvUsers.Nodes(1)
        .Expanded = True
        .Image = 2
    End With
End Sub

Private Sub Label3_Click()

End Sub

Private Sub trvUsers_NodeClick(ByVal Node As MSComctlLib.Node)
    Dim tmp As udtGetAccessResponse ' ...
    
    Dim i   As Integer ' ...
    
    Set m_selnode = Node
    
    ' deselect groups
    For i = 0 To (lstGroups.ListCount - 1)
        lstGroups.Selected(i) = False
    Next i
    
    ' disable changing of record type
    'For i = 0 To 3
    '    recType(i).Enabled = False
    'Next i
    
    ' disable changing of record name
    'txtName.Enabled = False
    
    ' grab entry from database
    tmp = GetAccess(trvUsers.SelectedItem.text)
    
    'Select Case (UCase$(tmp.Type))
    '    Case "USER":  recType(0).Value = True
    '    Case "CLAN":  recType(1).Value = True
    '    Case "GAME":  recType(2).Value = True
    '    Case "GROUP": recType(3).Value = True
    'End Select
    
    If (Node.Index = 1) Then
        frmDatabase.Caption = "Database"
        
        txtRank.Enabled = False
        txtFlags.Enabled = False
        lstGroups.Enabled = False
    Else
        If (tmp.Type = "USER") Then
            frmDatabase.Caption = "User: " & _
                tmp.Username
        ElseIf (tmp.Type = "CLAN") Then
            frmDatabase.Caption = "Clan: " & _
                tmp.Username
        ElseIf (tmp.Type = "GAME") Then
            frmDatabase.Caption = "Game: " & _
                tmp.Username
        ElseIf (tmp.Type = "GROUP") Then
            frmDatabase.Caption = "Group: " & _
                tmp.Username
        Else
            frmDatabase.Caption = tmp.Username
        End If
        
        txtRank.Enabled = True
        txtFlags.Enabled = True
        lstGroups.Enabled = True
    End If
    
    If (tmp.access > 0) Then
        txtRank.text = tmp.access
    Else
        txtRank.text = vbNullString
    End If
    
    txtFlags.text = tmp.Flags
    
    If (Len(tmp.Groups) And (tmp.Groups <> "%")) Then
        Dim Splt() As String  ' ...
        Dim j      As Integer ' ...
    
        If (InStr(1, tmp.Groups, ",", vbBinaryCompare) <> 0) Then
            Splt() = Split(DB(i).Groups, ",")
        Else
            ReDim Preserve Splt(0)
            
            Splt(0) = tmp.Groups
        End If
        
        For i = LBound(Splt) To UBound(Splt)
            For j = 0 To (lstGroups.ListCount - 1)
                If (StrComp(Splt(i), lstGroups.List(j), vbTextCompare) = 0) Then
                    lstGroups.Selected(j) = True
                End If
            Next j
        Next i
    End If
End Sub

Private Sub trvUsers_MouseMove(Button As Integer, Shift As Integer, X As Single, _
    Y As Single)

    If (Button = vbLeftButton) Then
        m_dragging = True
        
        Call trvUsers.Drag(vbBeginDrag)
    End If
End Sub

Private Sub trvUsers_DragOver(ByRef Source As Control, ByRef X As Single, _
    ByRef Y As Single, ByRef State As Integer)
    
    If (m_dragging) Then
        If (Source.name = "trvUsers") Then
            Set trvUsers.DropHighlight = trvUsers.HitTest(X, Y)
        End If
    End If
End Sub

Private Sub trvUsers_DragDrop(ByRef Source As Control, ByRef X As Single, _
    ByRef Y As Single)
    
    If (m_dragging) Then
        If (Source.name = "trvUsers") Then
            If (Not (trvUsers.DropHighlight Is Nothing)) Then
                Dim selnow  As udtGetAccessResponse ' ...
                Dim selprev As udtGetAccessResponse ' ...
                Dim gAcc    As udtGetAccessResponse ' ...
                
                Dim res     As Integer ' ...
                Dim i       As Integer ' ...
                Dim found   As Integer ' ...
                
                If (trvUsers.DropHighlight.Index = 1) Then
                    selprev = GetAccess(trvUsers.SelectedItem.text)
                    
                    If (Len(selprev.Groups) And (selprev.Groups <> "%")) Then
                        For i = LBound(DB) To UBound(DB)
                            If (StrComp(selprev.Username, DB(i).Username, vbBinaryCompare) = 0) Then
                                DB(i).Groups = vbNullString
                            End If
                        Next i
                        
                        ' ...
                        gAcc = GetCumulativeAccess(selprev.Username)
                        
                        Call trvUsers.Nodes.Add(trvUsers.DropHighlight.text, tvwChild, , _
                            selprev.Username)
                            
                        Call trvUsers.Nodes.Remove(trvUsers.SelectedItem.Index)
                        
                        If (gAcc.access = 0) Then
                            found = Exists(selprev.Username)
                            
                            If (found > 0) Then
                                With trvUsers.Nodes(found)
                                    .ForeColor = vbRed
                                    .Tag = "This entry is currently marked for deletetion."
                                End With
                            End If
                        End If
                    End If
                Else
                    If (trvUsers.SelectedItem.Index <> 1) Then
                        selnow = GetAccess(trvUsers.DropHighlight.text)
                        selprev = GetAccess(trvUsers.SelectedItem.text)
                        
                        If (selnow.Username <> selprev.Username) Then
                            If (StrComp(selnow.Type, "GROUP", vbBinaryCompare) = 0) Then
                                For i = LBound(DB) To UBound(DB)
                                    If (StrComp(selprev.Username, DB(i).Username, vbBinaryCompare) = 0) Then
                                        DB(i).Groups = trvUsers.DropHighlight.text
                                    End If
                                Next i
                                
                                ' ...
                                gAcc = GetCumulativeAccess(selprev.Username)
                                
                                Call trvUsers.Nodes.Add(trvUsers.DropHighlight.text, tvwChild, , _
                                    selprev.Username)
    
                                Call trvUsers.Nodes.Remove(trvUsers.SelectedItem.Index)
                                
                                If (gAcc.access = 0) Then
                                    found = Exists(selprev.Username)
                                    
                                    If (found > 0) Then
                                        With trvUsers.Nodes(found)
                                            .ForeColor = vbRed
                                            .Tag = "This entry is currently marked for deletetion."
                                        End With
                                    End If
                                End If
                            End If
                        End If
                    End If
                End If
            End If
            
            Set m_selnode = Nothing
            
            Set trvUsers.DropHighlight = Nothing
            
            m_dragging = False
        End If
    End If
End Sub

Private Function Exists(ByVal nodeName As String) As Integer
    Dim i As Integer ' ...
    
    For i = 1 To trvUsers.Nodes.Count
        If (StrComp(trvUsers.Nodes(i).text, nodeName, vbTextCompare) = 0) Then
            Exists = i
        
            Exit Function
        End If
    Next i
    
    Exists = False
End Function

Private Function GetIconIndex(ByVal name As String) As Integer
    ' ...
End Function
