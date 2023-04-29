ORG $008000

I_RESET:
    SEI                                       ; Disable IRQ.
    STZ.W HW_NMITIMEN                         ; Disable IRQ, NMI and joypad reading.
    STZ.W HW_HDMAEN                           ; Disable HDMA.
    STZ.W HW_MDMAEN                           ; Disable DMA.
    STZ.W HW_APUIO0                           ;\ Clear SPC I/O ports.
    STZ.W HW_APUIO1                           ;|
    STZ.W HW_APUIO2                           ;|
    STZ.W HW_APUIO3                           ;/
    LDA.B #!HW_DISP_FBlank                    ;\ Enable F-blank.
    STA.W HW_INIDISP                          ;/
    CLC                                       ;\ Disable emulation mode.
    XCE                                       ;/
    REP #$38                                  ; AXY->16, Disable decimal mode.
    LDA.W #0                                  ;\ Initialize direct page to 0x0000.
    TCD                                       ;/
    LDA.W #StackStart                         ;\ Initialize stack pointer to $01FF.
    TCS                                       ;/

    LDA.W #$A9|(!OBJOffscreen<<8)             ;\ "LDA #$F0"
    STA.L OAMResetRoutine                     ;/
    LDX.W #3*(!OBJCount-1)                    ;
    LDY.W #OAMMirror+4*(!OBJCount-1)+1        ; Starting address to clear ($03FD).
  - LDA.W #$008D                              ;\ 
    STA.L OAMResetRoutine+2,X                 ;| "STA $xxxx" for each OAM slot
    TYA                                       ;|
    STA.L OAMResetRoutine+3,X                 ;/
    SEC                                       ;\ 
    SBC.W #4                                  ;|
    TAY                                       ;|
    DEX #3                                    ;| Loop for all OAM slots.
    BPL -                                     ;/
    SEP #$30                                  ; AXY->8
    LDA.B #$6B                                ;\ "RTL"
    STA.L OAMResetRoutine+386                 ;/

    JSR UploadSPCEngine                       ; Upload the SPC engine.
    STZ.W GameMode                            ; Clear game mode.
    STZ.W OverworldOverride                   ; Clear OW bypass level number.
    JSR ClearMemory                           ; Clear out $0000-$1FFF and $7F837B/D.
    JSR UploadSamples                         ; Upload SPC samples.
    JSR WindowDMASetup                        ; Set up DMA for window settings.
    LDA.B #(VRam_OBJTiles>>13)|!HW_OBJ_Size_8_16
    STA.W HW_OBJSEL                           ; Set OAM character sizes to be 8x8 and 16x16.
    INC.B LagFlag                             ;

GameLoop:                                     ; Main game loop.
    LDA.B LagFlag                             ;\ Wait for NMI before executing next frame.
    BEQ GameLoop                              ;/
    CLI                                       ; Enable interrupts.
    INC.B TrueFrame                           ; Increment global frame counter.
    JSR RunGameMode                           ; Run the game.
    STZ.B LagFlag                             ; Indicate that the current frame has finished.
    BRA GameLoop                              ;

SPC700UploadLoop:                             ; Subroutine to upload data to the SPC chip. 24-bit pointer to data should be in $00.
    PHP                                       ;
    REP #$30                                  ; AXY->16
    LDY.W #0                                  ;
    LDA.W #$BBAA                              ; Value to check for when the SPC chip is ready.
  - CMP.W HW_APUIO0                           ;\ Wait for the SPC to be ready.
    BNE -                                     ;/
    SEP #$20                                  ; A->8
    LDA.B #$CC                                ; Byte used to enable SPC block upload.
    BRA SendSPCBlock                          ;

TransferBytes:                                ; Block upload loop. Entry point at $0080B3
    LDA.B [_0],Y                              ;\ 
    INY                                       ;| Load first byte to upload.
    XBA                                       ;|
    LDA.B #0                                  ;/ Validation byte for SPC.
    BRA StartTransfer                         ;

NextByte:                                     ; Inner byte loop for each block. Entry point below.
    XBA                                       ;\\ 
    LDA.B [_0],Y                              ;|| Load next byte.
    INY                                       ;||
    XBA                                       ;|/
  - CMP.W HW_APUIO0                           ;|\ Wait for the SPC to respond from the previous byte.
    BNE -                                     ;|/
    INC A                                     ;| Increment validation byte.
StartTransfer:                                ;| Entry point for the inner byte loop.
    REP #$20                                  ;|\ A->16
    STA.W HW_APUIO0                           ;|| Send byte, plus the validation byte.
    SEP #$20                                  ;|/ A->8
    DEX                                       ;|
    BNE NextByte                              ;/

  - CMP.W HW_APUIO0                           ;\ Wait for the SPC to respond from the last byte of the block.
    BNE -                                     ;/
  - ADC.B #3                                  ;\ Add 3; if A becomes 0, add 3 once more so it's still positive.
    BEQ -                                     ;/

SendSPCBlock:                                 ; Entry point for the SPC engine upload loop.
    PHA                                       ;
    REP #$20                                  ; A->16
    LDA.B [_0],Y                              ;\ 
    INY #2                                    ;| Get data length.
    TAX                                       ;/
    LDA.B [_0],Y                              ;\ 
    INY #2                                    ;| Send the ARAM address to write to.
    STA.W HW_APUIO2                           ;/
    SEP #$20                                  ; A->8
    CPX.W #1                                  ;\ 
    LDA.B #0                                  ;| If at the end of the data block, send #$00.
    ROL A                                     ;|  Else, send #$01.
    STA.W HW_APUIO1                           ;/
    ADC.B #$7F                                ; Set overflow flag if there are still bytes left to write.
    PLA                                       ;\ 
    STA.W HW_APUIO0                           ;| Send a byte to indicate the write is done,
  - CMP.W HW_APUIO0                           ;|  then wait for the response back from the SPC chip.
    BNE -                                     ;/
    BVS TransferBytes                         ; If the overflow flag was set earlier, jump back to upload additional blocks.
    STZ.W HW_APUIO0                           ;\ 
    STZ.W HW_APUIO1                           ;| Clear SPC I/O ports.
    STZ.W HW_APUIO2                           ;|
    STZ.W HW_APUIO3                           ;/
    PLP                                       ;
    RTS                                       ;

UploadSPCEngine:                              ; Routine to upload the music engine to the SPC700 chip.
    LDA.B #SPC700Engine                       ;\ 
    %BorW(STA, _0)                            ;|
    LDA.B #SPC700Engine>>8                    ;|
    %BorW(STA, _1)                            ;| Point $00 to the SPC engine code at $0E8000.
    LDA.B #SPC700Engine>>16                   ;|
    %BorW(STA, _2)                            ;/
UploadDataToSPC:                              ;
    SEI                                       ;\ 
    JSR SPC700UploadLoop                      ;| Upload the data pointed to by $00. Make sure interrupts don't fire during the process.
    CLI                                       ;/
    RTS                                       ;

UploadSamples:                                ; Routine to upload music samples to the SPC700 chip.
    LDA.B #MusicSamples                       ;\ 
    %BorW(STA, _0)                            ;|
    LDA.B #MusicSamples>>8                    ;| Point $00 to the SPC sample data at $0F8000.
    %BorW(STA, _1)                            ;|
    LDA.B #MusicSamples>>16                   ;|
    %BorW(STA, _2)                            ;/
    BRA StartMusicUpload                      ; Upload data.

UploadMusicBank1:                             ; Routine to upload overworld music data to the SPC700 chip.
    LDA.B #MusicBank1                         ;\ 
    %BorW(STA, _0)                            ;|
    LDA.B #MusicBank1>>8                      ;| Point $00 to the overworld music bank at $0E98B1.
    %BorW(STA, _1)                            ;|
    LDA.B #MusicBank1>>16                     ;|
    %BorW(STA, _2)                            ;/
StartMusicUpload:                             ;
    LDA.B #-1                                 ;\ Tell the SPC that music data is being sent.
    STA.W HW_APUIO1                           ;/
    JSR UploadDataToSPC                       ; Upload data.
    LDX.B #3                                  ;\ 
  - STZ.W HW_APUIO0,X                         ;|
    STZ.W SPCIO0,X                            ;|
    STZ.W Empty1DFD,X                         ;| Clear out all SPC I/O ports and mirrors.
    DEX                                       ;|
    BPL -                                     ;/
SPCUploadReturn:                              ;
    RTS                                       ;

UploadLevelMusic:                             ; Routine to upload level music data to the SPC700 chip.
    LDA.W BonusGameActivate                   ;\ 
    BNE UploadOverworldMusic                  ;| Upload the level music bank on one of 3 conditions:
    LDA.W OverworldOverride                   ;|  1. Going to a bonus game.
    CMP.B #!MainMapLvls+!IntroCutsceneLevel   ;|  2. Loading the intro level.
    BEQ UploadOverworldMusic                  ;|  3. Going to a new level (not primary).
    ORA.W SublevelCount                       ;| If none of these conditions are met, return.
    ORA.W ShowMarioStart                      ;|
    BNE SPCUploadReturn                       ;/
UploadOverworldMusic:                         ;
    LDA.B #MusicBank2                         ;\ 
    %BorW(STA, _0)                            ;|
    LDA.B #MusicBank2>>8                      ;| Point $00 to the level music bank at $0EAED6.
    %BorW(STA, _1)                            ;|
    LDA.B #MusicBank2>>16                     ;|
    %BorW(STA, _2)                            ;/
    BRA StartMusicUpload                      ; Upload the data.

UploadCreditsMusic:                           ; Routine to upload credits music data to the SPC700 chip.
    LDA.B #MusicBank3                         ;\ 
    %BorW(STA, _0)                            ;|
    LDA.B #MusicBank3>>8                      ;| Point $00 to the credits music bank at $03E400.
    %BorW(STA, _1)                            ;|
    LDA.B #MusicBank3>>16                     ;|
    %BorW(STA, _2)                            ;/
    BRA StartMusicUpload                      ; Upload the data.


I_NMI:                                        ; NMI routine.
    SEI                                       ; Disable interrupts to prevent interrupting an interrupt.
    PHP                                       ;\ 
    REP #$30                                  ;| AXY->16
    PHA                                       ;| Preserve values to be restored at the end.
    PHX                                       ;| Note: direct page and $00-$04 are not preserved!
    PHY                                       ;|
    PHB                                       ;/
    PHK                                       ;
    PLB                                       ;
    SEP #$30                                  ; AXY->8
    LDA.W HW_RDNMI                            ; Read to clear the n flag.
    LDA.W SPCIO2                              ;\ If playing music in $1DFB, branch to load it.
    BNE +                                     ;/
    LDY.W HW_APUIO2                           ;\ 
    CPY.W LastUsedMusic                       ;| If $1DFF doesn't match the currently playing music, update the music.
    BNE ++                                    ;/
  + STA.W HW_APUIO2                           ;\ 
    STA.W LastUsedMusic                       ;| Keep the current sound playing, then mirror and clear $1DFB.
    STZ.W SPCIO2                              ;/
 ++ LDA.W SPCIO0                              ;\ 
    STA.W HW_APUIO0                           ;|
    LDA.W SPCIO1                              ;|
    STA.W HW_APUIO1                           ;|
    LDA.W SPCIO3                              ;| Update the remaining sound ports and clear mirrors.
    STA.W HW_APUIO3                           ;|
    STZ.W SPCIO0                              ;|
    STZ.W SPCIO1                              ;|
    STZ.W SPCIO3                              ;/
    LDA.B #!HW_DISP_FBlank                    ;\ Force blank.
    STA.W HW_INIDISP                          ;/
    STZ.W HW_HDMAEN                           ; Disable HDMA.
    LDA.B Layer12Window                       ;\ Update layer 1 and 2 window mask settings.
    STA.W HW_W12SEL                           ;/
    LDA.B Layer34Window                       ;\ Update layer 3 and 4 window mask settings.
    STA.W HW_W34SEL                           ;/
    LDA.B OBJCWWindow                         ;\ Update sprite and color window settings.
    STA.W HW_WOBJSEL                          ;/
    LDA.B ColorAddition                       ;\ Initial color addition settings.
    STA.W HW_CGSWSEL                          ;/
    LDA.W IRQNMICommand                       ;\ Check if a regular level.
    BPL RegularLevelNMI                       ;|
    JMP Mode7NMI                              ;/ Otherwise, go to mode 7 routines.

RegularLevelNMI:                              ;\ Set color math on all layers in $40 but 3.
    LDA.B ColorSettings                       ;|
    AND.B #~!HW_CMath_BG3                     ;/
    STA.W HW_CGADSUB                          ;\ Mode 1 with layer 3 priority.
    LDA.B #!HW_BG_BG3Pri|!HW_BG_Mode1         ;/
    STA.W HW_BGMODE                           ;\ 
    LDA.B LagFlag                             ;|
    BEQ +                                     ;| If the game is lagging, skip updating stuff like sprite OAM and controller data.
    LDA.W IRQNMICommand                       ;| If in a special level, skip updating layer positions too.
    LSR A                                     ;|
    BEQ NotSpecialLevelNMI                    ;/
    JMP SpecialLevelNMI                       ;

  + INC.B LagFlag                             ; Allow the game loop to run after NMI.
    JSR CODE_00A488                           ; Upload palette to CGRAM.
    LDA.W IRQNMICommand                       ;\\ 
    LSR A                                     ;|| Skip down if not either in a regular level, loading message (MARIO START), title screen, or castle cutscene.
    BNE CODE_008222                           ;|/
    BCS +                                     ;|\ Draw status bar if in a regular level.
    JSR DrawStatusBar                         ;|/
  + LDA.W CutsceneID                          ;|\ 
    CMP.B #!Cutscene_Credits                  ;||
    BNE CODE_008209                           ;||
    LDA.W CreditsUpdateBG                     ;|| Handle DMA for the background during the credits staff roll, if applicable.
    BEQ CODE_00821A                           ;||
    JSL CODE_0C9567                           ;||
    BRA CODE_00821A                           ;|/
CODE_008209:                                  ;|
    JSL UploadOneMap16Strip                   ;| Update Layer 1/2 tilemaps.
    LDA.W UploadMarioStart                    ;|\ 
    BEQ CODE_008217                           ;|| If set to do so, upload graphics for black screen messages (MARIO START/GAME OVER/TIME UP/etc).
    JSR CODE_00A7C2                           ;||  Then skip way down to the $12 tilemap handling.
    BRA CODE_00823D                           ;|/
CODE_008217:                                  ;|
    JSR CODE_00A390                           ;|
CODE_00821A:                                  ;|
    JSR CODE_00A436                           ;| Restore the tiles overwritten by the MARIO START! message, if applicable.
    JSR MarioGFXDMA                           ;| Handle DMA for the player/Yoshi/Podoboo tiles.
    BRA CODE_00823D                           ;/

CODE_008222:                                  ; On overworld.
    LDA.W OverworldProcess                    ;\\ 
    CMP.B #10                                 ;||
    BNE CODE_008237                           ;||
    LDY.W OWSubmapSwapProcess                 ;|| If switching between two submaps on the overworld,
    DEY #2                                    ;||  and currently updating Layer 1, do exactly that.
    CPY.B #$4                                 ;|| Then skip down to controller updating.
    BCS CODE_008237                           ;||
    JSR CODE_00A529                           ;||
    BRA +                                     ;|/
CODE_008237:                                  ;|
    JSR CODE_00A4E3                           ;| Upload overworld animated tile graphics and animated palettes.
    JSR MarioGFXDMA                           ;/ Handle DMA for the player/Yoshi/Podoboo tiles.
CODE_00823D:                                  ;
    JSR LoadScrnImage                         ; Upload tilemap data from $12.
    JSR DoSomeSpriteDMA                       ; Upload OAM.
  + JSR ControllerUpdate                      ; Get controller data.

NotSpecialLevelNMI:                           ; All paths rejoin.
    LDA.B Layer1XPos                          ;\ 
    STA.W HW_BG1HOFS                          ;|
    LDA.B Layer1XPos+1                        ;|
    STA.W HW_BG1HOFS                          ;|
    LDA.B Layer1YPos                          ;|
    CLC                                       ;| Upload Layer 1's position.
    ADC.W ScreenShakeYOffset                  ;|
    STA.W HW_BG1VOFS                          ;|
    LDA.B Layer1YPos+1                        ;|
    ADC.W ScreenShakeYOffset+1                ;|
    STA.W HW_BG1VOFS                          ;/
    LDA.B Layer2XPos                          ;\ 
    STA.W HW_BG2HOFS                          ;|
    LDA.B Layer2XPos+1                        ;|
    STA.W HW_BG2HOFS                          ;| Upload Layer 2's position.
    LDA.B Layer2YPos                          ;|
    STA.W HW_BG2VOFS                          ;|
    LDA.B Layer2YPos+1                        ;|
    STA.W HW_BG2VOFS                          ;/
    LDA.W IRQNMICommand
    BEQ CODE_008292
SpecialLevelNMI:
    LDA.B #!HW_TIMEN_NMI|!HW_TIMEN_JoyRead
    LDY.W CutsceneID
    CPY.B #8
    BNE NotCredits
    LDY.W Brightness
    STY.W HW_INIDISP
    LDY.W HDMAEnable
    STY.W HW_HDMAEN
    JMP IRQNMIEnding

CODE_008292:          
    LDY.B #!StatusBarHeight                   ;\ How many scanlines the status bar uses in general.
CODE_008294:                                  ;|
    LDA.W HW_TIMEUP                           ;|
    STY.W HW_VTIME                            ;| Enable IRQ #1 on this scanline, for the status bar.
    STZ.W HW_VTIME+1                          ;|
    STZ.B IRQType                             ;/
    LDA.B #!HW_TIMEN_NMI|!HW_TIMEN_JoyRead|!HW_TIMEN_IRQV
NotCredits:
    STA.W HW_NMITIMEN
    STZ.W HW_BG3HOFS
    STZ.W HW_BG3HOFS
    STZ.W HW_BG3VOFS
    STZ.W HW_BG3VOFS
    LDA.W Brightness
    STA.W HW_INIDISP
    LDA.W HDMAEnable
    STA.W HW_HDMAEN
    REP #$30
    PLB
    PLY
    PLX
    PLA
    PLP
I_EMPTY:
    RTI

Mode7NMI:                                     ; NMI for Mode 7 rooms.
    LDA.B LagFlag                             ;\ Branch if in a lag frame.
    BNE Mode7Lagging                          ;/
    INC.B LagFlag                             ;
    LDA.W UploadMarioStart                    ;\ 
    BEQ CODE_0082D4                           ;| If set to do so, upload tiles for the MARIO START/TIME UP/GAME OVER messages.
    JSR CODE_00A7C2                           ;|  Then skip down to drawing the status bar.
    BRA CODE_0082E8                           ;/
CODE_0082D4:
    JSR CODE_00A436                           ; Restore the tiles overwritten by the MARIO START! message, if applicable.
    JSR MarioGFXDMA                           ; Handle DMA for the player/Yoshi/Podoboo tiles.
    BIT.W IRQNMICommand                       ;\ 
    BVC CODE_0082E8                           ;|
    JSR CODE_0098A9                           ;|
    LDA.W IRQNMICommand                       ;| If in Reznor/Morton/Roy/Ludwig/Bowser's battles, upload their Mode 7 tilemaps and animate their lava.
    LSR A                                     ;| If in Iggy/Larry/Reznor/Morton/Roy/Ludwig's battles, draw the status bar.
    BCS +                                     ;|
CODE_0082E8:                                  ;|
    JSR DrawStatusBar                         ;/
  + JSR CODE_00A488                           ; Upload palette to CGRAM.
    JSR LoadScrnImage                         ; Upload tilemap data from $12.
    JSR DoSomeSpriteDMA                       ; Upload OAM.
    JSR ControllerUpdate                      ; Get controller data.

Mode7Lagging:                                 ; Transfer various RAM mirrors to the registers
    LDA.B #!HW_BG_BG3Pri|!HW_BG_Mode1
    STA.W HW_BGMODE
    LDA.B Mode7CenterX
    CLC
    ADC.B #$80
    STA.W HW_M7X
    LDA.B Mode7CenterX+1
    ADC.B #0
    STA.W HW_M7X
    LDA.B Mode7CenterY
    CLC
    ADC.B #$80
    STA.W HW_M7Y
    LDA.B Mode7CenterY+1
    ADC.B #0
    STA.W HW_M7Y
    LDA.B Mode7ParamA
    STA.W HW_M7A
    LDA.B Mode7ParamA+1
    STA.W HW_M7A
    LDA.B Mode7ParamB
    STA.W HW_M7B
    LDA.B Mode7ParamB+1
    STA.W HW_M7B
    LDA.B Mode7ParamC
    STA.W HW_M7C
    LDA.B Mode7ParamC+1
    STA.W HW_M7C
    LDA.B Mode7ParamD
    STA.W HW_M7D
    LDA.B Mode7ParamD+1
    STA.W HW_M7D
    JSR SETL1SCROLL
    LDA.W IRQNMICommand                       ;\ 
    LSR A                                     ;| Branch if not in Bowser's room.
    BCC +                                     ;/
    LDA.W Brightness
    STA.W HW_INIDISP
    LDA.W HDMAEnable
    STA.W HW_HDMAEN
    LDA.B #!HW_TIMEN_NMI|!HW_TIMEN_JoyRead    ;\ Skip the status bar IRQ and immediately prepare the registers after.
    JMP CODE_0083F3                           ;/
                                              ; Not in Bowser's room.
  + LDY.B #!StatusBarHeight                   ;\ Scanline the status bar ends at in Iggy/Larry/Ludwig/Reznor's rooms.
    BIT.W IRQNMICommand                       ;|
    BVC +                                     ;|
    LDA.W ActiveBoss                          ;| 
    ASL A                                     ;|
    TAX                                       ;|
    LDA.W BossCeilingHeights,X                ;|
    CMP.B #!RoyMortonCeilingHeight            ;|
    BNE +                                     ;|
    LDY.B #!StatusBarHeight+9                 ;/ Scanline the status bar ends at in Morton/Roy's rooms.
  + JMP CODE_008294                           ; Prepare IRQ, and set up a couple more registers.

I_IRQ:                                        ; IRQ routine.
    SEI                                       ; Set Interrupt flag so routine can start
    PHP                                       ;\ Save A/X/Y/P/B
    REP #$30                                  ;| AXY->16
    PHA                                       ;|
    PHX                                       ;|
    PHY                                       ;|
    PHB                                       ;|
    PHK                                       ;|
    PLB                                       ;/ Set B to $00
    SEP #$30                                  ; AXY->8
    LDA.W HW_TIMEUP                           ; Read the IRQ register, 'unapply' the interrupt
    BPL ExitIRQ                               ; If "Timer IRQ" is clear, skip the next code block
    LDA.B #!HW_TIMEN_NMI|!HW_TIMEN_JoyRead
    LDY.W IRQNMICommand
    BMI CODE_0083BA                           ; If Bit 7 (negative flag) is set, branch to a different IRQ mode
IRQNMIEnding:
    STA.W HW_NMITIMEN                         ; Enable NMI Interrupt and Automatic Joypad reading
    LDY.B #31
    JSR WaitForHBlank
    LDA.B Layer3XPos                          ;\ Adjust scroll settings for layer 3
    STA.W HW_BG3HOFS                          ;|
    LDA.B Layer3XPos+1                        ;|
    STA.W HW_BG3HOFS                          ;|
    LDA.B Layer3YPos                          ;|
    STA.W HW_BG3VOFS                          ;|
    LDA.B Layer3YPos+1                        ;|
    STA.W HW_BG3VOFS                          ;/
CODE_0083A8:
    LDA.B MainBGMode                          ;\ Set the layer BG sizes, L3 priority, and BG mode
    STA.W HW_BGMODE                           ;/ (Effectively, this is the screen mode)
    LDA.B ColorSettings                       ;\ Write CGADSUB
    STA.W HW_CGADSUB                          ;/
ExitIRQ:
    REP #$30                                  ; AXY->16
    PLB                                       ;\ Pull everything back
    PLY                                       ;|
    PLX                                       ;|
    PLA                                       ;|
    PLP                                       ;/
    RTI                                       ; And Return

CODE_0083BA:
    BIT.W IRQNMICommand                       ; Get bit 6 of $0D9B
    BVC CODE_0083E3                           ; If clear, skip the next code section
    LDY.B IRQType                             ;\ Skip if $11 = 0
    BEQ CODE_0083D0                           ;/
    STA.W HW_NMITIMEN                         ; #$81 -> NMI / Controller Enable reg
    LDY.B #20
    JSR WaitForHBlank
    JSR SETL1SCROLL
    BRA CODE_0083A8
CODE_0083D0:
    INC.B IRQType                             ; $11++
    LDA.W HW_TIMEUP                           ;\ Set up the IRQ routine for layer 3
    LDA.B #!BossFloorHeight                   ;|\ <- Scanline where floor starts in Morton/Roy/Ludwig battles
    SEC                                       ;|| Vertical Counter trigger at 174 - $1888
    SBC.W ScreenShakeYOffset                  ;|/ Oddly enough, $1888 seems to be 16-bit, but the
    STA.W HW_VTIME                            ;| Store to Vertical Counter Timer
    STZ.W HW_VTIME+1                          ;/ Make the high byte of said timer 0
    LDA.B #!HW_TIMEN_NMI|!HW_TIMEN_JoyRead|!HW_TIMEN_IRQV
CODE_0083E3:
    LDY.W EndLevelTimer                       ; if $1493 = 0 skip down
    BEQ CODE_0083F3                           ;
    LDY.W ColorFadeTimer                      ;\ If $1495 is <#$40
    CPY.B #2*!PaletteFadeCount                ;|
    BCC CODE_0083F3                           ;/ Skip down
    LDA.B #!HW_TIMEN_NMI|!HW_TIMEN_JoyRead    ;
    BRA IRQNMIEnding                          ; Jump up to IRQNMIEnding

CODE_0083F3:                                  ; IRQ done; wait for H-blank, then update registers.
    STA.W HW_NMITIMEN                         ;
    JSR WaitLongForHBlank                     ; Wait until we enter an H-blank, then update the registers.
    NOP
    NOP
    LDA.B #!HW_BG_Mode7
    STA.W HW_BGMODE
    LDA.B Mode7XPos
    STA.W HW_BG1HOFS
    LDA.B Mode7XPos+1
    STA.W HW_BG1HOFS
    LDA.B Mode7YPos
    STA.W HW_BG1VOFS
    LDA.B Mode7YPos+1
    STA.W HW_BG1VOFS
    BRA ExitIRQ

SETL1SCROLL:
    LDA.B #(VRam_L1Mode7Tilemap>>8)|!HW_BGSC_Size_64x32
    STA.W HW_BG1SC
    LDA.B #VRam_L1Mode7Tiles>>12
    STA.W HW_BG12NBA
    LDA.B Layer1XPos
    STA.W HW_BG1HOFS
    LDA.B Layer1XPos+1
    STA.W HW_BG1HOFS
    LDA.B Layer1YPos
    CLC
    ADC.W ScreenShakeYOffset
    STA.W HW_BG1VOFS
    LDA.B Layer1YPos+1
    STA.W HW_BG1VOFS
    RTS

WaitLongForHBlank:                            ; Subroutine to wait for a horizontal interrupt.
  - LDY.B #32                                 ;\
WaitForHBlank:                                ;|
    BIT.W HW_HVBJOY                           ;| If in one already, wait for it to end.
    BVS -                                     ;/
  - BIT.W HW_HVBJOY                           ;\ Wait until the next H-blank fires.
    BVC -                                     ;/
  - DEY                                       ;\ Wait until we are far enough into the blank.
    BNE -                                     ;/
    RTS                                       ;

DoSomeSpriteDMA:                              ; Routine to upload sprite OAM to the registers.
    STZ.W HW_DMAPARAM                         ; Use DMA channel 0; increment, one register write once.
    REP #$20                                  ; A->16
    STZ.W HW_OAMADD                           ; Clear the sprite OAM index.
    LDA.W #(OAMMirror<<8)|(HW_OAMDATA&$FF)    ;\ 
    STA.W HW_DMAREG                           ;| Set channel 0's destination to $2104 (data for OAM write)
    LDA.W #OAMMirror>>8                       ;| and the source to $000200 (OAM table).
    STA.W HW_DMAADDR+1                        ;/
    LDA.W #4*!OBJCount+!OBJCount/4            ;\ Set the size to be 544 bytes.
    STA.W HW_DMACNT                           ;/
    LDY.B #!Ch0                               ;\ Begin DMA transfer on channel 0.
    STY.W HW_MDMAEN                           ;/
    SEP #$20                                  ; A->8
    LDA.B #!HW_OAM_SetPriority                ;\ Set OAM object priority bit.
    STA.W HW_OAMADD+1                         ;/
    LDA.B OAMAddress                          ;\ Set OAM index to $3F.
    STA.W HW_OAMADD                           ;/
    RTS


OAMTileSizeOffsets:                           ; Indices to $0420 for upload to the OAM table.
    dw 0, 8, 16, 24, 32, 40, 48, 56           ; only even bytes are actually used.
    dw 64, 72, 80, 88, 96, 104, 112
    db 120

ConsolidateOAM:                               ; Routine to upload OAM tile sizes ($0420) to the OAM table (at $0400).
    LDY.B #!OBJCount/4-2                      ;
  - LDX.W OAMTileSizeOffsets,Y                ;\ 
    LDA.W OAMTileSize+3,X                     ;|
    ASL #2                                    ;|
    ORA.W OAMTileSize+2,X                     ;|
    ASL #2                                    ;| Turn four tile size bytes into one and store to the OAM table.
    ORA.W OAMTileSize+1,X                     ;|
    ASL #2                                    ;|
    ORA.W OAMTileSize,X                       ;|
    STA.W OAMTileBitSize,Y                    ;/
    LDA.W OAMTileSize+7,X                     ;\ 
    ASL #2                                    ;|
    ORA.W OAMTileSize+6,X                     ;|
    ASL #2                                    ;| And four more. Minimal loops yo.
    ORA.W OAMTileSize+5,X                     ;|
    ASL #2                                    ;|
    ORA.W OAMTileSize+4,X                     ;|
    STA.W OAMTileBitSize+1,Y                  ;/
    DEY #2                                    ;\ If not at the end of the table, loop.
    BPL -                                     ;/
    RTS                                       ;

if ver_is_english(!_VER)                      ;\=============== U, SS, E0, & E1 ===============
CODE_0084C8:                                  ;! Wrapper to draw stripe image
    PHB                                       ;! This is not used in the J version:
    PHK                                       ;! - Used to change enemy names in the credits after
    PLB                                       ;!   special world is beaten in English verisons.
    JSR LoadScrnImage                         ;! - Used to clear layer 1/2 tilemaps before every
    PLB                                       ;!   level load in the E1 version.
    RTL                                       ;!
endif                                         ;/===============================================

StripeImages:                                 ; Stripe image data pointer. Indexed by $12.
    dl DynamicStripeImage                     ; 00 - Pointer to dynamic stripe image loader
    dl TitleScreenStripe                      ; 03 - Title screen
    dl OWBorderStripe                         ; 06 - Overworld border
    dl ClearMessageStripe                     ; 09 - Blank space to clear a message box
    dl ContinueEndStripe                      ; 0C - CONTINUE/END
    dl LudwigCutBGStripe                      ; 0F - Ludwig Castle Cutscene BG
    dl PlayerSelectStripe                     ; 12 - 1 PLAYER GAME/2 PLAYER GAME
    dl OWScrollArrowStripe                    ; 15 - OW scroll arrows
    dl OWScrollEraseStripe                    ; 18 - Remove OW scroll arrows
    dl ClearOWBoxStripe                       ; 1B - Blank space to clear overworld boxes
    dl ContinueSaveStripe                     ; 1E - CONTINUE AND SAVE
    
CutMessageStripes:                            ;
if ver_is_japanese(!_VER)                     ;\====================== J ======================
    dl C1Message4Stripe                       ;! 21 - Castle 1, Line 4: tabidatsunodearimashita.
    dl C1Message3Stripe                       ;! 24 - Castle 1, Line 3: nisareta nakamaotasukedashi doonatsuheiyae
    dl C1Message2Stripe                       ;! 27 - Castle 1, Line 2: taoshita mariotachiwa kuppanomahoude tamago
    dl C1Message1Stripe                       ;! 2A - Castle 1, Line 1: Yoosutaatouno oshirode saishonokokuppao
    dl C2Message4Stripe                       ;! 2D - Castle 2, Line 4: eteiruka? piichihimenounmeiya ikani!?
    dl C2Message3Stripe                       ;! 30 - Castle 2, Line 3: hetosusundeiku!konosaki donnawanagamachikama
    dl C2Message2Stripe                       ;! 33 - Castle 2, Line 2: doonatsuheiyakara chikanosekaino baniradoomu
    dl C2Message1Stripe                       ;! 36 - Castle 2, Line 1: mariotachiwa nibanmenokokuppamo yattsukete
    dl C3Message4Stripe                       ;! 39 - Castle 3, Line 4: shitara donnatabini narunodearouka!
    dl C3Message3Stripe                       ;! 3C - Castle 3, Line 3: moshimo midoriyaakanosuitchio totteinaito
    dl C3Message2Stripe                       ;! 3F - Castle 3, Line 2: hotto hitoiki. shikashikoosuwa kewashikunaru
    dl C3Message1Stripe                       ;! 42 - Castle 3, Line 1: mariotachiwa sanbanmenokokuppamo yattsukete
    dl C4Message4Stripe                       ;! 45 - Castle 4, Line 4: ginomori!hatashitemorionukerukotogadekirunoka?
    dl C4Message3Stripe                       ;! 48 - Castle 4, Line 3: nazootokanaito derukotogadekinaitoiu fushi
    dl C4Message2Stripe                       ;! 4B - Castle 4, Line 2: tachiwa korekara mayoinomorinihaitteiku!?
    dl C4Message1Stripe                       ;! 4E - Castle 4, Line 1: yonbanmenokokuppamo nantokakuriaa mario
    dl C5Message4Stripe                       ;! 51 - Castle 5, Line 4: pai. tsuginarutatakaino hojimarihajimarii!
    dl C5Message3Stripe                       ;! 54 - Castle 5, Line 3: chokoreetouwa nazonokoosuto doragondeip
    dl C5Message2Stripe                       ;! 57 - Castle 5, Line 2: to morionukerukotogadekita. daga konosakino
    dl C5Message1Stripe                       ;! 5A - Castle 5, Line 1: mariotachiwa gobanmenokokuppaoyattsuke yat
    dl C6Message4Stripe                       ;! 5D - Castle 6, Line 4: izoge mario! ganbare ruiji!
    dl C6Message3Stripe                       ;! 60 - Castle 6, Line 3: iriguchiohirakutameno kagigaarurashii.
    dl C6Message2Stripe                       ;! 63 - Castle 6, Line 2: konosakino chinbotsusenniwa kuppanotanino
    dl C6Message1Stripe                       ;! 66 - Castle 6, Line 1: rokubanmenokokuppaotaoshitamariotachi!
    dl C7Message4Stripe                       ;! 69 - Castle 7, Line 4: randoniheiwaotorimodosukotogadekirunoka?
    dl C7Message3Stripe                       ;! 6C - Castle 7, Line 3: bujinipiichihimeotasukedashi konokyouryuu
    dl C7Message2Stripe                       ;! 6F - Castle 7, Line 2: piichihimega torawareteiru kuppajounomi
    dl C7Message1Stripe                       ;! 72 - Castle 7, Line 1: tsuini saigonokokuppaotaoshita! nokosuwa
else                                          ;<================ U, SS, E0, & E1 ==============
    dl BlankStripe                            ;! 21 - Castle 1, Line 8: *empty*
    dl C1Message7Stripe                       ;! 24 - Castle 1, Line 7: travel to Donut Land.
    dl C1Message6Stripe                       ;! 27 - Castle 1, Line 6: Together, they now
    dl C1Message5Stripe                       ;! 2A - Castle 1, Line 5: still trapped in an egg.
    dl C1Message4Stripe                       ;! 2D - Castle 1, Line 4: Yoshi's friend who is
    dl C1Message3Stripe                       ;! 30 - Castle 1, Line 3: castle #1 and rescued
    dl C1Message2Stripe                       ;! 33 - Castle 1, Line 2: demented Iggy Koopa in
    dl C1Message1Stripe                       ;! 36 - Castle 1, Line 1: Mario has defeated the
    dl C2Message8Stripe                       ;! 39 - Castle 2, Line 8: Princess Toadstool?
    dl C2Message7Stripe                       ;! 3C - Castle 2, Line 7: What will become of
    dl C2Message6Stripe                       ;! 3F - Castle 2, Line 6: Mario in this new world?
    dl C2Message5Stripe                       ;! 42 - Castle 2, Line 5: Dome. What traps await
    dl C2Message4Stripe                       ;! 45 - Castle 2, Line 4: the underground Vanilla
    dl C2Message3Stripe                       ;! 48 - Castle 2, Line 3: memory. The next area is
    dl C2Message2Stripe                       ;! 4B - Castle 2, Line 2: castle #2 is now just a
    dl C2Message1Stripe                       ;! 4E - Castle 2, Line 1: Morton Koopa Jr. of
    dl BlankStripe                            ;! 51 - Castle 3, Line 8: *empty*
    dl C3Message7Stripe                       ;! 54 - Castle 3, Line 7: Green Switches yet?
    dl C3Message6Stripe                       ;! 57 - Castle 3, Line 6: you found the Red and
    dl C3Message5Stripe                       ;! 5A - Castle 3, Line 5: more difficult. Have
    dl C3Message4Stripe                       ;! 5D - Castle 3, Line 4: starting to get much
    dl C3Message3Stripe                       ;! 60 - Castle 3, Line 3: #3. Mario's quest is
    dl C3Message2Stripe                       ;! 63 - Castle 3, Line 2: Lemmy Koopa of castle
    dl C3Message1Stripe                       ;! 66 - Castle 3, Line 1: Mario has triumphed over
    dl C4Message8Stripe                       ;! 69 - Castle 4, Line 8: this perplexing forest.
    dl C4Message7Stripe                       ;! 6C - Castle 4, Line 7: to solve the puzzle of
    dl C4Message6Stripe                       ;! 6F - Castle 4, Line 6: Mario must use his brain
    dl C4Message5Stripe                       ;! 72 - Castle 4, Line 5: Illusion lies ahead.
    dl C4Message4Stripe                       ;! 75 - Castle 4, Line 4: are over. The Forest of
    dl C4Message3Stripe                       ;! 78 - Castle 4, Line 3: symphonies in castle #4
    dl C4Message2Stripe                       ;! 7B - Castle 4, Line 2: of composing Koopa
    dl C4Message1Stripe                       ;! 7E - Castle 4, Line 1: Ludwig von Koopa's days
    dl BlankStripe                            ;! 81 - Castle 5, Line 8: *empty*
    dl C5Message7Stripe                       ;! 84 - Castle 5, Line 7: tasty) Chocolate Island!
    dl C5Message6Stripe                       ;! 87 - Castle 5, Line 6: the dangerous (but
    dl C5Message5Stripe                       ;! 8A - Castle 5, Line 5: castle #5. Onward to
    dl C5Message4Stripe                       ;! 8D - Castle 5, Line 4: end to Roy Koopa of
    dl C5Message3Stripe                       ;! 90 - Castle 5, Line 3: Illusion and has put an
    dl C5Message2Stripe                       ;! 93 - Castle 5, Line 2: through the Forest of
    dl C5Message1Stripe                       ;! 96 - Castle 5, Line 1: Mario found his way
    dl C6Message8Stripe                       ;! 99 - Castle 6, Line 8: to the Valley of Bowser.
    dl C6Message7Stripe                       ;! 9C - Castle 6, Line 7: appears to be a gateway
    dl C6Message6Stripe                       ;! 9F - Castle 6, Line 6: is a sunken ship that
    dl C6Message5Stripe                       ;! A2 - Castle 6, Line 5: now before him. There
    dl C6Message4Stripe                       ;! A5 - Castle 6, Line 4: the challenge that is
    dl C6Message3Stripe                       ;! A8 - Castle 6, Line 3: song. Mario must meet
    dl C6Message2Stripe                       ;! AB - Castle 6, Line 2: #6 has sung her last
    dl C6Message1Stripe                       ;! AE - Castle 6, Line 1: Wendy O. Koopa in castle
    dl C7Message8Stripe                       ;! B1 - Castle 7, Line 8: Dinosaur Land?
    dl C7Message7Stripe                       ;! B4 - Castle 7, Line 7: restore peace to
    dl C7Message6Stripe                       ;! B7 - Castle 7, Line 6: Can Mario rescue her and
    dl C7Message5Stripe                       ;! BA - Castle 7, Line 5: Toadstool is being held.
    dl C7Message4Stripe                       ;! BD - Castle 7, Line 4: Castle where Princess
    dl C7Message3Stripe                       ;! C0 - Castle 7, Line 3: that is left is Bowser's
    dl C7Message2Stripe                       ;! C3 - Castle 7, Line 2: Koopa in castle #7. All
    dl C7Message1Stripe                       ;! C6 - Castle 7, Line 1: Mario has defeated Larry
endif                                         ;/===============================================

OtherStripes:
    dl LemmyCutBGStripe                       ; J75/UC9 - Lemmy, Larry Castle Cutscene BG
    dl WendyCutBGStripe                       ; J78/UCC - Wendy Castle Cutscene BG
    dl CutsceneCastleStripe                   ; J7B/UCF - Castle Cutscene Castle
    dl EraseAllStripe                         ; J7E/UD2 - Blank space to clear all of layers 1 and 2
    dl TheEndStripe                           ; J81/UD5 - Ending: THE END
    dl EnemyNameStripe00                      ; J84/UD8 - Ending: Enemies: Lakitu
    dl EnemyNameStripe01                      ; J87/UDB - Ending: Enemies: Hammer Bro.
    dl EnemyNameStripe02                      ; J8A/UDE - Ending: Enemies: Pokey
    dl EnemyNameStripe03                      ; J8D/UE1 - Ending: Enemies: Rex
    dl EnemyNameStripe04                      ; J90/UE4 - Ending: Enemies: Dino-Rhino
    dl EnemyNameStripe05                      ; J93/UE7 - Ending: Enemies: Blargg
    dl EnemyNameStripe06                      ; J96/UEA - Ending: Enemies: Urchin
    dl EnemyNameStripe07                      ; J99/UED - Ending: Enemies: Boo
    dl EnemyNameStripe08                      ; J9C/UF0 - Ending: Enemies: Dry Bones
    dl EnemyNameStripe09                      ; J9F/UF3 - Ending: Enemies: Grinder
    dl EnemyNameStripe0A                      ; JA2/UF6 - Ending: Enemies: Reznor
    dl EnemyNameStripe0B                      ; JA5/UF9 - Ending: Enemies: Mechakoopa
    dl EnemyNameStripe0C                      ; JA8/UFC - Ending: Enemies: Bowser
    dl IggyCutBGStripe                        ; JAB/UFF - Iggy, Morton, Roy Castle Cutscene BG

LoadScrnImage:                                ; Routine to upload a stripe image to VRAM (usually layer 3).
    LDY.B StripeImage
    LDA.W StripeImages,Y
    STA.B _0
    LDA.W StripeImages+1,Y
    STA.B _1
    LDA.W StripeImages+2,Y
    STA.B _2
    JSR LoadStripeImage
    LDA.B StripeImage
    BNE +
    STA.L DynStripeImgSize
    STA.L DynStripeImgSize+1
    DEC A
    STA.L DynamicStripeImage
  + STZ.B StripeImage                         ; Do not reload the same thing next frame
    RTS

ClearOutLayer3:                               ; DMA upload routine to clean out the layer 3 tilemap.
    JSR TurnOffIO                             ;
    LDA.B #!EmptyTile                         ;\ Tile to use as the blank tile.
    STA.B _0                                  ;/
    STZ.W HW_VMAINC                           ;] Single byte VRAM upload.
    STZ.W HW_VMADD                            ;\ 
    LDA.B #VRam_L3Tilemap>>8                  ;| Upload tilemap to Layer 3.
    STA.W HW_VMADD+1                          ;/
    LDX.B #6                                  ;\ Set up and enable DMA on channel 1.
  - LDA.W ClearTilemapDMAData,X               ;| $4310: Fixed transfer, one register write once.
    STA.W HW_DMAPARAM+$10,X                   ;| $4311: Destination is $2118 (VRAM low byte).
    DEX                                       ;| $4312: Source is $000000.
    BPL -                                     ;| $4315: Write x1000 bytes.
    LDY.B #!Ch1                               ;|
    STY.W HW_MDMAEN                           ;/
    LDA.B #!EmptyTile>>8                      ;\ YXPCCCTT to use for the blank tile.
    STA.B _0                                  ;/
    LDA.B #!HW_VINC_IncOnHi                   ;\ Two byte VRAM upload.
    STA.W HW_VMAINC                           ;/
    STZ.W HW_VMADD                            ;\ 
    LDA.B #VRam_L3Tilemap>>8                  ;| Upload tilemap to Layer 3.
    STA.W HW_VMADD+1                          ;/
    LDX.B #6                                  ;\ 
  - LDA.W ClearTilemapDMAData,X               ;| Set up and enable DMA on channel 1.
    STA.W HW_DMAPARAM+$10,X                   ;| Settings are the same as the previous one.
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #HW_VMDATA+1                        ;|\ Change destination to $2119 (VRAM high byte).
    STA.W HW_DMAREG+$10                       ;|/
    STY.W HW_MDMAEN                           ;/
    STZ.B OAMAddress                          ; Clear the current OAM address.
    JSL OAMResetRoutine                       ;\ Clear OAM data.
    JMP DoSomeSpriteDMA                       ;/


ClearTilemapDMAData:                          ; DMA setting data for channel 1; $4310-$4316, in reverse order.
    %DMASettings(!HW_DMA_ABusFix,HW_VMDATA,0,$1000)

ControllerUpdate:                             ; Routine to read controller data and upload to $15-$18. Part of NMI.
    LDA.W HW_CNTRL1                           ;\\  
    AND.B #!ButA|!ButX|!ButL|!ButR            ;|| Get controller 1 data 2.
    STA.W axlr0000P1Hold                      ;|/
    TAY                                       ;|\ 
    EOR.W axlr0000P1Mask                      ;|| Get controller 1 data 2, one frame.
    AND.W axlr0000P1Hold                      ;||
    STA.W axlr0000P1Frame                     ;||
    STY.W axlr0000P1Mask                      ;//
    LDA.W HW_CNTRL1+1                         ;\\ Get controller 1 data 1. 
    STA.W byetudlrP1Hold                      ;|/
    TAY                                       ;|\ 
    EOR.W byetudlrP1Mask                      ;|| Get controller 1 data 1, one frame.
    AND.W byetudlrP1Hold                      ;||
    STA.W byetudlrP1Frame                     ;||
    STY.W byetudlrP1Mask                      ;//
    LDA.W HW_CNTRL2                           ;\\ 
    AND.B #!ButA|!ButX|!ButL|!ButR            ;|| Get controller 2 data 2.
    STA.W axlr0000P2Hold                      ;|/
    TAY                                       ;|\ 
    EOR.W axlr0000P2Mask                      ;|| Get controller 2 data 2, one frame.
    AND.W axlr0000P2Hold                      ;||
    STA.W axlr0000P2Frame                     ;||
    STY.W axlr0000P2Mask                      ;//
    LDA.W HW_CNTRL2+1                         ;\\ Get controller 2 data 1. 
    STA.W byetudlrP2Hold                      ;|/
    TAY                                       ;|\ 
    EOR.W byetudlrP2Mask                      ;|| Get controller 2 data 1, one frame.
    AND.W byetudlrP2Hold                      ;||
    STA.W byetudlrP2Frame                     ;||
    STY.W byetudlrP2Mask                      ;//
    LDX.W ControllersPresent                  ;\ 
    BPL +                                     ;| If $0DA0 is set to use separate controllers, use the current player number as the controller port to accept input from.
    LDX.W PlayerTurnLvl                       ;/
  + LDA.W axlr0000P1Hold,X                    ;\ 
    AND.B #!ButA|!ButX                        ;| Set up $15, sharing the top two bits of controller data 2 (for A/X).
    ORA.W byetudlrP1Hold,X                    ;|
    STA.B byetudlrHold                        ;/
    LDA.W axlr0000P1Hold,X                    ;\ Set up $17.
    STA.B axlr0000Hold                        ;/
    LDA.W axlr0000P1Frame,X                   ;\ 
    AND.B #!ButX                              ;| Set up $16, sharing the top two bits of controller data 2 (for A/X).
    ORA.W byetudlrP1Frame,X                   ;|
    STA.B byetudlrFrame                       ;/
    LDA.W axlr0000P1Frame,X                   ;\ Set up $18.
    STA.B axlr0000Frame                       ;/
    RTS                                       ;

InitM7BossOAM:                                ; Subroutine to initialize OAM in Roy/Morton/Ludwig's rooms.
    REP #$30                                  ; AXY->16
    LDX.W #!BossBGOBJCount-2                  ;\
    LDA.W #!OBJBigSize|(!OBJBigSize<<8)       ;|
  - STA.W OAMTileSize,X                       ;| Initialize first 100 OBJs as 16x16.
    DEX #2                                    ;|
    BPL -                                     ;/ 
    SEP #$30                                  ; AXY->8
    LDA.B #!OBJOffscreen                      ;\ Clear out OAM.
    JSL OAMResetRoutine+302                   ;/
    RTS                                       ;

ExecutePtr:                                   ; Routine to jump to a 16-bit address in a table. Basically JSR (addr,a). A contains the index to jump to.
    STY.B _3                                  ; "Push" Y
    PLY
    STY.B _0
    REP #$30                                  ; AXY->16
    AND.W #%0000000011111111
    ASL A
    TAY
    PLA
    STA.B _1
    INY
    LDA.B [_0],Y
    STA.B _0
    SEP #$30                                  ; AXY->8
    LDY.B _3                                  ; "Pull" Y
    JML.W [_0]

ExecutePtrLong:                               ; Routine to jump to a 24-bit address in a table. Basically JSL (long,a).
    STY.B _5
    PLY
    STY.B _2
    REP #$30                                  ; AXY->16
    AND.W #%0000000011111111
    STA.B _3
    ASL A
    ADC.B _3
    TAY
    PLA
    STA.B _3
    INY
    LDA.B [_2],Y
    STA.B _0
    INY
    LDA.B [_2],Y
    STA.B _1
    SEP #$30                                  ; AXY->8
    LDY.B _5
    JML.W [_0]

LoadStripeImage:                              ; Subroutine to upload a specific Layer 3 tilemap (pointer in $00) to VRAM.
    REP #$10                                  ; XY->16
    STA.W HW_DMAADDR+2+$10                    ;
    LDY.W #0                                  ;
  - LDA.B [_0],Y                              ;\ Branch if bit 7 isn't set (i.e. end of data).
    BPL +                                     ;/
    SEP #$30                                  ; AXY->8
    RTS                                       ;
                                              ;
  + STA.B _4                                  ;\ 
    INY                                       ;|
    LDA.B [_0],Y                              ;|
    STA.B _3                                  ;| $03/$04 = VRAM destination
    INY                                       ;| $07 = direction (0 = horz, 1 = vert)
    LDA.B [_0],Y                              ;|
    STZ.B _7                                  ;|
    ASL A                                     ;|
    ROL.B _7                                  ;/
    LDA.B #HW_VMDATA                          ;\ Set register to $2118.
    STA.W HW_DMAREG+$10                       ;/
    LDA.B [_0],Y                              ;\ 
    AND.B #%01000000                          ;|
    LSR #3                                    ;| Enable RLE if applicable.
    STA.B _5                                  ;|
    STZ.B _6                                  ;|
    ORA.B #!HW_DMA_2Byte2Addr                 ;|
    STA.W HW_DMAPARAM+$10                     ;/
    REP #$20                                  ; A->16
    LDA.B _3                                  ;\ Set destination.
    STA.W HW_VMADD                            ;/
    LDA.B [_0],Y                              ;\ 
    XBA                                       ;|
    AND.W #%0011111111111111                  ;|
    TAX                                       ;|
    INX                                       ;|
    INY #2                                    ;| Set data source and length.
    TYA                                       ;|
    CLC                                       ;|
    ADC.B _0                                  ;|
    STA.W HW_DMAADDR+$10                      ;|
    STX.W HW_DMACNT+$10                       ;/
    LDA.B _5                                  ;\ 
    BEQ +                                     ;|
    SEP #$20                                  ;| A->8
    LDA.B _7                                  ;|
    STA.W HW_VMAINC                           ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;|
    LDA.B #HW_VMDATA+1                        ;|
    STA.W HW_DMAREG+$10                       ;| Set up RLE if applicable.
    REP #$21                                  ;| A->16, CLC
    LDA.B _3                                  ;|
    STA.W HW_VMADD                            ;|
    TYA                                       ;|
    ADC.B _0                                  ;|
    INC A                                     ;|
    STA.W HW_DMAADDR+$10                      ;|
    STX.W HW_DMACNT+$10                       ;/
    LDX.W #2                                  ;
  + STX.B _3                                  ;
    TYA                                       ;
    CLC                                       ;
    ADC.B _3                                  ;
    TAY                                       ;
    SEP #$20                                  ; A->8
    LDA.B _7                                  ;\ 
    ORA.B #!HW_VINC_IncOnHi                   ;| Set direction.
    STA.W HW_VMAINC                           ;/
    LDA.B #!Ch1                               ;\ Enable DMA on channel 1.
    STA.W HW_MDMAEN                           ;/
    JMP -                                     ;

UploadOneMap16Strip:                          ; DMA routine to upload one row/column of Map16 data to VRAM for Layer 1/2.
    SEP #$30                                  ; AXY->8
    LDA.W Layer1VramAddr                      ;\ 
    BNE +                                     ;| If $1BE4 is non-zero, update Layer 1. Else, skip to Layer 2.
    JMP UploadL2Map16Strip                    ;/
 
  + LDA.B ScreenMode                          ;\ Need to update Layer 1.
    AND.B #!ScrMode_Layer1Vert                ;| Jump down if in a vertical level.
    BEQ UploadOneL1Column                     ;|
    JMP UploadOneL1Row                        ;/

UploadOneL1Column:
    LDY.B #!HW_VINC_IncOnHi|!HW_VINC_IncBy32  ;\ Updating horizontal Layer 1.
    STY.W HW_VMAINC                           ;| Upload the top-left column of tiles.
    LDA.W Layer1VramAddr+1                    ;|\ 
    STA.W HW_VMADD                            ;|| Set VRAM address to write to.
    LDA.W Layer1VramAddr                      ;||
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer1Map16DMAData,X                ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;|
    STY.W HW_VMAINC                           ;/
    LDA.W Layer1VramAddr+1                    ;\ Upload the bottom-left column of tiles.
    STA.W HW_VMADD                            ;|\ 
    LDA.W Layer1VramAddr                      ;||
    CLC                                       ;|| Set VRAM address to write to (1 screen below origin).
    ADC.B #(2*!TilesPerBGPage)>>8             ;|| One screen below = 2 screens forward
    STA.W HW_VMADD+1                          ;||
    LDX.B #6                                  ;|/
  - LDA.W Layer1Map16DMAData+7,X              ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;|
    STY.W HW_VMAINC                           ;/
    LDA.W Layer1VramAddr+1                    ;\ Upload the rop-right column of tiles.
    INC A                                     ;|\ 
    STA.W HW_VMADD                            ;||
    LDA.W Layer1VramAddr                      ;|| Set VRAM address to write to (1 tile right of origin).
    STA.W HW_VMADD+1                          ;|| One tile right = 1 word forward
    LDX.B #6                                  ;|/
  - LDA.W Layer1Map16DMAData+2*7,X            ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;|
    STY.W HW_VMAINC                           ;/
    LDA.W Layer1VramAddr+1                    ;\ Upload the bottom-right column of tiles.
    INC A                                     ;|\ 
    STA.W HW_VMADD                            ;||
    LDA.W Layer1VramAddr                      ;||
    CLC                                       ;|| Set VRAM address to write to (1 screen below, 1 tile right of origin).
    ADC.B #(2*!TilesPerBGPage)>>8             ;|| One screen below & one tile right = 2 screens & 1 word forward
    STA.W HW_VMADD+1                          ;||
    LDX.B #6                                  ;|/
  - LDA.W Layer1Map16DMAData+3*7,X            ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    JMP UploadL2Map16Strip                    ; Done with Layer 1, skip down to handle Layer 2.

UploadOneL1Row:                               ; Updating vertical Layer 1.
    LDY.B #!HW_VINC_IncOnHi                   ;\ 
    STY.W HW_VMAINC                           ;| Upload the top-left row of tiles.
    LDA.W Layer1VramAddr+1                    ;|\ 
    STA.W HW_VMADD                            ;|| Set VRAM address to write to.
    LDA.W Layer1VramAddr                      ;||
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer1Map16DMAData,X                ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    STY.W HW_VMAINC                           ;\ Upload the top-right row of tiles.
    LDA.W Layer1VramAddr+1                    ;|\ 
    STA.W HW_VMADD                            ;||
    LDA.W Layer1VramAddr                      ;|| Set VRAM address to write to (1 screen right of origin).
    CLC                                       ;|| One screen right = 1 screen forward
    ADC.B #!TilesPerBGPage>>8                 ;||
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer1Map16DMAData+7,X              ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #2*!BGWidthInTiles                  ;|\ Change size to a full screen's worth.
    STA.W HW_DMACNT+$10                       ;|/
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    STY.W HW_VMAINC                           ;\ Upload the bottom-left row of tiles.
    LDA.W Layer1VramAddr+1                    ;|\ 
    CLC                                       ;||
    ADC.B #!BGWidthInTiles                    ;|| Set VRAM address to write to (1 tile below origin).
    STA.W HW_VMADD                            ;|| One tile below = 1 row forward
    LDA.W Layer1VramAddr                      ;||
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer1Map16DMAData+2*7,X            ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    STY.W HW_VMAINC                           ;\ Upload the bottom-right row of tiles.
    LDA.W Layer1VramAddr+1                    ;|\ 
    CLC                                       ;||
    ADC.B #!BGWidthInTiles                    ;||
    STA.W HW_VMADD                            ;|| Set VRAM address to write to (1 screen right, 1 tile below origin).
    LDA.W Layer1VramAddr                      ;|| One screen right & one tile below = 1 screen & 1 row forward
    CLC                                       ;||
    ADC.B #!TilesPerBGPage>>8                 ;||
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer1Map16DMAData+3*7,X            ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #2*!BGWidthInTiles                  ;|\ Change size to a full screen's worth.
    STA.W HW_DMACNT+$10                       ;|/
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    
UploadL2Map16Strip:                           ; Done with Layer 1.
    LDA.B #0                                  ;\ Clear update flag for Layer 1.
    STA.W Layer1VramAddr                      ;/ 
    LDA.W Layer2VramAddr                      ;\ If $1CE6 is non-zero, update Layer 2.
    BNE +                                     ;/
    JMP FinishUploadMap16Strip                ; Else, return.

  + LDA.B ScreenMode                          ;\ Need to update Layer 2.
    AND.B #!ScrMode_Layer2Vert                ;| Jump down if in a vertical level.
    BEQ UploadOneL2Column                     ;|
    JMP UploadOneL2Row                        ;/

UploadOneL2Column:
    LDY.B #!HW_VINC_IncOnHi|!HW_VINC_IncBy32  ;\ Updating horizontal Layer 2.
    STY.W HW_VMAINC                           ;| Upload the top-left column of tiles.
    LDA.W Layer2VramAddr+1                    ;|\ 
    STA.W HW_VMADD                            ;|| Set VRAM address to write to.
    LDA.W Layer2VramAddr                      ;||
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer2Map16DMAData,X                ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    STY.W HW_VMAINC                           ;\ Upload the bottom-left column of tiles.
    LDA.W Layer2VramAddr+1                    ;|\ 
    STA.W HW_VMADD                            ;||
    LDA.W Layer2VramAddr                      ;|| Set VRAM address to write to (1 screen below origin).
    CLC                                       ;|| One screen below = 2 screens forward
    ADC.B #(2*!TilesPerBGPage)>>8             ;||
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer2Map16DMAData+7,X              ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    STY.W HW_VMAINC                           ;\ Upload the rop-right column of tiles.
    LDA.W Layer2VramAddr+1                    ;|\ 
    INC A                                     ;||
    STA.W HW_VMADD                            ;|| Set VRAM address to write to (1 tile right of origin).
    LDA.W Layer2VramAddr                      ;|| One tile right = 1 word forward
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer2Map16DMAData+2*7,X            ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    STY.W HW_VMAINC                           ;\ Upload the bottom-right column of tiles.
    LDA.W Layer2VramAddr+1                    ;|\ 
    INC A                                     ;||
    STA.W HW_VMADD                            ;||
    LDA.W Layer2VramAddr                      ;|| Set VRAM address to write to (1 screen below, 1 tile right of origin).
    CLC                                       ;|| One screen below & one tile right = 2 screens & 1 word forward
    ADC.B #(2*!TilesPerBGPage)>>8             ;||
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer2Map16DMAData+3*7,X            ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    JMP FinishUploadMap16Strip                ; Done with Layer 2; return.

UploadOneL2Row:                               ; Updating horizontal Layer 2.
    LDY.B #!HW_VINC_IncOnHi                   ;\ 
    STY.W HW_VMAINC                           ;| Upload the top-left row of tiles.
    LDA.W Layer2VramAddr+1                    ;|\ 
    STA.W HW_VMADD                            ;|| Set VRAM address to write to.
    LDA.W Layer2VramAddr                      ;||
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer2Map16DMAData,X                ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    STY.W HW_VMAINC                           ;\ Upload the top-right row of tiles.
    LDA.W Layer2VramAddr+1                    ;|\ 
    STA.W HW_VMADD                            ;||
    LDA.W Layer2VramAddr                      ;|| Set VRAM address to write to (1 screen right of origin).
    CLC                                       ;|| One screen right = 1 screen forward
    ADC.B #!TilesPerBGPage>>8                 ;||
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer2Map16DMAData+7,X              ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #2*!BGWidthInTiles                  ;|\ Change size to a full screen's worth.
    STA.W HW_DMACNT+$10                       ;|/
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    STY.W HW_VMAINC                           ;\ Upload the bottom-left row of tiles.
    LDA.W Layer2VramAddr+1                    ;|\ 
    CLC                                       ;||
    ADC.B #!BGWidthInTiles                    ;|| Set VRAM address to write to (1 tile below origin).
    STA.W HW_VMADD                            ;|| One tile below = 1 row forward
    LDA.W Layer2VramAddr                      ;||
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer2Map16DMAData+2*7,X            ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    STY.W HW_VMAINC                           ;\ Upload the bottom-right row of tiles.
    LDA.W Layer2VramAddr+1                    ;|\ 
    CLC                                       ;||
    ADC.B #!BGWidthInTiles                    ;||
    STA.W HW_VMADD                            ;|| Set VRAM address to write to (1 screen right, 1 tile below origin).
    LDA.W Layer2VramAddr                      ;|| One screen right & one tile below = 1 screen & 1 row forward
    CLC                                       ;||
    ADC.B #!TilesPerBGPage>>8                 ;||
    STA.W HW_VMADD+1                          ;|/
    LDX.B #6                                  ;|
  - LDA.W Layer2Map16DMAData+3*7,X            ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #2*!BGWidthInTiles                  ;|\ Change size to a full screen's worth.
    STA.W HW_DMACNT+$10                       ;|/
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    
FinishUploadMap16Strip:                       ; Done with Layer 2.
    LDA.B #0                                  ;\ Clear update flag for Layer 2.
    STA.W Layer2VramAddr                      ;/
    RTL                                       ;


Layer1Map16DMAData:                           ; DMA settings for uploading rows/columns of Layer 1 Map16 data:
    %DMASettings(!HW_DMA_2Byte2Addr,HW_VMDATA,Layer1VramBuffer,2*!BGWidthInTiles)
    %DMASettings(!HW_DMA_2Byte2Addr,HW_VMDATA,Layer1VramBuffer+$40,2*!BGHeightInTiles)
    %DMASettings(!HW_DMA_2Byte2Addr,HW_VMDATA,Layer1VramBuffer+$80,2*!BGWidthInTiles)
    %DMASettings(!HW_DMA_2Byte2Addr,HW_VMDATA,Layer1VramBuffer+$C0,2*!BGHeightInTiles)
    
Layer2Map16DMAData:                           ; DMA settings for uploading rows/columns of Layer 2 Map16 data:
    %DMASettings(!HW_DMA_2Byte2Addr,HW_VMDATA,Layer2VramBuffer,2*!BGWidthInTiles)
    %DMASettings(!HW_DMA_2Byte2Addr,HW_VMDATA,Layer2VramBuffer+$40,2*!BGHeightInTiles)
    %DMASettings(!HW_DMA_2Byte2Addr,HW_VMDATA,Layer2VramBuffer+$80,2*!BGWidthInTiles)
    %DMASettings(!HW_DMA_2Byte2Addr,HW_VMDATA,Layer2VramBuffer+$C0,2*!BGHeightInTiles)

ClearMemory:                                  ; Routine to clear RAM on reset, specifically $00-$FF, $0200-$1FFF, and $7F837B/D.
    REP #$30                                  ; AXY->16
    LDX.W #NonMirroredWRAM-2                  ;\ Clear out $00-$FF and $0200-$1FFF.
 -- STZ.B _0,X                                ;|
  - DEX #2                                    ;|
    CPX.W #StackStart                         ;|\ Specifically don't clear out $0100-$01FF (Stack area)
    BPL +                                     ;||
    CPX.W #StackPage                          ;||
    BPL -                                     ;|/
  + CPX.W #-2                                 ;|
    BNE --                                    ;/
    LDA.W #0                                  ;\ 
    STA.L DynStripeImgSize                    ;| Initialize the stripe image and palette upload tables.
    STZ.W DynPaletteIndex                     ;| (the palette upload table is unnecessary though since it's cleared above).
    SEP #$30                                  ;| AXY->8
    LDA.B #-1                                 ;|
    STA.L DynamicStripeImage                  ;/
    RTS                                       ;

SetUpScreen:                                  ; Routine to set up certain VRAM-related registers in normal levels.
if ver_is_lores(!_VER)                        ;\=============== J, U, SS, & E0 ================
    STZ.W HW_SETINI                           ;! 224 lines (vertical resolution)
else                                          ;<===================== E1 ======================
    LDA.B #!HW_INI_Overscan                   ;! 239 lines
    STA.W HW_SETINI                           ;!
endif                                         ;/===============================================
    STZ.W HW_MOSAIC                           ; Turn off mosaic
    LDA.B #(VRam_L1Tilemap>>8)|!HW_BGSC_Size_64x64
    STA.W HW_BG1SC                            ; Layer 1 tilemap VRAM address and size
    LDA.B #(VRam_L2Tilemap>>8)|!HW_BGSC_Size_64x64
    STA.W HW_BG2SC                            ; Layer 2 tilemap VRAM address and size
    LDA.B #(VRam_L3Tilemap>>8)|!HW_BGSC_Size_64x64
    STA.W HW_BG3SC                            ; Layer 3 tilemap VRAM address and size
    LDA.B #(VRam_L1Tiles>>12)|(VRam_L2Tiles>>8)
    STA.W HW_BG12NBA                          ; Base VRAM address for Layer 1/2 GFX files
    LDA.B #VRam_L3Tiles>>12
    STA.W HW_BG34NBA                          ; Base address for Layer 3/4 GFX files
    STZ.B Layer12Window                       ;
    STZ.B Layer34Window                       ;
    STZ.B OBJCWWindow                         ;
    STZ.W HW_WBGLOG                           ;
    STZ.W HW_WOBJLOG                          ;
    STZ.W HW_TMW                              ;
    STZ.W HW_TSW                              ;
    LDA.B #!HW_CGSW_FixedColor                ;\ Color addition - add subscreen.
    STA.B ColorAddition                       ;/
    LDA.B #!HW_M7SEL_Color                    ;\ Set Mode7 "Screen Over" to %10000000, disable Mode7 flipping
    STA.W HW_M7SEL                            ;/
    RTS


AnglePerQuadMask:                             ; These two tables are used to convert an angle to its negative
    dw %0000000000000000
    dw %0000000011111110
    dw %0000000000000000
    dw %0000000011111110
AnglePerQuadOffset:
    dw 0,2,0,2

    dw $0000,$0100,$FFFF,$1000                ; unused table?
    db $F0

CalculateMode7Values:                         ; Subroutine to convert mode 7 X/Y Scale and angle into A/B/C/D Matrix values.
    LDA.B Mode7YScale                         ;\ Prep Y Scale value
    STA.B _0                                  ;/
    REP #$30                                  ; AXY->16
    JSR CalcBasisVector                       ; Calculate Y axis basis vector first, then X axis
    LDA.B Mode7XScale                         ;\ Prep X Scale value
    STA.B _0                                  ;/
    REP #$30                                  ; AXY->16
    LDA.B Mode7ParamA                         ;\ D <- A
    STA.B Mode7ParamD                         ;| C <- -B
    LDA.B Mode7ParamB                         ;| Essentially converting values from X axis to Y axis by rotating by 90 degrees.
    EOR.W #%1111111111111111                  ;|  Since the same subroutine is used for both axes.
    INC A                                     ;|
    STA.B Mode7ParamC                         ;/

CalcBasisVector:                              ; Subroutine to calculate a basis vector given a scale and a rotation.
    LDA.B Mode7Angle                          ; A value of $0200 here equals 360 degrees.
    ASL A                                     ;\
    PHA                                       ;| Y = quadrant of angle
    XBA                                       ;|
    AND.W #%0000000000000011                  ;|
    ASL A                                     ;|
    TAY                                       ;/
    PLA                                       ;\
    AND.W #%0000000011111110                  ;| X = angle from the X axis * 2
    EOR.W AnglePerQuadMask,Y                  ;|  Q1 & Q3 angles are positive
    CLC                                       ;|  Q2 & Q4 angles are negative
    ADC.W AnglePerQuadOffset,Y                ;| Angle is * 2 because M7SineWave entries are 2 bytes wide
    TAX                                       ;/
    JSR SineAndScale                          ;
    CPY.W #4                                  ;\
    BCC +                                     ;| Result is negative if angle is below X axis (Q3 or Q4)
    EOR.W #%1111111111111111                  ;|
    INC A                                     ;|
  + STA.B Mode7ParamB                         ;/
    TXA                                       ;\
    EOR.W #%0000000011111110                  ;| Now negate the angle and find its value
    CLC                                       ;|
    ADC.W #2                                  ;|
    AND.W #%0000000111111111                  ;|
    TAX                                       ;/
    JSR SineAndScale                          ;
    DEY #2                                    ;\
    CPY.W #4                                  ;| Result is negative if angle is left of Y axis (Q2 or Q3)
    BCS +                                     ;|
    EOR.W #%1111111111111111                  ;|
    INC A                                     ;|
  + STA.B Mode7ParamA                         ;/
    SEP #$30                                  ; AXY->8
    RTS

SineAndScale:                                 ; Looks up the sine of the angle in X, and multiplies it by the scale in $00.
    SEP #$20                                  ; A->8
    LDA.W M7SineWave+1,X                      ;\
    BEQ +                                     ;| $01 is used for the special case when sin(angle) is more than 8 bits
    LDA.B _0                                  ;|
  + STA.B _1                                  ;/
    LDA.W M7SineWave,X                        ;\ sin(angle) * scale = result
    STA.W HW_WRMPYA                           ;|
    LDA.B _0                                  ;|
    STA.W HW_WRMPYB                           ;/
    NOP #4
    LDA.W HW_RDMPY+1
    CLC                                       ;\ If sin(angle) is more than 8 bits, the only result is $0100 = 1.0.
    ADC.B _1                                  ;/ Therefore, the result is just the scale.
    XBA
    LDA.W HW_RDMPY
    REP #$20                                  ; A->16
    LSR #5                                    ; Scale of $20 = 1.0
    RTS

M7SineWave:                                   ; Sine LUT, from 0->pi/2 rad, 129 entries
    dw $0000,$0003,$0006,$0009
    dw $000C,$000F,$0012,$0015
    dw $0019,$001C,$001F,$0022
    dw $0025,$0028,$002B,$002E
    dw $0031,$0035,$0038,$003B
    dw $003E,$0041,$0044,$0047
    dw $004A,$004D,$0050,$0053
    dw $0056,$0059,$005C,$005F
    dw $0061,$0064,$0067,$006A
    dw $006D,$0070,$0073,$0075
    dw $0078,$007B,$007E,$0080
    dw $0083,$0086,$0088,$008B
    dw $008E,$0090,$0093,$0095
    dw $0098,$009B,$009D,$009F
    dw $00A2,$00A4,$00A7,$00A9
    dw $00AB,$00AE,$00B0,$00B2
    dw $00B5,$00B7,$00B9,$00BB
    dw $00BD,$00BF,$00C1,$00C3
    dw $00C5,$00C7,$00C9,$00CB
    dw $00CD,$00CF,$00D1,$00D3
    dw $00D4,$00D6,$00D8,$00D9
    dw $00DB,$00DD,$00DE,$00E0
    dw $00E1,$00E3,$00E4,$00E6
    dw $00E7,$00E8,$00EA,$00EB
    dw $00EC,$00ED,$00EE,$00EF
    dw $00F1,$00F2,$00F3,$00F4
    dw $00F4,$00F5,$00F6,$00F7
    dw $00F8,$00F9,$00F9,$00FA
    dw $00FB,$00FB,$00FC,$00FC
    dw $00FD,$00FD,$00FE,$00FE
    dw $00FE,$00FF,$00FF,$00FF
    dw $00FF,$00FF,$00FF,$00FF
    dw $0100

TallNumbers:                                  ; Tile array for numbers in the bonus star counter.
    db $B7,$3C,$B7,$BC,$B8,$3C,$B9,$3C
    db $BA,$3C,$BB,$3C,$BA,$3C,$BA,$BC
    db $BC,$3C,$BD,$3C,$BE,$3C,$BF,$3C
    db $C0,$3C,$B7,$BC,$C1,$3C,$B9,$3C
    db $C2,$3C,$C2,$BC,$B7,$3C,$C0,$FC

StatusBarRow1:
    db $3A,$38,$3B,$38,$3B,$38,$3A,$78        ; First line of the status bar (top of item box).

StatusBarRow2:
    db $30,$28,$31,$28,$32,$28,$33,$28        ; Second line of the status bar.
    db $34,$28,$FC,$38,$FC,$3C,$FC,$3C
    db $FC,$3C,$FC,$3C,$FC,$38,$FC,$38
    db $4A,$38,$FC,$38,$FC,$38,$4A,$78
    db $FC,$38,$3D,$3C,$3E,$3C,$3F,$3C
    db $FC,$38,$FC,$38,$FC,$38,$2E,$3C
    db $26,$38,$FC,$38,$FC,$38,$00,$38

StatusBarRow3:                                ; Third line of the status bar.
    db $26,$38,$FC,$38,$00,$38,$FC,$38
    db $FC,$38,$FC,$38,$64,$28,$26,$38
    db $FC,$38,$FC,$38,$FC,$38,$4A,$38
    db $FC,$38,$FC,$38,$4A,$78,$FC,$38
    db $FE,$3C,$FE,$3C,$00,$3C,$FC,$38
    db $FC,$38,$FC,$38,$FC,$38,$FC,$38
    db $FC,$38,$FC,$38,$00,$38

StatusBarRow4:                                ; Fourth line of the status bar (bottom of item box).
    db $3A,$B8,$3B,$B8,$3B,$B8,$3A,$F8

UploadStaticBar:                              ; Subroutine to upload the base status bar tilemap to VRAM.
    LDA.B #!HW_VINC_IncOnHi                   ;\ 
    STA.W HW_VMAINC                           ;|
    LDA.B #!VRAMAddrHUD1                      ;|
    STA.W HW_VMADD                            ;|
    LDA.B #!VRAMAddrHUD1>>8                   ;|
    STA.W HW_VMADD+1                          ;|
    LDX.B #6                                  ;| Execute DMA for the top line.
  - LDA.W StaticBarDMASettings,X              ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    LDA.B #!HW_VINC_IncOnHi                   ;\ 
    STA.W HW_VMAINC                           ;|
    LDA.B #!VRAMAddrHUD2                      ;|
    STA.W HW_VMADD                            ;|
    LDA.B #!VRAMAddrHUD2>>8                   ;|
    STA.W HW_VMADD+1                          ;|
    LDX.B #6                                  ;| Execute DMA for the second line.
  - LDA.W StaticBarDMASettings+7,X            ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    LDA.B #!HW_VINC_IncOnHi                   ;\ 
    STA.W HW_VMAINC                           ;|
    LDA.B #!VRAMAddrHUD3                      ;|
    STA.W HW_VMADD                            ;|
    LDA.B #!VRAMAddrHUD3>>8                   ;|
    STA.W HW_VMADD+1                          ;|
    LDX.B #6                                  ;| Execute DMA for the third line.
  - LDA.W StaticBarDMASettings+2*7,X          ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    LDA.B #!HW_VINC_IncOnHi                   ;\ 
    STA.W HW_VMAINC                           ;|
    LDA.B #!VRAMAddrHUD4                      ;|
    STA.W HW_VMADD                            ;|
    LDA.B #!VRAMAddrHUD4>>8                   ;|
    STA.W HW_VMADD+1                          ;|
    LDX.B #6                                  ;| Execute DMA for the last line.
  - LDA.W StaticBarDMASettings+3*7,X          ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    LDX.B #!StatusBarTileCount-1              ;\
    LDY.B #2*(!StatusBarTileCount-1)          ;|
  - LDA.W StatusBarRow2,Y                     ;|
    STA.W StatusBar,X                         ;|
    DEY #2                                    ;| Clear out RAM tilemap.
    DEX                                       ;|
    BPL -                                     ;/
    LDA.B #!FramesInOneIGT-1                  ;\ Number of frames one in game second lasts
    STA.W InGameTimerFrames                   ;/
    RTS

StaticBarDMASettings:
    %DMASettings(!HW_DMA_2Byte2Addr,HW_VMDATA,StatusBarRow1,2*!WidthOfItemBox)
    %DMASettings(!HW_DMA_2Byte2Addr,HW_VMDATA,StatusBarRow2,2*!WidthOfHUDL1)
    %DMASettings(!HW_DMA_2Byte2Addr,HW_VMDATA,StatusBarRow3,2*!WidthOfHUDL2)
    %DMASettings(!HW_DMA_2Byte2Addr,HW_VMDATA,StatusBarRow4,2*!WidthOfItemBox)

DrawStatusBar:                                ; Routine to upload the status bar tilemap from RAM to VRAM.
    STZ.W HW_VMAINC                           ;\ 
    LDA.B #!VRAMAddrHUD2                      ;|
    STA.W HW_VMADD                            ;|
    LDA.B #!VRAMAddrHUD2>>8                   ;|
    STA.W HW_VMADD+1                          ;|
    LDX.B #6                                  ;| Execute DMA for the top line.
  - LDA.W StatusBarDMASettings,X              ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    STZ.W HW_VMAINC                           ;\ 
    LDA.B #!VRAMAddrHUD3                      ;|
    STA.W HW_VMADD                            ;|
    LDA.B #!VRAMAddrHUD3>>8                   ;|
    STA.W HW_VMADD+1                          ;|
    LDX.B #6                                  ;| Execute DMA for the bottom line.
  - LDA.W StatusBarDMASettings+7,X            ;|
    STA.W HW_DMAPARAM+$10,X                   ;|
    DEX                                       ;|
    BPL -                                     ;|
    LDA.B #!Ch1                               ;|
    STA.W HW_MDMAEN                           ;/
    RTS                                        

StatusBarDMASettings:
    %DMASettings(!HW_DMA_1Byte1Addr,HW_VMDATA,StatusBar,!WidthOfHUDL1)
    %DMASettings(!HW_DMA_1Byte1Addr,HW_VMDATA,StatusBar+!WidthOfHUDL1,!WidthOfHUDL2)

LuigiNameTiles:                               ; "LUIGI"
    db $40,$41,$42,$43,$44
ItemBoxOBJNos:                                ; item box item OBJ numbers
    db $24,$26,$48,$0E
ItemBoxStarProps:                             ; star item box palettes
    db %00000000,%00000010,%00000100,%00000010
ItemBoxOBJProps:                              ; item box item palettes
    db %00001000,%00001010,%00000000,%00000100
TallNumberTiles:                              ; Tall numbers for status bar
    db $B7,$C3
    db $B8,$B9
    db $BA,$BB
    db $BA,$BF
    db $BC,$BD
    db $BE,$BF
    db $C0,$C3
    db $C1,$B9
    db $C2,$C4
    db $B7,$C5

UpdateStatusBar:                              ; Routine to update the status bar.
    LDA.W EndLevelTimer                       ;\ 
    ORA.B SpriteLock                          ;| Don't decrement the timer if:
    BNE UpdateTime                            ;|  - Ending a level
    LDA.W IRQNMICommand                       ;|  - Game frozen
    CMP.B #!IRQNMI_Bowser                     ;|  - In Bowser
    BEQ UpdateTime                            ;|  - A second hasn't passed
    DEC.W InGameTimerFrames                   ;|
    BPL UpdateTime                            ;/

    LDA.B #!FramesInOneIGT-1                  ;
    STA.W InGameTimerFrames                   ;
    LDA.W InGameTimerHundreds                 ;\ 
    ORA.W InGameTimerTens                     ;| If timer is already zero, skip "time up".
    ORA.W InGameTimerOnes                     ;|
    BEQ UpdateTime                            ;/

    LDX.B #2                                  ;\
  - DEC.W InGameTimerHundreds,X               ;|
    BPL +                                     ;| Decrement timer.
    LDA.B #9                                  ;|
    STA.W InGameTimerHundreds,X               ;|
    DEX                                       ;|
    BPL -                                     ;/
  + LDA.W InGameTimerHundreds                 ;\ 
    BNE +                                     ;|
    LDA.W InGameTimerTens                     ;|
    AND.W InGameTimerOnes                     ;| If time is 99, speed up music.
    CMP.B #9                                  ;|
    BNE +                                     ;|
    LDA.B #!SFX_HURRYUP                       ;|\ SFX for the "time is running out!" effect.
    STA.W SPCIO0                              ;//
  + LDA.W InGameTimerHundreds                 ;\ 
    ORA.W InGameTimerTens                     ;|
    ORA.W InGameTimerOnes                     ;| If time is 0, kill Mario.
    BNE UpdateTime                            ;|
    JSL KillMario                             ;/
    
UpdateTime:
    LDA.W InGameTimerHundreds                 ;\ 
    STA.W StatusBar+!HUDTimerOffset           ;|
    LDA.W InGameTimerTens                     ;| Copy time to status bar tilemap.
    STA.W StatusBar+!HUDTimerOffset+1         ;|
    LDA.W InGameTimerOnes                     ;|
    STA.W StatusBar+!HUDTimerOffset+2         ;/
    LDX.B #16                                 ;\
    LDY.B #0                                  ;|
  - LDA.W InGameTimerHundreds,Y               ;|
    BNE HandleScores                          ;| Replace leadings 0s in timer with spaces.
    LDA.B #!EmptyTile                         ;| (i.e. 099 vs. _99)
    STA.W StatusBar+!WidthOfHUDL1,X           ;| <- Interesting, instead of timer offset
    INY                                       ;|
    INX                                       ;|
    CPY.B #2                                  ;|
    BNE -                                     ;/

HandleScores:                                 ; Handle Mario and Luigi's scores and write them to the status bar.
    LDX.B #3                                  ;\
  - LDA.W PlayerScore+2,X                     ;|
    STA.B _0                                  ;|
    STZ.B _1                                  ;|
    REP #$20                                  ;| A->16
    LDA.W PlayerScore,X                       ;| Check if the player has reached a score of over 999999.
    SEC                                       ;|
    SBC.W #!MaximumScore                      ;|
    LDA.B _0                                  ;|
    SBC.W #!MaximumScore>>16                  ;|
    BCC +                                     ;|
    SEP #$20                                  ;| A->8
    LDA.B #!MaximumScore>>16                  ;|\ 
    STA.W PlayerScore+2,X                     ;||
    LDA.B #!MaximumScore>>8                   ;|| Limit the maximum score to 999999.
    STA.W PlayerScore+1,X                     ;||
    LDA.B #!MaximumScore                      ;||
    STA.W PlayerScore,X                       ;|/
  + SEP #$20                                  ;| A->8
    DEX                                       ;|\ 
    DEX                                       ;|| Repeat for both players.
    DEX                                       ;||
    BPL -                                     ;//

    LDA.W PlayerScore+2
    STA.B _0
    STZ.B _1
    LDA.W PlayerScore+1
    STA.B _3
    LDA.W PlayerScore
    STA.B _2
    LDX.B #!HUDScoreOffsetL2                  ;\ Status bar position offset from $0F15 to start writing Mario's score to.
    LDY.B #0                                  ;| Write Mario's score to the status bar.
    JSR DrawScore                             ;/
    LDX.B #0                                  ;\
  - LDA.W StatusBar+!HUDScoreOffset,X         ;|
    BNE +                                     ;|
    LDA.B #!EmptyTile                         ;| Replace leading 0s in Mario's score with spaces.
    STA.W StatusBar+!HUDScoreOffset,X         ;|
    INX                                       ;|
    CPX.B #6                                  ;|
    BNE -                                     ;/
  + LDA.W PlayerTurnLvl                       ;\ If playing as Mario, branch and don't overwrite with Luigi's score.
    BEQ HandleCoins                           ;/
    LDA.W PlayerScore+5
    STA.B _0
    STZ.B _1
    LDA.W PlayerScore+4
    STA.B _3
    LDA.W PlayerScore+3
    STA.B _2
    LDX.B #!HUDScoreOffsetL2                  ;\ Status bar position offset from $0F15 to start writing Luigi's score to.
    LDY.B #0                                  ;| Write Luigi's score to the status bar.
    JSR DrawScore                             ;/
    LDX.B #0                                  ;\
  - LDA.W StatusBar+!HUDScoreOffset,X         ;|
    BNE HandleCoins                           ;|
    LDA.B #!EmptyTile                         ;| Replace leading 0s in Luigi's score with spaces.
    STA.W StatusBar+!HUDScoreOffset,X         ;|
    INX                                       ;|
    CPX.B #6                                  ;|
    BNE -                                     ;/
    
HandleCoins:                                  ; Handle the current player's coins.
    LDA.W CoinAdder                           ;\ 
    BEQ HandleLives                           ;| Add a coin to the player's coin count if applicable.
    DEC.W CoinAdder                           ;|
    INC.W PlayerCoins                         ;/
    LDA.W PlayerCoins                         ;\ 
    CMP.B #!CoinsPer1up                       ;| How many coins the player needs to get a 1up (100).
    BCC HandleLives                           ;/
    INC.W GivePlayerLives                     ; Give he player a life.
    LDA.W PlayerCoins                         ;\ 
    SEC                                       ;|
    SBC.B #!CoinsPer1up                       ;| How many coins to take away after giving the player a 1up (100).
    STA.W PlayerCoins                         ;/

HandleLives:                                  ; Handle the current player's lives and write them to the status bar.
    LDA.W PlayerLives                         ;\ If Mario has a negative number of lives (i.e. game over), don't max out the life count.
    BMI +                                     ;/
    CMP.B #!MaximumLives-1                    ;\ Maximum number of lives the player can have.
    BCC +                                     ;|
    LDA.B #!MaximumLives-1                    ;| Amount of lives to use if the maximum life limit is reached.
    STA.W PlayerLives                         ;/
  + LDA.W PlayerLives                         ;\ 
    INC A                                     ;|
    JSR HexToDec                              ;| Write the life count to the status bar.
    TXY                                       ;|
    BNE +                                     ;|
    LDX.B #!EmptyTile                         ;| Tile to use for the tens digit of the life counter if 0 (blank tile).
  + STX.W StatusBar+!HUDLivesOffset           ;|\ Positions in the status bar to write the life count to.
    STA.W StatusBar+!HUDLivesOffset+1         ;//

HandleBonusStars:                             ; Handle the current player's bonus stars.
    LDX.W PlayerTurnLvl                       ;\ 
    LDA.W PlayerBonusStars,X                  ;|
    CMP.B #!MaximumBonusStars                 ;| Number of bonus stars required to enter the bonus game (100).
    BCC DrawCoinCount                         ;|
    LDA.B #-1                                 ;|\ Set the flag to activate the bonus game after the level is beaten.
    STA.W BonusGameActivate                   ;|/
    LDA.W PlayerBonusStars,X                  ;|\ 
    SEC                                       ;||
    SBC.B #!MaximumBonusStars                 ;|| Number of bonus stars to subtract from the counter after getting a bonus game (100).
    STA.W PlayerBonusStars,X                  ;//

DrawCoinCount:                                ; Write the current player's coin count to the status bar.
    LDA.W PlayerCoins                         ;\ 
    JSR HexToDec                              ;|
    TXY                                       ;|
    BNE +                                     ;|
    LDX.B #!EmptyTile                         ;|| Tile to use for the tens digit of the coin counter if 0 (blank tile).
  + STA.W StatusBar+!HUDCoinsOffset+1         ;|\ Positions in the status bar to write the coin count to.
    STX.W StatusBar+!HUDCoinsOffset           ;//

HandleSmallBonusStars:                        ; Write the small bonus star counter to the status bar.
    SEP #$20                                  ; A->8
    LDX.W PlayerTurnLvl                       ; Load Character into X
    STZ.B _0                                  ;
    STZ.B _1                                  ;
    STZ.B _3                                  ;
    LDA.W PlayerBonusStars,X                  ;
    STA.B _2                                  ;
    LDX.B #!HUDSmallStarsOffsetL2             ;\\ Status bar position offset from $0F15 to start writing the current player's bonus stars to.
    LDY.B #4*4                                ;| Write the small bonus stars to the status bar.
    JSR DrawSmallBonusStars                   ;/
    LDX.B #0                                  ;
  - LDA.W StatusBar+!HUDSmallStarsOffset,X    ;\ 
    BNE DrawBigBonusStars                     ;|
    LDA.B #!EmptyTile                         ;|| Tile to use for the tens digit of the small bonus stars counter if 0 (blank tile).
    STA.W StatusBar+!HUDSmallStarsOffset,X    ;|
    STA.W StatusBar+!HUDBigStarsOffset,X      ;| Write the small counter's digits to the status bar.
    INX                                       ;|
    CPX.B #1                                  ;|
    BNE -                                     ;/
    
DrawBigBonusStars:                            ; Write the large bonus star counter to the status bar.
    LDA.W StatusBar+!HUDSmallStarsOffset,X    ;\ 
    ASL A                                     ;| Write the big numbers to the status bar.
    TAY                                       ;|
    LDA.W TallNumberTiles,Y                   ;|\ Write the top of the number.
    STA.W StatusBar+!HUDBigStarsOffset,X      ;|/
    LDA.W TallNumberTiles+1,Y                 ;|\ Write the bottom of the number.
    STA.W StatusBar+!HUDSmallStarsOffset,X    ;|/
    INX                                       ;|
    CPX.B #2                                  ;|
    BNE DrawBigBonusStars                     ;/

    JSR DrawReserveItem                       ; Draw the reserve item to the status bar.

DrawLuigiName:                                ; Write LUIGI to the status bar if using player 2.
    LDA.W PlayerTurnLvl                       ;\ If playing as Mario, skip.
    BEQ DrawDragonCoins                       ;/
    LDX.B #4                                  ;\ 
  - LDA.W LuigiNameTiles,X                    ;| Write LUIGI to the status bar.
    STA.W StatusBar,X                         ;|
    DEX                                       ;|
    BPL -                                     ;/

DrawDragonCoins:                              ; Write the Dragon Coins collected to the status bar.
  + LDA.W DragonCoinsShown                    ;
    CMP.B #!MaximumDragonCoins                ; Number of Yoshi coins to remove the counter from the status bar at.
    BCC +                                     ;
    LDA.B #0                                  ;
  + DEC A                                     ;
    STA.B _0                                  ;
    LDX.B #0                                  ;\
  - LDY.B #!EmptyTile                         ;| Tile used for empty Yoshi coin spot in the status bar.
    LDA.B _0                                  ;| 
    BMI +                                     ;| 
    LDY.B #!HUDDragonCoinTile                 ;| Tile used for Yoshi coin spot in the status bar.
  + TYA                                       ;| 
    STA.W StatusBar+!HUDDragonsOffset,X       ;| Write the Yoshi coins to the status bar.
    DEC.B _0                                  ;| 
    INX                                       ;| 
    CPX.B #!MaximumDragonCoins-1              ;| Maximum number of Yoshi coins to draw to the status bar.
    BNE -                                     ;/ 
    RTS                                       ;


ScorePlaces:                                  ; Values used for converting score and bonus stars to decimal.
    dw $0001,$86A0                            ; "100000"
    dw $0000,$2710                            ; "10000"
    dw $0000,$03E8                            ; "1000"
    dw $0000,$0064                            ; "100"
    dw $0000,$000A                            ; "10"
    dw $0000,$0001                            ; "1"

DrawScore:                                    ; Routine to load a player's score to the status bar.
    SEP #$20                                  ; A->8
    STZ.W StatusBar+!WidthOfHUDL1,X           ; Zero the current status bar tile.
  - REP #$20                                  ; A->16
    LDA.B _2                                  ;\ 
    SEC                                       ;|
    SBC.W ScorePlaces+2,Y                     ;|
    STA.B _6                                  ;|
    LDA.B _0                                  ;|
    SBC.W ScorePlaces,Y                       ;| If the current value can not be subtracted from the score, branch.
    STA.B _4                                  ;|
    BCC +                                     ;|
    LDA.B _6                                  ;|
    STA.B _2                                  ;|
    LDA.B _4                                  ;|
    STA.B _0                                  ;/
    SEP #$20                                  ; A->8
    INC.W StatusBar+!WidthOfHUDL1,X           ; Increase the current status bar tile's value for each value subtracted.
    BRA -
  
  + INX
    INY #4
    CPY.B #4*6
    BNE DrawScore
    SEP #$20                                  ; A->8
    RTS

HexToDec:                                     ; SMW's hex-to-dec conversion routine (JSR). Returns ones digit in A, and tens in X.
    LDX.B #0                                  ;\
  - CMP.B #10                                 ;|
    BCC +                                     ;| Sets A to 10s of original A
    SBC.B #10                                 ;| Sets X to 1s of original A
    INX                                       ;|
    BRA -                                     ;|
  + RTS                                       ;/

DrawSmallBonusStars:                          ; Routine to load the small bonus star counter to the status bar. 
    SEP #$20                                  ; A->8
    STZ.W StatusBar+!WidthOfHUDL1,X           ; Zero the current status bar tile.
  - REP #$20                                  ; A->16
    LDA.B _2                                  ;\ 
    SEC                                       ;|
    SBC.W ScorePlaces+2,Y                     ;|
    STA.B _6                                  ;| If the current value can not be subtracted from the bonus stars, branch.
    BCC +                                     ;|
    LDA.B _6                                  ;|
    STA.B _2                                  ;/
    SEP #$20                                  ; A->8
    INC.W StatusBar+!WidthOfHUDL1,X
    BRA -

  + INX
    INY #4
    CPY.B #4*6
    BNE DrawSmallBonusStars
    SEP #$20                                  ; A->8
    RTS

DrawReserveItem:                              ; Subroutine to draw the reserve item to the item box.
    LDY.B #!IRQNMI_ReznorMortonRoy|%00100000
    BIT.W IRQNMICommand
    BVC +
    LDY.B #0
    LDA.W IRQNMICommand
    CMP.B #!IRQNMI_Bowser
    BEQ +
    LDA.B #!OBJOffscreen
    STA.W OAMTileYPos,Y
  + STY.B _1
    LDY.W PlayerItembox
    BEQ ++
    LDA.W ItemBoxOBJProps-1,Y
    STA.B _0
    CPY.B #3
    BNE +
    LDA.B TrueFrame
    LSR A
    AND.B #%00000011
    PHY
    TAY
    LDA.W ItemBoxStarProps,Y
    PLY
    STA.B _0
  + LDY.B _1
    LDA.B #!ReserveItemXPos                   ;\ X position of the item box item.
    STA.W OAMTileXPos,Y                       ;/
    LDA.B #!ReserveItemYPos                   ;\ Y position of the item box item.
    STA.W OAMTileYPos,Y                       ;/
    LDA.B #%00110000                          ;\ 
    ORA.B _0                                  ;| Set YXPPCCCT of the item box item.
    STA.W OAMTileAttr,Y                       ;/
    LDX.W PlayerItembox                       ;\ 
    LDA.W ItemBoxOBJNos-1,X                   ;| Set the tile number for the item box item.
    STA.W OAMTileNo,Y                         ;/
    TYA                                       ;\ 
    LSR #2                                    ;| Set the tile size of the item box item (16x16).
    TAY                                       ;|
    LDA.B #!OBJBigSize                        ;|
    STA.W OAMTileSize,Y                       ;/
 ++ RTS


SrtTxtStartTop:
    db $00,$FF,$4D,$4C,$03,$4D,$5D,$FF        ; " START!" top
SrtTxtMarioTop:
    db $03,$00,$4C,$03,$04,$15                ; "MARIO" top
SrtTxtLuigiTop:
    db $00,$02,$00,$4A,$4E,$FF                ; "LUIGI" top
SrtTxtGameOverTop:
    db $4C,$4B,$4A,$03,$5F,$05,$04,$03        ; "GAME OVER" top
    db $02
SrtTxtTimeUpTop:
    db $00,$FF,$01,$4A,$5F,$05,$04,$00        ; "TIME UP" top
    db $4D
SrtTxtBonusTop:
    db $5D,$03,$02,$01,$00,$FF,$5B,$14        ; "BONUS GAME" top
    db $5F,$01,$5E,$FF,$FF,$FF

SrtTxtStartBtm:
    db $10,$FF,$00,$5C,$13,$00,$5D,$FF        ; " START!" bottom
SrtTxtMarioBtm:
    db $03,$00,$5C,$13,$14,$15                ; "MARIO" bottom
SrtTxtLuigiBtm:
    db $00,$12,$00,$03,$5E,$FF                ; "LUIGI" bottom
SrtTxtGameOverBtm:
    db $5C,$4B,$5A,$03,$5F,$05,$14,$13        ; "GAME OVER" bottom
    db $12
SrtTxtTimeUpBtm:
    db $10,$FF,$11,$03,$5F,$05,$14,$00        ; "TIME UP" bottom
    db $00
SrtTxtBonusBtm:
    db $5D,$03,$12,$11,$10,$FF,$5B,$01        ; "BONUS GAME" bottom
    db $5F,$01,$5E,$FF,$FF,$FF

SrtPropStartTop:
    db $34,$00,$34,$34,$34,$34,$30,$00        ; " START!" top
SrtPropMarioTop:
    db $34,$34,$34,$34,$74,$34                ; "MARIO" top
SrtPropLuigiTop:
    db $34,$34,$34,$34,$34,$00                ; "LUIGI" top
SrtPropGameOverTop:
    db $34,$34,$34,$34,$34,$34,$34,$34        ; "GAME OVER" top
    db $34
SrtPropTimeUpTop:
    db $34,$00,$34,$34,$34,$34,$34,$34        ; "TIME UP" top
    db $34
SrtPropBonusGameTop:
    db $34,$34,$34,$34,$34,$34,$34,$34        ; "BONUS GAME" top
    db $34,$34,$34

SrtPropStartBtm:
    db $34,$00,$B4,$34,$34,$B4,$F0,$00        ; " START!" bottom
SrtPropMarioBtm:
    db $B4,$B4,$34,$34,$74,$B4                ; "MARIO" bottom
SrtPropLuigiBtm:
    db $B4,$34,$B4,$B4,$34,$00                ; "LUIGI" bottom
SrtPropGameOverBtm:
    db $34,$B4,$34,$B4,$B4,$B4,$34,$34        ; "GAME OVER" bottom
    db $34
SrtPropTimeUpBtm:
    db $34,$00,$34,$B4,$B4,$B4,$34,$B4        ; "TIME UP" bottom
    db $B4
SrtPropBonusBtm:
    db $B4,$B4,$34,$34,$34,$34,$F4,$B4        ; "BONUS GAME" bottom
    db $F4,$B4,$B4

CODE_00919B:                                  ; Subroutine to prepare No-Yoshi entrances and the green star block count.
    LDA.B PlayerAnimation                     ;\ 
    CMP.B #!PAni_CastleEntrance               ;| If performing a No Yoshi entrance, prepare the scene.
    BNE +                                     ;|
    JSR ProcessPlayerAnimation                ;/
    BRA ++

  + LDA.W SublevelCount                       ;\ 
    BNE ++                                    ;| Reset coin counter for the green star block only when entering the main level (not sublevels).
    LDA.B #!GreenStarBlockCoins               ;| Amount of coins needed to get 1up from green star block.
    STA.W GreenStarBlockCoins                 ;/
 ++ RTS

ShowLevelLoadingText:                         ; Routine to display text during level load.
    JSR CODE_00A82D                           ; Load "MARIO/LUIGI START !" tiles.
    LDX.B #0                                  ;\ Load "MARIO START !".
    LDA.B #!MarioStartXPos                    ;/ X position of the rightmost tile of the "MARIO START !" message.
    LDY.W BonusGameActivate                   ;\ 
    BEQ +                                     ;| If loading a bonus game, change the text display to "BONUS GAME".
    STZ.W InGameTimerHundreds                 ;|\ 
    STZ.W InGameTimerTens                     ;|| Clear the timer.
    STZ.W InGameTimerOnes                     ;|/
    LDX.B #SrtTxtBonusTop-SrtTxtStartTop      ;|
    LDA.B #!BonusGameXPos                     ;/ X position of the rightmost tile of the "BONUS GAME" message.
  + STA.B _0
    STZ.B _1
    LDY.B #8*(SrtTxtLuigiTop-SrtTxtStartTop)  ; Number of tiles to draw, x8.
  - JSR DrawOneStartScreenLetter              ; Draw the message to the screen.
    INX
    CPX.B #8                                  ;\ 
    BNE +                                     ;|
    LDA.W PlayerTurnLvl                       ;| If playing as Luigi, load "LUIGI" instead of "MARIO".
    BEQ +                                     ;|
    LDX.B #SrtTxtLuigiTop-SrtTxtStartTop      ;/
  + TYA                                       ;\ 
    SEC                                       ;| Move to next letter.
    SBC.B #8                                  ;|
    TAY                                       ;/
    BNE -
    JMP ConsolidateOAM                        ; Prep OAM for upload.

DrawOneStartScreenLetter:                     ; Subroutine to upload loading screen text to OAM.
    LDA.W SrtPropStartTop,X                   ;\ 
    STA.W OAMTileAttr+4*!SrtOAMSlot,Y         ;| Store the YXPPCCCT properties to OAM.
    LDA.W SrtPropStartBtm,X                   ;|
    STA.W OAMTileAttr+4*(!SrtOAMSlot+1),Y     ;/
    LDA.B _0                                  ;\ 
    STA.W OAMTileXPos+4*!SrtOAMSlot,Y         ;| Set the X position of each letter to OAM.
    STA.W OAMTileXPos+4*(!SrtOAMSlot+1),Y     ;/
    SEC                                       ;\ 
    SBC.B #8                                  ;|
    STA.B _0                                  ;| Move next letter 8 pixels to the left.
    BCS +                                     ;|
    DEC.B _1                                  ;/
  + PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B _1                                  ;\ 
    AND.B #%00000001                          ;| Set size.
    STA.W OAMTileSize+!SrtOAMSlot,Y           ;|
    STA.W OAMTileSize+!SrtOAMSlot+1,Y         ;/
    PLY
    LDA.W SrtTxtStartTop,X                    ;\ 
    BMI +                                     ;|
    STA.W OAMTileNo+4*!SrtOAMSlot,Y           ;| Store the tile numbers to OAM.
    LDA.W SrtTxtStartBtm,X                    ;|
    STA.W OAMTileNo+4*(!SrtOAMSlot+1),Y       ;/
    LDA.B #!StartScreenTextYPos               ;\ Y position of the top half of the loading screen messages.
    STA.W OAMTileYPos+4*!SrtOAMSlot,Y         ;/
    LDA.B #!StartScreenTextYPos+8             ;\ Y position of the bottom half of the loading screen messages.
    STA.W OAMTileYPos+4*(!SrtOAMSlot+1),Y     ;/
  + RTS

CODE_00922F:                                  ; Upload palettes from $0703 to CGRAM.
    STZ.W MainPalette                         ;\ 
    STZ.W MainPalette+1                       ;| Clear first color of palette data.
    STZ.W HW_CGADD                            ;/
    LDX.B #6                                  ;\ Set up and enable DMA on channel 2.
  - LDA.W MainPaletteDMAData,X                ;| $4320: Increment, one register write once.
    STA.W HW_DMAPARAM+$20,X                   ;| $4321: Destination is $2122 (CGRAM).
    DEX                                       ;| $4322: Source is $000703.
    BPL -                                     ;| $4325: Write x200 bytes.
    LDA.B #!Ch2                               ;|
    STA.W HW_MDMAEN                           ;/
    RTS

MainPaletteDMAData:
    %DMASettings(!HW_DMA_1Byte1Addr,HW_CGDATA,MainPalette,$0200)

WindowDMASetup:                               ; Routine to initialize window HDMA at power on. 
    LDX.B #4                                  ; Index for DMA set up
  - LDA.W WindowDMAData,X                     ;\ Set up DMA settings for $4370-$4374.
    STA.W HW_DMAPARAM+$70,X                   ;|  (controls, destination, source)
    DEX                                       ;|
    BPL -                                     ;/
    LDA.B #0                                  ; Set HDMA data bank to $00.
    STA.W HW_HDMABANK+$70

DisableHDMA:
    STZ.W HDMAEnable                          ; Disable HDMA.
ClearWindowHDMA:                              ; Subroutine to reset the HDMA table.
    REP #$10                                  ; XY->16
    LDX.W #2*(!ScreenHeight-1)                ;\
    LDA.B #$FF                                ;|
  - STA.W WindowTable,X                       ;| Initialize entries in the HDMA table to #$FF00.
    STZ.W WindowTable+1,X                     ;|
    DEX                                       ;|
    DEX                                       ;|
    BPL -                                     ;/
    SEP #$10                                  ; XY->8
    RTS                                       ;


WindowDMAData:
    %HDMASettings(!HW_DMA_HDMAIndirect|!HW_DMA_2Byte2Addr,HW_WH0,WindowDMASizes)

WindowDMASizes:
if ver_is_lores(!_VER)                        ;\================ J, U, SS, & E0 ===============
    db !ScreenHeight+16                       ;! Screen is split into two halves
    dw WindowTable                            ;! Each $F0 lines long
    db !ScreenHeight+16                       ;!
    dw WindowTable+!ScreenHeight              ;!
    db 0                                      ;!
else                                          ;<======================= E1 ====================
    db !ScreenHeight+8                        ;! Screen is split into two halves
    dw WindowTable                            ;! Each $F8 lines long
    db !ScreenHeight+8                        ;!
    dw WindowTable+!ScreenHeight              ;!
    db 0                                      ;!
endif                                         ;/===============================================

ClearWindowTable:                             ; Subroutine to clear the windowing table.
    JSR ClearWindowHDMA                       ; Clear out the windowing table.
    LDA.W IRQNMICommand                       ;\ 
    LSR A                                     ;| If running a level, overworld, or non-Bowser battle...
    BCS EnableWindowHDMA                      ;|
    REP #$10                                  ;| XY->16
    LDX.W #2*(!ScreenHeight-1)                ;|
SolidWindowTable:                             ;|
    STZ.W WindowTable,X                       ;|\ 
    LDA.B #$FF                                ;||
    STA.W WindowTable+1,X                     ;||
    INX                                       ;|| Set the HDMA table values to 0x00FF (full screen).
    INX                                       ;||
    CPX.W #2*!ScreenHeight                    ;||
    BCC SolidWindowTable                      ;//

EnableWindowHDMA:
    LDA.B #!Ch7                               ;\ Enable HDMA on channel 7.
    STA.W HDMAEnable                          ;/
    SEP #$10                                  ; XY->8
    RTS

HandleIggyLarryLavaColor:                     ; Subroutine to handle the solid lava BG color in Iggy/Larry's room.
    JSR ClearWindowHDMA                       ;
    REP #$10                                  ; XY->16
    LDX.W #2*!IggyLavaHeight                  ;\ Scanline (x2) where the solid lava color in Iggy/Larry's fight begins.
    BRA SolidWindowTable                      ;/

SetupCreditsBGHDMA:
    LDA.B #!CreditsBGOffsetStart
    STA.W CreditsL1HDMATable
    STA.W CreditsL2HDMATable
    STA.W CreditsL3HDMATable
    STZ.W CreditsL1HDMATable+9
    STZ.W CreditsL2HDMATable+9
    STZ.W CreditsL3HDMATable+9
    LDX.B #4
  - LDA.W CreditsHDMAData,X
    STA.W HW_DMAPARAM+$50,X
    LDA.W CreditsHDMAData+5,X
    STA.W HW_DMAPARAM+$60,X
    LDA.W CreditsHDMAData+5*2,X
    STA.W HW_DMAPARAM+$70,X
    DEX
    BPL -
    LDA.B #0
    STA.W HW_HDMABANK+$50
    STA.W HW_HDMABANK+$60
    STA.W HW_HDMABANK+$70
    LDA.B #!Ch5|!Ch6|!Ch7                     ;\ Enable HDMAs on channels 5, 6, and 7.
    STA.W HDMAEnable                          ;/

ProcessCreditsBGHDMA:
    REP #$30                                  ; AXY->16
    LDY.W #8
    LDX.W #20
  - LDA.W Layer1XPos,Y
    STA.W CreditsL1HDMATable+1,X
    STA.W CreditsL1HDMATable+4,X
    LDA.W NextLayer1XPos,Y
    STA.W CreditsL1HDMATable+7,X
    TXA
    SEC
    SBC.W #10
    TAX
    DEY #4
    BPL -
    SEP #$30                                  ; AXY->8
    RTS

CreditsHDMAData:
    %HDMASettings(!HW_DMA_2Byte1Addr,HW_BG1HOFS,CreditsL1HDMATable)
    %HDMASettings(!HW_DMA_2Byte1Addr,HW_BG2HOFS,CreditsL2HDMATable)
    %HDMASettings(!HW_DMA_2Byte1Addr,HW_BG3HOFS,CreditsL3HDMATable)


RunGameMode:
    LDA.W GameMode                            ; Load game mode
    JSL ExecutePtr

    dw GM00LoadPresents                       ; 00 - load nintendo presents
    dw GM01Presents                           ; 01 - nintendo presents
    dw GMTransitionFade                       ; 02 - fade out to title screen
    dw GM03LoadTitleScreen                    ; 03 - load title screen
    dw GM04PrepTitleScreen                    ; 04 - prepare title screen
    dw GMTransitionFade                       ; 05 - fade in to title screen
    dw GM06TitleSpotlight                     ; 06 - title screen spotlight
    dw GM07TitleScreen                        ; 07 - title screen
    dw GM08FileSelect                         ; 08 - file select
    dw GM09FileDelete                         ; 09 - file delete
    dw GM0APlayerSelect                       ; 0A - player select
    dw GMTransitionFade                       ; 0B - fade out to overworld
    dw GM0CLoadOverworld                      ; 0C - load overworld
    dw GMTransitionFade                       ; 0D - fade in to overworld
    dw GM0EOverworld                          ; 0E - overworld
    dw GMTransitionMosaic                     ; 0F - fade out to level
    dw GM10FadeToLevel                        ; 10 - finish fade to level
    dw GM11LoadLevel                          ; 11 - load level
    dw GM12PrepLevel                          ; 12 - prepare level
    dw GMTransitionMosaic                     ; 13 - fade in to level
    dw GM14Level                              ; 14 - level
    dw GMTransitionFade                       ; 15 - fade out to game over/time up
    dw GM16LoadGameOver                       ; 16 - load game over/time up
    dw GM17GameOver                           ; 17 - game over/time up
    dw GMTransitionFade                       ; 18 - fade out to credits
    dw GM19LoadCutscene                       ; 19 - load castle cutscene/credits
    dw GMTransitionFade                       ; 1A - fade in to castle cutscene/credits
    dw GM1BCutscene                           ; 1B - castle cutscene/credits
    dw GMTransitionFade                       ; 1C - fade out to credits yoshi house
    dw GM1DLoadThankYou                       ; 1D - load credits yoshi house
    dw GMTransitionFade                       ; 1E - fade in to credits yoshi house
    dw GM1FThankYou                           ; 1F - credits yoshi house
    dw GMTransitionFade                       ; 20 - fade out to load credits enemy list
    dw GM21LoadEnemyList                      ; 21 - load credits enemy list
    dw GMTransitionFade                       ; 22 - fade out to credits enemy list
    dw GM23PrepEnemyList                      ; 23 - prepare credits enemy list
    dw GMTransitionFade                       ; 24 - fade in to credits enemy list
    dw GM25EnemyList                          ; 25 - credits enemy list
    dw GMTransitionFade                       ; 26 - fade out to the end screen
    dw GM27LoadTheEnd                         ; 27 - load the end screen
    dw GM28FadeInTheEnd                       ; 28 - fade in to the end screen
    dw GM29TheEnd                             ; 29 - the end screen

TurnOffIO:                                    ; Subroutine to turn off the screen while loading.
    STZ.W HW_NMITIMEN                         ; Disable interupts.
    STZ.W HW_HDMAEN                           ; Disable HDMA.
    LDA.B #!HW_DISP_FBlank                    ;\ Force blank (turn the screen off).
    STA.W HW_INIDISP                          ;/
    RTS                                       ;


NintendoPos:                                  ; X positions for the "Nintendo Presents" tiles.
    db $60,$70,$80,$90
NintendoTile:                                 ; Tilemap for the "Nintendo Presents" tiles.
    db $02,$04,$06,$08

GM00LoadPresents:                             ; Game Mode 00 - Load Nintendo Presents
    JSR ClearOutLayer3                        ; Clean out Layer 3.
    JSR SetUpScreen                           ; Set up various registers (screen mode, CGADDSUB, windows...).
    JSR CODE_00A993                           ; Load Layer 3 GFX.
    LDY.B #4*(4-1)                            ;\ Load Nintendo Presents logo
    LDX.B #4-1                                ;|
  - LDA.W NintendoPos,X                       ;|
    STA.W OAMTileXPos,Y                       ;|
    LDA.B #!NintendoPresentsYPos              ;| Y position of logo
    STA.W OAMTileYPos,Y                       ;|
    LDA.W NintendoTile,X                      ;|
    STA.W OAMTileNo,Y                         ;|
    LDA.B #%00110000                          ;|
    STA.W OAMTileAttr,Y                       ;|
    DEY #4                                    ;|
    DEX                                       ;|
    BPL -                                     ;/
    LDA.B #!QuadOBJBigSize                    ;\ Make OBJs 16x16
    STA.W OAMTileBitSize                      ;/
    LDA.B #!SFX_COIN                          ;\ Play "Bing" sound
    STA.W SPCIO3                              ;/
    LDA.B #!NintendoPresentsTimer             ;
    STA.W VariousPromptTimer                  ;
CODE_0093CA:                                  ;
    LDA.B #%00001111                          ;\ Set brightness to max
    STA.W Brightness                          ;/
    LDA.B #1                                  ;
    STA.W MosaicDirection                     ;
    STZ.W SpritePalette                       ; Sprite palette setting = 0
    JSR LoadPalette                           ; Load palettes from ROM to RAM.
    STZ.W BackgroundColor                     ;\ Black background
    STZ.W BackgroundColor+1                   ;/
    JSR CODE_00922F                           ;
    STZ.W BlinkCursorPos                      ; Set menu pointer position to 0
    LDX.B #!HW_Through_OBJ                    ; Enable sprites, disable layers
    LDY.B #!HW_Through_BG3                    ; Set Layer 3 to subscreen
CODE_0093EA:                                  ;
    LDA.B #!IRQNMI_Cutscenes                  ;
    STA.W IRQNMICommand                       ;
    LDA.B #!HW_CMath_Back                     ;
    JSR ScreenSettings                        ; Set up CGADSUB, main/sub screen designation, and windowing.
CODE_0093F4:                                  ; Commonly jumped to after gamemodes involved in loading.
    INC.W GameMode                            ; Move on to Game Mode 01
Mode04Finish:                                 ;
    LDA.B #!HW_TIMEN_NMI|!HW_TIMEN_JoyRead    ;\ Enable NMI and auto-joypad reading.
    STA.W HW_NMITIMEN                         ;/
    RTS                                       ;

ScreenSettings:                               ; Subroutine to upload settings to the color math registers.
    STA.W HW_CGADSUB                          ;\ Set CGADSUB.
    STA.B ColorSettings                       ;/
    STX.W HW_TM                               ;\ Set main/sub screen settings.
    STY.W HW_TS                               ;/
    STZ.W HW_TMW                              ;\ Disable windowing.
    STZ.W HW_TSW                              ;/
    RTS                                       ;

GM01Presents:                                 ; Game Mode 01 - Nintendo Presents logo
    DEC.W VariousPromptTimer                  ;\ Return if not time for the logo to fade away.
    BNE FinishGameMode                        ;/
    JSR CODE_00B888                           ; Decompress GFX32/GFX33.
NextGameMode:
    INC.W GameMode
FinishGameMode:
    RTS

GM06TitleSpotlight:                           ; Game Mode 06 - Title Screen: Circle effect
    JSR DetermineJoypadInput                  ; Get the current controller port to accept data from.
    JSR IsFaceButtonPressed                   ;\ Branch if A/B/X/Y is not pressed.
    BEQ +                                     ;/
    LDA.B #4*!MaxTitleSpotlightSize           ;\ Size to make the window if the opening animation is skipped with A/B/X/Y.
    JSR CODE_009440                           ;/
    INC.W GameMode                            ;\ Prepare the file select menu.
    JMP PrepareFileSelect                     ;/

  + DEC.W VariousPromptTimer                  ; A/B/X/Y is not pressed, handle the window.
    BNE FinishGameMode                        ;\ Return if not time to grow the window yet.
    INC.W VariousPromptTimer                  ;/
    LDA.W SpotlightSize                       ;
    CLC                                       ;\ 
    ADC.B #4                                  ;|
    CMP.B #4*(!MaxTitleSpotlightSize+1)       ;|
    BCS NextGameMode                          ;| Increase the size of the title screen window.
CODE_009440:                                  ;|
    STA.W SpotlightSize                       ;|
CODE_009443:                                  ;/
    JSR CODE_00CA61                           ;
    LDA.B #!ScreenWidth/2                     ;\ X Position of spotlight
    STA.B _0                                  ;|
    LDA.B #!ScreenHeight/2                    ;| Y Position of spotlight
    STA.B _1                                  ;/
    JMP CODE_00CA88


CutsceneBgColor:                              ; Back area colors for the various castle destruction cutscenes and credits.
    db $02,$00,$04,$01,$00,$06,$04,$03

CutsceneCastlePal:                            ; FG palette numbers for the various castle destruction cutscenes and credits.
    db $06,$05,$06,$03,$03,$06,$06,$03

CutsceneBackground:                           ; Stripe pointers to the BG for the various castle destruction cutscenes.
    db OtherStripes-StripeImages+54
    db OtherStripes-StripeImages+54
    db OtherStripes-StripeImages
    db OtherStripes-OtherStripes+15
    db OtherStripes-StripeImages+54
    db OtherStripes-StripeImages+3
    db OtherStripes-StripeImages

GM19LoadCutscene:                             ; Game Mode 19 - Load Credits / Castle Cutscene
    JSR ClearOutLayer3                        ; Clean out Layer 3.
    JSR Clear_1A_13D3                         ; Clean out a large chunk of RAM.
    JSR SetUpScreen                           ; Set up various registers (screen mode, CGADDSUB, windows...).
    LDX.W CutsceneID                          ;
    LDA.B #!ObjTileset_CastleCutscene         ;\ 
    STA.W ObjectTileset                       ;| Set FG/BG and sprite GFX lists.
    LDA.B #!SprTileset_CastleCutscene         ;|
    STA.W SpriteTileset                       ;/
    LDA.W CutsceneBgColor-1,X                 ;\ Set back area color.
    STA.W BackAreaColor                       ;/
    LDA.W CutsceneCastlePal-1,X               ;\ Set FG palette number.
    STA.W BackgroundPalette                   ;/
    STZ.W SpritePalette                       ;
    LDA.B #1                                  ;\ BG always uses #$01.
    STA.W ForegroundPalette                   ;/      
    CPX.B #!Cutscene_Credits                  ;\ Branch if loading a castle destruction scene, not credits.
    BNE LoadCastleCutscene                    ;/
    JSR LoadCredits                           ;
    LDA.B #OtherStripes-StripeImages+9        ;\ 
    STA.B StripeImage                         ;| Turn Layer 3 completely black.
    JSR LoadScrnImage                         ;/
    JSR UploadCreditsMusic                    ; Upload the credits music bank.
    JSL CODE_0C93DD                           ; Load the credits backgrounds.
    JSR DisableHDMA                           ; Disable HDMA.
    INC.W ObjectTileset
    INC.W SpriteTileset
    BRA +

LoadCastleCutscene:                           ; Loading castle cutscene.
    LDA.B #!BGM_CUTSCENEINTRO                 ;\ SFX to use for the castle destruction cutscene.
    STA.W SPCIO2                              ;/
    LDA.W CutsceneBackground-1,X              ;\ 
    STA.B StripeImage                         ;| Load BG tilemap.
    JSR LoadScrnImage                         ;/
    LDA.B #OtherStripes-StripeImages+6        ;\ 
    STA.B StripeImage                         ;| Load FG tilemap.
    JSR LoadScrnImage                         ;/
    REP #$20                                  ; A->16
    LDA.W #!CastleCutsceneMarioXPos
    STA.B PlayerXPosNext
    LDA.W #!CastleCutsceneMarioYPos
    STA.B PlayerYPosNext
    SEP #$20                                  ; A->8
    INC.W IsCarryingItem
  + JSR UploadSpriteGFX                       ; Upload GFX files.
    JSR LoadPalette                           ; Load palettes from ROM to RAM.
    JSR CODE_00922F                           ; Upload palettes to CGRAM.
    LDX.B #11
  - STZ.B Layer1XPos,X
    DEX
    BPL -
    LDA.B #!OBJ_Priority2
    STA.B SpriteProperties
    JSR CODE_00A635
    STZ.B PlayerDirection
    STZ.B PlayerInAir
    JSL CODE_00CEB1                           ; Animate Mario (and his cape).
    LDX.B #!HW_Through_OBJ|!HW_Through_BG1|!HW_Through_BG2|!HW_Through_BG3
    LDY.B #!HW_Through_None                   ; Put all layers and OBJ on the main screen
    JSR CODE_009622

GM1BCutscene:                                 ; Game Mode 1B - Credits / Castle Cutscene
    JSL OAMResetRoutine                       ; Clear OAM.
    LDA.W CutsceneID                          ;\ 
    CMP.B #!Cutscene_Credits                  ;| Branch down if specifically running the credits.
    BEQ ProccessCredits                       ;/
    LDA.B axlr0000Hold                        ;\ 
    AND.B #0                                  ;|] DEBUG: Change #%00000000 to #%00110000 to enable the boss cutscene select.
    CMP.B #!ButL|!ButR                        ;| Pressing L + R will then reload the cutscene.
    BNE ProcessCastleCutscene                 ;/

DebugCutsceneSelect:                          ;# DEBUG: Boss cutscene select.
    LDA.B byetudlrHold                        ;#\ 
    AND.B #!DpadUp                            ;#|
    BEQ ++                                    ;#|
    LDA.W CutsceneID                          ;#| If up is also being held,
    INC A                                     ;#|  advance to the next boss cutscene.
    CMP.B #!Cutscene_Credits+1                ;#|
    BCC +                                     ;#|
    LDA.B #!Cutscene_Iggy                     ;#|
  + STA.W CutsceneID                          ;#/
 ++ LDA.B #!GameMode_FadeToCutscene           ;#\ Reload the scene.
    STA.W GameMode                            ;#/
    RTS                                       ;#

ProcessCastleCutscene:                        ; Debug code skipped; boss beaten cutscene continues.
    JSL CODE_0CC97E                           ; Run the general cutscene routines (text writing, sprites, etc.)
    REP #$20                                  ; A->16
    LDA.B Layer1XPos                          ;\ 
    PHA                                       ;|
    LDA.B Layer1YPos                          ;|
    PHA                                       ;| Draw Mario/Yoshi relative to Layer 2 rather than Layer 1,
    LDA.B Layer2XPos                          ;|  since Layer 1 is being used for the castle object.
    STA.B Layer1XPos                          ;|
    LDA.B Layer2YPos                          ;|
    STA.B Layer1YPos                          ;/
    SEP #$20                                  ; A->8
    JSL DrawMarioAndYoshi                     ; Draw Mario/Yoshi.
    REP #$20                                  ; A->16
    PLA                                       ;\ 
    STA.B Layer1YPos                          ;| Restore that position.
    PLA                                       ;|
    STA.B Layer1XPos                          ;/
    SEP #$20                                  ; A->8
    LDA.B #!PAni_CastleDestroy                ;\ Set Mario's animation routine so that it can be automatically handled.
    STA.B PlayerAnimation                     ;/
    JSR CODE_00C47E                           ; Handle various gameplay-related routines (e.g. Mario-object interaction).
    JMP ConsolidateOAM                        ; Prep OAM for upload.

ProccessCredits:                              ; Specifically running credits.
    JSL CODE_0C938D                           ; Run the main routine.
    JMP ConsolidateOAM                        ; Prep OAM for upload.

LoadCredits:
    LDY.B #!GFX2F_CreditsLetters              ;\ Decompress GFX2F to RAM.
    JSL PrepareGraphicsFile                   ;/
    LDA.B #!HW_VINC_IncOnHi
    STA.W HW_VMAINC
    REP #$30                                  ; AXY->16
    LDA.W #VRam_CreditsLetters                ;\
    STA.W HW_VMADD                            ;| Copy from WRAM to VRAM
    LDX.W #!GFX2F_DecompSize/2                ;|  manually, no DMA
  - LDA.B [_0]                                ;|
    STA.W HW_VMDATA                           ;|
    INC.B _0                                  ;|
    INC.B _0                                  ;|
    DEX                                       ;|
    BNE -                                     ;/
    SEP #$30                                  ; AXY->8
    RTS

GM1DLoadThankYou:                             ; Game Mode 1D - Ending: Load Yoshi's House
    INC.W CutsceneID                          ;
    LDA.B #!YoshisHouse                       ;\ 
    LDY.B #1                                  ;| Set to load level 104.
    JSR CODE_0096CF                           ;/
    DEC.W GameMode                            ;
    LDA.B #!SprTileset_CreditsThankYou        ;\ Set sprite GFX list.
    STA.W SpriteTileset                       ;/
    JSR GM12PrepLevel                         ; Load level data.
    DEC.W GameMode                            ;
    JSR TurnOffIO                             ; Turn off the screen.
    JSR ClearOutLayer3                        ; Clean out Layer 3.
    JSR CODE_00A993                           ; Load Layer 3 GFX.
    JSL CODE_0CA3C9                           ; Initialize misc data?
    JSR CODE_00961E                           ; Set up screen data (CGADSUB/etc.)

GM1FThankYou:                                 ; Game Mode 1F - Ending: Yoshi's House
    JSL OAMResetRoutine                       ; Clear OAM.
    JSL CODE_0C939A                           ; Run main routines.
    INC.B EffFrame                            ;
    JSL CODE_05BB39                           ; Handle tile animation.
    JMP ConsolidateOAM                        ; Prep OAM for upload.

GM21LoadEnemyList:                            ; Game Mode 21 - Fade to Enemy Credits (black)
    JSL CODE_0C93AD                           ; Fade.
    RTS                                       ;

GM23PrepEnemyList:                            ; Game Mode 23 - Load Enemy Credits (per scene)
    JSR ClearOutLayer3                        ; Clean out Layer 3.
    JSR Clear_1A_13D3                         ; Clean out a large chunk of RAM.
    JSR SetUpScreen                           ; Set up various registers (screen mode, CGADDSUB, windows...).
    JSL CODE_0CAD8C                           ;
    JSL CODE_05801E                           ; Load level data.
    LDA.W CreditsScreenNumber                 ;\
    CMP.B #10                                 ;|
    BNE ++                                    ;|
    LDA.B #!SprTileset_ReznorIggyLarry        ;|
    STA.W SpriteTileset                       ;| Set sprite GFX list based off of screen number.
    BRA +                                     ;|
 ++ CMP.B #12                                 ;|
    BNE +                                     ;|
    LDA.B #!SprTileset_CreditsKoopalings      ;|
    STA.W SpriteTileset                       ;/
  + JSR UploadSpriteGFX                       ; Upload GFX files.
    JSR LoadPalette                           ; Load palette data from ROM to RAM.
    JSL CODE_05809E                           ; Upload Map16 data to VRAM.
    JSR CODE_00A5F9                           ; Handle animated tiles.
    JSL CODE_0CADF6                           ; Load the enemy credits scene.
    LDA.W CreditsScreenNumber
    CMP.B #12
    BNE +
    LDX.B #11
  - LDA.W BowserEndPalette,X
    STA.W MainPalette+2*$82,X
    LDA.W BowserEndPalette+2*6,X
    STA.W MainPalette+2*$92,X
    DEX
    BPL -
    
CODE_009612:
  + JSR CODE_00922F                           ; Upload palettes to CGRAM.
    JSR SetupCreditsBGHDMA                    ; Initialize HDMA table.
    JSR LoadScrnImage                         ; Upload tilemap data from $12.
    JSR GM25EnemyList
    
CODE_00961E:
    LDX.B #!HW_Through_OBJ|!HW_Through_BG1|!HW_Through_BG3
    LDY.B #!HW_Through_BG2                    ; Main/sub screen settings.
CODE_009622:
    JSR KeepGameModeActive
    LDA.B #!HW_BG_BG3Pri|!HW_BG_Mode1
    STA.B MainBGMode
    JMP CODE_0093EA

GM25EnemyList:                                ; Game Mode 25 - Ending: Enemies
    STZ.W PlayerGfxTileCount                  ;
    JSR ProcessCreditsBGHDMA                  ; Initialize HDMA table.
    JSL OAMResetRoutine                       ; Clear OAM.
    JSL CODE_0C93A5                           ; Run main routines for the game mode.
    JMP ConsolidateOAM                        ; Prep OAM for upload.

GM27LoadTheEnd:                               ; Game Mode 27 - Ending: Load The End
    JSR ClearOutLayer3                        ; Clean out Layer 3.
    JSR Clear_1A_13D3                         ; Clean out a large chunk of RAM.
    JSR SetUpScreen                           ; Set up various registers (screen mode, CGADDSUB, windows...).
    JSR LoadCredits
    LDA.B #!SprTileset_TheEnd                 ;\ Set sprite GFX list.
    STA.W SpriteTileset                       ;/
    LDA.B #3
    STA.W BackAreaColor
    LDA.B #3
    STA.W BackgroundPalette
    JSR UploadSpriteGFX                       ; Upload GFX files.
    JSR LoadPalette
    LDX.B #11
  - LDA.W TheEndColors,X
    STA.W MainPalette+2*$D2,X
    LDA.W TheEndColors+12,X
    STA.W MainPalette+2*$E2,X
    LDA.W TheEndColors+24,X
    STA.W MainPalette+2*$F2,X
    DEX
    BPL -
    JSR CODE_00922F                           ; Upload palettes to CGRAM.
    LDA.B #OtherStripes-StripeImages+$0C      ;
    STA.B StripeImage                         ;
    JSR LoadScrnImage                         ; Upload tilemap data from $12.
    JSL CODE_0CAADF                           ;
    JSR ConsolidateOAM                        ; Prep OAM for upload.
    LDX.B #!HW_Through_OBJ|!HW_Through_BG3
    LDY.B #!HW_Through_None
    JMP CODE_009622

GM29TheEnd:                                   ; Game Mode 29 - The End
    RTS                                       ; We did it!

GM10FadeToLevel:                              ; Game Mode 10 -  Fade to Level (black)
    JSR ClearOutLayer3                        ; Clean out Layer 3.
    LDA.W BonusGameActivate                   ;\ Branch if bonus game should be loaded.
    BNE .ShowText                             ;/
    LDA.W SublevelCount                       ;\ Don't show "MARIO START!" if:
    ORA.W ShowMarioStart                      ;|  - entering sublevel
    ORA.W OverworldOverride                   ;|  - no yoshi intro
    BNE .DontShowText                         ;|  - exiting to overworld
    LDA.W OverworldLayer1Tile                 ;|  - entering yoshi's house
    CMP.B #!LevelTileNoStart                  ;|| Tile to not use "Mario Start!" on (default Yoshi's House)
    BEQ .DontShowText                         ;/
.ShowText:                                    ;
    JSR ShowLevelLoadingText                  ; Show MARIO START!
.DontShowText:                                ;
    JMP CODE_0093CA                           ; Load palettes and initialize screen settings.

GM03LoadTitleScreen:                          ; Game Mode 03 - Load Title Screen
    STZ.W HW_NMITIMEN
    JSR ClearMemory                           ; Clear out $0000-$1FFF and $7F837B/D.
    LDX.B #7                                  ;\ 
    LDA.B #-1                                 ;|
  - STA.W SpriteGFXFile,X                     ;| Write #$FF to $0101-$0108.
    DEX                                       ;|
    BPL -                                     ;/
    LDA.W OverworldOverride
    BNE +
    JSR UploadMusicBank1
    LDA.B #!BGM_TITLESCREEN                   ;\ Set title screen music
    STA.W SPCIO2                              ;/
  + LDA.B #!MainMapLvls+!TitleScreenLevel
    LDY.B #0
CODE_0096CF:
    STA.W OverworldOverride
    STY.W OWPlayerSubmap

GM11LoadLevel:                                ; Game Mode 11 - Load Level (Mario Start!)
    STZ.W HW_NMITIMEN                         ;
    JSR NoButtons                             ; Disable input.
    LDA.W SublevelCount                       ;\ 
    BNE +                                     ;| If entering a level that doesn't show Mario Start (e.g. castle entrance),
    LDA.W ShowMarioStart                      ;|  reload the overworld map...?
    BEQ +                                     ;/
    JSL CODE_04DC09                           ; Upload the overworld Layer 1 tilemap.
  + STZ.W Layer3ScrollType                    ;
    STZ.W OverworldProcess                    ;
    LDA.B #!DrumrollInit                      ;\ Initialize the end-level drumroll timer.
    STA.W DrumrollTimer                       ;/
    JSL CODE_05D796                           ; Load primary header data.
    LDX.B #7                                  ;\ 
  - LDA.B Layer1XPos,X                        ;|
    STA.W NextLayer1XPos,X                    ;| Reset Layer 1/2 position calculations.
    DEX                                       ;|
    BPL -                                     ;/
    JSR UploadLevelMusic                      ; Upload the level's music.
    JSR CODE_00A635                           ; Initialize RAM, prepare Mario's entrance animation.
    LDA.B #!LevelMaxScreens                   ;\ Set maximum screen number to 0x20.
    STA.B LastScreenHoriz                     ;/
    JSR CODE_00A796                           ; Get initial Layer 2 scroll positions.
    INC.W ScreenScrollAtWill                  ; Enable "vertical scroll at will" by default.
    JSL UpdateScreenPosition                  ; Reset layer positions.
    JSL CODE_05801E                           ; Load level data.
    LDA.W OverworldOverride                   ;\ 
    BEQ +                                     ;|
    CMP.B #!MainMapLvls+!IntroCutsceneLevel   ;|
    BNE +++                                   ;|
    LDA.B #!BGM_CUTSCENEFULL                  ;|] Intro song number.
    STA.W MusicBackup                         ;|
  + LDA.W MusicBackup                         ;|
    CMP.B #%01000000                          ;| Keep music from resetting except under certain conditions:
    BCS ++                                    ;| - Level other than intro level is being force-loaded via $0109
    LDY.W IRQNMICommand                       ;| - Bit 6 of $0DDA is set
    CPY.B #!IRQNMI_Bowser                     ;|
    BNE +                                     ;|
    LDA.B #!BGM_BOWSERINTERLUDE               ;|] Bowser music.
  + STA.W SPCIO2                              ;|
 ++ AND.B #%10111111                          ;|
    STA.W MusicBackup                         ;/
+++ STZ.W Brightness                          ;\ 
    STZ.W MosaicDirection                     ;| Start fade-in.
    INC.W GameMode                            ;/
    JMP Mode04Finish                          ; Re-enable NMI and auto-joypad read.

HexToDecLong:                                 ; Wrapper for Hex conversion routine.
    JSR HexToDec
    RTL

GM16LoadGameOver:                             ; Game Mode 16 - Load Game Over / Time Up
    JSR ClearOutLayer3                        ; Clean out Layer 3.
    JSR CODE_00A82D                           ; Load TIME UP/GAME OVER tiles.
    JMP CODE_0093CA                           ; Load palettes and initialize screen settings.

GM17GameOver:                                 ; Game Mode 17 - Game Over / Time Up
    JSL OAMResetRoutine                       ; Clear OAM.
    LDA.W GameOverAnimation
    BNE .SlideTextTogether
    DEC.W GameOverTimer
if ver_is_ntsc(!_VER)                         ;\================== J, U, & SS =================
    BNE .DisplayText                          ;! GAME OVER disappears when timer hits $00
else                                          ;<=================== E0, & E1 ==================
    LDY.W GameOverTimer                       ;! GAME OVER disappears when timer hits $30
    CPY.B #!GameOverThreshold                 ;!
    BCS .DisplayText                          ;!
endif                                         ;/===============================================
    LDA.W PlayerLives                         ;\ Branch out if the player is not out of lives yet.
    BPL .NoGameOverYet                        ;/
    STZ.W CarryYoshiThruLvls                  ; Get rid of Yoshi for this player
    LDA.W SavedPlayerLives                    ;\ Branch out if this was a game over,
    ORA.W SavedPlayerLives+1                  ;|  but the other player still has lives left.
    BPL .NoGameOverYet                        ;/
    LDX.B #12                                 ;\ 
  - STZ.W AllDragonCoinsCollected,X           ;| Clear all Dragon Coin, checkpoint 1up, and 3up moon flags.
if ver_is_japanese(!_VER)                     ;|\======================= J =====================
    STZ.W Checkpoint1upCollected,X            ;|! J version resets checkpoint 1ups correctly
else                                          ;|<=============== U, SS, E0, & E1 ===============
    STZ.W _6,X                                ;|! then they f'd it up for the other releases
endif                                         ;|/===============================================
    STZ.W MoonCollected,X                     ;|
    DEX                                       ;|
    BPL -                                     ;/
    INC.W ShowContinueEnd
.NoGameOverYet:
    JMP FadeToOverworld

.SlideTextTogether:
    SEC                                       ;\ 
    SBC.B #4                                  ;// Speed at which the "GAME OVER" / "TIME UP !" messages slide together.
.DisplayText:                                 ;
    STA.W GameOverAnimation                   ;\ 
    CLC                                       ;| Set X position for the right half of the message.
    ADC.B #!GameOverXPosRight                 ;| X position of the right side of the "OVER" / "UP !" half of the messages when they slide together.
    STA.B _0                                  ;|
    ROL.B _1                                  ;/
    LDX.W DeathMessage                        ;
    LDY.B #8*9                                ;
  - CPY.B #8*5                                ;\ Branch if currently loading the right half of the message.
    BNE +                                     ;/
    LDA.B #!GameOverXPosLeft                  ;\ X position of the right side of the "GAME " / "TIME " half of the messages when they slide together.
    SEC                                       ;|
    SBC.W GameOverAnimation                   ;|
    STA.B _0                                  ;| Set X position for the left half of the message.
    ROL A                                     ;|
    EOR.B #%00000001                          ;|
    STA.B _1                                  ;/
  + JSR DrawOneStartScreenLetter              ; Load the selected death screen message.
    INX                                       ;
    TYA                                       ;\ 
    SEC                                       ;|
    SBC.B #8                                  ;| Move to next letter.
    TAY                                       ;|
    BNE -                                     ;/
    JMP ConsolidateOAM                        ; Prep OAM for upload.

CODE_0097BC:
    LDA.B #%00001111
    STA.W Brightness                          ; Set brightness to full (RAM mirror)
    STZ.W MosaicSize
    JSR NextGameModeMosaic
    LDA.B #m7scale(1.0)                       ;\
    STA.B Mode7XScale                         ;| Set X and Y scale to 1.0
    STA.B Mode7YScale                         ;/
    STZ.W ScreenShakeYOffset
    JSR ClearOutLayer3
    LDA.B #!ObjTileset_ReznorIggyLarry
    STA.W ObjectTileset
    JSL CODE_03D958
    BIT.W IRQNMICommand
    BVC .IggyLarry
    JSR CODE_009925
    LDY.W ActiveBoss
    CPY.B #!ActiveBoss_Bowser
    BCC .RoyMortonLudwig
    BNE .Reznor
    LDA.B #!SprTileset_Bowser
    BRA +

.RoyMortonLudwig:                             ; Roy, Morton, & Ludwig
    LDA.B #3
    STA.W PlayerBehindNet                     ; Disable player interaction with sprites
    LDA.B #100*2                              ;\
    STA.B OAMAddress                          ;/ OAM slot 100 gets highest priority
    LDA.B #!SprTileset_RoyMortonLudwig
  + DEC.W ObjectTileset                       ; ObjectTileset = !ObjTileset_RoyMortonLudwig
    BRA +

.IggyLarry:
    JSR LoadIggyLarryPalette
    JSR HandleIggyLarryLavaColor
    LDX.B #$50                                ;\ Y Position of floor
    JSR MakeASolidFloor                       ;/
    REP #$20                                  ; A->16
    LDA.W #80                                 ;\
    STA.B PlayerXPosNext                      ;| Player starting position
    LDA.W #-48                                ;| (80, -48)
    STA.B PlayerYPosNext                      ;/
    STZ.B Layer1XPos                          ;\
    STZ.W NextLayer1XPos                      ;| Camera starting position
    LDA.W #-112                               ;| (0, -112)
    STA.B Layer1YPos                          ;|
    STA.W NextLayer1YPos                      ;/
    LDA.W #m7center(256)                      ;\
    STA.B Mode7CenterX                        ;| Mode 7 center point
    LDA.W #m7center(208)                      ;| (256, 208)
    STA.B Mode7CenterY                        ;/
    LDA.W #128                                ;\
    STA.B Mode7XPos                           ;| Mode 7 scroll position
    LDA.W #16                                 ;| (128, 16)
    STA.B Mode7YPos                           ;/
    SEP #$20                                  ; A->8
.Reznor:
    LDA.B #!SprTileset_ReznorIggyLarry
  + STA.W SpriteTileset
    JSR UploadSpriteGFX
    LDA.B #!HW_Through_OBJ|!HW_Through_BG1
    STA.W HW_TMW
    STZ.W HW_TS
    STZ.W HW_TSW
    LDA.B #!HW_WSEL_BG1_W1_En
    STA.B Layer12Window                       ; Enable Window 1 on BG1, OBJ, & Color Window
    LDA.B #!HW_WSEL_Color_W1_En|!HW_WSEL_Color_W1_IO|!HW_WSEL_OBJ_W1_En
    STA.B OBJCWWindow                         ; Color Window is inverted for lava
    LDA.B #!HW_CGSW_CW_Out<<4                 ;\ Turn on Color Window for sub screen
    STA.B ColorAddition                       ;/
    JSR UploadStaticBar
    JSR CalculateMode7Values
CODE_009860:
    JSL DrawMarioAndYoshi
    JSR AdvancePlayerPosition
    JSR ProcessPlayerAnimation
    STZ.B PlayerYSpeed+1                      ; Y speed = 0
    JSL CODE_01808C
    JSL OAMResetRoutine
    RTS

DATA_009875:                                  ; unknown usage
    dw 1, -1, 64, 448

CODE_00987D:                                  ; Mode 7 room stuff?
    JSR CalculateMode7Values
    BIT.W IRQNMICommand
    BVC +
    JMP CODE_009A52
    
  + JSL OAMResetRoutine                       ; Iggy & Larry
    JSL CODE_03C0C6                           ; Draw the top of the lava and handle their platform's movement.
    RTS


Mode7BossTileLocations:                       ; VRAM Addresses to upload M7 Boss Tilemaps
    dw $129E,$121E,$119E,$111E                ; Morton, Roy, & Ludwig
    dw $161E,$159E,$151E,$149E                ;\ Bowser
    dw $141E,$139E,$131E,$169E                ;/

CODE_0098A9:                                  ; Routine to handle uploading a boss's Mode 7 tilemap to VRAM, as well as animating the lava.
    LDA.W IRQNMICommand                       ;\
    LSR A                                     ;| Branch if in Bowser's battle (don't animate lava).
    BCS UploadBossTilemap                     ;/
    LDA.B EffFrame                            ;\
    LSR A                                     ;|
    LSR A                                     ;| Get frame of animation for the lava.
    AND.B #%00000110                          ;|
    TAX                                       ;/
    REP #$20                                  ; A->16
    LDY.B #!HW_VINC_IncOnHi                   ;\\
    STY.W HW_VMAINC                           ;||
    LDA.W #(HW_VMDATA<<8)|!HW_DMA_2Byte2Addr  ;|| Set as uploading to VRAM at $7800 (SP4).
    STA.W HW_DMAPARAM+$20                     ;||
    LDA.W #VRam_GFX_SP4                       ;||
    STA.W HW_VMADD                            ;|/
    LDA.L DATA_05BA39,X                       ;|\
    STA.W HW_DMAADDR+$20                      ;|| Set source address of the lava animation frame.
    LDY.B #AnimatedTiles>>16                  ;||
    STY.W HW_DMAADDR+$22                      ;|/
    LDA.W #128                                ;|\ Upload 0x80 bytes (one block).
    STA.W HW_DMACNT+$20                       ;|/
    LDY.B #!Ch2                               ;|
    STY.W HW_MDMAEN                           ;/
    CLC                                       ;
    
UploadBossTilemap:                            ; Done animating the lava; now upload the boss's tilemap.
    REP #$20                                  ; A->16
    LDA.W #4                                  ;\ 4 rows of 4 tiles
    LDY.B #3*2                                ;/
    BCC +                                     ;
    LDA.W #8                                  ;\ Except Bowser--12 rows of 8 tiles
    LDY.B #11*2                               ;/
  + STA.B _0                                  ;
    LDA.W #Mode7BossTilemap                   ;
    STA.B _2                                  ;
    STZ.W HW_VMAINC                           ;
    LDA.W #HW_VMDATA<<8                       ;
    STA.W HW_DMAPARAM+$20                     ;
    LDX.B #Mode7BossTilemap>>16               ;
    STX.W HW_DMAADDR+$22                      ;
    LDX.B #!Ch2                               ;
  - LDA.W Mode7BossTileLocations,Y            ;
    STA.W HW_VMADD                            ;
    LDA.B _2                                  ;
    STA.W HW_DMAADDR+$20                      ;
    CLC                                       ;
    ADC.B _0                                  ;
    STA.B _2                                  ;
    LDA.B _0                                  ;
    STA.W HW_DMACNT+$20                       ;
    STX.W HW_MDMAEN                           ;
    DEY                                       ;
    DEY                                       ;
    BPL -                                     ;
    SEP #$20                                  ; A->8
    RTS                                       ;

CODE_009925:                                  ; Roy, Morton, Ludwig, Reznor, & Bowser
    STZ.B PlayerYPosNext+1
    REP #$20                                  ; A->16
    LDA.W #$0020
    STA.B PlayerXPosNext
    STZ.B Layer1XPos
    STZ.W NextLayer1XPos
    STZ.B Layer1YPos
    STZ.W NextLayer1YPos
    LDA.W #m7center(256)                      ;\
    STA.B Mode7CenterX                        ;| Pivot point of M7 bosses
    LDA.W #m7center(288)                      ;| (256, 288)
    STA.B Mode7CenterY                        ;/
    SEP #$20                                  ; A->8
    JSR CODE_00AE15
    JSL CODE_01808C                           ; Run normal sprite routines
    LDA.W IRQNMICommand
    LSR A
    LDX.B #con($C0,$C0,$C0,$C0,$D0)           ; Y position of floor
    LDA.B #con($A0,$A0,$A0,$A0,$B0)           ; Y position of Mario
    BCC +
    STZ.W HorizLayer1Setting                  ;\ Bowser has no ceiling or lava
    JMP CODE_009A17                           ;/

  + REP #$30                                  ; AXY->16
    LDA.W ActiveBoss
    AND.W #%0000000011111111
    ASL A
    TAX
    LDY.W #con($02C0,$02C0,$02C0,$02C0,$0300) ; ceiling offset for Morton & Roy
    LDA.W BossCeilingHeights,X
    BPL +                                     ; if not Reznor, branch
    LDY.W #con($FB80,$FB80,$FB80,$FB80,$FBC0) ; ceiling offset for Reznor
  + CMP.W #18                                 ;\ if not Ludwig, branch
    BNE +                                     ;/
    LDY.W #con($0320,$0320,$0320,$0320,$0360) ; ceiling offset for Ludwig
  + STY.B _0
    LDX.W #0
    LDA.W #$C05A                              ; $5AC0 = VRAM address of bridge tiles

DrawMode7BossArena:
    STA.L DynamicStripeImage,X                ; Write location of top of bridge
    XBA                                       ;
    CLC                                       ;
    ADC.W #con($0080,$0080,$0080,$0080,$00C0) ; Y position of lava + ceiling
    XBA                                       ;
    STA.L DynamicStripeImage+$84,X            ; Write location of top of lava
    XBA                                       ;
    SEC                                       ;
    SBC.B _0                                  ;
    XBA                                       ;
    STA.L DynamicStripeImage+$108,X           ; Write location of ceiling
    LDA.W #(64*2-1)<<8                        ; 64 tiles (2 rows of 32)
    STA.L DynamicStripeImage+2,X              ;
    STA.L DynamicStripeImage+$86,X            ;
    STA.L DynamicStripeImage+$10A,X           ;

    LDY.W #16                                 ; Write tiles in pairs (32 pairs of 2)
  - LDA.W #$38A2                              ;\ Write bridge tiles
    STA.L DynamicStripeImage+4,X              ;|
    INC A                                     ;|
    STA.L DynamicStripeImage+6,X              ;|
    LDA.W #$38B2                              ;|
    STA.L DynamicStripeImage+$44,X            ;|
    INC A                                     ;|
    STA.L DynamicStripeImage+$46,X            ;/
    LDA.W #$2C80                              ;\ Write lava tiles
    STA.L DynamicStripeImage+$88,X            ;|
    INC A                                     ;|
    STA.L DynamicStripeImage+$8A,X            ;|
    INC A                                     ;|
    STA.L DynamicStripeImage+$C8,X            ;|
    INC A                                     ;|
    STA.L DynamicStripeImage+$CA,X            ;/
    LDA.W #$28A0                              ;\ Write brick ceiling tiles
    STA.L DynamicStripeImage+$10C,X           ;|
    INC A                                     ;|
    STA.L DynamicStripeImage+$10E,X           ;|
    LDA.W #$28B0                              ;|
    STA.L DynamicStripeImage+$14C,X           ;|
    INC A                                     ;|
    STA.L DynamicStripeImage+$14E,X           ;/
    INX #4                                    ;
    DEY                                       ;
    BNE -                                     ;

    TXA                                       ;\ Advance to next screen
    CLC                                       ;|
    ADC.W #$014C                              ;|
    TAX                                       ;/
    LDA.W #$C05E                              ; $5EC0 = VRAM address of bridge tiles
    CPX.W #$0318                              ;\ Branch out when done
    BCS +                                     ;/
    JMP DrawMode7BossArena                    ; Draw the second screen

  + LDA.W #$00FF                              ;\ Write sentinel
    STA.L DynamicStripeImage,X                ;/
    SEP #$30                                  ; AXY->8
    JSR LoadScrnImage
    LDX.B #$B0                                ; Y position of floor
    LDA.B #$90                                ; Y position of Mario

CODE_009A17:
    STA.B PlayerYPosNext
    JSR MakeMode7BossArenaMap16
    JMP ClearWindowTable

MakeMode7BossArenaMap16:
    LDY.B #16                                 ;\ 16 * 2 tiles of floor
    LDA.B #$32                                ;/
  - STA.L Map16TilesLow,X
    STA.L Map16TilesLow+$1B0,X
    STA.L Map16TilesHigh,X
    STA.L Map16TilesHigh+$1B0,X
    INX
    DEY
    BNE -

    CPX.B #$C0                                ;\ Branch if not Ludwig, Roy, Morton, Reznor
    BNE +                                     ;/
    LDX.B #con($D0,$D0,$D0,$D0,$E0)           ; Y position of lava collision

MakeASolidFloor:                              ; Run by All but Bowser
    LDY.B #16                                 ;\ 16 * 2 tiles of lava
    LDA.B #$05                                ;/
  - STA.L Map16TilesLow,X
    STA.L Map16TilesLow+$1B0,X
    INX
    DEY
    BNE -
  + RTS

DATA_009A4E:                                  ; unknown usage
    db $FF,$01,$18,$30

CODE_009A52:
    LDA.W IRQNMICommand
    LSR A
    BCS +
    JSL UpdateScreenPosition                  ; Morton, Ludwig, Roy, Reznor
    JSL ProcScreenScrollCmds
    LDA.W ActiveBoss
    CMP.B #!ActiveBoss_Reznor
    BEQ +
    JSR InitM7BossOAM                         ;\ Morton, Ludwig, Roy only
    JSL ProcM7BossObjBG                       ;/
    RTS

  + JSL OAMResetRoutine                       ; Bowser: just reset OAM and that's it
    RTS

DetermineJoypadInput:                         ; Routine to decide which controller ports to use as input data.
    LDA.W HW_JOY1                             ;\
    LSR A                                     ;| Connected controllers will read a 1 here
    LDA.W HW_JOY2                             ;|
    ROL A                                     ;|
    AND.B #%00000011                          ;/ Format ------21
    BEQ ++
    CMP.B #%00000011
    BNE +
    ORA.B #%10000000                          ; Set high bit if both controllers present
  + DEC A                                     ;\ 0 for port 1, 1 for port 2
 ++ STA.W ControllersPresent                  ;/ $82 for both
    RTS

GM04PrepTitleScreen:                          ; Game Mode 04 - Prepare Title Screen
    JSR DetermineJoypadInput                  ; Get the current controller port to accept data from.
    JSR GM12PrepLevel                         ; Load the title screen level.
    STZ.W InGameTimerHundreds                 ; Set the time limit to 0.
    JSR ClearOutLayer3                        ; Clean out Layer 3.
    LDA.B #3                                  ;\ 
    STA.B StripeImage                         ;| Upload the title screen stripe image.
    JSR LoadScrnImage                         ;/
    JSR CODE_00ADA6                           ; Load palettes to RAM.
    JSR CODE_00922F                           ; Upload palettes to CGRAM.
    JSL CODE_04F675                           ; Initialize overworld sprites.
    LDA.B #!IRQNMI_Cutscenes                  ;
    STA.W IRQNMICommand                       ;
    LDA.B #!HW_WSEL_BG1_W1_En|!HW_WSEL_BG1_W1_IO|!HW_WSEL_BG2_W1_En|!HW_WSEL_BG2_W1_IO
    STA.B Layer12Window                       ;\
    LDA.B #0                                  ;|
    STA.B Layer34Window                       ;| Set up window and math settings for the title screen circle.
    LDA.B #!HW_WSEL_Color_W1_En|!HW_WSEL_OBJ_W1_En|!HW_WSEL_OBJ_W1_IO
    STA.B OBJCWWindow                         ;|
    LDA.B #(!HW_CGSW_CW_In<<4)|!HW_CGSW_FixedColor
    STA.B ColorAddition                       ;/
    JSR CODE_009443                           ;
    LDA.B #16                                 ;
    STA.W VariousPromptTimer                  ;
    JMP Mode04Finish                          ; Re-enable NMI and auto-joypad read.


TitleScreenCursorMoveOffsets:                 ; Distances to move the cursor when up/down/select are pressed. 
    db 1, -1, -1                              ; Values are down/select, up, and both.

HandleTitleScreenCursor:                      ; Routine to handle the cursor in menus. Y = which menu
    PHY
    JSR DetermineJoypadInput
    PLY
HandleSelectionCursor:
    INC.W BlinkCursorTimer                    ; Blinking cursor frame counter (file select, save prompt, etc)
    JSR DrawSelectionCursor
    LDX.W BlinkCursorPos
    LDA.B byetudlrFrame                       ;\
    AND.B #!ButB|!ButStart                    ;| If A, B, or start is pressed
    BNE +                                     ;|
    LDA.B axlr0000Frame                       ;|
    BPL .CheckMovement                        ;/
  + LDA.B #!SFX_COIN                          ;\ Play coin sound effect
    STA.W SPCIO3                              ;/
    BRA .ResetCursorPos

.CheckMovement:
    PLA                                       ;\ Eat up last return address
    PLA                                       ;/ (We don't advance game mode)
    LDA.B byetudlrFrame                       ;\
    AND.B #!ButSelect                         ;|
    LSR #3                                    ;| select is equivalent to down
    ORA.B byetudlrFrame                       ;|
    AND.B #!DpadUp|!DpadDown                  ;| If select, up, or down is pressed
    BEQ .Return                               ;/
    LDY.B #!SFX_FIREBALL                      ;\ Play fireball sound effect
    STY.W SPCIO3                              ;/
    STZ.W BlinkCursorTimer
    LSR #2                                    ;
    TAY                                       ;
    TXA                                       ;
    ADC.W TitleScreenCursorMoveOffsets-1,Y    ; Add offset to cursor index
    BPL +                                     ;\
    LDA.B MaxMenuOptions                      ;| Wrap if necessary
    DEC A                                     ;|
  + CMP.B MaxMenuOptions                      ;|
    BCC +                                     ;|
.ResetCursorPos:                              ;|
    LDA.B #0                                  ;|
  + STA.W BlinkCursorPos                      ;/ Store cursor index
.Return:
    RTS

if ver_is_console(!_VER)                      ;\=============== J, U, E0, & E1 ================
SaveFileBits:                                 ;!
    db 1<<2,1<<1,1<<0                         ;!
endif                                         ;/===============================================
                   
GM09FileDelete:
if ver_is_console(!_VER)                      ;\=============== J, U, E0, & E1 ================
    REP #$20                                  ;! A->16
    LDA.W #$39C9                              ;!\ Make the screen darker
    LDY.B #!HW_CMath_Back|!HW_CMath_Half      ;!|
    JSR ChangeBackgroundColor                 ;!/
    LDA.B byetudlrFrame                       ;!\ If Y or X is pressed
    ORA.B axlr0000Frame                       ;!| go back to file select
    AND.B #!ButX|!ButY                        ;!|
    BEQ +                                     ;!/
endif                                         ;/===============================================

BackToFileSelect:
    DEC.W GameMode                            ;\ Go back 2 game modes
    DEC.W GameMode                            ;/ and advance forward 1 later
    JSR HandleSelectionCursor_ResetCursorPos
    JMP EnterFileSelect

if ver_is_console(!_VER)                      ;\================= J, U, E0, & E1 ==============
  + LDY.B #!CursorEraseFile                   ;!\ Process erase file menu
    JSR HandleSelectionCursor                 ;!/ Returning from this routine means A/B/start was pressed
    CPX.B #3                                  ;!
    BNE EraseFileSelected                     ;!
                                              ;!
    LDY.B #2                                  ;! loop over each file
 -- LSR.W SaveFileDelete                      ;!
    BCC +                                     ;!
    PHY                                       ;!
    LDA.W SaveDataLocationsHi,Y               ;!\ Get the location of this file
    XBA                                       ;!|
    LDA.W SaveDataLocationsLo,Y               ;!/
    REP #$10                                  ;! XY->16
    TAX                                       ;!
                                              ;!
    LDY.W #144-1                              ;! Clear all 144 bytes of the save file
    LDA.B #0                                  ;!
  - STA.L SaveData,X                          ;!
    STA.L SaveDataBackup,X                    ;!
    INX                                       ;!
    DEY                                       ;!
    BNE -                                     ;!
                                              ;!
    SEP #$10                                  ;! XY->8
    PLY                                       ;!
  + DEY                                       ;!
    BPL --                                    ;!
    JMP FadeOutBackToTitle                    ;!
                                              ;!
EraseFileSelected:                            ;!
    STX.W BlinkCursorPos                      ;!\ Add the selected file to the list
    LDA.W SaveFileBits,X                      ;!| of files to delete when the erase button is selected
    ORA.W SaveFileDelete                      ;!|
    STA.W SaveFileDelete                      ;!|
    STA.B _5                                  ;!/
if ver_is_japanese(!_VER)                     ;!\======================= J ====================
    LDY.B #12                                 ;!! Index into tiles--draw 4 tiles "_okesu"
else                                          ;!<================== U, E0, & E1 ===============
    LDX.B #0                                  ;!! Index into stripe images--draw the erase files stripe
endif                                         ;!/==============================================
    JMP DrawEraseFiles                        ;!
                                              ;!
ProcContinueEndMenu:                          ;!
    PHB                                       ;! Wrapper
    PHK                                       ;!
    PLB                                       ;!
    JSR .Unwrapped                            ;!
    PLB                                       ;!
    RTL                                       ;!
                                              ;!
.Unwrapped:                                   ;!
    DEC A                                     ;!
    JSL ExecutePtr                            ;!
                                              ;!
    dw InitContinueEndMenu                    ;!
    dw DispContinueEndMenu                    ;!
                                              ;!
InitContinueEndMenu:                          ;!
    LDY.B #12                                 ;!\ Draw "Continue/End" stripe image
    JSR ShowStripeAndFinish                   ;!/
    INC.W ShowContinueEnd                     ;! move to next process
    RTS                                       ;!
                                              ;!
DispContinueEndMenu:                          ;!
    LDY.B #!CursorContinueEnd                 ;!\ Process continue/end menu
    JSR HandleSelectionCursor                 ;!/ Returning from this routine means A/B/start was pressed
    TXA                                       ;!
    BNE +                                     ;!
    JMP LoadSaveAndFadeToOW                   ;!
                                              ;!
  + JMP FadeOutBackToTitle                    ;!
                                              ;!
ProcSaveMenu:                                 ;!
    PHB                                       ;! Wrapper
    PHK                                       ;!
    PLB                                       ;!
    JSR .Unwrapped                            ;!
    PLB                                       ;!
    RTL                                       ;!
                                              ;!
.Unwrapped:                                   ;!
    LDY.B #!CursorSaveNoSave                  ;!\ Process save menu
    JSR HandleSelectionCursor                 ;!/ Returning from this routine means A/B/start was pressed
    TXA                                       ;!
    BNE +                                     ;! If save was selected
    STZ.W SPCIO3                              ;!\
    LDA.B #!SFX_MIDWAY                        ;!| Play a sound
    STA.W SPCIO0                              ;!/
    JSL SaveTheGame                           ;! Save the game
  + JSL CloseOverworldPrompt                  ;! And close the save box
    RTS                                       ;!
                                              ;!
SaveTheGame:                                  ;!
    PHB                                       ;!
    PHK                                       ;!
    PLB                                       ;!
    LDX.W SaveFile                            ;!\ Put location of save data in X
    LDA.W SaveDataLocationsHi,X               ;!|
    XBA                                       ;!|
    LDA.W SaveDataLocationsLo,X               ;!|
    REP #$10                                  ;!| XY->16
    TAX                                       ;!/
                                              ;!
 -- LDY.W #0                                  ;!\ Clear the checksum counter
    STY.B PartialChecksum                     ;!/
  - LDA.W SaveDataBuffer,Y                    ;!\ Move a byte into SRAM
    STA.L SaveData,X                          ;!/
    CLC                                       ;!\
    ADC.B PartialChecksum                     ;!| Add it to the checksum
    STA.B PartialChecksum                     ;!|
    BCC +                                     ;!| And carry if needed
    INC.B PartialChecksum+1                   ;!/
  + INX                                       ;!\
    INY                                       ;!| Move to next byte
    CPY.W #!SaveFileSize-2                    ;!/
    BCC -                                     ;! And repeat
                                              ;!
    REP #$20                                  ;! A->16
    LDA.W #$5A5A                              ;!\
    SEC                                       ;!| Subtract checksum from base value
    SBC.B PartialChecksum                     ;!| And write it to the save file
    STA.L SaveData,X                          ;!/
    CPX.W #3*!SaveFileSize                    ;!\ Make a copy of the save file
    BCS +                                     ;!/
    TXA                                       ;!\ By offseting a bit into SRAM
    ADC.W #2*!SaveFileSize+2                  ;!|
    TAX                                       ;!/
    SEP #$20                                  ;! A->8
    BRA --                                    ;!
                                              ;!
  + SEP #$30                                  ;! AXY->8
    PLB                                       ;!
    RTL                                       ;!
                                              ;!
else                                          ;<====================== SS =====================
ProcContinueEndMenu:                          ;! Saving the game was removed
    RTL                                       ;!
.Unwrapped:                                   ;!\ unused
    RTS                                       ;!/
ProcSaveMenu:                                 ;!
    RTL                                       ;!
SaveTheGame:                                  ;!
    RTL                                       ;!
endif                                         ;/===============================================

CloseOverworldPrompt:
    INC.W OverworldPromptProcess
    INC.W MessageBoxExpand
    LDY.B #$1B
    JSR ShowStripeAndFinish
    RTL


TitleScreenInputSeq:                          ; Controller input for title screen movement
if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
    db $41,$0F,$C1,$30,$00,$10,$42,$20        ;!
    db $41,$70,$81,$11,$00,$80,$82,$0C        ;!
    db $00,$30,$C1,$30,$41,$60,$C1,$10        ;!
    db $00,$40,$01,$30,$E1,$01,$00,$60        ;!
    db $41,$4E,$80,$10,$00,$30,$41,$58        ;!
    db $00,$20,$60,$01,$00,$30,$60,$01        ;!
    db $00,$30,$60,$01,$00,$30,$60,$01        ;!
    db $00,$30,$60,$01,$00,$30,$41,$1A        ;!
    db $C1,$30,$00,$30,$FF                    ;!
else                                          ;<===================== E0 & E1 =================
    db $41,$0D,$C1,$30,$00,$10,$42,$26        ;!
    db $41,$58,$81,$17,$00,$7A,$82,$0C        ;!
    db $00,$34,$C1,$2A,$41,$50,$C1,$0C        ;!
    db $00,$30,$01,$20,$E1,$01,$00,$60        ;!
    db $41,$30,$80,$10,$00,$30,$41,$4E        ;!
    db $00,$20,$60,$01,$00,$30,$60,$01        ;!
    db $00,$30,$60,$01,$00,$30,$60,$01        ;!
    db $00,$30,$60,$01,$00,$30,$41,$15        ;!
    db $C1,$30,$00,$30,$FF                    ;!
endif                                         ;/===============================================

GM07TitleScreen:                              ; Game mode 07 - Title Screen (title screen movements).
    JSR DetermineJoypadInput                  ;
    JSR IsFaceButtonPressed                   ;\ If button is pressed, load file select
    BNE PrepareFileSelect                     ;/

    JSR NoButtons                             ;
    LDX.W TitleInputIndex                     ;
    DEC.W VariousPromptTimer                  ;
    BNE +                                     ;\ Advance to the next input if necessary
    LDA.W TitleScreenInputSeq+1,X             ;| 
    STA.W VariousPromptTimer                  ;|
    INX #2                                    ;|
    STX.W TitleInputIndex                     ;/
  + LDA.W TitleScreenInputSeq-2,X             ;
    CMP.B #-1                                 ;\ If this isn't the end of the data
    BNE WriteControllerInput                  ;/ Write it to the controller input

FadeOutBackToTitle:
    LDY.B #!GameMode_FadeToTitleScreen
WriteGameModeAndReturn:
    STY.W GameMode
    RTS

WriteControllerInput:
    AND.B #~!ButSelect                        ;\ Write all bits except select button
    STA.B byetudlrHold                        ;/ to controller held register
    CMP.W TitleScreenInputSeq-2,X             ;\ Write all bits except select and Y button
    BNE +                                     ;| to controller pressed register
    AND.B #~(!ButY|!ButSelect)                ;| Unless bit 5 (select) is set,
  + STA.B byetudlrFrame                       ;/ Then Y button is pressed as well
    JMP GM14Level

PrepareFileSelect:
    JSL OAMResetRoutine
    LDA.B #!HW_Through_BG3
    STA.W HW_TM
    LDA.B #!HW_Through_OBJ|!HW_Through_BG1|!HW_Through_BG2
    STA.W HW_TS
if ver_is_english_console(!_VER)              ;\================== U, E0, & E1 ================
    STZ.W HDMAEnable                          ;! Disable all HDMA
endif                                         ;/===============================================

EnterFileSelect:
    LDA.B #!MainMapLvls+!IntroCutsceneLevel   ;\ Upon entering file select,
    STA.W OverworldOverride                   ;| Set overworld override to intro cutscene
    JSR InitSaveData                          ;/ And initialize save data for new game

if ver_is_japanese(!_VER)                     ;\======================= J =====================
    LDY.B #14                                 ;! Index into tiles--draw 4 empty tiles
    JSR DrawFileSelect                        ;!
    LDA.B #-1                                 ;!\ Write sentinel for stripe image early to cut off
    STA.L DynamicStripeImage+$9C              ;!/ "owaru" from overwriting "kiroku okesu"
else                                          ;<================ U, SS, E0, & E1 ==============
    JSR DrawFileSelect                        ;!
endif                                         ;/===============================================
    JMP NextGameMode

IsFaceButtonPressed:                          ; Subroutine to check for any input of A/B/X/Y. Returns result in zero flag.
    LDA.B axlr0000Hold
    AND.B #!ButA|!ButX
    BNE +
    LDA.B byetudlrHold
    AND.B #!ButB|!ButY|!ButSelect|!ButStart
    BNE +
  + RTS


SaveDataLocationsHi:
    db SaveData>>8
    db SaveDataFile2>>8
    db SaveDataFile3>>8

SaveDataLocationsLo:
    db SaveData
    db SaveDataFile2
    db SaveDataFile3

if ver_is_arcade(!_VER)                       ;\======================= SS ====================
ZoneCursorStripe:                             ;!
    db $52,$06,$C0,$0C,$FC,$38                ;!\ Empty tiles next to zones
    db $52,$10,$C0,$08,$FC,$38                ;!/
    db $52,$06,$00,$01,$FC,$38                ;! cursor next to selected zone
    db $FF                                    ;!
                                              ;!
ZoneCursorPositions:                          ;!
    db $06,$46,$86,$C6,$10,$50,$90            ;! Low byte of VRAM address for cursor position
                                              ;!
ZoneCursorOutOfBounds:                        ;!
    db $07,$FF                                ;! Cursor position out of bounds (down, up)
                                              ;!
ZoneCursorLimits:                             ;!
    db $00,$06                                ;! Cursor position limits (top, bottom)
                                              ;!
GM08FileSelect:                               ;!
    REP #$20                                  ;! A->16
    LDA.W #$7393                              ;!\ Brighten the background
    LDY.B #!HW_CMath_Back                     ;!|
    JSR ChangeBackgroundColor                 ;!/
                                              ;!
    LDA.B byetudlrFrame                       ;!\ If A, B, Start pressed, select that zone
    AND.B #!ButB|!ButStart                    ;!|
    BNE ZoneSelected                          ;!|
    LDA.B axlr0000Frame                       ;!|
    BMI ZoneSelected                          ;!/
                                              ;!
    LDA.B byetudlrFrame                       ;!\ If up, down pressed, move the cursor
    AND.B #!DpadUp|!DpadDown                  ;!|
    BEQ .NoCursorMovement                     ;!/
    LDY.B #!SFX_FIREBALL                      ;!\ Play fireball sound
    STY.W SPCIO3                              ;!/
    LSR #3                                    ;!
    TAX                                       ;!
    LDY.W SelectedStartingZone                ;!\ Increase or decrease selected zone
    INY                                       ;!| Based on up/down pressed
    CMP.B #%00000001                          ;!|
    BNE +                                     ;!|
    DEY #2                                    ;!/
  + TYA                                       ;!\ Bounds check
    CMP.W ZoneCursorOutOfBounds,X             ;!|
    BNE +                                     ;!|
    LDY.W ZoneCursorLimits,X                  ;!|
  + STY.W SelectedStartingZone                ;!/
                                              ;!
.NoCursorMovement:                            ;!
    REP #$10                                  ;! XY->16
    LDY.W #$3D2E                              ;! Cursor tile
    LDA.B TrueFrame                           ;!\ Make the cursor blink
    AND.B #%00011111                          ;!|
    CMP.B #%00011000                          ;!|
    BCC +                                     ;!|
    LDY.W #!EmptyTile                         ;!/ Empty tile
                                              ;!
  + LDX.W #0                                  ;!\ Upload empty spaces next to zones stripe
  - LDA.W ZoneCursorStripe,X                  ;!|
    STA.L DynamicStripeImage,X                ;!|
    INX                                       ;!|
    CPX.W #19                                 ;!|
    BNE -                                     ;!/
                                              ;!
    LDX.W SelectedStartingZone                ;!\ Write position of cursor
    LDA.W ZoneCursorPositions,X               ;!|
    STA.L DynamicStripeImage+13               ;!/
                                              ;!
    REP #$20                                  ;!\ A->16
    TYA                                       ;!| Write the cursor
    STA.L DynamicStripeImage+16               ;!|
    SEP #$30                                  ;!/ AXY->8
                                              ;!
    RTS                                       ;!
                                              ;!
ZoneSelected:                                 ;!
    LDA.B #!SFX_COIN                          ;!\ Play coin sound effect
    STA.W SPCIO3                              ;!/
    SEP #$10                                  ;! XY->8
    LDA.W SelectedStartingZone                ;!\ Disable intro cutscene if not starting at zone 1
    BEQ +                                     ;!|
    STZ.W OverworldOverride                   ;!/
  + INC.W GameMode                            ;!
    JSR InitSaveData                          ;!
                                              ;!
else                                          ;<================= J, U, E0, & E1 ==============
                                              ;!
GM08FileSelect:                               ;!
    REP #$20                                  ;! A->16
    LDA.W #$7393                              ;!\ Brighten the background
    LDY.B #$20                                ;!|
    JSR ChangeBackgroundColor                 ;!/
    LDY.B #!CursorFileSelect                  ;!\ Process file select menu
    JSR HandleTitleScreenCursor               ;!/ Returning from this routine means A/B/start was pressed
    INC.W GameMode                            ;!
    CPX.B #3                                  ;!\ If the fourth option was selected, enter
    BNE FileSelected                          ;!| file erase mode
    STZ.W SaveFileDelete                      ;!|
if ver_is_japanese(!_VER)                     ;!|\====================== J =====================
    LDY.B #12                                 ;!|! Index into tiles--draw 4 tiles "_okesu"
else                                          ;!|<================= U, E0, & E1 ================
    LDX.B #0                                  ;!|! Index into stripe images--draw the erase files stripe
endif                                         ;!|/==============================================
    JMP DrawEraseFirstTime                    ;!/
                                              ;!
FileSelected:                                 ;!
    STX.W SaveFile                            ;!
    JSR VerifySaveFile                        ;!\ If save file is corrupted, don't load it
    BNE .NotValid                             ;!/
                                              ;! X = pointer to save data
    PHX                                       ;! Y = pointer to copy of save data (potentially corrupt)
    STZ.W OverworldOverride                   ;! Don't to go intro cutscene
                                              ;!
    LDA.B #!SaveFileSize                      ;!
    STA.B _0                                  ;!
  - LDA.L SaveData,X                          ;!\ Copy the save data in SRAM
    PHX                                       ;!| (potentially fixing corrupted copy)
    TYX                                       ;!|
    STA.L SaveData,X                          ;!/
    PLX                                       ;!
    INX                                       ;!
    INY                                       ;!
    DEC.B _0                                  ;!
    BNE -                                     ;!
                                              ;!
    PLX                                       ;!
    LDY.W #0                                  ;!
  - LDA.L SaveData,X                          ;!\ Copy the save data from SRAM to WRAM
    STA.W SaveDataBuffer,Y                    ;!/
    INX                                       ;!
    INY                                       ;!
    CPY.W #!SaveFileSize-2                    ;!
    BCC -                                     ;!
                                              ;!
.NotValid:                                    ;!
    SEP #$10                                  ;! XY->8
endif                                         ;/===============================================

    LDY.B #$12                                ; Draw "1/2 player game" stripe image
    INC.W GameMode

ShowStripeAndFinish:
    STY.B StripeImage
    LDX.B #0
    JMP WrapUpDynStripeImg

ChangeBackgroundColor:
    STA.W BackgroundColor                     ; Store A in BG color
    STY.B ColorSettings                       ; Store Y in CGADSUB
    SEP #$20                                  ; A->8
    RTS

if ver_is_japanese(!_VER)                     ;\======================== J ====================
EraseFileTiles:                               ;!
    db $D4,$31,$FC,$38,$9D,$31,$FC,$38        ;!\ append "okesu" to files (erase)
    db $8D,$31,$FC,$38,$FC,$38,$FC,$38        ;!/ or blank tiles
                                              ;!
DrawFileSelect:                               ;!
DrawEraseFirstTime:                           ;!
    STZ.B _5                                  ;! Don't erase any files
DrawEraseFiles:                               ;!
    STY.B _6                                  ;!
    LDX.B #176                                ;!\ Draw file select stripe image
  - LDA.L FileSelectStripe-1,X                ;!| regardless if in file select mode or file erase mode
    STA.L DynamicStripeImage-1,X              ;!|
    DEX                                       ;!|
    BNE -                                     ;!/
    LDA.B #118                                ;! location within stripe image to write exit count
                                              ;!
else                                          ;<================ U, SS, E0, & E1 ==============
                                              ;!
DrawFileSelect:                               ;!
    LDX.B #FileSelectStripe-EraseFileStripe   ;! Index into stripe images--draw the file select stripe
if ver_is_console(!_VER)                      ;!\=================== U, E0, & E1 ==============
DrawEraseFirstTime:                           ;!!
    STZ.B _5                                  ;!! Don't erase any files
endif                                         ;!/==============================================
DrawEraseFiles:                               ;!
    REP #$10                                  ;! XY->16
    LDY.W #0                                  ;!
  - LDA.L EraseFileStripe,X                   ;!\ Draw file select or file erase stripe image
    PHX                                       ;!| Depending on what mode we are in
    TYX                                       ;!|
    STA.L DynamicStripeImage,X                ;!/
    PLX                                       ;!
    INX                                       ;!
    INY                                       ;!
    CPY.W #FileSelectStripe-EraseFileStripe+1 ;!
    BNE -                                     ;!
    SEP #$10                                  ;! XY->8
if ver_is_console(!_VER)                      ;!\=================== U, E0, & E1 ==============
    LDA.B #132                                ;!! location within stripe image to write exit count
endif                                         ;!/==============================================
endif                                         ;/===============================================

if ver_is_console(!_VER)                      ;\================= J, U, E0, & E1 ==============
    STA.B _0                                  ;!
    LDX.B #2                                  ;! loop over each file
DrawFileExitCount:                            ;!
    STX.B _4                                  ;!
    LSR.B _5                                  ;!\ If this file is marked to be erased
    BCS .EmptyFile                            ;!/ show it as empty
    JSR VerifySaveFile                        ;!\ If this file is corrupted
    BNE .EmptyFile                            ;!/ show it as empty
    LDA.L SaveDataExitCount,X                 ;!
    SEP #$10                                  ;! XY->8
if ver_is_english(!_VER)                      ;!\=================== U, E0, & E1 ==============
    CMP.B #!TotalExitCount                    ;!! If all the exits are collected
    BCC .NoStar                               ;!! use special tiles for the counter next to the file
    LDY.B #$87                                ;!!
    LDA.B #$88                                ;!!
    BRA +                                     ;!!
endif                                         ;!/==============================================
                                              ;!
.NoStar:                                      ;!
    JSR HexToDec                              ;!\ Otherwise, convert number of exits to decimal
    TXY                                       ;!/
  + LDX.B _0                                  ;! X = location within stripe image to write exit count
    STA.L DynamicStripeImage+4,X              ;!
    TYA                                       ;!
    BNE +                                     ;!\ Leading zero is a blank space
    LDY.B #$FC                                ;!/
  + TYA                                       ;!
    STA.L DynamicStripeImage+2,X              ;!
    LDA.B #$38                                ;!\ Exit count uses different palette
    STA.L DynamicStripeImage+3,X              ;!|
    STA.L DynamicStripeImage+5,X              ;!/
    REP #$20                                  ;! A->16
if ver_is_japanese(!_VER)                     ;!\======================= J ====================
    LDA.W #!EmptyTile                         ;!!\ Clear dakuten from hajimekara
    STA.L DynamicStripeImage+18,X             ;!!/
    LDY.B _6                                  ;!!
  - LDA.W EraseFileTiles,Y                    ;!!\ Write empty spaces or word "okesu"
    STA.L DynamicStripeImage+6,X              ;!!/ overtop of hajimekara
    INX #2                                    ;!!
    DEY #4                                    ;!!
    BPL -                                     ;!!
    SEP #$20                                  ;!! A->8
.EmptyFile:                                   ;!!
    SEP #$10                                  ;!! XY->8
else                                          ;!<=================== U, E0, & E1 ==============
    LDY.B #3                                  ;!!
  - LDA.W #!EmptyTile                         ;!!\ Clear out the rest of the word "empty"
    STA.L DynamicStripeImage+6,X              ;!!/
    INX #2                                    ;!!
    DEY                                       ;!!
    BNE -                                     ;!!
    SEP #$20                                  ;!! A->8
.EmptyFile:                                   ;!!
    SEP #$10                                  ;!! XY->8
endif                                         ;!/==============================================
    LDA.B _0                                  ;!\
    SEC                                       ;!| Move to next file
    SBC.B #con(42,36,-1,36,36)                ;!| bytes backward within stripe image
    STA.B _0                                  ;!|
    LDX.B _4                                  ;!|
    DEX                                       ;!|
    BPL DrawFileExitCount                     ;!/
    RTS                                       ;!
                                              ;!
VerifySaveFile:                               ;! Check if save file is valid, X = file index
    LDA.W SaveDataLocationsHi,X               ;!
    XBA                                       ;!
    LDA.W SaveDataLocationsLo,X               ;!
                                              ;!
    REP #$30                                  ;! AXY->16
    TAX                                       ;!\ X = pointer to save data
    CLC                                       ;!|
    ADC.W #3*!SaveFileSize                    ;!|
    TAY                                       ;!/ Y = pointer to the other copy
                                              ;!
.CheckCopy:                                   ;!
    PHX                                       ;!
    PHY                                       ;!
    LDA.L SaveDataChecksum,X                  ;!\ Start with the checksum in the save file
    STA.B PartialChecksum                     ;!/
    SEP #$20                                  ;! A->8
    LDY.W #!SaveFileSize-2                    ;!
  - LDA.L SaveData,X                          ;!\ Add up all the bytes
    CLC                                       ;!|
    ADC.B PartialChecksum                     ;!|
    STA.B PartialChecksum                     ;!|
    BCC +                                     ;!| Carry if needed
    INC.B PartialChecksum+1                   ;!/
  + INX                                       ;!
    DEY                                       ;!
    BNE -                                     ;!
                                              ;!
    REP #$20                                  ;! A->16
    PLY                                       ;!
    PLX                                       ;!
    LDA.B PartialChecksum                     ;!\ Valid result should be this base value
    CMP.W #$5A5A                              ;!|
    BEQ .Done                                 ;!/ Exit if the save is valid
    CPX.W #3*!SaveFileSize-1                  ;!\
    BCS .Done                                 ;!/ Exit if both copies are invalid
    PHX                                       ;!\
    TYX                                       ;!| If the first save is invalid, swap X/Y and check the copy
    PLY                                       ;!/
    BRA .CheckCopy                            ;!
                                              ;!
.Done:                                        ;!
    SEP #$20                                  ;! A->8
    RTS                                       ;!
                                              ;!
else                                          ;<========================= SS ==================
    RTS                                       ;! Don't have to write exit counts for zones
                                              ;!
    RTS                                       ;! Don't have to verify save data
endif                                         ;/===============================================

GM0APlayerSelect:
    LDA.B byetudlrFrame                       ;\
    ORA.B axlr0000Frame                       ;| If X/Y pressed, go back to file select
    AND.B #!ButX|!ButY                        ;|
    BEQ +                                     ;|
    DEC.W GameMode                            ;|
    JMP BackToFileSelect                      ;/

  + LDY.B #!CursorPlayerSelect                ;\ Process player select menu
    JSR HandleTitleScreenCursor               ;/ Returning from this routine means A/B/start was pressed
    STX.W IsTwoPlayerGame
    JSR CopyFromSaveBuffer
    JSL DecompressOverworldL2

LoadSaveAndFadeToOW:
    LDA.B #!BGM_FADEOUT                       ;\ Fade music
    STA.W SPCIO2                              ;/
    LDA.B #-1                                 ;\ Set player 2 lives to -1 first
    STA.W SavedPlayerLives+1                  ;/
    LDX.W IsTwoPlayerGame                     ;\
    LDA.B #4                                  ;| Set initial lives to 4
  - STA.W SavedPlayerLives,X                  ;|
    DEX                                       ;|
    BPL -                                     ;/
    STA.W PlayerLives                         ; Current lives is also 4
    STZ.W PlayerCoins                         ;\
    STZ.W CarryYoshiThruLvls                  ;| Initialize a lot of stuff to zero
    STZ.B Powerup                             ;|
    STZ.W PlayerItembox                       ;|
    STZ.W ShowContinueEnd                     ;|
    REP #$20                                  ;| A->16
    STZ.W SavedPlayerCoins                    ;|
    STZ.W SavedPlayerPowerup                  ;|
    STZ.W SavedPlayerYoshi                    ;|
    STZ.W PlayerItembox                       ;| Supposed to be SavedPlayerPowerup?
    STZ.W PlayerBonusStars                    ;|
    STZ.W PlayerScore                         ;|
    STZ.W PlayerScore+3                       ;|
    SEP #$20                                  ;| A->8
    STZ.W PlayerScore+2                       ;|
    STZ.W PlayerScore+5                       ;/
    STZ.W OWLevelExitMode                     ; Enter overworld normally
    STZ.W PlayerTurnLvl                       ; Player 1's turn
FadeToOverworld:
    JSR KeepGameModeActive
    LDY.B #!GameMode_FadeToOverworld
    JMP WriteGameModeAndReturn

CursorOptCount:                               ; Number of options per menu
    dw 2,4,2,2,4

CursorCoords:                                 ; VRAM address of cursor on first option of each menu
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    dw $51CC                                  ;! continue/end
    dw $5208                                  ;! file select
    dw $5228                                  ;! 1/2 player
    dw $5208                                  ;! save/no save
    dw $5208                                  ;! erase file select
elseif ver_is_arcade(!_VER)                   ;<====================== SS =====================
    dw $51CB                                  ;! continue/end
    dw $5208                                  ;! file select
    dw $5208                                  ;! 1/2 player
    dw $51C4                                  ;! save/no save
    dw $5205                                  ;! erase file select
else                                          ;<================== U, E0, & E1 ================
    dw $51CB                                  ;! continue/end
    dw $51E8                                  ;! file select
    dw $5208                                  ;! 1/2 player
    dw $51C4                                  ;! save/no save
    dw $51E5                                  ;! erase file select
endif                                         ;/===============================================

CursorBitfields:
    db 1<<0,1<<1,1<<2,1<<3

DrawSelectionCursor:
    LDX.W BlinkCursorPos                      ;\ Convert cursor index into bitmask
    LDA.W CursorBitfields,X                   ;|
    TAX                                       ;/
    LDA.W BlinkCursorTimer                    ;\
    EOR.B #%00011111                          ;| Make the cursor blink
    AND.B #%00011000                          ;|
    BNE +                                     ;|
    LDX.B #0                                  ;|
  + STX.B _0                                  ;/
    LDA.L DynStripeImgSize
    TAX
    
    REP #$20                                  ; A->16
    LDA.W CursorOptCount,Y
    STA.B MaxMenuOptions
    STA.B _2
    
    LDA.W CursorCoords,Y
  - XBA
    STA.L DynamicStripeImage,X                ; Write VRAM address of stripe image
    XBA
    CLC                                       ;\ Advance 64 tiles per cursor slot
    ADC.W #64                                 ;/
    PHA
    LDA.W #(2-1)<<8                           ;\ Stripe image payload is 2 bytes
    STA.L DynamicStripeImage+2,X              ;/
    LDA.W #!EmptyTile                         ;\
    LSR.B _0                                  ;| Write an empty tile or cursor tile depending on bitmask
    BCC +                                     ;|
    LDA.W #$3D2E                              ;|
  + STA.L DynamicStripeImage+4,X              ;/
    PLA
    INX #6                                    ; Each stripe image is 6 bytes long
    DEC.B _2
    BNE -
    
    SEP #$20                                  ; A->8
WrapUpDynStripeImg:
    TXA                                       ;\ Preserve length of dynamic stripe image buffer
    STA.L DynStripeImgSize                    ;/
    LDA.B #-1                                 ;\ Write sentinel value
    STA.L DynamicStripeImage,X                ;/
    RTS

if ver_is_console(!_VER)                      ;\================ J, U, E0, & E1 ===============
InitLevelTileMovementData:                    ;!
    db $28,$03                                ;! enable left/right on yoshi's house
    db $4D,$01                                ;! enable right on special world star warp
    db $52,$01                                ;! enable right on star world top star warp
    db $53,$01                                ;! enable right on star world left star warp
    db $5B,$08                                ;! enable up on star world bottom left star warp
    db $5C,$02                                ;! enable left on star world bottom right star warp
    db $57,$04                                ;! enable down on star world right star warp
    db $30,$01                                ;! enable right on valley of bowser star warp
                                              ;!
InitPlayerOverworldData:                      ;!
    db !Submap_YoshisIsland                   ;!\ initial players submap
    db !Submap_YoshisIsland                   ;!/
    dw 2                                      ;!\ initial players animation
    dw 2                                      ;!/
    dw !InitOWPosX,!InitOWPosY                ;!\ initial players position
    dw !InitOWPosX,!InitOWPosY                ;!/
    dw !InitOWPosX>>4,!InitOWPosY>>4          ;!\ initial players position / $10
    dw !InitOWPosX>>4,!InitOWPosY>>4          ;!/
                                              ;!
InitSaveData:                                 ;!
    LDX.B #!SaveFileSize-2                    ;!\
  - STZ.W SaveDataBuffer-1,X                  ;!| Initialize all values to zero
    DEX                                       ;!|
    BNE -                                     ;!/
                                              ;!
    LDX.B #16-2                               ;!\
  - LDY.W InitLevelTileMovementData,X         ;!| Unlock movement directions on certain level tiles
    LDA.W InitLevelTileMovementData+1,X       ;!|
    STA.W SaveDataBuffer,Y                    ;!|
    DEX #2                                    ;!|
    BPL -                                     ;!/
                                              ;!
    LDX.B #22-1                               ;!\
  - LDA.W InitPlayerOverworldData,X           ;!| Initialize player overworld data
    STA.W SaveDataBufferSubmap,X              ;!|
    DEX                                       ;!|
    BPL -                                     ;!/
                                              ;!
    RTS                                       ;!
                                              ;!
else                                          ;<========================= SS ==================
                                              ;!
InitLevelTileMovementData:                    ;!
.Zone1:                                       ;!
    db $28,$83,$4D,$81,$52,$81,$53,$81        ;!\ Yoshi's House & Star Warps
    db $5B,$88,$5C,$82,$57,$84,$30,$81        ;!/
.Zone2:                                       ;!
    db $29,$89,$2A,$8A,$27,$85,$26,$8C        ;!\ Yoshi's Island completed
    db $25,$89,$15,$04                        ;!/
.Zone3:                                       ;!
    db $15,$86,$09,$8E,$04,$83,$05,$83        ;!\ Donut Plains completed
    db $06,$8A,$07,$8A,$3E,$04                ;!/
.Zone4:                                       ;!
    db $3E,$85,$3C,$8D,$2B,$85,$2E,$8C        ;!\ Vanilla Dome completed
    db $3D,$8C,$40,$8C,$0F,$02                ;!/
.Zone5:                                       ;!
    db $0F,$83,$10,$86,$0E,$85,$42,$08        ;! Cheese Bridge completed
.Zone6:                                       ;!
    db $42,$89,$44,$8D,$47,$85,$20,$85        ;!\ Forest of Illusion completed
    db $22,$08                                ;!/
.Zone7:                                       ;!
    db $22,$8A,$21,$85,$24,$8A,$23,$83        ;!\ Chocolate Island completed
    db $1B,$85,$1D,$8A,$1C,$89,$1A,$8C        ;!|
    db $18,$02                                ;!/
.End:                                         ;!
                                              ;!
#InitLevelTileMoveIndices:                    ;!
    db .Zone1-InitLevelTileMovementData       ;!
    db .Zone2-InitLevelTileMovementData       ;!
    db .Zone3-InitLevelTileMovementData       ;!
    db .Zone4-InitLevelTileMovementData       ;!
    db .Zone5-InitLevelTileMovementData       ;!
    db .Zone6-InitLevelTileMovementData       ;!
    db .Zone7-InitLevelTileMovementData       ;!
    db .End-InitLevelTileMovementData         ;!
                                              ;!
InitOWEventPlayerData:                        ;!
.Zone1:                                       ;!
    db $00,$00,$00,$00,$00,$00,$00,$00        ;!\ initial events cleared
    db $00,$00,$00,$00,$00,$00,$00            ;!/
    db !Submap_YoshisIsland                   ;!\ initial players submap
    db !Submap_YoshisIsland                   ;!/
    dw 2                                      ;!\ initial players animation
    dw 2                                      ;!/
    dw !InitOWPosX,!InitOWPosY                ;!\ initial players position
    dw !InitOWPosX,!InitOWPosY                ;!/
    dw !InitOWPosX>>4,!InitOWPosY>>4          ;!\ initial players position / $10
    dw !InitOWPosX>>4,!InitOWPosY>>4          ;!/
    db 0,0,0,0                                ;! initial switch palaces
.Zone2:                                       ;!
    db $7E,$00,$00,$00,$00,$00,$00,$00        ;!\ initial events cleared
    db $00,$00,$00,$00,$00,$00,$00            ;!/
    db !Submap_Main                           ;!\ initial players submap
    db !Submap_Main                           ;!/
    dw 2                                      ;!\ initial players animation
    dw 2                                      ;!/
    dw $58,$118                               ;!\ initial players position
    dw $58,$118                               ;!/
    dw $58>>4,$118>>4                         ;!\ initial players position / $10
    dw $58>>4,$118>>4                         ;!/
    db 0,1,0,0                                ;! initial switch palaces
.Zone3:                                       ;!
    db $7F,$6F,$00,$00,$00,$80,$00,$00        ;!\ initial events cleared
    db $00,$00,$00,$00,$00,$00,$00            ;!/
    db !Submap_VanillaDome                    ;!\ initial players submap
    db !Submap_VanillaDome                    ;!/
    dw 2                                      ;!\ initial players animation
    dw 2                                      ;!/
    dw $58,$128                               ;!\ initial players position
    dw $58,$128                               ;!/
    dw $58>>4,$128>>4                         ;!\ initial players position / $10
    dw $58>>4,$128>>4                         ;!/
    db 1,1,0,0                                ;! initial switch palaces
.Zone4:                                       ;!
    db $7F,$6F,$05,$F8,$00,$C0,$00,$00        ;!\ initial events cleared
    db $00,$00,$00,$00,$00,$00,$00            ;!/
    db !Submap_Main                           ;!\ initial players submap
    db !Submap_Main                           ;!/
    dw 2                                      ;!\ initial players animation
    dw 2                                      ;!/
    dw $148,$58                               ;!\ initial players position
    dw $148,$58                               ;!/
    dw $148>>4,$58>>4                         ;!\ initial players position / $10
    dw $148>>4,$58>>4                         ;!/
    db 1,1,0,1                                ;! initial switch palaces
.Zone5:                                       ;!
    db $7F,$6F,$05,$F8,$0D,$C0,$00,$00        ;!\ initial events cleared
    db $00,$00,$00,$00,$00,$00,$00            ;!/
    db !Submap_ForestOfIllusion               ;!\ initial players submap
    db !Submap_ForestOfIllusion               ;!/
    dw 2                                      ;!\ initial players animation
    dw 2                                      ;!/
    dw $88,$178                               ;!\ initial players position
    dw $88,$178                               ;!/
    dw $88>>4,$178>>4                         ;!\ initial players position / $10
    dw $88>>4,$178>>4                         ;!/
    db 1,1,0,1                                ;! initial switch palaces
.Zone6:                                       ;!
    db $7F,$6F,$05,$F8,$0D,$ED,$01,$00        ;!\ initial events cleared
    db $00,$00,$00,$00,$40,$00,$00            ;!/
    db !Submap_Main                           ;!\ initial players submap
    db !Submap_Main                           ;!/
    dw 2                                      ;!\ initial players animation
    dw 2                                      ;!/
    dw $188,$168                              ;!\ initial players position
    dw $188,$168                              ;!/
    dw $188>>4,$168>>4                        ;!\ initial players position / $10
    dw $188>>4,$168>>4                        ;!/
    db 1,1,1,1                                ;! initial switch palaces
.Zone7:                                       ;!
    db $7F,$6F,$05,$F8,$0D,$ED,$01,$00        ;!\ initial events cleared
    db $02,$7C,$00,$00,$70,$00,$00            ;!/
    db !Submap_Main                           ;!\ initial players submap
    db !Submap_Main                           ;!/
    dw 2                                      ;!\ initial players animation
    dw 2                                      ;!/
    dw $E8,$178                               ;!\ initial players position
    dw $E8,$178                               ;!/
    dw $E8>>4,$178>>4                         ;!\ initial players position / $10
    dw $E8>>4,$178>>4                         ;!/
    db 1,1,1,1                                ;! initial switch palaces
.End:                                         ;!
                                              ;!
#InitOWEventPlayerDataIndices:                ;!
    dw .Zone2-InitOWEventPlayerData-1         ;!
    dw .Zone3-InitOWEventPlayerData-1         ;!
    dw .Zone4-InitOWEventPlayerData-1         ;!
    dw .Zone5-InitOWEventPlayerData-1         ;!
    dw .Zone6-InitOWEventPlayerData-1         ;!
    dw .Zone7-InitOWEventPlayerData-1         ;!
    dw .End-InitOWEventPlayerData-1           ;!
                                              ;!
InitSaveData:                                 ;!
    LDX.B #!SaveFileSize-2                    ;!\
  - STZ.W SaveDataBuffer-1,X                  ;!| Initialize all values to zero
    DEX                                       ;!|
    BNE -                                     ;!/
                                              ;!
    LDX.W SelectedStartingZone                ;!\
    LDA.W InitLevelTileMoveIndices+1,X        ;!| Unlock movement directions on certain level tiles
    STA.B _0                                  ;!| Up to the current zone
    LDA.W InitLevelTileMoveIndices            ;!|
    TAX                                       ;!|
  - LDY.W InitLevelTileMovementData,X         ;!|
    LDA.W InitLevelTileMovementData+1,X       ;!|
    STA.W SaveDataBuffer,Y                    ;!|
    INX #2                                    ;!|
    CPX.B _0                                  ;!|
    BNE -                                     ;!/
                                              ;!
    REP #$30                                  ;!\ AXY->16
    LDA.W SelectedStartingZone                ;!|
    ASL A                                     ;!| Initialize overworld event table
    TAX                                       ;!| And player overworld data
    LDY.W InitOWEventPlayerDataIndices,X      ;!|
    LDX.W #41-1                               ;!|
  - LDA.W InitOWEventPlayerData,Y             ;!|
    STA.W SaveDataBufferEvents,X              ;!|
    DEY                                       ;!|
    DEX                                       ;!|
    BPL -                                     ;!/
                                              ;!
    SEP #$30                                  ;! AXY->8
    RTS                                       ;!
endif                                         ;/===============================================

KeepGameModeActive:                           ; This game mode will last 1 more frame
    LDA.B #1
CODE_009F2B:
    STA.W KeepModeActive
    RTS

BrightnessRate:
    db 1,-1
MosaicRate:
    db -1<<4,1<<4
BrightnessLimits:
    db 15,0
MosaicLimits:                                 ; unused
    db 0<<4,15<<4

GMTransitionMosaic:
    DEC.W KeepModeActive
    BPL Return009F6E
    JSR KeepGameModeActive
    LDY.W MosaicDirection                     ;\
    LDA.W MosaicSize                          ;| Adjust mosaic size
    CLC                                       ;|
    ADC.W MosaicRate,Y                        ;|
    STA.W MosaicSize                          ;/

CODE_009F4C:
    LDA.W Brightness                          ;\
    CLC                                       ;| Adjust brightness
    ADC.W BrightnessRate,Y                    ;|
    STA.W Brightness                          ;/
    CMP.W BrightnessLimits,Y
    BNE +

NextGameModeMosaic:
    INC.W GameMode                            ; Go to next game mode
    LDA.W MosaicDirection                     ;\ Reverse direction of mosaic
    EOR.B #1                                  ;|
    STA.W MosaicDirection                     ;/
  + LDA.B #%00000011                          ;\ Apply the mosaic
    ORA.W MosaicSize                          ;| to BG1 and BG2 only
    STA.W HW_MOSAIC                           ;/

Return009F6E:
    RTS

GMTransitionFade:
    DEC.W KeepModeActive
    BPL Return009F6E
    JSR KeepGameModeActive
CODE_009F77:
    LDY.W MosaicDirection
    BRA CODE_009F4C                           ; Adjust brightness but not mosaic

 
GM28FadeInTheEnd:                             ; Game Mode 28
    DEC.W KeepModeActive                      ; same as TransitionFade but it takes 8 frames
    BPL Return009F6E                          ; per increase in brightness level
    LDA.B #8
    JSR CODE_009F2B
    BRA CODE_009F77

Layer3TilemapSettings:                        ; Layer 3 settings. Three setting values per Layer 1 tileset.
    db !Tide_UpAndDown,!Tide_Stationary,$C0
    db !Tide_UpAndDown,$80,$81
    db !Tide_UpAndDown,!Tide_Stationary,$C0
    db !Tide_UpAndDown,!Tide_Stationary,$81
    db !Tide_UpAndDown,!Tide_Stationary,$80
    db !Tide_UpAndDown,!Tide_Stationary,$81
    db !Tide_UpAndDown,!Tide_Stationary,$81
    db !Tide_UpAndDown,!Tide_Stationary,$C0
    db !Tide_UpAndDown,!Tide_Stationary,$C0
    db !Tide_UpAndDown,!Tide_Stationary,$81
    db !Tide_UpAndDown,!Tide_Stationary,$80
    db !Tide_UpAndDown,!Tide_Stationary,$80
    db !Tide_UpAndDown,!Tide_Stationary,$80
    db !Tide_UpAndDown,!Tide_Stationary,$81
    db !Tide_UpAndDown,!Tide_Stationary,$81
    db !Tide_UpAndDown,!Tide_Stationary,$80   ; unreachable tileset

CODE_009FB8:                                  ;The main Layer 3 handling routine for levels.
    LDA.W ObjectTileset                       ;\
    ASL A                                     ;| Get (Tileset*3), store in $00
    CLC                                       ;|
    ADC.W ObjectTileset                       ;|
    STA.B _0                                  ;/
    LDA.W Layer3Setting                       ;\ Branch if the level does not have Layer 3.
    BEQ CODE_00A012                           ;/
    DEC A
    CLC
    ADC.B _0
    TAX
    LDA.W Layer3TilemapSettings,X
    BMI CODE_009FEA
    STA.W Layer3TideSetting
    LSR A
    PHP
    JSR CODE_00A045
    LDA.B #$70                                ; Starting Y position of the high/low Layer 3 tide.
    PLP
    BEQ +
    LDA.B #$40                                ; Y position of the normal Layer 3 tide.
  + STA.B Layer3YPos
    STZ.B Layer3YPos+1
    JSL CODE_05BC72
    BRA CODE_00A01B

CODE_009FEA:
    ASL A
    BMI CODE_00A012
    BEQ CODE_00A007
    LDA.W ObjectTileset                       ;\ Tilesets for which the tileset-specific Layer 3 background will not autoscroll
    CMP.B #!ObjTileset_Castle1                ;|
    BEQ CODE_009FFA                           ;|
    CMP.B #!ObjTileset_Underground1           ;/
    BNE CODE_00A01F
CODE_009FFA:
    REP #$20                                  ; A->16
    LDA.B Layer1XPos
    LSR A
    STA.B Layer3XPos
    SEP #$20                                  ; A->8
    LDA.B #$C0
    BRA CODE_00A017

CODE_00A007:
    LDX.B #7                                  ; Handle crusher.
  - LDA.W BigCrusherColors,X                  ; Upload the Layer 3 crusher palette.
    STA.W MainPalette+$18,X
    DEX
    BPL -
CODE_00A012:
    INC.W Layer3ScrollType                    ; Level does not have Layer 3.
    LDA.B #$D0
CODE_00A017:
    STA.B Layer3YPos                          ; Set initial Y position of Layer 3.
    STZ.B Layer3YPos+1
CODE_00A01B:
    LDA.B #%00000100
    TRB.B ColorSettings
CODE_00A01F:
    LDA.W Layer3Setting
    BEQ +
    DEC A
    CLC
    ADC.B _0
    STA.B _1
    ASL A
    CLC
    ADC.B _1
    TAX
    LDA.L Layer3Ptr,X
    STA.B _0
    LDA.L Layer3Ptr+1,X
    STA.B _1
    LDA.L Layer3Ptr+2,X
    STA.B _2
    JSR LoadStripeImage
  + RTS

CODE_00A045:
    REP #$30                                  ; AXY->16; Interaction routine for the tides.
    LDX.W #$0100
CODE_00A04A:
    LDY.W #$0058
    LDA.W #$0000                              ; Tile that the tides act like (water).
  - STA.L OWLayer1VramBuffer-$100,X
    INX
    INX                                       ; Fill row with water.
    DEY
    BNE -
    TXA
    CLC
    ADC.W #$0100                              ; Repeat for all applicable rows.
    TAX
    CPX.W #$1B00
    BCC CODE_00A04A
    SEP #$30                                  ; AXY->8
    LDA.B #!ScrMode_EnableL2Int               ; Enable collision with layer 3.
    TSB.B ScreenMode
    RTS


DATA_00A06B:
    dw $0000,$FFEF,$FFEF,$FFEF
    dw $00F0,$00F0,$00F0

DATA_00A079:
    dw $0000,$FFD8,$0080,$0128
    dw $FFD8,$0080,$0128

GM0CLoadOverworld:
; 16-bit X-coordinates for each of the submaps. The main map is handled elsewhere.
; 16-bit Y-coordinates for each of the submaps. The main map is handled elsewhere.
    JSR TurnOffIO                             ; Game Mode 0C - Load Overworld
    LDA.W EnteringStarWarp
    BEQ +                                     ; If warping via a pipe/star, store the destination positions to Mario's position.
    JSL CODE_04853B
  + JSR Clear_1A_13D3                         ; Clean out a large chunk of RAM.
    LDA.W OverworldOverride                   ; Branch if overworld loading isn't being overridden by a level (for e.g. intro).
    BEQ +
    LDA.B #con($B0,$B0,$B0,$90,$90)           ; How many frames (divided by 4) to wait before the intro message can be skipped.
    STA.W VariousPromptTimer
    STZ.W OWPlayerSubmap
    LDA.B #$F0                                ; Set the mosaic size.
    STA.W MosaicSize
    LDA.B #$10                                ; Switch to game mode 10 - Fade to Level (black)
    STA.W GameMode
    JMP Mode04Finish                          ; Re-enable NMI and auto-joypad read.

; Loading the overworld.
  + JSR ClearOutLayer3                        ; Clean out Layer 3.
    JSR UploadMusicBank1                      ; Upload the overworld music bank.
    JSR SetUpScreen                           ; Set up various registers (screen mode, CGADDSUB, windows...).
    STZ.W MusicBackup                         ; Clear the music register backup.
    LDX.W PlayerTurnLvl
    LDA.W PlayerLives
if ver_is_console(!_VER)                      ;\================ J, U, E0, & E1 ===============
    BPL +                                     ;!; Preserve the current player's lives. If 0, prepare the swap lives window.
    INC.W OverworldPromptProcess              ;!
endif                                         ;/===============================================
  + STA.W SavedPlayerLives,X
    LDA.B Powerup                             ; Preserve the current player's powerup.
    STA.W SavedPlayerPowerup,X
    LDA.W PlayerCoins                         ; Preserve the current player's coin count.
    STA.W SavedPlayerCoins,X
    LDA.W CarryYoshiThruLvls
    BEQ +
    LDA.W YoshiColor                          ; Preserve the current player's Yoshi.
  + STA.W SavedPlayerYoshi,X
    LDA.W PlayerItembox                       ; Preserve the current player's item box item.
    STA.W SavedPlayerItembox,X
    LDA.B #$03                                ; Set color math settings (add subscreen, direct color mode)
    STA.B ColorAddition
    LDA.B #$30                                ; Overworld CGADSUB setting.
    LDX.B #$15                                ; Overworld main screen designation.
    LDY.W ShowContinueEnd                     ; Branch if not set to show the continue/end screen.
    BEQ CODE_00A11B
if ver_is_console(!_VER)                      ;\================= J, U, E0, & E1 ==============
    JSR CopyFromSaveBuffer                    ;!; Transfer the SRAM buffer to RAM.
    LDA.W ExitsCompleted                      ;!; Branch if there is at least one event beaten.
    BNE +                                     ;!
    JSR FadeOutBackToTitle                    ;!
    JMP CODE_0093F4                           ;!
                                              ;!
; Game over screen is being shown.
  + JSL DecompressOverworldL2                 ;!; Decompress the overworld Layer 2 data and upload to RAM.
    REP #$20                                  ;! A->16
    LDA.W #$318C                              ;!
    STA.W BackgroundColor                     ;!
    SEP #$20                                  ;! A->8
    LDA.B #$30                                ;!
    STA.B OBJCWWindow                         ;!
    LDA.B #$20                                ;!
    STA.B ColorAddition                       ;!
    LDA.B #$B3                                ;!
    LDX.B #$17                                ;!
else                                          ;<======================== SS ===================
    JSR FadeOutBackToTitle                    ;!
    JMP CODE_0093F4                           ;!
endif                                         ;/===============================================
CODE_00A11B:
    LDY.B #$02                                ; Overworld subscreen designation.
    JSR ScreenSettings
    STX.W HW_TMW                              ; Set up CGADSUB, main/sub screen designation, and windowing.
    STY.W HW_TSW
    JSL CODE_04DC09                           ; Upload the overworld Layer 1 tilemap.
    LDX.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,X
    ASL A
    TAX
    REP #$20                                  ; A->16
    LDA.W DATA_00A06B,X                       ; Move the camera the the appropriate spot for the submap.
    STA.B Layer1XPos
    STA.B Layer2XPos
    LDA.W DATA_00A079,X
    STA.B Layer1YPos
    STA.B Layer2YPos
    SEP #$20                                  ; A->8
    JSR UploadSpriteGFX                       ; Upload GFX files.
    LDY.B #$14                                ; Decompress GFX14 to RAM.
    JSL PrepareGraphicsFile
    JSR CODE_00AD25                           ; Upload overworld palettes to CGRAM.
    JSR CODE_00922F
    LDA.B #$06                                ; \ Load overworld border
    STA.B StripeImage                         ; |
    JSR LoadScrnImage                         ; /; Upload the overworld border and life counter.
    JSL CODE_05DBF2
    JSR LoadScrnImage
    JSL CODE_048D91                           ; Initialize the level name/sprites of the overworld border, animated tiles, music, and player poses.
    JSL CODE_04D6E9                           ; Upload Layer 1 to VRAM.
    LDA.B #$F0
    STA.B OAMAddress
    JSR ConsolidateOAM                        ; Prep OAM for upload.
    JSR LoadScrnImage                         ; Upload tilemap data from $12.
    STZ.W OverworldProcess
    JSR KeepGameModeActive
    LDA.B #!IRQNMI_Overworld
    STA.W IRQNMICommand
    REP #$10                                  ; XY->16
    LDX.W #con($01BE,$01BE,$01BE,$01BE,$01DE)
    LDA.B #$FF
  - STZ.W WindowTable,X
    STA.W WindowTable+1,X
    DEX
    DEX
    BPL -
    JSR EnableWindowHDMA
    JMP CODE_0093F4

CopyFromSaveBuffer:
    REP #$10                                  ; XY->16; Subroutine to transfer the SRAM buffer to RAM.
    LDX.W #$008C                              ; Transfer to $1EA2-$1F2E.
  - LDA.W SaveDataBuffer,X
    STA.W OWLevelTileSettings,X               ; Perform the transfer.
    DEX
    BPL -
    SEP #$10                                  ; XY->8
    RTS

Clear_1A_13D3:
    REP #$10                                  ; XY->16; Clear RAM addresses $1A-$D7 and $13D3-$1BA1 (on overworld / cutscene load).
    SEP #$20                                  ; A->8
    LDX.W #$00BD                              ; \
  - STZ.B Layer1XPos,X                        ; |Clear RAM addresses $1A-$D7; Clear out $1A-$D7.
    DEX                                       ; |
    BPL -                                     ; /
    LDX.W #$07CE                              ; \
  - STZ.W PauseTimer,X                        ; |Clear RAM addresses $13D3-$1BA1; Clear out $13D3-$1BA1.
    DEX                                       ; |
    BPL -                                     ; /
    SEP #$10                                  ; XY->8
    RTS

GM0EOverworld:
; Game Mode 0E - Overworld
    JSR DetermineJoypadInput                  ; Get the current controller port to accept data from.
    INC.B EffFrame                            ; Increase alternate frame counter; Increment the effective frame counter.
    JSL OAMResetRoutine                       ; Clear OAM.
    JSL GameMode_0E_Prim                      ; (Bank 4.asm); Run primary routine.
    JMP ConsolidateOAM                        ; Prep OAM for upload.


GrndShakeDispYLo:
    db $FE,$00,$02,$00

GrndShakeDispYHi:
    db $FF,$00,$00,$00

    db $12,$22,$12,$02

GM14Level:
; Offsets for the screen shake effect (lo). LM merges with the below into 16-bit values.
; Offsets for the screen shake effect (hi).
; Game Mode 14 - Level
    LDA.W MessageBoxTrigger                   ; Branch if not showing a message box.
    BEQ +
    JSL CODE_05B10C                           ; Handle the message box.
    RTS

  + LDA.W BonusGameActivate                   ; Not showing a message box.
    BEQ +
    LDA.W BonusFinishTimer
    BEQ +
    CMP.B #con($40,$40,$40,$48,$48)
    BCS +
    JSR NoButtons
    CMP.B #con($1C,$1C,$1C,$24,$24)
    BCS +
    JSR SetMarioPeaceImg
    LDA.B #$0D
    STA.B PlayerAnimation
  + ORA.B PlayerAnimation
    ORA.W EndLevelTimer
    BEQ +
    LDA.B #$04
    TRB.B byetudlrHold
    LDA.B #$40
    TRB.B byetudlrFrame
    TRB.B axlr0000Frame
  + LDA.W PauseTimer
    BEQ CODE_00A21B
    DEC.W PauseTimer
    BRA CODE_00A242

CODE_00A21B:
    LDA.B byetudlrFrame
    AND.B #$10                                ; Button to press to pause the game (start)
    BEQ CODE_00A242
    LDA.W EndLevelTimer
    BNE CODE_00A242
    LDA.B PlayerAnimation
    CMP.B #$09
    BCS CODE_00A242
    LDA.B #$3C                                ; Number of frames to wait before registering the start button again.
    STA.W PauseTimer
    LDY.B #!SFX_UNPAUSE
    LDA.W PauseFlag
    EOR.B #$01                                ; Invert the pause flag.
    STA.W PauseFlag
    BEQ +                                     ; Play the appropriate SFX for pausing/unpausing.
    LDY.B #!SFX_PAUSE
  + STY.W SPCIO0
CODE_00A242:
    LDA.W PauseFlag                           ; Branch if the game is not paused.
    BEQ CODE_00A28A
    BRA CODE_00A25B                           ; [change to BRA #$00 to enable frame advance/slomo]

    BIT.W byetudlrP2Frame                     ; \ Unreachable; DEBUG: Frame advance / Slow down.
    BVS ADDR_00A259                           ; | Debug: Slow motion; Using controller 2:
    LDA.W byetudlrP2Hold                      ; |; Tap Y to advance one frame.
    BPL CODE_00A25B                           ; |; Hold B to run at 1/16th speed.
    LDA.B TrueFrame                           ; |
    AND.B #$0F                                ; |; Speed of slow-motion.
    BNE CODE_00A25B                           ; |
ADDR_00A259:
    BRA CODE_00A28A                           ; /

CODE_00A25B:
if ver_is_console(!_VER)                      ;\================== J, U, E0, & E1 =============
    LDA.B byetudlrHold                        ;!; Code to handle exiting the level by Start+Select.
    AND.B #$20                                ;!
    BEQ Return00A289                          ;!; Return if:
    LDY.W TranslevelNo                        ;!; Select not pressed
    LDA.W OWLevelTileSettings,Y               ;!; Level not already beaten
    BPL Return00A289                          ;!; Level is being beaten (?)
    LDA.W OWLevelExitMode                     ;!
    BEQ CODE_00A270                           ;!
    BPL Return00A289                          ;!
CODE_00A270:                                  ;!
    LDA.B #$80                                ;!
    BRA CODE_00A27E                           ;!; [change to BRA #$00 to activate the normal/secret exit with start+select (+A)]
                                              ;!
    LDA.B #$01                                ;! \ Unreachable; DEBUG: beat level with start+select.
    BIT.B byetudlrHold                        ;! | Debug: Beat level with Start+Select
    BPL +                                     ;! |; Start + select: Normal exit
    INC A                                     ;! /; Start + select + A: Secret exit.
  + STA.W MidwayFlag                          ;!
CODE_00A27E:                                  ;!
    STA.W OWLevelExitMode                     ;!; Fade to overworld. Value in A determines what exit to take.
    INC.W CreditsScreenNumber                 ;!; Indicate event should activate on overworld load.
    LDA.B #$0B                                ;!; Change game mode to 0B (fade to black).
    STA.W GameMode                            ;!
endif                                         ;/===============================================
Return00A289:
    RTS

CODE_00A28A:
; Game is not paused.
    LDA.W IRQNMICommand                       ; Branch if not in a Mode 7 rooms.
    BPL +
    JSR CODE_00987D
    JMP CODE_00A2A9

; Not a Mode 7 room.
  + JSL OAMResetRoutine                       ; Clear out OAM.
    JSL UpdateScreenPosition
    JSL ProcScreenScrollCmds                  ; Handle scrolling the layers.
    JSL CODE_0586F1
    JSL CODE_05BB39                           ; Handle tile animation.
CODE_00A2A9:
    LDA.B Layer1YPos
    PHA
    LDA.B Layer1YPos+1
    PHA
    STZ.W ScreenShakeYOffset                  ; \ Reset amout to shift level
    STZ.W ScreenShakeYOffset+1                ; /
    LDA.W ScreenShakeTimer                    ; \ If shake ground timer is set
    BEQ +                                     ; |
    DEC.W ScreenShakeTimer                    ; | Decrement timer
    AND.B #$03                                ; |; Handle shaking the screen.
    TAY                                       ; |; [LM modifies this routine to use 16-bit instead of 8-bit]
    LDA.W GrndShakeDispYLo,Y                  ; |
    STA.W ScreenShakeYOffset                  ; | $1888-$1889 = Amount to shift level
    CLC                                       ; |
    ADC.B Layer1YPos                          ; |
    STA.B Layer1YPos                          ; | Adjust screen boundry accordingly
    LDA.W GrndShakeDispYHi,Y                  ; |
    STA.W ScreenShakeYOffset+1                ; |
    ADC.B Layer1YPos+1                        ; |
    STA.B Layer1YPos+1                        ; /
  + JSR UpdateStatusBar                       ; Update the status bar.
    JSL DrawMarioAndYoshi                     ; Draw Mario/Yoshi.
    JSR AdvancePlayerPosition                 ; Update Mario's position mirrors ($D1/$D3).
    JSR CODE_00C47E                           ; Handle various gameplay-related routines (Mario-object interaction, level end, P-switches, etc).
    JSL CODE_01808C                           ; Run standard and cluster sprite routines.
    JSL CODE_028AB1                           ; Run routines for various other sprite types, as well as handle loading new sprites.
    PLA
    STA.B Layer1YPos+1
    PLA
    STA.B Layer1YPos
    JMP ConsolidateOAM                        ; Prep OAM for upload.

AdvancePlayerPosition:
    REP #$20                                  ; A->16; Routine to update Mario's position mirrors.
    LDA.B PlayerXPosNext
    STA.B PlayerXPosNow
    LDA.B PlayerYPosNext
    STA.B PlayerYPosNow
    SEP #$20                                  ; A->8
    RTS

MarioGFXDMA:
    REP #$20                                  ; A->16; Routine that handles the graphics DMA for the player/Yoshi/Podoboo tiles, as well as the player's palette.
    LDX.B #$04                                ; We're using DMA channel 2
    LDY.W PlayerGfxTileCount                  ; If the Nintendo Presents is currently loaded, skip the DMA to load the palette.
    BEQ +
    LDY.B #$86                                ; \ Set Address for CG-RAM Write to x86
    STY.W HW_CGADD                            ; /
    LDA.W #$2200                              ; Upload to CGRAM.
    STA.W HW_DMAPARAM+$20
    LDA.W PlayerPalletePtr                    ; \ Get location of palette from $0D82-$0D83
    STA.W HW_DMAADDR+$20                      ; /; Store the palette source to the registers.
    LDY.B #$00                                ; \ Palette is stored in bank x00; $00B2C8 (M), $00B2DC (L), $00B2F0 (FM), $00B304 (FL).
    STY.W HW_DMAADDR+$22                      ; /
    LDA.W #$0014                              ; \ x14 bytes will be transferred; Number of colors (x2) in Mario/Luigi's palettes.
    STA.W HW_DMACNT+$20                       ; /
    STX.W HW_MDMAEN                           ; Transfer the colors; Enable DMA on channel 2.
  + LDY.B #$80                                ; \ Set VRAM Address Increment Value to x80; Address increment mode.
    STY.W HW_VMAINC                           ; /
    LDA.W #$1801                              ; Set transfer method.
    STA.W HW_DMAPARAM+$20
    LDA.W #$67F0                              ; Write to tile x7F in SP1.
    STA.W HW_VMADD
    LDA.W DynGfxTile7FPtr
    STA.W HW_DMAADDR+$20                      ; Upload the misc cape tile.
    LDY.B #$7E                                ; \ Set bank to x7E
    STY.W HW_DMAADDR+$22                      ; /
    LDA.W #$0020                              ; \ x20 bytes will be transferred; Write x20 bytes (1 tile)
    STA.W HW_DMACNT+$20                       ; /
    STX.W HW_MDMAEN                           ; Transfer; Enable DMA on channel 2.
    LDA.W #$6000                              ; \ Set Address for VRAM Read/Write to x6000; Write the next set of tiles to the first row of SP1.
    STA.W HW_VMADD                            ; /
    LDX.B #$00
  - LDA.W DynGfxTilePtr,X                     ; \ Get address of graphics to copy; Upload the top halves of the player/Yoshi/Podoboo tiles.
    STA.W HW_DMAADDR+$20                      ; /
    LDA.W #$0040                              ; \ x40 bytes will be transferred; Upload x40 bytes (2 tiles)
    STA.W HW_DMACNT+$20                       ; /
    LDY.B #$04                                ; \ Transfer; Enable DMA on channel on channel 2.
    STY.W HW_MDMAEN                           ; /
    INX                                       ; \ Move to next address
    INX                                       ; /
    CPX.W PlayerGfxTileCount                  ; \ Repeat last segment while X<$0D84
    BCC -                                     ; /
    LDA.W #$6100                              ; \ Set Address for VRAM Read/Write to x6100; Write the next set of tiles to the second row of SP1.
    STA.W HW_VMADD                            ; /
    LDX.B #$00
  - LDA.W DynGfxTilePtr+$0A,X                 ; \ Get address of graphics to copy; Upload the bottom halves of the player/Yoshi/Podoboo tiles.
    STA.W HW_DMAADDR+$20                      ; /
    LDA.W #$0040                              ; \ x40 bytes will be transferred; Upload x40 bytes (2 tiles)
    STA.W HW_DMACNT+$20                       ; /
    LDY.B #$04                                ; \ Transfer; Enable DMA on channel on channel 2.
    STY.W HW_MDMAEN                           ; /
    INX                                       ; \ Move to next address
    INX                                       ; /
    CPX.W PlayerGfxTileCount                  ; \ Repeat last segment while X<$0D84
    BCC -                                     ; /
    SEP #$20                                  ; A->8
    RTS

CODE_00A390:
    REP #$20                                  ; A->16; Routine for DMAing animated tiles?
    LDY.B #$80
    STY.W HW_VMAINC
    LDA.W #$1801
    STA.W HW_DMAPARAM+$20
    LDY.B #$7E
    STY.W HW_DMAADDR+$22
    LDX.B #$04
    LDA.W Gfx33DestAddrC
    BEQ +
    STA.W HW_VMADD
    LDA.W Gfx33SrcAddrC
    STA.W HW_DMAADDR+$20
    LDA.W #$0080
    STA.W HW_DMACNT+$20
    STX.W HW_MDMAEN
  + LDA.W Gfx33DestAddrB
    BEQ +
    STA.W HW_VMADD
    LDA.W Gfx33SrcAddrB
    STA.W HW_DMAADDR+$20
    LDA.W #$0080
    STA.W HW_DMACNT+$20
    STX.W HW_MDMAEN
  + LDA.W Gfx33DestAddrA
    BEQ CODE_00A418
    STA.W HW_VMADD
    CMP.W #$0800
    BEQ CODE_00A3F0
    LDA.W Gfx33SrcAddrA
    STA.W HW_DMAADDR+$20
    LDA.W #$0080
    STA.W HW_DMACNT+$20
    STX.W HW_MDMAEN
    BRA CODE_00A418

CODE_00A3F0:
    LDA.W Gfx33SrcAddrA
    STA.W HW_DMAADDR+$20
    LDA.W #$0040
    STA.W HW_DMACNT+$20
    STX.W HW_MDMAEN
    LDA.W #$0900
    STA.W HW_VMADD
    LDA.W Gfx33SrcAddrA
    CLC
    ADC.W #$0040
    STA.W HW_DMAADDR+$20
    LDA.W #$0040
    STA.W HW_DMACNT+$20
    STX.W HW_MDMAEN
CODE_00A418:
    SEP #$20                                  ; A->8
    LDA.B #$64
CODE_00A41C:
    STZ.B _0
CODE_00A41E:
    STA.W HW_CGADD
    LDA.B EffFrame
    AND.B #$1C
    LSR A
    ADC.B _0
    TAY
    LDA.W FlashingColors,Y
    STA.W HW_CGDATA
    LDA.W FlashingColors+1,Y
    STA.W HW_CGDATA
    RTS

CODE_00A436:
; Routine to restore tiles 4A-4F and 5A-5F after the MARIO START! message, using data from $0BF6.
    LDA.W MarioStartFlag                      ; Return if not restoring the above tiles.
    BEQ +
    STZ.W MarioStartFlag
    REP #$20                                  ; A->16
    LDY.B #$80
    STY.W HW_VMAINC
    LDA.W #$64A0                              ; Prepare DMA to VRAM address $64A0 (tiles 4A-4F in SP1).
    STA.W HW_VMADD
    LDA.W #$1801
    STA.W HW_DMAPARAM+$20
    LDA.W #$0BF6
    STA.W HW_DMAADDR+$20                      ; Set source address to $0BF6.
    LDY.B #$00
    STY.W HW_DMAADDR+$22
    LDA.W #$00C0                              ; Set size to 0xC0 bytes.
    STA.W HW_DMACNT+$20
    LDX.B #$04
    STX.W HW_MDMAEN
    LDA.W #$65A0                              ; Prepare DMA to VRAM address $65A0 (tiles 5A-5F in SP1).
    STA.W HW_VMADD
    LDA.W #$0CB6                              ; Set source address to $0CB6.
    STA.W HW_DMAADDR+$20
    LDA.W #$00C0                              ; Set size to 0xC0 bytes.
    STA.W HW_DMACNT+$20
    STX.W HW_MDMAEN
    SEP #$20                                  ; A->8
  + RTS


DATA_00A47F:
    dl DynPaletteTable
    dl CopyPalette
    dl MainPalette

CODE_00A488:
; Pointers to the different palette mirrors in RAM.
    LDY.W PaletteIndexTable                   ; Routine to upload the palette to CGRAM.
    LDX.W DATA_00A47F+2,Y
    STX.B _2                                  ; Store base pointer... or at least, only the bank byte of it.
    STZ.B _1                                  ; (the low/high bytes are received from Y)
    STZ.B _0
    STZ.B _4                                  ; Clear $04 for no reason?
    LDA.W DATA_00A47F+1,Y
    XBA
    LDA.W DATA_00A47F,Y                       ; Load the low and high bytes into Y.
    REP #$10                                  ; XY->16
    TAY
CODE_00A4A0:
    LDA.B [_0],Y                              ; Branch if the first color has a low byte of 00.
    BEQ CODE_00A4CF                           ; Otherwise, use it as the number of colors to force-upload.
    STX.W HW_DMAADDR+$22
    STA.W HW_DMACNT+$20
    STA.B _3
    STZ.W HW_DMACNT+$21
    INY
    LDA.B [_0],Y                              ; Use the high byte of the first color as the starting color to upload to.
    STA.W HW_CGADD
    REP #$20                                  ; A->16
    LDA.W #$2200                              ; Set data to upload to $2122 (CGRAM).
    STA.W HW_DMAPARAM+$20
    INY
    TYA                                       ; Set source address.
    STA.W HW_DMAADDR+$20
    CLC
    ADC.B _3
    TAY
    SEP #$20                                  ; A->8
    LDA.B #$04                                ; Enable DMA.
    STA.W HW_MDMAEN
    BRA CODE_00A4A0                           ; If Y points to another set of colors to upload, repeat this process (else continue below).

CODE_00A4CF:
    SEP #$10                                  ; XY->8; Not forcing a palette upload.
    JSR CODE_00AE47                           ; Upload back area color.
    LDA.W PaletteIndexTable
    BNE +
    STZ.W DynPaletteIndex
    STZ.W DynPaletteTable
  + STZ.W PaletteIndexTable
  - RTS

CODE_00A4E3:
    REP #$10                                  ; XY->16; DMA to upload animated overworld tiles from $0AF6, as well as the palette when switching overworld submaps.
    LDA.B #$80
    STA.W HW_VMAINC
    LDY.W #$0750                              ; Prepare DMA to VRAM address $0750 (tile 75 in FG1).
    STY.W HW_VMADD
    LDY.W #$1801
    STY.W HW_DMAPARAM+$20
    LDY.W #GfxDecompOWAni
    STY.W HW_DMAADDR+$20                      ; Set source to $0AF6.
    STZ.W HW_DMAADDR+$22
    LDY.W #$0160                              ; Set size to 0x160 bytes (16 tiles).
    STY.W HW_DMACNT+$20
    LDA.B #$04
    STA.W HW_MDMAEN
    SEP #$10                                  ; XY->8
    LDA.W OverworldProcess
    CMP.B #$0A                                ; If not switching overworld submaps, also upload animated colors.
    BEQ -
    LDA.B #$6D                                ; Overworld animated color A (6D).
    JSR CODE_00A41C
    LDA.B #$10
    STA.B _0
    LDA.B #$7D                                ; Overworld animated color B (7D).
    JMP CODE_00A41E


DATA_00A521:
    db $00,$04,$08,$0C
DATA_00A525:
    db $00,$08,$10,$18

CODE_00A529:
    LDA.B #$80                                ; Routine when switching overworld submaps to upload Layer 1 and palette data?
    STA.W HW_VMAINC
    STZ.W HW_VMADD
    LDA.B #$30
    CLC
    ADC.W DATA_00A521,Y
    STA.W HW_VMADD+1
    LDX.B #$06
  - LDA.W DATA_00A586,X
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
  + LDA.W HW_DMAADDR+$11
    CLC
    ADC.W DATA_00A525,Y
    STA.W HW_DMAADDR+$11
    LDA.B #$02
    STA.W HW_MDMAEN
    LDA.B #$80
    STA.W HW_VMAINC
    STZ.W HW_VMADD
    LDA.B #$20
    CLC
    ADC.W DATA_00A521,Y
    STA.W HW_VMADD+1
    LDX.B #$06
  - LDA.W DATA_00A58D,X
    STA.W HW_DMAPARAM+$10,X
    DEX
    BPL -
    LDA.B #$02
    STA.W HW_MDMAEN
    RTS


DATA_00A586:
    db $01,$18
    dl OWLayer2Tilemap
    dw $0800

DATA_00A58D:
    db $01,$18
    dl OWLayer1VramBuffer
    dw $0800

CODE_00A594:
    PHB                                       ; Wrapper
    PHK
    PLB
    JSR CODE_00AD25
    PLB
    RTL

GM12PrepLevel:
; Game Mode 12 - Prepare Level (also used in loading title screen, YH in credits)
    JSR ClearOutLayer3                        ; gah, stupid keyboard >_<; Clean out Layer 3.
    JSR NoButtons                             ; Disable input.
    STZ.W UploadMarioStart
    JSR SetUpScreen                           ; Set up various registers (screen mode, CGADDSUB, windows...).
    JSR UploadStaticBar                       ; Upload the base status bar to VRAM.
    JSL CODE_05809E                           ; ->here; Upload Map16 data to VRAM.
    LDA.W IRQNMICommand                       ; Branch if loading a normal (non-Mode 7) level.
    BPL CODE_00A5B9
    JSR CODE_0097BC                           ; Working on this routine
    BRA +

CODE_00A5B9:
; Not a Mode 7 level.
    JSR UploadSpriteGFX                       ; Upload GFX files.
    JSR LoadPalette                           ; Load palette.
    JSL CODE_05BE8A                           ; Initialize Layer 3 settings.
    JSR CODE_009FB8                           ; Load Layer 3.
    JSR CODE_00A5F9                           ; Initialize animated tiles.
    JSR DisableHDMA                           ; Disable HDMA.
    JSR CODE_009860                           ; Draw Mario/Yoshi, process his object interaction, run sprite routines, and clear OAM.
  + JSR CODE_00922F                           ; Upload palettes to CGRAM.
    JSR KeepGameModeActive                    ; Keep mode active for a frame before any fadeouts.
    JSR UpdateStatusBar                       ; Update status bar.
    REP #$30                                  ; AXY->16
    PHB
    LDX.W #MainPalette
    LDY.W #CopyPalette
    LDA.W #$01EF
    MVN $00,$00                               ; Move palette data from $00903 to $00701.
    PLB
    LDX.W BackgroundColor
    STX.W CopyBGColor
    SEP #$30                                  ; AXY->8
    JSR CODE_00919B                           ; Prepare the No-Yoshi entrance (if applicable) and green star block count.
    JSR ConsolidateOAM                        ; Prep OAM for upload.
    JMP CODE_0093F4                           ; Increase game mode by 1, reenable interrupts, and return.

CODE_00A5F9:
    LDA.B #$E7                                ; Subroutine to handle animated 8x8 tiles.
    TRB.B EffFrame
  - JSL CODE_05BB39
    JSR CODE_00A390
    INC.B EffFrame
    LDA.B EffFrame
    AND.B #$07
    BNE -
    RTS


DATA_00A60D:
    dw $0100,$0101,$000D,$FFF3
    dw $FFFE,$FFFE,$0000,$0000

DATA_00A61D:
    db $0A,$00,$00,$00,$1A,$1A,$0A,$0A
DATA_00A625:
    db $00,$80,$40,$00,$01,$02,$40,$00
    db $40,$00,$00,$00,$00,$02,$00,$00

CODE_00A635:
; Directions of Mario when exiting from pipes. Indexed by $89 from $00A609.
; Amount of time to add to each pipe transition when riding Yoshi. Indexed by $89.
; Data on each of the tileset settings.
; Format: yy-- --cd
; yy = Which No-Yoshi sprite data to load. 00 = ghost house; 01 = rope; 10 = castle
; Setting c or d will make yellow/green ! blocks normal solid tiles.
    LDA.W BluePSwitchTimer                    ; If blue pow...; Routine on level load to initialize RAM and prepare Mario's entrance action.
    ORA.W SilverPSwitchTimer                  ; ...or silver pow...
    ORA.W DirectCoinTimer
    BNE CODE_00A64A
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario doesn't have star
    BEQ CODE_00A660                           ; /
    LDA.W MusicBackup
    BPL +
CODE_00A64A:
    LDA.W MusicBackup
    AND.B #$7F
  + ORA.B #$40
    STA.W MusicBackup
    STZ.W BluePSwitchTimer                    ; Zero out POW timer
    STZ.W SilverPSwitchTimer                  ; Zero out silver POW timer
    STZ.W DirectCoinTimer
    STZ.W InvinsibilityTimer                  ; Zero out star timer
CODE_00A660:
    LDA.W BonusRoomBlocks
    ORA.W BonusRoomBlocks+1
    ORA.W BonusRoomBlocks+2
    ORA.W BonusRoomBlocks+3
    ORA.W BonusRoomBlocks+4
    BEQ +
    STA.W DidPlayBonusGame
  + LDX.B #$23
  - STZ.B Map16HighPtr+2,X                    ; Clear RAM addresses $71-$93 (on level load).
    DEX
    BNE -
    LDX.B #$37
  - STZ.W OverworldProcess,X                  ; Clear RAM addresses $13DA-$1410 (on level load).
    DEX
    BNE -
    ASL.W UnusedStarCounter
    STZ.W KickingTimer
    STZ.W PickUpItemTimer
    STZ.W ColorFadeTimer
    STZ.W YoshiInPipeSetting
    LDY.B #$01
    LDX.W ObjectTileset
    CPX.B #$10
    BCS CODE_00A6CC
    LDA.W DATA_00A625,X
    LSR A
    BEQ CODE_00A6CC
    LDA.W ShowMarioStart
    ORA.W SublevelCount
    ORA.W DisableNoYoshiIntro
    BNE CODE_00A6CC
    LDA.W SkipMidwayCastleIntro
    BEQ CODE_00A6B6
    JSR CODE_00C90A
    BRA CODE_00A6CC

CODE_00A6B6:
    STZ.B PlayerInAir
    STY.B PlayerDirection
    STY.B NoYoshiInputTimer
    LDX.B #$0A
    LDY.B #$00
    LDA.W CarryYoshiThruLvls
    BEQ CODE_00A6C7
    LDY.B #$0F
CODE_00A6C7:
    STX.B PlayerAnimation
    STY.B PipeTimer
    RTS

CODE_00A6CC:
    LDA.B Layer1YPos
    CMP.B #$C0
    BEQ +
    INC.W VerticalScrollEnabled
  + LDA.W LevelEntranceType
    BEQ CODE_00A6E0                           ; Branch if not actions 0/5.
    CMP.B #$05
    BNE CODE_00A716                           ; For 05, make the level slippery.
    ROR.B LevelIsSlippery
CODE_00A6E0:
    STY.B PlayerDirection                     ; Mario Action 00, 05 - Normal level entrance
    LDA.B #$24                                ; Immediately 'fall' upon entering the level.
    STA.B PlayerInAir
    STZ.B SpriteLock
    LDA.W KeyholeTimer
    BEQ +
    LDA.W MusicBackup
    ORA.B #$7F
    STA.W MusicBackup
    LDA.B PlayerXPosNext                      ; If exiting by keyhole, reload music bank?...
    ORA.B #$04
    STA.W KeyholeXPos
    LDA.B PlayerYPosNext
    CLC
    ADC.B #$10
    STA.W KeyholeYPos
  + LDA.W YoshiHeavenFlag                     ; Return if not entering via Yoshi Wings.
    BEQ +
    LDA.B #$08                                ; \ Animation = Rise off screen,; Set Mario into the wings animation state (flying upwards).
    STA.B PlayerAnimation                     ; / for Yoshi Wing bonus stage
    LDA.B #$A0                                ; Initial Y position in the Yoshi Wings levels.
    STA.B PlayerYPosNext
    LDA.B #$90                                ; \ Set upward speed, #$90; Initial Y speed in the Yoshi Wings levels.
    STA.B PlayerYSpeed+1                      ; /
  + RTS

CODE_00A716:
    CMP.B #$06
    BCC CODE_00A740
    BNE CODE_00A734
    STY.B PlayerDirection                     ; Mario Action 06 - Shooting from diagonal pipe
    STY.W PlayerCapePose
    LDA.B #$FF
    STA.W YoshiInPipeSetting
    LDA.B #$08
    TSB.B PlayerXPosNext
    LDA.B #$02
    TSB.B PlayerYPosNext
    LDX.B #$07
    LDY.B #$20
    BRA CODE_00A6C7

CODE_00A734:
; Mario Action 07 - Vertical pipe downwards (water)
    STY.B LevelIsWater                        ; Set as a water level.
    LDA.W SkipMidwayCastleIntro
    ORA.W KeyholeTimer                        ; Unused?
    BNE CODE_00A6E0
    LDA.B #$04
CODE_00A740:
    CLC
    ADC.B #$03                                ; Store the direction of Mario's pipe exit animation.
    STA.B PlayerPipeAction
    TAY
    LSR A
    DEC A                                     ; Deterimine the direction Yoshi should face when exiting.
    STA.W YoshiInPipeSetting
    LDA.W DATA_00A60D-4,Y                     ; Determine Mario's direction.
    STA.B PlayerDirection
    LDX.B #$05
    CPY.B #$06
    BCC CODE_00A768
    LDA.B #$08                                ; How far Mario's position should be offset when exiting a vertical pipe.
    TSB.B PlayerXPosNext
    LDX.B #$06
    CPY.B #$07
    LDY.B #$1E                                ; How fast Mario exits an upward pipe.
    BCC +
    LDY.B #$0F                                ; How fast Mario exits a downward pipe, when small.
    LDA.B Powerup
    BEQ +
CODE_00A768:
    LDY.B #$1C                                ; \ Set downward speed, #$1C; How fast Mario exits a downward pipe, when with a powerup.
  + STY.B PlayerYSpeed+1                      ; /
    JSR CODE_00A6C7
    LDA.W PlayerRidingYoshi                   ; If not riding Yoshi, return.
    BEQ +
    LDX.B PlayerPipeAction
    LDA.B PipeTimer
    CLC                                       ; Add time to pipe entrances when riding Yoshi.
    ADC.W DATA_00A61D,X
    STA.B PipeTimer
    TXA
    ASL A
    TAX
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    CLC
    ADC.W DATA_00A60D-4,X
    STA.B PlayerXPosNext
    LDA.B PlayerYPosNext
    CLC
    ADC.W DATA_00A60D+4,X
    STA.B PlayerYPosNext
    SEP #$20                                  ; A->8
  + RTS

CODE_00A796:
    REP #$20                                  ; A->16; Subroutine to set Layer 2's initial scroll position, as well as the screen scroll region.
    LDY.W VertLayer2Setting
    BEQ CODE_00A7B9
    DEY
    BNE CODE_00A7A7
    LDA.B Layer2YPos
    SEC
    SBC.B Layer1YPos                          ; If vertical scrolling is enabled for Layer 2,
    BRA CODE_00A7B6                           ; get the base offset of Layer 2 from Layer 1's position, as set at level load.

CODE_00A7A7:
    LDA.B Layer1YPos                          ; Calculated based on the Layer 2 vertical scroll setting from the initial FG/BG positions:
    LSR A                                     ; Constant: $20 - $1C
    DEY                                       ; Variable: $20 - ($1C / 2)
    BEQ +                                     ; Slow:     $20 - ($1C / 8)
    LSR A
    LSR A                                     ; Note the difference between the slow setting here and its actual scroll rate (which is 1/32).
  + EOR.W #$FFFF                              ; That's why you can end up with garbage tiles at the top of the level when using it.
    INC A
    CLC
    ADC.B Layer2YPos
CODE_00A7B6:
    STA.W BackgroundVertOffset
CODE_00A7B9:
    LDA.W #$0080                              ; Initial screen scroll position when Mario spawns into the level.
    STA.W CameraMoveTrigger
    SEP #$20                                  ; A->8
    RTS

CODE_00A7C2:
    REP #$20                                  ; A->16; Subroutine to DMA the graphics for MARIO START! / LUIGI START! / TIME UP! / GAME OVER / BONUS GAME.
    LDX.B #$80
    STX.W HW_VMAINC
    LDA.W #$6000
    STA.W HW_VMADD
    LDA.W #$1801
    STA.W HW_DMAPARAM+$20
    LDA.W #MarioStartGraphics
    STA.W HW_DMAADDR+$20
    LDX.B #MarioStartGraphics>>16
    STX.W HW_DMAADDR+$22
    LDA.W #$00C0
    STA.W HW_DMACNT+$20
    LDX.B #$04
    STX.W HW_MDMAEN
    LDA.W #$6100
    STA.W HW_VMADD
    LDA.W #MarioStartGraphics+$C0
    STA.W HW_DMAADDR+$20
    LDA.W #$00C0
    STA.W HW_DMACNT+$20
    STX.W HW_MDMAEN
    LDA.W #$64A0
    STA.W HW_VMADD
    LDA.W #MarioStartGraphics+$180
    STA.W HW_DMAADDR+$20
    LDA.W #$00C0
    STA.W HW_DMACNT+$20
    STX.W HW_MDMAEN
    LDA.W #$65A0
    STA.W HW_VMADD
    LDA.W #MarioStartGraphics+$240
    STA.W HW_DMAADDR+$20
    LDA.W #$00C0
    STA.W HW_DMACNT+$20
    STX.W HW_MDMAEN
    SEP #$20                                  ; A->8
    RTS

CODE_00A82D:
    LDY.B #$0F                                ; GFX file loaded for the "MARIO START!", "GAME OVER", and "TIME UP!" text.
    JSL PrepareGraphicsFile                   ; Decompress file to RAM.
    LDA.W BonusGameActivate
    REP #$30                                  ; AXY->16
    BEQ +
    LDA.B _0                                  ; If loading the bonus game message, shift text pointer two tiles right.
    CLC
    ADC.W #$0030
    STA.B _0
  + LDX.W #$0000
CODE_00A845:
    LDY.W #$0008
  - LDA.B [_0]
    STA.L MarioStartGraphics,X
    INX
    INX
    INC.B _0
    INC.B _0
    DEY
    BNE -
    LDY.W #$0008
  - LDA.B [_0]
    AND.W #$00FF
    STA.L MarioStartGraphics,X
    INX
    INX
    INC.B _0
    DEY
    BNE -
    CPX.W #$0300
    BCC CODE_00A845
    SEP #$30                                  ; AXY->8
    LDY.B #$00                                ; Decompress GFX00 to RAM.
    JSL PrepareGraphicsFile
    REP #$30                                  ; AXY->16
    LDA.W #$B3F0
    STA.B _0
    LDA.W #$7EB3
    STA.B _1
    LDX.W #$0000
CODE_00A886:
    LDY.W #$0008
  - LDA.B [_0]
    STA.W GfxDecompSP1,X
    INX
    INX
    INC.B _0
    INC.B _0
    DEY
    BNE -
    LDY.W #$0008
  - LDA.B [_0]
    AND.W #$00FF
    STA.W GfxDecompSP1,X
    INX
    INX
    INC.B _0
    DEY
    BNE -
    CPX.W #$00C0
    BNE +
    LDA.W #$B570
    STA.B _0
  + CPX.W #$0180
    BCC CODE_00A886
    SEP #$30                                  ; AXY->8
    LDA.B #$01
    STA.W UploadMarioStart
    STA.W MarioStartFlag
    RTS


SPRITEGFXLIST:
    db $00,$01,$13,$02                        ; Forest
    db $00,$01,$12,$03                        ; Castle
    db $00,$01,$13,$05                        ; Mushroom
    db $00,$01,$13,$04                        ; Underground
    db $00,$01,$13,$06                        ; Water
    db $00,$01,$13,$09                        ; Pokey
    db $00,$01,$13,$04                        ; Underground 2
    db $00,$01,$06,$11                        ; Ghost House
    db $00,$01,$13,$20                        ; Banzai Bill
    db $00,$01,$13,$0F                        ; Yoshi's House
    db $00,$01,$13,$23                        ; Dino-Rhino
    db $00,$01,$0D,$14                        ; Switch Palace
    db $00,$01,$24,$0E                        ; Mechakoopa
    db $00,$01,$0A,$22                        ; Wendy/Lemmy
    db $00,$01,$13,$0E                        ; Ninji
    db $00,$01,$13,$14                        ; Unused
    db $00,$00,$00,$08
    db $10,$0F,$1C,$1D
    db $00,$01,$24,$22
    db $00,$01,$25,$22
    db $00,$22,$13,$2D
    db $00,$01,$0F,$22
    db $00,$26,$2E,$22
    db $21,$0B,$25,$0A
    db $00,$0D,$24,$22
    db $2C,$30,$2D,$0E
OBJECTGFXLIST:
    db $14,$17,$19,$15                        ; Normal 1
    db $14,$17,$1B,$18                        ; Castle 1
    db $14,$17,$1B,$16                        ; Rope 1
    db $14,$17,$0C,$1A                        ; Underground 1
    db $14,$17,$1B,$08                        ; Switch Palace 1
    db $14,$17,$0C,$07                        ; Ghost House 1
    db $14,$17,$0C,$16                        ; Rope 2
    db $14,$17,$1B,$15                        ; Normal 2
    db $14,$17,$19,$16                        ; Rope 3
    db $14,$17,$0D,$1A                        ; Underground 2
    db $14,$17,$1B,$08                        ; Switch Palace 2
    db $14,$17,$1B,$18                        ; Castle 2
    db $14,$17,$19,$1F                        ; Cloud/Forest
    db $14,$17,$0D,$07                        ; Ghost House 2
    db $14,$17,$19,$1A                        ; Underground 2
    db $14,$17,$14,$14
    db $0E,$0F,$17,$17
    db $1C,$1D,$08,$1E
    db $1C,$1D,$08,$1E
    db $1C,$1D,$08,$1E
    db $1C,$1D,$08,$1E
    db $1C,$1D,$08,$1E
    db $1C,$1D,$08,$1E
    db $1C,$1D,$08,$1E
    db $14,$17,$19,$2C
    db $19,$17,$1B,$18

CODE_00A993:
; Sprite GFX lists.
; 00 - Forest
; 01 - Castle
; 02 - Mushroom
; 03 - Underground
; 04 - Water
; 05 - Pokey
; 06 - Underground 2
; 07 - Ghost House
; 08 - Banzai Bill
; 09 - Yoshi's House
; 0A - Dino-Rhino
; 0B - Switch Palace
; 0C - Mecha-Koopa
; 0D - Wendy/Lemmy
; 0E - Ninji
; 0F - Unused
; 10 - Unused?
; 11 - Overworld
; 12 - Morton/Roy/Ludwig
; 13 - Iggy/Larry/Reznor
; 14 - Castle destruction
; 15 - Credits, staff roll
; 16 - Credits, Yoshi's House
; 17 - Credits, enemy credits
; 18 - Bowser
; 19 - Credits, THE END
; FG/BG GFX lists.
; 00 - Normal 1
; 01 - Castle 1
; 02 - Rope 1
; 03 - Underground 1
; 04 - Switch Palace 1
; 05 - Ghost House 1
; 06 - Rope 2
; 07 - Normal 2
; 08 - Rope 3
; 09 - Underground 2
; 0A - Switch Palace 2
; 0B - Castle 2
; 0C - Cloud/Forest
; 0D - Ghost House 2
; 0E - Underground 3
; 0F - Unused
; 10 - Unused?
; 11 - Main Map             ;\
; 12 - Yoshi's Island       ;|
; 13 - Vanilla Dome         ;|
; 14 - Forest of Illusion   ;| Note: not reloaded between submaps!
; 15 - Valley of Bowser     ;|
; 16 - Special World        ;|
; 17 - Star World           ;/
; 18 - Castle destruction
; 19 - Credits, staff roll
    STZ.W HW_VMADD                            ; \; Routine to upload Layer 3 pages 28-2B.
    LDA.B #$40                                ; |Set "Address for VRAM Read/Write" to x4000
    STA.W HW_VMADD+1                          ; /
    LDA.B #$03
    STA.B _F
    LDA.B #$28                                ; Starting file (GFX28).
    STA.B _E
CODE_00A9A3:
    LDA.B _E
    TAY                                       ; Decompress current file to RAM.
    JSL PrepareGraphicsFile
    REP #$30                                  ; AXY->16
    LDX.W #$03FF
    LDY.W #$0000
  - LDA.B [_0],Y                              ; Transfer file from RAM to VRAM.
    STA.W HW_VMDATA
    INY
    INY
    DEX
    BPL -
    SEP #$30                                  ; AXY->8
    INC.B _E
    DEC.B _F                                  ; Loop for all four files.
    BPL CODE_00A9A3
    STZ.W HW_VMADD                            ; \
    LDA.B #$60                                ; |Set "Address for VRAM Read/Write" to x6000
    STA.W HW_VMADD+1                          ; /
    LDY.B #$00                                ; Upload GFX00?
    JSR UploadGFXFile
    RTS


DATA_00A9D2:
    db $78,$70,$68,$60
DATA_00A9D6:
    db $18,$10,$08,$00

UploadSpriteGFX:
; Sprite GFX file VRAM upload locations (high byte only).
; FG/BG GFX file VRAM upload locations (high byte only).
    LDA.B #$80                                ; Decompression as well?; Upload the level's GFX files. This part specifically does sprite GFX.
    STA.W HW_VMAINC                           ; VRAM transfer control port
    LDX.B #$03
    LDA.W SpriteTileset                       ; $192B = current sprite GFX list index
    ASL A                                     ; \
    ASL A                                     ;  }4A -> Y
    TAY                                       ; /
  - LDA.W SPRITEGFXLIST,Y                     ; |
    STA.B _4,X                                ; |
    INY                                       ; |
    DEX                                       ; |
    BPL -                                     ; /
    LDA.B #$03                                ; #$03 -> A -> $0F
    STA.B _F
GFXTransferLoop:
    LDX.B _F                                  ; $0F -> X
    STZ.W HW_VMADD                            ; #$00 -> $2116
    LDA.W DATA_00A9D2,X                       ; My guess: Locations in VRAM to upload GFX to
    STA.W HW_VMADD+1                          ; Set VRAM address to $??00
    LDY.B _4,X                                ; Y is possibly which GFX file
    LDA.W SpriteGFXFile,X                     ; to upload to a section in VRAM, used in
    CMP.B _4,X                                ; the subroutine $00:BA28
    BEQ +                                     ; don't upload when it''s not needed
    JSR UploadGFXFile                         ; JSR to a JSL...
  + DEC.B _F                                  ; Decrement $0F
    BPL GFXTransferLoop                       ; if >= #$00, continue transfer
    LDX.B #$03                                ; \
  - LDA.B _4,X                                ; |Update $0101-$0104 to reflect the new sprite GFX
    STA.W SpriteGFXFile,X                     ; |That's loaded now.
    DEX                                       ; |
    BPL -                                     ; /
    LDA.W ObjectTileset                       ; LDA Tileset
    CMP.B #$FE
    BCS SetallFGBG80                          ; Branch to a routine that uploads file #$80 to every slot in FG/BG
    LDX.B #$03
    LDA.W ObjectTileset                       ; this routine is pretty close to the above
    ASL A                                     ; one, I'm guessing this does
    ASL A                                     ; object/BG GFX.
    TAY                                       ; 4A -> Y
  - LDA.W OBJECTGFXLIST,Y                     ; FG/BG GFX table; Upload the FG/BG GFX files.
    STA.B _4,X
    INY
    DEX
    BPL -                                     ; FG/Bg to upload -> $04 - $07
    LDA.B #$03
    STA.B _F                                  ; #$03 -> $0F
CODE_00AA35:
    LDX.B _F                                  ; $0F -> X
    STZ.W HW_VMADD
    LDA.W DATA_00A9D6,X                       ; Load + Store VRAM upload positions
    STA.W HW_VMADD+1
    LDY.B _4,X
    LDA.W BackgroundGFXFile,X                 ; Check to see if the file to be uploaded already
    CMP.B _4,X                                ; exists in the slot in VRAM - if so,
    BEQ +                                     ; don't bother uploading it again.
    JSR UploadGFXFile                         ; Upload the GFX file
  + DEC.B _F                                  ; Next GFX file; Continue to next GFX file.
    BPL CODE_00AA35
    LDX.B #$03
  - LDA.B _4,X
    STA.W BackgroundGFXFile,X
    DEX
    BPL -
    RTS                                       ; Return from uploading the GFX

SetallFGBG80:
    BEQ +                                     ; If zero flag set, don't update the tileset
    JSR CODE_00AB42
  + LDX.B #$03
    LDA.B #$80                                ; my guess is that it gets called in the same set of routines
  - STA.W BackgroundGFXFile,X
    DEX
    BPL -
    RTS

UploadGFXFile:
; Routine to upload a 3bpp/4bpp GFX file to VRAM. File number in Y, store VRAM location before calling.
    JSL PrepareGraphicsFile                   ; Decompress file to RAM.
    CPY.B #$01                                ; GFX file to load Special World graphical changes into.
    BNE +
    LDA.W OWLevelTileSettings+$49
    BPL +                                     ; handle the post-special world graphics and koopa color swap.; If loading GFX01, replace with the special world graphics if applicable.
    LDY.B #$31
    JSL PrepareGraphicsFile
    LDY.B #$01
  + REP #$20                                  ; A->16
    LDA.W #$0000
    LDX.W ObjectTileset                       ; LDX Tileset
    CPX.B #$11                                ; CPX #$11
    BCC CODE_00AA90                           ; If Tileset < #$11 skip to lower area
    CPY.B #$08                                ; if Y = #$08 skip to JSR; If not loading GFX08 (overworld Layer 1 tiles) or GFX1E (Yoshi's House/Switch Palace), branch.
    BEQ JumpTo_____
CODE_00AA90:
    CPY.B #$1E                                ; If Y = #$1E then
    BEQ JumpTo_____                           ; JMP otherwise
    BNE +                                     ; don't JMP
JumpTo_____:
    JMP FilterSomeRAM

  + STA.B _A                                  ; $0A = 0x0000
    LDA.W #$FFFF
    CPY.B #$01
    BEQ +
    CPY.B #$17                                ; Do special handling for GFX01 (standard sprites) and GFX17 (bush, goal, etc. FG),
    BEQ +                                     ; in order to handle berries using the second half of the palette.
    LDA.W #$0000
  + STA.W GfxBppConvertFlag
    LDY.B #$7F
CODE_00AAAE:
    LDA.W GfxBppConvertFlag
    BEQ CODE_00AACD                           ; Extra work for 3BPP -> 4BPP conversion in GFX01/17, to handle berries.
    CPY.B #$7E                                ; First two tiles in file use second half of the palette.
    BCC CODE_00AABE
CODE_00AAB7:
    LDA.W #$FF00                              ; Set to use the second half of the palette.
    STA.B _A
    BNE CODE_00AACD                           ; Equivalent to a BRA.
CODE_00AABE:
    CPY.B #$6E
    BCC CODE_00AAC8                           ; First two tiles in second row use second half of the palette.
    CPY.B #$70
    BCS CODE_00AAC8
    BCC CODE_00AAB7
CODE_00AAC8:
    LDA.W #$0000                              ; Everyone else uses the first half of the palette.
    STA.B _A
CODE_00AACD:
    LDX.B #$07
  - LDA.B [_0]
    STA.W HW_VMDATA
    XBA                                       ; Upload 16 bytes to VRAM.
    ORA.B [_0]                                ; This handles the first two bitplanes.
    STA.W GfxBppConvertBuffer,X
    INC.B _0
    INC.B _0
    DEX
    BPL -
    LDX.B #$07
  - LDA.B [_0]
    AND.W #$00FF
    STA.B _C
    LDA.B [_0]                                ; Upload 8 more bytes to VRAM. This handles bitplanes 2/3.
    XBA                                       ; The business with $0C/$0A is for handling the berry palettes;
    ORA.W GfxBppConvertBuffer,X               ; $0C is 0xFF00 only for the berry tiles, 0x0000 otherwise.
    AND.B _A                                  ; When 0xFF00, it essentially masks to only non-zero (non-transparent) pixels.
    ORA.B _C
    STA.W HW_VMDATA
    INC.B _0
    DEX
    BPL -
    DEY                                       ; Continue looping for all tiles in the file.
    BPL CODE_00AAAE
    SEP #$20                                  ; A->8
    RTS

FilterSomeRAM:
    LDA.W #$FF00
    STA.B _A
    LDY.B #$7F
Upload____ToVRAM:
    CPY.B #$08                                ; \Completely pointless code.
    BCS +                                     ; /(Why not just NOPing it out, Nintendo?)
  + LDX.B #$07
  - LDA.B [_0]                                ; \ Okay, so take [$00], store
    STA.W HW_VMDATA                           ; |it to VRAM, then bitwise
    XBA                                       ; |OR the high and low bytes together
    ORA.B [_0]                                ; |store in both bytes of A
    STA.W GfxBppConvertBuffer,X               ; /and store to $1BB2,x
    INC.B _0                                  ; \Increment $7E:0000 by 2
    INC.B _0                                  ; /
    DEX                                       ; \And continue on another 7 times (or 8 times total)
    BPL -                                     ; /
    LDX.B #$07                                ; hm..  It's like a FOR Y{FOR X{ } } thing ...yeah...
  - LDA.B [_0]
    AND.W #$00FF                              ; A normal byte becomes 2 anti-compressed bytes.
    STA.B _C                                  ; I'm going up, to try and find out what's supposed to set $00-$02 for this routine.
    LDA.B [_0]                                ; AHA, check $00/BA28.  It writes a RAM address to $00-$02, $7EAD00
    XBA                                       ; So...  Now to find otu what sets *That*
    ORA.W GfxBppConvertBuffer,X               ; ...this place gives me headaches... Can't we work on some other code? :(
    AND.B _A                                  ; Sure, go ahead.  anyways, this seems to upload the decompressed GFX
    ORA.B _C                                  ; while scrambling it afterwards (o_O).
    STA.W HW_VMDATA                           ; Okay... WHAT THE HELL?
    INC.B _0                                  ; I'll have nightmares about this routine for a few years. :(
    DEX
    BPL -                                     ; Ouch.
    DEY
    BPL Upload____ToVRAM
    SEP #$20                                  ; A->8
    RTS

CODE_00AB42:
    LDY.B #$27                                ; GFX file loaded for Mode 7 objects.
    JSL PrepareGraphicsFile                   ; Decompress file to RAM.
    REP #$10                                  ; XY->16
    LDY.W #$0000                              ; 3bpp->8bpp conversion loop. Extracts bits in sets of 3
    LDX.W #$03FF                              ; from the decompressed data, then uploads them to VRAM.
  - LDA.B [_0],Y
    STA.B _F
    JSR CODE_00ABC4                           ; Read first byte.
    LDA.B _4                                  ; Write the highest 3 bits to VRAM,
    STA.W HW_VMDATA+1                         ; then the next 3 bits.
    JSR CODE_00ABC4
    LDA.B _4                                  ; Preserve the remaining 2 bits in $04 for use below.
    STA.W HW_VMDATA+1
    STZ.B _4
    ROL.B _F
    ROL.B _4
    ROL.B _F
    ROL.B _4
    INY
    LDA.B [_0],Y
    STA.B _F
    ROL.B _F                                  ; Read second byte.
    ROL.B _4                                  ; Combine highest bit with the two from above, then write to VRAM.
    LDA.B _4                                  ; Write next 3 bits, then next 3 bits after that.
    STA.W HW_VMDATA+1
    JSR CODE_00ABC4                           ; Preserve the remaining single bit in $04 for use below.
    LDA.B _4
    STA.W HW_VMDATA+1
    JSR CODE_00ABC4
    LDA.B _4
    STA.W HW_VMDATA+1
    STZ.B _4
    ROL.B _F
    ROL.B _4
    INY
    LDA.B [_0],Y
    STA.B _F
    ROL.B _F                                  ; Read third byte.
    ROL.B _4                                  ; Combine highest two bits from the one above, then write to VRAM.
    ROL.B _F                                  ; Write next 3 bits, then final 3 bits.
    ROL.B _4
    LDA.B _4
    STA.W HW_VMDATA+1
    JSR CODE_00ABC4
    LDA.B _4
    STA.W HW_VMDATA+1
    JSR CODE_00ABC4
    LDA.B _4
    STA.W HW_VMDATA+1
    INY
    DEX                                       ; Loop for all remaining bytes.
    BPL -
    LDX.W #$2000
  - STZ.W HW_VMDATA+1
    DEX
    BNE -
    SEP #$10                                  ; XY->8
    RTS

CODE_00ABC4:
    STZ.B _4                                  ; Subroutine used above which 3 bits from $0F into $04.
    ROL.B _F
    ROL.B _4
    ROL.B _F
    ROL.B _4
    ROL.B _F
    ROL.B _4
    RTS


DATA_00ABD3:
    db $00,$18,$30,$48,$60,$78,$90,$A8        ; Offsets for FG, BG, Sprite Palettes

    db $00,$14,$28,$3C                        ; Offsets for The End Palettes??

DATA_00ABDF:
    dw $0000,$0038,$0070,$00A8                ; Offsets for Overworld Palettes
    dw $00E0,$0118,$0150

LoadPalette:
; Table of palette pointers (minus #$B732) for each overworld, indexed by $00AD1E.
    REP #$30                                  ; AXY->16; Routine to load level palettes.
    LDA.W #$7FDD                              ; \; SNES value to use for color 1 of palettes 0-7 (white).
    STA.B _4                                  ; |Set color 1 in all object palettes to white
    LDX.W #$0002                              ; |; Column number to fill with the above color.
    JSR LoadCol8Pal                           ; /
    LDA.W #$7FFF                              ; \; SNES value to use for color 1 of palettes 8-F (white).
    STA.B _4                                  ; |Set color 1 in all sprite palettes to white
    LDX.W #$0102                              ; |; Column number to fill with the above color.
    JSR LoadCol8Pal                           ; /
    LDA.W #StatusBarColors                    ; \; Layer 3 palettes pointer ($00B170).
    STA.B _0                                  ; |
    LDA.W #$0010                              ; |Load colors 8-16 in the first two object palettes from 00/B170; Layer 3 palettes starting index.
    STA.B _4                                  ; |(Layer 3 palettes)
    LDA.W #$0007                              ; |; Layer 3 palettes X-span, -1.
    STA.B _6                                  ; |
    LDA.W #$0001                              ; |; Layer 3 palettes Y-span, -1.
    STA.B _8                                  ; |
    JSR LoadColors                            ; /
    LDA.W #StandardColors                     ; \; Foreground/sprite palettes pointer ($00B250).
    STA.B _0                                  ; |
    LDA.W #$0084                              ; |Load colors 2-7 in palettes 4-D from 00/B250; Foreground/sprite palettes starting index.
    STA.B _4                                  ; |(Object and sprite palettes)
    LDA.W #$0005                              ; |; Foreground/sprite palettes X-span, -1.
    STA.B _6                                  ; |
    LDA.W #$0009                              ; |; Foreground/sprite palettes Y-span, -1.
    STA.B _8                                  ; |
    JSR LoadColors                            ; /
    LDA.W BackAreaColor                       ; \
    AND.W #$000F                              ; |
    ASL A                                     ; |Load background color
    TAY                                       ; |
    LDA.W BackAreaColors,Y                    ; |; Back area colors pointer ($00B0A0).
    STA.W BackgroundColor                     ; /
    LDA.W #ForegroundPalettes                 ; \Store base address in $00, ...; Tileset specific FG palettes pointer ($00B190).
    STA.B _0                                  ; /
    LDA.W ForegroundPalette                   ; \...get current object palette, ...
    AND.W #$000F                              ; /
    TAY                                       ; \
    LDA.W DATA_00ABD3,Y                       ; |
    AND.W #$00FF                              ; |...use it to figure out where to load from, ...
    CLC                                       ; |
    ADC.B _0                                  ; |...add it to the base address...
    STA.B _0                                  ; / ...and store it in $00
    LDA.W #$0044                              ; \; Tileset specific FG palettes starting index.
    STA.B _4                                  ; |
    LDA.W #$0005                              ; |; Tileset specific FG palettes X-span, -1.
    STA.B _6                                  ; |Load colors 2-7 in object palettes 2 and 3 from the address in $00
    LDA.W #$0001                              ; |; Tileset specific FG palettes Y-span, -1.
    STA.B _8                                  ; |
    JSR LoadColors                            ; /
    LDA.W #SpriteColors                       ; \Store base address in $00, ...; Tileset specific sprite palettes pointer ($00B318).
    STA.B _0                                  ; /
    LDA.W SpritePalette                       ; \...get current sprite palette, ...
    AND.W #$000F                              ; /
    TAY                                       ; \
    LDA.W DATA_00ABD3,Y                       ; |
    AND.W #$00FF                              ; |...use it to figure out where to load from, ...
    CLC                                       ; |
    ADC.B _0                                  ; |...add it to the base address...
    STA.B _0                                  ; / ...and store it in $00
    LDA.W #$01C4                              ; \; Tileset specific sprite palettes starting index.
    STA.B _4                                  ; |
    LDA.W #$0005                              ; |; Tileset specific sprite palettes X-span, -1.
    STA.B _6                                  ; |Load colors 2-7 in sprite palettes 6 and 7 from the address in $00
    LDA.W #$0001                              ; |; Tileset specific sprite palettes Y-span, -1.
    STA.B _8                                  ; |
    JSR LoadColors                            ; /
    LDA.W #BackgroundPalettes                 ; \Store bade address in $00, ...; Layer 2 BG palettes pointer ($0B0B0).
    STA.B _0                                  ; /
    LDA.W BackgroundPalette                   ; \...get current background palette, ...
    AND.W #$000F                              ; /
    TAY                                       ; \
    LDA.W DATA_00ABD3,Y                       ; |
    AND.W #$00FF                              ; |...use it to figure out where to load from, ...
    CLC                                       ; |
    ADC.B _0                                  ; |...add it to the base address...
    STA.B _0                                  ; / ...and store it in $00
    LDA.W #$0004                              ; \; Layer 2 BG palettes starting index.
    STA.B _4                                  ; |
    LDA.W #$0005                              ; |; Layer 2 BG palettes X-span, -1.
    STA.B _6                                  ; |Load colors 2-7 in object palettes 0 and 1 from the address in $00
    LDA.W #$0001                              ; |; Layer 2 BG palettes Y-span, -1.
    STA.B _8                                  ; |
    JSR LoadColors                            ; /
    LDA.W #BerryColors                        ; \; Layer 1 berry palettes pointer ($00B674)
    STA.B _0                                  ; |
    LDA.W #$0052                              ; |; Layer 1 berry palettes starting index.
    STA.B _4                                  ; |
    LDA.W #$0006                              ; |Load colors 9-F in object palettes 2-4 from 00/B674; Layer 1 berry palettes X-span, -1.
    STA.B _6                                  ; |
    LDA.W #$0002                              ; |; Layer 1 berry palettes Y-span, -1.
    STA.B _8                                  ; |
    JSR LoadColors                            ; /
    LDA.W #BerryColors                        ; \
    STA.B _0                                  ; |
    LDA.W #$0132                              ; |
    STA.B _4                                  ; |; Berry palette duplicated to palette 9 for unknown reason...
    LDA.W #$0006                              ; |Load colors 9-F in sprite palettes 1-3 from 00/B674
    STA.B _6                                  ; |
    LDA.W #$0002                              ; |
    STA.B _8                                  ; |
    JSR LoadColors                            ; /
    SEP #$30                                  ; AXY->8; 8-bit A, X, Y
    RTS

LoadCol8Pal:
    LDY.W #$0007                              ; Subroutine to load a color to a set of 8 palettes. Used for color 1 (white) in 0-7 and 8-F.
  - LDA.B _4
    STA.W MainPalette,X
    TXA
    CLC
    ADC.W #$0020
    TAX
    DEY
    BPL -
    RTS

LoadColors:
; Scratch RAM setup:
; $00 - Palette pointer.
; $04 - Starting index of the color.
; $06 - X span of block to upload.
; $08 - Y span of block to upload.
    LDX.B _4                                  ; Routine to upload a palette to RAM.
    LDY.B _6
  - LDA.B (_0)
    STA.W MainPalette,X
    INC.B _0
    INC.B _0
    INX
    INX
    DEY
    BPL -
    LDA.B _4
    CLC
    ADC.W #$0020
    STA.B _4
    DEC.B _8
    BPL LoadColors
    RTS


DATA_00AD1E:
    db $01,$00,$03,$04,$03,$05,$02            ; Palette Indices for Overworld Maps

CODE_00AD25:
; Palette IDs for each submap, as indices to $00ABDF.
    REP #$30                                  ; AXY->16; Routine to load overworld palettes.
    LDY.W #OverworldColors                    ; Overworld map Layer 2 palettes pointer ($00B3D8).
    LDA.W OWLevelTileSettings+$48
    BPL +
    LDY.W #OWSpecialColors                    ; Overworld map Layer 2 palettes pointer with special world ($00B732).
  + STY.B _0
    LDA.W ObjectTileset
    AND.W #$000F
    DEC A
    TAY
    LDA.W DATA_00AD1E,Y
    AND.W #$00FF                              ; Get actual Layer 2 palette pointer.
    ASL A
    TAY
    LDA.W DATA_00ABDF,Y
    CLC
    ADC.B _0
    STA.B _0
    LDA.W #$0082                              ; Overworld map Layer 2 palettes starting index.
    STA.B _4
    LDA.W #$0006                              ; Overworld map Layer 2 palettes X-span, -1.
    STA.B _6
    LDA.W #$0003                              ; Overworld map Layer 2 palettes Y-span, -1.
    STA.B _8
    JSR LoadColors
    LDA.W #OWStdColors                        ; Overworld map Layer 1 palettes pointer ($00B528).
    STA.B _0
    LDA.W #$0052                              ; Overworld map Layer 1 palettes starting index.
    STA.B _4
    LDA.W #$0006                              ; Overworld map Layer 1 palettes X-span, -1.
    STA.B _6
    LDA.W #$0005                              ; Overworld map Layer 1 palettes Y-span, -1.
    STA.B _8
    JSR LoadColors
    LDA.W #OWStdColors2                       ; Overworld map sprite palettes pointer ($00B57C).
    STA.B _0
    LDA.W #$0102                              ; Overworld map sprite palettes starting index.
    STA.B _4
    LDA.W #$0006                              ; Overworld map sprite palettes X-span, -1.
    STA.B _6
    LDA.W #$0007                              ; Overworld map sprite palettes Y-span, -1.
    STA.B _8
    JSR LoadColors
    LDA.W #OverworldHudColors                 ; Overworld map Layer 3 palettes pointer ($00B5EC).
    STA.B _0
    LDA.W #$0010                              ; Overworld map Layer 3 palettes starting index.
    STA.B _4
    LDA.W #$0007                              ; Overworld map Layer 3 palettes X-span, -1.
    STA.B _6
    LDA.W #$0001                              ; Overworld map Layer 3 palettes Y-span, -1.
    STA.B _8
    JSR LoadColors
    SEP #$30                                  ; AXY->8
    RTS

CODE_00ADA6:
    REP #$30                                  ; AXY->16; Routine to load title screen palettes.
    LDA.W #TitleScreenColors+$10              ; Title screen palette 1 pointer ($00B63C)
    STA.B _0
    LDA.W #$0010                              ; Title screen palette 1 starting index.
    STA.B _4
    LDA.W #$0007                              ; Title screen palette 1 X-span, -1.
    STA.B _6
    LDA.W #$0000                              ; Title screen palette 1 Y-span, -1.
    STA.B _8
    JSR LoadColors
    LDA.W #TitleScreenColors                  ; Title screen palette 0 pointer ($00B63C)
    STA.B _0
    LDA.W #$0030                              ; Title screen palette 0 starting index.
    STA.B _4
    LDA.W #$0007                              ; Title screen palette 0 X-span, -1.
    STA.B _6
    LDA.W #$0000                              ; Title screen palette 0 Y-span, -1.
    STA.B _8
    JSR LoadColors
    SEP #$30                                  ; AXY->8
    RTS

LoadIggyLarryPalette:
    JSR LoadPalette                           ; Routine to load Iggy and Larry palettes.
    REP #$30                                  ; AXY->16
    LDA.W #$0017                              ; Back area color (lava).
    STA.W BackgroundColor
    LDA.W #StatusBarColors                    ; Layer 3 palettes pointer ($00B170).
    STA.B _0
    LDA.W #$0010                              ; Layer 3 palettes starting index.
    STA.B _4
    LDA.W #$0007                              ; Layer 3 palettes X-span, -1.
    STA.B _6
    LDA.W #$0001                              ; Layer 3 palettes Y-span, -1.
    STA.B _8
    JSR LoadColors
    LDA.W #IggyLarryPlatColors                ; Iggy/Larry platform palettes pointer ($00B65C).
    STA.B _0
    LDA.W #$0000                              ; Iggy/Larry platform palettes starting index.
    STA.B _4
    LDA.W #$0007                              ; Iggy/Larry platform palettes X-span, -1.
    STA.B _6
    LDA.W #$0000                              ; Iggy/Larry platform palettes Y-span, -1.
    STA.B _8
    JSR LoadColors
    SEP #$30                                  ; AXY->8
    RTS

CODE_00AE15:
; Routine to load Morton, Ludwig, Roy, Reznor, and Bowser palettes.
    LDA.B #$02                                ; Mode 7 boss sprite palette setting (used for BG).
    STA.W SpritePalette
    LDA.B #$07                                ; Mode 7 boss FG palette setting (used for platforms/lava).
    STA.W ForegroundPalette
    JSR LoadPalette
    REP #$30                                  ; AXY->16
    LDA.W #$0017                              ; Back area color (used for lava).
    STA.W BackgroundColor
    LDA.W #OverworldHudColors+8               ; Layer 3 (?) palettes pointer ($00B5F4).
    STA.B _0
    LDA.W #$0018                              ; Layer 3 (?) palettes starting index.
    STA.B _4
    LDA.W #$0003                              ; Layer 3 (?) palettes X-span, -1.
    STA.B _6
    STZ.B _8
    JSR LoadColors
    SEP #$30                                  ; AXY->8
    RTS


DATA_00AE41:
    db $00,$05,$0A
DATA_00AE44:
    db $20,$40,$80

CODE_00AE47:
; Bitwise indices to each color component.
; ORA values for uploading color data to COLDATA ($2132).
    LDX.B #$02                                ; Routine to upload the back area color to COLDATA.
CODE_00AE49:
    REP #$20                                  ; A->16
    LDA.W BackgroundColor
    LDY.W DATA_00AE41,X
CODE_00AE51:
    DEY
    BMI CODE_00AE57
    LSR A                                     ; Get a particular component and upload it to the registers.
    BRA CODE_00AE51

CODE_00AE57:
    SEP #$20                                  ; A->8
    AND.B #$1F
    ORA.W DATA_00AE44,X
    STA.W HW_COLDATA
    DEX                                       ; Loop for all three components.
    BPL CODE_00AE49
    RTS


DATA_00AE65:
    dw $001F,$03E0,$7C00

DATA_00AE6B:
    dw $FFFF,$FFE0,$FC00

DATA_00AE71:
    dw $0001,$0020,$0400

DATA_00AE77:
    dw $0000,$0000,$0001,$0000
    dw $8000,$8000,$8020,$0400
    dw $8080,$8080,$8208,$1040
    dw $8420,$8420,$8844,$2210
    dw $8888,$8888,$9122,$4488
    dw $9248,$9248,$A492,$4924
    dw $A4A4,$A4A4,$A949,$5294
    dw $AAAA,$5294,$AAAA,$5554
    dw $AAAA,$AAAA,$D5AA,$AAAA
    dw $D5AA,$D5AA,$D6B5,$AD6A
    dw $DADA,$DADA,$DB6D,$B6DA
    dw $EDB6,$EDB6,$EEDD,$BB76
    dw $EEEE,$EEEE,$F7BB,$DDEE
    dw $FBDE,$FBDE,$FDF7,$EFBE
    dw $FEFE,$FEFE,$FFDF,$FBFE
    dw $FFFE,$FFFE,$FFFF,$FFFE

DATA_00AEF7:
    dw $8000,$4000,$2000,$1000
    dw $0800,$0400,$0200,$0100
    dw $0080,$0040,$0020,$0010
    dw $0008,$0004,$0002,$0001

CODE_00AF17:
; SNES RGB component locations (-bbb bbgg gggr rrrr)
; Fade to black table. Decreases a component by 1.
; Fade to color table. Increases a component by 1.
; Table of how much each component is allowed to fade relative to its brightness.
; TODO: explain better some day
; Table for the maximum values of a component to allow fading each frame.
; TODO: explain better some day
    LDY.W EndLevelTimer                       ; End level fade routine.
    LDA.B TrueFrame
    LSR A
    BCC +
    DEY
    BEQ +
    STY.W EndLevelTimer
  + CPY.B #con($A0,$A0,$A0,$B0,$B0)
    BCS CODE_00AF35
    LDA.B #$04
    TRB.B ColorSettings
    LDA.B #$09
    STA.B MainBGMode
    JSL CODE_05CBFF                           ; Handle the end level walk.
CODE_00AF35:
    LDA.B TrueFrame
    AND.B #$03                                ; Fade every four frames.
    BNE Return00AFA2
    LDA.W ColorFadeTimer
    CMP.B #$40                                ; Return if fully faded.
    BCS Return00AFA2
    JSR CODE_00AFA3                           ; Get fading information for the current frame.
    LDA.W #$01FE                              ; #$FE is the number of colors to upload to CGRAM (times 2), #$01 is the first color.
    STA.W CopyPalette
    LDX.W #$00EE                              ; Color to start with, times 2 (77).
CODE_00AF4E:
    LDA.W #$0007                              ; Number of colors in each palette to fade (1-7).
    STA.B _0
  - LDA.W CopyPalette,X
    STA.B _2
    LDA.W MainPalette,X                       ; Get the faded color.
    JSR CODE_00AFC0
    LDA.B _4
    STA.W CopyPalette,X
    DEX
    DEX                                       ; Decrement to previous color, and loop until the palette is faded.
    DEC.B _0
    BNE -
    TXA
    SEC
    SBC.W #$0012                              ; Decrement to previous palette, and loop until all palettes are faded.
    TAX
    BPL CODE_00AF4E
    LDX.W #$0004
  - LDA.W CopyPalette+$1A,X
    STA.B _2
    LDA.W MainPalette+$1A,X
    JSR CODE_00AFC0                           ; Also fade colors D-F of palette 0.
    LDA.B _4
    STA.W CopyPalette+$1A,X
    DEX
    DEX
    BPL -
    LDA.W BackgroundColor
    STA.B _2
    LDA.W CopyBGColor                         ; Also fade the back area color.
    JSR CODE_00AFC0
    LDA.B _4
    STA.W BackgroundColor
    SEP #$30                                  ; AXY->8
    STZ.W CopyPalette+$100
    LDA.B #!PaletteTableUse_Copy              ; Change palette upload table to $0905.
    STA.W PaletteIndexTable
Return00AFA2:
    RTS

CODE_00AFA3:
    TAY                                       ; Get fade information.
    INC A
    INC A                                     ; Increment fade timer.
    STA.W ColorFadeTimer
    TYA
    LSR A
    LSR A
    LSR A
    LSR A
    REP #$30                                  ; AXY->16
    AND.W #$0002
    STA.B _C
    TYA
    AND.W #$001E
    TAY
    LDA.W DATA_00AEF7,Y
    STA.B _E
    RTS

CODE_00AFC0:
; Scratch RAM setup:
; A   - original SNES RGB value
; $02 - current SNES RGB value
; $0C - 00 or 02, depending on which half of the timer you're in.
; $0E -
; Scratch RAM returns:
; $04 - new SNES RGB value
; $06 - Base R component, divided by 2 (0rrr rr00)
; $08 - Base G component, divided by 2 (0ggg gg00)
; $0A - Base B component, divided by 2 (0bbb bb00)
    STA.B _A                                  ; Subroutine to fade a color.
    AND.W #$001F
    ASL A
    ASL A
    STA.B _6
    LDA.B _A                                  ; Get the components of the color.
    AND.W #$03E0                              ; $06 = R
    LSR A                                     ; $08 = G
    LSR A                                     ; $0A = B
    LSR A
    STA.B _8
    LDA.B _B
    AND.W #$007C
    STA.B _A
    STZ.B _4
    LDY.W #$0004                              ; Get the new color.
CODE_00AFDF:
    PHY
    LDA.W _6,Y
    ORA.B _C
    TAY                                       ; Skip fading if the component is not able to fade this frame.
    LDA.W DATA_00AE77,Y                       ; This is to make color fading relative to the original color,
    PLY                                       ; rather than fading them to black individually as with color math.
    AND.B _E
    BEQ +
    LDA.W DATA_00AE6B,Y
    BIT.W EndLevelTimer                       ; Decide fade to black or fade to color.
    BPL +
    LDA.W DATA_00AE71,Y
  + CLC
    ADC.B _2
    AND.W DATA_00AE65,Y
    TSB.B _4
    DEY
    DEY                                       ; Loop for all components.
    BPL CODE_00AFDF
    RTS

CODE_00B006:
    PHB
    PHK
    PLB
    JSR CODE_00AFA3
    LDX.W #$006E
CODE_00B00F:
    LDY.W #$0008
  - LDA.W CopyPalette+2,X
    STA.B _2
    LDA.W MainPalette+$80,X
    PHY
    JSR CODE_00AFC0
    PLY
    LDA.B _4
    STA.W CopyPalette+2,X
    LDA.W MainPalette+$80,X
    SEC
    SBC.B _4
    STA.W CopyPalette+$74,X
    DEX
    DEX
    DEY
    BNE -
    TXA
    SEC
    SBC.W #$0010
    TAX
    BPL CODE_00B00F
    SEP #$30                                  ; AXY->8
    PLB
    RTL

CODE_00B03E:
    JSR CODE_00AF35
    LDA.W PaletteIndexTable
    CMP.B #!PaletteTableUse_Copy              ; Return if loading palette from $0905 (i.e. fading colors).
    BNE Return00B090
    LDA.B #$00
    STA.B _2
    REP #$30                                  ; AXY->16
    LDA.W PlayerPalletePtr
    STA.B _0
    LDY.W #$0014
  - LDA.B [_0],Y
    STA.W CopyPalette+$10C,Y
    DEY
    DEY
    BPL -
    LDA.W #$81EE
    STA.W CopyPalette+$100
    LDX.W #$00CE
CODE_00B068:
    LDA.W #$0007
    STA.B _0
  - LDA.W CopyPalette+$120,X
    STA.B _2
    LDA.W MainPalette+$120,X
    JSR CODE_00AFC0
    LDA.B _4
    STA.W CopyPalette+$120,X
    DEX
    DEX
    DEC.B _0
    BNE -
    TXA
    SEC
    SBC.W #$0012
    TAX
    BPL CODE_00B068
    SEP #$30                                  ; AXY->8
    STZ.W Empty0AF5
Return00B090:
    RTS

    %insert_empty($11,$0F,$36,$1D,$1B)

BackAreaColors:
    %incpal("col/misc/back_area.pal")

BackgroundPalettes:
    %incpal("col/lvl/bg_00.pal")
    %incpal("col/lvl/bg_01.pal")
    %incpal("col/lvl/bg_02.pal")
    %incpal("col/lvl/bg_03.pal")
    %incpal("col/lvl/bg_04.pal")
    %incpal("col/lvl/bg_05.pal")
    %incpal("col/lvl/bg_06.pal")
    %incpal("col/lvl/bg_07.pal")

StatusBarColors:
    %incpal("col/misc/status_bar.pal")

ForegroundPalettes:
    %incpal("col/lvl/fg_00.pal")
    %incpal("col/lvl/fg_01.pal")
    %incpal("col/lvl/fg_02.pal")
    %incpal("col/lvl/fg_03.pal")
    %incpal("col/lvl/fg_04.pal")
    %incpal("col/lvl/fg_05.pal")
    %incpal("col/lvl/fg_06.pal")
    %incpal("col/lvl/fg_07.pal")

StandardColors:
    %incpal("col/lvl/std_04.pal")
    %incpal("col/lvl/std_05.pal")
    %incpal("col/lvl/std_06.pal")
    %incpal("col/lvl/std_07.pal")
    %incpal("col/lvl/std_08.pal")
    %incpal("col/lvl/std_09.pal")
    %incpal("col/lvl/std_0A.pal")
    %incpal("col/lvl/std_0B.pal")
    %incpal("col/lvl/std_0C.pal")
    %incpal("col/lvl/std_0D.pal")

PlayerColors:
    %incpal("col/misc/mario_normal.pal")
    %incpal("col/misc/luigi_normal.pal")
    %incpal("col/misc/mario_fire.pal")
    %incpal("col/misc/luigi_fire.pal")

SpriteColors:
    %incpal("col/lvl/spr_00.pal")
    %incpal("col/lvl/spr_01.pal")
    %incpal("col/lvl/spr_02.pal")
    %incpal("col/lvl/spr_03.pal")
    %incpal("col/lvl/spr_04.pal")
    %incpal("col/lvl/spr_05.pal")
    %incpal("col/lvl/spr_06.pal")
BowserEndPalette:
    %incpal("col/lvl/spr_07.pal")

OverworldColors:
    %incpal("col/ow/YI_normal.pal")
    %incpal("col/ow/main_normal.pal")
    %incpal("col/ow/star_normal.pal")
    %incpal("col/ow/caves_normal.pal")
    %incpal("col/ow/FoI_normal.pal")
    %incpal("col/ow/special_normal.pal")

OWStdColors:
    %incpal("col/ow/std_02.pal")
    %incpal("col/ow/std_03.pal")
    %incpal("col/ow/std_04.pal")
    %incpal("col/ow/std_05.pal")
    %incpal("col/ow/std_06.pal")
    %incpal("col/ow/std_07.pal")

OWStdColors2:
    %incpal("col/ow/std_08.pal")
    %incpal("col/ow/std_09.pal")
    %incpal("col/ow/std_0A.pal")
    %incpal("col/ow/std_0B.pal")
    %incpal("col/ow/std_0C.pal")
    %incpal("col/ow/std_0D.pal")
    %incpal("col/ow/std_0E.pal")

OverworldLightning:
    %incpal("col/ow/lightning.pal")           ; Also Palette F Colors 1-7

OverworldHudColors:
    %incpal("col/ow/border.pal")

FlashingColors:
    %incpal("col/misc/flashing_yellow.pal")
    %incpal("col/misc/flashing_red.pal")

TitleScreenColors:
    %incpal("col/misc/title_screen.pal")

    %incpal("col/misc/blue_gradient.pal")     ; Unknown Blue Gradient

IggyLarryPlatColors:
    %incpal("col/misc/iggy_platform.pal")

BigCrusherColors:
    %incpal("col/misc/castle_crusher.pal")

BerryColors:
    %incpal("col/misc/berry_red.pal")
    %incpal("col/misc/berry_pink.pal")
    %incpal("col/misc/berry_green.pal")

BowserColors:
    %incpal("col/misc/bowser.pal")

TheEndColors:
    %incpal("col/misc/the_end_0D.pal")
    %incpal("col/misc/the_end_0E.pal")
    %incpal("col/misc/the_end_0F.pal")

OWSpecialColors:
    %incpal("col/ow/YI_special.pal")
    %incpal("col/ow/main_special.pal")
    %incpal("col/ow/star_special.pal")
    %incpal("col/ow/caves_special.pal")
    %incpal("col/ow/FoI_special.pal")
    %incpal("col/ow/special_special.pal")

    dl GFX33
    dl GFX32

CODE_00B888:
; The entirety of SMW's palette data.
; $00B0A0: Back area colors.
; $00B0B0: BG palette 0 (colors 02-07 and 12-17)
; $00B0C8: BG palette 1
; $00B0E0: BG palette 2
; $00B0F8: BG palette 3
; $00B110: BG palette 4
; $00B128: BG palette 5
; $00B140: BG palette 6
; $00B158: BG palette 7
; $00B170: Colors 08-0F (Layer 3)
; $00B180: Colors 18-1F (Layer 3)
; $00B190: FG palette 0 (colors 22-27, 32-37)
; $00B1A8: FG palette 1
; $00B1C0: FG palette 2
; $00B1D8: FG palette 3
; $00B1F0: FG palette 4
; $00B208: FG palette 5
; $00B220: FG palette 6
; $00B238: FG palette 7
; $00B250: Level colors 42-47
; $00B25C: Level colors 52-57
; $00B268: Level colors 62-67
; $00B274: Level colors 72-77
; $00B280: Level colors 82-87. Last two colors are overwritten by Mario; only available during the Nintendo Presents.
; $00B28C: Level colors 92-97
; $00B298: Level colors A2-A7. Also used by Ludwig, for palette 0.
; $00B2A4: Level colors B2-B7. Also used by Roy, for palette 0.
; $00B2B0: Level colors C2-C7
; $00B2BC: Level colors D2-D7. Also used by Morton, for palette 0.
; $00B2C8: Mario palette (palette 8, colors 6-F).
; $00B2DC: Luigi palette.
; $00B2F0: Fire Mario palette.
; $00B304: Fire Luigi palette.
; $00B318: Sprite palette 0 (colors E2-E7, F2-F7).
; $00B330: Sprite palette 1
; $00B348: Sprite palette 2
; $00B360: Sprite palette 3
; $00B378: Sprite palette 4. Also used for Morton and Roy in the credits.
; $00B390: Sprite palette 5
; $00B3A8: Sprite palette 6
; $00B3C0: Sprite palette 7. Also used in palette 8/9 for Bowser and Ludwig in the credits.
; $00B3D8: Yoshi's Island palettes 4-7, colors 1-7.
; $00B410: Main map palettes 4-7, colors 1-7.
; $00B448: Star World palettes 4-7, colors 1-7.
; $00B480: Vanilla Dome / Valley of Bowser palettes 4-7, colors 1-7.
; $00B4B8: Forest of Illusion palettes 4-7, colors 1-7.
; $00B4F0: Special World palettes 4-7, colors 1-7.
; $00B528: Overworld colors 29-2F
; $00B536: Overworld colors 39-3F
; $00B544: Overworld colors 49-4F
; $00B552: Colors 59-5F. Always uploaded, but only used on the overworld.
; $00B560: Colors 69-6F. Always uploaded, but only used on the overworld.
; $00B56E: Colors 79-7F. Always uploaded, but only used on the overworld.
; $00B57C: Overworld colors 81-87. Last two colors are overwritten by Mario.
; $00B58A: Overworld colors 91-97
; $00B598: Overworld colors A1-A7
; $00B5A6: Overworld colors B1-B7
; $00B5B4: Overworld colors C1-C7
; $00B5C2: Overworld colors D1-D7
; $00B5D0: Overworld colors E1-E7
; $00B5DE: Overworld colors F1-F7. Also used for the game's lightning effects.
; $00B5EC: Overworld colors 08-0F. $00B5F4 is also loaded for Mode 7 bosses for some reason (except Iggy/Larry).
; $00B5FC: Overworld colors 18-1F.
; $00B60C: Palette animation for color 64 (Yoshi coin) and color 6D (yellow level tile)
; $00B61C: Palette animation for color 7D (red level tile)
; $00B62C: Title screen colors 19-1F
; $00B63C: Title screen colors 09-0F
; $00B64C: ?
; $00B65C: Palette for Iggy/Larry's platform.
; $00B66C: Colors 0C-0F (Layer 3 crushers)
; $00B674: Level colors 29-2F and 99-9F (berries)
; $00B682: Level colors 39-3F and A9-AF (berries)
; $00B690: Level colors 49-4F and B9-BF (berries)
; $00B69E: Bowser palettes; used for his fade effect.
; Animates colors 02-07.
; $00B70E: "The End" colors D2-D7. Used by Luigi.
; $00B71A: "The End" colors D2-D7. Used by Mario.
; $00B726: "The End" colors D2-D7. Used by Peach.
; $00B732: Yoshi's Island [special] palettes 4-7, colors 1-7.
; $00B76A: Main map [special] palettes 4-7, colors 1-7.
; $00B7A2: Star World [special] palettes 4-7, colors 1-7.
; $00B7DA: Vanilla Dome / Valley of Bowser [special] palettes 4-7, colors 1-7.
; $00B812: Forest of Illusion [special] palettes 4-7, colors 1-7.
; $00B84A: Special World [special] palettes 4-7, colors 1-7.
; $00B882: ?
    REP #$10                                  ; XY->16; Routine to decompress GFX33 and GFX32.
    LDY.W #GFX33                              ; \
    STY.B GraphicsCompPtr                     ; |Store the address 08/BFC0 at $8A-$8C; $8A = $08BFC0 (GFX33)
    LDA.B #GFX33>>16                          ; |
    STA.B GraphicsCompPtr+2                   ; /
    LDY.W #MarioGraphics                      ; \
    STY.B _0                                  ; |Store the address 7E/2000 at $00-$02; $00 = $7E2000
    LDA.B #MarioGraphics>>16&$7F              ; |
    STA.B _2                                  ; /
    JSR CODE_00B8DE                           ; Decompress GFX33 to $7E2000.
    LDA.B #MarioGraphics>>16&$7F              ; \
    STA.B GraphicsUncompPtr+2                 ; |
    REP #$30                                  ; |AXY->16, Store the address 7E/ACFE at $8D-$8F; $8D = $7EACFE (end of $7E7D00)
    LDA.W #MarioGraphics+$8CFE                ; |
    STA.B GraphicsUncompPtr                   ; /
    LDX.W #$23FF
CODE_00B8AD:
    LDY.W #$0008
  - LDA.L MarioGraphics,X
    AND.W #$00FF                              ; Copy the data from $7E2000 to $7E7D00,
    STA.B [GraphicsUncompPtr]                 ; and convert from 3bpp to 4bpp in the process.
    DEX
    DEC.B GraphicsUncompPtr
    DEC.B GraphicsUncompPtr
    DEY
    BNE -
    LDY.W #$0008
CODE_00B8C4:
    DEX
    LDA.L MarioGraphics,X
    STA.B [GraphicsUncompPtr]
    DEX
    BMI CODE_00B8D7
    DEC.B GraphicsUncompPtr
    DEC.B GraphicsUncompPtr
    DEY
    BNE CODE_00B8C4
    BRA CODE_00B8AD

CODE_00B8D7:
; Done decompressing GFX33, now for GFX32.
    LDA.W #$8000                              ; $8A = $088000 (GFX32).
    STA.B GraphicsCompPtr
    SEP #$20                                  ; A->8
CODE_00B8DE:
; Subroutine to decompress LC_LZ2 data from the pointer in $8A to the destination in $00.
    REP #$10                                  ; XY->16; See SMWiki's page for details: http://old.smwiki.net/wiki/LC_LZ2
    LDY.W #$0000                              ; \; Note: $8A is modified, $00 is not.
CODE_00B8E3:
    JSR ReadByte                              ; |
    CMP.B #$FF                                ; |If the next byte is xFF, return.
    BNE +                                     ; |Compressed graphics files ends with xFF IIRC; Return if end sentinel is reached.
    SEP #$10                                  ; | XY->8
    RTS                                       ; /

  + STA.B GraphicsUncompPtr+2                 ; End not reached.
    AND.B #$E0
    CMP.B #$E0                                ; Branch if the command is "long length".
    BEQ CODE_00B8FF
    PHA
    LDA.B GraphicsUncompPtr+2
    REP #$20                                  ; A->16; Standard length command: use lower 5 bits as length.
    AND.W #$001F
    BRA +

CODE_00B8FF:
    LDA.B GraphicsUncompPtr+2                 ; "Long length" (2-byte) command.
    ASL A
    ASL A                                     ; Get the actual command.
    ASL A
    AND.B #$E0
    PHA
    LDA.B GraphicsUncompPtr+2
    AND.B #$03                                ; Get full 10-bit length.
    XBA
    JSR ReadByte
    REP #$20                                  ; A->16
; Continuing.
  + INC A                                     ; Preserve length in $8D.
    STA.B GraphicsUncompPtr
    SEP #$20                                  ; A->8
    PLA                                       ; Branch to appropriate command.
    BEQ CODE_00B930                           ; 000 - $00B930 (direct copy)
    BMI CODE_00B966                           ; 1xx - $00B966 (copy memory)
    ASL A                                     ; 001 - $00B93F (byte fill)
    BPL CODE_00B93F                           ; 010 - $00B94C (word fill)
    ASL A                                     ; 011 - continue (increasing fill)
    BPL CODE_00B94C
    JSR ReadByte
    LDX.B GraphicsUncompPtr
; Increasing fill:
  - STA.B [_0],Y                              ; Repeat a byte L+1 times, increasing the byte each time.
    INC A
    INY
    DEX
    BNE -
    JMP CODE_00B8E3

CODE_00B930:
    JSR ReadByte                              ; Direct copy (000).
    STA.B [_0],Y
    INY                                       ; Read and write bytes directly for L+1 bytes.
    LDX.B GraphicsUncompPtr
    DEX
    STX.B GraphicsUncompPtr
    BNE CODE_00B930
    BRA CODE_00B8E3

CODE_00B93F:
    JSR ReadByte                              ; Byte fill (001).
    LDX.B GraphicsUncompPtr
  - STA.B [_0],Y                              ; Repeat one byte L+1 times.
    INY
    DEX
    BNE -
    BRA CODE_00B8E3

CODE_00B94C:
    JSR ReadByte                              ; Word fill (010).
    XBA
    JSR ReadByte
    LDX.B GraphicsUncompPtr
CODE_00B955:
    XBA
    STA.B [_0],Y                              ; Repeat two bytes (L+1)/2 times.
    INY
    DEX
    BEQ CODE_00B963
    XBA
    STA.B [_0],Y
    INY
    DEX
    BNE CODE_00B955
CODE_00B963:
    JMP CODE_00B8E3                           ; Command is finished, go get next one.

CODE_00B966:
    JSR ReadByte                              ; Copy memory (1xx).
    XBA
    JSR ReadByte
if ver_has_rev_gfx(!_VER)                     ;\==================== J & E1 ===================
    XBA                                       ;! ThinkingFace
endif                                         ;/===============================================
    TAX
  - PHY
    TXY
    LDA.B [_0],Y                              ; Copies L+1 already-written bytes from another area in memory.
    TYX                                       ; The two bytes immediately after the command contain the address to copy.
    PLY
    STA.B [_0],Y
    INY
    INX
    REP #$20                                  ; A->16
    DEC.B GraphicsUncompPtr
    SEP #$20                                  ; A->8
    BNE -
    JMP CODE_00B8E3

ReadByte:
    LDA.B [GraphicsCompPtr]                   ; Read the byte; Subroutine to load a byte of compressed graphics data to A.
    LDX.B GraphicsCompPtr                     ; \ Go to next byte
    INX                                       ; |
    BNE +                                     ; |   \
    LDX.W #$8000                              ; |    |Handle bank crossing; Increment pointer, and cross a bank if necessary.
    INC.B GraphicsCompPtr+2                   ; |   /
  + STX.B GraphicsCompPtr                     ; /
    RTS

GFXFilesLow:
    db GFX00
    db GFX01
    db GFX02
    db GFX03
    db GFX04
    db GFX05
    db GFX06
    db GFX07
    db GFX08
    db GFX09
    db GFX0A
    db GFX0B
    db GFX0C
    db GFX0D
    db GFX0E
    db GFX0F
    db GFX10
    db GFX11
    db GFX12
    db GFX13
    db GFX14
    db GFX15
    db GFX16
    db GFX17
    db GFX18
    db GFX19
    db GFX1A
    db GFX1B
    db GFX1C
    db GFX1D
    db GFX1E
    db GFX1F
    db GFX20
    db GFX21
    db GFX22
    db GFX23
    db GFX24
    db GFX25
    db GFX26
    db GFX27
    db GFX28
    db GFX29
    db GFX2A
    db GFX2B
    db GFX2C
    db GFX2D
    db GFX2E
    db GFX2F
    db GFX30
    db GFX31

GFXFilesHigh:
    db GFX00>>8
    db GFX01>>8
    db GFX02>>8
    db GFX03>>8
    db GFX04>>8
    db GFX05>>8
    db GFX06>>8
    db GFX07>>8
    db GFX08>>8
    db GFX09>>8
    db GFX0A>>8
    db GFX0B>>8
    db GFX0C>>8
    db GFX0D>>8
    db GFX0E>>8
    db GFX0F>>8
    db GFX10>>8
    db GFX11>>8
    db GFX12>>8
    db GFX13>>8
    db GFX14>>8
    db GFX15>>8
    db GFX16>>8
    db GFX17>>8
    db GFX18>>8
    db GFX19>>8
    db GFX1A>>8
    db GFX1B>>8
    db GFX1C>>8
    db GFX1D>>8
    db GFX1E>>8
    db GFX1F>>8
    db GFX20>>8
    db GFX21>>8
    db GFX22>>8
    db GFX23>>8
    db GFX24>>8
    db GFX25>>8
    db GFX26>>8
    db GFX27>>8
    db GFX28>>8
    db GFX29>>8
    db GFX2A>>8
    db GFX2B>>8
    db GFX2C>>8
    db GFX2D>>8
    db GFX2E>>8
    db GFX2F>>8
    db GFX30>>8
    db GFX31>>8

GFXFilesBank:
    db GFX00>>16
    db GFX01>>16
    db GFX02>>16
    db GFX03>>16
    db GFX04>>16
    db GFX05>>16
    db GFX06>>16
    db GFX07>>16
    db GFX08>>16
    db GFX09>>16
    db GFX0A>>16
    db GFX0B>>16
    db GFX0C>>16
    db GFX0D>>16
    db GFX0E>>16
    db GFX0F>>16
    db GFX10>>16
    db GFX11>>16
    db GFX12>>16
    db GFX13>>16
    db GFX14>>16
    db GFX15>>16
    db GFX16>>16
    db GFX17>>16
    db GFX18>>16
    db GFX19>>16
    db GFX1A>>16
    db GFX1B>>16
    db GFX1C>>16
    db GFX1D>>16
    db GFX1E>>16
    db GFX1F>>16
    db GFX20>>16
    db GFX21>>16
    db GFX22>>16
    db GFX23>>16
    db GFX24>>16
    db GFX25>>16
    db GFX26>>16
    db GFX27>>16
    db GFX28>>16
    db GFX29>>16
    db GFX2A>>16
    db GFX2B>>16
    db GFX2C>>16
    db GFX2D>>16
    db GFX2E>>16
    db GFX2F>>16
    db GFX30>>16
    db GFX31>>16

PrepareGraphicsFile:
; GFX file pointers, low byte.
; 00-07
; 08-0F
; 10-17
; 18-1F
; 20-27
; 28-2F
; 30-31
; GFX file pointers, high byte.
; GFX file pointers, long byte.
; Scratch RAM returns:
; $00 - 24-bit pointer to the GFX file decompression buffer ($7EAD00).
; $8A - 24-bit pointer to the compressed GFX file.
; Scratch RAM usage:
; Y   - GFX file to get.
; Routine to decompress a file to RAM. Also stores the pointer to RAM in $00.
    PHB                                       ; Note: this routine does not handle the 3bpp->4bpp conversion.
    PHY
    PHK
    PLB
    LDA.W GFXFilesLow,Y
    STA.B GraphicsCompPtr
    LDA.W GFXFilesHigh,Y                      ; Get compressed graphics pointer.
    STA.B GraphicsCompPtr+1
    LDA.W GFXFilesBank,Y
    STA.B GraphicsCompPtr+2
    LDA.B #$00
    STA.B _0
    LDA.B #$AD                                ; Make a pointer to the GFX file decompression buffer.
    STA.B _1                                  ; ($7EAD00)
    LDA.B #$7E
    STA.B _2
    JSR CODE_00B8DE                           ; Decompress file.
    PLY
    PLB
    RTL

    %insert_empty($12,$13,$03,$00,$00)

DATA_00BA60:
    db Map16TilesLow
    db Map16TilesLow+$1B0
    db Map16TilesLow+$360
    db Map16TilesLow+$510
    db Map16TilesLow+$6C0
    db Map16TilesLow+$870
    db Map16TilesLow+$A20
    db Map16TilesLow+$BD0
    db Map16TilesLow+$D80
    db Map16TilesLow+$F30
    db Map16TilesLow+$10E0
    db Map16TilesLow+$1290
    db Map16TilesLow+$1440
    db Map16TilesLow+$15F0
    db Map16TilesLow+$17A0
    db Map16TilesLow+$1950
DATA_00BA70:
    db Map16TilesLow+$1B00
    db Map16TilesLow+$1CB0
    db Map16TilesLow+$1E60
    db Map16TilesLow+$2010
    db Map16TilesLow+$21C0
    db Map16TilesLow+$2370
    db Map16TilesLow+$2520
    db Map16TilesLow+$26D0
    db Map16TilesLow+$2880
    db Map16TilesLow+$2A30
    db Map16TilesLow+$2BE0
    db Map16TilesLow+$2D90
    db Map16TilesLow+$2F40
    db Map16TilesLow+$30F0
    db Map16TilesLow+$32A0
    db Map16TilesLow+$3450

DATA_00BA80:
    db Map16TilesLow
    db Map16TilesLow+$200
    db Map16TilesLow+$400
    db Map16TilesLow+$600
    db Map16TilesLow+$800
    db Map16TilesLow+$A00
    db Map16TilesLow+$C00
    db Map16TilesLow+$E00
    db Map16TilesLow+$1000
    db Map16TilesLow+$1200
    db Map16TilesLow+$1400
    db Map16TilesLow+$1600
    db Map16TilesLow+$1800
    db Map16TilesLow+$1A00
DATA_00BA8E:
    db Map16TilesLow+$1C00
    db Map16TilesLow+$1E00
    db Map16TilesLow+$2000
    db Map16TilesLow+$2200
    db Map16TilesLow+$2400
    db Map16TilesLow+$2600
    db Map16TilesLow+$2800
    db Map16TilesLow+$2A00
    db Map16TilesLow+$2C00
    db Map16TilesLow+$2E00
    db Map16TilesLow+$3000
    db Map16TilesLow+$3200
    db Map16TilesLow+$3400
    db Map16TilesLow+$3600

DATA_00BA9C:
    db Map16TilesLow>>8
    db Map16TilesLow+$1B0>>8
    db Map16TilesLow+$360>>8
    db Map16TilesLow+$510>>8
    db Map16TilesLow+$6C0>>8
    db Map16TilesLow+$870>>8
    db Map16TilesLow+$A20>>8
    db Map16TilesLow+$BD0>>8
    db Map16TilesLow+$D80>>8
    db Map16TilesLow+$F30>>8
    db Map16TilesLow+$10E0>>8
    db Map16TilesLow+$1290>>8
    db Map16TilesLow+$1440>>8
    db Map16TilesLow+$15F0>>8
    db Map16TilesLow+$17A0>>8
    db Map16TilesLow+$1950>>8
DATA_00BAAC:
    db Map16TilesLow+$1B00>>8
    db Map16TilesLow+$1CB0>>8
    db Map16TilesLow+$1E60>>8
    db Map16TilesLow+$2010>>8
    db Map16TilesLow+$21C0>>8
    db Map16TilesLow+$2370>>8
    db Map16TilesLow+$2520>>8
    db Map16TilesLow+$26D0>>8
    db Map16TilesLow+$2880>>8
    db Map16TilesLow+$2A30>>8
    db Map16TilesLow+$2BE0>>8
    db Map16TilesLow+$2D90>>8
    db Map16TilesLow+$2F40>>8
    db Map16TilesLow+$30F0>>8
    db Map16TilesLow+$32A0>>8
    db Map16TilesLow+$3450>>8

DATA_00BABC:
    db Map16TilesLow>>8
    db Map16TilesLow+$200>>8
    db Map16TilesLow+$400>>8
    db Map16TilesLow+$600>>8
    db Map16TilesLow+$800>>8
    db Map16TilesLow+$A00>>8
    db Map16TilesLow+$C00>>8
    db Map16TilesLow+$E00>>8
    db Map16TilesLow+$1000>>8
    db Map16TilesLow+$1200>>8
    db Map16TilesLow+$1400>>8
    db Map16TilesLow+$1600>>8
    db Map16TilesLow+$1800>>8
    db Map16TilesLow+$1A00>>8
DATA_00BACA:
    db Map16TilesLow+$1C00>>8
    db Map16TilesLow+$1E00>>8
    db Map16TilesLow+$2000>>8
    db Map16TilesLow+$2200>>8
    db Map16TilesLow+$2400>>8
    db Map16TilesLow+$2600>>8
    db Map16TilesLow+$2800>>8
    db Map16TilesLow+$2A00>>8
    db Map16TilesLow+$2C00>>8
    db Map16TilesLow+$2E00>>8
    db Map16TilesLow+$3000>>8
    db Map16TilesLow+$3200>>8
    db Map16TilesLow+$3400>>8
    db Map16TilesLow+$3600>>8

DATA_00BAD8:
    dl Map16TilesLow
    dl Map16TilesLow+$1B0
    dl Map16TilesLow+$360
    dl Map16TilesLow+$510
    dl Map16TilesLow+$6C0
    dl Map16TilesLow+$870
    dl Map16TilesLow+$A20
    dl Map16TilesLow+$BD0
    dl Map16TilesLow+$D80
    dl Map16TilesLow+$F30
    dl Map16TilesLow+$10E0
    dl Map16TilesLow+$1290
    dl Map16TilesLow+$1440
    dl Map16TilesLow+$15F0
    dl Map16TilesLow+$17A0
    dl Map16TilesLow+$1950

DATA_00BB08:
    dl Map16TilesLow+$1B00
    dl Map16TilesLow+$1CB0
    dl Map16TilesLow+$1E60
    dl Map16TilesLow+$2010
    dl Map16TilesLow+$21C0
    dl Map16TilesLow+$2370
    dl Map16TilesLow+$2520
    dl Map16TilesLow+$26D0
    dl Map16TilesLow+$2880
    dl Map16TilesLow+$2A30
    dl Map16TilesLow+$2BE0
    dl Map16TilesLow+$2D90
    dl Map16TilesLow+$2F40
    dl Map16TilesLow+$30F0
    dl Map16TilesLow+$32A0
    dl Map16TilesLow+$3450

DATA_00BB38:
    dl Map16TilesLow
    dl Map16TilesLow+$200
    dl Map16TilesLow+$400
    dl Map16TilesLow+$600
    dl Map16TilesLow+$800
    dl Map16TilesLow+$A00
    dl Map16TilesLow+$C00
    dl Map16TilesLow+$E00
    dl Map16TilesLow+$1000
    dl Map16TilesLow+$1200
    dl Map16TilesLow+$1400
    dl Map16TilesLow+$1600
    dl Map16TilesLow+$1800
    dl Map16TilesLow+$1A00

DATA_00BB62:
    dl Map16TilesLow+$1B00
    dl Map16TilesLow+$1CB0
    dl Map16TilesLow+$1E60
    dl Map16TilesLow+$2010
    dl Map16TilesLow+$21C0
    dl Map16TilesLow+$2370
    dl Map16TilesLow+$2520
    dl Map16TilesLow+$26D0
    dl Map16TilesLow+$2880
    dl Map16TilesLow+$2A30
    dl Map16TilesLow+$2BE0
    dl Map16TilesLow+$2D90
    dl Map16TilesLow+$2F40
    dl Map16TilesLow+$30F0
    dl Map16TilesLow+$32A0
    dl Map16TilesLow+$3450

DATA_00BB92:
    dl Map16TilesLow
    dl Map16TilesLow+$1B0
    dl Map16TilesLow+$360
    dl Map16TilesLow+$510
    dl Map16TilesLow+$6C0
    dl Map16TilesLow+$870
    dl Map16TilesLow+$A20
    dl Map16TilesLow+$BD0
    dl Map16TilesLow+$D80
    dl Map16TilesLow+$F30
    dl Map16TilesLow+$10E0
    dl Map16TilesLow+$1290
    dl Map16TilesLow+$1440
    dl Map16TilesLow+$15F0
    dl Map16TilesLow+$17A0
    dl Map16TilesLow+$1950

DATA_00BBC2:
    dl Map16TilesLow+$1C00
    dl Map16TilesLow+$1E00
    dl Map16TilesLow+$2000
    dl Map16TilesLow+$2200
    dl Map16TilesLow+$2400
    dl Map16TilesLow+$2600
    dl Map16TilesLow+$2800
    dl Map16TilesLow+$2A00
    dl Map16TilesLow+$2C00
    dl Map16TilesLow+$2E00
    dl Map16TilesLow+$3000
    dl Map16TilesLow+$3200
    dl Map16TilesLow+$3400
    dl Map16TilesLow+$3600

DATA_00BBEC:
    dl Map16TilesLow
    dl Map16TilesLow+$200
    dl Map16TilesLow+$400
    dl Map16TilesLow+$600
    dl Map16TilesLow+$800
    dl Map16TilesLow+$A00
    dl Map16TilesLow+$C00
    dl Map16TilesLow+$E00
    dl Map16TilesLow+$1000
    dl Map16TilesLow+$1200
    dl Map16TilesLow+$1400
    dl Map16TilesLow+$1600
    dl Map16TilesLow+$1800
    dl Map16TilesLow+$1A00

DATA_00BC16:
    dl Map16TilesLow+$1C00
    dl Map16TilesLow+$1E00
    dl Map16TilesLow+$2000
    dl Map16TilesLow+$2200
    dl Map16TilesLow+$2400
    dl Map16TilesLow+$2600
    dl Map16TilesLow+$2800
    dl Map16TilesLow+$2A00
    dl Map16TilesLow+$2C00
    dl Map16TilesLow+$2E00
    dl Map16TilesLow+$3000
    dl Map16TilesLow+$3200
    dl Map16TilesLow+$3400
    dl Map16TilesLow+$3600

DATA_00BC40:
    dl Map16TilesHigh
    dl Map16TilesHigh+$1B0
    dl Map16TilesHigh+$360
    dl Map16TilesHigh+$510
    dl Map16TilesHigh+$6C0
    dl Map16TilesHigh+$870
    dl Map16TilesHigh+$A20
    dl Map16TilesHigh+$BD0
    dl Map16TilesHigh+$D80
    dl Map16TilesHigh+$F30
    dl Map16TilesHigh+$10E0
    dl Map16TilesHigh+$1290
    dl Map16TilesHigh+$1440
    dl Map16TilesHigh+$15F0
    dl Map16TilesHigh+$17A0
    dl Map16TilesHigh+$1950

DATA_00BC70:
    dl Map16TilesHigh+$1B00
    dl Map16TilesHigh+$1CB0
    dl Map16TilesHigh+$1E60
    dl Map16TilesHigh+$2010
    dl Map16TilesHigh+$21C0
    dl Map16TilesHigh+$2370
    dl Map16TilesHigh+$2520
    dl Map16TilesHigh+$26D0
    dl Map16TilesHigh+$2880
    dl Map16TilesHigh+$2A30
    dl Map16TilesHigh+$2BE0
    dl Map16TilesHigh+$2D90
    dl Map16TilesHigh+$2F40
    dl Map16TilesHigh+$30F0
    dl Map16TilesHigh+$32A0
    dl Map16TilesHigh+$3450

DATA_00BCA0:
    dl Map16TilesHigh
    dl Map16TilesHigh+$200
    dl Map16TilesHigh+$400
    dl Map16TilesHigh+$600
    dl Map16TilesHigh+$800
    dl Map16TilesHigh+$A00
    dl Map16TilesHigh+$C00
    dl Map16TilesHigh+$E00
    dl Map16TilesHigh+$1000
    dl Map16TilesHigh+$1200
    dl Map16TilesHigh+$1400
    dl Map16TilesHigh+$1600
    dl Map16TilesHigh+$1800
    dl Map16TilesHigh+$1A00

DATA_00BCCA:
    dl Map16TilesHigh+$1B00
    dl Map16TilesHigh+$1CB0
    dl Map16TilesHigh+$1E60
    dl Map16TilesHigh+$2010
    dl Map16TilesHigh+$21C0
    dl Map16TilesHigh+$2370
    dl Map16TilesHigh+$2520
    dl Map16TilesHigh+$26D0
    dl Map16TilesHigh+$2880
    dl Map16TilesHigh+$2A30
    dl Map16TilesHigh+$2BE0
    dl Map16TilesHigh+$2D90
    dl Map16TilesHigh+$2F40
    dl Map16TilesHigh+$30F0
    dl Map16TilesHigh+$32A0
    dl Map16TilesHigh+$3450

DATA_00BCFA:
    dl Map16TilesHigh
    dl Map16TilesHigh+$1B0
    dl Map16TilesHigh+$360
    dl Map16TilesHigh+$510
    dl Map16TilesHigh+$6C0
    dl Map16TilesHigh+$870
    dl Map16TilesHigh+$A20
    dl Map16TilesHigh+$BD0
    dl Map16TilesHigh+$D80
    dl Map16TilesHigh+$F30
    dl Map16TilesHigh+$10E0
    dl Map16TilesHigh+$1290
    dl Map16TilesHigh+$1440
    dl Map16TilesHigh+$15F0
    dl Map16TilesHigh+$17A0
    dl Map16TilesHigh+$1950

DATA_00BD2A:
    dl Map16TilesHigh+$1C00
    dl Map16TilesHigh+$1E00
    dl Map16TilesHigh+$2000
    dl Map16TilesHigh+$2200
    dl Map16TilesHigh+$2400
    dl Map16TilesHigh+$2600
    dl Map16TilesHigh+$2800
    dl Map16TilesHigh+$2A00
    dl Map16TilesHigh+$2C00
    dl Map16TilesHigh+$2E00
    dl Map16TilesHigh+$3000
    dl Map16TilesHigh+$3200
    dl Map16TilesHigh+$3400
    dl Map16TilesHigh+$3600

DATA_00BD54:
    dl Map16TilesHigh
    dl Map16TilesHigh+$200
    dl Map16TilesHigh+$400
    dl Map16TilesHigh+$600
    dl Map16TilesHigh+$800
    dl Map16TilesHigh+$A00
    dl Map16TilesHigh+$C00
    dl Map16TilesHigh+$E00
    dl Map16TilesHigh+$1000
    dl Map16TilesHigh+$1200
    dl Map16TilesHigh+$1400
    dl Map16TilesHigh+$1600
    dl Map16TilesHigh+$1800
    dl Map16TilesHigh+$1A00

DATA_00BD7E:
    dl Map16TilesHigh+$1C00
    dl Map16TilesHigh+$1E00
    dl Map16TilesHigh+$2000
    dl Map16TilesHigh+$2200
    dl Map16TilesHigh+$2400
    dl Map16TilesHigh+$2600
    dl Map16TilesHigh+$2800
    dl Map16TilesHigh+$2A00
    dl Map16TilesHigh+$2C00
    dl Map16TilesHigh+$2E00
    dl Map16TilesHigh+$3000
    dl Map16TilesHigh+$3200
    dl Map16TilesHigh+$3400
    dl Map16TilesHigh+$3600

Ptrs00BDA8:
    dw DATA_00BAD8
    dw DATA_00BAD8
    dw DATA_00BAD8
    dw DATA_00BB38
    dw DATA_00BB38
    dw DATA_00BB92
    dw DATA_00BB92
    dw DATA_00BBEC
    dw DATA_00BBEC
    dw $0000
    dw DATA_00BBEC
    dw $0000
    dw DATA_00BAD8
    dw DATA_00BBEC
    dw DATA_00BAD8
    dw DATA_00BAD8
    dw $0000
    dw DATA_00BAD8
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw DATA_00BAD8
    dw DATA_00BAD8

Ptrs00BDE8:
    dw DATA_00BB08
    dw DATA_00BB08
    dw DATA_00BB08
    dw DATA_00BB62
    dw DATA_00BB62
    dw DATA_00BBC2
    dw DATA_00BBC2
    dw DATA_00BC16
    dw DATA_00BC16
    dw $0000
    dw DATA_00BC16
    dw $0000
    dw DATA_00BB08
    dw DATA_00BC16
    dw DATA_00BB08
    dw DATA_00BB08
    dw $0000
    dw DATA_00BB08
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw DATA_00BB08
    dw DATA_00BB08

Ptrs00BE28:
    dw DATA_00BC40
    dw DATA_00BC40
    dw DATA_00BC40
    dw DATA_00BCA0
    dw DATA_00BCA0
    dw DATA_00BCFA
    dw DATA_00BCFA
    dw DATA_00BD54
    dw DATA_00BD54
    dw $0000
    dw DATA_00BD54
    dw $0000
    dw DATA_00BC40
    dw DATA_00BD54
    dw DATA_00BC40
    dw DATA_00BC40
    dw $0000
    dw DATA_00BC40
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw DATA_00BC40
    dw DATA_00BC40

Ptrs00BE68:
    dw DATA_00BC70
    dw DATA_00BC70
    dw DATA_00BC70
    dw DATA_00BCCA
    dw DATA_00BCCA
    dw DATA_00BD2A
    dw DATA_00BD2A
    dw DATA_00BD7E
    dw DATA_00BD7E
    dw $0000
    dw DATA_00BD7E
    dw $0000
    dw DATA_00BC70
    dw DATA_00BD7E
    dw DATA_00BC70
    dw DATA_00BC70
    dw $0000
    dw DATA_00BC70
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw DATA_00BC70
    dw DATA_00BC70

LoadBlkPtrs:
    dw Ptrs00BDA8
    dw Ptrs00BDE8
LoadBlkTable2:
    dw Ptrs00BE28
    dw Ptrs00BE68

GenerateTile:
; Low bytes of Map16 pointers in horizontal levels. Indexed by screen number; each screen is x1B0 bytes.
; Continued from above, alternatively used for Layer 2.
; Low bytes of Map16 pointers in vertical levels. Indexed by screen number; each screen is x200 bytes (meaning these are pointless...).
; Continued from above, alternatively used for Layer 2.
; High bytes of Map16 pointers in horizontal levels. Indexed by screen number; each screen is x1B0 bytes.
; Continued from above, alternatively used for Layer 2.
; High bytes of Map16 pointers in vertical levels. Indexed by screen number; each screen is x200 bytes.
; Continued from above, alternatively used for Layer 2.
; Low Map16 block data pointers ($6B) for a horizontal Layer 1. Indexed by screen number.
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
; Continued from above, alternatively used for Layer 2.
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
; 1B
; 1C
; 1D
; 1E
; 1F
; Low Map16 block data pointers ($6B) for an unused Layer 1 layout. Indexed by screen number.
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
; Continued from above, alternatively used for Layer 2.
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
; 1B
; 1C
; 1D
; Low Map16 block data pointers ($6B) for an unused Layer 1 layout. Indexed by screen number.
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
; Continued from above, alternatively used for Layer 2.
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
; 1B
; 1C
; 1D
; Low Map16 block data pointers ($6B) for a vertical Layer 1. Indexed by screen number.
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
; Continued from above, alternatively used for Layer 2.
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
; 1B
; High Map16 block data pointers ($6E) for a horizontal Layer 1. Indexed by screen number.
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
; Continued from above, alternatively used for Layer 2.
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
; 1B
; 1C
; 1D
; 1E
; 1F
; High Map16 block data pointers ($6E) for an unused Layer 1. Indexed by screen number.
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
; Continued from above, alternatively used for Layer 2.
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
; 1B
; 1C
; 1D
; High Map16 block data pointers ($6E) for an unused Layer 1. Indexed by screen number.
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
; Continued from above, alternatively used for Layer 2.
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
; 1B
; 1C
; 1D
; High Map16 block data pointers ($6E) for a vertical Layer 1. Indexed by screen number.
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
; Continued from above, alternatively used for Layer 2.
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
; 1B
; Pointers to the low Map16 block data pointers for Layer 1. Indexed by level mode.
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
; 1B
; 1C
; 1D
; 1E
; 1F
; Pointers to the low Map16 block data pointers for Layer 2. Indexed by level mode.
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
; 1B
; 1C
; 1D
; 1E
; 1F
; Pointers to the high Map16 block data pointers for Layer 1. Indexed by level mode.
; Pointers to the high Map16 block data pointers for Layer 2. Indexed by level mode.
; Pointers to the low Map16 data block pointer tables for processing Layer 1 vs Layer 2.
; Yes, that means these are pointers to pointers to pointers.
; Pointers to the high Map16 data block pointer tables for processing Layer 1 vs Layer 2.
; RAM setup:
; $98   - 16-bit Y position of the tile.
; $9A   - 16-bit X position of the tile.
; $1933 - Layer to spawn the tile on (00 = layer 1, 01 = layer 2)
; Scratch RAM usage:
; $06   - Index to VRAM (16-bit)
; $08   - Layer X position (16-bit), sort of?
; $0A   - Layer Y position (16-bit), sort of?
    PHP                                       ; Map16 generation routine. Use $9C as the block to spawn.
    REP #$30                                  ; AXY->16
    PHX
    LDA.B Map16TileGenerate
    AND.W #$00FF
    BNE +                                     ; Return if not generating a new tile.
ADDR_00BEBB:
    JMP CODE_00BFB9

  + LDA.B TouchBlockXPos
    STA.B _C                                  ; $0C = tile X position
    LDA.B TouchBlockYPos                      ; $0E = tile Y position
    STA.B _E
    LDA.W #$0000
    SEP #$20                                  ; A->8
    LDA.B ScreenMode                          ; Return if the block would generate outside of the level.
    STA.B _9
    LDA.W LayerProcessing
    BEQ +
    LSR.B _9
  + LDY.B _E
    LDA.B _9
    AND.B #$01
    BEQ +
    LDA.B TouchBlockXPos+1
    STA.B _0                                  ; Swap the block's X and Y positions if in a vertical level.
    LDA.B TouchBlockYPos+1
    STA.B TouchBlockXPos+1
    LDA.B _0
    STA.B TouchBlockYPos+1
    LDY.B _C
  + CPY.W #$0200
    BCS ADDR_00BEBB
    LDA.W LayerProcessing
    ASL A
    TAX                                       ; Get Map16 data pointer to the screen the tile is on.
    LDA.L LoadBlkPtrs,X                       ; Set low byte of pointer; (specific tile indexing is handled later on)
    STA.B Layer1DataPtr
    LDA.L LoadBlkPtrs+1,X                     ; Set middle byte of pointer
    STA.B Layer1DataPtr+1
    STZ.B Layer1DataPtr+2                     ; High byte of pointer = #$00
    LDA.W LevelModeSetting
    ASL A
    TAY
    LDA.B [Layer1DataPtr],Y
    STA.B _4
    INY
    LDA.B [Layer1DataPtr],Y
    STA.B _5
    STZ.B _6
    LDA.B TouchBlockXPos+1
    STA.B _7
    ASL A
    CLC
    ADC.B _7
    TAY
    LDA.B [_4],Y
    STA.B Map16LowPtr
    STA.B Map16HighPtr
    INY
    LDA.B [_4],Y
    STA.B Map16LowPtr+1
    STA.B Map16HighPtr+1
    LDA.B #$7E
    STA.B Map16LowPtr+2
    INC A
    STA.B Map16HighPtr+2
    LDA.B _9
    AND.B #$01
    BEQ +                                     ; $06 = Actual VRAM position to upload to (16-bit)
    LDA.B TouchBlockYPos+1
    LSR A
    LDA.B TouchBlockXPos+1
    AND.B #$01
    JMP CODE_00BF46

  + LDA.B TouchBlockXPos+1
    LSR A
    LDA.B TouchBlockYPos+1
CODE_00BF46:
    ROL A
    ASL A
    ASL A
    ORA.B #$20
    STA.B _4
    CPX.W #$0000
    BEQ +
    CLC
    ADC.B #$10
    STA.B _4
  + LDA.B TouchBlockYPos
    AND.B #$F0
    CLC
    ASL A
    ROL A
    STA.B _5
    ROL A
    AND.B #$03
    ORA.B _4
    STA.B _6
    LDA.B TouchBlockXPos
    AND.B #$F0
    LSR A
    LSR A
    LSR A
    STA.B _4
    LDA.B _5
    AND.B #$C0
    ORA.B _4
    STA.B _7
    REP #$20                                  ; A->16
    LDA.B _9
    AND.W #$0001
    BNE CODE_00BF9B                           ; $08 = Layer X position.
    LDA.B Layer1XPos                          ; $0A = Layer Y position.
    SEC                                       ; x80 is subtracted from one of these two addresses depending on level orientation and layer.
    SBC.W #$0080                              ; Horizontal Layer 1 subtacts from X, vertical from Y.
    TAX                                       ; Opposite for Layer 2.
    LDY.B Layer1YPos
    LDA.W LayerProcessing
    BEQ CODE_00BFB2
    LDX.B Layer2XPos
    LDA.B Layer2YPos
    SEC
    SBC.W #$0080
    TAY
    JMP CODE_00BFB2

CODE_00BF9B:
    LDX.B Layer1XPos
    LDA.B Layer1YPos
    SEC
    SBC.W #$0080
    TAY
    LDA.W LayerProcessing
    BEQ CODE_00BFB2
    LDA.B Layer2XPos
    SEC
    SBC.W #$0080
    TAX
    LDY.B Layer2YPos
CODE_00BFB2:
    STX.B _8
    STY.B _A
    JSR CODE_00BFBC                           ; Run block-specific routines.
CODE_00BFB9:
    PLX
    PLP
    RTL

CODE_00BFBC:
    SEP #$30                                  ; AXY->8
    LDA.B Map16TileGenerate
    DEC A
    PHK
    PER $0003
    JML ExecutePtr                            ; $9C - Tile generated


GeneratedTiles:
    dw CODE_00C074                            ; 01 - empty space
    dw CODE_00C077                            ; 02 - empty space
    dw CODE_00C077                            ; 03 - vine
    dw CODE_00C077                            ; 04 - tree background, for berries
    dw CODE_00C077                            ; 05 - always turning block
    dw CODE_00C077                            ; 06 - coin
    dw CODE_00C077                            ; 07 - Mushroom scale base
    dw CODE_00C077                            ; 08 - mole hole
    dw CODE_00C0C4                            ; 09 - invisible solid
    dw CODE_00C0C4                            ; 0a - multiple coin turnblock
    dw CODE_00C0C4                            ; 0b - multiple coin q block
    dw CODE_00C0C4                            ; 0c - turn block
    dw CODE_00C0C4                            ; 0d - used block
    dw CODE_00C0C4                            ; 0e - music block
    dw CODE_00C0C4                            ; 0f - music
    dw CODE_00C0C4                            ; 10 - all way music block
    dw CODE_00C0C4                            ; 11 - sideways turn block
    dw CODE_00C0C4                            ; 12 - tranlucent
    dw CODE_00C0C4                            ; 13 - on off
    dw CODE_00C0C4                            ; 14 - side of pipe, left
    dw CODE_00C0C4                            ; 15 - side of pipe, right
    dw CODE_00C0C1                            ; 16 - used
    dw CODE_00C0C1                            ; 17 - O block from 1up game
    dw CODE_00C1AC                            ; 18 - invisible block containing wings
    dw CODE_00C334                            ; 19 - cage
    dw CODE_00C334                            ; 1a - cage
    dw CODE_00C3D1                            ; 1b -

DATA_00BFFF:
    dw $0000,$0080,$0100

DATA_00C005:
    db $80,$40,$20,$10,$08,$04,$02,$01

CODE_00C00D:
; Pointers for the different Map16 tile generatable by $00BEB0.
; (025) Empty, sets memory bit
; (025) Empty
; (006) Vine
; (049) Solid bush
; (048) Turning turnblock
; (02B) Coin
; (0A2) Mushroom stalk
; (0C6) Mole hole
; (152) Invisible solid block
; (11B) Multiple coin turnblock
; (123) Multiple coin ? block
; (11E) Turnblock
; (132) Used block
; (113) Noteblock
; (115) Noteblock
; (116) 4-way noteblock
; (12B) Side-bounce turnblock
; (12C) Translucent block
; (112) On/off switch
; (168) Left side of pipe
; (169) Right side of pipe
; (132) Used block, sets memory bit
; (15E) "Correct" block, sets memory bit
; (025) Empty, include tile below, sets memory bit (Yoshi coins)
; (---) 4x4 empty net frame (VRAM only)
; (---) 4x4 net door (VRAM only)
; (-25) 2x2 invisible block, does not set high bytes (switch palace switch)
; Indexes to each item memory table.
; AND values used for setting item memory bits.
    REP #$30                                  ; AXY->16; Subroutine to set an item memory bit.
    LDA.B TouchBlockXPos
    AND.W #$FF00                              ; Get index for the block to the item memory tables.
    LSR A                                     ; Note: far more optimized version available here: https://smwc.me/1477689
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _4
    LDA.B TouchBlockXPos
    AND.W #$0080
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _4
    STA.B _4
    LDA.B TouchBlockYPos
    AND.W #$0100
    BEQ +
    LDA.B _4
    ORA.W #$0002
    STA.B _4
  + LDA.W ItemMemorySetting
    AND.W #$000F
    ASL A
    TAX                                       ; Add the index to the current item memory table.
    LDA.L DATA_00BFFF,X
    CLC
    ADC.B _4
    STA.B _4
    TAY
    LDA.B TouchBlockXPos
    AND.W #$0070
    LSR A
    LSR A
    LSR A
    LSR A                                     ; Set the item memory bit for the column.
    TAX
    SEP #$20                                  ; A->8
    LDA.W ItemMemoryTable,Y
    ORA.L DATA_00C005,X
    STA.W ItemMemoryTable,Y
    RTS


    db $7F,$BF,$DF,$EF,$F7,$FB,$FD,$FE
TileToGeneratePg0:
    db $25,$25,$25,$06,$49,$48,$2B,$A2
    db $C6

CODE_00C074:
; Tiles for $00BEB0 to generate from page 0. First byte is unused.
; Subroutine to generate a tile from Map16 page 0.
    JSR CODE_00C00D                           ; Set  item memory bit.
CODE_00C077:
    REP #$30                                  ; AXY->16
    LDA.B TouchBlockYPos
    AND.W #$01F0
    STA.B _4
    LDA.B TouchBlockXPos
    LSR A
    LSR A
    LSR A
    LSR A
    AND.W #$000F
    ORA.B _4
    TAY
    LDA.B Map16TileGenerate                   ; \ X = index of tile to generate
    AND.W #$00FF                              ; |
    TAX                                       ; /
    SEP #$20                                  ; A->8
    LDA.B [Map16HighPtr],Y                    ; \ Reset #$01 bit
    AND.B #$FE                                ; |
    STA.B [Map16HighPtr],Y                    ; /; Write tile to Map16 data.
    LDA.L TileToGeneratePg0,X                 ; \ Store tile
    STA.B [Map16LowPtr],Y                     ; /
    REP #$20                                  ; A->16
    AND.W #$00FF
    ASL A
    TAY
    JMP CODE_00C0FB                           ; Upload tile to VRAM.


    db $80,$40,$20,$10,$08,$04,$02,$01
TileToGeneratePg1:
    db $52,$1B,$23,$1E,$32,$13,$15,$16
    db $2B,$2C,$12,$68,$69,$32,$5E

CODE_00C0C1:
; AND table. Possibly unused?
; Tiles for $00BEB0 to generate from page 1.
; Scratch RAM setup on entry:
; $08/$0A = layer X/Y position
; $0C/$0E = tile X/Y position
; $06     = 16-bit VRAM position
; Subroutine to generate a tile from Map16 page 1.
    JSR CODE_00C00D                           ; Set item memory bit.
CODE_00C0C4:
    REP #$30                                  ; AXY->16; Alternate entry that doesn't set the item memory bit.
    LDA.B TouchBlockYPos
    AND.W #$01F0
    STA.B _4
    LDA.B TouchBlockXPos
    LSR A
    LSR A
    LSR A
    LSR A
    AND.W #$000F
    ORA.B _4
    TAY
    LDA.B Map16TileGenerate                   ; \ X = index of tile to generate
    SEC                                       ; |
    SBC.W #$0009                              ; |
    AND.W #$00FF                              ; |
    TAX                                       ; /
    SEP #$20                                  ; A->8
    LDA.B [Map16HighPtr],Y                    ; \ Set #$01 bit
    ORA.B #$01                                ; |
    STA.B [Map16HighPtr],Y                    ; /; Write tile to the Map16 data.
    LDA.L TileToGeneratePg1,X                 ; \ Store tile
    STA.B [Map16LowPtr],Y                     ; /
    REP #$20                                  ; A->16
    AND.W #$00FF
    ORA.W #$0100
    ASL A
    TAY
CODE_00C0FB:
    LDA.B ScreenMode                          ; Upload the tile's actual graphics to VRAM.
    STA.B _0
    LDA.W LayerProcessing
    BEQ +
    LSR.B _0
  + LDA.B _0
    AND.W #$0001
    BNE CODE_00C127
    LDA.B _8
    AND.W #$FFF0
    BMI CODE_00C11A
    CMP.B _C
    BEQ CODE_00C13E
    BCS CODE_00C124
CODE_00C11A:
    CLC
    ADC.W #$0200
    CMP.B _C
    BEQ CODE_00C124
    BCS CODE_00C13E
CODE_00C124:
    JMP Return00C1AB

CODE_00C127:
    LDA.B _A
    AND.W #$FFF0
    BMI CODE_00C134
    CMP.B _E
    BEQ CODE_00C13E
    BCS Return00C1AB
CODE_00C134:
    CLC
    ADC.W #$0200
    CMP.B _E
    BEQ Return00C1AB
    BCC Return00C1AB
CODE_00C13E:
    LDA.L DynStripeImgSize
    TAX
    SEP #$20                                  ; A->8
    LDA.B _6
    STA.L DynamicStripeImage,X
    STA.L DynamicStripeImage+8,X
    LDA.B _7
    STA.L DynamicStripeImage+1,X
    CLC
    ADC.B #$20
    STA.L DynamicStripeImage+9,X
    LDA.B #$00
    STA.L DynamicStripeImage+2,X
    STA.L DynamicStripeImage+$0A,X
    LDA.B #$03
    STA.L DynamicStripeImage+3,X
    STA.L DynamicStripeImage+$0B,X
    LDA.B #$FF
    STA.L DynamicStripeImage+$10,X
    LDA.B #$0D
    STA.B _6
    REP #$20                                  ; A->16; [hijacked by LM for a jump to $06F5D0]
    LDA.W Map16Pointers,Y
    STA.B _4
    LDY.W #$0000
    LDA.B [_4],Y
    STA.L DynamicStripeImage+4,X
    INY
    INY
    LDA.B [_4],Y
    STA.L DynamicStripeImage+$0C,X
    INY
    INY
    LDA.B [_4],Y
    STA.L DynamicStripeImage+6,X
    INY
    INY
    LDA.B [_4],Y
    STA.L DynamicStripeImage+$0E,X
    TXA
    CLC
    ADC.W #$0010
    STA.L DynStripeImgSize
Return00C1AB:
    RTS

CODE_00C1AC:
; Erase tile and tile below, set item memory bit (Yoshi coin)
    JSR CODE_00C00D                           ; Set item memory bit.
    REP #$30                                  ; AXY->16
    LDA.B TouchBlockYPos
    AND.W #$01F0
    STA.B _4
    LDA.B TouchBlockXPos
    LSR A
    LSR A
    LSR A
    LSR A
    AND.W #$000F
    ORA.B _4
    TAY
    SEP #$20                                  ; A->8
    LDA.B #$25                                ; Erase tile at the block's position.
    STA.B [Map16LowPtr],Y
    REP #$20                                  ; A->16
    TYA
    CLC
    ADC.W #$0010                              ; How many tiles to add to the Yoshi coin's position for its lower tile (1 row).
    TAY
    SEP #$20                                  ; A->8
    LDA.B #$25                                ; Erase tile one block below.
    STA.B [Map16LowPtr],Y
    REP #$20                                  ; A->16
    AND.W #$00FF
    ASL A
    TAY
    LDA.B ScreenMode
    STA.B _0
    LDA.W LayerProcessing
    BEQ +
    LSR.B _0
  + LDA.B _0
    AND.W #$0001
    BNE CODE_00C20B
    LDA.B _8
    AND.W #$FFF0
    BMI CODE_00C1FE
    CMP.B _C
    BEQ CODE_00C222
    BCS Return00C1AB
CODE_00C1FE:
    CLC
    ADC.W #$0200
    CMP.B _C
    BCC Return00C1AB
    BEQ Return00C1AB
    JMP CODE_00C222

CODE_00C20B:
    LDA.B _A
    AND.W #$FFF0
    BMI CODE_00C218
    CMP.B _E
    BEQ CODE_00C222
    BCS Return00C1AB
CODE_00C218:
    CLC
    ADC.W #$0200
    CMP.B _E
    BEQ Return00C1AB
    BCC Return00C1AB
CODE_00C222:
    LDA.L DynStripeImgSize
    TAX
    SEP #$20                                  ; A->8
    LDA.B _6
    STA.L DynamicStripeImage,X
    STA.L DynamicStripeImage+$0C,X
    LDA.B _7
    STA.L DynamicStripeImage+1,X
    INC A
    STA.L DynamicStripeImage+$0D,X
    LDA.B #$80                                ; Upload position to VRAM.
    STA.L DynamicStripeImage+2,X
    STA.L DynamicStripeImage+$0E,X
    LDA.B #$07
    STA.L DynamicStripeImage+3,X
    STA.L DynamicStripeImage+$0F,X
    LDA.B #$FF
    STA.L DynamicStripeImage+$18,X
    LDA.B #$0D
    STA.B _6
    REP #$20                                  ; A->16; [hijacked by LM for a jump to $06F5D0]
    LDA.W Map16Pointers,Y
    STA.B _4
    LDY.W #$0000
    LDA.B [_4],Y
    STA.L DynamicStripeImage+4,X
    STA.L DynamicStripeImage+8,X
    INY
    INY
    LDA.B [_4],Y
    STA.L DynamicStripeImage+$10,X
    STA.L DynamicStripeImage+$14,X
    INY
    INY                                       ; Upload image to VRAM.
    LDA.B [_4],Y
    STA.L DynamicStripeImage+6,X
    STA.L DynamicStripeImage+$0A,X
    INY
    INY
    LDA.B [_4],Y
    STA.L DynamicStripeImage+$12,X
    STA.L DynamicStripeImage+$16,X
    TXA
    CLC
    ADC.W #$0018                              ; Update stripe upload index.
    STA.L DynStripeImgSize
    RTS


DATA_00C29E:
    db $99,$9C,$8B,$1C,$8B,$1C,$8B,$1C
    db $8B,$1C,$99,$DC,$9B,$1C,$F8,$1C
    db $F8,$1C,$F8,$1C,$F8,$1C,$9B,$5C
    db $9B,$1C,$F8,$1C,$F8,$1C,$F8,$1C
    db $F8,$1C,$9B,$5C,$9B,$1C,$F8,$1C
    db $F8,$1C,$F8,$1C,$F8,$1C,$9B,$5C
    db $9B,$1C,$F8,$1C,$F8,$1C,$F8,$1C
    db $F8,$1C,$9B,$5C,$99,$1C,$8B,$9C
    db $8B,$9C,$8B,$9C,$8B,$9C,$99,$5C
DATA_00C2E6:
    db $BA,$9C,$AB,$1C,$AB,$1C,$AB,$1C
    db $AB,$1C,$BA,$DC,$AA,$1C,$82,$1C
    db $82,$1C,$82,$1C,$82,$1C,$AA,$5C
    db $AA,$1C,$82,$1C,$82,$1C,$82,$1C
    db $82,$1C,$AA,$5C,$AA,$1C,$82,$1C
    db $82,$1C,$82,$1C,$82,$1C,$AA,$5C
    db $AA,$1C,$82,$1C,$82,$1C,$82,$1C
    db $82,$1C,$AA,$5C,$BA,$1C,$AB,$9C
    db $AB,$9C,$AB,$9C,$AB,$9C,$BA,$5C

DATA_00C32E:
    dl DATA_00C29E
    dl DATA_00C2E6

CODE_00C334:
; Tilemaps to write to VRAM for the gate object. Two bytes per 8x8; tile number, then YXPCCCTT.
; $00C29E - Empty
; $00C2E6 - Filled
; Pointers to the above tables, low byte. Indexed by which object is being spawned.
; Pointers to the above tables, high/long bytes. Indexed by which object is being spawned.
    INC.B _7                                  ; 4x4 empty space/gate, only updates VRAM (net door).
    LDA.B _7
    CLC
    ADC.B #$20                                ; Shift VRAM pointer one 8x8 right and down.
    STA.B _7
    LDA.B _6
    ADC.B #$00
    STA.B _6
    LDA.B Map16TileGenerate
    SEC
    SBC.B #$19
    STA.B _0
    ASL A
    CLC                                       ; $00 = ??
    ADC.B _0
    TAX
    LDA.L DATA_00C32E+2,X
    STA.B _4
    REP #$30                                  ; AXY->16
    LDA.L DATA_00C32E,X
    STA.B _2
    LDA.L DynStripeImgSize
    TAX
    LDY.W #$0005
  - SEP #$20                                  ; A->8
    LDA.B _6
    STA.L DynamicStripeImage,X
    LDA.B _7
    STA.L DynamicStripeImage+1,X
    LDA.B #$00
    STA.L DynamicStripeImage+2,X
    LDA.B #$0B
    STA.L DynamicStripeImage+3,X
    LDA.B _7
    CLC
    ADC.B #$20
    STA.B _7
    LDA.B _6
    ADC.B #$00
    STA.B _6
    REP #$20                                  ; A->16
    TXA
    CLC
    ADC.W #$0010
    TAX
    DEY
    BPL -
    LDA.L DynStripeImgSize
    TAX
    LDY.W #$0000
CODE_00C39F:
    LDA.W #$0005
    STA.B _0
  - LDA.B [_2],Y
    STA.L DynamicStripeImage+4,X
    INY
    INY
    INX
    INX
    DEC.B _0
    BPL -
    TXA
    CLC
    ADC.W #$0004
    TAX
    CPY.W #$0048
    BNE CODE_00C39F
    LDA.W #$00FF
    STA.L DynamicStripeImage,X
    LDA.L DynStripeImgSize
    CLC
    ADC.W #$0060
    STA.L DynStripeImgSize
    RTS

CODE_00C3D1:
    REP #$30                                  ; AXY->16; 2x2 invisible block, low bytes only (switch palace switch)
    LDA.B TouchBlockYPos
    AND.W #$01F0
    STA.B _4
    LDA.B TouchBlockXPos
    LSR A
    LSR A
    LSR A
    LSR A
    AND.W #$000F
    ORA.B _4
    TAY
    LDA.L DynStripeImgSize
    TAX
    SEP #$20                                  ; A->8
    LDA.B #$25
    STA.B [Map16LowPtr],Y
    INY
    LDA.B #$25
    STA.B [Map16LowPtr],Y
    REP #$20                                  ; A->16
    TYA
    CLC
    ADC.W #$0010
    TAY
    SEP #$20                                  ; A->8
    LDA.B #$25
    STA.B [Map16LowPtr],Y
    DEY
    LDA.B #$25
    STA.B [Map16LowPtr],Y
    LDY.W #$0003
  - LDA.B _6
    STA.L DynamicStripeImage,X
    LDA.B _7
    STA.L DynamicStripeImage+1,X
    LDA.B #$40
    STA.L DynamicStripeImage+2,X
    LDA.B #$06
    STA.L DynamicStripeImage+3,X
    REP #$20                                  ; A->16
    LDA.W #$18F8
    STA.L DynamicStripeImage+4,X
    TXA
    CLC
    ADC.W #$0006
    TAX
    SEP #$20                                  ; A->8
    LDA.B _7
    CLC
    ADC.B #$20
    STA.B _7
    LDA.B _6
    ADC.B #$00
    STA.B _6
    DEY
    BPL -
    LDA.B #$FF
    STA.L DynamicStripeImage,X
    REP #$20                                  ; A->16
    TXA
    STA.L DynStripeImgSize
    RTS

    %insert_empty($0D,$0D,$0D,$0D,$0C)

    db $80,$40,$20,$10,$08,$04,$02,$01
    db $80,$40,$20,$10,$08,$04,$02,$01

DATA_00C470:
    db $90,$00,$90,$00

DATA_00C474:
    db $04,$FC,$04,$FC

DATA_00C478:
    db $30,$33,$33,$30,$01,$00

CODE_00C47E:
    STZ.B PlayerHiddenTiles                   ; Routine to handle various gameplay-related processes (Mario-object interaction, level end, P-switches, etc).
    LDA.W UnusedStarCounter
    BPL +                                     ; Handle the (unused) star ability from level end.
    JSL CODE_01C580
    STZ.W UnusedStarCounter
; Keyhole routine.
  + LDY.W KeyholeTimer                        ; Branch if keyhole not active.
    BEQ CODE_00C4BA
    STY.W PlayerIsFrozen                      ; Freeze player.
    STY.B SpriteLock                          ; Freeze sprites.
    LDX.W KeyholeDirection
    LDA.W SpotlightSize
    CMP.W DATA_00C470,X                       ; Branch if not at max keyhole scaling.
    BNE CODE_00C4BC
    DEY
    BNE CODE_00C4B7
    INC.W KeyholeDirection
    TXA
    LSR A
    BCC +
    JSR CODE_00FCEC
    LDA.B #$02
    LDY.B #$0B                                ; Activate secret exit and fade to overworld.
    JSR CODE_00C9FE
    LDY.B #$00
CODE_00C4B7:
    STY.W KeyholeTimer
CODE_00C4BA:
    BRA +                                     ; Keyhole is not active.

CODE_00C4BC:
    CLC                                       ; Not done scaling keyhole.
    ADC.W DATA_00C474,X
    STA.W SpotlightSize
    LDA.B #$22
    STA.B Layer12Window
    LDA.B #$02
    STA.B Layer34Window
    LDA.W DATA_00C478,X
    STA.B OBJCWWindow
    LDA.B #$12
    STA.B ColorAddition
    REP #$20                                  ; A->16
    LDA.W #DATA_00CB93
    STA.B _4
    STZ.B _6
    SEP #$20                                  ; A->8
    LDA.W KeyholeXPos
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.B #$04
    STA.B _0
    LDA.W KeyholeYPos
    SEC
    SBC.B Layer1YPos
    CLC
    ADC.B #$10
    STA.B _1
    JSR CODE_00CA88
  + LDA.W PlayerIsFrozen                      ; Code reconvenes here.
    BEQ +                                     ; If the player is frozen in place, skip everything to return.
    JMP CODE_00C58F

; Player is not frozen.
  + LDA.B SpriteLock                          ; \ Branch if sprites locked; Branch if sprites frozen.
    BNE CODE_00C569                           ; /
    INC.B EffFrame
    LDX.B #$13
CODE_00C508:
    LDA.W ColorFadeTimer,X
    BEQ +
    DEC.W ColorFadeTimer,X
  + DEX
    BNE CODE_00C508
    LDA.B EffFrame
    AND.B #$03
    BNE CODE_00C569
    LDA.W BonusGameActivate
    BEQ CODE_00C533
    LDA.W BonusFinishTimer
    CMP.B #$44
    BNE +
    LDY.B #!BGM_BONUSOVER
    STY.W SPCIO2                              ; / Change music
  + CMP.B #con($01,$01,$01,$08,$08)
    BNE CODE_00C533
    LDY.B #$0B
    STY.W GameMode
CODE_00C533:
    LDY.W BluePSwitchTimer
    CPY.W SilverPSwitchTimer
    BCS +
    LDY.W SilverPSwitchTimer
  + LDA.W MusicBackup
    BMI +
    CPY.B #$01
    BNE +                                     ; If a switch is close to running out, play a sound effect to indicate such.
    LDY.W DirectCoinTimer                     ; If it does run out, then reset the music register.
    BNE +
    STA.W SPCIO2                              ; / Change music
  + CMP.B #$FF
    BEQ +
    CPY.B #con($1E,$1E,$1E,$18,$18)
    BNE +
    LDA.B #!SFX_RUNNINGOUT                    ; \ Play sound effect; SFX for the P-switch running out.
    STA.W SPCIO3                              ; /
  + LDX.B #$06
CODE_00C55E:
    LDA.W EmptyTimer14A8,X                    ; Decrement $14A8-$14AE, which includes the Blue/Silver P-switch timers.
    BEQ +
    DEC.W EmptyTimer14A8,X
  + DEX
    BNE CODE_00C55E
CODE_00C569:
    JSR ProcessPlayerAnimation                ; Process object interaction for Mario (and various animation states).
    LDA.B byetudlrFrame
    AND.B #$20
    BEQ CODE_00C58F
if ver_is_ntsc(!_VER)                         ;\================== J, U, & SS =================
    LDA.B byetudlrHold                        ;!
    AND.B #$08                                ;!
    BRA CODE_00C585                           ;! Change to BEQ to reach debug routine below
                                              ;!
    LDA.B Powerup                             ;! \ Unreachable; DEBUG: increment powerup status.
    INC A                                     ;! | Debug: Cycle through powerups
    CMP.B #$04                                ;! |
    BCC +                                     ;! |; Press up + select to increment status.
    LDA.B #$00                                ;! |
  + STA.B Powerup                             ;! |
    BRA CODE_00C58F                           ;! /
endif                                         ;/===============================================

CODE_00C585:
    PHB
    LDA.B #$02
    PHA
    PLB
    JSL CODE_028008
    PLB
CODE_00C58F:
    STZ.W NoteBlockActive
Return00C592:
    RTS

ProcessPlayerAnimation:          
    LDA.B PlayerAnimation                     ; Mario animation state routine. Effectively processes object interaction for Mario.
    JSL ExecutePtr

    dw ResetAni                               ; 0 - Reset
    dw PowerDownAni                           ; 1 - Power down
    dw MushroomAni                            ; 2 - Mushroom power up
    dw CapeAni                                ; 3 - Cape power up
    dw FlowerAni                              ; 4 - Flower power up
    dw DoorPipeAni                            ; 5 - Door/Horizontal pipe exit
    dw VertPipeAni                            ; 6 - Vertical pipe exit
    dw PipeCannonAni                          ; 7 - Shot out of diagonal pipe
    dw YoshiWingsAni                          ; 8 - Yoshi wings exit
    dw MarioDeathAni                          ; 9 - Mario Death
    dw EnterCastleAni                         ; A - Enter Castle
    dw UnknownAniB                            ; B - freeze forever
    dw UnknownAniC                            ; C - random movement??
    dw Return00C592                           ; D - freeze forever

UnknownAniB:
; Mario animation pointers.
; 00 - Normal
; 01 - Flashing (damage)
; 02 - Get mushroom
; 03 - Get feather
; 04 - Get fireflower
; 05 - Enter horizontal pipe
; 06 - Enter vertical pipe
; 07 - Shoot diagonally (slanted pipe)
; 08 - Shoot into the sky (Yoshi wings)
; 09 - End level without activating events (death)
; 0A - No-Yoshi entrance
; 0B - Freeze player
; 0C - Castle destruction
; 0D - Enter door
    STZ.W PlayerOverworldPose                 ; Mario state 0B - Freeze the player as if they've beaten a boss (?).
    STZ.W PlayerSlopePose
    LDA.W EndLevelTimer
    BEQ CODE_00C5CE
    JSL CODE_0CAB13
    LDA.W GameMode
    CMP.B #$14
    BEQ +
    JMP CODE_00C95B

CODE_00C5CE:
    STZ.W HDMAEnable                          ; Disable HDMA.
  + LDA.B #$01
    STA.W MessageBoxExpand
    LDA.B #$07
    STA.W LevelLoadObject
    JSR NoButtons                             ; Disable input.
    JMP CODE_00CD24


DATA_00C5E1:
    db $10,$30,$31,$32,$33,$34,$0E

if ver_is_ntsc(!_VER)                         ;\================== J, U, & SS =================
DATA_00C5E8:                                  ;!
    db $26,$11,$02,$48,$00,$60,$01,$09        ;!
    db $80,$08,$00,$20,$04,$60,$00,$01        ;!
    db $FF,$01                                ;!
                                              ;!
DATA_00C5F9:                                  ;!
    db $02,$48,$00,$60,$41,$2C,$C1,$04        ;!
    db $27,$04,$2F,$08,$25,$01,$2F,$04        ;!
    db $27,$04,$00,$08,$41,$1B,$C1,$04        ;!
    db $27,$04,$2F,$08,$25,$01,$2F,$04        ;!
    db $27,$04,$00,$04,$01,$08,$20,$01        ;!
    db $01,$10,$00,$08,$41,$12,$81,$0A        ;!
    db $00,$40,$82,$10,$02,$20,$00,$30        ;!
    db $01,$01,$00,$50,$22,$01,$FF,$01        ;!
                                              ;!
DATA_00C639:                                  ;!
    db $02,$48,$00,$60,$01,$09,$80,$08        ;!
    db $00,$20,$04,$60,$00,$20,$10,$20        ;!
    db $01,$58,$00,$2C,$31,$01,$3A,$10        ;!
    db $31,$01,$3A,$10,$31,$01,$3A,$20        ;!
    db $28,$A0,$28,$40,$29,$04,$28,$04        ;!
    db $29,$04,$28,$04,$29,$04,$28,$40        ;!
    db $22,$01,$FF,$01                        ;!
                                              ;!
DATA_00C66D:                                  ;!
    db $02,$48,$00,$60,$01,$09,$80,$08        ;!
    db $00,$20,$04,$60,$10,$20,$31,$01        ;!
    db $18,$60,$31,$01,$3B,$80,$31,$01        ;!
    db $3C,$40,$FF,$01                        ;!
                                              ;!
DATA_00C689:                                  ;!
    db $02,$48,$00,$60,$02,$30,$01,$84        ;!
    db $00,$20,$23,$01,$01,$16,$02,$20        ;!
    db $20,$01,$01,$20,$02,$20,$01,$02        ;!
    db $00,$80,$FF,$01                        ;!
                                              ;!
DATA_00C6A5:                                  ;!
    db $02,$48,$00,$60,$02,$28,$01,$83        ;!
    db $00,$28,$24,$01,$02,$01,$00,$FF        ;!
    db $00,$40,$20,$01,$00,$40,$02,$60        ;!
    db $00,$30,$FF,$01                        ;!
                                              ;!
DATA_00C6C1:                                  ;!
    db $02,$48,$00,$60,$01,$4E,$00,$40        ;!
    db $26,$01,$00,$1E,$20,$01,$00,$20        ;!
    db $08,$10,$20,$01,$2D,$18,$00,$A0        ;!
    db $20,$01,$2E,$01,$FF,$01                ;!
else                                          ;<===================== E0 & E1 =================
DATA_00C5E8:                                  ;!
    db $26,$11,$02,$3E,$00,$60,$01,$09        ;!
    db $80,$08,$00,$20,$04,$60,$00,$01        ;!
    db $FF,$01                                ;!
                                              ;!
DATA_00C5F9:                                  ;!
    db $02,$3E,$00,$60,$41,$25,$C1,$04        ;!
    db $27,$04,$2F,$08,$25,$01,$2F,$04        ;!
    db $27,$04,$00,$08,$41,$16,$C1,$04        ;!
    db $27,$04,$2F,$08,$25,$01,$2F,$04        ;!
    db $27,$04,$00,$04,$01,$04,$20,$01        ;!
    db $01,$04,$00,$08,$41,$14,$81,$1A        ;!
    db $00,$40,$82,$10,$02,$20,$00,$30        ;!
    db $01,$01,$00,$50,$22,$01,$FF,$01        ;!
                                              ;!
DATA_00C639:                                  ;!
    db $02,$3E,$00,$60,$01,$09,$80,$08        ;!
    db $00,$20,$04,$60,$00,$20,$10,$20        ;!
    db $01,$44,$00,$2C,$31,$01,$3A,$10        ;!
    db $31,$01,$3A,$10,$31,$01,$3A,$20        ;!
    db $28,$A0,$28,$40,$29,$04,$28,$04        ;!
    db $29,$04,$28,$04,$29,$04,$28,$40        ;!
    db $22,$01,$FF,$01                        ;!
                                              ;!
DATA_00C66D:                                  ;!
    db $02,$3E,$00,$60,$01,$09,$80,$08        ;!
    db $00,$20,$04,$60,$10,$20,$31,$01        ;!
    db $18,$60,$31,$01,$3B,$80,$31,$01        ;!
    db $3C,$40,$FF,$01                        ;!
                                              ;!
DATA_00C689:                                  ;!
    db $02,$3E,$00,$60,$02,$30,$01,$6E        ;!
    db $00,$20,$23,$01,$01,$16,$02,$20        ;!
    db $20,$01,$01,$20,$02,$20,$01,$02        ;!
    db $00,$80,$FF,$01                        ;!
                                              ;!
DATA_00C6A5:                                  ;!
    db $02,$3E,$00,$60,$02,$27,$01,$69        ;!
    db $00,$28,$24,$01,$02,$01,$00,$FF        ;!
    db $00,$40,$20,$01,$00,$30,$02,$40        ;!
    db $00,$30,$FF,$01                        ;!
                                              ;!
DATA_00C6C1:                                  ;!
    db $02,$3E,$00,$4C,$01,$43,$00,$40        ;!
    db $26,$01,$00,$1E,$20,$01,$00,$20        ;!
    db $08,$10,$20,$01,$2D,$18,$00,$A0        ;!
    db $20,$01,$2E,$01,$FF,$01                ;!
endif                                         ;/===============================================

DATA_00C6E0:
    db DATA_00C5E8-DATA_00C5E8
    db DATA_00C5F9-DATA_00C5E8-2
    db DATA_00C689-DATA_00C5E8-2
    db DATA_00C66D-DATA_00C5E8-2
    db DATA_00C639-DATA_00C5E8-2
    db DATA_00C6A5-DATA_00C5E8-2
    db DATA_00C6C1-DATA_00C5E8-2

UnknownAniC:
; Format for commands in the below table are a bit weird.
; If bit 4 is set, draws question marks above Mario (position and number drawn determined by $1445 and the routine at $0CD4A4).
; If bit 5 of first byte is clear, the rest of the byte is read as input ($15/$16).
; If bit 5 is set, then the first nibble is used as various specialized commands (see $00C789 onwards).
; If #$2D, also plays the P-balloon sound (for Lemmy's).
; If #$FF, indicates end of the data.
; Castle destruction data. First byte is the command byte; second is how long to use it.
; 00 - C1 Iggy (normal switch)
; 10 - C2 Morton (castle stomp)
; 50 - C5 Roy (broken switch)
; 84 - C4 Ludwig (liftoff)
; A0 - C3 Lemmy (hammer)
; BC - C6 Wendy (wipe)
; D8 - C7 Larry (toss)
; Indexes to each destruction sequence above.
; Scratch RAM usage:
; $88 - Timer for each command.
; $8F - Index to the input table above (within each sequence).
; Mario state 0C - Castle destruction cutscene.
    JSR NoButtons                             ; Disable input.
    STZ.W PlayerOverworldPose
    JSR CODE_00DC2D                           ; Update player position.
    LDA.B PlayerYSpeed+1                      ; \ Branch if Mario has upward speed; Branch if Mario moving upwards.
    BMI CODE_00C73F                           ; /
    LDA.B PlayerYPosNext
    CMP.B #$58                                ; Branch if Mario is on the ground.
    BCS CODE_00C739
    LDY.B PlayerXPosNext
    CPY.B #$40                                ; Branch if Mario is to the left of the detonation switch.
    BCC CODE_00C73F
    CPY.B #$60                                ; Branch if not to the right of the switch.
    BCC CODE_00C71C
    LDY.B Layer1YPos
    BEQ CODE_00C73F
    CLC                                       ; Branch if hitting the top of the castle. (Morton)
    ADC.B Layer1YPos
    CMP.B #$1C
    BMI CODE_00C73F
    SEC
    SBC.B Layer1YPos
    LDX.B #$D0                                ; Y speed to give Mario as he's bouncing off the top of the castle.
    LDY.B PlayerDirection
    BEQ CODE_00C730                           ; Skip down.
    LDY.B #$00                                ; Clear X speed if facing right.
    BRA CODE_00C72E

CODE_00C71C:
; Hitting the detonation switch.
    CMP.B #$4C                                ; Branch if not hitting the top of the switch.
    BCC CODE_00C73F
    LDA.B #!SFX_CUTSCENEFUSE                  ; \ Play sound effect; SFX for the fuse.
    STA.W SPCIO3                              ; /
    INC.W Layer1ScrollCmd
    LDA.B #$4C
    LDY.B #$F4                                ; X speed to send Mario back with.
    LDX.B #$C0                                ; Y speed to bounce Mario back off with.
CODE_00C72E:
    STY.B PlayerXSpeed+1
CODE_00C730:
    STX.B PlayerYSpeed+1
    LDX.B #!SFX_BONK                          ; \ Play sound effect; SFX for bouncing off something (switch, castle) in the castle destruction sequence.
    STX.W SPCIO0                              ; /
    BRA +

CODE_00C739:
    STZ.B PlayerInAir                         ; Mario is on the ground.
    LDA.B #$58
  + STA.B PlayerYPosNext
CODE_00C73F:
    LDX.W CutsceneID                          ; Fetch command.
    LDA.B CutsceneInputIndex
    CLC                                       ; Get index to current input.
    ADC.W DATA_00C6E0-1,X
    TAX
    LDA.B CutsceneInputTimer
    BNE +                                     ; Branch if not at the end of the current input.
    INC.B CutsceneInputIndex
    INC.B CutsceneInputIndex                  ; Move to next input.
    INX
    INX
    LDA.W DATA_00C5E8+1,X                     ; Set timer for next input.
    STA.B CutsceneInputTimer
    LDA.W DATA_00C5E8,X
    CMP.B #$2D                                ; Handle sound effect for tossing the castle away (Lemmy).
    BNE +
    LDA.B #!SFX_PBALLOON                      ; \ Play sound effect; SFX for tossing the castle.
    STA.W SPCIO0                              ; /
  + LDA.W DATA_00C5E8,X
    CMP.B #$FF                                ; Return if at the end of the data.
    BNE +                                     ; (first byte = #$FF)
    JMP Return00C7F8

  + PHA                                       ; Run command.
    AND.B #$10
    BEQ +                                     ; If bit 4 is set, draw a question mark above Mario's head.
    JSL CODE_0CD4A4
  + PLA
    TAY
    AND.B #$20
    BNE CODE_00C789
    STY.B byetudlrHold                        ; If bit 5 is clear, take the next byte as input data.
    TYA
    AND.B #$BF
    STA.B byetudlrFrame
    JSR CODE_00CD39                           ; Run input routines (?).
    BRA CODE_00C7F6

CODE_00C789:
    TYA                                       ; Not input.
    AND.B #$0F
    CMP.B #$07                                ; Branch if the first 4 bits are #$07 or more.
    BCS CODE_00C7E9
    DEC A                                     ; Branch if the first 4 bits was not #$00.
    BPL CODE_00C7A2
    LDA.W PickUpItemTimer                     ; _0 - Play pick up SFX if crouching, and increase $143E (for Larry's, Morton's).
    BEQ CODE_00C79D                           ; Play pick up sound effect if Mario is crouching.
    LDA.B #!SFX_CAPE                          ; \ Play sound effect; SFX for picking up the castle.
    STA.W SPCIO0                              ; /
CODE_00C79D:
    INC.W Layer1ScrollCmd
    BRA CODE_00C7F6

CODE_00C7A2:
    BNE CODE_00C7A9                           ; _1 - Increase $1445.
    INC.W Layer2ScrollTimer
    BRA CODE_00C7F6

CODE_00C7A9:
    DEC A                                     ; _2 - Play swim sound and increase $1446 (for the smoke cloud in Morton/Roy's).
    BNE CODE_00C7B6
    LDA.B #!SFX_SWIM                          ; \ Play sound effect; SFX for the huff sound used in Morton/Roy's sequences.
    STA.W SPCIO0                              ; /
    INC.W Layer1ScrollXSpeed
    BRA CODE_00C7F6

CODE_00C7B6:
    DEC A                                     ; _3 - Set $1445 to #$88 (for the hammer timer in Larry's).
    BNE CODE_00C7C0
    LDY.B #$88
    STY.W Layer2ScrollTimer
    BRA CODE_00C7F6

CODE_00C7C0:
    DEC A                                     ; _4 - Set $1446 to #$38 and center Mario's X position (Wendy's).
    BNE CODE_00C7CE
    LDA.B #$38
    STA.W Layer1ScrollXSpeed
    LDA.B #$07
    TRB.B PlayerXPosNext
    BRA CODE_00C7F6

CODE_00C7CE:
    DEC A                                     ; _5 - Play small boom, push Mario back, and increase $143E twice (Morton's).
    BNE CODE_00C7DF
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect; SFX for hitting the castle.
    STA.W SPCIO3                              ; /
    LDA.B #con($D8,$D8,$D8,$D2,$D2)           ; X speed to push Mario back with.
    STA.B PlayerXSpeed+1
    INC.W Layer1ScrollCmd
    BRA CODE_00C79D

CODE_00C7DF:
; _6 - Set Mario to pick up something (Larry's).
    LDA.B #$20                                ; Set timer for the grab animation.
    STA.W PickUpItemTimer
    INC.W IsCarryingItem
    BRA CODE_00C7F6

CODE_00C7E9:
    TAY                                       ; _7-_F - Change player image, based on $00C5E1, and clear $148F.
    LDA.W DATA_00C5E1-7,Y                     ; Change Mario's pose.
    STA.W PlayerPose
    STZ.W IsCarryingItem
    JSR CODE_00D7E4                           ; Handle flight (?).
CODE_00C7F6:
    DEC.B CutsceneInputTimer
Return00C7F8:
    RTS


DATA_00C7F9:
    db $C0,$FF,$A0,$00

YoshiWingsAni:
; Heights at which the player stops flying upward in the Yoshi Wings level.
; flying up to the YW level
; entering the YW level
; Mario state 08 - Collected Yoshi Wings
    JSR NoButtons                             ; Disable input.
    LDA.B #$0B                                ; Indicate Mario as in the air, moving upwards.
    STA.B PlayerInAir
    JSR CODE_00D7E4
    LDA.B PlayerYSpeed+1                      ; \ Branch if Mario has downward speed
    BPL CODE_00C80F                           ; /
    CMP.B #$90                                ; \ Branch if Y speed < #$90
    BCC +                                     ; /
CODE_00C80F:
    SEC                                       ; \ Y Speed -= #$0D
    SBC.B #con($0D,$0D,$0D,$0F,$0F)           ; |
    STA.B PlayerYSpeed+1                      ; /
  + LDA.B #$02
    LDY.B PlayerXSpeed+1
    BEQ CODE_00C827
    BMI +
    LDA.B #$FE
  + CLC
    ADC.B PlayerXSpeed+1
    STA.B PlayerXSpeed+1
    BVC CODE_00C827
    STZ.B PlayerXSpeed+1
CODE_00C827:
    JSR CODE_00DC2D
    REP #$20                                  ; A->16
    LDY.W YoshiHeavenFlag
    LDA.B PlayerYPosScrRel
    CMP.W DATA_00C7F9,Y
    SEP #$20                                  ; A->8
    BPL +
    STZ.B PlayerAnimation
    TYA
    BNE +
    INY
    INY
    STY.W YoshiHeavenFlag
    JSR CODE_00D273
  + JMP CODE_00CD8F

if ver_is_ntsc(!_VER)                         ;\================== J, U, & SS =================
DATA_00C848:                                  ;!
    db $01,$5F,$00,$30,$08,$30,$00,$20        ;!
    db $40,$01,$00,$30,$01,$80,$FF,$01        ;!
    db $3F,$00,$30,$20,$01,$80,$06,$00        ;!
    db $3A,$01,$38,$00,$30,$08,$30,$00        ;!
    db $20,$40,$01,$00,$30,$01,$80,$FF        ;!
else                                          ;<=================== E0 & E1 ===================
DATA_00C848:                                  ;!
    db $01,$4C,$00,$30,$08,$30,$00,$20        ;!
    db $40,$01,$00,$30,$01,$80,$FF,$01        ;!
    db $2C,$00,$30,$20,$01,$80,$06,$00        ;!
    db $3A,$01,$30,$00,$30,$08,$30,$00        ;!
    db $20,$40,$01,$00,$30,$01,$80,$FF        ;!
endif                                         ;/===============================================

EnterCastleAni:
; Controller input data for the No-Yoshi entrances.
; No Yoshi
; With Yoshi
    STZ.W SpinjumpFireball                    ; Mario state 0A - No-Yoshi entrance.
    LDX.W ObjectTileset
    BIT.W DATA_00A625,X                       ; Figure out which entrance to set up sprite data for.
    BMI CODE_00C889
    BVS ADDR_00C883
; Setting up ghost house entrance.
    JSL CODE_02F57C                           ; Draw the ghost house entrance sprite.
    BRA +

ADDR_00C883:
; Setting up rope entrance.
    JSL ADDR_02F58C                           ; Draw the no-Yoshi sign sprite.
    BRA +

CODE_00C889:
; Setting up castle entrance.
    JSL CODE_02F584                           ; Draw the castle door sprite.
  + LDX.B NoYoshiInputIndex                   ; All entrances rejoin.
    LDA.B byetudlrFrame
    ORA.B axlr0000Frame                       ; Disable input;
    JSR NoButtons                             ; if A/B are pressed, skip the intro.
    BMI CODE_00C8FB
    STZ.W PlayerOverworldPose
    DEC.B NoYoshiInputTimer
    BNE +
    INX
    INX                                       ; If at the end of the current input, set the timer for the next.
    STX.B NoYoshiInputIndex
    LDA.W DATA_00C848-1,X
    STA.B NoYoshiInputTimer
  + LDA.W DATA_00C848-2,X
    CMP.B #$FF                                ; If byte is #$FF, at end of data.
    BEQ CODE_00C8FB
    AND.B #$DF
    STA.B byetudlrHold
    CMP.W DATA_00C848-2,X                     ; Input command.
    BEQ +
    LDY.B #$80
    STY.B axlr0000Frame
  + ASL A
    BPL CODE_00C8D1                           ; If command contained A, start entrance door timer.
    JSR NoButtons
    LDY.B #$B0                                ; Time to wait for the castle door to open.
    LDX.W ObjectTileset
    BIT.W DATA_00A625,X
    BMI +
    LDY.B #$7F                                ; Time to wait for the ghost house door to open.
  + STY.W NoYoshiIntroTimer
CODE_00C8D1:
    JSR CODE_00DC2D
    LDA.B #$24
    STA.B PlayerInAir
    LDA.B #$6F
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$5F
  + LDX.W ObjectTileset
    BIT.W DATA_00A625,X
    BVC +
    SEC
    SBC.B #$10
  + CMP.B PlayerYPosNext
    BCS +
    INC A
    STA.B PlayerYPosNext
    STZ.B PlayerInAir
    STZ.W SpinJumpFlag
  + JMP CODE_00CD82

CODE_00C8FB:
    INC.W ShowMarioStart
    LDA.B #$0F
    STA.W GameMode
    CPX.B #$11
    BCC CODE_00C90A
    INC.W CarryYoshiThruLvls
CODE_00C90A:
    LDA.B #$01
    STA.W RemoveYoshiFlag
    LDA.B #!SFX_YOSHIDRUMOFF                  ; \ Play sound effect
    STA.W SPCIO1                              ; /
    RTS

CODE_00C915:
; Mario animation routine during the goal walk.
    JSR NoButtons                             ; Disable input.
    STZ.W PlayerInCloud
    STZ.W PlayerOverworldPose
    STZ.W PlayerSlopePose
    LDA.B ScreenMode
    LSR A                                     ; Branch if in a vertical level.
    BCS CODE_00C944
    LDA.W CutsceneID
    ORA.W SwitchPalaceColor                   ; Branch if not ending the level via boss beaten or switch palace.
    BEQ CODE_00C96B
    LDA.B PlayerInAir
    BEQ +
    JSR CODE_00CCE0
  + LDA.W SwitchPalaceColor
    BNE CODE_00C948
    JSR CODE_00B03E
    LDA.W ColorFadeTimer
    CMP.B #$40
    BCC Return00C96A
CODE_00C944:
    JSL CODE_05CBFF                           ; Goal sphere in a vertical level.
CODE_00C948:
; Switch palace switch.
    LDY.B #$01                                ; Freeze sprites.
    STY.B SpriteLock
    LDA.B TrueFrame
    LSR A                                     ; Return if:
    BCC Return00C96A                          ; Not on an odd-numbered frame.
    DEC.W EndLevelTimer                       ; Already ending the level (from e.g. goal tape)
if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
    BNE Return00C96A                          ;!
else                                          ;<==================== E0 & E1 ==================
    LDA.W EndLevelTimer                       ;!
    CMP.B #$50                                ;!
    BCS Return00C96A                          ;!
endif                                         ;/===============================================
    LDA.W SwitchPalaceColor                   ; Branch if activating a switch palace.
    BNE +
CODE_00C95B:
    LDY.B #$0B
    LDA.B #$01                                ; Activate the normal exit and fade to overworld.
    JMP CODE_00C9FE

; Switch palace message being activated.
  + LDA.B #con($70,$A0,$A0,$6A,$6A)           ; Number of frames to show the Switch Palace message for.
    STA.W VariousPromptTimer
    INC.W MessageBoxTrigger                   ; Display the Switch Palace message.
Return00C96A:
    RTS

CODE_00C96B:
    JSR CODE_00AF17                           ; Ending level through goal tape/sphere in horizontal level.
    LDA.W ShowPeaceSign
    BNE CODE_00C9AF
    LDA.W EndLevelTimer
    CMP.B #con($28,$28,$28,$50,$50)
    BCC +
    LDA.B #$01
    STA.B PlayerDirection
    STA.B byetudlrHold
    LDA.B #$05
    STA.B PlayerXSpeed+1
  + LDA.B PlayerInAir
    BEQ +
    JSR CODE_00D76B
  + LDA.B PlayerXSpeed+1
    BNE +
    STZ.W HorizLayer1Setting
    JSR CODE_00CA3E
    INC.W ShowPeaceSign
    LDA.B #con($40,$40,$40,$6E,$6E)
    STA.W PlayerPeaceSign
if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
    ASL A                                     ;!
else                                          ;<==================== E0 & E1 ==================
    LDA.B #$80                                ;!
endif                                         ;/===============================================
    STA.W ColorFadeDir
    STZ.W ColorFadeTimer
  + JMP CODE_00CD24

DATA_00C9A7:
    db $25,$07,$40,$0E,$20,$1A,$34,$32

CODE_00C9AF:
; Translevel numbers that activate each castle cutscene. Last byte is Front Door; Back Door is at $00CA13.
    JSR SetMarioPeaceImg                      ; Set Mario's image to the peace sign.
    LDA.W PlayerPeaceSign
    BEQ CODE_00C9C2                           ; Return if waiting for the peace sign to finish.
    DEC.W PlayerPeaceSign
    BNE +
    LDA.B #!BGM_SPOTLIGHT                     ; Play the circle-zoom sound.
    STA.W SPCIO2                              ; / Change music
  + RTS

CODE_00C9C2:
    JSR CODE_00CA44                           ; Decrease the circle-zoom effect's size.
    LDA.B #$01                                ; Simulate holding right.
    STA.B byetudlrHold
    JSR CODE_00CD24
    LDA.W SpotlightSize                       ; Return if the circle isn't done scaling away.
    BNE Return00CA30
    LDA.W SecretGoalTape                      ; \ Branch if Goal Tape extra bits == #$02
    INC A                                     ; | (never happens)
    CMP.B #$03                                ; |; If the secret exit flag for the tape is set to 02 (unused),
    BNE +                                     ; /; change submap to Yoshi's Island and activate the secret exit.
    LDA.B #$01                                ; \ Unreachable
    STA.W OWPlayerSubmap                      ; | Set submap to be Yoshi's Island
    LSR A                                     ; /
  + LDY.B #$0C
    LDX.W BonusGameActivate                   ; Branch if the bonus game is not set to activate after the level.
    BEQ +
    LDX.B #$FF
    STX.W BonusGameActivate                   ; Prep the bonus game.
    LDX.B #$F0
    STX.W MosaicSize
    STZ.W EndLevelTimer
    STZ.W MusicBackup
    LDY.B #$10
  + STZ.W Brightness
    STZ.W MosaicDirection
CODE_00C9FE:
    STA.W OWLevelExitMode                     ; Store secret/normal exit info; Prepare level end; A contains exit, Y contains game mode to activate.
    LDA.W CutsceneID                          ; Branch if not activating a boss cutscene.
    BEQ CODE_00CA25
    LDX.B #$08
    LDA.W TranslevelNo
    CMP.B #$13                                ; Level where defeating the boss activates the secret exit (Donut Secret House).
    BNE +
    INC.W OWLevelExitMode
  + CMP.B #$31                                ; The second level that activates the credits cutscene (Back Door).
    BEQ CODE_00CA20
CODE_00CA16:
    CMP.W DATA_00C9A7-1,X
    BEQ CODE_00CA20
    DEX                                       ; Check whether the level activates a boss-beaten cutscene.
    BNE CODE_00CA16                           ; If so, load game mode 18.
    BRA CODE_00CA25

CODE_00CA20:
    STX.W CutsceneID
    LDY.B #$18
CODE_00CA25:
    STY.W GameMode
    INC.W CreditsScreenNumber                 ; Indicate event should activate on overworld load.
CODE_00CA2B:
    LDA.B #$01                                ; Set flag to activate events on the overworld.
    STA.W MidwayFlag                          ; This particular spot is also used to set the midpoint flag.
Return00CA30:
    RTS

SetMarioPeaceImg:
    LDA.B #$26                                ; \ Mario's image = Peace Sign, or; Small subroutine to show Mario's peace pose at level end.
    LDY.W PlayerRidingYoshi                   ; |
    BEQ +                                     ; |; Set Mario's pose to 0x26, or 0x14 when riding Yoshi.
    LDA.B #$14                                ; | Mario's image = Peace Sign on Yoshi
  + STA.W PlayerPose                          ; /
    RTS

CODE_00CA3E:
    LDA.B #$F0
    STA.W SpotlightSize
    RTS

CODE_00CA44:
    LDA.W SpotlightSize
    BNE +
    RTS

  + JSR CODE_00CA61
    LDA.B #$FC
    JSR CODE_00CA6D
    LDA.B #$33
    STA.B Layer12Window
    STA.B OBJCWWindow
    LDA.B #$03
    STA.B Layer34Window
    LDA.B #$22
    STA.B ColorAddition
    RTS

CODE_00CA61:
    REP #$20                                  ; A->16; Subtroutine to get the pointer to the title screen window data ($00CB12).
    LDA.W #DATA_00CB12                        ; \
    STA.B _4                                  ; |Load xCB12 into $04 and $06; Set 16-bit pointer to $00CB12.
    STA.B _6                                  ; /
    SEP #$20                                  ; A->8
    RTS

CODE_00CA6D:
    CLC
    ADC.W SpotlightSize
    STA.W SpotlightSize
    LDA.B PlayerXPosScrRel
    CLC
    ADC.B #$08
    STA.B _0
    LDA.B #$18
    LDY.B Powerup
    BEQ +
    LDA.B #$10
  + CLC
    ADC.B PlayerYPosScrRel
    STA.B _1
CODE_00CA88:
    REP #$30                                  ; AXY->16
    AND.W #$00FF                              ; Keep lower byte of A
    ASL A                                     ; \
    DEC A                                     ; |Set Y to ((2A-1)*2)
    ASL A                                     ; |
    TAY                                       ; /
    SEP #$20                                  ; A->8
    LDX.W #$0000
CODE_00CA96:
    LDA.B _1
    CMP.W SpotlightSize
    BCC CODE_00CABD
    LDA.B #$FF
    STA.W WindowTable,X
    STZ.W WindowTable+1,X
    CPY.W #con($01C0,$01C0,$01C0,$01C0,$01E0)
    BCS +
    STA.W WindowTable,Y
    INC A
    STA.W WindowTable+1,Y
  + INX
    INX
    DEY
    DEY
    LDA.B _1
    BEQ CODE_00CB0A
    DEC.B _1
    BRA CODE_00CA96

CODE_00CABD:
    JSR CODE_00CC14
    CLC
    ADC.B _0
    BCC +
    LDA.B #$FF
  + STA.W WindowTable+1,X
    LDA.B _0
    SEC
    SBC.B _2
    BCS +
    LDA.B #$00
  + STA.W WindowTable,X
    CPY.W #$01E0
    BCS CODE_00CAFE
    LDA.B _7
    BNE CODE_00CAE7
    LDA.B #$00
    STA.W WindowTable+1,Y
    DEC A
    BRA CODE_00CAFB

CODE_00CAE7:
    LDA.B _3
    ADC.B _0
    BCC +
    LDA.B #$FF
  + STA.W WindowTable+1,Y
    LDA.B _0
    SEC
    SBC.B _3
    BCS CODE_00CAFB
    LDA.B #$00
CODE_00CAFB:
    STA.W WindowTable,Y
CODE_00CAFE:
    INX
    INX
    DEY
    DEY
    LDA.B _1
    BEQ CODE_00CB0A
    DEC.B _1
    BNE CODE_00CABD
CODE_00CB0A:
    LDA.B #$80
    STA.W HDMAEnable
    SEP #$10                                  ; XY->8
    RTS


DATA_00CB12:
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FE,$FE,$FE,$FE
    db $FD,$FD,$FD,$FD,$FC,$FC,$FC,$FB
    db $FB,$FB,$FA,$FA,$F9,$F9,$F8,$F8
    db $F7,$F7,$F6,$F6,$F5,$F5,$F4,$F3
    db $F3,$F2,$F1,$F1,$F0,$EF,$EE,$EE
    db $ED,$EC,$EB,$EA,$E9,$E9,$E8,$E7
    db $E6,$E5,$E4,$E3,$E2,$E1,$DF,$DE
    db $DD,$DC,$DB,$DA,$D8,$D7,$D6,$D5
    db $D3,$D2,$D0,$CF,$CD,$CC,$CA,$C9
    db $C7,$C6,$C4,$C2,$C1,$BF,$BD,$BB
    db $B9,$B7,$B6,$B4,$B1,$AF,$AD,$AB
    db $A9,$A7,$A4,$A2,$9F,$9D,$9A,$97
    db $95,$92,$8F,$8C,$89,$86,$82,$7F
    db $7B,$78,$74,$70,$6C,$67,$63,$5E
    db $59,$53,$4D,$46,$3F,$37,$2D,$1F
    db $00

DATA_00CB93:
    db $54,$53,$52,$52,$51,$50,$50
    db $4F,$4E,$4E,$4D,$4C,$4C,$4B,$4A
    db $4A,$4B,$48,$48,$47,$46,$46,$45
    db $44,$44,$43,$42,$42,$41,$40,$40
    db $3F,$3E,$3E,$3D,$3C,$3C,$3B,$3A
    db $3A,$39,$38,$38,$37,$36,$36,$35
    db $34,$34,$33,$32,$32,$31,$33,$35
    db $38,$3A,$3C,$3E,$3F,$41,$43,$44
    db $45,$47,$48,$49,$4A,$4B,$4C,$4D
    db $4E,$4E,$4F,$50,$50,$51,$51,$52
    db $52,$53,$53,$53,$53,$53,$53,$53
    db $53,$53,$53,$53,$53,$53,$52,$52
    db $51,$51,$50,$50,$4F,$4E,$4E,$4D
    db $4C,$4B,$4A,$49,$48,$47,$45,$44
    db $43,$41,$3F,$3E,$3C,$3A,$38,$35
    db $33,$30,$2D,$2A,$26,$23,$1E,$18
    db $11,$00

CODE_00CC14:
    PHY                                       ; Windowing data for the opening circle.
    LDA.B _1
    STA.W HW_WRDIV+1
    STZ.W HW_WRDIV
    LDA.W SpotlightSize
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
    TAY
    SEP #$20                                  ; A->8
    LDA.B (_6),Y
    STA.W HW_WRMPYA
    LDA.W SpotlightSize
    STA.W HW_WRMPYB
    NOP
    NOP
    NOP
    NOP
    LDA.W HW_RDMPY+1
    STA.B _3
    LDA.B (_4),Y
    STA.W HW_WRMPYA
    LDA.W SpotlightSize
    STA.W HW_WRMPYB
    NOP
    NOP
    NOP
    NOP
    LDA.W HW_RDMPY+1
    STA.B _2
    PLY
    RTS


DATA_00CC5C:
    db $00,$00,$00,$00,$02,$00,$06,$00
    db $FE,$FF,$FA,$FF

ResetAni:
if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
    LDA.B axlr0000Hold                        ;!; Normal Mario animation. Handles pretty much all Mario-related interaction with objects.
    AND.B #$20                                ;!
    BEQ +                                     ;!
    LDA.B axlr0000Frame                       ;!
    CMP.B #$80                                ;!
    BNE +                                     ;!; Handling the freeroam debug RAM address.
    INC.W DebugFreeRoam                       ;!
    LDA.W DebugFreeRoam                       ;!
    CMP.B #$03                                ;!
    BCC +                                     ;!
    STZ.W DebugFreeRoam                       ;!
  + LDA.W DebugFreeRoam                       ;!
    BRA CODE_00CCBB                           ;! Change to BEQ to enable debug code below; [change BRA to BEQ to enable freeroam cheat]
                                              ;!
    LSR A                                     ;! \ Unreachable; DEBUG: freeroam.
    BEQ ADDR_00CCB3                           ;! | Debug: Free roaming mode
    LDA.B #$FF                                ;! |
    STA.W IFrameTimer                         ;! |
    LDA.B byetudlrHold                        ;! |
    AND.B #$03                                ;! |
    ASL A                                     ;! |
    ASL A                                     ;! |
    LDX.B #$00                                ;! |
    JSR ADDR_00CC9F                           ;! |
    LDA.B byetudlrHold                        ;! |
    AND.B #$0C                                ;! |
    LDX.B #$02                                ;! |
ADDR_00CC9F:                                  ;! |
    BIT.B byetudlrHold                        ;! |
    BVC +                                     ;! |
    ORA.B #$02                                ;! |
  + TAY                                       ;! |
    REP #$20                                  ;! | A->16
    LDA.B PlayerXPosNext,X                    ;! |
    CLC                                       ;! |
    ADC.W DATA_00CC5C,Y                       ;! |
    STA.B PlayerXPosNext,X                    ;! |
    SEP #$20                                  ;! | A->8
    RTS                                       ;! /
                                              ;!
ADDR_00CCB3:                                  ;!
    LDA.B #$70                                ;!; Freeroam: full P-speed.
    STA.W PlayerPMeter                        ;!
    STA.W TakeoffTimer                        ;!
endif                                         ;/===============================================
CODE_00CCBB:
    LDA.W EndLevelTimer                       ; Debug code not enabled.
    BEQ +                                     ; Jump up if doing the goal walk.
    JMP CODE_00C915

; Not at level end.
  + JSR CODE_00CDDD                           ; Process L/R scrolling.
    LDA.B SpriteLock                          ; \ Branch if sprites locked; Return if sprites frozen.
    BNE Return00CCDF                          ; /
    STZ.W CapeInteracts
    STZ.W PlayerOverworldPose
    LDA.W PlayerStunnedTimer                  ; \ If lock Mario timer is set...
    BEQ CODE_00CCE0                           ; |
    DEC.W PlayerStunnedTimer                  ; | Decrease the timer; Handle Mario being stunned.
    STZ.B PlayerXSpeed+1                      ; | X speed = 0
    LDA.B #$0F                                ; | Mario's image = Going down tube; Animation frame for Mario when stunned.
    STA.W PlayerPose                          ; /
Return00CCDF:
    RTS

CODE_00CCE0:
    LDA.W IRQNMICommand                       ; Mario isn't stunned.
    BPL CODE_00CD24
    LSR A
    BCS CODE_00CD24
    BIT.W IRQNMICommand
    BVS CODE_00CD1C
    LDA.B PlayerInAir
    BNE CODE_00CD1C
    REP #$20                                  ; A->16
    LDA.W KeyholeXPos
    STA.B PlayerXPosNext
    LDA.W KeyholeYPos
    STA.B PlayerYPosNext
    SEP #$20                                  ; A->8
    JSR CODE_00DC2D
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    STA.W KeyholeXPos
    STA.W IggyLarryPlatIntXPos
    LDA.B PlayerYPosNext
    AND.W #$FFF0
    STA.W KeyholeYPos
    STA.W IggyLarryPlatIntYPos
    JSR CODE_00F9C9
    BRA +

CODE_00CD1C:
    JSR CODE_00DC2D
  + JSR CODE_00F8F2
    BRA CODE_00CD36

CODE_00CD24:
    LDA.B PlayerYSpeed+1                      ; \ Branch if Mario has downward speed
    BPL +                                     ; /
    LDA.B PlayerBlockedDir
    AND.B #$08
    BEQ +
    STZ.B PlayerYSpeed+1                      ; Y speed = 0
  + JSR CODE_00DC2D
    JSR CODE_00E92B                           ; Process object interaction for Mario.
CODE_00CD36:
    JSR CODE_00F595
CODE_00CD39:
    STZ.W PlayerTurningPose
    LDY.W PBalloonInflating                   ; Branch if Mario has a P-balloon.
    BNE CODE_00CD95
    LDA.W PlayerClimbingRope
    BEQ +
    LDA.B #$1F
    STA.B InteractionPtsClimbable
  + LDA.B PlayerIsClimbing                    ; Branch if Mario is climbing.
    BNE CODE_00CD72
    LDA.W IsCarryingItem
    ORA.W PlayerRidingYoshi                   ; Don't allow climbing while holding an item.
    BNE CODE_00CD79
    LDA.B InteractionPtsClimbable
    AND.B #$1B
    CMP.B #$1B
    BNE CODE_00CD79
    LDA.B byetudlrHold
    AND.B #$0C
    BEQ CODE_00CD79
    LDY.B PlayerInAir
    BNE CODE_00CD72
    AND.B #$08
    BNE CODE_00CD72
    LDA.B InteractionPtsClimbable
    AND.B #$04
    BEQ CODE_00CD79
CODE_00CD72:
    LDA.B InteractionPtsClimbable
    STA.B PlayerIsClimbing
    JMP CODE_00DB17

CODE_00CD79:
    LDA.B PlayerInWater
    BEQ CODE_00CD82                           ; If Mario is in water, run the swimming routine and
    JSR CODE_00D988                           ; skip all the in-air routines.
    BRA CODE_00CD8F

CODE_00CD82:
    JSR CODE_00D5F2                           ; Handle jumping.
    JSR CODE_00D062                           ; Handle capespinning/throwing fireballs.
    JSR CODE_00D7E4                           ; Handle flight.
CODE_00CD8B:
    JSL CODE_00CEB1                           ; Animate Mario (and his cape).
CODE_00CD8F:
    LDY.W PlayerRidingYoshi                   ; If riding Yoshi, branch to change his animation frame to an appropriate riding animation.
    BNE CODE_00CDAD
    RTS

CODE_00CD95:
    LDA.B #$42                                ; Handling Mario's animation with a P-balloon.
    LDX.B Powerup
    BEQ +
    LDA.B #$43
  + DEY                                       ; Handle Mario's pose when he has a P-balloon (poses 43/42/0F).
    BEQ +
    STY.W PBalloonInflating
    LDA.B #$0F                                ; \ Mario's image = Going down tube
  + STA.W PlayerPose                          ; /
CODE_00CDA8:
    RTS


    db $20,$21,$27,$28

CODE_00CDAD:
; Animations for Mario while riding Yoshi.
; Order is normal, turning, spitting tongue A, spitting tongue B.
    LDX.W YoshiTongueTimer                    ; Handling Mario's animation on Yoshi. Also handles the unused routine to shoot fireballs on Yoshi.
    BEQ +
    LDY.B #$03
    CPX.B #$0C
    BCS +
    LDY.B #$04
; Set Mario's pose on Yoshi, using the table above.
  + LDA.W CODE_00CDA8,Y                       ; When sticking his tongue out, Y is either 3 or 4, for Mario's "punch" animation.
    DEY                                       ; Otherwise, Y is set prior to calling this routine to 1 or 2 (based on $187A).
    BNE +
    LDY.B PlayerIsDucking
    BEQ +
    LDA.B #$1D                                ; \ Mario's image = Picking up object
  + STA.W PlayerPose                          ; /
    LDA.W YoshiHasWingsEvt                    ; \ Check Yoshi wing ability address for #$01,
    CMP.B #$01                                ; / but this is an impossible value
    BNE Return00CDDC                          ; \ Unreachable/unused code
    BIT.B byetudlrFrame                       ; | Lets Mario (any power) shoot fireballs while on Yoshi; If enabled to do so and X/Y is pressed, shoot a fireball. (unused, normally)
    BVC Return00CDDC                          ; |
    LDA.B #$08                                ; |; SFX for shooting a fireball on Yoshi.
    STA.W Empty18DB                           ; |
    JSR ShootFireball                         ; /
Return00CDDC:
    RTS

CODE_00CDDD:
; Routine to handle L/R scrolling.
    LDA.W HorizLayer1Setting                  ; Return if horizontal scrolling is disabled.
    BEQ Return00CDDC
    LDY.W CameraScrollDir
    LDA.W CameraIsScrolling                   ; If the screen is currently scrolling, freeze sprites and branch.
    STA.B SpriteLock
    BNE CODE_00CE4C
    LDA.W CameraProperMove
    BEQ CODE_00CDF6                           ; If the screen is currently "correcting" its position, prevent scrolling and skip down.
    STZ.W CameraScrollDir                     ; Else, continue below.
    BRA CODE_00CE48

CODE_00CDF6:
    LDA.B axlr0000Hold                        ; \ Branch if anything besides L/R being held; Able to screen scroll; check for L/R.
    AND.B #$CF                                ; |; Make sure no other buttons are pressed.
    ORA.B byetudlrHold                        ; |
    BNE CODE_00CE49                           ; /; [change from BNE to BRA to disable L/R scrolling]
    LDA.B axlr0000Hold                        ; \ Branch if L/R not being held
    AND.B #$30                                ; |
    BEQ CODE_00CE49                           ; |; Make sure either L or R is pressed (and not neither/both).
    CMP.B #$30                                ; |
    BEQ CODE_00CE49                           ; /
    LSR A
    LSR A
    LSR A
    INC.W CameraScrollTimer
    LDX.W CameraScrollTimer
    CPX.B #$10                                ; How many frames to wait before allowing the screen to scroll.
    BCC CODE_00CE4C
    TAX                                       ; Branch if:
    REP #$20                                  ; A->16; Still waiting for the screen to scroll
    LDA.W CameraMoveTrigger                   ; Already scrolled all the way over
    CMP.W DATA_00F6CB,X
    SEP #$20                                  ; A->8
    BEQ CODE_00CE4C
    LDA.B #$01
    TRB.W CameraMoveTrigger
    INC.W CameraIsScrolling
    LDA.B #$00
    CPX.B #$02
    BNE +
    LDA.B LastScreenHoriz
    DEC A
  + REP #$20                                  ; A->16
    XBA
    AND.W #$FF00
    CMP.B Layer1XPos
    SEP #$20                                  ; A->8
    BEQ +
    LDY.B #!SFX_SCREENSCROLL                  ; \ Play sound effect; SFX for screen scrolling.
    STY.W SPCIO3                              ; /
  + TXA
    STA.W CameraScrollDir
CODE_00CE48:
    TAY
CODE_00CE49:
    STZ.W CameraScrollTimer
CODE_00CE4C:
    LDX.B #$00
    LDA.B PlayerDirection
    ASL A
    STA.W CameraScrollPlayerDir
    REP #$20                                  ; A->16
    LDA.W CameraMoveTrigger
    CMP.W DATA_00F6CB,Y                       ; If scrolled all the way over, branch.
    BEQ CODE_00CE6D
    CLC                                       ; Move screen position.
    ADC.W DATA_00F6BF,Y
    LDY.W CameraScrollPlayerDir
    CMP.W DATA_00F6B3,Y
    BNE +
    STX.W CameraScrollDir
CODE_00CE6D:
    STX.W CameraIsScrolling
  + STA.W CameraMoveTrigger
    STX.W CameraProperMove
    SEP #$20                                  ; A->8
CODE_00CE78:
    RTS


    db $2A,$2B,$2C,$2D,$2E,$2F

DATA_00CE7F:
    db $2C,$2C,$2C,$2B,$2B,$2C,$2C,$2B
    db $2B,$2C,$2D,$2A,$2A,$2D,$2D,$2A
    db $2A,$2D,$2D,$2A,$2A,$2D,$2E,$2A
    db $2A,$2E

DATA_00CE99:
    db $00,$00,$25,$44,$00,$00,$0F,$45
DATA_00CEA1:
    db $00,$00,$00,$00,$01,$01,$01,$01
DATA_00CEA9:
    db $02,$07,$06,$09,$02,$07,$06,$09

CODE_00CEB1:
; Animation frames when flying.
; Animation frames when cape-sliding after landing from flight.
; Indexed by the values from $13E1 divided by 2, plus Mario's direction.
; Spinjump frame table. Alternates small-big, order left-back-right-front.
; Directions for Mario during the spinjump/capespin animation. Same order as above.
; Animation frames for Mario's cape while spinjumping/capespinning. Alternates rising/on-ground, falling.
; Primary Mario animation routine. First part gets cape image (X = image, Y = timer), second gets Mario image.
    LDA.W CapeAniTimer                        ; Related to cape animation?; Branch if capespinning, to not set the cape animation frame.
    BNE lbl14A2Not0
    LDX.W PlayerCapePose                      ; Cape image
    LDA.B PlayerInAir                         ; If Mario isn't in air, branch to $CEDE; Branch if Mario is on the ground.
    BEQ MarioAnimAir                          ; branch to $CEDE
    LDY.B #$04                                ; Length of the cape animation timer when in the air.
    BIT.B PlayerYSpeed+1                      ; \ If Mario is falling (and thus not on ground); Branch if Mario is falling.
    BPL CODE_00CECD                           ; / branch down
    CMP.B #$0C                                ; \ If making a "run jump",
    BEQ CODE_00CEFD                           ; / branch to $CEFD; Branch if Mario is shooting out of a pipe, jumping while running at max speed, or in water.
    LDA.B PlayerInWater                       ; \ If Mario is in water,
    BNE CODE_00CEFD                           ; |branch to $CEFD
    BRA MrioNtInWtr                           ; / otherwise, branch to $CEE4; Else, branch because Mario is not doing those (i.e. rising from a normal jump).

CODE_00CECD:
    INX                                       ; \; Mario is falling.
    CPX.B #$05                                ; |if X >= #$04 and != #$FF then jump down <- counting the INX
    BCS CODE_00CED6                           ; /
    LDX.B #$05                                ; X = #$05
    BRA CODE_00CF0A                           ; Branch to $CF04; If Mario's cape is currently "down", switch it to frame 5.

CODE_00CED6:
    CPX.B #$0B                                ; \ If X is less than #$0B,; If Mario's cape is currently "up", switch it to frame 7.
    BCC CODE_00CF0A                           ; / branch to $CF0A
    LDX.B #$07                                ; X = #$07
    BRA CODE_00CF0A                           ; Mario is not in the air, branch to $CF0A

MarioAnimAir:
; Mario is on the ground.
    LDA.B PlayerXSpeed+1                      ; \ If Mario X speed isn't 0,; Branch if Mario is moving.
    BNE CODE_00CEF0                           ; / branch to $CEF0
    LDY.B #$08                                ; Otherwise Y = #$08; Slow down the cape's animation.
MrioNtInWtr:
    TXA                                       ; A = X = #13DF; Mario is rising from a normal jump.
    BEQ CODE_00CF0A                           ; If $13DF (now A) = 0 branch to $CF04
    DEX                                       ; \; If the cape is fully down (frame 0), don't change its animation frame.
    CPX.B #$03                                ; |If X - 1 < #$03 Then Branch $CF04; If it's in frames 1-4, decrease its frame (i.e. lower it downwards).
    BCC CODE_00CF0A                           ; /; If it's greater than 4, drop it down to frame 2 (i.e. it was pointed upwards before).
    LDX.B #$02                                ; X = #$02
    BRA CODE_00CF0A                           ; Branch to $CF04

CODE_00CEF0:
    BPL +                                     ; \; Mario is moving on the ground.
    EOR.B #$FF                                ; |A = abs(A)
    INC A                                     ; |
  + LSR A                                     ; \; Get animation speed for the cape based on how fast Mario is running.
    LSR A                                     ; |Divide a by 8
    LSR A                                     ; /
    TAY                                       ; Y = A
    LDA.W DATA_00DC7C,Y                       ; A = Mario animation speed? (I didn't know it was a table...)
    TAY                                       ; Load Y with this table
CODE_00CEFD:
    INX                                       ; \; Mario is shooting out of a pipe, jumping while running at max speed, or in water.
    CPX.B #$03                                ; |; If the cape is in frames 1/2, bump its frame up to 5.
    BCS +                                     ; |If X is < #$02 and != #$FF <- counting the INX; If it's in frames 7-A, drop it down to frame 3.
    LDX.B #$05                                ; |then X = #$05; Else, just increase it.
  + CPX.B #$07                                ; \; Altogether, this creates the cape's "flapping" motion.
    BCC CODE_00CF0A                           ; |If X is greater than or equal to #$07 then X = #$03
    LDX.B #$03                                ; |
CODE_00CF0A:
    STX.W PlayerCapePose                      ; And X goes right back into $13DF (cape image) after being modified
    TYA                                       ; Now Y goes back into A
    LDY.B PlayerInWater                       ; \
    BEQ +                                     ; |If mario is in water then A = 2A; Store the cape frame and animation timer.
    ASL A                                     ; |
  + STA.W CapeAniTimer                        ; A -> $14A2 (do we know this byte yet?) no.
lbl14A2Not0:
    LDA.W SpinJumpFlag                        ; A = Spin Jump Flag; Mario is capespinning.
    ORA.W CapeSpinTimer                       ; Branch if Mario is not spinning (spinjump, capespin).
    BEQ CODE_00CF4E                           ; If $140D OR $14A6 = 0 then branch to $CF4E
    STZ.B PlayerIsDucking                     ; 0 -> Ducking while jumping flag
    LDA.B EffFrame                            ; \
    AND.B #$06                                ; |X = Y = Alternate frame counter AND #$06
    TAX                                       ; |; Animate the cape's spinning animation.
    TAY                                       ; /
    LDA.B PlayerInAir                         ; \ If on ground branch down
    BEQ +                                     ; /
    LDA.B PlayerYSpeed+1                      ; \ If Mario moving upwards branch down
    BMI +                                     ; /; Get the animation frame for the cape.
    INY                                       ; Y = Y + 1
  + LDA.W DATA_00CEA9,Y                       ; \ After loading from this table,
    STA.W PlayerCapePose                      ; / Store A in cape image
    LDA.B Powerup                             ; A = Mario's powerup status
    BEQ +                                     ; \
    INX                                       ; |If not small, increase X; Set Mario's direction.
  + LDA.W DATA_00CEA1,X                       ; \ Load from another table
    STA.B PlayerDirection                     ; / store to Mario's Direction
    LDY.B Powerup                             ; \
    CPY.B #$02                                ; |; If Mario has a feather, process capespin interaction.
    BNE +                                     ; |If Mario has cape, JSR
    JSR CODE_00D044                           ; |to possibly the graphics handler
  + LDA.W DATA_00CE99,X                       ; \ Load from a table again
    JMP CODE_00D01A                           ; / And jump

CODE_00CF4E:
; Mario is not capespinning (done with cape; time to handle Mario's actual animation frame).
    LDA.W PlayerSlopePose                     ; \ If $13ED is #$01 - #$7F then; Branch A if not sliding.
    BEQ CODE_00CF62                           ; |branch to $CF85; Branch B if sliding on a slope (not from flight) to store sliding animation frame and return.
    BPL CODE_00CF85                           ; |
    LDA.W SlopeType
    LSR A
    LSR A
    ORA.B PlayerDirection                     ; Flying: get appropriate flight frame for the slope Mario is on and store that, then return.
    TAY
    LDA.W DATA_00CE7F,Y
    BRA CODE_00CF85

CODE_00CF62:
    LDA.B #$3C                                ; \ Select Case $148F; Not sliding.
    LDY.W IsCarryingItem                      ; |Case 0:A = #$3C; Get ducking frame (1D or 3C, depending on whether or not Mario is holding an item).
    BEQ +                                     ; |Case Else: A = #$1D
    LDA.B #$1D                                ; |End Select
  + LDY.B PlayerIsDucking                     ; \ If Ducking while jumping; If Mario actually is ducking, branch to store the animation frame and return.
    BNE CODE_00CF85                           ; / Branch to $CF85
    LDA.W ShootFireTimer                      ; \ If (Unknown) = 0; Branch if not shooting a fireball.
    BEQ CODE_00CF7E                           ; / Branch to $CF7E
    LDA.B #$3F                                ; A = #$3F
    LDY.B PlayerInAir                         ; \ If Mario isn't in air,
    BEQ CODE_00CF85                           ; |branch to $CF85; Show shooting frame (16 or 3F, depending on whether or not Mario is in water).
    LDA.B #$16                                ; |Otherwise, set A to #$16 and
    BRA CODE_00CF85                           ; / branch to $CF85

CODE_00CF7E:
    LDA.B #$0E                                ; A = #$0E; Not shooting a fireball.
    LDY.W KickingTimer                        ; \ If Time to show Mario's current pose is 00,
    BEQ +                                     ; | Don't jump to $D01A; If kicking something, store animation frame 0E and return.
CODE_00CF85:
    JMP CODE_00D01A                           ; |

  + LDA.B #$1D                                ; A = #$1D; Not kicking something.
    LDY.W PickUpItemTimer                     ; \ If $1499 != 0 then Jump to $D01A; If picking something up, store animation frame 1D and return.
    BNE CODE_00CF85                           ; /
    LDA.B #$0F                                ; A = #$0F
    LDY.W FaceScreenTimer                     ; \ If $1499 != 0 then Jump to $D01A; If facing the screen (turning/pipe), store animation frame 0F and return.
    BNE CODE_00CF85                           ; /
    LDA.B #$00                                ; A = #$00; Stationary animation frame.
    LDX.W PlayerInCloud                       ; X = $18C2 (Unknown); Branch if in a Lakitu Cloud.
    BNE MarioAnimNoAbs1                       ; If X != 0 then branch down
    LDA.B PlayerInAir                         ; \ If Mario is flying branch down; Branch if on the ground.
    BEQ CODE_00CFB7                           ; /
    LDY.W RunTakeoffTimer                     ; \ If $14A0 != 0 then; Branch if Mario just jumped and running frames should still be shown for a bit.
    BNE CODE_00CFBC                           ; / Skip down
    LDY.W FlightPhase                         ; Spaghetticode(tm)
    BEQ +                                     ; If flying, get appropriate flight animation frame.
    LDA.W CODE_00CE78,Y
  + LDY.W IsCarryingItem                      ; \ If Mario isn't holding something,
    BEQ CODE_00D01A                           ; |branch to $D01A; If carrying something, use frame 09 instead.
    LDA.B #$09                                ; |Otherwise, set A to #$09 and; Either way, store and return.
    BRA CODE_00D01A                           ; / branch to $D01A

CODE_00CFB7:
; Mario is on the ground.
    LDA.W PlayerTurningPose                   ; If the player is supposed to "slide a bit" (very steep slope), just store frame 0 and return.
    BNE CODE_00D01A
CODE_00CFBC:
    LDA.B PlayerXSpeed+1                      ; \; Mario just jumped but is still showing running frames.
    BPL MarioAnimNoAbs1                       ; |; Get absolute value of Mario's X speed.
    EOR.B #$FF                                ; |Set A to absolute value of Mario's X speed
    INC A                                     ; |
MarioAnimNoAbs1:
; In a Lakitu cloud.
    TAX                                       ; Copy A to X; If not stationary, branch to get running animation frame.
    BNE CODE_00CFD4                           ; If Mario isn't standing still, branch to $CFD4
    XBA                                       ; "Push" A
    LDA.B byetudlrHold                        ; \
    AND.B #$08                                ; |If player isn't pressing up,; If up isn't pressed, branch.
    BEQ CODE_00D002                           ; |branch to $D002
    LDA.B #$03                                ; |Otherwise, store x03 in $13DE and; Store "looking up" flag.
    STA.W PlayerOverworldPose                 ; |branch to $D002
    BRA CODE_00D002                           ; /

CODE_00CFD4:
; Not stationary.
    LDA.B LevelIsSlippery                     ; \ If level isn't slippery,; Branch if not in a slippery level.
    BEQ CODE_00CFE3                           ; / branch to $CFE3
    LDA.B byetudlrHold
    AND.B #$03                                ; Branch if not holding left/right, to not animate Mario's running (so he slides).
    BEQ CODE_00D003
    LDA.B #$68                                ; Increase base index for the running animation timer table.
    STA.W PlayerPoseLenTimer
CODE_00CFE3:
    LDA.W PlayerWalkingPose                   ; A = $13DB
    LDY.W PlayerAniTimer                      ; \ If Mario is hurt (flashing),; Branch if not time to update Mario's running pose.
    BNE CODE_00D003                           ; / branch to $D003
    DEC A                                     ; A = A - 1
    BPL +                                     ; \If bit 7 is clear,; Get new animation frame for Mario's running animation.
    LDY.B Powerup                             ; | Load amount of walking frames
    LDA.W NumWalkingFrames,Y                  ; | for current powerup
  + XBA                                       ; \ >>-This code puts together an index to a table further down-<<
    TXA                                       ; |-\ Above Line: "Push" frame amount
    LSR A                                     ; |  |A = X / 8
    LSR A                                     ; |  |
    LSR A                                     ; |-/; Store new timer for the running frame.
    ORA.W PlayerPoseLenTimer                  ; |ORA with $13E5
    TAY                                       ; |And store A to Y
    LDA.W DATA_00DC7C,Y                       ; |
    STA.W PlayerAniTimer                      ; /
CODE_00D002:
    XBA                                       ; \ Switch in frame amount and store it to $13DB; Player is stationary (high A byte contains his animation frame).
CODE_00D003:
; Not time to get a new running frame.
    STA.W PlayerWalkingPose                   ; /; Store running frame pose.
    CLC                                       ; \ Add walking animation type
    ADC.W PlayerOverworldPose                 ; / (Walking, running...)
    LDY.W IsCarryingItem                      ; \; Use animation frame:
    BEQ CODE_00D014                           ; |; 0-2 if walking/running
    CLC                                       ; |If Mario is carrying something, add #$07; 3 if looking up
    ADC.B #$07                                ; |; 4-6 if sprinting
    BRA CODE_00D01A                           ; |; 7-9 if carrying an item

CODE_00D014:
    CPX.B #con($2F,$2F,$2F,$3A,$3A)           ; \; A if carrying an item and looking up
    BCC CODE_00D01A                           ; |If X is greater than #$2F, add #$04
    ADC.B #$03                                ; / <-Carry is always set here, adding #$01 to (#$03 + A)
CODE_00D01A:
    LDY.W WallrunningType                     ; \ If Mario isn't rotated 45 degrees (triangle; Most of the frames branch to here to do the final store. Wallrunning can potentially override all.
    BEQ +                                     ; / block), branch to $D030
    TYA                                       ; \ Y AND #$01 -> Mario's Direction RAM Byte
    AND.B #$01                                ; |
    STA.B PlayerDirection                     ; /
    LDA.B #$10                                ; \; If wallrunning, use frames 11-13.
    CPY.B #$06                                ; |If Y < 6 then
    BCC +                                     ; |    A = #13DB + $11
    LDA.W PlayerWalkingPose                   ; |Else
    CLC                                       ; |    A = #$10
    ADC.B #$11                                ; |End If
  + STA.W PlayerPose                          ; Store in Current animation frame; FINALLY, store that dang animation frame.
    RTL                                       ; And Finish


DATA_00D034:
    db $0C,$00,$F4,$FF,$08,$00,$F8,$FF
DATA_00D03C:
    db $10,$00,$10,$00,$02,$00,$02,$00

CODE_00D044:
; Cape/net punch collision X offsets, 16-bit. (right, left)
; Capespin
; Net punch
; Cape/net punch collision Y offsets, 16-bit. (right, left)
; Capespin
; Net punch
; Subroutine to calculate capespin and net punch interaction.
    LDY.B #$01                                ; Enable capespin interaction with sprites.
    STY.W CapeInteracts
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext                      ; \
    CLC                                       ; |
    ADC.W DATA_00D034,Y                       ; |
    STA.W CapeInteractionXPos                 ; |Set cape<->sprite collision coordinates; Interact at Mario's position.
    LDA.B PlayerYPosNext                      ; |
    CLC                                       ; |
    ADC.W DATA_00D03C,Y                       ; |
    STA.W CapeInteractionYPos                 ; /
    SEP #$20                                  ; A->8
    RTS

CODE_00D062:
    LDA.B Powerup                             ; Subroutine that handles capespinning.
    CMP.B #$02                                ; Which powerup gives Mario the ability to capespin.
    BNE CODE_00D081
    BIT.B byetudlrFrame                       ; Return if X/Y not pressed.
    BVC Return00D0AD
    LDA.B PlayerIsDucking
    ORA.W PlayerRidingYoshi                   ; Return if ducking, riding Yoshi, or spinjumping.
    ORA.W SpinJumpFlag
    BNE Return00D0AD
    LDA.B #$12                                ; How long the capespin lasts.
    STA.W CapeSpinTimer
    LDA.B #!SFX_SPIN                          ; \ Play sound effect; SFX for capespinning.
    STA.W SPCIO3                              ; /
    RTS

CODE_00D081:
; Subroutine that handles throwing fireballs.
    CMP.B #$03                                ; Which powerup gives Mario the ability to throw fireballs.
    BNE Return00D0AD
    LDA.B PlayerIsDucking
    ORA.W PlayerRidingYoshi                   ; If Mario is ducking or riding Yoshi, return.
    BNE Return00D0AD
    BIT.B byetudlrFrame                       ; If X or Y is pressed, branch to spawn a fireball.
    BVS CODE_00D0AA
    LDA.W SpinJumpFlag                        ; If Mario isn't spinjumping, return.
    BEQ Return00D0AD
    INC.W SpinjumpFireball
    LDA.W SpinjumpFireball                    ; Handle spinjump fireball timer, and if not time to spawn a fireball, return.
    AND.B #$0F
    BNE Return00D0AD
    TAY
    LDA.W SpinjumpFireball
    AND.B #$10
    BEQ +                                     ; Flip player's horizontal direction every 16 frames.
    INY
  + STY.B PlayerDirection
CODE_00D0AA:
    JSR ShootFireball                         ; haha, I read this as "FEAR" at first; Spawn a fireball.
Return00D0AD:
    RTS


    db $7C,$00,$80,$00,$00,$06,$00,$01

MarioDeathAni:
    STZ.B Powerup                             ; Set powerup to 0; Subroutine for the death animation.
    LDA.B #$3E                                ; \
    STA.W PlayerPose                          ; / Set Mario image to death image
    LDA.B TrueFrame                           ; \
    AND.B #$03                                ; |Decrease "Death fall timer" every four frames
    BNE +                                     ; |
    DEC.W PlayerAniTimer                      ; |
  + LDA.W PlayerAniTimer                      ; \ If Death fall timer isn't #$00,; Check if it's time to fade to the overworld.
    BNE DeathNotDone                          ; / branch to $D108
    LDA.B #$80
    STA.W OWLevelExitMode
    LDA.W RemoveYoshiFlag
    BNE +
    STZ.W CarryYoshiThruLvls                  ; Set reserve item to 0
  + DEC.W PlayerLives                         ; Decrease amount of lifes; Decrease life counter, and branch if not at 0 lives yet.
    BPL DeathNotGameOver                      ; If not Game Over, branch to $D0E6
    LDA.B #!BGM_GAMEOVER
    STA.W SPCIO2                              ; / Change music
    LDX.B #$14                                ; Set X (Death message) to x14 (Game Over)
    BRA DeathShowMessage

DeathNotGameOver:
    LDY.B #$0B                                ; Set Y (game mode) to x0B (Fade to overworld); Routine to handle Mario dying when he still has lives remaining.
    LDA.W InGameTimerHundreds                 ; \
    ORA.W InGameTimerTens                     ; |If time isn't zero,; Check if Mario died to time.
    ORA.W InGameTimerOnes                     ; |branch to $D104
    BNE +                                     ; /
    LDX.B #$1D                                ; Set X (Death message) to x1D (Time Up)
DeathShowMessage:
    STX.W DeathMessage                        ; Store X in Death message
    LDA.B #$C0                                ; \ Set Death message animation to xC0
    STA.W GameOverAnimation                   ; /(Must be divisable by 4)
    LDA.B #$FF                                ; \ Set Death message timer to xFF
    STA.W GameOverTimer                       ; /
    LDY.B #$15                                ; Set Y (game mode) to x15 (Fade to Game Over)
  + STY.W GameMode                            ; Store Y in Game Mode
    RTS

DeathNotDone:
    CMP.B #$26                                ; \ If Death fall timer >= x26,
    BCS +                                     ; / return
    STZ.B PlayerXSpeed+1                      ; Set Mario X speed to 0
    JSR CODE_00DC2D                           ; Update Mario's X/Y position.
    JSR CODE_00D92E
    LDA.B TrueFrame                           ; \
    LSR A                                     ; |
    LSR A                                     ; |Flip death image every four frames
    AND.B #$01                                ; |
    STA.B PlayerDirection                     ; /
  + RTS


GrowingAniImgs:
    db $00,$3D,$00,$3D,$00,$3D,$46,$3D
    db $46,$3D,$46,$3D

PowerDownAni:
; Mario animation frames for powerup/powerdown.
    LDA.W PlayerAniTimer                      ; Damage powerdown animation.
    BEQ CODE_00D140
    LSR A
    LSR A
CODE_00D130:
    TAY
    LDA.W GrowingAniImgs,Y                    ; \ Set Mario's image; Get the image to use.
    STA.W PlayerPose                          ; /
CODE_00D137:
    LDA.W PlayerAniTimer
    BEQ +
    DEC.W PlayerAniTimer
  + RTS

CODE_00D140:
    LDA.B #$7F                                ; How long to make Mario invincible after taking damage. Or growing from a cape?
    STA.W IFrameTimer
    BRA CODE_00D158

MushroomAni:
    LDA.W PlayerAniTimer                      ; Mushroom powerup animation.
    BEQ CODE_00D156
    LSR A
    LSR A
    EOR.B #$FF
    INC A
    CLC
    ADC.B #$0B
    BRA CODE_00D130

CODE_00D156:
    INC.B Powerup
CODE_00D158:
    LDA.B #$00
    STA.B PlayerAnimation
    STZ.B SpriteLock
  - RTS

CapeAni:
; Cape powerup animation.
    LDA.B #$7F                                ; Hide Mario.
    STA.B PlayerHiddenTiles
    DEC.W PlayerAniTimer                      ; Return if to time to end the animation.
    BNE -
    LDA.B Powerup
    LSR A                                     ; Unused? $19 will always be #$02 here.
    BEQ CODE_00D140
    BNE CODE_00D158                           ; Return Mario to a normal state.
FlowerAni:
    LDA.W PlayerSlopePose                     ; Fireflower powerup animation.
    AND.B #$80
    ORA.W FlightPhase
    BEQ +
    STZ.W FlightPhase
    LDA.W PlayerSlopePose
    AND.B #$7F
    STA.W PlayerSlopePose
    STZ.W PlayerPose
  + DEC.W CyclePaletteTimer
    BEQ CODE_00D158
    RTS


PipeSpeed:
    db $F8,$08                                ; horizontal pipe X speed
    db $00,$00                                ; horizontal pipe Y speed, vertical pipe X speed
if ver_is_ntsc(!_VER)                         ;\================== J, U, & SS =================
    db $F0,$10                                ;! vertical pipe Y speed
else                                          ;<=================== E0 & E1 ===================
    db $F2,$0E                                ;! vertical pipe Y speed
endif                                         ;/===============================================

DATA_00D193:
    db $00,$63,$1C,$00

DoorPipeAni:
    JSR NoButtons                             ; X speeds for entering pipes.
    STZ.W PlayerOverworldPose
    JSL CODE_00CEB1
; Spacer indexes for pipe X/Y speeds. Recommended not to edit.
; Y speeds for entering pipes.
    JSL CODE_00CFBC                           ; Animate Mario (and his cape).
    JSR CODE_00D1F4
    LDA.W PlayerRidingYoshi
    BEQ +
    LDA.B #$29                                ; \ Mario's image = Entering horizontal pipe on Yoshi
    STA.W PlayerPose                          ; /
  + REP #$20                                  ; A->16
    LDA.B PlayerYPosNext
    SEC
    SBC.W #$0008
    AND.W #$FFF0
    ORA.W #$000E
    STA.B PlayerYPosNext
    SEP #$20                                  ; A->8
    LDA.B PlayerPipeAction
    LSR A
    TAY
    INY
    LDA.W DATA_00D193-1,Y
    LDX.W IsCarryingItem
    BEQ +
    EOR.B #$1C
    DEC.W FaceScreenTimer
    BPL +
    INC.W FaceScreenTimer
  + LDX.B PipeTimer
    CPX.B #$1D
    BCS CODE_00D1F0
    CPY.B #$03
    BCC +
    REP #$20                                  ; A->16
    INC.B PlayerYPosNext
    INC.B PlayerYPosNext
    SEP #$20                                  ; A->8
  + LDA.W DATA_00D193,Y
CODE_00D1F0:
    STA.B PlayerHiddenTiles
    BRA CODE_00D22D

CODE_00D1F4:
    LDA.W CapeAniTimer
    BEQ +
    DEC.W CapeAniTimer
  + JMP CODE_00D137


PipeCntrBoundryX:
    db $0A,$06

PipeCntringSpeed:
    db $FF,$01

VertPipeAni:
    JSR NoButtons
    STZ.W PlayerCapePose
    LDA.B #$0F
    LDY.W PlayerRidingYoshi
    BEQ CODE_00D22A
    LDX.B #$00
    LDY.B PlayerDirection                     ; \
    LDA.B PlayerXPosNext                      ; | If not relativly centered on the pipe...
    AND.B #$0F                                ; |
    CMP.W PipeCntrBoundryX,Y                  ; |
    BEQ CODE_00D228                           ; |
    BPL +                                     ; |
    INX                                       ; |
  + LDA.B PlayerXPosNext                      ; | ...adjust Mario's X postion
    CLC                                       ; |
    ADC.W PipeCntringSpeed,X                  ; |
    STA.B PlayerXPosNext                      ; /
CODE_00D228:
    LDA.B #$21                                ; \ Mario's image = going down pipe
CODE_00D22A:
    STA.W PlayerPose                          ; /
CODE_00D22D:
    LDA.B #$40                                ; \ Set holding X/Y on controller
    STA.B byetudlrHold                        ; /
    LDA.B #$02                                ; \ Set behind scenery flag; Set flag to send Mario behind layers and other sprites?
    STA.W PlayerBehindNet                     ; /
    LDA.B PlayerPipeAction
    CMP.B #$04
    LDY.B PipeTimer
    BEQ CODE_00D268
    AND.B #$03
    TAY
    DEC.B PipeTimer
    BNE +
    BCS +
    LDA.B #$7F
    STA.B PlayerHiddenTiles
    INC.W DrawYoshiInPipe
  + LDA.B PlayerXSpeed+1                      ; \ If Mario has no speed...
    ORA.B PlayerYSpeed+1                      ; |
    BNE +                                     ; |
    LDA.B #!SFX_PIPE                          ; | ...play sound effect
    STA.W SPCIO0                              ; /
  + LDA.W PipeSpeed,Y                         ; \ Set X speed
    STA.B PlayerXSpeed+1                      ; /; Set Mario's X/Y speed depending on the pipe he's entering.
    LDA.W PipeSpeed+2,Y                       ; \ Set Y speed
    STA.B PlayerYSpeed+1                      ; /
    STZ.B PlayerInAir                         ; Mario flying = false
    JMP CODE_00DC2D

CODE_00D268:
    BCC CODE_00D273
CODE_00D26A:
    STZ.W PlayerBehindNet                     ; \ In new level, reset values
    STZ.W YoshiInPipeSetting                  ; /
    JMP CODE_00D158

CODE_00D273:
    INC.W SublevelCount
    LDA.B #$0F
    STA.W GameMode
    RTS

; Unused code, probably meant for moving Mario as part of the pipe entering animation.
    LDA.B PlayerYPosNext                      ; \ Unreachable; $88 seems to no longer be used the way this code intends it as, however.
    SEC                                       ; |
    SBC.B PlayerYPosNow                       ; |
    CLC                                       ; |
    ADC.B PipeTimer                           ; |
    STA.B PipeTimer                           ; |
    RTS                                       ; /

PipeCannonAni:
    JSR NoButtons                             ; Mario state 07 - Shot out of a diagonal pipe.
    LDA.B #$02                                ; Set flag to send Mario behind layers and other sprites.
    STA.W PlayerBehindNet
    LDA.B #$0C
    STA.B PlayerInAir
    JSR CODE_00CD8B
    DEC.B PipeTimer
    BNE +
    JMP CODE_00D26A

  + LDA.B PipeTimer
    CMP.B #$18
    BCC CODE_00D2AA
    BNE +
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
CODE_00D2AA:
    STZ.W PlayerBehindNet
    STZ.W YoshiInPipeSetting
    STZ.B SpriteLock                          ; Set sprites not locked
  + LDA.B #$40                                ; \ X speed = #$40; X speed for Mario when shot out of a diagonal pipe.
    STA.B PlayerXSpeed+1                      ; /; (NOTE: LM hijacks here)
    LDA.B #$C0                                ; \ Y speed = #$C0; Y speed for Mario when shot out of a diagonal pipe.
    STA.B PlayerYSpeed+1                      ; /
    JMP CODE_00DC2D


DATA_00D2BD:
    db $B0,$B6,$AE,$B4,$AB,$B2,$A9,$B0
    db $A6,$AE,$A4,$AB,$A1,$A9,$9F,$A6

if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
DATA_00D2CD:                                  ;!
    dw $FF00,$0100,$FF00,$0100                ;!
    dw $FF00,$0100,$FE80,$00C0                ;!
    dw $FF40,$0180,$FE00,$0040                ;!
    dw $FFC0,$0200,$FE00,$0040                ;!
    dw $FE00,$0040,$FFC0,$0200                ;!
    dw $FFC0,$0200,$FC00,$FF00                ;!
    dw $0100,$0400,$FF00,$0100                ;!
    dw $FF00,$0100                            ;!
                                              ;!
DATA_00D309:                                  ;!
    dw $FFE0,$0020,$FFE0,$0020                ;!
    dw $FFE0,$0020,$FFC0,$0020                ;!
    dw $FFE0,$0040,$FF80,$0020                ;!
    dw $FFE0,$0080,$FF80,$0020                ;!
    dw $FF80,$0020,$FFE0,$0080                ;!
    dw $FFE0,$0080,$FE00,$FF80                ;!
    dw $0080,$0200,$FF00,$0100                ;!
    dw $FF00,$0100                            ;!
                                              ;!
MarioAccel_:                                  ;!
    dw $FE80,$FE80,$0180,$0180                ;!
    dw $FE80,$FE80,$0180,$0180                ;!
    dw $FE80,$FE80,$0180,$0180                ;!
    dw $FE80,$FE80,$0140,$0140                ;!
    dw $FEC0,$FEC0,$0180,$0180                ;!
    dw $FE80,$FE80,$0100,$0100                ;!
    dw $FF00,$FF00,$0180,$0180                ;!
    dw $FE80,$FE80,$0100,$0100                ;!
    dw $FE80,$FE80,$0100,$0100                ;!
    dw $FF00,$FF00,$0180,$0180                ;!
    dw $FF00,$FF00,$0180,$0180                ;!
    dw $FC00,$FC00,$FD00,$FD00                ;!
    dw $0300,$0300,$0400,$0400                ;!
    dw $FC00,$FC00,$0600,$0600                ;!
    dw $FA00,$FA00,$0400,$0400                ;!
    dw $FF80,$0080,$FF00,$0100                ;!
    dw $FE80,$0180,$FE80,$FE80                ;!
    dw $0180,$0180,$FE80,$0280                ;!
    dw $FD80,$FB00,$0280,$0500                ;!
    dw $FD80,$FB00,$0280,$0500                ;!
    dw $FD80,$FB00,$0280,$0500                ;!
    dw $FD40,$FA80,$0240,$0480                ;!
    dw $FDC0,$FB80,$02C0,$0580                ;!
    dw $FD00,$FA00,$0200,$0400                ;!
    dw $FE00,$FC00,$0300,$0600                ;!
    dw $FD00,$FA00,$0200,$0400                ;!
    dw $FD00,$FA00,$0200,$0400                ;!
    dw $FE00,$FC00,$0300,$0600                ;!
    dw $FE00,$FC00,$0300,$0600                ;!
    dw $FD00,$FA00,$FD00,$FA00                ;!
    dw $0300,$0600,$0300,$0600                ;!
                                              ;!
DATA_00D43D:                                  ;!
    dw $FF80,$FE80,$0080,$0180                ;!
    dw $FF80,$FE80,$0080,$0180                ;!
    dw $FF80,$FE80,$0080,$0180                ;!
    dw $FE80,$FE80,$0080,$0140                ;!
    dw $FF80,$FEC0,$0180,$0180                ;!
    dw $FE80,$FE80,$0080,$0100                ;!
    dw $FF80,$FF00,$0180,$0180                ;!
    dw $FE80,$FE80,$0080,$0100                ;!
    dw $FE80,$FE80,$0080,$0100                ;!
    dw $FF80,$FF00,$0180,$0180                ;!
    dw $FF80,$FF00,$0180,$0180                ;!
    dw $FC00,$FC00,$FE00,$FD00                ;!
    dw $0300,$0300,$0400,$0400                ;!
    dw $FC00,$FC00,$0080,$0080                ;!
    dw $FF80,$FF80,$0400,$0400                ;!
    dw $FF80,$0080,$FF00,$0100                ;!
    dw $FE80,$0180,$FE80,$FE80                ;!
    dw $0180,$0180,$FE80,$0280                ;!
    dw $FFC0,$FD80,$0040,$0280                ;!
    dw $FFC0,$FD80,$0040,$0280                ;!
    dw $FFC0,$FD80,$0040,$0280                ;!
    dw $FF80,$FD40,$0040,$0240                ;!
    dw $FFC0,$FDC0,$0080,$02C0                ;!
    dw $FD00,$FD00,$0040,$0200                ;!
    dw $FFC0,$FE00,$0300,$0300                ;!
    dw $FD00,$FD00,$0040,$0200                ;!
    dw $FD00,$FD00,$0040,$0200                ;!
    dw $FFC0,$FE00,$0300,$0300                ;!
    dw $FFC0,$FE00,$0300,$0300                ;!
    dw $FD00,$FD00,$FD00,$FD00                ;!
    dw $0300,$0300,$0300,$0300                ;!
                                              ;!
DATA_00D535:                                  ;!
    db $EC,$14,$DC,$24,$DC,$24,$D0,$30        ;!
    db $EC,$14,$DC,$24,$DC,$24,$D0,$30        ;!
    db $EC,$14,$DC,$24,$DC,$24,$D0,$30        ;!
    db $E8,$12,$DC,$20,$DC,$20,$D0,$2C        ;!
    db $EE,$18,$E0,$24,$E0,$24,$D4,$30        ;!
    db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28        ;!
    db $F0,$24,$E4,$24,$E4,$24,$D8,$30        ;!
    db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28        ;!
    db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28        ;!
    db $F0,$24,$E4,$24,$E4,$24,$D8,$30        ;!
    db $F0,$24,$E4,$24,$E4,$24,$D8,$30        ;!
    db $DC,$F0,$DC,$F8,$DC,$F8,$D0,$FC        ;!
    db $10,$24,$08,$24,$08,$24,$04,$30        ;!
    db $D0,$08,$D0,$08,$D0,$08,$D0,$08        ;!
    db $F8,$30,$F8,$30,$F8,$30,$F8,$30        ;!
    db $F8,$08,$F0,$10,$F4,$04,$E8,$08        ;!
    db $F0,$10,$E0,$20,$EC,$0C,$D8,$18        ;!
    db $D8,$28,$D4,$2C,$D0,$30,$D0,$D0        ;!
    db $30,$30,$E0,$20                        ;!
                                              ;!
DATA_00D5C9:                                  ;!
    db $00,$00,$00,$00,$00,$00,$00,$00        ;!
    db $00,$00,$00,$F0,$00,$10,$00,$00        ;!
    db $00,$00,$00,$00,$00,$00,$00,$E0        ;!
    db $00,$20,$00,$00,$00,$00,$00,$F0        ;!
    db $00,$F8                                ;!
else                                          ;<====================== E0 & E1 ================
DATA_00D2CD:                                  ;!
    dw $FEC0,$0140,$FEC0,$0140                ;!
    dw $FEC0,$0140,$FE20,$00F0                ;!
    dw $FF10,$01E0,$FD80,$0050                ;!
    dw $FFB0,$0280,$FD80,$0050                ;!
    dw $FD80,$0050,$FFB0,$0280                ;!
    dw $FFB0,$0280,$FB00,$FEC0                ;!
    dw $0140,$0500,$FEC0,$0140                ;!
    dw $FEC0,$0140                            ;!
                                              ;!
DATA_00D309:                                  ;!
    dw $FFD8,$0028,$FFD8,$0028                ;!
    dw $FFD8,$0028,$FFB0,$0028                ;!
    dw $FFD8,$0050,$FF60,$0028                ;!
    dw $FFD8,$00A0,$FF60,$0028                ;!
    dw $FF60,$0028,$FFD8,$00A0                ;!
    dw $FFD8,$00A0,$FD80,$FF60                ;!
    dw $00A0,$0280,$FEC0,$0140                ;!
    dw $FEC0,$0140                            ;!
                                              ;!
MarioAccel_:                                  ;!
    dw $FE20,$FE20,$01E0,$01E0                ;!
    dw $FE20,$FE20,$01E0,$01E0                ;!
    dw $FE20,$FE20,$01E0,$01E0                ;!
    dw $FE20,$FE20,$0190,$0190                ;!
    dw $FE70,$FE70,$01E0,$01E0                ;!
    dw $FE20,$FE20,$0140,$0140                ;!
    dw $FEC0,$FEC0,$01E0,$01E0                ;!
    dw $FE20,$FE20,$0140,$0140                ;!
    dw $FE20,$FE20,$0140,$0140                ;!
    dw $FEC0,$FEC0,$01E0,$01E0                ;!
    dw $FEC0,$FEC0,$01E0,$01E0                ;!
    dw $FB00,$FB00,$FC40,$FC40                ;!
    dw $03C0,$03C0,$0500,$0500                ;!
    dw $FB00,$FB00,$0780,$0780                ;!
    dw $F880,$F880,$0500,$0500                ;!
    dw $FF60,$00A0,$FEC0,$0140                ;!
    dw $FE20,$01E0,$FE20,$FE20                ;!
    dw $01E0,$01E0,$FE20,$0320                ;!
    dw $FCE0,$F9C0,$0320,$0640                ;!
    dw $FCE0,$F9C0,$0320,$0640                ;!
    dw $FCE0,$F9C0,$0320,$0640                ;!
    dw $FC90,$F920,$02D0,$05A0                ;!
    dw $FDC0,$F920,$0370,$06E0                ;!
    dw $FC40,$F880,$0280,$0500                ;!
    dw $FD80,$FB00,$03C0,$0780                ;!
    dw $FC40,$F880,$0280,$0500                ;!
    dw $FC40,$F880,$0280,$0500                ;!
    dw $FD80,$FB00,$03C0,$0780                ;!
    dw $FD80,$FB00,$03C0,$0780                ;!
    dw $FC40,$F880,$FC40,$F880                ;!
    dw $03C0,$0780,$03C0,$0780                ;!
                                              ;!
DATA_00D43D:                                  ;!
    dw $FF60,$FE20,$00A0,$01E0                ;!
    dw $FF60,$FE20,$00A0,$01E0                ;!
    dw $FF60,$FE20,$00A0,$01E0                ;!
    dw $FE20,$FE20,$00A0,$0190                ;!
    dw $FF60,$FE70,$01E0,$01E0                ;!
    dw $FE20,$FE20,$00A0,$0140                ;!
    dw $FF60,$FEC0,$01E0,$01E0                ;!
    dw $FE20,$FE20,$00A0,$0140                ;!
    dw $FE20,$FE20,$00A0,$0140                ;!
    dw $FF60,$FEC0,$01E0,$01E0                ;!
    dw $FF60,$FEC0,$01E0,$01E0                ;!
    dw $FB00,$FB00,$FD80,$FC40                ;!
    dw $03C0,$03C0,$0500,$0500                ;!
    dw $FB00,$FB00,$00A0,$00A0                ;!
    dw $FF60,$FF60,$0500,$0500                ;!
    dw $FF60,$00A0,$FEC0,$0140                ;!
    dw $FE20,$01E0,$FE20,$FE20                ;!
    dw $01E0,$01E0,$FE20,$0320                ;!
    dw $FFB0,$FCE0,$0050,$0320                ;!
    dw $FFB0,$FCE0,$0050,$0320                ;!
    dw $FFB0,$FCE0,$0050,$0320                ;!
    dw $FF60,$FC90,$0050,$02D0                ;!
    dw $FFB0,$FD30,$00A0,$0370                ;!
    dw $FC40,$FC40,$0050,$0280                ;!
    dw $FFB0,$FD80,$03C0,$03C0                ;!
    dw $FC40,$FC40,$0050,$0280                ;!
    dw $FC40,$FC40,$0050,$0280                ;!
    dw $FFB0,$FD80,$03C0,$03C0                ;!
    dw $FFB0,$FD80,$03C0,$03C0                ;!
    dw $FC40,$FC40,$FC40,$FC40                ;!
    dw $03C0,$03C0,$03C0,$03C0                ;!
                                              ;!
DATA_00D535:                                  ;!
    db $E7,$19,$D3,$2D,$D3,$2D,$C4,$3C        ;!
    db $E7,$19,$D3,$2D,$D3,$2D,$C4,$3C        ;!
    db $E7,$19,$D3,$2D,$D3,$2D,$C4,$3C        ;!
    db $E2,$16,$D3,$28,$D3,$28,$C4,$38        ;!
    db $EA,$1E,$D8,$2D,$D8,$2D,$C8,$3C        ;!
    db $D3,$14,$D3,$23,$D3,$23,$C4,$34        ;!
    db $EC,$2D,$DD,$2D,$DD,$2D,$CC,$3C        ;!
    db $D3,$14,$D3,$23,$D3,$23,$C4,$34        ;!
    db $D3,$14,$D3,$23,$D3,$23,$C4,$34        ;!
    db $EC,$2D,$DD,$2D,$DD,$2D,$CC,$3C        ;!
    db $EC,$2D,$DD,$2D,$DD,$2D,$CC,$3C        ;!
    db $D3,$EC,$D3,$F6,$D3,$F6,$C4,$FC        ;!
    db $14,$2D,$0A,$2D,$0A,$2D,$05,$3C        ;!
    db $C4,$0A,$C4,$0A,$C4,$0A,$C4,$0A        ;!
    db $F6,$3C,$F6,$3C,$F6,$3C,$F6,$3C        ;!
    db $F6,$0A,$EC,$14,$F1,$05,$E2,$0A        ;!
    db $EC,$14,$D8,$28,$E7,$0F,$CE,$1E        ;!
    db $CE,$32,$C9,$37,$C4,$3C,$C4,$C4        ;!
    db $3C,$3C,$D8,$28                        ;!
                                              ;!
DATA_00D5C9:                                  ;!
    db $00,$00,$00,$00,$00,$00,$00,$00        ;!
    db $00,$00,$00,$EC,$00,$14,$00,$00        ;!
    db $00,$00,$00,$00,$00,$00,$00,$D8        ;!
    db $00,$28,$00,$00,$00,$00,$00,$EC        ;!
    db $00,$F6                                ;!
endif                                         ;/===============================================

if ver_is_lores(!_VER)                        ;\================= J, U, SS, & E0 ==============
DATA_00D5EB:                                  ;!
    db $FF,$FF,$02                            ;!
else                                          ;<======================= E1 ====================
DATA_00D5EB:                                  ;!
    db $FF,$FF,$03                            ;!
endif                                         ;/===============================================

DATA_00D5EE:
    db $68,$70

DATA_00D5F0:
    db $1C,$0C

CODE_00D5F2:
; Mario's jump speeds. Indexed by his X speed (divided by 8).
; First byte in each row is a normal jump, second is a spinjump.
; Decelerations for Mario when not giving any inputs or at max speed.
; First two are standard speeds (right, left). The latter ones are when on slopes (in the order of $13E1).
; For slopes, the two values are different.
; One value is when moving faster than the slope's autoslide speed (so slow down).
; The other is when moving slower than that (so speed up).
; ("autoslide speed" refers to the values in $00D5C9)
; Decelerations for Mario when not giving any inputs or at max speed, in slippery levels.
; Same order as above.
; Accelerations for Mario. Walk/run, for left then right.
; 00 - Flat (and water)
; 08 - Gradual left
; 10 - Gradual right
; 18 - Normal left
; 20 - Normal right
; 28 - Steep left
; 30 - Steep right
; 38 - Conveyor left, up
; 40 - Conveyor left, down
; 48 - Conveyor right, up
; 50 - Conveyor right, down
; 58 - Very steep left
; 60 - Very steep right
; 68 - Flying left (right = > + B)
; 70 - Flying right (left = < + B)
; 78 - Sliding - Gradual
; 7C - Sliding - Normal
; 80 - Sliding - Steep
; 84 - Sliding - Conveyor left
; 88 - Sliding - Conveyor right
; 8C - Sliding - Very steep
; 90 - Decelerating - Flat
; 98 - Decelerating - Gradual left
; A0 - Decelerating - Gradual right
; A8 - Decelerating - Normal left
; B0 - Decelerating - Normal right
; B8 - Decelerating - Steep left
; C0 - Decelerating - Steep right
; C8 - Decelerating - Conveyor left, up
; D0 - Decelerating - Conveyor left, down
; D8 - Decelerating - Conveyor right, up
; E0 - Decelerating - Conveyor right, down
; E8 - Decelerating - Very steep left
; F0 - Decelerating - Very steep right
; Accerations in slippery levels while on the ground. Same order as above.
; 00 - Flat (and water)
; 08 - Gradual left
; 10 - Gradual right
; 18 - Normal left
; 20 - Normal right
; 28 - Steep left
; 30 - Steep right
; 38 - Conveyor left, up
; 40 - Conveyor left, down
; 48 - Conveyor right, up
; 50 - Conveyor right, down
; 58 - Very steep left
; 60 - Very steep right
; 68 - Unused (would be flying, but you're in air...)
; 70 - Unused (would be flying, but you're in air...)
; 78 - Sliding - Gradual
; 7C - Sliding - Normal
; 80 - Sliding - Steep
; 84 - Sliding - Conveyor left
; 88 - Sliding - Conveyor right
; 8C - Sliding - Very steep
; 90 - Decelerating - Flat
; 98 - Decelerating - Gradual left
; A0 - Decelerating - Gradual right
; A8 - Decelerating - Normal left
; B0 - Decelerating - Normal right
; B8 - Decelerating - Steep left
; C0 - Decelerating - Steep right
; C8 - Decelerating - Conveyor left, up
; D0 - Decelerating - Conveyor left, down
; D8 - Decelerating - Conveyor right, up
; E0 - Decelerating - Conveyor right, down
; E8 - Decelerating - Very steep left
; F0 - Decelerating - Very steep right
; Side note about the below table:
; "Fast run" is used when Mario is moving faster than #$23 (the value at $00D723) and either on the ground or being shot out of a pipe.
; Maximum Mario X speeds. Each set is left/right in the order walk, run, fast run, sprint.
; 00 - Flat
; 08 - Gradual left
; 10 - Gradual right
; 18 - Normal left
; 20 - Normal right
; 28 - Steep left
; 30 - Steep right
; 38 - Conveyor left, up
; 40 - Conveyor left, down
; 48 - Conveyor right, up
; 50 - Conveyor right, down
; 58 - Very steep left
; 60 - Very steep right
; 68 - Flying left (right = > + B) - first set is no X/Y, second is with X/Y, rest unused
; 70 - Flying right (left = < + B) - first set is no X/Y, second is with X/Y, rest unused
; 78 - Water (ground, swimming, tide ground, tide swimming)
; 80 - Water with item (ground, swimming, tide ground, tide swimming)
; 88 - Sliding on each slope. In the same order as 08-60.
; How fast Mario autoslides on various slope tiles, when not holding any buttons.
; Flat
; Gradual
; Normal
; Steep
; Conveyor left
; Conveyor right
; Very steep
; Unused (?)
; Tides (swimming, on ground)
; P-meter increment/decrement values.
; 00 = no X/Y, 01 = X/Y, 02 = X/Y and faster than #$23.
; Values for $13E1 when flying.
; Initial spinump fireball timers?
    LDA.B PlayerInAir                         ; Mario's jump/duck routine.
    BEQ +                                     ; Skip the routine if Mario is in the air.
    JMP CODE_00D682

  + STZ.B PlayerIsDucking
    LDA.W PlayerSlopePose
    BNE +
    LDA.B byetudlrHold
    AND.B #$04                                ; If not sliding and down is pressed, make him duck and disable capespin interaction.
    BEQ +
    STA.B PlayerIsDucking
    STZ.W CapeInteracts
  + LDA.W StandOnSolidSprite
    CMP.B #$02
    BEQ CODE_00D61E
    LDA.B PlayerBlockedDir
    AND.B #$08                                ; If Mario is on the ground and A or B are pressed, branch to make him jump.
    BNE CODE_00D61E
    LDA.B byetudlrFrame
    ORA.B axlr0000Frame
    BMI CODE_00D630
CODE_00D61E:
    LDA.B PlayerIsDucking
    BEQ CODE_00D682
    LDA.B PlayerXSpeed+1
    BEQ +
    LDA.B LevelIsSlippery
    BNE +
    JSR CODE_00FE4A
  + JMP CODE_00D764

CODE_00D630:
    LDA.B PlayerXSpeed+1                      ; Mario is jumping.
    BPL +
    EOR.B #$FF
    INC A                                     ; Get jump speed index, as X = (abs(x)/8)*2
  + LSR A
    LSR A
    AND.B #$FE
    TAX
    LDA.B axlr0000Frame
    BPL CODE_00D65E                           ; Branch if normal jumping,
    LDA.W IsCarryingItem                      ; or trying to spinjump while holding an item.
    BNE CODE_00D65E
    INC A                                     ; Set spinjump flag.
    STA.W SpinJumpFlag
    LDA.B #!SFX_SPIN                          ; \ Play sound effect; SFX for spinjumping.
    STA.W SPCIO3                              ; /
    LDY.B PlayerDirection
    LDA.W DATA_00D5F0,Y                       ; Set spinjump fireball timer based on Mario's direction.
    STA.W SpinjumpFireball
    LDA.W PlayerRidingYoshi                   ; Branch if riding Yoshi.
    BNE CODE_00D682
    INX
    BRA +

CODE_00D65E:
; Normal jump.
    LDA.B #!SFX_JUMP                          ; \ Play sound effect; SFX for jumping.
    STA.W SPCIO1                              ; /
  + LDA.W DATA_00D2BD,X                       ; Get jump height using current speed (abs(x)/8)*2
    STA.B PlayerYSpeed+1
    LDA.B #$0B
    LDY.W PlayerPMeter
    CPY.B #con($70,$70,$70,$40,$68)           ; Check if Mario has a full P-meter.
    BCC CODE_00D67D
    LDA.W TakeoffTimer                        ; Don't reset the takeoff timer if it's already set.
    BNE +
    LDA.B #$50                                ; Set the takeoff timer.
    STA.W TakeoffTimer
  + LDA.B #$0C
CODE_00D67D:
    STA.B PlayerInAir
    STZ.W PlayerSlopePose
CODE_00D682:
    LDA.W PlayerSlopePose
    BMI CODE_00D692
    LDA.B byetudlrHold
    AND.B #$03
    BNE CODE_00D6B1
CODE_00D68D:
    LDA.W PlayerSlopePose
    BEQ +
CODE_00D692:
    JSR CODE_00FE4A
    LDA.W CurrentSlope
    BEQ +
    JSR CODE_00D968
    LDA.W SlopeType
    LSR A
    LSR A
    TAY
    ADC.B #$76
    TAX                                       ; Get a speed table indices based on the type of slope Mario is sliding on.
    TYA
    LSR A
    ADC.B #$87
    TAY
    JMP CODE_00D742

  + JMP CODE_00D764

CODE_00D6B1:
    STZ.W PlayerSlopePose
    AND.B #$01
    LDY.W FlightPhase
    BEQ CODE_00D6D5
    CMP.B PlayerDirection
    BEQ CODE_00D6C3
    LDY.B byetudlrFrame
    BPL CODE_00D68D
CODE_00D6C3:
    LDX.B PlayerDirection
    LDY.W DATA_00D5EE,X
    STY.W SlopeType
    STA.B _1
    ASL A
    ASL A
    ORA.W SlopeType
    TAX
    BRA CODE_00D713

CODE_00D6D5:
    LDY.B PlayerDirection
    CMP.B PlayerDirection
    BEQ CODE_00D6EC
    LDY.W IsCarryingItem
    BEQ CODE_00D6EA
    LDY.W FaceScreenTimer
    BNE CODE_00D6EC
    LDY.B #$08
    STY.W FaceScreenTimer
CODE_00D6EA:
    STA.B PlayerDirection
CODE_00D6EC:
    STA.B _1
    ASL A
    ASL A                                     ; Start with an X index based on the slope value and Mario's direction.
    ORA.W SlopeType
    TAX
    LDA.B PlayerXSpeed+1
    BEQ CODE_00D713                           ; Branch if:
    EOR.W MarioAccel_+1,X                     ; Stationary
    BPL CODE_00D713                           ; Moving in the direction Mario is facing
    LDA.W SkidTurnTimer                       ; Sliding from a very steep slope
    BNE CODE_00D713
    LDA.B LevelIsSlippery
    BNE +
    LDA.B #$0D                                ; If not in a slippery level, show Mario's turn pose and generate dust.
    STA.W PlayerTurningPose
    JSR CODE_00FE4A
  + TXA
    CLC                                       ; Increase X index by 90.
    ADC.B #$90
    TAX
CODE_00D713:
    LDY.B #$00
    BIT.B byetudlrHold                        ; If X/Y is not held, Y is #$00.
    BVC CODE_00D737
    INX
    INX
    INY
    LDA.B PlayerXSpeed+1
    BPL +
    EOR.B #$FF                                ; If Mario is moving slower than #$23, Y is #$01.
    INC A
  + CMP.B #con($23,$23,$23,$2C,$2C)           ; X speed at which Mario's P-meter starts increasing.
    BMI CODE_00D737
    LDA.B PlayerInAir
    BNE CODE_00D732
    LDA.B #$10
    STA.W RunTakeoffTimer
    BRA CODE_00D736                           ; If Mario is on the ground or being shot out of a pipe, Y is #$02.

CODE_00D732:
    CMP.B #$0C
    BNE CODE_00D737
CODE_00D736:
    INY
CODE_00D737:
    JSR CODE_00D96A                           ; Handle P-meter. If at max P-meter and Y is already #$02, increase Y to #$03.
    TYA
    ASL A
    ORA.W SlopeType                           ; Add slope values and Mario's direction to Y.
    ORA.B _1
    TAY
CODE_00D742:
    LDA.B PlayerXSpeed+1
    SEC
    SBC.W DATA_00D535,Y                       ; Branch if Mario is at the maximum X speed for the slope he's on.
    BEQ CODE_00D76B
    EOR.W DATA_00D535,Y
    BPL CODE_00D76B
    REP #$20                                  ; A->16
    LDA.W MarioAccel_,X
    LDY.B LevelIsSlippery
    BEQ +
    LDY.B PlayerInAir
    BNE +                                     ; Increase Mario's speed, accounting for slipperyness.
    LDA.W DATA_00D43D,X
  + CLC
    ADC.B PlayerXSpeed
    BRA CODE_00D7A0

CODE_00D764:
    JSR CODE_00D968
    LDA.B PlayerInAir
    BNE Return00D7A4
CODE_00D76B:
    LDA.W SlopeType
    LSR A
    TAY
    LSR A
    TAX
CODE_00D772:
    LDA.B PlayerXSpeed+1
    SEC
    SBC.W DATA_00D5C9+1,X
    BPL +
    INY
    INY
  + LDA.W EndLevelTimer
    ORA.B PlayerInAir
    REP #$20                                  ; A->16; Decelerate Mario.
    BNE CODE_00D78C
    LDA.W DATA_00D309,Y
    BIT.B LevelIsWater                        ; If in a slippery level, use a different set of deceleration values.
    BMI +
CODE_00D78C:
    LDA.W DATA_00D2CD,Y
  + CLC
    ADC.B PlayerXSpeed
    STA.B PlayerXSpeed
    SEC
    SBC.W DATA_00D5C9,X
    EOR.W DATA_00D2CD,Y                       ; Add slope auto-acceleration.
    BMI +
    LDA.W DATA_00D5C9,X
CODE_00D7A0:
    STA.B PlayerXSpeed
  + SEP #$20                                  ; A->8
Return00D7A4:
    RTS


if ver_is_ntsc(!_VER)                         ;\==================== J, U, & SS ===============
DATA_00D7A5:                                  ;!
    db $06,$03,$04,$10,$F4,$01,$03,$04        ;!
    db $05,$06                                ;!
                                              ;!
DATA_00D7AF:                                  ;!
    db $40,$40,$20,$40,$40,$40,$40,$40        ;!
    db $40,$40                                ;!
                                              ;!
DATA_00D7B9:                                  ;!
    db $10,$C8,$E0,$02,$03,$03,$04,$03        ;!
    db $02,$00,$01,$00,$00,$00,$00            ;!
                                              ;!
DATA_00D7C8:                                  ;!
    db $01,$10,$30,$30,$38,$38,$40            ;!
else                                          ;<===================== E0 & E1 =================
DATA_00D7A5:                                  ;!
    dw $06E6,$0373,$0499,$1266                ;!
    dw $F220,$0126,$0373,$0499                ;!
    dw $05C0,$06E6                            ;!
                                              ;!
DATA_00D7AF:                                  ;!
    dw $4000,$4000,$2000,$4000                ;!
    dw $4000,$4000,$4000,$4000                ;!
    dw $4000,$4000                            ;!
                                              ;!
DATA_00D7B9:                                  ;!
    db $10,$C8,$E0,$02,$03,$03,$04,$03        ;!
    db $02,$00,$01,$00,$00,$00,$00            ;!
                                              ;!
DATA_00D7C8:                                  ;!
    dw $0001,$0010,$0030,$0030                ;!
    dw $0038,$0038                            ;!
    db $40                                    ;!
endif                                         ;/===============================================

CapeSpeed:
    db $FF,$01,$01,$FF,$FF

DATA_00D7D4:
    db $01,$06,$03,$01,$00

DATA_00D7D9:
    db $00,$00,$00,$F8,$F8,$F8,$F4,$F0
    db $C8,$02,$01

CODE_00D7E4:
; Gravity (vertical acceleration).
; 00 = no B, 01 = with B, 02 = with Yoshi wings
; 03 = unused, 04 = air catch
; 05-09 = cape dives/rises
; Max falling speeds. Note: the actual max is this + gravity.
; 00 = no B, 01 = with B, 02 = with Yoshi wings
; These all seem unused.
; Special cape and boost speeds.
; 00 = hovering, 01 = takeoff boosts, 02 = Yoshi wings boosts
; Rest unused?
; Max cape diving speeds, based on phase ($1407).
; First byte unused.
; "Acceleration" dive phases for various conditions. Indicates the direction the angle is changing.
; 0 = Pulling back. 1 = Diving. 2 = No input, increase angle. 3 = No input, reduce angle. 4 = X/Y released.
; "Max" dive phases for various conditions.
; Same order as above.
; These values determine the size of the air catch for each dive phase, as the rise's Y speed cap.
; As it happens, the max dive value (#$C8) is also used to indicate whether Mario should change flight phases quickly.
; Based on Y speed divided by 8.
    LDY.W FlightPhase                         ; Flight routine.
    BNE CODE_00D824
    LDA.B PlayerInAir
    BEQ CODE_00D811
    LDA.W IsCarryingItem
    ORA.W PlayerRidingYoshi
    ORA.W SpinJumpFlag
    BNE CODE_00D811
    LDA.W PlayerSlopePose
    BMI CODE_00D7FF
    BNE CODE_00D811
CODE_00D7FF:
    STZ.W PlayerSlopePose
    LDX.B Powerup
    CPX.B #$02
    BNE CODE_00D811                           ; Skip down if:
    LDA.B PlayerYSpeed+1                      ; Mario doesn't have a cape.
    BMI CODE_00D811                           ; Mario is moving upwards.
    LDA.W TakeoffTimer                        ; Takeoff timer is set.
    BNE +
CODE_00D811:
    JMP CODE_00D8CD

  + STZ.B PlayerIsDucking                     ; Mario has cape, is falling, and his takeoff meter is set (start flight).
    LDA.B #$0B
    STA.B PlayerInAir
    STZ.W MaxStageOfFlight
    JSR CODE_00D94F
    LDX.B #$02
    BRA CODE_00D85B

CODE_00D824:
    CPY.B #$02
    BCC +
    JSR CODE_00D94F
  + LDX.W NextFlightPhase
    CPX.B #$04                                ; X = 4 if X/Y aren't held (terminating flight).
    BEQ CODE_00D856
    LDX.B #$03
    LDY.B PlayerYSpeed+1                      ; X = 3 if moving upwards.
    BMI CODE_00D856
    LDA.B byetudlrHold
    AND.B #$03                                ; Branch if L/R are being held.
    TAY
    BNE CODE_00D849
    LDA.W FlightPhase
    CMP.B #$04                                ; X = 2 if no inputs are pressed and Mario should increase in angle.
    BCS CODE_00D856                           ; X = 3 if no inputs are pressed and Mario should decrease in angle.
    DEX
    BRA CODE_00D856

CODE_00D849:
    LSR A
    LDY.B PlayerDirection
    BEQ +                                     ; X = 1 if diving.
    EOR.B #$01                                ; X = 0 if pulling back.
  + TAX
    CPX.W NextFlightPhase                     ; Branch if not rising.
    BNE CODE_00D85B
CODE_00D856:
    LDA.W CapePumpTimer                       ; Don't change dive phase if not yet time to.
    BNE CODE_00D87E
CODE_00D85B:
    BIT.B byetudlrHold
    BVS +                                     ; Force X = 4 if X/Y aren't being held.
    LDX.B #$04
  + LDA.W FlightPhase
    CMP.W DATA_00D7D4,X                       ; Branch if currently at the "max" dive phase for the conditions.
    BEQ CODE_00D87E
    CLC
    ADC.W CapeSpeed,X                         ; Adjust cape angle.
    STA.W FlightPhase
    LDA.B #$08
    LDY.W MaxStageOfFlight
    CPY.B #$C8                                ; Set time until the player advances a diving stage.
    BNE +                                     ; If the player has big air, advance four times faster.
    LDA.B #$02
  + STA.W CapePumpTimer
CODE_00D87E:
    STX.W NextFlightPhase
    LDY.W FlightPhase                         ; Branch if not flying.
    BEQ CODE_00D8CD
if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
    LDA.B PlayerYSpeed+1                      ;!
    BPL CODE_00D892                           ;!
    CMP.B #$C8                                ;!
    BCS +                                     ;!; Limit max possible cape rising speed (from big air).
    LDA.B #$C8                                ;!
    BRA +                                     ;!
                                              ;!
CODE_00D892:                                  ;!
    CMP.W DATA_00D7C8,Y                       ;!
    BCC +                                     ;!; Limit max cape dive speed.
    LDA.W DATA_00D7C8,Y                       ;!
  + PHA                                       ;!
    CPY.B #$01                                ;!
    BNE CODE_00D8C6                           ;!
    LDX.W MaxStageOfFlight                    ;!; Branch if no longer air catching.
    BEQ CODE_00D8C4                           ;!
    LDA.B PlayerYSpeed+1                      ;!; Branch if moving upwards.
    BMI CODE_00D8AF                           ;!
    LDA.B #!SFX_CAPE                          ;! \ Play sound effect; SFX for smashing the ground.
    STA.W SPCIO0                              ;! /
    BRA +                                     ;!
                                              ;!
CODE_00D8AF:                                  ;!
    CMP.W MaxStageOfFlight                    ;!
    BCS +                                     ;!; If Mario has reached the max rise speed for this stage, end the catch.
    STX.B PlayerYSpeed+1                      ;!
    STZ.W MaxStageOfFlight                    ;!
  + LDX.B PlayerDirection                     ;!
    LDA.B PlayerXSpeed+1                      ;!
    BEQ CODE_00D8C4                           ;!
    EOR.W DATA_00D535,X                       ;!
    BPL CODE_00D8C6                           ;!
CODE_00D8C4:                                  ;!
    LDY.B #$02                                ;!
CODE_00D8C6:                                  ;!
    PLA                                       ;!
    INY                                       ;!
    INY                                       ;!
    INY                                       ;!
else                                          ;<===================== E0 & E1 =================
    PHY                                       ;!
    TYA                                       ;!
    ASL A                                     ;!
    TAY                                       ;!
    REP #$20                                  ;! A->16
    LDA.B PlayerYSpeed                        ;!
    BPL CODE_00D892                           ;!
    CMP.W #$00C8                              ;!
    BCS +                                     ;!
    LDA.W #$00C8                              ;!
    BRA +                                     ;!
                                              ;!
CODE_00D892:                                  ;!
    CMP.W DATA_00D7C8-1,Y                     ;!
    BCC +                                     ;!
    LDA.W DATA_00D7C8-1,Y                     ;!
  + PLY                                       ;!
    PHA                                       ;!
    SEP #$20                                  ;! A->8
    CPY.B #$01                                ;!
    BNE CODE_00D8C6                           ;!
    LDX.W MaxStageOfFlight                    ;!
    BEQ CODE_00D8C4                           ;!
    LDA.B PlayerYSpeed+1                      ;!
    BMI CODE_00D8AF                           ;!
    LDA.B #!SFX_CAPE                          ;!
    STA.W SPCIO0                              ;!
    BRA +                                     ;!
                                              ;!
CODE_00D8AF:                                  ;!
    CMP.W MaxStageOfFlight                    ;!
    BCS +                                     ;!
    STX.B PlayerYSpeed+1                      ;!
    STZ.W MaxStageOfFlight                    ;!
  + LDX.B PlayerDirection                     ;!
    LDA.B PlayerXSpeed+1                      ;!
    BEQ CODE_00D8C4                           ;!
    EOR.W DATA_00D535,X                       ;!
    BPL CODE_00D8C6                           ;!
CODE_00D8C4:                                  ;!
    LDY.B #$02                                ;!
CODE_00D8C6:                                  ;!
    INY                                       ;!
    INY                                       ;!
    INY                                       ;!
    TYA                                       ;!
    ASL A                                     ;!
    TAY                                       ;!
    REP #$20                                  ;! A->16
    PLA                                       ;!
endif                                         ;/===============================================
    JMP CODE_00D948

CODE_00D8CD:
; Handle Yoshi flight.
    LDA.B PlayerInAir                         ; \ Branch if not flying; If on the ground, skip all this.
    BEQ CODE_00D928                           ; /
    LDX.B #$00                                ; X = #$00
    LDA.W PlayerRidingYoshi                   ; \ Branch if not on Yoshi
    BEQ CODE_00D8E7                           ; /
    LDA.W YoshiHasWingsEvt                    ; \ Branch if not winged Yoshi; If not riding a Yoshi with wings, branch.
    LSR A                                     ; |
    BEQ CODE_00D8E7                           ; /
    LDY.B #$02                                ; \ Branch if not Caped Mario
    CPY.B Powerup                             ; |; If Mario has cape, allow continuous flight by holding B.
    BEQ +                                     ; /
    INX                                       ; X= #$01
  + BRA CODE_00D8FF

CODE_00D8E7:
    LDA.B Powerup                             ; \ Branch if not Caped Mario; Handle hovering/takeoff with the cape.
    CMP.B #$02                                ; |; Skip down if Mario doesn't have a cape.
    BNE CODE_00D928                           ; /
    LDA.B PlayerInAir                         ; \ Branch if $72 != 0C
    CMP.B #$0C                                ; |
    BNE CODE_00D8FD                           ; /
    LDY.B #$01
    CPY.W TakeoffTimer                        ; Handle the extra boosts from a filled takeoff meter.
    BCC CODE_00D8FF
    INC.W TakeoffTimer
CODE_00D8FD:
    LDY.B #$00
CODE_00D8FF:
    LDA.W CapeFloatTimer
    BNE CODE_00D90D                           ; Set the initial hover timer if applicable.
    LDA.B byetudlrHold,X                      ; Depending on whether Mario is on a winged Yoshi with a cape or not,
    BPL CODE_00D924                           ; decide whether to hover based on first-frame A/B or held A/B.
    LDA.B #$10
    STA.W CapeFloatTimer
CODE_00D90D:
    LDA.B PlayerYSpeed+1
    BPL CODE_00D91B
    LDX.W DATA_00D7B9,Y
    BPL CODE_00D924
    CMP.W DATA_00D7B9,Y
    BCC CODE_00D924                           ; Limit maximum hovering/takeoff Y speed and return if at it.
CODE_00D91B:
    LDA.W DATA_00D7B9,Y
    CMP.B PlayerYSpeed+1
    BEQ CODE_00D94C
    BMI CODE_00D94C
CODE_00D924:
    CPY.B #$02
    BEQ +
CODE_00D928:
    LDY.B #$01
    LDA.B byetudlrHold
    BMI +
CODE_00D92E:
    LDY.B #$00
if ver_is_ntsc(!_VER)                         ;\================== J, U, & SS =================
  + LDA.B PlayerYSpeed+1                      ;! \ If Mario's Y speed is negative (up),
    BMI CODE_00D948                           ;! / branch to $D948; If Mario starts falling faster than his maximum downwards speed,
    CMP.W DATA_00D7AF,Y                       ;!; reset it back to the maximum downwards speed.
    BCC +                                     ;!
    LDA.W DATA_00D7AF,Y                       ;!
  + LDX.B PlayerInAir                         ;!
    BEQ CODE_00D948                           ;!
    CPX.B #$0B                                ;!; If Mario was previously jumping upwards, mark him as falling.
    BNE CODE_00D948                           ;!
    LDX.B #$24                                ;!
    STX.B PlayerInAir                         ;!
CODE_00D948:                                  ;!
    CLC                                       ;!; Add gravity to Mario's fall speed.
    ADC.W DATA_00D7A5,Y                       ;!
else                                          ;<==================== E0 & E1 ==================
  + TYA                                       ;!
    ASL A                                     ;!
    TAY                                       ;!
    REP #$20                                  ;! A->16
    LDA.B PlayerYSpeed                        ;!
    BMI CODE_00D948                           ;!
    CMP.W DATA_00D7AF,Y                       ;!
    BCC +                                     ;!
    LDA.W DATA_00D7AF,Y                       ;!
  + LDX.B PlayerInAir                         ;!
    BEQ CODE_00D948                           ;!
    CPX.B #$0B                                ;!
    BNE CODE_00D948                           ;!
    LDX.B #$24                                ;!
    STX.B PlayerInAir                         ;!
CODE_00D948:                                  ;!
    CLC                                       ;!
    ADC.W DATA_00D7A5,Y                       ;!
    SEP #$20                                  ;! A->8
    STA.B PlayerYSpeed                        ;!
    XBA                                       ;!
endif                                         ;/=============================================== 
CODE_00D94C:
    STA.B PlayerYSpeed+1
    RTS

CODE_00D94F:
    STZ.W Empty_140A
    LDA.B PlayerYSpeed+1
    BPL +
    LDA.B #$00
  + LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_00D7D9,Y
    CMP.W MaxStageOfFlight                    ; Store the aircatch's speed.
    BPL +
    STA.W MaxStageOfFlight
  + RTS

CODE_00D968:
    LDY.B #$00
CODE_00D96A:
    LDA.W PlayerPMeter
    CLC
    ADC.W DATA_00D5EB,Y
    BPL +
    LDA.B #$00
  + CMP.B #con($70,$70,$70,$40,$68)           ; Handle the P-meter. If zero, reset; if non-zero, decrease; if greater than #$70, reset to #$70.
    BCC +
    INY
    LDA.B #con($70,$70,$70,$40,$68)
  + STA.W PlayerPMeter
    RTS


DATA_00D980:
    db $16,$1A,$1A,$18

DATA_00D984:
    db $E8,$F8,$D0,$D0

CODE_00D988:
; Maximum upwards swim speeds, indexed by up/down inputs.
; 0 = no input, 1 = down held, 2 = up held, 3 = both held
    STZ.W PlayerSlopePose                     ; Mario's swimming routine.
    STZ.B PlayerIsDucking
    STZ.W FlightPhase
    STZ.W SpinJumpFlag
    LDY.B PlayerYSpeed+1
    LDA.W IsCarryingItem                      ; Branch if not holding an item.
    BEQ CODE_00D9EB
    LDA.B PlayerInAir
    BNE CODE_00D9AF
    LDA.B byetudlrFrame
    ORA.B axlr0000Frame
    BPL CODE_00D9AF
    LDA.B #$0B
    STA.B PlayerInAir
    STZ.W PlayerSlopePose
    LDY.B #$F0
    BRA CODE_00D9B5

CODE_00D9AF:
    LDA.B byetudlrHold
    AND.B #$04
    BEQ +
CODE_00D9B5:
    JSR CODE_00DAA9
    TYA
    CLC
    ADC.B #$08
    TAY
  + INY
    LDA.W PlayerCanJumpWater
    BNE +
    DEY
    LDA.B EffFrame
    AND.B #$03
    BNE +
    DEY
    DEY
  + TYA
    BMI CODE_00D9D7
    CMP.B #$10
    BCC +                                     ; Maximum downwards Y speed in water while carrying an item.
    LDA.B #$10
    BRA +

CODE_00D9D7:
    CMP.B #$F0
    BCS +                                     ; Maximum upwards Y speed in water while carrying an item.
    LDA.B #$F0
  + STA.B PlayerYSpeed+1
    LDY.B #$80                                ; Base index to Mario's X speeds for water when holding an item.
    LDA.B byetudlrHold
    AND.B #$03
    BNE CODE_00DA48
    LDA.B PlayerDirection
    BRA CODE_00DA46

CODE_00D9EB:
    LDA.B byetudlrFrame                       ; Mario is not holding an item.
    ORA.B axlr0000Frame                       ; Branch if:
    BPL CODE_00DA0B                           ; A/B not pressed
    LDA.W PlayerCanJumpWater                  ; Mario is at the surface of the water.
    BNE CODE_00DA0B
    JSR CODE_00DAA9
    LDA.B PlayerInAir
    BNE +
    LDA.B #$0B                                ; Handle Mario "jumping" off the ground in water.
    STA.B PlayerInAir
    STZ.W PlayerSlopePose
    LDY.B #$F0                                ; Base Y speed to give Mario when swimming off the ground.
  + TYA
    SEC
    SBC.B #$20                                ; Boost Y speed that A/B gives Mario.
    TAY
CODE_00DA0B:
    LDA.B EffFrame
    AND.B #$03
    BNE +                                     ; Apply "gravity" in water; every 4 frames add 2 to Y.
    INY
    INY
  + LDA.B byetudlrHold
    AND.B #$0C
    LSR A                                     ; Track whether up or down are being held.
    LSR A
    TAX
    TYA
    BMI CODE_00DA25
    CMP.B #$40
    BCC +                                     ; Maximum falling speeds while swimming.
    LDA.B #$40
    BRA +

CODE_00DA25:
    CMP.W DATA_00D984,X
    BCS +                                     ; Restrict maximum rising speeds while swimming, based on whether up/down are held.
    LDA.W DATA_00D984,X
  + STA.B PlayerYSpeed+1
    LDA.B PlayerInAir
    BNE CODE_00DA40
    LDA.B byetudlrHold
    AND.B #$04
    BEQ CODE_00DA40
    STZ.W CapeInteracts
    INC.B PlayerIsDucking
    BRA CODE_00DA69

CODE_00DA40:
    LDA.B byetudlrHold
    AND.B #$03
    BEQ CODE_00DA69
CODE_00DA46:
    LDY.B #$78                                ; Base index to Mario's X speeds for water when not holding an item.
CODE_00DA48:
    STY.B _0
    AND.B #$01
    STA.B PlayerDirection                     ; Modify speed index based on direction...
    PHA
    ASL A
    ASL A
    TAX
    PLA
    ORA.B _0
    LDY.W Layer3TideSetting                   ; ...whether Mario is in a level with tides...
    BEQ +
    CLC
    ADC.B #$04
  + TAY
    LDA.B PlayerInAir                         ; ... or if he's on the ground vs. floating.
    BEQ +
    INY
    INY
  + JSR CODE_00D742                           ; Handle Mario's max X speed and acceleration.
    BRA CODE_00DA7C

CODE_00DA69:
    LDY.B #$00
    TYX
    LDA.W Layer3TideSetting
    BEQ +
    LDX.B #$1E
    LDA.B PlayerInAir
    BNE +
    INX
    INX
  + JSR CODE_00D772
CODE_00DA7C:
    JSR CODE_00D062
    JSL CODE_00CEB1                           ; Animate Mario (and his cape).
    LDA.W CapeSpinTimer
    BNE Return00DA8C
    LDA.B PlayerInAir
    BNE +
Return00DA8C:
    RTS

  + LDA.B #$18
    LDY.W ShootFireTimer
    BNE +
    LDA.W PlayerAniTimer
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W DATA_00D980,Y
  + LDY.W IsCarryingItem
    BEQ +
    INC A
  + STA.W PlayerPose
    RTS

CODE_00DAA9:
    LDA.B #!SFX_SWIM                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.W PlayerAniTimer
    ORA.B #$10
    STA.W PlayerAniTimer
    RTS


DATA_00DAB7:
    db $10,$08,$F0,$F8

DATA_00DABB:
    db $B0,$F0

DATA_00DABD:
    db $00,$01,$00,$01,$01,$01,$01,$01
    db $01,$01,$01,$01,$01,$01,$01,$01
DATA_00DACD:
    db $22,$15,$22,$15,$21,$1F,$20,$20
    db $20,$20,$1F,$21,$1F,$21

ClimbingImgs:
    db $15,$22

ClimbPunchingImgs:
    db $1E,$23

DATA_00DADF:
    db $10,$0F,$0E,$0D,$0C,$0B,$0A,$09
    db $08,$07,$06,$05,$05,$05,$05,$05
    db $05,$05

DATA_00DAF1:
    db $20,$01,$40,$01,$2A,$01,$2A,$01
    db $30,$01,$33,$01,$32,$01,$34,$01
    db $36,$01,$38,$01,$3A,$01,$3B,$01
    db $45,$01,$45,$01,$45,$01,$45,$01
    db $45,$01,$45,$01,$08,$F8

CODE_00DB17:
; Climbing X/Y speeds.
; Every second byte is, oddly, used when climbing in water.
; Y speeds to give when jumping off a vine/net.
; Second byte is when in water.
; Frames to use for Mario's net punch animation.
    STZ.B PlayerInAir                         ; Routine to handle punching/turning a net door while Mario is climbing on a net
    STZ.B PlayerYSpeed+1
    STZ.W PlayerCapePose
    STZ.W SpinJumpFlag
    LDY.W NetDoorTimer                        ; Branch if not already in the net door turn animation.
    BEQ CODE_00DB7D
    LDA.W NetDoorPlayerXOffset
    BPL +
    EOR.B #$FF
    INC A
  + TAX
    CPY.B #$1E
    BCC CODE_00DB45
    LDA.W DATA_00DADF,X
    BIT.W NetDoorPlayerXOffset
    BPL +
    EOR.B #$FF
    INC A
  + STA.B PlayerXSpeed+1
    STZ.B PlayerXSpeed
    STZ.W PlayerXPosSpx
CODE_00DB45:
    TXA
    ASL A
    TAX
    LDA.W NetDoorPlayerXOffset
    CPY.B #$08
    BCS +
    EOR.B #$80
  + ASL A
    REP #$20                                  ; A->16
    LDA.W DATA_00DAF1,X
    BCS +
    EOR.W #$FFFF
    INC A
  + CLC
    ADC.B PlayerXSpeed
    STA.B PlayerXSpeed
    SEP #$20                                  ; A->8
    TYA
    LSR A
    AND.B #$0E
    ORA.W NetDoorDirIndex
    TAY
    LDA.W DATA_00DABD,Y
    BIT.W NetDoorPlayerXOffset
    BMI +
    EOR.B #$01
  + STA.B PlayerDirection
    LDA.W DATA_00DACD,Y
    BRA CODE_00DB92

CODE_00DB7D:
; Not already on a rotating net door.
    STZ.B PlayerXSpeed+1                      ; Clear Mario's X speed.
    STZ.B PlayerXSpeed
    LDX.W PlayerBehindNet
    LDA.W PunchNetTimer                       ; Branch if not punching.
    BEQ +
    TXA
    INC A                                     ; Handle the punching animation while climbing on a net.
    INC A
    JSR CODE_00D044                           ; Process net punch interaction.
    LDA.W ClimbPunchingImgs,X
CODE_00DB92:
    STA.W PlayerPose
    RTS

  + LDY.B PlayerInWater                       ; Mario is in Water flag
    BIT.B byetudlrFrame
    BPL CODE_00DBAC
    LDA.B #$0B
    STA.B PlayerInAir
    LDA.W DATA_00DABB,Y                       ; Set Y speed for jumping off a net.
    STA.B PlayerYSpeed+1
    LDA.B #!SFX_JUMP                          ; \ Play sound effect
    STA.W SPCIO1                              ; /
    BRA CODE_00DC00

CODE_00DBAC:
    BVC +
    LDA.B PlayerIsClimbing
    BPL +
    LDA.B #!SFX_BONK                          ; \ Play sound effect; SFX played for punching a net.
    STA.W SPCIO0                              ; /
    STX.W NetDoorDirIndex
    LDA.B PlayerXPosNext                      ; Mario X
    AND.B #$08
    LSR A
    LSR A
    LSR A
    EOR.B #$01
    STA.B PlayerDirection                     ; Mario's Direction
    LDA.B #$08
    STA.W PunchNetTimer
  + LDA.W ClimbingImgs,X
    STA.W PlayerPose                          ; Store A in Mario image
    LDA.B byetudlrHold
    AND.B #$03
    BEQ CODE_00DBF2
    LSR A
    TAX
    LDA.B InteractionPtsClimbable
    AND.B #$18
    CMP.B #$18
    BEQ CODE_00DBE8
    LDA.B PlayerIsClimbing
    BPL CODE_00DC00
    CPX.B InteractionPtDirection
    BEQ CODE_00DBF2
CODE_00DBE8:
    TXA
    ASL A
    ORA.B PlayerInWater
    TAX
    LDA.W DATA_00DAB7,X                       ; Set climbing X speed.
    STA.B PlayerXSpeed+1
CODE_00DBF2:
    LDA.B byetudlrHold                        ; \
    AND.B #$0C                                ; |If up or down isn't pressed, branch to $DC16
    BEQ CODE_00DC16                           ; /
    AND.B #$08                                ; \ If up is pressed, branch to $DC03
    BNE CODE_00DC03                           ; /
    LSR.B InteractionPtsClimbable
    BCS CODE_00DC0B
CODE_00DC00:
    STZ.B PlayerIsClimbing                    ; Mario isn't climbing
    RTS

CODE_00DC03:
    INY
    INY
    LDA.B InteractionPtsClimbable
    AND.B #$02
    BEQ CODE_00DC16
CODE_00DC0B:
    LDA.B PlayerIsClimbing
    BMI +
    STZ.B PlayerXSpeed+1
  + LDA.W DATA_00DAB7,Y                       ; Set climbing Y speed.
    STA.B PlayerYSpeed+1
CODE_00DC16:
    ORA.B PlayerXSpeed+1
    BEQ +
    LDA.W PlayerAniTimer
    ORA.B #$08
    STA.W PlayerAniTimer
    AND.B #$07
    BNE +
    LDA.B PlayerDirection
    EOR.B #$01
    STA.B PlayerDirection
  + RTS

CODE_00DC2D:
    LDA.B PlayerYSpeed+1                      ; \ Store Mario's Y speed in $8A; Routine to update the player's X and Y positions based on their speed.
    STA.B TempPlayerYSpeed                    ; /
    LDA.W WallrunningType
    BEQ CODE_00DC40
    LSR A
    LDA.B PlayerXSpeed+1
    BCC +                                     ; If wall-running, temporarily convert X speed to Y speed.
    EOR.B #$FF
    INC A
  + STA.B PlayerYSpeed+1
CODE_00DC40:
    LDX.B #$00                                ; Run for X position.
    JSR CODE_00DC4F
    LDX.B #$02                                ; Run for Y position.
    JSR CODE_00DC4F
    LDA.B TempPlayerYSpeed
    STA.B PlayerYSpeed+1
    RTS

if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
CODE_00DC4F:                                  ;!
    LDA.B PlayerXSpeed+1,X                    ;!; Update Mario's position (X=0 for x, X=2 for y).
    ASL A                                     ;!
    ASL A                                     ;!
    ASL A                                     ;!
    ASL A                                     ;!
    CLC                                       ;!
    ADC.W PlayerXPosSpx,X                     ;!
    STA.W PlayerXPosSpx,X                     ;!
    REP #$20                                  ;! A->16
    PHP                                       ;!
    LDA.B PlayerXSpeed+1,X                    ;!
    LSR A                                     ;!
    LSR A                                     ;!
    LSR A                                     ;!
    LSR A                                     ;!
    AND.W #$000F                              ;!
    CMP.W #$0008                              ;!
    BCC +                                     ;!
    ORA.W #$FFF0                              ;!
  + PLP                                       ;!
    ADC.B PlayerXPosNext,X                    ;!
    STA.B PlayerXPosNext,X                    ;!
    SEP #$20                                  ;! A->8
    RTS                                       ;!
else                                          ;<====================== E0 & E1 ================
CODE_00DC4F:                                  ;!
    LDA.B PlayerXSpeed+1,X                    ;!
    BPL +                                     ;!
    EOR.B #$FF                                ;!
    INC A                                     ;!
  + STA.B _1                                  ;!
    STZ.B _0                                  ;!
    STA.W HW_WRMPYA                           ;!
    TXA                                       ;!
    BEQ +                                     ;!
    LDA.B #$28                                ;!
  + STA.W HW_WRMPYB                           ;!
    NOP                                       ;!
    REP #$20                                  ;! A->16
    LDA.B _0                                  ;!
    CLC                                       ;!
    ADC.W HW_RDMPY                            ;!
    LSR A                                     ;!
    LSR A                                     ;!
    LSR A                                     ;!
    LSR A                                     ;!
    STZ.B _2                                  ;!
    BIT.B PlayerXSpeed,X                      ;!
    BPL +                                     ;!
    DEC.B _2                                  ;!
    EOR.W #$FFFF                              ;!
    INC A                                     ;!
  + STA.B _0                                  ;!
    SEP #$20                                  ;! A->8
    CLC                                       ;!
    ADC.W PlayerXPosSpx,X                     ;!
    STA.W PlayerXPosSpx,X                     ;!
    REP #$20                                  ;! A->16
    LDA.B _1                                  ;!
    ADC.B PlayerXPosNext,X                    ;!
    STA.B PlayerXPosNext,X                    ;!
    SEP #$20                                  ;! A->8
    RTS                                       ;!
endif                                         ;/===============================================


NumWalkingFrames:
    db $01,$02,$02,$02

if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
DATA_00DC7C:                                  ;!
    db $0A,$08,$06,$04,$03,$02,$01,$01        ;!
    db $0A,$08,$06,$04,$03,$02,$01,$01        ;!
    db $0A,$08,$06,$04,$03,$02,$01,$01        ;!
    db $08,$06,$04,$03,$02,$01,$01,$01        ;!
    db $08,$06,$04,$03,$02,$01,$01,$01        ;!
    db $05,$04,$03,$02,$01,$01,$01,$01        ;!
    db $05,$04,$03,$02,$01,$01,$01,$01        ;!
    db $05,$04,$03,$02,$01,$01,$01,$01        ;!
    db $05,$04,$03,$02,$01,$01,$01,$01        ;!
    db $05,$04,$03,$02,$01,$01,$01,$01        ;!
    db $05,$04,$03,$02,$01,$01,$01,$01        ;!
    db $04,$03,$02,$01,$01,$01,$01,$01        ;!
    db $04,$03,$02,$01,$01,$01,$01,$01        ;!
    db $02,$02,$02,$02,$02,$02,$02,$02        ;!
elseif ver_is_hires(!_VER)                    ;<======================= E1 ====================
DATA_00DC7C:                                  ;!
    db $09,$08,$06,$05,$04,$03,$03,$02        ;!
    db $09,$08,$06,$05,$04,$03,$03,$02        ;!
    db $09,$08,$06,$05,$04,$03,$03,$02        ;!
    db $07,$06,$05,$04,$03,$03,$02,$01        ;!
    db $07,$06,$05,$04,$03,$03,$02,$01        ;!
    db $05,$04,$04,$03,$03,$02,$01,$01        ;!
    db $05,$04,$03,$03,$02,$02,$01,$01        ;!
    db $05,$04,$03,$03,$02,$02,$01,$01        ;!
    db $05,$04,$03,$03,$02,$02,$01,$01        ;!
    db $05,$04,$03,$03,$02,$02,$01,$01        ;!
    db $05,$04,$03,$03,$02,$02,$01,$01        ;!
    db $04,$03,$03,$02,$02,$01,$01,$01        ;!
    db $04,$03,$03,$02,$02,$01,$01,$01        ;!
    db $02,$02,$02,$02,$02,$02,$02,$02        ;!
else                                          ;<======================= E0 ====================
DATA_00DC7C:                                  ;!
    db $0A,$08,$07,$06,$05,$04,$03,$02        ;!
    db $0A,$08,$07,$06,$05,$04,$03,$02        ;!
    db $0A,$08,$07,$06,$05,$04,$03,$02        ;!
    db $08,$07,$06,$05,$04,$03,$02,$01        ;!
    db $08,$07,$06,$05,$04,$03,$02,$01        ;!
    db $05,$04,$04,$03,$03,$02,$01,$01        ;!
    db $05,$04,$03,$03,$02,$02,$01,$01        ;!
    db $05,$04,$03,$03,$02,$02,$01,$01        ;!
    db $05,$04,$03,$03,$02,$02,$01,$01        ;!
    db $05,$04,$03,$03,$02,$02,$01,$01        ;!
    db $05,$04,$03,$03,$02,$02,$01,$01        ;!
    db $04,$03,$03,$02,$02,$01,$01,$01        ;!
    db $04,$03,$03,$02,$02,$01,$01,$01        ;!
    db $02,$02,$02,$02,$02,$02,$02,$02        ;!
endif                                         ;/===============================================

DATA_00DCEC:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $02,$04,$04,$04,$0E,$08,$00,$00
    db $00,$00,$00,$00,$00,$00,$08,$08
    db $08,$08,$08,$08,$00,$00,$00,$00
    db $0C,$10,$12,$14,$16,$18,$1A,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$06,$00,$00
    db $00,$00,$00,$0A,$00,$00

DATA_00DD32:
    db $00,$08,$10,$14,$18,$1E,$24,$24
    db $28,$30,$38,$3E,$44,$4A,$50,$54
    db $58,$58,$5C,$60,$64,$68,$6C,$70
    db $74,$78,$7C,$80

DATA_00DD4E:
    db $00,$00,$00,$00,$10,$00,$10,$00
    db $00,$00,$00,$00,$F8,$FF,$F8,$FF
    db $0E,$00,$06,$00,$F2,$FF,$FA,$FF
    db $17,$00,$07,$00,$0F,$00,$EA,$FF
    db $FA,$FF,$FA,$FF,$00,$00,$00,$00
    db $00,$00,$00,$00,$10,$00,$10,$00
    db $00,$00,$00,$00,$F8,$FF,$F8,$FF
    db $00,$00,$F8,$FF,$08,$00,$00,$00
    db $08,$00,$F8,$FF,$00,$00,$00,$00
    db $F8,$FF,$00,$00,$00,$00,$10,$00
    db $02,$00,$00,$00,$FE,$FF,$00,$00
    db $00,$00,$00,$00,$FC,$FF,$05,$00
    db $04,$00,$FB,$FF,$FB,$FF,$06,$00
    db $05,$00,$FA,$FF,$F9,$FF,$09,$00
    db $07,$00,$F7,$FF,$FD,$FF,$FD,$FF
    db $03,$00,$03,$00,$FF,$FF,$07,$00
    db $01,$00,$F9,$FF,$0A,$00,$F6,$FF
    db $08,$00,$F8,$FF,$08,$00,$F8,$FF
    db $00,$00,$04,$00,$FC,$FF,$FE,$FF
    db $02,$00,$0B,$00,$F5,$FF,$14,$00
    db $EC,$FF,$0E,$00,$F3,$FF,$08,$00
    db $F8,$FF,$0C,$00,$14,$00,$FD,$FF
    db $F4,$FF,$F4,$FF,$0B,$00,$0B,$00
    db $03,$00,$13,$00,$F5,$FF,$05,$00
    db $F5,$FF,$09,$00,$01,$00,$01,$00
    db $F7,$FF,$07,$00,$07,$00,$05,$00
    db $0D,$00,$0D,$00,$FB,$FF,$FB,$FF
    db $FB,$FF,$FF,$FF,$0F,$00,$01,$00
    db $F9,$FF,$00,$00

DATA_00DE32:
    db $01,$00,$11,$00,$11,$00,$19,$00
    db $01,$00,$11,$00,$11,$00,$19,$00
    db $0C,$00,$14,$00,$0C,$00,$14,$00
    db $18,$00,$18,$00,$28,$00,$18,$00
    db $18,$00,$28,$00,$06,$00,$16,$00
    db $01,$00,$11,$00,$09,$00,$11,$00
    db $01,$00,$11,$00,$09,$00,$11,$00
    db $01,$00,$11,$00,$11,$00,$01,$00
    db $11,$00,$11,$00,$01,$00,$11,$00
    db $11,$00,$01,$00,$11,$00,$11,$00
    db $01,$00,$11,$00,$01,$00,$11,$00
    db $11,$00,$05,$00,$04,$00,$14,$00
    db $04,$00,$14,$00,$0C,$00,$14,$00
    db $0C,$00,$14,$00,$10,$00,$10,$00
    db $10,$00,$10,$00,$10,$00,$00,$00
    db $10,$00,$00,$00,$10,$00,$00,$00
    db $10,$00,$00,$00,$0B,$00,$0B,$00
    db $11,$00,$11,$00,$FF,$FF,$FF,$FF
    db $10,$00,$10,$00,$10,$00,$10,$00
    db $10,$00,$10,$00,$10,$00,$15,$00
    db $15,$00,$25,$00,$25,$00,$04,$00
    db $04,$00,$04,$00,$14,$00,$14,$00
    db $04,$00,$14,$00,$14,$00,$04,$00
    db $04,$00,$14,$00,$04,$00,$04,$00
    db $14,$00,$00,$00,$08,$00,$00,$00
    db $00,$00,$08,$00,$00,$00,$00,$00
    db $10,$00,$18,$00,$00,$00,$10,$00
    db $18,$00,$00,$00,$10,$00,$00,$00
    db $10,$00,$F8,$FF

TilesetIndex:
    db $00,$46,$83,$46

TileExpansion_:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$28,$00,$00,$00,$00
    db $00,$00,$04,$04,$04,$00,$00,$00
    db $00,$00,$08,$00,$00,$00,$00,$0C
    db $0C,$0C,$00,$00,$10,$10,$14,$14
    db $18,$18,$00,$00,$1C,$00,$00,$00
    db $00,$20,$00,$00,$00,$00,$24,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$04
    db $04,$04,$00,$00,$00,$00,$00,$08
    db $00,$00,$00,$00,$0C,$0C,$0C,$00
    db $00,$10,$10,$14,$14,$18,$18,$00
    db $00,$1C,$00,$00,$00,$00,$20,$00
    db $00,$00,$00,$24,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
Mario8x8Tiles:
    db $00,$02,$80,$80,$00,$02,$0C,$80
    db $00,$02,$1A,$1B,$00,$02,$0D,$80
    db $00,$02,$22,$23,$00,$02,$32,$33
    db $00,$02,$0A,$0B,$00,$02,$30,$31
    db $00,$02,$20,$21,$00,$02,$7E,$80
    db $00,$02,$02,$80,$04,$7F,$4A,$5B
    db $4B,$5A

DATA_00E00C:
    db $50,$50,$50,$09,$50,$50,$50,$50
    db $50,$50,$09,$2B,$50,$2D,$50,$D5
    db $2E,$C4,$C4,$C4,$D6,$B6,$50,$50
    db $50,$50,$50,$50,$50,$C5,$D7,$2A
    db $E0,$50,$D5,$29,$2C,$B6,$D6,$28
    db $E0,$E0,$C5,$C5,$C5,$C5,$C5,$C5
    db $5C,$5C,$50,$5A,$B6,$50,$28,$28
    db $C5,$D7,$28,$70,$C5,$70,$1C,$93
    db $C5,$C5,$0B,$85,$90,$84,$70,$70
    db $70,$A0,$70,$70,$70,$70,$70,$70
    db $A0,$74,$70,$80,$70,$84,$17,$A4
    db $A4,$A4,$B3,$B0,$70,$70,$70,$70
    db $70,$70,$70,$E2,$72,$0F,$61,$70
    db $63,$82,$C7,$90,$B3,$D4,$A5,$C0
    db $08,$54,$0C,$0E,$1B,$51,$49,$4A
    db $48,$4B,$4C,$5D,$5E,$5F,$E3,$90
    db $5F,$5F,$C5,$70,$70,$70,$A0,$70
    db $70,$70,$70,$70,$70,$A0,$74,$70
    db $80,$70,$84,$17,$A4,$A4,$A4,$B3
    db $B0,$70,$70,$70,$70,$70,$70,$70
    db $E2,$72,$0F,$61,$70,$63,$82,$C7
    db $90,$B3,$D4,$A5,$C0,$08,$64,$0C
    db $0E,$1B,$51,$49,$4A,$48,$4B,$4C
    db $5D,$5E,$5F,$E3,$90,$5F,$5F,$C5
DATA_00E0CC:
    db $71,$60,$60,$19,$94,$96,$96,$A2
    db $97,$97,$18,$3B,$B4,$3D,$A7,$E5
    db $2F,$D3,$C3,$C3,$F6,$D0,$B1,$81
    db $B2,$86,$B4,$87,$A6,$D1,$F7,$3A
    db $F0,$F4,$F5,$39,$3C,$C6,$E6,$38
    db $F1,$F0,$C5,$C5,$C5,$C5,$C5,$C5
    db $6C,$4D,$71,$6A,$6B,$60,$38,$F1
    db $5B,$69,$F1,$F1,$4E,$E1,$1D,$A3
    db $C5,$C5,$1A,$95,$10,$07,$02,$01
    db $00,$02,$14,$13,$12,$30,$27,$26
    db $30,$03,$15,$04,$31,$07,$E7,$25
    db $24,$23,$62,$36,$33,$91,$34,$92
    db $35,$A1,$32,$F2,$73,$1F,$C0,$C1
    db $C2,$83,$D2,$10,$B7,$E4,$B5,$61
    db $0A,$55,$0D,$75,$77,$1E,$59,$59
    db $58,$02,$02,$6D,$6E,$6F,$F3,$68
    db $6F,$6F,$06,$02,$01,$00,$02,$14
    db $13,$12,$30,$27,$26,$30,$03,$15
    db $04,$31,$07,$E7,$25,$24,$23,$62
    db $36,$33,$91,$34,$92,$35,$A1,$32
    db $F2,$73,$1F,$C0,$C1,$C2,$83,$D2
    db $10,$B7,$E4,$B5,$61,$0A,$55,$0D
    db $75,$77,$1E,$59,$59,$58,$02,$02
    db $6D,$6E,$6F,$F3,$68,$6F,$6F,$06
MarioPalIndex:
    db $00,$40

DATA_00E18E:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$0D,$00,$10
    db $13,$22,$25,$28,$00,$16,$00,$00
    db $00,$00,$00,$00,$00,$08,$19,$1C
    db $04,$1F,$10,$10,$00,$16,$10,$06
    db $04,$08,$2B,$30,$35,$3A,$3F,$43
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $16,$16,$00,$00,$08,$00,$00,$00
    db $00,$00,$00,$10,$04,$00

DATA_00E1D4:
    db $06

DATA_00E1D5:
    db $00

DATA_00E1D6:
    db $06

DATA_00E1D7:
    db $00

DATA_00E1D8:
    db $86,$02,$06,$03,$06,$01,$06,$CE
    db $06,$06,$40,$00,$06,$2C,$06,$06
    db $44,$0E,$86,$2C,$06,$86,$2C,$0A
    db $86,$84,$08,$06,$0A,$02,$06,$AC
    db $10,$06,$CC,$10,$06,$AE,$10,$00
    db $8C,$14,$80,$2E,$00,$CA,$16,$91
    db $2F,$00,$8E,$18,$81,$30,$00,$EB
    db $1A,$90,$31,$04,$ED,$1C,$82,$06
    db $92,$1E

DATA_00E21A:
    db $84,$86,$88,$8A,$8C,$8E,$90,$90
    db $92,$94,$96,$98,$9A,$9C,$9E,$A0
    db $A2,$A4,$A6,$A8,$AA,$B0,$B6,$BC
    db $C2,$C8,$CE,$D4,$DA,$DE,$E2,$E2
DATA_00E23A:
    db $0A,$0A,$84,$0A,$88,$88,$88,$88
    db $8A,$8A,$8A,$8A,$44,$44,$44,$44
    db $42,$42,$42,$42,$40,$40,$40,$40
    db $22,$22,$22,$22,$A4,$A4,$A4,$A4
    db $A6,$A6,$A6,$A6,$86,$86,$86,$86
    db $6E,$6E,$6E,$6E

DATA_00E266:
    db $02,$02,$02,$0C,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$04,$12,$04,$04
    db $04,$12,$04,$04,$04,$12,$04,$04
    db $04,$12,$04,$04

DATA_00E292:
    db $01,$01,$01,$01,$02,$02,$02,$02
    db $04,$04,$04,$04,$08,$08,$08,$08

DATA_00E2A2:
    dw PlayerColors
    dw PlayerColors+$14
    dw PlayerColors
    dw PlayerColors+$14
    dw PlayerColors
    dw PlayerColors+$14
    dw PlayerColors+$28
    dw PlayerColors+$3C

DATA_00E2B2:
    db $10,$D4,$10,$E8

DATA_00E2B6:
    db $08,$CC,$08

DATA_00E2B9:
    db $E0,$10,$10,$30

DrawMarioAndYoshi:
; Number of walking frames for each of Mario's powerups.
; Animation timers for both Mario's run animation and his cape's fluttering animation.
; Both use the absolute value of his speed, divided by 8, as a base index.
; Mario animation adds $13E5 on top of it, which is either 00 in normal levels or 68 in slippery.
; These 8 are for in slippery levels, still indexed by his speed divided by 8 (it overflows into the next table if you go fast enough).
; Indices to $00DD32, indexed by $13E0 (his pose). ORA'd with Mario's direction.
; If Mario is small ($19 = 00), then pose 0x29 will use pose 0x20's value instead.
; Indexes to the position tables for Mario's tiles. Indexed by $00DCEC + Mario's direction.
; 16-bit X offsets of Mario's tiles in various poses. 16-bit, indexed by $00DD32.
; 8 bytes per entry: head, body, extra tile #1, extra tile #2.
; This value is then added with the onscreen X position in $7E.
; Cape positions, indexed by $00E21A.
; 16-bit Y offsets of Mario's tiles in various poses, indexed by $00DD32.
; 8 bytes per entry: head, body, extra tile #1, extra tile #2.
; This value is then added with the onscreen Y position in $80.
; Cape positions, indexed by $00E21A.
; Base indices to the tables below to use for Mario, indexed by $19.
; Extra tile index table for each of Mario's poses.
; $00DF1A - Small
; $00DF57 - Poses 3D-45
; $00DF60 - Big
; $00DF9D - Cape
; Actual OAM tile numbers for Mario (despite its name, not necessarily 8x8). Each entry is 4 bytes long.
; Byte 0 is Mario's dynamic head tile (always tile 0x00).
; Byte 1 is Mario's dynamic body tile (always tile 0x02).
; Byte 2 is the extra 8x8 tile #1 (scattered throughout SP1).
; Byte 3 is the extra 8x8 tile #2 (scattered throughout SP1).
; The high byte being set indicates the tile shouldn't be drawn.
; Extra tile #1 in this entry (the balloon) is treated as 16x16.
; Tile in SP1/SP2 to use as the cape's dynamic tile.
; Tile in SP1/SP2 to use as the cape's misc dynamic tile.
; Miscellaneous static cape tiles.
; List of upper tiles for Mario. Bit 3 is page number; see https://media.smwcentral.net/Diagrams/PlayerTiles.png
; Small
; Poses 3D-45
; Big
; Cape
; List of lower tiles for Mario. Bit 3 is page number; see https://media.smwcentral.net/Diagrams/PlayerTiles.png
; Small
; Poses 3D-45
; Big
; Cape
; X-bit values for Mario's YXPPCCCT, indexed by his direction.
; Indices to the below data, indexed by $13E0 in cape form.
; Data on Mario's cape, indexed by values in $00E18E. Each entry is up to 5 bytes long.
; 00        ;  Byte 0 - MSK - Which tiles to not draw, according to $78 (---- dluc). If bit 7 is set, tile #$7F is skipped, and the main cape tile uses a different OAM index for high priority.
; 02        ;  Byte 1 - DYN - If less than #$04, used as an index to $00E23A/$00E266; else, it's a 16x16 tile number in GFX32. Uploaded to #$04 in SP1.
; 04        ;  Byte 2 - POS - Index to $00E21A for the cape's position. Ignored if DYN is less than 04.
; 06        ;  Byte 3 - Ex1 - 8x8 tile in GFX32 to upload to tile #$7F in SP1. Ignored if MSK has bit 1 (u) set.
; 08        ;  Byte 4 - Ex2 - Index to $00DFDA to use for the cape's other static misc tile. Ignored if MSK has bit 2 (l) set.
; 0A        ;
; 0D        ; For a more visual table of this data, see here: https://loli.muncher.se/mariocape/
; 10
; 13
; 16
; 19
; 1C
; 1F
; 22
; 25
; 28
; 2B
; 30
; 35
; 3A
; 3F
; 43
; Position indices for the cape, to $00DD4E/$00DE32.
; Tilemap for Mario's cape (16x16), uploaded to tile #$04 in SP1. Indexed by byte 1 of $00E1D4 (4 bytes per entry).
; The four bytes are standing, crouching, riding Yoshi, and about to use Yoshi's tongue.
; With the exception of the first entry though, all 4 bytes are always the same...
; Offsets to $00E21A (the position index table) for Mario's cape. Indexed by byte 1 of $00E1D4 (4 bytes per entry).
; The four bytes are standing, crouching, riding Yoshi, and about to use Yoshi's tongue.
; 16-bit pointers to the palettes for the player.
; Small M/L, Big M/L
; Cape M/L, Fire M/L
; OAM indices for Mario, indexed by $13F9.
; OAM indices for Mario's extra 8x8 tile, indexed by $13F9.
; Priority bits for Mario's YXPPCCCT, indexed by $13F9 minus 1.
; Default usage: 1 = nets, 2 = pipes, and 3 = overworld (also after Bowser is killed)
    PHB                                       ; Mario GFX routine, which also draws Yoshi and handles some other processes as well (e.g. star).
    PHK
    PLB
    LDA.B PlayerHiddenTiles
    CMP.B #$FF                                ; Process Yoshi, unless Mario isn't being drawn.
    BEQ +
    JSL CODE_01EA70
  + LDY.W CyclePaletteTimer                   ; Branch if Mario is not currently flipping through palettes.
    BNE CODE_00E308
    LDY.W InvinsibilityTimer                  ; \ Branch if Mario doesn't have star; Branch if star power is not active.
    BEQ CODE_00E314                           ; /
    LDA.B PlayerHiddenTiles
    CMP.B #$FF
    BEQ +                                     ; Decrement the star power timer every 4 frames,
    LDA.B EffFrame                            ; unless Mario isn't being drawn.
    AND.B #$03
    BNE +
    DEC.W InvinsibilityTimer                  ; Decrease star timer
  + LDA.B TrueFrame
    CPY.B #con($1E,$1E,$1E,$18,$18)           ; Skip down to cycle palettes if star power is not close to finishing.
    BCC CODE_00E30A                           ; Otherwise, continue below to restore the music.
    BNE CODE_00E30C
    LDA.W MusicBackup
    CMP.B #$FF
    BEQ CODE_00E308                           ; Restore the music.
    AND.B #$7F
    STA.W MusicBackup
    TAX
    LDA.W BluePSwitchTimer
    ORA.W SilverPSwitchTimer
    ORA.W DirectCoinTimer
    BEQ +
    LDX.B #!BGM_PSWITCH
  + STX.W SPCIO2                              ; / Change music
CODE_00E308:
    LDA.B TrueFrame
CODE_00E30A:
    LSR A
    LSR A
CODE_00E30C:
    AND.B #$03                                ; Number of palettes to flash through when Mario has star power.
    INC A
    INC A
    INC A
    INC A
    BRA +

CODE_00E314:
    LDA.B Powerup                             ; Mario does not have star power.
    ASL A                                     ; Get the current palette to use for the player.
    ORA.W PlayerTurnLvl
  + ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.W DATA_00E2A2,Y                       ; Store the palette pointer to use for the current player's palette.
    STA.W PlayerPalletePtr
    SEP #$20                                  ; A->8
    LDX.W PlayerPose
    LDA.B #$05
    CMP.W WallrunningType                     ; Branch if Mario is not running sideways on a wall.
    BCS CODE_00E33E
    LDA.W WallrunningType
    LDY.B Powerup                             ; Branch if Mario is small.
    BEQ CODE_00E33B
    CPX.B #$13                                ; If the player's pose is not #$13, branch.
    BNE +
CODE_00E33B:
    EOR.B #$01                                ; Basically the whole point of this code is to determine whether
  + LSR A                                     ; to shift Mario's X position within the screen one extra pixel.
CODE_00E33E:
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    SBC.B Layer1XPos                          ; Store player X position relative to the screen.
    STA.B PlayerXPosScrRel
    LDA.W ScrShakePlayerYOffset
    AND.W #$00FF
    CLC
    ADC.B PlayerYPosNext
    LDY.B Powerup
    CPY.B #$01
    LDY.B #$01
    BCS +
    DEC A
    DEY                                       ; Store player Y position relative to the screen.
  + CPX.B #$0A                                ; Adjust for screen shake, powerup, and walking frame.
    BCS +
    CPY.W PlayerWalkingPose
  + SBC.B Layer1YPos
    CPX.B #$1C
    BNE +
    ADC.W #$0001
  + STA.B PlayerYPosScrRel
    SEP #$20                                  ; A->8
    LDA.W IFrameTimer
    BEQ +
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_00E292,Y
    AND.W IFrameTimer
    ORA.B SpriteLock
    ORA.W PlayerIsFrozen
    BNE +
    PLB
    RTL

  + LDA.B #$C8
    CPX.B #$43                                ; Set the size of Mario's tiles, 8x8 or 16x16 (hb12 c34-).
    BNE +                                     ; (1/2 = extra tile #1/#2, c = cape, 3/4 = cape misc #1/#2)
    LDA.B #$E8                                ; Balloon form sets Ex1 to be 16x16; in all others it's 8x8.
  + STA.B _4
    CPX.B #$29
    BNE +
    LDA.B Powerup
    BNE +
    LDX.B #$20
  + LDA.W DATA_00DCEC,X
    ORA.B PlayerDirection
    TAY
    LDA.W DATA_00DD32,Y
    STA.B _5
    LDY.B Powerup
    LDA.W PlayerPose
    CMP.B #$3D
    BCS +
    ADC.W TilesetIndex,Y
  + TAY
    LDA.W TileExpansion_,Y
    STA.B _6
    LDA.W DATA_00E00C,Y
    STA.B _A                                  ; Preserve the top/bottom tiles (stored at $00F63A).
    LDA.W DATA_00E0CC,Y
    STA.B _B
    LDA.B SpriteProperties
    LDX.W PlayerBehindNet
    BEQ +
    LDA.W DATA_00E2B9,X
  + LDY.W DATA_00E2B2,X
    LDX.B PlayerDirection
    ORA.W MarioPalIndex,X
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y                  ; Store Mario's YXPPCCCT to all necessary tiles.
    STA.W OAMTileAttr+$10C,Y                  ; If set to go behind layers, use standard YXPPCCCT instead of Mario's normal.
    STA.W OAMTileAttr+$110,Y
    STA.W OAMTileAttr+$F8,Y
    STA.W OAMTileAttr+$FC,Y
    LDX.B _4
    CPX.B #$E8
    BNE +
    EOR.B #$40
  + STA.W OAMTileAttr+$108,Y
    JSR CODE_00E45D
    JSR CODE_00E45D                           ; Draw main four tiles for Mario into OAM.
    JSR CODE_00E45D
    JSR CODE_00E45D
    LDA.B Powerup
    CMP.B #$02                                ; Powerup that shows the cape graphic. (all others skip the below code)
    BNE CODE_00E458
    PHY
    LDA.B #$2C                                ; Base index to $00DFDA for the extra cape tiles.
    STA.B _6
    LDX.W PlayerPose
    LDA.W DATA_00E18E,X
    TAX
    LDA.W DATA_00E1D7,X                       ; Get dynamic cape tile to upload to tile #$7F.
    STA.B _D
    LDA.W DATA_00E1D8,X                       ; Get position index for the second static cape tile.
    STA.B _E
    LDA.W DATA_00E1D5,X
    STA.B _C
    CMP.B #$04
    BCS CODE_00E432
    LDA.W PlayerCapePose
    ASL A
    ASL A
    ORA.B _C
    TAY
    LDA.W DATA_00E23A,Y                       ; Handle the main cape tile, uploaded dynamically to #$04 in SP1.
    STA.B _C                                  ; Gets the tile number and position offset.
    LDA.W DATA_00E266,Y
    BRA +

CODE_00E432:
    LDA.W DATA_00E1D6,X
  + ORA.B PlayerDirection
    TAY
    LDA.W DATA_00E21A,Y
    STA.B _5
    PLY
    LDA.W DATA_00E1D4,X                       ; Disable any extra cape tiles, if applicable.
    TSB.B PlayerHiddenTiles
    BMI +
    JSR CODE_00E45D                           ; Draw the main cape tile (04) and extra dynamic tile (7F).
  + LDX.W PlayerBehindNet                     ; If tile 7F is skipped by the value from $00E1D4,
    LDY.W DATA_00E2B6,X                       ; then the main tile is drawn with a different OAM index (for priority).
    JSR CODE_00E45D
    LDA.B _E
    STA.B _6                                  ; Draw the static cape tile.
    JSR CODE_00E45D
CODE_00E458:
    JSR CODE_00F636                           ; Store the pointers to Mario's graphics for DMA upload later.
    PLB
    RTL

CODE_00E45D:
; Subroutine to draw a tile for Mario into OAM, if applicable.
    LSR.B PlayerHiddenTiles                   ; Y contains OAM index, $05 contains the X/Y index, $06 contains the tile index. All incremented by respective amounts after.
    BCS +
    LDX.B _6                                  ; Store the tile number.
    LDA.W Mario8x8Tiles,X                     ; Skip the rest if not set to be shown, or not being used.
    BMI +
    STA.W OAMTileNo+$100,Y
    LDX.B _5
    REP #$20                                  ; A->16
    LDA.B PlayerYPosScrRel
    CLC
    ADC.W DATA_00DE32,X                       ; Store Y position for the tile.
    PHA
    CLC                                       ; Skip the rest if veritcally offscreen.
    ADC.W #$0010
    CMP.W #$0100
    PLA
    SEP #$20                                  ; A->8
    BCS +
    STA.W OAMTileYPos+$100,Y
    REP #$20                                  ; A->16
    LDA.B PlayerXPosScrRel
    CLC
    ADC.W DATA_00DD4E,X
    PHA
    CLC                                       ; Store X position for the tile.
    ADC.W #$0080                              ; Set high X bit for size later if horizontally offscreen.
    CMP.W #$0200
    PLA
    SEP #$20                                  ; A->8
    BCS +
    STA.W OAMTileXPos+$100,Y
    XBA
    LSR A
  + PHP
    TYA
    LSR A
    LSR A
    TAX
    ASL.B _4                                  ; Set size.
    ROL A
    PLP
    ROL A
    AND.B #$03
    STA.W OAMTileSize+$40,X
    INY
    INY
    INY
    INY
    INC.B _5                                  ; Increase X/Y position index for the next tile.
    INC.B _5
    INC.B _6                                  ; Increase tile index for the next tile.
    RTS


DATA_00E4B9:
    db $08,$08,$08,$08,$10,$10,$10,$10
    db $18,$18,$20,$20,$28,$30,$08,$10
    db $00,$00,$28,$00,$00,$00,$00,$00
    db $38,$50,$48,$40,$58,$58,$60,$60
    db $00

DATA_00E4DA:
    db $10,$10,$10,$10,$10,$10,$10,$10
    db $20,$20,$20,$20,$30,$30,$40,$30
    db $30,$30,$30,$00,$00,$00,$00,$00
    db $30,$30,$30,$30,$40,$40,$40,$40
    db $00

DATA_00E4FB:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $EC,$EC,$EE,$EE,$DA,$DA,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $DA,$DA,$DA,$DA,$00,$00,$00,$00
    db $00

DATA_00E51C:
    db $08,$08,$08,$08,$08,$08,$08,$08
    db $09,$09,$09,$09,$0B,$0B,$0B,$0B
    db $0B,$0B,$0B,$00,$00,$00,$00,$00
    db $0B,$0B,$0B,$0B,$14,$14,$14,$14
    db $06

DATA_00E53D:
    db $FF,$FF,$FF,$FF,$01,$01,$01,$01
    db $FE,$FE,$02,$02,$FD,$03,$FD,$03
    db $FD,$03,$FD,$00,$00,$00,$00,$00
    db $08,$08,$F8,$F8,$FC,$FC,$04,$04
    db $00

DATA_00E55E:
    db $00,$00,$00,$00,$00,$01,$01
    db $01,$01,$01,$02,$02,$02,$02,$02
    db $03,$03,$03,$03,$03,$04,$04,$04
    db $04,$04,$05,$05,$05,$05,$05,$06
    db $06,$06,$06,$06,$07,$07,$07,$07
    db $07,$08,$08,$08,$08,$08,$09,$09
    db $09,$09,$09,$0A,$0A,$0A,$0A,$0A
    db $0B,$0B,$0B,$0B,$0B,$0C,$0C,$0C
    db $0C,$0C,$0D,$0D,$0D,$0D,$0D,$0E
    db $0F,$10,$11,$03,$03,$04,$04,$09
    db $09,$0A,$0A,$0C,$0C,$0D,$0D,$12
    db $13,$14,$15,$16,$17,$1C,$1D,$1E
    db $1F,$18,$19,$1A,$1B,$08,$09,$0A
    db $0B,$0C,$0D

DATA_00E5C8:
    db $00,$00,$00,$00,$00
    db $01,$01,$01,$01,$01,$02,$02,$02
    db $02,$02,$03,$03,$03,$03,$03,$04
    db $04,$04,$04,$04,$05,$05,$05,$05
    db $05,$06,$06,$06,$06,$06,$07,$07
    db $07,$07,$07,$08,$08,$08,$08,$08
    db $09,$09,$09,$09,$09,$0A,$0A,$0A
    db $0A,$0A,$0B,$0B,$0B,$0B,$0B,$0C
    db $0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D
    db $0D,$0E,$0F,$10,$11,$03,$03,$04
    db $04,$09,$09,$0A,$0A,$0C,$0C,$0D
    db $0D,$0C,$0D,$0D,$0C,$16,$17,$1C
    db $1D,$1E,$1F,$18,$19,$1A,$1B,$08
    db $09,$0A,$0B,$0C,$0D

DATA_00E632:
    db $0F,$0F,$0F,$0F,$0E,$0E,$0E,$0E
    db $0D,$0D,$0D,$0D,$0C,$0C,$0C,$0C
    db $0B,$0B,$0B,$0B,$0A,$0A,$0A,$0A
    db $09,$09,$09,$09,$08,$08,$08,$08
    db $07,$07,$07,$07,$06,$06,$06,$06
    db $05,$05,$05,$05,$04,$04,$04,$04
    db $03,$03,$03,$03,$02,$02,$02,$02
    db $01,$01,$01,$01,$00,$00,$00,$00
    db $00,$00,$00,$00,$01,$01,$01,$01
    db $02,$02,$02,$02,$03,$03,$03,$03
    db $04,$04,$04,$04,$05,$05,$05,$05
    db $06,$06,$06,$06,$07,$07,$07,$07
    db $08,$08,$08,$08,$09,$09,$09,$09
    db $0A,$0A,$0A,$0A,$0B,$0B,$0B,$0B
    db $0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D
    db $0E,$0E,$0E,$0E,$0F,$0F,$0F,$0F
    db $0F,$0F,$0E,$0E,$0D,$0D,$0C,$0C
    db $0B,$0B,$0A,$0A,$09,$09,$08,$08
    db $07,$07,$06,$06,$05,$05,$04,$04
    db $03,$03,$02,$02,$01,$01,$00,$00
    db $00,$00,$01,$01,$02,$02,$03,$03
    db $04,$04,$05,$05,$06,$06,$07,$07
    db $08,$08,$09,$09,$0A,$0A,$0B,$0B
    db $0C,$0C,$0D,$0D,$0E,$0E,$0F,$0F
    db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08
    db $07,$06,$05,$04,$03,$02,$01,$00
    db $00,$01,$02,$03,$04,$05,$06,$07
    db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
    db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08
    db $07,$06,$05,$04,$03,$02,$01,$00
    db $00,$01,$02,$03,$04,$05,$06,$07
    db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
    db $08,$06,$04,$03,$02,$02,$01,$01
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $01,$01,$02,$02,$03,$04,$06,$08
    db $FF,$FE,$FD,$FC,$FB,$FA,$F9,$F8
    db $F7,$F6,$F5,$F4,$F3,$F2,$F1,$F0
    db $F0,$F1,$F2,$F3,$F4,$F5,$F6,$F7
    db $F8,$F9,$FA,$FB,$FC,$FD,$FE,$FF
    db $FF,$FF,$FE,$FE,$FD,$FD,$FC,$FC
    db $FB,$FB,$FA,$FA,$F9,$F9,$F8,$F8
    db $F7,$F7,$F6,$F6,$F5,$F5,$F4,$F4
    db $F3,$F3,$F2,$F2,$F1,$F1,$F0,$F0
    db $F0,$F0,$F1,$F1,$F2,$F2,$F3,$F3
    db $F4,$F4,$F5,$F5,$F6,$F6,$F7,$F7
    db $F8,$F8,$F9,$F9,$FA,$FA,$FB,$FB
    db $FC,$FC,$FD,$FD,$FE,$FE,$FF,$FF
    db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08
    db $07,$06,$05,$04,$03,$02,$01,$00
    db $00,$01,$02,$03,$04,$05,$06,$07
    db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
    db $00,$01,$02,$03,$04,$05,$06,$07
    db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
    db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08
    db $07,$06,$05,$04,$03,$02,$01,$00
    db $10,$10,$10,$10,$10,$10,$10,$10
    db $0E,$0C,$0A,$08,$06,$04,$02,$00
    db $0E,$0C,$0A,$08,$06,$04,$02,$00
    db $FE,$FC,$FA,$F8,$F6,$F4,$F2,$F0
    db $00,$02,$04,$06,$08,$0A,$0C,$0E
    db $10,$10,$10,$10,$10,$10,$10,$10
    db $F0,$F2,$F4,$F6,$F8,$FA,$FC,$FE
    db $00,$02,$04,$06,$08,$0A

DATA_00E830:
    db $0C,$0E,$08,$00,$0E,$00,$0E,$00
    db $08,$00,$05,$00,$0B,$00,$08,$00
    db $02,$00,$02,$00,$08,$00,$0B,$00
    db $05,$00,$08,$00,$0E,$00,$0E,$00
    db $08,$00,$05,$00,$0B,$00,$08,$00
    db $02,$00,$02,$00,$08,$00,$0B,$00
    db $05,$00,$08,$00,$0E,$00,$0E,$00
    db $08,$00,$05,$00,$0B,$00,$08,$00
    db $02,$00,$02,$00,$08,$00,$0B,$00
    db $05,$00,$08,$00,$0E,$00,$0E,$00
    db $08,$00,$05,$00,$0B,$00,$08,$00
    db $02,$00,$02,$00,$08,$00,$0B,$00
    db $05,$00,$10,$00,$20,$00,$07,$00
    db $00,$00,$F0,$FF

DATA_00E89C:
    db $08,$00,$18,$00,$1A,$00,$16,$00
DATA_00E8A4:
    db $10,$00,$20,$00,$20,$00,$18,$00
    db $1A,$00,$16,$00,$10,$00,$20,$00
    db $20,$00,$12,$00,$1A,$00,$0F,$00
    db $08,$00,$20,$00,$20,$00,$12,$00
    db $1A,$00,$0F,$00,$08,$00,$20,$00
    db $20,$00,$1D,$00,$28,$00,$19,$00
    db $13,$00,$30,$00,$30,$00,$1D,$00
    db $28,$00,$19,$00,$13,$00,$30,$00
    db $30,$00,$1A,$00,$28,$00,$16,$00
    db $10,$00,$30,$00,$30,$00,$1A,$00
    db $28,$00,$16,$00,$10,$00,$30,$00
    db $30,$00,$18,$00,$18,$00,$18,$00
    db $18,$00,$18,$00,$18,$00

DATA_00E90A:
    db $01,$02,$11

DATA_00E90D:
    db $FF

DATA_00E90E:
    db $FF,$01,$00

DATA_00E911:
    db $02,$0D

DATA_00E913:
    db $01,$00,$FF,$FF,$01,$00,$01,$00
    db $FF,$FF,$FF,$FF

DATA_00E91F:
    db $00,$00,$00,$00,$FF,$FF,$01,$00
    db $FF,$FF,$01,$00

CODE_00E92B:
; Values stored to $13E1 for each slope tile.
; 00 - Gradual
; 08 - Normal
; 0C - Steep
; 0E - Purple Triangle
; 10 - Ledge-edge Very Steep (from object 13)
; 12 - Upside-down Steep (unused)
; 14 - Upside-down Normal (unused)
; 18 - Conveyors
; 1C - Very Steep
; 20 - Flat Ground
; Y speeds to give Mario when standing on a slope.
; 00 - Gradual
; 08 - Normal
; 0C - Steep
; 0E - Purple Triangle
; 10 - Ledge-edge Very Steep (from object 13)
; 12 - Upside-down Steep (unused)
; 14 - Upside-down Normal (unused)
; 18 - Conveyors
; 1C - Very Steep
; 20 - Flat Ground
; Y speeds to give Mario when running up a slope.
; 00 - Gradual
; 08 - Normal
; 0C - Steep
; 0E - Purple Triangle
; 10 - Ledge-edge Very Steep (from object 13)
; 12 - Upside-down Steep (unused)
; 14 - Upside-down Normal (unused)
; 18 - Conveyors
; 1C - Very Steep
; 20 - Unused
; Size of the "top" of a slope (the area that pushes Mario onto it).
; 00 - Gradual
; 08 - Normal
; 0C - Steep
; 0E - Purple Triangle
; 10 - Ledge-edge Very Steep (from object 13)
; 12 - Upside-down Steep (unused)
; 14 - Upside-down Normal (unused)
; 18 - Conveyors
; 1C - Very Steep
; 20 - Flat Ground (unused, probably)
; Values to handle sprite interaction with the various slopes. Each value is the slope's "steepness".
; 00 - Gradual
; 08 - Normal
; 0C - Steep
; 0E - Purple Triangle
; 10 - Ledge-edge Very Steep (from object 13)
; 12 - Upside-down Steep
; 14 - Upside-down Normal
; 18 - Conveyors
; 1C - Very Steep
; 20 - Flat Ground
; Indices to the above tables for slopes in any tileset except 0 and 7. (upside-down slopes)
; Index to the table is the block number, from 16E to 1D7.
; Indices to the above tables for slopes in tilesets 0 and 7. (diagonal pipes)
; Index to the table is the block number, from 16E to 1D7.
; How many pixels a sprite should move down from the nearest 16x16 tile. Indexed by $00E5C8/$00E55E * 10, plus the X position within the slope.
; 000 - Gradual left
; 040 - Gradual right
; 080 - Normal left
; 0A0 - Normal right
; 0C0 - Steep left
; 0D0 - Steep right
; 0E0 - Purple triangle left
; 0F0 - Purple triangle right
; 100 - Very steep left, to edge (tile 1B6)
; 110 - Very steep right, to edge (tile 1B7)
; 120 - Upside-down steep left
; 130 - Upside-down steep right
; 140 - Upside-down normal left
; 160 - Upside-down normal right
; 180 - Left-up conveyor
; 190 - Right-down conveyor
; 1A0 - Right-up conveyor
; 1B0 - Left-down conveyor
; 1C0 - Very steep slope left
; 1E0 - Very steep slope right
; center,sideB,sideT, head,footL,footR
; Mario interaction points, X positions. See http://bin.smwcentral.net/u/75/InteractionPoints.txt
; 00 - Small, standing
; 0C - Small, walking
; 18 - Big, standing
; 24 - Big, walking
; 30 - Small, standing, on Yoshi
; 3C - Small, walking, on Yoshi
; 48 - Big, standing, on Yoshi
; 54 - Big, walking, on Yoshi
; 60 - Running up wall?
; $00E89C   | Mario interaction points, Y positions.
; 00 - Small, standing
; 0C - Small, walking
; 18 - Big, standing
; 24 - Big, walking
; 30 - Small, standing, on Yoshi
; 3C - Small, walking, on Yoshi
; 48 - Big, standing, on Yoshi
; 54 - Big, walking, on Yoshi
; 60 - Running up wall?
; Defines the "edges" of blocks. Mario won't interact with blocks if touching them at these positions.
; First = left side, second = right side.
; X speeds that conveyors push Mario with.
; Flat right
; Flat left
; Up right
; Down right
; Up left
; Down left
; Y speeds that conveyors push Mario with.
; Flat right
; Flat left
; Up right
; Down right
; Up left
; Down left
    JSR CODE_00EAA6                           ; Routine to process object interaction for Mario.
    LDA.W PlayerDisableObjInt
    BEQ CODE_00E938
    JSR CODE_00EE1D
    BRA CODE_00E98C

CODE_00E938:
    LDA.W PlayerIsOnGround
    STA.B TempPlayerGround
    STZ.W PlayerIsOnGround
    LDA.B PlayerInAir
    STA.B TempPlayerAir
    LDA.B ScreenMode
    BPL +                                     ; Branch if Layer 2 interaction is disabled.
    AND.B #!ScrMode_EnableL2Int|!ScrMode_Layer2Vert
    STA.B TempScreenMode
    LDA.B #$01
    STA.W LayerProcessing
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    CLC
    ADC.B Layer23XRelPos
    STA.B PlayerXPosNext
    LDA.B PlayerYPosNext
    CLC
    ADC.B Layer23YRelPos
    STA.B PlayerYPosNext
    SEP #$20                                  ; A->8; Run Mario's object interaction for Layer 2.
    JSR CODE_00EADB
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    SEC
    SBC.B Layer23XRelPos
    STA.B PlayerXPosNext
    LDA.B PlayerYPosNext
    SEC
    SBC.B Layer23YRelPos
    STA.B PlayerYPosNext
    SEP #$20                                  ; A->8
  + ASL.W PlayerIsOnGround
    LDA.B ScreenMode
    AND.B #!ScrMode_DisableL1Int|!ScrMode_Layer1Vert
    STA.B TempScreenMode                      ; Branch if Layer 1 interaction is disabled.
    ASL A
    BMI CODE_00E98C
    STZ.W LayerProcessing
    ASL.B TempPlayerGround                    ; Run Mario's object interaction for Layer 1.
    JSR CODE_00EADB
CODE_00E98C:
    LDA.W SideExitEnabled                     ; If side exits are not enabled, branch.
    BEQ CODE_00E9A1
    REP #$20                                  ; A->16
    LDA.B PlayerXPosScrRel
    CMP.W #$00FA                              ; How far Mario needs to be on the right side of the screen to exit the level.
    SEP #$20                                  ; A->8; (Greater than #$00FA is not recommended.)
    BCC CODE_00E9FB
    JSL SubSideExit
    RTS

CODE_00E9A1:
    LDA.B PlayerXPosScrRel
    CMP.B #$F0                                ; If Mario is too far into the right screen border, kill him.
    BCS CODE_00EA08
    LDA.B PlayerBlockedDir
    AND.B #$03                                ; If Mario is blocked from the left or right, branch.
    BNE CODE_00E9FB
    REP #$20                                  ; A->16
    LDY.B #$00
    LDA.W NextLayer1XPos
    CLC
    ADC.W #$00E8
    CMP.B PlayerXPosNext
    BEQ CODE_00E9C8
    BMI CODE_00E9C8
    INY
    LDA.B PlayerXPosNext
    SEC
    SBC.W #$0008
    CMP.W NextLayer1XPos
CODE_00E9C8:
    SEP #$20                                  ; A->8
    BEQ CODE_00E9FB
    BPL CODE_00E9FB
    LDA.W HorizLayer1Setting
    BNE +
    LDA.B #$80
    TSB.B PlayerBlockedDir
    REP #$20                                  ; A->16
    LDA.W Layer1ScrollXSpeed
    LSR A
    LSR A
    LSR A
    LSR A
    SEP #$20                                  ; A->8
    STA.B _0
    SEC
    SBC.B PlayerXSpeed+1
    EOR.W DATA_00E90E,Y
    BMI +
    LDA.B _0
    STA.B PlayerXSpeed+1
    LDA.W Layer1ScrollXPosUpd
    STA.W PlayerXPosSpx
  + LDA.W DATA_00E90A,Y
    TSB.B PlayerBlockedDir
CODE_00E9FB:
    LDA.B PlayerBlockedDir
    AND.B #$1C
    CMP.B #$1C                                ; If Mario is not inside of a block or on a solid sprite, branch.
    BNE CODE_00EA0D
    LDA.W StandOnSolidSprite
    BNE CODE_00EA0D
CODE_00EA08:
; Inside a block.
    JSR CODE_00F629                           ; Kill Mario.
    BRA CODE_00EA32                           ; Branch to continue.

CODE_00EA0D:
    LDA.B PlayerBlockedDir                    ; Not inside a block or on a sprite.
    AND.B #$03
    BEQ +
    AND.B #$02
    TAY
    REP #$20                                  ; A->16; If Mario is blocked on either the left or right,
    LDA.B PlayerXPosNext                      ; push him out of the block (1 pixel left/right).
    CLC
    ADC.W DATA_00E90D,Y                       ; If he's touching the screen barrier in a room with horizontal scrolling,
    STA.B PlayerXPosNext                      ; and moving towards the barrier, then clear his X speed.
    SEP #$20                                  ; A->8
    LDA.B PlayerBlockedDir
    BMI +
    LDA.B #$03
    STA.W PlayerPoseLenTimer
    LDA.B PlayerXSpeed+1
    EOR.W DATA_00E90D,Y
    BPL +
CODE_00EA32:
    STZ.B PlayerXSpeed+1
  + LDA.W PlayerBehindNet
    CMP.B #$01                                ; Something related to net gates?
    BNE +
    LDA.B InteractionPtsClimbable
    BNE +
    STZ.W PlayerBehindNet
  + STZ.W PlayerCanJumpWater
    LDA.B LevelIsWater                        ; If in a water level, branch down to always treat Mario as being in water.
    BNE CODE_00EA5E
    LSR.B InteractionPtsInWater               ; Return Mario as out of water if ???
    BCC CODE_00EAA3
    LDA.B PlayerInWater
    BNE CODE_00EA65                           ; Branch to check if Mario can jump out of the water if
    LDA.B PlayerYSpeed+1                      ; he's currently in water or is moving upwards.
    BMI CODE_00EA65
    LSR.B InteractionPtsInWater               ; Return if ???
    BCC Return00EAA5
    JSR CODE_00FDA5                           ; Spawn a splash sprite (entering water?)
    STZ.B PlayerYSpeed+1                      ; Clear Mario's Y speed.
CODE_00EA5E:
    LDA.B #$01                                ; Set Mario as being in water.
    STA.B PlayerInWater
CODE_00EA62:
    JMP CODE_00FD08                           ; Handle Mario's water bubbles.

CODE_00EA65:
; Mario is in water or moving upwards; check if he's jumping out of the water.
    LSR.B InteractionPtsInWater               ; Return Mario as in water if ???
    BCS CODE_00EA5E
    LDA.B PlayerInWater                       ; Return if not in water at all.
    BEQ Return00EAA5
    LDA.B #$FC                                ; Y speed to give Mario when reaching the surface of the water.
    CMP.B PlayerYSpeed+1                      ; Prevent Mario from flinging himself out of the water rather than jumping out.
    BMI +
    STA.B PlayerYSpeed+1
  + INC.W PlayerCanJumpWater
    LDA.B byetudlrHold
    AND.B #$88                                ; If A/B and up are not being pressed together,
    CMP.B #$88                                ; branch to just spawn water bubbles and return.
    BNE CODE_00EA62
    LDA.B axlr0000Hold
    BPL +
    LDA.W IsCarryingItem                      ; Check if spinjumping out of water.
    BNE +
    INC A                                     ; Set spinjump flag.
    STA.W SpinJumpFlag
    LDA.B #!SFX_SPIN                          ; \ Play sound effect; SFX for spinjumping out of water.
    STA.W SPCIO3                              ; /
  + LDA.B PlayerBlockedDir
    AND.B #$08                                ; If hitting a ceiling, branch to just spawn water bubbles and return.
    BNE CODE_00EA62
    JSR CODE_00FDA5                           ; Spawn a splash sprite (jumping out of water).
    LDA.B #$0B                                ; Set Mario as being in-air.
    STA.B PlayerInAir
    LDA.B #$AA                                ; Y speed to give Mario when jumping out of water.
    STA.B PlayerYSpeed+1
CODE_00EAA3:
    STZ.B PlayerInWater                       ; Clear water flag.
Return00EAA5:
    RTS

CODE_00EAA6:
; Subroutine to clear various addresses used for Mario-object interaction.
    STZ.W PlayerPoseLenTimer                  ; Slippery surface flag
    STZ.B PlayerBlockedDir                    ; Player blocked status
    STZ.W SlopeType                           ; Slope type (1)
    STZ.W CurrentSlope                        ; Slope type (2)
    STZ.B InteractionPtsInWater               ; Scratch RAM A
    STZ.B InteractionPtsClimbable             ; Scratch RAM B
    STZ.W Layer2Touched                       ; Touching Layer 2 flag
    RTS


if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
DATA_00EAB9:                                  ;!
    db $DE,$23                                ;!
else                                          ;<==================== E0 & E1 ==================
DATA_00EAB9:                                  ;!
    db $D6,$2B                                ;!
endif                                         ;/===============================================

DATA_00EABB:
    db $20,$E0

DATA_00EABD:
    db $08,$00,$F8,$FF

DATA_00EAC1:
    db $71,$72,$76,$77,$7B,$7C,$81,$86
    db $8A,$8B,$8F,$90,$94,$95,$99,$9A
    db $9E,$9F,$A3,$A4,$A8,$A9,$AD,$AE
    db $B2,$B3

CODE_00EADB:
; X speeds required to start a wallrun.
; X speeds for jumping out of a wallrun.
; Map16 tiles which are considered to be in water.
    LDA.B PlayerYPosNext                      ; Mario-object interaction routine for a specific layer.
    AND.B #$0F
    STA.B PlayerYPosInBlock
    LDA.W WallrunningType
    BNE +                                     ; Jump down if not wall-running, to process normal block interaction.
    JMP CODE_00EB77

  + AND.B #$01                                ; Mario is wallrunning.
    TAY
    LDA.B PlayerXSpeed+1
    SEC                                       ; Branch if still moving fast enough to wallrun.
    SBC.W DATA_00EAB9,Y                       ; Else, we're gonna break that wallrun.
    EOR.W DATA_00EAB9,Y
    BMI CODE_00EB48
    LDA.B PlayerInAir
    ORA.W IsCarryingItem
    ORA.B PlayerIsDucking
    ORA.W PlayerRidingYoshi
    BNE CODE_00EB48
    LDA.W WallrunningType
    CMP.B #$06
    BCS CODE_00EB22
    LDX.B PlayerYPosInBlock
    CPX.B #$08
    BCC Return00EB76
    CMP.B #$04
    BCS CODE_00EB73
    ORA.B #$04
    STA.W WallrunningType
CODE_00EB19:
    LDA.B PlayerXPosNext
    AND.B #$F0
    ORA.B #$08
    STA.B PlayerXPosNext
    RTS

CODE_00EB22:
    LDX.B #$60
    TYA
    BEQ +
    LDX.B #$66
  + JSR CODE_00EFE8
    LDA.B Powerup
    BNE CODE_00EB34
    INX
    INX
    BRA +

CODE_00EB34:
    JSR CODE_00EFE8
  + JSR CODE_00F44D                           ; Run "WallBody" interaction point.
    BNE CODE_00EB19                           ; Branch if touching a tile on page 0.
    LDA.B #$02
    TRB.W WallrunningType
    RTS

ADDR_00EB42:
    LDA.W WallrunningType
    AND.B #$01
    TAY
CODE_00EB48:
    LDA.W DATA_00EABB,Y                       ; Give X speed.
    STA.B PlayerXSpeed+1
    TYA
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    CLC
    ADC.W DATA_00EABD,Y
    STA.B PlayerXPosNext
    LDA.W #$0008
    LDY.B Powerup
    BEQ +
    LDA.W #$0010
  + CLC
    ADC.B PlayerYPosNext
    STA.B PlayerYPosNext
    SEP #$20                                  ; A->8
    LDA.B #$24                                ; Indicate Mario is in air and falling.
    STA.B PlayerInAir
    LDA.B #$E0                                ; Y speed to give when jumping out of a wall-run.
    STA.B PlayerYSpeed+1
CODE_00EB73:
    STZ.W WallrunningType
Return00EB76:
    RTS

CODE_00EB77:
    LDX.B #$00                                ; Block interaction routine.
    LDA.B Powerup
    BEQ +                                     ; Getting the interaction point base offset. Logic is as follows:
    LDA.B PlayerIsDucking                     ; If small, use a base offset of 0x00. If big, use 0x18.
    BNE +                                     ; If riding Yoshi, add 0x30.
    LDX.B #$18                                ; If on the left side of a tile, add 0x0B.
  + LDA.W PlayerRidingYoshi                   ; $93 contains the side Mario is on (0 = right, 1 = left).
    BEQ +
    TXA
    CLC
    ADC.B #$30
    TAX
  + LDA.B PlayerXPosNext
    AND.B #$0F
    TAY
    CLC
    ADC.B #$08
    AND.B #$0F
    STA.B PlayerXPosInBlock
    STZ.B PlayerBlockXSide
    CPY.B #$08
    BCC +
    TXA
    ADC.B #$0B
    TAX
    INC.B PlayerBlockXSide
  + LDA.B PlayerYPosInBlock
    CLC
    ADC.W DATA_00E8A4,X                       ; $91 = Y position of Mario's head within the block.
    AND.B #$0F
    STA.B PlayerBlockMoveY
    JSR CODE_00F44D                           ; Run "BodyInside" interaction point.
    BEQ CODE_00EBDD                           ; Branch if touching a tile on Page 0.
    CPY.B #$11                                ; Skip this point for tiles 100-110 (ledges).
    BCC CODE_00EC24
    CPY.B #$6E                                ; Branch for tiles 111-16D (solid blocks).
    BCC CODE_00EBC9                           ; The rest below are 16E-1FF (slopes + corners)
    TYA
    JSL CODE_00F04D                           ; If not a slope in water, skip this point.
    BCC CODE_00EC24
    LDA.B #$01
    TSB.B InteractionPtsInWater
    BRA CODE_00EC24

CODE_00EBC9:
    INX                                       ; Center of Mario's body is inside a solid block (111-16D).
    INX                                       ; Skip side interaction points.
    INX
    INX
    TYA
    LDY.B #$00
    CMP.B #$1E
    BEQ +
    CMP.B #$52                                ; Set blocked bits for Mario.
    BEQ +                                     ; Tiles 11E (turnblock) and 152 (invisible solid block)
    LDY.B #$02                                ; for whatever reason do not set the "middle of a block" bit.
  + JMP CODE_00EC6F

CODE_00EBDD:
    CPY.B #$9C                                ; Center of Mario's body is touching a block on page 0.
    BNE CODE_00EBE8
    LDA.W ObjectTileset
    CMP.B #$01
    BEQ CODE_00EC06
CODE_00EBE8:
; Check if the tile is a door and can be entered.
    CPY.B #$20                                ; Valid conditions are:
    BEQ CODE_00EC01                           ; Tile 9C in the Castle 1 tileset (also don't require being centered)
    CPY.B #$1F                                ; Tile 1F and small
    BEQ CODE_00EBFD                           ; Tile 20
    LDA.W BluePSwitchTimer                    ; Tile 27 and small with blue P-switch active
    BEQ CODE_00EC21                           ; Tile 28 with blue P-switch active
    CPY.B #$28                                ; All other tiles are skipped.
    BEQ CODE_00EC01
    CPY.B #$27
    BNE CODE_00EC21
CODE_00EBFD:
; In front of the top of a door.
    LDA.B Powerup                             ; Skip if Mario is small.
    BNE CODE_00EC24
CODE_00EC01:
; In front of an enterable door.
    JSR CODE_00F443                           ; Skip if Mario is not centered on the tile.
    BCS CODE_00EC24
CODE_00EC06:
    LDA.B TempPlayerAir                       ; Skip if not on the ground.
    BNE CODE_00EC24
    LDA.B byetudlrFrame
    AND.B #$08                                ; Button to enter door (up)
    BEQ CODE_00EC24
    LDA.B #!SFX_DOOROPEN                      ; \ Play sound effect; Door sound effect
    STA.W SPCIO3                              ; /
    JSR CODE_00D273
    LDA.B #$0D                                ; Set as entering a door.
    STA.B PlayerAnimation
    JSR NoButtons
    BRA CODE_00EC24

CODE_00EC21:
; Not in front of a door.
    JSR CODE_00F28C                           ; Handle Mario inside tiles other than doors.
CODE_00EC24:
; Done with BodyInside. Note that this is skipped if the above ran for a solid tile (111-16D).
    JSR CODE_00F44D                           ; Run "MarioSide" interaction point.
    BEQ CODE_00EC35                           ; Branch if touching a tile on page 0.
    CPY.B #$11
    BCC CODE_00EC3A
    CPY.B #$6E                                ; If touching tiles 111-16E, branch, and also skip the next point (HeadInside).
    BCS CODE_00EC3A                           ; Else, we're done here.
    INX
    INX
    BRA CODE_00EC4E

CODE_00EC35:
; Mario's side is touching a tile on page 0.
    LDA.B #$10                                ; Run page 0 interaction routines
    JSR CODE_00F2C9
CODE_00EC3A:
; Done with MarioSide. Note that this is skipped if the above ran for a solid tile (111-16D).
    JSR CODE_00F44D                           ; Run "HeadInside" interaction point.
    BNE CODE_00EC46                           ; Branch if touching a tile on page 1.
    LDA.B #$08                                ; Run page 0 interaction routines.
    JSR CODE_00F2C9
    BRA CODE_00EC8A

CODE_00EC46:
    CPY.B #$11                                ; Mario's head is inside a tile on page 1.
    BCC CODE_00EC8A                           ; Skip this point if tile 100-110 or 16E-1FF.
    CPY.B #$6E
    BCS CODE_00EC8A
CODE_00EC4E:
    LDA.B PlayerDirection
    CMP.B PlayerBlockXSide
    BEQ +                                     ; If facing the block Mario is touching,
    JSR CODE_00F3C4                           ; check if it's a horizontal exit-enabled pipe
    PHX                                       ; or a throwblock, and run interaction appropriately.
    JSR CODE_00F267
    LDY.W Map16TileNumber                     ; Current MAP16 tile number
    PLX
  + LDA.B #$03
    STA.W PlayerPoseLenTimer
    LDY.B PlayerBlockXSide
    LDA.B PlayerXPosNext
    AND.B #$0F
    CMP.W DATA_00E911,Y                       ; If touching the side of a solid block, interact with it.
    BEQ CODE_00EC8A
CODE_00EC6F:
    LDA.W NoteBlockActive
    BEQ CODE_00EC7B
    LDA.W Map16TileNumber                     ; If inside a noteblock (when bouncing on it), don't block.
    CMP.B #$52
    BEQ CODE_00EC8A
CODE_00EC7B:
    LDA.W DATA_00E90A,Y                       ; Set what side of the block is being touched horizontally.
    TSB.B PlayerBlockedDir
    AND.B #$03
    TAY
    LDA.W Map16TileNumber                     ; Current MAP16 tile number
    JSL CODE_00F127                           ; Run interaction code.
CODE_00EC8A:
; Done with HeadInside.
    JSR CODE_00F44D                           ; Run "MarioBelow" interaction point.
    BNE CODE_00ECB1                           ; Branch if touching a tile on page 1.
    LDA.B #$02                                ; Run MarioBelow interaction with various tiles on page 0.
    JSR CODE_00F2C2
    LDY.B PlayerYSpeed+1
    BPL CODE_00ECA3
    LDA.W Map16TileNumber                     ; Current MAP16 tile number
    CMP.B #$21
    BCC CODE_00ECA3                           ; Skip interaction point if not tiles 021-024.
    CMP.B #$25
    BCC +
CODE_00ECA3:
    JMP CODE_00ED4A

; Tiles 021-024 being hit by Mario's head.
  + SEC                                       ; Localize index.
    SBC.B #$04
    LDY.B #$00
    JSL CODE_00F17F                           ; Spawn a bounce sprite and the sprite inside.
    BRA CODE_00ED0D

CODE_00ECB1:
; Tile on page 1 being hit by Mario's head.
    CPY.B #$11                                ; Branch for 100-110 (ledges).
    BCC CODE_00ECA3
    CPY.B #$6E                                ; Branch for 111-16D (solids).
    BCC CODE_00ECFA
    CPY.B #$D8                                ; Branch for 16E-1D7 (slopes).
    BCC CODE_00ECDA                           ; The rest below are 1D8-1FF (non-solids).
    REP #$20                                  ; A->16
    LDA.B TouchBlockYPos
    CLC
    ADC.W #$0010
    STA.B TouchBlockYPos
    JSR CODE_00F461
    BEQ CODE_00ECF8
    CPY.B #$6E
    BCC CODE_00ED4A
    CPY.B #$D8
    BCS CODE_00ED4A
    LDA.B PlayerBlockMoveY
    SBC.B #$0F
    STA.B PlayerBlockMoveY
CODE_00ECDA:
    TYA
    SEC
    SBC.B #$6E
    TAY
    REP #$20                                  ; A->16
    LDA.B [SlopesPtr],Y
    AND.W #$00FF
    ASL A
    ASL A
    ASL A
    ASL A
    SEP #$20                                  ; A->8
    ORA.B PlayerXPosInBlock
    REP #$10                                  ; XY->16
    TAY
    LDA.W DATA_00E632,Y
    SEP #$10                                  ; XY->8
    BMI CODE_00ED0F                           ; Skip down if the slope is upside down (or the inside of a very-steep slope).
CODE_00ECF8:
    BRA CODE_00ED4A

CODE_00ECFA:
; Mario's head is inside a solid tile (111-16D).
    LDA.B #$02                                ; Handle interaction with the downwards-facing exit-enabled pipe.
    JSR CODE_00F3E9
    TYA
    LDY.B #$00                                ; Run solid block interaction.
    JSL CODE_00F127
    LDA.W Map16TileNumber                     ; Current MAP16 tile number
    CMP.B #$1E                                ; \ If block is turn block, branch to $ED3B; Skip to end if inside a turnblock.
    BEQ CODE_00ED3B                           ; /
CODE_00ED0D:
    LDA.B #$F0
CODE_00ED0F:
    CLC                                       ; Skip to next interaction point if ??? (something related to Mario's head Y position?)
    ADC.B PlayerBlockMoveY
    BPL CODE_00ED4A
    CMP.B #$F9
    BCS CODE_00ED28                           ; Branch to push Mario downwards if he's in the air or far enough below the top of the block.
    LDY.B PlayerInAir
    BNE CODE_00ED28
    LDA.B PlayerBlockedDir
    AND.B #$FC                                ; Set blocked bits for inside and above Mario, and clear bit for below him.
    ORA.B #$09
    STA.B PlayerBlockedDir
    STZ.B PlayerXSpeed+1                      ; Clear X speed.
    BRA CODE_00ED3B

CODE_00ED28:
    LDY.B PlayerInAir
    BEQ +
    EOR.B #$FF
    CLC                                       ; If not on the ground, push Mario downwards.
    ADC.B PlayerYPosNext
    STA.B PlayerYPosNext
    BCC +
    INC.B PlayerYPosNext+1
  + LDA.B #$08                                ; Set blocked status bit for above Mario.
    TSB.B PlayerBlockedDir
CODE_00ED3B:
    LDA.B PlayerYSpeed+1
    BPL CODE_00ED4A
    STZ.B PlayerYSpeed+1
    LDA.W SPCIO0                              ; / Play sound effect; If Mario's head hit the block while moving upwards, clear his Y speed and play a "hit" SFX.
    BNE CODE_00ED4A
    INC A                                     ; play bonk only if no other sound was queued
    STA.W SPCIO0                              ; / Play sound effect
CODE_00ED4A:
; Done with MarioBelow.
    JSR CODE_00F44D                           ; Run "MarioAbove" interaction point. This corresponds to whichever of Mario's feet is nearest the center of the block.
    BNE +                                     ; Jump down if on page 0.
    JMP CODE_00EDDB

; Foot touching tile on page 1.
  + CPY.B #$6E                                ; Branch if 16E+ (slopes/corners/lava).
    BCS +
    LDA.B #$03                                ; Handle interaction with the upwards-facing exit-enabled pipe.
    JSR CODE_00F3E9
    JMP CODE_00EDF7                           ; Skip next interaction point (right foot) and run the solid block routines.

; Tiles 16E-1FF.
  + CPY.B #$D8                                ; Branch if touching 16E-1D7 (slopes).
    BCC CODE_00ED86
    CPY.B #$FB                                ; Jump up to kill Mario if touching 1FB-1FF (lava).
    BCC +                                     ; If touching 1D8-1FB (corners), continue below.
    JMP CODE_00F629

  + REP #$20                                  ; A->16; Touching the top of a corner (1D8-1FB).
    LDA.B TouchBlockYPos
    SEC
    SBC.W #$0010                              ; Get "acts like" setting for the block above the corner.
    STA.B TouchBlockYPos
    JSR CODE_00F461
    BEQ CODE_00EDE9
    CPY.B #$6E
    BCC CODE_00EDE9
    CPY.B #$D8                                ; Change interaction to that tile if it's a slope.
    BCS CODE_00EDE9
    LDA.B PlayerYPosInBlock
    ADC.B #$10
    STA.B PlayerYPosInBlock
CODE_00ED86:
    LDA.W ObjectTileset                       ; Touching the top of a slope.
    CMP.B #$03
    BEQ CODE_00ED91
    CMP.B #$0E                                ; Branch for tile 1D2-1D7 if in tilesets 3/E.
    BNE CODE_00ED95                           ; (i.e. lava slopes)
CODE_00ED91:
    CPY.B #$D2
    BCS CODE_00EDE9
CODE_00ED95:
    TYA
    SEC
    SBC.B #$6E
    TAY
    LDA.B [SlopesPtr],Y
    PHA
    REP #$20                                  ; A->16
    AND.W #$00FF
    ASL A
    ASL A
    ASL A
    ASL A
    SEP #$20                                  ; A->8
    ORA.B PlayerXPosInBlock
    PHX
    REP #$10                                  ; XY->16; Push Mario on top of the ledge/slope if in range of its "top".
    TAX                                       ; If he's not in that range, branch down.
    LDA.B PlayerYPosInBlock
    SEC
    SBC.W DATA_00E632,X
    BPL +
    INC.W PlayerIsOnGround
  + SEP #$10                                  ; XY->8
    PLX
    PLY
    CMP.W DATA_00E51C,Y
    BCS CODE_00EDE9
    STA.B PlayerBlockMoveY
    STZ.B PlayerYPosInBlock
    JSR CODE_00F005                           ; Handle purple triangles.
    CPY.B #$1C                                ; Branch if not "very steep" slopes.
    BCC +
    LDA.B #$08                                ; Slide Mario without showing sliding image.
    STA.W SkidTurnTimer
    JMP CODE_00EED1                           ; Skip rest of slope handling.

; On a slope that is not the very steep slope.
  + JSR CODE_00EFBC                           ; Handle conveyor slopes.
    JMP CODE_00EE85

CODE_00EDDB:
; MarioAbove for tile on page 0.
    CPY.B #$05                                ; Branch if not tile 005 (lava).
    BNE CODE_00EDE4
    JSR CODE_00F629                           ; Kill Mario.
    BRA CODE_00EDE9

CODE_00EDE4:
    LDA.B #$04                                ; Run MarioAbove interaction with various tiles on page 0.
    JSR CODE_00F2C2
CODE_00EDE9:
; Done with MarioAbove. Note that slopes skip halfway down this routine (to $00EED1).
    JSR CODE_00F44D                           ; Run "TopCorner" interaction point. This handles the foot not covered by MarioAbove.
    BNE CODE_00EDF3                           ; Branch if the tile is on page 1.
    JSR CODE_00F309                           ; Handle interaction is page 0, and then branch.
    BRA CODE_00EE1D

CODE_00EDF3:
; On top of tile on page 1.
    CPY.B #$6E                                ; Branch if not a tile that is solid on top (100-16D).
    BCS CODE_00EE1D
CODE_00EDF7:
    LDA.B PlayerYSpeed+1                      ; Return if moving upwards (pass through top).
    BMI Return00EE39
    LDA.W ObjectTileset
    CMP.B #$03
    BEQ CODE_00EE06
    CMP.B #$0E
    BNE CODE_00EE11                           ; Tiles 159-15B (tileset-specific lava) have a non-solid top
CODE_00EE06:
; in tilesets 03/0E (underground 1/3).
    LDY.W Map16TileNumber                     ; $ED3B; Essentially, this makes Mario fall inside them.
    CPY.B #$59                                ; In all other tilesets, they're just a solid block.
    BCC CODE_00EE11
    CPY.B #$5C
    BCC CODE_00EE1D
CODE_00EE11:
    LDA.B PlayerYPosInBlock
    AND.B #$0F
    STZ.B PlayerYPosInBlock                   ; Branch if the player is on top of the block.
    CMP.B #$08
    STA.B PlayerBlockMoveY
    BCC CODE_00EE3A
CODE_00EE1D:
; Player is not on top of this tile.
    LDA.W StandOnSolidSprite                  ; \ If Mario isn't on a sprite platform,; Branch if not standing on top of a sprite.
    BEQ +                                     ; / branch to $EE2D
    LDA.B PlayerYSpeed+1                      ; \ If Mario is moving up,
    BMI +                                     ; / branch to $EE2D
    STZ.B TempScreenMode
    LDY.B #$20
    JMP CODE_00EEE1

  + LDA.B PlayerBlockedDir                    ; \
    AND.B #$04                                ; |If Mario is on an edge or in air,; Return if Mario is standing on something or has already been set as in midair.
    ORA.B PlayerInAir                         ; |branch to $EE39
    BNE Return00EE39                          ; /
CODE_00EE35:
    LDA.B #$24                                ; \ Set "In air" to x24 (falling); Set Mario as being in midair and falling.
    STA.B PlayerInAir                         ; /
Return00EE39:
    RTS

CODE_00EE3A:
    LDY.W Map16TileNumber                     ; Current MAP16 tile number; On top of a solid block/ledge.
    LDA.W ObjectTileset                       ; Tileset
    CMP.B #$02                                ; \ If tileset is "Rope 1",
    BEQ CODE_00EE48                           ; / branch to $EE48
    CMP.B #$08                                ; \ If tileset isn't "Rope 3",; Branch if:
    BNE CODE_00EE57                           ; / branch to $EE57; Not in tileset 2/8 (rope 1/3).
CODE_00EE48:
    TYA                                       ; \; Not tiles 10C/10D (the rope conveyors).
    SEC                                       ; |If the current tile isn't Rope 3's "Conveyor rope",
    SBC.B #$0C                                ; |branch to $EE57
    CMP.B #$02                                ; |
    BCS CODE_00EE57                           ; /
    ASL A
    TAX
    JSR CODE_00EFCD                           ; Push Mario to the side.
    BRA CODE_00EE83

CODE_00EE57:
    JSR CODE_00F267                           ; Run throwblock code, if applicable.
    LDY.B #$03
    LDA.W Map16TileNumber                     ; Current MAP16 tile number
    CMP.B #$1E                                ; \ If block isn't "Turn block",; Branch if not a turnblock.
    BNE CODE_00EE78                           ; / branch to $EE78
    LDX.B TempPlayerAir
    BEQ CODE_00EE83
    LDX.B Powerup                             ; Branch if not in the air, small, or not spinjumping.
    BEQ CODE_00EE83
    LDX.W SpinJumpFlag
    BEQ CODE_00EE83
    LDA.B #$21                                ; Break the turnblock.
    JSL CODE_00F17F
    BRA CODE_00EE1D

CODE_00EE78:
    CMP.B #$32                                ; \ If block isn't "Brown block",
    BNE +                                     ; / branch to $EE7F; If tile 132 (brown block), start the creating/eating sprite.
    STZ.W BlockSnakeActive
  + JSL CODE_00F120                           ; Interact with the block.
CODE_00EE83:
    LDY.B #$20                                ; Indicate that Mario is not on a slope.
CODE_00EE85:
    LDA.B PlayerYSpeed+1                      ; \ If Mario isn't moving up,
    BPL CODE_00EE8F                           ; / branch to $EE8F
    LDA.B TempPlayerGround                    ; Return if rising and not on the ground already (i.e. not interacting with the top of blocks).
    CMP.B #$02
    BCC Return00EE39
CODE_00EE8F:
    LDX.W SwitchPalacePressed                 ; Skip the rest of the interaction if not activating a switch palace switch.
    BEQ CODE_00EED1
    DEX
    TXA                                       ; Branch if the top-left of the switch was touched.
    AND.B #$03
    BEQ CODE_00EEAA
    CMP.B #$02                                ; Skip the rest of the interaction if the bottom half of the switch was touched.
    BCS CODE_00EED1
    REP #$20                                  ; A->16
    LDA.B TouchBlockXPos
    SEC                                       ; Move block position left one tile (to properly erase the switch).
    SBC.W #$0010
    STA.B TouchBlockXPos
    SEP #$20                                  ; A->8
CODE_00EEAA:
    TXA
    LSR A
    LSR A
    TAX
    LDA.W SwitchBlockFlags,X                  ; \ If switch block is already active,
    BNE CODE_00EED1                           ; / branch to $EED1; Set the corresponding ! block flag (if not already set),
    INC A                                     ; \ Activate switch block; and tell the game to prepare the OW switch blocks.
    STA.W SwitchBlockFlags,X                  ; /
    STA.W SwitchPalaceColor
    PHY
    STX.W BigSwitchPressTimer                 ; Spawn a pressed switch palace switch.
    JSR FlatPalaceSwitch
    PLY
    LDA.B #!BGM_LEVELCLEAR                    ; SFX for the pressed switch music.
    STA.W SPCIO2                              ; / Change music
    LDA.B #$FF                                ; \; Set music flag for level being over.
    STA.W MusicBackup                         ; / Set music to xFF
    LDA.B #$08                                ; Set end level timer.
    STA.W EndLevelTimer
CODE_00EED1:
    INC.W PlayerIsOnGround                    ; Slopes re-enter here.
    LDA.B PlayerYPosNext
    SEC
    SBC.B PlayerBlockMoveY
    STA.B PlayerYPosNext                      ; Push Mario on top of the block.
    LDA.B PlayerYPosNext+1
    SBC.B PlayerYPosInBlock
    STA.B PlayerYPosNext+1
CODE_00EEE1:
    LDA.W DATA_00E53D,Y
    BNE CODE_00EEEF                           ; Branch if not on a slope.
    LDX.W PlayerSlopePose
    BEQ CODE_00EF05
    LDX.B PlayerXSpeed+1                      ; If stationary, don't slide.
    BEQ CODE_00EF02
CODE_00EEEF:
    STA.W CurrentSlope
    LDA.B byetudlrHold
    AND.B #$04
    BEQ CODE_00EF05
    LDA.W IsCarryingItem
    ORA.W PlayerSlopePose                     ; If down is pressed and Mario is not carrying an item or flying, start sliding.
    BNE CODE_00EF05
    LDX.B #$1C
CODE_00EF02:
    STX.W PlayerSlopePose
CODE_00EF05:
    LDX.W DATA_00E4B9,Y                       ; Store current slope value for Mario.
    STX.W SlopeType
    CPY.B #$1C
    BCS CODE_00EF38
    LDA.B PlayerXSpeed+1
    BEQ CODE_00EF31
    LDA.W DATA_00E53D,Y
    BEQ CODE_00EF31
    EOR.B PlayerXSpeed+1
    BPL CODE_00EF31                           ; If not running fast enough up the slope (or not on a slope at all),
    STX.W PlayerPoseLenTimer                  ; use standard ground Y speed.
    LDA.B PlayerXSpeed+1                      ; Else, give a special upwards Y speed.
    BPL +
    EOR.B #$FF
    INC A
  + CMP.B #con($28,$28,$28,$34,$34)
    BCC CODE_00EF2F
    LDA.W DATA_00E4FB,Y                       ; Set Mario's Y speed while running up the slope.
    BRA CODE_00EF60

CODE_00EF2F:
    LDY.B #$20
CODE_00EF31:
    LDA.B PlayerYSpeed+1
    CMP.W DATA_00E4DA,Y
    BCC +                                     ; Get Y speed to give Mario while standing still on the ground. Accounts for slopes.
CODE_00EF38:
    LDA.W DATA_00E4DA,Y
  + LDX.B TempScreenMode                      ; Branch if collision with layer 2 is disabled.
    BPL CODE_00EF60
    INC.W Layer2Touched
    PHA
    REP #$20                                  ; A->16
    LDA.W Layer2DYPos
    AND.W #$FF00
    BPL +
    ORA.W #$00FF
  + XBA                                       ; Move Mario with layer 2.
    EOR.W #$FFFF
    INC A
    CLC
    ADC.B PlayerXPosNext
    STA.B PlayerXPosNext
    SEP #$20                                  ; A->8
    PLA
    CLC                                       ; Adjust Mario's Y speed for layer 2.
    ADC.B #$28
CODE_00EF60:
    STA.B PlayerYSpeed+1
    TAX
    BPL +                                     ; If Mario's Y speed is positive (i.e. running up a slope), increase the ground flag.
    INC.W PlayerIsOnGround
  + STZ.W StandingOnCage                      ; Clear unused wing cage flag.
    STZ.B PlayerInAir                         ; Clear "in-air" flag.
    STZ.B PlayerIsClimbing                    ; Clear climbing flag.
    STZ.W BouncingOnBoard                     ; Clear flag for having bounced off a springboard.
    STZ.W SpinJumpFlag                        ; Clear spinjump flag.
    LDA.B #$04                                ; Set blocked status for below Mario.
    TSB.B PlayerBlockedDir
    LDY.W FlightPhase                         ; Branch if landing from cape flight.
    BNE CODE_00EF99
    LDA.W PlayerRidingYoshi
    BEQ +
    LDA.B TempPlayerAir
    BEQ +
    LDA.W YoshiCanStomp                       ; \ If Yoshi has stomp ability,; Handle Yoshi stomping the ground, if applicable.
    BEQ +                                     ; |
    JSL YoshiStompRoutine                     ; | Run routine
    LDA.B #!SFX_YOSHISTOMP                    ; | Play sound effect; SFX to play when Yoshi stomps the ground.
    STA.W SPCIO3                              ; /
  + STZ.W SpriteStompCounter                  ; Clear enemy bounce counter.
    RTS

CODE_00EF99:
    STZ.W SpriteStompCounter                  ; Mario is landing from cape flight.
    STZ.W FlightPhase
    CPY.B #$05
    BCS CallGroundPound
    LDA.B Powerup
    CMP.B #$02
    BNE +
    SEC
    ROR.W PlayerSlopePose
  + RTS

CallGroundPound:
    LDA.B TempPlayerAir
    BEQ +
    JSL GroundPound
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + RTS

CODE_00EFBC:
    LDX.W Map16TileNumber                     ; Conveyor slopes.
    CPX.B #$CE
    BCC +                                     ; Return if not tiles 1CE-1D1 (conveyors)
    CPX.B #$D2
    BCS +
    TXA
    SEC
    SBC.B #$CC
    ASL A
    TAX
CODE_00EFCD:
    LDA.B TrueFrame                           ; Normal conveyors come in here too.
    AND.B #$03                                ; Move Mario only every fourth frame.
    BNE +
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    CLC
    ADC.W DATA_00E913,X
    STA.B PlayerXPosNext                      ; Shift Mario.
    LDA.B PlayerYPosNext
    CLC
    ADC.W DATA_00E91F,X
    STA.B PlayerYPosNext
    SEP #$20                                  ; A->8
  + RTS

CODE_00EFE8:
    JSR CODE_00F44D                           ; Run "WallSide" interaction point.
    BNE +
    JMP CODE_00F309

  + CPY.B #$11
    BCC +
    CPY.B #$6E
    BCS +
    TYA
    LDY.B #$00
    JSL CODE_00F160
    PLA
    PLA
    JMP ADDR_00EB42

  + RTS

CODE_00F005:
    TYA                                       ; Subroutine to handle the purple triangles.
    SEC
    SBC.B #$0E                                ; Return if the tile is not one of the purple triangles.
    CMP.B #$02
    BCS Return00F04C
    EOR.B #$01
    CMP.B PlayerDirection                     ; Return if Mario isn't facing up the triangle.
    BNE Return00F04C
    TAX
    LSR A
    LDA.B PlayerXPosInBlock
    BCC +
    EOR.B #$0F                                ; Return if not halfway up the triangle.
  + CMP.B #con($08,$08,$08,$09,$09)
    BCS Return00F04C
    LDA.W PlayerRidingYoshi                   ; Branch if not riding Yoshi.
    BEQ +
    LDA.B #!SFX_SPRING                        ; SFX for bounce off a purple triangle.
    STA.W SPCIO3                              ; / Play sound effect
    LDA.B #$80                                ; Y speed to give Mario when bouncing off a purple triangle with Yoshi.
    STA.B PlayerYSpeed+1
    STA.W BouncingOnBoard
    PLA
    PLA
    JMP CODE_00EE35

  + LDA.B PlayerXSpeed+1                      ; Running up a purple triangle while not on Yoshi.
    SEC
    SBC.W DATA_00EAB9,X                       ; Return if not running fast enough to start a wallrun.
    EOR.W DATA_00EAB9,X
    BMI Return00F04C
    LDA.W IsCarryingItem
    ORA.B PlayerIsDucking                     ; Return if holding an item or ducking.
    BNE Return00F04C
    INX
    INX                                       ; Start the wallrun.
    STX.W WallrunningType
Return00F04C:
    RTS

CODE_00F04D:
    PHX                                       ; Subroutine to check whether a slope tile is in water or not. Returns carry clear if not.
    LDX.B #$19
CODE_00F050:
    CMP.L DATA_00EAC1,X
    BEQ CODE_00F05A                           ; Check whether the tile one of the ones in water.
    DEX
    BPL CODE_00F050
    CLC
CODE_00F05A:
    PLX
    RTL


DATA_00F05C:
    db $01,$05,$01,$02,$01,$01,$00,$00
    db $00,$00,$00,$00,$00,$06,$02,$02
    db $02,$02,$02,$02,$02,$02,$02,$02
    db $02,$03,$03,$04,$02,$02,$02,$01
    db $01,$07,$11,$10

DATA_00F080:
    db $80,$00,$00,$1E,$00,$00,$05,$09
    db $06,$81,$0E,$0C,$14,$00,$05,$09
    db $06,$07,$0E,$0C,$16,$18,$1A,$1A
    db $00,$09,$00,$00,$FF,$0C,$0A,$00
    db $00,$00,$08,$02

DATA_00F0A4:
    db $0C,$08,$0C,$08,$0C,$0F,$08,$08
    db $08,$08,$08,$08,$08,$08,$08,$08
    db $08,$08,$08,$08,$08,$08,$08,$08
    db $08,$03,$03,$08,$08,$08,$08,$08
    db $08,$04,$08,$08

DATA_00F0C8:
    db $0E,$13,$0E,$0D,$0E,$10,$0D,$0D
    db $0D,$0D,$0A,$0D,$0D,$0C,$0D,$0D
    db $0D,$0D,$0B,$0D,$0D,$16,$0D,$0D
    db $0D,$11,$11,$12,$0D,$0D,$0D,$0E
    db $0F,$0C,$0D,$0D

DATA_00F0EC:
    db $08,$01,$02,$04,$ED,$F6,$00,$7D
    db $BE,$00,$6F,$B7

DATA_00F0F8:
    db $40,$50,$00,$70,$80,$00,$A0,$B0
DATA_00F100:
    db $05,$09,$06,$05,$09,$06,$05,$09
    db $06,$05,$09,$06,$05,$09,$06,$05
    db $07,$0A,$10,$07,$0A,$10,$07,$0A
    db $10,$07,$0A,$10,$07,$0A,$10,$07

CODE_00F120:
; Bounce block animation table. See http://acmlm.kafuka.org/board/thread.php?id=5741
; Block order is:
; $00-$1C = 111-12D
; $1D-$20 = 021-024
; $21 = broken turnblock, $22 = green ! block, $23 = yellow ! block
; Table of sprites to spawn out of certain Map16 blocks. See http://acmlm.kafuka.org/board/thread.php?id=5741
; Same block order as above.
; Table of which side the blocks will get "hit" by. ----btrl.
; b = bottom, t = top, r = right, l = left
; Same block order as above.
; List of values to store to $9C for each block when restored back to normal.
; Same block order as above.
; Table of values for which side the current block is being touched from. ---btrl.
; Values for the bonus game to determine whether the last block hit was the "third" block in a row.
; Indexed by X position (mod 16). Note that this means the 4 values before and after the table may also be used.
; Sprites for an unused block (flower/feather/star) and block 11A (star2/1up/vine).
; Index is 000b xxxx, where b = which block, and xxxx = x position.
; Each value is in the same format as $00F080.
    XBA                                       ; Routine to run solid block interaction. This first part checks if it should hurt you.
    LDA.W PlayerRidingYoshi                   ; Check if on Yoshi. If so, munchers/spikes don't hurt you.
    BNE CODE_00F15F
    XBA
CODE_00F127:
; Alternate entry to the solid block interaction routine that skips Yoshi's damage exception (for when touched from a side other than below).
    CMP.B #$2F                                ; Check if the block is a muncher. If so, hurt Mario.
    BEQ CODE_00F154
    CMP.B #$59
    BCC CODE_00F144
    CMP.B #$5C
    BCS CODE_00F140
    XBA                                       ; Check if a spike (59-5C). If not, don't hurt Mario.
    LDA.W ObjectTileset                       ; If the tileset is also 05 or 0D (Ghost House, therefore spikes), hurt Mario.
    CMP.B #$05
    BEQ CODE_00F154
    CMP.B #$0D
    BEQ CODE_00F154
    XBA
CODE_00F140:
    CMP.B #$5D
    BCC CODE_00F14C
CODE_00F144:
    CMP.B #$66
    BCC CODE_00F160
    CMP.B #$6A                                ; Check if Mario is touching spikes in a castle (including the smashers). If not, don't hurt Mario.
    BCS CODE_00F160
CODE_00F14C:
    XBA
    LDA.W ObjectTileset
    CMP.B #$01
    BNE CODE_00F15F
CODE_00F154:
    PHB
    LDA.B #$01
    PHA                                       ; Hurt Mario,
    PLB
    JSL HurtMario
    PLB
    RTL

CODE_00F15F:
    XBA                                       ; Not a block that hurts Mario; check if it's hittable.
CODE_00F160:
    SEC
    SBC.B #$11                                ; If the tile is a block that contains something (111-12E), offset it to the bounce block tables and branch.
    CMP.B #$1D
    BCC CODE_00F17F
    XBA
    PHX
    LDX.W ObjectTileset
    LDA.L DATA_00A625,X
    PLX
    AND.B #$03
    BEQ +                                     ; Return if:
    RTL                                       ; in tileset T:4

; block is not a yellow/green ! block
  + XBA                                       ; Else, offset into the bounce block tables as index x22.
    SBC.B #$59
    CMP.B #$02
    BCS Return00F1F8
    ADC.B #$22
CODE_00F17F:
; Subroutine for blocks that use bounce sprites and spawn something when hit. See usage below.
    PHX                                       ; Y = direction touching block from (0 = bottom, 1 = left, 2 = right, 3 = top)
    PHA                                       ; A = Block number, offset (Map16 111-12D, 021-024, 16A, 16B).
    TYX
    LDA.L DATA_00F0EC,X
    PLX                                       ; If the block is not activated from this direction, return with carry clear.
    AND.L DATA_00F0A4,X
    BEQ CODE_00F1F6
    STY.B _6                                  ; Store directions the block is activated from to $06.
    LDA.L DATA_00F0C8,X                       ; Store what block the block will turn into when activated to $07.
    STA.B _7
    LDA.L DATA_00F05C,X                       ; Store what sprite to use for the bounce animation to $04.
    STA.B _4
    LDA.L DATA_00F080,X
    BPL CODE_00F1BA                           ; Handle figuring out what sprite to give (stores to $05).
    CMP.B #$FF
    BNE CODE_00F1AE
    LDA.B #$05
    LDY.W GreenStarBlockCoins                 ; If #$FF was loaded, it's a green star block; give either a 1-up or coin depending on how many coins Mario has collected.
    BEQ CODE_00F1D0
    BRA CODE_00F1CE

CODE_00F1AE:
    LSR A
    LDA.B TouchBlockXPos
    ROR A                                     ; If 80 or 81 was loaded, get sprite to spawn corresponding to position and block number.
    LSR A                                     ; Index is in the format 000b xxxx
    LSR A                                     ; b = block type, xxxx = block x position
    LSR A                                     ; (0 = flower/feather/star, 1 = star2/1up/vine)
    TAX
    LDA.L DATA_00F100,X
CODE_00F1BA:
    LSR A
    BCC CODE_00F1D0
    CMP.B #$03                                ; If bit 0 is clear, spawn the sprite as normal.
    BEQ CODE_00F1C9
    LDY.B Powerup
    BNE CODE_00F1D0                           ; If it's set, either give a mushroom if Mario is small...
    LDA.B #$01
    BRA CODE_00F1D0

CODE_00F1C9:
    LDY.W InvinsibilityTimer                  ; \ Branch if Mario has star
    BNE CODE_00F1D0                           ; /; ...or, if it would spawn a star and Mario doesn't have star power, give a coin instead.
CODE_00F1CE:
    LDA.B #$06
CODE_00F1D0:
    STA.B _5
    CMP.B #$05
    BNE +                                     ; If spawning a 1-up, always turn into a brown "used" block and set the item memory bit for the block.
    LDA.B #$16
    STA.B _7
  + TAY
    LDA.B #$0F
    TRB.B TouchBlockXPos
    TRB.B TouchBlockYPos
    CPY.B #$06
    BNE CODE_00F1EC
    LDY.W ObjectTileset                       ; Branch if spawning a coin in the switch palace tileset.
    CPY.B #$04
    BEQ +
CODE_00F1EC:
    PHB
    LDA.B #$02
    PHA
    PLB
    JSL CODE_028752                           ; Spawn an item and bounce sprite.
    PLB
CODE_00F1F6:
    PLX
    CLC
Return00F1F8:
    RTL

  + LDA.B TouchBlockYPos+1                    ; Subroutine to handle coinblocks in bonus rooms/switch palaces.
    LSR A
    LDA.B TouchBlockYPos
    AND.B #$C0                                ; Y = Y position of block (i.e. current row, 0-7)
    ROL A
    ROL A
    ROL A
    TAY
    LDA.B TouchBlockXPos
    LSR A
    LSR A                                     ; X = X position of block
    LSR A
    LSR A
    TAX
    LDA.W PBalloonInflating,Y
    ORA.L DATA_00F0EC,X
    LDX.W PBalloonInflating,Y                 ; This whole bit is handling the coinblock row in a bonus game ($13F4 is the top row).
    STA.W PBalloonInflating,Y                 ; Each block is assigned a special value, and each time a block is hit that value is bitwise-ORed to the row's value.
    CMP.B #$FF                                ; If the row's value then becomes #$FF, continue below to give a 1-up.
    BNE CODE_00F226                           ; Else, branch down to determine whether the block was correct or not based on the current frame.
    LDA.B #$05
    STA.B _5
CODE_00F220:
    LDA.B #$17                                ; "Correct" block.
    STA.B _7                                  ; Turn into a "correct" block.
    BRA CODE_00F1EC

CODE_00F226:
    LDA.W DidPlayBonusGame                    ; If the bonus room has been entered before, always register "wrong".
    BNE CODE_00F236
    TXA
    BEQ +
    LDA.B #$02                                ; Decide whether to make the block correct or incorrect based on the frame.
; Increase chance of getting correct when hitting the second block.
  + EOR.B #$03                                ; (1/4 for the first block, 1/2 for the second)
    AND.B TrueFrame
    BNE CODE_00F220
CODE_00F236:
; "Wrong" block.
    LDA.B #!SFX_WRONG                         ; SFX for hitting the wrong coin block.
    STA.W SPCIO3                              ; / Play sound effect
    PHY
    STZ.B _5
    PHB
    LDA.B #$02                                ; \ Set data bank = $02; Spawn a coin and bounce sprite.
    PHA                                       ; |
    PLB
    JSL CODE_028752
    PLB
    PLY
    LDX.B #$07
    LDA.W PBalloonInflating,Y
CODE_00F24E:
    LSR A
    BCS +
    PHA
    LDA.B #$0D                                ; \ Block to generate = Used block
    STA.B Map16TileGenerate                   ; /
    LDA.L DATA_00F0F8,X
    STA.B TouchBlockXPos
    JSL GenerateTile
    PLA
  + DEX
    BPL CODE_00F24E
    JMP CODE_00F1F6

CODE_00F267:
    CPY.B #$2E                                ; Routine to handle throwblocks.
    BNE Return00F28B                          ; Return if:
    BIT.B byetudlrFrame                       ; Not tile 12E (throwblock).
    BVC Return00F28B                          ; X/Y not pressed.
    LDA.W IsCarryingItem                      ; Already holding something.
    ORA.W PlayerRidingYoshi                   ; Riding Yoshi.
    BNE Return00F28B
    LDA.B #$02
    PHA                                       ; Spawn a throwblock.
    PLB                                       ; If no empty sprite slots are available, don't let Mario pick up the block.
    JSL CODE_02862F
    BMI +
    LDA.B #$02                                ; \ Block to generate = #$02
    STA.B Map16TileGenerate                   ; /; Erase the tile.
    JSL GenerateTile
  + PHK
    PLB
Return00F28B:
    RTS

CODE_00F28C:
    TYA                                       ; Routine to handle the invisible 1-up checkpoints (also called when Mario's body is inside any page 0 tile other than a door).
    SEC
    SBC.B #$6F                                ; Branch if not one of the four invisible 1-up checkpoints.
    CMP.B #$04
    BCS CODE_00F2C0
    CMP.W OneUpCheckpoints
    BEQ CODE_00F2A8
    INC A
    CMP.W OneUpCheckpoints
    BEQ +
    LDA.W OneUpCheckpoints
    CMP.B #$04
    BCS +
    LDA.B #$FF
CODE_00F2A8:
    INC A
    STA.W OneUpCheckpoints
    CMP.B #$04
    BNE +
    PHX
    JSL TriggerInivis1Up                      ; Spawn a 1up.
    JSR CODE_00F3B2
    ORA.W Checkpoint1upCollected,Y            ; Set the bit for having collected the level's invisible 1up.
    STA.W Checkpoint1upCollected,Y
    PLX
  + RTS

CODE_00F2C0:
; Inside a tile on page 0 other than a door or invisible 1-up checkpoint.
    LDA.B #$01                                ; Note that the tile is currently specifically being processed from MarioBody.
CODE_00F2C2:
; Interaction routine for various tiles on page 0. Y contains tile number, A contains flags for which interaction point is running (see $74).
    CPY.B #$06                                ; If tile 006+, branch below.
    BCS CODE_00F2C9
    TSB.B InteractionPtsInWater               ; For tiles 000-005 (water/lava), set $8A and return.
    RTS

CODE_00F2C9:
; Not tiles 000-005.
    CPY.B #$38                                ; Branch if not tile 038 (midpoint).
    BNE CODE_00F2EE
    LDA.B #$02                                ; \ Block to generate = #$02; Midpoint interaction.
    STA.B Map16TileGenerate                   ; /; Turn into a blank tile.
    JSL GenerateTile
    JSR CODE_00FD5A                           ; Display a glitter effect.
    LDA.W DisableMidway
    BEQ +                                     ; Set midpoint flag if applicable.
    JSR CODE_00CA2B
  + LDA.B Powerup
    BNE +                                     ; Make Mario big.
    LDA.B #$01
    STA.B Powerup
  + LDA.B #!SFX_MIDWAY                        ; SFX for hitting a midpoint.
    STA.W SPCIO0                              ; / Play sound effect
    RTS

CODE_00F2EE:
    CPY.B #$06                                ; Not tiles 000-005 or 038.
    BEQ CODE_00F2FC
    CPY.B #$07                                ; Branch if not tiles 006-01C (vine/nets).
    BCC CODE_00F309
    CPY.B #$1D
    BCS CODE_00F309
    ORA.B #$80                                ; Mark that Mario is on a net (not a vine).
CODE_00F2FC:
    CMP.B #$01                                ; Vine/net interaction.
    BNE +                                     ; Preserve the interaction point flags.
    ORA.B #$18                                ; If on a vine, set the side-body flag to prevent horizontal movement.
  + TSB.B InteractionPtsClimbable
    LDA.B PlayerBlockXSide                    ; Preserve the side of the vine/net that Mario is on.
    STA.B InteractionPtDirection
    RTS

CODE_00F309:
    CPY.B #$2F                                ; Not 000-01C or 038.
    BCS CODE_00F311                           ; Branch if tiles 02A-02E (coins).
    CPY.B #$2A
    BCS CODE_00F32B
CODE_00F311:
    CPY.B #$6E                                ; Return if not 06E (moon).
    BNE Return00F376
; Moon interaction.
    LDA.B #$0F                                ; Give a 3up.
    JSL CODE_00F38A
    INC.W MoonCounter
    PHX
    JSR CODE_00F3B2
    ORA.W MoonCollected,Y                     ; Set the bit for having collected the level's 3up mooon.
    STA.W MoonCollected,Y
    PLX
    BRA CODE_00F36B                           ; Erase the tile.

CODE_00F32B:
    BNE CODE_00F332                           ;YOSHI COIN HANDLER; Tiles 02A-02E (coins).
    LDA.W BluePSwitchTimer                    ; Return if tile 02A without the blue P-switch active.
    BEQ Return00F376
CODE_00F332:
    CPY.B #$2D
    BEQ CODE_00F33F
    BCC CODE_00F367                           ; If not tile 02D/02E (Yoshi coin), branch.
    LDA.B TouchBlockYPos                      ; If tile 02E (lower half), shift the position up a tile.
    SEC
    SBC.B #$10
    STA.B TouchBlockYPos
CODE_00F33F:
    JSL CODE_00F377                           ; Register Yoshi coin and give points.
    INC.W DragonCoinsShown
    LDA.W DragonCoinsShown
    CMP.B #$05
    BCC +                                     ; If five coins are collected,
    PHX                                       ; set the bit for all five Yoshi coins collected in the level.
    JSR CODE_00F3B2
    ORA.W AllDragonCoinsCollected,Y
    STA.W AllDragonCoinsCollected,Y
    PLX
  + LDA.B #!SFX_DRAGONCOIN                    ; SFX for collecting a Yoshi coin.
    STA.W SPCIO0                              ; / Play sound effect
    LDA.B #$01                                ; Give Mario a coin.
    JSL CODE_05B330
    LDY.B #$18                                ; Generate two blank tiles.
    BRA +

CODE_00F367:
; Tiles 02A-02C.
    JSL CODE_05B34A                           ; Give a coin.
CODE_00F36B:
    LDY.B #$01                                ; \ Block to generate = #$01; Generate a blank tile.
  + STY.B Map16TileGenerate                   ; /
    JSL GenerateTile                          ; Turn into a specified tile and spawn glitter.
    JSR CODE_00FD5A
Return00F376:
    RTS

CODE_00F377:
    LDA.W DragonCoinsCollected                ; Subroutine to give a Yoshi coin.
    INC.W DragonCoinsCollected
    CLC
    ADC.B #$09
    CMP.B #$0D                                ; Increase coin counter and give appropriate number of points.
    BCC +
    LDA.B #$0D
  + BRA CODE_00F38A

CODE_00F388:
    LDA.B #$0D                                ; Subroutine to spawn a 1up score sprite at Mario's position.
CODE_00F38A:
    PHA                                       ; Subroutine to spawn a score sprite at Mario's position.
    JSL CODE_02AD34                           ; Find a score sprite slot.
    PLA
    STA.W ScoreSpriteNumber,Y
    LDA.B PlayerXPosNext
    STA.W ScoreSpriteXPosLow,Y
    LDA.B PlayerXPosNext+1                    ; Spawn the score sprite at Mario's position.
    STA.W ScoreSpriteXPosHigh,Y
    LDA.B PlayerYPosNext
    STA.W ScoreSpriteYPosLow,Y
    LDA.B PlayerYPosNext+1
    STA.W ScoreSpriteYPosHigh,Y
    LDA.B #$30                                ; Number of frames to display the score sprite.
    STA.W ScoreSpriteTimer,Y
    LDA.B #$00                                ; Spawn in the foreground.
    STA.W ScoreSpriteLayer,Y
    RTL

CODE_00F3B2:
    LDA.W TranslevelNo                        ; Subroutine to get the the bitwise index for any 12 byte level tables (e.g. Yoshi coins, 1ups, moons, etc).
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W TranslevelNo
    AND.B #$07
    TAX
    LDA.L DATA_05B35B,X
    RTS

CODE_00F3C4:
; Subroutine for handling interaction with exit-enabled horizontal pipes.
    CPY.B #$3F                                ; Return if not tile 13F (exit-enabled horizontal pipe).
    BNE Return00F376
    LDY.B TempPlayerAir
    BEQ +
    JMP CODE_00F43F

  + PHX
    TAX
    LDA.B PlayerXPosNext
    TXY
    BEQ +
    EOR.B #$FF
    INC A
  + AND.B #$0F
    ASL A
    CLC
    ADC.B #$20
    LDY.B #$05
    BRA CODE_00F40A


DATA_00F3E3:
    db $0A,$FF

DATA_00F3E5:
    db $02,$01,$08,$04

CODE_00F3E9:
; Input that needs to be held to enter each pipe.
; Right-facing, left-facing, down-facing, up-facing.
; Subroutine for handling interaction with exit-enabled vertical pipes.
    XBA                                       ; A contains the direction to check (0 = left, 1 = right, 2 = up, 3 = down).
    TYA
    SEC
    SBC.B #$37                                ; Return if not an exit-enabled vertical pipe.
    CMP.B #$02
    BCS Return00F442
    TAY
    LDA.B PlayerXPosInBlock
    SBC.W DATA_00F3E3,Y
    CMP.B #$05
    BCS CODE_00F43F
    PHX
    XBA
    TAX
    LDA.B #$20
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$30
  + LDY.B #$06
CODE_00F40A:
    STA.B PipeTimer
    LDA.B byetudlrHold
    AND.W DATA_00F3E5,X
    BEQ CODE_00F43E
    STA.B SpriteLock
    AND.B #$01
    STA.B PlayerDirection
    STX.B PlayerPipeAction
    TXA
    LSR A
    TAX
    BNE +
    LDA.W IsCarryingItem
    BEQ +
    LDA.B PlayerDirection
    EOR.B #$01
    STA.B PlayerDirection
    LDA.B #$08                                ; Face Mario towards the screen.
    STA.W FaceScreenTimer
  + INX
    STX.W YoshiInPipeSetting
    STY.B PlayerAnimation
    JSR NoButtons
    LDA.B #!SFX_PIPE                          ; SFX for going down a pipe.
    STA.W SPCIO0                              ; / Play sound effect
CODE_00F43E:
    PLX
CODE_00F43F:
    LDY.W Map16TileNumber
Return00F442:
    RTS

CODE_00F443:
; Subroutine to check if Mario is in the center of a block. Used for doors.
    LDA.B PlayerXPosNext                      ; (not used for the boss doors, however)
    CLC
    ADC.B #$04
    AND.B #$0F
    CMP.B #$08
    RTS

CODE_00F44D:
    INX                                       ; Routine to fetch the block being interacted by a particular interaction point.
    INX
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    CLC                                       ; Locate the interaction point, storing to $98/$9A.
    ADC.W DATA_00E830,X                       ; X contains the interaction point to check, times 2.
    STA.B TouchBlockXPos                      ; (center, side body, side head, head, left foot, right foot)
    LDA.B PlayerYPosNext
    CLC
    ADC.W DATA_00E89C,X
    STA.B TouchBlockYPos
CODE_00F461:
    JSR CODE_00F465                           ; Set up $1693 for the interaction point.
    RTS

CODE_00F465:
; Subroutine to set up $1693 with the tile's acts-like setting.
    SEP #$20                                  ; A->8; Returns not equal if on page 0 and equal if on page 1.
    STZ.W SwitchPalacePressed
    PHX
    LDA.B TempScreenMode
    BPL +                                     ; Jump down if Layer 2 has interaction.
    JMP CODE_00F4EC

; Layer 2 does not have interaction.
  + BNE CODE_00F4A6                           ; Branch if the level is vertical.
    REP #$20                                  ; A->16
    LDA.B TouchBlockYPos
    CMP.W #$01B0
    SEP #$20                                  ; A->8
    BCS CODE_00F4A0
    AND.B #$F0                                ; Return tile 025 if outside the level.
    STA.B _0
    LDX.B TouchBlockXPos+1
    CPX.B LevelScrLength
    BCS CODE_00F4A0
    LDA.B TouchBlockXPos
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _0                                  ; Get the pointer to the block being touched.
    CLC
    ADC.L DATA_00BA60,X
    STA.B _0
    LDA.B TouchBlockYPos+1
    ADC.L DATA_00BA9C,X
    BRA CODE_00F4CD

CODE_00F4A0:
    PLX                                       ; Return tile 025 (blank).
    LDY.B #$25
CODE_00F4A3:
    LDA.B #$00
    RTS

CODE_00F4A6:
    LDA.B TouchBlockXPos+1                    ; Vertical level without layer 2 interaction.
    CMP.B #$02
    BCS CODE_00F4E7                           ; Return tile 025 if outside the level.
    LDX.B TouchBlockYPos+1
    CPX.B LevelScrLength
    BCS CODE_00F4E7
    LDA.B TouchBlockYPos
    AND.B #$F0
    STA.B _0
    LDA.B TouchBlockXPos
    LSR A
    LSR A
    LSR A                                     ; Get the pointer to the block being touched.
    LSR A
    ORA.B _0
    CLC
    ADC.L DATA_00BA80,X
    STA.B _0
    LDA.B TouchBlockXPos+1
    ADC.L DATA_00BABC,X
CODE_00F4CD:
    STA.B _1
    LDA.B #$7E
    STA.B _2                                  ; Store Map16 tile number.
    LDA.B [_0]
    STA.W Map16TileNumber
    INC.B _2
    PLX                                       ; Store proper "acts like" setting for the tile.
    LDA.B [_0]
    JSL CODE_00F545
    LDY.W Map16TileNumber
    CMP.B #$00
    RTS

CODE_00F4E7:
    PLX                                       ; Return tile 025 (blank).
    LDY.B #$25
    BRA CODE_00F4A3

CODE_00F4EC:
; Layer 2 has interaction.
    ASL A                                     ; Branch if Layer 2 is vertical.
    BNE CODE_00F51B
    REP #$20                                  ; A->16
    LDA.B TouchBlockYPos
    CMP.W #$01B0
    SEP #$20                                  ; A->8
    BCS CODE_00F4E7
    AND.B #$F0                                ; Return tile 025 if outside the level.
    STA.B _0
    LDX.B TouchBlockXPos+1
    CPX.B #$10
    BCS CODE_00F4E7
    LDA.B TouchBlockXPos
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _0                                  ; Get the pointer to the block being touched.
    CLC
    ADC.L DATA_00BA70,X
    STA.B _0
    LDA.B TouchBlockYPos+1
    ADC.L DATA_00BAAC,X
    BRA CODE_00F4CD

CODE_00F51B:
    LDA.B TouchBlockXPos+1                    ; Vertical layer 2 with interaction.
    CMP.B #$02
    BCS CODE_00F4E7                           ; Return tile 025 if outside the level.
    LDX.B TouchBlockYPos+1
    CPX.B #$0E
    BCS CODE_00F4E7
    LDA.B TouchBlockYPos
    AND.B #$F0
    STA.B _0
    LDA.B TouchBlockXPos
    LSR A
    LSR A
    LSR A
    LSR A                                     ; Get the pointer to the block being touched.
    ORA.B _0
    CLC
    ADC.L DATA_00BA8E,X
    STA.B _0
    LDA.B TouchBlockXPos+1
    ADC.L DATA_00BACA,X
    JMP CODE_00F4CD

CODE_00F545:
    TAY                                       ; Get proper "acts like" settings for a block, accounting for P-switches.
    BNE CODE_00F577
    LDY.W Map16TileNumber                     ; Load MAP16 tile number
    CPY.B #$29                                ; \ If block isn't "Invisible POW ? block",; If not tile 029 (the P-switch activated ? block), branch.
    BNE PSwitchNotInvQBlk                     ; / branch to PSwitchNotInvQBlk
    LDY.W BluePSwitchTimer
    BEQ Return00F594                          ; If the P-switch is not active, return.
    LDA.B #$24                                ; Else, set the block to act like a coin block and return.
    STA.W Map16TileNumber
    RTL

PSwitchNotInvQBlk:
    CPY.B #$2B                                ; \ If block is "Coin",; Branch if tile 02B (normal coin).
    BEQ PSwitchCoinBrown                      ; / branch to PSwitchCoinBrown
    TYA
    SEC
    SBC.B #$EC                                ; Branch if not tiles 0EC-0FB (switch palace switches).
    CMP.B #$10
    BCS CODE_00F592
    INC A                                     ; Store value for the switch being pressed.
    STA.W SwitchPalacePressed
    BRA CODE_00F571                           ; Make it act solid.

PSwitchCoinBrown:
    LDY.W BluePSwitchTimer                    ; Return if the P-switch is not active (i.e. don't turn solid).
    BEQ Return00F594
CODE_00F571:
    LDA.B #$32                                ; Act like tile 132 (brown block).
    STA.W Map16TileNumber
    RTL

CODE_00F577:
    LDY.W Map16TileNumber                     ; Block is on page 1.
    CPY.B #$32
    BNE CODE_00F584
    LDY.W BluePSwitchTimer
    BNE CODE_00F58D
    RTL

CODE_00F584:
    CPY.B #$2F                                ; Make it act like a coin if:
    BNE Return00F594                          ; Tile 132 (brown block) and blue P-switch hit
    LDY.W SilverPSwitchTimer                  ; Tile 12F (muncher) and silver P-switch hit
    BEQ Return00F594                          ; Else, just return.
CODE_00F58D:
    LDY.B #$2B
    STY.W Map16TileNumber
CODE_00F592:
    LDA.B #$00
Return00F594:
    RTL

CODE_00F595:
    REP #$20                                  ; A->16; Handle falling off the bottom of the screen.
    LDA.W #$FF80
    CLC
    ADC.B Layer1YPos                          ; If Mario tries going too far above/below the visible screen, freeze his position.
    CMP.B PlayerYPosNext                      ; Think of this as the "vertical cap" for distance above the screen.
    BMI +
    STA.B PlayerYPosNext
  + SEP #$20                                  ; A->8
    LDA.B PlayerYPosScrRel+1
    DEC A                                     ; If Mario is above the screen, return.
    BMI Return00F5B6                          ; If he's below the screen, either kill Mario, or
    LDA.W YoshiHeavenFlag                     ; if he's in a Yoshi Wings game, activate the normal exit and fade to overworld.
    BEQ +
    JMP CODE_00C95B

; Fallen offscreen and not in Yoshi Wings.
  + JSL CODE_00F60A                           ; Kill Mario.
Return00F5B6:
    RTS

HurtMario:
    LDA.B PlayerAnimation                     ; \ Return if animation sequence activated; Routine to hurt Mario.
    BNE Return00F628                          ; /; Return if:
    LDA.W IFrameTimer                         ; \ If flashing...; Mario isn't in a normal animation state
    ORA.W InvinsibilityTimer                  ; | ...or have star...; Mario is invincible or has star power
    ORA.W EndLevelTimer                       ; | ...or level ending...; In the middle of the goal walk
    BNE Return00F628                          ; / ...return
    STZ.W GameCloudCoinCount
    LDA.W WallrunningType
    BEQ +
    PHB
    PHK                                       ; If wall-running, ???
    PLB
    JSR ADDR_00EB42
    PLB
  + LDA.B Powerup                             ; \ If Mario is small, kill him; Kill Mario if he doesn't have a powerup.
    BEQ KillMario                             ; /
    CMP.B #$02                                ; \ Branch if not Caped Mario
    BNE PowerDown                             ; /; If Mario is flying, end flight instead of damaging.
    LDA.W FlightPhase                         ; \ Branch if not soaring; Else, branch to damage.
    BEQ PowerDown                             ; /
; Stop Mario's flight.
    LDY.B #!SFX_FLYHIT                        ; \ Break Mario out of soaring; SFX for flight being canceled.
    STY.W SPCIO0                              ; | (Play sound effect)
    LDA.B #$01                                ; | (Set spin jump flag)
    STA.W SpinJumpFlag                        ; |
    LDA.B #$30                                ; | (Set flashing timer); How long Mario is invincible for after losing flight.
    STA.W IFrameTimer                         ; /
    BRA CODE_00F622

PowerDown:
; Activate power-down animation.
    LDY.B #!SFX_PIPE                          ; \ Play sound effect; SFX for being damaged.
    STY.W SPCIO0                              ; /
    JSL CODE_028008                           ; Drop the powerup in the item box.
    LDA.B #$01                                ; \ Set power down animation; Set to run power-down animation.
    STA.B PlayerAnimation                     ; /
    STZ.B Powerup                             ; Mario status = Small; Clear Mario's powerup.
    LDA.B #$2F                                ; How long the powerdown animation lasts.
    BRA +

KillMario:
; Subroutine to kill Mario.
    LDA.B #$90                                ; \ Mario Y speed = #$90; Speed at which Mario jumps upward.
    STA.B PlayerYSpeed+1                      ; /
CODE_00F60A:
    LDA.B #!BGM_DEATH                         ; \; SFX for dying (death music)
    STA.W SPCIO2                              ; / Change music
    LDA.B #$FF
    STA.W MusicBackup
    LDA.B #$09                                ; \ Animation sequence = Kill Mario
    STA.B PlayerAnimation                     ; /
    STZ.W SpinJumpFlag                        ; Spin jump flag = 0
    LDA.B #$30                                ; How long the death animation lasts.
  + STA.W PlayerAniTimer                      ; Set hurt frame timer
    STA.B SpriteLock                          ; set lock sprite timer
CODE_00F622:
    STZ.W FlightPhase                         ; Cape status = 0
    STZ.W Empty188A
Return00F628:
    RTL

CODE_00F629:
    JSL KillMario
NoButtons:
    STZ.B byetudlrHold                        ; Zero RAM mirrors for controller Input
    STZ.B byetudlrFrame
    STZ.B axlr0000Hold
    STZ.B axlr0000Frame
    RTS

CODE_00F636:
    REP #$20                                  ; A->16; Store pointers for Mario's graphical tiles.
    LDX.B #$00
    LDA.B _9
    ORA.W #$0800
    CMP.B _9
    BEQ +
    CLC
  + AND.W #$F700                              ; Store the pointers to the graphics for Mario's head (body if small).
    ROR A
    LSR A
    ADC.W #$2000
    STA.W DynGfxTilePtr
    CLC
    ADC.W #$0200
    STA.W DynGfxTilePtr+$0A
    LDX.B #$00
    LDA.B _A
    ORA.W #$0800
    CMP.B _A
    BEQ +
    CLC
  + AND.W #$F700                              ; Store the pointers to the graphics for Mario's body (when big).
    ROR A
    LSR A
    ADC.W #$2000
    STA.W DynGfxTilePtr+2
    CLC
    ADC.W #$0200
    STA.W DynGfxTilePtr+$0C
    LDA.B _B
    AND.W #$FF00
    LSR A
    LSR A
    LSR A                                     ; Store the pointers to the graphics for Mario's cape.
    ADC.W #$2000
    STA.W DynGfxTilePtr+4
    CLC
    ADC.W #$0200
    STA.W DynGfxTilePtr+$0E
    LDA.B _C
    AND.W #$FF00
    LSR A
    LSR A                                     ; Store the pointer the misc tile of Mario's cape during flight.
    LSR A
    ADC.W #$2000
    STA.W DynGfxTile7FPtr
    SEP #$20                                  ; A->8
    LDA.B #$0A                                ; Load #$0A tiles (Mario+Yoshi) in the DMA routine later.
    STA.W PlayerGfxTileCount
    RTS


DATA_00F69F:
    db $64,$00,$7C,$00

DATA_00F6A3:
    db $00,$00,$FF,$FF

DATA_00F6A7:
    db $FD,$FF,$05,$00,$FA,$FF

DATA_00F6AD:
    db $00,$00,$00,$00,$C0,$00

DATA_00F6B3:
    db $90,$00,$60,$00,$00,$00,$00,$00
    db $00,$00,$00,$00

DATA_00F6BF:
    db $00,$00,$FE,$FF,$02,$00,$00,$00
    db $FE,$FF,$02,$00

DATA_00F6CB:
    db $00,$00,$20,$00

DATA_00F6CF:
    db $D0,$00,$00,$00,$20,$00,$D0,$00
    db $01,$00,$FF,$FF

UpdateScreenPosition:
; Where to stop the screen relative to Mario when scrolling vertically.
; First is scrolling up, second is down.
; 16-bit EOR table used by the scroll codes.
; How quickly to catch the screen up to Mario when scrolling vertically.
; First is scrolling up, second is down.
; This one is mostly unused. Used as the upwards scroll speed when below the lower limit at $00F6AD.
; Vertical limits for scrolling.
; Upper limit (i.e. top of level). First is are scrolling up, second is down.
; Lower limit. Used for locking the screen with the "unless flying/climbing/etc." setting.
; Standard scroll distances when moving right/left, indexed by $13FF.
; Only the first two entries seem to actually be used.
; Horizontal screen scroll speed. First is right, second is left, third is unused.
; L/R scrolling.    [note: also used for deciding whether to catch the screen up to Mario]
; Screen catching up to Mario.
; L/R scroll distances.
; First is right, second is left. Third unused?
; Unused?
; How far to shift the screen as it scrolls while catching up to Mario.
; Basically, increasing these makes the screen catch up in "chunks"; I don't recommend it.
    PHB                                       ; Routine to handle moving/scrolling the screen by way of Mario (not scroll sprites).
    PHK
    PLB
    REP #$20                                  ; A->16
    LDA.W CameraMoveTrigger
    SEC
    SBC.W #$000C                              ; Distance Mario must be offset in the "scroll hotspot" for the screen to scroll left. NOTE: modified by LM to become a JSL!
    STA.W CameraLeftBuffer
    CLC
    ADC.W #$0018                              ; Distance Mario must be offset from the above offset for the screen to scroll right.
    STA.W CameraRightBuffer
    LDA.W NextLayer1XPos
    STA.B Layer1XPos
    LDA.W NextLayer1YPos
    STA.B Layer1YPos
    LDA.W NextLayer2XPos
    STA.B Layer2XPos
    LDA.W NextLayer2YPos
    STA.B Layer2YPos
    LDA.B ScreenMode
    LSR A
    BCC +
    JMP CODE_00F75C

  + LDA.W #$00C0                              ; Position at which the screen stops scrolling vertically in horizontal levels.
    JSR CODE_00F7F4
    LDY.W HorizLayer1Setting                  ; Check if horizontal scrolling is enabled. If not, skip.
    BEQ CODE_00F75A
    LDY.B #$02
    LDA.B PlayerXPosNext
    SEC
    SBC.B Layer1XPos
    STA.B _0
    CMP.W CameraMoveTrigger                   ; Figure out which direction to scroll the screen horizontally.
    BPL +
    LDY.B #$00
  + STY.B Layer1ScrollDir
    STY.B Layer2ScrollDir
    SEC
    SBC.W CameraLeftBuffer,Y
    BEQ CODE_00F75A
    STA.B _2
    EOR.W DATA_00F6A3,Y
    BPL CODE_00F75A
    JSR CODE_00F8AB
    LDA.B _2
    CLC
    ADC.B Layer1XPos
    BPL +
    LDA.W #$0000
  + STA.B Layer1XPos
    LDA.B LastScreenHoriz
    DEC A
    XBA
    AND.W #$FF00
    BPL +
    LDA.W #$0080
  + CMP.B Layer1XPos
    BPL CODE_00F75A
    STA.B Layer1XPos
CODE_00F75A:
    BRA CODE_00F79D

CODE_00F75C:
    LDA.B LastScreenVert
    DEC A
    XBA
    AND.W #$FF00
    JSR CODE_00F7F4
    LDY.W HorizLayer1Setting
    BEQ CODE_00F79D
    LDY.B #$00
    LDA.B PlayerXPosNext
    SEC
    SBC.B Layer1XPos
    STA.B _0
    CMP.W CameraMoveTrigger
    BMI +
    LDY.B #$02
  + SEC
    SBC.W CameraLeftBuffer,Y
    STA.B _2
    EOR.W DATA_00F6A3,Y
    BPL CODE_00F79D
    JSR CODE_00F8AB
    LDA.B _2
    CLC
    ADC.B Layer1XPos
    BPL +
    LDA.W #$0000
  + CMP.W #$0101
    BMI +
    LDA.W #$0100
  + STA.B Layer1XPos
CODE_00F79D:
    LDY.W HorizLayer2Setting
    BEQ CODE_00F7AA
    LDA.B Layer1XPos                          ; Layer 2 horizontal scroll rates:
    DEY                                       ; None: Don't attach scrolling.
    BEQ +                                     ; Constant: Scroll with Layer 1.
    LSR A                                     ; Variable: Scroll at 1/2 the speed of Layer 1.
  + STA.B Layer2XPos
CODE_00F7AA:
    LDY.W VertLayer2Setting
    BEQ CODE_00F7C2
    LDA.B Layer1YPos
    DEY
    BEQ +
    LSR A                                     ; Layer 2 vertical scroll rates:
    DEY                                       ; None: Don't attach scrolling.
    BEQ +                                     ; Constant: Scroll with Layer 1.
    LSR A                                     ; Variable: Scroll at 1/2 the speed of Layer 1.
    LSR A                                     ; Slow:     Scroll at 1/32 the speed of Layer 1.
    LSR A
    LSR A
  + CLC
    ADC.W BackgroundVertOffset
    STA.B Layer2YPos
CODE_00F7C2:
    SEP #$20                                  ; A->8
    LDA.B Layer1XPos
    SEC
    SBC.W NextLayer1XPos
    STA.W Layer1DXPos
    LDA.B Layer1YPos
    SEC
    SBC.W NextLayer1YPos
    STA.W Layer1DYPos                         ; Update addresses for how far the layer has scrolled this frame.
    LDA.B Layer2XPos
    SEC
    SBC.W NextLayer2XPos
    STA.W Layer2DXPos
    LDA.B Layer2YPos
    SEC
    SBC.W NextLayer2YPos
    STA.W Layer2DYPos
    LDX.B #$07
  - LDA.B Layer1XPos,X
    STA.W NextLayer1XPos,X
    DEX
    BPL -
    PLB
    RTL

CODE_00F7F4:
; Routine to handle what happens when vertical scrolling is enabled.
    LDX.W VertLayer1Setting                   ; Check if vertical scrolling (any) is enabled. If not, return.
    BNE +
    RTS

  + STA.B _4
    LDY.B #$00
    LDA.B PlayerYPosNext
    SEC                                       ; Decide whether to scroll the screen up or down.
    SBC.B Layer1YPos
    STA.B _0
    CMP.W #$0070                              ; Where the "bottom" scroll line is; Mario must above this to scroll up, and below to scroll down.
    BMI +
    LDY.B #$02
  + STY.B Layer1ScrollDir
    STY.B Layer2ScrollDir
    SEC
    SBC.W DATA_00F69F,Y
    STA.B _2
    EOR.W DATA_00F6A3,Y
    BMI +
    LDY.B #$02                                ; If the screen is scrolling down or has caught up to Mario,
    STZ.B _2                                  ; clear the "scroll up" flag and branch.
  + LDA.B _2                                  ; Else, continue below.
    BMI CODE_00F82A
    LDX.B #$00
    STX.W ScreenScrollAtWill
    BRA CODE_00F883

CODE_00F82A:
; Screen needs to move upwards to catch up to Mario.
    SEP #$20                                  ; A->8; Scroll the screen up if:
    LDA.W WallrunningType
    CMP.B #$06
    BCS +
    LDA.W YoshiHasWingsGfx                    ; \ If winged Yoshi...
    LSR A                                     ; |; Wall-running
    ORA.W TakeoffTimer                        ; Jumping with a full P-meter (takeoff meter set)
    ORA.B PlayerIsClimbing                    ; | ...or climbing; Climbing a net
    ORA.W PBalloonInflating                   ; Inflated from a P-balloon
    ORA.W PlayerInCloud                       ; Riding a Lakitu cloud
    ORA.W BouncingOnBoard                     ; Bouncing off a spring/purple triangle
  + TAX
    REP #$20                                  ; A->16
    BNE CODE_00F869
    LDX.W PlayerRidingYoshi
    BEQ CODE_00F856
    LDX.W YoshiHasWingsEvt                    ; \ Branch if 141E >= #$02; Riding Yoshi while he has wings
    CPX.B #$02                                ; |
    BCS CODE_00F869                           ; /
CODE_00F856:
    LDX.B PlayerInWater
    BEQ CODE_00F85E                           ; Swimming upwards in water
    LDX.B PlayerInAir
    BNE CODE_00F869
CODE_00F85E:
    LDX.W VertLayer1Setting
    DEX
    BEQ CODE_00F875
    LDX.W VerticalScrollEnabled
    BNE CODE_00F875
CODE_00F869:
    STX.W VerticalScrollEnabled               ; On the ground, the screen hasn't caught up to him, and he is not at the "screen lock" height.
    LDX.W VerticalScrollEnabled               ; (only if level has "no vertical scroll unless flying/etc.")
    BNE CODE_00F881
    LDY.B #$04                                ; [LM hijacks on this line, to determine whether the screen is locked]
    BRA CODE_00F881

CODE_00F875:
    LDX.W ScreenScrollAtWill                  ; If none of the above conditions are met, return without scrolling.
    BNE CODE_00F881
    LDX.B PlayerInAir
    BNE Return00F8AA
    INC.W ScreenScrollAtWill
CODE_00F881:
    LDA.B _2
CODE_00F883:
    SEC                                       ; Screen is scrolling down.
    SBC.W DATA_00F6A7,Y
    EOR.W DATA_00F6A7,Y
    ASL A
    LDA.B _2
    BCS +                                     ; Scroll the screen vertically.
    LDA.W DATA_00F6A7,Y                       ; And prevent the screen from scrolling above the top of the level.
  + CLC
    ADC.B Layer1YPos
    CMP.W DATA_00F6AD,Y
    BPL +
    LDA.W DATA_00F6AD,Y
  + STA.B Layer1YPos
    LDA.B _4
    CMP.B Layer1YPos
    BPL Return00F8AA
    STA.B Layer1YPos
    STZ.W VerticalScrollEnabled
Return00F8AA:
    RTS

CODE_00F8AB:
; Subroutine to handle horizontally scrolling the screen as Mario walks.
    LDY.W CameraIsScrolling                   ; Return if the screen is scrolling from L/R.
    BNE Return00F8DE
    SEP #$20                                  ; A->8
    LDX.W CameraScrollPlayerDir
    REP #$20                                  ; A->16
    LDY.B #$08
    LDA.W CameraMoveTrigger                   ; If scrolling right, Y=8. Else, Y=A.
    CMP.W DATA_00F6B3,X
    BPL +
    LDY.B #$0A
  + LDA.W DATA_00F6BF,Y
    EOR.B _2
    BPL Return00F8DE
    LDA.W DATA_00F6BF,X
    EOR.B _2                                  ; Return if Mario isn't moving in the direction the screen should scroll.
    BPL Return00F8DE                          ; Else, scroll it over.
    LDA.B _2
    CLC
    ADC.W DATA_00F6CF,Y
    BEQ Return00F8DE
    STA.B _2
    STY.W CameraProperMove
Return00F8DE:
    RTS


DATA_00F8DF:
    db $0C,$0C,$08,$00,$20,$04,$0A,$0D
    db $0D

BossCeilingHeights:
    dw !RoyMortonCeilingHeight
    dw !RoyMortonCeilingHeight
    dw !LudwigCeilingHeight
    dw !BowserCeilingHeight
    dw !ReznorCeilingHeight

CODE_00F8F2:
; Slope steepness for Iggy/Larry's platform at various angles (mod 16).
; Misc. values for each of the boss rooms specified by $13FC.
    JSR CODE_00EAA6                           ; Mort  Roy   Ludw  Bwsr  Rez
    BIT.W IRQNMICommand
    BVC CODE_00F94E
    JSR CODE_00E92B
    LDA.W ActiveBoss
    ASL A
    TAX
    PHX
    LDY.B PlayerYSpeed+1
    BPL +
    REP #$20                                  ; A->16
    LDA.B PlayerYPosNext
    CMP.W BossCeilingHeights,X
    BPL +
    LDA.W BossCeilingHeights,X
    STA.B PlayerYPosNext
    SEP #$20                                  ; A->8
    STZ.B PlayerYSpeed+1
    LDA.B #!SFX_BONK
    STA.W SPCIO0                              ; / Play sound effect
  + SEP #$20                                  ; A->8
    PLX
    LDA.W BossCeilingHeights,X
    CMP.B #$2A
    BNE Return00F94D
    REP #$20                                  ; A->16
    LDY.B #$00
    LDA.W SpriteMisc160E+9
    AND.W #$00FF
    INC A
    CMP.B PlayerXPosNext
    BEQ +
    BMI +
    LDA.W SpriteMisc1534+9
    AND.W #$00FF
    STA.B _0
    INY
    LDA.B PlayerXPosNext
    CLC
    ADC.W #$000F
    CMP.B _0
  + JMP CODE_00E9C8

Return00F94D:
    RTS

CODE_00F94E:
    LDY.B #$00                                ; Routine to handle proper interaction with the platform and lava in Iggy/Larry's room.
    LDA.B PlayerYSpeed+1
    BPL +
    JMP CODE_00F997

; Skip platform interaction if Mario is moving upwards,
  + JSR CODE_00F9A8                           ; or is not touching the platform and was not on the platform the previous frame.
    BCS +
    JSR CODE_00EE1D
    JMP CODE_00F997

; Mario is touching Iggy/Larry's platform.
  + LDA.B PlayerInAir                         ; Branch if Mario is on the ground (platform interaction has already been processed).
    BEQ +
    REP #$20                                  ; A->16
    LDA.W IggyLarryTempXPos
    AND.W #$00FF
    STA.W IggyLarryPlatIntXPos
    STA.W KeyholeXPos
    LDA.W IggyLarryTempYPos                   ; Process Mario's interaction with the platform.
    AND.W #$00F0
    STA.W IggyLarryPlatIntYPos
    STA.W KeyholeYPos
    JSR CODE_00F9C9
  + LDA.B Mode7Angle
    CLC
    ADC.B #$48
    LSR A
    LSR A
    LSR A                                     ; Handle sliding based on the angle of the platform.
    LSR A
    TAX
    LDY.W DATA_00F8DF,X
    LDA.B #$80
    STA.B TempScreenMode
    JSR CODE_00EEE1
CODE_00F997:
    REP #$20                                  ; A->16
    LDA.B PlayerYPosScrRel
    CMP.W #$00AE                              ; Y position of the lava in Iggy/Lemmy's room.
    SEP #$20                                  ; A->8; Kill Mario if he hits the lava.
    BMI +
    JSR CODE_00F629
  + JMP CODE_00E98C

CODE_00F9A8:
    REP #$20                                  ; A->16; Subroutine for the above to get Mario's position on Iggy/Larry's platform.
    LDA.B PlayerXPosNext
    CLC
    ADC.W #$0008
    STA.W IggyLarryPlatIntXPos                ; Get his position.
    LDA.B PlayerYPosNext
    CLC
    ADC.W #$0020
    STA.W IggyLarryPlatIntYPos
CODE_00F9BC:
    SEP #$20                                  ; A->8
    PHB
    LDA.B #$01
    PHA                                       ; Get actual X/Y position on Iggy/Larry's platform.
    PLB
    JSL CODE_01CC9D
    PLB
    RTS

CODE_00F9C9:
    LDA.B Mode7Angle                          ; Subroutine to handle Mario's interaction with Iggy/Larry's platform.
    PHA
    EOR.W #$FFFF
    INC A
    STA.B Mode7Angle                          ; Check for interaction with the platform.
    JSR CODE_00F9BC
    REP #$20                                  ; A->16
    PLA
    STA.B Mode7Angle
    LDA.W IggyLarryTempXPos
    AND.W #$00FF
    SEC                                       ; Center Mario's X position on the platform (?).
    SBC.W #$0008
    STA.B PlayerXPosNext
    LDA.W IggyLarryTempYPos
    AND.W #$00FF
    SEC                                       ; Shift Mario on top of the platform.
    SBC.W #$0020
    STA.B PlayerYPosNext
    SEP #$20                                  ; A->8
    RTS

    %insert_empty($1B,$1B,$1B,$4D,$4D)

    LDX.B #$0B                                ; \ Unreachable; Unused routine to clear out the sprite table.
  - STZ.W SpriteStatus,X                      ; | Clear out sprite status table
    DEX                                       ; |
    BPL -                                     ; |
    RTL                                       ; /

CODE_00FA19:
; Scratch RAM setup:
; A   - Tile number
; $0A - Block clipping X position, low (from $9A).
; $0C - Block clipping Y position, low (from $98).
; Scratch RAM returns:
; Y   - Index to $00E632 to get the pixel shift distance.
; $00 - Clipping Y position, centered onto the block.
; $01 - Basic slope index to the shift table.
; $05 - 24-bit pointer to $00E632.
; $08 - Slope steepness value (from $82).
    LDY.B #DATA_00E632                        ; Subroutine to get the offset of a sprite/fireball from the nearest block, for interacting with slopes.
    STY.B _5
    LDY.B #DATA_00E632>>8                     ; Point $05 to $00E632.
    STY.B _6
    LDY.B #DATA_00E632>>16
    STY.B _7
    SEC
    SBC.B #$6E
    TAY                                       ; Store the slope's steepness value to $08.
    LDA.B [SlopesPtr],Y
    STA.B _8
    ASL A
    ASL A
    ASL A
    ASL A                                     ; Get the index to the slope offset table into Y.
    STA.B _1
    BCC +
    INC.B _6
  + LDA.B _C
    AND.B #$0F                                ; Set Y clipping for the slope.
    STA.B _0
    LDA.B _A
    AND.B #$0F                                ; Get X position, plus the current touched position within the block.
    ORA.B _1
    TAY
    RTL

FlatPalaceSwitch:
    LDA.B #$20                                ; \ Set "Time to shake ground" to x20; Time to shake the ground when hitting the Switch Palace switch.
    STA.W ScreenShakeTimer                    ; /
    LDY.B #$02                                ; \
    LDA.B #$60                                ; |Set sprite x02 to x60 (Flat palace switch)
    STA.W SpriteNumber,Y                      ; /
    LDA.B #$08                                ; \ Set sprite's status to x08
    STA.W SpriteStatus,Y                      ; /
    LDA.B TouchBlockXPos                      ; \
    AND.B #$F0                                ; |Set sprite X (low) to $9A & 0xF0
    STA.W SpriteXPosLow,Y                     ; /
    LDA.B TouchBlockXPos+1                    ; \ Set sprite X (high) to $9B
    STA.W SpriteXPosHigh,Y                    ; /
    LDA.B TouchBlockYPos                      ; \
    AND.B #$F0                                ; |
    CLC                                       ; |Set sprite Y (low) to ($98 & 0xF0) + 0x10
    ADC.B #$10                                ; |
    STA.W SpriteYPosLow,Y                     ; /
    LDA.B TouchBlockYPos+1                    ; \
    ADC.B #$00                                ; |Set sprite Y (high) to $99 + carry
    STA.W SpriteYPosHigh,Y                    ; / (Carry carried over from previous addition)
    PHX
    TYX
    JSL InitSpriteTables
    PLX
    LDA.B #$5F                                ; \ Set sprite's "Spin Jump Death Frame Counter" to x5F
    STA.W SpriteMisc1540,Y                    ; /
    RTS

TriggerGoalTape:
    STZ.W PBalloonInflating                   ; Routine to handle triggering a goal tape.
    STZ.W PBalloonTimer                       ; Stop certain processes:
    STZ.W SpriteRespawnTimer                  ; Don't respawn sprites; P-balloon, generators, silver coin counter
if ver_is_english(!_VER)                      ;\================ U, SS, E0, & E1 ==============
    STZ.W CurrentGenerator                    ;!
endif                                         ;/===============================================
    STZ.W SilverCoinsCollected
    LDY.B #$0B                                ; Loop over sprites:; Sprite handling loop.
LvlEndSprLoopStrt:
    LDA.W SpriteStatus,Y                      ; \ If sprite status < 8,
    CMP.B #$08                                ; | skip the current sprite; Skip sprite if already dead/dying.
    BCC LvlEndNextSprite                      ; /
    CMP.B #$0B                                ; \ If Mario carries a sprite past the goal,
    BNE CODE_00FAA3                           ; |
    PHX                                       ; |; If being carried, use the handler for it instead.
    JSR LvlEndPowerUp                         ; | he gets a powerup
    PLX                                       ; |
    BRA LvlEndNextSprite                      ; /

CODE_00FAA3:
    LDA.W SpriteNumber,Y                      ; \ Branch if goal tape
    CMP.B #$7B                                ; |
    BEQ CODE_00FAB2                           ; /
    LDA.W SpriteOffscreenX,Y                  ; \ If sprite on screen...
    ORA.W SpriteOffscreenVert,Y               ; |
    BNE CODE_00FAC5                           ; |; If the sprite is either a goal tape or onscreen,
CODE_00FAB2:
    LDA.W SpriteTweakerE,Y                    ; | ...and "don't turn into coin" not set,; and doesn't have $1686 bit 5 set, then turn the sprite into the goal tape coin.
    AND.B #$20                                ; |
    BNE CODE_00FAC5                           ; |
    LDA.B #$10                                ; | Set coin animation timer = #$10; How many frames until the coin is collected.
    STA.W SpriteMisc1540,Y                    ; |
    LDA.B #$06                                ; | Sprite status = Level end, turn to coins
    STA.W SpriteStatus,Y                      ; |
    BRA LvlEndNextSprite                      ; /

CODE_00FAC5:
    LDA.W SpriteTweakerF,Y                    ; \ If "don't erase" not set,
    AND.B #$02                                ; |
    BNE LvlEndNextSprite                      ; |; Erase all applicable sprites.
    LDA.B #$00                                ; | Erase sprite
    STA.W SpriteStatus,Y                      ; /
LvlEndNextSprite:
    DEY                                       ; \ Goto next sprite
    BPL LvlEndSprLoopStrt                     ; /
    LDY.B #$07                                ; \
    LDA.B #$00                                ; | Clear out all extended sprites
  - STA.W ExtSpriteNumber,Y                   ; |; Clear extended sprite slots.
    DEY                                       ; |
    BPL -                                     ; /
    RTL


DATA_00FADF:
    db $74,$74,$77,$75,$76,$E0,$F0,$74
    db $74,$77,$75,$76,$E0,$F1,$F0,$F0
    db $F0,$F0,$F1,$E0,$F2,$E0,$E0,$E0
    db $E0,$F1,$E0,$E4

DATA_00FAFB:
    db $FF,$74,$75,$76,$77

LvlEndPowerUp:
; Table of sprites to give Mario for carrying an item past the goal tape.
; Shell, throwblock, Goomba, Bob-omb, Mechakoopa, P-balloon, or anything else
; Springboard, P-switch
; Key
; Baby Yoshi
; See comments below for individual row indices.
; Table of item box item sprite numbers. Blank, mushroom, fireflower, star, cape.
    LDX.B Powerup                             ; X = Mario's power up status; Routine to determine what sprite Mario will be given for crossing the goal point with an item. ~
    LDA.W InvinsibilityTimer                  ; \ If Mario has star, X = #$04.  However this never happens as $1490 is cleared earlier
    BEQ +                                     ; | Otherwise Mario could get a star from carrying a sprite past the goal.; X is powerup status (0-3).
    LDX.B #$04                                ; / Unreachable instruction; If Mario has star power, X is 4. Unused because star power gets cleared at $01C0FE.
; If Mario is on Yoshi, X is 5. Partially unused since you have to glitch for it.
  + LDA.W PlayerRidingYoshi                   ; \ If Mario on Yoshi, X = #$05; X = 6 seems to be unused.
    BEQ +                                     ; |
    LDX.B #$05                                ; /
  + LDA.W SpriteNumber,Y                      ; \ If Spring Board, X += #$07; Is Mario holding a...
    CMP.B #$2F                                ; |; ...springboard? Add 7 to X.
    BEQ CODE_00FB2D                           ; /
    CMP.B #$3E                                ; \ If P Switch, X += #$07; ...P-switch? Add 7 to X.
    BEQ CODE_00FB2D                           ; /
    CMP.B #$80                                ; \ If Key, X += #$0E; ...key? Add 14 to X.
    BEQ ADDR_00FB28                           ; /
    CMP.B #$2D                                ; \ If Baby Yoshi, X += #$15; ...anything but baby Yoshi? Leave as-is.
    BNE +                                     ; /; (e.g. shell, throwblock, goomba, etc.)
    TXA
    CLC                                       ; ...baby Yoshi? add 21 to X.
    ADC.B #$07
    TAX
ADDR_00FB28:
    TXA
    CLC
    ADC.B #$07
    TAX
CODE_00FB2D:
    TXA
    CLC
    ADC.B #$07
    TAX
  + LDA.L DATA_00FADF,X
    LDX.W PlayerItembox                       ; Pick sprite to spawn.
    CMP.L DATA_00FAFB,X                       ; If Mario already has it in the item box, spawn a 1up instead.
    BNE +
    LDA.B #$78
  + STZ.B _F
    CMP.B #$E0
    BCC +
    PHA                                       ; If E0-FF was loaded, store lower 4 bits to $0F.
    AND.B #$0F                                ; These 4 bits are used to affect the score sprite from 1ups;
    STA.B _F                                  ; 0 = 1up, 1 = 2up, 2 = 3up, 4 = 5up, 6+ = glitched.
    PLA
    CMP.B #$F0
    LDA.B #$78                                ; If E0-EF, spawn a 1up.
    BCS +                                     ; If F0-FF... also spawn a 1up, I guess.
    LDA.B #$78
  + STA.W SpriteNumber,Y                      ; Store sprite number.
    CMP.B #$76
    BNE +                                     ; If it's a star, increase this (unused) counter.
    INC.W UnusedStarCounter
  + TYX
    JSL InitSpriteTables                      ; Check for a sprite slot.
    LDA.B _F                                  ; Store $0F to $1594. As mentioned, this affects the 1up score sprite value.
    STA.W SpriteMisc1594,Y
    LDA.B #$0C                                ; \ Sprite status = Goal tape power up; Spawn the sprite.
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$D0                                ; Sprite Y speed on spawn.
    STA.W SpriteYSpeed,Y
    LDA.B #$05                                ; Sprite X speed on spawn.
    STA.W SpriteXSpeed,Y
    LDA.B #$20                                ; Wait time until Mario can collect it.
    STA.W SpriteMisc154C,Y
    LDA.B #!SFX_ITEMGOAL                      ; "Goal item" SFX
    STA.W SPCIO0                              ; / Play sound effect
    LDX.B #$03
CODE_00FB84:
    LDA.W SmokeSpriteNumber,X
    BEQ CODE_00FB8D
    DEX
    BPL CODE_00FB84
    RTS

CODE_00FB8D:
    LDA.B #$01
    STA.W SmokeSpriteNumber,X
    LDA.W SpriteYPosLow,Y
    STA.W SmokeSpriteYPos,X
    LDA.W SpriteXPosLow,Y
    STA.W SmokeSpriteXPos,X
    LDA.B #$1B
    STA.W SmokeSpriteTimer,X
    RTS


LvlEndSmokeTiles:
    db $66,$64,$62,$60,$E8,$EA,$EC,$EA

LvlEndSprCoins:
; Unused. Corresponds to the beta coin sprites (see: https://tcrf.net/images/e/e2/SMWObjectsEarly.png )
; Misc RAM usage:
; $1540 - Timer for how long the coin has the form of a cloud before actually hopping into the air.
    PHB                                       ; Routine to handle sprites turned into a coin at level end (sprite status 6).
    PHK
    PLB
    JSR LvlEndSprCoinsRt
    PLB
    RTL

LvlEndSprCoinsRt:
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
    LDA.W SpriteMisc1540,X
    BEQ CODE_00FBF0
    CMP.B #$01
    BNE +
    LDA.B #$D0
    STA.B SpriteYSpeed,X
  + PHX
    LDA.B #$04                                ; \ Use Palette A
    STA.W SpriteOBJAttribute,X                ; /
    JSL GenericSprGfxRt2
    LDA.W SpriteMisc1540,X
    LSR A
    LSR A
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    TAX
    LDA.W LvlEndSmokeTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    RTS

CODE_00FBF0:
    INC.W SpriteMisc1570,X
    JSL UpdateYPosNoGvtyW
    INC.B SpriteYSpeed,X
    INC.B SpriteYSpeed,X
    LDA.B SpriteYSpeed,X
    CMP.B #$20
    BMI CODE_00FC1E
    JSL CODE_05B34A                           ; Give Mario a coin.
    LDA.W SilverCoinsCollected
    CMP.B #$0D
    BCC +
    LDA.B #$0D
  + JSL GivePoints
    LDA.W SilverCoinsCollected
    CLC
    ADC.B #$02
    STA.W SilverCoinsCollected
    STZ.W SpriteStatus,X
CODE_00FC1E:
    JSL CoinSprGfx
    RTS

    LDY.B #$0B                                ; \ Unreachable instructions; Unused code to make a running Yoshi at the left edge of the screen.
ADDR_00FC25:
    LDA.W SpriteStatus,Y                      ; / Status = Carried
    CMP.B #$08
    BNE ADDR_00FC73
    LDA.W SpriteNumber,Y
    CMP.B #$35                                ; Find a living Yoshi, make him green, and remove wings.
    BNE ADDR_00FC73
    LDA.B #$01
    STA.W CarryYoshiThruLvls
    STZ.W YoshiHasWingsEvt                    ; No Yoshi wings
    LDA.W SpriteOBJAttribute,Y
    AND.B #$F1
    ORA.B #$0A
    STA.W SpriteOBJAttribute,Y
    LDA.W PlayerRidingYoshi                   ; Return if the Yoshi is being riden.
    BNE +
    LDA.B Layer1XPos
    SEC
    SBC.B #$10
    STA.W SpriteXPosLow,Y
    LDA.B Layer1XPos+1                        ; Position him just left of the screen,
    SBC.B #$00                                ; at Mario's Y position.
    STA.W SpriteXPosHigh,Y
    LDA.B PlayerYPosNext
    STA.W SpriteYPosLow,Y
    LDA.B PlayerYPosNext+1
    STA.W SpriteYPosHigh,Y
    LDA.B #$03
    STA.W SpriteTableC2,Y
    LDA.B #$00                                ; Spawn him running rightward.
    STA.W SpriteMisc157C,Y
    LDA.B #$10
    STA.W SpriteXSpeed,Y
  + RTL

ADDR_00FC73:
    DEY
    BPL ADDR_00FC25
    STZ.W CarryYoshiThruLvls
    RTL

CODE_00FC7A:
; Routine to spawn Mario on Yoshi after going to a new room.
    LDA.B #!SFX_YOSHIDRUMON                   ; SFX to turn on Yoshi drums on level entrance.
    STA.W SPCIO1                              ; / Play sound effect
    LDX.B #$00
    LDA.W DisableBonusSprite                  ; Use slot 0 if in Bonus Game (?).
    BNE +
    LDX.B #$05
    LDA.W SpriteMemorySetting                 ; Use slot 5 if sprite memory setting is 0A (for Wiggler?).
    CMP.B #$0A
    BEQ +
    JSL FindFreeSprSlot                       ; \ X = First free sprite slot, #$03 if none free
    TYX                                       ; |; Find an empty slot.
    BPL +                                     ; |; Use slot 3 if no slots available.
    LDX.B #$03                                ; /
  + LDA.B #$08                                ; \ Status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$35                                ; \ Sprite = Yoshi
    STA.B SpriteNumber,X                      ; /
    LDA.B PlayerXPosNext                      ; \ Yoshi X position = Mario X position
    STA.B SpriteXPosLow,X                     ; |
    LDA.B PlayerXPosNext+1                    ; |
    STA.W SpriteXPosHigh,X                    ; /
    LDA.B PlayerYPosNext                      ; \ Yoshi's Y position = Mario Y position - #$10; Spawn a Yoshi in the slot at Mario's position.
    SEC                                       ; | Mario Y position = Mario Y position - #$10
    SBC.B #$10                                ; |
    STA.B PlayerYPosNext                      ; |
    STA.B SpriteYPosLow,X                     ; |
    LDA.B PlayerYPosNext+1                    ; |
    SBC.B #$00                                ; |
    STA.B PlayerYPosNext+1                    ; |
    STA.W SpriteYPosHigh,X                    ; /
    JSL InitSpriteTables                      ; Reset sprite tables
    LDA.B #$04                                ; Prevent showing a water splash on spawn.
    STA.W SpriteMisc1FE2,X
    LDA.W YoshiColor                          ; \ Set Yoshi palette; Store the palette of the current player's Yoshi to the YXPPCCCT.
    STA.W SpriteOBJAttribute,X                ; /
    LDA.W YoshiHeavenFlag
    BEQ +
    LDA.B #$06
    STA.W SpriteOBJAttribute,X
  + INC.W PlayerRidingYoshi
    INC.B SpriteTableC2,X
    LDA.B PlayerDirection
    EOR.B #$01
    STA.W SpriteMisc157C,X
    DEC.W SpriteMisc160E,X
    INX
    STX.W CurrentYoshiSlot
    STX.W YoshiIsLoose
    RTL

CODE_00FCEC:
    LDX.B #$0B
  - STZ.W SpriteStatus,X
    DEX
    BPL -
    RTS

CODE_00FCF5:
    LDA.B #$A0
    STA.B SpriteXPosLow,X
    LDA.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B #$00
    STA.B SpriteYPosLow,X
    LDA.B #$00
    STA.W SpriteYPosHigh,X
    RTL

CODE_00FD08:
    LDY.B #$3F                                ; Subroutine to handle Mario's water bubbles.
    LDA.B byetudlrHold
    AND.B #$83                                ; Return if sprites frozen, or not a frame to spawn.
    BNE +
    LDY.B #$7F                                ; Bubbles spawn every 0x80 frames normally,
  + TYA                                       ; or every 0x40 frames with A/B/left/right held.
    AND.B EffFrame
    ORA.B SpriteLock
    BNE Return00FD23
    LDX.B #$07                                ; \ Find a free extended sprite slot
CODE_00FD1B:
    LDA.W ExtSpriteNumber,X                   ; |
    BEQ CODE_00FD26                           ; |; Find an empty extended sprite slot, and return if none found.
    DEX                                       ; |
    BPL CODE_00FD1B                           ; |
Return00FD23:
    RTS                                       ; / Return if no free slots


DATA_00FD24:
    db $02,$0A

CODE_00FD26:
; X offsets for Mario's water bubble based on the direction he's facing.
; Extended sprite slot found.
    LDA.B #$12                                ; \ Extended sprite = Water buble; Extended sprite that Mario "breathes" in water (bubble).
    STA.W ExtSpriteNumber,X                   ; /
    LDY.B PlayerDirection
    LDA.B PlayerXPosNext
    CLC
    ADC.W DATA_00FD24,Y                       ; Set spawn X position based on the direction Mario is fasing.
    STA.W ExtSpriteXPosLow,X
    LDA.B PlayerXPosNext+1
    ADC.B #$00
    STA.W ExtSpriteXPosHigh,X
    LDA.B Powerup
    BEQ CODE_00FD47
    LDA.B #$04                                ; Y offset for the bubble when big.
    LDY.B PlayerIsDucking
    BEQ +
CODE_00FD47:
    LDA.B #$0C                                ; Y offset for the bubble when small or ducking.
  + CLC
    ADC.B PlayerYPosNext
    STA.W ExtSpriteYPosLow,X
    LDA.B PlayerYPosNext+1
    ADC.B #$00
    STA.W ExtSpriteYPosHigh,X
    STZ.W ExtSpriteMisc176F,X                 ; Unused? Possibly this is supposed to be $1765 instead.
    RTS

CODE_00FD5A:
    LDA.B PlayerXPosScrRel+1                  ; Coin glitter routine.
    ORA.B PlayerYPosScrRel+1
    BNE Return00FD6A
    LDY.B #$03
CODE_00FD62:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_00FD6B
    DEY
    BPL CODE_00FD62
Return00FD6A:
    RTS

CODE_00FD6B:
    LDA.B #$05
    STA.W SmokeSpriteNumber,Y
    LDA.B TouchBlockXPos
    AND.B #$F0
    STA.W SmokeSpriteXPos,Y
    LDA.B TouchBlockYPos
    AND.B #$F0
    STA.W SmokeSpriteYPos,Y
    LDA.W LayerProcessing
    BEQ +
    LDA.B TouchBlockXPos
    SEC
    SBC.B Layer23XRelPos
    AND.B #$F0
    STA.W SmokeSpriteXPos,Y
    LDA.B TouchBlockYPos
    SEC
    SBC.B Layer23YRelPos
    AND.B #$F0
    STA.W SmokeSpriteYPos,Y
  + LDA.B #$10
    STA.W SmokeSpriteTimer,Y
    RTS


DATA_00FD9D:
    db $08,$FC,$10,$04

DATA_00FDA1:
    db $00,$FF,$00,$00

CODE_00FDA5:
; Low bytes of the Y offset for water splash sprites when jumping out of water.
; Ordered [small, big, small+Yoshi, big+Yoshi]
; High bytes of the Y offset for water splash sprites when jumping out of water.
    LDA.B PlayerInAir                         ; Routine to spawn a splash sprite when Mario enters or jumps out of water.
    BEQ CODE_00FDB3
    LDY.B #$0B
CODE_00FDAB:
; Find an empty minor extended sprite slot. Use slot 0 if none found.
    LDA.W MinExtSpriteNumber,Y                ; Curiously, if 'on the ground', the game doesn't set Y correctly?
    BEQ CODE_00FDB4                           ; Not sure if it's even possible to run this routine with that.
    DEY
    BPL CODE_00FDAB
CODE_00FDB3:
    INY
CODE_00FDB4:
    PHX
    LDX.B #$00
    LDA.B Powerup
    BEQ +
    INX                                       ; Get X value; start with 0, and:
; Add 1 if big
  + LDA.W PlayerRidingYoshi                   ; Add 2 if riding Yoshi
    BEQ +
    INX
    INX
  + LDA.B PlayerYPosNext
    CLC
    ADC.W DATA_00FD9D,X
    PHP
    AND.B #$F0
    CLC                                       ; Set Y position of the splash at the surface of the water.
    ADC.B #$03
    STA.W MinExtSpriteYPosLow,Y
    LDA.B PlayerYPosNext+1
    ADC.B #$00
    PLP
    ADC.W DATA_00FDA1,X
    STA.W MinExtSpriteYPosHigh,Y
    PLX
    LDA.B PlayerXPosNext
    STA.W MinExtSpriteXPosLow,Y               ; Set X position at Mario.
    LDA.B PlayerXPosNext+1
    STA.W MinExtSpriteXPosHigh,Y
    LDA.B #$07                                ; Set sprite ID as the water splash.
    STA.W MinExtSpriteNumber,Y
    LDA.B #$00                                ; Clear splash timer.
    STA.W MinExtSpriteTimer,Y
    LDA.B PlayerYSpeed+1                      ; Return if Mario is rising (i.e. continue if Mario is entering the water).
    BMI Return00FE0D
    STZ.B PlayerYSpeed+1                      ; Clear Mario's Y speed.
    LDY.B PlayerInAir
    BEQ +                                     ; If entering from the air, clear his X speed too.
    STZ.B PlayerXSpeed+1
  + LDY.B #$03                                ; Mario just entered water. Spawn a bunch of water bubbles.
    LDA.B Powerup                             ; Spawn up to 4 bubbles if Mario is big, and only 3 if small.
    BNE CODE_00FE05
    DEY
CODE_00FE05:
    LDA.W ExtSpriteNumber,Y
    BEQ CODE_00FE16                           ; Find an empty extended sprite slot.
CODE_00FE0A:
    DEY                                       ; If found, branch to the below routine to spawn a water bubble.
    BPL CODE_00FE05
Return00FE0D:
    RTS


DATA_00FE0E:
    db $10,$16,$13,$1C

DATA_00FE12:
    db $00,$04,$0A,$07

CODE_00FE16:
; Y offsets for the water bubble spawned when Mario enters water. Indexed by sprite slot.
; X offsets for the water bubble spawned when Mario enters water. Indexed by sprite slot.
; Subroutine of the above water-splash routine to spawn a water bubble when Mario enters water.
    LDA.B #$12                                ; \ Extended sprite = Water bubble; Set sprite ID as water bubble.
    STA.W ExtSpriteNumber,Y                   ; /
    TYA
    ASL A
    ASL A                                     ; Set initial movement timer based on the slot?
    ASL A
    ADC.B #$F7
    STA.W ExtSpriteMisc1765,Y
    LDA.B PlayerYPosNext
    ADC.W DATA_00FE0E,Y
    STA.W ExtSpriteYPosLow,Y
    LDA.B PlayerYPosNext+1
    ADC.B #$00
    STA.W ExtSpriteYPosHigh,Y                 ; Spawn offset from Mario's position based on the slot.
    LDA.B PlayerXPosNext
    ADC.W DATA_00FE12,Y
    STA.W ExtSpriteXPosLow,Y
    LDA.B PlayerXPosNext+1
    ADC.B #$00
    STA.W ExtSpriteXPosHigh,Y
    LDA.B #$00                                ; Unused?
    STA.W ExtSpriteMisc176F,Y
    JMP CODE_00FE0A                           ; Loop for however many bubbles are left.

CODE_00FE4A:
    LDA.B TrueFrame                           ; Routine to show dust clouds when turning.
    AND.B #$03
    ORA.B PlayerInAir
    ORA.B PlayerXPosScrRel+1
    ORA.B PlayerYPosScrRel+1
    ORA.B SpriteLock
    BNE Return00FE71
    LDA.B byetudlrHold
    AND.B #$04
    BEQ CODE_00FE67
    LDA.B PlayerXSpeed+1
    CLC
    ADC.B #$08
    CMP.B #$10
    BCC Return00FE71
CODE_00FE67:
    LDY.B #$03
CODE_00FE69:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_00FE72
    DEY
    BNE CODE_00FE69
Return00FE71:
    RTS

CODE_00FE72:
    LDA.B #$03
    STA.W SmokeSpriteNumber,Y
    LDA.B PlayerXPosNext
    ADC.B #$04
    STA.W SmokeSpriteXPos,Y
    LDA.B PlayerYPosNext
    ADC.B #$1A
    PHX
    LDX.W PlayerRidingYoshi
    BEQ +
    ADC.B #$10
  + STA.W SmokeSpriteYPos,Y
    PLX
    LDA.B #$13
    STA.W SmokeSpriteTimer,Y
    RTS


DATA_00FE94:
    db $FD,$03

DATA_00FE96:
    db $00,$08,$F8,$10,$F8,$10

DATA_00FE9C:
    db $00,$00,$FF,$00,$FF,$00

DATA_00FEA2:
    db $08,$08,$0C,$0C,$14,$14

ShootFireball:
; Initial fireball X speeds.
; X offsets (lo) for spawning Mario's fireballs (L/R each).
; Normal
; On Yoshi
; On Yoshi and ducking
; X offsets (hi) for spawning Mario's fireballs (L/R each).
; Normal
; On Yoshi
; On Yoshi and ducking
; Y offsets for spawning Mario's fireballs.
; Normal
; On Yoshi
; On Yoshi and ducking
    LDX.B #$09                                ; \ Find a free fireball slot (08-09); Subroutine to spawn a fireball for Mario.
CODE_00FEAA:
    LDA.W ExtSpriteNumber,X                   ; |; Find an empty extended sprite slot, among slots 8 and 9.
    BEQ CODE_00FEB5                           ; |
    DEX                                       ; |
    CPX.B #$07                                ; |; Decrease this value to increase the number of fireballs Mario can shoot.
    BNE CODE_00FEAA                           ; |
    RTS                                       ; / Return if no free slots

CODE_00FEB5:
    LDA.B #!SFX_FIREBALL                      ; SFX for shooting a fireball.
    STA.W SPCIO3                              ; / Play sound effect
    LDA.B #$0A                                ; How long Mario shows the "shot fireball" pose.
    STA.W ShootFireTimer
    LDA.B #$05                                ; \ Extended sprite = Mario fireball; Extended sprite for the fireball.
    STA.W ExtSpriteNumber,X                   ; /
    LDA.B #$30                                ; Initial fireball Y speed.
    STA.W ExtSpriteYSpeed,X
    LDY.B PlayerDirection
    LDA.W DATA_00FE94,Y                       ; Set initial fireball X speed.
    STA.W ExtSpriteXSpeed,X
    LDA.W PlayerRidingYoshi
    BEQ +
    INY                                       ; If on Yoshi, increase index to 2/3.
    INY                                       ; If also ducking, increase index to 4/5.
    LDA.W PlayerDuckingOnYoshi
    BEQ +                                     ; Note that these values normally aren't used since you can't shoot fireballs on Yoshi (see $00D087 for doing so).
    INY
    INY
  + LDA.B PlayerXPosNext
    CLC
    ADC.W DATA_00FE96,Y
    STA.W ExtSpriteXPosLow,X                  ; Set X position.
    LDA.B PlayerXPosNext+1
    ADC.W DATA_00FE9C,Y
    STA.W ExtSpriteXPosHigh,X
    LDA.B PlayerYPosNext
    CLC
    ADC.W DATA_00FEA2,Y
    STA.W ExtSpriteYPosLow,X                  ; Set Y position.
    LDA.B PlayerYPosNext+1
    ADC.B #$00
    STA.W ExtSpriteYPosHigh,X
    LDA.W PlayerBehindNet                     ; Put on the same layer as Mario.
    STA.W ExtSpritePriority,X
    RTS

ADDR_00FF07:
    REP #$20                                  ; A->16; Routine to move Mario with the flying cage sprite when he's on the floor of it.
    LDA.W Layer1DYPos
    AND.W #$FF00
    BPL +
    ORA.W #$00FF
  + XBA                                       ; Move Mario horizontally with the platform.
    CLC
    ADC.B PlayerXPosNext
    STA.B PlayerXPosNext
    LDA.W LoadingLevelNumber
    AND.W #$FF00
    BPL +
    ORA.W #$00FF
  + XBA                                       ; Move Mario vertically with the platform.
    EOR.W #$FFFF
    INC A
    CLC
    ADC.B PlayerYPosNext
    STA.B PlayerYPosNext
    SEP #$20                                  ; A->8
    RTL

ADDR_00FF32:
    LDA.W SpriteXPosHigh,X                    ; Routine to store the flying cage sprite's position to the Layer 3 position addresses.
    XBA
    LDA.B SpriteXPosLow,X
    REP #$20                                  ; A->16
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.W #$0030
    SEC
    SBC.B _0
    STA.B Layer3XPos
    SEP #$20                                  ; A->8
    LDA.W SpriteYPosHigh,X
    XBA
    LDA.B SpriteYPosLow,X
    REP #$20                                  ; A->16
    SEC
    SBC.B Layer1YPos
    STA.B _0
    LDA.W #$0100
    SEC
    SBC.B _0
    STA.B Layer3YPos
    SEP #$20                                  ; A->8
    RTL

CODE_00FF61:
    LDA.W SpriteXPosHigh,X                    ; Routine to store the Layer 3 Smash sprite's position to the Layer 3 position addresses.
    XBA                                       ; Emulation IRQ and BRK vector
    LDA.B SpriteXPosLow,X
    REP #$20                                  ; A->16
    CMP.W #$FF00
    BMI CODE_00FF73
    CMP.W #$0100
    BMI +
CODE_00FF73:
    LDA.W #$0100
  + STA.B Layer3XPos
    SEP #$20                                  ; A->8
    LDA.W SpriteYPosHigh,X
    XBA
    LDA.B SpriteYPosLow,X
    REP #$20                                  ; A->16
    STA.B _0
    LDA.W #$00A0
    SEC
    SBC.B _0
    CLC
    ADC.W ScreenShakeYOffset
    STA.B Layer3YPos
    SEP #$20                                  ; A->8
    RTL

    %insert_empty($90,$2D,$2D,$0B,$0B)
