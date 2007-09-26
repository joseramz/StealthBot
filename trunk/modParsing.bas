Attribute VB_Name = "modParsing"
Option Explicit

Public Const COLOR_BLUE2 = 12092001

Public Sub SendHeader()
    frmChat.sckBNet.SendData ChrW(1)
End Sub

Sub AddChat(ByVal sColor As String, ByVal sMsg As String)
    frmChat.AddChat sColor, sMsg
End Sub

Public Sub BNCSParsePacket(ByVal PacketData As String)
    Dim pD As clsPacketDebuffer     ' Packet debuffer object
    Dim PacketLen   As Long         ' Length of the packet minus the header
    Dim PacketID    As Byte         ' Battle.net packet ID
    Dim s           As String       ' Temporary string
    Dim l           As Long         ' Temporary long
    Dim EventID     As Long         ' 0x0F packet Event ID
    Dim UserFlags   As Long         ' 0x0F user's flags
    Dim UserPing    As Long         ' 0x0F user's ping
    Dim Username    As String       ' Misc username storage
    Dim s2          As String       ' Temporary string
    Dim s3          As String       ' Temporary string
    Dim ClanTag     As String       ' User clan tag
    Dim Product     As String       ' User product
    Dim W3Icon      As String       ' Warcraft III icon code
    Dim b           As Boolean      ' Temporary bool
    
    Static ServerToken As Long      ' Server token used in various packets
    
    '--------------
    '| Initialize |
    '--------------
    Set pD = New clsPacketDebuffer
    PacketLen = Len(PacketData) - 4
    
    '###########################################################################
    
    If PacketLen > 0 Then
        ' Start packet debuffer
        pD.DebuffPacket Mid$(PacketData, 5)
        ' Get packet ID
        PacketID = Asc(Mid$(PacketData, 2, 1))
        
        If MDebug("all") Then
            frmChat.AddChat COLOR_BLUE, "BNET RECV 0x" & Hex(PacketID)
        End If
        
        ' Added 2007-06-08 for a packet logging menu feature to aid tech support
        LogPacketRaw stBNCS, StoC, PacketID, PacketLen, PacketData
        
        '--------------
        '| Parse      |
        '--------------
        
        Select Case PacketID
            '###########################################################################
            Case &HB        ' These two events added so that debug-mode does not
            Case &H4C       ' spit data to the user!
            
            '###########################################################################
            Case &HA 'SID_ENTERCHAT
                s = pD.DebuffNTString
                CurrentUsername = s
                Call Event_LoggedOnAs(s, BotVars.Product)
            
            '###########################################################################
            Case &HF 'SID_CHATEVENT
                ' User information
                EventID = pD.DebuffDWORD
                UserFlags = pD.DebuffDWORD
                UserPing = pD.DebuffDWORD
                
                ' (3 defunct DWORDS)
                pD.Advance (3 * 4)
                
                ' Further user information
                Username = pD.DebuffNTString
                s = pD.DebuffNTString   ' Statstring
                s2 = ""
                
                If LenB(s) > 0 Then
                    Product = ParseStatstring(s, s2, ClanTag)
                End If
                
                If Product = "WAR3" Or Product = "W3XP" Then
                    If Len(s2) > 4 Then W3Icon = StrReverse(Mid$(s2, 6, 4))
                End If
                
                ' 0x0F is a beast!
                Select Case EventID
                    Case ID_JOIN
                        Call Event_UserJoins(Username, UserFlags, s2, UserPing, Product, ClanTag, s, W3Icon)
                        
                    Case ID_LEAVE
                        Call Event_UserLeaves(Username, UserFlags)
                        
                    Case ID_USER
                        Call Event_UserInChannel(Username, UserFlags, s2, UserPing, Product, ClanTag, s, W3Icon)
                        
                    Case ID_WHISPER
                        If Not bFlood Then Call Event_WhisperFromUser(Username, UserFlags, s)
                        
                    Case ID_TALK
                        Call Event_UserTalk(Username, UserFlags, s, UserPing)
                        
                    Case ID_BROADCAST
                        Call Event_ServerInfo("BROADCAST from " & Username & ": " & s)
                    
                    Case ID_CHANNEL
                        Call Event_JoinedChannel(s, UserFlags)
                        
                    Case ID_USERFLAGS
                        Call Event_FlagsUpdate(Username, UserFlags, UserPing, Product)
                        
                    Case ID_WHISPERSENT
                        Call Event_WhisperToUser(Username, UserFlags, s, UserPing)
                    
                    Case ID_CHANNELFULL, ID_CHANNELDOESNOTEXIST, ID_CHANNELRESTRICTED
                        'Call Event_ServerError(S)
                        
                    Case ID_INFO
                        Call Event_ServerInfo(s)
                        
                    Case ID_ERROR
                        Call Event_ServerError(s)
                        
                    Case ID_EMOTE
                        Call Event_UserEmote(Username, UserFlags, s)
                        
                    Case Else
                        If MDebug("debug") Then
                            AddChat RTBColors.ErrorMessageText, "Unhandled 0x0F Event: " & ZeroOffset(EventID, 2)
                            AddChat RTBColors.ErrorMessageText, "Packet data: " & vbCrLf & DebugOutput(PacketData)
                        End If
                End Select
                    
            '###########################################################################
            Case &H19 'SID_MESSAGEBOX
                pD.Advance 4  'unused DWORD
                s = pD.DebuffNTString
                
                Call Event_ServerError(s)
            
            '###########################################################################
            Case &H25 'SID_PING
                If BotVars.Spoof = 0 Or g_Online Then
                    PBuffer.InsertDWORD pD.DebuffDWORD
                    PBuffer.SendPacket &H25
                End If
            
            '###########################################################################
            Case &H26 'SID_READUSERDATA
                ProfileParse PacketData
            
            '###########################################################################
            Case &H3D 'SID_CREATEACCT2
                l = pD.DebuffDWORD
                
                b = Event_AccountCreateResponse(l)
                
                If b Then
                    Send0x3A ds.GetServerToken
                Else
                    Call frmChat.DoDisconnect
                End If
            
            '###########################################################################
            Case &H31 'SID_CHANGEPASSWORD
                ' Hypothetical code for when I decide to implement this
                ' b = CBool(pd.debuffdword)
                ' call event_ChangePasswordResponse(b)
            
            '###########################################################################
            Case &H3A 'SID_LOGONRESPONSE2
                l = pD.DebuffDWORD
            
                Select Case l
                    Case &H0  'Successful login.
                        Event_LogonEvent 2
                        
                        If AwaitingEmailReg = 0 Then
                            If Dii And BotVars.UseRealm Then
                                AddChat RTBColors.InformationText, "[BNET] Asking Battle.net for a list of Realm servers..."
                                frmRealm.Show
                                PBuffer.SendPacket &H40
                            Else
                                Send0x0A
                            End If
                        Else
                            frmEMailReg.Show
                        End If
                        
                    Case &H1  'Nonexistent account.
                        Event_LogonEvent 0
                        Event_LogonEvent 3
                        AttemptAccountCreation
                        
                    Case &H2  'Invalid password.
                        Event_LogonEvent 1
                        Call frmChat.DoDisconnect
                        
                    Case &H6  'Account has been closed (includes a reason)
                        s = pD.DebuffNTString
                        Event_LogonEvent 5, s
                        Call frmChat.DoDisconnect
                        
                    Case Else
                        ' WTF?
                        frmChat.AddChat RTBColors.ErrorMessageText, "[BNET] Invalid response to 0x3A!"
                        frmChat.AddChat RTBColors.ErrorMessageText, "Status code: " & l
                        frmChat.AddChat RTBColors.ErrorMessageText, "Packet dump: " & vbCrLf & DebugOutput(PacketData)
                        Call frmChat.DoDisconnect
                        
                End Select
                
            '###########################################################################
            Case &H3E 'SID_LOGONREALMEX
                'Debug.Print DebugOutput(PacketData)
                's: MCP chunk 1
                's2: IP address
                'l: Port
                
                If Len(PacketData) > 8 Then
                    s = pD.DebuffRaw(16) 'MCP chunk 1
                    
                    s2 = ""
                    
                    For l = 1 To 4 ' IP
                        s2 = s2 & Asc(pD.DebuffRaw(1)) & IIf(l < 4, ".", "")
                    Next l
                    
                    
                    l = pD.DebuffDWORD 'Port
                    l = ntohs(l)        'Fix byte order
                    'Debug.Print l
                    'Debug.Print ntohl(l)
                    
                    s = s & pD.DebuffRaw(48) 'MCP chunk 2
                    
                    With frmChat.sckMCP
                        If .State <> 0 Then .Close
                        
                        .RemoteHost = s2
                        .RemotePort = l
                    End With
                    
                    frmRealm.MCPHandler.CurrentChunk = s
                    
                    s = pD.DebuffNTString
                    frmRealm.MCPHandler.BNetUniqueUsername = s
                    
                    frmChat.sckMCP.Connect
                    
                Else
                    pD.Advance 4
                    l = pD.DebuffDWORD
                    
                    Call Event_RealmStatusError(l)
                    Unload frmRealm
                End If
                
            Case &H40 'SID_QUERYREALMS2
                pD.Advance 12
                
                s = pD.DebuffNTString
                AddChat RTBColors.SuccessText, "[BNET] Battle.net has responded!"
                AddChat RTBColors.InformationText, "[REALM] Opening a connection to the Diablo II Realm..."
                
                frmRealm.MCPHandler.LogonToRealm &H1, ServerToken, s
                
                
            'Case &H44 'SID_WARCRAFTGENERAL
                'l = pD.DebuffBYTE ' Subcommand ID
            
            'Case &H46 'SID_NEWS_INFO
            
            '###########################################################################
            Case &H50 'SID_AUTH_INFO
                l = pD.DebuffDWORD ' Logon type
                ds.LogonType = l
                
                ServerToken = pD.DebuffDWORD
                ds.SetServerToken ServerToken
                
                pD.Advance 4
                
                s3 = pD.DebuffRaw(8)    ' mpq filetime
                s = pD.DebuffNTString   ' mpq filename
                s2 = pD.DebuffNTString  ' ValueString [Hash Command]
                
                ds.SetHashCmd s2
                
                ' "IX86ver1.mpq"
                ' Updated 9/12/06 to combat Blizzard's change to the system
                ' Designed to be future-fixable via an update to BNCSutil.dll
                ds.SetMPQRev extractMPQNumber(s)
                ' Debug.Print "Extracted " & ds.GetMPQRev & " from " & s
                
                ' Updated 11/7/06 due to another change to Blizzard's checkrevision
                ' Now passing the entire filename to BNLS
                
                AddChat RTBColors.InformationText, "[BNET] Checking version..."
                
                If MDebug("-all") Then
                    frmChat.AddChat COLOR_BLUE, "-- MPQ name: " & s2
                    frmChat.AddChat COLOR_BLUE, "-- Checksum Formula: " & s
                End If
                
                If BotVars.BNLS Then
                    NLogin.Send_0x0D ds.LogonType
                
                    If LenB(ReadINI("Override", "BNLSLegacyHashing", "config.ini")) > 0 Then
                        NLogin.Send_0x09 ds.GetMPQRev, ds.GetHashCmd
                    Else
                        NLogin.Send_0x1A GetBNLSProductID(BotVars.Product), &H0, &H1, s3, s, s2
                    End If
                Else
                    Call Send0x51(ServerToken)
                End If
                
            '###########################################################################
            Case &H51 'SID_AUTH_CHECK
                ' b is being used as a NoProceed boolean
                l = pD.DebuffDWORD
                s = pD.DebuffNTString
                b = True    'Default action: Do not proceed
                
                Select Case l
                    Case &H0    'SUCCESS
                        b = False
                        Call Event_VersionCheck(0, vbNullString)
                        
                    Case &H100  'OLD Version
                        Call Event_VersionCheck(1, vbNullString)
                        
                    Case &H101  'INVALID VERSION
                        Call Event_VersionCheck(1, vbNullString)
                        
                    Case &H200  'INVALID KEY
                        Call Event_VersionCheck(2, vbNullString)
                        
                    Case &H201  'CDKEY IN USE, parse addtl info for username
                        Call Event_VersionCheck(6, s)
                        
                    Case &H202 'BANNED
                        Call Event_VersionCheck(5, vbNullString)
                        
                    Case &H203 'Wrong product
                        Call Event_VersionCheck(4, vbNullString)
                    
                    Case &H210  'INVALID KEY
                        Call Event_VersionCheck(7, vbNullString)
                        
                    Case &H211  'CDKEY IN USE, parse addtl info for username
                        Call Event_VersionCheck(8, s)
                        
                    Case &H212 'BANNED
                        Call Event_VersionCheck(9, vbNullString)
                        
                    Case &H213 'Wrong product
                        Call Event_VersionCheck(10, vbNullString)
                    
                    Case Else
                        If (ReadCFG("Override", "Ignore0x51Reply") = "Y") Then
                            b = False
                        End If
                        
                        AddChat RTBColors.ErrorMessageText, "Unknown 0x51 Response: 0x" & ZeroOffset(l, 4)
                End Select
                
                If frmChat.sckBNet.State = 7 And AwaitingEmailReg = 0 And Not b Then
                    AddChat RTBColors.InformationText, "[BNET] Sending login information..."
            
                    If ds.LogonType = 2 Then ' NLS! Proceed to 0x52+
                        If BotVars.BNLS Then
                            NLogin.Send_0x02 BotVars.Username, BotVars.Password
                        Else
                            Call CreateNLSObject
                            Call Send0x53
                        End If
                        
                    Else ' Not NLS! Proceed to 0x3A+
                        Send0x3A ServerToken
                    End If
                End If
            
            '###########################################################################
            Case &H52 'SID_AUTH_ACCOUNTCREATE
                l = pD.DebuffDWORD
                
                Select Case l
                    Case &H0
                        Call Event_LogonEvent(4)
                        
                        If frmChat.sckBNet.State = 7 Then
                            AddChat RTBColors.InformationText, "[BNET] Sending login information..."
                            
                            If BotVars.BNLS Then
                                NLogin.Send_0x02 BotVars.Username, BotVars.Password
                            Else
                                Call Send0x53
                            End If
                        End If
                        
                    Case Else
                        AddChat RTBColors.ErrorMessageText, "Account creation failed."
                        Call frmChat.DoDisconnect
                        
                End Select
                
                
            '###########################################################################
            Case &H53 'SID_AUTH_ACCOUNTLOGON
                l = pD.DebuffDWORD
                s = pD.DebuffRaw(32) 'Salt [s]
                s2 = pD.DebuffRaw(32) ' Server key [B]
                
                Select Case l
                    Case &H0    'Accepted, requires proof
                        If BotVars.BNLS Then
                            NLogin.Send_0x03 s & s2 ' BNLS wants it all at once
                        Else
                            Send0x54 s, s2
                        End If
                        
                    Case &H1    'Nonexistent
                        Call Event_LogonEvent(0)
                        Call Event_LogonEvent(3)
                        
                        If BotVars.BNLS Then
                            NLogin.Send_0x04 BotVars.Username, BotVars.Password
                        Else
                            Send0x52
                        End If
                        
                    Case &H5    'Requires upgrade
                        If BotVars.BNLS Then
                            NLogin.Send_0x07 BotVars.Username, BotVars.Password
                        Else
                            AddChat RTBColors.ErrorMessageText, "[BNET] Battle.net reports that your account requires an NLS upgrade."
                            AddChat RTBColors.ErrorMessageText, "[BNET] Please connect using BNLS at least once so that this upgrade can occur."
                            frmChat.DoDisconnect
                        End If
                        
                    Case Else
                        AddChat RTBColors.ErrorMessageText, "[BNET] Unknown response to 0x53: 0x" & ZeroOffset(l, 4)
                        frmChat.DoDisconnect
                        
                End Select
                
                
            '###########################################################################
            Case &H54 'SID_AUTH_ACCOUNTLOGONPROOF
                l = pD.DebuffDWORD
                
                Select Case l
                    Case &H0   'Success
                        Call Event_LogonEvent(2)
                        Send0x0A
                        
                    Case &HE    'Email registration requried
                        frmEMailReg.Show
                        ' ( the rest is handled by frmEMailReg )
                        
                    Case &HF    'Custom message
                        pD.Advance 32
                        s = pD.DebuffNTString
                        Call Event_LogonEvent(5, s)
                        Call frmChat.DoDisconnect
                    
                    Case &H2    'Invalid password
                        Call Event_LogonEvent(1)
                        Call frmChat.DoDisconnect
                        
                    Case Else
                        AddChat RTBColors.ErrorMessageText, "[BNET] Unknown response to 0x54: 0x" & Right$("00" & Hex(Conv(Mid$(PacketData, 5, 4))), 2)
                        AddChat RTBColors.ErrorMessageText, "[BNET] Hex dump of the packet: "
                        AddChat RTBColors.ErrorMessageText, "[BNET]" & vbCrLf & DebugOutput(PacketData)
                        Call frmChat.DoDisconnect
                        
                End Select
                
            '###########################################################################
            Case &H59 'SID_SETEMAIL
                AwaitingEmailReg = 1
                frmEMailReg.Show
            
            '###########################################################################
            Case Is >= &H65 'Friends List or Clan-related packet
                ' Hand the packet off to the appropriate handler
                If PacketID >= &H70 Then
                    ' added in response to the clan channel takeover exploit
                    ' discovered 11/7/05
                    If IsW3 Then
                        frmChat.ParseClanPacket PacketID, IIf(Len(PacketData) > 4, Mid$(PacketData, 5), vbNullString)
                    End If
                Else
                    frmChat.ParseFriendsPacket PacketID, Mid$(PacketData, 5)
                End If
            
            '###########################################################################
            Case Else
                If MDebug("debug") Then
                    AddChat RTBColors.ErrorMessageText, "Unhandled packet 0x" & ZeroOffset(PacketID, 2)
                    AddChat RTBColors.ErrorMessageText, "Packet data: " & vbCrLf & DebugOutput(PacketData)
                End If
            
        End Select
    End If
    
    Set pD = Nothing
