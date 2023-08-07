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

; === $7E0010 ===
; 1 byte
; non-zero during game loop
; set to zero after game loop
; must be non-zero to start game loop
; set to non-zero at end of V-blank
LagFlag: skip 1

; === $7E0011 ===
; 1 byte
; the ID of the currently queued IRQ
; for areas that use multiple IRQs, this value distinguishes them
IRQType: skip 1

; === $7E0012 ===
; 1 byte
; stripe image ID to draw
; index into a list of pointers to stripe images to draw
; must be divisible by 3 or it will draw garbage
; if this value is zero, the address points to the stripe image ram buffer
StripeImage: skip 1

; === $7E0013 ===
; 1 byte
; frame counter
; increments for every frame of execution
; not incremented during lag frames
TrueFrame: skip 1

; === $7E0014 ===
; 1 byte
; frame counter
; increments for every frame of execution when gameplay is not paused or frozen
; not incremented during lag frames
EffFrame: skip 1

; === $7E0015 ===
; 1 byte
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
byetudlrHold: skip 1
; Valid values
!ButB = %10000000
!ButY = %01000000
!ButSelect = %00100000
!ButStart = %00010000
!DpadUp = %00001000
!DpadDown = %00000100
!DpadLeft = %00000010
!DpadRight = %00000001

; === $7E0016 ===
; 1 byte
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
; Valid values
!ButB = %10000000
!ButY = %01000000
!ButSelect = %00100000
!ButStart = %00010000
!DpadUp = %00001000
!DpadDown = %00000100
!DpadLeft = %00000010
!DpadRight = %00000001

; === $7E0017 ===
; 1 byte
; controller data for the currently active player
; axlr0000
; ||||++++ always 0
; |||+---- set if the R button was pressed this frame
; ||+----- set if the L button was pressed this frame
; |+------ set if the X button was pressed this frame
; +------- set if the A button was pressed this frame
axlr0000Hold: skip 1
; Valid values
!ButA = %10000000
!ButX = %01000000
!ButL = %00100000
!ButR = %00010000

; === $7E0018 ===
; 1 byte
; controller data for the currently active player
; axlr0000
; ||||++++ always 0
; |||+---- set if the R button is held this frame
; ||+----- set if the L button is held this frame
; |+------ set if the X button is held this frame
; +------- set if the A button is held this frame
axlr0000Frame: skip 1
; Valid values
!ButA = %10000000
!ButX = %01000000
!ButL = %00100000
!ButR = %00010000

; === $7E0019 ===
; 1 byte
; the player's current powerup status
Powerup: skip 1
; Valid values
!Powerup_Small = 0
!Powerup_Big = 1
!Powerup_Cape = 2
!Powerup_Flower = 3

; === $7E001A ===
; 2 bytes
; the horizontal scroll value for background layer 1
; value buffer for PPU register $210D, BG1HOFS
Layer1XPos: skip 2

; === $7E001C ===
; 2 bytes
; the vertical scroll value for background layer 1
; value buffer for PPU register $210E, BG1VOFS
Layer1YPos: skip 2

; === $7E001E ===
; 2 bytes
; the horizontal scroll value for background layer 2
; value buffer for PPU register $210F, BG2HOFS
Layer2XPos: skip 2

; === $7E0020 ===
; 2 bytes
; the vertical scroll value for background layer 2
; value buffer for PPU register $2110, BG2VOFS
Layer2YPos: skip 2

; === $7E0022 ===
; 2 bytes
; the horizontal scroll value for background layer 3
; value buffer for PPU register $2111, BG3HOFS
Layer3XPos: skip 2

; === $7E0024 ===
; 2 bytes
; the vertical scroll value for background layer 3
; value buffer for PPU register $2112, BG3VOFS
Layer3YPos: skip 2

; === $7E0026 ===
; 2 bytes
; the horizontal difference between the two interactive layers
; the difference between layer 1 and layer 2 or 3 depending on the level mode
Layer23XRelPos: skip 2

; === $7E0028 ===
; 2 bytes
; the vertical difference between the two interactive layers
; the difference between layer 1 and layer 2 or 3 depending on the level mode
Layer23YRelPos: skip 2

; === $7E002A ===
; 2 bytes
; the horizontal co-ordinate of the mode 7 fixed point
; the value stored here is #$0080 more than the PPU register
; value buffer for PPU register $211F, M7X
Mode7CenterX: skip 2

; === $7E002C ===
; 2 bytes
; the vertical co-ordinate of the mode 7 fixed point
; the value stored here is #$0080 more than the PPU register
; value buffer for PPU register $2120, M7Y
Mode7CenterY: skip 2

; === $7E002E ===
; 2 bytes
; the value of the A parameter for the mode 7 transformation matrix
; value buffer for PPU register $211B, M7A
Mode7ParamA: skip 2

; === $7E0030 ===
; 2 bytes
; the value of the B parameter for the mode 7 transformation matrix
; value buffer for PPU register $211C, M7B
Mode7ParamB: skip 2

