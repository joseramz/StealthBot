VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsUserStats"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' clsUserStats.cls
' Copyright (C) 2008 Eric Evans

Option Explicit

' game icons
Private Const ICSTAR = 1
Private Const ICSEXP = 2
Private Const ICD2DV = 3
Private Const ICD2XP = 4
Private Const ICW2BN = 5
Private Const ICWAR3 = 6
Private Const ICGAVEL = 7
Private Const ICUNKNOWN = 8
Private Const ICBLIZZ = 9
Private Const ICSYSOP = 103
Private Const ICCHAT = 10
Private Const ICDIABLO = 11
Private Const ICDIABLOSW = 12
Private Const ICSQUELCH = 13
Private Const ICJSTR = 14
Private Const ICWAR3X = 15
Private Const LAG_PLUG = 16
Private Const LAG_1 = 17
Private Const LAG_2 = 18
Private Const LAG_3 = 19
Private Const LAG_4 = 20
Private Const LAG_5 = 21
Private Const LAG_6 = 22
Private Const MONITOR_ONLINE = 23
Private Const MONITOR_OFFLINE = 24
Private Const ICSCSW = 25

' world cyber games icons
Private Const IC_WCG_PLAYER = 89
Private Const IC_WCG_REF = 90
Private Const IC_WCRF = 104
Private Const IC_WCPL = 105
Private Const IC_WCGO = 106
Private Const IC_WCSI = 107
Private Const IC_WCBR = 108
Private Const IC_WCPG = 109

' pgtour icons
Private Const IC_PGT_A = 92
Private Const IC_PGT_B = 95
Private Const IC_PGT_C = 98
Private Const IC_PGT_D = 101

' variables
Private m_stat_string         As String
Private m_game                As String
Private m_icon                As String
Private m_spawn               As Boolean
Private m_clan                As String
Private m_level               As Long
Private m_character_name      As String
Private m_character_class_id  As Integer
Private m_character_flags     As Long
Private m_acts_completed      As Long
Private m_character_ladder    As Boolean
Private m_wins                As Long
Private m_ladder_rating       As Long
Private m_high_rating         As Long
Private m_ladder_rank         As Long
Private m_strength            As Long
Private m_dexterity           As Long
Private m_vitality            As Long
Private m_gold                As Long
Private m_magic               As Long
Private m_dots                As Long
Private m_expansion           As Boolean
Private m_hardcore            As Boolean
Private m_realm               As String
Private m_are_stats_valid     As Boolean

Public Property Let Game(ByVal str As String)
    m_game = str
End Property

Public Property Get Game() As String
    Game = m_game
End Property

Public Property Let IsValid(ByVal bln As Boolean)
    m_are_stats_valid = bln
End Property

Public Property Get IsValid() As Boolean
    IsValid = m_are_stats_valid
End Property

Public Property Get IsWCG() As Boolean
    Select Case (StrReverse$(Icon))
        Case "WCRF": IsWCG = True
        Case "WCPL": IsWCG = True
        Case "WCGO": IsWCG = True
        Case "WCSI": IsWCG = True
        Case "WCBR": IsWCG = True
        Case "WCPG": IsWCG = True
    End Select
End Property

Public Property Let Icon(ByVal str As String)
    m_icon = str
End Property

Public Property Get Icon() As String
    Icon = m_icon
End Property

Public Property Get IconTier() As String
    If ((Game = "WAR3") Or (Game = "W3XP")) Then
        Select Case (Mid$(Icon, 2, 1))
            Case "H": IconTier = "Human"
            Case "N": IconTier = "Night Elf"
            Case "U": IconTier = "Undead"
            Case "O": IconTier = "Orc"
            Case "R": IconTier = "Random"
            Case "D": IconTier = "Tournament"
            Case Else: IconTier = Mid$(Icon, 2, 1)
        End Select
    End If
End Property

