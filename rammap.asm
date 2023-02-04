incsrc "hardware_registers.asm"

; WORK RAM

ORG $000000

; scratch ram
; used for many various purposes
_0: skip 1
_1: skip 1
_2: skip 1
_3: skip 1
_4: skip 1
_5: skip 1
_6: skip 1
_7: skip 1
_8: skip 1
_9: skip 1
_A: skip 1
_B: skip 1
_C: skip 1
_D: skip 1
_E: skip 1
_F: skip 1

; non-zero during game loop
; set to zero after game loop
; must be non-zero to start game loop
; set to non-zero at end of V-blank
; 1 byte
LagFlag: skip 1

; the ID of the currently queued IRQ
; for areas that use multiple IRQs, this value distinguishes them
; 1 byte
IRQType: skip 1

; stripe image ID to draw
; index into a list of pointers to stripe images to draw
; must be divisible by 3 or it will draw garbage
; if this value is zero, the address points to the stripe image ram buffer
; 1 byte
StripeImage: skip 1

; frame counter
; increments for every frame of execution
; not incremented during lag frames
; 1 byte
TrueFrame: skip 1

; frame counter
; increments for every frame of execution when gameplay is not paused or frozen
; not incremented during lag frames
; 1 byte
EffFrame: skip 1

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
byetudlrHold: skip 1

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
byetudlrFrame: skip 1

; controller data for the currently active player
; axlr0000
; ||||++++ always 0
; |||+---- set if the R button was pressed this frame
; ||+----- set if the L button was pressed this frame
; |+------ set if the X button was pressed this frame
; +------- set if the A button was pressed this frame
; 1 byte
axlr0000Hold: skip 1

; controller data for the currently active player
; axlr0000
; ||||++++ always 0
; |||+---- set if the R button is held this frame
; ||+----- set if the L button is held this frame
; |+------ set if the X button is held this frame
; +------- set if the A button is held this frame
; 1 byte
axlr0000Frame: skip 1

; the player's current powerup status
; 0: skip
; 1 byte
Powerup: skip 1

; the horizontal scroll value for background layer 1
; value buffer for PPU register $210D, BG1HOFS
; 2 bytes
Layer1XPos: skip 2

; the vertical scroll value for background layer 1
; value buffer for PPU register $210E, BG1VOFS
; 2 bytes
Layer1YPos: skip 2

; the horizontal scroll value for background layer 2
; value buffer for PPU register $210F, BG2HOFS
; 2 bytes
Layer2XPos: skip 2

; the vertical scroll value for background layer 2
; value buffer for PPU register $2110, BG2VOFS
; 2 bytes
Layer2YPos: skip 2

; the horizontal scroll value for background layer 3
; value buffer for PPU register $2111, BG3HOFS
; 2 bytes
Layer3XPos: skip 2

; the vertical scroll value for background layer 3
; value buffer for PPU register $2112, BG3VOFS
; 2 bytes
Layer3YPos: skip 2

; the horizontal difference between the two interactive layers
; the difference between layer 1 and layer 2 or 3 depending on the level mode
; 2 bytes
Layer23XRelPos: skip 2

; the vertical difference between the two interactive layers
; the difference between layer 1 and layer 2 or 3 depending on the level mode
; 2 bytes
Layer23YRelPos: skip 2

; the horizontal co-ordinate of the mode 7 fixed point
; the value stored here is #$0080 more than the PPU register
; value buffer for PPU register $211F, M7X
; 2 bytes
Mode7CenterX: skip 2

; the vertical co-ordinate of the mode 7 fixed point
; the value stored here is #$0080 more than the PPU register
; value buffer for PPU register $2120, M7Y
; 2 bytes
Mode7CenterY: skip 2

; the value of the A parameter for the mode 7 transformation matrix
; value buffer for PPU register $211B, M7A
; 2 bytes
Mode7ParamA: skip 2

; the value of the B parameter for the mode 7 transformation matrix
; value buffer for PPU register $211C, M7B
; 2 bytes
Mode7ParamB: skip 2

; the value of the C parameter for the mode 7 transformation matrix
; value buffer for PPU register $211D, M7C
; 2 bytes
Mode7ParamC: skip 2

; the value of the D parameter for the mode 7 transformation matrix
; value buffer for PPU register $211E, M7D
; 2 bytes
Mode7ParamD: skip 2

; the value of an angle, where #$0200 marks a complete circle
; used in calculation of mode 7 parameters, and in brown swinging platforms
; 2 bytes
Mode7Angle: skip 2

; the value of horizontal scaling, where #$20 marks the identity
; used in calculation of mode 7 parameters
; lower values result in higher scaling and vis-versa
; 1 byte
Mode7XScale: skip 1

; the value of vertical scaling, where #$20 marks the identity
; used in calculation of mode 7 parameters
; lower values result in higher scaling and vis-versa
; 1 byte
Mode7YScale: skip 1

; the horizontal scroll value for the mode 7 background layer
; value buffer for PPU register $210D, BG1HOFS
; 2 bytes
Mode7XPos: skip 2

; the vertical scroll value for the mode 7 background layer
; value buffer for PPU register $210E, BG1VOFS
; 2 bytes
Mode7YPos: skip 2

; the background mode and layer character size settings
; value buffer for PPU register $2105, BGMODE
; 4321pmmm
; |||||+++ the background mode (0-7)
; ||||+--- set if background layer 3 has high priority
; ++++---- set if background layer 1/2/3/4 has 16x16 characters, else 8x8
; 1 byte
MainBGMode: skip 1

