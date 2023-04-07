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
    JSL GenericSprGfxRt2
    LDA.B SpriteLock
    BNE Return038086
    JSR SubOffscreen0Bnk3
    JSL SprSpr_MarioSprRts
    LDA.W SpriteMisc1540,X
    BEQ CODE_03802D
    DEC A
    BNE +
    JSL CODE_01AB6F
CODE_03802D:
    JSL UpdateSpritePos
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    LDA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.B SpriteXSpeed,X
  + LDA.W SpriteBlockedDirs,X
    AND.B #$08
    BEQ +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ Return038086                          ; /
    LDA.W SpriteMisc1540,X
    BNE Return038086
    LDA.W SpriteOBJAttribute,X
    EOR.B #$40
    STA.W SpriteOBJAttribute,X
    JSL GetRand
    AND.B #$03
    TAY
    LDA.W DATA_03800E,Y
    STA.B SpriteYSpeed,X
    LDY.W SpriteSlope,X
    INY
    INY
    INY
    LDA.W DATA_038007,Y
    CLC
    ADC.B SpriteXSpeed,X
    BPL CODE_03807E
    CMP.B #$E0
    BCS +
    LDA.B #$E0
    BRA +

CODE_03807E:
    CMP.B #$20
    BCC +
    LDA.B #$20
  + STA.B SpriteXSpeed,X
Return038086:
    RTS

BigBooBoss:
    JSL CODE_038398
    JSL CODE_038239
    LDA.W SpriteStatus,X
    BNE +
    INC.W CutsceneID
    LDA.B #$FF
    STA.W EndLevelTimer
    LDA.B #!BGM_BOSSCLEAR
    STA.W SPCIO2                              ; / Change music
    RTS

  + CMP.B #$08
    BNE +
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
    LDA.B #$03
    STA.W SpriteMisc1602,X
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    CMP.B #$90
    BNE +
    LDA.B #$08
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + RTS

CODE_0380D5:
    LDA.W SpriteMisc1540,X
    BNE Return0380F9
    LDA.B #$08
    STA.W SpriteMisc1540,X
    INC.W BooTransparency
    LDA.W BooTransparency
    CMP.B #$02
    BNE +
    LDY.B #!SFX_MAGIC                         ; \ Play sound effect
    STY.W SPCIO0                              ; /
  + CMP.B #$07
    BNE Return0380F9
    INC.B SpriteTableC2,X
    LDA.B #$40
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
    LDA.W SpriteMisc1540,X
    BNE +
    STZ.B SpriteTableC2,X
    LDA.B #$40
    STA.W SpriteMisc1570,X
  + LDA.B #$03
    STA.W SpriteMisc1602,X
    BRA +

CODE_038119:
    STZ.W SpriteMisc1602,X
    JSR CODE_0381E4
  + LDA.W SpriteMisc15AC,X
    BNE CODE_038132
    JSR SubHorzPosBnk3
    TYA
    CMP.W SpriteMisc157C,X
    BEQ CODE_03814A
    LDA.B #$1F
    STA.W SpriteMisc15AC,X
CODE_038132:
    CMP.B #$10
    BNE +
    PHA
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
    PLA
  + LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_038102,Y
    STA.W SpriteMisc1602,X
CODE_03814A:
    LDA.B EffFrame
    AND.B #$07
    BNE +
    LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X
    CLC
    ADC.W DATA_0380FA,Y
    STA.B SpriteXSpeed,X
    CMP.W DATA_0380FC,Y
    BNE +
    INC.W SpriteMisc151C,X
  + LDA.B EffFrame
    AND.B #$07
    BNE +
    LDA.W SpriteMisc1528,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W DATA_038100,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_0380FE,Y
    BNE +
    INC.W SpriteMisc1528,X
  + JSL UpdateXPosNoGvtyW
    JSL UpdateYPosNoGvtyW
    RTS

CODE_03818B:
    LDA.W SpriteMisc1540,X
    BNE CODE_0381AE
    INC.B SpriteTableC2,X
    LDA.B #$08
    STA.W SpriteMisc1540,X
    JSL LoadSpriteTables
    INC.W SpriteMisc1534,X
    LDA.W SpriteMisc1534,X
    CMP.B #$03
    BNE +
    LDA.B #$06
    STA.B SpriteTableC2,X
    JSL KillMostSprites
  + RTS

CODE_0381AE:
    AND.B #$0E
    EOR.W SpriteOBJAttribute,X
    STA.W SpriteOBJAttribute,X
    LDA.B #$03
    STA.W SpriteMisc1602,X
    RTS

CODE_0381BC:
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B #$08
    STA.W SpriteMisc1540,X
    DEC.W BooTransparency
    BNE +
    INC.B SpriteTableC2,X
    LDA.B #$C0
    STA.W SpriteMisc1540,X
  + RTS

CODE_0381D3:
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,X                      ; /
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    LDA.B #$D0
    STA.B SpriteYSpeed,X
    LDA.B #!SFX_FALL                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    RTS

CODE_0381E4:
    LDY.B #$0B
CODE_0381E6:
    LDA.W SpriteStatus,Y
    CMP.B #$09
    BEQ CODE_0381F5
    CMP.B #$0A
    BEQ CODE_0381F5
CODE_0381F1:
    DEY
    BPL CODE_0381E6
    RTS

CODE_0381F5:
    PHX
    TYX
    JSL GetSpriteClippingB
    PLX
    JSL GetSpriteClippingA
    JSL CheckForContact
    BCC CODE_0381F1
    LDA.B #$03
    STA.B SpriteTableC2,X
    LDA.B #$40
    STA.W SpriteMisc1540,X
    PHX
    TYX
    STZ.W SpriteStatus,X
    LDA.B SpriteXPosLow,X
    STA.B TouchBlockXPos
    LDA.W SpriteXPosHigh,X
    STA.B TouchBlockXPos+1
    LDA.B SpriteYPosLow,X
    STA.B TouchBlockYPos
    LDA.W SpriteYPosHigh,X
    STA.B TouchBlockYPos+1
    PHB
    LDA.B #$02
    PHA
    PLB
    LDA.B #$FF
    JSL ShatterBlock
    PLB
    PLX
    LDA.B #!SFX_ENEMYHURT                     ; \ Play sound effect
    STA.W SPCIO3                              ; /
    RTS

CODE_038239:
    LDY.B #$24
    STY.B ColorSettings
    LDA.W BooTransparency
    CMP.B #$08
    DEC A
    BCS +
    LDY.B #$34
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
    INY
    INX
    INC.B _0
    LDA.B _0
    CMP.B #$10
    BNE -
    LDX.W DynPaletteIndex
    LDA.B #$10
    STA.W DynPaletteTable,X
    LDA.B #$F0
    STA.W DynPaletteTable+1,X
    STZ.W DynPaletteTable+$12,X
    TXA
    CLC
    ADC.B #$12
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
    PHB                                       ; Wrapper
    PHK
    PLB
    JSR CODE_0383A0
    PLB
    RTL

CODE_0383A0:
    LDA.B SpriteNumber,X
    CMP.B #$37
    BNE CODE_0383C2
    LDA.B #$00
    LDY.B SpriteTableC2,X
    BEQ +
    LDA.B #$06
    LDY.W SpriteMisc1558,X
    BEQ +
    TYA
    AND.B #$04
    LSR A
    LSR A
    ADC.B #$02
  + STA.W SpriteMisc1602,X
    JSL GenericSprGfxRt2
    RTS

CODE_0383C2:
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc1602,X
    STA.B _6
    ASL A
    ASL A
    STA.B _3
    ASL A
    ASL A
    ADC.B _3
    STA.B _2
    LDA.W SpriteMisc157C,X
    STA.B _4
    LDA.W SpriteOBJAttribute,X
    STA.B _5
    LDX.B #$00
CODE_0383E0:
    PHX
    LDX.B _2
    LDA.W BigBooTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.B _4
    LSR A
    LDA.W BigBooGfxProp,X
    ORA.B _5
    BCS +
    EOR.B #$40
  + ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDA.W BigBooDispX,X
    BCS +
    EOR.B #$FF
    INC A
    CLC
    ADC.B #$28
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
    TAX
  + LDA.B _1
    CLC
    ADC.W BigBooDispY,X
    STA.W OAMTileYPos+$100,Y
    PLX
    INY
    INY
    INY
    INY
    INC.B _2
    INX
    CPX.B #$14
    BNE CODE_0383E0
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.W SpriteMisc1602,X
    CMP.B #$03
    BNE +
    LDA.W SpriteMisc1558,X
    BEQ +
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileYPos+$100,Y
    CLC
    ADC.B #$05
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
  + LDA.B #$13
    LDY.B #$02
    JSL FinishOAMWrite
    RTS

GreyFallingPlat:
    JSR CODE_038492
    LDA.B SpriteLock
    BNE Return038489
    JSR SubOffscreen0Bnk3
    LDA.B SpriteYSpeed,X
    BEQ CODE_038476
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +
    CLC
    ADC.B #$02
    STA.B SpriteYSpeed,X
  + JSL UpdateYPosNoGvtyW
CODE_038476:
    JSL InvisBlkMainRt
    BCC Return038489
    LDA.B SpriteYSpeed,X
    BNE Return038489
    LDA.B #$03
    STA.B SpriteYSpeed,X
    LDA.B #$18
    STA.W SpriteMisc1540,X
Return038489:
    RTS


FallingPlatDispX:
    db $00,$10,$20,$30

FallingPlatTiles:
    db $60,$61,$61,$62

CODE_038492:
    JSR GetDrawInfoBnk3
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC
    ADC.W FallingPlatDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.W FallingPlatTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.B #$03
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$03
    JSL FinishOAMWrite
    RTS


BlurpMaxSpeedY:
    db $04,$FC

BlurpSpeedX:
    db $08,$F8

BlurpAccelY:
    db $01,$FF

Blurp:
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W EffFrame
    LSR A
    LSR A
    LSR A
    CLC
    ADC.W CurSpriteProcess
    LSR A
    LDA.B #$A2
    BCC +
    LDA.B #$EC
  + STA.W OAMTileNo+$100,Y
    LDA.W SpriteStatus,X
    CMP.B #$08
    BEQ +
CODE_0384EC:
    LDA.W OAMTileAttr+$100,Y
    ORA.B #$80
    STA.W OAMTileAttr+$100,Y
    RTS

  + LDA.B SpriteLock
    BNE Return03852A
    JSR SubOffscreen0Bnk3
    LDA.B EffFrame
    AND.B #$03
    BNE +
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W BlurpAccelY,Y
    STA.B SpriteYSpeed,X
    CMP.W BlurpMaxSpeedY,Y
    BNE +
    INC.B SpriteTableC2,X
  + LDY.W SpriteMisc157C,X
    LDA.W BlurpSpeedX,Y
    STA.B SpriteXSpeed,X
    JSL UpdateXPosNoGvtyW
    JSL UpdateYPosNoGvtyW
    JSL SprSpr_MarioSprRts
Return03852A:
    RTS


PorcuPuffAccel:
    db $01,$FF

PorcuPuffMaxSpeed:
    db $10,$F0

PorcuPuffer:
    JSR CODE_0385A3
    LDA.B SpriteLock
    BNE Return038586
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return038586
    JSR SubOffscreen0Bnk3
    JSL SprSpr_MarioSprRts
    JSR SubHorzPosBnk3
    TYA
    STA.W SpriteMisc157C,X
    LDA.B EffFrame
    AND.B #$03
    BNE +
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
    ASL A
    ASL A
    CLC
    ADC.B SpriteXSpeed,X
    STA.B SpriteXSpeed,X
    JSL UpdateXPosNoGvtyW
    PLA
    STA.B SpriteXSpeed,X
    JSL CODE_019138
    LDY.B #$04
    LDA.W SpriteInLiquid,X
    BEQ +
    LDY.B #$FC
  + STY.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW
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
    JSR GetDrawInfoBnk3
    LDA.B EffFrame
    AND.B #$04
    STA.B _3
    LDA.W SpriteMisc157C,X
    STA.B _2
    PHX
    LDX.B #$03
CODE_0385B4:
    LDA.B _1
    CLC
    ADC.W PocruPufferDispY,X
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.B _2
    BNE +
    TXA
    ORA.B #$04
    TAX
  + LDA.B _0
    CLC
    ADC.W PocruPufferDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.W PocruPufferGfxProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLA
    PHA
    ORA.B _3
    TAX
    LDA.W PocruPufferTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_0385B4
    PLX
    LDY.B #$02
    LDA.B #$03
    JSL FinishOAMWrite
    RTS


FlyingBlockSpeedY:
    db $08,$F8

FlyingTurnBlocks:
    JSR CODE_0386A8
    LDA.B SpriteLock
    BNE Return038675
    LDA.W BGFastScrollActive
    BEQ CODE_038629
    LDA.W SpriteMisc1534,X
    INC.W SpriteMisc1534,X
    AND.B #$01
    BNE +
    DEC.W SpriteMisc1602,X
    LDA.W SpriteMisc1602,X
    CMP.B #$FF
    BNE +
    LDA.B #$FF
    STA.W SpriteMisc1602,X
    INC.W SpriteMisc157C,X
  + LDA.W SpriteMisc157C,X
    AND.B #$01
    TAY
    LDA.W FlyingBlockSpeedY,Y
    STA.B SpriteYSpeed,X
CODE_038629:
    LDA.B SpriteYSpeed,X
    PHA
    LDY.W SpriteMisc151C,X
    BNE +
    EOR.B #$FF
    INC A
    STA.B SpriteYSpeed,X
  + JSL UpdateYPosNoGvtyW
    PLA
    STA.B SpriteYSpeed,X
    LDA.W BGFastScrollActive
    STA.B SpriteXSpeed,X
    JSL UpdateXPosNoGvtyW
    STA.W SpriteMisc1528,X
    JSL InvisBlkMainRt
    BCC Return038675
    LDA.W BGFastScrollActive
    BNE Return038675
    LDA.B #$08
    STA.W BGFastScrollActive
    LDA.B #$7F
    STA.W SpriteMisc1602,X
    LDY.B #$09
CODE_038660:
    CPY.W CurSpriteProcess
    BEQ CODE_03866C
    LDA.W SpriteNumber,Y
    CMP.B #$C1
    BEQ CODE_038670
CODE_03866C:
    DEY
    BPL CODE_038660
    INY
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
    JSR GetDrawInfoBnk3
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B EffFrame
    LSR A
    AND.B #$04
    BEQ +
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
    CLC
    ADC.W ForestPlatDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W ForestPlatDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W ForestPlatTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W ForestPlatGfxProp,X
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W ForestPlatTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    LDX.B _6
    DEX
    BPL -
    PLX
    LDY.B #$FF
    LDA.B #$04
    JSL FinishOAMWrite
    RTS

GrayLavaPlatform:
    JSR CODE_03873A
    LDA.B SpriteLock
    BNE Return038733
    JSR SubOffscreen0Bnk3
    LDA.W SpriteMisc1540,X
    DEC A
    BNE +
    LDY.W SpriteLoadIndex,X                   ; \
    LDA.B #$00                                ; | Allow sprite to be reloaded by level loading routine
    STA.W SpriteLoadStatus,Y                  ; /
    STZ.W SpriteStatus,X
    RTS

  + JSL UpdateYPosNoGvtyW
    JSL InvisBlkMainRt
    BCC Return038733
    LDA.W SpriteMisc1540,X
    BNE Return038733
    LDA.B #$06
    STA.B SpriteYSpeed,X
    LDA.B #$40
    STA.W SpriteMisc1540,X
Return038733:
    RTS


LavaPlatTiles:
    db $85,$86,$85

DATA_038737:
    db $43,$03,$03

CODE_03873A:
    JSR GetDrawInfoBnk3
    PHX
    LDX.B #$02
  - LDA.B _0
    STA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$10
    STA.B _0
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.W LavaPlatTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_038737,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$02
    JSL FinishOAMWrite
    RTS


MegaMoleSpeed:
    db $10,$F0

MegaMole:
    JSR MegaMoleGfxRt                         ; Graphics routine
    LDA.W SpriteStatus,X                      ; \
    CMP.B #$08                                ; | If status != 8, return
    BNE Return038733                          ; /
    JSR SubOffscreen3Bnk3                     ; Handle off screen situation
    LDY.W SpriteMisc157C,X                    ; \ Set x speed based on direction
    LDA.W MegaMoleSpeed,Y                     ; |
    STA.B SpriteXSpeed,X                      ; /
    LDA.B SpriteLock                          ; \ If sprites locked, return
    BNE Return038733                          ; /
    LDA.W SpriteBlockedDirs,X
    AND.B #$04
    PHA
    JSL UpdateSpritePos                       ; Update position based on speed values
    JSL SprSprInteract                        ; Interact with other sprites
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ MegaMoleInAir                         ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    PLA
    BRA MegaMoleOnGround

MegaMoleInAir:
    PLA
    BEQ +
    LDA.B #$0A
    STA.W SpriteMisc1540,X
  + LDA.W SpriteMisc1540,X
    BEQ MegaMoleOnGround
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
MegaMoleOnGround:
    LDY.W SpriteMisc15AC,X                    ; \
    LDA.W SpriteBlockedDirs,X                 ; | If Mega Mole is in contact with an object...
    AND.B #$03                                ; |
    BEQ CODE_0387CD                           ; |
    CPY.B #$00                                ; |    ... and timer hasn't been set (time until flip == 0)...
    BNE +                                     ; |
    LDA.B #$10                                ; |    ... set time until flip
    STA.W SpriteMisc15AC,X                    ; /
  + LDA.W SpriteMisc157C,X                    ; \ Flip the temp direction status
    EOR.B #$01                                ; |
    STA.W SpriteMisc157C,X                    ; /
CODE_0387CD:
    CPY.B #$00                                ; \ If time until flip == 0...
    BNE +                                     ; |
    LDA.W SpriteMisc157C,X                    ; |    ...update the direction status used by the gfx routine
    STA.W SpriteMisc151C,X                    ; /
  + JSL MarioSprInteract                      ; Check for mario/Mega Mole contact
    BCC Return03882A                          ; (Carry set = contact)
    JSR SubVertPosBnk3
    LDA.B _E
    CMP.B #$D8
    BPL MegaMoleContact
    LDA.B PlayerYSpeed+1
    BMI Return03882A
    LDA.B #$01                                ; \ Set "on sprite" flag
    STA.W StandOnSolidSprite                  ; /
    LDA.B #$06                                ; \ Set riding Mega Mole
    STA.W SpriteMisc154C,X                    ; /
    STZ.B PlayerYSpeed+1                      ; Y speed = 0
    LDA.B #$D6                                ; \
    LDY.W PlayerRidingYoshi                   ; | Mario's y position += C6 or D6 depending if on yoshi
    BEQ +                                     ; |
    LDA.B #$C6                                ; |
  + CLC                                       ; |
    ADC.B SpriteYPosLow,X                     ; |
    STA.B PlayerYPosNext                      ; |
    LDA.W SpriteYPosHigh,X                    ; |
    ADC.B #$FF                                ; |
    STA.B PlayerYPosNext+1                    ; /
    LDY.B #$00                                ; \
    LDA.W SpriteXMovement                     ; | $1491 == 01 or FF, depending on direction
    BPL +                                     ; | Set mario's new x position
    DEY                                       ; |
  + CLC                                       ; |
    ADC.B PlayerXPosNext                      ; |
    STA.B PlayerXPosNext                      ; |
    TYA                                       ; |
    ADC.B PlayerXPosNext+1                    ; |
    STA.B PlayerXPosNext+1                    ;  /
    RTS

