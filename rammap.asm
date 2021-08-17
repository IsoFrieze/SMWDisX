incsrc "hardware_registers.asm"

; WORK RAM

; scratch ram
; used for many various purposes
!_0 = $7E0000
!_1 = $7E0001
!_2 = $7E0002
!_3 = $7E0003
!_4 = $7E0004
!_5 = $7E0005
!_6 = $7E0006
!_7 = $7E0007
!_8 = $7E0008
!_9 = $7E0009
!_A = $7E000A
!_B = $7E000B
!_C = $7E000C
!_D = $7E000D
!_E = $7E000E
!_F = $7E000F

; non-zero during game loop
; set to zero after game loop
; must be non-zero to start game loop
; set to non-zero at end of V-blank
; 1 byte
!LagFlag = $7E0010

; the ID of the currently queued IRQ
; for areas that use multiple IRQs, this value distinguishes them
; 1 byte
!IRQType = $7E0011

; stripe image ID to draw
; index into a list of pointers to stripe images to draw
; must be divisible by 3 or it will draw garbage
; if this value is zero, the address points to the stripe image ram buffer
; 1 byte
!StripeImage = $7E0012

; frame counter
; increments for every frame of execution
; not incremented during lag frames
; 1 byte
!TrueFrame = $7E0013

; frame counter
; increments for every frame of execution when gameplay is not paused or frozen
; not incremented during lag frames
; 1 byte
!EffFrame = $7E0014

; controller data for the currently active player
; byetudlr
; |||||||+ set if right on the dpad was pressed this frame
; ||||||+- set if left on the dpad was pressed this frame
; |||||+-- set if down on the dpad was pressed this frame
; ||||+--- set if up on the dpad was pressed this frame
; |||+---- set if the start button was pressed this frame
; ||+----- set if the select button was pressed this frame
; |+------ set if the Y button was pressed this frame
; +------- set if the A or B button were pressed this frame
; 1 byte
!byetudlrHold = $7E0015

; controller data for the currently active player
; byetudlr
; |||||||+ set if right on the dpad is held this frame
; ||||||+- set if left on the dpad is held this frame
; |||||+-- set if down on the dpad is held this frame
; ||||+--- set if up on the dpad is held this frame
; |||+---- set if the start button is held this frame
; ||+----- set if the select button is held this frame
; |+------ set if the Y button is held this frame
; +------- set if the B button is held this frame
!byetudlrFrame = $7E0016

; controller data for the currently active player
; axlr0000
; ||||++++ always 0
; |||+---- set if the R button was pressed this frame
; ||+----- set if the L button was pressed this frame
; |+------ set if the X button was pressed this frame
; +------- set if the A button was pressed this frame
; 1 byte
!axlr0000Hold = $7E0017

; controller data for the currently active player
; axlr0000
; ||||++++ always 0
; |||+---- set if the R button is held this frame
; ||+----- set if the L button is held this frame
; |+------ set if the X button is held this frame
; +------- set if the A button is held this frame
; 1 byte
!axlr0000Frame = $7E0018

; the player's current powerup status
; 0 = small, 1 = big, 2 = cape, 3 = fire
; 1 byte
!Powerup = $7E0019

; the horizontal scroll value for background layer 1
; value buffer for PPU register $210D, BG1HOFS
; 2 bytes
!Layer1XPos = $7E001A

; the vertical scroll value for background layer 1
; value buffer for PPU register $210E, BG1VOFS
; 2 bytes
!Layer1YPos = $7E001C

; the horizontal scroll value for background layer 2
; value buffer for PPU register $210F, BG2HOFS
; 2 bytes
!Layer2XPos = $7E001E

; the vertical scroll value for background layer 2
; value buffer for PPU register $2110, BG2VOFS
; 2 bytes
!Layer2YPos = $7E0020

; the horizontal scroll value for background layer 3
; value buffer for PPU register $2111, BG3HOFS
; 2 bytes
!Layer3XPos = $7E0022

; the vertical scroll value for background layer 3
; value buffer for PPU register $2112, BG3VOFS
; 2 bytes
!Layer3YPos = $7E0024

; the horizontal difference between the two interactive layers
; the difference between layer 1 and layer 2 or 3 depending on the level mode
; 2 bytes
!Layer23XRelPos = $7E0026

; the vertical difference between the two interactive layers
; the difference between layer 1 and layer 2 or 3 depending on the level mode
; 2 bytes
!Layer23YRelPos = $7E0028

; the horizontal co-ordinate of the mode 7 fixed point
; the value stored here is #$0080 more than the PPU register
; value buffer for PPU register $211F, M7X
; 2 bytes
!Mode7CenterX = $7E002A

; the vertical co-ordinate of the mode 7 fixed point
; the value stored here is #$0080 more than the PPU register
; value buffer for PPU register $2120, M7Y
; 2 bytes
!Mode7CenterY = $7E002C

; the value of the A parameter for the mode 7 transformation matrix
; value buffer for PPU register $211B, M7A
; 2 bytes
!Mode7ParamA = $7E002E

; the value of the B parameter for the mode 7 transformation matrix
; value buffer for PPU register $211C, M7B
; 2 bytes
!Mode7ParamB = $7E0030

; the value of the C parameter for the mode 7 transformation matrix
; value buffer for PPU register $211D, M7C
; 2 bytes
!Mode7ParamC = $7E0032

; the value of the D parameter for the mode 7 transformation matrix
; value buffer for PPU register $211E, M7D
; 2 bytes
!Mode7ParamD = $7E0034

; the value of an angle, where #$0200 marks a complete circle
; used in calculation of mode 7 parameters, and in brown swinging platforms
; 2 bytes
!Mode7Angle = $7E0036

; the value of horizontal scaling, where #$20 marks the identity
; used in calculation of mode 7 parameters
; lower values result in higher scaling and vis-versa
; 1 byte
!Mode7XScale = $7E0038

; the value of vertical scaling, where #$20 marks the identity
; used in calculation of mode 7 parameters
; lower values result in higher scaling and vis-versa
; 1 byte
!Mode7YScale = $7E0039

