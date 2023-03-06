; enum for version types
!__VER_J = 0
!__VER_U = 1
!__VER_SS = 2
!__VER_E0 = 3
!__VER_E1 = 4


; ==== SNES Functionality Constants ====
; (Prolly not a good idea to mess with these)

; number of OBJs in OAM
!OBJCount = 128

; position for OBJs so they don't show on screen
!OBJOffscreen = $F0

; bit for making OBJs large in size
!OBJBigSize = %10
    !QuadOBJBigSize = %10101010

; effective size of screen in lines
; used a lot for windowing effects
!ScreenHeight = con(224,224,224,224,240)
; screen of screen in dots
!ScreenWidth = 256

; number of tiles across in one BG page
!BGWidthInTiles = 32
; number of tiles in one BG page
!TilesPerBGPage = !BGWidthInTiles*!BGWidthInTiles
; number of tiles vertically the bottom half of a horizontal level uses
!BGHeightInTiles = 22

; ==== SMW Property Constants ====

; --- General Game ---

; tile used for empty spaces on layer 3
!EmptyTile = $38FC

; tile used for dragon coin on layer 3
!HUDDragonCoinTile = $2E

; maximum number of screens in a level
!LevelMaxScreens = 32

; size of a save file
!SaveFileSize = 143

; number of exits to make *96 appear on title screen
!TotalExitCount = 96

; --- In-Level Properties ---

; height of status bar in lines
!StatusBarHeight = 36

; properties regarding size and position of status bar
!WidthOfHUDL1 = 28
!WidthOfHUDL2 = 27
!WidthOfItemBox = 4
!OffsetOfStatusBar = 2
!OffsetOfItemBox = 14
    !StatusBarTileCount = !WidthOfHUDL1+!WidthOfHUDL2
    !VRAMAddrHUD1 = VRam_L3Tilemap+!BGWidthInTiles+!OffsetOfItemBox
    !VRAMAddrHUD2 = VRam_L3Tilemap+2*!BGWidthInTiles+!OffsetOfStatusBar
    !VRAMAddrHUD3 = VRam_L3Tilemap+3*!BGWidthInTiles+!OffsetOfStatusBar+1
    !VRAMAddrHUD4 = VRam_L3Tilemap+4*!BGWidthInTiles+!OffsetOfItemBox
!HUDDragonsOffset = 6
!HUDBigStarsOffset = 10
!HUDCoinsOffset = 26
!HUDLivesOffset = 29
!HUDSmallStarsOffset = 37
    !HUDSmallStarsOffsetL2 = !HUDSmallStarsOffset-!WidthOfHUDL1
!HUDTimerOffset = 44
!HUDScoreOffset = 48
    !HUDScoreOffsetL2 = !HUDScoreOffset-!WidthOfHUDL1

; number of frames in one in-game second
!FramesInOneIGT = con(41,41,41,35,35)
; maximum score
!MaximumScore = 999999
; maximum lives
!MaximumLives = 99
; coins in one 1up
!CoinsPer1up = 100
; bonus stars for bonus game
!MaximumBonusStars = 100
; number of dragon coins to display
!MaximumDragonCoins = 5
; position of reserve item
!ReserveItemXPos = $78
!ReserveItemYPos = 15

; number of coins to get a 1up from a green star block
!GreenStarBlockCoins = 30

; -- Cutscenes --

; X position of "MARIO START !"
!MarioStartXPos = $B0
; X position of "BONUS GAME"
!BonusGameXPos = $A4
; Y position of all starting screen text
!StartScreenTextYPos = $68
; X positions of "GAME OVER" and "TIME UP !"
!GameOverXPosLeft = $78
!GameOverXPosRight = $A0
; OAM slot to start using for starting screen text
!SrtOAMSlot = 66

; GAME OVER disappears when timer reaches this value
!GameOverThreshold = con(0,0,0,48,48)

; Y position of Nintendo Presents logo
!NintendoPresentsYPos = $70
; Number of frames Nintendo Presents exists
!NintendoPresentsTimer = 64

; maximum size of spotlight on title screen
!MaxTitleSpotlightSize = 59

; starting position of Mario in castle cutscenes
!CastleCutsceneMarioXPos = $90
!CastleCutsceneMarioYPos = $58

; number of interpolated palette values when fading
; to and from black at the end of a level
!PaletteFadeCount = 32

; number of frames to wait until drumroll starts
!DrumrollInit = 80

