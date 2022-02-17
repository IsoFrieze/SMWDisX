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

; effective size of screen in lines
; used a lot for windowing effects
!ScreenHeight = con(224,224,224,224,240)

; number of tiles across in one BG page
!BGWidthInTiles = 32
; number of tiles in one BG page
!TilesPerBGPage = !BGWidthInTiles*!BGWidthInTiles
; number of tiles vertically the bottom half of a horizontal level uses
!BGHeightInTiles = 22

; DMA channels
!Ch0 = %00000001
!Ch1 = %00000010
!Ch2 = %00000100
!Ch3 = %00001000
!Ch4 = %00010000
!Ch5 = %00100000
!Ch6 = %01000000
!Ch7 = %10000000

; ==== SMW Property Constants ====

; --- General Game ---

; tile used for empty spaces on layer 3
!EmptyTile = $38FC

; tile used for dragon coin on layer 3
!HUDDragonCoinTile = $2E

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

; number of interpolated palette values when fading
; to and from black at the end of a level
!PaletteFadeCount = 32

; number of coins to get a 1up from a green star block
!GreenStarBlockCoins = 30

; -- Boss Fights --

; ceiling heights for mode 7 boss rooms
!RoyMortonCeilingHeight = 42
!LudwigCeilingHeight = 18
!BowserCeilingHeight = 0
!ReznorCeilingHeight = -19

; floor heights for mode 7 boss rooms
!BossFloorHeight = 174

; number of OBJs to reserve for background in Roy/Morton/Ludwig
!BossBGOBJCount = 100

; --- Overworld Properties ---

; number of levels on the main map
!MainMapLvls = 36


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
!BGM_SPECIALWORLD =9
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