; the horizontal scroll value for the mode 7 background layer
; value buffer for PPU register $210D, BG1HOFS
; 2 bytes
!Mode7XPos = $7E003A

; the vertical scroll value for the mode 7 background layer
; value buffer for PPU register $210E, BG1VOFS
; 2 bytes
!Mode7YPos = $7E003C

; the background mode and layer character size settings
; value buffer for PPU register $2105, BGMODE
; 4321pmmm
; |||||+++ the background mode (0-7)
; ||||+--- set if background layer 3 has high priority
; ++++---- set if background layer 1/2/3/4 has 16x16 characters, else 8x8
; 1 byte
!MainBGMode = $7E003E

; index of the OBJ that should take highest priority
; value buffer for PPU register $2102, OAMADDL
; highest bit of $2103, OAMADDH, is set automatically
; 1 byte
!OAMAddress = $7E003F

; color math settings
; value buffer for PPU register $2131, CGADSUB
; shbo4321
; ||++++++ set if background layer 1/2/3/4/OBJ/back color should participate in color math
; |+------ set if color math result should be halved (e.g. average)
; +------- set if subtract subscreens, else add
; 1 byte
!ColorSettings = $7E0040

; window selection settings for background layers 1 and 2
; value buffer for PPU register $2123, W12SEL
; 2i1i2i1i
; |||||||+ background layer 1, in/out bit for window 1
; ||||||+- background layer 1, enable bit for window 1
; |||||+-- background layer 1, in/out bit for window 2
; ||||+--- background layer 1, enable bit for window 2
; |||+---- background layer 2, in/out bit for window 1
; ||+----- background layer 2, enable bit for window 1
; |+------ background layer 2, in/out bit for window 2
; +------- background layer 2, enable bit for window 2
; 1 byte
!Layer12Window = $7E0041

; window selection settings for background layers 3 and 4
; value buffer for PPU register $2124, W34SEL
; 2i1i2i1i
; |||||||+ background layer 3, in/out bit for window 1
; ||||||+- background layer 3, enable bit for window 1
; |||||+-- background layer 3, in/out bit for window 2
; ||||+--- background layer 3, enable bit for window 2
; |||+---- background layer 4, in/out bit for window 1
; ||+----- background layer 4, enable bit for window 1
; |+------ background layer 4, in/out bit for window 2
; +------- background layer 4, enable bit for window 2
; 1 byte
!Layer34Window = $7E0042

; window selection settings for OBJ layer and color window
; value buffer for PPU register $2125, WOBJSEL
; 2i1i2i1i
; |||||||+ OBJ layer, in/out bit for window 1
; ||||||+- OBJ layer, enable bit for window 1
; |||||+-- OBJ layer, in/out bit for window 2
; ||||+--- OBJ layer, enable bit for window 2
; |||+---- color window, in/out bit for window 1
; ||+----- color window, enable bit for window 1
; |+------ color window, in/out bit for window 2
; +------- color window, enable bit for window 2
; 1 byte
!OBJCWWindow = $7E0043