End Sub

Public Function StrToHex(ByVal String1 As String, Optional ByVal NoSpaces As Boolean = False) As String
    Dim strTemp As String, strReturn As String, i As Long
    
    For i = 1 To Len(String1)
        strTemp = Hex(Asc(Mid(String1, i, 1)))
        If Len(strTemp) = 1 Then strTemp = "0" & strTemp
        
        strReturn = strReturn & IIf(NoSpaces, "", Space(1)) & strTemp
    Next i
        
    StrToHex = strReturn
End Function

'Public Sub DecodeCDKey(ByVal sCDKey As String, ByRef dProductId As Double, ByRef dValue1 As Double, ByRef dValue2 As Double)
'    sCDKey = Replace(sCDKey, "-", vbNullString)
'    sCDKey = Replace(sCDKey, " ", vbNullString)
'    sCDKey = KillNull(sCDKey)
'
'    If Len(sCDKey) = 13 Then
'        sCDKey = DecodeStarcraftKey(sCDKey)
'    ElseIf Len(sCDKey) = 16 Then
'        sCDKey = DecodeD2Key(sCDKey)
'        'addchat vbBlue, "Decoded Diablo II CDKey: " & vbCrLf & DebugOutput(sCDKey)
'    Else
'        Exit Sub
'    End If
'
'    dProductId = Val("&H" & Left$(sCDKey, 2))
'
'    If Len(sCDKey) = 13 Then
'        dValue1 = Val(Mid$(sCDKey, 3, 7))
'        dValue2 = Val(Mid$(sCDKey, 10, 3))
'
'    ElseIf Len(sCDKey) = 16 Then
'        dValue1 = Val("&H" & Mid$(sCDKey, 3, 6))
'        dValue2 = Val("&H" & Mid$(sCDKey, 9))
'    End If
'
'End Sub