; index of the OBJ that should take highest priority
; value buffer for PPU register $2102, OAMADDL
; highest bit of $2103, OAMADDH, is set automatically
; 1 byte
OAMAddress: skip 1

; color math settings
; value buffer for PPU register $2131, CGADSUB
; shbo4321
; ||++++++ set if background layer 1/2/3/4/OBJ/back color should participate in color math
; |+------ set if color math result should be halved (e.g. average)
; +------- set if subtract subscreens, else add
; 1 byte
ColorSettings: skip 1

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
Layer12Window: skip 1

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
Layer34Window: skip 1

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
OBJCWWindow: skip 1

; color math enable and selection switch
; value buffer for PPU register $2130, CGSWSEL
; mmss--fd
; ||||  |+ set if direct color is enabled
; ||||  +- set for color math between subscreens, clear for fixed color math
; ||++---- color window, in/out bit for window 1
; ++------ color window, in/out bit for window 2
; 1 byte
ColorAddition: skip 1

Layer1TileUp: skip 2
Layer1TileDown: skip 2
Layer2TileUp: skip 2
Layer2TileDown: skip 2
Layer1PrevTileUp: skip 2
Layer1PrevTileDown: skip 2
Layer2PrevTileUp: skip 2
Layer2PrevTileDown: skip 2
Layer1ScrollDir: skip 1
Layer2ScrollDir: skip 1
LevelLoadPos: skip 1
; $7E0058 unused
skip 1
LvlLoadObjSize: skip 1
LvlLoadObjNo: skip 1
ScreenMode: skip 1
; $7E005C unused
skip 1
LevelScrLength: skip 1
LastScreenHoriz: skip 1
LastScreenVert: skip 1
; $7E0060-$7E0063 unused
skip 4
SpriteProperties: skip 1
Layer1DataPtr: skip 3
Layer2DataPtr: skip 3
Map16LowPtr: skip 3
Map16HighPtr: skip 3
PlayerAnimation: skip 1
PlayerInAir: skip 1
PlayerIsDucking: skip 1
PlayerIsClimbing: skip 1
PlayerInWater: skip 1
PlayerDirection: skip 1
PlayerBlockedDir: skip 1
PlayerHiddenTiles: skip 1
; $7E0079 unused
skip 1
PlayerXPosSpx: skip 1
PlayerXSpeed: skip 1
PlayerYPosSpx: skip 1
PlayerYSpeed: skip 1
PlayerXPosScrRel: skip 2
PlayerYPosScrRel: skip 2
SlopesPtr: skip 3
LevelIsWater: skip 1
LevelIsSlippery: skip 1
; $7E0087 unused
skip 1
PipeTimer: skip 1
PlayerPipeAction: skip 1
GraphicsCompPtr: skip 3
GraphicsUncompPtr: skip 3
PlayerYPosInBlock: skip 1
PlayerBlockMoveY: skip 1
PlayerXPosInBlock: skip 1
PlayerBlockXSide: skip 1
PlayerXPosNext: skip 2
PlayerYPosNext: skip 2
TouchBlockYPos: skip 2
TouchBlockXPos: skip 2
Map16TileGenerate: skip 1
SpriteLock: skip 1
SpriteNumber: skip 12
SpriteYSpeed: skip 12
SpriteXSpeed: skip 12
SpriteTableC2: skip 12
SpriteDataPtr: skip 3
PlayerXPosNow: skip 2
PlayerYPosNow: skip 2
WigglerSegmentPtr: skip 3
SpriteYPosLow: skip 12
SpriteXPosLow: skip 12
; $7E00F0-$7E00FF unused

ORG $000100

StackPage:
GameMode: skip 1
SpriteGFXFile: skip 4
BackgroundGFXFile: skip 4
OverworldOverride: skip 1
SaveFile: skip 1
; $7E010B - $7E010F unused
skip 5
CreditsLetterbox: skip 1

; $7E0112 - $7E01FF used as stack

ORG $0001FF
StackStart: skip 1

OAMMirror:
OAMTileXPos: skip 1
OAMTileYPos: skip 1
OAMTileNo: skip 1
OAMTileAttr: skip 1

ORG $000400

OAMTileBitSize: skip 32
OAMTileSize: skip 128
WindowTable:
CreditsL1HDMATable: skip 10
CreditsL2HDMATable: skip 10
CreditsL3HDMATable: skip 460
PaletteIndexTable: skip 1
DynPaletteIndex: skip 1
DynPaletteTable:

ORG $000701