; color math enable and selection switch
; value buffer for PPU register $2130, CGSWSEL
; mmss--fd
; ||||  |+ set if direct color is enabled
; ||||  +- set for color math between subscreens, clear for fixed color math
; ||++---- color window, in/out bit for window 1
; ++------ color window, in/out bit for window 2
; 1 byte
!ColorAddition = $7E0044
!Layer1TileUp = $7E0045
!Layer1TileDown = $7E0047
!Layer2TileUp = $7E0049
!Layer2TileDown = $7E004B
!Layer1PrevTileUp = $7E004D
!Layer1PrevTileDown = $7E004F
!Layer2PrevTileUp = $7E0051
!Layer2PrevTileDown = $7E0053
!Layer1ScrollDir = $7E0055
!Layer2ScrollDir = $7E0056
!LevelLoadPos = $7E0057
; $7E0058 unused
!LvlLoadObjSize = $7E0059
!LvlLoadObjNo = $7E005A
!ScreenMode = $7E005B
; $7E005C unused
!LevelScrLength = $7E005D
!LastScreenHoriz = $7E005E
!LastScreenVert = $7E005F
; $7E0060-$7E0063 unused
!SpriteProperties = $7E0064
!Layer1DataPtr = $7E0065
!Layer2DataPtr = $7E0068
!Map16LowPtr = $7E006B
!Map16HighPtr = $7E006E
!PlayerAnimation = $7E0071
!PlayerInAir = $7E0072
!PlayerIsDucking = $7E0073
!PlayerIsClimbing = $7E0074
!PlayerInWater = $7E0075
!PlayerDirection = $7E0076
!PlayerBlockedDir = $7E0077
!PlayerHiddenTiles = $7E0078
; $7E0079 unused
!PlayerXPosSpx = $7E007A
!PlayerXSpeed = $7E007B
!PlayerYPosSpx = $7E007C ; used only by E0 & E1
!PlayerYSpeed = $7E007D
!PlayerXPosScrRel = $7E007E
!PlayerYPosScrRel = $7E0080
!SlopesPtr = $7E0082
!LevelIsWater = $7E0085
!LevelIsSlippery = $7E0086
; $7E0087 unused
!PipeTimer = $7E0088
!PlayerPipeAction = $7E0089
!GraphicsCompPtr = $7E008A
!GraphicsUncompPtr = $7E008D
!PlayerYPosInBlock = $7E0090
!PlayerBlockMoveY = $7E0091
!PlayerXPosInBlock = $7E0092
!PlayerBlockXSide = $7E0093
!PlayerXPosNext = $7E0094
!PlayerYPosNext = $7E0096
!TouchBlockYPos = $7E0098
!TouchBlockXPos = $7E009A
!Map16TileGenerate = $7E009C
!SpriteLock = $7E009D
!SpriteNumber = $7E009E
!SpriteYSpeed = $7E00AA
!SpriteXSpeed = $7E00B6
!SpriteTableC2 = $7E00C2
!SpriteDataPtr = $7E00CE
!PlayerXPosNow = $7E00D1
!PlayerYPosNow = $7E00D3
!WigglerSegmentPtr = $7E00D5
!SpriteYPosLow = $7E00D8
!SpriteXPosLow = $7E00E4
; $7E00F0-$7E00FF unused
!GameMode = $7E0100
!SpriteGFXFile = $7E0101
!BackgroundGFXFile = $7E0105
!OverworldOverride = $7E0109
!SaveFile = $7E010A
; $7E010B = $7E010F unused
!CreditsLetterbox = $7E0110 ; used only by E1
; $7E0112 - $7E01FF used as stack
!OAMTileXPos = $7E0200
!OAMTileYPos = $7E0201
!OAMTileNo = $7E0202
!OAMTileAttr = $7E0203
!OAMTileBitSize = $7E0400
!OAMTileSize = $7E0420
!WindowTable = $7E04A0
!PaletteIndexTable = $7E0680
!DynPaletteIndex = $7E0681
!DynPaletteTable = $7E0682
; $7E0695-$7E0700 unused
!BackgroundColor = $7E0701
!MainPalette = $7E0703
!CopyBGColor = $7E0903
!CopyPalette = $7E0905
!Empty0AF5 = $7E0AF5
!GfxDecompOWAni = $7E0AF6
!RAM_0AFD = $7E0AFD
!CreditsSprYSpeed = $7E0B05
!CreditsSprXSpeed = $7E0B14
!CreditsSprYPosSpx = $7E0B23
!CreditsSprXPosSpx = $7E0B32
!CreditsSprYPosLow = $7E0B41
!CreditsSprXPosLow = $7E0B50
!CreditsSprYPosHigh = $7E0B5F
!CreditsSprXPosHigh = $7E0B6E
!CastleCutExSprAccel = $7E0B7D
!CastleCutExSprSlot = $7E0B8C
!GfxDecompSP1 = $7E0BF6
!Gfx33SrcAddrA = $7E0D76
!Gfx33SrcAddrB = $7E0D78
!Gfx33SrcAddrC = $7E0D7A
!Gfx33DestAddrA = $7E0D7C
!Gfx33DestAddrB = $7E0D7E
!Gfx33DestAddrC = $7E0D80
!PlayerPalletePtr = $7E0D82
!PlayerGfxTileCount = $7E0D84
!DynGfxTilePtr = $7E0D85
!DynGfxTile7FPtr = $7E0D99
!IRQNMICommand = $7E0D9B
; 7E0D9C unused
!ThroughMain = $7E0D9D
!ThroughSub = $7E0D9E
!HDMAEnable = $7E0D9F
!ControllersPresent = $7E0DA0
; 7E0DA1 unused
!byetudlrP1Hold = $7E0DA2
!byetudlrP2Hold = $7E0DA3
!axlr0000P1Hold = $7E0DA4
!axlr0000P2Hold = $7E0DA5
!byetudlrP1Frame = $7E0DA6
!byetudlrP2Frame = $7E0DA7
!axlr0000P1Frame = $7E0DA8
!axlr0000P2Frame = $7E0DA9
!byetudlrP1Mask = $7E0DAA
!byetudlrP2Mask = $7E0DAB
!axlr0000P1Mask = $7E0DAC
!axlr0000P2Mask = $7E0DAD
!Brightness = $7E0DAE
!MosaicDirection = $7E0DAF
!MosaicSize = $7E0DB0
!KeepModeActive = $7E0DB1
!IsTwoPlayerGame = $7E0DB2
!PlayerTurnLvl = $7E0DB3
!SavedPlayerLives = $7E0DB4
!SavedPlayerCoins = $7E0DB6
!SavedPlayerPowerup = $7E0DB8
!SavedPlayerYoshi = $7E0DBA
!SavedPlayerItembox = $7E0DBC
!PlayerLives = $7E0DBE
!PlayerCoins = $7E0DBF
!GreenStarBlockCoins = $7E0DC0
!CarryYoshiThruLvls = $7E0DC1
!PlayerItembox = $7E0DC2
; 7E0DC3 - 7E0D36 unused
!OverworldDestXPos = $7E0DC7
!OverworldDestYPos = $7E0DC9
!OWPlayerSpeed = $7E0DCF
!OWPlayerDirection = $7E0DD3
!OWLevelExitMode = $7E0DD5
!PlayerTurnOW = $7E0DD6
!PlayerSwitching = $7E0DD8
; 7E0DD9 unused
!MusicBackup = $7E0DDA
; 7E0DDB - 7E0DDD unused
!SaveFileDelete = $7E0DDE
!OWCloudOAMIndex = $7E0DDF
!OWCloudYSpeed = $7E0DE0
!OWSpriteNumber = $7E0DE5
!OWSpriteMisc0DF5 = $7E0DF5
!OWSpriteMisc0E05 = $7E0E05
!OWSpriteMisc0E15 = $7E0E15
!OWSpriteMisc0E25 = $7E0E25
!OWSpriteXPosLow = $7E0E35
!OWSpriteYPosLow = $7E0E45
!OWSpriteZPosLow = $7E0E55
!OWSpriteXPosHigh = $7E0E65
!OWSpriteYPosHigh = $7E0E75
!OWSpriteXSpeed = $7E0E95
!OWSpriteYSpeed = $7E0EA5
!OWSpriteZSpeed = $7E0EB5
!OWSpriteXPosSpx = $7E0EC5
!KoopaKidActive = $7E0EF5
!KoopaKidTile = $7E0EF6
!EnterLevelAuto = $7E0EF7
!YoshiSavedFlag = $7E0EF8
!StatusBar = $7E0EF9
!InGameTimerFrames = $7E0F30
!InGameTimerHundreds = $7E0F31
!InGameTimerTens = $7E0F32
!InGameTimerOnes = $7E0F33
!PlayerScore = $7E0F34
; 7E0F3A - 7E0F3F unused
!ScoreIncrement = $7E0F40
; 7E0F42 - 7E0F47 unused
!PlayerBonusStars = $7E0F48
!ClusterSpriteMisc0F4A = $7E0F4A
; 7E0F5E - 7E0F71 unused
!ClusterSpriteMisc0F72 = $7E0F72
!ClusterSpriteMisc0F86 = $7E0F86
!ClusterSpriteMisc0F9A = $7E0F9A
!BooRingAngleLow = $7E0FAE
!BooRingAngleHigh = $7E0FB0
!BooRingXPosLow = $7E0FB2
!BooRingXPosHigh = $7E0FB4
!BooRingYPosLow = $7E0FB6
!BooRingYPosHigh = $7E0FB8
!BooRingOffscreen = $7E0FBA
!BooRingLoadIndex = $7E0FBC
!Map16Pointers = $7E0FBE
!ItemMemorySetting = $7E13BE
!TranslevelNo = $7E13BF
!OverworldLayer1Tile = $7E13C1
!CurrentSubmap = $7E13C3
!MoonCounter = $7E13C5
!CutsceneID = $7E13C6
!YoshiColor = $7E13C7
; 7E13C8 unused
!ShowContinueEnd = $7E13C9
!ShowSavePrompt = $7E13CA
!UnusedStarCounter = $7E13CB
!CoinAdder = $7E13CC
!DisableMidway = $7E13CD
!MidwayFlag = $7E13CE
!SkipMidwayCastleIntro = $7E13CF
!StructureCrushTile = $7E13D0
!StructureCrushIndex = $7E13D1
!SwitchPalaceColor = $7E13D2
!PauseTimer = $7E13D3
!PauseFlag = $7E13D4
!Layer3ScrollType = $7E13D5
!DrumrollTimer = $7E13D6
!IntroMarchYPosSpx = $7E13D7
!OverworldProcess = $7E13D9
!PlayerXSpeedFPSpx = $7E13DA
!PlayerWalkingPose = $7E13DB
!PlayerTurningPose = $7E13DD
!PlayerOverworldPose = $7E13DE
!PlayerCapePose = $7E13DF
!PlayerPose = $7E13E0
!SlopeType = $7E13E1
!SpinjumpFireball = $7E13E2
!WallrunningType = $7E13E3
!PlayerPMeter = $7E13E4
!PlayerPoseLenTimer = $7E13E5
; 7E13E6 - 7E13E7 unused
!CapeInteracts = $7E13E8
!CapeInteractionXPos = $7E13E9
!CapeInteractionYPos = $7E13EB
!PlayerSlopePose = $7E13ED
!CurrentSlope = $7E13EE
!PlayerIsOnGround = $7E13EF
!NetDoorDirIndex = $7E13F0
!VerticalScrollEnabled = $7E13F1
; 7E13F2 unused
!PBalloonInflating = $7E13F3
!BonusRoomBlocks = $7E13F4
!PlayerBehindNet = $7E13F9
!PlayerCanJumpWater = $7E13FA
!PlayerIsFrozen = $7E13FB
!ActiveBoss = $7E13FC
!CameraIsScrolling = $7E13FD
!CameraScrollDir = $7E13FE
!CameraScrollPlayerDir = $7E13FF
!CameraProperMove = $7E1400
!CameraScrollTimer = $7E1401
!NoteBlockActive = $7E1402
!Layer3TideSetting = $7E1403
!ScreenScrollAtWill = $7E1404
!DrawYoshiInPipe = $7E1405
!BouncingOnBoard = $7E1406
!FlightPhase = $7E1407
!NextFlightPhase = $7E1408
!MaxStageOfFlight = $7E1409
!Empty_140A = $7E140A
; 7E140B - 7E140C unused
!SpinJumpFlag = $7E140D
!Layer2Touched = $7E140E
!ReznorOAMIndex = $7E140F
!YoshiHasWingsGfx = $7E1410
!HorizLayer1Setting = $7E1411
!VertLayer1Setting = $7E1412
!HorizLayer2Setting = $7E1413
!VertLayer2Setting = $7E1414
; 7E1415 - 7E1416 unused
!BackgroundVertOffset = $7E1417
!YoshiInPipeSetting = $7E1419
!SublevelCount = $7E141A
!DidPlayBonusGame = $7E141B
!SecretGoalTape = $7E141C
!ShowMarioStart = $7E141D
!YoshiHasWingsEvt = $7E141E
!DisableNoYoshiIntro = $7E141F
!DragonCoinsCollected = $7E1420
!OneUpCheckpoints = $7E1421
!DragonCoinsShown = $7E1422
!SwitchPalacePressed = $7E1423
!DisplayBonusStars = $7E1424
!BonusGameActivate = $7E1425
!MessageBoxTrigger = $7E1426
!ClownCarImage = $7E1427
!ClownCarPropeller = $7E1428
!BowserPalette = $7E1429
!CameraMoveTrigger = $7E142A
!CameraLeftBuffer = $7E142C
!CameraRightBuffer = $7E142E
!SolidTileStart = $7E1430
!SolidTileEnd = $7E1431
!DirectCoinInit = $7E1432
!SpotlightSize = $7E1433
!KeyholeTimer = $7E1434
!KeyholeDirection = $7E1435
!KeyholeXPos = $7E1436
!KeyholeYPos = $7E1438
!UploadMarioStart = $7E143A
!DeathMessage = $7E143B
!GameOverAnimation = $7E143C
!GameOverTimer = $7E143D
!Layer1ScrollCmd = $7E143E
!Layer2ScrollCmd = $7E143F
!Layer1ScrollBits = $7E1440
!Layer2ScrollBits = $7E1441
!Layer1ScrollType = $7E1442
!Layer2ScrollType = $7E1443
!Layer1ScrollTimer = $7E1444
!Layer2ScrollTimer = $7E1445
!Layer1ScrollXSpeed = $7E1446
!Layer1ScrollYSpeed = $7E1448
!Layer2ScrollXSpeed = $7E144A
!Layer2ScrollYSpeed = $7E144C
!Layer1ScrollXPosUpd = $7E144E
!Layer1ScrollYPosUpd = $7E1450
!Layer2ScrollXPosUpd = $7E1452
!Layer2ScrollYPosUpd = $7E1454
!ScrollLayerIndex = $7E1456
!CreditsJumpingYoshi = $7E1457
!Layer3ScrollXSpeed = $7E1458
!Layer3ScrollYSpeed = $7E145A
!Layer3ScrollXPosUpd = $7E145C
; 7E145E - 7E145F unused
!Layer3ScroolDir = $7E1460
; 7E1461 unused
!NextLayer1XPos = $7E1462
!NextLayer1YPos = $7E1464
!NextLayer2XPos = $7E1466
!NextLayer2YPos = $7E1468
!Layer3HorizOffset = $7E146A
; 7E146C - 7E146F unused
!CarryingFlag = $7E1470
!StandOnSolidSprite = $7E1471
!LightTopWinOpenPos = $7E1472
; 7E1473 unused
!LightTopWinClosePos = $7E1474
; 7E1475 unused
!LightBotWinOpenPos = $7E1476
; 7E1477 unused
!LightBotWinClosePos = $7E1478
; 7E1479 unused
!LightWinOpenCalc = $7E147A
; 7E147B unused
!LightWinCloseCalc = $7E147C
; 7E147D unused
!LightWinOpenMove = $7E147E
!LightWinCloseMove = $7E147F
!LightLeftWidth = $7E1480
!LightRightWidth = $7E1481
!LightSkipInit = $7E1482
!LightMoveDir = $7E1483
!LightLeftRelPos = $7E1484
!LightRightRelPos = $7E1485
!LightExists = $7E1486
; 7E1487 - 7E148A unused
!RNGCalc = $7E148B
!RandomNumber = $7E148D
!IsCarryingItem = $7E148F
!InvinsibilityTimer = $7E1490
!SpriteXMovement = $7E1491
!PlayerPeaceSignTimer = $7E1492
!EndLevelTimer = $7E1493
!ColorFadeDir = $7E1494
!ColorFadeTimer = $7E1495
!PlayerAniTimer = $7E1496
!IFrameTimer = $7E1497
!PickUpItemTimer = $7E1498
!FaceScreenTimer = $7E1499
!KickingTimer = $7E149A
!CyclePaletteTimer = $7E149B
!ShootFireTimer = $7E149C
!NetDoorTimer = $7E149D
!PunchNetTimer = $7E149E
!TakeoffTimer = $7E149F
!RunTakeoffTimer = $7E14A0
!SkidTurnTimer = $7E14A1
!CapeAniTimer = $7E14A2
!YoshiTongueTimer = $7E14A3
!CapePumpTimer = $7E14A4
!CapeFloatTimer = $7E14A5
!CapeSpinTimer = $7E14A6
!ReznorBridgeTimer = $7E14A7
!EmptyTimer14A8 = $7E14A8
!GroundPoundTimer = $7E14A9
!YoshiWingGrabTimer = $7E14AA
!BonusFinishTimer = $7E14AB
; 7E14AC unused
!BluePSwitchTimer = $7E14AD
!SilverPSwitchTimer = $7E14AE
!OnOffSwitch = $7E14AF
!BrSwingCenterXPos = $7E14B0
!BrSwingCenterYPos = $7E14B2
!BrSwingXDist = $7E14B4
!BrSwingYDist = $7E14B6
!BrSwingPlatXPos = $7E14B8
!BrSwingPlatYPos = $7E14BA
!BrSwingRadiusX = $7E14BC
; 7E14BE unused
!BrSwingRadiusY = $7E14BF
; 7E14C1 unused
!BrSwingSine = $7E14C2
; 7E14C4 unused
!BrSwingCosine = $7E14C5
; 7E14C7 unused
!SpriteStatus = $7E14C8
!SpriteXPosHigh = $7E14D4
!SpriteYPosHigh = $7E14E0
!SpriteYPosSpx = $7E14EC
!SpriteXPosSpx = $7E14F8
!SpriteMisc1504 = $7E1504
!SpriteMisc1510 = $7E1510
!SpriteMisc151C = $7E151C
!SpriteMisc1528 = $7E1528
!SpriteMisc1534 = $7E1534
!SpriteMisc1540 = $7E1540
!SpriteMisc154C = $7E154C
!SpriteMisc1558 = $7E1558
!SpriteMisc1564 = $7E1564
!SpriteMisc1570 = $7E1570
!SpriteMisc157C = $7E157C
!SpriteBlockedDirs = $7E1588
!SpriteMisc1594 = $7E1594
!SpriteOffscreenX = $7E15A0
!SpriteMisc15AC = $7E15AC
!SpriteSlope = $7E15B8
!SpriteWayOffscreenX = $7E15C4
!SpriteOnYoshiTongue = $7E15D0
!SpriteDisableObjInt = $7E15DC
; 7E15E8 unused
!CurSpriteProcess = $7E15E9
!SpriteOAMIndex = $7E15EA
!SpriteOBJAttribute = $7E15F6
!SpriteMisc1602 = $7E1602
!SpriteMisc160E = $7E160E
!SpriteLoadIndex = $7E161A
!SpriteMisc1626 = $7E1626
!SpriteBehindScene = $7E1632
!SpriteMisc163E = $7E163E
!SpriteInLiquid = $7E164A
!SpriteTweakerA = $7E1656
!SpriteTweakerB = $7E1662
!SpriteTweakerC = $7E166E
!SpriteTweakerD = $7E167A
!SpriteTweakerE = $7E1686
!SpriteMemorySetting = $7E1692
!Map16TileNumber = $7E1693
!SpriteBlockOffset = $7E1694
!SpriteInterIndex = $7E1695
; 7E1696 unused
!SpriteStompCounter = $7E1697
!MinorSpriteProcIndex = $7E1698
!BounceSpriteNumber = $7E1699
!BounceSpriteInit = $7E169D
!BounceSpriteYPosLow = $7E16A1
!BounceSpriteXPosLow = $7E16A5
!BounceSpriteYPosHigh = $7E16A9
!BounceSpriteXPosHigh = $7E16AD
!BounceSpriteYSpeed = $7E16B1
!BounceSpriteXSpeed = $7E16B5
!BounceSpriteXPosSpx = $7E16B9
!BounceSpriteTile = $7E16C1
!BounceSpriteTimer = $7E16C5
!BounceSpriteFlags = $7E16C9
!QuakeSpriteNumber = $7E16CD
!QuakeSpriteXPosLow = $7E16D1
!QuakeSpriteXPosHigh = $7E16D5
!QuakeSpriteYPosLow = $7E16D9
!QuakeSpriteYPosHigh = $7E16DD
!ScoreSpriteNumber = $7E16E1
!ScoreSpriteYPosLow = $7E16E7
!ScoreSpriteXPosLow = $7E16ED
!ScoreSpriteXPosHigh = $7E16F3
!ScoreSpriteYPosHigh = $7E16F9
!ScoreSpriteTimer = $7E16FF
!ScoreSpriteLayer = $7E1705
!ExtSpriteNumber = $7E170B
!ExtSpriteYPosLow = $7E1715
!ExtSpriteXPosLow = $7E171F
!ExtSpriteYPosHigh = $7E1729
!ExtSpriteXPosHigh = $7E1733
!ExtSpriteYSpeed = $7E173D
!ExtSpriteXSpeed = $7E1747
!ExtSpriteYPosSpx = $7E1751
!ExtSpriteXPosSpx = $7E175B
!ExtSpriteMisc1765 = $7E1765
!ExtSpriteMisc176F = $7E176F
!ExtSpritePriority = $7E1779
!ShooterNumber = $7E1783
!ShooterYPosLow = $7E178B
!ShooterYPosHigh = $7E1793
!ShooterXPosLow = $7E179B
!ShooterXPosHigh = $7E17A3
!ShooterTimer = $7E17AB
!ShooterLoadIndex = $7E17B3
!LoadingLevelNumber = $7E17BB
!Layer1DYPos = $7E17BC
!Layer1DXPos = $7E17BD
!Layer2DYPos = $7E17BE
!Layer2DXPos = $7E17BF
!SmokeSpriteNumber = $7E17C0
!SmokeSpriteYPos = $7E17C4
!SmokeSpriteXPos = $7E17C8
!SmokeSpriteTimer = $7E17CC
!CoinSpriteExists = $7E17D0
!CoinSpriteYPosLow = $7E17D4
!CoinSpriteYSpeed = $7E17D8
!CoinSpriteYPosSpx = $7E17DC
!CoinSpriteXPosLow = $7E17E0
!CoinSpriteLayer = $7E17E4
!CoinSpriteYPosHigh = $7E17E8
!CoinsPriteXPosHigh = $7E17EC
!MinExtSpriteNumber = $7E17F0
!MinExtSpriteYPosLow = $7E17FC
!MinExtSpriteXPosLow = $7E1808
!MinExtSpriteYPosHigh = $7E1814
!MinExtSpriteYSpeed = $7E1820
!MinExtSpriteXSpeed = $7E182C
!MinExtSpriteYPosSpx = $7E1838
!MinExtSpriteXPosSpx = $7E1850
!PlayerDisableObjInt = $7E185C
!MinExtSpriteSlotIdx = $7E185D
!TileGenerateTrackA = $7E185E
!SprMap16TouchVertLow = $7E185F
!SprMap16TouchHorizLow = $7E1860
!SpriteToOverwrite = $7E1861
!SprMap16TouchHorizHigh = $7E1862
!SmokeSpriteSlotIdx = $7E1863
; 7E1864 unused
!CoinSpriteSlotIdx = $7E1865
!BrSwingAngleParity = $7E1866
!Map16TileHittable = $7E1868
; 7E1869 - 7E186A unused
!MulticoinTimer = $7E186B
!SpriteOffscreenVert = $7E186C
!NetDoorPlayerXOffset = $7E1878
; 7E1879 unused
!PlayerRidingYoshi = $7E187A
!SpriteMisc187B = $7E187B
!ScreenShakeTimer = $7E1887
!ScreenShakeYOffset = $7E1888
!Empty188A = $7E188A
!ScrShakePlayerYOffset = $7E188B
!BossBGSpriteUpdate = $7E188C
!BossBGSpriteXCalc = $7E188D
; 7E188E unused
!BonusGameComplete = $7E188F
!BonusGame1UpCount = $7E1890
!PBalloonTimer = $7E1891
!ClusterSpriteNumber = $7E1892
!Empty18A6 = $7E18A6
!Map16TileDestroy = $7E18A7
!BossPillarFalling = $7E18A8
!BossPillarYPos = $7E18AA
!YoshiSwallowTimer = $7E18AC
!YoshiWalkingTimer = $7E18AD
!YoshiStartEatTimer = $7E18AE
!YoshiDuckTimer = $7E18AF
!YoshiXPos = $7E18B0
!YoshiYPos = $7E18B2
; 7E18B4 unused
!StandingOnCage = $7E18B5
!TileGenerateTrackB = $7E18B6
; 7E18B7 unused
!ActivateClusterSprite = $7E18B8
!CurrentGenerator = $7E18B9
!BooRingIndex = $7E18BA
; 7E18BB unused
!SkullRaftSpeed = $7E18BC
!PlayerStunnedTimer = $7E18BD
!PlayerClimbingRope = $7E18BE
!SpriteWillAppear = $7E18BF
!SpriteRespawnTimer = $7E18C0
!SpriteRespawnNumber = $7E18C1
!PlayerInCloud = $7E18C2
!SpriteRespawnYPos = $7E18C3
; 7E18C5 - 7E18CC unused
!BounceSpriteSlotIdx = $7E18CD
!TurnBlockSpinTimer = $7E18CE
!StarKillCounter = $7E18D2
!PlayerSparkleTimer = $7E18D3
!RedBerriesEaten = $7E18D4
!PinkBerriesEaten = $7E18D5
!EatenBerryType = $7E18D6
!SprMap16TouchVertHigh = $7E18D7
; 7E18D8 unused
!NoYoshiIntroTimer = $7E18D9
!YoshiEggSpriteHatch = $7E18DA
!Empty18DB = $7E18DB
!PlayerDuckingOnYoshi = $7E18DC
!SilverCoinsCollected = $7E18DD
!EggLaidTimer = $7E18DE
!CurrentYoshiSlot = $7E18DF
!LakituCloudTimer = $7E18E0
!LakituCloudSlot = $7E18E1
!YoshiIsLoose = $7E18E2
!GameCloudCoinCount = $7E18E3
!GivePlayerLives = $7E18E4
!GiveLivesTimer = $7E18E5
; 7E18E6 unused
!YoshiCanStomp = $7E18E7
!YoshiGrowingTimer = $7E18E8
!SmokeSpriteSlotFull = $7E18E9
!MinExtSpriteXPosHigh = $7E18EA
; 7E18F6 unused
!ScoreSpriteSlotIdx = $7E18F7
!BounceSpriteIntTimer = $7E18F8
!ExtSpriteSlotIdx = $7E18FC
!ChuckIsWhistling = $7E18FD
!DiagonalBulletTimer = $7E18FE
!ShooterSlotIdx = $7E18FF
!BonusStarsGained = $7E1900
!BounceSpriteYXPPCCCT = $7E1901
!IggyLarryPlatTilt = $7E1905
!IggyLarryPlatWait = $7E1906
!IggyLarryPlatPhase = $7E1907
!BlockSnakeActive = $7E1909
; 7E1908 unused
!BooCloudTimer = $7E190A
!BooTransparency = $7E190B
!DirectCoinTimer = $7E190C
!FinalCutscene = $7E190D
!SpriteBuoyancy = $7E190E
!SpriteTweakerF = $7E190F
!Empty191B = $7E191B
!YoshiHasKey = $7E191C
!SumoClustOverwrite = $7E191D
!BigSwitchPressTimer = $7E191E
; 7E191F unused
!BonusOneUpsRemain = $7E1920
!FinalMessageTimer = $7E1921
; 7E1923 - 7E1924 unused
!LevelModeSetting = $7E1925
; 7E1926 - 7E1927 unused
!LevelLoadObject = $7E1928
; 7E1929 unused
!LevelEntranceType = $7E192A
!SpriteTileset = $7E192B
; 7E192C unused
!ForegroundPalette = $7E192D
!SpritePalette = $7E192E
!BackAreaColor = $7E192F
!BackgroundPalette = $7E1930
!ObjectTileset = $7E1931
!Empty1932 = $7E1932
!LayerProcessing = $7E1933
!MarioStartFlag = $7E1935
; 7E1936 - 7E1937 unused
!SpriteLoadStatus = $7E1938
!ExitTableLow = $7E19B8
!ExitTableHigh = $7E19D8
!ItemMemoryTable = $7E19F8
!HardcodedPathIsUsed = $7E1B78
!HardcodedPathIndex = $7E1B7A
!Layer1PosSpx = $7E1B7C
!OverworldTightPath = $7E1B7E
; 7E1B7F unused
!OverworldClimbing = $7E1B80
!OverworldEventXPos = $7E1B82
!OverworldEventYPos = $7E1B83
!OverworldEventSize = $7E1B84
!OverworldEventProcess = $7E1B86
!OverworldPromptProcess = $7E1B87
!MessageBoxExpand = $7E1B88
!MessageBoxTimer = $7E1B89
!OWPromptArrowDir = $7E1B8A
!OWPromptArrowTimer = $7E1B8B
!OWTransitionFlag = $7E1B8C
!OWTransitionXCalc = $7E1B8D
!OWTransitionYCalc = $7E1B8F
!BlinkCursorTimer = $7E1B91
!BlinkCursorPos = $7E1B92
!UseSecondaryExit = $7E1B93
!DisableBonusSprite = $7E1B94
!YoshiHeavenFlag = $7E1B95
!SideExitEnabled = $7E1B96
!Empty1B97 = $7E1B97
!ShowPeaceSign = $7E1B99
!BGFastScrollActive = $7E1B9A
!RemoveYoshiFlag = $7E1B9B
!EnteringStarWarp = $7E1B9C
!Layer3TideTimer = $7E1B9D
!SwapOverworldMusic = $7E1B9E
!ReznorBridgeCount = $7E1B9F
!OverworldEarthquake = $7E1BA0
!LevelLoadObjectTile = $7E1BA1
!Mode7TileIndex = $7E1BA2
!Mode7GfxBuffer = $7E1BA3
!GfxBppConvertBuffer = $7E1BB2
!GfxBppConvertFlag = $7E1BBC
!Layer3Setting = $7E1BE3
!Layer1VramAddr = $7E1BE4
!Layer1VramBuffer = $7E1BE6
!Layer2VramAddr = $7E1CE6
!Layer2VramBuffer = $7E1CE8
!OWSubmapSwapProcess = $7E1DE8
!CreditsScreenNumber = $7E1DE9
!OverworldEvent = $7E1DEA
!EventTileIndex = $7E1DEB
!EventLength = $7E1DED
; 7E1DEF unused
!OverworldFreeCamXPos = $7E1DF0
!OverworldFreeCamYPos = $7E1DF2
!TitleInputIndex = $7E1DF4
!VariousPromptTimer = $7E1DF5
!StarWarpIndex = $7E1DF6
!StarWarpLaunchSpeed = $7E1DF7
!StarWarpLaunchTimer = $7E1DF8
!SPCIO0 = $7E1DF9
!SPCIO1 = $7E1DFA
!SPCIO2 = $7E1DFB
!SPCIO3 = $7E1DFC
!Empty1DFD = $7E1DFD
!LastUsedMusic = $7E1DFF
; 7E1E00 unused
!DebugFreeRoam = $7E1E01
!ClusterSpriteYPosLow = $7E1E02
!ClusterSpriteXPosLow = $7E1E16
!ClusterSpriteYPosHigh = $7E1E2A
!ClusterSpriteXPosHigh = $7E1E3E
!ClusterSpriteMisc1E52 = $7E1E52
!ClusterSpriteMisc1E66 = $7E1E66
!ClusterSpriteMisc1E7A = $7E1E7A
!ClusterSpriteMisc1E8E = $7E1E8E
!OWLevelTileSettings = $7E1EA2
!OWLevelTileSettings = $7E001EA2
!OWEventsActivated = $7E1F02
!OWPlayerSubmap = $7E1F11
!OWPlayerAnimation = $7E1F13
!OWPlayerXPos = $7E1F17
!OWPlayerYPos = $7E1F19
!OWPlayerXPosPtr = $7E1F1F
!OWPlayerYPosPtr = $7E1F21
!SwitchBlockFlags = $7E1F27
!SwitchBlockFlags = $7E001F27
; 7E1F2B - 7E1F2D unused
!ExitsCompleted = $7E1F2E
!AllDragonCoinsCollected = $7E1F2F
; 7E1F3B unused
!Checkpoint1upCollected = $7E1F3C
; 7E1F48 unused
!SaveDataBuffer = $7E1F49
!SaveDataBufferEvents = $7E1FA9
!SaveDataBufferSubmap = $7E1FB8
!SaveDataBufferAni = $7E1FBA
!SaveDataBufferXPos = $7E1FBE
!SaveDataBufferYPos = $7E1FC0
!SaveDataBufferXPosPtr = $7E1FC6
!SaveDataBufferYPosPtr = $7E1FC8
!SpriteMisc1FD6 = $7E1FD6
!SpriteMisc1FE2 = $7E1FE2
!MoonCollected = $7E1FEE
; 7E1FFA unused
!LightningFlashIndex = $7E1FFB
!LightningWaitTimer = $7E1FFC
!LightningTimer = $7E1FFD
!CreditsUpdateBG = $7E1FFE
; 7E1FFF unused