Public Property Get IconName() As String
    If ((Game = "WAR3") Or (Game = "W3XP")) Then
        Select Case (StrReverse$(Icon))
            Case "WCRF": IconName = "WCG Referee"
            Case "WCPL": IconName = "WCG Player"
            Case "WCGO": IconName = "WCG Gold Medalist"
            Case "WCSI": IconName = "WCG Silver Medalist"
            Case "WCBR": IconName = "WCG Bronze Medalist"
            Case "WCPG": IconName = "WCG Professional Gamer"
        End Select
        
        If (Len(IconName) > 0) Then
            Exit Property
        End If
    
        Select Case (Mid$(Icon, 2, 1))
            Case "H" ' Human
                If (Game = "WAR3") Then
                    Select Case (Val(Mid(Icon, 1, 1)))
                        Case 1: IconName = "peon"
                        Case 2: IconName = "footman"
                        Case 3: IconName = "knight"
                        Case 4: IconName = "Archmage"
                        Case 5: IconName = "Medivh"
                    End Select
                Else
                    Select Case (Val(Mid(Icon, 1, 1)))
                        Case 1: IconName = "peon"
                        Case 2: IconName = "rifleman"
                        Case 3: IconName = "sorceress"
                        Case 4: IconName = "spellbreaker"
                        Case 5: IconName = "Blood Mage"
                        Case 6: IconName = "Jaina Proudmore"
                    End Select
                End If
            
            Case "N" ' Night Elf
                If (Game = "WAR3") Then
                    Select Case (Val(Mid(Icon, 1, 1)))
                        Case 1: IconName = "peon"
                        Case 2: IconName = "archer"
                        Case 3: IconName = "druid of the claw"
                        Case 4: IconName = "Priestess of the Moon"
                        Case 5: IconName = "Furion"
                    End Select
                Else
                    Select Case (Val(Mid(Icon, 1, 1)))
                        Case 1: IconName = "peon"
                        Case 2: IconName = "huntress"
                        Case 3: IconName = "druid of the talon"
                        Case 4: IconName = "dryad"
                        Case 5: IconName = "Keeper of the Grove"
                        Case 6: IconName = "Maiev"
                    End Select
                End If
                
            Case "U" ' Undead
                If (Game = "WAR3") Then
                    Select Case (Val(Mid(Icon, 1, 1)))
                        Case 1: IconName = "peon"
                        Case 2: IconName = "ghoul"
                        Case 3: IconName = "abomination"
                        Case 4: IconName = "Lich"
                        Case 5: IconName = "Tichondrius"
                    End Select
                Else
                    Select Case (Val(Mid(Icon, 1, 1)))
                        Case 1: IconName = "peon"
                        Case 2: IconName = "crypt fiend"
                        Case 3: IconName = "banshee"
                        Case 4: IconName = "destroyer"
                        Case 5: IconName = "Crypt Lord"
                        Case 6: IconName = "Sylvanas"
                    End Select
                End If
            
            Case "O" ' Orc
                If (Game = "WAR3") Then
                    Select Case (Val(Mid(Icon, 1, 1)))
                        Case 1: IconName = "peon"
                        Case 2: IconName = "grunt"
                        Case 3: IconName = "tauren"
                        Case 4: IconName = "Far Seer"
                        Case 5: IconName = "Thrall"
                    End Select
                Else
                    Select Case (Val(Mid(Icon, 1, 1)))
                        Case 1: IconName = "peon"
                        Case 2: IconName = "headhunter"
                        Case 3: IconName = "shaman"
                        Case 4: IconName = "Spirit Walker"
                        Case 5: IconName = "Shadow Hunter"
                        Case 6: IconName = "Rexxar"
                    End Select
                End If

            Case "R" ' Random
                If (Game = "WAR3") Then
                    Select Case (Val(Mid(Icon, 1, 1)))
                        Case 1: IconName = "peon"
                        Case 2: IconName = "dragon whelp"
                        Case 3: IconName = "blue dragon"
                        Case 4: IconName = "red dragon"
                        Case 5: IconName = "Deathwing"
                    End Select
                Else
                    Select Case (Val(Mid(Icon, 1, 1)))
                        Case 1: IconName = "peon"
                        Case 2: IconName = "myrmidon"
                        Case 3: IconName = "siren"
                        Case 4: IconName = "dragon turtle"
                        Case 5: IconName = "sea witch"
                        Case 6: IconName = "Illidan"
                    End Select
                End If

            Case "D" ' Tournament
                If (Game = "W3XP") Then
                    Select Case (Val(Mid(Icon, 1, 1)))
                        Case 1: IconName = "peon"
                        Case 2: IconName = "Felguard"
                        Case 3: IconName = "infernal"
                        Case 4: IconName = "doomguard"
                        Case 5: IconName = "pit lord"
                        Case 6: IconName = "Archimonde"
                    End Select
                End If
        End Select
        
        If (IconName = vbNullString) Then
            IconName = "unknown"
        End If
    End If