BackgroundColor: skip 2
MainPalette: skip 512
CopyBGColor: skip 2
CopyPalette: skip 496
Empty0AF5: skip 1
GfxDecompOWAni: skip 7
CreditsSprTimer: skip 8
CreditsSprYSpeed: skip 15
CreditsSprXSpeed: skip 15
CreditsSprYPosSpx: skip 15
CreditsSprXPosSpx: skip 15
CreditsSprYPosLow: skip 15
CreditsSprXPosLow: skip 15
CreditsSprYPosHigh: skip 15
CreditsSprXPosHigh: skip 15
CastleCutExSprAccel: skip 15
CastleCutExSprSlot: skip 106
GfxDecompSP1: skip 384
Gfx33SrcAddrA: skip 2
Gfx33SrcAddrB: skip 2
Gfx33SrcAddrC: skip 2
Gfx33DestAddrA: skip 2
Gfx33DestAddrB: skip 2
Gfx33DestAddrC: skip 2
PlayerPalletePtr: skip 2
PlayerGfxTileCount: skip 1
DynGfxTilePtr: skip 20
DynGfxTile7FPtr: skip 2
IRQNMICommand: skip 1
; 7E0D9C unused
skip 1
ThroughMain: skip 1
ThroughSub: skip 1
HDMAEnable: skip 1
ControllersPresent: skip 1
; 7E0DA1 unused
skip 1
byetudlrP1Hold: skip 1
byetudlrP2Hold: skip 1
axlr0000P1Hold: skip 1
axlr0000P2Hold: skip 1
byetudlrP1Frame: skip 1
byetudlrP2Frame: skip 1
axlr0000P1Frame: skip 1
axlr0000P2Frame: skip 1
byetudlrP1Mask: skip 1
byetudlrP2Mask: skip 1
axlr0000P1Mask: skip 1
axlr0000P2Mask: skip 1
Brightness: skip 1
MosaicDirection: skip 1
MosaicSize: skip 1
KeepModeActive: skip 1
IsTwoPlayerGame: skip 1
PlayerTurnLvl: skip 1
SavedPlayerLives: skip 2
SavedPlayerCoins: skip 2
SavedPlayerPowerup: skip 2
SavedPlayerYoshi: skip 2
SavedPlayerItembox: skip 2
PlayerLives: skip 1
PlayerCoins: skip 1
GreenStarBlockCoins: skip 1
CarryYoshiThruLvls: skip 1
PlayerItembox: skip 1
; 7E0DC3 - 7E0DC6 unused
skip 4
OverworldDestXPos: skip 2
OverworldDestYPos: skip 6
OWPlayerSpeed: skip 4
OWPlayerDirection: skip 2
OWLevelExitMode: skip 1
PlayerTurnOW: skip 2
PlayerSwitching: skip 1
; 7E0DD9 unused
skip 1
MusicBackup: skip 1
; 7E0DDB - 7E0DDD unused
skip 3
SaveFileDelete: skip 1
OWCloudOAMIndex: skip 1
OWCloudYSpeed: skip 5
OWSpriteNumber: skip 16
OWSpriteMisc0DF5: skip 16
OWSpriteMisc0E05: skip 16
OWSpriteMisc0E15: skip 16
OWSpriteMisc0E25: skip 16
OWSpriteXPosLow: skip 16
OWSpriteYPosLow: skip 16
OWSpriteZPosLow: skip 16
OWSpriteXPosHigh: skip 16
OWSpriteYPosHigh: skip 16
OWSpriteZPosHigh: skip 16 ; unused?
OWSpriteXSpeed: skip 16
OWSpriteYSpeed: skip 16
OWSpriteZSpeed: skip 16
OWSpriteXPosSpx: skip 16
OWSpriteYPosSpx: skip 16 ; unused?
OWSpriteZPosSpx: skip 16 ; unused?
KoopaKidActive: skip 1
KoopaKidTile: skip 1
EnterLevelAuto: skip 1
YoshiSavedFlag: skip 1
StatusBar: skip 55
InGameTimerFrames: skip 1
InGameTimerHundreds: skip 1
InGameTimerTens: skip 1
InGameTimerOnes: skip 1
PlayerScore: skip 6
; 7E0F3A - 7E0F3F unused
skip 6
ScoreIncrement: skip 2
; 7E0F42 - 7E0F47 unused
skip 6
PlayerBonusStars: skip 2
ClusterSpriteMisc0F4A: skip 20
ClusterSpriteMisc0F5E: skip 20 ; unused
ClusterSpriteMisc0F72: skip 20
ClusterSpriteMisc0F86: skip 20
ClusterSpriteMisc0F9A: skip 20
BooRingAngleLow: skip 2
BooRingAngleHigh: skip 2
BooRingXPosLow: skip 2
BooRingXPosHigh: skip 2
BooRingYPosLow: skip 2
BooRingYPosHigh: skip 2
BooRingOffscreen: skip 2
BooRingLoadIndex: skip 2
Map16Pointers: skip 1024
ItemMemorySetting: skip 1
TranslevelNo: skip 2
OverworldLayer1Tile: skip 2
CurrentSubmap: skip 2
MoonCounter: skip 1
CutsceneID: skip 1
YoshiColor: skip 1
; 7E13C8 unused
skip 1
ShowContinueEnd: skip 1
ShowSavePrompt: skip 1
UnusedStarCounter: skip 1
CoinAdder: skip 1
DisableMidway: skip 1
MidwayFlag: skip 1
SkipMidwayCastleIntro: skip 1
StructureCrushTile: skip 1
StructureCrushIndex: skip 1
SwitchPalaceColor: skip 1
PauseTimer: skip 1
PauseFlag: skip 1
Layer3ScrollType: skip 1
DrumrollTimer: skip 1
IntroMarchYPosSpx: skip 2
OverworldProcess: skip 1
PlayerXSpeedFPSpx: skip 1
PlayerWalkingPose: skip 1
; 7E13DC unused
skip 1
PlayerTurningPose: skip 1
PlayerOverworldPose: skip 1
PlayerCapePose: skip 1
PlayerPose: skip 1
SlopeType: skip 1
SpinjumpFireball: skip 1
WallrunningType: skip 1
PlayerPMeter: skip 1
PlayerPoseLenTimer: skip 1
; 7E13E6 - 7E13E7 unused
skip 2
CapeInteracts: skip 1
CapeInteractionXPos: skip 2
CapeInteractionYPos: skip 2
PlayerSlopePose: skip 1
CurrentSlope: skip 1
PlayerIsOnGround: skip 1
NetDoorDirIndex: skip 1
VerticalScrollEnabled: skip 1
; 7E13F2 unused
skip 1
PBalloonInflating: skip 1
BonusRoomBlocks: skip 5
PlayerBehindNet: skip 1
PlayerCanJumpWater: skip 1
PlayerIsFrozen: skip 1
ActiveBoss: skip 1
CameraIsScrolling: skip 1
CameraScrollDir: skip 1
CameraScrollPlayerDir: skip 1
CameraProperMove: skip 1
CameraScrollTimer: skip 1
NoteBlockActive: skip 1
Layer3TideSetting: skip 1
ScreenScrollAtWill: skip 1
DrawYoshiInPipe: skip 1
BouncingOnBoard: skip 1
FlightPhase: skip 1
NextFlightPhase: skip 1
MaxStageOfFlight: skip 1
Empty_140A: skip 1
; 7E140B - 7E140C unused
skip 2
SpinJumpFlag: skip 1
Layer2Touched: skip 1
ReznorOAMIndex: skip 1
YoshiHasWingsGfx: skip 1
HorizLayer1Setting: skip 1
VertLayer1Setting: skip 1
HorizLayer2Setting: skip 1
VertLayer2Setting: skip 1
; 7E1415 - 7E1416 unused
skip 2
BackgroundVertOffset: skip 2
YoshiInPipeSetting: skip 1
SublevelCount: skip 1
DidPlayBonusGame: skip 1
SecretGoalTape: skip 1
ShowMarioStart: skip 1
YoshiHasWingsEvt: skip 1
DisableNoYoshiIntro: skip 1
DragonCoinsCollected: skip 1
OneUpCheckpoints: skip 1
DragonCoinsShown: skip 1
SwitchPalacePressed: skip 1
DisplayBonusStars: skip 1
BonusGameActivate: skip 1
MessageBoxTrigger: skip 1
ClownCarImage: skip 1
ClownCarPropeller: skip 1
BowserPalette: skip 1
CameraMoveTrigger: skip 2
CameraLeftBuffer: skip 2
CameraRightBuffer: skip 2
SolidTileStart: skip 1
SolidTileEnd: skip 1
DirectCoinInit: skip 1
SpotlightSize: skip 1
KeyholeTimer: skip 1
KeyholeDirection: skip 1
KeyholeXPos: skip 2
KeyholeYPos: skip 2
UploadMarioStart: skip 1
DeathMessage: skip 1
GameOverAnimation: skip 1
GameOverTimer: skip 1
Layer1ScrollCmd: skip 1
Layer2ScrollCmd: skip 1
Layer1ScrollBits: skip 1
Layer2ScrollBits: skip 1
Layer1ScrollType: skip 1
Layer2ScrollType: skip 1
Layer1ScrollTimer: skip 1
Layer2ScrollTimer: skip 1
Layer1ScrollXSpeed: skip 2
Layer1ScrollYSpeed: skip 2
Layer2ScrollXSpeed: skip 2
Layer2ScrollYSpeed: skip 2
Layer1ScrollXPosUpd: skip 2
Layer1ScrollYPosUpd: skip 2
Layer2ScrollXPosUpd: skip 2
Layer2ScrollYPosUpd: skip 2
ScrollLayerIndex: skip 1
CreditsJumpingYoshi: skip 1
Layer3ScrollXSpeed: skip 2
Layer3ScrollYSpeed: skip 2
Layer3ScrollXPosUpd: skip 2
; 7E145E - 7E145F unused
skip 2
Layer3ScroolDir: skip 1
; 7E1461 unused
skip 1
NextLayer1XPos: skip 2
NextLayer1YPos: skip 2
NextLayer2XPos: skip 2
NextLayer2YPos: skip 2
Layer3HorizOffset: skip 2
; 7E146C - 7E146F unused
skip 4
CarryingFlag: skip 1
StandOnSolidSprite: skip 1
LightTopWinOpenPos: skip 1
; 7E1473 unused
skip 1
LightTopWinClosePos: skip 1
; 7E1475 unused
skip 1
LightBotWinOpenPos: skip 1
; 7E1477 unused
skip 1
LightBotWinClosePos: skip 1
; 7E1479 unused
skip 1
LightWinOpenCalc: skip 1
; 7E147B unused
skip 1
LightWinCloseCalc: skip 1
; 7E147D unused
skip 1
LightWinOpenMove: skip 1
LightWinCloseMove: skip 1
LightLeftWidth: skip 1
LightRightWidth: skip 1
LightSkipInit: skip 1
LightMoveDir: skip 1
LightLeftRelPos: skip 1
LightRightRelPos: skip 1
LightExists: skip 1
; 7E1487 - 7E148A unused
skip 4
RNGCalc: skip 2
RandomNumber: skip 2
IsCarryingItem: skip 1
InvinsibilityTimer: skip 1
SpriteXMovement: skip 1
PlayerPeaceSign: skip 1
EndLevelTimer: skip 1
ColorFadeDir: skip 1
ColorFadeTimer: skip 1
PlayerAniTimer: skip 1
IFrameTimer: skip 1
PickUpItemTimer: skip 1
FaceScreenTimer: skip 1
KickingTimer: skip 1
CyclePaletteTimer: skip 1
ShootFireTimer: skip 1
NetDoorTimer: skip 1
PunchNetTimer: skip 1
TakeoffTimer: skip 1
RunTakeoffTimer: skip 1
SkidTurnTimer: skip 1
CapeAniTimer: skip 1
YoshiTongueTimer: skip 1
CapePumpTimer: skip 1
CapeFloatTimer: skip 1
CapeSpinTimer: skip 1
ReznorBridgeTimer: skip 1
EmptyTimer14A8: skip 1
GroundPoundTimer: skip 1
YoshiWingGrabTimer: skip 1
BonusFinishTimer: skip 1
; 7E14AC unused
skip 1
BluePSwitchTimer: skip 1
SilverPSwitchTimer: skip 1
OnOffSwitch: skip 1
BrSwingCenterXPos: skip 2
BrSwingCenterYPos: skip 2
BrSwingXDist: skip 2
BrSwingYDist: skip 2
BrSwingPlatXPos: skip 2
BrSwingPlatYPos: skip 2
BrSwingRadiusX: skip 2
; 7E14BE unused
skip 1
BrSwingRadiusY: skip 2
; 7E14C1 unused
skip 1
BrSwingSine: skip 2
; 7E14C4 unused
skip 1
BrSwingCosine: skip 2
; 7E14C7 unused
skip 1
SpriteStatus: skip 12
SpriteYPosHigh: skip 12
SpriteXPosHigh: skip 12
SpriteYPosSpx: skip 12
SpriteXPosSpx: skip 12
SpriteMisc1504: skip 12
SpriteMisc1510: skip 12
SpriteMisc151C: skip 12
SpriteMisc1528: skip 12
SpriteMisc1534: skip 12
SpriteMisc1540: skip 12
SpriteMisc154C: skip 12
SpriteMisc1558: skip 12
SpriteMisc1564: skip 12
SpriteMisc1570: skip 12
SpriteMisc157C: skip 12
SpriteBlockedDirs: skip 12
SpriteMisc1594: skip 12
SpriteOffscreenX: skip 12
SpriteMisc15AC: skip 12
SpriteSlope: skip 12
SpriteWayOffscreenX: skip 12
SpriteOnYoshiTongue: skip 12
SpriteDisableObjInt: skip 12
; 7E15E8 unused
skip 1
CurSpriteProcess: skip 1
SpriteOAMIndex: skip 12
SpriteOBJAttribute: skip 12
SpriteMisc1602: skip 12
SpriteMisc160E: skip 12
SpriteLoadIndex: skip 12
SpriteMisc1626: skip 12
SpriteBehindScene: skip 12
SpriteMisc163E: skip 12
SpriteInLiquid: skip 12
SpriteTweakerA: skip 12
SpriteTweakerB: skip 12
SpriteTweakerC: skip 12
SpriteTweakerD: skip 12
SpriteTweakerE: skip 12
SpriteMemorySetting: skip 1
Map16TileNumber: skip 1
SpriteBlockOffset: skip 1
SpriteInterIndex: skip 1
; 7E1696 unused
skip 1
SpriteStompCounter: skip 1
MinorSpriteProcIndex: skip 1
BounceSpriteNumber: skip 4
BounceSpriteInit: skip 4
BounceSpriteYPosLow: skip 4
BounceSpriteXPosLow: skip 4
BounceSpriteYPosHigh: skip 4
BounceSpriteXPosHigh: skip 4
BounceSpriteYSpeed: skip 4
BounceSpriteXSpeed: skip 4
BounceSpriteXPosSpx: skip 4
BounceSpriteYPosSpx: skip 4 ; unused
BounceSpriteTile: skip 4
BounceSpriteTimer: skip 4
BounceSpriteFlags: skip 4
QuakeSpriteNumber: skip 4
QuakeSpriteXPosLow: skip 4
QuakeSpriteXPosHigh: skip 4
QuakeSpriteYPosLow: skip 4
QuakeSpriteYPosHigh: skip 4
ScoreSpriteNumber: skip 6
ScoreSpriteYPosLow: skip 6
ScoreSpriteXPosLow: skip 6
ScoreSpriteXPosHigh: skip 6
ScoreSpriteYPosHigh: skip 6
ScoreSpriteTimer: skip 6
ScoreSpriteLayer: skip 6
ExtSpriteNumber: skip 10
ExtSpriteYPosLow: skip 10
ExtSpriteXPosLow: skip 10
ExtSpriteYPosHigh: skip 10
ExtSpriteXPosHigh: skip 10
ExtSpriteYSpeed: skip 10
ExtSpriteXSpeed: skip 10
ExtSpriteYPosSpx: skip 10
ExtSpriteXPosSpx: skip 10
ExtSpriteMisc1765: skip 10
ExtSpriteMisc176F: skip 10
ExtSpritePriority: skip 10
ShooterNumber: skip 8
ShooterYPosLow: skip 8
ShooterYPosHigh: skip 8
ShooterXPosLow: skip 8
ShooterXPosHigh: skip 8
ShooterTimer: skip 8
ShooterLoadIndex: skip 8
LoadingLevelNumber: skip 1
Layer1DYPos: skip 1
Layer1DXPos: skip 1
Layer2DYPos: skip 1
Layer2DXPos: skip 1
SmokeSpriteNumber: skip 4
SmokeSpriteYPos: skip 4
SmokeSpriteXPos: skip 4
SmokeSpriteTimer: skip 4
CoinSpriteExists: skip 4
CoinSpriteYPosLow: skip 4
CoinSpriteYSpeed: skip 4
CoinSpriteYPosSpx: skip 4
CoinSpriteXPosLow: skip 4
CoinSpriteLayer: skip 4
CoinSpriteYPosHigh: skip 4
CoinsPriteXPosHigh: skip 4
MinExtSpriteNumber: skip 12
MinExtSpriteYPosLow: skip 12
MinExtSpriteXPosLow: skip 12
MinExtSpriteYPosHigh: skip 12
MinExtSpriteYSpeed: skip 12
MinExtSpriteXSpeed: skip 12
MinExtSpriteYPosSpx: skip 12
MinExtSpriteXPosSpx: skip 12
MinExtSpriteTimer: skip 12
PlayerDisableObjInt: skip 1
MinExtSpriteSlotIdx: skip 1
TileGenerateTrackA: skip 1
SprMap16TouchVertLow: skip 1
SprMap16TouchHorizLow: skip 1
SpriteToOverwrite: skip 1
SprMap16TouchHorizHigh: skip 1
SmokeSpriteSlotIdx: skip 1
; 7E1864 unused
skip 1
CoinSpriteSlotIdx: skip 1
BrSwingAngleParity: skip 2
Map16TileHittable: skip 1
; 7E1869 - 7E186A unused
skip 2
MulticoinTimer: skip 1
SpriteOffscreenVert: skip 12
NetDoorPlayerXOffset: skip 1
; 7E1879 unused
skip 1
PlayerRidingYoshi: skip 1
SpriteMisc187B: skip 12
ScreenShakeTimer: skip 1
ScreenShakeYOffset: skip 2
Empty188A: skip 1
ScrShakePlayerYOffset: skip 1
BossBGSpriteUpdate: skip 1
BossBGSpriteXCalc: skip 1
; 7E188E unused
skip 1
BonusGameComplete: skip 1
BonusGame1UpCount: skip 1
PBalloonTimer: skip 1
ClusterSpriteNumber: skip 20
Empty18A6: skip 1
Map16TileDestroy: skip 1
BossPillarFalling: skip 2
BossPillarYPos: skip 2
YoshiSwallowTimer: skip 1
YoshiWalkingTimer: skip 1
YoshiStartEatTimer: skip 1
YoshiDuckTimer: skip 1
YoshiXPos: skip 2
YoshiYPos: skip 2
; 7E18B4 unused
skip 1
StandingOnCage: skip 1
TileGenerateTrackB: skip 1
; 7E18B7 unused
skip 1
ActivateClusterSprite: skip 1
CurrentGenerator: skip 1
BooRingIndex: skip 1
; 7E18BB unused
skip 1
SkullRaftSpeed: skip 1
PlayerStunnedTimer: skip 1
PlayerClimbingRope: skip 1
SpriteWillAppear: skip 1
SpriteRespawnTimer: skip 1
SpriteRespawnNumber: skip 1
PlayerInCloud: skip 1
SpriteRespawnYPos: skip 2
; 7E18C5 - 7E18CC unused
skip 8
BounceSpriteSlotIdx: skip 1
TurnBlockSpinTimer: skip 4
StarKillCounter: skip 1
PlayerSparkleTimer: skip 1
RedBerriesEaten: skip 1
PinkBerriesEaten: skip 1
EatenBerryType: skip 1
SprMap16TouchVertHigh: skip 1
; 7E18D8 unused
skip 1
NoYoshiIntroTimer: skip 1
YoshiEggSpriteHatch: skip 1
Empty18DB: skip 1
PlayerDuckingOnYoshi: skip 1
SilverCoinsCollected: skip 1
EggLaidTimer: skip 1
CurrentYoshiSlot: skip 1
LakituCloudTimer: skip 1
LakituCloudSlot: skip 1
YoshiIsLoose: skip 1
GameCloudCoinCount: skip 1
GivePlayerLives: skip 1
GiveLivesTimer: skip 1
; 7E18E6 unused
skip 1
YoshiCanStomp: skip 1
YoshiGrowingTimer: skip 1
SmokeSpriteSlotFull: skip 1
MinExtSpriteXPosHigh: skip 12
; 7E18F6 unused
skip 1
ScoreSpriteSlotIdx: skip 1
BounceSpriteIntTimer: skip 4
ExtSpriteSlotIdx: skip 1
ChuckIsWhistling: skip 1
DiagonalBulletTimer: skip 1
ShooterSlotIdx: skip 1
BonusStarsGained: skip 1
BounceSpriteYXPPCCCT: skip 4
IggyLarryPlatTilt: skip 1
IggyLarryPlatWait: skip 1
IggyLarryPlatPhase: skip 1
; 7E1908 unused
skip 1
BlockSnakeActive: skip 1
BooCloudTimer: skip 1
BooTransparency: skip 1
DirectCoinTimer: skip 1
FinalCutscene: skip 1
SpriteBuoyancy: skip 1
SpriteTweakerF: skip 12
Empty191B: skip 1
YoshiHasKey: skip 1
SumoClustOverwrite: skip 1
BigSwitchPressTimer: skip 1
; 7E191F unused
skip 1
BonusOneUpsRemain: skip 1
FinalMessageTimer: skip 2
; 7E1923 - 7E1924 unused
skip 2
LevelModeSetting: skip 1
; 7E1926 - 7E1927 unused
skip 2
LevelLoadObject: skip 1
; 7E1929 unused
skip 1
LevelEntranceType: skip 1
SpriteTileset: skip 1
; 7E192C unused
skip 1
ForegroundPalette: skip 1
SpritePalette: skip 1
BackAreaColor: skip 1
BackgroundPalette: skip 1
ObjectTileset: skip 1
Empty1932: skip 1
LayerProcessing: skip 2
MarioStartFlag: skip 1
; 7E1936 - 7E1937 unused
skip 2
SpriteLoadStatus: skip 128
ExitTableLow: skip 32
ExitTableHigh: skip 32
ItemMemoryTable: skip 384
HardcodedPathIsUsed: skip 2
HardcodedPathIndex: skip 2
Layer1PosSpx: skip 2
OverworldTightPath: skip 1
; 7E1B7F unused
skip 1
OverworldClimbing: skip 2
OverworldEventXPos: skip 1
OverworldEventYPos: skip 1
OverworldEventSize: skip 2
OverworldEventProcess: skip 1
OverworldPromptProcess: skip 1
MessageBoxExpand: skip 1
MessageBoxTimer: skip 1
OWPromptArrowDir: skip 1
OWPromptArrowTimer: skip 1
OWTransitionFlag: skip 1
OWTransitionXCalc: skip 2
OWTransitionYCalc: skip 2
BlinkCursorTimer: skip 1
BlinkCursorPos: skip 1
UseSecondaryExit: skip 1
DisableBonusSprite: skip 1
YoshiHeavenFlag: skip 1
SideExitEnabled: skip 1
Empty1B97: skip 2
ShowPeaceSign: skip 1
BGFastScrollActive: skip 1
RemoveYoshiFlag: skip 1
EnteringStarWarp: skip 1
Layer3TideTimer: skip 1
SwapOverworldMusic: skip 1
ReznorBridgeCount: skip 1
OverworldEarthquake: skip 1
LevelLoadObjectTile: skip 1
Mode7TileIndex: skip 1
Mode7GfxBuffer: skip 15
GfxBppConvertBuffer: skip 10
GfxBppConvertFlag: skip 39
Layer3Setting: skip 1
Layer1VramAddr: skip 2
Layer1VramBuffer: skip 256
Layer2VramAddr: skip 2
Layer2VramBuffer: skip 256
OWSubmapSwapProcess: skip 1
CreditsScreenNumber: skip 1
OverworldEvent: skip 1
EventTileIndex: skip 2
EventLength: skip 2
; 7E1DEF unused
skip 1
OverworldFreeCamXPos: skip 2
OverworldFreeCamYPos: skip 2
TitleInputIndex: skip 1
VariousPromptTimer: skip 1
StarWarpIndex: skip 1
StarWarpLaunchSpeed: skip 1
StarWarpLaunchTimer: skip 1
SPCIO0: skip 1
SPCIO1: skip 1
SPCIO2: skip 1
SPCIO3: skip 1
Empty1DFD: skip 2
LastUsedMusic: skip 1
; 7E1E00 unused
skip 1
DebugFreeRoam: skip 1
ClusterSpriteYPosLow: skip 20
ClusterSpriteXPosLow: skip 20
ClusterSpriteYPosHigh: skip 20
ClusterSpriteXPosHigh: skip 20
ClusterSpriteMisc1E52: skip 20
ClusterSpriteMisc1E66: skip 20
ClusterSpriteMisc1E7A: skip 20
ClusterSpriteMisc1E8E: skip 20
OWLevelTileSettings: skip 96
OWEventsActivated: skip 15
OWPlayerSubmap: skip 2
OWPlayerAnimation: skip 4
OWPlayerXPos: skip 2
OWPlayerYPos: skip 6
OWPlayerXPosPtr: skip 2
OWPlayerYPosPtr: skip 6
SwitchBlockFlags: skip 4
; 7E1F2B - 7E1F2D unused
skip 3
ExitsCompleted: skip 1
AllDragonCoinsCollected: skip 12
; 7E1F3B unused
skip 1
Checkpoint1upCollected: skip 12
; 7E1F48 unused
skip 1
SaveDataBuffer: skip 96
SaveDataBufferEvents: skip 15
SaveDataBufferSubmap: skip 2
SaveDataBufferAni: skip 4
SaveDataBufferXPos: skip 2
SaveDataBufferYPos: skip 6
SaveDataBufferXPosPtr: skip 2
SaveDataBufferYPosPtr: skip 6
SaveDataBufferSwitches: skip 4
; 7E1FD2 - 7E1FD4 unused
skip 3
SaveDataBufferExits: skip 1
SpriteMisc1FD6: skip 12
SpriteMisc1FE2: skip 12
MoonCollected: skip 12
; 7E1FFA unused
skip 1
LightningFlashIndex: skip 1
LightningWaitTimer: skip 1
LightningTimer: skip 1
CreditsUpdateBG: skip 1
; 7E1FFF unused
skip 1