Public Function DecodeD2Key(ByVal Key As String) As String

    Dim r As Double, n As Double, n2 As Double, v As Double, _
    v2 As Double, KeyValue As Double, c1 As Integer, c2 As Integer, _
    c As Byte, i As Integer, aryKey(0 To 15) As String, _
    codevalues As String ', bValid as boolean
    
    On Error GoTo ErrorTrapped
    
    codevalues = "246789BCDEFGHJKMNPRTVWXZ"
    r = 1
    KeyValue = 0
    
    For i = 1 To 16
    
        aryKey(i - 1) = Mid$(Key, i, 1)
        
    Next i
    
    For i = 0 To 15 Step 2
        c1 = InStr(1, codevalues, aryKey(i)) - 1
        If c1 < 0 Then c1 = &HFF
        If c1 > 255 Then c1 = 255
        n = c1 * 3
        c2 = InStr(1, codevalues, aryKey(i + 1)) - 1
        If c2 = -1 Then c2 = &HFF
        If c2 > 255 Then c2 = 255
        n = c2 + n * 8
        
        If n >= &H100 Then
        
            n = n - &H100
            KeyValue = KeyValue Or r
            
        End If
        
        n2 = n
        n2 = RShift(n2, 4)
        aryKey(i) = GetHexValue(n2)
        aryKey(i + 1) = GetHexValue(n)
        r = LShift(r, 1)
        
Cont:

    Next i
    
    v = 3
    
    For i = 0 To 15
    
        c = GetNumValue(aryKey(i))
        n = Val(c)
        n2 = v * 2
        n = n Xor n2
        v = v + n
        
    Next i
    
    v = v And &HFF
    
    For i = 15 To 0 Step -1
    
        c = Asc(aryKey(i))
        
        If i > 8 Then
        
            n = i - 9
            
        Else
        
            n = &HF - (8 - i)
            
        End If
        
        n = n And &HF
        c2 = Asc(aryKey(n))
        aryKey(i) = Chr$(c2)
        aryKey(n) = Chr$(c)
        
    Next i
    
    v2 = &H13AC9741
    
    For i = 15 To 0 Step -1
    
        c = Asc(UCase(aryKey(i)))
        aryKey(i) = Chr$(c)
        
        If Val(c) <= Asc("7") Then
        
            v = v2
            c2 = v And &HF
            c2 = c2 And 7
            c2 = c2 Xor c
            v = RShift(v, 3)
            aryKey(i) = Chr$(c2)
            v2 = v
            
        ElseIf Val(c) < Asc("A") Then
        
            c2 = CByte(i)
            c2 = c2 And 1
            c2 = c2 Xor c
            aryKey(i) = Chr$(c2)
            
        End If
        
    Next i
    
    DecodeD2Key = Join(aryKey, vbNullString)
    
    Erase aryKey()
    
    Exit Function
    
ErrorTrapped:
    AddChat RTBColors.ErrorMessageText, "D2/W2 CDKey decoding error occurred!"
    AddChat RTBColors.ErrorMessageText, Err.Number & ": " & Err.Description
End Function

Public Function DecodeStarcraftKey(ByVal sKey As String) As String
    Dim n As Double, n2 As Double, v As Double, _
    v2 As Double, c2 As Byte, c As Byte, _
    bValid As Boolean, i As Integer, aryKey(0 To 12) As String 'r as double, keyvalue as double, c1 as byte
    
    For i = 1 To 13
    
        aryKey(i - 1) = Mid$(sKey, i, 1)
        
    Next i
    
    v = 3
    
    For i = 0 To 11
    
        c = aryKey(i)
        n = Val(c)
        n2 = v * 2
        n = n Xor n2
        v = v + n
        
    Next i
    
    v = v Mod 10
    
    If Hex(v) = aryKey(12) Then
    
        bValid = True
        
    End If
    
    v = 194
    
    For i = 11 To 0 Step -1
    
        If v < 7 Then GoTo continue
        c = aryKey(i)
        n = CInt(v / 12)
        n2 = v Mod 12
        v = v - 17
        c2 = aryKey(n2)
        aryKey(i) = c2
        aryKey(n2) = c
        
    Next i
    
continue:

    v2 = &H13AC9741
    
    For i = 11 To 0 Step -1
    
        c = UCase$(aryKey(i))
        aryKey(i) = c
        
        If Asc(c) <= Asc("7") Then
        
            v = v2
            c2 = v And &HFF
            c2 = c2 And 7
            c2 = c2 Xor c
            v = RShift(CLng(v), 3)
            aryKey(i) = c2
            v2 = v
            
        ElseIf Asc(c) < 65 Then
        
            c2 = CByte(i)
            c2 = c2 And 1
            c2 = c2 Xor c
            aryKey(i) = c2
            
        End If
        
    Next i
    
    DecodeStarcraftKey = Join(aryKey, vbNullString)
    
    Erase aryKey()
    