!MarioGraphics = $7E2000
!AnimatedTiles = $7E7D00
!Layer2TilemapLow = $7EB900
!SwitchEventTableA = $7EB928
!SwitchEventTableB = $7EB950
!SwitchEventTableC = $7EB978
!SwitchEventTableD = $7EB9A0
!SwitchEventTableE = $7EB9C8
!SwitchEventTableF = $7EB9F0
!SwitchEventTableG = $7EBA18
!SwitchEventTableH = $7EBA40
!SwitchEventTableI = $7EBA68
!Layer2TilemapHigh = $7EBD00
; 7EC100 - 7EC67F unused
!Mode7BossTilemap = $7EC680
; 7EC6E0 - 7EC7FF unused
!Map16TilesLow = $7EC800
!OWLayer1Translevel = $7ED000
!OWLayer2Directions = $7ED800
!OWLayer1VramBuffer = $7EE400
!OWEventTilemap = $7F0000
; 7F0D00 - 7F3FFF unused
!OWLayer2Tilemap = $7F4000
!OAMResetRoutine = $7F8000
; 7F8183 - 7F837A unused
!DynStripeImgSize = $7F837B
!DynamicStripeImage = $7F837D
; 7F868D - 7F977A unused
!MarioStartGraphics = $7F977B
!WigglerTable = $7F9A7B
; 7F9C7B - 7FC7FF unused
!Map16TilesHigh = $7FC800