; -- Boss Fights --

; ceiling heights for mode 7 boss rooms
!RoyMortonCeilingHeight = 42
!LudwigCeilingHeight = 18
!BowserCeilingHeight = 0
!ReznorCeilingHeight = -19

; floor heights for mode 7 boss rooms
!BossFloorHeight = 174

; height of solid lava in Iggy/Larry
!IggyLavaHeight = 204

; number of OBJs to reserve for background in Roy/Morton/Ludwig
!BossBGOBJCount = 100

; --- Overworld Properties ---

; number of levels on the main map
!MainMapLvls = 36
; special translevel numbers
!IntroCutsceneLevel = $C5
!TitleScreenLevel = $C7
!YoshisHouse = $28

; level tile ID to not show MARIO START !
!LevelTileNoStart = $56

; initial position of players on the overworld
!InitOWPosX = $68
!InitOWPosY = $78

; --- Credits Properties ---

; Scanline that background HDMA table starts to use
!CreditsBGOffsetStart = 88


; -- Values for PlayerAnimation --
!PAni_Standard = 0
!PAni_IFrames = 1
!PAni_GetMushroom = 2
!PAni_GetFeather = 3
!PAni_GetFlower = 4
!PAni_EnterPipeHoriz = 5
!PAni_EnterPipeVert = 6
!PAni_PipeCanon = 7
!PAni_GetWings = 8
!PAni_EndLevel = 9
!PAni_CastleEntrance = 10
!PAni_Frozen = 11
!PAni_CastleDestroy = 12
!PAni_EnterDoor = 13

; -- Values for CutsceneID --
!Cutscene_Iggy = 1
!Cutscene_Morton = 2
!Cutscene_Lemmy = 3
!Cutscene_Ludwig = 4
!Cutscene_Roy = 5
!Cutscene_Wendy = 6
!Cutscene_Larry = 7
!Cutscene_Credits = 8

; -- Values for SpriteTileset --
!SprTileset_Forest = 0
!SprTileset_Castle = 1
!SprTileset_Mushroom = 2
!SprTileset_Underground1 = 3
!SprTileset_Water = 4
!SprTileset_Pokey = 5
!SprTileset_Underground2 = 6
!SprTileset_GhostHouse = 7
!SprTileset_BanzaiBill = 8
!SprTileset_YoshisHouse = 9
!SprTileset_DinoRhino = 10
!SprTileset_SwitchPalace = 11
!SprTileset_MechaKoopa = 12
!SprTileset_WendyLemmy = 13
!SprTileset_Ninji = 14
!SprTileset_Unused = 15
!SprTileset_Overworld = 17
!SprTileset_RoyMortonLudwig = 18
!SprTileset_ReznorIggyLarry = 19
!SprTileset_CastleCutscene = 20
!SprTileset_CreditsParade = 21
!SprTileset_CreditsThankYou = 22
!SprTileset_CreditsKoopalings = 23
!SprTileset_Bowser = 24
!SprTileset_TheEnd = 25

; -- Values for ObjectTileset --
!ObjTileset_Normal1 = 0
!ObjTileset_Castle1 = 1
!ObjTileset_Rope1 = 2
!ObjTileset_Underground1 = 3
!ObjTileset_SwitchPalace1 = 4
!ObjTileset_GhostHouse1 = 5
!ObjTileset_Rope2 = 6
!ObjTileset_Normal2 = 7
!ObjTileset_Rope3 = 8
!ObjTileset_Underground2 = 9
!ObjTileset_SwitchPalace2 = 10
!ObjTileset_Castle2 = 11
!ObjTileset_CloudForest = 12
!ObjTileset_GhostHouse2 = 13
!ObjTileset_Underground3 = 14
!ObjTileset_MainMap = 17
!ObjTileset_YoshisIsland = 18
!ObjTileset_VanillaDome = 19
!ObjTileset_ForestOfIllusion = 20
!ObjTileset_ValleyOfBowser = 21
!ObjTileset_SpecialWorld = 22
!ObjTileset_StarWorld = 23
!ObjTileset_CastleCutscene = 24
!ObjTileset_CreditsParade = 25
!ObjTileset_ReznorIggyLarry = -1
!ObjTileset_RoyMortonLudwig = -2

; -- Values for ActiveBoss --
!ActiveBoss_Morton = 0
!ActiveBoss_Roy = 1
!ActiveBoss_Ludwig = 2
!ActiveBoss_Bowser = 3
!ActiveBoss_Reznor = 4