End Function


Public Function LShift(ByVal pnValue As Long, ByVal pnShift As Long) As Double
    'on error resume next
    LShift = CDbl(pnValue * (2 ^ pnShift))
End Function


Public Function RShift(ByVal pnValue As Long, ByVal pnShift As Long) As Double
    'on error resume next
    RShift = CDbl(pnValue \ (2 ^ pnShift))
End Function

'Private Function HexToDec(ByVal sHex As String) As Long
''on error resume next
'    Dim i As Integer
'    Dim nDec As Long
'    Const HexChar As String = "0123456789ABCDEF"
'
'
'
'    For i = Len(sHex) To 1 Step -1
'        nDec = nDec + (InStr(1, HexChar, Mid(sHex, i, 1)) - 1) * 16 ^ (Len(sHex) - i)
'    Next i
'    HexToDec = CStr(nDec)
'
'End Function

Public Function KillNull(ByVal text As String) As String
    Dim i As Integer
    i = InStr(1, text, Chr(0))
    If i = 0 Then
        KillNull = text
        Exit Function
    End If
    KillNull = Left$(text, i - 1)
End Function

Public Function ParsePing(strData As String) As Long
    'on error resume next
    Dim strPing As String
    strPing$ = Mid$(strData, 13, 4)
    CopyMemory ParsePing, ByVal strPing$, 4
End Function

Public Function CVL(X As String) As Long
    'on error resume next
    If Len(X) < 4 Then
        Exit Function
    End If
    CopyMemory CVL, ByVal X, 4
End Function


'' Converts a string to an Integer
'Private Function CVI(x As String) As Integer
''on error resume next
'    If Len(x) < 2 Then
'        MsgBox "CVI(): String too short"
'        Stop
'    End If
'
'    CopyMemory CVI, ByVal x, 2
'End Function

Public Function GetHexValue(ByVal v As Long) As String

    v = v And &HF
    
    If v < 10 Then
    
        GetHexValue = Chr$(v + &H30)
        
    Else
    
        GetHexValue = Chr$(v + &H37)
        
    End If
    
End Function

Public Function GetNumValue(ByVal c As String) As Long
'on error resume next
    c = UCase(c)
    
    If StrictIsNumeric(c) Then
    
        GetNumValue = Asc(c) - &H30
        
    Else
    
        GetNumValue = Asc(c) - &H37
        
    End If
    
End Function

Public Sub NullTruncString(ByRef text As String)
'on error resume next
    Dim i As Integer
    
    i = InStr(text, Chr(0))
    If i = 0 Then Exit Sub
    
    text = Left$(text, i - 1)
End Sub

Public Sub FullJoin(Channel As String, Optional ByVal i As Byte)
    If i > 0 Then
        PBuffer.InsertDWORD CLng(i)
    Else
        PBuffer.InsertDWORD &H2
    End If
    PBuffer.InsertNTString Channel
    PBuffer.SendPacket &HC
End Sub

Public Function HexToStr(ByVal Hex1 As String) As String
'on error resume next
    Dim strReturn As String, i As Long
    If Len(Hex1) Mod 2 <> 0 Then Exit Function
    For i = 1 To Len(Hex1) Step 2
    strReturn = strReturn & Chr(Val("&H" & Mid(Hex1, i, 2)))
    Next i
    HexToStr = strReturn
End Function

Public Sub RejoinChannel(Channel As String)
    'on error resume next
    PBuffer.SendPacket &H10
    PBuffer.InsertDWORD &H2
    PBuffer.InsertNTString Channel
    PBuffer.SendPacket &HC
End Sub

Public Sub RequestProfile(strUser As String)
    'on error resume next
    With PBuffer
        .InsertDWORD 1
        .InsertDWORD 4
        .InsertDWORD GetTickCount()
        .InsertNTString strUser
        .InsertNTString "Profile\Age"
        .InsertNTString "Profile\Sex"
        .InsertNTString "Profile\Location"
        .InsertNTString "Profile\Description"
        .SendPacket &H26
    End With
End Sub

Public Sub RequestSpecificKey(ByVal sUsername As String, ByVal sKey As String)
    With PBuffer
        .InsertDWORD 1
        .InsertDWORD 1
        .InsertDWORD GetTickCount()
        .InsertNTString sUsername
        .InsertNTString sKey
        .SendPacket &H26
    End With
End Sub

Public Sub SetProfile(ByVal Location As String, ByVal Description As String)
    'Dim i As Byte
    Const MAX_DESCR As Long = 510
    Const MAX_SEX As Long = 200
    Const MAX_LOC As Long = 200
    
    '// Sanity checks
    If LenB(Description) = 0 Then
        Description = Space(1)
    ElseIf Len(Description) > MAX_DESCR Then
        Description = Left$(Description, MAX_DESCR)
    End If
    
'    If LenB(Sex) = 0 Then
'        Sex = Space(1)
'    ElseIf Len(Sex) > MAX_SEX Then
'        Sex = Left$(Sex, MAX_SEX)
'    End If
    
    If LenB(Location) = 0 Then
        Location = Space(1)
    ElseIf Len(Location) > MAX_LOC Then
        Location = Left$(Location, MAX_LOC)
    End If
    
    
    With PBuffer
        .InsertDWORD &H1                    '// #accounts
        .InsertDWORD 2                      '// #keys
        .InsertNTString CurrentUsername     '// account to update
                                            '// keys
        .InsertNTString "Profile\Location"
        .InsertNTString "Profile\Description"
                                            '// values
        .InsertNTString Location
        .InsertNTString Description
        
        .SendPacket &H27
    End With
End Sub

'// Extended version of this function for scripting use
'//  Will not ERASE if a field is left blank
'// 2007-06-07: SEX value is ignored because Blizzard removed that
'//     field from profiles
Public Sub SetProfileEx(ByVal Location As String, ByVal Description As String)
    'Dim i As Byte
    Const MAX_DESCR As Long = 510
    Const MAX_SEX As Long = 200
    Const MAX_LOC As Long = 200
    
    Dim nKeys As Integer
    Dim pKeys(1 To 3) As String
    
    '// Sanity checks
    If LenB(Description) > 0 Then
        If Len(Description) > MAX_DESCR Then
            Description = Left$(Description, MAX_DESCR)
        End If
        
        nKeys = nKeys + 1
        pKeys(nKeys) = "Profile\Description"
    End If
        
'    If LenB(Sex) = 0 Then
'        If Len(Sex) > MAX_SEX Then
'            Sex = Left$(Sex, MAX_SEX)
'        End If
'
'        nKeys = nKeys + 1
'        pKeys(nKeys) = "Profile\Sex"
'    End If
    
    If LenB(Location) = 0 Then
        If Len(Location) > MAX_LOC Then
            Location = Left$(Location, MAX_LOC)
        End If
        
        nKeys = nKeys + 1
        pKeys(nKeys) = "Profile\Location"
    End If
    
    If nKeys > 0 Then
        With PBuffer
            .InsertDWORD &H1                    '// #accounts
            .InsertDWORD nKeys                  '// #keys
            .InsertNTString CurrentUsername     '// account to update
                                                '// keys
            For nKeys = 1 To nKeys
                .InsertNTString pKeys(nKeys)
            Next nKeys
                                                '// values
            .InsertNTString Location
            .InsertNTString Description
            
            .SendPacket &H27
        End With
    End If
End Sub

Public Function GetDWORD(Data As String) As Long
    Dim tmp As String
    tmp = StrToHex(Data)
    Dim A As String, b As String, c As String, D As String
    A = Mid(tmp, 1, 2)
    b = Mid(tmp, 3, 2)
    c = Mid(tmp, 5, 2)
    D = Mid(tmp, 7, 2)
    tmp = D & c & b & A
    GetDWORD = Val("&H" & tmp)
End Function