MegaMoleContact:
    LDA.W SpriteMisc154C,X                    ; \ If riding Mega Mole...
    ORA.W SpriteOnYoshiTongue,X               ; |   ...or Mega Mole being eaten...
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
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc151C,X                    ; \ $02 = direction
    STA.B _2                                  ; /
    LDA.B EffFrame                            ; \
    LSR A                                     ; |
    LSR A                                     ; |
    NOP                                       ; |
    CLC                                       ; |
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
    INX                                       ; /
  + LDA.B _0                                  ; \ Tile x position = sprite x location ($00) + tile displacement
    CLC                                       ; |
    ADC.W MegaMoleTileDispX,X                 ; |
    STA.W OAMTileXPos+$100,Y                  ; /
    PLX                                       ; \ Pull, X = index to frame end
    LDA.B _1                                  ; |
    CLC                                       ; | Tile y position = sprite y location ($01) + tile displacement
    ADC.W MegaMoleTileDispY,X                 ; |
    STA.W OAMTileYPos+$100,Y                  ; /
    PHX                                       ; \ Set current tile
    TXA                                       ; | X = index of frame start + current tile
    CLC                                       ; |
    ADC.B _3                                  ; |
    TAX                                       ; |
    LDA.W MegaMoleTiles,X                     ; |
    STA.W OAMTileNo+$100,Y                    ; /
    LDA.B #$01                                ; Tile properties xyppccct, format
    LDX.B _2                                  ; \ If direction == 0...
    BNE +                                     ; |
    ORA.B #$40                                ; /    ...flip tile
  + ORA.B SpriteProperties                    ; Add in tile priority of level
    STA.W OAMTileAttr+$100,Y                  ; Store tile properties
    PLX                                       ; \ Pull, current tile
    INY                                       ; | Increase index to sprite tile map ($300)...
    INY                                       ; |    ...we wrote 4 bytes
    INY                                       ; |    ...so increment 4 times
    INY                                       ; |
    DEX                                       ; | Go to next tile of frame and loop
    BPL MegaMoleGfxLoopSt                     ; /
    PLX                                       ; Pull, X = sprite index
    LDY.B #$02                                ; \ Will write 02 to $0460 (all 16x16 tiles)
    LDA.B #$03                                ; | A = number of tiles drawn - 1
    JSL FinishOAMWrite                        ; / Don't draw if offscreen
    RTS


BatTiles:
    db $AE,$C0,$E8

Swooper:
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    LDA.W SpriteMisc1602,X
    TAX
    LDA.W BatTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    LDA.W SpriteStatus,X
    CMP.B #$08
    BEQ +
    JMP CODE_0384EC

  + LDA.B SpriteLock
    BNE +
    JSR SubOffscreen0Bnk3
    JSL SprSpr_MarioSprRts
    JSL UpdateXPosNoGvtyW
    JSL UpdateYPosNoGvtyW
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_0388E4
    dw CODE_038905
    dw CODE_038936

  + RTS


DATA_0388E0:
    db $10,$F0

DATA_0388E2:
    db $01,$FF

CODE_0388E4:
    LDA.W SpriteOffscreenX,X
    BNE +
    JSR SubHorzPosBnk3
    LDA.B _F
    CLC
    ADC.B #$50
    CMP.B #$A0
    BCS +
    INC.B SpriteTableC2,X
    TYA
    STA.W SpriteMisc157C,X
    LDA.B #$20
    STA.B SpriteYSpeed,X
    LDA.B #!SFX_SWOOPER                       ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + RTS

CODE_038905:
    LDA.B TrueFrame
    AND.B #$03
    BNE CODE_038915
    LDA.B SpriteYSpeed,X
    BEQ CODE_038915
    DEC.B SpriteYSpeed,X
    BNE CODE_038915
    INC.B SpriteTableC2,X
CODE_038915:
    LDA.B TrueFrame
    AND.B #$03
    BNE +
    LDY.W SpriteMisc157C,X
    LDA.B SpriteXSpeed,X
    CMP.W DATA_0388E0,Y
    BEQ +
    CLC
    ADC.W DATA_0388E2,Y
    STA.B SpriteXSpeed,X
  + LDA.B EffFrame
    AND.B #$04
    LSR A
    LSR A
    INC A
    STA.W SpriteMisc1602,X
    RTS

CODE_038936:
    LDA.B TrueFrame
    AND.B #$01
    BNE +
    LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W BlurpAccelY,Y
    STA.B SpriteYSpeed,X
    CMP.W BlurpMaxSpeedY,Y
    BNE +
    INC.W SpriteMisc151C,X
  + BRA CODE_038915


DATA_038954:
    db $20,$E0

DATA_038956:
    db $02,$FE

SlidingKoopa:
    LDA.B #$00
    LDY.B SpriteXSpeed,X
    BEQ CODE_038964
    BPL +
    INC A
  + STA.W SpriteMisc157C,X
CODE_038964:
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc1558,X
    CMP.B #$01
    BNE +
    LDA.W SpriteMisc157C,X
    PHA
    LDA.B #$02
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    PLA
    STA.W SpriteMisc157C,X
    SEC
  + LDA.B #$86
    BCC +
    LDA.B #$E0
  + STA.W OAMTileNo+$100,Y
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return0389FE
    JSR SubOffscreen0Bnk3
    JSL SprSpr_MarioSprRts
    LDA.B SpriteLock
    ORA.W SpriteMisc1540,X
    ORA.W SpriteMisc1558,X
    BNE Return0389FE
    JSL UpdateSpritePos
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ Return0389FE                          ; /
    JSR CODE_0389FF
    LDY.B #$00
    LDA.B SpriteXSpeed,X
    BEQ CODE_0389CC
    BPL +
    EOR.B #$FF
    INC A
  + STA.B _0
    LDA.W SpriteSlope,X
    BEQ CODE_0389CC
    LDY.B _0
    EOR.B SpriteXSpeed,X
    BPL CODE_0389CC
    LDY.B #$D0
CODE_0389CC:
    STY.B SpriteYSpeed,X
    LDA.B TrueFrame
    AND.B #$01
    BNE Return0389FE
    LDA.W SpriteSlope,X
    BNE CODE_0389EC
    LDA.B SpriteXSpeed,X
    BNE +
    LDA.B #$20
    STA.W SpriteMisc1558,X
    RTS

  + BPL +
    INC.B SpriteXSpeed,X
    INC.B SpriteXSpeed,X
  + DEC.B SpriteXSpeed,X
    RTS

CODE_0389EC:
    ASL A
    ROL A
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X
    CMP.W DATA_038954,Y
    BEQ Return0389FE
    CLC
    ADC.W DATA_038956,Y
    STA.B SpriteXSpeed,X
Return0389FE:
    RTS

CODE_0389FF:
    LDA.B SpriteXSpeed,X
    BEQ Return038A20
    LDA.B TrueFrame
    AND.B #$03
    BNE Return038A20
    LDA.B #$04
    STA.B _0
    LDA.B #$0A
    STA.B _1
    JSR IsSprOffScreenBnk3
    BNE Return038A20
    LDY.B #$03
CODE_038A18:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_038A21
    DEY
    BPL CODE_038A18
Return038A20:
    RTS

CODE_038A21:
    LDA.B #$03
    STA.W SmokeSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B _0
    STA.W SmokeSpriteXPos,Y
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B _1
    STA.W SmokeSpriteYPos,Y
    LDA.B #$13
    STA.W SmokeSpriteTimer,Y
    RTS

BowserStatue:
    JSR BowserStatueGfx
    LDA.B SpriteLock
    BNE +
    JSR SubOffscreen0Bnk3
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_038A57
    dw CODE_038A54
    dw CODE_038A69
    dw CODE_038A54

CODE_038A54:
    JSR CODE_038ACB
CODE_038A57:
    JSL InvisBlkMainRt
    JSL UpdateSpritePos
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + RTS

CODE_038A69:
    ASL.W SpriteTweakerD,X
    LSR.W SpriteTweakerD,X
    JSL MarioSprInteract
    STZ.W SpriteMisc1602,X
    LDA.B SpriteYSpeed,X
    CMP.B #$10
    BPL +
    INC.W SpriteMisc1602,X
  + JSL UpdateSpritePos
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    LDA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.B SpriteXSpeed,X
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ Return038AC6                          ; /
    LDA.B #$10
    STA.B SpriteYSpeed,X
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    LDA.W SpriteMisc1540,X
    BEQ CODE_038AC1
    DEC A
    BNE Return038AC6
    LDA.B #$C0
    STA.B SpriteYSpeed,X
    JSR SubHorzPosBnk3
    TYA
    STA.W SpriteMisc157C,X
    LDA.W BwsrStatueSpeed,Y
    STA.B SpriteXSpeed,X
    RTS


BwsrStatueSpeed:
    db $10,$F0

CODE_038AC1:
    LDA.B #$30
    STA.W SpriteMisc1540,X
Return038AC6:
    RTS


BwserFireDispXLo:
    db $10,$F0

BwserFireDispXHi:
    db $00,$FF

CODE_038ACB:
    TXA
    ASL A
    ASL A
    ADC.B TrueFrame
    AND.B #$7F
    BNE +
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BMI +                                     ; /
    LDA.B #!SFX_FIRESPIT                      ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$B3                                ; \ Sprite = Bowser Statue Fireball
    STA.W SpriteNumber,Y                      ; /
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    PHX
    LDA.W SpriteMisc157C,X
    TAX
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
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,Y
    LDA.W SpriteMisc157C,X
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
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc1602,X
    STA.B _4
    EOR.B #$01
    DEC A
    STA.B _3
    LDA.W SpriteOBJAttribute,X
    STA.B _5
    LDA.W SpriteMisc157C,X
    STA.B _2
    PHX
    LDX.B #$02
CODE_038B57:
    PHX
    LDA.B _2
    BNE +
    INX
    INX
    INX
  + LDA.B _0
    CLC
    ADC.W BwsrStatueDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.W BwsrStatueGfxProp,X
    ORA.B _5
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLX
    LDA.B _1
    CLC
    ADC.W BwsrStatueDispY,X
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.B _4
    BEQ +
    INX
    INX
    INX
  + LDA.W BwsrStatueTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W BwsrStatueTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    DEX
    CPX.B _3
    BNE CODE_038B57
    PLX
    LDY.B #$FF
    LDA.B #$02
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

  - RTS

CarrotTopLift:
    JSR CarrotTopLiftGfx
    LDA.B SpriteLock
    BNE -
    JSR SubOffscreen0Bnk3
    LDA.W SpriteMisc1540,X
    BNE +
    INC.B SpriteTableC2,X
    LDA.B #$80
    STA.W SpriteMisc1540,X
  + LDA.B SpriteTableC2,X
    AND.B #$03
    TAY
    LDA.W DATA_038C2A,Y
    STA.B SpriteXSpeed,X
    LDA.B SpriteXSpeed,X
    LDY.B SpriteNumber,X
    CPY.B #$B8
    BEQ +
    EOR.B #$FF
    INC A
  + STA.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW
    LDA.B SpriteXPosLow,X
    STA.W SpriteMisc151C,X
    JSL UpdateXPosNoGvtyW
    JSR CODE_038CE4
    JSL GetSpriteClippingA
    JSL CheckForContact
    BCC Return038CE3
    LDA.B PlayerYSpeed+1
    BMI Return038CE3
    LDA.B PlayerXPosNext
    SEC
    SBC.W SpriteMisc151C,X
    CLC
    ADC.B #$1C
    LDY.B SpriteNumber,X
    CPY.B #$B8
    BNE +
    CLC
    ADC.B #$38
  + TAY
    LDA.W PlayerRidingYoshi
    CMP.B #$01
    LDA.B #$20
    BCC +
    LDA.B #$30
  + CLC
    ADC.B PlayerYPosNext
    STA.B _0
    LDA.B SpriteYPosLow,X
    CLC
    ADC.W DATA_038BAA,Y
    CMP.B _0
    BPL Return038CE3
    LDA.W PlayerRidingYoshi
    CMP.B #$01
    LDA.B #$1D
    BCC +
    LDA.B #$2D
  + STA.B _0
    LDA.B SpriteYPosLow,X
    CLC
    ADC.W DATA_038BAA,Y
    PHP
    SEC
    SBC.B _0
    STA.B PlayerYPosNext
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    PLP
    ADC.B #$00
    STA.B PlayerYPosNext+1
    STZ.B PlayerYSpeed+1
    LDA.B #$01
    STA.W StandOnSolidSprite
    LDY.B #$00
    LDA.W SpriteXMovement
    BPL +
    DEY
  + CLC
    ADC.B PlayerXPosNext
    STA.B PlayerXPosNext
    TYA
    ADC.B PlayerXPosNext+1
    STA.B PlayerXPosNext+1
Return038CE3:
    RTS

CODE_038CE4:
    LDA.B PlayerXPosNext
    CLC
    ADC.B #$04
    STA.B _0
    LDA.B PlayerXPosNext+1
    ADC.B #$00
    STA.B _8
    LDA.B #$08
    STA.B _2
    STA.B _3
    LDA.B #$20
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$30
  + CLC
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
    JSR GetDrawInfoBnk3
    PHX
    LDA.B SpriteNumber,X
    CMP.B #$B8
    LDX.B #$02
    STX.B _2
    BCC CODE_038D34
    LDX.B #$05
CODE_038D34:
    LDA.B _0
    CLC
    ADC.W DiagPlatDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DiagPlatDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DiagPlatTiles2,X
    STA.W OAMTileNo+$100,Y
    LDA.W DiagPlatGfxProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    DEC.B _2
    BPL CODE_038D34
    PLX
    LDY.B #$02
    TYA
    JSL FinishOAMWrite
    RTS


DATA_038D66:
    db $00,$04,$07,$08,$08,$07,$04,$00
    db $00

InfoBox:
    JSL InvisBlkMainRt
    JSR SubOffscreen0Bnk3
    LDA.W SpriteMisc1558,X
    CMP.B #$01
    BNE +
    LDA.B #!SFX_MESSAGE                       ; \ Play sound effect
    STA.W SPCIO3                              ; /
    STZ.W SpriteMisc1558,X
    STZ.B SpriteTableC2,X
    LDA.B SpriteXPosLow,X
    LSR A
    LSR A
    LSR A
    LSR A
    AND.B #$01
    INC A
    STA.W MessageBoxTrigger
  + LDA.W SpriteMisc1558,X
    LSR A
    TAY
    LDA.B Layer1YPos
    PHA
    CLC
    ADC.W DATA_038D66,Y
    STA.B Layer1YPos
    LDA.B Layer1YPos+1
    PHA
    ADC.B #$00
    STA.B Layer1YPos+1
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$C0
    STA.W OAMTileNo+$100,Y
    PLA
    STA.B Layer1YPos+1
    PLA
    STA.B Layer1YPos
    RTS

TimedLift:
    JSR TimedPlatformGfx
    LDA.B SpriteLock
    BNE Return038DEF
    JSR SubOffscreen0Bnk3
    LDA.B TrueFrame
    AND.B #$00
    BNE +
    LDA.B SpriteTableC2,X
    BEQ +
    LDA.W SpriteMisc1570,X
    BEQ +
    DEC.W SpriteMisc1570,X
  + LDA.W SpriteMisc1570,X
    BEQ CODE_038DF0
    JSL UpdateXPosNoGvtyW
    STA.W SpriteMisc1528,X
    JSL InvisBlkMainRt
    BCC Return038DEF
    LDA.B #$10
    STA.B SpriteXSpeed,X
    STA.B SpriteTableC2,X
Return038DEF:
    RTS

CODE_038DF0:
    JSL UpdateSpritePos
    LDA.W SpriteXMovement
    STA.W SpriteMisc1528,X
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
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc1570,X
    PHX
    PHA
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    TAX
    LDA.W TimedPlatNumTiles,X
    STA.B _2
    LDX.B #$02
    PLA
    CMP.B #$08
    BCS CODE_038E2E
    DEX
CODE_038E2E:
    LDA.B _0
    CLC
    ADC.W TimedPlatDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W TimedPlatDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W TimedPlatTiles,X
    CPX.B #$02
    BNE +
    LDA.B _2
  + STA.W OAMTileNo+$100,Y
    LDA.W TimedPlatGfxProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W TimedPlatTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_038E2E
    PLX
    LDY.B #$FF
    LDA.B #$02
    JSL FinishOAMWrite
    RTS


GreyMoveBlkSpeed:
    db $00,$F0,$00,$10

GreyMoveBlkTiming:
    db $40,$50,$40,$50

GreyCastleBlock:
    JSR CODE_038EB4
    LDA.B SpriteLock
    BNE Return038EA7
    LDA.W SpriteMisc1540,X
    BNE +
    INC.B SpriteTableC2,X
    LDA.B SpriteTableC2,X
    AND.B #$03
    TAY
    LDA.W GreyMoveBlkTiming,Y
    STA.W SpriteMisc1540,X
  + LDA.B SpriteTableC2,X
    AND.B #$03
    TAY
    LDA.W GreyMoveBlkSpeed,Y
    STA.B SpriteXSpeed,X
    JSL UpdateXPosNoGvtyW
    STA.W SpriteMisc1528,X
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
    JSR GetDrawInfoBnk3
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC
    ADC.W GreyMoveBlkDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W GreyMoveBlkDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W GreyMoveBlkTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.B #$03
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$03
    JSL FinishOAMWrite
    RTS


StatueFireSpeed:
    db $10,$F0

StatueFireball:
    JSR StatueFireballGfx
    LDA.B SpriteLock
    BNE +
    JSR SubOffscreen0Bnk3
    JSL MarioSprInteract
    LDY.W SpriteMisc157C,X
    LDA.W StatueFireSpeed,Y
    STA.B SpriteXSpeed,X
    JSL UpdateXPosNoGvtyW
  + RTS


StatueFireDispX:
    db $08,$00,$00,$08

StatueFireTiles:
    db $32,$50,$33,$34,$32,$50,$33,$34
StatueFireGfxProp:
    db $09,$09,$09,$09,$89,$89,$89,$89

StatueFireballGfx:
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc157C,X
    ASL A
    STA.B _2
    LDA.B EffFrame
    LSR A
    AND.B #$03
    ASL A
    STA.B _3
    PHX
    LDX.B #$01
CODE_038F2F:
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    PHX
    TXA
    ORA.B _2
    TAX
    LDA.B _0
    CLC
    ADC.W StatueFireDispX,X
    STA.W OAMTileXPos+$100,Y
    PLA
    PHA
    ORA.B _3
    TAX
    LDA.W StatueFireTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W StatueFireGfxProp,X
    LDX.B _2
    BNE +
    EOR.B #$40
  + ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLX
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_038F2F
    PLX
    LDY.B #$00
    LDA.B #$01
    JSL FinishOAMWrite
    RTS


BooStreamFrntTiles:
    db $88,$8C,$8E,$A8,$AA,$AE,$88,$8C

ReflectingFireball:
    JSR CODE_038FF2
    BRA CODE_038FA4

BooStream:
    LDA.B #$00
    LDY.B SpriteXSpeed,X
    BPL +
    INC A
  + STA.W SpriteMisc157C,X
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    LSR A
    AND.B #$01
    STA.B _0
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
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return038FF1
    LDA.B SpriteLock
    BNE Return038FF1
    TXA
    EOR.B EffFrame
    AND.B #$07
    ORA.W SpriteOffscreenVert,X
    BNE +
    LDA.B SpriteNumber,X
    CMP.B #$B0
    BNE +
    JSR CODE_039020
  + JSL UpdateYPosNoGvtyW
    JSL UpdateXPosNoGvtyW
    JSL CODE_019138
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    LDA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.B SpriteXSpeed,X
  + LDA.W SpriteBlockedDirs,X
    AND.B #$0C
    BEQ +
    LDA.B SpriteYSpeed,X
    EOR.B #$FF
    INC A
    STA.B SpriteYSpeed,X
  + JSL MarioSprInteract
    JSR SubOffscreen0Bnk3
Return038FF1:
    RTS