; === $7E0032 ===
; 2 bytes
; the value of the C parameter for the mode 7 transformation matrix
; value buffer for PPU register $211D, M7C
Mode7ParamC: skip 2

; === $7E0034 ===
; 2 bytes
; the value of the D parameter for the mode 7 transformation matrix
; value buffer for PPU register $211E, M7D
Mode7ParamD: skip 2

; === $7E0036 ===
; 2 bytes
; the value of an angle, where #$0200 marks a complete circle
; used in calculation of mode 7 parameters, and in brown swinging platforms
Mode7Angle: skip 2

; === $7E0038 ===
; 1 byte
; the value of horizontal scaling, where #$20 marks the identity
; used in calculation of mode 7 parameters
; lower values result in higher scaling and vis-versa
Mode7XScale: skip 1

; === $7E0039 ===
; 1 byte
; the value of vertical scaling, where #$20 marks the identity
; used in calculation of mode 7 parameters
; lower values result in higher scaling and vis-versa
Mode7YScale: skip 1

; === $7E003A ===
; 2 bytes
; the horizontal scroll value for the mode 7 background layer
; value buffer for PPU register $210D, BG1HOFS
Mode7XPos: skip 2

; === $7E003C ===
; 2 bytes
; the vertical scroll value for the mode 7 background layer
; value buffer for PPU register $210E, BG1VOFS
Mode7YPos: skip 2

; === $7E003E ===
; 1 byte
; the background mode and layer character size settings
; value buffer for PPU register $2105, BGMODE
; 4321pmmm
; |||||+++ the background mode (0-7)
; ||||+--- set if background layer 3 has high priority
; ++++---- set if background layer 1/2/3/4 has 16x16 characters, else 8x8
MainBGMode: skip 1

; === $7E003F ===
; 1 byte
; index of the OBJ that should take highest priority
; value buffer for PPU register $2102, OAMADDL
; highest bit of $2103, OAMADDH, is set automatically
OAMAddress: skip 1

; === $7E0040 ===
; 1 byte
; color math settings
; value buffer for PPU register $2131, CGADSUB
; shbo4321
; ||++++++ set if background layer 1/2/3/4/OBJ/back color should participate in color math
; |+------ set if color math result should be halved (e.g. average)
; +------- set if subtract subscreens, else add
ColorSettings: skip 1

; === $7E0041 ===
; 1 byte
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
Layer12Window: skip 1

; === $7E0042 ===
; 1 byte
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
Layer34Window: skip 1

; === $7E0043 ===
; 1 byte
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
OBJCWWindow: skip 1

; === $7E0044 ===
; 1 byte
; color math enable and selection switch
; value buffer for PPU register $2130, CGSWSEL
; mmss--fd
; ||||  |+ set if direct color is enabled
; ||||  +- set for color math between subscreens, clear for fixed color math
; ||++---- color window sub screen (00 = on, 01 = inside, 10 = outside, 11 = off)
; ++------ color window main screen (00 = on, 01 = inside, 10 = outside, 11 = off)
ColorAddition: skip 1

; === $7E0045 ===
; 2 bytes
; In horizontal levels:
;     the X coordinate (in 16x16 tiles) of the
;     left edge of currently loaded Layer 1 tilemap data
; In vertical levels:
;     the Y coordinate (in 16x16 tiles) of the
;     top edge of currently loaded Layer 1 tilemap data
Layer1TileUp: skip 2

; === $7E0047 ===
; 2 bytes
; In horizontal levels:
;     the X coordinate (in 16x16 tiles) of the
;     right edge of currently loaded Layer 1 tilemap data
; In vertical levels:
;     the Y coordinate (in 16x16 tiles) of the
;     bottom edge of currently loaded Layer 1 tilemap data
Layer1TileDown: skip 2

; === $7E0049 ===
; 2 bytes
; In horizontal levels:
;     the X coordinate (in 16x16 tiles) of the
;     left edge of currently loaded Layer 2 tilemap data
; In vertical levels:
;     the Y coordinate (in 16x16 tiles) of the
;     top edge of currently loaded Layer 2 tilemap data
Layer2TileUp: skip 2

; === $7E004B ===
; 2 bytes
; In horizontal levels:
;     the X coordinate (in 16x16 tiles) of the
;     right edge of currently loaded Layer 2 tilemap data
; In vertical levels:
;     the Y coordinate (in 16x16 tiles) of the
;     bottom edge of currently loaded Layer 2 tilemap data
Layer2TileDown: skip 2

; === $7E004D ===
; 2 bytes
; In horizontal levels:
;     the X coordinate of Layer 1 when a column of tiles
;     was last uploaded to VRAM via scrolling left
; In vertical levels:
;     the Y coordinate of Layer 1 when a column of tiles
;     was last uploaded to VRAM via scrolling up
Layer1PrevTileUp: skip 2