Public Sub sPrintF(ByRef Source As String, ByVal nText As String, _
    Optional ByVal A As Variant, _
    Optional ByVal b As Variant, _
    Optional ByVal c As Variant, _
    Optional ByVal D As Variant, _
    Optional ByVal E As Variant, _
    Optional ByVal f As Variant, _
    Optional ByVal G As Variant, _
    Optional ByVal H As Variant)
    
    nText = Replace(nText, "%S", "%s")
    
    Dim i As Byte
    i = 0
    
    Do While (InStr(1, nText, "%s") <> 0)
        Select Case i
            Case 0
                If IsEmpty(A) Then GoTo theEnd
                nText = Replace(nText, "%s", A, 1, 1)
            Case 1
                If IsEmpty(b) Then GoTo theEnd
                nText = Replace(nText, "%s", b, 1, 1)
            Case 2
                If IsEmpty(c) Then GoTo theEnd
                nText = Replace(nText, "%s", c, 1, 1)
            Case 3
                If IsEmpty(D) Then GoTo theEnd
                nText = Replace(nText, "%s", D, 1, 1)
            Case 4
                If IsEmpty(E) Then GoTo theEnd
                nText = Replace(nText, "%s", E, 1, 1)
            Case 5
                If IsEmpty(f) Then GoTo theEnd
                nText = Replace(nText, "%s", f, 1, 1)
            Case 6
                If IsEmpty(G) Then GoTo theEnd
                nText = Replace(nText, "%s", G, 1, 1)
            Case 7
                If IsEmpty(H) Then GoTo theEnd
                nText = Replace(nText, "%s", H, 1, 1)
        End Select
        i = i + 1
    Loop
theEnd:
    Source = Source & nText
End Sub

Public Function ParseStatstring(ByVal Statstring As String, ByRef outBuf As String, ByRef sClan As String) As String
    Dim Values() As String
    Dim Temp() As String
    Dim cType As String
    Dim WCG As Boolean
   On Error GoTo ParseStatString_Error

    'Dim Icon As String
    
    ' FRCW = Ref
    ' LPCW = Player
    
    'Debug.Print "Received statstring: " & Statstring
    If LenB(Statstring) > 0 Then
        
        g_ThisIconCode = -1
    
        Select Case Left$(Statstring, 4)
            Case "3RAW", "PX3W"
                If Len(Statstring) > 4 Then
                    Temp() = Split(Statstring, " ")
                    
                    ReDim Values(3)
                    
                    If StrComp(Right$(Temp(1), 2), "CW") = 0 Then
                        WCG = True
                    Else
                        Values(1) = Mid$(Statstring, 6, 1)
                        Values(2) = Mid$(Statstring, 7, 1)
                    End If
                    
                    Values(0) = Temp(2)
                    
                    If UBound(Temp) > 2 Then
                        Values(3) = StrReverse(Temp(3))
                    End If
                    
                    g_ThisIconCode = GetRaceAndIcon(Values(1), Values(2), Left$(Statstring, 4), IIf(WCG, Temp(1), ""))
                    
                    sClan = IIf(UBound(Values) > 2, Values(3), "")
                    
                    If Left$(Statstring, 4) = "3RAW" Then
                        Call sPrintF(outBuf, "Warcraft III: Reign of Chaos (Level: %s, icon tier %s, %s icon" & IIf(UBound(Temp) > 2, ", in Clan " & sClan, vbNullString) & ")", Values(0), Values(2), Values(1))
                    Else
                        Call sPrintF(outBuf, "Warcraft III: The Frozen Throne (Level: %s, icon tier %s, %s icon" & IIf(UBound(Temp) > 2, ", in Clan " & sClan, vbNullString) & ")", Values(0), Values(2), Values(1))
                    End If
                Else
                    If Left$(Statstring, 4) = "3RAW" Then
                        Call StrCpy(outBuf, "Warcraft III: Reign of Chaos.")
                        g_ThisIconCode = -56
                    Else
                        Call StrCpy(outBuf, "Warcraft III: The Frozen Throne.")
                        g_ThisIconCode = -10
                    End If
                End If
                
            Case "RHSS"
                Call StrCpy(outBuf, "Starcraft Shareware.")
                
            Case "RATS"
                Values() = Split(Mid$(Statstring, 6), " ")
                If UBound(Values) <> 8 Then
                    Call sPrintF(outBuf, "a Starcraft %sbot", IIf((Values(3) = 1), " (spawn) ", vbNullString))
                Else
                    If Values(0) > 0 Then
                        Call sPrintF(outBuf, "Starcraft%s (%s wins, with a rating of %s on the ladder)", IIf((Values(3) = 1), " (spawn) ", vbNullString), Values(2), Values(0))
                    Else
                        Call sPrintF(outBuf, "Starcraft%s (%s wins).", IIf((Values(3) = 1), " (spawn) ", vbNullString), Values(2))
                    End If
                End If
                
            Case "PXES"
                Values() = Split(Mid(Statstring, 6), " ")
                If UBound(Values) <> 8 Then
                    Call sPrintF(outBuf, "a Starcraft Brood War bot.", vbNullString)
                    
                    If UBound(Values) > 2 Then
                        outBuf = outBuf & "(spawn) "
                    End If
                Else
                    If Values(0) > 0 Then
                        Call sPrintF(outBuf, "Starcraft Brood War%s (%s wins, with a rating of %s on the ladder)", IIf((Values(3) = 1), " (spawn) ", vbNullString), Values(2), Values(0))
                    Else
                        Call sPrintF(outBuf, "Starcraft Brood War%s (%s wins).", IIf((Values(3) = 1), " (spawn) ", vbNullString), Values(2))
                    End If
                End If
                
            Case "RTSJ"
                Values() = Split(Mid(Statstring, 6), " ")
                If UBound(Values) <> 8 Then
                    Call sPrintF(outBuf, "a Starcraft Japanese %sbot.", IIf((Values(3) = 1), " (spawn) ", vbNullString))
                Else
                    If Values(0) > 0 Then
                        Call sPrintF(outBuf, "Starcraft Japanese%s (%s wins, with a rating of %s on the ladder)", IIf((Values(3) = 1), " (spawn) ", vbNullString), Values(2), Values(0))
                    Else
                        Call sPrintF(outBuf, "Starcraft Japanese%s (%s wins).", IIf((Values(3) = 1), " (spawn) ", vbNullString), Values(2))
                    End If
                End If
                
            Case "NB2W"
                Values() = Split(Mid$(Statstring, 6), " ")
                
                If UBound(Values) <> 8 Then
                    Call sPrintF(outBuf, "a Warcraft II %sbot.", IIf((Values(3) = 1), " (spawn) ", vbNullString))
                Else
                    If Values(0) > 0 Then
                        Call sPrintF(outBuf, "Warcraft II%s (%s wins, with a rating of %s on the ladder)", IIf((Values(3) = 1), " (spawn) ", vbNullString), Values(2), Values(0))
                    Else
                        Call sPrintF(outBuf, "Warcraft II%s (%s wins).", IIf((Values(3) = 1), " (spawn) ", vbNullString), Values(2))
                    End If
                End If
                
            Case "RHSD"
                Values() = Split(Mid$(Statstring, 6), " ")
                If UBound(Values) <> 8 Then
                    Call StrCpy(outBuf, "A Diablo shareware bot.")
                Else
                    Select Case Values(1)
                        Case 0: cType = "warrior"
                        Case 1: cType = "rogue"
                        Case 2: cType = "sorceror"
                    End Select
                    Call sPrintF(outBuf, "Diablo shareware (Level %s %s with %s dots, %s strength, %s magic, %s dexterity, %s vitality, and %s gold)", Values(0), cType, Values(2), Values(3), Values(4), Values(5), Values(6), Values(7))
                End If
                
            Case "LTRD"
                Values() = Split(Mid$(Statstring, 6), " ")
                
                If UBound(Values) <> 8 Then
                    Call StrCpy(outBuf, "A Diablo bot.")
                Else
                    Select Case Values(1)
                        Case 0: cType = "warrior"
                        Case 1: cType = "rogue"
                        Case 2: cType = "sorceror"
                    End Select
                    Call sPrintF(outBuf, "Diablo (Level %s %s with %s dots, %s strength, %s magic, %s dexterity, %s vitality, and %s gold)", Values(0), cType, Values(2), Values(3), Values(4), Values(5), Values(6), Values(7))
                End If
                
            Case "PX2D"
                Call StrCpy(outBuf, ParseD2Stats(Statstring))
                
            Case "VD2D"
                Call StrCpy(outBuf, ParseD2Stats(Statstring))
                
            Case "TAHC"
                Call StrCpy(outBuf, "a Chat bot.")
                
            Case Else
                Call StrCpy(outBuf, "an unknown client.")
                
        End Select
        
        ParseStatstring = StrReverse(Left$(Statstring, 4))
        
    End If

