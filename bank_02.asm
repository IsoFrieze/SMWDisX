    ORG $028000

DATA_028000:
    db $80,$40,$20,$10,$08,$04,$02,$01

CODE_028008:
; Unused AND table.
    PHX                                       ; Item box drop routine.
    LDA.W PlayerItembox                       ; If there's no item in the player's item box, return.
    BEQ CODE_028070
    STZ.W PlayerItembox
    PHA
    LDA.B #!SFX_ITEMDEPLOYED                  ; \ Play sound effect; Item box sound effect
    STA.W SPCIO3                              ; /
    LDX.B #$0B
CODE_028019:
    LDA.W SpriteStatus,X
    BEQ CODE_028042
    DEX
    BPL CODE_028019                           ; Look for an open slot.
    DEC.W SpriteToOverwrite                   ; If all are full, overwrite one.
    BPL +
    LDA.B #$01
    STA.W SpriteToOverwrite
  + LDA.W SpriteToOverwrite
    CLC
    ADC.B #$0A
    TAX
    LDA.B SpriteNumber,X
    CMP.B #$7D                                ; Overwrite a slot.
    BNE CODE_028042
    LDA.W SpriteStatus,X
    CMP.B #$0B
    BNE CODE_028042
    STZ.W PBalloonInflating
CODE_028042:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    PLA                                       ; Spawn sprite.
    CLC                                       ; Sprite = Item Box + 73
    ADC.B #$73
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    LDA.B #$78                                ; Spawn X position of the item box sprite within the screen.
    CLC
    ADC.B Layer1XPos
    STA.B SpriteXPosLow,X                     ; Store the X position.
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B #$20                                ; Spawn Y position of the item box sprite within the screen.
    CLC
    ADC.B Layer1YPos
    STA.B SpriteYPosLow,X                     ; Store the Y position.
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    INC.W SpriteMisc1534,X                    ; Set blink-fall flag.
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
; Bob-omb explosion X position spacing. Added on top of each other to get the new position.
; Bob-omb explosion Y position spacing. Added on top of each other to get the new position.
    JSR ExplodeBombSubRt                      ;BOMB; Routine to handle the Bob-omb's explosion.
    RTL

ExplodeBombSubRt:
    STZ.W SpriteTweakerA,X                    ; Make sprite unstompable; Make Mario take damage if he lands on top of it.
    LDA.B #$11                                ; \ Set new clipping area for explosion; Change the Bob-omb's sprite hitbox size.
    STA.W SpriteTweakerB,X                    ; /
    JSR GetDrawInfo2
    LDA.B SpriteLock                          ; \ Increase frame count if sprites not locked
    BNE +                                     ; |; If sprites aren't locked, increment the frame timer for the explosion animation.
    INC.W SpriteMisc1570,X                    ; /
  + LDA.W SpriteMisc1540,X                    ; \ When timer is up free up sprite slot
    BNE +                                     ; |; Erase the sprite once the explosion finishes.
    STZ.W SpriteStatus,X                      ; /
    RTS

  + LDA.W SpriteMisc1540,X
    LSR A
    AND.B #$03
    CMP.B #$03                                ; For 2 out of every 8 frames...
    BNE +
    JSR ExplodeSprites                        ; Process interaction with sprites.
    LDA.W SpriteMisc1540,X
    SEC                                       ; As well as Mario.
    SBC.B #$10                                ; Don't interact during the first and last 16 frames of the explosion, though.
    CMP.B #$20
    BCS +
    JSL MarioSprInteract
  + LDY.B #$04                                ; Number of stars to draw, minus 1.
    STY.B _F
CODE_0280C4:
    LDA.W SpriteMisc1540,X
    LSR A
    PHA
    AND.B #$03
    STA.B _2
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos                          ; Get the X position within the screen for the explosion graphics.
    CLC
    ADC.B #$04                                ; X position offset of the explosion graphics.
    STA.B _0
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos                          ; Get the Y position within the screen for the explosion graphics.
    CLC
    ADC.B #$04                                ; Y position offset of the explosion graphics.
    STA.B _1
    LDY.B _F
    PLA
    AND.B #$04
    BEQ CODE_0280ED                           ; Switch star sets every 8 frames.
    TYA
    CLC
    ADC.B #$05
    TAY
CODE_0280ED:
    LDA.B _0
    CLC
    ADC.W BombExplosionX,Y
    STA.B _0                                  ; Get the position to draw the current star at.
    LDA.B _1
    CLC
    ADC.W BombExplosionY,Y
    STA.B _1
    DEC.B _2                                  ; Shrink the star spacing every few frames by recursively adding the offsets.
    BPL CODE_0280ED
    LDA.B _F
    ASL A
    ASL A                                     ; Upload the explosion stars to OAM.
    ADC.W SpriteOAMIndex,X
    TAY
    LDA.B _0
    STA.W OAMTileXPos+$100,Y                  ; Store sprite tile position.
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.B #$BC                                ; Tile number to use for the explosion effect.
    STA.W OAMTileNo+$100,Y
    LDA.B TrueFrame
    LSR A
    LSR A
    AND.B #$03                                ; Set YXPPCCCT settings for the explosion, based on the frame counter.
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
    LDA.B #$04                                ; Draw 5 8x8s to the screen.
    JMP CODE_02B7A7

ExplodeSprites:
    LDY.B #$09                                ; \ Loop over sprites:; Subroutine to look for sprites worth killing with an explosion.
ExplodeLoopStart:
    CPY.W CurSpriteProcess                    ; | Don't attempt to kill self; Skip interaction with itself.
    BEQ CODE_02814C                           ; |
    PHY                                       ; |
    LDA.W SpriteStatus,Y                      ; | Skip sprite if it's already dying/dead
    CMP.B #$08                                ; |; If the sprite is living, check if it should be killed by the explosion.
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
    JSL GetSpriteClippingA                    ; |; If the sprite isn't touching the explosion, return.
    JSL CheckForContact                       ; |
    BCC +                                     ; /
    LDA.W SpriteTweakerD,Y                    ; \ Return if sprite is invincible
    AND.B #$02                                ; | to explosions; If it can't be killed by an explosion, return.
    BNE +                                     ; /
    LDA.B #$02                                ; \ Sprite status = Killed; Knock offscreen.
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$C0                                ; \ Sprite Y speed = #$C0; Y speed of sprites falling offscreen via an explosion.
    STA.W SpriteYSpeed,Y                      ; /
    LDA.B #$00                                ; \ Sprite X speed = #$00; X speed of sprites falling offscreen via an explosion.
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
; X positions for the tiles at $028226.
; Ludwig
; Morton/Roy
; Y positions for the tiles at $028226.
; Ludwig
; Morton/Roy
; Tile numbers for the BG of the Mode 7 boss rooms (Roy/Morton/Ludwig).
; Ludwig
; Morton/Roy
    LDA.B Layer1XPos                          ; Routine to handle the sprite BG tilemap in Morton/Roy/Ludwig's rooms, as well as the pillars in Morton/Roy's.
    STA.W BossBGSpriteXCalc
    EOR.B #$FF
    INC A                                     ; (unused)
    STA.B _5
    LDA.B Layer1XPos+1
    LSR A
    ROR.W BossBGSpriteXCalc
    PHA
    LDA.W BossBGSpriteXCalc                   ; $06 = Base X offset for all of the sprite tiles.
    EOR.B #$FF                                ; Basically: this gets Layer 1's position right-shifted one bit, then inverts it.
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
    LDA.B #$66                                ; OAM index (from $0200) for offscreen tiles in Ludwig's room.
    STY.B _3
    LDA.B #$F0
  - STA.W OAMTileYPos+$0C,Y
    INY                                       ; Start by hiding all the tiles in the room offscreen.
    INY
    INY
    INY
    CPY.W #$018C
    BCC -
    LDX.W #$0000
    STX.B _C
    LDX.W #$0038
    LDY.W #$00E0
    LDA.W SpriteMisc187B+9                    ; X = Highest index to the background tilemap data for the boss (this value decrements).
    CMP.B #$01                                ; Y = Highest OAM indice for the boss's background (this value decrements).
    BNE CODE_0282D8
    LDX.W #$0039                              ; Get indices based on whether the BG is Ludwig's or Morton/Roy's.
    STX.B _C
    LDX.W #$001D
    LDY.W #$00FC
CODE_0282D8:
    STX.B _0                                  ; Morton/Roy/Ludwig tilemap upload loop.
    REP #$20                                  ; A->16
    TXA
    CLC                                       ; Get index to the current tile.
    ADC.B _C
    STA.B _A
    SEP #$20                                  ; A->8
    LDA.B _6
    CLC
    LDX.B _A                                  ; Store the tile's X position to OAM.
    ADC.L DATA_028178,X
    STA.W OAMTileXPos+$0C,Y
    STA.B _2
    LDA.W ScreenShakeYOffset
    STA.B _7
    ASL A
    ROR.B _7
    LDA.L DATA_0281CF,X                       ; Store the tile's Y position to OAM.
    DEC A
    SEC
    SBC.B _7
    STA.W OAMTileYPos+$0C,Y
    LDX.B _A
    LDA.W BossBGSpriteUpdate                  ; Set tile number/YXPPCCCT of the tile, only on initialization.
    BNE +
    LDA.L DATA_028226,X                       ; Store the tile's tile number to OAM.
    STA.W OAMTileNo+$0C,Y
    LDA.B #$0D                                ; YXPPCCCT to use for all the tiles in Morton/Roy/Ludwig's BGs.
    STA.W OAMTileAttr+$0C,Y
  + REP #$20                                  ; A->16
    PHY
    TYA
    LSR A
    LSR A                                     ; Store size to OAM as 16x16.
    TAY
    SEP #$20                                  ; A->8
    LDA.B #$02
    STA.W OAMTileSize+3,Y
    LDA.B _2
    CMP.B #$F0
    BCC +                                     ; Continue to the next tile if in Morton/Roy's room, or the tile is horizontally onscreen.
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
    LDA.W OAMTileAttr+$0C,Y                   ; Transfer the OAM data to a different OAM index, with the intention of hiding it offscreen.
    STA.W OAMTileAttr+$0C,X
    REP #$20                                  ; A->16
    TXA
    LSR A
    LSR A
    TAY
    SEP #$20                                  ; A->8
    LDA.B #$03                                ; Set high X bit so the tile is moved offscreen.
    STA.W OAMTileSize+3,Y
    LDA.B _3
    CLC
    ADC.B #$04                                ; Increment OAM index for the next offscreen tile.
    STA.B _3
    BCC +
    INC.B _4
  + PLY                                       ; Not hiding the tile.
    LDX.B _0
    DEY
    DEY
    DEY                                       ; Continue for all the tiles.
    DEY
    DEX
    BMI +
    JMP CODE_0282D8

  + SEP #$10                                  ; XY->8; Done uploading the boss BG.
    LDA.B #$01                                ; Set flag for done initializing the BG.
    STA.W BossBGSpriteUpdate
    LDA.W SpriteMisc187B+9
    CMP.B #$01                                ; Branch if in Ludwig's room.
    BNE CODE_028398
    LDA.B #$CD
    STA.W OAMTileAttr+$BC
    STA.W OAMTileAttr+$C0
    STA.W OAMTileAttr+$C4                     ; Add an extra X and Y flip for the bottom tiles of the "boxes" in Morton/Roy's BG.
    STA.W OAMTileAttr+$C8
    STA.W OAMTileAttr+$CC
    STA.W OAMTileAttr+$D0
    BRA CODE_0283C4

CODE_028398:
    LDA.B EffFrame                            ; In Ludwig's room.
    AND.B #$03                                ; Branch if not a frame to update the flames in the BG of Ludwig's room.
    BNE CODE_0283C4
    STZ.B _0
CODE_0283A0:
    LDX.B _0
    LDA.L DATA_0283C8,X
    TAY
    JSL GetRand
    AND.B #$01
    BNE +                                     ; Randomly flip the flame between tiles E8 and EA.
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
; Change the YXPPCCCT for the flame.
; Loop for all of the flame tiles.
; Handle Morton/Roy's pillars.
; OAM offsets for each of the flames in the BG of Ludwig's room.
; OAM indices for Morton and Roy's pillars.
; Subroutine to handle Morton/Roy's pillars.
; $0C = X position of the left wall
; $0D = X position of the right wall
; Handle the pillar if it's fallen/starting to fall, and draw it to the screen.
; Handle dropping the pillars if they're not done falling yet.
; Freeze Mario and Morton/Roy while doing so.
; Subroutine to handle Morton/Roy's pillars.
; Handle dropping Morton/Roy's pillars.
; Branch if not at the lowest position yet, to just store the position and return.
; Y position that Morton/Roy's pillars fall to (also change $028434).
; Set high bit of the pillar status (to indicate the pillar is done falling).
; How long the screen shakes after a pillar drops.
; SFX for one of Morton/Roy's pillars dropping.
; If this pillar was the left pillar, make the right pillar start falling.
; If this pillar was the right pillar, unfreeze Morton/Roy and Mario.
; Y position that Morton/Roy's pillars fall to (also change $028405).
; Pillars aren't done falling yet.
; Subroutine to handle drawing Morton/Roy's pillars.
; Hide the tile offscreen by default.
; Return if the tile actually is offscreen.
; Store Y position to OAM, if not below Morton/Roy's floor (in which case, keep hidden).
; Store X position to OAM.
; Tile number for the spike of the pillar.
; Tile number for the bricks of the pillar.
; YXPPCCCT for Morton/Roy's pillars.
; Set size as 16x16.
; Loop until the entire wall is drawn.
; Equivalent routine in bank 1 at $01AD30, bank 3 at $03B817.
; Subroutine to check horizontal proximity of Mario to a sprite.
; Returns the side in Y (0 = right) and distance in $0F.
; Store horizontal distance in $0F.
; If Mario is to the left, return Y=1. Else, Y=0.
; Subroutine to check if a sprite is offscreen horizontally or vertically. The result is stored in A.
; Subroutine to spawn three splash graphics in a row. Used for dolphins.
; Usage: horizontal distance between splashes in A, see $0284BC for additioanl adresses ($00/$02).
; Number of splash tiles.
; Draw the splash.
; Increase X offset.
; Repeat for any addiitonal tiles.
; Scratch RAM usage:
; $00 - Initial timer for the water splash (#$00 = full; #$12 = small)
; $01 - Number of splashes to spawn (dolphins only)
; $02 - X position offset from the sprite.
; $03 - Distance between splashes (dolphins only)
; Routine to display a small water splash. Used for fish when they're flopping.
; Routine to display a water splash at a sprite's position.
; If not the horizontal dolphin, spawn a single splash.
; Return if the dolphin is moving downwards (don't splash on entry into the water)
; Spawn three splashes 10 pixels apart.
; The actual splash routine. JSL to spawn one; initial timer in $00, X offset in $02.
; Don't draw if offscreen.
; Find an empty minor extended sprite slot, and return if none exist.
; Set Y position, offset slightly downwards.
; Set X position, offset with $02.
; Minor extended sprite number to spawn (water splash).
; Set initial timer.
; X speeds to randomly pick from for the lava particle.
; Y speeds to randomly pick from for the lava particle.
; Initial timers to randomly pick from for the lava particle.
; Scratch RAM usage:
; $00 - Number of flames to spawn, minus 1.
; Subroutine to display a lava splash.
; (pointless?)
; Return if vertically offscreen.
; Number of flames to spawn, minus 1.
; Find an empty extended sprite slot, and return if none exist.
; Spawn a lava particle.
; Extended sprite number (lava splash).
; Set Y position at the sprite.
; Set X position at the sprite, offset slightly right.
; Give a random X and Y speed.
; Give a random initial timer.
; Repeat for all particles.
; Subroutine for the sparkles from star power.
; Y = maximum vertical offset for the sparkle from Mario.
; X = constant vertical offset for the sparkle from Mario.
; $00 = Y position to spawn the sparkle at.
; $02 = X position to spawn the sparkle at.
; Find an empty minor extended sprite slot. Return if none found.
; Minor extended sprite to spawn (sparkle).
; Clear Y speed?
; Set Y position.
; Set X position.
; Number of frames to keep the sprite active for.
; Routine to spawn a lava particle, for the Podoboo.
; Return if offscreen.
; Find an empty minor extended sprite slot.
; Return if none found.
; Minor extended sprite number.
; Initial Y speed.
; Set X position to a random position on the sprite.
; Set Y position to a random position on the sprite.
; Number of frames the particle exists.
; Routine (JSL) to spawn a throwblock.
; Return if no empty slots are open.
; Spawn in status 0B (carried).
; Spawn at Mario's position.
; Note: the "LDA $95,X" is likely Nintendo's mistake.
; It can cause some bugs with the throwblock on spawn,
; but generally the code to handle holding items fixes this.
; Sprite to spawn (53).
; Throwblock initial stun timer.
; Show picking up pose, and mark as carrying an item.
; Routine (JSL) to create the shattered block effect at the position in $98-$9B.
; Usage: time to keep minor extended sprites active in A. If 0, keep active until offscreen.
; 0 makes it appears as brown particles (e.g. turnblock), non-zero makes them flash (e.g. throwblock)
; Find four empty minor extended sprite slot.
; If one can't be found, overwrite a slot.
; Shatter SFX
; Spawn a piece of brick.
; Set spawn X position.
; Set spawn Y position.
; Set X/Y speed.
; Set amount of time to exist.
; Repeat for all the particles.
; Routine (JSL) to handle Yoshi's earthquake ability.
; Return if Mario is landing after bouncing off an enemy.
; Process interaction with blocks.
; Spawn an earthquake sprite.
; Set bounce interaction center to Yoshi.
; Likely a typo at $0286D6; should be stored to $16D5.
; Rarely noticeable though.
; Spawn the smoke.
; Subroutine to spawn a quake sprite for a block.
; Find an empty quake sprite slot. If none exist, use slot 0.
; Spawn it at the block's position.
; If on Layer 2, offset from Layer 2's position.
; Spawn a block quake sprite for 6 frames.
; Bounce sprite Y speeds.
; Bounce sprite X speeds.
; Y offsets for each of the shattered block particles.
; X offsets for each of the shattered block particles.
; Y speeds to give each shattered block pafticle.
; X speeds to give each shattered block particle.
; Scratch RAM setup:
; $04 - Bounce sprite number, -1. #$07 will break the block like a turnblock.
; #$10 and #$11 are special values for the yellow and green ! blocks respectively.
; $05 - Sprite to spawn from the block (index to $0288A3)
; $06 - Direction to bounce. 0 = up, 1 = right, 2 = left, 3 = down
; $07 - Restore tile after the bounce block finishes, as the tile in $9C to spawn.
; Subroutine for spawning sprites from blocks, along with their bounce sprites.
; Branch if not a turnblock being broken.
; Routine to break a turnblock.
; Add score for breaking the block.
; Number of points awarded for breaking a turnblock, divided by 10.
; Y speed given after breaking a turnblock.
; Shatter the block.
; Spawn a quake sprite for interaction with nearby sprites.
; Turn into a blank tile.
; Bounce sprite YXPPCCCT table, in the order of $1699.
; Last two are for yellow and green ! blocks respectively.
; Not a breakable turnblock; spawn a bounce sprite and item.
; Search for an empty bounce sprite slot, and branch if one is found.
; If one can't be found, overwrite an existing slot.
; If the block being overwritten is a turnblock, reset that block's tile.
; Spawn the bounce sprite.
; If spawning block #$10/#$11 (yellow/green ! blocks),
; change it to a normal turnblock bounce sprite but with different YXPPCCCT.
; If hitting an ON/OFF switch, place a sound effect.
; SFX for hitting an On/Off switch.
; Set YXPPCCCT for the bounce block.
; Set the bounce sprite ID.
; Set in init state.
; Set spawn position at the block.
; Set X/Y speed of the bounce sprite.
; Set layer and direction of movement.
; Set restore tile.
; Number of frames the bounce sprite lasts.
; If spawning a spinning turnblock, set its timer.
; Spawn a quake sprite for interaction with nearby sprites.
; Spawn an item from the block.
; Return if no item is set to spawn.
; [useless]
; Branch if not spawning items 06 or 07 (coin).
; Initialize multiple-coin-block timer if applicable.
; Spawn a coin sprite.
; Sprites that spawn from Yoshi eggs in blocks. With Yoshi, without Yoshi.
; Sprites to spawn from various blocks and sprites.
; See the ROM map for details: http://www.smwcentral.net/?p=nmap&m=smwrom#02887D
; Sprites to spawn from various blocks and sprites when Yoshi is present.
; Identical to the original table, though, making it somewhat redundant.
; Initial status of the sprites spawned by blocks.
; Sprites to spawn from the key/wings/balloon/shell block.
; Note that the shell isn't included, because it's actually an invalid value from the next table.
; Sprite statuses to spawn the sprites from the key/wings/balloon/shell block.
; Note that the shell isn't included, because it receives an invalid sprite status.
; Spawning an actual sprite from a block.
; This part seems to be useless...?
; If spawning:
; A key (directly, not from key/wings/balloon/shell block)
; A vine in any sprite memory setting besides 0
; A Yoshi egg
; Then find an empty sprite slot, using the standard sprite memory limits.
; Return if none can be found.
; Otherwise, start from slot #$0B and look down.
; Routine to spawn a sprite from a block.
; Find an empty sprite slot, starting at slot 0B.
; (regardless of sprite memory limits)
; If no empty slot exists, overwrite either slot 0A or 0B.
; Set sprite status.
; If there is a Yoshi in the level, switch to the second table of sprites.
; Set sprite ID to spawn.
; SFX to use for items rising out of blocks.
; 02 for most blocks, 03 if spawning vine/key.
; Initialize the sprite.
; Just spawn a coin if the directional coins have already been spawned.
; Directional coin sprite spawning.
; SFX for the directional coins music.
; Set flag for spawning the directional coins.
; Spawning a sprite besides the directional coins.
; Spawn at the block's position.
; If the block is on Layer 2, offset the spawn position from that layer.
; Branch if not spawning a P-balloon (for key/wings/balloon/shell).
; Change to the correct sprite for the block's X position.
; If spawning a P-balloon, set it to face right and return.
; If spawning Yoshi wings, branch down to set $C2 and return.
; If spawning a key/shell, branch down to set a Y speed like other items from blocks.
; Not key/wings/balloon/shell.
; Branch if spawning a shell (directly, not from key/wings/balloon/shell).
; Branch if spawning a P-switch.
; Branch if not spawning a Yoshi egg.
; Search for a living Yoshi, and set the egg to
; hatch the corresponding sprite (Yoshi or 1up).
; Set Y speed for the spawned sprite.
; Yoshi Wings spawned; set sprite 7E to be Yoshi Wings.
; Direct shell spawned; set stun timer for a Koopa inside and give Y speed as normal.
; Set stun timer.
; Initial Y speed to give P-switches/Yoshis/shells/keys spawned from blocks.
; Other sprites; set stun timer and give Y speed as normal.
; Set stun timer.
; Initial Y speed to give sprites other than P-switches/Yoshis/shells/keys from blocks.
; Set timer to disable contact with Mario briefly.
; Set timer to disable block interaction briefly for carryable sprites.
; P-switch spawned; set type based on X position and give Y speed as normal.
; Set switch type and palette
; based on X position.
; Generate smoke.
; Set Y speed for the spawned sprite.
; P-switch colors spawned by tile 11D.
; Routine (JSL) to spawn smoke at a block's position.
; Find an empty smoke sprite slot, or overwrite slot 0 if none exist.
; Set to spawn a puff of smoke.
; Spawn at the block's position.
; Set timer for the smoke.
; Subroutine for spawning a coin sprite from blocks.
; Find an empty coin sprite slot, or overwrite one if none found.
; Give Mario a coin.
; Mark the sprite slot as used.
; Spawn above the block.
; Set layer.
; Initial Y speed for the coinblock coin.
; Frames between spawning sparkles, as star power runs out (first byte = about to run out).
; Routine to handle various other sprite types, as well as loading sprites.
; Branch if not giving a 1up
; or waiting to give a second one.
; Giving a 1-up.
; Frames between giving 1ups when more than one is collected.
; SFX for gaining a 1up.
; Increase life counter.
; Not giving a 1up.
; Handle sparkles from star power.
; Handle minor extended sprites.
; Handle bounce, quake, and smoke sprites.
; Handle score sprites.
; Handle extended sprites.
; Handle spinning coin sprites from blocks.
; Handle shooters.
; Handle generators.
; Handle capespin interaction.
; Handle loading sprites into the level.
; Handle sprites that respawn (e.g. Lakitu).
; Only respawn the sprite if:
; On an even frame
; Game isn't frozen
; Actually time to respawn
; There is an empty sprite slot
; Store the sprite number and state.
; Set spawn X position to the left of the screen.
; Set spawn Y position at the specified location.
; Routine to handle minor extended sprites.
; Run the MAIN routine for all of the non-empty extended sprite slots.
; OAM indices for most minor extended sprites.
; Tiles for the broken block bits.
; YXPPCCCT for the broken block bits.
; Run the minor extended sprite's MAIN routine.
; Minor extended sprite pointers.
; 0 - Unused
; 1 - Piece of brick
; 2 - Small star (from spinjump)
; 3 - Cracked shell (egg)
; 4 - Podoboo flame
; 5 - Small blue sparkle (from glitter)
; 6 - Rip van Fish's Z
; 7 - Water splash
; 8 - Unused note sprite (right)
; 9 - Unused note sprite (left)
; A - Boo stream tile
; B - Unused Yoshi smoke
; Unused smoke spawn routine. Would be used to spawn small clouds when riding Yoshi.
; [change to JSR $8BB9 to reenable]
; Create two minor extended sprites.
; Find an empty minor extended sprite slot.
; Store the minor extended sprite type (0B - Yoshi smoke).
; Start with no timer.
; Set Y position under Yoshi.
; Set X speed.
; Set X position offset from Mario.
; Initial X speeds for the unused Yoshi smoke sprites.
; X offset (lo) from Mario for the unused Yoshi smoke sprites.
; X offset (hi) from Mario for the unused Yoshi smoke sprites.
; Unused Yoshi smoke MAIN. If it has no timer, it's an invisible 'spawner' particle.
; Branch if it has a timer set (it's an actual particle, not the main one).
; Erase the sprite and return if the sprite's X speed is 0.
; Decelerate the sprite.
; Update X position.
; Return if not a frame to spawn a smoke particle.
; Find an empty minor extended sprite slot, and return if none found.
; Store extended sprite number (0B - Yoshi smoke).
; Store Y speed.
; Set at the same position as this sprite.
; Set an evaporation timer.
; The Yoshi smoke has a timer set.
; Branch to draw GFX if not yet time to erase.
; Erase the extended sprite.
; Tile numbers for the unused Yoshi smoke.
; Unused Yoshi smoke GFX routine (only used when it has a timer set).
; $00 = X position onscreen.
; Return if horizontally offscreen.
; $01 = Y position onscreen.
; Return if vertically offscreen.
; Store X/Y position.
; Store tile number.
; Store YXPPCCCT.
; Store size as 8x8.
; Tile numbers for the Boo Stream minor extended sprite, indexed by its sprite slot.
; Boo Stream extended sprite misc RAM:
; $182C - Horizontal direction the sprite is facing. (positive = right, negative = left)
; $1850 - Lifespan timer.
; Boo Stream minor extended sprite MAIN.
; Branch to just draw graphics if game frozen.
; Get clipping data for the sprite.
; Height/width of the Boo stream tile's interaction area.
; If in contact with Mario, hurt him.
; Erase the sprite if time to do so.
; Boo stream extended sprite GFX routine.
; Get X position onscreen.
; Return if horizontally offscreen.
; Store X position.
; Store Y position onscreen.
; Erase if vertically offscreen.
; Store tile number.
; Store YXPPCCCT, and X flip if applicable.
; Store size as 16x16.
; Water splash extended sprite MAIN
; If the offscreen horizontally,
; or the sprite's timer runs out,
; erase the sprite.
; Not despawning yet.
; Branch if it isn't time for the splash to shake yet.
; Sink the splash downwards 1 pixel every 2 frames.
; Get an X offset for shaking the splash back and forth as it fades.
; Store X position onscreen.
; Erase if horizontally offscreen.
; Store Y position onscreen.
; Erase if vertically offscreen.
; Store tile number.
; Store YXPPCCCT.
; Set size as 16x16.
; Increase timer if game not frozen.
; Tile numbers for the Rip Van Fish's Z.
; Rip Van Fish's Z misc RAM:
; $1850 - Timer for the sprite's lifespan; instead of erasing at #$00, however, it erases at #$14. Is set to #$7F on spawn.
; Rip Van Fish's Z MAIN, unused note sprite MAIN
; Branch if game frozen.
; Handle the timer.
; Handle X speed, creating a "wave" motion.
; Update X position.
; If extended sprite 09 (unused note sprite, left), invert the X speed of the sprite first.
; Move upwards one pixel every 4 frames.
; (high byte isn't handled...?)
; Store X position to OAM, and erase if horizontally offscreen.
; Store Y position to OAM, and erase if vertically offscreen.
; Store YXPPCCCT to OAM.
; Erase if the frame counter reaches #$14.
; Tile to use for the two unused note sprites.
; Get tile number, animating the normal Rip Van Fish's Z.
; Set size as 8x8.
; Subroutine to erase a minor extended sprite.
; Unused YXPPCCCT values...?
; Were likely used for the shards instead of the high bits of $1850, but not anymore.
; Egg shard misc RAM:
; $1850 - Lower 6 bits used as a timer to erase the sprite. Upper two bits used as X/Y flip for the sprite.
; Cracked Yoshi egg shell MAIN.
; Branch if time to erase the sprite.
; Update X/Y position.
; Accelerate downwards.
; Branch to erase the sprite if vertically offscreen.
; Else, set OAM Y position.
; Branch to erase the sprite if horizontally offscreen.
; Else, set OAM X position.
; Tile number for the shard.
; Set YXPPCCCT for the shard.
; Set size in OAM as 8x8.
; Tile numbers for the small star extended sprite, indexed by which sprite was actually spawned:
; Spinjump stars
; Glitter sparkles
; Small star misc RAM:
; $1850 - Lifespan timer.
; Small star MAIN / Sparkle MAIN (for glitter/spinjump)
; Erase the sprite if its timer runs out.
; If the game isn't frozen, decrement the sprite's lifespan timer.
; Store X position to OAM, and erase if horizontally offscreen.
; Store Y position to OAM, and erase if vertically offscreen.
; Store tile number to OAM.
; Store YXPPCCCT to OAM.
; Set size in OAM as 8x8.
; Tile number for the Podoboo's flame trail.
; Podoboo flame trail misc RAM:
; $1850 - Lifespan timer.
; Podoboo flame trail MAIN
; Erase the sprite if horizontally offscreen.
; Erase the sprite if its timer runs out.
; If the game isn't frozen, decrement the sprite's lifespan timer, update its Y position, and apply gravity.
; Store X position to OAM.
; Store Y position to OAM, and erase if vertically offscreen.
; Store tile number to OAM.
; Store YXPPCCCT to OAM.
; Store size to OAM as 8x8.
; Small subroutine to despawn a minor extended sprite.
; Minor extended brick piece MAIN
; Branch if game frozen.
; Every 4 frames, update the sprite's X position.
; Update the sprite's Y position.
; Every 4 frames, increase the sprite's Y speed downwards.
; Get onscreen Y position.
; If the sprite goes vertically offscreen:
; Don't draw, if above the screen.
; Erase, if too far offscreen.
; Get onscreen X position.
; If the sprite goes horizontally offscreen, erase it.
; Set OAM X position.
; Set OAM Y position,
; If below the screen, though, erase the sprite.
; Set tile number.
; Set YXPPCCCT.
; If the minor extended sprite's timer is set,
; cycle its palette like a rainbow (for throwblock's shatter).
; Set size as 8x8.
; Routine to handle bounce, quake, and smoke sprites.
; Handle the multiple coin block timer.
; Run bounce sprites.
; Run quake sprites.
; Run smoke sprites.
; Subroutine to run MAIN code for bounce sprites.
; Return if slot is empty.
; Decrease the sprite's lifespan timer if the game isn't frozen.
; Bounce sprite MAIN pointers.
; Y speeds for the turnblock bounce sprite, indexed by the direction it's moving in.
; Turnblock bounce sprite MAIN
; Return if game frozen.
; If the block was just hit,
; spawn an invisible solid block in its place.
; Branch if currently in the 'spinning turnblock' phase.
; Branch if not time to erase the sprite.
; Center the bounce sprite on the turnblock.
; Spawn a turning turnblock.
; Turnblock's sprite isn't done yet.
; Handle movement.
; Set Y speed based on the direction the block is moving.
; Draw GFX.
; Handle the spinning turnblock's timer.
; Time to return the turnblock back to normal.
; Spawn the original tile.
; Clear the bounce sprite slot.
; Y speeds to give the bounce sprite when spawned, indexed by the direction it's moving in.
; X speeds to give the bounce sprite when spawned, indexed by the direction it's moving in.
; Y speeds to give Mario when spawning a bounce sprite, indexed by the direction it's moving in.
; X speeds to give Mario when spawning a bounce sprite, indexed by the direction it's moving in.
; Bounce block MAIN routine (excluding turnblocks)
; Draw GFX.
; Return if sprites frozen.
; Branch if not initializing.
; Mark as being done INIT.
; Run INIT routine.
; Make the block invisible.
; Set Mario's Y speed for the direction the block was hit from, if applicable.
; By default, only changes speed when bouncing upward.
; Set Mario's X speed for the direction the block was hit from, if applicable.
; By default, only changes speed when bouncing to the side.
; General bounce sprite routine; mainly handles movement.
; Update Y position.
; Update X position.
; Set bounce sprite X/Y speed based on direction.
; Branch if:
; The block was not touched from above
; Mario is not in a normal status
; Only  applies to noteblocks, which are the only block that can be touched from above.
; Attach Mario's Y position to the noteblock sprite.
; Set flag for being on a noteblock and for being on a sprite.
; Not on a noteblock.
; Return if the bounce animation isn't finished.
; Branch if the block was not touched from above.
; Y speed given when bouncing off a noteblock.
; Push Mario out of the block.
; SFX for bouncing on a noteblock.
; Branch if not a ON/OFF block.
; SFX for hitting an ON/OFF block.
; Toggle the ON/OFF switch.
; Unused?
; Create the correct "output" block at a bounce sprite's position.
; If the block is multiple coin block,
; decide whether to keep it as the original
; or turn it into a used block.
; Block to turn into after a multiple-coin block runs out.
; Create an invisible solid block at the bounce sprite's position.
; Create a block stored in A at the bounce sprite's position.
; Spawn specified block at the bounce sprite's position.
; Bounce sprite OAM slots.
; Bounce sprite tile numbers, in the order of $1699.
; Bounce block sprite GFX routine.
; Offset position from Layer 2 if set to do so.
; Return if vertically offscreen.
; Return if horizontally offscreen.
; Set Y position.
; Set X position.
; Set YXPPCCCT.
; Set tile number.
; Set size as 16x16.
; Bounce block sprite INIT. Originally meant to make coins on top of blocks get collected, but now is broken.
; Branch if the the bounce sprite is being spawned on a horizontally layer.
; Return if the block above the sprite is vertically outside the level.
; Return if the block above the sprite is horizontally outside the level.
; $05 = 16-bit pointer to the Map16 table for the block.
; (as in, one tile above the block that was hit)
; Bounce sprite is being spawned on a horizontal layer.
; Return if the block above the sprite is vertically outside the level.
; Return if the block above the sprite is horizontally outside the level.
; $05 = 16-bit pointer to the Map16 table for the block above the bounce sprite.
; (as in, one tile above the block that was hit)
; Done doing the horizontal-vertical level busywork.
; Finish getting the 24-bit pointer to the tile in $05.
; Return if the tile above the bounce sprite isn't tile 02B (coin).
; Turn the coin into an invisible solid block
; and spawn a spinning coin sprite / give Mario a coin.
; (it was probably intended to be non-solid, but Nintendo forgot about it)
; Routine to spawn a spinning coin sprite when a bounce sprite is spawned under a coin.
; Find an empty slot to stick the coin in, and use slot 0 if none available.
; Spawn a spinning coin.
; Give Mario a coin.
; Set at the bounce sprite's position.
; Initial Y speed for the spawned coin.
; X speeds to give sprites hit/killed by quake sprites, capespins, cape smashes, or net punches.
; Clear quake sprite slot.
; Quake sprite interaction routine.
; If the quake sprite slot isn't used, return.
; If the quake timer runs out, delete the sprite.
; Return if not yet time to actually run interaction.
; Sprite interaction routine below is also used for net/capespin interaction, with $0E = #$01.
    BEQ CODE_0293F7                           ; Loop to look for sprites to interact with.
    CMP.B #$08
    BCC CODE_0293F7
    LDA.W SpriteTweakerC,X
    AND.B #$20                                ; Skip slot if the sprite:
    ORA.W SpriteOnYoshiTongue,X               ; Is being carried
    ORA.W SpriteMisc154C,X                    ; Is dead
    ORA.W SpriteMisc1FE2,X                    ; Can't be hit by a cape / quake sprite ($166E)
    BNE CODE_0293F7                           ; Is on Yoshi's tongue
    LDA.W SpriteBehindScene,X                 ; Has contact with Mario temporarily disabled
    PHY                                       ; Has contact with the cape/quake temporarily disabled
    LDY.B PlayerIsClimbing                    ; Is on the opposite side of a fence (different layer from Mario)
    BEQ +
    EOR.B #$01
  + PLY
    EOR.W PlayerBehindNet
    BNE CODE_0293F7
    JSL GetSpriteClippingA
    LDA.B _E
    BEQ CODE_0293EB
    JSR CODE_029696                           ; Get appropriate interaction values for the quake/capespin/net punch.
    BRA +                                     ; ($0E is 0 for quake sprites, 1 for capespin/net punch).

CODE_0293EB:
    JSR CODE_029663
  + JSL CheckForContact
    BCC CODE_0293F7                           ; If in contact with the sprite, hit it.
    JSR CODE_029404
CODE_0293F7:
    LDY.W MinorSpriteProcIndex
    DEX                                       ; Loop through the remaining sprites, and return if done.
    BMI +
    JMP CODE_0293B0

  + LDX.W MinorSpriteProcIndex
    RTS

CODE_029404:
; Subroutine to "hit" a sprite in contact with a quake/capespin/net punch. Also used for cape smash ($0E = #$35).
    LDA.B #$08                                ; Disable contact with Mario briefly.
    STA.W SpriteMisc154C,X
    LDA.B SpriteNumber,X
    CMP.B #$81                                ; Branch if not the roulette sprite.
    BNE CODE_029427
    LDA.B SpriteTableC2,X                     ; Return if the roulette sprite isn't currently in the box.
    BEQ +
    STZ.B SpriteTableC2,X
    LDA.B #$C0                                ; Y speed to give the roulette sprite when rising out of a block.
    STA.B SpriteYSpeed,X
    LDA.B #$10                                ; Set the timer for the rising animation from the block.
    STA.W SpriteMisc1540,X
    STZ.W SpriteMisc157C,X
    LDA.B #$20                                ; Set this timer, for whatever purpose.
    STA.W SpriteMisc1558,X
  + RTS

CODE_029427:
    CMP.B #$2D                                ; Not the roulette sprite being hit.
    BEQ CODE_029448
    LDA.W SpriteTweakerD,X
    AND.B #$02
    BNE CODE_0294A2                           ; Set stun timer for the sprite to #$FF, if:
    LDA.W SpriteStatus,X                      ; Not a Baby Yoshi
    CMP.B #$08                                ; Not carryable (normal state 08)
    BEQ CODE_029443                           ; Carryable, not a Bob-omb, and $C2 is set.
    LDA.B SpriteNumber,X                      ; (i.e. it's either a shell with a Koopa inside, a Goomba, or a Buzzy Beetle)
    CMP.B #$0D
    BEQ CODE_029448                           ; Alternatively, if the sprite is invincible to quake sprites/capespins, skip way down.
    LDA.B SpriteTableC2,X                     ; (excluding Baby Yoshi, which continues below)
    BEQ CODE_029448
CODE_029443:
    LDA.B #$FF
    STA.W SpriteMisc1540,X
CODE_029448:
    STZ.W SpriteMisc1558,X                    ; Sprite isn't invincible to quake sprites/capespins.
    LDA.B _E
    CMP.B #$35                                ; Display a contact sprite, unless being killed by a cape smash.
    BEQ +
    JSL CODE_01AB6F
  + LDA.B #$00                                ; Give 100 points.
    JSL GivePoints
    LDA.B #$02                                ; \ Sprite status = Killed; Kill the sprite (note: carryable sprites are fixed later).
    STA.W SpriteStatus,X                      ; /
    LDA.B SpriteNumber,X
    CMP.B #$1E
    BNE +                                     ; If killing the Lakitu, stun sprite slot #9 for some reason (probably meant to be the cloud?).
    LDA.B #$1F
    STA.W SpriteMisc1540+9
  + LDA.W SpriteTweakerB,X
    AND.B #$80
    BNE CODE_0294A2                           ; Branch if the sprite:
    LDA.W SpriteTweakerA,X                    ; \ Branch if can't be jumped on; Falls straight down when killed, or
    AND.B #$10                                ; |; Can't be jumped on, or
    BEQ CODE_0294A2                           ; /; Dies when jumped on
    LDA.W SpriteTweakerA,X                    ; \ Branch if dies when jumped on
    AND.B #$20                                ; |
    BNE CODE_0294A2                           ; /
    LDA.B #$09                                ; \ Sprite status = Carryable; Else, sprite must be a carryable sprite, so make it carryable again.
    STA.W SpriteStatus,X                      ; /
    ASL.W SpriteOBJAttribute,X
    SEC                                       ; Flip the sprite upside down.
    ROR.W SpriteOBJAttribute,X
    LDA.W SpriteTweakerE,X
    AND.B #$40
    BEQ CODE_0294A2
    PHX
    LDA.B SpriteNumber,X                      ; If it turns into another sprite when hit, do so.
    TAX                                       ; (i.e. Koopa shells, Goombas, Buzzy Beetles)
    LDA.L SpriteToSpawn,X
    PLX
    STA.B SpriteNumber,X
    JSL LoadSpriteTables
CODE_0294A2:
; Sprites that are invincible to capespins/quake sprites come back here.
    LDA.B #$C0                                ; Y speed to give sprites hit/killed by a quake sprite (block, Yoshi stomp).
    LDY.B _E
    BEQ +
    LDA.B #$B0                                ; Y speed to give sprites hit/killed by a cape smash, capespin, or net punch.
    CPY.B #$02
    BNE +
    LDA.B #$C0                                ; Unused Y speed?
  + STA.B SpriteYSpeed,X
    JSR SubHorzPosBnk2
    LDA.W DATA_029392,Y                       ; Send the sprite flying away from Mario.
    STA.B SpriteXSpeed,X
    TYA
    EOR.B #$01                                ; And have it face that direction, too.
    STA.W SpriteMisc157C,X
    RTS

GroundPound:
; Routine to handle smashing the ground as Cape Mario.
    LDA.B #$30                                ; \ Set ground shake timer; Set timer for shaking Layer 1.
    STA.W ScreenShakeTimer                    ; /
    STZ.W GroundPoundTimer                    ; [unused]
    PHB
    PHK
    PLB
    LDX.B #$09                                ; Loop over sprites:
KillSprLoopStart:
    LDA.W SpriteStatus,X                      ; \ Skip current sprite if status < 8
    CMP.B #$08                                ; |
    BCC +                                     ; /
    LDA.W SpriteBlockedDirs,X                 ; \ Skip current sprite if not on ground; Skip to next slot if:
    AND.B #$04                                ; |; Sprite is dying
    BEQ +                                     ; /; Sprite isn't on the ground
    LDA.W SpriteTweakerC,X                    ; \ Skip current sprite if...; Can't be killed by cape ($166E)
    AND.B #$20                                ; | ...can't be killed by cape...; On Yoshi's tongue
    ORA.W SpriteOnYoshiTongue,X               ; | ...or sprite being eaten...; Player contact is disabled
    ORA.W SpriteMisc154C,X                    ; | ...or interaction disabled
    BNE +                                     ; /
    LDA.B #$35
    STA.B _E                                  ; Hit all onscreen sprites.
    JSR CODE_029404
  + DEX
    BPL KillSprLoopStart
    PLB
    RTL

CODE_0294F5:
; Routine to handle capespin interaction.
    LDA.W CapeInteracts                       ; If the capespin isn't interacting with sprites, return.
    BEQ Return02950A
    STA.B _E
    LDA.B TrueFrame
    LSR A                                     ; Only process sprite interaction every odd frame.
    BCC +
    JSR CODE_0293AE                           ; Process sprite interaction with the capespin.
    JSR CODE_029631                           ; Process extended sprite interaction with the capespin.
  + JSR CODE_02950B                           ; Process object interaction.
Return02950A:
    RTS

CODE_02950B:
; Subroutine to handle capespin interaction with objects.
    STZ.B _F                                  ; Process capsepin interaction with Layer 1.
    JSR CODE_029540
    LDA.B ScreenMode                          ; Return if Layer 2 doesn't have collision.
    BPL +
    INC.B _F
    LDA.W CapeInteractionXPos
    CLC
    ADC.B Layer23XRelPos
    STA.W CapeInteractionXPos
    LDA.W CapeInteractionXPos+1
    ADC.B Layer23XRelPos+1
    STA.W CapeInteractionXPos+1               ; Add Layer 2/3 relative X positions to the capespin interaction.
    LDA.W CapeInteractionYPos
    CLC
    ADC.B Layer23YRelPos
    STA.W CapeInteractionYPos
    LDA.W CapeInteractionYPos+1
    ADC.B Layer23YRelPos+1
    STA.W CapeInteractionYPos+1
    JSR CODE_029540                           ; Process capespin interaction with Layer 2.
  + RTS


DATA_02953C:
    db $08,$08

DATA_02953E:
    db $02,$0E

CODE_029540:
; Y offsets for capespin interaction, indexed by whether it is an odd or even frame.
; X offsets for capespin interaction, indexed by whether it is an odd or even frame.
    LDA.B TrueFrame                           ; Routine to actually process capespin interaction with the layer in $0F.
    AND.B #$01
    TAY
    LDA.B _F
    INC A                                     ; Branch if the layer is horizontal (not vertical).
    AND.B ScreenMode
    BEQ CODE_0295AE
    LDA.W CapeInteractionYPos
    CLC
    ADC.W DATA_02953C,Y
    AND.B #$F0
    STA.B _0
    STA.B TouchBlockYPos                      ; Get interaction Y position, offset down half a block.
    LDA.W CapeInteractionYPos+1               ; Return if outside the level.
    ADC.B #$00
    CMP.B LevelScrLength
    BCS Return0295AD
    STA.B _3
    STA.B TouchBlockYPos+1
    LDA.W CapeInteractionXPos
    CLC
    ADC.W DATA_02953E,Y
    STA.B _1
    STA.B TouchBlockXPos                      ; Get interaction X position, offset slightly to the side of Mario.
    LDA.W CapeInteractionXPos+1               ; Return if outside the level.
    ADC.B #$00
    CMP.B #$02
    BCS Return0295AD
    STA.B _2
    STA.B TouchBlockXPos+1
    LDA.B _1
    LSR A
    LSR A
    LSR A                                     ; Get position as an XY-formatted value.
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
    STA.B _5                                  ; Get lower two bytes of the Map16 pointer.
    LDA.L DATA_00BABC,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BACA,X
  + ADC.B _2
    STA.B _6
    BRA CODE_02960D                           ; Continue to shared portion of the routine.

Return0295AD:
    RTS

CODE_0295AE:
    LDA.W CapeInteractionYPos                 ; Processing capespin interaction for a horizontal layer.
    CLC
    ADC.W DATA_02953C,Y
    AND.B #$F0
    STA.B _0
    STA.B TouchBlockYPos                      ; Get interaction Y position, offset down half a block.
    LDA.W CapeInteractionYPos+1               ; Return if outside the level.
    ADC.B #$00
    CMP.B #$02
    BCS Return0295AD
    STA.B _2
    STA.B TouchBlockYPos+1
    LDA.W CapeInteractionXPos
    CLC
    ADC.W DATA_02953E,Y
    STA.B _1
    STA.B TouchBlockXPos                      ; Get interaction X position, offset slightly to the side of Mario.
    LDA.W CapeInteractionXPos+1               ; Return if outside the level.
    ADC.B #$00
    CMP.B LevelScrLength
    BCS Return0295AD
    STA.B _3
    STA.B TouchBlockXPos+1
    LDA.B _1
    LSR A
    LSR A
    LSR A                                     ; Get position as an XY-formatted value.
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _3
    LDA.L DATA_00BA60,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA70,X
  + CLC
    ADC.B _0                                  ; Get lower two bytes of the Map16 pointer.
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
    LDA.B [_5]                                ; Get the low byte of the tile number in $1693, and the high byte in A.
    STA.W Map16TileNumber
    INC.B _7
    LDA.B [_5]
    JSL CODE_00F545                           ; Get proper "acts like" settings for the block being hit.
    CMP.B #$00                                ; If it's on page 0, return.
    BEQ +
    LDA.B _F                                  ; Store the current layer being processed.
    STA.W LayerProcessing
    LDA.W Map16TileNumber
    LDY.B #$00                                ; Process the block's interaction.
    JSL CODE_00F160
  + RTS

CODE_029631:
    LDX.B #$07                                ; Routine to process cape interaction with extended sprites.
CODE_029633:
    STX.W CurSpriteProcess
    LDA.W ExtSpriteNumber,X
    CMP.B #$02                                ; Don't interact with the puff of smoke or empty slots.
    BCC +
    JSR CODE_02A519
    JSR CODE_029696                           ; Move to next slot if Mario isn't touching it.
    JSL CheckForContact
    BCC +
    LDA.W ExtSpriteNumber,X
    CMP.B #$12                                ; Don't interact with the water bubble.
    BEQ +
    JSR CODE_02A4DE                           ; Turn into a smoke puff.
  + DEX                                       ; Loop for all the extended sprites.
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
; Quake sprite X displacements (low).
; Quake sprite X displacements (high).
; Quake sprite widths.
; Quake sprite Y displacements (low).
; Quake sprite Y displacements (high).
; Quake sprite heights.
; Scratch RAM returns:
; $00 - Clipping X displacement lo
; $01 - Clipping Y displacement lo
; $02 - Clipping width
; $03 - Clipping height
; $08 - Clipping X displacement hi
; $09 - Clipping Y displacement hi
    PHX                                       ; Routine to get interaction values for quake sprites. Takes the place of "sprite B".
    LDA.W QuakeSpriteNumber,Y
    TAX
    LDA.W QuakeSpriteXPosLow,Y
    CLC
    ADC.W Return029656,X
    STA.B _0                                  ; Get X displacement.
    LDA.W QuakeSpriteXPosHigh,Y
    ADC.W DATA_029658,X
    STA.B _8
    LDA.W DATA_02965A,X                       ; Get width.
    STA.B _2
    LDA.W QuakeSpriteYPosLow,Y
    CLC
    ADC.W DATA_02965C,X
    STA.B _1                                  ; Get Y displacement.
    LDA.W QuakeSpriteYPosHigh,Y
    ADC.W DATA_02965E,X
    STA.B _9
    LDA.W DATA_029660,X                       ; Get height.
    STA.B _3
    PLX
    RTS

CODE_029696:
    LDA.W CapeInteractionXPos                 ; Routine to get interaction values for Mario's cape and net punches. Takes the place of "sprite B".
    SEC
    SBC.B #$02
    STA.B _0                                  ; Get X displacement.
    LDA.W CapeInteractionXPos+1
    SBC.B #$00
    STA.B _8
    LDA.B #$14                                ; Width for Mario's capesin and net punch.
    STA.B _2
    LDA.W CapeInteractionYPos
    STA.B _1                                  ; Get Y displacement.
    LDA.W CapeInteractionYPos+1
    STA.B _9
    LDA.B #$10                                ; Height for Mario's capesin and net punch.
    STA.B _3
    RTS


DATA_0296B8:
    db $20,$24,$28,$2C

DATA_0296BC:
    db $90,$94,$98,$9C

CODE_0296C0:
; OAM indices for smoke sprites, in most normal levels.
; OAM indices for smoke sprites, in certain Mode 7 levels (usually Reznor).
    LDA.W SmokeSpriteNumber,X                 ; Subroutine to run smoke sprite MAIN code.
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
; Smoke sprite pointers.
; 00 - None
; 01 - Smoke puff
; 02 - Contact spark
; 03 - Friction smoke
; 04 - Unused
    RTS                                       ; 05 - Glitter


DATA_0296D8:
    db $66,$66,$64,$62,$60,$62,$60

CODE_0296DF:
; Tile numbers for the smoke puff sprite.
    STZ.W SmokeSpriteNumber,X                 ; Small subroutine to erase a smoke sprite.
    RTS

CODE_0296E3:
; Smoke puff MAIN
    LDA.W SmokeSpriteTimer,X                  ; Erase the sprite if its timer runs out.
    BEQ CODE_0296DF
    LDA.W SmokeSpriteNumber,X
    BMI CODE_0296F1
    LDA.B SpriteLock                          ; If the high bit is set, continue to animate the sprite even when the game is frozen.
    BNE +                                     ; Used for the cape powerup animation.
CODE_0296F1:
    DEC.W SmokeSpriteTimer,X
  + LDA.B SpriteNumber+7
    CMP.B #$A9
    BEQ CODE_02974A                           ; Branch if Reznor isn't spawned in slot B,
    LDA.W IRQNMICommand                       ; or the player isn't in Reznor's room?
    AND.B #$40
    BEQ CODE_02974A
    LDY.W DATA_0296BC,X
    LDA.W SmokeSpriteXPos,X
    SEC
    SBC.B Layer1XPos                          ; Store X position to OAM.
    CMP.B #$F4                                ; Erase if horizontally offscreen.
    BCS CODE_0296DF
    STA.W OAMTileXPos+$100,Y
    LDA.W SmokeSpriteYPos,X
    SEC
    SBC.B Layer1YPos                          ; Store Y position to OAM.
    CMP.B #$E0                                ; Erase if vertically offscreen.
    BCS CODE_0296DF
    STA.W OAMTileYPos+$100,Y
    LDA.W SmokeSpriteTimer,X
    CMP.B #$08
    LDA.B #$00
    BCS +
    ASL A
    ASL A                                     ; Store YXPPCCCT to OAM.
    ASL A                                     ; X-flip the sprite every 4 frames.
    ASL A
    AND.B #$40
  + ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDA.W SmokeSpriteTimer,X
    PHY
    LSR A
    LSR A                                     ; Store tile number to OAM.
    TAY
    LDA.W DATA_0296D8,Y
    PLY
    STA.W OAMTileNo+$100,Y
    TYA
    LSR A
    LSR A                                     ; Store size to OAM as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    RTS

CODE_02974A:
    LDY.W DATA_0296B8,X                       ; Smoke isn't being spawned in Reznor's room.
    LDA.W SmokeSpriteXPos,X
    SEC
    SBC.B Layer1XPos                          ; Store X position to OAM.
    CMP.B #$F4                                ; Erase if horizontally offscreen.
    BCS CODE_029793
    STA.W OAMTileXPos,Y
    LDA.W SmokeSpriteYPos,X
    SEC
    SBC.B Layer1YPos                          ; Store Y position to OAM.
    CMP.B #$E0                                ; Erase if vertically offscreen.
    BCS CODE_029793
    STA.W OAMTileYPos,Y
    LDA.W SmokeSpriteTimer,X
    CMP.B #$08
    LDA.B #$00
    BCS +
    ASL A
    ASL A                                     ; Store YXPPCCCT to OAM.
    ASL A                                     ; X-flip the sprite every 4 frames.
    ASL A
    AND.B #$40
  + ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    LDA.W SmokeSpriteTimer,X
    PHY
    LSR A
    LSR A                                     ; Store tile number to OAM.
    TAY
    LDA.W DATA_0296D8,Y
    PLY
    STA.W OAMTileNo,Y
    TYA
    LSR A
    LSR A                                     ; Store size to OAM as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    RTS

CODE_029793:
    STZ.W SmokeSpriteNumber,X                 ; Small subroutine to erase a smoke sprite.
    RTS

CODE_029797:
; Contact spark MAIN
    LDA.W SmokeSpriteTimer,X                  ; Erase the sprite if its timer runs out.
    BEQ CODE_029793
    LDY.B SpriteLock
    BNE +                                     ; Handle the smoke timer.
    DEC.W SmokeSpriteTimer,X
  + BIT.W IRQNMICommand
    BVC +
    LDA.W IRQNMICommand                       ; Jump down if in Reznor/Morton/Roy's rooms.
    CMP.B #$C1
    BEQ +
    JMP CODE_029838

; Not in Reznor/Morton/Roy's room.
  + LDY.B #$F0                                ; OAM index (from $0200) for the contact sprite in normal levels.
    LDA.W SmokeSpriteXPos,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$F0
    BCS CODE_029793                           ; Store X positions to OAM.
    STA.W OAMTileXPos,Y                       ; Erase if horizontally offscreen.
    STA.W OAMTileXPos+8,Y
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+4,Y
    STA.W OAMTileXPos+$0C,Y
    LDA.W SmokeSpriteYPos,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos,Y
    STA.W OAMTileYPos+4,Y                     ; Store Y position to OAM.
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
    AND.B #$40                                ; Store YXPPCCCT to OAM.
    ORA.B SpriteProperties                    ; X flip every 2 frames.
    STA.W OAMTileAttr,Y
    STA.W OAMTileAttr+4,Y
    EOR.B #$C0
    STA.W OAMTileAttr+8,Y
    STA.W OAMTileAttr+$0C,Y
    LDA.W SmokeSpriteTimer,X
    AND.B #$02                                ; Handle animation for the tile.
    BNE CODE_029815
    LDA.B #$7C                                ; Tile A to use for the contact sprite.
    STA.W OAMTileNo,Y
    STA.W OAMTileNo+$0C,Y
    LDA.B #$7D                                ; Tile B to use for the contact sprite.
    STA.W OAMTileNo+4,Y
    STA.W OAMTileNo+8,Y
    BRA +

CODE_029815:
    LDA.B #$7D                                ; Tile B to use for the contact sprite.
    STA.W OAMTileNo,Y
    STA.W OAMTileNo+$0C,Y
    LDA.B #$7C                                ; Tile A to use for the contact sprite.
    STA.W OAMTileNo+4,Y
    STA.W OAMTileNo+8,Y
  + TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00                                ; Set size for all four tiles as 8x8.
    STA.W OAMTileSize,Y
    STA.W OAMTileSize+1,Y
    STA.W OAMTileSize+2,Y
    STA.W OAMTileSize+3,Y
    RTS

CODE_029838:
; Contact sprite in Reznor/Morton/Roy's rooms (use $0300 range instead of $0200).
    LDY.B #$90                                ; OAM index (from $0300) for the contact sprite in Reznor/Morton'Roy's rooms.
    LDA.W SmokeSpriteXPos,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$F0
    BCS CODE_0298BE
    STA.W OAMTileXPos+$100,Y                  ; Store X positions to OAM.
    STA.W OAMTileXPos+$108,Y                  ; Erase if horizontally offscreen.
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$104,Y
    STA.W OAMTileXPos+$10C,Y
    LDA.W SmokeSpriteYPos,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y                  ; Store Y position to OAM.
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
    AND.B #$40                                ; Store YXPPCCCT to OAM.
    ORA.B SpriteProperties                    ; X flip every 2 frames.
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    EOR.B #$C0
    STA.W OAMTileAttr+$108,Y
    STA.W OAMTileAttr+$10C,Y
    LDA.W SmokeSpriteTimer,X
    AND.B #$02                                ; Handle animation for the tile.
    BNE CODE_02989B
    LDA.B #$7C                                ; Tile A to use for the contact sprite in Reznor/Morton/Roy's rooms.
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$10C,Y
    LDA.B #$7D                                ; Tile B to use for the contact sprite in Reznor/Morton/Roy's rooms.
    STA.W OAMTileNo+$104,Y
    STA.W OAMTileNo+$108,Y
    BRA +

CODE_02989B:
    LDA.B #$7D                                ; Tile B to use for the contact sprite in Reznor/Morton/Roy's rooms.
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$10C,Y
    LDA.B #$7C                                ; Tile A to use for the contact sprite in Reznor/Morton/Roy's rooms.
    STA.W OAMTileNo+$104,Y
    STA.W OAMTileNo+$108,Y
  + TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00                                ; Set size for all four tiles as 8x8.
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
    STA.W OAMTileSize+$42,Y
    STA.W OAMTileSize+$43,Y
    RTS

CODE_0298BE:
    STZ.W SmokeSpriteNumber,X                 ; Small subroutine to erase a smoke sprite.
    RTS


DATA_0298C2:
    db $04,$08,$04,$00

DATA_0298C6:
    db $FC,$04,$0C,$04

CODE_0298CA:
; X offsets for the glitter particles spawned by the glitter smoke sprite.
; Y offsets for the glitter particles spawned by the glitter smoke sprite.
; Glitter smoke sprite MAIN
    LDA.W SmokeSpriteTimer,X                  ; Erase the sprite if its timer runs out/
    BEQ CODE_0298BE
    LDY.B SpriteLock                          ; Return if game frozen.
    BNE Return029921
    DEC.W SmokeSpriteTimer,X
    AND.B #$03                                ; Return if not time to spawn a glitter particle.
    BNE Return029921
    LDY.B #$0B
CODE_0298DC:
    LDA.W MinExtSpriteNumber,Y
    BEQ CODE_0298F1
    DEY
    BPL CODE_0298DC                           ; Find an empty minor extended sprite slot to use,
    DEC.W MinExtSpriteSlotIdx                 ; or overwrite one if none found.
    BPL +
    LDA.B #$0B
    STA.W MinExtSpriteSlotIdx
  + LDY.W MinExtSpriteSlotIdx
CODE_0298F1:
    LDA.B #$02                                ; Minor extended sprite the glitter sprite spawns (glitter particle).
    STA.W MinExtSpriteNumber,Y
    LDA.W SmokeSpriteYPos,X
    STA.B _1
    LDA.W SmokeSpriteXPos,X
    STA.B _0
    LDA.W SmokeSpriteTimer,X
    LSR A
    LSR A
    AND.B #$03
    PHX                                       ; Store X position.
    TAX
    LDA.W DATA_0298C2,X
    CLC
    ADC.B _0
    STA.W MinExtSpriteXPosLow,Y
    LDA.W DATA_0298C6,X
    CLC                                       ; Store Y position.
    ADC.B _1
    STA.W MinExtSpriteYPosLow,Y
    PLX
    LDA.B #$17                                ; Timer for the glitter's animation.
    STA.W MinExtSpriteTimer,Y
Return029921:
    RTS


DATA_029922:
    db $66,$66,$64,$62,$62

CODE_029927:
; Friction smoke MAIN
    LDA.W SmokeSpriteTimer,X                  ; Branch if the sprite's timer hasn't run out yet.
    BNE CODE_029941
    BIT.W IRQNMICommand
    BVC +
    LDA.W ReznorOAMIndex                      ; Unused? This should always branch.
    BNE +                                     ; Plus the sprite is being erased anyway so it does nothing.
    LDY.W DATA_0296BC,X
    LDA.B #$F0
    STA.W OAMTileYPos+$100,Y
  + JMP CODE_029793                           ; Erase the sprite.

CODE_029941:
    LDY.B SpriteLock                          ; Not time to erase the sprite.
    BNE +
    DEC.W SmokeSpriteTimer,X                  ; Handle the smoke timer.
    AND.B #$07
    BNE +
    DEC.W SmokeSpriteYPos,X
  + LDA.B SpriteNumber+7
    CMP.B #$A9
    BEQ CODE_02996C
    LDA.W ReznorOAMIndex
    BNE CODE_02996C                           ; Get OAM index.
    LDA.W IRQNMICommand
    BPL CODE_02996C                           ; Use a different index if:
    CMP.B #$C1                                ; Reznor is not in slot 7
    BEQ CODE_029967                           ; Not in Reznor's room
    AND.B #$40                                ; In a mode 7 level
    BNE CODE_02999F
CODE_029967:
    LDY.W DATA_0296BC,X                       ; If in Morton/Roy's room, branch further down to use $0300 instead of $0200.
    BRA +

CODE_02996C:
    LDY.W DATA_0296B8,X
  + LDA.W SmokeSpriteXPos,X
    SEC                                       ; Store X position to OAM.
    SBC.B Layer1XPos
    STA.W OAMTileXPos,Y
    LDA.W SmokeSpriteYPos,X
    SEC                                       ; Store Y position to OAM.
    SBC.B Layer1YPos
    STA.W OAMTileYPos,Y
    LDA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr,Y
    LDA.W SmokeSpriteTimer,X
    LSR A
    LSR A
    TAX                                       ; Store tile number to OAM.
    %LorW_X(LDA,DATA_029922)
    LDX.W MinorSpriteProcIndex
    STA.W OAMTileNo,Y
    TYA
    LSR A
    LSR A                                     ; Set OAM size as 8x8.
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    RTS

CODE_02999F:
    LDY.W DATA_0296BC,X                       ; Friction smoke in Morton/Roy's room (use $0300 range instead of $0200).
    LDA.W SmokeSpriteXPos,X
    SEC                                       ; Store X position to OAM.
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$100,Y
    LDA.W SmokeSpriteYPos,X
    SEC                                       ; Store Y position to OAM.
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    LDA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    LDA.W SmokeSpriteTimer,X
    LSR A
    LSR A
    TAX                                       ; Store tile number to OAM.
    %LorW_X(LDA,DATA_029922)
    LDX.W MinorSpriteProcIndex
    STA.W OAMTileNo+$100,Y
    TYA
    LSR A
    LSR A                                     ; Set OAM size as 8x8.
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    RTS

CODE_0299D2:
    LDX.B #$03                                ; Routine to handle the spinning coin sprites.
CODE_0299D4:
    STX.W CurSpriteProcess
    LDA.W CoinSpriteExists,X
    BEQ +                                     ; Loop through all the slots and run the main routine for each of the used ones.
    JSR CODE_0299F1
  + DEX
    BPL CODE_0299D4
    RTS

CODE_0299E3:
; Small subroutine to erase a spinning coin sprite.
    LDA.B #$00                                ; Clear the slot.
    STA.W CoinSpriteExists,X
    RTS


DATA_0299E9:
    db $30,$38,$40,$48,$EC,$EA,$E8,$EC

CODE_0299F1:
; OAM indices for the spinning coin sprites.
; Spinning coin from blocks MAIN
    LDA.B SpriteLock                          ; Branch if the game is frozen.
    BNE +
    JSR CODE_02B58E                           ; Update Y position.
    LDA.W CoinSpriteYSpeed,X
    CLC                                       ; Decelerate Y speed.
    ADC.B #$03
    STA.W CoinSpriteYSpeed,X
    CMP.B #$20
    BMI +                                     ; Jump down if time to erase.
    JMP CODE_029AA8

  + LDA.W CoinSpriteLayer,X                   ; Not time to erase the coin sprite.
    ASL A
    ASL A
    TAY
    LDA.W Layer1YPos,Y
    STA.B _2                                  ; Store onscreen position to scratch RAM.
    LDA.W Layer1XPos,Y
    STA.B _3
    LDA.W Layer1YPos+1,Y
    STA.B _4
    LDA.W CoinSpriteYPosLow,X
    CMP.B _2
    LDA.W CoinSpriteYPosHigh,X
    SBC.B _4                                  ; Return if vertically offscreen.
    BNE Return029A6D
    LDA.W CoinSpriteXPosLow,X
    SEC
    SBC.B _3                                  ; Erase if horizontally offscreen.
    CMP.B #$F8
    BCS CODE_0299E3
    STA.B _0
    LDA.W CoinSpriteYPosLow,X
    SEC                                       ; Get onscreen Y position.
    SBC.B _2
    STA.B _1
    LDY.W DATA_0299E9,X
    STY.B _F
    LDY.B _F
    LDA.B _0                                  ; Store X position to OAM.
    STA.W OAMTileXPos,Y
    LDA.B _1                                  ; Store Y position to OAM.
    STA.W OAMTileYPos,Y
    LDA.B #$E8                                ; Tile A to use for the spinning coin sprite's animation.
    STA.W OAMTileNo,Y
    LDA.B #$04
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A                                     ; Set OAM size as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    TXA
    CLC
    ADC.B EffFrame
    LSR A                                     ; Branch if not in a 16x16 animation frame (to use 8x8 tiles instead).
    LSR A
    AND.B #$03
    BNE +
Return029A6D:
    RTS


    db $EA,$FA,$EA

; Additional tiles for the spinning coin sprite's animation.
; The fourth frame (16x16) is at $029A4F
  + LDY.B _F                                  ; Using 8x8 tiles for the spinning coin sprite's animation instead.
    PHX
    TAX
    LDA.B _0
    CLC
    ADC.B #$04                                ; Store X position to OAM.
    STA.W OAMTileXPos,Y
    STA.W OAMTileXPos+4,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.B #$08
    STA.W OAMTileYPos+4,Y
    LDA.L Return029A6D,X
    STA.W OAMTileNo,Y                         ; Store tile number to OAM.
    STA.W OAMTileNo+4,Y
    LDA.W OAMTileAttr,Y
    ORA.B #$80                                ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+4,Y
    TYA
    LSR A
    LSR A
    TAY                                       ; Set OAM size as 8x8.
    LDA.B #$00
    STA.W OAMTileSize,Y
    STA.W OAMTileSize+1,Y
    PLX
    RTS

CODE_029AA8:
; Time to erase the spinning coin sprite.
    JSL CODE_02AD34                           ; Find next usable location in score sprite table; Find an empty score sprite slot.
    LDA.B #$01                                ; Create a 10-point score sprite.
    STA.W ScoreSpriteNumber,Y                 ; add a "10" score sprite
    LDA.W CoinSpriteYPosLow,X
    STA.W ScoreSpriteYPosLow,Y                ; set Yposition low byte
    LDA.W CoinSpriteYPosHigh,X
    STA.W ScoreSpriteYPosHigh,Y               ; set Ypos high byte; Spawn at the coin sprite's position.
    LDA.W CoinSpriteXPosLow,X
    STA.W ScoreSpriteXPosLow,Y                ; set Xpos low byte
    LDA.W CoinsPriteXPosHigh,X
    STA.W ScoreSpriteXPosHigh,Y               ; set Xpos high byte
    LDA.B #$30                                ; Set initial timer for the score sprite.
    STA.W ScoreSpriteTimer,Y                  ; set initial speed to 30
    LDA.W CoinSpriteLayer,X                   ; Set on the same layer as the original coin.
    STA.W ScoreSpriteLayer,Y
    JSR CODE_029ADA                           ; Spawn glitter.
    JMP CODE_0299E3                           ; Puts #$00 into $17D0 and returns; Erase the coin sprite.

CODE_029ADA:
    LDY.B #$03                                ; for (c=3;c>=0;c--); Subroutine to spawn glitter from a spinning coin sprite.
CODE_029ADC:
    LDA.W SmokeSpriteNumber,Y                 ; {; Find an empty smoke sprite slot.
    BEQ CODE_029AE5                           ;  check if there is empty space in smoke/dust sprite table; Return if none found.
    DEY
    BPL CODE_029ADC                           ; }
    RTS                                       ;  if no empty space, return

CODE_029AE5:
    LDA.B #$05                                ; if there's an empty space, make it 5 (glitter sprite); Set smoke sprite number (05 - glitter).
    STA.W SmokeSpriteNumber,Y
    LDA.W CoinSpriteLayer,X                   ;  nots sure what 17E4 is used for yet - copied from $1933
    LSR A                                     ; carryout = $17E4 % 2
    PHP
    LDA.W CoinSpriteXPosLow,X                 ; get x coordinate low byte
    BCC +                                     ; if carryout == 1
    SBC.B Layer23XRelPos                      ;   x-coord -= $26
  + STA.W SmokeSpriteXPos,Y                   ; store x-coord; Spawn at the coin's position, accounting for the Layer 2 offset.
    LDA.W CoinSpriteYPosLow,X                 ; get y coordinate low byte
    PLP
    BCC +                                     ; if carryout == 1
    SBC.B Layer23YRelPos                      ;   y-coord -=$28
  + STA.W SmokeSpriteYPos,Y                   ; store y-coord
    LDA.B #$10                                ; Set initial timer for the glitter sprite.
    STA.W SmokeSpriteTimer,Y                  ; duration = 10
    RTS

CODE_029B0A:
    LDX.B #$09                                ; Routine to handle extended sprites.
  - STX.W CurSpriteProcess                    ; Run through all the extended sprite slots.
    JSR CODE_029B16
    DEX
    BPL -
Return029B15:
    RTS

CODE_029B16:
    LDA.W ExtSpriteNumber,X                   ; Return if the extended sprite isn't used.
    BEQ Return029B15
    LDY.B SpriteLock
    BNE +
    LDY.W ExtSpriteMisc176F,X                 ; If sprites aren't frozen and the extended sprite uses a timer, decrement said timer.
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
; Extended sprite pointers.
; 00 - Nothing
; 01 - Smoke puff
; 02 - Reznor fireball
; 03 - Hopping flame remnant
; 04 - Hammer
; 05 - Mario fireball (reserved for last two slots)
; 06 - Bone
; 07 - Lava splash
; 08 - Torpedo Ted launcher arm
; 09 - Unused
; 0A - Coin cloud coin
; 0B - Piranha Plant fireball
; 0C - Volcano Lotus fireball
; 0D - Baseball
; 0E - Wiggler flower
; 0F - Yoshi stomp smoke
; 10 - Spinjump stars
; 11 - Yoshi fireball
; 12 - Water bubble
    LDY.W DATA_02A153,X                       ; Volcano Lotus fireball MAIN
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0                                  ; Erase if horizontally offscreen.
    LDA.W ExtSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BNE CODE_029BDA
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1                                  ; Erase if vertically below the screen.
    LDA.W ExtSpriteYPosHigh,X                 ; Skip drawing if above the screen.
    SBC.B Layer1YPos+1
    BEQ CODE_029B76
    BMI CODE_029BA5
    BPL CODE_029BDA
CODE_029B76:
    LDA.B _0                                  ; Store X position to OAM.
    STA.W OAMTileXPos,Y
    LDA.B _1
    CMP.B #$F0                                ; Store Y position to OAM.
    BCS CODE_029BA5                           ; Skip remainder of drawing if below the screen.
    STA.W OAMTileYPos,Y
    LDA.B #$09
    ORA.B SpriteProperties                    ; Store YXPPCCCT.
    STA.W OAMTileAttr,Y
    LDA.B EffFrame
    LSR A
    EOR.W CurSpriteProcess                    ; Store tile number to OAM.
    LSR A
    LSR A
    LDA.B #$A6                                ; Tile A to use for the volcano lotus fireballs.
    BCC +
    LDA.B #$B6                                ; Tile B to use for the volcano lotus fireballs.
  + STA.W OAMTileNo,Y
    TYA
    LSR A
    LSR A                                     ; Set size as 8x8.
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
CODE_029BA5:
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return029BD9
    JSR CODE_02A3F6                           ; Process Mario interaction.
    JSR CODE_02B554                           ; Update X position.
    JSR CODE_02B560                           ; Update Y position.
    LDA.B TrueFrame
    AND.B #$03
    BNE +                                     ; Apply gravity.
    LDA.W ExtSpriteYSpeed,X
    CMP.B #$18                                ; Maximum falling speed for the lotus fireballs.
    BPL +
    INC.W ExtSpriteYSpeed,X
  + LDA.W ExtSpriteYSpeed,X                   ; Return if the fireball is still moving upwards.
    BMI Return029BD9
    TXA
    ASL A
    ASL A                                     ; Make the fireball "shake" as it falls.
    ASL A
    ADC.B TrueFrame
    LDY.B #$08                                ; X speed rightwards for the lotus fireball when falling.
    AND.B #$08
    BNE +
    LDY.B #$F8                                ; X speed leftwards for the lotus fireball when falling.
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
; X offsets (lo) for each of the smoke puffs created by Yoshi's stomp.
; X offsets (hi) for each of the smoke puffs created by Yoshi's stomp.
; X speeds for each of the smoke puffs created by Yoshi's stomp.
    LDA.B #$05                                ; \ Set ground shake timer; Subroutine to spawn the smoke from Yoshi's ground stomp ability.
    STA.W ScreenShakeTimer                    ; /
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect; SFX for Yoshi stomping the ground.
    STA.W SPCIO3                              ; /
    STZ.B _0
    JSR CODE_029BF5                           ; Create two sprites.
    INC.B _0
CODE_029BF5:
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_029BF7:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_029C00                           ; |; Find an empty extended sprite slot and return if none found.
    DEY                                       ; |
    BPL CODE_029BF7                           ; |
    RTS                                       ; / Return if no free slots

CODE_029C00:
    LDA.B #$0F                                ; \ Extended sprite = Yoshi stomp smoke; Extended sprite to spawn (0F - Yoshi stomp smoke).
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B PlayerYPosNext
    CLC
    ADC.B #$28
    STA.W ExtSpriteYPosLow,Y                  ; Spawn at Yoshi's feet.
    LDA.B PlayerYPosNext+1
    ADC.B #$00
    STA.W ExtSpriteYPosHigh,Y
    LDX.B _0
    LDA.B PlayerXPosNext
    CLC
    ADC.W DATA_029BDE,X                       ; Spawn on either side of Yoshi.
    STA.W ExtSpriteXPosLow,Y
    LDA.B PlayerXPosNext+1
    ADC.W DATA_029BE0,X
    STA.W ExtSpriteXPosHigh,Y
    LDA.W DATA_029BE2,X                       ; Set X speed.
    STA.W ExtSpriteXSpeed,Y
    LDA.B #$15                                ; Set lifespan timer.
    STA.W ExtSpriteMisc176F,Y
; Yoshi stomp smoke misc RAM:
; $176F - Lifespan timer.
; Yoshi stomp smoke MAIN
    RTS                                       ; Write X and Y position to OAM.


SmokeTrailTiles:
    db $66,$64,$62,$60,$60,$60,$60,$60
    db $60,$60,$60

SmokeTrail:
    JSR CODE_02A1A4
    LDY.W DATA_02A153,X
    LDA.W ExtSpriteMisc176F,X
    LSR A                                     ; Get tile index based on the smoke's lifespan.
    PHX
    TAX
    LDA.B EffFrame
    ASL A
    ASL A
    ASL A                                     ; Change YXPPCCCT in OAM, flipping X and Y every two frames.
    ASL A
    AND.B #$C0
    ORA.B #$32
    STA.W OAMTileAttr,Y
    %LorW_X(LDA,SmokeTrailTiles)
    STA.W OAMTileNo,Y                         ; Change tile number in OAM.
    TYA
    LSR A
    LSR A                                     ; Change size in OAM to 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    PLX
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return029C7E
    LDA.W ExtSpriteMisc176F,X                 ; Erase the sprite if its timer runs out.
    BEQ CODE_029C7F
    CMP.B #$06
    BNE +
    LDA.W ExtSpriteXSpeed,X                   ; Half the sprite's X speed each frame, until it slows down to #$06.
    ASL A
    ROR.W ExtSpriteXSpeed,X
  + JSR CODE_02B554                           ; Update X position.
Return029C7E:
    RTS

CODE_029C7F:
    STZ.W ExtSpriteNumber,X                   ; Clear extended sprite; Subroutine to erase an extended sprite.
; Spinjump stars misc RAM:
; $176F - Lifespan timer.
; Spinjump stars MAIN
    RTS                                       ; Erase the sprite if its timer runs out.

SpinJumpStars:
    LDA.W ExtSpriteMisc176F,X
    BEQ CODE_029C7F
    JSR CODE_02A1A4                           ; Write X and Y position to OAM.
    LDY.W DATA_02A153,X
    LDA.B #$34                                ; Tile to use for the spinjump stars.
    STA.W OAMTileAttr,Y
    LDA.B #$EF                                ; YXPPCCCT to use for the spinjump stars.
    STA.W OAMTileNo,Y
    LDA.B SpriteLock                          ; Return if game frozen (don't update position).
    BNE +
    LDA.W ExtSpriteMisc176F,X
    LSR A
    LSR A
    TAY                                       ; Return if not on a frame to update position.
    LDA.B TrueFrame
    AND.W DATA_029CB0,Y
    BNE +
    JSR CODE_02B554                           ; Update X position.
    JSR CODE_02B560                           ; Update Y position.
  + RTS


DATA_029CB0:
    db $FF,$07,$01,$00,$00

CloudCoin:
; How quickly the spinjump stars move over the course of its lifespan.
; More bits set = less often.
; Used misc RAM:
; $1765 - For the coin: flag to indicate the coin has already bounced on the ground.
; For Wiggler's flower: does nothing. Set by the Wiggler anyway, though.
; Coin game cloud coin MAIN / Wiggler flower MAIN
    LDA.B SpriteLock                          ; Branch down to graphics if game frozen.
    BNE CODE_029CF8
    JSR CODE_02B560                           ; Update Y position.
    LDA.W ExtSpriteYSpeed,X                   ; Update Y speed.
    CMP.B #$30                                ; Max falling speed for the coin game coin / Wiggler flower.
    BPL +
    CLC
    ADC.B #$02                                ; Gravity for the coin game coin / Wiggler flower.
    STA.W ExtSpriteYSpeed,X
  + LDA.W ExtSpriteNumber,X
    CMP.B #$0E                                ; Branch if not the Wiggler flower (i.e. sprite is the coin).
    BNE ADDR_029CE3
    LDY.B #$08                                ; X speed rightwards.
    LDA.B EffFrame
    AND.B #$08                                ; Handle X speed. Creates a "wiggling" motion.
    BEQ +
    LDY.B #$F8                                ; X speed leftwards.
  + TYA
    STA.W ExtSpriteXSpeed,X
    JSR CODE_02B554                           ; Update X position.
    BRA CODE_029CF8                           ; Draw GFX.

ADDR_029CE3:
    LDA.W ExtSpriteMisc1765,X                 ; Coin game cloud coin only.
    BNE +
    JSR CODE_02A56E                           ; If the coin hasn't hit the ground yet, process object interaction.
    BCC +
    LDA.B #$D0                                ; Y speed the coin game coin bounces off the ground with.
    STA.W ExtSpriteYSpeed,X
    INC.W ExtSpriteMisc1765,X
  + JSR CODE_02A3F6                           ; Process Mario interaction.
CODE_029CF8:
    LDA.W ExtSpriteYPosLow,X                  ; Coin game cloud coin / Wiggler flower GFX routine.
    SEC
    SBC.B Layer1YPos                          ; Get Y position onscreen.
    CMP.B #$F0                                ; Erase if it goes offscreen.
    BCS CODE_029D5A
    STA.B _1
    LDA.W ExtSpriteXPosLow,X
    CMP.B Layer1XPos
    LDA.W ExtSpriteXPosHigh,X                 ; Return if the sprite is horizontally offscreen.
    SBC.B Layer1XPos+1
    BNE Return029D5D
    LDY.W DATA_02A153,X
    STY.B _F
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos                          ; Store X position to OAM.
    STA.B _0
    STA.W OAMTileXPos,Y
    LDA.W ExtSpriteNumber,X
    CMP.B #$0E                                ; Branch if not the wiggler flower (i.e. sprite is the coin).
    BNE +
    LDA.B _1
    SEC                                       ; Store Y position to OAM.
    SBC.B #$05
    STA.W OAMTileYPos,Y
    LDA.B #$98                                ; Tile to use for the Wiggler flower.
    STA.W OAMTileNo,Y
    LDA.B #$0B                                ; YXPPCCCT to use for the Wiggler flower.
CODE_029D36:
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A                                     ; Set size as 8x8.
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    RTS

  + LDA.B _1                                  ; Store Y position to OAM.
    STA.W OAMTileYPos,Y
    LDA.B #$C2                                ; Tile to use for the coin game coin.
    STA.W OAMTileNo,Y
    LDA.B #$04                                ; YXPPCCCT to use for the coin game coin.
    JSR CODE_029D36
    LDA.B #$02                                ; Set size as 16x16.
    STA.W OAMTileSize,Y
    RTS

CODE_029D5A:
    STZ.W ExtSpriteNumber,X                   ; Clear extended sprite; Subroutine to erase an extended sprite.
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

; Animation frames for the unused extended sprite's animation.
; Indexed by its lifespan timer divided by 4.
; X offsets for each frame of the unused extended sprite.
; Note that the sprite is not composed of three tiles, but rather three seperate "directions".
; Each of the three values within a row correspond to these directions.
; Y offsets for each frame of the unused extended sprite (see above for indexing details).
; Tile numbers for each frame of the unused extended sprite (see above for indexing details).
; YXPPCCCT for each of the three "directions".
; Tile sizes for each of the animation frames, regardless of the "direction".
  - STZ.W ExtSpriteNumber,X                   ; Clear extended sprite; Subroutine to erase an extended sprite.
    RTS

UnusedExtendedSpr:
    JSR CODE_02A3F6
; Unused extended sprite misc RAM:
; $1747 - Sprite slot of the sprite spawning it.
; $1765 - Extra value (0-2) indicating the "direction" of the sprite. 0 = right, 1 = left, 2 = up
; $176F - Lifespan timer. Max recommended value is #$3F.
; Unused extended sprite MAIN. Seems kind of like a small flame (for the Dino Rhino?), which can be fired right, left, or up.
    LDY.W ExtSpriteXSpeed,X                   ; Process interaction with Mario, and hurt him if touched.
    LDA.W SpriteStatus,Y
    CMP.B #$08                                ; Erase the sprite if its spawner is dead or its timer runs out.
    BNE -
    LDA.W ExtSpriteMisc176F,X
    BEQ -
    LSR A
    LSR A
    NOP
    NOP
    TAY                                       ; $0F = animation frame
    LDA.W DATA_029D5E,Y                       ; $02 = base animation table index (frame times 3)
    STA.B _F
    ASL A
    ADC.B _F
    STA.B _2
    LDA.W ExtSpriteMisc1765,X
    CLC
    ADC.B _2                                  ; $03 = animation table index (base + extra value)
    TAY
    STY.B _3
    LDA.W ExtSpriteXPosLow,X
    CLC
    ADC.W UnusedExSprDispX,Y                  ; $00 = onscreen X position
    SEC                                       ; Note that no high X position is factored in.
    SBC.B Layer1XPos
    STA.B _0
    LDA.W ExtSpriteYPosLow,X
    CLC
    ADC.W UnusedExSprDispY,Y                  ; $01 = onscreen Y position.
    SEC                                       ; Note that no high Y position is factored in.
    SBC.B Layer1YPos
    STA.B _1
    LDY.W DATA_02A153,X
    CMP.B #$F0
    BCS CODE_029E39                           ; Store Y position to OAM. Erase if vertically offscreen.
    STA.W OAMTileYPos,Y
    LDA.B _0
    CMP.B #$10
    BCC CODE_029E39                           ; Store X position to OAM. Erase if horizontally offscreen.
    CMP.B #$F0
    BCS CODE_029E39
    STA.W OAMTileXPos,Y
    LDA.W ExtSpriteMisc1765,X
    TAX                                       ; Store YXPPCCCT to OAM.
    %LorW_X(LDA,UnusedExSprGfxProp)
    STA.W OAMTileAttr,Y
    LDX.B _3
    %LorW_X(LDA,UnusedExSprTiles)
    STA.W OAMTileNo,Y                         ; Store tile number to OAM.
    TYA
    LSR A
    LSR A
    TAY                                       ; Store size to OAM.
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
    SEC                                       ; If Mario is within a 0.4 by 1.0 space around the sprite, hurt him.
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
; Y speeds for the Torpedo Ted launcher arm.
    STZ.W ExtSpriteNumber,X                   ; Subroutine to erase an extended sprite.
    RTS

LauncherArm:
; Torped Ted misc RAM:
; $176F - Lifespan timer.
    LDY.B #$00                                ; Torpedo Ted launcher arm MAIN
    LDA.W ExtSpriteMisc176F,X                 ; Erase the sprite if its timer runs out.
    BEQ CODE_029E39
    CMP.B #$60
    BCS +
    INY                                       ; Get Y speed index based on how far into the animation it is.
    CMP.B #$30
    BCS +
    INY
  + PHY
    LDA.B SpriteLock
    BNE +
    LDA.W DATA_029E36,Y                       ; If the game isn't frozen, set Y speed and update Y position.
    STA.W ExtSpriteYSpeed,X
    JSR CODE_02B560
  + JSR CODE_02A1A4                           ; Write X and Y position to OAM.
    LDY.W DATA_02A153,X
    PLA
    CMP.B #$01
    LDA.B #$84                                ; Tile to use before the launcher arm releases the torpedo.
    BCC +
    LDA.B #$A4                                ; Tile to use after the launcher arm releases the torpedo.
  + STA.W OAMTileNo,Y
    LDA.W OAMTileAttr,Y
    AND.B #$00                                ; Change YXPPCCCT in OAM.
    ORA.B #$13
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A                                     ; Change size in OAM to 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    RTS


LavaSplashTiles2:
    db $D7,$C7,$D6,$C6

LavaSplash:
; Tile numbers for the lava splash extended sprite.
; Lava splash misc RAM:
; $176F - Lifespan timer.
; Lava splash MAIN
    LDA.B SpriteLock                          ; Branch if game frozen.
    BNE CODE_029E9D
    JSR CODE_02B554                           ; Update X/Y position.
    JSR CODE_02B560
    LDA.W ExtSpriteYSpeed,X
    CLC
    ADC.B #$02                                ; Apply gravity.
    STA.W ExtSpriteYSpeed,X
    CMP.B #$30
    BPL +
CODE_029E9D:
    LDY.W DATA_02A153,X
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0                                  ; Store X position to OAM.
    LDA.W ExtSpriteXPosHigh,X                 ; Erase if horizontally offscreen.
    SBC.B Layer1XPos+1
    BNE +
    LDA.B _0
    STA.W OAMTileXPos,Y
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos                          ; Store Y position to OAM.
    CMP.B #$F0                                ; Erase if vertically offscreen.
    BCS +
    STA.W OAMTileYPos,Y
    LDA.W ExtSpriteMisc176F,X
    LSR A
    LSR A
    LSR A
    NOP                                       ; Store tile number to OAM.
    NOP
    AND.B #$03
    TAX
    %LorW_X(LDA,LavaSplashTiles2)
    STA.W OAMTileNo,Y
    LDA.B SpriteProperties
    ORA.B #$05                                ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A                                     ; Set size in OAM as 8x8.
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
; Water bubble misc RAM:
; $1765 - Frame counter for timing Y speed movement.
; $176F - Unused? Cleared when spawned by Mario.
; Underwater bubble MAIN
    LDA.B SpriteLock                          ; Branch if game frozen.
    BNE CODE_029F2A
    INC.W ExtSpriteMisc1765,X
    LDA.W ExtSpriteMisc1765,X
    AND.B #$30
    BEQ +                                     ; For 48 frames out of 64, move upwards at 1 pixel per frame.
    DEC.W ExtSpriteYPosLow,X                  ; For the remaining 16, freeze the bubble in place vertically.
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
    BNE CODE_029F2A                           ; Erase the sprite if either touching a solid block,
    LDA.B _C                                  ; or not in a water level and not touching a water block.
    CMP.B #$06                                ; On odd frames, skip processing this either way.
    BCC CODE_029F2A
    LDA.B _F
    BEQ CODE_029F27
    LDA.B _D
    CMP.B #$06
    BCC CODE_029F2A
CODE_029F27:
    JMP CODE_02A211                           ; Erase the sprite.

CODE_029F2A:
    LDA.W ExtSpriteYPosLow,X                  ; Bubble is in water.
    CMP.B Layer1YPos
    LDA.W ExtSpriteYPosHigh,X                 ; Erase the sprite if vertically offscreen.
    SBC.B Layer1YPos+1
    BNE CODE_029F27
    JSR CODE_02A1A4                           ; Write X and Y position to OAM.
    LDA.W ExtSpriteMisc1765,X
    AND.B #$0C
    LSR A
    LSR A                                     ; Get X offset for the horizontal "waving" motion.
    TAY
    LDA.W DATA_029EEA,Y
    STA.B _0
    LDY.W DATA_02A153,X
    LDA.W OAMTileXPos,Y
    CLC                                       ; Offset X position in OAM.
    ADC.B _0
    STA.W OAMTileXPos,Y
    LDA.W OAMTileYPos,Y
    CLC                                       ; Offset Y position in OAM.
    ADC.B #$05
    STA.W OAMTileYPos,Y
    LDA.B #$1C                                ; Tile to use for the water bubble.
    STA.W OAMTileNo,Y
    RTS

YoshiFireball:
    LDA.B SpriteLock                          ; Yoshi fireball MAIN
    BNE +
    JSR CODE_02B554                           ; If the game isn't frozen, update X/Y position and process interaction with sprites.
    JSR CODE_02B560
    JSR ProcessFireball
  + JSR CODE_02A1A4                           ; Write X and Y position to OAM.
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A                                     ; Change tile number in OAM.
    LDY.W DATA_02A153,X
    LDA.B #$04                                ; Tile A to use for the Yoshi fireballs..
    BCC +
    LDA.B #$2B                                ; Tile B value to use for the Yoshi fireballs.
  + STA.W OAMTileNo,Y
    LDA.W ExtSpriteXSpeed,X
    AND.B #$80
    EOR.B #$80                                ; Change YXPPCCCT in OAM, making it flash.
    LSR A
    ORA.B #$35
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A                                     ; Change size in OAM to 16x16.
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
; Y speeds to bounce a fireball, depending on direction and slope type.
; Flat ground is D0. Steeper slope = further absolute value.
; Position offsets for fireballs from a slope. Same order as above.
; OAM indices for Mario's fireball.
; OAM indices for Mario's fireball in a mode 7 room.
; Mario's fireball MAIN
    LDA.B SpriteLock                          ; If the game is locked, branch.
    BNE CODE_02A02C
    LDA.W ExtSpriteYPosLow,X
    CMP.B Layer1YPos
    LDA.W ExtSpriteYPosHigh,X                 ; If vertically offscreen, erase the sprite.
    SBC.B Layer1YPos+1                        ; (redundant since the fireball's GFX routine also handles this better)
    BEQ +
    JMP CODE_02A211

  + INC.W ExtSpriteMisc1765,X
    JSR ProcessFireball                       ; Process interaction with sprites.
    LDA.W ExtSpriteYSpeed,X
    CMP.B #$30                                ; Maximum vertical speed.
    BPL +
    LDA.W ExtSpriteYSpeed,X
    CLC
    ADC.B #$04                                ; Acceleration from gravity.
    STA.W ExtSpriteYSpeed,X
  + JSR CODE_02A56E                           ; Process object interaction, and branch if the fireball has not hit a block.
    BCC CODE_02A010
    INC.W ExtSpriteXPosSpx,X                  ; Set the flag for having hit an object.
    LDA.W ExtSpriteXPosSpx,X
    CMP.B #$02                                ; If the hit flag is 2 (touching a block for 2+ frames), branch to erase it.
    BCS CODE_02A042
    LDA.W ExtSpriteXSpeed,X
    BPL +
    LDA.B _B
    EOR.B #$FF
    INC A
    STA.B _B                                  ; Set the fireball's Y speed after bouncing.
  + LDA.B _B                                  ; Depends on the type of slope being hit.
    CLC
    ADC.B #$04
    TAY
    LDA.W DATA_029F99,Y
    STA.W ExtSpriteYSpeed,X
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.W DATA_029FA2,Y                       ; Shift the fireball according to the slope's steepness.
    STA.W ExtSpriteYPosLow,X
    BCS +
    DEC.W ExtSpriteYPosHigh,X
  + BRA +

CODE_02A010:
    STZ.W ExtSpriteXPosSpx,X                  ; Is not hitting a block; clear hit flag.
  + LDY.B #$00                                ; Update fireball position.
    LDA.W ExtSpriteXSpeed,X
    BPL +
    DEY
  + CLC                                       ; Update X position.
    ADC.W ExtSpriteXPosLow,X
    STA.W ExtSpriteXPosLow,X
    TYA
    ADC.W ExtSpriteXPosHigh,X
    STA.W ExtSpriteXPosHigh,X
    JSR CODE_02B560                           ; Update Y position.
CODE_02A02C:
    LDA.B SpriteNumber+7
    CMP.B #$A9
    BEQ CODE_02A03B
    LDA.W IRQNMICommand                       ; Branch if in a Mode 7 boss room with a lot of sprite tiles (Morton, Roy, Bowser).
    BPL CODE_02A03B
    AND.B #$40
    BNE +
CODE_02A03B:
    LDY.W DATA_029FA3,X                       ; Upload graphics ($0200 version).
    JSR CODE_02A1A7
    RTS

CODE_02A042:
; Erase fireball after hitting an object.
    JSR CODE_02A02C                           ; Upload graphics ($0200 version).
CODE_02A045:
; Subroutine to erase a fireball in a puff of smoke.
    LDA.B #!SFX_BONK                          ; \ Play sound effect; SFX for fireballs hitting a block/sprite.
    STA.W SPCIO0                              ; /
    LDA.B #$0F                                ; Erase in a puff of smoke.
    JMP CODE_02A4E0

  + LDY.W DATA_029FA5,X                       ; Subroutine to upload fireball graphics in a $0300 OAM slot. Main use is for Mode 7 bosses to not screw up.
    LDA.W ExtSpriteXSpeed,X
    AND.B #$80                                ; X flip based on direction of movement.
    LSR A
    STA.B _0
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CMP.B #$F8
    BCS ADDR_02A0A9
    STA.W OAMTileXPos+$100,Y                  ; Erase sprite if offscreen
    LDA.W ExtSpriteYPosLow,X                  ; else upload X and Y positions to OAM.
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
    AND.B #$03                                ; Upload animation tile to OAM.
    TAX
    LDA.W FireballTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02A15F,X
    EOR.B _0
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDX.B _1                                  ; Upload YXPPCCCT to OAM.
    BEQ +
    AND.B #$CF
    ORA.B #$10
    STA.W OAMTileAttr+$100,Y
  + TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00                                ; Set tile size (8x8).
    STA.W OAMTileSize+$40,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
  - RTS

ADDR_02A0A9:
    JMP CODE_02A211                           ; Erase the sprite.

ProcessFireball:
    TXA                                       ; \ Return every other frame; Subroutine to handle fireball-sprite interaction (for both Mario's and Yoshi's).
    EOR.B TrueFrame                           ; |
    AND.B #$03                                ; |; Process only 1/4 frames.
    BNE -                                     ; /
    PHX
    TXY
    STY.W TileGenerateTrackA                  ; $185E = Y = Extended sprite index
    LDX.B #$09                                ; Loop over sprites:; Highest sprite slot that the fireballs interact with.
FireRtLoopStart:
    STX.W CurSpriteProcess
    LDA.W SpriteStatus,X                      ; \ Skip current sprite if status < 8
    CMP.B #$08                                ; |
    BCC FireRtNextSprite                      ; /
    LDA.W SpriteTweakerD,X                    ; \ Skip current sprite if...; Skip to the next slot if it's:
    AND.B #$02                                ; | ...invincible to fire/cape/etc; Dying/dead
    ORA.W SpriteOnYoshiTongue,X               ; | ...sprite being eaten...; Invincible to fireballs
    ORA.W SpriteBehindScene,X                 ; | ...interactions disabled...; On Yoshi's tongue
    EOR.W ExtSpritePriority,Y                 ; On a different layer than the fireball
    BNE FireRtNextSprite                      ; /; Not in contact with the fireball
    JSL GetSpriteClippingA
    JSR CODE_02A547
    JSL CheckForContact
    BCC FireRtNextSprite
    LDA.W ExtSpriteNumber,Y                   ; \ if Yoshi fireball...
    CMP.B #$11                                ; |
    BEQ +                                     ; |
    PHX                                       ; |; If not Yoshi's fireballs, erase the sprite.
    TYX                                       ; |
    JSR CODE_02A045                           ; | ...?
    PLX                                       ; /
  + LDA.W SpriteTweakerC,X                    ; \ Skip sprite if fire killing is disabled
    AND.B #$10                                ; |; If the sprite can't be killed by fireballs, skip to the next slot.
    BNE FireRtNextSprite                      ; /
    LDA.W SpriteTweakerF,X                    ; \ Branch if takes 1 fireball to kill
    AND.B #$08                                ; |; If the sprite does not require 5 fireballs to kill, branch to turn it into a coin.
    BEQ TurnSpriteToCoin                      ; /
    INC.W SpriteMisc1528,X                    ; Increase times Chuck hit by fireball
    LDA.W SpriteMisc1528,X                    ; \ If fire count >= 5, kill Chuck:; Increase fireball hit counter and skip to the next sprite if it hasn't been hit 5 times yet.
    CMP.B #$05                                ; |
    BCC FireRtNextSprite                      ; |
; Sprite has been hit by 5 fireballs, time to kill.
    LDA.B #!SFX_SPLAT                         ; | Play sound effect; SFX for killing a Chuck with fireballs.
    STA.W SPCIO0                              ; |
    LDA.B #$02                                ; | Sprite status = Killed; Kill the Chuck.
    STA.W SpriteStatus,X                      ; |
    LDA.B #$D0                                ; | Set death Y speed; Y speed to give the dead Chuck.
    STA.B SpriteYSpeed,X                      ; |
    JSR SubHorzPosBnk2
    LDA.W FireKillSpeedX,Y                    ; | Set death X speed; Send flying away from Mario.
    STA.B SpriteXSpeed,X                      ; |
    LDA.B #$04                                ; | Increase points; Give 1000 points.
    JSL GivePoints                            ; |
    BRA FireRtNextSprite                      ; /; Continue to next sprite.

TurnSpriteToCoin:
; Sprite has been killed by a fireball and should turn into a coin.
    LDA.B #!SFX_KICK                          ; \ Turn sprite into coin:; SFX for killing a sprite with a fireball.
    STA.W SPCIO0                              ; | Play sound effect
    LDA.B #$21                                ; | Sprite = Moving Coin; Sprite to spawn (coin).
    STA.B SpriteNumber,X                      ; |
    LDA.B #$08                                ; | Sprite status = Normal
    STA.W SpriteStatus,X                      ; |
    JSL InitSpriteTables                      ; | Reset sprite tables
    LDA.B #$D0                                ; | Set upward speed; Y speed to give the coin when spawned.
    STA.B SpriteYSpeed,X                      ; |
    JSR SubHorzPosBnk2
    TYA                                       ; Set the coin to travel away from Mario.
    EOR.B #$01
    STA.W SpriteMisc157C,X                    ; /
FireRtNextSprite:
    LDY.W TileGenerateTrackA                  ; Continuing to the next sprite slot.
    DEX                                       ; Loop for all of the sprite slots.
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
; X speeds to give Chucks killed by fireballs.
; OAM indices for extended sprites, indexed by slot.
; Tile for fireballs (Mario's and normal sprites').
; YXPPCCCT for fireballs (Mario's and normal sprites').
; Tiles for Reznor's fireballs.
; YXPPCCCT for Reznor's fireballs.
    LDA.B SpriteLock                          ; Reznor fireball MAIN
    BNE CODE_02A178
    JSR CODE_02B554                           ; If the game isn't frozen, update X/Y position and process interaction with Mario.
    JSR CODE_02B560
    JSR CODE_02A3F6
CODE_02A178:
; Reznor and Piranha Plant fireballs GFX routine.
    LDA.W IRQNMICommand                       ; If not in Reznor's room, branch to use the standard fireball GFX routine.
    BPL CODE_02A1A4
    JSR CODE_02A1A4                           ; Write X and Y position to OAM.
    LDY.W DATA_02A153,X
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03                                ; Change the tile stored to OAM.
    PHX
    TAX
    LDA.W ReznorFireTiles,X
    STA.W OAMTileNo,Y
    LDA.W DATA_02A167,X
    EOR.B _0                                  ; Change the YXPPCCCT stored to OAM.
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A                                     ; Change the size stored to OAM to 16x16.
    TAX
    LDA.B #$02
    STA.W OAMTileSize,X
    PLX
    RTS

CODE_02A1A4:
; Misc RAM returns:
; $00 - Direction of movement (#$01 = right, #$00 = left).
; $01 - Flag to send behind layers.
; $02 - Y position within screen.
; Extended sprite graphics routine. Primary purpose is for fireballs; to do other sprites, overwrite the uploaded tile.
    LDY.W DATA_02A153,X                       ; Get OAM index.
CODE_02A1A7:
    LDA.W ExtSpriteXSpeed,X
    AND.B #$80
    EOR.B #$80                                ; X flip the sprite based on direction.
    LSR A
    STA.B _0
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _1                                  ; Erase sprite if horizontally offscreen.
    LDA.W ExtSpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BNE CODE_02A211
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _2
    LDA.W ExtSpriteYPosHigh,X                 ; Erase sprite if vertically offscreen.
    SBC.B Layer1YPos+1
    BNE CODE_02A211
    LDA.B _2
    CMP.B #$F0
    BCS CODE_02A211
    STA.W OAMTileYPos,Y
    LDA.B _1                                  ; Write X and Y position to OAM.
    STA.W OAMTileXPos,Y
    LDA.W ExtSpritePriority,X
    STA.B _1
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03                                ; Write animation tile (fireball) to OAM.
    TAX
    %LorW_X(LDA,FireballTiles)
    STA.W OAMTileNo,Y
    %LorW_X(LDA,DATA_02A15F)
    EOR.B _0
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    LDX.B _1                                  ; Write YXPPCCCT to OAM.
    BEQ +
    AND.B #$CF
    ORA.B #$10
    STA.W OAMTileAttr,Y
  + TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00                                ; Set tile size (8x8).
    STA.W OAMTileSize,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_02A211:
; Erase an extended sprite.
    LDA.B #$00                                ; \ Clear extended sprite; Erase the extended sprite.
    STA.W ExtSpriteNumber,X                   ; /
    RTS


SmallFlameTiles:
    db $AC,$AD

FlameRemnant:
; Tiles for the hopping flame remnants.
; Flame remnant misc RAM:
; $1765 - Frame counter for animation.
; $176F - Lifespan timer.
; Hopping flame remnant MAIN
    LDA.B SpriteLock                          ; Skip to graphics if game frozen.
    BNE CODE_02A22F
    INC.W ExtSpriteMisc1765,X
    LDA.W ExtSpriteMisc176F,X                 ; Erase the sprite if its timer runs out.
    BEQ CODE_02A211
    CMP.B #$50
    BCS CODE_02A22F
    AND.B #$01                                ; If the flame is getting close to dying, don't process Mario interaction and make it flash every other frame.
    BNE Return02A253
    BEQ +
CODE_02A22F:
    JSR CODE_02A3F6                           ; Process Mario interaction.
  + JSR CODE_02A1A4                           ; Write X and Y position to OAM.
    LDY.W DATA_02A153,X
    LDA.W ExtSpriteMisc1765,X
    LSR A
    LSR A
    AND.B #$01                                ; Change tile number stored to OAM.
    TAX
    %LorW_X(LDA,SmallFlameTiles)
    STA.W OAMTileNo,Y
    LDA.W OAMTileAttr,Y
    AND.B #$3F                                ; Change YXPPCCCT stored to OAM.
    ORA.B #$05
    STA.W OAMTileAttr,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
Return02A253:
    RTS

Baseball:
; Baseball and Bone misc RAM:
; $1765 - Unused frame counter?...
; Baseball MAIN and bone MAIN
    LDA.B SpriteLock                          ; Branch if game frozen.
    BNE CODE_02A26A
    JSR CODE_02B554                           ; Update X position.
    INC.W ExtSpriteMisc1765,X
    LDA.B TrueFrame
    AND.B #$01                                ; Handle some unused frame counter...?
    BNE +
    INC.W ExtSpriteMisc1765,X
  + JSR CODE_02A3F6                           ; Process Mario interaction.
CODE_02A26A:
    LDA.W ExtSpriteNumber,X
    CMP.B #$0D                                ; Branch if not 0D (baseball); i.e. branch if bone.
    BNE CODE_02A2C3
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.W ExtSpriteXPosHigh,X                 ; Erase the baseball if it goes offscreen in the direction it was moving,
    SBC.B Layer1XPos+1                        ; and just return if it goes offscreen otherwise (e.g. Mario ran ahead of the baseball and it has to catch up).
    BEQ CODE_02A287
    EOR.W ExtSpriteXSpeed,X
    BPL CODE_02A2BF
    BMI Return02A2BE
CODE_02A287:
    LDY.W DATA_02A153,X
    LDA.B _0                                  ; Store X position to OAM.
    STA.W OAMTileXPos,Y
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1                                  ; Erase the baseball if above the screen.
    LDA.W ExtSpriteYPosHigh,X
    SBC.B Layer1YPos+1
    BNE CODE_02A2BF
    LDA.B _1                                  ; Store Y position to OAM.
    STA.W OAMTileYPos,Y
    LDA.B #$AD                                ; Tile to use for the baseball.
    STA.W OAMTileNo,Y
    LDA.B EffFrame
    ASL A
    ASL A
    ASL A                                     ; Store YXPPCCCT to OAM.
    ASL A
    AND.B #$C0
    ORA.B #$39
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A                                     ; Set size as 8x8.
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
Return02A2BE:
    RTS

CODE_02A2BF:
    STZ.W ExtSpriteNumber,X                   ; Clear extended sprite; Erase the extended sprite.
    RTS

CODE_02A2C3:
; Bone extended sprite.
    JSR CODE_02A317                           ; Get base tile.
    LDA.W OAMTileNo,Y
    CMP.B #$26                                ; Tile A to use for the bone.
    LDA.B #$80
    BCS +
    LDA.B #$82                                ; Tile B to use for the bone.
  + STA.W OAMTileNo,Y
    LDA.W OAMTileAttr,Y
    AND.B #$F1                                ; Change YXPPCCCT stored to OAM.
    ORA.B #$02
    STA.W OAMTileAttr,Y
    RTS


HammerTiles:
    db $08,$6D,$6D,$08,$08,$6D,$6D,$08
HammerGfxProp:
    db $47,$47,$07,$07,$87,$87,$C7,$C7

Hammer:
; Hammer MAIN and Piranha Plant fireball MAIN
    LDA.B SpriteLock                          ; If sprites are frozen, just draw graphics.
    BNE CODE_02A30C
    JSR CODE_02B554                           ; Update X position.
    JSR CODE_02B560                           ; Update Y position.
    LDA.W ExtSpriteYSpeed,X
    CMP.B #$40                                ; Max Y speed.
    BPL +
    INC.W ExtSpriteYSpeed,X                   ; Vertical acceleration.
    INC.W ExtSpriteYSpeed,X
  + JSR CODE_02A3F6                           ; Process Mario interaction.
    INC.W ExtSpriteMisc1765,X                 ; Increment animation timer.
CODE_02A30C:
    LDA.W ExtSpriteNumber,X
    CMP.B #$0B                                ; Jump away if the Piranha Plant fireball.
    BNE CODE_02A317
    JSR CODE_02A178
    RTS

CODE_02A317:
; Hammer and bone GFX routine.
    JSR CODE_02A1A4                           ; Write X and Y position to OAM.
    LDY.W DATA_02A153,X
    LDA.W ExtSpriteMisc1765,X
    LSR A
    LSR A
    LSR A
    AND.B #$07                                ; Write animation tile to OAM.
    PHX
    TAX
    %LorW_X(LDA,HammerTiles)
    STA.W OAMTileNo,Y
    %LorW_X(LDA,HammerGfxProp)
    EOR.B _0
    EOR.B #$40                                ; Write YXPPCCCT to OAM.
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAX
    LDA.B #$02                                ; Set tile size as 16x16.
    STA.W OAMTileSize,X
    PLX
    RTS

  - JMP CODE_02A211                           ; Erase the extended sprite.


DustCloudTiles:
    db $66,$64,$60,$62

DATA_02A34B:
    db $00,$40,$C0,$80

SmokePuff:
; Tile numbers for the smoke puff's animation.
; YXPPCCCT for the smoke puff's animation.
; Smoke puff misc RAM:
; $176F - Lifespan timer.
; Smoke puff extended sprite MAIN
    LDA.W ExtSpriteMisc176F,X                 ; Erase the sprite if its timer has run out.
    BEQ -
    LDA.W ReznorOAMIndex
    BNE CODE_02A362
    LDA.W IRQNMICommand                       ; Branch if in Morton/Roy or Bowser's room.
    BPL CODE_02A362
    AND.B #$40
    BNE ADDR_02A3B1
CODE_02A362:
    LDY.W DATA_02A153,X
    CPX.B #$08                                ; Get OAM index for the extended sprite.
    BCC +                                     ; If spawned from a fireball, reuse its OAM slot.
    LDY.W DATA_029FA3,X
  + LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos                          ; Write X position to OAM, and erase if horizontally offscreen.
    CMP.B #$F8
    BCS CODE_02A3AE
    STA.W OAMTileXPos,Y
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos                          ; Write Y position to OAM, and erase if vertically offscreen.
    CMP.B #$F0
    BCS CODE_02A3AE
    STA.W OAMTileYPos,Y
    LDA.W ExtSpriteMisc176F,X
    LSR A
    LSR A                                     ; Write the tile number to OAM.
    TAX
    %LorW_X(LDA,DustCloudTiles)
    STA.W OAMTileNo,Y
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03                                ; Write YXPPCCCT to OAM.
    TAX
    %LorW_X(LDA,DATA_02A34B)
    ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A                                     ; Set size as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_02A3AE:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    JML CODE_02A211                           ;!
else                                          ;<================ U, SS, E0, & E1 ==============
    JMP CODE_02A211                           ;!; Erase the extended sprite.
endif                                         ;/===============================================

ADDR_02A3B1:
    LDY.W DATA_029FA5,X                       ; Smoke puff is in Morton/Roy or Bowser's room; use the $0300 range for OAM instead. Note that apparently only fireballs are expected here.
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B Layer1XPos                          ; Store X position to OAM, and erase if horizontally offscreen.
    CMP.B #$F8
    BCS CODE_02A3AE
    STA.W OAMTileXPos+$100,Y
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B Layer1YPos                          ; Store Y position to OAM, and erase if vertically offscreen.
    CMP.B #$F0
    BCS CODE_02A3AE
    STA.W OAMTileYPos+$100,Y
    LDA.W ExtSpriteMisc176F,X
    LSR A
    LSR A                                     ; Store the tile number to OAM.
    TAX
    %LorW_X(LDA,DustCloudTiles)
    STA.W OAMTileNo+$100,Y
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03                                ; Store YXPPCCCT to OAM.
    TAX
    %LorW_X(LDA,DATA_02A34B)
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    TYA
    LSR A
    LSR A                                     ; Set size as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    RTS

CODE_02A3F6:
    LDA.W PlayerBehindNet                     ; Subroutine to process interaction between an extended sprite and Mario. Generally, hurts Mario if so.
    EOR.W ExtSpritePriority,X                 ; Return if Mario and the sprite are on different layers.
    BNE Return02A468
    JSL GetMarioClipping
    JSR CODE_02A519                           ; Return if not in contact.
    JSL CheckForContact
    BCC Return02A468
    LDA.W ExtSpriteNumber,X
    CMP.B #$0A                                ; Branch if not extended sprite A (coin game cloud).
    BNE CODE_02A469
    JSL CODE_05B34A                           ; Give Mario a coin.
    INC.W GameCloudCoinCount                  ; Increase coin game counter and erase the coin.
    STZ.W ExtSpriteNumber,X                   ; Clear extended sprite
    LDY.B #$03
ADDR_02A41E:
    LDA.W SmokeSpriteNumber,Y
    BEQ ADDR_02A427                           ; Find an empty smoke sprite slot. Overwrites slot 0 if none found.
    DEY
    BPL ADDR_02A41E
    INY
ADDR_02A427:
    LDA.B #$05                                ; Smoke sprite to spawn (glitter).
    STA.W SmokeSpriteNumber,Y
    LDA.W ExtSpriteXPosLow,X
    STA.W SmokeSpriteXPos,Y                   ; Spawn at the coin's position.
    LDA.W ExtSpriteYPosLow,X
    STA.W SmokeSpriteYPos,Y
    LDA.B #$0A                                ; Set timer for the glitter.
    STA.W SmokeSpriteTimer,Y
    JSL CODE_02AD34                           ; Find an empty score sprite slot.
    LDA.B #$05                                ; Score sprite to spawn (100 points).
    STA.W ScoreSpriteNumber,Y
    LDA.W ExtSpriteYPosLow,X
    STA.W ScoreSpriteYPosLow,Y
    LDA.W ExtSpriteYPosHigh,X
    STA.W ScoreSpriteYPosHigh,Y               ; Spawn at the coin's position.
    LDA.W ExtSpriteXPosLow,X
    STA.W ScoreSpriteXPosLow,Y
    LDA.W ExtSpriteXPosHigh,X
    STA.W ScoreSpriteXPosHigh,Y
    LDA.B #$30                                ; Set timer for the score sprite.
    STA.W ScoreSpriteTimer,Y
    LDA.B #$00                                ; Spawn on Layer 1, always.
    STA.W ScoreSpriteLayer,Y
Return02A468:
    RTS

CODE_02A469:
; Processing interaction with a sprite other than the cloud game coin (i.e. hurt Mario).
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario has star; Erase in a cloud of smoke if Mario has star power.
    BNE CODE_02A4B5                           ; /
    LDA.W PlayerRidingYoshi                   ; Branch if Mario doesn't have Yoshi.
    BEQ +
CODE_02A473:
    PHX                                       ; Riding Yoshi and hitting an extended sprite.
    LDX.W CurrentYoshiSlot
    LDA.B #$10                                ; Temporarily disable damage from other sprites for Yoshi.
    STA.W SpriteMisc163E-1,X
    LDA.B #!SFX_YOSHIDRUMOFF                  ; \ Play sound effect; Turning off Yoshi drums.
    STA.W SPCIO1                              ; /
    LDA.B #!SFX_YOSHIHURT                     ; \ Play sound effect; SFX for losing Yoshi.
    STA.W SPCIO3                              ; /
    LDA.B #$02                                ; Set Yoshi to be in a running state.
    STA.B SpriteTableC2-1,X
    STZ.W PlayerRidingYoshi                   ; Clear flags for riding Yoshi.
    STZ.W CarryYoshiThruLvls
    LDA.B #$C0                                ; Y speed to give Mario when knocked off Yoshi by an extended sprite.
    STA.B PlayerYSpeed+1
    STZ.B PlayerXSpeed+1
    LDY.W SpriteMisc157C-1,X
    LDA.W DATA_02A4B3,Y                       ; Give Yoshi a running X speed.
    STA.B SpriteXSpeed-1,X
    STZ.W SpriteMisc1594-1,X
    STZ.W SpriteMisc151C-1,X                  ; Reset Yoshi's tongue.
    STZ.W YoshiStartEatTimer
    LDA.B #$30                                ; How long Mario is invincible for after being knocked off Yoshi by an extended sprite.
    STA.W IFrameTimer
    PLX
    RTS

; Not riding Yoshi.
  + JSL HurtMario                             ; Hurt Mario.
    RTS


DATA_02A4B3:
    db $10,$F0

CODE_02A4B5:
; X speeds to give Yoshi when Mario is knocked off by an extended sprite.
    LDA.W ExtSpriteNumber,X                   ; Hitting an extended sprite while Mario has star power.
    CMP.B #$04                                ; Branch if extended sprite 04 (hammer).
    BEQ CODE_02A4DE
    LDA.W ExtSpriteXPosLow,X
    SEC
    SBC.B #$04
    STA.W ExtSpriteXPosLow,X
    LDA.W ExtSpriteXPosHigh,X
    SBC.B #$00
    STA.W ExtSpriteXPosHigh,X                 ; Offset the extended sprite's position 4 pixels left and up (to match with a 16x16 tile).
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
    STA.W ExtSpriteMisc176F,X                 ; Set timer for the smoke puff.
    LDA.B #$01                                ; Change the sprite into a puff of smoke.
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
; X clipping offsets for extended sprites $02-$0D.
; Y clipping offsets for extended sprites $02-$0D.
; Width for extended sprites $02-$0D.
; Height for extended sprites $02-$0D.
; Scratch RAM returns:
; $04 - Clipping X displacement, low
; $05 - Clipping Y displacement, low
; $06 - Clipping width
; $07 - Clipping height
; $0A - Clipping X displacement, high
; $0B - Clipping Y displacement, high
    LDY.W ExtSpriteNumber,X                   ; Subroutine to get clipping values (as sprite A) for an extended sprite.
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
; Scratch RAM returns:
; $00 - Clipping X displacement, low
; $01 - Clipping Y displacement, low
; $02 - Clipping width (#$0C)
; $03 - Clipping height (#$13)
; $08 - Clipping X displacement, high
; $09 - Clipping Y displacement, high
    LDA.W ExtSpriteXPosLow,Y                  ; Subroutine to get clipping values (as sprite B) for Mario's fireballs.
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
; Scratch RAM returns:
; Carry - Set if in contact, clear if not. Not recommended as a check when Layer 2 is active, as it only returns whether Layer 2 was hit.
; $0B   - Value from $00E53D, if a slope object is hit.
; $0C   - Layer 1 tile the sprite is hitting.
; $0D   - Layer 2 tile the sprite is hitting.
; $0E   - Whether the sprite hit an object: ---- ---1, or ---- --12 with layer 2 enabled.
; $0F   - #$01 if Layer 2 collision is processed, #$00 if not.
; $1694 - Number of pixels to shift down from the block's top (for slopes).
    STZ.B _F                                  ; Extended sprite-object interaction routine (for fireballs, coin game cloud coin).
    STZ.B _E                                  ; Initialize returns.
    STZ.B _B
    STZ.W SpriteBlockOffset
    LDA.W ReznorOAMIndex
    BNE CODE_02A5BC                           ; Branch if in a non Mode 7 room or Reznor's room.
    LDA.W IRQNMICommand
    BPL CODE_02A5BC
    AND.B #$40                                ; Branch if in Iggy/Larry's room.
    BEQ CODE_02A592
    LDA.W IRQNMICommand
    CMP.B #$C1                                ; Branch if in Bowser's room.
    BEQ CODE_02A5BC
    LDA.W ExtSpriteYPosLow,X                  ; Morton/Roy's room: return contact if lower than #$A8.
    CMP.B #$A8
    RTS

CODE_02A592:
    LDA.W ExtSpriteXPosLow,X                  ; In Iggy/Larry's room.
    CLC
    ADC.B #$04
    STA.W IggyLarryPlatIntXPos
    LDA.W ExtSpriteXPosHigh,X
    ADC.B #$00
    STA.W IggyLarryPlatIntXPos+1              ; Get interaction X/Y position.
    LDA.W ExtSpriteYPosLow,X
    CLC
    ADC.B #$08
    STA.W IggyLarryPlatIntYPos
    LDA.W ExtSpriteYPosHigh,X
    ADC.B #$00
    STA.W IggyLarryPlatIntYPos+1
    JSL CODE_01CC9D                           ; Check for contact with the platform and return result in carry.
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_02A5BC:
; In a normal level, Reznor's room, or Bowser's room.
    JSR CODE_02A611                           ; Check whether the extended sprite has hit an object (on Layer 1).
    ROL.B _E                                  ; Set bit 0 of $0E if so.
    LDA.W Map16TileNumber                     ; Store tile the sprite hit.
    STA.B _C
    LDA.B ScreenMode
    BPL +                                     ; Handle Layer 2 collision if applicable. Branch if not.
    INC.B _F
    LDA.W ExtSpriteXPosLow,X
    PHA
    CLC
    ADC.B Layer23XRelPos
    STA.W ExtSpriteXPosLow,X
    LDA.W ExtSpriteXPosHigh,X
    PHA
    ADC.B Layer23XRelPos+1
    STA.W ExtSpriteXPosHigh,X                 ; Offset the extended sprites's position for Layer 2.
    LDA.W ExtSpriteYPosLow,X
    PHA
    CLC
    ADC.B Layer23YRelPos
    STA.W ExtSpriteYPosLow,X
    LDA.W ExtSpriteYPosHigh,X
    PHA
    ADC.B Layer23YRelPos+1
    STA.W ExtSpriteYPosHigh,X
    JSR CODE_02A611                           ; Check whether the extended sprite has hit an object (on Layer 2).
    ROL.B _E                                  ; Shift $0E over one bit and set bit 0 if so.
    LDA.W Map16TileNumber                     ; Store tile the sprite hit.
    STA.B _D
    PLA
    STA.W ExtSpriteYPosHigh,X
    PLA
    STA.W ExtSpriteYPosLow,X                  ; Restore the extended sprite's position.
    PLA
    STA.W ExtSpriteXPosHigh,X
    PLA
    STA.W ExtSpriteXPosLow,X
; Not processing Layer 2 interaction.
  + LDA.B _E                                  ; Return whether or not the extended sprite hit a block.
    CMP.B #$01                                ; Note that this only checks whether the last processed layer was hit (i.e. only Layer 2 if both 1 and 2 are active).
    RTS

CODE_02A611:
    LDA.B _F                                  ; Subroutine to check whether an extended sprite has hit a block. Returns carry set if so.
    INC A                                     ; Branch if processing a horizontal layer.
    AND.B ScreenMode
    BEQ CODE_02A679
    LDA.W ExtSpriteYPosLow,X
    CLC
    ADC.B #$08                                ; Get position of the block being hit.
    STA.B TouchBlockYPos
    AND.B #$F0
    STA.B _0
    LDA.W ExtSpriteYPosHigh,X
    ADC.B #$00
    CMP.B LevelScrLength                      ; Return carry clear if vertically outside the level.
    BCS CODE_02A677
    STA.B _3
    STA.B TouchBlockYPos+1
    LDA.W ExtSpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.B _1
    STA.B TouchBlockXPos
    LDA.W ExtSpriteXPosHigh,X
    ADC.B #$00                                ; Return carry clear if horizontally outside the level.
    CMP.B #$02
    BCS CODE_02A677
    STA.B _2
    STA.B TouchBlockXPos+1
    LDA.B _1
    LSR A
    LSR A
    LSR A                                     ; Get position as an XY-formatted value.
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _3
    LDA.L DATA_00BA80,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA8E,X
  + CLC
    ADC.B _0                                  ; Get lower two bytes of the object data pointer, storing to $05.
    STA.B _5
    LDA.L DATA_00BABC,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BACA,X
  + ADC.B _2
    STA.B _6
    BRA CODE_02A6DB                           ; Jump down to the shared remainder of the code.

CODE_02A677:
    CLC                                       ; Return not in contact.
    RTS

CODE_02A679:
    LDA.W ExtSpriteYPosLow,X                  ; Extended sprite object interaction in horizontal levels.
    CLC
    ADC.B #$08                                ; Get position of the block being hit.
    STA.B TouchBlockYPos
    AND.B #$F0
    STA.B _0
    LDA.W ExtSpriteYPosHigh,X
    ADC.B #$00
    STA.B _2
    STA.B TouchBlockYPos+1
    LDA.B _0
    SEC
    SBC.B Layer1YPos                          ; Return carry clear if vertically outside the level.
    CMP.B #$F0
    BCS CODE_02A677
    LDA.W ExtSpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.B _1
    STA.B TouchBlockXPos
    LDA.W ExtSpriteXPosHigh,X
    ADC.B #$00                                ; Return carry clear if horizontally outside the level.
    CMP.B LevelScrLength
    BCS CODE_02A677
    STA.B _3
    STA.B TouchBlockXPos+1
    LDA.B _1
    LSR A
    LSR A
    LSR A                                     ; Get position as an XY-formatted value.
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _3
    LDA.L DATA_00BA60,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA70,X
  + CLC
    ADC.B _0                                  ; Get lower two bytes of the object data pointer, storing to $05.
    STA.B _5
    LDA.L DATA_00BA9C,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BAAC,X
  + ADC.B _2
    STA.B _6
CODE_02A6DB:
    LDA.B #$7E                                ; Common code; now time to handle interaction with the block.
    STA.B _7
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B [_5]                                ; Get the low byte of the tile number in $1693, and the high byte in A.
    STA.W Map16TileNumber
    INC.B _7
    LDA.B [_5]
    JSL CODE_00F545                           ; Get proper "acts like" settings for the block being hit.
    CMP.B #$00                                ; If it's on page 0, return empty (carry clear).
    BEQ CODE_02A729
    LDA.W Map16TileNumber
    CMP.B #$11                                ; Branch if it's a ledge (100-110).
    BCC CODE_02A72B
    CMP.B #$6E                                ; If it's a solid block (111-16D), return solid (carry set).
    BCC CODE_02A727
    CMP.B #$D8                                ; Branch if it's a corner tile/not a slope (1D8-1FF).
    BCS CODE_02A735
    LDY.B TouchBlockXPos
    STY.B _A                                  ; Slope tile (16E-1D7).
    LDY.B TouchBlockYPos                      ; Find the interaction position for the slope at the extended sprite's current X position.
    STY.B _C
    JSL CODE_00FA19
    LDA.B _0
    CMP.B #$0C
    BCS CODE_02A718                           ; Return as blank if more than 4 pixels from the bottom of the block and below the pixel offset distance (i.e. don't force on top).
    CMP.B [_5],Y
    BCC CODE_02A729
CODE_02A718:
    LDA.B [_5],Y                              ; Store tile number being hit.
    STA.W SpriteBlockOffset
    PHX
    LDX.B _8
    LDA.L DATA_00E53D,X                       ; Store the slope interaction index for the extended sprite to $0B.
    PLX
    STA.B _B
CODE_02A727:
    SEC                                       ; Return solid (carry set).
    RTS

CODE_02A729:
; Return not in contact.
    CLC                                       ; Return empty (carry clear).
    RTS

CODE_02A72B:
    LDA.B TouchBlockYPos                      ; Extended sprite interaction for ledges (tiles 100-110).
    AND.B #$0F                                ; If within 5 pixels of the top of the ledge, return solid.
    CMP.B #$06                                ; Else, return empty.
    BCS CODE_02A729
    SEC
    RTS

CODE_02A735:
    LDA.B TouchBlockYPos                      ; Extended sprite interaction for corners (tiles 1D8-1FF).
    AND.B #$0F                                ; If within 5 pixels of the top of the ledge, return solid.
    CMP.B #$06
    BCS CODE_02A729
    LDA.W ExtSpriteYPosLow,X
    SEC
    SBC.B #$02
    STA.W ExtSpriteYPosLow,X                  ; Else, shift the sprite up 2 pixels.
    LDA.W ExtSpriteYPosHigh,X
    SBC.B #$00
    STA.W ExtSpriteYPosHigh,X
    JMP CODE_02A611                           ; Check for contact again (to try and find the slope tile above it).

CODE_02A751:
    PHB                                       ; Routine to handle loading sprites during level load.
    PHK
    PLB
    JSR CODE_02ABF2                           ; Clear sprite status tables (excluding carried sprites) and clear out $1693-$190D.
    JSR CODE_02AC5C                           ; Load on-screen sprites.
    LDA.W IRQNMICommand
    BMI +                                     ; If not a boss room, run normal sprite INIT routines.
    JSL CODE_01808C
  + LDA.W CarryYoshiThruLvls
    BEQ +
    LDA.W RemoveYoshiFlag                     ; Spawn Mario on Yoshi if he's able to.
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
; Highest sprite slot to spawn normal sprites in for each sprite memory index.
; Highest sprite slot for reserved sprite 1 in for each sprite memory index.
; Highest sprite slot for reserved sprite 2 in for each sprite memory index.
; Lowest sprite slot to spawn normal sprites in for each sprite memory index.
; Lowest sprite slot to spawn a reserved sprite in for each sprite memory index.
; First sprite reserved for certain sprite slots in each sprite memory index.
; Second sprite reserved for certain OAM slots in each sprite memory index.
; Positions of the spawn region for the current direction of scrolling.
; 0 = left/up, 1 = no scroll (level load), 2 = right/down
; High bytes of the spawn region positions above.
    LDA.B TrueFrame                           ; \ Return every other frame; Subroutine to load sprites from level data; called each frame.
    AND.B #$01                                ; |; Return on odd frames.
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
    BRA +                                     ; /; Get the spawn region of the screen in $00/$01, accounting for vertical levels.

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
    LDA.B [SpriteDataPtr],Y                   ; Byte format: YYYYEEsy; Main sprite spawn loop; scans through the level's sprite data and sees what's next to spawn.
    CMP.B #$FF                                ; \ Return when we encounter $FF, as it signals the end; If #$FF is loaded, then the end of the data has been reached, so return.
    BEQ Return02A84B                          ; /
    ASL A                                     ; \ If 's' is set, $02 = #$10
    ASL A                                     ; | Else, $02 = #$00
    ASL A                                     ; |
    AND.B #$10                                ; |
    STA.B _2                                  ; /; Make sure the spawn region is on the same screen as the sprite.
    INY                                       ; Next byte; Skip to the next sprite if past it.
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
    BNE Return02A84B                          ; Return if sprite screen > adjusted screen boundary; End routine if the next sprite is past the spawn region.
    LDA.B [SpriteDataPtr],Y                   ; Byte format: XXXXSSSS
    AND.B #$F0                                ; \ Skip sprite if not right at the screen boundary; Skip if the sprite is not within the spawn region.
    CMP.B _0                                  ; |
    BNE LoadNextSprite                        ; /
    LDA.W SpriteLoadStatus,X                  ; \ This table has a flag for every sprite in the level (not just those onscreen)
    BNE LoadNextSprite                        ; / Skip sprite if it's already been loaded/permanently killed; Skip if the sprite has already been spawned or killed.
    STX.B _2                                  ; $02 = Number of sprite in level; Otherwise, mark the sprite as spawned.
    INC.W SpriteLoadStatus,X                  ; Mark sprite as loaded
    INY                                       ; Next byte
    LDA.B [SpriteDataPtr],Y                   ; Byte format: Sprite number; $05 = sprite ID to spawn.
    STA.B _5                                  ; $05 = Sprite number
    DEY                                       ; Previous byte
    CMP.B #$E7                                ; \ Branch if sprite number < #$E7; If the sprite ID is not E7-FE, branch.
    BCC CODE_02A88C                           ; /
    LDA.W Layer1ScrollCmd                     ; Spawning sprites E7-FE (scroll sprites)
    ORA.W Layer2ScrollCmd                     ; Skip if a scroll sprite has already been spawned.
    BNE +
    PHY
    PHX
    LDA.B _5                                  ; \ $143E = Type of scroll sprite
    SEC                                       ; | (Sprite number - #$E7); Store scroll sprite number.
    SBC.B #$E7                                ; |
    STA.W Layer1ScrollCmd                     ; /
    DEY                                       ; Previous byte
    LDA.B [SpriteDataPtr],Y                   ; Byte format: YYYYEEsy
    LSR A                                     ; Store starting Y position.
    LSR A
    STA.W Layer1ScrollBits
    JSL CODE_05BCD6                           ; Run INIT codes.
    PLX
    PLY
  + BRA LoadNextSprite

CODE_02A88C:
; Not a scroll sprite; check other special values (e.g. "run-once" sprites).
    CMP.B #$DE                                ; \ Branch if sprite number != 5 Eeries; If it's not sprite DE (5 eeries), then branch.
    BNE CODE_02A89C                           ; /
    PHY
    PHX
    DEY
    STY.B _3
    JSR Load5Eeries                           ; Load 5 eeries.
    PLX
    PLY
CODE_02A89A:
    BRA LoadNextSprite

CODE_02A89C:
    CMP.B #$E0                                ; \ Branch if sprite number != 3 Platforms on Chain; If it's not sprite E0 (3 platforms), then branch.
    BNE CODE_02A8AC                           ; /
    PHY
    PHX
    DEY
    STY.B _3
    JSR Load3Platforms                        ; Spawn 3 platforms.
    PLX
    PLY
    BRA CODE_02A89A

CODE_02A8AC:
    CMP.B #$CB                                ; \ Branch if sprite number < #$CB; Branch if it's a normal or shooter sprite (00-CA).
    BCC CODE_02A8D4                           ; /
    CMP.B #$DA                                ; \ Branch if sprite number >= #$DA; If the sprite ID is DA-FF, then branch as a special sprite.
    BCS CODE_02A8C0                           ; /
    SEC                                       ; \ $18B9 = Type of generator; Spawning sprites CB-D9 (generators)
    SBC.B #$CB                                ; | (Sprite number - #$CA); Store the generator type.
    INC A                                     ; |
    STA.W CurrentGenerator                    ; /
    STZ.W SpriteLoadStatus,X                  ; Allow sprite to be reloaded by level loading routine
    BRA CODE_02A89A

CODE_02A8C0:
    CMP.B #$E1                                ; \ Branch if sprite number < #$E1; If the sprite ID is not E1-E6, branch.
    BCC CODE_02A8D0                           ; /; If it is, then it's a cluster sprite.
    PHX
    PHY
    DEY
    STY.B _3
    JSR CODE_02AAC0                           ; Initialize the cluster sprite.
    PLY
    PLX
    BRA CODE_02A89A

CODE_02A8D0:
; Spawning sprites DA-DD, DF (shells)
    LDA.B #$09                                ; Spawn in the carryable state.
    BRA CODE_02A8DF

CODE_02A8D4:
    CMP.B #$C9                                ; \ Branch if sprite number < #$C9
    BCC LoadNormalSprite                      ; /; If the sprite ID is 00-C8, it's a normal sprite.
    JSR LoadShooter                           ; If it's C9 or CA, process as a shooter.
    BRA CODE_02A89A                           ; NOTE: there is a bug in implementation here, see the end of LoadShooter for details. PIXI fixes this.

LoadNormalSprite:
; Spawning sprites 00-C8 (standard sprites). Also used for DA-DD and DF (shells), with initial state 9.
    LDA.B #$01                                ; \ $04 = #$01; Normal initial sprite state.
CODE_02A8DF:
    STA.B _4                                  ; / Eventually goes into sprite status
    DEY                                       ; Previous byte
    STY.B _3
    LDY.W SpriteMemorySetting
    LDX.W SpriteSlotMax,Y
    LDA.W SpriteSlotStart,Y
    STA.B _6
    LDA.B _5
    CMP.W ReservedSprite1,Y                   ; Figure out what slots are available for the sprite.
    BNE +                                     ; $00 - Spawn region (low byte)
    LDX.W SpriteSlotMax1,Y                    ; $01 - Spawn region (high byte)
    LDA.W SpriteSlotStart1,Y                  ; $02 - Sprite load status index
    STA.B _6                                  ; $03 - Index to sprite data
; $04 - Sprite state to spawn with (either 01 or 09)
  + LDA.B _5                                  ; $05 - Sprite ID
    CMP.W ReservedSprite2,Y                   ; $06 - Minimum sprite slot
    BNE CODE_02A916                           ; $0F - Maximum sprite slot (also in X)
    CMP.B #$64                                ; Y   - Sprite memory index
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
    DEX                                       ; Find an empty sprite slot.
    CPX.B _6
    BNE CODE_02A918
    LDA.B _5
    CMP.B #$7B
    BNE CODE_02A936
    LDX.B _F
ADDR_02A92A:
; For the goal tape, if no slot was found, find a replaceable sprite to spawn over.
    LDA.W SpriteTweakerD,X                    ; (replaceable = in main sprite range, and not invincible to star/cape/fire/etc.)
    AND.B #$02
    BEQ CODE_02A93C
    DEX
    CPX.B _6
    BNE ADDR_02A92A
CODE_02A936:
    LDX.B _2                                  ; Could not find a slot, don't spawn.
    STZ.W SpriteLoadStatus,X                  ; Allow sprite to be reloaded by level loading routine
    RTS

CODE_02A93C:
    LDY.B _3                                  ; Found a sprite slot to spawn in.
    LDA.B ScreenMode                          ; \ Branch if horizontal level
    LSR A                                     ; |; Branch if in a horizontal level.
    BCC CODE_02A95B                           ; /
    LDA.B [SpriteDataPtr],Y                   ; \ Vertical level:
    PHA                                       ; | Same as below with X and Y coords swapped; Store low X position.
    AND.B #$F0                                ; |
    STA.B SpriteXPosLow,X                     ; |
    PLA                                       ; |
    AND.B #$0D                                ; |; Store high X (with extra bits).
    STA.W SpriteXPosHigh,X                    ; |
    LDA.B _0                                  ; |
    STA.B SpriteYPosLow,X                     ; |; Store Y position as the spawn region's location.
    LDA.B _1                                  ; |
    STA.W SpriteYPosHigh,X                    ; |
    BRA +                                     ; /

CODE_02A95B:
    LDA.B [SpriteDataPtr],Y                   ; Byte format: YYYYEEsy; Horizontal level.
    PHA                                       ; \ Bits 11110000 are low byte of Y position; Set the low Y position.
    AND.B #$F0                                ; |
    STA.B SpriteYPosLow,X                     ; /
    PLA                                       ; \ Bits 00001101 are high byte of Y position
    AND.B #$0D                                ; | (Extra bits are stored in Y position); Set the high Y position (with extra bits).
    STA.W SpriteYPosHigh,X                    ; /
    LDA.B _0                                  ; \ X position = adjusted screen boundary
    STA.B SpriteXPosLow,X                     ; |; Store X position as the spawn region's location.
    LDA.B _1                                  ; |
    STA.W SpriteXPosHigh,X                    ; /
  + INY                                       ; Done with horizontal/vertical level business.
    INY
    LDA.B _4                                  ; \ Sprite status = ??; Store the sprite's initial state.
    STA.W SpriteStatus,X                      ; /
    CMP.B #$09
    LDA.B [SpriteDataPtr],Y                   ;KKOOPA STORAGE???
    BCC +                                     ;NO, IT WAS STATIONARY
    SEC                                       ; Get the sprite ID to spawn (and fix the IDs for sprites DA-DF, the shells).
    SBC.B #$DA                                ;SUBTRACT DA, FIRST SHELL SPRITE [RED]
    CLC
    ADC.B #$04
  + PHY
    LDY.W OWLevelTileSettings+$49
    BPL CODE_02A996                           ;IF POSITIBE, JUST STORE?
    CMP.B #$04
    BNE +
    LDA.B #$07                                ;WHAT?; Store the sprite ID.
  + CMP.B #$05                                ; If the Special World is passed, turn green and red Koopas into yellow and blue.
    BNE CODE_02A996
    LDA.B #$06                                ;STORING RED KOOPA SHELL TO SPRITENUM
CODE_02A996:
    STA.B SpriteNumber,X
    PLY
    LDA.B _2                                  ; \ $161A,x = index of the sprite in the level; Store the sprite's load status index.
    STA.W SpriteLoadIndex,X                   ; / (Number of sprites in level, not just onscreen)
    LDA.W SilverPSwitchTimer
    BEQ CODE_02A9C9
    PHX
    LDA.B SpriteNumber,X
    TAX                                       ; Initialize the sprite's data.
    LDA.L Sprite190FVals,X                    ; If the silver P-switch is active and it's set to change into a coin, do so.
    PLX
    AND.B #$40
    BNE CODE_02A9C9
    LDA.B #$21                                ; \ Sprite = Moving Coin; Sprite to turn sprites into when a silver P-switch is active.
    STA.B SpriteNumber,X                      ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    JSL InitSpriteTables
    LDA.W SpriteOBJAttribute,X
    AND.B #$F1                                ; Make the coin silver.
    ORA.B #$02
    STA.W SpriteOBJAttribute,X
    BRA +

CODE_02A9C9:
    JSL InitSpriteTables                      ; Reset sprite tables
  + LDA.B #$01                                ; \ Set off screen horizontally; Set as initially offscreen.
    STA.W SpriteOffscreenX,X                  ; /
    LDA.B #$04                                ; \ ?? $1FE2,X = #$04; Prevent showing a water splash on spawn if in water.
    STA.W SpriteMisc1FE2,X                    ; /
    INY
    LDX.B _2
    INX                                       ; All done, move on to check the next sprite in the data.
    JMP LoadSpriteLoopStrt

FindFreeSlotLowPri:
; Routine to find an empty sprite slot, starting from the highest usable slot, minus 2. Returns it in Y.
    LDA.B #$02                                ; \ Number of slots to leave free = 2; Exclusively used for generators, since they don't always need to spawn a sprite.
    STA.B _E                                  ; |
    BRA +                                     ; /

FindFreeSprSlot:
    STZ.B _E                                  ; Number of slots tp leave free = 0; Routine to find an empty sprite slot, starting from highest usable slot. Returns in Y.
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
    LDA.W SpriteSlotMax,Y                     ; |; Get the range of slots to work with.
    SEC                                       ; |
    SBC.B _E                                  ; |
    TAY                                       ; |
CODE_02A9FE:
    LDA.W SpriteStatus,Y                      ; | If free slot...
    BEQ Return02AA0A                          ; |  ...return
    DEY                                       ; |; Loop through until an empty slot is found.
    CPY.B _F                                  ; |; If none are found, returns #$FF in Y.
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
; Positions for Boos in the reappearing ghosts generator, set 1. Format: $xy.
; Positions for Boos in the reappearing ghosts generator, set 2. Format: $xy.
; Swooper ceiling INIT
    LDX.B #$0E                                ; \ Unreachable; Number of bats to spawn.
  - STZ.W ClusterSpriteMisc1E66,X             ; | Loop X = 00 to 0E; Clear initial X speed.
    STZ.W ClusterSpriteMisc0F86,X             ; Mark Boo as translucent.
    LDA.B #$08                                ; Set cluster sprite number for the Boo.
    STA.W ClusterSpriteNumber,X
    JSL GetRand
    CLC
    ADC.B Layer1XPos
    STA.W ClusterSpriteXPosLow,X              ; Spawn at a random X position onscreen,
    STA.W ClusterSpriteMisc0F4A,X             ; with a random initial direction.
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W ClusterSpriteXPosHigh,X
    LDY.B _3
    LDA.B [SpriteDataPtr],Y
    PHA
    AND.B #$F0                                ; Spawn at the Y position from data.
    STA.W ClusterSpriteYPosLow,X
    PLA
    AND.B #$01
    STA.W ClusterSpriteYPosHigh,X
    DEX                                       ; Loop for all the Swoopers.
    BPL -
    RTS                                       ; /


DATA_02AA68:
    db $50,$90,$D0,$10

CODE_02AA6C:
; X positions for each of the castle candle flames.
; Castle candle flames INIT
    LDA.B #$07                                ; Mark sprite as invisible ("in Yoshi's mouth), but still loaded.
    STA.W SpriteStatus+3
    LDX.B #$03                                ; Number of flames to spawn.
  - LDA.B #$05                                ; Set cluster sprite number.
    STA.W ClusterSpriteNumber,X
    %LorW_X(LDA,DATA_02AA68)
    STA.W ClusterSpriteXPosLow,X              ; Set X position for the flame.
    LDA.B #$F0                                ; Y position for the flame.
    STA.W ClusterSpriteYPosLow,X
    TXA
    ASL A                                     ; Set the initial animation frame for the flame.
    ASL A
    STA.W ClusterSpriteMisc0F4A,X
    DEX                                       ; Loop for all the flames.
    BPL -
    RTS

CODE_02AA8D:
    STZ.W BooCloudTimer                       ; Reappearing ghosts INIT
    LDX.B #$13                                ; Number of ghosts to spawn.
  - LDA.B #$07                                ; Store the cluster sprite number.
    STA.W ClusterSpriteNumber,X
    LDA.W DATA_02AA0B,X
    PHA
    AND.B #$F0
    STA.W ClusterSpriteMisc1E66,X
    PLA                                       ; Set the first reappearance position.
    ASL A                                     ; (the first "configuration")
    ASL A
    ASL A
    ASL A
    STA.W ClusterSpriteMisc1E52,X
    LDA.W DATA_02AA1F,X
    PHA
    AND.B #$F0
    STA.W ClusterSpriteMisc1E8E,X
    PLA                                       ; Set the second reappearance position.
    ASL A                                     ; (the second "configuration")
    ASL A
    ASL A
    ASL A
    STA.W ClusterSpriteMisc1E7A,X
    DEX                                       ; Loop for all the Boos.
    BPL -
    RTS

  - JMP CODE_02AA33                           ; Swooper ceiling INIT (redirect)

CODE_02AAC0:
    LDY.B #$01                                ; Cluster sprite INIT redirects (sprites E1-E6).
    STY.W ActivateClusterSprite
    CMP.B #$E4                                ; Branch if sprite E4 - the Swooper ceiling.
    BEQ -
    CMP.B #$E6                                ; Branch if sprite E6 - the candle flames.
    BEQ CODE_02AA6C
    CMP.B #$E5                                ; Branch if sprite E5 - the reappearing Boos.
    BEQ CODE_02AA8D
    CMP.B #$E2                                ; Branch if sprite E2/E3 - the Boo circles.
    BCS CODE_02AB11
; Boo ceiling INIT
    LDX.B #$13                                ; Number of Boos to spawn.
  - STZ.W ClusterSpriteMisc1E66,X             ; Clear initial X speed.
    STZ.W ClusterSpriteMisc0F86,X             ; Mark Boo as translucent.
    LDA.B #$03                                ; Set cluster sprite number for the Boo.
    STA.W ClusterSpriteNumber,X
    JSL GetRand
    CLC
    ADC.B Layer1XPos
    STA.W ClusterSpriteXPosLow,X              ; Spawn at a random X position onscreen,
    STA.W ClusterSpriteMisc0F4A,X             ; with a random initial direction.
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W ClusterSpriteXPosHigh,X
    LDA.W RandomNumber+1
    AND.B #$3F
    ADC.B #$08
    CLC
    ADC.B Layer1YPos                          ; Spawn at a random Y position onscreen.
    STA.W ClusterSpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W ClusterSpriteYPosHigh,X
    DEX                                       ; Loop for all the Boos.
    BPL -
    INC.W BooRingIndex                        ; Limit Boo rings to only allow the second ring.
    RTS

CODE_02AB11:
    LDY.W BooRingIndex                        ; Boo ring INIT
    CPY.B #$02                                ; Return if more than two rings are on-screen.
    BCS Return02AB77
    LDY.B #$01                                ; Boo ring speed, clockwise.
    CMP.B #$E2
    BEQ +
    LDY.B #$FF                                ; Boo ring speed, counter-clockwise.
  + STY.B _F
    LDA.B #$09                                ; Number of Boos to spawn.
    STA.B _E
    LDX.B #$13
CODE_02AB28:
; Boo Ring spawn loop.
    LDA.W ClusterSpriteNumber,X               ; Skip if not an empty cluster sprite slot.
    BNE CODE_02AB71
    LDA.B #$04                                ; Cluster sprite to spawn in the ring.
    STA.W ClusterSpriteNumber,X
    LDA.W BooRingIndex                        ; Store ring number.
    STA.W ClusterSpriteMisc0F86,X
    LDA.B _E                                  ; Store the Boo's position in the ring.
    STA.W ClusterSpriteMisc0F72,X
    LDA.B _F
    STA.W ClusterSpriteMisc0F4A,X             ; Store the Boo's rotational speed, for ONLY the "base" ghost. All others have a speed of 0 (because they inherit from it).
    STZ.B _F                                  ; Additionally, skip all the below code except for that "base" ghost.
    BEQ +
    LDY.B _3
    LDA.B [SpriteDataPtr],Y
    LDY.W BooRingIndex
    PHA
    AND.B #$F0
    STA.W BooRingYPosLow,Y
    PLA                                       ; Set the center X/Y position for the ring.
    AND.B #$01
    STA.W BooRingYPosHigh,Y
    LDA.B _0
    STA.W BooRingXPosLow,Y
    LDA.B _1
    STA.W BooRingXPosHigh,Y
    LDA.B #$00                                ; Reset the ring's "offscreen" flag.
    STA.W BooRingOffscreen,Y
    LDA.B _2                                  ; Store the load status index for the ring; never used, though.
    STA.W BooRingLoadIndex,Y
; Not the "base" Boo.
  + DEC.B _E                                  ; If done spawning Boos, return.
    BMI CODE_02AB74
CODE_02AB71:
    DEX                                       ; Loop through the usable cluster sprite slots.
    BPL CODE_02AB28
CODE_02AB74:
    INC.W BooRingIndex                        ; Increase counter for the number of rings spawned.
Return02AB77:
    RTS

LoadShooter:
; Spawning sprites C9 or CA (shooters).
    STX.B _2                                  ; $02 = X = load status index ($1938)
    DEY                                       ; $03 = Y = data index ($CE)
    STY.B _3                                  ; $04 = A = sprite ID
    STA.B _4
    LDX.B #$07
CODE_02AB81:
    LDA.W ShooterNumber,X
    BEQ CODE_02AB9E
    DEX
    BPL CODE_02AB81
    DEC.W ShooterSlotIdx                      ; Find an empty shooter sprite slot,
    BPL +                                     ; and overwrite one if none found.
    LDA.B #$07
    STA.W ShooterSlotIdx
  + LDX.W ShooterSlotIdx
    LDY.W ShooterLoadIndex,X
    LDA.B #$00                                ; \ Allow sprite to be reloaded by level loading routine
    STA.W SpriteLoadStatus,Y                  ; /
CODE_02AB9E:
    LDY.B _3
    LDA.B _4
    SEC                                       ; Set the shooter number (ID - #$C8).
    SBC.B #$C8
    STA.W ShooterNumber,X
    LDA.B ScreenMode
    LSR A                                     ; Branch if Layer 1 is horizontal.
    BCC CODE_02ABC7
    LDA.B [SpriteDataPtr],Y
    PHA
    AND.B #$F0
    STA.W ShooterXPosLow,X                    ; Set X position from data.
    PLA
    AND.B #$01
    STA.W ShooterXPosHigh,X
    LDA.B _0
    STA.W ShooterYPosLow,X                    ; Set Y position from data loaded earlier.
    LDA.B _1
    STA.W ShooterYPosHigh,X
    BRA +

CODE_02ABC7:
    LDA.B [SpriteDataPtr],Y                   ; Shooter in a horizontal Layer 1 level.
    PHA
    AND.B #$F0
    STA.W ShooterYPosLow,X                    ; Set Y position from data.
    PLA
    AND.B #$01
    STA.W ShooterYPosHigh,X
    LDA.B _0
    STA.W ShooterXPosLow,X                    ; Set X position from data loaded earlier.
    LDA.B _1
    STA.W ShooterXPosHigh,X
  + LDA.B _2                                  ; Store load status index (not that the original game ever uses it...).
    STA.W ShooterLoadIndex,X
    LDA.B #$10                                ; Amount of time before the shooter first shoots.
    STA.W ShooterTimer,X
    INY
    INY                                       ; Return to load the next sprite from data.
    INY                                       ; NOTE: this actually *SHOULD NOT HAPPEN*!!! this routine should just RTS instead.
    LDX.B _2                                  ; as is, this may cause the game to load additional sprite data that was not intended to be loaded.
    INX
    JMP LoadSpriteLoopStrt

CODE_02ABF2:
; Routine to clear out sprite load status tables and clear RAM addresses $1693-$190D.
    LDX.B #$3F                                ; Also handles retaining carried sprites between levels.
  - STZ.W SpriteLoadStatus,X                  ; Allow sprite to be reloaded by level loading routine; Clear out the sprite load status table (or half of it, at least).
    DEX
    BPL -
    LDA.B #$FF
    STA.B _0
    LDX.B #$0B
CODE_02AC00:
    LDA.B #$FF                                ; \ Set to permanently erase sprite; Clear out load status indices for all the sprite slots.
    STA.W SpriteLoadIndex,X                   ; /
    LDA.W SpriteStatus,X
    CMP.B #$0B
    BEQ CODE_02AC11
    STZ.W SpriteStatus,X                      ; Erase all non-carried sprites.
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
    STA.B SpriteXPosLow                       ; If a sprite is being carried, respawn it in slot 0.
    LDA.W SpriteXPosHigh,X                    ; In regards to double-grab: only the lowest carried slot is respawned.
    STA.W SpriteXPosHigh                      ; Higher slots retain all their data.
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
  - STZ.W Map16TileNumber,X                   ; clear ram before entering new stage/area; Clear out RAM addresses $1693-$190D (on level load).
    DEX
    BPL -
    SEP #$10                                  ; XY->8
    STZ.W Layer1ScrollCmd                     ; Disable sprite scroll commands.
    STZ.W Layer2ScrollCmd
    RTS

CODE_02AC5C:
    LDA.B ScreenMode                          ; Routine that spawns sprites on-screen during level load. Spawns from -06 to +0A.
    LSR A                                     ; Branch if in a horizontal level (not vertical).
    BCC CODE_02ACA1
    LDA.B Layer1ScrollDir
    PHA
    LDA.B #$01
    STA.B Layer1ScrollDir
    LDA.B Layer1YPos
    PHA
    SEC
    SBC.B #$60
    STA.B Layer1YPos                          ; Start searching for sprites 6 tiles above the screen.
    LDA.B Layer1YPos+1
    PHA
    SBC.B #$00
    STA.B Layer1YPos+1
    STZ.W TileGenerateTrackB
  - JSR CODE_02A802                           ; Spawn sprites on that row. Run twice for some reason; not sure if necessary.
    JSR CODE_02A802
    LDA.B Layer1YPos
    CLC
    ADC.B #$10
    STA.B Layer1YPos
    LDA.B Layer1YPos+1
    ADC.B #$00                                ; Loop for x20 (32) tiles.
    STA.B Layer1YPos+1
    INC.W TileGenerateTrackB
    LDA.W TileGenerateTrackB
    CMP.B #$20
    BCC -
    PLA
    STA.B Layer1YPos+1
    PLA                                       ; Restore camera position.
    STA.B Layer1YPos
    PLA
    STA.B Layer1ScrollDir
    RTS

CODE_02ACA1:
    LDA.B Layer1ScrollDir                     ; Horizontal level.
    PHA
    LDA.B #$01
    STA.B Layer1ScrollDir
    LDA.B Layer1XPos
    PHA
    SEC
    SBC.B #$60
    STA.B Layer1XPos                          ; Start searching for sprites 6 tiles left of the screen.
    LDA.B Layer1XPos+1
    PHA
    SBC.B #$00
    STA.B Layer1XPos+1
    STZ.W TileGenerateTrackB
  - JSR CODE_02A802                           ; Spawn sprites in that column. Run twice for some reason; not sure if necessary.
    JSR CODE_02A802
    LDA.B Layer1XPos
    CLC
    ADC.B #$10
    STA.B Layer1XPos
    LDA.B Layer1XPos+1
    ADC.B #$00                                ; Loop for x20 (32) tiles.
    STA.B Layer1XPos+1
    INC.W TileGenerateTrackB
    LDA.W TileGenerateTrackB
    CMP.B #$20
    BCC -
    PLA
    STA.B Layer1XPos+1
    PLA                                       ; Restore camera position.
    STA.B Layer1XPos
    PLA
    STA.B Layer1ScrollDir
    RTS

CODE_02ACE1:
    PHX                                       ; Variant of the below routine that spawns a spawns a score sprite at the sprite slot in Y.
    TYX
    BRA +

GivePoints:
; Routine (JSL) to give points to the player. Amount to give is in A. (100 - 200 - 400... at 8, 1ups start)
    PHX                                       ;  takes sprite type -5 as input in A; X contains the slot of the sprite you want to spawn the score sprite at.
  + CLC
    ADC.B #$05                                ; Add 5 to sprite type (200,400,1up)
    JSL CODE_02ACEF                           ; Set score sprite type/initial position
    PLX
    RTL

CODE_02ACEF:
    PHY                                       ;  - note coordinates are level coords, not screen; Routine (JSL) to generate score sprites (including life/coin sprites). Sprite to spawn is in A.
    PHA                                       ;    sprite type 1=10,2=20,3=40,4=80,5=100,6=200,7=400,8=800,9=1000,A=2000,B=4000,C=8000,D=1up
    JSL CODE_02AD34                           ; Get next free position in table($16E1) to add score sprite; Find an empty score sprite slot to spawn into.
    PLA
    STA.W ScoreSpriteNumber,Y                 ; Set score sprite type (200,400,1up, etc)
    LDA.B SpriteYPosLow,X                     ; Load y position of sprite jumped on
    SEC
    SBC.B #$08                                ;   - make the score sprite appear a little higher
    STA.W ScoreSpriteYPosLow,Y                ; Set this as score sprite y-position; Set at the sprite's Y position.
    PHA                                       ; save that value
    LDA.W SpriteYPosHigh,X                    ; Get y-pos high byte for sprite jumped on
    SBC.B #$00
    STA.W ScoreSpriteYPosHigh,Y               ; Set score sprite y-pos high byte
    PLA                                       ; restore score sprite y-pos to A
    SEC                                       ; \
    SBC.B Layer1YPos                          ; |
    CMP.B #$F0                                ; |if (score sprite ypos <1C && >=0C)
    BCC +                                     ; |{
    LDA.W ScoreSpriteYPosLow,Y                ; |; If the sprite is being spawned above the screen,
    ADC.B #$10                                ; |; push it down a tile so it's onscreen.
    STA.W ScoreSpriteYPosLow,Y                ; |  move score sprite down by #$10
    LDA.W ScoreSpriteYPosHigh,Y               ; |
    ADC.B #$00                                ; |
    STA.W ScoreSpriteYPosHigh,Y               ; /}
  + LDA.B SpriteXPosLow,X                     ; \
    STA.W ScoreSpriteXPosLow,Y                ; /Set score sprite x-position; Set at the sprite's X position.
    LDA.W SpriteXPosHigh,X                    ; \
    STA.W ScoreSpriteXPosHigh,Y               ; /Set score sprite x-pos high byte
    LDA.B #$30                                ; \; Number of frames the score sprite lasts for.
    STA.W ScoreSpriteTimer,Y                  ; /scoreSpriteSpeed = #$30
    PLY
    RTL

CODE_02AD34:
    LDY.B #$05                                ; (here css is used to index through the table of score sprites in table at $16E1; Subroutine to find a score sprite slot.
CODE_02AD36:
    LDA.W ScoreSpriteNumber,Y                 ; for (css=5;css>=0;css--){
    BEQ Return02AD4B                          ;  if (css's type == 0)      --check for empty space
    DEY                                       ; Loop through the slots and find an empty one.
    BPL CODE_02AD36                           ; }; If no empty slots exist, replace one instead.
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
; Tiles used for the score sprites (left half). First byte unused.
; Tiles used for the score sprites (right half). First byte unused.
; Low byte of the score each sprite gives (divided by 10).
; High byte of the score each sprite gives (divided by 10).
; Speeds for the score sprite to travel (aka number of frames to wait before moving 1 pixel)
; Index is the high byte of the sprite's frame counter.
; OAM indices for the six score sprites, except in Reznor/Morton/Roy's rooms.
    BIT.W IRQNMICommand                       ; Routine to handle score sprites (including lives and coins).
    BVC CODE_02ADB8
    LDA.W IRQNMICommand
    CMP.B #$C1                                ; If in Bowser's battle, return and don't handle score sprites.
    BEQ Return02ADC8                          ; If in Reznor/Morton/Roy's battles, hide the last-active score sprite.
    LDA.B #$F0
    STA.W OAMTileYPos+4
    STA.W OAMTileYPos+8
CODE_02ADB8:
    LDX.B #$05
CODE_02ADBA:
    STX.W CurSpriteProcess
    LDA.W ScoreSpriteNumber,X                 ; Loop through all the score sprites
    BEQ +                                     ; and run the below routine for each.
    JSR CODE_02ADC9
  + DEX
    BPL CODE_02ADBA
Return02ADC8:
    RTS

CODE_02ADC9:
    LDA.B SpriteLock                          ; Score sprite MAIN routine.
    BEQ +                                     ; If the game is frozen, skip down to just draw graphics.
    JMP CODE_02AE5B
  + LDA.W ScoreSpriteTimer,X
    BNE +                                     ; If the sprite is still active, run its routine. Else, erase.
    STZ.W ScoreSpriteNumber,X
    RTS

DATA_02ADD9:
    db $01,$02,$03,$05,$05,$0A,$0F,$14
    db $19

DATA_02ADE2:
    db $04,$06

; Number of lives to give (1up, 2-up, 3-up/moon, 5-up)
; Number of coins to give (unused; 5, 10, 15, 20, and 25 coin sprites)
; Attributes of 2-up and 3-up sprites. The unused 5-up/coin sprites continue past this.
  + DEC.W ScoreSpriteTimer,X                  ; Main score sprite routine.
    CMP.B #$2A                                ; Handle timer, and branch down if not time to actually give points yet.
    BNE CODE_02AE38
    LDY.W ScoreSpriteNumber,X
    CPY.B #$0D                                ; If giving points (y = 00 - 0C), branch.
    BCC CODE_02AE12
    CPY.B #$11                                ; If giving 1ups (y = 0D - 10), branch.
    BCC CODE_02AE03
    PHX                                       ; Else, giving coins (y = 11 - 15) [unused].
    PHY
    LDA.W DATA_02ADE2-$16,Y                   ; Hey, this label might be wrong!; Add the coins to Mario's coin count.
    JSL ADDR_05B329
    PLY
    PLX
    BRA CODE_02AE12                           ; Also give points (glitched).

CODE_02AE03:
    LDA.W DATA_02ADE2-$16,Y                   ; Hey, this label might be wrong!; Giving lives.
    CLC
    ADC.W GivePlayerLives                     ; Give Mario the corresponding number of lives.
    STA.W GivePlayerLives
    STZ.W GiveLivesTimer
    BRA +

CODE_02AE12:
    LDA.W PlayerTurnLvl                       ; Giving points.
    ASL A
    ADC.W PlayerTurnLvl
    TAX
    LDA.W PlayerScore,X
    CLC
    ADC.W PointMultiplierLo,Y                 ; Increase the current player's score by the corresponding amount.
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
    TAY                                       ; Handle vertical movement of the sprite.
    LDA.B TrueFrame                           ; Works by waiting a certain number of frames before moving upwards one pixel.
    AND.W PointSpeedY,Y
    BNE CODE_02AE5B
    LDA.W ScoreSpriteYPosLow,X
    TAY
    SEC                                       ; Don't move the sprite upwards if near the top of the screen (to avoid looping).
    SBC.B Layer1YPos
    CMP.B #$04
    BCC CODE_02AE5B
    DEC.W ScoreSpriteYPosLow,X
    TYA
    BNE CODE_02AE5B
    DEC.W ScoreSpriteYPosHigh,X
CODE_02AE5B:
    LDA.W ScoreSpriteLayer,X                  ; Score sprite GFX routine.
    ASL A
    ASL A
    TAY                                       ; $02 = layer Y position
    REP #$20                                  ; A->16; $04 = layer X position
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
    SBC.B _5                                  ; Return if the sprite is horizontally offscreen.
    PLP                                       ; Accounts for both sides of the sprite, so not even a single pixel can be offscreen.
    ADC.B #$00
    BNE Return02AEFB
    LDA.W ScoreSpriteXPosLow,X
    CMP.B _4
    LDA.W ScoreSpriteXPosHigh,X
    SBC.B _5
    BNE Return02AEFB
    LDA.W ScoreSpriteYPosLow,X
    CMP.B _2
    LDA.W ScoreSpriteYPosHigh,X               ; Return if the sprite is vertically offscreen.
    SBC.B _3
    BNE Return02AEFB
    LDY.W DATA_02AD9E,X
    BIT.W IRQNMICommand                       ; Get OAM index.
    BVC +                                     ; In Reznor/Morton/Roy, use a special index.
    LDY.B #$04
  + LDA.W ScoreSpriteYPosLow,X
    SEC
    SBC.B _2                                  ; Store the Y position.
    STA.W OAMTileYPos,Y
    STA.W OAMTileYPos+4,Y
    LDA.W ScoreSpriteXPosLow,X
    SEC
    SBC.B _4
    STA.W OAMTileXPos,Y                       ; Store the X position.
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+4,Y
    PHX
    LDA.W ScoreSpriteNumber,X
    TAX
    %LorW_X(LDA,PointTile1)
    STA.W OAMTileNo,Y                         ; Store the tile number.
    %LorW_X(LDA,PointTile2)
    STA.W OAMTileNo+4,Y
    PLX
    PHY
    LDY.W ScoreSpriteNumber,X
    CPY.B #$0E
    LDA.B #$08                                ; 1up and score sprite YXPPCCCT.
    BCC +
    LDA.W DATA_02ADD9-5,Y                     ; Hey, this label might be wrong!; Store the YXPPCCT.
  + PLY                                       ; 2ups and 3ups get special palettes (and 5up+ get glitchy values).
    ORA.B #$30
    STA.W OAMTileAttr,Y
    STA.W OAMTileAttr+4,Y
    TYA
    LSR A
    LSR A
    TAY                                       ; Set size as 8x8.
    LDA.B #$00
    STA.W OAMTileSize,Y
    STA.W OAMTileSize+1,Y
    LDA.W ScoreSpriteNumber,X
    CMP.B #$11                                ; Branch if handling a coin sprite (to add an extra tile for the coin).
    BCS +
Return02AEFB:
    RTS

; Score sprite is adding coins, so add the coin icon to it.
  + LDY.B #$4C                                ; OAM index (from $0200) for the coin icon on score sprites.
    LDA.W ScoreSpriteXPosLow,X
    SEC
    SBC.B _4                                  ; Set X position.
    SEC
    SBC.B #$08
    STA.W OAMTileXPos,Y
    LDA.W ScoreSpriteYPosLow,X
    SEC                                       ; Set Y position.
    SBC.B _2
    STA.W OAMTileYPos,Y
    LDA.B #$5F                                ; Tile to use for the coin icon.
    STA.W OAMTileNo,Y
    LDA.B #$04
    ORA.B #$30                                ; Set YXPPCCCT.
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A                                     ; Set size as 8x8.
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    RTS

    STZ.W ScoreSpriteNumber,X                 ; \ Unreachable; Unused routine to erase a score sprite.
    RTS                                       ; /


DATA_02AF2D:
    db $00,$AA,$54

DATA_02AF30:
    db $00,$00,$01

Load3Platforms:
; Low bytes of the initial angles for the three chained platforms.
; High bits of the initial angles for the three chained platforms.
    LDY.B _3                                  ; 3 Platforms on Chains MAIN
    LDA.B [SpriteDataPtr],Y
    PHA
    AND.B #$F0                                ; $00 = 16-bit base X position (from spawn routine)
    STA.B _8                                  ; $08 = 16-bit base Y position
    PLA
    AND.B #$01
    STA.B _9
    LDA.B #$02                                ; Number of platforms to spawn.
    STA.B _4
CODE_02AF45:
    JSL FindFreeSprSlot                       ; \ Return if no free slots; Return if no sprite slots are available.
    BMI Return02AF86                          ; /
    TYX
    LDA.B #$01                                ; \ Sprite status = Initialization
    STA.W SpriteStatus,X                      ; /
    LDA.B #$A3                                ; \ Sprite = Grey Platform on Chain; Sprite to spawn (gray platform).
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables
    LDA.B _0
    STA.B SpriteXPosLow,X
    LDA.B _1
    STA.W SpriteXPosHigh,X                    ; Store X/Y position.
    LDA.B _8
    STA.B SpriteYPosLow,X
    LDA.B _9
    STA.W SpriteYPosHigh,X
    LDY.B _4
    LDA.W DATA_02AF2D,Y
    STA.W SpriteMisc1602,X                    ; Store initial angle of the platform.
    LDA.W DATA_02AF30,Y
    STA.W SpriteMisc151C,X
    CPY.B #$02
    BNE +                                     ; Store load status index, but only for the "base" platform of the trio.
    LDA.B _2
    STA.W SpriteLoadIndex,X
  + DEC.B _4                                  ; Loop for all the platforms.
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
; Initial X offsets (lo) for each Eerie in the group of 5.
; Initial X offsets (hi) for each Eerie in the group of 5.
; Initial Y speeds for each Eerie in the group of 5.
; Initial directions of acceleration for each Eerie in the group. Should match with Y speeds above.
; X speeds to assign all 5 Eeries in the group.
    LDY.B _3                                  ; Group of 5 Eeries MAIN
    LDA.B [SpriteDataPtr],Y
    PHA
    AND.B #$F0                                ; $00 = 16-bit base X position (from spawn routine)
    STA.B _8                                  ; $08 = 16-bit base Y position
    PLA
    AND.B #$01
    STA.B _9
    LDA.B #$04                                ; Number of Eeries to spawn.
    STA.B _4
CODE_02AFAF:
    JSL FindFreeSprSlot                       ; \ Return if no free slots; Return if no sprite slots are available.
    BMI Return02AFFD                          ; /
    TYX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$39                                ; \ Sprite = Wave Eerie; Sprite to spawn (wave Eerie).
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables
    LDY.B _4
    LDA.B _0
    CLC
    ADC.W EerieGroupDispXLo,Y                 ; Store X position, offset from the spawn position.
    STA.B SpriteXPosLow,X
    LDA.B _1
    ADC.W EerieGroupDispXHi,Y
    STA.W SpriteXPosHigh,X
    LDA.B _8
    STA.B SpriteYPosLow,X                     ; Store Y position.
    LDA.B _9
    STA.W SpriteYPosHigh,X
    LDA.W EerieGroupSpeedY,Y                  ; Store initial Y speed.
    STA.B SpriteYSpeed,X
    LDA.W EerieGroupState,Y                   ; Store initial direction of acceleration.
    STA.B SpriteTableC2,X
    CPY.B #$04
    BNE +                                     ; Store load status index, but only for the "base" platform of the trio.
    LDA.B _2
    STA.W SpriteLoadIndex,X
  + JSR SubHorzPosBnk2
    LDA.W EerieGroupSpeedX,Y                  ; Aim towards Mario.
    STA.B SpriteXSpeed,X
    DEC.B _4                                  ; Loop for all the Eeries.
    BPL CODE_02AFAF
Return02AFFD:
    RTS

CallGenerator:
; Routine to handle the currently active generator.
    LDA.W CurrentGenerator                    ; Return if no generator is active.
    BEQ +
    LDY.B SpriteLock                          ; Return if the game is frozen.
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

; Generator MAIN pointers.
; 1 - CB - Eeries
; 2 - CC - Para-Goombas
; 3 - CD - Para-Bombs
; 4 - CE - Para-Goombas and Para-Bombs
; 5 - CF - Dolphins, left
; 6 - D0 - Dolphins, right
; 7 - D1 - Jumping fish
; 8 - D2 - Turn off generator 2
; 9 - D3 - Super Koopas
; A - D4 - Bubbles
; B - D5 - Bullet Bills, sides
; C - D6 - Bullet Bills, surrounded
; D - D7 - Bullet Bills, diagonal
; E - D8 - Bowser Statue fire
  + RTS                                       ; F - D9 - Turn off generators

TurnOffGen2:
; Turn off generator 2 MAIN
    INC.W SpriteWillAppear                    ; Freeze the timers for disappearing/reappearing sprites.
    STZ.W SpriteRespawnTimer                  ; Don't respawn any sprites
    RTS

TurnOffGenerators:
; Turn off generators MAIN
    STZ.W CurrentGenerator                    ; Disable the active generator.
    RTS

GenerateFire:
    LDA.B EffFrame                            ; Bowser Statue fire generator MAIN
    AND.B #$7F                                ; Return if not time to spawn a fire.
    BNE +
    JSL FindFreeSlotLowPri                    ; Return if there are no free sprite slots.
    BMI +
    TYX
    LDA.B #!SFX_FIRESPIT                      ; \ Play sound effect; SFX for the Bowser statue fire generator spawning a flame.
    STA.W SPCIO3                              ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$B3                                ; \ Sprite = Bowser's Statue Fireball; Sprite to spawn (Bowser statue fireball)
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables
    JSL GetRand
    AND.B #$7F
    ADC.B #$20
    ADC.B Layer1YPos
    AND.B #$F0                                ; Set spawn Y at a random position on the screen.
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B Layer1XPos
    CLC
    ADC.B #$FF
    STA.B SpriteXPosLow,X                     ; Set spawn X at the right side of the screen.
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    INC.W SpriteMisc157C,X                    ; Face the flame left.
  + RTS

GenerateBullet:
    LDA.B EffFrame                            ; Side Bullet Bill generator MAIN
    AND.B #$7F                                ; |; Return if not time to spawn a bullet.
    BNE +                                     ; /
    JSL FindFreeSlotLowPri                    ; Return if there are no free sprite slots.
    BMI +
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect; SFX for the bullet bill generator spawning a bullet.
    STA.W SPCIO3                              ; /
    TYX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$1C                                ; \ Sprite = Bullet Bill; Sprite to spawn (bullet bill).
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables
    JSL GetRand
    PHA
    AND.B #$7F
    ADC.B #$20
    ADC.B Layer1YPos                          ; Set spawn Y at a random position on the screen.
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
    ADC.W DATA_02B1B8,Y                       ; Set spawn X randomly on either side of the screen.
    STA.B SpriteXPosLow,X
CODE_02B0BD:
    LDA.B Layer1XPos+1
CODE_02B0BF:
    ADC.W DATA_02B1BA,Y
    STA.W SpriteXPosHigh,X
    TYA                                       ; Set direction of the bullet accordingly.
    STA.B SpriteTableC2,X
  + RTS


    db $04,$08,$04,$03

GenMultiBullets:
; Ending index of the bullet directions in each pattern (for the tables at $02B0FA).
; This value minus the corresponding value in the below table determines the "starting" index.
; Number of bullets to spawn in each pattern (minus 1). First is surrounded, second is diagonal.
    LDA.B EffFrame                            ; Diagonal/surrounded Bullet Bill generator MAIN
    LSR A                                     ; Return if not a frame to spawn bullets (even frame).
    BCS Return02B0F9
    LDA.W DiagonalBulletTimer
    INC.W DiagonalBulletTimer
    CMP.B #$A0                                ; Handle timer for spawning the bullets, and return if not time to spawn them.
    BNE Return02B0F9
    STZ.W DiagonalBulletTimer
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect; SFX for spawning the bullets from the diagonal/surrounded bullet bill generators.
    STA.W SPCIO3                              ; /
    LDY.W CurrentGenerator
    LDA.W CODE_02B0BD,Y                       ; Get the number of bullets to spawn and the generator's index to the tables below.
    LDX.W CODE_02B0BF,Y
    STA.B _D
  - PHX
    JSR CODE_02B115                           ; Spawn a bullet.
    DEC.B _D
    PLX
    DEX                                       ; Loop for all the bullets in the pattern.
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
; X offsets for each of the bullets in the multi-bill generators.
; Surrounded
; Diagonal
; Y offsets for each of the bullets in the multi-bill generators.
; Surrounded
; Diagonal
; Directions of movement for each of the bullets in the multi-bil generators (see $C2 for the bullet bills)
; Surrounded
; Diagonal
; Routine to handle spawning all of the Bullet Bills for the multi-generators.
    JSL FindFreeSlotLowPri                    ; Return if no empty sprite slots left.
    BMI +
    LDA.B #$1C                                ; \ Sprite = Bullet Bill; Sprite to spawn (Bullet Bill).
    STA.W SpriteNumber,Y                      ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    TYX
    JSL InitSpriteTables
    LDX.B _D
    LDA.W DATA_02B0FA,X
    CLC
    ADC.B Layer1XPos                          ; Set X position onscreen.
    STA.W SpriteXPosLow,Y
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W SpriteXPosHigh,Y
    LDA.W DATA_02B103,X
    CLC
    ADC.B Layer1YPos
    STA.W SpriteYPosLow,Y                     ; Set Y position onscreen.
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    LDA.W DATA_02B10C,X                       ; Store direction of movement.
    STA.W SpriteTableC2,Y
  + RTS


DATA_02B153:
    db $10,$18,$20,$28

DATA_02B157:
    db $18,$1A,$1C,$1E

GenerateFish:
; Possible X offsets to the left/right of the screen for spawning the jumping fish. Should be positive values.
; Possible X speeds for spawning the jumping fish with. Should be positive values.
    LDA.B EffFrame                            ; Jumping fish generator MAIN
    AND.B #$1F                                ; Return if not time to spawn a fish.
    BNE Return02B1B7
    JSL FindFreeSlotLowPri                    ; Return if there are no free sprite slots.
    BMI Return02B1B7
    TYX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$17                                ; \ Sprite = Flying Fish; Sprite to spawn (generated fish).
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables
    LDA.B Layer1YPos
    CLC
    ADC.B #$C0
    STA.B SpriteYPosLow,X                     ; Set spawn Y position at the bottom of the screen.
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
    BPL +                                     ; Set spawn X position randomly to the left/right of the screen.
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
    BPL +                                     ; Set X speed accordingly, as well.
    EOR.B #$FF
    INC A
  + STA.B SpriteXSpeed,X
    LDA.B #$B8                                ; Initial Y speed for the jumping fish.
    STA.B SpriteYSpeed,X
Return02B1B7:
    RTS


DATA_02B1B8:
    db $E0,$10

DATA_02B1BA:
    db $FF,$01

GenSuperKoopa:
; X offsets (lo) to the sides of the screen for various generators.
; X offsets (hi) to the sides of the screen for various generators.
    LDA.B EffFrame                            ; Super Koopa generator MAIN
    AND.B #$3F                                ; Return if not time to spawn a Koopa.
    BNE +
    JSL FindFreeSlotLowPri                    ; Return if there are no free sprite slots.
    BMI +
    TYX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$71                                ; Sprite to spawn (red Super Koopa).
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    JSL GetRand
    PHA
    AND.B #$3F
    ADC.B #$20
    ADC.B Layer1YPos                          ; Set spawn Y at a random position on the screen.
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B #$28                                ; Initial Y speed for the generated Super Koopas.
    STA.B SpriteYSpeed,X
    PLA
    AND.B #$01
    TAY
    LDA.B Layer1XPos
    CLC
    ADC.W DATA_02B1B8,Y                       ; Set spawn X randomly on either side of the screen.
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.W DATA_02B1BA,Y
    STA.W SpriteXPosHigh,X
    TYA                                       ; Set initial direction accordingly.
    STA.W SpriteMisc157C,X
  + RTS

GenerateBubble:
    LDA.B EffFrame                            ; Bubble generator MAIN
    AND.B #$7F                                ; Return if not time to spawn a bubble.
    BNE Return02B259
    JSL FindFreeSlotLowPri                    ; Return if there are no free sprite slots.
    BMI Return02B259
    TYX
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$9D                                ; Sprite to spawn (bubble).
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    JSL GetRand
    PHA
    AND.B #$3F
    ADC.B #$20
    ADC.B Layer1YPos                          ; Set spawn Y at a random position on the screen.
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    PLA
    AND.B #$01
    TAY
    LDA.B Layer1XPos
    CLC
    ADC.W DATA_02B1B8,Y                       ; Set spawn X randomly on either side of the screen.
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.W DATA_02B1BA,Y
    STA.W SpriteXPosHigh,X
    TYA                                       ; Set initial direction accordingly.
    STA.W SpriteMisc157C,X
    JSL GetRand
    AND.B #$03
    TAY                                       ; Choose a random value for the contents of the bubble (00-02).
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
; Possible contents for the generated bubbles. 0 = goomba, 1 = bob-omb, 2 = fish, 3 = mushroom
; X offsets (lo) to the sides of the screen for the generated dolphins (left, right).
; X offsets (hi) to the sides of the screen for the generated dolphins (left, right).
; Initial X speeds for the generated dolphins (left, right).
; Possible initial Y speeds for the generated dolphins.
; Maximum sprite slots to spawn dolphins into for the two generators (left, right).
; Minimum sprite slots (-1) to spawn dolphins into for the two generators (left, right).
    LDA.B EffFrame                            ; Dolphin generator MAIN
    AND.B #$1F                                ; Return if not time to spawn a dolphin.
    BNE Return02B2CF
    LDY.W CurrentGenerator
    LDX.W DATA_02B263,Y
    LDA.W DATA_02B265,Y
    STA.B _0
CODE_02B27D:
; Find an empty sprite slot to spawn the dolphin into,
    LDA.W SpriteStatus,X                      ; and return if none can be found.
    BEQ CODE_02B288
    DEX
    CPX.B _0
    BNE CODE_02B27D
    RTS

CODE_02B288:
    LDA.B #$08                                ; \ Sprite status = Normal; Sprite slot is found for the dolphin.
    STA.W SpriteStatus,X                      ; /
    LDA.B #$41                                ; Sprite to spawn (dolphin, long jump)
    STA.B SpriteNumber,X
    JSL InitSpriteTables
    JSL GetRand
    AND.B #$7F
    ADC.B #$40
    ADC.B Layer1YPos                          ; Set spawn Y at a random position on the screen.
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    JSL GetRand
    AND.B #$03
    TAY                                       ; Set a random initial Y speed.
    LDA.W DATA_02B264,Y
    STA.B SpriteYSpeed,X
    LDY.W CurrentGenerator
    LDA.B Layer1XPos
    CLC
    ADC.W Return02B259,Y                      ; Set spawn X at the side of the screen (which side depends on the generator used).
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.W DATA_02B25B,Y
    STA.W SpriteXPosHigh,X
    LDA.W DATA_02B25D,Y                       ; Set X speed accordingly.
    STA.B SpriteXSpeed,X
    INC.W SpriteMisc151C,X                    ; Set the dolphin to not turn around.
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
; Initial X positions (lo) for the generated Eeries.
; Initial X positions (hi) for the generated Eeries.
    LDA.B EffFrame                            ; X speeds for the generated Eeries.
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
; Eerie generator MAIN.
; Return if not time to spawn an Eerie.
; Return if there are no free sprite slots.
; Sprite to spawn (Eerie).
; Set spawn Y at a random position on the screen.
; Set spawn X at a random side of the screen.
; Set X speed accordingly.
; Table of the sprites each Para-X generator spawns. Each generator can spawn two different sprites.
; Sprite A
; Sprite B
; Initial X speeds for the Para-X generator sprites.
; Para-Goomba/Bob-Omb generator MAIN.
; Return if not time to generate a Para-enemy.
; Return if there are no free sprite slots.
; Get the sprite to spawn.
; Set spawn Y position just above the screen.
; Set spawn X at a random side of the screen.
; Set a random initial angle.
; Set a random initial X speed.
; Routine to handle shooters.
; Return if game frozen.
; Loop through all the shooter slots and run the MAIN routine for all non-empty ones.
; Also decrement the timer for waiting to shoot every 2 frames.
; Shooter is shooting.
; Shooter MAIN pointers.
; 0 - Bullet Bill shooter
; 1 - Torpedo launcher
; 2 - Unused
; Torpedo launcher MAIN
; Return if not time to shoot.
; Time between torpedo launches.
    BNE Return02B3AA                          ; Return if vertically offscreen.
    LDA.W ShooterXPosLow,X                    ; Return if horizontally offscreen on either side.
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.B #$10
    CMP.B #$20
    BCC Return02B42C
    JSL FindFreeSlotLowPri                    ; Return if there are no empty sprite slots.
    BMI Return02B42C
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$44                                ; \ Sprite = Torpedo Ted; Sprite to spawn (Torpedo Ted).
    STA.W SpriteNumber,Y                      ; /
    LDA.W ShooterXPosLow,X                    ; \ Sprite position = Shooter position
    STA.W SpriteXPosLow,Y                     ; |
    LDA.W ShooterXPosHigh,X                   ; |
    STA.W SpriteXPosHigh,Y                    ; |; Spawn at the shooter's position.
    LDA.W ShooterYPosLow,X                    ; |
    STA.W SpriteYPosLow,Y                     ; |
    LDA.W ShooterYPosHigh,X                   ; |
    STA.W SpriteYPosHigh,Y                    ; /
    PHX
    TYX                                       ; X = sprite index
    JSL InitSpriteTables                      ; Setup sprite tables
    JSR SubHorzPosBnk2                        ; \ Direction = Towards Mario
    TYA                                       ; |; Face towards Mario.
    STA.W SpriteMisc157C,X                    ; /
    STA.B _0                                  ; $00 = sprite direction
    LDA.B #$30                                ; \ Set time to stay behind objects; Set the torpedo's timer for being spawned.
    STA.W SpriteMisc1540,X                    ; /
    PLX                                       ; X = shooter index
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_02B424:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_02B42D                           ; |; Find an empty extended sprite slot to spawn the arm sprite in,
    DEY                                       ; |; and return if none exist.
    BPL CODE_02B424                           ; |
Return02B42C:
    RTS                                       ; / Return if no free slots

CODE_02B42D:
; Extended sprite slot found.
    LDA.B #$08                                ; \ Extended sprite = Torpedo Ted arm; Extended sprite to spawn (Torpedo Ted arm).
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.W ShooterXPosLow,X
    CLC
    ADC.B #$08
    STA.W ExtSpriteXPosLow,Y                  ; Set spawn X position at the center of the shooter.
    LDA.W ShooterXPosHigh,X
    ADC.B #$00
    STA.W ExtSpriteXPosHigh,Y
    LDA.W ShooterYPosLow,X
    SEC
    SBC.B #$09
    STA.W ExtSpriteYPosLow,Y                  ; Set spawn Y position just above the shooter.
    LDA.W ShooterYPosHigh,X
    SBC.B #$00
    STA.W ExtSpriteYPosHigh,Y
    LDA.B #$90                                ; Number of frames the Torpedo Ted's arm animation lasts for.
    STA.W ExtSpriteMisc176F,Y
    PHX
    LDX.B _0
    LDA.W DATA_02B464,X                       ; Set initial "X speed" for the arm (actually used for direction).
    STA.W ExtSpriteXSpeed,Y
    PLX
    RTS


DATA_02B464:
    db $01,$FF

ShootBullet:
; "X speeds" (directions) for the Torpedo Ted arm.
; Bullet Bill shooter MAIN
    LDA.W ShooterTimer,X                      ; \ Return if it's not time to generate; Return if not time to shoot.
    BNE +                                     ; /
    LDA.B #$60                                ; \ Set time till next generation = 60; Time between bullet shots.
    STA.W ShooterTimer,X                      ; /
    LDA.W ShooterYPosLow,X                    ; \ Don't generate if off screen vertically
    CMP.B Layer1YPos                          ; |
    LDA.W ShooterYPosHigh,X                   ; |; Return if the shooter is vertically offscreen.
    SBC.B Layer1YPos+1                        ; |
    BNE +                                     ; /
    LDA.W ShooterXPosLow,X                    ; \ Don't generate if off screen horizontally
    CMP.B Layer1XPos                          ; |
    LDA.W ShooterXPosHigh,X                   ; |
    SBC.B Layer1XPos+1                        ; |
    BNE +                                     ; /
    LDA.W ShooterXPosLow,X                    ; \ ?? something else related to x position of generator??
    SEC                                       ; |; Return if the shooter is horizontally offscreen on either side.
    SBC.B Layer1XPos                          ; |
    CLC                                       ; |
    ADC.B #$10                                ; |
    CMP.B #$10                                ; |
    BCC +                                     ; /
    LDA.B PlayerXPosNext                      ; \ Don't fire if mario is next to generator
    SBC.W ShooterXPosLow,X                    ; |
    CLC                                       ; |; Return if Mario is within one tile of the shooter.
    ADC.B #$11                                ; |
    CMP.B #$22                                ; |
    BCC +                                     ; /
    JSL FindFreeSlotLowPri                    ; \ Get an index to an unused sprite slot, return if all slots full; Return if there are no sprite slots available.
    BMI +                                     ; / After: Y has index of sprite being generated
    LDA.B #!SFX_KAPOW                         ; \ Only shoot every #$80 frames; SFX for shooting a Bullet Bill.
    STA.W SPCIO3                              ; / Play sound effect
    LDA.B #$01                                ; \ Sprite status = Initialization
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$1C                                ; \ New sprite = Bullet Bill; Sprite to spawn (Bullet Bill).
    STA.W SpriteNumber,Y                      ; /
    LDA.W ShooterXPosLow,X                    ; \ Set x position for new sprite
    STA.W SpriteXPosLow,Y                     ; |; Set at the shooter's X position.
    LDA.W ShooterXPosHigh,X                   ; |
    STA.W SpriteXPosHigh,Y                    ; /
    LDA.W ShooterYPosLow,X                    ; \ Set y position for new sprite
    SEC                                       ; | (y position of generator - 1)
    SBC.B #$01                                ; |
    STA.W SpriteYPosLow,Y                     ; |; Set at the shooter's Y position (shifted a pixel up in order to line up).
    LDA.W ShooterYPosHigh,X                   ; |
    SBC.B #$00                                ; |
    STA.W SpriteYPosHigh,Y                    ; /
    PHX                                       ; \ Before: X must have index of sprite being generated
    TYX                                       ; | Routine clears *all* old sprite values...
    JSL InitSpriteTables                      ; | ...and loads in new values for the 6 main sprite tables
    PLX                                       ; /
    JSR ShowShooterSmoke                      ; Display smoke graphic; Spawn a smoke sprite on top of the shooter.
  + RTS

ShowShooterSmoke:
    LDY.B #$03                                ; \ Find a free slot to display effect; Subroutine to spawn a smoke sprite.
FindFreeSmokeSlot:
    LDA.W SmokeSpriteNumber,Y                 ; |; Find an empty smoke sprite slot, and return if none found.
    BEQ SetShooterSmoke                       ; |
    DEY                                       ; |
    BPL FindFreeSmokeSlot                     ; |
    RTS                                       ; / Return if no free slots


ShooterSmokeDispX:
    db $F4,$0C

SetShooterSmoke:
; X offsets for spawning the smoke cloud on the Bullet Bill shooter.
; Smoke sprite found for the bullet bill shooter.
    LDA.B #$01                                ; \ Set effect graphic to smoke graphic; Mark the sprite as existing.
    STA.W SmokeSpriteNumber,Y                 ; /
    LDA.W ShooterYPosLow,X                    ; \ Smoke y position = generator y position; Set Y position at the shooter.
    STA.W SmokeSpriteYPos,Y                   ; /
    LDA.B #$1B                                ; \ Set time to show smoke; Number of frames to show the smoke for.
    STA.W SmokeSpriteTimer,Y                  ; /
    LDA.W ShooterXPosLow,X                    ; \ Load generator x position and store it for later
    PHA                                       ; /
    LDA.B PlayerXPosNext                      ; \ Determine which side of the generator mario is on
    CMP.W ShooterXPosLow,X                    ; |
    LDA.B PlayerXPosNext+1                    ; |
    SBC.W ShooterXPosHigh,X                   ; |
    LDX.B #$00                                ; |; Set X position to the side of the shooter, on whichever side Mario is.
    BCC +                                     ; |
    INX                                       ; /
  + PLA                                       ; \ Set smoke x position from generator position
    CLC                                       ; |
    %LorW_X(ADC,ShooterSmokeDispX)            ; |
    STA.W SmokeSpriteXPos,Y                   ; /
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_02B51A:
    TXA                                       ; Routine to update a bounce sprite's X position.
    CLC
    ADC.B #$04                                ; Run the below routine with a shifted index.
    TAX
    JSR CODE_02B526
    LDX.W MinorSpriteProcIndex
    RTS

CODE_02B526:
    LDA.W BounceSpriteYSpeed,X                ; Routine to update a bounce sprite's Y position.
    ASL A
    ASL A
    ASL A                                     ; Update fraction bits.
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
    ORA.B #$F0                                ; Update position.
    DEY
  + PLP
    ADC.W BounceSpriteYPosLow,X
    STA.W BounceSpriteYPosLow,X
    TYA
    ADC.W BounceSpriteYPosHigh,X
    STA.W BounceSpriteYPosHigh,X
    RTS

CODE_02B554:
    TXA                                       ; Routine to update an extended sprite's X position.
    CLC
    ADC.B #$0A                                ; Run the below routine with a shifted index.
    TAX
    JSR CODE_02B560
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_02B560:
    LDA.W ExtSpriteYSpeed,X                   ; Routine to update an extended sprite's Y position.
    ASL A
    ASL A
    ASL A                                     ; Update fraction bits.
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
    ORA.B #$F0                                ; Update position.
    DEY
  + PLP
    ADC.W ExtSpriteYPosLow,X
    STA.W ExtSpriteYPosLow,X
    TYA
    ADC.W ExtSpriteYPosHigh,X
    STA.W ExtSpriteYPosHigh,X
    RTS

CODE_02B58E:
    LDA.W CoinSpriteYSpeed,X                  ; Routine to update a spinning coin sprite's Y position.
    ASL A
    ASL A
    ASL A                                     ; Update fraction bits.
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
    ORA.B #$F0                                ; Update position.
    DEY
  + PLP
    ADC.W CoinSpriteYPosLow,X
    STA.W CoinSpriteYPosLow,X
    TYA
    ADC.W CoinSpriteYPosHigh,X
    STA.W CoinSpriteYPosHigh,X
    RTS

CODE_02B5BC:
    TXA                                       ; Routine to update a minor extended sprite's X position.
    CLC
    ADC.B #$0C                                ; Run the below routine with a shifted index.
    TAX
    JSR CODE_02B5C8
    LDX.W MinorSpriteProcIndex
    RTS

CODE_02B5C8:
    LDA.W MinExtSpriteYSpeed,X                ; Routine to update a minor extended sprite's Y position.
    ASL A
    ASL A
    ASL A                                     ; Update fraction bits.
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
    CMP.B #$08                                ; Update the actual position.
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
; Clipping values ($1662) for the Pokey, corresponding to how many segments are left.
    PHB                                       ; Pokey MAIN
    PHK
    PLB
    JSR PokeyMainRt                           ; Run main routine.
    LDA.B SpriteTableC2,X                     ; \ After: Y = number of segments
    PHX                                       ; | $C2,x has a bit set for each segment remaining
    LDX.B #$04                                ; | for X=0 to X=4...
    LDY.B #$00                                ; |
PokeyLoopStart:
    LSR A                                     ; |
    BCC +                                     ; |; Count the number of segments remaining in the Pokey and change
    INY                                       ; | ...Increment Y if bit X is set; the size of the its hitbox depending on how many are left.
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
; AND values for each of the lower segments in the Pokey.
; AND values to get all of the segments below the ones specified above.
; AND values to get all the segments above and including the ones specified above.
; X offsets for animating the Pokey segments as it moves.
; X speeds for the Pokey.
; Y offsets for handling the "fall" animation of higher Pokey segments when a segment in the middle is removed.
; Pokey misc RAM:
; $C2   - Number of segments in the Pokey, bitwise (---x xxxx). Bits will shift right to fill in any "holes" that appear, so that they stay sequential.
; For the individual segments, it represents the number of segments that were above it in the Pokey. If 0, the segment is the head.
; $151C - Non-sequential mirror of $C2 (holes do not get filled in until another piece is removed). Used for determining how much of the Pokey needs to "fall" when a middle segment is removed.
; $1534 - Flag to decide whether the sprite is an actual Pokey or just a segment.
; $1540 - Timer for the "falling" animation of the segments while they realign when a piece in the middle is removed.
; $1558 - Timer to disable thrown sprites from hurting the Pokey. Set whenever a Pokey segment is knocked off.
; $1570 - Frame counter for turning towards Mario.
; $157C - Horizontal direction the sprite is moving in.
; The actual Pokey MAIN
    LDA.W SpriteMisc1534,X                    ; Branch if in single segment form.
    BNE CODE_02B681
    LDA.W SpriteStatus,X                      ; \ Branch if Status == Normal
    CMP.B #$08                                ; |; Branch if not dead.
    BEQ CODE_02B6A7                           ; /
    JMP CODE_02B726                           ; Skip to graphics.

CODE_02B681:
; Pokey segment.
    JSL GenericSprGfxRt2                      ; Draw a 16x16.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B SpriteTableC2,X
    CMP.B #$01
    LDA.B #$8A                                ; Tile for the Pokey's head when seperated.
    BCC +
    LDA.B #$E8                                ; Tile for the Pokey's body when seperated.
  + STA.W OAMTileNo+$100,Y
    LDA.W SpriteStatus,X
    CMP.B #$08                                ; Return if the segment was killed (under normal circumstances, this should always return at this point).
    BNE +
    JSR UpdateYPosNoGrvty
    INC.B SpriteYSpeed,X                      ; Apply gravity to the segment. There's no limit, though, so this will invert fairly quickly.
    INC.B SpriteYSpeed,X
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
  + RTS

CODE_02B6A7:
    LDA.B SpriteTableC2,X                     ; \ Erase sprite if no segments remain; Actual Pokey.
    BNE +                                     ; |; If there are no segments left, erase the sprite.
  - STZ.W SpriteStatus,X                      ; |
    RTS

; Pokey is alive.
  + CMP.B #$20                                ; Erase the Pokey if there are more than 5 segments?
    BCS -
    LDA.B SpriteLock                          ; Skip to graphics if game frozen.
    BNE CODE_02B726
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSL MarioSprInteract                      ; Process interaction with Mario.
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    AND.B #$7F                                ; How often to check Mario's side.
    BNE +
    JSR CODE_02D4FA                           ; Handle changing direction towards Mario.
    TYA
    STA.W SpriteMisc157C,X
  + LDY.W SpriteMisc157C,X
    LDA.W PokeySpeed,Y                        ; Set the Pokey's X speed.
    STA.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty                     ; Update X/Y position.
    JSR UpdateYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +                                     ; Apply gravity.
    CLC
    ADC.B #$02                                ; How fast the Pokey accelerates downwards.
    STA.B SpriteYSpeed,X
  + JSL CODE_019138                           ; Process interaction with blocks.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Clear Y speed if on the ground.
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.W SpriteBlockedDirs,X
    AND.B #$03
    BEQ +                                     ; Invert direction if touching a wall.
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + JSR CODE_02B7AC                           ; Process interaction with thrown sprites.
    LDY.B #$00
CODE_02B709:
    LDA.B SpriteTableC2,X
    AND.W DATA_02B653,Y
    BNE +
    LDA.B SpriteTableC2,X
    PHA
    AND.W DATA_02B657,Y
    STA.B _0                                  ; Shift the bits for the remaining segments in the Pokey so they they stay in sequence.
    PLA                                       ; (i.e. no "1001", make it "0011" instead)
    LSR A
    AND.W DATA_02B65B,Y
    ORA.B _0
    STA.B SpriteTableC2,X
  + INY
    CPY.B #$04
    BNE CODE_02B709
CODE_02B726:
    JSR GetDrawInfo2                          ; Pokey GFX routine.
    LDA.B _1
    CLC                                       ; Shift on-screen X position down 5 tiles, so the base is at the bottom of the Pokey.
    ADC.B #$40
    STA.B _1
    LDA.B SpriteTableC2,X
    STA.B _2                                  ; $02 = Segment count ($C2)
    STA.B _7                                  ; $03 = Extra Y offset to be added if a piece was been removed.
    LDA.W SpriteMisc151C,X                    ; $04 = Non-sequential segment count ($151C)
    STA.B _4                                  ; $05 = Extra Y offset actually being added to each segment. Starts at 0, but changes when a removed piece is encountered.
    LDY.W SpriteMisc1540,X                    ; $06 = Loop counter
    LDA.W DATA_02B665,Y                       ; $07 = Mirror of segment count ($C2)
    STA.B _3
    STZ.B _5
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    LDX.B #$04
CODE_02B74B:
    STX.B _6                                  ; Main segment GFX loop.
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    CLC
    ADC.B _6
    AND.B #$03
    TAX                                       ; Set X position, animating the "wiggle" of the segments in the process.
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
    PHA                                       ; Set Y position;
    LDA.B _3                                  ; if the segment is currently "falling" (i.e. a middle segment was knocked off),
    STA.B _5                                  ; then add the extra Y offset to it and all higher pieces for animating that.
    PLA
  + SEC
    SBC.B _5
    STA.W OAMTileYPos+$100,Y
CODE_02B781:
    LDA.B _1
    SEC                                       ; Shift Y position for the next segment one tile upwards.
    SBC.B #$10
    STA.B _1
    LDA.B _2
    LSR A
    LDA.B #$E8                                ; Tile to use for the Pokey's body.
    BCS +
    LDA.B #$8A                                ; TIle to use for the Pokey's head.
  + STA.W OAMTileNo+$100,Y
    LDA.B #$05                                ; Palette to use for the YXPPCCCT of the Pokey.
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX                                       ; Loop for all 5 segments (regardless of how many are actually still there).
    BPL CODE_02B74B
    PLX
    LDA.B #$04
    LDY.B #$02                                ; Upload 5 16x16s.
CODE_02B7A7:
    JSL FinishOAMWrite
    RTS

CODE_02B7AC:
    LDY.B #$09                                ; Routine to process interaction between a Pokey and other sprites (for being hurt by thrown items).
CODE_02B7AE:
    TYA
    EOR.B TrueFrame
    LSR A
    BCS CODE_02B7D2                           ; Skip slot if not a frame to process interaction,
    LDA.W SpriteStatus,Y                      ; or the sprite is not in a thrown state.
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
    JSL GetSpriteClippingA                    ; Branch if in contact.
    JSL CheckForContact
    PLB
    BCS CODE_02B7D6
CODE_02B7D2:
    DEY                                       ; Loop for all the remaining sprite slots.
    BPL CODE_02B7AE
  - RTS

CODE_02B7D6:
; Thrown sprite is in contact with the Pokey.
    LDA.W SpriteMisc1558,X                    ; Return if thrown sprite interaction is temporarily disabled.
    BNE -
    LDA.W SpriteYPosLow,Y
    SEC
    SBC.B SpriteYPosLow,X                     ; Knock off the Pokey segment being touched.
    PHY
    STY.W SpriteInterIndex
    JSR RemovePokeySgmntRt
    PLY
    JSR CODE_02B82E
    RTS

RemovePokeySgmntRt:
    LDY.B #$00                                ; Subroutine to remove a segment from a Pokey. Load A with the Y position being touched.
    CMP.B #$09
    BMI +
    INY
    CMP.B #$19
    BMI +                                     ; Figure out which segment is being killed/eaten (Y = 0-4)
    INY
    CMP.B #$29
    BMI +
    INY
    CMP.B #$39
    BMI +
    INY
  + LDA.B SpriteTableC2,X                     ; \ Take away a segment by unsetting a bit
    AND.W PokeyUnsetBit,Y                     ; |; Remove the segment.
    STA.B SpriteTableC2,X                     ; /
    STA.W SpriteMisc151C,X
    LDA.W DATA_02B829,Y                       ; Get AND value for determining the number of segments above the piece later.
    STA.B _D
    LDA.B #$0C                                ; Set timer for the "falling" animation of the rest of the Pokey.
    STA.W SpriteMisc1540,X
    ASL A                                     ; Temporarily disable extra interaction with the Pokey for thrown sprites.
    STA.W SpriteMisc1558,X
    RTS

RemovePokeySegment:
    PHB                                       ; Wrapper; Routine to remove a segment from a Pokey (JSL). Run by Yoshi's tongue.
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
; AND values to clear bits for the Pokey.
; AND values for tracking the number of segments above the removed piece.
; Indicates a tile is the head if this ANDed with the segments in the Pokey is 0.
; Routine to spawn a detatched Pokey segment when hit by a thrown sprite.
    JSL FindFreeSprSlot                       ; \ Return if no free slots; Return if no empty sprite slot exists.
    BMI +                                     ; /
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$70                                ; Sprite to spawn (Pokey).
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y                     ; Set X position at the Pokey.
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    LDX.W SpriteInterIndex
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y                     ; Set Y position at the thrown sprite.
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    LDA.B SpriteXSpeed,X
    STA.B _0
    ASL A                                     ; Set X speed as half the thrown sprite's.
    ROR.B _0
    LDA.B _0
    STA.W SpriteXSpeed,Y
    LDA.B #$E0                                ; Y speed to give the detatched segment.
    STA.W SpriteYSpeed,Y
    PLX
    LDA.B SpriteTableC2,X
    AND.B _D                                  ; Store a value representing the number of segments above the current one, for determining if it's the head.
    STA.W SpriteTableC2,Y
    LDA.B #$01                                ; Set flag for the sprite being a single segment.
    STA.W SpriteMisc1534,Y
    LDA.B #$01                                ; Give 200 points.
    JSL CODE_02ACE1
  + RTS

TorpedoTedMain:
; Torpedo Ted misc RAM:
; $1540 - Timer for the "launching" animation.
; $157C - Horizontal direction the sprite is facing.
    PHB                                       ; Torpedo Ted MAIN
    PHK
    PLB
    JSR CODE_02B88A
    PLB
    RTL

CODE_02B88A:
    LDA.B SpriteProperties                    ; \ Save $64
    PHA                                       ; /
    LDA.W SpriteMisc1540,X                    ; \ If being launched...; If currently being lowered by the arm, send behind objects.
    BEQ +                                     ; | ...set $64 = #$10...
    LDA.B #$10                                ; | ...so it will be drawn behind objects
    STA.B SpriteProperties                    ; /
  + JSR TorpedoGfxRt                          ; Draw sprite; Draw graphics.
    PLA                                       ; \ Restore $64
    STA.B SpriteProperties                    ; /
    LDA.B SpriteLock                          ; \ Return if sprites locked; Return if game frozen.
    BNE Return02B8B7                          ; /
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Process interaction with Mario and other sprites.
    LDA.W SpriteMisc1540,X                    ; \ Branch if not being launched; Branch if done being lowered.
    BEQ +                                     ; /
    LDA.B #$08                                ; \ Sprite Y speed = #$08; Y speed the arm lowers the Torpedo Ted with.
    STA.B SpriteYSpeed,X                      ; /
    JSR UpdateYPosNoGrvty                     ; Apply speed to position
    LDA.B #$10                                ; \ Sprite Y speed = #$10; Y speed the Torpedo Ted is given when released by the arm.
    STA.B SpriteYSpeed,X                      ; /
Return02B8B7:
    RTS


TorpedoMaxSpeed:
    db $20,$F0

TorpedoAccel:
    db $01,$FF

; Max X speeds for the Torpedo Ted.
; X accelerations for the Torpedo Ted.
  + LDA.B TrueFrame                           ; \ Only increase X speed every 4 frames; Torpedo Ted is released.
    AND.B #$03                                ; |
    BNE +                                     ; /
    LDY.W SpriteMisc157C,X                    ; \ If not at maximum, increase X speed
    LDA.B SpriteXSpeed,X                      ; |; Handle horizontal acceleration.
    CMP.W TorpedoMaxSpeed,Y                   ; |; Only increase X speed one out of every four frames.
    BEQ +                                     ; |
    CLC                                       ; |
    ADC.W TorpedoAccel,Y                      ; |
    STA.B SpriteXSpeed,X                      ; /
  + JSR UpdateXPosNoGrvty                     ; \ Apply speed to position; Update X/Y position.
    JSR UpdateYPosNoGrvty                     ; /
    LDA.B SpriteYSpeed,X                      ; \ If sprite has Y speed...
    BEQ +                                     ; |
    LDA.B TrueFrame                           ; | ...Decrease Y speed every other frame; Decelerate the Ted's vertical acceleration so that it straightens out after launch.
    AND.B #$01                                ; |
    BNE +                                     ; |
    DEC.B SpriteYSpeed,X                      ; /
  + TXA                                       ; \ Run $02B952 every 8 frames
    CLC                                       ; |
    ADC.B EffFrame                            ; |; Spawn smoke on the torpedo every 8 frames.
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
; X offsets for the Torpedo Ted's tiles.
; First two bytes are used when facing right, second two when facing left.
; Unused?
; X flips for the Torpedo Ted's tiles.
    JSR GetDrawInfo2                          ; Torpedo Ted GFX routine.
    LDA.B _1
    STA.W OAMTileYPos+$100,Y                  ; Set tile Y positions.
    STA.W OAMTileYPos+$104,Y
    PHX
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties                    ; Get YXPPCCCT, excluding X flip.
    STA.B _2
    LDA.W SpriteMisc157C,X
    TAX
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02B8F0)
    STA.W OAMTileXPos+$100,Y                  ; Set tile X positions.
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02B8F1)
    STA.W OAMTileXPos+$104,Y
    %LorW_X(LDA,DATA_02B8F5)
    ORA.B _2                                  ; Set YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    PLX
    LDA.B #$80                                ; Tile to use for the torpedo's head.
    STA.W OAMTileNo+$100,Y
    LDA.W SpriteMisc1540,X
    CMP.B #$01
    LDA.B #$82                                ; Tile to use for the torpedo's body when being lowered by the arm.
    BCS +
    LDA.B EffFrame
    LSR A
    LSR A
    LDA.B #$A0                                ; Tile A for the torpedo's body after launch.
    BCC +
    LDA.B #$82                                ; Tile B for the torpedo's body after launch.
  + STA.W OAMTileNo+$104,Y
    LDA.B #$01
    LDY.B #$02                                ; Upload two 16x16s.
    JMP CODE_02B7A7


DATA_02B94E:
    db $F4,$1C

DATA_02B950:
    db $FF,$00

CODE_02B952:
    LDY.B #$03                                ; Subroutine to spawn smoke for the Torpedo Ted.
CODE_02B954:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_02B969
    DEY
    BPL CODE_02B954                           ; Find an empty smoke sprite slot,
    DEC.W SmokeSpriteSlotFull                 ; or overwrite one if none exist.
    BPL +
    LDA.B #$03
    STA.W SmokeSpriteSlotFull
  + LDY.W SmokeSpriteSlotFull
CODE_02B969:
    LDA.B SpriteXPosLow,X
    STA.B _0                                  ; $00 = torpedo X position low
    LDA.W SpriteXPosHigh,X                    ; $01 = torpedo X position high
    STA.B _1
    PHX
    LDA.W SpriteMisc157C,X
    TAX
    LDA.B _0
    CLC                                       ; $02 = X position to spawn the smoke at
    ADC.W DATA_02B94E,X
    STA.B _2
    LDA.B _1
    ADC.W DATA_02B950,X                       ; If the smoke sprite would be spawning offscreen, return.
    PHA
    LDA.B _2
    CMP.B Layer1XPos
    PLA
    PLX
    SBC.B Layer1XPos+1
    BNE +
    LDA.B #$01                                ; Mark the smoke as existing.
    STA.W SmokeSpriteNumber,Y
    LDA.B _2                                  ; Set the X position.
    STA.W SmokeSpriteXPos,Y
    LDA.B SpriteYPosLow,X                     ; Set the Y position at the torpedo's.
    STA.W SmokeSpriteYPos,Y
    LDA.B #$0F                                ; How long the smoke lasts for.
    STA.W SmokeSpriteTimer,Y
  + RTS

    STA.B Map16TileGenerate                   ; $9C = tile to generate; Unused routine (JSL) to spawn a block at a sprite's position. Load the tile for $9C in A.
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position
    STA.B TouchBlockXPos                      ; | for block creation
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B TouchBlockXPos+1                    ; /; Load the sprite's position.
    LDA.B SpriteYPosLow,X                     ; \ $98 = Sprite Y position
    STA.B TouchBlockYPos                      ; | for block creation
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B TouchBlockYPos+1                    ; /
    JSL GenerateTile                          ; Generate the tile; Generate the block.
    RTL

CODE_02B9BD:
; Silver P-switch pressed.
    LDA.B #$02                                ; Initialize the points counter for the silver coins.
    STA.W SilverCoinsCollected
    LDY.B #$09
CODE_02B9C4:
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BCC +
    LDA.W SpriteTweakerF,Y
    AND.B #$40
    BNE +                                     ; Turn all loaded sprites into silver coins.
    JSR CODE_02B9D9
  + DEY
    BPL CODE_02B9C4
    RTL

CODE_02B9D9:
    LDA.B #$21                                ; Subroutine to turn a sprite into a silver coin.
    STA.W SpriteNumber,Y
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /; Spawn a coin.
    PHX
    TYX
    JSL InitSpriteTables
    LDA.W SpriteOBJAttribute,X
    AND.B #$F1                                ; Make silver.
    ORA.B #$02
    STA.W SpriteOBJAttribute,X
    LDA.B #$D8                                ; Y speed to spawn the coin with.
    STA.W SpriteYSpeed,X
    PLX
    RTS

CODE_02B9FA:
; Scratch RAM setup:
; $00 - X position, low
; $01 - Y position, low
; $08 - X position, high
; $09 - Y position, high
; $0F - Unused, but functions as a layer pointer (0 = layer 1, 1 = layer 2). Always 0 normally, though.
; Scratch RAM usages:
; $04, $06, $07, $0D
    STZ.B _F                                  ; Routine to process sprite interaction with berries. Used for Baby Yoshi and Yoshi's tongue.
    BRA CODE_02BA48                           ; [skip over vertical level interaction]

    LDA.B _1                                  ; \ Unreachable; (This unused code handles berry interaction in vertical levels.)
    AND.B #$F0                                ; | Very similar to code below
    STA.B _4
    LDA.B _9
    CMP.B LevelScrLength                      ; Return if outside the level vertically.
    BCS Return02BA47
    STA.B _5
    LDA.B _0
    STA.B _7
    LDA.B _8
    CMP.B #$02                                ; Return if outside of the level horizontally.
    BCS Return02BA47
    STA.B _A
    LDA.B _7
    LSR A
    LSR A
    LSR A                                     ; $04 = Block position, YX format.
    LSR A
    ORA.B _4
    STA.B _4
    LDX.B _5
    LDA.L DATA_00BA80,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA8E,X                       ; Get Map16 low pointer.
  + CLC
    ADC.B _4
    STA.B _5
    LDA.L DATA_00BABC,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BACA,X                       ; Get Map16 high pointer.
  + ADC.B _A
    STA.B _6
    BRA CODE_02BA92                           ; Branch to handle contact.

Return02BA47:
    RTL

CODE_02BA48:
    LDA.B _1                                  ; Berry interaction in a horizontal level.
    AND.B #$F0
    STA.B _4
    LDA.B _9
    CMP.B #$02                                ; Return if outside of the level vertically.
    BCS Return02BA47
    STA.B _D
    STA.W YoshiYPos+1
    LDA.B _0
    STA.B _6
    LDA.B _8
    CMP.B LevelScrLength                      ; Return if outside of the level horizontally.
    BCS Return02BA47
    STA.B _7
    LDA.B _6
    LSR A
    LSR A
    LSR A                                     ; $04 = Block position, YX format.
    LSR A
    ORA.B _4
    STA.B _4
    LDX.B _7
    LDA.L DATA_00BA60,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA70,X                       ; Get Map16 low pointer.
  + CLC
    ADC.B _4
    STA.B _5
    LDA.L DATA_00BA9C,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BAAC,X                       ; Get Map16 high pointer.
  + ADC.B _D
    STA.B _6
CODE_02BA92:
    LDX.W CurSpriteProcess                    ; X = Sprite index; Tile is found; handle contact.
    LDA.B #$7E
    STA.B _7
    LDA.B [_5]
    STA.W Map16TileNumber
    INC.B _7
    LDA.B [_5]                                ; Return if not touching a berry.
    BNE Return02BABF
    LDA.W Map16TileNumber
    CMP.B #$45                                ; If it is <= the Red Berry map16 tile
    BCC Return02BABF
    CMP.B #$48                                ; If it is => Map16 always turning block
    BCS Return02BABF
    SEC
    SBC.B #$44                                ; Keep track of the berry's color.
    STA.W EatenBerryType                      ;Berry Type
    LDY.B #$0B
CODE_02BAB7:
    LDA.W SpriteStatus,Y                      ; \ Find a free sprite slot and branch
    BEQ CODE_02BAC0                           ; |; Find an empty sprite slot to put the berry in.
    DEY                                       ; |; Return if none found.
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
    STA.W SpriteXPosHigh,Y                    ; |; Spawn sprite 74 (mushroom) at the block's position.
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
    INC.W SpriteMisc160E,X                    ; ?; Turn the mushroom into a berry.
    LDA.W SpriteTweakerB,X                    ; \ Change the index into sprite clipping table
    AND.B #$F0                                ; | to "resize" the sprite; Change clipping.
    ORA.B #$0C                                ; |
    STA.W SpriteTweakerB,X                    ; /
    LDA.W SpriteTweakerD,X                    ; \ No longer gives powerup when eaten
    AND.B #$BF                                ; |; Disable giving a powerup.
    STA.W SpriteTweakerD,X                    ; /
    PLX
    LDA.B #$04                                ; \ Block to generate = Tree behind berry
    STA.B Map16TileGenerate                   ; /; Spawn a blank bush tile.
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
; X offsets for Yoshi's wings, low.
; X offsets for Yoshi's wings, high.
; Y offsets for Yoshi's wings.
; Tile numbers for Yoshi's wings.
; YXPPCCCT for Yoshi's wings.
; Tile sizes for Yoshi's wings.
    STA.B _2                                  ; GFX routine to draw wings on Yoshi. A contains animation frame: 0 (closed) or 1 (open).
    JSR IsSprOffScreenBnk2                    ; Return if Yoshi is offscreen.
    BNE Return02BB87
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _4
    LDA.B SpriteYPosLow,X
    STA.B _1
    LDY.B #$F8                                ; OAM index (from $0200) for Yoshi's wings.
    PHX
    LDA.W SpriteMisc157C,X
    ASL A                                     ; Get X/Y position offsets.
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
    STA.W OAMTileXPos,Y                       ; Set X position, and return if offscreen.
    PLA
    SBC.B Layer1XPos+1
    BNE +
    LDA.B _1
    SEC
    SBC.B Layer1YPos                          ; Set Y position.
    CLC
    ADC.L DATA_02BB13,X
    STA.W OAMTileYPos,Y
    LDA.L YoshiWingsTiles,X                   ; Set tile number.
    STA.W OAMTileNo,Y
    LDA.B SpriteProperties
    ORA.L YoshiWingsGfxProp,X                 ; Set YXPPCCCT.
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.L YoshiWingsSize,X                    ; Set size.
    STA.W OAMTileSize,Y
  + PLX
Return02BB87:
    RTL


DATA_02BB88:
    db $FF,$01,$FF,$01,$00,$00

DATA_02BB8E:
    db $E8,$18,$F8,$08,$00,$00

DolphinMain:
; X accelerations for each of the dolphin sprites.
; Max X speeds for each of the dolphin sprites to reach before they jump.
; Dolphin misc RAM:
; $C2   - Counter for which direction the dolphin should next accelerate horizontally in; even = left, odd = right.
; $151C - Flag that stops the dolphin from changing directions if set (used by the dolphin generator).
; $1528 - Number of pixels the sprite has moved horizontally in the frame.
; $157C - Vertical dolphin only: horizontal direction the sprite is facing.
; $1602 - Vertical dolphin only: animation frame. Always 0.
; Dolphin MAIN
    JSR CODE_02BC14                           ; Draw graphics.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return02BBFF
    JSR SubOffscreen1Bnk2                     ; Process offscreen from -$40 to +$A0.
    JSR UpdateYPosNoGrvty                     ; Update X/Y position.
    JSR UpdateXPosNoGrvty
    STA.W SpriteMisc1528,X
    LDA.B EffFrame
    AND.B #$00
    BNE CODE_02BBB7
    LDA.B SpriteYSpeed,X                      ; Apply gravity.
    BMI CODE_02BBB5
    CMP.B #$3F                                ; The "AND #$00" line probably was meant for a reduced gravity, but currently, it's just useless.
    BCS CODE_02BBB7
CODE_02BBB5:
    INC.B SpriteYSpeed,X
CODE_02BBB7:
    TXA
    EOR.B TrueFrame
    LSR A                                     ; Process interaction with blocks every other frame.
    BCC +
    JSL CODE_019138
  + LDA.B SpriteYSpeed,X
    BMI CODE_02BBFB
    LDA.W SpriteInLiquid,X
    BEQ CODE_02BBFB
    LDA.B SpriteYSpeed,X
    BEQ +                                     ; If the dolphin falls into a liquid, decelerate it until its speed reaches 0.
    SEC                                       ; Else, if it's not in liquid, just make the dolphin solid and return.
    SBC.B #$08
    STA.B SpriteYSpeed,X
    BPL +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.W SpriteMisc151C,X
    BNE CODE_02BBF7
    LDA.B SpriteTableC2,X
    LSR A
    PHP
    LDA.B SpriteNumber,X                      ; Handle turning the dolphin around, unless set to not do so (with $151C).
    SEC
    SBC.B #$41
    PLP
    ROL A
    TAY
    LDA.B SpriteXSpeed,X
    CLC
    ADC.W DATA_02BB88,Y
    STA.B SpriteXSpeed,X                      ; Accelerate in the opposite direction until the max speed is reached.
    CMP.W DATA_02BB8E,Y
    BNE CODE_02BBFB
    INC.B SpriteTableC2,X
CODE_02BBF7:
    LDA.B #$C0                                ; Y speed to give the dolphin when jumping.
    STA.B SpriteYSpeed,X
CODE_02BBFB:
    JSL InvisBlkMainRt                        ; Make the dolphin solid.
Return02BBFF:
    RTL

CODE_02BC00:
    LDA.B EffFrame                            ; Vertical dolphin GFX routine.
    AND.B #$04
    LSR A                                     ; Animate the dolphin's "shake".
    LSR A
    STA.W SpriteMisc157C,X
    JSL GenericSprGfxRt1                      ; Draw a 16x32 sprite.
    RTS


DolphinTiles1:
    db $E2,$88

DolphinTiles2:
    db $E7,$A8

DolphinTiles3:
    db $E8,$A9

CODE_02BC14:
; Tiles for the horizontal dolphin's face.
; Tiles for the horizontal dolphin's abdomen.
; Tiles for the horizontal dolphin's tail.
    LDA.B SpriteNumber,X                      ; Main dolphin GFX routine.
    CMP.B #$43                                ; Jump to the routine above for the vertical dolphin.
    BNE +
    JMP CODE_02BC00

  + JSR GetDrawInfo2                          ; Horizontal dolphin GFX routine.
    LDA.B SpriteXSpeed,X
    STA.B _2
    LDA.B _0                                  ; Use the dolphin's X speed to determine which direction to face it.
    ASL.B _2                                  ; If facing left, branch down.
    PHP
    BCC CODE_02BC3C
    STA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$104,Y                  ; Store X positions, shifting right.
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$108,Y
    BRA +

CODE_02BC3C:
    CLC                                       ; Dolphin is facing left.
    ADC.B #$18
    STA.W OAMTileXPos+$100,Y
    SEC
    SBC.B #$10                                ; Store X positions, shifting left.
    STA.W OAMTileXPos+$104,Y
    SEC
    SBC.B #$08
    STA.W OAMTileXPos+$108,Y
  + LDA.B _1                                  ; Done with X posiiton.
    STA.W OAMTileYPos+$100,Y                  ; Store Y position.
    STA.W OAMTileYPos+$104,Y
    STA.W OAMTileYPos+$108,Y
    PHX
    LDA.B EffFrame
    AND.B #$08
    LSR A
    LSR A
    LSR A
    TAX                                       ; Store tiles, animating the tiles in the process.
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
    ORA.B #$40                                ; Store YXPPCCCT.
  + STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y
    LDA.B #$02
    LDY.B #$02                                ; Upload three 16x16s.
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
; Wall-follower X speeds.
; Wall-follower Y speeds.
; Fake X speeds for wall-followers, for handling object interaction.
; Fake Y speeds for wall-followers, for handling object interaction.
; Blocked statuses for wall-following sprites to check for in each direction.
; Used to determine whether the sprite has hit a wall.
; Animation frames for the Spike Top for each side of a block, in the order of the block statuses above.
; First set is when on the side.
; Second set is when turning to it (diagonal frames).
; X/Y flip for the Spike Top on each side of a block, in same order above.
; Animation frames for the Urchins.
; Wall following sprites misc RAM:
; $C2   - In wall-followers, indicator of what side of the block the sprite is on, as well as the direction it's moving.
; 0-3 = clockwise, 4-7 = counter; starts on top with 0/4, then increments in the direction of rotation.
; In sprites 3A/3B, this is a phase pointer. Even = waiting to move, odd = moving.
; $151C - Direction of rotation. 00 = clockwise, 10 = counter. In 3A/3B, this is used for the initial direction of movement (00 = vertical, 10 = horizontal)
; $1528 - Counter for the current animation frame of the Urchins. This value mod 4 determines which frame to use.
; $1540 - Wall-followers: Timer for turning corners. Handles letting the sprite move off the wall a bit before actually changing direction.
; Sprites 3A/3B: Phase timer. Not used in phase 1 for the wall-detect Urchin, but still set anyway.
; $1558 - Timer for blinking animations (which are only actually done by the Urchin/HotHead). Randomly set to #$0C.
; $1564 - Timer for showing the Spike Top's diagonal frame, though it's set for all sprites. Set to #$08 when turning.
; $157C - Horizontal direction the sprite is facing. Only used by the Spike Top / Sparky, but it has little effect on them.
; $1602 - Animation frame. Only used by the Urchins and Spike Top.
; Urchin: 0/1/2 = normal.
; Spike Top: 0/1/2/3 = walking, 4/5/6 = turning.
; $163E - Timer for the Urchin's animation. Set to #$0C each time its frame changes.
; MAIN for wall-following sprites (spike top, Urchins, sparky/fuzzy, hothead)
    JSL SprSprInteract                        ; Process interaction with other sprites.
    JSL GetRand
    AND.B #$FF
    ORA.B SpriteLock                          ; Call RNG; if #$00 is pulled and sprites are not locked, make the sprite blink.
    BNE +
    LDA.B #$0C
    STA.W SpriteMisc1558,X
  + LDA.B SpriteNumber,X                      ; \ Branch if not Spike Top
    CMP.B #$2E                                ; |; Branch if not sprite 2E (Spike Top).
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
    LDA.B EffFrame                            ; Set animation frame for the Spike Top according to the side it's on and whether or not it's rotating.
    LSR A
    LSR A
    LSR A
    AND.B #$01
  + CLC
    ADC.W DATA_02BCB7,Y
    STA.W SpriteMisc1602,X
    LDA.W SpriteOBJAttribute,X
    AND.B #$3F                                ; Handle X/Y flip for the Spike Top.
    ORA.W DATA_02BCC7,Y
    STA.W SpriteOBJAttribute,X
    JSL GenericSprGfxRt2                      ; Draw a 16x16.
    BRA CODE_02BD2F

CODE_02BD23:
    CMP.B #$A5                                ; Not a spike top.
    BCC CODE_02BD2C                           ; Run appropriate sprite GFX routine.
    JSR CODE_02BE4E                           ; Use the first one for fuzzy/sparky or hothead;
    BRA CODE_02BD2F                           ; Use the second one for urchins.

CODE_02BD2C:
    JSR CODE_02BF5C
CODE_02BD2F:
    LDA.W SpriteStatus,X                      ; Done GFX routines; all sprites reconvene here.
    CMP.B #$08
    BEQ +
    STZ.W SpriteMisc1528,X                    ; If killed, have the sprite close its eyes and terminate.
    LDA.B #$FF
    STA.W SpriteMisc1558,X
    RTL

; Sprite is alive.
  + LDA.B SpriteLock                          ; Return if the game is frozen.
    BNE Return02BD74
    JSR SubOffscreen3Bnk2                     ; Process offscreen from -$50 to +$60.
    JSL MarioSprInteract                      ; Process interaction with Mario.
    LDA.B SpriteNumber,X                      ; \ Branch if Spike Top
    CMP.B #$2E                                ; |
    BEQ CODE_02BDA7                           ; /
    CMP.B #$3C                                ; \ Branch if Wall-follow Urchin; Branch A if sprite 2E (spike top).
    BEQ CODE_02BDB3                           ; /; Branch B if sprites 3C, A5, or A6 (wall-follow urchin, fuzzy/sparky, hothead).
    CMP.B #$A5                                ; \ Branch if Ground-guided Fuzzball/Sparky; Resume code ahead if sprites 3A or 3B (non-wall-follow urchins).
    BEQ CODE_02BDB3                           ; /
    CMP.B #$A6                                ; \ Branch if Ground-guided Hothead
    BEQ CODE_02BDB3                           ; /
    LDA.B SpriteTableC2,X                     ; Fixed-direction Urchins (3A/3B).
    AND.B #$01
    JSL ExecutePtr

    dw CODE_02BD68
    dw CODE_02BD75

CODE_02BD68:
; Urchin phase pointers.
; 00 - Waiting to move.
; 01 - Moving (search for a wall / wait to stop).
    LDA.W SpriteMisc1540,X                    ; Waiting to move.
    BNE Return02BD74                          ; Switch to moving once the wait timer runs out.
    LDA.B #$80                                ; Number of frames to wait before stopping the fixed-distance urchin again.
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
Return02BD74:
    RTL

CODE_02BD75:
    LDA.B SpriteNumber,X                      ; \ Branch if Wall-detect Urchin; Moving (search for a wall / wait to stop).
    CMP.B #$3B                                ; |
    BEQ CODE_02BD80                           ; /; Branch for sprite 3A (fixed distance) if done moving.
    LDA.W SpriteMisc1540,X
    BEQ CODE_02BD91
CODE_02BD80:
    JSR UpdateXPosNoGrvty                     ; Update X/Y position.
    JSR UpdateYPosNoGrvty
    JSL CODE_019138                           ; Process block interaction.
    LDA.W SpriteBlockedDirs,X
    AND.B #$0F                                ; Return if not blocked on any side.
    BEQ +
CODE_02BD91:
    LDA.B SpriteXSpeed,X                      ; Urchin hit a wall, or the fixed-distance Urchin is done moving.
    EOR.B #$FF
    INC A
    STA.B SpriteXSpeed,X                      ; Invert X/Y speed.
    LDA.B SpriteYSpeed,X
    EOR.B #$FF
    INC A
    STA.B SpriteYSpeed,X
    LDA.B #$40                                ; Number of frames to wait for.
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X                     ; Switch to waiting.
  + RTL

CODE_02BDA7:
    LDA.B SpriteYPosLow,X                     ; Spike Top (2E).
    SEC
    SBC.B Layer1YPos                          ; Erase the sprite if it passes below the screen (to prevent walking under the level).
    CMP.B #$E0
    BCC CODE_02BDB3
    STZ.W SpriteStatus,X
CODE_02BDB3:
; Wall-following Urchin, Sparky/Fuzzy, HotHead (3C, A5, A6).
    LDA.W SpriteMisc1540,X                    ; Branch if in the process of turning.
    BNE CODE_02BDE7
    LDY.B SpriteTableC2,X
    LDA.W DATA_02BCA7,Y
    STA.B SpriteYSpeed,X                      ; Set some fake X/Y speeds for handling block interaction.
    LDA.W DATA_02BC9F,Y
    STA.B SpriteXSpeed,X
    JSL CODE_019138                           ; Process block interaction.
    LDA.W SpriteBlockedDirs,X
    AND.B #$0F
    BNE CODE_02BDE7                           ; If hitting a wall, set the timer for turning.
    LDA.B #$08
    STA.W SpriteMisc1564,X
    LDA.B #$38                                ; How long the Urchin takes to turn.
    LDY.B SpriteNumber,X                      ; \ Branch if Wall-follow Urchin
    CPY.B #$3C                                ; |
    BEQ +                                     ; /
    LDA.B #$1A                                ; How long the Hothead and Spike Top take to turn. Sparky/Fuzzy turn twice as fast.
    CPY.B #$A5
    BNE +
    LSR A
    NOP
  + STA.W SpriteMisc1540,X
CODE_02BDE7:
    LDA.B #$20                                ; What frame in the turning animation that the Urchin actually change direction at.
    LDY.B SpriteNumber,X                      ; \ Branch if Wall-follow Urchin
    CPY.B #$3C                                ; |
    BEQ +                                     ; /
    LDA.B #$10                                ; What frame in the turning animation that the Hothead/Spike Top change direction at. Sparky/Fuzzy use half this value.
    CPY.B #$A5
    BNE +
    LSR A
    NOP
  + CMP.W SpriteMisc1540,X                    ; Handle changing direction at outer corners.
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
    BPL CODE_02BE27                           ; Handle changing direction at inner corners.
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
    STA.B SpriteYSpeed,X                      ; Set X/Y speed.
    LDA.W DATA_02BC8F,Y
    STA.B SpriteXSpeed,X
    LDA.B SpriteNumber,X                      ; \ Branch if not Ground-guided Fuzzball/Sparky
    CMP.B #$A5                                ; |
    BNE +                                     ; /; Double X/Y speed if the Fuzzy/Sparky.
    ASL.B SpriteXSpeed,X
    ASL.B SpriteYSpeed,X
  + JSR UpdateXPosNoGrvty                     ; Update X and Y position.
    JSR UpdateYPosNoGrvty
    RTL


DATA_02BE4C:
    db $05,$45

CODE_02BE4E:
; YXPPCCCT for the Fuzzy's animation.
    LDA.B SpriteNumber,X                      ; Fuzzy/Sparky and HotHead GFX routine.
    CMP.B #$A5                                ; Branch if not the Fuzzy/Sparky.
    BNE CODE_02BEB5
    JSL GenericSprGfxRt2                      ; Draw a 16x16.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteTileset
    CMP.B #$02                                ; Branch if the sprite GFX index is not 2 (mushroom; i.e. Fuzzy).
    BNE +
    PHX
    LDA.B EffFrame
    LSR A
    LSR A                                     ; Get index for X/Y flip, for animation.
    AND.B #$01
    TAX
    LDA.B #$C8                                ; Tile to use for the Fuzzy.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02BE4C,X
    ORA.B SpriteProperties                    ; Store YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    PLX
    RTS

; Drawing a Sparky.
  + LDA.B #$0A                                ; Tile to use for the Sparky.
    STA.W OAMTileNo+$100,Y
    LDA.B EffFrame
    AND.B #$0C
    ASL A
    ASL A                                     ; Animate X/Y flip.
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
; X offsets for each of the HotHead's tiles.
; Y offsets for each of the HotHead's tiles.
; Tile numbers for each of the HotHead's tiles.
; Frame A
; Frame B
; YXPPCCCT for each of the HotHead's tiles.
; Frame A
; Frame B
; X offsets for the HotHead's eyes, for each direction of movement. These make it "look" in the direction it's moving.
; Y offsets for the HotHead's eyes, for each direction of movement. These make it "look" in the direction it's moving.
    JSR GetDrawInfo2                          ; Hothead GFX routine.
    TYA
    CLC
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    TAY
    LDA.B EffFrame
    AND.B #$04                                ; $03 = animation frame to use.
    STA.B _3
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC                                       ; Store X position.
    ADC.W DATA_02BE8D,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position.
    ADC.W DATA_02BE91,X
    STA.W OAMTileYPos+$100,Y
    PHX
    TXA
    ORA.B _3
    TAX                                       ; Store tile number.
    LDA.W HotheadTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02BE9D,X
    ORA.B SpriteProperties                    ; Store YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    PLX
    INY
    INY
    INY                                       ; Loop for all four tiles.
    INY
    DEX
    BPL -
    PLX
    LDA.B _0
    PHA
    LDA.B _1
    PHA
    LDY.B #$02
    LDA.B #$03                                ; Upload 4 16x16s.
    JSR CODE_02B7A7
    PLA
    STA.B _1
    PLA
    STA.B _0
    LDA.B #$09                                ; Tile to use for the HotHead's eyes when open.
    LDY.W SpriteMisc1558,X
    BEQ +
    LDA.B #$19                                ; Tile to use for the HotHead's eyes when blinking.
  + STA.B _2
    LDA.W SpriteOAMIndex,X
    SEC                                       ; Shift the OAM index down to make sure the eyes stay in front of the Hothead.
    SBC.B #$04
    STA.W SpriteOAMIndex,X
    TAY
    PHX
    LDA.B SpriteTableC2,X
    TAX
    LDA.B _0
    CLC                                       ; Store X position.
    ADC.W DATA_02BEA5,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position.
    ADC.W DATA_02BEAD,X
    STA.W OAMTileYPos+$100,Y
    LDA.B _2                                  ; Store tile number.
    STA.W OAMTileNo+$100,Y
    LDA.B #$05
    ORA.B SpriteProperties                    ; Store YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    PLX
    LDY.B #$00
    LDA.B #$00                                ; Upload 1 8x8.
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
; X offsets for each tile of the Urchin. Index 0 is the eyes.
; Y offsets for each tile of the Urchin. Index 0 is the eyes.
; YXPPCCCT for each tile of the Urchin. Index 0 is the eyes.
; Tile numbers each animation frame of the Urchin.
    LDA.W SpriteMisc163E,X                    ; Urchin GFX routine.
    BNE +
    INC.W SpriteMisc1528,X                    ; Handle timing the Urchin's animation.
    LDA.B #$0C
    STA.W SpriteMisc163E,X
  + LDA.W SpriteMisc1528,X
    AND.B #$03
    TAY                                       ; Set animation frame for the Urchin.
    LDA.W DATA_02BCD7,Y
    STA.W SpriteMisc1602,X
    JSR GetDrawInfo2
    STZ.B _5
    LDA.W SpriteMisc1602,X                    ; $02 = animation frame
    STA.B _2                                  ; $03 = blinking flag
    LDA.W SpriteMisc1558,X                    ; $05 = counter for the current tile
    STA.B _3
CODE_02BF84:
    LDX.B _5
    LDA.B _0
    CLC                                       ; Store X position.
    %LorW_X(ADC,DATA_02BF49)
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position.
    %LorW_X(ADC,DATA_02BF4E)
    STA.W OAMTileYPos+$100,Y
    %LorW_X(LDA,DATA_02BF53)
    STA.W OAMTileAttr+$100,Y                  ; Store YXPPCCCT.
    CPX.B #$00
    BNE CODE_02BFAC
    LDA.B #$CA                                ; Tile to use for the Urchin's eyes when open.
    LDX.B _3
    BEQ +
    LDA.B #$CC                                ; Tile to use for the Urchin's eyes when blinking.
  + BRA +

CODE_02BFAC:
    LDX.B _2                                  ; Store tile number.
    %LorW_X(LDA,UrchinTiles)
  + STA.W OAMTileNo+$100,Y
    INY
    INY
    INY
    INY                                       ; Loop for all 5 tiles.
    INC.B _5
    LDA.B _5
    CMP.B #$05
    BNE CODE_02BF84
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDY.B #$02                                ; Upload 5 16x16 tiles.
    JMP CODE_02C82B


DATA_02BFC8:
    db $10,$F0

DATA_02BFCA:
    db $01,$FF

; Max X/Y speeds for the Rip Van Fish.
  - RTL                                       ; X/Y speed accelerations for the Rip Van Fish.

RipVanFishMain:
; Rip Van Fish misc RAM:
; $C2   - Sprite phase. 0 = sleeping, 1 = swimming.
; $151C - Timer for the swimming phase. The fish falls asleep when this hits 0.
; $1528 - Timer for spawning the Z's while asleep.
; $1570 - Frame counter for animation.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame.
; 0/1 = swimming, 2/3 = sleeping
; Rip Van Fish MAIN
    JSL GenericSprGfxRt2                      ; Draw a 16x16 sprite.
    LDA.B SpriteLock                          ; If sprites locked, return.
    BNE -
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Process interaction with Mario and other sprites.
    LDA.B SpriteXSpeed,X
    PHA
    LDA.B SpriteYSpeed,X
    PHA
    LDY.W InvinsibilityTimer                  ; \ Branch if Mario doesn't have star
    BEQ +                                     ; /
    EOR.B #$FF
    INC A
    STA.B SpriteYSpeed,X                      ; If Mario has star power, invert the fish's X and Y speeds (to make it swim away).
    LDA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.B SpriteXSpeed,X
  + JSR CODE_02C126                           ; Update horizontal direction based on X speed.
    JSR UpdateXPosNoGrvty                     ; Update X position.
    JSR UpdateYPosNoGrvty                     ; Update Y position.
    JSL CODE_019138                           ; Process interaction with objects.
    PLA
    STA.B SpriteYSpeed,X
    PLA
    STA.B SpriteXSpeed,X
    INC.W SpriteMisc1570,X
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |; If hitting a wall, clear X speed.
    BEQ +                                     ; /
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
  + LDA.W SpriteBlockedDirs,X
    AND.B #$0C                                ; If hitting a ceiling/floor, clear Y speed.
    BEQ +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.W SpriteInLiquid,X
    BNE +                                     ; If not in water, sink downwards.
    LDA.B #$10                                ; Sinking Y speed of the Rip Van Fish when out of water.
    STA.B SpriteYSpeed,X
  + LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02C02E
    dw CODE_02C08A

CODE_02C02E:
; Rip Van Fish phase pointers.
; 0 - Sleeping.
; 1 - Swimming.
; Rip Van Fish phase 0 - Sleeping
    LDA.B #$02                                ; Sinking Y speed for the Rip Van Fish when sleeping.
    STA.B SpriteYSpeed,X
    LDA.B TrueFrame
    AND.B #$03
    BNE CODE_02C044
    LDA.B SpriteXSpeed,X
    BEQ CODE_02C044                           ; Decelerate X speed to 0.
    BPL CODE_02C042
    INC.B SpriteXSpeed,X
    BRA CODE_02C044

CODE_02C042:
    DEC.B SpriteXSpeed,X
CODE_02C044:
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; Clear Y speed if hitting the ground, and shift on top of the block.
    LDA.B SpriteYPosLow,X
    AND.B #$F0
    STA.B SpriteYPosLow,X
  + JSL CODE_02C0D9                           ; Spawn the Zs.
    LDA.W ChuckIsWhistling                    ; Branch to wake up if the Whistling Chuck has blown his whistle.
    BNE CODE_02C072
    JSR CODE_02D4FA
    LDA.B _F
    ADC.B #$30
    CMP.B #$60
    BCS CODE_02C07B                           ; Branch to not wake up if not within 3 tiles both vertically and horizontally of the fish.
    JSR CODE_02D50C
    LDA.B _E
    ADC.B #$30
    CMP.B #$60
    BCS CODE_02C07B
CODE_02C072:
; Wake up and switch to swimming phase.
    INC.B SpriteTableC2,X                     ; Increase phase (to swimming).
    LDA.B #$FF                                ; How long the fish stays in its swimming phase.
    STA.W SpriteMisc151C,X
    BRA CODE_02C08A                           ; Start swimming phase right away.

CODE_02C07B:
    LDY.B #$02                                ; Not time to wake up.
    LDA.W SpriteMisc1570,X
    AND.B #$30
    BNE +                                     ; Handle the fish's sleeping animation.
    INY
  + TYA
    STA.W SpriteMisc1602,X
    RTL

CODE_02C08A:
    LDA.B TrueFrame                           ; Rip Van Fish phase 1 - swimming
    AND.B #$01
    BNE CODE_02C095                           ; Handle the timer for sending the fish back to sleep, and branch to switch back to sleeping if time to.
    DEC.W SpriteMisc151C,X
    BEQ CODE_02C0CA
CODE_02C095:
    LDA.B TrueFrame
    AND.B #$07                                ; Branch if not a frame to update X/Y speed.
    BNE CODE_02C0BB
    JSR CODE_02D4FA
    LDA.B SpriteXSpeed,X
    CMP.W DATA_02BFC8,Y
    BEQ +                                     ; Accelerate horizontally towards Mario.
    CLC
    ADC.W DATA_02BFCA,Y
    STA.B SpriteXSpeed,X
  + JSR CODE_02D50C
    LDA.B SpriteYSpeed,X
    CMP.W DATA_02BFC8,Y
    BEQ CODE_02C0BB                           ; Accelerate vertically towards Mario.
    CLC
    ADC.W DATA_02BFCA,Y
    STA.B SpriteYSpeed,X
CODE_02C0BB:
    LDY.B #$00
    LDA.W SpriteMisc1570,X
    AND.B #$04
    BEQ +                                     ; Handle the fish's swimming animation.
    INY
  + TYA
    STA.W SpriteMisc1602,X
    RTL

CODE_02C0CA:
; Time to fall asleep again.
    STZ.B SpriteTableC2,X                     ; Return to sleeping state.
    JMP CODE_02C02E                           ; Jump back to the sleeping phase right away.

ADDR_02C0CF:
    LDA.B #$08                                ; \ Unreachable; Unused subroutine for the exploding block to spawn a now-unused minor extended sprite (musical notes?)
    LDY.W SpriteMisc157C,X                    ; | A = #$08 or #$09 depending on sprite direction; Spawn either sprite 7 or 8 (unused Z's/notes) depending on the direction the block is facing.
    BEQ +                                     ; |
    INC A                                     ; /
  + BRA +

CODE_02C0D9:
; Subroutine to spawn Zs for the Rip Van Fish.
    LDA.B #$06                                ; Extended sprite the Rip Van Fish spawns (a Z).
  + TAY
    LDA.W SpriteOffscreenX,X                  ; \ Return if sprite is offscreen
    ORA.W SpriteOffscreenVert,X               ; |
    BNE Return02C125                          ; /; Return if offscreen or not time to spawn a Z.
    TYA
    DEC.W SpriteMisc1528,X
    BPL Return02C125
    PHA
    LDA.B #$28                                ; How long to wait between spawning Z's.
    STA.W SpriteMisc1528,X
    LDY.B #$0B
CODE_02C0F2:
    LDA.W MinExtSpriteNumber,Y
    BEQ CODE_02C107
    DEY
    BPL CODE_02C0F2                           ; Find an empty minor extended sprite slot,
    DEC.W MinExtSpriteSlotIdx                 ; or overwrite one if none found.
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
    STA.W MinExtSpriteXPosLow,Y               ; Spawn at the sprite's position.
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$00
    STA.W MinExtSpriteYPosLow,Y
    LDA.B #$7F                                ; Number of frames to display the Z's for.
    STA.W MinExtSpriteTimer,Y
    LDA.B #$FA                                ; Initial X speed for the Z's.
    STA.W MinExtSpriteXSpeed,Y
Return02C125:
    RTL

CODE_02C126:
; Equivalent routine in bank 1 at $019A15.
    LDY.B #$00                                ; Subroutine to update a sprite's direction based on its current X speed.
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
; Frames between each animation frame in the Chuck's digging animation.
; Animation frames for the Chuck's digging animation.
; Chuck phase 4 - Diggin'
    LDA.W SpriteMisc1558,X                    ; Branch if not currently making the Chuck face the screen.
    BEQ CODE_02C156                           ; (for his head turn animation prior to digging)
    CMP.B #$01                                ; Branch if the head turn animation is still going on.
    BNE +
    LDA.B #$30                                ; Set timer for waiting to do the digging animation.
    STA.W SpriteMisc1540,X
    LDA.B #$04                                ; Set an initial counter for the number of rocks to dig up. Any multiple of 4 work, though (smaller = more rocks).
    STA.W SpriteMisc1534,X
    STZ.W SpriteMisc1570,X                    ; Clear animation frame counter.
; Not done with the head turn yet.
  + LDA.B #$02                                ; Turn the Chuck's head towards the screen.
    STA.W SpriteMisc151C,X
    RTS

CODE_02C156:
; Not facing the screen right now.
    LDA.W SpriteMisc1540,X                    ; Branch if not changing animation frames for the digging animation.
    BNE CODE_02C181
    INC.W SpriteMisc1534,X
    LDA.W SpriteMisc1534,X                    ; Get new index to the animation frame data.
    AND.B #$03
    STA.W SpriteMisc1570,X
    TAY
    LDA.W DATA_02C132,Y                       ; Set timer for waiting until the next animation frame.
    STA.W SpriteMisc1540,X
    CPY.B #$01                                ; Branch if not spawning the rock on this animation frame (frame 1).
    BNE CODE_02C181
    LDA.W SpriteMisc1534,X
    AND.B #$0C                                ; Branch if not done spawning rocks.
    BNE +
    LDA.B #$40                                ; Set the timer for the next turning animation.
    STA.W SpriteMisc1558,X
    RTS

; Time to spawn a rock.
  + JSR CODE_02C19A                           ; Spawn a rock.
CODE_02C181:
    LDY.W SpriteMisc1570,X                    ; In the digging animation, but not spawning a rock.
    LDA.W DATA_02C136,Y                       ; Set the Chuck's actual animation frame.
    STA.W SpriteMisc1602,X
    LDY.W SpriteMisc157C,X
    LDA.W DATA_02C1F3,Y                       ; Set the direction of the Chuck's head based on his body.
    STA.W SpriteMisc151C,X
    RTS


DATA_02C194:
    db $14,$EC

DATA_02C196:
    db $00,$FF

DATA_02C198:
    db $08,$F8

CODE_02C19A:
; X offsets (lo) from the Diggin' Chuck to spawn rocks at.
; X offsets (hi) from the Diggin' Chuck to spawn rocks at.
; X speeds to give the Diggin' Chuck's rocks.
; Routine to spawn a Diggin' Chuck's rock.
    JSL FindFreeSprSlot                       ; \ Return if no free slots; Return if there are no free sprite slots.
    BMI +                                     ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$48                                ; Sprite to spawn (Chuck's rock).
    STA.W SpriteNumber,Y
    LDA.W SpriteMisc157C,X
    STA.B _2
    LDA.B SpriteXPosLow,X                     ; $00 = 16-bit X position
    STA.B _0                                  ; $02 = Chuck's direction
    LDA.W SpriteXPosHigh,X
    STA.B _1
    PHX
    TYX
    JSL InitSpriteTables
    LDX.B _2
    LDA.B _0
    CLC
    ADC.W DATA_02C194,X                       ; Store X position of the rock.
    STA.W SpriteXPosLow,Y
    LDA.B _1
    ADC.W DATA_02C196,X
    STA.W SpriteXPosHigh,Y
    LDA.W DATA_02C198,X                       ; Store X speed.
    STA.W SpriteXSpeed,Y
    PLX
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$0A
    STA.W SpriteYPosLow,Y                     ; Store Y position, embedded in the ground below the Chuck.
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    LDA.B #$C0                                ; Initial Y speed for the Diggin' Chuck's rock after being dug up.
    STA.W SpriteYSpeed,Y
    LDA.B #$2C                                ; Set the timer for the digging animation.
    STA.W SpriteMisc1540,Y
  + RTS


DATA_02C1F3:
    db $01,$03

ChucksMain:
; Chuck misc RAM:
; $C2   - Phase pointer.
; 0 = looking side to side, 1 = charging, 2 = preparing to charge, 3 = hurt, 4 = digging, 5 = preparing to jump/split,
; 6 = jumping, 7 = landing from a jump, 8 = clappin', 9 = puntin', A = pitchin', B = waiting to whistle, C = whistling
; $151C - Animation frame for the Chuck's head.
; 0 = right, 1 = slightly right, 2 = towards screen, 3 = slightly left, 4 = left, 5 = diagonally up-left, 6 = diagonally up-right
; $1528 - Counter for the number of times Mario has bounced on the Chuck. Killed when it hits 3.
; $1534 - Various.
; Chargin'  - Used in phase 0 (looking side-to-side) as a counter to indicate which way the Chuck's head is turning (even = right, odd = left).
; Diggin'   - Counter for the animation frames in the digging animation, for determining when to stop digging.
; Pitchin'  - Flag for whether the Chuck is currently jumping.
; $1540 - Various timers.
; Chargin'  - Phase timers for phases 0/1/2. Phase 1 manually resets this to #$20 every frame that Mario is in the Chuck's line of sight.
; Hurt      - Animation timer for each phase of the hurt animation.
; Diggin'   - Timer for the digging animation.
; Pitchin'  - Timer for each "set" of baseballs (stops throwing when this passes #$40). When jumping, is also used as a timer for the jump.
; Clappin'  - Timer for waiting between each 'hop' or actual jump.
; Splittin' - Timer for waiting to split once Mario is close enough.
; Bouncin'  - Timer for waiting to bounce once Mario is close enough.
; $1558 - Various timers.
; Diggin'   - Timer for the head-turn animation prior to starting to dig.
; Pitchin'  - Timer set to #$08 immediately after throwing a baseball, to prevent throwing extra baseballs.
; $1564 - Timer to disable contact with Mario.
; $1570 - Various.
; Hurt      - Counter for the current phase of the hurt animnation.
; Diggin'   - Animation frame for the shovel. Valid values are 0-3.
; $157C - Horizontal direction the Chuck's body is facing.
; $1594 - In phase 0 (looking side-to-side), used as a counter for the current frame of animation in the Chuck's head turning animation.
; $15AC - Timer for the "starting to run" animation frame when beginning a charge.
; $1602 - Animation frame.
; 0 = sitting left/right, 1/2 = unused, 3 = sitting towards screen, 4 = crouching (clappin' chuck's), 5 = sitting slightly left/right,
; 6 = whistling/jumping, 7 = clapping, 8 = unused, 9 = crouching, A/B/C/D = hurt, E/F/10 = digging, 11 = kicking, 12/13 = running
; 14 = Waiting to throw a baseball, 15/16/17 = jumping and throwing baseball, 18/19 = throwing baseball
; $160E - Used by the Clappin' Chuck as a flag for whether it's hopping on the ground (0) or doing an actual jump (1).
; $163E - Unused timer that gets set when Mario first enters a Chargin' Chuck's line of sight, and cleared when the Chuck is hit.
; $187B - Various.
; Chargin' - Flag for whether Mario has entered the Chuck's line of sight at some point during his charge. Must be set in order to break turn/throwblocks.
; Pitchin' - Spawn X position mod 4, for determining how long to throw baseballs for in each set.
; $1FE2 - Used by the Clappin' Chuck as a timer to prevent the 'clap' sound effect from playing more than once.
    PHB                                       ; Chuck MAIN.
    PHK
    PLB
    LDA.W SpriteMisc187B,X
    PHA
    JSR CODE_02C22C                           ; Run main Chuck routine.
    PLA
    BNE +
    CMP.W SpriteMisc187B,X
    BEQ +
    LDA.W SpriteMisc163E,X                    ; If Mario was just spotted, set an unused timer.
    BNE +                                     ; Related to the unused code at $02C6B5.
    LDA.B #$28
    STA.W SpriteMisc163E,X
  + PLB
    RTL


DATA_02C213:
    db $01,$02,$03,$02

; Animation frames to give the Chuck's head when dying.
  - LDA.B EffFrame                            ; Animation for the Chuck dying.
    LSR A
    LSR A
    AND.B #$03                                ; Handle the death animation (shaking the Chuck's head).
    TAY
    LDA.W DATA_02C213,Y
    STA.W SpriteMisc151C,X
    JSR CODE_02C81A                           ; Draw GFX.
    RTS


DATA_02C228:
    db $40,$10

DATA_02C22A:
    db $03,$01

CODE_02C22C:
; Max falling speeds for Chucks. First value is out of water, second is in.
; Gravity for Chucks. First value is out of water, second is in.
    LDA.W SpriteStatus,X                      ; Actual main routine for the Chucks.
    CMP.B #$08                                ; Branch to just handle graphics if dying.
    BNE -
    LDA.W SpriteMisc15AC,X
    BEQ +                                     ; If just starting to charge, set an "inbetween" animation frame for the Chuck (5).
    LDA.B #$05
    STA.W SpriteMisc1602,X
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if on ground
    AND.B #$04                                ; |
    BNE +                                     ; /
    LDA.B SpriteYSpeed,X
    BPL +                                     ; Handle the animation frame for when the Chuck is jumping (6).
    LDA.B SpriteTableC2,X
    CMP.B #$05
    BCS +
    LDA.B #$06
    STA.W SpriteMisc1602,X
  + JSR CODE_02C81A                           ; Draw GFX.
    LDA.B SpriteLock                          ; Branch if game isn't frozen.
    BEQ +
    RTS

; Game isn't frozen.
  + JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSR CODE_02C79D                           ; Process interaction with Mario.
    JSL SprSprInteract                        ; Process interaction with sprites.
    JSL CODE_019138                           ; Process interaction with blocks.
    LDA.W SpriteBlockedDirs,X
    AND.B #$08
    BEQ +
    LDA.B #$10                                ; Y speed to give the Chuck when it hits a ceiling.
    STA.B SpriteYSpeed,X
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |; Branch if not blocked on the left/right.
    BEQ CODE_02C2F4                           ; /
    LDA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    BNE CODE_02C2E4
    LDA.W SpriteMisc187B,X                    ; Branch to make the Chuck jump if:
    BEQ CODE_02C2E4                           ; Offscreen
    LDA.B SpriteXPosLow,X                     ; Not chasing after Mario
    SEC                                       ; Not far enough onscreen (about 1 tile)
    SBC.B Layer1XPos                          ; Touching the side of Layer 2
    CLC                                       ; Not touching a turnblock/throwblock
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
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground; Chuck is breaking a block.
    AND.B #$04                                ; |; Branch if not on the ground.
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
    LDA.B #$02                                ; \ Block to generate = #$02; Shatter the lower block.
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile
    PLA
    SEC
    SBC.B #$10
    STA.B TouchBlockYPos
    PLA
    SBC.B #$00                                ; Shift the block position up one tile.
    STA.B TouchBlockYPos+1
    PLA
    STA.B TouchBlockXPos
    PLA
    STA.B TouchBlockXPos+1
    JSL ShatterBlock
    LDA.B #$02                                ; \ Block to generate = #$02; Shatter the upper block.
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile
    BRA CODE_02C2F4

CODE_02C2E4:
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground; Chuck is blocked but not able to break; make him jump instead.
    AND.B #$04                                ; |; Branch if not on the ground.
    BEQ CODE_02C2F7                           ; /
    LDA.B #$C0                                ; Y speed for the Chuck's jumps after running into a block
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty                     ; Update Y position.
    BRA +

CODE_02C2F4:
; Chuck is not blocked on the side.
    JSR UpdateXPosNoGrvty                     ; Update X position.
CODE_02C2F7:
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground; Chuck is blocked on the side but not on the ground.
    AND.B #$04                                ; |; If on the ground, clear X/Y speed.
    BEQ +                                     ; /
    JSR CODE_02C579
; Done with routine for being blocked on the side.
  + JSR UpdateYPosNoGrvty                     ; Update Y position.
    LDY.W SpriteInLiquid,X
    CPY.B #$01
    LDY.B #$00
    LDA.B SpriteYSpeed,X                      ; Handle gravity.
    BCC +
    INY
    CMP.B #$00
    BPL +
    CMP.B #$E0                                ; Limit rising speed in water to E0 (-32).
    BCS +
    LDA.B #$E0
  + CLC                                       ; Apply appropriate gravity based on whether the Chuck is in water.
    ADC.W DATA_02C22A,Y
    BMI +
    CMP.W DATA_02C228,Y                       ; Limit falling speed for the water, too.
    BCC +
    LDA.W DATA_02C228,Y
  + TAY
    BMI +
    LDY.B SpriteTableC2,X
    CPY.B #$07                                ; If the Chuck just landed, increase his Y speed slightly more, for some reason.
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
; Chuck phase pointers.
; 0 - Looking from side to side (Chargin')
; 1 - Chargin'
; 2 - Preparing to charge
; 3 - Hurt
; 4 - Diggin'
; 5 - Preparing to jump/split (Bouncin', Splittin')
; 6 - Jumping (Bouncin')
; 7 - Landing from a jump (Bouncin')
; 8 - Clappin'
; 9 - Puntin'
; A - Pitchin'
; B - Waiting to whistle
; C - Whistling
; Chuck routine B - Waiting to whistle
    LDA.B #$03                                ; Set animation frame as stationary.
    STA.W SpriteMisc1602,X
    LDA.W SpriteInLiquid,X
    BEQ +
    JSR CODE_02D4FA
    LDA.B _F                                  ; If the Chuck is in water and Mario is within 3 tiles horizontally,
    CLC                                       ; switch to whistling.
    ADC.B #$30
    CMP.B #$60
    BCS +
    LDA.B #$0C
    STA.B SpriteTableC2,X
  + JMP CODE_02C556                           ; Face Mario.


DATA_02C373:
    db $05,$05,$05,$02,$02,$06,$06,$06

CODE_02C37B:
; Animation frames for the Chuck's head during the whistle animation.
    LDA.B EffFrame                            ; Chuck routine C - Whistling
    AND.B #$3F                                ; Handle the whistle sound.
    BNE +
    LDA.B #!SFX_WHISTLE                       ; \ Play sound effect; SFX for the Chuck whistling.
    STA.W SPCIO3                              ; /
  + LDY.B #$03
    LDA.B EffFrame
    AND.B #$30
    BEQ +                                     ; Use animation frames 3/6 for the whistle animation.
    LDY.B #$06
  + TYA
    STA.W SpriteMisc1602,X
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$07                                ; Animate the Chuck's head.
    TAY
    LDA.W DATA_02C373,Y
    STA.W SpriteMisc151C,X
    LDA.B SpriteXPosLow,X
    LSR A
    LSR A
    LSR A
    LSR A                                     ; Set the flag to indicate the Whistlin' Chuck is whistling (for Rip Van Fish).
    LSR A
    LDA.B #$09                                ; If the Chuck is in an odd X position, also start the Super Koopa generator.
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
; Length of the Baseball Chuck's throwing "sets", indexed by its X position mod 4.
; Effectively equates to 2, 4, 6, and 5 baseballs respectively.
; Animation frames for the Baseball Chuck's throwing animation.
; Animation frames for the Baseball Chuck's throwing animation during a jump.
; Chuck routine A - Pitchin'
    LDA.W SpriteMisc1534,X                    ; Branch if the Chuck is already jumping.
    BNE CODE_02C43A
    JSR CODE_02D50C
    LDA.B _E
    BPL +                                     ; If Mario is at least 2 tiles above the Chuck, make him jump.
    CMP.B #$D0
    BCS +
    LDA.B #$C8                                ; Y speed the Pitchin' Chuck jumps with.
    STA.B SpriteYSpeed,X
    LDA.B #$3E
    STA.W SpriteMisc1540,X
    INC.W SpriteMisc1534,X
  + LDA.B TrueFrame
    AND.B #$07
    BNE +                                     ; Extend the timer for throwing slightly.
    LDA.W SpriteMisc1540,X                    ; (adds 1/8th the time, or between 15 and 30 frames depending on the initial timer)
    BEQ +
    INC.W SpriteMisc1540,X
  + LDA.B EffFrame
    AND.B #$3F                                ; Face the Chuck towards Mario every 64 frames.
    BNE +                                     ; (note that this doesn't apply when jumping)
    JSR CODE_02C556
  + LDA.W SpriteMisc1540,X
    BNE +
    LDY.W SpriteMisc187B,X                    ; If done with the current set of baseballs, start the next one.
    LDA.W DATA_02C3B3,Y
    STA.W SpriteMisc1540,X
  + LDA.W SpriteMisc1540,X
    CMP.B #$40                                ; Branch if still throwing baseballs for the current set.
    BCS +
    LDA.B #$00                                ; Animation for the Chuck inbetween sets of baseballs.
    STA.W SpriteMisc1602,X
    RTS

  + SEC                                       ; Baseball Chuck is in the process of throwing a set of baseballs.
    SBC.B #$40
    LSR A
    LSR A
    LSR A                                     ; Get the animation frame for the throwing animation.
    AND.B #$03
    TAY
    LDA.W DATA_02C3B7,Y
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    AND.B #$1F                                ; How often the Baseball Chuck throws a baseball (every 32 frames).
    CMP.B #$06
    BNE Return02C439                          ; Spawn a baseball when time to do so.
    JSR CODE_02C466
    LDA.B #$08
    STA.W SpriteMisc1558,X
Return02C439:
    RTS

CODE_02C43A:
; Baseball Chuck is jumping.
    LDA.W SpriteMisc1540,X                    ; Branch if done with the jump.
    BEQ CODE_02C45C
    PHA
    CMP.B #$20
    BCC +
    CMP.B #$30                                ; Clear the Chuck's Y speed if at the height of its jump (timer between 20 and 30).
    BCS +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LSR A
    LSR A
    TAY                                       ; Set the animation frame for the throwing animation.
    LDA.W DATA_02C3BB,Y
    STA.W SpriteMisc1602,X
    PLA
    CMP.B #$26
    BNE +                                     ; Actually spawn the baseball when time to do so.
    JSR CODE_02C466
  + RTS

CODE_02C45C:
; Done the jump.
    STZ.W SpriteMisc1534,X                    ; Clear the jumping flag.
    RTS


BaseballTileDispX:
    db $10,$F8

DATA_02C462:
    db $00,$FF

BaseballSpeed:
    db $18,$E8

CODE_02C466:
; X offsets (lo) for the baseballs spawned by the Pitchin' Chuck.
; X offsets (hi) for the baseballs spawned by the Pitchin' Chuck.
; X speeds for the baseballs spawned by the Pitchin' Chuck.
    LDA.W SpriteMisc1558,X                    ; Subroutine to spawn a baseball for the Pitchin' Chuck.
    ORA.W SpriteOffscreenVert,X               ; Return if the Chuck is offscreen, or has already spawned a baseball.
    BNE Return02C439
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_02C470:
    LDA.W ExtSpriteNumber,Y                   ; |; Find an empty extended sprite slot.
    BEQ CODE_02C479                           ; |
    DEY                                       ; |
    BPL CODE_02C470                           ; |
    RTS                                       ; / Return if no free slots

CODE_02C479:
    LDA.B #$0D                                ; \ Extended sprite = Baseball; Extended sprite to spawn (baseball)
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$00
    STA.W ExtSpriteYPosLow,Y                  ; Spawn at the Chuck's Y position.
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W ExtSpriteYPosHigh,Y
    PHX
    LDA.W SpriteMisc157C,X
    TAX
    LDA.B _0
    CLC
    ADC.W BaseballTileDispX,X                 ; Spawn at the Chuck's X position, offset in front of it.
    STA.W ExtSpriteXPosLow,Y
    LDA.B _1
    ADC.W DATA_02C462,X
    STA.W ExtSpriteXPosHigh,Y
    LDA.W BaseballSpeed,X                     ; Store the baseball's X speed.
    STA.W ExtSpriteXSpeed,Y
    PLX
    RTS


DATA_02C4B5:
    db $00,$00,$11,$11,$11,$11,$00,$00

CODE_02C4BD:
; Animation frames for the Puntin' Chuck's kick animation.
; Chuck phase 9 - Puntin'
    STZ.W SpriteMisc1602,X                    ; Use animation frame 0 as a base.
    TXA
    ASL A
    ASL A
    ASL A
    ADC.B TrueFrame
    AND.B #$7F
    CMP.B #$00                                ; Every 128 frames, face towards Mario and spawn a football.
    BNE +
    PHA
    JSR CODE_02C556
    JSL CODE_03CBB3
    PLA
  + CMP.B #$20
    BCS +
    LSR A
    LSR A                                     ; When about to kick a football, show the kick animation.
    TAY
    LDA.W DATA_02C4B5,Y
    STA.W SpriteMisc1602,X
  + RTS

CODE_02C4E3:
; Chuck routine A - Clappin'
    JSR CODE_02C556                           ; Face towards Mario.
    LDA.B #$06
    LDY.B SpriteYSpeed,X
    CPY.B #$F0
    BMI CODE_02C504                           ; Handle the animation frame.
    LDY.W SpriteMisc160E,X                    ; Use 6 when jumping, 7 when clapping.
    BEQ CODE_02C504
    LDA.W SpriteMisc1FE2,X
    BNE +
    LDA.B #!SFX_CLAP                          ; \ Play sound effect; SFX for the Clappin' Chuck clapping.
    STA.W SPCIO3                              ; /
    LDA.B #$20                                ; Set timer to prevent the sound from playing more than once.
    STA.W SpriteMisc1FE2,X
  + LDA.B #$07
CODE_02C504:
    STA.W SpriteMisc1602,X
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Return if the Chuck is still midjump.
    BEQ +                                     ; /
    STZ.W SpriteMisc160E,X
    LDA.B #$04                                ; Set animation frame for when on the ground (4).
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X                    ; Return if not time to either 'hop' or jump.
    BNE +
    LDA.B #$20                                ; Set timer until next jump.
    STA.W SpriteMisc1540,X
    LDA.B #$F0                                ; Y speed for the Clappin' Chuck's hops.
    STA.B SpriteYSpeed,X
    JSR CODE_02D50C
    LDA.B _E
    BPL +                                     ; Return Mario isn't at least 2 tiles above the Chuck.
    CMP.B #$D0
    BCS +
    LDA.B #$C0                                ; Y speed for the Clappin' Chuck's jump.
    STA.B SpriteYSpeed,X
    INC.W SpriteMisc160E,X
CODE_02C536:
    LDA.B #!SFX_SPRING                        ; \ Play sound effect; SFX for various Chuck's jumps.
    STA.W SPCIO3                              ; /
  + RTS

CODE_02C53C:
; Chuck phase 6 - Jumping (Bouncin')
    LDA.B #$06                                ; Set animation frame for jumping (6).
    STA.W SpriteMisc1602,X
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Return if not on the ground.
    BEQ +                                     ; /
    JSR CODE_02C579                           ; Clear X/Y speed.
    JSR CODE_02C556                           ; Face Mario.
    LDA.B #$08
    STA.W SpriteMisc1540,X                    ; Switch to landing phase, and set a brief timer for it.
    INC.B SpriteTableC2,X
  + RTS

CODE_02C556:
    JSR CODE_02D4FA                           ; Routine to make the Chuck face Mario.
    TYA
    STA.W SpriteMisc157C,X                    ; Face Mario.
    LDA.W DATA_02C639,Y
    STA.W SpriteMisc151C,X
    RTS

CODE_02C564:
; Chuck phase 7 - Landing from a jump (Bouncin')
    LDA.B #$03                                ; Set animation frame for landing (3).
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X                    ; Branch if not time to prepare the next jump.
    BNE CODE_02C579
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /; If still actually on the ground, switch to the "preparing to jump" phase.
    LDA.B #$05
    STA.B SpriteTableC2,X
CODE_02C579:
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0; Clear X/Y speed.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + RTS


DATA_02C57E:
    db $10,$F0

DATA_02C580:
    db $20,$E0

CODE_02C582:
; Initial X speeds for the two Chucks spawned by the Splittin' Chuck.
; X speeds for the Bouncin' Chuck when jumping.
; Chuck phase 5 - Preparing to jump/split (Bouncin' / Splittin')
    JSR CODE_02C556                           ; Face Mario.
    LDA.W SpriteMisc1540,X                    ; Branch if Mario hasn't gotten in range to initiate a jump.
    BEQ CODE_02C602
    CMP.B #$01                                ; Branch if not time to actually jump/split.
    BNE CODE_02C5FC
    LDA.B SpriteNumber,X
    CMP.B #$93                                ; Branch if not sprite 93 (Bouncin').
    BNE +
    JSR CODE_02D4FA
    LDA.W DATA_02C580,Y                       ; Set X speed towards Mario.
    STA.B SpriteXSpeed,X
    LDA.B #$B0                                ; Y speed the Bouncin' Chuck jumps with.
    STA.B SpriteYSpeed,X
    LDA.B #$06                                ; Switch to the jumping phase.
    STA.B SpriteTableC2,X
    JMP CODE_02C536                           ; Play the jump sound.

; Sprite 92 (splittin') is about to split.
  + STZ.B SpriteTableC2,X                     ; Switch to phase 0 (Sprintin')
    LDA.B #$50                                ; Set the base Chuck's timer for waiting to run after Mario.
    STA.W SpriteMisc1540,X
    LDA.B #!SFX_MAGIC                         ; \ Play sound effect; SFX for the Splittin' Chuck splitting apart.
    STA.W SPCIO0                              ; /
    STZ.W TileGenerateTrackA
    JSR CODE_02C5BC                           ; Run the below routine twice to spawn two Chucks.
    INC.W TileGenerateTrackA
CODE_02C5BC:
    JSL FindFreeSprSlot                       ; Return if no free sprite slot exists.
    BMI CODE_02C5FC
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /; Spawn sprite 91 (Chargin' Chuck)
    LDA.B #$91
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y                    ; Spawn the new Chuck at this one's position.
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    LDX.W TileGenerateTrackA
    LDA.W DATA_02C57E,X                       ; Set initial X speed.
    STA.W SpriteXSpeed,Y
    PLX
    LDA.B #$C8                                ; Initial Y speed for the two split Chucks.
    STA.W SpriteYSpeed,Y
    LDA.B #$50                                ; Set the new Chuck's timer for waiting to run after Mario.
    STA.W SpriteMisc1540,Y
CODE_02C5FC:
    LDA.B #$09                                ; Animation frame to use for the original Chuck while waiting to jump/split (9).
    STA.W SpriteMisc1602,X
    RTS

CODE_02C602:
    JSR CODE_02D4FA                           ; A jump/split hasn't yet been initiated.
    TYA                                       ; Face Mario (in spirit, not in graphics).
    STA.W SpriteMisc157C,X
    LDA.B _F
    CLC
    ADC.B #$50                                ; Branch if mario isn't within 5 blocks.
    CMP.B #$A0
    BCS +
    LDA.B #$40                                ; Set timer for waiting to split/bounce.
    STA.W SpriteMisc1540,X
    RTS

; Mario still isn't close enough to start a jump/split yet.
  + LDA.B #$03                                ; Animation frame for the Chuck waiting for Mario (3).
    STA.W SpriteMisc1602,X
    LDA.B TrueFrame
    AND.B #$3F                                ; Make the Chuck jump every so often while it waits.
    BNE +
    LDA.B #$E0                                ; How fas the Chuck 'hops' with while waiting for Mario to get close.
    STA.B SpriteYSpeed,X
  + RTS

CODE_02C628:
; Chuck subroutine to set a timer for the "inbetween" animation frame when starting to charge.
    LDA.B #$08                                ; How long the animation frame lasts.
    STA.W SpriteMisc15AC,X
    RTS


DATA_02C62E:
    db $00,$00,$00,$00,$01,$02,$03,$04
    db $04,$04,$04

DATA_02C639:
    db $00,$04

CODE_02C63B:
; Animation frames for the head-turning animation the Chuck uses when waiting to charge.
; Head animation frames for the Chuck when facing towards Mario.
; Chuck phase 0 - Looking from side to side.
    LDA.B #$03                                ; Animation frame for the Chuck while waiting to charge (3).
    STA.W SpriteMisc1602,X
    STZ.W SpriteMisc187B,X                    ; Clear flag for whether Mario has been found.
    LDA.W SpriteMisc1540,X
    AND.B #$0F                                ; Branch if not a frame to check whether to run towards Mario.
    BNE +
    JSR CODE_02D50C
    LDA.B _E
    CLC
    ADC.B #$28                                ; If Mario is within 2 tiles vertically, face him and mark him in the Chuck's line of sight.
    CMP.B #$50
    BCS +
    JSR CODE_02C556
    INC.W SpriteMisc187B,X
CODE_02C65C:
    LDA.B #$02                                ; Switch to the phase 2 (preparing to charge).
    STA.B SpriteTableC2,X
    LDA.B #$18                                ; How long the Chuck waits before actually charging.
    STA.W SpriteMisc1540,X
    RTS


DATA_02C666:
    db $01,$FF

; Increment/decrement values for handling the Chargin' Chuck's head-turning animation prior to a charge.
; Not a frame to actually check for Mario.
  + LDA.W SpriteMisc1540,X                    ; Branch if not yet time to force an auto-run.
    BNE CODE_02C677
    LDA.W SpriteMisc157C,X
    EOR.B #$01                                ; Turn to the opposite direction the Chuck is currently facing.
    STA.W SpriteMisc157C,X
    BRA CODE_02C65C                           ; Switch to preparing to charge.

CODE_02C677:
    LDA.B EffFrame                            ; Not forcing an auto-run either.
    AND.B #$03
    BNE CODE_02C691
    LDA.W SpriteMisc1534,X
    AND.B #$01
    TAY
    LDA.W SpriteMisc1594,X
    CLC                                       ; Handle the animation for the Chuck's head.
    ADC.W DATA_02C666,Y                       ; Use $1534 as the direction to currently turn;
    CMP.B #$0B                                ; then use $1594 as a counter for determining the actual frame for the Chuck's head (in $151C).
    BCS +
    STA.W SpriteMisc1594,X
CODE_02C691:
    LDY.W SpriteMisc1594,X
    LDA.W DATA_02C62E,Y
    STA.W SpriteMisc151C,X
    RTS

  + INC.W SpriteMisc1534,X                    ; Chuck has completed a turn to either side, so set him to start turning the other way next time.
    RTS


DATA_02C69F:
    db $10,$F0,$18,$E8

DATA_02C6A3:
    db $12,$13,$12,$13

CODE_02C6A7:
; Running X speeds for the Chargin' Chuck. Seperate speeds are used depending on whether it's running towards Mario.
; Auto-running
; Running towards Mario
; Animation frames for the Chargin' Chuck's run animation.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground; Chuck phase 1 - Chargin'
    AND.B #$04                                ; |
    BEQ +                                     ; /; Always branches.
    LDA.W SpriteMisc163E,X                    ; Would have played the below sound effect when the Chuck is on the ground and Mario has just been spotted.
    CMP.B #$01
    BRA +

    LDA.B #!SFX_NOTICEMESENPAI                ; \ Unreachable; Unused SFX for the Chuck spotting Mario.
    STA.W SPCIO0                              ; / Play sound effect
  + JSR CODE_02D50C
    LDA.B _E
    CLC
    ADC.B #$30
    CMP.B #$60
    BCS +                                     ; If Mario is vertically within 3 tiles of the Chuck and in front of him,
    JSR CODE_02D4FA                           ; reset the Chuck's run timer and indicate that Mario is in his line of sight.
    TYA
    CMP.W SpriteMisc157C,X
    BNE +
    LDA.B #$20
    STA.W SpriteMisc1540,X
    STA.W SpriteMisc187B,X
  + LDA.W SpriteMisc1540,X
    BNE +
    STZ.B SpriteTableC2,X
    JSR CODE_02C628                           ; If finished running, switch to phase 0 (looking side-to-side),
    JSL GetRand                               ; and set the timer for the charging phase.
    AND.B #$3F
    ORA.B #$40
    STA.W SpriteMisc1540,X
  + LDY.W SpriteMisc157C,X
    LDA.W DATA_02C639,Y                       ; Set the Chuck's head to face the direction it's running in.
    STA.W SpriteMisc151C,X
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Branch if the Chuck isn't on the ground.
    BEQ CODE_02C713                           ; /
    LDA.W SpriteMisc187B,X
    BEQ CODE_02C70E
    LDA.B EffFrame                            ; Branch if not running towards Mario.
    AND.B #$07
    BNE +
    LDA.B #!SFX_BONK                          ; \ Play sound effect; SFX for the Chargin' Chuck's run. Only plays when running towards Mario, not auto-running.
    STA.W SPCIO0                              ; /
  + INY
    INY
CODE_02C70E:
    LDA.W DATA_02C69F,Y                       ; Set X speed for the Chuck. Different X speeds are used when running towards Mario vs. auto-running.
    STA.B SpriteXSpeed,X
CODE_02C713:
    LDA.B TrueFrame
    LDY.W SpriteMisc187B,X
    BNE +
    LSR A
  + LSR A                                     ; Set animation frame for the Chuck. Animate half as fast when auto-running.
    AND.B #$03
    TAY
    LDA.W DATA_02C6A3,Y
    STA.W SpriteMisc1602,X
    RTS

CODE_02C726:
; Chuck phase 2 - preparing to charge.
    LDA.B #$03                                ; Animation frame to use (3).
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X                    ; Return if not time to actually charge.
    BNE +
    JSR CODE_02C628                           ; Set a timer for the 'starting to run' animation frame.
    LDA.B #$01                                ; Switch to phase 1 (charging).
    STA.B SpriteTableC2,X
    LDA.B #$40                                ; Set the auto-run timer for the charging phase.
    STA.W SpriteMisc1540,X
  + RTS


DATA_02C73D:
    db $0A,$0B,$0A,$0C,$0D,$0C

DATA_02C743:
    db $0C,$10,$10,$04,$08,$10,$18

CODE_02C74A:
; Animation frames for each phase of the hurt animation.
; Animation timers for each phase of the hurt animation.
    LDY.W SpriteMisc1570,X                    ; Chuck phase 3 - Hurt
    LDA.W SpriteMisc1540,X
    BNE CODE_02C760
    INC.W SpriteMisc1570,X                    ; Set timer for the current phase of the hurt animation.
    INY                                       ; Branch if done with the hurt animation.
    CPY.B #$07
    BEQ CODE_02C777
    LDA.W DATA_02C743,Y
    STA.W SpriteMisc1540,X
CODE_02C760:
    LDA.W DATA_02C73D,Y                       ; Get the the animation frame for the current phase of the hurt animation.
    STA.W SpriteMisc1602,X
    LDA.B #$02
    CPY.B #$05
    BNE +
    LDA.B EffFrame
    LSR A                                     ; Get the animation frame for the Chuck's head. Normally, fully forward (3).
    NOP                                       ; In phase 5 of the hurt animation though, makes the head shake from side to side (2-4).
    AND.B #$02
    INC A
  + STA.W SpriteMisc151C,X
    RTS

CODE_02C777:
    LDA.B SpriteNumber,X                      ; Done with the hurt animation.
    CMP.B #$94                                ; Brnach for sprite 94 (Whistlin' Chuck).
    BEQ CODE_02C794
    CMP.B #$46
    BNE +                                     ; Except for sprite 46 (Diggin' Chuck),
    LDA.B #$91                                ; transform the sprite into sprite 91 (Chargin' Chuck).
    STA.B SpriteNumber,X
  + LDA.B #$30                                ; Set the timer for the "waiting to charge" phase for the Chuck.
    STA.W SpriteMisc1540,X
    LDA.B #$02                                ; Switch to phase 2 (waiting to charge).
    STA.B SpriteTableC2,X
    INC.W SpriteMisc187B,X                    ; Mark Mario in the Chuck's line of sight.
    JMP CODE_02C556                           ; Face Mario.

CODE_02C794:
; Done with the Whistlin' Chuck's hurt animation.
    LDA.B #$0C                                ; Switch to phase C (whistling).
    STA.B SpriteTableC2,X
    RTS


    db $F0,$10

DATA_02C79B:
    db $20,$E0

CODE_02C79D:
; Unused table?
; X speeds to give Mario when bouncing off of a Chuck.
; Routine to process Mario interaction with Chucks.
    LDA.W SpriteMisc1564,X                    ; Return if contact with Mario is temporarily disabled.
    BNE Return02C80F
    JSL MarioSprInteract                      ; Return if not in contact with Mario.
    BCC Return02C80F
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario doesn't have star
    BEQ +                                     ; /
    LDA.B #$D0                                ; Y speed to give the Chuck when killed with star power.
    STA.B SpriteYSpeed,X
CODE_02C7B1:
; Chuck has been killed by Mario.
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0; Clear its X speed.
    LDA.B #$02                                ; \ Sprite status = Killed; Set as falling offscreen.
    STA.W SpriteStatus,X                      ; /
    LDA.B #!SFX_KICK                          ; \ Play sound effect; SFX for killing the Chuck.
    STA.W SPCIO0                              ; /
    LDA.B #$03                                ; Give 800 points.
    JSL GivePoints
    RTS

  + JSR CODE_02D50C                           ; Mario doesn't have star power.
    LDA.B _E                                  ; Branch to hurt Mario if too far below the Chuck.
    CMP.B #$EC
    BPL CODE_02C810
    LDA.B #$05                                ; Briefly disable extra contact with the Chuck.
    STA.W SpriteMisc1564,X
    LDA.B #!SFX_SPLAT                         ; \ Play sound effect; SFX for bouncing on a Chuck.
    STA.W SPCIO0                              ; /
    JSL DisplayContactGfx                     ; Display a contact sprite.
    JSL BoostMarioSpeed                       ; Make Mario bounce.
    STZ.W SpriteMisc163E,X                    ; Clear an unused timer.
    LDA.B SpriteTableC2,X
    CMP.B #$03                                ; Return if already in the Chuck's hurt state (only hurt once).
    BEQ Return02C80F
    INC.W SpriteMisc1528,X                    ; Increase Chuck stomp count
    LDA.W SpriteMisc1528,X                    ; \ Kill Chuck if stomp count >= 3; Count number of hits, and branch if not yet dead.
    CMP.B #$03                                ; |; Number of hits it takes to kill a Chuck.
    BCC CODE_02C7F6                           ; |
    STZ.B SpriteYSpeed,X                      ; | Sprite Y Speed = 0; Clear the Chuck's Y speed (in case it was jumping).
    BRA CODE_02C7B1                           ; /

CODE_02C7F6:
; Bounced off Chuck and didn't kill it.
    LDA.B #!SFX_ENEMYHURT                     ; \ Play sound effect; SFX for bouncing off a Chargin' Chuck.
    STA.W SPCIO3                              ; /
    LDA.B #$03                                ; Switch Chuck to hurt state.
    STA.B SpriteTableC2,X
    LDA.B #$03                                ; Set timer for the initial frame of the hurt animation.
    STA.W SpriteMisc1540,X
    STZ.W SpriteMisc1570,X                    ; Clear the counter for the hurt animation's phases.
    JSR CODE_02D4FA
    LDA.W DATA_02C79B,Y                       ; Give Mario an X speed depending on the side of the Chuck he hit.
    STA.B PlayerXSpeed+1
Return02C80F:
    RTS

CODE_02C810:
    LDA.W PlayerRidingYoshi                   ; Mario is too far below the Chuck to hit it.
    BNE +                                     ; Hurt Mario, unless riding Yoshi.
    JSL HurtMario
  + RTS

CODE_02C81A:
    JSR GetDrawInfo2                          ; Chuck GFX routine.
    JSR CODE_02C88C                           ; Draw the head.
    JSR CODE_02CA27                           ; Draw the body.
    JSR CODE_02CA9D                           ; Draw the hands, or Baseball Chuck's baseball.
    JSR CODE_02CBA1                           ; Draw the Diggin' Chuck's shovel.
    LDY.B #$FF
CODE_02C82B:
    LDA.B #$04                                ; Upload 5 manually-sized tiles.
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
; X offsets for the Chuck's head in each animation frame.
; Y offsets for the Chuck's head in each animation frame.
; OAM offsets for the head in each animation frame.
; Tile numbers for each head animation frame.
; X flips for each head animation frame.
    STZ.B _7                                  ; GFX subroutine for the Chuck's head.
    LDY.W SpriteMisc1602,X
    STY.B _4
    CPY.B #$09
    CLC
    BNE +                                     ; $00 = X position onscreen
    LDA.W SpriteMisc1540,X                    ; $01 = Y position onscreen
    SEC                                       ; $02 = Animation frame for the head
    SBC.B #$20                                ; $03 = Horizontal direction the Chuck's body facing
    BCC +                                     ; $04 = Animation frame for the Chuck
    PHA                                       ; $05 = Base OAM index of the Chuck
    LSR A                                     ; $07 = Extra Y offset used by animation frame 9 (crouching) to animate the head "ducking"
    LSR A                                     ; $08 = Base YXPPCCCT setting
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
    ADC.W DATA_02C864,Y                       ; Get OAM index for the head.
    TAY
    LDX.B _4
    %LorW_X(LDA,DATA_02C830)
    LDX.B _3
    BNE +
    EOR.B #$FF                                ; Store X position, accounting for which way the Chuck is turned.
    INC A
  + CLC
    ADC.B _0
    STA.W OAMTileXPos+$100,Y
    LDX.B _4
    LDA.B _1
    CLC
    %LorW_X(ADC,DATA_02C84A)
    SEC                                       ; Store Y position.
    SBC.B _7
    STA.W OAMTileYPos+$100,Y
    LDX.B _2
    %LorW_X(LDA,DATA_02C885)
    ORA.B _8                                  ; Store YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    %LorW_X(LDA,ChuckHeadTiles)
    STA.W OAMTileNo+$100,Y                    ; Store tile number.
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02                                ; Set size as 16x16.
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
; X offsets for the Chuck's first tile. Second set of values are when facing right.
; X offsets for the Chuck's second tile. Second set of values are when facing right.
; Y offsets for the Chuck's first tile. Second tile has no offset.
; Tile numbers for the Chuck's first tile.
; Tile numbers for the Chuck's second tile.
; Extra YXPPCCCT values for the Chuck's tiles.
; Extra YXPPCCCT values for the Chuck's second tile. EORed with the first, for X flipping.
; Sizes for the Chuck's first tile.
; OAM offsets for the Chuck's body.
; GFX subroutine for the Chuck's body.
    STZ.B _6                                  ; $00 = X position onscreen
    LDA.B _4                                  ; $01 = Y position onscreen
    LDY.B _3                                  ; $03 = Horizontal direction the Chuck's body facing
    BNE +                                     ; $04 = Animation frame for the Chuck
    CLC                                       ; $05 = Base OAM index of the Chuck
    ADC.B #$1A                                ; $06 = X bit of the YXPPCCCT setting
    LDX.B #$40                                ; $08 = Base YXPPCCCT setting
    STX.B _6
  + TAX
    LDY.B _4
    LDA.W DATA_02CA0D,Y
    CLC                                       ; Get OAM index for the body.
    ADC.B _5
    TAY
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02C909)
    STA.W OAMTileXPos+$100,Y                  ; Store X position of both tiles.
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02C93D)
    STA.W OAMTileXPos+$104,Y
    LDX.B _4
    LDA.B _1
    CLC
    %LorW_X(ADC,DATA_02C971)
    STA.W OAMTileYPos+$100,Y                  ; Store Y position of both tiles.
    LDA.B _1
    STA.W OAMTileYPos+$104,Y
    %LorW_X(LDA,ChuckBody1)
    STA.W OAMTileNo+$100,Y                    ; Store tile numbers.
    %LorW_X(LDA,ChuckBody2)
    STA.W OAMTileNo+$104,Y
    LDA.B _8
    ORA.B _6
    PHA
    %LorW_X(EOR,DATA_02C9BF)
    STA.W OAMTileAttr+$100,Y                  ; Store YXPPCCCT.
    PLA
    %LorW_X(EOR,DATA_02C9D9)
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY
    %LorW_X(LDA,DATA_02C9F3)
    STA.W OAMTileSize+$40,Y                   ; Store size of the tile.
    LDA.B #$02                                ; Second tile is always 16x16.
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
; X offsets for the first hand tile in frames 6/7.
; X offsets for the second hand tile in frames 6/7.
; Tile numbers for the hand tiles in frames 6/7.
; Y offsets for both hand tiles in frames 6/7.
; Tile sizes for the Chuck's hand tiles in frames 6/7.
    LDA.B _4                                  ; GFX subroutine for the Chuck's hands, or the Baesball Chuck's held baseball.
    CMP.B #$14                                ; $04 = Animation frame for the Chuck
    BCC +                                     ; If in frame 14+ (Baseball Chuck), jump down to draw his baseball instead.
    JMP CODE_02CB53

  + CMP.B #$12
    BEQ CODE_02CAFC                           ; Branch if in frame 12/13 (running).
    CMP.B #$13
    BEQ CODE_02CAFC
    SEC
    SBC.B #$06                                ; Return if not frame 6/7 (jumping/whistling, clapping).
    CMP.B #$02
    BCS +
    TAX
    LDY.B _5                                  ; $05 = Base OAM index of the Chuck
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02CA93)
    STA.W OAMTileXPos+$100,Y                  ; Store X position for both tiles.
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_02CA95)
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    CLC
    %LorW_X(ADC,DATA_02CA99)
    STA.W OAMTileYPos+$100,Y                  ; Store Y position for both tiles.
    STA.W OAMTileYPos+$104,Y
    %LorW_X(LDA,ClappinChuckTiles)
    STA.W OAMTileNo+$100,Y                    ; Store tile numbers.
    STA.W OAMTileNo+$104,Y
    LDA.B _8
    STA.W OAMTileAttr+$100,Y                  ; Store YXPPCCCT. X flip the second tile.
    ORA.B #$40
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY
    %LorW_X(LDA,DATA_02CA9B)
    STA.W OAMTileSize+$40,Y                   ; Store size of both tiles.
    STA.W OAMTileSize+$41,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
  + RTS


ChuckGfxProp:
    db $47,$07

CODE_02CAFC:
; Additional YXPPCCCT bits for the Chuck's hands in frames 12/13.
; Drawing Chuck's hands for animation frames 12/13 (running).
    LDY.B _5                                  ; $05 = Base OAM index of the Chuck
    LDA.W SpriteMisc157C,X
    PHX
    TAX
    ASL A
    ASL A
    ASL A
    PHA
    EOR.B #$08                                ; Set X position for one tile at the Chuck,
    CLC                                       ; and the other tile 8 pixels to the right.
    ADC.B _0
    STA.W OAMTileXPos+$100,Y
    PLA
    CLC
    ADC.B _0
    STA.W OAMTileXPos+$104,Y
    LDA.B #$1C
    STA.W OAMTileNo+$100,Y                    ; Set tile numbers (1C/1D).
    INC A
    STA.W OAMTileNo+$104,Y
    LDA.B _1
    SEC
    SBC.B #$08                                ; Set Y position.
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    LDA.W ChuckGfxProp,X
CODE_02CB2D:
    ORA.B SpriteProperties                    ; Set YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAX
CODE_02CB39:
    STZ.W OAMTileSize+$40,X                   ; Set size as 8x8.
    STZ.W OAMTileSize+$41,X
    PLX
    RTS


    db $FA,$0A,$06,$00,$00,$01,$0E,$FE
    db $02,$00,$00,$09,$08,$F4,$F4,$00
    db $00,$F4

CODE_02CB53:
; X offsets for the Baseball Chuck's held baseball in frames 14-19.
; Facing left
; Facing right
; Y offsets for the Baseball Chuck's held baseball in frames 14-19. An offset of 0 means don't draw.
    PHX                                       ; Drawing the baseball in the Chuck's hands for animation frames 14-19 (baseball).
    STA.B _2
    LDY.W SpriteMisc157C,X
    BNE +                                     ; $02 = base index to the animation frame.
    CLC
    ADC.B #$06                                ; If facing right, increases the index by 6.
  + TAX
    LDA.B _5
    CLC                                       ; $05 = Base OAM index of the Chuck
    ADC.B #$08                                ; Offset it two tiles in.
    TAY
    LDA.B _0
    CLC                                       ; Set X position.
    ADC.W CODE_02CB2D,X
    STA.W OAMTileXPos+$100,Y
    LDX.B _2
    LDA.W CODE_02CB39,X                       ; Skip tile if it has a Y offset of 0.
    BEQ +
    CLC
    ADC.B _1                                  ; Set Y position.
    STA.W OAMTileYPos+$100,Y
    LDA.B #$AD                                ; Set tile number.
    STA.W OAMTileNo+$100,Y
    LDA.B #$09
    ORA.B SpriteProperties                    ; Set YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAX
    STZ.W OAMTileSize+$40,X                   ; Set size as 8x8.
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
; X offsets for the Diggin' Chuck's shovel in frames E/F/10. Right, left for each.
; YXPPCCCT for the Diggin' Chuck's shovel in frames E/F/10. Right, left.
; Y offsets for the Diggin' Chuck's shovel in frames E/F/10.
; Tile numbers for the Diggin' Chuck's shovel in frames E/F/10.
; Tile sizes for the Diggin' Chuck's shovel in frames E/F/10.
    LDA.B SpriteNumber,X                      ; GFX subroutine for the Diggin' Chuck's shovel.
    CMP.B #$46                                ; Return if not sprite 46 (Diggin' Chuck).
    BNE Return02CBFB
    LDA.W SpriteMisc1602,X
    CMP.B #$05
    BNE CODE_02CBB2
    LDA.B #$01
    BRA CODE_02CBB9

CODE_02CBB2:
; Get index to the above animation tables for the frame.
    CMP.B #$0E                                ; Frame 05 shares frame 0F's tile.
    BCC Return02CBFB
    SEC
    SBC.B #$0E
CODE_02CBB9:
    STA.B _2
    LDA.W SpriteOAMIndex,X
    CLC                                       ; Get OAM index, offset 3 slots in.
    ADC.B #$0C
    TAY
    PHX
    LDA.B _2
    ASL A
    ORA.W SpriteMisc157C,X
    TAX                                       ; Store X position.
    LDA.B _0
    CLC
    ADC.W DigChuckTileDispX,X
    STA.W OAMTileXPos+$100,Y
    TXA
    AND.B #$01
    TAX                                       ; Store YXPPCCCT.
    LDA.W DigChuckTileProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDX.B _2
    LDA.B _1
    CLC                                       ; Store Y position.
    ADC.W DigChuckTileDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DigChuckTiles,X                     ; Store tile number.
    STA.W OAMTileNo+$100,Y
    TYA
    LSR A
    LSR A                                     ; Store size.
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
; Winged cage misc RAM:
; $1570 - Frame counter for animation.
    LDA.B SpriteLock                          ; \ If sprites not locked,; Beta winged cage MAIN
    BNE +                                     ; | increment sprite frame counter; Increment frame counter, unless the game is frozen.
    INC.W SpriteMisc1570,X                    ; /
  + JSR ADDR_02CCB9                           ; Draw GFX.
    PHX
    JSL ADDR_00FF32                           ; Store Layer 3's position.
    PLX
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W Layer1DXPos
    STA.B SpriteXPosLow,X                     ; Move the sprite horizontally with the screen.
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B PlayerAnimation                     ; \ Return if Mario animation sequence active
    CMP.B #$01                                ; |; Return if Mario is doing a special animation.
    BCS Return02CBFD                          ; /
    LDA.W StandingOnCage
    BEQ +                                     ; If touching the floor of the platform, move Mario with it.
    JSL ADDR_00FF07
  + LDY.B #$00
    LDA.W Layer1DYPos
    BPL +
    DEY
  + CLC                                       ; Move the sprite vertically with the screen.
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
    DEY                                       ; Process interaction between Mario and the sides of the cage.
    BPL ADDR_02CC6C
    CLC
    ADC.W #$0000
    CMP.B PlayerXPosNext
    BCC +                                     ; If Mario hits the left wall of the cage, clear his X speed and push him rightwards.
    STA.B PlayerXPosNext
    LDY.B #$00                                ; \ Mario's X speed = 0
    STY.B PlayerXSpeed+1                      ; /
    BRA +

ADDR_02CC6C:
    CLC
    ADC.W #$0090
    CMP.B PlayerXPosNext
    BCS +
    LDA.B _0                                  ; If Mario hits the right wall of the cage, clear his speed and push him leftwards.
    ADC.W #$0091
    STA.B PlayerXPosNext
    LDY.B #$00
    STY.B PlayerXSpeed+1
  + LDA.B _2
    LDY.B PlayerYSpeed+1                      ; Process interaction between Mario and the top/bottom of the cage.
    BPL ADDR_02CC93
    CLC
    ADC.W #$0020
    CMP.B PlayerYPosNext
    BCC +                                     ; If Mario hits the ceiling, clear his Y speed.
    LDY.B #$00
    STY.B PlayerYSpeed+1
    BRA +

ADDR_02CC93:
    CLC
    ADC.W #$0060
    CMP.B PlayerYPosNext
    BCS +
    LDA.B _2
    ADC.W #$0061                              ; If Mario hits the floor, clear his Y speed and push him upwards.
    STA.B PlayerYPosNext                      ; Also set flags for standing on top of a solid sprite and on the cage.
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
; X offsets for each of the wings of the birds carrying the cage.
; Y offsets for each of the wings of the birds carrying the cage.
; Flying cage GFX routine.
    LDA.B #$03                                ; $08 = number of wings to draw
    STA.B _8
    LDA.B SpriteXPosLow,X
    SEC                                       ; $00 = onscreen X position
    SBC.B Layer1XPos
    STA.B _0
    LDA.B SpriteYPosLow,X
    SEC                                       ; $01 = onscreen Y position
    SBC.B Layer1YPos
    STA.B _1
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM; $02 = OAM index
    STY.B _2
ADDR_02CCD0:
    LDY.B _2
    LDX.B _8
    LDA.B _0
    CLC                                       ; Store X position to OAM.
    %LorW_X(ADC,CageWingTileDispX)
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    CLC
    %LorW_X(ADC,CageWingTileDispY)
    STA.W OAMTileYPos+$100,Y                  ; Store Y position to OAM.
    CLC
    ADC.B #$08
    STA.W OAMTileYPos+$104,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.W SpriteMisc1570,X
    LSR A
    LSR A
    LSR A
    EOR.B _8                                  ; Store tile number to OAM.
    LSR A
    LDA.B #$C6                                ; First part of tile A to use for the bird wings.
    BCC +
    LDA.B #$81                                ; First part of tile B to use for the bird wings.
  + STA.W OAMTileNo+$100,Y
    LDA.B #$D6                                ; Second part of tile A to use for the bird wings.
    BCC +
    LDA.B #$D7                                ; Second part of tile B to use for the bird wings.
  + STA.W OAMTileNo+$104,Y
    LDA.B #$70
    STA.W OAMTileAttr+$100,Y                  ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY                                       ; Set size as 8x8.
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
    LDA.B _2
    CLC
    ADC.B #$08                                ; Loop for all four wings.
    STA.B _2
    DEC.B _8
    BPL ADDR_02CCD0
    RTS

CODE_02CD2D:
    PHB                                       ; Wrapper; Flat switch palace switch MAIN
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
; X offsets for each of the switch's tiles.
; Y offsets for each of the switch's tiles.
; Tile numbers for each of the switch's tiles.
; Base YXPPCCCT for each of the switch's tiles.
; Palettes (YXPPCCCT) for each of the switch palace switches.
; Switch palace switch misc RAM:
; $1540 - Indicator that the switch has actually just been pressed. If #$5E, it erases the switch object that was pressed.
    LDA.W SpriteMisc1540,X                    ; Actual flattened switch palace switch MAIN
    CMP.B #$5E                                ; Branch if not erasing the switch object.
    BNE +
    LDA.B #$1B                                ; \ Block to generate = #$1B
    STA.B Map16TileGenerate                   ; /
    LDA.B SpriteXPosLow,X
    STA.B TouchBlockXPos
    LDA.W SpriteXPosHigh,X
    STA.B TouchBlockXPos+1
    LDA.B SpriteYPosLow,X                     ; Create a block of four blank tiles at the switch, erasing the switch object.
    SEC
    SBC.B #$10
    STA.B TouchBlockYPos
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.B TouchBlockYPos+1
    JSL GenerateTile
  + JSL InvisBlkMainRt                        ; Make solid.
    JSR GetDrawInfo2
    PHX
    LDX.W BigSwitchPressTimer
    LDA.W DATA_02CD55,X                       ; Get palette for the switch.
    STA.B _2
    LDX.B #$07
CODE_02CD91:
    LDA.B _0                                  ; Upload the sprite to OAM; eight 8x8 tiles in a 4x2 block.
    CLC
    ADC.W DATA_02CD35,X
    STA.W OAMTileXPos+$100,Y                  ; Upload the position of the tile.
    LDA.B _1
    CLC
    ADC.W DATA_02CD3D,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DATA_02CD45,X                       ; Upload the tile number.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02CD4D,X
    CPX.B #$04
    BCS +                                     ; Upload the YXPPCCCT.
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
    LDA.B #$07                                ; Draw 8 8x8 tiles.
    JMP CODE_02B7A7

    RTS                                       ; rip


    db $00,$07,$F9,$00,$01,$FF

PeaBouncerMain:
; Wall springboard misc RAM:
; $C2   - Current angle of the platform. Positive is angled downards, while negative is angled upwards.
; $151C - Maximum angle the platform can reach at any given time.
; $1528 - Phase pointer. 00 = nothing, 01 = Mario is on the platform, 02 = platform is rebounding.
; $1534 - Timer set after receiving the small "base" bounce, during which pressing A/B will give Mario a "large" bounce.
; $1540 - Timer set after the springboard has reached its "lowest" point, for waiting to actually spring Mario.
; $1570 - Frame counter used after Mario bounces off the springboard, for its "rebounding" animation.
; $157C - Counter for the current direction the springboard is "rebounding" in. Even = up, odd = down.
; Wall springboard MAIN
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSR CODE_02CEE0                           ; Draw graphics and process Mario interaction.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return02CDFE
    LDA.W SpriteMisc1534,X
    BEQ +
    DEC.W SpriteMisc1534,X                    ; Check whether Mario is bouncing off the springboard.
    BIT.B byetudlrHold                        ; If so, check X/Y. If pressed, boost Mario with a higher Y speed.
    BPL +
    STZ.W SpriteMisc1534,X
    LDY.W SpriteMisc151C,X
    LDA.W DATA_02CDFF,Y                       ; Give Mario Y speed for jumping off the wall springboard.
    STA.B PlayerYSpeed+1
    LDA.B #!SFX_SPRING                        ; \ Play sound effect; SFX for jumping off a wall springboard.
    STA.W SPCIO3                              ; /
  + LDA.W SpriteMisc1528,X
    JSL ExecutePtr

    dw Return02CDFE
    dw CODE_02CE0F
    dw CODE_02CE3A

Return02CDFE:
    RTL                                       ; Wall springboard phase pointers.


DATA_02CDFF:
    db $B6,$B4,$B0,$A8,$A0,$98,$90,$88
DATA_02CE07:
    db $00,$00,$E8,$E0,$D0,$C8,$C0,$B8

CODE_02CE0F:
; 00 - Doing nothing.
; 01 - Mario is on the platform.
; 02 - Platform is rebounding.
; Y speeds to give Mario when jumping off a wall springboard (A/B held), indexed by the angle of the spring.
; Y speeds to give Mario when bouncing on a wall springboard (no A/B), indexed by the angle of the spring.
; Wall springboard phase 1 - Mario is on the platform.
    LDA.W SpriteMisc1540,X                    ; Branch if not waiting to spring Mario.
    BEQ CODE_02CE20
    DEC A                                     ; Branch if not time to spring Mario.
    BNE +
    INC.W SpriteMisc1528,X
    LDA.B #$01                                ; Switch to phase 2.
    STA.W SpriteMisc157C,X
  + RTL

CODE_02CE20:
    LDA.B SpriteTableC2,X                     ; Not time to spring Mario yet.
    BMI CODE_02CE29                           ; Branch if at the maximum angle for Mario's X position.
    CMP.W SpriteMisc151C,X
    BCS +
CODE_02CE29:
    CLC
    ADC.B #$01                                ; Increase angle of the platform by 1.
    STA.B SpriteTableC2,X
    RTL

  + LDA.W SpriteMisc151C,X                    ; At maximum angle.
    STA.B SpriteTableC2,X
    LDA.B #$08                                ; Set timer for waiting to spring Mario.
    STA.W SpriteMisc1540,X
    RTL

CODE_02CE3A:
    INC.W SpriteMisc1570,X                    ; Wall springboard phase 2 - Platform is rebounding.
    LDA.W SpriteMisc1570,X
    AND.B #$03                                ; Decrase maximum angle of the platform every 4 frames.
    BNE CODE_02CE49                           ; Branch down if done rebounding.
    DEC.W SpriteMisc151C,X
    BEQ CODE_02CE86
CODE_02CE49:
    LDA.W SpriteMisc151C,X
    EOR.B #$FF                                ; Invert the current maximum angle.
    INC A
    STA.B _0
    LDA.W SpriteMisc157C,X
    AND.B #$01                                ; Branch if currently accelerating the angle of the platform upwards.
    BNE CODE_02CE70
    LDA.B SpriteTableC2,X
    CLC
    ADC.B #$04
    STA.B SpriteTableC2,X
    BMI Return02CE66
    CMP.W SpriteMisc151C,X                    ; Angle the platform downwards.
    BCS +                                     ; If at the maximum angle, switch the direction of acceleration.
Return02CE66:
    RTL

  + LDA.W SpriteMisc151C,X
    STA.B SpriteTableC2,X
    INC.W SpriteMisc157C,X
    RTL

CODE_02CE70:
    LDA.B SpriteTableC2,X                     ; Angling the platform upwards.
    SEC
    SBC.B #$04
    STA.B SpriteTableC2,X
    BPL Return02CE7D
    CMP.B _0                                  ; Angle the platform upwards.
    BCC +                                     ; If at the maximum angle, switch the direction of acceleration.
Return02CE7D:
    RTL

  + LDA.B _0
    STA.B SpriteTableC2,X
    INC.W SpriteMisc157C,X
    RTL

CODE_02CE86:
; Done rebounding.
    STZ.B SpriteTableC2,X                     ; Clear phase and angle.
    STZ.W SpriteMisc1528,X
    RTL

    JSR CODE_02CEE0                           ; \ Unreachable; Unused. Would be a wrapper for the wall springboard's GFX/interaction routine.
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
; X offsets for each of the wall springboard's segments. Indexed by the current angle.
; Y offsets for each of the wall springboard's segments. Indexed by the current angle.
    JSR GetDrawInfo2                          ; Wall springboard GFX routine. Also handles Mario interaction.
    LDA.B #$04                                ; Number of segments in the wall springboard.
    STA.B _2
    LDA.B SpriteNumber,X
    SEC                                       ; $05 = Which platform (0 = right, 1 = left)
    SBC.B #$6B
    STA.B _5
    LDA.B SpriteTableC2,X                     ; $03 = angle of platform
    STA.B _3
    BPL +
    EOR.B #$FF
    INC A                                     ; $04 = absolute value of platform's angle (for indexing the above tables).
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
    LSR A                                     ; Store X position of the current segment to OAM.
    %LorW_X(LDA,DATA_02CE90)
    BCC +                                     ; $08 = X offset for the current segment of the spring.
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
    EOR.B #$FF                                ; Store Y position of the current segment to OAM.
    INC A                                     ; $09 = Y offset for the current segment of the spring.
  + STA.B _9
    CLC
    ADC.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.B #$3D                                ; Tile to use for the wall springboard's segments.
    STA.W OAMTileNo+$100,Y
    LDA.B SpriteProperties
    ORA.B #$0A                                ; Palette (x2) for the wall springboard.
    STA.W OAMTileAttr+$100,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    PHY
    JSR CODE_02CF52                           ; Process interaction with Mario.
    PLY
    INY
    INY
    INY                                       ; Loop for all of the segments.
    INY
    DEC.B _2
    BMI +
    JMP CODE_02CEFC

  + LDY.B #$00
    LDA.B #$04                                ; Upload 5 8x8 tiles.
    JMP CODE_02B7A7

  - RTS

CODE_02CF52:
    LDA.B PlayerAnimation                     ; Subroutine to process interaction between Mario and the wall springboard.
    CMP.B #$01
    BCS -                                     ; Return if:
    LDA.B PlayerYPosScrRel+1                  ; Mario is in a special animation state
    ORA.B PlayerXPosScrRel+1                  ; Mario or the platform are offscreen
    ORA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    BNE -
    LDA.B PlayerXPosScrRel
    CLC
    ADC.B #$02
    STA.B _A
    LDA.W PlayerRidingYoshi
    CMP.B #$01                                ; $0A = Mario's interaction X position
    LDA.B #$10                                ; $0B = Mario's interaction Y position (accounting for Yoshi)
    BCC +
    LDA.B #$20
  + CLC
    ADC.B PlayerYPosScrRel
    STA.B _B
    LDA.W OAMTileXPos+$100,Y
    SEC
    SBC.B _A
    CLC                                       ; Return if not within 8 pixels horizontally of the segment.
    ADC.B #$08
    CMP.B #$14
    BCS Return02CFFD
    LDA.B Powerup
    CMP.B #$01
    LDA.B #$1A
    BCS +                                     ; $0F = Mario's height (accounting for powerup)
    LDA.B #$1C
  + STA.B _F
    LDA.W OAMTileYPos+$100,Y
    SEC
    SBC.B _B
    CLC                                       ; Return if not within 8 pixels vertically of the segment.
    ADC.B #$08
    CMP.B _F
    BCS Return02CFFD
    LDA.B PlayerYSpeed+1                      ; Return if moving upwards.
    BMI Return02CFFD
    LDA.B #$1F
    PHX
    LDX.W PlayerRidingYoshi
    BEQ +                                     ; $0F = Mario's height (accounting for Yoshi)
    LDA.B #$2F
  + STA.B _F
    PLX
    LDA.W OAMTileYPos+$100,Y
    SEC
    SBC.B _F
    PHP
    CLC
    ADC.B Layer1YPos                          ; Push Mario on top of the platform.
    STA.B PlayerYPosNext
    LDA.B Layer1YPos+1
    ADC.B #$00
    PLP
    SBC.B #$00
    STA.B PlayerYPosNext+1
    STZ.B PlayerInAir
    LDA.B #$02                                ; Indicate Mario is standing on top of a springboard.
    STA.W StandOnSolidSprite
    LDA.W SpriteMisc1528,X
    BEQ CODE_02CFEB                           ; Branch if Mario is only just now landing on the springboard (i.e. it was previously in phase 0/2).
    CMP.B #$02
    BEQ CODE_02CFEB
    LDA.W SpriteMisc1540,X
    CMP.B #$01                                ; Return if not time to bounce Mario upwards.
    BNE +
    LDA.B #$08                                ; Set timer for checking A/B input.
    STA.W SpriteMisc1534,X
    LDY.B SpriteTableC2,X
    LDA.W DATA_02CE07,Y                       ; Bounce Mario upwards.
    STA.B PlayerYSpeed+1
  + RTS

CODE_02CFEB:
; Mario isn't on the springboard anymore.
    STZ.B PlayerXSpeed+1                      ; Clear X speed.
    LDY.B _2
    LDA.W PeaBouncerPhysics,Y                 ; Store maximum angle for the springboard based on the segment Mario is touching.
    STA.W SpriteMisc151C,X
    LDA.B #$01                                ; Set phase pointer to Mario being on the springboard.
    STA.W SpriteMisc1528,X
    STZ.W SpriteMisc1570,X                    ; Clear rebound timer.
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
; Maximum angles for the wall springboard before bouncing Mario, indexed by which segment Mario is on.
; Low bytes of the vertical offscreen processing distances in bank 2.
; High bytes of the vertical offscreen processing distances in bank 2.
; Low bytes for offscreen processing distances in bank 2.
; High bytes for offscreen processing distances in bank 2.
    LDA.B #$06                                ; \ Entry point of routine determines value of $03; SubOffscreenX7 routine. Processes sprites offscreen from -$50 to +$60 ($FFB0,$0160).
    BRA +                                     ; |

SubOffscreen2Bnk2:
    LDA.B #$04                                ; |; SubOffscreenX4 routine. Processes sprites offscreen from -$90 to +$A0 ($01A0,$FF70).
    BRA +                                     ; |

SubOffscreen1Bnk2:
    LDA.B #$02                                ; |; SubOffscreenX1 routine. Processes sprites offscreen from -$40 to +$A0 ($01A0,$FFC0).
  + STA.B _3                                  ; |
    BRA +                                     ; |

SubOffscreen0Bnk2:
    STZ.B _3                                  ; /; SubOffscreenX0 routine. Processes sprites offscreen from -$40 to +$30 ($0130,$FFC0).
  + JSR IsSprOffScreenBnk2                    ; \ if sprite is not off screen, return; Return if not offscreen.
    BEQ Return02D090                          ; /
    LDA.B ScreenMode                          ; \  vertical level
    AND.B #!ScrMode_Layer1Vert                ; |; Branch if in a vertical level.
    BNE VerticalLevelBnk2                     ; /
    LDA.B _3
    CMP.B #$04                                ; Don't erase below the level if using SubOffscreenX4 (for the mushroom scale platforms).
    BEQ CODE_02D04D
    LDA.B SpriteYPosLow,X                     ; \
    CLC                                       ; |
    ADC.B #$50                                ; | if the sprite has gone off the bottom of the level...; Erase the sprite if below the level.
    LDA.W SpriteYPosHigh,X                    ; | (if adding 0x50 to the sprite y position would make the high byte >= 2)
    ADC.B #$00                                ; |
    CMP.B #$02                                ; |
    BPL OffScrEraseSprBnk2                    ; /    ...erase the sprite
    LDA.W SpriteTweakerD,X                    ; \ if "process offscreen" flag is set, return
    AND.B #$04                                ; |; Return if set to process offscreen.
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
    CMP.B SpriteXPosLow,X                     ; Check if within the horizontal bounds specified by the routine call. Alternates sides each frame.
    PHP                                       ; If it is within the bounds (i.e. onscreen), return.
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
    LDA.W SpriteStatus,X                      ; \ If sprite status < 8, permanently erase sprite; Subroutine to erase a sprite when offscreen.
    CMP.B #$08                                ; |
    BCC +                                     ; /
    LDY.W SpriteLoadIndex,X                   ; \ Branch if should permanently erase sprite
    CPY.B #$FF                                ; |; Erase the sprite.
    BEQ +                                     ; /; If it wasn't killed, set it to respawn.
    LDA.B #$00                                ; \ Allow sprite to be reloaded by level loading routine
    STA.W SpriteLoadStatus,Y                  ; /
  + STZ.W SpriteStatus,X                      ; Erase sprite
Return02D090:
    RTS

VerticalLevelBnk2:
    LDA.W SpriteTweakerD,X                    ; \ If "process offscreen" flag is set, return; Offscreen routine for a vertical level.
    AND.B #$04                                ; |; Return if set to process offscreen.
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
    ROL.B _0                                  ; Check if within the vertical bounds specified by the routine call. Alternates sides each frame.
    CMP.B SpriteYPosLow,X                     ; If it is within the bounds (i.e. onscreen), return.
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
    LDA.W SpriteOffscreenX,X                  ; Returns with a value indicating whether the sprite is offscreen or not.
    ORA.W SpriteOffscreenVert,X
    RTS


DATA_02D0D0:
    db $14,$FC

DATA_02D0D2:
    db $00,$FF

CODE_02D0D4:
; X offsets for Yoshi's head from his body, low.
; X offsets for Yoshi's head from his body, high.
    LDA.W SpriteMisc1564,X                    ; Routine to process adult Yoshi interaction with berries.
    BNE +                                     ; Return if Yoshi has a sprite in his mouth or is swallowing.
    LDA.W SpriteMisc160E,X
    BPL +
    PHB
    PHK
    PLB
    JSR CODE_02D0E6
    PLB
  + RTL

CODE_02D0E6:
    STZ.B _F                                  ; Handle interaction with berry tiles.
    BRA CODE_02D149                           ; [don't bother doing vertical level interaction]

    LDA.B SpriteYPosLow,X                     ; \ Unreachable; (This unused code handles berry interaction in vertical levels.)
    CLC                                       ; | Something to do with Yoshi?
    ADC.B #$08
    AND.B #$F0
    STA.B _0                                  ; Return if Yoshi's head is outside of the level vertically.
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
    STA.B _1                                  ; Return if Yoshi's head is outside of the level horizontally.
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_02D0D2,Y
    CMP.B #$02
    BCS Return02D148
    STA.B _2
    LDA.B _1
    LSR A
    LSR A
    LSR A                                     ; $00 = Block position, YX format.
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _3
    LDA.L DATA_00BA80,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA8E,X                       ; Get Map16 low pointer.
  + CLC
    ADC.B _0
    STA.B _5
    LDA.L DATA_00BABC,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BACA,X                       ; Get Map16 high pointer.
  + ADC.B _2
    STA.B _6
    BRA CODE_02D1AD                           ; Handle contact.

Return02D148:
    RTS

CODE_02D149:
    LDA.B SpriteYPosLow,X                     ; \ $18B2 = Sprite Y position + #$08
    CLC                                       ; |
    ADC.B #$08                                ; |
    STA.W YoshiYPos                           ; /
    AND.B #$F0                                ; \ $00 = (Sprite Y position + #$08) rounded down to closest #$10 low byte; Return if Yoshi's head is outside of the level vertically.
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
    STA.B _1                                  ; | $01 = (Sprite X position + $0014/$FFFC) Low byte; Return if Yoshi's head is outside of the level horizontally.
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
    LSR A                                     ; |; $00 = Block position, YX format.
    LSR A                                     ; |
    ORA.B _0                                  ; |
    STA.B _0                                  ; /
    LDX.B _3
    LDA.L DATA_00BA60,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BA70,X                       ; Get Map16 low pointer.
  + CLC
    ADC.B _0
    STA.B _5
    LDA.L DATA_00BA9C,X
    LDY.B _F
    BEQ +
    LDA.L DATA_00BAAC,X                       ; Get Map16 high pointer.
  + ADC.B _2
    STA.B _6
CODE_02D1AD:
    LDA.B #$7E
    STA.B _7
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B [_5]
    STA.W Map16TileNumber
    INC.B _7
    LDA.B [_5]                                ; Return if not touching a berry.
    BNE +
    LDA.W Map16TileNumber
    CMP.B #$45
    BCC +
    CMP.B #$48
    BCS +
    SEC
    SBC.B #$44                                ; Keep track of the berry's color.
    STA.W EatenBerryType
    STZ.W YoshiTongueTimer                    ; Clear toungue stretch timer.
    LDY.W PlayerDuckingOnYoshi
    LDA.W DATA_02D1F1,Y                       ; Set animation frame; either normal or ducking.
    STA.W SpriteMisc1602,X
    LDA.B #$22                                ; Set swallow timer. (actual erasure of berry is in the swallow routine)
    STA.W SpriteMisc1564,X
    LDA.B PlayerYPosNext
    CLC
    ADC.B #$08
    AND.B #$F0                                ; Shift Mario's position to center on the berry.
    STA.B PlayerYPosNext
    LDA.B PlayerYPosNext+1
    ADC.B #$00
    STA.B PlayerYPosNext+1
  + RTS


DATA_02D1F1:
    db $00,$04

SetTreeTile:
; Animation frames for Yoshi when eating a berry, indexed by whether he's standing or ducking.
    LDA.W YoshiXPos                           ; \ Set X position of block; Routine to spawn a blank bush tile, for berries eaten by Yoshi's mouth.
    STA.B TouchBlockXPos                      ; |
    LDA.W YoshiXPos+1                         ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.W YoshiYPos                           ; \ Set Y position of block; Erase the berry tile.
    STA.B TouchBlockYPos                      ; |
    LDA.W YoshiYPos+1                         ; |
    STA.B TouchBlockYPos+1                    ; /
    LDA.B #$04                                ; \ Block to generate = Tree behind berry; Tile spawned from eating a berry by touching it.
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile
Return02D20F:
    RTL


    db $01

DATA_02D211:
    db $FF,$10,$F0

CODE_02D214:
; X speed accelerations for the P-balloon/Lakitu cloud.
; Max X speeds for the P-balloon/Lakitu cloud.
; Scratch RAM used:
; $00 - Maximum Y speed.
    LDA.B byetudlrHold                        ; Flight controller for the P-balloon/Lakitu cloud.
    AND.B #$03                                ; Branch if left or right are being held.
    BNE CODE_02D228
CODE_02D21A:
    LDA.B SpriteXSpeed,X                      ; Left/right not held.
    BEQ CODE_02D226
    BPL +
    INC.B SpriteXSpeed,X                      ; Decrease Mario's X speed.
    INC.B SpriteXSpeed,X
  + DEC.B SpriteXSpeed,X
CODE_02D226:
    BRA CODE_02D247

CODE_02D228:
    TAY                                       ; Left/right held.
    CPY.B #$01
    BNE CODE_02D238
    LDA.B SpriteXSpeed,X
    CMP.W DATA_02D211,Y
    BEQ CODE_02D247                           ; Check if at max speed right. If greater, decrease speed. Else, do nothing/increase speed.
    BPL CODE_02D21A
    BRA CODE_02D241

CODE_02D238:
    LDA.B SpriteXSpeed,X
    CMP.W DATA_02D211,Y                       ; Check if at max speed left. If less, decrease speed. Else, do nothing/increase speed.
    BEQ CODE_02D247
    BMI CODE_02D21A
CODE_02D241:
    CLC
    ADC.W Return02D20F,Y                      ; Increase X speed.
    STA.B SpriteXSpeed,X
CODE_02D247:
; All codes return to here.
    LDY.B #$00                                ; Vertical speed in the Lakitu Cloud without up/down pressed.
    LDA.B SpriteNumber,X
    CMP.B #$87                                ; Branch if using a P-balloon, not a Lakitu cloud.
    BNE CODE_02D25F
    LDA.B byetudlrHold
    AND.B #$0C
    BEQ +
    LDY.B #$10                                ; Max Y speed downwards in the Lakitu cloud.
    AND.B #$08
    BEQ +
    LDY.B #$F0                                ; Max Y speed upwards in the Lakitu cloud.
    BRA +

CODE_02D25F:
; Using P-balloon, not Lakitu cloud.
    LDY.B #$F8                                ; Vertical speed with the P-balloon without up/down pressed.
    LDA.B byetudlrHold
    AND.B #$0C
    BEQ +
    LDY.B #$F0                                ; Max Y speed upwards with the P-balloon.
    AND.B #$08
    BNE +
    LDY.B #$08                                ; Max Y speed downwards with the P-balloon.
  + STY.B _0                                  ; Got maximum Y speed.
    LDA.B SpriteYSpeed,X
    CMP.B _0
    BEQ CODE_02D27F
    BPL +                                     ; Accelerate Y speed accordingly.
    INC.B SpriteYSpeed,X
    INC.B SpriteYSpeed,X
  + DEC.B SpriteYSpeed,X
CODE_02D27F:
    LDA.B SpriteXSpeed,X
    STA.B PlayerXSpeed+1                      ; Link the sprite's X and Y speeds to Mario's.
    LDA.B SpriteYSpeed,X
    STA.B PlayerYSpeed+1
    RTL

UpdateXPosNoGrvty:
    TXA                                       ; \ Adjust index so we use X values rather than Y; Routine to update a sprite's X position using its current speed. Equivalent routine in bank 1 at $01ABCC.
    CLC                                       ; |
    ADC.B #$0C                                ; |; All this really does is run the routine below with a modified index.
    TAX                                       ; /
    JSR UpdateYPosNoGrvty
    LDX.W CurSpriteProcess                    ; X = sprite index
    RTS

UpdateYPosNoGrvty:
    LDA.B SpriteYSpeed,X                      ; \ $14EC or $14F8 += 16 * speed; Routine to update a sprite's Y position using its current speed. Equivalent routine in bank 1 at $01ABD8.
    ASL A                                     ; |
    ASL A                                     ; |
    ASL A                                     ; |; Update fraction bits.
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
    ORA.B #$F0                                ; | ...set high bits; Update the actual position.
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
    ADC.B #$00                                ; Keep track of how far the sprite has moved.
    STA.W SpriteXMovement                     ; $1491 = amount sprite was moved
    RTS

; Unused routine running the below routine.
    STA.B _0                                  ; Unreachable; Seems it originally used a block position ($94-$97) instead of a sprite position.
    LDA.B PlayerXPosNext                      ; \ Save Mario's position; Now useless, though.
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
; Aiming routine for the Boo/Swooper ceiling.
    STA.B _1                                  ; Input: A = desired magnitude of the final speed vector, X = sprite slot to aim from (0).
    PHX                                       ; Output: $00 = X speed, $01 = Y speed
    PHY
    JSR CODE_02D50C                           ; $02 = horizontal side of the sprite Mario is on.
    STY.B _2
    LDA.B _E
    BPL +
    EOR.B #$FF
    CLC                                       ; $0C = absolute value of the sprite's horizontal distance from Mario.
    ADC.B #$01
  + STA.B _C
    JSR CODE_02D4FA                           ; $03 = vertical side of the sprite Mario is on.
    STY.B _3
    LDA.B _F
    BPL +
    EOR.B #$FF
    CLC                                       ; $0D = absolute value of the sprite's vertical distance from Mario.
    ADC.B #$01
  + STA.B _D
    LDY.B #$00
    LDA.B _D
    CMP.B _C
    BCS +
    INY                                       ; If further away horizontally than vertically, swap $0C/$0D
    PHA                                       ; (so that the shorter distance is in $0C).
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
    ADC.B _C                                  ; $00 = ($0C * $01) / $0D
    CMP.B _D                                  ; $0B = ($0C * $01) % $0D
    BCC +
    SBC.B _D                                  ; Essentially, this does a ratio of the vertical and horizontal distances,
    INC.B _0                                  ; then scales the base speed using that ratio.
  + STA.B _B
    DEX
    BNE CODE_02D338
    TYA
    BEQ +
    LDA.B _0
    PHA                                       ; If $0C/$0D were swapped before, swap $00/$01.
    LDA.B _1
    STA.B _0
    PLA
    STA.B _1
  + LDA.B _0
    LDY.B _2
    BEQ +
    EOR.B #$FF                                ; Invert $00 if Mario is to the left of the sprite.
    CLC
    ADC.B #$01
    STA.B _0
  + LDA.B _1
    LDY.B _3
    BEQ +
    EOR.B #$FF                                ; Invert $01 if Mario is above the sprite.
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
; Y position offsets to the bottom of a sprite, for checking if offscreen.
; Bits to set in $186C, for each tile of a two-tile sprite.
; Misc RAM returns:
; Y   = OAM index (from $0300)
; $00 = Sprite X position relative to the screen border
; $01 = Sprite Y position relative to the screen border
; Also sets $15A0, $15C4, and $186C.
; GetDrawInfo routine. Gets various GFX-related addresses.
    STZ.W SpriteOffscreenVert,X               ; Initialize offscreen flags.
    STZ.W SpriteOffscreenX,X
    LDA.B SpriteXPosLow,X
    CMP.B Layer1XPos
    LDA.W SpriteXPosHigh,X                    ; Check if offscreen horizontally, and set the flag if so.
    SBC.B Layer1XPos+1
    BEQ +
    INC.W SpriteOffscreenX,X
  + LDA.W SpriteXPosHigh,X
    XBA
    LDA.B SpriteXPosLow,X
    REP #$20                                  ; A->16
    SEC
    SBC.B Layer1XPos
    CLC                                       ; Handle horizontal offscreen flag for 4 tiles offscreen. (-40 to +40)
    ADC.W #$0040                              ; If so, return the sprite's graphical routine.
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
    ADC.W DATA_02D374,Y                       ; Check if vertically offscreen, and set the flag if so.
    PHP                                       ; Due to a typo (?), if a sprite uses sprite clipping 20+, $186C's bits will be set for two different tiles.
    CMP.B Layer1YPos                          ; First ("top") tile = bit 0
    ROL.B _0                                  ; Second ("bottom") tile = bit 1
    PLP
    LDA.W SpriteYPosHigh,X                    ; Likely was supposed to be $190F instead of $1662, as in Bank 1's GFX routine.
    ADC.B #$00                                ; Fortunately for Nintendo, there don't seem to be any negative consequences of this.
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
    STA.B _0                                  ; Return onscreen position in $00 and $01, and OAM index in Y.
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    RTS

CODE_02D3E7:
; Sprite more than 4 tiles offscreen.
    PLA                                       ; Return the sprite's routine (i.e. don't draw).
    PLA
    RTS

Layer3SmashMain:
; Layer 3 Smash misc RAM:
; $C2   - Current phase.
; 0 = waiting in ceiling, 1 = slowly descending, 2 = smashing, 3 = waiting to rise back up, 4 = rising
; $1540 - Phase timer for phases 0, 1, and 3.
; Layer 3 smash MAIN
    JSL CODE_00FF61                           ; Store position to the Layer 3 position addresses.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return02D444
    JSR CODE_02D49C                           ; Process interaction with Mario.
    LDY.B #$00
    LDA.W Layer1DXPos
    BPL +
    DEY
  + CLC                                       ; Move the sprite horizontally with Layer 1.
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
; Layer 3 Smash phase pointers.
; 0 - Waiting in ceiling
; 1 - Slowly descending
; 2 - Smashing
; 3 - Waiting to rise back up
; 4 - Rising up
    LDA.W SpriteWillAppear                    ; Layer 3 Smash phase 0 - Waiting in ceiling
    BEQ +                                     ; If sprite D2 is spawned, stop creating smashers.
    JSR OffScrEraseSprBnk2
    RTS                                       ; [NOTE: this line should be an RTL instead; as-is, it will crash]

  + LDA.W SpriteMisc1540,X                    ; Return if not time to actually make the spawner.
    BNE Return02D444
    INC.B SpriteTableC2,X                     ; Move to phase 1.
    LDA.B #con($80,$80,$80,$68,$68)           ; How long to slowly descend the smashwer for before going into the full smash.
    STA.W SpriteMisc1540,X
    JSL GetRand
    AND.B #$3F
    ORA.B #$80
    STA.B SpriteXPosLow,X                     ; Move to a random X position from 80-BF.
    LDA.B #$FF
    STA.W SpriteXPosHigh,X
    STZ.B SpriteYPosLow,X
    STZ.W SpriteYPosHigh,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; Clear Y speed.
Return02D444:
    RTL

CODE_02D445:
; Layer 3 Smash phase 1 - Slowly descending
    LDA.W SpriteMisc1540,X                    ; Branch if time to go into the full smash.
    BEQ +
    LDA.B #con($04,$04,$04,$06,$06)           ; Y speed the Layer 3 Smash slowly descends with at the start.
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty                     ; Update Y position.
    RTL

; Time to smash.
  + INC.B SpriteTableC2,X                     ; Switch to phase 2.
    RTL

CODE_02D455:
; Layer 3 Smash phase 2 - Smashing
    JSR UpdateYPosNoGrvty                     ; Update Y position.
    LDA.B SpriteYSpeed,X
    BMI CODE_02D460
    CMP.B #con($40,$40,$40,$70,$70)           ; Max Y speed of the smasher.
    BCS +
CODE_02D460:
    CLC
    ADC.B #con($07,$07,$07,$0A,$0A)           ; Y speed acceleration for the smasher.
    STA.B SpriteYSpeed,X
  + LDA.B SpriteYPosLow,X
    CMP.B #$A0                                ; Return if not fully extended.
    BCC +
    AND.B #$F0                                ; Round the sprite's position up to the nearest block.
    STA.B SpriteYPosLow,X
    LDA.B #$50                                ; \ Set ground shake timer; How long to shake Layer 1 after the smasher stops.
    STA.W ScreenShakeTimer                    ; /
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect; SFX for the Layer 3 Smasher hitting the ground.
    STA.W SPCIO3                              ; /
    LDA.B #$30                                ; How long to wait before rising back up.
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X                     ; Switch to phase 3.
  + RTL

CODE_02D481:
    LDA.W SpriteMisc1540,X                    ; Layer 3 Smash phase 3 - Waiting to rise back up
    BNE +                                     ; Switch to phase 4 when time to.
    INC.B SpriteTableC2,X
  + RTL

CODE_02D489:
; Layer 3 Smash phase 4 - Rising up
    LDA.B #con($E0,$E0,$E0,$D8,$D8)           ; Y speed to give the smasher when rising upwards.
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty                     ; Update Y position.
    LDA.B SpriteYPosLow,X
    BNE +                                     ; Once fully retracted, return to phase 0.
    STZ.B SpriteTableC2,X
    LDA.B #con($A0,$A0,$A0,$88,$88)           ; How long to wait in the ceiling before smashing again.
    STA.W SpriteMisc1540,X
  + RTL

CODE_02D49C:
    LDA.B #$00                                ; Routine to process Mario interaction with the Layer 3 Smash sprite.
    LDY.B Powerup
    BEQ +
    LDY.B PlayerIsDucking
    BNE +                                     ; Return if Mario is too far below the smasher.
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
    LDA.B PlayerXPosScrRel                    ; Return if Mario isn't touching the smasher horizontally.
    CLC
    ADC.B _0
    SEC
    SBC.W #$0030
    CMP.W #$0090
    BCS CODE_02D4EF
    SEC
    SBC.W #$0008
    CMP.W #$0080                              ; Branch if Mario is touching the shaft of the smasher, rather than the bottom of it.
    SEP #$20                                  ; A->8
    BCS CODE_02D4E5
    LDA.B PlayerInAir                         ; Branch if Mario is in the air.
    BNE +
    JSL HurtMario                             ; Hurt Mario.
    RTS

  + STZ.B PlayerYSpeed+1                      ; Touching the bottom of the smasher while in the air.
    LDA.B SpriteYSpeed,X                      ; Clear Mario's Y speed. If the smasher is moving downards, move Mario with it.
    BMI +
    STA.B PlayerYSpeed+1
  + RTS

CODE_02D4E5:
    PHP                                       ; Touching the shaft of the smasher.
    LDA.B #$08
    PLP
    BPL +                                     ; Push Mario away from the smasher.
    LDA.B #$F8
  + STA.B PlayerXSpeed+1
CODE_02D4EF:
    SEP #$20                                  ; A->8
    RTS


    db $80,$40,$20,$10,$08,$04,$02,$01

CODE_02D4FA:
; Unused AND table?
    LDY.B #$00                                ; Subroutine to check which side of the sprite Mario is on (duplicate of SubHorzPosBnk2). Returns Y: 00 = right, 01 = left.
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
; Equivalent routine in bank 1 at $01AD42, and bank 3 at $03B829.
; Subroutine to check vertical proximity of Mario to a sprite.
    LDY.B #$00                                ; Returns the side in Y (0 = below) and distance in $0E.
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
; SFX for killing Wigglers with star power.
; Banzai Bill MAIN
    JSR CODE_02D5E4                           ; Draw GFX.
    LDA.W SpriteStatus,X
    CMP.B #$02
    BEQ +                                     ; Return if game frozen or dead.
    LDA.B SpriteLock
    BNE +
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    LDA.B #$E8                                ; X speed the Banzai Bill travels with.
    STA.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty                     ; Update X position.
    JSL MarioSprInteract                      ; Process interaction with Mario.
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
; X offsets for each of the Banzai Bill's tiles.
; Y offsets for each of the Banzai Bill's tiles.
; Tile numbers for each of the Banzai Bill's tiles.
; YXPPCCCT for each of the Banzai Bill's tiles.
    JSR GetDrawInfo2                          ; Banzai Bill GFX routine.
    PHX
    LDX.B #$0F                                ; Number of tiles to draw for the Banzai Bill.
  - LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W DATA_02D5A4,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W DATA_02D5B4,X
    STA.W OAMTileYPos+$100,Y
    LDA.W BanzaiBillTiles,X                   ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02D5D4,X                       ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$0F                                ; Upload 10 16x16s to OAM.
    JMP CODE_02B7A7

Banzai_Rotating:
    PHB                                       ; Ball 'n' Chain MAIN / Banzai Bill MAIN / Gray platform on a chain MAIN
    PHK
    PLB
    LDA.B SpriteNumber,X
    CMP.B #$9F                                ; Branch if not the Banzai Bill.
    BNE CODE_02D625
    JSR CODE_02D587                           ; Run the actual Banzai Bill MAIN.
    BRA +

CODE_02D625:
; Gray platform on a chain or ball n' chain.
    JSR CODE_02D62A                           ; Run the actual MAIN routine for them.
  + PLB
    RTL

CODE_02D62A:
; Ball 'n' Chain / Gray Platform misc RAM:
; $151C - High bit of the platform's angle. 0 = right side, 1 = left side.
; $1528 - Number of pixels moved horizontally in the frame.
; $1534 - Previous X position of the actual platform/ball, for tracking how much it's moved each frame.
; $1602 - Low byte of the angle of rotation. 0 = straight up/down.
; $160E - Flag for Mario being on the platform (set to #$03 if so).
; $187B - Radius of the platform.
; Ball 'n' Chain and Gray platform
    JSR SubOffscreen3Bnk2                     ; Process offscreen from -$50 to +$60.
    LDA.B SpriteLock                          ; Don't rotate the sprite if game frozen.
    BNE CODE_02D653
    LDA.B SpriteXPosLow,X
    LDY.B #$02                                ; Rotation speed counter-clockwise.
    AND.B #$10
    BNE +
    LDY.B #$FE                                ; Rotation speed clockwise.
  + TYA
    LDY.B #$00
    CMP.B #$00                                ; Handle increasing the platform's rotation.
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
    STA.B _1                                  ; $00 = 16-bit angle of the platform.
    LDA.W SpriteMisc1602,X
    STA.B _0
    REP #$30                                  ; AXY->16
    LDA.B _0
    CLC
    ADC.W #$0080                              ; $02 = 16-bit offset angle for cosine.
    AND.W #$01FF
    STA.B _2
    LDA.B _0
    AND.W #$00FF
    ASL A                                     ; $04 = Sine value.
    TAX
    LDA.L CircleCoords,X
    STA.B _4
    LDA.B _2
    AND.W #$00FF
    ASL A                                     ; $05 = Cosine value.
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
    LDA.W HW_RDMPY+1                          ; $04 = X offset from base position.
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
    LDA.W HW_RDMPY+1                          ; $06 = Y offset from base position.
    ADC.B #$00
  + LSR.B _3
    BCC +
    EOR.B #$FF
    INC A
  + STA.B _6
    LDA.B SpriteXPosLow,X
    PHA
    LDA.W SpriteXPosHigh,X
    PHA                                       ; Preserve base position of the platform.
    LDA.B SpriteYPosLow,X
    PHA
    LDA.W SpriteYPosHigh,X
    PHA
    LDY.W ClusterSpriteMisc0F86,X             ; Unused?...
    STZ.B _0
    LDA.B _4
    BPL +
    DEC.B _0                                  ; Store low X position of the actual platform.
  + CLC
    ADC.B SpriteXPosLow,X
    STA.B SpriteXPosLow,X
    PHP
    PHA
    SEC
    SBC.W SpriteMisc1534,X
    STA.W SpriteMisc1528,X                    ; Track the number of pixels moved in the frame.
    PLA
    STA.W SpriteMisc1534,X
    PLP
    LDA.W SpriteXPosHigh,X
    ADC.B _0                                  ; Store high X position of the actual platform.
    STA.W SpriteXPosHigh,X
    STZ.B _1
    LDA.B _6
    BPL +
    DEC.B _1
  + CLC                                       ; Store Y position of the actual platform.
    ADC.B SpriteYPosLow,X
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    ADC.B _1
    STA.W SpriteYPosHigh,X
    LDA.B SpriteNumber,X
    CMP.B #$9E                                ; Branch for the Ball 'n' Chain. Below runs for the Chained Platform only.
    BEQ CODE_02D750
    JSL InvisBlkMainRt                        ; Make solid, and branch if Mario isn't on the platform.
    BCC CODE_02D73D
    LDA.B #$03
    STA.W SpriteMisc160E,X                    ; Set flags for Mario being on the platform.
    STA.W StandOnSolidSprite
    LDA.W PlayerRidingYoshi                   ; Branch if riding Yoshi.
    BNE +
    PHX
    JSL DrawMarioAndYoshi                     ; Draw Mario.
    PLX
    LDA.B #$FF                                ; Hide Mario from the main GFX routine.
    STA.B PlayerHiddenTiles
    BRA +

CODE_02D73D:
    LDA.W SpriteMisc160E,X                    ; Mario isn't on the platform.
    BEQ +
    STZ.W SpriteMisc160E,X                    ; If Mario just jumped off the platform, make sure to draw Mario's sprite.
    PHX
    JSL DrawMarioAndYoshi
    PLX
; Riding Yoshi.
  + JSR CODE_02D848                           ; Draw the platform.
    BRA +

CODE_02D750:
; Sprite is specifically the Ball 'n' Chain.
    JSL MarioSprInteract                      ; Process Mario interaction.
    JSR CODE_02D813                           ; Draw the ball.
  + PLA                                       ; Both sprites join back up.
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X                     ; Restore the sprite's position.
    PLA
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X
    LDA.B _0
    CLC
    ADC.B Layer1XPos
    SEC
    SBC.B SpriteXPosLow,X                     ; Get X position for the middle chain segment.
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
    SBC.B SpriteYPosLow,X                     ; Get Y position for the middle chain segment.
    JSR CODE_02D870
    CLC
    ADC.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    LDA.W SpriteWayOffscreenX,X               ; Return if the sprite is offscreen.
    BNE Return02D806
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$10
    TAY
    PHX
    LDA.B SpriteXPosLow,X
    STA.B _A                                  ; $0A = Sprite X position
    LDA.B SpriteYPosLow,X                     ; $0B = Sprite Y position
    STA.B _B
    LDA.B SpriteNumber,X
    TAX
    LDA.B #$E8                                ; Tile to use for the Ball 'n' Chain's chain.
    CPX.B #$9E
    BEQ +
    LDA.B #$A2                                ; Tile to use for the rotating gray platform's chain.
  + STA.B _8
    LDX.B #$01                                ; Number of chain segments to draw.
  - LDA.B _0                                  ; Store X position.
    STA.W OAMTileXPos+$100,Y
    LDA.B _1                                  ; Store Y position.
    STA.W OAMTileYPos+$100,Y
    LDA.B _8                                  ; Store tile number
    STA.W OAMTileNo+$100,Y
    LDA.B #$33                                ; Store YXPPCCCT.
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
    STA.B _0                                  ; Halve the radius for the next segment's position.
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
    INY                                       ; Loop for the second segment.
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$05                                ; Upload all 6 16x16 tiles.
    JMP CODE_02B7A7

CODE_02D800:
    NOP                                       ; Routine to waste time for multiplication. Also...
    NOP                                       ; Used as the Ball 'n' Chain's tilemap (seriously).
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
; X offsets for each tile of the Ball 'n' Chain's ball.
; Y offsets for each tile of the Ball 'n' Chain's ball.
; YXPPCCCT for each tile of the Ball 'n' Chain's ball.
    JSR GetDrawInfo2                          ; Ball 'n' Chain's ball GFX routine. Note that size isn't handled here.
    PHX
    LDX.B #$03                                ; Number of tiles to draw for the ball.
  - LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W DATA_02D807,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W DATA_02D80B,X
    STA.W OAMTileYPos+$100,Y
    LDA.W CODE_02D800,X                       ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02D80F,X                       ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY                                       ; Loop for all four tiles.
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
; X offsets for each itle of the rotating gray platform.
; Tile numbers for each tile of the rotating gray platform.
    JSR GetDrawInfo2                          ; Rotating Gray Platform's platform GFX routine. Note that size isn't handled here.
    PHX
    LDX.B #$03                                ; Number of tiles in the platform.
  - LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W DATA_02D840,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1                                  ; Store Y position to OAM.
    STA.W OAMTileYPos+$100,Y
    LDA.W WoodPlatformTiles,X                 ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.B #$33                                ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY                                       ; Loop for all four tiles.
    INY
    DEX
    BPL -
    PLX
    RTS

CODE_02D870:
; Subroutine to get a position along a radius, for chain of the rotating gray platform / ball 'n' chain.
    PHP                                       ; Usage: distance (in just the X or Y plane) from base of the sprite to the platform/ball.
    BPL +
    EOR.B #$FF
    INC A
  + STA.W HW_WRDIV+1                          ; Divide the distance (times 0x100) by half the radius of the platform.
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
    ROL A                                     ; Return the resulting output.
    ASL.B _E                                  ; This is the strangest way of handling it, honestly.
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
; First frame to use for each of the sprites inside the bubble.
; Second frame to use for each of the sprites inside the bubble.
; YXPPCCCT to use for each of the sprites inside the bubble.
    PHB                                       ; Bubble MAIN
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
; X speeds for the bubble sprite.
; Y accelerations for the bubble sprite.
; Max Y speeds for the bubble sprite.
; Bubble misc RAM:
; $C2   - Sprite inside the bubble. 0 = Goomba, 1 = Bob-omb, 2 = fish, 3 = mushroom
; $151C - Vertical direction of acceleration. Even = down, odd = up.
; $1534 - Timer for the bubble. Pops when it runs out.
; $157C - Horizontal direction of movement. 0 = right, 1 = left.
    LDA.W SpriteOAMIndex,X                    ; Actual bubble MAIN
    CLC
    ADC.B #$14                                ; Set up a 16x16 tile for the sprite inside the bubble.
    STA.W SpriteOAMIndex,X
    JSL GenericSprGfxRt2
    PHX
    LDA.B SpriteTableC2,X
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    TAX                                       ; Set actual YXPPCCCT for the tile.
    LDA.W BubbleSprGfxProp1,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDA.B EffFrame
    ASL A
    ASL A
    ASL A
    LDA.W BubbleSprTiles1,X                   ; Set actual tile number for the tile, animating it on an 4-frame cycle.
    BCC +
    LDA.W BubbleSprTiles2,X
  + STA.W OAMTileNo+$100,Y
    PLX
    LDA.W SpriteMisc1534,X
    CMP.B #$60
    BCS CODE_02D8F3                           ; Draw the bubble.
    AND.B #$02                                ; If the bubble's timer is close to running out, make it flash every 2 frames.
    BEQ +
CODE_02D8F3:
    JSR CODE_02D9D6
  + LDA.W SpriteStatus,X
    CMP.B #$02
    BNE CODE_02D904                           ; If the bubble hasn't been killed by... something, reset it to its normal state?
    LDA.B #$08                                ; \ Sprite status = Normal; Not sure what the point of this is, but it's the reason you get a million points from throwing shells at bubbles.
    STA.W SpriteStatus,X                      ; /
    BRA CODE_02D96B

CODE_02D904:
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return02D977
    LDA.B TrueFrame
    AND.B #$01
    BNE +
    DEC.W SpriteMisc1534,X                    ; Decrease lifespan timer every 2 frames.
    LDA.W SpriteMisc1534,X                    ; If about to run out, play the pop sound.
    CMP.B #$04
    BNE +
    LDA.B #!SFX_CLAP                          ; \ Play sound effect; SFX for popping the bubble.
    STA.W SPCIO3                              ; /
  + LDA.W SpriteMisc1534,X
    DEC A                                     ; Branch if time to erase the bubble and spawn the sprite inside.
    BEQ CODE_02D978
    CMP.B #$07                                ; Return if the bubble is already popping.
    BCC Return02D977
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSR UpdateXPosNoGrvty                     ; Update X/Y position.
    JSR UpdateYPosNoGrvty
    JSL CODE_019138                           ; Process interaction with blocks.
    LDY.W SpriteMisc157C,X
    LDA.W BubbleSprGfxProp2,Y                 ; Store X speed.
    STA.B SpriteXSpeed,X
    LDA.B TrueFrame
    AND.B #$01
    BNE +
    LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY                                       ; Update Y speed every other frame.
    LDA.B SpriteYSpeed,X                      ; If at the maximum Y speed in the current direction, invert the direction of acceleration.
    CLC
    ADC.W BubbleSprGfxProp3,Y
    STA.B SpriteYSpeed,X
    CMP.W BubbleSprGfxProp4,Y
    BNE +
    INC.W SpriteMisc151C,X
  + LDA.W SpriteBlockedDirs,X                 ; Branch if hitting a block.
    BNE CODE_02D96B
    JSL SprSprInteract                        ; Process sprite interaction.
    JSL MarioSprInteract                      ; Return if not being touching by Mario.
    BCC Return02D9A0
    STZ.B PlayerYSpeed+1                      ; Clear Mario's speed.
    STZ.B PlayerXSpeed+1
CODE_02D96B:
    LDA.W SpriteMisc1534,X                    ; Bubble has been hit.
    CMP.B #$07
    BCC Return02D977                          ; Drop its lifespan timer down so it pops.
    LDA.B #$06
    STA.W SpriteMisc1534,X
Return02D977:
    RTS

CODE_02D978:
    LDY.B SpriteTableC2,X                     ; Erasing the bubble and replacing it with the sprite inside.
    LDA.W BubbleSprites,Y                     ; Get the sprite to spawn.
    STA.B SpriteNumber,X
    PHA
    JSL InitSpriteTables                      ; Initialize the new sprite.
    PLY
    LDA.B #$20
    CPY.B #$74
    BNE +                                     ; Disable contact for the sprite with Mario for a bit.
    LDA.B #$04
  + STA.W SpriteMisc154C,X
    LDA.B SpriteNumber,X
    CMP.B #$0D                                ; Initialize the Bob-Omb's stun timer.
    BNE +
    DEC.W SpriteMisc1540,X
  + JSR CODE_02D4FA
    TYA                                       ; Turn the sprite towards Mario.
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
; Sprites to contain in the bubble, indexed by spawn X position.
; X offsets for each tile in the bubble.
; Y offsets for each tile in the bubble.
; Tile numbers for each tile of the bubble.
; YXPPCCCT for each tile of the bubble.
; Tile size for each tile of the bubble.
; Indices to the X/Y offset tables for each frame of animation.
    JSR GetDrawInfo2                          ; Bubble GFX routine.
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A                                     ; $02 = index to the offset tables for each frame of animation.
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
    LDA.W SpriteMisc1534,X                    ; $03 = Timer for the popping animation.
    STA.B _3
    LDX.B #$04                                ; Number of tiles to use for the bubble (excluding the sprite inside).
CODE_02D9F8:
    PHX
    TXA
    CLC
    ADC.B _2
    TAX
    LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W BubbleTileDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W BubbleTileDispY,X
    STA.W OAMTileYPos+$100,Y
    PLX
    LDA.W BubbleTiles,X                       ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.W BubbleGfxProp,X
    ORA.B SpriteProperties                    ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    LDA.B _3
    CMP.B #$06                                ; If popping the bubble, change the tile number and YXPPCCCT.
    BCS CODE_02DA37
    CMP.B #$03
    LDA.B #$02
    ORA.B SpriteProperties                    ; Change YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    LDA.B #$64                                ; Tile A to use for the bubble's pop animation.
    BCS +
    LDA.B #$66                                ; Tile B to use for the bubble's pop animation.
  + STA.W OAMTileNo+$100,Y
CODE_02DA37:
    PHY
    TYA
    LSR A
    LSR A                                     ; Set size for the tile
    TAY
    LDA.W BubbleSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL CODE_02D9F8
    PLX
    LDY.B #$FF
    LDA.B #$04                                ; Upload 5 manually-sized tiles.
    JMP CODE_02B7A7

HammerBrotherMain:
    PHB                                       ; Hammer Bro. MAIN
    PHK
    PLB
    JSR CODE_02DA5A
    PLB
Return02DA59:
    RTL

CODE_02DA5A:
; Hammer Bro. misc RAM:
; $1540 - Timer to prevent throwing multiple hammers at once.
; $1570 - Frame counter for animation and throwing hammers.
; $157C - Horizontal direction the sprite is facing.
    STZ.W SpriteMisc157C,X                    ; Actual Hammer Bro. MAIN
    LDA.W SpriteStatus,X
    CMP.B #$02                                ; If falling offscreen from being killed, just draw his graphics.
    BNE +                                     ; (note that only status #$02 is checked; all others are not)
    JMP HammerBroGfx


HammerFreq:
    db $1F,$0F,$0F,$0F,$0F,$0F,$0F

; Rates at which the Hammer Bro. throws hammers on each submap.
; Not dead.
  + LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return02DAE8
    JSL SprSpr_MarioSprRts                    ; Process interaction with Mario and other sprites.
    JSR SubOffscreen1Bnk2                     ; Process offscreen from -$40 to +$A0.
    LDY.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,Y
    TAY
    LDA.B TrueFrame                           ; \ Increment $1570,x 3 out of every 4 frames
    AND.B #$03                                ; |
    BEQ +                                     ; |
    INC.W SpriteMisc1570,X                    ; /; Handle frame counter and turning animation.
  + LDA.W SpriteMisc1570,X                    ; On the main map, halve the hammer-throwing speed.
    ASL A
    CPY.B #$00
    BEQ +
    ASL A
  + AND.B #$40
    STA.W SpriteMisc157C,X
    LDA.W SpriteMisc1570,X                    ; \ Don't throw if...
    AND.W HammerFreq,Y                        ; | ...not yet time; Return if:
    ORA.W SpriteOffscreenX,X                  ; | ...sprite offscreen; Not time to throw a hammer
    ORA.W SpriteOffscreenVert,X               ; |; Offscreen
    ORA.W SpriteMisc1540,X                    ; | ...we just threw one; Just threw a hammer (don't spawn more than one).
    BNE Return02DAE8                          ; /
    LDA.B #$03                                ; \ Set minimum time in between throws; Set timer to prevent throwing extra hammers.
    STA.W SpriteMisc1540,X                    ; /
    LDY.B #$10                                ; \ $00 = Hammer X speed,; X speed to give the hammer when facing right.
    LDA.W SpriteMisc157C,X                    ; | based on sprite's direction
    BNE +                                     ; |
    LDY.B #$F0                                ; |; X speed to give the hammer when facing left.
  + STY.B _0                                  ; /
    LDY.B #$07                                ; \ Find a free extended sprite slots
CODE_02DABA:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ GenerateHammer                        ; |; Find an empty slot to spawn the hammer in, and return if none found.
    DEY                                       ; |
    BPL CODE_02DABA                           ; |
    RTS                                       ; / Return if no free slots

GenerateHammer:
    LDA.B #$04                                ; \ Extended sprite = Hammer; Extended sprite to spawn (hammer).
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X                     ; \ Hammer X pos = sprite X pos
    STA.W ExtSpriteXPosLow,Y                  ; |
    LDA.W SpriteXPosHigh,X                    ; |
    STA.W ExtSpriteXPosHigh,Y                 ; /; Spawn at the sprite's position.
    LDA.B SpriteYPosLow,X                     ; \ Hammer Y pos = sprite Y pos
    STA.W ExtSpriteYPosLow,Y                  ; |
    LDA.W SpriteYPosHigh,X                    ; |
    STA.W ExtSpriteYPosHigh,Y                 ; /
    LDA.B #$D0                                ; \ Hammer Y speed = #$D0; Initial Y speed for the hammer.
    STA.W ExtSpriteYSpeed,Y                   ; /
    LDA.B _0                                  ; \ Hammer X speed = $00; Store X speed.
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
; X offsets for the Hammer Bro.'s tiles.
; Y offsets for the Hammer Bro.'s tiles.
; Tile numbers for the Hammer Bro.
; Facing left
; Facing right
; Tile sizes for the Hammer Bro.
    JSR GetDrawInfo2                          ; Hammer Bro. GFX routine
    LDA.W SpriteMisc157C,X
    STA.B _2
    PHX
    LDX.B #$03                                ; Number of tiles to draw.
CODE_02DB08:
    LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W HammerBroDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W HammerBroDispY,X
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.B _2
    PHA                                       ; Store YXPPCCCT to OAM.
    ORA.B #$37
    STA.W OAMTileAttr+$100,Y
    PLA
    BEQ +
    INX
    INX
    INX                                       ; Store tile number to OAM.
    INX
  + LDA.W HammerBroTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    PHY
    TYA
    LSR A
    LSR A                                     ; Store tile size to OAM.
    TAY
    LDA.W HammerBroTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    INY
    DEX
    BPL CODE_02DB08
CODE_02DB44:
    PLX
    LDY.B #$FF
    LDA.B #$03                                ; Upload 4 manually-sized tiles to OAM.
    JMP CODE_02B7A7

FlyingPlatformMain:
    PHB                                       ; Flying turnblock platform MAIN
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
; Horizontal accelerations for the flying turnblock platform.
; Max X speeds for the flying turnblock platform.
; Vertical accelerations for the flying turnblock platform.
; Horizontal accelerations for the flying turnblock platform.
; Flying Hammer Bro. platform misc RAM:
; $C2   - When the platform is hit from below, this indicates which of the two blocks was hit. 1 = left, 2 = right.
; $151C - Direction of vertical acceleration. Even = +, odd = -
; $1528 - Number of pixels moved horizontally in the frame.
; $1534 - Direction of horizontal acceleration. Even = +, odd = -
; $1558 - Timer for the bounce animation when the platform is hit from below.
; $1594 - Slot of the Hammer Bro. riding the platform. #$FF if there is none.
; Flying Hammer Bro. platform MAIN
    JSR FlyingPlatformGfx                     ; Draw sprite; Draw graphics.
    LDA.B #$FF                                ; \ $1594 = #$FF
    STA.W SpriteMisc1594,X                    ; /
    LDY.B #$09                                ; \ Check sprite slots 0-9 for Hammer Brother
CODE_02DB66:
    LDA.W SpriteStatus,Y                      ; |
    CMP.B #$08                                ; |
    BNE CODE_02DB74                           ; |; Look for a Hammer Bro. to put on the platform.
    LDA.W SpriteNumber,Y                      ; |; Skip down if none found.
    CMP.B #$9B                                ; |
    BEQ PutHammerBroOnPlat                    ; |
CODE_02DB74:
    DEY                                       ; |
    BPL CODE_02DB66                           ; |
    BRA +                                     ; / Branch if no Hammer Brother

PutHammerBroOnPlat:
; Hammer Bro. found, attach him to the platform.
    TYA                                       ; \ $1594 = index of Hammer Bro; Keep track of the slot.
    STA.W SpriteMisc1594,X                    ; /
    LDA.B SpriteXPosLow,X                     ; \ Hammer Bro X postion = Platform X position
    STA.W SpriteXPosLow,Y                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    STA.W SpriteXPosHigh,Y                    ; /
    LDA.B SpriteYPosLow,X                     ; \ Hammer Bro Y position = Platform Y position - #$10
    SEC                                       ; |; Attach the Hammer Bro. to the platform.
    SBC.B #$10                                ; |
    STA.W SpriteYPosLow,Y                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    SBC.B #$00                                ; |
    STA.W SpriteYPosHigh,Y                    ; /
    PHX                                       ; \ Draw Hammer Bro
    TYX                                       ; |; Draw the Hammer Bro.
    JSR HammerBroGfx                          ; |
    PLX                                       ; /
; No Hammer Bro. found.
  + LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return02DC0E
    JSR SubOffscreen1Bnk2                     ; Process offscreen from -$40 to +$A0.
    LDA.B TrueFrame
    AND.B #$01                                ; Update X/Y speed every other frame.
    BNE CODE_02DBD7
    LDA.W SpriteMisc1534,X
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X
    CLC                                       ; Handle horizontal acceleration.
    ADC.W DATA_02DB54,Y
    STA.B SpriteXSpeed,X
    CMP.W DATA_02DB56,Y
    BNE +
    INC.W SpriteMisc1534,X
  + LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC                                       ; Handle vertical acceleration.
    ADC.W DATA_02DB58,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_02DB5A,Y
    BNE CODE_02DBD7
    INC.W SpriteMisc151C,X
CODE_02DBD7:
    JSR UpdateYPosNoGrvty                     ; Update X/Y position.
    JSR UpdateXPosNoGrvty
    STA.W SpriteMisc1528,X                    ; Make solid.
    JSL InvisBlkMainRt
    LDA.W SpriteMisc1558,X                    ; Return if the block wasn't hit from below.
    BEQ Return02DC0E
    LDA.B #$01
    STA.B SpriteTableC2,X
    JSR CODE_02D4FA
    LDA.B _F                                  ; Track which of the blocks in the platform that Mario is hitting.
    CMP.B #$08
    BMI +
    INC.B SpriteTableC2,X
  + LDY.W SpriteMisc1594,X                    ; Return if there isn't a Hammer Bro. on the platform.
    BMI Return02DC0E
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,Y                      ; /; Kill the Hammer Bro.
    LDA.B #$C0                                ; Y speed to give the Hammer Bro. when killed by hitting the platform from below.
    STA.W SpriteYSpeed,Y
    PHX
    TYX
    JSL CODE_01AB6F                           ; Display a contact sprite on the Hammer Bro.
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
; X offsets for each of the flying turnblock platform's tiles.
; Y offsets for each of the flying turnblock platform's tiles.
; Tile numbers for each of the flying turnblock platform's tiles.
; YXPPCCCT for each of the flying turnblock platform's tiles.
; Sizes for each of the flying turnblock platform's tiles.
; Additional Y offsets for the hit animation of the platform's blocks.
    JSR GetDrawInfo2                          ; Flying turnblock platform GFX routine.
    LDA.B SpriteTableC2,X                     ; $07 = which block of the platform has been hit from below, if any.
    STA.B _7
    LDA.W SpriteMisc1558,X
    LSR A
    TAY                                       ; $05 = current vertical offset for said hit block.
    LDA.W DATA_02DC37,Y
    STA.B _5
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    LDA.B EffFrame
    LSR A                                     ; $02 = index to the animation tables, for the wings animation
    AND.B #$04
    STA.B _2
    LDX.B #$03                                ; Number of tiles to draw.
CODE_02DC5D:
    STX.B _6
    TXA
    ORA.B _2
    TAX
    LDA.B _0                                  ; Store X position to OAM.
    CLC
    ADC.W DATA_02DC0F,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_02DC17,X
    STA.W OAMTileYPos+$100,Y
    PHX
    LDX.B _6
    CPX.B #$02                                ; Store Y position to OAM.
    BCS +                                     ; If the block was hit from below, animate its bounce.
    INX
    CPX.B _7
    BNE +
    LDA.W OAMTileYPos+$100,Y
    SEC
    SBC.B _5
    STA.W OAMTileYPos+$100,Y
  + PLX
    LDA.W HmrBroPlatTiles,X                   ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02DC27,X                       ; Store YXPPCCCT to OAM.
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Store size to OAM.
    TAY
    LDA.W DATA_02DC2F,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY                                       ; Loop for all of the tiles.
    LDX.B _6
    DEX
    BPL CODE_02DC5D
    JMP CODE_02DB44                           ; Uplaod 4 manually-sized tiles.

SumoBrotherMain:
; Sumo Bro. misc RAM:
; $C2   - Phase pointer.
; 0 = waiting to step, 1 = about to step, 2 = taking a step, 3 = stomping
; $1540 - Phase timer.
; $1558 - Timer for waiting to stomp a lightning bolt.
; $1570 - Counter for the number of steps taken when walking to the side.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame.
; 0/1 = walking, 2 = unused, 3/4/5 = stomping
    PHB                                       ; Sumo Bro. MAIN
    PHK
    PLB
    JSR CODE_02DCB7
    PLB
    RTL

CODE_02DCB7:
    JSR SumoBroGfx                            ; Draw GFX.
    LDA.B SpriteLock
    BNE Return02DCE9
    LDA.W SpriteStatus,X                      ; Return if game frozen or the sprite is dead.
    CMP.B #$08
    BNE Return02DCE9
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Process interaction with Mario and other sprites.
    JSL UpdateSpritePos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /; Clear X/Y speed if on the ground.
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
  + LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02DCEA
    dw CODE_02DCFF
    dw CODE_02DD0E
    dw CODE_02DD4B

Return02DCE9:
; Sumo Bro. phase pointers
; 0 - Waiting to take a step
; 1 - About to take a step
; 2 - Taking a step
    RTS                                       ; 3 - Stomping and spawning a lightning bolt

CODE_02DCEA:
; Sumo Bro. phase 0 - Waiting to take a step
    LDA.B #$01                                ; Animation frame when waiting to take a step.
    STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X                    ; Return if not time to take a step.
    BNE +
    STZ.W SpriteMisc1602,X
    LDA.B #$03                                ; How long the Sumo Bro. spends taking a step.
CODE_02DCF9:
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X                     ; Increase phase pointer.
  + RTS

CODE_02DCFF:
; Sumo Bro. phase 1 - About to take a step
    LDA.W SpriteMisc1540,X                    ; Return if not ready to take a step.
    BNE Return02DD0B
    INC.W SpriteMisc1602,X
    LDA.B #$03                                ; How long the Sumo Bro. spends taking a step.
    BRA CODE_02DCF9

Return02DD0B:
    RTS


DATA_02DD0C:
    db $20,$E0

CODE_02DD0E:
; Sumo Bro. phase 2 - Taking a step
    LDA.W SpriteMisc1558,X                    ; Branch if waiting to do the final stomp.
    BNE CODE_02DD45
    LDY.W SpriteMisc157C,X
    LDA.W DATA_02DD0C,Y                       ; Set walking X speed.
    STA.B SpriteXSpeed,X
    LDA.W SpriteMisc1540,X                    ; Return if not done taking a step.
    BNE Return02DD44
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X                    ; Increase counter for the number of steps taken.
    AND.B #$01                                ; After two steps, set the timer for waiting to stomp.
    BNE +
    LDA.B #$20                                ; How long the Sumo Bro waits after walking to actually stomp.
    STA.W SpriteMisc1558,X
  + LDA.W SpriteMisc1570,X
    CMP.B #$03                                ; Branch if not time to stomp.
    BNE CODE_02DD3D
    STZ.W SpriteMisc1570,X
    LDA.B #$70                                ; How long the stomping animation lasts.
    BRA CODE_02DCF9

CODE_02DD3D:
; Done with the step but not stomping yet.
    LDA.B #$03                                ; How long the Sumo Bro. waits before preparing to take another step.
CODE_02DD3F:
    JSR CODE_02DCF9
    STZ.B SpriteTableC2,X                     ; Return to phase 0.
Return02DD44:
    RTS

CODE_02DD45:
; Waiting to stomp.
    LDA.B #$01                                ; Animation frame to use prior to stomping.
    STA.W SpriteMisc1602,X
    RTS

CODE_02DD4B:
    LDA.B #$03                                ; Sumo Bro. phase 3 - stomping and spawning a lightning bolt.
    LDY.W SpriteMisc1540,X                    ; Branch if done with the stomp animation.
    BEQ CODE_02DD81
    CPY.B #$2E
    BNE CODE_02DD6F
    PHA                                       ; Spawn a lightning bolt if time to do so and the Sumo Bro. is onscreen.
    LDA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    BNE +
    LDA.B #$30                                ; \ Set ground shake timer; How long to shake Layer 1 for.
    STA.W ScreenShakeTimer                    ; /
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect; SFX for the Sumo Bro. stomping the ground.
    STA.W SPCIO3                              ; /
    PHY
    JSR GenSumoLightning                      ; Spawn the lightning bolt.
    PLY
  + PLA
CODE_02DD6F:
    CPY.B #$30
    BCC +
    CPY.B #$50
    BCS +
    INC A                                     ; Animate the stomping animation, using frames 3, 4, and 5.
    CPY.B #$44
    BCS +
    INC A
  + STA.W SpriteMisc1602,X
    RTS

CODE_02DD81:
    LDA.W SpriteMisc157C,X                    ; Done with the stomping animation.
    EOR.B #$01                                ; Change direction.
    STA.W SpriteMisc157C,X
    LDA.B #$40                                ; How long the Sumo Bro. waits for after stomping before walking.
    JSR CODE_02DD3F
    RTS

GenSumoLightning:
; Subroutine to spawn the Sumo Bro.'s lightning.
    JSL FindFreeSprSlot                       ; \ Return if no free slots; Find an empty sprite slot and return if none found.
    BMI +                                     ; /
    LDA.B #$2B                                ; \ Sprite = Lightning; Sprite to spawn (2B - lightning bolt).
    STA.W SpriteNumber,Y                      ; /
    LDA.B #$08                                ; \ Sprite status = Normal; State to spawn in.
    STA.W SpriteStatus,Y                      ; /
    LDA.B SpriteXPosLow,X                     ; \ Lightning X position = Sprite X position + #$04
    ADC.B #$04                                ; |
    STA.W SpriteXPosLow,Y                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    ADC.B #$00                                ; |; Spawn at the Sumo Bro's position.
    STA.W SpriteXPosHigh,Y                    ; /
    LDA.B SpriteYPosLow,X                     ; \ Lightning Y position = Sprite Y position
    STA.W SpriteYPosLow,Y                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    STA.W SpriteYPosHigh,Y                    ; /
    PHX
    TYX                                       ; \ Reset sprite tables
    JSL InitSpriteTables                      ; /
    LDA.B #$10                                ; \ $1FE2,x = #$10; How long the lightning bolt has block interaction disabled for after spawning.
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
; X offsets for the Sumo Bro's animation frames.
; First 6 rows are facing left, second are facing right.
; Y offsets for the Sumo Bro's animation frames.
; Tile numbers for the Sumo Bro's animation frames.
; Sizes for the Sumo Bro's animation frames.
    JSR GetDrawInfo2                          ; Sumo Bro. GFX routine.
    LDA.W SpriteMisc157C,X
    LSR A
    ROR A
    ROR A                                     ; $02 = X flip
    AND.B #$40
    EOR.B #$40
    STA.B _2
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc1602,X
    ASL A
    ASL A                                     ; Get tilemap index.
    PHX
    TAX
    LDA.B #$03                                ; Number of tiles to draw.
    STA.B _5
CODE_02DE5B:
    PHX
    LDA.B _2
    BEQ +
    TXA                                       ; Get X offset table index, based on whether the Sumo Bro. is facing right or left.
    CLC
    ADC.B #$18
    TAX
  + LDA.B _0
    CLC                                       ; Store X position to OAM.
    ADC.W SumoBrosDispX,X
    STA.W OAMTileXPos+$100,Y
    PLX
    LDA.B _1
    CLC                                       ; Store Y position to OAM.
    ADC.W SumoBrosDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W SumoBrosTiles,X                     ; Store tile number to OAM.
    STA.W OAMTileNo+$100,Y
    CMP.B #$66
    SEC
    BNE +
    CLC                                       ; Store YXPPCCCT to OAM.
  + LDA.B #$34                                ; Set the T bit for all tiles except tile 66 (which is part of an unused frame anyway).
    ADC.B _2
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Store size to OAM.
    TAY
    LDA.W SumoBrosTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY                                       ; Loop for all tiles.
    INX
    DEC.B _5
    BPL CODE_02DE5B
    PLX
    LDY.B #$FF
    LDA.B #$03                                ; Upload 4 manually-sized tiles.
    JMP CODE_02B7A7

SumosLightningMain:
; Sumo Bros. lightning misc RAM:
; $1540 - Timer to handle spawning the flame columns once the sprite hits the ground.
; $1570 - Counter for the number of flame columns spawned.
; $1FE2 - Timer to disable interaction with blocks after being spawned by the Sumo Bro.
; $0F4A - Timer for each flame's lifespan.
    PHB                                       ; Sumo Bros. lightning MAIN
    PHK
    PLB
    JSR CODE_02DEB0
    PLB
    RTL

CODE_02DEB0:
    LDA.W SpriteMisc1540,X                    ; Branch if spawning flames.
    BNE CODE_02DEFC
    LDA.B #$30                                ; Y speed of the Sumo Bro's lightning.
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty                     ; Update Y position.
    LDA.W SpriteMisc1FE2,X                    ; Branch if object interaction is disabled.
    BNE +
    JSL CODE_019138                           ; Handle block interaction.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Branch if not hitting a floor.
    BEQ +                                     ; /
    LDA.B #!SFX_FIRESPIT                      ; \ Play sound effect; SFX for the Sumo Bros. lightning spawning flames.
    STA.W SPCIO3                              ; /
    LDA.B #$22                                ; Set timer for spawning the flames.
    STA.W SpriteMisc1540,X
    LDA.W SpriteOffscreenX,X
    ORA.W SpriteOffscreenVert,X
    BNE +
    LDA.B SpriteXPosLow,X                     ; If not hitting the ground offscreen, spawn smoke at the sprite's position.
    STA.B TouchBlockXPos
    LDA.B SpriteYPosLow,X
    STA.B TouchBlockYPos
    JSL CODE_028A44
  + LDA.B #$00                                ; Draw four 8x8 tiles.
    JSL GenericSprGfxRt0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileAttr+$104,Y                  ; Flip the third tile horizontally and vertically (i.e. rotate 180 degrees).
    EOR.B #$C0
    STA.W OAMTileAttr+$104,Y
    RTS

CODE_02DEFC:
    STA.B _2                                  ; Lightning hit the ground and is spawning flames.
    CMP.B #$01
    BNE +                                     ; If spawning the last set of flames, set the sprite to erase.
    STZ.W SpriteStatus,X
  + AND.B #$0F
    CMP.B #$01                                ; If not time to spawn a new set of flames, return.
    BNE +
    STA.W ActivateClusterSprite
    JSR CODE_02DF2C
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X                    ; Spawn flames.
    CMP.B #$01                                ; For the first set, only spawn one flame.
    BEQ +                                     ; For the second/third sets, spawn two at a time.
    JSR CODE_02DF2C
    INC.W SpriteMisc1570,X
  + RTS


DATA_02DF22:
    db $FC,$0C,$EC,$1C,$DC

DATA_02DF27:
    db $FF,$00,$FF,$00,$FF

CODE_02DF2C:
; X position (lo) offsets of each flame for the Sumo Bros. lightning.
; X position (hi) offsets of each flame for the Sumo Bros. lightning.
    LDA.B SpriteXPosLow,X                     ; Subroutine to spawn a flame for the Sumo Bros. lightning.
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    LDY.B #$09
CODE_02DF37:
    LDA.W ClusterSpriteNumber,Y
    BEQ CODE_02DF4C
    DEY
    BPL CODE_02DF37                           ; Find an empty cluster sprite slot, starting at slot 9.
    DEC.W SumoClustOverwrite                  ; If none are found, overwrite one.
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
    ADC.W DATA_02DF22,X                       ; Set X position for the current flame.
    STA.W ClusterSpriteXPosLow,Y
    LDA.B _1
    ADC.W DATA_02DF27,X
    STA.W ClusterSpriteXPosHigh,Y
    PLX
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$10
    STA.W ClusterSpriteYPosLow,Y              ; Set Y position for the current flame.
    LDA.W SpriteYPosHigh,X
    SEC
    SBC.B #$00
    STA.W ClusterSpriteYPosHigh,Y
    LDA.B #$7F                                ; Set timer for the flame.
    STA.W ClusterSpriteMisc0F4A,Y
    LDA.W ClusterSpriteXPosLow,Y
    CMP.B Layer1XPos
    LDA.W ClusterSpriteXPosHigh,Y
    SBC.B Layer1XPos+1                        ; Actually spawn the flame, unless horizontally offscreen.
    BNE +
    LDA.B #$06
    STA.W ClusterSpriteNumber,Y
  + RTS

VolcanoLotusMain:
; Volcano lotus misc RAM:
; $C2   - Current phase. 0 = waiting to shoot, 1 = flashing before fire, 2 = firing
; $151C - Flag for the current palette when flashing.
; $1540 - Phase timer.
; $1602 - Animation frame. 0/1 = waiting to shoot, 2 = firing
    PHB                                       ; Volcano Lotus MAIN
    PHK
    PLB
    JSR CODE_02DF93
    PLB
    RTL

CODE_02DF93:
    JSR VolcanoLotusGfx                       ; Handle graphics.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return02DFC8
    STZ.W SpriteMisc151C,X
    JSL SprSpr_MarioSprRts                    ; Process Mario and sprite interaction.
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSR UpdateYPosNoGrvty                     ; Update Y position.
    LDA.B SpriteYSpeed,X
    CMP.B #$40                                ; Apply gravity.
    BPL +
    INC.B SpriteYSpeed,X
  + JSL CODE_019138                           ; Process object interaction.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; If on the ground, clear Y speed.
    BEQ +                                     ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02DFC9
    dw CODE_02DFDF
    dw CODE_02DFEF

Return02DFC8:
; Volcano Lotus phase pointers.
; 0 - Waiting to shoot.
; 1 - Flashing before fire.
    RTS                                       ; 2 - Firing.

CODE_02DFC9:
; Volcano lotus phase 0 - waiting to shoot.
    LDA.W SpriteMisc1540,X                    ; Branch if phase not finished.
    BNE +
    LDA.B #$40                                ; How many frames to flash before firing.
CODE_02DFD0:
    STA.W SpriteMisc1540,X                    ; Set phase timer and move to next phase.
    INC.B SpriteTableC2,X
    RTS

  + LSR A
    LSR A
    LSR A                                     ; Handle 'waiting' animation (frames 0/1).
    AND.B #$01
    STA.W SpriteMisc1602,X
    RTS

CODE_02DFDF:
; Volcano lotus phase 1 - flashing before fire.
    LDA.W SpriteMisc1540,X                    ; Branch if not done flashing.
    BNE CODE_02DFE8
    LDA.B #$40                                ; How many frames to wait after firing before returning to the 'waiting to shoot' phase.
    BRA CODE_02DFD0

CODE_02DFE8:
    LSR A
    AND.B #$01                                ; Flip current palette back and forth.
    STA.W SpriteMisc151C,X
    RTS

CODE_02DFEF:
; Volcano lotus phase 2 - firing.
    LDA.W SpriteMisc1540,X                    ; Branch if not done firing.
    BNE +
    LDA.B #$80                                ; How many frames the 'waiting to shoot' phase lasts.
    JSR CODE_02DFD0
    STZ.B SpriteTableC2,X
  + CMP.B #$38
    BNE +                                     ; Spawn the fireballs.
    JSR CODE_02E079
  + LDA.B #$02                                ; Set animation frame for firing (2).
    STA.W SpriteMisc1602,X
    RTS


VolcanoLotusTiles:
    db $8E,$9E,$E2

VolcanoLotusGfx:
; Tile numbers for the top of the Volcano Lotus (its 'tip') for each frame of animation.
; GFX routine for the Volcano Lotus.
    JSR MushroomScaleGfx                      ; Spawn two 16x16 tiles in a line.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$CE                                ; Base tile number to use for the Lotus.
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$104,Y
    LDA.W OAMTileAttr+$100,Y
    AND.B #$30
    ORA.B #$0B                                ; Fix YXPPCCCT, for the palette.
    STA.W OAMTileAttr+$100,Y
    ORA.B #$40
    STA.W OAMTileAttr+$104,Y
    LDA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$108,Y                  ; Set X offsets for the Lotus's 'tip' tiles.
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$10C,Y
    LDA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$108,Y                  ; Set Y offsets for the Lotus's 'tip' tiles.
    STA.W OAMTileYPos+$10C,Y
    PHX
    LDA.W SpriteMisc1602,X
    TAX
    LDA.W VolcanoLotusTiles,X                 ; Set tile numbers for the Lotus's 'tip' tiles.
    STA.W OAMTileNo+$108,Y
    INC A
    STA.W OAMTileNo+$10C,Y
    PLX
    LDA.W SpriteMisc151C,X
    CMP.B #$01
    LDA.B #$39                                ; YXPPCCCT for the Lotus in its 'normal' palette.
    BCC +
    LDA.B #$35                                ; YXPPCCCT for the Lotus in its 'flashing' palette.
  + STA.W OAMTileAttr+$108,Y
    STA.W OAMTileAttr+$10C,Y
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$08
    STA.W SpriteOAMIndex,X                    ; Draw two additional 8x8s.
    LDY.B #$00
    LDA.B #$01
    JMP CODE_02B7A7


DATA_02E071:
    db $10,$F0,$06,$FA

DATA_02E075:
    db $EC,$EC,$E8,$E8

CODE_02E079:
; Volcano Lotus initial fireball X speeds.
; Volcano Lotus initial fireball Y speeds.
    LDA.W SpriteOffscreenX,X                  ; Subroutine to spawn the fireballs for the Volcano Lotus.
    ORA.W SpriteOffscreenVert,X               ; Return if the sprite is offscreen.
    BNE Return02E0C4
    LDA.B #$03
    STA.B _0
CODE_02E085:
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_02E087:
    LDA.W ExtSpriteNumber,Y                   ; |; Find an empty extended sprite slot.
    BEQ CODE_02E090                           ; |; Return if none found.
    DEY                                       ; |
    BPL CODE_02E087                           ; |
    RTS                                       ; / Return if no free slots

CODE_02E090:
; Extended sprite slot found.
    LDA.B #$0C                                ; \ Extended sprite = Volcano Lotus fire; Set extended sprite number.
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00                                ; Spawn at the center of the Lotus.
    STA.W ExtSpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W ExtSpriteYPosHigh,Y
    PHX
    LDX.B _0
    LDA.W DATA_02E071,X
    STA.W ExtSpriteXSpeed,Y                   ; Set X/Y speed for the current fireball.
    LDA.W DATA_02E075,X
    STA.W ExtSpriteYSpeed,Y
    PLX
    DEC.B _0                                  ; Loop for all four fireballs.
    BPL CODE_02E085
Return02E0C4:
    RTS

JumpingPiranhaMain:
; Jumping Piranha Plant misc RAM:
; $C2   - Sprite phase. 0 = waiting in ground, 1 = jumping up, 2 = starting to fall (shoot fireballs)
; $151C - Frame counter for the propeller's animation.
; $1540 - Timer for waiting to jump in phase 0, and for shooting fire in phase 2.
; $1570 - Frame counter for the plant's mouth animation.
; $1602 - Animation frame (used individually by both the mouth and propeller). 1/2 = normal animation.
    PHB                                       ; Jumping Piranha Plant MAIN
    PHK
    PLB
    JSR CODE_02E0CD
    PLB
    RTL

CODE_02E0CD:
    JSL LoadSpriteTables                      ; Reload the plant's tweaker bytes.
    LDA.B SpriteProperties
    PHA
    LDA.B #$10                                ; Send the sprite behind objects.
    STA.B SpriteProperties
    LDA.W SpriteMisc1570,X
    AND.B #$08
    LSR A                                     ; Animate the plant's mouth.
    LSR A
    EOR.B #$02
    STA.W SpriteMisc1602,X
    JSL GenericSprGfxRt2                      ; Draw a 16x16 sprite.
    LDA.W SpriteOAMIndex,X
    CLC                                       ; Increase OAM slot (for the propeller).
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    LDA.W SpriteMisc151C,X
    AND.B #$04
    LSR A                                     ; Animate the propeller.
    LSR A
    INC A
    STA.W SpriteMisc1602,X
    LDA.B SpriteYPosLow,X
    PHA
    CLC
    ADC.B #$08
    STA.B SpriteYPosLow,X                     ; Offset Y position for the propeller.
    LDA.W SpriteYPosHigh,X
    PHA
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B #$0A                                ; YXPPCCCT for the propeller.
    STA.W SpriteOBJAttribute,X
    LDA.B #$01                                ; Draw four 8x8 tiles for the propeller.
    JSL GenericSprGfxRt0
    PLA
    STA.W SpriteYPosHigh,X
    PLA                                       ; Restore Y position and priority.
    STA.B SpriteYPosLow,X
    PLA
    STA.B SpriteProperties
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE +
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Process interaction with Mario and sprites.
    JSR UpdateYPosNoGrvty                     ; Update Y position.
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02E13C
    dw CODE_02E159
    dw CODE_02E177

CODE_02E13C:
; Jumping Piranha Plant phase pointers.
; 0 - Waiting in ground
; 1 - Jumping out
; 2 - Starting to slow down (shoot fireballs)
; Jumping Piranha Plant phase 0 - Waiting in the ground
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; Clear Y speed.
    LDA.W SpriteMisc1540,X
    BNE +
    JSR CODE_02D4FA                           ; Return if:
    LDA.B _F                                  ; Not time to jump out
    CLC                                       ; Mario is within 1.75 blocks of the plant.
    ADC.B #$1B
    CMP.B #$37
    BCC +
    LDA.B #$C0                                ; Initial jump Y speed for the jumping Piranha Plant.
    STA.B SpriteYSpeed,X
    INC.B SpriteTableC2,X                     ; Move to next phase.
    STZ.W SpriteMisc1602,X
  + RTS

CODE_02E159:
    LDA.B SpriteYSpeed,X                      ; Jumping Piranha Plant phase 1 - jumping out
    BMI CODE_02E161
    CMP.B #$40                                ; Limiter for the plant's max downwards Y speed, but that can't actually be reached here, so this is useless.
    BCS +
CODE_02E161:
    CLC
    ADC.B #$02                                ; Deceleration for the plant's jump.
    STA.B SpriteYSpeed,X
  + INC.W SpriteMisc1570,X                    ; Animate the plant's mouth.
    LDA.B SpriteYSpeed,X
    CMP.B #$F0                                ; Y speed at which the plant switches to phase 2.
    BMI Return02E176
    LDA.B #$50                                ; Number of rames to keep the fire-spitting plant's mouth open in phase 2.
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X                     ; Move to next phase.
Return02E176:
    RTS

CODE_02E177:
; Jumping Piranha Plant phase 2 - Descending (shoot fireballs)
    INC.W SpriteMisc151C,X                    ; Animate the propeller.
    LDA.W SpriteMisc1540,X                    ; Branch if not done spitting fireballs.
    BNE CODE_02E1A4
CODE_02E17F:
    INC.W SpriteMisc1570,X                    ; Animate the plant's mouth.
    LDA.B EffFrame
    AND.B #$03
    BNE +                                     ; Accelerate slowly downwards.
    LDA.B SpriteYSpeed,X
    CMP.B #$08                                ; Maximum downwards Y speed for the jumping piranha plant.
    BPL +
    INC A
    STA.B SpriteYSpeed,X
  + JSL CODE_019138
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Wait until the plant lands inside the ground, then return to phase 0.
    BEQ Return02E176                          ; /
    STZ.B SpriteTableC2,X
    LDA.B #$40                                ; Number of frames for the plant to wait in the ground.
    STA.W SpriteMisc1540,X
    RTS

CODE_02E1A4:
    LDY.B SpriteNumber,X                      ; Hasn't spit fire yet / keeping mouth open.
    CPY.B #$50                                ; Branch if not the fire-spitting plant.
    BNE CODE_02E1F7
    STZ.W SpriteMisc1570,X                    ; Stop the plant's mouth from animating.
    CMP.B #$40
    BNE CODE_02E1F7                           ; Branch if:
    LDA.W SpriteOffscreenX,X                  ; Not time to actually spit the fire
    ORA.W SpriteOffscreenVert,X               ; Offscreen
    BNE CODE_02E1F7
    LDA.B #$10                                ; X speed for the jumping piranha plant's rightwards fireball.
    JSR CODE_02E1C0
    LDA.B #$F0                                ; X speed for the jumping piranha plant's leftwards fireball.
CODE_02E1C0:
    STA.B _0
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_02E1C4:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_02E1CD                           ; |; Find an empty extended sprite slot. Return if none found.
    DEY                                       ; |
    BPL CODE_02E1C4                           ; |
    RTS                                       ; / Return if no free slots

CODE_02E1CD:
; Extended sprite slot found; spawn a fireball for the Piranha Plant.
    LDA.B #$0B                                ; \ Extended sprite = Piranha fireball; Set extended sprite number.
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00                                ; Set spawn position at the center of the plant.
    STA.W ExtSpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W ExtSpriteYPosHigh,Y
    LDA.B #$D0                                ; Initial Y speed for the jumping piranha plant's fireballs.
    STA.W ExtSpriteYSpeed,Y
    LDA.B _0                                  ; Set X speed.
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
; X speeds for each direction of movement for the coin trail.
; Y speeds for each direction of movement for the coin trail.
; Directions to have the coin trail go for each directional input combination.
; Index is bitwise [0000^v<>], with a 1 indicating pressed.
; 0 = up, 1 = down, 2 = left, 3 = right
; Directions to not allow changing to for each direction of the coin trail.
; (i.e. you can't send the trial back in the direction it just came from)
; Directional coins misc RAM:
; $C2   - Current direction of movement. 0 = up, 1 = down, 2 = left, 3 = right
; $151C - Direction of movement to head in next. 0 = up, 1 = down, 2 = left, 3 = right
; $1540 - Timer to send the sprite behind Layer 1 objects. Set to #$3E on spawn.
; $154C - Unused timer. Set to $2C on spawn.
    PHB                                       ; Directional Coins MAIN
    PHK
    PLB
    JSR CODE_02E21D
    PLB
    RTL

CODE_02E21D:
    LDA.B SpriteProperties
    PHA
    LDA.W SpriteMisc1540,X
    CMP.B #$30                                ; Send the sprite behind objects for a period of time after spawning.
    BCC +
    LDA.B #$10
    STA.B SpriteProperties
  + LDA.B Layer1YPos
    PHA
    CLC
    ADC.B #$01
    STA.B Layer1YPos                          ; Shift the the sprite one pixel upwards, so that its graphics line up with Layer 1.
    LDA.B Layer1YPos+1
    PHA
    ADC.B #$00
    STA.B Layer1YPos+1
    LDA.W BluePSwitchTimer
    BNE CODE_02E245
    JSL CoinSprGfx
    BRA +

CODE_02E245:
    JSL GenericSprGfxRt2                      ; Run an appropriate GFX routine, depending on whether the blue P-switch is active.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$2E                                ; Tile to use when the P-switch is active.
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$100,Y
    AND.B #$3F
    STA.W OAMTileAttr+$100,Y
  + PLA
    STA.B Layer1YPos+1
    PLA                                       ; Restore Layer 1 position and global priority.
    STA.B Layer1YPos
    PLA
    STA.B SpriteProperties
    LDA.B SpriteLock                          ; Branch if game frozen.
    BNE CODE_02E2DE
    LDA.B TrueFrame
    AND.B #$03
    BNE CODE_02E288                           ; Decrease the directional coin's timer every 4th frame. Branch if not 0 (time to end).
    DEC.W DirectCoinTimer
    BNE CODE_02E288
CODE_02E271:
    STZ.W DirectCoinTimer
    STZ.W SpriteStatus,X                      ; Erase the sprite.
    LDA.W BluePSwitchTimer
    ORA.W SilverPSwitchTimer
    BNE +                                     ; Unless a P-switch is still active, restore the level's original music.
    LDA.W MusicBackup
    BMI +
    STA.W SPCIO2                              ; / Change music
  + RTS

CODE_02E288:
    LDY.B SpriteTableC2,X                     ; Not time to erase the sprite.
    LDA.W DATA_02E1F9,Y
    STA.B SpriteXSpeed,X                      ; Set X/Y speed based on the sprite's current direction.
    LDA.W DATA_02E1FD,Y
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty                     ; Update X/Y position.
    JSR UpdateXPosNoGrvty
    LDA.B byetudlrHold
    AND.B #$0F
    BEQ +
    TAY
    LDA.W DATA_02E201,Y                       ; Check for pressed input, and if not in the opposite direction of the trail,
    TAY                                       ; store as the next direction to move.
    LDA.W DATA_02E211,Y
    CMP.B SpriteTableC2,X
    BEQ +
    TYA
    STA.W SpriteMisc151C,X
  + LDA.B SpriteYPosLow,X
    AND.B #$0F
    STA.B _0
    LDA.B SpriteXPosLow,X                     ; Branch if not centered on a block.
    AND.B #$0F
    ORA.B _0
    BNE CODE_02E2DE
    LDA.W SpriteMisc151C,X                    ; Change the direction of the trail's movement to the stored value.
    STA.B SpriteTableC2,X
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position
    STA.B TouchBlockXPos                      ; | for block creation
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ $98 = Sprite Y position; Spawn a coin at the sprite's position.
    STA.B TouchBlockYPos                      ; | for block creation
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B TouchBlockYPos+1                    ; /
    LDA.B #$06                                ; \ Block to generate = Coin; Tile the coin trail generates (coin).
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile
    RTS

CODE_02E2DE:
    JSL CODE_019138                           ; Not centered on a block.
    LDA.B SpriteXSpeed,X
    BNE CODE_02E2F3
    LDA.W SprMap16TouchVertHigh
    BNE CODE_02E2FF
    LDA.W SprMap16TouchVertLow
    CMP.B #$25
    BNE CODE_02E2FF
    RTS                                       ; If touching any tile besides 025, erase the sprite.

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
; Gas bubble misc RAM:
; $C2   - Vertical direction of acceleration. Even= down, odd = up
; $1570 - Frame counter for animation.
; $157C - Horizontal direction of movement. 0 = right, 1 = left
    PHB                                       ; Gas bubble MAIN
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
; X speeds for the gas bubble.
; Y accelerations for the gas bubble.
; Maximum Y speeds for the gas bubble.
    JSR GasBubbleGfx                          ; Draw GFX.
    LDA.B SpriteLock
    BNE Return02E351
    LDA.W SpriteStatus,X                      ; Return if game frozen, or sprite killed.
    CMP.B #$08
    BNE Return02E351
    LDY.W SpriteMisc157C,X
    LDA.W DATA_02E30B,Y                       ; Set X speed.
    STA.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty                     ; Update X position.
    LDA.B TrueFrame
    AND.B #$03
    BNE +
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY                                       ; Handle vertical acceleration every 4 frames.
    LDA.B SpriteYSpeed,X                      ; If at the maximum Y speed for a particular direction,
    CLC                                       ; change direction of acceleration.
    ADC.W DATA_02E30D,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_02E30F,Y
    BNE +
    INC.B SpriteTableC2,X
  + JSR UpdateYPosNoGrvty                     ; Update Y position.
    INC.W SpriteMisc1570,X                    ; Handle the timer for animation.
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSL MarioSprInteract                      ; Process interaction with Mario.
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
; X offsets for each tile in the gas bubble.
; Y offsets for each tile in the gas bubble.
; Tile numbers for each tile in the gas bubble.
; YXPPCCCT for each tile in the gas bubble.
; Which tiles to apply the below offsets to.
; Formatted as ------XY  (X = apply X offset, Y = apply Y offset)
; Extra X offsets the bubble will use for each frame of animation.
; Extra Y offsets the bubble will use for each frame of animation.
    JSR GetDrawInfo2                          ; GFX routine for the large green gas bubble.
    LDA.W SpriteMisc1570,X
    LSR A
    LSR A
    LSR A
    AND.B #$03                                ; Get extra X and Y offset value for the current frame of animation.
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
    CLC                                       ; Get the X offset for the current tile.
    ADC.B _2                                  ; Add the extra X offset if applicable, as well.
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
    CLC                                       ; Get the Y offset for the current tile.
    ADC.B _3                                  ; Add the extra Y offset if applicable, as well.
    BRA +

CODE_02E3F5:
    PLA
    SEC
    SBC.B _3
  + STA.W OAMTileYPos+$100,Y
    LDA.W DATA_02E372,X                       ; Set the tile number.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02E382,X                       ; Set YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY                                       ; Loop for all 16 tiles.
    INY
    DEX
    BPL CODE_02E3C6
    PLX
    LDY.B #$02
    LDA.B #$0F                                ; Draw 16 16x16 tiles.
    JMP CODE_02B7A7

ExplodingBlkMain:
; Exploding block misc RAM:
; $C2   - Sprite ID contained inside the block.
; $1570 - Frame counter for the block's shaking animation.
; $157C - Horizontal direction the sprite is facing. Always 0, though.
; $1602 - Animation frame. Always 0, though.
    PHB                                       ; Exploding block MAIN
    PHK
    PLB
    JSR CODE_02E41F
    PLB
    RTL

CODE_02E41F:
    JSL GenericSprGfxRt2                      ; Draw a 16x16 sprite.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return02E462
    BRA +

    JSL ADDR_02C0CF                           ; Unreachable instruction; [unused line, would spawn a now-unused minor extended sprite; see https://i.imgur.com/g68ViLN.gif]
  + LDY.B #$00
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    AND.B #$40
    BEQ +
    LDY.B #$04
    LDA.W SpriteMisc1570,X
    AND.B #$04                                ; Handle the shaking animation.
    BEQ +
    LDY.B #$FC
  + STY.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty
    JSL SprSpr_MarioSprRts                    ; Process Mario and sprite interaction.
    JSR CODE_02D4FA
    LDA.B _F
    CLC
    ADC.B #$60
    CMP.B #$C0                                ; If Mario is within 6 tiles of the sprite and the sprite isn't offscreen, make it explode.
    BCS Return02E462
    LDY.W SpriteOffscreenX,X
    BNE Return02E462
    JSL CODE_02E463
Return02E462:
    RTS

CODE_02E463:
    LDA.B SpriteTableC2,X                     ; Subroutine to spawn a sprite from the exploding block.
    STA.B SpriteNumber,X                      ; Spawn the sprite ID in $C2.
    JSL InitSpriteTables
    LDA.B #$D0                                ; Y speed to give sprites spawned from the exploding block.
    STA.B SpriteYSpeed,X
    JSR CODE_02D4FA
    TYA                                       ; Turn the sprite towards Mario.
    STA.W SpriteMisc157C,X
    LDA.B SpriteXPosLow,X
    STA.B TouchBlockXPos
    LDA.W SpriteXPosHigh,X
    STA.B TouchBlockXPos+1
    LDA.B SpriteYPosLow,X
    STA.B TouchBlockYPos
    LDA.W SpriteYPosHigh,X                    ; Create a shatter effect at the sprite's position.
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
; Mushroom scale misc RAM:
; $C2   - X position (low) of the right scale platform.
; $151C - Y position (high) of the platform's initial position.
; $1528 - Always 0. Would cause Mario to move horizontally while on the platform if non-zero.
; $1534 - Y position (low) of the platform's initial position.
; $1602 - X position (high) of the right scale platform.
    LDA.W SpriteOAMIndex,X                    ; Mushroom scales MAIN
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
    JSR SubOffscreen2Bnk2                     ; Process offscreen from -$90 to +$A0.
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
    LDA.B SpriteTableC2,X                     ; Run routine for the right (second) platform first.
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
    INC.W TileGenerateTrackA                  ; If Mario is on the right platform, sink it downwards.
    LDA.B #$F8                                ; Y speed to give the left platform when Mario is on the right.
    JSR CODE_02E559
  + LDA.W SpriteOAMIndex,X
    CLC                                       ; Update OAM index for the left platform.
    ADC.B #$08
    STA.W SpriteOAMIndex,X
    LDY.B #$00                                ; Run routine for the left (first) platform.
    JSR CODE_02E524
    BCC +
    INC.W TileGenerateTrackA                  ; If Mario is on the left platform, sink it downwards.
    LDA.B #$08                                ; Y speed to give the left platform when Mario is on it.
    JSR CODE_02E559
  + LDA.W TileGenerateTrackA
    BNE Return02E51F
    LDY.B #$02                                ; Return if Mario is on either platform,
    LDA.B SpriteYPosLow,X                     ; or if the platforms are already at their equilibrium position.
    CMP.W SpriteMisc1534,X
    BEQ Return02E51F
    LDA.W SpriteYPosHigh,X
    SBC.W SpriteMisc151C,X
    BMI +
    LDY.B #$FE                                ; Move the platforms towards their equilibrium position.
  + TYA
    JSR CODE_02E559
Return02E51F:
    RTS


MushrmScaleTiles:
    db $02,$07,$07,$02

CODE_02E524:
; Values for $9C for the mushroom platform to generate when moving.
; First two are for the left platform. Second are for the right platform.
; The first byte in each row is when the first plaform is descending. Second is rising.
    LDA.B SpriteYPosLow,X                     ; Individual platform routine.
    AND.B #$0F                                ; Branch if not centered vertically on a tile or not moving.
    BNE CODE_02E54E                           ; (i.e. don't modify any blocks)
    LDA.B SpriteYSpeed,X                      ; Note: does not work correctly cause Y speed doesn't actually zero out.
    BEQ CODE_02E54E
    LDA.B SpriteYSpeed,X
    BPL +
    INY                                       ; Get the block to generate based on the direction the platform is moving.
  + LDA.W MushrmScaleTiles,Y
    STA.B Map16TileGenerate                   ; $9C = tile to generate
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position
    STA.B TouchBlockXPos                      ; | for block creation
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ $98 = Sprite Y position; Generate the tile.
    STA.B TouchBlockYPos                      ; | for block creation
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B TouchBlockYPos+1                    ; /
    JSL GenerateTile                          ; Generate the tile
CODE_02E54E:
    JSR MushroomScaleGfx                      ; Draw GFX for the current platform.
    STZ.W SpriteMisc1528,X
    JSL InvisBlkMainRt                        ; Make solid.
    RTS

CODE_02E559:
; Subroutine for the scale platforms to update their Y positions. Load Y speed to A before calling.
    LDY.B SpriteLock                          ; Return if game frozen.
    BNE Return02E57D
    PHA
    JSR UpdateYPosNoGrvty                     ; Update Y position of the left platform.
    PLA
    STA.B SpriteYSpeed,X
    LDY.B #$00
    LDA.W SpriteXMovement
    EOR.B #$FF
    INC A
    BPL +
    DEY
  + CLC                                       ; Update Y position of the right platform.
    ADC.W SpriteMisc1534,X
    STA.W SpriteMisc1534,X
    TYA
    ADC.W SpriteMisc151C,X
    STA.W SpriteMisc151C,X
Return02E57D:
    RTS

MushroomScaleGfx:
    JSR GetDrawInfo2                          ; Subroutine to handle GFX for a single mushroom scale. Also used by the volcano lotus, for some reason.
    LDA.B _0
    SEC
    SBC.B #$08
    STA.W OAMTileXPos+$100,Y                  ; Set X position.
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    DEC A                                     ; Set Y position.
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    LDA.B #$80                                ; Tile to use for the scale platforms.
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$104,Y
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y                  ; Set YXPPCCCT.
    ORA.B #$40
    STA.W OAMTileAttr+$104,Y
    LDA.B #$01
    LDY.B #$02                                ; Spawn two 16x16s.
    JMP CODE_02B7A7

MovingLedgeMain:
; Moving Ghost House hole RAM:
; $1570 - Frame counter for deciding which direction to move.
    PHB                                       ; Moving Ghost House hole MAIN
    PHK
    PLB
    JSR CODE_02E5BC
    PLB
    RTL

CODE_02E5BC:
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    LDA.B SpriteLock                          ; Branch if game frozen.
    BNE CODE_02E5D7
    INC.W SpriteMisc1570,X
    LDY.B #$10                                ; Rightwards X speed of the platform.
    LDA.W SpriteMisc1570,X
    AND.B #$80
    BNE +
    LDY.B #$F0                                ; Leftwards X speed of the platform.
  + TYA
    STA.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty                     ; Update X position.
CODE_02E5D7:
    JSR CODE_02E637                           ; Draw graphics.
    JSR CODE_02E5F7                           ; Handle sprite interaction.
    LDA.W PlayerDisableObjInt
    BEQ CODE_02E5E8
    DEC A                                     ; Return if Mario is already in contact with a platform other than this one.
    CMP.W CurSpriteProcess
    BNE +
CODE_02E5E8:
    JSL MarioSprInteract                      ; Process Mario interaction.
    STZ.W PlayerDisableObjInt
    BCC +
    INX                                       ; If in contact with the platform, disable Mario's interaction with objects.
    STX.W PlayerDisableObjInt
    DEX
  + RTS

CODE_02E5F7:
    LDY.B #$0B                                ; Subroutine for the moving ledge hole to handle sprite interaction.
CODE_02E5F9:
    CPY.W CurSpriteProcess
    BEQ CODE_02E633
    TYA
    EOR.B TrueFrame                           ; Skip sprite slot if:
    AND.B #$03                                ; Not a frame to process interaction for
    BNE CODE_02E633                           ; Sprite is dying
    LDA.W SpriteStatus,Y                      ; Sprite is already in contact with another hole
    CMP.B #$08                                ; Sprite is the hole itself
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
    LDA.B #$00                                ; Disable object interaction for the sprite if in contact.
    STA.W SpriteDisableObjInt,Y
    BCC CODE_02E633
    TXA
    INC A
    STA.W SpriteDisableObjInt,Y
CODE_02E633:
    DEY                                       ; Loop for all sprite slots.
    BPL CODE_02E5F9
    RTS

CODE_02E637:
    JSR GetDrawInfo2                          ; GFX routine for the moving ledge hole.
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC                                       ; Set X position.
    ADC.W DATA_02E666,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1                                  ; Set Y position.
    STA.W OAMTileYPos+$100,Y
    LDA.W MovingHoleTiles,X                   ; Set tile number.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02E66E,X                       ; Set YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY                                       ; Loop for all four tiles.
    INY
    DEX
    BPL -
    PLX
    LDA.B #$03
    LDY.B #$02                                ; Upload four 16x16 tiles.
    JMP CODE_02B7A7


DATA_02E666:
    db $00,$08,$18,$20

MovingHoleTiles:
    db $EB,$EA,$EA,$EB

DATA_02E66E:
    db $71,$31,$31,$31

CODE_02E672:
; X offsets for each tile of the ledge hole.
; Tile numbers for each tile of the ledge hole.
; YXPPCCCT for each tile of the ledge hole.
    PHB                                       ; Wrapper; Routine to handle the 1up and fishing rod for a fishing Lakitu.
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
    SEC                                       ; Set X position of the fishing rod.
    SBC.B #$0D
    STA.W OAMTileXPos+$100,Y
    SEC
    SBC.B #$08                                ; Set X position of the 1up.
    STA.W TileGenerateTrackA
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    CLC                                       ; Set Y position of the fishing rod.
    ADC.B #$02
    STA.W OAMTileYPos+$100,Y
    STA.W TileGenerateTrackB
    CLC                                       ; Set Y position of the 1up.
    ADC.B #$40
    STA.W OAMTileYPos+$104,Y
    LDA.B #$AA                                ; Tile for the fishing rod.
    STA.W OAMTileNo+$100,Y
    LDA.B #$24                                ; Tile for the 1up.
    STA.W OAMTileNo+$104,Y
    LDA.B #$35                                ; YXPPCCCT for the fishing rod.
    STA.W OAMTileAttr+$100,Y
    LDA.B #$3A                                ; YXPPCCCT for the 1up.
    STA.W OAMTileAttr+$104,Y
    LDA.B #$01
    LDY.B #$02                                ; Upload two 16x16 tiles.
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
    BCS +                                     ; If Mario touches the 1up, erase it and give him a life.
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
    LDA.B #$38                                ; OAM index (from $0300) of the rope for Lakitu's fishing rod.
    STA.W SpriteOAMIndex,X
    TAY
    LDX.B #$07                                ; Number of rope tiles to draw. Also change $02E719.
  - LDA.W TileGenerateTrackA                  ; Drawing the rope.
    STA.W OAMTileXPos+$100,Y
    LDA.W TileGenerateTrackB
    STA.W OAMTileYPos+$100,Y
    CLC
    ADC.B #$08
    STA.W TileGenerateTrackB
    LDA.B #$89                                ; Tile number to use for the rope.
    STA.W OAMTileNo+$100,Y
    LDA.B #$35                                ; YXPPCCCT of the rope.
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    LDA.B #$07
    LDY.B #$00                                ; Upload 8 8x8s.
    JMP CODE_02B7A7

SwimJumpFishMain:
; Jumping fish misc RAM:
; $C2   - Sprite phase. Even = swimming back and forth, odd = jumping
; $1540 - Timer for waiting to turn/jump in phase 0, and actually jumping in phase 1.
; $1570 - Counter for the number of times the fish has turned. Jumps when this hits 4.
; $157C - Direction the sprite is facing. 0 = right, 1 = left
; $1602 - Animation frame. 0/1 = swimming
    PHB                                       ; Jumping fish MAIN
    PHK
    PLB
    JSR CODE_02E727
    PLB
    RTL

CODE_02E727:
    JSL GenericSprGfxRt2                      ; Draw a 16x16.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE +
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Process Mario and sprite interaction.
    JSL CODE_019138                           ; Process object interaction (specifically for handling water splashes).
    LDY.B #$00                                ; Animate swimming (0/1).
    JSR CODE_02EB3D
    LDA.B SpriteTableC2,X
    AND.B #$01
    JSL ExecutePtr

    dw CODE_02E74E
    dw CODE_02E788

; Jumping fish phase pointers.
; 0 - Swimming back and forth
  + RTS                                       ; 1 - About to jump / jumping


DATA_02E74C:
    db $14,$EC

CODE_02E74E:
; X speeds for the jumping fish.
    LDY.W SpriteMisc157C,X                    ; Jumping fish phase 0 - Swimming back and forth
    LDA.W DATA_02E74C,Y                       ; Set X speed for the sprite based on the direction it's facing.
    STA.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty                     ; Update X position.
    LDA.W SpriteMisc1540,X                    ; Return if not time to turn/jump.
    BNE Return02E77B
    INC.W SpriteMisc1570,X
    LDY.W SpriteMisc1570,X
    CPY.B #$04                                ; Branch if time to jump (on the 4th turn).
    BEQ CODE_02E77C
    LDA.W SpriteMisc157C,X
    EOR.B #$01                                ; Turn the fish around.
    STA.W SpriteMisc157C,X
    LDA.B #$20
    CPY.B #$03                                ; How many frames the last turn before jumping lasts.
    BEQ +
    LDA.B #$40                                ; How many frames the fish normally waits before turning around.
  + STA.W SpriteMisc1540,X
Return02E77B:
    RTS

CODE_02E77C:
    INC.B SpriteTableC2,X                     ; Time to switch to jumping.
    LDA.B #$80                                ; How long the jump lasts.
    STA.W SpriteMisc1540,X
    LDA.B #$A0                                ; Y speed to make the fish jump with.
    STA.B SpriteYSpeed,X
    RTS

CODE_02E788:
; Jumping fish phase 1 - About to jump / jumping
    LDA.W SpriteMisc1540,X                    ; Branch if the jump is finished.
    BEQ CODE_02E7A4
    CMP.B #$70                                ; Return if still waiting to jump.
    BCS Return02E7A3
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0; Clear the fish's X speed.
    JSR UpdateYPosNoGrvty                     ; Update Y position.
    LDA.B SpriteYSpeed,X
    BMI CODE_02E79E
    CMP.B #$30
    BCS Return02E7A3                          ; Apply gravity to the fish.
CODE_02E79E:
    CLC
    ADC.B #$02
    STA.B SpriteYSpeed,X
Return02E7A3:
    RTS

CODE_02E7A4:
    LDA.B SpriteYPosLow,X                     ; Fish has completed its jump.
    AND.B #$F0                                ; Center the sprite on the tile it ends up at.
    STA.B SpriteYPosLow,X
    INC.B SpriteTableC2,X                     ; Move back to phase 0.
    STZ.W SpriteMisc1570,X
    LDA.B #$20                                ; How long the fish swims for after landing before it turns for the first time.
    STA.W SpriteMisc1540,X
    RTS

ChucksRockMain:
; Diggin' Chuck's rock misc RAM:
; $1540 - Timer for the 'digging up' animation after being spawned by a Chuck.
; $1602 - Animation frame. 0/1 = normal
    PHB                                       ; Diggin' Chuck's rock MAIN
    PHK
    PLB
    JSR CODE_02E7BD
    PLB
    RTL

CODE_02E7BD:
    LDA.B SpriteProperties
    PHA
    LDA.W SpriteMisc1540,X                    ; Send the sprite behind objects for a period of time after spawning.
    BEQ +
    LDA.B #$10
    STA.B SpriteProperties
  + JSL GenericSprGfxRt2                      ; Draw a 16x16 sprite.
    PLA
    STA.B SpriteProperties
    LDA.B SpriteLock
    BNE Return02E82C                          ; Return if game frozen,
    LDA.W SpriteMisc1540,X                    ; or in the process of being dug up
    CMP.B #$08                                ; (embedded in the ground).
    BCS Return02E82C
    LDY.B #$00
    LDA.B TrueFrame                           ; Animate the rock (0/1).
    LSR A
    JSR CODE_02EB3D
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSL UpdateSpritePos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    LDA.W SpriteMisc1540,X                    ; Skip down to just handle Mario/sprite interaction if still being dug out.
    BNE CODE_02E828
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    LDA.B SpriteXSpeed,X                      ; Flip X speed if hitting the side of a block.
    EOR.B #$FF
    INC A
    STA.B SpriteXSpeed,X
  + LDA.W SpriteBlockedDirs,X
    AND.B #$08
    BEQ +
    LDA.B #$10                                ; Y speed to give if the rock hits a ceiling.
    STA.B SpriteYSpeed,X
  + LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ CODE_02E828                           ; /; Make the rock bounce as it rolls.
    LDA.B SpriteYSpeed,X
    CMP.B #$38
    LDA.B #$E0                                ; Y speed to give the rock for a "small" bounce.
    BCC +
    LDA.B #$D0                                ; Y speed to give the rock for a "big" bounce.
  + STA.B SpriteYSpeed,X
    LDA.B #$08                                ; X speed to give the rock if it lands on a left-facing slope.
    LDY.W SpriteSlope,X
    BEQ CODE_02E828
    BPL +
    LDA.B #$F8                                ; X speed to give the rock if it lands on a right-facing slope.
  + STA.B SpriteXSpeed,X
CODE_02E828:
    JSL SprSpr_MarioSprRts                    ; Process interaction with Mario and sprites.
Return02E82C:
    RTS

GrowingPipeMain:
; Growing/shrinking pipe misc RAM:
; $C2   - Current phase of movement.
; Mod 4: 0 = waiting at bottom, 1 = growing, 2 = waiting at top, 3 = shrinking
; $1534 - Used as tile offsets to clear out the space above the pipe on spawn. Initializes as #$40, ends up as #$F0 after spawn.
; $1570 - Movement phase timer.
    PHB                                       ; Growing/shrinking pipe MAIN
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
; Y speeds for each phase of the pipe's movement.
; Amount of time to spend in each phase of the pipe's movement.
; Tiles (for $9C) for the left side of the pipe to spawn.
; Second byte is growing (create), fourth is shrinking (erase).
; Tiles (for $9C) for the right side of the pipe to spawn.
; Second byte is growing (create), fourth is shrinking (erase).
    LDA.W SpriteMisc1534,X                    ; Branch if done clearing out the tiles.
    BMI +
    LDA.B SpriteYPosLow,X
    PHA
    SEC
    SBC.W SpriteMisc1534,X
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteYPosHigh,X                    ; Clear out the space above the growing/shrinking pipe.
    LDY.B #$03                                ; Meant to take care of stray tiles in case the pipe despawns while fully extended.
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

; Done clearing out the area, handle normal function.
  + JSR CODE_02E902                           ; Draw graphics.
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    LDA.B SpriteLock
    ORA.W SpriteOffscreenX,X
    BNE CODE_02E8B5                           ; Return if:
    JSR CODE_02D4FA                           ; Game frozen
    LDA.B _F                                  ; Sprite is horizontally offscreen
    CLC                                       ; Mario isn't within 5 tiles of the sprite
    ADC.B #$50
    CMP.B #$A0
    BCS CODE_02E8B5
    LDA.B SpriteTableC2,X
    AND.B #$03
    TAY
    INC.W SpriteMisc1570,X                    ; Branch if not time to change movement phase.
    LDA.W SpriteMisc1570,X
    CMP.W DATA_02E839,Y
    BNE CODE_02E8A2
    STZ.W SpriteMisc1570,X
    INC.B SpriteTableC2,X                     ; Move to next phase and return.
    BRA CODE_02E8B5

CODE_02E8A2:
; Movement phase not finished.
    LDA.W DATA_02E835,Y                       ; Set Y speed for the current phase.
    STA.B SpriteYSpeed,X
    BEQ +
    LDA.B SpriteYPosLow,X
    AND.B #$0F                                ; If centered on a tile, overwrite the tiles to extend the pipe.
    BNE +
    JSR GrowingPipeGfx
  + JSR UpdateYPosNoGrvty                     ; Update Y position.
CODE_02E8B5:
    JSL InvisBlkMainRt                        ; Make the sprite solid.
    RTS

GrowingPipeGfx:
    LDA.W GrowingPipeTiles1,Y                 ; Subroutine to handle spawning tiles for the growing/shrinking pipe.
    STA.W TileGenerateTrackA                  ; Get the two tiles to spawn under the pipe.
    LDA.W GrowingPipeTiles2,Y
    STA.W TileGenerateTrackB
    LDA.W TileGenerateTrackA
    STA.B Map16TileGenerate                   ; $9C = tile to generate
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position
    STA.B TouchBlockXPos                      ; | for block creation
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B TouchBlockXPos+1                    ; /; Overwrite the left tile.
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
    LDA.W SpriteXPosHigh,X                    ; |; Overwrite the right tile.
    ADC.B #$00                                ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ $98 = Sprite Y position
    STA.B TouchBlockYPos                      ; | for block creation
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B TouchBlockYPos+1                    ; /
    JSL GenerateTile                          ; Generate the tile
    RTS

CODE_02E902:
    JSR GetDrawInfo2                          ; Growing/shrinking pipe graphics routine.
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    CLC                                       ; Set X position.
    ADC.B #$10
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    DEC A                                     ; Set Y position.
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    LDA.B #$A4                                ; Tile for the left side of the pipe.
    STA.W OAMTileNo+$100,Y
    LDA.B #$A6                                ; Tile for the right side of the pipe.
    STA.W OAMTileNo+$104,Y
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties                    ; Set YXPPCCCT/
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
CODE_02E92E:
    LDA.B #$01
    LDY.B #$02                                ; Upload 2 16x16s.
    JMP CODE_02B7A7

PipeLakituMain:
; Pipe Lakitu misc RAM:
; $C2   - Current phase.
; 0 = hiding in pipe, 1 = peeking out of pipe, 2 = rising fully out, 3 = throwing a Spiny, 4 = descending back into the pipe
; $1540 - Phase timer.
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame.
; 0 = normal, 1 = throwing, 2 = killed
    PHB                                       ; Pipe Lakitu MAIN
    PHK
    PLB
    JSR CODE_02E93D
    PLB
    RTL

CODE_02E93D:
    LDA.W SpriteStatus,X
    CMP.B #$02                                ; If killed and falling offscreen, just draw graphics.
    BNE +
    LDA.B #$02                                ; Animation frame to use when dying,
    STA.W SpriteMisc1602,X
    JMP CODE_02E9EC

; Not dead.
  + JSR CODE_02E9EC                           ; Draw graphics.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE +
    STZ.W SpriteMisc1602,X
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Process Mario and sprite interaction.
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02E96D
    dw CODE_02E986
    dw CODE_02E9B4
    dw CODE_02E9BD
    dw CODE_02E9D5

CODE_02E96D:
; Pipe Lakitu phase pointers.
; 0 - Hidden in pipe
; 1 - Peeking out of pipe
; 2 - Rising out of pipe
; 3 - Throwing a Spiny
; 4 - Descending back into pipe
; Pipe Lakitu phase 0 - hidden in the pipe
    LDA.W SpriteMisc1540,X                    ; Return if not time to start peeking.
    BNE +
    JSR CODE_02D4FA
    LDA.B _F
    CLC                                       ; Return if Mario is within 1.25 tiles of the sprite (too close).
    ADC.B #$13
    CMP.B #$36
    BCC +
    LDA.B #$90                                ; Amount of time to spend in phase 1.
CODE_02E980:
    STA.W SpriteMisc1540,X                    ; Move to next phase.
    INC.B SpriteTableC2,X
  + RTS

CODE_02E986:
; Pipe Lakitu phase 1 - peeking out of the pipe
    LDA.W SpriteMisc1540,X                    ; Branch if not time to rise fully out of the pipe.
    BNE CODE_02E996
    JSR CODE_02D4FA
    TYA                                       ; Face Mario.
    STA.W SpriteMisc157C,X
    LDA.B #$0C                                ; Number of frames to spend in phase 2 (rising upwards).
    BRA CODE_02E980

CODE_02E996:
; Not done with phase 1 yet.
    CMP.B #$7C                                ; Branch if not done rising up to peek out yet.
    BCC +
CODE_02E99A:
    LDA.B #$F8                                ; Y speed for the Lakitu rising out of the pipe.
CODE_02E99C:
    STA.B SpriteYSpeed,X                      ; Set Y speed and update Y position.
    JSR UpdateYPosNoGrvty
    RTS

; Done rising upwards; peek from side to side.
  + CMP.B #$50                                ; Return if not time to start turning.
    BCS Return02E9B3
    LDY.B #$00
    LDA.B TrueFrame
    AND.B #$20
    BEQ +                                     ; Look from side to side.
    INY
  + TYA
    STA.W SpriteMisc157C,X
Return02E9B3:
    RTS

CODE_02E9B4:
; Pipe Lakitu phase 2 - rising out of the pipe
    LDA.W SpriteMisc1540,X                    ; If not done with the phase, rise upwards.
    BNE CODE_02E99A
    LDA.B #$80                                ; Amount of time to spend in the throwing phase.
    BRA CODE_02E980

CODE_02E9BD:
; Pipe Lakitu phase 3 - throwing a spiny
    LDA.W SpriteMisc1540,X                    ; Branch if not done with the phase.
    BNE CODE_02E9C6
    LDA.B #$20                                ; Amount of time to spend descending back into the pipe.
    BRA CODE_02E980

CODE_02E9C6:
; Not done with the throwing phase.
    CMP.B #$40                                ; Branch if not time to actually throw.
    BNE +
    JSL CODE_01EA19                           ; Spawn a Spiny and throw it.
    RTS

  + BCS +                                     ; If the Lakitu has already thrown the Spiny, show the throwing animation frame.
    INC.W SpriteMisc1602,X
  + RTS

CODE_02E9D5:
; Pipe Lakitu phase 4 - descending back into the pipe
    LDA.W SpriteMisc1540,X                    ; Branch if not done with the phase.
    BNE +
    LDA.B #$50                                ; Amount of time to spend hidden inside the pipe.
    JSR CODE_02E980
    STZ.B SpriteTableC2,X                     ; Return to phase 0.
    RTS

  + LDA.B #$08                                ; Y speed to descend back into the pipe with.
    BRA CODE_02E99C


PipeLakitu1:
    db $EC,$A8,$CE

PipeLakitu2:
    db $EE,$EE,$EE

CODE_02E9EC:
; Tile numbers for the upper tile of the pipe Lakitu.
; Tile numbers for the lower tile of the pipe Lakitu.
    JSR GetDrawInfo2                          ; Pipe Lakitu GFX routine.
    LDA.B _0
    STA.W OAMTileXPos+$100,Y                  ; Set X position.
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    CLC                                       ; Set Y position.
    ADC.B #$10
    STA.W OAMTileYPos+$104,Y
    PHX
    LDA.W SpriteMisc1602,X
    TAX
    LDA.W PipeLakitu1,X                       ; Set tile numbers.
    STA.W OAMTileNo+$100,Y
    LDA.W PipeLakitu2,X
    STA.W OAMTileNo+$104,Y
    PLX
    LDA.W SpriteMisc157C,X
    LSR A
    ROR A
    LSR A
    EOR.B #$5B                                ; YXPPCCCT for the pipe Lakitu.
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    JMP CODE_02E92E                           ; Upload 2 16x16s.

CODE_02EA25:
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM; Subroutine to prepare baby Yoshi's graphics for DMA upload.
    LDA.W OAMTileNo+$100,Y
    STA.B _0
    STZ.B _1
    LDA.B #$06                                ; Tile the baby Yoshi uses in SP1 (does NOT affect the actual DMA upload destination!).
    STA.W OAMTileNo+$100,Y
    REP #$20                                  ; A->16
    LDA.B _0
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A                                     ; Store the pointer of the Baby Yoshi's graphics for DMA upload.
    CLC
    ADC.W #$8500
    STA.W DynGfxTilePtr+6
    CLC
    ADC.W #$0200
    STA.W DynGfxTilePtr+$10
    SEP #$20                                  ; A->8
    RTL

CODE_02EA4E:
    LDY.B #$0B                                ; Routine to process interaction for baby Yoshi with sprites.
CODE_02EA50:
    TYA
    CMP.W SpriteMisc160E,X
    BEQ CODE_02EA86
    EOR.B TrueFrame
    LSR A
    BCS CODE_02EA86
    CPY.W CurSpriteProcess
    BEQ CODE_02EA86
    STY.W SpriteInterIndex                    ; Skip sprite if:
    LDA.W SpriteStatus,Y                      ; Already being eaten by the baby Yoshi.
    CMP.B #$08                                ; Not a processing frame for that sprite.
    BCC CODE_02EA86                           ; The sprite is the baby Yoshi itself.
    LDA.W SpriteNumber,Y                      ; The sprite is not alive.
    CMP.B #$70                                ; The sprite is a Pokey or keyhole.
    BEQ CODE_02EA86                           ; The sprite has a sprite number greater or equal to 1D (hopping flame)
    CMP.B #$0E                                ; and is not set to be edible ($1686 bit 0 or 1 set).
    BEQ CODE_02EA86
    CMP.B #$1D
    BCC CODE_02EA83
    LDA.W SpriteTweakerE,Y
    AND.B #$03
    ORA.W YoshiGrowingTimer
    BNE CODE_02EA86
CODE_02EA83:
    JSR CODE_02EA8A                           ; Run interaction.
CODE_02EA86:
    DEY
    BPL CODE_02EA50
    RTL

CODE_02EA8A:
    PHX                                       ; Register a sprite on baby Yoshi's tongue.
    TYX
    JSL GetSpriteClippingB
    PLX
    JSL GetSpriteClippingA                    ; Return if not in contact.
    JSL CheckForContact
    BCC Return02EACD
    LDA.W SpriteMisc163E,X
    BEQ CODE_02EAA9                           ; If baby Yoshi is already eating something, swallow that sprite (?).
    JSL CODE_03C023                           ; (this line seems to be responsible for baby Yoshi's 'double eat' glitch)
    LDA.W YoshiGrowingTimer                   ; Branch down if that extra swallow caused baby Yoshi to grow.
    BNE ADDR_02EACE                           ; (again related to that glitch)
CODE_02EAA9:
    LDA.B #$37                                ; Set the timer for baby Yoshi's eating animation.
    STA.W SpriteMisc163E,X
    LDY.W SpriteInterIndex                    ; Disable the sprite's interaction with everything.
    STA.W SpriteBehindScene,Y
    LDA.W SpriteInterIndex                    ; Track the sprite Yoshi is eating.
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
; Baby Yoshi started eating a second sprite while still eating a first and grew from the first sprite.
    STZ.W SpriteMisc163E,X                    ; Clear the misc RAM address for the grown Yoshi.
    RTS

WarpBlocksMain:
    PHB                                       ; Invisible warp hole MAIN
    PHK
    PLB
    JSR CODE_02EADA
    PLB
    RTL

CODE_02EADA:
    JSL MarioSprInteract                      ; Return if Mario isn't in contact.
    BCC +
    STZ.B PlayerXSpeed+1
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$0A                                ; Clear his X speed and push him 10 pixels right.
    STA.B PlayerXPosNext
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.B PlayerXPosNext+1
  + RTS

    RTS

CODE_02EAF2:
; Super Koopa bounced off of; spawns a feather at the sprite's position.
    JSL FindFreeSprSlot                       ; \ Return if no free slots; Return if no sprite slot available.
    BMI +                                     ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$77
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X                    ; Spawn sprite 77 (feather) at the Koopa's position.
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    TYX
    JSL InitSpriteTables
    LDA.B #$30
    STA.W SpriteMisc154C,X
    LDA.B #$D0                                ; Y speed to give the feather spawned from a Super Koopa.
    STA.B SpriteYSpeed,X
  + RTL

SuperKoopaMain:
; Super Koopa misc RAM:
; $C2   - Phase pointer for the ground Super Koopa. 0 = running, 1 = jumping, 2 = flying.
; $151C - Timer for the ground Super Koopa's takeoff, which occurs when this reaches #$30.
; $1534 - Flag to indicate the Super Koopa has a feather (flashing cape).
; $157C - Horizontal direction the sprite is facing.
; $1602 - Animation frame. 2/3 = flying, 4/5 = dying
; Ground Koopa only: 0/1 = walking, 6/7 = sprinting, 7/8 = jumping
    PHB                                       ; Super Koopa MAIN
    PHK
    PLB
    JSR CODE_02EB31
    PLB
    RTL


DATA_02EB2F:
    db $18,$E8

CODE_02EB31:
; X speeds for the Super Koopas that start in mid-air.
    JSR CODE_02ECDE                           ; Draw GFX.
    LDA.W SpriteStatus,X
    CMP.B #$02                                ; Branch if the Koopa isn't dying.
    BNE CODE_02EB49
    LDY.B #$04
CODE_02EB3D:
    LDA.B EffFrame
    AND.B #$04
    BEQ +                                     ; Handle dying animation (4/5).
    INY
  + TYA
    STA.W SpriteMisc1602,X
    RTS

CODE_02EB49:
; Super Koopa isn't dead.
    LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return02EB7C
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    JSL SprSpr_MarioSprRts                    ; Process Mario and sprite interaction.
    JSR UpdateXPosNoGrvty                     ; Update X and Y position.
    JSR UpdateYPosNoGrvty
    LDA.B SpriteNumber,X
    CMP.B #$73                                ; Branch if the ground Super Koopa.
    BEQ CODE_02EB7D
    LDY.W SpriteMisc157C,X
    LDA.W DATA_02EB2F,Y                       ; Set X speed based on direction.
    STA.B SpriteXSpeed,X
    JSR CODE_02EBF8                           ; Handle flying animation.
    LDA.B TrueFrame
    AND.B #$01
    BNE Return02EB7C                          ; Return if not done swooping downwards.
    LDA.B SpriteYSpeed,X
    CMP.B #$F0                                ; Maximum upwards Y speed for the 'swoop'.
    BMI Return02EB7C
    CLC
    ADC.B #$FF                                ; Upwards acceleration of the Super Koopa's 'swoop'.
    STA.B SpriteYSpeed,X
Return02EB7C:
    RTS

CODE_02EB7D:
    LDA.B SpriteTableC2,X                     ; Running specifically the Super Koopa that starts on the ground.
    JSL ExecutePtr

    dw CODE_02EB8D
    dw CODE_02EBD1
    dw CODE_02EBE7

DATA_02EB89:
    db $18,$E8

DATA_02EB8B:
    db $01,$FF

CODE_02EB8D:
; Ground Super Koopa phase pointers.
; 0 - Walking/running
; 1 - Jumping
; 2 - Flight
; Max X speeds for the Super Koopa that starts on the ground.
; X accelerations for the ground Super Koopa prior to taking off.
    LDA.B TrueFrame                           ; Ground Super Koopa phase 0 - walking/running
    AND.B #$00                                ; Useless?
    STA.B _1
    STZ.B _0
    LDY.W SpriteMisc157C,X
    LDA.B SpriteXSpeed,X
    CMP.W DATA_02EB89,Y
    BEQ CODE_02EBAB
    CLC                                       ; Increase the Super Koopa's X speed if not already at its max.
    ADC.W DATA_02EB8B,Y
    LDY.B _1
    BNE +
    STA.B SpriteXSpeed,X
  + INC.B _0
CODE_02EBAB:
    INC.W SpriteMisc151C,X
    LDA.W SpriteMisc151C,X                    ; Branch if time for the Super Koopa to switch to the jumping phase.
    CMP.B #$30
    BEQ CODE_02EBCA
CODE_02EBB5:
    LDY.B #$00
    LDA.B TrueFrame
    AND.B #$04
    BEQ +
    INY
; Alternate animation frame (0/1 or 6/7) every four frames.
  + TYA                                       ; 0/1 for walking, 6/7 for running.
    LDY.B _0
    BNE +
    CLC
    ADC.B #$06
  + STA.W SpriteMisc1602,X
    RTS

CODE_02EBCA:
    INC.B SpriteTableC2,X                     ; Time to jump.
    LDA.B #$D0                                ; Initial Y speed for the Super Koopa's jump.
    STA.B SpriteYSpeed,X
    RTS

CODE_02EBD1:
    LDA.B SpriteYSpeed,X                      ; Ground Super Koopa phase 1 - jumping
    CLC
    ADC.B #$02                                ; Vertical deceleration fo the Super Koopa's jump.
    STA.B SpriteYSpeed,X
    CMP.B #$14                                ; Falling speed to switch to flight at.
    BMI +
    INC.B SpriteTableC2,X
  + STZ.B _0
    JSR CODE_02EBB5                           ; Handle animation (7/8).
    INC.W SpriteMisc1602,X
    RTS

CODE_02EBE7:
    LDY.W SpriteMisc157C,X                    ; Ground Super Koopa phase 2 - flight
    LDA.W DATA_02EB89,Y                       ; Set X speed based on direction.
    STA.B SpriteXSpeed,X
    LDA.B SpriteYSpeed,X
    BEQ CODE_02EBF8                           ; Slow the Koopa down until it's flying straight.
    CLC
    ADC.B #$FF                                ; Vertical deceleration of the ground Super Koopa.
    STA.B SpriteYSpeed,X
CODE_02EBF8:
    LDY.B #$02
    LDA.B TrueFrame
    AND.B #$04
    BEQ +                                     ; Alternate animation frame (2/3) every four frames.
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
; X offfsets for each tile of the Super Koopa. The second set is when X flipped (facing left).
; X flipped offsets.
; Y offsets for each tile of the Super Koopa.
; Tile numbers for each tile of the Super Koopa.
; 0 - Walking A
; 1 = Walking B
; 2 = Flight A
; 3 = Flight B
; 4 = Dying A
; 5 = Dying B
; 6 = Running A
; 7 = Running B / Jumping A
; 8 = Jumping B
; Extra YXPPCCCT values for each tile of the Super Koopa (specifically, the Y and T bits).
; Bit 1 being set indicates the tile is a cape tile.
; Tile sizes for each tile of the Super Koopa. 00 = 8x8, 02 = 16x16.
    JSR GetDrawInfo2                          ; Super Koopa GFX routine.
    LDA.W SpriteMisc157C,X
    STA.B _2
    LDA.W SpriteOBJAttribute,X                ; $02 = Horizontal direction
    AND.B #$0E                                ; $03 = Animation frame (times 4)
    STA.B _5                                  ; $04 = Counter for the current tile number
    LDA.W SpriteMisc1602,X                    ; $05 = Super Koopa palette
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
    CLC                                       ; Set Y position for the tile.
    ADC.W DATA_02EC4E,X
    STA.W OAMTileYPos+$100,Y
    LDA.W SuperKoopaTiles,X                   ; Set the tile number.
    STA.W OAMTileNo+$100,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Set the size of the tile.
    TAY
    LDA.W DATA_02ECBA,X
    STA.W OAMTileSize+$40,Y
    PLY
    LDA.B _2
    LSR A
    LDA.W DATA_02EC96,X
    AND.B #$02                                ; Branch if not a cape tile.
    BEQ CODE_02ED4D
    PHP
    PHX
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.W SpriteMisc1534,X                    ; Branch if the cape isn't flashing (i.e. feather Super Koopa).
    BEQ CODE_02ED3B
    LDA.B EffFrame
    LSR A
    AND.B #$01                                ; Get palette to use for the flashing Super Koopa cape (alternating red/yellow).
    PHY
    TAY
    LDA.W DATA_02ED39,Y
    PLY
    BRA +


DATA_02ED39:
    db $10,$0A

CODE_02ED3B:
; Palettes for the Super Koopa cape when flashing (i.e. feather Super Koopa).
    LDA.B SpriteNumber,X                      ; Non-flashing cape tile.
    CMP.B #$72
    LDA.B #$08                                ; Get palette to use for the Super Koopa's cape (red or yellow).
    BCC +
    LSR A
  + PLX
    PLP
    ORA.W DATA_02EC96,X                       ; Get YXPPCCCT for the cape tile.
    AND.B #$FD
    BRA +

CODE_02ED4D:
; Non-cape tile.
    LDA.W DATA_02EC96,X                       ; Just get the YXPPCCCT directly.
    ORA.B _5
  + ORA.B SpriteProperties
    BCS +
    PHA
    TXA
    CLC
    ADC.B #$24                                ; Set YXPPCCCT, accounting for X flip.
    TAX
    PLA
    ORA.B #$40
  + STA.W OAMTileAttr+$100,Y
    LDA.B _0
    CLC                                       ; Set X position for the tile.
    ADC.W DATA_02EC06,X
    STA.W OAMTileXPos+$100,Y
    INY
    INY
    INY
    INY
    INC.B _4
    LDA.B _4                                  ; Loop for all four tiles.
    CMP.B #$04
    BNE CODE_02ECF7
    PLX
    LDY.B #$FF
    LDA.B #$03                                ; Upload 4 manually-sized tiles.
    JMP CODE_02B7A7


DATA_02ED7F:
    db $10,$20,$30

FloatingSkullInit:
; X offsets for each of the three additional raft segments.
    PHB                                       ; Floating skull raft INIT
    PHK
    PLB
    JSR CODE_02ED8A
    PLB
    RTL

CODE_02ED8A:
    STZ.W SkullRaftSpeed
    INC.B SpriteTableC2,X
    LDA.B #$02                                ; Number of segments to create (minus 2).
    STA.B _0
CODE_02ED93:
    JSL FindFreeSprSlot                       ; \ Branch if no free slots; Find a sprite slot, and terminate the raft if one can't be found.
    BMI +                                     ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$61                                ; Sprite that makes up the floating skull raft.
    STA.W SpriteNumber,Y
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y                     ; Set spawn Y position to be the same as this sprite.
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    LDX.B _0
    %LorW_X(LDA,DATA_02ED7F)
    LDX.W CurSpriteProcess                    ; X = Sprite index
    CLC
    ADC.B SpriteXPosLow,X                     ; Set X position for the next raft, offset from this one.
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    PLX
  + DEC.B _0                                  ; Loop for all of the remaining segments.
    BPL CODE_02ED93
    RTS

FloatingSkullMain:
; Floating Skull Raft misc RAM:
; $C2   - Flag to indicate which skull is the "first" one.
; $157C - Always 0, but would X flip the sprite.
    PHB                                       ; Floating Skull Raft MAIN
    PHK
    PLB
    JSR CODE_02EDD8
    PLB
    RTL

CODE_02EDD8:
    LDA.B SpriteTableC2,X                     ; Branch for skulls other than the first one.
    BEQ CODE_02EDF6                           ;IF SKULLS DIEING
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    LDA.W SpriteStatus,X                      ; Branch if the skull hasn't despawned.
    BNE CODE_02EDF6                           ;IF LIVING, DO BELOW
    LDY.B #$09
CODE_02EDE6:
    LDA.W SpriteNumber,Y
    CMP.B #$61                                ;SEARCH OUT OTHERS
    BNE +                                     ; Erase all the other raft pieces with it.
    LDA.B #$00                                ;ERASE THEM TOO
    STA.W SpriteStatus,Y
  + DEY
    BPL CODE_02EDE6
Return02EDF5:
    RTS

CODE_02EDF6:
; Skull raft is still alive.
    JSL GenericSprGfxRt2                      ; Draw a 16x16 sprite.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B EffFrame
    LSR A                                     ; Correct the raft's tile and animate.
    LSR A
    LSR A
    LSR A
    LDA.B #$E0                                ; Tile A to use for the skull raft.
    BCC +
    LDA.B #$E2                                ; Tile B to use for the skull raft.
  + STA.W OAMTileNo+$100,Y
    LDA.W OAMTileYPos+$100,Y
    CMP.B #$F0
    BCS +                                     ; Shift the sprite three pixels into the ground.
    CLC
    ADC.B #$03
    STA.W OAMTileYPos+$100,Y
; Done with graphics.
  + LDA.B SpriteLock                          ; Return if game frozen.
    BNE Return02EDF5
    STZ.B _0
    LDY.B #$09
CODE_02EE21:
    LDA.W SpriteStatus,Y
    BEQ +
    LDA.W SpriteNumber,Y                      ; As far as I can tell, this is all useless.
    CMP.B #$61                                ; Seems like originally the raft was supposed to fall off ledges
    BNE +                                     ; as one single raft, rather than in pieces.
    LDA.W SpriteBlockedDirs,Y
    AND.B #$0F                                ; This probably would have searched for any rafts that were blocked
    BEQ +                                     ; on any side (i.e. still on the ground).
    STA.B _0
  + DEY
    BPL CODE_02EE21
    LDA.W SkullRaftSpeed                      ; Set X speed for the raft.
    STA.B SpriteXSpeed,X
    LDA.B SpriteYSpeed,X
    CMP.B #$20
    BMI +                                     ; I'm not sure what this code was supposed to do. Useless now, anyway.
    LDA.B #$20
    STA.B SpriteYSpeed,X
  + JSL UpdateSpritePos                       ; Update X/Y position, apply gravity, and process interaction with blocks.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ +                                     ; /
    LDA.B #$10                                ; Y speed to give the raft when it's falling.
    STA.B SpriteYSpeed,X
  + JSL MarioSprInteract                      ; Return if Mario isn't in contact with the raft.
    BCC Return02EEA8
    LDA.B PlayerYSpeed+1                      ; Return if Mario isn't moving downwards onto the raft.
    BMI Return02EEA8
    LDA.B #$0C                                ; Make the raft start moving.
    STA.W SkullRaftSpeed
    LDA.W SpriteOAMIndex,X
    TAX                                       ; Sink the platform Mario is stepping on down one pixel.
    INC.W OAMTileYPos+$100,X
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B #$01                                ; Indicate that Mario is on a solid sprite.
    STA.W StandOnSolidSprite
    STZ.B PlayerInAir
    LDA.B #$1C
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$2C
  + STA.B _1
    LDA.B SpriteYPosLow,X                     ; Shift Mario on top of the platform, accounting for Yoshi.
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
    DEY                                       ; If he's not being pushed into a wall, move Mario with the platform as well.
  + CLC
    ADC.B PlayerXPosNext
    STA.B PlayerXPosNext
    TYA
    ADC.B PlayerXPosNext+1
    STA.B PlayerXPosNext+1
Return02EEA8:
    RTS

CoinCloudMain:
; Coin game cloud misc RAM:
; $C2   - Flag to reset the number of coins the player has thus far collected.
; $1570 - Counter for the number of coins the cloud has thrown.
; $157C - Horizontal direction the sprite is facing. Always 0.
; $1765 - Flag for the coins to indicate they've bounced on the ground.
    PHB                                       ; Bonus coin game cloud MAIN
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
; Y accelerations for the coin game cloud.
    LDA.B SpriteTableC2,X                     ; Maximum Y speeds for the coin game cloud.
    BNE +                                     ; Reset the player's collected coin count.
    INC.B SpriteTableC2,X
    STZ.W GameCloudCoinCount
  + LDA.B SpriteLock                          ; Skip down to graphics if the game is frozen.
    BNE ADDR_02EF1C
    LDA.B EffFrame
    AND.B #$7F
    BNE +
    LDA.W SpriteMisc1570,X                    ; Spawn a coin/1up if there are still more to spawn and it's time to do so.
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
    LDA.B #$10                                ; Y posiion to invert the cloud's direction of vertical accelerate at.
    STA.B _2
    LDA.B #$01
    STA.B _3
    REP #$20                                  ; A->16
    LDA.B _0
    CMP.B _2
    SEP #$20                                  ; A->8; Handle vertical acceleration.
    LDY.B #$00
    BCC +                                     ; The cloud waves up and down over a "line" at a specified Y position.
    INY                                       ; When all the coins have been collected, it just accelerates upwards.
  + LDA.W SpriteMisc1570,X
    CMP.B #$0B
    BCC +
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    LDY.B #$01
  + LDA.B SpriteYSpeed,X
    CMP.W DATA_02EEB3,Y
    BEQ ADDR_02EF12
    CLC
    ADC.W DATA_02EEB1,Y
    STA.B SpriteYSpeed,X
ADDR_02EF12:
    JSR UpdateYPosNoGrvty                     ; Update Y position.
    LDA.B #$08                                ; X speed of the coin game cloud.
    STA.B SpriteXSpeed,X
    JSR UpdateXPosNoGrvty                     ; Update X position.
ADDR_02EF1C:
    LDA.W SpriteOAMIndex,X
    PHA
    CLC
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    JSL GenericSprGfxRt2                      ; Draw a 16x16 sprite.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$60                                ; Tile used for the coin game cloud.
    STA.W OAMTileNo+$100,Y
    LDA.B EffFrame
    ASL A
    ASL A                                     ; Modify YXPPCCCT.
    ASL A                                     ; Give the sprite maximum priority, and use palette 8.
    AND.B #$C0
    ORA.B #$30
    STA.W OAMTileAttr+$100,Y
    PLA
    STA.W SpriteOAMIndex,X
    JSR GetDrawInfo2
    LDA.B _0
    CLC
    ADC.B #$04                                ; X offset of the cloud's face.
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.B #$04                                ; Y offset of the cloud's face.
    STA.W OAMTileYPos+$100,Y
    LDA.B #$4D                                ; Tile to use fo the cloud's face.
    STA.W OAMTileNo+$100,Y
    LDA.B #$39                                ; Palette to use for the cloud's face.
    STA.W OAMTileAttr+$100,Y
    LDY.B #$00
    LDA.B #$00                                ; Upload an 8x8.
    JSR CODE_02B7A7
    RTS

ADDR_02EF67:
    LDA.W GameCloudCoinCount                  ; Spawning a coin/1up for the coin game cloud.
    CMP.B #$0A                                ; Brnach if Mario hasn't collected all the coins.
    BCC ADDR_02EFAA
    LDY.B #$0B
ADDR_02EF70:
    LDA.W SpriteStatus,Y
    BEQ ADDR_02EF7B                           ; Find a free sprite slot to spawn the 1up in and return if none found.
    DEY
    CPY.B #$09
    BNE ADDR_02EF70
    RTS

ADDR_02EF7B:
    LDA.B #$08                                ; \ Sprite status = Normal; Cloud is spawning a 1up.
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$78                                ; Sprite generated when all of the coin game's coins are collected (1up).
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y                    ; Spawn at the cloud's position.
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    LDA.B #$E0                                ; Initial Y speed for the 1up.
    STA.B SpriteYSpeed,X
    INC.W SpriteMisc157C,X                    ; Send it leftwards.
    PLX
    RTS

ADDR_02EFAA:
    LDA.W SpriteMisc1570,X                    ; Not time to spawn a 1up yet.
    CMP.B #$0B                                ; Return if all the coins have been thrown.
    BCS Return02EFBB
    LDY.B #$07                                ; \ Find a free extended sprite slot
ADDR_02EFB3:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ ADDR_02EFBC                           ; |; Find a free extended sprite slot and return if none found.
    DEY                                       ; |
    BPL ADDR_02EFB3                           ; |
Return02EFBB:
    RTS                                       ; / Return if no free slots

ADDR_02EFBC:
; Cloud is spawning a coin.
    LDA.B #$0A                                ; \ Extended sprite = Cloud game coin; Extended sprite that the coin game cloud drops.
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00                                ; Spawn at the center of the cloud.
    STA.W ExtSpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W ExtSpriteYPosHigh,Y
    LDA.B #$D0                                ; Initial Y speed for the coin.
    STA.W ExtSpriteYSpeed,Y
    LDA.B #$00
    STA.W ExtSpriteXSpeed,Y                   ; Clear both the coin's initial X speed and the flag for having hit the ground.
    STA.W ExtSpriteMisc1765,Y
    RTS


DATA_02EFEA:
    db $00,$80,$00,$80

DATA_02EFEE:
    db $00,$00,$01,$01

WigglerInit:
; Low bytes of the pointers to the Wiggler segment data.
; High bytes of the pointers to the Wiggler segment data.
    PHB                                       ; Wiggler INIT.
    PHK
    PLB
    JSR CODE_02F011                           ; Get the pointer to the Wiggler's parts.
    LDY.B #$7E
  - LDA.B SpriteXPosLow,X
    STA.B [WigglerSegmentPtr],Y
    LDA.B SpriteYPosLow,X                     ; Initialize all of Wiggler's parts to the spawn X and Y positions.
    INY
    STA.B [WigglerSegmentPtr],Y
    DEY
    DEY
    DEY
    BPL -
    JSR CODE_02D4FA
    TYA                                       ; Face the sprite towards Mario.
    STA.W SpriteMisc157C,X
    PLB
    RTL

CODE_02F011:
    TXA                                       ; Subroutine to get the pointer to the Wiggler's RAM division. Stored to $D5.
    AND.B #$03
    TAY
    LDA.B #WigglerTable
    CLC
    ADC.W DATA_02EFEA,Y
    STA.B WigglerSegmentPtr
    LDA.B #WigglerTable>>8                    ; Write to $7F9A7B, +80x for each Wiggler.
    ADC.W DATA_02EFEE,Y
    STA.B WigglerSegmentPtr+1
    LDA.B #WigglerTable>>16
    STA.B WigglerSegmentPtr+2
    RTS

WigglerMain:
; Wiggler misc RAM:
; $C2   - Flags for the horizontal direction each individual segment is facing.
; Due to the odd way this is handled, it'll fill up to every bit set; only the first five matter, though.
; $151C - Flag to indicate whether the Wiggler is angered (1) or not (0).
; $1534 - Frame counter for turning towards Mario when the Wiggler is angry.
; $1540 - Timer for the Wiggler's 'stunned' animation when hurt.
; $154C - Timer to disable contact with Mario.
; $1570 - Frame counter for animation.
; $157C - Horizontal direction the sprite is facing.
; $15AC - Timer for turning around.
; $1602 - Frame counter for flipping the Wiggler's segments when it turns around.
    PHB                                       ; $1765 - Flag set to 1 for Wiggler's flowers. Not used by anything, though.
    PHK
    PLB
    JSR WigglerMainRt
    PLB
    RTL


WigglerSpeed:
    db $08,$F8,$10,$F0

WigglerMainRt:
; $02F031   | X speeds for the Wiggler. First two are when normal, second two are when angry.
; Wiggler MAIN.
    JSR CODE_02F011                           ; Get the pointer to the current Wiggler's parts.
    LDA.B SpriteLock
    BEQ +                                     ; Skip down if the game is frozen.
    JMP CODE_02F0D8

  + JSL SprSprInteract                        ; Process interaction with other sprites.
    LDA.W SpriteMisc1540,X                    ; Branch if the Wiggler isn't stunned from being hit.
    BEQ CODE_02F061
    CMP.B #$01                                ; Branch if the Wiggler isn't done being stunned (still flashing).
    BNE CODE_02F050
    LDA.B #$08                                ; Turn the Wiggler red.
    BRA +

CODE_02F050:
    AND.B #$0E                                ; Make the Wiggler flash.
  + STA.B _0                                  ; Override the Wiggler's palette (make it red/flashing).
    LDA.W SpriteOBJAttribute,X
    AND.B #$F1                                ; Change the Wiggler's palette.
    ORA.B _0
    STA.W SpriteOBJAttribute,X
    JMP CODE_02F0D8                           ; Skip all normal Wiggler routines (effectively freezing it).

CODE_02F061:
    JSR UpdateXPosNoGrvty                     ; Update the sprite's X/Y position.
    JSR UpdateYPosNoGrvty
    JSR SubOffscreen0Bnk2                     ; Process offscreen from -$40 to +$30.
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc151C,X
    BEQ +                                     ; If the Wiggler is angry, animate twice as fast.
    INC.W SpriteMisc1570,X
    INC.W SpriteMisc1534,X
    LDA.W SpriteMisc1534,X
    AND.B #$3F
    BNE +                                     ; And also turn towards Mario every 64 frames.
    JSR CODE_02D4FA
    TYA
    STA.W SpriteMisc157C,X
  + LDY.W SpriteMisc157C,X
    LDA.W SpriteMisc151C,X
    BEQ +
    INY                                       ; Set X speed depending on whether or not the Wiggler is angry.
    INY
  + LDA.W WigglerSpeed,Y
    STA.B SpriteXSpeed,X
    INC.B SpriteYSpeed,X                      ; Apply gravity. (note that, since there's no cap, it may invert if the Wiggler falls too long)
    JSL CODE_019138                           ; Process object interaction.
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if touching object
    AND.B #$03                                ; |; Branch if the Wiggler hit a wall.
    BNE CODE_02F0AE                           ; /
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |; Branch if the Wiggler is not on the ground.
    BEQ CODE_02F0AE                           ; /
    JSR CODE_02FFD1                           ; Set ground Y speed for the Wiggler.
    BRA +

CODE_02F0AE:
    LDA.W SpriteMisc15AC,X                    ; Wiggler is not on the ground.
    BNE +
    LDA.W SpriteMisc157C,X
    EOR.B #$01                                ; If the Wiggler just walked off a ledge,
    STA.W SpriteMisc157C,X                    ; invert its direction and set the timer for turning around.
    STZ.W SpriteMisc1602,X
    LDA.B #$08
    STA.W SpriteMisc15AC,X
; Wiggler is not in the air.
  + JSR CODE_02F0DB                           ; Move the Wiggler's segments.
    LDA.W SpriteMisc1602,X
    INC.W SpriteMisc1602,X
    AND.B #$07
    BNE CODE_02F0D8                           ; Register X flip for each Wiggler segment.
    LDA.B SpriteTableC2,X
    ASL A
    ORA.W SpriteMisc157C,X
    STA.B SpriteTableC2,X
CODE_02F0D8:
    JMP CODE_02F110                           ; Draw GFX and handle Mario interaction.

CODE_02F0DB:
    PHX                                       ; Subroutine for the Wiggler to move its segments forward.
    PHB
    REP #$30                                  ; AXY->16
    LDA.B WigglerSegmentPtr
    CLC
    ADC.W #$007D
    TAX
    LDA.B WigglerSegmentPtr                   ; Shift the stored positions for each of the segments up two bytes.
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
    STA.B [WigglerSegmentPtr],Y               ; Add the Wiggler's current position to the list.
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
; Indices to each segment's position in the RAM table at $7F9A7B.
; When angry, these values are halved.
; Additional Y offsets to create the "wiggle" animation of the segments.
; Tile numbers to use for each frame of animation for the Wiggler's body segments.
    JSR GetDrawInfo2                          ; Wiggler GFX and interaction routine.
    LDA.W SpriteMisc1570,X
    STA.B _3
    LDA.W SpriteOBJAttribute,X                ; $02 = direction of individual segments
    STA.B _7                                  ; $03 = animation timer
    LDA.W SpriteMisc151C,X                    ; $07 = base YXPPPCCT
    STA.B _8                                  ; $08 = angered flag
    LDA.B SpriteTableC2,X
    STA.B _2
    TYA
    CLC
    ADC.B #$04
    TAY
    LDX.B #$00
CODE_02F12D:
    PHX                                       ; $05 = current segment number
    STX.B _5
    LDA.B _3
    LSR A
    LSR A
    LSR A
    NOP
    NOP                                       ; $06 = animation frame for the current segment
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
    LSR A                                     ; $09 = index to the current segment's position in the RAM table
    AND.B #$FE
    TAY
  + STY.B _9
    LDA.B [WigglerSegmentPtr],Y
    PLY
    SEC                                       ; Set X position of the segment.
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$100,Y
    PHY
    LDY.B _9
    INY
    LDA.B [WigglerSegmentPtr],Y
    PLY
    SEC                                       ; Set Y position of the segment.
    SBC.B Layer1YPos
    LDX.B _6
    SEC
    %LorW_X(SBC,DATA_02F108)
    STA.W OAMTileYPos+$100,Y
    PLX
    PHX
    LDA.B #$8C                                ; Tile to use for the head of the Wiggler.
    CPX.B #$00
    BEQ +
    LDX.B _6                                  ; Set the tile number for the current segment.
    %LorW_X(LDA,WigglerTiles)
  + STA.W OAMTileNo+$100,Y
    PLX
    LDA.B _7
    ORA.B SpriteProperties
    LSR.B _2
    BCS +                                     ; Set YXPPCCCT, accounting for the X flip of the current segment.
    ORA.B #$40
  + STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A                                     ; Set the size of the tile as 16x16.
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    INX
    CPX.B #$05                                ; Loop for 5 tiles.
    BNE CODE_02F12D
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _8                                  ; Branch if the Wiggler isn't angry.
    BEQ CODE_02F1C7
    PHX
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc157C,X
    TAX
    LDA.W OAMTileXPos+$104,Y
    CLC
    ADC.W WigglerEyesX,X                      ; Add the Wiggler's angry eyes.
    PLX
    STA.W OAMTileXPos+$100,Y
    LDA.W OAMTileYPos+$104,Y
    STA.W OAMTileYPos+$100,Y
    LDA.B #$88                                ; Tile to use for the angered Wiggler's eyes.
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$104,Y                  ; Use the same YXPPCCCT as the Wiggler.
    BRA +

CODE_02F1C7:
    PHX                                       ; Wiggler isn't angry; show the flower instead.
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc157C,X
    TAX
    LDA.W OAMTileXPos+$104,Y
    CLC
    ADC.W DATA_02F2D3,X
    PLX
    STA.W OAMTileXPos+$100,Y                  ; Add the Wiggler's flower.
    LDA.W OAMTileYPos+$104,Y
    SEC
    SBC.B #$08
    STA.W OAMTileYPos+$100,Y
    LDA.B #$98                                ; Tile to use for the normal Wiggler's flower.
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$104,Y
    AND.B #$F1                                ; Use the same YXPPCCCT as the Wiggler but with palette D.
    ORA.B #$0A
  + STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00                                ; Set size of the extra tile as 8x8.
    STA.W OAMTileSize+$40,Y
    LDA.B #$05
    LDY.B #$FF                                ; Upload 6 manually-sized tiles.
    JSR CODE_02B7A7
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    REP #$20                                  ; A->16
    LDA.B _0
    SEC
    SBC.B PlayerXPosNext                      ; Return if Mario isn't within 5 tiles of either side of the Wiggler
    CLC                                       ; or the Wiggler is no longer alive.
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
    LDA.W OAMTileXPos+$104,Y                  ; Loop to handle Mario interaction for each Wiggler segment.
    SEC
    SBC.B PlayerXPosScrRel                    ; Skip segment if Mario isn't horizontally in contact.
    ADC.B #$0C
    CMP.B #$18
    BCS CODE_02F29B
    LDA.W OAMTileYPos+$104,Y
    SEC
    SBC.B PlayerYPosScrRel
    SBC.B #$10
    PHY
    LDY.W PlayerRidingYoshi
    BEQ +                                     ; Skip segment if Mario isn't vertically in contact.
    SBC.B #$10
  + PLY
    CLC
    ADC.B #$0C
    CMP.B #$18
    BCS CODE_02F29B
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario has star; Branch if Mario has star power.
    BNE ADDR_02F29D                           ; /
    LDA.W SpriteMisc154C,X
    ORA.B PlayerYPosScrRel+1                  ; Skip segment if interaction is disabled or Mario is vertically offscreen.
    BNE CODE_02F29B
    LDA.B #$08                                ; Disable interaction to prevent double-hitting.
    STA.W SpriteMisc154C,X
    LDA.W SpriteStompCounter
    BNE CODE_02F26B
    LDA.B PlayerYSpeed+1                      ; Branch to hurt Mario if he isn't descending or hasn't bounced off an enemy already.
    CMP.B #$08
    BMI CODE_02F296
CODE_02F26B:
    LDA.B #!SFX_KICK                          ; \ Play sound effect; SFX for bouncing off a Wiggler.
    STA.W SPCIO0                              ; /
    JSL BoostMarioSpeed                       ; Boost Mario upwards.
    LDA.W SpriteMisc151C,X
    ORA.W SpriteOnYoshiTongue,X               ; Return if the Wiggler is angry or on Yoshi's tongue (don't give points).
    BNE Return02F295
    JSL DisplayContactGfx
    LDA.W SpriteStompCounter
    INC.W SpriteStompCounter                  ; Increase Mario's bounce counter and give Mario points.
    JSL GivePoints
    LDA.B #$40
    STA.W SpriteMisc1540,X                    ; Set the Wiggler to be angered.
    INC.W SpriteMisc151C,X
    JSR CODE_02F2D7                           ; Spawn the falling flower sprite.
Return02F295:
    RTS

CODE_02F296:
; Hit the Wiggler without bouncing off.
    JSL HurtMario                             ; Hurt Mario.
    RTS

CODE_02F29B:
    BRA CODE_02F2C7                           ; Not in contact with the Wiggler; skip the segment.

ADDR_02F29D:
; In contact with the Wiggler and Mario has star power.
    LDA.B #$02                                ; \ Sprite status = Killed; Kill the Wiggler.
    STA.W SpriteStatus,X                      ; /
    LDA.B #$D0                                ; Y speed to give the Wiggler when killed with star power.
    STA.B SpriteYSpeed,X
    INC.W StarKillCounter
    LDA.W StarKillCounter
    CMP.B #$09                                ; Increment star kill counter.
    BCC +                                     ; (note that for some reason 2up was chosen as the point cap, rather than 1up like normal).
    LDA.B #$09
    STA.W StarKillCounter
  + JSL GivePoints                            ; Give Mario points.
    LDY.W StarKillCounter
    CPY.B #$08
    BCS +                                     ; Get SFX for killing Wigglers with star power, if not being given a 1up.
    LDA.W StompSFX2-1,Y                       ; \ Play sound effect
    STA.W SPCIO0                              ; /
  + RTS

CODE_02F2C7:
    INY                                       ; Skipping the current Wiggler segment.
    INY
    INY
    INY
    DEC.B _0
    BMI +                                     ; Repeat for each segment, and return when done.
    JMP CODE_02F22B

  + RTS


DATA_02F2D3:
    db $00,$08

WigglerEyesX:
    db $04,$04

CODE_02F2D7:
; X offsets for the angry Wiggler's eye tile from the head, indexed by the direction he's facing.
    LDY.B #$07                                ; \ Find a free extended sprite slot; Wiggler hit for the first time, spawn the falling flower sprite.
CODE_02F2D9:
    LDA.W ExtSpriteNumber,Y                   ; |
    BEQ CODE_02F2E2                           ; |; Find an empty extended sprite slot, and return if none found.
    DEY                                       ; |
    BPL CODE_02F2D9                           ; |
    RTS                                       ; / Return if no free slots

CODE_02F2E2:
; Found an extended sprite slot.
    LDA.B #$0E                                ; \ Extended sprite = Wiggler flower; Extended sprite to spawn when the Wiggler is hurt.
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B #$01                                ; Set an unused flag for the flower.
    STA.W ExtSpriteMisc1765,Y
    LDA.B SpriteXPosLow,X
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W ExtSpriteXPosHigh,Y                 ; Spawn at the Wiggler's position.
    LDA.B SpriteYPosLow,X
    STA.W ExtSpriteYPosLow,Y
    LDA.B SpriteYPosLow,X
    STA.W ExtSpriteYPosHigh,Y
    LDA.B #$D0                                ; Initial Y speed for the flower.
    STA.W ExtSpriteYSpeed,Y
    LDA.B SpriteXSpeed,X
    EOR.B #$FF                                ; Set initial X speed to be opposite the direction the Wiggler is facing.
    INC A
    STA.W ExtSpriteXSpeed,Y
    RTS

BirdsMain:
    PHB
    PHK
; YH bird misc RAM:
; $C2   - Phase pointer. 0 = hopping, 1 = pecking
; $1540 - Timer for the pecking animation.
; $154C - Timer set when turning around due to going too far left/right. Not used for anything, though.
; $1570 - Counter for the number of hops/pecks to before switching animation.
; $157C - Horizontal direction the sprite is facing.
; $15AC - Timer for turning around, set to #$0A whenever the sprite turns.
; $1602 - Animation frame. 0 = standing, 1 = pecking, 2/3 = flying (unused), 4 = turning
    PLB                                       ; Yoshi's House birds MAIN
    JSR CODE_02F317
    PLB
    RTL

CODE_02F317:
    LDA.W SpriteMisc15AC,X
    BEQ +
    LDA.B #$04                                ; Animation frame for turning the bird around.
    STA.W SpriteMisc1602,X
  + JSR CODE_02F3EA                           ; Draw graphics.
    JSR UpdateXPosNoGrvty                     ; Update X/Y position.
    JSR UpdateYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CLC                                       ; Apply gravity.
    ADC.B #$03
    STA.B SpriteYSpeed,X
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_02F342
    dw CODE_02F38F

; Yoshi's House bird phase pointers.
; 0 - Hopping
    RTS                                       ; 1 - Pecking


DATA_02F33C:
    db $02,$03,$05,$01

DATA_02F340:
    db $08,$F8

CODE_02F342:
; Values for the possible number of times to peck.
; X speeds for the YH bird.
    LDY.W SpriteMisc157C,X                    ; YH bird phase 0 - Hopping
    LDA.W DATA_02F340,Y                       ; Set X speed.
    STA.B SpriteXSpeed,X
    STZ.W SpriteMisc1602,X
    LDA.B SpriteYSpeed,X
    BMI Return02F370
    LDA.B SpriteYPosLow,X                     ; Return if jumping and not at the bird's "ground" position.
    CMP.B #$E8
    BCC Return02F370
    AND.B #$F8                                ; Center the bird vertically on the "ground".
    STA.B SpriteYPosLow,X
    LDA.B #$F0                                ; Hopping Y speed for the bird.
    STA.B SpriteYSpeed,X
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$30                                ; Branch if not too far to the right/left of the screen (time to turn around).
    CMP.B #$60
    BCC CODE_02F381
    LDA.W SpriteMisc1570,X
    BEQ +                                     ; Branch if done hopping.
    DEC.W SpriteMisc1570,X
Return02F370:
    RTS

; Done hopping.
  + INC.B SpriteTableC2,X                     ; Switch to pecking.
    JSL GetRand
    AND.B #$03
    TAY                                       ; Set a random number of times to peck.
    LDA.W DATA_02F33C,Y
    STA.W SpriteMisc1570,X
    RTS

CODE_02F381:
; Too far to the right/left; turn around.
    LDA.W SpriteMisc154C,X                    ; Return if already turning.
    BNE +
    JSR CODE_02F3C1                           ; Turn the sprite around and set a new number of times to hop.
    LDA.B #$10                                ; Set this address for no real reason.
    STA.W SpriteMisc154C,X
  + RTS

CODE_02F38F:
; YH bird phase 1 - Pecking
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0; Clear X/Y speed.
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    STZ.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X                    ; Branch if done with a particular peck.
    BEQ CODE_02F3A3
    CMP.B #$08
    BCS +                                     ; Else animate the pecking animation.
    INC.W SpriteMisc1602,X
  + RTS

CODE_02F3A3:
    LDA.W SpriteMisc1570,X                    ; Done with a peck.
    BEQ +                                     ; Branch if done with pecking altogether (switch to hopping).
    DEC.W SpriteMisc1570,X
    JSL GetRand
    AND.B #$1F                                ; Set a random length of time ($0A to $29 frames) for the next peck.
    ORA.B #$0A
    STA.W SpriteMisc1540,X
    RTS

; Done pecking altogether.
  + STZ.B SpriteTableC2,X                     ; Switch back to hopping.
    JSL GetRand
    AND.B #$01                                ; Randomly decide whether to turn immediately after finished the peck.
    BNE +
CODE_02F3C1:
    LDA.W SpriteMisc157C,X
    EOR.B #$01                                ; Invert X direction.
    STA.W SpriteMisc157C,X
    LDA.B #$0A                                ; Set turn timer.
    STA.W SpriteMisc15AC,X
  + JSL GetRand
    AND.B #$03
    CLC                                       ; Set a random number times (between 2 and 6) to hop.
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
; Tile numbers for the birds.
; YXPPCCCT values for the birds, excluding the palette, indexed by their direction.
; Palettes (in YXPPCCCT format) for the four birds.
; OAM indices (from $0200) for the four birds.
    TXA                                       ; Yoshi House bird GFX routine.
    AND.B #$03
    TAY
    LDA.W BirdsPal,Y
    LDY.W SpriteMisc157C,X                    ; $02 = YXPPCCCT for the bird.
    ORA.W BirdsFlip,Y
    STA.B _2
    TXA
    AND.B #$03
    TAY
    LDA.W FireplaceTilemap,Y                  ; Get OAM index.
    TAY
    LDA.B SpriteXPosLow,X
    SEC                                       ; Store X position.
    SBC.B Layer1XPos
    STA.W OAMTileXPos,Y
    LDA.B SpriteYPosLow,X
    SEC                                       ; Store Y position.
    SBC.B Layer1YPos
    STA.W OAMTileYPos,Y
    PHX
    LDA.W SpriteMisc1602,X
    TAX                                       ; Store the tile number.
    %LorW_X(LDA,BirdsTilemap)
    STA.W OAMTileNo,Y
    PLX
    LDA.B _2                                  ; Store YXPPCCCT.
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A                                     ; Set size as 8x8.
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    RTS

SmokeMain:
; YH smoke misc RAM:
; $151C - Index to the offset table at $02F463, for animation.
; $1540 - Timer set on spawn to disable horizontal movement briefly, for making it rise out of the smoke stack.
; $1570 - Frame counter for handling the cloud's X speed.
    PHB                                       ; Yoshi's House smoke MAIN
    PHK
    PLB
    JSR CODE_02F434
    PLB
    RTL

CODE_02F434:
    INC.W SpriteMisc1570,X
    LDY.B #$04                                ; X speed to give the cloud when floating right.
    LDA.W SpriteMisc1570,X
    AND.B #$40                                ; Handle X speed for the cloud.
    BEQ +
    LDY.B #$FE                                ; X speed to give the cloud when floating left.
  + STY.B SpriteXSpeed,X
    LDA.B #$FC                                ; Y speed to give the cloud.
    STA.B SpriteYSpeed,X
    JSR UpdateYPosNoGrvty                     ; Update Y position.
    LDA.W SpriteMisc1540,X
    BNE +                                     ; Update X position, unless disabled briefly on spawn.
    JSR UpdateXPosNoGrvty
  + JSR CODE_02F47C                           ; Draw graphics.
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos                          ; Erase once the sprite goes vertically offscreen.
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
; Additional X offsets for the YH clouds, for animating their "floatiness".
    LDA.B EffFrame                            ; YH smoke GFX routine
    AND.B #$0F                                ; Handle the cloud's animation.
    BNE +                                     ; Note that if the cloud stays alive too long, it'll overflow the animation table.
    INC.W SpriteMisc151C,X
  + LDY.W SpriteMisc151C,X
    LDA.W DATA_02F463,Y                       ; Get the extra X offset for the current frame of animation.
    STA.B _0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    PHA
    SEC
    SBC.B _0                                  ; Set X position for each tile.
    STA.W OAMTileXPos+$100,Y
    PLA
    CLC
    ADC.B _0
    STA.W OAMTileXPos+$104,Y
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos                          ; Set Y position for each tile.
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    LDA.B #$C5                                ; Tile number to use for the YH smoke.
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$104,Y
    LDA.B #$05                                ; YXPPCCCT to use for the YH smoke.
    STA.W OAMTileAttr+$100,Y
    ORA.B #$40
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y                   ; Set both tiles as 16x16.
    STA.W OAMTileSize+$41,Y
    RTS

SideExitMain:
; Side exit sprite misc RAM:
; $C2   - Counter for deciding the current frame of animation.
    PHB                                       ; Enable side exits MAIN
    PHK
    PLB
    JSR CODE_02F4D5
    PLB
    RTL

CODE_02F4D5:
    LDA.B #$01                                ; Enable the side exits.
    STA.W SideExitEnabled
    LDA.B SpriteXPosLow,X
    AND.B #$10                                ; Return if not also creating the YH fireplace and smoke clouds.
    BNE +
    JSR CODE_02F4EB                           ; Draw the fire.
    JSR CODE_02F53E                           ; Spawn smoke clouds.
  + RTS


DATA_02F4E7:
    db $D4,$AB

DATA_02F4E9:
    db $BB,$9A

CODE_02F4EB:
; Tile numbers for the top tile of the YH flame.
; Tile numbers for the bottom tile of the YH flame.
    LDA.W SpriteOAMIndex,X                    ; Subroutine to draw the fire for the YH's fireplace.
    CLC
    ADC.B #$08
    TAY
    LDA.B #$B8                                ; X position for the fire.
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    LDA.B #$B0                                ; Y position for the top tile of the fire.
    STA.W OAMTileYPos+$100,Y
    LDA.B #$B8                                ; Y position for the bottom tile of the fire.
    STA.W OAMTileYPos+$104,Y
    LDA.B TrueFrame
if ver_is_lores(!_VER)                        ;\================= J, U, SS, & E0 ==============
    AND.B #$03                                ;!
    BNE +                                     ;!
    PHY                                       ;!
    JSL GetRand                               ;!; Randomly decide whether when to change the flame's GFX.
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
    STA.W OAMTileNo+$100,Y                    ; Set the tile numbers for the flame.
    %LorW_X(LDA,DATA_02F4E9)
    STA.W OAMTileNo+$104,Y
    LDA.B #$35                                ; YXPPCCCT for the flame.
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y                   ; Set both tiles as 8x8.
    STA.W OAMTileSize+$41,Y
    PLX
    RTS

CODE_02F53E:
    LDA.B EffFrame                            ; Subroutine to handle the smoke clouds for the YH fireplace.
    AND.B #$3F                                ; Return if not time to spawn a cloud.
    BNE +
    JSR CODE_02F548                           ; Spawn a cloud.
  + RTS

CODE_02F548:
    LDY.B #$09                                ; Subroutine to actually spawn a smoke cloud.
CODE_02F54A:
    LDA.W SpriteStatus,Y
    BEQ CODE_02F553                           ; Find a empty sprite slot and return if none found.
    DEY
    BPL CODE_02F54A
    RTS

CODE_02F553:
    LDA.B #$8B                                ; Sprite number to spawn (smoke cloud).
    STA.W SpriteNumber,Y
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    PHX
    TYX
    JSL InitSpriteTables
    LDA.B #$BB                                ; X position to spawn at.
    STA.B SpriteXPosLow,X
    LDA.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B #$E0                                ; Y position to spawn at.
    STA.B SpriteYPosLow,X
    LDA.B #$20                                ; Amount of time to freeze the cloud's horizontal movement for (for rising out of the smokestack).
    STA.W SpriteMisc1540,X
    PLX
    RTS

CODE_02F57C:
    PHB                                       ; Wrapper; Routine to draw the ghost house entrance sprite.
    PHK
    PLB
    JSR CODE_02F759
    PLB
    RTL

CODE_02F584:
    PHB                                       ; Wrapper; Routine to draw the castle entrance sprite.
    PHK
    PLB
    JSR CODE_02F66E
    PLB
    RTL

ADDR_02F58C:
    PHB                                       ; Wrapper; Routine (JSL) to set up the no-Yoshi sign sprite.
    PHK
    PLB
    JSR ADDR_02F639
    PLB
    RTL

GhostExitMain:
    PHB                                       ; Ghost House exit MAIN
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
; X low offsets for each of the Ghost House exit's tiles.
; X high offsets for each of the Ghost House exit's tiles.
; Y low offsets for each of the Ghost House exit's tiles.
; Tile numbers for each of the Ghost House exit's tiles.
; YXPPCCCT for each of the Ghost House exit's tiles.
    LDA.B Layer1XPos                          ; Ghost House exit door MAIN
    CMP.B #$46                                ; Don't draw if scrolled offscreen.
    BCS Return02F618
    LDX.B #$09
    LDY.B #$A0                                ; OAM index (from $0300) to use for the Ghost House exit.
CODE_02F5DA:
    STZ.B _2
    LDA.W DATA_02F59E,X
    SEC
    SBC.B Layer1XPos                          ; Get X position for the current tile.
    STA.B _0                                  ; $02 = high X bit for OAM
    LDA.W DATA_02F5A8,X
    SBC.B Layer1XPos+1
    BEQ +
    INC.B _2
  + LDA.B _0                                  ; Set X position.
    STA.W OAMTileXPos+$100,Y
    LDA.W DATA_02F5B2,X                       ; Set Y position.
    STA.W OAMTileYPos+$100,Y
    LDA.W DATA_02F5BC,X                       ; Set tile number.
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_02F5C6,X                       ; Set YXPPCCCT.
    STA.W OAMTileAttr+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY                                       ; Set size as 16x16 and account for the high X bit.
    LDA.B #$02
    ORA.B _2
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    DEX                                       ; Loop for all tiles.
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
; X position offsets for each tile in the No-Yoshi sign.
; Y position offsets for each tile in the No-Yoshi sign.
; Tile numbers for each tile in the No-Yoshi sign.
; YXPPCCCT for each tile in the No-Yoshi sign.
    LDX.B #$07                                ; No Yoshi sign MAIN, for the rope entrance.
    LDY.B #$B0                                ; OAM index (from $0300) to use for the rope No-Yoshi sign.
  - LDA.B #$C0
    CLC                                       ; Set X position.
    %LorW_X(ADC,DATA_02F619)
    STA.W OAMTileXPos+$100,Y
    LDA.B #$70
    CLC                                       ; Set Y position.
    %LorW_X(ADC,DATA_02F621)
    STA.W OAMTileYPos+$100,Y
    %LorW_X(LDA,DATA_02F629)
    STA.W OAMTileNo+$100,Y                    ; Set tile number.
    %LorW_X(LDA,DATA_02F631)
    STA.W OAMTileAttr+$100,Y                  ; Set YXPPCCCT.
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02                                ; Set size as 16x16.
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    DEX                                       ; Loop for all tiles.
    BPL -
    RTS

CODE_02F66E:
    LDA.W NoYoshiIntroTimer                   ; Castle door sprite MAIN
    BEQ +                                     ; Handle the animation timer.
    DEC.W NoYoshiIntroTimer
  + CMP.B #$B0
    BNE +                                     ; Handle the SFX for the door opening.
    LDY.B #!SFX_DOOROPEN                      ; \ Play sound effect
    STY.W SPCIO3                              ; /
  + CMP.B #$01
    BNE +                                     ; Handle the SFX for the door closing.
    LDY.B #!SFX_DOORCLOSE                     ; \ Play sound effect
    STY.W SPCIO3                              ; /
  + CMP.B #$30
    BCC CODE_02F69A
    CMP.B #$81
    BCC CODE_02F698
    CLC
    ADC.B #$4F
    EOR.B #$FF                                ; Get the Y position offset of the door.
    INC A
    BRA CODE_02F69A

CODE_02F698:
    LDA.B #$30                                ; Y position for the door when fully open.
CODE_02F69A:
    STA.B _0
    JSR CODE_02F6B8                           ; Draw the door.
    RTS


DATA_02F6A0:
    db $00,$10,$20,$00,$10,$20,$00,$10
    db $20,$00,$10,$20

DATA_02F6AC:
    db $00,$00,$00,$10,$10,$10,$20,$20
    db $20,$30,$30,$30

CODE_02F6B8:
; X position offsets for each tile of the castle door.
; Y position offsets for each tile of the castle door.
    LDX.B #$0B                                ; Castle door GFX routine.
    LDY.B #$B0                                ; OAM index (from $0200) for the castle door sprite.
  - LDA.B #$B8
    CLC                                       ; Set X position of the tile.
    %LorW_X(ADC,DATA_02F6A0)
    STA.W OAMTileXPos,Y
    LDA.B #$50
    SEC
    SBC.B Layer1YPos
    SEC                                       ; Set Y position of the tile.
    SBC.B _0
    CLC
    %LorW_X(ADC,DATA_02F6AC)
    STA.W OAMTileYPos,Y
    LDA.B #$A5                                ; Tile number to use for the door.
    STA.W OAMTileNo,Y
    LDA.B #$21                                ; YXPPCCCT for the door.
    STA.W OAMTileAttr,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02                                ; Set the tile as 16x16.
    STA.W OAMTileSize,Y
    PLY
    INY
    INY
    INY
    INY
    DEX                                       ; Loop for all the tiles.
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
; YXPPCCCT for each of the Ghost House entrance's tiles.
; 0 - Closed
; 1 - Slightly open
; 2 - Mostly open
; 3 - Fully open
; Y position offsets for each tile of the Ghost House entrance.
; YXPPCCCT for each tile of the ghost house entrance.
; Tile numbers for each of the Ghost House entrance's tiles.
; 0 - Closed
; 1 - Slightly open
; 2 - Mostly open
; 3 - Fully open
; OAM indices (from $0300) for each tile of the castle door.
; Frames for the door's animation.
    LDA.W NoYoshiIntroTimer                   ; Ghost House entrance MAIN
    BEQ +                                     ; Handle the animation timer.
    DEC.W NoYoshiIntroTimer
  + CMP.B #$76
    BNE +                                     ; Handle the SFX for the door opening.
    LDY.B #!SFX_DOOROPEN                      ; \ Play sound effect
    STY.W SPCIO3                              ; /
  + CMP.B #$08
    BNE +                                     ; Handle the SFX for the door closing.
    LDY.B #!SFX_DOORCLOSE                     ; \ Play sound effect
    STY.W SPCIO3                              ; /
  + LSR A
    LSR A
    LSR A                                     ; $03 = animation frame for the door
    TAY
    LDA.W DATA_02F749,Y
    STA.B _3
    LDX.B #$07
    LDA.B #$B8
    SEC                                       ; $00 = base X position
    SBC.B Layer1XPos
    STA.B _0
    LDA.B #$60
    SEC                                       ; $01 = base Y position
    SBC.B Layer1YPos
    STA.B _1
CODE_02F78C:
    STX.B _2
    LDY.W DATA_02F741,X
    LDA.B _3
    ASL A
    ASL A
    ASL A                                     ; Get index to the current tile.
    CLC
    ADC.B _2
    TAX
    TYA                                       ; Branch if the OAM index is negative (should index from $0200 rather than $0300).
    BMI CODE_02F7D0
    LDA.B _0
    CLC                                       ; Set X position.
    %LorW_X(ADC,DATA_02F6F1)
    STA.W OAMTileXPos+$100,Y
    %LorW_X(LDA,DATA_02F721)
    STA.W OAMTileNo+$100,Y                    ; Set tile number.
    LDX.B _2
    LDA.B _1
    CLC                                       ; Set Y position.
    %LorW_X(ADC,DATA_02F711)
    STA.W OAMTileYPos+$100,Y
    LDA.B _3
    CMP.B #$03
    %LorW_X(LDA,DATA_02F719)
    BCC +                                     ; Set YXPPCCCT.
    EOR.B #$40
  + STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02                                ; Set size as 16x16.
    STA.W OAMTileSize+$40,Y
    BRA CODE_02F801

CODE_02F7D0:
    LDA.B _0                                  ; Alternative code for storing to $0200 rather than $0300.
    CLC                                       ; Set X position.
    %LorW_X(ADC,DATA_02F6F1)
    STA.W OAMTileXPos,Y
    %LorW_X(LDA,DATA_02F721)
    STA.W OAMTileNo,Y                         ; Set tile number.
    LDX.B _2
    LDA.B _1
    CLC                                       ; Set Y position.
    %LorW_X(ADC,DATA_02F711)
    STA.W OAMTileYPos,Y
    LDA.B _3
    CMP.B #$03
    %LorW_X(LDA,DATA_02F719)
    BCC +                                     ; Set YXPPCCCT.
    EOR.B #$40
  + STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02                                ; Set size as 16x16.
    STA.W OAMTileSize,Y
CODE_02F801:
    DEX
    BMI +                                     ; Loop for all tiles.
    JMP CODE_02F78C

  + RTS

CODE_02F808:
    PHB                                       ; Wrapper; Routine to run cluster sprite code.
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
    JSR CODE_02F821                           ; Run each cluster sprite's code.
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
; Cluster sprite MAIN pointers.
; 00 - Skip
; 01 - Bonus game 1up
; 02 - Unused
; 03 - Boo ceiling
; 04 - Boo ring
; 05 - Castle candle flame
; 06 - Sumo Bros flame
; 07 - Reappearing ghosts
; 08 - Swooper ceiling
; Reappearing Boo misc RAM usage:
; $1E52 - Y position onscreen to respawn the ghost at (position A)
; $1E66 - X position onscreen to respawn the ghost at (position A)
; $1E7A - Y position onscreen to respawn the ghost at (position B)
; $1E8E - X position onscreen to respawn the ghost at (position B)
    LDA.W BooCloudTimer                       ; Reappearing Ghosts MAIN
    STA.W TileGenerateTrackA
    TXY
    BNE +                                     ; Handle the timer for reappearing,
    DEC.W BooCloudTimer                       ; and the counter for deciding whether the Boo
    CMP.B #$00                                ; should spawn at its "position A" or "position B".
    BNE +
    INC.W BooRingIndex
    LDY.B #$FF
    STY.W BooCloudTimer
  + CMP.B #$00                                ; Branch if not getting the next position to spawn at.
    BNE CODE_02F89E
    LDA.W SpriteWillAppear                    ; Branch if the cluster sprite isn't being stopped by sprite D2.
    BEQ +
    STZ.W ClusterSpriteNumber,X               ; Erase the cluster sprite.
    STZ.W BooRingIndex
    RTS

  + LDA.W ClusterSpriteMisc1E66,X             ; Time for the ghost to find its next position.
    STA.B _0
    LDA.W ClusterSpriteMisc1E52,X
    STA.B _1
    LDA.W BooRingIndex
    AND.B #$01                                ; Get X/Y position to spawn the current ghost at.
    BNE +                                     ; (either "position A" or "position B")
    LDA.W ClusterSpriteMisc1E8E,X
    STA.B _0
    LDA.W ClusterSpriteMisc1E7A,X
    STA.B _1
  + LDA.B _0
    CLC
    ADC.B Layer1XPos
    STA.W ClusterSpriteXPosLow,X              ; Set respawn X position.
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W ClusterSpriteXPosHigh,X
    LDA.B _1
    CLC
    ADC.B Layer1YPos
    STA.W ClusterSpriteYPosLow,X              ; Set respawn Y position.
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W ClusterSpriteYPosHigh,X
CODE_02F89E:
    TXA                                       ; Ghost isn't finding a new position and isn't being stoped by sprite D2.
    ASL A
    ASL A
    ADC.B EffFrame                            ; Branch if the game is frozen,
    STA.B _0                                  ; or not time to adjust the Boo's Y position.
    AND.B #$07
    ORA.B SpriteLock
    BNE +
    LDA.B _0
    AND.B #$20
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A                                     ; Shift the Boo's Y position for its "floating" appearance.
    TAY
    LDA.W ClusterSpriteYPosLow,X
    CLC
    ADC.W DATA_02F837,Y
    STA.W ClusterSpriteYPosLow,X
    LDA.W ClusterSpriteYPosHigh,X
    ADC.W DATA_02F839,Y
    STA.W ClusterSpriteYPosHigh,X
  + LDY.W TileGenerateTrackA
    CPY.B #$20                                ; Return if the Boo is currently completely invisible (don't draw).
    BCC Return02F8FB
    CPY.B #$40
    BCS CODE_02F8D8
    TYA
    SBC.B #$1F
    BRA CODE_02F8E2

CODE_02F8D8:
    CPY.B #$E0
    BCC CODE_02F8E6
    TYA                                       ; Handle the timing of the Boo's palette fade effect.
    SBC.B #$E0
    EOR.B #$1F
    INC A
CODE_02F8E2:
    LSR A
    LSR A
    BRA +

CODE_02F8E6:
    JSR CODE_02FBB0                           ; If the ghost is fully visible, process Mario interaction.
    LDA.B #$08
  + STA.W BooTransparency
    CPX.B #$00
    BNE +                                     ; Handle the palette fade effect (only use slot 0, to prevent running multiple times).
    JSL CODE_038239
  + LDA.B #$0F                                ; Draw GFX.
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
; Y offsets for each animation frame of the Sumo Bros. flame. $FF = skip tile.
; Tile numbers for each animation frame of the Sumo Bros. flame.
; Animation frames for the flame throughout its lifespan.
; 00 = fully extended, 03 = smallest flame.
; Sumo Bros. flame misc RAM:
; $0F4A - Timer for the flame's lifespan.
; Sumo Bros flame MAIN
    LDA.W ClusterSpriteMisc0F4A,X             ; Branch if the flame is finished.
    BEQ CODE_02F93C
    LDY.B SpriteLock
    BNE +                                     ; If the game isn't frozen, decrease its lifespan timer.
    DEC.W ClusterSpriteMisc0F4A,X
  + LSR A
    LSR A
    LSR A
    TAY                                       ; Get the current frame of animation for the flame.
    LDA.W DATA_02F90C,Y
    ASL A
    STA.W TileGenerateTrackA
    JSR CODE_02F9AE                           ; Process Mario interaction.
    PHX
    JSR CODE_02F940                           ; Draw graphics.
    PLX
    RTS

CODE_02F93C:
; Flame is finished.
    STZ.W ClusterSpriteNumber,X               ; Erase the sprite.
    RTS

CODE_02F940:
    TXA                                       ; GFX routine for the flame.
    ASL A
    TAY                                       ; Get OAM index for the current flame.
    LDA.W DATA_02FF50,Y
    STA.W SpriteOAMIndex
    LDA.W ClusterSpriteXPosLow,X
    STA.B SpriteXPosLow
    LDA.W ClusterSpriteXPosHigh,X
    STA.W SpriteXPosHigh                      ; Write the flame's position information into sprite slot 0's data,
    LDA.W ClusterSpriteYPosLow,X              ; to run GetDrawInfo for it.
    STA.B SpriteYPosLow
    LDA.W ClusterSpriteYPosHigh,X             ; Note that this is why sprites in slot 0 warp on top of the flame.
    STA.W SpriteYPosHigh
    TAY
    LDX.B #$00
    JSR GetDrawInfo2
    LDX.B #$01
CODE_02F967:
    PHX
    LDA.B _0                                  ; Set the tile's X position.
    STA.W OAMTileXPos+$100,Y
    TXA
    ORA.W TileGenerateTrackA
    TAX
    LDA.W DATA_02F8FC,X                       ; Set the tile's Y position.
    BMI +                                     ; If its Y offset was negative, skip the tile.
    CLC
    ADC.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.W SumoBroFlameTiles,X                 ; Store tile number.
    STA.W OAMTileNo+$100,Y
    LDA.B EffFrame
    AND.B #$04
    ASL A
    ASL A
    ASL A                                     ; Store YXPPCCCT, and X flip every 4 frames.
    ASL A
    NOP
    ORA.B SpriteProperties
    ORA.B #$05                                ; Palette to use for the Sumo Bros. flames.
    STA.W OAMTileAttr+$100,Y
  + PLX
    INY
    INY
    INY
    INY
    DEX                                       ; Loop for the second tile.
    BPL CODE_02F967
    LDX.B #$00
    LDY.B #$02                                ; Upload 2 16x16s.
    LDA.B #$01                                ; (cheat again by using sprite slot 0)
    JSL FinishOAMWrite
    RTS

ADDR_02F9A6:
; Touched the Sumo Bros. flame with star power.
    STZ.W ClusterSpriteNumber,X               ; Erase the sprite.
    RTS


DATA_02F9AA:
    db $02,$0A,$12,$1A

CODE_02F9AE:
; Y displacements for the flame's hitbox for each frame of animation.
    TXA                                       ; Mario interaction routine for the Sumo Bros. flames.
    EOR.B TrueFrame
    AND.B #$03                                ; Return if not processing interaction for this slot,
    BNE Return02F9FE                          ; or the flame has faded enough to not hurt Mario.
    LDA.W ClusterSpriteMisc0F4A,X
    CMP.B #$10
    BCC Return02F9FE
    LDA.W ClusterSpriteXPosLow,X
    CLC
    ADC.B #$02
    STA.B _4                                  ; Set up clipping values for the flame.
    LDA.W ClusterSpriteXPosHigh,X
    ADC.B #$00
    STA.B _A
    LDA.B #$0C                                ; Width of the flame's hitbox.
    STA.B _6
    LDY.W TileGenerateTrackA
    LDA.W ClusterSpriteYPosLow,X
    CLC
    ADC.W DATA_02F9AA,Y
    STA.B _5
    LDA.B #$14                                ; Height of the flame's hitbox.
    STA.B _7
    LDA.W ClusterSpriteYPosHigh,X
    ADC.B #$00
    STA.B _B
    JSL GetMarioClipping
    JSL CheckForContact                       ; Return if Mario isn't in contact.
    BCC Return02F9FE
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario has star; If Mario has star power, branch to erase the sprite.
    BNE ADDR_02F9A6                           ; /
CODE_02F9F5:
    LDA.W PlayerRidingYoshi
    BNE +                                     ; If Mario isn't on Yoshi, hurt him. Else...
    JSL HurtMario
Return02F9FE:
    RTS

  + JMP CODE_02A473                           ; ...knock him off Yoshi.


DATA_02FA02:
    db $03,$07,$07,$07,$0F,$07,$07,$0F
DATA_02FA0A:
    db $F0,$F4,$F8,$FC

CastleFlameTiles:
    db $E2,$E4,$E2,$E4

CastleFlameGfxProp:
    db $09,$09,$49,$49

CODE_02FA16:
; AND values used as part of determining when to switch animation frames for the castle flame.
; OAM indices (from $0300) for the castle flames.
; Tile numbers for the castle flame's animation.
; YXPPCCCT for the castle flame's animation.
; Castle flame misc RAM:
; $0F4A - Counter for the flame's current animation frame (mod 4).
    LDA.B SpriteLock                          ; Castle candle flames MAIN
    BNE +
    JSL GetRand
    AND.B #$07                                ; If the game isn't frozen,
    TAY                                       ; randomly decide when to switch animation frames.
    LDA.B TrueFrame
    AND.W DATA_02FA02,Y
    BNE +
    INC.W ClusterSpriteMisc0F4A,X
  + LDY.W DATA_02FA0A,X
    LDA.W ClusterSpriteXPosLow,X
    SEC                                       ; Set X position of the flame.
    SBC.B Layer2XPos
    STA.W OAMTileXPos+$100,Y
    LDA.W ClusterSpriteYPosLow,X
    SEC                                       ; Set Y position of the flame.
    SBC.B Layer2YPos
    STA.W OAMTileYPos+$100,Y
    PHY
    PHX
    LDA.W ClusterSpriteMisc0F4A,X
    AND.B #$03
    TAX                                       ; Set tile number for the flame.
    %LorW_X(LDA,CastleFlameTiles)
    STA.W OAMTileNo+$100,Y
    %LorW_X(LDA,CastleFlameGfxProp)
    STA.W OAMTileAttr+$100,Y                  ; Set YXPPCCCT for the flame.
    PLX
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02                                ; Set as 16x16.
    STA.W OAMTileSize+$40,Y
    PLY
    LDA.W OAMTileXPos+$100,Y
    CMP.B #$F0
    BCC +
    LDA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$1EC
    LDA.W OAMTileYPos+$100,Y                  ; If the sprite is offscreen, duplicate the flame
    STA.W OAMTileYPos+$1EC                    ; to another OAM slot with the high X bit set.
    LDA.W OAMTileNo+$100,Y                    ; (for smooth looping)
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
; Base angle offsets for each Boos in the Boo Ring.
; Boo Ring misc RAM;
; $0F4A - Rotational speed of the ring. Only set for the "base" Boo of the ring (in position 9); all others have 0.
; $0F72 - Which position in the ring the Boo is at (00 - 09).
; $0F86 - Which ring the Boo belongs to (00 or 01).
    LDY.W ClusterSpriteMisc0F86,X             ; Boo ring MAIN
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
  + CLC                                       ; Update the Boo Ring's angle.
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
    BCC CODE_02FAF0                           ; Handle the flag for the Boo Ring being offscreen
    LDA.B #$01                                ; and despawn it if so.
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
    ADC.W BooRingAngleLow,Y                   ; $00 = current angle of the Boo
    STA.B _0
    %LorW_X(LDA,DATA_02FA85)
    ADC.W BooRingAngleHigh,Y
    AND.B #$01
    STA.B _1
    PLX
    REP #$30                                  ; AXY->16
    LDA.B _0
    CLC
    ADC.W #$0080                              ; $02 = Angle shifted by 0x80.
    AND.W #$01FF
    STA.B _2
    LDA.B _0
    AND.W #$00FF
    ASL A                                     ; Get the sin value for the angle.
    TAX
    LDA.L CircleCoords,X
    STA.B _4
    LDA.B _2
    AND.W #$00FF
    ASL A                                     ; Get the cos value for the angle.
    TAX
    LDA.L CircleCoords,X
    STA.B _6
    SEP #$30                                  ; AXY->8
    LDA.B _4
    STA.W HW_WRMPYA
    LDA.B #$50                                ; Horizontal radius of the ring.
    LDY.B _5
    BNE +
    STA.W HW_WRMPYB
    NOP
    NOP
    NOP
    NOP                                       ; Get the X offset for the boo.
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
    LDA.B #$50                                ; Vertical radius of the ring.
    LDY.B _7
    BNE +
    STA.W HW_WRMPYB
    NOP
    NOP
    NOP
    NOP                                       ; Get the Y offset for the boo.
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
  + CLC                                       ; Set the Boo's proper X position.
    ADC.W BooRingXPosLow,Y
    STA.W ClusterSpriteXPosLow,X
    LDA.W BooRingXPosHigh,Y
    ADC.B _0
    STA.W ClusterSpriteXPosHigh,X
    STZ.B _1
    LDA.B _6
    BPL +
    DEC.B _1
  + CLC                                       ; Set the Boo's proper Y position.
    ADC.W BooRingYPosLow,Y
    STA.W ClusterSpriteYPosLow,X
    LDA.W BooRingYPosHigh,Y
    ADC.B _1
    STA.W ClusterSpriteYPosHigh,X
    JSR CODE_02FC8D
CODE_02FBB0:
    TXA
    EOR.B TrueFrame                           ; Process interaction with Mario.
    AND.B #$03                                ; Only process for 1/4 of the Boos at a time.
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
; X accelerations for the Boo when turning around while translucent.
; Maximum X speeds for the Boo when turning around while translucent.
; These mark the point where it actually turns around.
; Boo Ceiling / Swooper Ceiling misc RAM usage:
; $0F4A - Boo only: Direction the Boo is facing. Even = right, odd = left.
; $0F72 - Boo/swooper "spawn" Y position (for deciding when to end its swoop).
; $0F86 - Flag for whether the sprite is opaque/attacking (1) or translucent (0).
; $0F9A - When opaque: Timer for waiting to "swoop" from the ceiling.
; When translucent (Boo only): Timer for waiting to reverse direction.
; $1E52 - Y speed.
; $1E66 - X speed.
; $1E7A - Accumulating faction bits for Y position. Only used when fully visible (opaque).
; $1E88 - Accumulating faction bits for X position.
    CPX.B #$00                                ; Boo Ceiling MAIN / Swooper Ceiling MAIN
    BEQ +                                     ; Skip down if not the "base" cluster sprite (to prevent running code multiple times).
    JMP CODE_02FC41

  + LDA.B TrueFrame                           ; "Base" code (run-once) for the ceiling.
    AND.B #$07                                ; Skip down if not time to spawn a Boo/Swooper.
    ORA.B SpriteLock
    BNE CODE_02FC3E
    JSL GetRand
    AND.B #$1F
    CMP.B #$14
    BCC +                                     ; Take a random cluster sprite slot and see if a Boo/Swooper can be 'spawned' in it.
    SBC.B #$14                                ; Skip down if not.
  + TAX
    LDA.W ClusterSpriteMisc0F86,X
    BNE CODE_02FC3E
    INC.W ClusterSpriteMisc0F86,X             ; Mark the sprite as 'visible'.
    LDA.B #$20                                ; Set the timer for waiting to swoop down.
    STA.W ClusterSpriteMisc0F9A,X
    STZ.B _0
    LDA.W ClusterSpriteXPosLow,X
    SBC.B Layer1XPos
    ADC.B Layer1XPos
    PHP                                       ; Reset the sprite's X position to be onscreen.
    ADC.B _0
    STA.W ClusterSpriteXPosLow,X              ; Note that this also overwrite's sprite slot 0's data
    STA.B SpriteXPosLow                       ; (for running certain sprite routines), hence the glitch
    LDA.B Layer1XPos+1                        ; where that slot will warp around in levels with the ceiling.
    ADC.B #$00
    PLP
    ADC.B #$00
    STA.W ClusterSpriteXPosHigh,X
    STA.W SpriteXPosHigh
    LDA.W ClusterSpriteYPosLow,X
    SBC.B Layer1YPos
    ADC.B Layer1YPos
    STA.W ClusterSpriteYPosLow,X
    STA.B SpriteYPosLow                       ; Reset the sprite's Y position to be onscreen too.
    AND.B #$FC
    STA.W ClusterSpriteMisc0F72,X             ; Again overwrite's sprite slot 0's position.
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W ClusterSpriteYPosHigh,X
    STA.W SpriteYPosHigh
    PHX
    LDX.B #$00
    LDA.B #$10                                ; Minimum X/Y speed to give the ghost.
    JSR CODE_02D2FB
    PLX
    LDA.B _0                                  ; Set X/Y speed for the Boo, aiming towards Mario.
    ADC.B #$09
    STA.W ClusterSpriteMisc1E52,X
    LDA.B _1
    STA.W ClusterSpriteMisc1E66,X
CODE_02FC3E:
    LDX.W CurSpriteProcess                    ; X = Sprite index
CODE_02FC41:
    LDA.B SpriteLock
    BNE +
    LDA.W ClusterSpriteMisc0F9A,X             ; Handle the timer for waiting to "swoop" the Boo.
    BEQ +
    DEC.W ClusterSpriteMisc0F9A,X
  + LDA.W ClusterSpriteMisc0F86,X
    BNE +                                     ; Skip down if the Boo is currently translucent.
    JMP CODE_02FCE2

; Boo is fully visible (opaque) and attacking Mario.
  + LDA.B SpriteLock                          ; Skip to graphics if game frozen.
    BNE CODE_02FC8D
    LDA.W ClusterSpriteMisc0F9A,X             ; Branch if not time to actually swoop.
    BNE +
    JSR CODE_02FF98                           ; Update X/Y position.
    JSR CODE_02FFA3
    TXA
    EOR.B TrueFrame
    AND.B #$03                                ; Every four frames, process interaction with Mario
    BNE +                                     ; and handle vertical acceleration.
    JSR CODE_02FE71
    LDA.W ClusterSpriteMisc1E52,X
    CMP.B #$E1                                ; Maximum upwards speed to give the Boo.
    BMI +
    DEC.W ClusterSpriteMisc1E52,X
  + LDA.W ClusterSpriteYPosLow,X              ; Not swooping.
    AND.B #$FC
    CMP.W ClusterSpriteMisc0F72,X
    BNE CODE_02FC8D                           ; If the Boo returns to its original Y position,
    LDA.W ClusterSpriteMisc1E52,X             ; return it to normal (end the swoop) and clear its Y speed.
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
    SEC                                       ; Return if the ghost is more than 4 tiles horizontally offscreen.
    SBC.B Layer1XPos
    CLC
    ADC.W #$0040
    CMP.W #$0180
    SEP #$20                                  ; A->8
    BCS Return02FCD8
    LDA.B #$02                                ; Draw GFX.
    JSR CODE_02FD48
    LDA.W ClusterSpriteYPosLow,X
    CLC
    ADC.B #$10
    PHP
    CMP.B Layer1YPos                          ; Branch if vertically offscreen.
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
    LDA.W DATA_02FF50,X                       ; Handle the high X bit of the ghost's OAM.
    LSR A
    LSR A
    TAY
    LDA.B #$03
    STA.W OAMTileSize+$40,Y
Return02FCD8:
    RTS

CODE_02FCD9:
    LDY.W DATA_02FF50,X                       ; Boo is vertically offscreen.
    LDA.B #$F0                                ; Hide the sprite.
    STA.W OAMTileYPos+$100,Y
    RTS

CODE_02FCE2:
    LDA.B SpriteLock                          ; Boo is currently translucent and floating around.
    BNE CODE_02FD46                           ; Skip to graphics if game frozen or running the Swooper Death Bat ceiling.
    LDA.W ClusterSpriteNumber,X               ; (i.e. death bats don't show up as translucent in-between spawns)
    CMP.B #$08
    BEQ CODE_02FD46
    LDA.W ClusterSpriteMisc0F9A,X
    BNE +
    LDA.B TrueFrame                           ; Branch if not time to turn or not a frame to update the sprite's X speed.
    AND.B #$01
    BNE +
    LDA.W ClusterSpriteMisc0F4A,X
    AND.B #$01
    TAY
    LDA.W ClusterSpriteMisc1E66,X             ; Handle the Boo's X speed.
    CLC                                       ; When time to turn around, slow the Boo down until it reaches a certain X speed,
    ADC.W DATA_02FBBB,Y                       ; at which point flip its direction and decide how long to wait before turning around again.
    STA.W ClusterSpriteMisc1E66,X
    CMP.W DATA_02FBBD,Y
    BNE +
    INC.W ClusterSpriteMisc0F4A,X
    LDA.W RandomNumber
    AND.B #$FF                                ; Set a random amount of time to wait before turning around again.
    ORA.B #$3F
    STA.W ClusterSpriteMisc0F9A,X
  + JSR CODE_02FF98                           ; Update the sprite's X position.
    TXA
    EOR.B TrueFrame
    AND.B #$03
    BNE CODE_02FD46
    STZ.B _0
    LDY.B #$01                                ; Downwards Y speed.
    TXA
    ASL A
    ASL A
    ASL A
    ADC.B TrueFrame                           ; Handle updating the Boo's Y position.
    AND.B #$40                                ; Only update every 4 frames, and change direction of movement every 64.
    BEQ +
    LDY.B #$FF                                ; Upwards Y speed.
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
; GFX routine for Boo cluster sprites (reappearing, ceiling, ring) and the Swooper ceiling.
    STA.B _2                                  ; Load palette for YXPPCCCT to A before running.
    LDY.W DATA_02FF50,X
    LDA.W ClusterSpriteXPosLow,X
    SEC                                       ; Set X position.
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$100,Y
    LDA.W ClusterSpriteYPosLow,X
    SEC                                       ; Set Y position.
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    AND.B #$01
    STA.B _0
    TXA                                       ; Set tile number, handling the Boo's normal animation.
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
    LDA.B #$40                                ; Set YXPPCCCT.
  + ORA.B #$31                                ; Priority and GFX page for the sprite.
    ORA.B _2
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02                                ; Set tile size as 16x16.
    STA.W OAMTileSize+$40,Y
    LDA.W ClusterSpriteNumber,X
    CMP.B #$08                                ; Return if not running the Swooper Death Bat Ceiling sprite.
    BNE +
    LDY.W DATA_02FF50,X
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$01
    STA.B _0
    LDA.W ClusterSpriteMisc0F86,X             ; Change the tile number for the sprite.
    ASL A
    ORA.B _0
    PHX
    TAX
    LDA.W BatCeilingTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.B #$37                                ; YXPPCCCT for the Swooper death bat ceiling.
    STA.W OAMTileAttr+$100,Y
    PLX
  + RTS


BatCeilingTiles:
    db $AE,$AE,$C0,$EB

CODE_02FDBC:
; Tile numbers for the Swooper ceiling sprites.
; Bonus game 1up misc RAM:
; $1E52 - Y speed. Set to #$10 when spawned.
; $1E66 - X speed. Set to #$01 when spawned; only used when on the ground.
; $1E7A - Accumulating fraction bits for Y position.
; Bonus game 1ups MAIN
    JSR CODE_02FFA3                           ; Update Y position.
    LDA.W ClusterSpriteMisc1E52,X
    CMP.B #$40
    BPL +                                     ; Apply gravity.
    CLC                                       ; Cap max Y speed at #$40.
    ADC.B #$03
    STA.W ClusterSpriteMisc1E52,X
  + LDA.W ClusterSpriteYPosHigh,X
    BEQ +
    LDA.W ClusterSpriteYPosLow,X
    CMP.B #$80                                ; If hitting the ground (Y=0080),
    BCC +                                     ; clear Y speed and clip Y position.
    AND.B #$F0
    STA.W ClusterSpriteYPosLow,X
    STZ.W ClusterSpriteMisc1E52,X
if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
  + TXA                                       ;!
    EOR.B TrueFrame                           ;!; Branch every other frame.
    LSR A                                     ;!
    BCC CODE_02FE48                           ;!
endif                                         ;/===============================================
  + LDA.W ClusterSpriteMisc1E52,X             ; Branch if falling.
    BNE +
    LDA.W ClusterSpriteMisc1E66,X
    CLC                                       ; Update X position.
    ADC.W ClusterSpriteXPosLow,X
    STA.W ClusterSpriteXPosLow,X
    LDA.W ClusterSpriteXPosLow,X
    EOR.W ClusterSpriteMisc1E66,X             ; Branch to avoid flipping into a wall.
    BPL +
    LDA.W ClusterSpriteXPosLow,X
    CLC
    ADC.B #$20                                ; Branch if not hitting one of the walls.
    CMP.B #$30
    BCS +
    LDA.W ClusterSpriteMisc1E66,X
    EOR.B #$FF                                ; Flip X speed otherwise.
    INC A
    STA.W ClusterSpriteMisc1E66,X
  + LDA.B PlayerXPosNext                      ; Not hitting a wall.
    SEC
    SBC.W ClusterSpriteXPosLow,X
    CLC                                       ; Branch if Mario isn't horizontally near the sprite.
    ADC.B #$0C
    CMP.B #$1E
    BCS CODE_02FE48
    LDA.B #$20
    LDY.B PlayerIsDucking
    BNE +
    LDY.B Powerup
    BEQ +
    LDA.B #$30                                ; Branch if Mario isn't vertically near the sprite,
  + STA.B _0                                  ; accounting for powerup/ducking.
    LDA.B PlayerYPosNext
    SEC
    SBC.W ClusterSpriteYPosLow,X
    CLC
    ADC.B #$20
    CMP.B _0
    BCS CODE_02FE48
    STZ.W ClusterSpriteNumber,X               ; Erase the sprite.
    JSR CODE_02FF6C                           ; Give a 1up.
    DEC.W BonusOneUpsRemain
    BNE CODE_02FE48                           ; If all the 1ups have been collected, set the end bonus game timer.
    LDA.B #$58
    STA.W BonusFinishTimer
CODE_02FE48:
    LDY.W DATA_02FF64,X                       ; Not touching the sprite; draw OAM.
    LDA.W ClusterSpriteXPosLow,X
    SEC                                       ; Set X position.
    SBC.B Layer1XPos
    STA.W OAMTileXPos,Y
    LDA.W ClusterSpriteYPosLow,X
    SEC                                       ; Set Y position.
    SBC.B Layer1YPos
    STA.W OAMTileYPos,Y
    LDA.B #$24                                ; Tile number for the bonus game 1up.
    STA.W OAMTileNo,Y
    LDA.B #$3A                                ; YXPPCCCT for the bonus game 1up.
    STA.W OAMTileAttr,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02                                ; Set as 16x16.
    STA.W OAMTileSize,Y
    RTS

CODE_02FE71:
    LDA.B #$14                                ; Routine to handle cluster sprite interaction with Mario (hurts him if in contact).
    BRA +

    LDA.B #$0C                                ; Unreachable instruction; [unused line that would use a smaller field of interaction]
  + STA.B _2
    STZ.B _3
    LDA.W ClusterSpriteXPosLow,X
    STA.B _0                                  ; $00 = 16-bit X position
    LDA.W ClusterSpriteXPosHigh,X
    STA.B _1
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    SEC
    SBC.B _0
    CLC                                       ; Return if Mario isn't horizontally in contact with the sprite.
    ADC.W #$000A
    CMP.B _2
    SEP #$20                                  ; A->8
    BCS Return02FEC4
    LDA.W ClusterSpriteYPosLow,X
    ADC.B #$03
    STA.B _2                                  ; $02 = 16-bit Y position
    LDA.W ClusterSpriteYPosHigh,X
    ADC.B #$00
    STA.B _3
    REP #$20                                  ; A->16
    LDA.W #$0014
    LDY.B Powerup
    BEQ +
    LDA.W #$0020
  + STA.B _4
    LDA.B PlayerYPosNext                      ; Return if Mario isn't vertically in contact, accounting for Yoshi.
    SEC
    SBC.B _2
    CLC
    ADC.W #$001C
    CMP.B _4
    SEP #$20                                  ; A->8
    BCS Return02FEC4
    JSR CODE_02F9F5                           ; Hurt Mario or knock him off Yoshi.
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

; (unused) Low bytes of the vertical offscreen processing distances for cluster sprites.
; (unused) High bytes of the vertical offscreen processing distances for cluster sprites.
; (unused) Low bytes of the horizontal offscreen processing distances for cluster sprites.
; (unused) High bytes of the horizontal offscreen processing distances for cluster sprites.
    LDA.B ScreenMode                          ; \ Unreachable; Unused version of SubOffScreen for cluster sprites.
    AND.B #!ScrMode_Layer1Vert                ; Branch if the level is vertical.
    BNE ADDR_02FF1E
    LDA.W ClusterSpriteYPosLow,X
    CLC
    ADC.B #$50
    LDA.W ClusterSpriteYPosHigh,X             ; Branch if the sprite is vertically below the level.
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
    PHP                                       ; Check if within the horizontal bounds of the screen (-$40 to +$30)
    LDA.B Layer1XPos+1                        ; If it is within the bounds (i.e. onscreen), return.
    LSR.B _0
    ADC.W DATA_02FECB,Y                       ; Alternates sides each frame.
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
    BEQ +                                     ; Mark the cluster sprite as respawnable in the load table.
    LDA.B #$00                                ; \ Allow sprite to be reloaded by level loading routine; (apparently $0F86 was a load status index table at some point)
    STA.W SpriteLoadStatus,Y                  ; /
  + STZ.W ClusterSpriteNumber,X               ; Erase the cluster sprite.
Return02FF1D:
    RTS                                       ; /

ADDR_02FF1E:
    LDA.B TrueFrame                           ; \ Unreachable, called from above routine
    LSR A                                     ; Return if not a frame to check in a vertical level.
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
    LDA.W Layer1YPos+1                        ; Check if within the vertical bounds of the screen (-$40 to +$50)
    LSR.B _0                                  ; If it is within the bounds (i.e. onscreen), return.
    ADC.W DATA_02FEC7,Y
    PLP                                       ; Alternates sides every two frames.
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
; Cluster sprite OAM indices (from $0300).
; OAM indices for the bonus game 1up cluster sprites.
; Subroutine to spawn a score sprite for the Bonus Game 1ups.
    JSL CODE_02AD34                           ; Find an empty score slot.
    LDA.B #$0D                                ; Give a 1up.
    STA.W ScoreSpriteNumber,Y
    LDA.W ClusterSpriteYPosLow,X
    SEC
    SBC.B #$08
    STA.W ScoreSpriteYPosLow,Y
    LDA.W ClusterSpriteYPosHigh,X             ; Spawn at the 1up's position.
    SBC.B #$00
    STA.W ScoreSpriteYPosHigh,Y
    LDA.W ClusterSpriteXPosLow,X
    STA.W ScoreSpriteXPosLow,Y
    LDA.W ClusterSpriteXPosHigh,X
    STA.W ScoreSpriteXPosHigh,Y
    LDA.B #$30                                ; Time to display the sprite.
    STA.W ScoreSpriteTimer,Y
    RTS

CODE_02FF98:
; RAM setup:
; $1E52 - Y speed
; $1E66 - X speed
; $1E7A - Accumulating Y fraction bits
; $1E8E - Accumulating X fraction bits
    PHX                                       ; Routine to update cluster sprite X position.
    TXA
    CLC
    ADC.B #$14                                ; Run routine below for X position.
    TAX
    JSR CODE_02FFA3
    PLX
    RTS

CODE_02FFA3:
    LDA.W ClusterSpriteMisc1E52,X             ; Routine to update cluster sprite X/Y position. Run directly to update Y position.
    ASL A
    ASL A
    ASL A                                     ; Update fraction bits.
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
    ORA.B #$F0                                ; Update position.
    DEY
  + PLP
    ADC.W ClusterSpriteYPosLow,X
    STA.W ClusterSpriteYPosLow,X
    TYA
    ADC.W ClusterSpriteYPosHigh,X
    STA.W ClusterSpriteYPosHigh,X
    RTS

CODE_02FFD1:
; Equivalent routine in bank 1 at $019A04.
    LDA.W SpriteBlockedDirs,X                 ; Subroutine to set Y speed for a sprite when on the ground.
    BMI ADDR_02FFDD
    LDA.B #$00
    LDY.W SpriteSlope,X                       ; If standing on a slope or Layer 2, give the sprite a Y speed of #$18.
    BEQ +                                     ; Else, clear its Y speed.
ADDR_02FFDD:
    LDA.B #$18
  + STA.B SpriteYSpeed,X
    RTS

    %insert_empty($05,$1E,$1E,$24,$30)