End Property

Public Property Let Statstring(ByVal str As String)
    If (Len(str) < 4) Then
        Exit Property
    End If
    Game = StrReverse$(Left$(str, 4))
    If (Len(str) >= 5) Then
        str = Mid$(str, 5)
        
        If (Left$(str, 1) = " ") Then
            str = Mid$(str, 2)
        End If
        
        m_stat_string = str
    
        Call Parse
    End If
End Property

Public Property Get Statstring() As String
    Statstring = m_stat_string
End Property

Public Property Get IsSpawn() As Boolean
    IsSpawn = m_spawn
End Property

Public Property Let IsSpawn(ByVal bln As Boolean)
    m_spawn = bln
End Property

Public Property Get Clan() As String
    Clan = m_clan
End Property

Public Property Let Clan(ByVal str As String)
    m_clan = str
End Property

Public Property Get Wins() As Long
    Wins = m_wins
End Property

Public Property Let Wins(ByVal lng As Long)
    m_wins = lng
End Property

Public Property Get LadderRating() As Long
    LadderRating = m_ladder_rating
End Property

Public Property Let LadderRating(ByVal lng As Long)
    m_ladder_rating = lng
End Property

Public Property Get HighLadderRating() As Long
    HighLadderRating = m_high_rating
End Property

Public Property Let HighLadderRating(ByVal lng As Long)
    m_high_rating = lng
End Property

Public Property Get LadderRank() As Long
    LadderRank = m_ladder_rank
End Property

Public Property Let LadderRank(ByVal lng As Long)
    m_ladder_rank = lng
End Property

Public Property Get Level() As Long
    Level = m_level
End Property

Public Property Let Level(ByVal lng As Long)
    m_level = lng
End Property

Public Property Get CharacterName() As String
    CharacterName = m_character_name
End Property

Public Property Let CharacterName(ByVal str As String)
    m_character_name = str
End Property

Public Property Get CharacterClassID() As Integer
    CharacterClassID = m_character_class_id
End Property

Public Property Let CharacterClassID(ByVal i As Integer)
    m_character_class_id = i
End Property

Public Property Get CharacterClass() As String
    On Error GoTo ERROR_HANDLER
    
    If ((Game = "DSHR") Or (Game = "DRTL")) Then
        Dim DIClasses(0 To 3) As String
        
        DIClasses(0) = "Warrior"
        DIClasses(1) = "Rogue"
        DIClasses(2) = "Sorceror"
        
        If (CharacterClassID < UBound(DIClasses)) Then
            CharacterClass = DIClasses(CharacterClassID)
        End If
        
    ElseIf ((Game = "D2DV") Or (Game = "D2XP")) Then
    
        Dim DIIClasses(0 To 7) As String
        
        DIIClasses(0) = "Amazon"
        DIIClasses(1) = "Sorceress"
        DIIClasses(2) = "Necromancer"
        DIIClasses(3) = "Paladin"
        DIIClasses(4) = "Barbarian"
        DIIClasses(5) = "Druid"
        DIIClasses(6) = "Assassin"
    
        If (CharacterClassID - 1 < UBound(DIIClasses)) Then
            CharacterClass = DIIClasses(CharacterClassID - 1)
        End If
    End If
    
    Exit Property
    
ERROR_HANDLER:
    IsValid = False
    Exit Property
End Property

Public Property Let CharacterFlags(ByVal lng As Long)
    m_character_flags = lng
End Property

Public Property Get CharacterFlags() As Long
    CharacterFlags = m_character_flags
End Property

Public Property Get IsHardcoreCharacter() As Boolean
    IsHardcoreCharacter = ((CharacterFlags And &H4) = &H4)
End Property