ParseStatString_Exit:
    Exit Function

ParseStatString_Error:

    Debug.Print "Error " & Err.Number & " (" & Err.Description & ") in procedure ParseStatString of Module modParsing"
    outBuf = "- Error parsing statstring. [" & Replace(Statstring, Chr(0), "") & "]"
    
    Resume ParseStatString_Exit
End Function

' This code cleaned 3/4/2005
Public Function ParseD2Stats(ByVal Stats As String)
    Dim Female As Boolean, Expansion As Boolean
    Dim sLen As Byte, Version As Byte, CharClass As Byte, Hardcore As Byte, CharLevel As Byte
    Dim StatBuf As String, p() As String, Server As String, Name As String
    
    Dim D2Classes(0 To 7) As String
        D2Classes(0) = "amazon"
        D2Classes(1) = "sorceress"
        D2Classes(2) = "necromancer"
        D2Classes(3) = "paladin"
        D2Classes(4) = "barbarian"
        D2Classes(5) = "druid"
        D2Classes(6) = "assassin"
        D2Classes(7) = "unknown class"
    
    If Len(Stats) > 4 Then
        sLen = GetServer(Stats, Server)
        sLen = GetCharacterName(Stats, sLen, Name)
        Call MakeArray(Mid$(Stats, sLen), p())
    End If
    
    If Left$(Stats, 4) = "VD2D" Then
        Call StrCpy(StatBuf, "Diablo II (")
    Else
        Call StrCpy(StatBuf, "Diablo II Lord of Destruction (")
    End If
    
    If (Len(Stats) = 4) Then
        Call StrCpy(StatBuf, "Open Character).")
    Else
        Version = Asc(p(0)) - &H80
        
        CharClass = Asc(p(13)) - 1
        If (CharClass < 0) Or (CharClass > 6) Then
            CharClass = 7
        End If
        
        If (CharClass = 0) Or (CharClass = 1) Or (CharClass = 6) Then
            Female = True
        Else
            Female = False
        End If
        
        CharLevel = Asc(p(25))
        Hardcore = Asc(p(26)) And 4
    
        If Left$(Stats, 4) = "PX2D" Then
            If (Asc(p(26)) And &H20) Then
                Select Case RShift((Asc(p(27)) And &H18), 3)
                    Case 1
                        If Hardcore Then
                            Call StrCpy(StatBuf, "Destroyer ")
                        Else
                            Call StrCpy(StatBuf, "Slayer ")
                        End If
                    Case 2, 3
                        If Hardcore Then
                            Call StrCpy(StatBuf, "Conquerer ")
                        Else
                            Call StrCpy(StatBuf, "Champion ")
                        End If
                    Case 4
                        If Hardcore Then
                            Call StrCpy(StatBuf, "Guardian ")
                        Else
                            If Not Female Then
                                Call StrCpy(StatBuf, "Patriarch ")
                            Else
                                Call StrCpy(StatBuf, "Matriarch ")
                            End If
                        End If
                End Select
                
                Expansion = True
            End If
        End If
        
        If Not Expansion Then
            Select Case RShift((Asc(p(27)) And &H18), 3)
                Case 1
                    If Female = False Then
                        If Hardcore Then
                            Call StrCpy(StatBuf, "Count ")
                        Else
                            Call StrCpy(StatBuf, "Sir ")
                        End If
                    Else
                        If Hardcore Then
                            Call StrCpy(StatBuf, "Countess ")
                        Else
                            Call StrCpy(StatBuf, "Dame ")
                        End If
                    End If
                Case 2
                    If Female = False Then
                        If Hardcore Then
                            Call StrCpy(StatBuf, "Duke ")
                        Else
                            Call StrCpy(StatBuf, "Lord ")
                        End If
                    Else
                        If Hardcore Then
                            Call StrCpy(StatBuf, "Duchess ")
                        Else
                            Call StrCpy(StatBuf, "Lady ")
                        End If
                    End If
                Case 3
                    If Female = False Then
                        If Hardcore Then
                            Call StrCpy(StatBuf, "King ")
                        Else
                            Call StrCpy(StatBuf, "Baron ")
                        End If
                    Else
                        If Hardcore Then
                            Call StrCpy(StatBuf, "Queen ")
                        Else
                            Call StrCpy(StatBuf, "Baroness ")
                        End If
                    End If
            End Select
        End If
        
        Call sPrintF(StatBuf, "%s, a ", Name)
        
        If Hardcore Then
            If (Asc(p(26)) And &H8) Then
                Call StrCpy(StatBuf, "dead ")
            End If
            Call StrCpy(StatBuf, "hardcore ")
        End If
        
        If Asc(p(26)) And &H40 Then
            Call StrCpy(StatBuf, "ladder ")
        End If
        
        Call sPrintF(StatBuf, "level %s ", CharLevel)
        
        Call sPrintF(StatBuf, "%s on realm %s).", D2Classes(CharClass), Server)
    End If
    
    ParseD2Stats = StatBuf
End Function

Public Function GetServer(ByVal Statstring As String, ByRef Server As String) As Byte
    'returns the begining of the character name
    Server = Mid$(Statstring, 5, InStr(5, Statstring, ",") - 5)
    GetServer = InStr(5, Statstring, ",") + 1
End Function

Public Function GetCharacterName(ByVal Statstring As String, ByVal start As Byte, ByRef cName As String) As Byte
    cName = Mid$(Statstring, start, InStr(start, Statstring, ",") - start)
    GetCharacterName = InStr(start, Statstring, ",") + 1
End Function

Function MakeLong(X As String) As Long
 'on error resume next
    If Len(X) < 4 Then
        Exit Function
    End If
    CopyMemory MakeLong, ByVal X, 4
End Function

Public Sub StrCpy(ByRef Source As String, ByVal nText As String)
    'on error resume next
    Source = Source & nText
End Sub

Public Sub GetValues(ByVal DataBuf As String, ByRef Ping As Long, ByRef Flags As Long, ByRef Name As String, ByRef Txt As String)
    'on error resume next
    Dim A As Long ', b As Long, c As Long, D As Long, E As Long, F As Long
    Dim f As Long
    Dim recvbufpos As Long
    
    Name = vbNullString
    Txt = vbNullString
    
    'Debug.Print DebugOutput(DataBuf)
    
    recvbufpos = 9
    f = MakeLong(Mid$(DataBuf, recvbufpos, 4))
    
    recvbufpos = recvbufpos + 4
    A = CVL(Mid$(DataBuf, recvbufpos, 4))
    
'    recvbufpos = recvbufpos + 4
'    b = MakeLong(Mid$(DataBuf, recvbufpos, 4))
'
'    recvbufpos = recvbufpos + 4
'    c = MakeLong(Mid$(DataBuf, recvbufpos, 4))
'
'    recvbufpos = recvbufpos + 4
'    D = MakeLong(Mid$(DataBuf, recvbufpos, 4))
'
'    recvbufpos = recvbufpos + 4
'    E = MakeLong(Mid$(DataBuf, recvbufpos, 4))
    
'    recvbufpos = recvbufpos + 4
    Flags = f
    Ping = A
    
    Call StrCpy(Name, KillNull(Mid$(DataBuf, 29)))
    Call StrCpy(Txt, KillNull(Mid$(DataBuf, Len(Name) + 30)))
End Sub