; === $7E004F ===
; 2 bytes
; In horizontal levels:
;     the X coordinate of Layer 1 when a column of tiles
;     was last uploaded to VRAM via scrolling right
; In vertical levels:
;     the Y coordinate of Layer 1 when a column of tiles
;     was last uploaded to VRAM via scrolling down
Layer1PrevTileDown: skip 2

; === $7E0051 ===
; 2 bytes
; In horizontal levels:
;     the X coordinate of Layer 2 when a column of tiles
;     was last uploaded to VRAM via scrolling left
; In vertical levels:
;     the Y coordinate of Layer 2 when a column of tiles
;     was last uploaded to VRAM via scrolling up
Layer2PrevTileUp: skip 2

; === $7E0053 ===
; 2 bytes
; In horizontal levels:
;     the X coordinate of Layer 2 when a column of tiles
;     was last uploaded to VRAM via scrolling right
; In vertical levels:
;     the Y coordinate of Layer 2 when a column of tiles
;     was last uploaded to VRAM via scrolling down
Layer2PrevTileDown: skip 2

; === $7E0055 ===
; 1 byte
; Which direction Layer 1 has scrolled
; used for handling camera behavior and spawning sprites
Layer1ScrollDir: skip 1
; Valid values
!ScrollDir_LeftUp = 0
!ScrollDir_Loading = 1
!ScrollDir_RightDown = 2

; === $7E0056 ===
; 1 byte
; Which direction Layer 2 has scrolled
; used for handling camera behavior
Layer2ScrollDir: skip 1
; Valid values
!ScrollDir_LeftUp = 0
!ScrollDir_RightDown = 2

; === $7E0057 ===
; 1 byte
; Position of a 16x16 tile within a screen
; Used during level loading
LevelLoadPos: skip 1

; === $7E0058 ===
; 1 byte
; unused
WRAM_0058: skip 1

; === $7E0059 ===
; 1 byte
; Size or extended type of the currently loading object
LvlLoadObjSize: skip 1

; === $7E005A ===
; 1 byte
; Object number of the currently loading object
LvlLoadObjNo: skip 1

; === $7E005B ===
; 1 byte
; Level type properties
; id----21
; ||    |+ Layer 1 is vertical
; ||    +- Layer 2 is vertical
; |+------ set to disable interaction with Layer 1
; +------- set to enable interaction with Layer 2
ScreenMode: skip 1
; Valid values
!ScrMode_Layer1Vert = %01
!ScrMode_Layer2Vert = %10
!ScrMode_DisableL1Int = %01000000
!ScrMode_EnableL2Int = %10000000

; === $7E005C ===
; 1 byte
; unused
WRAM_005C: skip 1

; === $7E005D ===
; 1 byte
; Number of screens in a level
; Set to -1 during Ludwig and Reznor battles, which represents 1.5
LevelScrLength: skip 1

; === $7E005E ===
; 1 byte
; In horizontal levels: the last screen of the level (stop scrolling right)
LastScreenHoriz: skip 1

; === $7E005F ===
; 1 byte
; In vertical levels: the last screen of the level (stop scrolling down)
LastScreenVert: skip 1

; === $7E0060 ===
; 4 bytes
; unused
WRAM_0060: skip 4

; === $7E0064 ===
; 1 byte
; Default properties for all objects
; yxppccct
; |||||||+ 9th bit of tile number
; ||||+++- palette
; ||++---- object priority
; |+------ x flip
; +------- y flip
SpriteProperties: skip 1
; Valid values
!OBJ_Priority0 = %000000
!OBJ_Priority1 = %010000
!OBJ_Priority2 = %100000
!OBJ_Priority3 = %110000
!OBJ_XFlip = %01000000
!OBJ_YFlip = %10000000

; === $7E0065 ===
; 3 bytes
; pointer to Layer 1 level data
Layer1DataPtr:

; === $7E0065 ===
; 2 bytes
; position of the currently loading line of staff roll text
StaffRollLinePos: skip 2

; === $7E0067 ===
; 1 byte
; current line of the staff roll being drawn
StaffRollCurLine: skip 1

; === $7E0068 ===
; 3 bytes
; pointer to Layer 2 level data
Layer2DataPtr: skip 3

; === $7E006B ===
; 3 bytes
; pointer to Layer 1 Map16 data
Map16LowPtr: skip 3

; === $7E006E ===
; 3 bytes
; pointer to Layer 2 Map16 data
Map16HighPtr: skip 3

; === $7E0071 ===
; 1 byte
; Current player animation that blocks player input
PlayerAnimation: skip 1
; Valid values
!PlayerAni_Default = 0
!PlayerAni_IFrames = 1
!PlayerAni_Growing = 2
!PlayerAni_GetCape = 3
!PlayerAni_GetFire = 4
!PlayerAni_EnterHPipe = 5
!PlayerAni_EnterVPipe = 6
!PlayerAni_CannonPipe = 7
!PlayerAni_YoshiHeaven = 8
!PlayerAni_Death = 9
!PlayerAni_EnterCastle = 10
!PlayerAni_Frozen = 11
!PlayerAni_CastleCutscene = 12
!PlayerAni_Door = 13