CODE_038FF2:
    JSL GenericSprGfxRt2
    LDA.B EffFrame
    LSR A
    LSR A
    LDA.B #$04
    BCC +
    ASL A
  + LDY.B SpriteXSpeed,X
    BPL +
    EOR.B #$40
  + LDY.B SpriteYSpeed,X
    BMI +
    EOR.B #$80
  + STA.B _0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$AC
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$100,Y
    AND.B #$31
    ORA.B _0
    STA.W OAMTileAttr+$100,Y
    RTS

CODE_039020:
    LDY.B #$0B
CODE_039022:
    LDA.W MinExtSpriteNumber,Y
    BEQ CODE_039037
    DEY
    BPL CODE_039022
    DEC.W MinExtSpriteSlotIdx
    BPL +
    LDA.B #$0B
    STA.W MinExtSpriteSlotIdx
  + LDY.W MinExtSpriteSlotIdx
CODE_039037:
    LDA.B #$0A
    STA.W MinExtSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W MinExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W MinExtSpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W MinExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W MinExtSpriteYPosHigh,Y
    LDA.B #$30
    STA.W MinExtSpriteTimer,Y
    LDA.B SpriteXSpeed,X
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
    JSR FishinBooGfx
    LDA.B SpriteLock
    BNE Return0390EA
    JSL MarioSprInteract
    JSR SubHorzPosBnk3
    STZ.W SpriteMisc1602,X
    LDA.W SpriteMisc15AC,X
    BEQ +
    INC.W SpriteMisc1602,X
    CMP.B #$10
    BNE +
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
    LDA.B #$20
    STA.W SpriteMisc15AC,X
  + LDA.W SpriteWillAppear
    BEQ +
    TYA
    EOR.B #$01
    TAY
  + LDA.B SpriteXSpeed,X                      ; \ If not at max X speed, accelerate
    CMP.W FishinBooMaxSpeedX,Y                ; |
    BEQ +                                     ; |
    CLC                                       ; |
    ADC.W FishinBooAccelX,Y                   ; |
    STA.B SpriteXSpeed,X                      ; /
  + LDA.B TrueFrame
    AND.B #$01
    BNE +
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
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
    ASL A
    CLC
    ADC.B SpriteXSpeed,X
    STA.B SpriteXSpeed,X
  + JSL UpdateXPosNoGvtyW
    PLA
    STA.B SpriteXSpeed,X
    JSL UpdateYPosNoGvtyW
    JSR CODE_0390F3
Return0390EA:
    RTS


DATA_0390EB:
    db $1A,$14,$EE,$F8

DATA_0390EF:
    db $00,$00,$FF,$FF

CODE_0390F3:
    LDA.W SpriteMisc157C,X
    ASL A
    ADC.W SpriteMisc1602,X
    TAY
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_0390EB,Y
    STA.B _4
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_0390EF,Y
    STA.B _A
    LDA.B #$04
    STA.B _6
    STA.B _7
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$47
    STA.B _5
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _B
    JSL GetMarioClipping
    JSL CheckForContact
    BCC +
    JSL HurtMario
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
    JSR GetDrawInfoBnk3
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
    LDA.B #!SFX_BONK                          ; \
    STA.W SPCIO0                              ; / Play sound effect
    BRA DrawReznor

HitPlatSide:
    JSR SubHorzPosBnk3                        ; \ Set mario to bounce back
    LDA.W ReboundSpeedX,Y                     ; | (hit side of platform?)
    STA.B PlayerXSpeed+1                      ; |
    BRA DrawReznor                            ; /

HitReznor:
    JSL HurtMario                             ; Hurt Mario
DrawReznor:
    STZ.W SpriteMisc1602,X                    ; Set normal image
    LDA.W SpriteMisc157C,X
    PHA
    LDY.W SpriteMisc15AC,X
    BEQ ReznorNoTurning
    CPY.B #$05
    BCC +
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + LDA.B #$02                                ; \ Set turning image
    STA.W SpriteMisc1602,X                    ; /
ReznorNoTurning:
    LDA.W SpriteMisc1558,X                    ; \ Shoot fire if "time to show firing image" == 20
    BEQ ReznorNoFiring                        ; |
    CMP.B #$20                                ; | (shows image for 20 frames after the fireball is shot)
    BNE +                                     ; |
    JSR ReznorFireRt                          ; /
  + LDA.B #$01                                ; \ Set firing image
    STA.W SpriteMisc1602,X                    ; /
ReznorNoFiring:
    JSR ReznorGfxRt                           ; Draw Reznor
    PLA
    STA.W SpriteMisc157C,X
    LDA.B SpriteLock                          ; \ If sprites locked, or mario already killed the Reznor on the platform, return
    ORA.W SpriteMisc151C,X                    ; |
    BNE +                                     ; /
    LDA.W SpriteMisc1564,X                    ; \ If time to bounce platform != 0C, return
    CMP.B #$0C                                ; | (causes delay between start of boucing platform and killing Reznor)
    BNE +                                     ; /
    LDA.B #!SFX_KICK                          ; \
    STA.W SPCIO0                              ; / Play sound effect
    STZ.W SpriteMisc1558,X                    ; Prevent from throwing fire after death
    INC.W SpriteMisc151C,X                    ; Record a hit on Reznor
    JSL FindFreeSprSlot                       ; \ Load Y with a free sprite index for dead Reznor
    BMI +                                     ; / Return if no free index
    LDA.B #$02                                ; \ Set status to being killed
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$A9                                ; \ Sprite to use for dead Reznor
    STA.W SpriteNumber,Y                      ; /
    LDA.B SpriteXPosLow,X                     ; \ Transfer x position to dead Reznor
    STA.W SpriteXPosLow,Y                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    STA.W SpriteXPosHigh,Y                    ; /
    LDA.B SpriteYPosLow,X                     ; \ Transfer y position to dead Reznor
    STA.W SpriteYPosLow,Y                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    STA.W SpriteYPosHigh,Y                    ; /
    PHX                                       ; \
    TYX                                       ; | Before: X must have index of sprite being generated
    JSL InitSpriteTables                      ; /  Routine clears all old sprite values and loads in new values for the 6 main sprite tables
    LDA.B #$C0                                ; \ Set y speed for Reznor's bounce off the platform
    STA.B SpriteYSpeed,X                      ; /
    PLX                                       ; pull, X = sprite index
  + RTS

ReznorFireRt:
    LDY.B #$07                                ; \ find a free extended sprite slot, return if all full
CODE_039AFA:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ FoundRznrFireSlot                     ; |
    DEY                                       ; |
    BPL CODE_039AFA                           ; |
    RTS                                       ; / Return if no free slots

FoundRznrFireSlot:
    LDA.B #!SFX_MAGIC                         ; \
    STA.W SPCIO0                              ; / Play sound effect
    LDA.B #$02                                ; \ Extended sprite = Reznor fireball
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X
    PHA
    SEC
    SBC.B #$08
    STA.W ExtSpriteXPosLow,Y
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    SBC.B #$00
    STA.W ExtSpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    PHA
    SEC
    SBC.B #$14
    STA.B SpriteYPosLow,X
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
    PLA
    STA.B SpriteYPosLow,X
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
    LDA.W SpriteMisc151C,X                    ; \ if the reznor is dead, only draw the platform
    BNE DrawReznorPlats                       ; /
    JSR GetDrawInfoBnk3                       ; after: Y = index to sprite tile map, $00 = sprite x, $01 = sprite y
    LDA.W SpriteMisc1602,X                    ; \ $03 = index to frame start (frame to show * 4 tiles per frame)
    ASL A                                     ; |
    ASL A                                     ; |
    STA.B _3                                  ; /
    LDA.W SpriteMisc157C,X                    ; \ $02 = direction index
    ASL A                                     ; |
    ASL A                                     ; |
    STA.B _2                                  ; /
    PHX
    LDX.B #$03
RznrGfxLoopStart:
    PHX
    LDA.B _3
    CMP.B #$08
    BCS +
    TXA
    ORA.B _2
    TAX
  + LDA.B _0
    CLC
    ADC.W ReznorTileDispX,X
    STA.W OAMTileXPos+$100,Y
    PLX
    LDA.B _1
    CLC
    ADC.W ReznorTileDispY,X
    STA.W OAMTileYPos+$100,Y
    PHX
    TXA
    ORA.B _3
    TAX
    LDA.W ReznorTiles,X                       ; \ set tile
    STA.W OAMTileNo+$100,Y                    ; /
    LDA.W ReznorPal,X                         ; \ set palette/properties
    CPX.B #$08                                ; | if turning, don't flip
    BCS +                                     ; |
    LDX.B _2                                  ; | if direction = 0, don't flip
    BNE +                                     ; |
    EOR.B #$40                                ; |
  + STA.W OAMTileAttr+$100,Y                  ; /
    PLX                                       ; \ pull, X = current tile of the frame we're drawing
    INY                                       ; | Increase index to sprite tile map ($300)...
    INY                                       ; |    ...we wrote 4 bytes...
    INY                                       ; |    ...so increment 4 times
    INY                                       ; |
    DEX                                       ; | Go to next tile of frame and loop
    BPL RznrGfxLoopStart                      ; /
    PLX                                       ; \
    LDY.B #$02                                ; | Y = 02 (All 16x16 tiles)
    LDA.B #$03                                ; | A = number of tiles drawn - 1
    JSL FinishOAMWrite                        ; / Don't draw if offscreen
    LDA.W SpriteStatus,X
    CMP.B #$02
    BEQ +
DrawReznorPlats:
    JSR ReznorPlatGfxRt
  + RTS


ReznorPlatDispY:
    db $00,$03,$04,$05,$05,$04,$03,$00

ReznorPlatGfxRt:
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$10
    STA.W SpriteOAMIndex,X
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc1564,X
    LSR A
    PHY
    TAY
    LDA.W ReznorPlatDispY,Y
    STA.B _2
    PLY
    LDA.B _0
    STA.W OAMTileXPos+$104,Y
    SEC
    SBC.B #$10
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    SEC
    SBC.B _2
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    LDA.B #$4E                                ; \ Tile of reznor platform...
    STA.W OAMTileNo+$100,Y                    ; | ...store left side
    STA.W OAMTileNo+$104,Y                    ; /  ...store right side
    LDA.B #$33                                ; \ Palette of reznor platform...
    STA.W OAMTileAttr+$100,Y                  ; |
    ORA.B #$40                                ; | ...flip right side
    STA.W OAMTileAttr+$104,Y                  ; /
    LDY.B #$02                                ; \
    LDA.B #$01                                ; | A = number of tiles drawn - 1
    JSL FinishOAMWrite                        ; / Don't draw if offscreen
    RTS

InvisBlk_DinosMain:
    LDA.B SpriteNumber,X                      ; \ Branch if sprite isn't "Invisible solid block"
    CMP.B #$6D                                ; |
    BNE +                                     ; /
    JSL InvisBlkMainRt                        ; \ Call "Invisible solid block" routine
    RTL

  + PHB
    PHK
    PLB
    JSR DinoMainSubRt
    PLB
    RTL

DinoMainSubRt:
    JSR DinoGfxRt
    LDA.B SpriteLock
    BNE Return039CA3
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return039CA3
    JSR SubOffscreen0Bnk3
    JSL MarioSprInteract
    JSL UpdateSpritePos
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
    LDA.B SpriteYSpeed,X
    BMI CODE_039C89
    STZ.B SpriteTableC2,X
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
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
    CLC
    ADC.W DATA_039C6E,Y
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_039C71,Y
    STA.W SpriteXPosHigh,X
Return039CA3:
    RTS


DinoSpeed:
    db $08,$F8,$10,$F0

CODE_039CA8:
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ CODE_039C89                           ; /
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B SpriteNumber,X
    CMP.B #$6E
    BEQ +
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
    ADC.B EffFrame
    AND.B #$3F
    BNE +
    JSR SubHorzPosBnk3                        ; \ If not facing mario, change directions
    TYA                                       ; |
    STA.W SpriteMisc157C,X                    ; /
  + LDA.B #$10
    STA.B SpriteYSpeed,X
    LDY.W SpriteMisc157C,X                    ; \ Set x speed for rhino based on direction and sprite number
    LDA.B SpriteNumber,X                      ; |
    CMP.B #$6E                                ; |
    BEQ +                                     ; |
    INY                                       ; |
    INY                                       ; |
  + LDA.W DinoSpeed,Y                         ; |
    STA.B SpriteXSpeed,X                      ; /
    JSR DinoSetGfxFrame
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    LDA.B #$C0
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
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    LDA.W SpriteMisc1540,X
    BNE +
    STZ.B SpriteTableC2,X
    LDA.B #$40
    STA.W SpriteMisc1540,X
    LDA.B #$00
  + CMP.B #$C0
    BNE +
    LDY.B #!SFX_FIRESPIT                      ; \ Play sound effect
    STY.W SPCIO3                              ; /
  + LSR A
    LSR A
    LSR A
    LDY.B SpriteTableC2,X
    CPY.B #$02
    BNE +
    CLC
    ADC.B #$20
  + TAY
    LDA.W DinoFlameTable,Y
    PHA
    AND.B #$0F
    STA.W SpriteMisc1602,X
    PLA
    LSR A
    LSR A
    LSR A
    LSR A
    STA.W SpriteMisc151C,X
    BNE +
    LDA.B SpriteNumber,X
    CMP.B #$6E
    BEQ +
    TXA
    EOR.B TrueFrame
    AND.B #$03
    BNE +
    JSR DinoFlameClipping
    JSL GetMarioClipping
    JSL CheckForContact
    BCC +
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario has star
    BNE +                                     ; /
    JSL HurtMario
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
    LDA.W SpriteMisc1602,X
    SEC
    SBC.B #$02
    TAY
    LDA.W SpriteMisc157C,X
    BNE +
    INY
    INY
  + LDA.B SpriteXPosLow,X
    CLC
    ADC.W DinoFlame1,Y
    STA.B _4
    LDA.W SpriteXPosHigh,X
    ADC.W DinoFlame2,Y
    STA.B _A
    LDA.W DinoFlame3,Y
    STA.B _6
    LDA.B SpriteYPosLow,X
    CLC
    ADC.W DinoFlame4,Y
    STA.B _5
    LDA.W SpriteYPosHigh,X
    ADC.W DinoFlame5,Y
    STA.B _B
    LDA.W DinoFlame6,Y
    STA.B _7
    RTS

DinoSetGfxFrame:
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    AND.B #$08
    LSR A
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
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc157C,X
    STA.B _2
    LDA.W SpriteMisc1602,X
    STA.B _4
    LDA.B SpriteNumber,X
    CMP.B #$6F
    BEQ CODE_039EA9
    PHX
    LDX.B #$03
CODE_039E5F:
    STX.B _F
    LDA.B _2
    CMP.B #$01
    BCS +
    TXA
    CLC
    ADC.B #$04
    TAX
  + %LorW_X(LDA,DinoRhinoGfxProp)
    STA.W OAMTileAttr+$100,Y
    %LorW_X(LDA,DinoRhinoTileDispX)
    CLC
    ADC.B _0
    STA.W OAMTileXPos+$100,Y
    LDA.B _4
    CMP.B #$01
    LDX.B _F
    %LorW_X(LDA,DinoRhinoTileDispY)
    ADC.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.B _4
    ASL A
    ASL A
    ADC.B _F
    TAX
    %LorW_X(LDA,DinoRhinoTiles)
    STA.W OAMTileNo+$100,Y
    INY
    INY
    INY
    INY
    LDX.B _F
    DEX
    BPL CODE_039E5F
    PLX
    LDA.B #$03
    LDY.B #$02
    JSL FinishOAMWrite
    RTS

CODE_039EA9:
    LDA.W SpriteMisc151C,X
    STA.B _3
    LDA.W SpriteMisc1602,X
    STA.B _4
    PHX
    LDA.B EffFrame
    AND.B #$02
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    LDX.B _4
    CPX.B #$03
    BEQ +
    ASL A
  + STA.B _5
    LDX.B #$04
CODE_039EC8:
    STX.B _6
    LDA.B _4
    CMP.B #$03
    BNE +
    TXA
    CLC
    ADC.B #$05
    TAX
  + PHX
    LDA.W DinoTorchTileDispX,X
    LDX.B _2
    BNE +
    EOR.B #$FF
    INC A
  + PLX
    CLC
    ADC.B _0
    STA.W OAMTileXPos+$100,Y
    LDA.W DinoTorchTileDispY,X
    CLC
    ADC.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.B _6
    CMP.B #$04
    BNE CODE_039EFD
    LDX.B _4
    LDA.W DinoTorchTiles,X
    BRA +

CODE_039EFD:
    LDA.W DinoFlameTiles,X
  + STA.W OAMTileNo+$100,Y
    LDA.B #$00
    LDX.B _2
    BNE +
    ORA.B #$40
  + LDX.B _6
    CPX.B #$04
    BEQ +
    EOR.B _5
  + ORA.W DinoTorchGfxProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    CPX.B _3
    BPL CODE_039EC8
    PLX
    LDY.W SpriteMisc151C,X
    LDA.W DinoTilesWritten,Y
    LDY.B #$02
    JSL FinishOAMWrite
    RTS


DinoTilesWritten:
    db $04,$03,$02,$01,$00

    RTS

Blargg:
    JSR CODE_03A062
    LDA.B SpriteLock
    BNE +
    JSL MarioSprInteract
    JSR SubOffscreen0Bnk3
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_039F57
    dw CODE_039F8B
    dw CODE_039FA4
    dw CODE_039FC8
    dw CODE_039FEF

  + RTS

CODE_039F57:
    LDA.W SpriteOffscreenX,X
    ORA.W SpriteMisc1540,X
    BNE +
    JSR SubHorzPosBnk3
    LDA.B _F
    CLC
    ADC.B #$70
    CMP.B #$E0
    BCS +
    LDA.B #$E3
    STA.B SpriteYSpeed,X
    LDA.W SpriteXPosHigh,X
    STA.W SpriteMisc151C,X
    LDA.B SpriteXPosLow,X
    STA.W SpriteMisc1528,X
    LDA.W SpriteYPosHigh,X
    STA.W SpriteMisc1534,X
    LDA.B SpriteYPosLow,X
    STA.W SpriteMisc1594,X
    JSR CODE_039FC0
    INC.B SpriteTableC2,X
  + RTS

CODE_039F8B:
    LDA.B SpriteYSpeed,X
    CMP.B #$10
    BMI +
    LDA.B #$50
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    RTS

  + JSL UpdateYPosNoGvtyW
    INC.B SpriteYSpeed,X
    INC.B SpriteYSpeed,X
    RTS

CODE_039FA4:
    LDA.W SpriteMisc1540,X
    BNE +
    INC.B SpriteTableC2,X
    LDA.B #$0A
    STA.W SpriteMisc1540,X
    RTS

  + CMP.B #$20
    BCC CODE_039FC0
    AND.B #$1F
    BNE Return039FC7
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    BRA +

CODE_039FC0:
    JSR SubHorzPosBnk3
    TYA
  + STA.W SpriteMisc157C,X
Return039FC7:
    RTS

CODE_039FC8:
    LDA.W SpriteMisc1540,X
    BEQ +
    LDA.B #$20
    STA.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW
    RTS

  + LDA.B #$20
    STA.W SpriteMisc1540,X
    LDY.W SpriteMisc157C,X
    LDA.W DATA_039FED,Y
    STA.B SpriteXSpeed,X
    LDA.B #$E2
    STA.B SpriteYSpeed,X
    JSR CODE_03A045
    INC.B SpriteTableC2,X
    RTS


DATA_039FED:
    db $10,$F0

CODE_039FEF:
    STZ.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    BEQ CODE_03A002
    DEC A
    BNE CODE_03A038
    LDA.B #!SFX_BLARGG                        ; \ Play sound effect
    STA.W SPCIO0                              ; /
    JSR CODE_03A045