ORG $7E2000

NonMirroredWRAM:
MarioGraphics: skip 23808
AnimatedTiles: skip 15360
Layer2TilemapLow:
SwitchAniXPosHigh: skip 40
SwitchAniYPosHigh: skip 40
SwitchAniZPosHigh: skip 40
SwitchAniXPosLow: skip 40
SwitchAniYPosLow: skip 40
SwitchAniZPosLow: skip 40
SwitchAniXSpeed: skip 40
SwitchAniYSpeed: skip 40
SwitchAniZSpeed: skip 40
SwitchAniXSpx: skip 40
SwitchAniYSpx: skip 40 ; unused?
SwitchAniZSpx: skip 40 ; unused?
skip 544
Layer2TilemapHigh: skip 1024
; 7EC100 - 7EC67F unused
skip 1408
Mode7BossTilemap: skip 96
; 7EC6E0 - 7EC7FF unused
skip 288
Map16TilesLow: skip 2048
OWLayer1Translevel: skip 2048
OWLayer2Directions: skip 3072
OWLayer1VramBuffer: skip 7168

ORG $7F0000

OWEventTilemap: skip 3328
; 7F0D00 - 7F3FFF unused
skip 13056
OWLayer2Tilemap: skip 16384
OAMResetRoutine: skip 387
; 7F8183 - 7F837A unused
skip 504
DynStripeImgSize: skip 2
DynamicStripeImage:
; 7F868D - 7F977A unused