; === $7E0072 ===
; 1 byte
; set if player is not on the ground
PlayerInAir: skip 1
; Valid values
!PlayerAir_Jump = 11 ; normal jump or swimming in water level
!PlayerAir_Takeoff = 12 ; pspeed jump
!PlayerAir_Falling = 36 ; descending or swimming in non-water level

; === $7E0073 ===
; 1 byte
; set if player is ducking
PlayerIsDucking: skip 1
; Valid values
!PlayerDuck_Duck = 4

; === $7E0074 ===
; 1 byte
; set if player is climbing
; n--shbtc
; |  ||||+ center collision
; |  |||+- top collision
; |  ||+-- bottom collision
; |  |+--- top horizontal collision
; |  +---- bottom horizontal collision
; +------- can climb diagonally (net vs vine)
PlayerIsClimbing: skip 1
; Valid values
!PlayerClimb_Center = %00001
!PlayerClimb_Top = %00010
!PlayerClimb_Bottom = %00100
!PlayerClimb_SideTop = %01000
!PlayerClimb_SideBottom = %10000
!PlayerClimb_Diagonally = %10000000

; === $7E0075 ===
; 1 byte
; set if player is in water
PlayerInWater: skip 1

; === $7E0076 ===
; 1 byte
; direction player is facing
PlayerDirection: skip 1
; Valid values
!PlayerDir_Left = 0
!PlayerDir_Right = 1

; === $7E0077 ===
; 1 byte
; flags for player collision with blocks
; s--cudlr
; |  ||||+ collision on right side
; |  |||+- collision on left side
; |  ||+-- collision on bottom
; |  |+--- collision on top
; |  +---- collision inside
; +------- collision with edge of screen
PlayerBlockedDir: skip 1
; Valid values
!PlayerBlock_Right = %00001
!PlayerBlock_Left = %00010
!PlayerBlock_Bottom = %00100
!PlayerBlock_Top = %01000
!PlayerBlock_Inside = %10000
!PlayerBlock_Screen = %10000000

; === $7E0078 ===
; 1 byte
; bitfield to hide certain tiles that make up the player
; sabcxylu
; |||||||+ upper half of body
; ||||||+- lower half of body
; ||||++-- various extra smaller tiles
; |||+---- cape tile
; |++----- various other cape tiles
; +------- don't decrement star timer (used with brown swinging platforms)
PlayerHiddenTiles: skip 1
; Valid values
!PlayerHide_None = %00000000
!PlayerHide_Body = %00000011
!PlayerHide_Extra = %00001100
!PlayerHide_Cape = %00010000
!PlayerHide_CapeX1 = %00100000
!PlayerHide_CapeX2 = %01000000
!PlayerHide_All = %01111111
!PlayerHide_PauseStar = %10000000

; === $7E0079 ===
; 1 byte
WRAM_0079: skip 1

; === $7E007A ===
; 2 bytes
; 4.12 fixed point player horizontal speed (pixels per frame)
; while all 16 bits are used for acceleration, only the
; upper 8 bits are used for position calculation
PlayerXSpeed: skip 2

; === $7E007C ===
; 2 bytes
; 4.12 fixed point player vertical speed (pixels per frame)
; while all 16 bits are used for acceleration, only the
; upper 8 bits are used for position calculation
PlayerYSpeed: skip 2

; === $7E007E ===
; 2 bytes
; player horizontal position relative to the screen boundary
PlayerXPosScrRel: skip 2

; === $7E0080 ===
; 2 bytes
; player horizontal position relative to the screen boundary
PlayerYPosScrRel: skip 2

; === $7E0082 ===
; 3 bytes
; pointer to various slope data
; changes with the level tileset
SlopesPtr: skip 3

; === $7E0085 ===
; 1 byte
; set if the level is a completely underwater level
LevelIsWater: skip 1

; === $7E0086 ===
; 1 byte
; set if the level is slippery
LevelIsSlippery: skip 1

; === $7E0087 ===
; 1 byte
; unused
WRAM_0087: skip 1

; === $7E0088 ===
; 1 byte
; timer that controls how long the animation is
; for entering/exiting a pipe
PipeTimer:

; === $7E0088 ===
; 1 byte
; index into no yoshi intro auto input
NoYoshiInputIndex:

; === $7E0088 ===
; 1 byte
; timer for castle cutscene auto input (how long each input lasts)
CutsceneInputTimer: skip 1

; === $7E0089 ===
; 1 byte
; which pipe animation to display
PlayerPipeAction:
; Valid values
!PlayerPipe_EnterRight = 0
!PlayerPipe_EnterLeft = 1
!PlayerPipe_EnterDown = 2
!PlayerPipe_EnterUp = 3
!PlayerPipe_ExitLeft = 4
!PlayerPipe_ExitRight = 5
!PlayerPipe_ExitUp = 6
!PlayerPipe_ExitDown = 7