'Public Sub ParseBinary(strData As String)
'
'   On Error GoTo ParseBinary_Error
'
'    If Len(strData) < 5 Then Exit Sub
'    Dim usrFlags As Long, Ping As Long, usrName As String, usrText As String
'    Dim Statstring As String, Product As String * 4
'    Dim W3Icon As String, InitStatstring As String, sClan As String
'    Dim PacketID As Byte
'
'    GetValues strData, Ping, usrFlags, usrName, usrText
'
''    If usrFlags = 10 Then: usrFlags = usrFlags + 6
''    If usrFlags = 12 Then: usrFlags = usrFlags + 6
'
'    PacketID = Asc(Mid$(strData, 5, 1))
'
'    If (PacketID = ID_JOIN Or PacketID = ID_USER Or PacketID = ID_FLAGupdate) Then
'        InitStatstring = usrText
'
'        Product = ParseStatString(usrText, Statstring, sClan)
'        Product = StrReverse(Product)
'
'        If Product = "WAR3" Or Product = "W3XP" Then
'            'Debug.Print usrText '//for that war3 statstring sniffage
'            If Len(usrText) > 4 Then W3Icon = StrReverse(Mid$(usrText, 6, 4))
'        End If
'    End If
'
'    'usrFlags = CLng(Val(FlagsIDsplt(strData)))
'
'    'If Asc(Mid$(strData, 5, 1)) <> 5 Then Debug.Print Hex(Asc(Mid$(strData, 5, 1)))
'
'    Select Case PacketID
'        Case ID_WHISPFROM
'            If Not bFlood Then
'                frmChat.Event_WhisperFromUser usrName, usrFlags, usrText, False
'            End If
'
'        Case ID_TALK
'            frmChat.Event_UserTalk usrName, usrFlags, usrText, Ping, False
'
'        Case ID_EMOTE
'            If Not bFlood Then
'                frmChat.Event_UserEmote usrName, usrFlags, usrText, False
'            End If
'
'        Case ID_JOIN: frmChat.Event_UserJoins usrName, usrFlags, Statstring, Ping, Product, sClan, InitStatstring, W3Icon
'        Case ID_BROADCAST: frmChat.Event_ServerInfo "[Broadcast from " & usrName & "]: " & usrText, False
'        Case ID_USER: If Not bFlood Then frmChat.Event_UserInChannel usrName, usrFlags, Statstring, Ping, Product, sClan, InitStatstring, W3Icon
'        Case ID_FLAGS: If Not bFlood Then frmChat.Event_FlagsUpdate usrName, usrFlags, usrText, Ping, InitStatstring
'        Case ID_ERROR: frmChat.Event_ServerError usrText, False
'        Case ID_WHISPTO: frmChat.Event_WhisperToUser usrName, usrFlags, usrText, Ping, False
'        Case ID_CHAN: frmChat.Event_JoinedChannel usrText, usrFlags, False
'        Case ID_INFO: If Not bFlood Then frmChat.Event_ServerInfo usrText, False
'        Case ID_LEAVE: If Not bFlood Then frmChat.Event_UserLeaves usrName, usrFlags, False, W3Icon
'        Case 0: Exit Sub
'        Case Else
'            On Error Resume Next
'            'Debug.Print strData
'            If InStr(1, Command(), "-debug", vbTextCompare) > 0 Then
'                AddChat RTBColors.ErrorMessageText, "Unhandled packet 0x" & IIf(Len(CStr(Hex(Asc(Mid$(strData, 2, 1))))) = 1, "0" & Hex(Asc(Mid$(strData, 2, 1))), Hex(Asc(Mid$(strData, 2, 1))))
'                AddChat RTBColors.ErrorMessageText, "Packet data: " & vbCrLf & DebugOutput(strData)
'            End If
'    End Select
'    Exit Sub
'Errz:
'    AddChat RTBColors.SuccessText, "Trapped error: " & Err.Number & ": " & Err.Description
'
'ParseBinary_Exit:
'    Exit Sub
'
'ParseBinary_Error:
'
'    Debug.Print "Error " & Err.Number & " (" & Err.Description & ") in procedure ParseBinary of Module modParsing"
'    Resume ParseBinary_Exit
'End Sub

Public Sub MakeArray(ByVal text As String, ByRef nArray() As String)
    Dim i As Long
    ReDim nArray(0)
    For i = 0 To Len(text)
        nArray(i) = Mid$(text, i + 1, 1)
        If i <> Len(text) Then
            ReDim Preserve nArray(0 To UBound(nArray) + 1)
        End If
    Next i
End Sub

Public Function GetRaceAndIcon(ByRef Icon As String, ByRef Race As String, ByVal Product As String, Optional ByRef WCGCode As String) As Integer
    Dim i As Integer, IMLPos As Integer
    Dim PerTier As Integer
        
    If Product = "3RAW" Then
        PerTier = 5
    Else
        PerTier = 6
    End If
    
    'Debug.Print "Icon: " & Icon & "; Race: " & Race
    
    Select Case Race
        Case "H"
            IMLPos = 1
            i = 0
            Race = "Human"
        Case "N"
            IMLPos = 1 + (PerTier * 1)
            i = 10
            Race = "Night Elves"
        Case "U"
            IMLPos = 1 + (PerTier * 2)
            i = 20
            Race = "Undead"
        Case "O"
            IMLPos = 1 + (PerTier * 3)
            i = 30
            Race = "Orcs"
        Case "R"
            IMLPos = 1 + (PerTier * 4)
            i = 40
            Race = "Random"
        Case "T", "D"
            IMLPos = 1 + (PerTier * 5)
            i = 50
            Race = "Tournament"
        
        Case Else
            IMLPos = 1 + (PerTier * 5)
            i = 50
            Race = "unknown"
            
    End Select
    
    If StrictIsNumeric(Icon) Then
        i = i + CInt(Icon)
        IMLPos = IMLPos + (CInt(Icon) - 1)
    End If
    
    If LenB(WCGCode) > 0 Then
        ' This is a WCG PLAYER or OTHER PERSON
        Select Case StrReverse(WCGCode)
        '*** Special icons for WCG added 6/24/07 ***
            Case Is = "WCRF"
                Icon = "WCG Referee"
                IMLPos = IC_WCRF
            Case Is = "WCPL"
                Icon = "WCG Player"
                IMLPos = IC_WCPL
            Case Is = "WCGO"
                Icon = "WCG Gold Medalist"
                IMLPos = IC_WCGO
            Case Is = "WCSI"
                Icon = "WCG Silver Medalist"
                IMLPos = IC_WCSI
            Case Is = "WCBR"
                Icon = "WCG Bronze Medalist"
                IMLPos = IC_WCBR
            Case Is = "WCPG"
                Icon = "WCG Professional Gamer"
                IMLPos = IC_WCPG
            Case Else
                Icon = "unknown"
                IMLPos = 37
        End Select
    Else
        If Product = "3RAW" Then
            Select Case i
                'Peon Icon
                Case 1, 11, 21, 31, 41
                    Icon = "peon"
                'Human Icons
                Case 2: Icon = "footman"
                Case 3: Icon = "knight"
                Case 4: Icon = "Archmage"
                Case 5: Icon = "Medivh"
                'Night Elf Icons
                Case 12: Icon = "archer"
                Case 13: Icon = "druid of the claw"
                Case 14: Icon = "Priestess of the Moon"
                Case 15: Icon = "Furion"
                'Undead Icons
                Case 22: Icon = "ghoul"
                Case 23: Icon = "abomination"
                Case 24: Icon = "Lich"
                Case 25: Icon = "Tichondrius"
                'Orc Icons
                Case 32: Icon = "grunt"
                Case 33: Icon = "tauren"
                Case 34: Icon = "Far Seer"
                Case 35: Icon = "Thrall"
                'Random Icons
                Case 42: Icon = "dragon whelp"
                Case 43: Icon = "blue dragon"
                Case 44: Icon = "red dragon"
                Case 45: Icon = "Deathwing"
                'else
                Case Else
                    Icon = "unknown"
                    IMLPos = 26
            End Select
        Else
            Select Case i
                'Peon Icon
                Case 1, 11, 21, 31, 41, 51
                    Icon = "peon"
                'Human Icons
                Case 2: Icon = "rifleman"
                Case 3: Icon = "sorceress"
                Case 4: Icon = "spellbreaker"
                Case 5: Icon = "Blood Mage"
                Case 6: Icon = "Jaina Proudmore"
                'Night Elf Icons
                Case 12: Icon = "huntress"
                Case 13: Icon = "druid of the talon"
                Case 14: Icon = "dryad"
                Case 15: Icon = "Keeper of the Grove"
                Case 16: Icon = "Maiev"
                'Undead Icons
                Case 22: Icon = "crypt fiend"
                Case 23: Icon = "banshee"
                Case 24: Icon = "destroyer"
                Case 25: Icon = "Crypt Lord"
                Case 26: Icon = "Sylvanas"
                'Orc Icons
                Case 32: Icon = "headhunter"
                Case 33: Icon = "shaman"
                Case 34: Icon = "Spirit Walker"
                Case 35: Icon = "Shadow Hunter"
                Case 36: Icon = "Rexxar"
                'Random Icons
                Case 42: Icon = "myrmidon"
                Case 43: Icon = "siren"
                Case 44: Icon = "dragon turtle"
                Case 45: Icon = "sea witch"
                Case 46: Icon = "Illidan"
                'Tournament Icons
                Case 52: Icon = "Felguard"
                Case 53: Icon = "infernal"
                Case 54: Icon = "doomguard"
                Case 55: Icon = "pit lord"
                Case 56: Icon = "Archimonde"
                'Everything else
                Case Else
                    Icon = "unknown"
                    IMLPos = 37
                    
            End Select
        End If
    End If
    
    If IMLPos > frmChat.imlIcons.ListImages.Count Then
        IMLPos = ICUNKNOWN
    End If
    'Debug.Print "Icon: " & Icon & "; Race: " & Race & "; IMLPos: " & IMLPos
    
    GetRaceAndIcon = IMLPos
    
