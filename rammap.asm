incsrc "hardware_registers.asm"

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

!IRQType = $7E0011
!StripeImage = $7E0012

; frame counter
; increments for every frame of execution
; not incremented during lag frames
; 1 byte
!TrueFrame = $7E0013

!EffFrame = $7E0014
!byetudlrHold = $7E0015
!byetudlrFrame = $7E0016
!axlr0000Hold = $7E0017
!axlr0000Frame = $7E0018
!Powerup = $7E0019
!Layer1XPos = $7E001A
!Layer1YPos = $7E001C
!Layer2XPos = $7E001E
!Layer2YPos = $7E0020
!Layer3XPos = $7E0022
!Layer3YPos = $7E0024
!Layer23XRelPos = $7E0026
!Layer23YRelPos = $7E0028
!Mode7CenterX = $7E002A
!Mode7CenterY = $7E002C
!Mode7ParamA = $7E002E
!Mode7ParamB = $7E0030
!Mode7ParamC = $7E0032
!Mode7ParamD = $7E0034
!Mode7Angle = $7E0036
!Mode7XScale = $7E0038
!Mode7YScale = $7E0039
!Mode7XPos = $7E003A
!Mode7YPos = $7E003C
!MainBGMode = $7E003E
!OAMAddress = $7E003F
!ColorSettings = $7E0040
!Layer12Window = $7E0041
!Layer34Window = $7E0042
!OBJCWWindow = $7E0043
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


; brightness
; value used by V-blank to exit F-blank
; #$00-#$0F
; 1 byte
!Brightness = $7E0DAE