Public Property Get IsFemaleCharacter() As Boolean
    IsFemaleCharacter = _
        ((m_character_class_id = 1) Or (m_character_class_id = 2) Or _
            (m_character_class_id = 7))
End Property

Public Property Get IsExpansionCharacter() As Boolean
    If (StrReverse$(Game) = "D2XP") Then
        IsExpansionCharacter = True
    Else
        IsExpansionCharacter = ((CharacterFlags And &H20) = &H20)
    End If
End Property

Public Property Get IsCharacterDead() As Boolean
    IsCharacterDead = ((IsHardcoreCharacter) And ((CharacterFlags And &H8) = &H8))
End Property

Public Property Let IsLadderCharacter(ByVal bln As Boolean)
    m_character_ladder = bln
End Property

Public Property Get IsLadderCharacter() As Boolean
    IsLadderCharacter = m_character_ladder
End Property

Public Property Get ActsCompleted() As Integer
    ActsCompleted = m_acts_completed
End Property

Public Property Let ActsCompleted(ByVal i As Integer)
    m_acts_completed = i
End Property

Public Property Get CurrentAct() As Integer
    If ((Game() = "D2DV") Or (Game() = "D2XP")) Then
        If (IsExpansionCharacter() = False) Then
            CurrentAct = ((ActsCompleted() Mod 4) + 1)
        Else
            CurrentAct = ((ActsCompleted() Mod 5) + 1)
        End If
    End If
End Property

Public Property Get CurrentDifficulty() As String
    If ((Game = "D2DV") Or (Game = "D2XP")) Then
        Select Case (CurrentDifficultyID)
            Case 0: CurrentDifficulty = "Normal"
            Case 1: CurrentDifficulty = "Nightmare"
            Case 2: CurrentDifficulty = "Hell"
        End Select
    End If
End Property

Public Property Get CurrentDifficultyID() As Integer
    Dim difficulty As Integer
    
    If ((Game = "D2DV") Or (Game = "D2XP")) Then
        If (IsExpansionCharacter = False) Then
            difficulty = Fix(ActsCompleted / 4)
        Else
            difficulty = Fix(ActsCompleted / 5)
        End If
    End If
    CurrentDifficultyID = difficulty
End Property

Public Property Get CharacterTitle() As String
    On Error GoTo ERROR_HANDLER

    ' thanks c0ol for multi-dimensional array idea
    Dim Classic(2, 3, 2)   As String
    Dim Expansion(2, 3, 2) As String
    
    ' softcore
    Classic(0, 0, 0) = "Sir"
    Classic(0, 0, 1) = "Dame"
    Classic(0, 1, 0) = "Lord"
    Classic(0, 1, 1) = "Lady"
    Classic(0, 2, 0) = "Baron"
    Classic(0, 2, 1) = "Baroness"
    
    ' hardcore
    Classic(1, 0, 0) = "Count"
    Classic(1, 0, 1) = "Countess"
    Classic(1, 1, 0) = "Duke"
    Classic(1, 1, 1) = "Duchess"
    Classic(1, 2, 0) = "King"
    Classic(1, 2, 1) = "Queen"
    
    ' softcore
    Expansion(0, 0, 0) = "Slayer"
    Expansion(0, 1, 0) = "Champion"
    Expansion(0, 2, 0) = "Patriarch"
    Expansion(0, 2, 1) = "Matriarch"
    
    ' hardcore
    Expansion(1, 0, 0) = "Destroyer"
    Expansion(1, 1, 0) = "Conquerer"
    Expansion(1, 2, 0) = "Guardian"
    
    If ((Game = "D2DV") Or (Game = "D2XP")) Then
        If (CurrentDifficultyID >= 1) Then
            If (IsExpansionCharacter = False) Then
                CharacterTitle = _
                    Classic(IIf(IsHardcoreCharacter, 1, 0), CurrentDifficultyID - 1, IIf(IsFemaleCharacter, 1, 0))
            
                ' run again with is female as false
                If (CharacterTitle = vbNullString) Then
                    CharacterTitle = Classic(IIf(IsHardcoreCharacter, 1, 0), CurrentDifficultyID - 1, 0)
                End If
            Else
                CharacterTitle = _
                    Expansion(IIf(IsHardcoreCharacter, 1, 0), CurrentDifficultyID - 1, IIf(IsFemaleCharacter, 1, 0))
            
                ' run again with is female as false
                If (CharacterTitle = vbNullString) Then
                    CharacterTitle = Expansion(IIf(IsHardcoreCharacter, 1, 0), CurrentDifficultyID - 1, 0)
                End If
            End If
        End If
    End If
    
    Exit Property
    
