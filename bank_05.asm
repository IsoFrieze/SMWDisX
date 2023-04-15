    ORG $058000

TilesetMAP16Loc:
    dw Map16Tileset0                          ; Addresses to tileset-specific MAP16 data
    dw Map16Tileset1
    dw Map16Tileset2
    dw Map16Tileset3
    dw Map16Tileset4
    dw Map16Tileset4
    dw Map16Tileset2
    dw Map16Tileset0
    dw Map16Tileset2
    dw Map16Tileset3
    dw Map16Tileset3
    dw Map16Tileset3
    dw Map16Tileset0
    dw Map16Tileset4
    dw Map16Tileset3

CODE_05801E:
    PHP
    SEP #$20                                  ; A->8
    REP #$10                                  ; XY->16
    LDX.W #$0000                              ; \
  - LDA.B #$25                                ; |
    STA.L Layer2TilemapLow,X                  ; |Set all background tiles (lower bytes) to x25
    STA.L Layer2TilemapLow+$200,X             ; |
    INX                                       ; |
    CPX.W #$0200                              ; |
    BNE -                                     ; /
    STZ.W LevelLoadObject
    LDA.B Layer2DataPtr+2                     ; \
    CMP.B #$FF                                ; |If the layer 2 data is a background,
    BNE CODE_058074                           ; / branch to $8074
    REP #$10                                  ; XY->16
    LDY.W #$0000                              ; \
    LDX.B Layer2DataPtr                       ; |
    CPX.W #DATA_0CE8FE                        ; |If Layer 2 pointer >= $E8FF,
    BCC +                                     ; |the background should use Map16 page x11 instead of x10
    LDY.W #$0001                              ; |
  + LDX.W #$0000                              ; \
    TYA                                       ; |
  - STA.L Layer2TilemapHigh,X                 ; |Set the background's Map16 page
    STA.L Layer2TilemapHigh+$200,X            ; |(i.e. setting all high tile bytes to Y)
    INX                                       ; |
    CPX.W #$0200                              ; |
    BNE -                                     ; /
    LDA.B #$0C                                ; \ Set highest Layer 2 address to x0C
    STA.B Layer2DataPtr+2                     ; / (All backgrounds are stored in bank 0C)
    STZ.W Empty1932                           ; \ Set tileset to 0
    STZ.W ObjectTileset                       ; /
    LDX.W #$B900
    STX.B _D
    REP #$20                                  ; A->16
    JSR CODE_058126
CODE_058074:
    SEP #$20                                  ; A->8
    LDX.W #$0000                              ; \
  - LDA.B #$00                                ; |
    JSR CODE_05833A                           ; |Clear level data
    DEX                                       ; |
    LDA.B #$25                                ; |
    JSR CODE_0582C8                           ; |
    CPX.W #$0200                              ; |
    BNE -                                     ; /
    STZ.W LevelLoadObject
    JSR LoadLevel                             ; Load the level
    SEP #$30                                  ; AXY->8
    LDA.W GameMode                            ; \
    CMP.B #$22                                ; |
    BPL +                                     ; |If level mode is less than x22,
    JSL CODE_02A751                           ; |JSL to $02A751
  + PLP
    RTL

if ver_is_lores(!_VER)                        ;\================== J, U, SS, & E0 =============
CODE_05809E:                                  ;!
    PHP                                       ;!
    SEP #$20                                  ;! A->8
else                                          ;<======================== E1 ===================
EDATA_05809E:                                 ;!
    db $20,$00,$5F,$FE,$FA,$18,$30,$00        ;!
    db $5F,$FE,$FA,$18,$FF                    ;!
                                              ;!
CODE_05809E:                                  ;!
    PHP                                       ;!
    SEP #$20                                  ;! A->8
    LDX.B #$0C                                ;!
  - LDA.L EDATA_05809E,X                      ;!
    STA.L DynamicStripeImage,X                ;!
    DEX                                       ;!
    BPL -                                     ;!
    STZ.B StripeImage                         ;!
    JSL CODE_0084C8                           ;!
    LDA.B #$80                                ;!
    STA.W HW_M7SEL                            ;!
endif                                         ;/===============================================
    STZ.W LevelLoadObject                     ; Zero a byte in the middle of the RAM table for the level header
    REP #$30                                  ; AXY->16
    LDA.W #$FFFF
    STA.B Layer1PrevTileUp                    ; $4D to $50 = #$FF
    STA.B Layer1PrevTileDown
    JSR CODE_05877E                           ; -> here
    LDA.B Layer1TileUp
    STA.B Layer1TileDown
    LDA.B Layer2TileUp
    STA.B Layer2TileDown
    LDA.W #$0202
    STA.B Layer1ScrollDir
CODE_0580BD:
    REP #$30                                  ; AXY->16
    JSL CODE_0588EC
    JSL CODE_058955
    JSL UploadOneMap16Strip
    REP #$30                                  ; AXY->16
    INC.B Layer1TileDown
    INC.B Layer2TileDown
    SEP #$30                                  ; AXY->8
    LDA.B Layer1TileDown
    LSR A
    LSR A
    LSR A
    REP #$30                                  ; AXY->16
    AND.W #$0006
    TAX
    LDA.W #$0133
    ASL A
    TAY
    LDA.W #$0007
    STA.B _0
    LDA.L MAP16AppTable,X
  - STA.W Map16Pointers,Y
    INY
    INY
    CLC
    ADC.W #$0008
    DEC.B _0
    BPL -
    SEP #$20                                  ; A->8
    INC.W LevelLoadObject
    LDA.W LevelLoadObject
    CMP.B #$20
    BNE CODE_0580BD
    LDA.W ThroughMain
    STA.W HW_TM
    STA.W HW_TMW
    LDA.W ThroughSub
    STA.W HW_TS
    STA.W HW_TSW
    REP #$20                                  ; A->16
    LDA.W #$FFFF
    STA.B Layer1PrevTileUp
    STA.B Layer1PrevTileDown
    STA.B Layer2PrevTileUp
    STA.B Layer2PrevTileDown
    PLP
    RTL

CODE_058126:
    PHP
    REP #$30                                  ; AXY->16
    LDY.W #$0000
    STY.B _3
    STY.B _5
    SEP #$30                                  ; AXY->8
    LDA.B #$7E
    STA.B _F
CODE_058136:
    SEP #$20                                  ; A->8
    REP #$10                                  ; XY->16
    LDY.B _3
    LDA.B [Layer2DataPtr],Y
    STA.B _7
    INY
    REP #$20                                  ; A->16
    STY.B _3
    SEP #$20                                  ; A->8
    AND.B #$80
    BEQ CODE_05816A
    LDA.B _7
    AND.B #$7F
    STA.B _7
    LDA.B [Layer2DataPtr],Y
    INY
    REP #$20                                  ; A->16
    STY.B _3
    LDY.B _5
  - SEP #$20                                  ; A->8
    STA.B [_D],Y
    INY
    DEC.B _7
    BPL -
    REP #$20                                  ; A->16
    STY.B _5
    JMP CODE_058188

CODE_05816A:
    REP #$20                                  ; A->16
    LDY.B _3
    SEP #$20                                  ; A->8
    LDA.B [Layer2DataPtr],Y
    INY
    REP #$20                                  ; A->16
    STY.B _3
    LDY.B _5
    SEP #$20                                  ; A->8
    STA.B [_D],Y
    REP #$20                                  ; A->16
    INY
    STY.B _5
    SEP #$20                                  ; A->8
    DEC.B _7
    BPL CODE_05816A
CODE_058188:
    REP #$20                                  ; A->16
    LDY.B _3
    SEP #$20                                  ; A->8
    LDA.B [Layer2DataPtr],Y
    CMP.B #$FF
    BNE CODE_058136
    INY
    LDA.B [Layer2DataPtr],Y
    CMP.B #$FF
    BNE CODE_058136
    REP #$20                                  ; A->16
    LDA.W #Map16BGTiles
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
    PLP
    RTS


DATA_0581BB:
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$E0,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $FE,$00,$7F,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$E0,$00,$00,$03,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

CODE_0581FB:
    SEP #$30                                  ; AXY->8
    LDA.W ObjectTileset                       ; \
    ASL A                                     ; |Store tileset*2 in X
    TAX                                       ; /
    LDA.B #DATA_0581BB>>16                    ; \Store x05 in $0F
    STA.B _F                                  ; /
    LDA.B #DATA_00E55E>>16                    ; \Store x00 in $84
    STA.B SlopesPtr+2                         ; /
    LDA.B #$C4                                ; \Store xC4 in $1430
    STA.W SolidTileStart                      ; /
    LDA.B #$CA                                ; \Store xCA in $1431
    STA.W SolidTileEnd                        ; /
    REP #$20                                  ; A->16
    LDA.W #DATA_00E55E                        ; \Store xE55E in $82-$83
    STA.B SlopesPtr                           ; /
    LDA.L TilesetMAP16Loc,X                   ; \Store address to MAP16 data in $00-$01
    STA.B _0                                  ; /
    LDA.W #Map16Common                        ; \Store x8000 in $02-$03
    STA.B _2                                  ; /
    LDA.W #DATA_0581BB                        ; \Store x81BB in $0D-$0E
    STA.B _D                                  ; /
    STZ.B _4                                  ; \
    STZ.B _9                                  ; |Store x00 in $04, $09 and $0B
    STZ.B _B                                  ; /
    REP #$10                                  ; XY->16
    LDY.W #$0000                              ; \Set X and Y to x0000
    TYX                                       ; /
CODE_058237:
    SEP #$20                                  ; A->8
    LDA.B [_D],Y
    STA.B _C
CODE_05823D:
    ASL.B _C
    BCC +
    REP #$20                                  ; A->16
    LDA.B _2
    STA.W Map16Pointers,X
    LDA.B _2
    CLC
    ADC.W #$0008
    STA.B _2
    JMP CODE_058262

  + REP #$20                                  ; A->16
    LDA.B _0
    STA.W Map16Pointers,X
    LDA.B _0
    CLC
    ADC.W #$0008
    STA.B _0
CODE_058262:
    SEP #$20                                  ; A->8
    INX
    INX
    INC.B _9
    INC.B _B
    LDA.B _B
    CMP.B #$08
    BNE CODE_05823D
    STZ.B _B
    INY
    CPY.W #$0040
    BNE CODE_058237
    LDA.W ObjectTileset
    BEQ CODE_058281
    CMP.B #$07
    BNE CODE_0582C5
CODE_058281:
    LDA.B #$FF
    STA.W SolidTileStart
    STA.W SolidTileEnd
    REP #$30                                  ; AXY->16
    LDA.W #DATA_00E5C8
    STA.B SlopesPtr
    LDA.W #$01C4
    ASL A
    TAY
    LDA.W #$8A70
    STA.B _0
    LDX.W #$0003
  - LDA.B _0
    STA.W Map16Pointers,Y
    CLC
    ADC.W #$0008
    STA.B _0
    INY
    INY
    DEX
    BPL -
    LDA.W #$01EC
    ASL A
    TAY
    LDX.W #$0003
  - LDA.B _0
    STA.W Map16Pointers,Y
    CLC
    ADC.W #$0008
    STA.B _0
    INY
    INY
    DEX
    BPL -
CODE_0582C5:
    SEP #$30                                  ; AXY->8
    RTS

CODE_0582C8:
    STA.L Map16TilesLow,X
    STA.L Map16TilesLow+$200,X
    STA.L Map16TilesLow+$400,X
    STA.L Map16TilesLow+$600,X
    STA.L Map16TilesLow+$800,X
    STA.L Map16TilesLow+$A00,X
    STA.L Map16TilesLow+$C00,X
    STA.L Map16TilesLow+$E00,X
    STA.L Map16TilesLow+$1000,X
    STA.L Map16TilesLow+$1200,X
    STA.L Map16TilesLow+$1400,X
    STA.L Map16TilesLow+$1600,X
    STA.L Map16TilesLow+$1800,X
    STA.L Map16TilesLow+$1A00,X
    STA.L Map16TilesLow+$1C00,X
    STA.L Map16TilesLow+$1E00,X
    STA.L Map16TilesLow+$2000,X
    STA.L Map16TilesLow+$2200,X
    STA.L Map16TilesLow+$2400,X
    STA.L Map16TilesLow+$2600,X
    STA.L Map16TilesLow+$2800,X
    STA.L Map16TilesLow+$2A00,X
    STA.L Map16TilesLow+$2C00,X
    STA.L Map16TilesLow+$2E00,X
    STA.L Map16TilesLow+$3000,X
    STA.L Map16TilesLow+$3200,X
    STA.L Map16TilesLow+$3400,X
    STA.L Map16TilesLow+$3600,X
    INX
    RTS

CODE_05833A:
    STA.L Map16TilesHigh,X
    STA.L Map16TilesHigh+$200,X
    STA.L Map16TilesHigh+$400,X
    STA.L Map16TilesHigh+$600,X
    STA.L Map16TilesHigh+$800,X
    STA.L Map16TilesHigh+$A00,X
    STA.L Map16TilesHigh+$C00,X
    STA.L Map16TilesHigh+$E00,X
    STA.L Map16TilesHigh+$1000,X
    STA.L Map16TilesHigh+$1200,X
    STA.L Map16TilesHigh+$1400,X
    STA.L Map16TilesHigh+$1600,X
    STA.L Map16TilesHigh+$1800,X
    STA.L Map16TilesHigh+$1A00,X
    STA.L Map16TilesHigh+$1C00,X
    STA.L Map16TilesHigh+$1E00,X
    STA.L Map16TilesHigh+$2000,X
    STA.L Map16TilesHigh+$2200,X
    STA.L Map16TilesHigh+$2400,X
    STA.L Map16TilesHigh+$2600,X
    STA.L Map16TilesHigh+$2800,X
    STA.L Map16TilesHigh+$2A00,X
    STA.L Map16TilesHigh+$2C00,X
    STA.L Map16TilesHigh+$2E00,X
    STA.L Map16TilesHigh+$3000,X
    STA.L Map16TilesHigh+$3200,X
    STA.L Map16TilesHigh+$3400,X
    STA.L Map16TilesHigh+$3600,X
    INX
    RTS

LoadLevel:
    PHP
    SEP #$30                                  ; AXY->8
    STZ.W LayerProcessing                     ; Layer number (0=Layer 1, 1=Layer 2)
    JSR CODE_0584E3                           ; Loads level header
    JSR CODE_0581FB
LoadAgain:
    LDA.W LevelModeSetting                    ; Get current level mode
    CMP.B #$09                                ; \
    BEQ LoadLevelDone                         ; |
    CMP.B #$0B                                ; |If the current level is a boss level,
    BEQ LoadLevelDone                         ; |don't load anything else.
    CMP.B #$10                                ; |
    BEQ LoadLevelDone                         ; /
    LDY.B #$00                                ; \
    LDA.B [Layer1DataPtr],Y                   ; |
    CMP.B #$FF                                ; |If level isn't empty, load the level.
    BEQ +                                     ; |
    JSR LoadLevelData                         ; /
  + SEP #$30                                  ; AXY->8
    LDA.W LevelModeSetting                    ; Get current level mode
    BEQ LoadLevelDone                         ; \
    CMP.B #$0A                                ; |
    BEQ LoadLevelDone                         ; |
    CMP.B #$0C                                ; |
    BEQ LoadLevelDone                         ; |If the current level isn't a Layer 2 level,
    CMP.B #$0D                                ; |branch to LoadLevelDone
    BEQ LoadLevelDone                         ; |
    CMP.B #$0E                                ; |
    BEQ LoadLevelDone                         ; |
    CMP.B #$11                                ; |
    BEQ LoadLevelDone                         ; |
    CMP.B #$1E                                ; |
    BEQ LoadLevelDone                         ; /
    INC.W LayerProcessing                     ; \Increase layer number and load into A
    LDA.W LayerProcessing                     ; /
    CMP.B #$02                                ; \If it is x02, end. (Layer 1 and 2 are done)
    BEQ LoadLevelDone                         ; /
    LDA.B Layer2DataPtr                       ; \
    CLC                                       ; |
    ADC.B #$05                                ; |
    STA.B Layer1DataPtr                       ; |Move address stored in $68-$6A to $65-$67.
    LDA.B Layer2DataPtr+1                     ; |(Move Layer 2 address to "Level to load" address)
    ADC.B #$00                                ; |It also increases the address by 5 (to ignore Layer 2's header)
    STA.B Layer1DataPtr+1                     ; |
    LDA.B Layer2DataPtr+2                     ; |
    STA.B Layer1DataPtr+2                     ; /
    STZ.W LevelLoadObject
    JMP LoadAgain

LoadLevelDone:
    STZ.W LayerProcessing
    PLP
    RTS


VerticalTable:
    db $00,$00,$80,$01,$81,$02,$82,$03        ; Vertical level settings for each level mode ; Format:
    db $83,$00,$01,$00,$00,$01,$00,$00        ; ?uuuuu?v
    db $00,$00,$00,$00,$00,$00,$00,$00        ; ?= Unknown purpose ; u= Unused?
    db $00,$00,$00,$00,$00,$00,$00,$80        ; v= Vertical level
LevMainScrnTbl:
    db $15,$15,$17,$15,$15,$15,$17,$15        ; Main screen settings for each level mode
    db $17,$15,$15,$15,$15,$15,$04,$04
    db $15,$17,$15,$15,$15,$15,$15,$15
    db $15,$15,$15,$15,$15,$15,$01,$02
LevSubScrnTbl:
    db $02,$02,$00,$02,$02,$02,$00,$02        ; Subscreen settings for each level mode
    db $00,$00,$02,$00,$02,$02,$13,$13
    db $00,$00,$02,$02,$02,$02,$02,$02
    db $02,$02,$02,$02,$02,$02,$16,$15
LevCGADSUBtable:
    db $24,$24,$24,$24,$24,$24,$20,$24        ; CGADSUB settings for each level mode
    db $24,$20,$24,$20,$70,$70,$24,$24
    db $20,$FF,$24,$24,$24,$24,$24,$24
    db $24,$24,$24,$24,$24,$24,$21,$22
SpecialLevTable:
    db $00,$00,$00,$00,$00,$00,$00,$00        ; Special level settings for each level mode ; 00: Normal level
    db $00,$C0,$00,$80,$00,$00,$00,$00        ; 80: Iggy/Larry level ; C0: Morton/Ludwig/Roy level
    db $C1,$00,$00,$00,$00,$00,$00,$00        ; C1: Bowser level
    db $00,$00,$00,$00,$00,$00,$00,$00
LevXYPPCCCTtbl:
    db $20,$20,$20,$30,$30,$30,$30,$30        ; XYPPCCCT settings for each level mode ; (The XYPPCCCT setting appears to be XORed with nearly all
    db $30,$30,$30,$30,$30,$30,$20,$20        ; sprites' XYPPCCCT settings)
    db $30,$30,$30,$30,$30,$30,$30,$30
    db $30,$30,$30,$30,$30,$30,$30,$30
TimerTable:
    db $00,$02,$03,$04

LevelMusicTable:
    db !BGM_OVERWORLD                         ; A level can choose between 8 tracks. ; This table contains the tracks to choose from.
    db !BGM_UNDERGROUND
    db !BGM_ATHLETIC
    db !BGM_CASTLE
    db !BGM_GHOSTHOUSE
    db !BGM_UNDERWATER
    db !BGM_BOSSFIGHT
    db !BGM_BONUSGAME

CODE_0584E3:
    LDY.B #$00
    LDA.B [Layer1DataPtr],Y                   ; Get first byte
    TAX                                       ; \
    AND.B #$1F                                ; |Get amount of screens
    INC A                                     ; |
    STA.B LevelScrLength                      ; /
    TXA                                       ; \
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |Get BG color setting
    LSR A                                     ; |
    LSR A                                     ; |
    STA.W BackgroundPalette                   ; /
    INY                                       ; \Get second byte
    LDA.B [Layer1DataPtr],Y                   ; /
    AND.B #$1F                                ; \Get level mode
    STA.W LevelModeSetting                    ; /
    TAX
    LDA.L LevXYPPCCCTtbl,X                    ; \Get XYPPCCCT settings from table
    STA.B SpriteProperties                    ; /
    LDA.L LevMainScrnTbl,X                    ; \Get main screen setting from table
    STA.W ThroughMain                         ; /
    LDA.L LevSubScrnTbl,X                     ; \Get subscreen setting from table
    STA.W ThroughSub                          ; /
    LDA.L LevCGADSUBtable,X                   ; \Get CGADSUB settings from table
    STA.B ColorSettings                       ; /
    LDA.L SpecialLevTable,X                   ; \Get special level setting from table
    STA.W IRQNMICommand                       ; /
    LDA.L VerticalTable,X                     ; \Get vertical level setting from table
    STA.B ScreenMode                          ; /
    LSR A                                     ; \
    LDA.B LevelScrLength                      ; |
    LDX.B #$01                                ; |If level mode is even:
    BCC +                                     ; |Store screen amount in $5E and x01 in $5F
    TAX                                       ; |Otherwise:
    LDA.B #$01                                ; |Store x01 in $5E and screen amount in $5F
  + STA.B LastScreenHoriz                     ; |
    STX.B LastScreenVert                      ; /
    LDA.B [Layer1DataPtr],Y                   ; Reload second byte
    LSR A                                     ; \
    LSR A                                     ; |
    LSR A                                     ; |Get BG color settings
    LSR A                                     ; |
    LSR A                                     ; |
    STA.W BackAreaColor                       ; /
    INY                                       ; \Get third byte
    LDA.B [Layer1DataPtr],Y                   ; /
    STA.B _0                                  ; "Push" third byte
    TAX                                       ; "Push" third byte
    AND.B #$0F                                ; \Load sprite set
    STA.W SpriteTileset                       ; /
    TXA                                       ; "Pull" third byte
    LSR A                                     ; \
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    AND.B #$07                                ; |
    TAX                                       ; |Get music
    LDA.L LevelMusicTable,X                   ; |
    LDX.W MusicBackup                         ; | \
    BPL +                                     ; |  |
    ORA.B #$80                                ; |  |Related to not restarting music if the new track
  + CMP.W MusicBackup                         ; |  |is the same as the old one?
    BNE +                                     ; |  |
    ORA.B #$40                                ; | /
  + STA.W MusicBackup                         ; /
    LDA.B _0                                  ; "Pull" third byte
    AND.B #$80                                ; \
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |Get Layer 3 priority
    LSR A                                     ; |
    ORA.B #$01                                ; |
    STA.B MainBGMode                          ; /
    INY                                       ; \Get fourth bit
    LDA.B [Layer1DataPtr],Y                   ; /
    STA.B _0                                  ; "Push" fourth bit
    LSR A                                     ; \
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    TAX                                       ; |Get time
    LDA.W SublevelCount                       ; |
    BNE +                                     ; |
    LDA.L TimerTable,X                        ; |
    STA.W InGameTimerHundreds                 ; |
    STZ.W InGameTimerTens                     ; |
    STZ.W InGameTimerOnes                     ; /
  + LDA.B _0                                  ; "Pull" fourth bit
    AND.B #$07                                ; \Get FG color settings
    STA.W ForegroundPalette                   ; /
    LDA.B _0                                  ; "Pull" fourth bit (again)
    AND.B #$38                                ; \
    LSR A                                     ; |
    LSR A                                     ; |Get sprite palette
    LSR A                                     ; |
    STA.W SpritePalette                       ; /
    INY                                       ; \Get fifth byte
    LDA.B [Layer1DataPtr],Y                   ; /
    AND.B #$0F                                ; \
    STA.W ObjectTileset                       ; |Get tileset
    STA.W Empty1932                           ; /
    LDA.B [Layer1DataPtr],Y                   ; Reload fifth byte
    AND.B #$C0                                ; \
    ASL A                                     ; |
    ROL A                                     ; |Get item memory settings
    ROL A                                     ; |
    STA.W ItemMemorySetting                   ; /
    LDA.B [Layer1DataPtr],Y                   ; Reload fifth byte
    AND.B #$30                                ; \
    LSR A                                     ; |Get horizontal/vertical scroll
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    CMP.B #$03                                ; | \
    BNE +                                     ; |  |If scroll mode is x03, disable both
    STZ.W HorizLayer1Setting                  ; |  |vertical and horizontal scroll
    LDA.B #$00                                ; | /
  + STA.W VertLayer1Setting                   ; /
    LDA.B Layer1DataPtr                       ; \
    CLC                                       ; |
    ADC.B #$05                                ; |
    STA.B Layer1DataPtr                       ; |Make $65 point at the level data
    LDA.B Layer1DataPtr+1                     ; |(Level data comes right after the header)
    ADC.B #$00                                ; |
    STA.B Layer1DataPtr+1                     ; /
    RTS                                       ; We're done!

CODE_0585D8:
    LDA.B LvlLoadObjNo
    BNE CODE_0585E2
    LDA.B LvlLoadObjSize
    CMP.B #$02
    BCC +
CODE_0585E2:
    LDA.B _A
    AND.B #$0F
    STA.B _0
    LDA.B _B
    AND.B #$0F
    STA.B _1
    LDA.B _A
    AND.B #$F0
    ORA.B _1
    STA.B _A
    LDA.B _B
    AND.B #$F0
    ORA.B _0
    STA.B _B
  + RTS

LoadLevelData:
    SEP #$30                                  ; AXY->8
    LDY.B #$00                                ; \
    LDA.B [Layer1DataPtr],Y                   ; |
    STA.B _A                                  ; |
    INY                                       ; |
    LDA.B [Layer1DataPtr],Y                   ; |Read three bytes of level data
    STA.B _B                                  ; |Store them in $0A, $0B and $59
    INY                                       ; |
    LDA.B [Layer1DataPtr],Y                   ; |
    STA.B LvlLoadObjSize                      ; |
    INY                                       ; /
    TYA                                       ; \
    CLC                                       ; |
    ADC.B Layer1DataPtr                       ; |
    STA.B Layer1DataPtr                       ; |Increase address by 3 (as 3 bytes were read)
    LDA.B Layer1DataPtr+1                     ; |
    ADC.B #$00                                ; |
    STA.B Layer1DataPtr+1                     ; /
    LDA.B _B                                  ; \
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    STA.B LvlLoadObjNo                        ; |Get block number, store in $5A
    LDA.B _A                                  ; |
    AND.B #$60                                ; |
    LSR A                                     ; |
    ORA.B LvlLoadObjNo                        ; |
    STA.B LvlLoadObjNo                        ; /
    LDA.B ScreenMode                          ; A = vertical level setting
    LDY.W LayerProcessing                     ; \
    BEQ +                                     ; |If $1933=x00, divide A by 2
    LSR A                                     ; /
  + AND.B #$01                                ; \
    BEQ +                                     ; |If lowest bit of A is set, jump to sub
    JSR CODE_0585D8                           ; /
  + LDA.B _A                                  ; \
    AND.B #$0F                                ; |
    ASL A                                     ; |
    ASL A                                     ; |
    ASL A                                     ; |Set upper half of $57 to Y pos
    ASL A                                     ; |and lower half of $57 to X pos
    STA.B LevelLoadPos                        ; |
    LDA.B _B                                  ; |
    AND.B #$0F                                ; |
    ORA.B LevelLoadPos                        ; |
    STA.B LevelLoadPos                        ; /
    REP #$20                                  ; A->16
    LDA.W LayerProcessing                     ; \
    AND.W #$00FF                              ; |Load $1993*2 into X
    ASL A                                     ; |
    TAX                                       ; /
    LDA.L LoadBlkPtrs,X
    STA.B _3
    LDA.L LoadBlkTable2,X
    STA.B _6
    LDA.W LevelModeSetting                    ; \
    AND.W #$001F                              ; |Set Y to Level Mode*2
    ASL A                                     ; |
    TAY                                       ; /
    SEP #$20                                  ; A->8
    LDA.B #$00
    STA.B _5
    STA.B _8
    LDA.B [_3],Y
    STA.B _0
    LDA.B [_6],Y
    STA.B _D
    INY
    LDA.B [_3],Y
    STA.B _1
    LDA.B [_6],Y
    STA.B _E
    LDA.B #$00
    STA.B _2
    STA.B _F
    LDA.B _A                                  ; \
    AND.B #$80                                ; |
    ASL A                                     ; |If New Page flag is set, increase $1928 by 1
    ADC.W LevelLoadObject                     ; |(A = $1928)
    STA.W LevelLoadObject                     ; /
    STA.W LevelLoadObjectTile                 ; Store A in $1BA1
    ASL A                                     ; \
    CLC                                       ; |Multiply A by 2 and add $1928 to it
    ADC.W LevelLoadObject                     ; |Set Y to A
    TAY                                       ; /
    LDA.B [_0],Y
    STA.B Map16LowPtr
    LDA.B [_D],Y
    STA.B Map16HighPtr
    INY
    LDA.B [_0],Y
    STA.B Map16LowPtr+1
    LDA.B [_D],Y
    STA.B Map16HighPtr+1
    INY
    LDA.B [_0],Y
    STA.B Map16LowPtr+2
    LDA.B [_D],Y
    STA.B Map16HighPtr+2
    LDA.B _A                                  ; \
    AND.B #$10                                ; |If high coordinate is set...
    BEQ +                                     ; |(Lower half of horizontal level)
    INC.B Map16LowPtr+1                       ; |(Right half of vertical level)
    INC.B Map16HighPtr+1                      ; |...increase $6C and $6F
  + LDA.B LvlLoadObjNo                        ; \
    BNE +                                     ; |If block number is x00 (extended object),
    JSR LevLoadExtObj                         ; |Jump to sub LevLoadExtObj
    JMP LevLoadContinue                       ; |                  (Why didn't they use BRA here?)

  + JSR LevLoadNrmObj                         ; |Jump to sub LevLoadNrmObj
LevLoadContinue:
    SEP #$20                                  ; A->8
    REP #$10                                  ; XY->16
    LDY.W #$0000                              ; \
    LDA.B [Layer1DataPtr],Y                   ; |
    CMP.B #$FF                                ; |If the next byte is xFF, return (loading is done).
    BEQ +                                     ; |Otherwise, repeat this routine.
    JMP LoadLevelData                         ; |

  + RTS                                       ; /

LevLoadExtObj:
    SEP #$30                                  ; AXY->8
    JSL CODE_0DA100
    RTS

LevLoadNrmObj:
    SEP #$30                                  ; AXY->8
    JSL CODE_0DA40F
    RTS

CODE_0586F1:
    PHP
    REP #$30                                  ; AXY->16
    JSR CODE_05877E
    SEP #$20                                  ; A->8
    LDA.B ScreenMode
    AND.B #!ScrMode_Layer1Vert
    BNE CODE_058713
    REP #$20                                  ; A->16
    LDA.B Layer1ScrollDir
    AND.W #$00FF
    TAX
    LDA.B Layer1XPos
    AND.W #$FFF0
    CMP.B Layer1PrevTileUp,X
    BEQ +
    JMP CODE_058724

CODE_058713:
    REP #$20                                  ; A->16
    LDA.B Layer1ScrollDir
    AND.W #$00FF
    TAX
    LDA.B Layer1YPos
    AND.W #$FFF0
    CMP.B Layer1PrevTileUp,X
    BEQ +
CODE_058724:
    STA.B Layer1PrevTileUp,X
    TXA
    EOR.W #$0002
    TAX
    LDA.W #$FFFF
    STA.B Layer1PrevTileUp,X
    JSL CODE_05881A
    JMP CODE_058774

  + SEP #$20                                  ; A->8
    LDA.B ScreenMode
    AND.B #!ScrMode_Layer2Vert
    BNE CODE_058753
    REP #$20                                  ; A->16
    LDA.B Layer2ScrollDir
    AND.W #$00FF
    TAX
    LDA.B Layer2XPos
    AND.W #$FFF0
    CMP.B Layer2PrevTileUp,X
    BEQ CODE_058774
    JMP CODE_058764

CODE_058753:
    REP #$20                                  ; A->16
    LDA.B Layer2ScrollDir
    AND.W #$00FF
    TAX
    LDA.B Layer2YPos
    AND.W #$FFF0
    CMP.B Layer2PrevTileUp,X
    BEQ CODE_058774
CODE_058764:
    STA.B Layer2PrevTileUp,X
    TXA
    EOR.W #$0002
    TAX
    LDA.W #$FFFF
    STA.B Layer2PrevTileUp,X
    JSL CODE_058883
CODE_058774:
    PLP
    RTL


MAP16AppTable:
    db $B0,$8A,$E0,$84,$F0,$8A,$30,$8B

CODE_05877E:
    PHP
    SEP #$20                                  ; A->8
    LDA.B ScreenMode
    AND.B #!ScrMode_Layer1Vert
    BNE CODE_0587CB
    REP #$20                                  ; A->16
    LDA.B Layer1XPos                          ; Load "Xpos of Screen Boundary"
    LSR A                                     ; \
    LSR A                                     ; |Multiply by 16
    LSR A                                     ; |
    LSR A                                     ; /
    TAY
    SEC                                       ; \
    SBC.W #$0008                              ; /Subtract 8
    STA.B Layer1TileUp                        ; Store to $45 (Seems to be Scratch RAM)
    TYA                                       ; Get back the multiplied XPos
    CLC
    ADC.W #$0017                              ; Add $17
    STA.B Layer1TileDown                      ; Store to $47 (Seems to be Scratch RAM)
    SEP #$30                                  ; AXY->8
    LDA.B Layer1ScrollDir                     ; \
    TAX                                       ; | LDA $45,x  / $55
    LDA.B Layer1TileUp,X                      ; /
    LSR A                                     ; \ multiply by 8
    LSR A                                     ; |
    LSR A                                     ; /
    REP #$30                                  ; AXY->16
    AND.W #$0006                              ; AND to make it either 6, 4, 2, or 0.
    TAX
    LDA.W #$0133                              ; \LDY #$0266
    ASL A                                     ; |
    TAY                                       ; /
    LDA.W #$0007
    STA.B _0
    LDA.L MAP16AppTable,X
  - STA.W Map16Pointers,Y                     ; MAP16 pointer table
    INY
    INY
    CLC
    ADC.W #$0008                              ; 8 bytes per tile?
    DEC.B _0
    BPL -
    JMP CODE_0587E1

CODE_0587CB:
    REP #$20                                  ; A->16
    LDA.B Layer1YPos
    LSR A
    LSR A
    LSR A
    LSR A
    TAY
    SEC
    SBC.W #$0008
    STA.B Layer1TileUp
    TYA
    CLC
    ADC.W #$0017
    STA.B Layer1TileDown
CODE_0587E1:
    SEP #$20                                  ; A->8
    LDA.B ScreenMode                          ; Load the vertical level flag
    AND.B #!ScrMode_Layer2Vert                ; \if bit 1 is set, process based on that
    BNE +                                     ; /
    REP #$20                                  ; A->16, Not a vertical level
    LDA.B Layer2XPos                          ; \Y = L2XPos * 16
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    TAY                                       ; /
    SEC
    SBC.W #$0008
    STA.B Layer2TileUp
    TYA
    CLC
    ADC.W #$0017
    STA.B Layer2TileDown
    JMP CODE_058818

  + REP #$20                                  ; \ A->16, A = Y = !4*16 (?)
    LDA.B Layer2YPos                          ; |
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    TAY                                       ; /
    SEC                                       ; \
    SBC.W #$0008                              ; |Subtract x08 and store in $49
    STA.B Layer2TileUp                        ; /
    TYA                                       ; \
    CLC                                       ; |"Undo", add x17 and store in $4B
    ADC.W #$0017                              ; |
    STA.B Layer2TileDown                      ; /
CODE_058818:
    PLP
    RTS

CODE_05881A:
    SEP #$30                                  ; AXY->8
    LDA.W LevelModeSetting
    JSL ExecutePtrLong

    dl CODE_0589CE
    dl CODE_0589CE
    dl CODE_0589CE
    dl CODE_058A9B
    dl CODE_058A9B
    dl CODE_0589CE
    dl CODE_0589CE
    dl CODE_058A9B
    dl CODE_058A9B
    dl Return058A9A
    dl CODE_058A9B
    dl Return058A9A
    dl CODE_0589CE
    dl CODE_058A9B
    dl CODE_0589CE
    dl CODE_0589CE
    dl Return058A9A
    dl CODE_0589CE
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl CODE_0589CE
    dl CODE_0589CE

CODE_058883:
    SEP #$30                                  ; AXY->8
    LDA.W LevelModeSetting
    JSL ExecutePtrLong

    dl Return058C70
    dl CODE_058B8D
    dl CODE_058B8D
    dl CODE_058B8D
    dl CODE_058B8D
    dl CODE_058C71
    dl CODE_058C71
    dl CODE_058C71
    dl CODE_058C71
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl CODE_058B8D
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl CODE_058B8D

CODE_0588EC:
    SEP #$30                                  ; AXY->8
    LDA.W LevelModeSetting
    JSL ExecutePtrLong

    dl CODE_0589CE
    dl CODE_0589CE
    dl CODE_0589CE
    dl CODE_058A9B
    dl CODE_058A9B
    dl CODE_0589CE
    dl CODE_0589CE
    dl CODE_058A9B
    dl CODE_058A9B
    dl Return058A9A
    dl CODE_058A9B
    dl Return058A9A
    dl CODE_0589CE
    dl CODE_058A9B
    dl CODE_0589CE
    dl CODE_0589CE
    dl Return058A9A
    dl CODE_0589CE
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl Return058A9A
    dl CODE_0589CE
    dl CODE_0589CE

CODE_058955:
    SEP #$30                                  ; AXY->8
    LDA.W LevelModeSetting
    JSL ExecutePtrLong

    dl CODE_058D7A
    dl CODE_058B8D
    dl CODE_058B8D
    dl CODE_058B8D
    dl CODE_058B8D
    dl CODE_058C71
    dl CODE_058C71
    dl CODE_058C71
    dl CODE_058C71
    dl Return058C70
    dl CODE_058D7A
    dl Return058C70
    dl CODE_058D7A
    dl CODE_058D7A
    dl CODE_058D7A
    dl CODE_058B8D
    dl Return058C70
    dl CODE_058D7A
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl Return058C70
    dl CODE_058D7A
    dl CODE_058B8D

    db $80,$00,$40,$00,$20,$00,$10,$00
    db $08,$00,$04,$00,$02,$00,$01,$00

CODE_0589CE:
    PHP
    REP #$30                                  ; AXY->16
    LDA.W LevelModeSetting
    AND.W #$00FF
    ASL A
    TAX
    SEP #$20                                  ; A->8
    LDA.L Ptrs00BDA8,X
    STA.B _A
    LDA.L Ptrs00BDA8+1,X
    STA.B _B
    LDA.L Ptrs00BE28,X
    STA.B _D
    LDA.L Ptrs00BE28+1,X
    STA.B _E
    LDA.B #$00
    STA.B _C
    STA.B _F
    LDA.B Layer1ScrollDir
    TAX
    LDA.B Layer1TileUp,X
    AND.B #$0F
    ASL A
    STA.W Layer1VramAddr+1
    LDY.W #$0020
    LDA.B Layer1TileUp,X
    AND.B #$10
    BEQ +
    LDY.W #$0024
  + TYA
    STA.W Layer1VramAddr
    REP #$20                                  ; A->16
    LDA.B Layer1TileUp,X
    AND.W #$01F0
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _0
    ASL A
    CLC
    ADC.B _0
    TAY
    LDA.B [_A],Y
    STA.B Map16LowPtr
    LDA.B [_D],Y
    STA.B Map16HighPtr
    SEP #$20                                  ; A->8
    INY
    INY
    LDA.B [_A],Y
    STA.B Map16LowPtr+2
    LDA.B [_D],Y
    STA.B Map16HighPtr+2
    SEP #$10                                  ; XY->8
    LDY.B #$0D
    LDA.W ObjectTileset
    CMP.B #$10
    BMI +
    LDY.B #$05
  + STY.B _C
    REP #$30                                  ; AXY->16
    LDA.B Layer1TileUp,X
    AND.W #$000F
    STA.B _8
    LDX.W #$0000
  - LDY.B _8
    LDA.B [Map16LowPtr],Y
    AND.W #$00FF
    STA.B _0
    LDA.B [Map16HighPtr],Y
    STA.B _1
    LDA.B _0
    ASL A
    TAY
    LDA.W Map16Pointers,Y
    STA.B _A
    LDY.W #$0000
    LDA.B [_A],Y
    STA.W Layer1VramBuffer,X
    INY
    INY
    LDA.B [_A],Y
    STA.W Layer1VramBuffer+2,X
    INY
    INY
    LDA.B [_A],Y
    STA.W Layer1VramBuffer+$80,X
    INY
    INY
    LDA.B [_A],Y
    STA.W Layer1VramBuffer+$82,X
    INX
    INX
    INX
    INX
    LDA.B _8
    CLC
    ADC.W #$0010
    STA.B _8
    CMP.W #$01B0
    BCC -
    PLP
Return058A9A:
    RTL

CODE_058A9B:
    PHP
    REP #$30                                  ; AXY->16
    LDA.W LevelModeSetting
    AND.W #$00FF
    ASL A
    TAX
    SEP #$20                                  ; A->8
    LDA.L Ptrs00BDA8,X
    STA.B _A
    LDA.L Ptrs00BDA8+1,X
    STA.B _B
    LDA.L Ptrs00BE28,X
    STA.B _D
    LDA.L Ptrs00BE28+1,X
    STA.B _E
    LDA.B #$00
    STA.B _C
    STA.B _F
    LDA.B Layer1ScrollDir
    TAX
    LDY.W #$0020
    LDA.B Layer1TileUp,X
    AND.B #$10
    BEQ +
    LDY.W #$0028
  + TYA
    STA.B _0
    LDA.B Layer1TileUp,X
    LSR A
    LSR A
    AND.B #$03
    ORA.B _0
    STA.W Layer1VramAddr
    LDA.B Layer1TileUp,X
    AND.B #$03
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    STA.W Layer1VramAddr+1
    REP #$20                                  ; A->16
    LDA.B Layer1TileUp,X
    AND.W #$01F0
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _0
    ASL A
    CLC
    ADC.B _0
    TAY
    LDA.B [_A],Y
    STA.B Map16LowPtr
    LDA.B [_D],Y
    STA.B Map16HighPtr
    SEP #$20                                  ; A->8
    INY
    INY
    LDA.B [_A],Y
    STA.B Map16LowPtr+2
    LDA.B [_D],Y
    STA.B Map16HighPtr+2
    SEP #$10                                  ; XY->8
    LDY.B #$0D
    LDA.W ObjectTileset
    CMP.B #$10
    BMI +
    LDY.B #$05
  + STY.B _C
    REP #$30                                  ; AXY->16
    LDA.B Layer1TileUp,X
    AND.W #$000F
    ASL A
    ASL A
    ASL A
    ASL A
    STA.B _8
    LDX.W #$0000
CODE_058B35:
    LDY.B _8
    LDA.B [Map16LowPtr],Y
    AND.W #$00FF
    STA.B _0
    LDA.B [Map16HighPtr],Y
    STA.B _1
    LDA.B _0
    ASL A
    TAY
    LDA.W Map16Pointers,Y
    STA.B _A
    LDY.W #$0000
    LDA.B [_A],Y
    STA.W Layer1VramBuffer,X
    INY
    INY
    LDA.B [_A],Y
    STA.W Layer1VramBuffer+$80,X
    INX
    INX
    INY
    INY
    LDA.B [_A],Y
    STA.W Layer1VramBuffer,X
    INY
    INY
    LDA.B [_A],Y
    STA.W Layer1VramBuffer+$80,X
    INX
    INX
    LDA.B _8
    TAY
    CLC
    ADC.W #$0001
    STA.B _8
    AND.W #$000F
    BNE +
    TYA
    AND.W #$FFF0
    CLC
    ADC.W #$0100
    STA.B _8
  + LDA.B _8
    AND.W #$010F
    BNE CODE_058B35
    PLP
    RTL

CODE_058B8D:
    PHP
    REP #$30                                  ; AXY->16
    LDA.W LevelModeSetting
    AND.W #$00FF
    ASL A
    TAX
    SEP #$20                                  ; A->8
    LDY.W #$0000
    LDA.W ObjectTileset
    CMP.B #$03
    BNE +
    LDY.W #$1000
  + STY.B _3
    LDA.L Ptrs00BDE8,X
    STA.B _A
    LDA.L Ptrs00BDE8+1,X
    STA.B _B
    LDA.L Ptrs00BE68,X
    STA.B _D
    LDA.L Ptrs00BE68+1,X
    STA.B _E
    LDA.B #$00
    STA.B _C
    STA.B _F
    LDA.B Layer2ScrollDir
    TAX
    LDA.B Layer2TileUp,X
    AND.B #$0F
    ASL A
    STA.W Layer2VramAddr+1
    LDY.W #$0030
    LDA.B Layer2TileUp,X
    AND.B #$10
    BEQ +
    LDY.W #$0034
  + TYA
    STA.W Layer2VramAddr
    REP #$30                                  ; AXY->16
    LDA.B Layer2TileUp,X
    AND.W #$01F0
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _0
    ASL A
    CLC
    ADC.B _0
    TAY
    LDA.B [_A],Y
    STA.B Map16LowPtr
    LDA.B [_D],Y
    STA.B Map16HighPtr
    SEP #$20                                  ; A->8
    INY
    INY
    LDA.B [_A],Y
    STA.B Map16LowPtr+2
    LDA.B [_D],Y
    STA.B Map16HighPtr+2
    SEP #$10                                  ; XY->8
    LDY.B #$0D
    LDA.W ObjectTileset
    CMP.B #$10
    BMI +
    LDY.B #$05
  + STY.B _C
    REP #$30                                  ; AXY->16
    LDA.B Layer2TileUp,X
    AND.W #$000F
    STA.B _8
    LDX.W #$0000
  - LDY.B _8
    LDA.B [Map16LowPtr],Y
    AND.W #$00FF
    STA.B _0
    LDA.B [Map16HighPtr],Y
    STA.B _1
    LDA.B _0
    ASL A
    TAY
    LDA.W Map16Pointers,Y
    STA.B _A
    LDY.W #$0000
    LDA.B [_A],Y
    ORA.B _3
    STA.W Layer2VramBuffer,X
    INY
    INY
    LDA.B [_A],Y
    ORA.B _3
    STA.W Layer2VramBuffer+2,X
    INY
    INY
    LDA.B [_A],Y
    ORA.B _3
    STA.W Layer2VramBuffer+$80,X
    INY
    INY
    LDA.B [_A],Y
    ORA.B _3
    STA.W Layer2VramBuffer+$82,X
    INX
    INX
    INX
    INX
    LDA.B _8
    CLC
    ADC.W #$0010
    STA.B _8
    CMP.W #$01B0
    BCC -
    PLP
Return058C70:
    RTL

CODE_058C71:
    PHP
    REP #$30                                  ; AXY->16
    LDA.W LevelModeSetting
    AND.W #$00FF
    ASL A
    TAX
    SEP #$20                                  ; A->8
    LDY.W #$0000
    LDA.W ObjectTileset
    CMP.B #$03
    BNE +
    LDY.W #$1000
  + STY.B _3
    LDA.L Ptrs00BDE8,X
    STA.B _A
    LDA.L Ptrs00BDE8+1,X
    STA.B _B
    LDA.L Ptrs00BE68,X
    STA.B _D
    LDA.L Ptrs00BE68+1,X
    STA.B _E
    LDA.B #$00
    STA.B _C
    STA.B _F
    LDA.B Layer2ScrollDir
    TAX
    LDY.W #$0030
    LDA.B Layer2TileUp,X
    AND.B #$10
    BEQ +
    LDY.W #$0038
  + TYA
    STA.B _0
    LDA.B Layer2TileUp,X
    LSR A
    LSR A
    AND.B #$03
    ORA.B _0
    STA.W Layer2VramAddr
    LDA.B Layer2TileUp,X
    AND.B #$03
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    STA.W Layer2VramAddr+1
    REP #$20                                  ; A->16
    LDA.B Layer2TileUp,X
    AND.W #$01F0
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _0
    ASL A
    CLC
    ADC.B _0
    TAY
    LDA.B [_A],Y
    STA.B Map16LowPtr
    LDA.B [_D],Y
    STA.B Map16HighPtr
    SEP #$20                                  ; A->8
    INY
    INY
    LDA.B [_A],Y
    STA.B Map16LowPtr+2
    LDA.B [_D],Y
    STA.B Map16HighPtr+2
    SEP #$10                                  ; XY->8
    LDY.B #$0D
    LDA.W ObjectTileset
    CMP.B #$10
    BMI +
    LDY.B #$05
  + STY.B _C
    REP #$30                                  ; AXY->16
    LDA.B Layer2TileUp,X
    AND.W #$000F
    ASL A
    ASL A
    ASL A
    ASL A
    STA.B _8
    LDX.W #$0000
CODE_058D1A:
    LDY.B _8
    LDA.B [Map16LowPtr],Y
    AND.W #$00FF
    STA.B _0
    LDA.B [Map16HighPtr],Y
    STA.B _1
    LDA.B _0
    ASL A
    TAY
    LDA.W Map16Pointers,Y
    STA.B _A
    LDY.W #$0000
    LDA.B [_A],Y
    ORA.B _3
    STA.W Layer2VramBuffer,X
    INY
    INY
    LDA.B [_A],Y
    ORA.B _3
    STA.W Layer2VramBuffer+$80,X
    INX
    INX
    INY
    INY
    LDA.B [_A],Y
    ORA.B _3
    STA.W Layer2VramBuffer,X
    INY
    INY
    LDA.B [_A],Y
    ORA.B _3
    STA.W Layer2VramBuffer+$80,X
    INX
    INX
    LDA.B _8
    TAY
    CLC
    ADC.W #$0001
    STA.B _8
    AND.W #$000F
    BNE +
    TYA
    AND.W #$FFF0
    CLC
    ADC.W #$0100
    STA.B _8
  + LDA.B _8
    AND.W #$010F
    BNE CODE_058D1A
    PLP
    RTL

CODE_058D7A:
    PHP
    SEP #$30                                  ; AXY->8
    LDA.W LevelLoadObject
    AND.B #$0F
    ASL A
    STA.W Layer2VramAddr+1
    LDY.B #$30
    LDA.W LevelLoadObject
    AND.B #$10
    BEQ +
    LDY.B #$34
  + TYA
    STA.W Layer2VramAddr
    REP #$20                                  ; A->16
    LDA.W #$B900
    STA.B Map16LowPtr
    LDA.W #$BD00
    STA.B Map16HighPtr
    LDA.W #Map16BGTiles
    STA.B _A
    LDA.W LevelLoadObject
    AND.W #$00F0
    BEQ +
    LDA.B Map16LowPtr
    CLC
    ADC.W #$01B0
    STA.B Map16LowPtr
    LDA.B Map16HighPtr
    CLC
    ADC.W #$01B0
    STA.B Map16HighPtr
  + SEP #$20                                  ; A->8
    LDA.B #$7E
    STA.B Map16LowPtr+2
    LDA.B #$7E
    STA.B Map16HighPtr+2
    LDY.B #Map16BGTiles>>16
    STY.B _C
    REP #$30                                  ; AXY->16
    LDA.W LevelLoadObject
    AND.W #$000F
    STA.B _8
    LDX.W #$0000
  - LDY.B _8
    LDA.B [Map16LowPtr],Y
    AND.W #$00FF
    STA.B _0
    LDA.B [Map16HighPtr],Y
    STA.B _1
    LDA.B _0
    ASL A
    ASL A
    ASL A
    TAY
    LDA.B [_A],Y
    STA.W Layer2VramBuffer,X
    INY
    INY
    LDA.B [_A],Y
    STA.W Layer2VramBuffer+2,X
    INY
    INY
    LDA.B [_A],Y
    STA.W Layer2VramBuffer+$80,X
    INY
    INY
    LDA.B [_A],Y
    STA.W Layer2VramBuffer+$82,X
    INX
    INX
    INX
    INX
    LDA.B _8
    CLC
    ADC.W #$0010
    STA.B _8
    CMP.W #$01B0
    BCC -
    PLP
    RTL

    %insert_empty($1E7,$1E7,$1E7,$1E7,$1C2)

Layer3Ptr:
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Cage
    dl Tilemap_L3Tide
    dl Tilemap_L3Crusher
    dl Tilemap_L3Windows
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Cage
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Rocks
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Cage
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Clouds
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Cage
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Cage
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Cage
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Fish
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Cage
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Cage
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Cage
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Clouds
    dl Tilemap_L3Tide
    dl Tilemap_L3Tide
    dl Tilemap_L3Rocks

Tilemap_L3Cage:
    db $58,$06,$00,$03,$87,$39,$88,$39
    db $58,$12,$00,$03,$87,$39,$88,$39
    db $58,$26,$00,$03,$97,$39,$98,$39
    db $58,$2C,$00,$03,$87,$39,$88,$39
    db $58,$32,$00,$03,$97,$39,$98,$39
    db $58,$38,$00,$03,$87,$39,$88,$39
    db $58,$46,$00,$03,$85,$39,$86,$39
    db $58,$4C,$00,$03,$97,$39,$98,$39
    db $58,$52,$00,$03,$85,$39,$86,$39
    db $58,$58,$00,$03,$97,$39,$98,$39
    db $58,$66,$00,$03,$95,$39,$96,$39
    db $58,$6C,$00,$03,$95,$39,$96,$39
    db $58,$72,$00,$03,$95,$39,$96,$39
    db $58,$78,$00,$03,$95,$39,$96,$39
    db $58,$84,$00,$2F,$80,$3D,$81,$3D
    db $82,$3D,$82,$7D,$82,$3D,$82,$7D
    db $82,$3D,$82,$7D,$82,$3D,$82,$7D
    db $82,$3D,$82,$7D,$82,$3D,$82,$7D
    db $82,$3D,$82,$7D,$82,$3D,$82,$7D
    db $82,$3D,$82,$7D,$82,$3D,$82,$7D
    db $81,$7D,$80,$7D,$58,$A4,$00,$2F
    db $90,$3D,$91,$3D,$92,$3D,$92,$7D
    db $92,$3D,$92,$7D,$92,$3D,$92,$7D
    db $92,$3D,$92,$7D,$92,$3D,$92,$7D
    db $92,$3D,$92,$7D,$92,$3D,$92,$7D
    db $92,$3D,$92,$7D,$92,$3D,$92,$7D
    db $92,$3D,$92,$7D,$91,$7D,$90,$7D
    db $58,$C4,$80,$13,$83,$3D,$83,$BD
    db $83,$3D,$83,$BD,$83,$3D,$83,$BD
    db $83,$3D,$83,$BD,$83,$3D,$83,$BD
    db $58,$C5,$80,$13,$84,$3D,$84,$BD
    db $84,$3D,$84,$BD,$84,$3D,$84,$BD
    db $84,$3D,$84,$BD,$84,$3D,$84,$BD
    db $58,$C7,$C0,$12,$93,$39,$58,$C8
    db $C0,$12,$94,$39,$58,$C9,$C0,$12
    db $93,$39,$58,$CA,$C0,$12,$94,$39
    db $58,$CB,$C0,$12,$93,$39,$58,$CC
    db $C0,$12,$94,$39,$58,$CD,$C0,$12
    db $93,$39,$58,$CE,$C0,$12,$94,$39
    db $58,$CF,$C0,$12,$93,$39,$58,$D0
    db $C0,$12,$94,$39,$58,$D1,$C0,$12
    db $93,$39,$58,$D2,$C0,$12,$94,$39
    db $58,$D3,$C0,$12,$93,$39,$58,$D4
    db $C0,$12,$94,$39,$58,$D5,$C0,$12
    db $93,$39,$58,$D6,$C0,$12,$94,$39
    db $58,$D7,$C0,$12,$93,$39,$58,$D8
    db $C0,$12,$94,$39,$58,$DA,$80,$13
    db $83,$3D,$83,$BD,$83,$3D,$83,$BD
    db $83,$3D,$83,$BD,$83,$3D,$83,$BD
    db $83,$3D,$83,$BD,$58,$DB,$80,$13
    db $84,$3D,$84,$BD,$84,$3D,$84,$BD
    db $84,$3D,$84,$BD,$84,$3D,$84,$BD
    db $84,$3D,$84,$BD,$5A,$04,$00,$2F
    db $90,$BD,$91,$BD,$82,$3D,$82,$7D
    db $82,$3D,$82,$7D,$82,$3D,$82,$7D
    db $82,$3D,$82,$7D,$82,$3D,$82,$7D
    db $82,$3D,$82,$7D,$82,$3D,$82,$7D
    db $82,$3D,$82,$7D,$82,$3D,$82,$7D
    db $82,$3D,$82,$7D,$91,$FD,$90,$FD
    db $5A,$24,$00,$2F,$80,$BD,$81,$BD
    db $92,$3D,$92,$7D,$92,$3D,$92,$7D
    db $92,$3D,$92,$7D,$92,$3D,$92,$7D
    db $92,$3D,$92,$7D,$92,$3D,$92,$7D
    db $92,$3D,$92,$7D,$92,$3D,$92,$7D
    db $92,$3D,$92,$7D,$92,$3D,$92,$7D
    db $81,$FD,$80,$FD,$FF

Tilemap_L3Crusher:
    db $50,$A8,$00,$1F,$99,$3D,$9A,$3D
    db $A1,$AD,$B2,$2D,$B3,$2D,$B4,$2D
    db $A5,$AD,$B6,$2D,$B7,$2D,$B8,$2D
    db $B4,$2D,$BA,$2D,$BB,$2D,$BC,$2D
    db $FE,$2C,$FE,$2C,$50,$C8,$00,$1F
    db $8B,$3D,$8C,$3D,$C1,$2D,$C2,$2D
    db $C3,$2D,$B4,$AD,$A3,$2D,$A4,$2D
    db $C7,$2D,$C8,$2D,$B4,$AD,$BA,$AD
    db $D5,$2D,$CC,$2D,$FE,$2C,$FE,$2C
    db $50,$E8,$00,$1F,$9B,$3D,$9C,$3D
    db $D1,$2D,$D2,$2D,$D3,$2D,$B7,$AD
    db $D5,$2D,$B4,$2D,$D7,$2D,$C7,$2D
    db $D9,$2D,$D9,$6D,$DB,$2D,$DC,$2D
    db $FE,$2C,$FE,$2C,$51,$08,$00,$1F
    db $89,$3D,$8A,$3D,$A1,$2D,$A2,$2D
    db $A3,$2D,$A4,$2D,$A5,$2D,$B4,$AD
    db $D5,$2D,$C7,$AD,$FD,$2C,$AA,$2D
    db $AB,$2D,$AC,$2D,$FE,$2C,$FE,$2C
    db $51,$28,$00,$1F,$99,$3D,$9A,$3D
    db $A1,$AD,$B2,$2D,$B3,$2D,$B4,$2D
    db $A5,$AD,$B6,$2D,$B7,$2D,$B8,$2D
    db $B4,$2D,$BA,$2D,$BB,$2D,$BC,$2D
    db $FE,$2C,$FE,$2C,$51,$48,$00,$1F
    db $8B,$3D,$8C,$3D,$C1,$2D,$C2,$2D
    db $C3,$2D,$B4,$AD,$A3,$2D,$A4,$2D
    db $C7,$2D,$C8,$2D,$B4,$AD,$BA,$AD
    db $D5,$2D,$CC,$2D,$FE,$2C,$FE,$2C
    db $51,$68,$00,$1F,$9B,$3D,$9C,$3D
    db $D1,$2D,$D2,$2D,$D3,$2D,$B7,$AD
    db $D5,$2D,$B4,$2D,$D7,$2D,$C7,$2D
    db $D9,$2D,$D9,$6D,$DB,$2D,$DC,$2D
    db $FE,$2C,$FE,$2C,$51,$88,$00,$1F
    db $89,$3D,$8A,$3D,$A1,$2D,$A2,$2D
    db $A3,$2D,$A4,$2D,$A5,$2D,$B4,$AD
    db $D5,$2D,$C7,$AD,$FD,$2C,$AA,$2D
    db $AB,$2D,$AC,$2D,$FE,$2C,$FE,$2C
    db $51,$A8,$00,$1F,$99,$3D,$9A,$3D
    db $A1,$AD,$B2,$2D,$B3,$2D,$B4,$2D
    db $A5,$AD,$B6,$2D,$B7,$2D,$B8,$2D
    db $B4,$2D,$BA,$2D,$BB,$2D,$BC,$2D
    db $FE,$2C,$FE,$2C,$51,$C8,$00,$1F
    db $8B,$3D,$8C,$3D,$C1,$2D,$C2,$2D
    db $C3,$2D,$B4,$AD,$A3,$2D,$A4,$2D
    db $C7,$2D,$C8,$2D,$B4,$AD,$BA,$AD
    db $D5,$2D,$CC,$2D,$FE,$2C,$FE,$2C
    db $51,$E8,$00,$1F,$9B,$3D,$9C,$3D
    db $D1,$2D,$D2,$2D,$D3,$2D,$B7,$AD
    db $D5,$2D,$B4,$2D,$D7,$2D,$C7,$2D
    db $D9,$2D,$D9,$6D,$DB,$2D,$DC,$2D
    db $FE,$2C,$FE,$2C,$52,$08,$00,$1F
    db $89,$3D,$8A,$3D,$A1,$2D,$A2,$2D
    db $A3,$2D,$A4,$2D,$A5,$2D,$B4,$AD
    db $D5,$2D,$C7,$AD,$FD,$2C,$AA,$2D
    db $AB,$2D,$AC,$2D,$FE,$2C,$FE,$2C
    db $52,$28,$00,$1F,$99,$3D,$9A,$3D
    db $A1,$AD,$B2,$2D,$B3,$2D,$B4,$2D
    db $A5,$AD,$B6,$2D,$B7,$2D,$B8,$2D
    db $B4,$2D,$BA,$2D,$BB,$2D,$BC,$2D
    db $FE,$2C,$FE,$2C,$52,$48,$00,$1F
    db $8B,$3D,$8C,$3D,$C1,$2D,$C2,$2D
    db $C3,$2D,$B4,$AD,$A3,$2D,$A4,$2D
    db $C7,$2D,$C8,$2D,$B4,$AD,$BA,$AD
    db $D5,$2D,$CC,$2D,$FE,$2C,$FE,$2C
    db $52,$68,$00,$1F,$9B,$3D,$9C,$3D
    db $D1,$2D,$D2,$2D,$D3,$2D,$B7,$AD
    db $D5,$2D,$B4,$2D,$D7,$2D,$C7,$2D
    db $D9,$2D,$D9,$6D,$DB,$2D,$DC,$2D
    db $FE,$2C,$FE,$2C,$52,$88,$00,$1F
    db $89,$3D,$8A,$3D,$A1,$2D,$A2,$2D
    db $A3,$2D,$A4,$2D,$A5,$2D,$B4,$AD
    db $D5,$2D,$C7,$AD,$FD,$2C,$AA,$2D
    db $AB,$2D,$AC,$2D,$FE,$2C,$FE,$2C
    db $52,$A8,$00,$1F,$99,$3D,$9A,$3D
    db $A1,$AD,$B2,$2D,$B3,$2D,$B4,$2D
    db $A5,$AD,$B6,$2D,$B7,$2D,$B8,$2D
    db $B4,$2D,$BA,$2D,$BB,$2D,$BC,$2D
    db $FE,$2C,$FE,$2C,$52,$C7,$00,$23
    db $CD,$2D,$CE,$2D,$CF,$2D,$E1,$2D
    db $E2,$2D,$E3,$2D,$E4,$2D,$E5,$2D
    db $E6,$2D,$E7,$2D,$E8,$2D,$E9,$2D
    db $EA,$2D,$EB,$2D,$EC,$2D,$ED,$2D
    db $EE,$2D,$CD,$6D,$52,$E7,$00,$23
    db $DD,$2D,$DE,$2D,$DF,$2D,$F1,$2D
    db $F2,$2D,$DE,$2D,$DF,$2D,$F1,$2D
    db $F2,$2D,$DE,$2D,$DF,$2D,$F1,$2D
    db $F2,$2D,$DE,$2D,$DF,$2D,$F1,$2D
    db $F2,$2D,$DD,$6D,$FF

Tilemap_L3Tide:
    db $58,$00,$00,$3F,$7D,$39,$7E,$39
    db $7D,$39,$7E,$39,$7D,$39,$7E,$39
    db $7D,$39,$7E,$39,$7D,$39,$7E,$39
    db $7D,$39,$7E,$39,$7D,$39,$7E,$39
    db $7D,$39,$7E,$39,$7D,$39,$7E,$39
    db $7D,$39,$7E,$39,$7D,$39,$7E,$39
    db $7D,$39,$7E,$39,$7D,$39,$7E,$39
    db $7D,$39,$7E,$39,$7D,$39,$7E,$39
    db $7D,$39,$7E,$39,$58,$20,$47,$7E
    db $8E,$39,$5C,$00,$00,$3F,$7D,$39
    db $7E,$39,$7D,$39,$7E,$39,$7D,$39
    db $7E,$39,$7D,$39,$7E,$39,$7D,$39
    db $7E,$39,$7D,$39,$7E,$39,$7D,$39
    db $7E,$39,$7D,$39,$7E,$39,$7D,$39
    db $7E,$39,$7D,$39,$7E,$39,$7D,$39
    db $7E,$39,$7D,$39,$7E,$39,$7D,$39
    db $7E,$39,$7D,$39,$7E,$39,$7D,$39
    db $7E,$39,$7D,$39,$7E,$39,$5C,$20
    db $47,$7E,$8E,$39,$FF

Tilemap_L3Clouds:
    db $53,$A0,$00,$03,$FF,$60,$9E,$61
    db $53,$B8,$00,$01,$9E,$21,$53,$B9
    db $40,$0C,$FF,$20,$53,$C0,$00,$03
    db $FF,$60,$9E,$E1,$53,$D8,$00,$01
    db $9E,$A1,$53,$D9,$40,$0C,$FF,$20
    db $53,$E0,$40,$08,$FF,$60,$53,$E5
    db $00,$01,$9E,$61,$53,$EA,$00,$0B
    db $9E,$21,$FF,$20,$FF,$20,$FF,$20
    db $FF,$60,$9E,$61,$53,$FB,$00,$01
    db $9E,$21,$53,$FC,$40,$06,$FF,$20
    db $58,$00,$40,$08,$FF,$60,$58,$05
    db $00,$01,$9E,$E1,$58,$0A,$00,$0B
    db $9E,$A1,$FF,$20,$FF,$20,$FF,$20
    db $FF,$60,$9E,$E1,$58,$1B,$00,$01
    db $9E,$A1,$58,$1C,$40,$06,$FF,$20
    db $58,$60,$80,$0F,$FF,$20,$FF,$20
    db $8F,$61,$8F,$E1,$FF,$20,$FF,$20
    db $FF,$60,$FF,$60,$58,$61,$80,$0F
    db $FF,$20,$FF,$20,$FC,$60,$FC,$60
    db $FF,$20,$FF,$20,$9E,$61,$9E,$E1
    db $58,$62,$00,$03,$FF,$60,$9E,$61
    db $58,$82,$00,$03,$FF,$60,$9E,$E1
    db $58,$E2,$40,$06,$FF,$20,$58,$E6
    db $00,$03,$FF,$60,$9E,$61,$59,$02
    db $40,$06,$FF,$20,$59,$06,$00,$03
    db $FF,$60,$9E,$E1,$58,$6C,$00,$01
    db $9E,$21,$58,$6D,$40,$24,$FF,$20
    db $58,$8C,$00,$01,$9E,$A1,$58,$8D
    db $40,$24,$FF,$20,$58,$B2,$00,$01
    db $9E,$21,$58,$B3,$40,$18,$FF,$20
    db $58,$D2,$00,$01,$9E,$A1,$58,$D3
    db $40,$18,$FF,$20,$58,$FC,$00,$07
    db $FC,$20,$8F,$21,$FF,$20,$FF,$20
    db $59,$1C,$00,$07,$FC,$20,$8F,$A1
    db $FF,$20,$FF,$20,$59,$2E,$00,$0B
    db $9E,$21,$FF,$20,$FF,$20,$FF,$20
    db $FF,$60,$9E,$61,$59,$4E,$00,$0B
    db $9E,$A1,$FF,$20,$FF,$20,$FF,$20
    db $FF,$60,$9E,$E1,$59,$38,$00,$01
    db $9E,$21,$59,$39,$40,$0C,$FF,$20
    db $59,$58,$00,$01,$9E,$A1,$59,$59
    db $40,$0C,$FF,$20,$59,$A4,$00,$01
    db $9E,$21,$59,$A5,$40,$0E,$FF,$20
    db $59,$AD,$00,$05,$FF,$60,$FF,$60
    db $9E,$61,$59,$C4,$00,$01,$9E,$A1
    db $59,$C5,$40,$0E,$FF,$20,$59,$CD
    db $00,$05,$FF,$60,$FF,$60,$9E,$E1
    db $59,$E0,$00,$03,$FF,$60,$9E,$61
    db $5A,$00,$00,$03,$FF,$60,$9E,$E1
    db $59,$E8,$00,$01,$9E,$21,$59,$E9
    db $40,$12,$FF,$20,$59,$F3,$00,$05
    db $FF,$60,$FF,$60,$9E,$61,$5A,$08
    db $00,$01,$9E,$A1,$5A,$09,$40,$12
    db $FF,$20,$5A,$13,$00,$05,$FF,$60
    db $FF,$60,$9E,$E1,$59,$FC,$00,$07
    db $9E,$21,$FF,$20,$FF,$20,$FF,$20
    db $5A,$1C,$00,$07,$9E,$A1,$FF,$20
    db $FF,$20,$FF,$20,$5A,$2E,$00,$03
    db $FC,$20,$8F,$21,$5A,$30,$40,$0C
    db $FF,$20,$5A,$37,$00,$05,$FF,$60
    db $FF,$60,$9E,$61,$5A,$4E,$00,$03
    db $FC,$20,$8F,$A1,$5A,$50,$40,$0C
    db $FF,$20,$5A,$57,$00,$05,$FF,$60
    db $FF,$60,$9E,$E1,$5A,$6C,$00,$0B
    db $9E,$21,$FF,$20,$FF,$20,$FF,$20
    db $FF,$60,$9E,$61,$5A,$8C,$00,$0B
    db $9E,$A1,$FF,$20,$FF,$20,$FF,$20
    db $FF,$60,$9E,$E1,$57,$A0,$00,$03
    db $FF,$60,$9E,$61,$57,$B8,$00,$01
    db $9E,$21,$57,$B9,$40,$0C,$FF,$20
    db $57,$C0,$00,$03,$FF,$60,$9E,$E1
    db $57,$D8,$00,$01,$9E,$A1,$57,$D9
    db $40,$0C,$FF,$20,$57,$E0,$40,$08
    db $FF,$60,$57,$E5,$00,$01,$9E,$61
    db $57,$EA,$00,$0B,$9E,$21,$FF,$20
    db $FF,$20,$FF,$20,$FF,$20,$9E,$61
    db $57,$FB,$00,$01,$9E,$21,$57,$FC
    db $40,$06,$FF,$20,$5C,$00,$40,$08
    db $FF,$60,$5C,$05,$00,$01,$9E,$E1
    db $5C,$0A,$00,$0B,$9E,$A1,$FF,$20
    db $FF,$20,$FF,$20,$FF,$60,$9E,$E1
    db $5C,$1B,$00,$01,$9E,$A1,$5C,$1C
    db $40,$06,$FF,$20,$5C,$60,$80,$0F
    db $FF,$20,$FF,$20,$8F,$61,$8F,$E1
    db $FF,$20,$FF,$20,$FF,$60,$FF,$60
    db $5C,$61,$80,$0F,$FF,$20,$FF,$20
    db $FC,$60,$FC,$60,$FF,$20,$FF,$20
    db $9E,$61,$9E,$E1,$5C,$62,$00,$03
    db $FF,$60,$9E,$61,$5C,$82,$00,$03
    db $FF,$60,$9E,$E1,$5C,$E2,$40,$06
    db $FF,$20,$5C,$E6,$00,$03,$FF,$60
    db $9E,$61,$5D,$02,$40,$06,$FF,$20
    db $5D,$06,$00,$03,$FF,$60,$9E,$E1
    db $5C,$6C,$00,$01,$9E,$21,$5C,$6D
    db $40,$24,$FF,$20,$5C,$8C,$00,$01
    db $9E,$A1,$5C,$8D,$40,$24,$FF,$20
    db $5C,$B2,$00,$01,$9E,$21,$5C,$B3
    db $40,$18,$FF,$20,$5C,$D2,$00,$01
    db $9E,$A1,$5C,$D3,$40,$18,$FF,$20
    db $5C,$FC,$00,$07,$FC,$20,$8F,$21
    db $FF,$20,$FF,$20,$5D,$1C,$00,$07
    db $FC,$20,$8F,$A1,$FF,$20,$FF,$20
    db $5D,$2E,$00,$0B,$9E,$21,$FF,$20
    db $FF,$20,$FF,$20,$FF,$60,$9E,$61
    db $5D,$4E,$00,$0B,$9E,$A1,$FF,$20
    db $FF,$20,$FF,$20,$FF,$60,$9E,$E1
    db $5D,$38,$00,$01,$9E,$21,$5D,$39
    db $40,$0C,$FF,$20,$5D,$58,$00,$01
    db $9E,$A1,$5D,$59,$40,$0C,$FF,$20
    db $5D,$A4,$00,$01,$9E,$21,$5D,$A5
    db $40,$0E,$FF,$20,$5D,$AD,$00,$05
    db $FF,$60,$FF,$60,$9E,$61,$5D,$C4
    db $00,$01,$9E,$A1,$5D,$C5,$40,$0E
    db $FF,$20,$5D,$CD,$00,$05,$FF,$60
    db $FF,$60,$9E,$E1,$5D,$E0,$00,$03
    db $FF,$60,$9E,$61,$5E,$00,$00,$03
    db $FF,$60,$9E,$E1,$5D,$E8,$00,$01
    db $9E,$21,$5D,$E9,$40,$12,$FF,$20
    db $5D,$F3,$00,$05,$FF,$60,$FF,$60
    db $9E,$61,$5E,$08,$00,$01,$9E,$A1
    db $5E,$09,$40,$12,$FF,$20,$5E,$13
    db $00,$05,$FF,$60,$FF,$60,$9E,$E1
    db $5D,$FC,$00,$07,$9E,$21,$FF,$20
    db $FF,$20,$FF,$20,$5E,$1C,$00,$07
    db $9E,$A1,$FF,$20,$FF,$20,$FF,$20
    db $5E,$2E,$00,$03,$FC,$20,$8F,$21
    db $5E,$30,$40,$0C,$FF,$20,$5E,$37
    db $00,$05,$FF,$60,$FF,$60,$9E,$61
    db $5E,$4E,$00,$03,$FC,$20,$8F,$A1
    db $5E,$50,$40,$0C,$FF,$20,$5E,$57
    db $00,$05,$FF,$60,$FF,$60,$9E,$E1
    db $5E,$6C,$00,$0B,$9E,$21,$FF,$20
    db $FF,$20,$FF,$20,$FF,$60,$9E,$61
    db $5E,$8C,$00,$0B,$9E,$A1,$FF,$20
    db $FF,$20,$FF,$20,$FF,$60,$9E,$E1
    db $FF

Tilemap_L3Fish:
    db $51,$67,$00,$01,$9F,$39,$51,$93
    db $00,$01,$9F,$29,$51,$D1,$00,$01
    db $9F,$39,$52,$5A,$00,$01,$9F,$39
    db $52,$77,$00,$01,$9F,$29,$52,$79
    db $80,$03,$9F,$29,$9F,$39,$52,$8C
    db $00,$01,$9F,$29,$53,$3D,$00,$01
    db $9F,$39,$55,$67,$00,$01,$9F,$39
    db $55,$93,$00,$01,$9F,$29,$55,$D1
    db $00,$01,$9F,$39,$56,$5A,$00,$01
    db $9F,$39,$56,$77,$00,$01,$9F,$29
    db $56,$79,$80,$03,$9F,$29,$9F,$39
    db $56,$8C,$00,$01,$9F,$29,$57,$3D
    db $00,$01,$9F,$39,$58,$07,$00,$01
    db $9F,$39,$58,$33,$00,$01,$9F,$29
    db $58,$71,$00,$01,$9F,$39,$58,$FA
    db $00,$01,$9F,$39,$59,$17,$00,$01
    db $9F,$29,$59,$19,$80,$03,$9F,$29
    db $9F,$39,$59,$2C,$00,$01,$9F,$29
    db $59,$DD,$00,$01,$9F,$39,$5C,$07
    db $00,$01,$9F,$39,$5C,$33,$00,$01
    db $9F,$29,$5C,$71,$00,$01,$9F,$39
    db $5C,$FA,$00,$01,$9F,$39,$5D,$17
    db $00,$01,$9F,$29,$5D,$19,$80,$03
    db $9F,$29,$9F,$39,$5D,$2C,$00,$01
    db $9F,$29,$5D,$DD,$00,$01,$9F,$39
    db $FF

Tilemap_L3Windows:
    db $58,$03,$00,$03,$80,$01,$81,$01
    db $58,$07,$00,$03,$80,$01,$81,$01
    db $58,$0F,$00,$07,$80,$01,$81,$01
    db $80,$01,$81,$01,$58,$15,$00,$0B
    db $80,$01,$81,$01,$80,$01,$81,$01
    db $80,$01,$81,$01,$58,$20,$00,$0F
    db $80,$01,$81,$01,$86,$15,$87,$15
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $58,$22,$80,$05,$86,$15,$96,$15
    db $90,$15,$58,$23,$80,$05,$87,$15
    db $97,$15,$91,$15,$58,$2C,$80,$05
    db $86,$15,$96,$15,$90,$15,$58,$2D
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $58,$2F,$80,$05,$86,$15,$96,$15
    db $90,$15,$58,$30,$80,$05,$87,$15
    db $97,$15,$91,$15,$58,$32,$80,$05
    db $86,$15,$96,$15,$90,$15,$58,$33
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $58,$36,$00,$03,$80,$01,$81,$01
    db $58,$3A,$00,$03,$80,$01,$81,$01
    db $58,$3C,$80,$05,$86,$15,$96,$15
    db $90,$15,$58,$3D,$80,$05,$87,$15
    db $97,$15,$91,$15,$58,$45,$00,$03
    db $82,$15,$83,$15,$58,$8D,$00,$03
    db $80,$01,$81,$01,$58,$9E,$00,$03
    db $80,$01,$81,$01,$58,$BD,$00,$03
    db $80,$01,$81,$01,$58,$C7,$00,$03
    db $80,$01,$81,$01,$58,$D9,$00,$01
    db $81,$01,$58,$DC,$00,$07,$80,$01
    db $81,$01,$82,$15,$83,$15,$58,$E4
    db $00,$03,$80,$01,$81,$01,$58,$E8
    db $00,$07,$80,$01,$81,$01,$80,$01
    db $81,$01,$58,$F9,$00,$0D,$80,$01
    db $81,$01,$80,$01,$81,$01,$82,$15
    db $83,$15,$82,$15,$59,$02,$80,$05
    db $86,$15,$96,$15,$90,$15,$59,$03
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $59,$05,$00,$0B,$80,$01,$81,$01
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $59,$0C,$80,$05,$86,$15,$96,$15
    db $90,$15,$59,$0D,$80,$05,$87,$15
    db $97,$15,$91,$15,$59,$0F,$80,$05
    db $86,$15,$96,$15,$90,$15,$59,$10
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $59,$12,$80,$05,$86,$15,$96,$15
    db $90,$15,$59,$13,$80,$05,$87,$15
    db $97,$15,$91,$15,$59,$1A,$00,$0B
    db $80,$01,$81,$01,$86,$15,$87,$15
    db $82,$15,$83,$15,$59,$1C,$80,$05
    db $86,$15,$96,$15,$90,$15,$59,$1D
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $59,$24,$00,$0F,$80,$01,$81,$01
    db $82,$15,$83,$15,$82,$15,$83,$15
    db $80,$01,$81,$01,$59,$39,$00,$03
    db $80,$01,$81,$01,$59,$47,$00,$07
    db $80,$01,$81,$01,$82,$15,$83,$15
    db $59,$5A,$00,$0B,$80,$01,$81,$01
    db $90,$15,$91,$15,$80,$01,$81,$01
    db $59,$64,$00,$17,$80,$01,$81,$01
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $80,$01,$81,$01,$80,$01,$81,$01
    db $80,$01,$81,$01,$59,$87,$00,$03
    db $80,$01,$81,$01,$59,$8B,$00,$07
    db $80,$01,$81,$01,$80,$01,$81,$01
    db $59,$98,$00,$03,$80,$01,$81,$01
    db $59,$A8,$00,$07,$80,$01,$81,$01
    db $82,$15,$83,$15,$59,$B9,$00,$03
    db $80,$01,$81,$01,$59,$C5,$00,$03
    db $80,$01,$81,$01,$59,$C9,$00,$07
    db $80,$01,$81,$01,$80,$01,$81,$01
    db $59,$D6,$00,$0F,$80,$01,$81,$01
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $80,$01,$81,$01,$59,$E2,$80,$05
    db $86,$15,$96,$15,$90,$15,$59,$E3
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $59,$EA,$00,$0B,$80,$01,$81,$01
    db $86,$15,$87,$15,$82,$15,$83,$15
    db $59,$EC,$80,$05,$86,$15,$96,$15
    db $90,$15,$59,$ED,$80,$05,$87,$15
    db $97,$15,$91,$15,$59,$EF,$80,$05
    db $86,$15,$96,$15,$90,$15,$59,$F0
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $59,$F2,$80,$05,$86,$15,$96,$15
    db $90,$15,$59,$F3,$80,$05,$87,$15
    db $97,$15,$91,$15,$59,$F7,$00,$07
    db $82,$15,$83,$15,$82,$15,$83,$15
    db $59,$FC,$80,$05,$86,$15,$96,$15
    db $90,$15,$59,$FD,$80,$05,$87,$15
    db $97,$15,$91,$15,$5A,$14,$00,$0F
    db $80,$01,$81,$01,$82,$15,$83,$15
    db $80,$01,$81,$01,$82,$15,$83,$15
    db $5A,$20,$00,$01,$81,$01,$5A,$27
    db $00,$03,$80,$01,$81,$01,$5A,$35
    db $00,$0B,$80,$01,$81,$01,$80,$01
    db $81,$01,$82,$15,$83,$15,$5A,$40
    db $00,$07,$80,$01,$81,$01,$80,$01
    db $81,$01,$5A,$56,$00,$03,$80,$01
    db $81,$01,$5A,$5A,$00,$03,$80,$01
    db $81,$01,$5A,$60,$00,$09,$81,$01
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $5A,$67,$00,$03,$80,$01,$81,$01
    db $5A,$79,$00,$07,$80,$01,$81,$01
    db $80,$01,$81,$01,$5A,$80,$00,$0B
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $80,$01,$81,$01,$5A,$98,$00,$03
    db $80,$01,$81,$01,$5A,$9C,$00,$03
    db $80,$01,$81,$01,$5A,$A0,$00,$05
    db $83,$15,$80,$01,$81,$01,$5A,$A5
    db $00,$07,$80,$01,$81,$01,$80,$01
    db $81,$01,$5A,$C0,$00,$07,$82,$15
    db $83,$15,$82,$15,$83,$15,$5A,$C6
    db $00,$03,$80,$01,$81,$01,$5A,$CA
    db $00,$03,$80,$01,$81,$01,$5A,$E0
    db $00,$0D,$83,$15,$82,$15,$83,$15
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $5A,$E9,$00,$03,$80,$01,$81,$01
    db $5C,$03,$00,$03,$80,$01,$81,$01
    db $5C,$07,$00,$03,$80,$01,$81,$01
    db $5C,$0F,$00,$07,$80,$01,$81,$01
    db $80,$01,$81,$01,$5C,$15,$00,$0B
    db $80,$01,$81,$01,$80,$01,$81,$01
    db $80,$01,$81,$01,$5C,$20,$00,$0F
    db $80,$01,$81,$01,$86,$15,$87,$15
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $5C,$22,$80,$05,$86,$15,$96,$15
    db $90,$15,$5C,$23,$80,$05,$87,$15
    db $97,$15,$91,$15,$5C,$2C,$80,$05
    db $86,$15,$96,$15,$90,$15,$5C,$2D
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $5C,$2F,$80,$05,$86,$15,$96,$15
    db $90,$15,$5C,$30,$80,$05,$87,$15
    db $97,$15,$91,$15,$5C,$32,$80,$05
    db $86,$15,$96,$15,$90,$15,$5C,$33
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $5C,$36,$00,$03,$80,$01,$81,$01
    db $5C,$3A,$00,$03,$80,$01,$81,$01
    db $5C,$3C,$80,$05,$86,$15,$96,$15
    db $90,$15,$5C,$3D,$80,$05,$87,$15
    db $97,$15,$91,$15,$5C,$45,$00,$03
    db $82,$15,$83,$15,$5C,$8D,$00,$03
    db $80,$01,$81,$01,$5C,$9E,$00,$03
    db $80,$01,$81,$01,$5C,$BD,$00,$03
    db $80,$01,$81,$01,$5C,$C7,$00,$03
    db $80,$01,$81,$01,$5C,$D9,$00,$01
    db $81,$01,$5C,$DC,$00,$07,$80,$01
    db $81,$01,$82,$15,$83,$15,$5C,$E4
    db $00,$03,$80,$01,$81,$01,$5C,$E8
    db $00,$07,$80,$01,$81,$01,$80,$01
    db $81,$01,$5C,$F9,$00,$0D,$80,$01
    db $81,$01,$80,$01,$81,$01,$82,$15
    db $83,$15,$82,$15,$5D,$02,$80,$05
    db $86,$15,$96,$15,$90,$15,$5D,$03
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $5D,$05,$00,$0B,$80,$01,$81,$01
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $5D,$0C,$80,$05,$86,$15,$96,$15
    db $90,$15,$5D,$0D,$80,$05,$87,$15
    db $97,$15,$91,$15,$5D,$0F,$80,$05
    db $86,$15,$96,$15,$90,$15,$5D,$10
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $5D,$12,$80,$05,$86,$15,$96,$15
    db $90,$15,$5D,$13,$80,$05,$87,$15
    db $97,$15,$91,$15,$5D,$1A,$00,$0B
    db $80,$01,$81,$01,$86,$15,$87,$15
    db $82,$15,$83,$15,$5D,$1C,$80,$05
    db $86,$15,$96,$15,$90,$15,$5D,$1D
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $5D,$24,$00,$0F,$80,$01,$81,$01
    db $82,$15,$83,$15,$82,$15,$83,$15
    db $80,$01,$81,$01,$5D,$39,$00,$03
    db $80,$01,$81,$01,$5D,$47,$00,$07
    db $80,$01,$81,$01,$82,$15,$83,$15
    db $5D,$5A,$00,$0B,$80,$01,$81,$01
    db $90,$15,$91,$15,$80,$01,$81,$01
    db $5D,$64,$00,$17,$80,$01,$81,$01
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $80,$01,$81,$01,$80,$01,$81,$01
    db $80,$01,$81,$01,$5D,$87,$00,$03
    db $80,$01,$81,$01,$5D,$8B,$00,$07
    db $80,$01,$81,$01,$80,$01,$81,$01
    db $5D,$98,$00,$03,$80,$01,$81,$01
    db $5D,$A8,$00,$07,$80,$01,$81,$01
    db $82,$15,$83,$15,$5D,$B9,$00,$03
    db $80,$01,$81,$01,$5D,$C5,$00,$03
    db $80,$01,$81,$01,$5D,$C9,$00,$07
    db $80,$01,$81,$01,$80,$01,$81,$01
    db $5D,$D6,$00,$0F,$80,$01,$81,$01
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $80,$01,$81,$01,$5D,$E2,$80,$05
    db $86,$15,$96,$15,$90,$15,$5D,$E3
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $5D,$EA,$00,$0B,$80,$01,$81,$01
    db $86,$15,$87,$15,$82,$15,$83,$15
    db $5D,$EC,$80,$05,$86,$15,$96,$15
    db $90,$15,$5D,$ED,$80,$05,$87,$15
    db $97,$15,$91,$15,$5D,$EF,$80,$05
    db $86,$15,$96,$15,$90,$15,$5D,$F0
    db $80,$05,$87,$15,$97,$15,$91,$15
    db $5D,$F2,$80,$05,$86,$15,$96,$15
    db $90,$15,$5D,$F3,$80,$05,$87,$15
    db $97,$15,$91,$15,$5D,$F7,$00,$07
    db $82,$15,$83,$15,$82,$15,$83,$15
    db $5D,$FC,$80,$05,$86,$15,$96,$15
    db $90,$15,$5D,$FD,$80,$05,$87,$15
    db $97,$15,$91,$15,$5E,$14,$00,$0F
    db $80,$01,$81,$01,$82,$15,$83,$15
    db $80,$01,$81,$01,$82,$15,$83,$15
    db $5E,$20,$00,$01,$81,$01,$5E,$27
    db $00,$03,$80,$01,$81,$01,$5E,$35
    db $00,$0B,$80,$01,$81,$01,$80,$01
    db $81,$01,$82,$15,$83,$15,$5E,$40
    db $00,$07,$80,$01,$81,$01,$80,$01
    db $81,$01,$5E,$56,$00,$03,$80,$01
    db $81,$01,$5E,$5A,$00,$03,$80,$01
    db $81,$01,$5E,$60,$00,$09,$81,$01
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $5E,$67,$00,$03,$80,$01,$81,$01
    db $5E,$79,$00,$07,$80,$01,$81,$01
    db $80,$01,$81,$01,$5E,$80,$00,$0B
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $80,$01,$81,$01,$5E,$98,$00,$03
    db $80,$01,$81,$01,$5E,$9C,$00,$03
    db $80,$01,$81,$01,$5E,$A0,$00,$05
    db $83,$15,$80,$01,$81,$01,$5E,$A5
    db $00,$07,$80,$01,$81,$01,$80,$01
    db $81,$01,$5E,$C0,$00,$07,$82,$15
    db $83,$15,$82,$15,$83,$15,$5E,$C6
    db $00,$03,$80,$01,$81,$01,$5E,$CA
    db $00,$03,$80,$01,$81,$01,$5E,$E0
    db $00,$0D,$83,$15,$82,$15,$83,$15
    db $82,$15,$83,$15,$80,$01,$81,$01
    db $5E,$E9,$00,$03,$80,$01,$81,$01
    db $FF

Tilemap_L3Rocks:
    db $53,$DA,$00,$05,$F9,$11,$FA,$11
    db $FB,$11,$53,$FA,$00,$05,$FC,$11
    db $FD,$11,$FE,$11,$58,$3C,$00,$01
    db $DA,$11,$58,$6D,$00,$05,$F9,$11
    db $FA,$11,$FB,$11,$58,$8D,$00,$05
    db $FC,$11,$FD,$11,$FE,$11,$58,$E5
    db $00,$07,$92,$11,$95,$11,$98,$11
    db $AD,$11,$59,$05,$00,$07,$B1,$11
    db $B5,$11,$C4,$51,$B9,$11,$59,$25
    db $00,$07,$BD,$11,$C4,$11,$C4,$51
    db $D8,$11,$59,$45,$00,$0D,$D6,$11
    db $D8,$11,$C9,$11,$CA,$11,$F9,$15
    db $FA,$15,$FB,$15,$59,$65,$00,$0D
    db $C9,$11,$CA,$11,$CB,$11,$DA,$11
    db $FC,$15,$FD,$15,$FE,$15,$59,$85
    db $00,$0D,$CB,$11,$DA,$11,$CB,$11
    db $92,$11,$95,$11,$98,$11,$AD,$11
    db $59,$A4,$00,$0F,$F3,$11,$F4,$11
    db $F5,$11,$FC,$38,$B1,$11,$B5,$11
    db $C4,$51,$B9,$11,$59,$C4,$00,$0F
    db $F6,$11,$F7,$11,$F8,$11,$DA,$05
    db $BD,$11,$C4,$11,$C4,$51,$D8,$11
    db $59,$CF,$00,$05,$F9,$15,$FA,$15
    db $FB,$15,$59,$E3,$00,$1D,$CB,$15
    db $FC,$11,$FD,$11,$FE,$11,$FC,$38
    db $D6,$11,$D8,$11,$C9,$11,$CA,$11
    db $F3,$15,$F4,$15,$F5,$15,$FC,$15
    db $FD,$15,$FE,$15,$5A,$08,$00,$17
    db $C9,$11,$CA,$11,$CB,$11,$DA,$11
    db $F6,$15,$F7,$15,$F8,$15,$F9,$55
    db $FC,$0D,$F3,$15,$F4,$15,$F5,$15
    db $5A,$28,$00,$19,$CB,$11,$DA,$11
    db $CB,$11,$DA,$11,$FD,$15,$FD,$15
    db $FE,$15,$DA,$55,$F9,$15,$F6,$15
    db $F7,$15,$F8,$15,$FB,$15,$5A,$49
    db $00,$17,$DA,$15,$F9,$05,$FA,$05
    db $FB,$05,$FC,$38,$FC,$38,$DA,$15
    db $FE,$15,$FC,$15,$FD,$15,$FE,$15
    db $DA,$55,$5A,$6A,$00,$09,$FC,$05
    db $FD,$05,$FE,$05,$FC,$38,$DA,$05
    db $58,$F6,$00,$05,$F9,$11,$FA,$11
    db $FB,$11,$59,$13,$00,$0B,$F9,$11
    db $FA,$11,$FB,$11,$FC,$11,$FD,$11
    db $FE,$11,$59,$31,$00,$09,$F9,$15
    db $FA,$15,$FB,$15,$FD,$11,$FE,$11
    db $59,$51,$00,$11,$FC,$15,$FD,$15
    db $FE,$15,$F3,$11,$F4,$11,$F5,$11
    db $FC,$11,$FD,$11,$FE,$11,$59,$72
    db $00,$0B,$FC,$15,$F9,$15,$F6,$11
    db $F7,$11,$F8,$11,$DA,$51,$59,$92
    db $00,$0D,$DA,$15,$FE,$15,$FC,$11
    db $FD,$11,$FE,$11,$FC,$11,$DA,$55
    db $57,$DA,$00,$05,$F9,$11,$FA,$11
    db $FB,$11,$57,$FA,$00,$05,$FC,$11
    db $FD,$11,$FE,$11,$5C,$3C,$00,$01
    db $DA,$11,$5C,$6D,$00,$05,$F9,$11
    db $FA,$11,$FB,$11,$5C,$8D,$00,$05
    db $FC,$11,$FD,$11,$FE,$11,$5C,$E5
    db $00,$07,$92,$11,$95,$11,$98,$11
    db $AD,$11,$5D,$05,$00,$07,$B1,$11
    db $B5,$11,$C4,$51,$B9,$11,$5D,$25
    db $00,$07,$BD,$11,$C4,$11,$C4,$51
    db $D8,$11,$5D,$45,$00,$0D,$D6,$11
    db $D8,$11,$C9,$11,$CA,$11,$F9,$51
    db $FA,$51,$FB,$51,$5D,$65,$00,$0D
    db $C9,$11,$CA,$11,$CB,$11,$DA,$11
    db $FC,$51,$FD,$51,$FE,$51,$5D,$85
    db $00,$0D,$CB,$11,$DA,$11,$CB,$11
    db $92,$11,$95,$11,$98,$11,$AD,$11
    db $5D,$A4,$00,$0F,$F3,$11,$F4,$11
    db $F5,$11,$FC,$38,$B1,$11,$B5,$11
    db $C4,$51,$B9,$11,$5D,$C4,$00,$0F
    db $F6,$11,$F7,$11,$F8,$11,$DA,$05
    db $BD,$11,$C4,$11,$C4,$51,$D8,$11
    db $5D,$CF,$00,$05,$F9,$15,$FA,$15
    db $FB,$15,$5D,$E3,$00,$1D,$CB,$15
    db $FC,$11,$FD,$11,$FE,$11,$FC,$38
    db $D6,$11,$D8,$11,$C9,$11,$CA,$11
    db $F3,$15,$F4,$15,$F5,$15,$FC,$15
    db $FD,$15,$FE,$15,$5E,$08,$00,$17
    db $C9,$11,$CA,$11,$CB,$11,$DA,$11
    db $F6,$15,$F7,$15,$F8,$15,$F9,$55
    db $FC,$0D,$F3,$15,$F4,$15,$F5,$15
    db $5E,$28,$00,$19,$CB,$11,$DA,$11
    db $CB,$11,$DA,$11,$FD,$15,$FD,$15
    db $FE,$15,$DA,$55,$F9,$15,$F6,$15
    db $F7,$15,$F8,$15,$FB,$15,$5E,$49
    db $00,$17,$DA,$15,$F9,$05,$FA,$05
    db $FB,$05,$FC,$38,$FC,$38,$DA,$15
    db $FE,$15,$FC,$15,$FD,$15,$FE,$15
    db $DA,$55,$5E,$6A,$00,$09,$FC,$05
    db $FD,$05,$FE,$05,$FC,$38,$DA,$05
    db $5C,$F6,$00,$05,$F9,$11,$FA,$11
    db $FB,$11,$5D,$13,$00,$0B,$F9,$11
    db $FA,$11,$FB,$11,$FC,$11,$FD,$11
    db $FE,$11,$5D,$31,$00,$09,$F9,$15
    db $FA,$15,$FB,$15,$FD,$11,$FE,$11
    db $5D,$51,$00,$11,$FC,$15,$FD,$15
    db $FE,$15,$F3,$11,$F4,$11,$F5,$11
    db $FC,$11,$FD,$11,$FE,$11,$5D,$72
    db $00,$0B,$FC,$15,$F9,$15,$F6,$11
    db $F7,$11,$F8,$11,$DA,$51,$5D,$92
    db $00,$0D,$DA,$15,$FE,$15,$FC,$11
    db $FD,$11,$FE,$11,$FC,$11,$DA,$55
    db $FF

    %insert_empty($1E,$1E,$1E,$1E,$1E)

DATA_05A580:
if ver_is_japanese(!_VER)                     ;\======================== J ====================
    db $51,$67,$51,$27,$50,$E7,$50,$A7        ;!
else                                          ;<================ U, SS, E0, & E1 ==============
    db $51,$A7,$51,$87,$51,$67,$51,$47        ;!
    db $51,$27,$51,$07,$50,$E7,$50,$C7        ;!
endif                                         ;/===============================================

DATA_05A590:
    db $14,$45,$3F,$08,$00,$29,$AA,$27
    db $26,$84,$95,$A9,$15,$13,$CE,$A7
    db $A4,$25,$A5,$05,$A6,$2A,$28

DATA_05A5A7:
    dw SwitchMessage-MessageBoxes
    dw SwitchMessage-MessageBoxes
    dw SwitchMessage-MessageBoxes
    dw SwitchMessage-MessageBoxes
    dw IntroMessage-MessageBoxes
    dw ItemBoxMessage-MessageBoxes
    dw MidwayMessage-MessageBoxes
    dw JumpHighMessage-MessageBoxes
    dw BonusStarsMessage-MessageBoxes
    dw GhostHouseMessage-MessageBoxes
    dw CapeMarioMessage-MessageBoxes
    dw HoldItemMessage-MessageBoxes
    dw SecretExitMessage-MessageBoxes
    dw StarWorldMessage-MessageBoxes
    dw SpecialWorldMessage-MessageBoxes
    dw DragonCoinMessage-MessageBoxes
    dw CI2Message-MessageBoxes
    dw ClimbDoorMessage-MessageBoxes
    dw IggyKoopaMessage-MessageBoxes
    dw ScreenScrollMessage-MessageBoxes
    dw StartSelectMessage-MessageBoxes
    dw SpinJumpMessage-MessageBoxes
    dw YoshiGoneMessage-MessageBoxes
    dw FillYellowMessage-MessageBoxes
    dw RescueYoshiMessage-MessageBoxes

MessageBoxes:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
SwitchMessage:                                ;!
    db $5D,$5D,$5A,$5D,$4A,$48,$65,$7B        ;!
    db $14,$51,$EF,$02,$59,$10,$21,$5D        ;!
    db $5A,$5D,$5D,$00,$52,$0D,$59,$04        ;!
    db $50,$09,$0D,$5D,$4A,$48,$65,$7B        ;!
    db $14,$0E,$04,$20,$59,$10,$5D,$5D        ;!
    db $5D,$5D,$59,$04,$5D,$5D,$5D,$5D        ;!
    db $12,$04,$58,$55,$5D,$07,$07,$19        ;!
    db $59,$10,$14,$6C,$5A,$4A,$59,$04        ;!
    db $4D,$3E,$5F,$59,$10,$51,$19,$0A        ;!
    db $78,$5D,$5D,$5D,$5D,$5D,$5D            ;!
IntroMessage:                                 ;!
    db $07                                    ;!
    db $21,$59,$11,$14,$59,$17,$0D,$01        ;!
    db $15,$5D,$51,$84,$02,$55,$EF,$02        ;!
    db $63,$4C,$59,$64,$52,$12,$1E,$20        ;!
    db $00,$1E,$09,$01,$5D,$07,$14,$09        ;!
    db $19,$59,$10,$5D,$5D,$5D,$5D,$19        ;!
    db $0D,$1D,$1E,$5B,$79,$5A,$7B,$59        ;!
    db $04,$5D,$0A,$59,$04,$0D,$77,$06        ;!
    db $09,$0D,$78,$5D,$07,$01,$0F,$15        ;!
    db $51,$7C,$11,$5D,$5F,$65,$5B,$61        ;!
    db $14,$09,$58,$59,$08,$3F,$5D,$5D        ;!
ItemBoxMessage:                               ;!
    db $5D,$5A,$5D,$A7,$4C,$5B,$A6,$48        ;!
    db $4C,$64,$5D,$62,$59,$64,$59,$61        ;!
    db $48,$4A,$5D,$5A,$5D,$1F,$59,$17        ;!
    db $21,$12,$11,$7C,$10,$5D,$00,$19        ;!
    db $7C,$0D,$62,$48,$4F,$43,$15,$5D        ;!
    db $59,$04,$1C,$21,$14,$02,$03,$12        ;!
    db $5D,$A8,$07,$5D,$50,$01,$10,$50        ;!
    db $06,$19,$0A,$E0,$4E,$5F,$64,$59        ;!
    db $A6,$4B,$4C,$59,$10,$5D,$11,$57        ;!
    db $0D,$55,$1D,$09,$19,$0A,$78            ;!
MidwayMessage:                                ;!
    db $5D                                    ;!
    db $5A,$5D,$A7,$4C,$5B,$A6,$48,$4C        ;!
    db $64,$5D,$62,$59,$64,$59,$61,$48        ;!
    db $4A,$5D,$5A,$5D,$07,$07,$12,$00        ;!
    db $56,$14,$15,$5D,$A0,$04,$21,$59        ;!
    db $66,$5A,$64,$5D,$07,$07,$14,$4F        ;!
    db $5A,$5B,$69,$77,$51,$7C,$10,$50        ;!
    db $01,$0D,$20,$5D,$0F,$59,$0F,$51        ;!
    db $15,$5D,$5D,$07,$14,$00,$0D,$55        ;!
    db $04,$20,$5D,$15,$59,$09,$19,$55        ;!
    db $19,$0A,$78,$5D,$5D,$5D                ;!
JumpHighMessage:                              ;!
    db $10,$51                                ;!
    db $77,$17,$21,$59,$0D,$11,$51,$5D        ;!
    db $59,$6B,$68,$4C,$5B,$69,$59,$A6        ;!
    db $4B,$4C,$77,$5D,$50,$09,$0F,$59        ;!
    db $0F,$06,$10,$01,$56,$11,$5D,$0D        ;!
    db $04,$05,$15,$13,$19,$0A,$78,$0A        ;!
    db $01,$1C,$21,$59,$10,$15,$5D,$02        ;!
    db $03,$12,$4D,$5A,$77,$01,$57,$10        ;!
    db $01,$52,$01,$11,$5D,$0D,$04,$05        ;!
    db $59,$6B,$68,$4C,$5B,$69,$59,$10        ;!
    db $51,$19,$0B,$21,$78,$5D,$5D            ;!
BonusStarsMessage:                            ;!
    db $59                                    ;!
    db $6C,$5A,$FF,$14,$5D,$3E,$5A,$5B        ;!
    db $69,$77,$51,$7C,$0D,$11,$51,$59        ;!
    db $A6,$5A,$46,$4A,$4A,$4B,$5A,$59        ;!
    db $04,$5D,$1D,$20,$03,$19,$0A,$3F        ;!
    db $5D,$0C,$57,$59,$04,$A8,$A9,$A9        ;!
    db $00,$0F,$19,$57,$59,$15,$5D,$0D        ;!
    db $14,$09,$01,$59,$A6,$5A,$46,$4A        ;!
    db $59,$66,$5A,$43,$59,$04,$15,$59        ;!
    db $09,$19,$55,$19,$0A,$78,$5D,$5D        ;!
    db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D        ;!
    db $5D                                    ;!
GhostHouseMessage:                            ;!
    db $07,$07,$15,$5D,$6A,$59,$61            ;!
    db $66,$1E,$09,$51,$78,$78,$78,$5D        ;!
    db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D        ;!
    db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D        ;!
    db $5D,$5D,$5D,$5D,$5D,$5D,$07,$07        ;!
    db $04,$20,$01,$51,$10,$59,$10,$20        ;!
    db $57,$0D,$1E,$0F,$15,$5D,$01,$52        ;!
    db $01,$88,$3E,$77,$1A,$0F,$06,$10        ;!
    db $59,$07,$20,$21,$5D,$66,$65,$66        ;!
    db $65,$66,$65,$5D                        ;!
CapeMarioMessage:                             ;!
    db $67,$4C,$64,$14                        ;!
    db $0C,$02,$08,$15,$5D,$52,$57,$57        ;!
    db $59,$15,$04,$21,$0D,$21,$3F,$1A        ;!
    db $59,$11,$55,$14,$59,$A6,$4B,$4C        ;!
    db $77,$59,$0A,$7C,$11,$50,$09,$10        ;!
    db $01,$56,$07,$11,$19,$59,$0A,$15        ;!
    db $5D,$15,$1E,$05,$15,$09,$56,$5D        ;!
    db $0C,$09,$10,$59,$6B,$68,$4C,$5B        ;!
    db $69,$00,$11,$15,$5D,$C0,$12,$F0        ;!
    db $12,$59,$61,$63,$4C,$4A,$77,$11        ;!
    db $56,$59,$0D,$06,$78                    ;!
HoldItemMessage:                              ;!
    db $00,$50,$59                            ;!
    db $A6,$4B,$4C,$5D,$1A,$59,$11,$55        ;!
    db $59,$A6,$4B,$4C,$15,$5D,$04,$0C        ;!
    db $05,$3F,$50,$09,$0D,$19,$19,$59        ;!
    db $10,$5D,$07,$02,$20,$12,$08,$58        ;!
    db $56,$11,$5D,$5D,$5D,$07,$02,$20        ;!
    db $59,$04,$1D,$10,$56,$78,$02,$03        ;!
    db $77,$1B,$01,$10,$15,$52,$0A,$11        ;!
    db $19,$02,$03,$12,$5D,$52,$59,$06        ;!
    db $0D,$55,$59,$10,$51,$19,$0A,$78        ;!
    db $5D,$5D,$5D,$5D                        ;!
SecretExitMessage:                            ;!
    db $5D,$5A,$5D,$A7                        ;!
    db $4C,$5B,$A6,$48,$4C,$64,$5D,$62        ;!
    db $59,$64,$59,$61,$48,$4A,$5D,$5A        ;!
    db $5D,$67,$65,$5B,$69,$59,$10,$5D        ;!
    db $00,$04,$01,$67,$5A,$5F,$14,$6C        ;!
    db $5A,$4A,$12,$15,$5D,$1D,$02,$16        ;!
    db $11,$0F,$59,$6C,$5A,$FF,$59,$04        ;!
    db $00,$55,$19,$0A,$78,$1F,$B0,$02        ;!
    db $5D,$14,$00,$56,$16,$11,$15,$5D        ;!
    db $08,$59,$04,$09,$10,$1A,$0D,$20        ;!
    db $59,$11,$02,$3D,$5D                    ;!
StarWorldMessage:                             ;!
    db $07,$14,$0B                            ;!
    db $04,$01,$14,$00,$0E,$07,$0E,$12        ;!
    db $5D,$4A,$4B,$5A,$14,$09,$19,$18        ;!
    db $14,$01,$55,$59,$05,$0E,$59,$04        ;!
    db $00,$56,$20,$09,$01,$78,$5D,$01        ;!
    db $0F,$0F,$14,$01,$55,$59,$05,$0E        ;!
    db $77,$5D,$0A,$59,$18,$10,$16,$20        ;!
    db $05,$11,$5D,$67,$65,$5B,$69,$77        ;!
    db $01,$51,$51,$0A,$56,$14,$12,$5D        ;!
    db $11,$10,$1D,$59,$18,$21,$55,$59        ;!
    db $10,$0A,$78,$5D                        ;!
SpecialWorldMessage:                          ;!
    db $07,$07,$19,$59                        ;!
    db $10,$05,$56,$11,$15,$5D,$50,$1D        ;!
    db $58,$52,$04,$7C,$0D,$3F,$5D,$07        ;!
    db $07,$04,$20,$08,$51,$15,$5D,$4A        ;!
    db $5B,$18,$6B,$68,$FF,$6C,$5A,$4A        ;!
    db $3F,$5D,$5F,$60,$62,$0A,$56,$11        ;!
    db $5D,$0A,$07,$09,$5D,$00,$0D,$20        ;!
    db $09,$01,$5D,$5D,$51,$84,$02,$55        ;!
    db $EF,$02,$63,$4C,$59,$64,$77,$5D        ;!
    db $0D,$14,$09,$1C,$19,$0A,$78            ;!
DragonCoinMessage:                            ;!
    db $5D                                    ;!
    db $5A,$5D,$A7,$4C,$5B,$A6,$48,$4C        ;!
    db $64,$5D,$62,$59,$64,$59,$61,$48        ;!
    db $4A,$5A,$5D,$5D,$5D,$50,$50,$51        ;!
    db $52,$6C,$48,$4C,$15,$5D,$59,$64        ;!
    db $63,$59,$6C,$4C,$6C,$48,$4C,$5D        ;!
    db $5D,$A8,$0F,$14,$6C,$5A,$4A,$59        ;!
    db $10,$5D,$59,$07,$19,$01,$5D,$11        ;!
    db $56,$11,$5D,$5D,$5D,$67,$60,$6A        ;!
    db $77,$16,$11,$55,$5D,$5B,$69,$4E        ;!
    db $59,$E0,$4C,$64,$3F,$5D,$5D,$5D        ;!
CI2Message:                                   ;!
    db $07,$07,$15,$17,$09,$59,$51,$14        ;!
    db $6C,$5A,$4A,$5D,$6C,$48,$4C,$77        ;!
    db $11,$7C,$0D,$19,$01,$0A,$02,$1E        ;!
    db $5D,$04,$04,$7C,$0D,$59,$09,$04        ;!
    db $21,$59,$10,$5D,$0F,$59,$51,$12        ;!
    db $59,$10,$56,$6C,$5A,$4A,$59,$04        ;!
    db $04,$58,$56,$3F,$5D,$15,$0D,$09        ;!
    db $10,$52,$59,$0C,$14,$59,$6C,$5A        ;!
    db $FF,$77,$1A,$0F,$06,$56,$07,$11        ;!
    db $59,$04,$59,$10,$51,$56,$04,$3D        ;!
    db $5D,$5D                                ;!
ClimbDoorMessage:                             ;!
    db $5D,$5A,$5D,$A7,$4C,$5B                ;!
    db $A6,$48,$4C,$64,$5D,$62,$59,$64        ;!
    db $59,$61,$48,$4A,$5D,$5A,$5D,$59        ;!
    db $6B,$68,$4C,$5B,$69,$A0,$12,$5D        ;!
    db $02,$03,$12,$4D,$5A,$77,$01,$57        ;!
    db $56,$11,$5D,$04,$52,$00,$1A,$12        ;!
    db $0F,$04,$19,$56,$07,$11,$59,$04        ;!
    db $59,$10,$51,$19,$0A,$78,$5D,$59        ;!
    db $64,$62,$12,$15,$01,$56,$14,$1D        ;!
    db $02,$03,$4D,$5A,$59,$10,$78,$5D        ;!
    db $5D,$5D,$5D                            ;!
IggyKoopaMessage:                             ;!
    db $50,$09,$5C,$14,$A0                    ;!
    db $12,$15,$5D,$47,$65,$6B,$5A,$14        ;!
    db $52,$04,$19,$59,$04,$5D,$0F,$04        ;!
    db $19,$7C,$10,$01,$56,$3F,$5D,$5D        ;!
    db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D        ;!
    db $07,$14,$09,$5C,$14,$6C,$5F,$65        ;!
    db $5B,$61,$11,$14,$5D,$0D,$0D,$04        ;!
    db $01,$15,$5D,$1F,$02,$59,$04,$21        ;!
    db $14,$01,$06,$18,$14,$5D,$50,$11        ;!
    db $09,$00,$01,$59,$0D,$3F,$5D            ;!
ScreenScrollMessage:                          ;!
    db $5D                                    ;!
    db $5A,$5D,$A7,$4C,$5B,$A6,$48,$4C        ;!
    db $64,$5D,$62,$59,$64,$59,$61,$48        ;!
    db $4A,$5D,$5A,$5D,$5D,$49,$5A,$59        ;!
    db $A6,$4B,$4C,$5D,$7A,$5A,$59,$A6        ;!
    db $4B,$4C,$77,$5D,$50,$0A,$11,$5D        ;!
    db $59,$04,$1C,$21,$77,$5D,$F0,$12        ;!
    db $C0,$12,$59,$0A,$20,$0B,$19,$0A        ;!
    db $78,$5D,$5D,$5D,$0E,$84,$7C,$11        ;!
    db $08,$51,$14,$54,$02,$77,$5D,$1A        ;!
    db $0D,$55,$59,$10,$51,$19,$0A            ;!
StartSelectMessage:                           ;!
    db $5D                                    ;!
    db $5A,$5D,$A7,$4C,$5B,$A6,$48,$4C        ;!
    db $64,$5D,$62,$59,$64,$59,$61,$48        ;!
    db $4A,$5D,$5A,$5D,$01,$0E,$59,$11        ;!
    db $5F,$60,$62,$09,$0D,$6C,$5A,$4A        ;!
    db $52,$20,$5D,$4A,$4B,$5A,$64,$59        ;!
    db $A6,$4B,$4C,$77,$5D,$50,$09,$10        ;!
    db $5D,$E0,$4E,$5F,$64,$59,$A6,$4B        ;!
    db $4C,$77,$5D,$50,$0A,$11,$5D,$67        ;!
    db $65,$5B,$69,$12,$1D,$59,$11,$56        ;!
    db $07,$11,$59,$04,$59,$10,$51,$19        ;!
    db $0A                                    ;!
SpinJumpMessage:                              ;!
    db $51,$01,$5C,$59,$A6,$4B,$4C            ;!
    db $15,$59,$6B,$68,$4C,$5B,$69,$5D        ;!
    db $00,$04,$59,$A6,$4B,$4C,$15,$4A        ;!
    db $5B,$79,$4C,$59,$6B,$68,$4C,$5B        ;!
    db $69,$78,$17,$1C,$52,$01,$10,$51        ;!
    db $1D,$17,$1C,$10,$50,$50,$51,$01        ;!
    db $67,$60,$6A,$52,$20,$5D,$59,$69        ;!
    db $3E,$65,$5F,$1D,$58,$57,$56,$47        ;!
    db $65,$6B,$5A,$04,$20,$50,$55,$56        ;!
    db $14,$1D,$5D,$00,$04,$59,$A6,$4B        ;!
    db $4C,$3F                                ;!
YoshiGoneMessage:                             ;!
    db $5D,$48,$63,$65,$6B,$68                ;!
    db $48,$3F,$5D,$59,$54,$05,$15,$5D        ;!
    db $5F,$65,$5B,$61,$04,$20,$52,$04        ;!
    db $19,$77,$0D,$0A,$06,$56,$5D,$0D        ;!
    db $59,$16,$12,$59,$10,$19,$0A,$78        ;!
    db $5D,$5D,$59,$07,$1F,$02,$14,$04        ;!
    db $0D,$15,$5D,$59,$08,$21,$13,$21        ;!
    db $59,$10,$09,$0D,$78,$5D,$5D,$5D        ;!
    db $5D,$5D,$5D,$4A,$5A,$5B,$61,$5A        ;!
    db $59,$64,$63,$59,$6C,$4C,$5D,$5D        ;!
    db $47,$65,$6B,$5A                        ;!
FillYellowMessage:                            ;!
    db $5D,$5A,$5D,$A7                        ;!
    db $4C,$5B,$A6,$48,$4C,$64,$5D,$62        ;!
    db $59,$64,$59,$61,$48,$4A,$5D,$5A        ;!
    db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D        ;!
    db $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D        ;!
    db $5D,$5D,$5D,$10,$21,$0B,$21,$14        ;!
    db $59,$69,$3E,$65,$5F,$59,$04,$5D        ;!
    db $51,$12,$52,$56,$16,$11,$15,$04        ;!
    db $7C,$5B,$15,$1E,$19,$12,$5D,$01        ;!
    db $7C,$10,$1A,$19,$09,$84,$02,$78        ;!
    db $5D,$5D                                ;!
RescueYoshiMessage:                           ;!
    db $69,$5A,$65,$3F,$5D,$0D                ;!
    db $0A,$04,$7C,$0D,$78,$5D,$59,$54        ;!
    db $05,$47,$65,$6B,$5A,$5F,$65,$5B        ;!
    db $61,$12,$0F,$04,$19,$7C,$0D,$5D        ;!
    db $52,$04,$19,$77,$0D,$0A,$06,$12        ;!
    db $50,$09,$5C,$18,$01,$07,$02,$11        ;!
    db $09,$0D,$20,$5D,$1E,$0F,$20,$12        ;!
    db $5D,$5D,$0D,$19,$59,$07,$12,$5D        ;!
    db $11,$59,$09,$07,$1C,$20,$57,$0D        ;!
    db $21,$59,$10,$0A,$78,$5D,$5D            ;!
else                                          ;<================ U, SS, E0, & E1 ==============
IntroMessage:                                 ;!
    db $16,$44,$4B,$42,$4E,$4C,$44,$1A        ;!
    db $1F,$1F,$1F,$13,$47,$48,$52,$1F        ;!
    db $48,$D2,$03,$48,$4D,$4E,$52,$40        ;!
    db $54,$51,$1F,$0B,$40,$4D,$43,$1B        ;!
    db $1F,$1F,$08,$CD,$53,$47,$48,$52        ;!
    db $1F,$52,$53,$51,$40,$4D,$46,$44        ;!
    db $1F,$1F,$4B,$40,$4D,$C3,$56,$44        ;!
    db $1F,$1F,$1F,$1F,$45,$48,$4D,$43        ;!
    db $1F,$1F,$1F,$1F,$53,$47,$40,$D3        ;!
    db $0F,$51,$48,$4D,$42,$44,$52,$52        ;!
    db $1F,$13,$4E,$40,$43,$52,$53,$4E        ;!
    db $4E,$CB,$48,$52,$1F,$1F,$4C,$48        ;!
    db $52,$52,$48,$4D,$46,$1F,$40,$46        ;!
    db $40,$48,$4D,$9A,$0B,$4E,$4E,$4A        ;!
    db $52,$1F,$1F,$4B,$48,$4A,$44,$1F        ;!
    db $01,$4E,$56,$52,$44,$D1,$48,$52        ;!
    db $1F,$40,$53,$1F,$48,$53,$1F,$40        ;!
    db $46,$40,$48,$4D,$9A                    ;!
if ver_is_console(!_VER)                      ;!\================= U, E0, & E1 ================
SwitchMessage:                                ;!!
    db $1C,$1F,$12                            ;!!
    db $16,$08,$13,$02,$07,$1F,$0F,$00        ;!!
    db $0B,$00,$02,$04,$1F,$9C,$13,$47        ;!!
    db $44,$1F,$1F,$4F,$4E,$56,$44,$51        ;!!
    db $1F,$1F,$4E,$45,$1F,$53,$47,$C4        ;!!
    db $52,$56,$48,$53,$42,$47,$1F,$1F        ;!!
    db $58,$4E,$54,$1F,$1F,$1F,$47,$40        ;!!
    db $55,$C4,$4F,$54,$52,$47,$44,$43        ;!!
    db $1F,$1F,$56,$48,$4B,$4B,$1F,$1F        ;!!
    db $53,$54,$51,$CD,$9F,$1F,$1F,$1F        ;!!
    db $1F,$1F,$1F,$48,$4D,$53,$4E,$1F        ;!!
    db $1F,$1F,$1F,$1F,$9B,$18,$4E,$54        ;!!
    db $51,$1F,$4F,$51,$4E,$46,$51,$44        ;!!
    db $52,$52,$1F,$56,$48,$4B,$CB,$40        ;!!
    db $4B,$52,$4E,$1F,$1F,$1F,$41,$44        ;!!
    db $1F,$1F,$1F,$52,$40,$55,$44,$43        ;!!
    db $9B                                    ;!!
else                                          ;!<====================== SS ====================
SwitchMessage:                                ;!!
    db $1C,$1F,$12,$16,$08,$13,$02,$07        ;!!
    db $1F,$0F,$00,$0B,$00,$02,$04,$1F        ;!!
    db $9C,$9F,$13,$47,$44,$1F,$1F,$4F        ;!!
    db $4E,$56,$44,$51,$1F,$1F,$4E,$45        ;!!
    db $1F,$53,$47,$C4,$52,$56,$48,$53        ;!!
    db $42,$47,$1F,$1F,$58,$4E,$54,$1F        ;!!
    db $1F,$1F,$47,$40,$55,$C4,$4F,$54        ;!!
    db $52,$47,$44,$43,$1F,$1F,$56,$48        ;!!
    db $4B,$4B,$1F,$1F,$53,$54,$51,$CD        ;!!
    db $9F,$1F,$1F,$1F,$1F,$1F,$1F,$48        ;!!
    db $4D,$53,$4E,$1F,$1F,$1F,$1F,$1F        ;!!
    db $9B,$9F                                ;!!
endif                                         ;!/==============================================
YoshiGoneMessage:                             ;!
    db $07,$44,$4B,$4B,$4E,$1A,$1F            ;!
    db $1F,$1F,$12,$4E,$51,$51,$58,$1F        ;!
    db $08,$5D,$CC,$4D,$4E,$53,$1F,$1F        ;!
    db $47,$4E,$4C,$44,$1D,$1F,$1F,$41        ;!
    db $54,$53,$1F,$1F,$88,$47,$40,$55        ;!
    db $44,$1F,$1F,$1F,$1F,$46,$4E,$4D        ;!
    db $44,$1F,$1F,$1F,$1F,$53,$CE,$51        ;!
    db $44,$52,$42,$54,$44,$1F,$1F,$4C        ;!
    db $58,$1F,$45,$51,$48,$44,$4D,$43        ;!
    db $D2,$56,$47,$4E,$1F,$56,$44,$51        ;!
    db $44,$1F,$1F,$42,$40,$4F,$53,$54        ;!
    db $51,$44,$C3,$41,$58,$1F,$01,$4E        ;!
    db $56,$52,$44,$51,$9B,$1F,$1F,$1F        ;!
    db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F        ;!
    db $1F,$1F,$1F,$1F,$1F,$60,$E1,$1F        ;!
    db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F        ;!
    db $1C,$1F,$18,$4E,$52,$47,$48,$62        ;!
    db $E3                                    ;!
RescueYoshiMessage:                           ;!
    db $07,$4E,$4E,$51,$40,$58,$1A            ;!
    db $1F,$1F,$13,$47,$40,$4D,$4A,$1F        ;!
    db $58,$4E,$D4,$45,$4E,$51,$1F,$51        ;!
    db $44,$52,$42,$54,$48,$4D,$46,$1F        ;!
    db $1F,$1F,$4C,$44,$9B,$0C,$58,$1F        ;!
    db $4D,$40,$4C,$44,$1F,$1F,$48,$52        ;!
    db $1F,$18,$4E,$52,$47,$48,$9B,$0E        ;!
    db $4D,$1F,$1F,$1F,$4C,$58,$1F,$1F        ;!
    db $1F,$56,$40,$58,$1F,$1F,$1F,$53        ;!
    db $CE,$51,$44,$52,$42,$54,$44,$1F        ;!
    db $4C,$58,$1F,$45,$51,$48,$44,$4D        ;!
    db $43,$52,$9D,$01,$4E,$56,$52,$44        ;!
    db $51,$1F,$53,$51,$40,$4F,$4F,$44        ;!
    db $43,$1F,$1F,$4C,$C4,$48,$4D,$1F        ;!
    db $53,$47,$40,$53,$1F,$44,$46,$46        ;!
    db $9B,$9F                                ;!
FillYellowMessage:                            ;!
    db $08,$53,$1F,$48,$52,$1F                ;!
    db $4F,$4E,$52,$52,$48,$41,$4B,$44        ;!
    db $1F,$1F,$53,$CE,$45,$48,$4B,$4B        ;!
    db $1F,$48,$4D,$1F,$53,$47,$44,$1F        ;!
    db $43,$4E,$53,$53,$44,$C3,$4B,$48        ;!
    db $4D,$44,$1F,$41,$4B,$4E,$42,$4A        ;!
    db $52,$1B,$1F,$1F,$1F,$1F,$13,$CE        ;!
    db $45,$48,$4B,$4B,$1F,$48,$4D,$1F        ;!
    db $53,$47,$44,$1F,$58,$44,$4B,$4B        ;!
    db $4E,$D6,$4E,$4D,$44,$52,$1D,$1F        ;!
    db $49,$54,$52,$53,$1F,$46,$4E,$1F        ;!
    db $56,$44,$52,$D3,$53,$47,$44,$4D        ;!
    db $1F,$4D,$4E,$51,$53,$47,$1F,$1F        ;!
    db $53,$4E,$1F,$53,$47,$C4,$53,$4E        ;!
    db $4F,$1F,$1F,$1F,$1F,$1F,$4E,$45        ;!
    db $1F,$1F,$1F,$1F,$1F,$53,$47,$C4        ;!
    db $4C,$4E,$54,$4D,$53,$40,$48,$4D        ;!
    db $9B                                    ;!
ItemBoxMessage:                               ;!
    db $1C,$0F,$0E,$08,$0D,$13,$1F            ;!
    db $0E,$05,$1F,$00,$03,$15,$08,$02        ;!
    db $04,$9C,$18,$4E,$54,$1F,$1F,$42        ;!
    db $40,$4D,$1F,$1F,$47,$4E,$4B,$43        ;!
    db $1F,$1F,$40,$CD,$44,$57,$53,$51        ;!
    db $40,$1F,$48,$53,$44,$4C,$1F,$1F        ;!
    db $48,$4D,$1F,$53,$47,$C4,$41,$4E        ;!
    db $57,$1F,$40,$53,$1F,$1F,$53,$47        ;!
    db $44,$1F,$53,$4E,$4F,$1F,$4E,$C5        ;!
    db $53,$47,$44,$1F,$52,$42,$51,$44        ;!
    db $44,$4D,$1B,$1F,$1F,$1F,$1F,$1F        ;!
    db $13,$CE,$54,$52,$44,$1F,$48,$53        ;!
    db $1D,$1F,$1F,$4F,$51,$44,$52,$52        ;!
    db $1F,$53,$47,$C4,$12,$04,$0B,$04        ;!
    db $02,$13,$1F,$01,$54,$53,$53,$4E        ;!
    db $4D,$9B,$9F                            ;!
HoldItemMessage:                              ;!
    db $1C,$0F,$0E,$08,$0D                    ;!
    db $13,$1F,$0E,$05,$1F,$00,$03,$15        ;!
    db $08,$02,$04,$9C,$13,$4E,$1F,$1F        ;!
    db $1F,$4F,$48,$42,$4A,$1F,$1F,$1F        ;!
    db $54,$4F,$1F,$1F,$1F,$C0,$52,$47        ;!
    db $44,$4B,$4B,$1D,$1F,$1F,$54,$52        ;!
    db $44,$1F,$1F,$53,$47,$44,$1F,$97        ;!
    db $4E,$51,$1F,$1F,$18,$1F,$1F,$01        ;!
    db $54,$53,$53,$4E,$4D,$1B,$1F,$1F        ;!
    db $13,$CE,$53,$47,$51,$4E,$56,$1F        ;!
    db $1F,$1F,$1F,$40,$1F,$1F,$1F,$52        ;!
    db $47,$44,$4B,$CB,$54,$4F,$56,$40        ;!
    db $51,$43,$52,$1D,$1F,$1F,$4B,$4E        ;!
    db $4E,$4A,$1F,$1F,$54,$CF,$40,$4D        ;!
    db $43,$1F,$4B,$44,$53,$1F,$46,$4E        ;!
    db $1F,$4E,$45,$1F,$1F,$53,$47,$C4        ;!
    db $41,$54,$53,$53,$4E,$4D,$9B            ;!
SpinJumpMessage:                              ;!
    db $13                                    ;!
    db $4E,$1F,$43,$4E,$1F,$40,$1F,$52        ;!
    db $4F,$48,$4D,$1F,$49,$54,$4C,$4F        ;!
    db $9D,$4F,$51,$44,$52,$52,$1F,$1F        ;!
    db $1F,$1F,$53,$47,$44,$1F,$1F,$1F        ;!
    db $1F,$1F,$80,$01,$54,$53,$53,$4E        ;!
    db $4D,$1B,$1F,$1F,$1F,$1F,$00,$1F        ;!
    db $12,$54,$4F,$44,$D1,$0C,$40,$51        ;!
    db $48,$4E,$1F,$1F,$1F,$52,$4F,$48        ;!
    db $4D,$1F,$1F,$49,$54,$4C,$CF,$42        ;!
    db $40,$4D,$1F,$41,$51,$44,$40,$4A        ;!
    db $1F,$52,$4E,$4C,$44,$1F,$1F,$4E        ;!
    db $C5,$53,$47,$44,$1F,$1F,$1F,$41        ;!
    db $4B,$4E,$42,$4A,$52,$1F,$1F,$1F        ;!
    db $40,$4D,$C3,$43,$44,$45,$44,$40        ;!
    db $53,$1F,$52,$4E,$4C,$44,$1F,$4E        ;!
    db $45,$1F,$53,$47,$C4,$53,$4E,$54        ;!
    db $46,$47,$44,$51,$1F,$44,$4D,$44        ;!
    db $4C,$48,$44,$52,$9B                    ;!
MidwayMessage:                                ;!
    db $1C,$0F,$0E                            ;!
    db $08,$0D,$13,$1F,$0E,$05,$1F,$00        ;!
    db $03,$15,$08,$02,$04,$9C,$13,$47        ;!
    db $48,$52,$1F,$1F,$1F,$46,$40,$53        ;!
    db $44,$1F,$1F,$4C,$40,$51,$4A,$D2        ;!
    db $53,$47,$44,$1F,$4C,$48,$43,$43        ;!
    db $4B,$44,$1F,$4E,$45,$1F,$53,$47        ;!
    db $48,$D2,$40,$51,$44,$40,$1B,$1F        ;!
    db $1F,$1F,$01,$58,$1F,$42,$54,$53        ;!
    db $53,$48,$4D,$C6,$53,$47,$44,$1F        ;!
    db $53,$40,$4F,$44,$1F,$47,$44,$51        ;!
    db $44,$1D,$1F,$58,$4E,$D4,$42,$40        ;!
    db $4D,$1F,$42,$4E,$4D,$53,$48,$4D        ;!
    db $54,$44,$1F,$1F,$45,$51,$4E,$CC        ;!
    db $42,$4B,$4E,$52,$44,$1F,$1F,$1F        ;!
    db $53,$4E,$1F,$1F,$1F,$1F,$53,$47        ;!
    db $48,$D2,$4F,$4E,$48,$4D,$53,$9B        ;!
DragonCoinMessage:                            ;!
    db $1C,$0F,$0E,$08,$0D,$13,$1F,$0E        ;!
    db $05,$1F,$00,$03,$15,$08,$02,$04        ;!
    db $9C,$13,$47,$44,$1F,$41,$48,$46        ;!
    db $1F,$42,$4E,$48,$4D,$52,$1F,$1F        ;!
    db $40,$51,$C4,$03,$51,$40,$46,$4E        ;!
    db $4D,$1F,$02,$4E,$48,$4D,$52,$1B        ;!
    db $1F,$1F,$1F,$08,$C5,$58,$4E,$54        ;!
    db $1F,$1F,$4F,$48,$42,$4A,$1F,$54        ;!
    db $4F,$1F,$1F,$45,$48,$55,$C4,$4E        ;!
    db $45,$1F,$1F,$53,$47,$44,$52,$44        ;!
    db $1F,$1F,$48,$4D,$1F,$1F,$4E,$4D        ;!
    db $C4,$40,$51,$44,$40,$1D,$1F,$1F        ;!
    db $58,$4E,$54,$1F,$1F,$46,$44,$53        ;!
    db $1F,$40,$CD,$44,$57,$53,$51,$40        ;!
    db $1F,$0C,$40,$51,$48,$4E,$9B,$9F        ;!
JumpHighMessage:                              ;!
    db $16,$47,$44,$4D,$1F,$58,$4E,$54        ;!
    db $1F,$1F,$52,$53,$4E,$4C,$4F,$1F        ;!
    db $4E,$CD,$40,$4D,$1F,$44,$4D,$44        ;!
    db $4C,$58,$1D,$1F,$1F,$58,$4E,$54        ;!
    db $1F,$42,$40,$CD,$49,$54,$4C,$4F        ;!
    db $1F,$47,$48,$46,$47,$1F,$1F,$48        ;!
    db $45,$1F,$1F,$58,$4E,$D4,$47,$4E        ;!
    db $4B,$43,$1F,$1F,$1F,$1F,$53,$47        ;!
    db $44,$1F,$1F,$1F,$49,$54,$4C,$CF        ;!
    db $41,$54,$53,$53,$4E,$4D,$1B,$1F        ;!
    db $1F,$14,$52,$44,$1F,$14,$4F,$1F        ;!
    db $4E,$CD,$53,$47,$44,$1F,$02,$4E        ;!
    db $4D,$53,$51,$4E,$4B,$1F,$0F,$40        ;!
    db $43,$1F,$53,$CE,$49,$54,$4C,$4F        ;!
    db $1F,$47,$48,$46,$47,$1F,$1F,$48        ;!
    db $4D,$1F,$1F,$53,$47,$C4,$52,$47        ;!
    db $40,$4B,$4B,$4E,$56,$1F,$56,$40        ;!
    db $53,$44,$51,$9B                        ;!
StartSelectMessage:                           ;!
    db $08,$45,$1F,$1F                        ;!
    db $58,$4E,$54,$1F,$40,$51,$44,$1F        ;!
    db $1F,$48,$4D,$1F,$40,$CD,$40,$51        ;!
    db $44,$40,$1F,$53,$47,$40,$53,$1F        ;!
    db $58,$4E,$54,$1F,$47,$40,$55,$C4        ;!
    db $40,$4B,$51,$44,$40,$43,$58,$1F        ;!
    db $1F,$1F,$42,$4B,$44,$40,$51,$44        ;!
    db $43,$9D,$58,$4E,$54,$1F,$42,$40        ;!
    db $4D,$1F,$1F,$51,$44,$53,$54,$51        ;!
    db $4D,$1F,$53,$CE,$53,$47,$44,$1F        ;!
    db $4C,$40,$4F,$1F,$52,$42,$51,$44        ;!
    db $44,$4D,$1F,$1F,$41,$D8,$4F,$51        ;!
    db $44,$52,$52,$48,$4D,$46,$1F,$1F        ;!
    db $1F,$1F,$12,$13,$00,$11,$13,$9D        ;!
    db $53,$47,$44,$4D,$1F,$12,$04,$0B        ;!
    db $04,$02,$13,$9B,$9F                    ;!
BonusStarsMessage:                            ;!
    db $18,$4E,$54                            ;!
    db $1F,$1F,$1F,$46,$44,$53,$1F,$1F        ;!
    db $1F,$1F,$01,$4E,$4D,$54,$D2,$12        ;!
    db $53,$40,$51,$52,$1F,$1F,$48,$45        ;!
    db $1F,$1F,$58,$4E,$54,$1F,$42,$54        ;!
    db $D3,$53,$47,$44,$1F,$1F,$53,$40        ;!
    db $4F,$44,$1F,$1F,$40,$53,$1F,$1F        ;!
    db $53,$47,$C4,$44,$4D,$43,$1F,$1F        ;!
    db $4E,$45,$1F,$44,$40,$42,$47,$1F        ;!
    db $40,$51,$44,$40,$9B,$08,$45,$1F        ;!
    db $58,$4E,$54,$1F,$42,$4E,$4B,$4B        ;!
    db $44,$42,$53,$1F,$64,$6B,$EB,$01        ;!
    db $4E,$4D,$54,$52,$1F,$1F,$12,$53        ;!
    db $40,$51,$52,$1F,$1F,$1F,$58,$4E        ;!
    db $D4,$42,$40,$4D,$1F,$1F,$1F,$4F        ;!
    db $4B,$40,$58,$1F,$1F,$40,$1F,$1F        ;!
    db $45,$54,$CD,$41,$4E,$4D,$54,$52        ;!
    db $1F,$46,$40,$4C,$44,$9B                ;!
ClimbDoorMessage:                             ;!
    db $0F,$51                                ;!
    db $44,$52,$52,$1F,$14,$4F,$1F,$1F        ;!
    db $1F,$4E,$4D,$1F,$1F,$53,$47,$C4        ;!
    db $02,$4E,$4D,$53,$51,$4E,$4B,$1F        ;!
    db $0F,$40,$43,$1F,$1F,$56,$47,$48        ;!
    db $4B,$C4,$49,$54,$4C,$4F,$48,$4D        ;!
    db $46,$1F,$1F,$1F,$40,$4D,$43,$1F        ;!
    db $1F,$58,$4E,$D4,$42,$40,$4D,$1F        ;!
    db $1F,$42,$4B,$48,$4D,$46,$1F,$1F        ;!
    db $53,$4E,$1F,$53,$47,$C4,$45,$44        ;!
    db $4D,$42,$44,$1B,$1F,$1F,$1F,$1F        ;!
    db $13,$4E,$1F,$46,$4E,$1F,$48,$CD        ;!
    db $53,$47,$44,$1F,$1F,$43,$4E,$4E        ;!
    db $51,$1F,$1F,$40,$53,$1F,$1F,$53        ;!
    db $47,$C4,$44,$4D,$43,$1F,$1F,$4E        ;!
    db $45,$1F,$53,$47,$48,$52,$1F,$40        ;!
    db $51,$44,$40,$9D,$54,$52,$44,$1F        ;!
    db $14,$4F,$1F,$40,$4B,$52,$4E,$9B        ;!
IggyKoopaMessage:                             ;!
    db $1C,$0F,$0E,$08,$0D,$13,$1F,$0E        ;!
    db $05,$1F,$00,$03,$15,$08,$02,$04        ;!
    db $9C,$0E,$4D,$44,$1F,$1F,$1F,$4E        ;!
    db $45,$1F,$1F,$1F,$18,$4E,$52,$47        ;!
    db $48,$5D,$D2,$45,$51,$48,$44,$4D        ;!
    db $43,$52,$1F,$48,$52,$1F,$53,$51        ;!
    db $40,$4F,$4F,$44,$C3,$48,$4D,$1F        ;!
    db $1F,$53,$47,$44,$1F,$42,$40,$52        ;!
    db $53,$4B,$44,$1F,$1F,$41,$D8,$08        ;!
    db $46,$46,$58,$1F,$0A,$4E,$4E,$4F        ;!
    db $40,$1B,$1F,$1F,$1F,$1F,$1F,$13        ;!
    db $CE,$43,$44,$45,$44,$40,$53,$1F        ;!
    db $1F,$47,$48,$4C,$1D,$1F,$1F,$4F        ;!
    db $54,$52,$C7,$47,$48,$4C,$1F,$48        ;!
    db $4D,$53,$4E,$1F,$1F,$53,$47,$44        ;!
    db $1F,$4B,$40,$55,$C0,$4F,$4E,$4E        ;!
    db $4B,$9B                                ;!
CapeMarioMessage:                             ;!
    db $14,$52,$44,$1F,$1F,$0C                ;!
    db $40,$51,$48,$4E,$5D,$52,$1F,$1F        ;!
    db $42,$40,$4F,$C4,$53,$4E,$1F,$1F        ;!
    db $1F,$52,$4E,$40,$51,$1F,$1F,$53        ;!
    db $47,$51,$4E,$54,$46,$C7,$53,$47        ;!
    db $44,$1F,$40,$48,$51,$1A,$1F,$11        ;!
    db $54,$4D,$1F,$45,$40,$52,$53,$9D        ;!
    db $49,$54,$4C,$4F,$1D,$1F,$40,$4D        ;!
    db $43,$1F,$47,$4E,$4B,$43,$1F,$53        ;!
    db $47,$C4,$18,$1F,$01,$54,$53,$53        ;!
    db $4E,$4D,$1B,$1F,$1F,$13,$4E,$1F        ;!
    db $4A,$44,$44,$CF,$41,$40,$4B,$40        ;!
    db $4D,$42,$44,$1D,$1F,$1F,$54,$52        ;!
    db $44,$1F,$4B,$44,$45,$D3,$40,$4D        ;!
    db $43,$1F,$1F,$51,$48,$46,$47,$53        ;!
    db $1F,$1F,$4E,$4D,$1F,$53,$47,$C4        ;!
    db $02,$4E,$4D,$53,$51,$4E,$4B,$1F        ;!
    db $0F,$40,$43,$9B                        ;!
SecretExitMessage:                            ;!
    db $13,$47,$44,$1F                        ;!
    db $51,$44,$43,$1F,$43,$4E,$53,$1F        ;!
    db $1F,$40,$51,$44,$40,$D2,$4E,$4D        ;!
    db $1F,$1F,$53,$47,$44,$1F,$1F,$4C        ;!
    db $40,$4F,$1F,$1F,$47,$40,$55,$C4        ;!
    db $53,$56,$4E,$1F,$1F,$1F,$1F,$1F        ;!
    db $1F,$43,$48,$45,$45,$44,$51,$44        ;!
    db $4D,$D3,$44,$57,$48,$53,$52,$1B        ;!
    db $1F,$1F,$1F,$1F,$1F,$1F,$08,$45        ;!
    db $1F,$58,$4E,$D4,$47,$40,$55,$44        ;!
    db $1F,$1F,$53,$47,$44,$1F,$53,$48        ;!
    db $4C,$44,$1F,$40,$4D,$C3,$52,$4A        ;!
    db $48,$4B,$4B,$1D,$1F,$1F,$41,$44        ;!
    db $1F,$52,$54,$51,$44,$1F,$53,$CE        ;!
    db $4B,$4E,$4E,$4A,$1F,$45,$4E,$51        ;!
    db $1F,$53,$47,$44,$4C,$9B,$9F            ;!
GhostHouseMessage:                            ;!
    db $13                                    ;!
    db $47,$48,$52,$1F,$1F,$48,$52,$1F        ;!
    db $1F,$40,$1F,$1F,$06,$47,$4E,$52        ;!
    db $D3,$07,$4E,$54,$52,$44,$1B,$1F        ;!
    db $1F,$1F,$1F,$1F,$02,$40,$4D,$1F        ;!
    db $58,$4E,$D4,$45,$48,$4D,$43,$1F        ;!
    db $1F,$1F,$53,$47,$44,$1F,$1F,$1F        ;!
    db $44,$57,$48,$53,$9E,$07,$44,$44        ;!
    db $1D,$1F,$1F,$47,$44,$44,$1D,$1F        ;!
    db $1F,$47,$44,$44,$1B,$1B,$9B,$03        ;!
    db $4E,$4D,$5D,$53,$1F,$46,$44,$53        ;!
    db $1F,$4B,$4E,$52,$53,$9A,$9F,$9F        ;!
    db $9F                                    ;!
ScreenScrollMessage:                          ;!
    db $18,$4E,$54,$1F,$42,$40,$4D            ;!
    db $1F,$1F,$52,$4B,$48,$43,$44,$1F        ;!
    db $53,$47,$C4,$52,$42,$51,$44,$44        ;!
    db $4D,$1F,$1F,$1F,$4B,$44,$45,$53        ;!
    db $1F,$1F,$1F,$4E,$D1,$51,$48,$46        ;!
    db $47,$53,$1F,$1F,$41,$58,$1F,$4F        ;!
    db $51,$44,$52,$52,$48,$4D,$C6,$53        ;!
    db $47,$44,$1F,$0B,$1F,$4E,$51,$1F        ;!
    db $11,$1F,$01,$54,$53,$53,$4E,$4D        ;!
    db $D2,$4E,$4D,$1F,$1F,$1F,$53,$4E        ;!
    db $4F,$1F,$1F,$1F,$4E,$45,$1F,$1F        ;!
    db $53,$47,$C4,$42,$4E,$4D,$53,$51        ;!
    db $4E,$4B,$4B,$44,$51,$1B,$1F,$1F        ;!
    db $1F,$1F,$18,$4E,$D4,$4C,$40,$58        ;!
    db $1F,$41,$44,$1F,$40,$41,$4B,$44        ;!
    db $1F,$53,$4E,$1F,$52,$44,$C4,$45        ;!
    db $54,$51,$53,$47,$44,$51,$1F,$40        ;!
    db $47,$44,$40,$43,$9B                    ;!
StarWorldMessage:                             ;!
    db $13,$47,$44                            ;!
    db $51,$44,$1F,$1F,$1F,$40,$51,$44        ;!
    db $1F,$1F,$1F,$45,$48,$55,$C4,$44        ;!
    db $4D,$53,$51,$40,$4D,$42,$44,$52        ;!
    db $1F,$1F,$53,$4E,$1F,$1F,$53,$47        ;!
    db $C4,$12,$53,$40,$51,$1F,$1F,$1F        ;!
    db $16,$4E,$51,$4B,$43,$1F,$1F,$1F        ;!
    db $1F,$48,$CD,$03,$48,$4D,$4E,$52        ;!
    db $40,$54,$51,$1F,$1F,$1F,$1F,$1F        ;!
    db $0B,$40,$4D,$43,$9B,$05,$48,$4D        ;!
    db $43,$1F,$1F,$53,$47,$44,$4C,$1F        ;!
    db $40,$4B,$4B,$1F,$40,$4D,$C3,$58        ;!
    db $4E,$54,$1F,$1F,$1F,$42,$40,$4D        ;!
    db $1F,$1F,$1F,$53,$51,$40,$55,$44        ;!
    db $CB,$41,$44,$53,$56,$44,$44,$4D        ;!
    db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$4C        ;!
    db $40,$4D,$D8,$43,$48,$45,$45,$44        ;!
    db $51,$44,$4D,$53,$1F,$4F,$4B,$40        ;!
    db $42,$44,$52,$9B                        ;!
CI2Message:                                   ;!
    db $07,$44,$51,$44                        ;!
    db $1D,$1F,$1F,$1F,$53,$47,$44,$1F        ;!
    db $1F,$42,$4E,$48,$4D,$D2,$58,$4E        ;!
    db $54,$1F,$1F,$1F,$42,$4E,$4B,$4B        ;!
    db $44,$42,$53,$1F,$1F,$1F,$4E,$D1        ;!
    db $53,$47,$44,$1F,$53,$48,$4C,$44        ;!
    db $1F,$51,$44,$4C,$40,$48,$4D,$48        ;!
    db $4D,$C6,$42,$40,$4D,$1F,$1F,$42        ;!
    db $47,$40,$4D,$46,$44,$1F,$1F,$1F        ;!
    db $58,$4E,$54,$D1,$4F,$51,$4E,$46        ;!
    db $51,$44,$52,$52,$1B,$1F,$1F,$02        ;!
    db $40,$4D,$1F,$58,$4E,$D4,$45,$48        ;!
    db $4D,$43,$1F,$1F,$53,$47,$44,$1F        ;!
    db $1F,$52,$4F,$44,$42,$48,$40,$CB        ;!
    db $46,$4E,$40,$4B,$9E,$9F                ;!
SpecialWorldMessage:                          ;!
    db $00,$4C                                ;!
    db $40,$59,$48,$4D,$46,$1A,$1F,$1F        ;!
    db $05,$44,$56,$1F,$47,$40,$55,$C4        ;!
    db $4C,$40,$43,$44,$1F,$48,$53,$1F        ;!
    db $1F,$53,$47,$48,$52,$1F,$45,$40        ;!
    db $51,$9B,$01,$44,$58,$4E,$4D,$43        ;!
    db $1F,$1F,$4B,$48,$44,$52,$1F,$1F        ;!
    db $1F,$53,$47,$C4,$12,$4F,$44,$42        ;!
    db $48,$40,$4B,$1F,$1F,$1F,$1F,$1F        ;!
    db $1F,$19,$4E,$4D,$44,$9B,$02,$4E        ;!
    db $4C,$4F,$4B,$44,$53,$44,$1F,$1F        ;!
    db $48,$53,$1F,$1F,$1F,$40,$4D,$C3        ;!
    db $58,$4E,$54,$1F,$42,$40,$4D,$1F        ;!
    db $44,$57,$4F,$4B,$4E,$51,$44,$1F        ;!
    db $1F,$C0,$52,$53,$51,$40,$4D,$46        ;!
    db $44,$1F,$4D,$44,$56,$1F,$56,$4E        ;!
    db $51,$4B,$43,$9B,$06,$0E,$0E,$03        ;!
    db $1F,$0B,$14,$02,$0A,$9A                ;!
endif                                         ;/===============================================

ClearMessageStripe:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    db $50,$A7,$41,$E2,$FC,$38,$FF            ;!
else                                          ;<=============== U, SS, E0, & E1 ===============
    db $50,$C7,$41,$E2,$FC,$38,$FF            ;!
endif                                         ;/===============================================

DATA_05B106:
    db $4C,$50

DATA_05B108:
    db $50,$00

DATA_05B10A:
    db $04,$FC

CODE_05B10C:
    PHB
    PHK
    PLB
    LDX.W MessageBoxExpand
    LDA.W MessageBoxTimer
    CMP.W DATA_05B108,X
    BNE CODE_05B191
    TXA
    BEQ CODE_05B132
    STZ.W MessageBoxTrigger
    STZ.W MessageBoxExpand
    STZ.B Layer12Window
    STZ.B Layer34Window
    STZ.B OBJCWWindow
    STZ.W HDMAEnable
    LDA.B #$02
    STA.B ColorAddition
    BRA CODE_05B18E

CODE_05B132:
    LDA.W OverworldOverride
    ORA.W SwitchPalaceColor
    BEQ CODE_05B16E
if ver_is_japanese(!_VER)                    ;\======================== J ====================
    LDA.B TrueFrame                           ;!
    AND.B #$03                                ;!
    BNE CODE_05B18E                           ;!
    DEC.W VariousPromptTimer                  ;!
    BNE CODE_05B18E                           ;!
    PLB                                       ;!
    LDA.W SwitchPalaceColor                   ;!
    BEQ CODE_05B15B                           ;!
    INC.W CreditsScreenNumber                 ;!
    LDA.B #$01                                ;!
    STA.W MidwayFlag                          ;!
    BRA +                                     ;!
else                                          ;<================ U, SS, E0, & E1 ==============
if ver_is_console(!_VER)                      ;!\================= U, E0, & E1 ================
    LDA.W VariousPromptTimer                  ;!!
    BEQ CODE_05B16E                           ;!!
    LDA.B TrueFrame                           ;!!
    AND.B #$03                                ;!!
    BNE CODE_05B18E                           ;!!
    DEC.W VariousPromptTimer                  ;!!
    BNE CODE_05B18E                           ;!!
    LDA.W SwitchPalaceColor                   ;!!
    BEQ CODE_05B16E                           ;!!
else                                          ;!<======================= SS ===================
    LDA.B TrueFrame                           ;!!
    AND.B #$03                                ;!!
    BNE CODE_05B16E                           ;!!
    DEC.W VariousPromptTimer                  ;!!
    BNE CODE_05B16E                           ;!!
    LDA.W SwitchPalaceColor                   ;!!
    BEQ CODE_05B15A                           ;!!
endif                                         ;!/==============================================
CODE_05B14F:                                  ;!
    PLB                                       ;!
    INC.W CreditsScreenNumber                 ;!
    LDA.B #$01                                ;!
    STA.W MidwayFlag                          ;!
    BRA +                                     ;!
CODE_05B15A:                                  ;!
    PLB                                       ;!
endif                                         ;/===============================================
CODE_05B15B:
    LDA.B #$8E
    STA.W OWPlayerYPos
SubSideExit:
    STZ.W OverworldOverride
    LDA.B #$00
  + STA.W OWLevelExitMode
    LDA.B #$0B
    STA.W GameMode
    RTL

CODE_05B16E:
    LDA.B byetudlrHold
    AND.B #$F0
    BEQ CODE_05B18E
    EOR.B byetudlrFrame
    AND.B #$F0
    BEQ +
    LDA.B axlr0000Hold
    AND.B #$C0
    BEQ CODE_05B18E
    EOR.B axlr0000Frame
    AND.B #$C0
    BNE CODE_05B18E
if ver_is_arcade(!_VER)                       ;\====================== SS =====================
  + LDA.W SwitchPalaceColor                   ;!
    BNE CODE_05B14F                           ;!
endif                                         ;/===============================================
if ver_is_english(!_VER)                      ;\================= U, SS, E0, & E1 =============
  + LDA.W OverworldOverride                   ;!
    BNE CODE_05B15A                           ;!
endif                                         ;/===============================================
  + INC.W MessageBoxExpand
CODE_05B18E:
    JMP CODE_05B299

CODE_05B191:
    CMP.W DATA_05B106,X
    BNE CODE_05B1A0
    TXA
    BEQ +
    JSR CODE_05B31B
    LDA.B #$09
    STA.B StripeImage
CODE_05B1A0:
    JMP CODE_05B250

  + LDX.B #$16
CODE_05B1A5:
    LDY.B #$01
    LDA.W DATA_05A590,X
    BPL +
    INY
    AND.B #$7F
  + CPY.W MessageBoxTrigger
    BNE CODE_05B1B9
    CMP.W TranslevelNo
    BEQ CODE_05B1BC
CODE_05B1B9:
    DEX
    BNE CODE_05B1A5
CODE_05B1BC:
    LDY.W MessageBoxTrigger
    CPY.B #$03
    BNE +
    LDX.B #$18
  + CPX.B #$04
    BCS +
    INX
    STX.W SwitchPalaceColor
    DEX
    JSR CODE_05B2EB
  + CPX.B #$16
    BNE +
    LDA.W PlayerRidingYoshi
    BEQ +
    INX
  + TXA
    ASL A
    TAX
    REP #$20                                  ; A->16
    LDA.W DATA_05A5A7,X
    STA.B _0
    REP #$10                                  ; XY->16
    LDA.L DynStripeImgSize
    TAX
if ver_is_japanese(!_VER)                     ;\======================== J ====================
    LDY.W #$0006                              ;!
CODE_05B1EF:                                  ;!
    LDA.W DATA_05A580,Y                       ;!
    STA.L DynamicStripeImage,X                ;!
    XBA                                       ;!
    CLC                                       ;!
    ADC.W #$0020                              ;!
    XBA                                       ;!
    STA.L DynamicStripeImage+$28,X            ;!
    LDA.W #$2300                              ;!
    STA.L DynamicStripeImage+2,X              ;!
    STA.L DynamicStripeImage+$2A,X            ;!
    PHY                                       ;!
    SEP #$20                                  ;! A->8
    LDA.B #$12                                ;!
    STA.B _2                                  ;!
    LDY.B _0                                  ;!
CODE_05B208:                                  ;!
    LDA.W MessageBoxes,Y                      ;!
    CMP.B #$59                                ;!
    BEQ +                                     ;!
    CMP.B #$5B                                ;!
    BEQ +                                     ;!
    DEY                                       ;!
    LDA.B #$5D                                ;!
  + STA.L DynamicStripeImage+4,X              ;!
    INY                                       ;!
    LDA.W MessageBoxes,Y                      ;!
    STA.L DynamicStripeImage+$2C,X            ;!
    LDA.B #$39                                ;!
    STA.L DynamicStripeImage+5,X              ;!
    STA.L DynamicStripeImage+$2D,X            ;!
    INX                                       ;!
    INX                                       ;!
    INY                                       ;!
    DEC.B _2                                  ;!
    BNE CODE_05B208                           ;!
    STY.B _0                                  ;!
    REP #$20                                  ;! A->16
    TXA                                       ;!
    CLC                                       ;!
    ADC.W #$002C                              ;!
    TAX                                       ;!
else                                          ;<================ U, SS, E0, & E1 ==============
    LDY.W #$000E                              ;!
CODE_05B1EF:                                  ;!
    LDA.W DATA_05A580,Y                       ;!
    STA.L DynamicStripeImage,X                ;!
    LDA.W #$2300                              ;!
    STA.L DynamicStripeImage+2,X              ;!
    PHY                                       ;!
    SEP #$20                                  ;! A->8
    LDA.B #$12                                ;!
    STA.B _2                                  ;!
    STZ.B _3                                  ;!
    LDY.B _0                                  ;!
CODE_05B208:                                  ;!
    LDA.B #$1F                                ;!
    BIT.W _3                                  ;!
    BMI +                                     ;!
    LDA.W MessageBoxes,Y                      ;!
    STA.W _3                                  ;!
    AND.B #$7F                                ;!
    INY                                       ;!
  + STA.L DynamicStripeImage+4,X              ;!
    LDA.B #$39                                ;!
    STA.L DynamicStripeImage+5,X              ;!
    INX                                       ;!
    INX                                       ;!
    DEC.B _2                                  ;!
    BNE CODE_05B208                           ;!
    STY.B _0                                  ;!
    REP #$20                                  ;! A->16
    INX                                       ;!
    INX                                       ;!
    INX                                       ;!
    INX                                       ;!
endif                                         ;/===============================================
    PLY
    DEY
    DEY
    BPL CODE_05B1EF
    LDA.W #$00FF
    STA.L DynamicStripeImage,X
    TXA
    STA.L DynStripeImgSize
    SEP #$30                                  ; AXY->8
    LDA.B #$01
    STA.W Layer3ScrollType
    STZ.B Layer3XPos
    STZ.B Layer3XPos+1
    STZ.B Layer3YPos
    STZ.B Layer3YPos+1
CODE_05B250:
    LDX.W MessageBoxExpand
    LDA.W MessageBoxTimer
    CLC
    ADC.W DATA_05B10A,X
    STA.W MessageBoxTimer
    CLC
    ADC.B #$80
    XBA
    LDA.B #$80
    SEC
    SBC.W MessageBoxTimer
    REP #$20                                  ; A->16
    LDX.B #$00
    LDY.B #$50
CODE_05B26D:
    CPX.W MessageBoxTimer
    BCC +
    LDA.W #$00FF
  + STA.W WindowTable+$4C,Y
    STA.W WindowTable+$9C,X
    INX
    INX
    DEY
    DEY
    BNE CODE_05B26D
    SEP #$20                                  ; A->8
    LDA.B #$22
    STA.B Layer12Window
    LDY.W SwitchPalaceColor
    BEQ +
    LDA.B #$20
  + STA.B OBJCWWindow
    LDA.B #$22
    STA.B ColorAddition
    LDA.B #$80
    STA.W HDMAEnable
CODE_05B299:
    PLB
    RTL


DATA_05B29B:
    db $AD,$35,$AD,$75,$AD,$B5,$AD,$F5
    db $A7,$35,$A7,$75,$B7,$35,$B7,$75
    db $BD,$37,$BD,$77,$BD,$B7,$BD,$F7
    db $A7,$37,$A7,$77,$B7,$37,$B7,$77
    db $AD,$39,$AD,$79,$AD,$B9,$AD,$F9
    db $A7,$39,$A7,$79,$B7,$39,$B7,$79
    db $BD,$3B,$BD,$7B,$BD,$BB,$BD,$FB
    db $A7,$3B,$A7,$7B,$B7,$3B,$B7,$7B

DATA_05B2DB:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    db $38,$4B,$40,$4B,$38,$53,$40,$53        ;!
    db $60,$4B,$68,$4B,$60,$53,$68,$53        ;!
elseif ver_is_arcade(!_VER)                   ;<======================= SS ====================
    db $50,$57,$58,$57,$50,$5F,$58,$5F        ;!
    db $92,$57,$9A,$57,$92,$5F,$9A,$5F        ;!
else                                          ;<================== U, E0, & E1 ================
    db $50,$4F,$58,$4F,$50,$57,$58,$57        ;!
    db $92,$4F,$9A,$4F,$92,$57,$9A,$57        ;!
endif                                         ;/===============================================

CODE_05B2EB:
    PHX
    TXA
    ASL A
    ASL A
    ASL A
    ASL A
    TAX
    STZ.B _0
    REP #$20                                  ; A->16
    LDY.B #$1C
  - LDA.W DATA_05B29B,X
    STA.W OAMTileNo,Y
    PHX
    LDX.B _0
    LDA.W DATA_05B2DB,X
    STA.W OAMTileXPos,Y
    PLX
    INX
    INX
    INC.B _0
    INC.B _0
    DEY
    DEY
    DEY
    DEY
    BPL -
    STZ.W OAMTileBitSize
    SEP #$20                                  ; A->8
    PLX
    RTS

CODE_05B31B:
    LDY.B #$1C
    LDA.B #$F0
  - STA.W OAMTileYPos,Y
    DEY
    DEY
    DEY
    DEY
    BPL -
    RTS

ADDR_05B329:
    PHA
    LDA.B #!SFX_COIN
    STA.W SPCIO3                              ; / Play sound effect
    PLA
CODE_05B330:
    STA.B _0
    CLC
    ADC.W CoinAdder
    STA.W CoinAdder
    LDA.W GreenStarBlockCoins
    BEQ Return05B35A
    SEC
    SBC.B _0
    BPL +
    LDA.B #$00
  + STA.W GreenStarBlockCoins
    BRA Return05B35A

CODE_05B34A:
    INC.W CoinAdder
    LDA.B #!SFX_COIN
    STA.W SPCIO3                              ; / Play sound effect
    LDA.W GreenStarBlockCoins
    BEQ Return05B35A
    DEC.W GreenStarBlockCoins
Return05B35A:
    RTL


DATA_05B35B:
    db $80,$40,$20,$10,$08,$04,$02,$01

    TYA                                       ; \ Unreachable
    AND.B #$07
    PHA
    TYA
    LSR A
    LSR A
    LSR A
    TAX
    LDA.W OWEventsActivated,X
    PLX
    AND.L DATA_05B35B,X
    RTL                                       ; /


if ver_is_japanese(!_VER)                     ;\====================== J ======================
TitleScreenStripe:                            ;!
    db $50,$00,$00,$7F,$58,$2C,$59,$2C        ;!
    db $55,$2C,$56,$2C,$66,$EC,$65,$EC        ;!
    db $57,$2C,$58,$2C,$59,$2C,$57,$2C        ;!
    db $58,$2C,$59,$2C,$57,$2C,$58,$2C        ;!
    db $59,$2C,$38,$2C,$39,$2C,$66,$EC        ;!
    db $65,$EC,$57,$2C,$58,$2C,$59,$2C        ;!
    db $57,$2C,$58,$2C,$59,$2C,$57,$2C        ;!
    db $58,$2C,$59,$2C,$38,$2C,$39,$2C        ;!
    db $56,$6C,$55,$2C,$68,$2C,$69,$2C        ;!
    db $65,$2C,$66,$2C,$56,$EC,$55,$AC        ;!
    db $67,$2C,$68,$2C,$69,$2C,$67,$2C        ;!
    db $68,$2C,$69,$2C,$67,$2C,$68,$2C        ;!
    db $69,$2C,$48,$2C,$49,$2C,$56,$EC        ;!
    db $55,$AC,$67,$2C,$68,$2C,$69,$2C        ;!
    db $67,$2C,$68,$2C,$69,$2C,$67,$2C        ;!
    db $68,$2C,$69,$2C,$48,$2C,$49,$2C        ;!
    db $66,$6C,$65,$6C,$50,$40,$80,$33        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$50,$41,$80,$33        ;!
    db $56,$2C,$66,$2C,$39,$2C,$49,$2C        ;!
    db $56,$2C,$66,$2C,$39,$2C,$49,$2C        ;!
    db $56,$2C,$66,$2C,$39,$2C,$49,$2C        ;!
    db $56,$2C,$66,$2C,$39,$2C,$49,$2C        ;!
    db $56,$2C,$66,$2C,$39,$2C,$49,$2C        ;!
    db $56,$2C,$66,$2C,$39,$2C,$49,$2C        ;!2b8dc
    db $56,$2C,$66,$2C,$50,$5E,$80,$33        ;!
    db $66,$EC,$56,$EC,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$50,$5F,$80,$33        ;!
    db $65,$EC,$55,$EC,$38,$6C,$48,$6C        ;!
    db $55,$6C,$65,$6C,$38,$6C,$48,$6C        ;!
    db $55,$6C,$65,$6C,$38,$6C,$48,$6C        ;!
    db $55,$6C,$65,$6C,$38,$6C,$48,$6C        ;!
    db $55,$6C,$65,$6C,$38,$6C,$48,$6C        ;!
    db $55,$6C,$65,$6C,$38,$6C,$48,$6C        ;!
    db $55,$6C,$65,$6C,$53,$40,$00,$7F        ;!
    db $69,$AC,$67,$AC,$68,$AC,$69,$AC        ;!
    db $67,$AC,$68,$AC,$69,$AC,$48,$AC        ;!
    db $49,$AC,$56,$6C,$55,$2C,$67,$AC        ;!
    db $68,$AC,$69,$AC,$67,$AC,$68,$AC        ;!
    db $69,$AC,$67,$AC,$68,$AC,$69,$AC        ;!
    db $48,$AC,$49,$AC,$66,$EC,$65,$EC        ;!
    db $57,$2C,$58,$2C,$59,$2C,$57,$2C        ;!
    db $58,$2C,$57,$2C,$58,$2C,$59,$2C        ;!
    db $59,$AC,$57,$AC,$58,$AC,$59,$AC        ;!
    db $57,$AC,$58,$AC,$59,$AC,$38,$AC        ;!
    db $39,$AC,$66,$6C,$65,$6C,$57,$AC        ;!
    db $58,$AC,$59,$AC,$57,$AC,$58,$AC        ;!
    db $59,$AC,$57,$AC,$58,$AC,$59,$AC        ;!
    db $38,$AC,$39,$AC,$56,$EC,$55,$AC        ;!
    db $67,$2C,$68,$2C,$69,$2C,$67,$2C        ;!
    db $68,$2C,$67,$2C,$68,$2C,$69,$2C        ;!
    db $50,$CA,$00,$13,$98,$3C,$A9,$3C        ;!
    db $2F,$38,$AE,$28,$E0,$B8,$2C,$38        ;!
    db $4B,$28,$F0,$28,$F1,$28,$98,$68        ;!
    db $50,$EA,$00,$15,$4F,$3C,$8A,$3C        ;!
    db $8B,$28,$8C,$28,$8D,$38,$35,$38        ;!
    db $45,$28,$2A,$28,$2B,$28,$60,$28        ;!
    db $C8,$28,$51,$0A,$00,$15,$99,$3C        ;!
    db $9A,$3C,$9B,$28,$9C,$28,$9D,$38        ;!
    db $9E,$38,$9F,$28,$5A,$28,$5B,$28        ;!
    db $90,$28,$CC,$28,$51,$2B,$00,$13        ;!
    db $AA,$28,$AB,$28,$AC,$28,$AD,$28        ;!
    db $FE,$28,$AF,$28,$70,$28,$71,$28        ;!
    db $72,$28,$73,$28,$51,$3C,$00,$01        ;!
    db $75,$28,$51,$44,$00,$2F,$B0,$28        ;!
    db $B1,$28,$B2,$28,$B3,$28,$B4,$28        ;!
    db $B5,$38,$CA,$38,$2C,$38,$2F,$3C        ;!
    db $FC,$28,$FC,$28,$FC,$28,$E0,$B8        ;!
    db $3C,$38,$3C,$78,$74,$38,$FC,$28        ;!
    db $B5,$3C,$CA,$3C,$2C,$3C,$2F,$3C        ;!
    db $B5,$3C,$CA,$3C,$98,$68,$51,$64        ;!
    db $00,$31,$6A,$28,$6B,$28,$6C,$28        ;!
    db $6D,$28,$6E,$28,$6F,$38,$C6,$38        ;!
    db $C7,$38,$D8,$3C,$C9,$3C,$CA,$3C        ;!
    db $CB,$3C,$D0,$B8,$CD,$38,$CE,$38        ;!
    db $CF,$38,$CA,$28,$A1,$28,$C6,$3C        ;!
    db $C7,$3C,$D8,$3C,$A5,$3C,$A3,$3C        ;!
    db $B6,$3C,$C8,$28,$51,$84,$00,$31        ;!
    db $D0,$3C,$D1,$28,$D2,$28,$D3,$28        ;!
    db $61,$28,$62,$38,$63,$38,$D7,$38        ;!
    db $D8,$3C,$D9,$3C,$DA,$3C,$DB,$3C        ;!
    db $DC,$38,$DD,$38,$DE,$38,$DF,$38        ;!
    db $DA,$28,$29,$28,$63,$3C,$D7,$3C        ;!
    db $D8,$3C,$2D,$3C,$4C,$3C,$4D,$3C        ;!
    db $4E,$28,$51,$A4,$00,$31,$E0,$3C        ;!
    db $E1,$28,$E2,$28,$E3,$28,$E4,$28        ;!
    db $E5,$38,$E6,$38,$E7,$38,$E8,$3C        ;!
    db $E9,$3C,$EA,$3C,$EB,$3C,$EC,$38        ;!
    db $ED,$38,$EE,$38,$EF,$38,$EA,$28        ;!
    db $EB,$28,$E6,$3C,$E7,$3C,$5C,$3C        ;!
    db $5D,$3C,$5E,$3C,$5F,$3C,$FE,$28        ;!
    db $51,$C5,$00,$2F,$FE,$28,$F2,$28        ;!
    db $F3,$28,$F4,$28,$F5,$28,$FE,$28        ;!
    db $F7,$28,$F8,$28,$F9,$28,$FA,$28        ;!
    db $FB,$28,$50,$28,$51,$28,$52,$28        ;!
    db $53,$28,$A0,$28,$FB,$28,$A2,$28        ;!
    db $F7,$28,$F8,$28,$F9,$28,$A6,$28        ;!
    db $A7,$28,$A8,$28,$53,$09,$00,$1B        ;!
    db $F6,$38,$FC,$28,$36,$38,$37,$38        ;!
    db $37,$38,$54,$38,$FC,$28,$46,$38        ;!
    db $47,$38,$AE,$39,$AF,$39,$C5,$39        ;!
    db $C6,$39,$BF,$39,$FF                    ;!
elseif ver_is_hires(!_VER)                    ;<======================== E1 ===================
TitleScreenStripe:                            ;!
    db $50,$00,$00,$7F,$58,$2C,$59,$2C        ;!
    db $55,$2C,$56,$2C,$66,$EC,$65,$EC        ;!
    db $57,$2C,$58,$2C,$59,$2C,$57,$2C        ;!
    db $58,$2C,$59,$2C,$57,$2C,$58,$2C        ;!
    db $59,$2C,$38,$2C,$39,$2C,$66,$EC        ;!
    db $65,$EC,$57,$2C,$58,$2C,$59,$2C        ;!
    db $57,$2C,$58,$2C,$59,$2C,$57,$2C        ;!
    db $58,$2C,$59,$2C,$38,$2C,$39,$2C        ;!
    db $56,$6C,$55,$2C,$68,$2C,$69,$2C        ;!
    db $65,$2C,$66,$2C,$56,$EC,$55,$AC        ;!
    db $67,$2C,$68,$2C,$69,$2C,$67,$2C        ;!
    db $68,$2C,$69,$2C,$67,$2C,$68,$2C        ;!
    db $69,$2C,$48,$2C,$49,$2C,$56,$EC        ;!
    db $55,$AC,$67,$2C,$68,$2C,$69,$2C        ;!
    db $67,$2C,$68,$2C,$69,$2C,$67,$2C        ;!
    db $68,$2C,$69,$2C,$48,$2C,$49,$2C        ;!
    db $66,$6C,$65,$6C,$50,$40,$80,$37        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $50,$41,$80,$37,$56,$2C,$66,$2C        ;!
    db $39,$2C,$49,$2C,$56,$2C,$66,$2C        ;!
    db $39,$2C,$49,$2C,$56,$2C,$66,$2C        ;!
    db $39,$2C,$49,$2C,$56,$2C,$66,$2C        ;!
    db $39,$2C,$49,$2C,$56,$2C,$66,$2C        ;!
    db $39,$2C,$49,$2C,$56,$2C,$66,$2C        ;!
    db $39,$2C,$49,$2C,$56,$2C,$66,$2C        ;!
    db $39,$2C,$49,$2C,$50,$5E,$80,$37        ;!
    db $66,$EC,$56,$EC,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $50,$5F,$80,$37,$65,$EC,$55,$EC        ;!
    db $38,$6C,$48,$6C,$55,$6C,$65,$6C        ;!
    db $38,$6C,$48,$6C,$55,$6C,$65,$6C        ;!
    db $38,$6C,$48,$6C,$55,$6C,$65,$6C        ;!
    db $38,$6C,$48,$6C,$55,$6C,$65,$6C        ;!
    db $38,$6C,$48,$6C,$55,$6C,$65,$6C        ;!
    db $38,$6C,$48,$6C,$55,$6C,$65,$6C        ;!
    db $38,$6C,$48,$6C,$53,$80,$00,$7F        ;!
    db $69,$AC,$67,$AC,$68,$AC,$69,$AC        ;!
    db $67,$AC,$68,$AC,$69,$AC,$48,$AC        ;!
    db $49,$AC,$56,$6C,$55,$2C,$67,$AC        ;!
    db $68,$AC,$69,$AC,$67,$AC,$68,$AC        ;!
    db $69,$AC,$67,$AC,$68,$AC,$69,$AC        ;!
    db $48,$AC,$49,$AC,$66,$EC,$65,$EC        ;!
    db $57,$2C,$58,$2C,$59,$2C,$57,$2C        ;!
    db $58,$2C,$57,$2C,$58,$2C,$59,$2C        ;!
    db $59,$AC,$57,$AC,$58,$AC,$59,$AC        ;!
    db $57,$AC,$58,$AC,$59,$AC,$38,$AC        ;!
    db $39,$AC,$66,$6C,$65,$6C,$57,$AC        ;!
    db $58,$AC,$59,$AC,$57,$AC,$58,$AC        ;!
    db $59,$AC,$57,$AC,$58,$AC,$59,$AC        ;!
    db $38,$AC,$39,$AC,$56,$EC,$55,$AC        ;!
    db $67,$2C,$68,$2C,$69,$2C,$67,$2C        ;!
    db $68,$2C,$67,$2C,$68,$2C,$69,$2C        ;!
    db $50,$AA,$00,$13,$98,$3C,$A9,$3C        ;!
    db $2F,$38,$AE,$28,$E0,$B8,$2C,$38        ;!
    db $4B,$28,$F0,$28,$F1,$28,$98,$68        ;!
    db $50,$CA,$00,$15,$4F,$3C,$8A,$3C        ;!
    db $8B,$28,$8C,$28,$8D,$38,$35,$38        ;!
    db $45,$28,$2A,$28,$2B,$28,$60,$28        ;!
    db $A2,$28,$50,$EA,$00,$15,$99,$3C        ;!
    db $9A,$3C,$9B,$28,$9C,$28,$9D,$38        ;!
    db $9E,$38,$9F,$28,$5A,$28,$5B,$28        ;!
    db $90,$28,$A0,$28,$51,$0A,$00,$13        ;!
    db $5C,$28,$5C,$68,$71,$28,$71,$68        ;!
    db $5C,$28,$72,$28,$73,$28,$71,$68        ;!
    db $75,$28,$89,$28,$51,$3B,$00,$03        ;!
    db $7B,$39,$7C,$39,$51,$23,$00,$2F        ;!
    db $B0,$28,$B1,$28,$B2,$28,$B3,$28        ;!
    db $B4,$28,$B5,$38,$F5,$38,$2C,$38        ;!
    db $AC,$3C,$F2,$3C,$F3,$3C,$F4,$3C        ;!
    db $E0,$B8,$3C,$38,$FB,$38,$74,$38        ;!
    db $F3,$28,$F8,$28,$F5,$3C,$2C,$3C        ;!
    db $AC,$3C,$B5,$3C,$F5,$3C,$98,$68        ;!
    db $51,$43,$00,$31,$6A,$28,$6B,$28        ;!
    db $6C,$28,$6D,$28,$6E,$28,$6F,$38        ;!
    db $C6,$38,$C7,$38,$D8,$3C,$C9,$3C        ;!
    db $CA,$3C,$CB,$3C,$D0,$B8,$CD,$38        ;!
    db $CE,$38,$CF,$38,$CA,$28,$A1,$28        ;!
    db $C6,$3C,$C7,$3C,$D8,$3C,$A5,$3C        ;!
    db $A3,$3C,$B6,$3C,$C8,$28,$51,$63        ;!
    db $00,$31,$D0,$3C,$D1,$28,$D2,$28        ;!
    db $D3,$28,$61,$28,$62,$38,$63,$38        ;!
    db $D7,$38,$D8,$3C,$D9,$3C,$DA,$3C        ;!
    db $DB,$3C,$DC,$38,$DD,$38,$DE,$38        ;!
    db $DF,$38,$DA,$28,$29,$28,$63,$3C        ;!
    db $D7,$3C,$D8,$3C,$2D,$3C,$4C,$3C        ;!
    db $4D,$3C,$CC,$28,$51,$83,$00,$31        ;!
    db $E0,$3C,$E1,$28,$E2,$28,$E3,$28        ;!
    db $E4,$28,$E5,$38,$E6,$38,$E7,$38        ;!
    db $E8,$3C,$E9,$3C,$EA,$3C,$EB,$3C        ;!
    db $EC,$38,$ED,$38,$EE,$38,$EF,$38        ;!
    db $EA,$28,$F7,$28,$E6,$3C,$E7,$3C        ;!
    db $E8,$3C,$5D,$3C,$5E,$3C,$5F,$3C        ;!
    db $FA,$28,$51,$A3,$00,$2F,$5C,$28        ;!
    db $A4,$28,$FC,$28,$FC,$28,$A6,$38        ;!
    db $75,$28,$A7,$28,$A8,$38,$FC,$28        ;!
    db $FC,$28,$FC,$28,$FC,$28,$AA,$38        ;!
    db $5C,$68,$AB,$38,$71,$68,$FC,$28        ;!
    db $FC,$28,$A7,$28,$A8,$38,$FC,$28        ;!
    db $AD,$3C,$A7,$28,$AF,$3C,$53,$27        ;!
    db $00,$25,$F6,$38,$FC,$28,$36,$38        ;!
    db $37,$38,$37,$38,$54,$38,$20,$39        ;!
    db $36,$38,$37,$38,$37,$38,$36,$38        ;!
    db $FC,$28,$46,$38,$47,$38,$AE,$39        ;!
    db $AF,$39,$C5,$39,$C6,$39,$BF,$39        ;!
    db $FF                                    ;!
else                                          ;<================== U, SS, & E0 ================
TitleScreenStripe:                            ;!
    db $50,$00,$00,$7F,$58,$2C,$59,$2C        ;!
    db $55,$2C,$56,$2C,$66,$EC,$65,$EC        ;!
    db $57,$2C,$58,$2C,$59,$2C,$57,$2C        ;!
    db $58,$2C,$59,$2C,$57,$2C,$58,$2C        ;!
    db $59,$2C,$38,$2C,$39,$2C,$66,$EC        ;!
    db $65,$EC,$57,$2C,$58,$2C,$59,$2C        ;!
    db $57,$2C,$58,$2C,$59,$2C,$57,$2C        ;!
    db $58,$2C,$59,$2C,$38,$2C,$39,$2C        ;!
    db $56,$6C,$55,$2C,$68,$2C,$69,$2C        ;!
    db $65,$2C,$66,$2C,$56,$EC,$55,$AC        ;!
    db $67,$2C,$68,$2C,$69,$2C,$67,$2C        ;!
    db $68,$2C,$69,$2C,$67,$2C,$68,$2C        ;!
    db $69,$2C,$48,$2C,$49,$2C,$56,$EC        ;!
    db $55,$AC,$67,$2C,$68,$2C,$69,$2C        ;!
    db $67,$2C,$68,$2C,$69,$2C,$67,$2C        ;!
    db $68,$2C,$69,$2C,$48,$2C,$49,$2C        ;!
    db $66,$6C,$65,$6C,$50,$40,$80,$33        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$38,$2C,$48,$2C        ;!
    db $55,$2C,$65,$2C,$50,$41,$80,$33        ;!
    db $56,$2C,$66,$2C,$39,$2C,$49,$2C        ;!
    db $56,$2C,$66,$2C,$39,$2C,$49,$2C        ;!
    db $56,$2C,$66,$2C,$39,$2C,$49,$2C        ;!
    db $56,$2C,$66,$2C,$39,$2C,$49,$2C        ;!
    db $56,$2C,$66,$2C,$39,$2C,$49,$2C        ;!
    db $56,$2C,$66,$2C,$39,$2C,$49,$2C        ;!
    db $56,$2C,$66,$2C,$50,$5E,$80,$33        ;!
    db $66,$EC,$56,$EC,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$39,$6C,$49,$6C        ;!
    db $56,$6C,$66,$6C,$50,$5F,$80,$33        ;!
    db $65,$EC,$55,$EC,$38,$6C,$48,$6C        ;!
    db $55,$6C,$65,$6C,$38,$6C,$48,$6C        ;!
    db $55,$6C,$65,$6C,$38,$6C,$48,$6C        ;!
    db $55,$6C,$65,$6C,$38,$6C,$48,$6C        ;!
    db $55,$6C,$65,$6C,$38,$6C,$48,$6C        ;!
    db $55,$6C,$65,$6C,$38,$6C,$48,$6C        ;!
    db $55,$6C,$65,$6C,$53,$40,$00,$7F        ;!
    db $69,$AC,$67,$AC,$68,$AC,$69,$AC        ;!
    db $67,$AC,$68,$AC,$69,$AC,$48,$AC        ;!
    db $49,$AC,$56,$6C,$55,$2C,$67,$AC        ;!
    db $68,$AC,$69,$AC,$67,$AC,$68,$AC        ;!
    db $69,$AC,$67,$AC,$68,$AC,$69,$AC        ;!
    db $48,$AC,$49,$AC,$66,$EC,$65,$EC        ;!
    db $57,$2C,$58,$2C,$59,$2C,$57,$2C        ;!
    db $58,$2C,$57,$2C,$58,$2C,$59,$2C        ;!
    db $59,$AC,$57,$AC,$58,$AC,$59,$AC        ;!
    db $57,$AC,$58,$AC,$59,$AC,$38,$AC        ;!
    db $39,$AC,$66,$6C,$65,$6C,$57,$AC        ;!
    db $58,$AC,$59,$AC,$57,$AC,$58,$AC        ;!
    db $59,$AC,$57,$AC,$58,$AC,$59,$AC        ;!
    db $38,$AC,$39,$AC,$56,$EC,$55,$AC        ;!
    db $67,$2C,$68,$2C,$69,$2C,$67,$2C        ;!
    db $68,$2C,$67,$2C,$68,$2C,$69,$2C        ;!
    db $50,$AA,$00,$13,$98,$3C,$A9,$3C        ;!
    db $2F,$38,$AE,$28,$E0,$B8,$2C,$38        ;!
    db $4B,$28,$F0,$28,$F1,$28,$98,$68        ;!
    db $50,$CA,$00,$15,$4F,$3C,$8A,$3C        ;!
    db $8B,$28,$8C,$28,$8D,$38,$35,$38        ;!
    db $45,$28,$2A,$28,$2B,$28,$60,$28        ;!
    db $A2,$28,$50,$EA,$00,$15,$99,$3C        ;!
    db $9A,$3C,$9B,$28,$9C,$28,$9D,$38        ;!
    db $9E,$38,$9F,$28,$5A,$28,$5B,$28        ;!
    db $90,$28,$A0,$28,$51,$0A,$00,$13        ;!
    db $5C,$28,$5C,$68,$71,$28,$71,$68        ;!
    db $5C,$28,$72,$28,$73,$28,$71,$68        ;!
    db $75,$28,$89,$28,$51,$3B,$00,$03        ;!
    db $7B,$39,$7C,$39,$51,$23,$00,$2F        ;!
    db $B0,$28,$B1,$28,$B2,$28,$B3,$28        ;!
    db $B4,$28,$B5,$38,$F5,$38,$2C,$38        ;!
    db $AC,$3C,$F2,$3C,$F3,$3C,$F4,$3C        ;!
    db $E0,$B8,$3C,$38,$FB,$38,$74,$38        ;!
    db $F3,$28,$F8,$28,$F5,$3C,$2C,$3C        ;!
    db $AC,$3C,$B5,$3C,$F5,$3C,$98,$68        ;!
    db $51,$43,$00,$31,$6A,$28,$6B,$28        ;!
    db $6C,$28,$6D,$28,$6E,$28,$6F,$38        ;!
    db $C6,$38,$C7,$38,$D8,$3C,$C9,$3C        ;!
    db $CA,$3C,$CB,$3C,$D0,$B8,$CD,$38        ;!
    db $CE,$38,$CF,$38,$CA,$28,$A1,$28        ;!
    db $C6,$3C,$C7,$3C,$D8,$3C,$A5,$3C        ;!
    db $A3,$3C,$B6,$3C,$C8,$28,$51,$63        ;!
    db $00,$31,$D0,$3C,$D1,$28,$D2,$28        ;!
    db $D3,$28,$61,$28,$62,$38,$63,$38        ;!
    db $D7,$38,$D8,$3C,$D9,$3C,$DA,$3C        ;!
    db $DB,$3C,$DC,$38,$DD,$38,$DE,$38        ;!
    db $DF,$38,$DA,$28,$29,$28,$63,$3C        ;!
    db $D7,$3C,$D8,$3C,$2D,$3C,$4C,$3C        ;!
    db $4D,$3C,$CC,$28,$51,$83,$00,$31        ;!
    db $E0,$3C,$E1,$28,$E2,$28,$E3,$28        ;!
    db $E4,$28,$E5,$38,$E6,$38,$E7,$38        ;!
    db $E8,$3C,$E9,$3C,$EA,$3C,$EB,$3C        ;!
    db $EC,$38,$ED,$38,$EE,$38,$EF,$38        ;!
    db $EA,$28,$F7,$28,$E6,$3C,$E7,$3C        ;!
    db $E8,$3C,$5D,$3C,$5E,$3C,$5F,$3C        ;!
    db $FA,$28,$51,$A3,$00,$2F,$5C,$28        ;!
    db $A4,$28,$FC,$28,$FC,$28,$A6,$38        ;!
    db $75,$28,$A7,$28,$A8,$38,$FC,$28        ;!
    db $FC,$28,$FC,$28,$FC,$28,$AA,$38        ;!
    db $5C,$68,$AB,$38,$71,$68,$FC,$28        ;!
    db $FC,$28,$A7,$28,$A8,$38,$FC,$28        ;!
    db $AD,$3C,$A7,$28,$AF,$3C,$53,$07        ;!
    db $00,$25,$F6,$38,$FC,$28,$36,$38        ;!
    db $37,$38,$37,$38,$54,$38,$20,$39        ;!
    db $36,$38,$37,$38,$37,$38,$36,$38        ;!
    db $FC,$28,$46,$38,$47,$38,$AE,$39        ;!
    db $AF,$39,$C5,$39,$C6,$39,$BF,$39        ;!
    db $FF                                    ;!
endif                                         ;/===============================================

if ver_is_japanese(!_VER)                     ;\======================== J ====================
FileSelectStripe:                             ;!
    db $52,$28,$40,$1C,$FC,$38,$52,$68        ;!
    db $40,$1C,$FC,$38,$52,$0A,$00,$1F        ;!
    db $84,$30,$85,$30,$86,$30,$FC,$38        ;!
    db $FC,$38,$71,$31,$FC,$38,$24,$38        ;!
    db $24,$38,$24,$38,$30,$31,$3B,$31        ;!
    db $32,$31,$33,$31,$34,$31,$FC,$38        ;!
    db $51,$F5,$00,$01,$35,$31,$52,$4A        ;!
    db $00,$1F,$84,$30,$85,$30,$86,$30        ;!
    db $FC,$38,$FC,$38,$2C,$31,$FC,$38        ;!
    db $24,$38,$24,$38,$24,$38,$30,$31        ;!
    db $3B,$31,$32,$31,$33,$31,$34,$31        ;!
    db $FC,$38,$52,$35,$00,$01,$35,$31        ;!
    db $52,$8A,$00,$1F,$84,$30,$85,$30        ;!
    db $86,$30,$FC,$38,$FC,$38,$2D,$31        ;!
    db $FC,$38,$24,$38,$24,$38,$24,$38        ;!
    db $30,$31,$3B,$31,$32,$31,$33,$31        ;!
    db $34,$31,$FC,$38,$52,$75,$00,$01        ;!
    db $35,$31,$52,$CA,$00,$0D,$38,$31        ;!
    db $39,$31,$3A,$31,$FC,$38,$8D,$31        ;!
    db $9D,$31,$D4,$31,$52,$CA,$00,$0D        ;!
    db $86,$30,$7A,$30,$88,$30,$FC,$38        ;!
    db $FC,$38,$FC,$38,$FC,$38,$FF            ;!
                                              ;!
PlayerSelectStripe:                           ;!
    db $51,$F5,$00,$01,$FC,$38,$52,$08        ;!
    db $40,$23,$FC,$38,$52,$48,$40,$23        ;!
    db $FC,$38,$52,$88,$40,$23,$FC,$38        ;!
    db $52,$C8,$40,$10,$FC,$38,$52,$2A        ;!
    db $00,$19,$6D,$31,$FC,$38,$6F,$31        ;!
    db $70,$31,$71,$31,$72,$31,$73,$31        ;!
    db $74,$31,$FC,$38,$75,$31,$71,$31        ;!
    db $76,$31,$73,$31,$52,$6A,$00,$19        ;!
    db $6E,$31,$FC,$38,$6F,$31,$70,$31        ;!
    db $71,$31,$72,$31,$73,$31,$74,$31        ;!
    db $FC,$38,$75,$31,$71,$31,$76,$31        ;!
    db $73,$31,$FF                            ;!
elseif ver_is_arcade(!_VER)                   ;<========================= SS ==================
EraseFileStripe:                              ;!
    db $52,$05,$40,$2E,$FC,$38,$52,$28        ;!
    db $40,$1C,$FC,$38,$52,$45,$40,$2E        ;!
    db $FC,$38,$52,$68,$40,$1C,$FC,$38        ;!
    db $52,$85,$40,$2E,$FC,$38,$52,$C5        ;!
    db $40,$1C,$FC,$38,$52,$0D,$00,$1F        ;!
    db $76,$31,$71,$31,$74,$31,$82,$30        ;!
    db $83,$30,$FC,$38,$71,$31,$FC,$38        ;!
    db $24,$38,$24,$38,$24,$38,$73,$31        ;!
    db $76,$31,$6F,$31,$2F,$31,$72,$31        ;!
    db $52,$4D,$00,$1F,$76,$31,$71,$31        ;!
    db $74,$31,$82,$30,$83,$30,$FC,$38        ;!
    db $2C,$31,$FC,$38,$24,$38,$24,$38        ;!
    db $24,$38,$73,$31,$76,$31,$6F,$31        ;!
    db $2F,$31,$72,$31,$52,$8D,$00,$1F        ;!
    db $76,$31,$71,$31,$74,$31,$82,$30        ;!
    db $83,$30,$FC,$38,$2D,$31,$FC,$38        ;!
    db $24,$38,$24,$38,$24,$38,$73,$31        ;!
    db $76,$31,$6F,$31,$2F,$31,$72,$31        ;!
    db $52,$07,$00,$0B,$73,$31,$74,$31        ;!
    db $71,$31,$31,$31,$73,$31,$FC,$38        ;!
    db $52,$47,$00,$0B,$73,$31,$74,$31        ;!
    db $71,$31,$31,$31,$73,$31,$FC,$38        ;!
    db $52,$87,$00,$0B,$73,$31,$74,$31        ;!
    db $71,$31,$31,$31,$73,$31,$FC,$38        ;!
    db $52,$C7,$00,$05,$73,$31,$79,$30        ;!
    db $7C,$30,$FF                            ;!
                                              ;!
FileSelectStripe:                             ;!
    db $52,$05,$40,$2E,$FC,$38,$52,$28        ;!
    db $40,$1C,$FC,$38,$52,$45,$40,$2E        ;!
    db $FC,$38,$52,$68,$40,$1C,$FC,$38        ;!
    db $52,$85,$40,$2E,$FC,$38,$52,$C5        ;!
    db $40,$1C,$FC,$38,$52,$08,$00,$1F        ;!
    db $21,$31,$3E,$31,$30,$31,$73,$31        ;!
    db $FC,$38,$6D,$31,$FC,$38,$FC,$38        ;!
    db $FC,$38,$FC,$38,$21,$31,$3E,$31        ;!
    db $30,$31,$73,$31,$FC,$38,$51,$30        ;!
    db $52,$48,$00,$1F,$21,$31,$3E,$31        ;!
    db $30,$31,$73,$31,$FC,$38,$6E,$31        ;!
    db $FC,$38,$FC,$38,$FC,$38,$FC,$38        ;!
    db $21,$31,$3E,$31,$30,$31,$73,$31        ;!
    db $FC,$38,$52,$30,$52,$88,$00,$1F        ;!
    db $21,$31,$3E,$31,$30,$31,$73,$31        ;!
    db $FC,$38,$4E,$30,$FC,$38,$FC,$38        ;!
    db $FC,$38,$FC,$38,$21,$31,$3E,$31        ;!
    db $30,$31,$73,$31,$FC,$38,$53,$30        ;!
    db $52,$C8,$00,$0B,$21,$31,$3E,$31        ;!
    db $30,$31,$73,$31,$FC,$38,$50,$30        ;!
    db $FF                                    ;!
                                              ;!
PlayerSelectStripe:                           ;!
    db $52,$05,$40,$2F,$FC,$38,$52,$45        ;!
    db $40,$2F,$FC,$38,$52,$85,$40,$2F        ;!
    db $FC,$38,$52,$C5,$40,$1C,$FC,$38        ;!
    db $52,$0A,$00,$19,$6D,$31,$FC,$38        ;!
    db $6F,$31,$70,$31,$71,$31,$72,$31        ;!
    db $73,$31,$74,$31,$FC,$38,$75,$31        ;!
    db $71,$31,$76,$31,$73,$31,$52,$4A        ;!
    db $00,$19,$6E,$31,$FC,$38,$6F,$31        ;!
    db $70,$31,$71,$31,$72,$31,$73,$31        ;!
    db $74,$31,$FC,$38,$75,$31,$71,$31        ;!
    db $76,$31,$73,$31,$FF                    ;!
else                                          ;<================== U, E0, & E1 ================
EraseFileStripe:                              ;!
    db $51,$E5,$40,$2E,$FC,$38,$52,$08        ;!
    db $40,$1C,$FC,$38,$52,$25,$40,$2E        ;!
    db $FC,$38,$52,$48,$40,$1C,$FC,$38        ;!
    db $52,$65,$40,$2E,$FC,$38,$52,$A5        ;!
    db $40,$1C,$FC,$38,$51,$ED,$00,$1F        ;!
    db $76,$31,$71,$31,$74,$31,$82,$30        ;!
    db $83,$30,$FC,$38,$71,$31,$FC,$38        ;!
    db $24,$38,$24,$38,$24,$38,$73,$31        ;!
    db $76,$31,$6F,$31,$2F,$31,$72,$31        ;!
    db $52,$2D,$00,$1F,$76,$31,$71,$31        ;!
    db $74,$31,$82,$30,$83,$30,$FC,$38        ;!
    db $2C,$31,$FC,$38,$24,$38,$24,$38        ;!
    db $24,$38,$73,$31,$76,$31,$6F,$31        ;!
    db $2F,$31,$72,$31,$52,$6D,$00,$1F        ;!
    db $76,$31,$71,$31,$74,$31,$82,$30        ;!
    db $83,$30,$FC,$38,$2D,$31,$FC,$38        ;!
    db $24,$38,$24,$38,$24,$38,$73,$31        ;!
    db $76,$31,$6F,$31,$2F,$31,$72,$31        ;!
    db $51,$E7,$00,$0B,$73,$31,$74,$31        ;!
    db $71,$31,$31,$31,$73,$31,$FC,$38        ;!
    db $52,$27,$00,$0B,$73,$31,$74,$31        ;!
    db $71,$31,$31,$31,$73,$31,$FC,$38        ;!
    db $52,$67,$00,$0B,$73,$31,$74,$31        ;!
    db $71,$31,$31,$31,$73,$31,$FC,$38        ;!
    db $52,$A7,$00,$05,$73,$31,$79,$30        ;!
    db $7C,$30,$FF                            ;!
                                              ;!
FileSelectStripe:                             ;!
    db $51,$E5,$40,$2E,$FC                    ;!
    db $38,$52,$08,$40,$1C,$FC,$38,$52        ;!
    db $25,$40,$2E,$FC,$38,$52,$48,$40        ;!
    db $1C,$FC,$38,$52,$65,$40,$2E,$FC        ;!
    db $38,$52,$A5,$40,$1C,$FC,$38,$51        ;!
    db $EA,$00,$1F,$76,$31,$71,$31,$74        ;!
    db $31,$82,$30,$83,$30,$FC,$38,$71        ;!
    db $31,$FC,$38,$24,$38,$24,$38,$24        ;!
    db $38,$73,$31,$76,$31,$6F,$31,$2F        ;!
    db $31,$72,$31,$52,$2A,$00,$1F,$76        ;!
    db $31,$71,$31,$74,$31,$82,$30,$83        ;!
    db $30,$FC,$38,$2C,$31,$FC,$38,$24        ;!
    db $38,$24,$38,$24,$38,$73,$31,$76        ;!
    db $31,$6F,$31,$2F,$31,$72,$31,$52        ;!
    db $6A,$00,$1F,$76,$31,$71,$31,$74        ;!
    db $31,$82,$30,$83,$30,$FC,$38,$2D        ;!
    db $31,$FC,$38,$24,$38,$24,$38,$24        ;!
    db $38,$73,$31,$76,$31,$6F,$31,$2F        ;!
    db $31,$72,$31,$52,$AA,$00,$13,$73        ;!
    db $31,$74,$31,$71,$31,$31,$31,$73        ;!
    db $31,$FC,$38,$7C,$30,$71,$31,$2F        ;!
    db $31,$71,$31,$FF                        ;!
                                              ;!
PlayerSelectStripe:                           ;!
    db $51,$E5,$40,$2F,$FC,$38,$52,$25        ;!
    db $40,$2F,$FC,$38,$52,$65,$40,$2F        ;!
    db $FC,$38,$52,$A5,$40,$1C,$FC,$38        ;!
    db $52,$0A,$00,$19,$6D,$31,$FC,$38        ;!
    db $6F,$31,$70,$31,$71,$31,$72,$31        ;!
    db $73,$31,$74,$31,$FC,$38,$75,$31        ;!
    db $71,$31,$76,$31,$73,$31,$52,$4A        ;!
    db $00,$19,$6E,$31,$FC,$38,$6F,$31        ;!
    db $70,$31,$71,$31,$72,$31,$73,$31        ;!
    db $74,$31,$FC,$38,$75,$31,$71,$31        ;!
    db $76,$31,$73,$31,$FF                    ;!
endif                                         ;/===============================================

if ver_is_japanese(!_VER)                     ;\======================== J ====================
ContinueSaveStripe:                           ;!
    db $52,$0A,$00,$15,$38,$39,$39,$39        ;!
    db $3A,$39,$3B,$39,$3C,$39,$FC,$38        ;!
    db $80,$38,$81,$38,$36,$39,$37,$39        ;!
    db $88,$38,$52,$30,$00,$01,$35,$39        ;!
    db $52,$4A,$00,$19,$38,$39,$39,$39        ;!
    db $3A,$39,$3B,$39,$89,$38,$7B,$38        ;!
    db $3C,$39,$FC,$38,$80,$38,$81,$38        ;!
    db $36,$39,$37,$39,$88,$38,$FF            ;!
                                              ;!
ContinueEndStripe:                            ;!
    db $51,$CE,$00,$09,$80,$38,$81,$38        ;!
    db $36,$39,$37,$39,$88,$38,$52,$0E        ;!
    db $00,$05,$86,$38,$7A,$38,$88,$38        ;!
    db $FF                                    ;!
else                                          ;<================ U, SS, E0, & E1 ==============
ContinueSaveStripe:                           ;!
    db $51,$C6,$00,$21,$2D,$39,$7A,$38        ;!
    db $79,$38,$2F,$39,$82,$38,$79,$38        ;!
    db $7B,$38,$73,$39,$FC,$38,$71,$39        ;!
    db $79,$38,$7C,$38,$FC,$38,$31,$39        ;!
    db $71,$39,$80,$38,$73,$39,$52,$06        ;!
    db $00,$29,$2D,$39,$7A,$38,$79,$38        ;!
    db $2F,$39,$82,$38,$79,$38,$7B,$38        ;!
    db $73,$39,$FC,$38,$81,$38,$82,$38        ;!
    db $2F,$39,$84,$38,$7A,$38,$7B,$38        ;!
    db $2F,$39,$FC,$38,$31,$39,$71,$39        ;!
    db $80,$38,$73,$39,$FF                    ;!
                                              ;!
ContinueEndStripe:                            ;!
    db $51,$CD,$00,$0F,$2D,$39,$7A,$38        ;!
    db $79,$38,$2F,$39,$82,$38,$79,$38        ;!
    db $7B,$38,$73,$39,$52,$0D,$00,$05        ;!
    db $73,$39,$79,$38,$7C,$38,$FF            ;!
endif                                         ;/===============================================

DATA_05B93B:
    db $00,$06

DATA_05B93D:
    db $40,$06

DATA_05B93F:
    db $80,$06,$40,$07,$A0,$0E,$00,$08
    db $00,$05,$40,$05,$80,$05,$C0,$05
    db $80,$07,$C0,$07,$A0,$0D,$C0,$06
    db $00,$07,$C0,$04,$40,$04,$80,$04
    db $00,$04,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00

DATA_05B96B:
    db $00,$00,$00,$00,$00,$00,$01,$01
    db $01,$01,$01,$01,$01,$01,$02,$02
    db $02,$02

DATA_05B97D:
    db $02,$00,$00,$00,$00,$00,$00,$00
    db $00,$01,$00,$02,$02,$00

DATA_05B98B:
    db $00,$05,$0A,$0F,$14,$14,$19,$14
    db $0A,$14,$00,$05,$00,$14

AnimatedTileData:
    dw AnimatedTiles+$1800                    ; ? Block frame 1
    dw AnimatedTiles+$1A00                    ; ? Block frame 2
    dw AnimatedTiles+$1C00                    ; ? Block frame 3
    dw AnimatedTiles+$1E00                    ; ? Block frame 4
    dw AnimatedTiles+$1880                    ; Note block frame 1
    dw AnimatedTiles+$1A80                    ; Note block frame 2
    dw AnimatedTiles+$1C80                    ; Note block frame 3
    dw AnimatedTiles+$1E80                    ; Note block frame 4
    dw AnimatedTiles+$1900                    ; Turn block
    dw AnimatedTiles+$1900                    ; Turn block
    dw AnimatedTiles+$1900                    ; Turn block
    dw AnimatedTiles+$1900                    ; Turn block
    dw AnimatedTiles+$2080                    ; Midway point frame 1
    dw AnimatedTiles+$2280                    ; Midway point frame 2
    dw AnimatedTiles+$2480                    ; Midway point frame 3
    dw AnimatedTiles+$2680                    ; Midway point frame 4
    dw AnimatedTiles+$1900                    ; Spinning turn block frame 1
    dw AnimatedTiles+$1B00                    ; Spinning turn block frame 2
    dw AnimatedTiles+$1D00                    ; Spinning turn block frame 3
    dw AnimatedTiles+$1F00                    ; Spinning turn block frame 4
    dw AnimatedTiles-$F80                     ; Berry frame 1
    dw AnimatedTiles-$D80                     ; Berry frame 2
    dw AnimatedTiles-$100                     ; Berry frame 3
    dw AnimatedTiles-$80                      ; Berry frame 4
    dw AnimatedTiles+$2F20                    ; Blank
    dw AnimatedTiles+$2F20                    ; Blank
    dw AnimatedTiles+$2F20                    ; Blank
    dw AnimatedTiles+$2F20                    ; Blank
    dw AnimatedTiles+$2F20                    ; Blank
    dw AnimatedTiles+$2F20                    ; Blank
    dw AnimatedTiles+$2F20                    ; Blank
    dw AnimatedTiles+$2F20                    ; Blank
    dw AnimatedTiles+$1680                    ; Used block
    dw AnimatedTiles+$1680                    ; Used block
    dw AnimatedTiles+$1680                    ; Used block
    dw AnimatedTiles+$1680                    ; Used block
    dw AnimatedTiles+$2700                    ; Muncher frame 1
    dw AnimatedTiles+$2780                    ; Muncher frame 2
    dw AnimatedTiles+$2700                    ; Muncher frame 1
    dw AnimatedTiles+$2780                    ; Muncher frame 2
    dw AnimatedTiles+$2F20                    ; Blank
    dw AnimatedTiles+$2F20                    ; Blank
    dw AnimatedTiles+$2F20                    ; Blank
    dw AnimatedTiles+$2F20                    ; Blank
    dw AnimatedTiles+$2F00                    ; Line guide top-right bottom-left
    dw AnimatedTiles+$2F00                    ; Line guide top-right bottom-left
    dw AnimatedTiles+$2F00                    ; Line guide top-right bottom-left
    dw AnimatedTiles+$2F00                    ; Line guide top-right bottom-left
    dw AnimatedTiles+$1400                    ; On/Off block ON
    dw AnimatedTiles+$1400                    ; On/Off block ON
    dw AnimatedTiles+$1400                    ; On/Off block ON
    dw AnimatedTiles+$1400                    ; On/Off block ON
    dw AnimatedTiles+$1980                    ; Coin frame 1
    dw AnimatedTiles+$1B80                    ; Coin frame 2
    dw AnimatedTiles+$1D80                    ; Coin frame 3
    dw AnimatedTiles+$1F80                    ; Coin frame 4
    dw AnimatedTiles+$2000                    ; Water frame 1
    dw AnimatedTiles+$2200                    ; Water frame 2
    dw AnimatedTiles+$2400                    ; Water frame 3
    dw AnimatedTiles+$2600                    ; Water frame 4
    dw AnimatedTiles+$1180                    ; Lava frame 1
    dw AnimatedTiles+$1380                    ; Lava frame 2
    dw AnimatedTiles+$1580                    ; Lava frame 3
    dw AnimatedTiles+$1780                    ; Lava frame 4
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$2000                    ; Water frame 1
    dw AnimatedTiles+$2200                    ; Water frame 2
    dw AnimatedTiles+$2400                    ; Water frame 3
    dw AnimatedTiles+$2600                    ; Water frame 4
DATA_05BA39:
    dw AnimatedTiles+$1180                    ; Coin frame 1
    dw AnimatedTiles+$1380                    ; Coin frame 2
    dw AnimatedTiles+$1580                    ; Coin frame 3
    dw AnimatedTiles+$1780                    ; Coin frame 4
    dw AnimatedTiles                          ; Escalator Up frame 1
    dw AnimatedTiles+$200                     ; Escalator Up frame 2
    dw AnimatedTiles+$400                     ; Escalator Up frame 3
    dw AnimatedTiles+$600                     ; Escalator Up frame 4
    dw AnimatedTiles+$600                     ; Escalator Down frame 1
    dw AnimatedTiles+$400                     ; Escalator Down frame 2
    dw AnimatedTiles+$200                     ; Escalator Down frame 3
    dw AnimatedTiles                          ; Escalator Down frame 4
    dw AnimatedTiles+$2100                    ; Candle glow frame 1
    dw AnimatedTiles+$2300                    ; Candle glow frame 2
    dw AnimatedTiles+$2500                    ; Candle glow frame 3
    dw AnimatedTiles+$2300                    ; Candle glow frame 2
    dw AnimatedTiles+$2000                    ; Water frame 1
    dw AnimatedTiles+$2200                    ; Water frame 2
    dw AnimatedTiles+$2400                    ; Water frame 3
    dw AnimatedTiles+$2600                    ; Water frame 4
    dw AnimatedTiles+$2800                    ; Line guide stopper & Rope frame 1
    dw AnimatedTiles+$2A00                    ; Line guide stopper & Rope frame 2
    dw AnimatedTiles+$2C00                    ; Line guide stopper & Rope frame 3
    dw AnimatedTiles+$2E00                    ; Line guide stopper & Rope frame 4
    dw AnimatedTiles+$2880                    ; Diagonal rope Up frame 1
    dw AnimatedTiles+$2A80                    ; Diagonal rope Up frame 2
    dw AnimatedTiles+$2C80                    ; Diagonal rope Up frame 3
    dw AnimatedTiles+$2E80                    ; Diagonal rope Up frame 4
    dw AnimatedTiles+$2E80                    ; Diagonal rope Down frame 1
    dw AnimatedTiles+$2C80                    ; Diagonal rope Down frame 2
    dw AnimatedTiles+$2A80                    ; Diagonal rope Down frame 3
    dw AnimatedTiles+$2880                    ; Diagonal rope Down frame 4
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$2180                    ; Shining stars frame 1
    dw AnimatedTiles+$2380                    ; Shining stars frame 2
    dw AnimatedTiles+$2580                    ; Shining stars frame 3
    dw AnimatedTiles+$2380                    ; Shining stars frame 2
    dw AnimatedTiles+$80                      ; Gradual sloped lava frame 1
    dw AnimatedTiles+$280                     ; Gradual sloped lava frame 2
    dw AnimatedTiles+$480                     ; Gradual sloped lava frame 3
    dw AnimatedTiles+$680                     ; Gradual sloped lava frame 4
    dw AnimatedTiles+$100                     ; Diagonal sloped lava frame 1
    dw AnimatedTiles+$300                     ; Diagonal sloped lava frame 2
    dw AnimatedTiles+$500                     ; Diagonal sloped lava frame 3
    dw AnimatedTiles+$700                     ; Diagonal sloped lava frame 4
    dw AnimatedTiles+$180                     ; Lava wall frame 1
    dw AnimatedTiles+$380                     ; Lava wall frame 2
    dw AnimatedTiles+$580                     ; Lava wall frame 3
    dw AnimatedTiles+$780                     ; Lava wall frame 4
    dw AnimatedTiles+$680                     ; Gradual sloped lava frame 4
    dw AnimatedTiles+$480                     ; Gradual sloped lava frame 3
    dw AnimatedTiles+$280                     ; Gradual sloped lava frame 2
    dw AnimatedTiles+$80                      ; Gradual sloped lava frame 1
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$2980                    ; Ghost House lantern frame 1
    dw AnimatedTiles+$2B80                    ; Ghost House lantern frame 2
    dw AnimatedTiles+$2D80                    ; Ghost House lantern frame 3
    dw AnimatedTiles+$2B80                    ; Ghost House lantern frame 4
    dw AnimatedTiles+$1100                    ; Seaweed frame 1
    dw AnimatedTiles+$1300                    ; Seaweed frame 2
    dw AnimatedTiles+$1500                    ; Seaweed frame 3
    dw AnimatedTiles+$1700                    ; Seaweed frame 4
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$2180                    ; Shining stars frame 1
    dw AnimatedTiles+$2380                    ; Shining stars frame 2
    dw AnimatedTiles+$2580                    ; Shining stars frame 3
    dw AnimatedTiles+$2380                    ; Shining stars frame 2
    dw AnimatedTiles+$2900                    ; Twinkling stars frame 1
    dw AnimatedTiles+$2B00                    ; Twinkling stars frame 2
    dw AnimatedTiles+$2D00                    ; Twinkling stars frame 3
    dw AnimatedTiles+$2B00                    ; Twinkling stars frame 2
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1800                    ; ? Block
    dw AnimatedTiles+$1480                    ; Door
    dw AnimatedTiles+$1480                    ; Door
    dw AnimatedTiles+$1480                    ; Door
    dw AnimatedTiles+$1480                    ; Door
    dw AnimatedTiles+$1980                    ; Coin frame 1
    dw AnimatedTiles+$1B80                    ; Coin frame 2
    dw AnimatedTiles+$1D80                    ; Coin frame 3
    dw AnimatedTiles+$1F80                    ; Coin frame 4
    dw AnimatedTiles+$1980                    ; Coin frame 1
    dw AnimatedTiles+$1B80                    ; Coin frame 2
    dw AnimatedTiles+$1D80                    ; Coin frame 3
    dw AnimatedTiles+$1F80                    ; Coin frame 4
    dw AnimatedTiles+$1980                    ; Coin frame 1
    dw AnimatedTiles+$1B80                    ; Coin frame 2
    dw AnimatedTiles+$1D80                    ; Coin frame 3
    dw AnimatedTiles+$1F80                    ; Coin frame 4
    dw AnimatedTiles+$1800                    ; ? Block frame 1
    dw AnimatedTiles+$1A00                    ; ? Block frame 2
    dw AnimatedTiles+$1C00                    ; ? Block frame 3
    dw AnimatedTiles+$1E00                    ; ? Block frame 4
    dw AnimatedTiles+$2F80                    ; Line guide top-left bottom-right
    dw AnimatedTiles+$2F80                    ; Line guide top-left bottom-right
    dw AnimatedTiles+$2F80                    ; Line guide top-left bottom-right
    dw AnimatedTiles+$2F80                    ; Line guide top-left bottom-right
    dw AnimatedTiles+$1600                    ; On/Off block OFF
    dw AnimatedTiles+$1600                    ; On/Off block OFF
    dw AnimatedTiles+$1600                    ; On/Off block OFF
    dw AnimatedTiles+$1600                    ; On/Off block OFF
    dw AnimatedTiles+$1680                    ; Used block
    dw AnimatedTiles+$1680                    ; Used block
    dw AnimatedTiles+$1680                    ; Used block
    dw AnimatedTiles+$1680                    ; Used block

CODE_05BB39:
    PHB                                       ; AXY->8
    PHK
    PLB
    LDA.B EffFrame                            ;\
    AND.B #$07                                ;| Calculate the index of the first one of four 8x8 tiles in a 16x16 tile:
    STA.B _0                                  ;| GFX_TILE_IDX = (EffFrame & 0b111) + ((EffFrame & 0b111) << 1), which is equivalent to:
    ASL A                                     ;| GFX_TILE_IDX = (EffFrame & 0b111) * 3
    ADC.B _0                                  ;/
    TAY                                       ;\ Y = GFX_TILE_IDX
    ASL A                                     ;| 
    TAX                                       ;/ X = GFX_TILE_IDX * 2; index of VRAM address at $05B93B, $05B93D, and $05B93F
    REP #$20                                  ; A->16
    LDA.B EffFrame                            ;\
    AND.W #$0018                              ;| TILE_DATA_INDEX_PART = (EffFrame & 0b00011000) >> 2
    LSR A                                     ;| Extract bits 3 and 4 from EffFrame, and move them to bits 1 and 2: 0b000AB000 -> 0b00000AB0
    LSR A                                     ;| 
    STA.B _0                                  ;/ 
    LDA.W DATA_05B93B,X                       ;\ 
    STA.W Gfx33DestAddrC                      ;| 
    LDA.W DATA_05B93D,X                       ;| Write the 3 VRAM addresses of animated tiles' GFX into Gfx33DestAddr{A,B,C},
    STA.W Gfx33DestAddrB                      ;| using X as an index to the pointer tables at $05B93B, $05B93D, and $05B93F.
    LDA.W DATA_05B93F,X                       ;| 
    STA.W Gfx33DestAddrA                      ;/ 
    LDX.B #$04                                ; Initialise LOOP_COUNTER = 4
CODE_05BB67:
    PHY                                       ;\ Start loop, backup X and Y.
    PHX                                       ;/
    SEP #$20                                  ; A->8
    TYA                                       ; A = GFX_TILE_IDX
    LDX.W DATA_05B96B,Y                       ; X holds the value that determines how the current tile should behave.
    BEQ CODE_05BB88                           ; X == 0: the tile does not change based on any of the following conditions.
    DEX                                       ;\ X == 2: the tile changes depending on FG/BG tileset number.
    BNE CODE_05BB81                           ;/ 
    LDX.W DATA_05B97D,Y                       ; X == 1: tile changes depending on the two P-Switch timers and ON/OFF switch state.
    LDY.W BluePSwitchTimer,X                  ;\ If a P-Switch timer or ON/OFF Switch state is 0, handle the tile's default look,
    BEQ CODE_05BB88                           ;/ that is when it's unaffected by P-Switch timer or ON/OFF Switch.
    CLC                                       ;\ A = GFX_TILE_IDX + 0x26
    ADC.B #$26                                ;/ 
    BRA CODE_05BB88                           ; Handle the look of the tile.

CODE_05BB81:
    LDY.W ObjectTileset                       ; Load the current object tileset.
    CLC                                       ;\ Determine which group of animated tiles to use for current FG/BG tileset,
    ADC.W DATA_05B98B,Y                       ;/ as defined in the table at $05B98B.
CODE_05BB88:
    REP #$30                                  ; AXY->16
    AND.W #$00FF                              ;\ 
    ASL A                                     ;| 
    ASL A                                     ;| Calculate the index to AnimatedTileData:
    ASL A                                     ;| A = ((GFX_TILE_IDX & 0xFF) << 3) | TILE_DATA_INDEX_PART
    ORA.B _0                                  ;| 
    TAY                                       ;/
    LDA.W AnimatedTileData,Y                  ; Get VRAM address of the tile's current animation frame GFX.
    SEP #$10                                  ; XY->8
    PLX                                       ; X = LOOP_COUNTER
    STA.W Gfx33SrcAddrA,X                     ; Write that address to Gfx33SrcAddrA.
    PLY                                       ;\ Increment GFX_TILE_IDX.
    INY                                       ;/ 
    DEX                                       ;\ Subtract 2 from LOOP_COUNTER.
    DEX                                       ;/ 
    BPL CODE_05BB67                           ; Go back to the beginning of the loop if the LOOP_COUNTER is not negative.
    SEP #$20                                  ; A->8
    PLB
    RTL

    %insert_empty($48A,$5A,$84,$5A,$4A)

ProcScreenScrollCmds:
    PHB
    PHK
    PLB
    JSR CODE_05BC76
    JSR CODE_05BCA5
    JSR CODE_05BC4A
    LDA.W NextLayer1XPos
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.W Layer1DXPos
    STA.W Layer1DXPos
    LDA.W NextLayer1YPos
    SEC
    SBC.B Layer1YPos
    CLC
    ADC.W Layer1DYPos
    STA.W Layer1DYPos
    LDA.W NextLayer2XPos
    SEC
    SBC.B Layer2XPos
    LDY.W Layer2ScrollCmd
    DEY
    BNE +
    TYA
  + STA.W Layer2DXPos
    LDA.W NextLayer2YPos
    SEC
    SBC.B Layer2YPos
    STA.W Layer2DYPos
    LDA.W Layer3ScrollType
    BNE +
    JSR CODE_05C40C
  + PLB
    RTL

Return05BC49:
    RTS

CODE_05BC4A:
    REP #$20                                  ; A->16
    LDY.W Layer3TideSetting
    BNE CODE_05BC5F
    LDA.W NextLayer2XPos
    SEC
    SBC.W NextLayer1XPos
    STA.B Layer23XRelPos
    LDA.W NextLayer2YPos
    BRA +

CODE_05BC5F:
    LDA.B Layer3XPos
    SEC
    SBC.W NextLayer1XPos
    STA.B Layer23XRelPos
    LDA.B Layer3YPos
  + SEC
    SBC.W NextLayer1YPos
    STA.B Layer23YRelPos
    SEP #$20                                  ; A->8
    RTS

CODE_05BC72:
    JSR CODE_05BC4A
    RTL

CODE_05BC76:
    STZ.W ScrollLayerIndex
    LDA.W SpriteLock
    BNE Return05BC49
    LDA.W Layer1ScrollCmd
    BEQ Return05BC49
    JSL ExecutePtr

    dw CODE_05C04D                            ; 00 - Auto-Scroll, Unused?
    dw CODE_05C04D                            ; 01 - Auto-Scroll
    dw Return05BC49                           ; 02 - Layer 2 Smash
    dw Return05BC49                           ; 03 - Layer 2 Scroll
    dw ADDR_05C283                            ; 04 - Unused
    dw ADDR_05C69E                            ; 05 - Unused
    dw Return05BC49                           ; 06 - Layer 2 Falls
    dw Return05BFF5                           ; 07 - Unused
    dw CODE_05C51F                            ; 08 - Layer 2 Scroll
    dw Return05BC49                           ; 09 - Unused
    dw ADDR_05C32E                            ; 0A - Unused
    dw CODE_05C727                            ; 0B - Layer 2 On/Off Switch controlled
    dw CODE_05C787                            ; 0C - Auto-Scroll level
    dw Return05BC49                           ; 0D - Fast BG scroll
    dw Return05BC49                           ; 0E - Layer 2 sink/rise

CODE_05BCA5:
    LDA.B #$04
    STA.W ScrollLayerIndex
    LDA.W Layer2ScrollCmd
    BEQ Return05BC49
    LDY.W SpriteLock
    BNE Return05BC49
    JSL ExecutePtr

    dw CODE_05C04D
    dw CODE_05C198
    dw CODE_05C955
    dw CODE_05C5BB
    dw ADDR_05C283
    dw Return05BC49
    dw ADDR_05C659
    dw Return05BFF5
    dw CODE_05C51F
    dw CODE_05C7C1
    dw ADDR_05C32E
    dw CODE_05C727
    dw CODE_05C787
    dw CODE_05C7BC
    dw CODE_05C81C

CODE_05BCD6:
    PHB
    PHK
    PLB
    STZ.W ScrollLayerIndex
    JSR CODE_05BCE9
    LDA.B #$04
    STA.W ScrollLayerIndex
    JSR CODE_05BD0E
    PLB
    RTL

CODE_05BCE9:
    LDA.W Layer1ScrollCmd
    JSL ExecutePtr

    dw CODE_05BD36                            ; 00 - Auto-Scroll, Unused?
    dw CODE_05BD36                            ; 01 - Auto-Scroll
    dw CODE_05BF6A                            ; 02 - Layer 2 Smash
    dw CODE_05BF0A                            ; 03 - Layer 2 Scroll
    dw ADDR_05BDDD                            ; 04 - Unused
    dw ADDR_05BFBA                            ; 05 - Unused
    dw ADDR_05BF97                            ; 06 - Layer 2 Falls
    dw Return05BD35                           ; 07 - Unused
    dw CODE_05BEA6                            ; 08 - Layer 2 Scroll
    dw Return05BC49                           ; 09 - Unused
    dw ADDR_05BE3A                            ; 0A - Unused
    dw CODE_05BFF6                            ; 0B - Layer 2 On/Off Switch controlled
    dw CODE_05C005                            ; 0C - Auto-Scroll level
    dw CODE_05C01A                            ; 0D - Fast BG scroll
    dw CODE_05C036                            ; 0E - Layer 2 sink/rise

CODE_05BD0E:
    LDA.W Layer2ScrollCmd
    BEQ Return05BD35
    JSL ExecutePtr

    dw CODE_05BD4C
    dw CODE_05BD4C
    dw Return05BC49
    dw CODE_05BF20
    dw ADDR_05BDF0
    dw Return05BC49
    dw Return05BC49
    dw Return05BD35
    dw CODE_05BEC6
    dw CODE_05C022
    dw ADDR_05BE4D
    dw Return05BC49
    dw Return05BC49
    dw Return05BC49
    dw Return05BC49

Return05BD35:
    RTS

CODE_05BD36:
    STZ.W HorizLayer1Setting
    LDA.W Layer1ScrollBits
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.W DATA_05C9D1,Y
    STA.W Layer1ScrollCmd
    LDA.W DATA_05C9DB,Y
    STA.W Layer1ScrollBits
CODE_05BD4C:
    LDX.W ScrollLayerIndex
    REP #$20                                  ; A->16
    STZ.W Layer1ScrollXSpeed,X
    STZ.W Layer1ScrollYSpeed,X
    STZ.W Layer1ScrollXPosUpd,X
    STZ.W Layer1ScrollYPosUpd,X
    SEP #$20                                  ; A->8
    TXA
    LSR A
    LSR A
    TAX
    LDY.W Layer1ScrollBits
    LDA.W ScrollLayerIndex
    BEQ +
    LDY.W Layer2ScrollBits
  + LDA.W DATA_05CA61,Y
    STA.W Layer1ScrollType,X
    LDA.W DATA_05CA68,Y
    STA.W Layer1ScrollTimer,X
    RTS

    LDA.W Layer1ScrollBits                    ; \ Unreachable
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.W DATA_05C9E5,Y
    STA.W Layer1ScrollCmd
    LDA.W DATA_05C9E7,Y
    STA.W Layer1ScrollBits
    REP #$20                                  ; A->16
    LDY.W Layer1ScrollBits
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    BEQ +
    LDY.W Layer2ScrollBits
  + LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W DATA_05C9E9,Y
    STA.W Layer1ScrollType,X
    LDA.W DATA_05CBC7,Y
    AND.W #$00FF
    BEQ +
    EOR.W #$FFFF
    INC A
  + LDX.W ScrollLayerIndex
    CLC
    ADC.W NextLayer1YPos,X
    AND.W #$00FF
    STA.W Layer1ScrollXPosUpd,X
    STZ.W Layer1ScrollYPosUpd,X
CODE_05BDC9:
    STZ.W Layer1ScrollXSpeed,X
    STZ.W Layer1ScrollYSpeed,X
CODE_05BDCF:
    SEP #$20                                  ; A->8
    TXA
    LSR A
    LSR A
    AND.B #$FF
    TAX
    LDA.B #$FF
    STA.W Layer1ScrollTimer,X
    RTS

ADDR_05BDDD:
    LDA.W Layer1ScrollBits
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.W DATA_05CA08,Y
    STA.W Layer1ScrollCmd
    LDA.W DATA_05CA0C,Y
    STA.W Layer1ScrollBits
ADDR_05BDF0:
    REP #$20                                  ; A->16
    LDY.W Layer1ScrollBits
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    BEQ +
    LDY.W Layer2ScrollBits
  + LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W DATA_05CA10,Y
    STA.W Layer1ScrollType,X
    PHA
    TYA
    ASL A
    TAY
    LDA.W DATA_05CA12,Y
    STA.B _0
    PLA
    TAY
    LDX.W ScrollLayerIndex
    LDA.B _0
    CPY.B #$01
    BEQ +
    EOR.W #$FFFF
    INC A
  + CLC
    ADC.W NextLayer1YPos,X
    STA.W Layer1ScrollXPosUpd,X
    STZ.W Layer1ScrollXSpeed,X
    STZ.W Layer1ScrollYSpeed,X
    STZ.W Layer1ScrollYPosUpd,X
    SEP #$20                                  ; A->8
    RTS

ADDR_05BE3A:
    LDA.W Layer1ScrollBits
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.W DATA_05CA16,Y
    STA.W Layer1ScrollCmd
    LDA.W DATA_05CA1E,Y
    STA.W Layer1ScrollBits
ADDR_05BE4D:
    REP #$20                                  ; A->16
    LDY.W Layer1ScrollBits
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    BEQ +
    LDY.W Layer2ScrollBits
  + LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W DATA_05CA26,Y
    STA.W Layer1ScrollType,X
    TAY
    LDX.W ScrollLayerIndex
    LDA.W #$0F17
    CPY.B #$01
    BEQ +
    EOR.W #$FFFF
    INC A
  + STA.W Layer1ScrollYPosUpd,X
    STZ.W Layer1ScrollXSpeed,X
    STZ.W Layer1ScrollYSpeed,X
    STZ.W Layer1ScrollXPosUpd,X
    SEP #$20                                  ; A->8
    RTS

CODE_05BE8A:
    PHB
    PHK
    PLB
    REP #$20                                  ; A->16
    LDA.W DATA_05CA26
    STA.W Layer3ScroolDir
    STZ.W Layer3ScrollXSpeed
    STZ.W Layer3ScrollYSpeed
    STZ.W Layer3ScrollXPosUpd
    LDA.B Layer1YPos
    STA.B Layer3YPos
    SEP #$20                                  ; A->8
    PLB
    RTL

CODE_05BEA6:
    STZ.W HorizLayer1Setting
    LDA.W Layer1ScrollBits
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.W DATA_05CA3E,Y
    STA.W Layer1ScrollCmd
    LDA.W DATA_05CA42,Y
    STA.W Layer1ScrollBits
    STZ.B Layer1XPos
    STZ.W NextLayer1XPos
    STZ.B Layer2XPos
    STZ.W NextLayer2XPos
CODE_05BEC6:
    REP #$20                                  ; A->16
    LDY.W Layer1ScrollBits
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    BEQ +
    LDY.W Layer2ScrollBits
  + LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W DATA_05CA46,Y
    STA.W Layer1ScrollType,X
    TAX
    TYA
    ASL A
    TAY
    LDA.W DATA_05CBED,Y
    AND.W #$00FF
    CPX.B #$01
    BEQ +
    EOR.W #$FFFF
    INC A
  + LDX.W ScrollLayerIndex
    CLC
    ADC.W NextLayer1XPos,X
    AND.W #$00FF
    STA.W Layer1ScrollYPosUpd,X
    STZ.W Layer1ScrollXPosUpd,X
    JMP CODE_05BDC9

CODE_05BF0A:
    STZ.W VertLayer2Setting
    LDA.W Layer1ScrollBits
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.W DATA_05CA48,Y
    STA.W Layer1ScrollCmd
    LDA.W DATA_05CA52,Y
    STA.W Layer1ScrollBits
CODE_05BF20:
    REP #$20                                  ; A->16
    LDY.W Layer1ScrollBits
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    BEQ +
    LDY.W Layer2ScrollBits
  + LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W DATA_05CA5C,Y
    STA.W Layer1ScrollType,X
    TAX
    TYA
    ASL A
    TAY
    LDA.W DATA_05CBF5,Y
    AND.W #$00FF
    CPX.B #$01
    BEQ +
    EOR.W #$FFFF
    INC A
  + LDX.W ScrollLayerIndex
    CLC
    ADC.W NextLayer1YPos,X
    AND.W #$00FF
    STA.W Layer1ScrollXPosUpd,X
    STZ.W Layer1ScrollYPosUpd,X
    STZ.W Layer1ScrollYSpeed,X
    STZ.W Layer1ScrollYSpeed,X
    JMP CODE_05BDCF

CODE_05BF6A:
    LDY.W Layer1ScrollBits
    LDA.W DATA_05C94F,Y
    STA.W Layer1ScrollBits
    LDA.W DATA_05C952,Y
    STA.W Layer2ScrollBits
    REP #$20                                  ; A->16
    LDA.W #$0200
    JSR CODE_05BFD2
    LDA.W Layer1ScrollBits
    CLC
    ADC.B #$0A
    TAX
    LDY.B #$01
    JSR CODE_05C95B
    REP #$20                                  ; A->16
    LDA.W NextLayer2YPos
    STA.B Layer2YPos
    JMP CODE_05C32B

ADDR_05BF97:
    STZ.W HorizLayer1Setting
    REP #$20                                  ; A->16
    STZ.B Layer1XPos
    STZ.W NextLayer1XPos
    STZ.B Layer2XPos
    STZ.W NextLayer2XPos
    LDA.W #$0600
    STA.W Layer1ScrollCmd
    STZ.W Layer2ScrollYSpeed
    STZ.W Layer2ScrollYPosUpd
    SEP #$20                                  ; A->8
    LDA.B #$60
    STA.W Layer2ScrollBits
    RTS

ADDR_05BFBA:
    STZ.W HorizLayer1Setting
    REP #$20                                  ; A->16
    STZ.B Layer2XPos
    STZ.W NextLayer2XPos
    LDA.W #$03C0
    STA.B Layer2YPos
    STA.W NextLayer2YPos
    STZ.W Layer1ScrollBits
    LDA.W #$0005
CODE_05BFD2:
    STZ.W Layer1ScrollTimer
CODE_05BFD5:
    STZ.W Layer1ScrollType
    STA.W Layer1ScrollCmd
    STZ.W Layer1ScrollXSpeed
    STZ.W Layer1ScrollYSpeed
    STZ.W Layer1ScrollXPosUpd
    STZ.W Layer1ScrollYPosUpd
    STZ.W Layer2ScrollXSpeed
    STZ.W Layer2ScrollYSpeed
    STZ.W Layer2ScrollXPosUpd
    STZ.W Layer2ScrollYPosUpd
    SEP #$20                                  ; A->8
Return05BFF5:
    RTS

CODE_05BFF6:
    REP #$20                                  ; A->16
    LDA.W #$0B00
    BRA CODE_05BFD2


DATA_05BFFD:
    db $00,$00,$02,$00

DATA_05C001:
    db $80,$00,$00,$01

CODE_05C005:
    STZ.W HorizLayer1Setting
    LDA.W Layer1ScrollBits
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.W DATA_05BFFD,Y
    STA.W Layer1ScrollBits
    LDA.W #$000C
    BRA CODE_05BFD2

CODE_05C01A:
    REP #$20                                  ; A->16
    LDA.W #$0D00
    JSR CODE_05BFD2
CODE_05C022:
    STZ.W HorizLayer2Setting
    REP #$20                                  ; A->16
    STZ.W Layer2ScrollXSpeed
    STZ.W Layer2ScrollYSpeed
    STZ.W Layer2ScrollXPosUpd
    STZ.W Layer2ScrollYPosUpd
    SEP #$20                                  ; A->8
    RTS

CODE_05C036:
    LDY.W Layer1ScrollBits
    LDA.W DATA_05C808,Y
    STA.W Layer1ScrollTimer
    LDA.W DATA_05C80B,Y
    STA.W Layer2ScrollTimer
    REP #$20                                  ; A->16
    LDA.W #$0E00
    JMP CODE_05BFD5

CODE_05C04D:
    LDA.W ScrollLayerIndex
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollTimer,X
    BNE +
    LDX.W ScrollLayerIndex
    STZ.W Layer1ScrollXSpeed,X
    RTS

  + REP #$20                                  ; A->16
    LDA.W Layer1ScrollType,X
    TAY
    LDA.W DATA_05CA6E,Y
    AND.W #$00FF
    STA.B _4
    LDA.W DATA_05CABE,Y
    AND.W #$00FF
    STA.B _6
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    TAX
    LDA.W NextLayer1XPos,X
    STA.B _0
    LDA.W NextLayer1YPos,X
    STA.B _2
    LDX.B #$02
    LDA.W DATA_05CA6F,Y
    AND.W #$00FF
    CMP.B _4
    BNE CODE_05C098
    STZ.B _4
    STX.B _8
    BRA CODE_05C0AD

CODE_05C098:
    ASL A
    ASL A
    ASL A
    ASL A
    SEC
    SBC.B _0
    STA.B _0
    BPL +
    LDX.B #$00
    EOR.W #$FFFF
    INC A
  + STA.B _4
    STX.B _8
CODE_05C0AD:
    LDX.B #$00
    LDA.W DATA_05CABF,Y
    AND.W #$00FF
    CMP.B _6
    BNE CODE_05C0BD
    STZ.B _6
    BRA CODE_05C0D0

CODE_05C0BD:
    ASL A
    ASL A
    ASL A
    ASL A
    SEC
    SBC.B _2
    STA.B _2
    BPL +
    LDX.B #$02
    EOR.W #$FFFF
    INC A
  + STA.B _6
CODE_05C0D0:
    LDA.B ScreenMode
    LSR A
    BCS +
    LDX.B _8
  + STX.B Layer1ScrollDir
    LDA.W #$FFFF
    STA.B _8
    LDA.B _4
    STA.B _A
    LDA.B _6
    STA.B _C
    CMP.B _4
    BCC +
    STA.B _A
    LDA.B _4
    STA.B _C
    LDA.W #$0001
    STA.B _8
  + LDA.B _A
    STA.W HW_WRDIV
    SEP #$20                                  ; A->8
    LDA.W DATA_05CB0F,Y
    STA.W HW_WRDIV+2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    REP #$20                                  ; A->16
    LDA.W HW_RDDIV
    BNE +
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    INC.W Layer1ScrollType,X
    SEP #$20                                  ; A->8
    DEC.W Layer1ScrollTimer,X
    JMP CODE_05C04D

  + STA.B _A
    LDA.B _C
    ASL A
    ASL A
    ASL A
    ASL A
    STA.B _C
    LDY.B #$10
    LDA.W #$0000
    STA.B _E
CODE_05C134:
    ASL.B _C
    ROL A
    CMP.B _A
    BCC +
    SBC.B _A
  + ROL.B _E
    DEY
    BNE CODE_05C134
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollType,X
    TAY
    LDA.W DATA_05CB0F,Y
    AND.W #$00FF
    ASL A
    ASL A
    ASL A
    ASL A
    STA.B _A
    LDX.B #$02
CODE_05C15D:
    LDA.B _8
    BMI CODE_05C165
    LDA.B _A
    BRA +

CODE_05C165:
    LDA.B _E
  + BIT.B _0,X
    BPL +
    EOR.W #$FFFF
    INC A
  + PHX
    PHA
    TXA
    CLC
    ADC.W ScrollLayerIndex
    TAX
    PLA
    LDY.B #$00
    CMP.W Layer1ScrollXSpeed,X
    BEQ CODE_05C18D
    BPL +
    LDY.B #$02
  + LDA.W Layer1ScrollXSpeed,X
    CLC
    ADC.W DATA_05CB5F,Y
    STA.W Layer1ScrollXSpeed,X
CODE_05C18D:
    JSR CODE_05C4F9
    PLX
    DEX
    DEX
    BPL CODE_05C15D
    SEP #$20                                  ; A->8
    RTS

CODE_05C198:
    JSR CODE_05C04D
    REP #$20                                  ; A->16
    LDA.W NextLayer2XPos
    STA.W NextLayer1XPos
    LDA.B Layer2YPos
    CLC
    ADC.W ScreenShakeYOffset
    STA.B Layer2YPos
    SEP #$20                                  ; A->8
    RTS

    LDA.W ScrollLayerIndex                    ; \ Unreachable
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollTimer,X
    BMI ADDR_05C1D4
    DEC.W Layer1ScrollTimer,X
    LDA.W Layer1ScrollTimer,X
    CMP.B #$20
    BCC +
    REP #$20                                  ; A->16
    LDX.W ScrollLayerIndex
    LDA.W NextLayer1YPos,X
    EOR.W #$0001
    STA.W NextLayer1YPos,X
  + JMP CODE_05C32B

ADDR_05C1D4:
    REP #$30                                  ; AXY->16
    LDY.W ScrollLayerIndex
    LDA.W Layer1ScrollXPosUpd,Y
    TAX
    LDA.W NextLayer1YPos,Y
    CMP.W Layer1ScrollXPosUpd,Y
    BCC ADDR_05C1EB
    STA.B _4
    STX.B _2
    BRA +

ADDR_05C1EB:
    STA.B _2
    STX.B _4
  + SEP #$10                                  ; XY->8
    LDA.B _2
    CMP.B _4
    BCC ADDR_05C24D
    SEP #$20                                  ; A->8
    LDA.W ScrollLayerIndex
    AND.B #$FF
    LSR A
    LSR A
    TAX
    LDA.B #$30
    STA.W Layer1ScrollTimer,X
    REP #$20                                  ; A->16
    LDX.W ScrollLayerIndex
    STZ.W Layer1ScrollYSpeed,X
    STZ.W Layer1ScrollYPosUpd,X
    LDY.W Layer1ScrollBits
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    BEQ +
    LDY.W Layer2ScrollBits
  + LDA.W DATA_05CBC7,Y
    AND.W #$00FF
    STA.B _0
    TXA
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollType,X
    EOR.W #$0001
    STA.W Layer1ScrollType,X
    AND.W #$00FF
    BNE +
    LDA.B _0
    EOR.W #$FFFF
    INC A
    STA.B _0
  + LDX.W ScrollLayerIndex
    LDA.B _0
    CLC
    ADC.W Layer1ScrollXPosUpd,X
    STA.W Layer1ScrollXPosUpd,X
ADDR_05C24D:
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAY
    LDA.W Layer1ScrollType,Y
    TAX
    LDA.W DATA_05CBC8,X
    AND.W #$00FF
    CPX.B #$01
    BEQ +
    EOR.W #$FFFF
    INC A
  + LDX.W ScrollLayerIndex
    LDY.B #$00
    CMP.W Layer1ScrollYSpeed,X
    BEQ ADDR_05C280
    BPL +
    LDY.B #$02
  + LDA.W Layer1ScrollYSpeed,X
    CLC
    ADC.W DATA_05CB7B,Y
    STA.W Layer1ScrollYSpeed,X
ADDR_05C280:
    JMP ADDR_05C31D

ADDR_05C283:
    REP #$20                                  ; A->16
    LDY.W ScrollLayerIndex
    LDA.W Layer1ScrollXPosUpd,Y
    SEC
    SBC.W NextLayer1YPos,Y
    BPL +
    EOR.W #$FFFF
    INC A
  + STA.B _2
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollType,X
    AND.W #$00FF
    TAY
    LSR A
    TAX
    LDA.B _2
    STA.W HW_WRDIV
    SEP #$20                                  ; A->8
    LDA.W DATA_05CBE3,X
    STA.W HW_WRDIV+2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    REP #$20                                  ; A->16
    LDA.W HW_RDDIV
    BNE ADDR_05C2E5
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollType,X
    TAY
    LDX.W ScrollLayerIndex
    LDA.W #$0200
    CPY.B #$01
    BNE +
    EOR.W #$FFFF
    INC A
  + CLC
    ADC.W NextLayer1YPos,X
    STA.W NextLayer1YPos,X
ADDR_05C2E5:
    LDX.W Layer1ScrollBits
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    BEQ +
    LDX.W Layer2ScrollBits
  + LDA.W DATA_05CBE3,X
    AND.W #$00FF
    ASL A
    ASL A
    ASL A
    ASL A
    CPY.B #$01
    BEQ +
    EOR.W #$FFFF
    INC A
  + LDX.W ScrollLayerIndex
    LDY.B #$00
    CMP.W Layer1ScrollYSpeed,X
    BEQ ADDR_05C31D
    BPL +
    LDY.B #$02
  + LDA.W Layer1ScrollYSpeed,X
    CLC
    ADC.W DATA_05CB9B,Y
    STA.W Layer1ScrollYSpeed,X
ADDR_05C31D:
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    CLC
    ADC.W #$0002
    TAX
CODE_05C328:
    JSR CODE_05C4F9
CODE_05C32B:
    SEP #$20                                  ; A->8
    RTS

ADDR_05C32E:
    REP #$20                                  ; A->16
    LDY.W ScrollLayerIndex
    LDA.W Layer1ScrollYPosUpd,Y
    SEC
    SBC.W NextLayer1XPos,Y
    BPL +
    EOR.W #$FFFF
    INC A
  + STA.B _2
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollType,X
    AND.W #$00FF
    TAY
    LSR A
    TAX
    LDA.B _2
    STA.W HW_WRDIV
    SEP #$20                                  ; A->8
    LDA.W DATA_05CBE5,X
    STA.W HW_WRDIV+2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    REP #$20                                  ; A->16
    LDA.W HW_RDDIV
    BNE ADDR_05C39F
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollType,X
    TAY
    LDX.W ScrollLayerIndex
    LDA.W #$0600
    CPY.B #$01
    BNE +
    EOR.W #$FFFF
    INC A
  + CLC
    ADC.W NextLayer1XPos,X
    STA.W NextLayer1XPos,X
    LDA.W #$FFF8
    STA.W Layer1TileUp,X
    LDA.W #$0017
    STA.W Layer1TileDown,X
    STZ.W PlayerXPosNext+1
ADDR_05C39F:
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollType,X
    AND.W #$00FF
    PHA
    SEP #$20                                  ; A->8
    LDX.B #$02
    LDY.B #$00
    CMP.B #$01
    BEQ +
    LDX.B #$00
    LDY.B #$01
  + TXA
    STA.W Layer1ScrollDir,Y
    REP #$20                                  ; A->16
    PLA
    TAY
    LDX.W Layer1ScrollBits
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    BEQ +
    LDX.W Layer2ScrollBits
  + LDA.W DATA_05CBE5,X
    AND.W #$00FF
    ASL A
    ASL A
    ASL A
    ASL A
    CPY.B #$01
    BEQ +
    EOR.W #$FFFF
    INC A
  + LDX.W ScrollLayerIndex
    LDY.B #$00
    CMP.W Layer1ScrollXSpeed,X
    BEQ ADDR_05C3FD
    BPL +
    LDY.B #$02
  + LDA.W Layer1ScrollXSpeed,X
    CLC
    ADC.W DATA_05CBA3,Y
    STA.W Layer1ScrollXSpeed,X
ADDR_05C3FD:
    LDX.W ScrollLayerIndex
    JSR CODE_05C4F9
    SEP #$20                                  ; A->8
    RTS


DATA_05C406:
    db $FF,$01

DATA_05C408:
    db $FC,$04

DATA_05C40A:
    db $30,$A0

CODE_05C40C:
    LDA.W Layer3TideSetting
    BEQ +
    JMP CODE_05C494

  + REP #$20                                  ; A->16
    LDY.W ObjectTileset
    CPY.B #$01
    BEQ CODE_05C421
    CPY.B #$03
    BNE CODE_05C428
CODE_05C421:
    LDA.B Layer1XPos
    LSR A
    STA.B Layer3XPos
    BRA CODE_05C491

CODE_05C428:
    LDY.W SpriteLock
    BNE CODE_05C48D
    LDA.W Layer3ScroolDir
    AND.W #$00FF
    TAY
    LDA.W DATA_05CBEB
    AND.W #$00FF
    ASL A
    ASL A
    ASL A
    ASL A
    CPY.B #$01
    BEQ +
    EOR.W #$FFFF
    INC A
  + LDY.B #$00
    CMP.W Layer3ScrollXSpeed
    BEQ CODE_05C45B
    BPL +
    LDY.B #$02
  + LDA.W Layer3ScrollXSpeed
    CLC
    ADC.W DATA_05CBBB,Y
    STA.W Layer3ScrollXSpeed
CODE_05C45B:
    LDA.W Layer3ScrollXPosUpd
    AND.W #$00FF
    CLC
    ADC.W Layer3ScrollXSpeed
    STA.W Layer3ScrollXPosUpd
    AND.W #$FF00
    BPL +
    ORA.W #$00FF
  + XBA
    CLC
    ADC.B Layer3XPos
    STA.B Layer3XPos
    LDA.W Layer1DXPos
    AND.W #$00FF
    CMP.W #$0080
    BCC +
    ORA.W #$FF00
  + STA.B _0
    LDA.B Layer3XPos
    CLC
    ADC.B _0
    STA.B Layer3XPos
CODE_05C48D:
    LDA.B Layer1YPos
    STA.B Layer3YPos
CODE_05C491:
    SEP #$20                                  ; A->8
    RTS

CODE_05C494:
    DEC A
    BNE CODE_05C4EC
    LDA.W SpriteLock
    BNE CODE_05C4EC
    LDY.W Layer3ScroolDir
    LDA.B EffFrame
    AND.B #$03
    BNE CODE_05C4C0
    LDA.W Layer3ScrollYSpeed
    BNE CODE_05C4AF
    DEC.W Layer3TideTimer
    BNE CODE_05C4EC
CODE_05C4AF:
    CMP.W DATA_05C408,Y
    BEQ +
    CLC
    ADC.W DATA_05C406,Y
    STA.W Layer3ScrollYSpeed
  + LDA.B #$4B
    STA.W Layer3TideTimer
CODE_05C4C0:
    LDA.B Layer3YPos
    CMP.W DATA_05C40A,Y
    BNE +
    TYA
    EOR.B #$01
    STA.W Layer3ScroolDir
  + LDA.W Layer3ScrollYSpeed
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.W Layer3ScrollXPosUpd
    STA.W Layer3ScrollXPosUpd
    LDA.W Layer3ScrollYSpeed
    PHP
    LSR A
    LSR A
    LSR A
    LSR A
    PLP
    BPL +
    ORA.B #$F0
  + ADC.B Layer3YPos
    STA.B Layer3YPos
CODE_05C4EC:
    LDA.B Layer3XPos
    SEC
    ADC.W Layer1DXPos
    STA.B Layer3XPos
    LDA.B #$01
    STA.B Layer3XPos+1
    RTS

CODE_05C4F9:
    LDA.W Layer1ScrollXPosUpd,X
    AND.W #$00FF
    CLC
    ADC.W Layer1ScrollXSpeed,X
    STA.W Layer1ScrollXPosUpd,X
    AND.W #$FF00
    BPL +
    ORA.W #$00FF
  + XBA
    CLC
    ADC.W NextLayer1XPos,X
    STA.W NextLayer1XPos,X
    LDA.B _8
    EOR.W #$FFFF
    INC A
    STA.B _8
    RTS

CODE_05C51F:
    REP #$30                                  ; AXY->16
    LDY.W ScrollLayerIndex
    REP #$30                                  ; AXY->16
    LDA.W Layer1ScrollYPosUpd,Y
    TAX
    LDA.W NextLayer1XPos,Y
    CMP.W Layer1ScrollYPosUpd,Y
    BCC CODE_05C538
    STA.B _4
    STX.B _2
    BRA +

CODE_05C538:
    STA.B _2
    STX.B _4
  + SEP #$10                                  ; XY->8
    LDA.B _2
    CMP.B _4
    BCC CODE_05C585
    LDY.W Layer1ScrollBits
    LDA.W ScrollLayerIndex
    BEQ +
    LDY.W Layer2ScrollBits
  + TYA
    ASL A
    TAY
    LDA.W DATA_05CBEE,Y
    AND.W #$00FF
    STA.B _0
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollType,X
    EOR.W #$0001
    STA.W Layer1ScrollType,X
    AND.W #$00FF
    BNE +
    LDA.B _0
    EOR.W #$FFFF
    INC A
    STA.B _0
  + LDX.W ScrollLayerIndex
    LDA.B _0
    CLC
    ADC.W Layer1ScrollYPosUpd,X
    STA.W Layer1ScrollYPosUpd,X
CODE_05C585:
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollType,X
    TAX
    LDA.W DATA_05CBF1,X
    AND.W #$00FF
    CPX.B #$01
    BEQ +
    EOR.W #$FFFF
    INC A
  + LDX.W ScrollLayerIndex
    LDY.B #$00
    CMP.W Layer1ScrollXSpeed,X
    BEQ CODE_05C5B8
    BPL +
    LDY.B #$02
  + LDA.W Layer1ScrollXSpeed,X
    CLC
    ADC.W DATA_05CBC3,Y
    STA.W Layer1ScrollXSpeed,X
CODE_05C5B8:
    JMP CODE_05C328

CODE_05C5BB:
    REP #$30                                  ; AXY->16
    LDY.W ScrollLayerIndex
    REP #$30                                  ; AXY->16
    LDA.W Layer1ScrollXPosUpd,Y
    TAX
    LDA.W NextLayer1YPos,Y
    CMP.W Layer1ScrollXPosUpd,Y
    BCC CODE_05C5D4
    STA.B _4
    STX.B _2
    BRA +

CODE_05C5D4:
    STA.B _2
    STX.B _4
  + SEP #$10                                  ; XY->8
    LDA.B _2
    CMP.B _4
    BCC CODE_05C621
    LDY.W Layer1ScrollBits
    LDA.W ScrollLayerIndex
    BEQ +
    LDY.W Layer2ScrollBits
  + TYA
    ASL A
    TAY
    LDA.W DATA_05CBF6,Y
    AND.W #$00FF
    STA.B _0
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollType,X
    EOR.W #$0001
    STA.W Layer1ScrollType,X
    AND.W #$00FF
    BNE +
    LDA.B _0
    EOR.W #$FFFF
    INC A
    STA.B _0
  + LDX.W ScrollLayerIndex
    LDA.B _0
    CLC
    ADC.W Layer1ScrollXPosUpd,X
    STA.W Layer1ScrollXPosUpd,X
CODE_05C621:
    LDA.W ScrollLayerIndex
    AND.W #$00FF
    LSR A
    LSR A
    TAX
    LDA.W Layer1ScrollType,X
    TAX
    LDA.W DATA_05CBF1,X
    AND.W #$00FF
    CPX.B #$01
    BEQ +
    EOR.W #$FFFF
    INC A
  + LDX.W ScrollLayerIndex
    LDY.B #$00
    CMP.W Layer1ScrollYSpeed,X
    BEQ CODE_05C654
    BPL +
    LDY.B #$02
  + LDA.W Layer1ScrollYSpeed,X
    CLC
    ADC.W DATA_05CBC3,Y
    STA.W Layer1ScrollYSpeed,X
CODE_05C654:
    INX
    INX
    JMP CODE_05C328

ADDR_05C659:
    LDA.W Layer2ScrollBits
    BEQ ++
    DEC.W Layer2ScrollBits
    CMP.B #$20
    BCS +
    LDA.B EffFrame
    AND.B #$01
    BNE +
    LDA.W NextLayer1YPos
    EOR.B #$01
    STA.W NextLayer1YPos
  + RTS

 ++ STZ.B Layer2ScrollDir
    REP #$20                                  ; A->16
    LDA.W Layer2ScrollYSpeed
    CMP.W #$FFC0
    BEQ +
    DEC A
    STA.W Layer2ScrollYSpeed
  + LDA.W NextLayer2YPos
    CMP.W #$0031
    BPL +
    STZ.W Layer2ScrollYSpeed
  + BNE +
    LDY.B #$20
    STY.W Layer2ScrollBits
  + LDX.B #$06
    JSR CODE_05C4F9
    JMP CODE_05C32B

ADDR_05C69E:
    LDA.B #$02
    STA.B Layer1ScrollDir
    STZ.B Layer2ScrollDir
    REP #$20                                  ; A->16
    LDX.W Layer1ScrollBits
    BNE ADDR_05C6CD
    LDA.W Layer1ScrollXSpeed
    CMP.W #$0080
    BEQ +
    INC A
  + STA.W Layer1ScrollXSpeed
    LDY.B LastScreenHoriz
    DEY
    CPY.W NextLayer1XPos+1
    BNE ADDR_05C6EC
    INC.W Layer1ScrollBits
    STZ.W Layer1ScrollXSpeed
    LDA.W #$FCF0
    STA.W Empty1B97
    BRA ADDR_05C6EC

ADDR_05C6CD:
    LDY.B #$16                                ; \ Unreachable
    STY.W HW_TM
    LDA.W Layer2ScrollYSpeed
    CMP.W #$FF80
    BEQ +
    DEC A
  + STA.W Layer2ScrollYSpeed
    STA.W Layer1ScrollYSpeed
    LDA.W NextLayer2YPos
    BNE ADDR_05C6EC
    STZ.W Layer2ScrollYSpeed
    STZ.W Layer1ScrollYSpeed
ADDR_05C6EC:
    LDX.B #$06
  - JSR CODE_05C4F9
    DEX
    DEX
    BPL -
    SEP #$20                                  ; A->8
    LDA.W NextLayer1XPos+1
    SEC
    SBC.B LastScreenHoriz
    INC A
    INC A
    XBA
    LDA.W NextLayer1XPos
    REP #$20                                  ; A->16
    LDY.B #!ScrMode_EnableL2Int|!ScrMode_Layer2Vert
    CMP.W #$0000
    BPL +
    LDA.W #$0000
    LDY.B #!ScrMode_Layer2Vert
  + STA.W NextLayer2XPos
    STA.B Layer2XPos
    STY.B ScreenMode
    JMP CODE_05C32B


DATA_05C71B:
    db $20,$00,$C1,$00

DATA_05C71F:
    db $C0,$FF,$40,$00

DATA_05C723:
    db $FF,$FF,$01,$00

CODE_05C727:
    LDX.W OnOffSwitch
    BEQ +
    LDX.B #$02
  + CPX.W Layer2ScrollType
    BEQ CODE_05C74A
    DEC.W Layer2ScrollTimer
    BPL +
    STX.W Layer2ScrollType
  + LDA.W NextLayer2YPos
    EOR.B #$01
    STA.W NextLayer2YPos
    STZ.W Layer2ScrollYSpeed
    STZ.W Layer2ScrollYSpeed+1
    RTS

CODE_05C74A:
    LDA.B #$10
    STA.W Layer2ScrollTimer
    REP #$20                                  ; A->16
    LDA.W NextLayer2YPos
    CMP.W DATA_05C71B,X
    BNE CODE_05C770
    CPX.B #$00
    BNE +
    LDA.W #!SFX_KAPOW
    STA.W SPCIO3                              ; / Play sound effect
    LDA.W #$0020                              ; \ Set ground shake timer
    STA.W ScreenShakeTimer                    ; /
  + LDX.B #$00
    STX.W OnOffSwitch
    BRA CODE_05C784

CODE_05C770:
    LDA.W Layer2ScrollYSpeed
    CMP.W DATA_05C71F,X
    BEQ +
    CLC
    ADC.W DATA_05C723,X
    STA.W Layer2ScrollYSpeed
  + LDX.B #$06
    JSR CODE_05C4F9
CODE_05C784:
    JMP CODE_05C32B

CODE_05C787:
    LDA.B #$02
    STA.B Layer1ScrollDir
    STA.B Layer2ScrollDir
    LDA.W ScrollLayerIndex
    LSR A
    LSR A
    TAX
    LDY.W Layer1ScrollBits,X
    LDX.W ScrollLayerIndex
    REP #$20                                  ; A->16
    LDA.W Layer1ScrollXSpeed,X
    CMP.W DATA_05C001,Y
    BEQ +
    INC A
  + STA.W Layer1ScrollXSpeed,X
    LDA.B LastScreenHoriz
    DEC A
    XBA
    AND.W #$FF00
    CMP.W NextLayer1XPos,X
    BNE +
    STZ.W Layer1ScrollXSpeed,X
  + JSR CODE_05C4F9
    JMP CODE_05C32B

CODE_05C7BC:
    LDA.W BGFastScrollActive
    BEQ CODE_05C7ED
CODE_05C7C1:
    LDA.B #$02
    STA.B Layer2ScrollDir
    REP #$20                                  ; A->16
    LDA.W Layer2ScrollXSpeed
    CMP.W #$0400
    BEQ +
    INC A
  + STA.W Layer2ScrollXSpeed
    LDX.B #$04
    JSR CODE_05C4F9
    LDA.W Layer1DXPos
    AND.W #$00FF
    CMP.W #$0080
    BCC +
    ORA.W #$FF00
  + CLC
    ADC.W NextLayer2XPos
    STA.W NextLayer2XPos
CODE_05C7ED:
    JMP CODE_05C32B


DATA_05C7F0:
    dw $0000,$02F0,$08B0,$0000
    dw $0000,$0370

DATA_05C7FC:
    dw $00D0,$0350,$0A30,$0008
    dw $0040,$0380

DATA_05C808:
    db $00,$06,$08

DATA_05C80B:
    db $03,$01,$02

DATA_05C80E:
    dw $00C0

DATA_05C810:
    dw $0000,$00B0

DATA_05C814:
    dw $FF80,$00C0

DATA_05C818:
if ver_is_ntsc(!_VER)                         ;\==================== J, U, & SS ===============
    dw $FFFF,$0001                            ;!
else                                          ;<===================== E0 & E1 =================
    dw $FFFE,$0002                            ;!
endif                                         ;/===============================================

CODE_05C81C:
    REP #$20                                  ; A->16
    STZ.B _0
    LDY.W Layer2ScrollTimer
    STY.B _0
    LDY.B #$00
    LDX.W Layer1ScrollTimer
    CPX.B #$08
    BCC CODE_05C830
    LDY.B #$02
CODE_05C830:
    LDA.W NextLayer2XPos
    CMP.W DATA_05C7F0,X
    BCC +
    CMP.W DATA_05C7FC,X
    BCS +
    STZ.W Layer1ScrollType
    LDA.W DATA_05C80E,Y
    STA.W NextLayer2YPos
    STZ.W Layer2ScrollYSpeed
    STZ.W Layer2ScrollYPosUpd
  + INX
    INX
    DEC.B _0
    BNE CODE_05C830
    SEP #$20                                  ; A->8
    LDA.W Layer1ScrollType
    ORA.W Layer2Touched
    STA.W Layer1ScrollType
    BEQ CODE_05C87D
    REP #$20                                  ; A->16
    LDA.W NextLayer2YPos
    CMP.W DATA_05C810,Y
    BEQ CODE_05C87D
    LDA.W Layer2ScrollYSpeed
    CMP.W DATA_05C814,Y
    BEQ CODE_05C875
    CLC
    ADC.W DATA_05C818,Y
CODE_05C875:
    STA.W Layer2ScrollYSpeed
    LDX.B #$06
    JSR CODE_05C4F9
CODE_05C87D:
    SEP #$20                                  ; A->8
    RTS


DATA_05C880:
    db $00,$00,$C0,$01,$00,$03,$00,$08
    db $38,$08,$00,$0A,$00,$00,$80,$03
    db $50,$04,$90,$08,$60,$09,$80,$0E
    db $00,$40,$00,$40,$00,$40,$00,$40
    db $00,$40,$00,$00

DATA_05C8A4:
    db $08,$00,$00,$03,$10,$04,$38,$08
    db $70,$08,$00,$0B,$08,$00,$50,$04
    db $A0,$04,$60,$09,$40,$0A,$FF,$0F
    db $00,$50,$00,$50,$00,$50,$00,$50
    db $00,$50,$80,$00

DATA_05C8C8:
    db $C0,$00,$B0,$00,$70,$00,$C0,$00
    db $C0,$00,$C0,$00,$00,$00,$00,$00
    db $C0,$00,$B0,$00,$A0,$00,$70,$00
    db $B0,$00,$B0,$00,$B0,$00,$00,$00
    db $00,$00,$B0,$00,$20,$00,$20,$00
    db $20,$00,$10,$00,$10,$00,$10,$00
    db $00,$00,$00,$00,$10,$00

DATA_05C8FE:
    db $00,$01,$00,$01,$00,$08,$00,$01
    db $00,$01,$00,$08,$00,$00,$00,$00
    db $80,$01,$00,$FF,$00,$FF,$00,$00
    db $00,$FF,$00,$FF,$00,$FF,$00,$FF
    db $00,$FF,$00,$FF,$00,$F8,$00,$F8
    db $00,$F8,$00,$F8,$00,$F8,$00,$F8
    db $00,$00,$00,$00,$40,$FE

DATA_05C934:
if ver_is_ntsc(!_VER)                         ;\================= J, U, & SS ==================
    db $80,$40,$01,$80,$00,$00,$80,$00        ;!
    db $40,$00,$00,$20,$40,$00,$20,$00        ;!
    db $00,$20,$80,$80,$20,$80,$80,$20        ;!
    db $00,$00,$A0                            ;!
else                                          ;<================== E0 & E1 ====================
    db $66,$33,$01,$66,$00,$00,$66,$00        ;!
    db $33,$00,$00,$19,$33,$00,$19,$00        ;!
    db $00,$19,$66,$66,$19,$66,$66,$19        ;!
    db $00,$00,$80                            ;!
endif                                         ;/===============================================

DATA_05C94F:
    db $00,$0C,$18

DATA_05C952:
    db $05,$05,$05

CODE_05C955:
    LDX.W Layer1ScrollBits
    LDY.W Layer2ScrollBits
CODE_05C95B:
    REP #$20                                  ; A->16
CODE_05C95D:
    LDA.W NextLayer2XPos
    CMP.W DATA_05C880,X
    BCC +
    CMP.W DATA_05C8A4,X
    BCS +
    TXA
    LSR A
    AND.W #$00FE
    STA.W Layer1ScrollType
    LDA.W #$00C1
    STA.W NextLayer2YPos
    STZ.W Layer1ScrollTimer
  + INX
    INX
    DEY
    BNE CODE_05C95D
    SEP #$20                                  ; A->8
    LDA.W Layer1ScrollTimer
    BEQ +
    DEC.W Layer1ScrollTimer
    RTS

  + LDA.W Layer1ScrollType
    CLC
    ADC.W Layer2ScrollType
    TAY
    LSR A
    TAX
    REP #$20                                  ; A->16
    LDA.W NextLayer2YPos
    SEC
    SBC.W DATA_05C8C8,Y
    EOR.W DATA_05C8FE,Y
    BPL +
    LDA.W DATA_05C8FE,Y
    JMP CODE_05C875

  + LDA.W DATA_05C8C8,Y
    STA.W NextLayer2YPos
    SEP #$20                                  ; A->8
    LDA.W DATA_05C934,X
    STA.W Layer1ScrollTimer
    LDA.W Layer2ScrollType
    CLC
    ADC.B #$12
    CMP.B #$36
    BCC +
    LDA.B #!SFX_KAPOW
    STA.W SPCIO3                              ; / Play sound effect
    LDA.B #$20                                ; \ Set ground shake timer
    STA.W ScreenShakeTimer                    ; /
    LDA.B #$00
  + STA.W Layer2ScrollType
    RTS


DATA_05C9D1:
    db $01,$01,$01,$00,$01,$01,$01,$00
    db $01,$09

DATA_05C9DB:
    db $01,$00,$02,$00,$04,$03,$05,$00
    db $06,$00

DATA_05C9E5:
    db $00,$01

DATA_05C9E7:
    db $00,$00

DATA_05C9E9:
    db $00,$00,$02,$02,$02,$00,$02,$05
    db $02,$02,$05,$00,$00,$02,$01,$00
    db $03,$02,$03,$04,$03,$01,$00,$01
    db $00,$00,$03,$00,$00,$00,$00

DATA_05CA08:
    db $00,$04,$00,$04

DATA_05CA0C:
    db $00,$00,$00,$01

DATA_05CA10:
    db $00,$01

DATA_05CA12:
    db $40,$01,$E0,$00

DATA_05CA16:
    db $05,$00,$00,$05,$05,$02,$02,$05
DATA_05CA1E:
    db $00,$00,$00,$01,$02,$03,$04,$03
DATA_05CA26:
    db $01,$00,$01,$01,$00,$06,$00,$06
    db $00,$00,$00,$01,$00,$01,$08,$00
    db $00,$08,$00,$00,$00,$01,$01,$00
DATA_05CA3E:
    db $00,$08,$00,$08

DATA_05CA42:
    db $00,$00,$00,$01

DATA_05CA46:
    db $01,$01

DATA_05CA48:
    db $00,$03,$00,$03,$00,$03,$00,$03
    db $00,$03

DATA_05CA52:
    db $00,$00,$00,$01,$00,$02,$00,$03
    db $00,$04

DATA_05CA5C:
    db $01,$00,$00,$00,$00

DATA_05CA61:
    db $01,$18,$1E,$29,$2D,$35,$47

DATA_05CA68:
    db $16,$05,$0A,$03,$07,$11

DATA_05CA6E:
    db $09

DATA_05CA6F:
    db $00,$09,$14,$1C,$24,$28,$33,$3C
    db $43,$4B,$54,$60,$67,$74,$77,$7B
    db $83,$8A,$8D,$90,$99,$A0,$B0,$00
    db $09,$14,$2C,$3C,$B0,$00,$09,$11
    db $1D,$2C,$32,$41,$48,$63,$6B,$70
    db $00,$27,$37,$70,$00,$07,$12,$27
    db $32,$48,$5B,$70,$00,$20,$28,$3A
    db $40,$5F,$66,$6B,$6B,$80,$80,$89
    db $92,$96,$9A,$9E,$A0,$B0,$00,$10
    db $1A,$20,$2B,$30,$3B,$40,$4B

DATA_05CABE:
    db $50

DATA_05CABF:
    db $0C,$0C,$06,$0B,$08,$0C,$03,$02
    db $09,$03,$09,$02,$06,$06,$07,$05
    db $08,$05,$0A,$04,$08,$04,$04,$0C
    db $0C,$07,$07,$05,$05,$0C,$0C,$08
    db $0C,$0C,$07,$07,$0A,$0A,$0C,$0C
    db $00,$00,$0A,$0A,$00,$00,$09,$09
    db $03,$03,$0C,$0C,$0C,$0C,$08,$08
    db $05,$05,$02,$02,$09,$09,$01,$01
    db $01,$02,$03,$07,$08,$08,$0C,$0C
    db $02,$02,$0A,$0A,$02,$02,$0A,$0A
DATA_05CB0F:
    db $07,$07,$07,$07,$07,$07,$07,$07
    db $07,$07,$07,$07,$07,$07,$07,$07
    db $07,$07,$07,$07,$07,$07,$07,$07
    db $07,$07,$07,$07,$07,$07,$07,$07
    db $07,$07,$07,$07,$07,$07,$07,$07
    db $07,$07,$07,$07,$07,$07,$07,$07
    db $07,$07,$07,$07,$08,$08,$08,$08
    db $08,$08,$10,$08,$40,$08,$04,$08
    db $10,$08,$08,$10,$10,$08,$08,$08
    db $08,$08,$08,$08,$08,$08,$08,$08
DATA_05CB5F:
    db $01,$00,$FF,$FF,$01,$00,$FF,$FF
    db $01,$00,$FF,$FF,$01,$00,$FF,$FF
    db $01,$00,$FF,$FF,$01,$00,$FF,$FF
    db $01,$00,$FF,$FF

DATA_05CB7B:
    db $01,$00,$FF,$FF,$01,$00,$FF,$FF
    db $01,$00,$FF,$FF,$01,$00,$FF,$FF
    db $01,$00,$FF,$FF,$01,$00,$FF,$FF
    db $01,$00,$FF,$FF,$04,$00,$FC,$FF
DATA_05CB9B:
    db $01,$00,$FF,$FF,$01,$00,$FF,$FF
DATA_05CBA3:
    db $04,$00,$FC,$FF,$04,$00,$FC,$FF
    db $04,$00,$FC,$FF,$04,$00,$FC,$FF
    db $01,$00,$FF,$FF,$01,$00,$FF,$FF
DATA_05CBBB:
    db $04,$00,$FC,$FF,$04,$00,$FC,$FF
DATA_05CBC3:
    db $01,$00,$FF,$FF

DATA_05CBC7:
    db $30

DATA_05CBC8:
    db $70,$80,$10,$28,$30,$30,$30,$30
    db $14,$02,$30,$30,$30,$30,$70,$80
    db $70,$80,$70,$80,$70,$80,$70,$80
    db $70,$80,$18

DATA_05CBE3:
    db $18,$18

DATA_05CBE5:
    db $18,$18,$08,$20,$06,$06

DATA_05CBEB:
    db $04,$04

DATA_05CBED:
    db $60

DATA_05CBEE:
    db $42,$D0,$B2

DATA_05CBF1:
    db $80,$80,$80,$80

if ver_is_lores(!_VER)                        ;\================= J, U, SS, & E0 ==============
DATA_05CBF5:                                  ;!
    db $90                                    ;!
DATA_05CBF6:                                  ;!
    db $72,$60,$42,$20,$10,$40,$22,$20        ;!
    db $10                                    ;!
else                                          ;<======================= E1 ====================
DATA_05CBF5:                                  ;!
    db $90                                    ;!
DATA_05CBF6:                                  ;!
    db $72,$60,$42,$22,$02,$40,$22,$20        ;!
    db $10                                    ;!
endif                                         ;/===============================================

CODE_05CBFF:
    PHB
    PHK                                       ; Wrapper
    PLB
    JSR CODE_05CC07
    PLB
    RTL

CODE_05CC07:
    LDA.W OverworldProcess
    JSL ExecutePtr

    dw CODE_05CC66
    dw CODE_05CD76
    dw CODE_05CECA
    dw Return05CFE9

DATA_05CC16:
    db $51,$0D,$00,$09,$30,$28,$31,$28
    db $32,$28,$33,$28,$34,$28,$51,$49
    db $00,$19,$0C,$38,$18,$38,$1E,$38
    db $1B,$38,$1C,$38,$0E,$38,$FC,$38
    db $0C,$38,$15,$38,$0E,$38,$0A,$38
    db $1B,$38,$28,$38,$51,$A9,$00,$19
    db $76,$38,$FC,$38,$FC,$38,$FC,$38
    db $26,$38,$05,$38,$00,$38,$77,$38
    db $FC,$38,$FC,$38,$FC,$38,$FC,$38
    db $FC,$38,$FF

DATA_05CC61:
    db $40,$41,$42,$43,$44

CODE_05CC66:
    LDY.B #$00
    LDX.W PlayerTurnLvl
    LDA.W PlayerBonusStars,X
CODE_05CC6E:
    CMP.B #$0A
    BCC CODE_05CC77
    SBC.B #$0A
    INY
    BRA CODE_05CC6E

CODE_05CC77:
    CPY.W InGameTimerTens
    BNE +
    CPY.W InGameTimerOnes
    BNE +
    INC.W GivePlayerLives
  + LDA.B #$01
    STA.W Layer3ScrollType
    LDA.B #$08
    TSB.B MainBGMode
    REP #$30                                  ; AXY->16
    STZ.B Layer3XPos
    STZ.B Layer3YPos
    LDY.W #$004A
    TYA
    CLC
    ADC.L DynStripeImgSize
    TAX
  - LDA.W DATA_05CC16,Y
    STA.L DynamicStripeImage,X
    DEX
    DEX
    DEY
    DEY
    BPL -
    LDA.L DynStripeImgSize
    TAX
    SEP #$20                                  ; A->8
    LDA.W PlayerTurnLvl
    BEQ CODE_05CCC8
    LDY.W #$0000
  - LDA.W DATA_05CC61,Y
    STA.L DynamicStripeImage+4,X
    INX
    INX
    INY
    CPY.W #$0005
    BNE -
CODE_05CCC8:
    LDY.W #$0002
    LDA.B #$04
    CLC
    ADC.L DynStripeImgSize
    TAX
  - LDA.W InGameTimerHundreds,Y
    STA.L DynamicStripeImage+$32,X
    DEY
    DEX
    DEX
    BPL -
    LDA.L DynStripeImgSize
    TAX
CODE_05CCE4:
    LDA.L DynamicStripeImage+$32,X
    AND.B #$0F
    BNE CODE_05CCF9
    LDA.B #$FC
    STA.L DynamicStripeImage+$32,X
    INX
    INX
    CPX.W #$0004
    BNE CODE_05CCE4
CODE_05CCF9:
    SEP #$10                                  ; XY->8
    JSR CODE_05CE4C
    REP #$20                                  ; A->16
    STZ.B _0
    LDA.B _2
    STA.W ScoreIncrement
    LDX.B #$42
    LDY.B #$00
    JSR CODE_05CDFD
    LDX.B #$00
CODE_05CD10:
    LDA.L DynamicStripeImage+$40,X
    AND.W #$000F
    BNE CODE_05CD26
    LDA.W #$38FC
    STA.L DynamicStripeImage+$40,X
    INX
    INX
    CPX.B #$08
    BNE CODE_05CD10
CODE_05CD26:
    SEP #$20                                  ; A->8
    INC.W OverworldProcess
    LDA.B #$28
    STA.W DisplayBonusStars
    LDA.B #$4A
    CLC
    ADC.L DynStripeImgSize
    INC A
    STA.L DynStripeImgSize
    SEP #$30                                  ; AXY->8
    RTS


DATA_05CD3F:
    db $52,$0A,$00,$15,$0B,$38,$18,$38
    db $17,$38,$1E,$38,$1C,$38,$28,$38
    db $FC,$38,$64,$28,$26,$38,$FC,$38
    db $FC,$38,$51,$F3,$00,$03,$FC,$38
    db $FC,$38,$FF

DATA_05CD62:
    db $B7

DATA_05CD63:
    db $C3,$B8,$B9,$BA,$BB,$BA,$BF,$BC
    db $BD,$BE,$BF,$C0,$C3,$C1,$B9,$C2
    db $C4,$B7,$C5

CODE_05CD76:
    LDA.W BonusStarsGained
    BEQ CODE_05CDD5
    DEC.W DisplayBonusStars
    BPL Return05CDE8
    LDY.B #$22
    TYA
    CLC
    ADC.L DynStripeImgSize
    TAX
  - LDA.W DATA_05CD3F,Y
    STA.L DynamicStripeImage,X
    DEX
    DEY
    BPL -
    LDA.L DynStripeImgSize
    TAX
    LDA.W BonusStarsGained
    AND.B #$0F
    ASL A
    TAY
    LDA.W DATA_05CD63,Y
    STA.L DynamicStripeImage+$18,X
    LDA.W DATA_05CD62,Y
    STA.L DynamicStripeImage+$20,X
    LDA.W BonusStarsGained
    AND.B #$F0
    LSR A
    LSR A
    LSR A
    LSR A
    BEQ +
    ASL A
    TAY
    LDA.W DATA_05CD63,Y
    STA.L DynamicStripeImage+$16,X
    LDA.W DATA_05CD62,Y
    STA.L DynamicStripeImage+$1E,X
  + LDA.B #$22
    CLC
    ADC.L DynStripeImgSize
    INC A
    STA.L DynStripeImgSize
CODE_05CDD5:
    DEC.W DrumrollTimer
    BPL Return05CDE8
    LDA.W BonusStarsGained
    STA.W DisplayBonusStars
    INC.W OverworldProcess
    LDA.B #!SFX_DRUMROLLSTART
    STA.W SPCIO3                              ; / Play sound effect
Return05CDE8:
    RTS


DATA_05CDE9:
    db $00,$00

DATA_05CDEB:
    db $10,$27,$00,$00,$E8,$03,$00,$00
    db $64,$00,$00,$00,$0A,$00,$00,$00
    db $01,$00

CODE_05CDFD:
    LDA.L DynStripeImgSize,X
    AND.W #$FF00
    STA.L DynStripeImgSize,X
CODE_05CE08:
    PHX
    TYX
    LDA.B _2
    SEC
    %LorW_X(SBC,DATA_05CDEB)
    STA.B _6
    LDA.B _0
    %LorW_X(SBC,DATA_05CDE9)
    STA.B _4
    PLX
    BCC CODE_05CE2F
    LDA.B _6
    STA.B _2
    LDA.B _4
    STA.B _0
    LDA.L DynStripeImgSize,X
    INC A
    STA.L DynStripeImgSize,X
    BRA CODE_05CE08

CODE_05CE2F:
    INX
    INX
    INY
    INY
    INY
    INY
    CPY.B #$14
    BNE CODE_05CDFD
    RTS


DATA_05CE3A:
    db $00,$00,$64,$00,$C8,$00,$2C,$01
DATA_05CE42:
    db $00,$0A,$14,$1E,$28,$32,$3C,$46
    db $50,$5A

CODE_05CE4C:
    REP #$20                                  ; A->16
    LDA.W InGameTimerHundreds
    ASL A
    TAX
    LDA.W DATA_05CE3A,X
    STA.B _0
    LDA.W InGameTimerTens
    TAX
    LDA.W DATA_05CE42,X
    AND.W #$00FF
    CLC
    ADC.B _0
    STA.B _0
    LDA.W InGameTimerOnes
    AND.W #$00FF
    CLC
    ADC.B _0
    STA.B _0
    SEP #$20                                  ; A->8
    LDA.B _0
    STA.W HW_WRMPYA
    LDA.B #$32
    STA.W HW_WRMPYB
    NOP
    NOP
    NOP
    NOP
    LDA.W HW_RDMPY
    STA.B _2
    LDA.W HW_RDMPY+1
    STA.B _3
    LDA.B _1
    STA.W HW_WRMPYA
    LDA.B #$32
    STA.W HW_WRMPYB
    NOP
    NOP
    NOP
    NOP
    LDA.W HW_RDMPY
    CLC
    ADC.B _3
    STA.B _3
    RTS


DATA_05CEA3:
    db $51,$B1,$00,$09,$FC,$38,$FC,$38
    db $FC,$38,$FC,$38,$00,$38,$51,$F3
    db $00,$03,$FC,$38,$FC,$38,$52,$13
    db $00,$03,$FC,$38,$FC,$38,$FF

DATA_05CEC2:
    db $0A,$00,$64,$00

DATA_05CEC6:
    db $01,$00,$0A,$00

CODE_05CECA:
    PHB
    PHK
    PLB
    REP #$20                                  ; A->16
    LDX.B #$00
    LDA.W PlayerTurnLvl
    AND.W #$00FF
    BEQ +
    LDX.B #$03
  + LDY.B #$02
    LDA.W ScoreIncrement
    BEQ CODE_05CF05
    CMP.W #$0063
    BCS +
    LDY.B #$00
  + SEC
    SBC.W DATA_05CEC2,Y
    STA.W ScoreIncrement
    STA.B _2
    LDA.W DATA_05CEC6,Y
    CLC
    ADC.W PlayerScore,X
    STA.W PlayerScore,X
    LDA.W PlayerScore+2,X
    ADC.W #$0000
    STA.W PlayerScore+2,X
CODE_05CF05:
    LDX.W BonusStarsGained
    BEQ CODE_05CF36
    SEP #$20                                  ; A->8
    LDA.B TrueFrame
    AND.B #$03
    BNE +
    LDX.W PlayerTurnLvl
    LDA.W PlayerBonusStars,X
    CLC
    ADC.B #$01
    STA.W PlayerBonusStars,X
    LDA.W BonusStarsGained
    DEC A
    STA.W BonusStarsGained
    AND.B #$0F
    CMP.B #$0F
    BNE +
    LDA.W BonusStarsGained
    SEC
    SBC.B #$06
    STA.W BonusStarsGained
  + REP #$20                                  ; A->16
CODE_05CF36:
    LDA.W ScoreIncrement
    BNE +
    LDX.W BonusStarsGained
    BNE +
    LDX.B #$30
    STX.W DrumrollTimer
    INC.W OverworldProcess
    LDX.B #!SFX_DRUMROLLEND
    STX.W SPCIO3                              ; / Play sound effect
  + LDY.B #$1E
    TYA
    CLC
    ADC.L DynStripeImgSize
    TAX
    INC A
    STA.B _A
  - LDA.W DATA_05CEA3,Y
    STA.L DynamicStripeImage,X
    DEX
    DEX
    DEY
    DEY
    BPL -
    LDA.W ScoreIncrement
    BEQ CODE_05CFA0
    STZ.B _0
    LDA.L DynStripeImgSize
    CLC
    ADC.W #$0006
    TAX
    LDY.B #$00
    JSR CODE_05CDFD
    LDA.L DynStripeImgSize
    CLC
    ADC.W #$0008
    STA.B _0
    LDA.L DynStripeImgSize
    TAX
CODE_05CF8A:
    LDA.L DynamicStripeImage+4,X
    AND.W #$000F
    BNE CODE_05CFA0
    LDA.W #$38FC
    STA.L DynamicStripeImage+4,X
    INX
    INX
    CPX.B _0
    BNE CODE_05CF8A
CODE_05CFA0:
    SEP #$20                                  ; A->8
    REP #$10                                  ; XY->16
    LDA.W DisplayBonusStars
    BEQ +
    LDA.L DynStripeImgSize
    TAX
    LDA.W BonusStarsGained
    AND.B #$0F
    ASL A
    TAY
    LDA.W DATA_05CD62,Y
    STA.L DynamicStripeImage+$14,X
    LDA.W DATA_05CD63,Y
    STA.L DynamicStripeImage+$1C,X
    LDA.W BonusStarsGained
    AND.B #$F0
    LSR A
    LSR A
    LSR A
    BEQ +
    TAY
    LDA.W DATA_05CD62,Y
    STA.L DynamicStripeImage+$12,X
    LDA.W DATA_05CD63,Y
    STA.L DynamicStripeImage+$1A,X
  + REP #$20                                  ; A->16
    SEP #$10                                  ; XY->8
    LDA.B _A
    STA.L DynStripeImgSize
    SEP #$30                                  ; AXY->8
    PLB
Return05CFE9:
    RTS

    %insert_empty($114,$16,$16,$16,$16)

OWL1CharData:
    db $22,$01
    db $22,$01,$22,$01,$22,$01,$D8,$01
    db $D9,$C1,$D9,$01,$D8,$C1,$22,$01
    db $DF,$01,$22,$01,$DF,$01,$EE,$C1
    db $DE,$C1,$ED,$C1,$DD,$C1,$DA,$01
    db $DA,$C1,$DA,$01,$DA,$C1,$DD,$01
    db $ED,$01,$DE,$01,$EE,$01,$DF,$01
    db $22,$01,$DF,$01,$22,$01,$22,$01
    db $D8,$01,$22,$01,$D9,$01,$22,$01
    db $EB,$01,$EB,$01,$EB,$C1,$EB,$C1
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$EB,$01,$EC,$C1
    db $DC,$C1,$DC,$01,$EC,$01,$DB,$01
    db $DB,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$EC,$C1,$DC,$C1,$DC,$01
    db $EC,$01,$22,$01,$22,$01,$D6,$01
    db $E6,$01,$D7,$01,$E7,$01,$EA,$01
    db $EA,$01,$EA,$C1,$EA,$C1,$D9,$C1
    db $22,$01,$D8,$C1,$22,$01,$E7,$C1
    db $D7,$C1,$E6,$C1,$D6,$C1,$22,$01
    db $22,$01,$DB,$01,$DB,$01,$D9,$41
    db $D8,$81,$D8,$41,$D9,$81,$ED,$81
    db $DD,$81,$EE,$81,$DE,$81,$DE,$41
    db $EE,$41,$DD,$41,$ED,$41,$22,$01
    db $D9,$41,$22,$01,$D8,$41,$EB,$41
    db $EB,$81,$22,$01,$EB,$41,$22,$01
    db $22,$01,$EB,$81,$22,$01,$22,$01
    db $EB,$41,$22,$01,$22,$01,$DC,$41
    db $EC,$41,$EC,$81,$DC,$81,$EC,$81
    db $DC,$81,$22,$01,$22,$01,$22,$01
    db $22,$01,$DC,$41,$EC,$41,$D7,$41
    db $E7,$41,$D6,$41,$E6,$41,$D8,$81
    db $22,$01,$D9,$81,$22,$01,$E6,$81
    db $D6,$81,$E7,$81,$D7,$81,$EB,$81
    db $22,$01,$EB,$41,$EB,$81,$EB,$01
    db $EB,$C1,$EB,$C1,$22,$01,$A8,$11
    db $B8,$11,$A9,$11,$B9,$11,$A6,$11
    db $B6,$11,$A7,$11,$B7,$11,$A6,$11
    db $B6,$11,$A7,$11,$B7,$11,$20,$68
    db $20,$68,$20,$28,$20,$28,$20,$28
    db $20,$28,$22,$09,$22,$09,$22,$01
    db $22,$01,$EC,$C1,$DC,$C1,$DC,$01
    db $EC,$01,$22,$01,$22,$01,$EA,$01
    db $EA,$01,$EA,$C1,$EA,$C1,$EE,$C1
    db $DE,$C1,$ED,$C1,$DD,$C1,$DD,$01
    db $ED,$01,$DE,$01,$EE,$01,$EB,$C1
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$EB,$01,$EC,$C1
    db $DC,$C1,$DC,$01,$EC,$01,$DB,$01
    db $DB,$01,$22,$01,$22,$01,$D6,$01
    db $E6,$01,$D7,$01,$E7,$01,$ED,$81
    db $DD,$81,$EE,$81,$DE,$81,$DF,$01
    db $22,$01,$DF,$01,$22,$01,$D7,$41
    db $E7,$41,$D6,$41,$E6,$41,$22,$01
    db $EB,$41,$22,$01,$22,$01,$EC,$81
    db $DC,$81,$22,$01,$22,$01,$22,$01
    db $22,$01,$EB,$81,$22,$01,$D9,$41
    db $D8,$81,$D8,$41,$D9,$81,$EB,$C1
    db $EB,$C1,$EB,$C1,$22,$01,$22,$01
    db $22,$01,$DB,$01,$DB,$01,$E7,$C1
    db $D7,$C1,$E6,$C1,$D6,$C1,$22,$01
    db $DF,$01,$22,$01,$DF,$01,$E6,$81
    db $D6,$81,$E7,$81,$D7,$81,$D8,$01
    db $D9,$C1,$D9,$01,$D8,$C1,$EA,$01
    db $EA,$01,$EA,$C1,$EA,$C1,$EA,$01
    db $EA,$01,$EA,$C1,$EA,$C1,$D6,$01
    db $E6,$01,$D7,$01,$E7,$01,$DA,$01
    db $DA,$C1,$DA,$01,$DA,$C1,$A4,$11
    db $B4,$11,$A5,$11,$B5,$11,$22,$11
    db $90,$11,$22,$11,$91,$11,$C2,$11
    db $D2,$11,$C3,$11,$D3,$11,$23,$38
    db $71,$38,$23,$38,$71,$38,$23,$28
    db $71,$28,$23,$28,$71,$28,$23,$30
    db $71,$30,$23,$30,$71,$30,$22,$01
    db $22,$01,$22,$01,$EB,$01,$22,$01
    db $EB,$41,$22,$01,$22,$01,$22,$01
    db $22,$01,$EB,$81,$22,$01,$22,$15
    db $AC,$15,$22,$15,$AD,$15,$EA,$01
    db $EA,$01,$EA,$C1,$EA,$C1,$DA,$01
    db $DA,$C1,$DA,$01,$DA,$C1,$DA,$01
    db $DA,$C1,$DA,$01,$DA,$C1,$E7,$C1
    db $D7,$C1,$E6,$C1,$D6,$C1,$EB,$C1
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$C9,$05
    db $C8,$05,$C9,$05,$C8,$05,$84,$11
    db $94,$11,$85,$11,$95,$11,$22,$01
    db $22,$01,$22,$01,$22,$01,$88,$15
    db $98,$15,$89,$15,$99,$15,$22,$01
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$8C,$15
    db $9C,$15,$8D,$15,$9D,$15,$9E,$10
    db $64,$10,$9F,$10,$65,$10,$BC,$15
    db $AE,$15,$BD,$15,$AF,$15,$82,$19
    db $92,$19,$83,$19,$93,$19,$C8,$19
    db $F8,$19,$C9,$19,$F9,$19,$AA,$11
    db $BA,$11,$AA,$51,$BA,$51,$56,$19
    db $EA,$09,$56,$59,$EA,$C9,$A0,$11
    db $B0,$11,$A1,$11,$B1,$11,$A2,$11
    db $B2,$11,$A3,$11,$B3,$11,$CC,$15
    db $CE,$15,$CD,$15,$CF,$15,$22,$01
    db $22,$01,$22,$01,$22,$01,$86,$99
    db $86,$19,$86,$D9,$86,$59,$96,$99
    db $96,$19,$96,$D9,$96,$59,$86,$9D
    db $86,$1D,$86,$DD,$86,$5D,$96,$9D
    db $96,$1D,$96,$DD,$96,$5D,$86,$99
    db $86,$19,$86,$D9,$86,$59,$96,$99
    db $96,$19,$96,$D9,$96,$59,$86,$9D
    db $86,$1D,$86,$DD,$86,$5D,$96,$9D
    db $96,$1D,$96,$DD,$96,$5D,$22,$01
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$80,$1C
    db $90,$1C,$81,$1C,$90,$5C,$22,$01
    db $22,$01,$22,$01,$22,$01,$80,$14
    db $90,$14,$81,$14,$90,$54,$22,$01
    db $22,$01,$22,$01,$22,$01,$22,$01
    db $22,$01,$22,$01,$22,$01,$82,$1D
    db $92,$1D,$83,$1D,$93,$1D,$22,$01
    db $22,$01,$22,$01,$22,$01,$86,$99
    db $86,$19,$86,$D9,$86,$59,$22,$01
    db $22,$01,$22,$01,$22,$01,$86,$99
    db $86,$19,$86,$D9,$86,$59,$8A,$15
    db $9A,$15,$8B,$15,$9B,$15,$8C,$15
    db $9C,$15,$8D,$15,$9D,$15,$C0,$11
    db $D0,$11,$C1,$11,$D1,$11,$22,$11
    db $22,$11,$22,$11,$22,$11,$22,$1D
    db $82,$1C,$22,$1D,$83,$1C,$22,$1D
    db $82,$14,$22,$1D,$83,$14,$80,$19
    db $90,$19,$81,$19,$91,$19,$8E,$19
    db $9E,$19,$8F,$19,$9F,$19,$A0,$19
    db $B0,$19,$A1,$19,$B1,$19,$A4,$19
    db $B4,$19,$A5,$19,$B5,$19,$A8,$19
    db $B8,$19,$A9,$19,$B9,$19,$BE,$19
    db $CE,$19,$BF,$19,$CF,$19,$C4,$19
    db $D4,$19,$C5,$19,$D5,$19,$22,$09
    db $C6,$0D,$22,$09,$C7,$0D,$22,$09
    db $FC,$0D,$FE,$0D,$FD,$0D,$CC,$0D
    db $E4,$0D,$CD,$0D,$E5,$0D,$E0,$0D
    db $F0,$0D,$E1,$0D,$F1,$0D,$F4,$0D
    db $22,$09,$F5,$0D,$22,$09,$E8,$0D
    db $22,$09,$22,$09,$22,$09,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$75,$3C
    db $75,$3C,$75,$3C,$75,$3C,$22,$09
    db $79,$14,$22,$09,$9D,$14,$22,$09
    db $78,$54,$22,$09,$22,$09,$22,$09
    db $22,$09,$22,$09,$79,$14,$22,$09
    db $9D,$14,$78,$14,$9D,$14,$9D,$14
    db $78,$54,$79,$54,$22,$09,$79,$14
    db $22,$09,$22,$09,$22,$09,$22,$09
    db $22,$09,$78,$54,$22,$09,$22,$09
    db $22,$09,$78,$14,$22,$09,$9D,$14
    db $22,$09,$79,$54,$22,$09,$22,$09
    db $9D,$14,$22,$09,$78,$54,$22,$09
    db $78,$14,$22,$09,$22,$09,$22,$09
    db $22,$09,$22,$09,$79,$54,$78,$14
    db $9D,$14,$9D,$14,$9D,$14,$56,$10
    db $9E,$10,$57,$10,$9F,$10,$9E,$10
    db $9E,$10,$9F,$10,$9F,$10,$22,$15
    db $AC,$15,$22,$15,$AD,$15,$22,$09
    db $22,$09,$22,$09,$48,$19,$22,$09
    db $39,$19,$22,$09,$22,$09,$22,$09
    db $22,$09,$37,$15,$47,$15,$38,$15
    db $48,$19,$58,$19,$49,$19,$49,$59
    db $59,$59,$48,$59,$58,$59,$37,$55
    db $47,$55,$22,$09,$22,$09,$22,$09
    db $22,$09,$57,$15,$5A,$1D,$58,$19
    db $5B,$19,$59,$19,$59,$19,$60,$19
    db $70,$19,$60,$59,$70,$59,$3A,$19
    db $4A,$19,$3B,$19,$4B,$11,$48,$19
    db $58,$19,$48,$59,$58,$59,$22,$09
    db $22,$09,$7A,$1D,$22,$09,$7B,$1D
    db $22,$09,$7B,$1D,$22,$09,$7B,$1D
    db $22,$09,$7A,$5D,$22,$09,$CA,$19
    db $FA,$19,$CB,$19,$FB,$19,$7E,$18
    db $22,$09,$22,$09,$22,$09,$7F,$10
    db $22,$09,$22,$09,$22,$09,$7F,$10
    db $22,$09,$22,$09,$7E,$18,$7E,$18
    db $22,$09,$22,$09,$7F,$10,$22,$09
    db $22,$09,$22,$09,$7E,$18,$22,$09
    db $22,$09,$22,$09,$7F,$10,$3F,$10
    db $3F,$10,$3F,$10,$3F,$10,$6F,$51
    db $7F,$51,$6E,$51,$7E,$51,$F3,$51
    db $FF,$51,$87,$51,$97,$51,$08,$00
    db $09,$00,$0A,$00,$0B,$00,$00,$00
    db $00,$00,$00,$00,$00,$00

DATA_05D608:
    db $FF,$1F,$20,$FF,$0B,$0D,$0E,$0F
    db $28,$09,$10,$21,$22,$23,$24,$25
    db $27,$60,$FF,$12,$02,$07,$FF,$FF
    db $4E,$FF,$4D,$4A,$4C,$4B,$36,$35
    db $61,$63,$62,$48,$46,$06,$05,$04
    db $00,$01,$03,$19,$FF,$1D,$1A,$14
    db $44,$45,$42,$3E,$40,$41,$43,$3D
    db $3B,$39,$38,$4F,$17,$1B,$15,$29
    db $1C,$30,$2A,$32,$2C,$37,$34,$2E
    db $6D,$6C,$6B,$6A,$69,$64,$65,$66
    db $67,$68,$56,$53,$54,$5F,$57,$59
    db $51,$5A,$5D,$50,$5C

    %insert_empty($A3,$A3,$A3,$A3,$A3)

DATA_05D708:
    db $00,$60,$C0,$00

DATA_05D70C:
    db $60,$90,$C0,$00

DATA_05D710:
    db $03,$01,$01,$00,$00,$02,$02,$01
    db $00,$00,$00,$00,$00,$00,$00,$00
DATA_05D720:
    db $02,$02,$01,$00,$01,$02,$01,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
DATA_05D730:
    db $00,$30,$60,$80,$A0,$B0,$C0,$E0
    db $10,$30,$50,$60,$70,$90,$00,$00
DATA_05D740:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $01,$01,$01,$01,$01,$01,$01,$01
DATA_05D750:
    db $10,$80,$00,$E0,$10,$70,$00,$E0
DATA_05D758:
    db $00,$00,$00,$00,$01,$01,$01,$01
DATA_05D760:
    db $05,$01,$02,$06,$08,$01

PtrsLong05D766:
    dl GhostHouseEntrance
    dl CastleEntrance1
    dl NoYoshiEntrance1
    dl NoYoshiEntrance2
    dl NoYoshiEntrance3
    dl CastleEntrance2

PtrsLong05D778:
    dl EmptyLevel
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CE684 : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CE8EE : db $FF

DATA_05D78A:
    db $03,$00,$00,$00,$00,$00

DATA_05D790:
    db $70,$70,$60,$70,$70,$70

CODE_05D796:
    PHB
    PHK
    PLB
    SEP #$30                                  ; AXY->8
    STZ.W SkipMidwayCastleIntro
    LDA.W YoshiHeavenFlag
    BNE CODE_05D7A8
    LDY.W BonusGameActivate
    BEQ +
CODE_05D7A8:
    JSR CODE_05DBAC
  + LDA.W SublevelCount
    BNE +
    JMP CODE_05D83E

  + LDX.B PlayerXPosNext+1
    LDA.B ScreenMode
    AND.B #!ScrMode_Layer1Vert
    BEQ +
    LDX.B PlayerYPosNext+1
  + LDA.W ExitTableLow,X
    STA.W LoadingLevelNumber
    STA.B _E
    LDA.W PlayerTurnOW
    LSR A
    LSR A
    TAY
    LDA.W OWPlayerSubmap,Y
    BEQ +
    LDA.B #$01
  + STA.B _F
    LDA.W UseSecondaryExit
    BEQ +
    REP #$30                                  ; AXY->16
    LDA.W #$0000
    SEP #$20                                  ; A->8
    LDY.B _E
    LDA.W DATA_05F800,Y
    STA.B _E
    STA.W LoadingLevelNumber
    LDA.W DATA_05FA00,Y
    STA.B _0
    AND.B #$0F
    TAX
    LDA.L DATA_05D730,X
    STA.B PlayerYPosNext
    LDA.L DATA_05D740,X
    STA.B PlayerYPosNext+1
    LDA.B _0
    AND.B #$30
    LSR A
    LSR A
    LSR A
    LSR A
    TAX
    LDA.L DATA_05D708,X
    STA.B Layer1YPos
    LDA.B _0
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    TAX
    LDA.L DATA_05D70C,X
    STA.B Layer2YPos
    LDA.W DATA_05FC00,Y
    STA.B _1
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    TAX
    LDA.L DATA_05D750,X
    STA.B PlayerXPosNext
    LDA.L DATA_05D758,X
    STA.B PlayerXPosNext+1
    LDA.W DATA_05FE00,Y
    AND.B #$07
    STA.W LevelEntranceType
  + JMP CODE_05D8B7

CODE_05D83E:
    STZ.B _F
    LDY.B #$00
    LDA.W OverworldOverride
    BNE CODE_05D8A2
    REP #$30                                  ; AXY->16
    STZ.B Layer1XPos                          ; Set "X position of screen boundary" to 0
    STZ.B Layer2XPos                          ; Set "Layer 2 X position" to 0
    LDX.W PlayerTurnOW
    LDA.W OWPlayerXPosPtr,X
    AND.W #$000F
    STA.B _0
    LDA.W OWPlayerYPosPtr,X
    AND.W #$000F
    ASL A
    ASL A
    ASL A
    ASL A
    STA.B _2
    LDA.W OWPlayerXPosPtr,X
    AND.W #$0010
    ASL A
    ASL A
    ASL A
    ASL A
    ORA.B _0
    STA.B _0
    LDA.W OWPlayerYPosPtr,X
    AND.W #$0010
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    ORA.B _2
    ORA.B _0
    TAX
    LDA.W PlayerTurnOW                        ; \
    AND.W #$00FF                              ; |
    LSR A                                     ; |Set Y to current player
    LSR A                                     ; |
    TAY                                       ; /
    LDA.W OWPlayerSubmap,Y                    ; \ Get current player's submap
    AND.W #$000F                              ; /
    BEQ +                                     ; \
    TXA                                       ; |
    CLC                                       ; |If on submap, increase X by x400
    ADC.W #$0400                              ; |
    TAX                                       ; |
  + SEP #$20                                  ; A->8
    LDA.L OWLayer1Translevel,X
    STA.W TranslevelNo                        ; Store overworld level number
CODE_05D8A2:
    CMP.B #$25                                ; \
    BCC +                                     ; |
    SEC                                       ; |If A>= x25,
    SBC.B #$24                                ; |subtract x24
  + STA.W LoadingLevelNumber
    STA.B _E                                  ; Store A as lower level number byte
    LDA.W OWPlayerSubmap,Y                    ; \
    BEQ +                                     ; |Set higher level number byte to:
    LDA.B #$01                                ; |0 if on overworld
  + STA.B _F                                  ; /
CODE_05D8B7:
    REP #$30                                  ; AXY->16
    LDA.B _E                                  ; \
    ASL A                                     ; |
    CLC                                       ; |Multiply level number by 3 and store in Y
    ADC.B _E                                  ; |(Each L1/2 pointer table entry is 3 bytes long)
    TAY                                       ; /
    SEP #$20                                  ; A->8
    LDA.W Layer1Ptrs,Y                        ; \
    STA.B Layer1DataPtr                       ; |
    LDA.W Layer1Ptrs+1,Y                      ; |Load Layer 1 pointer into $65-$67
    STA.B Layer1DataPtr+1                     ; |
    LDA.W Layer1Ptrs+2,Y                      ; |
    STA.B Layer1DataPtr+2                     ; /
    LDA.W Layer2Ptrs,Y                        ; \
    STA.B Layer2DataPtr                       ; |
    LDA.W Layer2Ptrs+1,Y                      ; |Load Layer 2 pointer into $68-$6A
    STA.B Layer2DataPtr+1                     ; |
    LDA.W Layer2Ptrs+2,Y                      ; |
    STA.B Layer2DataPtr+2                     ; /
    REP #$20                                  ; A->16
    LDA.B _E                                  ; \
    ASL A                                     ; |Multiply level number by 2 and store in Y
    TAY                                       ; / (Each sprite pointer table entry is 2 bytes long)
    LDA.W #$0000
    SEP #$20                                  ; A->8
    LDA.W Ptrs05EC00,Y                        ; \
    STA.B SpriteDataPtr                       ; |Store location of sprite level Y in $CE-$CF
    LDA.W Ptrs05EC00+1,Y                      ; |
    STA.B SpriteDataPtr+1                     ; /
    LDA.B #$07                                ; \ Set highest byte to x07
    STA.B SpriteDataPtr+2                     ; / (All sprite data is stored in bank 07)
    LDA.B [SpriteDataPtr]                     ; \ Get first byte of sprite data (header)
    AND.B #$3F                                ; |Get level's sprite memory
    STA.W SpriteMemorySetting                 ; / Store in $1692
    LDA.B [SpriteDataPtr]                     ; \ Get first byte of sprite data (header) again
    AND.B #$C0                                ; |Get level's sprite buoyancy settings
    STA.W SpriteBuoyancy                      ; / Store in $190E
    REP #$10                                  ; XY->16
    SEP #$20                                  ; A->8
    LDY.B _E
    LDA.W DATA_05F000,Y
    LSR A
    LSR A
    LSR A
    LSR A
    TAX
    LDA.L DATA_05D720,X
    STA.W HorizLayer2Setting
    LDA.L DATA_05D710,X
    STA.W VertLayer2Setting
    LDA.B #$01
    STA.W HorizLayer1Setting
    LDA.W DATA_05F200,Y
    AND.B #$C0
    CLC
    ASL A
    ROL A
    ROL A
    STA.W Layer3Setting
    STZ.B Layer1YPos+1
    STZ.B Layer2YPos+1
    LDA.W DATA_05F600,Y
    AND.B #$80
    STA.W DisableNoYoshiIntro
    LDA.W DATA_05F600,Y
    AND.B #$60
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B ScreenMode
    LDA.W UseSecondaryExit
    BNE +
    LDA.W DATA_05F000,Y
    AND.B #$0F
    TAX
    LDA.L DATA_05D730,X
    STA.B PlayerYPosNext
    LDA.L DATA_05D740,X
    STA.B PlayerYPosNext+1
    LDA.W DATA_05F200,Y
    STA.B _2
    AND.B #$07
    TAX
    LDA.L DATA_05D750,X
    STA.B PlayerXPosNext
    LDA.L DATA_05D758,X
    STA.B PlayerXPosNext+1
    LDA.B _2
    AND.B #$38
    LSR A
    LSR A
    LSR A
    STA.W LevelEntranceType
    LDA.W DATA_05F400,Y
    STA.B _2
    AND.B #$03
    TAX
    LDA.L DATA_05D70C,X
    STA.B Layer2YPos
    LDA.B _2
    AND.B #$0C
    LSR A
    LSR A
    TAX
    LDA.L DATA_05D708,X
    STA.B Layer1YPos
    LDA.W DATA_05F600,Y
    STA.B _1
  + LDA.B ScreenMode
    AND.B #!ScrMode_Layer1Vert
    BEQ +
    LDY.W #$0000
    LDA.B [Layer1DataPtr],Y
    AND.B #$1F
    STA.B PlayerYPosNext+1
    INC A
    STA.B LastScreenVert
    LDA.B #$01
    STA.W VertLayer1Setting
  + LDA.W SublevelCount
    BNE +
    LDA.B _2
    LSR A
    LSR A
    LSR A
    LSR A
    STA.W DisableMidway
    STZ.W MidwayFlag
    LDY.W TranslevelNo
    LDA.W DATA_05D608,Y
    STA.W OverworldEvent
    SEP #$10                                  ; XY->8
    LDX.W TranslevelNo
    LDA.W OWLevelTileSettings,X
    AND.B #$40
    BEQ +
    STA.W SkipMidwayCastleIntro
    LDA.B _2
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B PlayerXPosNext+1
    JMP CODE_05DA17

  + REP #$10                                  ; XY->16
    LDA.B _1
    AND.B #$1F
    STA.B _1
    LDA.B ScreenMode
    AND.B #!ScrMode_Layer1Vert
    BNE +
    LDA.B _1
    STA.B PlayerXPosNext+1
    JMP CODE_05DA17

  + LDA.B _1
    STA.B PlayerYPosNext+1
    STA.B Layer1YPos+1
    SEP #$10                                  ; XY->8
    LDY.W VertLayer2Setting
    CPY.B #$03
    BEQ +
    STA.B Layer2YPos+1
  + LDA.B #$01
    STA.W VertLayer1Setting
CODE_05DA17:
    SEP #$30                                  ; AXY->8
    LDA.W TranslevelNo
    CMP.B #$52
    BCC CODE_05DA24
    LDX.B #$03
    BRA CODE_05DA38

CODE_05DA24:
    LDX.B #$04
    LDY.B #$04
    LDA.B [Layer1DataPtr],Y
    AND.B #$0F
CODE_05DA2C:
    CMP.L DATA_05D760,X
    BEQ CODE_05DA38
    DEX
    BPL CODE_05DA2C
  - JMP CODE_05DAD7

CODE_05DA38:
    LDA.W SublevelCount
    BNE -
    LDA.W ShowMarioStart
    BNE -
    LDA.W DisableNoYoshiIntro
    BNE -
    LDA.W TranslevelNo
    CMP.B #$31
    BEQ CODE_05DA5E
    CMP.B #$32
    BEQ CODE_05DA5E
    CMP.B #$34
    BEQ CODE_05DA5E
    CMP.B #$35
    BEQ CODE_05DA5E
    CMP.B #$40
    BNE +
CODE_05DA5E:
    LDX.B #$05
  + LDA.W SkipMidwayCastleIntro
    BNE +
    LDA.L DATA_05D790,X
    STA.B PlayerYPosNext
    LDA.B #$01
    STA.B PlayerYPosNext+1
    LDA.B #$30
    STA.B PlayerXPosNext
    STZ.B PlayerXPosNext+1
    LDA.B #$C0
    STA.B Layer1YPos
    STA.B Layer2YPos
    STZ.W LevelEntranceType
    LDA.B #$EE
    STA.B SpriteDataPtr
    LDA.B #$C3
    STA.B SpriteDataPtr+1
    LDA.B #$07
    STA.B SpriteDataPtr+2
    LDA.B [SpriteDataPtr]
    AND.B #$3F
    STA.W SpriteMemorySetting
    LDA.B [SpriteDataPtr]
    AND.B #$C0
    STA.W SpriteBuoyancy
    STZ.W HorizLayer2Setting
    STZ.W VertLayer2Setting
    STZ.W HorizLayer1Setting
    STZ.B ScreenMode
    LDA.L DATA_05D78A,X
    STA.W Layer3Setting
    STX.B _0
    TXA
    ASL A
    CLC
    ADC.B _0
    TAY
    LDA.W PtrsLong05D766,Y
    STA.B Layer1DataPtr
    LDA.W PtrsLong05D766+1,Y
    STA.B Layer1DataPtr+1
    LDA.W PtrsLong05D766+2,Y
    STA.B Layer1DataPtr+2
    LDA.W PtrsLong05D778,Y
    STA.B Layer2DataPtr
    LDA.W PtrsLong05D778+1,Y
    STA.B Layer2DataPtr+1
    LDA.W PtrsLong05D778+2,Y
    STA.B Layer2DataPtr+2
  + LDA.L DATA_05D760,X
    STA.W ObjectTileset
CODE_05DAD7:
    LDA.W SublevelCount
    BEQ +
    LDA.W BonusGameActivate
    BNE +
    LDA.W TranslevelNo
    CMP.B #$24
    BNE +
    JSR CODE_05DAEF
  + PLB
    SEP #$30                                  ; AXY->8
    RTL

CODE_05DAEF:
    SEP #$30                                  ; AXY->8
    LDY.B #$04
    LDA.B [Layer1DataPtr],Y
    AND.B #$C0
    CLC
    ROL A
    ROL A
    ROL A
    JSL ExecutePtrLong

    dl CODE_05DB3E
    dl CODE_05DB6E
    dl CODE_05DB82

ChocIsld2Layer1:
    dw CI2Sub8Level0CD
    dw CI2Sub7Level6EC7E
    dw CI2Sub7Level6EC7E
    dw CI2Sub3Level0CF
    dw CI2Sub2Level6E9FB
    dw CI2Sub1Level6EAB0
    dw CI2Sub4Level0CE
    dw CI2Sub5Level6EB72
    dw CI2Sub6Level6EBBE

ChocIsld2Sprites:
    dw CI2Sub8Sprites0CD
    dw CI2Sub7Sprites6EC7E
    dw CI2Sub7Sprites6EC7E
    dw CI2Sub3Sprites0CF
    dw CI2Sub2Sprites6E9FB
    dw CI2Sub1Sprites6EAB0
    dw CI2Sub4Sprites0CE
    dw CI2Sub5Sprites6EB72
    dw CI2Sub6SPrites6EBBE

ChocIsld2Layer2:
    dw DATA_0CDF59
    dw DATA_0CDF59
    dw DATA_0CDF59
    dw DATA_0CDF59
    dw DATA_0CDF59
    dw DATA_0CDF59
    dw DATA_0CDF59
    dw DATA_0CDF59
    dw DATA_0CDF59

CODE_05DB3E:
    LDX.B #$00
    LDA.W DragonCoinsShown
    CMP.B #$04
    BEQ CODE_05DB49
    LDX.B #$02
CODE_05DB49:
    REP #$20                                  ; A->16
    LDA.L ChocIsld2Layer1,X
    STA.B Layer1DataPtr
    LDA.L ChocIsld2Sprites,X
    STA.B SpriteDataPtr
    LDA.L ChocIsld2Layer2,X
    STA.B Layer2DataPtr
    SEP #$20                                  ; A->8
    LDA.B [SpriteDataPtr]
    AND.B #$7F
    STA.W SpriteMemorySetting
    LDA.B [SpriteDataPtr]
    AND.B #$80
    STA.W SpriteBuoyancy
    RTS

CODE_05DB6E:
    LDX.B #$0A
    LDA.W GreenStarBlockCoins
    CMP.B #$16
    BPL +
    LDX.B #$08
    CMP.B #$0A
    BPL +
    LDX.B #$06
  + JMP CODE_05DB49

CODE_05DB82:
    LDX.B #$0C
    LDA.W InGameTimerHundreds
    CMP.B #$02
    BMI CODE_05DBA6
    LDA.W InGameTimerTens
    CMP.B #$03
    BMI CODE_05DBA6
    BNE CODE_05DB9B
    LDA.W InGameTimerOnes
    CMP.B #$05
    BMI CODE_05DBA6
CODE_05DB9B:
    LDX.B #$0E
    LDA.W InGameTimerTens
    CMP.B #$05
    BMI CODE_05DBA6
    LDX.B #$10
CODE_05DBA6:
    JMP CODE_05DB49


DATA_05DBA9:
    db $00,$C8,$00

CODE_05DBAC:
    LDY.B #$00
    LDA.W YoshiHeavenFlag
    BEQ +
    LDY.B #$01
  + LDX.B PlayerXPosNext+1
    LDA.B ScreenMode
    AND.B #!ScrMode_Layer1Vert
    BEQ +
    LDX.B PlayerYPosNext+1
  + LDA.W DATA_05DBA9,Y
    STA.W ExitTableLow,X
    INC.W SublevelCount
    RTS


DATA_05DBC9:
    db $50,$88,$00,$03,$FE,$38,$FE,$38
    db $FF,$B8,$3C,$B9,$3C,$BA,$3C,$BB
    db $3C,$BA,$3C,$BA,$BC,$BC,$3C,$BD
    db $3C,$BE,$3C,$BF,$3C,$C0,$3C,$B7
    db $BC,$C1,$3C,$B9,$3C,$C2,$3C,$C2
    db $BC

CODE_05DBF2:
    PHB
    PHK
    PLB
    LDX.B #$08
  - LDA.W DATA_05DBC9,X
    STA.L DynamicStripeImage,X
    DEX
    BPL -
    LDX.B #$00
    LDA.W PlayerTurnLvl
    BEQ +
    LDX.B #$01
  + LDA.W SavedPlayerLives,X
    INC A
    JSR CODE_05DC3A
    CPX.B #$00
    BEQ +
    CLC
    ADC.B #$22
    STA.L DynamicStripeImage+6
    LDA.B #$39
    STA.L DynamicStripeImage+7
    TXA
  + CLC
    ADC.B #$22
    STA.L DynamicStripeImage+4
    LDA.B #$39
    STA.L DynamicStripeImage+5
    LDA.B #$08
    STA.L DynStripeImgSize
    SEP #$20                                  ; A->8
    PLB
    RTL

CODE_05DC3A:
    LDX.B #$00
CODE_05DC3C:
    CMP.B #$0A
    BCC Return05DC45
    SBC.B #$0A
    INX
    BRA CODE_05DC3C

Return05DC45:
    RTS

    %insert_empty($3BA,$3BA,$3BA,$3BA,$3BA)

Layer1Ptrs:
    dl BonusGameLevel
    dl VS2Level001
    dl VS3Level002
    dl TSALevel003
    dl DGHLevel004
    dl DP3Level005
    dl DP4Level006
    dl C2Level007
    dl GSPLevel008
    dl DP2Level009
    dl DS1Level00A
    dl VFLevel00B
    dl BB1Level00C
    dl BB2Level00D
    dl C4Level00E
    dl CBALevel00F
    dl CMLevel010
    dl SLLevel011
    dl TestLevel
    dl DSHLevel013
    dl YSPLevel014
    dl DP1Level015
    dl DP1Level015
    dl DP1Level015
    dl SGSLevel018
    dl TestLevel
    dl C6Level01A
    dl CFLevel01B
    dl CI5Level01C
    dl CI4Level01D
    dl TestLevel
    dl FFLevel01F
    dl C5Level020
    dl CGHLevel021
    dl CI1Level022
    dl CI3Level023
    dl CI2Level024
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl LemmyCopyLevel
    dl WendyCopyLevel
    dl Mode7BossCopyLevel
    dl LarryIggyCopyLevel
    dl LarryIggyCopyLevel
    dl Mode7BossCopyLevel
    dl Mode7BossCopyLevel
    dl Mode7BossCopyLevel
    dl BowserCopyLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl CI5Sub1Level0BD
    dl CI1Sub2Level0BE
    dl CBASub1Level0BF
    dl CI5Sub2Level0C0
    dl CMSub1Level0C1
    dl DS1Sub1Level0C2
    dl DP4Sub1Level0C3
    dl DGHSub4Level0C4
    dl IntroLevel0C5
    dl SLSub1Level0C6
    dl TitleScrLevel0C7
    dl YoshiWingsLevel0C8
    dl GSPSub1Level0C9
    dl YSPSub1Level0CA
    dl VS3Sub1Level0CB
    dl Mode7BossLayer1
    dl CI2Sub8Level0CD
    dl CI2Sub4Level0CE
    dl CI2Sub3Level0CF
    dl CI1Level022
    dl CI1Level022
    dl DP4Sub1Level0D2
    dl C6Sub2Level0D3
    dl C6Sub1Level0D4
    dl Mode7BossLayer1
    dl FFSub1Level0D6
    dl CI3Sub1Level0D7
    dl VS2Sub1Level0D8
    dl Mode7BossLayer1
    dl C4Sub1Level0DA
    dl C4Sub3Level0DB
    dl C4Sub2Level0DC
    dl BB2Sub1Level0DD
    dl DGHSub1Level0F9
    dl Mode7BossLayer1
    dl VFSub1Level0E0
    dl VFSub1Level0E0
    dl Mode7BossLayer1
    dl DP1Sub2Level0E3
    dl DSHSub4Level0E4
    dl Mode7BossLayer1
    dl C2Sub1Level0E6
    dl C2Sub3Level0E7
    dl C2Sub2Level0E8
    dl DP2Sub1Level0E9
    dl CI4Sub1Level0EA
    dl GhostHouseExitLevel
    dl DSHLevel013
    dl DSHSub1Level0ED
    dl DSHLevel013
    dl CFSub1Level0EF
    dl GhostHouseExitLevel
    dl DSHSub2Level0F1
    dl DSHSub1Level0ED
    dl BB1Sub1Level0F3
    dl DP3Sub1Level0F4
    dl CI1Sub1Level0F5
    dl CI1Sub1Level0F5
    dl SGSSub2Level0F7
    dl SGSSub1Level0F8
    dl DGHSub1Level0F9
    dl DGHSub3Level0FA
    dl GhostHouseExitLevel
    dl CGHSub1Level0FC
    dl DP1Sub1Level0FD
    dl DGHSub2Level0FE
    dl DP2Sub2Level0FF
    dl BonusGameLevel
    dl C1Level101
    dl YI4Level102
    dl YI3Level103
    dl YHLevel104
    dl YI1Level105
    dl YI2Level106
    dl VGHLevel107
    dl SlopeTestLevel108
    dl VS1Level109
    dl VD3Level10A
    dl DS2Level10B
    dl TestLevel
    dl FDLevel10D
    dl BDLevel10E
    dl VoB4Level10F
    dl C7Level110
    dl VoBFLevel111
    dl TestLevel
    dl VoB3Level113
    dl VoBGHLevel114
    dl VoB2Level115
    dl VoB1Level116
    dl CSLevel117
    dl VD2Level118
    dl VD4Level119
    dl VD1Level11A
    dl RSPLevel11B
    dl C3Level11C
    dl FGHLevel11D
    dl FoI1Level11E
    dl FoI4Level11F
    dl FoI2Level120
    dl BSPLevel121
    dl FSALevel122
    dl FoI3Level123
    dl TestLevel
    dl FunkyLevel125
    dl OutrageousLevel126
    dl MondoLevel127
    dl GroovyLevel128
    dl TestLevel
    dl GnarlyLevel12A
    dl TubularLevel12B
    dl WayCoolLevel12C
    dl AwesomeLevel12D
    dl TestLevel
    dl TestLevel
    dl SW2Level130
    dl TestLevel
    dl SW3Level132
    dl TestLevel
    dl SW1Level134
    dl SW4Level135
    dl SW5Level136
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl WendyCopyLevel
    dl LemmyCopyLevel
    dl Mode7BossCopyLevel
    dl LarryIggyCopyLevel
    dl LarryIggyCopyLevel
    dl Mode7BossCopyLevel
    dl Mode7BossCopyLevel
    dl Mode7BossCopyLevel
    dl BowserCopyLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl TestLevel
    dl VoB3Sub1Level1BB
    dl FoI3Sub1Level1BC
    dl FDSub10Level1BD
    dl YI4Sub1Level1BE
    dl VoB4Sub1Level1BF
    dl CSSub1Level1C0
    dl FoI4Sub1Level1C1
    dl VD3Sub2Level1C2
    dl VD2Sub1Level1C3
    dl GnarlySub1Level1C4
    dl GnarlySub1Level1C4
    dl DS2Sub1Level1C6
    dl BowserLevel1C7
    dl YoshiWingsLevel1C8
    dl WayCoolSub1Level1C9
    dl YI2Sub1Level1CA
    dl YI1Sub1Level1CB
    dl FDSub8Level1CC
    dl FDSub7Level1CD
    dl FDSub6Level1CE
    dl FDSub5Level1CF
    dl FDSub9Level1D0
    dl FDSub4Level1D1
    dl FDSub3Level1D2
    dl FDSub2Level1D3
    dl FDSub1Level1D4
    dl SW2Sub1Level1D5
    dl SW1Sub1Level1D6
    dl BSPSub1Level1D7
    dl RSPSub1Level1D8
    dl VoBGHLevel114
    dl GhostHouseExitLevel
    dl VoBGHSub2Level1DB
    dl VoBGHSub2Level1DB
    dl VoBGHSub1Level1DD
    dl Mode7BossLayer1
    dl FoI4Sub2Level1DF
    dl MondoSub1Level1E0
    dl MondoSub2Level1E1
    dl VoB2Sub2Level1E2
    dl VoB2Sub1Level1E3
    dl VoB1Sub1Level1E4
    dl VoB1Sub2Level1E5
    dl FGHSub2Level1E6
    dl GhostHouseExitLevel
    dl FGHLevel11D
    dl FGHLevel11D
    dl VGHSub1Level1EA
    dl LarryIggyLevel
    dl CSSub3Level1EC
    dl CSSub2Level1ED
    dl CSSub4Level1EE
    dl VD1Sub1Level1EF
    dl VS1Sub2Level1F0
    dl VS1Sub1Level1F1
    dl C3Sub3Level1F2
    dl C3Sub2Level1F3
    dl C3Sub1Level1F4
    dl VD4Sub1Level1F5
    dl LarryIggyLevel
    dl VD3Sub1Level1F7
    dl FoI3Sub2Level1F8
    dl GhostHouseExitLevel
    dl FGHSub1Level1FA
    dl VGHLevel107
    dl C1Sub1Level1FC
    dl YI3Sub1Level1FD
    dl C7Sub1Level1FE
    dl YI4Sub2Level1FF

Layer2Ptrs:
    dw DATA_0CE674 : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CEC82 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CEC82 : db $FF
    dw DATA_0CDE54 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CE674 : db $FF
    dl DP2LvlL2009
    dw DATA_0CDAB9 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CDD44 : db $FF
    dl C4LvlL200E
    dw DATA_0CDD44 : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CDAB9 : db $FF
    dw DATA_0CDE54 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CDE54 : db $FF
    dw DATA_0CDE54 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CDAB9 : db $FF
    dw DATA_0CD900 : db $FF
    dl C6LvlL201A
    dw DATA_0CF45A : db $FF
    dw DATA_0CE7C0 : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CE103 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CDE54 : db $FF
    dw DATA_0CE7C0 : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CDE54 : db $FF
    dl GhostHouseExitLvlL2
    dw DATA_0CD900 : db $FF
    dw DATA_0CE472 : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CE684 : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CDE54 : db $FF
    dw DATA_0CDE54 : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CF45A : db $FF
    dl C6Sub1LvlL20D4
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CF45A : db $FF
    dl C4Sub2LvlL20DC
    dw DATA_0CDD44 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CDE54 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CE674 : db $FF
    dl C2Sub3LvlL20E7
    dw DATA_0CF45A : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CE8FE : db $FF
    dl GhostHouseExitLvlL2
    dw DATA_0CEF80 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CF45A : db $FF
    dl GhostHouseExitLvlL2
    dw DATA_0CEF80 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CDE54 : db $FF
    dw DATA_0CDE54 : db $FF
    dw DATA_0CE8EE : db $FF
    dw DATA_0CF175 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CEF80 : db $FF
    dl GhostHouseExitLvlL2
    dw DATA_0CEF80 : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CDE54 : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CE103 : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CEC82 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CE7C0 : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CE103 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CF45A : db $FF
    dl VoBFLvlL2111
    dw DATA_0CD900 : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CEF80 : db $FF
    dl VoB2LvlL2115
    dw DATA_0CE8FE : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CE684 : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CF45A : db $FF
    dl FGHLvlL211D
    dw DATA_0CEC82 : db $FF
    dw DATA_0CEC82 : db $FF
    dw DATA_0CDAB9 : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CEC82 : db $FF
    dw DATA_0CEC82 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CDC71 : db $FF
    dw DATA_0CEC82 : db $FF
    dw DATA_0CE7C0 : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CE472 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CDAB9 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CE684 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CE684 : db $FF
    dw DATA_0CE684 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CDF59 : db $FF
    dw DATA_0CDAB9 : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CD900 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CE103 : db $FF
    dl FDSub6LvlL21CE
    dl FDSub5LvlL21CF
    dw DATA_0CE103 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CE103 : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CEF80 : db $FF
    dl GhostHouseExitLvlL2
    dw DATA_0CEF80 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CDD44 : db $FF
    dw DATA_0CE7C0 : db $FF
    dl VoB2Sub2LvlL21E2
    dl VoB2Sub1LvlL21E3
    dw DATA_0CE674 : db $FF
    dw DATA_0CE8FE : db $FF
    dl GhostHouseExitLvlL2
    dl GhostHouseExitLvlL2
    dl FGHLvlL211D
    dl FGHLvlL211D
    dw DATA_0CEF80 : db $FF
    dw DATA_0CF45A : db $FF
    dl CSSub3LvlL21EC
    dw DATA_0CE8FE : db $FF
    dw DATA_0CE8FE : db $FF
    dl VD1Sub1LvlL21EF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CF45A : db $FF
    dl C3Sub2LvlL21F3
    dw DATA_0CF45A : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CE674 : db $FF
    dw DATA_0CE8FE : db $FF
    dl GhostHouseExitLvlL2
    dw DATA_0CEF80 : db $FF
    dw DATA_0CEF80 : db $FF
    dw DATA_0CE103 : db $FF
    dw DATA_0CE8FE : db $FF
    dw DATA_0CF45A : db $FF
    dw DATA_0CDF59 : db $FF

Ptrs05EC00:
    dw BonusGameSprites
    dw VS2Sprites001
    dw VS3Sprites002
    dw TSASprites003
    dw DGHSprites004
    dw DP3Sprites005
    dw DP4Sprites006
    dw C2Sprites007
    dw GSPSprites008
    dw DP2Sprites009
    dw DS1Sprites00A
    dw VFSprites00B
    dw BB1Sprites00C
    dw BB2Sprites00D
    dw C4Sprites00E
    dw CBASprites00F
    dw CMSprites010
    dw SLSprites011
    dw TestLevelSprites
    dw DSHSprites013
    dw YSPSprites014
    dw DP1Sprites015
    dw DP1Sprites015
    dw DP1Sprites015
    dw SGSSprites018
    dw TestLevelSprites
    dw C6Sprites01A
    dw CFSprites01B
    dw CI5Sprites01C
    dw CI4Sprites01D
    dw TestLevelSprites
    dw FFSprites01F
    dw C5Sprites020
    dw CGHSprites021
    dw CI1Sprites022
    dw CI3Sprites023
    dw CI2Sprites024
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw LemmyCopySprites
    dw WendyCopySprites
    dw ReznorCopySprites
    dw LarryCopySprites
    dw IggyCopySprites
    dw LudwigCopySprites
    dw RoyCopySprites
    dw MortonCopySprites
    dw BowserCopySprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw EmptySprites
    dw CI1Sub2Sprites0BE
    dw CBASub1Sprites0BF
    dw CI5Sub2Sprites0C0
    dw CMSub1Sprites0C1
    dw DS1Sub1Sprites0C2
    dw DP4Sub1Sprites0C3
    dw GHNormalExitSprites
    dw IntroSprites0C5
    dw SubNormalExitSprites
    dw TitleScrSprites0C7
    dw YoshiWingsSprites0C8
    dw GSPSub1Sprites0C9
    dw YSPSub1Sprites0CA
    dw SubNormalExitSprites
    dw C5Sub1Sprites0CC
    dw CI2Sub8Sprites0CD
    dw CI2Sub4Sprites0CE
    dw CI2Sub3Sprites0CF
    dw CI1Sprites022
    dw CI1Sprites022
    dw DP4Sub1Sprites0D2
    dw C6Sub2Sprites0D3
    dw C6Sub1Sprites0D4
    dw ReznorSubSprites
    dw FFSub1Sprites0D6
    dw CI3Sub1Sprites0D7
    dw VS2Sub1Sprites0D8
    dw C4Sub4Sprites0D9
    dw EmptySprites
    dw C4Sub3Sprites0DB
    dw C4Sub2Sprites0DC
    dw BB2Sub1Sprites0DD
    dw DGHSub1Sprites0F9
    dw ReznorSubSprites
    dw VFSub1Sprites0E0
    dw VFSub1Sprites0E0
    dw ReznorSubSprites
    dw DP1Sub2Sprites0E3
    dw DSHSub4Sprites0E4
    dw C2Sub4Sprites0E5
    dw EmptySprites
    dw C2Sub3Sprites0E7
    dw C2Sub2Sprites0E8
    dw DP2Sub1Sprites0E9
    dw CI4Sub1Sprites0EA
    dw SubSecretExitSprites
    dw DSHSprites013
    dw DSHSub1Sprites0ED
    dw DSHSprites013
    dw CFSub1Sprites0EF
    dw GHNormalExitSprites
    dw DSHSub2Sprites0F1
    dw DSHSub1Sprites0ED
    dw SubNormalExitSprites
    dw EmptySprites
    dw CI1Sprites022
    dw CI1Sprites022
    dw SGSSub2Sprites0F7
    dw SGSSub1Sprites0F8
    dw DGHSub1Sprites0F9
    dw EmptySprites
    dw GHNormalExitSprites
    dw CGHSub1Sprites0FC
    dw EmptySprites
    dw DGHSub2Sprites0FE
    dw SubNormalExitSprites
    dw BonusGameSprites
    dw C1Sprites101
    dw YI4Sprites102
    dw YI3Spirtes103
    dw YHSprites104
    dw YI1Sprites105
    dw YI2Sprites106
    dw VGHSprites107
    dw TestLevelSprites
    dw VS1Sprites109
    dw VD3Sprites10A
    dw DS2Sprites10B
    dw TestLevelSprites
    dw FDSprites10D
    dw BDSprites10E
    dw VoB4Sprites10F
    dw C7Sprites110
    dw VoBFSprites111
    dw TestLevelSprites
    dw VoB3Sprites113
    dw VoBGHSprites114
    dw VoB2Sprites115
    dw VoB1Sprites116
    dw CSSprites117
    dw VD2Sprites118
    dw VD4Sprites119
    dw VD1Sprites11A
    dw RSPSprites11B
    dw C3Sprites11C
    dw FGHSprites11D
    dw FoI1Sprites11E
    dw FoI4Sprites11F
    dw FoI2Sprites120
    dw BSPSprites121
    dw FSASprites122
    dw FoI3Sprites123
    dw TestLevelSprites
    dw FunkySprites125
    dw OutrageousSprites126
    dw MondoSprites127
    dw GroovySprites128
    dw TestLevelSprites
    dw GnarlySprites12A
    dw TubularSprites12B
    dw WayCoolSprites12C
    dw AwesomeSprites12D
    dw TestLevelSprites
    dw TestLevelSprites
    dw SW2Sprites130
    dw TestLevelSprites
    dw SW3Sprites132
    dw TestLevelSprites
    dw SW1Sprites134
    dw SW4Sprites135
    dw SW5Sprites136
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw WendyCopySprites
    dw LemmyCopySprites
    dw ReznorCopySprites
    dw LarryCopySprites
    dw IggyCopySprites
    dw LudwigCopySprites
    dw RoyCopySprites
    dw MortonCopySprites
    dw BowserCopySprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw TestLevelSprites
    dw EmptySprites
    dw EmptySprites
    dw BDSprites10E
    dw YI4Sub1Sprites1BE
    dw VoB4Sub1Sprites1BF
    dw CSSub1Sprites1C0
    dw FoI4Sub1Sprites1C1
    dw VD3Sub2Sprites1C2
    dw VD2Sub1Sprites1C3
    dw GnarlySub1Sprites1C4
    dw GnarlySub1Sprites1C4
    dw DS2Sub1Sprites1C6
    dw BowserSprites1C7
    dw YoshiWingsSprites1C8
    dw EmptySprites
    dw YI2Sub1Sprites1CA
    dw EmptySprites
    dw FDSub8Sprites1CC
    dw FDSub7Sprites1CD
    dw FDSub6Sprites1CE
    dw FDSub5Sprites1CF
    dw FDSprites10D
    dw FDSub4Sprites1D1
    dw FDSub3Sprites1D2
    dw FDSub2Sprites1D3
    dw FDSub1Sprites1D4
    dw SubNormalExitSprites
    dw SubNormalExitSprites
    dw BSPSub1Sprites1D7
    dw RSPSub1Sprites1D8
    dw VoBGHSprites114
    dw GHNormalExitSprites
    dw VoBGHSub2Sprites1DB
    dw VoBGHSub2Sprites1DB
    dw VoBGHSub1Sprites1DD
    dw ReznorSubSprites
    dw FoI4Sub2Sprites1DF
    dw EmptySprites
    dw SubNormalExitSprites
    dw VoB2Sub2Sprites1E2
    dw VoB2Sub1Sprites1E3
    dw EmptySprites
    dw VoB1Sub2Sprites1E5
    dw GHNormalExitSprites
    dw SubSecretExitSprites
    dw FGHSprites11D
    dw FGHSprites11D
    dw VGHSub1Sprites1EA
    dw C7Sub2Sprites1EB
    dw CSSub3Sprites1EC
    dw CSSub2Sprites1ED
    dw SubNormalExitSprites
    dw VD1Sub1Sprites1EF
    dw VS1Sub2Sprites1F0
    dw VS1Sub1Sprites1F1
    dw C3Sub3Sprites1F2
    dw C3Sub2Sprites1F3
    dw EmptySprites
    dw VD4Sub1Sprites1F5
    dw C1Sub2Sprites1F6
    dw EmptySprites
    dw FoI3Sub2Sprites1F8
    dw GHNormalExitSprites
    dw FGHSub1Sprites1FA
    dw VGHSprites107
    dw C1Sub1Sprites1FC
    dw YI3Sub1Sprites1FD
    dw C7Sub1Sprites1FE
    dw YI4Sub2Sprites1FF

DATA_05F000:
    db $07,$5B,$19,$2B,$1B,$5B,$5B,$5B
    db $27,$37,$18,$19,$59,$5B,$29,$1B
    db $5B,$58,$05,$5B,$2B,$5B,$1B,$1B
    db $51,$0B,$4B,$1B,$07,$52,$0B,$1B
    db $57,$1B,$5B,$5B,$5B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$57,$57,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$6C,$18,$19
    db $1A,$51,$0D,$1A,$2B,$5B,$1B,$5A
    db $6B,$2B,$2B,$18,$0B,$1B,$1B,$5B
    db $59,$58,$19,$57,$49,$0B,$5B,$52
    db $19,$0B,$6C,$0C,$48,$18,$5A,$0B
    db $59,$59,$0B,$5A,$2A,$0B,$6C,$7D
    db $5B,$5A,$00,$2B,$5B,$5B,$5B,$17
    db $2B,$5B,$58,$18,$6C,$59,$58,$01
    db $17,$5B,$1B,$2B,$1B,$6C,$5A,$2A
    db $07,$1B,$18,$5B,$0B,$5B,$5B,$5B
    db $0B,$0D,$58,$5B,$0B,$1A,$1B,$58
    db $5B,$48,$0B,$1B,$0A,$4B,$5B,$57
    db $52,$17,$57,$2B,$17,$29,$1C,$5B
    db $59,$2B,$56,$1C,$0B,$5B,$1C,$1B
    db $1A,$0B,$05,$58,$5B,$19,$0B,$0B
    db $58,$0B,$5B,$0B,$01,$5B,$5B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$57,$57,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$6C,$6C,$1B,$5A,$16
    db $1A,$19,$16,$16,$58,$5C,$1A,$0B
    db $5D,$19,$19,$19,$1B,$1B,$73,$4B
    db $1A,$59,$59,$1B,$1B,$1B,$1B,$2B
    db $2B,$09,$2B,$0B,$0B,$09,$0B,$29
    db $52,$1B,$48,$4B,$6C,$5B,$2B,$2B
    db $2B,$29,$5B,$0B,$4B,$01,$5B,$49
    db $1B,$1B,$57,$48,$1B,$19,$0B,$6C
    db $28,$2B,$1B,$5A,$1B,$19,$19,$1B
DATA_05F200:
    db $20,$00,$80,$01,$00,$01,$00,$00
    db $00,$C0,$38,$39,$00,$00,$00,$00
    db $00,$F8,$00,$00,$00,$00,$00,$00
    db $F8,$00,$C0,$00,$00,$01,$00,$80
    db $01,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$01,$01,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$10,$A0,$20
    db $18,$A0,$18,$18,$00,$01,$18,$00
    db $01,$10,$10,$10,$00,$10,$10,$10
    db $31,$30,$20,$01,$C0,$00,$00,$18
    db $20,$00,$10,$01,$C1,$20,$01,$00
    db $39,$39,$00,$18,$00,$00,$10,$C0
    db $01,$18,$01,$00,$00,$03,$03,$00
    db $00,$01,$00,$10,$10,$31,$30,$20
    db $38,$00,$00,$00,$00,$10,$01,$18
    db $20,$00,$80,$00,$01,$00,$00,$00
    db $00,$01,$00,$28,$00,$00,$00,$00
    db $01,$C0,$00,$00,$00,$C0,$00,$00
    db $01,$00,$00,$00,$01,$00,$00,$00
    db $38,$00,$00,$00,$00,$00,$00,$40
    db $00,$00,$01,$01,$00,$28,$00,$00
    db $F8,$00,$00,$00,$01,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$01,$01,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$10,$10,$00,$18,$28
    db $18,$F8,$28,$28,$1B,$19,$18,$00
    db $00,$20,$20,$20,$00,$00,$F8,$C0
    db $00,$00,$00,$00,$80,$18,$10,$10
    db $10,$03,$00,$03,$00,$01,$00,$20
    db $18,$10,$D1,$D1,$10,$18,$00,$00
    db $01,$01,$01,$00,$D1,$10,$10,$D0
    db $09,$11,$01,$C0,$00,$20,$00,$10
    db $20,$00,$01,$01,$80,$20,$00,$10
DATA_05F400:
    db $0A,$9A,$8A,$0A,$0A,$AA,$AA,$0A
    db $0A,$0A,$0A,$0A,$0A,$9A,$0A,$9A
    db $9A,$0A,$02,$0A,$0A,$9A,$9A,$9A
    db $03,$0A,$BA,$8A,$BA,$00,$0A,$0A
    db $0A,$0A,$9A,$9A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$00,$00,$00
    db $00,$00,$00,$00,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$09,$0A,$0A
    db $0A,$0A,$0A,$0A,$00,$0A,$0A,$0A
    db $9A,$9A,$0A,$0A,$0B,$00,$0A,$03
    db $0A,$00,$0A,$0A,$0A,$0A,$0A,$00
    db $0A,$0A,$00,$0A,$0A,$00,$0A,$03
    db $0A,$0A,$00,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$03
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$7A,$0A,$9A,$0A,$9A,$9A,$0A
    db $0A,$02,$FA,$0A,$0A,$0A,$6A,$9A
    db $7A,$0A,$0A,$8A,$0A,$7A,$9A,$7A
    db $A0,$9A,$FA,$0A,$9A,$0A,$9A,$9A
    db $0A,$0A,$05,$9A,$0A,$0A,$9A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$03,$9A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$00,$00,$00
    db $00,$00,$00,$00,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$00
    db $0A,$0A,$0A,$0A,$0A,$0A,$03,$0A
    db $0A,$09,$0A,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$00,$0A
    db $03,$0A,$0B,$0A,$0A,$0A,$0A,$0A
    db $0A,$0A,$0A,$00,$0A,$03,$0A,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$00,$0A
    db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
DATA_05F600:
    db $00,$00,$80,$00,$00,$80,$00,$00
    db $00,$00,$00,$00,$80,$80,$00,$80
    db $00,$00,$64,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$80,$80,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$03,$64,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $10,$07,$00,$00,$00,$00,$00,$00
    db $04,$00,$00,$64,$09,$00,$01,$00
    db $04,$00,$00,$00,$00,$00,$00,$67
    db $02,$00,$60,$00,$02,$04,$04,$00
    db $00,$01,$00,$00,$00,$10,$07,$60
    db $00,$00,$00,$00,$00,$00,$01,$00
    db $00,$00,$80,$80,$00,$00,$00,$00
    db $00,$66,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$80,$00,$00,$00,$00
    db $00,$80,$00,$00,$00,$00,$00,$00
    db $00,$00,$80,$00,$00,$00,$00,$00
    db $00,$00,$E4,$00,$80,$00,$00,$00
    db $80,$00,$80,$00,$E0,$80,$80,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$03
    db $00,$03,$00,$00,$01,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$64,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$03,$00,$03,$00,$03,$00,$00
    db $00,$00,$01,$00,$00,$00,$00,$00
    db $07,$06,$00,$00,$00,$60,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$05,$00,$00,$00,$00
DATA_05F800:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$0F
    db $1C,$10,$0A,$06,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$06,$00,$00,$00,$00,$23
    db $01,$00,$00,$00,$00,$0D,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$1D,$00,$00,$00,$00,$14
    db $00,$00,$00,$00,$05,$00,$00,$00
    db $00,$00,$00,$00,$00,$15,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$13,$23,$00,$02,$0F
    db $17,$1F,$00,$18,$00,$00,$0B,$00
    db $00,$2C,$06,$05,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $27,$00,$00,$00,$16,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$1A
    db $00,$00,$00,$00,$00,$19,$00,$0A
    db $23,$00,$00,$00,$00,$03,$00,$00
DATA_05FA00:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$AB
    db $A9,$C2,$A6,$AA,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$AA,$02
    db $AA,$00,$A8,$00,$00,$00,$00,$A8
    db $A8,$AA,$00,$AA,$00,$AB,$A9,$00
    db $00,$AB,$00,$00,$00,$00,$00,$00
    db $00,$00,$02,$00,$00,$00,$00,$AB
    db $AA,$00,$00,$00,$A9,$00,$AA,$AB
    db $00,$00,$00,$00,$00,$A9,$00,$AB
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$A8,$AA,$00,$AB,$A9
    db $A7,$AA,$00,$AA,$00,$00,$A7,$00
    db $00,$AB,$AB,$A9,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $AA,$00,$00,$00,$A8,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$A7
    db $00,$00,$00,$00,$00,$AB,$00,$AB
    db $AA,$00,$00,$00,$00,$A9,$00,$00
DATA_05FC00:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$0E
    db $2A,$25,$64,$04,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$21,$68
    db $26,$00,$08,$00,$00,$00,$00,$6D
    db $70,$2B,$00,$0D,$00,$2D,$27,$00
    db $00,$2D,$00,$00,$00,$00,$00,$00
    db $00,$00,$6A,$00,$00,$00,$00,$02
    db $6A,$00,$00,$00,$70,$00,$0E,$21
    db $00,$00,$00,$00,$00,$2B,$00,$0A
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$08,$04,$00,$05,$03
    db $26,$68,$00,$30,$00,$00,$2A,$00
    db $00,$69,$70,$08,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $2A,$00,$00,$00,$29,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$2E
    db $00,$00,$00,$00,$00,$2F,$00,$2F
    db $32,$00,$00,$00,$00,$28,$00,$00
DATA_05FE00:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$03
    db $03,$03,$07,$03,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$03,$01
    db $03,$00,$06,$00,$00,$00,$00,$04
    db $06,$03,$00,$03,$00,$03,$00,$00
    db $00,$03,$00,$00,$00,$00,$00,$00
    db $00,$00,$03,$00,$00,$00,$00,$00
    db $03,$00,$00,$00,$03,$00,$03,$02
    db $00,$00,$00,$00,$00,$04,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$04,$03,$00,$03,$03
    db $04,$03,$00,$03,$00,$00,$05,$00
    db $00,$03,$03,$06,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $03,$00,$00,$00,$03,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$02
    db $00,$00,$00,$00,$00,$03,$00,$02
    db $03,$00,$00,$00,$00,$03,$00,$00