ORG $7F977B

MarioStartGraphics: skip 768
WigglerTable: skip 512
; 7F9C7B - 7FC7FF unused
skip 11141
Map16TilesHigh: skip 14336


; SAVE RAM

ORG $700000

SaveData: skip 140
SaveDataChecksum: skip 3
SaveDataFile2: skip 143
SaveDataFile3: skip 143
SaveDataBackup: skip 429
; 70035A - 7007FF unused


; AUDIO RAM

ORG $000000

SPCInEdge: skip 4
SPCOutBuffer: skip 4
SPCInBuffer: skip 4
ARam_0C: skip 2
ARam_0E: skip 2
ARam_10: skip 1
ARam_11: skip 1
ARam_12: skip 1
ARam_13: skip 1
ARam_14: skip 1
ARam_15: skip 1
PitchValue: skip 2
SFX1DF9PhrasePtr: skip 2
SFX1DFCPhrasePtr: skip 2
ARam_1C: skip 1
ChannelsMuted: skip 1
skip 16
ARam_2E: skip 1
ARam_2F: skip 1
VoPhrasePtr: skip 16
BlockPtr: skip 2
MusicLoopCounter: skip 1
MasterTranspose: skip 1
SPCTimer: skip 2
CurrentChannel2: skip 1
ARam_47: skip 1
CurrentChannel: skip 1
ARam_49: skip 1
skip 6
MasterTempo: skip 2
TempoSetTimer: skip 1
TempoSetVal: skip 1
ARam_54: skip 2
ARam_56: skip 1
MasterVolume: skip 1
VolFadeTimer: skip 1
VolFadeVal: skip 1
ARam_5A: skip 2
ARam_5C: skip 2
skip 2
ARam_60: skip 1
EchoVolLeft: skip 2
EchoVolRight: skip 2
ARam_65: skip 2
ARam_67: skip 2
ARam_69: skip 1
ARam_6A: skip 1
skip 5
VoTimers: skip 16
VoPanFade: skip 16
VoPitchSlide: skip 16
VoVibrato: skip 16
ARam_B0: skip 16
VoInstrument: skip 16
skip 32
HW_SPCTEST: skip 1
HW_SPCCONTROL: skip 1
HW_DSPADDR: skip 1
HW_DSPDATA: skip 1
HW_SNESIO0: skip 1
HW_SNESIO1: skip 1
HW_SNESIO2: skip 1
HW_SNESIO3: skip 1
HW_AUXIO0: skip 1
HW_AUXIO1: skip 1
HW_TIMER0: skip 1
HW_TIMER1: skip 1
HW_TIMER2: skip 1
HW_COUNTER0: skip 1
HW_COUNTER1: skip 1
HW_COUNTER2: skip 1
NoteLength: skip 16
ARam_0110: skip 16
skip 224
ARam_0200: skip 16
ARam_0210: skip 16
skip 32
ARam_0240: skip 16
ARam_0250: skip 16
ARam_0260: skip 16
skip 16
ARam_0280: skip 16
ARam_0290: skip 16
ARam_02A0: skip 16
ARam_02B0: skip 16
ARam_02C0: skip 16
ARam_02D0: skip 16
skip 32
ARam_0300: skip 32
ARam_0320: skip 16
ARam_0330: skip 16
ARam_0340: skip 16
ARam_0350: skip 16
ARam_0360: skip 16
ARam_0370: skip 16
ARam_0380: skip 1
ARam_0381: skip 1
ARam_0382: skip 1
ARam_0383: skip 1
ARam_0384: skip 1
ARam_0385: skip 1
ARam_0386: skip 1
ARam_0387: skip 1
ARam_0388: skip 1
ARam_0389: skip 1
skip 86
ARam_03E0: skip 16
ARam_03F0: skip 16
skip 254
HotResetA5: skip 1
HotReset5A: skip 1

ORG $000500
SPCEngine:

ORG $001360
MusicData:

ORG $005570
SoundEffectTable:

ORG $008000
SamplePtrTable: skip 256
SampleTable:


; VIDEO RAM

ORG $000000

VRam_M7Tilemap:
VRam_L1L2Tiles: skip 8192
VRam_L1Tilemap: skip 4096
VRam_L2Tilemap: skip 4096
VRam_L3Tiles: skip 1536
VRam_CreditsLetters: skip 2560
VRam_L3Tilemap: skip 4096
VRam_OBJTiles: