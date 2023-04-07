    ORG $028000

DATA_028000:
    db $80,$40,$20,$10,$08,$04,$02,$01

CODE_028008:
    PHX
    LDA.W PlayerItembox
    BEQ CODE_028070
    STZ.W PlayerItembox
    PHA
    LDA.B #!SFX_ITEMDEPLOYED                  ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDX.B #$0B
CODE_028019:
    LDA.W SpriteStatus,X
    BEQ CODE_028042
    DEX
    BPL CODE_028019
    DEC.W SpriteToOverwrite
    BPL +
    LDA.B #$01
    STA.W SpriteToOverwrite
  + LDA.W SpriteToOverwrite
    CLC
    ADC.B #$0A
    TAX
    LDA.B SpriteNumber,X
    CMP.B #$7D
    BNE CODE_028042
    LDA.W SpriteStatus,X
    CMP.B #$0B
    BNE CODE_028042
    STZ.W PBalloonInflating
CODE_028042:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    PLA
    CLC
    ADC.B #$73
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    LDA.B #$78
    CLC
    ADC.B Layer1XPos
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B #$20
    CLC
    ADC.B Layer1YPos
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    INC.W SpriteMisc1534,X
CODE_028070:
    PLX
    RTL


BombExplosionX:
    db $00,$08,$06,$FA,$F8,$06,$08,$00
    db $F8,$FA

BombExplosionY:
    db $F8,$FE,$06,$06,$FE,$FA,$02,$08
    db $02,$FA

ExplodeBombRt:
    JSR ExplodeBombSubRt                      ;BOMB
    RTL

ExplodeBombSubRt:
    STZ.W SpriteTweakerA,X                    ; Make sprite unstompable
    LDA.B #$11                                ; \ Set new clipping area for explosion
    STA.W SpriteTweakerB,X                    ; /
    JSR GetDrawInfo2
    LDA.B SpriteLock                          ; \ Increase frame count if sprites not locked
    BNE +                                     ; |
    INC.W SpriteMisc1570,X                    ; /
  + LDA.W SpriteMisc1540,X                    ; \ When timer is up free up sprite slot
    BNE +                                     ; |
    STZ.W SpriteStatus,X                      ; /
    RTS

  + LDA.W SpriteMisc1540,X
    LSR A
    AND.B #$03
    CMP.B #$03
    BNE +
    JSR ExplodeSprites
    LDA.W SpriteMisc1540,X
    SEC
    SBC.B #$10
    CMP.B #$20
    BCS +
    JSL MarioSprInteract
  + LDY.B #$04
    STY.B _F
CODE_0280C4:
    LDA.W SpriteMisc1540,X
    LSR A
    PHA
    AND.B #$03
    STA.B _2
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.B #$04
    STA.B _0
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CLC
    ADC.B #$04
    STA.B _1
    LDY.B _F
    PLA
    AND.B #$04
    BEQ CODE_0280ED
    TYA
    CLC
    ADC.B #$05
    TAY
CODE_0280ED:
    LDA.B _0
    CLC
    ADC.W BombExplosionX,Y
    STA.B _0
    LDA.B _1
    CLC
    ADC.W BombExplosionY,Y
    STA.B _1
    DEC.B _2
    BPL CODE_0280ED
    LDA.B _F
    ASL A
    ASL A
    ADC.W SpriteOAMIndex,X
    TAY
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.B #$BC
    STA.W OAMTileNo+$100,Y
    LDA.B TrueFrame
    LSR A
    LSR A
    AND.B #$03
    SEC
    ROL A
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    DEC.B _F
    BPL CODE_0280C4
    LDY.B #$00
    LDA.B #$04
    JMP CODE_02B7A7

ExplodeSprites:
    LDY.B #$09                                ; \ Loop over sprites:
ExplodeLoopStart:
    CPY.W CurSpriteProcess                    ; | Don't attempt to kill self
    BEQ CODE_02814C                           ; |
    PHY                                       ; |
    LDA.W SpriteStatus,Y                      ; | Skip sprite if it's already dying/dead
    CMP.B #$08                                ; |
    BCC +                                     ; |
    JSR ExplodeKillSpr                        ; | Check for contact
  + PLY                                       ; |
CODE_02814C:
    DEY                                       ; | Next
    BPL ExplodeLoopStart                      ; /
    RTS

ExplodeKillSpr:
    PHX
    TYX                                       ; \ Return if no sprite contact
    JSL GetSpriteClippingB                    ; |
    PLX                                       ; |
    JSL GetSpriteClippingA                    ; |
    JSL CheckForContact                       ; |
    BCC +                                     ; /
    LDA.W SpriteTweakerD,Y                    ; \ Return if sprite is invincible
    AND.B #$02                                ; | to explosions
    BNE +                                     ; /
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$C0                                ; \ Sprite Y speed = #$C0
    STA.W SpriteYSpeed,Y                      ; /
    LDA.B #$00                                ; \ Sprite X speed = #$00
    STA.W SpriteXSpeed,Y                      ; /
  + RTS


DATA_028178:
    db $F8,$38,$78,$B8,$00,$10,$20,$D0
    db $E0,$10,$40,$80,$C0,$10,$10,$20
    db $B0,$20,$50,$60,$C0,$F0,$80,$B0
    db $20,$60,$A0,$E0,$70,$F0,$70,$B0
    db $F0,$10,$20,$50,$60,$90,$A0,$D0
    db $E0,$10,$20,$50,$60,$90,$A0,$D0
    db $E0,$10,$20,$50,$60,$90,$A0,$D0
    db $E0,$50,$60,$C0,$D0,$30,$40,$70
    db $80,$B0,$C0,$30,$40,$70,$80,$B0
    db $C0,$40,$50,$80,$90,$C8,$D8,$30
    db $40,$A0,$B0,$58,$68,$B0,$C0

DATA_0281CF:
    db $70,$70,$70,$70,$20,$20,$20,$20
    db $20,$30,$30,$30,$30,$70,$80,$80
    db $80,$90,$90,$90,$A0,$50,$60,$60
    db $70,$70,$70,$70,$60,$60,$70,$70
    db $70,$40,$40,$40,$40,$40,$40,$40
    db $40,$50,$50,$50,$50,$50,$50,$50
    db $50,$60,$60,$60,$60,$60,$60,$60
    db $60,$30,$30,$30,$30,$48,$48,$48
    db $48,$48,$48,$58,$58,$58,$58,$58
    db $58,$70,$70,$78,$78,$70,$70,$80
    db $80,$88,$88,$A0,$A0,$A0,$A0

DATA_028226:
    db $E8,$E8,$E8,$E8,$E4,$E4,$E4,$E4
    db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4
    db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4
    db $E4,$E4,$E4,$E4,$EE,$EE,$EE,$EE
    db $EE,$C0,$C2,$C0,$C2,$C0,$C2,$C0
    db $C2,$E0,$E2,$E0,$E2,$E0,$E2,$E0
    db $E2,$C4,$A4,$C4,$A4,$C4,$A4,$C4
    db $A4,$CC,$CE,$CC,$CE,$C8,$CA,$C8
    db $CA,$C8,$CA,$CA,$C8,$CA,$C8,$CA
    db $C8,$CC,$CE,$CC,$CE,$CC,$CE,$CC
    db $CE,$CC,$CE,$CC,$CE,$CC,$CE

ProcM7BossObjBG:
    LDA.B Layer1XPos
    STA.W BossBGSpriteXCalc
    EOR.B #$FF
    INC A
    STA.B _5
    LDA.B Layer1XPos+1
    LSR A
    ROR.W BossBGSpriteXCalc
    PHA
    LDA.W BossBGSpriteXCalc
    EOR.B #$FF
    INC A
    STA.B _6
    PLA
    LSR A
    ROR.W BossBGSpriteXCalc
    LDA.W BossBGSpriteXCalc
    EOR.B #$FF
    INC A
    STA.W BossBGSpriteXCalc
    REP #$10                                  ; XY->16
    LDY.W #$0164
    LDA.B #$66
    STY.B _3
    LDA.B #$F0
  - STA.W OAMTileYPos+$0C,Y
    INY
    INY
    INY
    INY
    CPY.W #$018C
    BCC -
    LDX.W #$0000
    STX.B _C
    LDX.W #$0038
    LDY.W #$00E0
    LDA.W SpriteMisc187B+9
    CMP.B #$01
    BNE CODE_0282D8
    LDX.W #$0039
    STX.B _C
    LDX.W #$001D
    LDY.W #$00FC
CODE_0282D8:
    STX.B _0
    REP #$20                                  ; A->16
    TXA
    CLC
    ADC.B _C
    STA.B _A
    SEP #$20                                  ; A->8
    LDA.B _6
    CLC
    LDX.B _A
    ADC.L DATA_028178,X
    STA.W OAMTileXPos+$0C,Y
    STA.B _2
    LDA.W ScreenShakeYOffset
    STA.B _7
    ASL A
    ROR.B _7
    LDA.L DATA_0281CF,X
    DEC A
    SEC
    SBC.B _7
    STA.W OAMTileYPos+$0C,Y
    LDX.B _A
    LDA.W BossBGSpriteUpdate
    BNE +
    LDA.L DATA_028226,X
    STA.W OAMTileNo+$0C,Y
    LDA.B #$0D
    STA.W OAMTileAttr+$0C,Y
  + REP #$20                                  ; A->16
    PHY
    TYA
    LSR A
    LSR A
    TAY
    SEP #$20                                  ; A->8
    LDA.B #$02
    STA.W OAMTileSize+3,Y
    LDA.B _2
    CMP.B #$F0
    BCC +
    LDA.W SpriteMisc187B+9
    CMP.B #$01
    BEQ +
    PLY
    PHY
    LDX.B _3
    LDA.W OAMTileXPos+$0C,Y
    STA.W OAMTileXPos+$0C,X
    LDA.W OAMTileYPos+$0C,Y
    STA.W OAMTileYPos+$0C,X
    LDA.W OAMTileNo+$0C,Y
    STA.W OAMTileNo+$0C,X
    LDA.W OAMTileAttr+$0C,Y
    STA.W OAMTileAttr+$0C,X
    REP #$20                                  ; A->16
    TXA
    LSR A
    LSR A
    TAY
    SEP #$20                                  ; A->8
    LDA.B #$03
    STA.W OAMTileSize+3,Y
    LDA.B _3
    CLC
    ADC.B #$04
    STA.B _3
    BCC +
    INC.B _4
  + PLY
    LDX.B _0
    DEY
    DEY
    DEY
    DEY
    DEX
    BMI +
    JMP CODE_0282D8

  + SEP #$10                                  ; XY->8
    LDA.B #$01
    STA.W BossBGSpriteUpdate
    LDA.W SpriteMisc187B+9
    CMP.B #$01
    BNE CODE_028398
    LDA.B #$CD
    STA.W OAMTileAttr+$BC
    STA.W OAMTileAttr+$C0
    STA.W OAMTileAttr+$C4
    STA.W OAMTileAttr+$C8
    STA.W OAMTileAttr+$CC
    STA.W OAMTileAttr+$D0
    BRA CODE_0283C4

CODE_028398:
    LDA.B EffFrame
    AND.B #$03
    BNE CODE_0283C4
    STZ.B _0
CODE_0283A0:
    LDX.B _0
    LDA.L DATA_0283C8,X
    TAY
    JSL GetRand
    AND.B #$01
    BNE +
    LDA.W OAMTileNo+$0C,Y
    EOR.B #$02
    STA.W OAMTileNo+$0C,Y
  + LDA.B #$09
    STA.W OAMTileAttr+$0C,Y
    INC.B _0
    LDA.B _0
    CMP.B #$04
    BNE CODE_0283A0
CODE_0283C4:
    JSR CODE_0283CE
    RTL


DATA_0283C8:
    db $00,$04,$08,$0C

DATA_0283CC:
    db $0C,$30

CODE_0283CE:
    LDA.W SpriteMisc1534+9
    SEC
    SBC.B #$1E
    STA.B _C
    LDA.W SpriteMisc160E+9
    CLC
    ADC.B #$10
    STA.B _D
    LDX.B #$01
CODE_0283E0:
    STX.B _F
    LDA.W BossPillarFalling,X
    BEQ CODE_0283F4
    BMI +
    STA.W PlayerIsFrozen
    STA.B SpriteLock
    JSR CODE_0283F8
  + JSR CODE_028439
CODE_0283F4:
    DEX
    BPL CODE_0283E0
    RTS

CODE_0283F8:
    LDA.W BossPillarYPos,X
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    SEC
    ADC.W BossPillarYPos,X
    CMP.B #$B0
    BCC CODE_028435
    ASL.W BossPillarFalling,X
    SEC
    ROR.W BossPillarFalling,X
    LDA.B #$30                                ; \ Set ground shake timer
    STA.W ScreenShakeTimer                    ; /
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
    CPX.B #$00
    BNE CODE_02842A
    LDA.W BossPillarFalling+1
    BNE CODE_02842A
    INC.W BossPillarFalling+1
    STZ.W BossPillarYPos+1
    BRA +

CODE_02842A:
    CPX.B #$01
    BNE +
    STZ.B SpriteLock
    STZ.W PlayerIsFrozen
  + LDA.B #$B0
CODE_028435:
    STA.W BossPillarYPos,X
    RTS

CODE_028439:
    LDA.L DATA_0283CC,X
    TAY
    STZ.B _0
CODE_028440:
    LDA.B #$F0
    STA.W OAMTileYPos,Y
    LDA.W BossPillarYPos,X
    SEC
    SBC.B Layer1YPos
    SEC
    SBC.W ScreenShakeYOffset
    SEC
    SBC.B _0
    CMP.B #$20
    BCC Return02848C
    CMP.B #$A4
    BCS +
    STA.W OAMTileYPos,Y
  + LDA.B _C,X
    STA.W OAMTileXPos,Y
    LDA.B #$E6
    LDX.B _0
    BEQ +
    LDA.B #$08
  + STA.W OAMTileNo,Y
    LDA.B #$0D
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAX
    LDA.B #$02
    STA.W OAMTileSize,X
    LDX.B _F
    INY
    INY
    INY
    INY
    LDA.B _0
    CLC
    ADC.B #$10
    STA.B _0
    CMP.B #$90
    BCC CODE_028440
Return02848C:
    RTS

SubHorzPosBnk2:
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

IsOffScreenBnk2:
    LDA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    RTS

CODE_0284A6:
    STA.B _3
    LDA.B #$02
    STA.B _1
  - JSL CODE_0284D8
    LDA.B _2
    CLC
    ADC.B _3
    STA.B _2
    DEC.B _1
    BPL -
    RTL

CODE_0284BC:
    LDA.B #$12
    BRA +

CODE_0284C0:
    LDA.B #$00
  + STA.B _0
    STZ.B _2
    LDA.B SpriteNumber,X
    CMP.B #$41
    BEQ CODE_0284D0
    CMP.B #$42
    BNE CODE_0284D8
CODE_0284D0:
    LDA.B SpriteYSpeed,X
    BPL Return0284E7
    LDA.B #$0A
    BRA CODE_0284A6

CODE_0284D8:
    JSR IsOffScreenBnk2
    BNE Return0284E7
    LDY.B #$0B
CODE_0284DF:
    LDA.W MinExtSpriteNumber,Y
    BEQ CODE_0284E8
    DEY
    BPL CODE_0284DF
Return0284E7:
    RTL

CODE_0284E8:
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$00
    AND.B #$F0
    CLC
    ADC.B #$03
    STA.W MinExtSpriteYPosLow,Y
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B _2
    STA.W MinExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W MinExtSpriteXPosHigh,Y
    LDA.B #$07
    STA.W MinExtSpriteNumber,Y
    LDA.B _0
    STA.W MinExtSpriteTimer,Y
    RTL


DATA_028510:
    db $04,$FC,$06,$FA,$08,$F8,$0A,$F6
DATA_028518:
    db $E0,$E1,$E2,$E3,$E4,$E6,$E8,$EA
DATA_028520:
    db $1F,$13,$10,$1C,$17,$1A,$0F,$1E

CODE_028528:
    JSR IsOffScreenBnk2
    LDA.W SpriteOffscreenVert,X
    BNE Return0284E7
    LDA.B #$04
    STA.B _0
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_028536:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_02853F                           ; |
    DEY                                       ; |
    BPL CODE_028536                           ; |
    RTL                                       ; / Return if no free slots

CODE_02853F:
    LDA.B #$07                                ; \ Extended sprite = Lava splash
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteYPosLow,X
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W ExtSpriteYPosHigh,Y
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W ExtSpriteXPosHigh,Y
    JSL GetRand
    PHX
    AND.B #$07
    TAX
    LDA.L DATA_028510,X
    STA.W ExtSpriteXSpeed,Y
    LDA.W RandomNumber+1
    AND.B #$07
    TAX
    LDA.L DATA_028518,X
    STA.W ExtSpriteYSpeed,Y
    JSL GetRand
    AND.B #$07
    TAX
    LDA.L DATA_028520,X
    STA.W ExtSpriteMisc176F,Y
    PLX
    DEC.B _0
    BPL CODE_028536
    RTL

CODE_02858F:
    LDY.B #$1F                                ; \ If Big Mario:
    LDX.B #$00                                ; | Y = #$1F
    LDA.B Powerup                             ; | X = #$00
    BNE +                                     ; | Small Mario:
    LDY.B #$0F                                ; | Y = #$0F
    LDX.B #$10                                ; / X = #$10
  + STX.B _1
    JSL GetRand
    TYA
    AND.W RandomNumber
    CLC
    ADC.B _1
    CLC
    ADC.B PlayerYPosNext
    STA.B _0
    LDA.W RandomNumber+1
    AND.B #$0F
    CLC
    ADC.B #$FE
    CLC
    ADC.B PlayerXPosNext
    STA.B _2
CODE_0285BA:
    LDY.B #$0B
CODE_0285BC:
    LDA.W MinExtSpriteNumber,Y
    BEQ CODE_0285C5
    DEY
    BPL CODE_0285BC
    RTL

CODE_0285C5:
    LDA.B #$05
    STA.W MinExtSpriteNumber,Y
    LDA.B #$00
    STA.W MinExtSpriteYSpeed,Y
    LDA.B _0
    STA.W MinExtSpriteYPosLow,Y
    LDA.B _2
    STA.W MinExtSpriteXPosLow,Y
    LDA.B #$17
    STA.W MinExtSpriteTimer,Y
    RTL

CODE_0285DF:
    JSR IsOffScreenBnk2
    BNE Return0285EE
    LDY.B #$0B
CODE_0285E6:
    LDA.W MinExtSpriteNumber,Y
    BEQ CODE_0285EF
    DEY
    BPL CODE_0285E6
Return0285EE:
    RTL

CODE_0285EF:
    JSL GetRand
    LDA.B #$04
    STA.W MinExtSpriteNumber,Y
    LDA.B #$00
    STA.W MinExtSpriteYSpeed,Y
    LDA.W RandomNumber
    AND.B #$0F
    SEC
    SBC.B #$03
    CLC
    ADC.B SpriteXPosLow,X
    STA.W MinExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W MinExtSpriteXPosHigh,Y
    LDA.W RandomNumber+1
    AND.B #$07
    CLC
    ADC.B #$07
    CLC
    ADC.B SpriteYPosLow,X
    STA.W MinExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W MinExtSpriteYPosHigh,Y
    LDA.B #$17
    STA.W MinExtSpriteTimer,Y
    RTL

CODE_02862F:
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BMI +                                     ; /
    TYX
    LDA.B #$0B                                ; \ Sprite status = Being carried
    STA.W SpriteStatus,X                      ; /
    LDA.B PlayerYPosNext
    STA.B SpriteYPosLow,X
    LDA.B PlayerYPosNext+1
    STA.W SpriteYPosHigh,X
    LDA.B PlayerXPosNext
    STA.B SpriteXPosLow,X
    LDA.B PlayerXPosNext+1,X
    STA.W SpriteXPosHigh,X
    LDA.B #$53                                ; \ Sprite = Throw Block
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables
    LDA.B #$FF
    STA.W SpriteMisc1540,X
    LDA.B #$08
    STA.W PickUpItemTimer
    STA.W IsCarryingItem
  + RTL

ShatterBlock:
    PHX
    STA.B _0
    LDY.B #$03
    LDX.B #$0B
CODE_02866A:
    LDA.W MinExtSpriteNumber,X
    BEQ CODE_02867F
CODE_02866F:
    DEX
    BPL CODE_02866A
    DEC.W MinExtSpriteSlotIdx
    BPL +
    LDA.B #$0B
    STA.W MinExtSpriteSlotIdx
  + LDX.W MinExtSpriteSlotIdx
CODE_02867F:
    LDA.B #!SFX_SHATTER                       ; \
    STA.W SPCIO3                              ; / Play sound effect
    LDA.B #$01
    STA.W MinExtSpriteNumber,X
    LDA.B TouchBlockXPos
    CLC
    ADC.W DATA_028746,Y
    STA.W MinExtSpriteXPosLow,X
    LDA.B TouchBlockXPos+1
    ADC.B #$00
    STA.W MinExtSpriteXPosHigh,X
    LDA.B TouchBlockYPos
    CLC
    ADC.W DATA_028742,Y
    STA.W MinExtSpriteYPosLow,X
    LDA.B TouchBlockYPos+1
    ADC.B #$00
    STA.W MinExtSpriteYPosHigh,X
    LDA.W DATA_02874A,Y
    STA.W MinExtSpriteYSpeed,X
    LDA.W DATA_02874E,Y
    STA.W MinExtSpriteXSpeed,X
    LDA.B _0
    STA.W MinExtSpriteTimer,X
    DEY
    BPL CODE_02866F
    PLX
    RTL

YoshiStompRoutine:
    LDA.W SpriteStompCounter
    BNE +
    PHB
    PHK
    PLB
    JSR SprBlkInteract
    LDA.B #$02
    STA.W QuakeSpriteNumber,Y
    LDA.B PlayerXPosNext
    STA.W QuakeSpriteXPosLow,Y
    LDA.B PlayerXPosNext+1
    STA.W QuakeSpriteYPosHigh,Y
    LDA.B PlayerYPosNext
    CLC
    ADC.B #$20
    STA.W QuakeSpriteYPosLow,Y
    LDA.B PlayerYPosNext+1
    ADC.B #$00
    STA.W QuakeSpriteYPosHigh,Y
    JSR CODE_029BE4
    PLB
  + RTL

SprBlkInteract:
    LDY.B #$03
CODE_0286EF:
    LDA.W QuakeSpriteNumber,Y
    BEQ CODE_0286F8
    DEY
    BPL CODE_0286EF
    INY
CODE_0286F8:
    LDA.B TouchBlockXPos
    STA.W QuakeSpriteXPosLow,Y
    LDA.B TouchBlockXPos+1
    STA.W QuakeSpriteXPosHigh,Y
    LDA.B TouchBlockYPos
    STA.W QuakeSpriteYPosLow,Y
    LDA.B TouchBlockYPos+1
    STA.W QuakeSpriteYPosHigh,Y
    LDA.W LayerProcessing
    BEQ +
    LDA.B TouchBlockXPos
    SEC
    SBC.B Layer23XRelPos
    STA.W QuakeSpriteXPosLow,Y
    LDA.B TouchBlockXPos+1
    SBC.B Layer23XRelPos+1
    STA.W QuakeSpriteXPosHigh,Y
    LDA.B TouchBlockYPos
    SEC
    SBC.B Layer23YRelPos
    STA.W QuakeSpriteYPosLow,Y
    LDA.B TouchBlockYPos+1
    SBC.B Layer23YRelPos+1
    STA.W QuakeSpriteYPosHigh,Y
  + LDA.B #$01
    STA.W QuakeSpriteNumber,Y
    LDA.B #$06
    STA.W BounceSpriteIntTimer,Y
    RTS


BlockBounceSpeedY:
    db $C0,$00,$00,$40

BlockBounceSpeedX:
    db $00,$40,$C0,$00

DATA_028742:
    db $00,$00,$08,$08

DATA_028746:
    db $00,$08,$00,$08

DATA_02874A:
    db $FB,$FB,$FD,$FD

DATA_02874E:
    db $FF,$01,$FF,$01

CODE_028752:
    LDA.B _4
    CMP.B #$07
    BNE NotBreakable
    LDA.W PlayerTurnLvl                       ; \ Increase points
    ASL A                                     ; |
    ADC.W PlayerTurnLvl                       ; |
    TAX                                       ; |
    LDA.W PlayerScore,X                       ; |
    CLC                                       ; |
    ADC.B #$05                                ; |
    STA.W PlayerScore,X                       ; |
    BCC +                                     ; |
    INC.W PlayerScore+1,X                     ; |
    BNE +                                     ; |
    INC.W PlayerScore+2,X                     ; /
  + LDA.B #$D0                                ; Deflect Mario downward
    STA.B PlayerYSpeed+1                      ; /
    LDA.B #$00                                ; for shatter routine?
    JSL ShatterBlock                          ; Actually break the block
    JSR SprBlkInteract                        ; Handle sprite/block interaction
CODE_028780:
    LDA.B #$02                                ; \ Replace block with "nothing" tile
    STA.B Map16TileGenerate                   ; |
    JSL GenerateTile                          ; /
    RTL


BlockBounce:
    db $00,$03,$00,$00,$01,$07,$00,$04
    db $0A

NotBreakable:
    LDY.B #$03                                ; \ Reset turning block
FindTurningBlkSlot:
    LDA.W BounceSpriteNumber,Y                ; |
    BEQ CODE_028807                           ; |
    DEY                                       ; |
    BPL FindTurningBlkSlot                    ; /
    DEC.W BounceSpriteSlotIdx
    BPL +
    LDA.B #$03
    STA.W BounceSpriteSlotIdx
  + LDY.W BounceSpriteSlotIdx
    LDA.W BounceSpriteNumber,Y                ; \ Branch if not a turn block
    CMP.B #$07                                ; |
    BNE +                                     ; /
    LDA.B TouchBlockXPos                      ; \ Save [$98-$9A]
    PHA                                       ; |
    LDA.B TouchBlockXPos+1                    ; |
    PHA                                       ; |
    LDA.B TouchBlockYPos                      ; |
    PHA                                       ; |
    LDA.B TouchBlockYPos+1                    ; |
    PHA                                       ; /
    LDA.W BounceSpriteXPosLow,Y               ; \ Block Y position = Bounce Y sprite position
    STA.B TouchBlockXPos                      ; |
    LDA.W BounceSpriteXPosHigh,Y              ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.W BounceSpriteYPosLow,Y               ; \ Block X position = Bounce X sprite position
    CLC                                       ; |
    ADC.B #$0C                                ; | (Round to nearest #$10)
    AND.B #$F0                                ; |
    STA.B TouchBlockYPos                      ; |
    LDA.W BounceSpriteYPosHigh,Y              ; |
    ADC.B #$00                                ; |
    STA.B TouchBlockYPos+1                    ; /
    LDA.W BounceSpriteTile,Y                  ; \ Block to generate = Bounce sprite block
    STA.B Map16TileGenerate                   ; /
    LDA.B _4                                  ; \ Save [$04-$07]
    PHA                                       ; |
    LDA.B _5                                  ; |
    PHA                                       ; |
    LDA.B _6                                  ; |
    PHA                                       ; |
    LDA.B _7                                  ; |
    PHA                                       ; /
    JSL GenerateTile
    PLA                                       ; \ Restore [$04-$07]
    STA.B _7                                  ; |
    PLA                                       ; |
    STA.B _6                                  ; |
    PLA                                       ; |
    STA.B _5                                  ; |
    PLA                                       ; |
    STA.B _4                                  ; /
    PLA                                       ; \ Restore [$98-$9A]
    STA.B TouchBlockYPos+1                    ; |
    PLA                                       ; |
    STA.B TouchBlockYPos                      ; |
    PLA                                       ; |
    STA.B TouchBlockXPos+1                    ; |
    PLA                                       ; |
    STA.B TouchBlockXPos                      ; /
  + LDY.W BounceSpriteSlotIdx
CODE_028807:
    LDA.B _4
    CMP.B #$10
    BCC CODE_028818
    STZ.B _4
    TAX
    LDA.W CODE_028780,X
    STA.W BounceSpriteYXPPCCCT,Y
    BRA CODE_02882A

CODE_028818:
    LDA.B _4                                  ; \ Play on/off sound if appropriate
    CMP.B #$05                                ; |
    BNE +                                     ; |
    LDX.B #!SFX_SWITCH                        ; |
    STX.W SPCIO0                              ; /
  + TAX
    LDA.W BlockBounce,X
    STA.W BounceSpriteYXPPCCCT,Y
CODE_02882A:
    LDA.B _4                                  ; \ Set block bounce sprite type
    INC A                                     ; |
    STA.W BounceSpriteNumber,Y                ; /
    LDA.B #$00                                ; \ set (times can be hit?)
    STA.W BounceSpriteInit,Y                  ; /
    LDA.B TouchBlockXPos                      ; \ Set bounce block y position
    STA.W BounceSpriteXPosLow,Y               ; |
    LDA.B TouchBlockXPos+1                    ; |
    STA.W BounceSpriteXPosHigh,Y              ; /
    LDA.B TouchBlockYPos                      ; \ Set bounce block x position
    STA.W BounceSpriteYPosLow,Y               ; |
    LDA.B TouchBlockYPos+1                    ; |
    STA.W BounceSpriteYPosHigh,Y              ; /
    LDA.W LayerProcessing
    LSR A
    ROR A
    STA.B _8
    LDX.B _6
    %LorW_X(LDA,BlockBounceSpeedY)            ; \ Set bounce y speed
    STA.W BounceSpriteYSpeed,Y                ; /
    %LorW_X(LDA,BlockBounceSpeedX)            ; \ Set bounce x speed
    STA.W BounceSpriteXSpeed,Y                ; /
    TXA
    ORA.B _8
    STA.W BounceSpriteFlags,Y
    LDA.B _7                                  ; \ Set tile to turn block into
    STA.W BounceSpriteTile,Y                  ; /
    LDA.B #$08                                ; \ Time to show bouncing block
    STA.W BounceSpriteTimer,Y
    LDA.W BounceSpriteNumber,Y
    CMP.B #$07
    BNE +
    LDA.B #$FF
    STA.W TurnBlockSpinTimer,Y
  + JSR SprBlkInteract
CODE_02887D:
    LDA.B _5
    BEQ Return0288A0
    CMP.B #$0A
    BNE +
  + LDA.B _5
    CMP.B #$08
    BCS CODE_0288DC
    CMP.B #$06
    BCC CODE_0288DC
    CMP.B #$07
    BNE CODE_02889D
    LDA.W MulticoinTimer
    BNE CODE_02889D
    LDA.B #$FF
    STA.W MulticoinTimer
CODE_02889D:
    JSR CODE_028A66
Return0288A0:
    RTL


DATA_0288A1:
    db $35,$78

SpriteInBlock:
    db $00,$74,$75,$76,$77,$78,$00,$00
    db $79,$00,$3E,$7D,$2C,$04,$81,$45
    db $80

    db $00,$74,$75,$76,$77,$78,$00,$00
    db $79,$00,$3E,$7D,$2C,$04,$81,$45
    db $80

StatusOfSprInBlk:
    db $00,$08,$08,$08,$08,$08,$00,$00
    db $08,$00,$09,$08,$09,$09,$08,$08
    db $09

DATA_0288D6:
    db $80,$7E,$7D

DATA_0288D9:
    db $09,$08,$08

CODE_0288DC:
    LDY.B _5
    CPY.B #$0B
    BNE CODE_0288EA
    LDA.B TouchBlockXPos
    AND.B #$30
    CMP.B #$20
    BEQ GenSpriteFromBlk
CODE_0288EA:
    CPY.B #$10
    BEQ CODE_0288FD
    CPY.B #$08
    BNE CODE_0288F9
    LDA.W SpriteMemorySetting
    BEQ GenSpriteFromBlk
    BNE CODE_0288FD
CODE_0288F9:
    CPY.B #$0C
    BNE GenSpriteFromBlk
CODE_0288FD:
    JSL FindFreeSprSlot
    TYX
    BPL CODE_028922
    RTL

GenSpriteFromBlk:
    LDX.B #$0B                                ; \ Find a last free sprite slot from 00-0B
CODE_028907:
    LDA.W SpriteStatus,X                      ; |
    BEQ CODE_028922                           ; |
    DEX                                       ; |
    CPX.B #$FF                                ; |
    BNE CODE_028907                           ; /
    DEC.W SpriteToOverwrite
    BPL +
    LDA.B #$01
    STA.W SpriteToOverwrite
  + LDA.W SpriteToOverwrite
    CLC
    ADC.B #$0A
    TAX
CODE_028922:
    STX.W TileGenerateTrackA
    LDY.B _5
    LDA.W StatusOfSprInBlk,Y                  ; \ Set sprite status
    STA.W SpriteStatus,X                      ; /
    LDA.W YoshiIsLoose
    BEQ +
    TYA
    CLC
    ADC.B #$11
    TAY
  + STY.W SpriteInterIndex
    LDA.W SpriteInBlock,Y                     ; \ Set sprite number
    STA.B SpriteNumber,X                      ; /
    STA.B _E
    LDY.B #!SFX_ITEMBLOCK
    CMP.B #$81
    BCS +
    CMP.B #$79
    BCC +
    INY
  + STY.W SPCIO3                              ; / Play sound effect
    JSL InitSpriteTables
    INC.W SpriteOffscreenX,X
    LDA.B SpriteNumber,X
    CMP.B #$45
    BNE CODE_028972
    LDA.W DirectCoinInit
    BEQ +
    STZ.W SpriteStatus,X
    JMP CODE_02889D

  + LDA.B #!BGM_PSWITCH
    STA.W SPCIO2                              ; / Change music
    INC.W DirectCoinInit
    STZ.W DirectCoinTimer
CODE_028972:
    LDA.B TouchBlockXPos
    STA.B SpriteXPosLow,X
    LDA.B TouchBlockXPos+1
    STA.W SpriteXPosHigh,X
    LDA.B TouchBlockYPos
    STA.B SpriteYPosLow,X
    LDA.B TouchBlockYPos+1
    STA.W SpriteYPosHigh,X
    LDA.W LayerProcessing
    BEQ +
    LDA.B TouchBlockXPos
    SEC
    SBC.B Layer23XRelPos
    STA.B SpriteXPosLow,X
    LDA.B TouchBlockXPos+1
    SBC.B Layer23XRelPos+1
    STA.W SpriteXPosHigh,X
    LDA.B TouchBlockYPos
    SEC
    SBC.B Layer23YRelPos
    STA.B SpriteYPosLow,X
    LDA.B TouchBlockYPos+1
    SBC.B Layer23YRelPos+1
    STA.W SpriteYPosHigh,X
  + LDA.B SpriteNumber,X
    CMP.B #$7D
    BNE CODE_0289D3
    LDA.B SpriteXPosLow,X
    AND.B #$30
    LSR A
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_0288D9,Y
    STA.W SpriteStatus,X
    LDA.W DATA_0288D6,Y
    STA.B SpriteNumber,X
    PHA
    JSL InitSpriteTables
    PLA
    CMP.B #$7D
    BNE +
    INC.W SpriteMisc157C,X
    RTL

  + CMP.B #$7E
    BEQ CODE_028A03
    BRA CODE_028A01

CODE_0289D3:
    CMP.B #$04
    BEQ ADDR_028A08
    CMP.B #$3E
    BEQ CODE_028A2A
    CMP.B #$2C
    BNE CODE_028A11
    LDY.B #$0B
CODE_0289E1:
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BCC CODE_0289F3
    LDA.W SpriteNumber,Y
    CMP.B #$2D
    BNE CODE_0289F3
CODE_0289EF:
    LDY.B #$01
    BRA CODE_0289FB

CODE_0289F3:
    DEY
    BPL CODE_0289E1
    LDY.W YoshiIsLoose
    BNE CODE_0289EF
CODE_0289FB:
    LDA.W DATA_0288A1,Y
    STA.W SpriteMisc151C,X
CODE_028A01:
    BRA CODE_028A0D

CODE_028A03:
    INC.B SpriteTableC2,X
    INC.B SpriteTableC2,X
    RTL

ADDR_028A08:
    LDA.B #$FF
    STA.W SpriteMisc1540,X
CODE_028A0D:
    LDA.B #$D0
    BRA +

CODE_028A11:
    LDA.B #$3E
    STA.W SpriteMisc1540,X
    LDA.B #$D0
  + STA.B SpriteYSpeed,X
    LDA.B #$2C
    STA.W SpriteMisc154C,X
    LDA.W SpriteTweakerF,X
    BPL +
    LDA.B #$10
    STA.W SpriteMisc15AC,X
  + RTL

CODE_028A2A:
    LDA.B SpriteXPosLow,X
    LSR A
    LSR A
    LSR A
    LSR A
    AND.B #$01
    STA.W SpriteMisc151C,X
    TAY
    LDA.W DATA_028A42,Y
    STA.W SpriteOBJAttribute,X
    JSL CODE_028A44
    BRA CODE_028A0D


DATA_028A42:
    db $06,$02

CODE_028A44:
    PHX
    LDX.B #$03
CODE_028A47:
    LDA.W SmokeSpriteNumber,X
    BEQ CODE_028A50
    DEX
    BPL CODE_028A47
    INX
CODE_028A50:
    LDA.B #$01
    STA.W SmokeSpriteNumber,X
    LDA.B TouchBlockYPos
    STA.W SmokeSpriteYPos,X
    LDA.B TouchBlockXPos
    STA.W SmokeSpriteXPos,X
    LDA.B #$1B
    STA.W SmokeSpriteTimer,X
    PLX
    RTL

CODE_028A66:
    LDX.B #$03
CODE_028A68:
    LDA.W CoinSpriteExists,X
    BEQ CODE_028A7D
    DEX
    BPL CODE_028A68
    DEC.W CoinSpriteSlotIdx
    BPL +
    LDA.B #$03
    STA.W CoinSpriteSlotIdx
  + LDX.W CoinSpriteSlotIdx
CODE_028A7D:
    JSL CODE_05B34A
    INC.W CoinSpriteExists,X
    LDA.B TouchBlockXPos
    STA.W CoinSpriteXPosLow,X
    LDA.B TouchBlockXPos+1
    STA.W CoinsPriteXPosHigh,X
    LDA.B TouchBlockYPos
    SEC
    SBC.B #$10
    STA.W CoinSpriteYPosLow,X
    LDA.B TouchBlockYPos+1
    SBC.B #$00
    STA.W CoinSpriteYPosHigh,X
    LDA.W LayerProcessing
    STA.W CoinSpriteLayer,X
    LDA.B #$D0
    STA.W CoinSpriteYSpeed,X
    RTS


DATA_028AA9:
    db $07,$03,$03,$01,$01,$01,$01,$01

CODE_028AB1:
    PHB
    PHK
    PLB
    LDA.W GivePlayerLives
    BEQ CODE_028AD5
    LDA.W GiveLivesTimer
    BEQ CODE_028AC3
    DEC.W GiveLivesTimer
    BRA CODE_028AD5

CODE_028AC3:
    DEC.W GivePlayerLives
    BEQ +
    LDA.B #$23
    STA.W GiveLivesTimer
  + LDA.B #!SFX_1UP                           ; \ Play sound effect
    STA.W SPCIO3                              ; /
    INC.W PlayerLives
CODE_028AD5:
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario doesn't have star
    BEQ CODE_028AEB                           ; /
    CMP.B #$08
    BCC CODE_028AEB
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    TAY
    LDA.B TrueFrame
    AND.W DATA_028AA9,Y
    BRA CODE_028AF5

CODE_028AEB:
    LDA.W PlayerSparkleTimer
    BEQ +
    DEC.W PlayerSparkleTimer
    AND.B #$01
CODE_028AF5:
    ORA.B PlayerXPosScrRel+1
    ORA.B PlayerYPosScrRel+1
    BNE +
    LDA.B PlayerYPosScrRel
    CMP.B #$D0
    BCS +
    JSL CODE_02858F
  + JSR CODE_028B67
    JSR CODE_02902D
    JSR ScoreSprGfx
    JSR CODE_029B0A
    JSR CODE_0299D2
    JSR CODE_02B387
    JSR CallGenerator
    JSR CODE_0294F5
    JSR LoadSprFromLevel
    LDA.W SpriteRespawnTimer                  ; \ Return if timer not set
    BEQ +                                     ; /
    LDA.B TrueFrame                           ; \ Decrement every other frame...
    AND.B #$01                                ; |
    ORA.B SpriteLock                          ; | ...as long as sprites not locked...
    ORA.W SpriteWillAppear
    BNE +                                     ; |
    DEC.W SpriteRespawnTimer                  ; /
    BNE +                                     ; Return if the timer hasn't just run out
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BMI +                                     ; /
    TYX
    LDA.B #$01                                ; \ Sprite status = Initialization
    STA.W SpriteStatus,X                      ; /
    LDA.W SpriteRespawnNumber                 ; \ Sprite = Sprite to respwan
    STA.B SpriteNumber,X                      ; /
    LDA.B Layer1XPos
    SEC
    SBC.B #$20
    AND.B #$EF
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    SBC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.W SpriteRespawnYPos
    STA.B SpriteYPosLow,X
    LDA.W SpriteRespawnYPos+1
    STA.W SpriteYPosHigh,X
    JSL InitSpriteTables                      ; Reset sprite tables
  + PLB
    RTL

CODE_028B67:
    LDX.B #$0B
CODE_028B69:
    LDA.W MinExtSpriteNumber,X
    BEQ +
    STX.W MinorSpriteProcIndex
    JSR CODE_028B94
  + DEX
    BPL CODE_028B69
Return028B77:
    RTS


BrokenBlock:
    db $50,$54,$58,$5C,$60,$64,$68,$6C
    db $70,$74,$78,$7C

BrokenBlock2:
    db $3C,$3D,$3D,$3C,$3C,$3D,$3D,$3C
DATA_028B8C:
    db $00,$00,$80,$80,$80,$C0,$40,$00

CODE_028B94:
    JSL ExecutePtr

    dw Return028B77
    dw CODE_028F8B
    dw CODE_028ED2
    dw CODE_028E7E
    dw CODE_028F2F
    dw CODE_028ED2
    dw CODE_028DDB
    dw CODE_028D4F
    dw CODE_028DDB
    dw CODE_028DDB
    dw CODE_028CC4
    dw ADDR_028C0F

DisabledAddSmokeRt:
    PHB                                       ; \ This routine does nothing at all
    PHK                                       ; | I believe it used to call the below
    PLB                                       ; | routine to add smoke when boarding
    JSR Return028BB8                          ; | Yoshi
    PLB                                       ; |
    RTL                                       ; /

Return028BB8:
    RTS

    STZ.B _0                                  ; \ Display smoke when getting on Yoshi
    JSR ADDR_028BC0                           ; |
    INC.B _0                                  ; |
ADDR_028BC0:
    LDY.B #$0B                                ; |
ADDR_028BC2:
    LDA.W MinExtSpriteNumber,Y                ; |
    BEQ ADDR_028BCB                           ; |
    DEY                                       ; |
    BPL ADDR_028BC2                           ; |
    RTS                                       ; /

ADDR_028BCB:
    LDA.B #$0B
    STA.W MinExtSpriteNumber,Y
    LDA.B #$00
    STA.W MinExtSpriteTimer,Y
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$1C
    STA.W MinExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W MinExtSpriteYPosHigh,Y
    LDA.B PlayerXPosNext
    STA.B _2
    LDA.B PlayerXPosNext+1
    STA.B _3
    PHX
    LDX.B _0
    LDA.W DATA_028C09,X
    STA.W MinExtSpriteXSpeed,Y
    LDA.B _2
    CLC
    ADC.W DATA_028C0B,X
    STA.W MinExtSpriteXPosLow,Y
    LDA.B _3
    ADC.W DATA_028C0D,X
    STA.W MinExtSpriteXPosHigh,Y
    PLX
    RTS


DATA_028C09:
    db $40,$C0

DATA_028C0B:
    db $0C,$FC

DATA_028C0D:
    db $00,$FF

ADDR_028C0F:
    LDA.W MinExtSpriteTimer,X
    BNE ADDR_028C61
    LDA.W MinExtSpriteXSpeed,X
    BEQ ADDR_028C66
    BPL ADDR_028C20
    CLC
    ADC.B #$08
    BRA +

ADDR_028C20:
    SEC
    SBC.B #$08
  + STA.W MinExtSpriteXSpeed,X
    JSR CODE_02B5BC
    TXA
    EOR.B TrueFrame
    AND.B #$03
    BNE Return028C60
    LDY.B #$0B
ADDR_028C32:
    LDA.W MinExtSpriteNumber,Y
    BEQ ADDR_028C3B
    DEY
    BPL ADDR_028C32
    RTS

ADDR_028C3B:
    LDA.B #$0B
    STA.W MinExtSpriteNumber,Y
    STA.W MinExtSpriteYSpeed,Y
    LDA.W MinExtSpriteXPosLow,X
    STA.W MinExtSpriteXPosLow,Y
    LDA.W MinExtSpriteXPosHigh,X
    STA.W MinExtSpriteXPosHigh,Y
    LDA.W MinExtSpriteYPosLow,X
    STA.W MinExtSpriteYPosLow,Y
    LDA.W MinExtSpriteYPosHigh,X
    STA.W MinExtSpriteYPosHigh,Y
    LDA.B #$10
    STA.W MinExtSpriteTimer,Y
Return028C60:
    RTS

ADDR_028C61:
    DEC.W MinExtSpriteTimer,X
    BNE +
ADDR_028C66:
    STZ.W MinExtSpriteNumber,X
    RTS


DATA_028C6A:
    db $66,$66,$64,$62

  + LDY.W BrokenBlock,X
    LDA.W MinExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.W MinExtSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BNE ADDR_028C66
    LDA.W MinExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    LDA.W MinExtSpriteYPosHigh,X
    SBC.B Layer1YPos+1
    BNE ADDR_028C66
    LDA.B _0
    STA.W OAMTileXPos,Y
    LDA.B _1
    STA.W OAMTileYPos,Y
    PHX
    LDA.W MinExtSpriteTimer,X
    LSR A
    LSR A
    TAX
    LDA.W DATA_028C6A,X
    STA.W OAMTileNo,Y
    PLX
    LDA.B SpriteProperties
    ORA.B #$08
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    RTS


BooStreamTiles:
    db $88,$A8,$AA,$8C,$8E,$AE,$88,$A8
    db $AA,$8C,$8E,$AE

CODE_028CC4:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_028CFF                           ; /
    LDA.W MinExtSpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.B _4
    LDA.W MinExtSpriteXPosHigh,X
    ADC.B #$00
    STA.B _A
    LDA.W MinExtSpriteYPosLow,X
    CLC
    ADC.B #$04
    STA.B _5
    LDA.W MinExtSpriteYPosHigh,X
    ADC.B #$00
    STA.B _B
    LDA.B #$08
    STA.B _6
    STA.B _7
    JSL GetMarioClipping
    JSL CheckForContact
    BCC +
    JSL HurtMario
  + DEC.W MinExtSpriteTimer,X
    BEQ CODE_028D62
CODE_028CFF:
    LDY.W BrokenBlock,X
    LDA.W MinExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.W MinExtSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BNE Return028D41
    LDA.B _0
    STA.W OAMTileXPos,Y
    LDA.W MinExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$F0
    BCS CODE_028D62
    STA.W OAMTileYPos,Y
    LDA.W BooStreamTiles,X
    STA.W OAMTileNo,Y
    LDA.W MinExtSpriteXSpeed,X
    LSR A
    AND.B #$40
    EOR.B #$40
    ORA.B SpriteProperties
    ORA.B #$0F
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
Return028D41:
    RTS


WaterSplashTiles:
    db $68,$68,$6A,$6A,$6A,$62,$62,$62
    db $64,$64,$64,$64,$66

CODE_028D4F:
    LDA.W MinExtSpriteXPosLow,X
    CMP.B Layer1XPos
    LDA.W MinExtSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BNE CODE_028D62
    LDA.W MinExtSpriteTimer,X
    CMP.B #$20
    BNE +
CODE_028D62:
    STZ.W MinExtSpriteNumber,X
    RTS

  + STZ.B _0
    CMP.B #$10
    BCC CODE_028D8B
    AND.B #$01
    ORA.B SpriteLock
    BNE +
    INC.W MinExtSpriteYPosLow,X
  + LDA.W MinExtSpriteTimer,X
    SEC
    SBC.B #$10
    LSR A
    LSR A
    STA.B _2
    LDA.B TrueFrame
    LSR A
    LDA.B _2
    BCC +
    EOR.B #$FF
    INC A
  + STA.B _0
CODE_028D8B:
    LDY.W BrokenBlock,X
    LDA.W MinExtSpriteXPosLow,X
    CLC
    ADC.B _0
    SEC
    SBC.B Layer1XPos
    CMP.B #$F0
    BCS CODE_028D62
    STA.W OAMTileXPos,Y
    LDA.W MinExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$E8
    BCS CODE_028D62
    STA.W OAMTileYPos,Y
    LDA.W MinExtSpriteTimer,X
    LSR A
    TAX
    CPX.B #$0C
    BCC +
    LDX.B #$0C
  + %LorW_X(LDA,WaterSplashTiles)
    LDX.W MinorSpriteProcIndex
    STA.W OAMTileNo,Y
    LDA.B SpriteProperties
    ORA.B #$02
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    INC.W MinExtSpriteTimer,X
  + RTS


RipVanFishZsTiles:
    db $F1,$F0,$E1,$E0

CODE_028DDB:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_028E20                           ; /
    LDA.W MinExtSpriteTimer,X
    BEQ +
    DEC.W MinExtSpriteTimer,X
  + LDA.W MinExtSpriteTimer,X
    AND.B #$00
    BNE +
    LDA.W MinExtSpriteTimer,X
    INC.W MinExtSpriteXSpeed,X
    AND.B #$10
    BNE +
    DEC.W MinExtSpriteXSpeed,X
    DEC.W MinExtSpriteXSpeed,X
  + LDA.W MinExtSpriteXSpeed,X
    PHA
    LDY.W MinExtSpriteNumber,X
    CPY.B #$09
    BNE +
    EOR.B #$FF
    INC A
    STA.W MinExtSpriteXSpeed,X
  + JSR CODE_02B5BC
    PLA
    STA.W MinExtSpriteXSpeed,X
    LDA.W MinExtSpriteTimer,X
    AND.B #$03
    BNE CODE_028E20
    DEC.W MinExtSpriteYPosLow,X
CODE_028E20:
    LDY.W BrokenBlock,X
    LDA.W MinExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$08
    BCC CODE_028E76
    CMP.B #$FC
    BCS CODE_028E76
    STA.W OAMTileXPos,Y
    LDA.W MinExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$F0
    BCS CODE_028E76
    STA.W OAMTileYPos,Y
    LDA.B SpriteProperties
    ORA.B #$03
    STA.W OAMTileAttr,Y
    LDA.W MinExtSpriteTimer,X
    CMP.B #$14
    BEQ CODE_028E76
    LDA.W MinExtSpriteNumber,X
    CMP.B #$08
    LDA.B #$7F
    BCS +
    LDA.W MinExtSpriteTimer,X
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    AND.B #$03
    TAX
    %LorW_X(LDA,RipVanFishZsTiles)
  + STA.W OAMTileNo,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    LDX.W MinorSpriteProcIndex
    RTS

CODE_028E76:
    STZ.W MinExtSpriteNumber,X
    RTS


    db $03,$43,$83,$C3

CODE_028E7E:
    DEC.W MinExtSpriteTimer,X
    LDA.W MinExtSpriteTimer,X
    AND.B #$3F
    BEQ CODE_028ED7
    JSR CODE_02B5BC
    JSR CODE_02B5C8
    INC.W MinExtSpriteYSpeed,X
    INC.W MinExtSpriteYSpeed,X
    LDY.W BrokenBlock,X
    LDA.W MinExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$F0
    BCS CODE_028ED7
    STA.W OAMTileYPos,Y
    LDA.W MinExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$F8
    BCS CODE_028ED7
    STA.W OAMTileXPos,Y
    LDA.B #$6F
    STA.W OAMTileNo,Y
    LDA.W MinExtSpriteTimer,X
    AND.B #$C0
    ORA.B #$03
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    RTS


StarSparkleTiles:
    db $66,$6E,$FF,$6D,$6C,$5C

CODE_028ED2:
    LDA.W MinExtSpriteTimer,X
    BNE +
CODE_028ED7:
    JMP CODE_028F87

  + LDY.B SpriteLock
    BNE +
    DEC.W MinExtSpriteTimer,X
  + LDY.W BrokenBlock,X
    LDA.W MinExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$F0
    BCS CODE_028ED7
    STA.W OAMTileXPos,Y
    LDA.W MinExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$F0
    BCS CODE_028ED7
    STA.W OAMTileYPos,Y
    LDA.W MinExtSpriteNumber,X
    PHA
    LDA.W MinExtSpriteTimer,X
    LSR A
    LSR A
    LSR A
    TAX
    PLA
    CMP.B #$05
    BNE +
    INX
    INX
    INX
  + %LorW_X(LDA,StarSparkleTiles)
    STA.W OAMTileNo,Y
    LDA.B SpriteProperties
    ORA.B #$06
    STA.W OAMTileAttr,Y
    LDX.W MinorSpriteProcIndex
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    RTS


LavaSplashTiles:
    db $D7,$C7,$D6,$C6

CODE_028F2F:
    LDA.W MinExtSpriteXPosLow,X
    CMP.B Layer1XPos
    LDA.W MinExtSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BNE CODE_028F87
    LDA.W MinExtSpriteTimer,X
    BEQ CODE_028F87
    LDY.B SpriteLock
    BNE +
    DEC.W MinExtSpriteTimer,X
    JSR CODE_02B5C8
    INC.W MinExtSpriteYSpeed,X
  + LDY.W BrokenBlock,X
    LDA.W MinExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos,Y
    LDA.W MinExtSpriteYPosLow,X
    CMP.B #$F0
    BCS CODE_028F87
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos,Y
    LDA.W MinExtSpriteTimer,X
    LSR A
    LSR A
    LSR A
    TAX
    %LorW_X(LDA,LavaSplashTiles)
    STA.W OAMTileNo,Y
    LDA.B SpriteProperties
    ORA.B #$05
    STA.W OAMTileAttr,Y
    LDX.W MinorSpriteProcIndex
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    RTS

CODE_028F87:
    STZ.W MinExtSpriteNumber,X
    RTS

CODE_028F8B:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_028FCA                           ; /
    LDA.B TrueFrame
    AND.B #$03
    BEQ CODE_028FAB
    LDY.B #$00
    LDA.W MinExtSpriteXSpeed,X
    BPL +
    DEY
  + CLC
    ADC.W MinExtSpriteXPosLow,X
    STA.W MinExtSpriteXPosLow,X
    TYA
    ADC.W MinExtSpriteXPosHigh,X
    STA.W MinExtSpriteXPosHigh,X
CODE_028FAB:
    LDY.B #$00
    LDA.W MinExtSpriteYSpeed,X
    BPL +
    DEY
  + CLC
    ADC.W MinExtSpriteYPosLow,X
    STA.W MinExtSpriteYPosLow,X
    TYA
    ADC.W MinExtSpriteYPosHigh,X
    STA.W MinExtSpriteYPosHigh,X
    LDA.B TrueFrame
    AND.B #$03
    BNE CODE_028FCA
    INC.W MinExtSpriteYSpeed,X
CODE_028FCA:
    LDA.W MinExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _0
    LDA.W MinExtSpriteYPosHigh,X
    SBC.B Layer1YPos+1
    BEQ CODE_028FDD
    BPL CODE_028F87
    BMI Return02902C
CODE_028FDD:
    LDY.W BrokenBlock,X
    LDA.W MinExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _1
    LDA.W MinExtSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BNE CODE_028F87
    LDA.B _1
    STA.W OAMTileXPos,Y
    LDA.B _0
    CMP.B #$F0
    BCS CODE_028F87
    STA.W OAMTileYPos,Y
    LDA.W MinExtSpriteTimer,X
    PHA
    LDA.B EffFrame
    LSR A
    CLC
    ADC.W MinorSpriteProcIndex
    AND.B #$07
    TAX
    %LorW_X(LDA,BrokenBlock2)
    STA.W OAMTileNo,Y
    PLA
    BEQ +
    LDA.B TrueFrame
    AND.B #$0E
  + %LorW_X(EOR,DATA_028B8C)
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    LDX.W MinorSpriteProcIndex
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
Return02902C:
    RTS

CODE_02902D:
    LDA.W MulticoinTimer
    CMP.B #$02
    BCC +
    LDA.B SpriteLock
    BNE +
    DEC.W MulticoinTimer
  + LDX.B #$03
  - STX.W MinorSpriteProcIndex
    JSR CODE_02904D
    JSR CODE_029398
    JSR CODE_0296C0
    DEX
    BPL -
Return02904C:
    RTS

CODE_02904D:
    LDA.W BounceSpriteNumber,X
    BEQ Return02904C
    LDY.B SpriteLock
    BNE +
    LDY.W BounceSpriteTimer,X                 ; \ Decrement bounce sprite timer if > 0
    BEQ +
    DEC.W BounceSpriteTimer,X
  + JSL ExecutePtr

    dw Return02904C                           ; 00 - Nothing (Bypassed above)
    dw BounceBlockSpr                         ; 01 - Turn Block without turn
    dw BounceBlockSpr                         ; 02 - Music Block
    dw BounceBlockSpr                         ; 03 - Question Block
    dw BounceBlockSpr                         ; 04 - Sideways Bounce Block
    dw BounceBlockSpr                         ; 05 - Translucent Block
    dw BounceBlockSpr                         ; 06 - On/Off Block
    dw TurnBlockSpr                           ; 07 - Turn Block

DATA_029072:
    db $13,$00,$00,$ED

TurnBlockSpr:
    LDA.B SpriteLock                          ; \ Return if sprites locked
    BNE Return0290CD                          ; /
    LDA.W BounceSpriteInit,X                  ; \ Initialize only once
    BNE +                                     ; | (Generate invisible tile sprite)
    INC.W BounceSpriteInit,X                  ; |
    JSR InvisSldFromBncSpr                    ; /
  + LDA.W BounceSpriteTimer,X
    BEQ CODE_0290BB
    CMP.B #$01
    BNE CODE_0290A8
    LDA.W BounceSpriteYPosLow,X
    CLC
    ADC.B #$08
    AND.B #$F0
    STA.W BounceSpriteYPosLow,X
    LDA.W BounceSpriteYPosHigh,X
    ADC.B #$00
    STA.W BounceSpriteYPosHigh,X
    LDA.B #$05
    JSR TileFromBounceSpr1
    BRA CODE_0290BB

CODE_0290A8:
    JSR CODE_02B526
    LDY.W BounceSpriteFlags,X
    LDA.W BounceSpriteYSpeed,X
    CLC
    ADC.W DATA_029072,Y
    STA.W BounceSpriteYSpeed,X
    JSR BounceSprGfx
CODE_0290BB:
    LDA.W TurnBlockSpinTimer,X
    BEQ +
    DEC.W TurnBlockSpinTimer,X
    RTS

  + LDA.W BounceSpriteTile,X
    JSR TileFromBounceSpr1
    STZ.W BounceSpriteNumber,X
Return0290CD:
    RTS


DATA_0290CE:
    db $10,$00,$00,$F0

DATA_0290D2:
    db $00,$F0,$10,$00

DATA_0290D6:
    db $80,$80,$80,$00

DATA_0290DA:
    db $80,$E0,$20,$80

BounceBlockSpr:
    JSR BounceSprGfx
    LDA.B SpriteLock
    BNE Return0290CD
    LDA.W BounceSpriteInit,X
    BNE CODE_02910B
    INC.W BounceSpriteInit,X
    JSR CODE_029265
    JSR InvisSldFromBncSpr
    LDA.W BounceSpriteFlags,X
    AND.B #$03
    TAY
    LDA.W DATA_0290D6,Y
    CMP.B #$80
    BEQ +
    STA.B PlayerYSpeed+1
  + LDA.W DATA_0290DA,Y
    CMP.B #$80
    BEQ CODE_02910B
    STA.B PlayerXSpeed+1
CODE_02910B:
    JSR CODE_02B526
    JSR CODE_02B51A
    LDA.W BounceSpriteFlags,X
    AND.B #$03
    TAY
    LDA.W BounceSpriteYSpeed,X
    CLC
    ADC.W DATA_0290CE,Y
    STA.W BounceSpriteYSpeed,X
    LDA.W BounceSpriteXSpeed,X
    CLC
    ADC.W DATA_0290D2,Y
    STA.W BounceSpriteXSpeed,X
    LDA.W BounceSpriteFlags,X
    AND.B #$03
    CMP.B #$03
    BNE CODE_02915E
    LDA.B PlayerAnimation
    CMP.B #$01
    BCS CODE_02915E
    LDA.B #$20
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$30
  + STA.B _0
    LDA.W BounceSpriteYPosLow,X
    SEC
    SBC.B _0
    STA.B PlayerYPosNext
    LDA.W BounceSpriteYPosHigh,X
    SBC.B #$00
    STA.B PlayerYPosNext+1
    LDA.B #$01
    STA.W StandOnSolidSprite
    STA.W NoteBlockActive
    STZ.B PlayerYSpeed+1
CODE_02915E:
    LDA.W BounceSpriteTimer,X
    BNE Return02919C
    LDA.W BounceSpriteFlags,X
    AND.B #$03
    CMP.B #$03
    BNE +
    LDA.B #$A0
    STA.B PlayerYSpeed+1
    LDA.B PlayerYPosNext
    SEC
    SBC.B #$02
    STA.B PlayerYPosNext
    LDA.B PlayerYPosNext+1
    SBC.B #$00
    STA.B PlayerYPosNext+1
    LDA.B #!SFX_SPRING                        ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + JSR TileFromBounceSpr0
    LDY.W BounceSpriteNumber,X
    CPY.B #$06
    BCC +
    LDA.B #!SFX_SWITCH                        ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.W OnOffSwitch                         ; \ Toggle On/Off
    EOR.B #$01                                ; |
    STA.W OnOffSwitch                         ; /
  + STZ.W BounceSpriteNumber,X
Return02919C:
    RTS


    db $01,$00

TileFromBounceSpr0:
    LDA.W BounceSpriteTile,X                  ; \ If doesn't turn into multiple coin block,
    CMP.B #$0A                                ; |
    BEQ CODE_0291AA                           ; |
    CMP.B #$0B                                ; |
    BNE +                                     ; / Block to generate = Bounce sprite block to turn into
CODE_0291AA:
    LDY.W MulticoinTimer
    CPY.B #$01
    BNE +
    STZ.W MulticoinTimer
    LDA.B #$0D                                ; Block to generate = Used block
  + BRA TileFromBounceSpr1

InvisSldFromBncSpr:
    LDA.B #$09                                ; Block to generate = Invisible solid
TileFromBounceSpr1:
    STA.B Map16TileGenerate                   ; Set block to generate
    LDA.W BounceSpriteXPosLow,X               ; \ Block Y position = Bounce sprite Y position
    CLC                                       ; |
    ADC.B #$08                                ; | (Rounded to nearest #$10)
    AND.B #$F0                                ; |
    STA.B TouchBlockXPos                      ; |
    LDA.W BounceSpriteXPosHigh,X              ; |
    ADC.B #$00                                ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.W BounceSpriteYPosLow,X               ; \ Block X position = Bounce sprite X position
    CLC                                       ; |
    ADC.B #$08                                ; | (Rounded to nearest #$10)
    AND.B #$F0                                ; |
    STA.B TouchBlockYPos                      ; |
    LDA.W BounceSpriteYPosHigh,X              ; |
    ADC.B #$00                                ; |
    STA.B TouchBlockYPos+1                    ; /
    LDA.W BounceSpriteFlags,X
    ASL A
    ROL A
    AND.B #$01
    STA.W LayerProcessing
    JSL GenerateTile
Return0291EC:
    RTS


DATA_0291ED:
    db $10,$14,$18

BounceSpriteTiles:
    db $1C,$40,$6B,$2A,$42,$EA,$8A,$40

BounceSprGfx:
    LDY.B #$00
    LDA.W BounceSpriteFlags,X
    BPL +
    LDY.B #$04
  + LDA.W Layer1YPos,Y
    STA.B _2
    LDA.W Layer1XPos,Y
    STA.B _3
    LDA.W Layer1YPos+1,Y
    STA.B _4
    LDA.W Layer1XPos+1,Y
    STA.B _5
    LDA.W BounceSpriteYPosLow,X
    CMP.B _2
    LDA.W BounceSpriteYPosHigh,X
    SBC.B _4
    BNE Return0291EC
    LDA.W BounceSpriteXPosLow,X
    CMP.B _3
    LDA.W BounceSpriteXPosHigh,X
    SBC.B _5
    BNE Return0291EC
    LDY.W DATA_0291ED,X
    LDA.W BounceSpriteYPosLow,X
    SEC
    SBC.B _2
    STA.B _1
    STA.W OAMTileYPos,Y
    LDA.W BounceSpriteXPosLow,X
    SEC
    SBC.B _3
    STA.B _0
    STA.W OAMTileXPos,Y
    LDA.W BounceSpriteYXPPCCCT,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    LDA.W BounceSpriteNumber,X
    TAX
    %LorW_X(LDA,BounceSpriteTiles)
    STA.W OAMTileNo,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    LDX.W MinorSpriteProcIndex
    RTS

CODE_029265:
    LDA.B #$01
    LDY.W BounceSpriteFlags,X
    STY.B _F
    BPL +
    ASL A
  + AND.B ScreenMode
    BEQ CODE_0292CA
    LDA.W BounceSpriteYPosLow,X
    SEC
    SBC.B #$03
    AND.B #$F0
    STA.B _0
    LDA.W BounceSpriteYPosHigh,X
    SBC.B #$00
    CMP.B LevelScrLength
    BCS Return0292C9
    STA.B _3
    AND.B #$10
    STA.B _8
    LDA.W BounceSpriteXPosLow,X
    STA.B _1
    LDA.W BounceSpriteXPosHigh,X
    CMP.B #$02
    BCS Return0292C9
    STA.B _2
    LDA.B _1
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _3
    LDA.L DATA_00BA80,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA8E,X
  + CLC
    ADC.B _0
    STA.B _5
    LDA.L DATA_00BABC,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BACA,X
  + ADC.B _2
    STA.B _6
    BRA CODE_02931A

Return0292C9:
    RTS

CODE_0292CA:
    LDA.W BounceSpriteYPosLow,X
    SEC
    SBC.B #$03
    AND.B #$F0
    STA.B _0
    LDA.W BounceSpriteYPosHigh,X
    SBC.B #$00
    CMP.B #$02
    BCS Return0292C9
    STA.B _2
    LDA.W BounceSpriteXPosLow,X
    STA.B _1
    LDA.W BounceSpriteXPosHigh,X
    CMP.B LevelScrLength
    BCS Return0292C9
    STA.B _3
    LDA.B _1
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _3
    LDA.L DATA_00BA60,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA70,X
  + CLC
    ADC.B _0
    STA.B _5
    LDA.L DATA_00BA9C,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BAAC,X
  + ADC.B _2
    STA.B _6
CODE_02931A:
    LDA.B #$7E
    STA.B _7
    LDX.W MinorSpriteProcIndex
    LDA.B [_5]
    STA.W Map16TileNumber
    INC.B _7
    LDA.B [_5]
    BNE +
    LDA.W Map16TileNumber
    CMP.B #$2B
    BNE +
    LDA.W BounceSpriteYPosLow,X
    PHA
    SBC.B #$03
    AND.B #$F0
    STA.W BounceSpriteYPosLow,X
    LDA.W BounceSpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W BounceSpriteYPosHigh,X
    JSR InvisSldFromBncSpr
    JSR ADDR_029356
    PLA
    STA.W BounceSpriteYPosHigh,X
    PLA
    STA.W BounceSpriteYPosLow,X
  + RTS

ADDR_029356:
    LDY.B #$03
ADDR_029358:
    LDA.W CoinSpriteExists,Y
    BEQ ADDR_029361
    DEY
    BPL ADDR_029358
    INY
ADDR_029361:
    LDA.B #$01
    STA.W CoinSpriteExists,Y
    JSL CODE_05B34A
    LDA.W BounceSpriteXPosLow,X
    STA.W CoinSpriteXPosLow,Y
    LDA.W BounceSpriteXPosHigh,X
    STA.W CoinsPriteXPosHigh,Y
    LDA.W BounceSpriteYPosLow,X
    STA.W CoinSpriteYPosLow,Y
    LDA.W BounceSpriteYPosHigh,X
    STA.W CoinSpriteYPosHigh,Y
    LDA.W BounceSpriteFlags,X
    ASL A
    ROL A
    AND.B #$01
    STA.W CoinSpriteLayer,Y
    LDA.B #$D0
    STA.W CoinSpriteYSpeed,Y
Return029391:
    RTS


DATA_029392:
    db $F8,$08

CODE_029394:
    STZ.W QuakeSpriteNumber,X
  - RTS

CODE_029398:
    LDA.W QuakeSpriteNumber,X
    BEQ -
    DEC.W BounceSpriteIntTimer,X
    BEQ CODE_029394
    LDA.W BounceSpriteIntTimer,X
    CMP.B #$03
    BCS Return029391
    LDY.W MinorSpriteProcIndex
    STZ.B _E
CODE_0293AE:
    LDX.B #$0B
CODE_0293B0:
    STX.W CurSpriteProcess
    LDA.W SpriteStatus,X
    CMP.B #$0B
    BEQ CODE_0293F7
    CMP.B #$08
    BCC CODE_0293F7
    LDA.W SpriteTweakerC,X
    AND.B #$20
    ORA.W SpriteOnYoshiTongue,X
    ORA.W SpriteMisc154C,X
    ORA.W SpriteMisc1FE2,X
    BNE CODE_0293F7
    LDA.W SpriteBehindScene,X
    PHY
    LDY.B PlayerIsClimbing
    BEQ +
    EOR.B #$01
  + PLY
    EOR.W PlayerBehindNet
    BNE CODE_0293F7
    JSL GetSpriteClippingA
    LDA.B _E
    BEQ CODE_0293EB
    JSR CODE_029696
    BRA +

CODE_0293EB:
    JSR CODE_029663
  + JSL CheckForContact
    BCC CODE_0293F7
    JSR CODE_029404
CODE_0293F7:
    LDY.W MinorSpriteProcIndex
    DEX
    BMI +
    JMP CODE_0293B0

  + LDX.W MinorSpriteProcIndex
    RTS

CODE_029404:
    LDA.B #$08
    STA.W SpriteMisc154C,X
    LDA.B SpriteNumber,X
    CMP.B #$81
    BNE CODE_029427
    LDA.B SpriteTableC2,X
    BEQ +
    STZ.B SpriteTableC2,X
    LDA.B #$C0
    STA.B SpriteYSpeed,X
    LDA.B #$10
    STA.W SpriteMisc1540,X
    STZ.W SpriteMisc157C,X
    LDA.B #$20
    STA.W SpriteMisc1558,X
  + RTS

CODE_029427:
    CMP.B #$2D
    BEQ CODE_029448
    LDA.W SpriteTweakerD,X
    AND.B #$02
    BNE CODE_0294A2
    LDA.W SpriteStatus,X
    CMP.B #$08
    BEQ CODE_029443
    LDA.B SpriteNumber,X
    CMP.B #$0D
    BEQ CODE_029448
    LDA.B SpriteTableC2,X
    BEQ CODE_029448
CODE_029443:
    LDA.B #$FF
    STA.W SpriteMisc1540,X
CODE_029448:
    STZ.W SpriteMisc1558,X
    LDA.B _E
    CMP.B #$35
    BEQ +
    JSL CODE_01AB6F
  + LDA.B #$00
    JSL GivePoints
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,X                      ; /
    LDA.B SpriteNumber,X
    CMP.B #$1E
    BNE +
    LDA.B #$1F
    STA.W SpriteMisc1540+9
  + LDA.W SpriteTweakerB,X
    AND.B #$80
    BNE CODE_0294A2
    LDA.W SpriteTweakerA,X                    ; \ Branch if can't be jumped on
    AND.B #$10                                ; |
    BEQ CODE_0294A2                           ; /
    LDA.W SpriteTweakerA,X                    ; \ Branch if dies when jumped on
    AND.B #$20                                ; |
    BNE CODE_0294A2                           ; /
    LDA.B #$09                                ; \ Sprite status = Carryable
    STA.W SpriteStatus,X                      ; /
    ASL.W SpriteOBJAttribute,X
    SEC
    ROR.W SpriteOBJAttribute,X
    LDA.W SpriteTweakerE,X
    AND.B #$40
    BEQ CODE_0294A2
    PHX
    LDA.B SpriteNumber,X
    TAX
    LDA.L SpriteToSpawn,X
    PLX
    STA.B SpriteNumber,X
    JSL LoadSpriteTables
CODE_0294A2:
    LDA.B #$C0
    LDY.B _E
    BEQ +
    LDA.B #$B0
    CPY.B #$02
    BNE +
    LDA.B #$C0
  + STA.B SpriteYSpeed,X
    JSR SubHorzPosBnk2
    LDA.W DATA_029392,Y
    STA.B SpriteXSpeed,X
    TYA
    EOR.B #$01
    STA.W SpriteMisc157C,X
    RTS

GroundPound:
    LDA.B #$30                                ; \ Set ground shake timer
    STA.W ScreenShakeTimer                    ; /
    STZ.W GroundPoundTimer
    PHB
    PHK
    PLB
    LDX.B #$09                                ; Loop over sprites:
KillSprLoopStart:
    LDA.W SpriteStatus,X                      ; \ Skip current sprite if status < 8
    CMP.B #$08                                ; |
    BCC +                                     ; /
    LDA.W SpriteBlockedDirs,X                 ; \ Skip current sprite if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    LDA.W SpriteTweakerC,X                    ; \ Skip current sprite if...
    AND.B #$20                                ; | ...can't be killed by cape...
    ORA.W SpriteOnYoshiTongue,X               ; | ...or sprite being eaten...
    ORA.W SpriteMisc154C,X                    ; | ...or interaction disabled
    BNE +                                     ; /
    LDA.B #$35
    STA.B _E
    JSR CODE_029404
  + DEX
    BPL KillSprLoopStart
    PLB
    RTL

CODE_0294F5:
    LDA.W CapeInteracts
    BEQ Return02950A
    STA.B _E
    LDA.B TrueFrame
    LSR A
    BCC +
    JSR CODE_0293AE
    JSR CODE_029631
  + JSR CODE_02950B
Return02950A:
    RTS

CODE_02950B:
    STZ.B _F
    JSR CODE_029540
    LDA.B ScreenMode
    BPL +
    INC.B _F
    LDA.W CapeInteractionXPos
    CLC
    ADC.B Layer23XRelPos
    STA.W CapeInteractionXPos
    LDA.W CapeInteractionXPos+1
    ADC.B Layer23XRelPos+1
    STA.W CapeInteractionXPos+1
    LDA.W CapeInteractionYPos
    CLC
    ADC.B Layer23YRelPos
    STA.W CapeInteractionYPos
    LDA.W CapeInteractionYPos+1
    ADC.B Layer23YRelPos+1
    STA.W CapeInteractionYPos+1
    JSR CODE_029540
  + RTS


DATA_02953C:
    db $08,$08

DATA_02953E:
    db $02,$0E

CODE_029540:
    LDA.B TrueFrame
    AND.B #$01
    TAY
    LDA.B _F
    INC A
    AND.B ScreenMode
    BEQ CODE_0295AE
    LDA.W CapeInteractionYPos
    CLC
    ADC.W DATA_02953C,Y
    AND.B #$F0
    STA.B _0
    STA.B TouchBlockYPos
    LDA.W CapeInteractionYPos+1
    ADC.B #$00
    CMP.B LevelScrLength
    BCS Return0295AD
    STA.B _3
    STA.B TouchBlockYPos+1
    LDA.W CapeInteractionXPos
    CLC
    ADC.W DATA_02953E,Y
    STA.B _1
    STA.B TouchBlockXPos
    LDA.W CapeInteractionXPos+1
    ADC.B #$00
    CMP.B #$02
    BCS Return0295AD
    STA.B _2
    STA.B TouchBlockXPos+1
    LDA.B _1
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _3
    LDA.L DATA_00BA80,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA8E,X
  + CLC
    ADC.B _0
    STA.B _5
    LDA.L DATA_00BABC,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BACA,X
  + ADC.B _2
    STA.B _6
    BRA CODE_02960D

Return0295AD:
    RTS

CODE_0295AE:
    LDA.W CapeInteractionYPos
    CLC
    ADC.W DATA_02953C,Y
    AND.B #$F0
    STA.B _0
    STA.B TouchBlockYPos
    LDA.W CapeInteractionYPos+1
    ADC.B #$00
    CMP.B #$02
    BCS Return0295AD
    STA.B _2
    STA.B TouchBlockYPos+1
    LDA.W CapeInteractionXPos
    CLC
    ADC.W DATA_02953E,Y
    STA.B _1
    STA.B TouchBlockXPos
    LDA.W CapeInteractionXPos+1
    ADC.B #$00
    CMP.B LevelScrLength
    BCS Return0295AD
    STA.B _3
    STA.B TouchBlockXPos+1
    LDA.B _1
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _3
    LDA.L DATA_00BA60,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA70,X
  + CLC
    ADC.B _0
    STA.B _5
    LDA.L DATA_00BA9C,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BAAC,X
  + ADC.B _2
    STA.B _6
CODE_02960D:
    LDA.B #$7E
    STA.B _7
    LDA.B [_5]
    STA.W Map16TileNumber
    INC.B _7
    LDA.B [_5]
    JSL CODE_00F545
    CMP.B #$00
    BEQ +
    LDA.B _F
    STA.W LayerProcessing
    LDA.W Map16TileNumber
    LDY.B #$00
    JSL CODE_00F160
  + RTS

CODE_029631:
    LDX.B #$07
CODE_029633:
    STX.W CurSpriteProcess
    LDA.W ExtSpriteNumber,X
    CMP.B #$02
    BCC +
    JSR CODE_02A519
    JSR CODE_029696
    JSL CheckForContact
    BCC +
    LDA.W ExtSpriteNumber,X
    CMP.B #$12
    BEQ +
    JSR CODE_02A4DE
  + DEX
    BPL CODE_029633
Return029656:
    RTS


    db $FC

DATA_029658:
    db $E0,$FF

DATA_02965A:
    db $FF,$18

DATA_02965C:
    db $50,$FC

DATA_02965E:
    db $F8,$FF

DATA_029660:
    db $FF,$18,$10

CODE_029663:
    PHX
    LDA.W QuakeSpriteNumber,Y
    TAX
    LDA.W QuakeSpriteXPosLow,Y
    CLC
    ADC.W Return029656,X
    STA.B _0
    LDA.W QuakeSpriteXPosHigh,Y
    ADC.W DATA_029658,X
    STA.B _8
    LDA.W DATA_02965A,X
    STA.B _2
    LDA.W QuakeSpriteYPosLow,Y
    CLC
    ADC.W DATA_02965C,X
    STA.B _1
    LDA.W QuakeSpriteYPosHigh,Y
    ADC.W DATA_02965E,X
    STA.B _9
    LDA.W DATA_029660,X
    STA.B _3
    PLX
    RTS

CODE_029696:
    LDA.W CapeInteractionXPos
    SEC
    SBC.B #$02
    STA.B _0
    LDA.W CapeInteractionXPos+1
    SBC.B #$00
    STA.B _8
    LDA.B #$14
    STA.B _2
    LDA.W CapeInteractionYPos
    STA.B _1
    LDA.W CapeInteractionYPos+1
    STA.B _9
    LDA.B #$10
    STA.B _3
    RTS


DATA_0296B8:
    db $20,$24,$28,$2C

DATA_0296BC:
    db $90,$94,$98,$9C

CODE_0296C0:
    LDA.W SmokeSpriteNumber,X
    BEQ Return0296D7
    AND.B #$7F
    JSL ExecutePtr

    dw Return0296D7
    dw CODE_0296E3
    dw CODE_029797
    dw CODE_029927
    dw Return0296D7
    dw CODE_0298CA

Return0296D7:
    RTS


DATA_0296D8:
    db $66,$66,$64,$62,$60,$62,$60

CODE_0296DF:
    STZ.W SmokeSpriteNumber,X
    RTS

CODE_0296E3:
    LDA.W SmokeSpriteTimer,X
    BEQ CODE_0296DF
    LDA.W SmokeSpriteNumber,X
    BMI CODE_0296F1
    LDA.B SpriteLock
    BNE +
CODE_0296F1:
    DEC.W SmokeSpriteTimer,X
  + LDA.B SpriteNumber+7
    CMP.B #$A9
    BEQ CODE_02974A
    LDA.W IRQNMICommand
    AND.B #$40
    BEQ CODE_02974A
    LDY.W DATA_0296BC,X
    LDA.W SmokeSpriteXPos,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$F4
    BCS CODE_0296DF
    STA.W OAMTileXPos+$100,Y
    LDA.W SmokeSpriteYPos,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$E0
    BCS CODE_0296DF
    STA.W OAMTileYPos+$100,Y
    LDA.W SmokeSpriteTimer,X
    CMP.B #$08
    LDA.B #$00
    BCS +
    ASL A
    ASL A
    ASL A
    ASL A
    AND.B #$40
  + ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDA.W SmokeSpriteTimer,X
    PHY
    LSR A
    LSR A
    TAY
    LDA.W DATA_0296D8,Y
    PLY
    STA.W OAMTileNo+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    RTS

CODE_02974A:
    LDY.W DATA_0296B8,X
    LDA.W SmokeSpriteXPos,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$F4
    BCS CODE_029793
    STA.W OAMTileXPos,Y
    LDA.W SmokeSpriteYPos,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$E0
    BCS CODE_029793
    STA.W OAMTileYPos,Y
    LDA.W SmokeSpriteTimer,X
    CMP.B #$08
    LDA.B #$00
    BCS +
    ASL A
    ASL A
    ASL A
    ASL A
    AND.B #$40
  + ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    LDA.W SmokeSpriteTimer,X
    PHY
    LSR A
    LSR A
    TAY
    LDA.W DATA_0296D8,Y
    PLY
    STA.W OAMTileNo,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    RTS

CODE_029793:
    STZ.W SmokeSpriteNumber,X
    RTS

CODE_029797:
    LDA.W SmokeSpriteTimer,X
    BEQ CODE_029793
    LDY.B SpriteLock
    BNE +
    DEC.W SmokeSpriteTimer,X
  + BIT.W IRQNMICommand
    BVC +
    LDA.W IRQNMICommand
    CMP.B #$C1
    BEQ +
    JMP CODE_029838

  + LDY.B #$F0
    LDA.W SmokeSpriteXPos,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$F0
    BCS CODE_029793
    STA.W OAMTileXPos,Y
    STA.W OAMTileXPos+8,Y
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+4,Y
    STA.W OAMTileXPos+$0C,Y
    LDA.W SmokeSpriteYPos,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos,Y
    STA.W OAMTileYPos+4,Y
    CLC
    ADC.B #$08
    STA.W OAMTileYPos+8,Y
    STA.W OAMTileYPos+$0C,Y
    LDA.W SmokeSpriteTimer,X
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    AND.B #$40
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    STA.W OAMTileAttr+4,Y
    EOR.B #$C0
    STA.W OAMTileAttr+8,Y
    STA.W OAMTileAttr+$0C,Y
    LDA.W SmokeSpriteTimer,X
    AND.B #$02
    BNE CODE_029815
    LDA.B #$7C
    STA.W OAMTileNo,Y
    STA.W OAMTileNo+$0C,Y
    LDA.B #$7D
    STA.W OAMTileNo+4,Y
    STA.W OAMTileNo+8,Y
    BRA +

CODE_029815:
    LDA.B #$7D
    STA.W OAMTileNo,Y
    STA.W OAMTileNo+$0C,Y
    LDA.B #$7C
    STA.W OAMTileNo+4,Y
    STA.W OAMTileNo+8,Y
  + TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    STA.W OAMTileSize+1,Y
    STA.W OAMTileSize+2,Y
    STA.W OAMTileSize+3,Y
    RTS

CODE_029838:
    LDY.B #$90
    LDA.W SmokeSpriteXPos,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$F0
    BCS CODE_0298BE
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$108,Y
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$104,Y
    STA.W OAMTileXPos+$10C,Y
    LDA.W SmokeSpriteYPos,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    CLC
    ADC.B #$08
    STA.W OAMTileYPos+$108,Y
    STA.W OAMTileYPos+$10C,Y
    LDA.W SmokeSpriteTimer,X
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    AND.B #$40
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    EOR.B #$C0
    STA.W OAMTileAttr+$108,Y
    STA.W OAMTileAttr+$10C,Y
    LDA.W SmokeSpriteTimer,X
    AND.B #$02
    BNE CODE_02989B
    LDA.B #$7C
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$10C,Y
    LDA.B #$7D
    STA.W OAMTileNo+$104,Y
    STA.W OAMTileNo+$108,Y
    BRA +

CODE_02989B:
    LDA.B #$7D
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$10C,Y
    LDA.B #$7C
    STA.W OAMTileNo+$104,Y
    STA.W OAMTileNo+$108,Y
  + TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
    STA.W OAMTileSize+$42,Y
    STA.W OAMTileSize+$43,Y
    RTS

CODE_0298BE:
    STZ.W SmokeSpriteNumber,X
    RTS


DATA_0298C2:
    db $04,$08,$04,$00

DATA_0298C6:
    db $FC,$04,$0C,$04

CODE_0298CA:
    LDA.W SmokeSpriteTimer,X
    BEQ CODE_0298BE
    LDY.B SpriteLock
    BNE Return029921
    DEC.W SmokeSpriteTimer,X
    AND.B #$03
    BNE Return029921
    LDY.B #$0B
CODE_0298DC:
    LDA.W MinExtSpriteNumber,Y
    BEQ CODE_0298F1
    DEY
    BPL CODE_0298DC
    DEC.W MinExtSpriteSlotIdx
    BPL +
    LDA.B #$0B
    STA.W MinExtSpriteSlotIdx
  + LDY.W MinExtSpriteSlotIdx
CODE_0298F1:
    LDA.B #$02
    STA.W MinExtSpriteNumber,Y
    LDA.W SmokeSpriteYPos,X
    STA.B _1
    LDA.W SmokeSpriteXPos,X
    STA.B _0
    LDA.W SmokeSpriteTimer,X
    LSR A
    LSR A
    AND.B #$03
    PHX
    TAX
    LDA.W DATA_0298C2,X
    CLC
    ADC.B _0
    STA.W MinExtSpriteXPosLow,Y
    LDA.W DATA_0298C6,X
    CLC
    ADC.B _1
    STA.W MinExtSpriteYPosLow,Y
    PLX
    LDA.B #$17
    STA.W MinExtSpriteTimer,Y
Return029921:
    RTS


DATA_029922:
    db $66,$66,$64,$62,$62

CODE_029927:
    LDA.W SmokeSpriteTimer,X
    BNE CODE_029941
    BIT.W IRQNMICommand
    BVC +
    LDA.W ReznorOAMIndex
    BNE +
    LDY.W DATA_0296BC,X
    LDA.B #$F0
    STA.W OAMTileYPos+$100,Y
  + JMP CODE_029793

CODE_029941:
    LDY.B SpriteLock
    BNE +
    DEC.W SmokeSpriteTimer,X
    AND.B #$07
    BNE +
    DEC.W SmokeSpriteYPos,X
  + LDA.B SpriteNumber+7
    CMP.B #$A9
    BEQ CODE_02996C
    LDA.W ReznorOAMIndex
    BNE CODE_02996C
    LDA.W IRQNMICommand
    BPL CODE_02996C
    CMP.B #$C1
    BEQ CODE_029967
    AND.B #$40
    BNE CODE_02999F
CODE_029967:
    LDY.W DATA_0296BC,X
    BRA +

CODE_02996C:
    LDY.W DATA_0296B8,X
  + LDA.W SmokeSpriteXPos,X
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos,Y
    LDA.W SmokeSpriteYPos,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos,Y
    LDA.B SpriteProperties
    STA.W OAMTileAttr,Y
    LDA.W SmokeSpriteTimer,X
    LSR A
    LSR A
    TAX
    %LorW_X(LDA,DATA_029922)
    LDX.W MinorSpriteProcIndex
    STA.W OAMTileNo,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    RTS

CODE_02999F:
    LDY.W DATA_0296BC,X
    LDA.W SmokeSpriteXPos,X
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$100,Y
    LDA.W SmokeSpriteYPos,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    LDA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDA.W SmokeSpriteTimer,X
    LSR A
    LSR A
    TAX
    %LorW_X(LDA,DATA_029922)
    LDX.W MinorSpriteProcIndex
    STA.W OAMTileNo+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    RTS

CODE_0299D2:
    LDX.B #$03
CODE_0299D4:
    STX.W CurSpriteProcess
    LDA.W CoinSpriteExists,X
    BEQ +
    JSR CODE_0299F1
  + DEX
    BPL CODE_0299D4
    RTS

CODE_0299E3:
    LDA.B #$00
    STA.W CoinSpriteExists,X
    RTS


DATA_0299E9:
    db $30,$38,$40,$48,$EC,$EA,$E8,$EC

CODE_0299F1:
    LDA.B SpriteLock
    BNE +
    JSR CODE_02B58E
    LDA.W CoinSpriteYSpeed,X
    CLC
    ADC.B #$03
    STA.W CoinSpriteYSpeed,X
    CMP.B #$20
    BMI +
    JMP CODE_029AA8

  + LDA.W CoinSpriteLayer,X
    ASL A
    ASL A
    TAY
    LDA.W Layer1YPos,Y
    STA.B _2
    LDA.W Layer1XPos,Y
    STA.B _3
    LDA.W Layer1YPos+1,Y
    STA.B _4
    LDA.W CoinSpriteYPosLow,X
    CMP.B _2
    LDA.W CoinSpriteYPosHigh,X
    SBC.B _4
    BNE Return029A6D
    LDA.W CoinSpriteXPosLow,X
    SEC
    SBC.B _3
    CMP.B #$F8
    BCS CODE_0299E3
    STA.B _0
    LDA.W CoinSpriteYPosLow,X
    SEC
    SBC.B _2
    STA.B _1
    LDY.W DATA_0299E9,X
    STY.B _F
    LDY.B _F
    LDA.B _0
    STA.W OAMTileXPos,Y
    LDA.B _1
    STA.W OAMTileYPos,Y
    LDA.B #$E8
    STA.W OAMTileNo,Y
    LDA.B #$04
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    TXA
    CLC
    ADC.B EffFrame
    LSR A
    LSR A
    AND.B #$03
    BNE +
Return029A6D:
    RTS


    db $EA,$FA,$EA

  + LDY.B _F
    PHX
    TAX
    LDA.B _0
    CLC
    ADC.B #$04
    STA.W OAMTileXPos,Y
    STA.W OAMTileXPos+4,Y
    LDA.B _1
    CLC
    ADC.B #$08
    STA.W OAMTileYPos+4,Y
    LDA.L Return029A6D,X
    STA.W OAMTileNo,Y
    STA.W OAMTileNo+4,Y
    LDA.W OAMTileAttr,Y
    ORA.B #$80
    STA.W OAMTileAttr+4,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    STA.W OAMTileSize+1,Y
    PLX
    RTS

CODE_029AA8:
    JSL CODE_02AD34                           ; Find next usable location in score sprite table
    LDA.B #$01
    STA.W ScoreSpriteNumber,Y                 ; add a "10" score sprite
    LDA.W CoinSpriteYPosLow,X
    STA.W ScoreSpriteYPosLow,Y                ; set Yposition low byte
    LDA.W CoinSpriteYPosHigh,X
    STA.W ScoreSpriteYPosHigh,Y               ; set Ypos high byte
    LDA.W CoinSpriteXPosLow,X
    STA.W ScoreSpriteXPosLow,Y                ; set Xpos low byte
    LDA.W CoinsPriteXPosHigh,X
    STA.W ScoreSpriteXPosHigh,Y               ; set Xpos high byte
    LDA.B #$30
    STA.W ScoreSpriteTimer,Y                  ; set initial speed to 30
    LDA.W CoinSpriteLayer,X
    STA.W ScoreSpriteLayer,Y
    JSR CODE_029ADA
    JMP CODE_0299E3                           ; Puts #$00 into $17D0 and returns

CODE_029ADA:
    LDY.B #$03                                ; for (c=3;c>=0;c--)
CODE_029ADC:
    LDA.W SmokeSpriteNumber,Y                 ; {
    BEQ CODE_029AE5                           ;  check if there is empty space in smoke/dust sprite table
    DEY
    BPL CODE_029ADC                           ; }
    RTS                                       ;  if no empty space, return

CODE_029AE5:
    LDA.B #$05                                ; if there's an empty space, make it 5 (glitter sprite)
    STA.W SmokeSpriteNumber,Y
    LDA.W CoinSpriteLayer,X                   ;  nots sure what 17E4 is used for yet - copied from $1933
    LSR A                                     ; carryout = $17E4 % 2
    PHP
    LDA.W CoinSpriteXPosLow,X                 ; get x coordinate low byte
    BCC +                                     ; if carryout == 1
    SBC.B Layer23XRelPos                      ;   x-coord -= $26
  + STA.W SmokeSpriteXPos,Y                   ; store x-coord
    LDA.W CoinSpriteYPosLow,X                 ; get y coordinate low byte
    PLP
    BCC +                                     ; if carryout == 1
    SBC.B Layer23YRelPos                      ;   y-coord -=$28
  + STA.W SmokeSpriteYPos,Y                   ; store y-coord
    LDA.B #$10
    STA.W SmokeSpriteTimer,Y                  ; duration = 10
    RTS

CODE_029B0A:
    LDX.B #$09
  - STX.W CurSpriteProcess
    JSR CODE_029B16
    DEX
    BPL -
Return029B15:
    RTS

CODE_029B16:
    LDA.W ExtSpriteNumber,X
    BEQ Return029B15
    LDY.B SpriteLock
    BNE +
    LDY.W ExtSpriteMisc176F,X
    BEQ +
    DEC.W ExtSpriteMisc176F,X
  + JSL ExecutePtr

    dw Return029B15                           ; 00 - Empty slot
    dw SmokePuff                              ; 01 - Puff of smoke
    dw ReznorFireball                         ; 02 - Reznor fireball
    dw FlameRemnant                           ; 03 - Tiny flame left by hopping flame
    dw Hammer                                 ; 04 - Hammer
    dw MarioFireball                          ; 05 - Mario fireball
    dw Baseball                               ; 06 - Bone
    dw LavaSplash                             ; 07 - Lava splash
    dw LauncherArm                            ; 08 - Torpedo Ted shooter's arm
    dw UnusedExtendedSpr                      ; 09 - Unused (Red thing that flickers from 16x16 to 8x8)
    dw CloudCoin                              ; 0A - Coin from cloud game
    dw Hammer                                 ; 0B - Piranha fireball
    dw VolcanoLotusFire                       ; 0C - Volcano lotus fire
    dw Baseball                               ; 0D - Baseball
    dw CloudCoin                              ; 0E - Flower of Wiggler
    dw SmokeTrail                             ; 0F - Trail of smoke
    dw SpinJumpStars                          ; 10 - Spin Jump stars
    dw YoshiFireball                          ; 11 - Yoshi fireballs
    dw WaterBubble                            ; 12 - Water bubble

VolcanoLotusFire:
    LDY.W DATA_02A153,X
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.W ExtSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BNE CODE_029BDA
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    LDA.W ExtSpriteYPosHigh,X
    SBC.B Layer1YPos+1
    BEQ CODE_029B76
    BMI CODE_029BA5
    BPL CODE_029BDA
CODE_029B76:
    LDA.B _0
    STA.W OAMTileXPos,Y
    LDA.B _1
    CMP.B #$F0
    BCS CODE_029BA5
    STA.W OAMTileYPos,Y
    LDA.B #$09
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    LDA.B EffFrame
    LSR A
    EOR.W CurSpriteProcess
    LSR A
    LSR A
    LDA.B #$A6
    BCC +
    LDA.B #$B6
  + STA.W OAMTileNo,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
CODE_029BA5:
    LDA.B SpriteLock
    BNE Return029BD9
    JSR CODE_02A3F6
    JSR CODE_02B554
    JSR CODE_02B560
    LDA.B TrueFrame
    AND.B #$03
    BNE +
    LDA.W ExtSpriteYSpeed,X
    CMP.B #$18
    BPL +
    INC.W ExtSpriteYSpeed,X
  + LDA.W ExtSpriteYSpeed,X
    BMI Return029BD9
    TXA
    ASL A
    ASL A
    ASL A
    ADC.B TrueFrame
    LDY.B #$08
    AND.B #$08
    BNE +
    LDY.B #$F8
  + TYA
    STA.W ExtSpriteXSpeed,X
Return029BD9:
    RTS

CODE_029BDA:
    STZ.W ExtSpriteNumber,X                   ; Clear extended sprite
    RTS


DATA_029BDE:
    db $08,$F8

DATA_029BE0:
    db $00,$FF

DATA_029BE2:
    db $18,$E8

CODE_029BE4:
    LDA.B #$05                                ; \ Set ground shake timer
    STA.W ScreenShakeTimer                    ; /
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
    STZ.B _0
    JSR CODE_029BF5
    INC.B _0
CODE_029BF5:
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_029BF7:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_029C00                           ; |
    DEY                                       ; |
    BPL CODE_029BF7                           ; |
    RTS                                       ; / Return if no free slots

CODE_029C00:
    LDA.B #$0F                                ; \ Extended sprite = Yoshi stomp smoke
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B PlayerYPosNext
    CLC
    ADC.B #$28
    STA.W ExtSpriteYPosLow,Y
    LDA.B PlayerYPosNext+1
    ADC.B #$00
    STA.W ExtSpriteYPosHigh,Y
    LDX.B _0
    LDA.B PlayerXPosNext
    CLC
    ADC.W DATA_029BDE,X
    STA.W ExtSpriteXPosLow,Y
    LDA.B PlayerXPosNext+1
    ADC.W DATA_029BE0,X
    STA.W ExtSpriteXPosHigh,Y
    LDA.W DATA_029BE2,X
    STA.W ExtSpriteXSpeed,Y
    LDA.B #$15
    STA.W ExtSpriteMisc176F,Y
    RTS


SmokeTrailTiles:
    db $66,$64,$62,$60,$60,$60,$60,$60
    db $60,$60,$60

SmokeTrail:
    JSR CODE_02A1A4
    LDY.W DATA_02A153,X
    LDA.W ExtSpriteMisc176F,X
    LSR A
    PHX
    TAX
    LDA.B EffFrame
    ASL A
    ASL A
    ASL A
    ASL A
    AND.B #$C0
    ORA.B #$32
    STA.W OAMTileAttr,Y
    %LorW_X(LDA,SmokeTrailTiles)
    STA.W OAMTileNo,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    PLX
    LDA.B SpriteLock
    BNE Return029C7E
    LDA.W ExtSpriteMisc176F,X
    BEQ CODE_029C7F
    CMP.B #$06
    BNE +
    LDA.W ExtSpriteXSpeed,X
    ASL A
    ROR.W ExtSpriteXSpeed,X
  + JSR CODE_02B554
Return029C7E:
    RTS

CODE_029C7F:
    STZ.W ExtSpriteNumber,X                   ; Clear extended sprite
    RTS

SpinJumpStars:
    LDA.W ExtSpriteMisc176F,X
    BEQ CODE_029C7F
    JSR CODE_02A1A4
    LDY.W DATA_02A153,X
    LDA.B #$34
    STA.W OAMTileAttr,Y
    LDA.B #$EF
    STA.W OAMTileNo,Y
    LDA.B SpriteLock
    BNE +
    LDA.W ExtSpriteMisc176F,X
    LSR A
    LSR A
    TAY
    LDA.B TrueFrame
    AND.W DATA_029CB0,Y
    BNE +
    JSR CODE_02B554
    JSR CODE_02B560
  + RTS


DATA_029CB0:
    db $FF,$07,$01,$00,$00

CloudCoin:
    LDA.B SpriteLock
    BNE CODE_029CF8
    JSR CODE_02B560
    LDA.W ExtSpriteYSpeed,X
    CMP.B #$30
    BPL +
    CLC
    ADC.B #$02
    STA.W ExtSpriteYSpeed,X
  + LDA.W ExtSpriteNumber,X
    CMP.B #$0E
    BNE ADDR_029CE3
    LDY.B #$08
    LDA.B EffFrame
    AND.B #$08
    BEQ +
    LDY.B #$F8
  + TYA
    STA.W ExtSpriteXSpeed,X
    JSR CODE_02B554
    BRA CODE_029CF8

ADDR_029CE3:
    LDA.W ExtSpriteMisc1765,X
    BNE +
    JSR CODE_02A56E
    BCC +
    LDA.B #$D0
    STA.W ExtSpriteYSpeed,X
    INC.W ExtSpriteMisc1765,X
  + JSR CODE_02A3F6
CODE_029CF8:
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$F0
    BCS CODE_029D5A
    STA.B _1
    LDA.W ExtSpriteXPosLow,X
    CMP.B Layer1XPos
    LDA.W ExtSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BNE Return029D5D
    LDY.W DATA_02A153,X
    STY.B _F
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    STA.W OAMTileXPos,Y
    LDA.W ExtSpriteNumber,X
    CMP.B #$0E
    BNE +
    LDA.B _1
    SEC
    SBC.B #$05
    STA.W OAMTileYPos,Y
    LDA.B #$98
    STA.W OAMTileNo,Y
    LDA.B #$0B
CODE_029D36:
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    RTS

  + LDA.B _1
    STA.W OAMTileYPos,Y
    LDA.B #$C2
    STA.W OAMTileNo,Y
    LDA.B #$04
    JSR CODE_029D36
    LDA.B #$02
    STA.W OAMTileSize,Y
    RTS

CODE_029D5A:
    STZ.W ExtSpriteNumber,X                   ; Clear extended sprite
Return029D5D:
    RTS


DATA_029D5E:
    db $00,$01,$02,$03,$02,$03,$02,$03
    db $03,$02,$03,$02,$03,$02,$01,$00
UnusedExSprDispX:
    db $10,$F8,$03,$10,$F8,$03,$10,$F0
    db $FF,$10,$F0,$FF

UnusedExSprDispY:
    db $02,$02,$EE,$02,$02,$EE,$FE,$FE
    db $E6,$FE,$FE,$E6

UnusedExSprTiles:
    db $B3,$B3,$B1,$B2,$B2,$B0,$8E,$8E
    db $A8,$8C,$8C,$88

UnusedExSprGfxProp:
    db $69,$29,$29

UnusedExSprTileSize:
    db $00,$00,$02,$02

  - STZ.W ExtSpriteNumber,X                   ; Clear extended sprite
    RTS

UnusedExtendedSpr:
    JSR CODE_02A3F6
    LDY.W ExtSpriteXSpeed,X
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BNE -
    LDA.W ExtSpriteMisc176F,X
    BEQ -
    LSR A
    LSR A
    NOP
    NOP
    TAY
    LDA.W DATA_029D5E,Y
    STA.B _F
    ASL A
    ADC.B _F
    STA.B _2
    LDA.W ExtSpriteMisc1765,X
    CLC
    ADC.B _2
    TAY
    STY.B _3
    LDA.W ExtSpriteXPosLow,X
    CLC
    ADC.W UnusedExSprDispX,Y
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.W ExtSpriteYPosLow,X
    CLC
    ADC.W UnusedExSprDispY,Y
    SEC
    SBC.B Layer1YPos
    STA.B _1
    LDY.W DATA_02A153,X
    CMP.B #$F0
    BCS CODE_029E39
    STA.W OAMTileYPos,Y
    LDA.B _0
    CMP.B #$10
    BCC CODE_029E39
    CMP.B #$F0
    BCS CODE_029E39
    STA.W OAMTileXPos,Y
    LDA.W ExtSpriteMisc1765,X
    TAX
    %LorW_X(LDA,UnusedExSprGfxProp)
    STA.W OAMTileAttr,Y
    LDX.B _3
    %LorW_X(LDA,UnusedExSprTiles)
    STA.W OAMTileNo,Y
    TYA
    LSR A
    LSR A
    TAY
    LDX.B _F
    %LorW_X(LDA,UnusedExSprTileSize)
    STA.W OAMTileSize,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _0
    SEC
    SBC.B PlayerXPosScrRel
    CLC
    ADC.B #$04
    CMP.B #$08
    BCS +
    LDA.B _1
    SEC
    SBC.B PlayerYPosScrRel
    SEC
    SBC.B #$10
    CLC
    ADC.B #$10
    CMP.B #$10
    BCS +
    JMP CODE_02A469

  + RTS


DATA_029E36:
    db $08,$00,$F8

CODE_029E39:
    STZ.W ExtSpriteNumber,X
    RTS

LauncherArm:
    LDY.B #$00
    LDA.W ExtSpriteMisc176F,X
    BEQ CODE_029E39
    CMP.B #$60
    BCS +
    INY
    CMP.B #$30
    BCS +
    INY
  + PHY
    LDA.B SpriteLock
    BNE +
    LDA.W DATA_029E36,Y
    STA.W ExtSpriteYSpeed,X
    JSR CODE_02B560
  + JSR CODE_02A1A4
    LDY.W DATA_02A153,X
    PLA
    CMP.B #$01
    LDA.B #$84
    BCC +
    LDA.B #$A4
  + STA.W OAMTileNo,Y
    LDA.W OAMTileAttr,Y
    AND.B #$00
    ORA.B #$13
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    RTS


LavaSplashTiles2:
    db $D7,$C7,$D6,$C6

LavaSplash:
    LDA.B SpriteLock
    BNE CODE_029E9D
    JSR CODE_02B554
    JSR CODE_02B560
    LDA.W ExtSpriteYSpeed,X
    CLC
    ADC.B #$02
    STA.W ExtSpriteYSpeed,X
    CMP.B #$30
    BPL +
CODE_029E9D:
    LDY.W DATA_02A153,X
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.W ExtSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BNE +
    LDA.B _0
    STA.W OAMTileXPos,Y
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$F0
    BCS +
    STA.W OAMTileYPos,Y
    LDA.W ExtSpriteMisc176F,X
    LSR A
    LSR A
    LSR A
    NOP
    NOP
    AND.B #$03
    TAX
    %LorW_X(LDA,LavaSplashTiles2)
    STA.W OAMTileNo,Y
    LDA.B SpriteProperties
    ORA.B #$05
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

  + STZ.W ExtSpriteNumber,X                   ; Clear extended sprite
    RTS


DATA_029EEA:
    db $00,$01,$00,$FF

WaterBubble:
    LDA.B SpriteLock
    BNE CODE_029F2A
    INC.W ExtSpriteMisc1765,X
    LDA.W ExtSpriteMisc1765,X
    AND.B #$30
    BEQ +
    DEC.W ExtSpriteYPosLow,X
    LDY.W ExtSpriteYPosLow,X
    INY
    BNE +
    DEC.W ExtSpriteYPosHigh,X
  + TXA
    EOR.B TrueFrame
    LSR A
    BCS CODE_029F2A
    JSR CODE_02A56E
    BCS CODE_029F27
    LDA.B LevelIsWater
    BNE CODE_029F2A
    LDA.B _C
    CMP.B #$06
    BCC CODE_029F2A
    LDA.B _F
    BEQ CODE_029F27
    LDA.B _D
    CMP.B #$06
    BCC CODE_029F2A
CODE_029F27:
    JMP CODE_02A211

CODE_029F2A:
    LDA.W ExtSpriteYPosLow,X
    CMP.B Layer1YPos
    LDA.W ExtSpriteYPosHigh,X
    SBC.B Layer1YPos+1
    BNE CODE_029F27
    JSR CODE_02A1A4
    LDA.W ExtSpriteMisc1765,X
    AND.B #$0C
    LSR A
    LSR A
    TAY
    LDA.W DATA_029EEA,Y
    STA.B _0
    LDY.W DATA_02A153,X
    LDA.W OAMTileXPos,Y
    CLC
    ADC.B _0
    STA.W OAMTileXPos,Y
    LDA.W OAMTileYPos,Y
    CLC
    ADC.B #$05
    STA.W OAMTileYPos,Y
    LDA.B #$1C
    STA.W OAMTileNo,Y
    RTS

YoshiFireball:
    LDA.B SpriteLock
    BNE +
    JSR CODE_02B554
    JSR CODE_02B560
    JSR ProcessFireball
  + JSR CODE_02A1A4
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    LDY.W DATA_02A153,X
    LDA.B #$04
    BCC +
    LDA.B #$2B
  + STA.W OAMTileNo,Y
    LDA.W ExtSpriteXSpeed,X
    AND.B #$80
    EOR.B #$80
    LSR A
    ORA.B #$35
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    RTS


DATA_029F99:
    db $00,$B8,$C0,$C8,$D0,$D8,$E0,$E8
    db $F0

DATA_029FA2:
    db $00

DATA_029FA3:
    db $05,$03

DATA_029FA5:
    db $02,$02,$02,$02,$02,$02,$F8,$FC
    db $A0,$A4

MarioFireball:
    LDA.B SpriteLock
    BNE CODE_02A02C
    LDA.W ExtSpriteYPosLow,X
    CMP.B Layer1YPos
    LDA.W ExtSpriteYPosHigh,X
    SBC.B Layer1YPos+1
    BEQ +
    JMP CODE_02A211

  + INC.W ExtSpriteMisc1765,X
    JSR ProcessFireball
    LDA.W ExtSpriteYSpeed,X
    CMP.B #$30
    BPL +
    LDA.W ExtSpriteYSpeed,X
    CLC
    ADC.B #$04
    STA.W ExtSpriteYSpeed,X
  + JSR CODE_02A56E
    BCC CODE_02A010
    INC.W ExtSpriteXPosSpx,X
    LDA.W ExtSpriteXPosSpx,X
    CMP.B #$02
    BCS CODE_02A042
    LDA.W ExtSpriteXSpeed,X
    BPL +
    LDA.B _B
    EOR.B #$FF
    INC A
    STA.B _B
  + LDA.B _B
    CLC
    ADC.B #$04
    TAY
    LDA.W DATA_029F99,Y
    STA.W ExtSpriteYSpeed,X
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.W DATA_029FA2,Y
    STA.W ExtSpriteYPosLow,X
    BCS +
    DEC.W ExtSpriteYPosHigh,X
  + BRA +

CODE_02A010:
    STZ.W ExtSpriteXPosSpx,X
  + LDY.B #$00
    LDA.W ExtSpriteXSpeed,X
    BPL +
    DEY
  + CLC
    ADC.W ExtSpriteXPosLow,X
    STA.W ExtSpriteXPosLow,X
    TYA
    ADC.W ExtSpriteXPosHigh,X
    STA.W ExtSpriteXPosHigh,X
    JSR CODE_02B560
CODE_02A02C:
    LDA.B SpriteNumber+7
    CMP.B #$A9
    BEQ CODE_02A03B
    LDA.W IRQNMICommand
    BPL CODE_02A03B
    AND.B #$40
    BNE +
CODE_02A03B:
    LDY.W DATA_029FA3,X
    JSR CODE_02A1A7
    RTS

CODE_02A042:
    JSR CODE_02A02C
CODE_02A045:
    LDA.B #!SFX_BONK                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.B #$0F
    JMP CODE_02A4E0

  + LDY.W DATA_029FA5,X
    LDA.W ExtSpriteXSpeed,X
    AND.B #$80
    LSR A
    STA.B _0
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$F8
    BCS ADDR_02A0A9
    STA.W OAMTileXPos+$100,Y
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$F0
    BCS ADDR_02A0A9
    STA.W OAMTileYPos+$100,Y
    LDA.W ExtSpritePriority,X
    STA.B _1
    LDA.W ExtSpriteMisc1765,X
    LSR A
    LSR A
    AND.B #$03
    TAX
    LDA.W FireballTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02A15F,X
    EOR.B _0
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDX.B _1
    BEQ +
    AND.B #$CF
    ORA.B #$10
    STA.W OAMTileAttr+$100,Y
  + TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
  - RTS

ADDR_02A0A9:
    JMP CODE_02A211

ProcessFireball:
    TXA                                       ; \ Return every other frame
    EOR.B TrueFrame                           ; |
    AND.B #$03                                ; |
    BNE -                                     ; /
    PHX
    TXY
    STY.W TileGenerateTrackA                  ; $185E = Y = Extended sprite index
    LDX.B #$09                                ; Loop over sprites:
FireRtLoopStart:
    STX.W CurSpriteProcess
    LDA.W SpriteStatus,X                      ; \ Skip current sprite if status < 8
    CMP.B #$08                                ; |
    BCC FireRtNextSprite                      ; /
    LDA.W SpriteTweakerD,X                    ; \ Skip current sprite if...
    AND.B #$02                                ; | ...invincible to fire/cape/etc
    ORA.W SpriteOnYoshiTongue,X               ; | ...sprite being eaten...
    ORA.W SpriteBehindScene,X                 ; | ...interactions disabled...
    EOR.W ExtSpritePriority,Y
    BNE FireRtNextSprite                      ; /
    JSL GetSpriteClippingA
    JSR CODE_02A547
    JSL CheckForContact
    BCC FireRtNextSprite
    LDA.W ExtSpriteNumber,Y                   ; \ if Yoshi fireball...
    CMP.B #$11                                ; |
    BEQ +                                     ; |
    PHX                                       ; |
    TYX                                       ; |
    JSR CODE_02A045                           ; | ...?
    PLX                                       ; /
  + LDA.W SpriteTweakerC,X                    ; \ Skip sprite if fire killing is disabled
    AND.B #$10                                ; |
    BNE FireRtNextSprite                      ; /
    LDA.W SpriteTweakerF,X                    ; \ Branch if takes 1 fireball to kill
    AND.B #$08                                ; |
    BEQ TurnSpriteToCoin                      ; /
    INC.W SpriteMisc1528,X                    ; Increase times Chuck hit by fireball
    LDA.W SpriteMisc1528,X                    ; \ If fire count >= 5, kill Chuck:
    CMP.B #$05                                ; |
    BCC FireRtNextSprite                      ; |
    LDA.B #!SFX_SPLAT                         ; | Play sound effect
    STA.W SPCIO0                              ; |
    LDA.B #$02                                ; | Sprite status = Killed
    STA.W SpriteStatus,X                      ; |
    LDA.B #$D0                                ; | Set death Y speed
    STA.B SpriteYSpeed,X                      ; |
    JSR SubHorzPosBnk2
    LDA.W FireKillSpeedX,Y                    ; | Set death X speed
    STA.B SpriteXSpeed,X                      ; |
    LDA.B #$04                                ; | Increase points
    JSL GivePoints                            ; |
    BRA FireRtNextSprite                      ; /

TurnSpriteToCoin:
    LDA.B #!SFX_KICK                          ; \ Turn sprite into coin:
    STA.W SPCIO0                              ; | Play sound effect
    LDA.B #$21                                ; | Sprite = Moving Coin
    STA.B SpriteNumber,X                      ; |
    LDA.B #$08                                ; | Sprite status = Normal
    STA.W SpriteStatus,X                      ; |
    JSL InitSpriteTables                      ; | Reset sprite tables
    LDA.B #$D0                                ; | Set upward speed
    STA.B SpriteYSpeed,X                      ; |
    JSR SubHorzPosBnk2
    TYA
    EOR.B #$01
    STA.W SpriteMisc157C,X                    ; /
FireRtNextSprite:
    LDY.W TileGenerateTrackA
    DEX
    BMI +
    JMP FireRtLoopStart

  + PLX                                       ; $15E9 = Sprite index
    STX.W CurSpriteProcess                    ; $15E9 = Sprite index
    RTS


FireKillSpeedX:
    db $F0,$10

DATA_02A153:
    db $90,$94,$98,$9C,$A0,$A4,$A8,$AC
FireballTiles:
    db $2C,$2D,$2C,$2D

DATA_02A15F:
    db $04,$04,$C4,$C4

ReznorFireTiles:
    db $26,$2A,$26,$2A

DATA_02A167:
    db $35,$35,$F5,$F5

ReznorFireball:
    LDA.B SpriteLock
    BNE CODE_02A178
    JSR CODE_02B554
    JSR CODE_02B560
    JSR CODE_02A3F6
CODE_02A178:
    LDA.W IRQNMICommand
    BPL CODE_02A1A4
    JSR CODE_02A1A4
    LDY.W DATA_02A153,X
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03
    PHX
    TAX
    LDA.W ReznorFireTiles,X
    STA.W OAMTileNo,Y
    LDA.W DATA_02A167,X
    EOR.B _0
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAX
    LDA.B #$02
    STA.W OAMTileSize,X
    PLX
    RTS

CODE_02A1A4:
    LDY.W DATA_02A153,X
CODE_02A1A7:
    LDA.W ExtSpriteXSpeed,X
    AND.B #$80
    EOR.B #$80
    LSR A
    STA.B _0
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _1
    LDA.W ExtSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BNE CODE_02A211
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _2
    LDA.W ExtSpriteYPosHigh,X
    SBC.B Layer1YPos+1
    BNE CODE_02A211
    LDA.B _2
    CMP.B #$F0
    BCS CODE_02A211
    STA.W OAMTileYPos,Y
    LDA.B _1
    STA.W OAMTileXPos,Y
    LDA.W ExtSpritePriority,X
    STA.B _1
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03
    TAX
    %LorW_X(LDA,FireballTiles)
    STA.W OAMTileNo,Y
    %LorW_X(LDA,DATA_02A15F)
    EOR.B _0
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    LDX.B _1
    BEQ +
    AND.B #$CF
    ORA.B #$10
    STA.W OAMTileAttr,Y
  + TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_02A211:
    LDA.B #$00                                ; \ Clear extended sprite
    STA.W ExtSpriteNumber,X                   ; /
    RTS


SmallFlameTiles:
    db $AC,$AD

FlameRemnant:
    LDA.B SpriteLock
    BNE CODE_02A22F
    INC.W ExtSpriteMisc1765,X
    LDA.W ExtSpriteMisc176F,X
    BEQ CODE_02A211
    CMP.B #$50
    BCS CODE_02A22F
    AND.B #$01
    BNE Return02A253
    BEQ +
CODE_02A22F:
    JSR CODE_02A3F6
  + JSR CODE_02A1A4
    LDY.W DATA_02A153,X
    LDA.W ExtSpriteMisc1765,X
    LSR A
    LSR A
    AND.B #$01
    TAX
    %LorW_X(LDA,SmallFlameTiles)
    STA.W OAMTileNo,Y
    LDA.W OAMTileAttr,Y
    AND.B #$3F
    ORA.B #$05
    STA.W OAMTileAttr,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
Return02A253:
    RTS

Baseball:
    LDA.B SpriteLock
    BNE CODE_02A26A
    JSR CODE_02B554
    INC.W ExtSpriteMisc1765,X
    LDA.B TrueFrame
    AND.B #$01
    BNE +
    INC.W ExtSpriteMisc1765,X
  + JSR CODE_02A3F6
CODE_02A26A:
    LDA.W ExtSpriteNumber,X
    CMP.B #$0D
    BNE CODE_02A2C3
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.W ExtSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BEQ CODE_02A287
    EOR.W ExtSpriteXSpeed,X
    BPL CODE_02A2BF
    BMI Return02A2BE
CODE_02A287:
    LDY.W DATA_02A153,X
    LDA.B _0
    STA.W OAMTileXPos,Y
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    LDA.W ExtSpriteYPosHigh,X
    SBC.B Layer1YPos+1
    BNE CODE_02A2BF
    LDA.B _1
    STA.W OAMTileYPos,Y
    LDA.B #$AD
    STA.W OAMTileNo,Y
    LDA.B EffFrame
    ASL A
    ASL A
    ASL A
    ASL A
    AND.B #$C0
    ORA.B #$39
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
Return02A2BE:
    RTS

CODE_02A2BF:
    STZ.W ExtSpriteNumber,X                   ; Clear extended sprite
    RTS

CODE_02A2C3:
    JSR CODE_02A317
    LDA.W OAMTileNo,Y
    CMP.B #$26
    LDA.B #$80
    BCS +
    LDA.B #$82
  + STA.W OAMTileNo,Y
    LDA.W OAMTileAttr,Y
    AND.B #$F1
    ORA.B #$02
    STA.W OAMTileAttr,Y
    RTS


HammerTiles:
    db $08,$6D,$6D,$08,$08,$6D,$6D,$08
HammerGfxProp:
    db $47,$47,$07,$07,$87,$87,$C7,$C7

Hammer:
    LDA.B SpriteLock
    BNE CODE_02A30C
    JSR CODE_02B554
    JSR CODE_02B560
    LDA.W ExtSpriteYSpeed,X
    CMP.B #$40
    BPL +
    INC.W ExtSpriteYSpeed,X
    INC.W ExtSpriteYSpeed,X
  + JSR CODE_02A3F6
    INC.W ExtSpriteMisc1765,X
CODE_02A30C:
    LDA.W ExtSpriteNumber,X
    CMP.B #$0B
    BNE CODE_02A317
    JSR CODE_02A178
    RTS

CODE_02A317:
    JSR CODE_02A1A4
    LDY.W DATA_02A153,X
    LDA.W ExtSpriteMisc1765,X
    LSR A
    LSR A
    LSR A
    AND.B #$07
    PHX
    TAX
    %LorW_X(LDA,HammerTiles)
    STA.W OAMTileNo,Y
    %LorW_X(LDA,HammerGfxProp)
    EOR.B _0
    EOR.B #$40
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAX
    LDA.B #$02
    STA.W OAMTileSize,X
    PLX
    RTS

  - JMP CODE_02A211


DustCloudTiles:
    db $66,$64,$60,$62

DATA_02A34B:
    db $00,$40,$C0,$80

SmokePuff:
    LDA.W ExtSpriteMisc176F,X
    BEQ -
    LDA.W ReznorOAMIndex
    BNE CODE_02A362
    LDA.W IRQNMICommand
    BPL CODE_02A362
    AND.B #$40
    BNE ADDR_02A3B1
CODE_02A362:
    LDY.W DATA_02A153,X
    CPX.B #$08
    BCC +
    LDY.W DATA_029FA3,X
  + LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$F8
    BCS CODE_02A3AE
    STA.W OAMTileXPos,Y
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$F0
    BCS CODE_02A3AE
    STA.W OAMTileYPos,Y
    LDA.W ExtSpriteMisc176F,X
    LSR A
    LSR A
    TAX
    %LorW_X(LDA,DustCloudTiles)
    STA.W OAMTileNo,Y
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03
    TAX
    %LorW_X(LDA,DATA_02A34B)
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_02A3AE:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    JML CODE_02A211                           ;!
else                                          ;<================ U, SS, E0, & E1 ==============
    JMP CODE_02A211                           ;!
endif                                         ;/===============================================

ADDR_02A3B1:
    LDY.W DATA_029FA5,X
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$F8
    BCS CODE_02A3AE
    STA.W OAMTileXPos+$100,Y
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$F0
    BCS CODE_02A3AE
    STA.W OAMTileYPos+$100,Y
    LDA.W ExtSpriteMisc176F,X
    LSR A
    LSR A
    TAX
    %LorW_X(LDA,DustCloudTiles)
    STA.W OAMTileNo+$100,Y
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03
    TAX
    %LorW_X(LDA,DATA_02A34B)
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    RTS

CODE_02A3F6:
    LDA.W PlayerBehindNet
    EOR.W ExtSpritePriority,X
    BNE Return02A468
    JSL GetMarioClipping
    JSR CODE_02A519
    JSL CheckForContact
    BCC Return02A468
    LDA.W ExtSpriteNumber,X
    CMP.B #$0A
    BNE CODE_02A469
    JSL CODE_05B34A
    INC.W GameCloudCoinCount
    STZ.W ExtSpriteNumber,X                   ; Clear extended sprite
    LDY.B #$03
ADDR_02A41E:
    LDA.W SmokeSpriteNumber,Y
    BEQ ADDR_02A427
    DEY
    BPL ADDR_02A41E
    INY
ADDR_02A427:
    LDA.B #$05
    STA.W SmokeSpriteNumber,Y
    LDA.W ExtSpriteXPosLow,X
    STA.W SmokeSpriteXPos,Y
    LDA.W ExtSpriteYPosLow,X
    STA.W SmokeSpriteYPos,Y
    LDA.B #$0A
    STA.W SmokeSpriteTimer,Y
    JSL CODE_02AD34
    LDA.B #$05
    STA.W ScoreSpriteNumber,Y
    LDA.W ExtSpriteYPosLow,X
    STA.W ScoreSpriteYPosLow,Y
    LDA.W ExtSpriteYPosHigh,X
    STA.W ScoreSpriteYPosHigh,Y
    LDA.W ExtSpriteXPosLow,X
    STA.W ScoreSpriteXPosLow,Y
    LDA.W ExtSpriteXPosHigh,X
    STA.W ScoreSpriteXPosHigh,Y
    LDA.B #$30
    STA.W ScoreSpriteTimer,Y
    LDA.B #$00
    STA.W ScoreSpriteLayer,Y
Return02A468:
    RTS

CODE_02A469:
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario has star
    BNE CODE_02A4B5                           ; /
    LDA.W PlayerRidingYoshi
    BEQ +
CODE_02A473:
    PHX
    LDX.W CurrentYoshiSlot
    LDA.B #$10
    STA.W SpriteMisc163E-1,X
    LDA.B #!SFX_YOSHIDRUMOFF                  ; \ Play sound effect
    STA.W SPCIO1                              ; /
    LDA.B #!SFX_YOSHIHURT                     ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$02
    STA.B SpriteTableC2-1,X
    STZ.W PlayerRidingYoshi
    STZ.W CarryYoshiThruLvls
    LDA.B #$C0
    STA.B PlayerYSpeed+1
    STZ.B PlayerXSpeed+1
    LDY.W SpriteMisc157C-1,X
    LDA.W DATA_02A4B3,Y
    STA.B SpriteXSpeed-1,X
    STZ.W SpriteMisc1594-1,X
    STZ.W SpriteMisc151C-1,X
    STZ.W YoshiStartEatTimer
    LDA.B #$30
    STA.W IFrameTimer
    PLX
    RTS

  + JSL HurtMario
    RTS


DATA_02A4B3:
    db $10,$F0

CODE_02A4B5:
    LDA.W ExtSpriteNumber,X
    CMP.B #$04
    BEQ CODE_02A4DE
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B #$04
    STA.W ExtSpriteXPosLow,X
    LDA.W ExtSpriteXPosHigh,X
    SBC.B #$00
    STA.W ExtSpriteXPosHigh,X
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B #$04
    STA.W ExtSpriteYPosLow,X
    LDA.W ExtSpriteYPosHigh,X
    SBC.B #$00
    STA.W ExtSpriteYPosHigh,X
CODE_02A4DE:
    LDA.B #$07
CODE_02A4E0:
    STA.W ExtSpriteMisc176F,X
    LDA.B #$01
    STA.W ExtSpriteNumber,X
    RTS


DATA_02A4E9:
    db $03,$03,$04,$03,$04,$00,$00,$00
    db $04,$03

DATA_02A4F3:
    db $03,$03,$03,$03,$04,$03,$04,$00
    db $00,$00,$02,$03

DATA_02A4FF:
    db $03,$03,$01,$01,$08,$01,$08,$00
    db $00,$0F,$08,$01

DATA_02A50B:
    db $01,$01,$01,$01,$08,$01,$08,$00
    db $00,$0F,$0C,$01,$01,$01

CODE_02A519:
    LDY.W ExtSpriteNumber,X
    LDA.W ExtSpriteXPosLow,X
    CLC
    ADC.W DATA_02A4E9-2,Y
    STA.B _4
    LDA.W ExtSpriteXPosHigh,X
    ADC.B #$00
    STA.B _A
    LDA.W DATA_02A4FF,Y
    STA.B _6
    LDA.W ExtSpriteYPosLow,X
    CLC
    ADC.W DATA_02A4F3,Y
    STA.B _5
    LDA.W ExtSpriteYPosHigh,X
    ADC.B #$00
    STA.B _B
    LDA.W DATA_02A50B,Y
    STA.B _7
    RTS

CODE_02A547:
    LDA.W ExtSpriteXPosLow,Y
    SEC
    SBC.B #$02
    STA.B _0
    LDA.W ExtSpriteXPosHigh,Y
    SBC.B #$00
    STA.B _8
    LDA.B #$0C
    STA.B _2
    LDA.W ExtSpriteYPosLow,Y
    SEC
    SBC.B #$04
    STA.B _1
    LDA.W ExtSpriteYPosHigh,Y
    SBC.B #$00
    STA.B _9
    LDA.B #$13
    STA.B _3
    RTS

CODE_02A56E:
    STZ.B _F
    STZ.B _E
    STZ.B _B
    STZ.W SpriteBlockOffset
    LDA.W ReznorOAMIndex
    BNE CODE_02A5BC
    LDA.W IRQNMICommand
    BPL CODE_02A5BC
    AND.B #$40
    BEQ CODE_02A592
    LDA.W IRQNMICommand
    CMP.B #$C1
    BEQ CODE_02A5BC
    LDA.W ExtSpriteYPosLow,X
    CMP.B #$A8
    RTS

CODE_02A592:
    LDA.W ExtSpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.W IggyLarryPlatIntXPos
    LDA.W ExtSpriteXPosHigh,X
    ADC.B #$00
    STA.W IggyLarryPlatIntXPos+1
    LDA.W ExtSpriteYPosLow,X
    CLC
    ADC.B #$08
    STA.W IggyLarryPlatIntYPos
    LDA.W ExtSpriteYPosHigh,X
    ADC.B #$00
    STA.W IggyLarryPlatIntYPos+1
    JSL CODE_01CC9D
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_02A5BC:
    JSR CODE_02A611
    ROL.B _E
    LDA.W Map16TileNumber
    STA.B _C
    LDA.B ScreenMode
    BPL +
    INC.B _F
    LDA.W ExtSpriteXPosLow,X
    PHA
    CLC
    ADC.B Layer23XRelPos
    STA.W ExtSpriteXPosLow,X
    LDA.W ExtSpriteXPosHigh,X
    PHA
    ADC.B Layer23XRelPos+1
    STA.W ExtSpriteXPosHigh,X
    LDA.W ExtSpriteYPosLow,X
    PHA
    CLC
    ADC.B Layer23YRelPos
    STA.W ExtSpriteYPosLow,X
    LDA.W ExtSpriteYPosHigh,X
    PHA
    ADC.B Layer23YRelPos+1
    STA.W ExtSpriteYPosHigh,X
    JSR CODE_02A611
    ROL.B _E
    LDA.W Map16TileNumber
    STA.B _D
    PLA
    STA.W ExtSpriteYPosHigh,X
    PLA
    STA.W ExtSpriteYPosLow,X
    PLA
    STA.W ExtSpriteXPosHigh,X
    PLA
    STA.W ExtSpriteXPosLow,X
  + LDA.B _E
    CMP.B #$01
    RTS

CODE_02A611:
    LDA.B _F
    INC A
    AND.B ScreenMode
    BEQ CODE_02A679
    LDA.W ExtSpriteYPosLow,X
    CLC
    ADC.B #$08
    STA.B TouchBlockYPos
    AND.B #$F0
    STA.B _0
    LDA.W ExtSpriteYPosHigh,X
    ADC.B #$00
    CMP.B LevelScrLength
    BCS CODE_02A677
    STA.B _3
    STA.B TouchBlockYPos+1
    LDA.W ExtSpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.B _1
    STA.B TouchBlockXPos
    LDA.W ExtSpriteXPosHigh,X
    ADC.B #$00
    CMP.B #$02
    BCS CODE_02A677
    STA.B _2
    STA.B TouchBlockXPos+1
    LDA.B _1
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _3
    LDA.L DATA_00BA80,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA8E,X
  + CLC
    ADC.B _0
    STA.B _5
    LDA.L DATA_00BABC,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BACA,X
  + ADC.B _2
    STA.B _6
    BRA CODE_02A6DB

CODE_02A677:
    CLC
    RTS

CODE_02A679:
    LDA.W ExtSpriteYPosLow,X
    CLC
    ADC.B #$08
    STA.B TouchBlockYPos
    AND.B #$F0
    STA.B _0
    LDA.W ExtSpriteYPosHigh,X
    ADC.B #$00
    STA.B _2
    STA.B TouchBlockYPos+1
    LDA.B _0
    SEC
    SBC.B Layer1YPos
    CMP.B #$F0
    BCS CODE_02A677
    LDA.W ExtSpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.B _1
    STA.B TouchBlockXPos
    LDA.W ExtSpriteXPosHigh,X
    ADC.B #$00
    CMP.B LevelScrLength
    BCS CODE_02A677
    STA.B _3
    STA.B TouchBlockXPos+1
    LDA.B _1
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _3
    LDA.L DATA_00BA60,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA70,X
  + CLC
    ADC.B _0
    STA.B _5
    LDA.L DATA_00BA9C,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BAAC,X
  + ADC.B _2
    STA.B _6
CODE_02A6DB:
    LDA.B #$7E
    STA.B _7
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B [_5]
    STA.W Map16TileNumber
    INC.B _7
    LDA.B [_5]
    JSL CODE_00F545
    CMP.B #$00
    BEQ CODE_02A729
    LDA.W Map16TileNumber
    CMP.B #$11
    BCC CODE_02A72B
    CMP.B #$6E
    BCC CODE_02A727
    CMP.B #$D8
    BCS CODE_02A735
    LDY.B TouchBlockXPos
    STY.B _A
    LDY.B TouchBlockYPos
    STY.B _C
    JSL CODE_00FA19
    LDA.B _0
    CMP.B #$0C
    BCS CODE_02A718
    CMP.B [_5],Y
    BCC CODE_02A729
CODE_02A718:
    LDA.B [_5],Y
    STA.W SpriteBlockOffset
    PHX
    LDX.B _8
    LDA.L DATA_00E53D,X
    PLX
    STA.B _B
CODE_02A727:
    SEC
    RTS

CODE_02A729:
    CLC
    RTS

CODE_02A72B:
    LDA.B TouchBlockYPos
    AND.B #$0F
    CMP.B #$06
    BCS CODE_02A729
    SEC
    RTS

CODE_02A735:
    LDA.B TouchBlockYPos
    AND.B #$0F
    CMP.B #$06
    BCS CODE_02A729
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B #$02
    STA.W ExtSpriteYPosLow,X
    LDA.W ExtSpriteYPosHigh,X
    SBC.B #$00
    STA.W ExtSpriteYPosHigh,X
    JMP CODE_02A611

CODE_02A751:
    PHB
    PHK
    PLB
    JSR CODE_02ABF2
    JSR CODE_02AC5C
    LDA.W IRQNMICommand
    BMI +
    JSL CODE_01808C
  + LDA.W CarryYoshiThruLvls
    BEQ +
    LDA.W RemoveYoshiFlag
    BNE +
    JSL CODE_00FC7A
  + PLB
    RTL


SpriteSlotMax:
    db $09,$05,$07,$07,$07,$06,$07,$06
    db $06,$09,$08,$04,$07,$07,$07,$08
    db $09,$05,$05

SpriteSlotMax1:
    db $09,$07,$07,$01,$00,$01,$07,$06
    db $06,$00,$02,$00,$07,$01,$07,$08
    db $09,$07,$05

SpriteSlotMax2:
    db $09,$07,$07,$01,$00,$06,$07,$06
    db $06,$00,$02,$00,$07,$01,$07,$08
    db $09,$07,$05

SpriteSlotStart:
    db $FF,$FF,$00,$01,$00,$01,$FF,$01
    db $FF,$00,$FF,$00,$FF,$01,$FF,$FF
    db $FF,$FF,$FF

SpriteSlotStart1:
    db $FF,$05,$FF,$FF,$FF,$FF,$FF,$01
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$05,$FF

ReservedSprite1:
    db $FF,$5F,$54,$5E,$60,$28,$88,$FF
    db $FF,$C5,$86,$28,$FF,$90,$FF,$FF
    db $FF,$AE

ReservedSprite2:
    db $FF,$64,$FF,$FF,$9F,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$9F,$FF,$FF
    db $FF,$FF

DATA_02A7F6:
    db $D0,$00,$20

DATA_02A7F9:
    db $FF,$00,$01

LoadSprFromLevel:
    LDA.B TrueFrame                           ; \ Return every other frame
    AND.B #$01                                ; |
    BNE Return02A84B                          ; /
CODE_02A802:
    LDY.B Layer1ScrollDir
    LDA.B ScreenMode                          ; \ Branch if horizontal level
    LSR A                                     ; |
    BCC CODE_02A817                           ; /
    LDA.B Layer1YPos                          ; \ Vertical level:
    CLC                                       ; | $00,$01 = Screen boundary Y + offset
    ADC.W DATA_02A7F6,Y                       ; |
    AND.B #$F0                                ; |
    STA.B _0                                  ; |
    LDA.B Layer1YPos+1                        ; |
    BRA +                                     ; /

CODE_02A817:
    LDA.B Layer1XPos                          ; \ Horizontal level:
    CLC                                       ; | $00,$01 = Screen boundary X + offset
    ADC.W DATA_02A7F6,Y                       ; |
    AND.B #$F0                                ; |
    STA.B _0                                  ; |
    LDA.B Layer1XPos+1                        ; |
  + ADC.W DATA_02A7F9,Y                       ; |
    BMI Return02A84B                          ; |
    STA.B _1                                  ; /
    LDX.B #$00                                ; X = #$00 (Number of sprite in level)
    LDY.B #$01                                ; Y = #$01 (Index into level data)
LoadSpriteLoopStrt:
    LDA.B [SpriteDataPtr],Y                   ; Byte format: YYYYEEsy
    CMP.B #$FF                                ; \ Return when we encounter $FF, as it signals the end
    BEQ Return02A84B                          ; /
    ASL A                                     ; \ If 's' is set, $02 = #$10
    ASL A                                     ; | Else, $02 = #$00
    ASL A                                     ; |
    AND.B #$10                                ; |
    STA.B _2                                  ; /
    INY                                       ; Next byte
    LDA.B [SpriteDataPtr],Y                   ; Byte format: XXXXSSSS
    AND.B #$0F                                ; \ Skip all sprites until we find one at the adjusted screen boundary:
    ORA.B _2                                  ; |
    CMP.B _1                                  ; | If sprite screen (sSSSS) < adjusted screen boundary...
    BCS CODE_02A84C                           ; / ...skip the sprite
LoadNextSprite:
    INY                                       ; \ Move on to the next sprite
    INY                                       ; |
    INX                                       ; |
    BRA LoadSpriteLoopStrt                    ; /

Return02A84B:
    RTS

CODE_02A84C:
    BNE Return02A84B                          ; Return if sprite screen > adjusted screen boundary
    LDA.B [SpriteDataPtr],Y                   ; Byte format: XXXXSSSS
    AND.B #$F0                                ; \ Skip sprite if not right at the screen boundary
    CMP.B _0                                  ; |
    BNE LoadNextSprite                        ; /
    LDA.W SpriteLoadStatus,X                  ; \ This table has a flag for every sprite in the level (not just those onscreen)
    BNE LoadNextSprite                        ; / Skip sprite if it's already been loaded/permanently killed
    STX.B _2                                  ; $02 = Number of sprite in level
    INC.W SpriteLoadStatus,X                  ; Mark sprite as loaded
    INY                                       ; Next byte
    LDA.B [SpriteDataPtr],Y                   ; Byte format: Sprite number
    STA.B _5                                  ; $05 = Sprite number
    DEY                                       ; Previous byte
    CMP.B #$E7                                ; \ Branch if sprite number < #$E7
    BCC CODE_02A88C                           ; /
    LDA.W Layer1ScrollCmd
    ORA.W Layer2ScrollCmd
    BNE +
    PHY
    PHX
    LDA.B _5                                  ; \ $143E = Type of scroll sprite
    SEC                                       ; | (Sprite number - #$E7)
    SBC.B #$E7                                ; |
    STA.W Layer1ScrollCmd                     ; /
    DEY                                       ; Previous byte
    LDA.B [SpriteDataPtr],Y                   ; Byte format: YYYYEEsy
    LSR A
    LSR A
    STA.W Layer1ScrollBits
    JSL CODE_05BCD6
    PLX
    PLY
  + BRA LoadNextSprite

CODE_02A88C:
    CMP.B #$DE                                ; \ Branch if sprite number != 5 Eeries
    BNE CODE_02A89C                           ; /
    PHY
    PHX
    DEY
    STY.B _3
    JSR Load5Eeries
    PLX
    PLY
CODE_02A89A:
    BRA LoadNextSprite

CODE_02A89C:
    CMP.B #$E0                                ; \ Branch if sprite number != 3 Platforms on Chain
    BNE CODE_02A8AC                           ; /
    PHY
    PHX
    DEY
    STY.B _3
    JSR Load3Platforms
    PLX
    PLY
    BRA CODE_02A89A

CODE_02A8AC:
    CMP.B #$CB                                ; \ Branch if sprite number < #$CB
    BCC CODE_02A8D4                           ; /
    CMP.B #$DA                                ; \ Branch if sprite number >= #$DA
    BCS CODE_02A8C0                           ; /
    SEC                                       ; \ $18B9 = Type of generator
    SBC.B #$CB                                ; | (Sprite number - #$CA)
    INC A                                     ; |
    STA.W CurrentGenerator                    ; /
    STZ.W SpriteLoadStatus,X                  ; Allow sprite to be reloaded by level loading routine
    BRA CODE_02A89A

CODE_02A8C0:
    CMP.B #$E1                                ; \ Branch if sprite number < #$E1
    BCC CODE_02A8D0                           ; /
    PHX
    PHY
    DEY
    STY.B _3
    JSR CODE_02AAC0
    PLY
    PLX
    BRA CODE_02A89A

CODE_02A8D0:
    LDA.B #$09
    BRA CODE_02A8DF

CODE_02A8D4:
    CMP.B #$C9                                ; \ Branch if sprite number < #$C9
    BCC LoadNormalSprite                      ; /
    JSR LoadShooter
    BRA CODE_02A89A

LoadNormalSprite:
    LDA.B #$01                                ; \ $04 = #$01
CODE_02A8DF:
    STA.B _4                                  ; / Eventually goes into sprite status
    DEY                                       ; Previous byte
    STY.B _3
    LDY.W SpriteMemorySetting
    LDX.W SpriteSlotMax,Y
    LDA.W SpriteSlotStart,Y
    STA.B _6
    LDA.B _5
    CMP.W ReservedSprite1,Y
    BNE +
    LDX.W SpriteSlotMax1,Y
    LDA.W SpriteSlotStart1,Y
    STA.B _6
  + LDA.B _5
    CMP.W ReservedSprite2,Y
    BNE CODE_02A916
    CMP.B #$64
    BNE CODE_02A90F
    LDA.B _0
    AND.B #$10
    BEQ CODE_02A916
CODE_02A90F:
    LDX.W SpriteSlotMax2,Y
    LDA.B #$FF
    STA.B _6
CODE_02A916:
    STX.B _F
CODE_02A918:
    LDA.W SpriteStatus,X
    BEQ CODE_02A93C
    DEX
    CPX.B _6
    BNE CODE_02A918
    LDA.B _5
    CMP.B #$7B
    BNE CODE_02A936
    LDX.B _F
ADDR_02A92A:
    LDA.W SpriteTweakerD,X
    AND.B #$02
    BEQ CODE_02A93C
    DEX
    CPX.B _6
    BNE ADDR_02A92A
CODE_02A936:
    LDX.B _2
    STZ.W SpriteLoadStatus,X                  ; Allow sprite to be reloaded by level loading routine
    RTS

CODE_02A93C:
    LDY.B _3
    LDA.B ScreenMode                          ; \ Branch if horizontal level
    LSR A                                     ; |
    BCC CODE_02A95B                           ; /
    LDA.B [SpriteDataPtr],Y                   ; \ Vertical level:
    PHA                                       ; | Same as below with X and Y coords swapped
    AND.B #$F0                                ; |
    STA.B SpriteXPosLow,X                     ; |
    PLA                                       ; |
    AND.B #$0D                                ; |
    STA.W SpriteXPosHigh,X                    ; |
    LDA.B _0                                  ; |
    STA.B SpriteYPosLow,X                     ; |
    LDA.B _1                                  ; |
    STA.W SpriteYPosHigh,X                    ; |
    BRA +                                     ; /

CODE_02A95B:
    LDA.B [SpriteDataPtr],Y                   ; Byte format: YYYYEEsy
    PHA                                       ; \ Bits 11110000 are low byte of Y position
    AND.B #$F0                                ; |
    STA.B SpriteYPosLow,X                     ; /
    PLA                                       ; \ Bits 00001101 are high byte of Y position
    AND.B #$0D                                ; | (Extra bits are stored in Y position)
    STA.W SpriteYPosHigh,X                    ; /
    LDA.B _0                                  ; \ X position = adjusted screen boundary
    STA.B SpriteXPosLow,X                     ; |
    LDA.B _1                                  ; |
    STA.W SpriteXPosHigh,X                    ; /
  + INY
    INY
    LDA.B _4                                  ; \ Sprite status = ??
    STA.W SpriteStatus,X                      ; /
    CMP.B #$09
    LDA.B [SpriteDataPtr],Y                   ;KKOOPA STORAGE???
    BCC +                                     ;NO, IT WAS STATIONARY
    SEC
    SBC.B #$DA                                ;SUBTRACT DA, FIRST SHELL SPRITE [RED]
    CLC
    ADC.B #$04
  + PHY
    LDY.W OWLevelTileSettings+$49
    BPL CODE_02A996                           ;IF POSITIBE, JUST STORE?
    CMP.B #$04
    BNE +
    LDA.B #$07                                ;WHAT?
  + CMP.B #$05
    BNE CODE_02A996
    LDA.B #$06                                ;STORING RED KOOPA SHELL TO SPRITENUM
CODE_02A996:
    STA.B SpriteNumber,X
    PLY
    LDA.B _2                                  ; \ $161A,x = index of the sprite in the level
    STA.W SpriteLoadIndex,X                   ; / (Number of sprites in level, not just onscreen)
    LDA.W SilverPSwitchTimer
    BEQ CODE_02A9C9
    PHX
    LDA.B SpriteNumber,X
    TAX
    LDA.L Sprite190FVals,X
    PLX
    AND.B #$40
    BNE CODE_02A9C9
    LDA.B #$21                                ; \ Sprite = Moving Coin
    STA.B SpriteNumber,X                      ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    JSL InitSpriteTables
    LDA.W SpriteOBJAttribute,X
    AND.B #$F1
    ORA.B #$02
    STA.W SpriteOBJAttribute,X
    BRA +

CODE_02A9C9:
    JSL InitSpriteTables                      ; Reset sprite tables
  + LDA.B #$01                                ; \ Set off screen horizontally
    STA.W SpriteOffscreenX,X                  ; /
    LDA.B #$04                                ; \ ?? $1FE2,X = #$04
    STA.W SpriteMisc1FE2,X                    ; /
    INY
    LDX.B _2
    INX
    JMP LoadSpriteLoopStrt

FindFreeSlotLowPri:
    LDA.B #$02                                ; \ Number of slots to leave free = 2
    STA.B _E                                  ; |
    BRA +                                     ; /

FindFreeSprSlot:
    STZ.B _E                                  ; Number of slots tp leave free = 0
  + PHB
    PHK
    PLB
    JSR FindFreeSlotRt
    PLB
    TYA
    RTL

FindFreeSlotRt:
    LDY.W SpriteMemorySetting                 ; \ Subroutine: Return the first free sprite slot in Y (#$FF if not found)
    LDA.W SpriteSlotStart,Y                   ; | Y = Sprite memory index
    STA.B _F                                  ; |
    LDA.W SpriteSlotMax,Y                     ; |
    SEC                                       ; |
    SBC.B _E                                  ; |
    TAY                                       ; |
CODE_02A9FE:
    LDA.W SpriteStatus,Y                      ; | If free slot...
    BEQ Return02AA0A                          ; |  ...return
    DEY                                       ; |
    CPY.B _F                                  ; |
    BNE CODE_02A9FE                           ; |
    LDY.B #$FF                                ; | If no free slots, Y=#$FF
Return02AA0A:
    RTS                                       ; /


DATA_02AA0B:
    db $31,$71,$A1,$43,$93,$C3,$14,$65
    db $E5,$36,$A7,$39,$99,$F9,$1A,$7A
    db $DA,$4C,$AD,$ED

DATA_02AA1F:
    db $01,$51,$91,$D1,$22,$62,$A2,$73
    db $E3,$C7,$88,$29,$5A,$AA,$EB,$2C
    db $8C,$CC,$FC,$5D

CODE_02AA33:
    LDX.B #$0E                                ; \ Unreachable
  - STZ.W ClusterSpriteMisc1E66,X             ; | Loop X = 00 to 0E
    STZ.W ClusterSpriteMisc0F86,X
    LDA.B #$08
    STA.W ClusterSpriteNumber,X
    JSL GetRand
    CLC
    ADC.B Layer1XPos
    STA.W ClusterSpriteXPosLow,X
    STA.W ClusterSpriteMisc0F4A,X
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W ClusterSpriteXPosHigh,X
    LDY.B _3
    LDA.B [SpriteDataPtr],Y
    PHA
    AND.B #$F0
    STA.W ClusterSpriteYPosLow,X
    PLA
    AND.B #$01
    STA.W ClusterSpriteYPosHigh,X
    DEX
    BPL -
    RTS                                       ; /


DATA_02AA68:
    db $50,$90,$D0,$10

CODE_02AA6C:
    LDA.B #$07
    STA.W SpriteStatus+3
    LDX.B #$03
  - LDA.B #$05
    STA.W ClusterSpriteNumber,X
    %LorW_X(LDA,DATA_02AA68)
    STA.W ClusterSpriteXPosLow,X
    LDA.B #$F0
    STA.W ClusterSpriteYPosLow,X
    TXA
    ASL A
    ASL A
    STA.W ClusterSpriteMisc0F4A,X
    DEX
    BPL -
    RTS

CODE_02AA8D:
    STZ.W BooCloudTimer
    LDX.B #$13
  - LDA.B #$07
    STA.W ClusterSpriteNumber,X
    LDA.W DATA_02AA0B,X
    PHA
    AND.B #$F0
    STA.W ClusterSpriteMisc1E66,X
    PLA
    ASL A
    ASL A
    ASL A
    ASL A
    STA.W ClusterSpriteMisc1E52,X
    LDA.W DATA_02AA1F,X
    PHA
    AND.B #$F0
    STA.W ClusterSpriteMisc1E8E,X
    PLA
    ASL A
    ASL A
    ASL A
    ASL A
    STA.W ClusterSpriteMisc1E7A,X
    DEX
    BPL -
    RTS

  - JMP CODE_02AA33

CODE_02AAC0:
    LDY.B #$01
    STY.W ActivateClusterSprite
    CMP.B #$E4
    BEQ -
    CMP.B #$E6
    BEQ CODE_02AA6C
    CMP.B #$E5
    BEQ CODE_02AA8D
    CMP.B #$E2
    BCS CODE_02AB11
    LDX.B #$13
  - STZ.W ClusterSpriteMisc1E66,X
    STZ.W ClusterSpriteMisc0F86,X
    LDA.B #$03
    STA.W ClusterSpriteNumber,X
    JSL GetRand
    CLC
    ADC.B Layer1XPos
    STA.W ClusterSpriteXPosLow,X
    STA.W ClusterSpriteMisc0F4A,X
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W ClusterSpriteXPosHigh,X
    LDA.W RandomNumber+1
    AND.B #$3F
    ADC.B #$08
    CLC
    ADC.B Layer1YPos
    STA.W ClusterSpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W ClusterSpriteYPosHigh,X
    DEX
    BPL -
    INC.W BooRingIndex
    RTS

CODE_02AB11:
    LDY.W BooRingIndex
    CPY.B #$02
    BCS Return02AB77
    LDY.B #$01
    CMP.B #$E2
    BEQ +
    LDY.B #$FF
  + STY.B _F
    LDA.B #$09
    STA.B _E
    LDX.B #$13
CODE_02AB28:
    LDA.W ClusterSpriteNumber,X
    BNE CODE_02AB71
    LDA.B #$04
    STA.W ClusterSpriteNumber,X
    LDA.W BooRingIndex
    STA.W ClusterSpriteMisc0F86,X
    LDA.B _E
    STA.W ClusterSpriteMisc0F72,X
    LDA.B _F
    STA.W ClusterSpriteMisc0F4A,X
    STZ.B _F
    BEQ +
    LDY.B _3
    LDA.B [SpriteDataPtr],Y
    LDY.W BooRingIndex
    PHA
    AND.B #$F0
    STA.W BooRingYPosLow,Y
    PLA
    AND.B #$01
    STA.W BooRingYPosHigh,Y
    LDA.B _0
    STA.W BooRingXPosLow,Y
    LDA.B _1
    STA.W BooRingXPosHigh,Y
    LDA.B #$00
    STA.W BooRingOffscreen,Y
    LDA.B _2
    STA.W BooRingLoadIndex,Y
  + DEC.B _E
    BMI CODE_02AB74
CODE_02AB71:
    DEX
    BPL CODE_02AB28
CODE_02AB74:
    INC.W BooRingIndex
Return02AB77:
    RTS

LoadShooter:
    STX.B _2
    DEY
    STY.B _3
    STA.B _4
    LDX.B #$07
CODE_02AB81:
    LDA.W ShooterNumber,X
    BEQ CODE_02AB9E
    DEX
    BPL CODE_02AB81
    DEC.W ShooterSlotIdx
    BPL +
    LDA.B #$07
    STA.W ShooterSlotIdx
  + LDX.W ShooterSlotIdx
    LDY.W ShooterLoadIndex,X
    LDA.B #$00                                ; \ Allow sprite to be reloaded by level loading routine
    STA.W SpriteLoadStatus,Y                  ; /
CODE_02AB9E:
    LDY.B _3
    LDA.B _4
    SEC
    SBC.B #$C8
    STA.W ShooterNumber,X
    LDA.B ScreenMode
    LSR A
    BCC CODE_02ABC7
    LDA.B [SpriteDataPtr],Y
    PHA
    AND.B #$F0
    STA.W ShooterXPosLow,X
    PLA
    AND.B #$01
    STA.W ShooterXPosHigh,X
    LDA.B _0
    STA.W ShooterYPosLow,X
    LDA.B _1
    STA.W ShooterYPosHigh,X
    BRA +

CODE_02ABC7:
    LDA.B [SpriteDataPtr],Y
    PHA
    AND.B #$F0
    STA.W ShooterYPosLow,X
    PLA
    AND.B #$01
    STA.W ShooterYPosHigh,X
    LDA.B _0
    STA.W ShooterXPosLow,X
    LDA.B _1
    STA.W ShooterXPosHigh,X
  + LDA.B _2
    STA.W ShooterLoadIndex,X
    LDA.B #$10
    STA.W ShooterTimer,X
    INY
    INY
    INY
    LDX.B _2
    INX
    JMP LoadSpriteLoopStrt

CODE_02ABF2:
    LDX.B #$3F
  - STZ.W SpriteLoadStatus,X                  ; Allow sprite to be reloaded by level loading routine
    DEX
    BPL -
    LDA.B #$FF
    STA.B _0
    LDX.B #$0B
CODE_02AC00:
    LDA.B #$FF                                ; \ Set to permanently erase sprite
    STA.W SpriteLoadIndex,X                   ; /
    LDA.W SpriteStatus,X
    CMP.B #$0B
    BEQ CODE_02AC11
    STZ.W SpriteStatus,X
    BRA +

CODE_02AC11:
    STX.B _0
  + DEX
    BPL CODE_02AC00
    LDX.B _0
    BMI +
    STZ.W SpriteStatus,X
    LDA.B #$0B                                ; \ Sprite status = Being carried
    STA.W SpriteStatus                        ; /
    LDA.B SpriteNumber,X
    STA.B SpriteNumber
    LDA.B SpriteXPosLow,X
    STA.B SpriteXPosLow
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh
    LDA.B SpriteYPosLow,X
    STA.B SpriteYPosLow
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh
    LDA.W SpriteOBJAttribute,X
    PHA
    LDX.B #$00
    JSL InitSpriteTables
    PLA
    STA.W SpriteOBJAttribute
  + REP #$10                                  ; XY->16
    LDX.W #$027A
  - STZ.W Map16TileNumber,X                   ; clear ram before entering new stage/area
    DEX
    BPL -
    SEP #$10                                  ; XY->8
    STZ.W Layer1ScrollCmd
    STZ.W Layer2ScrollCmd
    RTS

CODE_02AC5C:
    LDA.B ScreenMode
    LSR A
    BCC CODE_02ACA1
    LDA.B Layer1ScrollDir
    PHA
    LDA.B #$01
    STA.B Layer1ScrollDir
    LDA.B Layer1YPos
    PHA
    SEC
    SBC.B #$60
    STA.B Layer1YPos
    LDA.B Layer1YPos+1
    PHA
    SBC.B #$00
    STA.B Layer1YPos+1
    STZ.W TileGenerateTrackB
  - JSR CODE_02A802
    JSR CODE_02A802
    LDA.B Layer1YPos
    CLC
    ADC.B #$10
    STA.B Layer1YPos
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.B Layer1YPos+1
    INC.W TileGenerateTrackB
    LDA.W TileGenerateTrackB
    CMP.B #$20
    BCC -
    PLA
    STA.B Layer1YPos+1
    PLA
    STA.B Layer1YPos
    PLA
    STA.B Layer1ScrollDir
    RTS

CODE_02ACA1:
    LDA.B Layer1ScrollDir
    PHA
    LDA.B #$01
    STA.B Layer1ScrollDir
    LDA.B Layer1XPos
    PHA
    SEC
    SBC.B #$60
    STA.B Layer1XPos
    LDA.B Layer1XPos+1
    PHA
    SBC.B #$00
    STA.B Layer1XPos+1
    STZ.W TileGenerateTrackB
  - JSR CODE_02A802
    JSR CODE_02A802
    LDA.B Layer1XPos
    CLC
    ADC.B #$10
    STA.B Layer1XPos
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.B Layer1XPos+1
    INC.W TileGenerateTrackB
    LDA.W TileGenerateTrackB
    CMP.B #$20
    BCC -
    PLA
    STA.B Layer1XPos+1
    PLA
    STA.B Layer1XPos
    PLA
    STA.B Layer1ScrollDir
    RTS

CODE_02ACE1:
    PHX
    TYX
    BRA +

GivePoints:
    PHX                                       ;  takes sprite type -5 as input in A
  + CLC
    ADC.B #$05                                ; Add 5 to sprite type (200,400,1up)
    JSL CODE_02ACEF                           ; Set score sprite type/initial position
    PLX
    RTL

CODE_02ACEF:
    PHY                                       ;  - note coordinates are level coords, not screen
    PHA                                       ;    sprite type 1=10,2=20,3=40,4=80,5=100,6=200,7=400,8=800,9=1000,A=2000,B=4000,C=8000,D=1up
    JSL CODE_02AD34                           ; Get next free position in table($16E1) to add score sprite
    PLA
    STA.W ScoreSpriteNumber,Y                 ; Set score sprite type (200,400,1up, etc)
    LDA.B SpriteYPosLow,X                     ; Load y position of sprite jumped on
    SEC
    SBC.B #$08                                ;   - make the score sprite appear a little higher
    STA.W ScoreSpriteYPosLow,Y                ; Set this as score sprite y-position
    PHA                                       ; save that value
    LDA.W SpriteYPosHigh,X                    ; Get y-pos high byte for sprite jumped on
    SBC.B #$00
    STA.W ScoreSpriteYPosHigh,Y               ; Set score sprite y-pos high byte
    PLA                                       ; restore score sprite y-pos to A
    SEC                                       ; \
    SBC.B Layer1YPos                          ; |
    CMP.B #$F0                                ; |if (score sprite ypos <1C && >=0C)
    BCC +                                     ; |{
    LDA.W ScoreSpriteYPosLow,Y                ; |
    ADC.B #$10                                ; |
    STA.W ScoreSpriteYPosLow,Y                ; |  move score sprite down by #$10
    LDA.W ScoreSpriteYPosHigh,Y               ; |
    ADC.B #$00                                ; |
    STA.W ScoreSpriteYPosHigh,Y               ; /}
  + LDA.B SpriteXPosLow,X                     ; \
    STA.W ScoreSpriteXPosLow,Y                ; /Set score sprite x-position
    LDA.W SpriteXPosHigh,X                    ; \
    STA.W ScoreSpriteXPosHigh,Y               ; /Set score sprite x-pos high byte
    LDA.B #$30                                ; \
    STA.W ScoreSpriteTimer,Y                  ; /scoreSpriteSpeed = #$30
    PLY
    RTL

CODE_02AD34:
    LDY.B #$05                                ; (here css is used to index through the table of score sprites in table at $16E1
CODE_02AD36:
    LDA.W ScoreSpriteNumber,Y                 ; for (css=5;css>=0;css--){
    BEQ Return02AD4B                          ;  if (css's type == 0)      --check for empty space
    DEY
    BPL CODE_02AD36                           ; }
    DEC.W ScoreSpriteSlotIdx                  ; $18f7--;                   --gives LRU
    BPL +                                     ; if ($18f7 <0)
    LDA.B #$05                                ;   $18f7=5;
    STA.W ScoreSpriteSlotIdx
  + LDY.W ScoreSpriteSlotIdx                  ; return $18f7 in Y;
Return02AD4B:
    RTL


PointTile1:
    db $00,$83,$83,$83,$83,$44,$54,$46
    db $47,$44,$54,$46,$47,$56,$29,$39
    db $38,$5E,$5E,$5E,$5E,$5E

PointTile2:
    db $00,$44,$54,$46,$47,$45,$45,$45
    db $45,$55,$55,$55,$55,$57,$57,$57
    db $57,$4E,$44,$4F,$54,$5D

PointMultiplierLo:
    db $00,$01,$02,$04,$08,$0A,$14,$28
    db $50,$64,$C8,$90,$20,$00,$00,$00
    db $00

PointMultiplierHi:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$01,$03,$00,$00,$00
    db $00

PointSpeedY:
    db $03,$01,$00,$00

DATA_02AD9E:
    db $B0,$B8,$C0,$C8,$D0,$D8

ScoreSprGfx:
    BIT.W IRQNMICommand
    BVC CODE_02ADB8
    LDA.W IRQNMICommand
    CMP.B #$C1
    BEQ Return02ADC8
    LDA.B #$F0
    STA.W OAMTileYPos+4
    STA.W OAMTileYPos+8
CODE_02ADB8:
    LDX.B #$05
CODE_02ADBA:
    STX.W CurSpriteProcess
    LDA.W ScoreSpriteNumber,X
    BEQ +
    JSR CODE_02ADC9
  + DEX
    BPL CODE_02ADBA
Return02ADC8:
    RTS

CODE_02ADC9:
    LDA.B SpriteLock
    BEQ +
    JMP CODE_02AE5B
  + LDA.W ScoreSpriteTimer,X
    BNE +
    STZ.W ScoreSpriteNumber,X
    RTS

DATA_02ADD9:
    db $01,$02,$03,$05,$05,$0A,$0F,$14
    db $19

DATA_02ADE2:
    db $04,$06

  + DEC.W ScoreSpriteTimer,X
    CMP.B #$2A
    BNE CODE_02AE38
    LDY.W ScoreSpriteNumber,X
    CPY.B #$0D
    BCC CODE_02AE12
    CPY.B #$11
    BCC CODE_02AE03
    PHX
    PHY
    LDA.W DATA_02ADE2-$16,Y                   ; Hey, this label might be wrong!
    JSL ADDR_05B329
    PLY
    PLX
    BRA CODE_02AE12

CODE_02AE03:
    LDA.W DATA_02ADE2-$16,Y                   ; Hey, this label might be wrong!
    CLC
    ADC.W GivePlayerLives
    STA.W GivePlayerLives
    STZ.W GiveLivesTimer
    BRA +

CODE_02AE12:
    LDA.W PlayerTurnLvl
    ASL A
    ADC.W PlayerTurnLvl
    TAX
    LDA.W PlayerScore,X
    CLC
    ADC.W PointMultiplierLo,Y
    STA.W PlayerScore,X
    LDA.W PlayerScore+1,X
    ADC.W PointMultiplierHi,Y
    STA.W PlayerScore+1,X
    LDA.W PlayerScore+2,X
    ADC.B #$00
    STA.W PlayerScore+2,X
  + LDX.W CurSpriteProcess                    ; X = Sprite index
CODE_02AE38:
    LDA.W ScoreSpriteTimer,X
    LSR A
    LSR A
    LSR A
    LSR A
    TAY
    LDA.B TrueFrame
    AND.W PointSpeedY,Y
    BNE CODE_02AE5B
    LDA.W ScoreSpriteYPosLow,X
    TAY
    SEC
    SBC.B Layer1YPos
    CMP.B #$04
    BCC CODE_02AE5B
    DEC.W ScoreSpriteYPosLow,X
    TYA
    BNE CODE_02AE5B
    DEC.W ScoreSpriteYPosHigh,X
CODE_02AE5B:
    LDA.W ScoreSpriteLayer,X
    ASL A
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.W Layer1YPos,Y
    STA.B _2
    LDA.W Layer1XPos,Y
    STA.B _4
    SEP #$20                                  ; A->8
    LDA.W ScoreSpriteXPosLow,X
    CLC
    ADC.B #$0C
    PHP
    SEC
    SBC.B _4
    LDA.W ScoreSpriteXPosHigh,X
    SBC.B _5
    PLP
    ADC.B #$00
    BNE Return02AEFB
    LDA.W ScoreSpriteXPosLow,X
    CMP.B _4
    LDA.W ScoreSpriteXPosHigh,X
    SBC.B _5
    BNE Return02AEFB
    LDA.W ScoreSpriteYPosLow,X
    CMP.B _2
    LDA.W ScoreSpriteYPosHigh,X
    SBC.B _3
    BNE Return02AEFB
    LDY.W DATA_02AD9E,X
    BIT.W IRQNMICommand
    BVC +
    LDY.B #$04
  + LDA.W ScoreSpriteYPosLow,X
    SEC
    SBC.B _2
    STA.W OAMTileYPos,Y
    STA.W OAMTileYPos+4,Y
    LDA.W ScoreSpriteXPosLow,X
    SEC
    SBC.B _4
    STA.W OAMTileXPos,Y
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+4,Y
    PHX
    LDA.W ScoreSpriteNumber,X
    TAX
    %LorW_X(LDA,PointTile1)
    STA.W OAMTileNo,Y
    %LorW_X(LDA,PointTile2)
    STA.W OAMTileNo+4,Y
    PLX
    PHY
    LDY.W ScoreSpriteNumber,X
    CPY.B #$0E
    LDA.B #$08
    BCC +
    LDA.W DATA_02ADD9-5,Y                     ; Hey, this label might be wrong!
  + PLY
    ORA.B #$30
    STA.W OAMTileAttr,Y
    STA.W OAMTileAttr+4,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    STA.W OAMTileSize+1,Y
    LDA.W ScoreSpriteNumber,X
    CMP.B #$11
    BCS +
Return02AEFB:
    RTS

  + LDY.B #$4C
    LDA.W ScoreSpriteXPosLow,X
    SEC
    SBC.B _4
    SEC
    SBC.B #$08
    STA.W OAMTileXPos,Y
    LDA.W ScoreSpriteYPosLow,X
    SEC
    SBC.B _2
    STA.W OAMTileYPos,Y
    LDA.B #$5F
    STA.W OAMTileNo,Y
    LDA.B #$04
    ORA.B #$30
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    RTS

    STZ.W ScoreSpriteNumber,X                 ; \ Unreachable
    RTS                                       ; /


DATA_02AF2D:
    db $00,$AA,$54

DATA_02AF30:
    db $00,$00,$01

Load3Platforms:
    LDY.B _3
    LDA.B [SpriteDataPtr],Y
    PHA
    AND.B #$F0
    STA.B _8
    PLA
    AND.B #$01
    STA.B _9
    LDA.B #$02
    STA.B _4
CODE_02AF45:
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BMI Return02AF86                          ; /
    TYX
    LDA.B #$01                                ; \ Sprite status = Initialization
    STA.W SpriteStatus,X                      ; /
    LDA.B #$A3                                ; \ Sprite = Grey Platform on Chain
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables
    LDA.B _0
    STA.B SpriteXPosLow,X
    LDA.B _1
    STA.W SpriteXPosHigh,X
    LDA.B _8
    STA.B SpriteYPosLow,X
    LDA.B _9
    STA.W SpriteYPosHigh,X
    LDY.B _4
    LDA.W DATA_02AF2D,Y
    STA.W SpriteMisc1602,X
    LDA.W DATA_02AF30,Y
    STA.W SpriteMisc151C,X
    CPY.B #$02
    BNE +
    LDA.B _2
    STA.W SpriteLoadIndex,X
  + DEC.B _4
    BPL CODE_02AF45
Return02AF86:
    RTS


EerieGroupDispXLo:
    db $E0,$F0,$00,$10,$20

EerieGroupDispXHi:
    db $FF,$FF,$00,$00,$00

EerieGroupSpeedY:
    db $17,$E9,$17,$E9,$17

EerieGroupState:
    db $00,$01,$00,$01,$00

EerieGroupSpeedX:
    db $10,$F0

Load5Eeries:
    LDY.B _3
    LDA.B [SpriteDataPtr],Y
    PHA
    AND.B #$F0
    STA.B _8
    PLA
    AND.B #$01
    STA.B _9
    LDA.B #$04
    STA.B _4
CODE_02AFAF:
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BMI Return02AFFD                          ; /
    TYX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$39                                ; \ Sprite = Wave Eerie
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables
    LDY.B _4
    LDA.B _0
    CLC
    ADC.W EerieGroupDispXLo,Y
    STA.B SpriteXPosLow,X
    LDA.B _1
    ADC.W EerieGroupDispXHi,Y
    STA.W SpriteXPosHigh,X
    LDA.B _8
    STA.B SpriteYPosLow,X
    LDA.B _9
    STA.W SpriteYPosHigh,X
    LDA.W EerieGroupSpeedY,Y
    STA.B SpriteYSpeed,X
    LDA.W EerieGroupState,Y
    STA.B SpriteTableC2,X
    CPY.B #$04
    BNE +
    LDA.B _2
    STA.W SpriteLoadIndex,X
  + JSR SubHorzPosBnk2
    LDA.W EerieGroupSpeedX,Y
    STA.B SpriteXSpeed,X
    DEC.B _4
    BPL CODE_02AFAF
Return02AFFD:
    RTS

CallGenerator:
    LDA.W CurrentGenerator
    BEQ +
    LDY.B SpriteLock
    BNE +
    DEC A
    JSL ExecutePtr

    dw GenerateEerie                          ; 00 - Eerie, generator
    dw GenParaEnemy                           ; 01 - Para-Goomba, generator
    dw GenParaEnemy                           ; 02 - Para-Bomb, generator
    dw GenParaEnemy                           ; 03 - Para-Bomb and Para-Goomba, generator
    dw GenerateDolphin                        ; 04 - Dolphin, left, generator
    dw GenerateDolphin                        ; 05 - Dolphin, right, generator
    dw GenerateFish                           ; 06 - Jumping fish, generator
    dw TurnOffGen2                            ; 07 - Turn off generator 2 (sprite E5)
    dw GenSuperKoopa                          ; 08 - Super Koopa, generator
    dw GenerateBubble                         ; 09 - Bubble with Goomba and Bob-omb, generator
    dw GenerateBullet                         ; 0A - Bullet Bill, generator
    dw GenMultiBullets                        ; 0B - Bullet Bill surrounded, generator
    dw GenMultiBullets                        ; 0C - Bullet Bill diagonal, generator
    dw GenerateFire                           ; 0D - Bowser statue fire breath, generator
    dw TurnOffGenerators                      ; 0E - Turn off standard generators

  + RTS

TurnOffGen2:
    INC.W SpriteWillAppear
    STZ.W SpriteRespawnTimer                  ; Don't respawn any sprites
    RTS

TurnOffGenerators:
    STZ.W CurrentGenerator
    RTS

GenerateFire:
    LDA.B EffFrame
    AND.B #$7F
    BNE +
    JSL FindFreeSlotLowPri
    BMI +
    TYX
    LDA.B #!SFX_FIRESPIT                      ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$B3                                ; \ Sprite = Bowser's Statue Fireball
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables
    JSL GetRand
    AND.B #$7F
    ADC.B #$20
    ADC.B Layer1YPos
    AND.B #$F0
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B Layer1XPos
    CLC
    ADC.B #$FF
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    INC.W SpriteMisc157C,X
  + RTS

GenerateBullet:
    LDA.B EffFrame
    AND.B #$7F                                ; |
    BNE +                                     ; /
    JSL FindFreeSlotLowPri
    BMI +
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
    TYX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$1C                                ; \ Sprite = Bullet Bill
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables
    JSL GetRand
    PHA
    AND.B #$7F
    ADC.B #$20
    ADC.B Layer1YPos
    AND.B #$F0
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    PLA
    AND.B #$01
    TAY
    LDA.B Layer1XPos
    CLC
    ADC.W DATA_02B1B8,Y
    STA.B SpriteXPosLow,X
CODE_02B0BD:
    LDA.B Layer1XPos+1
CODE_02B0BF:
    ADC.W DATA_02B1BA,Y
    STA.W SpriteXPosHigh,X
    TYA
    STA.B SpriteTableC2,X
  + RTS


    db $04,$08,$04,$03

GenMultiBullets:
    LDA.B EffFrame
    LSR A
    BCS Return02B0F9
    LDA.W DiagonalBulletTimer
    INC.W DiagonalBulletTimer
    CMP.B #$A0
    BNE Return02B0F9
    STZ.W DiagonalBulletTimer
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDY.W CurrentGenerator
    LDA.W CODE_02B0BD,Y
    LDX.W CODE_02B0BF,Y
    STA.B _D
  - PHX
    JSR CODE_02B115
    DEC.B _D
    PLX
    DEX
    BPL -
Return02B0F9:
    RTS


DATA_02B0FA:
    db $00,$00,$40,$C0,$F0,$00,$00,$F0
    db $F0

DATA_02B103:
    db $50,$B0,$E0,$E0,$80,$00,$E0,$E0
    db $00

DATA_02B10C:
    db $00,$00,$02,$02,$01,$05,$04,$07
    db $06

CODE_02B115:
    JSL FindFreeSlotLowPri
    BMI +
    LDA.B #$1C                                ; \ Sprite = Bullet Bill
    STA.W SpriteNumber,Y                      ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    TYX
    JSL InitSpriteTables
    LDX.B _D
    LDA.W DATA_02B0FA,X
    CLC
    ADC.B Layer1XPos
    STA.W SpriteXPosLow,Y
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W SpriteXPosHigh,Y
    LDA.W DATA_02B103,X
    CLC
    ADC.B Layer1YPos
    STA.W SpriteYPosLow,Y
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    LDA.W DATA_02B10C,X
    STA.W SpriteTableC2,Y
  + RTS


DATA_02B153:
    db $10,$18,$20,$28

DATA_02B157:
    db $18,$1A,$1C,$1E

GenerateFish:
    LDA.B EffFrame
    AND.B #$1F
    BNE Return02B1B7
    JSL FindFreeSlotLowPri
    BMI Return02B1B7
    TYX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$17                                ; \ Sprite = Flying Fish
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables
    LDA.B Layer1YPos
    CLC
    ADC.B #$C0
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    JSL GetRand
    CMP.B #$00
    PHP
    PHP
    AND.B #$03
    TAY
    LDA.W DATA_02B153,Y
    PLP
    BPL +
    EOR.B #$FF
  + CLC
    ADC.B Layer1XPos
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.W RandomNumber+1
    AND.B #$03
    TAY
    LDA.W DATA_02B157,Y
    PLP
    BPL +
    EOR.B #$FF
    INC A
  + STA.B SpriteXSpeed,X
    LDA.B #$B8
    STA.B SpriteYSpeed,X
Return02B1B7:
    RTS


DATA_02B1B8:
    db $E0,$10

DATA_02B1BA:
    db $FF,$01

GenSuperKoopa:
    LDA.B EffFrame
    AND.B #$3F
    BNE +
    JSL FindFreeSlotLowPri
    BMI +
    TYX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$71
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    JSL GetRand
    PHA
    AND.B #$3F
    ADC.B #$20
    ADC.B Layer1YPos
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B #$28
    STA.B SpriteYSpeed,X
    PLA
    AND.B #$01
    TAY
    LDA.B Layer1XPos
    CLC
    ADC.W DATA_02B1B8,Y
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.W DATA_02B1BA,Y
    STA.W SpriteXPosHigh,X
    TYA
    STA.W SpriteMisc157C,X
  + RTS

GenerateBubble:
    LDA.B EffFrame
    AND.B #$7F
    BNE Return02B259
    JSL FindFreeSlotLowPri
    BMI Return02B259
    TYX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$9D
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    JSL GetRand
    PHA
    AND.B #$3F
    ADC.B #$20
    ADC.B Layer1YPos
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    PLA
    AND.B #$01
    TAY
    LDA.B Layer1XPos
    CLC
    ADC.W DATA_02B1B8,Y
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.W DATA_02B1BA,Y
    STA.W SpriteXPosHigh,X
    TYA
    STA.W SpriteMisc157C,X
    JSL GetRand
    AND.B #$03
    TAY
    LDA.W DATA_02B25A,Y
    STA.B SpriteTableC2,X
Return02B259:
    RTS


DATA_02B25A:
    db $00

DATA_02B25B:
    db $01,$02

DATA_02B25D:
    db $00,$10,$E0,$01,$FF,$E8

DATA_02B263:
    db $18

DATA_02B264:
    db $F0

DATA_02B265:
    db $E0,$00,$10,$04,$09,$FF,$04

GenerateDolphin:
    LDA.B EffFrame
    AND.B #$1F
    BNE Return02B2CF
    LDY.W CurrentGenerator
    LDX.W DATA_02B263,Y
    LDA.W DATA_02B265,Y
    STA.B _0
CODE_02B27D:
    LDA.W SpriteStatus,X
    BEQ CODE_02B288
    DEX
    CPX.B _0
    BNE CODE_02B27D
    RTS

CODE_02B288:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$41
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    JSL GetRand
    AND.B #$7F
    ADC.B #$40
    ADC.B Layer1YPos
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    JSL GetRand
    AND.B #$03
    TAY
    LDA.W DATA_02B264,Y
    STA.B SpriteYSpeed,X
    LDY.W CurrentGenerator
    LDA.B Layer1XPos
    CLC
    ADC.W Return02B259,Y
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.W DATA_02B25B,Y
    STA.W SpriteXPosHigh,X
    LDA.W DATA_02B25D,Y
    STA.B SpriteXSpeed,X
    INC.W SpriteMisc151C,X
Return02B2CF:
    RTS


DATA_02B2D0:
    db $F0,$FF

DATA_02B2D2:
    db $FF,$00

DATA_02B2D4:
    db $10,$F0

GenerateEerie:
    LDA.B EffFrame
    AND.B #$3F
    BNE +
    JSL FindFreeSlotLowPri
    BMI +
    TYX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$38
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    JSL GetRand
    AND.B #$7F
    ADC.B #$40
    ADC.B Layer1YPos
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.W RandomNumber+1
    AND.B #$01
    TAY
    LDA.W DATA_02B2D0,Y
    CLC
    ADC.B Layer1XPos
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.W DATA_02B2D2,Y
    STA.W SpriteXPosHigh,X
    LDA.W DATA_02B2D4,Y
    STA.B SpriteXSpeed,X
  + RTS


DATA_02B31F:
    db $3F,$40,$3F,$3F,$40,$40

DATA_02B325:
    db $FA,$FB,$FC,$FD

GenParaEnemy:
    LDA.B EffFrame
    AND.B #$7F
    BNE Return02B386
    JSL FindFreeSlotLowPri
    BMI Return02B386
    TYX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    JSL GetRand
    LSR A
    LDY.W CurrentGenerator
    BCC +
    INY
    INY
    INY
  + LDA.W DATA_02B31F-2,Y
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    LDA.B Layer1YPos
    SEC
    SBC.B #$20
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.W RandomNumber
    AND.B #$FF
    CLC
    ADC.B #$30
    PHP
    ADC.B Layer1XPos
    STA.B SpriteXPosLow,X
    PHP
    AND.B #$0E
    STA.W SpriteMisc1570,X
    LSR A
    AND.B #$03
    TAY
    LDA.W DATA_02B325,Y
    STA.B SpriteXSpeed,X
    LDA.B Layer1XPos+1
    PLP
    ADC.B #$00
    PLP
    ADC.B #$00
    STA.W SpriteXPosHigh,X
Return02B386:
    RTS

CODE_02B387:
    LDA.B SpriteLock
    BNE Return02B3AA
    LDX.B #$07
CODE_02B38D:
    STX.W CurSpriteProcess
    LDA.W ShooterNumber,X
    BEQ CODE_02B3A7
    LDY.W ShooterTimer,X
    BEQ CODE_02B3A4
    PHA
    LDA.B TrueFrame
    LSR A
    BCC +
    DEC.W ShooterTimer,X
  + PLA
CODE_02B3A4:
    JSR CODE_02B3AB
CODE_02B3A7:
    DEX
    BPL CODE_02B38D
Return02B3AA:
    RTS

CODE_02B3AB:
    DEC A
    JSL ExecutePtr

    dw ShootBullet                            ; 00 - Bullet Bill shooter
    dw LaunchTorpedo                          ; 01 - Torpedo Ted launcher
    dw Return02B3AA                           ; 02 - Unused

LaunchTorpedo:
    LDA.W ShooterTimer,X
    BNE Return02B42C
    LDA.B #$50
    STA.W ShooterTimer,X
    LDA.W ShooterYPosLow,X
    CMP.B Layer1YPos
    LDA.W ShooterYPosHigh,X
    SBC.B Layer1YPos+1
    BNE Return02B3AA
    LDA.W ShooterXPosLow,X
    CMP.B Layer1XPos
    LDA.W ShooterXPosHigh,X
    SBC.B Layer1XPos+1
    BNE Return02B3AA
    LDA.W ShooterXPosLow,X
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.B #$10
    CMP.B #$20
    BCC Return02B42C
    JSL FindFreeSlotLowPri
    BMI Return02B42C
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$44                                ; \ Sprite = Torpedo Ted
    STA.W SpriteNumber,Y                      ; /
    LDA.W ShooterXPosLow,X                    ; \ Sprite position = Shooter position
    STA.W SpriteXPosLow,Y                     ; |
    LDA.W ShooterXPosHigh,X                   ; |
    STA.W SpriteXPosHigh,Y                    ; |
    LDA.W ShooterYPosLow,X                    ; |
    STA.W SpriteYPosLow,Y                     ; |
    LDA.W ShooterYPosHigh,X                   ; |
    STA.W SpriteYPosHigh,Y                    ; /
    PHX
    TYX                                       ; X = sprite index
    JSL InitSpriteTables                      ; Setup sprite tables
    JSR SubHorzPosBnk2                        ; \ Direction = Towards Mario
    TYA                                       ; |
    STA.W SpriteMisc157C,X                    ; /
    STA.B _0                                  ; $00 = sprite direction
    LDA.B #$30                                ; \ Set time to stay behind objects
    STA.W SpriteMisc1540,X                    ; /
    PLX                                       ; X = shooter index
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_02B424:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_02B42D                           ; |
    DEY                                       ; |
    BPL CODE_02B424                           ; |
Return02B42C:
    RTS                                       ; / Return if no free slots

CODE_02B42D:
    LDA.B #$08                                ; \ Extended sprite = Torpedo Ted arm
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.W ShooterXPosLow,X
    CLC
    ADC.B #$08
    STA.W ExtSpriteXPosLow,Y
    LDA.W ShooterXPosHigh,X
    ADC.B #$00
    STA.W ExtSpriteXPosHigh,Y
    LDA.W ShooterYPosLow,X
    SEC
    SBC.B #$09
    STA.W ExtSpriteYPosLow,Y
    LDA.W ShooterYPosHigh,X
    SBC.B #$00
    STA.W ExtSpriteYPosHigh,Y
    LDA.B #$90
    STA.W ExtSpriteMisc176F,Y
    PHX
    LDX.B _0
    LDA.W DATA_02B464,X
    STA.W ExtSpriteXSpeed,Y
    PLX
    RTS


DATA_02B464:
    db $01,$FF

ShootBullet:
    LDA.W ShooterTimer,X                      ; \ Return if it's not time to generate
    BNE +                                     ; /
    LDA.B #$60                                ; \ Set time till next generation = 60
    STA.W ShooterTimer,X                      ; /
    LDA.W ShooterYPosLow,X                    ; \ Don't generate if off screen vertically
    CMP.B Layer1YPos                          ; |
    LDA.W ShooterYPosHigh,X                   ; |
    SBC.B Layer1YPos+1                        ; |
    BNE +                                     ; /
    LDA.W ShooterXPosLow,X                    ; \ Don't generate if off screen horizontally
    CMP.B Layer1XPos                          ; |
    LDA.W ShooterXPosHigh,X                   ; |
    SBC.B Layer1XPos+1                        ; |
    BNE +                                     ; /
    LDA.W ShooterXPosLow,X                    ; \ ?? something else related to x position of generator??
    SEC                                       ; |
    SBC.B Layer1XPos                          ; |
    CLC                                       ; |
    ADC.B #$10                                ; |
    CMP.B #$10                                ; |
    BCC +                                     ; /
    LDA.B PlayerXPosNext                      ; \ Don't fire if mario is next to generator
    SBC.W ShooterXPosLow,X                    ; |
    CLC                                       ; |
    ADC.B #$11                                ; |
    CMP.B #$22                                ; |
    BCC +                                     ; /
    JSL FindFreeSlotLowPri                    ; \ Get an index to an unused sprite slot, return if all slots full
    BMI +                                     ; / After: Y has index of sprite being generated
    LDA.B #!SFX_KAPOW                         ; \ Only shoot every #$80 frames
    STA.W SPCIO3                              ; / Play sound effect
    LDA.B #$01                                ; \ Sprite status = Initialization
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$1C                                ; \ New sprite = Bullet Bill
    STA.W SpriteNumber,Y                      ; /
    LDA.W ShooterXPosLow,X                    ; \ Set x position for new sprite
    STA.W SpriteXPosLow,Y                     ; |
    LDA.W ShooterXPosHigh,X                   ; |
    STA.W SpriteXPosHigh,Y                    ; /
    LDA.W ShooterYPosLow,X                    ; \ Set y position for new sprite
    SEC                                       ; | (y position of generator - 1)
    SBC.B #$01                                ; |
    STA.W SpriteYPosLow,Y                     ; |
    LDA.W ShooterYPosHigh,X                   ; |
    SBC.B #$00                                ; |
    STA.W SpriteYPosHigh,Y                    ; /
    PHX                                       ; \ Before: X must have index of sprite being generated
    TYX                                       ; | Routine clears *all* old sprite values...
    JSL InitSpriteTables                      ; | ...and loads in new values for the 6 main sprite tables
    PLX                                       ; /
    JSR ShowShooterSmoke                      ; Display smoke graphic
  + RTS

ShowShooterSmoke:
    LDY.B #$03                                ; \ Find a free slot to display effect
FindFreeSmokeSlot:
    LDA.W SmokeSpriteNumber,Y                 ; |
    BEQ SetShooterSmoke                       ; |
    DEY                                       ; |
    BPL FindFreeSmokeSlot                     ; |
    RTS                                       ; / Return if no free slots


ShooterSmokeDispX:
    db $F4,$0C

SetShooterSmoke:
    LDA.B #$01                                ; \ Set effect graphic to smoke graphic
    STA.W SmokeSpriteNumber,Y                 ; /
    LDA.W ShooterYPosLow,X                    ; \ Smoke y position = generator y position
    STA.W SmokeSpriteYPos,Y                   ; /
    LDA.B #$1B                                ; \ Set time to show smoke
    STA.W SmokeSpriteTimer,Y                  ; /
    LDA.W ShooterXPosLow,X                    ; \ Load generator x position and store it for later
    PHA                                       ; /
    LDA.B PlayerXPosNext                      ; \ Determine which side of the generator mario is on
    CMP.W ShooterXPosLow,X                    ; |
    LDA.B PlayerXPosNext+1                    ; |
    SBC.W ShooterXPosHigh,X                   ; |
    LDX.B #$00                                ; |
    BCC +                                     ; |
    INX                                       ; /
  + PLA                                       ; \ Set smoke x position from generator position
    CLC                                       ; |
    %LorW_X(ADC,ShooterSmokeDispX)            ; |
    STA.W SmokeSpriteXPos,Y                   ; /
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_02B51A:
    TXA
    CLC
    ADC.B #$04
    TAX
    JSR CODE_02B526
    LDX.W MinorSpriteProcIndex
    RTS

CODE_02B526:
    LDA.W BounceSpriteYSpeed,X
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.W BounceSpriteXPosSpx,X
    STA.W BounceSpriteXPosSpx,X
    PHP
    LDA.W BounceSpriteYSpeed,X
    LSR A
    LSR A
    LSR A
    LSR A
    CMP.B #$08
    LDY.B #$00
    BCC +
    ORA.B #$F0
    DEY
  + PLP
    ADC.W BounceSpriteYPosLow,X
    STA.W BounceSpriteYPosLow,X
    TYA
    ADC.W BounceSpriteYPosHigh,X
    STA.W BounceSpriteYPosHigh,X
    RTS

CODE_02B554:
    TXA
    CLC
    ADC.B #$0A
    TAX
    JSR CODE_02B560
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_02B560:
    LDA.W ExtSpriteYSpeed,X
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.W ExtSpriteYPosSpx,X
    STA.W ExtSpriteYPosSpx,X
    PHP
    LDY.B #$00
    LDA.W ExtSpriteYSpeed,X
    LSR A
    LSR A
    LSR A
    LSR A
    CMP.B #$08
    BCC +
    ORA.B #$F0
    DEY
  + PLP
    ADC.W ExtSpriteYPosLow,X
    STA.W ExtSpriteYPosLow,X
    TYA
    ADC.W ExtSpriteYPosHigh,X
    STA.W ExtSpriteYPosHigh,X
    RTS

CODE_02B58E:
    LDA.W CoinSpriteYSpeed,X
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.W CoinSpriteYPosSpx,X
    STA.W CoinSpriteYPosSpx,X
    PHP
    LDY.B #$00
    LDA.W CoinSpriteYSpeed,X
    LSR A
    LSR A
    LSR A
    LSR A
    CMP.B #$08
    BCC +
    ORA.B #$F0
    DEY
  + PLP
    ADC.W CoinSpriteYPosLow,X
    STA.W CoinSpriteYPosLow,X
    TYA
    ADC.W CoinSpriteYPosHigh,X
    STA.W CoinSpriteYPosHigh,X
    RTS

CODE_02B5BC:
    TXA
    CLC
    ADC.B #$0C
    TAX
    JSR CODE_02B5C8
    LDX.W MinorSpriteProcIndex
    RTS

CODE_02B5C8:
    LDA.W MinExtSpriteYSpeed,X
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.W MinExtSpriteYPosSpx,X
    STA.W MinExtSpriteYPosSpx,X
    PHP
    LDA.W MinExtSpriteYSpeed,X
    LSR A
    LSR A
    LSR A
    LSR A
    CMP.B #$08
    BCC +
    ORA.B #$F0
  + PLP
    ADC.W MinExtSpriteYPosLow,X
    STA.W MinExtSpriteYPosLow,X
    RTS

    %insert_empty($26,$44,$44,$44,$44)

PokeyClipIndex:
    db $1B,$1B,$1A,$19,$18,$17

PokeyMain:
    PHB
    PHK
    PLB
    JSR PokeyMainRt
    LDA.B SpriteTableC2,X                     ; \ After: Y = number of segments
    PHX                                       ; | $C2,x has a bit set for each segment remaining
    LDX.B #$04                                ; | for X=0 to X=4...
    LDY.B #$00                                ; |
PokeyLoopStart:
    LSR A                                     ; |
    BCC +                                     ; |
    INY                                       ; | ...Increment Y if bit X is set
  + DEX                                       ; |
    BPL PokeyLoopStart                        ; |
    PLX                                       ; /
    LDA.W PokeyClipIndex,Y                    ; \ Update the index into the clipping table
    STA.W SpriteTweakerB,X                    ; /
    PLB
    RTL


DATA_02B653:
    db $01,$02,$04,$08

DATA_02B657:
    db $00,$01,$03,$07

DATA_02B65B:
    db $FF,$FE,$FC,$F8

PokeyTileDispX:
    db $00,$01,$00,$FF

PokeySpeed:
    db $02,$FE

DATA_02B665:
    db $00,$05,$09,$0C,$0E,$0F,$10,$10
    db $10,$10,$10,$10,$10

PokeyMainRt:
    LDA.W SpriteMisc1534,X
    BNE CODE_02B681
    LDA.W SpriteStatus,X                      ; \ Branch if Status == Normal
    CMP.B #$08                                ; |
    BEQ CODE_02B6A7                           ; /
    JMP CODE_02B726

CODE_02B681:
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B SpriteTableC2,X
    CMP.B #$01
    LDA.B #$8A
    BCC +
    LDA.B #$E8
  + STA.W OAMTileNo+$100,Y
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE +
    JSR UpdateYPosNoGrvty
    INC.B SpriteYSpeed,X
    INC.B SpriteYSpeed,X
    JSR SubOffscreen0Bnk2
  + RTS

CODE_02B6A7:
    LDA.B SpriteTableC2,X                     ; \ Erase sprite if no segments remain
    BNE +                                     ; |
  - STZ.W SpriteStatus,X                      ; |
    RTS

  + CMP.B #$20
    BCS -
    LDA.B SpriteLock
    BNE CODE_02B726
    JSR SubOffscreen0Bnk2
    JSL MarioSprInteract
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    AND.B #$7F
    BNE +
    JSR CODE_02D4FA
    TYA
    STA.W SpriteMisc157C,X
  + LDY.W SpriteMisc157C,X
    LDA.W PokeySpeed,Y
    STA.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty
    JSR UpdateYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +
    CLC
    ADC.B #$02
    STA.B SpriteYSpeed,X
  + JSL CODE_019138
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.W SpriteBlockedDirs,X
    AND.B #$03
    BEQ +
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + JSR CODE_02B7AC
    LDY.B #$00
CODE_02B709:
    LDA.B SpriteTableC2,X
    AND.W DATA_02B653,Y
    BNE +
    LDA.B SpriteTableC2,X
    PHA
    AND.W DATA_02B657,Y
    STA.B _0
    PLA
    LSR A
    AND.W DATA_02B65B,Y
    ORA.B _0
    STA.B SpriteTableC2,X
  + INY
    CPY.B #$04
    BNE CODE_02B709
CODE_02B726:
    JSR GetDrawInfo2
    LDA.B _1
    CLC
    ADC.B #$40
    STA.B _1
    LDA.B SpriteTableC2,X
    STA.B _2
    STA.B _7
    LDA.W SpriteMisc151C,X
    STA.B _4
    LDY.W SpriteMisc1540,X
    LDA.W DATA_02B665,Y
    STA.B _3
    STZ.B _5
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    LDX.B #$04
CODE_02B74B:
    STX.B _6
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    CLC
    ADC.B _6
    AND.B #$03
    TAX
    LDA.B _7
    CMP.B #$01
    BNE +
    LDX.B #$00
  + LDA.B _0
    CLC
    ADC.W PokeyTileDispX,X
    STA.W OAMTileXPos+$100,Y
    LDX.B _6
    LDA.B _1
    LSR.B _2
    BCC CODE_02B781
    LSR.B _4
    BCS +
    PHA
    LDA.B _3
    STA.B _5
    PLA
  + SEC
    SBC.B _5
    STA.W OAMTileYPos+$100,Y
CODE_02B781:
    LDA.B _1
    SEC
    SBC.B #$10
    STA.B _1
    LDA.B _2
    LSR A
    LDA.B #$E8
    BCS +
    LDA.B #$8A
  + STA.W OAMTileNo+$100,Y
    LDA.B #$05
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_02B74B
    PLX
    LDA.B #$04
    LDY.B #$02
CODE_02B7A7:
    JSL FinishOAMWrite
    RTS

CODE_02B7AC:
    LDY.B #$09
CODE_02B7AE:
    TYA
    EOR.B TrueFrame
    LSR A
    BCS CODE_02B7D2
    LDA.W SpriteStatus,Y
    CMP.B #$0A
    BNE CODE_02B7D2
    PHB
    LDA.B #$03
    PHA
    PLB
    PHX
    TYX
    JSL GetSpriteClippingB
    PLX
    JSL GetSpriteClippingA
    JSL CheckForContact
    PLB
    BCS CODE_02B7D6
CODE_02B7D2:
    DEY
    BPL CODE_02B7AE
  - RTS

CODE_02B7D6:
    LDA.W SpriteMisc1558,X
    BNE -
    LDA.W SpriteYPosLow,Y
    SEC
    SBC.B SpriteYPosLow,X
    PHY
    STY.W SpriteInterIndex
    JSR RemovePokeySgmntRt
    PLY
    JSR CODE_02B82E
    RTS

RemovePokeySgmntRt:
    LDY.B #$00
    CMP.B #$09
    BMI +
    INY
    CMP.B #$19
    BMI +
    INY
    CMP.B #$29
    BMI +
    INY
    CMP.B #$39
    BMI +
    INY
  + LDA.B SpriteTableC2,X                     ; \ Take away a segment by unsetting a bit
    AND.W PokeyUnsetBit,Y                     ; |
    STA.B SpriteTableC2,X                     ; /
    STA.W SpriteMisc151C,X
    LDA.W DATA_02B829,Y
    STA.B _D
    LDA.B #$0C
    STA.W SpriteMisc1540,X
    ASL A
    STA.W SpriteMisc1558,X
    RTS

RemovePokeySegment:
    PHB                                       ; Wrapper
    PHK
    PLB
    JSR RemovePokeySgmntRt
    PLB
    RTL


PokeyUnsetBit:
    db $EF,$F7,$FB,$FD,$FE

DATA_02B829:
    db $E0,$F0,$F8,$FC,$FE

CODE_02B82E:
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BMI +                                     ; /
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$70
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    LDX.W SpriteInterIndex
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    LDA.B SpriteXSpeed,X
    STA.B _0
    ASL A
    ROR.B _0
    LDA.B _0
    STA.W SpriteXSpeed,Y
    LDA.B #$E0
    STA.W SpriteYSpeed,Y
    PLX
    LDA.B SpriteTableC2,X
    AND.B _D
    STA.W SpriteTableC2,Y
    LDA.B #$01
    STA.W SpriteMisc1534,Y
    LDA.B #$01
    JSL CODE_02ACE1
  + RTS

TorpedoTedMain:
    PHB
    PHK
    PLB
    JSR CODE_02B88A
    PLB
    RTL

CODE_02B88A:
    LDA.B SpriteProperties                    ; \ Save $64
    PHA                                       ; /
    LDA.W SpriteMisc1540,X                    ; \ If being launched...
    BEQ +                                     ; | ...set $64 = #$10...
    LDA.B #$10                                ; | ...so it will be drawn behind objects
    STA.B SpriteProperties                    ; /
  + JSR TorpedoGfxRt                          ; Draw sprite
    PLA                                       ; \ Restore $64
    STA.B SpriteProperties                    ; /
    LDA.B SpriteLock                          ; \ Return if sprites locked
    BNE Return02B8B7                          ; /
    JSR SubOffscreen0Bnk2
    JSL SprSpr_MarioSprRts
    LDA.W SpriteMisc1540,X                    ; \ Branch if not being launched
    BEQ +                                     ; /
    LDA.B #$08                                ; \ Sprite Y speed = #$08
    STA.B SpriteYSpeed,X                      ; /
    JSR UpdateYPosNoGrvty                     ; Apply speed to position
    LDA.B #$10                                ; \ Sprite Y speed = #$10
    STA.B SpriteYSpeed,X                      ; /
Return02B8B7:
    RTS


TorpedoMaxSpeed:
    db $20,$F0

TorpedoAccel:
    db $01,$FF

  + LDA.B TrueFrame                           ; \ Only increase X speed every 4 frames
    AND.B #$03                                ; |
    BNE +                                     ; /
    LDY.W SpriteMisc157C,X                    ; \ If not at maximum, increase X speed
    LDA.B SpriteXSpeed,X                      ; |
    CMP.W TorpedoMaxSpeed,Y                   ; |
    BEQ +                                     ; |
    CLC                                       ; |
    ADC.W TorpedoAccel,Y                      ; |
    STA.B SpriteXSpeed,X                      ; /
  + JSR UpdateXPosNoGrvty                     ; \ Apply speed to position
    JSR UpdateYPosNoGrvty                     ; /
    LDA.B SpriteYSpeed,X                      ; \ If sprite has Y speed...
    BEQ +                                     ; |
    LDA.B TrueFrame                           ; | ...Decrease Y speed every other frame
    AND.B #$01                                ; |
    BNE +                                     ; |
    DEC.B SpriteYSpeed,X                      ; /
  + TXA                                       ; \ Run $02B952 every 8 frames
    CLC                                       ; |
    ADC.B EffFrame                            ; |
    AND.B #$07                                ; |
    BNE +                                     ; |
    JSR CODE_02B952                           ; /
  + RTS


DATA_02B8F0:
    db $10

DATA_02B8F1:
    db $00,$10,$80,$82

DATA_02B8F5:
    db $40,$00

TorpedoGfxRt:
    JSR GetDrawInfo2
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    PHX
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties
    STA.B _2
    LDA.W SpriteMisc157C,X
    TAX
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02B8F0)
    STA.W OAMTileXPos+$100,Y
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02B8F1)
    STA.W OAMTileXPos+$104,Y
    %LorW_X(LDA,DATA_02B8F5)
    ORA.B _2
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    PLX
    LDA.B #$80
    STA.W OAMTileNo+$100,Y
    LDA.W SpriteMisc1540,X
    CMP.B #$01
    LDA.B #$82
    BCS +
    LDA.B EffFrame
    LSR A
    LSR A
    LDA.B #$A0
    BCC +
    LDA.B #$82
  + STA.W OAMTileNo+$104,Y
    LDA.B #$01
    LDY.B #$02
    JMP CODE_02B7A7


DATA_02B94E:
    db $F4,$1C

DATA_02B950:
    db $FF,$00

CODE_02B952:
    LDY.B #$03
CODE_02B954:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_02B969
    DEY
    BPL CODE_02B954
    DEC.W SmokeSpriteSlotFull
    BPL +
    LDA.B #$03
    STA.W SmokeSpriteSlotFull
  + LDY.W SmokeSpriteSlotFull
CODE_02B969:
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    PHX
    LDA.W SpriteMisc157C,X
    TAX
    LDA.B _0
    CLC
    ADC.W DATA_02B94E,X
    STA.B _2
    LDA.B _1
    ADC.W DATA_02B950,X
    PHA
    LDA.B _2
    CMP.B Layer1XPos
    PLA
    PLX
    SBC.B Layer1XPos+1
    BNE +
    LDA.B #$01
    STA.W SmokeSpriteNumber,Y
    LDA.B _2
    STA.W SmokeSpriteXPos,Y
    LDA.B SpriteYPosLow,X
    STA.W SmokeSpriteYPos,Y
    LDA.B #$0F
    STA.W SmokeSpriteTimer,Y
  + RTS

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
    RTL

CODE_02B9BD:
    LDA.B #$02
    STA.W SilverCoinsCollected
    LDY.B #$09
CODE_02B9C4:
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BCC +
    LDA.W SpriteTweakerF,Y
    AND.B #$40
    BNE +
    JSR CODE_02B9D9
  + DEY
    BPL CODE_02B9C4
    RTL

CODE_02B9D9:
    LDA.B #$21
    STA.W SpriteNumber,Y
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    PHX
    TYX
    JSL InitSpriteTables
    LDA.W SpriteOBJAttribute,X
    AND.B #$F1
    ORA.B #$02
    STA.W SpriteOBJAttribute,X
    LDA.B #$D8
    STA.W SpriteYSpeed,X
    PLX
    RTS

CODE_02B9FA:
    STZ.B _F
    BRA CODE_02BA48

    LDA.B _1                                  ; \ Unreachable
    AND.B #$F0                                ; | Very similar to code below
    STA.B _4
    LDA.B _9
    CMP.B LevelScrLength
    BCS Return02BA47
    STA.B _5
    LDA.B _0
    STA.B _7
    LDA.B _8
    CMP.B #$02
    BCS Return02BA47
    STA.B _A
    LDA.B _7
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _4
    STA.B _4
    LDX.B _5
    LDA.L DATA_00BA80,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA8E,X
  + CLC
    ADC.B _4
    STA.B _5
    LDA.L DATA_00BABC,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BACA,X
  + ADC.B _A
    STA.B _6
    BRA CODE_02BA92

Return02BA47:
    RTL

CODE_02BA48:
    LDA.B _1
    AND.B #$F0
    STA.B _4
    LDA.B _9
    CMP.B #$02
    BCS Return02BA47
    STA.B _D
    STA.W YoshiYPos+1
    LDA.B _0
    STA.B _6
    LDA.B _8
    CMP.B LevelScrLength
    BCS Return02BA47
    STA.B _7
    LDA.B _6
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _4
    STA.B _4
    LDX.B _7
    LDA.L DATA_00BA60,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA70,X
  + CLC
    ADC.B _4
    STA.B _5
    LDA.L DATA_00BA9C,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BAAC,X
  + ADC.B _D
    STA.B _6
CODE_02BA92:
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B #$7E
    STA.B _7
    LDA.B [_5]
    STA.W Map16TileNumber
    INC.B _7
    LDA.B [_5]
    BNE Return02BABF
    LDA.W Map16TileNumber
    CMP.B #$45                                ; If it is <= the Red Berry map16 tile
    BCC Return02BABF
    CMP.B #$48                                ; If it is => Map16 always turning block
    BCS Return02BABF
    SEC
    SBC.B #$44
    STA.W EatenBerryType                      ;Berry Type
    LDY.B #$0B
CODE_02BAB7:
    LDA.W SpriteStatus,Y                      ; \ Find a free sprite slot and branch
    BEQ CODE_02BAC0                           ; |
    DEY                                       ; |
    BPL CODE_02BAB7                           ; /
Return02BABF:
    RTL                                       ; Return if no slots found

CODE_02BAC0:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$74                                ; \ Sprite number = Mushroom
    STA.W SpriteNumber,Y                      ; /
    LDA.B _0                                  ; \ Sprite and block X position = $00,$08
    STA.W SpriteXPosLow,Y                     ; |
    STA.B TouchBlockXPos                      ; |
    LDA.B _8                                  ; |
    STA.W SpriteXPosHigh,Y                    ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B _1                                  ; \ Sprite and block Y position = $01,$09
    STA.W SpriteYPosLow,Y                     ; |
    STA.B TouchBlockYPos                      ; |
    LDA.B _9                                  ; |
    STA.W SpriteYPosHigh,Y                    ; |
    STA.B TouchBlockYPos+1                    ; /
    PHX
    TYX
    JSL InitSpriteTables                      ; Reset sprite tables
    INC.W SpriteMisc160E,X                    ; ?
    LDA.W SpriteTweakerB,X                    ; \ Change the index into sprite clipping table
    AND.B #$F0                                ; | to "resize" the sprite
    ORA.B #$0C                                ; |
    STA.W SpriteTweakerB,X                    ; /
    LDA.W SpriteTweakerD,X                    ; \ No longer gives powerup when eaten
    AND.B #$BF                                ; |
    STA.W SpriteTweakerD,X                    ; /
    PLX
    LDA.B #$04                                ; \ Block to generate = Tree behind berry
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile                          ; Generate the tile
    RTL


DATA_02BB0B:
    db $02,$FA,$06,$06

DATA_02BB0F:
    db $00,$FF,$00,$00

DATA_02BB13:
    db $10,$08,$10,$08

YoshiWingsTiles:
    db $5D,$C6,$5D,$C6

YoshiWingsGfxProp:
    db $46,$46,$06,$06

YoshiWingsSize:
    db $00,$02,$00,$02

CODE_02BB23:
    STA.B _2
    JSR IsSprOffScreenBnk2
    BNE Return02BB87
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _4
    LDA.B SpriteYPosLow,X
    STA.B _1
    LDY.B #$F8
    PHX
    LDA.W SpriteMisc157C,X
    ASL A
    ADC.B _2
    TAX
    LDA.B _0
    CLC
    ADC.L DATA_02BB0B,X
    STA.B _0
    LDA.B _4
    ADC.L DATA_02BB0F,X
    PHA
    LDA.B _0
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos,Y
    PLA
    SBC.B Layer1XPos+1
    BNE +
    LDA.B _1
    SEC
    SBC.B Layer1YPos
    CLC
    ADC.L DATA_02BB13,X
    STA.W OAMTileYPos,Y
    LDA.L YoshiWingsTiles,X
    STA.W OAMTileNo,Y
    LDA.B SpriteProperties
    ORA.L YoshiWingsGfxProp,X
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.L YoshiWingsSize,X
    STA.W OAMTileSize,Y
  + PLX
Return02BB87:
    RTL


DATA_02BB88:
    db $FF,$01,$FF,$01,$00,$00

DATA_02BB8E:
    db $E8,$18,$F8,$08,$00,$00

DolphinMain:
    JSR CODE_02BC14
    LDA.B SpriteLock
    BNE Return02BBFF
    JSR SubOffscreen1Bnk2
    JSR UpdateYPosNoGrvty
    JSR UpdateXPosNoGrvty
    STA.W SpriteMisc1528,X
    LDA.B EffFrame
    AND.B #$00
    BNE CODE_02BBB7
    LDA.B SpriteYSpeed,X
    BMI CODE_02BBB5
    CMP.B #$3F
    BCS CODE_02BBB7
CODE_02BBB5:
    INC.B SpriteYSpeed,X
CODE_02BBB7:
    TXA
    EOR.B TrueFrame
    LSR A
    BCC +
    JSL CODE_019138
  + LDA.B SpriteYSpeed,X
    BMI CODE_02BBFB
    LDA.W SpriteInLiquid,X
    BEQ CODE_02BBFB
    LDA.B SpriteYSpeed,X
    BEQ +
    SEC
    SBC.B #$08
    STA.B SpriteYSpeed,X
    BPL +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.W SpriteMisc151C,X
    BNE CODE_02BBF7
    LDA.B SpriteTableC2,X
    LSR A
    PHP
    LDA.B SpriteNumber,X
    SEC
    SBC.B #$41
    PLP
    ROL A
    TAY
    LDA.B SpriteXSpeed,X
    CLC
    ADC.W DATA_02BB88,Y
    STA.B SpriteXSpeed,X
    CMP.W DATA_02BB8E,Y
    BNE CODE_02BBFB
    INC.B SpriteTableC2,X
CODE_02BBF7:
    LDA.B #$C0
    STA.B SpriteYSpeed,X
CODE_02BBFB:
    JSL InvisBlkMainRt
Return02BBFF:
    RTL

CODE_02BC00:
    LDA.B EffFrame
    AND.B #$04
    LSR A
    LSR A
    STA.W SpriteMisc157C,X
    JSL GenericSprGfxRt1
    RTS


DolphinTiles1:
    db $E2,$88

DolphinTiles2:
    db $E7,$A8

DolphinTiles3:
    db $E8,$A9

CODE_02BC14:
    LDA.B SpriteNumber,X
    CMP.B #$43
    BNE +
    JMP CODE_02BC00

  + JSR GetDrawInfo2
    LDA.B SpriteXSpeed,X
    STA.B _2
    LDA.B _0
    ASL.B _2
    PHP
    BCC CODE_02BC3C
    STA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$104,Y
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$108,Y
    BRA +

CODE_02BC3C:
    CLC
    ADC.B #$18
    STA.W OAMTileXPos+$100,Y
    SEC
    SBC.B #$10
    STA.W OAMTileXPos+$104,Y
    SEC
    SBC.B #$08
    STA.W OAMTileXPos+$108,Y
  + LDA.B _1
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    STA.W OAMTileYPos+$108,Y
    PHX
    LDA.B EffFrame
    AND.B #$08
    LSR A
    LSR A
    LSR A
    TAX
    LDA.W DolphinTiles1,X
    STA.W OAMTileNo+$100,Y
    LDA.W DolphinTiles2,X
    STA.W OAMTileNo+$104,Y
    LDA.W DolphinTiles3,X
    STA.W OAMTileNo+$108,Y
    PLX
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties
    PLP
    BCS +
    ORA.B #$40
  + STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y
    LDA.B #$02
    LDY.B #$02
    JMP CODE_02B7A7


DATA_02BC8F:
    db $08,$00,$F8,$00,$F8,$00,$08,$00
DATA_02BC97:
    db $00,$08,$00,$F8,$00,$08,$00,$F8
DATA_02BC9F:
    db $01,$FF,$FF,$01,$FF,$01,$01,$FF
DATA_02BCA7:
    db $01,$01,$FF,$FF,$01,$01,$FF,$FF
DATA_02BCAF:
    db $01,$04,$02,$08,$02,$04,$01,$08
DATA_02BCB7:
    db $00,$02,$00,$02,$00,$02,$00,$02
    db $05,$04,$05,$04,$05,$04,$05,$04
DATA_02BCC7:
    db $00,$C0,$C0,$00,$40,$80,$80,$40
    db $80,$C0,$40,$00,$C0,$80,$00,$40
DATA_02BCD7:
    db $00,$01,$02,$01

WallFollowersMain:
    JSL SprSprInteract
    JSL GetRand
    AND.B #$FF
    ORA.B SpriteLock
    BNE +
    LDA.B #$0C
    STA.W SpriteMisc1558,X
  + LDA.B SpriteNumber,X                      ; \ Branch if not Spike Top
    CMP.B #$2E                                ; |
    BNE CODE_02BD23                           ; /
    LDY.B SpriteTableC2,X
    LDA.W SpriteMisc1564,X
    BEQ CODE_02BD04
    TYA
    CLC
    ADC.B #$08
    TAY
    LDA.B #$00
    BRA +

CODE_02BD04:
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    AND.B #$01
  + CLC
    ADC.W DATA_02BCB7,Y
    STA.W SpriteMisc1602,X
    LDA.W SpriteOBJAttribute,X
    AND.B #$3F
    ORA.W DATA_02BCC7,Y
    STA.W SpriteOBJAttribute,X
    JSL GenericSprGfxRt2
    BRA CODE_02BD2F

CODE_02BD23:
    CMP.B #$A5
    BCC CODE_02BD2C
    JSR CODE_02BE4E
    BRA CODE_02BD2F

CODE_02BD2C:
    JSR CODE_02BF5C
CODE_02BD2F:
    LDA.W SpriteStatus,X
    CMP.B #$08
    BEQ +
    STZ.W SpriteMisc1528,X
    LDA.B #$FF
    STA.W SpriteMisc1558,X
    RTL

  + LDA.B SpriteLock
    BNE Return02BD74
    JSR SubOffscreen3Bnk2
    JSL MarioSprInteract
    LDA.B SpriteNumber,X                      ; \ Branch if Spike Top
    CMP.B #$2E                                ; |
    BEQ CODE_02BDA7                           ; /
    CMP.B #$3C                                ; \ Branch if Wall-follow Urchin
    BEQ CODE_02BDB3                           ; /
    CMP.B #$A5                                ; \ Branch if Ground-guided Fuzzball/Sparky
    BEQ CODE_02BDB3                           ; /
    CMP.B #$A6                                ; \ Branch if Ground-guided Hothead
    BEQ CODE_02BDB3                           ; /
    LDA.B SpriteTableC2,X
    AND.B #$01
    JSL ExecutePtr

    dw CODE_02BD68
    dw CODE_02BD75

CODE_02BD68:
    LDA.W SpriteMisc1540,X
    BNE Return02BD74
    LDA.B #$80
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
Return02BD74:
    RTL

CODE_02BD75:
    LDA.B SpriteNumber,X                      ; \ Branch if Wall-detect Urchin
    CMP.B #$3B                                ; |
    BEQ CODE_02BD80                           ; /
    LDA.W SpriteMisc1540,X
    BEQ CODE_02BD91
CODE_02BD80:
    JSR UpdateXPosNoGrvty
    JSR UpdateYPosNoGrvty
    JSL CODE_019138
    LDA.W SpriteBlockedDirs,X
    AND.B #$0F
    BEQ +
CODE_02BD91:
    LDA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.B SpriteXSpeed,X
    LDA.B SpriteYSpeed,X
    EOR.B #$FF
    INC A
    STA.B SpriteYSpeed,X
    LDA.B #$40
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + RTL

CODE_02BDA7:
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$E0
    BCC CODE_02BDB3
    STZ.W SpriteStatus,X
CODE_02BDB3:
    LDA.W SpriteMisc1540,X
    BNE CODE_02BDE7
    LDY.B SpriteTableC2,X
    LDA.W DATA_02BCA7,Y
    STA.B SpriteYSpeed,X
    LDA.W DATA_02BC9F,Y
    STA.B SpriteXSpeed,X
    JSL CODE_019138
    LDA.W SpriteBlockedDirs,X
    AND.B #$0F
    BNE CODE_02BDE7
    LDA.B #$08
    STA.W SpriteMisc1564,X
    LDA.B #$38
    LDY.B SpriteNumber,X                      ; \ Branch if Wall-follow Urchin
    CPY.B #$3C                                ; |
    BEQ +                                     ; /
    LDA.B #$1A
    CPY.B #$A5
    BNE +
    LSR A
    NOP
  + STA.W SpriteMisc1540,X
CODE_02BDE7:
    LDA.B #$20
    LDY.B SpriteNumber,X                      ; \ Branch if Wall-follow Urchin
    CPY.B #$3C                                ; |
    BEQ +                                     ; /
    LDA.B #$10
    CPY.B #$A5
    BNE +
    LSR A
    NOP
  + CMP.W SpriteMisc1540,X
    BNE CODE_02BE0E
    INC.B SpriteTableC2,X
    LDA.B SpriteTableC2,X
    CMP.B #$04
    BNE +
    STZ.B SpriteTableC2,X
  + CMP.B #$08
    BNE CODE_02BE0E
    LDA.B #$04
    STA.B SpriteTableC2,X
CODE_02BE0E:
    LDY.B SpriteTableC2,X
    LDA.W SpriteBlockedDirs,X
    AND.W DATA_02BCAF,Y
    BEQ CODE_02BE2F
    LDA.B #$08
    STA.W SpriteMisc1564,X
    DEC.B SpriteTableC2,X
    LDA.B SpriteTableC2,X
    BPL CODE_02BE27
    LDA.B #$03
    BRA CODE_02BE2D

CODE_02BE27:
    CMP.B #$03
    BNE CODE_02BE2F
    LDA.B #$07
CODE_02BE2D:
    STA.B SpriteTableC2,X
CODE_02BE2F:
    LDY.B SpriteTableC2,X
    LDA.W DATA_02BC97,Y
    STA.B SpriteYSpeed,X
    LDA.W DATA_02BC8F,Y
    STA.B SpriteXSpeed,X
    LDA.B SpriteNumber,X                      ; \ Branch if not Ground-guided Fuzzball/Sparky
    CMP.B #$A5                                ; |
    BNE +                                     ; /
    ASL.B SpriteXSpeed,X
    ASL.B SpriteYSpeed,X
  + JSR UpdateXPosNoGrvty
    JSR UpdateYPosNoGrvty
    RTL


DATA_02BE4C:
    db $05,$45

CODE_02BE4E:
    LDA.B SpriteNumber,X
    CMP.B #$A5
    BNE CODE_02BEB5
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteTileset
    CMP.B #$02
    BNE +
    PHX
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$01
    TAX
    LDA.B #$C8
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02BE4C,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLX
    RTS

  + LDA.B #$0A
    STA.W OAMTileNo+$100,Y
    LDA.B EffFrame
    AND.B #$0C
    ASL A
    ASL A
    ASL A
    ASL A
    EOR.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$100,Y
    RTS


DATA_02BE8D:
    db $F8,$08,$F8,$08

DATA_02BE91:
    db $F8,$F8,$08,$08

HotheadTiles:
    db $0C,$0E,$0E,$0C,$0E,$0C,$0C,$0E
DATA_02BE9D:
    db $05,$05,$C5,$C5,$45,$45,$85,$85
DATA_02BEA5:
    db $07,$07,$01,$01,$01,$01,$07,$07
DATA_02BEAD:
    db $00,$08,$08,$00,$00,$08,$08,$00

CODE_02BEB5:
    JSR GetDrawInfo2
    TYA
    CLC
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    TAY
    LDA.B EffFrame
    AND.B #$04
    STA.B _3
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC
    ADC.W DATA_02BE8D,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_02BE91,X
    STA.W OAMTileYPos+$100,Y
    PHX
    TXA
    ORA.B _3
    TAX
    LDA.W HotheadTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02BE9D,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLX
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    LDA.B _0
    PHA
    LDA.B _1
    PHA
    LDY.B #$02
    LDA.B #$03
    JSR CODE_02B7A7
    PLA
    STA.B _1
    PLA
    STA.B _0
    LDA.B #$09
    LDY.W SpriteMisc1558,X
    BEQ +
    LDA.B #$19
  + STA.B _2
    LDA.W SpriteOAMIndex,X
    SEC
    SBC.B #$04
    STA.W SpriteOAMIndex,X
    TAY
    PHX
    LDA.B SpriteTableC2,X
    TAX
    LDA.B _0
    CLC
    ADC.W DATA_02BEA5,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_02BEAD,X
    STA.W OAMTileYPos+$100,Y
    LDA.B _2
    STA.W OAMTileNo+$100,Y
    LDA.B #$05
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLX
    LDY.B #$00
    LDA.B #$00
    JMP CODE_02B7A7


DATA_02BF49:
    db $08,$00,$10,$00,$10

DATA_02BF4E:
    db $08,$00,$00,$10,$10

DATA_02BF53:
    db $37,$37,$77,$B7,$F7

UrchinTiles:
    db $C4,$C6,$C8,$C6

CODE_02BF5C:
    LDA.W SpriteMisc163E,X
    BNE +
    INC.W SpriteMisc1528,X
    LDA.B #$0C
    STA.W SpriteMisc163E,X
  + LDA.W SpriteMisc1528,X
    AND.B #$03
    TAY
    LDA.W DATA_02BCD7,Y
    STA.W SpriteMisc1602,X
    JSR GetDrawInfo2
    STZ.B _5
    LDA.W SpriteMisc1602,X
    STA.B _2
    LDA.W SpriteMisc1558,X
    STA.B _3
CODE_02BF84:
    LDX.B _5
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02BF49)
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    %LorW_X(ADC,DATA_02BF4E)
    STA.W OAMTileYPos+$100,Y
    %LorW_X(LDA,DATA_02BF53)
    STA.W OAMTileAttr+$100,Y
    CPX.B #$00
    BNE CODE_02BFAC
    LDA.B #$CA
    LDX.B _3
    BEQ +
    LDA.B #$CC
  + BRA +

CODE_02BFAC:
    LDX.B _2
    %LorW_X(LDA,UrchinTiles)
  + STA.W OAMTileNo+$100,Y
    INY
    INY
    INY
    INY
    INC.B _5
    LDA.B _5
    CMP.B #$05
    BNE CODE_02BF84
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDY.B #$02
    JMP CODE_02C82B


DATA_02BFC8:
    db $10,$F0

DATA_02BFCA:
    db $01,$FF

  - RTL

RipVanFishMain:
    JSL GenericSprGfxRt2
    LDA.B SpriteLock
    BNE -
    JSR SubOffscreen0Bnk2
    JSL SprSpr_MarioSprRts
    LDA.B SpriteXSpeed,X
    PHA
    LDA.B SpriteYSpeed,X
    PHA
    LDY.W InvinsibilityTimer                  ; \ Branch if Mario doesn't have star
    BEQ +                                     ; /
    EOR.B #$FF
    INC A
    STA.B SpriteYSpeed,X
    LDA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.B SpriteXSpeed,X
  + JSR CODE_02C126
    JSR UpdateXPosNoGrvty
    JSR UpdateYPosNoGrvty
    JSL CODE_019138
    PLA
    STA.B SpriteYSpeed,X
    PLA
    STA.B SpriteXSpeed,X
    INC.W SpriteMisc1570,X
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
  + LDA.W SpriteBlockedDirs,X
    AND.B #$0C
    BEQ +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.W SpriteInLiquid,X
    BNE +
    LDA.B #$10
    STA.B SpriteYSpeed,X
  + LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02C02E
    dw CODE_02C08A

CODE_02C02E:
    LDA.B #$02
    STA.B SpriteYSpeed,X
    LDA.B TrueFrame
    AND.B #$03
    BNE CODE_02C044
    LDA.B SpriteXSpeed,X
    BEQ CODE_02C044
    BPL CODE_02C042
    INC.B SpriteXSpeed,X
    BRA CODE_02C044

CODE_02C042:
    DEC.B SpriteXSpeed,X
CODE_02C044:
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.B SpriteYPosLow,X
    AND.B #$F0
    STA.B SpriteYPosLow,X
  + JSL CODE_02C0D9
    LDA.W ChuckIsWhistling
    BNE CODE_02C072
    JSR CODE_02D4FA
    LDA.B _F
    ADC.B #$30
    CMP.B #$60
    BCS CODE_02C07B
    JSR CODE_02D50C
    LDA.B _E
    ADC.B #$30
    CMP.B #$60
    BCS CODE_02C07B
CODE_02C072:
    INC.B SpriteTableC2,X
    LDA.B #$FF
    STA.W SpriteMisc151C,X
    BRA CODE_02C08A

CODE_02C07B:
    LDY.B #$02
    LDA.W SpriteMisc1570,X
    AND.B #$30
    BNE +
    INY
  + TYA
    STA.W SpriteMisc1602,X
    RTL

CODE_02C08A:
    LDA.B TrueFrame
    AND.B #$01
    BNE CODE_02C095
    DEC.W SpriteMisc151C,X
    BEQ CODE_02C0CA
CODE_02C095:
    LDA.B TrueFrame
    AND.B #$07
    BNE CODE_02C0BB
    JSR CODE_02D4FA
    LDA.B SpriteXSpeed,X
    CMP.W DATA_02BFC8,Y
    BEQ +
    CLC
    ADC.W DATA_02BFCA,Y
    STA.B SpriteXSpeed,X
  + JSR CODE_02D50C
    LDA.B SpriteYSpeed,X
    CMP.W DATA_02BFC8,Y
    BEQ CODE_02C0BB
    CLC
    ADC.W DATA_02BFCA,Y
    STA.B SpriteYSpeed,X
CODE_02C0BB:
    LDY.B #$00
    LDA.W SpriteMisc1570,X
    AND.B #$04
    BEQ +
    INY
  + TYA
    STA.W SpriteMisc1602,X
    RTL

CODE_02C0CA:
    STZ.B SpriteTableC2,X
    JMP CODE_02C02E

ADDR_02C0CF:
    LDA.B #$08                                ; \ Unreachable
    LDY.W SpriteMisc157C,X                    ; | A = #$08 or #$09 depending on sprite direction
    BEQ +                                     ; |
    INC A                                     ; /
  + BRA +

CODE_02C0D9:
    LDA.B #$06
  + TAY
    LDA.W SpriteOffscreenX,X                  ; \ Return if sprite is offscreen
    ORA.W SpriteOffscreenVert,X               ; |
    BNE Return02C125                          ; /
    TYA
    DEC.W SpriteMisc1528,X
    BPL Return02C125
    PHA
    LDA.B #$28
    STA.W SpriteMisc1528,X
    LDY.B #$0B
CODE_02C0F2:
    LDA.W MinExtSpriteNumber,Y
    BEQ CODE_02C107
    DEY
    BPL CODE_02C0F2
    DEC.W MinExtSpriteSlotIdx
    BPL +
    LDA.B #$0B
    STA.W MinExtSpriteSlotIdx
  + LDY.W MinExtSpriteSlotIdx
CODE_02C107:
    PLA
    STA.W MinExtSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$06
    STA.W MinExtSpriteXPosLow,Y
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$00
    STA.W MinExtSpriteYPosLow,Y
    LDA.B #$7F
    STA.W MinExtSpriteTimer,Y
    LDA.B #$FA
    STA.W MinExtSpriteXSpeed,Y
Return02C125:
    RTL

CODE_02C126:
    LDY.B #$00
    LDA.B SpriteXSpeed,X
    BPL +
    INY
  + TYA
    STA.W SpriteMisc157C,X
    RTS


DATA_02C132:
    db $30,$20,$0A,$30

DATA_02C136:
    db $05,$0E,$0F,$10

CODE_02C13A:
    LDA.W SpriteMisc1558,X
    BEQ CODE_02C156
    CMP.B #$01
    BNE +
    LDA.B #$30
    STA.W SpriteMisc1540,X
    LDA.B #$04
    STA.W SpriteMisc1534,X
    STZ.W SpriteMisc1570,X
  + LDA.B #$02
    STA.W SpriteMisc151C,X
    RTS

CODE_02C156:
    LDA.W SpriteMisc1540,X
    BNE CODE_02C181
    INC.W SpriteMisc1534,X
    LDA.W SpriteMisc1534,X
    AND.B #$03
    STA.W SpriteMisc1570,X
    TAY
    LDA.W DATA_02C132,Y
    STA.W SpriteMisc1540,X
    CPY.B #$01
    BNE CODE_02C181
    LDA.W SpriteMisc1534,X
    AND.B #$0C
    BNE +
    LDA.B #$40
    STA.W SpriteMisc1558,X
    RTS

  + JSR CODE_02C19A
CODE_02C181:
    LDY.W SpriteMisc1570,X
    LDA.W DATA_02C136,Y
    STA.W SpriteMisc1602,X
    LDY.W SpriteMisc157C,X
    LDA.W DATA_02C1F3,Y
    STA.W SpriteMisc151C,X
    RTS


DATA_02C194:
    db $14,$EC

DATA_02C196:
    db $00,$FF

DATA_02C198:
    db $08,$F8

CODE_02C19A:
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BMI +                                     ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$48
    STA.W SpriteNumber,Y
    LDA.W SpriteMisc157C,X
    STA.B _2
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    PHX
    TYX
    JSL InitSpriteTables
    LDX.B _2
    LDA.B _0
    CLC
    ADC.W DATA_02C194,X
    STA.W SpriteXPosLow,Y
    LDA.B _1
    ADC.W DATA_02C196,X
    STA.W SpriteXPosHigh,Y
    LDA.W DATA_02C198,X
    STA.W SpriteXSpeed,Y
    PLX
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$0A
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    LDA.B #$C0
    STA.W SpriteYSpeed,Y
    LDA.B #$2C
    STA.W SpriteMisc1540,Y
  + RTS


DATA_02C1F3:
    db $01,$03

ChucksMain:
    PHB
    PHK
    PLB
    LDA.W SpriteMisc187B,X
    PHA
    JSR CODE_02C22C
    PLA
    BNE +
    CMP.W SpriteMisc187B,X
    BEQ +
    LDA.W SpriteMisc163E,X
    BNE +
    LDA.B #$28
    STA.W SpriteMisc163E,X
  + PLB
    RTL


DATA_02C213:
    db $01,$02,$03,$02

  - LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W DATA_02C213,Y
    STA.W SpriteMisc151C,X
    JSR CODE_02C81A
    RTS


DATA_02C228:
    db $40,$10

DATA_02C22A:
    db $03,$01

CODE_02C22C:
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE -
    LDA.W SpriteMisc15AC,X
    BEQ +
    LDA.B #$05
    STA.W SpriteMisc1602,X
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if on ground
    AND.B #$04                                ; |
    BNE +                                     ; /
    LDA.B SpriteYSpeed,X
    BPL +
    LDA.B SpriteTableC2,X
    CMP.B #$05
    BCS +
    LDA.B #$06
    STA.W SpriteMisc1602,X
  + JSR CODE_02C81A
    LDA.B SpriteLock
    BEQ +
    RTS

  + JSR SubOffscreen0Bnk2
    JSR CODE_02C79D
    JSL SprSprInteract
    JSL CODE_019138
    LDA.W SpriteBlockedDirs,X
    AND.B #$08
    BEQ +
    LDA.B #$10
    STA.B SpriteYSpeed,X
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ CODE_02C2F4                           ; /
    LDA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    BNE CODE_02C2E4
    LDA.W SpriteMisc187B,X
    BEQ CODE_02C2E4
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.B #$14
    CMP.B #$1C
    BCC CODE_02C2E4
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if on ground
    AND.B #$40                                ; |
    BNE CODE_02C2E4                           ; /
    LDA.W Map16TileDestroy
    CMP.B #$2E
    BEQ CODE_02C2A6
    CMP.B #$1E
    BNE CODE_02C2E4
CODE_02C2A6:
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ CODE_02C2F7                           ; /
    LDA.B TouchBlockXPos+1
    PHA
    LDA.B TouchBlockXPos
    PHA
    LDA.B TouchBlockYPos+1
    PHA
    LDA.B TouchBlockYPos
    PHA
    JSL ShatterBlock
    LDA.B #$02                                ; \ Block to generate = #$02
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile
    PLA
    SEC
    SBC.B #$10
    STA.B TouchBlockYPos
    PLA
    SBC.B #$00
    STA.B TouchBlockYPos+1
    PLA
    STA.B TouchBlockXPos
    PLA
    STA.B TouchBlockXPos+1
    JSL ShatterBlock
    LDA.B #$02                                ; \ Block to generate = #$02
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile
    BRA CODE_02C2F4

CODE_02C2E4:
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ CODE_02C2F7                           ; /
    LDA.B #$C0
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty
    BRA +

CODE_02C2F4:
    JSR UpdateXPosNoGrvty
CODE_02C2F7:
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    JSR CODE_02C579
  + JSR UpdateYPosNoGrvty
    LDY.W SpriteInLiquid,X
    CPY.B #$01
    LDY.B #$00
    LDA.B SpriteYSpeed,X
    BCC +
    INY
    CMP.B #$00
    BPL +
    CMP.B #$E0
    BCS +
    LDA.B #$E0
  + CLC
    ADC.W DATA_02C22A,Y
    BMI +
    CMP.W DATA_02C228,Y
    BCC +
    LDA.W DATA_02C228,Y
  + TAY
    BMI +
    LDY.B SpriteTableC2,X
    CPY.B #$07
    BNE +
    CLC
    ADC.B #$03
  + STA.B SpriteYSpeed,X
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02C63B
    dw CODE_02C6A7
    dw CODE_02C726
    dw CODE_02C74A
    dw CODE_02C13A
    dw CODE_02C582
    dw CODE_02C53C
    dw CODE_02C564
    dw CODE_02C4E3
    dw CODE_02C4BD
    dw CODE_02C3CB
    dw CODE_02C356
    dw CODE_02C37B

CODE_02C356:
    LDA.B #$03
    STA.W SpriteMisc1602,X
    LDA.W SpriteInLiquid,X
    BEQ +
    JSR CODE_02D4FA
    LDA.B _F
    CLC
    ADC.B #$30
    CMP.B #$60
    BCS +
    LDA.B #$0C
    STA.B SpriteTableC2,X
  + JMP CODE_02C556


DATA_02C373:
    db $05,$05,$05,$02,$02,$06,$06,$06

CODE_02C37B:
    LDA.B EffFrame
    AND.B #$3F
    BNE +
    LDA.B #!SFX_WHISTLE                       ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + LDY.B #$03
    LDA.B EffFrame
    AND.B #$30
    BEQ +
    LDY.B #$06
  + TYA
    STA.W SpriteMisc1602,X
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$07
    TAY
    LDA.W DATA_02C373,Y
    STA.W SpriteMisc151C,X
    LDA.B SpriteXPosLow,X
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    LDA.B #$09
    BCC +
    STA.W CurrentGenerator
  + STA.W ChuckIsWhistling
    RTS


DATA_02C3B3:
    db $7F,$BF,$FF,$DF

DATA_02C3B7:
    db $18,$19,$14,$14

DATA_02C3BB:
    db $18,$18,$18,$18,$17,$17,$17,$17
    db $17,$17,$16,$15,$15,$16,$16,$16

CODE_02C3CB:
    LDA.W SpriteMisc1534,X
    BNE CODE_02C43A
    JSR CODE_02D50C
    LDA.B _E
    BPL +
    CMP.B #$D0
    BCS +
    LDA.B #$C8
    STA.B SpriteYSpeed,X
    LDA.B #$3E
    STA.W SpriteMisc1540,X
    INC.W SpriteMisc1534,X
  + LDA.B TrueFrame
    AND.B #$07
    BNE +
    LDA.W SpriteMisc1540,X
    BEQ +
    INC.W SpriteMisc1540,X
  + LDA.B EffFrame
    AND.B #$3F
    BNE +
    JSR CODE_02C556
  + LDA.W SpriteMisc1540,X
    BNE +
    LDY.W SpriteMisc187B,X
    LDA.W DATA_02C3B3,Y
    STA.W SpriteMisc1540,X
  + LDA.W SpriteMisc1540,X
    CMP.B #$40
    BCS +
    LDA.B #$00
    STA.W SpriteMisc1602,X
    RTS

  + SEC
    SBC.B #$40
    LSR A
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W DATA_02C3B7,Y
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    AND.B #$1F
    CMP.B #$06
    BNE Return02C439
    JSR CODE_02C466
    LDA.B #$08
    STA.W SpriteMisc1558,X
Return02C439:
    RTS

CODE_02C43A:
    LDA.W SpriteMisc1540,X
    BEQ CODE_02C45C
    PHA
    CMP.B #$20
    BCC +
    CMP.B #$30
    BCS +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LSR A
    LSR A
    TAY
    LDA.W DATA_02C3BB,Y
    STA.W SpriteMisc1602,X
    PLA
    CMP.B #$26
    BNE +
    JSR CODE_02C466
  + RTS

CODE_02C45C:
    STZ.W SpriteMisc1534,X
    RTS


BaseballTileDispX:
    db $10,$F8

DATA_02C462:
    db $00,$FF

BaseballSpeed:
    db $18,$E8

CODE_02C466:
    LDA.W SpriteMisc1558,X
    ORA.W SpriteOffscreenVert,X
    BNE Return02C439
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_02C470:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_02C479                           ; |
    DEY                                       ; |
    BPL CODE_02C470                           ; |
    RTS                                       ; / Return if no free slots

CODE_02C479:
    LDA.B #$0D                                ; \ Extended sprite = Baseball
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$00
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W ExtSpriteYPosHigh,Y
    PHX
    LDA.W SpriteMisc157C,X
    TAX
    LDA.B _0
    CLC
    ADC.W BaseballTileDispX,X
    STA.W ExtSpriteXPosLow,Y
    LDA.B _1
    ADC.W DATA_02C462,X
    STA.W ExtSpriteXPosHigh,Y
    LDA.W BaseballSpeed,X
    STA.W ExtSpriteXSpeed,Y
    PLX
    RTS


DATA_02C4B5:
    db $00,$00,$11,$11,$11,$11,$00,$00

CODE_02C4BD:
    STZ.W SpriteMisc1602,X
    TXA
    ASL A
    ASL A
    ASL A
    ADC.B TrueFrame
    AND.B #$7F
    CMP.B #$00
    BNE +
    PHA
    JSR CODE_02C556
    JSL CODE_03CBB3
    PLA
  + CMP.B #$20
    BCS +
    LSR A
    LSR A
    TAY
    LDA.W DATA_02C4B5,Y
    STA.W SpriteMisc1602,X
  + RTS

CODE_02C4E3:
    JSR CODE_02C556
    LDA.B #$06
    LDY.B SpriteYSpeed,X
    CPY.B #$F0
    BMI CODE_02C504
    LDY.W SpriteMisc160E,X
    BEQ CODE_02C504
    LDA.W SpriteMisc1FE2,X
    BNE +
    LDA.B #!SFX_CLAP                          ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$20
    STA.W SpriteMisc1FE2,X
  + LDA.B #$07
CODE_02C504:
    STA.W SpriteMisc1602,X
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    STZ.W SpriteMisc160E,X
    LDA.B #$04
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B #$20
    STA.W SpriteMisc1540,X
    LDA.B #$F0
    STA.B SpriteYSpeed,X
    JSR CODE_02D50C
    LDA.B _E
    BPL +
    CMP.B #$D0
    BCS +
    LDA.B #$C0
    STA.B SpriteYSpeed,X
    INC.W SpriteMisc160E,X
CODE_02C536:
    LDA.B #!SFX_SPRING                        ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + RTS

CODE_02C53C:
    LDA.B #$06
    STA.W SpriteMisc1602,X
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    JSR CODE_02C579
    JSR CODE_02C556
    LDA.B #$08
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + RTS

CODE_02C556:
    JSR CODE_02D4FA
    TYA
    STA.W SpriteMisc157C,X
    LDA.W DATA_02C639,Y
    STA.W SpriteMisc151C,X
    RTS

CODE_02C564:
    LDA.B #$03
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    BNE CODE_02C579
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    LDA.B #$05
    STA.B SpriteTableC2,X
CODE_02C579:
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + RTS


DATA_02C57E:
    db $10,$F0

DATA_02C580:
    db $20,$E0

CODE_02C582:
    JSR CODE_02C556
    LDA.W SpriteMisc1540,X
    BEQ CODE_02C602
    CMP.B #$01
    BNE CODE_02C5FC
    LDA.B SpriteNumber,X
    CMP.B #$93
    BNE +
    JSR CODE_02D4FA
    LDA.W DATA_02C580,Y
    STA.B SpriteXSpeed,X
    LDA.B #$B0
    STA.B SpriteYSpeed,X
    LDA.B #$06
    STA.B SpriteTableC2,X
    JMP CODE_02C536

  + STZ.B SpriteTableC2,X
    LDA.B #$50
    STA.W SpriteMisc1540,X
    LDA.B #!SFX_MAGIC                         ; \ Play sound effect
    STA.W SPCIO0                              ; /
    STZ.W TileGenerateTrackA
    JSR CODE_02C5BC
    INC.W TileGenerateTrackA
CODE_02C5BC:
    JSL FindFreeSprSlot
    BMI CODE_02C5FC
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$91
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    LDX.W TileGenerateTrackA
    LDA.W DATA_02C57E,X
    STA.W SpriteXSpeed,Y
    PLX
    LDA.B #$C8
    STA.W SpriteYSpeed,Y
    LDA.B #$50
    STA.W SpriteMisc1540,Y
CODE_02C5FC:
    LDA.B #$09
    STA.W SpriteMisc1602,X
    RTS

CODE_02C602:
    JSR CODE_02D4FA
    TYA
    STA.W SpriteMisc157C,X
    LDA.B _F
    CLC
    ADC.B #$50
    CMP.B #$A0
    BCS +
    LDA.B #$40
    STA.W SpriteMisc1540,X
    RTS

  + LDA.B #$03
    STA.W SpriteMisc1602,X
    LDA.B TrueFrame
    AND.B #$3F
    BNE +
    LDA.B #$E0
    STA.B SpriteYSpeed,X
  + RTS

CODE_02C628:
    LDA.B #$08
    STA.W SpriteMisc15AC,X
    RTS


DATA_02C62E:
    db $00,$00,$00,$00,$01,$02,$03,$04
    db $04,$04,$04

DATA_02C639:
    db $00,$04

CODE_02C63B:
    LDA.B #$03
    STA.W SpriteMisc1602,X
    STZ.W SpriteMisc187B,X
    LDA.W SpriteMisc1540,X
    AND.B #$0F
    BNE +
    JSR CODE_02D50C
    LDA.B _E
    CLC
    ADC.B #$28
    CMP.B #$50
    BCS +
    JSR CODE_02C556
    INC.W SpriteMisc187B,X
CODE_02C65C:
    LDA.B #$02
    STA.B SpriteTableC2,X
    LDA.B #$18
    STA.W SpriteMisc1540,X
    RTS


DATA_02C666:
    db $01,$FF

  + LDA.W SpriteMisc1540,X
    BNE CODE_02C677
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
    BRA CODE_02C65C

CODE_02C677:
    LDA.B EffFrame
    AND.B #$03
    BNE CODE_02C691
    LDA.W SpriteMisc1534,X
    AND.B #$01
    TAY
    LDA.W SpriteMisc1594,X
    CLC
    ADC.W DATA_02C666,Y
    CMP.B #$0B
    BCS +
    STA.W SpriteMisc1594,X
CODE_02C691:
    LDY.W SpriteMisc1594,X
    LDA.W DATA_02C62E,Y
    STA.W SpriteMisc151C,X
    RTS

  + INC.W SpriteMisc1534,X
    RTS


DATA_02C69F:
    db $10,$F0,$18,$E8

DATA_02C6A3:
    db $12,$13,$12,$13

CODE_02C6A7:
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    LDA.W SpriteMisc163E,X
    CMP.B #$01
    BRA +

    LDA.B #!SFX_NOTICEMESENPAI                ; \ Unreachable
    STA.W SPCIO0                              ; / Play sound effect
  + JSR CODE_02D50C
    LDA.B _E
    CLC
    ADC.B #$30
    CMP.B #$60
    BCS +
    JSR CODE_02D4FA
    TYA
    CMP.W SpriteMisc157C,X
    BNE +
    LDA.B #$20
    STA.W SpriteMisc1540,X
    STA.W SpriteMisc187B,X
  + LDA.W SpriteMisc1540,X
    BNE +
    STZ.B SpriteTableC2,X
    JSR CODE_02C628
    JSL GetRand
    AND.B #$3F
    ORA.B #$40
    STA.W SpriteMisc1540,X
  + LDY.W SpriteMisc157C,X
    LDA.W DATA_02C639,Y
    STA.W SpriteMisc151C,X
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ CODE_02C713                           ; /
    LDA.W SpriteMisc187B,X
    BEQ CODE_02C70E
    LDA.B EffFrame
    AND.B #$07
    BNE +
    LDA.B #!SFX_BONK                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
  + INY
    INY
CODE_02C70E:
    LDA.W DATA_02C69F,Y
    STA.B SpriteXSpeed,X
CODE_02C713:
    LDA.B TrueFrame
    LDY.W SpriteMisc187B,X
    BNE +
    LSR A
  + LSR A
    AND.B #$03
    TAY
    LDA.W DATA_02C6A3,Y
    STA.W SpriteMisc1602,X
    RTS

CODE_02C726:
    LDA.B #$03
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    BNE +
    JSR CODE_02C628
    LDA.B #$01
    STA.B SpriteTableC2,X
    LDA.B #$40
    STA.W SpriteMisc1540,X
  + RTS


DATA_02C73D:
    db $0A,$0B,$0A,$0C,$0D,$0C

DATA_02C743:
    db $0C,$10,$10,$04,$08,$10,$18

CODE_02C74A:
    LDY.W SpriteMisc1570,X
    LDA.W SpriteMisc1540,X
    BNE CODE_02C760
    INC.W SpriteMisc1570,X
    INY
    CPY.B #$07
    BEQ CODE_02C777
    LDA.W DATA_02C743,Y
    STA.W SpriteMisc1540,X
CODE_02C760:
    LDA.W DATA_02C73D,Y
    STA.W SpriteMisc1602,X
    LDA.B #$02
    CPY.B #$05
    BNE +
    LDA.B EffFrame
    LSR A
    NOP
    AND.B #$02
    INC A
  + STA.W SpriteMisc151C,X
    RTS

CODE_02C777:
    LDA.B SpriteNumber,X
    CMP.B #$94
    BEQ CODE_02C794
    CMP.B #$46
    BNE +
    LDA.B #$91
    STA.B SpriteNumber,X
  + LDA.B #$30
    STA.W SpriteMisc1540,X
    LDA.B #$02
    STA.B SpriteTableC2,X
    INC.W SpriteMisc187B,X
    JMP CODE_02C556

CODE_02C794:
    LDA.B #$0C
    STA.B SpriteTableC2,X
    RTS


    db $F0,$10

DATA_02C79B:
    db $20,$E0

CODE_02C79D:
    LDA.W SpriteMisc1564,X
    BNE Return02C80F
    JSL MarioSprInteract
    BCC Return02C80F
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario doesn't have star
    BEQ +                                     ; /
    LDA.B #$D0
    STA.B SpriteYSpeed,X
CODE_02C7B1:
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,X                      ; /
    LDA.B #!SFX_KICK                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.B #$03
    JSL GivePoints
    RTS

  + JSR CODE_02D50C
    LDA.B _E
    CMP.B #$EC
    BPL CODE_02C810
    LDA.B #$05
    STA.W SpriteMisc1564,X
    LDA.B #!SFX_SPLAT                         ; \ Play sound effect
    STA.W SPCIO0                              ; /
    JSL DisplayContactGfx
    JSL BoostMarioSpeed
    STZ.W SpriteMisc163E,X
    LDA.B SpriteTableC2,X
    CMP.B #$03
    BEQ Return02C80F
    INC.W SpriteMisc1528,X                    ; Increase Chuck stomp count
    LDA.W SpriteMisc1528,X                    ; \ Kill Chuck if stomp count >= 3
    CMP.B #$03                                ; |
    BCC CODE_02C7F6                           ; |
    STZ.B SpriteYSpeed,X                      ; | Sprite Y Speed = 0
    BRA CODE_02C7B1                           ; /

CODE_02C7F6:
    LDA.B #!SFX_ENEMYHURT                     ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$03
    STA.B SpriteTableC2,X
    LDA.B #$03
    STA.W SpriteMisc1540,X
    STZ.W SpriteMisc1570,X
    JSR CODE_02D4FA
    LDA.W DATA_02C79B,Y
    STA.B PlayerXSpeed+1
Return02C80F:
    RTS

CODE_02C810:
    LDA.W PlayerRidingYoshi
    BNE +
    JSL HurtMario
  + RTS

CODE_02C81A:
    JSR GetDrawInfo2
    JSR CODE_02C88C
    JSR CODE_02CA27
    JSR CODE_02CA9D
    JSR CODE_02CBA1
    LDY.B #$FF
CODE_02C82B:
    LDA.B #$04
    JMP CODE_02B7A7


DATA_02C830:
    db $F8,$F8,$F8,$00,$00,$FE,$00,$00
    db $FA,$00,$00,$00,$00,$00,$00,$FD
    db $FD,$F9,$F6,$F6,$F8,$FE,$FC,$FA
    db $F8,$FA

DATA_02C84A:
    db $F8,$F9,$F7,$F8,$FC,$F8,$F4,$F5
    db $F5,$FC,$FD,$00,$F9,$F5,$F8,$FA
    db $F6,$F6,$F4,$F4,$F8,$F6,$F6,$F8
    db $F8,$F5

DATA_02C864:
    db $08,$08,$08,$00,$00,$00,$08,$08
    db $08,$00,$08,$08,$00,$00,$00,$00
    db $00,$08,$10,$10,$0C,$0C,$0C,$0C
    db $0C,$0C

ChuckHeadTiles:
    db $06,$0A,$0E,$0A,$06,$4B,$4B

DATA_02C885:
    db $40,$40,$00,$00,$00,$00,$40

CODE_02C88C:
    STZ.B _7
    LDY.W SpriteMisc1602,X
    STY.B _4
    CPY.B #$09
    CLC
    BNE +
    LDA.W SpriteMisc1540,X
    SEC
    SBC.B #$20
    BCC +
    PHA
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _7
    PLA
    LSR A
    LSR A
  + LDA.B _0
    ADC.B #$00
    STA.B _0
    LDA.W SpriteMisc151C,X
    STA.B _2
    LDA.W SpriteMisc157C,X
    STA.B _3
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties
    STA.B _8
    LDA.W SpriteOAMIndex,X
    STA.B _5
    CLC
    ADC.W DATA_02C864,Y
    TAY
    LDX.B _4
    %LorW_X(LDA,DATA_02C830)
    LDX.B _3
    BNE +
    EOR.B #$FF
    INC A
  + CLC
    ADC.B _0
    STA.W OAMTileXPos+$100,Y
    LDX.B _4
    LDA.B _1
    CLC
    %LorW_X(ADC,DATA_02C84A)
    SEC
    SBC.B _7
    STA.W OAMTileYPos+$100,Y
    LDX.B _2
    %LorW_X(LDA,DATA_02C885)
    ORA.B _8
    STA.W OAMTileAttr+$100,Y
    %LorW_X(LDA,ChuckHeadTiles)
    STA.W OAMTileNo+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS


DATA_02C909:
    db $F8,$F8,$F8,$FC,$FC,$FC,$FC,$F8
    db $01,$FC,$FC,$FC,$FC,$FC,$FC,$FC
    db $FC,$F8,$F8,$F8,$F8,$08,$06,$F8
    db $F8,$01,$10,$10,$10,$04,$04,$04
    db $04,$08,$07,$04,$04,$04,$04,$04
    db $04,$04,$04,$10,$08,$08,$10,$00
    db $02,$10,$10,$07

DATA_02C93D:
    db $00,$00,$00,$04,$04,$04,$04,$08
    db $00,$04,$04,$04,$04,$04,$04,$04
    db $04,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$FC,$FC,$FC
    db $FC,$F8,$00,$FC,$FC,$FC,$FC,$FC
    db $FC,$FC,$FC,$00,$00,$00,$00,$00
    db $00,$00,$00,$00

DATA_02C971:
    db $06,$06,$06,$00,$00,$00,$00,$00
    db $F8,$00,$00,$00,$00,$00,$00,$00
    db $00,$03,$00,$00,$06,$F8,$F8,$00
    db $00,$F8

ChuckBody1:
    db $0D,$34,$35,$26,$2D,$28,$40,$42
    db $5D,$2D,$64,$64,$64,$64,$E7,$28
    db $82,$CB,$23,$20,$0D,$0C,$5D,$BD
    db $BD,$5D

ChuckBody2:
    db $4E,$0C,$22,$26,$2D,$29,$40,$42
    db $AE,$2D,$64,$64,$64,$64,$E8,$29
    db $83,$CC,$24,$21,$4E,$A0,$A0,$A2
    db $A4,$AE

DATA_02C9BF:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$40,$00,$00
    db $00,$00

DATA_02C9D9:
    db $00,$00,$00,$40,$40,$00,$40,$40
    db $00,$40,$40,$40,$40,$40,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00

DATA_02C9F3:
    db $00,$00,$00,$02,$02,$02,$02,$02
    db $00,$02,$02,$02,$02,$02,$02,$02
    db $02,$00,$02,$02,$00,$00,$00,$00
    db $00,$00

DATA_02CA0D:
    db $00,$00,$00,$04,$04,$04,$0C,$0C
    db $00,$08,$00,$00,$04,$04,$04,$04
    db $04,$00,$08,$08,$00,$00,$00,$00
    db $00,$00

CODE_02CA27:
    STZ.B _6
    LDA.B _4
    LDY.B _3
    BNE +
    CLC
    ADC.B #$1A
    LDX.B #$40
    STX.B _6
  + TAX
    LDY.B _4
    LDA.W DATA_02CA0D,Y
    CLC
    ADC.B _5
    TAY
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02C909)
    STA.W OAMTileXPos+$100,Y
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02C93D)
    STA.W OAMTileXPos+$104,Y
    LDX.B _4
    LDA.B _1
    CLC
    %LorW_X(ADC,DATA_02C971)
    STA.W OAMTileYPos+$100,Y
    LDA.B _1
    STA.W OAMTileYPos+$104,Y
    %LorW_X(LDA,ChuckBody1)
    STA.W OAMTileNo+$100,Y
    %LorW_X(LDA,ChuckBody2)
    STA.W OAMTileNo+$104,Y
    LDA.B _8
    ORA.B _6
    PHA
    %LorW_X(EOR,DATA_02C9BF)
    STA.W OAMTileAttr+$100,Y
    PLA
    %LorW_X(EOR,DATA_02C9D9)
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY
    %LorW_X(LDA,DATA_02C9F3)
    STA.W OAMTileSize+$40,Y
    LDA.B #$02
    STA.W OAMTileSize+$41,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS


DATA_02CA93:
    db $FA,$00

DATA_02CA95:
    db $0E,$00

ClappinChuckTiles:
    db $0C,$44

DATA_02CA99:
    db $F8,$F0

DATA_02CA9B:
    db $00,$02

CODE_02CA9D:
    LDA.B _4
    CMP.B #$14
    BCC +
    JMP CODE_02CB53

  + CMP.B #$12
    BEQ CODE_02CAFC
    CMP.B #$13
    BEQ CODE_02CAFC
    SEC
    SBC.B #$06
    CMP.B #$02
    BCS +
    TAX
    LDY.B _5
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02CA93)
    STA.W OAMTileXPos+$100,Y
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02CA95)
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    CLC
    %LorW_X(ADC,DATA_02CA99)
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    %LorW_X(LDA,ClappinChuckTiles)
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$104,Y
    LDA.B _8
    STA.W OAMTileAttr+$100,Y
    ORA.B #$40
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY
    %LorW_X(LDA,DATA_02CA9B)
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
  + RTS


ChuckGfxProp:
    db $47,$07

CODE_02CAFC:
    LDY.B _5
    LDA.W SpriteMisc157C,X
    PHX
    TAX
    ASL A
    ASL A
    ASL A
    PHA
    EOR.B #$08
    CLC
    ADC.B _0
    STA.W OAMTileXPos+$100,Y
    PLA
    CLC
    ADC.B _0
    STA.W OAMTileXPos+$104,Y
    LDA.B #$1C
    STA.W OAMTileNo+$100,Y
    INC A
    STA.W OAMTileNo+$104,Y
    LDA.B _1
    SEC
    SBC.B #$08
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    LDA.W ChuckGfxProp,X
CODE_02CB2D:
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAX
CODE_02CB39:
    STZ.W OAMTileSize+$40,X
    STZ.W OAMTileSize+$41,X
    PLX
    RTS


    db $FA,$0A,$06,$00,$00,$01,$0E,$FE
    db $02,$00,$00,$09,$08,$F4,$F4,$00
    db $00,$F4

CODE_02CB53:
    PHX
    STA.B _2
    LDY.W SpriteMisc157C,X
    BNE +
    CLC
    ADC.B #$06
  + TAX
    LDA.B _5
    CLC
    ADC.B #$08
    TAY
    LDA.B _0
    CLC
    ADC.W CODE_02CB2D,X
    STA.W OAMTileXPos+$100,Y
    LDX.B _2
    LDA.W CODE_02CB39,X
    BEQ +
    CLC
    ADC.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.B #$AD
    STA.W OAMTileNo+$100,Y
    LDA.B #$09
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAX
    STZ.W OAMTileSize+$40,X
  + PLX
    RTS


DigChuckTileDispX:
    db $FC,$04,$10,$F0,$12,$EE

DigChuckTileProp:
    db $47,$07

DigChuckTileDispY:
    db $F8,$00,$F8

DigChuckTiles:
    db $CA,$E2,$A0

DigChuckTileSize:
    db $00,$02,$02

CODE_02CBA1:
    LDA.B SpriteNumber,X
    CMP.B #$46
    BNE Return02CBFB
    LDA.W SpriteMisc1602,X
    CMP.B #$05
    BNE CODE_02CBB2
    LDA.B #$01
    BRA CODE_02CBB9

CODE_02CBB2:
    CMP.B #$0E
    BCC Return02CBFB
    SEC
    SBC.B #$0E
CODE_02CBB9:
    STA.B _2
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$0C
    TAY
    PHX
    LDA.B _2
    ASL A
    ORA.W SpriteMisc157C,X
    TAX
    LDA.B _0
    CLC
    ADC.W DigChuckTileDispX,X
    STA.W OAMTileXPos+$100,Y
    TXA
    AND.B #$01
    TAX
    LDA.W DigChuckTileProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDX.B _2
    LDA.B _1
    CLC
    ADC.W DigChuckTileDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DigChuckTiles,X
    STA.W OAMTileNo+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.W DigChuckTileSize,X
    STA.W OAMTileSize+$40,Y
    PLX
Return02CBFB:
    RTS

    RTS

Return02CBFD:
    RTL

WingedCageMain:
    LDA.B SpriteLock                          ; \ If sprites not locked,
    BNE +                                     ; | increment sprite frame counter
    INC.W SpriteMisc1570,X                    ; /
  + JSR ADDR_02CCB9
    PHX
    JSL ADDR_00FF32
    PLX
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W Layer1DXPos
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B PlayerAnimation                     ; \ Return if Mario animation sequence active
    CMP.B #$01                                ; |
    BCS Return02CBFD                          ; /
    LDA.W StandingOnCage
    BEQ +
    JSL ADDR_00FF07
  + LDY.B #$00
    LDA.W Layer1DYPos
    BPL +
    DEY
  + CLC
    ADC.B SpriteYPosLow,X
    STA.B SpriteYPosLow,X
    TYA
    ADC.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,X
    LDA.B SpriteXPosLow,X                     ; \ $00 = Sprite X position
    STA.B _0                                  ; |
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B _1                                  ; /
    LDA.B SpriteYPosLow,X                     ; \ $02 = Sprite Y position
    STA.B _2                                  ; |
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B _3                                  ; /
    REP #$20                                  ; A->16
    LDA.B _0
    LDY.B PlayerXSpeed+1
    DEY
    BPL ADDR_02CC6C
    CLC
    ADC.W #$0000
    CMP.B PlayerXPosNext
    BCC +
    STA.B PlayerXPosNext
    LDY.B #$00                                ; \ Mario's X speed = 0
    STY.B PlayerXSpeed+1                      ; /
    BRA +

ADDR_02CC6C:
    CLC
    ADC.W #$0090
    CMP.B PlayerXPosNext
    BCS +
    LDA.B _0
    ADC.W #$0091
    STA.B PlayerXPosNext
    LDY.B #$00
    STY.B PlayerXSpeed+1
  + LDA.B _2
    LDY.B PlayerYSpeed+1
    BPL ADDR_02CC93
    CLC
    ADC.W #$0020
    CMP.B PlayerYPosNext
    BCC +
    LDY.B #$00
    STY.B PlayerYSpeed+1
    BRA +

ADDR_02CC93:
    CLC
    ADC.W #$0060
    CMP.B PlayerYPosNext
    BCS +
    LDA.B _2
    ADC.W #$0061
    STA.B PlayerYPosNext
    LDY.B #$00
    STY.B PlayerYSpeed+1
    LDY.B #$01
    STY.W StandOnSolidSprite
    STY.W StandingOnCage
  + SEP #$20                                  ; A->8
    RTL


CageWingTileDispX:
    db $00,$30,$60,$90

CageWingTileDispY:
    db $F8,$00,$F8,$00

ADDR_02CCB9:
    LDA.B #$03
    STA.B _8
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    STY.B _2
ADDR_02CCD0:
    LDY.B _2
    LDX.B _8
    LDA.B _0
    CLC
    %LorW_X(ADC,CageWingTileDispX)
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    CLC
    %LorW_X(ADC,CageWingTileDispY)
    STA.W OAMTileYPos+$100,Y
    CLC
    ADC.B #$08
    STA.W OAMTileYPos+$104,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.W SpriteMisc1570,X
    LSR A
    LSR A
    LSR A
    EOR.B _8
    LSR A
    LDA.B #$C6
    BCC +
    LDA.B #$81
  + STA.W OAMTileNo+$100,Y
    LDA.B #$D6
    BCC +
    LDA.B #$D7
  + STA.W OAMTileNo+$104,Y
    LDA.B #$70
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
    LDA.B _2
    CLC
    ADC.B #$08
    STA.B _2
    DEC.B _8
    BPL ADDR_02CCD0
    RTS

CODE_02CD2D:
    PHB                                       ; Wrapper
    PHK
    PLB
    JSR CODE_02CD59
    PLB
    RTL


DATA_02CD35:
    db $00,$08,$10,$18,$00,$08,$10,$18
DATA_02CD3D:
    db $00,$00,$00,$00,$08,$08,$08,$08
DATA_02CD45:
    db $00,$01,$01,$00,$10,$11,$11,$10
DATA_02CD4D:
    db $31,$31,$71,$71,$31,$31,$71,$71
DATA_02CD55:
    db $0A,$04,$06,$08

CODE_02CD59:
    LDA.W SpriteMisc1540,X
    CMP.B #$5E
    BNE +
    LDA.B #$1B                                ; \ Block to generate = #$1B
    STA.B Map16TileGenerate                   ; /
    LDA.B SpriteXPosLow,X
    STA.B TouchBlockXPos
    LDA.W SpriteXPosHigh,X
    STA.B TouchBlockXPos+1
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$10
    STA.B TouchBlockYPos
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.B TouchBlockYPos+1
    JSL GenerateTile
  + JSL InvisBlkMainRt
    JSR GetDrawInfo2
    PHX
    LDX.W BigSwitchPressTimer
    LDA.W DATA_02CD55,X
    STA.B _2
    LDX.B #$07
CODE_02CD91:
    LDA.B _0
    CLC
    ADC.W DATA_02CD35,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_02CD3D,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DATA_02CD45,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02CD4D,X
    CPX.B #$04
    BCS +
    ORA.B _2
  + STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_02CD91
    PLX
    LDY.B #$00
    LDA.B #$07
    JMP CODE_02B7A7

    RTS


    db $00,$07,$F9,$00,$01,$FF

PeaBouncerMain:
    JSR SubOffscreen0Bnk2
    JSR CODE_02CEE0
    LDA.B SpriteLock
    BNE Return02CDFE
    LDA.W SpriteMisc1534,X
    BEQ +
    DEC.W SpriteMisc1534,X
    BIT.B byetudlrHold
    BPL +
    STZ.W SpriteMisc1534,X
    LDY.W SpriteMisc151C,X
    LDA.W DATA_02CDFF,Y
    STA.B PlayerYSpeed+1
    LDA.B #!SFX_SPRING                        ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + LDA.W SpriteMisc1528,X
    JSL ExecutePtr

    dw Return02CDFE
    dw CODE_02CE0F
    dw CODE_02CE3A

Return02CDFE:
    RTL


DATA_02CDFF:
    db $B6,$B4,$B0,$A8,$A0,$98,$90,$88
DATA_02CE07:
    db $00,$00,$E8,$E0,$D0,$C8,$C0,$B8

CODE_02CE0F:
    LDA.W SpriteMisc1540,X
    BEQ CODE_02CE20
    DEC A
    BNE +
    INC.W SpriteMisc1528,X
    LDA.B #$01
    STA.W SpriteMisc157C,X
  + RTL

CODE_02CE20:
    LDA.B SpriteTableC2,X
    BMI CODE_02CE29
    CMP.W SpriteMisc151C,X
    BCS +
CODE_02CE29:
    CLC
    ADC.B #$01
    STA.B SpriteTableC2,X
    RTL

  + LDA.W SpriteMisc151C,X
    STA.B SpriteTableC2,X
    LDA.B #$08
    STA.W SpriteMisc1540,X
    RTL

CODE_02CE3A:
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    AND.B #$03
    BNE CODE_02CE49
    DEC.W SpriteMisc151C,X
    BEQ CODE_02CE86
CODE_02CE49:
    LDA.W SpriteMisc151C,X
    EOR.B #$FF
    INC A
    STA.B _0
    LDA.W SpriteMisc157C,X
    AND.B #$01
    BNE CODE_02CE70
    LDA.B SpriteTableC2,X
    CLC
    ADC.B #$04
    STA.B SpriteTableC2,X
    BMI Return02CE66
    CMP.W SpriteMisc151C,X
    BCS +
Return02CE66:
    RTL

  + LDA.W SpriteMisc151C,X
    STA.B SpriteTableC2,X
    INC.W SpriteMisc157C,X
    RTL

CODE_02CE70:
    LDA.B SpriteTableC2,X
    SEC
    SBC.B #$04
    STA.B SpriteTableC2,X
    BPL Return02CE7D
    CMP.B _0
    BCC +
Return02CE7D:
    RTL

  + LDA.B _0
    STA.B SpriteTableC2,X
    INC.W SpriteMisc157C,X
    RTL

CODE_02CE86:
    STZ.B SpriteTableC2,X
    STZ.W SpriteMisc1528,X
    RTL

    JSR CODE_02CEE0                           ; \ Unreachable
    RTL                                       ; / Wrapper for Pea Bouncer gfx routine


DATA_02CE90:
    db $00,$08,$10,$18,$20,$00,$08,$10
    db $18,$20,$00,$08,$10,$18,$20,$00
    db $08,$10,$18,$1F,$00,$08,$10,$17
    db $1E,$00,$08,$0F,$16,$1D,$00,$07
    db $0F,$16,$1C,$00,$07,$0E,$15,$1B
DATA_02CEB8:
    db $00,$00,$00,$00,$00,$00,$01,$01
    db $01,$02,$00,$00,$01,$02,$04,$00
    db $01,$02,$04,$06,$00,$01,$03,$06
    db $08,$00,$02,$04,$08,$0A,$00,$02
    db $05,$07,$0C,$00,$02,$05,$09,$0E

CODE_02CEE0:
    JSR GetDrawInfo2
    LDA.B #$04
    STA.B _2
    LDA.B SpriteNumber,X
    SEC
    SBC.B #$6B
    STA.B _5
    LDA.B SpriteTableC2,X
    STA.B _3
    BPL +
    EOR.B #$FF
    INC A
  + STA.B _4
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
CODE_02CEFC:
    LDA.B _4
    ASL A
    ASL A
    ADC.B _4
    ADC.B _2
    TAX
    LDA.B _5
    LSR A
    %LorW_X(LDA,DATA_02CE90)
    BCC +
    EOR.B #$FF
    INC A
  + STA.B _8
    CLC
    ADC.B _0
    STA.W OAMTileXPos+$100,Y
    LDA.B _3
    ASL A
    %LorW_X(LDA,DATA_02CEB8)
    BCC +
    EOR.B #$FF
    INC A
  + STA.B _9
    CLC
    ADC.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.B #$3D
    STA.W OAMTileNo+$100,Y
    LDA.B SpriteProperties
    ORA.B #$0A
    STA.W OAMTileAttr+$100,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    PHY
    JSR CODE_02CF52
    PLY
    INY
    INY
    INY
    INY
    DEC.B _2
    BMI +
    JMP CODE_02CEFC

  + LDY.B #$00
    LDA.B #$04
    JMP CODE_02B7A7

  - RTS

CODE_02CF52:
    LDA.B PlayerAnimation
    CMP.B #$01
    BCS -
    LDA.B PlayerYPosScrRel+1
    ORA.B PlayerXPosScrRel+1
    ORA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    BNE -
    LDA.B PlayerXPosScrRel
    CLC
    ADC.B #$02
    STA.B _A
    LDA.W PlayerRidingYoshi
    CMP.B #$01
    LDA.B #$10
    BCC +
    LDA.B #$20
  + CLC
    ADC.B PlayerYPosScrRel
    STA.B _B
    LDA.W OAMTileXPos+$100,Y
    SEC
    SBC.B _A
    CLC
    ADC.B #$08
    CMP.B #$14
    BCS Return02CFFD
    LDA.B Powerup
    CMP.B #$01
    LDA.B #$1A
    BCS +
    LDA.B #$1C
  + STA.B _F
    LDA.W OAMTileYPos+$100,Y
    SEC
    SBC.B _B
    CLC
    ADC.B #$08
    CMP.B _F
    BCS Return02CFFD
    LDA.B PlayerYSpeed+1
    BMI Return02CFFD
    LDA.B #$1F
    PHX
    LDX.W PlayerRidingYoshi
    BEQ +
    LDA.B #$2F
  + STA.B _F
    PLX
    LDA.W OAMTileYPos+$100,Y
    SEC
    SBC.B _F
    PHP
    CLC
    ADC.B Layer1YPos
    STA.B PlayerYPosNext
    LDA.B Layer1YPos+1
    ADC.B #$00
    PLP
    SBC.B #$00
    STA.B PlayerYPosNext+1
    STZ.B PlayerInAir
    LDA.B #$02
    STA.W StandOnSolidSprite
    LDA.W SpriteMisc1528,X
    BEQ CODE_02CFEB
    CMP.B #$02
    BEQ CODE_02CFEB
    LDA.W SpriteMisc1540,X
    CMP.B #$01
    BNE +
    LDA.B #$08
    STA.W SpriteMisc1534,X
    LDY.B SpriteTableC2,X
    LDA.W DATA_02CE07,Y
    STA.B PlayerYSpeed+1
  + RTS

CODE_02CFEB:
    STZ.B PlayerXSpeed+1
    LDY.B _2
    LDA.W PeaBouncerPhysics,Y
    STA.W SpriteMisc151C,X
    LDA.B #$01
    STA.W SpriteMisc1528,X
    STZ.W SpriteMisc1570,X
Return02CFFD:
    RTS


PeaBouncerPhysics:
    db $01,$01,$03,$05,$07

DATA_02D003:
    db $40,$B0

DATA_02D005:
    db $01,$FF

DATA_02D007:
    db $30,$C0,$A0,$C0,$A0,$70,$60,$B0
DATA_02D00F:
    db $01,$FF,$01,$FF,$01,$FF,$01,$FF

SubOffscreen3Bnk2:
    LDA.B #$06                                ; \ Entry point of routine determines value of $03
    BRA +                                     ; |

SubOffscreen2Bnk2:
    LDA.B #$04                                ; |
    BRA +                                     ; |

SubOffscreen1Bnk2:
    LDA.B #$02                                ; |
  + STA.B _3                                  ; |
    BRA +                                     ; |

SubOffscreen0Bnk2:
    STZ.B _3                                  ; /
  + JSR IsSprOffScreenBnk2                    ; \ if sprite is not off screen, return
    BEQ Return02D090                          ; /
    LDA.B ScreenMode                          ; \  vertical level
    AND.B #!ScrMode_Layer1Vert                ; |
    BNE VerticalLevelBnk2                     ; /
    LDA.B _3
    CMP.B #$04
    BEQ CODE_02D04D
    LDA.B SpriteYPosLow,X                     ; \
    CLC                                       ; |
    ADC.B #$50                                ; | if the sprite has gone off the bottom of the level...
    LDA.W SpriteYPosHigh,X                    ; | (if adding 0x50 to the sprite y position would make the high byte >= 2)
    ADC.B #$00                                ; |
    CMP.B #$02                                ; |
    BPL OffScrEraseSprBnk2                    ; /    ...erase the sprite
    LDA.W SpriteTweakerD,X                    ; \ if "process offscreen" flag is set, return
    AND.B #$04                                ; |
    BNE Return02D090                          ; /
CODE_02D04D:
    LDA.B TrueFrame
    AND.B #$01
    ORA.B _3
    STA.B _1
    TAY
    LDA.B Layer1XPos
    CLC
    ADC.W DATA_02D007,Y
    ROL.B _0
    CMP.B SpriteXPosLow,X
    PHP
    LDA.B Layer1XPos+1
    LSR.B _0
    ADC.W DATA_02D00F,Y
    PLP
    SBC.W SpriteXPosHigh,X
    STA.B _0
    LSR.B _1
    BCC +
    EOR.B #$80
    STA.B _0
  + LDA.B _0
    BPL Return02D090
OffScrEraseSprBnk2:
    LDA.W SpriteStatus,X                      ; \ If sprite status < 8, permanently erase sprite
    CMP.B #$08                                ; |
    BCC +                                     ; /
    LDY.W SpriteLoadIndex,X                   ; \ Branch if should permanently erase sprite
    CPY.B #$FF                                ; |
    BEQ +                                     ; /
    LDA.B #$00                                ; \ Allow sprite to be reloaded by level loading routine
    STA.W SpriteLoadStatus,Y                  ; /
  + STZ.W SpriteStatus,X                      ; Erase sprite
Return02D090:
    RTS

VerticalLevelBnk2:
    LDA.W SpriteTweakerD,X                    ; \ If "process offscreen" flag is set, return
    AND.B #$04                                ; |
    BNE Return02D090                          ; /
    LDA.B TrueFrame                           ; \ Return every other frame
    LSR A                                     ; |
    BCS Return02D090                          ; /
    AND.B #$01
    STA.B _1
    TAY
    LDA.B Layer1YPos
    CLC
    ADC.W DATA_02D003,Y
    ROL.B _0
    CMP.B SpriteYPosLow,X
    PHP
    LDA.W Layer1YPos+1
    LSR.B _0
    ADC.W DATA_02D005,Y
    PLP
    SBC.W SpriteYPosHigh,X
    STA.B _0
    LDY.B _1
    BEQ +
    EOR.B #$80
    STA.B _0
  + LDA.B _0
    BPL Return02D090
    BMI OffScrEraseSprBnk2
IsSprOffScreenBnk2:
    LDA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    RTS


DATA_02D0D0:
    db $14,$FC

DATA_02D0D2:
    db $00,$FF

CODE_02D0D4:
    LDA.W SpriteMisc1564,X
    BNE +
    LDA.W SpriteMisc160E,X
    BPL +
    PHB
    PHK
    PLB
    JSR CODE_02D0E6
    PLB
  + RTL

CODE_02D0E6:
    STZ.B _F
    BRA CODE_02D149

    LDA.B SpriteYPosLow,X                     ; \ Unreachable
    CLC                                       ; | Something to do with Yoshi?
    ADC.B #$08
    AND.B #$F0
    STA.B _0
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    CMP.B LevelScrLength
    BCS Return02D148
    STA.B _3
    AND.B #$10
    STA.B _8
    LDY.W SpriteMisc157C,X
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_02D0D0,Y
    STA.B _1
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_02D0D2,Y
    CMP.B #$02
    BCS Return02D148
    STA.B _2
    LDA.B _1
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _3
    LDA.L DATA_00BA80,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA8E,X
  + CLC
    ADC.B _0
    STA.B _5
    LDA.L DATA_00BABC,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BACA,X
  + ADC.B _2
    STA.B _6
    BRA CODE_02D1AD

Return02D148:
    RTS

CODE_02D149:
    LDA.B SpriteYPosLow,X                     ; \ $18B2 = Sprite Y position + #$08
    CLC                                       ; |
    ADC.B #$08                                ; |
    STA.W YoshiYPos                           ; /
    AND.B #$F0                                ; \ $00 = (Sprite Y position + #$08) rounded down to closest #$10 low byte
    STA.B _0                                  ; /
    LDA.W SpriteYPosHigh,X                    ; \
    ADC.B #$00                                ; | Return if off screen
    CMP.B #$02                                ; |
    BCS Return02D148                          ; |
    STA.B _2                                  ; | $02 = (Sprite Y position + #$08) High byte
    STA.W YoshiYPos+1                         ; /
    LDY.W SpriteMisc157C,X                    ; \ $18B0 = Sprite X position + $0014/$FFFC
    LDA.B SpriteXPosLow,X                     ; |
    CLC                                       ; |
    ADC.W DATA_02D0D0,Y                       ; |
    STA.B _1                                  ; | $01 = (Sprite X position + $0014/$FFFC) Low byte
    STA.W YoshiXPos                           ; |
    LDA.W SpriteXPosHigh,X                    ; |
    ADC.W DATA_02D0D2,Y                       ; |
    CMP.B LevelScrLength                      ; | Return if past end of level
    BCS Return02D148                          ; |
    STA.W YoshiXPos+1                         ; |
    STA.B _3                                  ; / $03 = (Sprite X position + $0014/$FFFC) High byte
    LDA.B _1                                  ; \ $00 = bits 4-7 of Y position, bits 4-7 of X position
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    ORA.B _0                                  ; |
    STA.B _0                                  ; /
    LDX.B _3
    LDA.L DATA_00BA60,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA70,X
  + CLC
    ADC.B _0
    STA.B _5
    LDA.L DATA_00BA9C,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BAAC,X
  + ADC.B _2
    STA.B _6
CODE_02D1AD:
    LDA.B #$7E
    STA.B _7
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B [_5]
    STA.W Map16TileNumber
    INC.B _7
    LDA.B [_5]
    BNE +
    LDA.W Map16TileNumber
    CMP.B #$45
    BCC +
    CMP.B #$48
    BCS +
    SEC
    SBC.B #$44
    STA.W EatenBerryType
    STZ.W YoshiTongueTimer
    LDY.W PlayerDuckingOnYoshi
    LDA.W DATA_02D1F1,Y
    STA.W SpriteMisc1602,X
    LDA.B #$22
    STA.W SpriteMisc1564,X
    LDA.B PlayerYPosNext
    CLC
    ADC.B #$08
    AND.B #$F0
    STA.B PlayerYPosNext
    LDA.B PlayerYPosNext+1
    ADC.B #$00
    STA.B PlayerYPosNext+1
  + RTS


DATA_02D1F1:
    db $00,$04

SetTreeTile:
    LDA.W YoshiXPos                           ; \ Set X position of block
    STA.B TouchBlockXPos                      ; |
    LDA.W YoshiXPos+1                         ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.W YoshiYPos                           ; \ Set Y position of block
    STA.B TouchBlockYPos                      ; |
    LDA.W YoshiYPos+1                         ; |
    STA.B TouchBlockYPos+1                    ; /
    LDA.B #$04                                ; \ Block to generate = Tree behind berry
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile
Return02D20F:
    RTL


    db $01

DATA_02D211:
    db $FF,$10,$F0

CODE_02D214:
    LDA.B byetudlrHold
    AND.B #$03
    BNE CODE_02D228
CODE_02D21A:
    LDA.B SpriteXSpeed,X
    BEQ CODE_02D226
    BPL +
    INC.B SpriteXSpeed,X
    INC.B SpriteXSpeed,X
  + DEC.B SpriteXSpeed,X
CODE_02D226:
    BRA CODE_02D247

CODE_02D228:
    TAY
    CPY.B #$01
    BNE CODE_02D238
    LDA.B SpriteXSpeed,X
    CMP.W DATA_02D211,Y
    BEQ CODE_02D247
    BPL CODE_02D21A
    BRA CODE_02D241

CODE_02D238:
    LDA.B SpriteXSpeed,X
    CMP.W DATA_02D211,Y
    BEQ CODE_02D247
    BMI CODE_02D21A
CODE_02D241:
    CLC
    ADC.W Return02D20F,Y
    STA.B SpriteXSpeed,X
CODE_02D247:
    LDY.B #$00
    LDA.B SpriteNumber,X
    CMP.B #$87
    BNE CODE_02D25F
    LDA.B byetudlrHold
    AND.B #$0C
    BEQ +
    LDY.B #$10
    AND.B #$08
    BEQ +
    LDY.B #$F0
    BRA +

CODE_02D25F:
    LDY.B #$F8
    LDA.B byetudlrHold
    AND.B #$0C
    BEQ +
    LDY.B #$F0
    AND.B #$08
    BNE +
    LDY.B #$08
  + STY.B _0
    LDA.B SpriteYSpeed,X
    CMP.B _0
    BEQ CODE_02D27F
    BPL +
    INC.B SpriteYSpeed,X
    INC.B SpriteYSpeed,X
  + DEC.B SpriteYSpeed,X
CODE_02D27F:
    LDA.B SpriteXSpeed,X
    STA.B PlayerXSpeed+1
    LDA.B SpriteYSpeed,X
    STA.B PlayerYSpeed+1
    RTL

UpdateXPosNoGrvty:
    TXA                                       ; \ Adjust index so we use X values rather than Y
    CLC                                       ; |
    ADC.B #$0C                                ; |
    TAX                                       ; /
    JSR UpdateYPosNoGrvty
    LDX.W CurSpriteProcess                    ; X = sprite index
    RTS

UpdateYPosNoGrvty:
    LDA.B SpriteYSpeed,X                      ; \ $14EC or $14F8 += 16 * speed
    ASL A                                     ; |
    ASL A                                     ; |
    ASL A                                     ; |
    ASL A                                     ; |
    CLC                                       ; |
    ADC.W SpriteYPosSpx,X                     ; |
    STA.W SpriteYPosSpx,X                     ; /
    PHP
    PHP
    LDY.B #$00
    LDA.B SpriteYSpeed,X                      ; \ Amount to move sprite = speed / 16
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; /
    CMP.B #$08                                ; \ If speed was negative...
    BCC +                                     ; |
    ORA.B #$F0                                ; | ...set high bits
    DEY                                       ; /
  + PLP
    PHA                                       ; \ Add to position
    ADC.B SpriteYPosLow,X                     ; |
    STA.B SpriteYPosLow,X                     ; |
    TYA                                       ; |
    ADC.W SpriteYPosHigh,X                    ; |
    STA.W SpriteYPosHigh,X                    ; |
    PLA                                       ; /
    PLP
    ADC.B #$00
    STA.W SpriteXMovement                     ; $1491 = amount sprite was moved
    RTS

    STA.B _0                                  ; Unreachable
    LDA.B PlayerXPosNext                      ; \ Save Mario's position
    PHA                                       ; |
    LDA.B PlayerXPosNext+1                    ; |
    PHA                                       ; |
    LDA.B PlayerYPosNext                      ; |
    PHA                                       ; |
    LDA.B PlayerYPosNext+1                    ; |
    PHA                                       ; /
    LDA.W SpriteXPosLow,Y                     ; \ Mario's position = Sprite position
    STA.B PlayerXPosNext                      ; |
    LDA.W SpriteXPosHigh,Y                    ; |
    STA.B PlayerXPosNext+1                    ; |
    LDA.W SpriteYPosLow,Y                     ; |
    STA.B PlayerYPosNext                      ; |
    LDA.W SpriteYPosHigh,Y                    ; |
    STA.B PlayerYPosNext+1                    ; /
    LDA.B _0
    JSR CODE_02D2FB
    PLA                                       ; \ Restore Mario's position
    STA.B PlayerYPosNext+1                    ; |
    PLA                                       ; |
    STA.B PlayerYPosNext                      ; |
    PLA                                       ; |
    STA.B PlayerXPosNext+1                    ; |
    PLA                                       ; |
    STA.B PlayerXPosNext                      ; /
    RTS

CODE_02D2FB:
    STA.B _1
    PHX
    PHY
    JSR CODE_02D50C
    STY.B _2
    LDA.B _E
    BPL +
    EOR.B #$FF
    CLC
    ADC.B #$01
  + STA.B _C
    JSR CODE_02D4FA
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
CODE_02D338:
    LDA.B _B
    CLC
    ADC.B _C
    CMP.B _D
    BCC +
    SBC.B _D
    INC.B _0
  + STA.B _B
    DEX
    BNE CODE_02D338
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


DATA_02D374:
    db $0C,$1C

DATA_02D376:
    db $01,$02

GetDrawInfo2:
    STZ.W SpriteOffscreenVert,X
    STZ.W SpriteOffscreenX,X
    LDA.B SpriteXPosLow,X
    CMP.B Layer1XPos
    LDA.W SpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BEQ +
    INC.W SpriteOffscreenX,X
  + LDA.W SpriteXPosHigh,X
    XBA
    LDA.B SpriteXPosLow,X
    REP #$20                                  ; A->16
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.W #$0040
    CMP.W #$0180
    SEP #$20                                  ; A->8
    ROL A
    AND.B #$01
    STA.W SpriteWayOffscreenX,X
    BNE CODE_02D3E7
    LDY.B #$00
    LDA.W SpriteTweakerB,X
    AND.B #$20
    BEQ CODE_02D3B2
    INY
CODE_02D3B2:
    LDA.B SpriteYPosLow,X
    CLC
    ADC.W DATA_02D374,Y
    PHP
    CMP.B Layer1YPos
    ROL.B _0
    PLP
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    LSR.B _0
    SBC.B Layer1YPos+1
    BEQ +
    LDA.W SpriteOffscreenVert,X
    ORA.W DATA_02D376,Y
    STA.W SpriteOffscreenVert,X
  + DEY
    BPL CODE_02D3B2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    RTS

CODE_02D3E7:
    PLA
    PLA
    RTS

Layer3SmashMain:
    JSL CODE_00FF61
    LDA.B SpriteLock
    BNE Return02D444
    JSR CODE_02D49C
    LDY.B #$00
    LDA.W Layer1DXPos
    BPL +
    DEY
  + CLC
    ADC.B SpriteXPosLow,X
    STA.B SpriteXPosLow,X
    TYA
    ADC.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,X
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02D419
    dw CODE_02D445
    dw CODE_02D455
    dw CODE_02D481
    dw CODE_02D489

CODE_02D419:
    LDA.W SpriteWillAppear
    BEQ +
    JSR OffScrEraseSprBnk2
    RTS

  + LDA.W SpriteMisc1540,X
    BNE Return02D444
    INC.B SpriteTableC2,X
    LDA.B #con($80,$80,$80,$68,$68)
    STA.W SpriteMisc1540,X
    JSL GetRand
    AND.B #$3F
    ORA.B #$80
    STA.B SpriteXPosLow,X
    LDA.B #$FF
    STA.W SpriteXPosHigh,X
    STZ.B SpriteYPosLow,X
    STZ.W SpriteYPosHigh,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
Return02D444:
    RTL

CODE_02D445:
    LDA.W SpriteMisc1540,X
    BEQ +
    LDA.B #con($04,$04,$04,$06,$06)
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty
    RTL

  + INC.B SpriteTableC2,X
    RTL

CODE_02D455:
    JSR UpdateYPosNoGrvty
    LDA.B SpriteYSpeed,X
    BMI CODE_02D460
    CMP.B #con($40,$40,$40,$70,$70)
    BCS +
CODE_02D460:
    CLC
    ADC.B #con($07,$07,$07,$0A,$0A)
    STA.B SpriteYSpeed,X
  + LDA.B SpriteYPosLow,X
    CMP.B #$A0
    BCC +
    AND.B #$F0
    STA.B SpriteYPosLow,X
    LDA.B #$50                                ; \ Set ground shake timer
    STA.W ScreenShakeTimer                    ; /
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$30
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + RTL

CODE_02D481:
    LDA.W SpriteMisc1540,X
    BNE +
    INC.B SpriteTableC2,X
  + RTL

CODE_02D489:
    LDA.B #con($E0,$E0,$E0,$D8,$D8)
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty
    LDA.B SpriteYPosLow,X
    BNE +
    STZ.B SpriteTableC2,X
    LDA.B #con($A0,$A0,$A0,$88,$88)
    STA.W SpriteMisc1540,X
  + RTL

CODE_02D49C:
    LDA.B #$00
    LDY.B Powerup
    BEQ +
    LDY.B PlayerIsDucking
    BNE +
    LDA.B #$10
  + CLC
    ADC.B SpriteYPosLow,X
    CMP.B PlayerYPosScrRel
    BCC CODE_02D4EF
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    REP #$20                                  ; A->16
    LDA.B PlayerXPosScrRel
    CLC
    ADC.B _0
    SEC
    SBC.W #$0030
    CMP.W #$0090
    BCS CODE_02D4EF
    SEC
    SBC.W #$0008
    CMP.W #$0080
    SEP #$20                                  ; A->8
    BCS CODE_02D4E5
    LDA.B PlayerInAir
    BNE +
    JSL HurtMario
    RTS

  + STZ.B PlayerYSpeed+1
    LDA.B SpriteYSpeed,X
    BMI +
    STA.B PlayerYSpeed+1
  + RTS

CODE_02D4E5:
    PHP
    LDA.B #$08
    PLP
    BPL +
    LDA.B #$F8
  + STA.B PlayerXSpeed+1
CODE_02D4EF:
    SEP #$20                                  ; A->8
    RTS


    db $80,$40,$20,$10,$08,$04,$02,$01

CODE_02D4FA:
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

CODE_02D50C:
    LDY.B #$00
    LDA.B PlayerYPosNext
    SEC
    SBC.B SpriteYPosLow,X
    STA.B _E
    LDA.B PlayerYPosNext+1
    SBC.W SpriteYPosHigh,X
    BPL +
    INY
  + RTS

    %insert_empty($46,$62,$62,$62,$62)

StompSFX2:
    db !SFX_STOMP1
    db !SFX_STOMP2
    db !SFX_STOMP3
    db !SFX_STOMP4
    db !SFX_STOMP5
    db !SFX_STOMP6
    db !SFX_STOMP7

CODE_02D587:
    JSR CODE_02D5E4
    LDA.W SpriteStatus,X
    CMP.B #$02
    BEQ +
    LDA.B SpriteLock
    BNE +
    JSR SubOffscreen0Bnk2
    LDA.B #$E8
    STA.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty
    JSL MarioSprInteract
  + RTS


DATA_02D5A4:
    db $00,$10,$20,$30,$00,$10,$20,$30
    db $00,$10,$20,$30,$00,$10,$20,$30
DATA_02D5B4:
    db $00,$00,$00,$00,$10,$10,$10,$10
    db $20,$20,$20,$20,$30,$30,$30,$30
BanzaiBillTiles:
    db $80,$82,$84,$86,$A0,$88,$CE,$EE
    db $C0,$C2,$CE,$EE,$8E,$AE,$84,$86
DATA_02D5D4:
    db $33,$33,$33,$33,$33,$33,$33,$33
    db $33,$33,$33,$33,$33,$33,$B3,$B3

CODE_02D5E4:
    JSR GetDrawInfo2
    PHX
    LDX.B #$0F
  - LDA.B _0
    CLC
    ADC.W DATA_02D5A4,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_02D5B4,X
    STA.W OAMTileYPos+$100,Y
    LDA.W BanzaiBillTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02D5D4,X
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$0F
    JMP CODE_02B7A7

Banzai_Rotating:
    PHB
    PHK
    PLB
    LDA.B SpriteNumber,X
    CMP.B #$9F
    BNE CODE_02D625
    JSR CODE_02D587
    BRA +

CODE_02D625:
    JSR CODE_02D62A
  + PLB
    RTL

CODE_02D62A:
    JSR SubOffscreen3Bnk2
    LDA.B SpriteLock
    BNE CODE_02D653
    LDA.B SpriteXPosLow,X
    LDY.B #$02
    AND.B #$10
    BNE +
    LDY.B #$FE
  + TYA
    LDY.B #$00
    CMP.B #$00
    BPL +
    DEY
  + CLC
    ADC.W SpriteMisc1602,X
    STA.W SpriteMisc1602,X
    TYA
    ADC.W SpriteMisc151C,X
    AND.B #$01
    STA.W SpriteMisc151C,X
CODE_02D653:
    LDA.W SpriteMisc151C,X
    STA.B _1
    LDA.W SpriteMisc1602,X
    STA.B _0
    REP #$30                                  ; AXY->16
    LDA.B _0
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
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _4
    STA.W HW_WRMPYA
    LDA.W SpriteMisc187B,X
    LDY.B _5
    BNE +
    STA.W HW_WRMPYB
    JSR CODE_02D800
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
    LDA.W SpriteMisc187B,X
    LDY.B _7
    BNE +
    STA.W HW_WRMPYB
    JSR CODE_02D800
    ASL.W HW_RDMPY
    LDA.W HW_RDMPY+1
    ADC.B #$00
  + LSR.B _3
    BCC +
    EOR.B #$FF
    INC A
  + STA.B _6
    LDA.B SpriteXPosLow,X
    PHA
    LDA.W SpriteXPosHigh,X
    PHA
    LDA.B SpriteYPosLow,X
    PHA
    LDA.W SpriteYPosHigh,X
    PHA
    LDY.W ClusterSpriteMisc0F86,X
    STZ.B _0
    LDA.B _4
    BPL +
    DEC.B _0
  + CLC
    ADC.B SpriteXPosLow,X
    STA.B SpriteXPosLow,X
    PHP
    PHA
    SEC
    SBC.W SpriteMisc1534,X
    STA.W SpriteMisc1528,X
    PLA
    STA.W SpriteMisc1534,X
    PLP
    LDA.W SpriteXPosHigh,X
    ADC.B _0
    STA.W SpriteXPosHigh,X
    STZ.B _1
    LDA.B _6
    BPL +
    DEC.B _1
  + CLC
    ADC.B SpriteYPosLow,X
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    ADC.B _1
    STA.W SpriteYPosHigh,X
    LDA.B SpriteNumber,X
    CMP.B #$9E
    BEQ CODE_02D750
    JSL InvisBlkMainRt
    BCC CODE_02D73D
    LDA.B #$03
    STA.W SpriteMisc160E,X
    STA.W StandOnSolidSprite
    LDA.W PlayerRidingYoshi
    BNE +
    PHX
    JSL DrawMarioAndYoshi
    PLX
    LDA.B #$FF
    STA.B PlayerHiddenTiles
    BRA +

CODE_02D73D:
    LDA.W SpriteMisc160E,X
    BEQ +
    STZ.W SpriteMisc160E,X
    PHX
    JSL DrawMarioAndYoshi
    PLX
  + JSR CODE_02D848
    BRA +

CODE_02D750:
    JSL MarioSprInteract
    JSR CODE_02D813
  + PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    PLA
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X
    LDA.B _0
    CLC
    ADC.B Layer1XPos
    SEC
    SBC.B SpriteXPosLow,X
    JSR CODE_02D870
    CLC
    ADC.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.B _1
    CLC
    ADC.B Layer1YPos
    SEC
    SBC.B SpriteYPosLow,X
    JSR CODE_02D870
    CLC
    ADC.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    LDA.W SpriteWayOffscreenX,X
    BNE Return02D806
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$10
    TAY
    PHX
    LDA.B SpriteXPosLow,X
    STA.B _A
    LDA.B SpriteYPosLow,X
    STA.B _B
    LDA.B SpriteNumber,X
    TAX
    LDA.B #$E8
    CPX.B #$9E
    BEQ +
    LDA.B #$A2
  + STA.B _8
    LDX.B #$01
  - LDA.B _0
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.B _8
    STA.W OAMTileNo+$100,Y
    LDA.B #$33
    STA.W OAMTileAttr+$100,Y
    LDA.B _0
    CLC
    ADC.B Layer1XPos
    SEC
    SBC.B _A
    STA.B _0
    ASL A
    ROR.B _0
    LDA.B _0
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.B _A
    STA.B _0
    LDA.B _1
    CLC
    ADC.B Layer1YPos
    SEC
    SBC.B _B
    STA.B _1
    ASL A
    ROR.B _1
    LDA.B _1
    SEC
    SBC.B Layer1YPos
    CLC
    ADC.B _B
    STA.B _1
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$05
    JMP CODE_02B7A7

CODE_02D800:
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
Return02D806:
    RTS


DATA_02D807:
    db $F8,$08,$F8,$08

DATA_02D80B:
    db $F8,$F8,$08,$08

DATA_02D80F:
    db $33,$73,$B3,$F3

CODE_02D813:
    JSR GetDrawInfo2
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC
    ADC.W DATA_02D807,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_02D80B,X
    STA.W OAMTileYPos+$100,Y
    LDA.W CODE_02D800,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02D80F,X
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    RTS


DATA_02D840:
    db $00,$F0,$00,$10

WoodPlatformTiles:
    db $A2,$60,$61,$62

CODE_02D848:
    JSR GetDrawInfo2
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC
    ADC.W DATA_02D840,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.W WoodPlatformTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.B #$33
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    RTS

CODE_02D870:
    PHP
    BPL +
    EOR.B #$FF
    INC A
  + STA.W HW_WRDIV+1
    STZ.W HW_WRDIV
    LDA.W SpriteMisc187B,X
    LSR A
    STA.W HW_WRDIV+2
    JSR CODE_02D800
    LDA.W HW_RDDIV
    STA.B _E
    LDA.W HW_RDDIV+1
    ASL.B _E
    ROL A
    ASL.B _E
    ROL A
    ASL.B _E
    ROL A
    ASL.B _E
    ROL A
    PLP
    BPL +
    EOR.B #$FF
    INC A
  + RTS


BubbleSprTiles1:
    db $A8,$CA,$67,$24

BubbleSprTiles2:
    db $AA,$CC,$69,$24

BubbleSprGfxProp1:
    db $84,$85,$05,$08

BubbleSpriteMain:
    PHB
    PHK
    PLB
    JSR CODE_02D8BB
    PLB
    RTL


BubbleSprGfxProp2:
    db $08,$F8

BubbleSprGfxProp3:
    db $01,$FF

BubbleSprGfxProp4:
    db $0C,$F4

CODE_02D8BB:
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$14
    STA.W SpriteOAMIndex,X
    JSL GenericSprGfxRt2
    PHX
    LDA.B SpriteTableC2,X
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    TAX
    LDA.W BubbleSprGfxProp1,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDA.B EffFrame
    ASL A
    ASL A
    ASL A
    LDA.W BubbleSprTiles1,X
    BCC +
    LDA.W BubbleSprTiles2,X
  + STA.W OAMTileNo+$100,Y
    PLX
    LDA.W SpriteMisc1534,X
    CMP.B #$60
    BCS CODE_02D8F3
    AND.B #$02
    BEQ +
CODE_02D8F3:
    JSR CODE_02D9D6
  + LDA.W SpriteStatus,X
    CMP.B #$02
    BNE CODE_02D904
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    BRA CODE_02D96B

CODE_02D904:
    LDA.B SpriteLock
    BNE Return02D977
    LDA.B TrueFrame
    AND.B #$01
    BNE +
    DEC.W SpriteMisc1534,X
    LDA.W SpriteMisc1534,X
    CMP.B #$04
    BNE +
    LDA.B #!SFX_CLAP                          ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + LDA.W SpriteMisc1534,X
    DEC A
    BEQ CODE_02D978
    CMP.B #$07
    BCC Return02D977
    JSR SubOffscreen0Bnk2
    JSR UpdateXPosNoGrvty
    JSR UpdateYPosNoGrvty
    JSL CODE_019138
    LDY.W SpriteMisc157C,X
    LDA.W BubbleSprGfxProp2,Y
    STA.B SpriteXSpeed,X
    LDA.B TrueFrame
    AND.B #$01
    BNE +
    LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W BubbleSprGfxProp3,Y
    STA.B SpriteYSpeed,X
    CMP.W BubbleSprGfxProp4,Y
    BNE +
    INC.W SpriteMisc151C,X
  + LDA.W SpriteBlockedDirs,X
    BNE CODE_02D96B
    JSL SprSprInteract
    JSL MarioSprInteract
    BCC Return02D9A0
    STZ.B PlayerYSpeed+1
    STZ.B PlayerXSpeed+1
CODE_02D96B:
    LDA.W SpriteMisc1534,X
    CMP.B #$07
    BCC Return02D977
    LDA.B #$06
    STA.W SpriteMisc1534,X
Return02D977:
    RTS

CODE_02D978:
    LDY.B SpriteTableC2,X
    LDA.W BubbleSprites,Y
    STA.B SpriteNumber,X
    PHA
    JSL InitSpriteTables
    PLY
    LDA.B #$20
    CPY.B #$74
    BNE +
    LDA.B #$04
  + STA.W SpriteMisc154C,X
    LDA.B SpriteNumber,X
    CMP.B #$0D
    BNE +
    DEC.W SpriteMisc1540,X
  + JSR CODE_02D4FA
    TYA
    STA.W SpriteMisc157C,X
Return02D9A0:
    RTS


BubbleSprites:
    db $0F,$0D,$15,$74

BubbleTileDispX:
    db $F8,$08,$F8,$08,$FF,$F9,$07,$F9
    db $07,$00,$FA,$06,$FA,$06,$00

BubbleTileDispY:
    db $F6,$F6,$02,$02,$FC,$F5,$F5,$03
    db $03,$FC,$F4,$F4,$04,$04,$FB

BubbleTiles:
    db $A0,$A0,$A0,$A0,$99

BubbleGfxProp:
    db $07,$47,$87,$C7,$03

BubbleSize:
    db $02,$02,$02,$02,$00

DATA_02D9D2:
    db $00,$05,$0A,$05

CODE_02D9D6:
    JSR GetDrawInfo2
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W DATA_02D9D2,Y
    STA.B _2
    LDA.W SpriteOAMIndex,X
    SEC
    SBC.B #$14
    STA.W SpriteOAMIndex,X
    TAY
    PHX
    LDA.W SpriteMisc1534,X
    STA.B _3
    LDX.B #$04
CODE_02D9F8:
    PHX
    TXA
    CLC
    ADC.B _2
    TAX
    LDA.B _0
    CLC
    ADC.W BubbleTileDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W BubbleTileDispY,X
    STA.W OAMTileYPos+$100,Y
    PLX
    LDA.W BubbleTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W BubbleGfxProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDA.B _3
    CMP.B #$06
    BCS CODE_02DA37
    CMP.B #$03
    LDA.B #$02
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDA.B #$64
    BCS +
    LDA.B #$66
  + STA.W OAMTileNo+$100,Y
CODE_02DA37:
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W BubbleSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_02D9F8
    PLX
    LDY.B #$FF
    LDA.B #$04
    JMP CODE_02B7A7

HammerBrotherMain:
    PHB
    PHK
    PLB
    JSR CODE_02DA5A
    PLB
Return02DA59:
    RTL

CODE_02DA5A:
    STZ.W SpriteMisc157C,X
    LDA.W SpriteStatus,X
    CMP.B #$02
    BNE +
    JMP HammerBroGfx


HammerFreq:
    db $1F,$0F,$0F,$0F,$0F,$0F,$0F

  + LDA.B SpriteLock
    BNE Return02DAE8
    JSL SprSpr_MarioSprRts
    JSR SubOffscreen1Bnk2
    LDY.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,Y
    TAY
    LDA.B TrueFrame                           ; \ Increment $1570,x 3 out of every 4 frames
    AND.B #$03                                ; |
    BEQ +                                     ; |
    INC.W SpriteMisc1570,X                    ; /
  + LDA.W SpriteMisc1570,X
    ASL A
    CPY.B #$00
    BEQ +
    ASL A
  + AND.B #$40
    STA.W SpriteMisc157C,X
    LDA.W SpriteMisc1570,X                    ; \ Don't throw if...
    AND.W HammerFreq,Y                        ; | ...not yet time
    ORA.W SpriteOffscreenX,X                  ; | ...sprite offscreen
    ORA.W SpriteOffscreenVert,X               ; |
    ORA.W SpriteMisc1540,X                    ; | ...we just threw one
    BNE Return02DAE8                          ; /
    LDA.B #$03                                ; \ Set minimum time in between throws
    STA.W SpriteMisc1540,X                    ; /
    LDY.B #$10                                ; \ $00 = Hammer X speed,
    LDA.W SpriteMisc157C,X                    ; | based on sprite's direction
    BNE +                                     ; |
    LDY.B #$F0                                ; |
  + STY.B _0                                  ; /
    LDY.B #$07                                ; \ Find a free extended sprite slots
CODE_02DABA:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ GenerateHammer                        ; |
    DEY                                       ; |
    BPL CODE_02DABA                           ; |
    RTS                                       ; / Return if no free slots

GenerateHammer:
    LDA.B #$04                                ; \ Extended sprite = Hammer
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X                     ; \ Hammer X pos = sprite X pos
    STA.W ExtSpriteXPosLow,Y                  ; |
    LDA.W SpriteXPosHigh,X                    ; |
    STA.W ExtSpriteXPosHigh,Y                 ; /
    LDA.B SpriteYPosLow,X                     ; \ Hammer Y pos = sprite Y pos
    STA.W ExtSpriteYPosLow,Y                  ; |
    LDA.W SpriteYPosHigh,X                    ; |
    STA.W ExtSpriteYPosHigh,Y                 ; /
    LDA.B #$D0                                ; \ Hammer Y speed = #$D0
    STA.W ExtSpriteYSpeed,Y                   ; /
    LDA.B _0                                  ; \ Hammer X speed = $00
    STA.W ExtSpriteXSpeed,Y                   ; /
Return02DAE8:
    RTS


HammerBroDispX:
    db $08,$10,$00,$10

HammerBroDispY:
    db $F8,$F8,$00,$00

HammerBroTiles:
    db $5A,$4A,$46,$48,$4A,$5A,$48,$46
HammerBroTileSize:
    db $00,$00,$02,$02

HammerBroGfx:
    JSR GetDrawInfo2
    LDA.W SpriteMisc157C,X
    STA.B _2
    PHX
    LDX.B #$03
CODE_02DB08:
    LDA.B _0
    CLC
    ADC.W HammerBroDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W HammerBroDispY,X
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.B _2
    PHA
    ORA.B #$37
    STA.W OAMTileAttr+$100,Y
    PLA
    BEQ +
    INX
    INX
    INX
    INX
  + LDA.W HammerBroTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W HammerBroTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_02DB08
CODE_02DB44:
    PLX
    LDY.B #$FF
    LDA.B #$03
    JMP CODE_02B7A7

FlyingPlatformMain:
    PHB
    PHK
    PLB
    JSR CODE_02DB5C
    PLB
    RTL


DATA_02DB54:
    db $01,$FF

DATA_02DB56:
    db $20,$E0

DATA_02DB58:
    db $02,$FE

DATA_02DB5A:
    db $20,$E0

CODE_02DB5C:
    JSR FlyingPlatformGfx                     ; Draw sprite
    LDA.B #$FF                                ; \ $1594 = #$FF
    STA.W SpriteMisc1594,X                    ; /
    LDY.B #$09                                ; \ Check sprite slots 0-9 for Hammer Brother
CODE_02DB66:
    LDA.W SpriteStatus,Y                      ; |
    CMP.B #$08                                ; |
    BNE CODE_02DB74                           ; |
    LDA.W SpriteNumber,Y                      ; |
    CMP.B #$9B                                ; |
    BEQ PutHammerBroOnPlat                    ; |
CODE_02DB74:
    DEY                                       ; |
    BPL CODE_02DB66                           ; |
    BRA +                                     ; / Branch if no Hammer Brother

PutHammerBroOnPlat:
    TYA                                       ; \ $1594 = index of Hammer Bro
    STA.W SpriteMisc1594,X                    ; /
    LDA.B SpriteXPosLow,X                     ; \ Hammer Bro X postion = Platform X position
    STA.W SpriteXPosLow,Y                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    STA.W SpriteXPosHigh,Y                    ; /
    LDA.B SpriteYPosLow,X                     ; \ Hammer Bro Y position = Platform Y position - #$10
    SEC                                       ; |
    SBC.B #$10                                ; |
    STA.W SpriteYPosLow,Y                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    SBC.B #$00                                ; |
    STA.W SpriteYPosHigh,Y                    ; /
    PHX                                       ; \ Draw Hammer Bro
    TYX                                       ; |
    JSR HammerBroGfx                          ; |
    PLX                                       ; /
  + LDA.B SpriteLock
    BNE Return02DC0E
    JSR SubOffscreen1Bnk2
    LDA.B TrueFrame
    AND.B #$01
    BNE CODE_02DBD7
    LDA.W SpriteMisc1534,X
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X
    CLC
    ADC.W DATA_02DB54,Y
    STA.B SpriteXSpeed,X
    CMP.W DATA_02DB56,Y
    BNE +
    INC.W SpriteMisc1534,X
  + LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W DATA_02DB58,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_02DB5A,Y
    BNE CODE_02DBD7
    INC.W SpriteMisc151C,X
CODE_02DBD7:
    JSR UpdateYPosNoGrvty
    JSR UpdateXPosNoGrvty
    STA.W SpriteMisc1528,X
    JSL InvisBlkMainRt
    LDA.W SpriteMisc1558,X
    BEQ Return02DC0E
    LDA.B #$01
    STA.B SpriteTableC2,X
    JSR CODE_02D4FA
    LDA.B _F
    CMP.B #$08
    BMI +
    INC.B SpriteTableC2,X
  + LDY.W SpriteMisc1594,X
    BMI Return02DC0E
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$C0
    STA.W SpriteYSpeed,Y
    PHX
    TYX
    JSL CODE_01AB6F
    PLX
Return02DC0E:
    RTS


DATA_02DC0F:
    db $00,$10,$F2,$1E,$00,$10,$FA,$1E
DATA_02DC17:
    db $00,$00,$F6,$F6,$00,$00,$FE,$FE
HmrBroPlatTiles:
    db $40,$40,$C6,$C6,$40,$40,$5D,$5D
DATA_02DC27:
    db $32,$32,$72,$32,$32,$32,$72,$32
DATA_02DC2F:
    db $02,$02,$02,$02,$02,$02,$00,$00
DATA_02DC37:
    db $00,$04,$06,$08,$08,$06,$04,$00

FlyingPlatformGfx:
    JSR GetDrawInfo2
    LDA.B SpriteTableC2,X
    STA.B _7
    LDA.W SpriteMisc1558,X
    LSR A
    TAY
    LDA.W DATA_02DC37,Y
    STA.B _5
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    LDA.B EffFrame
    LSR A
    AND.B #$04
    STA.B _2
    LDX.B #$03
CODE_02DC5D:
    STX.B _6
    TXA
    ORA.B _2
    TAX
    LDA.B _0
    CLC
    ADC.W DATA_02DC0F,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_02DC17,X
    STA.W OAMTileYPos+$100,Y
    PHX
    LDX.B _6
    CPX.B #$02
    BCS +
    INX
    CPX.B _7
    BNE +
    LDA.W OAMTileYPos+$100,Y
    SEC
    SBC.B _5
    STA.W OAMTileYPos+$100,Y
  + PLX
    LDA.W HmrBroPlatTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02DC27,X
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W DATA_02DC2F,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    LDX.B _6
    DEX
    BPL CODE_02DC5D
    JMP CODE_02DB44

SumoBrotherMain:
    PHB
    PHK
    PLB
    JSR CODE_02DCB7
    PLB
    RTL

CODE_02DCB7:
    JSR SumoBroGfx
    LDA.B SpriteLock
    BNE Return02DCE9
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return02DCE9
    JSR SubOffscreen0Bnk2
    JSL SprSpr_MarioSprRts
    JSL UpdateSpritePos
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
  + LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02DCEA
    dw CODE_02DCFF
    dw CODE_02DD0E
    dw CODE_02DD4B

Return02DCE9:
    RTS

CODE_02DCEA:
    LDA.B #$01
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    BNE +
    STZ.W SpriteMisc1602,X
    LDA.B #$03
CODE_02DCF9:
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + RTS

CODE_02DCFF:
    LDA.W SpriteMisc1540,X
    BNE Return02DD0B
    INC.W SpriteMisc1602,X
    LDA.B #$03
    BRA CODE_02DCF9

Return02DD0B:
    RTS


DATA_02DD0C:
    db $20,$E0

CODE_02DD0E:
    LDA.W SpriteMisc1558,X
    BNE CODE_02DD45
    LDY.W SpriteMisc157C,X
    LDA.W DATA_02DD0C,Y
    STA.B SpriteXSpeed,X
    LDA.W SpriteMisc1540,X
    BNE Return02DD44
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    AND.B #$01
    BNE +
    LDA.B #$20
    STA.W SpriteMisc1558,X
  + LDA.W SpriteMisc1570,X
    CMP.B #$03
    BNE CODE_02DD3D
    STZ.W SpriteMisc1570,X
    LDA.B #$70
    BRA CODE_02DCF9

CODE_02DD3D:
    LDA.B #$03
CODE_02DD3F:
    JSR CODE_02DCF9
    STZ.B SpriteTableC2,X
Return02DD44:
    RTS

CODE_02DD45:
    LDA.B #$01
    STA.W SpriteMisc1602,X
    RTS

CODE_02DD4B:
    LDA.B #$03
    LDY.W SpriteMisc1540,X
    BEQ CODE_02DD81
    CPY.B #$2E
    BNE CODE_02DD6F
    PHA
    LDA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    BNE +
    LDA.B #$30                                ; \ Set ground shake timer
    STA.W ScreenShakeTimer                    ; /
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
    PHY
    JSR GenSumoLightning
    PLY
  + PLA
CODE_02DD6F:
    CPY.B #$30
    BCC +
    CPY.B #$50
    BCS +
    INC A
    CPY.B #$44
    BCS +
    INC A
  + STA.W SpriteMisc1602,X
    RTS

CODE_02DD81:
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
    LDA.B #$40
    JSR CODE_02DD3F
    RTS

GenSumoLightning:
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BMI +                                     ; /
    LDA.B #$2B                                ; \ Sprite = Lightning
    STA.W SpriteNumber,Y                      ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B SpriteXPosLow,X                     ; \ Lightning X position = Sprite X position + #$04
    ADC.B #$04                                ; |
    STA.W SpriteXPosLow,Y                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    ADC.B #$00                                ; |
    STA.W SpriteXPosHigh,Y                    ; /
    LDA.B SpriteYPosLow,X                     ; \ Lightning Y position = Sprite Y position
    STA.W SpriteYPosLow,Y                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    STA.W SpriteYPosHigh,Y                    ; /
    PHX
    TYX                                       ; \ Reset sprite tables
    JSL InitSpriteTables                      ; /
    LDA.B #$10                                ; \ $1FE2,x = #$10
    STA.W SpriteMisc1FE2,X                    ; / Time to not interact with ground??
    PLX
  + RTS


SumoBrosDispX:
    db $FF,$07,$FC,$04,$FF,$07,$FC,$04
    db $FF,$FF,$FC,$04,$FF,$FF,$FC,$04
    db $02,$02,$F4,$04,$02,$02,$F4,$04
    db $09,$01,$04,$FC,$09,$01,$04,$FC
    db $01,$01,$04,$FC,$01,$01,$04,$FC
    db $FF,$FF,$0C,$FC,$FF,$FF,$0C,$FC
SumoBrosDispY:
    db $F8,$F8,$00,$00,$F8,$F8,$00,$00
    db $F8,$F0,$00,$00,$F8,$F8,$00,$00
    db $F8,$F8,$01,$00,$F8,$F8,$FF,$00
SumoBrosTiles:
    db $98,$99,$A7,$A8,$98,$99,$AA,$AB
    db $8A,$66,$AA,$AB,$EE,$EE,$C5,$C6
    db $80,$80,$C1,$C3,$80,$80,$C1,$C3
SumoBrosTileSize:
    db $00,$00,$02,$02,$00,$00,$02,$02
    db $02,$02,$02,$02,$02,$02,$02,$02
    db $02,$02,$02,$02,$02,$02,$02,$02

SumoBroGfx:
    JSR GetDrawInfo2
    LDA.W SpriteMisc157C,X
    LSR A
    ROR A
    ROR A
    AND.B #$40
    EOR.B #$40
    STA.B _2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc1602,X
    ASL A
    ASL A
    PHX
    TAX
    LDA.B #$03
    STA.B _5
CODE_02DE5B:
    PHX
    LDA.B _2
    BEQ +
    TXA
    CLC
    ADC.B #$18
    TAX
  + LDA.B _0
    CLC
    ADC.W SumoBrosDispX,X
    STA.W OAMTileXPos+$100,Y
    PLX
    LDA.B _1
    CLC
    ADC.W SumoBrosDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W SumoBrosTiles,X
    STA.W OAMTileNo+$100,Y
    CMP.B #$66
    SEC
    BNE +
    CLC
  + LDA.B #$34
    ADC.B _2
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W SumoBrosTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    INX
    DEC.B _5
    BPL CODE_02DE5B
    PLX
    LDY.B #$FF
    LDA.B #$03
    JMP CODE_02B7A7

SumosLightningMain:
    PHB
    PHK
    PLB
    JSR CODE_02DEB0
    PLB
    RTL

CODE_02DEB0:
    LDA.W SpriteMisc1540,X
    BNE CODE_02DEFC
    LDA.B #$30
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty
    LDA.W SpriteMisc1FE2,X
    BNE +
    JSL CODE_019138
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    LDA.B #!SFX_FIRESPIT                      ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$22
    STA.W SpriteMisc1540,X
    LDA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    BNE +
    LDA.B SpriteXPosLow,X
    STA.B TouchBlockXPos
    LDA.B SpriteYPosLow,X
    STA.B TouchBlockYPos
    JSL CODE_028A44
  + LDA.B #$00
    JSL GenericSprGfxRt0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileAttr+$104,Y
    EOR.B #$C0
    STA.W OAMTileAttr+$104,Y
    RTS

CODE_02DEFC:
    STA.B _2
    CMP.B #$01
    BNE +
    STZ.W SpriteStatus,X
  + AND.B #$0F
    CMP.B #$01
    BNE +
    STA.W ActivateClusterSprite
    JSR CODE_02DF2C
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    CMP.B #$01
    BEQ +
    JSR CODE_02DF2C
    INC.W SpriteMisc1570,X
  + RTS


DATA_02DF22:
    db $FC,$0C,$EC,$1C,$DC

DATA_02DF27:
    db $FF,$00,$FF,$00,$FF

CODE_02DF2C:
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    LDY.B #$09
CODE_02DF37:
    LDA.W ClusterSpriteNumber,Y
    BEQ CODE_02DF4C
    DEY
    BPL CODE_02DF37
    DEC.W SumoClustOverwrite
    BPL +
    LDA.B #$09
    STA.W SumoClustOverwrite
  + LDY.W SumoClustOverwrite
CODE_02DF4C:
    PHX
    LDA.W SpriteMisc1570,X
    TAX
    LDA.B _0
    CLC
    ADC.W DATA_02DF22,X
    STA.W ClusterSpriteXPosLow,Y
    LDA.B _1
    ADC.W DATA_02DF27,X
    STA.W ClusterSpriteXPosHigh,Y
    PLX
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$10
    STA.W ClusterSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    SEC
    SBC.B #$00
    STA.W ClusterSpriteYPosHigh,Y
    LDA.B #$7F
    STA.W ClusterSpriteMisc0F4A,Y
    LDA.W ClusterSpriteXPosLow,Y
    CMP.B Layer1XPos
    LDA.W ClusterSpriteXPosHigh,Y
    SBC.B Layer1XPos+1
    BNE +
    LDA.B #$06
    STA.W ClusterSpriteNumber,Y
  + RTS

VolcanoLotusMain:
    PHB
    PHK
    PLB
    JSR CODE_02DF93
    PLB
    RTL

CODE_02DF93:
    JSR VolcanoLotusGfx
    LDA.B SpriteLock
    BNE Return02DFC8
    STZ.W SpriteMisc151C,X
    JSL SprSpr_MarioSprRts
    JSR SubOffscreen0Bnk2
    JSR UpdateYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +
    INC.B SpriteYSpeed,X
  + JSL CODE_019138
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02DFC9
    dw CODE_02DFDF
    dw CODE_02DFEF

Return02DFC8:
    RTS

CODE_02DFC9:
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B #$40
CODE_02DFD0:
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
    RTS

  + LSR A
    LSR A
    LSR A
    AND.B #$01
    STA.W SpriteMisc1602,X
    RTS

CODE_02DFDF:
    LDA.W SpriteMisc1540,X
    BNE CODE_02DFE8
    LDA.B #$40
    BRA CODE_02DFD0

CODE_02DFE8:
    LSR A
    AND.B #$01
    STA.W SpriteMisc151C,X
    RTS

CODE_02DFEF:
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B #$80
    JSR CODE_02DFD0
    STZ.B SpriteTableC2,X
  + CMP.B #$38
    BNE +
    JSR CODE_02E079
  + LDA.B #$02
    STA.W SpriteMisc1602,X
    RTS


VolcanoLotusTiles:
    db $8E,$9E,$E2

VolcanoLotusGfx:
    JSR MushroomScaleGfx
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$CE
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$104,Y
    LDA.W OAMTileAttr+$100,Y
    AND.B #$30
    ORA.B #$0B
    STA.W OAMTileAttr+$100,Y
    ORA.B #$40
    STA.W OAMTileAttr+$104,Y
    LDA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$108,Y
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$10C,Y
    LDA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$108,Y
    STA.W OAMTileYPos+$10C,Y
    PHX
    LDA.W SpriteMisc1602,X
    TAX
    LDA.W VolcanoLotusTiles,X
    STA.W OAMTileNo+$108,Y
    INC A
    STA.W OAMTileNo+$10C,Y
    PLX
    LDA.W SpriteMisc151C,X
    CMP.B #$01
    LDA.B #$39
    BCC +
    LDA.B #$35
  + STA.W OAMTileAttr+$108,Y
    STA.W OAMTileAttr+$10C,Y
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$08
    STA.W SpriteOAMIndex,X
    LDY.B #$00
    LDA.B #$01
    JMP CODE_02B7A7


DATA_02E071:
    db $10,$F0,$06,$FA

DATA_02E075:
    db $EC,$EC,$E8,$E8

CODE_02E079:
    LDA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    BNE Return02E0C4
    LDA.B #$03
    STA.B _0
CODE_02E085:
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_02E087:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_02E090                           ; |
    DEY                                       ; |
    BPL CODE_02E087                           ; |
    RTS                                       ; / Return if no free slots

CODE_02E090:
    LDA.B #$0C                                ; \ Extended sprite = Volcano Lotus fire
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W ExtSpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W ExtSpriteYPosHigh,Y
    PHX
    LDX.B _0
    LDA.W DATA_02E071,X
    STA.W ExtSpriteXSpeed,Y
    LDA.W DATA_02E075,X
    STA.W ExtSpriteYSpeed,Y
    PLX
    DEC.B _0
    BPL CODE_02E085
Return02E0C4:
    RTS

JumpingPiranhaMain:
    PHB
    PHK
    PLB
    JSR CODE_02E0CD
    PLB
    RTL

CODE_02E0CD:
    JSL LoadSpriteTables
    LDA.B SpriteProperties
    PHA
    LDA.B #$10
    STA.B SpriteProperties
    LDA.W SpriteMisc1570,X
    AND.B #$08
    LSR A
    LSR A
    EOR.B #$02
    STA.W SpriteMisc1602,X
    JSL GenericSprGfxRt2
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    LDA.W SpriteMisc151C,X
    AND.B #$04
    LSR A
    LSR A
    INC A
    STA.W SpriteMisc1602,X
    LDA.B SpriteYPosLow,X
    PHA
    CLC
    ADC.B #$08
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B #$0A
    STA.W SpriteOBJAttribute,X
    LDA.B #$01
    JSL GenericSprGfxRt0
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    PLA
    STA.B SpriteProperties
    LDA.B SpriteLock
    BNE +
    JSR SubOffscreen0Bnk2
    JSL SprSpr_MarioSprRts
    JSR UpdateYPosNoGrvty
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02E13C
    dw CODE_02E159
    dw CODE_02E177

CODE_02E13C:
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.W SpriteMisc1540,X
    BNE +
    JSR CODE_02D4FA
    LDA.B _F
    CLC
    ADC.B #$1B
    CMP.B #$37
    BCC +
    LDA.B #$C0
    STA.B SpriteYSpeed,X
    INC.B SpriteTableC2,X
    STZ.W SpriteMisc1602,X
  + RTS

CODE_02E159:
    LDA.B SpriteYSpeed,X
    BMI CODE_02E161
    CMP.B #$40
    BCS +
CODE_02E161:
    CLC
    ADC.B #$02
    STA.B SpriteYSpeed,X
  + INC.W SpriteMisc1570,X
    LDA.B SpriteYSpeed,X
    CMP.B #$F0
    BMI Return02E176
    LDA.B #$50
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
Return02E176:
    RTS

CODE_02E177:
    INC.W SpriteMisc151C,X
    LDA.W SpriteMisc1540,X
    BNE CODE_02E1A4
CODE_02E17F:
    INC.W SpriteMisc1570,X
    LDA.B EffFrame
    AND.B #$03
    BNE +
    LDA.B SpriteYSpeed,X
    CMP.B #$08
    BPL +
    INC A
    STA.B SpriteYSpeed,X
  + JSL CODE_019138
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ Return02E176                          ; /
    STZ.B SpriteTableC2,X
    LDA.B #$40
    STA.W SpriteMisc1540,X
    RTS

CODE_02E1A4:
    LDY.B SpriteNumber,X
    CPY.B #$50
    BNE CODE_02E1F7
    STZ.W SpriteMisc1570,X
    CMP.B #$40
    BNE CODE_02E1F7
    LDA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    BNE CODE_02E1F7
    LDA.B #$10
    JSR CODE_02E1C0
    LDA.B #$F0
CODE_02E1C0:
    STA.B _0
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_02E1C4:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_02E1CD                           ; |
    DEY                                       ; |
    BPL CODE_02E1C4                           ; |
    RTS                                       ; / Return if no free slots

CODE_02E1CD:
    LDA.B #$0B                                ; \ Extended sprite = Piranha fireball
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W ExtSpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W ExtSpriteYPosHigh,Y
    LDA.B #$D0
    STA.W ExtSpriteYSpeed,Y
    LDA.B _0
    STA.W ExtSpriteXSpeed,Y
CODE_02E1F7:
    BRA CODE_02E17F


DATA_02E1F9:
    db $00,$00,$F0,$10

DATA_02E1FD:
    db $F0,$10,$00,$00

DATA_02E201:
    db $00,$03,$02,$00,$01,$03,$02,$00
    db $00,$03,$02,$00,$00,$00,$00,$00
DATA_02E211:
    db $01,$00,$03,$02

DirectionCoinsMain:
    PHB
    PHK
    PLB
    JSR CODE_02E21D
    PLB
    RTL

CODE_02E21D:
    LDA.B SpriteProperties
    PHA
    LDA.W SpriteMisc1540,X
    CMP.B #$30
    BCC +
    LDA.B #$10
    STA.B SpriteProperties
  + LDA.B Layer1YPos
    PHA
    CLC
    ADC.B #$01
    STA.B Layer1YPos
    LDA.B Layer1YPos+1
    PHA
    ADC.B #$00
    STA.B Layer1YPos+1
    LDA.W BluePSwitchTimer
    BNE CODE_02E245
    JSL CoinSprGfx
    BRA +

CODE_02E245:
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$2E
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$100,Y
    AND.B #$3F
    STA.W OAMTileAttr+$100,Y
  + PLA
    STA.B Layer1YPos+1
    PLA
    STA.B Layer1YPos
    PLA
    STA.B SpriteProperties
    LDA.B SpriteLock
    BNE CODE_02E2DE
    LDA.B TrueFrame
    AND.B #$03
    BNE CODE_02E288
    DEC.W DirectCoinTimer
    BNE CODE_02E288
CODE_02E271:
    STZ.W DirectCoinTimer
    STZ.W SpriteStatus,X
    LDA.W BluePSwitchTimer
    ORA.W SilverPSwitchTimer
    BNE +
    LDA.W MusicBackup
    BMI +
    STA.W SPCIO2                              ; / Change music
  + RTS

CODE_02E288:
    LDY.B SpriteTableC2,X
    LDA.W DATA_02E1F9,Y
    STA.B SpriteXSpeed,X
    LDA.W DATA_02E1FD,Y
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty
    JSR UpdateXPosNoGrvty
    LDA.B byetudlrHold
    AND.B #$0F
    BEQ +
    TAY
    LDA.W DATA_02E201,Y
    TAY
    LDA.W DATA_02E211,Y
    CMP.B SpriteTableC2,X
    BEQ +
    TYA
    STA.W SpriteMisc151C,X
  + LDA.B SpriteYPosLow,X
    AND.B #$0F
    STA.B _0
    LDA.B SpriteXPosLow,X
    AND.B #$0F
    ORA.B _0
    BNE CODE_02E2DE
    LDA.W SpriteMisc151C,X
    STA.B SpriteTableC2,X
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position
    STA.B TouchBlockXPos                      ; | for block creation
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ $98 = Sprite Y position
    STA.B TouchBlockYPos                      ; | for block creation
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B TouchBlockYPos+1                    ; /
    LDA.B #$06                                ; \ Block to generate = Coin
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile
    RTS

CODE_02E2DE:
    JSL CODE_019138
    LDA.B SpriteXSpeed,X
    BNE CODE_02E2F3
    LDA.W SprMap16TouchVertHigh
    BNE CODE_02E2FF
    LDA.W SprMap16TouchVertLow
    CMP.B #$25
    BNE CODE_02E2FF
    RTS

CODE_02E2F3:
    LDA.W SprMap16TouchHorizHigh
    BNE CODE_02E2FF
    LDA.W SprMap16TouchHorizLow
    CMP.B #$25
    BEQ +
CODE_02E2FF:
    JSR CODE_02E271
  + RTS

GasBubbleMain:
    PHB
    PHK
    PLB
    JSR CODE_02E311
    PLB
    RTL


DATA_02E30B:
    db $10,$F0

DATA_02E30D:
    db $01,$FF

DATA_02E30F:
    db $10,$F0

CODE_02E311:
    JSR GasBubbleGfx
    LDA.B SpriteLock
    BNE Return02E351
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return02E351
    LDY.W SpriteMisc157C,X
    LDA.W DATA_02E30B,Y
    STA.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty
    LDA.B TrueFrame
    AND.B #$03
    BNE +
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W DATA_02E30D,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_02E30F,Y
    BNE +
    INC.B SpriteTableC2,X
  + JSR UpdateYPosNoGrvty
    INC.W SpriteMisc1570,X
    JSR SubOffscreen0Bnk2
    JSL MarioSprInteract
Return02E351:
    RTS


DATA_02E352:
    db $00,$10,$20,$30,$00,$10,$20,$30
    db $00,$10,$20,$30,$00,$10,$20,$30
DATA_02E362:
    db $00,$00,$00,$00,$10,$10,$10,$10
    db $20,$20,$20,$20,$30,$30,$30,$30
DATA_02E372:
    db $80,$82,$84,$86,$A0,$A2,$A4,$A6
    db $A0,$A2,$A4,$A6,$80,$82,$84,$86
DATA_02E382:
    db $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B
    db $BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB
DATA_02E392:
    db $00,$00,$02,$02,$00,$00,$02,$02
    db $01,$01,$03,$03,$01,$01,$03,$03
DATA_02E3A2:
    db $00,$01,$02,$01

DATA_02E3A6:
    db $02,$01,$00,$01

GasBubbleGfx:
    JSR GetDrawInfo2
    LDA.W SpriteMisc1570,X
    LSR A
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W DATA_02E3A2,Y
    STA.B _2
    LDA.W DATA_02E3A6,Y
    STA.B _3
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    LDX.B #$0F
CODE_02E3C6:
    LDA.B _0
    CLC
    ADC.W DATA_02E352,X
    PHA
    LDA.W DATA_02E392,X
    AND.B #$02
    BNE CODE_02E3DA
    PLA
    CLC
    ADC.B _2
    BRA +

CODE_02E3DA:
    PLA
    SEC
    SBC.B _2
  + STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_02E362,X
    PHA
    LDA.W DATA_02E392,X
    AND.B #$01
    BNE CODE_02E3F5
    PLA
    CLC
    ADC.B _3
    BRA +

CODE_02E3F5:
    PLA
    SEC
    SBC.B _3
  + STA.W OAMTileYPos+$100,Y
    LDA.W DATA_02E372,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02E382,X
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_02E3C6
    PLX
    LDY.B #$02
    LDA.B #$0F
    JMP CODE_02B7A7

ExplodingBlkMain:
    PHB
    PHK
    PLB
    JSR CODE_02E41F
    PLB
    RTL

CODE_02E41F:
    JSL GenericSprGfxRt2
    LDA.B SpriteLock
    BNE Return02E462
    BRA +

    JSL ADDR_02C0CF                           ; Unreachable instruction
  + LDY.B #$00
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    AND.B #$40
    BEQ +
    LDY.B #$04
    LDA.W SpriteMisc1570,X
    AND.B #$04
    BEQ +
    LDY.B #$FC
  + STY.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty
    JSL SprSpr_MarioSprRts
    JSR CODE_02D4FA
    LDA.B _F
    CLC
    ADC.B #$60
    CMP.B #$C0
    BCS Return02E462
    LDY.W SpriteOffscreenX,X
    BNE Return02E462
    JSL CODE_02E463
Return02E462:
    RTS

CODE_02E463:
    LDA.B SpriteTableC2,X
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    LDA.B #$D0
    STA.B SpriteYSpeed,X
    JSR CODE_02D4FA
    TYA
    STA.W SpriteMisc157C,X
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
    LDA.B #$00
    JSL ShatterBlock
    PLB
    RTL

ScalePlatformMain:
    LDA.W SpriteOAMIndex,X
    PHA
    PHB
    PHK
    PLB
    JSR CODE_02E4A5
    PLB
    PLA
    STA.W SpriteOAMIndex,X
    RTL

CODE_02E4A5:
    JSR SubOffscreen2Bnk2
    STZ.W TileGenerateTrackA
    LDA.B SpriteXPosLow,X
    PHA
    LDA.W SpriteXPosHigh,X
    PHA
    LDA.B SpriteYPosLow,X
    PHA
    LDA.W SpriteYPosHigh,X
    PHA
    LDA.W SpriteMisc151C,X
    STA.W SpriteYPosHigh,X
    LDA.W SpriteMisc1534,X
    STA.B SpriteYPosLow,X
    LDA.B SpriteTableC2,X
    STA.B SpriteXPosLow,X
    LDA.W SpriteMisc1602,X
    STA.W SpriteXPosHigh,X
    LDY.B #$02
    JSR CODE_02E524
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    PLA
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X
    BCC +
    INC.W TileGenerateTrackA
    LDA.B #$F8
    JSR CODE_02E559
  + LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$08
    STA.W SpriteOAMIndex,X
    LDY.B #$00
    JSR CODE_02E524
    BCC +
    INC.W TileGenerateTrackA
    LDA.B #$08
    JSR CODE_02E559
  + LDA.W TileGenerateTrackA
    BNE Return02E51F
    LDY.B #$02
    LDA.B SpriteYPosLow,X
    CMP.W SpriteMisc1534,X
    BEQ Return02E51F
    LDA.W SpriteYPosHigh,X
    SBC.W SpriteMisc151C,X
    BMI +
    LDY.B #$FE
  + TYA
    JSR CODE_02E559
Return02E51F:
    RTS


MushrmScaleTiles:
    db $02,$07,$07,$02

CODE_02E524:
    LDA.B SpriteYPosLow,X
    AND.B #$0F
    BNE CODE_02E54E
    LDA.B SpriteYSpeed,X
    BEQ CODE_02E54E
    LDA.B SpriteYSpeed,X
    BPL +
    INY
  + LDA.W MushrmScaleTiles,Y
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
CODE_02E54E:
    JSR MushroomScaleGfx
    STZ.W SpriteMisc1528,X
    JSL InvisBlkMainRt
    RTS

CODE_02E559:
    LDY.B SpriteLock
    BNE Return02E57D
    PHA
    JSR UpdateYPosNoGrvty
    PLA
    STA.B SpriteYSpeed,X
    LDY.B #$00
    LDA.W SpriteXMovement
    EOR.B #$FF
    INC A
    BPL +
    DEY
  + CLC
    ADC.W SpriteMisc1534,X
    STA.W SpriteMisc1534,X
    TYA
    ADC.W SpriteMisc151C,X
    STA.W SpriteMisc151C,X
Return02E57D:
    RTS

MushroomScaleGfx:
    JSR GetDrawInfo2
    LDA.B _0
    SEC
    SBC.B #$08
    STA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    DEC A
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    LDA.B #$80
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$104,Y
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    ORA.B #$40
    STA.W OAMTileAttr+$104,Y
    LDA.B #$01
    LDY.B #$02
    JMP CODE_02B7A7

MovingLedgeMain:
    PHB
    PHK
    PLB
    JSR CODE_02E5BC
    PLB
    RTL

CODE_02E5BC:
    JSR SubOffscreen0Bnk2
    LDA.B SpriteLock
    BNE CODE_02E5D7
    INC.W SpriteMisc1570,X
    LDY.B #$10
    LDA.W SpriteMisc1570,X
    AND.B #$80
    BNE +
    LDY.B #$F0
  + TYA
    STA.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty
CODE_02E5D7:
    JSR CODE_02E637
    JSR CODE_02E5F7
    LDA.W PlayerDisableObjInt
    BEQ CODE_02E5E8
    DEC A
    CMP.W CurSpriteProcess
    BNE +
CODE_02E5E8:
    JSL MarioSprInteract
    STZ.W PlayerDisableObjInt
    BCC +
    INX
    STX.W PlayerDisableObjInt
    DEX
  + RTS

CODE_02E5F7:
    LDY.B #$0B
CODE_02E5F9:
    CPY.W CurSpriteProcess
    BEQ CODE_02E633
    TYA
    EOR.B TrueFrame
    AND.B #$03
    BNE CODE_02E633
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BCC CODE_02E633
    LDA.W SpriteDisableObjInt,Y
    BEQ CODE_02E617
    DEC A
    CMP.W CurSpriteProcess
    BNE CODE_02E633
CODE_02E617:
    TYX
    JSL GetSpriteClippingB
    LDX.W CurSpriteProcess                    ; X = Sprite index
    JSL GetSpriteClippingA
    JSL CheckForContact
    LDA.B #$00
    STA.W SpriteDisableObjInt,Y
    BCC CODE_02E633
    TXA
    INC A
    STA.W SpriteDisableObjInt,Y
CODE_02E633:
    DEY
    BPL CODE_02E5F9
    RTS

CODE_02E637:
    JSR GetDrawInfo2
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC
    ADC.W DATA_02E666,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.W MovingHoleTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02E66E,X
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    LDA.B #$03
    LDY.B #$02
    JMP CODE_02B7A7


DATA_02E666:
    db $00,$08,$18,$20

MovingHoleTiles:
    db $EB,$EA,$EA,$EB

DATA_02E66E:
    db $71,$31,$31,$31

CODE_02E672:
    PHB                                       ; Wrapper
    PHK
    PLB
    JSR CODE_02E67A
    PLB
    RTL

CODE_02E67A:
    JSR GetDrawInfo2
    TYA
    CLC
    ADC.B #$08
    STA.W SpriteOAMIndex,X
    TAY
    LDA.B _0
    SEC
    SBC.B #$0D
    STA.W OAMTileXPos+$100,Y
    SEC
    SBC.B #$08
    STA.W TileGenerateTrackA
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    CLC
    ADC.B #$02
    STA.W OAMTileYPos+$100,Y
    STA.W TileGenerateTrackB
    CLC
    ADC.B #$40
    STA.W OAMTileYPos+$104,Y
    LDA.B #$AA
    STA.W OAMTileNo+$100,Y
    LDA.B #$24
    STA.W OAMTileNo+$104,Y
    LDA.B #$35
    STA.W OAMTileAttr+$100,Y
    LDA.B #$3A
    STA.W OAMTileAttr+$104,Y
    LDA.B #$01
    LDY.B #$02
    JSR CODE_02B7A7
    LDA.W SpriteOffscreenX,X
    BNE +
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B PlayerXPosScrRel
    SEC
    SBC.W OAMTileXPos+$104,Y
    CLC
    ADC.B #$0C
    CMP.B #$18
    BCS +
    LDA.B PlayerYPosScrRel
    SEC
    SBC.W OAMTileYPos+$104,Y
    CLC
    ADC.B #$0C
    CMP.B #$18
    BCS +
    STZ.W SpriteMisc151C,X
    JSL CODE_00F388
  + PHX
    LDA.B #$38
    STA.W SpriteOAMIndex,X
    TAY
    LDX.B #$07
  - LDA.W TileGenerateTrackA
    STA.W OAMTileXPos+$100,Y
    LDA.W TileGenerateTrackB
    STA.W OAMTileYPos+$100,Y
    CLC
    ADC.B #$08
    STA.W TileGenerateTrackB
    LDA.B #$89
    STA.W OAMTileNo+$100,Y
    LDA.B #$35
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    LDA.B #$07
    LDY.B #$00
    JMP CODE_02B7A7

SwimJumpFishMain:
    PHB
    PHK
    PLB
    JSR CODE_02E727
    PLB
    RTL

CODE_02E727:
    JSL GenericSprGfxRt2
    LDA.B SpriteLock
    BNE +
    JSR SubOffscreen0Bnk2
    JSL SprSpr_MarioSprRts
    JSL CODE_019138
    LDY.B #$00
    JSR CODE_02EB3D
    LDA.B SpriteTableC2,X
    AND.B #$01
    JSL ExecutePtr

    dw CODE_02E74E
    dw CODE_02E788

  + RTS


DATA_02E74C:
    db $14,$EC

CODE_02E74E:
    LDY.W SpriteMisc157C,X
    LDA.W DATA_02E74C,Y
    STA.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty
    LDA.W SpriteMisc1540,X
    BNE Return02E77B
    INC.W SpriteMisc1570,X
    LDY.W SpriteMisc1570,X
    CPY.B #$04
    BEQ CODE_02E77C
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
    LDA.B #$20
    CPY.B #$03
    BEQ +
    LDA.B #$40
  + STA.W SpriteMisc1540,X
Return02E77B:
    RTS

CODE_02E77C:
    INC.B SpriteTableC2,X
    LDA.B #$80
    STA.W SpriteMisc1540,X
    LDA.B #$A0
    STA.B SpriteYSpeed,X
    RTS

CODE_02E788:
    LDA.W SpriteMisc1540,X
    BEQ CODE_02E7A4
    CMP.B #$70
    BCS Return02E7A3
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    JSR UpdateYPosNoGrvty
    LDA.B SpriteYSpeed,X
    BMI CODE_02E79E
    CMP.B #$30
    BCS Return02E7A3
CODE_02E79E:
    CLC
    ADC.B #$02
    STA.B SpriteYSpeed,X
Return02E7A3:
    RTS

CODE_02E7A4:
    LDA.B SpriteYPosLow,X
    AND.B #$F0
    STA.B SpriteYPosLow,X
    INC.B SpriteTableC2,X
    STZ.W SpriteMisc1570,X
    LDA.B #$20
    STA.W SpriteMisc1540,X
    RTS

ChucksRockMain:
    PHB
    PHK
    PLB
    JSR CODE_02E7BD
    PLB
    RTL

CODE_02E7BD:
    LDA.B SpriteProperties
    PHA
    LDA.W SpriteMisc1540,X
    BEQ +
    LDA.B #$10
    STA.B SpriteProperties
  + JSL GenericSprGfxRt2
    PLA
    STA.B SpriteProperties
    LDA.B SpriteLock
    BNE Return02E82C
    LDA.W SpriteMisc1540,X
    CMP.B #$08
    BCS Return02E82C
    LDY.B #$00
    LDA.B TrueFrame
    LSR A
    JSR CODE_02EB3D
    JSR SubOffscreen0Bnk2
    JSL UpdateSpritePos
    LDA.W SpriteMisc1540,X
    BNE CODE_02E828
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    LDA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.B SpriteXSpeed,X
  + LDA.W SpriteBlockedDirs,X
    AND.B #$08
    BEQ +
    LDA.B #$10
    STA.B SpriteYSpeed,X
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ CODE_02E828                           ; /
    LDA.B SpriteYSpeed,X
    CMP.B #$38
    LDA.B #$E0
    BCC +
    LDA.B #$D0
  + STA.B SpriteYSpeed,X
    LDA.B #$08
    LDY.W SpriteSlope,X
    BEQ CODE_02E828
    BPL +
    LDA.B #$F8
  + STA.B SpriteXSpeed,X
CODE_02E828:
    JSL SprSpr_MarioSprRts
Return02E82C:
    RTS

GrowingPipeMain:
    PHB
    PHK
    PLB
    JSR CODE_02E845
    PLB
    RTL


DATA_02E835:
    db $00,$F0,$00,$10

DATA_02E839:
    db $20,$40,$20,$40

GrowingPipeTiles1:
    db $00,$14,$00,$02

GrowingPipeTiles2:
    db $00,$15,$00,$02

CODE_02E845:
    LDA.W SpriteMisc1534,X
    BMI +
    LDA.B SpriteYPosLow,X
    PHA
    SEC
    SBC.W SpriteMisc1534,X
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    LDY.B #$03
    JSR GrowingPipeGfx
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    LDA.W SpriteMisc1534,X
    SEC
    SBC.B #$10
    STA.W SpriteMisc1534,X
    RTS

  + JSR CODE_02E902
    JSR SubOffscreen0Bnk2
    LDA.B SpriteLock
    ORA.W SpriteOffscreenX,X
    BNE CODE_02E8B5
    JSR CODE_02D4FA
    LDA.B _F
    CLC
    ADC.B #$50
    CMP.B #$A0
    BCS CODE_02E8B5
    LDA.B SpriteTableC2,X
    AND.B #$03
    TAY
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    CMP.W DATA_02E839,Y
    BNE CODE_02E8A2
    STZ.W SpriteMisc1570,X
    INC.B SpriteTableC2,X
    BRA CODE_02E8B5

CODE_02E8A2:
    LDA.W DATA_02E835,Y
    STA.B SpriteYSpeed,X
    BEQ +
    LDA.B SpriteYPosLow,X
    AND.B #$0F
    BNE +
    JSR GrowingPipeGfx
  + JSR UpdateYPosNoGrvty
CODE_02E8B5:
    JSL InvisBlkMainRt
    RTS

GrowingPipeGfx:
    LDA.W GrowingPipeTiles1,Y
    STA.W TileGenerateTrackA
    LDA.W GrowingPipeTiles2,Y
    STA.W TileGenerateTrackB
    LDA.W TileGenerateTrackA
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
    LDA.W TileGenerateTrackB
    STA.B Map16TileGenerate                   ; $9C = tile to generate
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position + #$10
    CLC                                       ; | for block creation
    ADC.B #$10                                ; |
    STA.B TouchBlockXPos                      ; |
    LDA.W SpriteXPosHigh,X                    ; |
    ADC.B #$00                                ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ $98 = Sprite Y position
    STA.B TouchBlockYPos                      ; | for block creation
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B TouchBlockYPos+1                    ; /
    JSL GenerateTile                          ; Generate the tile
    RTS

CODE_02E902:
    JSR GetDrawInfo2
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    DEC A
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    LDA.B #$A4
    STA.W OAMTileNo+$100,Y
    LDA.B #$A6
    STA.W OAMTileNo+$104,Y
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
CODE_02E92E:
    LDA.B #$01
    LDY.B #$02
    JMP CODE_02B7A7

PipeLakituMain:
    PHB
    PHK
    PLB
    JSR CODE_02E93D
    PLB
    RTL

CODE_02E93D:
    LDA.W SpriteStatus,X
    CMP.B #$02
    BNE +
    LDA.B #$02
    STA.W SpriteMisc1602,X
    JMP CODE_02E9EC

  + JSR CODE_02E9EC
    LDA.B SpriteLock
    BNE +
    STZ.W SpriteMisc1602,X
    JSR SubOffscreen0Bnk2
    JSL SprSpr_MarioSprRts
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02E96D
    dw CODE_02E986
    dw CODE_02E9B4
    dw CODE_02E9BD
    dw CODE_02E9D5

CODE_02E96D:
    LDA.W SpriteMisc1540,X
    BNE +
    JSR CODE_02D4FA
    LDA.B _F
    CLC
    ADC.B #$13
    CMP.B #$36
    BCC +
    LDA.B #$90
CODE_02E980:
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + RTS

CODE_02E986:
    LDA.W SpriteMisc1540,X
    BNE CODE_02E996
    JSR CODE_02D4FA
    TYA
    STA.W SpriteMisc157C,X
    LDA.B #$0C
    BRA CODE_02E980

CODE_02E996:
    CMP.B #$7C
    BCC +
CODE_02E99A:
    LDA.B #$F8
CODE_02E99C:
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty
    RTS

  + CMP.B #$50
    BCS Return02E9B3
    LDY.B #$00
    LDA.B TrueFrame
    AND.B #$20
    BEQ +
    INY
  + TYA
    STA.W SpriteMisc157C,X
Return02E9B3:
    RTS

CODE_02E9B4:
    LDA.W SpriteMisc1540,X
    BNE CODE_02E99A
    LDA.B #$80
    BRA CODE_02E980

CODE_02E9BD:
    LDA.W SpriteMisc1540,X
    BNE CODE_02E9C6
    LDA.B #$20
    BRA CODE_02E980

CODE_02E9C6:
    CMP.B #$40
    BNE +
    JSL CODE_01EA19
    RTS

  + BCS +
    INC.W SpriteMisc1602,X
  + RTS

CODE_02E9D5:
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B #$50
    JSR CODE_02E980
    STZ.B SpriteTableC2,X
    RTS

  + LDA.B #$08
    BRA CODE_02E99C


PipeLakitu1:
    db $EC,$A8,$CE

PipeLakitu2:
    db $EE,$EE,$EE

CODE_02E9EC:
    JSR GetDrawInfo2
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    CLC
    ADC.B #$10
    STA.W OAMTileYPos+$104,Y
    PHX
    LDA.W SpriteMisc1602,X
    TAX
    LDA.W PipeLakitu1,X
    STA.W OAMTileNo+$100,Y
    LDA.W PipeLakitu2,X
    STA.W OAMTileNo+$104,Y
    PLX
    LDA.W SpriteMisc157C,X
    LSR A
    ROR A
    LSR A
    EOR.B #$5B
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    JMP CODE_02E92E

CODE_02EA25:
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileNo+$100,Y
    STA.B _0
    STZ.B _1
    LDA.B #$06
    STA.W OAMTileNo+$100,Y
    REP #$20                                  ; A->16
    LDA.B _0
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.W #$8500
    STA.W DynGfxTilePtr+6
    CLC
    ADC.W #$0200
    STA.W DynGfxTilePtr+$10
    SEP #$20                                  ; A->8
    RTL

CODE_02EA4E:
    LDY.B #$0B
CODE_02EA50:
    TYA
    CMP.W SpriteMisc160E,X
    BEQ CODE_02EA86
    EOR.B TrueFrame
    LSR A
    BCS CODE_02EA86
    CPY.W CurSpriteProcess
    BEQ CODE_02EA86
    STY.W SpriteInterIndex
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BCC CODE_02EA86
    LDA.W SpriteNumber,Y
    CMP.B #$70
    BEQ CODE_02EA86
    CMP.B #$0E
    BEQ CODE_02EA86
    CMP.B #$1D
    BCC CODE_02EA83
    LDA.W SpriteTweakerE,Y
    AND.B #$03
    ORA.W YoshiGrowingTimer
    BNE CODE_02EA86
CODE_02EA83:
    JSR CODE_02EA8A
CODE_02EA86:
    DEY
    BPL CODE_02EA50
    RTL

CODE_02EA8A:
    PHX
    TYX
    JSL GetSpriteClippingB
    PLX
    JSL GetSpriteClippingA
    JSL CheckForContact
    BCC Return02EACD
    LDA.W SpriteMisc163E,X
    BEQ CODE_02EAA9
    JSL CODE_03C023
    LDA.W YoshiGrowingTimer
    BNE ADDR_02EACE
CODE_02EAA9:
    LDA.B #$37
    STA.W SpriteMisc163E,X
    LDY.W SpriteInterIndex
    STA.W SpriteBehindScene,Y
    LDA.W SpriteInterIndex
    STA.W SpriteMisc160E,X
    STZ.W SpriteMisc157C,X
    LDA.B SpriteXPosLow,X
    CMP.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    SBC.W SpriteXPosHigh,Y
    BCC Return02EACD
    INC.W SpriteMisc157C,X
Return02EACD:
    RTS

ADDR_02EACE:
    STZ.W SpriteMisc163E,X
    RTS

WarpBlocksMain:
    PHB
    PHK
    PLB
    JSR CODE_02EADA
    PLB
    RTL

CODE_02EADA:
    JSL MarioSprInteract
    BCC +
    STZ.B PlayerXSpeed+1
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$0A
    STA.B PlayerXPosNext
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.B PlayerXPosNext+1
  + RTS

    RTS

CODE_02EAF2:
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BMI +                                     ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$77
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    TYX
    JSL InitSpriteTables
    LDA.B #$30
    STA.W SpriteMisc154C,X
    LDA.B #$D0
    STA.B SpriteYSpeed,X
  + RTL

SuperKoopaMain:
    PHB
    PHK
    PLB
    JSR CODE_02EB31
    PLB
    RTL


DATA_02EB2F:
    db $18,$E8

CODE_02EB31:
    JSR CODE_02ECDE
    LDA.W SpriteStatus,X
    CMP.B #$02
    BNE CODE_02EB49
    LDY.B #$04
CODE_02EB3D:
    LDA.B EffFrame
    AND.B #$04
    BEQ +
    INY
  + TYA
    STA.W SpriteMisc1602,X
    RTS

CODE_02EB49:
    LDA.B SpriteLock
    BNE Return02EB7C
    JSR SubOffscreen0Bnk2
    JSL SprSpr_MarioSprRts
    JSR UpdateXPosNoGrvty
    JSR UpdateYPosNoGrvty
    LDA.B SpriteNumber,X
    CMP.B #$73
    BEQ CODE_02EB7D
    LDY.W SpriteMisc157C,X
    LDA.W DATA_02EB2F,Y
    STA.B SpriteXSpeed,X
    JSR CODE_02EBF8
    LDA.B TrueFrame
    AND.B #$01
    BNE Return02EB7C
    LDA.B SpriteYSpeed,X
    CMP.B #$F0
    BMI Return02EB7C
    CLC
    ADC.B #$FF
    STA.B SpriteYSpeed,X
Return02EB7C:
    RTS

CODE_02EB7D:
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02EB8D
    dw CODE_02EBD1
    dw CODE_02EBE7

DATA_02EB89:
    db $18,$E8

DATA_02EB8B:
    db $01,$FF

CODE_02EB8D:
    LDA.B TrueFrame
    AND.B #$00
    STA.B _1
    STZ.B _0
    LDY.W SpriteMisc157C,X
    LDA.B SpriteXSpeed,X
    CMP.W DATA_02EB89,Y
    BEQ CODE_02EBAB
    CLC
    ADC.W DATA_02EB8B,Y
    LDY.B _1
    BNE +
    STA.B SpriteXSpeed,X
  + INC.B _0
CODE_02EBAB:
    INC.W SpriteMisc151C,X
    LDA.W SpriteMisc151C,X
    CMP.B #$30
    BEQ CODE_02EBCA
CODE_02EBB5:
    LDY.B #$00
    LDA.B TrueFrame
    AND.B #$04
    BEQ +
    INY
  + TYA
    LDY.B _0
    BNE +
    CLC
    ADC.B #$06
  + STA.W SpriteMisc1602,X
    RTS

CODE_02EBCA:
    INC.B SpriteTableC2,X
    LDA.B #$D0
    STA.B SpriteYSpeed,X
    RTS

CODE_02EBD1:
    LDA.B SpriteYSpeed,X
    CLC
    ADC.B #$02
    STA.B SpriteYSpeed,X
    CMP.B #$14
    BMI +
    INC.B SpriteTableC2,X
  + STZ.B _0
    JSR CODE_02EBB5
    INC.W SpriteMisc1602,X
    RTS

CODE_02EBE7:
    LDY.W SpriteMisc157C,X
    LDA.W DATA_02EB89,Y
    STA.B SpriteXSpeed,X
    LDA.B SpriteYSpeed,X
    BEQ CODE_02EBF8
    CLC
    ADC.B #$FF
    STA.B SpriteYSpeed,X
CODE_02EBF8:
    LDY.B #$02
    LDA.B TrueFrame
    AND.B #$04
    BEQ +
    INY
  + TYA
    STA.W SpriteMisc1602,X
    RTS


DATA_02EC06:
    db $08,$08,$10,$00,$08,$08,$10,$00
    db $08,$10,$10,$00,$08,$10,$10,$00
    db $09,$09,$00,$00,$09,$09,$00,$00
    db $08,$10,$00,$00,$08,$10,$00,$00
    db $08,$10,$00,$00,$00,$00,$F8,$00
    db $00,$00,$F8,$00,$00,$F8,$F8,$00
    db $00,$F8,$F8,$00,$FF,$FF,$00,$00
    db $FF,$FF,$00,$00,$00,$F8,$00,$00
    db $00,$F8,$00,$00,$00,$F8,$00,$00
DATA_02EC4E:
    db $00,$08,$08,$00,$00,$08,$08,$00
    db $03,$03,$08,$00,$03,$03,$08,$00
    db $FF,$07,$00,$00,$FF,$07,$00,$00
    db $FD,$FD,$00,$00,$FD,$FD,$00,$00
    db $FD,$FD,$00,$00

SuperKoopaTiles:
    db $C8,$D8,$D0,$E0,$C9,$D9,$C0,$E2
    db $E4,$E5,$F2,$E0,$F4,$F5,$F2,$E0
    db $DA,$CA,$E0,$CF,$DB,$CB,$E0,$CF
    db $E4,$E5,$E0,$CF,$F4,$F5,$E2,$CF
    db $E4,$E5,$E2,$CF

DATA_02EC96:
    db $03,$03,$03,$00,$03,$03,$03,$00
    db $03,$03,$01,$01,$03,$03,$01,$01
    db $83,$83,$80,$00,$83,$83,$80,$00
    db $03,$03,$00,$01,$03,$03,$00,$01
    db $03,$03,$00,$01

DATA_02ECBA:
    db $00,$00,$00,$02,$00,$00,$00,$02
    db $00,$00,$00,$02,$00,$00,$00,$02
    db $00,$00,$02,$00,$00,$00,$02,$00
    db $00,$00,$02,$00,$00,$00,$02,$00
    db $00,$00,$02,$00

CODE_02ECDE:
    JSR GetDrawInfo2
    LDA.W SpriteMisc157C,X
    STA.B _2
    LDA.W SpriteOBJAttribute,X
    AND.B #$0E
    STA.B _5
    LDA.W SpriteMisc1602,X
    ASL A
    ASL A
    STA.B _3
    PHX
    STZ.B _4
CODE_02ECF7:
    LDA.B _3
    CLC
    ADC.B _4
    TAX
    LDA.B _1
    CLC
    ADC.W DATA_02EC4E,X
    STA.W OAMTileYPos+$100,Y
    LDA.W SuperKoopaTiles,X
    STA.W OAMTileNo+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W DATA_02ECBA,X
    STA.W OAMTileSize+$40,Y
    PLY
    LDA.B _2
    LSR A
    LDA.W DATA_02EC96,X
    AND.B #$02
    BEQ CODE_02ED4D
    PHP
    PHX
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.W SpriteMisc1534,X
    BEQ CODE_02ED3B
    LDA.B EffFrame
    LSR A
    AND.B #$01
    PHY
    TAY
    LDA.W DATA_02ED39,Y
    PLY
    BRA +


DATA_02ED39:
    db $10,$0A

CODE_02ED3B:
    LDA.B SpriteNumber,X
    CMP.B #$72
    LDA.B #$08
    BCC +
    LSR A
  + PLX
    PLP
    ORA.W DATA_02EC96,X
    AND.B #$FD
    BRA +

CODE_02ED4D:
    LDA.W DATA_02EC96,X
    ORA.B _5
  + ORA.B SpriteProperties
    BCS +
    PHA
    TXA
    CLC
    ADC.B #$24
    TAX
    PLA
    ORA.B #$40
  + STA.W OAMTileAttr+$100,Y
    LDA.B _0
    CLC
    ADC.W DATA_02EC06,X
    STA.W OAMTileXPos+$100,Y
    INY
    INY
    INY
    INY
    INC.B _4
    LDA.B _4
    CMP.B #$04
    BNE CODE_02ECF7
    PLX
    LDY.B #$FF
    LDA.B #$03
    JMP CODE_02B7A7


DATA_02ED7F:
    db $10,$20,$30

FloatingSkullInit:
    PHB
    PHK
    PLB
    JSR CODE_02ED8A
    PLB
    RTL

CODE_02ED8A:
    STZ.W SkullRaftSpeed
    INC.B SpriteTableC2,X
    LDA.B #$02
    STA.B _0
CODE_02ED93:
    JSL FindFreeSprSlot                       ; \ Branch if no free slots
    BMI +                                     ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$61
    STA.W SpriteNumber,Y
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    LDX.B _0
    %LorW_X(LDA,DATA_02ED7F)
    LDX.W CurSpriteProcess                    ; X = Sprite index
    CLC
    ADC.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    PLX
  + DEC.B _0
    BPL CODE_02ED93
    RTS

FloatingSkullMain:
    PHB
    PHK
    PLB
    JSR CODE_02EDD8
    PLB
    RTL

CODE_02EDD8:
    LDA.B SpriteTableC2,X
    BEQ CODE_02EDF6                           ;IF SKULLS DIEING
    JSR SubOffscreen0Bnk2
    LDA.W SpriteStatus,X
    BNE CODE_02EDF6                           ;IF LIVING, DO BELOW
    LDY.B #$09
CODE_02EDE6:
    LDA.W SpriteNumber,Y
    CMP.B #$61                                ;SEARCH OUT OTHERS
    BNE +
    LDA.B #$00                                ;ERASE THEM TOO
    STA.W SpriteStatus,Y
  + DEY
    BPL CODE_02EDE6
Return02EDF5:
    RTS

CODE_02EDF6:
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    LSR A
    LDA.B #$E0
    BCC +
    LDA.B #$E2
  + STA.W OAMTileNo+$100,Y
    LDA.W OAMTileYPos+$100,Y
    CMP.B #$F0
    BCS +
    CLC
    ADC.B #$03
    STA.W OAMTileYPos+$100,Y
  + LDA.B SpriteLock
    BNE Return02EDF5
    STZ.B _0
    LDY.B #$09
CODE_02EE21:
    LDA.W SpriteStatus,Y
    BEQ +
    LDA.W SpriteNumber,Y
    CMP.B #$61
    BNE +
    LDA.W SpriteBlockedDirs,Y
    AND.B #$0F
    BEQ +
    STA.B _0
  + DEY
    BPL CODE_02EE21
    LDA.W SkullRaftSpeed
    STA.B SpriteXSpeed,X
    LDA.B SpriteYSpeed,X
    CMP.B #$20
    BMI +
    LDA.B #$20
    STA.B SpriteYSpeed,X
  + JSL UpdateSpritePos
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    LDA.B #$10
    STA.B SpriteYSpeed,X
  + JSL MarioSprInteract
    BCC Return02EEA8
    LDA.B PlayerYSpeed+1
    BMI Return02EEA8
    LDA.B #$0C
    STA.W SkullRaftSpeed
    LDA.W SpriteOAMIndex,X
    TAX
    INC.W OAMTileYPos+$100,X
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B #$01
    STA.W StandOnSolidSprite
    STZ.B PlayerInAir
    LDA.B #$1C
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$2C
  + STA.B _1
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B _1
    STA.B PlayerYPosNext
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.B PlayerYPosNext+1
    LDA.B PlayerBlockedDir
    AND.B #$01
    BNE Return02EEA8
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
Return02EEA8:
    RTS

CoinCloudMain:
    PHB
    PHK
    PLB
    JSR ADDR_02EEB5
    PLB
    RTL


DATA_02EEB1:
    db $01,$FF

DATA_02EEB3:
    db $10,$F0

ADDR_02EEB5:
    LDA.B SpriteTableC2,X
    BNE +
    INC.B SpriteTableC2,X
    STZ.W GameCloudCoinCount
  + LDA.B SpriteLock
    BNE ADDR_02EF1C
    LDA.B EffFrame
    AND.B #$7F
    BNE +
    LDA.W SpriteMisc1570,X
    CMP.B #$0B
    BCS +
    INC.W SpriteMisc1570,X
    JSR ADDR_02EF67
  + LDA.B EffFrame
    AND.B #$01
    BNE ADDR_02EF12
    LDA.B SpriteYPosLow,X
    STA.B _0
    LDA.W SpriteYPosHigh,X
    STA.B _1
    LDA.B #$10
    STA.B _2
    LDA.B #$01
    STA.B _3
    REP #$20                                  ; A->16
    LDA.B _0
    CMP.B _2
    SEP #$20                                  ; A->8
    LDY.B #$00
    BCC +
    INY
  + LDA.W SpriteMisc1570,X
    CMP.B #$0B
    BCC +
    JSR SubOffscreen0Bnk2
    LDY.B #$01
  + LDA.B SpriteYSpeed,X
    CMP.W DATA_02EEB3,Y
    BEQ ADDR_02EF12
    CLC
    ADC.W DATA_02EEB1,Y
    STA.B SpriteYSpeed,X
ADDR_02EF12:
    JSR UpdateYPosNoGrvty
    LDA.B #$08
    STA.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty
ADDR_02EF1C:
    LDA.W SpriteOAMIndex,X
    PHA
    CLC
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    JSL GenericSprGfxRt2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$60
    STA.W OAMTileNo+$100,Y
    LDA.B EffFrame
    ASL A
    ASL A
    ASL A
    AND.B #$C0
    ORA.B #$30
    STA.W OAMTileAttr+$100,Y
    PLA
    STA.W SpriteOAMIndex,X
    JSR GetDrawInfo2
    LDA.B _0
    CLC
    ADC.B #$04
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.B #$04
    STA.W OAMTileYPos+$100,Y
    LDA.B #$4D
    STA.W OAMTileNo+$100,Y
    LDA.B #$39
    STA.W OAMTileAttr+$100,Y
    LDY.B #$00
    LDA.B #$00
    JSR CODE_02B7A7
    RTS

ADDR_02EF67:
    LDA.W GameCloudCoinCount
    CMP.B #$0A
    BCC ADDR_02EFAA
    LDY.B #$0B
ADDR_02EF70:
    LDA.W SpriteStatus,Y
    BEQ ADDR_02EF7B
    DEY
    CPY.B #$09
    BNE ADDR_02EF70
    RTS

ADDR_02EF7B:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$78
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    LDA.B #$E0
    STA.B SpriteYSpeed,X
    INC.W SpriteMisc157C,X
    PLX
    RTS

ADDR_02EFAA:
    LDA.W SpriteMisc1570,X
    CMP.B #$0B
    BCS Return02EFBB
    LDY.B #$07                                ; \ Find a free extended sprite slot
ADDR_02EFB3:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ ADDR_02EFBC                           ; |
    DEY                                       ; |
    BPL ADDR_02EFB3                           ; |
Return02EFBB:
    RTS                                       ; / Return if no free slots

ADDR_02EFBC:
    LDA.B #$0A                                ; \ Extended sprite = Cloud game coin
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W ExtSpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W ExtSpriteYPosHigh,Y
    LDA.B #$D0
    STA.W ExtSpriteYSpeed,Y
    LDA.B #$00
    STA.W ExtSpriteXSpeed,Y
    STA.W ExtSpriteMisc1765,Y
    RTS


DATA_02EFEA:
    db $00,$80,$00,$80

DATA_02EFEE:
    db $00,$00,$01,$01

WigglerInit:
    PHB
    PHK
    PLB
    JSR CODE_02F011
    LDY.B #$7E
  - LDA.B SpriteXPosLow,X
    STA.B [WigglerSegmentPtr],Y
    LDA.B SpriteYPosLow,X
    INY
    STA.B [WigglerSegmentPtr],Y
    DEY
    DEY
    DEY
    BPL -
    JSR CODE_02D4FA
    TYA
    STA.W SpriteMisc157C,X
    PLB
    RTL

CODE_02F011:
    TXA
    AND.B #$03
    TAY
    LDA.B #WigglerTable
    CLC
    ADC.W DATA_02EFEA,Y
    STA.B WigglerSegmentPtr
    LDA.B #WigglerTable>>8
    ADC.W DATA_02EFEE,Y
    STA.B WigglerSegmentPtr+1
    LDA.B #WigglerTable>>16
    STA.B WigglerSegmentPtr+2
    RTS

WigglerMain:
    PHB
    PHK
    PLB
    JSR WigglerMainRt
    PLB
    RTL


WigglerSpeed:
    db $08,$F8,$10,$F0

WigglerMainRt:
    JSR CODE_02F011
    LDA.B SpriteLock
    BEQ +
    JMP CODE_02F0D8

  + JSL SprSprInteract
    LDA.W SpriteMisc1540,X
    BEQ CODE_02F061
    CMP.B #$01
    BNE CODE_02F050
    LDA.B #$08
    BRA +

CODE_02F050:
    AND.B #$0E
  + STA.B _0
    LDA.W SpriteOBJAttribute,X
    AND.B #$F1
    ORA.B _0
    STA.W SpriteOBJAttribute,X
    JMP CODE_02F0D8

CODE_02F061:
    JSR UpdateXPosNoGrvty
    JSR UpdateYPosNoGrvty
    JSR SubOffscreen0Bnk2
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc151C,X
    BEQ +
    INC.W SpriteMisc1570,X
    INC.W SpriteMisc1534,X
    LDA.W SpriteMisc1534,X
    AND.B #$3F
    BNE +
    JSR CODE_02D4FA
    TYA
    STA.W SpriteMisc157C,X
  + LDY.W SpriteMisc157C,X
    LDA.W SpriteMisc151C,X
    BEQ +
    INY
    INY
  + LDA.W WigglerSpeed,Y
    STA.B SpriteXSpeed,X
    INC.B SpriteYSpeed,X
    JSL CODE_019138
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if touching object
    AND.B #$03                                ; |
    BNE CODE_02F0AE                           ; /
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ CODE_02F0AE                           ; /
    JSR CODE_02FFD1
    BRA +

CODE_02F0AE:
    LDA.W SpriteMisc15AC,X
    BNE +
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
    STZ.W SpriteMisc1602,X
    LDA.B #$08
    STA.W SpriteMisc15AC,X
  + JSR CODE_02F0DB
    LDA.W SpriteMisc1602,X
    INC.W SpriteMisc1602,X
    AND.B #$07
    BNE CODE_02F0D8
    LDA.B SpriteTableC2,X
    ASL A
    ORA.W SpriteMisc157C,X
    STA.B SpriteTableC2,X
CODE_02F0D8:
    JMP CODE_02F110

CODE_02F0DB:
    PHX
    PHB
    REP #$30                                  ; AXY->16
    LDA.B WigglerSegmentPtr
    CLC
    ADC.W #$007D
    TAX
    LDA.B WigglerSegmentPtr
    CLC
    ADC.W #$007F
    TAY
    LDA.W #$007D
    MVP WigglerTable>>16,WigglerTable>>16
    SEP #$30                                  ; AXY->8
    PLB
    PLX
    LDY.B #$00
    LDA.B SpriteXPosLow,X
    STA.B [WigglerSegmentPtr],Y
    LDA.B SpriteYPosLow,X
    INY
    STA.B [WigglerSegmentPtr],Y
    RTS


DATA_02F103:
    db $00,$1E,$3E,$5E,$7E

DATA_02F108:
    db $00,$01,$02,$01

WigglerTiles:
    db $C4,$C6,$C8,$C6

CODE_02F110:
    JSR GetDrawInfo2
    LDA.W SpriteMisc1570,X
    STA.B _3
    LDA.W SpriteOBJAttribute,X
    STA.B _7
    LDA.W SpriteMisc151C,X
    STA.B _8
    LDA.B SpriteTableC2,X
    STA.B _2
    TYA
    CLC
    ADC.B #$04
    TAY
    LDX.B #$00
CODE_02F12D:
    PHX
    STX.B _5
    LDA.B _3
    LSR A
    LSR A
    LSR A
    NOP
    NOP
    NOP
    NOP
    CLC
    ADC.B _5
    AND.B #$03
    STA.B _6
    PHY
    LDY.W DATA_02F103,X
    LDA.B _8
    BEQ +
    TYA
    LSR A
    AND.B #$FE
    TAY
  + STY.B _9
    LDA.B [WigglerSegmentPtr],Y
    PLY
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$100,Y
    PHY
    LDY.B _9
    INY
    LDA.B [WigglerSegmentPtr],Y
    PLY
    SEC
    SBC.B Layer1YPos
    LDX.B _6
    SEC
    %LorW_X(SBC,DATA_02F108)
    STA.W OAMTileYPos+$100,Y
    PLX
    PHX
    LDA.B #$8C
    CPX.B #$00
    BEQ +
    LDX.B _6
    %LorW_X(LDA,WigglerTiles)
  + STA.W OAMTileNo+$100,Y
    PLX
    LDA.B _7
    ORA.B SpriteProperties
    LSR.B _2
    BCS +
    ORA.B #$40
  + STA.W OAMTileAttr+$100,Y
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
    INX
    CPX.B #$05
    BNE CODE_02F12D
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _8
    BEQ CODE_02F1C7
    PHX
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc157C,X
    TAX
    LDA.W OAMTileXPos+$104,Y
    CLC
    ADC.W WigglerEyesX,X
    PLX
    STA.W OAMTileXPos+$100,Y
    LDA.W OAMTileYPos+$104,Y
    STA.W OAMTileYPos+$100,Y
    LDA.B #$88
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$104,Y
    BRA +

CODE_02F1C7:
    PHX
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc157C,X
    TAX
    LDA.W OAMTileXPos+$104,Y
    CLC
    ADC.W DATA_02F2D3,X
    PLX
    STA.W OAMTileXPos+$100,Y
    LDA.W OAMTileYPos+$104,Y
    SEC
    SBC.B #$08
    STA.W OAMTileYPos+$100,Y
    LDA.B #$98
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$104,Y
    AND.B #$F1
    ORA.B #$0A
  + STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    LDA.B #$05
    LDY.B #$FF
    JSR CODE_02B7A7
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    REP #$20                                  ; A->16
    LDA.B _0
    SEC
    SBC.B PlayerXPosNext
    CLC
    ADC.W #$0050
    CMP.W #$00A0
    SEP #$20                                  ; A->8
    BCS Return02F295
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return02F295
    LDA.B #$04
    STA.B _0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
CODE_02F22B:
    LDA.W OAMTileXPos+$104,Y
    SEC
    SBC.B PlayerXPosScrRel
    ADC.B #$0C
    CMP.B #$18
    BCS CODE_02F29B
    LDA.W OAMTileYPos+$104,Y
    SEC
    SBC.B PlayerYPosScrRel
    SBC.B #$10
    PHY
    LDY.W PlayerRidingYoshi
    BEQ +
    SBC.B #$10
  + PLY
    CLC
    ADC.B #$0C
    CMP.B #$18
    BCS CODE_02F29B
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario has star
    BNE ADDR_02F29D                           ; /
    LDA.W SpriteMisc154C,X
    ORA.B PlayerYPosScrRel+1
    BNE CODE_02F29B
    LDA.B #$08
    STA.W SpriteMisc154C,X
    LDA.W SpriteStompCounter
    BNE CODE_02F26B
    LDA.B PlayerYSpeed+1
    CMP.B #$08
    BMI CODE_02F296
CODE_02F26B:
    LDA.B #!SFX_KICK                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    JSL BoostMarioSpeed
    LDA.W SpriteMisc151C,X
    ORA.W SpriteOnYoshiTongue,X
    BNE Return02F295
    JSL DisplayContactGfx
    LDA.W SpriteStompCounter
    INC.W SpriteStompCounter
    JSL GivePoints
    LDA.B #$40
    STA.W SpriteMisc1540,X
    INC.W SpriteMisc151C,X
    JSR CODE_02F2D7
Return02F295:
    RTS

CODE_02F296:
    JSL HurtMario
    RTS

CODE_02F29B:
    BRA CODE_02F2C7

ADDR_02F29D:
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,X                      ; /
    LDA.B #$D0
    STA.B SpriteYSpeed,X
    INC.W StarKillCounter
    LDA.W StarKillCounter
    CMP.B #$09
    BCC +
    LDA.B #$09
    STA.W StarKillCounter
  + JSL GivePoints
    LDY.W StarKillCounter
    CPY.B #$08
    BCS +
    LDA.W StompSFX2-1,Y                       ; \ Play sound effect
    STA.W SPCIO0                              ; /
  + RTS

CODE_02F2C7:
    INY
    INY
    INY
    INY
    DEC.B _0
    BMI +
    JMP CODE_02F22B

  + RTS


DATA_02F2D3:
    db $00,$08

WigglerEyesX:
    db $04,$04

CODE_02F2D7:
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_02F2D9:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_02F2E2                           ; |
    DEY                                       ; |
    BPL CODE_02F2D9                           ; |
    RTS                                       ; / Return if no free slots

CODE_02F2E2:
    LDA.B #$0E                                ; \ Extended sprite = Wiggler flower
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B #$01
    STA.W ExtSpriteMisc1765,Y
    LDA.B SpriteXPosLow,X
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W ExtSpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W ExtSpriteYPosLow,Y
    LDA.B SpriteYPosLow,X
    STA.W ExtSpriteYPosHigh,Y
    LDA.B #$D0
    STA.W ExtSpriteYSpeed,Y
    LDA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.W ExtSpriteXSpeed,Y
    RTS

BirdsMain:
    PHB
    PHK
    PLB
    JSR CODE_02F317
    PLB
    RTL

CODE_02F317:
    LDA.W SpriteMisc15AC,X
    BEQ +
    LDA.B #$04
    STA.W SpriteMisc1602,X
  + JSR CODE_02F3EA
    JSR UpdateXPosNoGrvty
    JSR UpdateYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CLC
    ADC.B #$03
    STA.B SpriteYSpeed,X
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02F342
    dw CODE_02F38F

    RTS


DATA_02F33C:
    db $02,$03,$05,$01

DATA_02F340:
    db $08,$F8

CODE_02F342:
    LDY.W SpriteMisc157C,X
    LDA.W DATA_02F340,Y
    STA.B SpriteXSpeed,X
    STZ.W SpriteMisc1602,X
    LDA.B SpriteYSpeed,X
    BMI Return02F370
    LDA.B SpriteYPosLow,X
    CMP.B #$E8
    BCC Return02F370
    AND.B #$F8
    STA.B SpriteYPosLow,X
    LDA.B #$F0
    STA.B SpriteYSpeed,X
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$30
    CMP.B #$60
    BCC CODE_02F381
    LDA.W SpriteMisc1570,X
    BEQ +
    DEC.W SpriteMisc1570,X
Return02F370:
    RTS

  + INC.B SpriteTableC2,X
    JSL GetRand
    AND.B #$03
    TAY
    LDA.W DATA_02F33C,Y
    STA.W SpriteMisc1570,X
    RTS

CODE_02F381:
    LDA.W SpriteMisc154C,X
    BNE +
    JSR CODE_02F3C1
    LDA.B #$10
    STA.W SpriteMisc154C,X
  + RTS

CODE_02F38F:
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    STZ.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    BEQ CODE_02F3A3
    CMP.B #$08
    BCS +
    INC.W SpriteMisc1602,X
  + RTS

CODE_02F3A3:
    LDA.W SpriteMisc1570,X
    BEQ +
    DEC.W SpriteMisc1570,X
    JSL GetRand
    AND.B #$1F
    ORA.B #$0A
    STA.W SpriteMisc1540,X
    RTS

  + STZ.B SpriteTableC2,X
    JSL GetRand
    AND.B #$01
    BNE +
CODE_02F3C1:
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
    LDA.B #$0A
    STA.W SpriteMisc15AC,X
  + JSL GetRand
    AND.B #$03
    CLC
    ADC.B #$02
    STA.W SpriteMisc1570,X
    RTS


BirdsTilemap:
    db $D2,$D3,$D0,$D1,$9B

BirdsFlip:
    db $71,$31

BirdsPal:
    db $08,$04,$06,$0A

FireplaceTilemap:
    db $30,$34,$48,$3C

CODE_02F3EA:
    TXA
    AND.B #$03
    TAY
    LDA.W BirdsPal,Y
    LDY.W SpriteMisc157C,X
    ORA.W BirdsFlip,Y
    STA.B _2
    TXA
    AND.B #$03
    TAY
    LDA.W FireplaceTilemap,Y
    TAY
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos,Y
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos,Y
    PHX
    LDA.W SpriteMisc1602,X
    TAX
    %LorW_X(LDA,BirdsTilemap)
    STA.W OAMTileNo,Y
    PLX
    LDA.B _2
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    RTS

SmokeMain:
    PHB
    PHK
    PLB
    JSR CODE_02F434
    PLB
    RTL

CODE_02F434:
    INC.W SpriteMisc1570,X
    LDY.B #$04
    LDA.W SpriteMisc1570,X
    AND.B #$40
    BEQ +
    LDY.B #$FE
  + STY.B SpriteXSpeed,X
    LDA.B #$FC
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty
    LDA.W SpriteMisc1540,X
    BNE +
    JSR UpdateXPosNoGrvty
  + JSR CODE_02F47C
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$F0
    BNE +
    STZ.W SpriteStatus,X
  + RTS


DATA_02F463:
    db $03,$04,$05,$04,$05,$06,$05,$06
    db $07,$06,$07,$08,$07,$08,$07,$08
    db $07,$08,$07,$08,$07,$08,$07,$08
    db $07

CODE_02F47C:
    LDA.B EffFrame
    AND.B #$0F
    BNE +
    INC.W SpriteMisc151C,X
  + LDY.W SpriteMisc151C,X
    LDA.W DATA_02F463,Y
    STA.B _0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    PHA
    SEC
    SBC.B _0
    STA.W OAMTileXPos+$100,Y
    PLA
    CLC
    ADC.B _0
    STA.W OAMTileXPos+$104,Y
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    LDA.B #$C5
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$104,Y
    LDA.B #$05
    STA.W OAMTileAttr+$100,Y
    ORA.B #$40
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
    RTS

SideExitMain:
    PHB
    PHK
    PLB
    JSR CODE_02F4D5
    PLB
    RTL

CODE_02F4D5:
    LDA.B #$01
    STA.W SideExitEnabled
    LDA.B SpriteXPosLow,X
    AND.B #$10
    BNE +
    JSR CODE_02F4EB
    JSR CODE_02F53E
  + RTS


DATA_02F4E7:
    db $D4,$AB

DATA_02F4E9:
    db $BB,$9A

CODE_02F4EB:
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$08
    TAY
    LDA.B #$B8
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    LDA.B #$B0
    STA.W OAMTileYPos+$100,Y
    LDA.B #$B8
    STA.W OAMTileYPos+$104,Y
    LDA.B TrueFrame
if ver_is_lores(!_VER)                        ;\================= J, U, SS, & E0 ==============
    AND.B #$03                                ;!
    BNE +                                     ;!
    PHY                                       ;!
    JSL GetRand                               ;!
    PLY                                       ;!
    AND.B #$03                                ;!
    BNE +                                     ;!
    INC.B SpriteTableC2,X                     ;!
else                                          ;<======================= E1 ====================
    AND.B #$07                                ;!
    BNE +                                     ;! yup this does nothing
endif                                         ;/===============================================
  + PHX
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAX
    %LorW_X(LDA,DATA_02F4E7)
    STA.W OAMTileNo+$100,Y
    %LorW_X(LDA,DATA_02F4E9)
    STA.W OAMTileNo+$104,Y
    LDA.B #$35
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
    PLX
    RTS

CODE_02F53E:
    LDA.B EffFrame
    AND.B #$3F
    BNE +
    JSR CODE_02F548
  + RTS

CODE_02F548:
    LDY.B #$09
CODE_02F54A:
    LDA.W SpriteStatus,Y
    BEQ CODE_02F553
    DEY
    BPL CODE_02F54A
    RTS

CODE_02F553:
    LDA.B #$8B
    STA.W SpriteNumber,Y
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    PHX
    TYX
    JSL InitSpriteTables
    LDA.B #$BB
    STA.B SpriteXPosLow,X
    LDA.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B #$E0
    STA.B SpriteYPosLow,X
    LDA.B #$20
    STA.W SpriteMisc1540,X
    PLX
    RTS

CODE_02F57C:
    PHB                                       ; Wrapper
    PHK
    PLB
    JSR CODE_02F759
    PLB
    RTL

CODE_02F584:
    PHB                                       ; Wrapper
    PHK
    PLB
    JSR CODE_02F66E
    PLB
    RTL

ADDR_02F58C:
    PHB                                       ; Wrapper
    PHK
    PLB
    JSR ADDR_02F639
    PLB
    RTL

GhostExitMain:
    PHB
    PHK
    PLB
    PHX
    JSR CODE_02F5D0
    PLX
    PLB
    RTL


DATA_02F59E:
    db $08,$18,$F8,$F8,$F8,$F8,$28,$28
    db $28,$28

DATA_02F5A8:
    db $00,$00,$FF,$FF,$FF,$FF,$00,$00
    db $00,$00

DATA_02F5B2:
    db $5F,$5F,$8F,$97,$A7,$AF,$8F,$97
    db $A7,$AF

DATA_02F5BC:
    db $9C,$9E,$A0,$B0,$B0,$A0,$A0,$B0
    db $B0,$A0

DATA_02F5C6:
    db $23,$23,$2D,$2D,$AD,$AD,$6D,$6D
    db $ED,$ED

CODE_02F5D0:
    LDA.B Layer1XPos
    CMP.B #$46
    BCS Return02F618
    LDX.B #$09
    LDY.B #$A0
CODE_02F5DA:
    STZ.B _2
    LDA.W DATA_02F59E,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.W DATA_02F5A8,X
    SBC.B Layer1XPos+1
    BEQ +
    INC.B _2
  + LDA.B _0
    STA.W OAMTileXPos+$100,Y
    LDA.W DATA_02F5B2,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DATA_02F5BC,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02F5C6,X
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    ORA.B _2
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_02F5DA
Return02F618:
    RTS


DATA_02F619:
    db $F8,$08,$F8,$08,$00,$00,$00,$00
DATA_02F621:
    db $00,$00,$10,$10,$20,$30,$40,$08
DATA_02F629:
    db $C7,$A7,$A7,$C7,$A9,$C9,$C9,$E0
DATA_02F631:
    db $A9,$69,$A9,$69,$29,$29,$29,$6B

ADDR_02F639:
    LDX.B #$07
    LDY.B #$B0
  - LDA.B #$C0
    CLC
    %LorW_X(ADC,DATA_02F619)
    STA.W OAMTileXPos+$100,Y
    LDA.B #$70
    CLC
    %LorW_X(ADC,DATA_02F621)
    STA.W OAMTileYPos+$100,Y
    %LorW_X(LDA,DATA_02F629)
    STA.W OAMTileNo+$100,Y
    %LorW_X(LDA,DATA_02F631)
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
    BPL -
    RTS

CODE_02F66E:
    LDA.W NoYoshiIntroTimer
    BEQ +
    DEC.W NoYoshiIntroTimer
  + CMP.B #$B0
    BNE +
    LDY.B #!SFX_DOOROPEN                      ; \ Play sound effect
    STY.W SPCIO3                              ; /
  + CMP.B #$01
    BNE +
    LDY.B #!SFX_DOORCLOSE                     ; \ Play sound effect
    STY.W SPCIO3                              ; /
  + CMP.B #$30
    BCC CODE_02F69A
    CMP.B #$81
    BCC CODE_02F698
    CLC
    ADC.B #$4F
    EOR.B #$FF
    INC A
    BRA CODE_02F69A

CODE_02F698:
    LDA.B #$30
CODE_02F69A:
    STA.B _0
    JSR CODE_02F6B8
    RTS


DATA_02F6A0:
    db $00,$10,$20,$00,$10,$20,$00,$10
    db $20,$00,$10,$20

DATA_02F6AC:
    db $00,$00,$00,$10,$10,$10,$20,$20
    db $20,$30,$30,$30

CODE_02F6B8:
    LDX.B #$0B
    LDY.B #$B0
  - LDA.B #$B8
    CLC
    %LorW_X(ADC,DATA_02F6A0)
    STA.W OAMTileXPos,Y
    LDA.B #$50
    SEC
    SBC.B Layer1YPos
    SEC
    SBC.B _0
    CLC
    %LorW_X(ADC,DATA_02F6AC)
    STA.W OAMTileYPos,Y
    LDA.B #$A5
    STA.W OAMTileNo,Y
    LDA.B #$21
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
    RTS


DATA_02F6F1:
    db $00,$00,$00,$00,$10,$10,$10,$10
    db $00,$00,$00,$00,$10,$10,$10,$10
    db $00,$00,$00,$00,$10,$10,$10,$10
    db $F2,$F2,$F2,$F2,$1E,$1E,$1E,$1E
DATA_02F711:
    db $00,$08,$18,$20,$00,$08,$18,$20
DATA_02F719:
    db $7D,$7D,$FD,$FD,$3D,$3D,$BD,$BD
DATA_02F721:
    db $A0,$B0,$B0,$A0,$A0,$B0,$B0,$A0
    db $A3,$B3,$B3,$A3,$A3,$B3,$B3,$A3
    db $A2,$B2,$B2,$A2,$A2,$B2,$B2,$A2
    db $A3,$B3,$B3,$A3,$A3,$B3,$B3,$A3
DATA_02F741:
    db $40,$44,$48,$4C,$F0,$F4,$F8,$FC
DATA_02F749:
    db $00,$01,$02,$03,$03,$03,$03,$03
    db $03,$03,$03,$03,$03,$02,$01,$00

CODE_02F759:
    LDA.W NoYoshiIntroTimer
    BEQ +
    DEC.W NoYoshiIntroTimer
  + CMP.B #$76
    BNE +
    LDY.B #!SFX_DOOROPEN                      ; \ Play sound effect
    STY.W SPCIO3                              ; /
  + CMP.B #$08
    BNE +
    LDY.B #!SFX_DOORCLOSE                     ; \ Play sound effect
    STY.W SPCIO3                              ; /
  + LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_02F749,Y
    STA.B _3
    LDX.B #$07
    LDA.B #$B8
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.B #$60
    SEC
    SBC.B Layer1YPos
    STA.B _1
CODE_02F78C:
    STX.B _2
    LDY.W DATA_02F741,X
    LDA.B _3
    ASL A
    ASL A
    ASL A
    CLC
    ADC.B _2
    TAX
    TYA
    BMI CODE_02F7D0
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02F6F1)
    STA.W OAMTileXPos+$100,Y
    %LorW_X(LDA,DATA_02F721)
    STA.W OAMTileNo+$100,Y
    LDX.B _2
    LDA.B _1
    CLC
    %LorW_X(ADC,DATA_02F711)
    STA.W OAMTileYPos+$100,Y
    LDA.B _3
    CMP.B #$03
    %LorW_X(LDA,DATA_02F719)
    BCC +
    EOR.B #$40
  + STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    BRA CODE_02F801

CODE_02F7D0:
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02F6F1)
    STA.W OAMTileXPos,Y
    %LorW_X(LDA,DATA_02F721)
    STA.W OAMTileNo,Y
    LDX.B _2
    LDA.B _1
    CLC
    %LorW_X(ADC,DATA_02F711)
    STA.W OAMTileYPos,Y
    LDA.B _3
    CMP.B #$03
    %LorW_X(LDA,DATA_02F719)
    BCC +
    EOR.B #$40
  + STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
CODE_02F801:
    DEX
    BMI +
    JMP CODE_02F78C

  + RTS

CODE_02F808:
    PHB                                       ; Wrapper
    PHK
    PLB
    JSR CODE_02F810
    PLB
    RTL

CODE_02F810:
    LDX.B #$13
CODE_02F812:
    STX.W CurSpriteProcess
    LDA.W ClusterSpriteNumber,X
    BEQ +
    JSR CODE_02F821
  + DEX
    BPL CODE_02F812
Return02F820:
    RTS

CODE_02F821:
    JSL ExecutePtr

    dw Return02F820
    dw CODE_02FDBC
    dw $0000
    dw CODE_02FBC7
    dw CODE_02FA98
    dw CODE_02FA16
    dw CODE_02F91C
    dw CODE_02F83D
    dw CODE_02FBC7

DATA_02F837:
    db $01,$FF

DATA_02F839:
    db $00,$FF,$02,$0E

CODE_02F83D:
    LDA.W BooCloudTimer
    STA.W TileGenerateTrackA
    TXY
    BNE +
    DEC.W BooCloudTimer
    CMP.B #$00
    BNE +
    INC.W BooRingIndex
    LDY.B #$FF
    STY.W BooCloudTimer
  + CMP.B #$00
    BNE CODE_02F89E
    LDA.W SpriteWillAppear
    BEQ +
    STZ.W ClusterSpriteNumber,X
    STZ.W BooRingIndex
    RTS

  + LDA.W ClusterSpriteMisc1E66,X
    STA.B _0
    LDA.W ClusterSpriteMisc1E52,X
    STA.B _1
    LDA.W BooRingIndex
    AND.B #$01
    BNE +
    LDA.W ClusterSpriteMisc1E8E,X
    STA.B _0
    LDA.W ClusterSpriteMisc1E7A,X
    STA.B _1
  + LDA.B _0
    CLC
    ADC.B Layer1XPos
    STA.W ClusterSpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W ClusterSpriteXPosHigh,X
    LDA.B _1
    CLC
    ADC.B Layer1YPos
    STA.W ClusterSpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W ClusterSpriteYPosHigh,X
CODE_02F89E:
    TXA
    ASL A
    ASL A
    ADC.B EffFrame
    STA.B _0
    AND.B #$07
    ORA.B SpriteLock
    BNE +
    LDA.B _0
    AND.B #$20
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W ClusterSpriteYPosLow,X
    CLC
    ADC.W DATA_02F837,Y
    STA.W ClusterSpriteYPosLow,X
    LDA.W ClusterSpriteYPosHigh,X
    ADC.W DATA_02F839,Y
    STA.W ClusterSpriteYPosHigh,X
  + LDY.W TileGenerateTrackA
    CPY.B #$20
    BCC Return02F8FB
    CPY.B #$40
    BCS CODE_02F8D8
    TYA
    SBC.B #$1F
    BRA CODE_02F8E2

CODE_02F8D8:
    CPY.B #$E0
    BCC CODE_02F8E6
    TYA
    SBC.B #$E0
    EOR.B #$1F
    INC A
CODE_02F8E2:
    LSR A
    LSR A
    BRA +

CODE_02F8E6:
    JSR CODE_02FBB0
    LDA.B #$08
  + STA.W BooTransparency
    CPX.B #$00
    BNE +
    JSL CODE_038239
  + LDA.B #$0F
    JSR CODE_02FD48
Return02F8FB:
    RTS


DATA_02F8FC:
    db $00,$10,$00,$10,$08,$10,$FF,$10
SumoBroFlameTiles:
    db $DC,$EC,$CC,$EC,$CC,$DC,$00,$CC
DATA_02F90C:
    db $03,$03,$03,$03,$02,$01,$00,$00
    db $00,$00,$00,$00,$01,$02,$03,$03

CODE_02F91C:
    LDA.W ClusterSpriteMisc0F4A,X
    BEQ CODE_02F93C
    LDY.B SpriteLock
    BNE +
    DEC.W ClusterSpriteMisc0F4A,X
  + LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_02F90C,Y
    ASL A
    STA.W TileGenerateTrackA
    JSR CODE_02F9AE
    PHX
    JSR CODE_02F940
    PLX
    RTS

CODE_02F93C:
    STZ.W ClusterSpriteNumber,X
    RTS

CODE_02F940:
    TXA
    ASL A
    TAY
    LDA.W DATA_02FF50,Y
    STA.W SpriteOAMIndex
    LDA.W ClusterSpriteXPosLow,X
    STA.B SpriteXPosLow
    LDA.W ClusterSpriteXPosHigh,X
    STA.W SpriteXPosHigh
    LDA.W ClusterSpriteYPosLow,X
    STA.B SpriteYPosLow
    LDA.W ClusterSpriteYPosHigh,X
    STA.W SpriteYPosHigh
    TAY
    LDX.B #$00
    JSR GetDrawInfo2
    LDX.B #$01
CODE_02F967:
    PHX
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    TXA
    ORA.W TileGenerateTrackA
    TAX
    LDA.W DATA_02F8FC,X
    BMI +
    CLC
    ADC.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.W SumoBroFlameTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.B EffFrame
    AND.B #$04
    ASL A
    ASL A
    ASL A
    ASL A
    NOP
    ORA.B SpriteProperties
    ORA.B #$05
    STA.W OAMTileAttr+$100,Y
  + PLX
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_02F967
    LDX.B #$00
    LDY.B #$02
    LDA.B #$01
    JSL FinishOAMWrite
    RTS

ADDR_02F9A6:
    STZ.W ClusterSpriteNumber,X
    RTS


DATA_02F9AA:
    db $02,$0A,$12,$1A

CODE_02F9AE:
    TXA
    EOR.B TrueFrame
    AND.B #$03
    BNE Return02F9FE
    LDA.W ClusterSpriteMisc0F4A,X
    CMP.B #$10
    BCC Return02F9FE
    LDA.W ClusterSpriteXPosLow,X
    CLC
    ADC.B #$02
    STA.B _4
    LDA.W ClusterSpriteXPosHigh,X
    ADC.B #$00
    STA.B _A
    LDA.B #$0C
    STA.B _6
    LDY.W TileGenerateTrackA
    LDA.W ClusterSpriteYPosLow,X
    CLC
    ADC.W DATA_02F9AA,Y
    STA.B _5
    LDA.B #$14
    STA.B _7
    LDA.W ClusterSpriteYPosHigh,X
    ADC.B #$00
    STA.B _B
    JSL GetMarioClipping
    JSL CheckForContact
    BCC Return02F9FE
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario has star
    BNE ADDR_02F9A6                           ; /
CODE_02F9F5:
    LDA.W PlayerRidingYoshi
    BNE +
    JSL HurtMario
Return02F9FE:
    RTS

  + JMP CODE_02A473


DATA_02FA02:
    db $03,$07,$07,$07,$0F,$07,$07,$0F
DATA_02FA0A:
    db $F0,$F4,$F8,$FC

CastleFlameTiles:
    db $E2,$E4,$E2,$E4

CastleFlameGfxProp:
    db $09,$09,$49,$49

CODE_02FA16:
    LDA.B SpriteLock
    BNE +
    JSL GetRand
    AND.B #$07
    TAY
    LDA.B TrueFrame
    AND.W DATA_02FA02,Y
    BNE +
    INC.W ClusterSpriteMisc0F4A,X
  + LDY.W DATA_02FA0A,X
    LDA.W ClusterSpriteXPosLow,X
    SEC
    SBC.B Layer2XPos
    STA.W OAMTileXPos+$100,Y
    LDA.W ClusterSpriteYPosLow,X
    SEC
    SBC.B Layer2YPos
    STA.W OAMTileYPos+$100,Y
    PHY
    PHX
    LDA.W ClusterSpriteMisc0F4A,X
    AND.B #$03
    TAX
    %LorW_X(LDA,CastleFlameTiles)
    STA.W OAMTileNo+$100,Y
    %LorW_X(LDA,CastleFlameGfxProp)
    STA.W OAMTileAttr+$100,Y
    PLX
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    PLY
    LDA.W OAMTileXPos+$100,Y
    CMP.B #$F0
    BCC +
    LDA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$1EC
    LDA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$1EC
    LDA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$1EC
    LDA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$1EC
    LDA.B #$03
    STA.W OAMTileSize+$7B
  + RTS


DATA_02FA84:
    db $00

DATA_02FA85:
    db $00,$28,$00,$50,$00,$78,$00,$A0
    db $00,$C8,$00,$F0,$00,$18,$01,$40
    db $01,$68,$01

CODE_02FA98:
    LDY.W ClusterSpriteMisc0F86,X
    LDA.W BooRingOffscreen,Y
    BEQ +
    STZ.W ClusterSpriteNumber,X
    RTS

  + LDA.B SpriteLock
    BNE CODE_02FAF0
    LDA.W ClusterSpriteMisc0F4A,X
    BEQ CODE_02FAF0
    STZ.B _0
    BPL +
    DEC.B _0
  + CLC
    ADC.W BooRingAngleLow,Y
    STA.W BooRingAngleLow,Y
    LDA.W BooRingAngleHigh,Y
    ADC.B _0
    AND.B #$01
    STA.W BooRingAngleHigh,Y
    LDA.W BooRingXPosLow,Y
    STA.B _0
    LDA.W BooRingXPosHigh,Y
    STA.B _1
    REP #$20                                  ; A->16
    LDA.B _0
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.W #$0080
    CMP.W #$0200
    SEP #$20                                  ; A->8
    BCC CODE_02FAF0
    LDA.B #$01
    STA.W BooRingOffscreen,Y
    PHX
    LDX.W BooRingLoadIndex,Y
    STZ.W SpriteLoadStatus,X                  ; Allow sprite to be reloaded by level loading routine
    PLX
    DEC.W BooRingIndex
CODE_02FAF0:
    PHX
    LDA.W ClusterSpriteMisc0F72,X
    ASL A
    TAX
    %LorW_X(LDA,DATA_02FA84)
    CLC
    ADC.W BooRingAngleLow,Y
    STA.B _0
    %LorW_X(LDA,DATA_02FA85)
    ADC.W BooRingAngleHigh,Y
    AND.B #$01
    STA.B _1
    PLX
    REP #$30                                  ; AXY->16
    LDA.B _0
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
    LDA.B #$50
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
    LDA.B #$50
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
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDY.W ClusterSpriteMisc0F86,X
    STZ.B _0
    LDA.B _4
    BPL +
    DEC.B _0
  + CLC
    ADC.W BooRingXPosLow,Y
    STA.W ClusterSpriteXPosLow,X
    LDA.W BooRingXPosHigh,Y
    ADC.B _0
    STA.W ClusterSpriteXPosHigh,X
    STZ.B _1
    LDA.B _6
    BPL +
    DEC.B _1
  + CLC
    ADC.W BooRingYPosLow,Y
    STA.W ClusterSpriteYPosLow,X
    LDA.W BooRingYPosHigh,Y
    ADC.B _1
    STA.W ClusterSpriteYPosHigh,X
    JSR CODE_02FC8D
CODE_02FBB0:
    TXA
    EOR.B TrueFrame
    AND.B #$03
    BNE +
    JSR CODE_02FE71
  + RTS


DATA_02FBBB:
    db $01,$FF

DATA_02FBBD:
    db $08,$F8

BooRingTiles:
    db $88,$8C,$A8,$8E,$AA,$AE,$88,$8C

CODE_02FBC7:
    CPX.B #$00
    BEQ +
    JMP CODE_02FC41

  + LDA.B TrueFrame
    AND.B #$07
    ORA.B SpriteLock
    BNE CODE_02FC3E
    JSL GetRand
    AND.B #$1F
    CMP.B #$14
    BCC +
    SBC.B #$14
  + TAX
    LDA.W ClusterSpriteMisc0F86,X
    BNE CODE_02FC3E
    INC.W ClusterSpriteMisc0F86,X
    LDA.B #$20
    STA.W ClusterSpriteMisc0F9A,X
    STZ.B _0
    LDA.W ClusterSpriteXPosLow,X
    SBC.B Layer1XPos
    ADC.B Layer1XPos
    PHP
    ADC.B _0
    STA.W ClusterSpriteXPosLow,X
    STA.B SpriteXPosLow
    LDA.B Layer1XPos+1
    ADC.B #$00
    PLP
    ADC.B #$00
    STA.W ClusterSpriteXPosHigh,X
    STA.W SpriteXPosHigh
    LDA.W ClusterSpriteYPosLow,X
    SBC.B Layer1YPos
    ADC.B Layer1YPos
    STA.W ClusterSpriteYPosLow,X
    STA.B SpriteYPosLow
    AND.B #$FC
    STA.W ClusterSpriteMisc0F72,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W ClusterSpriteYPosHigh,X
    STA.W SpriteYPosHigh
    PHX
    LDX.B #$00
    LDA.B #$10
    JSR CODE_02D2FB
    PLX
    LDA.B _0
    ADC.B #$09
    STA.W ClusterSpriteMisc1E52,X
    LDA.B _1
    STA.W ClusterSpriteMisc1E66,X
CODE_02FC3E:
    LDX.W CurSpriteProcess                    ; X = Sprite index
CODE_02FC41:
    LDA.B SpriteLock
    BNE +
    LDA.W ClusterSpriteMisc0F9A,X
    BEQ +
    DEC.W ClusterSpriteMisc0F9A,X
  + LDA.W ClusterSpriteMisc0F86,X
    BNE +
    JMP CODE_02FCE2

  + LDA.B SpriteLock
    BNE CODE_02FC8D
    LDA.W ClusterSpriteMisc0F9A,X
    BNE +
    JSR CODE_02FF98
    JSR CODE_02FFA3
    TXA
    EOR.B TrueFrame
    AND.B #$03
    BNE +
    JSR CODE_02FE71
    LDA.W ClusterSpriteMisc1E52,X
    CMP.B #$E1
    BMI +
    DEC.W ClusterSpriteMisc1E52,X
  + LDA.W ClusterSpriteYPosLow,X
    AND.B #$FC
    CMP.W ClusterSpriteMisc0F72,X
    BNE CODE_02FC8D
    LDA.W ClusterSpriteMisc1E52,X
    BPL CODE_02FC8D
    STZ.W ClusterSpriteMisc0F86,X
    STZ.W ClusterSpriteMisc1E66,X
CODE_02FC8D:
    LDA.W ClusterSpriteXPosLow,X
    STA.B _0
    LDA.W ClusterSpriteXPosHigh,X
    STA.B _1
    REP #$20                                  ; A->16
    LDA.B _0
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.W #$0040
    CMP.W #$0180
    SEP #$20                                  ; A->8
    BCS Return02FCD8
    LDA.B #$02
    JSR CODE_02FD48
    LDA.W ClusterSpriteYPosLow,X
    CLC
    ADC.B #$10
    PHP
    CMP.B Layer1YPos
    LDA.W ClusterSpriteYPosHigh,X
    SBC.B Layer1YPos+1
    PLP
    ADC.B #$00
    BNE CODE_02FCD9
    LDA.W ClusterSpriteXPosLow,X
    CMP.B Layer1XPos
    LDA.W ClusterSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BEQ Return02FCD8
    LDA.W DATA_02FF50,X
    LSR A
    LSR A
    TAY
    LDA.B #$03
    STA.W OAMTileSize+$40,Y
Return02FCD8:
    RTS

CODE_02FCD9:
    LDY.W DATA_02FF50,X
    LDA.B #$F0
    STA.W OAMTileYPos+$100,Y
    RTS

CODE_02FCE2:
    LDA.B SpriteLock
    BNE CODE_02FD46
    LDA.W ClusterSpriteNumber,X
    CMP.B #$08
    BEQ CODE_02FD46
    LDA.W ClusterSpriteMisc0F9A,X
    BNE +
    LDA.B TrueFrame
    AND.B #$01
    BNE +
    LDA.W ClusterSpriteMisc0F4A,X
    AND.B #$01
    TAY
    LDA.W ClusterSpriteMisc1E66,X
    CLC
    ADC.W DATA_02FBBB,Y
    STA.W ClusterSpriteMisc1E66,X
    CMP.W DATA_02FBBD,Y
    BNE +
    INC.W ClusterSpriteMisc0F4A,X
    LDA.W RandomNumber
    AND.B #$FF
    ORA.B #$3F
    STA.W ClusterSpriteMisc0F9A,X
  + JSR CODE_02FF98
    TXA
    EOR.B TrueFrame
    AND.B #$03
    BNE CODE_02FD46
    STZ.B _0
    LDY.B #$01
    TXA
    ASL A
    ASL A
    ASL A
    ADC.B TrueFrame
    AND.B #$40
    BEQ +
    LDY.B #$FF
    DEC.B _0
  + TYA
    CLC
    ADC.W ClusterSpriteYPosLow,X
    STA.W ClusterSpriteYPosLow,X
    LDA.B _0
    ADC.W ClusterSpriteYPosHigh,X
    STA.W ClusterSpriteYPosHigh,X
CODE_02FD46:
    LDA.B #$0E
CODE_02FD48:
    STA.B _2
    LDY.W DATA_02FF50,X
    LDA.W ClusterSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$100,Y
    LDA.W ClusterSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    AND.B #$01
    STA.B _0
    TXA
    AND.B #$03
    ASL A
    ADC.B _0
    PHX
    TAX
    %LorW_X(LDA,BooRingTiles)
    STA.W OAMTileNo+$100,Y
    PLX
    LDA.W ClusterSpriteMisc1E66,X
    ASL A
    LDA.B #$00
    BCS +
    LDA.B #$40
  + ORA.B #$31
    ORA.B _2
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    LDA.W ClusterSpriteNumber,X
    CMP.B #$08
    BNE +
    LDY.W DATA_02FF50,X
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$01
    STA.B _0
    LDA.W ClusterSpriteMisc0F86,X
    ASL A
    ORA.B _0
    PHX
    TAX
    LDA.W BatCeilingTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.B #$37
    STA.W OAMTileAttr+$100,Y
    PLX
  + RTS


BatCeilingTiles:
    db $AE,$AE,$C0,$EB

CODE_02FDBC:
    JSR CODE_02FFA3
    LDA.W ClusterSpriteMisc1E52,X
    CMP.B #$40
    BPL +
    CLC
    ADC.B #$03
    STA.W ClusterSpriteMisc1E52,X
  + LDA.W ClusterSpriteYPosHigh,X
    BEQ +
    LDA.W ClusterSpriteYPosLow,X
    CMP.B #$80
    BCC +
    AND.B #$F0
    STA.W ClusterSpriteYPosLow,X
    STZ.W ClusterSpriteMisc1E52,X
if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
  + TXA                                       ;!
    EOR.B TrueFrame                           ;!
    LSR A                                     ;!
    BCC CODE_02FE48                           ;!
endif                                         ;/===============================================
  + LDA.W ClusterSpriteMisc1E52,X
    BNE +
    LDA.W ClusterSpriteMisc1E66,X
    CLC
    ADC.W ClusterSpriteXPosLow,X
    STA.W ClusterSpriteXPosLow,X
    LDA.W ClusterSpriteXPosLow,X
    EOR.W ClusterSpriteMisc1E66,X
    BPL +
    LDA.W ClusterSpriteXPosLow,X
    CLC
    ADC.B #$20
    CMP.B #$30
    BCS +
    LDA.W ClusterSpriteMisc1E66,X
    EOR.B #$FF
    INC A
    STA.W ClusterSpriteMisc1E66,X
  + LDA.B PlayerXPosNext
    SEC
    SBC.W ClusterSpriteXPosLow,X
    CLC
    ADC.B #$0C
    CMP.B #$1E
    BCS CODE_02FE48
    LDA.B #$20
    LDY.B PlayerIsDucking
    BNE +
    LDY.B Powerup
    BEQ +
    LDA.B #$30
  + STA.B _0
    LDA.B PlayerYPosNext
    SEC
    SBC.W ClusterSpriteYPosLow,X
    CLC
    ADC.B #$20
    CMP.B _0
    BCS CODE_02FE48
    STZ.W ClusterSpriteNumber,X
    JSR CODE_02FF6C
    DEC.W BonusOneUpsRemain
    BNE CODE_02FE48
    LDA.B #$58
    STA.W BonusFinishTimer
CODE_02FE48:
    LDY.W DATA_02FF64,X
    LDA.W ClusterSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos,Y
    LDA.W ClusterSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos,Y
    LDA.B #$24
    STA.W OAMTileNo,Y
    LDA.B #$3A
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    RTS

CODE_02FE71:
    LDA.B #$14
    BRA +

    LDA.B #$0C                                ; Unreachable instruction
  + STA.B _2
    STZ.B _3
    LDA.W ClusterSpriteXPosLow,X
    STA.B _0
    LDA.W ClusterSpriteXPosHigh,X
    STA.B _1
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    SEC
    SBC.B _0
    CLC
    ADC.W #$000A
    CMP.B _2
    SEP #$20                                  ; A->8
    BCS Return02FEC4
    LDA.W ClusterSpriteYPosLow,X
    ADC.B #$03
    STA.B _2
    LDA.W ClusterSpriteYPosHigh,X
    ADC.B #$00
    STA.B _3
    REP #$20                                  ; A->16
    LDA.W #$0014
    LDY.B Powerup
    BEQ +
    LDA.W #$0020
  + STA.B _4
    LDA.B PlayerYPosNext
    SEC
    SBC.B _2
    CLC
    ADC.W #$001C
    CMP.B _4
    SEP #$20                                  ; A->8
    BCS Return02FEC4
    JSR CODE_02F9F5
Return02FEC4:
    RTS


DATA_02FEC5:
    db $40,$B0

DATA_02FEC7:
    db $01,$FF

DATA_02FEC9:
    db $30,$C0

DATA_02FECB:
    db $01,$FF

    LDA.B ScreenMode                          ; \ Unreachable
    AND.B #!ScrMode_Layer1Vert
    BNE ADDR_02FF1E
    LDA.W ClusterSpriteYPosLow,X
    CLC
    ADC.B #$50
    LDA.W ClusterSpriteYPosHigh,X
    ADC.B #$00
    CMP.B #$02
    BPL ADDR_02FF0E
    LDA.B TrueFrame
    AND.B #$01
    STA.B _1
    TAY
    LDA.B Layer1XPos
    CLC
    ADC.W DATA_02FEC9,Y
    ROL.B _0
    CMP.W ClusterSpriteXPosLow,X
    PHP
    LDA.B Layer1XPos+1
    LSR.B _0
    ADC.W DATA_02FECB,Y
    PLP
    SBC.W ClusterSpriteXPosHigh,X
    STA.B _0
    LSR.B _1
    BCC +
    EOR.B #$80
    STA.B _0
  + LDA.B _0
    BPL Return02FF1D
ADDR_02FF0E:
    LDY.W ClusterSpriteMisc0F86,X
    CPY.B #$FF
    BEQ +
    LDA.B #$00                                ; \ Allow sprite to be reloaded by level loading routine
    STA.W SpriteLoadStatus,Y                  ; /
  + STZ.W ClusterSpriteNumber,X
Return02FF1D:
    RTS                                       ; /

ADDR_02FF1E:
    LDA.B TrueFrame                           ; \ Unreachable, called from above routine
    LSR A
    BCS Return02FF1D
    AND.B #$01
    STA.B _1
    TAY
    LDA.B Layer1XPos
    CLC
    ADC.W DATA_02FEC5,Y
    ROL.B _0
    CMP.W ClusterSpriteYPosLow,X
    PHP
    LDA.W Layer1YPos+1
    LSR.B _0
    ADC.W DATA_02FEC7,Y
    PLP
    SBC.W ClusterSpriteYPosHigh,X
    STA.B _0
    LDY.B _1
    BEQ +
    EOR.B #$80
    STA.B _0
  + LDA.B _0
    BPL Return02FF1D
    BMI ADDR_02FF0E                           ; /

DATA_02FF50:
    db $E0,$E4,$E8,$EC,$F0,$F4,$F8,$FC
    db $5C,$58,$54,$50,$4C,$48,$44,$40
    db $3C,$38,$34,$30

DATA_02FF64:
    db $90,$94,$98,$9C,$A0,$A4,$A8,$AC

CODE_02FF6C:
    JSL CODE_02AD34
    LDA.B #$0D
    STA.W ScoreSpriteNumber,Y
    LDA.W ClusterSpriteYPosLow,X
    SEC
    SBC.B #$08
    STA.W ScoreSpriteYPosLow,Y
    LDA.W ClusterSpriteYPosHigh,X
    SBC.B #$00
    STA.W ScoreSpriteYPosHigh,Y
    LDA.W ClusterSpriteXPosLow,X
    STA.W ScoreSpriteXPosLow,Y
    LDA.W ClusterSpriteXPosHigh,X
    STA.W ScoreSpriteXPosHigh,Y
    LDA.B #$30
    STA.W ScoreSpriteTimer,Y
    RTS

CODE_02FF98:
    PHX
    TXA
    CLC
    ADC.B #$14
    TAX
    JSR CODE_02FFA3
    PLX
    RTS

CODE_02FFA3:
    LDA.W ClusterSpriteMisc1E52,X
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.W ClusterSpriteMisc1E7A,X
    STA.W ClusterSpriteMisc1E7A,X
    PHP
    LDA.W ClusterSpriteMisc1E52,X
    LSR A
    LSR A
    LSR A
    LSR A
    CMP.B #$08
    LDY.B #$00
    BCC +
    ORA.B #$F0
    DEY
  + PLP
    ADC.W ClusterSpriteYPosLow,X
    STA.W ClusterSpriteYPosLow,X
    TYA
    ADC.W ClusterSpriteYPosHigh,X
    STA.W ClusterSpriteYPosHigh,X
    RTS

CODE_02FFD1:
    LDA.W SpriteBlockedDirs,X
    BMI ADDR_02FFDD
    LDA.B #$00
    LDY.W SpriteSlope,X
    BEQ +
ADDR_02FFDD:
    LDA.B #$18
  + STA.B SpriteYSpeed,X
    RTS

    %insert_empty($05,$1E,$1E,$24,$30)