CODE_03A002:
    JSL UpdateXPosNoGvtyW
    JSL UpdateYPosNoGvtyW
    LDA.B TrueFrame
    AND.B #$00
    BNE +
    INC.B SpriteYSpeed,X
  + LDA.B SpriteYSpeed,X
    CMP.B #$20
    BMI CODE_03A038
    JSR CODE_03A045
    STZ.B SpriteTableC2,X
    LDA.W SpriteMisc151C,X
    STA.W SpriteXPosHigh,X
    LDA.W SpriteMisc1528,X
    STA.B SpriteXPosLow,X
    LDA.W SpriteMisc1534,X
    STA.W SpriteYPosHigh,X
    LDA.W SpriteMisc1594,X
    STA.B SpriteYPosLow,X
    LDA.B #$40
    STA.W SpriteMisc1540,X
CODE_03A038:
    LDA.B SpriteYSpeed,X
    CLC
    ADC.B #$06
    CMP.B #$0C
    BCS +
    INC.W SpriteMisc1602,X
  + RTS

CODE_03A045:
    LDA.B SpriteYPosLow,X
    PHA
    SEC
    SBC.B #$0C
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    JSL CODE_028528
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    RTS

CODE_03A062:
    JSR GetDrawInfoBnk3
    LDA.B SpriteTableC2,X
    BEQ CODE_03A038
    CMP.B #$04
    BEQ +
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$A0
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$100,Y
    AND.B #$CF
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

  + LDA.W SpriteMisc1602,X
    ASL A
    ASL A
    ADC.W SpriteMisc1602,X
    STA.B _3
    LDA.W SpriteMisc157C,X
    STA.B _2
    PHX
    LDX.B #$04
CODE_03A0AF:
    PHX
    PHX
    LDA.B _1
    CLC
    ADC.W DATA_03A08C,X
    STA.W OAMTileYPos+$100,Y
    LDA.B _2
    BNE +
    TXA
    CLC
    ADC.B #$05
    TAX
  + LDA.B _0
    CLC
    ADC.W DATA_03A082,X
    STA.W OAMTileXPos+$100,Y
    PLA
    CLC
    ADC.B _3
    TAX
    LDA.W BlarggTilemap,X
    STA.W OAMTileNo+$100,Y
    LDX.B _2
    LDA.W DATA_03A09B,X
    STA.W OAMTileAttr+$100,Y
    PLX
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_03A0AF
    PLX
    LDY.B #$02
    LDA.B #$04
    JSL FinishOAMWrite
    RTS

CODE_03A0F1:
    JSL InitSpriteTables
    STZ.W SpriteOffscreenX,X
    LDA.B #$80
    STA.B SpriteYPosLow,X
    LDA.B #$FF
    STA.W SpriteYPosHigh,X
    LDA.B #$D0
    STA.B SpriteXPosLow,X
    LDA.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B #$02
    STA.W SpriteMisc187B,X
    LDA.B #$03
    STA.B SpriteTableC2,X
    JSL CODE_03DD7D
    RTL

Bnk3CallSprMain:
    PHB
    PHK
    PLB
    LDA.B SpriteNumber,X
    CMP.B #$C8
    BNE +
    JSR LightSwitch
    PLB
    RTL

  + CMP.B #$C7
    BNE +
    JSR InvisMushroom
    PLB
    RTL

  + CMP.B #$51
    BNE +
    JSR Ninji
    PLB
    RTL

  + CMP.B #$1B
    BNE +
    JSR Football
    PLB
    RTL

  + CMP.B #$C6
    BNE +
    JSR DarkRoomWithLight
    PLB
    RTL

  + CMP.B #$7A
    BNE +
    JSR Firework
    PLB
    RTL

  + CMP.B #$7C
    BNE +
    JSR PrincessPeach
    PLB
    RTL

  + CMP.B #$C5
    BNE +
    JSR BigBooBoss
    PLB
    RTL

  + CMP.B #$C4
    BNE +
    JSR GreyFallingPlat
    PLB
    RTL

  + CMP.B #$C2
    BNE +
    JSR Blurp
    PLB
    RTL

  + CMP.B #$C3
    BNE +
    JSR PorcuPuffer
    PLB
    RTL

  + CMP.B #$C1
    BNE +
    JSR FlyingTurnBlocks
    PLB
    RTL

  + CMP.B #$C0
    BNE +
    JSR GrayLavaPlatform
    PLB
    RTL

  + CMP.B #$BF
    BNE +
    JSR MegaMole
    PLB
    RTL

  + CMP.B #$BE
    BNE +
    JSR Swooper
    PLB
    RTL

  + CMP.B #$BD
    BNE +
    JSR SlidingKoopa
    PLB
    RTL

  + CMP.B #$BC
    BNE +
    JSR BowserStatue
    PLB
    RTL

  + CMP.B #$B8
    BEQ CODE_03A1BE
    CMP.B #$B7
    BNE +
CODE_03A1BE:
    JSR CarrotTopLift
    PLB
    RTL

  + CMP.B #$B9
    BNE +
    JSR InfoBox
    PLB
    RTL

  + CMP.B #$BA
    BNE +
    JSR TimedLift
    PLB
    RTL

  + CMP.B #$BB
    BNE +
    JSR GreyCastleBlock
    PLB
    RTL

  + CMP.B #$B3
    BNE +
    JSR StatueFireball
    PLB
    RTL

  + LDA.B SpriteNumber,X
    CMP.B #$B2
    BNE +
    JSR FallingSpike
    PLB
    RTL

  + CMP.B #$AE
    BNE +
    JSR FishinBoo
    PLB
    RTL

  + CMP.B #$B6
    BNE +
    JSR ReflectingFireball
    PLB
    RTL

  + CMP.B #$B0
    BNE +
    JSR BooStream
    PLB
    RTL

  + CMP.B #$B1
    BNE +
    JSR CreateEatBlock
    PLB
    RTL

  + CMP.B #$AC
    BEQ CODE_03A21E
    CMP.B #$AD
    BNE +
CODE_03A21E:
    JSR WoodenSpike
    PLB
    RTL

  + CMP.B #$AB
    BNE +
    JSR RexMainRt
    PLB
    RTL

  + CMP.B #$AA
    BNE +
    JSR Fishbone
    PLB
    RTL

  + CMP.B #$A9
    BNE +
    JSR Reznor
    PLB
    RTL

  + CMP.B #$A8
    BNE +
    JSR Blargg
    PLB
    RTL

  + CMP.B #$A1
    BNE +
    JSR BowserBowlingBall
    PLB
    RTL

  + CMP.B #$A2
    BNE +
    JSR MechaKoopa
    PLB
    RTL

  + JSL CODE_03DFCC
    JSR CODE_03A279
    JSR CODE_03B43C
    PLB
    RTL


DATA_03A265:
    db $04,$03,$02,$01,$00,$01,$02,$03
    db $04,$05,$06,$07,$07,$07,$07,$07
    db $07,$07,$07,$07

CODE_03A279:
    LDA.B Mode7XScale
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_03A265,Y
    STA.W BowserPalette
    LDA.W SpriteMisc1570,X
    CLC
    ADC.B #$1E
    ORA.W SpriteMisc157C,X
    STA.W Mode7TileIndex
    LDA.B EffFrame
    LSR A
    AND.B #$03
    STA.W ClownCarPropeller
    LDA.B #$90
    STA.B Mode7CenterX
    LDA.B #$C8
    STA.B Mode7CenterY
    JSL CODE_03DEDF
    LDA.W BowserHurtState
    BEQ +
    JSR CODE_03AF59
  + LDA.W SpriteMisc1564,X
    BEQ +
    JSR CODE_03A3E2
  + LDA.W SpriteMisc1594,X
    BEQ +
    DEC A
    LSR A
    LSR A
    PHA
    LSR A
    TAY
    LDA.W DATA_03A8BE,Y
    STA.B _2
    PLA
    AND.B #$03
    STA.B _3
    JSR CODE_03AA6E
    NOP
  + LDA.B SpriteLock
    BNE Return03A340
    STZ.W SpriteMisc1594,X
    LDA.B #$30
    STA.B SpriteProperties
    LDA.B Mode7XScale
    CMP.B #$20
    BCS +
    STZ.B SpriteProperties
  + JSR CODE_03A661
    LDA.W BowserWaitTimer
    BEQ +
    LDA.B TrueFrame
    AND.B #$03
    BNE +
    DEC.W BowserWaitTimer
  + LDA.B TrueFrame
    AND.B #$7F
    BNE +
    JSL GetRand
    AND.B #$01
    BNE +
    LDA.B #$0C
    STA.W SpriteMisc1558,X
  + JSR CODE_03B078
    LDA.W SpriteMisc151C,X
    CMP.B #$09
    BEQ +
    STZ.W ClownCarImage
    LDA.W SpriteMisc1558,X
    BEQ +
    INC.W ClownCarImage
  + JSR CODE_03A5AD
    JSL UpdateXPosNoGvtyW
    JSL UpdateYPosNoGvtyW
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
    RTS


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
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc1564,X
    DEC A
    LSR A
    STA.B _3
    ASL A
    ASL A
    ASL A
    STA.B _2
    LDA.B #$70
    STA.W SpriteOAMIndex,X
    TAY
    PHX
    LDX.B #$07
  - PHX
    TXA
    ORA.B _2
    TAX
    LDA.B _0
    CLC
    ADC.W DATA_03A341,X
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_03A389,X
    CLC
    ADC.B #$30
    STA.W OAMTileYPos+$100,Y
    LDX.B _3
    LDA.W DATA_03A3D9,X
    STA.W OAMTileNo+$100,Y
    PLX
    LDA.W DATA_03A3D1,X
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$07
    JSL FinishOAMWrite
    RTS


DATA_03A437:
    db $00,$00,$00,$00,$02,$04,$06,$08
    db $0A,$0E

CODE_03A441:
    LDA.W SpriteMisc154C,X
    BNE CODE_03A482
    LDA.W SpriteMisc1540,X
    BNE CODE_03A465
    LDA.B #$0E
    STA.W SpriteMisc1570,X
    LDA.B #con($04,$04,$04,$05,$05)
    STA.B SpriteYSpeed,X
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$10
    BNE +
    LDA.B #$A4
    STA.W SpriteMisc1540,X
  + RTS

CODE_03A465:
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    CMP.B #$01
    BEQ CODE_03A47C
    CMP.B #$40
    BCS +
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_03A437,Y
    STA.W SpriteMisc1570,X
  + RTS

CODE_03A47C:
    LDA.B #con($24,$24,$24,$15,$15)
    STA.W SpriteMisc154C,X
    RTS

CODE_03A482:
    DEC A
    BNE +
    LDA.B #$07
    STA.W SpriteMisc151C,X
    LDA.B #$78
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
    JSR CODE_03A4D2
    JSR CODE_03A4FD
    JSR CODE_03A4ED
    LDA.W SpriteMisc1528,X
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X
    CLC
    ADC.W DATA_03A490,Y
    STA.B SpriteXSpeed,X
    CMP.W DATA_03A492,Y
    BNE +
    INC.W SpriteMisc1528,X
  + LDA.W SpriteMisc1534,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W DATA_03A494,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_03A496,Y
    BNE +
    INC.W SpriteMisc1534,X
  + RTS

CODE_03A4D2:
    LDY.B #$00
    LDA.B TrueFrame
    AND.B #$E0
    BNE +
    LDA.B TrueFrame
    AND.B #$18
    LSR A
    LSR A
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
    LDA.B TrueFrame
    AND.B #$1F
    BNE +
    JSR SubHorzPosBnk3
    LDA.W DATA_03A4EB,Y
    STA.W SpriteMisc157C,X
  + RTS

CODE_03A4FD:
    LDA.W BowserWaitTimer
    BNE Return03A52C
    LDA.W SpriteMisc151C,X
    CMP.B #$08
    BNE CODE_03A51A
    INC.W BowserAttackType
    LDA.W BowserAttackType
    CMP.B #$03
    BEQ CODE_03A51A
    LDA.B #$FF
    STA.W BowserSteelieTimer
    BRA Return03A52C

CODE_03A51A:
    STZ.W BowserAttackType
    LDA.W SpriteStatus
    BEQ CODE_03A527
    LDA.W SpriteStatus+1
    BNE Return03A52C
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
    LDA.W BowserAttackTimer
    BEQ CODE_03A5D8
    DEC.W BowserAttackTimer
    BNE +
    LDA.B #$54
    STA.W BowserWaitTimer
    RTS

  + LSR A
    LSR A
    TAY
    LDA.W DATA_03A52D,Y
    STA.W SpriteMisc1570,X
    LDA.W BowserAttackTimer
    CMP.B #$80
    BNE +
    JSR CODE_03B019
    LDA.B #!SFX_SPRING                        ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + PLA
    PLA
    RTS

CODE_03A5D8:
    LDA.W BowserSteelieTimer
    BEQ Return03A60D
    DEC.W BowserSteelieTimer
    BEQ CODE_03A60E
    LSR A
    LSR A
    TAY
    LDA.W DATA_03A52D,Y
    STA.W SpriteMisc1570,X
    LDA.W DATA_03A56D,Y
    STA.B Mode7Angle
    STZ.B Mode7Angle+1
    CMP.B #$FF
    BNE +
    STZ.B Mode7Angle
    INC.B Mode7Angle+1
    STZ.B SpriteProperties
  + LDA.W BowserSteelieTimer
    CMP.B #$80
    BNE +
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
    JSR CODE_03A61D
  + PLA
    PLA
Return03A60D:
    RTS

CODE_03A60E:
    LDA.B #$60
    LDY.W BowserAttackType
    CPY.B #$02
    BEQ +
    LDA.B #$20
  + STA.W BowserWaitTimer
    RTS

CODE_03A61D:
    LDA.B #$08
    STA.W SpriteStatus+8
    LDA.B #$A1
    STA.B SpriteNumber+8
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$08
    STA.B SpriteXPosLow+8
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh+8
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
    LDA.W BowserHurtState
    BEQ Return03A6BF
    STZ.W BowserAttackTimer
    STZ.W BowserSteelieTimer
    DEC.W BowserHurtState
    BNE CODE_03A691
    LDA.B #$50
    STA.W BowserWaitTimer
    DEC.W SpriteMisc187B,X
    BNE CODE_03A691
    LDA.W SpriteMisc151C,X
    CMP.B #$09
    BEQ CODE_03A6C0
    LDA.B #$02
    STA.W SpriteMisc187B,X
    LDA.B #$01
    STA.W SpriteMisc151C,X
    LDA.B #$80
    STA.W SpriteMisc1540,X
CODE_03A691:
    PLY
    PLY
    PHA
    LDA.W BowserHurtState
    LSR A
    LSR A
    TAY
    LDA.W DATA_03A64D,Y
    STA.B Mode7Angle
    STZ.B Mode7Angle+1
    BPL +
    INC.B Mode7Angle+1
  + PLA
    LDY.B #$0C
    CMP.B #$40
    BCS +
CODE_03A6AC:
    LDA.B TrueFrame
    LDY.B #$10
    AND.B #$04
    BEQ +
    LDY.B #$12
  + TYA
    STA.W SpriteMisc1570,X
    LDA.B #$02
    STA.W ClownCarImage
Return03A6BF:
    RTS

CODE_03A6C0:
    LDA.B #$04
    STA.W SpriteMisc151C,X
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    RTS

KillMostSprites:
    LDY.B #$09
CODE_03A6CA:
    LDA.W SpriteStatus,Y
    BEQ +
    LDA.W SpriteNumber,Y
    CMP.B #$A9
    BEQ +
    CMP.B #$29
    BEQ +
    CMP.B #$A0
    BEQ +
    CMP.B #$C5
    BEQ +
    LDA.B #$04                                ; \ Sprite status = Killed by spin jump
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$1F                                ; \ Time to show cloud of smoke = #$1F
    STA.W SpriteMisc1540,Y                    ; /
  + DEY
    BPL CODE_03A6CA
    RTL


DATA_03A6F0:
    db $0E,$0E,$0A,$08,$06,$04,$02,$00

CODE_03A6F8:
    LDA.W SpriteMisc1540,X
    BEQ CODE_03A731
    CMP.B #$01
    BNE +
    LDY.B #!BGM_BOWSERZOOMOUT
    STY.W SPCIO2                              ; / Change music
  + LSR A
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_03A6F0,Y
    STA.W SpriteMisc1570,X
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    STZ.W SpriteMisc1528,X
    STZ.W SpriteMisc1534,X
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
    LDY.W SpriteMisc1528,X
    CPY.B #$02
    BCS +
    LDA.B TrueFrame
    AND.W DATA_03A723,Y
    BNE +
    LDA.B SpriteXSpeed,X
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
    BNE +
    LDA.B SpriteYSpeed,X
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
    CLC
    ADC.W DATA_03A729,Y
    STA.B Mode7XScale
    STA.B Mode7YScale
    CMP.W DATA_03A72D,Y
    BNE +
    INC.W BowserFlyawayCounter
  + LDA.W SpriteXPosHigh,X
    CMP.B #$FE
    BNE +
CODE_03A794:
    LDA.B #$03
    STA.W SpriteMisc151C,X
    LDA.B #$80
    STA.W BowserWaitTimer
    JSL GetRand
    AND.B #$F0
    STA.W BowserFireXPos
    LDA.B #!BGM_BOWSERINTERLUDE2
    STA.W SPCIO2                              ; / Change music
  + RTS

CODE_03A7AD:
    LDA.B #$60
    STA.B Mode7XScale
    STA.B Mode7YScale
    LDA.B #$FF
    STA.W SpriteXPosHigh,X
    LDA.B #$60
    STA.B SpriteXPosLow,X
    LDA.W BowserWaitTimer
    BNE +
    LDA.B #!BGM_BOWSERZOOMIN
    STA.W SPCIO2                              ; / Change music
    LDA.B #$02
    STA.W SpriteMisc151C,X
    LDA.B #$18
    STA.B SpriteYPosLow,X
    LDA.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B #$08
    STA.B Mode7XScale
    STA.B Mode7YScale
    LDA.B #$64
    STA.B SpriteXSpeed,X
    RTS

  + CMP.B #$60
    BCS Return03A840
    LDA.B TrueFrame
    AND.B #$1F
    BNE Return03A840
    LDY.B #$07
CODE_03A7EB:
    LDA.W SpriteStatus,Y
    BEQ CODE_03A7F6
    DEY
    CPY.B #$01
    BNE CODE_03A7EB
    RTS

CODE_03A7F6:
    LDA.B #!SFX_FIRESPIT                      ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$33
    STA.W SpriteNumber,Y
    LDA.W BowserFireXPos
    PHA
    STA.W SpriteXPosLow,Y
    CLC
    ADC.B #$20
    STA.W BowserFireXPos
    LDA.B #$00
    STA.W SpriteXPosHigh,Y
    LDA.B #$00
    STA.W SpriteYPosLow,Y
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    INC.B SpriteTableC2,X
    ASL.W SpriteTweakerE,X
    LSR.W SpriteTweakerE,X
    LDA.B #$39
    STA.W SpriteTweakerB,X
    PLX
    PLA
    LSR A
    LSR A
    LSR A
    LSR A
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
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.W SpriteMisc1540,X
    BNE CODE_03A86E
    LDA.B SpriteXSpeed,X
    BEQ +
    DEC.B SpriteXSpeed,X
  + LDA.B TrueFrame
    AND.B #$03
    BNE +
    INC.B Mode7XScale
    INC.B Mode7YScale
    LDA.B Mode7XScale
    CMP.B #$20
    BNE +
    LDA.B #$FF
    STA.W SpriteMisc1540,X
  + RTS

CODE_03A86E:
    CMP.B #$A0
    BNE +
    PHA
    JSR CODE_03A8D6
    PLA
  + STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    CMP.B #$01
    BEQ CODE_03A89D
    CMP.B #$40
    BCS CODE_03A8AE
    CMP.B #$3F
    BNE +
    PHA
    LDY.W BowserMusicIndex
    LDA.W BowserSoundMusic-7,Y
    STA.W SPCIO2                              ; / Change music
    PLA
  + LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_03A437,Y
    STA.W SpriteMisc1570,X
    RTS