; === $7E0089 ===
; 1 byte
; timer for no yoshi intro auto input (how long each input lasts)
NoYoshiInputTimer: skip 1

; === $7E008A ===
; 1 byte
; temporary location for player Y speed
; used when calculating player speed when running on a wall
TempPlayerYSpeed:

; === $7E008A ===
; 2 bytes
; running sum for calculating the checksum of save files
PartialChecksum:

; === $7E008A ===
; 1 byte
; number of options in the current menu
MaxMenuOptions:

; === $7E008A ===
; 3 bytes
; pointer to the current position within compressed graphics data
GraphicsCompPtr:

; === $7E008A ===
; 1 byte
; which player interaction points are in water
; ---shbtc
;    ||||+ center collision
;    |||+- top collision
;    ||+-- bottom collision
;    |+--- top horizontal collision
;    +---- bottom horizontal collision
InteractionPtsInWater: skip 1

; === $7E008B ===
; 1 byte
; which player interaction points are on a climbable tile
; ---shbtc
;    ||||+ center collision
;    |||+- top collision
;    ||+-- bottom collision
;    |+--- top horizontal collision
;    +---- bottom horizontal collision
InteractionPtsClimbable: skip 1

; === $7E008C ===
; 1 byte
; which side of a block the current player interaction point is touching
InteractionPtDirection: skip 1

; === $7E008D ===
; 3 bytes
; pointer to the current position within decompressed graphics data
GraphicsUncompPtr:

; === $7E008D ===
; 1 byte
; temporary copy of PlayerIsOnGround
; ------21
;       |+ set if player standing on Layer 1
;       +- set if player standing on Layer 2
TempPlayerGround: skip 1

; === $7E008E ===
; 1 byte
; temporary copy of ScreenMode
; Level type properties
; id----21
; ||    |+ Layer 1 is vertical
; ||    +- Layer 2 is vertical
; |+------ set to disable interaction with Layer 1
; +------- set to enable interaction with Layer 2
TempScreenMode: skip 1

; === $7E008F ===
; 1 byte
; temporary copy of PlayerInAir
TempPlayerAir:

; === $7E008F ===
; 1 byte
; index into castle cutscene auto input
CutsceneInputIndex: skip 1

; === $7E0090 ===
; 1 byte
; vertical position of the player within a block
; relative to the player's feet
PlayerYPosInBlock: skip 1

; === $7E0091 ===
; 1 byte
; vertical position of the player's interaction point within a block
PlayerBlockMoveY: skip 1

; === $7E0092 ===
; 1 byte
; horizontal position of the player within a block
; relative to the center of the player
PlayerXPosInBlock: skip 1

; === $7E0093 ===
; 1 byte
; which side of a tile the player is currently within
PlayerBlockXSide: skip 1

; === $7E0094 ===
; 2 bytes
; horizontal position of the player within the level
; forward calculation for the next frame
PlayerXPosNext: skip 2

; === $7E0096 ===
; 2 bytes
; vertical position of the player within the level
; forward calculation for the next frame
PlayerYPosNext: skip 2

; === $7E0098 ===
; 2 bytes
; vertical position of the currently processing player interaction point
TouchBlockYPos: skip 2

; === $7E009A ===
; 2 bytes
; horizontal position of the currently processing player interaction point
TouchBlockXPos: skip 2

; === $7E009C ===
; 1 byte
; a Map16 tile to draw to the screen
Map16TileGenerate: skip 1
; Valid values
!Map16Gen_CollectEmpty = 1 ; sets item memory
!Map16Gen_Empty = 2
!Map16Gen_Vine = 3
!Map16Gen_Bush = 4
!Map16Gen_TurningBlock = 5
!Map16Gen_Coin = 6
!Map16Gen_MushStalk = 7
!Map16Gen_MoleHole = 8
!Map16Gen_SolidEmpty = 9
!Map16Gen_TurnMulticoin = 10
!Map16Gen_QMulticoin = 11
!Map16Gen_TurnBlock = 12
!Map16Gen_UsedBlock = 13
!Map16Gen_NoteBlock = 14
!Map16Gen_NoteUnused = 15
!Map16Gen_NoteAllSides = 16
!Map16Gen_TurnBounce = 17
!Map16Gen_Roulette = 18
!Map16Gen_OnOff = 19
!Map16Gen_PipeLeft = 20
!Map16Gen_PipeRight = 21
!Map16Gen_CollectUsed = 22 ; sets item memory
!Map16Gen_CollectCorrect = 23 ; sets item memory
!Map16Gen_CollectDragon = 24 ; sets item memory
!Map16Gen_NetDoorEmpty = 25
!Map16Gen_NetDoorClosed = 26
!Map16Gen_FlatSwitch = 27

; === $7E009D ===
; 1 byte
; locks most animations and movements when set
SpriteLock: skip 1

; === $7E009E ===
; 12 bytes
; sprite ID table
SpriteNumber: skip 12

; === $7E00AA ===
; 12 bytes
; sprite vertical speed table
SpriteYSpeed: skip 12

; === $7E00B6 ===
; 12 bytes
; sprite horizontal speed table
SpriteXSpeed: skip 12

; === $7E00C2 ===
; 12 bytes
; various sprite properties table
SpriteTableC2: skip 12

; === $7E00CE ===
; 3 bytes
; pointer to the level's sprite data
SpriteDataPtr: skip 3

; === $7E00D1 ===
; 2 bytes
; horizontal position of the player within the level
PlayerXPosNow: skip 2

; === $7E00D3 ===
; 2 bytes
; vertical position of the player within the level
PlayerYPosNow: skip 2

; === $7E00D5 ===
; 3 bytes
; pointer to the segment data of currently processing Wiggler
WigglerSegmentPtr: skip 3

; === $7E00D8 ===
; 12 bytes
; sprite vertical position table
; lower 8 bits
SpriteYPosLow: skip 12

; === $7E00E4 ===
; 12 bytes
; sprite horizontal position table
; lower 8 bits
SpriteXPosLow: skip 12

; === $7E00F0 ===
; 16 bytes
; unused
WRAM_00F0:

ORG $000100

StackPage:

; === $7E0100 ===
; 1 byte
; the current game mode
GameMode: skip 1
; Valid values
!GameMode_LoadPresents = 0
!GameMode_Presents = 1
!GameMode_FadeToTitleScreen = 2
!GameMode_LoadTitleScreen = 3
!GameMode_PrepareTitleScreen = 4
!GameMode_FadeInTitleScreen = 5
!GameMode_SpotlightTitleScreen = 6
!GameMode_TitleScreen = 7
!GameMode_FileSelect = 8
!GameMode_FileDelete = 9
!GameMode_PlayerSelect = 10
!GameMode_FadeToOverworld = 11
!GameMode_LoadOverworld = 12
!GameMode_FadeInOverworld = 13
!GameMode_Overworld = 14
!GameMode_FadeToLevel = 15
!GameMode_FadeLevelBlack = 16
!GameMode_LoadLevel = 17
!GameMode_PrepareLevel = 18
!GameMode_FadeInLevel = 19
!GameMode_Level = 20
!GameMode_FadeToGameOver = 21
!GameMode_LoadGameOver = 22
!GameMode_GameOver = 23
!GameMode_FadeToCutscene = 24
!GameMode_LoadCutscene = 25
!GameMode_FadeInCutscene = 26
!GameMode_Cutscene = 27
!GameMode_FadeToThankYou = 28
!GameMode_LoadThankYou = 29
!GameMode_FadeInThankYou = 30
!GameMode_ThankYou = 31
!GameMode_FadeToEnemyList = 32
!GameMode_LoadEnemyList = 33
!GameMode_FadeInEnemyList = 34
!GameMode_EnemyList = 35
!GameMode_FadeToTheEnd = 36
!GameMode_LoadTheEnd = 37
!GameMode_FadeInTheEnd = 38
!GameMode_TheEnd = 39

; === $7E0101 ===
; 4 bytes
; the four currently loaded sprite graphics files loaded in VRAM
SpriteGFXFile: skip 4

; === $7E0105 ===
; 4 bytes
; the four currently loaded sprite graphics files loaded in VRAM
BackgroundGFXFile: skip 4

; === $7E0109 ===
; 1 byte
; translevel number to load in lieu of the overworld
OverworldOverride: skip 1

; === $7E010A ===
; 1 byte
; the current save file to save to
SaveFile: skip 6

; === $7E0110 ===
; 2 bytes
; timer used for the size of the letterboxing during the credits
; (only used in PAL v1.1)
CreditsLetterbox: skip 1

; $7E0112 - $7E01FF used as stack

ORG $0001FF

; === $7E01FF ===
; variable size
; stack starts here and grows down
; ~240 bytes available before Bad Things(TM) happen
StackStart: skip 1

; === $7E0200 ===
; 512 bytes
; a work RAM buffer of Object Attribute Memory (OAM)
; table 1: object position, tile, and attributes
OAMMirror:

; === $7E0200 ===
; 128 objects
; the lower 8 bits of the object's X position on the screen
OAMTileXPos: skip 1

; === $7E0201 ===
; 128 objects
; the 8 bits of the object's Y position on the screen
; $E0 is just off the bottom of the screen
OAMTileYPos: skip 1

; === $7E0202 ===
; 128 objects
; the lower 8 bits of the tile number that the object uses
OAMTileNo: skip 1