ERROR_HANDLER:
    CharacterTitle = vbNullString
    
    Exit Property
End Property

Public Property Get Dots() As Long
    Dots = m_dots
End Property

Public Property Let Dots(ByVal lng As Long)
    m_dots = lng
End Property

Public Property Get Strength() As Long
    Strength = m_strength
End Property

Public Property Let Strength(ByVal lng As Long)
    m_strength = lng
End Property

Public Property Get Magic() As Long
    Magic = m_magic
End Property

Public Property Let Magic(ByVal lng As Long)
    m_magic = lng
End Property

Public Property Get Gold() As Long
    Gold = m_gold
End Property

Public Property Let Gold(ByVal lng As Long)
    m_gold = lng
End Property

Public Property Get Dexterity() As Long
    Dexterity = m_dexterity
End Property

Public Property Let Dexterity(ByVal lng As Long)
    m_dexterity = lng
End Property

Public Property Get Vitality() As Long
    Vitality = m_vitality
End Property

Public Property Let Vitality(ByVal lng As Long)
    m_vitality = lng
End Property

Public Property Get Realm() As String
    Realm = m_realm
End Property

Public Property Let Realm(ByVal str As String)
    m_realm = str
End Property

Public Property Get ToString() As String
    Dim buf As String
    
    buf = MakeLongGameName(Game)
    
    Select Case (Game)
        Case "SSHR", "STAR", "JSTR", "SEXP"
            buf = buf & StarCraft_ToString()
            
        Case "DSHR", "DRTL"
            buf = buf & Diablo_ToString()
            
        Case "D2DV", "D2XP"
            buf = buf & DiabloII_ToString()

        Case "W2BN"
            buf = buf & WarCraftII_ToString()
        
        Case "WAR3", "W3XP"
            buf = buf & WarCraftIII_ToString()
            
        Case Else
            Exit Property
    End Select
    
    'buf = buf & "."
    
    ToString = buf
End Property

Public Property Get IconCode() As Integer
    Dim intWins As Integer
    
    If (BotVars.ShowStatsIcons) Then
        Select Case (StrReverse$(Icon))
            Case "WCRF": IconCode = IC_WCRF
            Case "WCPL": IconCode = IC_WCPL
            Case "WCGO": IconCode = IC_WCGO
            Case "WCSI": IconCode = IC_WCSI
            Case "WCBR": IconCode = IC_WCBR
            Case "WCPG": IconCode = IC_WCPG
        End Select
        
        If (IconCode) Then
            Exit Property
        End If
        
        Select Case Game
            Case "DRTL"
                If (IsValid) Then
                    IconCode = (ICON_START_DRTL + CharacterClassID)
                End If
                
            Case "DSHR"
                If (IsValid) Then
                    IconCode = ICON_START_DSHR
                End If
            
            Case "D2DV", "D2XP"
                If (LenB(Statstring) > 0) Then
                    IconCode = (ICON_START_D2 + CharacterClassID - 1)
                End If
            
            Case "STAR", "SEXP"
                intWins = Wins
                If (intWins > 10) Then intWins = 10
                IconCode = (ICON_START_SC + intWins)
            
            Case "W2BN"
                intWins = Wins
                If (intWins > 10) Then intWins = 10
                IconCode = (ICON_START_W2 + intWins)
            
            Case "WAR3", "W3XP"
                IconCode = _
                    GetRaceAndIcon(Val(Mid$(Icon(), 1, 1)), Mid$(Icon(), 2, 1), StrReverse$(Game), _
                        IIf(IsWCG, Icon, ""))

                If (IconCode <> ICUNKNOWN) Then
                    If (Game = "W3XP") Then
                        IconCode = (ICON_START_W3XP + IconCode)
                    Else
                        IconCode = (ICON_START_WAR3 + IconCode)
                    End If
                End If
            
        End Select
    End If
    
    If ((IconCode = 0) Or (IconCode = ICUNKNOWN)) Then
        Select Case (Game)
            Case "CHAT": IconCode = ICCHAT
            Case "SSHR": IconCode = ICSCSW
            Case "STAR": IconCode = ICSTAR
            Case "JSTR": IconCode = ICJSTR
            Case "SEXP": IconCode = ICSEXP
            Case "DSHR": IconCode = ICDIABLOSW
            Case "DRTL": IconCode = ICDIABLO
            Case "W2BN": IconCode = ICW2BN
            Case "D2DV": IconCode = ICD2DV
            Case "D2XP": IconCode = ICD2XP
            Case "WAR3": IconCode = ICWAR3
            Case "W3XP": IconCode = ICWAR3X
            Case Else:   IconCode = ICUNKNOWN
        End Select
    End If