CODE_03A89D:
    LDA.W BowserMusicIndex
    INC A
    STA.W SpriteMisc151C,X
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.B #$80
    STA.W BowserWaitTimer
    RTS

CODE_03A8AE:
    CMP.B #$E8
    BNE +
    LDY.B #!SFX_PEACHHELP                     ; \ Play sound effect
    STY.W SPCIO0                              ; /
  + SEC
    SBC.B #$3F
    STA.W SpriteMisc1594,X
    RTS


DATA_03A8BE:
    db $00,$00,$00,$08,$10,$14,$14,$16
    db $16,$18,$18,$17,$16,$16,$17,$18
    db $18,$17,$14,$10,$0C,$08,$04,$00

CODE_03A8D6:
    LDY.B #$07
CODE_03A8D8:
    LDA.W SpriteStatus,Y
    BEQ CODE_03A8E3
    DEY
    CPY.B #$01
    BNE CODE_03A8D8
    RTS

CODE_03A8E3:
    LDA.B #!SFX_MAGIC                         ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$74
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh,Y
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
    LDA.B #$C0
    STA.B SpriteYSpeed,X
    STZ.W SpriteMisc157C,X
    LDY.B #$0C
    LDA.B SpriteXPosLow,X
    BPL +
    LDY.B #$F4
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
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$20
    SEC
    SBC.B _2
    SEC
    SBC.B Layer1YPos
    STA.B _1
    CPY.B #$08
    BCC +
    CPY.B #$10
    BCS +
    LDA.B _0
    SEC
    SBC.B #$04
    STA.W OAMTileXPos+$A0
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$A4
    LDA.B _1
    SEC
    SBC.B #$18
    STA.W OAMTileYPos+$A0
    STA.W OAMTileYPos+$A4
    LDA.B #$20
    STA.W OAMTileNo+$A0
    LDA.B #$22
    STA.W OAMTileNo+$A4
    LDA.B EffFrame
    LSR A
    AND.B #$06
    INC A
    INC A
    INC A
    STA.W OAMTileAttr+$A0
    STA.W OAMTileAttr+$A4
    LDA.B #$02
    STA.W OAMTileSize+$28
    STA.W OAMTileSize+$29
  + LDY.B #$70
CODE_03AAC8:
    LDA.B _3
    ASL A
    ASL A
    STA.B _4
    PHX
    LDX.B #$03
CODE_03AAD1:
    PHX
    TXA
    CLC
    ADC.B _4
    TAX
    LDA.B _0
    CLC
    ADC.W DATA_03A92E,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_03A97E,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DATA_03A9CE,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_03AA1E,X
    PHX
    LDX.W CurSpriteProcess                    ; X = Sprite index
    CPX.B #$09
    BEQ +
    ORA.B #$30
  + STA.W OAMTileAttr+$100,Y
    PLX
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
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
    JSR CODE_03A4FD
    JSR CODE_03A4D2
    JSR CODE_03A4ED
    LDA.B TrueFrame
    AND.B #$00
    BNE CODE_03AB4B
    LDY.B #$00
    LDA.B SpriteXPosLow,X
    CMP.B PlayerXPosNext
    LDA.W SpriteXPosHigh,X
    SBC.B PlayerXPosNext+1
    BMI +
    INY
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
  + LDA.B SpriteYSpeed,X
    CMP.W DATA_03AB1B,Y
    BEQ +
    CLC
    ADC.W DATA_03AB19,Y
    STA.B SpriteYSpeed,X
  + RTS


DATA_03AB62:
    db $10,$F0

CODE_03AB64:
    LDA.B #$03
    STA.W ClownCarImage
    JSR CODE_03A4FD
    JSR CODE_03A4D2
    JSR CODE_03A4ED
    LDA.B SpriteYSpeed,X
    CLC
    ADC.B #$03
    STA.B SpriteYSpeed,X
    LDA.B SpriteYPosLow,X
    CMP.B #con($64,$64,$64,$64,$74)
    BCC +
    LDA.W SpriteYPosHigh,X
    BMI +
    LDA.B #$64
    STA.B SpriteYPosLow,X
    LDA.B #$A0
    STA.B SpriteYSpeed,X
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
    JSR SubHorzPosBnk3
    LDA.W DATA_03AB62,Y
    STA.B SpriteXSpeed,X
    LDA.B #$20                                ; \ Set ground shake timer
    STA.W ScreenShakeTimer                    ; /
  + RTS

CODE_03AB9F:
    JSR CODE_03A6AC
    LDA.W SpriteYPosHigh,X
    BMI CODE_03ABAF
    BNE +
    LDA.B SpriteYPosLow,X
    CMP.B #$10
    BCS +
CODE_03ABAF:
    LDA.B #$05
    STA.W SpriteMisc151C,X
    LDA.B #con($60,$60,$60,$50,$50)
    STA.W SpriteMisc1540,X
  + LDA.B #$F8
    STA.B SpriteYSpeed,X
    RTS

CODE_03ABBE:
    JSR CODE_03A6AC
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.W SpriteMisc1540,X
    BNE CODE_03ABEB
    LDA.B Mode7Angle
    CLC
    ADC.B #$0A
    STA.B Mode7Angle
    LDA.B Mode7Angle+1
    ADC.B #$00
    STA.B Mode7Angle+1
    BEQ +
    STZ.B Mode7Angle
    LDA.B #$20
    STA.W SpriteMisc154C,X
    LDA.B #con($60,$60,$60,$50,$50)
    STA.W SpriteMisc1540,X
    LDA.B #$06
    STA.W SpriteMisc151C,X
  + RTS

CODE_03ABEB:
    CMP.B #con($40,$40,$40,$30,$30)
    BCC Return03AC02
    CMP.B #con($5E,$5E,$5E,$4A,$4A)
    BNE +
    LDY.B #!BGM_BOWSERDEFEATED
    STY.W SPCIO2                              ; / Change music
  + LDA.W SpriteMisc1564,X
    BNE Return03AC02
    LDA.B #$12
    STA.W SpriteMisc1564,X
Return03AC02:
    RTS

CODE_03AC03:
    JSR CODE_03A6AC
    LDA.W SpriteMisc154C,X
    CMP.B #$01
    BNE +
    LDA.B #$0B
    STA.B PlayerAnimation
    INC.W FinalCutscene
    STZ.W BackgroundColor
    STZ.W BackgroundColor+1
    LDA.B #$03
    STA.W PlayerBehindNet
    JSR CODE_03AC63
  + LDA.W SpriteMisc1540,X
    BNE Return03AC4C
    LDA.B #$FA
    STA.B SpriteXSpeed,X
    LDA.B #$FC
    STA.B SpriteYSpeed,X
    LDA.B Mode7Angle
    CLC
    ADC.B #$05
    STA.B Mode7Angle
    LDA.B Mode7Angle+1
    ADC.B #$00
    STA.B Mode7Angle+1
    LDA.B TrueFrame
    AND.B #$03
    BNE Return03AC4C
    LDA.B Mode7XScale
    CMP.B #$80
    BCS +
    INC.B Mode7XScale
    INC.B Mode7YScale
Return03AC4C:
    RTS

  + LDA.W SpriteInLiquid,X
    BNE +
    LDA.B #!BGM_PEACHSAVED
    STA.W SPCIO2                              ; / Change music
    INC.W SpriteInLiquid,X
  + LDA.B #$FE
    STA.W SpriteXPosHigh,X
    STA.W SpriteYPosHigh,X
    RTS

CODE_03AC63:
    LDA.B #$08
    STA.W SpriteStatus+8
    LDA.B #$7C
    STA.B SpriteNumber+8
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$08
    STA.B SpriteXPosLow+8
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh+8
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
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    LDA.B TrueFrame
    AND.B #$7F
    BNE +
    JSL GetRand
    AND.B #$07
    BNE +
    LDA.B #$0C
    STA.W SpriteMisc154C,X
  + LDY.W SpriteMisc1602,X
    LDA.W SpriteMisc154C,X
    BEQ +
    INY
  + LDA.W SpriteMisc157C,X
    BNE +
    TYA
    CLC
    ADC.B #$08
    TAY
  + STY.B _3
    LDA.B #$D0
    STA.W SpriteOAMIndex,X
    TAY
    JSR CODE_03AAC8
    LDY.B #$02
    LDA.B #$03
    JSL FinishOAMWrite
    LDA.W SpriteMisc1558,X
    BEQ CODE_03AD18
    PHX
    LDX.B #$00
    LDA.B Powerup
    BNE +
    INX
  + LDY.B #$4C
    LDA.B PlayerXPosScrRel
    STA.W OAMTileXPos+$100,Y
    LDA.B PlayerYPosScrRel
    CLC
    ADC.W BlushTileDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W BlushTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    LDA.B PlayerDirection
    CMP.B #$01
    LDA.B #$31
    BCC +
    ORA.B #$40
  + STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
CODE_03AD18:
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    STZ.B PlayerXSpeed+1
    LDA.B #$04
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
    LDA.B #$06
    STA.W SpriteMisc1602,X
    JSL UpdateYPosNoGvtyW
    LDA.B SpriteYSpeed,X
    CMP.B #$08
    BCS +
    CLC
    ADC.B #$01
    STA.B SpriteYSpeed,X
  + LDA.W SpriteYPosHigh,X
    BMI +
    LDA.B SpriteYPosLow,X
    CMP.B #con($A0,$A0,$A0,$A0,$B0)
    BCC +
    LDA.B #con($A0,$A0,$A0,$A0,$B0)
    STA.B SpriteYPosLow,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.B #$A0
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + LDA.B TrueFrame
    AND.B #$07
    BNE Return03AD73
    LDY.B #$0B
CODE_03AD6B:
    LDA.W MinExtSpriteNumber,Y
    BEQ CODE_03AD74
    DEY
    BPL CODE_03AD6B
Return03AD73:
    RTS

CODE_03AD74:
    LDA.B #$05
    STA.W MinExtSpriteNumber,Y
    JSL GetRand
    STZ.B _0
    AND.B #$1F
    CLC
    ADC.B #$F8
    BPL +
    DEC.B _0
  + CLC
    ADC.B SpriteXPosLow,X
    STA.W MinExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B _0
    STA.W MinExtSpriteXPosHigh,Y
    LDA.W RandomNumber+1
    AND.B #$1F
    ADC.B SpriteYPosLow,X
    STA.W MinExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W MinExtSpriteYPosHigh,Y
    LDA.B #$00
    STA.W MinExtSpriteYSpeed,Y
    LDA.B #$17
    STA.W MinExtSpriteTimer,Y
    RTS

CODE_03ADB3:
    LDA.W SpriteMisc1540,X
    BNE +
    INC.B SpriteTableC2,X
    JSR CODE_03ADCC
    BCC +
    INC.W SpriteMisc151C,X
  + JSR SubHorzPosBnk3
    TYA
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
    LDA.B EffFrame
    AND.B #$08
    BNE +
    LDA.B #$08
    STA.W SpriteMisc1602,X
  + JSR CODE_03ADCC
    PHP
    JSR SubHorzPosBnk3
    PLP
    LDA.W SpriteMisc151C,X
    BNE ADDR_03ADF9
    BCS CODE_03AE14
    BRA CODE_03ADFF

ADDR_03ADF9:
    BCC CODE_03AE14
    TYA
    EOR.B #$01
    TAY
CODE_03ADFF:
    LDA.W DATA_03ADD9,Y
    STA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.B PlayerXSpeed+1
    TYA
    STA.W SpriteMisc157C,X
    STA.B PlayerDirection
    JSL UpdateXPosNoGvtyW
    RTS

CODE_03AE14:
    JSR SubHorzPosBnk3
    TYA
    STA.W SpriteMisc157C,X
    STA.B PlayerDirection
    INC.B SpriteTableC2,X
    LDA.B #$60
    STA.W SpriteMisc1540,X
    RTS

CODE_03AE25:
    LDA.W SpriteMisc1540,X
    BNE +
    INC.B SpriteTableC2,X
    LDA.B #$A0
    STA.W SpriteMisc1540,X
  + RTS

CODE_03AE32:
    LDA.W SpriteMisc1540,X
    BNE +
    INC.B SpriteTableC2,X
    STZ.W Empty188A
    STZ.W ScrShakePlayerYOffset
  + CMP.B #$50
    BCC Return03AE5A
    PHA
    BNE +
    LDA.B #$14
    STA.W SpriteMisc154C,X
  + LDA.B #$0A
    STA.W SpriteMisc1602,X
    PLA
    CMP.B #$68
    BNE Return03AE5A
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
    JSR CODE_03D674
    LDA.W SpriteMisc1540,X
    BNE Return03AEC7
    LDY.W FinalMessageTimer
    CPY.B #con($4C,$54,$54,$54,$54)
    BEQ +
    INC.W FinalMessageTimer
    LDA.W DATA_03AE5B,Y
    STA.W SpriteMisc1540,X
Return03AEC7:
    RTS

  + INC.B SpriteTableC2,X
    LDA.B #$40
    STA.W SpriteMisc1540,X
    RTS

  - INC.B SpriteTableC2,X
    LDA.B #$80
    STA.W SpriteMisc1FE2+9
    RTS


    db $00,$00,$94,$18,$18,$9C,$9C,$FF
    db $00,$00,$52,$63,$63,$73,$73,$7F

CODE_03AEE8:
    LDA.W SpriteMisc1540,X
    BEQ -
    LSR A
    STA.B _0
    STZ.B _1
    REP #$20                                  ; A->16
    LDA.B _0
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    ORA.B _0
    STA.B _0
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    ORA.B _0
    STA.B _0
    SEP #$20                                  ; A->8
    PHX
    TAX
    LDY.W DynPaletteIndex
    LDA.B #$02
    STA.W DynPaletteTable,Y
    LDA.B #$F1
    STA.W DynPaletteTable+1,Y
    LDA.B _0
    STA.W DynPaletteTable+2,Y
    LDA.B _1
    STA.W DynPaletteTable+3,Y
    LDA.B #$00
    STA.W DynPaletteTable+4,Y
    TYA
    CLC
    ADC.B #$04
    STA.W DynPaletteIndex
    PLX
    JSR CODE_03D674
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
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc157C,X
    STA.B _4
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$07
    STA.B _2
    LDA.B #$EC
    STA.W SpriteOAMIndex,X
    TAY
    PHX
    LDX.B #$03
  - PHX
    TXA
    ASL A
    ASL A
    ADC.B _2
    AND.B #$07
    TAX
    LDA.B _0
    CLC
    ADC.W DATA_03AF34,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_03AF3C,X
    STA.W OAMTileYPos+$100,Y
    LDA.B #$59
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_03AF44,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLX
    INY
    INY
    INY
    INY
    DEX
    BPL -
    LDA.W ClownCarTeardropPos
    INC.W ClownCarTeardropPos
    LSR A
    LSR A
    LSR A
    CMP.B #$0D
    BCS +
    TAX
    LDY.B #$FC
    LDA.B _4
    ASL A
    ROL A
    ASL A
    ASL A
    ASL A
    ADC.B _0
    CLC
    ADC.B #$15
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.L DATA_03AF4C,X
    STA.W OAMTileYPos+$100,Y
    LDA.B #$49
    STA.W OAMTileNo+$100,Y
    LDA.B #$07
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
  + PLX
    LDY.B #$00
    LDA.B #$04
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
    TYA
    LSR A
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
    STZ.B _2
    JSR CODE_03B020
    INC.B _2
CODE_03B020:
    LDY.B #$01
CODE_03B022:
    LDA.W SpriteStatus,Y
    BEQ CODE_03B02B
    DEY
    BPL CODE_03B022
    RTS

CODE_03B02B:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$A2
    STA.W SpriteNumber,Y
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$10
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    PHX
    LDX.B _2
    LDA.B _0
    CLC
    ADC.W DATA_03B013,X
    STA.W SpriteXPosLow,Y
    LDA.B _1
    ADC.W DATA_03B015,X
    STA.W SpriteXPosHigh,Y
    TYX
    JSL InitSpriteTables
    LDY.B _2
    LDA.W DATA_03B017,Y
    STA.B SpriteXSpeed,X
    LDA.B #$C0
    STA.B SpriteYSpeed,X
    PLX
    RTS


DATA_03B074:
    db $40,$C0

DATA_03B076:
    db $10,$F0

CODE_03B078:
    LDA.B Mode7XScale
    CMP.B #$20
    BNE Return03B0DB
    LDA.W SpriteMisc151C,X
    CMP.B #$07
    BCC Return03B0F2
    LDA.B Mode7Angle
    ORA.B Mode7Angle+1
    BNE Return03B0F2
    JSR CODE_03B0DC
    LDA.W SpriteMisc154C,X
    BNE Return03B0DB
    LDA.B #$24
    STA.W SpriteTweakerB,X
    JSL MarioSprInteract
    BCC CODE_03B0BD
    JSR CODE_03B0D6
    STZ.B PlayerYSpeed+1
    JSR SubHorzPosBnk3
    LDA.W BowserAttackTimer
    ORA.W BowserSteelieTimer
    BEQ CODE_03B0B3
    LDA.W DATA_03B076,Y
    BRA +

CODE_03B0B3:
    LDA.W DATA_03B074,Y
  + STA.B PlayerXSpeed+1
    LDA.B #!SFX_BONK                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
CODE_03B0BD:
    INC.W SpriteTweakerB,X
    JSL MarioSprInteract
    BCC +
    JSR CODE_03B0D2
  + INC.W SpriteTweakerB,X
    JSL MarioSprInteract
    BCC Return03B0DB
CODE_03B0D2:
    JSL HurtMario
CODE_03B0D6:
    LDA.B #$20
    STA.W SpriteMisc154C,X
Return03B0DB:
    RTS

CODE_03B0DC:
    LDY.B #$01
CODE_03B0DE:
    PHY
    LDA.W SpriteStatus,Y
    CMP.B #$09
    BNE +
    LDA.W SpriteOffscreenX,Y
    BNE +
    JSR CODE_03B0F3
  + PLY
    DEY
    BPL CODE_03B0DE
Return03B0F2:
    RTS

CODE_03B0F3:
    PHX
    TYX
    JSL GetSpriteClippingB
    PLX
    LDA.B #$24
    STA.W SpriteTweakerB,X
    JSL GetSpriteClippingA
    JSL CheckForContact
    BCS CODE_03B142
    INC.W SpriteTweakerB,X
    JSL GetSpriteClippingA
    JSL CheckForContact
    BCC Return03B160
    LDA.W BowserHurtState
    BNE Return03B160
    LDA.B #$4C
    STA.W BowserHurtState
    STZ.W ClownCarTeardropPos
    LDA.W SpriteMisc151C,X
    STA.W BowserMusicIndex
    LDA.B #!SFX_ENEMYHURT                     ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.W SpriteMisc151C,X
    CMP.B #$09
    BNE CODE_03B142
    LDA.W SpriteMisc187B,X
    CMP.B #$01
    BNE CODE_03B142
    PHY
    JSL KillMostSprites
    PLY
CODE_03B142:
    LDA.B #$00
    STA.W SpriteXSpeed,Y
    PHX
    LDX.B #$10
    LDA.W SpriteYSpeed,Y
    BMI +
    LDX.B #$D0
  + TXA
    STA.W SpriteYSpeed,Y
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,Y                      ; /
    TYX
    JSL CODE_01AB6F
    PLX
Return03B160:
    RTS


BowserBallSpeed:
    db $10,$F0

BowserBowlingBall:
    JSR BowserBallGfx
    LDA.B SpriteLock
    BNE Return03B1D4
    JSR SubOffscreen0Bnk3
    JSL MarioSprInteract
    JSL UpdateXPosNoGvtyW
    JSL UpdateYPosNoGvtyW
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL CODE_03B186
    CLC
    ADC.B #$03
    STA.B SpriteYSpeed,X
    BRA +