; === $7E0203 ===
; 128 objects
; various properties of the object
; yxppccct
; |||||||+ the higher 1 bit of the tile number the object uses
; ||||+++- the palette that the object uses
; ||++---- the priority that this object has against backgrounds
; |+------ the object is flipped horizontally
; +------- the object is flipped vertically
OAMTileAttr: skip 1

ORG $000400

; === $7E0400 ===
; 32 bytes
; a work RAM buffer of Object Attribute Memory (OAM)
; table 2: object high X position & size
OAMTileBitSize: skip 32

; === $7E0400 ===
; 128 bytes
; expanded table of object attributes for OAM table 2
; one byte per object
; ------sx
;       |+ the higher 1 bit of the object's X position on the screen
;       +- the size of the object (big or small)
OAMTileSize: skip 128

; === $7E04A0 ===
; 480 bytes
; window left and right positions for each line
; 2 bytes per line
; last 32 lines are seldom used outside of the PAL release
WindowTable:

; === $7E04A0 ===
; 10 bytes
; HDMA table for background layer 1 position during the
; enemy names credits scenes
; first two entries are for the top half
; (split in two because it can be large)
; last entry for bottom half
CreditsL1HDMATable: skip 10

; === $7E04AA ===
; 10 bytes
; HDMA table for background layer 2 position during the
; enemy names credits scenes
; first two entries are for the top half
; (split in two because it can be large)
; last entry for bottom half
CreditsL2HDMATable: skip 10

; === $7E04B4 ===
; 10 bytes
; HDMA table for background layer 3 position during the
; enemy names credits scenes
; first two entries are for the top half
; (split in two because it can be large)
; last entry for bottom half
CreditsL3HDMATable: skip 460

; === $7E0680 ===
; 1 byte
; which palette table to use
PaletteIndexTable: skip 1
; Valid values
!PaletteTableUse_Dynamic = 0
!PaletteTableUse_Copy = 3
!PaletteTableUse_Main = 6

; === $7E0681 ===
; 1 byte
; the current size of the dynamic palette upload table
DynPaletteIndex: skip 1

; === $7E0682 ===
; 127 bytes
; list of entries of colors to upload to CGRAM
; each entry has a 2 byte header
; header byte 1 = number of bytes to upload in this entry
; header byte 2 = CGRAM word address to upload this entry
; data = the colors to upload
DynPaletteTable: skip 127

; === $7E0701 ===
; 2 bytes
; the fixed color, commonly used for the background
; value buffer for PPU register $2132, COLDATA
BackgroundColor: skip 2

; === $7E0703 ===
; 512 bytes
; a work RAM buffer of the entirety of CGRAM
MainPalette: skip 512

; === $7E0903 ===
; 2 bytes
; copy of the background color
; used during level end palette fade in and out
CopyBGColor: skip 2

; === $7E0905 ===
; 496 bytes
; a copy of almost all of CGRAM, missing the last 8 colors
; used during level end palette fade in and out
; as well as overworld event tile fading animation
CopyPalette: skip 496

; === $7E0AF5 ===
; 1 byte
; mostly unused
; cleared after a boss is beaten
Empty0AF5: skip 1

; === $7E0AF6 ===
; 352 bytes
; graphics buffer for animated tiles on the overworld
GfxDecompOWAni:

; === $7E0AF6 ===
; 256 bytes
; tilemap for Iggy and Larry's rotating platform
IggyLarryPlatInteract:

; === $7E0AF6 ===
; 15 bytes
; timer for sprites during credits and castle cutscenes
CreditsSprTimer: skip 15

; === $7E0B05 ===
; 15 bytes
; Y speed for sprites during credits and castle cutscenes
; upper 8 bits of 4.12 fixed point in pixels per frame
CreditsSprYSpeed: skip 15

; === $7E0B14 ===
; 15 bytes
; X speed for sprites during credits and castle cutscenes
; upper 8 bits of 4.12 fixed point in pixels per frame
CreditsSprXSpeed: skip 15

; === $7E0B23 ===
; 15 bytes
; Y speed fractional part for sprites during credits and castle cutscenes
; lower 8 bits of 4.12 fixed point in pixels per frame
CreditsSprYSubSpd: skip 15

; === $7E0B32 ===
; 15 bytes
; X speed fractional part for sprites during credits and castle cutscenes
; lower 8 bits of 4.12 fixed point in pixels per frame
CreditsSprXSubSpd: skip 15

; === $7E0B41 ===
; 15 bytes
; low byte of Y position for sprites during credits and castle cutscenes
CreditsSprYPosLow: skip 15

; === $7E0B50 ===
; 15 bytes
; low byte of X position for sprites during credits and castle cutscenes
CreditsSprXPosLow: skip 15

; === $7E0B5F ===
; 15 bytes
; high byte of Y position for sprites during credits and castle cutscenes
CreditsSprYPosHigh: skip 15

; === $7E0B6E ===
; 15 bytes
; high byte of X position for sprites during credits and castle cutscenes
CreditsSprXPosHigh: skip 15