End Property

Private Sub Parse()
    On Error GoTo ERROR_HANDLER
    
    IsValid = True
    If (Statstring = vbNullString) Then
        Exit Sub
    End If
    Select Case (Game)
        Case "SSHR", "STAR", "JSTR", "SEXP"
            Call ParseStarCraft
            
        Case "DSHR", "DRTL"
            Call ParseDiablo
            
        Case "D2DV", "D2XP"
            Call ParseDiabloII

        Case "W2BN"
            Call ParseWarCraftII
        
        Case "WAR3", "W3XP"
            Call ParseWarCraftIII
    End Select
    
    Exit Sub
    
ERROR_HANDLER:
    IsValid = False
    
    Exit Sub
End Sub

Private Sub ParseStarCraft()
    Dim Values() As String
    
    ReDim Preserve Values(0)
    Values() = Split(Statstring, Space$(1))
    
    If (UBound(Values) <> 8) Then
        IsValid = False
    
        Exit Sub
    End If
            
    LadderRating = Val(Values(0))
    LadderRank = Val(Values(1))
    Wins = Val(Values(2))
    IsSpawn = CBool(Val(Values(3)))
    LadderRank = Val(Values(5))
    Icon = CStr(Values(8))
End Sub

Private Sub ParseDiablo()
    Dim Values() As String
    
    ReDim Preserve Values(0)
    Values() = Split(Statstring, Space$(1))
    
    If (UBound(Values) <> 8) Then
        IsValid = False
    
        Exit Sub
    End If
    
    Level = Val(Values(0))
    CharacterClassID = Val(Values(1))
    Dots = Val(Values(2))
    Strength = Val(Values(3))
    Magic = Val(Values(4))
    Dexterity = Val(Values(5))
    Vitality = Val(Values(6))
    Gold = Val(Values(7))
    
End Sub

Private Sub ParseDiabloII()
    Dim Values()   As String
    Dim charData() As Integer
    
    ReDim Preserve Values(0)
    Values() = Split(Statstring, ",", 3)
  
    If (UBound(Values) >= 1) Then
        Realm = Values(0)
        CharacterName = Values(1)
        
        If (UBound(Values) >= 2) Then
            MakeArr Values(2), charData
        
            CharacterClassID = charData(13)
            Level = charData(25)
            CharacterFlags = charData(26)
        
            If (UBound(charData) >= 26) Then
                ActsCompleted = ((charData(27) Xor &H80) / 2)

                IsLadderCharacter = (charData(30) <> &HFF)
            End If
        End If
    End If
End Sub

Private Sub ParseWarCraftII()
    Call ParseStarCraft
End Sub

Private Sub ParseWarCraftIII()
    Dim Values() As String
    
    ReDim Preserve Values(0)
    Values() = Split(Statstring, Space$(1))
    
    If (UBound(Values) = 0) Then
        Exit Sub
    End If
    
    Icon = Values(0)
    Level = Val(Values(1))
    
    If (UBound(Values) > 1) Then
        Clan = StrReverse$(Values(2))
    End If
End Sub

Private Function StarCraft_ToString() As String
    Dim buf As String
    
    If ((Statstring = vbNullString) Or (IsValid = False)) Then
        buf = " (No stats available)"
    Else
        buf = _
            " (" & Wins() & " wins" & IIf(LadderRating(), ", with a rating of " & LadderRating() & _
                " on the ladder", "") & ")"
    End If
            
    If (IsSpawn()) Then
        buf = buf & " (spawn)"
    End If
    
    StarCraft_ToString = buf