; SAVE RAM

!SaveData = $700000
!SaveDataChecksum = $70008C
!SaveDataFile2 = $70008F
!SaveDataFile3 = $70011E
!SaveDataBackup = $7001AD
; 70035A - 7007FF unused

; AUDIO RAM

!SPCInEdge = $00
!SPCOutBuffer = $04
!SPCInBuffer = $08
!ARam_0C = $0C
!ARam_0E = $0E
!ARam_10 = $10
!ARam_11 = $11
!ARam_12 = $12
!ARam_13 = $13
!ARam_14 = $14
!ARam_15 = $15
!PitchValue = $16
!SFX1DF9PhrasePtr = $18
!SFX1DFCPhrasePtr = $1A
!ARam_1C = $1C
!ChannelsMuted = $1D
!ARam_2E = $2E
!ARam_2F = $2F
!VoPhrasePtr = $30
!BlockPtr = $40
!MusicLoopCounter = $42
!MasterTranspose = $43
!SPCTimer = $44
!CurrentChannel2 = $46
!ARam_47 = $47
!CurrentChannel = $48
!ARam_49 = $49
!MasterTempo = $50
!TempoSetTimer = $52
!TempoSetVal = $53
!ARam_56 = $56
!MasterVolume = $57
!VolFadeTimer = $58
!VolFadeVal = $59
!ARam_5A = $5A
!ARam_5C = $5C
!ARam_60 = $60
!EchoVolLeft = $61
!EchoVolRight = $63
!ARam_65 = $65
!ARam_67 = $67
!ARam_69 = $69
!ARam_6A = $6A
!VoTimers = $70
!VoPanFade = $80
!VoPitchSlide = $90
!VoVibrato = $A0
!ARam_B0 = $B0
!VoInstrument = $C0
!SPCCONTROL = $00F1
!DSPDATA = $00F2
!DSPADDR = $00F3
!SNESIO0 = $00F4
!SNESIO1 = $00F5
!SNESIO2 = $00F6
!SNESIO3 = $00F7
!TIMER0 = $00FA
!COUNTER0 = $00FD
!NoteLength = $0100
!ARam_0110 = $0110
!ARam_0200 = $0200
!ARam_0210 = $0210
!ARam_0240 = $0240
!ARam_0250 = $0250
!ARam_0260 = $0260
!ARam_0280 = $0280
!ARam_0290 = $0290
!ARam_02A0 = $02A0
!ARam_02B0 = $02B0
!ARam_02C0 = $02C0
!ARam_02D0 = $02D0
!ARam_02FF = $02FF
!ARam_0300 = $0300
!ARam_0320 = $0320
!ARam_0330 = $0330
!ARam_0340 = $0340
!ARam_0350 = $0350
!ARam_0360 = $0360
!ARam_0370 = $0370
!ARam_0380 = $0380
!ARam_0381 = $0381
!ARam_0382 = $0382
!ARam_0383 = $0383
!ARam_0384 = $0384
!ARam_0385 = $0385
!ARam_0386 = $0386
!ARam_0387 = $0387
!ARam_0388 = $0388
!ARam_0389 = $0389
!ARam_03E0 = $03E0
!ARam_03F0 = $03F0
!SPCEngine = $000500
!MusicData = $001360
!SoundEffectTable = $005570
!SamplePtrTable = $8000
!SampleTable = $8100
!MusicData = $1360
