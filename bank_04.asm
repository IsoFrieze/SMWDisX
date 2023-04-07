    ORG $048000

DATA_048000:
    dw $B480,$B498,$B4B0

DATA_048006:
    dw $B300,$B318,$B330,$B348
    dw $B360,$B378,$B390,$B3A8
    dw $B3C0,$B3D8,$B3F0,$B408
    dw $B420,$B438,$B450,$B468
    dw $B480,$B498,$B4B0,$B4C8
    dw $B4E0,$B4F8,$B510,$B528
    dw $B540,$B558,$B570,$B588
    dw $B5A0,$B5B8,$B5D0,$B5E8
    dw $B600,$B618,$B630,$B648
    dw $B660,$B678,$B690,$B6A8
    dw $B6C0,$B6D8,$B6F0,$B708
    dw $B720,$B738,$B750,$B768
    dw $B780,$B798,$B7B0,$B7C8
    dw $B7E0,$B7F8,$B810,$B828
    dw $B840,$B858,$B870,$B888
    dw $B8A0,$B8B8,$B8D0,$B8E8

CODE_048086:
    REP #$30                                  ; AXY->16
    STZ.B _3
    STZ.B _5
  - LDX.B _3
    LDA.W DATA_048000,X
    STA.B _0
    SEP #$10                                  ; XY->8
    LDY.B #$7E
    STY.B _2
    REP #$10                                  ; XY->16
    LDX.B _5
    JSR CODE_0480B9
    LDA.B _5
    CLC
    ADC.W #$0020
    STA.B _5
    LDA.B _3
    INC A
    INC A
    STA.B _3
    AND.W #$00FF
    CMP.W #$0006
    BNE -
    SEP #$30                                  ; AXY->8
    RTS

CODE_0480B9:
    LDY.W #$0000
    LDA.W #$0008
    STA.B _7
    STA.B _9
  - LDA.B [_0],Y
    STA.W GfxDecompOWAni,X
    INY
    INY
    INX
    INX
    DEC.B _7
    BNE -
  - LDA.B [_0],Y
    AND.W #$00FF
    STA.W GfxDecompOWAni,X
    INY
    INX
    INX
    DEC.B _9
    BNE -
    RTS

OW_Tile_Animation:
    LDA.B TrueFrame                           ; \
    AND.B #$07                                ; |If lower 3 bits of frame counter isn't 0,
    BNE CODE_048101                           ; / don't update the water animation
    LDX.B #$1F
CODE_0480E8:
    LDA.W GfxDecompOWAni,X
    STA.B _0
    TXA
    AND.B #$08
    BNE CODE_0480F9
    ASL.B _0
    ROL.W GfxDecompOWAni,X
    BRA +

CODE_0480F9:
    LSR.B _0
    ROR.W GfxDecompOWAni,X
  + DEX
    BPL CODE_0480E8
CODE_048101:
    LDA.B TrueFrame                           ; \
    AND.B #$07                                ; |If lower 3 bits of frame counter isn't 0,
    BNE +                                     ; / don't update the waterfall animation
    LDX.B #$20
    JSR CODE_048172
  + LDA.B TrueFrame                           ; \
    AND.B #$07                                ; |If lower 3 bits of frame counter isn't 0,
    BNE CODE_048123                           ; / branch to $8123
    LDX.B #$1F
  - LDA.W GfxDecompOWAni+$40,X
    ASL A
    ROL.W GfxDecompOWAni+$40,X
    DEX
    BPL -
    LDX.B #$40
    JSR CODE_048172
CODE_048123:
    REP #$30                                  ; AXY->16
    LDA.W #$0060
    STA.B _D
    STZ.B _B
CODE_04812C:
    LDX.W #$0038
    LDA.B _B
    CMP.W #$0020
    BCS +
    LDX.W #$0070
  + TXA
    AND.B TrueFrame
    LSR A
    LSR A
    CPX.W #$0038
    BEQ +
    LSR A
  + CLC
    ADC.B _B
    TAX
    LDA.W DATA_048006,X
    STA.B _0
    SEP #$10                                  ; XY->8
    LDY.B #$7E
    STY.B _2
    REP #$10                                  ; XY->16
    LDX.B _D
    JSR CODE_0480B9
    LDA.B _D
    CLC
    ADC.W #$0020
    STA.B _D
    LDA.B _B
    CLC
    ADC.W #$0010
    STA.B _B
    CMP.W #$0080
    BNE CODE_04812C
    SEP #$30                                  ; AXY->8
    RTS

CODE_048172:
    REP #$20                                  ; A->16
    LDY.B #$00
  - PHX
    TXA
    CLC
    ADC.W #$000E
    TAX
    LDA.W GfxDecompOWAni,X
    STA.B _0
    PLX
CODE_048183:
    LDA.W GfxDecompOWAni,X
    STA.B _2
    LDA.B _0
    STA.W GfxDecompOWAni,X
    LDA.B _2
    STA.B _0
    INX
    INX
    INY
    CPY.B #$08
    BEQ -
    CPY.B #$10
    BNE CODE_048183
    SEP #$20                                  ; A->8
    RTS


OWScrollArrowStripe:
    db $50,$CF,$00,$03,$7E,$78,$7E,$38
    db $50,$EF,$00,$03,$7F,$38,$7F,$78
    db $51,$C3,$00,$03,$7E,$78,$7D,$78
    db $51,$E3,$00,$03,$7E,$F8,$7D,$F8
    db $51,$DB,$00,$03,$7D,$38,$7E,$38
    db $51,$FB,$00,$03,$7D,$B8,$7E,$B8
    db $52,$EF,$00,$03,$7F,$B8,$7F,$F8
    db $53,$0F,$00,$03,$7E,$F8,$7E,$B8
    db $FF

OWScrollEraseStripe:
    db $50,$CF,$40,$02,$FC,$00,$50,$EF
    db $40,$02,$FC,$00,$51,$C3,$40,$02
    db $FC,$00,$51,$E3,$40,$02,$FC,$00
    db $51,$DB,$40,$02,$FC,$00,$51,$FB
    db $40,$02,$FC,$00,$52,$EF,$40,$02
    db $FC,$00,$53,$0F,$40,$02,$FC,$00
    db $FF

OWScrollSpeed:
    db $00,$00,$02,$00,$FE,$FF,$02,$00
    db $00,$00,$02,$00,$FE,$FF,$02,$00
OWMaxScrollRange:
    db $00,$00,$11,$01,$EF,$FF,$11,$01
    db $00,$00,$32,$01,$D7,$FF,$32,$01
DATA_048231:
    db $0F,$0F,$07,$07,$07,$03,$03,$03
    db $01,$01,$03,$03,$03,$07,$07,$07

GameMode_0E_Prim:
    PHB
    PHK
    PLB
    LDX.B #$01                                ; \ If player 1 pushes select...
CODE_048246:
    LDA.W byetudlrP1Frame,X                   ; |
    AND.B #$20                                ; | ...disabled by BRA
    BRA CODE_048261                           ; / Change to BEQ to enable debug code below

    LDA.W SavedPlayerYoshi,X                  ; \ Unreachable
    INC A                                     ; | Debug: Change Yoshi color
    INC A                                     ; |
    CMP.B #$04                                ; |
    BCS +                                     ; |
    LDA.B #$04                                ; |
  + CMP.B #$0B                                ; |
    BCC +                                     ; |
    LDA.B #$00                                ; |
  + STA.W SavedPlayerYoshi,X                  ; /
CODE_048261:
    DEX
    BPL CODE_048246
    JSR CODE_0485A7
    JSR OW_Tile_Animation
    LDA.W SwitchPalaceColor                   ; \ If "! blocks flying away color" is 0,
    BEQ +                                     ; / don't play the animation
    JSR CODE_04F290
    JMP CODE_04840D

  + LDA.W ShowContinueEnd                     ; \ If not showing Continue/End message,
    BEQ +                                     ; / branch to $8281
    JSL ProcContinueEndMenu
    JMP CODE_048410

  + LDA.W OverworldPromptProcess
    BEQ CODE_048295
    CMP.B #$05
    BCS CODE_04828F
    LDY.W IsTwoPlayerGame
    BEQ CODE_048295
CODE_04828F:
    JSR CODE_04F3E5
    JMP CODE_048413

CODE_048295:
    LDA.W PauseFlag
    LSR A
    BNE +
    JMP CODE_048356

  + REP #$20                                  ; A->16
    LDA.W OverworldFreeCamYPos
    SEC
    SBC.B Layer1YPos
    STA.B _1
    BPL +
    EOR.W #$FFFF
    INC A
  + LSR A
    SEP #$20                                  ; A->8
    STA.B _5
    REP #$20                                  ; A->16
    LDA.W OverworldFreeCamXPos
    SEC
    SBC.B Layer1XPos
    STA.B _0
    BPL +
    EOR.W #$FFFF
    INC A
  + LSR A
    SEP #$20                                  ; A->8
    STA.B _4
    LDX.B #$01
    CMP.B _5
    BCS +
    DEX
    LDA.B _5
  + CMP.B #$02
    BCS +
    REP #$20                                  ; A->16
    LDA.W OverworldFreeCamXPos
    STA.B Layer1XPos
    STA.B Layer2XPos
    LDA.W OverworldFreeCamYPos
    STA.B Layer1YPos
    STA.B Layer2YPos
    SEP #$20                                  ; A->8
    STZ.W PauseFlag
    JMP CODE_0483BD

  + STZ.W HW_WRDIV
    LDY.B _4,X
    STY.W HW_WRDIV+1
    STA.W HW_WRDIV+2
    NOP                                       ; \
    NOP                                       ; |
    NOP                                       ; |Makes you wonder what used to be here...
    NOP                                       ; |
    NOP                                       ; | NOTHING! Division takes time!
    NOP                                       ; /
    REP #$20                                  ; A->16
    LDA.W HW_RDDIV
    LSR A
    LSR A
    SEP #$20                                  ; A->8
    LDY.B _1,X
    BPL +
    EOR.B #$FF
    INC A
  + STA.B _1,X
    TXA
    EOR.B #$01
    TAX
    LDA.B #$40
    LDY.B _1,X
    BPL +
    LDA.B #$C0
  + STA.B _1,X
    LDY.B #$01
CODE_048320:
    TYA
    ASL A
    TAX
    LDA.W _1,Y
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.W Layer1PosSpx,Y
    STA.W Layer1PosSpx,Y
    LDA.W _1,Y
    PHY
    PHP
    LSR A
    LSR A
    LSR A
    LSR A
    LDY.B #$00
    PLP
    BPL +
    ORA.B #$F0
    DEY
  + ADC.B Layer1XPos,X
    STA.B Layer1XPos,X
    STA.B Layer2XPos,X
    TYA
    ADC.B Layer1XPos+1,X
    STA.B Layer1XPos+1,X
    STA.B Layer2XPos+1,X
    PLY
    DEY
    BPL CODE_048320
    JMP CODE_04840D

CODE_048356:
    LDA.W OverworldProcess
    CMP.B #$03
    BEQ CODE_048366
    CMP.B #$04
    BNE CODE_04839A
    LDA.W PlayerSwitching
    BNE CODE_04839A
CODE_048366:
if ver_is_console(!_VER)                      ;\================= J, U, E0, & E1 ==============
    LDA.W axlr0000P1Frame                     ;!
    ORA.W axlr0000P2Frame                     ;!
    AND.B #$30                                ;!
    BEQ +                                     ;!
    LDA.B #$01                                ;!
    STA.W OverworldPromptProcess              ;!
endif                                         ;/===============================================
  + LDX.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,X
    BNE CODE_04839A
    LDA.B byetudlrFrame
    AND.B #$10
    BEQ CODE_04839A
    INC.W PauseFlag                           ; Look around overworld
    LDA.W PauseFlag
    LSR A
    BNE CODE_04839A
    REP #$20                                  ; A->16
    LDA.B Layer1XPos
    STA.W OverworldFreeCamXPos
    LDA.B Layer1YPos
    STA.W OverworldFreeCamYPos
    SEP #$20                                  ; A->8
CODE_04839A:
    LDA.W PauseFlag
    BEQ CODE_0483C3
    LDX.B #$00
    LDA.B byetudlrHold
    AND.B #$03
    ASL A
    JSR OWFreeLook
    LDX.B #$02
    LDA.B byetudlrHold
    AND.B #$0C
    ORA.B #$10
    LSR A
    JSR OWFreeLook
    LDY.B #$15
    LDA.B TrueFrame
    AND.B #$18
    BNE +
CODE_0483BD:
    LDY.B #$18
  + STY.B StripeImage
    BRA CODE_04840D

CODE_0483C3:
    LDX.W OverworldEarthquake
    BEQ CODE_04840A
    CPX.B #$FE
    BNE +
    LDA.B #!SFX_RUMBLINGON
    STA.W SPCIO0                              ; / Play sound effect
    LDA.B #!BGM_VALLEYOPENS
    STA.W SPCIO2                              ; / Change music
  + TXA
    LSR A
    LSR A
    LSR A
    LSR A
    TAY
    LDA.B TrueFrame
    AND.W DATA_048231,Y
    BNE +
    LDA.B Layer1XPos
    EOR.B #$01
    STA.B Layer1XPos
    STA.B Layer2XPos
    LDA.B Layer1YPos
    EOR.B #$01
    STA.B Layer1YPos
    STA.B Layer2YPos
  + CPX.B #$80
    BCS CODE_0483FE
    LDA.W OverworldProcess
    CMP.B #$02
    BNE CODE_04840A
CODE_0483FE:
    DEC.W OverworldEarthquake
    BNE CODE_04840D
    LDA.B #!SFX_RUMBLINGOFF
    STA.W SPCIO0                              ; / Play sound effect
    BRA CODE_04840D

CODE_04840A:
    JSR CODE_048576
CODE_04840D:
    JSR CODE_04F708
CODE_048410:
    JSR CODE_04862E
CODE_048413:
    PLB
    RTL

OWFreeLook:
    TAY                                       ; A=$2,X=$0 for right; A=$4,X=$0 for left; A=$A,X=$2 for down; A=$C,X=$2 for up
    REP #$20                                  ; A->16
    LDA.B Layer1XPos,X
    CLC
    ADC.W OWScrollSpeed,Y
    PHA
    SEC
    SBC.W OWMaxScrollRange,Y
    EOR.W OWScrollSpeed,Y
    ASL A
    PLA
    BCC +
    STA.B Layer1XPos,X
    STA.B Layer2XPos,X
  + SEP #$20                                  ; A->8
    RTS


DATA_048431:
    db $11,$00,$0A,$00,$09,$00,$0B,$00
    db $12,$00,$0A,$00,$07,$00,$0A,$02
    db $03,$02,$10,$04,$12,$04,$1C,$04
    db $14,$04,$12,$06,$00,$02,$12,$06
    db $10,$00,$17,$06,$14,$00,$1C,$06
    db $14,$00,$1C,$06,$17,$06,$11,$05
    db $11,$05,$14,$04,$06,$01

DATA_048467:
    db $07,$00,$03,$00,$10,$00,$0E,$00
    db $17,$00,$18,$00,$12,$00,$14,$00
    db $0B,$00,$03,$00,$01,$00,$09,$00
    db $09,$00,$1D,$00,$0E,$00,$18,$00
    db $0F,$00,$16,$00,$10,$00,$18,$00
    db $02,$00,$1D,$00,$18,$00,$13,$00
    db $11,$00,$03,$00,$07,$00

DATA_04849D:
    db $A8,$04,$38,$04,$08,$09,$28,$09
    db $C8,$09,$48,$09,$28,$0D,$18,$01
    db $A8,$00,$98,$00,$B8,$00,$28,$01
    db $A8,$00,$78,$00,$28,$0D,$08,$04
    db $78,$0D,$08,$01,$C8,$0D,$48,$01
    db $C8,$0D,$48,$09,$18,$0B,$78,$0D
    db $68,$02,$C8,$0D,$28,$0D

DATA_0484D3:
    db $48,$01,$B8,$00,$38,$00,$18,$00
    db $98,$00,$98,$00,$D8,$01,$78,$00
    db $38,$00,$08,$01,$E8,$00,$78,$01
    db $88,$01,$28,$01,$88,$01,$E8,$00
    db $68,$01,$F8,$00,$88,$01,$08,$01
    db $D8,$01,$38,$00,$38,$01,$88,$01
    db $78,$00,$D8,$01,$D8,$01

CODE_048509:
    LDY.W PlayerTurnLvl                       ; \ Get current player's submap
    LDA.W OWPlayerSubmap,Y                    ; /
    STA.B _1                                  ; Store it in $01
    STZ.B _0                                  ; Store x00 in $00
    REP #$20                                  ; A->16
    LDX.W PlayerTurnOW                        ; Set X to Current character*4
    LDY.B #$34                                ; Set Y to x34
CODE_04851A:
    LDA.W DATA_048431,Y
    EOR.B _0
    CMP.W #$0200
    BCS CODE_048531
    CMP.W OWPlayerXPosPtr,X
    BNE CODE_048531
    LDA.W OWPlayerYPosPtr,X
    CMP.W DATA_048467,Y
    BEQ CODE_048535
CODE_048531:
    DEY
    DEY
    BPL CODE_04851A
CODE_048535:
    STY.W StarWarpIndex                       ; Store Y in "Warp destination"
    SEP #$20                                  ; A->8
    RTS

CODE_04853B:
    PHB
    PHK
    PLB
    REP #$20                                  ; A->16
    LDX.W PlayerTurnOW
    LDY.W StarWarpIndex
    LDA.W DATA_04849D,Y
    PHA
    AND.W #$01FF
    STA.W OWPlayerXPos,X
    LSR A
    LSR A
    LSR A
    LSR A
    STA.W OWPlayerXPosPtr,X
    LDA.W DATA_0484D3,Y
    STA.W OWPlayerYPos,X
    LSR A
    LSR A
    LSR A
    LSR A
    STA.W OWPlayerYPosPtr,X
    PLA
    LSR A
    XBA
    AND.W #$000F
    STA.W CurrentSubmap
    REP #$10                                  ; XY->16
    JSR CODE_049A93
    SEP #$30                                  ; AXY->8
    PLB
    RTL

CODE_048576:
    LDA.W OverworldProcess
    JSL ExecutePtrLong

    dl CODE_048EF1
    dl CODE_04E570
    dl CODE_048F87
    dl CODE_049120
    dl CODE_04945D
    dl CODE_049D9A
    dl CODE_049E22
    dl CODE_049DD1
    dl CODE_049E22
    dl CODE_049E4C
    dl CODE_04DAEF
    dl CODE_049E52
    dl CODE_0498C6

DrawOWBoarder_:
    JSR CODE_04862E
CODE_0485A7:
    REP #$20                                  ; A->16
    LDA.W #$001E                              ; \ Mario X postion = #$001E
    CLC                                       ; | (On overworld boarder)
    ADC.B Layer1XPos                          ; |
    STA.B PlayerXPosNext                      ; /
    LDA.W #$0006                              ; \ Mario Y postion = #$0006
    CLC                                       ; | (On overworld boarder)
    ADC.B Layer1YPos                          ; |
    STA.B PlayerYPosNext                      ; /
    SEP #$20                                  ; A->8
    LDA.B #$08
    STA.W PlayerXSpeed+1
    PHB
    LDA.B #$00
    PHA
    PLB
    JSL CODE_00CEB1
    PLB
    LDA.B #$03
    STA.W PlayerBehindNet
    JSL DrawMarioAndYoshi
    LDA.B #$06
    STA.W PlayerGfxTileCount
    LDA.W PlayerAniTimer
    BEQ +
    DEC.W PlayerAniTimer
  + LDA.W CapeAniTimer
    BEQ +
    DEC.W CapeAniTimer
  + LDA.B #$18
    STA.B _0
    LDA.B #$07
    STA.B _1
    LDY.B #$00
    TYX
CODE_0485F3:
    LDA.B _0
    STA.W OAMTileXPos,X
    CLC
    ADC.B #$08
    STA.B _0
    LDA.B _1
    STA.W OAMTileYPos,X
    LDA.B #$7E
    STA.W OAMTileNo,X
    LDA.B #$36
    STA.W OAMTileAttr,X
    PHX
    TYX
    LDA.B #$00
    STA.W OAMTileSize,X
    PLX
    INY
    TYA
    AND.B #$03
    BNE +
    LDA.B #$18
    STA.B _0
    LDA.B _1
    CLC
    ADC.B #$08
    STA.B _1
  + INX
    INX
    INX
    INX
    CPY.B #$10
    BNE CODE_0485F3
    RTS

CODE_04862E:
    REP #$30                                  ; AXY->16
    LDX.W PlayerTurnOW                        ; X = player x 4
    LDA.W OWPlayerXPos,X                      ; A = player X-pos on OW
    SEC
    SBC.B Layer1XPos                          ; A = X-pos on screen
    CMP.W #$0100
    BCS CODE_04864D                           ; \ if < #$0100
    STA.B _0                                  ; | $00 = X-pos on screen
    STA.B _8                                  ; | $08 = X-pos on screen
    LDA.W OWPlayerYPos,X                      ; | A = player Y-pos on OW
    SEC                                       ; |
    SBC.B Layer1YPos                          ; | A = Y-pos on screen
    CMP.W #$0100                              ; |
    BCC +                                     ; /
CODE_04864D:
    LDA.W #$00F0                              ; \
  + STA.B _2                                  ; | $02 = Y-pos on screen
    STA.B _A                                  ; / $0A = Y-pos on screen
    TXA                                       ; A = player x 4
    EOR.W #$0004                              ; A = other player x 4
    TAX                                       ; X = other player x 4
    LDA.W OWPlayerXPos,X                      ; \
    SEC                                       ; | (same as above, but for luigi)
    SBC.B Layer1XPos                          ; |
    CMP.W #$0100                              ; |
    BCS CODE_048673                           ; |
    STA.B _4                                  ; | $04 = X-pos on screen
    STA.B _C                                  ; | $0C = X-pos on screen
    LDA.W OWPlayerYPos,X                      ; |
    SEC                                       ; |
    SBC.B Layer1YPos                          ; |
    CMP.W #$0100                              ; |
    BCC +                                     ; |
CODE_048673:
    LDA.W #$00F0                              ; |
  + STA.B _6                                  ; | $06 = Y-pos on screen
    STA.B _E                                  ; / $0E = Y-pos on screen
    SEP #$30                                  ; AXY->8
    LDA.B _0
    SEC
    SBC.B #$08                                ; subtract 8 from 1P X-pos
    STA.B _0                                  ; $00 = 1P X-pos on screen
    LDA.B _2
    SEC
    SBC.B #$09                                ; subtract 9 from 1P Y-pos
    STA.B _1                                  ; $01 = 1P Y-pos on screen
    LDA.B _4
    SEC
    SBC.B #$08                                ; subtract 8 from 2P X-pos
    STA.B _2                                  ; $02 = 2P X-pos on screen
    LDA.B _6
    SEC
    SBC.B #$09                                ; subtract 9 from 2P Y-pos
    STA.B _3                                  ; $03 = 2P Y-pos on screen
    LDA.B #$03
    STA.B GraphicsCompPtr+2                   ; $8C = #$03
    LDA.B _0
    STA.B _6                                  ; $06 = 1P X-pos on screen
    STA.B GraphicsCompPtr                     ; $8A = 1P X-pos on screen
    LDA.B _1
    STA.B _7                                  ; $07 = 1P Y-pos on screen
    STA.B GraphicsCompPtr+1                   ; $8B = 1P Y-pos on screen
    LDA.W PlayerTurnOW                        ; A = player x 4
    LSR A                                     ; A = player x 2
    TAY                                       ; Y = player x 2
    LDA.W OWPlayerAnimation,Y                 ; A = player OW animation type
    CMP.B #$12
    BEQ CODE_0486C5                           ; skip if enter level in water animation
    CMP.B #$07
    BCC CODE_0486BC                           ; don't skip if moving on land
    CMP.B #$0F
    BCC CODE_0486C5                           ; skip if moving in water
CODE_0486BC:
    LDA.B GraphicsCompPtr+1
    SEC
    SBC.B #$05                                ; subtract 5 from Y-pos if on land
    STA.B GraphicsCompPtr+1                   ; $8B = 1P Y-pos on screen
    STA.B _7                                  ; $07 = 1P Y-pos on screen
CODE_0486C5:
    REP #$30                                  ; AXY->16
    LDA.W PlayerTurnOW                        ; A = player x 4
    XBA                                       ; A = player x #$400
    LSR A                                     ; A = player x #$200
    STA.B _4                                  ; $04 = player x #$200
    LDX.W #$0000                              ; X = #$0000
    JSR CODE_048789                           ; draw halo if out of lives
    LDA.W PlayerTurnOW                        ; A = player x 4
    LSR A                                     ; A = player x 2
    TAY                                       ; Y = player x 2
    LDX.W #$0000                              ; X = #$0000
    JSR CODE_04894F
    SEP #$30                                  ; AXY->8
    STZ.W OAMTileSize+$27                     ; \
    STZ.W OAMTileSize+$28                     ; | make OAM tiles 8x8
    STZ.W OAMTileSize+$29                     ; |
    STZ.W OAMTileSize+$2A                     ; |
    STZ.W OAMTileSize+$2B                     ; |
    STZ.W OAMTileSize+$2C                     ; |
    STZ.W OAMTileSize+$2D                     ; |
    STZ.W OAMTileSize+$2E                     ; /
    LDA.B #$03
    STA.B GraphicsCompPtr+2                   ; $8C = #$03
    LDA.W OWPlayerSubmap                      ; A = 1P submap
    LDY.W OverworldProcess                    ; Y = overworld process
    CPY.B #$0A
    BNE +
    EOR.B #$01                                ; ??
  + CMP.W OWPlayerSubmap+1
    BNE CODE_048786                           ; skip everything if 1P and 2P are on different submaps
    LDA.B _2
    STA.B _6                                  ; $06 = 2P X-pos on screen
    STA.B GraphicsCompPtr                     ; $8A = 2P X-pos on screen
    LDA.B _3
    STA.B _7                                  ; $07 = 2P Y-pos on screen
    STA.B GraphicsCompPtr+1                   ; $8B = 2P Y-pos on screen
    LDA.W PlayerTurnOW                        ; A = player x 4
    LSR A                                     ; A = player x 2
    EOR.B #$02                                ; A = other player x 2
    TAY                                       ; Y = other player x 2
    LDA.W OWPlayerAnimation,Y                 ; A = other player OW animation type
    CMP.B #$12
    BEQ CODE_048739                           ; skip if enter level in water animation
    CMP.B #$07
    BCC CODE_048730                           ; don't skip if moving on land
    CMP.B #$0F
    BCC CODE_048739                           ; skip if moving in water
CODE_048730:
    LDA.B GraphicsCompPtr+1
    SEC
    SBC.B #$05                                ; subtract 5 from Y-pos if on land
    STA.B GraphicsCompPtr+1                   ; $8B = 2P Y-pos on screen
    STA.B _7                                  ; $07 = 2P Y-pos on screen
CODE_048739:
    REP #$30                                  ; AXY->16
    LDA.W IsTwoPlayerGame
    AND.W #$00FF
    BEQ CODE_048786                           ; skip everything if we are in a 1P-game (why check that so late?)
    LDA.B _C
    CMP.W #$00F0
    BCS CODE_048786                           ; skip if 2P is offscreen in the X direction
    LDA.B _E
    CMP.W #$00F0
    BCS CODE_048786                           ; skip if 2P is offscreen in the Y direction
    LDA.B _4                                  ; A = player x #$200
    EOR.W #$0200                              ; A = other player x #$200
    STA.B _4                                  ; $04 = other player x #$200
    LDX.W #$0020                              ; X = #$0020
    JSR CODE_048789                           ; draw halo if out of lives
    LDA.W PlayerTurnOW                        ; A = player x 4
    LSR A                                     ; A = player x 2
    EOR.W #$0002                              ; A = other player x 2
    TAY                                       ; Y = other player x 2
    LDX.W #$0020                              ; X = #$0020
    JSR CODE_04894F
    SEP #$30                                  ; AXY->8
    STZ.W OAMTileSize+$2F                     ; \
    STZ.W OAMTileSize+$30                     ; | make OAM tiles 8x8
    STZ.W OAMTileSize+$31                     ; |
    STZ.W OAMTileSize+$32                     ; |
    STZ.W OAMTileSize+$33                     ; |
    STZ.W OAMTileSize+$34                     ; |
    STZ.W OAMTileSize+$35                     ; |
    STZ.W OAMTileSize+$36                     ; /
CODE_048786:
    SEP #$30                                  ; AXY->8
    RTS

CODE_048789:
    LDA.B GraphicsCompPtr                     ; A = Y-pos on screen | X-pos on screen
    PHA
    PHX                                       ; X = player x #$20
    LDA.B _4                                  ; A = player x #$200
    XBA                                       ; A = player x 2
    LSR A                                     ; A = player
    TAX                                       ; X = player
    LDA.W SavedPlayerLives-1,X                ; A = player lives | junk
    PLX                                       ; X = player x #$20
    AND.W #$FF00                              ; A = player lives | #$00
    BPL +                                     ; skip if player lives positive
    SEP #$20                                  ; A->8
    LDA.B GraphicsCompPtr
    STA.W OAMTileXPos+$B4,X                   ; OAM X-pos of 1st halo tile
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$B8,X                   ; OAM X-pos of 2nd halo tile
    LDA.B GraphicsCompPtr+1
    CLC
    ADC.B #$F9
    STA.W OAMTileYPos+$B4,X                   ; OAM Y-pos of 1st halo tile
    STA.W OAMTileYPos+$B8,X                   ; OAM Y-pos of 2nd halo tile
    LDA.B #$7C
    STA.W OAMTileNo+$B4,X                     ; OAM tile number of 1st halo tile
    STA.W OAMTileNo+$B8,X                     ; OAM tile number of 2nd halo tile
    LDA.B #$20
    STA.W OAMTileAttr+$B4,X                   ; OAM yxppccct of 1st halo tile
    LDA.B #$60
    STA.W OAMTileAttr+$B8,X                   ; OAM yxppccct of 2nd halo tile
    REP #$20                                  ; A->16
  + PLA                                       ; A = Y-pos on screen | X-pos on screen
    STA.B GraphicsCompPtr                     ; $8A = X-pos on screen, $8B = Y-pos on screen
    RTS


OWPlayerTiles:
    db $0E,$24,$0F,$24,$1E,$24,$1F,$24
    db $20,$24,$21,$24,$30,$24,$31,$24
    db $0E,$24,$0F,$24,$1E,$24,$1F,$24
    db $20,$24,$21,$24,$31,$64,$30,$64
    db $0A,$24,$0B,$24,$1A,$24,$1B,$24
    db $0C,$24,$0D,$24,$1C,$24,$1D,$24
    db $0A,$24,$0B,$24,$1A,$24,$1B,$24
    db $0C,$24,$0D,$24,$1D,$64,$1C,$64
    db $08,$24,$09,$24,$18,$24,$19,$24
    db $06,$24,$07,$24,$16,$24,$17,$24
    db $08,$24,$09,$24,$18,$24,$19,$24
    db $06,$24,$07,$24,$16,$24,$17,$24
    db $09,$64,$08,$64,$19,$64,$18,$64
    db $07,$64,$06,$64,$17,$64,$16,$64
    db $09,$64,$08,$64,$19,$64,$18,$64
    db $07,$64,$06,$64,$17,$64,$16,$64
    db $0E,$24,$0F,$24,$38,$24,$38,$64
    db $20,$24,$21,$24,$39,$24,$39,$64
    db $0E,$24,$0F,$24,$38,$24,$38,$64
    db $20,$24,$21,$24,$39,$24,$39,$64
    db $0A,$24,$0B,$24,$38,$24,$38,$64
    db $0C,$24,$0D,$24,$39,$24,$39,$64
    db $0A,$24,$0B,$24,$38,$24,$38,$64
    db $0C,$24,$0D,$24,$39,$24,$39,$64
    db $08,$24,$09,$24,$38,$24,$38,$64
    db $06,$24,$07,$24,$39,$24,$39,$64
    db $08,$24,$09,$24,$38,$24,$38,$64
    db $06,$24,$07,$24,$39,$24,$39,$64
    db $09,$64,$08,$64,$38,$24,$38,$64
    db $07,$64,$06,$64,$39,$24,$39,$64
    db $09,$64,$08,$64,$38,$24,$38,$64
    db $07,$64,$06,$64,$39,$24,$39,$64
    db $24,$24,$25,$24,$34,$24,$35,$24
    db $24,$24,$25,$24,$34,$24,$35,$24
    db $24,$24,$25,$24,$34,$24,$35,$24
    db $24,$24,$25,$24,$34,$24,$35,$24
    db $24,$24,$25,$24,$38,$24,$38,$64
    db $24,$24,$25,$24,$38,$24,$38,$64
    db $24,$24,$25,$24,$38,$24,$38,$64
    db $24,$24,$25,$24,$38,$24,$38,$64
    db $46,$24,$47,$24,$56,$24,$57,$24
    db $47,$64,$46,$64,$57,$64,$56,$64
    db $46,$24,$47,$24,$56,$24,$57,$24
    db $47,$64,$46,$64,$57,$64,$56,$64
    db $46,$24,$47,$24,$56,$24,$57,$24
    db $47,$64,$46,$64,$57,$64,$56,$64
    db $46,$24,$47,$24,$56,$24,$57,$24
    db $47,$64,$46,$64,$57,$64,$56,$64
OWWarpIndex:
    db $20,$60,$00,$40

CODE_04894F:
    SEP #$30                                  ; AXY->8
    PHY                                       ; Y = player x 2
    TYA                                       ; A = player x 2
    LSR A                                     ; A = player
    TAY                                       ; Y = player
    LDA.W SavedPlayerYoshi,Y                  ; A = player's yoshi color
    BEQ +                                     ; branch if no yoshi
    STA.B _E                                  ; $0E = player's yoshi color
    STZ.B _F                                  ; $0F = #$00
    PLY                                       ; Y = player x 2
    JMP CODE_048CE6                           ; jump

  + PLY                                       ; Y = player x 2
    REP #$30                                  ; AXY->16
    LDA.W OWPlayerAnimation,Y                 ; A = player OW animation type
    ASL A
    ASL A
    ASL A
    ASL A                                     ; A = player OW animation type x #$10
    STA.B _0                                  ; $00 = player OW animation type x #$10
    LDA.B TrueFrame                           ; A = frame counter
    AND.W #$0018                              ; A = 5 LSB of frame counter
    CLC
    ADC.B _0                                  ; A = 0000 000a aaaf ffff (a = animation type, f = 5 LSB of frame counter)
    TAY                                       ; Y = that index ^
    PHX                                       ; X = player x #$20
    LDA.B _4                                  ; A = player x #$200
    XBA                                       ; A = player x 2
    LSR A                                     ; A = player
    TAX                                       ; X = player
    LDA.W SavedPlayerLives-1,X                ; A = player's lives | junk
    PLX                                       ; X = player x #$20
    AND.W #$FF00                              ; A = player's lives | #$00
    BPL CODE_04898B                           ; branch if player's lives positive
    LDA.B _0                                  ; A = player OW animation type x #$10
    TAY                                       ; Y = player OW animation type x #$10
    BRA CODE_0489A7                           ; branch (basically, if player is out of lives, their sprite is static)

CODE_04898B:
    CPX.W #$0000
    BNE CODE_0489A7                           ; skip if 2P
    LDA.W OverworldProcess
    CMP.W #$000B
    BNE CODE_0489A7                           ; skip if not on star warp
    LDA.B TrueFrame                           ; A = frame counter
    AND.W #$000C                              ; A = 0000 ff00 (f = frame counter bits)
    LSR A
    LSR A                                     ; A = 2 LSB of frame counter / 4
    TAY                                       ; Y = 2 LSB of frame counter / 4
    LDA.W OWWarpIndex,Y                       ; A = index to use when using a star warp (overrides that complicated thing)
    AND.W #$00FF
    TAY                                       ; Y = index into tilemap table
CODE_0489A7:
    REP #$20                                  ; A->16
    LDA.B GraphicsCompPtr                     ; A = Y-pos on screen | X-pos on screen
    STA.W OAMTileXPos+$9C,X                   ; OAM y-pos and x-pos for tile
    LDA.W OWPlayerTiles,Y                     ; get tile | yxppccct
    CLC
    ADC.B _4                                  ; add player x #$200 (increment palette of tile by 1)
    STA.W OAMTileNo+$9C,X                     ; OAM tile and yxppccct for tile
    SEP #$20                                  ; A->8
    INX
    INX
    INX
    INX                                       ; increment X to next OAM tile
    INY
    INY                                       ; increment index to tilemap table
    LDA.B GraphicsCompPtr
    CLC
    ADC.B #$08                                ; \
    STA.B GraphicsCompPtr                     ; | update X and Y position of tile
    DEC.B GraphicsCompPtr+2                   ; | (zig zag pattern)
    LDA.B GraphicsCompPtr+2                   ; |
    AND.B #$01                                ; |
    BEQ +                                     ; |
    LDA.B _6                                  ; |
    STA.B GraphicsCompPtr                     ; |
    LDA.B GraphicsCompPtr+1                   ; |
    CLC                                       ; |
    ADC.B #$08                                ; |
    STA.B GraphicsCompPtr+1                   ; /
  + LDA.B GraphicsCompPtr+2
    BPL CODE_0489A7                           ; loop if we have tiles left
    RTS


DATA_0489DE:
    db $66,$24,$67,$24,$76,$24,$77,$24
    db $2F,$62,$2E,$62,$3F,$62,$3E,$62
    db $66,$24,$67,$24,$76,$24,$77,$24
    db $2E,$22,$2F,$22,$3E,$22,$3F,$22
    db $2F,$62,$2E,$62,$3F,$62,$3E,$62
    db $0A,$24,$0B,$24,$1A,$24,$1B,$24
    db $2E,$22,$2F,$22,$3E,$22,$3F,$22
    db $0A,$24,$0B,$24,$1A,$24,$1B,$24
    db $64,$24,$65,$24,$74,$24,$75,$24
    db $40,$22,$41,$22,$50,$22,$51,$22
    db $64,$24,$65,$24,$74,$24,$75,$24
    db $42,$22,$43,$24,$52,$24,$53,$24
    db $65,$64,$64,$64,$75,$64,$74,$64
    db $41,$62,$40,$62,$51,$62,$50,$62
    db $65,$64,$64,$64,$75,$64,$74,$64
    db $43,$62,$42,$62,$53,$62,$52,$62
    db $38,$24,$38,$64,$66,$24,$67,$24
    db $76,$24,$77,$24,$FF,$FF,$FF,$FF
    db $39,$24,$39,$64,$66,$24,$67,$24
    db $76,$24,$77,$24,$FF,$FF,$FF,$FF
    db $38,$24,$38,$64,$2F,$62,$2E,$62
    db $0A,$24,$0B,$24,$1A,$24,$1B,$24
    db $39,$24,$39,$24,$2E,$22,$2F,$22
    db $0A,$24,$0B,$24,$1A,$24,$1B,$24
    db $38,$24,$38,$64,$64,$24,$65,$24
    db $74,$24,$75,$24,$40,$22,$41,$22
    db $39,$24,$39,$64,$64,$24,$65,$24
    db $74,$24,$75,$24,$42,$22,$42,$22
    db $38,$24,$38,$64,$65,$64,$64,$64
    db $75,$64,$74,$64,$41,$62,$40,$62
    db $39,$24,$39,$64,$65,$64,$64,$64
    db $75,$64,$74,$64,$43,$62,$42,$62
    db $2F,$62,$2E,$62,$3F,$62,$3E,$62
    db $24,$24,$25,$24,$34,$24,$35,$24
    db $2E,$22,$2F,$22,$3E,$22,$3F,$22
    db $24,$24,$25,$24,$34,$24,$35,$24
    db $38,$24,$38,$64,$2F,$62,$2E,$62
    db $24,$24,$25,$24,$34,$24,$35,$24
    db $39,$24,$39,$64,$2E,$22,$2F,$22
    db $24,$24,$25,$24,$34,$24,$35,$24
    db $66,$24,$67,$24,$76,$24,$77,$24
    db $2F,$62,$2E,$62,$3F,$62,$3E,$62
    db $66,$24,$67,$24,$76,$24,$77,$24
    db $2E,$22,$2F,$22,$3E,$22,$3F,$22
    db $66,$24,$67,$24,$76,$24,$77,$24
    db $2F,$62,$2E,$62,$3F,$62,$3E,$62
    db $66,$24,$67,$24,$76,$24,$77,$24
    db $2E,$22,$2F,$22,$3E,$22,$3F,$22
DATA_048B5E:
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $07,$0F,$07,$0F,$00,$08,$00,$08
    db $07,$0F,$07,$0F,$00,$08,$00,$08
    db $F9,$01,$F9,$01,$00,$08,$00,$08
    db $F9,$01,$F9,$01,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$07,$0F,$07,$0F,$00,$08
    db $00,$08,$07,$0F,$07,$0F,$00,$08
    db $00,$08,$F9,$01,$F9,$01,$00,$08
    db $00,$08,$F9,$01,$F9,$01,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
    db $00,$08,$00,$08,$00,$08,$00,$08
DATA_048C1E:
    db $FB,$FB,$03,$03,$00,$00,$08,$08
    db $FA,$FA,$02,$02,$00,$00,$08,$08
    db $00,$00,$08,$08,$F8,$F8,$00,$00
    db $00,$00,$08,$08,$F9,$F9,$01,$01
    db $FC,$FC,$04,$04,$00,$00,$08,$08
    db $FB,$FB,$03,$03,$00,$00,$08,$08
    db $FC,$FC,$04,$04,$00,$00,$08,$08
    db $FB,$FB,$03,$03,$00,$00,$08,$08
    db $08,$08,$FB,$FB,$03,$03,$00,$00
    db $08,$08,$FA,$FA,$02,$02,$00,$00
    db $08,$08,$00,$00,$F8,$F8,$00,$00
    db $08,$08,$00,$00,$F9,$F9,$01,$01
    db $08,$08,$FC,$FC,$04,$04,$00,$00
    db $08,$08,$FB,$FB,$03,$03,$00,$00
    db $08,$08,$FC,$FC,$04,$04,$00,$00
    db $08,$08,$FB,$FB,$03,$03,$00,$00
    db $00,$00,$08,$08,$F8,$F8,$00,$00
    db $00,$00,$08,$08,$F8,$F8,$00,$00
    db $08,$08,$00,$00,$F8,$F8,$00,$00
    db $08,$08,$00,$00,$F8,$F8,$00,$00
    db $FB,$FB,$03,$03,$00,$00,$08,$08
    db $FA,$FA,$02,$02,$00,$00,$08,$08
    db $FB,$FB,$03,$03,$00,$00,$08,$08
    db $FA,$FA,$02,$02,$00,$00,$08,$08
DATA_048CDE:
    db $00,$00,$00,$02,$00,$04,$00,$06

CODE_048CE6:
    LDA.B #$07
    STA.B GraphicsCompPtr+2                   ; $8C = #$07
    REP #$30                                  ; AXY->16
    LDA.W OWPlayerAnimation,Y
    ASL A
    ASL A
    ASL A
    ASL A
    STA.B _0
    LDA.B TrueFrame
    AND.W #$0008
    ASL A
    CLC
    ADC.B _0
    TAY                                       ; Y = 0000 000a aaaf ffff (a = animation type, f = 5 LSB of frame counter)
    CPX.W #$0000
    BNE CODE_048D1B                           ; skip if not 1P
    LDA.W OverworldProcess
    CMP.W #$000B
    BNE CODE_048D1B                           ; skip if not star warp
    LDA.B TrueFrame
    AND.W #$000C
    LSR A
    LSR A
    TAY                                       ; Y = 2 LSB of frame counter / 4
    LDA.W OWWarpIndex,Y
    AND.W #$00FF
    TAY                                       ; Y = index into tilemap table
CODE_048D1B:
    REP #$20                                  ; A->16
    PHY                                       ; Y = index into tilemap table
    TYA                                       ; A = index into tilemap table
    LSR A                                     ; / 2
    TAY                                       ; Y = index into tilemap table / 2
    SEP #$20                                  ; A->8
    LDA.W DATA_048B5E,Y                       ; X offset table for riding yoshi sprites
    CLC
    ADC.B GraphicsCompPtr
    STA.W OAMTileXPos+$9C,X                   ; OAM X-position
    LDA.W DATA_048C1E,Y                       ; Y offset table for riding yoshi sprites
    CLC
    ADC.B GraphicsCompPtr+1
    STA.W OAMTileYPos+$9C,X                   ; OAM Y-position
    PLY
    REP #$20                                  ; A->16
    LDA.W DATA_0489DE,Y
    CMP.W #$FFFF
    BEQ CODE_048D67
    PHA
    AND.W #$0F00
    CMP.W #$0200
    BNE CODE_048D5E
    STY.B _8
    LDA.B _E
    SEC
    SBC.W #$0004
    TAY
    PLA
    AND.W #$F0FF
    ORA.W DATA_048CDE,Y
    PHA
    LDY.B _8
    BRA +

CODE_048D5E:
    PLA
    CLC
    ADC.B _4
    PHA
  + PLA
    STA.W OAMTileNo+$9C,X
CODE_048D67:
    SEP #$20                                  ; A->8
    INX
    INX
    INX
    INX
    INY
    INY
    DEC.B GraphicsCompPtr+2
    BPL CODE_048D1B
    RTS


DATA_048D74:
    db $0B,$00,$13,$00,$1A,$00,$1B,$00
    db $1F,$00,$20,$00,$31,$00,$32,$00
    db $34,$00,$35,$00,$40,$00

OverworldMusic:
    db !BGM_DONUTPLAINS
    db !BGM_YOSHISISLAND
    db !BGM_VANILLADOME
    db !BGM_FORESTOFILLUSION
    db !BGM_VALLEYOFBOWSER
    db !BGM_SPECIALWORLD
    db !BGM_STARWORLD

CODE_048D91:
    PHB
    PHK
    PLB
    STZ.W SwapOverworldMusic
    LDA.B #$0F
    STA.W Layer1ScrollXPosUpd
    LDX.B #$02
    LDA.W OWPlayerAnimation
    CMP.B #$12
    BEQ CODE_048DA9
    AND.B #$08
    BEQ +
CODE_048DA9:
    LDX.B #$0A
  + STX.W OWPlayerAnimation
    LDX.B #$02
    LDA.W OWPlayerAnimation+2
    CMP.B #$12
    BEQ CODE_048DBB
    AND.B #$08
    BEQ +
CODE_048DBB:
    LDX.B #$0A
  + STX.W OWPlayerAnimation+2
    SEP #$10                                  ; XY->8
    JSR CODE_048E55
    REP #$30                                  ; AXY->16
    LDA.W OWLevelExitMode-1
    AND.W #$FF00
    BEQ CODE_048DDF
    BMI CODE_048DDF
    LDA.W TranslevelNo
    AND.W #$00FF
    CMP.W #$0018
    BNE CODE_048DDF
    BRL CODE_048E34
CODE_048DDF:
    LDA.W CutsceneID
    AND.W #$00FF
    BEQ CODE_048E38
    LDA.W CutsceneID
    AND.W #$FF00
    STA.W CutsceneID
if ver_is_english(!_VER)                      ;\================ U, SS, E0, & E1 ==============
    SEP #$10                                  ;! XY->8
    LDX.W PlayerTurnOW                        ;! this code block prevents the music from
    LDA.W OWPlayerXPos,X                      ;! being disabled after beating a boss for
    LSR A                                     ;! a second time
    LSR A                                     ;!
    LSR A                                     ;!
    LSR A                                     ;!
    STA.B _0                                  ;!
    LDA.W OWPlayerYPos,X                      ;!
    LSR A                                     ;!
    LSR A                                     ;!
    LSR A                                     ;!
    LSR A                                     ;!
    STA.B _2                                  ;!
    TXA                                       ;!
    LSR A                                     ;!
    LSR A                                     ;!
    TAX                                       ;!
    JSR OW_TilePos_Calc                       ;!
    REP #$10                                  ;! XY->16
    LDX.B _4                                  ;!
    LDA.L OWLayer1Translevel,X                ;!
    AND.W #$00FF                              ;!
    TAX                                       ;!
    LDA.W OWLevelTileSettings,X               ;!
    AND.W #$0080                              ;!
    BNE CODE_048E38                           ;!
endif                                         ;/===============================================
    LDY.W #$0014
CODE_048E25:
    LDA.W TranslevelNo
    AND.W #$00FF
    CMP.W DATA_048D74,Y
    BEQ CODE_048E38
    DEY
    DEY
    BPL CODE_048E25
CODE_048E34:
    SEP #$30                                  ; AXY->8
    BRA +

CODE_048E38:
    SEP #$30                                  ; AXY->8
    LDX.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,X
    TAX
    LDA.W OverworldMusic,X
    STA.W SPCIO2                              ; / Change music
  + PLB
    RTL


DATA_048E49:
    db $28,$01,$00,$00,$88,$01

DATA_048E4F:
    db $C8,$01,$00,$00,$D8,$01

CODE_048E55:
    REP #$30                                  ; AXY->16
    LDA.W PlayerTurnLvl
    AND.W #$00FF
    ASL A
    ASL A
    STA.W PlayerTurnOW
    LDX.W PlayerTurnOW
    LDA.W OWPlayerXPosPtr,X
    STA.B _0
    LDA.W OWPlayerYPosPtr,X
    STA.B _2
    TXA
    LSR A
    LSR A
    TAX
    JSR OW_TilePos_Calc
    STZ.B _0
    LDX.B _4
    LDA.L OWLayer1Translevel,X
    AND.W #$00FF
    ASL A
    TAX
    LDA.W LevelNames,X
    STA.B _0
    JSR CODE_049D07
    LDX.B _4
    BMI +
    CPX.W #$0800
    BCS +
    LDA.L Map16TilesLow,X
    AND.W #$00FF
    STA.W OverworldLayer1Tile
  + SEP #$30                                  ; AXY->8
    LDX.W EnterLevelAuto
    BEQ CODE_048EE1
    BPL ADDR_048ED9
    TXA
    AND.B #$7F
    TAX
    STZ.W OWSpriteMisc0DF5,X
    LDA.W KoopaKidTile
    LDX.W OWLevelExitMode
    BPL ADDR_048ECD
    ASL A
    TAX
    REP #$20                                  ; A->16
    LDY.W PlayerTurnOW
    LDA.W DATA_048E49,X
    STA.W OWPlayerXPos,Y
    LDA.W DATA_048E4F,X
    STA.W OWPlayerYPos,Y
    SEP #$20                                  ; A->8
    BRA CODE_048EE1

ADDR_048ECD:
    TAX
    LDA.W DATA_04FB85,X
    ORA.W KoopaKidActive
    STA.W KoopaKidActive
    BRA CODE_048EE1

ADDR_048ED9:
    LDA.W OWLevelExitMode
    BMI CODE_048EE1
    STZ.W OWSpriteNumber,X
CODE_048EE1:
    REP #$30                                  ; AXY->16
    JSR OWMoveScroll
    SEP #$30                                  ; AXY->8
    JSR DrawOWBoarder_
    JSR CODE_048086
    JMP OW_Tile_Animation

CODE_048EF1:
    LDA.B #$08
    STA.W KeepModeActive
    LDA.W OWPlayerSubmap
    CMP.B #$01
    BNE CODE_048F13
    LDA.W OWPlayerXPos
    CMP.B #$68
    BNE CODE_048F13
    LDA.W OWPlayerYPos
    CMP.B #$8E
    BNE CODE_048F13
    LDA.B #$0C
    STA.W OverworldProcess
    BRL CODE_048F7A
CODE_048F13:
    REP #$20                                  ; A->16
    LDX.W PlayerTurnOW
    LDA.W OWPlayerXPos,X
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _0
    LDA.W OWPlayerYPos,X
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _2
    TXA
    LSR A
    LSR A
    TAX
    JSR OW_TilePos_Calc
    REP #$10                                  ; XY->16
    SEP #$20                                  ; A->8
    LDA.W MidwayFlag
    BEQ CODE_048F56
    LDA.W OWLevelExitMode
    BEQ CODE_048F56
    BPL CODE_048F5F
    REP #$20                                  ; A->16
    LDX.B _4
    LDA.L OWLayer1Translevel,X
    AND.W #$00FF
    TAX
    LDA.W OWLevelTileSettings,X
    ORA.W #$0040
    STA.W OWLevelTileSettings,X
CODE_048F56:
    SEP #$20                                  ; A->8
    LDA.B #$05
    STA.W OverworldProcess
    BRA CODE_048F7A

CODE_048F5F:
    REP #$20                                  ; A->16
    LDX.B _4
    LDA.L OWLayer1Translevel,X
    AND.W #$00FF
    TAX
    LDA.W OWLevelTileSettings,X
    ORA.W #$0080
    AND.W #$FFBF
    STA.W OWLevelTileSettings,X
    INC.W OverworldProcess
CODE_048F7A:
    REP #$30                                  ; AXY->16
    JMP OWMoveScroll


DATA_048F7F:
    db $58,$59,$5D,$63,$77,$79,$7E,$80

CODE_048F87:
    JSR CODE_049903
if ver_is_console(!_VER)                      ;\================= J, U, E0, & E1 ==============
    LDX.B #$07                                ;!
CODE_048F8C:                                  ;!
    LDA.W OverworldLayer1Tile                 ;!
    CMP.W DATA_048F7F,X                       ;!
    BNE CODE_049000                           ;!
    LDX.B #$2C                                ;!
  - LDA.W OWEventsActivated,X                 ;!
    STA.W SaveDataBufferEvents,X              ;!
    DEX                                       ;!
    BPL -                                     ;!
    REP #$30                                  ;! AXY->16
    LDX.W PlayerTurnOW                        ;!
    TXA                                       ;!
    EOR.W #$0004                              ;!
    TAY                                       ;!
    LDA.W SaveDataBufferXPos,X                ;!
    STA.W SaveDataBufferXPos,Y                ;!
    LDA.W SaveDataBufferYPos,X                ;!
    STA.W SaveDataBufferYPos,Y                ;!
    LDA.W SaveDataBufferXPosPtr,X             ;!
    STA.W SaveDataBufferXPosPtr,Y             ;!
    LDA.W SaveDataBufferYPosPtr,X             ;!
    STA.W SaveDataBufferYPosPtr,Y             ;!
    TXA                                       ;!
    LSR A                                     ;!
    TAX                                       ;!
    EOR.W #$0002                              ;!
    TAY                                       ;!
    LDA.W SaveDataBufferAni,X                 ;!
    STA.W SaveDataBufferAni,Y                 ;!
    TXA                                       ;!
    SEP #$30                                  ;! AXY->8
    LSR A                                     ;!
    TAX                                       ;!
    EOR.B #$01                                ;!
    TAY                                       ;!
    LDA.W SaveDataBufferSubmap,X              ;!
    STA.W SaveDataBufferSubmap,Y              ;!
endif                                         ;/===============================================
    LDA.W OWLevelExitMode
    CMP.B #$E0
    BNE CODE_048FFB
    DEC.W KeepModeActive
    BMI +
    RTS

  + INC.W ShowSavePrompt
    JSR CODE_049037
    LDA.B #$02
    STA.W KeepModeActive
    LDA.B #$04
    STA.W OverworldProcess
    BRA CODE_049003

CODE_048FFB:
    INC.W ShowSavePrompt
    BRA CODE_049003

if ver_is_console(!_VER)                      ;\================ J, U, E0, & E1 ===============
CODE_049000:                                  ;!
    DEX                                       ;!
    BPL CODE_048F8C                           ;!
endif                                         ;/===============================================
CODE_049003:
    REP #$20                                  ; A->16
    STZ.B _6
    LDX.W PlayerTurnOW
    LDA.W OWPlayerXPos,X
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _0
    LDA.W OWPlayerYPos,X
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _2
    TXA
    LSR A
    LSR A
    TAX
    JSR OW_TilePos_Calc
    REP #$10                                  ; XY->16
    LDX.B _4
    LDA.L Map16TilesLow,X
    AND.W #$00FF
    STA.W OverworldLayer1Tile
    SEP #$30                                  ; AXY->8
    INC.W OverworldProcess
    RTS

CODE_049037:
    PHX
    PHY
    PHP
    SEP #$30                                  ; AXY->8
    LDA.W ShowSavePrompt
    BEQ CODE_049054
if ver_is_console(!_VER)                      ;\================= J, U, E0, & E1 ==============
    LDX.B #$5F                                ;!
  - LDA.W OWLevelTileSettings,X               ;!
    STA.W SaveDataBuffer,X                    ;!
    DEX                                       ;!
    BPL -                                     ;!
    STZ.W ShowSavePrompt                      ;!
    LDA.B #$05                                ;!
    STA.W OverworldPromptProcess              ;!
else                                          ;<======================== SS ===================
    LDX.B #$2C                                ;!
  - LDA.W OWEventsActivated,X                 ;!
    STA.W SaveDataBufferEvents,X              ;!
    DEX                                       ;!
    BPL -                                     ;!
    REP #$30                                  ;! AXY->16
    LDX.W PlayerTurnOW                        ;!
    TXA                                       ;!
    EOR.W #$0004                              ;!
    TAY                                       ;!
    LDA.W SaveDataBufferXPos,X                ;!
    STA.W SaveDataBufferXPos,Y                ;!
    LDA.W SaveDataBufferYPos,X                ;!
    STA.W SaveDataBufferYPos,Y                ;!
    LDA.W SaveDataBufferXPosPtr,X             ;!
    STA.W SaveDataBufferXPosPtr,Y             ;!
    LDA.W SaveDataBufferYPosPtr,X             ;!
    STA.W SaveDataBufferYPosPtr,Y             ;!
    TXA                                       ;!
    LSR A                                     ;!
    TAX                                       ;!
    EOR.W #$0002                              ;!
    TAY                                       ;!
    LDA.W SaveDataBufferAni,X                 ;!
    STA.W SaveDataBufferAni,Y                 ;!
    TXA                                       ;!
    SEP #$30                                  ;! AXY->8
    LSR A                                     ;!
    TAX                                       ;!
    EOR.B #$01                                ;!
    TAY                                       ;!
    LDA.W SaveDataBufferSubmap,X              ;!
    STA.W SaveDataBufferSubmap,Y              ;!
    LDX.B #$5F                                ;!
  - LDA.W OWLevelTileSettings,X               ;!
    STA.W SaveDataBuffer,X                    ;!
    DEX                                       ;!
    BPL -                                     ;!
    STZ.W ShowSavePrompt                      ;!
endif                                         ;/===============================================
CODE_049054:
    PLP
    PLY
    PLX
    RTS


DATA_049058:
    db $FF,$FF,$01,$00,$FF,$FF,$01,$00
DATA_049060:
    db $05,$03,$01,$00

DATA_049064:
    db $00,$00,$02,$00,$04,$00,$06,$00
DATA_04906C:
    db $28,$00,$08,$00,$14,$00,$36,$00
    db $3F,$00,$45,$00

HardCodedOWPaths:
    db $09,$15,$23,$1B,$43,$44,$24,$FF
    db $30,$31

DATA_049082:
    db $78,$01

DATA_049084:
    db $28,$01

OWHardCodedTiles:
OWPathDP2_DP1:
    db $10,$10,$1E,$19,$16,$66
OWPathDP1_DP2:
    db $16,$19,$1E,$10,$10,$66
OWPathCI3_CF:
    db $04,$04,$04,$58
OWPathCF_CI3:
    db $04,$04,$04,$66
OWPathFoI4_FoI2:
    db $04,$04,$04,$04,$04,$6A
OWPathFoI2_FoI4:
    db $04,$04,$04,$04,$04,$66
OWPathCI2_Pipe:
    db $1E,$19,$06,$09,$0F,$20,$1A,$21
    db $1A,$14,$19,$18,$1F,$17,$82
OWPathPipe_CI2:
    db $17,$1F,$18,$19,$14,$1A,$21,$1A
    db $20,$0F,$09,$06,$19,$1E,$66
OWPathStar_FD:
    db $04,$04,$58
OWPathFD_Star:
    db $04,$04,$5F

OWHardCodedDirs:
OWDirDP2_DP1:
    db $02,$02,$02,$02,$06,$06
OWDirDP1_DP2:
    db $04,$04,$00,$00,$00,$00
OWDirCI3_CF:
    db $04,$04,$04,$04
OWDirCF_CI3:
    db $06,$06,$06,$06
OWDirFoI4_FoI2:
    db $06,$06,$06,$06,$06,$06
OWDirFoI2_FoI4:
    db $04,$04,$04,$04,$04,$04
OWDirCI2_Pipe:
    db $02,$02,$06,$06,$00,$00,$00,$04
    db $00,$04,$04,$00,$04,$00,$04
OWDirPipe_CI2:
    db $06,$02,$06,$02,$06,$06,$02,$06
    db $02,$02,$02,$04,$04,$00,$00
OWDirStar_FD:
    db $06,$06,$06
OWDirFD_Star:
    db $04,$04,$04

DATA_04910E:
    db OWPathDP2_DP1-OWHardCodedTiles
    db OWPathDP1_DP2-OWHardCodedTiles
    db OWPathCI3_CF-OWHardCodedTiles
    db OWPathCF_CI3-OWHardCodedTiles
    db OWPathFoI4_FoI2-OWHardCodedTiles
    db OWPathFoI2_FoI4-OWHardCodedTiles
    db OWPathCI2_Pipe-OWHardCodedTiles
    db OWPathPipe_CI2-OWHardCodedTiles
    db OWPathStar_FD-OWHardCodedTiles
    db OWPathFD_Star-OWHardCodedTiles

DATA_049118:
    db $08,$00,$04,$00,$02,$00,$01,$00

CODE_049120:
    STZ.W PlayerSwitching
    LDY.W EnterLevelAuto
    BMI OWPU_NotOnPipe
    LDA.W OWLevelExitMode
    BMI CODE_049132
    BEQ CODE_049132
    BRL CODE_0491E9
CODE_049132:
    LDA.B byetudlrFrame
    AND.B #$20
    BRA +                                     ; Change to BEQ to enable below debug code

    LDA.W OverworldLayer1Tile                 ; \ Unreachable
    BEQ CODE_049165                           ; | Debug: Warp to star road from Yoshi's house
    CMP.B #$56                                ; |
    BEQ CODE_049165                           ; /
if ver_is_english(!_VER)                      ;\=============== U, SS, E0, & E1 ===============
  + LDA.B axlr0000Hold                        ;! \
    AND.B #$30                                ;! |If L and R aren't pressed,
    CMP.B #$30                                ;! |branch to OWPU_NoLR
    BNE +                                     ;! /
    LDA.W OverworldLayer1Tile                 ;! \
    CMP.B #$81                                ;! |If Mario is standing on Destroyed Castle,
    BEQ OWPU_EnterLevel                       ;! / branch to OWPU_EnterLevel
endif                                         ;/===============================================
  + LDA.B byetudlrFrame                       ; \
    ORA.B axlr0000Frame                       ; |If A, B, X or Y are pressed,
    AND.B #$C0                                ; |branch to OWPU_ABXY
    BNE OWPU_ABXY                             ; |Otherwise,
    BRL CODE_0491E9                           ; / branch to $91E9
OWPU_ABXY:
    STZ.W SwapOverworldMusic
    LDA.W OverworldLayer1Tile                 ; \
    CMP.B #$5F                                ; |If not standing on a star tile,
    BNE OWPU_NotOnStar                        ; / branch to OWPU_NotOnStar
CODE_049165:
    JSR CODE_048509
    BNE OWPU_IsOnPipeRTS
    STZ.W StarWarpLaunchSpeed                 ; Set "Fly away" speed to 0
    STZ.W StarWarpLaunchTimer                 ; Set "Stay on ground" timer to 0 (31 = Fly away)
    LDA.B #!SFX_FEATHER                       ; \ Star Road sound effect
    STA.W SPCIO0                              ; /
    LDA.B #$0B                                ; \ Activate star warp
    STA.W OverworldProcess                    ; /
    JMP CODE_049E52

OWPU_NotOnStar:
    LDA.W OverworldLayer1Tile                 ; \
    CMP.B #$82                                ; |If standing on Pipe#1 (unused),
    BEQ OWPU_IsOnPipe                         ; / branch to OWPU_IsOnPipe
    CMP.B #$5B                                ; \ If not standing on Pipe#2,
    BNE OWPU_NotOnPipe                        ; / branch to OWPU_NotOnPipe
OWPU_IsOnPipe:
    JSR CODE_048509
    BNE OWPU_IsOnPipeRTS
CODE_04918D:
    INC.W EnteringStarWarp
    STZ.W OWLevelExitMode                     ; Set auto-walk to 0
    LDA.B #$0B                                ; \ Fade to overworld
    STA.W GameMode                            ; /
OWPU_IsOnPipeRTS:
    RTS

OWPU_NotOnPipe:
    CMP.B #$81                                ; \
    BEQ CODE_0491E9                           ; |If standing on a tile >= (?) Destroyed Castle,
    BCS CODE_0491E9                           ; / branch to $91E9
OWPU_EnterLevel:
    LDA.W PlayerTurnOW                        ; \
    LSR A                                     ; |If current player is Luigi,
    AND.B #$02                                ; |change Luigi's animation in the following lines
    TAX                                       ; /
    LDY.B #$10                                ; \
    LDA.W OWPlayerAnimation,X                 ; |
    AND.B #$08                                ; |If Mario isn't swimming, use "raise hand" animation
    BEQ +                                     ; |Otherwise, use "raise hand, swimming" animation
    LDY.B #$12                                ; |
  + TYA                                       ; |
    STA.W OWPlayerAnimation,X                 ; /
    LDX.W PlayerTurnLvl                       ; Get current character
    LDA.W SavedPlayerCoins,X                  ; \ Get character's coins
    STA.W PlayerCoins                         ; /
    LDA.W SavedPlayerLives,X                  ; \ Get character's lives
    STA.W PlayerLives                         ; /
    LDA.W SavedPlayerPowerup,X                ; \ Get character's powerup
    STA.B Powerup                             ; /
    LDA.W SavedPlayerYoshi,X                  ; \
    STA.W CarryYoshiThruLvls                  ; |Get character's Yoshi color
    STA.W YoshiColor                          ; |
    STA.W PlayerRidingYoshi                   ; /
    LDA.W SavedPlayerItembox,X                ; \ Get character's reserved item
    STA.W PlayerItembox                       ; /
    LDA.B #$02                                ; \ Related to fade speed
    STA.W KeepModeActive                      ; /
    LDA.B #!BGM_FADEOUT                       ; \ Music fade out
    STA.W SPCIO2                              ; /
    INC.W GameMode                            ; Fade to level
    RTS

CODE_0491E9:
    REP #$20                                  ; A->16
    LDX.W PlayerTurnOW                        ; Get current character * 4
    LDA.W OWPlayerXPos,X                      ; Get character's X coordinate
    LSR A                                     ; \
    LSR A                                     ; |Divide X coordinate by 16
    LSR A                                     ; |
    LSR A                                     ; /
    STA.B _0                                  ; \ Store in $00 and $1F1F,x
    STA.W OWPlayerXPosPtr,X                   ; /
    LDA.W OWPlayerYPos,X                      ; Get character's Y coordinate
    LSR A                                     ; \
    LSR A                                     ; |Divide Y coordinate by 16
    LSR A                                     ; |
    LSR A                                     ; /
    STA.B _2                                  ; \ Store in $02 and $1F21,x
    STA.W OWPlayerYPosPtr,X                   ; /
    TXA                                       ; \
    LSR A                                     ; |Divide (current character * 4) by 4
    LSR A                                     ; |
    TAX                                       ; /
    JSR OW_TilePos_Calc                       ; Calculate current tile pos
    SEP #$20                                  ; A->8
    LDX.W OWLevelExitMode                     ; \ If auto-walk=0,
    BEQ OWPU_NotAutoWalk                      ; / branch to OWPU_NotAutoWalk
    DEX
    LDA.W DATA_049060,X
    STA.B _8
    STZ.B _9
    REP #$30                                  ; AXY->16
    LDX.B _4                                  ; X = tile pos
    LDA.L OWLayer1Translevel,X                ; \ Get level number of current tile pos
    AND.W #$00FF                              ; /
    LDY.W #$000A
CODE_04922A:
    CMP.W DATA_04906C,Y
    BNE CODE_04923B
    LDA.W #$0005
    STA.W OverworldProcess
    JSR CODE_049037
    BRL CODE_049411
CODE_04923B:
    DEY
    DEY
    BPL CODE_04922A
    LDA.L OWLayer2Directions,X
    AND.W #$00FF
    LDX.B _8
    BEQ CODE_04924E
  - LSR A
    DEX
    BPL -
CODE_04924E:
    AND.W #$0003
    ASL A
    TAX
    LDA.W DATA_049064,X
    TAY
    JMP CODE_0492BC

OWPU_NotAutoWalk:
    SEP #$30                                  ; AXY->8
    STZ.W OWLevelExitMode                     ; Set auto-walk to 0
    LDA.B byetudlrFrame                       ; \
    AND.B #$0F                                ; |If no dir button is pressed (one frame),
    BEQ CODE_04926E                           ; / branch to $926E
    LDX.W OverworldLayer1Tile                 ; \
    CPX.B #$82                                ; |If standing on Pipe#2,
    BEQ CODE_0492AD                           ; |branch to $92AD
    BRA CODE_04928C                           ; / Otherwise, branch to $928C

CODE_04926E:
    DEC.W Layer1ScrollXPosUpd                 ; \ Decrease "Face walking dir" timer
    BPL +                                     ; / If >= 0, branch to $9287
    STZ.W Layer1ScrollXPosUpd                 ; Set "Face walking dir" timer to 0
    LDA.W PlayerTurnOW                        ; \
    LSR A                                     ; |Set X to current character * 2
    AND.B #$02                                ; |
    TAX                                       ; /
    LDA.W OWPlayerAnimation,X                 ; \
    AND.B #$08                                ; |Set current character's animation to "facing down"
    ORA.B #$02                                ; |or "facing down in water", depending on if character
    STA.W OWPlayerAnimation,X                 ; / is in water or not.
  + REP #$30                                  ; AXY->16
    JMP OWMoveScroll

CODE_04928C:
    REP #$30                                  ; AXY->16
    AND.W #$00FF
    NOP
    NOP
    NOP
    PHA
    STZ.B _6
    LDX.B _4
    LDA.L OWLayer1Translevel,X
    AND.W #$00FF
    TAX
    PLA
    AND.W OWLevelTileSettings,X
    AND.W #$000F
    BNE CODE_0492AD
    JMP CODE_049411

CODE_0492AD:
    REP #$30                                  ; AXY->16
    AND.W #$00FF
    LDY.W #$0006
CODE_0492B5:
    LSR A
    BCS CODE_0492BC
    DEY
    DEY
    BPL CODE_0492B5
CODE_0492BC:
    TYA
    STA.W OWPlayerDirection
    LDX.W #$0000
    CPY.W #$0004
    BCS +
    LDX.W #$0002
  + LDA.B _4
    STA.B _8
    LDA.B _0,X
    CLC
    ADC.W DATA_049058,Y
    STA.B _0,X
    LDA.W PlayerTurnOW
    LSR A
    LSR A
    TAX
    JSR OW_TilePos_Calc
    LDX.B _4
    BMI CODE_049301
    CMP.W #$0800
    BCS CODE_049301
    LDA.L Map16TilesLow,X
    AND.W #$00FF
    BEQ CODE_049301
    CMP.W #$0056
    BCC CODE_0492FE
    CMP.W #$0087
    BCC CODE_0492FE
    BRA CODE_049301

CODE_0492FE:
    BRL CODE_049384
CODE_049301:
    STZ.W HardcodedPathIsUsed
    STZ.W HardcodedPathIndex
    LDX.B _8
    LDA.L OWLayer1Translevel,X
    AND.W #$00FF
    STA.B _0
    LDX.W #$0009
CODE_049315:
    LDA.W HardCodedOWPaths,X
    AND.W #$00FF
    CMP.W #$00FF
    BNE CODE_049349
    PHX
    LDX.W PlayerTurnOW
    LDA.W OWPlayerYPos,X
    CMP.W DATA_049082
    BNE CODE_049346
    LDA.W OWPlayerXPos,X
    CMP.W DATA_049084
    BNE CODE_049346
    LDA.W PlayerTurnLvl
    AND.W #$00FF
    TAX
    LDA.W OWPlayerSubmap,X
    AND.W #$00FF
    BNE CODE_049346
    PLX
    BRA CODE_04934D

CODE_049346:
    PLX
    BRA CODE_049374

CODE_049349:
    CMP.B _0
    BNE CODE_049374
CODE_04934D:
    STX.B _0
    LDA.W DATA_04910E,X
    AND.W #$00FF
    TAX
    DEC A
    STA.W HardcodedPathIndex
    STY.B _2
    LDA.W OWHardCodedDirs,X
    AND.W #$00FF
    CMP.B _2
    BNE CODE_04937A
    LDA.W #$0001
    STA.W HardcodedPathIsUsed
    LDA.W OWHardCodedTiles,X
    AND.W #$00FF
    BRA CODE_049384

CODE_049374:
    DEX
    BMI CODE_04937A
    BRL CODE_049315
CODE_04937A:
    SEP #$20                                  ; A->8
    STZ.W OWLevelExitMode
    REP #$20                                  ; A->16
    JMP CODE_049411

CODE_049384:
    STA.W OverworldLayer1Tile
    STA.B _0
    STZ.B _2
    LDX.W #$0017
CODE_04938E:
    LDA.W DATA_04A03C,X
    AND.W #$00FF
    CMP.B _0
    BNE CODE_0493B5
    LDA.W DATA_04A0E4,X
    CLC
    ADC.W PlayerTurnOW
    PHA
    TXA
    ASL A
    ASL A
    TAX
    LDA.W DATA_04A084,X
    STA.B _0
    LDA.W DATA_04A086,X
    STA.B _2
    PLA
    AND.W #$00FF
    TAX
    BRA CODE_0493DA

CODE_0493B5:
    DEX
    BPL CODE_04938E
    LDX.W #$0008
    TYA
    AND.W #$0002
    BNE +
    TXA
    EOR.W #$FFFF
    INC A
    TAX
  + STX.B _0
    LDX.W #$0000
    CPY.W #$0004
    BCS +
    LDX.W #$0002
  + TXA
    CLC
    ADC.W PlayerTurnOW
    TAX
CODE_0493DA:
    LDA.B _0
    CLC
    ADC.W OWPlayerXPos,X
    STA.W OverworldDestXPos,X
    TXA
    EOR.W #$0002
    TAX
    LDA.B _2
    CLC
    ADC.W OWPlayerXPos,X
    STA.W OverworldDestXPos,X
    TXA
    LSR A
    AND.W #$0002
    TAX
    TYA
    STA.B _0
    LDA.W OWPlayerAnimation,X
    AND.W #$0008
    ORA.B _0
    STA.W OWPlayerAnimation,X
    LDA.W #$000F
    STA.W Layer1ScrollXPosUpd
    INC.W OverworldProcess
    STZ.W Layer1ScrollTimer
CODE_049411:
    JMP OWMoveScroll


DATA_049414:
    db $0D,$08

OWScrollLowerBound:
    db $EF,$FF,$D7,$FF

OWScrollUpperBound:
    db $11,$01,$31,$01

DATA_04941E:
    db $08,$00,$04,$00,$02,$00,$01,$00
DATA_049426:
    db $44,$43,$45,$46,$47,$48,$25,$40
    db $42,$4D

DATA_049430:
    db $0C

DATA_049431:
    db $00,$0E,$00,$10,$06,$12,$00,$18
    db $04,$1A,$02,$20,$06,$42,$06,$4E
    db $04,$50,$02,$58,$06,$5A,$00,$70
    db $06,$90,$00,$A0,$06

DATA_04944E:
    db $01,$01,$00,$01,$01,$00,$00,$00
    db $01,$00,$00,$01,$00,$01,$00

CODE_04945D:
    LDA.W PlayerSwitching
    BEQ +
    LDA.B #$08
    STA.W OverworldProcess
    RTS

  + REP #$30                                  ; AXY->16
    LDA.W PlayerTurnOW
    CLC
    ADC.W #$0002
    TAY
    LDX.W #$0002
CODE_049475:
    LDA.W OverworldDestXPos,Y
    SEC
    SBC.W OWPlayerXPos,Y
    STA.B _0,X
    BPL +
    EOR.W #$FFFF
    INC A
  + STA.B _4,X
    DEY
    DEY
    DEX
    DEX
    BPL CODE_049475
    LDY.W #$FFFF
    LDA.B _4
    STA.B _A
    LDA.B _6
    STA.B _C
    CMP.B _4
    BCC +
    STA.B _A
    LDA.B _4
    STA.B _C
    LDY.W #$0001
  + STY.B _8
    SEP #$20                                  ; A->8
    LDX.W OverworldClimbing
    LDA.W DATA_049414,X
    ASL A
    ASL A
    ASL A
    ASL A
    STA.W HW_WRMPYA
    LDA.B _C
    BEQ +
    STA.W HW_WRMPYB
    NOP
    NOP
    NOP
    NOP
    REP #$20                                  ; A->16
    LDA.W HW_RDMPY
    STA.W HW_WRDIV
    SEP #$20                                  ; A->8
    LDA.B _A
    STA.W HW_WRDIV+2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    REP #$20                                  ; A->16
    LDA.W HW_RDDIV
  + REP #$20                                  ; A->16
    STA.B _E
    LDX.W OverworldClimbing
    LDA.W DATA_049414,X
    AND.W #$00FF
    ASL A
    ASL A
    ASL A
    ASL A
    STA.B _A
    LDX.W #$0002
CODE_0494F0:
    LDA.B _8
    BMI CODE_0494F8
    LDA.B _A
    BRA +

CODE_0494F8:
    LDA.B _E
  + BIT.B _0,X
    BPL +
    EOR.W #$FFFF
    INC A
  + STA.W OWPlayerSpeed,X
    LDA.B _8
    EOR.W #$FFFF
    INC A
    STA.B _8
    DEX
    DEX
    BPL CODE_0494F0
    LDX.W #$0000
    LDA.B _8
    BMI +
    LDX.W #$0002
  + LDA.B _0,X
    BEQ +
    JMP CODE_049801

  + LDA.W Layer1ScrollTimer
    BEQ +
    STZ.W HardcodedPathIsUsed
    LDX.W PlayerTurnOW
    LDA.W OWPlayerXPosPtr,X
    STA.B _0
    LDA.W OWPlayerYPosPtr,X
    STA.B _2
    TXA
    LSR A
    LSR A
    TAX
    JSR OW_TilePos_Calc
    STZ.B _0
    LDX.B _4
    LDA.L OWLayer1Translevel,X
    AND.W #$00FF
    ASL A
    TAX
    LDA.W LevelNames,X
    STA.B _0
    JSR CODE_049D07
    INC.W OverworldProcess
    JSR CODE_049037
    JMP OWMoveScroll

  + LDA.W OverworldLayer1Tile
    STA.W OverworldTightPath
    LDA.W #$0008
    STA.B _8
    LDY.W OWPlayerDirection
    TYA
    AND.W #$00FF
    EOR.W #$0002
    STA.B _A
    BRA CODE_049582

ADDR_049575:
    LDA.B _8
    SEC
    SBC.W #$0002
    STA.B _8
    CMP.B _A
    BEQ ADDR_049575
    TAY
CODE_049582:
    LDX.W PlayerTurnOW
    LDA.W OWPlayerXPosPtr,X
    STA.B _0
    LDA.W OWPlayerYPosPtr,X
    STA.B _2
    LDX.W #$0000
    CPY.W #$0004
    BCS +
    LDX.W #$0002
  + LDA.B _0,X
    CLC
    ADC.W DATA_049058,Y
    STA.B _0,X
    LDA.W PlayerTurnOW
    LSR A
    LSR A
    TAX
    JSR OW_TilePos_Calc
    LDA.W HardcodedPathIsUsed
    BEQ CODE_0495CE
    STY.B _6
    LDX.W HardcodedPathIndex
    INX
    LDA.W OWHardCodedDirs,X
    AND.W #$00FF
    CMP.B _6
    BNE ADDR_049575
    STX.W HardcodedPathIndex
    LDA.W OWHardCodedTiles,X
    AND.W #$00FF
    CMP.W #$0058
    BNE CODE_0495DE
CODE_0495CE:
    LDX.B _4
    BMI ADDR_049575
    CMP.W #$0800
    BCS ADDR_049575
    LDA.L Map16TilesLow,X                     ; \ Load OW tile number
    AND.W #$00FF                              ; /
CODE_0495DE:
    STA.W OverworldLayer1Tile                 ; Set "Current OW tile"
    BEQ ADDR_049575
    CMP.W #$0087
    BCS ADDR_049575
    PHA
    PHY
    TAX
    DEX
    LDY.W #$0000
    LDA.W DATA_049FEB,X
    STA.B _E
    AND.W #$00FF
    CMP.W #$0014
    BNE +
    LDY.W #$0001
  + STY.W OverworldClimbing
    LDX.W PlayerTurnOW
    LDA.B _0
    STA.W OWPlayerXPosPtr,X
    LDA.B _2
    STA.W OWPlayerYPosPtr,X
    PLY
    PLA
    PHA
    SEP #$30                                  ; AXY->8
    LDX.B #$09
CODE_049616:
    CMP.W DATA_049426,X
    BNE CODE_049645
    PHY
    JSR CODE_049A24
    PLY
    LDA.B #$01
    STA.W SwapOverworldMusic
    JSR CODE_04F407
    STZ.W OWTransitionFlag
    REP #$20                                  ; A->16
    STZ.W BackgroundColor
    LDA.W #$7000
    STA.W OWTransitionXCalc
    LDA.W #$5400
    STA.W OWTransitionYCalc
    SEP #$20                                  ; A->8
    LDA.B #$0A
    STA.W OverworldProcess
    BRA CODE_049648

CODE_049645:
    DEX
    BPL CODE_049616
CODE_049648:
    REP #$30                                  ; AXY->16
    PLA
    PHA
    CMP.W #$0056
    BCS +
    JMP CODE_04971D

  + CMP.W #$0080
    BEQ CODE_049663
    CMP.W #$006A
    BCC CODE_049676
    CMP.W #$006E
    BCS CODE_049676
CODE_049663:
    LDA.W PlayerTurnOW
    LSR A
    AND.W #$0002
    TAX
    LDA.W OWPlayerAnimation,X
    ORA.W #$0008
    STA.W OWPlayerAnimation,X
    BRA +

CODE_049676:
    LDA.W PlayerTurnOW
    LSR A
    AND.W #$0002
    TAX
    LDA.W OWPlayerAnimation,X
    AND.W #$00F7
    STA.W OWPlayerAnimation,X
  + LDA.W #$0001
    STA.W Layer1ScrollTimer
    LDA.W OverworldLayer1Tile
    CMP.W #$005F
    BEQ +
    CMP.W #$005B
    BEQ +
    CMP.W #$0082
    BEQ +
    LDA.W #!SFX_BEEP
    STA.W SPCIO3                              ; / Play sound effect
  + NOP
    NOP
    NOP
    LDA.W OverworldLayer1Tile
    AND.W #$00FF
    CMP.W #$0082
    BEQ +
    PHY
    TYA
    AND.W #$00FF
    EOR.W #$0002
    TAY
    STZ.B _6
    LDX.B _4
    LDA.L OWLayer1Translevel,X
    AND.W #$00FF
    TAX
    LDA.W DATA_04941E,Y
    ORA.W OWLevelTileSettings,X
    STA.W OWLevelTileSettings,X
    PLY
  + LDA.W PlayerTurnOW
    LSR A
    AND.W #$0002
    TAX
    LDA.W OWPlayerAnimation,X
    AND.W #$000C
    STA.B _E
    LDA.W #$0001
    STA.B _4
    LDA.W OverworldTightPath
    AND.W #$00FF
    STA.B _0
    LDX.W #$0017
CODE_0496F2:
    LDA.W DATA_04A03C,X
    AND.W #$00FF
    CMP.B _0
    BNE CODE_049704
    TXA
    ASL A
    TAX
    LDA.W DATA_04A054,X
    BRA CODE_049718

CODE_049704:
    DEX
    BPL CODE_0496F2
    LDA.W #$0000
    ORA.W #$0800
    CPY.W #$0004
    BCC CODE_049718
    LDA.W #$0000
    ORA.W #$0008
CODE_049718:
    LDX.W #$0000
    BRA +

CODE_04971D:
    DEC A
    ASL A
    TAX
    LDA.W DATA_049F49,X
    STA.B _4
    LDA.W DATA_049EA7,X
  + STA.B _0
    TXA
    SEP #$20                                  ; A->8
    LDX.W #$001C
CODE_049730:
    CMP.W DATA_049430,X
    BEQ CODE_04973B
    DEX
    DEX
    BPL CODE_049730
    BRA CODE_04974A

CODE_04973B:
    TYA
    CMP.W DATA_049431,X
    BEQ CODE_04974A
    TXA
    LSR A
    TAX
    LDA.W DATA_04944E,X
    TAX
    BRA +

CODE_04974A:
    LDX.W #$0000
    TYA
    AND.B #$02
    BEQ +
    LDX.W #$0001
  + LDA.B _4,X
    BEQ +
    LDA.B _0
    EOR.B #$FF
    INC A
    STA.B _0
    LDA.B _1
    EOR.B #$FF
    INC A
    STA.B _1
  + REP #$20                                  ; A->16
    PLA
    LDX.W #$0000
    LDA.B _E
    AND.W #$0007
    BNE +
    LDX.W #$0001
  + LDA.B _E
    AND.W #$00FF
    STA.B _4
    LDA.B _0,X
    AND.W #$00FF
    CMP.W #$0080
    BCS +
    LDA.B _4
    CLC
    ADC.W #$0002
    STA.B _4
  + LDA.W PlayerTurnOW
    LSR A
    AND.W #$0002
    TAX
    LDA.B _4
    STA.W OWPlayerAnimation,X
    LDX.W PlayerTurnOW
    LDA.B _0
    AND.W #$00FF
    CMP.W #$0080
    BCC +
    ORA.W #$FF00
  + CLC
    ADC.W OWPlayerXPos,X
    AND.W #$FFFC
    STA.W OverworldDestXPos,X
    LDA.B _1
    AND.W #$00FF
    CMP.W #$0080
    BCC +
    ORA.W #$FF00
  + CLC
    ADC.W OWPlayerYPos,X
    AND.W #$FFFC
    STA.W OverworldDestYPos,X
    SEP #$20                                  ; A->8
    LDA.W OverworldDestXPos,X
    AND.B #$0F
    BNE CODE_0497E3
    LDY.W #$0004
    LDA.B _0
    BMI +
    LDY.W #$0006
  + BRA +

CODE_0497E3:
    LDA.W OverworldDestYPos,X
    AND.B #$0F
    BNE +
    LDY.W #$0000
    LDA.B _1
    BMI +
    LDY.W #$0002
  + STY.W OWPlayerDirection
    LDA.W OverworldProcess
    CMP.B #$0A
    BEQ OWMoveScroll
    JMP CODE_04945D

CODE_049801:
    REP #$20                                  ; A->16
    LDA.W PlayerTurnOW
    CLC
    ADC.W #$0002
    TAX
    LDY.W #$0002
CODE_04980E:
    LDA.W Layer3ScrollType,Y
    AND.W #$00FF
    CLC
    ADC.W OWPlayerSpeed,Y
    STA.W Layer3ScrollType,Y
    AND.W #$FF00
    BPL +
    ORA.W #$00FF
  + XBA
    CLC
    ADC.W OWPlayerXPos,X
    STA.W OWPlayerXPos,X
    DEX
    DEX
    DEY
    DEY
    BPL CODE_04980E
OWMoveScroll:
    SEP #$20                                  ; A->8
    LDA.W OverworldProcess
    CMP.B #$0A
    BEQ OWCancelMoveScroll
    LDA.W OverworldEarthquake
    BNE OWCancelMoveScroll
OWScrollNoChecks:
    REP #$30                                  ; AXY->16
    LDX.W PlayerTurnOW
    LDA.W OWPlayerXPos,X
    STA.B _0
    LDA.W OWPlayerYPos,X
    STA.B _2
    TXA
    LSR A
    LSR A
    TAX
    LDA.W OWPlayerSubmap,X
    AND.W #$00FF
    BNE OWCancelMoveScroll
    LDX.W #$0002
    TXY
CheckOWScrollBounds:
    LDA.B _0,X
    SEC
    SBC.W #$0080
    BPL ++
    CMP.W OWScrollLowerBound,Y
    BCS +
    LDA.W OWScrollLowerBound,Y
    BRA +

 ++ CMP.W OWScrollUpperBound,Y
    BCC +
    LDA.W OWScrollUpperBound,Y
  + STA.B Layer1XPos,X
    STA.B Layer2XPos,X
    DEY
    DEY
    DEX
    DEX
    BPL CheckOWScrollBounds
OWCancelMoveScroll:
    SEP #$30                                  ; AXY->8
    RTS

OW_TilePos_Calc:
    LDA.B _0                                  ; Get overworld X pos/16 (X)
    AND.W #$000F                              ; \
    STA.B _4                                  ; |
    LDA.B _0                                  ; |
    AND.W #$0010                              ; |
    ASL A                                     ; |Set tile pos to ((X&0xF)+((X&0x10)<<4))
    ASL A                                     ; |
    ASL A                                     ; |
    ASL A                                     ; |
    ADC.B _4                                  ; |
    STA.B _4                                  ; /
    LDA.B _2                                  ; Get overworld Y pos/16 (Y)
    ASL A                                     ; \
    ASL A                                     ; |
    ASL A                                     ; |Increase tile pos by ((Y<<4)&0xFF)
    ASL A                                     ; |
    AND.W #$00FF                              ; |
    ADC.B _4                                  ; |
    STA.B _4                                  ; /
    LDA.B _2                                  ; \
    AND.W #$0010                              ; |
    BEQ +                                     ; |If (Y&0x10) isn't 0,
    LDA.B _4                                  ; |increase tile pos by x200
    CLC                                       ; |
    ADC.W #$0200                              ; |
    STA.B _4                                  ; /
  + LDA.W OWPlayerSubmap,X                    ; \
    AND.W #$00FF                              ; |
    BEQ Return0498C5                          ; |If on submap,
    LDA.B _4                                  ; |Increase tile pos by x400
    CLC                                       ; |
    ADC.W #$0400                              ; |
    STA.B _4                                  ; /
Return0498C5:
    RTS

CODE_0498C6:
    STZ.W OWPlayerAnimation
    LDA.B #$80
    CLC
    ADC.W IntroMarchYPosSpx
    STA.W IntroMarchYPosSpx
    PHP
    LDA.B #$0F
    CMP.B #$08
    LDY.B #$00
    BCC +
    ORA.B #$F0
    DEY
  + PLP
    ADC.W OWPlayerYPos
    STA.W OWPlayerYPos
    TYA
    ADC.W OWPlayerYPos+1
    STA.W OWPlayerYPos+1
    LDA.W OWPlayerYPos
    CMP.B #$78
    BNE +
    STZ.W OverworldProcess
    JSL SaveTheGame
  + RTS


    db $08,$00,$04,$00,$02,$00,$01,$00

CODE_049903:
    LDX.W OWLevelExitMode
    BEQ Return0498C5
    BMI Return0498C5
    DEX
    LDA.W DATA_049060,X
    STA.B _8
    STZ.B _9
    REP #$20                                  ; A->16
    LDX.W PlayerTurnOW
    LDA.W OWPlayerXPos,X
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _0
    STA.W OWPlayerXPosPtr,X
    LDA.W OWPlayerYPos,X
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _2
    STA.W OWPlayerYPosPtr,X
    TXA
    LSR A
    LSR A
    TAX
    JSR OW_TilePos_Calc
    REP #$10                                  ; XY->16
    LDX.B _4
    LDA.L OWLayer2Directions,X
    AND.W #$00FF
    LDX.B _8
    BEQ CODE_049949
  - LSR A
    DEX
    BPL -
CODE_049949:
    AND.W #$0003
    ASL A
    TAY
    LDX.B _4
    LDA.L OWLayer1Translevel,X
    AND.W #$00FF
    TAX
    LDA.W DATA_04941E,Y
    ORA.W OWLevelTileSettings,X
    STA.W OWLevelTileSettings,X
    SEP #$30                                  ; AXY->8
    RTS


DATA_049964:
    db $40,$01

DATA_049966:
    db $28,$00

DATA_049968:
    db $00,$50,$01,$58,$00,$00,$10,$00
    db $48,$00,$01,$10,$00,$98,$00,$01
    db $A0,$00,$D8,$00,$00,$40,$01,$58
    db $00,$02,$90,$00,$E8,$01,$04,$60
    db $01,$E8,$00,$00,$A0,$00,$C8,$01
    db $00,$60,$01,$88,$00,$03,$08,$01
    db $90,$01,$00,$E8,$01,$10,$00,$03
    db $10,$01,$C8,$01,$00,$F0,$01,$88
    db $00,$03

DATA_0499AA:
    db $00,$00

DATA_0499AC:
    db $48,$00

DATA_0499AE:
    db $01,$00,$00,$98,$00,$01,$50,$01
    db $28,$00,$00,$60,$01,$58,$00,$00
    db $50,$01,$58,$00,$02,$90,$00,$D8
    db $00,$00,$50,$01,$E8,$00,$00,$A0
    db $00,$E8,$01,$04,$50,$01,$88,$00
    db $03,$B0,$00,$C8,$01,$00,$E8,$01
    db $00,$00,$03,$08,$01,$A0,$01,$00
    db $00,$02,$88,$00,$03,$00,$01,$C8
    db $01,$00

DATA_0499F0:
    db $00

DATA_0499F1:
    db $04,$00,$09,$14,$02,$15,$05,$14
    db $05,$09,$0D,$15,$0E,$09,$1E,$15
    db $08,$0A,$1C,$1E,$00,$10,$19,$1F
    db $08,$10,$1C

DATA_049A0C:
    db $EF,$FF

DATA_049A0E:
    db $D8,$FF,$EF,$FF,$80,$00,$EF,$FF
    db $28,$01,$F0,$00,$D8,$FF,$F0,$00
    db $80,$00,$F0,$00,$28,$01

CODE_049A24:
    REP #$20                                  ; A->16
    LDA.W PlayerTurnOW
    LSR A
    LSR A
    TAX
    LDA.W OWPlayerSubmap,X
    AND.W #$00FF
    STA.W CurrentSubmap
    LDA.W #$001A
    STA.B _2
    LDY.B #$41
    LDX.W PlayerTurnOW
CODE_049A3F:
    LDA.W OWPlayerYPos,X
    CMP.W DATA_049964,Y
    BNE CODE_049A85
    LDA.W OWPlayerXPos,X
    CMP.W DATA_049966,Y
    BNE CODE_049A85
    LDA.W DATA_049968,Y
    AND.W #$00FF
    CMP.W CurrentSubmap
    BNE CODE_049A85
    LDA.W DATA_0499AA,Y
    STA.W OWPlayerYPos,X
    LDA.W DATA_0499AC,Y
    STA.W OWPlayerXPos,X
    LDA.W DATA_0499AE,Y
    AND.W #$00FF
    STA.W CurrentSubmap
    LDY.B _2
    LDA.W DATA_0499F0,Y
    AND.W #$00FF
    STA.W OWPlayerYPosPtr,X
    LDA.W DATA_0499F1,Y
    AND.W #$00FF
    STA.W OWPlayerXPosPtr,X
    BRA CODE_049A90

CODE_049A85:
    DEC.B _2
    DEC.B _2
    DEY
    DEY
    DEY
    DEY
    DEY
    BPL CODE_049A3F
CODE_049A90:
    SEP #$20                                  ; A->8
    RTS

CODE_049A93:
    LDA.W PlayerTurnOW
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W OWPlayerSubmap,X
    AND.W #$FF00
    ORA.W CurrentSubmap
    STA.W OWPlayerSubmap,X
    AND.W #$00FF
    BNE +
    JMP OWScrollNoChecks

  + DEC A
    ASL A
    ASL A
    TAY
    LDA.W DATA_049A0C,Y
    STA.B Layer1XPos
    STA.B Layer2XPos
    LDA.W DATA_049A0E,Y
    STA.B Layer1YPos
    STA.B Layer2YPos
    SEP #$30                                  ; AXY->8
    RTS


if ver_is_japanese(!_VER)                     ;\======================== J ====================
LevelNameStrings:                             ;!
    db $47,$5A,$4A,$4B,$5A,$11,$82,$64        ;!
    db $59,$5A,$46,$41,$18,$01,$9E,$61        ;!
    db $59,$40,$63,$64,$59,$5A,$C3,$61        ;!
    db $59,$40,$63,$0D,$59,$01,$8E,$61        ;!
    db $59,$4B,$5A,$69,$59,$60,$65,$6B        ;!
    db $D9,$7B,$5A,$4A,$59,$69,$59,$60        ;!
    db $65,$6B,$D9,$0B,$21,$18,$59,$01        ;!
    db $1E,$99,$19,$1F,$01,$14,$1D,$D5        ;!
    db $7B,$44,$6C,$4E,$5A,$11,$82,$63        ;!
    db $43,$5E,$04,$01,$07,$82,$19,$50        ;!
    db $02,$5F,$65,$61,$5B,$14,$0D,$92        ;!
    db $5F,$65,$61,$5B,$14,$09,$5C,$01        ;!
    db $55,$05,$59,$8E,$5F,$65,$61,$5B        ;!
    db $14,$09,$5C,$02,$20,$05,$59,$8E        ;!
    db $47,$65,$6B,$5A,$14,$01,$83,$4A        ;!
    db $4B,$5A,$3E,$5A,$64,$D9,$42,$5A        ;!
    db $4B,$59,$14,$1A,$0A,$59,$02,$9A        ;!
    db $5E,$48,$4F,$45,$69,$59,$4A,$4B        ;!
    db $DA,$04,$7C,$15,$5B,$1E,$99,$00        ;!
    db $04,$4A,$48,$65,$FB,$00,$50,$4A        ;!
    db $48,$65,$FB,$51,$01,$5C,$4A,$48        ;!
    db $65,$FB,$1A,$11,$59,$55,$4A,$48        ;!
    db $65,$FB,$16,$1A,$8F,$0E,$21,$54        ;!
    db $59,$0F,$0B,$A1,$52,$0C,$D9,$53        ;!
    db $06,$1A,$8E,$02,$20,$1A,$8E,$50        ;!
    db $0D,$14,$09,$9A,$67,$60,$6A,$4A        ;!
    db $4B,$65,$69,$1D,$79,$59,$65,$5F        ;!
    db $E0,$4A,$18,$5B,$6B,$68,$60,$4A        ;!
    db $64,$14,$0D,$9C,$7B,$68,$4C,$79        ;!
    db $5B,$6A,$4C,$6B,$65,$69,$DB,$6C        ;!
    db $5A,$4A,$A3,$6C,$5A,$4A,$A4,$6C        ;!
    db $5A,$4A,$A5,$6C,$5A,$4A,$A6,$6C        ;!
    db $5A,$4A,$A7,$11,$55,$10,$D9,$6A        ;!
    db $61,$59,$66,$1E,$09,$D1,$04,$05        ;!
    db $57,$1E,$09,$D1,$09,$DC,$6C,$5A        ;!
    db $CA,$94,$DD                            ;!
                                              ;!
DATA_049C91:                                  ;!
    db $1A,$01,$00,$00,$07,$00,$0F,$00        ;!
    db $17,$00,$1F,$00,$29,$00,$33,$00        ;!
    db $3A,$00,$40,$00,$47,$00,$4E,$00        ;!
    db $58,$00,$64,$00,$70,$00,$77,$00        ;!
    db $7E,$00,$88,$00,$91,$00                ;!
                                              ;!
DATA_049CCF:                                  ;!
    db $1A,$01,$97,$00,$9D,$00,$A3,$00        ;!
    db $AA,$00,$B2,$00,$B5,$00,$BC,$00        ;!
    db $BF,$00,$C3,$00,$C7,$00,$CC,$00        ;!
    db $D9,$00,$E4,$00                        ;!
                                              ;!
JDATA_049BE1:                                 ;!
    db $1A,$01,$EF,$00,$F3,$00,$F7,$00        ;!
    db $FB,$00,$FF,$00,$03,$01,$07,$01        ;!
    db $0E,$01,$14,$01,$16,$01                ;!
                                              ;!
DATA_049CED:                                  ;!
    db $19,$01,$1A,$01                        ;!
else                                          ;<================ U, SS, E0, & E1 ==============
LevelNameStrings:                             ;!
    db $18,$0E,$12,$07,$08,$5D,$12,$9F        ;!
    db $12,$13,$00,$11,$9F,$5A,$64,$1F        ;!
    db $08,$06,$06,$18,$5D,$12,$9F,$5A        ;!
    db $65,$1F,$0C,$0E,$11,$13,$0E,$0D        ;!
    db $5D,$12,$9F,$5A,$66,$1F,$0B,$04        ;!
    db $0C,$0C,$18,$5D,$12,$9F,$5A,$67        ;!
    db $1F,$0B,$14,$03,$16,$08,$06,$5D        ;!
    db $12,$9F,$5A,$68,$1F,$11,$0E,$18        ;!
    db $5D,$12,$9F,$5A,$69,$1F,$16,$04        ;!
    db $0D,$03,$18,$5D,$12,$9F,$5A,$6A        ;!
    db $1F,$0B,$00,$11,$11,$18,$5D,$12        ;!
    db $9F,$03,$0E,$0D,$14,$13,$9F,$06        ;!
    db $11,$04,$04,$0D,$9F,$13,$0E,$0F        ;!
    db $1F,$12,$04,$02,$11,$04,$13,$1F        ;!
    db $00,$11,$04,$00,$9F,$15,$00,$0D        ;!
    db $08,$0B,$0B,$00,$9F,$38,$39,$3A        ;!
    db $3B,$3C,$9F,$11,$04,$03,$9F,$01        ;!
    db $0B,$14,$04,$9F,$01,$14,$13,$13        ;!
    db $04,$11,$1F,$01,$11,$08,$03,$06        ;!
    db $04,$9F,$02,$07,$04,$04,$12,$04        ;!
    db $1F,$01,$11,$08,$03,$06,$04,$9F        ;!
    db $12,$0E,$03,$00,$1F,$0B,$00,$0A        ;!
    db $04,$9F,$02,$0E,$0E,$0A,$08,$04        ;!
    db $1F,$0C,$0E,$14,$0D,$13,$00,$08        ;!
    db $0D,$9F,$05,$0E,$11,$04,$12,$13        ;!
    db $9F,$02,$07,$0E,$02,$0E,$0B,$00        ;!
    db $13,$04,$9F,$02,$07,$0E,$02,$0E        ;!
    db $1C,$06,$07,$0E,$12,$13,$1F,$07        ;!
    db $0E,$14,$12,$04,$9F,$12,$14,$0D        ;!
    db $0A,$04,$0D,$1F,$06,$07,$0E,$12        ;!
    db $13,$1F,$12,$07,$08,$0F,$9F,$15        ;!
    db $00,$0B,$0B,$04,$18,$9F,$01,$00        ;!
    db $02,$0A,$1F,$03,$0E,$0E,$11,$9F        ;!
    db $05,$11,$0E,$0D,$13,$1F,$03,$0E        ;!
    db $0E,$11,$9F,$06,$0D,$00,$11,$0B        ;!
    db $18,$9F,$13,$14,$01,$14,$0B,$00        ;!
    db $11,$9F,$16,$00,$18,$1F,$02,$0E        ;!
    db $0E,$0B,$9F,$07,$0E,$14,$12,$04        ;!
    db $9F,$08,$12,$0B,$00,$0D,$03,$9F        ;!
    db $12,$16,$08,$13,$02,$07,$1F,$0F        ;!
    db $00,$0B,$00,$02,$04,$9F,$02,$00        ;!
    db $12,$13,$0B,$04,$9F,$0F,$0B,$00        ;!
    db $08,$0D,$12,$9F,$06,$07,$0E,$12        ;!
    db $13,$1F,$07,$0E,$14,$12,$04,$9F        ;!
    db $12,$04,$02,$11,$04,$13,$9F,$03        ;!
    db $0E,$0C,$04,$9F,$05,$0E,$11,$13        ;!
    db $11,$04,$12,$12,$9F,$0E,$05,$32        ;!
    db $33,$34,$35,$36,$37,$0E,$0D,$9F        ;!
    db $0E,$05,$1F,$01,$0E,$16,$12,$04        ;!
    db $11,$9F,$11,$0E,$00,$03,$9F,$16        ;!
    db $0E,$11,$0B,$03,$9F,$00,$16,$04        ;!
    db $12,$0E,$0C,$04,$9F,$E4,$E5,$E6        ;!
    db $E7,$E8,$0F,$00,$0B,$00,$02,$84        ;!
    db $00,$11,$04,$80,$06,$11,$0E,$0E        ;!
    db $15,$98,$0C,$0E,$0D,$03,$8E,$0E        ;!
    db $14,$13,$11,$00,$06,$04,$0E,$14        ;!
    db $92,$05,$14,$0D,$0A,$98,$07,$0E        ;!
    db $14,$12,$84,$9F                        ;!
                                              ;!
DATA_049C91:                                  ;!
    db $CB,$01,$00,$00,$08,$00,$0D,$00        ;!
    db $17,$00,$23,$00,$2E,$00,$3A,$00        ;!
    db $43,$00,$4E,$00,$59,$00,$5F,$00        ;!
    db $65,$00,$75,$00,$7D,$00,$83,$00        ;!
    db $87,$00,$8C,$00,$9A,$00,$A8,$00        ;!
    db $B2,$00,$C2,$00,$C9,$00,$D3,$00        ;!
    db $E5,$00,$F7,$00,$FE,$00,$08,$01        ;!
    db $13,$01,$1A,$01,$22,$01                ;!
                                              ;!
DATA_049CCF:                                  ;!
    db $CB,$01,$2B,$01,$31,$01,$38,$01        ;!
    db $46,$01,$4D,$01,$54,$01,$60,$01        ;!
    db $67,$01,$6C,$01,$75,$01,$80,$01        ;!
    db $8A,$01,$8F,$01,$95,$01                ;!
                                              ;!
DATA_049CED:                                  ;!
    db $CB,$01,$9D,$01,$9E,$01,$9F,$01        ;!
    db $A0,$01,$A1,$01,$A2,$01,$A8,$01        ;!
    db $AC,$01,$B2,$01,$B7,$01,$C1,$01        ;!
    db $C6,$01                                ;!
endif                                         ;/===============================================

if ver_is_japanese(!_VER)                     ;\======================== J ====================
CODE_049D07:                                  ;!
    LDA.L DynStripeImgSize                    ;!
    TAX                                       ;!
    CLC                                       ;!
    ADC.W #$0020                              ;!
    STA.B _2                                  ;!
    CLC                                       ;!
    ADC.W #$0024                              ;!
    STA.L DynStripeImgSize                    ;!
    LDA.W #$1F00                              ;!
    STA.L DynamicStripeImage+2,X              ;!
    STA.L DynamicStripeImage+$26,X            ;!
    LDA.W #$8C50                              ;!
    STA.L DynamicStripeImage,X                ;!
    LDA.W #$6C50                              ;!
    STA.L DynamicStripeImage+$24,X            ;!
    LDA.B _1                                  ;!
    AND.W #$001F                              ;!
    ASL A                                     ;!
    TAY                                       ;!
    LDA.W DATA_049C91,Y                       ;!
    TAY                                       ;!
    SEP #$20                                  ;! A->8
    LDA.W LevelNameStrings,Y                  ;!
    BMI +                                     ;!
    JSR CODE_049D7F                           ;!
    LDA.B _1                                  ;!
    ASL A                                     ;!
    ROL A                                     ;!
    ROL A                                     ;!
    REP #$20                                  ;! A->16
    AND.W #$0003                              ;!
    ASL A                                     ;!
    TAY                                       ;!
    LDA.W DATA_049CED,Y                       ;!
    TAY                                       ;!
    SEP #$20                                  ;! A->8
    JSR CODE_049D7F                           ;!
  + REP #$20                                  ;! A->16
    LDA.B _0                                  ;!
    AND.W #$00F0                              ;!
    LSR A                                     ;!
    LSR A                                     ;!
    LSR A                                     ;!
    TAY                                       ;!
    LDA.W DATA_049CCF,Y                       ;!
    TAY                                       ;!
    SEP #$20                                  ;! A->8
    LDA.W LevelNameStrings,Y                  ;!
    CMP.B #$DD                                ;!
    BEQ +                                     ;!
    JSR CODE_049D7F                           ;!
    LDA.B _1                                  ;!
    AND.B #$20                                ;!
    ASL A                                     ;!
    ASL A                                     ;!
    ASL A                                     ;!
    ROL A                                     ;!
    REP #$20                                  ;! A->16
    AND.W #$0001                              ;!
    ASL A                                     ;!
    TAY                                       ;!
    LDA.W DATA_049CED,Y                       ;!
    TAY                                       ;!
    SEP #$20                                  ;! A->8
    JSR CODE_049D7F                           ;!
  + REP #$20                                  ;! A->16
    LDA.B _0                                  ;!
    AND.W #$000F                              ;!
    ASL A                                     ;!
    TAY                                       ;!
    LDA.W JDATA_049BE1,Y                      ;!
    TAY                                       ;!
    SEP #$20                                  ;! A->8
    JSR CODE_049D7F                           ;!
  - CPX.B _2                                  ;!
    BCS +                                     ;!
    LDY.W #$011A                              ;!
    JSR CODE_049D7F                           ;!
    BRA -                                     ;!
  + LDA.B #$FF                                ;!
    STA.L DynamicStripeImage+$28,X            ;!
    REP #$20                                  ;! A->16
    RTS                                       ;!
                                              ;!
CODE_049D7F:                                  ;!
    LDA.W LevelNameStrings,Y                  ;!
    PHP                                       ;!
    CPX.B _2                                  ;!
    BCS +++                                   ;!
    AND.B #$7F                                ;!
    CMP.B #$59                                ;!
    BEQ +                                     ;!
    CMP.B #$5B                                ;!
    BNE ++                                    ;!
  + STA.L DynamicStripeImage+$26,X            ;!
    BRA +++                                   ;!
 ++ STA.L DynamicStripeImage+4,X              ;!
    LDA.B #$5D                                ;!
    STA.L DynamicStripeImage+$28,X            ;!
    LDA.B #$39                                ;!
    STA.L DynamicStripeImage+5,X              ;!
    STA.L DynamicStripeImage+$29,X            ;!
    INX                                       ;!
    INX                                       ;!
+++ INY                                       ;!
    PLP                                       ;!
    BPL CODE_049D7F                           ;!
    RTS                                       ;!
else                                          ;<================= U, SS, E0 & E1 ==============
CODE_049D07:                                  ;!
    LDA.L DynStripeImgSize                    ;!
    TAX                                       ;!
    CLC                                       ;!
    ADC.W #$0026                              ;!
    STA.B _2                                  ;!
    CLC                                       ;!
    ADC.W #$0004                              ;!
    STA.L DynStripeImgSize                    ;!
    LDA.W #$2500                              ;!
    STA.L DynamicStripeImage+2,X              ;!
    LDA.W #$8B50                              ;!
    STA.L DynamicStripeImage,X                ;!
    LDA.B _1                                  ;!
    AND.W #$007F                              ;!
    ASL A                                     ;!
    TAY                                       ;!
    LDA.W DATA_049C91,Y                       ;!
    TAY                                       ;!
    SEP #$20                                  ;! A->8
    LDA.W LevelNameStrings,Y                  ;!
    BMI +                                     ;!
    JSR CODE_049D7F                           ;!
  + REP #$20                                  ;! A->16
    LDA.B _0                                  ;!
    AND.W #$00F0                              ;!
    LSR A                                     ;!
    LSR A                                     ;!
    LSR A                                     ;!
    TAY                                       ;!
    LDA.W DATA_049CCF,Y                       ;!
    TAY                                       ;!
    SEP #$20                                  ;! A->8
    LDA.W LevelNameStrings,Y                  ;!
    CMP.B #$9F                                ;!
    BEQ +                                     ;!
    JSR CODE_049D7F                           ;!
  + REP #$20                                  ;! A->16
    LDA.B _0                                  ;!
    AND.W #$000F                              ;!
    ASL A                                     ;!
    TAY                                       ;!
    LDA.W DATA_049CED,Y                       ;!
    TAY                                       ;!
    SEP #$20                                  ;! A->8
    JSR CODE_049D7F                           ;!
CODE_049D6A:                                  ;!
    CPX.B _2                                  ;!
    BCS CODE_049D76                           ;!
    LDY.W #$01CB                              ;!
    JSR CODE_049D7F                           ;!
    BRA CODE_049D6A                           ;!
                                              ;!
CODE_049D76:                                  ;!
    LDA.B #$FF                                ;!
    STA.L DynamicStripeImage+4,X              ;!
    REP #$20                                  ;! A->16
    RTS                                       ;!
                                              ;!
CODE_049D7F:                                  ;!
    LDA.W LevelNameStrings,Y                  ;!
    PHP                                       ;!
    CPX.B _2                                  ;!
    BCS +                                     ;!
    AND.B #$7F                                ;!
    STA.L DynamicStripeImage+4,X              ;!
    LDA.B #$39                                ;!
    STA.L DynamicStripeImage+5,X              ;!
    INX                                       ;!
    INX                                       ;!
  + INY                                       ;!
    PLP                                       ;!
    BPL CODE_049D7F                           ;!
    RTS                                       ;!
endif                                         ;/===============================================

CODE_049D9A:
    LDA.W IsTwoPlayerGame
    BEQ CODE_049DAF
    LDA.W PlayerTurnLvl
    EOR.B #$01
    TAX
    LDA.W SavedPlayerLives,X
    BMI CODE_049DAF
    LDA.W OWLevelExitMode
    BNE +
CODE_049DAF:
    LDA.B #$03
    STA.W OverworldProcess
    STZ.W OWLevelExitMode
    REP #$30                                  ; AXY->16
    JMP OWMoveScroll

  + DEC.W KeepModeActive
    BPL +
    LDA.B #$02
    STA.W KeepModeActive
    STZ.W OWLevelExitMode
    INC.W OverworldProcess
  + REP #$30                                  ; AXY->16
    JMP OWMoveScroll

CODE_049DD1:
    LDA.W PlayerTurnLvl
    EOR.B #$01
    STA.W PlayerTurnLvl
    TAX
    LDA.W SavedPlayerCoins,X
    STA.W PlayerCoins
    LDA.W SavedPlayerLives,X
    STA.W PlayerLives
    LDA.W SavedPlayerPowerup,X
    STA.B Powerup
    LDA.W SavedPlayerYoshi,X
    STA.W CarryYoshiThruLvls
    STA.W YoshiColor
    STA.W PlayerRidingYoshi
    LDA.W SavedPlayerItembox,X
    STA.W PlayerItembox
    JSL CODE_05DBF2
    REP #$20                                  ; A->16
    JSR CODE_048E55
    SEP #$20                                  ; A->8
    LDX.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,X
    STA.W CurrentSubmap
    STZ.W CurrentSubmap+1
    LDA.B #$02
    STA.W KeepModeActive
    LDA.B #$0A
    STA.W OverworldProcess
    INC.W PlayerSwitching
    RTS

CODE_049E22:
    DEC.W KeepModeActive
    BPL +
    LDA.B #$02
    STA.W KeepModeActive
    LDX.W MosaicDirection
    LDA.W Brightness
    CLC
    ADC.L BrightnessRate,X
    STA.W Brightness
    CMP.L BrightnessLimits,X
    BNE +
    INC.W OverworldProcess
    LDA.W MosaicDirection
    EOR.B #$01
    STA.W MosaicDirection
  + RTS

CODE_049E4C:
    LDA.B #$03
    STA.W OverworldProcess
    RTS

CODE_049E52:
    LDA.W StarWarpLaunchSpeed
    BNE CODE_049E63
    INC.W StarWarpLaunchTimer
    LDA.W StarWarpLaunchTimer
    CMP.B #$31
    BNE CODE_049E93
    BRA CODE_049E69

CODE_049E63:
    LDA.B TrueFrame
    AND.B #$07
    BNE +
CODE_049E69:
    INC.W StarWarpLaunchSpeed
    LDA.W StarWarpLaunchSpeed
    CMP.B #$05
    BNE +
    LDA.B #$04
    STA.W StarWarpLaunchSpeed
  + REP #$20                                  ; A->16
    LDA.W StarWarpLaunchSpeed
    AND.W #$00FF
    STA.B _0
    LDX.W PlayerTurnOW
    LDA.W OWPlayerYPos,X
    SEC
    SBC.B _0
    STA.W OWPlayerYPos,X
    SEC
    SBC.B Layer1YPos
    BMI +
CODE_049E93:
    SEP #$20                                  ; A->8
    RTS

  + SEP #$20                                  ; A->8
    JMP CODE_04918D

    LDY.B #$00                                ; \ Unreachable
ADDR_049E9D:
    CMP.B #$0A                                ; | While A >= #$0A...
    BCC Return049EA6                          ; |
    SBC.B #$0A                                ; | A -= #$0A
    INY                                       ; | Y++
    BRA ADDR_049E9D                           ; /

Return049EA6:
    RTS                                       ; /


DATA_049EA7:
    db $10,$F8,$10,$00,$10,$FC,$10,$00
    db $10,$FC,$10,$00,$08,$FC,$0C,$F4
    db $FC,$04,$04,$FC,$F8,$10,$00,$10
    db $FC,$08,$FC,$08,$FC,$10,$00,$10
    db $F8,$04,$FC,$10,$00,$10,$10,$08
    db $10,$04,$10,$04,$08,$04,$0C,$0C
    db $04,$04,$04,$04,$08,$10,$FC,$F8
    db $FC,$F8,$04,$10,$F8,$FC,$04,$10
    db $F4,$F4,$0C,$F4,$10,$00,$00,$10
    db $00,$10,$10,$00,$10,$00,$FC,$08
    db $FC,$08,$00,$10,$10,$FC,$10,$FC
    db $FC,$04,$04,$FC,$F8,$10,$00,$10
    db $FC,$10,$10,$04,$10,$00,$04,$10
    db $04,$04,$FC,$F8,$04,$04,$10,$08
    db $0C,$F4,$00,$10,$FC,$10,$10,$00
    db $04,$10,$10,$F8,$00,$10,$00,$10
    db $FC,$10,$10,$00,$00,$10,$00,$10
    db $00,$10,$00,$10,$00,$10,$00,$10
    db $04,$FC,$04,$04,$04,$04,$00,$10
    db $00,$10,$10,$00,$10,$00,$FC,$10
    db $FC,$04

DATA_049F49:
    db $01,$00,$01,$00,$01,$00,$01,$00
    db $01,$00,$01,$00,$00,$01,$00,$01
    db $00,$01,$00,$01,$01,$00,$01,$00
    db $00,$01,$01,$00,$01,$00,$01,$00
    db $00,$01,$01,$00,$01,$00,$01,$00
    db $01,$00,$01,$00,$01,$00,$01,$00
    db $01,$00,$01,$00,$01,$00,$00,$01
    db $00,$01,$01,$00,$00,$01,$01,$00
    db $00,$01,$01,$00,$01,$00,$01,$00
    db $01,$00,$01,$00,$01,$00,$00,$01
    db $01,$00,$01,$00,$01,$00,$01,$00
    db $00,$01,$00,$01,$01,$00,$01,$00
    db $01,$00,$01,$00,$01,$00,$01,$00
    db $01,$00,$00,$01,$01,$00,$01,$00
    db $01,$00,$01,$00,$01,$00,$01,$00
    db $01,$00,$01,$00,$01,$00,$01,$00
    db $01,$00,$01,$00,$01,$00,$01,$00
    db $01,$00,$01,$00,$01,$00,$01,$00
    db $00,$01,$01,$00,$01,$00,$01,$00
    db $01,$00,$01,$00,$01,$00,$01,$00
    db $00,$01

DATA_049FEB:
    db $04,$04,$04,$04,$04,$04,$04,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $04,$00,$00,$04,$04,$04,$04,$00
    db $00,$00,$00,$00,$00,$00,$04,$00
    db $00,$00,$04,$00,$00,$04,$04,$08
    db $08,$08,$0C,$0C,$08,$08,$08,$08
    db $08,$0C,$0C,$08,$08,$08,$08,$0C
    db $08,$08,$08,$0C,$08,$0C,$14,$14
    db $14,$04,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$04,$04,$08
    db $00

DATA_04A03C:
    db $07,$09,$0A,$0D,$0E,$11,$17,$19
    db $1A,$1C,$1D,$1F,$28,$29,$2D,$2E
    db $35,$36,$37,$49,$4A,$4B,$4D,$51
DATA_04A054:
    db $08,$FC,$FC,$08,$FC,$08,$FC,$08
    db $FC,$08,$04,$00,$08,$04,$04,$08
    db $04,$08,$04,$00,$04,$08,$04,$00
    db $FC,$08,$00,$00,$FC,$08,$FC,$08
    db $04,$00,$04,$00,$00,$00,$08,$FC
    db $08,$04,$08,$04,$FC,$08,$08,$FC
DATA_04A084:
    db $04,$00

DATA_04A086:
    db $F8,$FF,$08,$00,$FC,$FF,$F8,$FF
    db $04,$00,$F8,$FF,$04,$00,$08,$00
    db $FC,$FF,$04,$00,$04,$00,$04,$00
    db $08,$00,$08,$00,$04,$00,$F8,$FF
    db $FC,$FF,$00,$00,$00,$00,$08,$00
    db $04,$00,$04,$00,$04,$00,$F8,$FF
    db $04,$00,$04,$00,$04,$00,$08,$00
    db $FC,$FF,$F8,$FF,$04,$00,$04,$00
    db $04,$00,$00,$00,$00,$00,$04,$00
    db $04,$00,$04,$00,$F8,$FF,$04,$00
    db $08,$00,$FC,$FF,$F8,$FF,$F8,$FF
    db $04,$00,$FC,$FF,$08,$00

DATA_04A0E4:
    db $02,$02,$02,$02,$02,$00,$02,$02
    db $02,$00,$02,$00,$02,$00,$02,$02
    db $00,$00,$00,$02,$02,$02,$02,$02

if ver_is_japanese(!_VER)                     ;\======================= J =====================
LevelNames:                                   ;!
    db $00,$00,$52,$44,$53,$44,$90,$22        ;!
    db $07,$22,$03,$62,$04,$62,$09,$22        ;!
    db $40,$62,$02,$62,$51,$42,$06,$24        ;!
    db $01,$65,$02,$65,$09,$27,$01,$66        ;!
    db $01,$67,$00,$70,$00,$6F,$08,$22        ;!
    db $30,$72,$01,$62,$00,$6F,$00,$00        ;!
    db $60,$2A,$00,$00,$09,$29,$06,$29        ;!
    db $05,$69,$04,$69,$00,$6F,$06,$28        ;!
    db $09,$28,$07,$29,$01,$69,$03,$69        ;!
    db $02,$69,$09,$21,$04,$61,$03,$61        ;!
    db $00,$6E,$01,$61,$02,$61,$07,$23        ;!
    db $00,$6F,$51,$43,$03,$63,$52,$42        ;!
    db $00,$6F,$00,$6C,$00,$6D,$04,$6B        ;!
    db $09,$2B,$06,$2B,$00,$00,$03,$6B        ;!
    db $07,$2B,$02,$6B,$01,$6B,$51,$49        ;!
    db $02,$63,$04,$63,$01,$63,$10,$63        ;!
    db $09,$23,$07,$28,$01,$68,$04,$68        ;!
    db $02,$68,$20,$68,$51,$48,$03,$68        ;!
    db $00,$6F,$DA,$00,$DA,$00,$CA,$40        ;!
    db $CA,$40,$00,$6F,$AA,$60,$AA,$60        ;!
    db $BA,$60,$BA,$60,$00,$6F,$00,$6F        ;!
    db $02,$71,$00,$6F,$03,$71,$00,$6F        ;!
    db $01,$71,$04,$71,$05,$71,$00,$6F        ;!
    db $00,$6F                                ;!
else                                          ;<================ U, SS, E0, & E1 ==============
LevelNames:                                   ;!
    db $00,$00,$72,$0D,$73,$0D,$00,$0C        ;!
    db $60,$0A,$53,$0A,$54,$0A,$40,$04        ;!
    db $30,$0B,$52,$0A,$71,$0A,$90,$0D        ;!
    db $01,$11,$02,$11,$40,$06,$07,$12        ;!
    db $00,$14,$00,$13,$C0,$02,$7C,$0A        ;!
    db $33,$0E,$51,$0A,$C0,$02,$53,$04        ;!
    db $00,$18,$53,$04,$40,$08,$90,$16        ;!
    db $25,$16,$24,$16,$C0,$02,$90,$15        ;!
    db $40,$07,$00,$17,$21,$16,$23,$16        ;!
    db $22,$16,$40,$03,$24,$01,$23,$01        ;!
    db $10,$01,$21,$01,$22,$01,$60,$0D        ;!
    db $C0,$02,$71,$0D,$83,$0D,$72,$0A        ;!
    db $C0,$02,$00,$1B,$00,$1A,$B4,$19        ;!
    db $40,$09,$90,$19,$00,$00,$B3,$19        ;!
    db $60,$19,$B2,$19,$B1,$19,$70,$16        ;!
    db $82,$0D,$84,$0D,$81,$0D,$30,$0F        ;!
    db $40,$05,$60,$15,$A1,$15,$A4,$15        ;!
    db $A2,$15,$30,$10,$77,$15,$A3,$15        ;!
    db $C0,$02,$0B,$00,$0A,$00,$09,$00        ;!
    db $08,$00,$C0,$02,$00,$1C,$00,$1D        ;!
    db $00,$1E,$E0,$00,$C0,$02,$C0,$02        ;!
    db $D2,$02,$C0,$02,$D3,$02,$C0,$02        ;!
    db $D1,$02,$D4,$02,$D5,$02,$C0,$02        ;!
    db $C0,$02                                ;!
endif                                         ;/===============================================

    %insert_empty($306,$24A,$26B,$24A,$24A)

OWBorderStripe:
    db $50,$00,$41,$3E,$FE,$38,$50,$A0
    db $C0,$28,$FE,$38,$50,$A1,$C0,$28
    db $FE,$38,$50,$BE,$C0,$28,$FE,$38
    db $50,$BF,$C0,$28,$FE,$38,$53,$40
    db $41,$7E,$FE,$38,$50,$A2,$00,$01
    db $92,$3C,$50,$A3,$40,$32,$93,$3C
    db $50,$BD,$00,$01,$92,$7C,$50,$C2
    db $C0,$24,$94,$7C,$50,$DD,$C0,$24
    db $94,$3C,$53,$22,$00,$01,$92,$BC
    db $53,$23,$40,$32,$93,$BC,$53,$3D
    db $00,$01,$92,$FC,$50,$FE,$C0,$24
    db $D6,$2C,$53,$44,$40,$32,$D5,$2C
    db $50,$DE,$00,$01,$D4,$2C,$53,$43
    db $00,$01,$D4,$EC,$53,$5E,$00,$01
    db $D4,$AC,$50,$02,$00,$01,$95,$38
    db $50,$09,$00,$01,$97,$38,$50,$0E
    db $00,$01,$96,$38,$50,$33,$00,$01
    db $97,$38,$50,$37,$00,$01,$95,$38
    db $50,$3B,$00,$01,$96,$38,$50,$42
    db $00,$01,$96,$38,$50,$50,$00,$01
    db $95,$38,$50,$55,$00,$01,$96,$38
    db $50,$5E,$00,$01,$95,$38,$51,$01
    db $00,$01,$97,$38,$51,$5F,$00,$01
    db $96,$38,$51,$81,$00,$01,$95,$38
    db $51,$C0,$00,$01,$96,$38,$51,$FF
    db $00,$01,$97,$38,$52,$60,$00,$01
    db $95,$38,$52,$7F,$00,$01,$95,$38
    db $53,$00,$00,$01,$97,$38,$53,$1F
    db $00,$01,$96,$38,$53,$61,$00,$01
    db $95,$38,$53,$6A,$00,$01,$95,$38
    db $53,$73,$00,$01,$96,$38,$53,$76
    db $00,$01,$95,$38,$53,$86,$00,$01
    db $96,$38,$53,$91,$00,$01,$95,$38
    db $53,$9A,$00,$01,$97,$38,$53,$9E
    db $00,$01,$95,$38,$50,$23,$C0,$06
    db $FC,$2C,$50,$24,$C0,$06,$FC,$2C
    db $50,$25,$C0,$06,$FC,$2C,$50,$26
    db $C0,$06,$FC,$2C,$50,$87,$00,$01
    db $8F,$38,$FF

OWTileNumbers:
    db $9B,$75,$81,$20,$01
    db $76,$20,$9B,$75,$81,$20,$01,$76
    db $20,$9A,$75,$00,$10,$81,$20,$01
    db $76,$20,$94,$75,$00,$01,$81,$02
    db $81,$01,$05,$02,$11,$50,$20,$7D
    db $20,$92,$75,$02,$10,$03,$11,$81
    db $71,$81,$11,$81,$71,$03,$11,$43
    db $10,$9C,$91,$75,$01,$10,$11,$89
    db $71,$01,$11,$10,$89,$75,$04,$01
    db $02,$03,$02,$01,$82,$75,$01,$3D
    db $71,$83,$AD,$81,$8A,$81,$AD,$81
    db $8A,$01,$11,$10,$89,$75,$00,$3D
    db $82,$71,$00,$3D,$82,$75,$01,$3D
    db $71,$83,$AD,$81,$8A,$81,$AD,$81
    db $8A,$01,$3D,$3F,$89,$75,$00,$00
    db $81,$43,$01,$42,$40,$81,$75,$01
    db $10,$00,$83,$43,$00,$11,$85,$71
    db $01,$11,$10,$88,$75,$01,$11,$20
    db $82,$69,$03,$20,$11,$75,$3D,$81
    db $20,$82,$69,$00,$00,$81,$43,$00
    db $11,$83,$71,$00,$3D,$88,$75,$01
    db $11,$50,$81,$69,$04,$41,$42,$11
    db $75,$3D,$81,$20,$81,$69,$01,$20
    db $69,$81,$20,$00,$50,$83,$43,$00
    db $10,$89,$75,$00,$11,$81,$43,$00
    db $11,$82,$75,$02,$3D,$50,$20,$82
    db $69,$81,$20,$01,$69,$20,$82,$69
    db $01,$20,$76,$86,$75,$01,$54,$55
    db $87,$75,$01,$00,$11,$83,$43,$00
    db $50,$81,$20,$83,$69,$01,$20,$76
    db $86,$75,$03,$9E,$9F,$06,$05,$85
    db $03,$01,$20,$50,$83,$43,$00,$11
    db $81,$43,$00,$50,$82,$69,$01,$20
    db $7D,$84,$75,$04,$01,$02,$9E,$9F
    db $58,$81,$71,$02,$BA,$BD,$BF,$81
    db $71,$81,$20,$83,$69,$03,$50,$11
    db $71,$11,$82,$43,$01,$9C,$10,$84
    db $75,$0E,$3D,$71,$9E,$9F,$71,$58
    db $71,$BD,$BF,$BA,$71,$11,$20,$69
    db $20,$83,$69,$00,$50,$83,$43,$02
    db $10,$9C,$43,$84,$75,$04,$3D,$58
    db $9E,$9F,$71,$81,$58,$06,$BF,$71
    db $BD,$71,$11,$50,$20,$84,$69,$00
    db $20,$82,$69,$03,$20,$76,$20,$69
    db $83,$75,$05,$10,$11,$58,$9E,$9F
    db $58,$81,$71,$07,$58,$BA,$BD,$BF
    db $71,$11,$50,$20,$84,$69,$00,$20
    db $81,$69,$03,$20,$76,$20,$69,$82
    db $75,$06,$10,$11,$56,$57,$9E,$9F
    db $58,$82,$71,$02,$BD,$71,$BA,$81
    db $71,$81,$58,$04,$43,$58,$43,$50
    db $20,$82,$69,$03,$20,$76,$20,$69
    db $82,$75,$05,$3D,$58,$9E,$9F,$64
    db $65,$84,$71,$81,$BD,$00,$BF,$83
    db $58,$04,$71,$58,$11,$50,$20,$81
    db $69,$03,$20,$76,$20,$69,$82,$75
    db $03,$3D,$71,$64,$65,$81,$71,$00
    db $6E,$81,$6B,$05,$6E,$BD,$BF,$BA
    db $BD,$58,$81,$8A,$01,$AD,$8E,$81
    db $58,$07,$11,$43,$BC,$3D,$20,$7D
    db $20,$69,$82,$75,$01,$00,$11,$81
    db $71,$01,$AE,$BC,$83,$68,$04,$BA
    db $BD,$11,$43,$11,$81,$8A,$09,$AD
    db $8A,$8F,$53,$52,$71,$BC,$3D,$43
    db $3F,$81,$43,$82,$75,$06,$20,$50
    db $11,$8F,$9B,$71,$6E,$81,$6B,$05
    db $6E,$11,$43,$00,$69,$00,$81,$43
    db $08,$58,$8F,$9B,$63,$62,$71,$BC
    db $71,$10,$82,$3F,$82,$75,$02,$20
    db $50,$11,$81,$AC,$01,$58,$11,$82
    db $43,$04,$00,$69,$50,$43,$50,$81
    db $20,$04,$50,$58,$9B,$8F,$6C,$81
    db $68,$01,$6C,$3D,$82,$3F,$82,$75
    db $02,$00,$11,$58,$81,$AC,$09,$11
    db $50,$20,$69,$20,$50,$43,$11,$3F
    db $11,$81,$43,$03,$50,$3D,$8A,$BC
    db $83,$68,$00,$6C,$82,$03,$81,$75
    db $03,$10,$11,$56,$57,$81,$AC,$01
    db $3D,$50,$82,$43,$00,$11,$85,$3F
    db $03,$10,$11,$8A,$BC,$84,$68,$81
    db $71,$00,$43,$81,$75,$03,$3D,$58
    db $64,$65,$81,$8A,$01,$11,$10,$87
    db $3F,$03,$10,$03,$52,$53,$81,$71
    db $00,$6C,$82,$68,$03,$6C,$11,$00
    db $69,$81,$75,$03,$3D,$71,$56,$57
    db $81,$8A,$01,$58,$3D,$86,$3F,$00
    db $10,$81,$8F,$0B,$62,$63,$52,$53
    db $71,$52,$53,$71,$11,$50,$69,$20
    db $81,$75,$03,$00,$11,$64,$65,$81
    db $AC,$02,$11,$00,$11,$84,$3F,$0F
    db $10,$52,$53,$71,$8E,$71,$62,$63
    db $52,$51,$63,$11,$50,$69,$20,$69
    db $81,$75,$03,$20,$3D,$71,$58,$81
    db $AC,$02,$3D,$50,$11,$84,$3F,$04
    db $3D,$62,$63,$71,$8E,$82,$71,$03
    db $62,$63,$42,$41,$82,$69,$00,$20
    db $81,$75,$03,$20,$3D,$58,$71,$81
    db $AC,$00,$3D,$83,$3F,$00,$10,$81
    db $03,$0A,$11,$52,$53,$52,$53,$71
    db $52,$53,$11,$50,$20,$82,$69,$07
    db $50,$43,$75,$11,$20,$00,$11,$71
    db $81,$AC,$01,$11,$10,$82,$3F,$00
    db $3D,$81,$71,$09,$52,$51,$63,$62
    db $63,$52,$51,$63,$3A,$20,$82,$69
    db $03,$50,$11,$75,$20,$9E,$75,$00
    db $20,$9E,$75,$01,$20,$10,$95,$75
    db $03,$E2,$E5,$F5,$F6,$83,$75,$02
    db $50,$11,$10,$90,$75,$07,$01,$02
    db $03,$05,$84,$32,$33,$C4,$83,$75
    db $03,$11,$71,$11,$10,$8D,$75,$02
    db $01,$02,$11,$82,$71,$04,$35,$36
    db $37,$38,$01,$82,$75,$01,$10,$03
    db $81,$11,$00,$10,$8B,$75,$01,$10
    db $11,$84,$71,$05,$49,$4A,$59,$5A
    db $11,$10,$81,$75,$81,$3F,$02,$10
    db $71,$3D,$8B,$75,$02,$3D,$AD,$5D
    db $84,$68,$00,$5D,$82,$71,$00,$3D
    db $81,$75,$82,$3F,$81,$3D,$8B,$75
    db $01,$3D,$AD,$86,$68,$81,$71,$01
    db $11,$00,$81,$75,$81,$3F,$02,$10
    db $11,$00,$87,$75,$01,$01,$02,$81
    db $03,$02,$00,$11,$5D,$84,$68,$04
    db $5D,$71,$11,$50,$20,$81,$75,$05
    db $3F,$10,$11,$50,$20,$10,$85,$75
    db $01,$10,$11,$82,$71,$04,$20,$50
    db $44,$43,$44,$81,$43,$05,$44,$43
    db $42,$40,$69,$20,$81,$75,$05,$9C
    db $43,$50,$69,$20,$3D,$85,$A4,$01
    db $3D,$AD,$81,$8A,$03,$11,$20,$69
    db $20,$87,$69,$81,$20,$81,$75,$81
    db $20,$81,$69,$01,$50,$3D,$81,$B4
    db $01,$B5,$A5,$81,$B4,$01,$3D,$AD
    db $81,$8A,$02,$11,$50,$20,$87,$69
    db $0A,$20,$69,$20,$10,$75,$20,$69
    db $20,$50,$11,$4D,$85,$75,$01,$4D
    db $71,$81,$AC,$03,$71,$11,$50,$20
    db $87,$69,$81,$20,$01,$11,$10,$81
    db $20,$00,$50,$81,$11,$01,$00,$02
    db $82,$03,$05,$02,$01,$3D,$71,$8F
    db $9B,$81,$71,$01,$11,$44,$81,$43
    db $00,$60,$83,$69,$04,$20,$69,$20
    db $71,$3D,$81,$43,$81,$11,$02,$50
    db $20,$11,$82,$43,$81,$11,$03,$00
    db $11,$71,$AE,$83,$BC,$02,$AE,$11
    db $00,$84,$69,$0A,$20,$50,$58,$4D
    db $43,$11,$71,$3D,$69,$20,$41,$82
    db $69,$07,$41,$42,$20,$41,$42,$44
    db $43,$44,$81,$43,$02,$44,$50,$20
    db $83,$69,$0B,$20,$50,$11,$71,$3D
    db $20,$50,$43,$00,$69,$20,$42,$82
    db $43,$02,$42,$41,$20,$81,$69,$00
    db $20,$84,$69,$81,$20,$82,$69,$0B
    db $41,$42,$11,$58,$71,$4D,$69,$20
    db $69,$20,$69,$20,$85,$73,$02,$20
    db $69,$20,$84,$69,$02,$20,$69,$20
    db $82,$43,$00,$11,$81,$58,$03,$71
    db $58,$3D,$20,$81,$69,$03,$20,$69
    db $50,$11,$83,$3F,$01,$11,$20,$81
    db $69,$00,$20,$84,$69,$02,$20,$50
    db $58,$81,$AC,$81,$89,$81,$58,$07
    db $11,$00,$69,$20,$69,$20,$50,$11
    db $84,$3F,$03,$11,$50,$69,$20,$84
    db $69,$01,$20,$50,$81,$89,$81,$AC
    db $81,$99,$81,$89,$00,$3D,$81,$20
    db $81,$69,$01,$20,$11,$86,$3F,$04
    db $11,$42,$41,$20,$60,$83,$43,$00
    db $11,$81,$99,$81,$AC,$81,$89,$81
    db $99,$06,$3D,$20,$43,$50,$69,$50
    db $11,$88,$3F,$03,$11,$43,$3D,$71
    db $81,$89,$01,$71,$58,$81,$89,$81
    db $8F,$09,$99,$98,$89,$71,$3D,$20
    db $3F,$11,$43,$11,$8A,$3F,$02,$10
    db $11,$58,$81,$99,$81,$89,$01,$99
    db $98,$82,$89,$81,$99,$02,$58,$3D
    db $50,$82,$3F,$81,$10,$83,$3F,$81
    db $10,$82,$3F,$01,$10,$11,$81,$89
    db $04,$58,$89,$98,$99,$89,$82,$98
    db $00,$99,$81,$89,$02,$58,$4D,$11
    db $82,$03,$02,$11,$00,$11,$81,$3F
    db $00,$10,$81,$11,$82,$03,$04,$11
    db $58,$99,$98,$89,$81,$99,$00,$89
    db $83,$98,$00,$89,$81,$99,$02,$71
    db $4D,$75,$82,$43,$81,$50,$02,$11
    db $3F,$9C,$82,$43,$02,$11,$71,$58
    db $82,$89,$01,$98,$99,$81,$89,$85
    db $99,$00,$58,$81,$89,$01,$11,$10
    db $81,$69,$81,$20,$82,$76,$00,$20
    db $81,$69,$03,$20,$50,$11,$71,$82
    db $99,$03,$98,$89,$99,$98,$86,$89
    db $81,$99,$01,$58,$3D,$81,$69,$81
    db $20,$82,$76,$00,$20,$82,$69,$03
    db $20,$41,$42,$11,$81,$89,$81,$99
    db $01,$89,$98,$81,$99,$81,$98,$82
    db $99,$81,$89,$01,$58,$3D,$81,$69
    db $81,$20,$82,$7D,$00,$20,$81,$69
    db $00,$20,$82,$69,$00,$3D,$81,$99
    db $81,$89,$01,$99,$98,$81,$89,$81
    db $98,$06,$89,$3B,$89,$98,$99,$11
    db $00,$81,$69,$05,$20,$50,$11,$3F
    db $11,$20,$82,$69,$00,$20,$81,$69
    db $06,$3D,$71,$58,$99,$98,$89,$99
    db $83,$98,$01,$99,$89,$81,$98,$02
    db $89,$3D,$20,$82,$43,$00,$11,$81
    db $3F,$00,$11,$83,$43,$03,$50,$41
    db $42,$11,$82,$89,$82,$98,$82,$99
    db $01,$98,$89,$83,$99,$01,$3D,$20
    db $87,$75,$04,$08,$07,$06,$05,$11
    db $81,$58,$84,$99,$00,$98,$82,$89
    db $81,$99,$81,$89,$09,$58,$71,$3D
    db $20,$75,$11,$50,$20,$3D,$71,$81
    db $AC,$01,$71,$11,$82,$03,$00,$11
    db $81,$71,$01,$62,$63,$82,$71,$08
    db $62,$63,$11,$2A,$69,$20,$69,$50
    db $11,$83,$75,$05,$11,$20,$00,$11
    db $8F,$9B,$84,$71,$00,$5D,$81,$68
    db $00,$5D,$82,$71,$03,$58,$71,$11
    db $50,$81,$20,$02,$41,$42,$11,$85
    db $75,$06,$00,$43,$23,$30,$AE,$AF
    db $AD,$81,$8A,$01,$71,$5D,$81,$68
    db $00,$5D,$83,$71,$05,$11,$50,$20
    db $69,$2A,$11,$86,$75,$01,$10,$11
    db $81,$71,$03,$11,$30,$8E,$AD,$81
    db $8A,$01,$52,$53,$81,$71,$81,$58
    db $03,$71,$58,$11,$50,$81,$69,$01
    db $20,$3A,$81,$75,$01,$A6,$A7,$83
    db $75,$01,$00,$11,$81,$71,$03,$11
    db $00,$52,$53,$81,$AC,$02,$62,$63
    db $71,$81,$58,$03,$11,$43,$42,$41
    db $81,$69,$08,$20,$50,$11,$A6,$A7
    db $B6,$B7,$A6,$A7,$81,$75,$01,$20
    db $50,$81,$43,$03,$50,$20,$62,$63
    db $81,$AC,$00,$71,$81,$58,$03,$71
    db $11,$50,$20,$83,$69,$04,$50,$11
    db $75,$B6,$B7,$81,$3F,$01,$B6,$B7
    db $81,$75,$01,$20,$69,$81,$3E,$0C
    db $69,$20,$42,$44,$43,$44,$43,$44
    db $43,$42,$41,$69,$20,$82,$69,$03
    db $50,$11,$A6,$A7,$85,$3F,$81,$75
    db $01,$20,$69,$81,$3E,$00,$69,$82
    db $20,$84,$69,$00,$20,$81,$69,$00
    db $20,$81,$69,$04,$50,$11,$75,$B6
    db $B7,$85,$3F,$81,$75,$01,$20,$69
    db $81,$3E,$03,$69,$20,$69,$20,$83
    db $69,$00,$20,$82,$69,$05,$20,$41
    db $42,$11,$A6,$A7,$87,$3F,$81,$75
    db $01,$20,$69,$81,$3E,$00,$69,$81
    db $20,$85,$69,$04,$20,$69,$50,$43
    db $11,$81,$75,$01,$B6,$B7,$87,$3F
    db $81,$75,$01,$20,$69,$81,$3E,$03
    db $69,$20,$41,$20,$83,$69,$03,$20
    db $41,$42,$11,$83,$75,$01,$A6,$A7
    db $87,$3F,$81,$75,$01,$20,$69,$81
    db $3E,$02,$69,$20,$11,$85,$43,$00
    db $11,$85,$75,$01,$B6,$B7,$87,$3F
    db $81,$75,$01,$20,$69,$81,$3E,$08
    db $69,$20,$03,$04,$03,$04,$03,$02
    db $01,$87,$75,$01,$A6,$A7,$86,$3F
    db $03,$75,$10,$20,$C2,$81,$C3,$03
    db $C2,$20,$56,$57,$82,$71,$02,$56
    db $57,$10,$86,$75,$03,$B6,$B7,$A6
    db $A7,$83,$3F,$04,$A6,$75,$4D,$50
    db $D2,$81,$D3,$03,$D2,$50,$9E,$9F
    db $82,$71,$02,$9E,$9F,$3D,$88,$75
    db $0A,$B6,$B7,$3F,$A6,$A7,$3F,$B6
    db $75,$3D,$11,$20,$81,$3E,$03,$20
    db $11,$9E,$9F,$82,$71,$02,$64,$65
    db $4D,$8B,$75,$01,$B6,$B7,$82,$75
    db $02,$4D,$11,$50,$81,$3E,$05,$50
    db $11,$9E,$9F,$56,$57,$81,$71,$01
    db $58,$3D,$90,$75,$02,$3D,$58,$11
    db $81,$43,$06,$11,$58,$64,$65,$9E
    db $9F,$71,$81,$58,$00,$3D,$83,$75
    db $81,$60,$8A,$75,$00,$00,$81,$43
    db $00,$11,$83,$71,$03,$58,$64,$65
    db $11,$81,$43,$00,$00,$83,$75,$02
    db $3D,$11,$60,$83,$75,$02,$60,$03
    db $60,$82,$75,$81,$20,$01,$69,$3D
    db $86,$71,$00,$3D,$81,$69,$00,$20
    db $83,$75,$00,$60,$81,$11,$00,$60
    db $81,$75,$03,$60,$11,$A6,$A7,$81
    db $03,$00,$75,$81,$20,$01,$69,$00
    db $81,$43,$05,$44,$43,$44,$43,$44
    db $00,$81,$69,$00,$20,$83,$75,$03
    db $20,$3D,$A6,$A7,$81,$03,$06,$11
    db $A6,$A9,$B7,$A6,$A7,$11,$81,$20
    db $00,$69,$81,$20,$84,$69,$81,$20
    db $81,$69,$01,$20,$11,$82,$75,$03
    db $60,$11,$B6,$B7,$82,$71,$08,$B6
    db $A8,$A7,$B6,$A8,$11,$50,$20,$69
    db $81,$20,$84,$69,$81,$20,$81,$69
    db $01,$50,$11,$81,$75,$01,$60,$11
    db $84,$71,$07,$A6,$A7,$B6,$B7,$71
    db $B6,$75,$11,$81,$43,$81,$20,$84
    db $69,$81,$20,$81,$43,$00,$11,$82
    db $75,$02,$60,$11,$58,$83,$71,$02
    db $B6,$B7,$58,$82,$71,$82,$75,$02
    db $11,$50,$20,$84,$69,$02,$20,$50
    db $11,$84,$75,$0C,$20,$3D,$58,$A6
    db $A7,$A6,$A7,$A6,$A7,$A6,$A7,$A6
    db $A7,$83,$75,$00,$11,$86,$43,$00
    db $11,$85,$75,$0C,$60,$11,$A6,$A9
    db $B7,$B6,$B7,$B6,$B7,$B6,$B7,$B6
    db $B7,$92,$75,$04,$60,$11,$B6,$A8
    db $A7,$81,$71,$05,$A6,$A7,$A6,$A7
    db $A6,$A7,$8D,$75,$11,$A6,$A7,$75
    db $A6,$A7,$20,$60,$11,$B6,$A8,$A7
    db $71,$B6,$B7,$B6,$B7,$B6,$B7,$8D
    db $75,$04,$B6,$B7,$A6,$A9,$B7,$81
    db $20,$05,$60,$11,$B6,$B7,$11,$43
    db $81,$11,$81,$43,$00,$11,$8C,$75
    db $05,$A6,$A7,$A6,$A9,$B7,$3F,$82
    db $20,$00,$60,$81,$43,$01,$60,$69
    db $81,$3D,$81,$69,$00,$3D,$89,$75
    db $08,$A6,$A7,$75,$B6,$B7,$B6,$B7
    db $A6,$A7,$83,$20,$81,$69,$01,$20
    db $69,$81,$60,$81,$69,$00,$60,$89
    db $75,$01,$B6,$B7,$84,$75,$02,$B6
    db $B7,$43,$82,$20,$81,$69,$01,$20
    db $69,$81,$20,$81,$69,$00,$20,$86
    db $75,$04,$10,$11,$71,$58,$6E,$82
    db $6B,$83,$AD,$01,$8E,$99,$81,$98
    db $00,$99,$81,$8F,$05,$99,$98,$89
    db $58,$3D,$50,$86,$75,$03,$3D,$71
    db $58,$71,$83,$68,$83,$AD,$01,$8E
    db $89,$81,$98,$00,$89,$81,$AC,$05
    db $89,$98,$99,$11,$00,$11,$86,$75
    db $04,$4D,$58,$71,$58,$5D,$81,$68
    db $00,$5D,$84,$89,$82,$98,$00,$99
    db $81,$AC,$81,$99,$02,$11,$50,$20
    db $87,$75,$03,$3D,$71,$00,$50,$81
    db $43,$81,$71,$87,$99,$02,$71,$9B
    db $8F,$81,$89,$02,$3D,$69,$20,$87
    db $75,$01,$4D,$3D,$81,$50,$81,$20
    db $02,$50,$71,$6E,$82,$6B,$83,$AD
    db $08,$AF,$AE,$89,$98,$99,$3D,$69
    db $20,$11,$86,$75,$03,$00,$11,$10
    db $11,$81,$43,$01,$50,$3D,$83,$68
    db $83,$AD,$0A,$8E,$89,$98,$99,$11
    db $00,$69,$50,$11,$A6,$A7,$84,$75
    db $03,$20,$50,$11,$10,$81,$3F,$02
    db $11,$3D,$5D,$81,$68,$01,$5D,$58
    db $82,$89,$00,$98,$81,$99,$07,$71
    db $3A,$20,$50,$11,$75,$B6,$B7,$84
    db $75,$04,$20,$69,$50,$11,$03,$81
    db $10,$01,$58,$71,$81,$AC,$01,$58
    db $89,$82,$98,$00,$99,$81,$71,$03
    db $11,$2A,$20,$11,$81,$75,$81,$3F
    db $01,$A6,$A7,$81,$75,$01,$11,$20
    db $81,$69,$00,$50,$82,$11,$01,$71
    db $58,$81,$AC,$00,$71,$83,$99,$03
    db $71,$11,$42,$41,$81,$20,$00,$11
    db $81,$75,$81,$3F,$01,$B6,$B7,$81
    db $75,$01,$11,$50,$82,$69,$01,$41
    db $42,$89,$43,$06,$42,$41,$69,$20
    db $69,$50,$11,$81,$75,$81,$3F,$01
    db $A6,$A7,$82,$75,$01,$11,$50,$83
    db $69,$00,$20,$87,$69,$00,$20,$82
    db $69,$02,$20,$2A,$11,$82,$75,$81
    db $3F,$01,$B6,$B7,$83,$75,$00,$60
    db $83,$43,$02,$50,$69,$50,$81,$43
    db $00,$50,$83,$69,$00,$20,$81,$69
    db $01,$20,$3A,$83,$75,$02,$3F,$A6
    db $A7,$84,$75,$00,$3D,$82,$71,$03
    db $AD,$DA,$69,$DA,$81,$8A,$00,$3D
    db $82,$69,$00,$20,$82,$69,$01,$50
    db $11,$83,$75,$02,$A7,$B6,$B7,$84
    db $75,$01,$3D,$58,$81,$71,$03,$AD
    db $DA,$69,$DA,$81,$8A,$00,$3D,$81
    db $69,$07,$50,$43,$50,$41,$42,$10
    db $03,$10,$82,$75,$00,$B7,$81,$75
    db $02,$60,$03,$60,$81,$75,$07,$60
    db $11,$A6,$A7,$58,$3D,$43,$00,$81
    db $43,$00,$00,$81,$43,$07,$00,$43
    db $00,$11,$75,$00,$43,$00,$85,$75
    db $0B,$3D,$71,$11,$03,$60,$20,$3D
    db $B6,$B7,$11,$60,$75,$83,$20,$81
    db $75,$82,$20,$81,$75,$02,$20,$69
    db $20,$85,$75,$0B,$3D,$A6,$A7,$A6
    db $A7,$43,$11,$A6,$A7,$3D,$20,$75
    db $83,$20,$81,$75,$82,$20,$81,$75
    db $02,$20,$69,$20,$82,$75,$00,$60
    db $81,$03,$0B,$A6,$A9,$A8,$A9,$B7
    db $71,$58,$B6,$B7,$3D,$20,$11,$83
    db $20,$01,$11,$75,$82,$20,$05,$75
    db $11,$20,$69,$20,$11,$81,$75,$0F
    db $3D,$A6,$A7,$B6,$B7,$B6,$A8,$A7
    db $A6,$A7,$A6,$A7,$3D,$20,$11,$50
    db $81,$20,$00,$50,$81,$11,$82,$20
    db $81,$11,$03,$50,$69,$50,$11,$81
    db $75,$0F,$11,$B6,$B7,$A6,$A7,$71
    db $B6,$A8,$A9,$B7,$B6,$B7,$11,$60
    db $75,$11,$81,$43,$0A,$11,$75,$11
    db $50,$20,$50,$11,$75,$11,$43,$11
    db $82,$75,$0D,$58,$A6,$A7,$B6,$A8
    db $A7,$A6,$A9,$A8,$A7,$A6,$A7,$71
    db $11,$81,$03,$00,$60,$83,$75,$02
    db $11,$43,$11,$87,$75,$11,$A7,$B6
    db $B7,$71,$B6,$B7,$B6,$B7,$B6,$A8
    db $A9,$A8,$A7,$71,$A6,$A7,$11,$60
    db $8D,$75,$13,$A8,$A7,$A6,$A7,$A6
    db $A7,$A6,$A7,$A6,$A9,$B7,$B6,$A8
    db $A7,$B6,$A8,$A7,$11,$03,$60,$8B
    db $75,$13,$B6,$B7,$B6,$B7,$B6,$B7
    db $B6,$B7,$B6,$B7,$A6,$A7,$B6,$B7
    db $71,$B6,$A8,$A7,$11,$60,$81,$75
    db $01,$A6,$A7,$87,$75,$17,$A6,$A7
    db $A6,$A7,$A6,$A7,$A6,$A7,$A6,$A7
    db $B6,$B7,$A6,$A7,$71,$A6,$A9,$B7
    db $3D,$20,$75,$A6,$A9,$B7,$87,$75
    db $16,$B6,$A8,$A9,$B7,$B6,$B7,$B6
    db $B7,$B6,$A8,$A7,$A6,$A9,$A8,$A7
    db $B6,$A8,$A7,$11,$60,$75,$B6,$B7
    db $88,$75,$13,$A6,$A9,$B7,$A6,$A7
    db $A6,$A7,$A6,$A7,$B6,$B7,$B6,$B7
    db $B6,$B7,$A6,$A9,$B7,$11,$60,$8B
    db $75,$09,$B6,$B7,$A6,$A9,$A8,$A9
    db $A8,$A9,$B7,$11,$83,$43,$07,$11
    db $B6,$B7,$11,$60,$20,$A6,$A7,$82
    db $75,$01,$A6,$A7,$84,$75,$09,$A6
    db $A7,$B6,$B7,$B6,$B7,$B6,$B7,$58
    db $3D,$83,$69,$00,$60,$81,$11,$00
    db $60,$81,$20,$06,$B6,$A8,$A7,$A6
    db $A7,$B6,$B7,$84,$75,$01,$B6,$B7
    db $81,$43,$81,$11,$03,$43,$11,$71
    db $3D,$83,$69,$00,$20,$81,$60,$82
    db $20,$04,$3F,$B6,$A8,$A9,$B7,$86
    db $75,$01,$43,$60,$81,$69,$81,$60
    db $03,$69,$3D,$58,$3D,$83,$69,$85
    db $20,$03,$A6,$A7,$B6,$B7,$87,$75
    db $01,$69,$20,$81,$69,$81,$20,$03
    db $69,$60,$43,$60,$83,$69,$84,$20
    db $02,$43,$B6,$B7,$89,$75,$83,$75
    db $03,$20,$69,$20,$B8,$81,$B9,$06
    db $B8,$20,$69,$20,$75,$54,$55,$8C
    db $75,$81,$4F,$83,$75,$03,$20,$69
    db $20,$B8,$81,$B9,$06,$B8,$20,$69
    db $20,$04,$9E,$9F,$82,$03,$04,$05
    db $06,$07,$54,$55,$84,$75,$81,$4F
    db $81,$75,$05,$54,$55,$20,$69,$20
    db $B8,$81,$B9,$07,$B8,$20,$69,$20
    db $71,$9E,$9F,$71,$81,$AC,$04,$71
    db $56,$57,$9E,$9F,$84,$75,$81,$4F
    db $81,$75,$05,$9E,$9F,$20,$C6,$C7
    db $C8,$81,$C9,$07,$C8,$C7,$C6,$20
    db $71,$9E,$9F,$71,$81,$AC,$04,$71
    db $64,$65,$9E,$9F,$84,$75,$81,$4F
    db $81,$75,$05,$9E,$9F,$20,$D6,$D7
    db $AA,$81,$AB,$07,$AA,$D7,$D6,$20
    db $11,$9E,$67,$57,$81,$AC,$82,$71
    db $02,$64,$67,$55,$83,$75,$81,$4F
    db $07,$75,$0A,$9E,$9F,$50,$E6,$E7
    db $AA,$81,$AB,$07,$AA,$E7,$E6,$50
    db $11,$64,$9E,$9F,$81,$71,$81,$BC
    db $04,$AE,$71,$64,$65,$0A,$82,$75
    db $81,$4F,$07,$75,$1A,$64,$65,$11
    db $50,$F7,$F8,$81,$F9,$10,$F8,$F7
    db $50,$11,$71,$56,$66,$9F,$71,$53
    db $52,$71,$9B,$8F,$52,$53,$1A,$82
    db $75,$81,$4F,$02,$75,$00,$11,$81
    db $71,$02,$11,$20,$B8,$81,$B9,$0B
    db $B8,$20,$11,$56,$57,$9E,$9F,$67
    db $57,$63,$51,$52,$81,$AC,$02,$62
    db $63,$3D,$82,$75,$81,$4F,$07,$75
    db $20,$3D,$56,$57,$11,$20,$B8,$81
    db $B9,$0B,$B8,$20,$11,$9E,$67,$66
    db $9F,$9E,$9F,$3C,$63,$62,$81,$8A
    db $02,$71,$11,$00,$82,$75,$81,$4F
    db $07,$75,$20,$3D,$64,$65,$11,$50
    db $B8,$81,$B9,$02,$B8,$50,$11,$81
    db $9E,$06,$9F,$67,$66,$9F,$58,$52
    db $53,$81,$8A,$02,$11,$50,$20,$82
    db $75,$81,$4F,$07,$11,$20,$3D,$71
    db $BF,$71,$11,$43,$81,$AC,$0B,$43
    db $56,$57,$64,$9E,$9F,$9E,$9F,$65
    db $58,$62,$63,$81,$AC,$02,$11,$50
    db $20,$82,$75,$81,$4F,$11,$11,$50
    db $3D,$BD,$BA,$BD,$BF,$71,$9B,$8F
    db $58,$64,$65,$71,$64,$65,$9E,$9F
    db $81,$58,$07,$3C,$58,$9B,$8F,$58
    db $3D,$20,$11,$81,$75,$81,$4F,$08
    db $75,$11,$3D,$BF,$BD,$BF,$71,$8F
    db $9B,$81,$58,$84,$2C,$01,$9E,$9F
    db $81,$8A,$07,$AD,$AF,$AE,$58,$3C
    db $3D,$50,$11,$81,$75,$81,$4F,$81
    db $75,$09,$4D,$BA,$BF,$BD,$71,$9B
    db $8F,$58,$71,$2C,$82,$71,$02,$2C
    db $9E,$9F,$81,$8A,$06,$AD,$8E,$58
    db $3C,$58,$4D,$11,$82,$75,$81,$43
    db $81,$75,$08,$40,$42,$43,$11,$8F
    db $9B,$56,$57,$2C,$83,$71,$02,$2C
    db $9E,$9F,$81,$AC,$81,$58,$03,$43
    db $44,$42,$40,$83,$75,$81,$69,$81
    db $75,$00,$20,$81,$69,$00,$3D,$81
    db $AC,$03,$64,$65,$6E,$5D,$81,$68
    db $03,$5D,$6E,$64,$65,$81,$AC,$01
    db $3C,$3D,$82,$69,$00,$20,$83,$75
    db $81,$69,$81,$75,$00,$20,$81,$69
    db $00,$3D,$81,$5D,$00,$6B,$81,$6D
    db $83,$6B,$81,$6D,$00,$6B,$81,$5D
    db $01,$58,$3D,$82,$69,$00,$20,$83
    db $75,$81,$69,$02,$75,$11,$20,$81
    db $69,$00,$3D,$81,$5D,$01,$6B,$6E
    db $84,$2C,$02,$71,$6E,$6B,$81,$5D
    db $01,$71,$3D,$82,$69,$01,$20,$11
    db $82,$75,$81,$69,$09,$75,$11,$42
    db $41,$69,$00,$43,$44,$43,$44,$81
    db $43,$81,$44,$81,$43,$05,$44,$43
    db $44,$43,$44,$00,$81,$69,$02,$41
    db $42,$11,$82,$75,$81,$69,$82,$75
    db $01,$11,$43,$81,$20,$8C,$69,$81
    db $20,$81,$43,$00,$11,$84,$75,$81
    db $69,$84,$75,$81,$20,$8C,$69,$81
    db $20,$87,$75,$82,$69,$81,$20,$00
    db $3D,$85,$71,$04,$3D,$69,$20,$69
    db $20,$84,$69,$02,$20,$69,$20,$81
    db $69,$81,$20,$82,$69,$81,$71,$81
    db $20,$01,$69,$3D,$85,$71,$02,$3D
    db $69,$20,$81,$69,$00,$00,$83,$43
    db $02,$46,$47,$48,$81,$20,$81,$69
    db $00,$20,$81,$69,$81,$71,$81,$20
    db $02,$2A,$00,$11,$83,$71,$06,$11
    db $00,$2A,$69,$20,$2A,$11,$85,$71
    db $02,$11,$42,$41,$81,$20,$82,$69
    db $81,$71,$81,$20,$03,$3A,$20,$40
    db $42,$81,$43,$07,$42,$40,$20,$3A
    db $20,$69,$3A,$71,$81,$8A,$83,$AD
    db $04,$8E,$71,$11,$50,$20,$82,$69
    db $81,$71,$02,$69,$00,$11,$82,$20
    db $81,$69,$82,$20,$04,$3D,$20,$69
    db $3D,$71,$81,$8A,$83,$AD,$81,$AF
    db $03,$8E,$11,$50,$20,$81,$69,$81
    db $71,$00,$43,$81,$11,$00,$50,$81
    db $20,$81,$69,$81,$20,$01,$50,$3D
    db $81,$43,$00,$3D,$87,$71,$04,$8E
    db $8A,$8F,$11,$0F,$81,$69,$81,$71
    db $05,$A6,$A7,$3C,$11,$42,$40,$81
    db $69,$03,$40,$42,$11,$00,$81,$71
    db $01,$40,$42,$83,$43,$00,$11,$82
    db $71,$81,$AC,$01,$71,$1F,$81,$69
    db $81,$71,$05,$B6,$B7,$A6,$A7,$3C
    db $11,$81,$43,$81,$11,$04,$00,$20
    db $71,$11,$20,$84,$69,$03,$40,$42
    db $11,$71,$81,$8A,$01,$71,$2F,$81
    db $69,$81,$71,$04,$A6,$A7,$B6,$B7
    db $11,$82,$43,$01,$42,$40,$81,$20
    db $02,$11,$50,$20,$83,$69,$04,$20
    db $69,$20,$50,$11,$81,$8A,$01,$71
    db $11,$83,$71,$04,$B6,$B7,$3C,$11
    db $00,$83,$69,$82,$20,$02,$3D,$50
    db $20,$84,$69,$03,$20,$69,$20,$3D
    db $81,$AC,$85,$71,$81,$3C,$02,$11
    db $50,$20,$84,$69,$05,$20,$00,$3D
    db $11,$42,$41,$82,$69,$04,$20,$69
    db $20,$69,$3D,$81,$AC,$85,$71,$03
    db $4F,$3C,$4F,$3C,$81,$4F,$00,$3D
    db $96,$3F,$81,$75,$83,$4F,$81,$3C
    db $01,$11,$0A,$95,$3F,$81,$75,$81
    db $8A,$81,$AD,$81,$4F,$01,$3C,$1A
    db $95,$3F,$81,$75,$81,$8A,$81,$AD
    db $03,$4F,$3C,$4F,$3D,$8E,$3F,$00
    db $0A,$81,$03,$01,$02,$01,$81,$3F
    db $81,$75,$81,$AC,$81,$4F,$03,$11
    db $43,$42,$40,$8E,$3F,$00,$1A,$81
    db $4F,$01,$3C,$11,$81,$23,$81,$75
    db $81,$AC,$81,$4F,$00,$3A,$82,$20
    db $8E,$43,$04,$3D,$4F,$3C,$4F,$3C
    db $81,$4F,$81,$75,$82,$4F,$01,$11
    db $2A,$82,$20,$00,$4F,$81,$3C,$01
    db $4F,$3C,$87,$4F,$81,$3C,$03,$00
    db $11,$4F,$3C,$82,$4F,$81,$75,$81
    db $4F,$01,$11,$50,$81,$20,$06,$69
    db $20,$3C,$4F,$3C,$4F,$3C,$88,$4F
    db $04,$3C,$20,$40,$42,$11,$82,$4F
    db $81,$75,$81,$4F,$01,$3D,$69,$81
    db $20,$05,$69,$20,$4F,$3C,$4F,$3C
    db $81,$4F,$81,$AC,$01,$4F,$3C,$81
    db $4F,$02,$3C,$11,$43,$81,$20,$01
    db $69,$50,$82,$43,$81,$75,$81,$4F
    db $01,$3D,$69,$81,$20,$03,$69,$20
    db $3C,$4F,$81,$3C,$01,$4F,$3C,$81
    db $AC,$00,$3C,$82,$4F,$02,$11,$50
    db $69,$81,$20,$84,$69,$81,$75,$03
    db $4F,$3C,$11,$50,$81,$20,$01,$69
    db $20,$81,$8A,$83,$AD,$81,$5D,$01
    db $4F,$3C,$81,$5D,$02,$3D,$50,$43
    db $81,$20,$84,$69,$81,$75,$03,$3C
    db $4F,$3C,$3D,$81,$20,$01,$69,$20
    db $81,$8A,$83,$AD,$81,$68,$01,$3C
    db $4F,$81,$68,$00,$3D,$81,$11,$01
    db $50,$20,$84,$69,$81,$75,$07,$4F
    db $3C,$11,$00,$69,$20,$40,$42,$81
    db $AC,$03,$3C,$4F,$3C,$4F,$81,$5D
    db $81,$3C,$81,$5D,$05,$11,$10,$3F
    db $10,$42,$41,$83,$69,$81,$75,$81
    db $43,$05,$50,$20,$2A,$43,$11,$3C
    db $81,$AC,$00,$4F,$84,$3C,$00,$4F
    db $83,$3C,$05,$11,$03,$11,$3C,$4F
    db $50,$82,$69,$81,$75,$81,$69,$81
    db $20,$00,$3A,$82,$3C,$81,$8A,$83
    db $AD,$81,$5D,$81,$AD,$81,$8A,$81
    db $AD,$81,$8A,$81,$AD,$00,$8E,$82
    db $43,$81,$75,$07,$69,$20,$69,$20
    db $43,$11,$3C,$4F,$81,$8A,$83,$AD
    db $81,$68,$81,$AD,$81,$8A,$81,$AD
    db $81,$8A,$81,$AD,$81,$AF,$01,$8E
    db $4F,$81,$75,$07,$69,$20,$69,$20
    db $69,$50,$11,$3C,$82,$4F,$00,$3C
    db $81,$4F,$81,$5D,$00,$3C,$83,$4F
    db $00,$3C,$81,$4F,$81,$3C,$03,$4F
    db $8E,$AF,$4F,$81,$75,$81,$69,$81
    db $20,$00,$43,$81,$50,$01,$43,$11
    db $81,$60,$82,$3C,$03,$4F,$3C,$4F
    db $3C,$81,$60,$81,$3C,$81,$60,$00
    db $3C,$81,$60,$82,$3C,$81,$75,$08
    db $69,$20,$69,$20,$3F,$11,$50,$69
    db $60,$81,$11,$00,$60,$81,$3C,$00
    db $60,$82,$23,$81,$11,$81,$23,$81
    db $11,$02,$23,$11,$3D,$82,$3C,$81
    db $75,$81,$69,$81,$20,$04,$11,$3F
    db $11,$60,$11,$81,$4F,$00,$11,$81
    db $23,$00,$11,$8A,$4F,$00,$11,$82
    db $23,$81,$75,$07,$69,$20,$69,$50
    db $11,$3F,$60,$11,$95,$4F,$81,$75
    db $9D,$71,$81,$69,$9D,$71,$81,$69
    db $9D,$71,$81,$69,$9D,$71,$81,$69
    db $9D,$71,$81,$69,$82,$71,$00,$7C
    db $81,$71,$81,$7C,$81,$71,$82,$7C
    db $81,$71,$00,$7C,$81,$71,$00,$7C
    db $81,$71,$00,$7C,$81,$71,$00,$7C
    db $84,$71,$81,$43,$81,$71,$08,$7C
    db $71,$7C,$71,$7C,$71,$7C,$71,$7C
    db $82,$71,$0A,$7C,$71,$7C,$71,$7C
    db $71,$7C,$71,$7C,$71,$7C,$88,$71
    db $00,$7C,$82,$71,$04,$7C,$71,$7C
    db $71,$7C,$82,$71,$00,$7C,$82,$71
    db $06,$7C,$71,$7C,$71,$7C,$71,$7C
    db $89,$71,$00,$7C,$81,$71,$03,$7C
    db $71,$7C,$71,$82,$7C,$01,$71,$7C
    db $82,$71,$01,$7C,$71,$82,$7C,$01
    db $71,$7C,$8A,$71,$01,$7C,$71,$81
    db $7C,$81,$71,$00,$7C,$82,$71,$00
    db $7C,$82,$71,$06,$7C,$71,$7C,$71
    db $7C,$71,$7C,$88,$71,$04,$7C,$71
    db $7C,$71,$7C,$82,$71,$00,$7C,$82
    db $71,$0A,$7C,$71,$7C,$71,$7C,$71
    db $7C,$71,$7C,$71,$7C,$86,$71,$81
    db $43,$02,$00,$69,$20,$83,$69,$06
    db $20,$50,$11,$71,$02,$01,$11,$83
    db $43,$03,$42,$41,$20,$3D,$81,$8A
    db $85,$71,$82,$69,$81,$20,$82,$69
    db $06,$41,$42,$A6,$A7,$A6,$A7,$3D
    db $85,$3F,$02,$11,$50,$3D,$81,$8A
    db $85,$71,$81,$43,$02,$60,$20,$50
    db $82,$43,$07,$11,$A6,$A9,$B7,$B6
    db $B7,$00,$11,$85,$3F,$01,$60,$11
    db $81,$AC,$87,$71,$04,$11,$60,$11
    db $A6,$A7,$81,$71,$01,$B6,$B7,$81
    db $71,$02,$3D,$50,$11,$85,$3F,$01
    db $3D,$71,$81,$AC,$88,$71,$06,$11
    db $60,$B6,$B7,$A6,$A7,$71,$81,$8A
    db $02,$AD,$3D,$11,$85,$3F,$02,$10
    db $3D,$71,$81,$AC,$89,$71,$05,$11
    db $60,$71,$B6,$B7,$71,$81,$8A,$01
    db $AD,$3D,$84,$3F,$04,$10,$03,$11
    db $3D,$5D,$81,$68,$00,$5D,$86,$71
    db $00,$3C,$81,$71,$01,$3D,$71,$81
    db $60,$00,$71,$81,$AC,$02,$71,$11
    db $10,$83,$3F,$00,$3D,$81,$71,$01
    db $3D,$5D,$81,$68,$00,$5D,$85,$71
    db $05,$3C,$71,$3C,$71,$11,$43,$81
    db $11,$00,$60,$81,$AC,$00,$71,$81
    db $60,$00,$10,$81,$3F,$00,$60,$82
    db $43,$03,$11,$71,$9B,$8F,$87,$71
    db $00,$3C,$85,$71,$00,$11,$82,$43
    db $81,$11,$00,$43,$81,$03,$00,$11
    db $81,$71,$81,$AD,$01,$AF,$AE,$9B
    db $71,$81,$AD,$00,$8E,$87,$71,$00
    db $87,$81,$88,$00,$97,$81,$86,$81
    db $85,$81,$86,$02,$85,$71,$85,$81
    db $86,$00,$85,$81,$89,$00,$87,$81
    db $88,$01,$87,$85,$81,$86,$00,$85
    db $81,$89,$81,$71,$81,$BB,$03,$58
    db $71,$58,$95,$81,$96,$81,$95,$81
    db $96,$02,$95,$71,$95,$81,$96,$00
    db $95,$81,$99,$00,$85,$81,$86,$01
    db $85,$95,$81,$96,$00,$95,$81,$99
    db $81,$71,$81,$BB,$00,$85,$81,$86
    db $00,$97,$81,$88,$81,$87,$81,$88
    db $02,$87,$58,$87,$81,$88,$00,$87
    db $81,$89,$00,$95,$81,$96,$01,$95
    db $87,$81,$88,$00,$97,$81,$86,$01
    db $85,$71,$81,$BB,$00,$95,$81,$96
    db $01,$95,$58,$81,$71,$00,$58,$81
    db $89,$85,$71,$81,$99,$00,$87,$81
    db $88,$04,$87,$71,$58,$71,$95,$81
    db $96,$01,$95,$71,$81,$BB,$00,$87
    db $81,$88,$01,$87,$85,$81,$86,$00
    db $85,$81,$99,$81,$71,$83,$89,$81
    db $5D,$81,$89,$81,$71,$00,$85,$81
    db $86,$00,$97,$81,$88,$01,$97,$71
    db $81,$BB,$00,$85,$81,$86,$01,$85
    db $95,$81,$96,$00,$95,$83,$71,$83
    db $99,$81,$5D,$81,$99,$81,$89,$00
    db $95,$81,$96,$00,$95,$81,$58,$81
    db $71,$81,$BB,$00,$95,$81,$96,$01
    db $95,$87,$81,$88,$00,$87,$81,$71
    db $83,$89,$02,$58,$71,$58,$82,$71
    db $81,$99,$00,$87,$81,$88,$01,$87
    db $85,$81,$86,$00,$71,$81,$BB,$00
    db $87,$81,$88,$01,$87,$85,$81,$86
    db $00,$85,$81,$71,$83,$99,$00,$85
    db $81,$86,$00,$85,$83,$89,$00,$85
    db $81,$86,$01,$85,$95,$81,$96,$00
    db $71,$81,$BB,$00,$85,$81,$86,$01
    db $85,$95,$81,$96,$00,$95,$81,$71
    db $83,$89,$00,$95,$81,$96,$00,$95
    db $83,$99,$00,$95,$81,$96,$01,$95
    db $87,$81,$88,$00,$71,$81,$BB,$00
    db $95,$81,$96,$01,$95,$87,$81,$88
    db $00,$87,$81,$71,$83,$99,$00,$87
    db $81,$88,$01,$87,$58,$82,$71,$00
    db $87,$81,$88,$00,$87,$83,$71,$81
    db $BB,$00,$87,$81,$88,$00,$97,$81
    db $86,$01,$85,$71,$81,$89,$81,$71
    db $83,$89,$00,$71,$81,$89,$00,$71
    db $81,$2B,$85,$89,$81,$71,$81,$BB
    db $00,$71,$81,$58,$00,$95,$81,$96
    db $01,$95,$71,$81,$99,$81,$71,$83
    db $99,$00,$58,$81,$99,$00,$58,$81
    db $2B,$85,$99,$81,$71,$81,$E8,$00
    db $85,$81,$86,$00,$97,$81,$88,$00
    db $87,$82,$71,$81,$89,$82,$71,$81
    db $89,$00,$71,$81,$89,$81,$71,$81
    db $89,$00,$85,$81,$86,$00,$85,$81
    db $71,$81,$3F,$00,$95,$81,$96,$00
    db $95,$81,$89,$83,$71,$81,$99,$00
    db $71,$81,$89,$81,$99,$00,$71,$81
    db $99,$81,$71,$81,$99,$00,$95,$81
    db $96,$00,$95,$81,$71,$81,$3F,$00
    db $87,$81,$88,$00,$87,$81,$99,$83
    db $89,$02,$58,$71,$58,$81,$99,$00
    db $71,$81,$89,$00,$71,$81,$89,$00
    db $85,$81,$86,$00,$97,$81,$88,$00
    db $87,$81,$71,$81,$D8,$81,$89,$00
    db $85,$81,$86,$00,$85,$83,$99,$00
    db $85,$81,$86,$00,$85,$81,$71,$81
    db $99,$00,$71,$81,$99,$00,$95,$81
    db $96,$01,$95,$71,$81,$89,$81,$71
    db $81,$3F,$81,$99,$00,$95,$81,$96
    db $00,$95,$83,$89,$00,$95,$81,$96
    db $00,$95,$83,$89,$00,$85,$81,$86
    db $00,$97,$81,$88,$01,$87,$58,$81
    db $99,$81,$71,$81,$3F,$81,$71,$00
    db $87,$81,$88,$00,$87,$83,$99,$00
    db $87,$81,$88,$00,$87,$83,$99,$00
    db $95,$81,$96,$00,$95,$81,$89,$00
    db $85,$81,$86,$00,$85,$81,$71,$81
    db $3F,$00,$71,$81,$89,$01,$71,$58
    db $83,$89,$00,$71,$81,$89,$00,$85
    db $81,$86,$00,$85,$81,$58,$00,$87
    db $81,$88,$00,$87,$81,$99,$00,$95
    db $81,$96,$00,$95,$81,$71,$81,$D9
    db $00,$71,$81,$99,$01,$58,$71,$83
    db $99,$00,$58,$81,$99,$00,$95,$81
    db $96,$00,$95,$81,$89,$00,$85,$81
    db $86,$00,$85,$81,$89,$00,$87,$81
    db $88,$00,$87,$81,$71,$81,$D8,$01
    db $71,$85,$81,$86,$03,$85,$71,$58
    db $85,$81,$86,$02,$85,$71,$87,$81
    db $88,$00,$87,$81,$99,$00,$95,$81
    db $96,$00,$95,$81,$99,$85,$71,$81
    db $3F,$83,$75,$03,$20,$69,$20,$B8
    db $81,$B9,$03,$B8,$20,$69,$20,$8F
    db $75,$81,$4F,$82,$71,$00,$7C,$81
    db $71,$00,$7C,$82,$71,$82,$7C,$81
    db $71,$00,$7C,$81,$71,$05,$7C,$71
    db $7C,$71,$7C,$71,$82,$7C,$82,$71
    db $81,$43,$9D,$71,$81,$69,$85,$71
    db $81,$7B,$83,$71,$81,$7B,$83,$71
    db $81,$7B,$83,$71,$81,$7B,$83,$71
    db $81,$43,$85,$71,$81,$7B,$83,$71
    db $81,$7B,$83,$71,$81,$7B,$83,$71
    db $81,$7B,$C7,$71,$81,$5D,$81,$6B
    db $81,$5D,$83,$71,$81,$7B,$83,$71
    db $81,$7B,$83,$71,$81,$7B,$87,$71
    db $81,$5D,$81,$6B,$81,$5D,$83,$71
    db $81,$7B,$83,$71,$81,$7B,$83,$71
    db $81,$7B,$C5,$71,$83,$BB,$00,$7C
    db $88,$BB,$81,$10,$81,$BB,$81,$7B
    db $89,$BB,$81,$71,$81,$BB,$01,$B0
    db $B1,$86,$BB,$02,$7C,$BB,$10,$81
    db $11,$01,$10,$BB,$81,$7B,$82,$BB
    db $00,$7C,$85,$BB,$81,$71,$03,$BB
    db $E0,$C0,$C1,$82,$BB,$81,$7B,$82
    db $BB,$01,$10,$11,$81,$5D,$01,$11
    db $10,$8B,$BB,$81,$71,$03,$BB,$E1
    db $D0,$D1,$82,$BB,$81,$7B,$82,$BB
    db $08,$3D,$4F,$5D,$68,$4F,$11,$10
    db $BB,$7C,$83,$BB,$81,$7B,$82,$BB
    db $81,$71,$8A,$BB,$00,$10,$82,$4F
    db $81,$6C,$01,$4F,$3D,$85,$BB,$81
    db $7B,$82,$BB,$81,$71,$82,$BB,$00
    db $10,$86,$03,$84,$4F,$81,$6C,$04
    db $11,$03,$04,$03,$04,$82,$03,$00
    db $10,$82,$BB,$81,$71,$81,$7B,$01
    db $BB,$3D,$81,$5D,$83,$6B,$81,$5D
    db $84,$4F,$02,$6C,$68,$5D,$83,$4F
    db $81,$5D,$00,$3D,$82,$BB,$81,$71
    db $81,$7B,$01,$BB,$3D,$81,$5D,$83
    db $6B,$81,$5D,$05,$4F,$12,$13,$14
    db $15,$4F,$81,$5D,$83,$4F,$02,$68
    db $5D,$3D,$82,$BB,$81,$71,$82,$BB
    db $00,$00,$87,$4F,$05,$58,$31,$32
    db $33,$34,$58,$84,$4F,$81,$6C,$01
    db $11,$00,$82,$BB,$81,$71,$04,$BB
    db $7C,$BB,$20,$50,$85,$4F,$07,$58
    db $4F,$35,$36,$37,$38,$4F,$58,$82
    db $4F,$81,$6C,$02,$11,$50,$20,$82
    db $BB,$81,$71,$82,$BB,$02,$20,$69
    db $00,$81,$4F,$81,$5D,$10,$4F,$58
    db $4F,$35,$36,$37,$38,$4F,$58,$4F
    db $5D,$68,$6C,$11,$00,$69,$20,$82
    db $BB,$81,$71,$02,$E8,$E9,$E8,$81
    db $20,$04,$69,$50,$4F,$68,$5D,$81
    db $4F,$05,$58,$49,$4A,$59,$5A,$58
    db $81,$4F,$81,$5D,$02,$4F,$3D,$69
    db $81,$20,$82,$E8,$81,$71,$82,$3F
    db $05,$20,$69,$20,$50,$4F,$68,$84
    db $4F,$81,$5D,$86,$4F,$03,$3D,$20
    db $69,$20,$82,$D8,$81,$71,$81,$3F
    db $04,$D8,$20,$69,$00,$11,$81,$6C
    db $84,$4F,$03,$5D,$68,$6D,$6E,$84
    db $4F,$03,$11,$00,$69,$20,$82,$3F
    db $81,$71,$05,$D8,$D9,$3F,$20,$50
    db $11,$81,$6C,$85,$4F,$81,$11,$00
    db $6E,$81,$6D,$00,$6E,$83,$4F,$02
    db $11,$50,$20,$82,$D9,$81,$71,$04
    db $3F,$D8,$D9,$00,$11,$81,$6C,$85
    db $4F,$05,$11,$00,$50,$43,$11,$6E
    db $81,$6D,$00,$6E,$83,$4F,$00,$00
    db $82,$3F,$81,$71,$81,$3F,$03,$10
    db $11,$5D,$68,$84,$4F,$09,$11,$43
    db $50,$69,$20,$69,$50,$11,$4F,$6E
    db $81,$6D,$00,$6E,$81,$5D,$01,$4F
    db $10,$81,$3F,$81,$71,$81,$3F,$01
    db $3D,$4F,$81,$5D,$81,$4F,$00,$11
    db $81,$43,$00,$00,$82,$69,$00,$20
    db $81,$69,$01,$00,$18,$81,$4F,$05
    db $6E,$6D,$68,$5D,$4F,$3D,$81,$3F
    db $81,$71,$02,$D9,$3F,$3D,$82,$4F
    db $02,$11,$43,$50,$82,$69,$00,$20
    db $81,$69,$08,$20,$69,$20,$69,$48
    db $47,$46,$45,$11,$82,$4F,$00,$00
    db $81,$3F,$81,$71,$03,$D8,$D9,$40
    db $42,$81,$43,$02,$50,$69,$20,$82
    db $69,$02,$20,$69,$20,$82,$69,$00
    db $20,$83,$69,$00,$00,$81,$43,$01
    db $50,$20,$81,$3F,$81,$71,$81,$3F
    db $02,$20,$69,$20,$81,$69,$00,$20
    db $83,$69,$00,$20,$81,$69,$02,$20
    db $69,$20,$84,$69,$04,$20,$69,$20
    db $69,$20,$81,$3F,$81,$71,$03,$4F
    db $3C,$4F,$3C,$81,$4F,$00,$3D,$96
    db $3F,$81,$75

OWTilemap:
    db $9B,$1C,$03,$58,$18
    db $1C,$58,$9B,$1C,$03,$58,$18,$1C
    db $58,$9A,$1C,$04,$10,$58,$18,$1C
    db $58,$94,$1C,$81,$10,$81,$50,$82
    db $10,$03,$50,$18,$14,$58,$90,$1C
    db $81,$5C,$84,$10,$00,$50,$82,$10
    db $03,$50,$10,$50,$90,$90,$1C,$00
    db $5C,$81,$10,$8B,$50,$89,$1C,$82
    db $10,$81,$50,$81,$1C,$00,$5C,$86
    db $10,$00,$50,$82,$10,$00,$50,$81
    db $D0,$89,$1C,$83,$10,$00,$50,$81
    db $1C,$00,$5C,$81,$10,$84,$90,$00
    db $D0,$82,$90,$02,$D0,$50,$18,$89
    db $1C,$00,$50,$81,$90,$81,$D0,$81
    db $1C,$01,$18,$50,$84,$90,$85,$10
    db $81,$50,$88,$1C,$01,$D4,$58,$82
    db $1C,$03,$18,$94,$1C,$18,$81,$58
    db $82,$5C,$00,$50,$82,$90,$84,$50
    db $88,$1C,$81,$54,$81,$1C,$82,$14
    db $01,$1C,$18,$81,$58,$81,$5C,$03
    db $18,$5C,$58,$18,$84,$90,$00,$D0
    db $89,$1C,$00,$54,$82,$14,$82,$1C
    db $00,$18,$81,$58,$82,$5C,$81,$58
    db $01,$5C,$58,$82,$5C,$01,$18,$14
    db $86,$1C,$81,$10,$87,$1C,$01,$58
    db $98,$83,$18,$81,$58,$00,$18,$83
    db $5C,$01,$18,$14,$86,$1C,$81,$10
    db $81,$50,$85,$10,$00,$58,$85,$98
    db $81,$18,$00,$58,$82,$5C,$01,$18
    db $14,$84,$1C,$84,$10,$81,$50,$06
    db $10,$50,$10,$50,$10,$58,$18,$83
    db $5C,$81,$98,$01,$18,$58,$82,$18
    db $01,$D8,$18,$84,$1C,$01,$10,$50
    db $81,$10,$02,$50,$10,$50,$81,$10
    db $05,$D0,$50,$D0,$58,$5C,$58,$83
    db $5C,$84,$98,$02,$D8,$18,$98,$84
    db $1C,$83,$10,$00,$50,$82,$10,$84
    db $50,$00,$18,$84,$5C,$00,$18,$82
    db $5C,$03,$18,$14,$58,$5C,$83,$1C
    db $85,$10,$00,$50,$81,$10,$81,$50
    db $00,$90,$82,$50,$00,$58,$84,$5C
    db $00,$58,$81,$5C,$03,$18,$14,$58
    db $5C,$82,$1C,$8A,$10,$83,$50,$84
    db $10,$01,$50,$18,$82,$5C,$03,$18
    db $14,$58,$5C,$82,$1C,$89,$10,$81
    db $50,$81,$90,$85,$10,$81,$50,$00
    db $58,$81,$5C,$03,$18,$14,$58,$5C
    db $82,$1C,$85,$10,$00,$50,$84,$10
    db $01,$50,$D0,$81,$10,$00,$50,$83
    db $10,$00,$50,$81,$10,$04,$50,$18
    db $14,$58,$5C,$82,$1C,$01,$50,$90
    db $81,$10,$01,$50,$10,$83,$18,$02
    db $10,$50,$D0,$82,$90,$00,$D0,$81
    db $90,$00,$10,$81,$50,$81,$10,$02
    db $50,$14,$58,$81,$14,$82,$1C,$00
    db $58,$81,$90,$03,$50,$90,$10,$D0
    db $82,$90,$04,$D0,$90,$10,$5C,$50
    db $81,$90,$02,$10,$D0,$10,$81,$50
    db $82,$10,$00,$50,$82,$58,$82,$1C
    db $00,$58,$82,$10,$02,$50,$10,$D0
    db $82,$90,$01,$10,$5C,$81,$14,$07
    db $54,$58,$18,$90,$10,$D0,$10,$50
    db $81,$18,$01,$10,$50,$82,$58,$82
    db $1C,$00,$D0,$82,$10,$00,$50,$81
    db $D0,$02,$58,$5C,$18,$82,$14,$01
    db $58,$54,$81,$14,$00,$54,$82,$10
    db $83,$18,$00,$10,$82,$50,$81,$1C
    db $84,$10,$81,$50,$84,$14,$85,$58
    db $81,$10,$01,$90,$10,$84,$18,$81
    db $10,$00,$90,$81,$1C,$84,$10,$82
    db $50,$87,$58,$01,$10,$50,$83,$10
    db $00,$D0,$82,$18,$02,$90,$D0,$10
    db $82,$1C,$83,$10,$03,$90,$D0,$10
    db $50,$86,$58,$01,$10,$50,$88,$10
    db $81,$D0,$01,$1C,$58,$81,$1C,$01
    db $50,$90,$82,$10,$03,$50,$D0,$10
    db $94,$84,$58,$83,$10,$00,$50,$83
    db $10,$01,$18,$10,$81,$D0,$01,$1C
    db $18,$82,$1C,$00,$58,$83,$10,$81
    db $50,$81,$14,$84,$58,$83,$10,$00
    db $D0,$84,$10,$81,$D0,$82,$1C,$00
    db $58,$81,$1C,$00,$58,$83,$10,$81
    db $50,$83,$58,$00,$10,$81,$50,$87
    db $10,$81,$D0,$00,$58,$82,$1C,$81
    db $14,$04,$1C,$D4,$58,$50,$90,$81
    db $10,$82,$50,$82,$58,$83,$10,$00
    db $18,$83,$10,$03,$18,$10,$D0,$18
    db $82,$1C,$81,$14,$01,$1C,$18,$9E
    db $1C,$00,$18,$9E,$1C,$01,$18,$50
    db $95,$1C,$83,$10,$83,$1C,$00,$10
    db $81,$50,$90,$1C,$87,$10,$83,$1C
    db $01,$90,$10,$81,$50,$8D,$1C,$89
    db $10,$01,$50,$5C,$81,$1C,$82,$90
    db $81,$50,$8B,$1C,$81,$10,$84,$50
    db $83,$10,$81,$50,$81,$1C,$81,$58
    db $02,$90,$10,$50,$8B,$1C,$82,$10
    db $84,$18,$00,$50,$82,$10,$00,$50
    db $81,$1C,$82,$58,$01,$10,$50,$8B
    db $1C,$01,$10,$90,$85,$18,$00,$58
    db $81,$50,$01,$D0,$10,$81,$1C,$81
    db $58,$02,$10,$D0,$10,$87,$1C,$83
    db $18,$00,$50,$81,$90,$84,$18,$01
    db $D0,$10,$81,$D0,$00,$18,$81,$1C
    db $01,$58,$10,$81,$D0,$01,$18,$58
    db $85,$1C,$84,$18,$00,$58,$87,$90
    db $81,$D0,$01,$5C,$18,$81,$1C,$05
    db $10,$90,$D0,$5C,$18,$58,$88,$18
    db $04,$58,$D8,$58,$5C,$58,$81,$1C
    db $85,$5C,$01,$58,$18,$81,$1C,$01
    db $58,$18,$81,$5C,$01,$18,$58,$86
    db $18,$81,$98,$00,$D8,$81,$58,$01
    db $18,$5C,$81,$1C,$84,$5C,$07,$18
    db $5C,$18,$50,$1C,$58,$5C,$58,$81
    db $18,$00,$58,$85,$1C,$82,$18,$01
    db $58,$18,$82,$58,$81,$1C,$85,$5C
    db $01,$58,$18,$81,$50,$00,$58,$82
    db $18,$01,$D8,$18,$83,$10,$81,$50
    db $81,$18,$00,$D8,$82,$18,$00,$58
    db $82,$18,$00,$58,$83,$5C,$04,$18
    db $5C,$18,$10,$50,$82,$18,$81,$D8
    db $01,$18,$D0,$83,$90,$04,$50,$58
    db $98,$18,$D8,$83,$18,$02,$98,$D8
    db $18,$84,$5C,$00,$58,$81,$10,$00
    db $50,$81,$98,$04,$18,$58,$5C,$18
    db $D0,$82,$5C,$81,$90,$00,$58,$87
    db $98,$01,$D8,$18,$83,$5C,$00,$18
    db $82,$10,$01,$50,$18,$81,$98,$02
    db $18,$5C,$18,$83,$14,$81,$54,$00
    db $58,$81,$5C,$00,$58,$84,$5C,$01
    db $58,$18,$82,$5C,$83,$10,$81,$50
    db $05,$5C,$58,$5C,$18,$5C,$18,$85
    db $1C,$02,$58,$5C,$18,$84,$5C,$02
    db $18,$5C,$18,$87,$10,$01,$50,$18
    db $81,$5C,$01,$18,$5C,$81,$14,$83
    db $58,$01,$D4,$58,$81,$5C,$00,$58
    db $84,$5C,$00,$58,$82,$10,$02,$50
    db $10,$50,$81,$10,$05,$D0,$10,$5C
    db $58,$5C,$18,$81,$14,$00,$18,$83
    db $58,$81,$54,$01,$5C,$18,$84,$5C
    db $00,$18,$81,$10,$05,$50,$10,$50
    db $10,$50,$10,$81,$50,$81,$18,$81
    db $5C,$01,$18,$94,$86,$58,$82,$54
    db $00,$58,$86,$10,$05,$50,$10,$50
    db $10,$50,$10,$81,$50,$03,$18,$14
    db $54,$5C,$81,$14,$01,$58,$18,$85
    db $58,$02,$18,$54,$14,$82,$10,$00
    db $50,$82,$10,$02,$50,$D0,$90,$81
    db $10,$82,$50,$02,$18,$58,$54,$81
    db $14,$81,$58,$84,$18,$83,$58,$83
    db $10,$02,$50,$10,$50,$81,$10,$07
    db $50,$10,$50,$10,$50,$10,$50,$14
    db $82,$58,$02,$10,$50,$58,$82,$18
    db $01,$10,$50,$82,$58,$82,$10,$00
    db $50,$81,$10,$81,$50,$02,$10,$50
    db $10,$81,$50,$04,$10,$50,$10,$50
    db $14,$82,$50,$81,$10,$00,$94,$81
    db $18,$81,$10,$01,$50,$10,$81,$50
    db $83,$10,$0D,$50,$10,$50,$10,$50
    db $10,$50,$10,$50,$10,$50,$10,$50
    db $1C,$82,$90,$00,$D0,$81,$14,$01
    db $18,$10,$83,$90,$82,$10,$01,$50
    db $10,$81,$50,$07,$10,$50,$10,$50
    db $10,$50,$10,$50,$81,$10,$82,$50
    db $81,$1C,$81,$18,$82,$14,$00,$58
    db $81,$1C,$00,$18,$81,$90,$81,$10
    db $00,$50,$81,$10,$00,$50,$81,$10
    db $0A,$50,$10,$50,$10,$50,$10,$50
    db $10,$50,$10,$50,$81,$1C,$81,$18
    db $82,$14,$00,$58,$82,$1C,$00,$58
    db $82,$90,$04,$10,$50,$10,$50,$10
    db $81,$50,$81,$10,$81,$50,$05,$10
    db $50,$10,$50,$10,$50,$81,$1C,$81
    db $18,$82,$14,$00,$58,$81,$1C,$00
    db $18,$82,$1C,$81,$10,$02,$50,$10
    db $50,$81,$10,$06,$50,$10,$50,$10
    db $50,$14,$10,$81,$50,$01,$D0,$10
    db $82,$1C,$81,$14,$02,$18,$D4,$58
    db $82,$1C,$00,$58,$81,$1C,$84,$10
    db $00,$50,$81,$10,$01,$50,$10,$81
    db $50,$02,$10,$50,$10,$81,$50,$02
    db $18,$14,$54,$81,$14,$01,$18,$58
    db $85,$54,$83,$10,$06,$50,$10,$50
    db $10,$50,$10,$50,$81,$10,$03,$50
    db $10,$50,$10,$81,$50,$00,$18,$87
    db $1C,$83,$50,$83,$10,$02,$50,$10
    db $50,$81,$10,$06,$50,$10,$50,$10
    db $50,$10,$50,$81,$10,$02,$50,$18
    db $1C,$81,$54,$00,$58,$82,$10,$01
    db $50,$10,$83,$50,$89,$10,$81,$D0
    db $02,$1C,$58,$1C,$81,$14,$83,$1C
    db $04,$54,$58,$50,$90,$D0,$86,$10
    db $81,$18,$00,$50,$84,$10,$81,$D0
    db $01,$58,$18,$82,$14,$85,$1C,$00
    db $D0,$81,$10,$01,$50,$D0,$82,$10
    db $02,$50,$10,$90,$81,$18,$00,$D0
    db $83,$10,$81,$D0,$01,$18,$1C,$81
    db $14,$86,$1C,$83,$10,$81,$50,$00
    db $D0,$81,$90,$00,$D0,$87,$10,$81
    db $D0,$81,$1C,$01,$58,$14,$81,$1C
    db $81,$14,$83,$1C,$01,$50,$90,$81
    db $10,$00,$D0,$83,$10,$00,$50,$84
    db $10,$01,$D0,$90,$81,$D0,$81,$1C
    db $00,$18,$87,$14,$81,$1C,$00,$58
    db $82,$90,$01,$D0,$18,$82,$10,$00
    db $50,$83,$10,$81,$D0,$00,$58,$83
    db $1C,$81,$14,$00,$1C,$81,$14,$81
    db $58,$81,$14,$81,$1C,$05,$58,$1C
    db $18,$58,$1C,$18,$86,$90,$81,$D0
    db $02,$1C,$58,$5C,$81,$1C,$83,$14
    db $85,$58,$81,$1C,$04,$58,$1C,$18
    db $58,$1C,$81,$18,$00,$58,$84,$1C
    db $00,$58,$81,$1C,$00,$58,$81,$1C
    db $81,$14,$00,$1C,$81,$14,$85,$58
    db $81,$1C,$07,$58,$1C,$18,$58,$1C
    db $18,$1C,$58,$83,$1C,$01,$18,$5C
    db $81,$1C,$00,$58,$84,$14,$87,$58
    db $81,$1C,$04,$58,$1C,$18,$58,$1C
    db $81,$18,$01,$1C,$5C,$83,$1C,$01
    db $58,$1C,$82,$14,$81,$1C,$81,$14
    db $87,$58,$81,$1C,$07,$58,$1C,$18
    db $58,$1C,$18,$54,$58,$83,$1C,$00
    db $18,$82,$14,$83,$1C,$81,$14,$87
    db $58,$81,$1C,$06,$58,$1C,$18,$58
    db $1C,$18,$54,$86,$14,$85,$1C,$81
    db $14,$87,$58,$81,$1C,$05,$58,$1C
    db $18,$58,$1C,$18,$84,$10,$81,$50
    db $87,$1C,$81,$14,$86,$58,$02,$1C
    db $10,$58,$81,$10,$81,$50,$00,$18
    db $86,$10,$00,$50,$86,$1C,$83,$14
    db $83,$58,$03,$14,$1C,$10,$50,$81
    db $10,$81,$50,$87,$10,$00,$50,$88
    db $1C,$81,$14,$00,$58,$81,$14,$09
    db $58,$14,$1C,$10,$D0,$58,$18,$58
    db $18,$90,$86,$10,$00,$50,$8B,$1C
    db $81,$14,$82,$1C,$00,$10,$81,$50
    db $01,$18,$58,$88,$10,$00,$50,$90
    db $1C,$81,$10,$00,$50,$8A,$10,$00
    db $50,$83,$1C,$01,$18,$58,$8A,$1C
    db $00,$50,$82,$90,$86,$10,$00,$D0
    db $81,$90,$00,$10,$83,$1C,$00,$18
    db $81,$58,$83,$1C,$81,$18,$00,$58
    db $82,$1C,$81,$58,$00,$1C,$87,$10
    db $00,$50,$81,$1C,$00,$18,$83,$1C
    db $81,$98,$81,$58,$81,$1C,$85,$18
    db $00,$1C,$81,$58,$01,$1C,$50,$86
    db $90,$00,$10,$81,$1C,$00,$18,$83
    db $1C,$00,$58,$8A,$18,$00,$D4,$81
    db $58,$00,$1C,$81,$58,$84,$1C,$81
    db $18,$81,$1C,$01,$18,$94,$82,$1C
    db $8B,$18,$81,$54,$01,$58,$1C,$81
    db $58,$84,$1C,$81,$18,$81,$1C,$81
    db $14,$81,$1C,$8C,$18,$01,$1C,$54
    db $81,$14,$81,$58,$84,$1C,$81,$18
    db $82,$14,$82,$1C,$81,$98,$8A,$18
    db $82,$1C,$81,$54,$00,$58,$84,$1C
    db $00,$18,$81,$14,$84,$1C,$00,$58
    db $8B,$18,$83,$1C,$00,$54,$87,$14
    db $85,$1C,$8C,$18,$92,$1C,$81,$98
    db $8A,$18,$8D,$1C,$81,$14,$00,$1C
    db $81,$14,$00,$58,$81,$98,$89,$18
    db $8D,$1C,$84,$14,$81,$58,$81,$98
    db $81,$18,$00,$D8,$81,$98,$00,$D8
    db $82,$98,$8C,$1C,$84,$14,$83,$58
    db $82,$98,$03,$D8,$1C,$18,$58,$81
    db $1C,$00,$18,$89,$1C,$81,$14,$00
    db $1C,$85,$14,$83,$58,$81,$1C,$03
    db $18,$1C,$98,$D8,$81,$1C,$00,$98
    db $89,$1C,$81,$14,$84,$1C,$82,$14
    db $82,$58,$81,$1C,$03,$18,$1C,$58
    db $18,$81,$1C,$00,$58,$86,$1C,$83
    db $10,$83,$50,$86,$10,$82,$50,$82
    db $10,$03,$50,$10,$50,$14,$86,$1C
    db $83,$10,$83,$18,$84,$90,$06,$10
    db $50,$10,$50,$10,$50,$10,$81,$50
    db $02,$D0,$10,$14,$86,$1C,$83,$10
    db $00,$90,$81,$18,$07,$D0,$10,$50
    db $10,$50,$10,$50,$10,$81,$50,$03
    db $10,$50,$10,$50,$81,$D0,$00,$18
    db $87,$1C,$82,$10,$82,$90,$82,$10
    db $0A,$50,$10,$50,$10,$50,$10,$50
    db $10,$50,$90,$10,$81,$50,$01,$1C
    db $18,$87,$1C,$07,$10,$50,$14,$54
    db $58,$18,$90,$10,$83,$50,$83,$10
    db $02,$50,$90,$10,$82,$50,$02,$1C
    db $18,$94,$86,$1C,$03,$50,$90,$50
    db $54,$81,$14,$01,$54,$10,$83,$18
    db $84,$90,$00,$10,$81,$50,$02,$D0
    db $10,$1C,$83,$14,$84,$1C,$00,$58
    db $81,$90,$00,$50,$81,$58,$02,$54
    db $10,$90,$81,$18,$00,$D0,$81,$10
    db $07,$50,$10,$50,$10,$50,$10,$D0
    db $18,$81,$14,$00,$1C,$81,$14,$84
    db $1C,$01,$58,$1C,$81,$90,$81,$50
    db $83,$10,$00,$50,$81,$10,$01,$50
    db $10,$81,$50,$81,$10,$81,$D0,$01
    db $18,$14,$81,$1C,$81,$58,$81,$14
    db $81,$1C,$01,$D4,$58,$81,$1C,$81
    db $90,$00,$50,$83,$10,$00,$50,$81
    db $10,$03,$50,$10,$50,$10,$82,$D0
    db $02,$58,$18,$94,$81,$1C,$81,$58
    db $81,$14,$81,$1C,$81,$54,$82,$1C
    db $8B,$90,$81,$D0,$02,$1C,$18,$1C
    db $81,$14,$81,$1C,$81,$58,$81,$14
    db $82,$1C,$81,$54,$83,$1C,$00,$58
    db $87,$1C,$00,$18,$82,$1C,$00,$18
    db $81,$14,$82,$1C,$81,$58,$81,$14
    db $83,$1C,$84,$18,$01,$58,$1C,$82
    db $10,$00,$50,$83,$1C,$00,$58,$81
    db $1C,$01,$18,$14,$83,$1C,$00,$58
    db $81,$14,$84,$1C,$84,$18,$01,$58
    db $1C,$81,$10,$81,$50,$82,$1C,$00
    db $18,$82,$1C,$81,$14,$83,$1C,$82
    db $14,$84,$1C,$83,$18,$02,$98,$D8
    db $1C,$81,$90,$01,$D0,$50,$81,$1C
    db $81,$18,$00,$58,$81,$14,$81,$10
    db $00,$50,$82,$1C,$00,$14,$81,$1C
    db $81,$18,$00,$58,$81,$1C,$81,$98
    db $82,$18,$02,$58,$14,$50,$81,$90
    db $00,$10,$81,$14,$07,$58,$98,$18
    db $14,$1C,$50,$90,$10,$85,$1C,$81
    db $18,$01,$58,$18,$81,$58,$82,$18
    db $81,$D8,$00,$1C,$81,$58,$81,$18
    db $81,$1C,$81,$58,$00,$18,$81,$1C
    db $02,$58,$1C,$18,$85,$1C,$88,$18
    db $02,$58,$18,$1C,$81,$58,$81,$18
    db $81,$1C,$81,$58,$00,$18,$81,$1C
    db $02,$58,$1C,$18,$82,$1C,$8B,$18
    db $02,$58,$18,$D4,$81,$58,$81,$18
    db $01,$94,$1C,$81,$58,$06,$18,$1C
    db $D4,$58,$1C,$18,$94,$81,$1C,$8B
    db $18,$01,$58,$18,$81,$54,$01,$58
    db $18,$81,$14,$00,$D4,$81,$58,$01
    db $18,$94,$81,$54,$00,$1C,$81,$14
    db $81,$1C,$8B,$18,$81,$58,$01,$1C
    db $54,$82,$14,$00,$1C,$81,$54,$00
    db $58,$81,$14,$01,$1C,$54,$81,$14
    db $82,$1C,$8C,$18,$00,$58,$81,$18
    db $00,$58,$83,$1C,$00,$54,$81,$14
    db $87,$1C,$8F,$18,$81,$58,$8D,$1C
    db $90,$18,$02,$58,$18,$58,$8B,$1C
    db $91,$18,$81,$D8,$81,$1C,$81,$14
    db $87,$1C,$91,$18,$02,$58,$18,$1C
    db $82,$14,$87,$1C,$91,$18,$81,$58
    db $00,$1C,$81,$14,$88,$1C,$91,$18
    db $81,$D8,$8B,$1C,$88,$18,$00,$D8
    db $84,$98,$81,$18,$81,$D8,$00,$18
    db $81,$14,$82,$1C,$81,$14,$84,$1C
    db $88,$18,$00,$58,$83,$1C,$81,$98
    db $81,$D8,$81,$18,$86,$14,$84,$1C
    db $81,$18,$82,$98,$00,$D8,$81,$98
    db $01,$18,$58,$83,$1C,$02,$58,$98
    db $D8,$82,$18,$00,$58,$83,$14,$86
    db $1C,$01,$98,$D8,$81,$1C,$02,$98
    db $D8,$1C,$81,$18,$00,$58,$83,$1C
    db $81,$58,$83,$18,$83,$14,$88,$1C
    db $00,$18,$81,$1C,$02,$58,$18,$1C
    db $81,$98,$00,$D8,$83,$1C,$81,$58
    db $82,$18,$82,$14,$89,$1C,$83,$14
    db $00,$50,$83,$10,$82,$50,$81,$10
    db $00,$14,$81,$18,$8C,$14,$81,$10
    db $83,$14,$00,$50,$83,$10,$82,$50
    db $82,$10,$81,$18,$85,$10,$81,$18
    db $84,$14,$81,$10,$81,$14,$81,$18
    db $00,$50,$83,$10,$82,$50,$82,$10
    db $81,$18,$81,$10,$01,$50,$10,$83
    db $18,$84,$14,$81,$10,$81,$14,$81
    db $18,$00,$50,$83,$10,$83,$50,$81
    db $10,$81,$18,$81,$10,$01,$50,$10
    db $83,$18,$84,$14,$81,$10,$81,$14
    db $81,$18,$00,$50,$83,$10,$81,$50
    db $03,$10,$50,$10,$90,$82,$18,$01
    db $10,$50,$82,$10,$82,$18,$83,$14
    db $81,$10,$01,$14,$10,$81,$18,$00
    db $50,$81,$10,$81,$90,$81,$D0,$81
    db $50,$81,$10,$82,$18,$85,$10,$81
    db $18,$00,$50,$82,$14,$81,$10,$01
    db $14,$10,$81,$18,$81,$50,$82,$10
    db $82,$50,$82,$10,$82,$18,$00,$10
    db $81,$50,$01,$10,$D0,$82,$10,$00
    db $50,$82,$14,$81,$10,$02,$14,$50
    db $90,$81,$10,$81,$50,$81,$10,$81
    db $50,$81,$10,$85,$18,$82,$50,$01
    db $10,$50,$81,$10,$00,$50,$82,$14
    db $81,$10,$02,$14,$54,$10,$81,$18
    db $01,$D0,$50,$81,$10,$81,$50,$01
    db $10,$90,$86,$18,$81,$50,$04,$10
    db $50,$10,$D0,$10,$82,$14,$81,$10
    db $02,$14,$54,$10,$81,$18,$81,$50
    db $81,$10,$81,$50,$81,$10,$85,$18
    db $82,$10,$00,$90,$82,$D0,$83,$14
    db $81,$10,$01,$D4,$54,$83,$10,$00
    db $50,$81,$10,$01,$50,$10,$87,$18
    db $83,$10,$82,$50,$83,$14,$81,$10
    db $81,$54,$82,$10,$00,$50,$81,$10
    db $02,$50,$90,$10,$81,$18,$00,$10
    db $83,$18,$81,$10,$07,$18,$10,$50
    db $90,$10,$50,$14,$94,$81,$14,$81
    db $10,$08,$14,$54,$10,$50,$10,$90
    db $10,$50,$90,$81,$10,$84,$50,$81
    db $18,$07,$10,$50,$10,$50,$90,$10
    db $18,$50,$83,$14,$81,$10,$81,$14
    db $81,$10,$04,$90,$50,$10,$50,$90
    db $85,$10,$00,$50,$81,$18,$01,$90
    db $D0,$81,$90,$03,$10,$18,$10,$50
    db $83,$14,$81,$D0,$81,$14,$83,$90
    db $01,$50,$90,$81,$18,$00,$50,$84
    db $10,$81,$18,$01,$10,$50,$81,$10
    db $81,$90,$81,$D0,$83,$14,$81,$50
    db $81,$14,$00,$54,$81,$14,$81,$10
    db $00,$50,$81,$18,$00,$50,$82,$10
    db $01,$50,$10,$81,$18,$03,$10,$50
    db $18,$50,$87,$14,$81,$50,$81,$14
    db $00,$54,$81,$14,$81,$10,$05,$50
    db $10,$50,$90,$D0,$90,$82,$D0,$05
    db $10,$50,$10,$50,$10,$50,$87,$14
    db $81,$50,$02,$14,$D4,$54,$81,$14
    db $02,$10,$90,$D0,$81,$90,$85,$10
    db $81,$D0,$03,$90,$D0,$10,$50,$83
    db $14,$00,$94,$82,$14,$81,$50,$00
    db $14,$82,$54,$01,$14,$50,$8E,$90
    db $00,$10,$87,$14,$81,$50,$82,$14
    db $01,$54,$14,$81,$50,$8E,$10,$87
    db $14,$81,$50,$84,$14,$81,$50,$8E
    db $10,$87,$14,$81,$50,$00,$10,$81
    db $50,$86,$10,$00,$50,$88,$10,$00
    db $50,$83,$10,$00,$50,$81,$10,$81
    db $50,$8B,$10,$00,$50,$83,$10,$00
    db $D0,$86,$10,$00,$50,$82,$10,$82
    db $50,$84,$10,$01,$50,$90,$83,$10
    db $04,$D0,$10,$50,$10,$50,$87,$10
    db $83,$50,$81,$10,$81,$50,$84,$10
    db $00,$50,$83,$90,$81,$D0,$01,$10
    db $50,$84,$10,$00,$50,$85,$10,$81
    db $50,$81,$10,$81,$50,$82,$10,$01
    db $D0,$10,$81,$50,$82,$10,$00,$50
    db $81,$10,$00,$50,$83,$10,$01,$90
    db $D0,$83,$90,$00,$D0,$81,$10,$84
    db $50,$83,$10,$82,$50,$82,$10,$00
    db $50,$81,$10,$00,$50,$81,$18,$88
    db $10,$02,$D0,$90,$10,$83,$50,$84
    db $10,$82,$50,$85,$10,$81,$18,$86
    db $90,$83,$10,$01,$50,$10,$82,$50
    db $86,$10,$00,$50,$82,$10,$00,$D0
    db $81,$10,$02,$18,$D8,$50,$84,$10
    db $82,$90,$81,$10,$01,$50,$10,$82
    db $50,$85,$10,$00,$D0,$82,$90,$81
    db $D0,$81,$10,$81,$D8,$00,$50,$86
    db $10,$82,$90,$02,$D0,$10,$50,$86
    db $10,$00,$D0,$87,$10,$02,$58,$14
    db $50,$84,$10,$02,$50,$10,$50,$81
    db $10,$00,$50,$87,$10,$81,$D0,$85
    db $10,$03,$50,$D8,$58,$14,$81,$54
    db $88,$10,$00,$50,$8B,$10,$00,$50
    db $96,$10,$81,$14,$85,$10,$81,$50
    db $95,$10,$81,$14,$01,$10,$50,$84
    db $10,$00,$50,$95,$10,$81,$14,$01
    db $90,$D0,$81,$90,$82,$10,$00,$50
    db $91,$10,$81,$50,$81,$10,$81,$14
    db $01,$10,$50,$81,$10,$83,$D0,$92
    db $10,$00,$50,$81,$10,$81,$14,$01
    db $10,$50,$81,$10,$00,$D0,$81,$50
    db $00,$10,$8E,$18,$86,$10,$81,$14
    db $82,$10,$81,$D0,$81,$50,$00,$10
    db $8E,$18,$01,$50,$90,$84,$10,$81
    db $14,$81,$10,$81,$D0,$81,$10,$01
    db $50,$10,$8E,$18,$00,$50,$82,$90
    db $82,$10,$81,$14,$81,$10,$81,$50
    db $81,$10,$01,$50,$10,$86,$18,$00
    db $58,$84,$18,$01,$D8,$98,$82,$50
    db $00,$90,$82,$D0,$81,$14,$81,$10
    db $81,$50,$81,$10,$01,$50,$10,$86
    db $18,$00,$58,$83,$18,$81,$D8,$87
    db $50,$81,$14,$81,$10,$81,$50,$81
    db $10,$03,$50,$10,$18,$58,$84,$18
    db $00,$58,$82,$18,$81,$58,$81,$14
    db $86,$50,$81,$14,$82,$10,$00,$50
    db $81,$10,$03,$50,$10,$98,$D8,$83
    db $98,$85,$18,$01,$58,$14,$81,$54
    db $85,$50,$81,$14,$81,$10,$01,$D0
    db $10,$81,$50,$82,$18,$00,$58,$83
    db $18,$01,$98,$D8,$81,$18,$01,$98
    db $D8,$81,$58,$81,$18,$81,$58,$83
    db $50,$81,$14,$82,$D0,$00,$10,$84
    db $18,$00,$58,$8A,$18,$00,$58,$83
    db $18,$00,$58,$82,$50,$81,$14,$82
    db $50,$00,$10,$84,$18,$00,$58,$84
    db $18,$00,$58,$82,$18,$00,$58,$82
    db $18,$00,$58,$85,$18,$81,$14,$03
    db $50,$10,$50,$10,$81,$98,$81,$18
    db $01,$98,$D8,$83,$98,$81,$18,$82
    db $98,$00,$D8,$82,$98,$00,$D8,$81
    db $98,$00,$D8,$82,$18,$81,$14,$04
    db $50,$10,$50,$10,$50,$81,$98,$86
    db $18,$01,$98,$D8,$8A,$18,$81,$D8
    db $00,$18,$81,$14,$82,$50,$02,$10
    db $14,$54,$82,$98,$01,$10,$50,$86
    db $18,$01,$10,$50,$81,$18,$04,$10
    db $50,$18,$10,$50,$82,$18,$81,$14
    db $04,$50,$10,$50,$10,$18,$81,$54
    db $00,$50,$81,$10,$81,$50,$81,$18
    db $84,$10,$00,$50,$82,$10,$00,$50
    db $81,$10,$00,$50,$82,$18,$81,$14
    db $82,$50,$03,$10,$94,$18,$54,$83
    db $10,$00,$50,$8D,$10,$00,$50,$82
    db $10,$81,$14,$02,$50,$10,$50,$81
    db $14,$00,$18,$97,$10,$81,$14,$9D
    db $10,$81,$50,$9D,$10,$81,$50,$9D
    db $10,$81,$50,$9D,$10,$81,$50,$9D
    db $10,$81,$50,$82,$10,$00,$14,$81
    db $10,$81,$14,$81,$10,$82,$14,$81
    db $10,$00,$14,$81,$10,$00,$14,$81
    db $10,$00,$14,$81,$10,$00,$14,$88
    db $10,$08,$14,$10,$14,$10,$14,$10
    db $14,$10,$14,$82,$10,$0A,$14,$10
    db $14,$10,$14,$10,$14,$10,$14,$10
    db $14,$88,$10,$00,$14,$82,$10,$04
    db $14,$10,$14,$10,$14,$82,$10,$00
    db $14,$82,$10,$06,$14,$10,$14,$10
    db $14,$10,$14,$89,$10,$00,$14,$81
    db $10,$03,$14,$10,$14,$10,$82,$14
    db $01,$10,$14,$82,$10,$01,$14,$10
    db $82,$14,$01,$10,$14,$8A,$10,$01
    db $14,$10,$81,$14,$81,$10,$00,$14
    db $82,$10,$00,$14,$82,$10,$06,$14
    db $10,$14,$10,$14,$10,$14,$88,$10
    db $04,$14,$10,$14,$10,$14,$82,$10
    db $00,$14,$82,$10,$0A,$14,$10,$14
    db $10,$14,$10,$14,$10,$14,$10,$14
    db $86,$10,$81,$90,$87,$10,$82,$18
    db $81,$58,$00,$54,$83,$14,$81,$54
    db $00,$50,$81,$10,$00,$50,$88,$10
    db $00,$50,$83,$10,$85,$18,$00,$58
    db $85,$18,$81,$54,$02,$10,$90,$D0
    db $87,$10,$81,$50,$8A,$18,$00,$94
    db $85,$18,$82,$10,$00,$50,$87,$10
    db $81,$50,$88,$18,$00,$58,$81,$14
    db $85,$18,$82,$10,$00,$50,$88,$10
    db $81,$50,$85,$18,$03,$58,$18,$58
    db $14,$86,$18,$82,$10,$00,$50,$89
    db $10,$81,$50,$83,$18,$03,$98,$D8
    db $98,$58,$87,$18,$83,$10,$00,$50
    db $89,$10,$03,$50,$18,$10,$50,$81
    db $18,$01,$58,$18,$81,$58,$86,$18
    db $01,$10,$90,$81,$10,$00,$D0,$89
    db $10,$00,$50,$81,$10,$81,$50,$05
    db $18,$58,$18,$10,$50,$58,$81,$18
    db $85,$10,$01,$50,$90,$8E,$10,$00
    db $50,$83,$10,$00,$50,$87,$10,$01
    db $50,$90,$9B,$10,$82,$90,$87,$10
    db $81,$1C,$00,$5C,$81,$1C,$81,$5C
    db $81,$1C,$81,$5C,$00,$10,$81,$1C
    db $81,$5C,$01,$10,$50,$81,$1C,$81
    db $5C,$81,$1C,$81,$5C,$01,$10,$50
    db $81,$10,$81,$1C,$82,$10,$81,$1C
    db $81,$5C,$81,$1C,$81,$5C,$00,$10
    db $81,$1C,$81,$5C,$01,$10,$50,$81
    db $1C,$81,$5C,$81,$1C,$81,$5C,$01
    db $10,$50,$81,$10,$83,$1C,$81,$5C
    db $00,$1C,$81,$5C,$81,$1C,$81,$5C
    db $00,$10,$81,$1C,$81,$5C,$01,$10
    db $50,$81,$1C,$81,$5C,$81,$1C,$00
    db $5C,$81,$1C,$81,$5C,$00,$10,$83
    db $1C,$81,$5C,$84,$10,$00,$50,$86
    db $10,$00,$50,$81,$1C,$81,$5C,$82
    db $10,$81,$1C,$81,$5C,$00,$10,$83
    db $1C,$81,$5C,$81,$1C,$81,$5C,$01
    db $10,$50,$82,$10,$06,$50,$10,$50
    db $10,$50,$10,$50,$81,$10,$81,$1C
    db $81,$5C,$03,$1C,$5C,$1C,$10,$83
    db $1C,$81,$5C,$81,$1C,$81,$5C,$84
    db $10,$08,$50,$10,$50,$90,$D0,$10
    db $50,$10,$50,$81,$1C,$81,$5C,$83
    db $10,$83,$1C,$81,$5C,$81,$1C,$81
    db $5C,$82,$10,$02,$50,$10,$50,$86
    db $10,$00,$50,$81,$1C,$81,$5C,$81
    db $1C,$01,$5C,$10,$83,$1C,$81,$5C
    db $81,$1C,$81,$5C,$82,$10,$02,$50
    db $10,$50,$81,$1C,$81,$5C,$03,$10
    db $50,$10,$50,$81,$1C,$81,$5C,$81
    db $1C,$01,$5C,$10,$83,$1C,$81,$5C
    db $81,$1C,$81,$5C,$82,$10,$02,$50
    db $10,$50,$81,$1C,$81,$5C,$03,$10
    db $50,$10,$50,$81,$1C,$81,$5C,$81
    db $1C,$01,$5C,$10,$83,$1C,$81,$5C
    db $81,$1C,$81,$5C,$82,$10,$02,$50
    db $10,$50,$81,$1C,$81,$5C,$83,$10
    db $81,$1C,$81,$5C,$83,$10,$83,$1C
    db $00,$5C,$81,$1C,$81,$5C,$81,$10
    db $00,$50,$82,$10,$02,$50,$10,$50
    db $81,$10,$09,$50,$10,$14,$54,$10
    db $50,$10,$50,$10,$50,$81,$10,$81
    db $1C,$82,$10,$81,$1C,$81,$5C,$81
    db $10,$00,$50,$82,$10,$02,$50,$10
    db $50,$81,$10,$09,$50,$10,$94,$D4
    db $10,$50,$10,$50,$10,$50,$81,$10
    db $81,$18,$81,$1C,$81,$5C,$00,$1C
    db $81,$5C,$83,$10,$00,$50,$83,$10
    db $00,$50,$81,$10,$00,$50,$82,$10
    db $00,$50,$81,$1C,$81,$5C,$83,$10
    db $81,$1C,$81,$5C,$01,$10,$50,$84
    db $10,$00,$50,$81,$10,$02,$50,$10
    db $50,$81,$10,$00,$50,$82,$10,$00
    db $50,$81,$1C,$81,$5C,$83,$10,$81
    db $1C,$81,$5C,$05,$10,$50,$10,$50
    db $10,$50,$83,$10,$00,$50,$81,$10
    db $00,$50,$81,$10,$00,$50,$81,$1C
    db $81,$5C,$00,$1C,$81,$5C,$81,$10
    db $81,$18,$01,$10,$50,$81,$1C,$81
    db $5C,$03,$10,$50,$10,$50,$81,$1C
    db $81,$5C,$82,$10,$00,$50,$81,$10
    db $00,$50,$81,$1C,$81,$5C,$81,$10
    db $00,$50,$84,$10,$00,$50,$81,$1C
    db $81,$5C,$03,$10,$50,$10,$50,$81
    db $1C,$81,$5C,$03,$10,$50,$10,$50
    db $81,$1C,$81,$5C,$00,$1C,$81,$5C
    db $81,$10,$00,$50,$85,$10,$81,$1C
    db $81,$5C,$03,$10,$50,$10,$50,$81
    db $1C,$81,$5C,$03,$10,$50,$10,$50
    db $81,$1C,$81,$5C,$01,$10,$50,$81
    db $1C,$81,$5C,$85,$10,$00,$50,$82
    db $10,$02,$50,$10,$50,$81,$10,$00
    db $50,$81,$1C,$81,$5C,$81,$10,$81
    db $1C,$81,$5C,$01,$10,$50,$81,$1C
    db $81,$5C,$81,$10,$81,$18,$81,$10
    db $00,$50,$82,$10,$02,$50,$10,$50
    db $81,$10,$00,$50,$81,$1C,$81,$5C
    db $01,$10,$50,$81,$1C,$81,$5C,$01
    db $10,$50,$81,$1C,$81,$5C,$81,$10
    db $81,$18,$00,$10,$81,$1C,$81,$5C
    db $81,$10,$81,$1C,$81,$5C,$00,$10
    db $81,$1C,$81,$5C,$01,$10,$50,$81
    db $1C,$81,$5C,$01,$10,$50,$87,$10
    db $83,$14,$00,$50,$83,$10,$82,$50
    db $81,$10,$8F,$14,$84,$10,$00,$14
    db $81,$10,$00,$14,$82,$10,$82,$14
    db $81,$10,$00,$14,$81,$10,$05,$14
    db $10,$14,$10,$14,$10,$82,$14,$82
    db $10,$81,$90,$A5,$10,$01,$54,$14
    db $83,$10,$01,$54,$14,$83,$10,$01
    db $54,$14,$83,$10,$01,$54,$14,$8B
    db $10,$01,$D4,$94,$83,$10,$01,$D4
    db $94,$83,$10,$01,$D4,$94,$83,$10
    db $01,$D4,$94,$C8,$10,$82,$50,$01
    db $10,$50,$83,$10,$01,$54,$14,$83
    db $10,$01,$54,$14,$83,$10,$01,$54
    db $14,$87,$10,$00,$90,$82,$D0,$01
    db $90,$D0,$83,$10,$01,$D4,$94,$83
    db $10,$01,$D4,$94,$83,$10,$01,$D4
    db $94,$C5,$10,$83,$1C,$00,$14,$88
    db $1C,$01,$18,$58,$81,$1C,$01,$54
    db $14,$89,$1C,$81,$10,$81,$1C,$81
    db $14,$86,$1C,$08,$14,$1C,$18,$10
    db $50,$58,$1C,$D4,$94,$82,$1C,$00
    db $14,$85,$1C,$81,$10,$00,$1C,$82
    db $14,$82,$1C,$01,$54,$14,$82,$1C
    db $00,$18,$81,$10,$81,$50,$00,$58
    db $8B,$1C,$81,$10,$00,$1C,$82,$14
    db $82,$1C,$01,$D4,$94,$82,$1C,$81
    db $10,$00,$90,$81,$10,$03,$50,$58
    db $1C,$14,$83,$1C,$01,$54,$14,$82
    db $1C,$81,$10,$8A,$1C,$00,$18,$82
    db $10,$00,$D0,$81,$10,$00,$50,$85
    db $1C,$01,$D4,$94,$82,$1C,$81,$10
    db $82,$1C,$87,$18,$84,$10,$02,$D0
    db $10,$50,$86,$18,$00,$58,$82,$1C
    db $81,$10,$02,$54,$14,$1C,$81,$10
    db $00,$50,$84,$10,$00,$50,$84,$10
    db $02,$D0,$10,$50,$84,$10,$81,$50
    db $82,$1C,$81,$10,$05,$D4,$94,$1C
    db $10,$90,$D0,$84,$90,$00,$D0,$85
    db $10,$01,$90,$D0,$84,$10,$01,$D0
    db $50,$82,$1C,$81,$10,$82,$1C,$00
    db $50,$87,$10,$00,$18,$83,$10,$00
    db $18,$84,$10,$02,$50,$90,$D0,$83
    db $1C,$81,$10,$04,$1C,$14,$1C,$50
    db $90,$85,$10,$00,$18,$85,$10,$00
    db $18,$82,$10,$03,$50,$90,$D0,$DC
    db $83,$1C,$81,$10,$82,$1C,$02,$50
    db $10,$50,$82,$10,$02,$50,$10,$18
    db $85,$10,$00,$18,$82,$10,$01,$90
    db $D0,$85,$1C,$81,$10,$82,$18,$00
    db $50,$81,$10,$00,$90,$81,$10,$00
    db $D0,$81,$10,$00,$18,$83,$10,$00
    db $18,$81,$10,$06,$90,$D0,$10,$5C
    db $1C,$5C,$1C,$82,$18,$84,$10,$02
    db $50,$10,$50,$88,$10,$00,$50,$83
    db $10,$00,$50,$81,$10,$00,$5C,$82
    db $1C,$82,$18,$83,$10,$06,$18,$50
    db $10,$D0,$10,$50,$90,$84,$10,$00
    db $90,$84,$10,$00,$50,$81,$10,$01
    db $50,$9C,$81,$1C,$84,$10,$81,$18
    db $01,$10,$50,$81,$10,$01,$50,$90
    db $85,$10,$01,$D0,$90,$81,$D0,$85
    db $10,$02,$50,$5C,$1C,$82,$18,$82
    db $10,$81,$18,$03,$D0,$10,$50,$90
    db $85,$10,$01,$D0,$1C,$82,$90,$81
    db $D0,$85,$10,$00,$9C,$8F,$10,$05
    db $D0,$9C,$DC,$1C,$50,$10,$81,$90
    db $00,$10,$81,$D0,$82,$10,$02,$50
    db $10,$50,$87,$10,$01,$90,$D0,$81
    db $10,$00,$D0,$81,$9C,$83,$1C,$00
    db $50,$81,$10,$01,$50,$D0,$81,$10
    db $81,$D0,$03,$10,$D0,$10,$50,$83
    db $10,$00,$18,$84,$10,$02,$D0,$9C
    db $DC,$82,$1C,$00,$5C,$81,$1C,$00
    db $50,$82,$10,$83,$D0,$00,$90,$82
    db $10,$00,$1C,$83,$10,$81,$18,$81
    db $90,$81,$9C,$02,$DC,$1C,$5C,$82
    db $1C,$00,$5C,$81,$1C,$82,$10,$00
    db $50,$83,$10,$00,$50,$81,$90,$01
    db $DC,$1C,$85,$10,$02,$50,$10,$5C
    db $86,$1C,$00,$5C,$81,$1C,$00,$50
    db $86,$10,$00,$50,$81,$10,$81,$1C
    db $89,$10,$00,$50,$96,$10,$81,$14
DATA_04D678:
    db $00,$C0,$C0,$C0,$30,$C0,$C0,$00
    db $C0,$20,$30,$C0,$C0,$C0,$C0,$D0
    db $40,$40,$40,$D0,$40,$80,$80,$00
    db $00,$00,$00,$40,$00,$80,$20,$80
    db $40,$40,$80,$60,$90,$00,$00,$C0
    db $00,$00,$00,$C0,$40,$20,$40,$C0
    db $E0,$C0,$00,$C0,$00,$00,$C0,$20
    db $80,$80,$80,$80,$30,$40,$E0,$00
    db $40,$E0,$E0,$D0,$70,$FF,$40,$90
    db $55,$80,$80,$80,$80,$00,$C0,$C0
    db $C0,$C0,$40,$00,$80,$A0,$30,$AA
    db $60,$D0,$80,$00,$55,$55,$00,$00
    db $AA,$55,$FF,$FF,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00

CODE_04D6E9:
    REP #$30                                  ; AXY->16
    STZ.B Layer1YPos
    LDA.W #$FFFF
    STA.B Layer1PrevTileUp
    STA.B Layer1PrevTileDown
    LDA.W #$0202
    STA.B Layer1ScrollDir
    LDA.W PlayerTurnOW
    LSR A
    LSR A
    AND.W #$00FF
    TAX
    LDA.W OWPlayerSubmap,X
    AND.W #$000F
    BEQ CODE_04D714
    LDA.W #$0020
    STA.B Layer1TileDown
    LDA.W #$0200
    STA.B Layer1YPos
CODE_04D714:
    JSL CODE_05881A
    JSL UploadOneMap16Strip
    REP #$30                                  ; AXY->16
    INC.B Layer1TileDown
    LDA.B Layer1YPos
    CLC
    ADC.W #$0010
    STA.B Layer1YPos
    AND.W #$01FF
    BNE CODE_04D714
    LDA.B Layer2YPos
    STA.B Layer1YPos
    STZ.B Layer1TileDown
    STZ.W LevelModeSetting
    STZ.B ScreenMode
    LDA.W #$FFFF
    STA.B Layer1PrevTileUp
    STA.B Layer1PrevTileDown
    SEP #$30                                  ; AXY->8
    LDA.B #$80
    STA.W HW_VMAINC
    STZ.W HW_VMADD
    LDA.B #$30
    STA.W HW_VMADD+1
    LDX.B #$06
  - LDA.L DATA_04DAB3,X
    STA.W HW_DMAPARAM+$10,X
    DEX
    BPL -
    LDA.W PlayerTurnOW
    LSR A
    LSR A
    TAX
    LDA.W OWPlayerSubmap,X
    BEQ +
    LDA.B #$60
    STA.W HW_DMAADDR+$11
  + LDA.B #$02
    STA.W HW_MDMAEN
    RTL

CODE_04D770:
    STA.L Map16TilesHigh,X
    STA.L Map16TilesHigh+$1B0,X
    STA.L Map16TilesHigh+$360,X
    STA.L Map16TilesHigh+$510,X
    STA.L Map16TilesHigh+$6C0,X
    STA.L Map16TilesHigh+$870,X
    STA.L Map16TilesHigh+$A20,X
    STA.L Map16TilesHigh+$BD0,X
    STA.L Map16TilesHigh+$D80,X
    STA.L Map16TilesHigh+$F30,X
    STA.L Map16TilesHigh+$10E0,X
    STA.L Map16TilesHigh+$1290,X
    STA.L Map16TilesHigh+$1440,X
    STA.L Map16TilesHigh+$15F0,X
    STA.L Map16TilesHigh+$17A0,X
    STA.L Map16TilesHigh+$1950,X
    STA.L Map16TilesHigh+$1B00,X
    STA.L Map16TilesHigh+$1CB0,X
    STA.L Map16TilesHigh+$1E60,X
    STA.L Map16TilesHigh+$2010,X
    STA.L Map16TilesHigh+$21C0,X
    STA.L Map16TilesHigh+$2370,X
    STA.L Map16TilesHigh+$2520,X
    STA.L Map16TilesHigh+$26D0,X
    STA.L Map16TilesHigh+$2880,X
    STA.L Map16TilesHigh+$2A30,X
    STA.L Map16TilesHigh+$2BE0,X
    STA.L Map16TilesHigh+$2D90,X
    STA.L Map16TilesHigh+$2F40,X
    STA.L Map16TilesHigh+$30F0,X
    STA.L Map16TilesHigh+$32A0,X
    STA.L Map16TilesHigh+$3450,X
    INX
    RTS

CODE_04D7F2:
    REP #$30                                  ; AXY->16
    LDA.W #$0000
    SEP #$20                                  ; A->8
    LDA.B #OWLayer1Translevel
    STA.B _D
    LDA.B #OWLayer1Translevel>>8
    STA.B _E
    LDA.B #OWLayer1Translevel>>16
    STA.B _F
    LDA.B #OWLayer2Directions
    STA.B _A
    LDA.B #OWLayer2Directions>>8
    STA.B _B
    LDA.B #OWLayer2Directions>>16
    STA.B _C
    LDA.B #Map16TilesLow
    STA.B _4
    LDA.B #Map16TilesLow>>8
    STA.B _5
    LDA.B #Map16TilesLow>>16
    STA.B _6
    LDY.W #$0001
    STY.B _0
    LDY.W #$07FF
    LDA.B #$00
  - STA.B [_A],Y
    STA.B [_D],Y
    DEY
    BPL -
    LDY.W #$0000
    TYX
CODE_04D832:
    LDA.B [_4],Y
    CMP.B #$56
    BCC +
    CMP.B #$81
    BCS +
    LDA.B _0
    STA.B [_D],Y
    TAX
    LDA.L DATA_04D678,X
    STA.B [_A],Y
    INC.B _0
  + INY
    CPY.W #$0800
    BNE CODE_04D832
    STZ.B _F
  - JSR CODE_04DA49
    INC.B _F
    LDA.B _F
    CMP.B #$6F
    BNE -
    RTS


DATA_04D85D:
    db $00,$00,$00,$00,$00,$00,$69,$04
    db $4B,$04,$29,$04,$09,$04,$D3,$00
    db $E5,$00,$A5,$00,$D1,$00,$85,$00
    db $A9,$00,$CB,$00,$BD,$00,$9D,$00
    db $A5,$00,$07,$02,$00,$00,$27,$02
    db $12,$05,$08,$06,$E3,$04,$C8,$04
    db $2A,$06,$EC,$04,$0C,$06,$1C,$06
    db $4A,$06,$00,$00,$E0,$04,$3E,$00
    db $30,$01,$34,$01,$36,$01,$3A,$01
    db $00,$00,$57,$01,$84,$01,$3A,$01
    db $00,$00,$00,$00,$AA,$06,$76,$06
    db $C8,$06,$AC,$06,$76,$06,$00,$00
    db $00,$00,$A4,$06,$AA,$06,$C4,$06
    db $00,$00,$04,$03,$00,$00,$00,$00
    db $79,$05,$77,$05,$59,$05,$74,$05
    db $00,$00,$54,$05,$00,$00,$34,$05
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$B3,$03,$00,$00
    db $00,$00,$00,$00,$DF,$02,$DC,$02
    db $00,$00,$7E,$02,$00,$00,$00,$00
    db $00,$00,$E0,$04,$E0,$04,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$34,$05,$34,$05
    db $00,$00,$00,$00,$87,$07,$00,$00
    db $F0,$01,$68,$03,$65,$03,$B5,$03
    db $00,$00,$36,$07,$39,$07,$3C,$07
    db $1C,$07,$19,$07,$16,$07,$13,$07
    db $11,$07,$00,$00,$00,$00,$00,$00
DATA_04D93D:
    db $00,$00,$00,$00,$00,$00,$21,$92
    db $21,$16,$20,$92,$20,$12,$23,$46
    db $23,$8A,$22,$8A,$23,$42,$22,$0A
    db $22,$92,$23,$16,$22,$DA,$22,$5A
    db $22,$8A,$28,$0E,$00,$00,$28,$8E
    db $24,$04,$28,$10,$23,$86,$23,$10
    db $28,$94,$23,$98,$28,$18,$28,$58
    db $29,$14,$00,$00,$23,$80,$20,$DC
    db $24,$C0,$24,$C8,$24,$CC,$24,$D4
    db $00,$00,$25,$4E,$26,$08,$24,$D4
    db $00,$00,$00,$00,$2A,$94,$29,$CC
    db $2B,$10,$2A,$98,$29,$CC,$00,$00
    db $00,$00,$2A,$88,$2A,$94,$2B,$08
    db $00,$00,$2C,$08,$00,$00,$00,$00
    db $25,$D2,$25,$CE,$25,$52,$25,$C8
    db $00,$00,$25,$48,$00,$00,$24,$C8
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$2E,$C6,$00,$00
    db $00,$00,$00,$00,$2B,$5E,$2B,$58
    db $00,$00,$29,$DC,$00,$00,$00,$00
    db $00,$00,$23,$80,$23,$80,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$24,$C8,$24,$C8
    db $00,$00,$00,$00,$2E,$0E,$00,$00
    db $27,$C0,$2D,$90,$2D,$8A,$2E,$CA
    db $00,$00,$2C,$CC,$2C,$D2,$2C,$D8
    db $2C,$58,$2C,$52,$2C,$4C,$2C,$46
    db $2C,$42,$00,$00,$00,$00,$00,$00
DATA_04DA1D:
    db $6E,$6F,$70,$71,$72,$73,$74,$75
    db $59,$53,$52,$83,$4D,$57,$5A,$76
    db $78,$7A,$7B,$7D,$7F,$54

DATA_04DA33:
    db $66,$67,$68,$69,$6A,$6B,$6C,$6D
    db $58,$43,$44,$45,$25,$5E,$5F,$77
    db $79,$63,$7C,$7E,$80,$23

CODE_04DA49:
    REP #$30                                  ; AXY->16
    LDA.B _F
    AND.W #$00F8
    LSR A
    LSR A
    LSR A
    TAY
    LDA.B _F
    AND.W #$0007
    TAX
    SEP #$20                                  ; A->8
    LDA.W OWEventsActivated,Y
    AND.L DATA_04E44B,X
    BEQ Return04DAAC
    REP #$20                                  ; A->16
    LDA.W #$C800
    STA.B _4
    LDA.B _F
    AND.W #$00FF
    ASL A
    TAX
    LDA.L DATA_04D85D,X
    TAY
    LDX.W #$0015
    SEP #$20                                  ; A->8
    LDA.B #$7E
    STA.B _6
    LDA.B [_4],Y
CODE_04DA83:
    CMP.L DATA_04DA1D,X
    BEQ CODE_04DA8F
    DEX
    BPL CODE_04DA83
    JMP CODE_04DA9D

CODE_04DA8F:
    LDA.L DATA_04DA33,X
    STA.B [_4],Y
    CPX.W #$0015
    BNE CODE_04DA9D
    INY
    STA.B [_4],Y
CODE_04DA9D:
    LDA.B _F
    JSR CODE_04E677
    SEP #$10                                  ; XY->8
    STZ.W OverworldEventProcess
    LDA.B _F
    JSR CODE_04E9F1
Return04DAAC:
    RTS

DecompressOverworldL2:
    PHP
    JSR CODE_04DC6A
    PLP
    RTL


DATA_04DAB3:
    db $01,$18
    dl OWLayer2Tilemap
    dw $2000

CODE_04DABA:
    SEP #$20                                  ; A->8
    REP #$10                                  ; XY->16
    LDA.B [_0],Y
    STA.B _3
    AND.B #$80
    BNE CODE_04DAD6
  - INY
    LDA.B [_0],Y
    STA.L OWLayer2Tilemap,X
    INX
    INX
    DEC.B _3
    BPL -
    JMP CODE_04DAE9

CODE_04DAD6:
    LDA.B _3
    AND.B #$7F
    STA.B _3
    INY
    LDA.B [_0],Y
  - STA.L OWLayer2Tilemap,X
    INX
    INX
    DEC.B _3
    BPL -
CODE_04DAE9:
    INY
    CPX.B _E
    BCC CODE_04DABA
    RTS

CODE_04DAEF:
    SEP #$30                                  ; AXY->8
    LDA.W OWSubmapSwapProcess
    JSL ExecutePtr

    dw CODE_04DB18
    dw CODE_04DCB6
    dw CODE_04DCB6
    dw CODE_04DCB6
    dw CODE_04DCB6
    dw CODE_04DB9D
    dw CODE_04DB18
    dw CODE_04DBCF

DATA_04DB08:
    db $00,$F9,$00,$07

DATA_04DB0C:
    db $00,$00,$00,$70

DATA_04DB10:
    db $C0,$FA,$40,$05

DATA_04DB14:
    db $00,$00,$00,$54

CODE_04DB18:
    REP #$20                                  ; A->16
    LDX.W OWTransitionFlag
    LDA.W OWTransitionXCalc
    CLC
    ADC.W DATA_04DB08,X
    STA.W OWTransitionXCalc
    SEC
    SBC.W DATA_04DB0C,X
    EOR.W DATA_04DB08,X
    BPL CODE_04DB43
    LDA.W OWTransitionYCalc
    CLC
    ADC.W DATA_04DB10,X
    STA.W OWTransitionYCalc
    SEC
    SBC.W DATA_04DB14,X
    EOR.W DATA_04DB10,X
    BMI +
CODE_04DB43:
    %LorW_X(LDA,DATA_04DB0C)
    STA.W OWTransitionXCalc
    %LorW_X(LDA,DATA_04DB14)
    STA.W OWTransitionYCalc
    INC.W OWSubmapSwapProcess
    TXA
    EOR.W #$0002
    TAX
    STX.W OWTransitionFlag
    BEQ +
    JSR CODE_049A93
  + SEP #$20                                  ; A->8
    LDA.W OWTransitionYCalc+1
    ASL A
    STA.B _0
    LDA.W OWTransitionXCalc+1
    CLC
    ADC.B #$80
    XBA
    LDA.B #$80
    SEC
    SBC.W OWTransitionXCalc+1
    REP #$20                                  ; A->16
    LDX.B #$00
    LDY.B #$A8
CODE_04DB7A:
    CPX.B _0
    BCC +
    LDA.W #$00FF
  + STA.W WindowTable+$4E,Y
    STA.W WindowTable+$F8,X
    INX
    INX
    DEY
    DEY
    BNE CODE_04DB7A
    SEP #$20                                  ; A->8
    LDA.B #$33
    STA.B Layer12Window
    LDA.B #$33
CODE_04DB95:
    STA.B OBJCWWindow
    LDA.B #$80
    STA.W HDMAEnable
    RTS

CODE_04DB9D:
    LDA.W PlayerTurnOW
    LSR A
    LSR A
    TAX
    LDA.W OWPlayerSubmap,X
    TAX
    LDA.L DATA_04DC02,X
    STA.W ObjectTileset
    JSL CODE_00A594
    LDA.B #$FE
    STA.W MainPalette
    LDA.B #$01
    STA.W MainPalette+1
    STZ.W MainPalette+$100
    LDA.B #!PaletteTableUse_Main
    STA.W PaletteIndexTable
    INC.W OWSubmapSwapProcess
    RTS


OverworldMusic2:
    db !BGM_DONUTPLAINS
    db !BGM_YOSHISISLAND
    db !BGM_VANILLADOME
    db !BGM_FORESTOFILLUSION
    db !BGM_VALLEYOFBOWSER
    db !BGM_SPECIALWORLD
    db !BGM_STARWORLD

CODE_04DBCF:
    STZ.W OWSubmapSwapProcess
    LDA.B #$04
    STA.W OverworldProcess
    LDA.W PlayerTurnOW
    LSR A
    LSR A
    TAY
    LDA.W IsTwoPlayerGame
    BEQ CODE_04DBF3
    LDA.W SwapOverworldMusic
    BNE CODE_04DBF3
    TYA
    EOR.B #$01
    TAX
    LDA.W OWPlayerSubmap,Y
    CMP.W OWPlayerSubmap,X
    BEQ +
CODE_04DBF3:
    LDA.W OWPlayerSubmap,Y
    TAX
    LDA.L OverworldMusic2,X
    STA.W SPCIO2                              ; / Change music
    STZ.W SwapOverworldMusic
  + RTS


DATA_04DC02:
    db $11,$12,$13,$14,$15,$16,$17

CODE_04DC09:
    SEP #$30                                  ; AXY->8
    LDA.W PlayerTurnOW
    LSR A
    LSR A
    TAX
    LDA.W OWPlayerSubmap,X
    TAX
    LDA.L DATA_04DC02,X
    STA.W ObjectTileset
    LDA.B #$11
    STA.W SpriteTileset
    LDA.B #$07
    STA.W LevelModeSetting
    LDA.B #!ScrMode_Layer1Vert|!ScrMode_Layer2Vert
    STA.B ScreenMode
    REP #$10                                  ; XY->16
    LDX.W #$0000
    TXA
  - JSR CODE_04D770
    CPX.W #$01B0
    BNE -
    REP #$30                                  ; AXY->16
    LDA.W #OWL1CharData
    STA.B _0
    LDX.W #$0000
  - LDA.B _0
    STA.W Map16Pointers,X
    LDA.B _0
    CLC
    ADC.W #$0008
    STA.B _0
    INX
    INX
    CPX.W #$0400
    BNE -
    PHB
    LDA.W #$07FF
    LDX.W #OWL1TileData
    LDY.W #Map16TilesLow
    MVN $7E,$0C
    PLB
    JSR CODE_04D7F2
    SEP #$30                                  ; AXY->8
    RTL

CODE_04DC6A:
    SEP #$30                                  ; AXY->8
    JSR CODE_04DD40
    REP #$20                                  ; A->16
    LDA.W #OWTileNumbers
    STA.B _0
    SEP #$30                                  ; AXY->8
    LDA.B #OWTileNumbers>>16
    STA.B _2
    REP #$10                                  ; XY->16
    LDY.W #$4000
    STY.B _E
    LDY.W #$0000
    TYX
    JSR CODE_04DABA
    REP #$20                                  ; A->16
    LDA.W #OWTilemap
    STA.B _0
    SEP #$20                                  ; A->8
    LDX.W #$0001
    LDY.W #$0000
    JSR CODE_04DABA
    SEP #$30                                  ; AXY->8
    LDA.B #$00
    STA.B _F
  - JSR CODE_04E453
    INC.B _F
    LDA.B _F
    CMP.B #$6F
    BNE -
    RTS


    db $80,$40,$20,$10,$08,$04,$02,$01

CODE_04DCB6:
    PHP
    REP #$10                                  ; XY->16
    SEP #$20                                  ; A->8
    LDX.W #OWL1CharData
    STX.B Layer1DataPtr
    LDA.B #OWL1CharData>>16
    STA.B Layer1DataPtr+2
    LDX.W #$0000
    STX.B _0
    LDA.W OWSubmapSwapProcess
    DEC A
    STA.B _1
    REP #$20                                  ; A->16
    LDA.W PlayerTurnOW
    LSR A
    LSR A
    AND.W #$00FF
    TAX
    SEP #$20                                  ; A->8
    LDA.W OWPlayerSubmap,X
    BEQ CODE_04DCE8
    LDA.B _1
    CLC
    ADC.B #$04
    STA.B _1
CODE_04DCE8:
    LDX.B _0
    LDA.L Map16TilesLow,X
    STA.B _2
    REP #$20                                  ; A->16
    LDA.L Map16TilesHigh,X
    STA.B _3
    LDA.B _2
    ASL A
    ASL A
    ASL A
    TAY
    LDA.B _0
    AND.W #$00FF
    ASL A
    ASL A
    PHA
    AND.W #$003F
    STA.B _2
    PLA
    ASL A
    AND.W #$0F80
    ORA.B _2
    TAX
    LDA.B [Layer1DataPtr],Y
    STA.L OWLayer1VramBuffer,X
    INY
    INY
    LDA.B [Layer1DataPtr],Y
    STA.L OWLayer1VramBuffer+$40,X
    INY
    INY
    LDA.B [Layer1DataPtr],Y
    STA.L OWLayer1VramBuffer+2,X
    INY
    INY
    LDA.B [Layer1DataPtr],Y
    STA.L OWLayer1VramBuffer+$42,X
    SEP #$20                                  ; A->8
    INC.B _0
    LDA.B _0
    AND.B #$FF
    BNE CODE_04DCE8
    INC.W OWSubmapSwapProcess
    PLP
    RTS

CODE_04DD40:
    REP #$10                                  ; XY->16
    SEP #$20                                  ; A->8
    LDY.W #OWEventTileProp
    STY.B _2
    LDA.B #OWEventTileProp>>16
    STA.B _4
    LDX.W #$0000
    TXY
    JSR CODE_04DD57
    SEP #$30                                  ; AXY->8
    RTS

CODE_04DD57:
    SEP #$20                                  ; A->8
    LDA.B [_2],Y
    INY
    STA.B _5
    AND.B #$80
    BNE CODE_04DD71
  - LDA.B [_2],Y
    STA.L OWEventTilemap,X
    INY
    INX
    DEC.B _5
    BPL -
    JMP CODE_04DD83

CODE_04DD71:
    LDA.B _5
    AND.B #$7F
    STA.B _5
    LDA.B [_2],Y
  - STA.L OWEventTilemap,X
    INX
    DEC.B _5
    BPL -
    INY
CODE_04DD83:
    REP #$20                                  ; A->16
    LDA.B [_2],Y
    CMP.W #$FFFF
    BNE CODE_04DD57
    RTS


DATA_04DD8D:
    db $00,$09

DATA_04DD8F:
    db $CC,$23,$04,$09,$8C,$23,$08,$09
    db $4E,$23,$0C,$09,$0E,$23,$10,$09
    db $D0,$22,$14,$09,$90,$22,$8C,$01
    db $02,$22,$B0,$01,$02,$22,$D4,$01
    db $02,$22,$44,$0A,$C6,$21,$48,$0A
    db $44,$20,$4C,$0A,$86,$21,$48,$0A
    db $04,$20,$00,$09,$E4,$23,$38,$09
    db $A4,$23,$28,$09,$24,$23,$18,$09
    db $26,$23,$1C,$09,$28,$23,$20,$09
    db $EC,$22,$24,$09,$AC,$22,$0C,$0B
    db $2C,$22,$10,$0B,$EC,$21,$30,$09
    db $6C,$21,$34,$09,$68,$21,$38,$09
    db $E4,$20,$38,$09,$A4,$20,$3C,$09
    db $90,$10,$40,$09,$4C,$10,$44,$09
    db $0C,$10,$38,$09,$8C,$07,$38,$09
    db $0C,$07,$28,$09,$8C,$06,$48,$09
    db $14,$10,$4C,$09,$94,$07,$50,$09
    db $54,$07,$38,$09,$0C,$06,$04,$09
    db $8C,$05,$54,$09,$0E,$05,$E8,$09
    db $48,$06,$E8,$09,$C8,$06,$98,$09
    db $88,$06,$EC,$09,$12,$05,$F0,$09
    db $D2,$04,$F4,$09,$92,$04,$00,$00
    db $D8,$04,$24,$00,$98,$04,$48,$00
    db $D8,$03,$6C,$00,$56,$03,$90,$00
    db $56,$03,$B4,$00,$56,$03,$10,$05
    db $18,$05,$28,$09,$24,$05,$38,$0B
    db $14,$07,$60,$09,$28,$05,$64,$09
    db $6A,$05,$68,$09,$AC,$05,$6C,$09
    db $2C,$06,$70,$09,$30,$06,$74,$09
    db $B2,$05,$78,$09,$32,$05,$68,$01
    db $FC,$07,$50,$0A,$C0,$0F,$D8,$00
    db $7C,$07,$FC,$00,$7C,$07,$20,$01
    db $7C,$07,$44,$01,$7C,$07,$50,$09
    db $D4,$06,$4C,$09,$94,$06,$7C,$09
    db $14,$06,$80,$09,$94,$05,$84,$09
    db $18,$07,$88,$09,$1A,$07,$48,$09
    db $9C,$07,$8C,$09,$1C,$10,$90,$09
    db $60,$10,$94,$09,$64,$10,$38,$09
    db $DC,$10,$98,$09,$84,$28,$A4,$09
    db $18,$31,$84,$09,$1C,$31,$A8,$09
    db $E0,$30,$4C,$09,$60,$30,$A0,$09
    db $CA,$30,$A0,$09,$0E,$31,$B0,$09
    db $10,$31,$B4,$09,$CC,$30,$B8,$09
    db $8C,$30,$BC,$09,$0C,$30,$BC,$09
    db $8C,$27,$BC,$09,$A0,$27,$BC,$09
    db $20,$27,$AC,$09,$A0,$26,$28,$09
    db $20,$26,$00,$0A,$64,$30,$04,$0A
    db $A8,$30,$08,$0A,$28,$31,$18,$09
    db $22,$26,$98,$09,$26,$26,$C0,$09
    db $2A,$26,$C4,$09,$6C,$26,$C8,$09
    db $70,$26,$CC,$09,$B0,$26,$28,$09
    db $30,$27,$D0,$09,$70,$27,$38,$09
    db $B0,$27,$28,$09,$30,$30,$38,$09
    db $B0,$30,$38,$09,$F0,$30,$D4,$09
    db $B0,$31,$D8,$09,$2E,$32,$98,$09
    db $2A,$32,$E0,$09,$CC,$26,$BC,$09
    db $8C,$26,$E4,$09,$0C,$26,$DC,$09
    db $04,$27,$DC,$09,$C0,$26,$DC,$09
    db $40,$27,$98,$09,$B4,$01,$0C,$0B
    db $B8,$01,$30,$0B,$88,$09,$34,$0B
    db $A0,$09,$10,$0A,$8A,$09,$10,$0A
    db $9E,$09,$0C,$0A,$8C,$09,$0C,$0A
    db $9C,$09,$10,$0A,$8E,$09,$10,$0A
    db $9A,$09,$0C,$0A,$90,$09,$0C,$0A
    db $98,$09,$10,$0A,$92,$09,$10,$0A
    db $96,$09,$14,$0A,$A4,$09,$A8,$03
    db $30,$08,$18,$0A,$AC,$09,$1C,$0A
    db $F0,$09,$9C,$09,$70,$0A,$20,$0A
    db $F0,$0A,$20,$0A,$70,$0B,$20,$0A
    db $F0,$0B,$24,$0A,$70,$0C,$38,$09
    db $F0,$0C,$28,$0A,$30,$0D,$2C,$0A
    db $98,$0A,$30,$0A,$9C,$0A,$14,$0B
    db $10,$0B,$18,$0B,$90,$0B,$34,$0A
    db $1C,$0B,$38,$0A,$5E,$0B,$3C,$0A
    db $62,$0B,$40,$0A,$66,$0B,$20,$0A
    db $E8,$0A,$9C,$09,$68,$0A,$7C,$0A
    db $A4,$33,$7C,$0A,$E8,$33,$7C,$0A
    db $68,$34,$18,$09,$A2,$33,$C0,$09
    db $A4,$33,$30,$09,$E8,$33,$54,$0A
    db $28,$34,$38,$09,$A8,$34,$7C,$0A
    db $98,$33,$7C,$0A,$9C,$33,$58,$0A
    db $9E,$33,$98,$09,$9C,$33,$28,$09
    db $98,$33,$7C,$0A,$26,$36,$7C,$0A
    db $20,$36,$5C,$0A,$68,$35,$14,$09
    db $A8,$35,$D8,$09,$26,$36,$1C,$09
    db $24,$36,$28,$09,$20,$36,$7C,$0A
    db $2C,$35,$7C,$0A,$30,$35,$60,$0A
    db $2A,$35,$98,$09,$2C,$35,$98,$09
    db $2E,$35,$98,$09,$30,$35,$7C,$0A
    db $DA,$35,$7C,$0A,$98,$34,$7C,$0A
    db $18,$34,$58,$0A,$1E,$36,$3C,$09
    db $1C,$36,$64,$0A,$D8,$35,$44,$09
    db $98,$35,$28,$09,$18,$35,$38,$09
    db $98,$34,$38,$09,$18,$34,$28,$09
    db $98,$33,$7C,$0A,$A0,$36,$7C,$0A
    db $60,$37,$D0,$09,$60,$36,$38,$09
    db $E0,$36,$38,$09,$60,$37,$7C,$0A
    db $9C,$33,$18,$09,$9A,$33,$98,$09
    db $9C,$33,$7C,$0A,$10,$35,$58,$0A
    db $96,$33,$6C,$0A,$92,$33,$70,$0A
    db $D0,$33,$74,$0A,$10,$34,$38,$09
    db $90,$34,$28,$09,$10,$35,$7C,$0A
    db $1C,$35,$7C,$0A,$22,$35,$98,$09
    db $14,$35,$28,$09,$18,$35,$98,$09
    db $1C,$35,$98,$09,$20,$35,$98,$09
    db $24,$35,$7C,$0A,$10,$36,$D0,$09
    db $50,$35,$38,$09,$90,$35,$28,$09
    db $10,$36,$7C,$0A,$90,$36,$7C,$0A
    db $0E,$37,$7C,$0A,$0A,$37,$7C,$0A
    db $02,$37,$D0,$09,$50,$36,$78,$0A
    db $D0,$36,$1C,$09,$0C,$37,$98,$09
    db $08,$37,$98,$09,$04,$37,$98,$09
    db $00,$37,$90,$0A,$12,$18,$94,$0A
    db $AA,$2B,$98,$0A,$A8,$2B,$9C,$0A
    db $A4,$2B,$94,$0A,$A2,$2B,$98,$0A
    db $A0,$2B,$A0,$0A,$64,$2B,$A4,$0A
    db $9A,$2B,$98,$0A,$98,$2B,$98,$0A
    db $96,$2B,$98,$0A,$94,$2B,$9C,$0A
    db $90,$2B,$A0,$0A,$5C,$2B,$A0,$0A
    db $50,$2B,$A8,$0A,$10,$2B,$9C,$0A
    db $90,$2A,$AC,$0A,$92,$2A,$98,$0A
    db $94,$2A,$98,$0A,$96,$2A,$98,$0A
    db $98,$2A,$A0,$0A,$50,$2A,$A8,$0A
    db $10,$2A,$3C,$0B,$90,$29,$40,$0B
    db $94,$29,$40,$0B,$98,$29,$A0,$0A
    db $5C,$2A,$A8,$0A,$1C,$2A,$A8,$0A
    db $DC,$29,$A0,$0A,$64,$2A,$A8,$0A
    db $24,$2A,$A8,$0A,$E4,$29,$B0,$0A
    db $90,$1D,$A0,$09,$8C,$1D,$B0,$0A
    db $56,$1E,$B4,$0A,$5A,$1E,$B8,$0A
    db $5C,$1D,$A0,$09,$18,$1D,$BC,$0A
    db $90,$1C,$BC,$0A,$0C,$1C,$A0,$09
    db $0C,$1E,$C0,$0A,$8A,$1E,$C0,$0A
    db $86,$1E,$BC,$0A,$04,$1E,$A0,$09
    db $84,$1D,$B8,$0A,$C6,$1C,$B0,$0A
    db $0C,$1D,$A0,$09,$88,$1D,$A0,$09
    db $84,$1D,$B4,$0A,$80,$1D,$A0,$09
    db $3C,$16,$A0,$09,$BC,$16,$A0,$09
    db $B8,$16,$A0,$09,$B4,$16,$A0,$09
    db $30,$16,$A8,$0A,$70,$15,$C4,$0A
    db $30,$15,$D8,$0A,$B8,$13,$4C,$09
    db $B0,$14,$C8,$0A,$32,$14,$CC,$0A
    db $F4,$13,$D0,$0A,$B8,$13,$D4,$0A
    db $B8,$12,$F8,$01,$F4,$11,$1C,$02
    db $F4,$11,$40,$02,$F4,$11,$64,$02
    db $F4,$11,$88,$02,$F4,$11,$AC,$02
    db $F4,$11,$D0,$02,$F4,$11,$F4,$02
    db $F4,$11,$18,$03,$F4,$11,$3C,$03
    db $B4,$11,$60,$03,$B4,$11,$3C,$03
    db $B4,$11,$DC,$0A,$10,$3D,$E0,$0A
    db $CE,$3C,$E4,$0A,$8C,$3C,$E8,$0A
    db $48,$3C,$EC,$0A,$14,$3C,$F0,$0A
    db $D6,$3B,$F4,$0A,$98,$3B,$F8,$0A
    db $5A,$3B,$18,$09,$26,$3C,$98,$09
    db $28,$3C,$98,$09,$2A,$3C,$98,$09
    db $2C,$3C,$6C,$09,$28,$3D,$FC,$0A
    db $68,$3D,$00,$0B,$AA,$3D,$E4,$0A
    db $EC,$3D,$E4,$0A,$2E,$3E,$DC,$0A
    db $B0,$3E,$3C,$0B,$90,$29,$40,$0B
    db $94,$29,$40,$0B,$98,$29,$04,$0B
    db $9C,$3D,$08,$0B,$D8,$3D,$08,$0B
    db $14,$3E,$08,$0B,$50,$3E,$08,$0B
    db $8C,$3E,$6C,$09,$88,$3E,$44,$01
    db $7C,$07,$38,$09,$E0,$19,$1C,$0B
    db $20,$1A,$CC,$03,$DC,$1A,$F0,$03
    db $DC,$1A,$14,$04,$DC,$1A,$38,$04
    db $9C,$1B,$5C,$04,$9C,$1B,$80,$04
    db $5C,$1B,$A4,$04,$1C,$1B,$C8,$04
    db $DC,$1A,$EC,$04,$9C,$1A,$58,$0A
    db $1E,$1B,$20,$0B,$1C,$1B,$24,$0B
    db $1A,$1B,$28,$0B,$18,$1B,$A0,$09
    db $94,$1B,$A0,$09,$14,$1C,$A0,$09
    db $94,$1C,$C0,$0A,$14,$1D,$2C,$0B
    db $56,$1D,$A0,$09,$D4,$1D,$98,$09
    db $90,$39,$98,$09,$94,$39,$28,$09
    db $98,$39,$98,$09,$9C,$39,$98,$09
    db $A0,$39,$28,$09,$A4,$39,$98,$09
    db $A8,$39,$98,$09,$AC,$39,$28,$09
    db $B0,$39,$98,$09,$B4,$39,$98,$09
    db $B4,$38,$28,$09,$B0,$38,$98,$09
    db $AC,$38,$98,$09,$A8,$38,$28,$09
    db $A4,$38,$98,$09,$A0,$38,$98,$09
    db $9C,$38,$28,$09,$98,$38,$98,$09
    db $94,$38,$98,$09,$90,$38,$28,$09
    db $8C,$38,$98,$09,$88,$38,$28,$09
    db $84,$38

DATA_04E359:
    db $00,$00

DATA_04E35B:
    db $00,$00,$0D,$00,$0D,$00,$10,$00
    db $15,$00,$18,$00,$1A,$00,$20,$00
    db $23,$00,$26,$00,$29,$00,$2C,$00
    db $35,$00,$39,$00,$3A,$00,$42,$00
    db $46,$00,$4A,$00,$4C,$00,$4D,$00
    db $4E,$00,$52,$00,$59,$00,$5D,$00
    db $60,$00,$67,$00,$6A,$00,$6C,$00
    db $6F,$00,$72,$00,$75,$00,$77,$00
    db $77,$00,$83,$00,$83,$00,$84,$00
    db $8E,$00,$90,$00,$92,$00,$98,$00
    db $98,$00,$98,$00,$A0,$00,$A5,$00
    db $AC,$00,$B2,$00,$BD,$00,$C2,$00
    db $C5,$00,$CC,$00,$D3,$00,$D7,$00
    db $E1,$00,$E2,$00,$E2,$00,$E2,$00
    db $E5,$00,$E7,$00,$E8,$00,$ED,$00
    db $EE,$00,$F1,$00,$F5,$00,$FA,$00
    db $FD,$00,$00,$01,$00,$01,$00,$01
    db $00,$01,$00,$01,$02,$01,$08,$01
    db $0F,$01,$12,$01,$14,$01,$16,$01
    db $17,$01,$1E,$01,$2B,$01,$2B,$01
    db $2B,$01,$2B,$01,$2F,$01,$2F,$01
    db $2F,$01,$33,$01,$33,$01,$33,$01
    db $37,$01,$37,$01,$37,$01,$40,$01
    db $40,$01,$46,$01,$46,$01,$46,$01
    db $47,$01,$52,$01,$56,$01,$5C,$01
    db $5C,$01,$5F,$01,$62,$01,$65,$01
    db $68,$01,$6B,$01,$6E,$01,$71,$01
    db $73,$01,$73,$01,$73,$01,$73,$01
    db $73,$01,$73,$01,$73,$01,$73,$01
    db $73,$01,$73,$01,$73,$01,$73,$01
DATA_04E44B:
    db $80,$40,$20,$10,$08,$04,$02,$01

CODE_04E453:
    SEP #$30                                  ; AXY->8
    LDA.B _F
    AND.B #$07
    TAX
    LDA.B _F
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W OWEventsActivated,Y
    AND.L DATA_04E44B,X
    BNE +
    RTS

  + LDA.B _F
    ASL A
    TAX
    REP #$20                                  ; A->16
    LDA.L DATA_04E359,X
    STA.W EventTileIndex
    LDA.L DATA_04E35B,X
    STA.W EventLength
    CMP.W EventTileIndex
    BEQ CODE_04E493
  - JSR CODE_04E496
    REP #$20                                  ; A->16
    INC.W EventTileIndex
    LDA.W EventTileIndex
    CMP.W EventLength
    BNE -
CODE_04E493:
    SEP #$30                                  ; AXY->8
    RTS

CODE_04E496:
    REP #$30                                  ; AXY->16
    LDA.W EventTileIndex
    ASL A
    ASL A
    TAX
    LDA.L DATA_04DD8D,X
    TAY
    LDA.L DATA_04DD8F,X
    STA.B _4
CODE_04E4A9:
    SEP #$20                                  ; A->8
    LDA.B #$7F
    STA.B _8
    LDA.B #$0C
    STA.B _B
    REP #$20                                  ; A->16
    LDA.W #$0000
    STA.B _6
    LDA.W #$8000
    STA.B _9
    CPY.W #$0900
    BCC +
    JSR CODE_04E4D0
    JMP CODE_04E4CD

  + JSR CODE_04E520
CODE_04E4CD:
    SEP #$30                                  ; AXY->8
    RTS

CODE_04E4D0:
    LDA.W #$0001
    STA.B _0
CODE_04E4D5:
    LDX.B _4
    LDA.W #$0001
    STA.B _C
CODE_04E4DC:
    SEP #$20                                  ; A->8
    LDA.B [_9],Y
    STA.L OWLayer2Tilemap,X
    INX
    LDA.B [_6],Y
    STA.L OWLayer2Tilemap,X
    INY
    INX
    REP #$20                                  ; A->16
    TXA
    AND.W #$003F
    BNE +
    DEX
    TXA
    AND.W #$FFC0
    CLC
    ADC.W #$0800
    TAX
  + DEC.B _C
    BPL CODE_04E4DC
    LDA.B _4
    TAX
    CLC
    ADC.W #$0040
    STA.B _4
    AND.W #$07C0
    BNE +
    TXA
    AND.W #$F83F
    CLC
    ADC.W #$1000
    STA.B _4
  + DEC.B _0
    BPL CODE_04E4D5
    RTS

CODE_04E520:
    LDA.W #$0005
    STA.B _0
CODE_04E525:
    LDX.B _4
    LDA.W #$0005
    STA.B _C
CODE_04E52C:
    SEP #$20                                  ; A->8
    LDA.B [_9],Y
    STA.L OWLayer2Tilemap,X
    INX
    LDA.B [_6],Y
    STA.L OWLayer2Tilemap,X
    INY
    INX
    REP #$20                                  ; A->16
    TXA
    AND.W #$003F
    BNE +
    DEX
    TXA
    AND.W #$FFC0
    CLC
    ADC.W #$0800
    TAX
  + DEC.B _C
    BPL CODE_04E52C
    LDA.B _4
    TAX
    CLC
    ADC.W #$0040
    STA.B _4
    AND.W #$07C0
    BNE +
    TXA
    AND.W #$F83F
    CLC
    ADC.W #$1000
    STA.B _4
  + DEC.B _0
    BPL CODE_04E525
    RTS

CODE_04E570:
    LDA.W OverworldEventProcess
    JSL ExecutePtr

    dw CODE_04E5EE
    dw CODE_04EBEB
    dw CODE_04E6D3
    dw CODE_04E6F9
    dw CODE_04EAA4
    dw CODE_04EC78
    dw CODE_04EBEB
    dw CODE_04E9EC

DATA_04E587:
    db $20,$52,$22,$DA,$28,$58,$24,$C0
    db $24,$94,$23,$42,$28,$94,$2A,$98
    db $25,$0E,$25,$52,$25,$C4,$2A,$DE
    db $2A,$98,$28,$44,$2C,$50,$2C,$0C
DATA_04E5A7:
    db $77,$79,$58,$4C,$A6

DATA_04E5AC:
    db $85,$86,$00,$10,$00

DATA_04E5B1:
    db $85,$86,$81,$81,$81

DATA_04E5B6:
    db $19,$04,$BD,$00,$1C,$06,$30,$01
    db $2A,$01,$D1,$00,$2A,$06,$AC,$06
    db $47,$05,$59,$05,$72,$05,$BF,$02
    db $AC,$02,$12,$02,$18,$03,$06,$03
DATA_04E5D6:
    db $06,$0F,$1C,$21,$24,$28,$29,$37
    db $40,$41,$43,$4A,$4D,$02,$61,$35
DATA_04E5E6:
    db $58,$59,$5D,$63,$77,$79,$7E,$80

CODE_04E5EE:
    LDA.W OWLevelExitMode
    CMP.B #$02
    BNE +
    INC.W OverworldEvent
  + LDA.W CreditsScreenNumber
    BEQ CODE_04E61A
    LDA.W OverworldEvent
    CMP.B #$FF
    BEQ CODE_04E61A
    LDA.W OverworldEvent
    AND.B #$07
    TAX
    LDA.W OverworldEvent
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W OWEventsActivated,Y
    AND.L DATA_04E44B,X
    BEQ CODE_04E640
CODE_04E61A:
    LDX.B #$07
CODE_04E61C:
    LDA.W DATA_04E5E6,X
    CMP.W OverworldLayer1Tile
    BNE +
    INC.W OverworldProcess
    LDA.B #$E0
    STA.W OWLevelExitMode
    LDA.B #$0F
    STA.W KeepModeActive
    RTS

  + DEX
    BPL CODE_04E61C
    LDA.B #$05
    STA.W OverworldProcess
    LDA.B #$80
    STA.W OWLevelExitMode
    RTS

CODE_04E640:
    INC.W OverworldEventProcess
    LDA.W OverworldEvent
    JSR CODE_04E677
    TYA
    ASL A
    ASL A
    ASL A
    ASL A
    STA.W OverworldEventXPos
    TYA
    AND.B #$F0
    STA.W OverworldEventYPos
    LDA.B #$28
    STA.W OverworldEventSize
    LDA.W TranslevelNo
    CMP.B #$18
    BNE +
    LDA.B #$FF
    STA.W OverworldEarthquake
  + LDA.W OverworldEventProcess
    CMP.B #$02
    BEQ +
    LDA.B #!SFX_CASTLECRUSH
    STA.W SPCIO3                              ; / Play sound effect
  + SEP #$30                                  ; AXY->8
    RTS

CODE_04E677:
    SEP #$30                                  ; AXY->8
    LDX.B #$17
CODE_04E67B:
    CMP.L DATA_04E5D6,X
    BEQ CODE_04E68A
    DEX
    BPL CODE_04E67B
CODE_04E684:
    LDA.B #$02
    STA.W OverworldEventProcess
    RTS

CODE_04E68A:
    STX.W StructureCrushIndex
    TXA
    ASL A
    TAX
    LDA.B #$7E
    STA.B _C
    REP #$30                                  ; AXY->16
    LDA.W #$C800
    STA.B _A
    LDA.L DATA_04E5B6,X
    TAY
    SEP #$20                                  ; A->8
    LDX.W #$0004
    LDA.B [_A],Y
CODE_04E6A7:
    CMP.L DATA_04E5A7,X
    BEQ CODE_04E6B3
    DEX
    BPL CODE_04E6A7
    JMP CODE_04E684

CODE_04E6B3:
    TXA
    STA.W StructureCrushTile
    CPX.W #$0003
    BMI +
    LDA.L DATA_04E5AC,X
    STA.B [_A],Y
    REP #$20                                  ; A->16
    TYA
    CLC
    ADC.W #$0010
    TAY
  + SEP #$20                                  ; A->8
    LDA.L DATA_04E5B1,X
    STA.B [_A],Y
    RTS

CODE_04E6D3:
    INC.W OverworldEventProcess
    LDA.W OverworldEvent
    ASL A
    TAX
    REP #$20                                  ; A->16
    LDA.L DATA_04E359,X
    STA.W EventTileIndex
    LDA.L DATA_04E35B,X
    STA.W EventLength
    CMP.W EventTileIndex
    SEP #$20                                  ; A->8
    BNE +
    INC.W OverworldEventProcess
    INC.W OverworldEventProcess
  + RTS

CODE_04E6F9:
    JSR CODE_04EA62
    LDA.B #$7F
    STA.B _E
    REP #$30                                  ; AXY->16
    LDA.W EventTileIndex
    ASL A
    ASL A
    TAX
    LDA.L DATA_04DD8D,X
    STA.W OverworldEventSize
    LDA.L DATA_04DD8F,X
    STA.B _0
    AND.W #$1FFF
    LSR A
    CLC
    ADC.W #$3000
    XBA
    STA.B _2
    LDA.B _0
    LSR A
    LSR A
    LSR A
    SEP #$20                                  ; A->8
    AND.B #$F8
    STA.W OverworldEventYPos
    LDA.B _0
    AND.B #$3E
    ASL A
    ASL A
    STA.W OverworldEventXPos
    REP #$20                                  ; A->16
    LDA.W #$4000
    STA.B _C
    LDA.W #$EFFF
    STA.B _A
    LDA.W OverworldEventSize
    CMP.W #$0900
    BCC +
    JSR CODE_04E76C
    JMP CODE_04E752

  + JSR CODE_04E824
CODE_04E752:
    LDA.W #$00FF
    STA.L DynamicStripeImage,X
    TXA
    STA.L DynStripeImgSize
    JSR CODE_04E496
    SEP #$30                                  ; AXY->8
    LDA.B #!SFX_NEWLEVEL
    STA.W SPCIO3                              ; / Play sound effect
    INC.W OverworldEventProcess
    RTS

CODE_04E76C:
    LDA.W #$0001
    STA.B _6
    LDA.L DynStripeImgSize
    TAX
CODE_04E776:
    LDA.B _2
    STA.L DynamicStripeImage,X
    INX
    INX
    LDY.W #$0300
    LDA.B _3
    AND.W #$001F
    STA.B _8
    LDA.W #$0020
    SEC
    SBC.B _8
    STA.B _8
    CMP.W #$0001
    BNE +
    LDA.B _8
    ASL A
    DEC A
    XBA
    TAY
  + TYA
    STA.L DynamicStripeImage,X
    INX
    INX
    LDA.W #$0001
    STA.B _4
    LDY.B _0
CODE_04E7A9:
    LDA.B [_C],Y
    AND.B _A
    STA.L DynamicStripeImage,X
    INX
    INX
    INY
    INY
    TYA
    AND.W #$003F
    BNE +
    LDA.B _4
    BEQ +
    DEY
    TYA
    AND.W #$FFC0
    CLC
    ADC.W #$0800
    TAY
    LDA.B _2
    XBA
    AND.W #$3BE0
    CLC
    ADC.W #$0400
    XBA
    STA.L DynamicStripeImage,X
    INX
    INX
    LDA.B _8
    ASL A
    DEC A
    XBA
    STA.L DynamicStripeImage,X
    INX
    INX
  + DEC.B _4
    BPL CODE_04E7A9
    LDA.B _2
    XBA
    CLC
    ADC.W #$0020
    XBA
    STA.B _2
    LDA.B _0
    TAY
    CLC
    ADC.W #$0040
    STA.B _0
    AND.W #$07C0
    BNE +
    TYA
    AND.W #$F83F
    CLC
    ADC.W #$1000
    STA.B _0
    LDA.B _2
    XBA
    SEC
    SBC.W #$0020
    AND.W #$341F
    CLC
    ADC.W #$0800
    XBA
    STA.B _2
  + DEC.B _6
    BMI +
    JMP CODE_04E776

  + RTS

CODE_04E824:
    LDA.W #$0005
    STA.B _6
    LDA.L DynStripeImgSize
    TAX
CODE_04E82E:
    LDA.B _2
    STA.L DynamicStripeImage,X
    INX
    INX
    LDY.W #$0B00
    LDA.B _3
    AND.W #$001F
    STA.B _8
    LDA.W #$0020
    SEC
    SBC.B _8
    STA.B _8
    CMP.W #$0006
    BCS +
    LDA.B _8
    ASL A
    DEC A
    XBA
    TAY
    LDA.W #$0006
    SEC
    SBC.B _8
    STA.B _8
  + TYA
    STA.L DynamicStripeImage,X
    INX
    INX
    LDA.W #$0005
    STA.B _4
    LDY.B _0
CODE_04E869:
    LDA.B [_C],Y
    AND.B _A
    STA.L DynamicStripeImage,X
    INX
    INX
    INY
    INY
    TYA
    AND.W #$003F
    BNE +
    LDA.B _4
    BEQ +
    DEY
    TYA
    AND.W #$FFC0
    CLC
    ADC.W #$0800
    TAY
    LDA.B _2
    XBA
    AND.W #$3BE0
    CLC
    ADC.W #$0400
    XBA
    STA.L DynamicStripeImage,X
    INX
    INX
    LDA.B _8
    ASL A
    DEC A
    XBA
    STA.L DynamicStripeImage,X
    INX
    INX
  + DEC.B _4
    BPL CODE_04E869
    LDA.B _2
    XBA
    CLC
    ADC.W #$0020
    XBA
    STA.B _2
    LDA.B _0
    TAY
    CLC
    ADC.W #$0040
    STA.B _0
    AND.W #$07C0
    BNE +
    TYA
    AND.W #$F83F
    CLC
    ADC.W #$1000
    STA.B _0
    LDA.B _2
    XBA
    SEC
    SBC.W #$0020
    AND.W #$341F
    CLC
    ADC.W #$0800
    XBA
    STA.B _2
  + DEC.B _6
    BMI +
    JMP CODE_04E82E

  + RTS


DATA_04E8E4:
    db $06,$06,$06,$06,$06,$06,$06,$06
    db $14,$14,$14,$14,$14,$1D,$1D,$1D
    db $1D,$12,$12,$12,$1C,$2F,$2F,$2F
    db $2F,$2F,$34,$34,$34,$47,$4E,$4E
    db $01,$0F,$24,$24,$6C,$0F,$0F,$54
    db $55,$57,$58,$5D

DATA_04E910:
    db $00,$00,$00,$00,$00,$00,$01,$01
    db $00,$01,$01,$01,$01,$01,$01,$01
    db $00,$01,$01,$00,$00,$01,$01,$01
    db $01,$01,$01,$01,$01,$00,$01,$00
    db $00,$01,$01,$01,$01,$01,$00,$00
    db $00,$00,$00,$00

DATA_04E93C:
    db $15,$02,$35,$02,$45,$02,$55,$02
    db $65,$02,$75,$02,$14,$11,$94,$10
    db $A9,$00,$A4,$05,$24,$05,$28,$07
    db $A4,$06,$A8,$01,$AC,$01,$B0,$01
    db $3C,$00,$00,$29,$80,$28,$10,$05
    db $54,$01,$30,$18,$B0,$18,$2E,$19
    db $2A,$19,$26,$19,$24,$18,$20,$18
    db $1C,$18,$97,$05,$EC,$2A,$7B,$05
    db $12,$02,$94,$31,$A0,$32,$20,$33
    db $16,$1D,$14,$31,$25,$06,$F0,$01
    db $F0,$01,$04,$03,$04,$03,$27,$02
DATA_04E994:
    db $68,$00,$24,$00,$24,$00,$25,$00
    db $00,$00,$81,$00,$38,$09,$28,$09
    db $66,$00,$9C,$09,$28,$09,$F8,$09
    db $FC,$09,$98,$09,$98,$09,$28,$09
    db $66,$00,$38,$09,$28,$09,$66,$00
    db $68,$00,$80,$0A,$84,$0A,$88,$0A
    db $98,$09,$98,$09,$94,$09,$98,$09
    db $8C,$0A,$66,$00,$84,$03,$66,$00
    db $79,$00,$A8,$0A,$38,$09,$38,$09
    db $A0,$09,$30,$0A,$69,$00,$5F,$00
    db $5F,$00,$5F,$00,$5F,$00,$5F,$00

CODE_04E9EC:
    LDA.W OverworldEvent
    STA.B _F
CODE_04E9F1:
    LDX.B #$2B
CODE_04E9F3:
    CMP.L DATA_04E8E4,X
    BEQ CODE_04EA25
CODE_04E9F9:
    DEX
    BPL CODE_04E9F3
    LDA.W OverworldEventProcess
    BEQ +
    STZ.W OverworldEventProcess
    INC.W OverworldProcess
    LDA.W OverworldEvent
    AND.B #$07
    TAX
    LDA.W OverworldEvent
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W OWEventsActivated,Y
    ORA.L DATA_04E44B,X
    STA.W OWEventsActivated,Y
    INC.W ExitsCompleted
    STZ.W CreditsScreenNumber
  + RTS

CODE_04EA25:
    PHX
    LDA.L DATA_04E910,X
    STA.B _2
    TXA
    ASL A
    TAX
    REP #$20                                  ; A->16
    LDA.L DATA_04E994,X
    STA.B _0
    LDA.L DATA_04E93C,X
    STA.B _4
    LDA.B _2
    AND.W #$0001
    BEQ +
    REP #$10                                  ; XY->16
    LDY.B _0
    JSR CODE_04E4A9
    JMP CODE_04EA5A

  + SEP #$20                                  ; A->8
    REP #$10                                  ; XY->16
    LDX.B _4
    LDA.B _0
    STA.L Map16TilesLow,X
CODE_04EA5A:
    SEP #$30                                  ; AXY->8
    PLX
    LDA.B _F
    JMP CODE_04E9F9

CODE_04EA62:
    STZ.W ColorFadeTimer
    STZ.W ColorFadeDir
    LDX.B #$6F
  - LDA.W MainPalette,X
    STA.W CopyPalette+2,X
    STZ.W CopyPalette+$74,X
    DEX
    BPL -
    LDX.B #$6F
CODE_04EA78:
    LDY.B #$10
  - LDA.W MainPalette+$80,X
    STA.W CopyPalette+2,X
    DEX
    DEY
    BNE -
    TXA
    SEC
    SBC.B #$10
    TAX
    BPL CODE_04EA78
CODE_04EA8B:
    REP #$20                                  ; A->16
    LDA.W #$0070
    STA.W CopyPalette
    LDA.W #$C070
    STA.W CopyPalette+$72
    SEP #$20                                  ; A->8
    STZ.W CopyPalette+$E4
    LDA.B #!PaletteTableUse_Copy
    STA.W PaletteIndexTable
    RTS

CODE_04EAA4:
    LDA.W ColorFadeTimer
    CMP.B #$40
    BCC CODE_04EAC9
    INC.W OverworldEventProcess
    JSR CODE_04EE30
    JSR CODE_04E496
    REP #$20                                  ; A->16
    INC.W EventTileIndex
    LDA.W EventTileIndex
    CMP.W EventLength
    SEP #$20                                  ; A->8
    BCS +
    LDA.B #$03
    STA.W OverworldEventProcess
  + RTS

CODE_04EAC9:
    JSR CODE_04EC67
    REP #$30                                  ; AXY->16
    LDY.W #$008C
    LDX.W #$0006
    LDA.W OverworldEventSize
    CMP.W #$0900
    BCC +
    LDY.W #$000C
    LDX.W #$0002
  + STX.B _5
    TAX
    SEP #$20                                  ; A->8
CODE_04EAE7:
    LDA.B _5
    STA.B _3
    LDA.B _0
  - STA.B _2
    LDA.B _1
    STA.W OAMTileYPos+$150,Y
    LDA.L OWEventTileNum,X
    STA.W OAMTileNo+$150,Y
    LDA.L OWEventTilemap,X
    AND.B #$C0
    STA.B _4
    LDA.L OWEventTilemap,X
    AND.B #$1C
    LSR A
    ORA.B _4
    ORA.B #$11
    STA.W OAMTileAttr+$150,Y
    LDA.B _2
    STA.W OAMTileXPos+$150,Y
    CLC
    ADC.B #$08
    INX
    DEY
    DEY
    DEY
    DEY
    DEC.B _3
    BNE -
    LDA.B _1
    CLC
    ADC.B #$08
    STA.B _1
    CPY.W #$FFFC
    BNE CODE_04EAE7
    SEP #$10                                  ; XY->8
    LDX.B #$23
  - STZ.W OAMTileSize+$54,X
    DEX
    BPL -
    LDY.B #$08
    LDX.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,X
    CMP.B #$03
    BNE +
    LDY.B #$01
  + STY.B GraphicsCompPtr
  - LDA.W ColorFadeTimer
    JSL CODE_00B006
    DEC.B GraphicsCompPtr
    BNE -
    JMP CODE_04EA8B


DATA_04EB56:
    db $F5,$11,$F2,$15,$F5,$11,$F3,$14
    db $F5,$11,$F3,$14,$F6,$10,$F4,$13
    db $F7,$0F,$F5,$12,$F8,$0E,$F7,$11
    db $FA,$0D,$F9,$10,$FC,$0C,$FB,$0D
    db $FF,$0A,$FE,$0B,$01,$07,$01,$07
    db $00,$08,$00,$08

DATA_04EB82:
    db $F8,$F8,$11,$12,$F8,$F8,$10,$11
    db $F8,$F8,$10,$11,$F9,$F9,$0F,$10
    db $FA,$FA,$0E,$0F,$FB,$FB,$0C,$0D
    db $FC,$FC,$0B,$0B,$FE,$FE,$0A,$0A
    db $00,$00,$08,$08,$01,$01,$07,$07
    db $00,$00,$08,$08

DATA_04EBAE:
    db $F6,$B6,$76,$36,$F6,$B6,$76,$36
    db $36,$76,$B6,$F6,$36,$76,$B6,$F6
    db $36,$36,$36,$36,$36,$36,$36,$36
    db $36,$36,$36,$36,$36,$36,$36,$36
    db $36,$36,$36,$36,$36,$36,$36,$36
    db $30,$70,$B0,$F0

DATA_04EBDA:
    db $22,$23,$32,$33,$32,$23,$22

DATA_04EBE1:
    db $73,$73,$72,$72,$5F,$5F,$28,$28
    db $28,$28

CODE_04EBEB:
    DEC.W OverworldEventSize
    BPL +
    INC.W OverworldEventProcess
    RTS

  + LDA.W OverworldEventSize
    LDY.W OverworldEventProcess
    CPY.B #$01
    BEQ CODE_04EC17
    CMP.B #$10
    BNE +
    PHA
    JSR CODE_04ED83
    PLA
  + LSR A
    LSR A
    TAX
    LDA.W DATA_04EBDA,X
    STA.B _2
    JSR CODE_04EC67
    LDX.B #$28
    JMP CODE_04EC2E

CODE_04EC17:
    CMP.B #$18
    BNE +
    PHA
    JSR CODE_04EEAA
    PLA
  + AND.B #$FC
    TAX
    LSR A
    LSR A
    TAY
    LDA.W DATA_04EBE1,Y
    STA.B _2
    JSR CODE_04EC67
CODE_04EC2E:
    LDA.B #$03
    STA.B _3
    LDY.B #$00
  - LDA.B _0
    CLC
    ADC.W DATA_04EB56,X
    STA.W OAMTileXPos+$80,Y
    LDA.B _1
    CLC
    ADC.W DATA_04EB82,X
    STA.W OAMTileYPos+$80,Y
    LDA.B _2
    STA.W OAMTileNo+$80,Y
    LDA.W DATA_04EBAE,X
    STA.W OAMTileAttr+$80,Y
    INY
    INY
    INY
    INY
    INX
    DEC.B _3
    BPL -
    STZ.W OAMTileSize+$20
    STZ.W OAMTileSize+$21
    STZ.W OAMTileSize+$22
    STZ.W OAMTileSize+$23
    RTS

CODE_04EC67:
    LDA.W OverworldEventXPos
    SEC
    SBC.B Layer2XPos
    STA.B _0
    LDA.W OverworldEventYPos
    CLC
    SBC.B Layer2YPos
    STA.B _1
    RTS

CODE_04EC78:
    LDA.B #$7E
    STA.B _F
    REP #$30                                  ; AXY->16
    LDA.W #$C800
    STA.B _D
    LDA.W OverworldEvent
    AND.W #$00FF
    ASL A
    TAX
    LDA.L DATA_04D85D,X
    TAY
    LDX.W #$0015
    SEP #$20                                  ; A->8
    LDA.B [_D],Y
CODE_04EC97:
    CMP.L DATA_04DA1D,X
    BEQ CODE_04ECA8
    DEX
    BPL CODE_04EC97
    SEP #$10                                  ; XY->8
    LDA.B #$07
    STA.W OverworldEventProcess
    RTS

CODE_04ECA8:
    SEP #$30                                  ; AXY->8
    LDA.B #!SFX_COIN
    STA.W SPCIO3                              ; / Play sound effect
    INC.W OverworldEventProcess
    LDA.W OverworldEvent
    AND.B #$FF
    ASL A
    TAX
    LDA.L DATA_04D85D,X
    ASL A
    ASL A
    ASL A
    ASL A
    STA.W OverworldEventXPos
    LDA.L DATA_04D85D,X
    AND.B #$F0
    STA.W OverworldEventYPos
    LDA.B #$1C
    STA.W OverworldEventSize
    RTS


DATA_04ECD3:
    db $86,$99,$86,$19,$86,$D9,$86,$59
    db $96,$99,$96,$19,$96,$D9,$96,$59
    db $86,$9D,$86,$1D,$86,$DD,$86,$5D
    db $96,$9D,$96,$1D,$96,$DD,$96,$5D
    db $86,$99,$86,$19,$86,$D9,$86,$59
    db $96,$99,$96,$19,$96,$D9,$96,$59
    db $86,$9D,$86,$1D,$86,$DD,$86,$5D
    db $96,$9D,$96,$1D,$96,$DD,$96,$5D
    db $88,$15,$98,$15,$89,$15,$99,$15
    db $A4,$11,$B4,$11,$A5,$11,$B5,$11
    db $22,$11,$90,$11,$22,$11,$91,$11
    db $C2,$11,$D2,$11,$C3,$11,$D3,$11
    db $A6,$11,$B6,$11,$A7,$11,$B7,$11
    db $82,$19,$92,$19,$83,$19,$93,$19
    db $C8,$19,$F8,$19,$C9,$19,$F9,$19
    db $80,$1C,$90,$1C,$81,$1C,$90,$5C
    db $80,$14,$90,$14,$81,$14,$90,$54
    db $A2,$11,$B2,$11,$A3,$11,$B3,$11
    db $82,$1D,$92,$1D,$83,$1D,$93,$1D
    db $86,$99,$86,$19,$86,$D9,$86,$59
    db $86,$99,$86,$19,$86,$D9,$86,$59
    db $A8,$11,$B8,$11,$A9,$11,$B9,$11

CODE_04ED83:
    LDA.B #Map16TilesLow>>16
    STA.B _F
    REP #$30                                  ; AXY->16
    LDA.W #Map16TilesLow
    STA.B _D
    LDA.W OverworldEvent
    AND.W #$00FF
    ASL A
    TAX
    LDA.L DATA_04D85D,X
    TAY
    LDX.W #$0015
    SEP #$20                                  ; A->8
    LDA.B [_D],Y
CODE_04EDA2:
    CMP.L DATA_04DA1D,X
    BEQ CODE_04EDAB
    DEX
    BNE CODE_04EDA2
CODE_04EDAB:
    REP #$30                                  ; AXY->16
    STX.B _E
    LDA.W OverworldEvent
    AND.W #$00FF
    ASL A
    TAX
    LDA.L DATA_04D93D,X
    STA.B _0
    LDA.L DATA_04D85D,X
    TAX
    PHX
    LDX.B _E
    SEP #$20                                  ; A->8
    LDA.L DATA_04DA33,X
    PLX
    STA.L Map16TilesLow,X
    LDA.B #DATA_04ECD3>>16
    STA.B _C
    REP #$20                                  ; A->16
    LDA.W #DATA_04ECD3
    STA.B _A
    LDA.B _E
    ASL A
    ASL A
    ASL A
    TAY
    LDA.L DynStripeImgSize
    TAX
CODE_04EDE6:
    LDA.B _0
    STA.L DynamicStripeImage,X
    CLC
    ADC.W #$2000
    STA.L DynamicStripeImage+8,X
    LDA.W #$0300
    STA.L DynamicStripeImage+2,X
    STA.L DynamicStripeImage+$0A,X
    LDA.B [_A],Y
    STA.L DynamicStripeImage+4,X
    INY
    INY
    LDA.B [_A],Y
    STA.L DynamicStripeImage+$0C,X
    INY
    INY
    LDA.B [_A],Y
    STA.L DynamicStripeImage+6,X
    INY
    INY
    LDA.B [_A],Y
    STA.L DynamicStripeImage+$0E,X
    LDA.W #$00FF
    STA.L DynamicStripeImage+$10,X
    TXA
    CLC
    ADC.W #$0010
    STA.L DynStripeImgSize
    SEP #$30                                  ; AXY->8
    RTS

CODE_04EE30:
    SEP #$20                                  ; A->8
    LDA.B #$7F
    STA.B _E
    REP #$30                                  ; AXY->16
    LDA.W EventTileIndex
    ASL A
    ASL A
    TAX
    LDA.L DATA_04DD8F,X
    STA.B _0
    AND.W #$1FFF
    LSR A
    CLC
    ADC.W #$3000
    XBA
    STA.B _2
    LDA.W #$4000
    STA.B _C
    LDA.W #$FFFF
    STA.B _A
    LDA.L DATA_04DD8D,X
    CMP.W #$0900
    BCC +
    JSR CODE_04E76C
    JMP CODE_04EE6B

  + JSR CODE_04E824
CODE_04EE6B:
    LDA.W #$00FF
    STA.L DynamicStripeImage,X
    TXA
    STA.L DynStripeImgSize
    SEP #$30                                  ; AXY->8
    RTS


DATA_04EE7A:
    db $22,$01,$82,$1C,$22,$01,$83,$1C
    db $22,$01,$82,$14,$22,$01,$83,$14
    db $EA,$01,$EA,$01,$EA,$C1,$EA,$C1
    db $EA,$01,$EA,$01,$EA,$C1,$EA,$C1
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $8A,$15,$9A,$15,$8B,$15,$9B,$15

CODE_04EEAA:
    SEP #$30                                  ; AXY->8
    LDA.B #Map16TilesLow>>16
    STA.B _F
    LDA.B #DATA_04EE7A>>16
    STA.B _C
    REP #$30                                  ; AXY->16
    LDA.W #Map16TilesLow
    STA.B _D
    LDA.W #DATA_04EE7A
    STA.B _A
    LDA.W StructureCrushIndex
    AND.W #$00FF
    ASL A
    TAX
    LDA.L DATA_04E587,X
    STA.B _0
    LDA.L DynStripeImgSize
    TAX
    LDA.W StructureCrushTile
    AND.W #$00FF
    CMP.W #$0003
    BMI +
    ASL A
    ASL A
    ASL A
    TAY
    LDA.B _0
    STA.L DynamicStripeImage,X
    CLC
    ADC.W #$2000
    STA.L DynamicStripeImage+8,X
    XBA
    CLC
    ADC.W #$0020
    XBA
    STA.B _0
    LDA.W #$0300
    STA.L DynamicStripeImage+2,X
    STA.L DynamicStripeImage+$0A,X
    LDA.B [_A],Y
    STA.L DynamicStripeImage+4,X
    INY
    INY
    LDA.B [_A],Y
    STA.L DynamicStripeImage+$0C,X
    INY
    INY
    LDA.B [_A],Y
    STA.L DynamicStripeImage+6,X
    INY
    INY
    LDA.B [_A],Y
    STA.L DynamicStripeImage+$0E,X
    TXA
    CLC
    ADC.W #$0010
    TAX
  + LDA.W StructureCrushTile
    AND.W #$00FF
    CMP.W #$0002
    BPL CODE_04EF38
    ASL A
    ASL A
    ASL A
    TAY
    BRA +

CODE_04EF38:
    LDY.W #$0028
  + JMP CODE_04EDE6

    %insert_empty($340,$342,$342,$342,$342)

DATA_04F280:
    db $00,$D8,$28,$D0,$30,$D8,$28,$00
DATA_04F288:
    db $D0,$D8,$D8,$00,$00,$28,$28,$30

CODE_04F290:
    LDY.W KeyholeYPos+1
    CPY.B #$0C
    BCC +
    STZ.W SwitchPalaceColor
    RTS

  + LDA.W KeyholeXPos+1
    BNE CODE_04F314
    CPY.B #$08
    BCS CODE_04F30C
    LDA.B #!SFX_SWITCHBLOCK
    STA.W SPCIO3                              ; / Play sound effect
    LDA.B #$07
    STA.B _0
    LDX.W KeyholeXPos
  - LDY.W PlayerTurnOW
    LDA.W OWPlayerXPos,Y
    STA.L SwitchAniXPosLow,X
    LDA.W OWPlayerXPos+1,Y
    STA.L SwitchAniXPosHigh,X
    LDA.W OWPlayerYPos,Y
    STA.L SwitchAniYPosLow,X
    LDA.W OWPlayerYPos+1,Y
    STA.L SwitchAniYPosHigh,X
    LDA.B #$00
    STA.L SwitchAniZPosLow,X
    STA.L SwitchAniZPosHigh,X
    LDY.B _0
    LDA.W DATA_04F280,Y
    STA.L SwitchAniXSpeed,X
    LDA.W DATA_04F288,Y
    STA.L SwitchAniYSpeed,X
    LDA.B #$D0
    STA.L SwitchAniZSpeed,X
    INX
    DEC.B _0
    BPL -
    CPX.B #$28
    BCC CODE_04F309
    LDA.W KeyholeYPos
    CLC
    ADC.B #$20
    CMP.B #$A0
    BCC +
    LDA.B #$00
  + STA.W KeyholeYPos
    LDX.B #$00
CODE_04F309:
    STX.W KeyholeXPos
CODE_04F30C:
    LDA.B #$10
    STA.W KeyholeXPos+1
    INC.W KeyholeYPos+1
CODE_04F314:
    DEC.W KeyholeXPos+1
    LDA.W KeyholeYPos
    STA.B _F
    LDX.B #$00
CODE_04F31E:
    PHX
    LDY.B #$00
    JSR CODE_04F39C
    JSR CODE_04F397
    JSR CODE_04F397
    PLX
    LDA.L SwitchAniZSpeed,X
    CLC
    ADC.B #$01
    BMI +
    CMP.B #$40
    BCC +
    LDA.B #$40
  + STA.L SwitchAniZSpeed,X
    LDA.L SwitchAniZPosHigh,X
    XBA
    LDA.L SwitchAniZPosLow,X
    REP #$20                                  ; A->16
    CLC
    ADC.B _2
    STA.B _2
    SEP #$20                                  ; A->8
    XBA
    ORA.B _1
    BNE +
    LDY.B _F
    XBA
    STA.W OAMTileYPos+$140,Y
    LDA.B _0
    STA.W OAMTileXPos+$140,Y
    LDA.B #$E6
    STA.W OAMTileNo+$140,Y
    LDA.W SwitchPalaceColor
    DEC A
    ASL A
    ORA.B #$30
    STA.W OAMTileAttr+$140,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$50,Y
  + LDA.B _F
    CLC
    ADC.B #$04
    CMP.B #$A0
    BCC +
    LDA.B #$00
  + STA.B _F
    INX
    CPX.W KeyholeXPos
    BCC CODE_04F31E
    LDA.W KeyholeYPos+1
    CMP.B #$05
    BCC Return04F396
    CPX.B #$28
    BCC CODE_04F31E
Return04F396:
    RTS

CODE_04F397:
    TXA
    CLC
    ADC.B #$28
    TAX
CODE_04F39C:
    PHY
    LDA.L SwitchAniXSpeed,X
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.L SwitchAniXSpx,X
    STA.L SwitchAniXSpx,X
    LDA.L SwitchAniXSpeed,X
    PHP
    LSR A
    LSR A
    LSR A
    LSR A
    LDY.B #$00
    PLP
    BPL +
    ORA.B #$F0
    DEY
  + ADC.L SwitchAniXPosLow,X
    STA.L SwitchAniXPosLow,X
    XBA
    TYA
    ADC.L SwitchAniXPosHigh,X
    STA.L SwitchAniXPosHigh,X
    XBA
    PLY
    REP #$20                                  ; A->16
    SEC
    SBC.W Layer1XPos,Y
    SEC
    SBC.W #$0008
    STA.W _0,Y
    SEP #$20                                  ; A->8
    INY
    INY
    RTS

CODE_04F3E5:
    DEC A
    JSL ExecutePtr

    dw CODE_04F3FF
    dw CODE_04F415
    dw CODE_04F513
    dw CODE_04F415
    dw CODE_04F3FF
    dw CODE_04F415
    dw CODE_04F3FA
    dw CODE_04F415

CODE_04F3FA:
    JSL ProcSaveMenu
    RTS

CODE_04F3FF:
    LDA.B #!SFX_MESSAGE
    STA.W SPCIO3                              ; / Play sound effect
    INC.W OverworldPromptProcess
CODE_04F407:
    STZ.B Layer12Window
    STZ.B Layer34Window
    STZ.B OBJCWWindow
    STZ.W HDMAEnable
    RTS


DATA_04F411:
    db $04,$FC

DATA_04F413:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    db $48,$00                                ;!
else                                          ;<================ U, SS, E0, & E1 ==============
    db $68,$00                                ;!
endif                                         ;/===============================================

CODE_04F415:
    LDX.B #$00
    LDA.W SavedPlayerLives
    CMP.W SavedPlayerLives+1
    BPL +
    INX
  + STX.W OWPromptArrowDir
    LDX.W MessageBoxExpand
    LDA.W MessageBoxTimer
    CMP.L DATA_04F413,X
    BNE CODE_04F44B
    INC.W OverworldPromptProcess
    LDA.W OverworldPromptProcess
    CMP.B #$07
    BNE +
    LDY.B #$1E
    STY.B StripeImage
  + DEC A
    AND.B #$03
    BNE Return04F44A
    STZ.W OverworldPromptProcess
    STZ.W MessageBoxExpand
    BRA CODE_04F407

Return04F44A:
    RTS

CODE_04F44B:
    CLC
    ADC.L DATA_04F411,X
    STA.W MessageBoxTimer
    CLC
    ADC.B #$80
    XBA
    REP #$10                                  ; XY->16
    LDX.W #con($016E,$016E,$016E,$016E,$018E)
    LDA.B #$FF
  - STA.W WindowTable+$50,X
    STZ.W WindowTable+$51,X
    DEX
    DEX
    BPL -
    SEP #$10                                  ; XY->8
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    LDA.B #$80                                ;! timing difference for size of overworld save box
    SEC                                       ;!
    SBC.W MessageBoxTimer                     ;!
    REP #$20                                  ;! A->16
    LDX.W MessageBoxTimer                     ;!
    LDY.B #$48                                ;!
  - STA.W WindowTable+$C8,Y                   ;!
    STA.W WindowTable+$110,X                  ;!
    DEY                                       ;!
    DEY                                       ;!
    DEX                                       ;!
    DEX                                       ;!
    BPL -                                     ;!
else                                          ;<================= U, SS, E0, & E1 ==============
    LDA.W MessageBoxTimer                     ;!
    LSR A                                     ;!
    ADC.W MessageBoxTimer                     ;!
    LSR A                                     ;!
    AND.B #$FE                                ;!
    TAX                                       ;!
    LDA.B #$80                                ;!
    SEC                                       ;!
    SBC.W MessageBoxTimer                     ;!
    REP #$20                                  ;! A->16
    LDY.B #$48                                ;!
  - STA.W WindowTable+$A8,Y                   ;!
    STA.W WindowTable+$F0,X                   ;!
    DEY                                       ;!
    DEY                                       ;!
    DEX                                       ;!
    DEX                                       ;!
    BPL -                                     ;!
endif                                         ;/===============================================
    STZ.W BackgroundColor
    SEP #$20                                  ; A->8
    LDA.B #$22
    STA.B Layer12Window
    LDA.B #$20
    JMP CODE_04DB95


ClearOWBoxStripe:
if ver_is_japanese(!_VER)                     ;\======================== J ====================
    db $51,$C9,$40,$14,$FC,$38,$52,$08        ;!
    db $40,$1E,$FC,$38,$52,$2F,$40,$02        ;!
    db $FC,$38,$52,$48,$40,$1C,$FC,$38        ;!
    db $FF                                    ;!
else                                          ;<================ U, SS, E0, & E1 ==============
    db $51,$C4,$40,$24,$FC,$38,$52,$04        ;!
    db $40,$2C,$FC,$38,$52,$2F,$40,$02        ;!
    db $FC,$38,$52,$48,$40,$1C,$FC,$38        ;!
    db $FF                                    ;!
endif                                         ;/===============================================

DATA_04F4B2:
    db $52,$49,$00,$09,$16,$28,$0A,$28
    db $1B,$28,$12,$28,$18,$28,$52,$52
    db $00,$09,$15,$28,$1E,$28,$12,$28
    db $10,$28,$12,$28,$52,$0B,$00,$05
    db $26,$28,$00,$28,$00,$28,$52,$14
    db $00,$05,$26,$28,$00,$28,$00,$28
    db $52,$0F,$00,$03,$FC,$38,$FC,$38
    db $52,$2F,$00,$03,$FC,$38,$FC,$38
    db $51,$C9,$00,$03,$85,$29,$85,$69
    db $51,$D2,$00,$03,$85,$29,$85,$69
    db $FF

DATA_04F503:
    db $7D,$38,$7E,$78

DATA_04F507:
    db $7E,$38,$7D,$78

DATA_04F50B:
    db $7D,$B8,$7E,$F8

DATA_04F50F:
    db $7E,$B8,$7D,$F8

CODE_04F513:
    LDA.W byetudlrP1Frame
    ORA.W byetudlrP2Frame
    AND.B #$10
    BEQ +
    LDX.W PlayerTurnLvl
    LDA.W SavedPlayerLives,X
    STA.W PlayerLives
    JSL CloseOverworldPrompt
    RTS

  + LDA.W byetudlrP1Frame
    AND.B #$C0
    BNE CODE_04F53B
    LDA.W byetudlrP2Frame
    AND.B #$C0
    BEQ CODE_04F56C
    EOR.B #$C0
CODE_04F53B:
    LDX.B #$01
    ASL A
    BCS +
    DEX
  + CPX.W OWPromptArrowDir
    BEQ +
    LDA.B #$18
    STA.W OWPromptArrowTimer
  + STX.W OWPromptArrowDir
    TXA
    EOR.B #$01
    TAY
    LDA.W SavedPlayerLives,X
    BEQ CODE_04F56C
    BMI CODE_04F56C
    LDA.W SavedPlayerLives,Y
    CMP.B #$62
    BPL CODE_04F56C
    INC A
    STA.W SavedPlayerLives,Y
    DEC.W SavedPlayerLives,X
    LDA.B #!SFX_BEEP
    STA.W SPCIO3                              ; / Play sound effect
CODE_04F56C:
    REP #$20                                  ; A->16
    LDA.W #$7848
    STA.W OAMTileXPos+$9C
    LDA.W #$7890
    STA.W OAMTileXPos+$A0
    LDA.W #$340A
    STA.W OAMTileNo+$9C
    LDA.W #$360A
    STA.W OAMTileNo+$A0
    SEP #$20                                  ; A->8
    LDA.B #$02
    STA.W OAMTileSize+$27
    STA.W OAMTileSize+$28
    JSL CODE_05DBF2
    LDY.B #$50
    TYA
    CLC
    ADC.L DynStripeImgSize
    STA.L DynStripeImgSize
    TAX
  - LDA.W DATA_04F4B2,Y
    STA.L DynamicStripeImage,X
    DEX
    DEY
    BPL -
    INX
    REP #$20                                  ; A->16
    LDY.W SavedPlayerLives
    BMI +
    LDA.W #$38FC
    STA.L DynamicStripeImage+$44,X
    STA.L DynamicStripeImage+$46,X
  + LDY.W SavedPlayerLives+1
    BMI +
    LDA.W #$38FC
    STA.L DynamicStripeImage+$4C,X
    STA.L DynamicStripeImage+$4E,X
  + SEP #$20                                  ; A->8
    INC.W OWPromptArrowTimer
    LDA.W OWPromptArrowTimer
    AND.B #$18
    BEQ +
    LDA.W OWPromptArrowDir
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.W DATA_04F503,Y
    STA.L DynamicStripeImage+$34,X
    LDA.W DATA_04F507,Y
    STA.L DynamicStripeImage+$36,X
    LDA.W DATA_04F50B,Y
    STA.L DynamicStripeImage+$3C,X
    LDA.W DATA_04F50F,Y
    STA.L DynamicStripeImage+$3E,X
    SEP #$20                                  ; A->8
  + LDA.W SavedPlayerLives
    JSR CODE_04F60E
    TXA
    CLC
    ADC.B #$0A
    TAX
    LDA.W SavedPlayerLives+1
CODE_04F60E:
    INC A
    PHX
    JSL HexToDecLong
    TXY
    BNE +
    LDX.B #$FC
  + TXY
    PLX
    STA.L DynamicStripeImage+$24,X
    TYA
    STA.L DynamicStripeImage+$22,X
    RTS


OverworldSprites:
    db $00 : dw $0100,$00E0
    db $00 : dw $0100,$0060
    db $06 : dw $0170,$0020
    db $07 : dw $0038,$018A
    db $00 : dw $0058,$007A
    db $08 : dw $0188,$0018
    db $09 : dw $0148,$FFFC
    db $00 : dw $0080,$0100
    db $00 : dw $0050,$0140
    db $03 : dw $0000,$0000
    db $0A : dw $0040,$0098
    db $0A : dw $0060,$00F8
    db $0A : dw $0140,$0158

ExtraOWGhostXPos:
    dw $0030,$0100,$FF10
ExtraOWGhostYPos:
    dw $0020,$FF70,$0010

DATA_04F672:
    db $01,$40,$80

CODE_04F675:
    PHB
    PHK
    PLB
    LDX.B #$0C
    LDY.B #$4B
CODE_04F67C:
    LDA.W OverworldSprites-$0F,Y
    STA.W OWSpriteNumber+3,X
    CMP.B #$01
    BEQ ADDR_04F68A
    CMP.B #$02
    BNE +
ADDR_04F68A:
    LDA.B #$40
    STA.W OWSpriteZPosLow+3,X
  + LDA.W OverworldSprites-$0E,Y
    STA.W OWSpriteXPosLow+3,X
    LDA.W OverworldSprites-$0D,Y
    STA.W OWSpriteXPosHigh+3,X
    LDA.W OverworldSprites-$0C,Y
    STA.W OWSpriteYPosLow+3,X
    LDA.W OverworldSprites-$0B,Y
    STA.W OWSpriteYPosHigh+3,X
    TYA
    SEC
    SBC.B #$05
    TAY
    DEX
    BPL CODE_04F67C
    LDX.B #$0D
CODE_04F6B1:
    STZ.W OWSpriteMisc0E25,X
    LDA.W DATA_04FD22
    DEC A
    STA.W OWSpriteZSpeed,X
    LDA.W DATA_04F672-$0D,X
  - PHA
    STX.W SaveFileDelete
    JSR CODE_04F853
    PLA
    DEC A
    BNE -
    INX
    CPX.B #$10
    BCC CODE_04F6B1
    PLB
    RTL


DATA_04F6D0:
    db $70,$7F,$78,$7F,$70,$7F,$78,$7F
DATA_04F6D8:
    db $F0,$FF,$20,$00,$C0,$00,$F0,$FF
    db $F0,$FF,$80,$00,$F0,$FF,$00,$00
DATA_04F6E8:
    db $70,$00,$60,$01,$58,$01,$B0,$00
    db $60,$01,$60,$01,$70,$00,$60,$01
DATA_04F6F8:
    db $20,$58,$43,$CF,$18,$34,$A2,$5E
DATA_04F700:
    db $07,$05,$06,$07,$04,$06,$07,$05

CODE_04F708:
    LDA.B #$F7
    JSR CODE_04F882
    BNE CODE_04F76E
    LDY.W LightningFlashIndex
    BNE CODE_04F73B
    LDA.B TrueFrame
    LSR A
    BCC CODE_04F76E
    DEC.W LightningWaitTimer
    BNE CODE_04F76E
    TAY
    LDA.W CODE_04F708,Y
    AND.B #$07
    TAX
    LDA.W DATA_04F6F8,X
    STA.W LightningWaitTimer
    LDY.W DATA_04F700,X
    STY.W LightningFlashIndex
    LDA.B #$08
    STA.W LightningTimer
    LDA.B #!SFX_THUNDER
    STA.W SPCIO3                              ; / Play sound effect
CODE_04F73B:
    DEC.W LightningTimer
    BPL +
    DEC.W LightningFlashIndex
    LDA.B #$04
    STA.W LightningTimer
  + TYA
    ASL A
    TAY
    LDX.W DynPaletteIndex
    LDA.B #$02
    STA.W DynPaletteTable,X
    LDA.B #$47
    STA.W DynPaletteTable+1,X
    LDA.W MainPalette+$50,Y
    STA.W DynPaletteTable+2,X
    LDA.W MainPalette+$51,Y
    STA.W DynPaletteTable+3,X
    STZ.W DynPaletteTable+4,X
    TXA
    CLC
    ADC.B #$04
    STA.W DynPaletteIndex
CODE_04F76E:
    LDX.B #$02
CODE_04F770:
    LDA.W OWSpriteNumber,X
    BNE +
    LDA.B #$05
    STA.W OWSpriteNumber,X
    JSR CODE_04FE5B
    AND.B #$07
    TAY
    LDA.W DATA_04F6D0,Y
    STA.W OWSpriteZPosLow,X
    TYA
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.B Layer1XPos
    CLC
    ADC.W DATA_04F6D8,Y
    SEP #$20                                  ; A->8
    STA.W OWSpriteXPosLow,X
    XBA
    STA.W OWSpriteXPosHigh,X
    REP #$20                                  ; A->16
    LDA.B Layer1YPos
    CLC
    ADC.W DATA_04F6E8,Y
    SEP #$20                                  ; A->8
    STA.W OWSpriteYPosLow,X
    XBA
    STA.W OWSpriteYPosHigh,X
  + DEX
    BPL CODE_04F770
    LDX.B #$04
  - TXA
    STA.W OWCloudYSpeed,X
    DEX
    BPL -
    LDX.B #$04
CODE_04F7B9:
    STX.B _0
CODE_04F7BB:
    STX.B _1
    LDX.B _0
    LDY.W OWCloudYSpeed,X
    LDA.W OWSpriteYPosLow,Y
    STA.B _2
    LDA.W OWSpriteYPosHigh,Y
    STA.B _3
    LDX.B _1
    LDY.W OWCloudOAMIndex,X
    LDA.W OWSpriteYPosHigh,Y
    XBA
    LDA.W OWSpriteYPosLow,Y
    REP #$20                                  ; A->16
    CMP.B _2
    SEP #$20                                  ; A->8
    BPL +
    PHY
    LDY.B _0
    LDA.W OWCloudYSpeed,Y
    STA.W OWCloudOAMIndex,X
    PLA
    STA.W OWCloudYSpeed,Y
  + DEX
    BNE CODE_04F7BB
    LDX.B _0
    DEX
    BNE CODE_04F7B9
    LDA.B #$30
    STA.W OWCloudOAMIndex
    STZ.W EnterLevelAuto
    LDX.B #$0F
    LDY.B #$2D
CODE_04F801:
    CPX.B #$0D
    BCS +
    LDA.W OWSpriteMisc0E25,X
    BEQ +
    DEC.W OWSpriteMisc0E25,X
  + CPX.B #$05
    BCC CODE_04F819
    STX.W SaveFileDelete
    JSR CODE_04F853
    BRA +

CODE_04F819:
    PHX
    LDA.W OWCloudYSpeed,X
    TAX
    STX.W SaveFileDelete
    JSR CODE_04F853
    PLX
  + DEX
    BPL CODE_04F801
Return04F828:
    RTS


    db $7F,$21,$7F,$7F,$7F,$77,$3F,$F7
    db $F7,$00

DATA_04F833:
    db $00,$52,$31,$19,$45,$2A,$03,$8B
    db $94,$3C,$78,$0D,$36,$5E,$87,$1F
DATA_04F843:
    db $F4,$F4,$F4,$F4,$F4,$9C,$3C,$48
    db $C8,$CC,$A0,$A4,$D8,$DC,$E0,$E4

CODE_04F853:
    JSR CODE_04F87C
    BNE Return04F828
    LDA.W OWSpriteNumber,X
    JSL ExecutePtr

    dw Return04F828
    dw ADDR_04F8CC
    dw ADDR_04F9B8
    dw CODE_04FA3E
    dw ADDR_04FAF1
    dw CODE_04FB37
    dw CODE_04FB98
    dw CODE_04FC46
    dw CODE_04FCE1
    dw CODE_04FD24
    dw CODE_04FD70

DATA_04F875:
    db $80,$40,$20,$10,$08,$04,$02

CODE_04F87C:
    LDY.W OWSpriteNumber,X
    LDA.W Return04F828,Y
CODE_04F882:
    STA.B _0
    LDY.W OverworldProcess
    CPY.B #$0A
    BNE CODE_04F892
    LDY.W OWSubmapSwapProcess
    CPY.B #$01
    BNE CODE_04F8A3
CODE_04F892:
    LDA.W PlayerTurnOW
    LSR A
    LSR A
    TAY
    LDA.W OWPlayerSubmap,Y
    TAY
    LDA.W DATA_04F875,Y
    AND.B _0
    BEQ +
CODE_04F8A3:
    LDA.B #$01
  + RTS


DATA_04F8A6:
    db $01,$01,$03,$01,$01,$01,$01,$02
DATA_04F8AE:
    db $0C,$0C,$12,$12,$12,$12,$0C,$0C
DATA_04F8B6:
    db $10,$00,$08,$00,$20,$00,$20,$00
DATA_04F8BE:
    db $10,$00,$30,$00,$08,$00,$10,$00
DATA_04F8C6:
    db $01,$FF

DATA_04F8C8:
    db $10,$F0

DATA_04F8CA:
    db $10,$F0

ADDR_04F8CC:
    JSR CODE_04FE90
    CLC
    JSR ADDR_04FE00
    JSR CODE_04FE62
    REP #$20                                  ; A->16
    LDA.B _2
    STA.B _4
    SEP #$20                                  ; A->8
    JSR CODE_04FE5B
    LDX.B #$06
    AND.B #$10
    BEQ ADDR_04F8E8
    INX
ADDR_04F8E8:
    STX.B _6
    LDA.B _0
    CLC
    ADC.W DATA_04F8A6,X
    STA.B _0
    BCC +
    INC.B _1
  + LDA.B _4
    CLC
    ADC.W DATA_04F8AE,X
    STA.B _2
    LDA.B _5
    ADC.B #$00
    STA.B _3
    LDA.B #$32
    XBA
    LDA.B #$28
    JSR CODE_04FB7B
    LDX.B _6
    DEX
    DEX
    BPL ADDR_04F8E8
    LDX.W SaveFileDelete
    JSR CODE_04FE62
    LDA.B #$32
    XBA
    LDA.B #$26
    JSR CODE_04FB7A
    LDA.W OWSpriteMisc0E15,X
    BEQ +
    JMP ADDR_04FF2E

  + LDA.W OWSpriteMisc0E05,X
    AND.B #$01
    TAY
    LDA.W OWSpriteZSpeed,X
    CLC
    ADC.W DATA_04F8C6,Y
    STA.W OWSpriteZSpeed,X
    CMP.W DATA_04F8CA,Y
    BNE +
    LDA.W OWSpriteMisc0E05,X
    EOR.B #$01
    STA.W OWSpriteMisc0E05,X
  + JSR ADDR_04FEEF
    LDY.W OWSpriteMisc0DF5,X
    LDA.W OWSpriteMisc0E05-1,X
    ASL A
    EOR.B _0
    BPL ADDR_04F95D
    LDA.B _6
    CMP.W DATA_04F8B6,Y
    LDA.W #$0040
    BCS +
ADDR_04F95D:
    LDA.W OWSpriteMisc0E05-1,X
    EOR.B _2
    ASL A
    BCC +
    LDA.B _8
    CMP.W DATA_04F8BE,Y
    LDA.W #$0080
  + SEP #$20                                  ; A->8
    BCC +
    EOR.W OWSpriteMisc0E05,X
    STA.W OWSpriteMisc0E05,X
    JSR CODE_04FE5B
    AND.B #$06
    STA.W OWSpriteMisc0DF5,X
  + TXA
    CLC
    ADC.B #$10
    TAX
    LDA.W OWSpriteMisc0DF5,X
    ASL A
    JSR ADDR_04F993
    LDX.W SaveFileDelete
    LDA.W OWSpriteMisc0E05,X
    ASL A
    ASL A
ADDR_04F993:
    LDY.B #$00
    BCS +
    INY
  + LDA.W OWSpriteXSpeed,X
    CLC
    ADC.W DATA_04F8C6,Y
    CMP.W DATA_04F8C8,Y
    BEQ +
    STA.W OWSpriteXSpeed,X
  + RTS


DATA_04F9A8:
    db $4E,$4F,$5E,$4F

DATA_04F9AC:
    db $08,$07,$04,$07

DATA_04F9B0:
    db $00,$01,$04,$01

DATA_04F9B4:
    db $01,$07,$09,$07

ADDR_04F9B8:
    CLC
    JSR ADDR_04FE00
    JSR ADDR_04FEEF
    SEP #$20                                  ; A->8
    LDY.B #$00
    LDA.B _1
    BMI +
    INY
  + LDA.W OWSpriteXSpeed,X
    CLC
    ADC.W DATA_04F8C6,Y
    CMP.W DATA_04F8C8,Y
    BEQ +
    STA.W OWSpriteXSpeed,X
  + LDY.W PlayerTurnOW
    LDA.W OWPlayerYPos,Y
    STA.W OWSpriteYPosLow,X
    LDA.W OWPlayerYPos+1,Y
    STA.W OWSpriteYPosHigh,X
    JSR CODE_04FE90
    JSR CODE_04FE62
    LDA.B #$36
    LDY.W OWSpriteXSpeed,X
    BMI +
    ORA.B #$40
  + PHA
    XBA
    LDA.B #$4C
    JSR CODE_04FB7A
    PLA
    XBA
    JSR CODE_04FE5B
    LSR A
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W DATA_04F9AC,Y
    BIT.W OWSpriteXSpeed,X
    BMI +
    LDA.W DATA_04F9B0,Y
  + CLC
    ADC.B _0
    STA.B _0
    BCC +
    INC.B _1
  + LDA.W DATA_04F9B4,Y
    CLC
    ADC.B _2
    STA.B _2
    BCC +
    INC.B _3
  + LDA.W DATA_04F9A8,Y
    CLC
    JMP CODE_04FB7B


DATA_04FA2E:
    db $70,$50,$B0

DATA_04FA31:
    db $00,$01,$00

DATA_04FA34:
    db $CF,$8F,$7F

DATA_04FA37:
    db $00,$00,$01

DATA_04FA3A:
    db $73,$72,$63,$62

CODE_04FA3E:
    LDA.W OWSpriteMisc0DF5,X
    BNE CODE_04FA83
    LDA.W OverworldLayer1Tile
    SEC
    SBC.B #$4E
    CMP.B #$03
    BCS Return04FA82
    TAY
    LDA.W DATA_04FA2E,Y
    STA.W OWSpriteXPosLow,X
    LDA.W DATA_04FA31,Y
    STA.W OWSpriteXPosHigh,X
    LDA.W DATA_04FA34,Y
    STA.W OWSpriteYPosLow,X
    LDA.W DATA_04FA37,Y
    STA.W OWSpriteYPosHigh,X
    JSR CODE_04FE5B
    LSR A
    ROR A
    LSR A
    AND.B #$40
    ORA.B #$12
    STA.W OWSpriteMisc0DF5,X
    LDA.B #$24
    STA.W OWSpriteZSpeed,X
    LDA.B #!SFX_SWIM
    STA.W SPCIO0                              ; / Play sound effect
CODE_04FA7D:
    LDA.B #$0F
    STA.W OWSpriteMisc0E25,X
Return04FA82:
    RTS

CODE_04FA83:
    DEC.W OWSpriteZSpeed,X
    LDA.W OWSpriteZSpeed,X
    CMP.B #$E4
    BNE +
    JSR CODE_04FA7D
  + JSR CODE_04FE90
    LDA.W OWSpriteZPosLow,X
    ORA.W OWSpriteMisc0E25,X
    BNE +
    STZ.W OWSpriteMisc0DF5,X
  + JSR CODE_04FE62
    LDA.W OWSpriteMisc0DF5,X
    LDY.B #$08
    BIT.W OWSpriteZSpeed,X
    BPL +
    EOR.B #$C0
    LDY.B #$10
  + XBA
    TYA
    LDY.B #$4A
    AND.B TrueFrame
    BEQ +
    LDY.B #$48
  + TYA
    JSR CODE_04FB06
    JSR CODE_04FE4E
    SEC
    SBC.B #$08
    STA.B _2
    BCS +
    DEC.B _3
  + LDA.B #$36
    XBA
    LDA.W OWSpriteMisc0E25,X
    BEQ Return04FA82
    LSR A
    LSR A
    PHY
    TAY
    LDA.W DATA_04FA3A,Y
    PLY
    PHA
    JSR CODE_04FAED
    REP #$20                                  ; A->16
    LDA.B _0
    CLC
    ADC.W #$0008
    STA.B _0
    SEP #$20                                  ; A->8
    LDA.B #$76
    XBA
    PLA
CODE_04FAED:
    CLC
    JMP CODE_04FB0A

ADDR_04FAF1:
    JSR ADDR_04FED7
    JSR CODE_04FE62                           ; NOP this and the sprite doesn't appear
    JSR CODE_04FE5B                           ; NOP this and the sprite stops animating.
    LDY.B #$2A                                ;Tile for pirahna plant, #1
    AND.B #$08
    BEQ +
    LDY.B #$2C                                ; Tile for pirahna plant, #2, stored in $0242
  + LDA.B #$32                                ; YXPPCCCT - 00110010
    XBA
    TYA
CODE_04FB06:
    SEC
    LDY.W DATA_04F843,X
CODE_04FB0A:
    STA.W OAMTileNo+$40,Y                     ;Tilemap
    XBA
    STA.W OAMTileAttr+$40,Y                   ;Property
    LDA.B _1
    BNE +
    LDA.B _0
    STA.W OAMTileXPos+$40,Y                   ;X Position
    LDA.B _3
    BNE +
    PHP
    LDA.B _2
    STA.W OAMTileYPos+$40,Y                   ;Y Position
    TYA
    LSR A
    LSR A
    PLP
    PHY
    TAY
    ROL A
    ASL A
    AND.B #$03
    STA.W OAMTileSize+$10,Y
    PLY
    DEY
    DEY
    DEY
    DEY
  + RTS

CODE_04FB37:
    LDA.B #$02                                ;\Overworld Sprite X Speed
    STA.W OWSpriteXSpeed,X                    ;/
    LDA.B #$FF                                ;\Overworld Sprite Y Speed
    STA.W OWSpriteYSpeed,X                    ;/
    JSR CODE_04FE90                           ;Move the overworld cloud
    JSR CODE_04FE62
    REP #$20                                  ; A->16
    LDA.B _0
    CLC
    ADC.W #$0020
    CMP.W #$0140
    BCS +
    LDA.B _2
    CLC
    ADC.W #$0080
    CMP.W #$01A0
  + SEP #$20                                  ; A->8
    BCC +
    STZ.W OWSpriteNumber,X
  + LDA.B #$32
    JSR CODE_04FB77
    REP #$20                                  ; A->16
    LDA.B _0
    CLC
    ADC.W #$0010
    STA.B _0
    SEP #$20                                  ; A->8
    LDA.B #$72
CODE_04FB77:
    XBA
    LDA.B #$44
CODE_04FB7A:
    SEC
CODE_04FB7B:
    LDY.W OWCloudOAMIndex
    JSR CODE_04FB0A
    STY.W OWCloudOAMIndex
Return04FB84:
    RTS


DATA_04FB85:
    db $80,$40,$20

DATA_04FB88:
    db $30,$10,$C0

DATA_04FB8B:
    db $01,$01,$01

DATA_04FB8E:
    db $7F,$7F,$8F

DATA_04FB91:
    db $01,$00

DATA_04FB93:
    db $01,$08

DATA_04FB95:
    db $02,$0F,$00

CODE_04FB98:
    LDA.W OWSpriteMisc0DF5,X
    BNE ADDR_04FBD8
    LDA.W OverworldLayer1Tile
    SEC
    SBC.B #$49
    CMP.B #$03
    BCS Return04FB84
    TAY
    STA.W KoopaKidTile
    LDA.W KoopaKidActive
    AND.W DATA_04FB85,Y
    BNE Return04FB84
    LDA.W DATA_04FB88,Y
    STA.W OWSpriteXPosLow,X
    LDA.W DATA_04FB8B,Y
    STA.W OWSpriteXPosHigh,X
    LDA.W DATA_04FB8E,Y
    STA.W OWSpriteYPosLow,X
    LDA.W DATA_04FB91,Y
    STA.W OWSpriteYPosHigh,X
    LDA.B #$02
    STA.W OWSpriteMisc0DF5,X
    LDA.B #$F0
    STA.W OWSpriteXSpeed,X
    STZ.W OWSpriteMisc0E25,X
ADDR_04FBD8:
    JSR CODE_04FE62
    LDA.W OWSpriteMisc0E25,X
    BNE +
    INC.W OWSpriteMisc0E05,X
    JSR CODE_04FEAB
    LDY.W OWSpriteMisc0DF5,X
    LDA.W OWSpriteXPosLow,X
    AND.B #$0F
    CMP.W DATA_04FB95,Y
    BNE +
    DEC.W OWSpriteMisc0DF5,X
    LDA.B #$04
    STA.W OWSpriteXSpeed,X
    LDA.B #$60
    STA.W OWSpriteMisc0E25,X
  + LDA.W DATA_04FB93,Y
    LDY.B #$22
    AND.W OWSpriteMisc0E05,X
    BNE +
    LDY.B #$62
  + TYA
    XBA
    LDA.B #$6A
    JSR CODE_04FB06
    JSR ADDR_04FED7
    BCS +
    ORA.B #$80
    STA.W EnterLevelAuto
  + RTS


DATA_04FC1E:
    db $38

DATA_04FC1F:
    db $00,$68,$00

DATA_04FC22:
    db $8A

DATA_04FC23:
    db $01,$6A,$00

DATA_04FC26:
    db $01,$02,$03,$04,$03,$02,$01,$00
    db $01,$02,$03,$04,$03,$02,$01,$00
DATA_04FC36:
    db $FF,$FF,$FE,$FD,$FD,$FC,$FB,$FB
    db $FA,$F9,$F9,$F8,$F7,$F7,$F6,$F5

CODE_04FC46:
    LDA.W PlayerTurnOW
    LSR A
    LSR A
    TAY
    LDA.W OWPlayerSubmap,Y
    ASL A
    TAY
    LDA.W DATA_04FC1E,Y
    STA.W OWSpriteXPosLow,X
    LDA.W DATA_04FC1F,Y
    STA.W OWSpriteXPosHigh,X
    LDA.W DATA_04FC22,Y
    STA.W OWSpriteYPosLow,X
    LDA.W DATA_04FC23,Y
    STA.W OWSpriteYPosHigh,X
    LDA.B TrueFrame
    AND.B #$0F
    BNE CODE_04FC7C
    LDA.W OWSpriteMisc0DF5,X
    INC A
    CMP.B #$0C
    BCC +
    LDA.B #$00
  + STA.W OWSpriteMisc0DF5,X
CODE_04FC7C:
    LDA.B #$03
    STA.B _4
    LDA.B TrueFrame
    STA.B _6
    STZ.B _7
    LDY.W DATA_04F843,X
    LDA.W OWSpriteMisc0DF5,X
    TAX
CODE_04FC8D:
    PHY
    PHX
    LDX.W SaveFileDelete
    JSR CODE_04FE62
    PLX
    LDA.B _7
    CLC
    ADC.W DATA_04FC36,X
    CLC
    ADC.B _2
    STA.B _2
    BCS +
    DEC.B _3
  + LDA.B _0
    CLC
    ADC.W DATA_04FC26,X
    STA.B _0
    BCC +
    INC.B _1
  + TXA
    CLC
    ADC.B #$0C
    CMP.B #$10
    AND.B #$0F
    TAX
    BCC +
    LDA.B _7
    SBC.B #$0C
    STA.B _7
  + LDA.B #$30
    XBA
    LDY.B #$28
    LDA.B _6
    CLC
    ADC.B #$0A
    STA.B _6
    AND.B #$20
    BEQ +
    LDY.B #$5F
  + TYA
    PLY
    JSR CODE_04FAED
    DEC.B _4
    BNE CODE_04FC8D
    LDX.W SaveFileDelete
    RTS


                                              ;Bowser's sign code starts here.
CODE_04FCE1:
    JSR CODE_04FE62
    LDA.B #$04                                ;\How many tiles to show up for Bowser's sign
    STA.B _4                                  ;/
    LDA.B #$6F
    STA.B _5
    LDY.W DATA_04F843,X
  - LDA.B TrueFrame
    LSR A
    AND.B #$06
    ORA.B #$30
    XBA
    LDA.B _5
    JSR CODE_04FAED                           ;Jump to CLC, then the OAM part of the Pirahna Plant code.
    LDA.B _0
    SEC
    SBC.B #$08
    STA.B _0
    DEC.B _5
    DEC.B _4
    BNE -
    RTS


DATA_04FD0A:
    db $07,$07,$03,$03,$5F,$5F

DATA_04FD10:
    db $01,$FF,$01,$FF,$01,$FF,$01,$FF
    db $01,$FF

DATA_04FD1A:
    db $18,$E8,$0A,$F6,$08,$F8,$03,$FD
DATA_04FD22:
    db $01,$FF

CODE_04FD24:
    JSR CODE_04FE90
    JSR CODE_04FE62
    JSR CODE_04FE62
    LDA.B #$00
    LDY.W OWSpriteXSpeed,X
    BMI +
    LDA.B #$40
  + XBA
    LDA.B #$68
    JSR CODE_04FB06
    INC.W OWSpriteMisc0E15,X
    LDA.W OWSpriteMisc0E15,X
    LSR A
    BCS Return04FD6F
    LDA.W OWSpriteMisc0E05,X
    ORA.B #$02
    TAY
    TXA
    ADC.B #$10
    TAX
    JSR CODE_04FD55
    LDY.W OWSpriteMisc0DF5,X
CODE_04FD55:
    LDA.W OWSpriteXSpeed,X
    CLC
    ADC.W DATA_04FD10,Y
    STA.W OWSpriteXSpeed,X
    CMP.W DATA_04FD1A,Y
    BNE CODE_04FD68
    TYA
    EOR.B #$01
    TAY
CODE_04FD68:
    TYA
    STA.W OWSpriteMisc0DF5,X
    LDX.W SaveFileDelete
Return04FD6F:
    RTS

CODE_04FD70:
    JSR CODE_04FE90
    JSR CODE_04FE62
    JSR CODE_04FE62
    LDY.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,Y
    BEQ CODE_04FDA5
    CPX.B #$0F
    BNE +
    LDA.W OWEventsActivated+5
    AND.B #$12
    BNE +
    STX.B _3
  + TXA
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.B _0
    CLC
    ADC.W ExtraOWGhostXPos-$1A,Y
    STA.B _0
    LDA.B _2
    CLC
    ADC.W ExtraOWGhostYPos-$1A,Y
    STA.B _2
    SEP #$20                                  ; A->8
CODE_04FDA5:
    LDA.B #$34
    LDY.W OWSpriteXSpeed,X
    BMI +
    LDA.B #$44
  + XBA
    LDA.B #$60
    JSR CODE_04FB06
    LDA.W OWSpriteMisc0E25,X
    STA.B _0
    INC.W OWSpriteMisc0E25,X
    TXA
    CLC
    ADC.B #$20
    TAX
    LDA.B #$08
    JSR CODE_04FDD2
    TXA
    CLC
    ADC.B #$10
    TAX
    LDA.B #$06
    JSR CODE_04FDD2
    LDA.B #$04
CODE_04FDD2:
    ORA.W OWSpriteMisc0DF5,X
    TAY
    LDA.W DATA_04FD0A-4,Y
    AND.B _0
    BNE CODE_04FD68
    JMP CODE_04FD55


DATA_04FDE0:
    db $00,$00,$00,$00,$01,$02,$02,$02
    db $00,$00,$01,$01,$02,$02,$03,$03
DATA_04FDF0:
    db $08,$08,$08,$08,$07,$06,$05,$05
    db $00,$00,$0E,$0E,$0C,$0C,$0A,$0A

ADDR_04FE00:
    ROR.B _4
    JSR CODE_04FE62
    JSR CODE_04FE4E
    LDA.W OWSpriteZPosLow,X
    LSR A
    LSR A
    LSR A
    LSR A
    LDY.B #$29
    BIT.B _4
    BPL +
    LDY.B #$2E
    CLC
    ADC.B #$08
  + STY.B _5
    TAY
    STY.B _6
    LDA.B _0
    CLC
    ADC.W DATA_04FDE0,Y
    STA.B _0
    BCC +
    INC.B _1
  + LDA.B #$32
    LDY.W DATA_04F843,X
    JSR ADDR_04FE45
    PHY
    LDY.B _6
    LDA.B _0
    CLC
    ADC.W DATA_04FDF0,Y
    STA.B _0
    BCC +
    INC.B _1
  + LDA.B #$72
    PLY
ADDR_04FE45:
    XBA
    LDA.B _4
    ASL A
    LDA.B _5
    JMP CODE_04FB0A

CODE_04FE4E:
    LDA.B _2
    CLC
    ADC.W OWSpriteZPosLow,X
    STA.B _2
    BCC +
    INC.B _3
  + RTS

CODE_04FE5B:
    LDA.B TrueFrame
    CLC
    ADC.W DATA_04F833,X
    RTS

CODE_04FE62:
    TXA
    CLC
    ADC.B #$10
    TAX
    LDY.B #$02
    JSR CODE_04FE7D
    LDX.W SaveFileDelete
    LDA.B _2
    SEC
    SBC.W OWSpriteZPosLow,X
    STA.B _2
    BCS +
    DEC.B _3
  + LDY.B #$00
CODE_04FE7D:
    LDA.W OWSpriteXPosHigh,X
    XBA
    LDA.W OWSpriteXPosLow,X
    REP #$20                                  ; A->16
    SEC
    SBC.W Layer1XPos,Y
    STA.W _0,Y
    SEP #$20                                  ; A->8
    RTS

CODE_04FE90:
    TXA                                       ;Transfer X to A
    CLC                                       ;Clear Carry Flag
    ADC.B #$20                                ;Add #$20 to A
    TAX                                       ;Transfer A to X
    JSR CODE_04FEAB
    LDA.W OWSpriteXPosLow,X                   ;Load OW Sprite XPos Low
    BPL +                                     ;If it is => 80
    STZ.W OWSpriteXPosLow,X                   ;Store 00 OW Sprite Xpos Low
  + TXA                                       ;Transfer X to A
    SEC                                       ;Set Carry Flag...
    SBC.B #$10                                ;...for substraction
    TAX                                       ;Transfer A to X
    JSR CODE_04FEAB
    LDX.W SaveFileDelete
CODE_04FEAB:
    LDA.W OWSpriteXSpeed,X                    ;Load OW Sprite X Speed
    ASL A                                     ;Multiply it by 2
    ASL A                                     ;4...
    ASL A                                     ;8...
    ASL A                                     ;16...
    CLC                                       ;Clear Carry Flag
    ADC.W OWSpriteXPosSpx,X
    STA.W OWSpriteXPosSpx,X                   ;And store it in
    LDA.W OWSpriteXSpeed,X                    ;Load OW Sprite X Speed
    PHP
    LSR A                                     ;Divide by 2
    LSR A                                     ;4
    LSR A                                     ;8
    LSR A                                     ;16
    LDY.B #$00                                ;Load $00 in Y
    PLP
    BPL +
    ORA.B #$F0
    DEY
  + ADC.W OWSpriteXPosLow,X
    STA.W OWSpriteXPosLow,X
    TYA
    ADC.W OWSpriteXPosHigh,X
    STA.W OWSpriteXPosHigh,X
    RTS

ADDR_04FED7:
    JSR ADDR_04FEEF
    LDA.B _6
    CMP.W #$0008
    BCS +
    LDA.B _8
    CMP.W #$0008
  + SEP #$20                                  ; A->8
    TXA
    BCS +
    STA.W EnterLevelAuto
  + RTS

ADDR_04FEEF:
    LDA.W OWSpriteXPosHigh,X
    XBA
    LDA.W OWSpriteXPosLow,X
    REP #$20                                  ; A->16
    CLC
    ADC.W #$0008
    LDY.W PlayerTurnOW
    SEC
    SBC.W OWPlayerXPos,Y
    STA.B _0
    BPL +
    EOR.W #$FFFF
    INC A
  + STA.B _6
    SEP #$20                                  ; A->8
    LDA.W OWSpriteYPosHigh,X
    XBA
    LDA.W OWSpriteYPosLow,X
    REP #$20                                  ; A->16
    CLC
    ADC.W #$0008
    LDY.W PlayerTurnOW
    SEC
    SBC.W OWPlayerYPos,Y
    STA.B _2
    BPL +
    EOR.W #$FFFF
    INC A
  + STA.B _8
    RTS

ADDR_04FF2E:
    JSR ADDR_04FEEF
    LSR.B _6
    LSR.B _8
    SEP #$20                                  ; A->8
    LDA.W OWSpriteZPosLow,X
    LSR A
    STA.B _A
    STZ.B _5
    LDY.B #$04
    CMP.B _8
    BCS +
    LDY.B #$02
    LDA.B _8
  + CMP.B _6
    BCS +
    LDY.B #$00
    LDA.B _6
  + CMP.B #$01
    BCS +
    STZ.W OWSpriteMisc0E15,X
    STZ.W OWSpriteXSpeed,X
    STZ.W OWSpriteYSpeed,X
    STZ.W OWSpriteZSpeed,X
    LDA.B #$40
    STA.W OWSpriteZPosLow,X
    RTS

  + STY.B _C
    LDX.B #$04
ADDR_04FF6B:
    CPX.B _C
    BNE ADDR_04FF73
    LDA.B #$20
    BRA +

ADDR_04FF73:
    STZ.W HW_WRDIV
    LDA.B _6,X
    STA.W HW_WRDIV+1
    LDA.W _6,Y
    STA.W HW_WRDIV+2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    REP #$20                                  ; A->16
    LDA.W HW_RDDIV
    LSR A
    LSR A
    LSR A
    SEP #$20                                  ; A->8
  + BIT.B _1,X
    BMI +
    EOR.B #$FF
    INC A
  + STA.B _0,X
    DEX
    DEX
    BPL ADDR_04FF6B
    LDX.W SaveFileDelete
    LDA.B _0
    STA.W OWSpriteXSpeed,X
    LDA.B _2
    STA.W OWSpriteYSpeed,X
    LDA.B _4
    STA.W OWSpriteZSpeed,X
    RTS

    %insert_empty($57,$4F,$4F,$4F,$4F)