; === $7E0B7D ===
; 15 bytes
; vertical acceleration for sprites during credits and castle cutscenes
CastleCutExSprAccel: skip 15

; === $7E0B8C ===
; 15 bytes
; flag to denote slot taken for sprites during credits and castle cutscenes
CastleCutExSprSlot: skip 106

; === $7E0BF6 ===
; 384 bytes
; graphics buffer for OBJ tiles $4A-$4F & $5A-$5F
; includes small pieces of Mario, springboard, sliding Koopa, et al
GfxDecompSP1: skip 384

; === $7E0D76 ===
; 2 bytes
; source address of the first of three
; animated 16x16 tiles uploaded this frame
Gfx33SrcAddrA: skip 2

; === $7E0D78 ===
; 2 bytes
; source address of the second of three
; animated 16x16 tiles uploaded this frame
Gfx33SrcAddrB: skip 2

; === $7E0D7A ===
; 2 bytes
; source address of the third of three
; animated 16x16 tiles uploaded this frame
Gfx33SrcAddrC: skip 2

; === $7E0D7C ===
; 2 bytes
; destination VRAM address of the first of three
; animated 16x16 tiles uploaded this frame
Gfx33DestAddrA: skip 2

; === $7E0D7E ===
; 2 bytes
; destination VRAM address of the second of three
; animated 16x16 tiles uploaded this frame
Gfx33DestAddrB: skip 2

; === $7E0D80 ===
; 2 bytes
; destination VRAM address of the third of three
; animated 16x16 tiles uploaded this frame
Gfx33DestAddrC: skip 2

; === $7E0D82 ===
; 2 bytes
; pointer to the player's palette (bank is $00)
PlayerPalletePtr: skip 2

; === $7E0D84 ===
; 1 byte
; number of 8x8 tiles that make up the player
PlayerGfxTileCount: skip 1

; === $7E0D85 ===
; 20 bytes
; 10 pointers to graphics that make up various parts of
; Mario, Yoshi, cape, and Podoboo
DynGfxTilePtr: skip 20

; === $7E0D99 ===
; 2 bytes
; pointer to graphics that make up parts of Mario (OBJ tile $7F)
DynGfxTile7FPtr: skip 2

; === $7E0D9A ===
; 1 byte
; flag to determine which NMI and IRQ code to run for various game modes
IRQNMICommand: skip 1
; Valid values
!IRQNMI_Standard = 0
!IRQNMI_Cutscenes = 1
!IRQNMI_Overworld = 2
!IRQNMI_IggyLarry = %10000000
!IRQNMI_ReznorMortonRoy = %11000000
!IRQNMI_Bowser = %11000001

; === $7E0D9C ===
; 1 byte
; unused
WRAM_0D9C: skip 1


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
PlayerXPosSpx: skip 1
PlayerWalkingPose: skip 1
PlayerYPosSpx: skip 1 ; unused
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

; === $7E1403 ===
; 1 byte
; which layer 3 tide setting is enabled
Layer3TideSetting: skip 1
; Valid values
!Tide_UpAndDown = 1
!Tide_Stationary = 2

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
CutsceneTextTimer:
SelectedStartingZone:
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
LakituCloudTempXPos:
IggyLarryRotCenterX:
BrSwingCenterXPos:
BowserWaitTimer: skip 1
BowserAttackTimer: skip 1
LakituCloudTempYPos:
IggyLarryRotCenterY:
BrSwingCenterYPos:
BowserFlyawayCounter: skip 1
ClownCarTeardropPos: skip 1
IggyLarryPlatIntXPos:
BrSwingXDist:
BowserMusicIndex: skip 1
BowserHurtState: skip 1
IggyLarryPlatIntYPos:
BrSwingYDist:
BowserSteelieTimer: skip 1
BowserFireXPos: skip 1
IggyLarryTempXPos:
BrSwingPlatXPos:
BowserAttackType: skip 2
IggyLarryTempYPos:
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

SaveData: skip !SaveFileSize-3
SaveDataExitCount: skip 1
SaveDataChecksum: skip 2
SaveDataFile2: skip !SaveFileSize
SaveDataFile3: skip !SaveFileSize
SaveDataBackup: skip 3*!SaveFileSize
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
VRam_L1Tiles: 
VRam_L2Tiles:
VRam_GFX_FG1: skip 2048
VRam_GFX_FG2: skip 2048
VRam_GFX_BG1: skip 2048
VRam_GFX_FG3: skip 2048
VRam_L1Tilemap: skip 4096
VRam_L2Tilemap: skip 4096
VRam_L3Tiles: skip 1536
VRam_CreditsLetters: skip 2560
VRam_L3Tilemap: skip 2048
VRam_L1Mode7Tilemap: skip 2048
VRam_OBJTiles:
VRam_GFX_SP1: skip 2048
VRam_GFX_SP2: skip 2048
VRam_L1Mode7Tiles:
VRam_GFX_SP3: skip 2048
VRam_GFX_SP4: