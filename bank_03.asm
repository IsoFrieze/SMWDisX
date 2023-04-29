    ORG $038000

StompSFX3:
    db !SFX_STOMP1
    db !SFX_STOMP2
    db !SFX_STOMP3
    db !SFX_STOMP4
    db !SFX_STOMP5
    db !SFX_STOMP6
    db !SFX_STOMP7

DATA_038007:
    db $F0,$F8,$FC,$00,$04,$08,$10

DATA_03800E:
    db $A0,$D0,$C0,$D0

Football:
; Sound effects for Mario bouncing off a Rex or killing it with star power.
; X speeds to add to the football's speed when bouncing off each slope type (see $15B8 for the order).
; Y speeds to randomly give the football when bouncing.
; Football misc RAM:
; $1540 - Timer for waiting to be kicked by a Puntin' Chuck after spawn.
; $1602 - Animation frame. Always 0.
; Football MAIN
    JSL GenericSprGfxRt2                      ; Draw a 16x16 sprite.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return038086
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Process interaction with Mario and other sprites.
    LDA.W SpriteMisc1540,X
    BEQ CODE_03802D
    DEC A                                     ; If not waiting to be kicked by a Chuck, update X/Y position, apply gravity, and process interaction with blocks.
    BNE +                                     ; If it was just kicked, also display a contact sprite.
    JSL CODE_01AB6F
CODE_03802D:
    JSL UpdateSpritePos
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    LDA.B SpriteXSpeed,X                      ; If the sprite hits a wall, invert its X speed.
    EOR.B #$FF
    INC A
    STA.B SpriteXSpeed,X
  + LDA.W SpriteBlockedDirs,X
    AND.B #$08                                ; If the sprite hits a ceiling, clear its Y speed.
    BEQ +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ Return038086                          ; /; Return if not hitting the ground, or still waiting to be kicked.
    LDA.W SpriteMisc1540,X
    BNE Return038086
    LDA.W SpriteOBJAttribute,X
    EOR.B #$40                                ; Horizontally flip the sprite.
    STA.W SpriteOBJAttribute,X
    JSL GetRand
    AND.B #$03
    TAY                                       ; Give random Y speed.
    LDA.W DATA_03800E,Y
    STA.B SpriteYSpeed,X
    LDY.W SpriteSlope,X
    INY
    INY
    INY                                       ; Add an X speed depending on the type of slope the football is bouncing off of.
    LDA.W DATA_038007,Y
    CLC
    ADC.B SpriteXSpeed,X
    BPL CODE_03807E
    CMP.B #$E0                                ; Maximum X speed leftwards (1).
    BCS +
    LDA.B #$E0                                ; Maximum X speed leftwards (2).
    BRA +

CODE_03807E:
    CMP.B #$20                                ; Maximum X speed rightwards (1).
    BCC +
    LDA.B #$20                                ; Maximum X speed rightwards (2).
  + STA.B SpriteXSpeed,X
Return038086:
    RTS

BigBooBoss:
; Big Boo Boss misc RAM:
; $C2   - Phase pointer.
; 0 = stopped before fading in, 1 = fading in, 2 = floating around (visible),
; 3 = hurt, 4 = fading out, 5 = floating around (invisible), 6 = dying
; $151C - Direction of horizontal acceleration. Even = left, odd = right
; $1528 - Direction of vertical acceleration. Even = down, odd = up
; $1534 - Counter for the number of hits the boss has taken.
; $1540 - Phase timer for phase 3 and 5, as well as a timer for switching palettes during fade in/out.
; $1570 - Frame counter when waiting to fade back in.
; $157C - Horizontal direction the sprite is facing. 0 = right, 1 = left.
; $15AC - Timer for turning around.
; $1602 - Animation frame.
; 0 = normal, 1/2 = turning, 3 = eyes covered
; Big Boo Boss MAIN
    JSL CODE_038398                           ; Draw GFX.
    JSL CODE_038239                           ; Handle the palette fade effect.
    LDA.W SpriteStatus,X
    BNE +                                     ; If no longer in existence, end the level.
    INC.W CutsceneID
    LDA.B #$FF                                ; Set end timer.
    STA.W EndLevelTimer
    LDA.B #!BGM_BOSSCLEAR                     ; SFX/music played after beating a Big Boo Boss.
    STA.W SPCIO2                              ; / Change music
    RTS

  + CMP.B #$08                                ; Big Boo is still alive.
    BNE +                                     ; Return if dying or game frozen.
    LDA.B SpriteLock
    BNE +
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_0380BE
    dw CODE_0380D5
    dw CODE_038119
    dw CODE_03818B
    dw CODE_0381BC
    dw CODE_038106
    dw CODE_0381D3

CODE_0380BE:
; Big Boo Boss phase pointers.
; 0 - Stopped before fading in
; 1 - Fading in
; 2 - Floating around (visible)
; 3 - Hurt
; 4 - Fading out
; 5 - Floating around (invisible)
; 6 - Dying
; Big Boo Boss phase 0 - Stopped before fading in.
    LDA.B #$03                                ; Animation frame for pausing before fading in.
    STA.W SpriteMisc1602,X
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X                    ; Return if not time to start fading in.
    CMP.B #$90
    BNE +
    LDA.B #$08                                ; Prep timer for fading in.
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + RTS

CODE_0380D5:
; Big Boo Boss phase 1 - Fading in
    LDA.W SpriteMisc1540,X                    ; Return if not time to increment the change the palette.
    BNE Return0380F9
    LDA.B #$08                                ; How quickly the palette changes when fading in.
    STA.W SpriteMisc1540,X
    INC.W BooTransparency
    LDA.W BooTransparency
    CMP.B #$02                                ; Handle incrementing the palette index.
    BNE +
    LDY.B #!SFX_MAGIC                         ; \ Play sound effect; SFX for the Big Boo Boss reappearing.
    STY.W SPCIO0                              ; /
  + CMP.B #$07                                ; Return if not done fading.
    BNE Return0380F9
    INC.B SpriteTableC2,X                     ; Increment phase pointer.
    LDA.B #$40                                ; Unused?
    STA.W SpriteMisc1540,X
Return0380F9:
    RTS


DATA_0380FA:
    db $FF,$01

DATA_0380FC:
    db $F0,$10

DATA_0380FE:
    db $0C,$F4

DATA_038100:
    db $01,$FF

DATA_038102:
    db $01,$02,$02,$01

CODE_038106:
; X accelerations for the Big Boo Boss.
; Max X speeds for the Big Boo Boss.
; Max Y speeds for the Big Boo Boss.
; Y accelerations for the Big Boo Boss.
; Animation frames for the Big Boo Boss's turning animation.
    LDA.W SpriteMisc1540,X                    ; Big Boo Boss phase 5 - Floating around (while invisible)
    BNE +                                     ; If done floating around, return to phase 0.
    STZ.B SpriteTableC2,X
    LDA.B #$40                                ; Initial frame counter value for waiting to fade back in (this is dumb, Nintendo).
    STA.W SpriteMisc1570,X
  + LDA.B #$03                                ; Animation frame for the Boo while floating around.
    STA.W SpriteMisc1602,X
    BRA +

CODE_038119:
; Big Boo Boss phase 2 - Floating around (while visible)
    STZ.W SpriteMisc1602,X                    ; Use animation frame 0.
    JSR CODE_0381E4                           ; Process interaction with thrown sprites.
  + LDA.W SpriteMisc15AC,X
    BNE CODE_038132
    JSR SubHorzPosBnk3
    TYA                                       ; If not already turning, check whether the Boo needs to turn towards Mario.
    CMP.W SpriteMisc157C,X
    BEQ CODE_03814A
    LDA.B #$1F                                ; How long it takes the Big Boo Boss to turn.
    STA.W SpriteMisc15AC,X
CODE_038132:
    CMP.B #$10
    BNE +
    PHA
    LDA.W SpriteMisc157C,X                    ; If the boss is currently in the middle of a turn, actually invert his direction.
    EOR.B #$01
    STA.W SpriteMisc157C,X
    PLA
  + LSR A
    LSR A
    LSR A                                     ; Get animation frame for the turning animation.
    TAY
    LDA.W DATA_038102,Y
    STA.W SpriteMisc1602,X
CODE_03814A:
    LDA.B EffFrame
    AND.B #$07
    BNE +
    LDA.W SpriteMisc151C,X
    AND.B #$01                                ; Every 8 frames, update X speed.
    TAY
    LDA.B SpriteXSpeed,X                      ; If at the max X speed in the current direction,
    CLC                                       ; invert the direction of horizontal acceleration.
    ADC.W DATA_0380FA,Y
    STA.B SpriteXSpeed,X
    CMP.W DATA_0380FC,Y
    BNE +
    INC.W SpriteMisc151C,X
  + LDA.B EffFrame
    AND.B #$07
    BNE +
    LDA.W SpriteMisc1528,X
    AND.B #$01                                ; Every 8 frames, update Y speed.
    TAY
    LDA.B SpriteYSpeed,X                      ; If at the max Y speed in the current direction,
    CLC                                       ; invert the direction of vertical acceleration.
    ADC.W DATA_038100,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_0380FE,Y
    BNE +
    INC.W SpriteMisc1528,X
  + JSL UpdateXPosNoGvtyW                     ; Update X position.
    JSL UpdateYPosNoGvtyW                     ; Update Y position.
    RTS

CODE_03818B:
; Big Boo Boss phase 3 - Hurt
    LDA.W SpriteMisc1540,X                    ; Branch if not done with the hurt animation.
    BNE CODE_0381AE
    INC.B SpriteTableC2,X                     ; Increment phase pointer to 4 (fade out).
    LDA.B #$08                                ; Prep timer for fading out.
    STA.W SpriteMisc1540,X
    JSL LoadSpriteTables                      ; Reload Tweaker bits...?
    INC.W SpriteMisc1534,X
    LDA.W SpriteMisc1534,X                    ; Return if the boss hasn't been killed.
    CMP.B #$03                                ; Amount of HP the Big Boo Boss has.
    BNE +
    LDA.B #$06                                ; Switch phase point to 6 (dying).
    STA.B SpriteTableC2,X
    JSL KillMostSprites                       ; Make other sprites poof in a cloud of smoke.
  + RTS

CODE_0381AE:
    AND.B #$0E                                ; Not done with the hurt animation.
    EOR.W SpriteOBJAttribute,X                ; Make the boss flash palettes.
    STA.W SpriteOBJAttribute,X
    LDA.B #$03                                ; Animation frame for the Big Boo Boss's hurt animation.
    STA.W SpriteMisc1602,X
    RTS

CODE_0381BC:
; Big Boo Boss phase 4 - Fading out
    LDA.W SpriteMisc1540,X                    ; Return if not time to increment the change the palette.
    BNE +
    LDA.B #$08                                ; How quickly the palette changes when fading in.
    STA.W SpriteMisc1540,X
    DEC.W BooTransparency                     ; Decrement the palette index, and return if not done doing so.
    BNE +
    INC.B SpriteTableC2,X                     ; Increment phase pointer to 5 (floating around, invisible).
    LDA.B #$C0                                ; How long the Big Boo floats around while invisible.
    STA.W SpriteMisc1540,X
  + RTS

CODE_0381D3:
; Big Boo Boss phase 6 - Dying
    LDA.B #$02                                ; \ Sprite status = Killed; Set sprite status as 02 (falling offscreen).
    STA.W SpriteStatus,X                      ; /
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0; Clear X speed.
    LDA.B #$D0                                ; How quickly the Big Boo Boss falls after dying.
    STA.B SpriteYSpeed,X
    LDA.B #!SFX_FALL                          ; \ Play sound effect; SFX for the Big Boo Boss dying.
    STA.W SPCIO0                              ; /
    RTS

CODE_0381E4:
    LDY.B #$0B                                ; Subroutine to handle interaction between the Big Boo Boss and thrown sprites.
CODE_0381E6:
    LDA.W SpriteStatus,Y
    CMP.B #$09
    BEQ CODE_0381F5
    CMP.B #$0A                                ; Find a sprite either in state 9 (carryable) or state A (thrown).
    BEQ CODE_0381F5
CODE_0381F1:
    DEY
    BPL CODE_0381E6
    RTS

CODE_0381F5:
    PHX
    TYX
    JSL GetSpriteClippingB
    PLX                                       ; Continue searching for a sprite if not in contact.
    JSL GetSpriteClippingA                    ; Else, continue below to hurt the boss.
    JSL CheckForContact
    BCC CODE_0381F1
    LDA.B #$03                                ; Switch to the hurt animation phase.
    STA.B SpriteTableC2,X
    LDA.B #$40                                ; How long the Big Boo Boss stays hurt for.
    STA.W SpriteMisc1540,X
    PHX
    TYX                                       ; Erase the thrown sprite.
    STZ.W SpriteStatus,X
    LDA.B SpriteXPosLow,X
    STA.B TouchBlockXPos
    LDA.W SpriteXPosHigh,X
    STA.B TouchBlockXPos+1
    LDA.B SpriteYPosLow,X
    STA.B TouchBlockYPos
    LDA.W SpriteYPosHigh,X                    ; Create shatter particles at the sprite's position.
    STA.B TouchBlockYPos+1
    PHB
    LDA.B #$02
    PHA
    PLB
    LDA.B #$FF
    JSL ShatterBlock
    PLB
    PLX
    LDA.B #!SFX_ENEMYHURT                     ; \ Play sound effect; SFX for hurting the Big Boo Boss.
    STA.W SPCIO3                              ; /
    RTS

CODE_038239:
; Routine to handle the palette fade effect for the Big Boo Boss and reappearing ghosts.
    LDY.B #$24                                ; Disable color math on sprites.
    STY.B ColorSettings
    LDA.W BooTransparency
    CMP.B #$08                                ; Get index to the current palette,
    DEC A                                     ; and enable color math if not at the full palette.
    BCS +
    LDY.B #$34                                ; Enable color math on sprites.
    STY.B ColorSettings
    INC A
  + ASL A
    ASL A
    ASL A
    ASL A
    TAX
    STZ.B _0
    LDY.W DynPaletteIndex
  - LDA.L BooBossPals,X
    STA.W DynPaletteTable+2,Y
    INY                                       ; Transfer the colors to the palette upload table in RAM.
    INX
    INC.B _0
    LDA.B _0
    CMP.B #$10
    BNE -
    LDX.W DynPaletteIndex
    LDA.B #$10
    STA.W DynPaletteTable,X                   ; Set transfer as 16 bytes starting at palette F (i.e. full palette F).
    LDA.B #$F0
    STA.W DynPaletteTable+1,X
    STZ.W DynPaletteTable+$12,X
    TXA
    CLC
    ADC.B #$12                                ; Update the palette transfer index for any additional changes.
    STA.W DynPaletteIndex
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTL


BigBooDispX:
    db $08,$08,$20,$00,$00,$00,$00,$10
    db $10,$10,$10,$20,$20,$20,$20,$30
    db $30,$30,$30,$FD,$0C,$0C,$27,$00
    db $00,$00,$00,$10,$10,$10,$10,$1F
    db $20,$20,$1F,$2E,$2E,$2C,$2C,$FB
    db $12,$12,$30,$00,$00,$00,$00,$10
    db $10,$10,$10,$1F,$20,$20,$1F,$2E
    db $2E,$2E,$2E,$F8,$11,$FF,$08,$08
    db $00,$00,$00,$00,$10,$10,$10,$10
    db $20,$20,$20,$20,$30,$30,$30,$30
BigBooDispY:
    db $12,$22,$18,$00,$10,$20,$30,$00
    db $10,$20,$30,$00,$10,$20,$30,$00
    db $10,$20,$30,$18,$16,$16,$12,$22
    db $00,$10,$20,$30,$00,$10,$20,$30
    db $00,$10,$20,$30,$00,$10,$20,$30
BigBooTiles:
    db $C0,$E0,$E8,$80,$A0,$A0,$80,$82
    db $A2,$A2,$82,$84,$A4,$C4,$E4,$86
    db $A6,$C6,$E6,$E8,$C0,$E0,$E8,$80
    db $A0,$A0,$80,$82,$A2,$A2,$82,$84
    db $A4,$C4,$E4,$86,$A6,$C6,$E6,$E8
    db $C0,$E0,$E8,$80,$A0,$A0,$80,$82
    db $A2,$A2,$82,$84,$A4,$A4,$84,$86
    db $A6,$A6,$86,$E8,$E8,$E8,$C2,$E2
    db $80,$A0,$A0,$80,$82,$A2,$A2,$82
    db $84,$A4,$C4,$E4,$86,$A6,$C6,$E6
BigBooGfxProp:
    db $00,$00,$40,$00,$00,$80,$80,$00
    db $00,$80,$80,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$40,$00
    db $00,$80,$80,$00,$00,$80,$80,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$40,$00,$00,$80,$80,$00
    db $00,$80,$80,$00,$00,$80,$80,$00
    db $00,$80,$80,$00,$00,$40,$00,$00
    db $00,$00,$80,$80,$00,$00,$80,$80
    db $00,$00,$00,$00,$00,$00,$00,$00

CODE_038398:
; X position offsets for each of the Big Boo's tiles.
; Y position offsets for each of the Big Boo's tiles.
; Sprite tilemap for the Big Boo.
; YXPPCCCT settings for each of the Big Boo's tiles.
    PHB                                       ; Wrapper; Big Boo / normal Boo GFX routine.
    PHK
    PLB
    JSR CODE_0383A0
    PLB
    RTL

CODE_0383A0:
    LDA.B SpriteNumber,X
    CMP.B #$37                                ; Branch if not the small Boo (i.e. Big Boo / Big Boo Boss).
    BNE CODE_0383C2
    LDA.B #$00                                ; Animation frame when stationary.
    LDY.B SpriteTableC2,X
    BEQ +
    LDA.B #$06                                ; Animation frame when moving.
    LDY.W SpriteMisc1558,X
    BEQ +
    TYA
    AND.B #$04
    LSR A                                     ; Animate the 'tongue out' animation if applicable (frames 2/3).
    LSR A
    ADC.B #$02
  + STA.W SpriteMisc1602,X
    JSL GenericSprGfxRt2                      ; Draw a 16x16.
    RTS

CODE_0383C2:
    JSR GetDrawInfoBnk3                       ; Big Boo / Big Boo Boss GFX routine.
    LDA.W SpriteMisc1602,X
    STA.B _6
    ASL A
    ASL A                                     ; $06 = animation frame
    STA.B _3                                  ; $03 = animation frame, x4
    ASL A                                     ; $02 = animation frame, x20
    ASL A
    ADC.B _3                                  ; $04 = horizontal direction
    STA.B _2                                  ; $05 = base YXPPCCCT
    LDA.W SpriteMisc157C,X
    STA.B _4
    LDA.W SpriteOBJAttribute,X
    STA.B _5
    LDX.B #$00
CODE_0383E0:
    PHX                                       ; Big Boo tile loop.
    LDX.B _2
    LDA.W BigBooTiles,X                       ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.B _4
    LSR A
    LDA.W BigBooGfxProp,X
    ORA.B _5
    BCS +                                     ; Store YXPPCCCT to OAM.
    EOR.B #$40
  + ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDA.W BigBooDispX,X
    BCS +
    EOR.B #$FF
    INC A
    CLC
    ADC.B #$28                                ; Store X position to OAM. If facing left, invert and offset the position.
  + CLC
    ADC.B _0
    STA.W OAMTileXPos+$100,Y
    PLX
    PHX
    LDA.B _6
    CMP.B #$03
    BCC +
    TXA
    CLC
    ADC.B #$14
    TAX                                       ; Store Y position to OAM. If using frame 3, increment the index...?
  + LDA.B _1
    CLC
    ADC.W BigBooDispY,X
    STA.W OAMTileYPos+$100,Y
    PLX
    INY
    INY
    INY
    INY                                       ; Loop for 20 tiles.
    INC.B _2
    INX
    CPX.B #$14
    BNE CODE_0383E0
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.W SpriteMisc1602,X
    CMP.B #$03
    BNE +
    LDA.W SpriteMisc1558,X
    BEQ +                                     ; If the Boo has its eyes covered and $1558 is set (normal Big Boo is peeking out),
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM; shift the hands down a few pixels.
    LDA.W OAMTileYPos+$100,Y
    CLC
    ADC.B #$05                                ; How far the Big Boo's hands move down when it's peeking from behind them.
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
  + LDA.B #$13
    LDY.B #$02                                ; Upload 20 16x16 tiles.
    JSL FinishOAMWrite
    RTS

GreyFallingPlat:
; Falling gray platform misc RAM:
; $1528 - Unused, but would make Mario move horizontally on the platform.
; $1540 - Timer set after initially landing, to prevent the platform from immediately accelerating as it falls.
; Gray falling platform MAIN
    JSR CODE_038492                           ; Draw GFX.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return038489
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    LDA.B SpriteYSpeed,X                      ; Branch if not already falling.
    BEQ CODE_038476
    LDA.W SpriteMisc1540,X                    ; Branch if Mario just landed and the platform should wait before accelerating.
    BNE +
    LDA.B SpriteYSpeed,X
    CMP.B #$40                                ; Max falling speed for the platform.
    BPL +
    CLC
    ADC.B #$02                                ; Falling acceleration for the platform.
    STA.B SpriteYSpeed,X
  + JSL UpdateYPosNoGvtyW                     ; Update Y position.
CODE_038476:
    JSL InvisBlkMainRt                        ; Make solid, and return if not in contact with Mario.
    BCC Return038489
    LDA.B SpriteYSpeed,X                      ; Return if already falling.
    BNE Return038489
    LDA.B #$03                                ; Set initial falling Y speed.
    STA.B SpriteYSpeed,X
; Set timer to wait before accelerating.
    LDA.B #$18                                ; X displacements for each tile of the falling gray platform.
    STA.W SpriteMisc1540,X
Return038489:
    RTS


FallingPlatDispX:
    db $00,$10,$20,$30

FallingPlatTiles:
    db $60,$61,$61,$62

CODE_038492:
; Tile numbers for each tile of the falling gray platform.
    JSR GetDrawInfoBnk3                       ; Falling gray platform GFX routine.
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC                                       ; Upload X position to OAM.
    ADC.W FallingPlatDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1                                  ; Upload Y position to OAM.
    STA.W OAMTileYPos+$100,Y
    LDA.W FallingPlatTiles,X                  ; Upload tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.B #$03
    ORA.B SpriteProperties                    ; Uplaod YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$03                                ; Upload 4 16x16 tiles.
    JSL FinishOAMWrite
    RTS


BlurpMaxSpeedY:
    db $04,$FC

BlurpSpeedX:
    db $08,$F8

BlurpAccelY:
    db $01,$FF

Blurp:
; Max Y speeds for the Blurp and Swooper.
; X speeds for the Blurp.
; Y accelerations for the Blurp and Swooper.
; Blurp misc RAM:
; $C2   - Direciton of vertical acceleration. Even = down, odd = up.
; $157C - Horizontal direction the sprite is facing.
; Blurp MAIN
    JSL GenericSprGfxRt2                      ; Draw a 16x16 sprite.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W EffFrame
    LSR A
    LSR A
    LSR A
    CLC
    ADC.W CurSpriteProcess                    ; Animate the Blurp's swimming motion.
    LSR A
    LDA.B #$A2                                ; Tile A to use for the Blurp.
    BCC +
    LDA.B #$EC                                ; Tile B to use for the Blurp.
  + STA.W OAMTileNo+$100,Y
    LDA.W SpriteStatus,X
    CMP.B #$08
    BEQ +
CODE_0384EC:
    LDA.W OAMTileAttr+$100,Y
    ORA.B #$80                                ; If dead, flip the sprite upside down and return.
    STA.W OAMTileAttr+$100,Y
    RTS

; Not dead.
  + LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return03852A
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    LDA.B EffFrame
    AND.B #$03
    BNE +
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY                                       ; Every 4 frames, update Y speed.
    LDA.B SpriteYSpeed,X                      ; If at the max speed in a particular direction, invert its direction of movement.
    CLC
    ADC.W BlurpAccelY,Y
    STA.B SpriteYSpeed,X
    CMP.W BlurpMaxSpeedY,Y
    BNE +
    INC.B SpriteTableC2,X
  + LDY.W SpriteMisc157C,X
    LDA.W BlurpSpeedX,Y                       ; Store X speed in the direction the Blurp is facing.
    STA.B SpriteXSpeed,X
    JSL UpdateXPosNoGvtyW                     ; Update X position.
    JSL UpdateYPosNoGvtyW                     ; Update Y position.
    JSL SprSpr_MarioSprRts                    ; Process interaction with Mario and other sprites.
Return03852A:
    RTS


PorcuPuffAccel:
    db $01,$FF

PorcuPuffMaxSpeed:
    db $10,$F0

PorcuPuffer:
; X accelerations for the Porcu-Puffer.
; Max X speeds for the Porcu-Puffer.
; Porcupuffer misc RAM:
; $157C - Horizontal direction the sprite is facing.
; Porcu-Puffer MAIN
    JSR CODE_0385A3                           ; Draw graphics.
    LDA.B SpriteLock
    BNE Return038586
    LDA.W SpriteStatus,X                      ; Return if game frozen or sprite dead.
    CMP.B #$08
    BNE Return038586
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Process interaction with Mario and sprites.
    JSR SubHorzPosBnk3
    TYA
    STA.W SpriteMisc157C,X
    LDA.B EffFrame
    AND.B #$03
    BNE +                                     ; Apply X acceleration if not at max.
    LDA.B SpriteXSpeed,X                      ; \ Branch if at max speed
    CMP.W PorcuPuffMaxSpeed,Y                 ; |
    BEQ +                                     ; /
    CLC                                       ; \ Otherwise, accelerate
    ADC.W PorcuPuffAccel,Y                    ; |
    STA.B SpriteXSpeed,X                      ; /
  + LDA.B SpriteXSpeed,X
    PHA
    LDA.W Layer1DXPos
    ASL A
    ASL A                                     ; Move with the screen.
    ASL A
    CLC
    ADC.B SpriteXSpeed,X
    STA.B SpriteXSpeed,X
    JSL UpdateXPosNoGvtyW                     ; Update X position.
    PLA
    STA.B SpriteXSpeed,X
    JSL CODE_019138                           ; Process interaction with blocks.
    LDY.B #$04                                ; Y speed to give the Porcu-Puffer when out of water (falling).
    LDA.W SpriteInLiquid,X
    BEQ +
    LDY.B #$FC                                ; Y speed to give the Porcu-Puffer when in water (rising).
  + STY.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW                     ; Update Y position.
Return038586:
    RTS


PocruPufferDispX:
    db $F8,$08,$F8,$08,$08,$F8,$08,$F8
PocruPufferDispY:
    db $F8,$F8,$08,$08

PocruPufferTiles:
    db $86,$C0,$A6,$C2,$86,$C0,$A6,$8A
PocruPufferGfxProp:
    db $0D,$0D,$0D,$0D,$4D,$4D,$4D,$4D

CODE_0385A3:
; X displacements for each of the Porcu-Puffer's tiles.
; Y displacements for each of the Porcu-Puffer's tiles.
; Tile numbers for the Porcu-Puffer.
; YXPPCCCT for the Porcu-Puffer.
    JSR GetDrawInfoBnk3                       ; Porcu-Puffer GFX routine.
    LDA.B EffFrame
    AND.B #$04                                ; $03 = Animation index
    STA.B _3
    LDA.W SpriteMisc157C,X                    ; $02 = X flip
    STA.B _2
    PHX
    LDX.B #$03
CODE_0385B4:
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W PocruPufferDispY,X
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.B _2
    BNE +
    TXA
    ORA.B #$04
    TAX
  + LDA.B _0                                  ; Store X position to OAM.
    CLC
    ADC.W PocruPufferDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.W PocruPufferGfxProp,X
    ORA.B SpriteProperties                    ; Store YXPPCCCCT.
    STA.W OAMTileAttr+$100,Y
    PLA
    PHA
    ORA.B _3                                  ; Store tile number.
    TAX
    LDA.W PocruPufferTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL CODE_0385B4
    PLX
    LDY.B #$02
    LDA.B #$03                                ; Upload 4 16x16 tiles.
    JSL FinishOAMWrite
    RTS


FlyingBlockSpeedY:
    db $08,$F8

FlyingTurnBlocks:
; Y speeds for the flying turnblock platform.
; Flying Gray Turnblocks misc RAM:
; $151C - Value indicating whether the platform flies up first (00) or down first (10)
; $1528 - Number of pixels moved horizontally in the frame.
; $1534 - Extra timer for changing the direction of vertical movement. $1602 is only decremented every odd even tick of this address.
; $157C - Direction of vertical movement. Even = down, odd = up.
; $1602 - Timer for changing the direction of vertical movement.
; Flying Gray Turnblocks MAIN
    JSR CODE_0386A8                           ; Draw GFX.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return038675
    LDA.W BGFastScrollActive
    BEQ CODE_038629                           ; Handle Y speed if the platform has been started.
    LDA.W SpriteMisc1534,X
    INC.W SpriteMisc1534,X
    AND.B #$01
    BNE +
    DEC.W SpriteMisc1602,X                    ; If time to change direction, do so.
    LDA.W SpriteMisc1602,X
    CMP.B #$FF
    BNE +
    LDA.B #$FF
    STA.W SpriteMisc1602,X
    INC.W SpriteMisc157C,X
  + LDA.W SpriteMisc157C,X
    AND.B #$01
    TAY                                       ; Set Y speed.
    LDA.W FlyingBlockSpeedY,Y
    STA.B SpriteYSpeed,X
CODE_038629:
    LDA.B SpriteYSpeed,X
    PHA
    LDY.W SpriteMisc151C,X
    BNE +
    EOR.B #$FF                                ; Update Y position.
    INC A                                     ; If the platform was spawned at an odd X position, invert its direction of movement.
    STA.B SpriteYSpeed,X
  + JSL UpdateYPosNoGvtyW
    PLA
    STA.B SpriteYSpeed,X
    LDA.W BGFastScrollActive                  ; Store X speed.
    STA.B SpriteXSpeed,X
    JSL UpdateXPosNoGvtyW                     ; Update X position.
    STA.W SpriteMisc1528,X
    JSL InvisBlkMainRt                        ; Make the platform solid, and return if Mario isn't on the platform.
    BCC Return038675
    LDA.W BGFastScrollActive                  ; Return if the platform hasn't already been started.
    BNE Return038675
    LDA.B #$08                                ; X speed the flying gray platform flies at.
    STA.W BGFastScrollActive
    LDA.B #$7F                                ; Set initial timer until the platform turns around.
    STA.W SpriteMisc1602,X
    LDY.B #$09
CODE_038660:
    CPY.W CurSpriteProcess
    BEQ CODE_03866C
    LDA.W SpriteNumber,Y
    CMP.B #$C1
    BEQ CODE_038670                           ; Find a second platform and start it up too.
CODE_03866C:
    DEY                                       ; (note that any more platforms will immediately reverse direction).
    BPL CODE_038660
    INY                                       ; Note: this line should probably be changed to an RTS.
CODE_038670:
    LDA.B #$7F
    STA.W SpriteMisc1602,Y
Return038675:
    RTS


ForestPlatDispX:
    db $00,$10,$20,$F2,$2E,$00,$10,$20
    db $FA,$2E

ForestPlatDispY:
    db $00,$00,$00,$F6,$F6,$00,$00,$00
    db $FE,$FE

ForestPlatTiles:
    db $40,$40,$40,$C6,$C6,$40,$40,$40
    db $5D,$5D

ForestPlatGfxProp:
    db $32,$32,$32,$72,$32,$32,$32,$32
    db $72,$32

ForestPlatTileSize:
    db $02,$02,$02,$02,$02,$02,$02,$02
    db $00,$00

CODE_0386A8:
; X offsets for the Flying Gray Turnblocks.
; Y offsets for the Flying Gray Turnblocks.
; Tile numbers for the Flying Gray Turnblocks.
; YXPPCCCT for the Flying Gray Turnblocks.
; Tile sizes for the Flying Gray Turnblocks.
    JSR GetDrawInfoBnk3                       ; Flying Gray Turnblocks GFX routine
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B EffFrame
    LSR A
    AND.B #$04
    BEQ +                                     ; $02 = Animation index to the above tables (for animating the wings).
    INC A
  + STA.B _2
    PHX
    LDX.B #$04
  - STX.B _6
    TXA
    CLC
    ADC.B _2
    TAX
    LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W ForestPlatDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W ForestPlatDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W ForestPlatTiles,X                   ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.W ForestPlatGfxProp,X                 ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Store size to OAM.
    TAY
    LDA.W ForestPlatTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    LDX.B _6
    DEX
    BPL -
    PLX
    LDY.B #$FF
    LDA.B #$04                                ; Upload 5 manually-sized tiles.
    JSL FinishOAMWrite
    RTS

GrayLavaPlatform:
; Gray lava platform misc RAM:
; $1528 - Always 0, but would move Mario horizontally when standing on the platform if non-zero.
; $1540 - Timer for sinking the platform.
; Gray lava platform MAIN
    JSR CODE_03873A                           ; Draw GFX.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return038733
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    LDA.W SpriteMisc1540,X
    DEC A                                     ; Branch if not done sinking.
    BNE +
    LDY.W SpriteLoadIndex,X                   ; \
    LDA.B #$00                                ; | Allow sprite to be reloaded by level loading routine; Erase the sprite.
    STA.W SpriteLoadStatus,Y                  ; /
    STZ.W SpriteStatus,X
    RTS

; Not done sinking (or hasn't started yet).
  + JSL UpdateYPosNoGvtyW                     ; Update Y position.
    JSL InvisBlkMainRt                        ; Make the platform solid and return if Mario isn't on it.
    BCC Return038733
    LDA.W SpriteMisc1540,X                    ; Return if the platform has already started sinking.
    BNE Return038733
    LDA.B #$06                                ; Y speed the lava platform sinks with.
    STA.B SpriteYSpeed,X
    LDA.B #$40                                ; How long the lava platform takes to sink.
    STA.W SpriteMisc1540,X
Return038733:
    RTS


LavaPlatTiles:
    db $85,$86,$85

DATA_038737:
    db $43,$03,$03

CODE_03873A:
; Tile numbers for the gray lava platform.
; YXPPCCCT for the gray lava platform.
    JSR GetDrawInfoBnk3                       ; Gray lava platform GFX routine
    PHX
    LDX.B #$02
  - LDA.B _0
    STA.W OAMTileXPos+$100,Y
    CLC                                       ; Store X position to OAM.
    ADC.B #$10
    STA.B _0
    LDA.B _1                                  ; Store Y position to OAM.
    STA.W OAMTileYPos+$100,Y
    LDA.W LavaPlatTiles,X                     ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_038737,X
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$02                                ; Upload 3 16x16 tiles.
    JSL FinishOAMWrite
    RTS


MegaMoleSpeed:
    db $10,$F0

MegaMole:
; Mega Mole misc RAM:
; $151C - Horizontal direction the sprite is facing.
; $1540 - Timer set when the mole walks of a ledge, so that it can actually clear the ledge before it starts falling (i.e. don't clip through the corner).
; $154C - Timer set while Mario is standing on the mole, to prevent him from being hurt by it.
; $157C - Horizontal direction the sprite is moving.
; $15AC - Timer for turning around.
; Mega Mole MAIN
    JSR MegaMoleGfxRt                         ; Graphics routine; Draw GFX.
    LDA.W SpriteStatus,X                      ; \
    CMP.B #$08                                ; | If status != 8, return; Return if dead.
    BNE Return038733                          ; /
    JSR SubOffscreen3Bnk3                     ; Handle off screen situation; Process offscreen from -$50 to +$60.
    LDY.W SpriteMisc157C,X                    ; \ Set x speed based on direction
    LDA.W MegaMoleSpeed,Y                     ; |; Store X speed.
    STA.B SpriteXSpeed,X                      ; /
    LDA.B SpriteLock                          ; \ If sprites locked, return; Return if game frozen.
    BNE Return038733                          ; /
    LDA.W SpriteBlockedDirs,X
    AND.B #$04
    PHA
    JSL UpdateSpritePos                       ; Update position based on speed values; Update X/Y position, apply gravity, and process interaction with blocks.
    JSL SprSprInteract                        ; Interact with other sprites; Process interaction with other sprites.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ MegaMoleInAir                         ; /; If the Mega Mole is on the ground, clear Y speed and branch.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    PLA
    BRA MegaMoleOnGround

MegaMoleInAir:
    PLA                                       ; Mole is in the air.
    BEQ +                                     ; If the mole was previously on the ground, set the timer to wait before actually falling.
    LDA.B #$0A
    STA.W SpriteMisc1540,X
  + LDA.W SpriteMisc1540,X
    BEQ MegaMoleOnGround                      ; If the mole has just walked of a ledge, clear Y speed for a bit before actually falling.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
MegaMoleOnGround:
    LDY.W SpriteMisc15AC,X                    ; \; Mole is on the ground.
    LDA.W SpriteBlockedDirs,X                 ; | If Mega Mole is in contact with an object...
    AND.B #$03                                ; |
    BEQ CODE_0387CD                           ; |
    CPY.B #$00                                ; |    ... and timer hasn't been set (time until flip == 0)...
    BNE +                                     ; |; If the mole just hit a wall, turn it around (if it's not already in the process of turning).
    LDA.B #$10                                ; |    ... set time until flip
    STA.W SpriteMisc15AC,X                    ; /
  + LDA.W SpriteMisc157C,X                    ; \ Flip the temp direction status
    EOR.B #$01                                ; |
    STA.W SpriteMisc157C,X                    ; /
CODE_0387CD:
    CPY.B #$00                                ; \ If time until flip == 0...
    BNE +                                     ; |; Only actually update the direction the mole is facing when the it finishes turning.
    LDA.W SpriteMisc157C,X                    ; |    ...update the direction status used by the gfx routine
    STA.W SpriteMisc151C,X                    ; /
  + JSL MarioSprInteract                      ; Check for mario/Mega Mole contact; Process interaction with Mario, and return if not in contact.
    BCC Return03882A                          ; (Carry set = contact)
    JSR SubVertPosBnk3
    LDA.B _E                                  ; Branch if less than 18 pixels above the mole, to hurt Mario.
    CMP.B #$D8
    BPL MegaMoleContact
    LDA.B PlayerYSpeed+1                      ; Return if moving upwards.
    BMI Return03882A
    LDA.B #$01                                ; \ Set "on sprite" flag; Set flag for being on a sprite.
    STA.W StandOnSolidSprite                  ; /
    LDA.B #$06                                ; \ Set riding Mega Mole; Set timer to prevent Mario from being hurt by the mole.
    STA.W SpriteMisc154C,X                    ; /
    STZ.B PlayerYSpeed+1                      ; Y speed = 0; Clear Mario's Y speed.
    LDA.B #$D6                                ; \
    LDY.W PlayerRidingYoshi                   ; | Mario's y position += C6 or D6 depending if on yoshi
    BEQ +                                     ; |
    LDA.B #$C6                                ; |
  + CLC                                       ; |; Offset Mario on top of the sprite.
    ADC.B SpriteYPosLow,X                     ; |
    STA.B PlayerYPosNext                      ; |
    LDA.W SpriteYPosHigh,X                    ; |
    ADC.B #$FF                                ; |
    STA.B PlayerYPosNext+1                    ; /
    LDY.B #$00                                ; \
    LDA.W SpriteXMovement                     ; | $1491 == 01 or FF, depending on direction
    BPL +                                     ; | Set mario's new x position
    DEY                                       ; |
  + CLC                                       ; |; Move Mario horizontally with the sprite.
    ADC.B PlayerXPosNext                      ; |
    STA.B PlayerXPosNext                      ; |
    TYA                                       ; |
    ADC.B PlayerXPosNext+1                    ; |
    STA.B PlayerXPosNext+1                    ;  /
    RTS

MegaMoleContact:
    LDA.W SpriteMisc154C,X                    ; \ If riding Mega Mole...
    ORA.W SpriteOnYoshiTongue,X               ; |   ...or Mega Mole being eaten...; Hurt Mario, unless Mario is on top of it or it's on Yoshi's tongue.
    BNE Return03882A                          ; /   ...return
    JSL HurtMario                             ; Hurt mario
Return03882A:
    RTS


MegaMoleTileDispX:
    db $00,$10,$00,$10,$10,$00,$10,$00
MegaMoleTileDispY:
    db $F0,$F0,$00,$00

MegaMoleTiles:
    db $C6,$C8,$E6,$E8,$CA,$CC,$EA,$EC

MegaMoleGfxRt:
; X offsets for each tile of the Mega Mole, indexed by its direction.
; Y offsets for each tile of the Mega Mole.
; Tile numbers for each tile of the Mega Mole's walking animation.
    JSR GetDrawInfoBnk3                       ; Mega Mole GFX routine
    LDA.W SpriteMisc151C,X                    ; \ $02 = direction; $02 = horizontal direciton
    STA.B _2                                  ; /
    LDA.B EffFrame                            ; \
    LSR A                                     ; |
    LSR A                                     ; |
    NOP                                       ; |
    CLC                                       ; |; $03 = animation frame (x4)
    ADC.W CurSpriteProcess                    ; |
    AND.B #$01                                ; |
    ASL A                                     ; |
    ASL A                                     ; |
    STA.B _3                                  ; | $03 = index to frame start (0 or 4)
    PHX                                       ; /
    LDX.B #$03                                ; Run loop 4 times, cuz 4 tiles per frame
MegaMoleGfxLoopSt:
    PHX                                       ; Push, current tile
    LDA.B _2                                  ; \
    BNE +                                     ; | If facing right, index to frame end += 4
    INX                                       ; |
    INX                                       ; |
    INX                                       ; |
    INX                                       ; /; Store X position to OAM.
  + LDA.B _0                                  ; \ Tile x position = sprite x location ($00) + tile displacement
    CLC                                       ; |
    ADC.W MegaMoleTileDispX,X                 ; |
    STA.W OAMTileXPos+$100,Y                  ; /
    PLX                                       ; \ Pull, X = index to frame end
    LDA.B _1                                  ; |
    CLC                                       ; | Tile y position = sprite y location ($01) + tile displacement; Store Y position to OAM.
    ADC.W MegaMoleTileDispY,X                 ; |
    STA.W OAMTileYPos+$100,Y                  ; /
    PHX                                       ; \ Set current tile
    TXA                                       ; | X = index of frame start + current tile
    CLC                                       ; |
    ADC.B _3                                  ; |; Store tile number to OAM.
    TAX                                       ; |
    LDA.W MegaMoleTiles,X                     ; |
    STA.W OAMTileNo+$100,Y                    ; /
    LDA.B #$01                                ; Tile properties xyppccct, format
    LDX.B _2                                  ; \ If direction == 0...
    BNE +                                     ; |
    ORA.B #$40                                ; /    ...flip tile; Store YXPPCCCT to OAM.
  + ORA.B SpriteProperties                    ; Add in tile priority of level
    STA.W OAMTileAttr+$100,Y                  ; Store tile properties
    PLX                                       ; \ Pull, current tile
    INY                                       ; | Increase index to sprite tile map ($300)...
    INY                                       ; |    ...we wrote 4 bytes
    INY                                       ; |    ...so increment 4 times; Loop for all of the tiles.
    INY                                       ; |
    DEX                                       ; | Go to next tile of frame and loop
    BPL MegaMoleGfxLoopSt                     ; /
    PLX                                       ; Pull, X = sprite index
    LDY.B #$02                                ; \ Will write 02 to $0460 (all 16x16 tiles)
    LDA.B #$03                                ; | A = number of tiles drawn - 1; Upload 4 16x16 tiles.
    JSL FinishOAMWrite                        ; / Don't draw if offscreen
    RTS


BatTiles:
    db $AE,$C0,$E8

Swooper:
; Swooper misc RAM:
; $C2   - Phase pointer.
; 0 = waiting to swoop, 1 = swooping, 2 = flying straight
; $151C - Direction of vertical acceleration in phase 2. Even = down, odd = up.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame.
; 0 = waiting on the ceiling, 1/2 = flying
; Swooper MAIN
    JSL GenericSprGfxRt2                      ; Draw a 16x16 sprite.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    LDA.W SpriteMisc1602,X
    TAX                                       ; Change the tile number stored to OAM.
    LDA.W BatTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    LDA.W SpriteStatus,X
    CMP.B #$08                                ; If dead, flip the sprite upside down and return.
    BEQ +
    JMP CODE_0384EC

; Not dead.
  + LDA.B SpriteLock                          ; Return if game frozen.
    BNE +
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Process interaction with Mario and other sprties.
    JSL UpdateXPosNoGvtyW                     ; Update X position.
    JSL UpdateYPosNoGvtyW                     ; Update Y position.
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_0388E4
    dw CODE_038905
    dw CODE_038936

; Swooper phase pointers.
; 0 - Waiting to swoop
; 1 - Swooping
  + RTS                                       ; 2 - Flying straight


DATA_0388E0:
    db $10,$F0

DATA_0388E2:
    db $01,$FF

CODE_0388E4:
; Max X speeds for the Swooper.
; X accelerations for the Swooper.
; Swooper phase 0 - Waiting to swoop
    LDA.W SpriteOffscreenX,X                  ; Return if horizontally offscreen.
    BNE +
    JSR SubHorzPosBnk3
    LDA.B _F
    CLC                                       ; Return if Mario isn't within 5 tiles of the sprite.
    ADC.B #$50
    CMP.B #$A0
    BCS +
    INC.B SpriteTableC2,X                     ; Increment phase pointer.
    TYA                                       ; Fly towards Mario.
    STA.W SpriteMisc157C,X
    LDA.B #$20                                ; Initial Y speed when the Swooper swoops.
    STA.B SpriteYSpeed,X
    LDA.B #!SFX_SWOOPER                       ; \ Play sound effect; SFX for the swooper swooping.
    STA.W SPCIO3                              ; /
  + RTS

CODE_038905:
    LDA.B TrueFrame                           ; Swooper phase 1 - Swooping
    AND.B #$03
    BNE CODE_038915
    LDA.B SpriteYSpeed,X                      ; Every 4 frames, decrease Y speed by 1.
    BEQ CODE_038915                           ; If the sprite no longer has any Y speed, increment phase pointer.
    DEC.B SpriteYSpeed,X
    BNE CODE_038915
    INC.B SpriteTableC2,X
CODE_038915:
    LDA.B TrueFrame
    AND.B #$03
    BNE +
    LDY.W SpriteMisc157C,X
    LDA.B SpriteXSpeed,X                      ; Ever 4 frames, accelerate horizontally if not moving at the max speed yet.
    CMP.W DATA_0388E0,Y
    BEQ +
    CLC
    ADC.W DATA_0388E2,Y
    STA.B SpriteXSpeed,X
  + LDA.B EffFrame
    AND.B #$04
    LSR A                                     ; Animate the Swooper's flight.
    LSR A
    INC A
    STA.W SpriteMisc1602,X
    RTS

CODE_038936:
    LDA.B TrueFrame                           ; Swooper phase 2 - Flying straight
    AND.B #$01
    BNE +
    LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY                                       ; Handle the Swooper's "flapping" movement every other frame.
    LDA.B SpriteYSpeed,X                      ; If at the max Y speed in a particular direction, invert its direction of vertical acceleration.
    CLC
    ADC.W BlurpAccelY,Y
    STA.B SpriteYSpeed,X
    CMP.W BlurpMaxSpeedY,Y
    BNE +
    INC.W SpriteMisc151C,X
  + BRA CODE_038915                           ; Handle animation and X speed.


DATA_038954:
    db $20,$E0

DATA_038956:
    db $02,$FE

SlidingKoopa:
; Max X speeds down slopes for the sliding blue Koopa.
; X accelerations down slopes for the sliding blue Koopa.
; Sliding Blue Koopa misc RAM:
; $1540 - Timer set briefly on spawn, to prevent the Koopa from immediately falling.
; $1558 - Timer after the Koopa stops to wait before turning into a normal Koopa.
; $157C - Horizontal direction the sprite is facing.
    LDA.B #$00                                ; Sliding blue Koopa MAIN
    LDY.B SpriteXSpeed,X
    BEQ CODE_038964
    BPL +                                     ; Update direction based on X speed.
    INC A
  + STA.W SpriteMisc157C,X
CODE_038964:
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc1558,X
    CMP.B #$01
    BNE +
    LDA.W SpriteMisc157C,X                    ; If done sliding, turn into a normal blue Koopa.
    PHA
    LDA.B #$02                                ; Sprite the sliding blue Koopa turns into when it touches the ground.
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    PLA
    STA.W SpriteMisc157C,X
    SEC
  + LDA.B #$86                                ; Tile to use for the sliding blue Koopa while sliding.
    BCC +
    LDA.B #$E0                                ; Tile to use for the sliding blue Koopa when it's about to turn into a normal Koopa.
  + STA.W OAMTileNo+$100,Y
    LDA.W SpriteStatus,X
    CMP.B #$08                                ; Return if dead.
    BNE Return0389FE
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Process interaction with Mario and other sprites.
    LDA.B SpriteLock
    ORA.W SpriteMisc1540,X                    ; Return if game frozen or the Koopa has stopped.
    ORA.W SpriteMisc1558,X
    BNE Return0389FE
    JSL UpdateSpritePos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Return if not on the ground.
    BEQ Return0389FE                          ; /
    JSR CODE_0389FF                           ; Handle spawning the friction smoke.
    LDY.B #$00
    LDA.B SpriteXSpeed,X
    BEQ CODE_0389CC
    BPL +
    EOR.B #$FF
    INC A
  + STA.B _0                                  ; Calculate Y speed for the blue Koopa based on the type of slope it's on and its current X speed.
    LDA.W SpriteSlope,X                       ; Normally, it always tries to move the sprite in a 45-degree angle downwards, unless sliding up a slope.
    BEQ CODE_0389CC
    LDY.B _0
    EOR.B SpriteXSpeed,X
    BPL CODE_0389CC
    LDY.B #$D0                                ; Y speed to give the blue Koopa when sliding up a slope.
CODE_0389CC:
    STY.B SpriteYSpeed,X
    LDA.B TrueFrame
    AND.B #$01                                ; Return every odd frame.
    BNE Return0389FE
    LDA.W SpriteSlope,X                       ; Branch if not on flat ground.
    BNE CODE_0389EC
    LDA.B SpriteXSpeed,X
    BNE +                                     ; If the Koopa has come to a stop, set its timer for returning to normal.
    LDA.B #$20
    STA.W SpriteMisc1558,X
    RTS

  + BPL +                                     ; Not stationary.
    INC.B SpriteXSpeed,X
    INC.B SpriteXSpeed,X                      ; Apply friction.
  + DEC.B SpriteXSpeed,X
    RTS

CODE_0389EC:
    ASL A                                     ; Not on flat ground; apply X acceleration.
    ROL A
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X                      ; Accelerate, if not already at the max X speed.
    CMP.W DATA_038954,Y
    BEQ Return0389FE
    CLC
    ADC.W DATA_038956,Y
    STA.B SpriteXSpeed,X
Return0389FE:
    RTS

CODE_0389FF:
    LDA.B SpriteXSpeed,X                      ; Subroutine for the sliding blue Koopa to generate friction smoke.
    BEQ Return038A20
    LDA.B TrueFrame
    AND.B #$03                                ; Return if:
    BNE Return038A20                          ; Not moving
    LDA.B #$04                                ; Not a frame to generate smoke
    STA.B _0                                  ; Offscreen
    LDA.B #$0A
    STA.B _1
    JSR IsSprOffScreenBnk3
    BNE Return038A20
    LDY.B #$03
CODE_038A18:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_038A21                           ; Find an empty smoke sprite slot and return if none found.
    DEY
    BPL CODE_038A18
Return038A20:
    RTS

CODE_038A21:
    LDA.B #$03                                ; Smoke sprite to spawn (friction smoke).
    STA.W SmokeSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B _0
    STA.W SmokeSpriteXPos,Y                   ; Spawn a the Koopa's position.
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B _1
    STA.W SmokeSpriteYPos,Y
    LDA.B #$13                                ; Set initial timer for the smoke.
    STA.W SmokeSpriteTimer,Y
    RTS

BowserStatue:
; Bowser statue misc RAM:
; $C2   - Statue type. 0 = normal, 1/3 = fire, 2 = jumping
; $1540 - Timer for the jumping statue, to wait before jumping.
; $1602 - Animation frame.
; 0 = normal, 1 = jumping
; Bowser statue MAIN
    JSR BowserStatueGfx                       ; Draw GFX.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE +
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_038A57
    dw CODE_038A54
    dw CODE_038A69
    dw CODE_038A54

CODE_038A54:
; Bowser statue pointers.
; 0 - Normal
; 1 - Fire-breathing
; 2 - Jumping
; 3 - Fire-breathing
; Bowser Statue type 1/3 - Fire
    JSR CODE_038ACB                           ; Spawn fireballs.
CODE_038A57:
; Bowser Statue type 0 - Normal
    JSL InvisBlkMainRt                        ; Make solid.
    JSL UpdateSpritePos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; If touching the ground, clear the statue's Y speed.
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + RTS

CODE_038A69:
    ASL.W SpriteTweakerD,X                    ; Bowser Statue type 2 - Jumping
    LSR.W SpriteTweakerD,X                    ; Process interaction with Mario, and hurt him if in contact.
    JSL MarioSprInteract
    STZ.W SpriteMisc1602,X
    LDA.B SpriteYSpeed,X
    CMP.B #$10                                ; Animate the statue's jump.
    BPL +
    INC.W SpriteMisc1602,X
  + JSL UpdateSpritePos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    LDA.B SpriteXSpeed,X
    EOR.B #$FF                                ; If hitting the side of a block, turn the statue around.
    INC A
    STA.B SpriteXSpeed,X
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Return if not hitting the ground.
    BEQ Return038AC6                          ; /
    LDA.B #$10                                ; Y speed for the Bowser statue while on the ground.
    STA.B SpriteYSpeed,X
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0; Clear X speed.
    LDA.W SpriteMisc1540,X                    ; Branch if the statue's "waiting to jump" timer hasn't been set yet.
    BEQ CODE_038AC1
    DEC A                                     ; Return if not time to jump.
    BNE Return038AC6
    LDA.B #$C0                                ; Y speed to give the Bowser Statue when jumping.
    STA.B SpriteYSpeed,X
    JSR SubHorzPosBnk3
    TYA
    STA.W SpriteMisc157C,X                    ; Jump towards Mario.
    LDA.W BwsrStatueSpeed,Y
    STA.B SpriteXSpeed,X
    RTS


BwsrStatueSpeed:
    db $10,$F0

CODE_038AC1:
; X speeds for the jumping Bowser statue.
; Need to set the Bowser Statue's "waiting to jump" timer.
    LDA.B #$30                                ; How long the statue waits on the ground before jumping.
    STA.W SpriteMisc1540,X
Return038AC6:
    RTS


BwserFireDispXLo:
    db $10,$F0

BwserFireDispXHi:
    db $00,$FF

CODE_038ACB:
; X offsets (lo) for fireballs spawned by the Bowser statue.
; X offsets (hi) for fireballs spawned by the Bowser statue.
    TXA                                       ; Routine to generate fireballs for the fire Bowser statue.
    ASL A
    ASL A                                     ; Return if not a frame to shoot a fireball.
    ADC.B TrueFrame
    AND.B #$7F
    BNE +
    JSL FindFreeSprSlot                       ; \ Return if no free slots; Return if a sprite slot can't be found.
    BMI +                                     ; /
    LDA.B #!SFX_FIRESPIT                      ; \ Play sound effect; SFX for the Bowser statue shooting a fireball.
    STA.W SPCIO3                              ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$B3                                ; \ Sprite = Bowser Statue Fireball; Sprite spawned by the Bowser statue (fireball).
    STA.W SpriteNumber,Y                      ; /
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    PHX
    LDA.W SpriteMisc157C,X
    TAX                                       ; Spawn at the statue's X position, offset to the side.
    LDA.B _0
    CLC
    ADC.W BwserFireDispXLo,X
    STA.W SpriteXPosLow,Y
    LDA.B _1
    ADC.W BwserFireDispXHi,X
    STA.W SpriteXPosHigh,Y
    TYX                                       ; \ Reset sprite tables
    JSL InitSpriteTables                      ; |
    PLX                                       ; /
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$02
    STA.W SpriteYPosLow,Y                     ; Spawn tat the statue's Y position.
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,Y
    LDA.W SpriteMisc157C,X                    ; Face the fireball the same direction as the statue.
    STA.W SpriteMisc157C,Y
  + RTS


BwsrStatueDispX:
    db $08,$F8,$00,$00,$08,$00

BwsrStatueDispY:
    db $10,$F8,$00

BwsrStatueTiles:
    db $56,$30,$41,$56,$30,$35

BwsrStatueTileSize:
    db $00,$02,$02

BwsrStatueGfxProp:
    db $00,$00,$00,$40,$40,$40

BowserStatueGfx:
; X offsets for each tile in the Bowser statue.
; Right
; Left
; Y offsets for each tile in the Bowser statue.
; Tile numbers for each tile in the Bowser statue.
; Normal (last tile unused)
; Jumping
; Tile size for each tile in the Bowser statue.
; YXPPCCCT for each tile in the Bowser statue.
; Right
; Left
    JSR GetDrawInfoBnk3                       ; Bowser Statue GFX routine
    LDA.W SpriteMisc1602,X                    ; $04 = animation frame
    STA.B _4
    EOR.B #$01
    DEC A                                     ; $03 = value indicating how many tiles to draw. 00 (2 tiles) for normal frame, FF (3 tiles) for jumping.
    STA.B _3
    LDA.W SpriteOBJAttribute,X                ; $05 = base YXPPCCCT
    STA.B _5
    LDA.W SpriteMisc157C,X                    ; $02 = horizontal direction
    STA.B _2
    PHX
    LDX.B #$02
CODE_038B57:
    PHX                                       ; Tile loop.
    LDA.B _2
    BNE +
    INX
    INX
    INX                                       ; Store X position to OAM.
  + LDA.B _0
    CLC
    ADC.W BwsrStatueDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.W BwsrStatueGfxProp,X
    ORA.B _5                                  ; Store YXPPCCCT to OAM.
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLX
    LDA.B _1
    CLC                                       ; Store Y positin to OAM.
    ADC.W BwsrStatueDispY,X
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.B _4
    BEQ +
    INX
    INX                                       ; Store tile number to OAM.
    INX
  + LDA.W BwsrStatueTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    PHY
    TYA
    LSR A
    LSR A                                     ; Store tile size to OAM.
    TAY
    LDA.W BwsrStatueTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    DEX
    CPX.B _3
    BNE CODE_038B57
    PLX
    LDY.B #$FF
    LDA.B #$02                                ; Upload 3 manually-sized tiles.
    JSL FinishOAMWrite
    RTS


DATA_038BAA:
    db $20,$20,$20,$20,$20,$20,$20,$20
    db $20,$20,$20,$20,$20,$20,$20,$20
    db $20,$1F,$1E,$1D,$1C,$1B,$1A,$19
    db $18,$17,$16,$15,$14,$13,$12,$11
    db $10,$0F,$0E,$0D,$0C,$0B,$0A,$09
    db $08,$07,$06,$05,$04,$03,$02,$01
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $01,$02,$03,$04,$05,$06,$07,$08
    db $09,$0A,$0B,$0C,$0D,$0E,$0F,$10
    db $11,$12,$13,$14,$15,$16,$17,$18
    db $19,$1A,$1B,$1C,$1D,$1E,$1F,$20
    db $20,$20,$20,$20,$20,$20,$20,$20
    db $20,$20,$20,$20,$20,$20,$20,$20
DATA_038C2A:
    db $00,$F8,$00,$08

; Interaction Y positions for the Carrot Top Lift at each X position. This effctively defines the shape of the platform.
; Up-Right platform
; Up-Left platform
  - RTS                                       ; Movement speeds for the Carrot Top Lift.

CarrotTopLift:
; Carrot Top Lift misc RAM:
; $C2   - Movement phase. Value mod 4: 0/2 = stationary, 1 = moving left, 3 = moving right
; $151C - Previous X position, for determining whether or not Mario is on the platform.
; $1540 - Movement timer.
; Carrot Top Lift MAIN
    JSR CarrotTopLiftGfx                      ; Draw GFX.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE -
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    LDA.W SpriteMisc1540,X
    BNE +
    INC.B SpriteTableC2,X                     ; If at the end of a particular movement, increment phase pointer and set timer.
    LDA.B #$80
    STA.W SpriteMisc1540,X
  + LDA.B SpriteTableC2,X
    AND.B #$03
    TAY                                       ; Store X speed for the current movement.
    LDA.W DATA_038C2A,Y
    STA.B SpriteXSpeed,X
    LDA.B SpriteXSpeed,X
    LDY.B SpriteNumber,X
    CPY.B #$B8
    BEQ +                                     ; Store Y speed for the current movement, as equal to the X speed.
    EOR.B #$FF                                ; If sprite B8 (up-left), reverse the Y speed.
    INC A
  + STA.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW                     ; Update Y position.
    LDA.B SpriteXPosLow,X                     ; Preserve old X position, for moving Mario with the platform.
    STA.W SpriteMisc151C,X
    JSL UpdateXPosNoGvtyW                     ; Update X position.
    JSR CODE_038CE4
    JSL GetSpriteClippingA
    JSL CheckForContact                       ; Return if not in contact with the platform, or Mario is moving upwards.
    BCC Return038CE3
    LDA.B PlayerYSpeed+1
    BMI Return038CE3
    LDA.B PlayerXPosNext
    SEC
    SBC.W SpriteMisc151C,X
    CLC
    ADC.B #$1C
    LDY.B SpriteNumber,X                      ; Get index to the Y position table based on Mario's current X position within the platform.
    CPY.B #$B8
    BNE +
    CLC
    ADC.B #$38
  + TAY
    LDA.W PlayerRidingYoshi
    CMP.B #$01
    LDA.B #$20
    BCC +                                     ; Get lower interaction point for Mario's Y position, accounting for whether he's on Yoshi or not.
    LDA.B #$30                                ; This point determines whether or not Mario is on top of the platform.
  + CLC
    ADC.B PlayerYPosNext
    STA.B _0
    LDA.B SpriteYPosLow,X
    CLC
    ADC.W DATA_038BAA,Y                       ; Return if not in contact with the platform at the current X position.
    CMP.B _0
    BPL Return038CE3
    LDA.W PlayerRidingYoshi
    CMP.B #$01
    LDA.B #$1D                                ; Get upper interaction point for Mario's Y position, accounting for whether he's on Yoshi or not.
    BCC +                                     ; This point indicates where Mario's feet are relative to his position.
    LDA.B #$2D
  + STA.B _0
    LDA.B SpriteYPosLow,X
    CLC
    ADC.W DATA_038BAA,Y
    PHP
    SEC
    SBC.B _0                                  ; Move Mario on top of the platform.
    STA.B PlayerYPosNext
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    PLP
    ADC.B #$00
    STA.B PlayerYPosNext+1
    STZ.B PlayerYSpeed+1                      ; Clear Mario's Y speed.
    LDA.B #$01                                ; Set flag for being on a sprite.
    STA.W StandOnSolidSprite
    LDY.B #$00
    LDA.W SpriteXMovement
    BPL +
    DEY
  + CLC                                       ; Move Mario horizontally with the platform.
    ADC.B PlayerXPosNext
    STA.B PlayerXPosNext
    TYA
    ADC.B PlayerXPosNext+1
    STA.B PlayerXPosNext+1
Return038CE3:
    RTS

CODE_038CE4:
    LDA.B PlayerXPosNext                      ; Routine for the Carrot Top platform to get Mario's clipping data.
    CLC
    ADC.B #$04
    STA.B _0                                  ; Get clipping X position.
    LDA.B PlayerXPosNext+1
    ADC.B #$00
    STA.B _8
    LDA.B #$08
    STA.B _2                                  ; Get interaction area as an 8x8 square.
    STA.B _3
    LDA.B #$20
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$30
  + CLC                                       ; Get clipping Y position.
    ADC.B PlayerYPosNext
    STA.B _1
    LDA.B PlayerYPosNext+1
    ADC.B #$00
    STA.B _9
    RTS


DiagPlatDispX:
    db $10,$00,$10,$00,$10,$00

DiagPlatDispY:
    db $00,$10,$10,$00,$10,$10

DiagPlatTiles2:
    db $E4,$E0,$E2,$E4,$E0,$E2

DiagPlatGfxProp:
    db $0B,$0B,$0B,$4B,$4B,$4B

CarrotTopLiftGfx:
; X offsets for each tile of the Carrot Top platform.
; Down-left
; Up-left
; Y offsets for each tile of the Carrot Top platform.
; Down-left
; Up-left
; Tile numbers for each tile of the Carrot Top platform.
; Down-left
; Up-left
; YXPPCCCT for each tile of the Carrot Top platform.
; Down-left
; Up-left
    JSR GetDrawInfoBnk3                       ; Carrot Top Lift GFX routine
    PHX
    LDA.B SpriteNumber,X
    CMP.B #$B8
    LDX.B #$02                                ; Get index to the above tables, based on which platform this is.
    STX.B _2
    BCC CODE_038D34
    LDX.B #$05
CODE_038D34:
    LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W DiagPlatDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W DiagPlatDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DiagPlatTiles2,X                    ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.W DiagPlatGfxProp,X
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    DEX
    DEC.B _2
    BPL CODE_038D34
    PLX
    LDY.B #$02
    TYA                                       ; Upload 3 16x16 tiles.
    JSL FinishOAMWrite
    RTS


DATA_038D66:
    db $00,$04,$07,$08,$08,$07,$04,$00
    db $00

InfoBox:
; Message box misc RAM:
; $C2   - Flag for the box having been hit from below.
; $1528 - Unused, but would cause Mario to move horizontally when standing on the platform if non-zero.
; $1558 - Timer for the bounce animation when hit below.
; $157C - Horizontal direction the sprite is facing. Always 0.
; Message Box MAIN
    JSL InvisBlkMainRt                        ; Make solid.
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    LDA.W SpriteMisc1558,X
    CMP.B #$01                                ; Branch if not time to display the box's message.
    BNE +
    LDA.B #!SFX_MESSAGE                       ; \ Play sound effect; SFX for hitting a message box.
    STA.W SPCIO3                              ; /
    STZ.W SpriteMisc1558,X
    STZ.B SpriteTableC2,X
    LDA.B SpriteXPosLow,X
    LSR A
    LSR A
    LSR A                                     ; Activate message.
    LSR A
    AND.B #$01
    INC A
    STA.W MessageBoxTrigger
  + LDA.W SpriteMisc1558,X
    LSR A
    TAY
    LDA.B Layer1YPos
    PHA
    CLC                                       ; If the block was hit and is doing a bounce animation, offset Y position.
    ADC.W DATA_038D66,Y
    STA.B Layer1YPos
    LDA.B Layer1YPos+1
    PHA
    ADC.B #$00
    STA.B Layer1YPos+1
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM; Draw a 16x16 sprite.
    LDA.B #$C0                                ; Tile the message box uses.
    STA.W OAMTileNo+$100,Y
    PLA
    STA.B Layer1YPos+1                        ; Restore Y position.
    PLA
    STA.B Layer1YPos
    RTS

TimedLift:
; Timed lift misc RAM:
; $C2   - Flag for whether the platform has been started (10) or not (00).
; $1528 - Number of pixels moved in a frame, for moving Mario.
; $1570 - Timer for the platform's clock.
; Timed Lift MAIN
    JSR TimedPlatformGfx                      ; Draw GFX.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return038DEF
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    LDA.B TrueFrame
    AND.B #$00
    BNE +
    LDA.B SpriteTableC2,X                     ; If the platform has started moving, decrement the timer each frame.
    BEQ +
    LDA.W SpriteMisc1570,X
    BEQ +
    DEC.W SpriteMisc1570,X
  + LDA.W SpriteMisc1570,X                    ; Branch if the platform hasn't fallen yet.
    BEQ CODE_038DF0
    JSL UpdateXPosNoGvtyW                     ; Update X position.
    STA.W SpriteMisc1528,X
    JSL InvisBlkMainRt                        ; Make solid and return if Mario isn't on the platform.
    BCC Return038DEF
    LDA.B #$10                                ; X speed to give the timed platform once started.
    STA.B SpriteXSpeed,X
    STA.B SpriteTableC2,X
Return038DEF:
    RTS

CODE_038DF0:
; Platform's timer has run out, make it fall.
    JSL UpdateSpritePos                       ; Update X/Y position and apply gravity.
    LDA.W SpriteXMovement
    STA.W SpriteMisc1528,X                    ; Make solid.
    JSL InvisBlkMainRt
    RTS


TimedPlatDispX:
    db $00,$10,$0C

TimedPlatDispY:
    db $00,$00,$04

TimedPlatTiles:
    db $C4,$C4,$00

TimedPlatGfxProp:
    db $0B,$4B,$0B

TimedPlatTileSize:
    db $02,$02,$00

TimedPlatNumTiles:
    db $B6,$B5,$B4,$B3

TimedPlatformGfx:
; X offsets for each tile in the timed platform.
; Y offsets for each tile in the timed platform.
; Tile numbers for each tile in the timed platform.
; Last byte unused (it's the number's tile).
; YXPPCCCT for each tile in the timed platform.
; Size for each tile in the timed platform.
; Tile numbers for each of the numbers on the timed platform.
    JSR GetDrawInfoBnk3                       ; Timed Platform GFX routine
    LDA.W SpriteMisc1570,X
    PHX
    PHA
    LSR A
    LSR A
    LSR A                                     ; $02 = Tile for the number on the platform.
    LSR A
    LSR A
    LSR A
    TAX
    LDA.W TimedPlatNumTiles,X
    STA.B _2
    LDX.B #$02
    PLA
    CMP.B #$08                                ; Get number of tiles to upload; if the timer has run out, don't draw the number.
    BCS CODE_038E2E
    DEX
CODE_038E2E:
    LDA.B _0                                  ; Tile loop.
    CLC                                       ; Store X position to OAM.
    ADC.W TimedPlatDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W TimedPlatDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W TimedPlatTiles,X
    CPX.B #$02
    BNE +                                     ; Store tile number to OAM.
    LDA.B _2
  + STA.W OAMTileNo+$100,Y
    LDA.W TimedPlatGfxProp,X
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Store size to OAM.
    TAY
    LDA.W TimedPlatTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL CODE_038E2E
    PLX
    LDY.B #$FF
    LDA.B #$02                                ; Upload 3 manually-sized tiles.
    JSL FinishOAMWrite
    RTS


GreyMoveBlkSpeed:
    db $00,$F0,$00,$10

GreyMoveBlkTiming:
    db $40,$50,$40,$50

GreyCastleBlock:
; Castle Block misc RAM:
; $C2   - Movement phase. Mod 4: 0/2 = stationary, 1 = left, 2 = right.
; $1528 - Number of pixels moved in a frame, for moving Mario.
; $1540 - Movement timer.
; $1558 - Unused timer set when hit from below, when $C2 is 0.
; $1564 - Unused timer set when hit from below.
; Moving gray castle block MAIN
    JSR CODE_038EB4                           ; Draw GFX.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return038EA7
    LDA.W SpriteMisc1540,X
    BNE +
    INC.B SpriteTableC2,X
    LDA.B SpriteTableC2,X                     ; If at the end of a particular movement, increment phase pointer and set timer.
    AND.B #$03
    TAY
    LDA.W GreyMoveBlkTiming,Y
    STA.W SpriteMisc1540,X
  + LDA.B SpriteTableC2,X
    AND.B #$03
    TAY                                       ; Store X speed.
    LDA.W GreyMoveBlkSpeed,Y
    STA.B SpriteXSpeed,X
    JSL UpdateXPosNoGvtyW                     ; Update X position.
    STA.W SpriteMisc1528,X                    ; Make solid.
    JSL InvisBlkMainRt
Return038EA7:
    RTS


GreyMoveBlkDispX:
    db $00,$10,$00,$10

GreyMoveBlkDispY:
    db $00,$00,$10,$10

GreyMoveBlkTiles:
    db $CC,$CE,$EC,$EE

CODE_038EB4:
; Moving castle block X offsets.
; Moving castle block Y offsets.
; Moving castle block tile numbers.
    JSR GetDrawInfoBnk3                       ; Moving castle block GFX routine.
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W GreyMoveBlkDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W GreyMoveBlkDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W GreyMoveBlkTiles,X                  ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.B #$03
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY                                       ; Loop for all tiles.
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$03                                ; Upload 4 16x16 tiles.
    JSL FinishOAMWrite
    RTS


StatueFireSpeed:
    db $10,$F0

StatueFireball:
; X speeds for the statue fireball.
; Statue Fireball misc RAM:
; $157C - Horizontal direction the sprite is facing.
; Statue fireball MAIN
    JSR StatueFireballGfx                     ; Draw GFX.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE +
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    JSL MarioSprInteract                      ; Process interaction with Mario.
    LDY.W SpriteMisc157C,X
    LDA.W StatueFireSpeed,Y                   ; Store X speed.
    STA.B SpriteXSpeed,X
    JSL UpdateXPosNoGvtyW                     ; Update X position.
  + RTS


StatueFireDispX:
    db $08,$00,$00,$08

StatueFireTiles:
    db $32,$50,$33,$34,$32,$50,$33,$34
StatueFireGfxProp:
    db $09,$09,$09,$09,$89,$89,$89,$89

StatueFireballGfx:
; X offsets for each tile of the statue fireball, indexed by its direction.
; Tile numbers for each frame of the statue fireball's animation.
; YXPPCCCT for each frame of the statue fireball's animation.
    JSR GetDrawInfoBnk3                       ; Statue fireball GFX routine
    LDA.W SpriteMisc157C,X
    ASL A                                     ; $02 = horizontal direction, x2.
    STA.B _2
    LDA.B EffFrame
    LSR A
    AND.B #$03                                ; $03 = animation frame, x4
    ASL A
    STA.B _3
    PHX
    LDX.B #$01
CODE_038F2F:
; Tile loop.
    LDA.B _1                                  ; Store Y position to OAM.
    STA.W OAMTileYPos+$100,Y
    PHX
    TXA
    ORA.B _2
    TAX
    LDA.B _0                                  ; Store X position to OAM.
    CLC
    ADC.W StatueFireDispX,X
    STA.W OAMTileXPos+$100,Y
    PLA
    PHA
    ORA.B _3                                  ; Store tile number to OAM.
    TAX
    LDA.W StatueFireTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W StatueFireGfxProp,X
    LDX.B _2
    BNE +
    EOR.B #$40                                ; Store YXPPCCCT to OAM.
  + ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLX
    INY
    INY
    INY                                       ; Loop for all tiles.
    INY
    DEX
    BPL CODE_038F2F
    PLX
    LDY.B #$00
    LDA.B #$01                                ; Upload 2 8x8 tiles.
    JSL FinishOAMWrite
    RTS


BooStreamFrntTiles:
    db $88,$8C,$8E,$A8,$AA,$AE,$88,$8C

ReflectingFireball:
; Tile numbers for the Boo Stream's animation.
; Reflecting Fireball / Boo Stream misc RAM:
; $157C - (Boo Stream only) Horizontal direction the sprite is facing.
; Reflecting fireball MAIN
    JSR CODE_038FF2                           ; Draw GFX.
    BRA CODE_038FA4                           ; Continue to routine below.

BooStream:
    LDA.B #$00                                ; Boo Stream MAIN
    LDY.B SpriteXSpeed,X
    BPL +                                     ; Set horizontal direction based on current X speed.
    INC A
  + STA.W SpriteMisc157C,X
    JSL GenericSprGfxRt2                      ; Draw a 16x16 tile.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    LSR A
    AND.B #$01
    STA.B _0                                  ; Change tile number in OAM, animating based on the current frame number.
    TXA
    AND.B #$03
    ASL A
    ORA.B _0
    PHX
    TAX
    LDA.W BooStreamFrntTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
CODE_038FA4:
    LDA.W SpriteStatus,X                      ; Reflecting Fireball joins in.
    CMP.B #$08
    BNE Return038FF1                          ; Return if sprite dead or game frozen.
    LDA.B SpriteLock
    BNE Return038FF1
    TXA
    EOR.B EffFrame
    AND.B #$07
    ORA.W SpriteOffscreenVert,X               ; Boo Stream only:
    BNE +                                     ; Every 8 frames while vertically onscreen, spawn a stream trail minor extended sprite.
    LDA.B SpriteNumber,X
    CMP.B #$B0
    BNE +
    JSR CODE_039020
  + JSL UpdateYPosNoGvtyW                     ; Update Y position.
    JSL UpdateXPosNoGvtyW                     ; Update X position.
    JSL CODE_019138                           ; Process interaction with blocks.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    LDA.B SpriteXSpeed,X                      ; If hitting a wall, invert X speed.
    EOR.B #$FF
    INC A
    STA.B SpriteXSpeed,X
  + LDA.W SpriteBlockedDirs,X
    AND.B #$0C
    BEQ +
    LDA.B SpriteYSpeed,X                      ; If hitting a ceiling/floor, invert Y speed.
    EOR.B #$FF
    INC A
    STA.B SpriteYSpeed,X
  + JSL MarioSprInteract                      ; Process interaction with Mario.
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
Return038FF1:
    RTS

CODE_038FF2:
; Routine to handle graphics for the Reflecting Fireball.
    JSL GenericSprGfxRt2                      ; Draw a 16x16 sprite.
    LDA.B EffFrame
    LSR A
    LSR A                                     ; Get palette for current frame.
    LDA.B #$04
    BCC +
    ASL A
  + LDY.B SpriteXSpeed,X
    BPL +
    EOR.B #$40
  + LDY.B SpriteYSpeed,X                      ; Get X/Y flip based on the direction the sprite is moving.
    BMI +
    EOR.B #$80
  + STA.B _0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$AC                                ; Tile to use for the reflecting fireball.
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$100,Y
    AND.B #$31                                ; Change YXPPCCCT stored in OAM.
    ORA.B _0
    STA.W OAMTileAttr+$100,Y
    RTS

CODE_039020:
    LDY.B #$0B                                ; Subroutine to spawn the stream trail minor extended sprites for the Boo Stream.
CODE_039022:
    LDA.W MinExtSpriteNumber,Y
    BEQ CODE_039037
    DEY
    BPL CODE_039022                           ; Find an empty minor extended sprite slot, or replace one if none found.
    DEC.W MinExtSpriteSlotIdx
    BPL +
    LDA.B #$0B
    STA.W MinExtSpriteSlotIdx
  + LDY.W MinExtSpriteSlotIdx
CODE_039037:
    LDA.B #$0A                                ; Store sprite number.
    STA.W MinExtSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W MinExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W MinExtSpriteXPosHigh,Y              ; Spawn at the Boo Stream's position.
    LDA.B SpriteYPosLow,X
    STA.W MinExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W MinExtSpriteYPosHigh,Y
    LDA.B #$30                                ; Boo stream lifespan timer.
    STA.W MinExtSpriteTimer,Y
    LDA.B SpriteXSpeed,X                      ; Transfer X speed, so that it faces the same direction.
    STA.W MinExtSpriteXSpeed,Y
    RTS


FishinBooAccelX:
    db $01,$FF

FishinBooMaxSpeedX:
    db $20,$E0

FishinBooAccelY:
    db $01,$FF

FishinBooMaxSpeedY:
    db $10,$F0

FishinBoo:
; X accelerations for the Fishin' Boo.
; Max X speeds for the Fishin' Boo.
; Y accelerations for the Fishin' Boo.
; Max Y speeds for the Fishin' Boo.
; Fishin' Boo misc RAM:
; $C2   - Direction of vertical acceleration. Even = down, odd = up.
; $157C - Horizontal direciton the sprite is facing.
; $15AC - Turn timer.
; $1602 - Animation frame.
; 0 =normal, 1 = turning
; Fishin' Boo MAIN
    JSR FishinBooGfx                          ; Draw GFX.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return0390EA
    JSL MarioSprInteract                      ; Process interaction with Mario.
    JSR SubHorzPosBnk3
    STZ.W SpriteMisc1602,X
    LDA.W SpriteMisc15AC,X                    ; Handle turning the sprite towards Mario.
    BEQ +
    INC.W SpriteMisc1602,X
    CMP.B #$10
    BNE +                                     ; Actually flip the direction of the sprite when time to.
    TYA
    STA.W SpriteMisc157C,X
  + TXA
    ASL A
    ASL A
    ASL A
    ASL A
    ADC.B TrueFrame
    AND.B #$3F
    ORA.W SpriteMisc15AC,X
    BNE +
    LDA.B #$20                                ; How long the Fishin' Boo takes to turn around.
    STA.W SpriteMisc15AC,X
  + LDA.W SpriteWillAppear
    BEQ +
    TYA                                       ; If sprite D2 is spawned, make the Fishin' Boo fly away from Mario.
    EOR.B #$01
    TAY
  + LDA.B SpriteXSpeed,X                      ; \ If not at max X speed, accelerate
    CMP.W FishinBooMaxSpeedX,Y                ; |
    BEQ +                                     ; |; Horizontally accelerate the Boo towards Mario if not already at the max speed.
    CLC                                       ; |
    ADC.W FishinBooAccelX,Y                   ; |
    STA.B SpriteXSpeed,X                      ; /
  + LDA.B TrueFrame
    AND.B #$01
    BNE +
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY                                       ; Handle vertical acceleration.
    LDA.B SpriteYSpeed,X                      ; When at the maximum Y speed in a particular direction, invert the direction of acceleration (for the "wave" motion).
    CLC
    ADC.W FishinBooAccelY,Y
    STA.B SpriteYSpeed,X
    CMP.W FishinBooMaxSpeedY,Y
    BNE +
    INC.B SpriteTableC2,X
  + LDA.B SpriteXSpeed,X
    PHA
    LDY.W SpriteWillAppear
    BNE +
    LDA.W Layer1DXPos
    ASL A
    ASL A
    ASL A                                     ; Update the sprite's X position, and move it with the screen.
    CLC
    ADC.B SpriteXSpeed,X
    STA.B SpriteXSpeed,X
  + JSL UpdateXPosNoGvtyW
    PLA
    STA.B SpriteXSpeed,X
    JSL UpdateYPosNoGvtyW                     ; Update Y position.
    JSR CODE_0390F3                           ; Process interaction between the flame and Mario.
Return0390EA:
    RTS


DATA_0390EB:
    db $1A,$14,$EE,$F8

DATA_0390EF:
    db $00,$00,$FF,$FF

CODE_0390F3:
    LDA.W SpriteMisc157C,X                    ; Subroutine to handle interaction with the Fishin' Boo's flame.
    ASL A
    ADC.W SpriteMisc1602,X
    TAY
    LDA.B SpriteXPosLow,X
    CLC                                       ; Get X position of the flame.
    ADC.W DATA_0390EB,Y
    STA.B _4
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_0390EF,Y
    STA.B _A
    LDA.B #$04                                ; Size of the Fishin' Boo flame's hitbox.
    STA.B _6
    STA.B _7
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$47
    STA.B _5                                  ; Get Y position of the flame.
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _B
    JSL GetMarioClipping
    JSL CheckForContact                       ; Return if not in contact with Mario.
    BCC +
    JSL HurtMario                             ; Hurt Mario (even if he's on Yoshi!).
  + RTS


FishinBooDispX:
    db $FB,$05,$00,$F2,$FD,$03,$EA,$EA
    db $EA,$EA,$FB,$05,$00,$FA,$FD,$03
    db $F2,$F2,$F2,$F2,$FB,$05,$00,$0E
    db $03,$FD,$16,$16,$16,$16,$FB,$05
    db $00,$06,$03,$FD,$0E,$0E,$0E,$0E
FishinBooDispY:
    db $0B,$0B,$00,$03,$0F,$0F,$13,$23
    db $33,$43

FishinBooTiles1:
    db $60,$60,$64,$8A,$60,$60,$AC,$AC
    db $AC,$CE

FishinBooGfxProp:
    db $04,$04,$0D,$09,$04,$04,$0D,$0D
    db $0D,$07

FishinBooTiles2:
    db $CC,$CE,$CC,$CE

DATA_039178:
    db $00,$00,$40,$40

DATA_03917C:
    db $00,$40,$C0,$80

FishinBooGfx:
    JSR GetDrawInfoBnk3                       ; X offsets for the Fishin' Boo's tiles.
    LDA.W SpriteMisc1602,X
    STA.B _4
    LDA.W SpriteMisc157C,X
    STA.B _2
    PHX
    PHY
    LDX.B #$09
CODE_039191:
    LDA.B _1
    CLC
    ADC.W FishinBooDispY,X
    STA.W OAMTileYPos+$100,Y
    STZ.B _3
    LDA.W FishinBooTiles1,X
    CPX.B #$09
    BNE +
    LDA.B EffFrame
    LSR A
    LSR A
    PHX
    AND.B #$03
    TAX
    LDA.W DATA_039178,X
    STA.B _3
    LDA.W FishinBooTiles2,X
    PLX
  + STA.W OAMTileNo+$100,Y
    LDA.B _2
    CMP.B #$01
    LDA.W FishinBooGfxProp,X
    EOR.B _3
    ORA.B SpriteProperties
    BCS +
    EOR.B #$40
  + STA.W OAMTileAttr+$100,Y
    PHX
    LDA.B _4
    BEQ +
    TXA
    CLC
    ADC.B #$0A
    TAX
  + LDA.B _2
    BNE +
    TXA
    CLC
    ADC.B #$14
    TAX
  + LDA.B _0
    CLC
    ADC.W FishinBooDispX,X
    STA.W OAMTileXPos+$100,Y
    PLX
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_039191
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    AND.B #$03
    TAX
    PLY
    LDA.W DATA_03917C,X
    EOR.W OAMTileAttr+$110,Y
    STA.W OAMTileAttr+$110,Y
    STA.W OAMTileAttr+$124,Y
    EOR.B #$C0
    STA.W OAMTileAttr+$114,Y
    STA.W OAMTileAttr+$120,Y
    PLX
    LDY.B #$02
    LDA.B #$09
    JSL FinishOAMWrite
    RTS

FallingSpike:
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$E0
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileYPos+$100,Y
    DEC A
    STA.W OAMTileYPos+$100,Y
    LDA.W SpriteMisc1540,X
    BEQ +
    LSR A
    LSR A
    AND.B #$01
    CLC
    ADC.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$100,Y
  + LDA.B SpriteLock
    BNE CODE_03926C
    JSR SubOffscreen0Bnk3
    JSL UpdateSpritePos
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_03924C
    dw CODE_039262

CODE_03924C:
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    JSR SubHorzPosBnk3
    LDA.B _F
    CLC
    ADC.B #$40
    CMP.B #$80
    BCS +
    INC.B SpriteTableC2,X
    LDA.B #con($40,$40,$40,$20,$20)
    STA.W SpriteMisc1540,X
  + RTS

CODE_039262:
    LDA.W SpriteMisc1540,X
    BNE CODE_03926C
    JSL MarioSprInteract
    RTS

CODE_03926C:
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    RTS


CrtEatBlkSpeedX:
    db $10,$F0,$00,$00,$00

CrtEatBlkSpeedY:
    db $00,$00,$10,$F0,$00

DATA_039279:
    db $00,$00,$01,$00,$02,$00,$00,$00
    db $03,$00,$00

CreateEatBlock:
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileYPos+$100,Y
    DEC A
    STA.W OAMTileYPos+$100,Y
    LDA.B #$2E
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$100,Y
    AND.B #$3F
    STA.W OAMTileAttr+$100,Y
    LDY.B #$02
    LDA.B #$00
    JSL FinishOAMWrite
    LDY.B #$04
    LDA.W BlockSnakeActive
    CMP.B #$FF
    BEQ CODE_0392C0
    LDA.B TrueFrame
    AND.B #$03
    ORA.B SpriteLock
    BNE +
    LDA.B #!SFX_BLOCKSNAKE                    ; \ Play sound effect
    STA.W SPCIO1                              ; /
  + LDY.W SpriteMisc157C,X
CODE_0392C0:
    LDA.B SpriteLock
    BNE Return03932B
    LDA.W CrtEatBlkSpeedX,Y
    STA.B SpriteXSpeed,X
    LDA.W CrtEatBlkSpeedY,Y
    STA.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW
    JSL UpdateXPosNoGvtyW
    STZ.W SpriteMisc1528,X
    JSL InvisBlkMainRt
    LDA.W BlockSnakeActive
    CMP.B #$FF
    BEQ Return03932B
    LDA.B SpriteYPosLow,X
    ORA.B SpriteXPosLow,X
    AND.B #$0F
    BNE Return03932B
    LDA.W SpriteMisc151C,X
    BNE CODE_03932C
    DEC.W SpriteMisc1570,X
    BMI CODE_0392F8
    BNE CODE_03931F
CODE_0392F8:
    LDY.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,Y
    CMP.B #$01
    LDY.W SpriteMisc1534,X
    INC.W SpriteMisc1534,X
    LDA.W CrtEatBlkData1,Y
    BCS +
    LDA.W CrtEatBlkData2,Y
  + STA.W SpriteMisc1602,X
    PHA
    LSR A
    LSR A
    LSR A
    LSR A
    STA.W SpriteMisc1570,X
    PLA
    AND.B #$03
    STA.W SpriteMisc157C,X
CODE_03931F:
    LDA.B #$0D
    JSR GenTileFromSpr1
    LDA.W SpriteMisc1602,X
    CMP.B #$FF
    BEQ +
Return03932B:
    RTS

CODE_03932C:
    LDA.B #$02
    JSR GenTileFromSpr1
    LDA.B #$01
    STA.B SpriteXSpeed,X
    STA.B SpriteYSpeed,X
    JSL CODE_019138
    LDA.W SpriteBlockedDirs,X
    PHA
    LDA.B #$FF
    STA.B SpriteXSpeed,X
    STA.B SpriteYSpeed,X
    LDA.B SpriteXPosLow,X
    PHA
    SEC
    SBC.B #$01
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B SpriteYPosLow,X
    PHA
    SEC
    SBC.B #$01
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    JSL CODE_019138
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    PLA
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X
    PLA
    ORA.W SpriteBlockedDirs,X
    BEQ +
    TAY
    LDA.W DATA_039279,Y
    STA.W SpriteMisc157C,X
    RTS

  + STZ.W SpriteStatus,X
    RTS

GenTileFromSpr1:
    STA.B Map16TileGenerate                   ; $9C = tile to generate
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position
    STA.B TouchBlockXPos                      ; | for block creation
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ $98 = Sprite Y position
    STA.B TouchBlockYPos                      ; | for block creation
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B TouchBlockYPos+1                    ; /
    JSL GenerateTile                          ; Generate the tile
    RTS


CrtEatBlkData1:
    db $10,$13,$10,$13,$10,$13,$10,$13
    db $10,$13,$10,$13,$10,$13,$10,$13
    db $F0,$F0,$20,$12,$10,$12,$10,$12
    db $10,$12,$10,$12,$10,$12,$10,$12
    db $D0,$C3,$F1,$21,$22,$F1,$F1,$51
    db $43,$10,$13,$10,$13,$10,$13,$F0
    db $F0,$F0,$60,$32,$60,$32,$71,$32
    db $60,$32,$61,$32,$70,$33,$10,$33
    db $10,$33,$10,$33,$10,$33,$F0,$10
    db $F2,$52,$FF

CrtEatBlkData2:
    db $80,$13,$10,$13,$10,$13,$10,$13
    db $60,$23,$20,$23,$B0,$22,$A1,$22
    db $A0,$22,$A1,$22,$C0,$13,$10,$13
    db $10,$13,$10,$13,$10,$13,$10,$13
    db $10,$13,$F0,$F0,$F0,$52,$50,$33
    db $50,$32,$50,$33,$50,$22,$50,$33
    db $F0,$50,$82,$FF

WoodenSpike:
    JSR WoodSpikeGfx
    LDA.B SpriteLock
    BNE +
    JSR SubOffscreen0Bnk3
    JSR CODE_039488
    LDA.B SpriteTableC2,X
    AND.B #$03
    JSL ExecutePtr

    dw CODE_039458
    dw CODE_03944E
    dw CODE_039441
    dw CODE_03946B

  + RTS

CODE_039441:
    LDA.W SpriteMisc1540,X
    BEQ CODE_03944A
    LDA.B #$20
    BRA CODE_039475

CODE_03944A:
    LDA.B #$30
    BRA SetTimerNextState

CODE_03944E:
    LDA.W SpriteMisc1540,X
    BNE Return039457
    LDA.B #$18
    BRA SetTimerNextState

Return039457:
    RTS

CODE_039458:
    LDA.W SpriteMisc1540,X
    BEQ +
    LDA.B #$F0
    JSR CODE_039475
    RTS

  + LDA.B #$30
SetTimerNextState:
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X                     ; Goto next state
    RTS

CODE_03946B:
    LDA.W SpriteMisc1540,X                    ; \ If stall timer us up,
    BNE Return039474                          ; | reset it to #$2F...
    LDA.B #$2F                                ; |
    BRA SetTimerNextState                     ; | ...and goto next state

Return039474:
    RTS                                       ; /

CODE_039475:
    LDY.W SpriteMisc151C,X
    BEQ +
    EOR.B #$FF
    INC A
  + STA.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW
    RTS


DATA_039484:
    db $01,$FF

DATA_039486:
    db $00,$FF

CODE_039488:
    JSL MarioSprInteract
    BCC Return0394B0
    JSR SubHorzPosBnk3
    LDA.B _F
    CLC
    ADC.B #$04
    CMP.B #$08
    BCS +
    JSL HurtMario
    RTS

  + LDA.B PlayerXPosNext
    CLC
    ADC.W DATA_039484,Y
    STA.B PlayerXPosNext
    LDA.B PlayerXPosNext+1
    ADC.W DATA_039486,Y
    STA.B PlayerXPosNext+1
    STZ.B PlayerXSpeed+1
Return0394B0:
    RTS


WoodSpikeDispY:
    db $00,$10,$20,$30,$40,$40,$30,$20
    db $10,$00

WoodSpikeTiles:
    db $6A,$6A,$6A,$6A,$4A,$6A,$6A,$6A
    db $6A,$4A

WoodSpikeGfxProp:
    db $81,$81,$81,$81,$81,$01,$01,$01
    db $01,$01

WoodSpikeGfx:
    JSR GetDrawInfoBnk3
    STZ.B _2                                  ; \ Set $02 based on sprite number
    LDA.B SpriteNumber,X                      ; |
    CMP.B #$AD                                ; |
    BNE +                                     ; |
    LDA.B #$05                                ; |
    STA.B _2                                  ; /
  + PHX
    LDX.B #$04                                ; Draw 4 tiles:
  - PHX
    TXA
    CLC
    ADC.B _2
    TAX
    LDA.B _0                                  ; \ Set X
    STA.W OAMTileXPos+$100,Y                  ; /
    LDA.B _1                                  ; \ Set Y
    CLC                                       ; |
    ADC.W WoodSpikeDispY,X                    ; |
    STA.W OAMTileYPos+$100,Y                  ; /
    LDA.W WoodSpikeTiles,X                    ; \ Set tile
    STA.W OAMTileNo+$100,Y                    ; /
    LDA.W WoodSpikeGfxProp,X                  ; \ Set gfs properties
    STA.W OAMTileAttr+$100,Y                  ; /
    INY                                       ; \ We wrote 4 times, so increase index by 4
    INY                                       ; |
    INY                                       ; |
    INY                                       ; /
    PLX
    DEX
    BPL -
    PLX
    LDY.B #$02                                ; \ Wrote 5 16x16 tiles...
    LDA.B #$04                                ; |
    JSL FinishOAMWrite                        ; /
    RTS


RexSpeed:
    db $08,$F8,$10,$F0

RexMainRt:
    JSR RexGfxRt                              ; Draw Rex gfx
    LDA.W SpriteStatus,X                      ; \ If Rex status != 8...
    CMP.B #$08                                ; |   ... not (killed with spin jump [4] or star [2])
    BNE RexReturn                             ; /    ... return
    LDA.B SpriteLock                          ; \ If sprites locked...
    BNE RexReturn                             ; /    ... return
    LDA.W SpriteMisc1558,X                    ; \ If Rex not defeated (timer to show remains > 0)...
    BEQ RexAlive                              ; /    ... goto RexAlive
    STA.W SpriteOnYoshiTongue,X               ; \
    DEC A                                     ; |   If Rex remains don't disappear next frame...
    BNE RexReturn                             ; /    ... return
    STZ.W SpriteStatus,X                      ; This is the last frame to show remains, so set Rex status = 0
RexReturn:
    RTS

RexAlive:
    JSR SubOffscreen0Bnk3                     ; Only process Rex while on screen
    INC.W SpriteMisc1570,X                    ; Increment number of frames Rex has been on sc
    LDA.W SpriteMisc1570,X                    ; \ Calculate which frame to show:
    LSR A                                     ; |
    LSR A                                     ; |
    LDY.B SpriteTableC2,X                     ; | Number of hits determines if smushed
    BEQ CODE_03954A                           ; |
    AND.B #$01                                ; | Update every 8 cycles if smushed
    CLC                                       ; |
    ADC.B #$03                                ; | Show smushed frame
    BRA +                                     ; |

CODE_03954A:
    LSR A                                     ; |
    AND.B #$01                                ; | Update every 16 cycles if normal
  + STA.W SpriteMisc1602,X                    ; / Write frame to show
    LDA.W SpriteBlockedDirs,X                 ; \  If sprite is not on ground...
    AND.B #$04                                ; |    ...(4 = on ground) ...
    BEQ RexInAir                              ; /     ...goto IN_AIR
    LDA.B #$10                                ; \  Y speed = 10
    STA.B SpriteYSpeed,X                      ; /
    LDY.W SpriteMisc157C,X                    ; Load, y = Rex direction, as index for speed
    LDA.B SpriteTableC2,X                     ; \ If hits on Rex == 0...
    BEQ +                                     ; /    ...goto DONT_ADJUST_SPEED
    INY                                       ; \ Increment y twice...
    INY                                       ; /    ...in order to get speed for smushed Rex
  + LDA.W RexSpeed,Y                          ; \ Load x speed from ROM...
    STA.B SpriteXSpeed,X                      ; /    ...and store it
RexInAir:
    LDA.W SpriteMisc1FE2,X                    ; \ If time to show half-smushed Rex > 0...
    BNE +                                     ; /    ...goto HALF_SMUSHED
    JSL UpdateSpritePos                       ; Update position based on speed values
  + LDA.W SpriteBlockedDirs,X                 ; \ If Rex is touching the side of an object...
    AND.B #$03                                ; |
    BEQ +                                     ; |
    LDA.W SpriteMisc157C,X                    ; |
    EOR.B #$01                                ; |    ... change Rex direction
    STA.W SpriteMisc157C,X                    ; /
  + JSL SprSprInteract                        ; Interact with other sprites
    JSL MarioSprInteract                      ; Check for mario/Rex contact
    BCC NoRexContact                          ; (carry set = mario/Rex contact)
    LDA.W InvinsibilityTimer                  ; \ If mario star timer > 0 ...
    BNE RexStarKill                           ; /    ... goto HAS_STAR
    LDA.W SpriteMisc154C,X                    ; \ If Rex invincibility timer > 0 ...
    BNE NoRexContact                          ; /    ... goto NO_CONTACT
    LDA.B #$08                                ; \ Rex invincibility timer = $08
    STA.W SpriteMisc154C,X                    ; /
    LDA.B PlayerYSpeed+1                      ; \  If mario's y speed < 10 ...
    CMP.B #$10                                ; |   ... Rex will hurt mario
    BMI RexWins                               ; /
    JSR RexPoints                             ; Give mario points
    JSL BoostMarioSpeed                       ; Set mario speed
    JSL DisplayContactGfx                     ; Display contact graphic
    LDA.W SpinJumpFlag                        ; \  If mario is spin jumping...
    ORA.W PlayerRidingYoshi                   ; |    ... or on yoshi ...
    BNE RexSpinKill                           ; /     ... goto SPIN_KILL
    INC.B SpriteTableC2,X                     ; Increment Rex hit counter
    LDA.B SpriteTableC2,X                     ; \  If Rex hit counter == 2
    CMP.B #$02                                ; |
    BNE +                                     ; |
    LDA.B #$20                                ; |    ... time to show defeated Rex = $20
    STA.W SpriteMisc1558,X                    ; /
    RTS

  + LDA.B #$0C                                ; \ Time to show semi-squashed Rex = $0C
    STA.W SpriteMisc1FE2,X                    ; /
    STZ.W SpriteTweakerB,X                    ; Change clipping area for squashed Rex
    RTS

RexWins:
    LDA.W IFrameTimer                         ; \ If mario is invincible...
    ORA.W PlayerRidingYoshi                   ; |  ... or mario on yoshi...
    BNE NoRexContact                          ; /   ... return
    JSR SubHorzPosBnk3                        ; \  Set new Rex direction
    TYA                                       ; |
    STA.W SpriteMisc157C,X                    ; /
    JSL HurtMario                             ; Hurt mario
NoRexContact:
    RTS

RexSpinKill:
    LDA.B #$04                                ; \ Rex status = 4 (being killed by spin jump)
    STA.W SpriteStatus,X                      ; /
    LDA.B #$1F                                ; \ Set spin jump animation timer
    STA.W SpriteMisc1540,X                    ; /
    JSL CODE_07FC3B                           ; Show star animation
    LDA.B #!SFX_SPINKILL                      ; \
    STA.W SPCIO0                              ; / Play sound effect
    RTS

RexStarKill:
    LDA.B #$02                                ; \ Rex status = 2 (being killed by star)
    STA.W SpriteStatus,X                      ; /
    LDA.B #$D0                                ; \ Set y speed
    STA.B SpriteYSpeed,X                      ; /
    JSR SubHorzPosBnk3                        ; Get new Rex direction
    LDA.W RexKilledSpeed,Y                    ; \ Set x speed based on Rex direction
    STA.B SpriteXSpeed,X                      ; /
    INC.W StarKillCounter                     ; Increment number consecutive enemies killed
    LDA.W StarKillCounter                     ; \
    CMP.B #$08                                ; | If consecutive enemies stomped >= 8, reset to 8
    BCC +                                     ; |
    LDA.B #$08                                ; |
    STA.W StarKillCounter                     ; /
  + JSL GivePoints                            ; Give mario points
    LDY.W StarKillCounter                     ; \
    CPY.B #$08                                ; | If consecutive enemies stomped < 8 ...
    BCS +                                     ; |
    LDA.W StompSFX3-1,Y                       ; |    ... play sound effect
    STA.W SPCIO0                              ; / Play sound effect
  + RTS

    RTS


RexKilledSpeed:
    db $F0,$10

    RTS

RexPoints:
    PHY
    LDA.W SpriteStompCounter
    CLC
    ADC.W SpriteMisc1626,X
    INC.W SpriteStompCounter                  ; Increase consecutive enemies stomped
    TAY
    INY
    CPY.B #$08                                ; \ If consecutive enemies stomped >= 8 ...
    BCS +                                     ; /    ... don't play sound
    LDA.W StompSFX3-1,Y                       ; \
    STA.W SPCIO0                              ; / Play sound effect
  + TYA                                       ; \
    CMP.B #$08                                ; | If consecutive enemies stomped >= 8, reset to 8
    BCC +                                     ; |
    LDA.B #$08                                ; /
  + JSL GivePoints                            ; Give mario points
    PLY
    RTS


RexTileDispX:
    db $FC,$00,$FC,$00,$FE,$00,$00,$00
    db $00,$00,$00,$08,$04,$00,$04,$00
    db $02,$00,$00,$00,$00,$00,$08,$00
RexTileDispY:
    db $F1,$00,$F0,$00,$F8,$00,$00,$00
    db $00,$00,$08,$08

RexTiles:
    db $8A,$AA,$8A,$AC,$8A,$AA,$8C,$8C
    db $A8,$A8,$A2,$B2

RexGfxProp:
    db $47,$07

RexGfxRt:
    LDA.W SpriteMisc1558,X                    ; \ If time to show Rex remains > 0...
    BEQ +                                     ; |
    LDA.B #$05                                ; |    ...set Rex frame = 5 (fully squashed)
    STA.W SpriteMisc1602,X                    ; /
  + LDA.W SpriteMisc1FE2,X                    ; \ If time to show half smushed Rex > 0...
    BEQ +                                     ; |
    LDA.B #$02                                ; |    ...set Rex frame = 2 (half smushed)
    STA.W SpriteMisc1602,X                    ; /
  + JSR GetDrawInfoBnk3                       ; Y = index to sprite tile map, $00 = sprite x, $01 = sprite y
    LDA.W SpriteMisc1602,X                    ; \
    ASL A                                     ; | $03 = index to frame start (frame to show * 2 tile per frame)
    STA.B _3                                  ; /
    LDA.W SpriteMisc157C,X                    ; \ $02 = sprite direction
    STA.B _2                                  ; /
    PHX                                       ; Push sprite index
    LDX.B #$01                                ; Loop counter = (number of tiles per frame) - 1
RexGfxLoopStart:
    PHX                                       ; Push current tile number
    TXA                                       ; \ X = index to horizontal displacement
    ORA.B _3                                  ; / get index of tile (index to first tile of frame + current tile number)
    PHA                                       ; Push index of current tile
    LDX.B _2                                  ; \ If facing right...
    BNE +                                     ; |
    CLC                                       ; |
    ADC.B #$0C                                ; /    ...use row 2 of horizontal tile displacement table
  + TAX                                       ; \
    LDA.B _0                                  ; | Tile x position = sprite x location ($00) + tile displacement
    CLC                                       ; |
    ADC.W RexTileDispX,X                      ; |
    STA.W OAMTileXPos+$100,Y                  ; /
    PLX                                       ; \ Pull, X = index to vertical displacement and tilemap
    LDA.B _1                                  ; | Tile y position = sprite y location ($01) + tile displacement
    CLC                                       ; |
    ADC.W RexTileDispY,X                      ; |
    STA.W OAMTileYPos+$100,Y                  ; /
    LDA.W RexTiles,X                          ; \ Store tile
    STA.W OAMTileNo+$100,Y                    ; /
    LDX.B _2                                  ; \
    LDA.W RexGfxProp,X                        ; | Get tile properties using sprite direction
    ORA.B SpriteProperties                    ; | Level properties
    STA.W OAMTileAttr+$100,Y                  ; / Store tile properties
    TYA                                       ; \ Get index to sprite property map ($460)...
    LSR A                                     ; |    ...we use the sprite OAM index...
    LSR A                                     ; |    ...and divide by 4 because a 16x16 tile is 4 8x8 tiles
    LDX.B _3                                  ; | If index of frame start is > 0A
    CPX.B #$0A                                ; |
    TAX                                       ; |
    LDA.B #$00                                ; |     ...show only an 8x8 tile
    BCS +                                     ; |
    LDA.B #$02                                ; | Else show a full 16 x 16 tile
  + STA.W OAMTileSize+$40,X                   ; /
    PLX                                       ; \ Pull, X = current tile of the frame we're drawing
    INY                                       ; | Increase index to sprite tile map ($300)...
    INY                                       ; |    ...we wrote 4 times...
    INY                                       ; |    ...so increment 4 times
    INY                                       ; |
    DEX                                       ; | Go to next tile of frame and loop
    BPL RexGfxLoopStart                       ; /
    PLX                                       ; Pull, X = sprite index
    LDY.B #$FF                                ; \ FF because we already wrote size to $0460
    LDA.B #$01                                ; | A = number of tiles drawn - 1
    JSL FinishOAMWrite                        ; / Don't draw if offscreen
    RTS

Fishbone:
    JSR FishboneGfx
    LDA.B SpriteLock
    BNE Return03972A
    JSR SubOffscreen0Bnk3
    JSL MarioSprInteract
    JSL UpdateXPosNoGvtyW
    TXA
    ASL A
    ASL A
    ASL A
    ASL A
    ADC.B TrueFrame
    AND.B #$7F
    BNE +
    JSL GetRand
    AND.B #$01
    BNE +
    LDA.B #$0C
    STA.W SpriteMisc1558,X
  + LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_03972F
    dw CODE_03975E

Return03972A:
    RTS


FishboneMaxSpeed:
    db $10,$F0

FishboneAcceler:
    db $01,$FF

CODE_03972F:
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    NOP
    LSR A
    AND.B #$01
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    BEQ CODE_039756
    AND.B #$01
    BNE +
    LDY.W SpriteMisc157C,X
    LDA.B SpriteXSpeed,X
    CMP.W FishboneMaxSpeed,Y
    BEQ +
    CLC
    ADC.W FishboneAcceler,Y
    STA.B SpriteXSpeed,X
  + RTS

CODE_039756:
    INC.B SpriteTableC2,X
    LDA.B #$30
    STA.W SpriteMisc1540,X
    RTS

CODE_03975E:
    STZ.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    BEQ CODE_039776
    AND.B #$03
    BNE Return039775
    LDA.B SpriteXSpeed,X
    BEQ Return039775
    BPL +
    INC.B SpriteXSpeed,X
    RTS

  + DEC.B SpriteXSpeed,X
Return039775:
    RTS

CODE_039776:
    STZ.B SpriteTableC2,X
    LDA.B #$30
    STA.W SpriteMisc1540,X
    RTS


FishboneDispX:
    db $F8,$F8,$10,$10

FishboneDispY:
    db $00,$08

FishboneGfxProp:
    db $4D,$CD,$0D,$8D

FishboneTailTiles:
    db $A3,$A3,$B3,$B3

FishboneGfx:
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc1558,X
    CMP.B #$01
    LDA.B #$A6
    BCC +
    LDA.B #$A8
  + STA.W OAMTileNo+$100,Y
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc157C,X
    ASL A
    STA.B _2
    LDA.W SpriteMisc1602,X
    ASL A
    STA.B _3
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    TAY
    PHX
    LDX.B #$01
  - LDA.B _1
    CLC
    ADC.W FishboneDispY,X
    STA.W OAMTileYPos+$100,Y
    PHX
    TXA
    ORA.B _2
    TAX
    LDA.B _0
    CLC
    ADC.W FishboneDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.W FishboneGfxProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLA
    PHA
    ORA.B _3
    TAX
    LDA.W FishboneTailTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    LDY.B #$00
    LDA.B #$02
    JSL FinishOAMWrite
    RTS

CODE_0397F9:
    STA.B _1
    PHX
    PHY
    JSR SubVertPosBnk3
    STY.B _2
    LDA.B _E
    BPL +
    EOR.B #$FF
    CLC
    ADC.B #$01
  + STA.B _C
    JSR SubHorzPosBnk3
    STY.B _3
    LDA.B _F
    BPL +
    EOR.B #$FF
    CLC
    ADC.B #$01
  + STA.B _D
    LDY.B #$00
    LDA.B _D
    CMP.B _C
    BCS +
    INY
    PHA
    LDA.B _C
    STA.B _D
    PLA
    STA.B _C
  + LDA.B #$00
    STA.B _B
    STA.B _0
    LDX.B _1
CODE_039836:
    LDA.B _B
    CLC
    ADC.B _C
    CMP.B _D
    BCC +
    SBC.B _D
    INC.B _0
  + STA.B _B
    DEX
    BNE CODE_039836
    TYA
    BEQ +
    LDA.B _0
    PHA
    LDA.B _1
    STA.B _0
    PLA
    STA.B _1
  + LDA.B _0
    LDY.B _2
    BEQ +
    EOR.B #$FF
    CLC
    ADC.B #$01
    STA.B _0
  + LDA.B _1
    LDY.B _3
    BEQ +
    EOR.B #$FF
    CLC
    ADC.B #$01
    STA.B _1
  + PLY
    PLX
    RTS

ReznorInit:
    CPX.B #$07
    BNE +
    LDA.B #$04
    STA.B SpriteTableC2,X
    JSL CODE_03DD7D
  + JSL GetRand
    STA.W SpriteMisc1570,X
    RTL


ReznorStartPosLo:
    db $00,$80,$00,$80

ReznorStartPosHi:
    db $00,$00,$01,$01

ReboundSpeedX:
    db $20,$E0

Reznor:
    INC.W ReznorOAMIndex
    LDA.B SpriteLock
    BEQ +
    JMP DrawReznor

  + CPX.B #$07
    BNE CODE_039910
    PHX
    JSL CODE_03D70C                           ; Break bridge when necessary
    LDA.B #$80                                ; \ Set radius for Reznor sign rotation
    STA.B Mode7CenterX                        ; |
    STZ.B Mode7CenterX+1                      ; /
    LDX.B #$00
    LDA.B #$C0                                ; \ X position of Reznor sign
    STA.B SpriteXPosLow                       ; |
    STZ.W SpriteXPosHigh                      ; /
    LDA.B #$B2                                ; \ Y position of Reznor sign
    STA.B SpriteYPosLow                       ; |
    STZ.W SpriteYPosHigh                      ; /
    LDA.B #$2C
    STA.W Mode7TileIndex
    JSL CODE_03DEDF                           ; Applies position changes to Reznor sign
    PLX                                       ; Pull, X = sprite index
    REP #$20                                  ; A->16
    LDA.B Mode7Angle                          ; \ Rotate 1 frame around the circle (clockwise)
    CLC                                       ; | $37,36 = 0 to 1FF, denotes circle position
    ADC.W #$0001                              ; |
    AND.W #$01FF                              ; |
    STA.B Mode7Angle                          ; /
    SEP #$20                                  ; A->8
    CPX.B #$07
    BNE CODE_039910
    LDA.W SpriteMisc163E,X                    ; \ Branch if timer to trigger level isn't set
    BEQ ReznorNoLevelEnd                      ; /
    DEC A
    BNE CODE_039910
    DEC.W CutsceneID                          ; Prevent mario from walking at level end
    LDA.B #$FF                                ; \ Set time before return to overworld
    STA.W EndLevelTimer                       ; /
    LDA.B #!BGM_BOSSCLEAR                     ; \
    STA.W SPCIO2                              ; / Play sound effect
    RTS

ReznorNoLevelEnd:
    LDA.W SpriteMisc151C+7                    ; \
    CLC                                       ; |
    ADC.W SpriteMisc151C+6                    ; |
    ADC.W SpriteMisc151C+5                    ; |
    ADC.W SpriteMisc151C+4                    ; |
    CMP.B #$04                                ; |
    BNE CODE_039910                           ; |
    LDA.B #$90                                ; | Set time to trigger level if all Reznors are dead
    STA.W SpriteMisc163E,X                    ; /
    JSL KillMostSprites
    LDY.B #$07                                ; \ Zero out extended sprite table
    LDA.B #$00                                ; |
  - STA.W ExtSpriteNumber,Y                   ; |
    DEY                                       ; |
    BPL -                                     ; /
CODE_039910:
    LDA.W SpriteStatus,X
    CMP.B #$08
    BEQ +
    JMP DrawReznor

  + TXA                                       ; \ Load Y with Reznor number (0-3)
    AND.B #$03                                ; |
    TAY                                       ; /
    LDA.B Mode7Angle                          ; \
    CLC                                       ; |
    ADC.W ReznorStartPosLo,Y                  ; |
    STA.B _0                                  ; | $01,00 = 0-1FF, position Reznors on the circle
    LDA.B Mode7Angle+1                        ; |
    ADC.W ReznorStartPosHi,Y                  ; |
    AND.B #$01                                ; |
    STA.B _1                                  ; /
    REP #$30                                  ; \ AXY->16
    LDA.B _0                                  ; | Make Reznors turn clockwise rather than counter clockwise
    EOR.W #$01FF                              ; | ($01,00 = -1 * $01,00)
    INC A                                     ; |
    STA.B _0                                  ; /
    CLC
    ADC.W #$0080
    AND.W #$01FF
    STA.B _2
    LDA.B _0
    AND.W #$00FF
    ASL A
    TAX
    LDA.L CircleCoords,X
    STA.B _4
    LDA.B _2
    AND.W #$00FF
    ASL A
    TAX
    LDA.L CircleCoords,X
    STA.B _6
    SEP #$30                                  ; AXY->8
    LDA.B _4
    STA.W HW_WRMPYA
    LDA.B #$38
    LDY.B _5
    BNE +
    STA.W HW_WRMPYB
    NOP
    NOP
    NOP
    NOP
    ASL.W HW_RDMPY
    LDA.W HW_RDMPY+1
    ADC.B #$00
  + LSR.B _1
    BCC +
    EOR.B #$FF
    INC A
  + STA.B _4
    LDA.B _6
    STA.W HW_WRMPYA
    LDA.B #$38
    LDY.B _7
    BNE +
    STA.W HW_WRMPYB
    NOP
    NOP
    NOP
    NOP
    ASL.W HW_RDMPY
    LDA.W HW_RDMPY+1
    ADC.B #$00
  + LSR.B _3
    BCC +
    EOR.B #$FF
    INC A
  + STA.B _6
    LDX.W CurSpriteProcess                    ; X = sprite index
    LDA.B SpriteXPosLow,X
    PHA
    STZ.B _0
    LDA.B _4
    BPL +
    DEC.B _0
  + CLC
    ADC.B Mode7CenterX
    PHP
    CLC
    ADC.B #$40
    STA.B SpriteXPosLow,X
    LDA.B Mode7CenterX+1
    ADC.B #$00
    PLP
    ADC.B _0
    STA.W SpriteXPosHigh,X
    PLA
    SEC
    SBC.B SpriteXPosLow,X
    EOR.B #$FF
    INC A
    STA.W SpriteMisc1528,X
    STZ.B _1
    LDA.B _6
    BPL +
    DEC.B _1
  + CLC
    ADC.B Mode7CenterY
    PHP
    ADC.B #$20
    STA.B SpriteYPosLow,X
    LDA.B Mode7CenterY+1
    ADC.B #$00
    PLP
    ADC.B _1
    STA.W SpriteYPosHigh,X
    LDA.W SpriteMisc151C,X                    ; \ If a Reznor is dead, make it's platform standable
    BEQ +                                     ; |
    JSL InvisBlkMainRt                        ; |
    JMP DrawReznor                            ; /

  + LDA.B TrueFrame                           ; \ Don't try to spit fire if turning
    AND.B #$00                                ; |
    ORA.W SpriteMisc15AC,X                    ; |
    BNE +                                     ; /
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    CMP.B #$00
    BNE +
    STZ.W SpriteMisc1570,X
    LDA.B #$40                                ; \ Set time to show firing graphic = 0A
    STA.W SpriteMisc1558,X                    ; /
  + TXA
    ASL A
    ASL A
    ASL A
    ASL A
    ADC.B EffFrame
    AND.B #$3F
    ORA.W SpriteMisc1558,X                    ; Firing
    ORA.W SpriteMisc15AC,X                    ; Turning
    BNE +
    LDA.W SpriteMisc157C,X                    ; \ if direction has changed since last frame...
    PHA                                       ; |
    JSR SubHorzPosBnk3                        ; |
    TYA                                       ; |
    STA.W SpriteMisc157C,X                    ; |
    PLA                                       ; |
    CMP.W SpriteMisc157C,X                    ; |
    BEQ +                                     ; |
    LDA.B #$0A                                ; | ...set time to show turning graphic = 0A
    STA.W SpriteMisc15AC,X                    ; /
  + LDA.W SpriteMisc154C,X                    ; \ If disable interaction timer > 0, just draw Reznor
    BNE DrawReznor                            ; /
    JSL MarioSprInteract                      ; \ Interact with mario
    BCC DrawReznor                            ; / If no contact, just draw Reznor
    LDA.B #$08                                ; \ Disable interaction timer = 08
    STA.W SpriteMisc154C,X                    ; / (eg. after hitting Reznor, or getting bounced by platform)
    LDA.B PlayerYPosNext                      ; \ Compare y positions to see if mario hit Reznor
    SEC                                       ; |
    SBC.B SpriteYPosLow,X                     ; |
    CMP.B #$ED                                ; |
    BMI HitReznor                             ; /
    CMP.B #$F2                                ; \ See if mario hit side of the platform
    BMI HitPlatSide                           ; |
    LDA.B PlayerYSpeed+1                      ; |
    BPL HitPlatSide                           ; /
    LDA.B #$29                                ; ??Something about boosting mario on platform??
    STA.W SpriteTweakerB,X
    LDA.B #$0F                                ; \ Time to bounce platform = 0F
    STA.W SpriteMisc1564,X                    ; /
    LDA.B #$10                                ; \ Set mario's y speed to rebound down off platform
    STA.B PlayerYSpeed+1                      ; /
; Left, normal
; Left, turning
; Right, normal
; Right, turning
    LDA.B #!SFX_BONK                          ; \; Y offsets for the Fishin' Boo's tiles.
    STA.W SPCIO0                              ; / Play sound effect
    BRA DrawReznor

HitPlatSide:
    JSR SubHorzPosBnk3                        ; \ Set mario to bounce back
; Tile numbers for the Fishin' Boo.
; YXPPCCCT for the Fishin' Boo.
; Tile numbers for the Fishin' Boo's flame's animation.
; YXPPCCCT for the Fishin' Boo's flame's animation.
; YXPPCCCT for animating the Fishin' Boo's cloud.
; Fishin' Boo GFX routine.
; $04 = animation frame
; $02 = horizontal direction
; Main tile loop.
; Store Y position to OAM.
; Store tile number to OAM.
; Store YXPPCCCT to OAM.
; Store X position to OAM.
; Loop for all tiles.
; Animate the Fishin' Boo's cloud by X/Y flipping it.
; Upload 10 16x16 tiles.
; Falling Spike misc RAM:
; $C2   - Phase pointer. 0 = waiting, 1 = shaking/falling.
; $1540 - Timer for shaking before falling.
; Falling Spike MAIN
; Draw a 16x16.
; Tile to use for the falling spike.
; Graphically shift the sprite up one pixel.
; If about to fall, make the spike shake from side to side.
; Clear Y speed and return if game frozen.
; Process offscreen from -$40 to +$30.
; Update X/Y position, apply gravity, and process block interaction.
; Falling Spike phase pointers.
; 0 - Waiting
; 1 - Shaking/falling
; Falling Spike phase 0 - Waiting
; Clear Y speed.
; If Mario is within 4 tiles horizontally of the sprite, get ready to fall.
; How long the spike shakes for before falling.
; Falling Spike phase 1 - Shaking/falling
; Branch if not time to fall.
; Process interaction with Mario.
; Spike is shaking before falling.
; Clear Y speed.
; X speeds for the Creating/Eating block in each direction. Last value is when stationary.
; Y speeds for the Creating/Eating block in each direction. Last value is when stationary.
; Indices to the above to use for the Eating block when it needs to make a choice between paths in two directions.
; , ---r, --l-, --lr
; d--, -d-r, -dl-, -dlr
; u---, u--r, u-l-  (remaining values are missing, hence the glitches from other path choices)
; Creating/Eating block misc RAM:
; $C2   - Unused, but set to 1 when the block is hit from below for the first time.
; $151C - Which type of block this is. 00 = creating, 10 = eating.
; $1528 - Always 0. Would cause Mario to move horizontally while on the block if non-zero.
; $1534 - (creating) Current index to the path tables.
; $1558 - Unused timer set when the block is hit from below for the first time.
; $1564 - Unsued timer set when the block is hit from below.
; $1570 - (creating) Number of tiles remaining in the path's current direction of movement.
; $157C - (creating) Current direction of movement. 0 = right, 1 = left, 2 = down, 3 = up
; $1602 - (creating) Current movement value, in the form XY, where Y is the direction and X is the total number of tiles to move along. FF indicates the end.
; Creating/Eating block MAIN
; Draw a 16x16 sprite.
; Move the sprite up one pixel (so it lines up with tiles).
; Tile to use for the Creating/Eating sprite.
; Clear X/Y flip in OAM.
; Upload one 16x16 sprite (again?).
; Get current direction of movement (if moving at all).
; Also handle the sound effects if it is actually moving.
; SFX for the creating/eating block.
; Return if game frozen.
; Store X/Y speed for the current direction.
; Update Y position.
; Update X position.
; Make solid.
; Return if the platform hasn't started yet.
; Return if not centered on a tile yet.
; Branch for the eating block (not the creating block).
; Branch if not at the end of the current movement.
; Get current movement value.
; Decides which of the two path data tables to use based on whether Mario is on the main map or submaps.
; Get length of the current movement.
; Get direction of movement.
; Not at the end of the current movement.
; Generate a used block at the current position.
; Branch if at the end of the path.
; Eating block routine.
; Erase the tile at the current position.
; Interact with blocks below/right of the sprite.
; Interact with blocks above/left of the sprite.
; Branch to erase the sprite if no blocks were found.
; Store next direction of movement.
; Erasing the eating block at the end of its path.
; Subroutine to generate a Map16 tile at the position of the sprite currently being processed. Only used by the creating/eating sprite.
; Creating block path for submaps. (Larry's Castle)
; Format is one byte per command: XY
; Y = direction (0 = right, 1 = left, 2 = down, 3 = up)
; X = number of tiles to travel
; Creating block path for the main map. (Roy's Castle)
; Same format as above.
; Wooden spike misc RAM:
; $C2   - Sprite phase pointer. Mod 4: 0 = retracting, 1 = waiting to extend, 2 = extending, 3 = waiting to retract
; $151C - Initial direction of movement. 00 = down, 10 = up
; $1540 - Phase timer.
; Wooden Spike MAIN
; Draw GFX.
; Return if game frozen.
; Process offscreen from -$40 to +$30.
; Process interaction with Mario.
; Wooden Spike phase pointers.
; 0 - Retracting
; 1 - Waiting to extend
; 2 - Extending
; 3 - Waiting to retract
; Wooden Spike phase 2 - Extending
; Branch if done extending.
; How quickly to extend the wooden spike.
; Done extending.
; How long to wait before retracting the spike.
; Wooden Spike phase 1 - Waiting to extend
; Return if not time to extend yet.
; How long to spend extending.
; Wooden Spike phase 0 - Retracting
; Branch if done retracting.
; How quickly to retract the spike.
; Done retracting.
; How long to wait before extending the spike.
; Wooden Spike phase 3 - Waiting to retract
; Return if not time to retract.
; How long to spend retracting the spike.
; Retracting/extending the sprite: set Y speed.
; Store Y speed.
; If the spike is sprite AD in an odd X position, invert the given Y speed.
; Update Y position.
; Distances (lo) to push Mario out of the wooden spike when he's touching the side of it.
; Distances (hi) to push Mario out of the wooden spike when he's touching the side of it.
; Routine for processing interaction between the wooden spike and Mario.
; Return if not in contact with Mario.
; Branch if not within 4 pixels of the sprite.
; Hurt Mario.
; Not within 4 pixels of the sprite; touching the sides.
; Push Mario to the side of the sprite.
; Clear Mario's X speed.
; Y offsets for each tile of the wooden spike.
; Downwards-pointing
; Upwards-pointing
; Tile numbers for each tile of the wooden spike.
; Downwards-pointing
; Upwards-pointing
; YXPPCCCT for each tile of the wooden spike.
; Downwards-pointing
; Upwards-pointing
; Wooden spike GFX routine
; Get base index to the above tables for the spike.
; Tile loop.
; Get index for the current tile.
; Store X position to OAM.
; Store Y position to OAM.
; Store tile number to OAM.
; Store YXPPCCCT to OAM.
; Loop for all of the tiles.
; Upload 5 16x16 tiles.
; Rex walking speeds. First two are normal, second two are squished.
; Rex misc RAM:
; $C2   - Counter for the number of times the Rex has been bounced on. Normal (0), half-squished (1), or fully squished (2).
; $1558 - Timer for showing the Rex's fully-squished frame.
; $1570 - Frame counter for animation.
; $157C - Horizontal direction the sprite is facing.
; $15D0 - Timer set when squished to prevent being hit by a capespin/quake sprite.
; $1602 - Animation frame.
; 0/1 = walking, 2 = half-squished transision, 3/4 = half-squished walking, 5 = fully squished
; $1FE2 - Timer set when the Rex is bounced on for the first time, for briefly pausing it before it starts running in its half-squished state.
; Rex MAIN
; Draw GFX
; Return if sprites are frozen, or the Rex is dying.
; Branch if the sprite hasn't been fully squished.
; Erase the sprite once its squish timer runs out.
; Rex isn't dead from squishing.
; Process offscreen from -$40 to +$30.
; Handle animating the Rex's walk cycle.
; 0/1 for normal, 3/4 for half-squished.
; If on the ground, store X speed.
; If the Rex wasn't just bounced on, update X/Y position, apply gravity, and process block interaction.
; If the Rex hits a wall, turn it around.
; Process interaction with other sprites.
; Branch if not in contact with Mario.
; Branch if Mario has star power.
; Branch if the Rex already interacted with Mario once and needs to wait before interacting again.
; Set timer to prevent multiple interactions.
; Branch if Mario is moving upwards with a speed faster than #$10 (i.e. not able to bounce off).
; Rex was bounced on.
; Give points.
; Bounce Mario.
; Display a contact sprite.
; Branch if Mario was spinjumping or riding Yoshi.
; Increment hit counter.
; Branch if the Rex hasn't been fully squished yet.
; How long the Rex shows its fully-squished animation frame for.
; Half-squishing the Rex.
; How long the half-squished Rex pauses for.
; Change sprite clipping.
; Mario is being hurt by the Rex.
; Return no contact if Mario has invulnerability frames or is riding Yoshi (who handles interaction in his own routine).
; Make the Rex face towards Mario.
; Hurt Mario.
; Rex was killed by a spinjump / Yoshi stomp.
; Switch status to disappearing in a cloud of smoke.
; Set timer for the smoke cloud.
; Draw the spinjump stars.
; SFX for stomping the Rex.
; Rex was killed by star power.
; Kill the Rex.
; Y speed to give the Rex when killed by star power.
; Make the Rex fly away from Mario.
; Increment Mario's star power kill count.
; Give respective number of points.
; Store sound effect for the kill.
; X speeds to give the Rex when killed with star power.
; Subroutine to give points for bounce off of a Rex.
; Increase Mario's bounce counter and play an appropriate sound effect.
; Give Mario an appropriate number of points.
; X offsets for each of the Rex's animation frames.
; Walking A/B, right
; Half-smushed trasition, right
; Half-smushed walking A/B, right
; Fully-smushed, right
; Walking A/B, left
; Half-smushed trasition, left
; Half-smushed walking A/B, left
; Fully-smushed, left
; Y offsets for each of the Rex's animation frames.
; Walking A/B
; Half-smushed trasition
; Half-smushed walking A/B
; Fully-smushed
; Tile numbers for each of the Rex's animation frames.
; Walking A/B
; Half-smushed trasition
; Half-smushed walking A/B
; Fully-smushed
; YXPPCCCT for the Rex, indexed by his direction.
; Rex GFX routine
; If the Rex was smushed, use animation frame 5.
; If the Rex was just half-smushed, use animation frame 2.
; $03 = animation frame x2
; $02 = horizontal direction
; Store X position to OAM.
; Store Y position to OAM.
; Store tile number to OAM.
; Store YXPPCCCT to OAM.
; Store tile size to OAM; normally 16x16, except when fully-squished.
; Loop for the second tile.
; Upload 2 manually-sized tiles.
; Fishbone misc RAM:
; $C2   - Phase pointer. 0 = boosting, 1 = decelerating.
; $1540 - Phase timer.
; $1558 - Timer for the Fishbone's blink animation. Randomly has a chance of being set every 128 frames.
; $1570 - Frame counter for animation.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame. 0/1 = swimming
; Fishbone MAIN
; Draw GFX.
; Return if game frozen.
; Process offscreen from -$40 to +$30.
; Process interaction with Mario.
; Update X position.
; Every 128 frames, randomly decide whether to boost the fishbone or not.
; Fishbone phase pointers.
; 0 - Boosting
; 1 - Decelerating
; Max X speeds for the Fishbone.
; X accelerations for the Fishbone.
; Fishbone phase 0 - Boosting
; Handle swimming animation.
; Branch if done boosting.
; Return if not a frame to accelerate the Fishbone.
; Horizontally accelerate the Fishbone, if not already at the max speed.
; Done boosting.
; Increment phase pointer.
; How long the Fishbone decelerates for before boosting again.
; Fishbone phase 1 - Decelerating
; Branch if time to boost again.
; Branch if not a frame to decelerate.
; Slow the Fishbone down.
; Time to boost again.
; Clear phase pointer.
; How long the Fishbone boosts for.
; X offsets for the Fishbone's tail, indexed by its direction.
; Right
; Left
; Y offsets for the Fishbone's tail.
; YXPPCCCT for the Fishbone's tail, indexed by its direction.
; Right
; Left
; Tile numbers for the Fishbone's tail, indexed by its animation frame.
; Fishbone GFX routine
; Draw a 16x16 (for the fishbone's head).
; Change tile number in OAM.
; Tile to use for the Fishbone's head normally.
; Tile to use for the Fishbone's head when blinking.
; $02 = horizontal direction x2
; $03 = animation frame x2
; Tile loop for the Fishbone's tail tiles.
; Store Y position to OAM.
; Store X position to OAM.
; Store YXPPCCCT to OAM.
; Store tile number to OAM.
; Loop for both tiles.
; Draw 2 8x8 tiles.
; Aiming routine for Reznor's fireballs.
; Input: A = desired magnitude of the final speed vector, X = sprite slot to aim from.
; Output: $00 = X speed, $01 = Y speed
; Set $0C to the absolute vertical distance from Mario.
; Appears to be have a coding error on Nintendo's part;
; SubVertPosBnk3 uses $0F, not $0E like the normal SubVertPos routine.
; Set $0D to the absolute horizontal distance from Mario.
; If further away horizontally than vertically, swap $0C/$0D
; (so that the shorter distance is in $0C).
; $00 = ($0C * $01) / $0D
; $0B = ($0C * $01) % $0D
; Essentially, this does a ratio of the vertical and horizontal distances,
; then scales the base speed using that ratio.
; If $0C/$0D were swapped before,
; swap $00/$01.
; Invert $00 if Mario is to the left.
; Invert $01 if Mario is to the right.
; Reznor INIT
; Branch if not the "base" Reznor sprite.
; Store Mode 7 index.
; Load palette/GFX files.
; Store a random value to Reznor's initial fireball timer.
; Initial angular positions for each Reznor, low
; Initial angular positions for each Reznor, high
; X speeds to give Mario when he runs into the side of Reznor's platform.
; Reznor misc RAM:
; $C2   - Set to #$04 for the "base" Reznor in slot 7, to indicate which Mode 7 room needs to be loaded.
; Also (unintentially) set to 1 for the other Reznors if their platform is hit after the Reznor has already been killed.
; $151C - Flag for whether this Reznor has been killed.
; $1528 - Number of pixels moved horizontally during the frame, for moving Mario with the Reznor's platform if he's on top of it.
; $1558 - Timer for Reznor's firing animation. Set to #$40 when shooting.
; Also set after the Reznor is killed when hitting the platform for the first time, although this is unused.
; $1564 - Timer set whenever Reznor's platform is hit from below, for the platform's bounce animation.
; $1570 - Frame counter to determine when Reznor should shoot a fireball. Sets to a random initial number; a fireball is shot when it hits 0.
; $157C - Horizontal direction the sprite is facing. 00 = right, 01 = left
; $15AC - Timer for turning.
; $1602 - Animation frame.
; 0 = normal, 1 = shooting, 2 = turning
; $163E - Timer for waiting before ending the level after all Reznors are dead.
; Reznor MAIN
; Set flag to send smoke sprites to a different VRAM address.
; If game frozen, skip Mario interaction and position updating.
; If not the base Reznor, skip down.
; Handle collapsing the bridge if time to.
; X position of the center of rotation for Reznor's wheel.
; X position of Reznor's wheel.
; Y position of Reznor's wheel.
; Attach the wheel to Reznor's position.
; Speed that Reznor's wheel rotates with.
; How many frames until the wheel resets its rotation.
; Useless? Since this was already checked earlier.
; Branch if Reznor hasn't been defeated.
; Branch further if Reznor has been defeated, but not time to end the level yet.
; Set end level timer.
; SFX/music played after defeating Reznor.
; Not ending the level yet.
; Branch if all four Reznors haven't been defeated yet.
; Set timer to wait before actually ending the level.
; Make any other sprites disappear in a puff of smoke.
; Erase all of Reznor's fireballs.
; Non-base Reznors join back in here.
; If not alive, skip Mario interaction and position updating.
; Calculate Reznor's position on the wheel.
; Get Reznor's base angular position.
; Rotate Reznor counter-clockwise.
; Get the sin value.
; Get the cos value.
; X-radius of Reznor's rotation.
; Calculate Reznor's current X offset on the wheel.
; Y-radius of Reznor's rotation.
; Calculate Reznor's current Y offset on the wheel.
; Update X position.
; Track number of pixels the platform has moved horizontally.
; Update Y position.
; Branch if this Reznor hasn't been killed.
; Make the Reznor's platform solid after he dies.
; Branch down to continue code.
; Reznor is still alive; this handles the actual Reznor.
; Don't shoot fire if Reznor is turning.
; (with a useless AND)
; Only shoot fire every 256 frames.
; (useless)
; How long Reznor spends with his mouth open. Fireball shoots when this decrements to #$20.
; Check whether to allow Reznor to turn and branch if not.
; (conditions for not: not a frame to check, currently shooting a fireball, already turning)
; Check whether Reznor is facing Mario and, if he's not, change his direction.
; How long Reznor takes to turn around.
; Skip Mario interaction routine if dying or not touching Mario.
; Check where Mario has touched Reznor.
; If touching the actual Reznor, branch to hurt Mario.
; If touching the side of the platform, branch to stop Mario.
; If touching the bottom of the platform, continue below to kill the Reznor.
; Hit the bottom of the platform.
; Change interaction hitbox.
; Set timer for the platform's bounce animation (and for killing the Reznor).
; Set Y speed for Mario.
; SFX for kitting the bottom of Reznor's platform.
; Branch down to continue code.
; Hit the side of the platform.
    LDA.W ReboundSpeedX,Y                     ; | (hit side of platform?); Push Mario back.
    STA.B PlayerXSpeed+1                      ; |
    BRA DrawReznor                            ; /; Branch down to continue code.

HitReznor:
; Hit the actual Reznor.
    JSL HurtMario                             ; Hurt Mario; Hurt Mario.
DrawReznor:
    STZ.W SpriteMisc1602,X                    ; Set normal image; All Reznor routines rejoin here.
    LDA.W SpriteMisc157C,X
    PHA
    LDY.W SpriteMisc15AC,X
    BEQ ReznorNoTurning
    CPY.B #$05                                ; Handle Reznor's turning animation.
    BCC +
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + LDA.B #$02                                ; \ Set turning image
    STA.W SpriteMisc1602,X                    ; /
ReznorNoTurning:
    LDA.W SpriteMisc1558,X                    ; \ Shoot fire if "time to show firing image" == 20
    BEQ ReznorNoFiring                        ; |
    CMP.B #$20                                ; | (shows image for 20 frames after the fireball is shot)
    BNE +                                     ; |; If time to shoot a fireball, spawn one.
    JSR ReznorFireRt                          ; /; Then show an animation frame for firing for a brief period afterwards.
  + LDA.B #$01                                ; \ Set firing image
    STA.W SpriteMisc1602,X                    ; /
ReznorNoFiring:
    JSR ReznorGfxRt                           ; Draw Reznor; Draw GFX.
    PLA
    STA.W SpriteMisc157C,X
    LDA.B SpriteLock                          ; \ If sprites locked, or mario already killed the Reznor on the platform, return
    ORA.W SpriteMisc151C,X                    ; |; Return if:
    BNE +                                     ; /; Game frozen
    LDA.W SpriteMisc1564,X                    ; \ If time to bounce platform != 0C, return; Reznor is already dead
    CMP.B #$0C                                ; | (causes delay between start of boucing platform and killing Reznor); Reznor's platform hasn't been hit
    BNE +                                     ; /
    LDA.B #!SFX_KICK                          ; \; SFX for a Reznor being killed.
    STA.W SPCIO0                              ; / Play sound effect
    STZ.W SpriteMisc1558,X                    ; Prevent from throwing fire after death; Clear Reznor's fireball-shooting timer.
    INC.W SpriteMisc151C,X                    ; Record a hit on Reznor; Set flag for the Reznor having been killed.
    JSL FindFreeSprSlot                       ; \ Load Y with a free sprite index for dead Reznor; Return if there's no empty sprite slot to spawn the dead Reznor in.
    BMI +                                     ; / Return if no free index
    LDA.B #$02                                ; \ Set status to being killed
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$A9                                ; \ Sprite to use for dead Reznor; Sprite Reznor turns into after being hit (another Reznor).
    STA.W SpriteNumber,Y                      ; /
    LDA.B SpriteXPosLow,X                     ; \ Transfer x position to dead Reznor
    STA.W SpriteXPosLow,Y                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    STA.W SpriteXPosHigh,Y                    ; /; Spawn at the Reznor's current position.
    LDA.B SpriteYPosLow,X                     ; \ Transfer y position to dead Reznor
    STA.W SpriteYPosLow,Y                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    STA.W SpriteYPosHigh,Y                    ; /
    PHX                                       ; \
    TYX                                       ; | Before: X must have index of sprite being generated
    JSL InitSpriteTables                      ; /  Routine clears all old sprite values and loads in new values for the 6 main sprite tables
    LDA.B #$C0                                ; \ Set y speed for Reznor's bounce off the platform; Y speed the Reznor bounces with when knocked off his platform.
    STA.B SpriteYSpeed,X                      ; /
    PLX                                       ; pull, X = sprite index
  + RTS

ReznorFireRt:
    LDY.B #$07                                ; \ find a free extended sprite slot, return if all full; Subroutine to shoot Reznor's fireball.
CODE_039AFA:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ FoundRznrFireSlot                     ; |; Find an empty extended sprite slot, and return if none found.
    DEY                                       ; |
    BPL CODE_039AFA                           ; |
    RTS                                       ; / Return if no free slots

FoundRznrFireSlot:
    LDA.B #!SFX_MAGIC                         ; \; SFX for Reznor's fireball being shot.
    STA.W SPCIO0                              ; / Play sound effect
    LDA.B #$02                                ; \ Extended sprite = Reznor fireball; Set the extended sprite number.
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X
    PHA
    SEC
    SBC.B #$08
    STA.W ExtSpriteXPosLow,Y                  ; Set X position.
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    SBC.B #$00
    STA.W ExtSpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    PHA
    SEC
    SBC.B #$14
    STA.B SpriteYPosLow,X                     ; Set Y position.
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W ExtSpriteYPosHigh,Y
    STA.W SpriteYPosHigh,X
    LDA.B #$10
    JSR CODE_0397F9
    PLA
    STA.W SpriteYPosHigh,X
    PLA                                       ; Set X/Y speed.
    STA.B SpriteYPosLow,X                     ; Aim for Mario (or at least fail in trying).
    PLA
    STA.B SpriteXPosLow,X
    LDA.B _0
    STA.W ExtSpriteYSpeed,Y
    LDA.B _1
    STA.W ExtSpriteXSpeed,Y
    RTS


ReznorTileDispX:
    db $00,$F0,$00,$F0,$F0,$00,$F0,$00
ReznorTileDispY:
    db $E0,$E0,$F0,$F0

ReznorTiles:
    db $40,$42,$60,$62,$44,$46,$64,$66
    db $28,$28,$48,$48

ReznorPal:
    db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F
    db $7F,$3F,$7F,$3F

ReznorGfxRt:
; X offsets for Reznor, indexed by his direction.
; Right
; Left
; Y offsets for Reznor.
; Tile numbers for Reznor.
; Normal
; Shooting
; Turning
; YXPPCCCT for Reznor.
; Normal
; Shooting
; Turning
; Reznor GFX routine
    LDA.W SpriteMisc151C,X                    ; \ if the reznor is dead, only draw the platform; Branch to just draw the platform if Reznor is dead.
    BNE DrawReznorPlats                       ; /
    JSR GetDrawInfoBnk3                       ; after: Y = index to sprite tile map, $00 = sprite x, $01 = sprite y
    LDA.W SpriteMisc1602,X                    ; \ $03 = index to frame start (frame to show * 4 tiles per frame)
    ASL A                                     ; |; $03 = animation frame, x4
    ASL A                                     ; |
    STA.B _3                                  ; /
    LDA.W SpriteMisc157C,X                    ; \ $02 = direction index
    ASL A                                     ; |; $02 = horizontal direction, x4
    ASL A                                     ; |
    STA.B _2                                  ; /
    PHX
    LDX.B #$03
RznrGfxLoopStart:
    PHX                                       ; Tile loop.
    LDA.B _3
    CMP.B #$08
    BCS +
    TXA
    ORA.B _2
    TAX                                       ; Store X position to OAM.
  + LDA.B _0
    CLC
    ADC.W ReznorTileDispX,X
    STA.W OAMTileXPos+$100,Y
    PLX
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W ReznorTileDispY,X
    STA.W OAMTileYPos+$100,Y
    PHX
    TXA
    ORA.B _3                                  ; Store tile number to OAM.
    TAX
    LDA.W ReznorTiles,X                       ; \ set tile
    STA.W OAMTileNo+$100,Y                    ; /
    LDA.W ReznorPal,X                         ; \ set palette/properties
    CPX.B #$08                                ; | if turning, don't flip
    BCS +                                     ; |
    LDX.B _2                                  ; | if direction = 0, don't flip; Store YXPPCCCT to OAM.
    BNE +                                     ; |
    EOR.B #$40                                ; |
  + STA.W OAMTileAttr+$100,Y                  ; /
    PLX                                       ; \ pull, X = current tile of the frame we're drawing
    INY                                       ; | Increase index to sprite tile map ($300)...
    INY                                       ; |    ...we wrote 4 bytes...
    INY                                       ; |    ...so increment 4 times; Loop for all tiles.
    INY                                       ; |
    DEX                                       ; | Go to next tile of frame and loop
    BPL RznrGfxLoopStart                      ; /
    PLX                                       ; \
    LDY.B #$02                                ; | Y = 02 (All 16x16 tiles)
    LDA.B #$03                                ; | A = number of tiles drawn - 1; Upload 4 16x16 tiles.
    JSL FinishOAMWrite                        ; / Don't draw if offscreen
    LDA.W SpriteStatus,X
    CMP.B #$02                                ; Return if this is a dead Reznor (platform not included).
    BEQ +
DrawReznorPlats:
    JSR ReznorPlatGfxRt                       ; Draw Reznor's platform.
  + RTS


ReznorPlatDispY:
    db $00,$03,$04,$05,$05,$04,$03,$00

ReznorPlatGfxRt:
; Y offsets for the bounce animation of Reznor's platform.
    LDA.W SpriteOAMIndex,X                    ; Reznor's platform GFX routine
    CLC
    ADC.B #$10
    STA.W SpriteOAMIndex,X
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc1564,X
    LSR A
    PHY                                       ; $02 = Y offset for the platform's bounce animation when hit.
    TAY
    LDA.W ReznorPlatDispY,Y
    STA.B _2
    PLY
    LDA.B _0
    STA.W OAMTileXPos+$104,Y
    SEC                                       ; Store X positions to OAM.
    SBC.B #$10
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    SEC
    SBC.B _2                                  ; Store Y positions to OAM.
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    LDA.B #$4E                                ; \ Tile of reznor platform...; Tile number to use for Reznor's platform.
    STA.W OAMTileNo+$100,Y                    ; | ...store left side
    STA.W OAMTileNo+$104,Y                    ; /  ...store right side
    LDA.B #$33                                ; \ Palette of reznor platform...; YXPPCCCT for Reznor's platforms.
    STA.W OAMTileAttr+$100,Y                  ; |
    ORA.B #$40                                ; | ...flip right side
    STA.W OAMTileAttr+$104,Y                  ; /
    LDY.B #$02                                ; \
    LDA.B #$01                                ; | A = number of tiles drawn - 1; Upload 2 16x16 tiles.
    JSL FinishOAMWrite                        ; / Don't draw if offscreen
    RTS

InvisBlk_DinosMain:
; Dino Rhino/Torch misc RAM:
; $C2   - Pointers to different routines. Fire is unused in the Rhino.
; 0 = walking, 1 = fire horz, 2 = fire vert, 3 = jumping
; $151C - Length of the Dino Torch's flame (0 = max, 4 = none). Also set for the Rhino at spawn, but otherwise unused.
; $1540 - Timer to wait before starting/stopping a flame. Rhino sets on spawn but doesn't use.
; $1570 - Frame counter for animation.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame.
; 0/1 = walking, 2 = fire sideways, 3 = fire up
    LDA.B SpriteNumber,X                      ; \ Branch if sprite isn't "Invisible solid block"; Invisible solid block MAIN / Dino Rhino MAIN / Dino Torch MAIN
    CMP.B #$6D                                ; |; Just make solid if sprite 6D (invisible block)
    BNE +                                     ; /; Honestly though, why is this here?
    JSL InvisBlkMainRt                        ; \ Call "Invisible solid block" routine
    RTL

  + PHB
    PHK
    PLB
    JSR DinoMainSubRt
    PLB
    RTL

DinoMainSubRt:
    JSR DinoGfxRt                             ; Draw graphics.
    LDA.B SpriteLock
    BNE Return039CA3
    LDA.W SpriteStatus,X                      ; Return if game frozen or sprite dead.
    CMP.B #$08
    BNE Return039CA3
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    JSL MarioSprInteract                      ; Process interaction with Mario.
; Update X/Y position, apply gravity, and process block interaction.
    JSL UpdateSpritePos                       ; Dino Rhino/Torch state pointers.
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_039CA8
    dw CODE_039D41
    dw CODE_039D41
    dw CODE_039C74

DATA_039C6E:
    db $00,$FE,$02

DATA_039C71:
    db $00,$FF,$00

CODE_039C74:
; 0 - Walking
; 1 - Horizontal fire
; 2 - Vertical fire
; 3 - Jumping
; Low X position shifts to push the Dino Rhino/Torch out of walls.
; High X position shifts to push the Dino Rhino/Torch out of walls.
    LDA.B SpriteYSpeed,X                      ; Dino Rhino/Torch rhino 3 - Jumping
    BMI CODE_039C89
    STZ.B SpriteTableC2,X
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object; Return to state 0 if it starts falling,
    AND.B #$03                                ; |; and invert direction if it's hitting a wall at that time.
    BEQ CODE_039C89                           ; /
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
CODE_039C89:
    STZ.W SpriteMisc1602,X
    LDA.W SpriteBlockedDirs,X
    AND.B #$03
    TAY
    LDA.B SpriteXPosLow,X
    CLC                                       ; Push back from walls.
    ADC.W DATA_039C6E,Y
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_039C71,Y
    STA.W SpriteXPosHigh,X
Return039CA3:
    RTS                                       ; X speeds for the Dino Rhino and Dino Torch.


DinoSpeed:
    db $08,$F8,$10,$F0

CODE_039CA8:
; Rhino
; Torch
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground; Dino Rhino/Torch phase 0 - Walking
    AND.B #$04                                ; |; If not on the ground, push the Rhino back from walls and return.
    BEQ CODE_039C89                           ; /
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B SpriteNumber,X
    CMP.B #$6E
    BEQ +                                     ; If the Dino Torch's timer hits 0, spit fire in a random direction.
    LDA.B #$FF                                ; \ Set fire breathing timer
    STA.W SpriteMisc1540,X                    ; /
    JSL GetRand
    AND.B #$01
    INC A
    STA.B SpriteTableC2,X
  + TXA
    ASL A
    ASL A
    ASL A
    ASL A
    ADC.B EffFrame                            ; Turn towards Mario every 64 frames. (when on the ground)
    AND.B #$3F
    BNE +
    JSR SubHorzPosBnk3                        ; \ If not facing mario, change directions
    TYA                                       ; |
    STA.W SpriteMisc157C,X                    ; /
  + LDA.B #$10                                ; Set ground Y speed.
    STA.B SpriteYSpeed,X
    LDY.W SpriteMisc157C,X                    ; \ Set x speed for rhino based on direction and sprite number
    LDA.B SpriteNumber,X                      ; |
    CMP.B #$6E                                ; |
    BEQ +                                     ; |
    INY                                       ; |; Set X speed.
    INY                                       ; |
  + LDA.W DinoSpeed,Y                         ; |
    STA.B SpriteXSpeed,X                      ; /
    JSR DinoSetGfxFrame                       ; Animate the Dino Rhino/Torch's walking.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |; If it runs into a block, jump.
    BEQ +                                     ; /
    LDA.B #$C0                                ; Jump speed.
    STA.B SpriteYSpeed,X
    LDA.B #$03
    STA.B SpriteTableC2,X
  + RTS


DinoFlameTable:
    db $41,$42,$42,$32,$22,$12,$02,$02
    db $02,$02,$02,$02,$02,$02,$02,$02
    db $02,$02,$02,$02,$02,$02,$02,$12
    db $22,$32,$42,$42,$42,$42,$41,$41
    db $41,$43,$43,$33,$23,$13,$03,$03
    db $03,$03,$03,$03,$03,$03,$03,$03
    db $03,$03,$03,$03,$03,$03,$03,$13
    db $23,$33,$43,$43,$43,$43,$41,$41

CODE_039D41:
; Animation data for the Dino Torch's fire. In the format XY: Y = animation frame for the Dino, X = 4 - length of the flame
; Horizontal
; Vertical
; Dino Rhino/Torch phase 1/2- Horizontal/Vertical fire
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0; Clear X speed.
    LDA.W SpriteMisc1540,X
    BNE +                                     ; If done shooting fire, return to phase 0.
    STZ.B SpriteTableC2,X
    LDA.B #$40
    STA.W SpriteMisc1540,X
    LDA.B #$00
  + CMP.B #$C0                                ; Branch if not time to play the fire sound.
    BNE +
    LDY.B #!SFX_FIRESPIT                      ; \ Play sound effect; SFX for the Dino Torch shooting fire.
    STY.W SPCIO3                              ; /
  + LSR A
    LSR A
    LSR A
    LDY.B SpriteTableC2,X
    CPY.B #$02
    BNE +
    CLC                                       ; Get current frame of animation for the Dino Rhino.
    ADC.B #$20
  + TAY
    LDA.W DinoFlameTable,Y
    PHA
    AND.B #$0F
    STA.W SpriteMisc1602,X
    PLA
    LSR A
    LSR A
    LSR A                                     ; Get height of the flame, and return if not at full length.
    LSR A
    STA.W SpriteMisc151C,X
    BNE +
    LDA.B SpriteNumber,X
    CMP.B #$6E
    BEQ +
    TXA
    EOR.B TrueFrame                           ; Return if:
    AND.B #$03                                ; Sprite is not the Dino Torch.
    BNE +                                     ; Not a frame to process interaction with Mario.
    JSR DinoFlameClipping                     ; The flame is not in contact with Mario.
    JSL GetMarioClipping                      ; Mario has invulnerability frames.
    JSL CheckForContact
    BCC +
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario has star
    BNE +                                     ; /
    JSL HurtMario                             ; Hurt Mario.
  + RTS


DinoFlame1:
    db $DC,$02,$10,$02

DinoFlame2:
    db $FF,$00,$00,$00

DinoFlame3:
    db $24,$0C,$24,$0C

DinoFlame4:
    db $02,$DC,$02,$DC

DinoFlame5:
    db $00,$FF,$00,$FF

DinoFlame6:
    db $0C,$24,$0C,$24

DinoFlameClipping:
    LDA.W SpriteMisc1602,X                    ; Subroutine to get clipping data for the Dino Torch's flame.
    SEC
    SBC.B #$02
    TAY                                       ; Get index to the above tables for the flame.
    LDA.W SpriteMisc157C,X
    BNE +
    INY
    INY
  + LDA.B SpriteXPosLow,X
    CLC
    ADC.W DinoFlame1,Y
    STA.B _4                                  ; Get clipping X position.
    LDA.W SpriteXPosHigh,X
    ADC.W DinoFlame2,Y
    STA.B _A
    LDA.W DinoFlame3,Y                        ; Get clipping width.
    STA.B _6
    LDA.B SpriteYPosLow,X
    CLC
    ADC.W DinoFlame4,Y
    STA.B _5                                  ; Get clipping Y position.
    LDA.W SpriteYPosHigh,X
    ADC.W DinoFlame5,Y
    STA.B _B
    LDA.W DinoFlame6,Y                        ; Get clipping height.
    STA.B _7
    RTS

DinoSetGfxFrame:
    INC.W SpriteMisc1570,X                    ; Subroutine to handle animating the Dino Rhino / Torch's walk cycle.
    LDA.W SpriteMisc1570,X
    AND.B #$08
    LSR A                                     ; Set animation frame (0/1).
    LSR A
    LSR A
    STA.W SpriteMisc1602,X
    RTS


DinoTorchTileDispX:
    db $D8,$E0,$EC,$F8,$00,$FF,$FF,$FF
    db $FF,$00

DinoTorchTileDispY:
    db $00,$00,$00,$00,$00,$D8,$E0,$EC
    db $F8,$00

DinoFlameTiles:
    db $80,$82,$84,$86,$00,$88,$8A,$8C
    db $8E,$00

DinoTorchGfxProp:
    db $09,$05,$05,$05,$0F

DinoTorchTiles:
    db $EA,$AA,$C4,$C6

DinoRhinoTileDispX:
    db $F8,$08,$F8,$08,$08,$F8,$08,$F8
DinoRhinoGfxProp:
    db $2F,$2F,$2F,$2F,$6F,$6F,$6F,$6F
DinoRhinoTileDispY:
    db $F0,$F0,$00,$00

DinoRhinoTiles:
    db $C0,$C2,$E4,$E6,$C0,$C2,$E0,$E2
    db $C8,$CA,$E8,$E2,$CC,$CE,$EC,$EE

DinoGfxRt:
; X offsets for the Dino Torch and its flame. Fifth byte corresponds to the actual Dino.
; Normal
; Jumping
; Y offsets for the Dino Torch and its flame. Fifth byte corresponds to the actual Dino.
; Tile numbers for the Dino Torch's flame. Fifth byte of each row unused.
; YXPPCCCT for the Dino Torch and its flame. Fifth byte corresponds to the actual Dino.
; Tile numbers for the Dino Torch.
; X offsets for the Dino Rhino.
; YXPPCCCT for the Dino Rhino.
; Y offsets for the Dino Rhino.
; Tile numbers for the Dino Rhino.
    JSR GetDrawInfoBnk3                       ; Dino Rhino/Torch GFX routine
    LDA.W SpriteMisc157C,X                    ; $02 = horizontal direction
    STA.B _2
    LDA.W SpriteMisc1602,X                    ; $04 = animation frame
    STA.B _4
    LDA.B SpriteNumber,X
    CMP.B #$6F                                ; Branch for the Dino Torch.
    BEQ CODE_039EA9
    PHX
    LDX.B #$03
CODE_039E5F:
    STX.B _F                                  ; Dino Rhino tile loop.
    LDA.B _2
    CMP.B #$01
    BCS +
    TXA
    CLC                                       ; Store YXPPCCCT to OAM.
    ADC.B #$04
    TAX
  + %LorW_X(LDA,DinoRhinoGfxProp)
    STA.W OAMTileAttr+$100,Y
    %LorW_X(LDA,DinoRhinoTileDispX)
    CLC                                       ; Store X position to OAM.
    ADC.B _0
    STA.W OAMTileXPos+$100,Y
    LDA.B _4
    CMP.B #$01
    LDX.B _F                                  ; Store Y position to OAM.
    %LorW_X(LDA,DinoRhinoTileDispY)
    ADC.B _1                                  ; Make the Dino Rhino shift up and down with the walk animation as well.
    STA.W OAMTileYPos+$100,Y
    LDA.B _4
    ASL A
    ASL A
    ADC.B _F                                  ; Store tile number to OAM.
    TAX
    %LorW_X(LDA,DinoRhinoTiles)
    STA.W OAMTileNo+$100,Y
    INY
    INY
    INY
    INY                                       ; Loop for all tiles.
    LDX.B _F
    DEX
    BPL CODE_039E5F
    PLX
    LDA.B #$03
    LDY.B #$02                                ; Upload 4 16x16 tiles.
    JSL FinishOAMWrite
    RTS

CODE_039EA9:
; Dino Torch GFX routine.
    LDA.W SpriteMisc151C,X                    ; $03 = length of the torch's flame (4 = none, 0 = max)
    STA.B _3
    LDA.W SpriteMisc1602,X                    ; $04 = animation frame (this was already set though, so useless).
    STA.B _4
    PHX
    LDA.B EffFrame
    AND.B #$02
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A                                     ; $05 = animation frame for the flame
    LDX.B _4
    CPX.B #$03
    BEQ +
    ASL A
  + STA.B _5
    LDX.B #$04
CODE_039EC8:
    STX.B _6                                  ; Dino Torch tile loop
    LDA.B _4
    CMP.B #$03
    BNE +
    TXA
    CLC
    ADC.B #$05
    TAX
  + PHX                                       ; Store X position to OAM.
    LDA.W DinoTorchTileDispX,X                ; Invert offset if facing right.
    LDX.B _2
    BNE +
    EOR.B #$FF
    INC A
  + PLX
    CLC
    ADC.B _0
    STA.W OAMTileXPos+$100,Y
    LDA.W DinoTorchTileDispY,X
    CLC                                       ; Store Y position to OAM.
    ADC.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.B _6
    CMP.B #$04
    BNE CODE_039EFD
    LDX.B _4
    LDA.W DinoTorchTiles,X                    ; Store tile number to OAM.
    BRA +

CODE_039EFD:
    LDA.W DinoFlameTiles,X
  + STA.W OAMTileNo+$100,Y
    LDA.B #$00
    LDX.B _2
    BNE +
    ORA.B #$40
  + LDX.B _6
    CPX.B #$04                                ; Store YXPPCCCT to OAM.
    BEQ +
    EOR.B _5
  + ORA.W DinoTorchGfxProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY                                       ; Loop for all tiles.
    DEX
    CPX.B _3
    BPL CODE_039EC8
    PLX
    LDY.W SpriteMisc151C,X
    LDA.W DinoTilesWritten,Y                  ; Upload some number of 16x16 tiles.
    LDY.B #$02
    JSL FinishOAMWrite
    RTS


DinoTilesWritten:
    db $04,$03,$02,$01,$00

    RTS                                       ; How many tiles (-1) to upload to OAM for the Dino Torch, indexed by the length its flame.

Blargg:
; Blargg misc RAM:
; $C2   - Sprite phase.
; 0 = Hiding under the lava, 1 = Eye rises out, 2 = Eye staring, 3 = Eye descending, 4 = Attacking
; $151C - Spawn X position (hi)
; $1528 - Spawn X position (lo)
; $1534 - Spawn Y position (hi)
; $1540 - Phase timer.
; $157C - Horizontal direction the sprite is facing.
; $1594 - Spawn Y position (lo)
; $1602 - Animation frame for the Blargg when fully emerged. 0 = mouth closed, 1 = mouth open
; Blargg MAIN
    JSR CODE_03A062                           ; Draw GFX
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE +
    JSL MarioSprInteract                      ; Process interaction with Mario.
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_039F57
    dw CODE_039F8B
    dw CODE_039FA4
    dw CODE_039FC8
    dw CODE_039FEF

; Blargg phase pointers.
; 0 - Hiding under the lava
; 1 - Eye rises out
; 2 - Eye staring
; 3 - Eye descending
  + RTS                                       ; 4 - Attacking

CODE_039F57:
    LDA.W SpriteOffscreenX,X                  ; Blargg phase 0 - Hiding under the lava.
    ORA.W SpriteMisc1540,X                    ; Return if offscreen or not time to poke its eye out.
    BNE +
    JSR SubHorzPosBnk3
    LDA.B _F
    CLC                                       ; Return if Mario isn't within 7 tiles of the sprite.
    ADC.B #$70
    CMP.B #$E0
    BCS +
    LDA.B #$E3                                ; Y speed to give the Blargg's eye when rising up.
    STA.B SpriteYSpeed,X
    LDA.W SpriteXPosHigh,X
    STA.W SpriteMisc151C,X
    LDA.B SpriteXPosLow,X
    STA.W SpriteMisc1528,X                    ; Preserve the Blargg's spawn position.
    LDA.W SpriteYPosHigh,X
    STA.W SpriteMisc1534,X
    LDA.B SpriteYPosLow,X
    STA.W SpriteMisc1594,X
    JSR CODE_039FC0                           ; Turn to face Mario/
    INC.B SpriteTableC2,X                     ; Increase phase pointer to phase 1.
  + RTS

CODE_039F8B:
    LDA.B SpriteYSpeed,X                      ; Blargg phase 1 - Eye rising up
    CMP.B #$10                                ; Branch if not done rising up.
    BMI +
    LDA.B #$50                                ; How long the Blargg stares out of the lava before ducking back down.
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X                     ; Increase phase pointer to phase 2.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; Clear Y speed.
    RTS

; Eye isn't done rising.
  + JSL UpdateYPosNoGvtyW                     ; Update Y position.
    INC.B SpriteYSpeed,X                      ; Decrease Y speed.
    INC.B SpriteYSpeed,X
    RTS

CODE_039FA4:
; Blargg phase 2 - Eye is staring
    LDA.W SpriteMisc1540,X                    ; Branch if not done staring.
    BNE +
    INC.B SpriteTableC2,X                     ; Increase phase pointer to phase 3.
    LDA.B #$0A                                ; How long the Blargg's eye spends lowering back into the lava.
    STA.W SpriteMisc1540,X
    RTS

; Not time to sink back down.
  + CMP.B #$20                                ; Once the timer starts going low enough, lock on to Mario.
    BCC CODE_039FC0
    AND.B #$1F
    BNE Return039FC7
    LDA.W SpriteMisc157C,X                    ; Make the Blargg look from side to side.
    EOR.B #$01
    BRA +

CODE_039FC0:
    JSR SubHorzPosBnk3                        ; Turn the Blargg to face Mario.
    TYA
  + STA.W SpriteMisc157C,X
Return039FC7:
    RTS

CODE_039FC8:
; Blargg phase 3 - Eye is descending back into the lava
    LDA.W SpriteMisc1540,X                    ; Branch if time to attack.
    BEQ +
    LDA.B #$20                                ; Y speed the eye descends with.
    STA.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW                     ; Update Y position.
    RTS

; Time to attack.
  + LDA.B #$20                                ; How long the Blargg waits under the lava before actually attacking.
    STA.W SpriteMisc1540,X
    LDY.W SpriteMisc157C,X
    LDA.W DATA_039FED,Y                       ; Set attack X speed.
    STA.B SpriteXSpeed,X
    LDA.B #$E2                                ; Initial Y speed of the Blargg's attack.
    STA.B SpriteYSpeed,X
    JSR CODE_03A045                           ; Create a lava splash.
    INC.B SpriteTableC2,X                     ; Increment phase pointer to phase 4.
    RTS


DATA_039FED:
    db $10,$F0

CODE_039FEF:
    STZ.W SpriteMisc1602,X                    ; Blargg phase 4 - Attacking
    LDA.W SpriteMisc1540,X                    ; Branch if already attacking.
    BEQ CODE_03A002
    DEC A                                     ; Skip down and return if not time to attack yet (i.e. waiting under the lava)
    BNE CODE_03A038
    LDA.B #!SFX_BLARGG                        ; \ Play sound effect; SFX for the Blargg attacking.
    STA.W SPCIO0                              ; /
    JSR CODE_03A045                           ; Create a lava splash.
CODE_03A002:
    JSL UpdateXPosNoGvtyW                     ; Update X position.
    JSL UpdateYPosNoGvtyW                     ; Update Y position.
    LDA.B TrueFrame
    AND.B #$00                                ; Apply gravity.
    BNE +
    INC.B SpriteYSpeed,X
  + LDA.B SpriteYSpeed,X
    CMP.B #$20                                ; Branch if not done attacking.
    BMI CODE_03A038
    JSR CODE_03A045                           ; Creating yet another lava splash.
    STZ.B SpriteTableC2,X                     ; Return phase pointer to phase 0.
    LDA.W SpriteMisc151C,X
    STA.W SpriteXPosHigh,X
    LDA.W SpriteMisc1528,X
    STA.B SpriteXPosLow,X                     ; Restore original spawn position.
    LDA.W SpriteMisc1534,X
    STA.W SpriteYPosHigh,X
    LDA.W SpriteMisc1594,X
    STA.B SpriteYPosLow,X
    LDA.B #$40                                ; How long the Blargg waits under the lava after attacking before poking its eye out again.
    STA.W SpriteMisc1540,X
CODE_03A038:
    LDA.B SpriteYSpeed,X
    CLC
    ADC.B #$06                                ; Handle the animation of the Blargg's mouth, based on how far into the jump it is.
    CMP.B #$0C
    BCS +
    INC.W SpriteMisc1602,X
  + RTS

CODE_03A045:
    LDA.B SpriteYPosLow,X                     ; Subroutine to spawn a lava splash for the Blargg.
    PHA
    SEC
    SBC.B #$0C
    STA.B SpriteYPosLow,X                     ; Offset Y position to display the splash at.
    LDA.W SpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    JSL CODE_028528                           ; Create a lava splash.
    PLA
    STA.W SpriteYPosHigh,X                    ; Restore Y position.
    PLA
    STA.B SpriteYPosLow,X
    RTS

CODE_03A062:
    JSR GetDrawInfoBnk3                       ; Blargg GFX routine
    LDA.B SpriteTableC2,X                     ; Branch if the Blargg is currently hidden under the lava and shouldn't be drawn.
    BEQ CODE_03A038
    CMP.B #$04                                ; Branch ot the second GFX routine if the full body needs to be drawn.
    BEQ +                                     ; Else, the code below draws just his eyes.
    JSL GenericSprGfxRt2                      ; Draw a 16x16 sprite.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$A0                                ; Tile to use for the Blargg's eye.
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$100,Y
    AND.B #$CF                                ; Change YXPPCCCT in OAM.
    STA.W OAMTileAttr+$100,Y
    RTS


DATA_03A082:
    db $F8,$08,$F8,$08,$18,$08,$F8,$08
    db $F8,$E8

DATA_03A08C:
    db $F8,$F8,$08,$08,$08

BlarggTilemap:
    db $A2,$A4,$C2,$C4,$A6,$A2,$A4,$E6
    db $C8,$A6

DATA_03A09B:
    db $45,$05

; X offsets for each tile of the Blargg, indexed by his direction.
; Left
; Right
; Y offsets for each tile of the Blargg.
; Tile numbers for each tile of the Blargg.
; YXPPCCCT for the Blargg, indexed by his direction.
  + LDA.W SpriteMisc1602,X                    ; Blargg GFX routine 2 (when fully emerged)
    ASL A
    ASL A                                     ; $03 = Animation frame, x5
    ADC.W SpriteMisc1602,X
    STA.B _3
    LDA.W SpriteMisc157C,X                    ; $02 = Horizontal direction
    STA.B _2
    PHX
    LDX.B #$04
CODE_03A0AF:
    PHX
    PHX
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W DATA_03A08C,X
    STA.W OAMTileYPos+$100,Y
    LDA.B _2
    BNE +
    TXA
    CLC
    ADC.B #$05
    TAX                                       ; Store X position to OAM.
  + LDA.B _0
    CLC
    ADC.W DATA_03A082,X
    STA.W OAMTileXPos+$100,Y
    PLA
    CLC
    ADC.B _3                                  ; Store tile number to OAM.
    TAX
    LDA.W BlarggTilemap,X
    STA.W OAMTileNo+$100,Y
    LDX.B _2
    LDA.W DATA_03A09B,X                       ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    PLX
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL CODE_03A0AF
    PLX
    LDY.B #$02
    LDA.B #$04                                ; Upload 5 16x16s.
    JSL FinishOAMWrite
    RTS

CODE_03A0F1:
    JSL InitSpriteTables                      ; Bowser INIT
    STZ.W SpriteOffscreenX,X
    LDA.B #$80
    STA.B SpriteYPosLow,X
    LDA.B #$FF
    STA.W SpriteYPosHigh,X                    ; Set initial position at 00D0,FF80.
    LDA.B #$D0
    STA.B SpriteXPosLow,X
    LDA.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B #$02                                ; Number of hits needed to defeat the first phase of Bowser.
    STA.W SpriteMisc187B,X
    LDA.B #$03                                ; Store Mode 7 index.
    STA.B SpriteTableC2,X
    JSL CODE_03DD7D                           ; Load palette/GFX files.
    RTL

Bnk3CallSprMain:
    PHB                                       ; Routine to find code for sprites which couldn't fit in bank 1/2.
    PHK
    PLB
    LDA.B SpriteNumber,X
    CMP.B #$C8                                ; Light switch redirect
    BNE +
    JSR LightSwitch
    PLB
    RTL

  + CMP.B #$C7                                ; Invisible mushroom redirect
    BNE +
    JSR InvisMushroom
    PLB
    RTL

  + CMP.B #$51                                ; Ninji redirect
    BNE +
    JSR Ninji
    PLB
    RTL

  + CMP.B #$1B                                ; Football redirect
    BNE +
    JSR Football
    PLB
    RTL

  + CMP.B #$C6                                ; Spotlight redirect
    BNE +
    JSR DarkRoomWithLight
    PLB
    RTL

  + CMP.B #$7A                                ; Fireball redirect
    BNE +
    JSR Firework
    PLB
    RTL

  + CMP.B #$7C                                ; Peach redirect
    BNE +
    JSR PrincessPeach
    PLB
    RTL

  + CMP.B #$C5                                ; Big Boo Boss redirect
    BNE +
    JSR BigBooBoss
    PLB
    RTL

  + CMP.B #$C4                                ; Gray falling platform redirect
    BNE +
    JSR GreyFallingPlat
    PLB
    RTL

  + CMP.B #$C2                                ; Blurp redirect
    BNE +
    JSR Blurp
    PLB
    RTL

  + CMP.B #$C3                                ; Porcupuffer redirect
    BNE +
    JSR PorcuPuffer
    PLB
    RTL

  + CMP.B #$C1                                ; Flying turnblocks redirect
    BNE +
    JSR FlyingTurnBlocks
    PLB
    RTL

  + CMP.B #$C0                                ; Gray lava platform redirect
    BNE +
    JSR GrayLavaPlatform
    PLB
    RTL

  + CMP.B #$BF                                ; Mega Mole redirect
    BNE +
    JSR MegaMole
    PLB
    RTL

  + CMP.B #$BE                                ; Swooper redirect
    BNE +
    JSR Swooper
    PLB
    RTL

  + CMP.B #$BD                                ; Sliding Koopa redirect
    BNE +
    JSR SlidingKoopa
    PLB
    RTL

  + CMP.B #$BC                                ; Bowser Statue redirect
    BNE +
    JSR BowserStatue
    PLB
    RTL

  + CMP.B #$B8                                ; Carrot Top Lift redirect
    BEQ CODE_03A1BE
    CMP.B #$B7
    BNE +
CODE_03A1BE:
    JSR CarrotTopLift
    PLB
    RTL

  + CMP.B #$B9                                ; Message Box redirect
    BNE +
    JSR InfoBox
    PLB
    RTL

  + CMP.B #$BA                                ; Timed Lift redirect
    BNE +
    JSR TimedLift
    PLB
    RTL

  + CMP.B #$BB                                ; Gray Castle Block redirect
    BNE +
    JSR GreyCastleBlock
    PLB
    RTL

  + CMP.B #$B3                                ; Bowser Statue Fireball redirect
    BNE +
    JSR StatueFireball
    PLB
    RTL

  + LDA.B SpriteNumber,X                      ; Falling Spike redirect
    CMP.B #$B2
    BNE +
    JSR FallingSpike
    PLB
    RTL

  + CMP.B #$AE                                ; Fishin' Boo redirect
    BNE +
    JSR FishinBoo
    PLB
    RTL

  + CMP.B #$B6                                ; Reflecting Fireball redirect
    BNE +
    JSR ReflectingFireball
    PLB
    RTL

  + CMP.B #$B0                                ; Boo Stream redirect
    BNE +
    JSR BooStream
    PLB
    RTL

  + CMP.B #$B1                                ; Creating/Eating Block redirect
    BNE +
    JSR CreateEatBlock
    PLB
    RTL

  + CMP.B #$AC                                ; Wooden Spike redirect
    BEQ CODE_03A21E
    CMP.B #$AD
    BNE +
CODE_03A21E:
    JSR WoodenSpike
    PLB
    RTL

  + CMP.B #$AB                                ; Rex redirect
    BNE +
    JSR RexMainRt
    PLB
    RTL

  + CMP.B #$AA                                ; Fishbone redirect
    BNE +
    JSR Fishbone
    PLB
    RTL

  + CMP.B #$A9                                ; Reznor redirect
    BNE +
    JSR Reznor
    PLB
    RTL

  + CMP.B #$A8                                ; Blargg redirect
    BNE +
    JSR Blargg
    PLB
    RTL

  + CMP.B #$A1                                ; Bowser's Bowling Ball redirect
    BNE +
    JSR BowserBowlingBall
    PLB
    RTL

  + CMP.B #$A2                                ; MechaKoopa redirect
    BNE +
    JSR MechaKoopa
    PLB
    RTL

; Bowser misc RAM:
; $C2   - Set to #$03 on spawn, to indicate which Mode 7 room needs to be loaded.
; $151C - Sprite phase.
; 0 = descending at start, 1 = swooping out, 2 = swooping in / peach, 3 = bowser flames
; 4 = rising up after death, 5 = death clouds / flipping upside down, 6 = dropping peach and flying away
; 7 = attack phase 1, 8 = attack phase 2, 3 = attack phase 3
; $1528 - Direction of horizontal acceleration in attack phase 1 (0 = left, 1 = right).
; Also used when swooping out of the screen for the same purpose, with 0 = right, 1 = left, 2 = none.
; $1534 - Direction of vertical acceleration in attack phase 1 (0 = down, 1 = up).
; Also used when swooping out of the screen for the same purpose, with 0 = up, 1 = down, 2 = none.
; $1540 - Timer for Bowser's ducking animations at the beginning/end of each phase.
; Also used for waiting to turn upside-down after defeat, and for waiting to fly away after dropping Peach.
; $154C - Timer to disable contact with Mario.
; Also used as a timer just before attack phase 1 for briefly pausing Bowser.
; Furthermore used as a timer after Bowser rotates upside down after his defeat to wait before spawning Peach.
; $1558 - Timer for the clown car's blinking animation.
; $1564 - Timer for the cloud puffs after defeat.
; $1570 - Animation frame for Bowser.
; 0 = Normal, 2/4/6/8/A = ducking into car/blinking, C = hit, E = inside car, 10/12 = hurt
; $157C - Facing direction. 00 = left, 80 = right. Other values will mess up graphics.
; $1594 - Timer for Peach's "Help!" animation.
; $187B - HP for the current phase.
; Bowser MAIN
  + JSL CODE_03DFCC                           ; Set up palette.
    JSR CODE_03A279                           ; Run primary code.
    JSR CODE_03B43C                           ; Draw the room and item box.
    PLB
    RTL


DATA_03A265:
    db $04,$03,$02,$01,$00,$01,$02,$03
    db $04,$05,$06,$07,$07,$07,$07,$07
    db $07,$07,$07,$07

CODE_03A279:
; Palette indices for Bowser's fade in/out animations.
    LDA.B Mode7XScale                         ; Primary Bowser code.
    LSR A
    LSR A
    LSR A                                     ; Set Bowser's current palette based on his "size".
    TAY
    LDA.W DATA_03A265,Y
    STA.W BowserPalette
    LDA.W SpriteMisc1570,X
    CLC
    ADC.B #$1E                                ; Set animation frame for Bowser. Bit 7 controls X flip.
    ORA.W SpriteMisc157C,X
    STA.W Mode7TileIndex
    LDA.B EffFrame
    LSR A                                     ; Set animation frame for the propellor.
    AND.B #$03
    STA.W ClownCarPropeller
    LDA.B #$90
    STA.B Mode7CenterX                        ; Set centers of rotation/scale for Mode 7.
    LDA.B #$C8
    STA.B Mode7CenterY
    JSL CODE_03DEDF                           ; Handle the Mode 7 tilemap.
    LDA.W BowserHurtState
    BEQ +                                     ; If Bowser has been hurt, draw the stars and teardrop above his head
    JSR CODE_03AF59
  + LDA.W SpriteMisc1564,X
    BEQ +                                     ; If Bowser has been defeated, handle the cloud puffs from his car and draw them.
    JSR CODE_03A3E2
  + LDA.W SpriteMisc1594,X
    BEQ +
    DEC A
    LSR A
    LSR A
    PHA
    LSR A                                     ; If Peach is being shown, handle her "Help!" animation and draw her.
    TAY
    LDA.W DATA_03A8BE,Y
    STA.B _2
    PLA
    AND.B #$03
    STA.B _3
    JSR CODE_03AA6E
    NOP
  + LDA.B SpriteLock                          ; Return if the game frozen.
    BNE Return03A340
    STZ.W SpriteMisc1594,X
    LDA.B #$30
    STA.B SpriteProperties
    LDA.B Mode7XScale                         ; Set Bowser to be drawn behind Mario.
    CMP.B #$20                                ; If Bowser is moving "towards" the screen, send Mario behind him instead.
    BCS +
    STZ.B SpriteProperties
  + JSR CODE_03A661                           ; Handle Bowser's hurt animation, and end the fight if it was the last hit.
    LDA.W BowserWaitTimer
    BEQ +
    LDA.B TrueFrame                           ; Handle the timer for Bowser's attacks.
    AND.B #$03
    BNE +
    DEC.W BowserWaitTimer
  + LDA.B TrueFrame
    AND.B #$7F
    BNE +
    JSL GetRand                               ; Every 128 frames, randomly descide whether to make the clown car blink.
    AND.B #$01
    BNE +
    LDA.B #$0C                                ; How long the clown car's blinking animation lasts.
    STA.W SpriteMisc1558,X
  + JSR CODE_03B078                           ; Process interaction with Mario and the MechaKoopas.
    LDA.W SpriteMisc151C,X
    CMP.B #$09
    BEQ +
    STZ.W ClownCarImage                       ; If not in phase 9, animate the blinking animation for Bowser's clown car.
    LDA.W SpriteMisc1558,X
    BEQ +
    INC.W ClownCarImage
  + JSR CODE_03A5AD                           ; Handle attacking.
    JSL UpdateXPosNoGvtyW                     ; Update X position.
    JSL UpdateYPosNoGvtyW                     ; Update Y position.
    LDA.W SpriteMisc151C,X
    JSL ExecutePtr

    dw CODE_03A441
    dw CODE_03A6F8
    dw CODE_03A84B
    dw CODE_03A7AD
    dw CODE_03AB9F
    dw CODE_03ABBE
    dw CODE_03AC03
    dw CODE_03A49C
    dw CODE_03AB21
    dw CODE_03AB64

Return03A340:
; Bowser phase pointers.
; 0 - Descending at the start
; 1 - Swooping out of the screen
; 2 - Swooping into the screen / Peach
; 3 - Bowser flames dropping
; 4 - Rising up after being killed
; 5 - Death (cloud puffs, rotation)
; 6 - Dropping Peach and spinning away
; 7 - Phase 1
; 8 - Phase 2
    RTS                                       ; 9 - Phase 3


DATA_03A341:
    db $D5,$DD,$23,$2B,$D5,$DD,$23,$2B
    db $D5,$DD,$23,$2B,$D5,$DD,$23,$2B
    db $D6,$DE,$22,$2A,$D6,$DE,$22,$2A
    db $D7,$DF,$21,$29,$D7,$DF,$21,$29
    db $D8,$E0,$20,$28,$D8,$E0,$20,$28
    db $DA,$E2,$1E,$26,$DA,$E2,$1E,$26
    db $DC,$E4,$1C,$24,$DC,$E4,$1C,$24
    db $E0,$E8,$18,$20,$E0,$E8,$18,$20
    db $E8,$F0,$10,$18,$E8,$F0,$10,$18
DATA_03A389:
    db $DD,$D5,$D5,$DD,$23,$2B,$2B,$23
    db $DD,$D5,$D5,$DD,$23,$2B,$2B,$23
    db $DE,$D6,$D6,$DE,$22,$2A,$2A,$22
    db $DF,$D7,$D7,$DF,$21,$29,$29,$21
    db $E0,$D8,$D8,$E0,$20,$28,$28,$20
    db $E2,$DA,$DA,$E2,$1E,$26,$26,$1E
    db $E4,$DC,$DC,$E4,$1C,$24,$24,$1C
    db $E8,$E0,$E0,$E8,$18,$20,$20,$18
    db $F0,$E8,$E8,$F0,$10,$18,$18,$10
DATA_03A3D1:
    db $80,$40,$00,$C0,$00,$C0,$80,$40
DATA_03A3D9:
    db $E3,$ED,$ED,$EB,$EB,$E9,$E9,$E7
    db $E7

CODE_03A3E2:
; X offsets for each tile of the cloud puffs in Bowser's death animation. 8 tiles per frame.
; Y offsets for each tile of the cloud puffs in Bowser's death animation. 8 tiles per frame.
; YXPPCCCT for each of the cloud puffs spawned by Bowser when defeated.
; Tile numbers for each frame of animation for the clouds from Bowser's Clown Car.
    JSR GetDrawInfoBnk3                       ; Subroutine to draw the cloud puffs when Bowser is defeated.
    LDA.W SpriteMisc1564,X
    DEC A                                     ; $03 = animation frame of the puff
    LSR A
    STA.B _3
    ASL A
    ASL A                                     ; $02 = animation frame, x8
    ASL A
    STA.B _2
    LDA.B #$70                                ; OAM index (from $0300) for Bowser's death clouds.
    STA.W SpriteOAMIndex,X
    TAY
    PHX
    LDX.B #$07
  - PHX                                       ; Cloud puffs tile loop.
    TXA
    ORA.B _2
    TAX
    LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W DATA_03A341,X
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_03A389,X                       ; Store Y position to OAM.
    CLC
    ADC.B #$30
    STA.W OAMTileYPos+$100,Y
    LDX.B _3
    LDA.W DATA_03A3D9,X                       ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    PLX
    LDA.W DATA_03A3D1,X                       ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY                                       ; Loop for all of the puffs.
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$07                                ; Upload 8 manually-sized tiles.
    JSL FinishOAMWrite
    RTS


DATA_03A437:
    db $00,$00,$00,$00,$02,$04,$06,$08
    db $0A,$0E

CODE_03A441:
; Animation frames for the animation of Bowser emerging from his clown car at the start of a phase.
; Bowser phase 0 - Descending at the start
    LDA.W SpriteMisc154C,X                    ; Branch if fully descended, Bowser has emerged, and waiting to start attack phase 1.
    BNE CODE_03A482
    LDA.W SpriteMisc1540,X                    ; Branch if fully descended and waiting for Bowser to emerge.
    BNE CODE_03A465
    LDA.B #$0E                                ; Animation frame for Bowser when he's descending at the start of the battle.
    STA.W SpriteMisc1570,X
    LDA.B #con($04,$04,$04,$05,$05)           ; Y speed of Bowser as he descends at the start of the battle.
    STA.B SpriteYSpeed,X
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0; Clear X speed.
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos                          ; Return if not done descending.
    CMP.B #$10
    BNE +
    LDA.B #$A4                                ; How long Bowser takes to emerge from his car at the start of the fight.
    STA.W SpriteMisc1540,X
  + RTS

CODE_03A465:
; Car has fully descended, waiting for Bowser to emerge.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; Clear X/Y speed.
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    CMP.B #$01                                ; Branch if Bowser is done emerging.
    BEQ CODE_03A47C
    CMP.B #$40
    BCS +
    LSR A
    LSR A                                     ; Handle the animation for Bowser emerging from his car.
    LSR A
    TAY
    LDA.W DATA_03A437,Y
    STA.W SpriteMisc1570,X
  + RTS

CODE_03A47C:
; Bowser just finished emergining.
    LDA.B #con($24,$24,$24,$15,$15)           ; How long Bowser pauses for before attack phase 1 actually starts.
    STA.W SpriteMisc154C,X
    RTS

CODE_03A482:
; Car has fully descended, Bowser has emerge, now just waiting to actually start phase 1.
    DEC A                                     ; Return if not time to start.
    BNE +
    LDA.B #$07                                ; Start Phase 1.
    STA.W SpriteMisc151C,X
    LDA.B #$78                                ; How long until Bowser throws his first set of MechaKoopas.
    STA.W BowserWaitTimer
  + RTS


DATA_03A490:
    db $FF,$01

DATA_03A492:
    db $C8,$38

DATA_03A494:
    db $01,$FF

DATA_03A496:
    db $1C,$E4

DATA_03A498:
    db $00,$02,$04,$02

CODE_03A49C:
; X speed accelerations for Bowser in Phase 1.
; Maximum X speeds for Bowser in Phase 1.
; Y speed accelerations for Bowser in Phase 1.
; Maximum Y speeds for Bowser in Phase 1.
; Animation pointers to use for Bowser's facial animation (squinting, closing mouth)
; Bowser phase 7 - Attack phase 1
    JSR CODE_03A4D2                           ; Animate Bowser's face.
    JSR CODE_03A4FD                           ; Prepare a MechaKoopa attack when time to.
    JSR CODE_03A4ED                           ; Face Mario.
    LDA.W SpriteMisc1528,X
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X
    CLC                                       ; Update Bowser's X speed and reverse acceleration if at the maximum.
    ADC.W DATA_03A490,Y
    STA.B SpriteXSpeed,X
    CMP.W DATA_03A492,Y
    BNE +
    INC.W SpriteMisc1528,X
  + LDA.W SpriteMisc1534,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC                                       ; Update Bowser's Y speed and reverse acceleration if at the maximum.
    ADC.W DATA_03A494,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_03A496,Y
    BNE +
    INC.W SpriteMisc1534,X
  + RTS

CODE_03A4D2:
; Subroutine to animate Bowser's facial animation.
    LDY.B #$00                                ; Default frame.
    LDA.B TrueFrame
    AND.B #$E0                                ; Don't blink if not time to do so.
    BNE +
    LDA.B TrueFrame
    AND.B #$18
    LSR A
    LSR A                                     ; Get the animation frame for Bowser's blink animation.
    LSR A
    TAY
    LDA.W DATA_03A498,Y
    TAY
  + TYA
    STA.W SpriteMisc1570,X
    RTS


DATA_03A4EB:
    db $80,$00

CODE_03A4ED:
    LDA.B TrueFrame                           ; Subroutine to turn Bowser toward Mario.
    AND.B #$1F
    BNE +                                     ; Every 32 frames, turn Bowser to face Mario.
    JSR SubHorzPosBnk3
    LDA.W DATA_03A4EB,Y
    STA.W SpriteMisc157C,X
  + RTS

CODE_03A4FD:
; Handle Bowser's attacks (MechaKoopas, bowling balls)
    LDA.W BowserWaitTimer                     ; Return if not time for an attack.
    BNE Return03A52C
    LDA.W SpriteMisc151C,X                    ; Continue to next code if:
    CMP.B #$08                                ; In phase 1/3
    BNE CODE_03A51A                           ; Already thrown two bowling balls
    INC.W BowserAttackType                    ; Else, prepare a Bowling Ball attack and return.
    LDA.W BowserAttackType
    CMP.B #$03                                ; Number of bowling balls to drop (+1); use with $03A613.
    BEQ CODE_03A51A
    LDA.B #$FF                                ; How long to wait for dropping a bowling ball.
    STA.W BowserSteelieTimer
    BRA Return03A52C

CODE_03A51A:
    STZ.W BowserAttackType                    ; Preparing MechaKoopa attack.
    LDA.W SpriteStatus
    BEQ CODE_03A527
    LDA.W SpriteStatus+1                      ; If slot 0 or 1 are empty, prepare a MechaKoopa attack.
    BNE Return03A52C                          ; Else, return without doing so.
CODE_03A527:
    LDA.B #$FF
    STA.W BowserAttackTimer
Return03A52C:
    RTS


DATA_03A52D:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$02,$04,$06,$08,$0A,$0E,$0E
    db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
    db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
    db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
    db $0E,$0E,$0A,$08,$06,$04,$02,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
DATA_03A56D:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$10,$20,$30,$40,$50,$60
    db $80,$A0,$C0,$E0,$FF,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$C0,$80,$60
    db $40,$30,$20,$10,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00

CODE_03A5AD:
; Animation frames for Bowser ducking into his clown car
; during the MechaKoopa and bowling ball attacks.
; Mode 7 rotation values for Bowser's bowling ball animation.
; #$FF is handled as #$0100 instead. All other values remain 8-bit.
; Bowser's attack routine.
    LDA.W BowserAttackTimer                   ; Branch if the MechaKoopa animation timer is not currently running.
    BEQ CODE_03A5D8
    DEC.W BowserAttackTimer
    BNE +                                     ; If the timer has just run out, reset it and return. Else, branch.
    LDA.B #$54                                ; Amount of time between Bowser throwing Mechakoopas in Phase 1.
    STA.W BowserWaitTimer
    RTS

  + LSR A                                     ; MechaKoopa timer is running; handle animation and toss.
    LSR A
    TAY                                       ; Animate Bowser's ducking movement.
    LDA.W DATA_03A52D,Y
    STA.W SpriteMisc1570,X
    LDA.W BowserAttackTimer
    CMP.B #$80
    BNE +                                     ; Spawn the MechaKoopas when time to.
    JSR CODE_03B019
    LDA.B #!SFX_SPRING                        ; \ Play sound effect; SFX for Bowser throwing MechaKoopas.
    STA.W SPCIO3                              ; /
  + PLA
    PLA
    RTS

CODE_03A5D8:
; MechaKoopa timer is not running; handle bowling ball animation instead.
    LDA.W BowserSteelieTimer                  ; Return if the bowling ball animation timer is not running.
    BEQ Return03A60D
    DEC.W BowserSteelieTimer                  ; Branch if the timer just ran out.
    BEQ CODE_03A60E
    LSR A
    LSR A
    TAY                                       ; Animate Bowser's ducking movement.
    LDA.W DATA_03A52D,Y
    STA.W SpriteMisc1570,X
    LDA.W DATA_03A56D,Y
    STA.B Mode7Angle
    STZ.B Mode7Angle+1
    CMP.B #$FF                                ; Animate the car's rotation.
    BNE +
    STZ.B Mode7Angle
    INC.B Mode7Angle+1
    STZ.B SpriteProperties
  + LDA.W BowserSteelieTimer
    CMP.B #$80                                ; Spawn the ball when time to.
    BNE +
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect; SFX for Bowser dropping a bowling ball.
    STA.W SPCIO3                              ; /
    JSR CODE_03A61D
  + PLA
    PLA
Return03A60D:
    RTS

CODE_03A60E:
; Bowling ball timer just ran out.
    LDA.B #$60                                ; Amount of time before Bowser drops Mechakoopas after the bowling balls in Phase 2.
    LDY.W BowserAttackType
    CPY.B #$02                                ; Number of bowling balls to drop; use with $03A50F.
    BEQ +
    LDA.B #$20                                ; Amount of time between the bowling balls.
  + STA.W BowserWaitTimer
    RTS

CODE_03A61D:
    LDA.B #$08                                ; Subroutine to spawn one of Bowser's bowling balls.
    STA.W SpriteStatus+8
    LDA.B #$A1                                ; Sprite to spawn (Bowling Ball).
    STA.B SpriteNumber+8
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$08
    STA.B SpriteXPosLow+8
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh+8                    ; Spawn at Bowser's position.
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$40
    STA.B SpriteYPosLow+8
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh+8
    PHX
    LDX.B #$08
    JSL InitSpriteTables
    PLX
    RTS


DATA_03A64D:
    db $00,$00,$00,$00,$FC,$F8,$F4,$F0
    db $F4,$F8,$FC,$00,$04,$08,$0C,$10
    db $0C,$08,$04,$00

CODE_03A661:
; Angles for Bowser's hurt animation.
; Although it's 8-bit, positive values refer to 000-07F and negative refer to 180-1FF.
; Subroutine to handle animating Bowser when hurt.
    LDA.W BowserHurtState                     ; Return if Bowser is not currently hurt.
    BEQ Return03A6BF
    STZ.W BowserAttackTimer                   ; Clear Bowser's attack timers.
    STZ.W BowserSteelieTimer
    DEC.W BowserHurtState                     ; Branch if not done with the hurt animation yet.
    BNE CODE_03A691
    LDA.B #$50                                ; How long before Bowser's next attack after taking damage.
    STA.W BowserWaitTimer
    DEC.W SpriteMisc187B,X                    ; Branch if not time to move onto the next phase.
    BNE CODE_03A691
    LDA.W SpriteMisc151C,X
    CMP.B #$09                                ; Branch if in phase 3 (to kill Bowser).
    BEQ CODE_03A6C0
    LDA.B #$02                                ; How much HP to give Bowser in phase 2/3.
    STA.W SpriteMisc187B,X
    LDA.B #$01                                ; Set Bowser to swoop out of the screen.
    STA.W SpriteMisc151C,X
    LDA.B #$80                                ; Set timer for Bowser's ducking animation before swooping out.
    STA.W SpriteMisc1540,X
CODE_03A691:
    PLY
    PLY
    PHA
    LDA.W BowserHurtState
    LSR A
    LSR A
    TAY
    LDA.W DATA_03A64D,Y                       ; Animate the car's rotation.
    STA.B Mode7Angle
    STZ.B Mode7Angle+1
    BPL +
    INC.B Mode7Angle+1
  + PLA
    LDY.B #$0C                                ; Frame for ducking slightly after being hit.
    CMP.B #$40
    BCS +
CODE_03A6AC:
    LDA.B TrueFrame
    LDY.B #$10                                ; Hurt pose frame 1.
    AND.B #$04
    BEQ +
    LDY.B #$12                                ; Hurt pose frame 2.
  + TYA
    STA.W SpriteMisc1570,X
    LDA.B #$02                                ; Frame to use for the clown car.
    STA.W ClownCarImage
Return03A6BF:
    RTS

CODE_03A6C0:
; Phase 3 defeated.
    LDA.B #$04                                ; End the fight.
    STA.W SpriteMisc151C,X
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0; Clear Bowser's X speed.
    RTS

KillMostSprites:
    LDY.B #$09                                ; Subroutine to kill most other sprites after a boss is defeated.
CODE_03A6CA:
    LDA.W SpriteStatus,Y                      ; Find a living sprite.
    BEQ +
    LDA.W SpriteNumber,Y
    CMP.B #$A9
    BEQ +                                     ; If not sprite:
    CMP.B #$29                                ; A9 (Reznor)
    BEQ +                                     ; 29 (Koopa Kid)
    CMP.B #$A0                                ; A0 (Bowser)
    BEQ +                                     ; C5 (Big Boo Boss)
    CMP.B #$C5
    BEQ +
    LDA.B #$04                                ; \ Sprite status = Killed by spin jump
    STA.W SpriteStatus,Y                      ; /; ...erase in a cloud of smoke.
    LDA.B #$1F                                ; \ Time to show cloud of smoke = #$1F
    STA.W SpriteMisc1540,Y                    ; /
  + DEY
    BPL CODE_03A6CA
    RTL


DATA_03A6F0:
    db $0E,$0E,$0A,$08,$06,$04,$02,$00

CODE_03A6F8:
; Animation frames for Bowser ducking into the clown car before swooping out.
; Bowser phase 1 - Swooping out of the screen
    LDA.W SpriteMisc1540,X                    ; Branch if Bowser is done ducking into his car and it's time to actually swoop.
    BEQ CODE_03A731
    CMP.B #$01
    BNE +                                     ; Play SFX if time to actually swoop.
    LDY.B #!BGM_BOWSERZOOMOUT                 ; SFX/music for swooping out of the screen.
    STY.W SPCIO2                              ; / Change music
  + LSR A
    LSR A
    LSR A
    LSR A                                     ; Animate Bowser ducking into the car.
    TAY
    LDA.W DATA_03A6F0,Y
    STA.W SpriteMisc1570,X
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0; Clear X/Y speed.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    STZ.W SpriteMisc1528,X
    STZ.W SpriteMisc1534,X                    ; Clear movement related addresses.
    STZ.W BowserFlyawayCounter
    RTS


DATA_03A71F:
    db $01,$FF

DATA_03A721:
    db $10,$80

DATA_03A723:
    db $07,$03

DATA_03A725:
    db $FF,$01

DATA_03A727:
    db $F0,$08

DATA_03A729:
    db $01,$FF

DATA_03A72B:
    db $03,$03

DATA_03A72D:
    db $60,$02

DATA_03A72F:
    db $01,$01

CODE_03A731:
; X accelerations to apply as Bowser swoops out of the screen.
; Max X speeds to accelerate to before increasing the X phase of Bowser's movement out of the screen.
; How often to apply horizontal acceleration as Bowser swoops out of the screen.
; Y accelerations to apply as Bowser swoops out of the screen.
; Max Y speeds to accelerate to before increasing the Y phase of Bowser's movement out of the screen.
; Speeds to scale Bowser with as he swoops out of the screen.
; How often to apply vertical acceleration as Bowser swoops out of the screen.
; Maximum scaling to increase to before increasing the scale phase of Bowser's movement out of the screen.
; How often to change the size of Bowser as he swoops out of the screen.
    LDY.W SpriteMisc1528,X                    ; Routine to actually swoop Bowser out of the screen.
    CPY.B #$02
    BCS +
    LDA.B TrueFrame
    AND.W DATA_03A723,Y
    BNE +                                     ; Handle horizontal acceleration over the course of the movement.
    LDA.B SpriteXSpeed,X                      ; If $1528 is #$02, no acceleration is applied (never reached, though).
    CLC
    ADC.W DATA_03A71F,Y
    STA.B SpriteXSpeed,X
    CMP.W DATA_03A721,Y
    BNE +
    INC.W SpriteMisc1528,X
  + LDY.W SpriteMisc1534,X
    CPY.B #$02
    BCS +
    LDA.B TrueFrame
    AND.W DATA_03A72B,Y
    BNE +                                     ; Handle vertical acceleration over the course of the movement.
    LDA.B SpriteYSpeed,X                      ; If $1534 is #$02, no acceleration is applied.
    CLC
    ADC.W DATA_03A725,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_03A727,Y
    BNE +
    INC.W SpriteMisc1534,X
  + LDY.W BowserFlyawayCounter
    CPY.B #$02
    BEQ CODE_03A794
    LDA.B TrueFrame
    AND.W DATA_03A72F,Y
    BNE +
    LDA.B Mode7XScale
    CLC                                       ; Handle size change over the course of the movement (think of it as the "Z acceleration").
    ADC.W DATA_03A729,Y                       ; If $14B2 is #$02, no change is applied.
    STA.B Mode7XScale
    STA.B Mode7YScale                         ; Return if Bowser's sprite hasn't moved far enough left to mark Bowswer as "out of shot".
    CMP.W DATA_03A72D,Y                       ; (i.e. not time to end the phase)
    BNE +
    INC.W BowserFlyawayCounter
  + LDA.W SpriteXPosHigh,X
    CMP.B #$FE
    BNE +
CODE_03A794:
    LDA.B #$03                                ; Switch to phase 3 (Bowser flames dropping).
    STA.W SpriteMisc151C,X
    LDA.B #$80                                ; Set timer for Bowser's flames phase.
    STA.W BowserWaitTimer
    JSL GetRand
    AND.B #$F0                                ; Set random X position for the initial fireball.
    STA.W BowserFireXPos
    LDA.B #!BGM_BOWSERINTERLUDE2              ; SFX/music for the Bowser flames phase.
    STA.W SPCIO2                              ; / Change music
  + RTS

CODE_03A7AD:
    LDA.B #$60                                ; Bowser phase 3 - Bowser flames dropping
    STA.B Mode7XScale
    STA.B Mode7YScale
    LDA.B #$FF                                ; Keep Bowser out of shot.
    STA.W SpriteXPosHigh,X
    LDA.B #$60
    STA.B SpriteXPosLow,X
    LDA.W BowserWaitTimer                     ; Branch if not time to end the phase.
    BNE +
    LDA.B #!BGM_BOWSERZOOMIN                  ; SFX/music for Bowser's flames phase.
    STA.W SPCIO2                              ; / Change music
    LDA.B #$02                                ; Switch to phase 3 (swooping in).
    STA.W SpriteMisc151C,X
    LDA.B #$18
    STA.B SpriteYPosLow,X                     ; Set Y position for the start of the swoop at #$0018.
    LDA.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B #$08
    STA.B Mode7XScale                         ; Set initial scaling as Bowser swoops back in.
    STA.B Mode7YScale
    LDA.B #$64                                ; Set initial X speed as Bowser swoops back in.
    STA.B SpriteXSpeed,X
    RTS

; Bowser is still dropping flames.
  + CMP.B #$60                                ; Return if not time to actually drop the flames.
    BCS Return03A840
    LDA.B TrueFrame
    AND.B #$1F                                ; How often to spawn a Bowser flame.
    BNE Return03A840
    LDY.B #$07
CODE_03A7EB:
    LDA.W SpriteStatus,Y
    BEQ CODE_03A7F6                           ; Find an empty sprite slot and return if none found.
    DEY
    CPY.B #$01
    BNE CODE_03A7EB
    RTS

CODE_03A7F6:
    LDA.B #!SFX_FIRESPIT                      ; \ Play sound effect; SFX for a Bowser flame spawning.
    STA.W SPCIO3                              ; /
    LDA.B #$08                                ; \ Sprite status = Normal; Sprite status of Bowser's fireballs.
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$33                                ; Sprite to use as Bowser's fire (Podoboo)
    STA.W SpriteNumber,Y
    LDA.W BowserFireXPos
    PHA
    STA.W SpriteXPosLow,Y
    CLC                                       ; Set X position, 2 blocks right of the last fire.
    ADC.B #$20
    STA.W BowserFireXPos
    LDA.B #$00
    STA.W SpriteXPosHigh,Y
    LDA.B #$00
    STA.W SpriteYPosLow,Y                     ; Set Y position at the top of the screen.
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    INC.B SpriteTableC2,X                     ; Spawn the sprite as the Bowser fire, not as a Podoboo.
    ASL.W SpriteTweakerE,X                    ; Clear "don't interact with objects" flag.
    LSR.W SpriteTweakerE,X
    LDA.B #$39                                ; Change sprite clipping.
    STA.W SpriteTweakerB,X
    PLX
    PLA
    LSR A
    LSR A
    LSR A
    LSR A                                     ; Get spawn sound effect based on where the flame is being spawned horizontally on the screen.
    LSR A
    TAY
    LDA.W BowserSound,Y
    STA.W SPCIO3                              ; / Play sound effect
Return03A840:
    RTS


BowserSound:
    db !SFX_BOWSERFIRE1
    db !SFX_BOWSERFIRE2
    db !SFX_BOWSERFIRE3
    db !SFX_BOWSERFIRE4
    db !SFX_BOWSERFIRE5
    db !SFX_BOWSERFIRE6
    db !SFX_BOWSERFIRE7
    db !SFX_BOWSERFIRE8

BowserSoundMusic:
    db !BGM_BOWSERPHASE2
    db !BGM_BOWSERPHASE3

CODE_03A84B:
; SFX for Bowser's fires (Podoboo fades).
; SFX/music for Bowser attack phases 2 and 3.
; Bowser phase 2 - Swooping into the screen / Peach's item
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; CLear Y speed.
    LDA.W SpriteMisc1540,X                    ; Branch if showing Peach / Bowser is emerging.
    BNE CODE_03A86E
    LDA.B SpriteXSpeed,X
    BEQ +                                     ; Declerate X speed.
    DEC.B SpriteXSpeed,X
  + LDA.B TrueFrame
    AND.B #$03                                ; Return if not a frame to adjust scaling.
    BNE +
    INC.B Mode7XScale                         ; Scale Bowser away from the screen, to "swoop in".
    INC.B Mode7YScale
    LDA.B Mode7XScale
    CMP.B #$20                                ; Return if not fully scaled in.
    BNE +
    LDA.B #$FF                                ; Set timer for the Peach animation and Bowser emerging.
    STA.W SpriteMisc1540,X
  + RTS

CODE_03A86E:
    CMP.B #$A0                                ; Showing Peach / emerging Bowser.
    BNE +
    PHA                                       ; Spawn a mushroom once time to do so.
    JSR CODE_03A8D6
    PLA
  + STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0; Clear X/Y speed.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    CMP.B #$01                                ; Branch if done emerging Bowser.
    BEQ CODE_03A89D
    CMP.B #$40                                ; Branch if currently showing Peach.
    BCS CODE_03A8AE
    CMP.B #$3F
    BNE +                                     ; Handle starting the next attack phase's music.
    PHA
    LDY.W BowserMusicIndex
    LDA.W BowserSoundMusic-7,Y                ; Get music for Bowser's attack phase 2/3.
    STA.W SPCIO2                              ; / Change music
    PLA
  + LSR A
    LSR A
    LSR A                                     ; Set animation frame for Bowser emerging.
    TAY
    LDA.W DATA_03A437,Y
    STA.W SpriteMisc1570,X
    RTS

CODE_03A89D:
    LDA.W BowserMusicIndex                    ; Done emerging Bowser, go to attack phase.
    INC A
    STA.W SpriteMisc151C,X
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.B #$80                                ; How long Bowser waits before his next attack after swooping in.
    STA.W BowserWaitTimer
    RTS

CODE_03A8AE:
    CMP.B #$E8                                ; Still showing Peach.
    BNE +                                     ; Play sound for Peach emerging when time to do so.
    LDY.B #!SFX_PEACHHELP                     ; \ Play sound effect; SFX for Peach emerging from Bowser's car.
    STY.W SPCIO0                              ; /
  + SEC
    SBC.B #$3F                                ; Handle timer for Peach's "Help!" animation.
    STA.W SpriteMisc1594,X
    RTS


DATA_03A8BE:
    db $00,$00,$00,$08,$10,$14,$14,$16
    db $16,$18,$18,$17,$16,$16,$17,$18
    db $18,$17,$14,$10,$0C,$08,$04,$00

CODE_03A8D6:
; Additional Y offsets for Peach throughout her "Help!" animation.
    LDY.B #$07                                ; Subroutine to spawn Peach's mushroom.
CODE_03A8D8:
    LDA.W SpriteStatus,Y
    BEQ CODE_03A8E3                           ; Find an empty sprite slot and return if none found.
    DEY
    CPY.B #$01
    BNE CODE_03A8D8
    RTS

CODE_03A8E3:
    LDA.B #!SFX_MAGIC                         ; \ Play sound effect; Sound Peach makes when she throws a sprite.
    STA.W SPCIO0                              ; /
    LDA.B #$08                                ; \ Sprite status = Normal; Status of the sprite Peach throws.
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$74                                ; Sprite Peach throws.
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh,Y                    ; Spawn at Bowser/Peach's position.
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$18
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    LDA.B #$C0                                ; Initial Y speed for the mushroom thrown by Peach.
    STA.B SpriteYSpeed,X
    STZ.W SpriteMisc157C,X
    LDY.B #$0C                                ; Set initial X speed and direction based on the direction Peach threw the sprite?
    LDA.B SpriteXPosLow,X                     ; (which will always be left...)
    BPL +
    LDY.B #$F4                                ; X speed Peach throws the mushroom with.
    INC.W SpriteMisc157C,X
  + STY.B SpriteXSpeed,X
    PLX
    RTS


DATA_03A92E:
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $08,$00,$08,$00,$08,$00,$08,$00
    db $08,$00,$08,$00,$08,$00,$08,$00
    db $08,$00,$08,$00,$08,$00,$08,$00
    db $08,$00,$08,$00,$08,$00,$08,$00
DATA_03A97E:
    db $00,$00,$08,$08,$00,$00,$08,$08
    db $00,$00,$08,$08,$00,$00,$08,$08
    db $00,$00,$10,$10,$00,$00,$10,$10
    db $00,$00,$10,$10,$00,$00,$10,$10
    db $00,$00,$10,$10,$00,$00,$10,$10
    db $00,$00,$10,$10,$00,$00,$10,$10
    db $00,$00,$10,$10,$00,$00,$10,$10
    db $00,$00,$10,$10,$00,$00,$10,$10
    db $00,$00,$10,$10,$00,$00,$10,$10
    db $00,$00,$10,$10,$00,$00,$10,$10
DATA_03A9CE:
    db $05,$06,$15,$16,$9D,$9E,$4E,$AE
    db $06,$05,$16,$15,$9E,$9D,$AE,$4E
    db $8A,$8B,$AA,$68,$83,$84,$AA,$68
    db $8A,$8B,$80,$81,$83,$84,$80,$81
    db $85,$86,$A5,$A6,$83,$84,$A5,$A6
    db $82,$83,$A2,$A3,$82,$83,$A2,$A3
    db $8A,$8B,$AA,$68,$83,$84,$AA,$68
    db $8A,$8B,$80,$81,$83,$84,$80,$81
    db $85,$86,$A5,$A6,$83,$84,$A5,$A6
    db $82,$83,$A2,$A3,$82,$83,$A2,$A3
DATA_03AA1E:
    db $01,$01,$01,$01,$01,$01,$01,$01
    db $41,$41,$41,$41,$41,$41,$41,$41
    db $01,$01,$01,$01,$01,$01,$01,$01
    db $01,$01,$01,$01,$01,$01,$01,$01
    db $00,$00,$00,$00,$01,$01,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $41,$41,$41,$41,$41,$41,$41,$41
    db $41,$41,$41,$41,$41,$41,$41,$41
    db $40,$40,$40,$40,$41,$41,$40,$40
    db $40,$40,$40,$40,$40,$40,$40,$40

CODE_03AA6E:
; X offsets for Peach.
; 00 - Help A (left)
; 01 - Help B (left)
; 02 - Help A (right)
; 03 - Help B (right)
; 04 - Walking A
; 05 - Walking A, blinking
; 06 - Floating down
; 07 - Floating down, blinking
; 08 - Walking B
; 09 - Walking B, blinking
; 09 - Kiss (unused duplicate?)
; 0A - Kiss
; 0B - Leftwards - Walking A
; 0C - Leftwards - Walking A, blinking
; 0D - Leftwards - Floating down
; 0E - Leftwards - Floating down, blinking
; 0F - Leftwards - Walking B
; 10 - Leftwards - Walking B, blinking
; 11 - Leftwards - Kiss (unused duplicate?)
; 12 - Leftwards - Kiss
; Y offsets for Peach.
; 00 - Help A (left)
; 01 - Help B (left)
; 02 - Help A (right)
; 03 - Help B (right)
; 04 - Walking A
; 05 - Walking A, blinking
; 06 - Floating down
; 07 - Floating down, blinking
; 08 - Walking B
; 09 - Walking B, blinking
; 09 - Kiss (unused duplicate?)
; 0A - Kiss
; 0B - Leftwards - Walking A
; 0C - Leftwards - Walking A, blinking
; 0D - Leftwards - Floating down
; 0E - Leftwards - Floating down, blinking
; 0F - Leftwards - Walking B
; 10 - Leftwards - Walking B, blinking
; 11 - Leftwards - Kiss (unused duplicate?)
; 12 - Leftwards - Kiss
; Tile numbers for Peach.
; 00 - Help A (left)
; 01 - Help B (left)
; 02 - Help A (right)
; 03 - Help B (right)
; 04 - Walking A
; 05 - Walking A, blinking
; 06 - Floating down
; 07 - Floating down, blinking
; 08 - Walking B
; 09 - Walking B, blinking
; 09 - Kiss (unused duplicate?)
; 0A - Kiss
; 0B - Leftwards - Walking A
; 0C - Leftwards - Walking A, blinking
; 0D - Leftwards - Floating down
; 0E - Leftwards - Floating down, blinking
; 0F - Leftwards - Walking B
; 10 - Leftwards - Walking B, blinking
; 11 - Leftwards - Kiss (unused duplicate?)
; 12 - Leftwards - Kiss
; YXPPCCCT for Peach.
; 00 - Help A (left)
; 01 - Help B (left)
; 02 - Help A (right)
; 03 - Help B (right)
; 04 - Walking A
; 05 - Walking A, blinking
; 06 - Floating down
; 07 - Floating down, blinking
; 08 - Walking B
; 09 - Walking B, blinking
; 0A - Kiss (unused duplicate?)
; 0B - Kiss
; 0C - Rightwards - Walking A
; 0D - Rightwards - Walking A, blinking
; 0E - Rightwards - Floating down
; 0F - Rightwards - Floating down, blinking
; 10 - Rightwards - Walking B
; 11 - Rightwards - Walking B, blinking
; 12 - Rightwards - Kiss (unused duplicate?)
; 13 - Rightwards - Kiss
; Scratch RAM input:
; $02 = Additional Y offset for Peach
; $03 = Animation frame, for Peach (base timer / 4)
; Y   = Animation frame, for Peach's speech bubble (base timer / 8)
    LDA.B SpriteXPosLow,X                     ; Peach GFX routine, when in Bowser's clown car (includes "Help!" message).
    CLC
    ADC.B #$04                                ; $00 = onscreen X position
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$20
    SEC                                       ; $01 = onscreen Y position
    SBC.B _2
    SEC
    SBC.B Layer1YPos
    STA.B _1
    CPY.B #$08
    BCC +                                     ; Branch if not showing Peach's "Help!" speech bubble.
    CPY.B #$10
    BCS +
    LDA.B _0
    SEC
    SBC.B #$04
    STA.W OAMTileXPos+$A0                     ; Store X position to OAM for the speech bubble.
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$A4
    LDA.B _1
    SEC
    SBC.B #$18                                ; Store Y position to OAM for the speech bubble.
    STA.W OAMTileYPos+$A0
    STA.W OAMTileYPos+$A4
    LDA.B #$20                                ; Tile A for Peach's speech bubble.
    STA.W OAMTileNo+$A0
    LDA.B #$22                                ; Tile B for Peach's speech bubble.
    STA.W OAMTileNo+$A4
    LDA.B EffFrame
    LSR A
    AND.B #$06
    INC A                                     ; Store YXPPCCCT to OAM for the speech bubble, making it flash through palettes A-D.
    INC A
    INC A
    STA.W OAMTileAttr+$A0
    STA.W OAMTileAttr+$A4
    LDA.B #$02
    STA.W OAMTileSize+$28                     ; Store size to OAM as 16x16.
    STA.W OAMTileSize+$29
  + LDY.B #$70                                ; OAM index (from $0300) for Peach when in Bowser's clown car.
CODE_03AAC8:
    LDA.B _3                                  ; Peach GFX routine (even when out of Bowser's clown car). Note that Y, $00, $01, and $03 must be set up beforehand.
    ASL A                                     ; $04 = animation frame, x4
    ASL A
    STA.B _4
    PHX
    LDX.B #$03
CODE_03AAD1:
    PHX                                       ; Peach tile loop.
    TXA
    CLC
    ADC.B _4
    TAX                                       ; Store X position to OAM.
    LDA.B _0
    CLC
    ADC.W DATA_03A92E,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W DATA_03A97E,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DATA_03A9CE,X                       ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_03AA1E,X
    PHX
    LDX.W CurSpriteProcess                    ; X = Sprite index
    CPX.B #$09                                ; Store YXPPCCCT to OAM. If not in Bowser's car, give high priority.
    BEQ +
    ORA.B #$30
  + STA.W OAMTileAttr+$100,Y
    PLX
    PHY
    TYA
    LSR A
    LSR A                                     ; Store size to OAM as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY                                       ; Loop for all tiles.
    PLX
    DEX
    BPL CODE_03AAD1
    PLX
    RTS


DATA_03AB15:
    db $01,$FF

DATA_03AB17:
    db $20,$E0

DATA_03AB19:
    db $02,$FE

DATA_03AB1B:
    db $20,$E0,$01,$FF,$10,$F0

CODE_03AB21:
; X accelerations for Bowser in phase 2.
; Max X speeds for Bowser in phase 2.
; Y accelerations for Bowser in Phase 2.
; Max Y speeds for Bowser in phase 2.
; Unused acceleration and max speed values. Unknown what they would have been used by.
; Bowser phase 8 - Attack phase 2
    JSR CODE_03A4FD                           ; Prepare a MechaKoopa / Bowling Ball attack when time to.
    JSR CODE_03A4D2                           ; Animate Bowser's face.
    JSR CODE_03A4ED                           ; Face Mario.
    LDA.B TrueFrame
    AND.B #$00                                ; Branch if not a frame to apply acceleration (although this is every frame).
    BNE CODE_03AB4B
    LDY.B #$00
    LDA.B SpriteXPosLow,X
    CMP.B PlayerXPosNext
    LDA.W SpriteXPosHigh,X
    SBC.B PlayerXPosNext+1
    BMI +
    INY                                       ; Accelerate horizontally towards Mario, if not already at the max X speed.
  + LDA.B SpriteXSpeed,X
    CMP.W DATA_03AB17,Y
    BEQ CODE_03AB4B
    CLC
    ADC.W DATA_03AB15,Y
    STA.B SpriteXSpeed,X
CODE_03AB4B:
    LDY.B #$00
    LDA.B SpriteYPosLow,X
    CMP.B #$10
    BMI +
    INY
; Accelerate vertically around Y=10, if not already at the max Y speed.
  + LDA.B SpriteYSpeed,X                      ; (this creates Bowser's "wave" motion")
    CMP.W DATA_03AB1B,Y
    BEQ +
    CLC
    ADC.W DATA_03AB19,Y
    STA.B SpriteYSpeed,X
  + RTS


DATA_03AB62:
    db $10,$F0

CODE_03AB64:
; Bowser's X speeds for phase 3.
; Bowser phase 9 - Attack phase 3
    LDA.B #$03                                ; Set image to angry face.
    STA.W ClownCarImage
    JSR CODE_03A4FD                           ; Prepare a MechaKoopa attack when time to.
    JSR CODE_03A4D2                           ; Animate Bowser's face.
    JSR CODE_03A4ED                           ; Face Mario.
    LDA.B SpriteYSpeed,X
    CLC                                       ; Apply gravity.
    ADC.B #$03                                ; Downwards vertical acceleration for Bowser in phase 3.
    STA.B SpriteYSpeed,X
    LDA.B SpriteYPosLow,X
    CMP.B #con($64,$64,$64,$64,$74)
    BCC +
    LDA.W SpriteYPosHigh,X                    ; Return if not hitting the ground (at Y = 0x0064).
    BMI +
    LDA.B #$64
    STA.B SpriteYPosLow,X
    LDA.B #$A0                                ; Y speed to bounce Bowser up with.
    STA.B SpriteYSpeed,X
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect; SFX for slamming the ground.
    STA.W SPCIO3                              ; /
    JSR SubHorzPosBnk3
    LDA.W DATA_03AB62,Y                       ; Set X speed towards Mario.
    STA.B SpriteXSpeed,X
    LDA.B #$20                                ; \ Set ground shake timer; How long to shake the ground for.
    STA.W ScreenShakeTimer                    ; /
  + RTS

CODE_03AB9F:
; Bowser phase 4 - Rising up after being killed
    JSR CODE_03A6AC                           ; Show Bowser's hurt pose.
    LDA.W SpriteYPosHigh,X
    BMI CODE_03ABAF
    BNE +
    LDA.B SpriteYPosLow,X                     ; Continue to phase 5 if fully risen up (at Y = 0x0010)
    CMP.B #$10
    BCS +
CODE_03ABAF:
    LDA.B #$05                                ; Switch to phase 5 (death puffs).
    STA.W SpriteMisc151C,X
    LDA.B #con($60,$60,$60,$50,$50)           ; How long Bowser shows the death puffs for.
    STA.W SpriteMisc1540,X
  + LDA.B #$F8                                ; Y speed to give Bowser as he rises upwards at the end of the fight.
    STA.B SpriteYSpeed,X
    RTS

CODE_03ABBE:
; Bowser phase 5 - Defeated (cloud puffs, rotation)
    JSR CODE_03A6AC                           ; Show Bowser's hurt pose.
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0; Clear X/Y speed.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.W SpriteMisc1540,X                    ; Branch if still showing the cloud puffs.
    BNE CODE_03ABEB
    LDA.B Mode7Angle
    CLC
    ADC.B #$0A
    STA.B Mode7Angle                          ; Rotate Bowser, and return if not fully rotated upside-down.
    LDA.B Mode7Angle+1
    ADC.B #$00
    STA.B Mode7Angle+1
    BEQ +
    STZ.B Mode7Angle
    LDA.B #$20                                ; Set timer to wait before spawning Peach.
    STA.W SpriteMisc154C,X
    LDA.B #con($60,$60,$60,$50,$50)           ; Set timer to wait before flying away.
    STA.W SpriteMisc1540,X
    LDA.B #$06                                ; Switch to phase 6 (dropping peach / flying away).
    STA.W SpriteMisc151C,X
  + RTS

CODE_03ABEB:
; Still showing the cloud puffs / waiting to rotate.
    CMP.B #con($40,$40,$40,$30,$30)           ; Return if just waiting before rotating Bowser.
    BCC Return03AC02
    CMP.B #con($5E,$5E,$5E,$4A,$4A)
    BNE +                                     ; Change music when time to.
    LDY.B #!BGM_BOWSERDEFEATED                ; Music for defeating Bowser.
    STY.W SPCIO2                              ; / Change music
  + LDA.W SpriteMisc1564,X
    BNE Return03AC02                          ; Set timer for the cloud puffs.
    LDA.B #$12
    STA.W SpriteMisc1564,X
Return03AC02:
    RTS

CODE_03AC03:
; Bowser phase 6 - Dropping Peach and spinning away
    JSR CODE_03A6AC                           ; Show Bowser's hurt pose.
    LDA.W SpriteMisc154C,X
    CMP.B #$01                                ; Spawn Peach once time to do so.
    BNE +
    LDA.B #$0B                                ; Freeze Mario.
    STA.B PlayerAnimation
    INC.W FinalCutscene
    STZ.W BackgroundColor                     ; Clear lightning palette, just in case.
    STZ.W BackgroundColor+1
    LDA.B #$03                                ; Set flag to send Mario behind other sprites,
    STA.W PlayerBehindNet                     ; since most of Bowser's room will be moving the OAM range at $0300 in order to make room for the credits message.
    JSR CODE_03AC63
  + LDA.W SpriteMisc1540,X                    ; Return if not time to fly away.
    BNE Return03AC4C
    LDA.B #$FA                                ; X speed Bowser flies away with.
    STA.B SpriteXSpeed,X
    LDA.B #$FC                                ; Y speed Bowser flies away with.
    STA.B SpriteYSpeed,X
    LDA.B Mode7Angle
    CLC
    ADC.B #$05                                ; Speed at which Bowser spins as he flies away.
    STA.B Mode7Angle
    LDA.B Mode7Angle+1
    ADC.B #$00
    STA.B Mode7Angle+1
    LDA.B TrueFrame
    AND.B #$03
    BNE Return03AC4C
    LDA.B Mode7XScale                         ; Scale Bowser away.
    CMP.B #$80                                ; Branch if he's flown far enough away.
    BCS +
    INC.B Mode7XScale
    INC.B Mode7YScale
Return03AC4C:
    RTS

  + LDA.W SpriteInLiquid,X                    ; Done with Bowser's defeat movement; play "adventure is over" music.
    BNE +                                     ; Start the end music if it hasn't already.
    LDA.B #!BGM_PEACHSAVED                    ; SFX for the Peach kiss music.
    STA.W SPCIO2                              ; / Change music
    INC.W SpriteInLiquid,X
  + LDA.B #$FE
    STA.W SpriteXPosHigh,X                    ; Hide Bowser out of shot.
    STA.W SpriteYPosHigh,X
    RTS

CODE_03AC63:
    LDA.B #$08                                ; Routine to spawn Peach after defeating Bowser.
    STA.W SpriteStatus+8
    LDA.B #$7C                                ; Sprite ID (Peach) to spawn.
    STA.B SpriteNumber+8
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$08
    STA.B SpriteXPosLow+8
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh+8                    ; Spawn at Bowser's position.
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$47
    STA.B SpriteYPosLow+8
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh+8
    PHX
    LDX.B #$08
    JSL InitSpriteTables
    PLX
    RTS


BlushTileDispY:
    db $01,$11

BlushTiles:
    db $6E,$88

PrincessPeach:
; Y offsets for Mario's blush after Peach kisses him. Indexed by whether he's small or not.
; Tile numbers for Mario's blush after Peach kisses him. Indexed by whether he's small or not.
; Peach misc RAM:
; $C2   - Sprite phase.
; 0 = floating down, 1 = waiting after fall, 2 = walking towards Mario, 3 = standing next to Mario
; 4 = kissing Mario, 5 = displaying "Mario's adventure...", 6 = fading text, 7 = fireworks
; $151C - Flag to indicate Peach landed on top of Mario and should walk away from him.
; $1534 - Counter for the fireworks at the end.
; $1540 - Phase timer. In phase 5, it's also used for waiting between writing each letter.
; $154C - Timer for Peach's blink animation.
; $1558 - Timer for Mario's blush when Peach kisses him.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame.
; 0/1/2/3 = "Help!" animation, 4 = walk A, 6 = floating down, 8 = walk B, A = kiss
; $1FE2 - (using slot #9's) Timer for spawning fireworks after the fight.
    LDA.B SpriteXPosLow,X                     ; Princess Peach MAIN (also handles the "Mario's Adventure..." text)
    SEC                                       ; $00 = onscreen X position
    SBC.B Layer1XPos
    STA.B _0
    LDA.B SpriteYPosLow,X
    SEC                                       ; $01 = onscreen Y position
    SBC.B Layer1YPos
    STA.B _1
    LDA.B TrueFrame
    AND.B #$7F
    BNE +
    JSL GetRand                               ; Randomly make Peach blink.
    AND.B #$07
    BNE +
    LDA.B #$0C
    STA.W SpriteMisc154C,X
  + LDY.W SpriteMisc1602,X
    LDA.W SpriteMisc154C,X
    BEQ +
    INY
; Get animation frame.
  + LDA.W SpriteMisc157C,X                    ; If blinking, increment by 1.
    BNE +                                     ; If facing right, increment by 8.
    TYA
    CLC
    ADC.B #$08
    TAY
  + STY.B _3
    LDA.B #$D0                                ; OAM index (from $0300) for Peach when out of Bowser's car.
    STA.W SpriteOAMIndex,X
    TAY
    JSR CODE_03AAC8
    LDY.B #$02                                ; Draw GFX (4 16x16 tiles).
    LDA.B #$03
    JSL FinishOAMWrite
    LDA.W SpriteMisc1558,X                    ; Branch if the tiles for Mario's blush aren't being drawn.
    BEQ CODE_03AD18
    PHX
    LDX.B #$00
    LDA.B Powerup                             ; Get index to Y offsets based on Mario's powerup.
    BNE +
    INX
  + LDY.B #$4C                                ; OAM index (from $0300) of Mario's blush tile.
    LDA.B PlayerXPosScrRel                    ; Store X position for the blush to OAM.
    STA.W OAMTileXPos+$100,Y
    LDA.B PlayerYPosScrRel
    CLC                                       ; Store Y position for the blush to OAM.
    ADC.W BlushTileDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W BlushTiles,X                        ; Store tile number for the blush to OAM.
    STA.W OAMTileNo+$100,Y
    PLX
    LDA.B PlayerDirection
    CMP.B #$01
    LDA.B #$31
    BCC +                                     ; Store YXPPCCCT for the blush to OAM.
    ORA.B #$40
  + STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A                                     ; Store size to OAM as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
CODE_03AD18:
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0; Clear Mario and Peach's X speeds.
    STZ.B PlayerXSpeed+1
    LDA.B #$04                                ; Set base animation frame.
    STA.W SpriteMisc1602,X
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_03AD37
    dw CODE_03ADB3
    dw CODE_03ADDD
    dw CODE_03AE25
    dw CODE_03AE32
    dw CODE_03AEAF
    dw CODE_03AEE8
    dw CODE_03C796

CODE_03AD37:
; Peach phase pointers.
; 0 - Floating down
; 1 - Waiting after fall
; 2 - Walking toward Mario
; 3 - Standing next to Mario
; 4 - Kissing Mario (and slightly after)
; 5 - Displaying the "Mario's adventure is over..." text
; 6 - Fade text
; 7 - Fireworks sequence
; Peach phase 0 - Floating down
    LDA.B #$06                                ; Animation frame for Peach floating down.
    STA.W SpriteMisc1602,X
    JSL UpdateYPosNoGvtyW                     ; Update Y position.
    LDA.B SpriteYSpeed,X
    CMP.B #$08                                ; Max X speed for Peach as she falls.
    BCS +
    CLC
    ADC.B #$01                                ; X acceleration for Peach as she falls.
    STA.B SpriteYSpeed,X
  + LDA.W SpriteYPosHigh,X
    BMI +
    LDA.B SpriteYPosLow,X
    CMP.B #con($A0,$A0,$A0,$A0,$B0)
    BCC +                                     ; If on the ground (at Y = 0x00A0), increment to next phase.
    LDA.B #con($A0,$A0,$A0,$A0,$B0)
    STA.B SpriteYPosLow,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.B #$A0                                ; How long Peach waits on the ground before walking towards Mario.
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + LDA.B TrueFrame
    AND.B #$07                                ; Return if not a frame to spawn one of Peach's sparkles.
    BNE Return03AD73
    LDY.B #$0B
CODE_03AD6B:
    LDA.W MinExtSpriteNumber,Y
    BEQ CODE_03AD74                           ; Find an empty minor extended sprite slot and return if none found.
    DEY
    BPL CODE_03AD6B
Return03AD73:
    RTS

CODE_03AD74:
    LDA.B #$05                                ; Minor extended sprite to spawn (sparkle).
    STA.W MinExtSpriteNumber,Y
    JSL GetRand
    STZ.B _0
    AND.B #$1F
    CLC
    ADC.B #$F8
    BPL +
    DEC.B _0                                  ; Set at a random X position on Peach.
  + CLC
    ADC.B SpriteXPosLow,X
    STA.W MinExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B _0
    STA.W MinExtSpriteXPosHigh,Y
    LDA.W RandomNumber+1
    AND.B #$1F
    ADC.B SpriteYPosLow,X
    STA.W MinExtSpriteYPosLow,Y               ; Set at a random Y position on Peach.
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W MinExtSpriteYPosHigh,Y
    LDA.B #$00                                ; Clear sprite Y speed (unused?).
    STA.W MinExtSpriteYSpeed,Y
    LDA.B #$17                                ; Lifespan timer for Peach's sparkles.
    STA.W MinExtSpriteTimer,Y
    RTS

CODE_03ADB3:
    LDA.W SpriteMisc1540,X                    ; Peach state 1 - Waiting after falling
    BNE +
    INC.B SpriteTableC2,X                     ; If time to walk towards Mario, increment to next phase.
    JSR CODE_03ADCC                           ; In doing so, if already on top of Mario, set flag to walk away from him.
    BCC +
    INC.W SpriteMisc151C,X
  + JSR SubHorzPosBnk3
    TYA                                       ; Face Mario and Peach towards each other.
    STA.W SpriteMisc157C,X
    STA.B PlayerDirection
    RTS

CODE_03ADCC:
    JSL GetSpriteClippingA
    JSL GetMarioClipping
    JSL CheckForContact
    RTS


DATA_03ADD9:
    db $08,$F8,$F8,$08

CODE_03ADDD:
; X speeds for Mario and Peach when walking towards each other. Only the first two values seem to be used.
    LDA.B EffFrame                            ; Peach phase 2 - Walking toward Mario
    AND.B #$08
    BNE +                                     ; Animate Peach walking.
    LDA.B #$08
    STA.W SpriteMisc1602,X
  + JSR CODE_03ADCC
    PHP
    JSR SubHorzPosBnk3
    PLP                                       ; Figure out how to move Peach and Mario.
    LDA.W SpriteMisc151C,X                    ; If Peach wasn't in contact with him and still isn't, make them walk towards each other.
    BNE ADDR_03ADF9                           ; If Peach was in contact with him and still is, make them walk away from each other.
    BCS CODE_03AE14                           ; If Peach wasn't in contact with him and now is (or was in contact and now isn't), branch to end the phase.
    BRA CODE_03ADFF

ADDR_03ADF9:
    BCC CODE_03AE14
    TYA
    EOR.B #$01
    TAY
CODE_03ADFF:
    LDA.W DATA_03ADD9,Y                       ; Store X speed for Mario and Peach as decided.
    STA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.B PlayerXSpeed+1
    TYA
    STA.W SpriteMisc157C,X                    ; Make Mario/Peach face the way they're walking.
    STA.B PlayerDirection
    JSL UpdateXPosNoGvtyW                     ; Update X position for Peach.
    RTS

CODE_03AE14:
    JSR SubHorzPosBnk3                        ; Peach and Mario are right next to each other; end the phase.
    TYA                                       ; Face Mario and Peach towards each other again.
    STA.W SpriteMisc157C,X
    STA.B PlayerDirection
    INC.B SpriteTableC2,X                     ; Increment to next phase.
    LDA.B #$60                                ; How long Peach waits to kiss Mario.
    STA.W SpriteMisc1540,X
    RTS

CODE_03AE25:
; Peach phase 3 - Standing next to Mario
    LDA.W SpriteMisc1540,X                    ; Return if not time to kiss Mario.
    BNE +
    INC.B SpriteTableC2,X                     ; Increment to next phase.
    LDA.B #$A0                                ; Set timer for the kiss animation.
    STA.W SpriteMisc1540,X
  + RTS

CODE_03AE32:
    LDA.W SpriteMisc1540,X                    ; Peach phase 4 - Kissing Mario
    BNE +                                     ; Increment to next phase if done kissing Mario.
    INC.B SpriteTableC2,X
    STZ.W Empty188A                           ; Unused...?
    STZ.W ScrShakePlayerYOffset
  + CMP.B #$50                                ; Return if done animating Peach's part of the kiss.
    BCC Return03AE5A
    PHA
    BNE +                                     ; Force timer for Peach's blink animation when the kiss ends (so Peach has her eyes closed).
    LDA.B #$14
    STA.W SpriteMisc154C,X
  + LDA.B #$0A                                ; Animation frame to use for Peach's kiss.
    STA.W SpriteMisc1602,X
    PLA
    CMP.B #$68
    BNE Return03AE5A                          ; Set timer for Mario's blush animation when time to.
    LDA.B #$80
    STA.W SpriteMisc1558,X
Return03AE5A:
    RTS


if ver_is_japanese(!_VER)                     ;\======================= J =====================
DATA_03AE5B:                                  ;!
    db $08,$08,$00,$10,$08,$08,$00,$08        ;!
    db $08,$08,$08,$08,$08,$00,$08,$08        ;!
    db $08,$08,$10,$08,$08,$08,$00,$08        ;!
    db $03,$38,$04,$10,$04,$10,$0C,$08        ;!
    db $08,$08,$08,$08,$08,$04,$0C,$04        ;!
    db $10,$00,$08,$08,$08,$08,$08,$08        ;!
    db $08,$08,$08,$00,$08,$08,$08,$03        ;!
    db $08,$08,$00,$10,$08,$08,$08,$00        ;!
    db $08,$08,$00,$08,$08,$08,$08,$40        ;!
    db $10,$10,$10,$C0                        ;!
elseif ver_is_pal(!_VER)                      ;<===================== E0 & E1 =================
DATA_03AE5B:                                  ;!
    db $05,$05,$05,$05,$05,$05,$10,$05        ;!
    db $05,$05,$05,$05,$05,$05,$05,$05        ;!
    db $08,$05,$05,$05,$05,$05,$14,$08        ;!
    db $05,$05,$05,$05,$14,$05,$05,$08        ;!
    db $05,$05,$05,$05,$05,$05,$05,$05        ;!
    db $14,$05,$05,$05,$05,$05,$14,$05        ;!
    db $03,$14,$05,$05,$05,$05,$05,$05        ;!
    db $05,$05,$05,$05,$05,$05,$08,$05        ;!
    db $05,$05,$05,$05,$05,$05,$05,$05        ;!
    db $05,$05,$08,$05,$05,$05,$05,$05        ;!
    db $05,$05,$05,$50                        ;!
else                                          ;<====================== U & SS =================
DATA_03AE5B:                                  ;!
    db $08,$08,$08,$08,$08,$08,$18,$08        ;!
    db $08,$08,$08,$08,$08,$08,$08,$08        ;!
    db $08,$08,$08,$08,$08,$08,$20,$08        ;!
    db $08,$08,$08,$08,$20,$08,$08,$10        ;!
    db $08,$08,$08,$08,$08,$08,$08,$08        ;!
    db $20,$08,$08,$08,$08,$08,$20,$08        ;!
    db $04,$20,$08,$08,$08,$08,$08,$08        ;!
    db $08,$08,$08,$08,$08,$08,$10,$08        ;!
    db $08,$08,$08,$08,$08,$08,$08,$08        ;!
    db $08,$08,$10,$08,$08,$08,$08,$08        ;!
    db $08,$08,$08,$40                        ;!
endif                                         ;/===============================================

CODE_03AEAF:
; How long to wait between each letter.
; Peach phase 5 - Displaying the "Mario's adventure..." text.
    JSR CODE_03D674                           ; Write the message text so far.
    LDA.W SpriteMisc1540,X                    ; Return if not time to write the next letter.
    BNE Return03AEC7
    LDY.W FinalMessageTimer
    CPY.B #con($4C,$54,$54,$54,$54)           ; Branch if message is finished.
    BEQ +
    INC.W FinalMessageTimer
    LDA.W DATA_03AE5B,Y                       ; Add a new letter and set timer until the next one.
    STA.W SpriteMisc1540,X
Return03AEC7:
    RTS

; Done with the message.
  + INC.B SpriteTableC2,X                     ; Increment to next phase.
    LDA.B #$40                                ; How long the game takes to fade the message away.
    STA.W SpriteMisc1540,X
    RTS

; Time to shoot fireworks.
  - INC.B SpriteTableC2,X                     ; Increment to next phase (7).
    LDA.B #$80                                ; How long until the first firework is shot.
    STA.W SpriteMisc1FE2+9
    RTS


    db $00,$00,$94,$18,$18,$9C,$9C,$FF
    db $00,$00,$52,$63,$63,$73,$73,$7F

CODE_03AEE8:
; Peach phase 6 - Fade text
    LDA.W SpriteMisc1540,X                    ; Branch if done fading.
    BEQ -
    LSR A
    STA.B _0
    STZ.B _1                                  ; Fade the message text.
    REP #$20                                  ; A->16
    LDA.B _0
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    ORA.B _0                                  ; Take current timer divided by 2 (rounded down), and multiply by 0x421.
    STA.B _0
    ASL A                                     ; This gets the shade of white to use for the text currently,
    ASL A                                     ; e.g. if timer is 3F (max) -> 1F -> 7FFF (full white)
    ASL A
    ASL A
    ASL A
    ORA.B _0
    STA.B _0
    SEP #$20                                  ; A->8
    PHX
    TAX
    LDY.W DynPaletteIndex
    LDA.B #$02                                ; Transfer one color...
    STA.W DynPaletteTable,Y
    LDA.B #$F1                                ; ...to color F1.
    STA.W DynPaletteTable+1,Y
    LDA.B _0
    STA.W DynPaletteTable+2,Y                 ; Write the value calculated before.
    LDA.B _1
    STA.W DynPaletteTable+3,Y
    LDA.B #$00                                ; Write end sentinel.
    STA.W DynPaletteTable+4,Y
    TYA
    CLC
    ADC.B #$04
    STA.W DynPaletteIndex
    PLX
    JSR CODE_03D674                           ; Keep the message text written while it fades.
    RTS


DATA_03AF34:
    db $F4,$FF,$0C,$19,$24,$19,$0C,$FF
DATA_03AF3C:
    db $FC,$F6,$F4,$F6,$FC,$02,$04,$02
DATA_03AF44:
    db $05,$05,$05,$05,$45,$45,$45,$45
DATA_03AF4C:
    db $34,$34,$34,$35,$35,$36,$36,$37
    db $38,$3A,$3E,$46,$54

CODE_03AF59:
; X offsets for the animation of the stars above Bowser's head when hurt.
; Y offsets for the animation of the stars above Bowser's head when hurt.
; YXPPCCCT for the animation of the stars above Bowser's head when hurt.
; Y offsets for the teardrop on Bowser's head when hurt.
    JSR GetDrawInfoBnk3                       ; Subroutine to draw the spinning stars and teardrop above Bowser's head when hurt.
    LDA.W SpriteMisc157C,X                    ; $04 = horizontal direction
    STA.B _4
    LDA.B EffFrame
    LSR A
    LSR A                                     ; $02 = animation frame
    AND.B #$07
    STA.B _2
    LDA.B #$EC                                ; OAM index (from $0300) to use for the stars above Bowser's head.
    STA.W SpriteOAMIndex,X
    TAY
    PHX
    LDX.B #$03
  - PHX                                       ; Tile loop for the stars.
    TXA
    ASL A
    ASL A                                     ; Get index to the current tile.
    ADC.B _2
    AND.B #$07
    TAX
    LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W DATA_03AF34,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W DATA_03AF3C,X
    STA.W OAMTileYPos+$100,Y
    LDA.B #$59                                ; Tile number to use for the stars above Bowser's head.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_03AF44,X
    ORA.B SpriteProperties                    ; Store YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    PLX
    INY
    INY
    INY                                       ; Loop for all four stars.
    INY
    DEX
    BPL -
    LDA.W ClownCarTeardropPos
    INC.W ClownCarTeardropPos
    LSR A
    LSR A                                     ; Branch if not showing the teardrop on Bowser's head.
    LSR A
    CMP.B #$0D
    BCS +
    TAX
    LDY.B #$FC                                ; OAM index (from $0300) to use for Bowser's teardrop.
    LDA.B _4
    ASL A
    ROL A
    ASL A
    ASL A                                     ; Store X position to OAM.
    ASL A
    ADC.B _0
    CLC
    ADC.B #$15
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.L DATA_03AF4C,X
    STA.W OAMTileYPos+$100,Y
    LDA.B #$49                                ; Tile to use for the teardrop on Bowser's head.
    STA.W OAMTileNo+$100,Y
    LDA.B #$07
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
  + PLX                                       ; Not drawing the teardrop.
    LDY.B #$00
    LDA.B #$04                                ; Upload 5 8x8 tiles (4 stars + teardrop).
    JSL FinishOAMWrite
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    LDX.B #$04
  - LDA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos,Y
    LDA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos,Y
    LDA.W OAMTileNo+$100,Y
    STA.W OAMTileNo,Y
    LDA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr,Y
    PHY
    TYA                                       ; Transfer all of the tiles just written from the $0300 range to the $0200 range.
    LSR A                                     ; (probably because Nintendo didn't bother to code a FinishOamWrite for that range....)
    LSR A
    TAY
    LDA.W OAMTileSize+$40,Y
    STA.W OAMTileSize,Y
    PLY
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    RTS


DATA_03B013:
    db $00,$10

DATA_03B015:
    db $00,$00

DATA_03B017:
    db $F8,$08

CODE_03B019:
; X offsets (lo) for the MechaKoopas thrown by Bowser.
; X offsets (hi) for the MechaKoopas thrown by Bowser.
; X speeds for the MechaKoopas thrown by Bowser.
    STZ.B _2                                  ; Subroutine to spawn Bowser's MechaKoopas.
    JSR CODE_03B020
    INC.B _2
CODE_03B020:
    LDY.B #$01
CODE_03B022:
    LDA.W SpriteStatus,Y
    BEQ CODE_03B02B                           ; Find an empty sprite slot (in slots 0/1) and return if none found.
    DEY
    BPL CODE_03B022
    RTS

CODE_03B02B:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$A2                                ; Sprite to spawn (MechaKoopa).
    STA.W SpriteNumber,Y
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$10
    STA.W SpriteYPosLow,Y                     ; Spawn at Bowser's Y position.
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    PHX
    LDX.B _2
    LDA.B _0                                  ; Spawn at Bowser's X position, offset to either side.
    CLC
    ADC.W DATA_03B013,X
    STA.W SpriteXPosLow,Y
    LDA.B _1
    ADC.W DATA_03B015,X
    STA.W SpriteXPosHigh,Y
    TYX
    JSL InitSpriteTables
    LDY.B _2
    LDA.W DATA_03B017,Y                       ; Store initial X speed.
    STA.B SpriteXSpeed,X
    LDA.B #$C0                                ; Y speed Bowser throws the MechaKoopas with.
    STA.B SpriteYSpeed,X
    PLX
    RTS


DATA_03B074:
    db $40,$C0

DATA_03B076:
    db $10,$F0

CODE_03B078:
; X speeds to give Mario when he runs into Bowser's car normally.
; X speeds to give Mario when he runs into Bowser's car while it's attacking (MechaKoopa/Bowling Balls).
    LDA.B Mode7XScale                         ; Subroutine to process interaction for Bowser and his car with Mario.
    CMP.B #$20                                ; Return if Bowser isn't exactly scaled to 0x20 (i.e. he's zooming in/out).
    BNE Return03B0DB
    LDA.W SpriteMisc151C,X
    CMP.B #$07                                ; Return if not in an attack phase.
    BCC Return03B0F2
    LDA.B Mode7Angle
    ORA.B Mode7Angle+1                        ; Return if Bowser is rotated at all (e.g. hurt animation, dropping a Bowling Ball).
    BNE Return03B0F2
    JSR CODE_03B0DC                           ; Process interaction with MechaKoopas.
    LDA.W SpriteMisc154C,X                    ; Return if contact is disabled with Mario.
    BNE Return03B0DB
    LDA.B #$24                                ; Change sprite clipping (for interaction with the actual car).
    STA.W SpriteTweakerB,X
    JSL MarioSprInteract                      ; Return if Mario isn't in contact with the car.
    BCC CODE_03B0BD
    JSR CODE_03B0D6                           ; Disable additional contact with Mario.
    STZ.B PlayerYSpeed+1                      ; Clear Mario's Y speed.
    JSR SubHorzPosBnk3
    LDA.W BowserAttackTimer
    ORA.W BowserSteelieTimer
    BEQ CODE_03B0B3
    LDA.W DATA_03B076,Y                       ; Push Mario away from the car.
    BRA +                                     ; Speed Mario is pushed depends on whether the car is moving normally or attacking (with MechaKoopas or a bowling ball)

CODE_03B0B3:
    LDA.W DATA_03B074,Y
  + STA.B PlayerXSpeed+1
    LDA.B #!SFX_BONK                          ; \ Play sound effect; SFX for Mario hitting Bowser's car.
    STA.W SPCIO0                              ; /
CODE_03B0BD:
    INC.W SpriteTweakerB,X
    JSL MarioSprInteract                      ; If Mario is in contact with Bowser, hurt him, and disable additional contact with Mario.
    BCC +
    JSR CODE_03B0D2
  + INC.W SpriteTweakerB,X
    JSL MarioSprInteract
    BCC Return03B0DB
CODE_03B0D2:
    JSL HurtMario                             ; If Mario is in contact with Bowser's propeller, hurt him, and disable additional contact with Mario.
CODE_03B0D6:
    LDA.B #$20
    STA.W SpriteMisc154C,X
Return03B0DB:
    RTS

CODE_03B0DC:
    LDY.B #$01                                ; Subroutine to process interaction between Bowser and MechaKoopas.
CODE_03B0DE:
    PHY
    LDA.W SpriteStatus,Y
    CMP.B #$09
    BNE +
    LDA.W SpriteOffscreenX,Y                  ; Loop through the two MechaKoopa slots and run the below code for any that exist and aren't offscreen.
    BNE +
    JSR CODE_03B0F3
  + PLY
    DEY
    BPL CODE_03B0DE
Return03B0F2:
    RTS

CODE_03B0F3:
    PHX                                       ; MechaKoopa found.
    TYX
    JSL GetSpriteClippingB
    PLX
    LDA.B #$24
    STA.W SpriteTweakerB,X                    ; Branch if in contact with the car (not the top!).
    JSL GetSpriteClippingA
    JSL CheckForContact
    BCS CODE_03B142
    INC.W SpriteTweakerB,X
    JSL GetSpriteClippingA                    ; Return if not in contact with Bowser either.
    JSL CheckForContact
    BCC Return03B160
    LDA.W BowserHurtState                     ; Return if Bowser is already in his hurt state.
    BNE Return03B160
    LDA.B #$4C                                ; How long Bowser's hurt animation lasts.
    STA.W BowserHurtState
    STZ.W ClownCarTeardropPos
    LDA.W SpriteMisc151C,X                    ; Track the phase that was just defeated (for changing music later).
    STA.W BowserMusicIndex
    LDA.B #!SFX_ENEMYHURT                     ; \ Play sound effect; SFX for hitting Bowser with a MechaKoopa.
    STA.W SPCIO3                              ; /
    LDA.W SpriteMisc151C,X
    CMP.B #$09
    BNE CODE_03B142
    LDA.W SpriteMisc187B,X
    CMP.B #$01                                ; If Bowser was hit in attack phase 3 on his last hit, kill all of the remaining MechaKoopas.
    BNE CODE_03B142
    PHY
    JSL KillMostSprites
    PLY
CODE_03B142:
; MechaKoopa hit the car, not Bowser.
    LDA.B #$00                                ; Clear its X speed.
    STA.W SpriteXSpeed,Y
    PHX
    LDX.B #$10                                ; Y speed to give the MechaKoopa when it hits Bowser while moving up.
    LDA.W SpriteYSpeed,Y
    BMI +
    LDX.B #$D0                                ; Y speed to give the MechaKoopa when it hits Bowser while moving down.
  + TXA
    STA.W SpriteYSpeed,Y
    LDA.B #$02                                ; \ Sprite status = Killed; Kill the MechaKoopa.
    STA.W SpriteStatus,Y                      ; /
    TYX
    JSL CODE_01AB6F                           ; Display a contact sprite at the MechaKoopa's position.
    PLX
Return03B160:
    RTS


BowserBallSpeed:
    db $10,$F0

BowserBowlingBall:
; X speeds for Bowser's bowling ball.
; Bowser's Bowling Ball misc RAM:
; $1570 - Frame counter for animating the ball's shine. Increments or decrements depending on the direction the ball is rolling.
; Bowser's Bowling Ball MAIN
    JSR BowserBallGfx                         ; Draw GFX.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return03B1D4
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    JSL MarioSprInteract                      ; Process interaction with Mario.
    JSL UpdateXPosNoGvtyW                     ; Update X position.
    JSL UpdateYPosNoGvtyW                     ; Update Y position.
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL CODE_03B186                           ; Handle Y speed.
    CLC
    ADC.B #$03                                ; Vertical acceleration for the Bowling ball.
    STA.B SpriteYSpeed,X
    BRA +

CODE_03B186:
    LDA.B #$40
    STA.B SpriteYSpeed,X
  + LDA.B SpriteYSpeed,X
    BMI CODE_03B1C5
    LDA.W SpriteYPosHigh,X
    BMI CODE_03B1C5                           ; Branch if the ball isn't at the "ground" position, or it's already moving upwards.
    LDA.B SpriteYPosLow,X
    CMP.B #con($B0,$B0,$B0,$B0,$C0)
    BCC CODE_03B1C5
    LDA.B #con($B0,$B0,$B0,$B0,$C0)           ; Lock the ball to the "ground" position.
    STA.B SpriteYPosLow,X
    LDA.B SpriteYSpeed,X
    CMP.B #$3E                                ; Branch if the ball isn't falling fast enough for the large bounce.
    BCC +
    LDY.B #!SFX_YOSHISTOMP                    ; \ Play sound effect; SFX for Bowser's ball's first bounce (the "slam").
    STY.W SPCIO3                              ; /
    LDY.B #$20                                ; \ Set ground shake timer; How long the screen shakes after the bowling ball slams the ground.
    STY.W ScreenShakeTimer                    ; /
  + CMP.B #$08
    BCC +                                     ; Branch if not falling fast enough for the smaller bounce.
    LDA.B #!SFX_BONK                          ; \ Play sound effect; SFX for Bowser's bowling ball's second bounce.
    STA.W SPCIO0                              ; /
  + JSR CODE_03B7F8                           ; Handle bouncing the ball.
    LDA.B SpriteXSpeed,X
    BNE CODE_03B1C5
    JSR SubHorzPosBnk3                        ; If the sprite doesn't already have an X speed set, make it move towards Mario.
    LDA.W BowserBallSpeed,Y
    STA.B SpriteXSpeed,X
CODE_03B1C5:
    LDA.B SpriteXSpeed,X                      ; Return if the ball still has no X speed (i.e. it's still in the initial fall from Bowser's clown car).
    BEQ Return03B1D4
    BMI +
    DEC.W SpriteMisc1570,X
    DEC.W SpriteMisc1570,X                    ; Handle timing the rolling animation.
  + INC.W SpriteMisc1570,X
Return03B1D4:
    RTS


BowserBallDispX:
    db $F0,$00,$10,$F0,$00,$10,$F0,$00
    db $10,$00,$00,$F8

BowserBallDispY:
    db $E2,$E2,$E2,$F2,$F2,$F2,$02,$02
    db $02,$02,$02,$EA

BowserBallTiles:
    db $45,$47,$45,$65,$66,$65,$45,$47
    db $45,$39,$38,$63

BowserBallGfxProp:
    db $0D,$0D,$4D,$0D,$0D,$4D,$8D,$8D
    db $CD,$0D,$0D,$0D

BowserBallTileSize:
    db $02,$02,$02,$02,$02,$02,$02,$02
    db $02,$00,$00,$02

BowserBallDispX2:
    db $04,$0D,$10,$0D,$04,$FB,$F8,$FB
BowserBallDispY2:
    db $00,$FD,$F4,$EB,$E8,$EB,$F4,$FD

BowserBallGfx:
; X offsets for each tile of Bowser's bowling ball.
; Y offsets for each tile of Bowser's bowling ball.
; Tile numbers for each tile of Bowser's bowling ball.
; YXPPCCCT for each tile of Bowser's bowling ball.
; Tile size for each tile of Bowser's bowling ball.
; X offsets for animation fo the "shine" on Bowser's bowling ball.
; Y offsets for animation fo the "shine" on Bowser's bowling ball.
; Bowser's bowling ball GFX routine
    LDA.B #$70                                ; OAM index (from $0300) for Bowser's bowling ball.
    STA.W SpriteOAMIndex,X
    JSR GetDrawInfoBnk3
    PHX
    LDX.B #$0B
  - LDA.B _0                                  ; Tile loop.
    CLC                                       ; Store X position to OAM.
    ADC.W BowserBallDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W BowserBallDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W BowserBallTiles,X                   ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.W BowserBallGfxProp,X
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Store tile size to OAM.
    TAY
    LDA.W BowserBallTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL -
    PLX
    PHX
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc1570,X
    LSR A
    LSR A
    LSR A                                     ; Get index for the animation of the ball's "shine" tiles.
    AND.B #$07
    PHA
    TAX
    LDA.W OAMTileXPos+$104,Y
    CLC                                       ; Change X position of the second tile in OAM.
    ADC.W BowserBallDispX2,X
    STA.W OAMTileXPos+$104,Y
    LDA.W OAMTileYPos+$104,Y
    CLC                                       ; Change Y position of the second tile in OAM.
    ADC.W BowserBallDispY2,X
    STA.W OAMTileYPos+$104,Y
    PLA
    CLC
    ADC.B #$02
    AND.B #$07
    TAX
    LDA.W OAMTileXPos+$108,Y
    CLC                                       ; Change X position of the third tile in OAM.
    ADC.W BowserBallDispX2,X
    STA.W OAMTileXPos+$108,Y
    LDA.W OAMTileYPos+$108,Y
    CLC                                       ; Change Y position of the third tile in OAM.
    ADC.W BowserBallDispY2,X
    STA.W OAMTileYPos+$108,Y
    PLX
    LDA.B #$0B
    LDY.B #$FF                                ; Upload 12 manually-sized tiles.
    JSL FinishOAMWrite
    RTS


MechakoopaSpeed:
    db $08,$F8

MechaKoopa:
; X speeds for the MechaKoopa.
; MechaKoopa misc RAM:
; $C2   - Frame counter for deciding when to turn towards Mario.
; $1540 - Timer to wait before returning a stunned MechaKoopa to normal.
; $1570 - Frame counter for animation,
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame. 0/1/2/3 = walking, 4 = being stunned, 5 = stunned
; $1FE2 - Timer set after hitting a block in its stunned state.
; MechaKoopa MAIN
    JSL CODE_03B307                           ; Draw GFX.
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return03B306                          ; Return if dying or game frozen.
    LDA.B SpriteLock
    BNE Return03B306
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Process interaction with Mario and other sprites.
    JSL UpdateSpritePos                       ; Update X/Y position, apply gravity, and process block interaction.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Branch if not on the ground.
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDY.W SpriteMisc157C,X
    LDA.W MechakoopaSpeed,Y                   ; Set X speed.
    STA.B SpriteXSpeed,X
    LDA.B SpriteTableC2,X
    INC.B SpriteTableC2,X
    AND.B #$3F
    BNE +                                     ; Every 64 frames, turn towards Mario.
    JSR SubHorzPosBnk3
    TYA
    STA.W SpriteMisc157C,X
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    LDA.B SpriteXSpeed,X
    EOR.B #$FF                                ; If hitting a wall, invert X speed and facing direction.
    INC A
    STA.B SpriteXSpeed,X
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    AND.B #$0C                                ; Animate the MechaKoopa's walk animation.
    LSR A
    LSR A
    STA.W SpriteMisc1602,X
Return03B306:
    RTS

CODE_03B307:
    PHB                                       ; Wrapper; MechaKoopa GFX routine.
    PHK
    PLB
    JSR MechaKoopaGfx
    PLB
    RTL


MechakoopaDispX:
    db $F8,$08,$F8,$00,$08,$00,$10,$00
MechakoopaDispY:
    db $F8,$F8,$08,$00,$F9,$F9,$09,$00
    db $F8,$F8,$08,$00,$F9,$F9,$09,$00
    db $FD,$00,$05,$00,$00,$00,$08,$00
MechakoopaTiles:
    db $40,$42,$60,$51,$40,$42,$60,$0A
    db $40,$42,$60,$0C,$40,$42,$60,$0E
    db $00,$02,$10,$01,$00,$02,$10,$01
MechakoopaGfxProp:
    db $00,$00,$00,$00,$40,$40,$40,$40
MechakoopaTileSize:
    db $02,$00,$00,$02

MechakoopaPalette:
    db $0B,$05

MechaKoopaGfx:
; X offsets for the MechaKoopa, indexed by its direction.
; Y offsets for each frame of the MechaKoopa.
; Tile numbers for each frame of the MechaKoopa.
; YXPPCCCT for the MechaKoopa, indexed by its direction.
; Tile sizes for each tile of the MechaKoopa.
; YXPPCCCT for the MechaKoopa to flash between when its stun timer runs low.
; Actual MechaKoopa GFX routine.
    LDA.B #$0B                                ; Normal YXPPCCCT for the MechaKoopa.
    STA.W SpriteOBJAttribute,X
    LDA.W SpriteMisc1540,X                    ; Branch if not stunned.
    BEQ CODE_03B37F
    LDY.B #$05
    CMP.B #$05
    BCC CODE_03B369
    CMP.B #$FA
    BCC +                                     ; Animate the MechaKoopa's key.
CODE_03B369:
    LDY.B #$04
  + TYA
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    CMP.B #$30
    BCS CODE_03B37F
    AND.B #$01                                ; Animate the MechaKoopa's palette as its stun tiemr runs low.
    TAY
    LDA.W MechakoopaPalette,Y
    STA.W SpriteOBJAttribute,X
CODE_03B37F:
    JSR GetDrawInfoBnk3                       ; Not stunned.
    LDA.W SpriteOBJAttribute,X                ; $04 = YXPPCCCT
    STA.B _4
    TYA
    CLC
    ADC.B #$0C
    TAY
    LDA.W SpriteMisc1602,X
    ASL A                                     ; $03 = animation frame
    ASL A
    STA.B _3
    LDA.W SpriteMisc157C,X
    ASL A
    ASL A                                     ; $02 = horizontal direction
    EOR.B #$04
    STA.B _2
    PHX
    LDX.B #$03
  - PHX                                       ; Tile loop
    PHY
    TYA
    LSR A
    LSR A                                     ; Store size to OAM.
    TAY
    LDA.W MechakoopaTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    PLA
    PHA
    CLC
    ADC.B _2
    TAX                                       ; Store X position to OAM.
    LDA.B _0
    CLC
    ADC.W MechakoopaDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.W MechakoopaGfxProp,X
    ORA.B _4                                  ; Store YXPPCCCT to OAM.
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLA
    PHA
    CLC
    ADC.B _3                                  ; Store tile number to OAM.
    TAX
    LDA.W MechakoopaTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W MechakoopaDispY,X
    STA.W OAMTileYPos+$100,Y
    PLX
    DEY
    DEY
    DEY                                       ; Loop for all four tiles.
    DEY
    DEX
    BPL -
    PLX
    LDY.B #$FF
    LDA.B #$03                                ; Upload 4 manually-sized tiles.
    JSL FinishOAMWrite
    JSR MechaKoopaKeyGfx                      ; Draw the MechaKoopa's key.
    RTS


MechaKeyDispX:
    db $F9,$0F

MechaKeyGfxProp:
    db $4D,$0D

MechaKeyTiles:
    db $70,$71,$72,$71

MechaKoopaKeyGfx:
; X offsets for the MechaKoopa's key, indexed by its direction.
; YXPPCCCT for the MechaKoopa's key, indexed by its direction.
; Tile numbers for each frame animation for the MechaKoopa's key.
    LDA.W SpriteOAMIndex,X                    ; GFX subroutine for the MechaKoopa's key.
    CLC
    ADC.B #$10
    STA.W SpriteOAMIndex,X
    JSR GetDrawInfoBnk3
    PHX
    LDA.W SpriteMisc1570,X
    LSR A
    LSR A                                     ; $02 = animation frame
    AND.B #$03
    STA.B _2
    LDA.W SpriteMisc157C,X
    TAX
    LDA.B _0                                  ; Store X position to OAM.
    CLC
    ADC.W MechaKeyDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    SEC                                       ; Store Y position to OAM.
    SBC.B #$00
    STA.W OAMTileYPos+$100,Y
    LDA.W MechaKeyGfxProp,X
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    LDX.B _2
    LDA.W MechaKeyTiles,X                     ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    PLX
    LDY.B #$00
    LDA.B #$00                                ; Upload 1 8x8 tile.
    JSL FinishOAMWrite
    RTS

CODE_03B43C:
; Subroutine to draw the Bowser room graphics.
    JSR BowserItemBoxGfx                      ; Draw Mario's item box.
    JSR BowserSceneGfx                        ; Draw the room.
    RTS


BowserItemBoxPosX:
    db $70,$80,$70,$80

BowserItemBoxPosY:
    db $07,$07,$17,$17

BowserItemBoxProp:
    db $37,$77,$B7,$F7

BowserItemBoxGfx:
; X offsets for each tile of Mario's item box in Bowser's room.
; Y offsets for each tile of Mario's item box in Bowser's room.
; Tile numbers for each tile of Mario's item box in Bowser's room.
    LDA.W FinalCutscene                       ; Subroutine to set up Mario's item box in Bowser's boss room.
    BEQ +
    STZ.W PlayerItembox                       ; Return if Mario has no item or Bowser has been defeated.
  + LDA.W PlayerItembox
    BEQ Return03B48B
    PHX
    LDX.B #$03
    LDY.B #$04                                ; OAM index (from $0200) to use for Mario's item box in Bowser's room.
  - LDA.W BowserItemBoxPosX,X                 ; Store X position to OAM.
    STA.W OAMTileXPos,Y
    LDA.W BowserItemBoxPosY,X                 ; Store Y position to OAM.
    STA.W OAMTileYPos,Y
    LDA.B #$43                                ; Tile to use for the item box in Bowser's room.
    STA.W OAMTileNo,Y
    LDA.W BowserItemBoxProp,X                 ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Set size as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    PLY
    INY
    INY
    INY                                       ; Loop for all four tiles.
    INY
    DEX
    BPL -
    PLX
Return03B48B:
    RTS


BowserRoofPosX:
    db $00,$30,$60,$90,$C0,$F0,$00,$30
    db $40,$50,$60,$90,$A0,$B0,$C0,$F0
if ver_is_lores(!_VER)                        ;\================= J, U, SS, & E0 ==============
BowserRoofPosY:                               ;!
    db $B0,$B0,$B0,$B0,$B0,$B0,$D0,$D0        ;!
    db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0        ;!
else                                          ;<======================= E1 ====================
BowserRoofPosY:                               ;!
    db $C0,$C0,$C0,$C0,$C0,$C0,$E0,$E0        ;!
    db $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0        ;!
endif                                         ;/===============================================

BowserSceneGfx:
; X offsets for additional tiles for the floor of Bowser's room.
; Merlons
; Support columns
; Y offsets for additional tiles for the floor of Bowser's room.
; Merlons
; Support columns
    PHX                                       ; Subroutine to set up Bowser's boss room.
    LDY.B #$BC                                ; OAM index (from $0300) for the floor of Bowser's room when Bowser is still alive.
    STZ.B _1
    LDA.W FinalCutscene
    STA.B _F                                  ; Get OAM index for the floor of Bowser's room.
    CMP.B #$01                                ; For some reason, it also has one less tile uploaded after Bowser is defeated (not sure why).
    LDX.B #$10
    BCC CODE_03B4BF
    LDY.B #$90                                ; OAM index (from $0300) for the floor of Bowser's room after Bowser is defeated.
    DEX
CODE_03B4BF:
    LDA.B #con($C0,$C0,$C0,$C0,$D0)           ; Tile loop for the floor of Bowser's room.
    SEC                                       ; Store Y position to OAM.
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    LDA.B _1
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$100,Y                  ; Store X position to OAM.
    CLC
    ADC.B #$10
    STA.B _1
    LDA.B #$08                                ; Tile to use for the floor of Bowser's room.
    STA.W OAMTileNo+$100,Y
    LDA.B #$0D
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Store size to OAM as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL CODE_03B4BF
    LDX.B #$0F
    LDA.B _F                                  ; Branch if Bowser has been defeated, to use the $0300 range of OAM.
    BNE CODE_03B532
    LDY.B #$14                                ; OAM index (from $0200) for the extra tiles in Bowser's room while Bowser is still alive.
CODE_03B4FA:
    %LorW_X(LDA,BowserRoofPosX)
; Tile loop for additional tiles in Bowser's room.
    SEC                                       ; Store X position to OAM.
    SBC.B Layer1XPos
    STA.W OAMTileXPos,Y
    %LorW_X(LDA,BowserRoofPosY)
    SEC                                       ; Store Y position to OAM.
    SBC.B Layer1YPos
    STA.W OAMTileYPos,Y
    LDA.B #$08                                ; Tile to use for the support columns of Bowser's floor.
    CPX.B #$06
    BCS +
    LDA.B #$03                                ; Tile to use for the merlons on Bowser's floor.
  + STA.W OAMTileNo,Y
    LDA.B #$0D
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Store size to OAM as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    PLY
    INY
    INY
    INY                                       ; Loop for all tiles.
    INY
    DEX
    BPL CODE_03B4FA
    BRA CODE_03B56A

CODE_03B532:
; Using the $0300 OAM range for Bowser's extra floor tiles.
    LDY.B #$50                                ; OAM index (from $0300) for the extra tiles in Bowser's room after Bowser has been defeated.
CODE_03B534:
    %LorW_X(LDA,BowserRoofPosX)
; Alternate tile loop for additional tiles in Bowser's room.
    SEC                                       ; Store X position to OAM.
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$100,Y
    %LorW_X(LDA,BowserRoofPosY)
    SEC                                       ; Store Y position to OAM.
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    LDA.B #$08                                ; Tile to use for the support columns of Bowser's floor.
    CPX.B #$06
    BCS +
    LDA.B #$03                                ; Tile to use for the merlons on Bowser's floor.
  + STA.W OAMTileNo+$100,Y
    LDA.B #$0D
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Store size to OAM as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL CODE_03B534
CODE_03B56A:
    PLX
    RTS


SprClippingDispX:
    db $02,$02,$10,$14,$00,$00,$01,$08
    db $F8,$FE,$03,$06,$01,$00,$06,$02
    db $00,$E8,$FC,$FC,$04,$00,$FC,$02
    db $02,$02,$02,$02,$00,$02,$E0,$F0
    db $FC,$FC,$00,$F8,$F4,$F2,$00,$FC
    db $F2,$F0,$02,$00,$F8,$04,$02,$02
    db $08,$00,$00,$00,$FC,$03,$08,$00
    db $08,$04,$F8,$00

SprClippingWidth:
    db $0C,$0C,$10,$08,$30,$50,$0E,$28
    db $20,$14,$01,$03,$0D,$0F,$14,$24
    db $0F,$40,$08,$08,$18,$0F,$18,$0C
    db $0C,$0C,$0C,$0C,$0A,$1C,$30,$30
    db $08,$08,$10,$20,$38,$3C,$20,$18
    db $1C,$20,$0C,$10,$10,$08,$1C,$1C
    db $10,$30,$30,$40,$08,$12,$34,$0F
    db $20,$08,$20,$10

SprClippingDispY:
    db $03,$03,$FE,$08,$FE,$FE,$02,$08
    db $FE,$08,$07,$06,$FE,$FC,$06,$FE
    db $FE,$E8,$10,$10,$02,$FE,$F4,$08
    db $13,$23,$33,$43,$0A,$FD,$F8,$FC
    db $E8,$10,$00,$E8,$20,$04,$58,$FC
    db $E8,$FC,$F8,$02,$F8,$04,$FE,$FE
    db $F2,$FE,$FE,$FE,$FC,$00,$08,$F8
    db $10,$03,$10,$00

SprClippingHeight:
    db $0A,$15,$12,$08,$0E,$0E,$18,$30
    db $10,$1E,$02,$03,$16,$10,$14,$12
    db $20,$40,$34,$74,$0C,$0E,$18,$45
    db $3A,$2A,$1A,$0A,$30,$1B,$20,$12
    db $18,$18,$10,$20,$38,$14,$08,$18
    db $28,$1B,$13,$4C,$10,$04,$22,$20
    db $1C,$12,$12,$12,$08,$20,$2E,$14
    db $28,$0A,$10,$0D

MairoClipDispY:
    db $06,$14,$10,$18

MarioClippingHeight:
    db $1A,$0C,$20,$18

GetMarioClipping:
; X displacement of each sprite clipping.
; Width of each sprite clipping.
; Y displacement of each sprite clipping.
; Height of each sprite clipping.
; Mario Y displacement from his actual position, for sprite interaction.
; Order is big, small, big on Yoshi, small on Yoshi.
; Mario's height, for sprite interaction.
; Same order as above.
; Scratch RAM returns:
; $00 - Clipping X displacement lo
; $01 - Clipping Y displacement lo
; $02 - Clipping width
; $03 - Clipping height
; $08 - Clipping X displacement hi
; $09 - Clipping Y displacement hi
    PHX                                       ; Get player clipping routine. Stores clipping data for Mario's hitbox (as sprite B).
    LDA.B PlayerXPosNext                      ; \
    CLC                                       ; |
    ADC.B #$02                                ; |
    STA.B _0                                  ; | $00 = (Mario X position + #$02) Low byte; Get clipping X position, offset 2 pixels right.
    LDA.B PlayerXPosNext+1                    ; |
    ADC.B #$00                                ; |
    STA.B _8                                  ; / $08 = (Mario X position + #$02) High byte
    LDA.B #$0C                                ; \ $06 = Clipping width X (#$0C); Width of Mario's sprite interaction hitbox.
    STA.B _2                                  ; /
    LDX.B #$00                                ; \ If mario small or ducking, X = #$01
    LDA.B PlayerIsDucking                     ; | else, X = #$00
    BNE CODE_03B680                           ; |
    LDA.B Powerup                             ; |; Use 16x16 hitbox if small, 16x32 otherwise.
    BNE +                                     ; |; [change BNE to LDA to always have 16x16, or to BRA to always have 16x32. Use with $00EB79 and $01B4C0]
CODE_03B680:
    INX                                       ; /
  + LDA.W PlayerRidingYoshi                   ; \ If on Yoshi, X += #$02
    BEQ +                                     ; |; Increase hitbox size if riding Yoshi.
    INX                                       ; |
    INX                                       ; /
  + LDA.L MarioClippingHeight,X               ; \ $03 = Clipping height
    STA.B _3                                  ; /
    LDA.B PlayerYPosNext                      ; \
    CLC                                       ; |
    ADC.L MairoClipDispY,X                    ; |
    STA.B _1                                  ; | $01 = (Mario Y position + displacement) Low byte; Set clipping Y position.
    LDA.B PlayerYPosNext+1                    ; |
    ADC.B #$00                                ; |
    STA.B _9                                  ; / $09 = (Mario Y position + displacement) High byte
    PLX
    RTL

GetSpriteClippingA:
; Scratch RAM returns:
; $04 - Clipping X displacement, low
; $05 - Clipping Y displacement, low
; $06 - Clipping width
; $07 - Clipping height
; $0A - Clipping X displacement, high
; $0B - Clipping Y displacement, high
    PHY                                       ; Get sprite clipping A routine. Stores clipping data for the hitbox of the sprite slot in X.
    PHX
    TXY                                       ; Y = Sprite index
    LDA.W SpriteTweakerB,X                    ; \ X = Clipping table index
    AND.B #$3F                                ; |
    TAX                                       ; /
    STZ.B _F                                  ; \
    LDA.L SprClippingDispX,X                  ; | Load low byte of X displacement
    BPL +                                     ; |
    DEC.B _F                                  ; | $0F = High byte of X displacement
  + CLC                                       ; |
    ADC.W SpriteXPosLow,Y                     ; |
    STA.B _4                                  ; | $04 = (Sprite X position + displacement) Low byte
    LDA.W SpriteXPosHigh,Y                    ; |
    ADC.B _F                                  ; |
    STA.B _A                                  ; / $0A = (Sprite X position + displacement) High byte
    LDA.L SprClippingWidth,X                  ; \ $06 = Clipping width
    STA.B _6                                  ; /
    STZ.B _F                                  ; \
    LDA.L SprClippingDispY,X                  ; | Load low byte of Y displacement
    BPL +                                     ; |
    DEC.B _F                                  ; | $0F = High byte of Y displacement
  + CLC                                       ; |
    ADC.W SpriteYPosLow,Y                     ; |
    STA.B _5                                  ; | $05 = (Sprite Y position + displacement) Low byte
    LDA.W SpriteYPosHigh,Y                    ; |
    ADC.B _F                                  ; |
    STA.B _B                                  ; / $0B = (Sprite Y position + displacement) High byte
    LDA.L SprClippingHeight,X                 ; \ $07 = Clipping height
    STA.B _7                                  ; /
    PLX                                       ; X = Sprite index
    PLY
    RTL

GetSpriteClippingB:
; Scratch RAM returns:
; $00 - Clipping X displacement, low
; $01 - Clipping Y displacement, low
; $02 - Clipping width
; $03 - Clipping height
; $08 - Clipping X displacement, high
; $09 - Clipping Y displacement, high
    PHY                                       ; Get sprite clipping B routine. Stores clipping data for the hitbox of a second sprite slot in X.
    PHX
    TXY                                       ; Y = Sprite index
    LDA.W SpriteTweakerB,X                    ; \ X = Clipping table index
    AND.B #$3F                                ; |
    TAX                                       ; /
    STZ.B _F                                  ; \
    LDA.L SprClippingDispX,X                  ; | Load low byte of X displacement
    BPL +                                     ; |
    DEC.B _F                                  ; | $0F = High byte of X displacement
  + CLC                                       ; |
    ADC.W SpriteXPosLow,Y                     ; |
    STA.B _0                                  ; | $00 = (Sprite X position + displacement) Low byte
    LDA.W SpriteXPosHigh,Y                    ; |
    ADC.B _F                                  ; |
    STA.B _8                                  ; / $08 = (Sprite X position + displacement) High byte
    LDA.L SprClippingWidth,X                  ; \ $02 = Clipping width
    STA.B _2                                  ; /
    STZ.B _F                                  ; \
    LDA.L SprClippingDispY,X                  ; | Load low byte of Y displacement
    BPL +                                     ; |
    DEC.B _F                                  ; | $0F = High byte of Y displacement
  + CLC                                       ; |
    ADC.W SpriteYPosLow,Y                     ; |
    STA.B _1                                  ; | $01 = (Sprite Y position + displacement) Low byte
    LDA.W SpriteYPosHigh,Y                    ; |
    ADC.B _F                                  ; |
    STA.B _9                                  ; / $09 = (Sprite Y position + displacement) High byte
    LDA.L SprClippingHeight,X                 ; \ $03 = Clipping height
    STA.B _3                                  ; /
    PLX                                       ; X = Sprite index
    PLY
    RTL

CheckForContact:
; Check for contact routine. Returns carry set if so, clear if not.
    PHX                                       ; Run two of the three above routines first,
    LDX.B #$01                                ; or one of the codes at $02A519 / $02A547.
CODE_03B72E:
    LDA.B _0,X
    SEC
    SBC.B _4,X
    PHA
    LDA.B _8,X
    SBC.B _A,X                                ; Return no contact if not on the same screen.
    STA.B _C
    PLA
    CLC
    ADC.B #$80
    LDA.B _C
    ADC.B #$00
    BNE CODE_03B75A
    LDA.B _4,X
    SEC
    SBC.B _0,X
    CLC
    ADC.B _6,X
    STA.B _F                                  ; Return no contact if too far apart.
    LDA.B _2,X
    CLC
    ADC.B _6,X
    CMP.B _F
    BCC CODE_03B75A
    DEX                                       ; Loop for horizontal.
    BPL CODE_03B72E
CODE_03B75A:
    PLX
    RTL


DATA_03B75C:
    db $0C,$1C

DATA_03B75E:
    db $01,$02

GetDrawInfoBnk3:
; Y position offsets to the bottom of a sprite, for checking if offscreen.
; Bits to set in $186C, for each tile of a two-tile sprite.
; Misc RAM returns:
; Y   = OAM index (from $0300)
; $00 = Sprite X position relative to the screen border
; $01 = Sprite Y position relative to the screen border
; Also sets $15A0, $15C4, and $186C.
; GetDrawInfo routine. Sets various graphical flags, including offscreen flags.
    STZ.W SpriteOffscreenVert,X               ; Reset sprite offscreen flag, vertical; Initialize offscreen flags.
    STZ.W SpriteOffscreenX,X                  ; Reset sprite offscreen flag, horizontal
    LDA.B SpriteXPosLow,X                     ; \
    CMP.B Layer1XPos                          ; | Set horizontal offscreen if necessary
    LDA.W SpriteXPosHigh,X                    ; |; Check if offscreen horizontally, and set the flag if so.
    SBC.B Layer1XPos+1                        ; |
    BEQ +                                     ; |
    INC.W SpriteOffscreenX,X                  ; /
  + LDA.W SpriteXPosHigh,X                    ; \
    XBA                                       ; | Mark sprite invalid if far enough off screen
    LDA.B SpriteXPosLow,X                     ; |
    REP #$20                                  ; A->16
    SEC                                       ; |
    SBC.B Layer1XPos                          ; |
    CLC                                       ; |; Handle horizontal offscreen flag for 4 tiles offscreen. (-40 to +40)
    ADC.W #$0040                              ; |; If so, return the sprite's graphical routine.
    CMP.W #$0180                              ; |
    SEP #$20                                  ; A->8
    ROL A                                     ; |
    AND.B #$01                                ; |
    STA.W SpriteWayOffscreenX,X               ; |
    BNE CODE_03B7CF                           ; /
    LDY.B #$00                                ; \ set up loop:
    LDA.W SpriteTweakerB,X                    ; |
    AND.B #$20                                ; | if not smushed (1662 & 0x20), go through loop twice
    BEQ CODE_03B79A                           ; | else, go through loop once
    INY                                       ; /
CODE_03B79A:
    LDA.B SpriteYPosLow,X                     ; \
    CLC                                       ; | set vertical offscree
    ADC.W DATA_03B75C,Y                       ; |; Check if vertically offscreen, and set the flag if so.
    PHP                                       ; |; Due to a typo (?), if a sprite uses sprite clipping 20+, $186C's bits will be set for two different tiles.
    CMP.B Layer1YPos                          ; | (vert screen boundry); First ("top") tile = bit 0
    ROL.B _0                                  ; |; Second ("bottom") tile = bit 1
    PLP                                       ; |
    LDA.W SpriteYPosHigh,X                    ; |; Likely was supposed to be $190F instead of $1662, as in Bank 1's GFX routine.
    ADC.B #$00                                ; |; Fortunately for Nintendo, there don't seem to be any negative consequences of this.
    LSR.B _0                                  ; |
    SBC.B Layer1YPos+1                        ; |
    BEQ +                                     ; |
    LDA.W SpriteOffscreenVert,X               ; | (vert offscreen)
    ORA.W DATA_03B75E,Y                       ; |
    STA.W SpriteOffscreenVert,X               ; |
  + DEY                                       ; |
    BPL CODE_03B79A                           ; /
    LDY.W SpriteOAMIndex,X                    ; get offset to sprite OAM
    LDA.B SpriteXPosLow,X                     ; \
    SEC                                       ; |
    SBC.B Layer1XPos                          ; |
    STA.B _0                                  ; / $00 = sprite x position relative to screen boarder; Return onscreen position in $00 and $01, and OAM index in Y.
    LDA.B SpriteYPosLow,X                     ; \
    SEC                                       ; |
    SBC.B Layer1YPos                          ; |
    STA.B _1                                  ; / $01 = sprite y position relative to screen boarder
    RTS

CODE_03B7CF:
; Sprite more than 4 tiles offscreen.
    PLA                                       ; \ Return from *main gfx routine* subroutine...; Return the sprite's routine (i.e. don't draw).
    PLA                                       ; |    ...(not just this subroutine)
    RTS                                       ; /


DATA_03B7D2:
    db $00,$00,$00,$F8,$F8,$F8,$F8,$F8
    db $F8,$F7,$F6,$F5,$F4,$F3,$F2,$E8
    db $E8,$E8,$E8,$00,$00,$00,$00,$FE
    db $FC,$F8,$EC,$EC,$EC,$E8,$E4,$E0
    db $DC,$D8,$D4,$D0,$CC,$C8

CODE_03B7F8:
; Y speeds to bounce Bowser's bowling ball with, indexed by its Y speed on hitting the ground.
; 00 - Unused
; 13 - Bowser's bowling ball
    LDA.B SpriteYSpeed,X                      ; Subroutine to handle bouncing Bowser's bowling ball.
    PHA
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    PLA                                       ; Get index to the above table for the height to bounce with.
    LSR A
    LSR A
    TAY
    LDA.B SpriteNumber,X
    CMP.B #$A1
    BNE +                                     ; Increase index by 0x13 for Bowser's bowling ball...?
    TYA                                       ; Apparently some other sprite used this routine at some point, too (Goomba maybe?).
    CLC
    ADC.B #$13
    TAY
  + LDA.W DATA_03B7D2,Y
    LDY.W SpriteBlockedDirs,X                 ; Store speed when if the ball has hit the ground.
    BMI +
    STA.B SpriteYSpeed,X
  + RTS

SubHorzPosBnk3:
; Equivalent routine in bank 1 at $01AD30, bank 2 at $02848D.
; Subroutine to check horizontal proximity of Mario to a sprite.
    LDY.B #$00                                ; Returns the side in Y (0 = right) and distance in $0F.
    LDA.B PlayerXPosNext
    SEC
    SBC.B SpriteXPosLow,X
    STA.B _F
    LDA.B PlayerXPosNext+1
    SBC.W SpriteXPosHigh,X
    BPL +
    INY
  + RTS

SubVertPosBnk3:
; Equivalent routine in bank 1 at $01AD42, and bank 2 at $02D50C.
; Subroutine to check vertical proximity of Mario to a sprite.
    LDY.B #$00                                ; Returns the side in Y (0 = below) and distance in $0F.
    LDA.B PlayerYPosNext
    SEC                                       ; Note that that this returns in $0F, not $0E like the other SubVertPos routines.
    SBC.B SpriteYPosLow,X                     ; This was probably not intentional, since all the routines that use this
    STA.B _F                                  ; actually still expect the result to be in $0E (and either just get lucky or don't actually work).
    LDA.B PlayerYPosNext+1                    ; As such, you can safely patch a fix to make it $0E without issue.
    SBC.W SpriteYPosHigh,X
    BPL +
    INY
  + RTS


DATA_03B83B:
    db $40,$B0

DATA_03B83D:
    db $01,$FF

DATA_03B83F:
    db $30,$C0,$A0,$80,$A0,$40,$60,$B0
DATA_03B847:
    db $01,$FF,$01,$FF,$01,$00,$01,$FF

SubOffscreen3Bnk3:
; Low bytes for offscreen processing distances in bank 03.
; High bytes for offscreen processing distances in bank 03.
    LDA.B #$06                                ; \ Entry point of routine determines value of $03; SubOffscreenX7 routine. Processes sprites offscreen from -$50 to +$60 ($FFB0,$0160).
    BRA +                                     ; |

; SubOffscreenX6 routine. Processes sprites offscreen from $40 to +$A0 ($0040,$01A0).
    LDA.B #$04                                ; |; Unused in SMW. And yes, this stops processing in the middle of the visible screen.
    BRA +                                     ; |

; SubOffscreenX5 routine. Processes sprites offscreen from -$80 to +$A0 ($01A0,$FF80).
    LDA.B #$02                                ; |; Unused in SMW.
  + STA.B _3                                  ; |
    BRA +                                     ; |

SubOffscreen0Bnk3:
    STZ.B _3                                  ; /; SubOffscreenX0 routine. Processes sprites offscreen from -$40 to +$30 ($0130,$FFC0).
  + JSR IsSprOffScreenBnk3                    ; \ if sprite is not off screen, return
    BEQ Return03B8C2                          ; /
    LDA.B ScreenMode                          ; \  vertical level
    AND.B #!ScrMode_Layer1Vert                ; |
    BNE VerticalLevelBnk3                     ; /
    LDA.B SpriteYPosLow,X                     ; \
    CLC                                       ; |
    ADC.B #$50                                ; | if the sprite has gone off the bottom of the level...
    LDA.W SpriteYPosHigh,X                    ; | (if adding 0x50 to the sprite y position would make the high byte >= 2)
    ADC.B #$00                                ; |
    CMP.B #$02                                ; |
    BPL OffScrEraseSprBnk3                    ; /    ...erase the sprite
    LDA.W SpriteTweakerD,X                    ; \ if "process offscreen" flag is set, return
    AND.B #$04                                ; |
    BNE Return03B8C2                          ; /
    LDA.B TrueFrame
    AND.B #$01
    ORA.B _3
    STA.B _1
    TAY
    LDA.B Layer1XPos
    CLC
    ADC.W DATA_03B83F,Y
    ROL.B _0
    CMP.B SpriteXPosLow,X
    PHP
    LDA.B Layer1XPos+1
    LSR.B _0
    ADC.W DATA_03B847,Y
    PLP
    SBC.W SpriteXPosHigh,X
    STA.B _0
    LSR.B _1
    BCC +
    EOR.B #$80
    STA.B _0
  + LDA.B _0
    BPL Return03B8C2
OffScrEraseSprBnk3:
    LDA.W SpriteStatus,X                      ; \ If sprite status < 8, permanently erase sprite
    CMP.B #$08                                ; |
    BCC +                                     ; /
    LDY.W SpriteLoadIndex,X                   ; \ Branch if should permanently erase sprite
    CPY.B #$FF                                ; |
    BEQ +                                     ; /
    LDA.B #$00                                ; \ Allow sprite to be reloaded by level loading routine
    STA.W SpriteLoadStatus,Y                  ; /
  + STZ.W SpriteStatus,X
Return03B8C2:
    RTS

VerticalLevelBnk3:
    LDA.W SpriteTweakerD,X                    ; \ If "process offscreen" flag is set, return
    AND.B #$04                                ; |
    BNE Return03B8C2                          ; /
    LDA.B TrueFrame                           ; \ Return every other frame
    LSR A                                     ; |
    BCS Return03B8C2                          ; /
    AND.B #$01
    STA.B _1
    TAY
    LDA.B Layer1YPos
    CLC
    ADC.W DATA_03B83B,Y
    ROL.B _0
    CMP.B SpriteYPosLow,X
    PHP
    LDA.W Layer1YPos+1
    LSR.B _0
    ADC.W DATA_03B83D,Y
    PLP
    SBC.W SpriteYPosHigh,X
    STA.B _0
    LDY.B _1
    BEQ +
    EOR.B #$80
    STA.B _0
  + LDA.B _0
    BPL Return03B8C2
    BMI OffScrEraseSprBnk3
IsSprOffScreenBnk3:
    LDA.W SpriteOffscreenX,X                  ; \ If sprite is on screen, A = 0
    ORA.W SpriteOffscreenVert,X               ; |
    RTS                                       ; /


MagiKoopaPals:
    %incpal("col/misc/magikoopa.pal")

BooBossPals:
    %incpal("col/misc/the_big_boo.pal")

    %insert_empty($5FE,$5FE,$5FE,$5FE,$5FE)

GenTileFromSpr2:
; Magikoopa palettes. Affects palette F, colors 0-7.
; 8 palettes of 8 colors each, including the transparent color.
; Big Boo Boss palette animation. Also used for the reappearing ghosts.
; 8 palettes of 8 colors each, including the transparent color.
; Empty. LM sticks various hijacks in this block.
; Used by LM as a hijack to $049199 for determining whether an overworld level is enterable.
; Used by LM for its level name hijack, to write the name into the stripe image table.
; The actual name table can be found at read3($03BB57), with 19 bytes per level.
; Used by LM for its message box text hijack.
; Used by LM as a table of message box stripe headers (first 2 bytes) for each line.
; With Lunar Magic's overworld level expansion, this table is shifted a bit earlier, to $03BC79.
; Unused?
; Used by LM for the "display level message 1" fix.
; Unused?
; Used by LM for 24-bit pointers to ExGFX60-63.
; Unused?
; Used by LM as a springboard to a routine
; for getting a sceen exit with the ExLevel expansion.
; Used by LM as a routine to implement the additional secondary entrance bytes.
; Used by LM as 16-bit pointers to each message box's text.
; Indexed by ((level * 2) + message number) * 2.
; Note: if LM's overworld level expansion is applied, this table is moved to read3($03BBD9).
; Instead, this table used for the initial level flags (moved from $05DDA0).
; The remainder of the table ($03BF80 onwards) is then left unused for now.
    STA.B Map16TileGenerate                   ; $9C = tile to generate; Routine to generate a tile at a sprite's position, +8 pixels left and down.
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position + #$08
    SEC                                       ; | for block creation
    SBC.B #$08                                ; |
    STA.B TouchBlockXPos                      ; |
    LDA.W SpriteXPosHigh,X                    ; |
    SBC.B #$00                                ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ $98 = Sprite Y position + #$08
    CLC                                       ; | for block creation
    ADC.B #$08                                ; |
    STA.B TouchBlockYPos                      ; |
    LDA.W SpriteYPosHigh,X                    ; |
    ADC.B #$00                                ; |
    STA.B TouchBlockYPos+1                    ; /
    JSL GenerateTile                          ; Generate the tile
    RTL

CODE_03C023:
; Routine to feed Baby Yoshi, which gets used when the 'double-eat' glitch occurs.
    PHB                                       ; Wrapper; Otherwise, it's just a duplicate of $01A288.
    PHK
    PLB
    JSR CODE_03C02F
    PLB
    RTL


DATA_03C02B:
    db $74,$75,$77,$76

CODE_03C02F:
    LDY.W SpriteMisc160E,X                    ; Sprite numbers that each value of the roulette sprite corresponds to.
    LDA.B #$00                                ; Erase the sprite being eaten.
    STA.W SpriteStatus,Y
    LDA.B #!SFX_GULP                          ; \ Play sound effect; SFX for baby Yoshi swallowing.
    STA.W SPCIO0                              ; /
    LDA.W SpriteMisc160E,Y                    ; If the sprite has $160E set (i.e. it's a berry, not a mushroom), don't grow instantly.
    BNE CODE_03C09B
    LDA.W SpriteNumber,Y
    CMP.B #$81
    BNE +
    LDA.B EffFrame
    LSR A                                     ; If eating sprite 81 (roulette item), get the actual powerup being eaten.
    LSR A
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W DATA_03C02B,Y
  + CMP.B #$74
    BCC CODE_03C09B                           ; If baby Yoshi eats a powerup, instantly grow. Else, branch.
    CMP.B #$78
    BCS CODE_03C09B
ADDR_03C05C:
    STZ.W YoshiSwallowTimer
    STZ.W YoshiHasWingsEvt                    ; No Yoshi wing ability
    LDA.B #$35
    STA.W SpriteNumber,X                      ; Make a grown Yoshi.
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #!SFX_YOSHI                         ; \ Play sound effect; SFX for Yoshi growing up.
    STA.W SPCIO3                              ; /
    LDA.B SpriteYPosLow,X
    SBC.B #$10
    STA.B SpriteYPosLow,X                     ; Spawn the adult Yoshi a tile higher than the baby Yoshi.
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.W SpriteOBJAttribute,X
    PHA
    JSL InitSpriteTables
    PLA
    AND.B #$FE
    STA.W SpriteOBJAttribute,X
    LDA.B #$0C                                ; Set initial animation frame for the growing animation.
    STA.W SpriteMisc1602,X
    DEC.W SpriteMisc160E,X
    LDA.B #$40                                ; How long Yoshi's growing animation lasts.
    STA.W YoshiGrowingTimer
    RTS

CODE_03C09B:
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    CMP.B #$05                                ; Number of sprites baby Yoshi has to eat to grow (when double-eating). Change with $01A2FB.
    BNE CODE_03C0A7
    BRA ADDR_03C05C

CODE_03C0A7:
; Yoshi has eaten a sprite.
    JSL CODE_05B34A                           ; Give a coin.
    LDA.B #$01                                ; Give 200 points.
    JSL GivePoints
    RTS


DATA_03C0B2:
    db $68,$6A,$6C,$6E

DATA_03C0B6:
    db $00,$03,$01,$02,$04,$02,$00,$01
    db $00,$04,$00,$02,$00,$03,$04,$01

CODE_03C0C6:
; Tile numbers to use for the lava in Iggy/Larry's rooms.
; Indices to the above table for each actual lava tile in the room.
    LDA.B SpriteLock                          ; Subroutine to draw the top of the lava in Iggy/Larry's rooms.
    BNE +                                     ; If the game isn't frozen, rotate Iggy/Larry's platform.
    JSR CODE_03C11E
  + STZ.B _0
    LDX.B #$13
    LDY.B #$B0
  - STX.B _2
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    CLC                                       ; Store X position to OAM.
    ADC.B #$10
    STA.B _0
    LDA.B #$C4                                ; Store Y position to OAM.
    STA.W OAMTileYPos+$100,Y
    LDA.B SpriteProperties
    ORA.B #$09                                ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    PHX
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    CLC                                       ; Store tile number to OAM.
    ADC.L DATA_03C0B6,X
    AND.B #$03
    TAX
    LDA.L DATA_03C0B2,X
    STA.W OAMTileNo+$100,Y
    TYA
    LSR A
    LSR A
    TAX
    LDA.B #$02                                ; Store size to OAM as 16x16.
    STA.W OAMTileSize+$40,X
    PLX
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL -
    RTL


IggyPlatSpeed:
    db $FF,$01,$FF,$01

DATA_03C116:
    db $FF,$00,$FF,$00

IggyPlatBounds:
    db $E7,$18,$D7,$28

CODE_03C11E:
; Speeds (lo) to rotate Iggy/Larry's platform by.
; Speeds (hi) to rotate Iggy/Larry's platform by.
; Max angles to rotate Iggy/Larry's platforms to.
    LDA.B SpriteLock                          ; \ If sprites locked...; Subroutine to handle rotating Iggy/Larry's platform.
    ORA.W EndLevelTimer                       ; | ...or battle is over (set to FF when over)...; Return if game frozen or level has ended.
    BNE Return03C175                          ; / ...return
    LDA.W IggyLarryPlatWait                   ; \ If platform at a maximum tilt, (stationary timer > 0)
    BEQ +                                     ; |; Handle the "paused" timer for Iggy/Larry's platform.
    DEC.W IggyLarryPlatWait                   ; / decrement stationary timer
  + LDA.B TrueFrame                           ; \ Return every other time through...
    AND.B #$01                                ; |; If the paused timer is set or it's not a frame to rotate the platform, return.
    ORA.W IggyLarryPlatWait                   ; | ...return if stationary
    BNE Return03C175                          ; /
    LDA.W IggyLarryPlatTilt                   ; $1907 holds the total number of tilts made
    AND.B #$01                                ; \ X=1 if platform tilted up to the right (/)...
    TAX                                       ; / ...else X=0
    LDA.W IggyLarryPlatPhase                  ; $1907 holds the current phase: 0/ 1\ 2/ 3\ 4// 5\\; Get index for the max tilt angle.
    CMP.B #$04                                ; \ If this is phase 4 or 5...; If on the third "phase" of the tilt, tilt the platform more than usual.
    BCC +                                     ; | ...cause a steep tilt by setting X=X+2
    INX                                       ; |
    INX                                       ; /
  + LDA.B Mode7Angle                          ; $36 is tilt of platform: //D8 /E8 -0- 18\ 28\\
    CLC                                       ; \ Get new tilt of platform by adding value
    ADC.L IggyPlatSpeed,X                     ; |
    STA.B Mode7Angle                          ; /
    PHA                                       ; Rotate the platform.
    LDA.B Mode7Angle+1                        ; $37 is boolean tilt of platform: 0\ /1
    ADC.L DATA_03C116,X                       ; \ if tilted up to left,  $37=0
    AND.B #$01                                ; | if tilted up to right, $37=1
    STA.B Mode7Angle+1                        ; /
    PLA
    CMP.L IggyPlatBounds,X                    ; \ Return if platform not at a maximum tilt; Return if not at the max rotation.
    BNE Return03C175                          ; /
    INC.W IggyLarryPlatTilt                   ; Increment total number of tilts made; Increment tilt counter.
    LDA.B #$40                                ; \ Set timer to stay stationary; Set pause timer to wait before the next rotation.
    STA.W IggyLarryPlatWait                   ; /
    INC.W IggyLarryPlatPhase                  ; Increment phase
    LDA.W IggyLarryPlatPhase                  ; \ If phase > 5, phase = 0
    CMP.B #$06                                ; |; Increment the phase pointer.
    BNE Return03C175                          ; |
    STZ.W IggyLarryPlatPhase                  ; /
Return03C175:
    RTS


DATA_03C176:
    db $0C,$0C,$0C,$0C,$0C,$0C,$0D,$0D
    db $0D,$0D,$FC,$FC,$FC,$FC,$FC,$FC
    db $FB,$FB,$FB,$FB,$0C,$0C,$0C,$0C
    db $0C,$0C,$0D,$0D,$0D,$0D,$FC,$FC
    db $FC,$FC,$FC,$FC,$FB,$FB,$FB,$FB
DATA_03C19E:
    db $0E,$0E,$0E,$0D,$0D,$0D,$0C,$0C
    db $0B,$0B,$0E,$0E,$0E,$0D,$0D,$0D
    db $0C,$0C,$0B,$0B,$12,$12,$12,$11
    db $11,$11,$10,$10,$0F,$0F,$12,$12
    db $12,$11,$11,$11,$10,$10,$0F,$0F
DATA_03C1C6:
    db $02,$FE

DATA_03C1C8:
    db $00,$FF

CODE_03C1CA:
; X offsets for the swallowing tile from Yoshi.
; Right
; Left
; Right, ducking
; Left, ducking
; Y offsets for the swallowing tile from Yoshi.
; Right
; Left
; Right, ducking
; Left, ducking
; "Speeds" that sprites get pushed down very steep slopes (low).
; "Speeds" that sprites get pushed down very steep slopes (high).
    PHB                                       ; Routine used to push a sprite down a very steep slope.
    PHK
    PLB
    LDY.B #$00
    LDA.W SpriteSlope,X                       ; Get direction to push.
    BPL +
    INY
  + LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_03C1C6,Y
    STA.B SpriteXPosLow,X                     ; Shift the sprite to the side.
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_03C1C8,Y
    STA.W SpriteXPosHigh,X
    LDA.B #$18                                ; Set Y speed.
    STA.B SpriteYSpeed,X
    PLB
    RTL


DATA_03C1EC:
    db $00,$04,$07,$08,$08,$07,$04,$00
    db $00

LightSwitch:
; Y offsets for the light switch's bounce animation.
; Light switch misc RAM:
; $C2   - Flag for the switch being hit.
; $1558 - Timer for the switch's bounce animation.
; $1564 - Unused timer set whenever hit from below. Not used for anything, though.
; Light switch MAIN
    LDA.B SpriteLock                          ; Branch to just draw graphics if game frozen.
    BNE CODE_03C22B
    JSL InvisBlkMainRt                        ; Make solid.
    JSR SubOffscreen0Bnk3                     ; Process offscreen from -$40 to +$30.
    LDA.W SpriteMisc1558,X
    CMP.B #$05                                ; Branch to just draw graphics if the switch hasn't been hit.
    BNE CODE_03C22B
    STZ.B SpriteTableC2,X                     ; Clear flag for the block being hit.
    LDY.B #!SFX_SWITCH                        ; \ Play sound effect; SFX for hitting the light switch block.
    STY.W SPCIO0                              ; /
    PHA
    LDY.B #$09
CODE_03C211:
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BNE +
    LDA.W SpriteNumber,Y
    CMP.B #$C6                                ; Loop through all the sprites to find any spotlight sprites.
    BNE +                                     ; If one is found, invert the "active" flag for it.
    LDA.W SpriteTableC2,Y
    EOR.B #$01
    STA.W SpriteTableC2,Y
  + DEY
    BPL CODE_03C211
    PLA
CODE_03C22B:
    LDA.W SpriteMisc1558,X                    ; Light switch GFX routine.
    LSR A
    TAY
    LDA.B Layer1YPos
    PHA
    CLC                                       ; Offset Y position, for the bounce animation.
    ADC.W DATA_03C1EC,Y
    STA.B Layer1YPos
    LDA.B Layer1YPos+1
    PHA
    ADC.B #$00
    STA.B Layer1YPos+1
    JSL GenericSprGfxRt2                      ; Draw a 16x16 tile.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$2A                                ; Tile to use for the light switch block.
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$100,Y
    AND.B #$BF                                ; Clear X flip from YXPPCCCT (but not Y, for some reason).
    STA.W OAMTileAttr+$100,Y
    PLA
    STA.B Layer1YPos+1                        ; Restore Y position.
    PLA
    STA.B Layer1YPos
    RTS


ChainsawMotorTiles:
    db $E0,$C2,$C0,$C2

DATA_03C25F:
    db $F2,$0E

DATA_03C261:
    db $33,$B3

CODE_03C263:
; Tile numbers for the chainsaw's mechanism (not the actual saw, which is constant).
; Y offsets between each tile of the chainsaw, indexed by whether it's upright or upside-down.
; YXPPCCCT for the chainsaw, indexed by whether it's upright or upside-down.
    PHB                                       ; Wrapper; Chainsaw GFX routine.
    PHK
    PLB
    JSR ChainsawGfx
    PLB
    RTL

ChainsawGfx:
    JSR GetDrawInfoBnk3
    PHX
    LDA.B SpriteNumber,X
    SEC
    SBC.B #$65                                ; Get data based on whether this is the upright chainsaw (65) or upside-down chainsaw (66).
    TAX
    LDA.W DATA_03C25F,X                       ; $03 = Y offset between each tile.
    STA.B _3
    LDA.W DATA_03C261,X                       ; $04 = YXPPCCCT for each tile
    STA.B _4
    PLX
    LDA.B EffFrame
    AND.B #$02                                ; $02 = additional Y offset for animating the saw
    STA.B _2
    LDA.B _0
    SEC
    SBC.B #$08                                ; Store X positions to OAM.
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    STA.W OAMTileXPos+$108,Y
    LDA.B _1
    SEC
    SBC.B #$08
    STA.W OAMTileYPos+$100,Y
    CLC
    ADC.B _3                                  ; Store Y positions to OAM.
    CLC
    ADC.B _2
    STA.W OAMTileYPos+$104,Y
    CLC
    ADC.B _3
    STA.W OAMTileYPos+$108,Y
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03                                ; Animate the chainsaw's motor.
    PHX
    TAX
    LDA.W ChainsawMotorTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    LDA.B #$AE                                ; Tile A for the chainsaw's saw.
    STA.W OAMTileNo+$104,Y
    LDA.B #$8E                                ; Tile B for the chainsaw's saw.
    STA.W OAMTileNo+$108,Y
    LDA.B #$37
    STA.W OAMTileAttr+$100,Y
    LDA.B _4                                  ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y
    LDY.B #$02
    TYA                                       ; Upload 3 16x16 tiles to OAM.
    JSL FinishOAMWrite
    RTS

TriggerInivis1Up:
    PHX                                       ; \ Find free sprite slot (#$0B-#$00); Subroutine to spawn a 1up once all 4 invisible checkpoints have been touched.
    LDX.B #$0B                                ; |
CODE_03C2DC:
    LDA.W SpriteStatus,X                      ; |
    BEQ Generate1Up                           ; |; Find an empty sprite slot and return if none found.
    DEX                                       ; |
    BPL CODE_03C2DC                           ; |
    PLX                                       ; |
    RTL                                       ; /

Generate1Up:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$78                                ; \ Sprite = 1Up; Sprite to spawn (1up).
    STA.B SpriteNumber,X                      ; /
    LDA.B PlayerXPosNext                      ; \ Sprite X position = Mario X position
    STA.B SpriteXPosLow,X                     ; |
    LDA.B PlayerXPosNext+1                    ; |
    STA.W SpriteXPosHigh,X                    ; /; Spawn at Mario's position.
    LDA.B PlayerYPosNext                      ; \ Sprite Y position = Matio Y position
    STA.B SpriteYPosLow,X                     ; |
    LDA.B PlayerYPosNext+1                    ; |
    STA.W SpriteYPosHigh,X                    ; /
    JSL InitSpriteTables                      ; Load sprite tables
    LDA.B #$10                                ; \ Disable interaction timer = #$10; Disable contact with Mario briefly.
    STA.W SpriteMisc154C,X                    ; /
    JSR PopupMushroom
    PLX
    RTL

InvisMushroom:
    JSR GetDrawInfoBnk3                       ; Invisible mushroom MAIN.
    JSL MarioSprInteract                      ; \ Return if no interaction; Return if not in contact with Mario.
    BCC Return03C347                          ; /
    LDA.B #$74                                ; \ Replace, Sprite = Mushroom; Sprite invisible mushroom spawns (mushroom).
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables                      ; Reset sprite tables
    LDA.B #$20                                ; \ Disable interaction timer = #$20; Disable contact for the mushroom with Mario briefly.
    STA.W SpriteMisc154C,X                    ; /
    LDA.B SpriteYPosLow,X                     ; \ Sprite Y position = Mario Y position - $000F
    SEC                                       ; |
    SBC.B #$0F                                ; |
    STA.B SpriteYPosLow,X                     ; |; Spawn above the invisible mushroom.
    LDA.W SpriteYPosHigh,X                    ; |
    SBC.B #$00                                ; |
    STA.W SpriteYPosHigh,X                    ; /
PopupMushroom:
    LDA.B #$00                                ; \ Sprite direction = dirction of Mario's X speed
    LDY.B PlayerXSpeed+1                      ; |
    BPL +                                     ; |; Spawn moving away from Mario.
    INC A                                     ; |
  + STA.W SpriteMisc157C,X                    ; /
    LDA.B #$C0                                ; \ Set upward speed; Initial Y speed for the mushroom.
    STA.B SpriteYSpeed,X                      ; /
    LDA.B #!SFX_ITEMBLOCK                     ; \ Play sound effect; SFX for spawning a mushroom from the invisible mushroom sprite.
    STA.W SPCIO3                              ; /
Return03C347:
    RTS


NinjiSpeedY:
    db $D0,$C0,$B0,$D0

Ninji:
; Y speeds the Ninji can jump with.
; Ninji misc RAM:
; $C2   - Counter for the number of times the Ninji has jumped.
; $1540 - Timer for waiting between jumps.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame. 0 = normal, 1 = jumping
; Ninji MAIN
    JSL GenericSprGfxRt2                      ; Draw sprite uing the routine for sprites <= 53; Draw a 16x16 sprite.
    LDA.B SpriteLock                          ; \ Return if sprites locked; Return if game frozen.
    BNE Return03C38F                          ; /
    JSR SubHorzPosBnk3                        ; \ Always face mario
    TYA                                       ; |; Face Mario.
    STA.W SpriteMisc157C,X                    ; /
    JSR SubOffscreen0Bnk3                     ; Only process while onscreen; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Interact with mario; Process interaction with Mario and other sprites.
    JSL UpdateSpritePos                       ; Update position based on speed values; Update X/Y position, apply gravity, and process block interaction.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Branch if not on the ground.
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; Clear Y speed.
    LDA.W SpriteMisc1540,X                    ; Branch if not time to jump.
    BNE +
    LDA.B #$60                                ; How long the Ninji waits between jumps.
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
    LDA.B SpriteTableC2,X
    AND.B #$03                                ; Set Y speed for the jump.
    TAY
    LDA.W NinjiSpeedY,Y
    STA.B SpriteYSpeed,X
  + LDA.B #$00
    LDY.B SpriteYSpeed,X
    BMI +                                     ; Set animation frame.
    INC A
  + STA.W SpriteMisc1602,X
Return03C38F:
    RTS

CODE_03C390:
    PHB                                       ; Dry Bones / Bony Beetle GFX routine container.
    PHK
    PLB
    LDA.W SpriteMisc157C,X
    PHA
    LDY.W SpriteMisc15AC,X
    BEQ +                                     ; Handle turning the sprite around if its turn timer is set.
    CPY.B #$05
    BCC +
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + JSR CODE_03C3DA                           ; Draw GFX.
    PLA
    STA.W SpriteMisc157C,X
    PLB
    RTL

; Bony Beetle's GFX routine.
  - JSL GenericSprGfxRt2                      ; Draw a 16x16 sprite.
    RTS


DryBonesTileDispX:
    db $00,$08,$00,$00,$F8,$00,$00,$04
    db $00,$00,$FC,$00

DryBonesGfxProp:
    db $43,$43,$43,$03,$03,$03

DryBonesTileDispY:
    db $F4,$F0,$00,$F4,$F1,$00,$F4,$F0
    db $00

DryBonesTiles:
    db $00,$64,$66,$00,$64,$68,$82,$64
    db $E6

DATA_03C3D7:
    db $00,$00,$FF

CODE_03C3DA:
; Dry Bones tile X displacements. Bone, head, body for each frame.
; Left
; Right
; Left (turning)
; Right (turning)
; Dry Bones YXPPCCCT. Bone, head, body.
; Left
; Right
; Dry Bones tile Y displacements; bone, head, body for each frame. Bone byte is unused for walking.
; Walk A
; Walk B
; Throwing bone
; Dry Bones tiles; bone, head, body for each frame. Bone byte is unused for walking.
; Walk A
; Walk B
; Throwing bone
; Number of tiles for each frame, subtracted from 2. (i.e. 00 = 2 tiles, FF = 3)
; Walk A
; Walk B
; THrowing bone
    LDA.B SpriteNumber,X                      ; Dry Bones / Buzzy Beetle GFX routine.
    CMP.B #$31                                ; Branch if running the Buzzy Beetle, to just draw a 16x16.
    BEQ -
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc15AC,X
    STA.B _5
    LDA.W SpriteMisc157C,X
    ASL A                                     ; Set up some additional scratch RAM.
    ADC.W SpriteMisc157C,X
    STA.B _2                                  ; $02 = Direction (times 3)
    PHX                                       ; $03 = Animation frame (times 3)
    LDA.W SpriteMisc1602,X                    ; $04 = Number of tiles
    PHA                                       ; $05 = Turn timer
    ASL A
    ADC.W SpriteMisc1602,X
    STA.B _3
    PLX
    LDA.W DATA_03C3D7,X
    STA.B _4
    LDX.B #$02
CODE_03C404:
    PHX
    TXA
    CLC
    ADC.B _2
    TAX
    PHX
    LDA.B _5                                  ; Get X displacement index.
    BEQ +
    TXA
    CLC
    ADC.B #$06
    TAX
  + LDA.B _0
    CLC                                       ; Set X displacement.
    ADC.W DryBonesTileDispX,X
    STA.W OAMTileXPos+$100,Y
    PLX
    LDA.W DryBonesGfxProp,X
    ORA.B SpriteProperties                    ; Set YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    PLA
    PHA
    CLC
    ADC.B _3
    TAX
    LDA.B _1                                  ; Set Y displacement.
    CLC
    ADC.W DryBonesTileDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DryBonesTiles,X                     ; Set tile number.
    STA.W OAMTileNo+$100,Y
    PLX
    INY
    INY
    INY
    INY
    DEX
    CPX.B _4                                  ; Loop for the correct number of tiles (2 or 3).
    BNE CODE_03C404
    PLX
    LDY.B #$02
    TYA                                       ; Draw 2 or 3 16x16s.
    JSL FinishOAMWrite
    RTS

CODE_03C44E:
    LDA.W SpriteOffscreenX,X                  ; Routine for the Dry Bones to spawn a bone.
    ORA.W SpriteOffscreenVert,X               ; Return if offscreen.
    BNE Return03C460
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_03C458:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_03C461                           ; |; Find an empty extended sprite slot, and return if none found.
    DEY                                       ; |
    BPL CODE_03C458                           ; |
Return03C460:
    RTL                                       ; / Return if no free slots

CODE_03C461:
    LDA.B #$06                                ; \ Extended sprite = Bone; Set extended sprite number.
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteYPosLow,X
    SEC                                       ; Set Y position.
    SBC.B #$10                                ; Y displacement of the Dry Bones' bone.
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W ExtSpriteYPosHigh,Y
    LDA.B SpriteXPosLow,X
    STA.W ExtSpriteXPosLow,Y                  ; Set X position.
    LDA.W SpriteXPosHigh,X
    STA.W ExtSpriteXPosHigh,Y
    LDA.W SpriteMisc157C,X
    LSR A
    LDA.B #$18                                ; X speed of the bone when going right.
    BCC +
    LDA.B #$E8                                ; X speed of the bone when going left.
  + STA.W ExtSpriteXSpeed,Y
    RTL


DATA_03C48F:
    db $01,$FF

DATA_03C491:
    db $FF,$90

DiscoBallTiles:
    db $80,$82,$84,$86,$88,$8C,$C0,$C2
    db $C2

DATA_03C49C:
    db $31,$33,$35,$37,$31,$33,$35,$37
    db $39

CODE_03C4A5:
; Speeds the spotlight's window moves with.
; Max positions for the spotlight's window to move to.
; Tile numbers for the dark room spotlight First 8 used when active, 9th used when inactive.
; YXPPCCCT for the dark room spotlight. First 8 used when active, 9th used when inactive.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM; Spotlight GFX routine.
    LDA.B #$78
    STA.W OAMTileXPos+$100,Y                  ; Set position at the top-middle of the screen.
    LDA.B #$28
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.B SpriteTableC2,X
    LDX.B #$08
    AND.B #$01
    BEQ +                                     ; Get animation frame.
    LDA.B TrueFrame
    LSR A
    AND.B #$07
    TAX
  + LDA.W DiscoBallTiles,X                    ; Set current tile number for the animation.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_03C49C,X                       ; Set current YXPPCCCT for the animation.
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A                                     ; Set size as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    PLX
    RTS


DATA_03C4D8:
    db $10,$8C

DATA_03C4DA:
    db $42,$31

DarkRoomWithLight:
; Back area colors (low byte) for usage by the spotlight.
; First color is when inactive, second is active.
; Back area colors (high byte) for usage by the spotlight.
; Spotlight misc RAM:
; $C2   - Flag to indicate whether the spotlight is active (1) or not (0).
; $1534 - Flag to indicate this spotlight is the "true" one (i.e. not a second one spawned later).
    LDA.W SpriteMisc1534,X                    ; Dark Room Spotlight MAIN (disco ball)
    BNE CODE_03C500
    LDY.B #$09
CODE_03C4E3:
    CPY.W CurSpriteProcess
    BEQ +
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BNE +                                     ; If another spotlight has already been spawned, delete this one.
    LDA.W SpriteNumber,Y
    CMP.B #$C6
    BNE +
    STZ.W SpriteStatus,X
Return03C4F9:
    RTS

  + DEY
    BPL CODE_03C4E3
    INC.W SpriteMisc1534,X
CODE_03C500:
    JSR CODE_03C4A5                           ; Draw GFX.
    LDA.B #$FF                                ; Set CGADSUB (enable half-color subtract on every layer).
    STA.B ColorSettings
    LDA.B #$20                                ; Set CGWSEL (enable color math inside window only).
    STA.B ColorAddition
    LDA.B #$20                                ; Set WOBJSEL (enable window on BG2/BG4/color only).
    STA.B OBJCWWindow
    LDA.B #$80                                ; Enable HDMA on channel 7.
    STA.W HDMAEnable
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY
    LDA.W DATA_03C4D8,Y                       ; Set color for addition based on whether the spotlight is active or not.
    STA.W BackgroundColor
    LDA.W DATA_03C4DA,Y
    STA.W BackgroundColor+1
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return03C4F9
    LDA.W LightSkipInit
    BNE +                                     ; Initialize the spotlight window if it hasn't already been.
    LDA.B #$00                                ; Left position of the base.
    STA.W LightBotWinOpenPos
    LDA.B #$90                                ; Right position of the base.
    STA.W LightBotWinClosePos
    LDA.B #$78                                ; Left position of the top.
    STA.W LightTopWinOpenPos
    LDA.B #$87                                ; Right position of the top.
    STA.W LightTopWinClosePos
    LDA.B #$01                                ; (unused)
    STA.W LightExists
    STZ.W LightMoveDir                        ; Set spotlight to move right initially.
    INC.W LightSkipInit
  + LDY.W LightMoveDir                        ; Spotlight window has been initialized.
    LDA.W LightBotWinOpenPos
    CLC                                       ; Update left position of the base.
    ADC.W DATA_03C48F,Y
    STA.W LightBotWinOpenPos
    LDA.W LightBotWinClosePos
    CLC                                       ; Update right position of the base.
    ADC.W DATA_03C48F,Y
    STA.W LightBotWinClosePos
    CMP.W DATA_03C491,Y
    BNE +
    LDA.W LightMoveDir                        ; If at the maximum position in the current direction,
    INC A                                     ; invert direction of the spotlight's movement.
    AND.B #$01
    STA.W LightMoveDir
  + LDA.B TrueFrame
    AND.B #$03                                ; Return if not a frame to update the window.
    BNE Return03C4F9
    LDY.B #$00
    LDA.W LightTopWinOpenPos
    STA.W LightWinOpenCalc
    SEC
    SBC.W LightBotWinOpenPos
    BCS +                                     ; Get width between the top-left and bottom-left windows,
    INY                                       ; and set some related addresses for calculating the window.
    EOR.B #$FF
    INC A
  + STA.W LightLeftWidth
    STY.W LightLeftRelPos
    STZ.W LightWinOpenMove
    LDY.B #$00
    LDA.W LightTopWinClosePos
    STA.W LightWinCloseCalc
    SEC
    SBC.W LightBotWinClosePos
    BCS +                                     ; Get width between the top-right and bottom-right windows,
    INY                                       ; and set some related addresses for calculating the window.
    EOR.B #$FF
    INC A
  + STA.W LightRightWidth
    STY.W LightRightRelPos
    STZ.W LightWinCloseMove
    LDA.B SpriteTableC2,X                     ; $0F = flag for whether the spotlight is active.
    STA.B _F
    PHX
    REP #$10                                  ; XY->16
    LDX.W #$0000
CODE_03C5B8:
; Loop for updating the window HDMA table.
    CPX.W #$005F                              ; If above the spotlight, set the window fully across the scanline.
    BCC CODE_03C607
    LDA.W LightWinOpenMove
    CLC
    ADC.W LightLeftWidth
    STA.W LightWinOpenMove
    BCS CODE_03C5CD
    CMP.B #$CF
    BCC +                                     ; Get left window position for the current scanline.
CODE_03C5CD:
    SBC.B #$CF
    STA.W LightWinOpenMove
    INC.W LightWinOpenCalc
    LDA.W LightLeftRelPos
    BNE +
    DEC.W LightWinOpenCalc
    DEC.W LightWinOpenCalc
  + LDA.W LightWinCloseMove
    CLC
    ADC.W LightRightWidth
    STA.W LightWinCloseMove
    BCS CODE_03C5F0
    CMP.B #$CF
    BCC +
CODE_03C5F0:
    SBC.B #$CF                                ; Get right window position for the current scanline.
    STA.W LightWinCloseMove
    INC.W LightWinCloseCalc
    LDA.W LightRightRelPos
    BNE +
    DEC.W LightWinCloseCalc
    DEC.W LightWinCloseCalc
  + LDA.B _F                                  ; Branch if the spotlight actually is active.
    BNE CODE_03C60F
CODE_03C607:
    LDA.B #$01                                ; Full window on the current scanline.
    STA.W WindowTable,X                       ; Set width as 0x0100.
    DEC A
    BRA +

CODE_03C60F:
    LDA.W LightWinOpenCalc                    ; Spotlight is active and there is an opening in the window.
    STA.W WindowTable,X
    LDA.W LightWinCloseCalc                   ; Set width as calculated.
  + STA.W WindowTable+1,X
    INX
    INX                                       ; Loop for all the scanlines.
    CPX.W #con($01C0,$01C0,$01C0,$01C0,$01E0)
    BNE CODE_03C5B8
    SEP #$10                                  ; XY->8
    PLX
    RTS


DATA_03C626:
    db $14,$28,$38,$20,$30,$4C,$40,$34
    db $2C,$1C,$08,$0C,$04,$0C,$1C,$24
    db $2C,$38,$40,$48,$50,$5C,$5C,$6C
    db $4C,$58,$24,$78,$64,$70,$78,$7C
    db $70,$68,$58,$4C,$40,$34,$24,$04
    db $18,$2C,$0C,$0C,$14,$18,$1C,$24
    db $2C,$28,$24,$30,$30,$34,$38,$3C
    db $44,$54,$48,$5C,$68,$40,$4C,$40
    db $3C,$40,$50,$54,$60,$54,$4C,$5C
    db $5C,$68,$74,$6C,$7C,$78,$68,$80
    db $18,$48,$2C,$1C

DATA_03C67A:
    db $1C,$0C,$08,$1C,$14,$08,$14,$24
    db $28,$2C,$30,$3C,$44,$4C,$44,$34
    db $40,$34,$24,$1C,$10,$0C,$18,$18
    db $2C,$28,$68,$28,$34,$34,$38,$40
    db $44,$44,$38,$3C,$44,$48,$4C,$5C
    db $5C,$54,$64,$74,$74,$88,$80,$94
    db $8C,$78,$6C,$64,$70,$7C,$8C,$98
    db $90,$98,$84,$84,$88,$78,$78,$6C
    db $5C,$50,$50,$48,$50,$5C,$64,$64
    db $74,$78,$74,$64,$60,$58,$54,$50
    db $50,$58,$30,$34

DATA_03C6CE:
    db $20,$30,$39,$47,$50,$60,$70,$7C
    db $7B,$80,$7D,$78,$6E,$60,$4F,$47
    db $41,$38,$30,$2A,$20,$10,$04,$00
    db $00,$08,$10,$20,$1A,$10,$0A,$06
    db $0F,$17,$16,$1C,$1F,$21,$10,$18
    db $20,$2C,$2E,$3B,$30,$30,$2D,$2A
    db $34,$36,$3A,$3F,$45,$4D,$5F,$54
    db $4E,$67,$70,$67,$70,$5C,$4E,$40
    db $48,$56,$57,$5F,$68,$72,$77,$6F
    db $66,$60,$67,$5C,$57,$4B,$4D,$54
    db $48,$43,$3D,$3C

DATA_03C722:
    db $18,$1E,$25,$22,$1A,$17,$20,$30
    db $41,$4F,$61,$70,$7F,$8C,$94,$92
    db $A0,$86,$93,$88,$88,$78,$66,$50
    db $40,$30,$22,$20,$2C,$30,$40,$4F
    db $59,$51,$3F,$39,$4C,$5F,$6A,$6F
    db $77,$7E,$6C,$60,$58,$48,$3D,$2F
    db $28,$38,$44,$30,$36,$27,$21,$2F
    db $39,$2A,$2F,$39,$40,$3F,$49,$50
    db $60,$59,$4C,$51,$48,$4F,$56,$67
    db $5B,$68,$75,$7D,$87,$8A,$7A,$6B
    db $70,$82,$73,$92

DATA_03C776:
    db $60,$B0,$40,$80

FireworkSfx1:
    db !SFX_FIREWORKFIRE1
    db $00
    db !SFX_FIREWORKFIRE1
    db !SFX_FIREWORKFIRE2

FireworkSfx2:
    db $00
    db !SFX_FIREWORKFIRE3
    db $00
    db $00

FireworkSfx3:
    db !SFX_FIREWORKBANG1
    db $00
    db !SFX_FIREWORKBANG1
    db !SFX_FIREWORKBANG2

FireworkSfx4:
    db $00
    db !SFX_FIREWORKBANG3
    db $00
    db $00

DATA_03C78A:
    db $00,$AA,$FF,$AA

DATA_03C78E:
    db $00,$7E,$27,$7E

DATA_03C792:
    db $C0,$C0,$FF,$C0

CODE_03C796:
; Max X offset of each firework particle from the center of a normal explosion.
; Subtract #$40 from this value for the offset.
; Max Y offset of each firework particle from the center of a normal explosion.
; Subtract #$50 from this value for the offset.
; Max X offset of each firework particle from the center of the heart explosion.
; Subtract #$40 from this value for the offset.
; Max Y offset of each firework particle from the center of the heart explosion.
; Subtract #$50 from this value for the offset.
; X position of each firework.
; SFX (1DF9) to use when first shooting each firework.
; SFX (1DFC) to use when first shooting each firework.
; SFX (1DF9) to use when exploding each firework.
; SFX (1DFC) to use when exploding each firework.
; Low byte of colors to use for the background color when a firework explodes.
; High byte of colors to use for the background color when a firework explodes.
; Frames between each firework.
; Peach phase 7 - Spawning fireworks
    LDA.W SpriteMisc1564,X                    ; Branch if the fireworks aren't done yet.
    BEQ CODE_03C7A7
    DEC A                                     ; Return if not time to fade to the credits.
    BNE +
    INC.W CutsceneID
    LDA.B #$FF                                ; Start fade to credits.
    STA.W EndLevelTimer
  + RTS

CODE_03C7A7:
    LDA.W SpriteMisc1564+9                    ; Not done shooting fireworks.
    AND.B #$03
    TAY
    LDA.W DATA_03C78A,Y                       ; Animate the flashing from the fireworks exploding.
    STA.W BackgroundColor
    LDA.W DATA_03C78E,Y
    STA.W BackgroundColor+1
    LDA.W SpriteMisc1FE2+9                    ; Return if not time to spawn a new firework.
    BNE Return03C80F
    LDA.W SpriteMisc1534,X
    CMP.B #$04                                ; Branch if the last firework has been fired.
    BEQ CODE_03C810
    LDY.B #$01
CODE_03C7C7:
    LDA.W SpriteStatus,Y
    BEQ CODE_03C7D0                           ; Find an empty sprite slot (in slots 0/1) to spawn the firework in, and return if none found.
    DEY
    BPL CODE_03C7C7
    RTS

CODE_03C7D0:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$7A                                ; Sprite to spawn (firework).
    STA.W SpriteNumber,Y
    LDA.B #$00
    STA.W SpriteXPosHigh,Y
    LDA.B #$A8
    CLC
    ADC.B Layer1YPos
    STA.W SpriteYPosLow,Y                     ; Spawn at the bottom of the screen.
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    PLX
    PHX
    LDA.W SpriteMisc1534,X
    AND.B #$03                                ; Track which firework this was.
    STA.W SpriteMisc1534,Y
    TAX
    LDA.W DATA_03C792,X                       ; Set time until next firework.
    STA.W SpriteMisc1FE2+9
    LDA.W DATA_03C776,X                       ; Set X position for this firework.
    STA.W SpriteXPosLow,Y
    PLX
    INC.W SpriteMisc1534,X                    ; Increment counter for number of fireworks.
Return03C80F:
    RTS

CODE_03C810:
; Last firework has been shot, wait to fade to credits.
    LDA.B #$70                                ; How long until the game fades to credits after the fireworks.
    STA.W SpriteMisc1564,X
    RTS

Firework:
; Firework misc RAM:
; $B6   - Used as a timer for decelerating the Y speed while shooting up.
; $C2   - Sprite phase.
; 0 = initial fire, 1 = shooting up, 2 = exploding, 3 = fading away
; $151C - Speed at which the explosion is expanding.
; $1534 - Which firework this is. 0 = big, 1 = small, 2 = medium, 3 = heart
; $1564 - Timer for waiting to play the second part of the firing sound effect.
; Slot #9's is also used for timing the explosion color flash effect.
; $1570 - Current "radius" of the explosion.
; $15AC - Timer for waiting to play the explosion sound effect.
; $1602 - Animation set for the particles. Valid values are 0-9.
    LDA.B SpriteTableC2,X                     ; Firework MAIN
    JSL ExecutePtr

    dw CODE_03C828
    dw CODE_03C845
    dw CODE_03C88D
    dw CODE_03C941

FireworkSpeedY:
    db $E4,$E6,$E4,$E2

CODE_03C828:
; Fireworks phase pointers.
; 0 - Initial fire
; 1 - Shooting up
; 2 - Exploding
; 3 - Fading away
; Y speeds to shoot each firework with.
    LDY.W SpriteMisc1534,X                    ; Fireworks phase 0 - Initial fire
    LDA.W FireworkSpeedY,Y                    ; Set Y speed.
    STA.B SpriteYSpeed,X
    LDA.B #!SFX_YOSHISTOMP                    ; \ Play sound effect; SFX for shooting a firework.
    STA.W SPCIO3                              ; /
    LDA.B #$10                                ; Set timer to wait a bit before playing the second part of the shoot sound effect.
    STA.W SpriteMisc1564,X
    INC.B SpriteTableC2,X                     ; Increment to phase 1.
    RTS


DATA_03C83D:
    db $14,$0C,$10,$15

DATA_03C841:
    db $08,$10,$0C,$05

CODE_03C845:
; Initial speeds for each firework's particles.
; Delay before the explosion sound for each firework.
    LDA.W SpriteMisc1564,X                    ; Fireworks phase 1 - Shooting up
    CMP.B #$01
    BNE +
    LDY.W SpriteMisc1534,X                    ; Once time to, play the second/third part of the firework shooting sound effect.
    LDA.W FireworkSfx1,Y                      ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.W FireworkSfx2,Y                      ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + JSL UpdateYPosNoGvtyW                     ; Update Y position.
    INC.B SpriteXSpeed,X
    LDA.B SpriteXSpeed,X
    AND.B #$03                                ; Handle Y deceleration.
    BNE +
    INC.B SpriteYSpeed,X
  + LDA.B SpriteYSpeed,X
    CMP.B #$FC                                ; Branch if it hasn't slowed down enough to explode.
    BNE +
    INC.B SpriteTableC2,X                     ; Increment phase pointer to 2.
    LDY.W SpriteMisc1534,X
    LDA.W DATA_03C83D,Y                       ; Set initial speed for the explosion's particles.
    STA.W SpriteMisc151C,X
    LDA.W DATA_03C841,Y                       ; Set timer for waiting before the exposion sound.
    STA.W SpriteMisc15AC,X
    LDA.B #$08                                ; Set timer for the background color flash.
    STA.W SpriteMisc1564+9
  + JSR CODE_03C96D                           ; Draw the firework.
    RTS


DATA_03C889:
    db $FF,$80,$C0,$FF

CODE_03C88D:
; Maximum sizes for each explosion.
    LDA.W SpriteMisc15AC,X                    ; Fireworks phase 2 - Exploding
    DEC A
    BNE +
    LDY.W SpriteMisc1534,X                    ; Once time to, play the explosion part of the firework sound effect.
    LDA.W FireworkSfx3,Y                      ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.W FireworkSfx4,Y                      ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + JSR CODE_03C8B1
    LDA.B SpriteTableC2,X
    CMP.B #$02                                ; Expand the explosion. Run twice per frame, for some reason.
    BNE +
    JSR CODE_03C8B1
  + JMP CODE_03C9E9                           ; Draw the particles.

CODE_03C8B1:
    LDY.W SpriteMisc1534,X                    ; Subroutine to expand the firework's explosion.
    LDA.W SpriteMisc1570,X
    CLC                                       ; Expand the explosion.
    ADC.W SpriteMisc151C,X                    ; Branch if it's overflows, to cap at #$FF.
    STA.W SpriteMisc1570,X
    BCS ADDR_03C8DB
    CMP.W DATA_03C889,Y                       ; Branch if at the maximum size for this explosion.
    BCS CODE_03C8E0
    LDA.W SpriteMisc151C,X
    CMP.B #$02
    BCC CODE_03C8D4
    SEC
    SBC.B #$01                                ; Decelerate the speed of the explosion, then branch down.
    STA.W SpriteMisc151C,X
    BCS +
CODE_03C8D4:
    LDA.B #$01
    STA.W SpriteMisc151C,X
    BRA +

ADDR_03C8DB:
; Overflowed explosion size.
    LDA.B #$FF                                ; Cap at #$FF.
    STA.W SpriteMisc1570,X
CODE_03C8E0:
; At maximum explosion size.
    INC.B SpriteTableC2,X                     ; Increment phase pointer to 3.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.W SpriteMisc151C,X                    ; Not at max size.
    AND.B #$FF
    TAY                                       ; Get animation frame for the particles.
    LDA.W DATA_03C8F1,Y
    STA.W SpriteMisc1602,X
    RTS


DATA_03C8F1:
    db $06,$05,$04,$03,$03,$03,$03,$02
    db $02,$02,$02,$02,$02,$02,$01,$01
    db $01,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $03,$03,$03,$03,$03,$03,$03,$03
    db $03,$03,$02,$02,$02,$02,$02,$02
    db $02,$02,$02,$02,$02,$02,$02,$02
    db $02,$02,$02,$02,$02,$02,$02,$02

CODE_03C941:
; Animation frames for the firework's particles as they're exploding outwards.
    LDA.B TrueFrame                           ; Fireworks phase 3 - Fading away
    AND.B #$07                                ; Handle downwards acceleration.
    BNE +
    INC.B SpriteYSpeed,X
  + JSL UpdateYPosNoGvtyW                     ; Update Y position.
    LDA.B #$07
    LDY.B SpriteYSpeed,X
    CPY.B #$08                                ; Erase the particles once they start falling fast enough.
    BNE +
    STZ.W SpriteStatus,X
  + CPY.B #$03
    BCC +                                     ; Get "animation frame" for the particles, based on how fast they're falling.
    INC A
    CPY.B #$05
    BCC +
    INC A
  + STA.W SpriteMisc1602,X
    JSR CODE_03C9E9                           ; Draw the particles.
    RTS


DATA_03C969:
    db $EC,$8E,$EC,$EC

CODE_03C96D:
; Tile numbers for the fireworks.
    TXA                                       ; GFX routine for the firework as it's shooting upwards.
    EOR.B TrueFrame                           ; Only draw once every 4 frames (to make it flash).
    AND.B #$03
    BNE +
    JSR GetDrawInfoBnk3
    LDY.B #$00                                ; OAM index (from $0300) to use for the firework.
    LDA.B _0                                  ; Store X position to OAM.
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y                  ; (mistake?...)
    LDA.B _1                                  ; Store Y position to OAM.
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.W SpriteMisc1534,X
    TAX
    LDA.B TrueFrame
    LSR A
    LSR A                                     ; Store tile number to OAM.
    AND.B #$02
    LSR A
    ADC.W DATA_03C969,X
    STA.W OAMTileNo+$100,Y
    PLX
    LDA.B TrueFrame
    ASL A
    AND.B #$0E
    STA.B _2
    LDA.B TrueFrame
    ASL A
    ASL A                                     ; Store YXPPCCCT to OAM.
    ASL A
    ASL A
    AND.B #$40
    ORA.B _2
    ORA.B #$31
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A                                     ; Store size to OAM as 8x8.
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
  + RTS


DATA_03C9B9:
    db $36,$35,$C7,$34,$34,$34,$34,$24
    db $03,$03,$36,$35,$C7,$34,$34,$24
    db $24,$24,$24,$03,$36,$35,$C7,$34
    db $34,$34,$24,$24,$03,$24,$36,$35
    db $C7,$34,$24,$24,$24,$24,$24,$03
DATA_03C9E1:
    db $00,$01,$01,$00,$00,$FF,$FF,$00

CODE_03C9E9:
; Tile numbers for the particles as they fade away. 03 corresponds to invisible.
; To get a value:
; take frame number mod 4 for row number,
; then value from $1602 for column number.
; X offsets for animating the particle's "shake" as it falls.
    TXA                                       ; GFX routine for the exploded firework's particles.
    EOR.B TrueFrame                           ; $05 = base index for X offsetting the particles as they fall (making them "shake" slightly)
    STA.B _5
    LDA.W SpriteMisc1570,X                    ; $06 = size of the explosion
    STA.B _6
    LDA.W SpriteMisc1602,X                    ; $07 = animation frame for the particles
    STA.B _7
    LDA.B SpriteXPosLow,X                     ; $08 = center X position
    STA.B _8
    LDA.B SpriteYPosLow,X
    SEC                                       ; $09 = center Y position
    SBC.B Layer1YPos
    STA.B _9
    LDA.W SpriteMisc1534,X                    ; $0A = which firework this is
    STA.B _A
    PHX
    LDX.B #$3F
    LDY.B #$00
CODE_03CA0D:
    STX.B _4                                  ; Tile loop for the first set of particles; these ones go into $0200.
    LDA.B _A
    CMP.B #$03
    LDA.W DATA_03C626,X
    BCC +
    LDA.W DATA_03C6CE,X                       ; $00 = Max X offset of the current particle from the center
  + SEC
    SBC.B #$40
    STA.B _0
    PHY
    LDA.B _A
    CMP.B #$03
    LDA.W DATA_03C67A,X
    BCC +
    LDA.W DATA_03C722,X                       ; $01 = Max Y offset of the current particle from the center
  + SEC
    SBC.B #$50
    STA.B _1
    LDA.B _0
    BPL +
    EOR.B #$FF
    INC A
  + STA.W HW_WRMPYA
    LDA.B _6
    STA.W HW_WRMPYB
    NOP                                       ; $02 = X offset * firework size
    NOP
    NOP
    NOP
    LDA.W HW_RDMPY+1
    LDY.B _0
    BPL +
    EOR.B #$FF
    INC A
  + STA.B _2
    LDA.B _1
    BPL +
    EOR.B #$FF
    INC A
  + STA.W HW_WRMPYA
    LDA.B _6
    STA.W HW_WRMPYB
    NOP
    NOP                                       ; $03 = X offset * firework size
    NOP
    NOP
    LDA.W HW_RDMPY+1
    LDY.B _1
    BPL +
    EOR.B #$FF
    INC A
  + STA.B _3
    LDY.B #$00
    LDA.B _7
    CMP.B #$06
    BCC +
    LDA.B _5
    CLC                                       ; If the particle is close to fading away, make it "shake" slightly from side to side.
    ADC.B _4
    LSR A
    LSR A
    AND.B #$07
    TAY
  + LDA.W DATA_03C9E1,Y
    PLY
    CLC                                       ; Store X position to OAM.
    ADC.B _2
    CLC
    ADC.B _8
    STA.W OAMTileXPos,Y
    LDA.B _3
    CLC                                       ; Store Y position to OAM.
    ADC.B _9
    STA.W OAMTileYPos,Y
    PHX
    LDA.B _5
    AND.B #$03
    STA.B _F
    ASL A
    ASL A
    ASL A                                     ; Store tile number to OAM.
    ADC.B _F
    ADC.B _F
    ADC.B _7
    TAX
    LDA.W DATA_03C9B9,X
    STA.W OAMTileNo,Y
    PLX
    LDA.B _5
    LSR A
    NOP
    NOP
    PHX
    LDX.B _A
    CPX.B #$03                                ; Store YXPPCCCT to OAM.
    BEQ +
    EOR.B _4
  + AND.B #$0E
    ORA.B #$31
    STA.W OAMTileAttr,Y
    PLX
    PHY
    TYA
    LSR A
    LSR A                                     ; Set size in OAM as 8x8.
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    PLY
    INY
    INY
    INY
    INY                                       ; Loop for all of the particles.
    DEX
    BMI +
    JMP CODE_03CA0D

  + LDX.B #$53                                ; Done with the first set of particles, now for the second.
CODE_03CADC:
    STX.B _4                                  ; Tile loop for the second set of particles; these ones go into $0300.
    LDA.B _A
    CMP.B #$03
    LDA.W DATA_03C626,X
    BCC +
    LDA.W DATA_03C6CE,X                       ; $00 = Max X offset of the current particle from the center
  + SEC
    SBC.B #$40
    STA.B _0
    LDA.B _A
    CMP.B #$03
    LDA.W DATA_03C67A,X
    BCC +
    LDA.W DATA_03C722,X
  + SEC                                       ; $01 = Max Y offset of the current particle from the center
    SBC.B #$50
    STA.B _1
    PHY
    LDA.B _0
    BPL +
    EOR.B #$FF
    INC A
  + STA.W HW_WRMPYA
    LDA.B _6
    STA.W HW_WRMPYB
    NOP                                       ; $02 = X offset * firework size
    NOP
    NOP
    NOP
    LDA.W HW_RDMPY+1
    LDY.B _0
    BPL +
    EOR.B #$FF
    INC A
  + STA.B _2
    LDA.B _1
    BPL +
    EOR.B #$FF
    INC A
  + STA.W HW_WRMPYA
    LDA.B _6
    STA.W HW_WRMPYB
    NOP
    NOP                                       ; $03 = X offset * firework size
    NOP
    NOP
    LDA.W HW_RDMPY+1
    LDY.B _1
    BPL +
    EOR.B #$FF
    INC A
  + STA.B _3
    LDY.B #$00
    LDA.B _7
    CMP.B #$06
    BCC +
    LDA.B _5
    CLC                                       ; If the particle is close to fading away, make it "shake" slightly from side to side.
    ADC.B _4
    LSR A
    LSR A
    AND.B #$07
    TAY
  + LDA.W DATA_03C9E1,Y
    PLY
    CLC                                       ; Store X position to OAM.
    ADC.B _2
    CLC
    ADC.B _8
    STA.W OAMTileXPos+$100,Y
    LDA.B _3
    CLC                                       ; Store Y position to OAM.
    ADC.B _9
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.B _5
    AND.B #$03
    STA.B _F
    ASL A
    ASL A
    ASL A                                     ; Store tile number to OAM.
    ADC.B _F
    ADC.B _F
    ADC.B _7
    TAX
    LDA.W DATA_03C9B9,X
    STA.W OAMTileNo+$100,Y
    PLX
    LDA.B _5
    LSR A
    NOP
    NOP
    PHX
    LDX.B _A
    CPX.B #$03                                ; Store YXPPCCCT to OAM.
    BEQ +
    EOR.B _4
  + AND.B #$0E
    ORA.B #$31
    STA.W OAMTileAttr+$100,Y
    PLX
    PHY
    TYA
    LSR A
    LSR A                                     ; Set size in OAM as 8x8.
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY                                       ; Loop for all of the particles.
    DEX
    CPX.B #$3F
    BEQ +
    JMP CODE_03CADC

  + PLX
    RTS


ChuckSprGenDispX:
    db $14,$EC

ChuckSprGenSpeedHi:
    db $00,$FF

ChuckSprGenSpeedLo:
    db $18,$E8

CODE_03CBB3:
; Routine to spawn a football for the Puntin' Chuck.
    JSL FindFreeSprSlot                       ; \ Return if no free slots; Return if there are no empty sprite slots.
    BMI +                                     ; /
    LDA.B #$1B                                ; \ Sprite = Football; Sprite to spawn (football).
    STA.W SpriteNumber,Y                      ; /
    PHX
    TYX
    JSL InitSpriteTables
    PLX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    LDA.B SpriteXPosLow,X
    STA.B _1
    LDA.W SpriteXPosHigh,X
    STA.B _0
    PHX                                       ; Spawn at the Chuck's position, offset slightly in front of it.
    LDA.W SpriteMisc157C,X
    TAX
    LDA.B _1
    CLC
    ADC.L ChuckSprGenDispX,X
    STA.W SpriteXPosLow,Y
    LDA.B _0
    ADC.L ChuckSprGenSpeedHi,X
    STA.W SpriteXPosHigh,Y
    LDA.L ChuckSprGenSpeedLo,X                ; Set the X speed for the football.
    STA.W SpriteXSpeed,Y
    LDA.B #$E0                                ; Y speed to spawn the Chuck's football with.
    STA.W SpriteYSpeed,Y
    LDA.B #$10                                ; Set the timer to pause it until it actually gets kicked.
    STA.W SpriteMisc1540,Y
    PLX
  + RTL

CODE_03CC09:
; Wendy/Lemmy misc RAM:
; $C2   - (from Koopa Kid) Which boss the sprite is running.
; 5 = Lemmy, 6 = Wendy
; $151C - Phase pointer.
; 0 = in pipe, 1 = rising, 2 = out of pipe, 3 = lowering, 4 = hit, 5 = falling, 6 = lava.
; $1528 - Emerged animation pointer.
; 0 = looking at camera, 1 = waving hands A, 2 = opening mouth, 3 = looking side to side,
; 4 = weird face A, 5 = legs, 6 = weird face B, 7 = waving hands B, 8 = dummy
; $1540 - Phase timer.
; $1570 - Flag for being a dummy, used to index some tables. 00 = wendy/lemmy, 10 = dummy 1, 20 = dummy 2.
; $1602 - Animation frame.
; 0/1 = hurt, 2/3 = looking at camera, 4/5 = waving hands A, 6/7 = opening mouth,
; 8/9 = look side to side, A/B = sticking tongue out, C/D = legs, E/F = weird face,
; 10/11/12 = waving hands B, 13 = dummy, 14/15/16 = dummy hurt
; $160E - Spawn position index, for deciding which pipes to emerge each sprite from.
    PHB                                       ; Wrapper; Wendy/Lemmy MAIN
    PHK
    PLB
    STZ.W SpriteTweakerB,X
    JSR CODE_03CC14
    PLB
    RTL

CODE_03CC14:
    JSR CODE_03D484                           ; Draw the boss.
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE +                                     ; Return if dead or game frozen.
    LDA.B SpriteLock
    BNE +
    LDA.W SpriteMisc151C,X
    JSL ExecutePtr

    dw CODE_03CC8A
    dw CODE_03CD21
    dw CODE_03CDC7
    dw CODE_03CDEF
    dw CODE_03CE0E
    dw CODE_03CE5A
    dw CODE_03CE89

; Pointers to the different routines for Wendy/Lemmy.
; 0 - Waiting in pipe
; 1 - Rising from pipe
; 2 - Waiting out of pipe
; 3 - Lowering into pipe
; 4 - Hurt
; 5 - Falling
  + RTS                                       ; 6 - Sinking in lava


DATA_03CC38:
    db $18,$38,$58,$78,$98,$B8,$D8,$78
DATA_03CC40:
    db $40,$50,$50,$40,$30,$40,$50,$40
DATA_03CC48:
    db $50,$4A,$50,$4A,$4A,$40,$4A,$48
    db $4A

DATA_03CC51:
    db $02,$04,$06,$08,$0B,$0C,$0E,$10
    db $13

DATA_03CC5A:
    db $00,$01,$02,$03,$04,$05,$06,$00
    db $01,$02,$03,$04,$05,$06,$00,$01
    db $02,$03,$04,$05,$06,$00,$01,$02
    db $03,$04,$05,$06,$00,$01,$02,$03
    db $04,$05,$06,$00,$01,$02,$03,$04
    db $05,$06,$00,$01,$02,$03,$04,$05

CODE_03CC8A:
; Possible X spawn positions for Wendy/Lemmy and the dummies.
; Last byte is unused.
; Corresponding Y spawn positions for Lemmy and his dummies.
; Last byte is unused.
; Length of time to wait while emerging from the pipe with each animation.
; Last byte used for the dummies.
; Animations to randomly choose from for when fully emerged.
; Last byte used for the dummies.
; Indexes to the above X/Y position tables for each RNG number.
; Wendy/Lemmy.
; Dummy 1
; Dummy 2
; Wendy/Lemmy phase 0 - Waiting in pipe.
    LDA.W SpriteMisc1540,X                    ; Return if not time to start rising.
    BNE Return03CCDF
    LDA.W SpriteMisc1570,X
    BNE +
    JSL GetRand                               ; Get a random number 0-F for fetching a position.
    AND.B #$0F
    STA.W SpriteMisc160E,X
  + LDA.W SpriteMisc160E,X
    ORA.W SpriteMisc1570,X
    TAY
    LDA.W DATA_03CC5A,Y                       ; Get X spawn position.
    TAY
    LDA.W DATA_03CC38,Y
    STA.B SpriteXPosLow,X
    LDA.B SpriteTableC2,X
    CMP.B #$06
    LDA.W DATA_03CC40,Y                       ; Get Y spawn position.
    BCC +
    LDA.B #$50                                ; Y position for Wendy's spawn location.
  + STA.B SpriteYPosLow,X
    LDA.B #$08
    LDY.W SpriteMisc1570,X
    BNE +
    JSR CODE_03CCE2
    JSL GetRand
    LSR A
    LSR A
    AND.B #$07                                ; Set up positions, and set animation/timer for emerging.
  + STA.W SpriteMisc1528,X                    ; Also accounts for a dummy instead of Wendy.
    TAY
    LDA.W DATA_03CC48,Y
    STA.W SpriteMisc1540,X
    INC.W SpriteMisc151C,X
    LDA.W DATA_03CC51,Y
    STA.W SpriteMisc1602,X
Return03CCDF:
    RTS


DATA_03CCE0:
    db $10,$20

CODE_03CCE2:
; Flags for the two dummies.
; Set positions for the Wendy/Lemmy dummies.
    LDY.B #$01                                ; Base sprite slot to spawn dummies in.
    JSR CODE_03CCE8
    DEY
CODE_03CCE8:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$29
    STA.W SpriteNumber,Y                      ; Initialize a new dummy.
    PHX
    TYX
    JSL InitSpriteTables
    PLX
    LDA.W DATA_03CCE0,Y                       ; Mark as a dummy.
    STA.W SpriteMisc1570,Y
    LDA.B SpriteTableC2,X
    STA.W SpriteTableC2,Y                     ; Set it as the same sprite as the currently processed one.
    LDA.W SpriteMisc160E,X
    STA.W SpriteMisc160E,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y                    ; Set at the same position as Wendy/Lemmy currently is.
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    RTS

CODE_03CD21:
    LDA.W SpriteMisc1540,X                    ; Wendy/Lemmy phase 1 - Rising from pipe
    BNE +
    LDA.B #$40                                ; When fully extended, reset timer and switch to next phase.
    STA.W SpriteMisc1540,X
    INC.W SpriteMisc151C,X
  + LDA.B #$F8                                ; Y speed when rising from the pipe.
    STA.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW
    RTS


DATA_03CD37:
    db $02,$02,$02,$02,$03,$03,$03,$03
    db $03,$03,$03,$03,$02,$02,$02,$02
    db $04,$04,$04,$04,$05,$05,$04,$05
    db $05,$04,$05,$05,$04,$04,$04,$04
    db $06,$06,$06,$06,$07,$07,$07,$07
    db $07,$07,$07,$07,$06,$06,$06,$06
    db $08,$08,$08,$08,$08,$09,$09,$08
    db $08,$09,$09,$08,$08,$08,$08,$08
    db $0B,$0B,$0B,$0B,$0B,$0A,$0B,$0A
    db $0B,$0A,$0B,$0A,$0B,$0B,$0B,$0B
    db $0C,$0C,$0C,$0C,$0D,$0C,$0D,$0C
    db $0D,$0C,$0D,$0C,$0D,$0D,$0D,$0D
    db $0E,$0E,$0E,$0E,$0E,$0F,$0E,$0F
    db $0E,$0F,$0E,$0F,$0E,$0E,$0E,$0E
    db $10,$10,$10,$10,$11,$12,$11,$10
    db $11,$12,$11,$10,$11,$11,$11,$11
    db $13,$13,$13,$13,$13,$13,$13,$13
    db $13,$13,$13,$13,$13,$13,$13,$13

CODE_03CDC7:
; Animations for Wendy/Lemmy when out of the pipe.
; Looking at camera
; Waving hands
; Opening mouth
; Looking side to side
; Weird face A
; Legs
; Weird face B
; Waving hands
; Dummy
; Wendy/Lemmy phase 2 - Waiting out of pipe.
    JSR CODE_03CEA7                           ; Process interaction with Mario.
    LDA.W SpriteMisc1540,X                    ; Branch if not time to descend back into the pipe.
    BNE +
CODE_03CDCF:
    LDA.B #$24                                ; How long Wendy/Lemmy takes to descend into their pipe.
    STA.W SpriteMisc1540,X
    LDA.B #$03                                ; Switch to phase 3 (descending into pipe).
    STA.W SpriteMisc151C,X
    RTS

  + LSR A                                     ; Not time to descend into the pipe.
    LSR A
    STA.B _0
    LDA.W SpriteMisc1528,X
    ASL A
    ASL A                                     ; Animate the boss.
    ASL A
    ASL A
    ORA.B _0
    TAY
    LDA.W DATA_03CD37,Y
    STA.W SpriteMisc1602,X
    RTS

CODE_03CDEF:
; Wendy/Lemmy phase 3 - Descending into pipe
    LDA.W SpriteMisc1540,X                    ; Branch if not done descending.
    BNE CODE_03CE05
    LDA.W SpriteMisc1570,X                    ; Branch if not a dummy.
    BEQ +
    STZ.W SpriteStatus,X                      ; Erase the dummy.
    RTS

; Wendy/Lemmy fully descended.
  + STZ.W SpriteMisc151C,X                    ; Return to phase 0 (waiting in pipe).
    LDA.B #$30                                ; How long until Wendy/Lemmy/dummies emerge from the pipes.
    STA.W SpriteMisc1540,X
CODE_03CE05:
; Not done descending.
    LDA.B #$10                                ; Speed at which Wendy/Lemmy descend into the pipes.
    STA.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW
    RTS

CODE_03CE0E:
; Wendy/Lemmy phase 4 - Hurt
    LDA.W SpriteMisc1540,X                    ; Branch if not done with the hurt animation.
    BNE CODE_03CE2A
    INC.W SpriteMisc1534,X
    LDA.W SpriteMisc1534,X                    ; Branch if Wendy/Lemmy isn't dead.
    CMP.B #$03                                ; How much HP Wend/Lemmy have.
    BNE CODE_03CDCF
    LDA.B #$05                                ; Switch to phase 5 (falling).
    STA.W SpriteMisc151C,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.B #!SFX_FALL                          ; SFX for Wendy/Lemmy falling.
    STA.W SPCIO0                              ; / Play sound effect
    RTS

CODE_03CE2A:
    LDY.W SpriteMisc1570,X                    ; Not done with the hurt animation.
    BNE CODE_03CE42
CODE_03CE2F:
    CMP.B #$24                                ; Wendy/Lemmy isn't dead yet.
    BNE +
    LDY.B #!SFX_CORRECT                       ; SFX for hitting Wendy/Lemmy (correct).
    STY.W SPCIO3                              ; / Play sound effect
  + LDA.B EffFrame
    LSR A
    LSR A                                     ; Get Wendy/Lemmy's animation frame (0/1).
    AND.B #$01
    STA.W SpriteMisc1602,X
    RTS

CODE_03CE42:
    CMP.B #$10                                ; Dummy was hurt.
    BNE +
    LDY.B #!SFX_WRONG                         ; SFX for hitting one of the dummies (incorrect).
    STY.W SPCIO3                              ; / Play sound effect
  + LSR A
    LSR A
    LSR A                                     ; Get the dummy's animation frame.
    TAY
    LDA.W DATA_03CE56,Y
    STA.W SpriteMisc1602,X
    RTS


DATA_03CE56:
    db $16,$16,$15,$14

CODE_03CE5A:
; Animation frames for the dummy's hurt animation.
; Wendy/Lemmy phase 5 - Falling
    JSL UpdateYPosNoGvtyW                     ; Update Y posiiton.
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +                                     ; Apply gravity.
    CLC
    ADC.B #$03                                ; How quickly Wendy/Lemmy accelerate while falling.
    STA.B SpriteYSpeed,X
  + LDA.W SpriteYPosHigh,X
    BEQ +
    LDA.B SpriteYPosLow,X                     ; Branch if not in the lava yet.
    CMP.B #$85
    BCC +
    LDA.B #$06                                ; Switch to phase 6 (sinking in lava).
    STA.W SpriteMisc151C,X
    LDA.B #$80                                ; How long Wendy/Lemmy sink in the lava for.
    STA.W SpriteMisc1540,X
    LDA.B #!SFX_BOSSINLAVA                    ; SFX for Wendy/Lemmy falling in the lava.
    STA.W SPCIO3                              ; / Play sound effect
    JSL CODE_028528                           ; Create a lava splash.
; Not in the lava yet.
  + BRA CODE_03CE2F                           ; Animate the boss as they fall.

CODE_03CE89:
; Wendy/Lemmy phase 6 - Sinking in lava
    LDA.W SpriteMisc1540,X                    ; Branch if not time to erase the boss.
    BNE +
    STZ.W SpriteStatus,X                      ; Erase the boss.
    INC.W CutsceneID
    LDA.B #$FF                                ; End the level.
    STA.W EndLevelTimer
    LDA.B #!BGM_BOSSCLEAR                     ; SFX for the song after Wendy/Lemmy is defeated.
    STA.W SPCIO2                              ; / Change music
; Not done sinking.
  + LDA.B #$04                                ; How fast Wendy/Lemmy sinks.
    STA.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW                     ; Update Y positino.
    RTS

CODE_03CEA7:
; Mario interaction routine for Wendy/Lemmy.
    JSL MarioSprInteract                      ; Return if not in contact.
    BCC Return03CEF1
    LDA.B PlayerYSpeed+1
    CMP.B #$10                                ; Branch if Mario isn't falling fast enough (to hurt him).
    BMI CODE_03CEED
    JSL DisplayContactGfx                     ; Display a contact sprite.
    LDA.B #$02                                ; Points given for hitting Wendy/Lemmy/dummies.
    JSL GivePoints
    JSL BoostMarioSpeed                       ; Bounce Mario.
    LDA.B #!SFX_SPLAT                         ; SFX for hitting Wendy/Lemmy/dummies.
    STA.W SPCIO0                              ; / Play sound effect
    LDA.W SpriteMisc1570,X
    BNE +
    LDA.B #!SFX_ENEMYHURT                     ; SFX for hitting specifically Wendy/Lemmy (not a dummy). Doubled on top of the other one.
    STA.W SPCIO3                              ; / Play sound effect
    LDA.W SpriteMisc1534,X
    CMP.B #$02                                ; Number of times (minus 1) that Wendy/Lemmy has to be hit before other sprites in the room are erased.
    BNE +
    JSL KillMostSprites
  + LDA.B #$04                                ; Switch to phase 4 (hurt).
    STA.W SpriteMisc151C,X
    LDA.B #$50                                ; How long Wendy/Lemmy stalls after being hit.
    LDY.W SpriteMisc1570,X
    BEQ +
    LDA.B #$1F                                ; How long Wendy/Lemmy stalls after a dummy is hit.
  + STA.W SpriteMisc1540,X
    RTS

CODE_03CEED:
; Wendy/Lemmy hit while not falling fast enough.
    JSL HurtMario                             ; Hurt Mario.
Return03CEF1:
    RTS


DATA_03CEF2:
    db $F8,$08,$F8,$08,$00,$00,$F8,$08
    db $F8,$08,$00,$00,$F8,$00,$00,$00
    db $00,$00,$FB,$00,$FB,$03,$00,$00
    db $F8,$08,$00,$00,$08,$00,$F8,$08
    db $00,$00,$00,$00,$F8,$00,$00,$00
    db $00,$00,$F8,$00,$08,$00,$00,$00
    db $F8,$08,$00,$06,$00,$00,$F8,$08
    db $00,$02,$00,$00,$F8,$08,$00,$04
    db $00,$08,$F8,$08,$00,$00,$08,$00
    db $F8,$08,$00,$00,$00,$00,$F8,$08
    db $00,$00,$00,$00,$F8,$08,$00,$00
    db $08,$00,$F8,$08,$00,$00,$08,$00
    db $F8,$08,$00,$00,$00,$00,$F8,$08
    db $00,$00,$00,$00,$F8,$08,$00,$00
    db $00,$00,$F8,$08,$00,$00,$08,$00
    db $F8,$08,$00,$00,$00,$00,$F8,$08
    db $00,$00,$00,$00,$F8,$08,$00,$00
    db $00,$00

DATA_03CF7C:
    db $F8,$08,$F8,$08,$00,$00,$F8,$08
    db $F8,$08,$00,$00,$F8,$00,$08,$00
    db $00,$00,$FB,$00,$FB,$03,$00,$00
    db $F8,$08,$00,$00,$08,$00,$F8,$08
    db $00,$00,$00,$00,$F8,$00,$08,$00
    db $00,$00,$F8,$00,$08,$00,$00,$00
    db $F8,$08,$00,$06,$00,$08,$F8,$08
    db $00,$02,$00,$08,$F8,$08,$00,$04
    db $00,$08,$F8,$08,$00,$00,$08,$00
    db $F8,$08,$00,$00,$00,$00,$F8,$08
    db $00,$00,$00,$00,$F8,$08,$00,$00
    db $08,$00,$F8,$08,$00,$00,$08,$00
    db $F8,$08,$00,$00,$00,$00,$F8,$08
    db $00,$00,$00,$00,$F8,$08,$00,$00
    db $00,$00,$F8,$08,$00,$00,$08,$00
    db $F8,$08,$00,$00,$00,$00,$F8,$08
    db $00,$00,$00,$00,$F8,$08,$00,$00
    db $00,$00

DATA_03D006:
    db $04,$04,$14,$14,$00,$00,$04,$04
    db $14,$14,$00,$00,$00,$08,$F8,$00
    db $00,$00,$00,$08,$F8,$F8,$00,$00
    db $05,$05,$00,$F8,$F8,$00,$05,$05
    db $00,$00,$00,$00,$00,$08,$F8,$00
    db $00,$00,$00,$08,$00,$00,$00,$00
    db $05,$05,$00,$F8,$00,$00,$05,$05
    db $00,$F8,$00,$00,$05,$05,$00,$0F
    db $F8,$F8,$05,$05,$00,$F8,$F8,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$05,$05,$00,$F8
    db $F8,$00,$05,$05,$00,$F8,$F8,$00
    db $04,$04,$02,$00,$00,$00,$04,$04
    db $01,$00,$00,$00,$04,$04,$00,$00
    db $00,$00,$05,$05,$00,$F8,$F8,$00
    db $05,$05,$00,$00,$00,$00,$05,$05
    db $03,$00,$00,$00,$05,$05,$04,$00
    db $00,$00

DATA_03D090:
    db $04,$04,$14,$14,$00,$00,$04,$04
    db $14,$14,$00,$00,$00,$08,$00,$00
    db $00,$00,$00,$08,$F8,$F8,$00,$00
    db $05,$05,$00,$F8,$F8,$00,$05,$05
    db $00,$00,$00,$00,$00,$08,$00,$00
    db $00,$00,$00,$08,$08,$00,$00,$00
    db $05,$05,$00,$F8,$F8,$00,$05,$05
    db $00,$F8,$F8,$00,$05,$05,$00,$0F
    db $F8,$F8,$05,$05,$00,$F8,$F8,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$05,$05,$00,$F8
    db $F8,$00,$05,$05,$00,$F8,$F8,$00
    db $04,$04,$02,$00,$00,$00,$04,$04
    db $01,$00,$00,$00,$04,$04,$00,$00
    db $00,$00,$05,$05,$00,$F8,$F8,$00
    db $05,$05,$00,$00,$00,$00,$05,$05
    db $03,$00,$00,$00,$05,$05,$04,$00
    db $00,$00

DATA_03D11A:
    db $20,$20,$26,$26,$08,$00,$2E,$2E
    db $24,$24,$08,$00,$00,$28,$02,$00
    db $00,$00,$04,$28,$12,$12,$00,$00
    db $22,$22,$04,$12,$12,$00,$20,$20
    db $08,$00,$00,$00,$00,$28,$02,$00
    db $00,$00,$0A,$28,$13,$00,$00,$00
    db $20,$20,$0C,$02,$00,$00,$20,$20
    db $0C,$02,$00,$00,$22,$22,$06,$03
    db $12,$12,$20,$20,$06,$12,$12,$00
    db $2A,$2A,$00,$00,$00,$00,$2C,$2C
    db $00,$00,$00,$00,$20,$20,$06,$12
    db $12,$00,$20,$20,$06,$12,$12,$00
    db $22,$22,$08,$00,$00,$00,$20,$20
    db $08,$00,$00,$00,$2E,$2E,$08,$00
    db $00,$00,$4E,$4E,$60,$43,$43,$00
    db $4E,$4E,$64,$00,$00,$00,$62,$62
    db $64,$00,$00,$00,$62,$62,$64,$00
    db $00,$00

DATA_03D1A4:
    db $20,$20,$26,$26,$48,$00,$2E,$2E
    db $24,$24,$48,$00,$40,$28,$42,$00
    db $00,$00,$44,$28,$52,$52,$00,$00
    db $22,$22,$44,$52,$52,$00,$20,$20
    db $48,$00,$00,$00,$40,$28,$42,$00
    db $00,$00,$4A,$28,$53,$00,$00,$00
    db $20,$20,$4C,$1E,$1F,$00,$20,$20
    db $4C,$1F,$1E,$00,$22,$22,$44,$03
    db $52,$52,$20,$20,$44,$52,$52,$00
    db $2A,$2A,$00,$00,$00,$00,$2C,$2C
    db $00,$00,$00,$00,$20,$20,$46,$52
    db $52,$00,$20,$20,$46,$52,$52,$00
    db $22,$22,$48,$00,$00,$00,$20,$20
    db $48,$00,$00,$00,$2E,$2E,$48,$00
    db $00,$00,$4E,$4E,$66,$68,$68,$00
    db $4E,$4E,$6A,$00,$00,$00,$62,$62
    db $6A,$00,$00,$00,$62,$62,$6A,$00
    db $00,$00

LemmyGfxProp:
    db $05,$45,$05,$45,$05,$00,$05,$45
    db $05,$45,$05,$00,$05,$05,$05,$00
    db $00,$00,$05,$05,$05,$45,$00,$00
    db $05,$45,$05,$05,$45,$00,$05,$45
    db $05,$00,$00,$00,$05,$05,$05,$00
    db $00,$00,$05,$05,$05,$00,$00,$00
    db $05,$45,$05,$05,$00,$00,$05,$45
    db $45,$45,$00,$00,$05,$45,$05,$05
    db $05,$45,$05,$45,$45,$05,$45,$00
    db $05,$45,$00,$00,$00,$00,$05,$45
    db $00,$00,$00,$00,$05,$45,$45,$05
    db $45,$00,$05,$45,$05,$05,$45,$00
    db $05,$45,$05,$00,$00,$00,$05,$45
    db $05,$00,$00,$00,$05,$45,$05,$00
    db $00,$00,$07,$47,$07,$07,$47,$00
    db $07,$47,$07,$00,$00,$00,$07,$47
    db $07,$00,$00,$00,$07,$47,$07,$00
    db $00,$00

WendyGfxProp:
    db $09,$49,$09,$49,$09,$00,$09,$49
    db $09,$49,$09,$00,$09,$09,$09,$00
    db $00,$00,$09,$09,$09,$49,$00,$00
    db $09,$49,$09,$09,$49,$00,$09,$49
    db $09,$00,$00,$00,$09,$09,$09,$00
    db $00,$00,$09,$09,$09,$00,$00,$00
    db $09,$49,$09,$09,$09,$00,$09,$49
    db $49,$49,$49,$00,$09,$49,$09,$09
    db $09,$49,$09,$49,$49,$09,$49,$00
    db $09,$49,$00,$00,$00,$00,$09,$49
    db $00,$00,$00,$00,$09,$49,$49,$09
    db $49,$00,$09,$49,$09,$09,$49,$00
    db $09,$49,$09,$00,$00,$00,$09,$49
    db $09,$00,$00,$00,$09,$49,$09,$00
    db $00,$00,$05,$45,$05,$05,$45,$00
    db $05,$45,$05,$00,$00,$00,$05,$45
    db $05,$00,$00,$00,$05,$45,$05,$00
    db $00,$00

DATA_03D342:
    db $02,$02,$02,$02,$02,$04,$02,$02
    db $02,$02,$02,$04,$02,$02,$00,$04
    db $04,$04,$02,$02,$00,$00,$04,$04
    db $02,$02,$02,$00,$00,$04,$02,$02
    db $02,$04,$04,$04,$02,$02,$00,$04
    db $04,$04,$02,$02,$00,$04,$04,$04
    db $02,$02,$02,$00,$04,$04,$02,$02
    db $02,$00,$04,$04,$02,$02,$02,$00
    db $00,$00,$02,$02,$02,$00,$00,$04
    db $02,$02,$04,$04,$04,$04,$02,$02
    db $04,$04,$04,$04,$02,$02,$02,$00
    db $00,$04,$02,$02,$02,$00,$00,$04
    db $02,$02,$02,$04,$04,$04,$02,$02
    db $02,$04,$04,$04,$02,$02,$02,$04
    db $04,$04,$02,$02,$02,$00,$00,$04
    db $02,$02,$02,$04,$04,$04,$02,$02
    db $02,$04,$04,$04,$02,$02,$02,$04
    db $04,$04

DATA_03D3CC:
    db $02,$02,$02,$02,$02,$04,$02,$02
    db $02,$02,$02,$04,$02,$02,$00,$04
    db $04,$04,$02,$02,$00,$00,$04,$04
    db $02,$02,$02,$00,$00,$04,$02,$02
    db $02,$04,$04,$04,$02,$02,$00,$04
    db $04,$04,$02,$02,$00,$04,$04,$04
    db $02,$02,$02,$00,$00,$04,$02,$02
    db $02,$00,$00,$04,$02,$02,$02,$00
    db $00,$00,$02,$02,$02,$00,$00,$04
    db $02,$02,$04,$04,$04,$04,$02,$02
    db $04,$04,$04,$04,$02,$02,$02,$00
    db $00,$04,$02,$02,$02,$00,$00,$04
    db $02,$02,$02,$04,$04,$04,$02,$02
    db $02,$04,$04,$04,$02,$02,$02,$04
    db $04,$04,$02,$02,$02,$00,$00,$04
    db $02,$02,$02,$04,$04,$04,$02,$02
    db $02,$04,$04,$04,$02,$02,$02,$04
    db $04,$04

DATA_03D456:
    db $04,$04,$02,$03,$04,$02,$02,$02
    db $03,$03,$05,$04,$01,$01,$04,$04
    db $02,$02,$02,$04,$02,$02,$02

DATA_03D46D:
    db $04,$04,$02,$03,$04,$02,$02,$02
    db $04,$04,$05,$04,$01,$01,$04,$04
    db $02,$02,$02,$04,$02,$02,$02

CODE_03D484:
; X offsets for Lemmy's tiles.
; X offsets for Wendy's tiles.
; [change $CFAF and $CFB5 to 08 to fix Wendy's bow, in conjunction with $03D1A4]
; <- change the 06 to 08 to fix Wendy's bow
; <- change the 02 to 08 to fix Wendy's bow
; Y offsets for Lemmy's tiles.
; Y offsets for Wendy's tiles.
; Lemmy (and dummies) tilemap.
; Wendy (and dummies) tilemap.
; [change $D1D7 to 1F 1E and $D1DD to 1E 1F to fix Wendy's bow, in conjunction with $03CF7C]
; <- change $1E,$1F to $1F,$1E to fix Wendy's bow
; <- change $1F,$1E to $1E,$1F to fix Wendy's bow
; Lemmy's YXPPCCCT properties.
; Wendy's YXPPCCCT properties.
; Tile sizes for Lemmy.
; Tile sizes for Wendy.
; Number of tiles in each animation frame for Lemmy (-1).
; Number of tiles in each animation frame for Wendy (-1).
    JSR GetDrawInfoBnk3                       ; Wendy/Lemmy GFX routine.
    LDA.W SpriteMisc1602,X
    ASL A
    ASL A                                     ; Multiply animation frame by 6,
    ADC.W SpriteMisc1602,X                    ; to get index to the tilemap tables.
    ADC.W SpriteMisc1602,X
    STA.B _2
    LDA.B SpriteTableC2,X
    CMP.B #$06                                ; Branch for Wendy.
    BEQ CODE_03D4DF
    PHX                                       ; Lemmy GFX routine.
    LDA.W SpriteMisc1602,X
    TAX                                       ; Get the number of tiles in this animation frame.
    %LorW_X(LDA,DATA_03D456)
    TAX
  - PHX
    TXA
    CLC                                       ; Get the index to the current tile.
    ADC.B _2
    TAX
    LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W DATA_03CEF2,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W DATA_03D006,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DATA_03D11A,X                       ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.W LemmyGfxProp,X
    ORA.B #$10                                ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Store tile size to OAM.
    TAY
    LDA.W DATA_03D342,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    PLX
    DEX
    BPL -
CODE_03D4DD:
    PLX
    RTS

CODE_03D4DF:
    PHX                                       ; Wendy GFX routine.
    LDA.W SpriteMisc1602,X
    TAX                                       ; Get the number of tiles in this animation frame.
    %LorW_X(LDA,DATA_03D46D)
    TAX
  - PHX
    TXA
    CLC                                       ; Get the index to the current tile.
    ADC.B _2
    TAX
    LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W DATA_03CF7C,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W DATA_03D090,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DATA_03D1A4,X                       ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.W WendyGfxProp,X
    ORA.B #$10                                ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Store tile size to OAM.
    TAY
    LDA.W DATA_03D3CC,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    PLX
    DEX
    BPL -
    BRA CODE_03D4DD


if ver_is_japanese(!_VER)                     ;\========================= J ===================
DATA_03D524:                                  ;!
    db $28,$30,$88,$0E,$30,$30,$89,$0E        ;!
    db $38,$30,$8A,$0E,$38,$28,$8B,$0E        ;!
    db $48,$30,$88,$0E,$50,$30,$8C,$0E        ;!
    db $58,$30,$8D,$0E,$58,$28,$8B,$0E        ;!
    db $60,$30,$8E,$0E,$68,$30,$98,$0E        ;!
    db $70,$30,$99,$0E,$78,$30,$9A,$0E        ;!
    db $80,$30,$8E,$0E,$88,$30,$9B,$0E        ;!
    db $88,$28,$8B,$0E,$90,$30,$9C,$0E        ;!
    db $98,$30,$9D,$0E,$A0,$30,$8C,$0E        ;!
    db $A8,$30,$9E,$0E,$B8,$30,$A0,$0E        ;!
    db $C0,$30,$A1,$0E,$C8,$30,$99,$0E        ;!
    db $D0,$30,$8A,$0E,$D0,$28,$8B,$0E        ;!
    db $D8,$30,$A8,$0E,$E0,$30,$F2,$0E        ;!
    db $20,$40,$A9,$0E,$28,$40,$AA,$0E        ;!
    db $30,$40,$AB,$0E,$38,$40,$AC,$0E        ;!
    db $40,$40,$8E,$0E,$48,$40,$AD,$0E        ;!
    db $50,$40,$AE,$0E,$58,$40,$AF,$0E        ;!
    db $60,$40,$B0,$0E,$68,$40,$B1,$0E        ;!
    db $70,$40,$A1,$0E,$78,$40,$A1,$0E        ;!
    db $80,$40,$FF,$0E,$88,$40,$8A,$0E        ;!
    db $90,$40,$B8,$0E,$98,$40,$B9,$0E        ;!
    db $98,$38,$BA,$0E,$A0,$40,$AC,$0E        ;!
    db $A8,$40,$BB,$0E,$B0,$40,$8D,$0E        ;!
    db $B8,$40,$8E,$0E,$C0,$40,$BC,$0E        ;!
    db $C8,$40,$8E,$0E,$D0,$40,$BD,$0E        ;!
    db $D8,$40,$BE,$0E,$20,$50,$BF,$0E        ;!
    db $20,$48,$8B,$0E,$28,$50,$DE,$0E        ;!
    db $30,$50,$AC,$0E,$38,$50,$AB,$0E        ;!
    db $40,$50,$DF,$0E,$48,$50,$E2,$0E        ;!
    db $50,$50,$AE,$0E,$50,$48,$8B,$0E        ;!
    db $60,$50,$E5,$0E,$68,$50,$BC,$0E        ;!
    db $70,$50,$BC,$0E,$78,$50,$E0,$0E        ;!
    db $78,$48,$8B,$0E,$80,$50,$9E,$0E        ;!
    db $88,$50,$BD,$0E,$88,$48,$8B,$0E        ;!
    db $90,$50,$AF,$0E,$98,$50,$99,$0E        ;!
    db $A0,$50,$AF,$0E,$A8,$50,$A8,$0E        ;!
    db $B0,$50,$F5,$0E,$B8,$50,$F5,$0E        ;!
    db $C0,$50,$F5,$0E,$C8,$50,$F5,$0E        ;!
else                                          ;<================= U, SS, E0, & E1 ==============
DATA_03D524:                                  ;!
    db $18,$20,$A1,$0E,$20,$20,$88,$0E        ;!
    db $28,$20,$AB,$0E,$30,$20,$99,$0E        ;!
    db $38,$20,$A8,$0E,$40,$20,$BF,$0E        ;!
    db $48,$20,$AC,$0E,$58,$20,$88,$0E        ;!
    db $60,$20,$8B,$0E,$68,$20,$AF,$0E        ;!
    db $70,$20,$8C,$0E,$78,$20,$9E,$0E        ;!
    db $80,$20,$AD,$0E,$88,$20,$AE,$0E        ;!
    db $90,$20,$AB,$0E,$98,$20,$8C,$0E        ;!
    db $A8,$20,$99,$0E,$B0,$20,$AC,$0E        ;!
    db $C0,$20,$A8,$0E,$C8,$20,$AF,$0E        ;!
    db $D0,$20,$8C,$0E,$D8,$20,$AB,$0E        ;!
    db $E0,$20,$BD,$0E,$18,$30,$A1,$0E        ;!
    db $20,$30,$88,$0E,$28,$30,$AB,$0E        ;!
    db $30,$30,$99,$0E,$38,$30,$A8,$0E        ;!
    db $40,$30,$BE,$0E,$48,$30,$AD,$0E        ;!
    db $50,$30,$98,$0E,$58,$30,$8C,$0E        ;!
    db $68,$30,$A0,$0E,$70,$30,$AB,$0E        ;!
    db $78,$30,$99,$0E,$80,$30,$9E,$0E        ;!
    db $88,$30,$8A,$0E,$90,$30,$8C,$0E        ;!
    db $98,$30,$AC,$0E,$A0,$30,$AC,$0E        ;!
    db $A8,$30,$BE,$0E,$B0,$30,$B0,$0E        ;!
    db $B8,$30,$A8,$0E,$C0,$30,$AC,$0E        ;!
    db $C8,$30,$98,$0E,$D0,$30,$99,$0E        ;!
    db $D8,$30,$BE,$0E,$18,$40,$88,$0E        ;!
    db $20,$40,$9E,$0E,$28,$40,$8B,$0E        ;!
    db $38,$40,$98,$0E,$40,$40,$99,$0E        ;!
    db $48,$40,$AC,$0E,$58,$40,$8D,$0E        ;!
    db $60,$40,$AB,$0E,$68,$40,$99,$0E        ;!
    db $70,$40,$8C,$0E,$78,$40,$9E,$0E        ;!
    db $80,$40,$8B,$0E,$88,$40,$AC,$0E        ;!
    db $98,$40,$88,$0E,$A0,$40,$AB,$0E        ;!
    db $A8,$40,$8C,$0E,$B8,$40,$8E,$0E        ;!
    db $C0,$40,$A8,$0E,$C8,$40,$99,$0E        ;!
    db $D0,$40,$9E,$0E,$D8,$40,$8E,$0E        ;!
    db $18,$50,$AD,$0E,$20,$50,$A8,$0E        ;!
    db $30,$50,$AD,$0E,$38,$50,$88,$0E        ;!
    db $40,$50,$9B,$0E,$48,$50,$8C,$0E        ;!
    db $58,$50,$88,$0E,$68,$50,$AF,$0E        ;!
    db $70,$50,$88,$0E,$78,$50,$8A,$0E        ;!
    db $80,$50,$88,$0E,$88,$50,$AD,$0E        ;!
    db $90,$50,$99,$0E,$98,$50,$A8,$0E        ;!
    db $A0,$50,$9E,$0E,$A8,$50,$BD,$0E        ;!
endif                                         ;/===============================================

CODE_03D674:
; OAM data for the "Mario's adventure is over..." message. In raw OAM format.
; Ma        Mario's adventure is over.
; ri        Mario,the Princess,Yoshi,
; o'        and his friends are going
; sa        to take a vacation.
; dv
; en
; tu
; re
; is
; ov
; er
; .M
; ar
; io
; ,t
; he
; Pr
; in
; ce
; ss
; ,Y
; os
; hi
; ,a
; nd
; hi
; sf
; ri
; en
; ds
; ar
; eg
; oi
; ng
; to
; ta
; ke
; av
; ac
; at
; io
; n.
    PHX                                       ; Routine to write the "Mario's adventure is over..." message.
    REP #$30                                  ; AXY->16
    LDX.W FinalMessageTimer                   ; Return if the message isn't being written yet.
    BEQ CODE_03D6A8
    DEX
    LDY.W #$0000
  - PHX                                       ; Tile loop for all of the currently written letters. Loops twice per letter.
    TXA
    ASL A
    ASL A
    TAX
    LDA.W DATA_03D524,X                       ; Store X/Y position to OAM.
    STA.W OAMTileXPos,Y
    LDA.W DATA_03D524+2,X                     ; Store tile number / YXPPCCCT to OAM.
    STA.W OAMTileNo,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY                                       ; Store size to OAM as 8x8.
    SEP #$20                                  ; A->8
    LDA.B #$00
    STA.W OAMTileSize,Y
    REP #$20                                  ; A->16
    PLY
    PLX
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL -
CODE_03D6A8:
    SEP #$30                                  ; AXY->8
    PLX
    RTS

    %insert_empty($72,$54,$54,$54,$54)

DATA_03D700:
    db $B0,$A0,$90,$80,$70,$60,$50,$40
    db $30,$20,$10,$00

CODE_03D70C:
; X positions to to erase breaking Reznor's bridge, offset from the center of the room.
    PHX                                       ; Routine to break Reznor's bridge.
    LDA.W SpriteMisc151C+4                    ; \ Return if less than 2 reznors killed
    CLC                                       ; |
    ADC.W SpriteMisc151C+5                    ; |; Return if enough Reznors (at least 2) haven't died yet.
    ADC.W SpriteMisc151C+6                    ; |
    ADC.W SpriteMisc151C+7                    ; |
    CMP.B #$02                                ; |; How many Reznors need to be killed for the bridge to begin breaking.
    BCC CODE_03D757                           ; /
    LDX.W ReznorBridgeCount                   ; Return if the bridge is done breaking.
    CPX.B #$0C                                ; How many pairs of tiles there are in Reznor's bridge.
    BCS CODE_03D757
    LDA.L DATA_03D700,X
    STA.B TouchBlockXPos                      ; Get X position of the tile to break.
    STZ.B TouchBlockXPos+1
    LDA.B #$B0                                ; Y position of Reznor's bridge, for breaking it.
    STA.B TouchBlockYPos
    STZ.B TouchBlockYPos+1
    LDA.W ReznorBridgeTimer                   ; Branch if time to reset the timer until the next block breaks.
    BEQ CODE_03D74A
    CMP.B #$3C                                ; Return if not time to break the bridge part.
    BNE CODE_03D757
    JSR CODE_03D77F                           ; Erase the tile on the left.
    JSR CODE_03D759                           ; Erase the tile on the right.
    JSR CODE_03D77F
    INC.W ReznorBridgeCount                   ; Increment counter for next block and return.
    BRA CODE_03D757

CODE_03D74A:
    JSR CODE_03D766                           ; Reset the timer for breaking Reznor's bridge.
    LDA.B #$40                                ; How many frames to wait before breaking each bridge tile.
    STA.W ReznorBridgeTimer
    LDA.B #!SFX_SHATTER                       ; SFX for destroying a tile in Reznor's bridge.
    STA.W SPCIO3                              ; / Play sound effect
CODE_03D757:
    PLX
    RTL

CODE_03D759:
    REP #$20                                  ; A->16; Subroutine to get the position of the second block to break.
    LDA.W #$0170
    SEC                                       ; Get X position of the block on other side of the room.
    SBC.B TouchBlockXPos
    STA.B TouchBlockXPos
    SEP #$20                                  ; A->8
    RTS

CODE_03D766:
; Subroutine to generate smoke at the destroyed bridge positions.
    JSR CODE_03D76C                           ; Generate smoke for the left bridge tile.
    JSR CODE_03D759                           ; Get position of the right bridge tile (to generate smoke at it, too).
CODE_03D76C:
    REP #$20                                  ; A->16
    LDA.B TouchBlockXPos
    SEC
    SBC.B Layer1XPos                          ; Return if horizontally offscreen.
    CMP.W #$0100
    SEP #$20                                  ; A->8
    BCS +
    JSL CODE_028A44                           ; Generate smoke.
  + RTS

CODE_03D77F:
    LDA.B TouchBlockXPos                      ; Subroutine to erase a bridge tile in Reznor's fight.
    LSR A
    LSR A
    LSR A
    STA.B _1
    LSR A
    ORA.B TouchBlockYPos
    REP #$20                                  ; A->16
    AND.W #$00FF                              ; Get Map16 index to the tile to ovewrite.
    LDX.B TouchBlockXPos+1                    ; $00 = 16-bit value to append to the VRAM data write for the X position of the tile.
    BEQ +
    CLC
    ADC.W #$01B0
    LDX.B #$04
  + STX.B _0
    REP #$10                                  ; XY->16
    TAX
    SEP #$20                                  ; A->8
    LDA.B #$25
    STA.L Map16TilesLow,X                     ; Write a blank tile to Map16.
    LDA.B #$00
    STA.L Map16TilesHigh,X
    REP #$20                                  ; A->16
    LDA.L DynStripeImgSize
    TAX
    LDA.W #$C05A
    CLC
    ADC.B _0
    STA.L DynamicStripeImage,X                ; Write to the VRAM upload table:
    ORA.W #$2000                              ; 5A C0 40 02 - FC 38
    STA.L DynamicStripeImage+6,X              ; 5A E0 40 02 - FC 38
    LDA.W #$0240                              ; FF
    STA.L DynamicStripeImage+2,X              ; With X position factored into the first 2 bytes of each row.
    STA.L DynamicStripeImage+8,X
    LDA.W #$38FC
    STA.L DynamicStripeImage+4,X
    STA.L DynamicStripeImage+$0A,X
    LDA.W #$00FF
    STA.L DynamicStripeImage+$0C,X
    TXA
    CLC                                       ; Increment stripe image index.
    ADC.W #$000C
    STA.L DynStripeImgSize
    SEP #$30                                  ; AXY->8
    RTS


DATA_03D7EC:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$15,$16,$17,$18,$17,$18
    db $17,$18,$17,$18,$19,$1A,$00,$00
    db $00,$00,$01,$02,$03,$04,$03,$04
    db $03,$04,$03,$04,$05,$12,$00,$00
    db $00,$00,$00,$07,$04,$03,$04,$03
    db $04,$03,$04,$03,$08,$00,$00,$00
    db $00,$00,$00,$09,$0A,$04,$03,$04
    db $03,$04,$03,$0B,$0C,$00,$00,$00
    db $00,$00,$00,$00,$0D,$0E,$04,$03
    db $04,$03,$0F,$10,$00,$00,$00,$00
    db $00,$00,$00,$00,$11,$02,$03,$04
    db $03,$04,$05,$12,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$07,$04,$03
    db $04,$03,$08,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$09,$0A,$04
    db $03,$0B,$0C,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$13,$03
    db $04,$14,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$13
    db $14,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
DATA_03D8EC:
    db $FF,$FF

DATA_03D8EE:
    db $FF,$FF,$FF,$FF,$24,$34,$25,$0B
    db $26,$36,$0E,$1B,$0C,$1C,$0D,$1D
    db $0E,$1E,$29,$39,$2A,$3A,$2B,$3B
    db $26,$38,$20,$30,$21,$31,$27,$37
    db $28,$38,$FF,$FF,$22,$32,$0E,$33
    db $0C,$1C,$0D,$1D,$0E,$3C,$2D,$3D
    db $FF,$FF,$07,$17,$0E,$23,$0E,$04
    db $0C,$1C,$0D,$1D,$0E,$09,$0E,$2C
    db $0A,$1A,$FF,$FF,$24,$34,$2B,$3B
    db $FF,$FF,$07,$17,$0E,$18,$0E,$19
    db $0A,$1A,$02,$12,$03,$13,$03,$08
    db $03,$05,$03,$05,$03,$14,$03,$15
    db $03,$05,$03,$05,$03,$08,$03,$06
    db $0F,$1F

CODE_03D958:
; Iggy/Larry platform tilemap. Values here are also used to handle interaction.
; Map16 data for each of the tiles listed above. Refer to this image for tiles:  http://i.imgur.com/uEvZD71.png
; 00
; 01
; 02
; 03
; 04
; 05
; 06
; 07
; 08
; 09
; 0A
; 0B
; 0C
; 0D
; 0E
; 0F
; 10
; 11
; 12
; 13
; 14
; 15
; 16
; 17
; 18
; 19
; 1A
    REP #$10                                  ; XY->16; Routine to clear out the Mode 7 tilemap. Also uploads Iggy/Larry's platform tilemap in their room.
    STZ.W HW_VMAINC
    STZ.W HW_VMADD
    STZ.W HW_VMADD+1
    LDX.W #$4000
    LDA.B #$FF                                ; Clear out FG/BG GFX files and Layer 1/2 tilemaps.
  - STA.W HW_VMDATA
    DEX
    BNE -
    SEP #$10                                  ; XY->8
    BIT.W IRQNMICommand                       ; Return if not in Iggy/Larry's rooms.
    BVS +
    PHB
    PHK
    PLB
    LDA.B #DATA_03D7EC
    STA.B _5
    LDA.B #DATA_03D7EC>>8                     ; $05 = pointer to $03D7EC.
    STA.B _6
    LDA.B #DATA_03D7EC>>16
    STA.B _7
    LDA.B #$10
    STA.B _0                                  ; $00 = Base VRAM address to write to (0810).
    LDA.B #$08
    STA.B _1
    JSR CODE_03D991                           ; Upload the tilemap.
    PLB
  + RTL

CODE_03D991:
    STZ.W HW_VMAINC                           ; Subroutine to upload the tilemap for Iggy/Larry's platform.
    LDY.B #$00
CODE_03D996:
; Outer loop; this loop uploads each row of the tilemap.
    STY.B _2                                  ; $02 = row number
    LDA.B #$00
CODE_03D99A:
; Inner loop (2); this loop uploads the full tilemap data for each tile in a row.
    STA.B _3                                  ; $03 = counter for which half of the tilemap to write.
    LDA.B _0
    STA.W HW_VMADD                            ; Store VRAM address to write to.
    LDA.B _1
    STA.W HW_VMADD+1
    LDY.B _2
    LDA.B #$10                                ; $04 = col number
    STA.B _4
; Inner loop; this loop uploads one half of the tilemap data for each tile in a row.
  - LDA.B [_5],Y                              ; Load tile number to $0AF6.
    STA.W IggyLarryPlatInteract,Y
    ASL A
    ASL A
    ORA.B _3
    TAX                                       ; Upload half of the 8x8 tilemap to VRAM.
    %WorL_X(LDA,DATA_03D8EC)
    STA.W HW_VMDATA
    %WorL_X(LDA,DATA_03D8EE)
    STA.W HW_VMDATA
    INY
    DEC.B _4                                  ; Loop for all tiles in the row.
    BNE -
    LDA.B _0
    CLC
    ADC.B #$80                                ; Increment VRAM pointer to next row.
    STA.B _0
    BCC +
    INC.B _1
  + LDA.B _3
    EOR.B #$01                                ; Loop for the second half of the tilemap.
    BNE CODE_03D99A
    TYA                                       ; Loop for all rows of the tilemap.
    BNE CODE_03D996
    RTS


DATA_03D9DE:
    db $FF,$00,$FF,$FF,$02,$04,$06,$FF
    db $08,$0A,$0C,$FF,$0E,$10,$12,$FF
    db $FF,$00,$FF,$FF,$02,$04,$06,$FF
    db $08,$0A,$0C,$FF,$0E,$14,$16,$FF
    db $FF,$00,$FF,$FF,$02,$04,$06,$FF
    db $08,$0A,$0C,$FF,$0E,$18,$1A,$FF
    db $46,$48,$4A,$FF,$4C,$4E,$50,$FF
    db $52,$54,$0C,$FF,$0E,$18,$1A,$FF
    db $FF,$FF,$FF,$FF,$B2,$B4,$06,$FF
    db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF
    db $FF,$1C,$FF,$FF,$1E,$20,$22,$FF
    db $24,$26,$28,$FF,$FF,$2A,$2C,$FF
    db $FF,$2E,$30,$FF,$32,$34,$35,$33
    db $36,$38,$39,$37,$42,$44,$45,$43
    db $FF,$2E,$30,$FF,$32,$34,$35,$33
    db $36,$38,$39,$37,$42,$44,$45,$43
    db $FF,$2E,$30,$FF,$32,$34,$35,$33
    db $36,$38,$39,$37,$3E,$40,$41,$3F
    db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF
    db $08,$0A,$0C,$FF,$0E,$10,$12,$FF
    db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF
    db $08,$0A,$0C,$FF,$0E,$14,$16,$FF
    db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF
    db $08,$0A,$0C,$FF,$0E,$18,$1A,$FF
    db $6C,$6E,$FF,$FF,$72,$74,$50,$FF
    db $52,$54,$0C,$FF,$0E,$18,$1A,$FF
    db $FF,$BE,$FF,$FF,$DC,$DE,$06,$FF
    db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF
    db $60,$62,$FF,$FF,$64,$66,$22,$FF
    db $24,$26,$28,$FF,$FF,$2A,$2C,$FF
    db $FF,$68,$69,$FF,$32,$6A,$6B,$33
    db $36,$38,$39,$37,$42,$44,$45,$43
    db $FF,$68,$69,$FF,$32,$6A,$6B,$33
    db $36,$38,$39,$37,$42,$44,$45,$43
    db $FF,$68,$69,$FF,$32,$6A,$6B,$33
    db $36,$38,$39,$37,$3E,$40,$41,$3F
    db $7A,$7C,$FF,$FF,$7E,$80,$82,$FF
    db $84,$86,$0C,$FF,$0E,$10,$12,$FF
    db $7A,$7C,$FF,$FF,$7E,$80,$06,$FF
    db $84,$86,$0C,$FF,$0E,$14,$16,$FF
    db $7A,$7C,$FF,$FF,$7E,$80,$06,$FF
    db $84,$86,$0C,$FF,$0E,$18,$1A,$FF
    db $A0,$A2,$A4,$FF,$A6,$A8,$AA,$FF
    db $52,$54,$0C,$FF,$0E,$18,$1A,$FF
    db $FF,$B8,$FF,$FF,$D6,$D8,$DA,$FF
    db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF
    db $88,$8A,$8C,$FF,$8E,$90,$92,$FF
    db $94,$96,$28,$FF,$FF,$2A,$2C,$FF
    db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D
    db $36,$38,$39,$37,$42,$44,$45,$43
    db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D
    db $36,$38,$39,$37,$42,$44,$45,$43
    db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D
    db $36,$38,$39,$37,$3E,$40,$41,$3F
    db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF
    db $C0,$C2,$C4,$FF,$E0,$E2,$E4,$FF
    db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF
    db $C6,$C8,$CA,$FF,$E6,$E8,$EA,$FF
    db $FF,$FF,$FF,$FF,$FF,$CD,$FF,$FF
    db $C5,$C3,$C1,$FF,$E5,$E3,$E1,$FF
    db $FF,$90,$92,$94,$96,$FF,$FF,$FF
    db $FF,$B0,$B2,$B4,$B6,$38,$FF,$FF
    db $FF,$D0,$D2,$D4,$D6,$58,$5A,$FF
    db $FF,$F0,$F2,$F4,$F6,$78,$7A,$FF
    db $FF,$90,$92,$94,$96,$FF,$FF,$FF
    db $FF,$98,$9A,$9C,$B6,$38,$FF,$FF
    db $FF,$D0,$D2,$D4,$D6,$58,$5A,$FF
    db $FF,$F0,$F2,$F4,$F6,$78,$7A,$FF
    db $FF,$90,$92,$94,$96,$FF,$FF,$FF
    db $FF,$98,$BA,$BC,$B6,$38,$FF,$FF
    db $FF,$D8,$DA,$DC,$D6,$58,$5A,$FF
    db $FF,$F8,$FA,$FC,$F6,$78,$7A,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$90,$92,$94,$96,$FF,$FF
    db $FF,$FF,$98,$BA,$BC,$B6,$38,$FF
    db $FF,$FF,$D8,$DA,$DC,$D6,$58,$5A
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$90,$92,$94,$96,$FF,$FF
    db $FF,$FF,$98,$BA,$BC,$B6,$38,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$90,$92,$94,$96,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$90,$92,$94,$96,$FF,$FF,$FF
    db $FF,$98,$BA,$BC,$B6,$38,$FF,$FF
    db $FF,$D8,$DA,$DC,$D6,$58,$5A,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $04,$06,$08,$0A,$0B,$09,$07,$05
    db $24,$26,$28,$2A,$2C,$29,$27,$25
    db $FF,$84,$86,$88,$89,$87,$85,$FF
    db $FF,$A4,$A6,$A8,$A9,$A7,$A5,$FF
    db $04,$06,$08,$0A,$0B,$09,$07,$05
    db $24,$26,$28,$2D,$2B,$29,$27,$25
    db $FF,$84,$86,$88,$89,$87,$85,$FF
    db $FF,$A4,$A6,$0C,$0D,$A7,$A5,$FF
    db $80,$82,$83,$8A,$82,$83,$8C,$8E
    db $A0,$A2,$A3,$C4,$A2,$A3,$AC,$AE
    db $80,$8A,$8A,$8A,$8A,$8A,$8C,$8E
    db $A0,$60,$61,$C4,$60,$61,$AC,$AE
    db $80,$03,$01,$8A,$00,$02,$8C,$8E
    db $A0,$23,$21,$C4,$20,$22,$AC,$AE
    db $80,$00,$02,$8A,$03,$01,$AA,$8E
    db $A0,$20,$22,$C4,$23,$21,$AC,$AE
    db $C0,$C2,$C4,$C4,$C4,$CA,$CC,$CE
    db $E0,$E2,$E4,$E6,$E8,$EA,$EC,$EE
    db $40,$42,$44,$46,$48,$4A,$4C,$4E
    db $FF,$62,$64,$66,$68,$6A,$6C,$FF
    db $10,$12,$14,$16,$18,$1A,$1C,$1E
    db $10,$30,$32,$34,$36,$1A,$1C,$1E

KoopaPalPtrLo:
    db StandardColors+$6C
    db StandardColors+$54
    db StandardColors+$48
    db SpriteColors+$60
    db SpriteColors+$54

KoopaPalPtrHi:
    db StandardColors+$6C>>8
    db StandardColors+$54>>8
    db StandardColors+$48>>8
    db SpriteColors+$60>>8
    db SpriteColors+$54>>8

DATA_03DD78:
    db $0B,$0B,$0B,$21,$00

CODE_03DD7D:
; Morton, Roy, and Ludwig Mode 7 tilemap.
; $0000 (00) - Morton walk A
; $0010 (01) - Morton walk B
; $0020 (02) - Morton walk C
; $0030 (03) - Unused (Morton fireballs A)
; $0040 (04) - Unused (Morton fireballs B)
; $0050 (05) - Morton turning
; $0060 (06) - Morton hurt A / falling
; $0070 (07) - Morton hurt B
; $0080 (08) - Unused (Morton dying?)
; $0090 (00) - Roy walk A
; $00A0 (01) - Roy walk B
; $00B0 (02) - Roy walk C
; $00C0 (03) - Unused (Roy fireballs A)
; $00D0 (04) - Unused (Roy fireballs B)
; $00E0 (05) - Roy turning
; $00F0 (06) - Roy hurt A / falling
; $0100 (07) - Roy hurt B
; $0110 (08) - Unused (Roy dying?)
; $0120 (00) - Ludwig walk A
; $0130 (01) - Ludwig walk B
; $0140 (02) - Ludwig walk C
; $0150 (03) - Ludwig fireballs A
; $0160 (04) - Ludwig fireballs B
; $0170 (05) - Ludwig turning
; $0180 (06) - Ludwig hurt A
; $0190 (07) - Ludwig hurt B
; $01A0 (08) - Unused (Ludwig dying?)
; $01B0 (1B) - Ludwig shell A
; $01C0 (1D) - Ludwig shell B
; $01D0 (1E) - Ludwig shell C
; Bowser's Mode 7 tilemap, indexed from $03D9DE. Reznor also uses index $02C0.
; $01E0 (00) - Bowser normal
; $0200 (02) - Bowser ducking A / blinking A
; $0220 (04) - Bowser ducking B / blinking B
; $0240 (06) - Bowser ducking C
; $0260 (08) - Bowser ducking D
; $0280 (0A) - Bowser ducking E
; $02A0 (0C) - Bowser hit
; $02C0 (0E) - Bowser hidden inside car, Reznor (i.e. don't draw)
; $02E0 (10) - Bowser hurt A
; $0300 (12) - Bowser hurt B
; $0320 (00) - Clown Car row 1 (normal)
; $0330 (01) - Clown Car row 1 (blinking)
; $0340 (02) - Clown Car row 1 (hurt)
; $0350 (03) - Clown Car row 1 (angry)
; $0360 - Clown Car row 2
; $0370 - Clown Car row 3
; $0380 - Clown Car green top (with Bowser's hands)
; $0388 - Clown Car green top (without Bowser's hands)
; Low byte for the pointers to Morton, Roy, Ludwig, Bowser, and Reznor's wheel palettes.
; High byte for the pointers to Morton, Roy, Bowser, and Reznor's wheel palettes.
; Graphics files used for Morton, Roy, Ludwig, and Bowser. Last byte is unused.
; Misc RAM input:
; $C2 - Tilemap to load. 0 = Morton, 1 = Roy, 2 = Ludwig, 3 = Bowser, 4 = Reznor
    PHX                                       ; Routine to load palettes and GFX files for the Mode 7 rooms.
    PHB
    PHK
    PLB
    LDY.B SpriteTableC2,X
    STY.W ActiveBoss                          ; Branch if not Reznor.
    CPY.B #$04
    BNE +
    JSR CODE_03DE8E                           ; Load Reznor's wheel tilemap.
    LDA.B #$48                                ; Y position of the center of rotation for Reznor's wheel.
    STA.B Mode7CenterY
    LDA.B #$14                                ; Size of Reznor's wheel.
    STA.B Mode7XScale
    STA.B Mode7YScale
  + LDA.B #$FF                                ; Not Reznor.
    STA.B LevelScrLength                      ; Clear number of screens in the level.
    INC A
    STA.B LastScreenHoriz
    LDY.W ActiveBoss
    LDX.W DATA_03DD78,Y
    LDA.W KoopaPalPtrLo,Y                     ; \ $00 = Pointer in bank 0 (from above tables); Get index to the palette for the current Mode 7 room.
    STA.B _0                                  ; |; Also get the graphics file to use.
    LDA.W KoopaPalPtrHi,Y                     ; |
    STA.B _1                                  ; |
    STZ.B _2                                  ; /
    LDY.B #$0B                                ; \ Read 0B bytes and put them in $0707
  - LDA.B [_0],Y                              ; |; Upload Mode 7 palette corresponding to the current boss.
    STA.W MainPalette+4,Y                     ; |
    DEY                                       ; |
    BPL -                                     ; /
    LDA.B #$80
    STA.W HW_VMAINC                           ; Set VRAM upload register to increment after writing to $2119,
    STZ.W HW_VMADD                            ; and set VRAM location to 0000 (FG1).
    STZ.W HW_VMADD+1
    TXY                                       ; If Reznor, skip.
    BEQ CODE_03DDD7
    JSL PrepareGraphicsFile                   ; Decompress GFX file to RAM.
    LDA.B #$80
    STA.B _3
  - JSR CODE_03DDE5                           ; Upload 0x80 tiles to VRAM.
    DEC.B _3
    BNE -
CODE_03DDD7:
    LDX.B #$5F                                ; Reznor returns here (done with the GFX file upload).
  - LDA.B #$FF
    STA.L Mode7BossTilemap,X                  ; Clear out Mode 7 tilemap.
    DEX
    BPL -
    PLB
    PLX
    RTL

CODE_03DDE5:
; Subroutine to upload a single Mode 7 8x8 tile to VRAM (technically two: the tile, and its reverse).
    LDX.B #$00                                ; Note that each pixel is 3bpp, rather than actual 8bpp.
    TXY
    LDA.B #$08
    STA.B _5                                  ; Upload one 8x8 of the GFX file to VRAM.
CODE_03DDEC:
    JSR CODE_03DE39
    PHY
    TYA
    LSR A                                     ; Get one row of pixels (in 3bpp).
    CLC
    ADC.B #$0F
    TAY
    JSR CODE_03DE3C
    LDY.B #$08
  - LDA.W Mode7GfxBuffer,X
    ASL A
    ROL A
    ROL A                                     ; Write each pixels's data to VRAM.
    ROL A
    AND.B #$07
    STA.W Mode7GfxBuffer,X
    STA.W HW_VMDATA+1
    INX
    DEY
    BNE -
    PLY
    DEC.B _5                                  ; Loop for remaining rows.
    BNE CODE_03DDEC
    LDA.B #$07
CODE_03DE15:
    TAX                                       ; Upload another 8x8 of the GFX file to VRAM (the "mirrored" tile).
    LDY.B #$08
    STY.B _5
  - LDY.W Mode7GfxBuffer,X                    ; Write each pixel's data to VRAM, in reverse.
    STY.W HW_VMDATA+1
    DEX
    DEC.B _5
    BNE -
    CLC
    ADC.B #$08
    CMP.B #$40
    BCC CODE_03DE15
    REP #$20                                  ; A->16
    LDA.B _0
    CLC                                       ; Increase pointer for next tile.
    ADC.W #$0018
    STA.B _0
    SEP #$20                                  ; A->8
    RTS

CODE_03DE39:
    JSR CODE_03DE3C                           ; Subroutine to get two bits of each pixel's data in a row.
CODE_03DE3C:
    PHX                                       ; Subroutine to get one bit of each pixel's data in a row.
    LDA.B [_0],Y
    PHY
    LDY.B #$08
  - ASL A                                     ; Get one bit for each pixel... backwards, for some reason.
    ROR.W Mode7GfxBuffer,X
    INX
    DEY
    BNE -
    PLY
    INY
    PLX
    RTS


DATA_03DE4E:
    db $40,$41,$42,$43,$44,$45,$46,$47
    db $50,$51,$52,$53,$54,$55,$56,$57
    db $60,$61,$62,$63,$64,$65,$66,$67
    db $70,$71,$72,$73,$74,$75,$76,$77
    db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F
    db $58,$59,$5A,$5B,$5C,$5D,$5E,$5F
    db $68,$69,$6A,$6B,$6C,$6D,$6E,$6F
    db $78,$79,$7A,$7B,$7C,$7D,$7E,$3F

CODE_03DE8E:
; Mode 7 tilemap for Reznor's wheel.
; Subroutine to upload Reznor's wheel to VRAM.
    STZ.W HW_VMAINC                           ; Set VRAM upload register to increment after writing to $2118.
    REP #$20                                  ; A->16
    LDA.W #$0A1C                              ; Initial VRAM address.
    STA.B _0
    LDX.B #$00
CODE_03DE9A:
    REP #$20                                  ; A->16; Upload loop.
    LDA.B _0
    CLC
    ADC.W #$0080                              ; Increase VRAM address to next row.
    STA.B _0
    STA.W HW_VMADD
    SEP #$20                                  ; A->8
    LDY.B #$08
  - %WorL_X(LDA,DATA_03DE4E)
; Loop through to the tiles in the row.
    STA.W HW_VMDATA                           ; Write tile to VRAM.
    INX
    DEY
    BNE -
    CPX.B #$40                                ; Loop for all of the rows.
    BCC CODE_03DE9A
    RTS


DATA_03DEBB:
    db $00,$01,$10,$01

DATA_03DEBF:
    db $6E,$70,$FF,$50,$FE,$FE,$FF,$57
DATA_03DEC7:
    db $72,$74,$52,$54,$3C,$3E,$55,$53
DATA_03DECF:
    db $76,$56,$56,$FF,$FF,$FF,$51,$FF
DATA_03DED7:
    db $20,$03,$30,$03,$40,$03,$50,$03

CODE_03DEDF:
; Offsets for Mode 7's position from a sprite's position.
; First value is X, second is Y.
; Mode 7 tiles for Bowser's propelor animation (left-most two).
; Mode 7 tiles for Bowser's propelor animation (middle two).
; Mode 7 tiles for Bowser's propelor animation (right-most two).
; Mode 7 tilemap indices for the eyes of Bowser's clown car.
; Routine to handle the Mode 7 tilemap of Morton/Roy/Ludwig/Bowser.
    PHB                                       ; Also run by Reznor, to move the wheel with him.
    PHK
    PLB
    LDA.W SpriteXPosHigh,X
    XBA
    LDA.B SpriteXPosLow,X
    LDY.B #$00
    JSR CODE_03DFAE                           ; Move Mode 7's position with the sprite's position.
    LDA.W SpriteYPosHigh,X
    XBA
    LDA.B SpriteYPosLow,X
    LDY.B #$02
    JSR CODE_03DFAE
    PHX
    REP #$30                                  ; AXY->16
    STZ.B _6
    LDY.W #$0003                              ; Number of tiles to write per row for Morton/Roy/Ludwig.
    LDA.W IRQNMICommand
    LSR A                                     ; Branch if not in Bowser's battle.
    BCC CODE_03DF44
    LDA.W ClownCarPropeller
    AND.W #$0003
    ASL A
    TAX
    %WorL_X(LDA,DATA_03DEBF)
    STA.L Mode7BossTilemap+1                  ; Animate the propeller of Bowser's clown car.
    %WorL_X(LDA,DATA_03DEC7)
    STA.L Mode7BossTilemap+3
    %WorL_X(LDA,DATA_03DECF)
    STA.L Mode7BossTilemap+5
    LDA.W #$0008                              ; Index to write to in the Mode 7 tilemap for the top of Bowser's clown car.
    STA.B _6
    LDX.W #$0380
    LDA.W Mode7TileIndex
    AND.W #$007F                              ; Use #$0380 for the top of Bowser's car if his hands are resting on it.
    CMP.W #$002C                              ; Use #$0388 if they aren't (hidden and hurt frames).
    BCC +
    LDX.W #$0388
  + TXA
    LDX.W #$000A                              ; Number of rows to write for Bowser.
    LDY.W #$0007                              ; Number of tiles to write per row of Bowser.
    SEC
CODE_03DF44:
    STY.B _0                                  ; Not in Bowser's batle.
    BCS CODE_03DF55
CODE_03DF48:
    LDA.W Mode7TileIndex                      ; Tilemap write loop.
    AND.W #$007F
    ASL A                                     ; Get tilemap index for the sprite.
    ASL A
    ASL A
    ASL A
    LDX.W #$0003                              ; Number of rows to write for Morton/Ludwig/Bowser's body.
CODE_03DF55:
    STX.B _2
    PHA
    LDY.W LevelLoadObjectTile
    BPL +                                     ; Unused.
    CLC
    ADC.B _0
  + TAY
    SEP #$20                                  ; A->8
    LDX.B _6
    LDA.B _0                                  ; Loop to store tiles for the current row.
    STA.B _4
CODE_03DF69:
    LDA.W DATA_03D9DE,Y
    INY
    BIT.W Mode7TileIndex
    BPL +                                     ; Store tile to tilemap, and increment to next tile.
    EOR.B #$01                                ; If high bit of $1BA2 is set, the sprite is X flipped
    DEY                                       ; and tiles are loaded in reverse (right-to-left).
    DEY
  + STA.L Mode7BossTilemap,X
    INX
    DEC.B _4                                  ; Repeat for all tiles.
    BPL CODE_03DF69
    STX.B _6
    REP #$20                                  ; A->16
    PLA
    SEC                                       ; Move index to next row of the tilemap.
    ADC.B _0
    LDX.B _2                                  ; Handle Bowser's weird assembly.
    CPX.W #$0004                              ; Row #$04 - Switch to Bowser's body.
    BEQ CODE_03DF48
    CPX.W #$0008
    BNE +                                     ; Row #$08 - Switch to the rest of Bowser's clown car.
    LDA.W #$0360
  + CPX.W #$000A                              ; Row #$0A - Switch to the eyes of Bowser's clown car.
    BNE +
    LDA.W ClownCarImage
    AND.W #$0003
    ASL A                                     ; Get the tilemap index for the eyes of Bowser's clown car.
    TAY
    LDA.W DATA_03DED7,Y
  + DEX                                       ; Loop for all rows.
    BPL CODE_03DF55
    SEP #$30                                  ; AXY->8
    PLX
    PLB
    RTL

CODE_03DFAE:
; Subroutine to transfer a sprite's X/Y position to the Mode 7 position.
    PHX                                       ; Load position in A, and axis (0 = X, 2 = Y) in Y.
    TYX
    REP #$20                                  ; A->16
    EOR.W #$FFFF
    INC A
    CLC
    %WorL_X(ADC,DATA_03DEBB)
    CLC                                       ; Set Mode 7 position, accounting for screen position.
    ADC.B Layer1XPos,X
    STA.B Mode7XPos,X
    SEP #$20                                  ; A->8
    PLX
    RTS


DATA_03DFC4:
    db $00,$0E,$1C,$2A,$38,$46,$54,$62

CODE_03DFCC:
; Indices to Bowser's palette table.
    PHX                                       ; Subroutine to handle Bowser's palettes.
    LDX.W DynPaletteIndex
    LDA.B #$10
    STA.W DynPaletteTable,X                   ; Clip back area color to black.
    STZ.W DynPaletteTable+1,X
    STZ.W DynPaletteTable+2,X
    STZ.W DynPaletteTable+3,X
    TXY
    LDX.W LightningFlashIndex                 ; Branch if lightning is flashing.
    BNE CODE_03E01B
    LDA.W FinalCutscene
    BEQ CODE_03DFF0
    REP #$20                                  ; A->16; Don't handle lightning anymore once Bowser is defeated.
    LDA.W BackgroundColor
    BRA CODE_03E031

CODE_03DFF0:
    LDA.B EffFrame                            ; Bowser isn't defeated; wait for a lightning flash.
    LSR A
    BCC CODE_03E036                           ; Handle lightning flash timer and branch if not time to flash.
    DEC.W LightningWaitTimer
    BNE CODE_03E036
    TAX
    LDA.L CODE_04F708,X
    AND.B #$07
    TAX                                       ; Store a "random" amount of time to wait until the next flash, and initial intensity of the current flash.
    LDA.L DATA_04F6F8,X
    STA.W LightningWaitTimer
    LDA.L DATA_04F700,X
    STA.W LightningFlashIndex
    TAX
    LDA.B #$08                                ; Set initial timer for the palette fade.
    STA.W LightningTimer
    LDA.B #!SFX_THUNDER                       ; SFX for the lightning in Bowser's fight.
    STA.W SPCIO3                              ; / Play sound effect
CODE_03E01B:
    DEC.W LightningTimer                      ; Lightning is flashing.
    BPL +
    DEC.W LightningFlashIndex                 ; Decrease how bright the next flash will be, and set the timer for its length.
    LDA.B #$04
    STA.W LightningTimer
  + TXA
    ASL A
    TAX                                       ; Get background color for the current step of the flash.
    REP #$20                                  ; A->16
    LDA.L OverworldLightning,X
CODE_03E031:
    STA.W DynPaletteTable+2,Y
    SEP #$20                                  ; A->8
CODE_03E036:
    LDX.W BowserPalette                       ; Done with the lightning flash; now handle Bowser's palette.
    LDA.L DATA_03DFC4,X                       ; Get index to the current palette.
    TAX
    LDA.B #$0E                                ; Number of colors to upload.
    STA.B _0
; Bowser palette loop.
  - LDA.L BowserColors,X                      ; Store color.
    STA.W DynPaletteTable+4,Y
    INX
    INY                                       ; Loop for all colors.
    DEC.B _0
    BNE -
    TYX                                       ; Add end sentinel byte.
; SPC data; see https://pastebin.com/raw/NHiUdUAR for a translated pointer dump.
; Data starts with the song offsets; first two bytes are the size (-1). Each song is then a one-byte offset and a byte for the size of its pointers.
; Each song then lists its phrases, with a one-byte offset and a byte for the size of its pointers; a value of 0000 indicates the end.
; Each phrase then contains 16-bit offsets to SPC data for each of the 8 channels (for 16 bytes total per phrase).
    STZ.W DynPaletteTable+4,X                 ; Music bank 3: Credits
    INX
    INX
    INX
    INX
    STX.W DynPaletteIndex
    PLX
    RTL

    %insert_empty($3AB,$3A4,$3A4,$3A4,$3A4)

MusicBank3:
    dw MusicBank3_End-MusicBank3-4
    dw MusicData

    base MusicData

    dw MusicB3S01
    dw MusicB3S02
    dw MusicB3S03
    dw MusicB3S04
    dw MusicB3S01
    dw MusicB3S02
    dw MusicB3S03
    dw MusicB3S04
    dw MusicB3S01
    dw MusicB3S02
    dw MusicB3S03
    dw MusicB3S04


MusicB3S01:
    dw MusicB3S09L00
    dw MusicB3S0BL0F
    dw MusicB3S09L02
    dw MusicB3S09L03
    dw MusicB3S09L04
    dw MusicB3S09L05
    dw MusicB3S09L06
    dw MusicB3S09L07
    dw MusicB3S09L08
    dw MusicB3S09L09
    dw MusicB3S09L0A
    dw MusicB3S0BL10
    dw MusicB3S0BL11
    dw MusicB3S0BL12
    dw MusicB3S0BL13
    dw MusicB3S0BL14
    dw MusicB3S0BL16
    dw MusicB3S09L11
    dw $0000

MusicB3S09L00:
    dw MusicB3S01P00
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB3S0BL0F:
    dw MusicB3S01P01
    dw MusicB3S01P02
    dw MusicB3S01P03
    dw MusicB3S01P04
    dw MusicB3S01P05
    dw MusicB3S01P06
    dw MusicB3S01P07
    dw MusicB3S01P08

MusicB3S09L02:
    dw MusicB3S01P09
    dw MusicB3S01P0A
    dw MusicB3S01P0B
    dw $0000
    dw $0000
    dw $0000
    dw MusicB3S01P0C
    dw MusicB3S01P0D

MusicB3S09L04:
    dw MusicB3S01P13
    dw MusicB3S01P0A
    dw MusicB3S01P0B
    dw MusicB3S01P14
    dw $0000
    dw MusicB3S01P15
    dw MusicB3S01P0C
    dw MusicB3S01P0D

MusicB3S09L03:
    dw MusicB3S01P0E
    dw MusicB3S01P0F
    dw MusicB3S01P10
    dw $0000
    dw $0000
    dw $0000
    dw MusicB3S01P11
    dw MusicB3S01P12

MusicB3S09L05:
    dw MusicB3S01P16
    dw MusicB3S01P17
    dw MusicB3S01P18
    dw MusicB3S01P19
    dw $0000
    dw MusicB3S01P1A
    dw MusicB3S01P1B
    dw MusicB3S01P1C

MusicB3S09L06:
    dw MusicB3S01P1D
    dw MusicB3S01P1E
    dw MusicB3S01P1F
    dw MusicB3S01P20
    dw $0000
    dw MusicB3S01P21
    dw MusicB3S01P22
    dw MusicB3S01P23

MusicB3S09L07:
    dw MusicB3S01P24
    dw MusicB3S01P25
    dw MusicB3S01P26
    dw MusicB3S01P27
    dw $0000
    dw MusicB3S01P28
    dw MusicB3S01P29
    dw MusicB3S01P0D

MusicB3S09L08:
    dw MusicB3S01P2A
    dw MusicB3S01P0A
    dw MusicB3S01P0B
    dw MusicB3S01P14
    dw MusicB3S01P2B
    dw MusicB3S01P2C
    dw MusicB3S01P0C
    dw MusicB3S01P0D

MusicB3S09L09:
    dw MusicB3S01P2D
    dw MusicB3S01P2E
    dw MusicB3S01P2F
    dw MusicB3S01P30
    dw MusicB3S01P31
    dw MusicB3S01P32
    dw MusicB3S01P33
    dw MusicB3S01P34

MusicB3S09L0A:
    dw MusicB3S01P35
    dw MusicB3S01P36
    dw MusicB3S01P37
    dw MusicB3S01P38
    dw MusicB3S01P39
    dw MusicB3S01P3A
    dw MusicB3S01P3B
    dw MusicB3S01P3C

MusicB3S0BL10:
    dw MusicB3S01P2A
    dw MusicB3S01P3D
    dw MusicB3S01P0B
    dw MusicB3S01P14
    dw MusicB3S01P2B
    dw MusicB3S01P2C
    dw MusicB3S01P0C
    dw MusicB3S01P0D

MusicB3S0BL11:
    dw MusicB3S01P2D
    dw MusicB3S01P3E
    dw MusicB3S01P3F
    dw MusicB3S01P30
    dw MusicB3S01P31
    dw MusicB3S01P32
    dw MusicB3S01P33
    dw MusicB3S01P34

MusicB3S0BL12:
    dw MusicB3S01P40
    dw MusicB3S01P41
    dw MusicB3S01P42
    dw MusicB3S01P43
    dw MusicB3S01P44
    dw MusicB3S01P45
    dw MusicB3S01P46
    dw MusicB3S01P47

MusicB3S0BL13:
    dw MusicB3S01P48
    dw MusicB3S01P49
    dw MusicB3S01P0B
    dw MusicB3S01P14
    dw MusicB3S01P4A
    dw MusicB3S01P4B
    dw MusicB3S01P0C
    dw MusicB3S01P0D

MusicB3S0BL14:
    dw MusicB3S01P4C
    dw MusicB3S01P4D
    dw MusicB3S01P3F
    dw MusicB3S01P30
    dw MusicB3S01P4E
    dw MusicB3S01P4F
    dw MusicB3S01P33
    dw MusicB3S01P34

MusicB3S0BL16:
    dw MusicB3S01P50
    dw MusicB3S01P41
    dw MusicB3S01P42
    dw MusicB3S01P43
    dw MusicB3S01P44
    dw MusicB3S01P45
    dw MusicB3S01P46
    dw MusicB3S01P47

MusicB3S09L11:
    dw MusicB3S01P51
    dw MusicB3S01P52
    dw MusicB3S01P53
    dw MusicB3S01P54
    dw MusicB3S01P55
    dw MusicB3S01P56
    dw MusicB3S01P57
    dw $0000

MusicB3S02:
    dw MusicB3S0AL00
    dw $0000

MusicB3S0AL00:
    dw MusicB3S02P00
    dw MusicB3S02P01
    dw MusicB3S02P02
    dw MusicB3S02P03
    dw MusicB3S02P04
    dw MusicB3S02P05
    dw MusicB3S02P06
    dw MusicB3S02P07

MusicB3S0BL00:
    dw MusicB3S03P00
    dw MusicB3S03P01
    dw MusicB3S03P02
    dw MusicB3S03P03
    dw MusicB3S03P04
    dw MusicB3S03P05
    dw MusicB3S03P06
    dw MusicB3S03P07

MusicB3S0BL01:
    dw MusicB3S03P08
    dw MusicB3S03P09
    dw MusicB3S03P0A
    dw MusicB3S03P0B
    dw MusicB3S03P0C
    dw MusicB3S03P0D
    dw MusicB3S03P0E
    dw MusicB3S03P0F

MusicB3S03:
    dw MusicB3S0BL00
    dw MusicB3S0BL01
    dw MusicB3S0CL00
    dw MusicB3S0CL01
    dw MusicB3S0BL04
    dw MusicB3S0CL02
    dw MusicB3S0CL03
    dw MusicB3S0CL04
    dw MusicB3S0BL08
    dw MusicB3S0CL05
    dw MusicB3S0BL0A
    dw MusicB3S0BL0B
    dw MusicB3S0BL0C
    dw MusicB3S0BL0D
    dw MusicB3S0BL0E
    dw MusicB3S0BL0F
    dw MusicB3S0BL10
    dw MusicB3S0BL11
    dw MusicB3S0BL12
    dw MusicB3S0BL13
    dw MusicB3S0BL14
    dw MusicB3S0BL12
    dw MusicB3S0BL15
    dw MusicB3S0BL12
    dw MusicB3S0BL13
    dw MusicB3S0BL14
    dw MusicB3S0BL16
    dw MusicB3S0BL17
    dw $0000

MusicB3S0CL00:
    dw MusicB3S03P10
    dw MusicB3S03P11
    dw MusicB3S03P12
    dw MusicB3S03P13
    dw MusicB3S03P14
    dw MusicB3S03P15
    dw $0000
    dw MusicB3S03P16

MusicB3S0BL04:
    dw MusicB3S03P10
    dw MusicB3S03P11
    dw MusicB3S03P12
    dw MusicB3S03P13
    dw MusicB3S03P14
    dw MusicB3S03P1D
    dw $0000
    dw MusicB3S03P16

MusicB3S0CL01:
    dw MusicB3S03P17
    dw MusicB3S03P18
    dw MusicB3S03P19
    dw MusicB3S03P1A
    dw MusicB3S03P1B
    dw MusicB3S03P1C
    dw $0000
    dw MusicB3S03P16

MusicB3S0CL02:
    dw MusicB3S03P1E
    dw MusicB3S03P1F
    dw MusicB3S03P20
    dw MusicB3S03P21
    dw MusicB3S03P22
    dw MusicB3S03P23
    dw $0000
    dw MusicB3S03P16

MusicB3S0CL03:
    dw MusicB3S03P24
    dw MusicB3S03P25
    dw MusicB3S03P26
    dw MusicB3S03P27
    dw MusicB3S03P28
    dw MusicB3S03P29
    dw $0000
    dw MusicB3S03P16

MusicB3S0CL04:
    dw MusicB3S03P2A
    dw MusicB3S03P2B
    dw MusicB3S03P2C
    dw MusicB3S03P2D
    dw MusicB3S03P2E
    dw MusicB3S03P2F
    dw $0000
    dw MusicB3S03P16

MusicB3S0BL08:
    dw MusicB3S03P24
    dw MusicB3S03P25
    dw MusicB3S03P26
    dw MusicB3S03P27
    dw MusicB3S03P28
    dw MusicB3S03P29
    dw MusicB3S03P30
    dw MusicB3S03P16

MusicB3S0CL05:
    dw MusicB3S03P31
    dw MusicB3S03P32
    dw MusicB3S03P33
    dw MusicB3S03P34
    dw MusicB3S03P35
    dw MusicB3S03P36
    dw MusicB3S03P37
    dw MusicB3S03P38

MusicB3S0BL0A:
    dw MusicB3S03P10
    dw MusicB3S03P11
    dw MusicB3S03P12
    dw MusicB3S03P13
    dw MusicB3S03P14
    dw MusicB3S03P15
    dw MusicB3S03P39
    dw MusicB3S03P16

MusicB3S0BL0C:
    dw MusicB3S03P10
    dw MusicB3S03P11
    dw MusicB3S03P12
    dw MusicB3S03P13
    dw MusicB3S03P14
    dw MusicB3S03P1D
    dw MusicB3S03P39
    dw MusicB3S03P16

MusicB3S0BL0B:
    dw MusicB3S03P17
    dw MusicB3S03P18
    dw MusicB3S03P19
    dw MusicB3S03P1A
    dw MusicB3S03P1B
    dw MusicB3S03P1C
    dw MusicB3S03P3A
    dw MusicB3S03P16

MusicB3S0BL0D:
    dw MusicB3S03P3B
    dw MusicB3S03P3C
    dw MusicB3S03P3D
    dw MusicB3S03P3E
    dw MusicB3S03P3F
    dw MusicB3S03P40
    dw MusicB3S03P41
    dw MusicB3S03P16

MusicB3S0BL0E:
    dw MusicB3S03P42
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB3S0BL15:
    dw MusicB3S03P43
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB3S0BL17:
    dw MusicB3S03P44
    dw MusicB3S03P45
    dw MusicB3S03P46
    dw MusicB3S03P47
    dw MusicB3S03P48
    dw MusicB3S03P49
    dw MusicB3S03P4A
    dw MusicB3S03P4B

MusicB3S04:
    dw MusicB3S0CL00
    dw MusicB3S0CL01
    dw MusicB3S0CL00
    dw MusicB3S0CL02
    dw MusicB3S0CL03
    dw MusicB3S0CL04
    dw MusicB3S0CL03
    dw MusicB3S0CL05
    dw $00FF,MusicB3S04
    dw $0000

MusicB3S03P42:
    db $DA,$04,$E2,$16,$E3,$90,$1B,$00

MusicB3S03P43:
    db $E4,$01,$00

MusicB3S03P10:
    db $DA,$12,$E2,$1E,$DB,$0A,$DE,$14
    db $19,$27,$0C,$6D,$B4,$0C,$2E,$B7
    db $B9,$30,$6E,$B7,$0C,$2D,$B9,$0C
    db $6E,$BB,$C6,$0C,$2D,$BB,$30,$6E
    db $B9,$0C,$2D,$B3,$0C,$6E,$B4,$0C
    db $2D,$B7,$B9,$30,$6E,$B7,$0C,$2D
    db $B8,$0C,$6E,$B9,$C6,$0C,$2D,$B9
    db $30,$6E,$B7,$0C,$2D,$B8,$00

MusicB3S03P39:
    db $DA,$12,$DB,$0F,$DE,$14,$14,$20
    db $48,$6D,$B7,$18,$B9,$48,$B7,$0C
    db $B4,$B5,$30,$B7,$0C,$C6,$B9,$B7
    db $B9,$48,$B7,$18,$B4

MusicB3S03P15:
    db $DA,$00,$DB,$05,$DE,$14,$19,$27
    db $30,$6B,$C7,$0C,$C7,$B7,$0C,$2C
    db $B9,$BC,$06,$7B,$BB,$BC,$0C,$69
    db $BB,$18,$C6,$0C,$C7,$B3,$0C,$2C
    db $B7,$BB,$06,$7B,$B9,$BB,$0C,$69
    db $B9,$18,$C6,$0C,$C7,$B2,$0C,$2C
    db $B4,$B9,$06,$7B,$B7,$B9,$0C,$69
    db $B7,$18,$C6,$0C,$C7,$06,$4B,$AD
    db $AF,$B0,$B2,$B4,$B5

MusicB3S03P1D:
    db $30,$6B,$B4,$0C,$C7,$B7,$0C,$2C
    db $B9,$BC,$06,$7B,$BB,$BC,$0C,$69
    db $BB,$18,$C6,$0C,$C7,$B3,$0C,$2C
    db $B7,$BB,$06,$7B,$B9,$BB,$0C,$69
    db $B9,$18,$C6,$0C,$C7,$B2,$0C,$2C
    db $B4,$B9,$06,$7B,$B7,$B9,$0C,$69
    db $B7,$18,$C6,$0C,$C7,$06,$4B,$AD
    db $AF,$B0,$B2,$B4,$B5

MusicB3S03P13:
    db $DA,$12,$DB,$08,$DE,$14,$1F,$25
    db $0C,$6D,$B0,$0C,$2E,$B4,$B4,$30
    db $6E,$B4,$0C,$2D,$B4,$0C,$6E,$B7
    db $C6,$0C,$2D,$B7,$30,$6E,$B3,$0C
    db $2D,$AF,$0C,$6E,$AE,$0C,$2D,$B2
    db $B2,$30,$6E,$B2,$0C,$2D,$B2,$0C
    db $6E,$B4,$C6,$0C,$2D,$B4,$30,$6E
    db $B4,$0C,$2D,$B4

MusicB3S03P14:
    db $DA,$12,$DB,$0C,$DE,$14,$1B,$26
    db $0C,$6D,$AB,$0C,$2E,$B0,$B0,$30
    db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B3
    db $C6,$0C,$2D,$B3,$30,$6E,$AF,$0C
    db $2D,$AB,$0C,$6E,$AB,$0C,$2E,$AE
    db $AE,$30,$6E,$AE,$0C,$2D,$AE,$0C
    db $6E,$B1,$C6,$0C,$2D,$B1,$30,$6E
    db $B1,$0C,$2D,$B1

MusicB3S03P11:
    db $DA,$04,$DB,$08,$DE,$14,$19,$28
    db $0C,$3B,$C7,$9C,$C7,$9C,$C7,$9C
    db $C7,$9C,$C7,$9B,$C7,$9B,$C7,$9B
    db $C7,$9B,$C7,$9A,$C7,$9A,$C7,$9A
    db $C7,$9A,$C7,$99,$C7,$99,$C7,$99
    db $C7,$99

MusicB3S03P12:
    db $DA,$08,$DB,$0C,$DE,$14,$19,$28
    db $0C,$6E,$98,$9F,$93,$9F,$98,$9F
    db $93,$9F,$97,$9F,$93,$9F,$97,$9F
    db $93,$9F,$96,$9F,$93,$9F,$96,$9F
    db $93,$9F,$95,$9C,$90,$9C,$95,$9C
    db $90,$9C

MusicB3S03P16:
    db $DA,$05,$DB,$14,$DE,$00,$00,$00
    db $E9,$F3,$17,$08,$0C,$4B,$D1,$0C
    db $4C,$D2,$0C,$49,$D1,$0C,$4B,$D2
    db $00

MusicB3S03P17:
    db $0C,$6E,$B9,$0C,$2D,$BB,$BC,$30
    db $6E,$B9,$0C,$2D,$B8,$0C,$6E,$B7
    db $0C,$2D,$B8,$B9,$30,$6E,$B4,$0C
    db $C7,$12,$6E,$B4,$06,$6D,$B3,$0C
    db $2C,$B2,$12,$6E,$B4,$06,$6D,$B3
    db $0C,$2C,$B2,$0C,$2E,$B4,$B2,$30
    db $4E,$B7,$C6,$00

MusicB3S03P3A:
    db $30,$6D,$B0,$0C,$C6,$AF,$C6,$AD
    db $AB,$AC,$AD,$B4,$30,$C6,$24,$B4
    db $18,$B0,$0C,$AF,$B0,$B1,$30,$B2
    db $06,$C7,$AB,$AD,$AF,$B0,$B2,$B4
    db $B5

MusicB3S03P1C:
    db $06,$7B,$B4,$B5,$0C,$69,$B4,$18
    db $C6,$0C,$C7,$06,$4B,$AF,$B0,$B2
    db $B4,$B5,$B6,$06,$7B,$B7,$B9,$0C
    db $69,$B7,$18,$C6,$0C,$C7,$06,$4B
    db $B2,$B4,$B5,$B7,$B9,$BB,$30,$BC
    db $C6,$BB,$0C,$C7,$06,$4B,$BB,$BC
    db $BB,$B9,$B7,$B5

MusicB3S03P1A:
    db $0C,$6E,$B5,$0C,$2D,$B5,$B9,$30
    db $6E,$B6,$0C,$2D,$B6,$0C,$6E,$B4
    db $0C,$2D,$B4,$B4,$30,$6E,$B1,$0C
    db $C7,$12,$6E,$AD,$06,$6D,$AD,$0C
    db $2C,$AD,$12,$6E,$AD,$06,$6D,$AD
    db $0C,$2C,$AD,$0C,$2E,$AD,$AD,$30
    db $4E,$B2,$C6

MusicB3S03P1B:
    db $0C,$6E,$B0,$0C,$2D,$B0,$B5,$30
    db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B0
    db $0C,$2D,$B0,$B0,$30,$6E,$AB,$0C
    db $C7,$12,$6E,$A9,$06,$6D,$A9,$0C
    db $2C,$A9,$12,$6E,$A9,$06,$6D,$A9
    db $0C,$2C,$A9,$0C,$2E,$A9,$A9,$30
    db $4E,$AF,$C6

MusicB3S03P18:
    db $0C,$C7,$9D,$C7,$9D,$C7,$9E,$C7
    db $9E,$C7,$9C,$C7,$9C,$C7,$99,$C7
    db $99,$C7,$9A,$C7,$9A,$C7,$9A,$C7
    db $9A,$C7,$97,$C7,$97,$C7,$97,$C7
    db $97

MusicB3S03P19:
    db $0C,$91,$A1,$98,$A1,$92,$A1,$98
    db $A1,$93,$9F,$98,$9F,$95,$9F,$90
    db $9F,$8E,$9D,$95,$9D,$8E,$9D,$90
    db $91,$93,$9D,$8E,$9D,$93,$9D,$8E
    db $9D

MusicB3S03P1E:
    db $0C,$6E,$B9,$0C,$2D,$BB,$BC,$30
    db $6E,$B9,$0C,$2D,$B8,$0C,$6E,$B7
    db $0C,$2D,$B8,$B9,$30,$6E,$C0,$0C
    db $C7,$0C,$6E,$C0,$0C,$2D,$BF,$C0
    db $18,$6E,$BC,$0C,$2E,$BC,$18,$6E
    db $B9,$30,$4E,$BC,$C6,$00

MusicB3S03P23:
    db $06,$7B,$B4,$B5,$0C,$69,$B4,$18
    db $C6,$0C,$C7,$06,$4B,$AF,$B0,$B2
    db $B4,$B5,$B6,$06,$7B,$B7,$B9,$0C
    db $69,$B7,$18,$C6,$0C,$C7,$06,$4B
    db $B2,$B4,$B5,$B7,$B9,$BB,$30,$BC
    db $BB,$60,$BC

MusicB3S03P21:
    db $0C,$6E,$B5,$0C,$2D,$B5,$B9,$30
    db $6E,$B6,$0C,$2D,$B6,$0C,$6E,$B4
    db $0C,$2D,$B4,$B4,$30,$6E,$BD,$0C
    db $C7,$0C,$6E,$B9,$0C,$2D,$B9,$B9
    db $18,$6E,$B9,$0C,$2E,$B5,$18,$6E
    db $B5,$30,$4E,$B7,$C6

MusicB3S03P22:
    db $0C,$6E,$B0,$0C,$2D,$B0,$B5,$30
    db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B0
    db $0C,$2D,$B0,$B0,$30,$6E,$B7,$0C
    db $C7,$0C,$6E,$B5,$0C,$2D,$B5,$B5
    db $18,$6E,$B5,$0C,$2E,$B2,$18,$6E
    db $B2,$30,$4E,$B4,$C6

MusicB3S03P1F:
    db $0C,$C7,$98,$C7,$98,$C7,$98,$C7
    db $98,$C7,$9C,$C7,$9C,$C7,$99,$C7
    db $99,$C7,$95,$C7,$95,$C7,$97,$C7
    db $97,$C7,$9C,$C7,$9C,$C7,$9C,$C7
    db $9C

MusicB3S03P20:
    db $0C,$91,$9D,$98,$9D,$92,$9E,$98
    db $9E,$93,$9F,$9A,$9F,$95,$A1,$9C
    db $A1,$8E,$9A,$95,$9A,$93,$9F,$9A
    db $9F,$98,$9F,$93,$9F,$98,$98,$97
    db $96

MusicB3S03P3B:
    db $0C,$6E,$B9,$0C,$2D,$BB,$BC,$30
    db $6E,$B9,$0C,$2D,$B8,$0C,$6E,$B7
    db $0C,$2D,$B8,$B9,$30,$6E,$C0,$0C
    db $C7,$00

MusicB3S03P41:
    db $30,$6D,$B0,$0C,$C6,$AF,$C6,$AD
    db $AB,$AC,$AD,$B4,$30,$C6

MusicB3S03P3E:
    db $0C,$6E,$B5,$0C,$2D,$B5,$B9,$30
    db $6E,$B6,$0C,$2D,$B6,$0C,$6E,$B4
    db $0C,$2D,$B4,$B4,$30,$6E,$BD,$0C
    db $C7

MusicB3S03P3F:
    db $0C,$6E,$B0,$0C,$2D,$B0,$B5,$30
    db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B0
    db $0C,$2D,$B0,$B0,$30,$6E,$B7,$0C
    db $C7

MusicB3S03P40:
    db $06,$7B,$B4,$B5,$0C,$69,$B4,$18
    db $C6,$0C,$C7,$06,$4B,$AF,$B0,$B2
    db $B4,$B5,$B6,$06,$7B,$B7,$B9,$0C
    db $69,$B7,$18,$C6,$0C,$C7,$06,$4B
    db $B2,$B4,$B5,$B7,$B9,$BB

MusicB3S03P3C:
    db $0C,$C7,$98,$C7,$98,$C7,$98,$C7
    db $98,$C7,$9C,$C7,$9C,$C7,$99,$C7
    db $99

MusicB3S03P3D:
    db $0C,$91,$9D,$98,$9D,$92,$9E,$98
    db $9E,$93,$9F,$9A,$9F,$95,$A1,$9C
    db $A1

MusicB3S03P24:
    db $DA,$12,$18,$6D,$AD,$0C,$B4,$C7
    db $C7,$0C,$2D,$B4,$0C,$6E,$B3,$0C
    db $2D,$B4,$0C,$6E,$B5,$0C,$2D,$B4
    db $B1,$30,$6E,$AD,$0C,$2D,$AD,$0C
    db $6E,$B4,$0C,$2D,$B2,$0C,$6D,$B4
    db $0C,$2D,$B2,$0C,$6E,$B4,$0C,$2D
    db $B2,$C7,$0C,$6D,$AD,$30,$C6,$C7
    db $00

MusicB3S03P30:
    db $DB,$0F,$DE,$14,$14,$20,$DA,$12
    db $18,$6D,$B9,$0C,$C0,$C7,$C7,$0C
    db $2D,$C0,$0C,$6E,$BF,$0C,$2D,$C0
    db $0C,$6E,$C1,$0C,$2D,$C0,$BD,$30
    db $6E,$B9,$0C,$2D,$B9,$0C,$6E,$C0
    db $0C,$2D,$BE,$0C,$6D,$C0,$0C,$2D
    db $BE,$0C,$6E,$C0,$0C,$2D,$BE,$C7
    db $0C,$6D,$B9,$30,$C6,$C7

MusicB3S03P27:
    db $DA,$12,$18,$6D,$A8,$0C,$AB,$C7
    db $C7,$0C,$2D,$AB,$0C,$6E,$AA,$0C
    db $2D,$AB,$0C,$6E,$AD,$0C,$2D,$AB
    db $A8,$30,$6E,$A5,$0C,$2D,$A5,$0C
    db $6E,$AB,$0C,$2D,$AA,$0C,$6D,$AB
    db $0C,$2D,$AA,$0C,$6E,$AB,$0C,$2D
    db $AA,$C7,$0C,$6D,$A4,$30,$C6,$C7

MusicB3S03P28:
    db $DB,$05,$DE,$19,$19,$35,$DA,$00
    db $30,$6B,$A8,$0C,$C6,$A7,$A8,$AD
    db $48,$B4,$0C,$B3,$B4,$30,$B9,$B4
    db $60,$B2

MusicB3S03P29:
    db $DB,$08,$DE,$19,$18,$34,$DA,$00
    db $30,$6B,$9F,$0C,$C6,$9E,$9F,$A5
    db $48,$AB,$0C,$AA,$AB,$30,$B4,$AB
    db $60,$AA

MusicB3S03P25:
    db $0C,$C7,$99,$C7,$99,$C7,$99,$C7
    db $99,$C7,$99,$C7,$99,$C7,$99,$C7
    db $99,$C7,$98,$C7,$98,$C7,$98,$C7
    db $98,$C7,$98,$C7,$98,$C7,$98,$C7
    db $98

MusicB3S03P26:
    db $0C,$95,$9F,$90,$9F,$95,$9F,$90
    db $9F,$95,$9F,$90,$9F,$95,$9F,$90
    db $8F,$8E,$9E,$95,$9E,$8E,$9E,$95
    db $9E,$8E,$9E,$95,$9E,$8E,$9E,$90
    db $92

MusicB3S03P2A:
    db $18,$6D,$AB,$0C,$B2,$C7,$C7,$0C
    db $2D,$B2,$0C,$6E,$B1,$0C,$2D,$B2
    db $0C,$6E,$B4,$0C,$2D,$B2,$AF,$30
    db $6E,$AB,$0C,$2D,$B2,$18,$4E,$B0
    db $B0,$10,$6D,$B0,$10,$6E,$B2,$10
    db $6E,$B3,$30,$B4,$C7,$00

MusicB3S03P2D:
    db $18,$6D,$A3,$0C,$A9,$C7,$C7,$0C
    db $2D,$A9,$0C,$6E,$A8,$0C,$2D,$A9
    db $0C,$6E,$AB,$0C,$2D,$A9,$A6,$30
    db $6E,$A3,$0C,$2D,$A9,$18,$4E,$A8
    db $A8,$10,$6D,$A8,$10,$6E,$A9,$10
    db $6E,$AA,$30,$AC,$C7

MusicB3S03P2E:
    db $30,$69,$AB,$0C,$C6,$A9,$AB,$AF
    db $48,$B2,$0C,$B0,$B2,$48,$B0,$18
    db $B2,$60,$B4

MusicB3S03P2F:
    db $30,$69,$A3,$0C,$C6,$A3,$A6,$A9
    db $48,$AB,$0C,$A9,$AB,$48,$A8,$18
    db $AB,$60,$AC

MusicB3S03P2B:
    db $0C,$C7,$97,$C7,$97,$C7,$97,$C7
    db $97,$C7,$97,$C7,$97,$C7,$97,$C7
    db $97,$C7,$9C,$C7,$9C,$C7,$9C,$C7
    db $9C,$C7,$97,$C7,$97,$C7,$97,$C7
    db $97

MusicB3S03P2C:
    db $0C,$93,$9D,$8E,$9D,$93,$9D,$8E
    db $9D,$93,$9D,$8E,$9D,$93,$9D,$95
    db $97,$98,$9F,$93,$9F,$98,$9F,$93
    db $9F,$90,$A0,$97,$A0,$90,$A0,$92
    db $94

MusicB3S03P31:
    db $18,$6D,$AB,$0C,$B2,$C7,$C7,$0C
    db $2D,$B2,$0C,$6E,$B1,$0C,$2D,$B2
    db $0C,$6E,$B4,$0C,$2D,$B2,$C7,$30
    db $6E,$AB,$0C,$2D,$B2,$18,$4E,$B0
    db $B0,$10,$6D,$B0,$10,$6E,$B2,$10
    db $6E,$B3,$18,$2E,$B4,$C7,$30,$4E
    db $B7,$00

MusicB3S03P37:
    db $18,$6D,$B7,$0C,$BE,$C7,$C7,$0C
    db $2D,$BE,$0C,$6E,$BD,$0C,$2D,$BE
    db $0C,$6E,$C0,$0C,$2D,$BE,$C7,$30
    db $6E,$B7,$0C,$2D,$BE,$18,$4E,$BC
    db $BC,$10,$6D,$BC,$10,$6E,$BE,$10
    db $6E,$BF,$18,$2E,$C0,$C7,$06,$C7
    db $AB,$AD,$AF,$B0,$B2,$B4,$B5

MusicB3S03P34:
    db $18,$6D,$A3,$0C,$A9,$C7,$C7,$0C
    db $2D,$A9,$0C,$6E,$A8,$0C,$2D,$A9
    db $0C,$6E,$AB,$0C,$2D,$A9,$C7,$30
    db $6E,$A3,$0C,$2D,$A9,$18,$4E,$A8
    db $A8,$10,$6D,$A8,$10,$6E,$A9,$10
    db $6E,$AA,$18,$2E,$AB,$C7,$30,$4E
    db $AF

MusicB3S03P35:
    db $30,$69,$AB,$0C,$C6,$A9,$AB,$AF
    db $48,$B2,$0C,$B0,$B2,$30,$B0,$B2
    db $30,$B4,$B3

MusicB3S03P36:
    db $30,$69,$A3,$0C,$C6,$A3,$A6,$A9
    db $48,$AB,$0C,$A9,$AB,$30,$A8,$AB
    db $30,$AB,$AF

MusicB3S03P32:
    db $0C,$C7,$97,$C7,$97,$C7,$97,$C7
    db $97,$C7,$97,$C7,$97,$C7,$97,$C7
    db $97,$C7,$9C,$C7,$9C,$C7,$9C,$C7
    db $9C,$DA,$01,$18,$AF,$C7,$A7,$C6

MusicB3S03P33:
    db $0C,$93,$9D,$8E,$9D,$93,$9D,$8E
    db $9D,$93,$9D,$8E,$9D,$93,$9D,$95
    db $97,$98,$9F,$93,$9F,$98,$9F,$93
    db $9F,$18,$8C,$C7,$93,$C6

MusicB3S03P38:
    db $DA,$05,$DB,$14,$DE,$00,$00,$00
    db $E9,$F3,$17,$06,$18,$4C,$D1,$C7
    db $30,$6D,$D2

MusicB3S03P44:
    db $DA,$04,$DB,$0A,$DE,$22,$19,$38
    db $60,$5E,$BC,$C6,$DA,$01,$60,$C6
    db $C6,$C6,$00

MusicB3S03P45:
    db $DA,$04,$DB,$08,$DE,$20,$18,$36
    db $60,$5D,$B4,$C6,$DA,$01,$60,$C6
    db $C6,$C6

MusicB3S03P4A:
    db $DA,$04,$DB,$0C,$DE,$21,$1A,$37
    db $60,$5D,$AB,$C6,$DA,$01,$60,$C6
    db $C6,$C6

MusicB3S03P47:
    db $DA,$04,$DB,$0A,$DE,$22,$18,$36
    db $60,$5D,$A4,$C6,$DA,$01,$60,$C6
    db $C6,$C6

MusicB3S03P49:
    db $DA,$04,$DB,$0F,$10,$5D,$B0,$C7
    db $B0,$AE,$C7,$AE,$AD,$C7,$AD,$AC
    db $C7,$AC,$30,$AB,$24,$A7,$6C,$A6
    db $60,$C6

MusicB3S03P4B:
    db $DA,$04,$DB,$0F,$10,$5D,$AB,$C7
    db $AB,$A8,$C7,$A8,$A9,$C7,$A9,$A9
    db $C7,$A9,$30,$A6,$24,$A3,$6C,$A2
    db $60,$C6

MusicB3S03P48:
    db $DA,$04,$DB,$0F,$10,$5D,$A8,$C7
    db $A8,$A4,$C7,$A4,$A4,$C7,$A4,$A4
    db $C7,$A4,$30,$A3,$24,$9D,$6C,$9C
    db $60,$C6

MusicB3S03P46:
    db $DA,$08,$DB,$0A,$DE,$22,$19,$38
    db $10,$5D,$8C,$8C,$8C,$90,$90,$90
    db $91,$91,$91,$92,$92,$92,$30,$93
    db $24,$93,$6C,$8C,$60,$C6

MusicB3S02P00:
    db $DA,$01,$E2,$12,$DB,$0A,$DE,$14
    db $19,$28,$18,$7C,$A7,$0C,$A8,$AB
    db $AD,$30,$AB,$0C,$AD,$AF,$C6,$AF
    db $30,$AD,$0C,$A7,$A8,$AB,$AD,$30
    db $AB,$0C,$AC,$AD,$C6,$AD,$60,$AB
    db $60,$77,$C6,$00

MusicB3S02P03:
    db $DA,$02,$DB,$0A,$18,$79,$A7,$0C
    db $A8,$AB,$AD,$30,$AB,$0C,$AD,$AF
    db $C6,$AF,$30,$AD,$0C,$A7,$A8,$AB
    db $AD,$30,$AB,$0C,$AC,$AD,$C6,$AD
    db $60,$AB,$C6

MusicB3S02P01:
    db $DA,$01,$DB,$0C,$DE,$14,$19,$28
    db $06,$C6,$18,$79,$A7,$0C,$A8,$AB
    db $AD,$30,$AB,$0C,$AD,$AF,$C6,$AF
    db $30,$AD,$0C,$A7,$A8,$AB,$AD,$30
    db $AB,$0C,$AC,$AD,$C6,$AD,$60,$AB
    db $60,$75,$C6

MusicB3S02P02:
    db $DA,$01,$DB,$0A,$DE,$14,$19,$28
    db $18,$7B,$C7,$60,$98,$97,$96,$95
    db $C6,$C6,$C6

MusicB3S02P04:
    db $DA,$01,$DB,$0A,$DE,$14,$19,$28
    db $18,$7B,$C7,$0C,$C7,$24,$9F,$30
    db $B0,$0C,$C7,$24,$9F,$30,$AF,$0C
    db $C7,$24,$9F,$30,$AE,$0C,$C7,$24
    db $9F,$30,$B1,$60,$C6,$C6,$C6

MusicB3S02P05:
    db $DA,$01,$DB,$0A,$DE,$14,$19,$28
    db $18,$7B,$C7,$18,$C7,$48,$A8,$18
    db $C7,$48,$A7,$18,$C7,$48,$A6,$18
    db $C7,$48,$A5,$60,$C6,$C6,$C6

MusicB3S02P06:
    db $DA,$01,$DB,$0A,$DE,$14,$19,$28
    db $18,$7B,$C7,$24,$C7,$3C,$AB,$24
    db $C7,$3C,$AB,$24,$C7,$3C,$AB,$24
    db $C7,$3C,$AB,$60,$C6,$C6,$C6

MusicB3S02P07:
    db $DA,$01,$DB,$0A,$DE,$14,$19,$28
    db $18,$7B,$C7,$30,$C7,$B4,$30,$C7
    db $B3,$30,$C7,$B2,$30,$C7,$B4,$60
    db $C6,$C6,$C6

MusicB3S03P05:
    db $DA,$04,$DB,$08,$DE,$22,$18,$14
    db $08,$5C,$C7,$A9,$C7,$A9,$AD,$C7
    db $24,$AA,$0C,$C7,$08,$A9,$A8,$C7
    db $A8,$A8,$C7,$24,$AB,$0C,$C7,$08
    db $C7

MusicB3S03P00:
    db $E2,$1C,$DA,$04,$DB,$0A,$DE,$22
    db $18,$14,$08,$5D,$AC,$AD,$C7,$AF
    db $B0,$C7,$24,$AD,$0C,$C7,$08,$AC
    db $AB,$C7,$AC,$AD,$C7,$24,$B4,$0C
    db $C7,$08,$C7,$00

MusicB3S03P04:
    db $DA,$04,$DB,$0C,$DE,$22,$18,$14
    db $08,$5C,$C7,$A4,$C7,$A4,$A9,$C7
    db $24,$A4,$0C,$C7,$08,$A4,$A4,$C7
    db $A4,$A4,$C7,$24,$A5,$0C,$C7,$08
    db $C7

MusicB3S03P03:
    db $DA,$06,$DB,$0A,$DE,$22,$18,$14
    db $08,$5D,$B8,$B9,$C7,$BB,$BC,$C7
    db $24,$B9,$0C,$C7,$08,$B8,$B7,$C7
    db $B8,$B9,$C7,$24,$C0,$0C,$C7,$08
    db $C7

MusicB3S03P01:
    db $DA,$0D,$DB,$0F,$DE,$22,$18,$14
    db $01,$C7,$08,$C7,$18,$4E,$C7,$9D
    db $C7,$9E,$C7,$9F,$C7,$9F,$18,$9E
    db $08,$C7,$C7,$9D,$18,$C6,$08,$C7
    db $C7,$AB

MusicB3S03P06:
    db $DA,$0D,$DB,$0F,$DE,$22,$18,$14
    db $08,$C7,$18,$4E,$C7,$98,$C7,$98
    db $C7,$9A,$C7,$99,$18,$A1,$08,$C7
    db $C7,$A3,$18,$C6,$08,$C7,$C7,$A4

MusicB3S03P02:
    db $DA,$08,$DB,$0A,$DE,$22,$18,$14
    db $08,$C7,$18,$5F,$91,$08,$C7,$C7
    db $91,$18,$92,$08,$C7,$C7,$92,$18
    db $93,$08,$C7,$C7,$93,$18,$95,$08
    db $95,$90,$8F,$18,$8E,$08,$C6,$C7
    db $93,$18,$C6,$08,$C7,$C7,$98

MusicB3S03P07:
    db $DA,$04,$DB,$14,$08,$C7,$18,$6C
    db $D1,$08,$D2,$C7,$D1,$18,$D1,$08
    db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7
    db $D1,$D1,$C7,$D1,$D2,$D1,$D1,$18
    db $D2,$08,$C6,$C7,$D2,$18,$C6,$08
    db $C7,$C7,$D2

MusicB3S03P08:
    db $DA,$04,$DB,$0A,$DE,$22,$19,$38
    db $18,$4D,$B4,$08,$C7,$C7,$B4,$E3
    db $60,$18,$18,$B4,$08,$C7,$C7,$B7
    db $18,$B7,$08,$C7,$C7,$B7,$18,$B7
    db $C7,$00

MusicB3S03P09:
    db $DA,$04,$DB,$08,$DE,$20,$18,$36
    db $18,$4D,$A4,$08,$C7,$C7,$A4,$18
    db $A4,$08,$C7,$C7,$A7,$18,$A7,$08
    db $C7,$C7,$A7,$18,$A7,$C7

MusicB3S03P0E:
    db $DA,$04,$DB,$0C,$DE,$21,$1A,$37
    db $18,$4D,$AD,$08,$C7,$C7,$AD,$18
    db $AD,$08,$C7,$C7,$AF,$18,$AF,$08
    db $C7,$C7,$AF,$18,$AF,$C7

MusicB3S03P0B:
    db $DA,$04,$DB,$0A,$DE,$22,$18,$36
    db $18,$4D,$A9,$08,$C7,$C7,$A9,$18
    db $A9,$08,$C7,$C7,$AB,$18,$AB,$08
    db $C7,$C7,$AB,$18,$AB,$C7

MusicB3S03P0D:
    db $DA,$04,$DB,$0F,$08,$4D,$C7,$C7
    db $9A,$18,$9A,$08,$C7,$C7,$9A,$18
    db $9A,$08,$C7,$C7,$9F,$18,$9F,$18
    db $C7,$18,$7D,$9F

MusicB3S03P0C:
    db $DA,$04,$DB,$0F,$08,$4C,$C7,$C7
    db $8E,$18,$8E,$08,$C7,$C7,$8E,$18
    db $8E,$08,$C7,$C7,$93,$18,$93,$18
    db $C7,$18,$7E,$93

MusicB3S03P0A:
    db $DA,$08,$DB,$0A,$DE,$22,$19,$38
    db $08,$5F,$C7,$C7,$8E,$18,$8E,$08
    db $C7,$C7,$8E,$18,$8E,$08,$C7,$C7
    db $93,$18,$93,$18,$C7,$18,$7F,$93

MusicB3S03P0F:
    db $DA,$00,$DB,$0A,$08,$6C,$C7,$C7
    db $D0,$18,$D0,$08,$C7,$C7,$D0,$18
    db $D0,$08,$C7,$C7,$D0,$18,$D0,$18
    db $C7,$D0

MusicB3S01P00:
    db $24,$C7,$00

MusicB3S01P01:
    db $DA,$04,$E2,$16,$E3,$90,$1C,$DB
    db $0A,$DE,$22,$19,$38,$18,$4C,$B4
    db $08,$C7,$C7,$B4,$18,$B4,$08,$C7
    db $C7,$B7,$18,$B7,$08,$C7,$C7,$B7
    db $18,$B7,$C7,$00

MusicB3S01P02:
    db $DA,$04,$DB,$08,$DE,$20,$18,$36
    db $18,$4C,$A4,$08,$C7,$C7,$A4,$18
    db $A4,$08,$C7,$C7,$A7,$18,$A7,$08
    db $C7,$C7,$A7,$18,$A7,$C7

MusicB3S01P07:
    db $DA,$04,$DB,$0C,$DE,$21,$1A,$37
    db $18,$4C,$AD,$08,$C7,$C7,$AD,$18
    db $AD,$08,$C7,$C7,$AF,$18,$AF,$08
    db $C7,$C7,$AF,$18,$AF,$C7

MusicB3S01P04:
    db $DA,$04,$DB,$0A,$DE,$22,$18,$36
    db $18,$4C,$A9,$08,$C7,$C7,$A9,$18
    db $A9,$08,$C7,$C7,$AB,$18,$AB,$08
    db $C7,$C7,$AB,$18,$AB,$C7

MusicB3S01P06:
    db $DA,$04,$DB,$0F,$08,$4C,$C7,$C7
    db $9A,$18,$9A,$08,$C7,$C7,$9A,$18
    db $9A,$08,$C7,$C7,$9F,$18,$9F,$08
    db $C7,$C7,$C7,$18,$7D,$9F

MusicB3S01P05:
    db $DA,$04,$DB,$0F,$08,$4B,$C7,$C7
    db $8E,$18,$8E,$08,$C7,$C7,$8E,$18
    db $8E,$08,$C7,$C7,$93,$18,$93,$08
    db $C7,$C7,$C7,$18,$7E,$93

MusicB3S01P03:
    db $DA,$08,$DB,$0A,$DE,$22,$19,$38
    db $08,$5E,$C7,$C7,$8E,$18,$8E,$08
    db $C7,$C7,$8E,$18,$8E,$08,$C7,$C7
    db $93,$18,$93,$08,$C7,$C7,$C7,$18
    db $7F,$93

MusicB3S01P08:
    db $DA,$00,$DB,$0A,$08,$6B,$C7,$C7
    db $D0,$18,$D0,$08,$C7,$C7,$D0,$18
    db $D0,$08,$C7,$C7,$D0,$18,$D0,$C7
    db $08,$D0,$DB,$14,$08,$D1,$D1

MusicB3S01P09:
    db $DA,$00,$DB,$0A,$DE,$22,$19,$38
    db $08,$5D,$A8,$C7,$AB,$AD,$C7,$24
    db $AB,$0C,$C7,$08,$AD,$AF,$C7,$B0
    db $AF,$AE,$24,$AD,$0C,$C7,$08,$A7
    db $A8,$C7,$AB,$AD,$C7,$24,$AB,$0C
    db $C7,$08,$AC,$AD,$C7,$AE,$AD,$AC
    db $24,$AB,$0C,$C7,$08,$AC,$00

MusicB3S01P13:
    db $DA,$06,$DB,$0A,$DE,$22,$19,$38

MusicB3S01P2A:
    db $08,$5D,$A8,$C7,$AB,$AD,$C7,$24
    db $AB,$0C,$C7,$08,$AD,$AF,$C7,$B0
    db $AF,$AE,$24,$AD,$0C,$C7,$08,$A7
    db $A8,$C7,$AB,$AD,$C7,$24,$AB,$0C
    db $C7,$08,$AC,$AD,$C7,$AE,$AD,$AC
    db $24,$AB,$0C,$C7,$08,$AC,$00

MusicB3S01P14:
    db $DA,$12,$DB,$05,$DE,$22,$19,$28
    db $60,$6B,$B4,$30,$B3,$08,$C6,$C6
    db $B3,$BB,$C6,$B9,$48,$B7,$18,$B2
    db $60,$B1

MusicB3S01P15:
    db $DA,$06,$DB,$08,$DE,$14,$1F,$30
    db $08,$6B,$A4,$C7,$A4,$A8,$C7,$24
    db $A4,$0C,$C7,$08,$A8,$AB,$C7,$AB
    db $A7,$A7,$24,$A7,$0C,$C7,$08,$A3
    db $A2,$C7,$A6,$A6,$C7,$24,$A6,$0C
    db $C7,$08,$A6,$A8,$C7,$AB,$A8,$A8
    db $24,$A8,$0C,$C7,$08,$A8

MusicB3S01P2C:
    db $08,$6D,$A4,$C7,$A4,$A8,$C7,$24
    db $A4,$0C,$C7,$08,$A8,$AB,$C7,$AB
    db $A7,$A7,$24,$A7,$0C,$C7,$08,$A3
    db $A2,$C7,$A6,$A6,$C7,$24,$A6,$0C
    db $C7,$08,$A6,$A8,$C7,$AB,$A8,$A8
    db $24,$A8,$0C,$C7,$08,$A8

MusicB3S01P2B:
    db $DA,$06,$DB,$0C,$DE,$14,$1F,$30
    db $08,$6D,$9F,$C7,$A8,$A4,$C7,$24
    db $A8,$0C,$C7,$08,$A4,$A7,$C7,$A7
    db $AB,$AB,$24,$A3,$0C,$C7,$08,$9F
    db $9F,$C7,$A2,$A2,$C7,$24,$A2,$0C
    db $C7,$08,$A2,$A5,$C7,$A8,$A5,$A5
    db $24,$A5,$0C,$C7,$08,$A5

MusicB3S01P0A:
    db $DA,$0D,$DB,$0F,$01,$C7,$18,$4E
    db $C7,$9F,$C7,$9F,$C7,$9F,$C7,$9F
    db $C7,$9F,$C7,$9F,$C7,$9F,$C7,$9F

MusicB3S01P0C:
    db $DA,$0D,$DB,$0F,$18,$4E,$C7,$9C
    db $C7,$9C,$C7,$9B,$C7,$9B,$C7,$9A
    db $C7,$9A,$C7,$99,$C7,$99

MusicB3S01P0B:
    db $DA,$08,$DB,$0A,$DE,$14,$1F,$30
    db $18,$6F,$98,$C7,$18,$93,$08,$C7
    db $C7,$93,$18,$97,$C7,$18,$93,$08
    db $C7,$C7,$93,$18,$96,$C7,$18,$93
    db $08,$C7,$C7,$93,$18,$95,$C7,$18
    db $90,$08,$C7,$C7,$90

MusicB3S01P0D:
    db $DA,$00,$DB,$14,$18,$6B,$D1,$08
    db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7
    db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1
    db $C7,$D1,$D2,$D1,$D1,$18,$D1,$08
    db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7
    db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1
    db $C7,$D1,$D2,$D1,$D1

MusicB3S01P0E:
    db $08,$AD,$C7,$AF,$B0,$C7,$24,$AD
    db $0C,$C7,$08,$AC,$AB,$C7,$AC,$AD
    db $C7,$24,$A8,$0C,$C7,$08,$C7,$A8
    db $C7,$A4,$A1,$C7,$A8,$A4,$C7,$A1
    db $A4,$C7,$AB,$30,$C6,$C7,$00

MusicB3S01P0F:
    db $01,$C7,$18,$C7,$9D,$C7,$9E,$C7
    db $9F,$C7,$9F,$18,$9E,$08,$C7,$C7
    db $9E,$18,$C6,$08,$9E,$C7,$9F,$18
    db $C6,$08,$C7,$C7,$A3,$A4,$C7,$A4
    db $A6,$C7,$A6

MusicB3S01P11:
    db $18,$C7,$98,$C7,$98,$C7,$9A,$C7
    db $99,$18,$A1,$08,$C7,$C7,$A1,$18
    db $C6,$08,$A1,$C7,$A3,$18,$C6,$08
    db $C7,$C7,$9A,$9C,$C7,$9C,$9D,$C7
    db $9D

MusicB3S01P10:
    db $18,$91,$08,$C7,$C7,$91,$18,$92
    db $08,$C7,$C7,$92,$18,$93,$08,$C7
    db $C7,$93,$18,$95,$08,$95,$90,$8F
    db $18,$8E,$08,$C6,$C7,$8E,$18,$C6
    db $08,$8E,$C7,$93,$18,$C6,$08,$C7
    db $C7,$93,$95,$C7,$95,$97,$C7,$97

MusicB3S01P12:
    db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
    db $08,$D2,$C7,$D1,$18,$D1,$08,$D2
    db $C7,$D1,$D1,$C7,$D1,$D2,$D1,$D1
    db $18,$D2,$08,$C6,$C7,$D2,$18,$C6
    db $08,$D2,$C7,$D2,$18,$C6,$08,$C6
    db $C7,$D1,$D2,$C7,$D1,$D2,$D1,$D1

MusicB3S01P1A:
    db $08,$A9,$C7,$A9,$AD,$C7,$24,$AA
    db $0C,$C7,$08,$A9,$A8,$C7,$A8,$A8
    db $C7,$24,$AB,$0C,$C7,$08,$C7,$AD
    db $C7,$AD,$AD,$C7,$A9,$C7,$C7,$A9
    db $A9,$C7,$A8,$30,$C6,$C7

MusicB3S01P16:
    db $08,$AD,$C7,$AF,$B0,$C7,$24,$AD
    db $0C,$C7,$08,$AC,$AB,$C7,$AC,$AD
    db $C7,$24,$B4,$0C,$C7,$08,$C7,$B4
    db $C7,$B3,$B4,$C7,$B0,$C7,$C7,$B0
    db $AD,$C7,$B0,$30,$C6,$C7,$00

MusicB3S01P19:
    db $48,$B0,$08,$AD,$C6,$B0,$48,$B4
    db $08,$B3,$C6,$B4,$30,$B9,$30,$B4
    db $60,$B0

MusicB3S01P17:
    db $01,$C7,$18,$C7,$9D,$C7,$9E,$C7
    db $9F,$C7,$9F,$18,$9E,$08,$C7,$C7
    db $9D,$18,$C6,$08,$C7,$C7,$AB,$18
    db $C6,$08,$B0,$C7,$B0,$AF,$C7,$AF
    db $AE,$C7,$AE

MusicB3S01P1B:
    db $18,$C7,$98,$C7,$98,$C7,$9A,$C7
    db $99,$18,$A1,$08,$C7,$C7,$A3,$18
    db $C6,$08,$C7,$C7,$A4,$18,$C6,$08
    db $A8,$C7,$A8,$A7,$C7,$A7,$A6,$C7
    db $A6

MusicB3S01P18:
    db $18,$91,$08,$C7,$C7,$91,$18,$92
    db $08,$C7,$C7,$92,$18,$93,$08,$C7
    db $C7,$93,$18,$95,$08,$95,$90,$8F
    db $18,$8E,$08,$C6,$C7,$93,$18,$C6
    db $08,$C7,$C7,$98,$18,$C6,$08,$98
    db $C7,$98,$97,$C7,$97,$96,$C7,$96

MusicB3S01P1C:
    db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
    db $08,$D2,$C7,$D1,$18,$D1,$08,$D2
    db $C7,$D1,$D1,$C7,$D1,$D2,$D1,$D1
    db $18,$D2,$08,$C6,$C7,$D2,$18,$C6
    db $08,$C7,$C7,$D2,$18,$C6,$08,$D2
    db $C7,$D1,$D2,$C7,$D1,$D2,$C7,$D1

MusicB3S01P1D:
    db $DA,$04,$18,$6C,$AD,$B4,$08,$B4
    db $C7,$B4,$B3,$C7,$B4,$B5,$C6,$B4
    db $B1,$C7,$24,$AD,$0C,$C7,$08,$AD
    db $B4,$C6,$B2,$B4,$C6,$B2,$B4,$C6
    db $B2,$B0,$C7,$AD,$30,$C6,$C7,$00

MusicB3S01P21:
    db $DA,$04,$18,$6B,$A8,$AB,$08,$AB
    db $C7,$AB,$AA,$C7,$AB,$AD,$C6,$AB
    db $A8,$C7,$24,$A5,$0C,$C7,$08,$A5
    db $AB,$C6,$AA,$AB,$C6,$AA,$AB,$C6
    db $AA,$A8,$C7,$A4,$30,$C6,$C7

MusicB3S01P20:
    db $18,$C7,$08,$AD,$C6,$AC,$AD,$C6
    db $B4,$C6,$C6,$AD,$AD,$C6,$AC,$AD
    db $C6,$B4,$C6,$C6,$AD,$AF,$C6,$B1
    db $18,$C7,$08,$AD,$C6,$AC,$AD,$C6
    db $B2,$C6,$C6,$AD,$AD,$C6,$AC,$AD
    db $C6,$B2,$30,$C6

MusicB3S01P1E:
    db $01,$C7,$18,$C7,$9F,$C7,$9F,$C7
    db $9F,$C7,$9F,$C7,$9E,$C7,$9E,$C7
    db $9E,$C7,$9E

MusicB3S01P22:
    db $18,$C7,$99,$C7,$99,$C7,$99,$C7
    db $99,$C7,$98,$C7,$98,$C7,$98,$C7
    db $98

MusicB3S01P1F:
    db $18,$95,$08,$C7,$C7,$95,$18,$90
    db $08,$C7,$C7,$90,$18,$95,$08,$C7
    db $C7,$95,$18,$95,$08,$95,$90,$8F
    db $18,$8E,$08,$C7,$C7,$8E,$18,$95
    db $08,$C7,$C7,$95,$18,$8E,$08,$C7
    db $C7,$8E,$8E,$C7,$8E,$90,$C7,$92

MusicB3S01P23:
    db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
    db $08,$D2,$C7,$D1,$18,$D1,$08,$D2
    db $C7,$D1,$D1,$C7,$D1,$D2,$D1,$D1
    db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
    db $08,$D2,$C7,$D1,$18,$D1,$08,$D2
    db $C7,$D1,$D2,$C7,$D1,$D2,$C7,$D1

MusicB3S01P24:
    db $18,$AB,$B2,$08,$B2,$C7,$B2,$B1
    db $C7,$B2,$B4,$C6,$B2,$AF,$C7,$24
    db $AB,$0C,$C7,$08,$B2,$18,$B0,$B0
    db $10,$B0,$B2,$B3,$18,$B4,$C7,$AB
    db $C6,$00

MusicB3S01P28:
    db $18,$A3,$A9,$08,$A9,$C7,$A9,$A8
    db $C7,$A9,$AB,$C6,$A9,$A6,$C7,$24
    db $A3,$0C,$C7,$08,$A9,$18,$A8,$A8
    db $10,$A8,$A9,$AA,$18,$AB,$C7,$A3
    db $C6

MusicB3S01P27:
    db $18,$C7,$08,$AB,$C6,$AA,$AB,$C6
    db $B2,$C6,$C6,$AB,$AB,$C6,$AA,$AB
    db $C6,$B2,$C6,$C6,$AB,$AD,$C6,$AF
    db $30,$B0,$10,$B0,$AF,$AD,$AB,$06
    db $AD,$AF,$B0,$B2,$B3,$B4,$B5,$B6
    db $30,$B7

MusicB3S01P25:
    db $01,$C7,$18,$C7,$9D,$C7,$9D,$C7
    db $9D,$C7,$9D,$C7,$9C,$10,$9C,$9D
    db $9E,$18,$9F,$C7,$9B,$C6

MusicB3S01P29:
    db $18,$C7,$97,$C7,$97,$C7,$97,$C7
    db $97,$C7,$9F,$10,$9F,$A0,$A1,$18
    db $A3,$C7,$A3,$C6

MusicB3S01P26:
    db $18,$93,$08,$C7,$C7,$93,$18,$8E
    db $08,$C7,$C7,$8E,$18,$93,$08,$C7
    db $C7,$93,$18,$93,$08,$93,$95,$97
    db $18,$98,$08,$C7,$C7,$98,$10,$98
    db $9A,$9B,$18,$9C,$C7,$93,$C6,$18
    db $D1,$08,$D2,$C7,$D1,$18,$D1,$08
    db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7
    db $D1,$D1,$C7,$D1,$D2,$D1,$D1,$18
    db $D1,$08,$D2,$C7,$D1,$10,$D2,$D2
    db $D2,$18,$D1,$08,$D2,$C7,$D1,$D2
    db $C7,$D1,$D2,$D1,$D1

MusicB3S01P32:
    db $08,$A9,$C7,$A9,$AD,$C7,$24,$AA
    db $0C,$C7,$08,$A9,$A8,$C7,$A8,$A8
    db $C7,$24,$AB,$0C,$C7,$08,$C7

MusicB3S01P2D:
    db $08,$AD,$C7,$AF,$B0,$C7,$24,$AD
    db $0C,$C7,$08,$AC,$AB,$C7,$AC,$AD
    db $C7,$24,$B4,$0C,$C7,$08,$C7,$00

MusicB3S01P31:
    db $DA,$04,$DB,$0C,$DE,$22,$18,$14
    db $08,$5C,$A4,$C7,$A4,$A9,$C7,$24
    db $A4,$0C,$C7,$08,$A4,$A4,$C7,$A4
    db $A4,$C7,$24,$A5,$0C,$C7,$08,$C7

MusicB3S01P30:
    db $48,$B0,$08,$AD,$C6,$B0,$60,$B4

MusicB3S01P2E:
    db $01,$C7,$18,$C7,$9D,$C7,$9E,$C7
    db $9F,$C7,$9F,$18,$9E,$08,$C7,$C7
    db $9D,$18,$C6,$08,$C7,$C7,$AB

MusicB3S01P33:
    db $18,$C7,$98,$C7,$98,$C7,$9A,$C7
    db $99,$18,$A1,$08,$C7,$C7,$A3,$18
    db $C6,$08,$C7,$C7,$A4

MusicB3S01P2F:
    db $18,$91,$08,$C7,$C7,$91,$18,$92
    db $08,$C7,$C7,$92,$18,$93,$08,$C7
    db $C7,$93,$18,$95,$08,$95,$90,$8F
    db $18,$8E,$08,$C6,$C7,$93,$18,$C6
    db $08,$C7,$C7,$98

MusicB3S01P34:
    db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
    db $08,$D2,$C7,$D1,$18,$D1,$08,$D2
    db $C7,$D1,$D1,$C7,$D1,$D2,$D1,$D1
    db $18,$D2,$08,$C6,$C7,$D2,$18,$C6
    db $08,$C7,$C7,$D2

MusicB3S01P35:
    db $DA,$04,$DB,$0A,$DE,$22,$19,$38
    db $18,$4D,$B4,$08,$C7,$C7,$B4,$18
    db $B4,$08,$C7,$C7,$B7,$18,$B7,$08
    db $C7,$C7,$B7,$18,$B7,$C7,$00

MusicB3S01P36:
    db $DA,$04,$DB,$08,$DE,$20,$18,$36
    db $18,$4D,$A4,$08,$C7,$C7,$A4,$18
    db $A4,$08,$C7,$C7,$A7,$18,$A7,$08
    db $C7,$C7,$A7,$18,$A7,$C7

MusicB3S01P3B:
    db $DA,$04,$DB,$0C,$DE,$21,$1A,$37
    db $18,$4D,$AD,$08,$C7,$C7,$AD,$18
    db $AD,$08,$C7,$C7,$AF,$18,$AF,$08
    db $C7,$C7,$AF,$18,$AF,$C7

MusicB3S01P38:
    db $DA,$04,$DB,$0A,$DE,$22,$18,$36
    db $18,$4D,$A9,$08,$C7,$C7,$A9,$18
    db $A9,$08,$C7,$C7,$AB,$18,$AB,$08
    db $C7,$C7,$AB,$18,$AB,$C7

MusicB3S01P3A:
    db $DA,$04,$DB,$0F,$08,$4D,$C7,$C7
    db $9A,$18,$9A,$08,$C7,$C7,$9A,$18
    db $9A,$08,$C7,$C7,$9F,$18,$9F,$08
    db $C7,$C7,$C7,$18,$7D,$9F

MusicB3S01P39:
    db $DA,$04,$DB,$0F,$08,$4C,$C7,$C7
    db $8E,$18,$8E,$08,$C7,$C7,$8E,$18
    db $8E,$08,$C7,$C7,$93,$18,$93,$08
    db $C7,$C7,$C7,$18,$7E,$93

MusicB3S01P37:
    db $DA,$08,$DB,$0A,$DE,$22,$19,$38
    db $08,$5F,$C7,$C7,$8E,$18,$8E,$08
    db $C7,$C7,$8E,$18,$8E,$08,$C7,$C7
    db $93,$18,$93,$08,$C7,$C7,$C7,$18
    db $7F,$93

MusicB3S01P3C:
    db $DA,$00,$DB,$0A,$08,$6C,$C7,$C7
    db $D0,$18,$D0,$08,$C7,$C7,$D0,$18
    db $D0,$08,$C7,$C7,$D0,$18,$D0,$C7
    db $08,$D0,$DB,$14,$08,$D1,$D1

MusicB3S01P3D:
    db $DA,$06,$DB,$0A,$DE,$22,$19,$38
    db $08,$6F,$B4,$C7,$B7,$B9,$C7,$24
    db $B7,$0C,$C7,$08,$B9,$BB,$C7,$BC
    db $BB,$BA,$24,$B9,$0C,$C7,$08,$B3
    db $B4,$C7,$B7,$B9,$C7,$24,$B7,$0C
    db $C7,$08,$B8,$B9,$C7,$BA,$B9,$B8
    db $24,$B7,$0C,$C7,$08,$B8,$00

MusicB3S01P3E:
    db $08,$B9,$C7,$BB,$BC,$C7,$24,$B9
    db $0C,$C7,$08,$B8,$B7,$C7,$B8,$B9
    db $C7,$24,$C0,$0C,$C7,$08,$C7,$00

MusicB3S01P3F:
    db $18,$91,$08,$C7,$C7,$91,$18,$92
    db $08,$C7,$C7,$92,$18,$93,$08,$C7
    db $C7,$93,$18,$95,$08,$C7,$C7,$95

MusicB3S01P50:
    db $DA,$04,$DB,$0A,$DE,$22,$19,$38
    db $18,$5D,$C0,$08,$C7,$C7,$C0,$E3
    db $78,$18,$18,$C0,$08,$C7,$C7,$C3
    db $18,$C3,$08,$C7,$C7,$C3,$18,$C3
    db $C3,$00

MusicB3S01P40:
    db $DA,$04,$DB,$0A,$DE,$22,$19,$38
    db $18,$5D,$C0,$08,$C7,$C7,$C0,$18
    db $C0,$08,$C7,$C7,$C3,$18,$C3,$08
    db $C7,$C7,$C3,$18,$C3,$C3,$00

MusicB3S01P41:
    db $DA,$04,$DB,$08,$DE,$20,$18,$36
    db $18,$5D,$A4,$08,$C7,$C7,$A4,$18
    db $A4,$08,$C7,$C7,$A7,$18,$A7,$08
    db $C7,$C7,$A7,$18,$A7,$A7

MusicB3S01P46:
    db $DA,$04,$DB,$0C,$DE,$21,$1A,$37
    db $18,$5D,$B9,$08,$C7,$C7,$B9,$18
    db $B9,$08,$C7,$C7,$BB,$18,$BB,$08
    db $C7,$C7,$BB,$18,$BB,$BB

MusicB3S01P43:
    db $DA,$04,$DB,$0A,$DE,$22,$18,$36
    db $18,$5D,$A9,$08,$C7,$C7,$A9,$18
    db $A9,$08,$C7,$C7,$AB,$18,$AB,$08
    db $C7,$C7,$AB,$18,$AB,$AB

MusicB3S01P45:
    db $DA,$04,$DB,$0F,$08,$5D,$C7,$C7
    db $9A,$18,$9A,$08,$C7,$C7,$9A,$18
    db $9A,$08,$C7,$C7,$9F,$18,$9F,$08
    db $C7,$C7,$9F,$08,$7D,$C7,$C7,$9F

MusicB3S01P44:
    db $DA,$04,$DB,$0F,$08,$5C,$C7,$C7
    db $8E,$18,$8E,$08,$C7,$C7,$8E,$18
    db $8E,$08,$C7,$C7,$93,$18,$93,$08
    db $C7,$C7,$93,$08,$7E,$C7,$C7,$93

MusicB3S01P42:
    db $DA,$08,$DB,$0A,$DE,$22,$19,$38
    db $08,$5F,$C7,$C7,$8E,$18,$8E,$08
    db $C7,$C7,$8E,$18,$8E,$08,$C7,$C7
    db $93,$18,$93,$08,$C7,$C7,$C7,$08
    db $7F,$C7,$C7,$93

MusicB3S01P47:
    db $DA,$00,$DB,$0A,$08,$6C,$C7,$C7
    db $D0,$18,$D0,$08,$C7,$C7,$D0,$18
    db $D0,$08,$C7,$C7,$D0,$18,$D0,$C7
    db $08,$D0,$DB,$14,$08,$D1,$D1

MusicB3S01P49:
    db $DA,$04,$DE,$14,$19,$30,$DB,$0A
    db $08,$4F,$B9,$C6,$B7,$B9,$C6,$24
    db $B7,$0C,$C6,$08,$B9,$BB,$C6,$C7
    db $BB,$C6,$24,$B9,$0C,$C6,$08,$C6
    db $B9,$C6,$B7,$B9,$C6,$24,$B7,$0C
    db $C6,$08,$B8,$B9,$C6,$C7,$B9,$C6
    db $24,$B7,$0C,$C6,$08,$B8

MusicB3S01P48:
    db $DE,$16,$18,$30,$DB,$0A,$08,$4E
    db $AD,$C6,$AB,$AD,$C6,$24,$AB,$0C
    db $C6,$08,$AD,$AF,$C6,$C7,$AF,$C6
    db $24,$AD,$0C,$C6,$08,$C6,$AD,$C6
    db $AB,$AD,$C6,$24,$AB,$0C,$C7,$08
    db $AC,$AD,$C6,$C7,$AD,$C6,$24,$AB
    db $0C,$C6,$08,$AC,$00

MusicB3S01P4B:
    db $DE,$15,$19,$31,$DB,$08,$08,$4E
    db $A8,$C6,$A4,$A8,$C6,$24,$A8,$0C
    db $C6,$08,$A8,$AB,$C6,$C7,$AB,$C6
    db $24,$A7,$0C,$C6,$08,$C6,$A6,$C6
    db $A6,$A6,$C6,$24,$A6,$0C,$C6,$08
    db $A6,$A8,$C6,$C7,$A8,$C6,$24,$A8
    db $0C,$C6,$08,$A8

MusicB3S01P4A:
    db $DA,$06,$DB,$0C,$DE,$14,$1A,$30
    db $08,$4E,$A4,$C6,$A4,$A4,$C6,$24
    db $A4,$0C,$C6,$08,$A4,$A7,$C6,$C7
    db $A7,$C6,$24,$A3,$0C,$C6,$08,$C6
    db $A2,$C6,$A2,$A2,$C6,$24,$A2,$0C
    db $C6,$08,$A2,$A5,$C6,$C7,$A5,$C6
    db $24,$A5,$0C,$C6,$08,$A5

MusicB3S01P4D:
    db $08,$B9,$C6,$BB,$BC,$C6,$24,$B9
    db $0C,$C6,$08,$B8,$B7,$C6,$B8,$B9
    db $C6,$24,$C0,$0C,$C6,$08,$C6,$00

MusicB3S01P4F:
    db $08,$A9,$C6,$A9,$AD,$C6,$24,$AA
    db $0C,$C6,$08,$A9,$A8,$C6,$A8,$A8
    db $C6,$24,$AB,$0C,$C6,$08,$C6

MusicB3S01P4C:
    db $08,$AD,$C6,$AF,$B0,$C6,$24,$AD
    db $0C,$C6,$08,$AC,$AB,$C6,$AC,$AD
    db $C6,$24,$B4,$0C,$C6,$08,$C6,$00

MusicB3S01P4E:
    db $DA,$04,$DB,$0C,$DE,$22,$18,$14
    db $08,$5C,$A4,$C6,$A4,$A9,$C6,$24
    db $A4,$0C,$C6,$08,$A4,$A4,$C6,$A4
    db $A4,$C6,$24,$A5,$0C,$C6,$08,$C6

MusicB3S01P51:
    db $DA,$04,$DB,$0A,$DE,$22,$19,$38
    db $60,$5E,$BC,$C6,$DA,$01,$10,$9F
    db $C6,$C6,$C6,$AF,$C6,$60,$C6,$C6
    db $00

MusicB3S01P52:
    db $DA,$04,$DB,$08,$DE,$20,$18,$36
    db $60,$5D,$B4,$C6,$DA,$01,$10,$C7
    db $A3,$C6,$C6,$C6,$B3,$60,$C6,$C6

MusicB3S01P57:
    db $DA,$04,$DB,$0C,$DE,$21,$1A,$37
    db $60,$5D,$AB,$C6,$DA,$01,$10,$C7
    db $C7,$A7,$C6,$C6,$C6,$60,$B7,$C6

MusicB3S01P54:
    db $DA,$04,$DB,$0A,$DE,$22,$18,$36
    db $60,$5D,$A4,$C6,$DA,$01,$10,$C7
    db $C7,$C7,$AB,$C6,$C6,$60,$C6,$C6

MusicB3S01P56:
    db $DA,$04,$DB,$0F,$10,$5D,$A4,$C7
    db $A4,$A2,$C7,$A2,$A1,$C7,$A1,$A0
    db $C7,$A0,$60,$9F,$9B,$C6

MusicB3S01P55:
    db $DA,$0D,$DB,$0F,$10,$5D,$9C,$C7
    db $9C,$9C,$C7,$9C,$98,$C7,$98,$98
    db $C7,$98,$60,$97,$97,$C6

MusicB3S01P53:
    db $DA,$08,$DB,$0A,$DE,$22,$19,$38
    db $10,$5D,$98,$C7,$98,$96,$C7,$96
    db $95,$C7,$95,$94,$C7,$94,$60,$93
    db $93,$C6


    base off

MusicBank3_End:
    dw $0000,SPCEngine

    db $E8,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00

    %insert_empty($220,$220,$220,$220,$220)