End Function

Private Function Diablo_ToString() As String
    Dim buf As String
    
    If ((Statstring = vbNullString) Or (IsValid = False)) Then
        buf = " (No stats available)"
    Else
        buf = _
            " (Level " & Level() & " " & CharacterClass() & " with " & Dots() & " dots, " & Strength() & _
                " strength, " & Magic() & " magic, " & Dexterity() & " dexterity, " & Vitality() & _
                    " vitality, and " & Gold() & " gold)"
    End If
    
    If (IsSpawn()) Then
        buf = buf & " (spawn)"
    End If
    Diablo_ToString = buf
End Function

Private Function DiabloII_ToString() As String
    Dim buf As String
    If ((Statstring = vbNullString) Or (IsValid = False)) Then
        buf = " (Open Character)"
    Else
        buf = " ("

        If (Len(CharacterTitle()) > 0) Then
            buf = buf & CharacterTitle() & " "
        End If

        buf = _
            buf & CharacterName() & ", a " & IIf(IsCharacterDead(), "dead ", vbNullString) & _
                IIf(IsHardcoreCharacter(), "hardcore ", vbNullString) & "level " & Level() & " " & _
                    IIf(IsLadderCharacter(), "ladder ", vbNullString) & CharacterClass()
        
        buf = _
            buf & " on " & Realm() & ")"
    End If
    
    DiabloII_ToString = buf
End Function

Private Function WarCraftII_ToString() As String
    WarCraftII_ToString = StarCraft_ToString()
End Function

Private Function WarCraftIII_ToString() As String
    Dim buf As String
    
    If ((Statstring = vbNullString) Or (IsValid = False)) Then
        buf = " (No stats available)"
    Else
        If (IsWCG) Then
            buf = " (" & IconName() & " icon"
        Else
            buf = " (Level: " & Level() & ", icon tier " & IconTier() & ", " & IconName() & _
                    " icon"
        End If
        
        If (Clan() <> vbNullString) Then
            buf = buf & ", in clan " & Clan()
        End If
        
        buf = buf & ")"
    End If
            
    WarCraftIII_ToString = buf
End Function

Private Sub MakeArr(ByVal str As String, ByRef arr() As Integer)
    Dim i As Integer
    
    ReDim arr(0)
    
    For i = 1 To Len(str)
        If (i > 1) Then
            ReDim Preserve arr(0 To i - 1)
        End If
        
        arr(i - 1) = Asc(Mid(str, i, 1))
    Next i
End Sub

Private Function MakeLongGameName(ByVal Game As String) As String
    Select Case (Game)
        ' chat/telnet
        Case "CHAT": MakeLongGameName = "Chat"
    
        ' starcraft
        Case "SSHR": MakeLongGameName = "StarCraft: Shareware"
        Case "STAR": MakeLongGameName = "StarCraft"
        Case "JSTR": MakeLongGameName = "StarCraft: Japanese"
        Case "SEXP": MakeLongGameName = "StarCraft: Brood War"

        ' diablo
        Case "DSHR": MakeLongGameName = "Diablo I: Shareware"
        Case "DRTL": MakeLongGameName = "Diablo I: Retail"

        ' diablo ii
        Case "D2DV": MakeLongGameName = "Diablo II"
        Case "D2XP": MakeLongGameName = "Diablo II: Lord of Destruction"

        ' warcraft ii
        Case "W2BN": MakeLongGameName = "WarCraft II"

        ' warcraft iii
        Case "WAR3": MakeLongGameName = "WarCraft III: Reign of Chaos"
        Case "W3XP": MakeLongGameName = "WarCraft III: The Frozen Throne"
    End Select
End Function

Private Function MakeRomanNum(ByVal Num As Integer) As String
    Select Case (Num)
        Case 1: MakeRomanNum = "I"
        Case 2: MakeRomanNum = "II"
        Case 3: MakeRomanNum = "III"
        Case 4: MakeRomanNum = "IV"
        Case 5: MakeRomanNum = "V"
    End Select
End Function