CODE_03B186:
    LDA.B #$40
    STA.B SpriteYSpeed,X
  + LDA.B SpriteYSpeed,X
    BMI CODE_03B1C5
    LDA.W SpriteYPosHigh,X
    BMI CODE_03B1C5
    LDA.B SpriteYPosLow,X
    CMP.B #con($B0,$B0,$B0,$B0,$C0)
    BCC CODE_03B1C5
    LDA.B #con($B0,$B0,$B0,$B0,$C0)
    STA.B SpriteYPosLow,X
    LDA.B SpriteYSpeed,X
    CMP.B #$3E
    BCC +
    LDY.B #!SFX_YOSHISTOMP                    ; \ Play sound effect
    STY.W SPCIO3                              ; /
    LDY.B #$20                                ; \ Set ground shake timer
    STY.W ScreenShakeTimer                    ; /
  + CMP.B #$08
    BCC +
    LDA.B #!SFX_BONK                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
  + JSR CODE_03B7F8
    LDA.B SpriteXSpeed,X
    BNE CODE_03B1C5
    JSR SubHorzPosBnk3
    LDA.W BowserBallSpeed,Y
    STA.B SpriteXSpeed,X
CODE_03B1C5:
    LDA.B SpriteXSpeed,X
    BEQ Return03B1D4
    BMI +
    DEC.W SpriteMisc1570,X
    DEC.W SpriteMisc1570,X
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
    LDA.B #$70
    STA.W SpriteOAMIndex,X
    JSR GetDrawInfoBnk3
    PHX
    LDX.B #$0B
  - LDA.B _0
    CLC
    ADC.W BowserBallDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W BowserBallDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W BowserBallTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W BowserBallGfxProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W BowserBallTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    PHX
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc1570,X
    LSR A
    LSR A
    LSR A
    AND.B #$07
    PHA
    TAX
    LDA.W OAMTileXPos+$104,Y
    CLC
    ADC.W BowserBallDispX2,X
    STA.W OAMTileXPos+$104,Y
    LDA.W OAMTileYPos+$104,Y
    CLC
    ADC.W BowserBallDispY2,X
    STA.W OAMTileYPos+$104,Y
    PLA
    CLC
    ADC.B #$02
    AND.B #$07
    TAX
    LDA.W OAMTileXPos+$108,Y
    CLC
    ADC.W BowserBallDispX2,X
    STA.W OAMTileXPos+$108,Y
    LDA.W OAMTileYPos+$108,Y
    CLC
    ADC.W BowserBallDispY2,X
    STA.W OAMTileYPos+$108,Y
    PLX
    LDA.B #$0B
    LDY.B #$FF
    JSL FinishOAMWrite
    RTS


MechakoopaSpeed:
    db $08,$F8

MechaKoopa:
    JSL CODE_03B307
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return03B306
    LDA.B SpriteLock
    BNE Return03B306
    JSR SubOffscreen0Bnk3
    JSL SprSpr_MarioSprRts
    JSL UpdateSpritePos
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDY.W SpriteMisc157C,X
    LDA.W MechakoopaSpeed,Y
    STA.B SpriteXSpeed,X
    LDA.B SpriteTableC2,X
    INC.B SpriteTableC2,X
    AND.B #$3F
    BNE +
    JSR SubHorzPosBnk3
    TYA
    STA.W SpriteMisc157C,X
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    LDA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.B SpriteXSpeed,X
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    AND.B #$0C
    LSR A
    LSR A
    STA.W SpriteMisc1602,X
Return03B306:
    RTS

CODE_03B307:
    PHB                                       ; Wrapper
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
    LDA.B #$0B
    STA.W SpriteOBJAttribute,X
    LDA.W SpriteMisc1540,X
    BEQ CODE_03B37F
    LDY.B #$05
    CMP.B #$05
    BCC CODE_03B369
    CMP.B #$FA
    BCC +
CODE_03B369:
    LDY.B #$04
  + TYA
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    CMP.B #$30
    BCS CODE_03B37F
    AND.B #$01
    TAY
    LDA.W MechakoopaPalette,Y
    STA.W SpriteOBJAttribute,X
CODE_03B37F:
    JSR GetDrawInfoBnk3
    LDA.W SpriteOBJAttribute,X
    STA.B _4
    TYA
    CLC
    ADC.B #$0C
    TAY
    LDA.W SpriteMisc1602,X
    ASL A
    ASL A
    STA.B _3
    LDA.W SpriteMisc157C,X
    ASL A
    ASL A
    EOR.B #$04
    STA.B _2
    PHX
    LDX.B #$03
  - PHX
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W MechakoopaTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    PLA
    PHA
    CLC
    ADC.B _2
    TAX
    LDA.B _0
    CLC
    ADC.W MechakoopaDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.W MechakoopaGfxProp,X
    ORA.B _4
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLA
    PHA
    CLC
    ADC.B _3
    TAX
    LDA.W MechakoopaTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.B _1
    CLC
    ADC.W MechakoopaDispY,X
    STA.W OAMTileYPos+$100,Y
    PLX
    DEY
    DEY
    DEY
    DEY
    DEX
    BPL -
    PLX
    LDY.B #$FF
    LDA.B #$03
    JSL FinishOAMWrite
    JSR MechaKoopaKeyGfx
    RTS


MechaKeyDispX:
    db $F9,$0F

MechaKeyGfxProp:
    db $4D,$0D

MechaKeyTiles:
    db $70,$71,$72,$71

MechaKoopaKeyGfx:
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$10
    STA.W SpriteOAMIndex,X
    JSR GetDrawInfoBnk3
    PHX
    LDA.W SpriteMisc1570,X
    LSR A
    LSR A
    AND.B #$03
    STA.B _2
    LDA.W SpriteMisc157C,X
    TAX
    LDA.B _0
    CLC
    ADC.W MechaKeyDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    SEC
    SBC.B #$00
    STA.W OAMTileYPos+$100,Y
    LDA.W MechaKeyGfxProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDX.B _2
    LDA.W MechaKeyTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    LDY.B #$00
    LDA.B #$00
    JSL FinishOAMWrite
    RTS

CODE_03B43C:
    JSR BowserItemBoxGfx
    JSR BowserSceneGfx
    RTS


BowserItemBoxPosX:
    db $70,$80,$70,$80

BowserItemBoxPosY:
    db $07,$07,$17,$17

BowserItemBoxProp:
    db $37,$77,$B7,$F7

BowserItemBoxGfx:
    LDA.W FinalCutscene
    BEQ +
    STZ.W PlayerItembox
  + LDA.W PlayerItembox
    BEQ Return03B48B
    PHX
    LDX.B #$03
    LDY.B #$04
  - LDA.W BowserItemBoxPosX,X
    STA.W OAMTileXPos,Y
    LDA.W BowserItemBoxPosY,X
    STA.W OAMTileYPos,Y
    LDA.B #$43
    STA.W OAMTileNo,Y
    LDA.W BowserItemBoxProp,X
    STA.W OAMTileAttr,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    PLY
    INY
    INY
    INY
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
    PHX
    LDY.B #$BC
    STZ.B _1
    LDA.W FinalCutscene
    STA.B _F
    CMP.B #$01
    LDX.B #$10
    BCC CODE_03B4BF
    LDY.B #$90
    DEX
CODE_03B4BF:
    LDA.B #con($C0,$C0,$C0,$C0,$D0)
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    LDA.B _1
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$10
    STA.B _1
    LDA.B #$08
    STA.W OAMTileNo+$100,Y
    LDA.B #$0D
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_03B4BF
    LDX.B #$0F
    LDA.B _F
    BNE CODE_03B532
    LDY.B #$14
CODE_03B4FA:
    %LorW_X(LDA,BowserRoofPosX)
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos,Y
    %LorW_X(LDA,BowserRoofPosY)
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos,Y
    LDA.B #$08
    CPX.B #$06
    BCS +
    LDA.B #$03
  + STA.W OAMTileNo,Y
    LDA.B #$0D
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    PLY
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_03B4FA
    BRA CODE_03B56A

CODE_03B532:
    LDY.B #$50