End Function

Public Function Conv(ByVal RawString As String) As Long
    Dim lReturn As Long
    
    If Len(RawString) = 4 Then
        Call CopyMemory(lReturn, ByVal RawString, 4)
    Else
        Debug.Print "---------- WARNING: Invalid string length in Conv()!"
        Debug.Print "---------- Length: " & Len(RawString)
        Debug.Print DebugOutput(RawString)
    End If
    
    Conv = lReturn
End Function


'// COLORMODIFY - where L is passed as the start position of the text to be checked
Public Sub ColorModify(ByRef rtb As RichTextBox, ByRef l As Long)
    Dim i As Long, s As Long
    Dim Temp As Long
    
    If l = 0 Then l = 1
    
    Temp = l
    
    With rtb
        If InStr(Temp, .text, "�c", vbTextCompare) > 0 Then
            .Visible = False
            Do
                i = InStr(Temp, .text, "�c", vbTextCompare)
                
                If StrictIsNumeric(Mid$(.text, i + 2, 1)) Then
                    s = GetColorVal(Mid$(.text, i + 2, 1))
                    .SelStart = i - 1
                    .SelLength = 3
                    .SelText = vbNullString
                    .SelStart = i - 1
                    .SelLength = Len(.text) - i
                    .SelColor = s
                Else
                    Select Case Mid$(.text, i + 2, 1)
                        Case "i"
                            .SelStart = i - 1
                            .SelLength = 3
                            .SelText = vbNullString
                            .SelStart = i - 1
                            .SelLength = Len(.text) - 1
                            If .SelItalic = True Then
                                .SelItalic = False
                            Else
                                .SelItalic = True
                            End If
                            
                        Case "b", "."       'BOLD
                            .SelStart = i - 1
                            .SelLength = 3
                            .SelText = vbNullString
                            .SelStart = i - 1
                            .SelLength = Len(.text) - 1
                            If .SelBold = True Then
                                .SelBold = False
                            Else
                                .SelBold = True
                            End If
                            
                        Case "u", "."       'underline
                            .SelStart = i - 1
                            .SelLength = 3
                            .SelText = vbNullString
                            .SelStart = i - 1
                            .SelLength = Len(.text) - 1
                            If .SelUnderline = True Then
                                .SelUnderline = False
                            Else
                                .SelUnderline = True
                            End If
                            
                        Case ";"
                            .SelStart = i - 1
                            .SelLength = 3
                            .SelText = vbNullString
                            .SelStart = i - 1
                            .SelLength = Len(.text) - 1
                            .SelColor = HTMLToRGBColor("8D00CE")    'Purple
                            
                        Case ":"
                            .SelStart = i - 1
                            .SelLength = 3
                            .SelText = vbNullString
                            .SelStart = i - 1
                            .SelLength = Len(.text) - 1
                            .SelColor = 186408      '// Lighter green
                            
                        Case "<"
                            .SelStart = i - 1
                            .SelLength = 3
                            .SelText = vbNullString
                            .SelStart = i - 1
                            .SelLength = Len(.text) - 1
                            .SelColor = HTMLToRGBColor("00A200")    'Dark green
                        'Case Else: Debug.Print s
                    End Select
                End If
                Temp = Temp + 1
                
            Loop While InStr(Temp, .text, "�c", vbTextCompare) > 0
            .Visible = True
        End If
        
        '// Check for SC color codes
        Temp = l
        
        If InStr(Temp, .text, "�", vbBinaryCompare) > 0 Then
            Do
                i = InStr(Temp, .text, "�", vbBinaryCompare)
                s = GetSCColorString(Mid$(.text, i + 1, 1))
                
                If Len(s) > 0 Then
                    .Visible = False
                    .SelStart = i - 1
                    .SelLength = 2
                    .SelText = vbNullString
                    .SelStart = i - 1
                    .SelLength = Len(.text) - 1
                    .SelColor = s
                    .Visible = True
                End If
                
                Temp = Temp + 1
                
            Loop While InStr(Temp, .text, "�", vbBinaryCompare) > 0
        End If
    End With
End Sub

Public Function GetSCColorString(ByVal scCC As String) As String
    Select Case Asc(scCC)
        Case Asc("Q"): GetSCColorString = RGB(93, 93, 93)       'Grey
        Case Asc("R"): GetSCColorString = RGB(30, 224, 54)      'Green
        Case Asc("Z"), Asc("X"), Asc("S"): GetSCColorString = RGB(160, 169, 116)    'Yellow
        Case Asc("Y"), Asc("["), Asc("Y"): GetSCColorString = RGB(231, 38, 82)      'Red
        Case Asc("V"), Asc("@"): GetSCColorString = RGB(98, 77, 232)      'Blue
        Case Asc("W"), Asc("P"): GetSCColorString = vbWhite               'White
        Case Asc("T"), Asc("U"), Asc("V"): GetSCColorString = HTMLToRGBColor("00CCCC") 'cyan/teal
        Case Else: GetSCColorString = vbNullString
    End Select
End Function

Public Function GetColorVal(ByVal d2CC As String) As String
    Select Case CInt(d2CC)
        Case 1: GetColorVal = HTMLToRGBColor("CE3E3E")  'Red
        Case 2: GetColorVal = HTMLToRGBColor("00CE00")  'Green
        Case 3: GetColorVal = HTMLToRGBColor("44409C")  'Blue
        Case 4: GetColorVal = HTMLToRGBColor("A19160")  'Gold
        Case 5: GetColorVal = HTMLToRGBColor("555555")  'Grey
        Case 6: GetColorVal = HTMLToRGBColor("080808")  'Black
        Case 7: GetColorVal = HTMLToRGBColor("A89D65")  'Gold
        Case 8: GetColorVal = HTMLToRGBColor("CE8800")  'Gold-Orange
        Case 9: GetColorVal = HTMLToRGBColor("CECE51")  'Light Yellow
        Case 0: GetColorVal = HTMLToRGBColor("FFFFFF")  'White
    End Select
End Function


'Originally from DPChat by Zorm - cleaned up and adapted to my needs
Public Sub ProfileParse(Data As String)
    On Error Resume Next
    Dim X As Integer
    Dim ProfileEnd As String
    Dim SplitProfile() As String
    
    ProfileEnd = Mid(Data, 17, Len(Data))
    SplitProfile = Split(ProfileEnd, Chr(&H0))
    
    If AwaitingSystemKeys = 1 Then
        
        Event_KeyReturn "System\Account Created", SplitProfile(0)
        Event_KeyReturn "System\Last Logon", SplitProfile(1)
        Event_KeyReturn "System\Last Logoff", SplitProfile(2)
        Event_KeyReturn "System\Time Logged", SplitProfile(3)
        AwaitingSystemKeys = 0
        
    Else
    
        Event_KeyReturn "Profile\Age", SplitProfile(0)
        Event_KeyReturn "Profile\Sex", SplitProfile(1)
        Event_KeyReturn "Profile\Location", SplitProfile(2)
        Event_KeyReturn "Profile\Description", SplitProfile(3)
        
    End If
End Sub