; -- Values for BlinkCursor --
!CursorContinueEnd = 0
!CursorFileSelect = 2
!CursorPlayerSelect = 4
!CursorSaveNoSave = 6
!CursorEraseFile = 8

; -- Values for Overworld Submaps --
!Submap_Main = 0
!Submap_YoshisIsland = 1
!Submap_VanillaDome = 2
!Submap_ForestOfIllusion = 3
!Submap_ValleyOfBowser = 4
!Submap_SpecialWorld = 5
!Submap_StarWorld = 6

; --- SFX & BGM ID Numbers ---

; values for SPC commands to trigger music and sound effects
; port 0
!SFX_BONK = 1
!SFX_SPLAT = 2
!SFX_KICK = 3
!SFX_PIPE = 4
!SFX_MIDWAY = 5
!SFX_GULP = 6
!SFX_BONES = 7
!SFX_SPINKILL = 8
!SFX_CAPE = 9
!SFX_MUSHROOM = 10
!SFX_SWITCH = 11
!SFX_ITEMGOAL = 12
!SFX_FEATHER = 13
!SFX_SWIM = 14
!SFX_FLYHIT = 15
!SFX_MAGIC = 16
!SFX_PAUSE = 17
!SFX_UNPAUSE = 18
!SFX_STOMP1 = 19
!SFX_STOMP2 = 20
!SFX_STOMP3 = 21
!SFX_STOMP4 = 22
!SFX_STOMP5 = 23
!SFX_STOMP6 = 24
!SFX_STOMP7 = 25
!SFX_GRINDER = 26
!SFX_DRAGONCOIN = 28
!SFX_PBALLOON = 30
!SFX_BOSSDEAD = 31
!SFX_SPIT = 32
!SFX_RUMBLINGON = 33
!SFX_RUMBLINGOFF = 34
!SFX_FALL = 35
!SFX_NOTICEMESENPAI = 36 ; unused sfx that doesn't actually exist
!SFX_BLARGG = 37
!SFX_FIREWORKFIRE1 = 38
!SFX_FIREWORKBANG1 = 39
!SFX_FIREWORKFIRE2 = 40
!SFX_FIREWORKBANG2 = 41
!SFX_PEACHHELP = 42
!SFX_HURRYUP = -1
; port 1
!SFX_JUMP = 1
!SFX_YOSHIDRUMON = 2
!SFX_YOSHIDRUMOFF = 3
!SFX_BLOCKSNAKE = 4
; port 2
!BGM_ATHLETIC = 1
!BGM_OVERWORLD = 2
!BGM_UNDERWATER = 3
!BGM_BOWSERSTART = 4
!BGM_BOSSFIGHT = 5
!BGM_UNDERGROUND = 6
!BGM_GHOSTHOUSE = 7
!BGM_CASTLE = 8
!BGM_DEATH = 9
!BGM_GAMEOVER = 10
!BGM_BOSSCLEAR = 11
!BGM_LEVELCLEAR = 12
!BGM_STARPOWER = 13
!BGM_PSWITCH = 14
!BGM_KEYHOLE = 15
!BGM_KEYHOLE2 = 16
!BGM_SPOTLIGHT = 17
!BGM_BONUSGAME = 18
!BGM_CUTSCENEFULL = 19
!BGM_BONUSOVER = 20
!BGM_CUTSCENEINTRO = 21
!BGM_BOWSERINTERLUDE = 22
!BGM_BOWSERZOOMOUT = 23
!BGM_BOWSERZOOMIN = 24
!BGM_BOWSERPHASE2 = 25
!BGM_BOWSERPHASE3 = 26
!BGM_BOWSERDEFEATED = 27
!BGM_PEACHSAVED = 28
!BGM_BOWSERINTERLUDE2 = 29
!BGM_TITLESCREEN = 1
!BGM_DONUTPLAINS = 2
!BGM_YOSHISISLAND = 3
!BGM_VANILLADOME = 4
!BGM_STARWORLD = 5
!BGM_FORESTOFILLUSION = 6
!BGM_VALLEYOFBOWSER = 7
!BGM_VALLEYOPENS = 8
!BGM_SPECIALWORLD = 9
!BGM_STAFFCREDITS = 9
!BGM_CREDITSYOSHISHOUSE = 10
!BGM_CREDITSTHANKYOU = 11
!BGM_FADEOUT = %10000000
; port 3
!SFX_COIN = 1
!SFX_ITEMBLOCK = 2
!SFX_VINEBLOCK = 3
!SFX_SPIN = 4
!SFX_1UP = 5
!SFX_FIREBALL = 6
!SFX_SHATTER = 7
!SFX_SPRING = 8
!SFX_KAPOW = 9
!SFX_EGGHATCH = 10
!SFX_ITEMRESERVED = 11
!SFX_ITEMDEPLOYED = 12
!SFX_SCREENSCROLL = 14
!SFX_DOOROPEN = 15
!SFX_DOORCLOSE = 16
!SFX_DRUMROLLSTART = 17
!SFX_DRUMROLLEND = 18
!SFX_YOSHIHURT = 19
!SFX_NEWLEVEL = 21
!SFX_CASTLECRUSH = 22
!SFX_FIRESPIT = 23
!SFX_THUNDER = 24
!SFX_CLAP = 25
!SFX_CUTSCENEBOMB = 26
!SFX_CUTSCENEFUSE = 27
!SFX_SWITCHBLOCK = 28
!SFX_WHISTLE = 30
!SFX_YOSHI = 31
!SFX_BOSSINLAVA = 32
!SFX_YOSHITONGUE = 33
!SFX_MESSAGE = 34
!SFX_BEEP = 35
!SFX_RUNNINGOUT = 36
!SFX_YOSHISTOMP = 37
!SFX_SWOOPER = 38
!SFX_PODOBOO = 39
!SFX_ENEMYHURT = 40
!SFX_CORRECT = 41
!SFX_WRONG = 42
!SFX_FIREWORKFIRE3 = 43
!SFX_FIREWORKBANG3 = 44
!SFX_BOWSERFIRE1 = 45
!SFX_BOWSERFIRE2 = 46
!SFX_BOWSERFIRE3 = 47
!SFX_BOWSERFIRE4 = 48
!SFX_BOWSERFIRE5 = 49
!SFX_BOWSERFIRE6 = 50
!SFX_BOWSERFIRE7 = 51
!SFX_BOWSERFIRE8 = 52