CODE_03B534:
    %LorW_X(LDA,BowserRoofPosX)
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$100,Y
    %LorW_X(LDA,BowserRoofPosY)
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    LDA.B #$08
    CPX.B #$06
    BCS +
    LDA.B #$03
  + STA.W OAMTileNo+$100,Y
    LDA.B #$0D
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
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
    PHX
    LDA.B PlayerXPosNext                      ; \
    CLC                                       ; |
    ADC.B #$02                                ; |
    STA.B _0                                  ; | $00 = (Mario X position + #$02) Low byte
    LDA.B PlayerXPosNext+1                    ; |
    ADC.B #$00                                ; |
    STA.B _8                                  ; / $08 = (Mario X position + #$02) High byte
    LDA.B #$0C                                ; \ $06 = Clipping width X (#$0C)
    STA.B _2                                  ; /
    LDX.B #$00                                ; \ If mario small or ducking, X = #$01
    LDA.B PlayerIsDucking                     ; | else, X = #$00
    BNE CODE_03B680                           ; |
    LDA.B Powerup                             ; |
    BNE +                                     ; |
CODE_03B680:
    INX                                       ; /
  + LDA.W PlayerRidingYoshi                   ; \ If on Yoshi, X += #$02
    BEQ +                                     ; |
    INX                                       ; |
    INX                                       ; /
  + LDA.L MarioClippingHeight,X               ; \ $03 = Clipping height
    STA.B _3                                  ; /
    LDA.B PlayerYPosNext                      ; \
    CLC                                       ; |
    ADC.L MairoClipDispY,X                    ; |
    STA.B _1                                  ; | $01 = (Mario Y position + displacement) Low byte
    LDA.B PlayerYPosNext+1                    ; |
    ADC.B #$00                                ; |
    STA.B _9                                  ; / $09 = (Mario Y position + displacement) High byte
    PLX
    RTL

GetSpriteClippingA:
    PHY
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
    PHY
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
    PHX
    LDX.B #$01
CODE_03B72E:
    LDA.B _0,X
    SEC
    SBC.B _4,X
    PHA
    LDA.B _8,X
    SBC.B _A,X
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
    STA.B _F
    LDA.B _2,X
    CLC
    ADC.B _6,X
    CMP.B _F
    BCC CODE_03B75A
    DEX
    BPL CODE_03B72E
CODE_03B75A:
    PLX
    RTL


DATA_03B75C:
    db $0C,$1C

DATA_03B75E:
    db $01,$02

GetDrawInfoBnk3:
    STZ.W SpriteOffscreenVert,X               ; Reset sprite offscreen flag, vertical
    STZ.W SpriteOffscreenX,X                  ; Reset sprite offscreen flag, horizontal
    LDA.B SpriteXPosLow,X                     ; \
    CMP.B Layer1XPos                          ; | Set horizontal offscreen if necessary
    LDA.W SpriteXPosHigh,X                    ; |
    SBC.B Layer1XPos+1                        ; |
    BEQ +                                     ; |
    INC.W SpriteOffscreenX,X                  ; /
  + LDA.W SpriteXPosHigh,X                    ; \
    XBA                                       ; | Mark sprite invalid if far enough off screen
    LDA.B SpriteXPosLow,X                     ; |
    REP #$20                                  ; A->16
    SEC                                       ; |
    SBC.B Layer1XPos                          ; |
    CLC                                       ; |
    ADC.W #$0040                              ; |
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
    ADC.W DATA_03B75C,Y                       ; |
    PHP                                       ; |
    CMP.B Layer1YPos                          ; | (vert screen boundry)
    ROL.B _0                                  ; |
    PLP                                       ; |
    LDA.W SpriteYPosHigh,X                    ; |
    ADC.B #$00                                ; |
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
    STA.B _0                                  ; / $00 = sprite x position relative to screen boarder
    LDA.B SpriteYPosLow,X                     ; \
    SEC                                       ; |
    SBC.B Layer1YPos                          ; |
    STA.B _1                                  ; / $01 = sprite y position relative to screen boarder
    RTS

CODE_03B7CF:
    PLA                                       ; \ Return from *main gfx routine* subroutine...
    PLA                                       ; |    ...(not just this subroutine)
    RTS                                       ; /


DATA_03B7D2:
    db $00,$00,$00,$F8,$F8,$F8,$F8,$F8
    db $F8,$F7,$F6,$F5,$F4,$F3,$F2,$E8
    db $E8,$E8,$E8,$00,$00,$00,$00,$FE
    db $FC,$F8,$EC,$EC,$EC,$E8,$E4,$E0
    db $DC,$D8,$D4,$D0,$CC,$C8

CODE_03B7F8:
    LDA.B SpriteYSpeed,X
    PHA
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    PLA
    LSR A
    LSR A
    TAY
    LDA.B SpriteNumber,X
    CMP.B #$A1
    BNE +
    TYA
    CLC
    ADC.B #$13
    TAY
  + LDA.W DATA_03B7D2,Y
    LDY.W SpriteBlockedDirs,X
    BMI +
    STA.B SpriteYSpeed,X
  + RTS

SubHorzPosBnk3:
    LDY.B #$00
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
    LDY.B #$00
    LDA.B PlayerYPosNext
    SEC
    SBC.B SpriteYPosLow,X
    STA.B _F
    LDA.B PlayerYPosNext+1
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
    LDA.B #$06                                ; \ Entry point of routine determines value of $03
    BRA +                                     ; |

    LDA.B #$04                                ; |
    BRA +                                     ; |

    LDA.B #$02                                ; |
  + STA.B _3                                  ; |
    BRA +                                     ; |

SubOffscreen0Bnk3:
    STZ.B _3                                  ; /
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
    STA.B Map16TileGenerate                   ; $9C = tile to generate
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
    PHB                                       ; Wrapper
    PHK
    PLB
    JSR CODE_03C02F
    PLB
    RTL


DATA_03C02B:
    db $74,$75,$77,$76

CODE_03C02F:
    LDY.W SpriteMisc160E,X
    LDA.B #$00
    STA.W SpriteStatus,Y
    LDA.B #!SFX_GULP                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.W SpriteMisc160E,Y
    BNE CODE_03C09B
    LDA.W SpriteNumber,Y
    CMP.B #$81
    BNE +
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W DATA_03C02B,Y
  + CMP.B #$74
    BCC CODE_03C09B
    CMP.B #$78
    BCS CODE_03C09B
ADDR_03C05C:
    STZ.W YoshiSwallowTimer
    STZ.W YoshiHasWingsEvt                    ; No Yoshi wing ability
    LDA.B #$35
    STA.W SpriteNumber,X
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #!SFX_YOSHI                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B SpriteYPosLow,X
    SBC.B #$10
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.W SpriteOBJAttribute,X
    PHA
    JSL InitSpriteTables
    PLA
    AND.B #$FE
    STA.W SpriteOBJAttribute,X
    LDA.B #$0C
    STA.W SpriteMisc1602,X
    DEC.W SpriteMisc160E,X
    LDA.B #$40
    STA.W YoshiGrowingTimer
    RTS

CODE_03C09B:
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    CMP.B #$05
    BNE CODE_03C0A7
    BRA ADDR_03C05C

CODE_03C0A7:
    JSL CODE_05B34A
    LDA.B #$01
    JSL GivePoints
    RTS


DATA_03C0B2:
    db $68,$6A,$6C,$6E

DATA_03C0B6:
    db $00,$03,$01,$02,$04,$02,$00,$01
    db $00,$04,$00,$02,$00,$03,$04,$01

CODE_03C0C6:
    LDA.B SpriteLock
    BNE +
    JSR CODE_03C11E
  + STZ.B _0
    LDX.B #$13
    LDY.B #$B0
  - STX.B _2
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$10
    STA.B _0
    LDA.B #$C4
    STA.W OAMTileYPos+$100,Y
    LDA.B SpriteProperties
    ORA.B #$09
    STA.W OAMTileAttr+$100,Y
    PHX
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    CLC
    ADC.L DATA_03C0B6,X
    AND.B #$03
    TAX
    LDA.L DATA_03C0B2,X
    STA.W OAMTileNo+$100,Y
    TYA
    LSR A
    LSR A
    TAX
    LDA.B #$02
    STA.W OAMTileSize+$40,X
    PLX
    INY
    INY
    INY
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
    LDA.B SpriteLock                          ; \ If sprites locked...
    ORA.W EndLevelTimer                       ; | ...or battle is over (set to FF when over)...
    BNE Return03C175                          ; / ...return
    LDA.W IggyLarryPlatWait                   ; \ If platform at a maximum tilt, (stationary timer > 0)
    BEQ +                                     ; |
    DEC.W IggyLarryPlatWait                   ; / decrement stationary timer
  + LDA.B TrueFrame                           ; \ Return every other time through...
    AND.B #$01                                ; |
    ORA.W IggyLarryPlatWait                   ; | ...return if stationary
    BNE Return03C175                          ; /
    LDA.W IggyLarryPlatTilt                   ; $1907 holds the total number of tilts made
    AND.B #$01                                ; \ X=1 if platform tilted up to the right (/)...
    TAX                                       ; / ...else X=0
    LDA.W IggyLarryPlatPhase                  ; $1907 holds the current phase: 0/ 1\ 2/ 3\ 4// 5\\
    CMP.B #$04                                ; \ If this is phase 4 or 5...
    BCC +                                     ; | ...cause a steep tilt by setting X=X+2
    INX                                       ; |
    INX                                       ; /
  + LDA.B Mode7Angle                          ; $36 is tilt of platform: //D8 /E8 -0- 18\ 28\\
    CLC                                       ; \ Get new tilt of platform by adding value
    ADC.L IggyPlatSpeed,X                     ; |
    STA.B Mode7Angle                          ; /
    PHA
    LDA.B Mode7Angle+1                        ; $37 is boolean tilt of platform: 0\ /1
    ADC.L DATA_03C116,X                       ; \ if tilted up to left,  $37=0
    AND.B #$01                                ; | if tilted up to right, $37=1
    STA.B Mode7Angle+1                        ; /
    PLA
    CMP.L IggyPlatBounds,X                    ; \ Return if platform not at a maximum tilt
    BNE Return03C175                          ; /
    INC.W IggyLarryPlatTilt                   ; Increment total number of tilts made
    LDA.B #$40                                ; \ Set timer to stay stationary
    STA.W IggyLarryPlatWait                   ; /
    INC.W IggyLarryPlatPhase                  ; Increment phase
    LDA.W IggyLarryPlatPhase                  ; \ If phase > 5, phase = 0
    CMP.B #$06                                ; |
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
    PHB
    PHK
    PLB
    LDY.B #$00
    LDA.W SpriteSlope,X
    BPL +
    INY
  + LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_03C1C6,Y
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_03C1C8,Y
    STA.W SpriteXPosHigh,X
    LDA.B #$18
    STA.B SpriteYSpeed,X
    PLB
    RTL


DATA_03C1EC:
    db $00,$04,$07,$08,$08,$07,$04,$00
    db $00

LightSwitch:
    LDA.B SpriteLock
    BNE CODE_03C22B
    JSL InvisBlkMainRt
    JSR SubOffscreen0Bnk3
    LDA.W SpriteMisc1558,X
    CMP.B #$05
    BNE CODE_03C22B
    STZ.B SpriteTableC2,X
    LDY.B #!SFX_SWITCH                        ; \ Play sound effect
    STY.W SPCIO0                              ; /
    PHA
    LDY.B #$09
CODE_03C211:
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BNE +
    LDA.W SpriteNumber,Y
    CMP.B #$C6
    BNE +
    LDA.W SpriteTableC2,Y
    EOR.B #$01
    STA.W SpriteTableC2,Y
  + DEY
    BPL CODE_03C211
    PLA
CODE_03C22B:
    LDA.W SpriteMisc1558,X
    LSR A
    TAY
    LDA.B Layer1YPos
    PHA
    CLC
    ADC.W DATA_03C1EC,Y
    STA.B Layer1YPos
    LDA.B Layer1YPos+1
    PHA
    ADC.B #$00
    STA.B Layer1YPos+1
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$2A
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$100,Y
    AND.B #$BF
    STA.W OAMTileAttr+$100,Y
    PLA
    STA.B Layer1YPos+1
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
    PHB                                       ; Wrapper
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
    SBC.B #$65
    TAX
    LDA.W DATA_03C25F,X
    STA.B _3
    LDA.W DATA_03C261,X
    STA.B _4
    PLX
    LDA.B EffFrame
    AND.B #$02
    STA.B _2
    LDA.B _0
    SEC
    SBC.B #$08
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    STA.W OAMTileXPos+$108,Y
    LDA.B _1
    SEC
    SBC.B #$08
    STA.W OAMTileYPos+$100,Y
    CLC
    ADC.B _3
    CLC
    ADC.B _2
    STA.W OAMTileYPos+$104,Y
    CLC
    ADC.B _3
    STA.W OAMTileYPos+$108,Y
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03
    PHX
    TAX
    LDA.W ChainsawMotorTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    LDA.B #$AE
    STA.W OAMTileNo+$104,Y
    LDA.B #$8E
    STA.W OAMTileNo+$108,Y
    LDA.B #$37
    STA.W OAMTileAttr+$100,Y
    LDA.B _4
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y
    LDY.B #$02
    TYA
    JSL FinishOAMWrite
    RTS

TriggerInivis1Up:
    PHX                                       ; \ Find free sprite slot (#$0B-#$00)
    LDX.B #$0B                                ; |
CODE_03C2DC:
    LDA.W SpriteStatus,X                      ; |
    BEQ Generate1Up                           ; |
    DEX                                       ; |
    BPL CODE_03C2DC                           ; |
    PLX                                       ; |
    RTL                                       ; /

Generate1Up:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$78                                ; \ Sprite = 1Up
    STA.B SpriteNumber,X                      ; /
    LDA.B PlayerXPosNext                      ; \ Sprite X position = Mario X position
    STA.B SpriteXPosLow,X                     ; |
    LDA.B PlayerXPosNext+1                    ; |
    STA.W SpriteXPosHigh,X                    ; /
    LDA.B PlayerYPosNext                      ; \ Sprite Y position = Matio Y position
    STA.B SpriteYPosLow,X                     ; |
    LDA.B PlayerYPosNext+1                    ; |
    STA.W SpriteYPosHigh,X                    ; /
    JSL InitSpriteTables                      ; Load sprite tables
    LDA.B #$10                                ; \ Disable interaction timer = #$10
    STA.W SpriteMisc154C,X                    ; /
    JSR PopupMushroom
    PLX
    RTL

InvisMushroom:
    JSR GetDrawInfoBnk3
    JSL MarioSprInteract                      ; \ Return if no interaction
    BCC Return03C347                          ; /
    LDA.B #$74                                ; \ Replace, Sprite = Mushroom
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables                      ; Reset sprite tables
    LDA.B #$20                                ; \ Disable interaction timer = #$20
    STA.W SpriteMisc154C,X                    ; /
    LDA.B SpriteYPosLow,X                     ; \ Sprite Y position = Mario Y position - $000F
    SEC                                       ; |
    SBC.B #$0F                                ; |
    STA.B SpriteYPosLow,X                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    SBC.B #$00                                ; |
    STA.W SpriteYPosHigh,X                    ; /
PopupMushroom:
    LDA.B #$00                                ; \ Sprite direction = dirction of Mario's X speed
    LDY.B PlayerXSpeed+1                      ; |
    BPL +                                     ; |
    INC A                                     ; |
  + STA.W SpriteMisc157C,X                    ; /
    LDA.B #$C0                                ; \ Set upward speed
    STA.B SpriteYSpeed,X                      ; /
    LDA.B #!SFX_ITEMBLOCK                     ; \ Play sound effect
    STA.W SPCIO3                              ; /
Return03C347:
    RTS


NinjiSpeedY:
    db $D0,$C0,$B0,$D0

Ninji:
    JSL GenericSprGfxRt2                      ; Draw sprite uing the routine for sprites <= 53
    LDA.B SpriteLock                          ; \ Return if sprites locked
    BNE Return03C38F                          ; /
    JSR SubHorzPosBnk3                        ; \ Always face mario
    TYA                                       ; |
    STA.W SpriteMisc157C,X                    ; /
    JSR SubOffscreen0Bnk3                     ; Only process while onscreen
    JSL SprSpr_MarioSprRts                    ; Interact with mario
    JSL UpdateSpritePos                       ; Update position based on speed values
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B #$60
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
    LDA.B SpriteTableC2,X
    AND.B #$03
    TAY
    LDA.W NinjiSpeedY,Y
    STA.B SpriteYSpeed,X
  + LDA.B #$00
    LDY.B SpriteYSpeed,X
    BMI +
    INC A
  + STA.W SpriteMisc1602,X
Return03C38F:
    RTS

CODE_03C390:
    PHB
    PHK
    PLB
    LDA.W SpriteMisc157C,X
    PHA
    LDY.W SpriteMisc15AC,X
    BEQ +
    CPY.B #$05
    BCC +
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + JSR CODE_03C3DA
    PLA
    STA.W SpriteMisc157C,X
    PLB
    RTL

  - JSL GenericSprGfxRt2
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
    LDA.B SpriteNumber,X
    CMP.B #$31
    BEQ -
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc15AC,X
    STA.B _5
    LDA.W SpriteMisc157C,X
    ASL A
    ADC.W SpriteMisc157C,X
    STA.B _2
    PHX
    LDA.W SpriteMisc1602,X
    PHA
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
    LDA.B _5
    BEQ +
    TXA
    CLC
    ADC.B #$06
    TAX
  + LDA.B _0
    CLC
    ADC.W DryBonesTileDispX,X
    STA.W OAMTileXPos+$100,Y
    PLX
    LDA.W DryBonesGfxProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLA
    PHA
    CLC
    ADC.B _3
    TAX
    LDA.B _1
    CLC
    ADC.W DryBonesTileDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DryBonesTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    INY
    INY
    INY
    INY
    DEX
    CPX.B _4
    BNE CODE_03C404
    PLX
    LDY.B #$02
    TYA
    JSL FinishOAMWrite
    RTS

CODE_03C44E:
    LDA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    BNE Return03C460
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_03C458:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_03C461                           ; |
    DEY                                       ; |
    BPL CODE_03C458                           ; |
Return03C460:
    RTL                                       ; / Return if no free slots

CODE_03C461:
    LDA.B #$06                                ; \ Extended sprite = Bone
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$10
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W ExtSpriteYPosHigh,Y
    LDA.B SpriteXPosLow,X
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W ExtSpriteXPosHigh,Y
    LDA.W SpriteMisc157C,X
    LSR A
    LDA.B #$18
    BCC +
    LDA.B #$E8
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
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$78
    STA.W OAMTileXPos+$100,Y
    LDA.B #$28
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.B SpriteTableC2,X
    LDX.B #$08
    AND.B #$01
    BEQ +
    LDA.B TrueFrame
    LSR A
    AND.B #$07
    TAX
  + LDA.W DiscoBallTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_03C49C,X
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
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
    LDA.W SpriteMisc1534,X
    BNE CODE_03C500
    LDY.B #$09
CODE_03C4E3:
    CPY.W CurSpriteProcess
    BEQ +
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BNE +
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
    JSR CODE_03C4A5
    LDA.B #$FF
    STA.B ColorSettings
    LDA.B #$20
    STA.B ColorAddition
    LDA.B #$20
    STA.B OBJCWWindow
    LDA.B #$80
    STA.W HDMAEnable
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY
    LDA.W DATA_03C4D8,Y
    STA.W BackgroundColor
    LDA.W DATA_03C4DA,Y
    STA.W BackgroundColor+1
    LDA.B SpriteLock
    BNE Return03C4F9
    LDA.W LightSkipInit
    BNE +
    LDA.B #$00
    STA.W LightBotWinOpenPos
    LDA.B #$90
    STA.W LightBotWinClosePos
    LDA.B #$78
    STA.W LightTopWinOpenPos
    LDA.B #$87
    STA.W LightTopWinClosePos
    LDA.B #$01
    STA.W LightExists
    STZ.W LightMoveDir
    INC.W LightSkipInit
  + LDY.W LightMoveDir
    LDA.W LightBotWinOpenPos
    CLC
    ADC.W DATA_03C48F,Y
    STA.W LightBotWinOpenPos
    LDA.W LightBotWinClosePos
    CLC
    ADC.W DATA_03C48F,Y
    STA.W LightBotWinClosePos
    CMP.W DATA_03C491,Y
    BNE +
    LDA.W LightMoveDir
    INC A
    AND.B #$01
    STA.W LightMoveDir
  + LDA.B TrueFrame
    AND.B #$03
    BNE Return03C4F9
    LDY.B #$00
    LDA.W LightTopWinOpenPos
    STA.W LightWinOpenCalc
    SEC
    SBC.W LightBotWinOpenPos
    BCS +
    INY
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
    BCS +
    INY
    EOR.B #$FF
    INC A
  + STA.W LightRightWidth
    STY.W LightRightRelPos
    STZ.W LightWinCloseMove
    LDA.B SpriteTableC2,X
    STA.B _F
    PHX
    REP #$10                                  ; XY->16
    LDX.W #$0000
CODE_03C5B8:
    CPX.W #$005F
    BCC CODE_03C607
    LDA.W LightWinOpenMove
    CLC
    ADC.W LightLeftWidth
    STA.W LightWinOpenMove
    BCS CODE_03C5CD
    CMP.B #$CF
    BCC +
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
    SBC.B #$CF
    STA.W LightWinCloseMove
    INC.W LightWinCloseCalc
    LDA.W LightRightRelPos
    BNE +
    DEC.W LightWinCloseCalc
    DEC.W LightWinCloseCalc
  + LDA.B _F
    BNE CODE_03C60F
CODE_03C607:
    LDA.B #$01
    STA.W WindowTable,X
    DEC A
    BRA +

CODE_03C60F:
    LDA.W LightWinOpenCalc
    STA.W WindowTable,X
    LDA.W LightWinCloseCalc
  + STA.W WindowTable+1,X
    INX
    INX
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
    LDA.W SpriteMisc1564,X
    BEQ CODE_03C7A7
    DEC A
    BNE +
    INC.W CutsceneID
    LDA.B #$FF
    STA.W EndLevelTimer
  + RTS

CODE_03C7A7:
    LDA.W SpriteMisc1564+9
    AND.B #$03
    TAY
    LDA.W DATA_03C78A,Y
    STA.W BackgroundColor
    LDA.W DATA_03C78E,Y
    STA.W BackgroundColor+1
    LDA.W SpriteMisc1FE2+9
    BNE Return03C80F
    LDA.W SpriteMisc1534,X
    CMP.B #$04
    BEQ CODE_03C810
    LDY.B #$01
CODE_03C7C7:
    LDA.W SpriteStatus,Y
    BEQ CODE_03C7D0
    DEY
    BPL CODE_03C7C7
    RTS

CODE_03C7D0:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$7A
    STA.W SpriteNumber,Y
    LDA.B #$00
    STA.W SpriteXPosHigh,Y
    LDA.B #$A8
    CLC
    ADC.B Layer1YPos
    STA.W SpriteYPosLow,Y
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    PLX
    PHX
    LDA.W SpriteMisc1534,X
    AND.B #$03
    STA.W SpriteMisc1534,Y
    TAX
    LDA.W DATA_03C792,X
    STA.W SpriteMisc1FE2+9
    LDA.W DATA_03C776,X
    STA.W SpriteXPosLow,Y
    PLX
    INC.W SpriteMisc1534,X
Return03C80F:
    RTS

CODE_03C810:
    LDA.B #$70
    STA.W SpriteMisc1564,X
    RTS

Firework:
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_03C828
    dw CODE_03C845
    dw CODE_03C88D
    dw CODE_03C941

FireworkSpeedY:
    db $E4,$E6,$E4,$E2

CODE_03C828:
    LDY.W SpriteMisc1534,X
    LDA.W FireworkSpeedY,Y
    STA.B SpriteYSpeed,X
    LDA.B #!SFX_YOSHISTOMP                    ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$10
    STA.W SpriteMisc1564,X
    INC.B SpriteTableC2,X
    RTS


DATA_03C83D:
    db $14,$0C,$10,$15

DATA_03C841:
    db $08,$10,$0C,$05

CODE_03C845:
    LDA.W SpriteMisc1564,X
    CMP.B #$01
    BNE +
    LDY.W SpriteMisc1534,X
    LDA.W FireworkSfx1,Y                      ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.W FireworkSfx2,Y                      ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + JSL UpdateYPosNoGvtyW
    INC.B SpriteXSpeed,X
    LDA.B SpriteXSpeed,X
    AND.B #$03
    BNE +
    INC.B SpriteYSpeed,X
  + LDA.B SpriteYSpeed,X
    CMP.B #$FC
    BNE +
    INC.B SpriteTableC2,X
    LDY.W SpriteMisc1534,X
    LDA.W DATA_03C83D,Y
    STA.W SpriteMisc151C,X
    LDA.W DATA_03C841,Y
    STA.W SpriteMisc15AC,X
    LDA.B #$08
    STA.W SpriteMisc1564+9
  + JSR CODE_03C96D
    RTS


DATA_03C889:
    db $FF,$80,$C0,$FF

CODE_03C88D:
    LDA.W SpriteMisc15AC,X
    DEC A
    BNE +
    LDY.W SpriteMisc1534,X
    LDA.W FireworkSfx3,Y                      ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.W FireworkSfx4,Y                      ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + JSR CODE_03C8B1
    LDA.B SpriteTableC2,X
    CMP.B #$02
    BNE +
    JSR CODE_03C8B1
  + JMP CODE_03C9E9

CODE_03C8B1:
    LDY.W SpriteMisc1534,X
    LDA.W SpriteMisc1570,X
    CLC
    ADC.W SpriteMisc151C,X
    STA.W SpriteMisc1570,X
    BCS ADDR_03C8DB
    CMP.W DATA_03C889,Y
    BCS CODE_03C8E0
    LDA.W SpriteMisc151C,X
    CMP.B #$02
    BCC CODE_03C8D4
    SEC
    SBC.B #$01
    STA.W SpriteMisc151C,X
    BCS +
CODE_03C8D4:
    LDA.B #$01
    STA.W SpriteMisc151C,X
    BRA +

ADDR_03C8DB:
    LDA.B #$FF
    STA.W SpriteMisc1570,X
CODE_03C8E0:
    INC.B SpriteTableC2,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.W SpriteMisc151C,X
    AND.B #$FF
    TAY
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
    LDA.B TrueFrame
    AND.B #$07
    BNE +
    INC.B SpriteYSpeed,X
  + JSL UpdateYPosNoGvtyW
    LDA.B #$07
    LDY.B SpriteYSpeed,X
    CPY.B #$08
    BNE +
    STZ.W SpriteStatus,X
  + CPY.B #$03
    BCC +
    INC A
    CPY.B #$05
    BCC +
    INC A
  + STA.W SpriteMisc1602,X
    JSR CODE_03C9E9
    RTS


DATA_03C969:
    db $EC,$8E,$EC,$EC

CODE_03C96D:
    TXA
    EOR.B TrueFrame
    AND.B #$03
    BNE +
    JSR GetDrawInfoBnk3
    LDY.B #$00
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.W SpriteMisc1534,X
    TAX
    LDA.B TrueFrame
    LSR A
    LSR A
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
    ASL A
    ASL A
    ASL A
    AND.B #$40
    ORA.B _2
    ORA.B #$31
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
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
    TXA
    EOR.B TrueFrame
    STA.B _5
    LDA.W SpriteMisc1570,X
    STA.B _6
    LDA.W SpriteMisc1602,X
    STA.B _7
    LDA.B SpriteXPosLow,X
    STA.B _8
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _9
    LDA.W SpriteMisc1534,X
    STA.B _A
    PHX
    LDX.B #$3F
    LDY.B #$00
CODE_03CA0D:
    STX.B _4
    LDA.B _A
    CMP.B #$03
    LDA.W DATA_03C626,X
    BCC +
    LDA.W DATA_03C6CE,X
  + SEC
    SBC.B #$40
    STA.B _0
    PHY
    LDA.B _A
    CMP.B #$03
    LDA.W DATA_03C67A,X
    BCC +
    LDA.W DATA_03C722,X
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
    NOP
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
    NOP
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
    CLC
    ADC.B _4
    LSR A
    LSR A
    AND.B #$07
    TAY
  + LDA.W DATA_03C9E1,Y
    PLY
    CLC
    ADC.B _2
    CLC
    ADC.B _8
    STA.W OAMTileXPos,Y
    LDA.B _3
    CLC
    ADC.B _9
    STA.W OAMTileYPos,Y
    PHX
    LDA.B _5
    AND.B #$03
    STA.B _F
    ASL A
    ASL A
    ASL A
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
    CPX.B #$03
    BEQ +
    EOR.B _4
  + AND.B #$0E
    ORA.B #$31
    STA.W OAMTileAttr,Y
    PLX
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    PLY
    INY
    INY
    INY
    INY
    DEX
    BMI +
    JMP CODE_03CA0D

  + LDX.B #$53
CODE_03CADC:
    STX.B _4
    LDA.B _A
    CMP.B #$03
    LDA.W DATA_03C626,X
    BCC +
    LDA.W DATA_03C6CE,X
  + SEC
    SBC.B #$40
    STA.B _0
    LDA.B _A
    CMP.B #$03
    LDA.W DATA_03C67A,X
    BCC +
    LDA.W DATA_03C722,X
  + SEC
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
    NOP
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
    NOP
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
    CLC
    ADC.B _4
    LSR A
    LSR A
    AND.B #$07
    TAY
  + LDA.W DATA_03C9E1,Y
    PLY
    CLC
    ADC.B _2
    CLC
    ADC.B _8
    STA.W OAMTileXPos+$100,Y
    LDA.B _3
    CLC
    ADC.B _9
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.B _5
    AND.B #$03
    STA.B _F
    ASL A
    ASL A
    ASL A
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
    CPX.B #$03
    BEQ +
    EOR.B _4
  + AND.B #$0E
    ORA.B #$31
    STA.W OAMTileAttr+$100,Y
    PLX
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
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
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BMI +                                     ; /
    LDA.B #$1B                                ; \ Sprite = Football
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
    PHX
    LDA.W SpriteMisc157C,X
    TAX
    LDA.B _1
    CLC
    ADC.L ChuckSprGenDispX,X
    STA.W SpriteXPosLow,Y
    LDA.B _0
    ADC.L ChuckSprGenSpeedHi,X
    STA.W SpriteXPosHigh,Y
    LDA.L ChuckSprGenSpeedLo,X
    STA.W SpriteXSpeed,Y
    LDA.B #$E0
    STA.W SpriteYSpeed,Y
    LDA.B #$10
    STA.W SpriteMisc1540,Y
    PLX
  + RTL

CODE_03CC09:
    PHB                                       ; Wrapper
    PHK
    PLB
    STZ.W SpriteTweakerB,X
    JSR CODE_03CC14
    PLB
    RTL

CODE_03CC14:
    JSR CODE_03D484
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE +
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

  + RTS


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
    LDA.W SpriteMisc1540,X
    BNE Return03CCDF
    LDA.W SpriteMisc1570,X
    BNE +
    JSL GetRand
    AND.B #$0F
    STA.W SpriteMisc160E,X
  + LDA.W SpriteMisc160E,X
    ORA.W SpriteMisc1570,X
    TAY
    LDA.W DATA_03CC5A,Y
    TAY
    LDA.W DATA_03CC38,Y
    STA.B SpriteXPosLow,X
    LDA.B SpriteTableC2,X
    CMP.B #$06
    LDA.W DATA_03CC40,Y
    BCC +
    LDA.B #$50
  + STA.B SpriteYPosLow,X
    LDA.B #$08
    LDY.W SpriteMisc1570,X
    BNE +
    JSR CODE_03CCE2
    JSL GetRand
    LSR A
    LSR A
    AND.B #$07
  + STA.W SpriteMisc1528,X
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
    LDY.B #$01
    JSR CODE_03CCE8
    DEY
CODE_03CCE8:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$29
    STA.W SpriteNumber,Y
    PHX
    TYX
    JSL InitSpriteTables
    PLX
    LDA.W DATA_03CCE0,Y
    STA.W SpriteMisc1570,Y
    LDA.B SpriteTableC2,X
    STA.W SpriteTableC2,Y
    LDA.W SpriteMisc160E,X
    STA.W SpriteMisc160E,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    RTS

CODE_03CD21:
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B #$40
    STA.W SpriteMisc1540,X
    INC.W SpriteMisc151C,X
  + LDA.B #$F8
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
    JSR CODE_03CEA7
    LDA.W SpriteMisc1540,X
    BNE +
CODE_03CDCF:
    LDA.B #$24
    STA.W SpriteMisc1540,X
    LDA.B #$03
    STA.W SpriteMisc151C,X
    RTS

  + LSR A
    LSR A
    STA.B _0
    LDA.W SpriteMisc1528,X
    ASL A
    ASL A
    ASL A
    ASL A
    ORA.B _0
    TAY
    LDA.W DATA_03CD37,Y
    STA.W SpriteMisc1602,X
    RTS

CODE_03CDEF:
    LDA.W SpriteMisc1540,X
    BNE CODE_03CE05
    LDA.W SpriteMisc1570,X
    BEQ +
    STZ.W SpriteStatus,X
    RTS

  + STZ.W SpriteMisc151C,X
    LDA.B #$30
    STA.W SpriteMisc1540,X
CODE_03CE05:
    LDA.B #$10
    STA.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW
    RTS

CODE_03CE0E:
    LDA.W SpriteMisc1540,X
    BNE CODE_03CE2A
    INC.W SpriteMisc1534,X
    LDA.W SpriteMisc1534,X
    CMP.B #$03
    BNE CODE_03CDCF
    LDA.B #$05
    STA.W SpriteMisc151C,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.B #!SFX_FALL
    STA.W SPCIO0                              ; / Play sound effect
    RTS

CODE_03CE2A:
    LDY.W SpriteMisc1570,X
    BNE CODE_03CE42
CODE_03CE2F:
    CMP.B #$24
    BNE +
    LDY.B #!SFX_CORRECT
    STY.W SPCIO3                              ; / Play sound effect
  + LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$01
    STA.W SpriteMisc1602,X
    RTS

CODE_03CE42:
    CMP.B #$10
    BNE +
    LDY.B #!SFX_WRONG
    STY.W SPCIO3                              ; / Play sound effect
  + LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_03CE56,Y
    STA.W SpriteMisc1602,X
    RTS


DATA_03CE56:
    db $16,$16,$15,$14

CODE_03CE5A:
    JSL UpdateYPosNoGvtyW
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +
    CLC
    ADC.B #$03
    STA.B SpriteYSpeed,X
  + LDA.W SpriteYPosHigh,X
    BEQ +
    LDA.B SpriteYPosLow,X
    CMP.B #$85
    BCC +
    LDA.B #$06
    STA.W SpriteMisc151C,X
    LDA.B #$80
    STA.W SpriteMisc1540,X
    LDA.B #!SFX_BOSSINLAVA
    STA.W SPCIO3                              ; / Play sound effect
    JSL CODE_028528
  + BRA CODE_03CE2F

CODE_03CE89:
    LDA.W SpriteMisc1540,X
    BNE +
    STZ.W SpriteStatus,X
    INC.W CutsceneID
    LDA.B #$FF
    STA.W EndLevelTimer
    LDA.B #!BGM_BOSSCLEAR
    STA.W SPCIO2                              ; / Change music
  + LDA.B #$04
    STA.B SpriteYSpeed,X
    JSL UpdateYPosNoGvtyW
    RTS

CODE_03CEA7:
    JSL MarioSprInteract
    BCC Return03CEF1
    LDA.B PlayerYSpeed+1
    CMP.B #$10
    BMI CODE_03CEED
    JSL DisplayContactGfx
    LDA.B #$02
    JSL GivePoints
    JSL BoostMarioSpeed
    LDA.B #!SFX_SPLAT
    STA.W SPCIO0                              ; / Play sound effect
    LDA.W SpriteMisc1570,X
    BNE +
    LDA.B #!SFX_ENEMYHURT
    STA.W SPCIO3                              ; / Play sound effect
    LDA.W SpriteMisc1534,X
    CMP.B #$02
    BNE +
    JSL KillMostSprites
  + LDA.B #$04
    STA.W SpriteMisc151C,X
    LDA.B #$50
    LDY.W SpriteMisc1570,X
    BEQ +
    LDA.B #$1F
  + STA.W SpriteMisc1540,X
    RTS

CODE_03CEED:
    JSL HurtMario
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
    JSR GetDrawInfoBnk3
    LDA.W SpriteMisc1602,X
    ASL A
    ASL A
    ADC.W SpriteMisc1602,X
    ADC.W SpriteMisc1602,X
    STA.B _2
    LDA.B SpriteTableC2,X
    CMP.B #$06
    BEQ CODE_03D4DF
    PHX
    LDA.W SpriteMisc1602,X
    TAX
    %LorW_X(LDA,DATA_03D456)
    TAX
  - PHX
    TXA
    CLC
    ADC.B _2
    TAX
    LDA.B _0
    CLC
    ADC.W DATA_03CEF2,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_03D006,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DATA_03D11A,X
    STA.W OAMTileNo+$100,Y
    LDA.W LemmyGfxProp,X
    ORA.B #$10
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W DATA_03D342,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    PLX
    DEX
    BPL -
CODE_03D4DD:
    PLX
    RTS

CODE_03D4DF:
    PHX
    LDA.W SpriteMisc1602,X
    TAX
    %LorW_X(LDA,DATA_03D46D)
    TAX
  - PHX
    TXA
    CLC
    ADC.B _2
    TAX
    LDA.B _0
    CLC
    ADC.W DATA_03CF7C,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_03D090,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DATA_03D1A4,X
    STA.W OAMTileNo+$100,Y
    LDA.W WendyGfxProp,X
    ORA.B #$10
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W DATA_03D3CC,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
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
    PHX
    REP #$30                                  ; AXY->16
    LDX.W FinalMessageTimer
    BEQ CODE_03D6A8
    DEX
    LDY.W #$0000
  - PHX
    TXA
    ASL A
    ASL A
    TAX
    LDA.W DATA_03D524,X
    STA.W OAMTileXPos,Y
    LDA.W DATA_03D524+2,X
    STA.W OAMTileNo,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    SEP #$20                                  ; A->8
    LDA.B #$00
    STA.W OAMTileSize,Y
    REP #$20                                  ; A->16
    PLY
    PLX
    INY
    INY
    INY
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
    PHX
    LDA.W SpriteMisc151C+4                    ; \ Return if less than 2 reznors killed
    CLC                                       ; |
    ADC.W SpriteMisc151C+5                    ; |
    ADC.W SpriteMisc151C+6                    ; |
    ADC.W SpriteMisc151C+7                    ; |
    CMP.B #$02                                ; |
    BCC CODE_03D757                           ; /
    LDX.W ReznorBridgeCount
    CPX.B #$0C
    BCS CODE_03D757
    LDA.L DATA_03D700,X
    STA.B TouchBlockXPos
    STZ.B TouchBlockXPos+1
    LDA.B #$B0
    STA.B TouchBlockYPos
    STZ.B TouchBlockYPos+1
    LDA.W ReznorBridgeTimer
    BEQ CODE_03D74A
    CMP.B #$3C
    BNE CODE_03D757
    JSR CODE_03D77F
    JSR CODE_03D759
    JSR CODE_03D77F
    INC.W ReznorBridgeCount
    BRA CODE_03D757

CODE_03D74A:
    JSR CODE_03D766
    LDA.B #$40
    STA.W ReznorBridgeTimer
    LDA.B #!SFX_SHATTER
    STA.W SPCIO3                              ; / Play sound effect
CODE_03D757:
    PLX
    RTL

CODE_03D759:
    REP #$20                                  ; A->16
    LDA.W #$0170
    SEC
    SBC.B TouchBlockXPos
    STA.B TouchBlockXPos
    SEP #$20                                  ; A->8
    RTS

CODE_03D766:
    JSR CODE_03D76C
    JSR CODE_03D759
CODE_03D76C:
    REP #$20                                  ; A->16
    LDA.B TouchBlockXPos
    SEC
    SBC.B Layer1XPos
    CMP.W #$0100
    SEP #$20                                  ; A->8
    BCS +
    JSL CODE_028A44
  + RTS

CODE_03D77F:
    LDA.B TouchBlockXPos
    LSR A
    LSR A
    LSR A
    STA.B _1
    LSR A
    ORA.B TouchBlockYPos
    REP #$20                                  ; A->16
    AND.W #$00FF
    LDX.B TouchBlockXPos+1
    BEQ +
    CLC
    ADC.W #$01B0
    LDX.B #$04
  + STX.B _0
    REP #$10                                  ; XY->16
    TAX
    SEP #$20                                  ; A->8
    LDA.B #$25
    STA.L Map16TilesLow,X
    LDA.B #$00
    STA.L Map16TilesHigh,X
    REP #$20                                  ; A->16
    LDA.L DynStripeImgSize
    TAX
    LDA.W #$C05A
    CLC
    ADC.B _0
    STA.L DynamicStripeImage,X
    ORA.W #$2000
    STA.L DynamicStripeImage+6,X
    LDA.W #$0240
    STA.L DynamicStripeImage+2,X
    STA.L DynamicStripeImage+8,X
    LDA.W #$38FC
    STA.L DynamicStripeImage+4,X
    STA.L DynamicStripeImage+$0A,X
    LDA.W #$00FF
    STA.L DynamicStripeImage+$0C,X
    TXA
    CLC
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
    REP #$10                                  ; XY->16
    STZ.W HW_VMAINC
    STZ.W HW_VMADD
    STZ.W HW_VMADD+1
    LDX.W #$4000
    LDA.B #$FF
  - STA.W HW_VMDATA
    DEX
    BNE -
    SEP #$10                                  ; XY->8
    BIT.W IRQNMICommand
    BVS +
    PHB
    PHK
    PLB
    LDA.B #DATA_03D7EC
    STA.B _5
    LDA.B #DATA_03D7EC>>8
    STA.B _6
    LDA.B #DATA_03D7EC>>16
    STA.B _7
    LDA.B #$10
    STA.B _0
    LDA.B #$08
    STA.B _1
    JSR CODE_03D991
    PLB
  + RTL

CODE_03D991:
    STZ.W HW_VMAINC
    LDY.B #$00
CODE_03D996:
    STY.B _2
    LDA.B #$00
CODE_03D99A:
    STA.B _3
    LDA.B _0
    STA.W HW_VMADD
    LDA.B _1
    STA.W HW_VMADD+1
    LDY.B _2
    LDA.B #$10
    STA.B _4
  - LDA.B [_5],Y
    STA.W IggyLarryPlatInteract,Y
    ASL A
    ASL A
    ORA.B _3
    TAX
    %WorL_X(LDA,DATA_03D8EC)
    STA.W HW_VMDATA
    %WorL_X(LDA,DATA_03D8EE)
    STA.W HW_VMDATA
    INY
    DEC.B _4
    BNE -
    LDA.B _0
    CLC
    ADC.B #$80
    STA.B _0
    BCC +
    INC.B _1
  + LDA.B _3
    EOR.B #$01
    BNE CODE_03D99A
    TYA
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
    PHX
    PHB
    PHK
    PLB
    LDY.B SpriteTableC2,X
    STY.W ActiveBoss
    CPY.B #$04
    BNE +
    JSR CODE_03DE8E
    LDA.B #$48
    STA.B Mode7CenterY
    LDA.B #$14
    STA.B Mode7XScale
    STA.B Mode7YScale
  + LDA.B #$FF
    STA.B LevelScrLength
    INC A
    STA.B LastScreenHoriz
    LDY.W ActiveBoss
    LDX.W DATA_03DD78,Y
    LDA.W KoopaPalPtrLo,Y                     ; \ $00 = Pointer in bank 0 (from above tables)
    STA.B _0                                  ; |
    LDA.W KoopaPalPtrHi,Y                     ; |
    STA.B _1                                  ; |
    STZ.B _2                                  ; /
    LDY.B #$0B                                ; \ Read 0B bytes and put them in $0707
  - LDA.B [_0],Y                              ; |
    STA.W MainPalette+4,Y                     ; |
    DEY                                       ; |
    BPL -                                     ; /
    LDA.B #$80
    STA.W HW_VMAINC
    STZ.W HW_VMADD
    STZ.W HW_VMADD+1
    TXY
    BEQ CODE_03DDD7
    JSL PrepareGraphicsFile
    LDA.B #$80
    STA.B _3
  - JSR CODE_03DDE5
    DEC.B _3
    BNE -
CODE_03DDD7:
    LDX.B #$5F
  - LDA.B #$FF
    STA.L Mode7BossTilemap,X
    DEX
    BPL -
    PLB
    PLX
    RTL

CODE_03DDE5:
    LDX.B #$00
    TXY
    LDA.B #$08
    STA.B _5
CODE_03DDEC:
    JSR CODE_03DE39
    PHY
    TYA
    LSR A
    CLC
    ADC.B #$0F
    TAY
    JSR CODE_03DE3C
    LDY.B #$08
  - LDA.W Mode7GfxBuffer,X
    ASL A
    ROL A
    ROL A
    ROL A
    AND.B #$07
    STA.W Mode7GfxBuffer,X
    STA.W HW_VMDATA+1
    INX
    DEY
    BNE -
    PLY
    DEC.B _5
    BNE CODE_03DDEC
    LDA.B #$07
CODE_03DE15:
    TAX
    LDY.B #$08
    STY.B _5
  - LDY.W Mode7GfxBuffer,X
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
    CLC
    ADC.W #$0018
    STA.B _0
    SEP #$20                                  ; A->8
    RTS

CODE_03DE39:
    JSR CODE_03DE3C
CODE_03DE3C:
    PHX
    LDA.B [_0],Y
    PHY
    LDY.B #$08
  - ASL A
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
    STZ.W HW_VMAINC
    REP #$20                                  ; A->16
    LDA.W #$0A1C
    STA.B _0
    LDX.B #$00
CODE_03DE9A:
    REP #$20                                  ; A->16
    LDA.B _0
    CLC
    ADC.W #$0080
    STA.B _0
    STA.W HW_VMADD
    SEP #$20                                  ; A->8
    LDY.B #$08
  - %WorL_X(LDA,DATA_03DE4E)
    STA.W HW_VMDATA
    INX
    DEY
    BNE -
    CPX.B #$40
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
    PHB
    PHK
    PLB
    LDA.W SpriteXPosHigh,X
    XBA
    LDA.B SpriteXPosLow,X
    LDY.B #$00
    JSR CODE_03DFAE
    LDA.W SpriteYPosHigh,X
    XBA
    LDA.B SpriteYPosLow,X
    LDY.B #$02
    JSR CODE_03DFAE
    PHX
    REP #$30                                  ; AXY->16
    STZ.B _6
    LDY.W #$0003
    LDA.W IRQNMICommand
    LSR A
    BCC CODE_03DF44
    LDA.W ClownCarPropeller
    AND.W #$0003
    ASL A
    TAX
    %WorL_X(LDA,DATA_03DEBF)
    STA.L Mode7BossTilemap+1
    %WorL_X(LDA,DATA_03DEC7)
    STA.L Mode7BossTilemap+3
    %WorL_X(LDA,DATA_03DECF)
    STA.L Mode7BossTilemap+5
    LDA.W #$0008
    STA.B _6
    LDX.W #$0380
    LDA.W Mode7TileIndex
    AND.W #$007F
    CMP.W #$002C
    BCC +
    LDX.W #$0388
  + TXA
    LDX.W #$000A
    LDY.W #$0007
    SEC
CODE_03DF44:
    STY.B _0
    BCS CODE_03DF55
CODE_03DF48:
    LDA.W Mode7TileIndex
    AND.W #$007F
    ASL A
    ASL A
    ASL A
    ASL A
    LDX.W #$0003
CODE_03DF55:
    STX.B _2
    PHA
    LDY.W LevelLoadObjectTile
    BPL +
    CLC
    ADC.B _0
  + TAY
    SEP #$20                                  ; A->8
    LDX.B _6
    LDA.B _0
    STA.B _4
CODE_03DF69:
    LDA.W DATA_03D9DE,Y
    INY
    BIT.W Mode7TileIndex
    BPL +
    EOR.B #$01
    DEY
    DEY
  + STA.L Mode7BossTilemap,X
    INX
    DEC.B _4
    BPL CODE_03DF69
    STX.B _6
    REP #$20                                  ; A->16
    PLA
    SEC
    ADC.B _0
    LDX.B _2
    CPX.W #$0004
    BEQ CODE_03DF48
    CPX.W #$0008
    BNE +
    LDA.W #$0360
  + CPX.W #$000A
    BNE +
    LDA.W ClownCarImage
    AND.W #$0003
    ASL A
    TAY
    LDA.W DATA_03DED7,Y
  + DEX
    BPL CODE_03DF55
    SEP #$30                                  ; AXY->8
    PLX
    PLB
    RTL

CODE_03DFAE:
    PHX
    TYX
    REP #$20                                  ; A->16
    EOR.W #$FFFF
    INC A
    CLC
    %WorL_X(ADC,DATA_03DEBB)
    CLC
    ADC.B Layer1XPos,X
    STA.B Mode7XPos,X
    SEP #$20                                  ; A->8
    PLX
    RTS


DATA_03DFC4:
    db $00,$0E,$1C,$2A,$38,$46,$54,$62

CODE_03DFCC:
    PHX
    LDX.W DynPaletteIndex
    LDA.B #$10
    STA.W DynPaletteTable,X
    STZ.W DynPaletteTable+1,X
    STZ.W DynPaletteTable+2,X
    STZ.W DynPaletteTable+3,X
    TXY
    LDX.W LightningFlashIndex
    BNE CODE_03E01B
    LDA.W FinalCutscene
    BEQ CODE_03DFF0
    REP #$20                                  ; A->16
    LDA.W BackgroundColor
    BRA CODE_03E031

CODE_03DFF0:
    LDA.B EffFrame
    LSR A
    BCC CODE_03E036
    DEC.W LightningWaitTimer
    BNE CODE_03E036
    TAX
    LDA.L CODE_04F708,X
    AND.B #$07
    TAX
    LDA.L DATA_04F6F8,X
    STA.W LightningWaitTimer
    LDA.L DATA_04F700,X
    STA.W LightningFlashIndex
    TAX
    LDA.B #$08
    STA.W LightningTimer
    LDA.B #!SFX_THUNDER
    STA.W SPCIO3                              ; / Play sound effect
CODE_03E01B:
    DEC.W LightningTimer
    BPL +
    DEC.W LightningFlashIndex
    LDA.B #$04
    STA.W LightningTimer
  + TXA
    ASL A
    TAX
    REP #$20                                  ; A->16
    LDA.L OverworldLightning,X
CODE_03E031:
    STA.W DynPaletteTable+2,Y
    SEP #$20                                  ; A->8
CODE_03E036:
    LDX.W BowserPalette
    LDA.L DATA_03DFC4,X
    TAX
    LDA.B #$0E
    STA.B _0
  - LDA.L BowserColors,X
    STA.W DynPaletteTable+4,Y
    INX
    INY
    DEC.B _0
    BNE -
    TYX
    STZ.W DynPaletteTable+4,X
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