; -- Graphics File IDs --
    !GFX_DecompSize = $C00
!GFX00_Powerups = 0
!GFX01_KoopaGoomba = 1
!GFX02_SpinyLakitu = 2
!GFX03_ThwompMagikoopa = 3
!GFX04_BuzzyBlargg = 4
!GFX05_Chainsaw = 5
!GFX06_UrchinDolphin = 6
!GFX07_GhostHouse = 7
!GFX08_YoshisHouse = 8
!GFX09_SumoPokey = 9
!GFX0A_WendyLemmy = 10
!GFX0B_RoyMortonLudwig = 11
!GFX0C_Underground = 12
!GFX0D_PrincessPeach = 13
!GFX0E_NinjiDisco = 14
!GFX0F_MarioStart = 15
!GFX10_OWSprites = 16
!GFX11_BigBooEerie = 17
!GFX12_DryBonesGrinder = 18
!GFX13_HammerBroChuck = 19
!GFX14_OWAnimation = 20
!GFX15_GrassTiles = 21
!GFX16_RopeTiles = 22
!GFX17_DiagonalPipe = 23
!GFX18_CastleTiles = 24
!GFX19_ForestHillBG = 25
!GFX1A_CaveTiles = 26
!GFX1B_PillarCastleBG = 27
!GFX1C_OWTiles1 = 28
!GFX1D_OWTiles2 = 29
!GFX1E_OELevelIcons = 30
!GFX1F_ForestTiles = 31
!GFX20_RexMegaMole = 32
!GFX21_Bowser = 33
!GFX22_BossBackground = 34
!GFX23_DinoRhino = 35
!GFX24_Mechakoopa = 36
!GFX25_IggyLarryReznor = 37
!GFX26_CreditsYoshi = 38
!GFX27_IggyReznorPlat = 39
!GFX28_HUDTiles = 40
!GFX29_TitleScreen = 41
!GFX2A_MessageTiles = 42
!GFX2B_CastleCrusher = 43
!GFX2C_CutsceneTiles = 44
!GFX2D_CutsceneSprites = 45
!GFX2E_ThankYou = 46
!GFX2F_CreditsLetters = 47
    !GFX2F_DecompSize = $400
!GFX30_TheEnd = 48
!GFX31_SpecialEnemies = 49
!GFX32_Mario = 50
!GFX33_AnimatedTiles = 51