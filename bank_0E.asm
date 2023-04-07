    ORG $0E8000

SPC700Engine:
    dw SoundEffects-SPC700Engine-4
    dw SPCEngine

    arch spc700
    base SPCEngine

APU_Start:
    CLRP
    MOV X,#$CF
    MOV SP,X                                  ; set SP to (01)cf;
    MOV A,#$00
    MOV.W ARam_0386,A
    MOV.W ARam_0387,A
    MOV.W ARam_0388,A
    MOV.W ARam_0389,A                         ; zero 0386-9
    MOV X,A
  - MOV (X+),A
    CMP X,#$E8
    BNE -                                     ; zero 00-e7;
if ver_is_japanese(!_VER)                     ;\======================== J ====================
    MOV.W A,HotReset5A                        ;!
    CMP A,#$5A                                ;!
    BNE APU_0518                              ;!
    MOV.W A,HotResetA5                        ;!
    CMP A,#$A5                                ;!
    BEQ JAPU_0535                             ;!
endif                                         ;/===============================================
APU_0518:
    MOV A,#$00
    MOV X,A
  - MOV.W ARam_0200+X,A
    INC X
    BNE -                                     ; zero 0200-02ff;
  - MOV.W ARam_0300+X,A
    INC X
    BNE -                                     ; zero 0300-03ff;
if ver_is_japanese(!_VER)                     ;\======================== J ====================
JAPU_0535:                                    ;!
    MOV A,#$5A                                ;!
    MOV.W HotReset5A,A                        ;!
    MOV A,#$A5                                ;!
    MOV.W HotResetA5,A                        ;!
endif                                         ;/===============================================
    MOV X,#$0B
  - MOV.W A,DefaultDSPRegs+X
    MOV Y,A
    MOV.W A,DefaultDSPVals+X
    CALL WriteDSPReg                          ; write A to DSP reg Y;
    DEC X
    BPL -                                     ; set initial DSP reg values;
    MOV A,#$F0
    MOV.W HW_SPCCONTROL,A                     ; reset ports, disable timers
    MOV A,#$10
    MOV.W HW_TIMER0,A                         ; set timer0 freq to 2ms
    MOV A,#$36
    MOV.B MasterTempo+1,A                     ; set $51 to #$36
    MOV A,#$01
    MOV.W HW_SPCCONTROL,A                     ; start timer 0

APU_Loop:
    MOV.W Y,HW_COUNTER0                       ; main loop
    BEQ APU_Loop                              ; wait for counter 0 increment;
    PUSH Y
    MOV A,#$38
    MUL YA
    CLRC
    ADC.B A,SPCTimer
    MOV.B SPCTimer,A
    BCC +
    INC.B SPCTimer+1
    CALL APU_06AE
    MOV X,#$00
    CALL CopyToSNES                           ; read/send APU0;
    CALL APU_09E5
    MOV X,#$01
    CALL CopyToSNES                           ; read/send APU1;
    CALL APU_0816
    MOV X,#$03
    CALL CopyToSNES                           ; read/send APU3;
  + MOV.B A,MasterTempo+1
    POP Y
    MUL YA
    CLRC
    ADC.B A,ARam_49
    MOV.B ARam_49,A
    BCC APU_058D
    MOV.W A,ARam_0388
    BNE +
    CALL APU_0BC0
  + MOV X,#$02
    CALL CopyToSNES                           ; read/send APU2;
    BRA APU_Loop                              ; restart main loop;
APU_058D:
    MOV.B A,SPCOutBuffer+2                    ; if writing 0 to APU2 then
    BEQ APU_Loop                              ; restart main loop;

    MOV X,#$0E                                ; foreach voice;
    MOV.B CurrentChannel,#$80
  - MOV.B A,VoPhrasePtr+1+X
    BEQ +                                     ; skip call if vptr == 0;
    CALL APU_1198                             ; do per-voice fades/dsps?;
  + LSR.B CurrentChannel
    DEC X
    DEC X
    BPL -                                     ; loop for each voice;
    BRA APU_Loop                              ; restart main loop;

CopyToSNES:
    MOV A,X                                   ; SEND 04+X TO APUX; get APUX to 00+X with "debounce"?;
    MOV Y,A
    MOV.B A,SPCOutBuffer+X
    MOV.W HW_SNESIO0+X,A
  - MOV.W A,HW_SNESIO0+X
    CMP.W A,HW_SNESIO0+X
    BNE -
    MOV Y,A
    MOV.B A,SPCInBuffer+X
    MOV.B SPCInBuffer+X,Y
    CBNE.B SPCInBuffer+X,+
    MOV Y,#$00
    MOV.B SPCInEdge+X,Y
    RET                                       ; return with old value in A;

  + MOV.B SPCInEdge+X,Y
    MOV A,Y
    RET                                       ; return with new value in A;

HandleVCmd:
    CMP A,#$D0                                ; handle a note vcmd;
    BCS +                                     ; percussion note;
    CMP A,#$C6
    BCC APU_05E3                              ; normal notenum OR $80;
  - RET

  + MOV.B VoInstrument+1+X,A
    SETC
    SBC A,#$D0
    MOV Y,#$06
    MOV ARam_14,#$A5
    MOV ARam_15,#$5F
    CALL APU_0D56                             ; set sample A-$D0 in bank $5FA5 width 6;
    BNE -                                     ; return if 1D vbit set;
    INC Y
    MOV.B A,(ARam_14)+Y                       ; get perc note num from instr tbl
APU_05E3:
    AND A,#$7F
    CLRC
    ADC.B A,MasterTranspose                   ; add global transpose
    MOV.W ARam_02B0+1+X,A
    MOV.W A,ARam_02D0+1+X
    MOV.W ARam_02B0+X,A
    MOV A,#$00
    MOV.W ARam_0330+X,A
    MOV.W ARam_0360+X,A
    MOV.B VoVibrato+X,A
    MOV.W ARam_0110+X,A
    MOV.B ARam_B0+X,A
    OR.B (ARam_5C),(CurrentChannel)           ; set volume changed flg
    OR.B (ARam_47),(CurrentChannel)           ; set key on shadow vbit
    MOV.W A,ARam_0300+X
    MOV.B VoPitchSlide+X,A
    BEQ APU_062B
    MOV.W A,ARam_0300+1+X
    MOV.B VoPitchSlide+1+X,A
    MOV.W A,ARam_0320+X
    BNE +
    MOV.W A,ARam_02B0+1+X
    SETC
    SBC.W A,ARam_0320+1+X
    MOV.W ARam_02B0+1+X,A
  + MOV.W A,ARam_0320+1+X
    CLRC
    ADC.W A,ARam_02B0+1+X
    CALL APU_0F5D
APU_062B:
    MOV.W A,ARam_02B0+1+X
    MOV Y,A
    MOV.W A,ARam_02B0+X
    MOVW.B ARam_10,YA

APU_0634:
    MOV Y,#$00                                ; set DSP pitch from $10/11;
    MOV.B A,ARam_11
    SETC
    SBC A,#$34
    BCS APU_0646
    MOV.B A,ARam_11
    SETC
    SBC A,#$13
    BCS APU_064A
    DEC Y
    ASL A
APU_0646:
    ADDW.B YA,ARam_10
    MOVW.B ARam_10,YA
APU_064A:
    PUSH X
    MOV.B A,ARam_11
    CALL GetPitch
    MOVW.B ARam_14,YA                         ; $14/5 = pitch for notenum $11
    MOV.B A,ARam_11
    INC A
    CALL GetPitch                             ; get pitch for notenum $11 + 1;
    POP X
    SUBW.B YA,ARam_14
    PUSH A
    MOV.B A,ARam_10
    MUL YA                                    ; multiply pitch diff by fraction ($10);
    ADDW.B YA,ARam_14
    MOVW.B ARam_14,YA
    MOV.B A,ARam_10
    POP Y
    MUL YA
    MOV A,Y
    MOV Y,#$00
    ADDW.B YA,ARam_14
    MOVW.B ARam_14,YA
    MOV.W A,ARam_0210+X
    MOV.B Y,ARam_14
    MUL YA
    MOVW.B PitchValue,YA
    MOV.W A,ARam_0210+X
    MOV.B Y,ARam_15
    MUL YA
    CLRC
    ADC.B A,PitchValue+1
    MOV.B PitchValue+1,A                      ; $16/7 = $14/15 * 0210+X
    MOV A,X                                   ; set voice X pitch DSP reg from 16/7;
    XCN A                                     ; (if vbit clear in 1D);
    LSR A
    OR A,#$02
    MOV Y,A                                   ; Y = voice X pitch DSP reg;
    MOV.B A,PitchValue
    CALL WriteDSPRegCond
    INC Y
    MOV.B A,PitchValue+1

WriteDSPRegCond:
    PUSH A                                    ; write A to DSP reg Y if vbit clear in $1D;
    MOV.B A,CurrentChannel
    AND.B A,ChannelsMuted
    POP A
    BNE +
WriteDSPReg:
    MOV.W HW_DSPADDR,Y                        ; write A to DSP reg Y
    MOV.W HW_DSPDATA,A
  + RET

APU_069E:
    MOV A,#$0A
    MOV.W ARam_0387,A
    MOV.B A,MasterTempo+1
    CALL APU_0E14                             ; ADD #$0A TO TEMPO; zero tempo low;
    MOV A,#$1D
    MOV.B SPCInEdge+3,A
    BRA APU_06D2

APU_06AE:
    CMP.B SPCInEdge,#$12
    BEQ APU_06C2
    CMP.B SPCInEdge,#$11
    BEQ APU_06C2
    CMP.B SPCOutBuffer,#$11
    BEQ APU_06C8
    CMP.B SPCOutBuffer,#$1D
    BEQ APU_06C8
APU_06C2:
    MOV.B A,SPCInEdge
    BMI APU_069E
    BNE APU_06D2
APU_06C8:
    MOV.W A,ARam_0382
    BNE APU_071A
    MOV.B A,SPCOutBuffer
    BNE APU_074D
APU_06D1:
    RET

APU_06D2:
    MOV.B SPCOutBuffer,A
    MOV.W A,ARam_0388
    BEQ APU_06F7
    MOV A,#$00
    MOV.W ARam_0388,A
    MOV.W A,ARam_0389
    BNE +
    MOV A,#$20
    BRA APU_06F2                              ; disable echo write;
  + MOV A,#$16
    MOV.B EchoVolLeft+1,A
    MOV.B EchoVolRight+1,A
    CALL WriteDSPEchoVol                      ; set echo vol L/R to #$16;
    MOV A,#$00
APU_06F2:
    MOV Y,#DSP_FLG
    CALL WriteDSPReg                          ; unmute sound, enable echo write;
APU_06F7:
    MOV A,#$02
    MOV.W ARam_0382,A
    CMP.B SPCOutBuffer,#$11
    BNE +
    MOV.W A,ARam_0389
    BEQ +
    MOV A,#$00
    CALL APU_0F22
  + MOV A,#$10
    MOV Y,#DSP_KOF
    CALL WriteDSPReg                          ; key off voice 4;
    SET4.B ChannelsMuted
    MOV A,#$00
    MOV.W ARam_0300+8,A
    RET

APU_071A:
    DEC.W ARam_0382                           ; 0382 nonzero;
    BNE APU_06D1                              ; ret;
APU_071F:
    MOV.B A,SPCOutBuffer
    ASL A
    MOV Y,A
    MOV.W A,SFXPtrs1DF9-2+Y
    MOV.B SFX1DF9PhrasePtr,A
    MOV.W A,SFXPtrs1DF9-1+Y
    MOV.B SFX1DF9PhrasePtr+1,A
    BRA APU_0754
APU_072F:
    CMP.B SPCOutBuffer,#$11
    BNE +
    MOV A,#$60
    MOV.W ARam_0388,A
    MOV Y,#DSP_FLG
    CALL WriteDSPReg                          ; mute sound, disable echo write;
  + MOV SPCOutBuffer,#$00
    CLR4.B ChannelsMuted
    MOV X,#$08
    MOV.B A,VoInstrument+9
    BEQ +
    JMP APU_0D4B
  + RET

APU_074D:
    DEC.W ARam_0380
    BNE APU_07A6
APU_0752:
    INCW.B SFX1DF9PhrasePtr
APU_0754:
    MOV X,#$00
    MOV.B A,(SFX1DF9PhrasePtr+X)
    BEQ APU_072F
    BMI APU_0786
    MOV.W ARam_0381,A
    INCW.B SFX1DF9PhrasePtr
    MOV.B A,(SFX1DF9PhrasePtr+X)
    MOV.B ARam_10,A
    BMI APU_0786
    MOV Y,#DSP_VOLL+$40
    CALL WriteDSPReg                          ; set voice 4 vol L;
    INCW.B SFX1DF9PhrasePtr
    MOV.B A,(SFX1DF9PhrasePtr+X)
    BPL APU_077D
    MOV X,A
    MOV.B A,ARam_10
    MOV Y,#DSP_VOLR+$40
    CALL WriteDSPReg                          ; set voice 4 vol R (same as vol L);
    MOV A,X
    BRA APU_0786

APU_077D:
    MOV Y,#DSP_VOLR+$40
    CALL WriteDSPReg                          ; set voice 4 vol R (different from vol L);
    INCW.B SFX1DF9PhrasePtr
    MOV.B A,(SFX1DF9PhrasePtr+X)
APU_0786:
    CMP A,#$DA
    BEQ APU_07F3
    CMP A,#$DD
    BEQ APU_07C2
    CMP A,#$EB
    BEQ APU_07D5
    CMP A,#$FF
    BEQ APU_071F
    MOV X,#$08
    CALL HandleVCmd
    MOV A,#$10
    CALL APU_0D32                             ; key on voice 4;
APU_07A0:
    MOV.W A,ARam_0381
    MOV.W ARam_0380,A
APU_07A6:
    CLR7.B ARam_13
    MOV X,#$08
    MOV.B A,VoPitchSlide+X
    BEQ APU_07B3
    CALL PitchSlideDelta
    BRA +
APU_07B3:
    MOV A,#$02
    CMP.W A,ARam_0380
    BNE +
    MOV A,#$10
    MOV Y,#DSP_KOF
    CALL WriteDSPReg                          ; key off voice 4;
  + RET

APU_07C2:
    MOV X,#$00
    INCW.B SFX1DF9PhrasePtr
    MOV.B A,(SFX1DF9PhrasePtr+X)
    MOV.B CurrentChannel2,#$08
    MOV X,#$08
    CALL HandleVCmd
    MOV A,#$10
    CALL APU_0D32                             ; key on voice 4;
APU_07D5:
    MOV X,#$00
    INCW.B SFX1DF9PhrasePtr
    MOV.B A,(SFX1DF9PhrasePtr+X)
    MOV.B VoPitchSlide+9,A
    INCW.B SFX1DF9PhrasePtr
    MOV.B A,(SFX1DF9PhrasePtr+X)
    MOV.B VoPitchSlide+8,A
    PUSH A
    INCW.B SFX1DF9PhrasePtr
    MOV.B A,(SFX1DF9PhrasePtr+X)
    POP Y
    MOV.B CurrentChannel2,#$08
    MOV X,#$08
    CALL APU_0F5D
    BRA APU_07A0

APU_07F3:
    MOV X,#$00
    INCW.B SFX1DF9PhrasePtr
    MOV.B A,(SFX1DF9PhrasePtr+X)
    MOV Y,#$09                                ; set DSP regs for voice 4 from 5570+(9*A);
    MUL YA
    MOV X,A
    MOV Y,#DSP_VOLL+$40
    MOV ARam_12,#$08
  - MOV.W A,SFXDSPSettings+X
    CALL WriteDSPReg
    INC X
    INC Y
    DBNZ.B ARam_12,-
    MOV.W A,SFXDSPSettings+X
    MOV.W ARam_0210+8,A
    JMP APU_0752

APU_0816:
    CMP.B SPCOutBuffer+3,#$24
    BEQ +
    CMP.B SPCInEdge+3,#$24
    BEQ ++
    CMP.B SPCOutBuffer+3,#$1D
    BEQ +
    CMP.B SPCOutBuffer+3,#$05
    BEQ +
 ++ MOV.B A,SPCInEdge+3
    BNE APU_0837
  + MOV.B A,ARam_0C+1
    BNE APU_084B
    MOV.B A,SPCOutBuffer+3
    BNE APU_0876
  - RET

APU_0837:
    MOV.B SPCOutBuffer+3,A
    MOV.B ARam_0C+1,#$02
    MOV A,#$40
    MOV Y,#DSP_KOF
    CALL WriteDSPReg                          ; key off voice 6 now;
    SET6.B ChannelsMuted                      ; don't set vol DSP for voice 6
    MOV A,#$00
    MOV.W ARam_0300+$0C,A
    RET
APU_084B:
    DBNZ.B ARam_0C+1,-
    MOV.B A,SPCOutBuffer+3
    ASL A
    MOV Y,A
    MOV.W A,SFXPtrs1DFC-2+Y
    MOV.B SFX1DFCPhrasePtr,A
    MOV.W A,SFXPtrs1DFC-1+Y
    MOV.B SFX1DFCPhrasePtr+1,A
    BRA APU_087D
APU_085E:
    MOV.B SPCOutBuffer+3,#$00
    CLR6.B ChannelsMuted                      ; OK to use voice 6 again
    MOV A,#$00
    MOV.B ARam_2F,A
    MOV Y,#DSP_NON
    CALL WriteDSPReg                          ; noise vbits off;
    MOV X,#$0C
    MOV.B A,VoInstrument+$0D
    BEQ +
    JMP APU_0D4B
  + RET

APU_0876:
    DEC.W ARam_0384
    BNE APU_08D3
APU_087B:
    INCW.B SFX1DFCPhrasePtr
APU_087D:
    MOV X,#$00
    MOV.B A,(SFX1DFCPhrasePtr+X)
    BEQ APU_085E
    BMI APU_08AF
    MOV.W ARam_0385,A
    INCW.B SFX1DFCPhrasePtr
    MOV.B A,(SFX1DFCPhrasePtr+X)
    MOV.B ARam_10,A
    BMI APU_08AF
    MOV Y,#DSP_VOLL+$60
    CALL WriteDSPReg                          ; set voice 6 vol L;
    INCW.B SFX1DFCPhrasePtr
    MOV.B A,(SFX1DFCPhrasePtr+X)
    BPL +
    MOV X,A
    MOV.B A,ARam_10
    MOV Y,#DSP_VOLR+$60
    CALL WriteDSPReg                          ; set voice 6 vol R (same as vol L);
    MOV A,X
    BRA APU_08AF
  + MOV Y,#DSP_VOLR+$60
    CALL WriteDSPReg                          ; set voice 6 vol R (different from vol R);
    INCW.B SFX1DFCPhrasePtr
    MOV.B A,(SFX1DFCPhrasePtr+X)
APU_08AF:
    CMP A,#$DA
    BEQ APU_0920
    CMP A,#$DD
    BEQ APU_08EF
    CMP A,#$EB
    BEQ APU_0902
    CMP A,#$FF
    BNE +
    DECW.B SFX1DFCPhrasePtr
    BRA APU_087D

  + MOV X,#$0C                                ; other $80+;
    CALL HandleVCmd
    MOV A,#$40
    CALL APU_0D32                             ; key on voice 6;
APU_08CD:
    MOV.W A,ARam_0385
    MOV.W ARam_0384,A
APU_08D3:
    CLR7.B ARam_13
    MOV X,#$0C
    MOV.B A,VoPitchSlide+X                    ; pitch slide counter
    BEQ APU_08E0
    CALL PitchSlideDelta                      ; add pitch slide delta and set DSP pitch;
    BRA +
APU_08E0:
    MOV A,#$02
    CMP.W A,ARam_0384
    BNE +
    MOV A,#$40
    MOV Y,#DSP_KOF
    CALL WriteDSPReg                          ; key off voice 6 now;
  + RET

APU_08EF:
    MOV X,#$00                                ; DD;
    INCW.B SFX1DFCPhrasePtr
    MOV.B A,(SFX1DFCPhrasePtr+X)
    MOV.B CurrentChannel2,#$0C
    MOV X,#$0C
    CALL HandleVCmd
    MOV A,#$40
    CALL APU_0D32                             ; key on voice 6;

APU_0902:
    MOV X,#$00                                ; EB;
    INCW.B SFX1DFCPhrasePtr
    MOV.B A,(SFX1DFCPhrasePtr+X)
    MOV.B VoPitchSlide+$0D,A
    INCW.B SFX1DFCPhrasePtr
    MOV.B A,(SFX1DFCPhrasePtr+X)
    MOV.B VoPitchSlide+$0C,A
    PUSH A
    INCW.B SFX1DFCPhrasePtr
    MOV.B A,(SFX1DFCPhrasePtr+X)
    POP Y
    MOV.B CurrentChannel2,#$0C
    MOV X,#$0C
    CALL APU_0F5D
    BRA APU_08CD

APU_0920:
    MOV A,#$00                                ; DA;
    MOV.B ARam_2F,A
    MOV Y,#DSP_NON
    CALL WriteDSPReg
APU_0929:
    MOV X,#$00
    INCW.B SFX1DFCPhrasePtr
    MOV.B A,(SFX1DFCPhrasePtr+X)
    BMI +
    MOV Y,#$09                                ; set DSP regs for voice 6 from 5570+(9*A);
    MUL YA
    MOV X,A
    MOV Y,#DSP_VOLL+$60
    MOV ARam_12,#$08
  - MOV.W A,SFXDSPSettings+X
    CALL WriteDSPReg
    INC X
    INC Y
    DBNZ.B ARam_12,-
    MOV.W A,SFXDSPSettings+X
    MOV.W ARam_0210+$0C,A
    JMP APU_087B
  + AND A,#$1F
    MOV.B ARam_2E,A
    MOV Y,#DSP_FLG
    CALL WriteDSPReg                          ; set noise frequency;
    MOV A,#$40
    MOV.B ARam_2F,A
    MOV Y,#DSP_NON
    CALL WriteDSPReg                          ; enable noise on voice 6;
    BRA APU_0929

SFXDSPRegs:
    MOV Y,#$09                                ; set DSP regs for voice 5 from 5570+(9*A);
    MUL YA
    MOV X,A
    MOV Y,#DSP_VOLL+$50
    MOV ARam_12,#$08
  - MOV.W A,SFXDSPSettings+X
    CALL WriteDSPReg
    INC X
    INC Y
    DBNZ.B ARam_12,-
    MOV.W A,SFXDSPSettings+X
    MOV.W ARam_0210+$0A,A                     ; set voice 5 pitch mult from 5570+X;
    RET

APU_097D:
    MOV.B A,SPCOutBuffer+2                    ; $01 = 02;
    CMP A,#$06
    BEQ +
    AND A,#$FC
    BNE APU_0A03
  + MOV.W A,ARam_0386
    BNE APU_099A
    MOV A,#$09
    CALL SFXDSPRegs                           ; set voice 5 DSP from 5570+(9*9);
    MOV A,#$01
    BNE +
APU_0995:
    MOV A,#$00                                ; $01 = 03;
  + MOV.W ARam_0386,A
APU_099A:
    BRA APU_0A03

APU_099C:
    MOV A,#$60                                ; $01 = FF (reset?);
    MOV Y,#DSP_FLG
    CALL WriteDSPReg                          ; mute all voices;
    MOV A,#$FF
    MOV Y,#DSP_KOF
    CALL WriteDSPReg                          ; key off all voices now;
    CALL StandardTransfer                     ; do standardish SPC transfer;
    MOV A,#$00
    MOV.B SPCOutBuffer,A
    MOV.B SPCOutBuffer+1,A
    MOV.B SPCOutBuffer+2,A
    MOV.B SPCOutBuffer+3,A
    MOV.B ChannelsMuted,A
    MOV.W ARam_0387,A
    MOV.W ARam_0388,A
    MOV.W ARam_0386,A
    MOV.W ARam_0389,A
    MOV A,#$20
    MOV Y,#DSP_FLG
    CALL WriteDSPReg                          ; unmute voices;
    RET

PitchSlideDelta:
    MOV A,#$B0                                ; add pitch slide delta and set DSP pitch;
    MOV Y,#$02                                ; pitch (notenum fixed-point);
    DEC.B VoPitchSlide+X
    CALL APU_1075                             ; add pitch slide delta to value;
    MOV.W A,ARam_02B0+1+X
    MOV Y,A
    MOV.W A,ARam_02B0+X
    MOVW.B ARam_10,YA
    MOV.B CurrentChannel,#$00                 ; vbit flags = 0 (to force DSP set);
    JMP APU_0634                              ; force voice DSP pitch from 02B0/1;

APU_09E5:
    MOV.B A,SPCInEdge+1
    CMP A,#$FF
    BEQ APU_099C
    CMP A,#$02
    BEQ APU_097D
    CMP A,#$03
    BEQ APU_0995
    CMP A,#$01
    BEQ APU_0A14
    MOV.B A,SPCOutBuffer+1
    CMP A,#$01
    BEQ APU_0A03
    MOV.B A,SPCInEdge+1
    CMP A,#$04
    BEQ APU_0A0E                              ; (jmp $0ace);

APU_0A03:
    MOV.B A,SPCOutBuffer+1
    CMP A,#$01
    BEQ APU_0A51
    CMP A,#$04
    BEQ +                                     ; (jmp $0b08);
APU_0A0D:
    RET

APU_0A0E:
    JMP APU_0ACE
  + JMP APU_0B08

APU_0A14:
    MOV.B SPCOutBuffer+1,A                    ; $01 = 01
    MOV A,#$04
    MOV.W ARam_0383,A
    MOV A,#$80
    MOV Y,#DSP_KOF
    CALL WriteDSPReg                          ; key off voice 7;
    SET7.B ChannelsMuted
    MOV A,#$00
    MOV Y,#$20
  - MOV.W ARam_0300-1+Y,A
    DBNZ Y,-
    RET

APU_0A2E:
    DEC.W ARam_0383
    BNE APU_0A0D
    MOV.B ARam_1C,#$30
    BRA APU_0A68
  - CMP.B ARam_1C,#$2A
    BNE APU_0A99
    MOV.B CurrentChannel2,#$0E
    MOV X,#$0E
    MOV Y,#$00
    MOV.B VoPitchSlide+$0F,Y
    MOV Y,#$12
    MOV.B VoPitchSlide+$0E,Y
    MOV A,#$B9
    CALL APU_0F5D
    BRA APU_0A99

APU_0A51:
    MOV.W A,ARam_0383
    BNE APU_0A2E
    DBNZ.B ARam_1C,-
    MOV.B SPCOutBuffer+1,#$00
    CLR7.B ChannelsMuted
    MOV X,#$0E
    MOV.B A,VoInstrument+$0F
    BEQ +
    JMP APU_0D4B
  + RET

APU_0A68:
    CALL APU_0AB1
    MOV A,#$B2
    MOV CurrentChannel2,#$0E
    MOV X,#$0E
    CALL HandleVCmd
    MOV Y,#$00
    MOV.B VoPitchSlide+$0F,Y
    MOV Y,#$05
    MOV.B VoPitchSlide+$0E,Y
    MOV A,#$B5
    CALL APU_0F5D
    MOV A,#$38
    MOV.B ARam_10,A
    MOV Y,#DSP_VOLL+$70
    CALL WriteDSPReg                          ; set voice 7 vol L to #$38;
    MOV A,#$38
    MOV.B ARam_10,A
    MOV Y,#DSP_VOLR+$70
    CALL WriteDSPReg                          ; set voice 7 vol R to #$38;
    MOV A,#$80
    CALL APU_0D32                             ; key on voice 7;
APU_0A99:
    MOV A,#$02
    CBNE.B ARam_1C,+
    MOV A,#$80
    MOV Y,#DSP_KOF
    CALL WriteDSPReg                          ; key off voice 7;
  + CLR7.B ARam_13
    MOV.B A,VoPitchSlide+$0E
    BEQ +
    MOV X,#$0E
    CALL PitchSlideDelta
  + RET

APU_0AB1:
    MOV A,#$08
APU_0AB3:
    MOV Y,#$09                                ; set DSP regs for voice 7 from 5570+(9*A);
    MUL YA
    MOV X,A
    MOV Y,#DSP_VOLL+$70
    MOV.B ARam_12,#$08
  - MOV.W A,SFXDSPSettings+X
    CALL WriteDSPReg
    INC X
    INC Y
    DBNZ.B ARam_12,-
    MOV.W A,SFXDSPSettings+X
    MOV.W ARam_0210+$0E,A
    RET

APU_0ACE:
    MOV.B SPCOutBuffer+1,A                    ; $01 = 04 && $05 != 01
    MOV A,#$04
    MOV.W ARam_0383,A
    MOV A,#$80
    MOV Y,#DSP_KOF
    CALL WriteDSPReg                          ; key off voice 7 now;
    SET7.B ChannelsMuted
    MOV A,#$00
    MOV Y,#$20
  - MOV.W ARam_0300-1+Y,A
    DBNZ Y,-
  - RET

APU_0AE8:
    DEC.W ARam_0383
    BNE -
    MOV.B ARam_1C,#$18
    BRA +
APU_0AF2:
    CMP.B ARam_1C,#$0C
    BNE APU_0B33
  + MOV A,#$07
    CALL APU_0AB3
    MOV A,#$A4
    MOV.B CurrentChannel2,#$0E
    MOV X,#$0E
    CALL HandleVCmd
    BRA APU_0B1C

APU_0B08:
    MOV.W A,ARam_0383
    BNE APU_0AE8
    DBNZ.B ARam_1C,APU_0AF2
    MOV.B SPCOutBuffer+1,#$00
    CLR7.B ChannelsMuted
    MOV X,#$0E
    MOV.B A,VoInstrument+$0F
    JMP APU_0D4B
APU_0B1C:
    MOV A,#$28
    MOV.B ARam_10,A
    MOV Y,#DSP_VOLL+$70
    CALL WriteDSPReg                          ; set voice 7 vol L to #$28;
    MOV A,#$28
    MOV.B ARam_10,A
    MOV Y,#DSP_VOLR+$70
    CALL WriteDSPReg                          ; set voice 7 vol R to #$28;
    MOV A,#$80
    CALL APU_0D32                             ; key on voice 7;
APU_0B33:
    MOV A,#$02
    CBNE.B ARam_1C,+
    MOV A,#$80
    MOV Y,#DSP_KOF
    CALL WriteDSPReg                          ; key off voice 7;
  + RET

APU_0B40:
    SETC                                      ; play song in A?;
    CMP A,#$16
    BEQ +
    CMP A,#$10
    BEQ +
    CMP A,#$0F
    BEQ +
    CMP A,#$09
    BCC ++
    CMP A,#$0D
    BCS ++
  + MOV Y,#$00
    MOV.W ARam_0387,Y
 ++ MOV.B SPCOutBuffer+2,A
    MOV.B ARam_0C,#$02
    ASL A
    MOV Y,A
    MOV.W A,MusicData-2+Y
    MOV.B BlockPtr,A
    MOV.W A,MusicData-1+Y
    MOV.B BlockPtr+1,A

    MOV X,#$0E                                ; foreach voice;
  - MOV A,#$0A
    MOV.W ARam_0280+1+X,A                     ; pan
    MOV A,#$FF
    MOV.W ARam_0240+1+X,A                     ; voice base vol
    MOV A,#$00
    MOV.W ARam_02D0+1+X,A                     ; portamento off
    MOV.B VoPanFade+1+X,A                     ; pan fade ctr
    MOV.B VoPanFade+X,A                       ; vol fade ctr
    MOV.B VoVibrato+1+X,A
    MOV.B ARam_B0+1+X,A
    MOV.B VoInstrument+X,A                    ; repeat ctr
    MOV.B VoInstrument+1+X,A                  ; current instr
    DEC X
    DEC X
    BPL -

    MOV.B VolFadeTimer,A                      ; master vol fade ctr
    MOV.B ARam_60,A                           ; echo vol fade ctr
    MOV.B TempoSetTimer,A                     ; tempo fade ctr
    MOV.B MasterTranspose,A                   ; global transpose
    MOV.B MasterVolume,#$C0                   ; master vol
    MOV.B MasterTempo+1,#$36                  ; tempo
    MOV Y,#$20
  - MOV.W ARam_0300-1+Y,A
    DBNZ Y,-                                  ; zero $0300-031f;
    BRA +
APU_0BA3:
    MOV.B SPCOutBuffer+2,A
  + MOV.B A,ChannelsMuted
    EOR A,#$FF
    MOV Y,#DSP_KOF
    JMP WriteDSPReg                           ; key off all unmuted voices;

APU_0BAE:
    MOV X,#$F0                                ; fade volume out over 240 counts;
    MOV.B VolFadeTimer,X
    MOV A,#$00
    MOV.B VolFadeVal,A
    SETC
    SBC.B A,MasterVolume
    CALL APU_0F76
    MOVW.B ARam_5A,YA                         ; set volume fade out after 240 counts
    BRA APU_0BE7

APU_0BC0:
    MOV.B A,SPCOutBuffer+2
    BEQ APU_0BDE
    CMP A,#$06
    BEQ ++
    AND A,#$FC
    BNE +
 ++ MOV.W A,ARam_0386
    BNE +
    MOV A,#$20
    MOV Y,#DSP_KOF
    CALL WriteDSPReg                          ; key off voice 5;
    SET5.B ChannelsMuted
    BRA APU_0BDE
  + CLR5.B ChannelsMuted
APU_0BDE:
    MOV.B A,SPCInEdge+2
    BMI APU_0BAE
    BEQ APU_0BE7
    JMP APU_0B40                              ; play song in A?;

APU_0BE7:
    MOV.B A,ARam_0C
    BNE APU_0BFE
    MOV.B A,SPCOutBuffer+2
    BNE APU_0C46
  - RET

APU_0BF0:
    MOV Y,#$00                                ; read next word at $40 into YA;
    MOV.B A,(BlockPtr)+Y
    INCW.B BlockPtr
    PUSH A
    MOV.B A,(BlockPtr)+Y
    INCW.B BlockPtr
    MOV Y,A
    POP A
    RET

APU_0BFE:
    DBNZ.B ARam_0C,-
APU_0C01:
    CALL APU_0BF0                             ; read next word at $40;
    MOVW.B PitchValue,YA                      ; save in $16/17
    MOV A,Y                                   ; high byte zero?;
    BNE APU_0C22
    MOV.B A,PitchValue                        ; refetch lo byte
    BEQ APU_0BA3                              ; key off, return if also zero;
    DEC.B MusicLoopCounter
    BEQ APU_0C1C
    BPL +
    MOV.B MusicLoopCounter,A
  + CALL APU_0BF0                             ; read next word at $40;
    MOVW.B BlockPtr,YA                        ; "goto" that address
    BRA APU_0C01                              ; and continue;
APU_0C1C:
    INCW.B BlockPtr
    INCW.B BlockPtr                           ; skip goto address
    BRA APU_0C01                              ; continue;

APU_0C22:
    MOV Y,#$0F                                ; high byte not zero:;
  - MOV.B A,(PitchValue)+Y
    MOV.W VoPhrasePtr+Y,A
    DEC Y
    BPL -                                     ; set vptrs from [$16];

    MOV X,#$0E
    MOV.B CurrentChannel,#$80                 ; foreach voice
  - MOV.B A,VoPhrasePtr+1+X
    BEQ +                                     ; next if vptr hi = 0;
    MOV A,#$01
    MOV.B VoTimers+X,A                        ; set duration counter to 1
    MOV.B A,VoInstrument+1+X
    BNE +
    CALL APU_0D4A                             ; set instr to 0 if no instr set;
  + LSR.B CurrentChannel
    DEC X
    DEC X
    BPL -                                     ; loop;

APU_0C46:
    MOV X,#$00
    MOV.B ARam_47,X
    MOV.B CurrentChannel,#$01                 ; foreach voice
APU_0C4D:
    MOV.B CurrentChannel2,X
    MOV.B A,VoPhrasePtr+1+X
    BEQ APU_0CC9                              ; next if vptr hi zero;
    DEC.B VoTimers+X                          ; dec duration counter
    BNE APU_0CC6                              ; if not zero, skip to voice readahead;
APU_0C57:
    CALL NextVCmd                             ; get next vbyte;
    BNE APU_0C7A
    MOV.B A,VoInstrument+X                    ; vcmd 00:  end repeat/return
    BEQ APU_0C01                              ; goto next $40 section if rpt count 0;
    DEC.B VoInstrument+X                      ; dec repeat count
    BNE APU_0C6E                              ; if zero then;
    MOV.W A,ARam_03E0+X
    MOV.B VoPhrasePtr+X,A
    MOV.W A,ARam_03E0+1+X
    BRA +                                     ; goto 03E0/1;
APU_0C6E:
    MOV.W A,ARam_03F0+X                       ; else
    MOV.B VoPhrasePtr+X,A
    MOV.W A,ARam_03F0+1+X                     ; goto 03F0/1
  + MOV.B VoPhrasePtr+1+X,A
    BRA APU_0C57                              ; continue to next vbyte;

APU_0C7A:
    BMI APU_0C9F                              ; vcmds 01-7f:;
    MOV.W ARam_0200+X,A                       ; set cmd as duration
    CALL NextVCmd                             ; get next vcmd;
    BMI APU_0C9F                              ; if not note then;
    PUSH A
    XCN A
    AND A,#$07
    MOV Y,A
    MOV.W A,NoteDurs+Y
    MOV.W ARam_0200+1+X,A                     ; set dur% from high nybble
    POP A
    AND A,#$0F
    MOV Y,A
    MOV.W A,VelocityValues+Y
    MOV.W ARam_0210+1+X,A                     ; set per-note vol from low nybble
    OR.B (ARam_5C),(CurrentChannel)           ; mark vol changed?
    CALL NextVCmd                             ; get next vbyte;
APU_0C9F:
    CMP A,#$DA
    BCC +                                     ; vcmd da-ff:;
    CALL APU_0D40                             ; dispatch vcmd;
    BRA APU_0C57                              ; do next vcmd;

  + PUSH A                                    ; vcmd 80-d9 (note);
    MOV.B A,CurrentChannel
    AND.B A,ChannelsMuted
    POP A
    BNE +
    CALL HandleVCmd                           ; handle note cmd if vbit 1D clear;
  + MOV.W A,ARam_0200+X
    MOV.B VoTimers+X,A                        ; set duration counter from duration
    MOV Y,A
    MOV.W A,ARam_0200+1+X
    MUL YA
    MOV A,Y
    BNE +
    INC A
  + MOV.W NoteLength+X,A                      ; set note dur counter from dur * dur%
    BRA APU_0CC9
APU_0CC6:
    CALL APU_10A1                             ; do voice readahead;
APU_0CC9:
    INC X
    INC X
    ASL.B CurrentChannel
    BCS +
    JMP APU_0C4D                              ; loop;

  + MOV.B A,TempoSetTimer                     ; do global fades
    BEQ APU_0CE3
    DBNZ.B TempoSetTimer,+
    MOVW.B YA,TempoSetTimer
    BRA APU_0CE1

  + MOVW.B YA,ARam_54
    ADDW.B YA,MasterTempo
APU_0CE1:
    MOVW.B MasterTempo,YA
APU_0CE3:
    MOV.B A,ARam_60
    BEQ APU_0D03
    DBNZ.B ARam_60,+
    MOV A,#$00
    MOV.B Y,EchoVolLeft+1
    MOVW.B EchoVolLeft,YA
    MOV.B Y,EchoVolRight+1
    BRA APU_0CFE

  + MOVW.B YA,ARam_65
    ADDW.B YA,EchoVolLeft
    MOVW.B EchoVolLeft,YA
    MOVW.B YA,ARam_67
    ADDW.B YA,EchoVolRight
APU_0CFE:
    MOVW.B EchoVolRight,YA
    CALL WriteDSPEchoVol
APU_0D03:
    MOV.B A,VolFadeTimer
    BEQ APU_0D17
    DBNZ.B VolFadeTimer,+
    MOVW.B YA,VolFadeTimer
    BRA APU_0D12

  + MOVW.B YA,ARam_5A
    ADDW.B YA,ARam_56
APU_0D12:
    MOVW.B ARam_56,YA
    MOV.B ARam_5C,#$FF                        ; set all vol chg flags

APU_0D17:
    MOV X,#$0E
    MOV.B CurrentChannel,#$80
  - MOV.B A,VoPhrasePtr+1+X
    BEQ +
    CALL APU_0FDB                             ; per-voice fades?;
  + LSR.B CurrentChannel
    DEC X
    DEC X
    BPL -
    MOV.B ARam_5C,#$00                        ; clear volchg flags
    MOV.B A,ChannelsMuted
    EOR A,#$FF
    AND.B A,ARam_47
APU_0D32:
    PUSH A                                    ; key on voices in A;
    MOV Y,#DSP_KOF
    MOV A,#$00
    CALL WriteDSPReg                          ; key off none;
    POP A
    MOV Y,#DSP_KON
    JMP WriteDSPReg                           ; key on voices from A;

APU_0D40:
    ASL A                                     ; dispatch vcmd in A;
    MOV X,A
    MOV A,#$00
    JMP (VCmdPtrs-$B4+X)                      ; $DA minimum? (F90);

VCmd_DA:
    CALL NextVCmd46                           ; vcmd DA: set instrument;

APU_0D4A:
    INC A                                     ; set instrument to A;
APU_0D4B:
    MOV.B VoInstrument+1+X,A
    DEC A
    MOV Y,#$05
    MOV.B ARam_14,#$46
    MOV.B ARam_15,#$5F

APU_0D56:
    MUL YA                                    ; set sample A in bank at $14/15 width Y;
    ADDW.B YA,ARam_14
    MOVW.B ARam_14,YA
    MOV.B A,CurrentChannel
    AND.B A,ChannelsMuted
    BNE APU_0D8D
    PUSH X
    MOV A,X
    XCN A
    LSR A
    OR A,#$04                                 ; voice X SRCN;
    MOV X,A
    MOV.B A,CurrentChannel
    EOR A,#$FF
    AND.B A,ARam_2F
    MOV.B ARam_2F,A
    MOV Y,#DSP_NON
    CALL WriteDSPReg                          ; clear noise vbit;
    MOV Y,#$00
  - MOV.B A,(ARam_14)+Y
    MOV.W HW_DSPADDR,X
    MOV.W HW_DSPDATA,A
    INC X
    INC Y
    CMP Y,#$04
    BNE -                                     ; set SRCN, ADSR1/2, GAIN;
    MOV.B A,(ARam_14)+Y
    POP X
    MOV.W ARam_0210+X,A                       ; set pitch multiplier
    MOV A,#$00
APU_0D8D:
    RET

VCmd_DB:
    CALL NextVCmd46                           ; vcmd DB: set pan;
    AND A,#$1F
    MOV.W ARam_0280+1+X,A                     ; voice pan value
    MOV A,Y
    AND A,#$C0
    MOV.W ARam_02A0+1+X,A                     ; negate voice vol bits
    MOV A,#$00
    MOV.W ARam_0280+X,A
    OR.B (ARam_5C),(CurrentChannel)           ; set vol chg flag
    RET

VCmd_DC:
    CALL NextVCmd46                           ; vcmd DC: pan fade;
    MOV.B VoPanFade+1+X,A
    PUSH A
    CALL NextVCmd
    MOV.W ARam_02A0+X,A
    SETC
    SBC.W A,ARam_0280+1+X                     ; current pan value
    POP X
    CALL APU_0F76                             ; delta = pan value / steps;
    MOV.W ARam_0290+X,A
    MOV A,Y
    MOV.W ARam_0290+1+X,A
    RET

VCmd_DE:
    CALL NextVCmd46                           ; vcmd DE: vibrato on;
    MOV.W ARam_0340+X,A
    MOV A,#$00
    MOV.W ARam_0340+1+X,A
    CALL NextVCmd
    MOV.W ARam_0330+1+X,A
    CALL NextVCmd

VCmd_DF:
    MOV.B X,CurrentChannel2                   ; vcmd DF: vibrato off
    MOV.B VoVibrato+1+X,A
    RET

VCmd_EA:
    CALL NextVCmd46                           ; vcmd EA: vibrato fade;
    MOV.W ARam_0340+1+X,A
    PUSH A
    MOV.B A,VoVibrato+1+X
    MOV.W ARam_0350+1+X,A
    POP X
    MOV Y,#$00
    DIV YA,X
    MOV.B X,CurrentChannel2
    MOV.W ARam_0350+X,A
    RET

VCmd_E0:
    CALL NextVCmd46                           ; vcmd E0: set master volume;
    MOV.B MasterVolume,A
    MOV.B ARam_56,#$00
    MOV.B ARam_5C,#$FF                        ; all vol chgd
    RET

VCmd_E1:
    CALL NextVCmd46                           ; vcmd E1: master vol fade;
    MOV.B VolFadeTimer,A
    CALL NextVCmd
    MOV.B VolFadeVal,A
    MOV.B X,VolFadeTimer
    SETC
    SBC.B A,MasterVolume
    CALL APU_0F76
    MOVW.B ARam_5A,YA
    RET

VCmd_E2:
    CALL NextVCmd46                           ; vcmd E2: tempo;
APU_0E14:
    ADC.W A,ARam_0387                         ; set tempo
    MOV.B MasterTempo+1,A
    MOV.B MasterTempo,#$00
    RET

VCmd_E3:
    CALL NextVCmd46                           ; vcmd E3: tempo fade;
    MOV.B TempoSetTimer,A
    CALL NextVCmd
    ADC.W A,ARam_0387
    MOV.B TempoSetVal,A
    MOV.B X,TempoSetTimer
    SETC
    SBC.B A,MasterTempo+1
    CALL APU_0F76
    MOVW.B ARam_54,YA
    RET

VCmd_E4:
    CALL NextVCmd46                           ; vcmd E4: transpose (global);
    MOV.B MasterTranspose,A
    RET

VCmd_E5:
    CALL NextVCmd46                           ; vcmd E5: tremolo on;
    MOV.W ARam_0370+X,A
    CALL NextVCmd
    MOV.W ARam_0360+2+X,A
    CALL NextVCmd

VCmd_E6:
    MOV.B X,CurrentChannel2                   ; vcmd E6: tremolo off
    MOV.B ARam_B0+1+X,A
    RET

VCmd_EB:
    MOV A,#$01                                ; vcmd EB: pitch envelope (release);
    BRA +
VCmd_EC:
    MOV A,#$00                                ; vcmd EC: pitch envelope (attack);
  + MOV.B X,CurrentChannel2
    MOV.W ARam_0320+X,A
    CALL NextVCmd46
    MOV.W ARam_0300+1+X,A
    CALL NextVCmd
    MOV.W ARam_0300+X,A
    CALL NextVCmd
    MOV.W ARam_0320+1+X,A
    RET
    MOV.B X,CurrentChannel2
    MOV.W ARam_0300+X,A
    RET

VCmd_E7:
    CALL NextVCmd46                           ; vcmd E7: set voice volume base;
    MOV.W ARam_0240+1+X,A
    MOV A,#$00
    MOV.W ARam_0240+X,A
    OR.B (ARam_5C),(CurrentChannel)           ; mark volume changed
    RET

VCmd_E8:
    CALL NextVCmd46                           ; vcmd E8: voice volume base fade;
    MOV.B VoPanFade+X,A
    PUSH A
    CALL NextVCmd
    MOV.W ARam_0260+X,A
    SETC
    SBC.W A,ARam_0240+1+X
    POP X
    CALL APU_0F76
    MOV.W ARam_0250+X,A
    MOV A,Y
    MOV.W ARam_0250+1+X,A
    RET

VCmd_EE:
    CALL NextVCmd46                           ; vcmd EE: tuning;
    MOV.W ARam_02D0+1+X,A
    RET

VCmd_E9:
    CALL NextVCmd46                           ; vcmd E9: call subroutine;
    PUSH A
    CALL NextVCmd
    PUSH A
    CALL NextVCmd
    MOV.B VoInstrument+X,A                    ; repeat counter = op3
    MOV.B A,VoPhrasePtr+X
    MOV.W ARam_03E0+X,A
    MOV.B A,VoPhrasePtr+1+X
    MOV.W ARam_03E0+1+X,A                     ; save current vptr in 3E0/1+X
    POP A
    MOV.B VoPhrasePtr+1+X,A
    MOV.W ARam_03F0+1+X,A
    POP A
    MOV.B VoPhrasePtr+X,A
    MOV.W ARam_03F0+X,A                       ; set vptr/3F0/1+X to op1/2
    RET

VCmd_EF:
    CALL NextVCmd46                           ; vcmd EF: set echo vbits/volume;
    MOV.W ARam_0389,A                         ; set echo vbit shadow from op1
    MOV Y,#DSP_EON
    CALL WriteDSPReg                          ; set echo vbits DSP from shadow;
    CALL NextVCmd
    MOV A,#$00
    MOVW.B EchoVolLeft,YA                     ; set 61/2 from op2 * $100 (evol L)
    CALL NextVCmd
    MOV A,#$00
    MOVW.B EchoVolRight,YA                    ; set 63/4 from op3 * $100 (evol R)
    MOV.B ARam_2E,A                           ; zero 2e
    AND A,#$1F
    MOV Y,#DSP_FLG
    CALL WriteDSPReg                          ; zero noise freq, enable echo write;

WriteDSPEchoVol:
    MOV.B A,EchoVolLeft+1                     ; set echo vol's from shadows
    MOV Y,#DSP_EVOLL
    CALL WriteDSPReg                          ; set echo vol L DSP from $62;
    MOV.B A,EchoVolRight+1
    MOV Y,#DSP_EVOLR
    JMP WriteDSPReg                           ; set echo vol R DSP from $64;

VCmd_F2:
    CALL NextVCmd46                           ; vcmd F2: echo volume fade;
    MOV.B ARam_60,A
    CALL NextVCmd
    MOV.B ARam_69,A
    MOV.B X,ARam_60
    SETC
    SBC.B A,EchoVolLeft+1
    CALL APU_0F76
    MOVW.B ARam_65,YA
    CALL NextVCmd
    MOV.B ARam_6A,A
    MOV.B X,ARam_60
    SETC
    SBC.B A,EchoVolRight+1
    CALL APU_0F76
    MOVW.B ARam_67,YA
    RET

VCmd_F0:
    MOV.B X,CurrentChannel2                   ; vcmd F0: disable echo
    MOV.W ARam_0389,A                         ; clear all echo vbits
APU_0F22:
    MOV Y,A
    MOVW.B EchoVolLeft,YA                     ; zero echo vol L shadow
    MOVW.B EchoVolRight,YA                    ; zero echo vol R shadow
    CALL WriteDSPEchoVol                      ; set echo vol DSP regs from shadows;
    MOV.B ARam_2E,A                           ; zero 2E
    OR A,#$20
    MOV Y,#DSP_FLG
    JMP WriteDSPReg                           ; disable echo write, noise freq 0;

VCmd_F1:
    CALL NextVCmd46                           ; vcmd F1: set echo delay, feedback, filter;
    MOV Y,#DSP_EDL
    CALL WriteDSPReg                          ; set echo delay from op1;
    CALL NextVCmd
    MOV Y,#DSP_EFB
    CALL WriteDSPReg                          ; set echo feedback from op2;
    CALL NextVCmd
    MOV Y,#$08
    MUL YA
    MOV X,A
    MOV Y,#DSP_C0
  - MOV.W A,EchoFilters+X                     ; filter table;
    CALL WriteDSPReg
    INC X
    MOV A,Y
    CLRC
    ADC A,#$10
    MOV Y,A
    BPL -                                     ; set echo filter from table idx op3;
    MOV.B X,CurrentChannel2
    RET

APU_0F5D:
    AND A,#$7F                                ; calculate portamento delta;
    MOV.W ARam_02D0+X,A                       ; final portamento value
    SETC
    SBC.W A,ARam_02B0+1+X                     ; note number
    PUSH A
    MOV.B A,VoPitchSlide+X                    ; portamento steps
    MOV X,A
    POP A
    CALL APU_0F76
    MOV.W ARam_02C0+X,A
    MOV A,Y
    MOV.W ARam_02C0+1+X,A                     ; portamento delta
    RET

APU_0F76:
    BCS APU_0F85                              ; signed 16 bit division;
    EOR A,#$FF
    INC A
    CALL APU_0F85
    MOVW.B ARam_14,YA
    MOVW.B YA,ARam_0E
    SUBW.B YA,ARam_14
    RET

APU_0F85:
    MOV Y,#$00
    DIV YA,X
    PUSH A
    MOV A,#$00
    DIV YA,X
    POP Y
    MOV.B X,CurrentChannel2
    RET

VCmdPtrs:
    dw VCmd_DA                                ; DA - SET INSTRUMENT ; dispatch table for 0d44 (vcmds)
    dw VCmd_DB                                ; db - set pan
    dw VCmd_DC                                ; dc - pan fade
    dw $0000                                  ; dd - undef, but slur
    dw VCmd_DE                                ; de - vibrato on
    dw VCmd_DF                                ; df - vibrato off
    dw VCmd_E0                                ; e0 - master volume
    dw VCmd_E1                                ; e1 - master volume fade
    dw VCmd_E2                                ; e2 - tempo
    dw VCmd_E3                                ; e3 - tempo fade
    dw VCmd_E4                                ; e4 - global transpose
    dw VCmd_E5                                ; e5 - tremolo on
    dw VCmd_E6                                ; e6 - tremolo off
    dw VCmd_E7                                ; e7 - voice volume base
    dw VCmd_E8                                ; e8 - voice volume base fade
    dw VCmd_E9                                ; e9 - call subroutine
    dw VCmd_EA                                ; ea - vibrato fade
    dw VCmd_EB                                ; eb - pitch envelope (release)
    dw VCmd_EC                                ; ec - pitch envelope (attack)
    dw $0000                                  ; ed - (undef)
    dw VCmd_EE                                ; ee - tuning
    dw VCmd_EF                                ; ef - set echo vbits/volume
    dw VCmd_F0                                ; f0 - disable echo
    dw VCmd_F1                                ; f1 - set echo delay, feedback, filter
    dw VCmd_F2                                ; f2 - echo volume fade

VCmdLens:
    db $02,$02,$03,$04,$04,$01,$02,$03        ; vcmd op lens?
    db $02,$03,$02,$04,$01,$02,$03,$04
    db $02,$04,$04,$01,$02,$04,$01,$04
    db $04

APU_0FDB:
    MOV.B A,VoPanFade+X
    BEQ +
    OR.B (ARam_5C),(CurrentChannel)
    MOV A,#$40
    MOV Y,#$02
    DEC.B VoPanFade+X
    CALL APU_1075
  + MOV.B A,ARam_B0+1+X
    MOV Y,A
    BEQ APU_1013
    MOV.W A,ARam_0370+X
    CBNE.B ARam_B0+X,APU_1011
    OR.B (ARam_5C),(CurrentChannel)
    MOV.W A,ARam_0360+X
    BPL +
    INC Y
    BNE +
    MOV A,#$80
    BRA ++
  + CLRC
    ADC.W A,ARam_0360+2+X
 ++ MOV.W ARam_0360+X,A
    CALL APU_123A
    BRA APU_1019

APU_1011:
    INC.B ARam_B0+X
APU_1013:
    MOV.W A,ARam_0210+1+X                     ; volume from note
    CALL APU_124D                             ; set voice vol from master/base/note;
APU_1019:
    MOV.B A,VoPanFade+1+X
    BNE APU_1024
    MOV.B A,CurrentChannel
    AND.B A,ARam_5C
    BNE APU_102D
    RET

APU_1024:
    MOV A,#$80                                ; do: pan fade and set volume;
    MOV Y,#$02
    DEC.B VoPanFade+1+X
    CALL APU_1075
APU_102D:
    MOV.W A,ARam_0280+1+X
    MOV Y,A
    MOV.W A,ARam_0280+X
    MOVW.B ARam_10,YA                         ; set $10/1 from voice pan

APU_1036:
    MOV A,X                                   ; set voice volume DSP regs with pan value from $10/1;
    XCN A
    LSR A
    MOV.B ARam_12,A                           ; $12 = voice X volume DSP reg
APU_103B:
    MOV.B Y,ARam_11
    MOV.W A,PanTable+1+Y                      ; next pan val from table;
    SETC
    SBC.W A,PanTable+Y                        ; pan val;
    MOV.B Y,ARam_10
    MUL YA
    MOV A,Y
    MOV.B Y,ARam_11
    CLRC
    ADC.W A,PanTable+Y                        ; add integer part to pan val;
    MOV Y,A
    MOV.W A,ARam_0370+1+X                     ; volume
    MUL YA
    MOV.W A,ARam_02A0+1+X                     ; bits 7/6 will negate volume L/R
    BBC0.B ARam_12,+
    ASL A
  + BPL APU_1061
    MOV A,Y
    EOR A,#$FF
    INC A
    MOV Y,A
APU_1061:
    MOV A,Y
    MOV.B Y,ARam_12
    CALL WriteDSPRegCond                      ; set DSP vol if vbit 1D clear;
    MOV A,#$00
    MOV Y,#$14
    SUBW.B YA,ARam_10
    MOVW.B ARam_10,YA                         ; $10/11 = #$1400 - $10/11
    INC.B ARam_12                             ; go back and do R chan vol
    BBC1.B ARam_12,APU_103B
    RET

APU_1075:
    MOVW.B ARam_14,YA                         ; add fade delta to value (set final value at end)
    BNE APU_1088
    CLRC
    ADC A,#$20
    MOVW.B PitchValue,YA
    MOV A,X
    MOV Y,A
    MOV A,#$00
    PUSH A
    MOV.B A,(PitchValue)+Y
    INC Y
    BRA APU_109A

APU_1088:
    CLRC
    ADC A,#$10
    MOVW.B PitchValue,YA
    MOV A,X
    MOV Y,A
    MOV.B A,(ARam_14)+Y
    CLRC
    ADC.B A,(PitchValue)+Y
    PUSH A
    INC Y
    MOV.B A,(ARam_14)+Y
    ADC.B A,(PitchValue)+Y
APU_109A:
    MOV.B (ARam_14)+Y,A
    DEC Y
    POP A
    MOV.B (ARam_14)+Y,A
    RET

APU_10A1:
    SETP                                      ; do: voice readahead;
    DEC.B SPCInEdge+X
    CLRP
    BEQ +
    MOV A,#$02
    CBNE.B VoTimers+X,APU_10D8
  + MOV.B A,VoPhrasePtr+X
    MOV.B Y,VoPhrasePtr+1+X
    MOVW.B ARam_14,YA
    MOV Y,#$00
APU_10B4:
    MOV.B A,(ARam_14)+Y
    BEQ APU_10D1
    BMI APU_10BF
  - INC Y
    MOV.B A,(ARam_14)+Y
    BPL -
APU_10BF:
    CMP A,#$C6
    BEQ APU_10D8                              ; tie?;
    CMP A,#$DA
    BCC APU_10D1
    PUSH Y
    MOV Y,A
    POP A
    CLRC
    ADC.W A,VCmdLens-$DA+Y                    ; (FC2) vcmd op lens;
    MOV Y,A
    BRA APU_10B4

APU_10D1:
    MOV.B A,CurrentChannel
    MOV Y,#DSP_KOF
    CALL WriteDSPRegCond                      ; key off current voice now;
APU_10D8:
    CLR7.B ARam_13
    MOV.B A,VoPitchSlide+X
    BEQ +
    MOV.B A,CurrentChannel
    AND.B A,ChannelsMuted
    BEQ APU_1111
  + MOV.B A,(VoPhrasePtr+X)
    CMP A,#$DD
    BNE APU_112A
    MOV.B A,CurrentChannel
    AND.B A,ChannelsMuted
    BEQ +
    MOV.B ARam_10,#$04
  - CALL APU_1260
    DBNZ.B ARam_10,-
    BRA APU_1111
  + CALL APU_1260
    CALL NextVCmd
    MOV.B VoPitchSlide+1+X,A
    CALL NextVCmd
    MOV.B VoPitchSlide+X,A
    CALL NextVCmd
    CLRC
    ADC.B A,MasterTranspose
    CALL APU_0F5D
APU_1111:
    MOV.B A,VoPitchSlide+1+X
    BEQ +
    DEC.B VoPitchSlide+1+X
    BRA APU_112A

  + MOV.B A,ChannelsMuted
    AND.B A,CurrentChannel
    BNE APU_112A
APU_111F:
    SET7.B ARam_13
    MOV A,#$B0
    MOV Y,#$02
    DEC.B VoPitchSlide+X
    CALL APU_1075
APU_112A:
    MOV.W A,ARam_02B0+1+X
    MOV Y,A
    MOV.W A,ARam_02B0+X
    MOVW.B ARam_10,YA                         ; note num -> $10/11
    MOV.B A,VoVibrato+1+X
    BEQ APU_1140
    MOV.W A,ARam_0340+X
    CMP.B A,VoVibrato+X
    BEQ APU_1144
    INC.B VoVibrato+X
APU_1140:
    BBS7.B ARam_13,APU_1195
    RET
APU_1144:
    MOV.W A,ARam_0340+1+X
    BEQ APU_1166
    CMP.W A,ARam_0110+X
    BNE +
    MOV.W A,ARam_0350+1+X
    MOV.B VoVibrato+1+X,A
    BRA APU_1166
  + MOV.W A,ARam_0110+X
    BEQ +
    MOV.B A,VoVibrato+1+X
  + CLRC
    ADC.W A,ARam_0350+X
    MOV.B VoVibrato+1+X,A
    SETP
    INC.B ARam_10+X
    CLRP
APU_1166:
    MOV.W A,ARam_0330+X
    CLRC
    ADC.W A,ARam_0330+1+X
    MOV.W ARam_0330+X,A
APU_1170:
    MOV.B ARam_12,A
    ASL A
    ASL A
    BCC +
    EOR A,#$FF
  + MOV Y,A
    MOV.B A,VoVibrato+1+X
    CMP A,#$F1
    BCS APU_1185
    MUL YA
    MOV A,Y
    MOV Y,#$00
    BRA APU_1188
APU_1185:
    AND A,#$0F
    MUL YA
APU_1188:
    BBC7.B ARam_12,+
    MOVW.B ARam_12,YA
    MOVW.B YA,ARam_0E
    SUBW.B YA,ARam_12
  + ADDW.B YA,ARam_10
    MOVW.B ARam_10,YA
APU_1195:
    JMP APU_0634

APU_1198:
    CLR7.B ARam_13                            ; per-voice fades/dsps?
    MOV.B A,ARam_B0+1+X
    BEQ +
    MOV.W A,ARam_0370+X
    CBNE.B ARam_B0+X,+
    CALL APU_122D                             ; voice vol calculations;
  + MOV.W A,ARam_0280+1+X
    MOV Y,A
    MOV.W A,ARam_0280+X
    MOVW.B ARam_10,YA                         ; $10/11 = voice pan value
    MOV.B A,VoPanFade+1+X                     ; voice pan fade counter
    BNE +
    BBS7.B ARam_13,APU_11C3
    BRA APU_11C6

  + MOV.W A,ARam_0290+1+X
    MOV Y,A
    MOV.W A,ARam_0290+X                       ; pan fade delta
    CALL APU_1201                             ; add delta (with mutations)?;
APU_11C3:
    CALL APU_1036                             ; set voice DSP regs, pan from $10/11;
APU_11C6:
    CLR7.B ARam_13
    MOV.W A,ARam_02B0+1+X
    MOV Y,A
    MOV.W A,ARam_02B0+X
    MOVW.B ARam_10,YA                         ; notenum to $10/11
    MOV.B A,VoPitchSlide+X                    ; pitch slide counter
    BEQ +
    MOV.B A,VoPitchSlide+1+X
    BNE +
    MOV.W A,ARam_02C0+1+X
    MOV Y,A
    MOV.W A,ARam_02C0+X
    CALL APU_11FF                             ; add pitch slide delta;
  + MOV.B A,VoVibrato+1+X
    BNE +
  - BBS7.B ARam_13,APU_1195
    RET

  + MOV.W A,ARam_0340+X
    CBNE.B VoVibrato+X,-
    MOV.B Y,ARam_49
    MOV.W A,ARam_0330+1+X
    MUL YA
    MOV A,Y
    CLRC
    ADC.W A,ARam_0330+X
    JMP APU_1170

APU_11FF:
    SET7.B ARam_13
APU_1201:
    MOVW.B PitchValue,YA
    MOV.B ARam_12,Y
    BBC7.B ARam_12,+
    MOVW.B YA,ARam_0E
    SUBW.B YA,PitchValue
    MOVW.B PitchValue,YA
  + MOV.B Y,ARam_49
    MOV.B A,PitchValue
    MUL YA
    MOV.B ARam_14,Y
    MOV.B ARam_15,#$00
    MOV.B Y,ARam_49
    MOV.B A,PitchValue+1
    MUL YA
    ADDW.B YA,ARam_14
    BBC7.B ARam_12,+
    MOVW.B ARam_14,YA
    MOVW.B YA,ARam_0E
    SUBW.B YA,ARam_14
  + ADDW.B YA,ARam_10
    MOVW.B ARam_10,YA
    RET

APU_122D:
    SET7.B ARam_13
    MOV.B Y,ARam_49                           ; tempo counter (i.e. fractional part of tick counter)
    MOV.W A,ARam_0360+2+X                     ; tremolo rate
    MUL YA
    MOV A,Y
    CLRC
    ADC.W A,ARam_0360+X
APU_123A:
    ASL A
    BCC +
    EOR A,#$FF
  + MOV.B Y,ARam_B0+1+X                       ; tremolo depth
    MUL YA
    MOV.W A,ARam_0210+1+X                     ; per-note volume (velocity)
    MUL YA
    MOV A,Y
    EOR A,#$FF
    SETC
    ADC.W A,ARam_0210+1+X
APU_124D:
    MOV Y,A
    MOV.W A,ARam_0240+1+X                     ; CHANNEL VOLUME ; set voice volume from master/base/A
    MUL YA
    MOV.B A,MasterVolume                      ; master volume
    MUL YA
    MOV A,Y
    MUL YA
    MOV A,Y                                   ; (^2 exponential);
    MOV.W ARam_0370+1+X,A                     ; voice volume
    RET

NextVCmd46:
    MOV.B X,CurrentChannel2                   ; get next vcmd stream byte for voice $46 Channel2
NextVCmd:
    MOV.B A,(VoPhrasePtr+X)                   ; get next vcmd stream byte into A/Y
APU_1260:
    INC.B VoPhrasePtr+X
    BNE +
    INC.B VoPhrasePtr+1+X
  + MOV Y,A
    RET

NoteDurs:
    db $33,$66,$80,$99,$B3,$CC,$E6,$FF        ; for 0C89 - note dur%'s

VelocityValues:
    db $08,$12,$1B,$24,$2C,$35,$3E,$47        ; per-note velocity values
    db $51,$5A,$62,$6B,$7D,$8F,$A1,$B3

PanTable:
    db $00,$01,$03,$07,$0D,$15,$1E,$29        ; pan table (max pan full L = $14.00)
    db $34,$42,$51,$5E,$67,$6E,$73,$77
    db $7A,$7C,$7D,$7E,$7F

DefaultDSPVals:
    db $7F,$7F,$00,$00,$2F,$60,$00,$00        ; default values (1295) for DSP regs (12A1)
    db $00,$80,$60,$02

DefaultDSPRegs:
    db $0C,$1C,$2C,$3C,$6C,$0D,$2D,$3D        ; mvol L/R max, echo vol L/R zero, FLG = echo off/noise 400HZ
    db $4D,$5D,$6D,$7D                        ; echo feedback = $60, echo/pitchmod/noise vbits off
                                              ; source dir = $8000, echo ram = $6000, echo delay = 32ms
EchoFilters:
    db $FF,$08,$17,$24,$24,$17,$08,$FF        ; echo filters 0 and 1
    db $7F,$00,$00,$00,$00,$00,$00,$00

GetPitch:
    MOV Y,#$00                                ; get pitch from note number in A (with octave correction) to YA;to YA
    ASL A
    MOV X,#$18
    DIV YA,X
    MOV X,A
    MOV.W A,PitchTable+1+Y
    MOV.B PitchValue,A
    MOV.W A,PitchTable+Y
    BRA +
  - LSR.B PitchValue
    ROR A
    INC X
  + CMP X,#$06
    BNE -
    MOV.B Y,PitchValue
    RET

PitchTable:
    dw $10BE                                  ; pitch table
    dw $11BD
    dw $12CB
    dw $13E9
    dw $1518
    dw $1659
    dw $17AD
    dw $1916
    dw $1A94
    dw $1C28
    dw $1DD5
    dw $1F9B
    db $00

StandardTransfer:
    MOV A,#$AA                                ; do: standardish SPU transfer;
    MOV.W HW_SNESIO0,A
    MOV A,#$BB
    MOV.W HW_SNESIO1,A
  - MOV.W A,HW_SNESIO0
    CMP A,#$CC
    BNE -
    BRA APU_1325

APU_1305:
    MOV.W Y,HW_SNESIO0
    BNE APU_1305
APU_130A:
    CMP.W Y,HW_SNESIO0
    BNE APU_131E
    MOV.W A,HW_SNESIO1
    MOV.W HW_SNESIO0,Y
    MOV.B (ARam_14)+Y,A
    INC Y
    BNE APU_130A
    INC.B ARam_15
    BRA APU_130A
APU_131E:
    BPL APU_130A
    CMP.W Y,HW_SNESIO0
    BPL APU_130A
APU_1325:
    MOV.W A,HW_SNESIO2
    MOV.W Y,HW_SNESIO3
    MOVW.B ARam_14,YA
    MOV.W Y,HW_SNESIO0
    MOV.W A,HW_SNESIO1
    MOV.W HW_SNESIO0,Y
    BNE APU_1305
    MOV X,#$31
    MOV.W HW_SPCCONTROL,X                     ; reset ports, keep timer running
    RET


    base off
    arch 65816

SoundEffects:
    dw MusicBank1-SoundEffects-4
    dw SoundEffectTable

    base SoundEffectTable

SFXDSPSettings:
    db $70,$70 : dw $1000
    db $06,$DF,$E0,$B8,$02
    db $70,$70 : dw $1000
    db $00,$FE,$0A,$B8,$03
    db $70,$70 : dw $1000
    db $03,$FE,$11,$B8,$03
    db $70,$70 : dw $1000
    db $04,$FE,$6A,$B8,$03
    db $70,$70 : dw $1000
    db $00,$FE,$11,$B8,$03
    db $70,$70 : dw $1000
    db $08,$FE,$6A,$B8,$03
    db $70,$70 : dw $1000
    db $02,$FE,$6A,$B8,$06
    db $70,$70 : dw $1000
    db $06,$FE,$6A,$B8,$05
    db $70,$70 : dw $1000
    db $00,$CA,$D7,$B8,$03
    db $70,$70 : dw $1000
    db $10,$0E,$6A,$7F,$04
    db $70,$70 : dw $1000
    db $0B,$FE,$6A,$B8,$02
    db $70,$70 : dw $1000
    db $0B,$FF,$E0,$B8,$05
    db $70,$70 : dw $1000
    db $0E,$FE,$00,$7F,$06
    db $70,$70 : dw $1000
    db $00,$B6,$30,$30,$06
    db $70,$70 : dw $1000
    db $12,$0E,$6A,$70,$03
    db $70,$70 : dw $1000
    db $01,$FA,$6A,$70,$03
    db $70,$70 : dw $1000
    db $02,$FE,$16,$70,$03
    db $70,$70 : dw $1000
    db $13,$0E,$16,$7F,$03
    db $70,$70 : dw $1000
    db $02,$FE,$33,$7F,$03

SFXPtrs1DFC:
    dw SFX_1DFC_01
    dw SFX_1DFC_02
    dw SFX_1DFC_03
    dw SFX_1DFC_04
    dw SFX_1DFC_05
    dw SFX_1DFC_06
    dw SFX_1DFC_07
    dw SFX_1DFC_08
    dw SFX_1DFC_09
    dw SFX_1DFC_0A
    dw SFX_1DFC_0B
    dw SFX_1DFC_0C
    dw SFX_1DFC_0C
    dw SFX_1DFC_0E
    dw SFX_1DFC_0F
    dw SFX_1DFC_09
    dw SFX_1DFC_11
    dw SFX_1DFC_12
    dw SFX_1DFC_13
    dw SFX_1DFC_14
    dw SFX_1DFC_15
    dw SFX_1DFC_16
    dw SFX_1DFC_17
    dw SFX_1DFC_18
    dw SFX_1DFC_19
    dw SFX_1DFC_1A
    dw SFX_1DFC_1B
    dw SFX_1DFC_1C
    dw SFX_1DFC_1D
    dw SFX_1DFC_1E
    dw SFX_1DFC_1F
    dw SFX_1DFC_20
    dw SFX_1DFC_21
    dw SFX_1DFC_22
    dw SFX_1DFC_23
    dw SFX_1DFC_24
    dw SFX_1DFC_25
    dw SFX_1DFC_26
    dw SFX_1DFC_27
    dw SFX_1DFC_28
    dw SFX_1DFC_29
    dw SFX_1DFC_2A
    dw SFX_1DFC_2B
    dw SFX_1DFC_2C
    dw SFX_1DFC_2D
    dw SFX_1DFC_2E
    dw SFX_1DFC_2F
    dw SFX_1DFC_30
    dw SFX_1DFC_31
    dw SFX_1DFC_32
    dw SFX_1DFC_33
    dw SFX_1DFC_34

SFXPtrs1DF9:
    dw SFX_1DF9_01
    dw SFX_1DF9_02
    dw SFX_1DF9_03
    dw SFX_1DF9_04
    dw SFX_1DF9_05
    dw SFX_1DF9_06
    dw SFX_1DF9_07
    dw SFX_1DF9_08
    dw SFX_1DF9_09
    dw SFX_1DF9_0A
    dw SFX_1DF9_0B
    dw SFX_1DF9_0C
    dw SFX_1DF9_0D
    dw SFX_1DF9_0E
    dw SFX_1DF9_0F
    dw SFX_1DF9_10
    dw SFX_1DF9_11
    dw SFX_1DF9_11
    dw SFX_1DF9_13
    dw SFX_1DF9_14
    dw SFX_1DF9_15
    dw SFX_1DF9_16
    dw SFX_1DF9_17
    dw SFX_1DF9_18
    dw SFX_1DF9_19
    dw SFX_1DF9_1A
    dw SFX_1DF9_1B
    dw SFX_1DF9_1C
    dw SFX_1DF9_1D
    dw SFX_1DF9_1E
    dw SFX_1DF9_1F
    dw SFX_1DF9_20
    dw SFX_1DF9_21
    dw SFX_1DF9_22
    dw SFX_1DF9_23
    dw SFX_1DF9_22
    dw SFX_1DF9_25
    dw SFX_1DF9_26
    dw SFX_1DF9_27
    dw SFX_1DF9_28
    dw SFX_1DF9_29
    dw SFX_1DF9_2A

SFX_1DF9_2A:
    incbin "sfx/SFX_1DF9_2A.bin"
SFX_1DFC_2D:
    incbin "sfx/SFX_1DFC_2D.bin"
SFX_1DFC_2E:
    incbin "sfx/SFX_1DFC_2E.bin"
SFX_1DFC_2F:
    incbin "sfx/SFX_1DFC_2F.bin"
SFX_1DFC_30:
    incbin "sfx/SFX_1DFC_30.bin"
SFX_1DFC_31:
    incbin "sfx/SFX_1DFC_31.bin"
SFX_1DFC_32:
    incbin "sfx/SFX_1DFC_32.bin"
SFX_1DFC_33:
    incbin "sfx/SFX_1DFC_33.bin"
SFX_1DFC_34:
    incbin "sfx/SFX_1DFC_34.bin"
SFX_1DF9_29:
    incbin "sfx/SFX_1DF9_29.bin"
SFX_1DF9_28:
    incbin "sfx/SFX_1DF9_28.bin"
SFX_1DFC_2C:
    incbin "sfx/SFX_1DFC_2C.bin"
SFX_1DFC_2B:
    incbin "sfx/SFX_1DFC_2B.bin"
SFX_1DF9_27:
    incbin "sfx/SFX_1DF9_27.bin"
SFX_1DF9_26:
    incbin "sfx/SFX_1DF9_26.bin"
SFX_1DFC_2A:
    incbin "sfx/SFX_1DFC_2A.bin"
SFX_1DFC_29:
    incbin "sfx/SFX_1DFC_29.bin"
SFX_1DF9_23:
    incbin "sfx/SFX_1DF9_23.bin"
SFX_1DFC_28:
    incbin "sfx/SFX_1DFC_28.bin"
SFX_1DF9_25:
    incbin "sfx/SFX_1DF9_25.bin"
SFX_1DFC_27:
    incbin "sfx/SFX_1DFC_27.bin"
SFX_1DFC_26:
    incbin "sfx/SFX_1DFC_26.bin"
SFX_1DFC_25:
    incbin "sfx/SFX_1DFC_25.bin"
SFX_1DFC_24:
    incbin "sfx/SFX_1DFC_24.bin"
SFX_1DFC_22:
    incbin "sfx/SFX_1DFC_22.bin"
SFX_1DFC_23:
    incbin "sfx/SFX_1DFC_23.bin"
SFX_1DFC_1F:
    incbin "sfx/SFX_1DFC_1F.bin"
SFX_1DFC_1E:
    incbin "sfx/SFX_1DFC_1E.bin"
SFX_1DFC_1C:
    incbin "sfx/SFX_1DFC_1C.bin"
SFX_1DF9_21:
    incbin "sfx/SFX_1DF9_21.bin"
SFX_1DFC_1B:
    incbin "sfx/SFX_1DFC_1B.bin"
SFX_1DFC_1A:
    incbin "sfx/SFX_1DFC_1A.bin"
SFX_1DFC_20:
    incbin "sfx/SFX_1DFC_20.bin"
SFX_1DFC_19:
    incbin "sfx/SFX_1DFC_19.bin"
SFX_1DFC_18:
    incbin "sfx/SFX_1DFC_18.bin"
SFX_1DFC_17:
    incbin "sfx/SFX_1DFC_17.bin"
SFX_1DFC_16:
    incbin "sfx/SFX_1DFC_16.bin"
SFX_1DFC_15:
    incbin "sfx/SFX_1DFC_15.bin"
SFX_1DF9_20:
    incbin "sfx/SFX_1DF9_20.bin"
SFX_1DF9_1F:
    incbin "sfx/SFX_1DF9_1F.bin"
SFX_1DF9_1E:
    incbin "sfx/SFX_1DF9_1E.bin"
SFX_1DF9_1A:
    incbin "sfx/SFX_1DF9_1A.bin"
SFX_1DF9_1B:
    incbin "sfx/SFX_1DF9_1B.bin"
SFX_1DF9_08:
    incbin "sfx/SFX_1DF9_08.bin"
SFX_1DFC_08:
    incbin "sfx/SFX_1DFC_08.bin"
SFX_1DF9_22:
    incbin "sfx/SFX_1DF9_22.bin"
SFX_1DF9_11:
    incbin "sfx/SFX_1DF9_11.bin"
SFX_1DFC_0E:
    incbin "sfx/SFX_1DFC_0E.bin"
SFX_1DF9_09:
    incbin "sfx/SFX_1DF9_09.bin"
SFX_1DF9_0E:
    incbin "sfx/SFX_1DF9_0E.bin"
SFX_1DFC_0B:
    incbin "sfx/SFX_1DFC_0B.bin"
SFX_1DFC_0A:
    incbin "sfx/SFX_1DFC_0A.bin"
SFX_1DF9_06:
    incbin "sfx/SFX_1DF9_06.bin"
SFX_1DFC_13:
    incbin "sfx/SFX_1DFC_13.bin"
SFX_1DF9_1C:
    incbin "sfx/SFX_1DF9_1C.bin"
SFX_1DF9_1D:
    incbin "sfx/SFX_1DF9_1D.bin"
SFX_1DFC_1D:
    incbin "sfx/SFX_1DFC_1D.bin"
SFX_1DF9_05:
    incbin "sfx/SFX_1DF9_05.bin"
SFX_1DF9_04:
    incbin "sfx/SFX_1DF9_04.bin"
SFX_1DF9_0B:
    incbin "sfx/SFX_1DF9_0B.bin"
SFX_1DFC_06:
    incbin "sfx/SFX_1DFC_06.bin"
SFX_1DF9_03:
    incbin "sfx/SFX_1DF9_03.bin"
SFX_1DF9_13:
    incbin "sfx/SFX_1DF9_13.bin"
SFX_1DF9_14:
    incbin "sfx/SFX_1DF9_14.bin"
SFX_1DF9_15:
    incbin "sfx/SFX_1DF9_15.bin"
SFX_1DF9_16:
    incbin "sfx/SFX_1DF9_16.bin"
SFX_1DF9_17:
    incbin "sfx/SFX_1DF9_17.bin"
SFX_1DF9_18:
    incbin "sfx/SFX_1DF9_18.bin"
SFX_1DF9_19:
    incbin "sfx/SFX_1DF9_19.bin"
SFX_1DF9_02:
    incbin "sfx/SFX_1DF9_02.bin"
SFX_1DFC_21:
    incbin "sfx/SFX_1DFC_21.bin"
SFX_1DF9_01:
    incbin "sfx/SFX_1DF9_01.bin"
SFX_1DFC_03:
    incbin "sfx/SFX_1DFC_03.bin"
SFX_1DFC_02:
    incbin "sfx/SFX_1DFC_02.bin"
SFX_1DFC_0C:
    incbin "sfx/SFX_1DFC_0C.bin"
SFX_1DF9_07:
    incbin "sfx/SFX_1DF9_07.bin"
SFX_1DF9_0D:
    incbin "sfx/SFX_1DF9_0D.bin"
SFX_1DFC_14:
    incbin "sfx/SFX_1DFC_14.bin"
SFX_1DF9_0A:
    incbin "sfx/SFX_1DF9_0A.bin"
SFX_1DFC_05:
    incbin "sfx/SFX_1DFC_05.bin"
SFX_1DF9_10:
    incbin "sfx/SFX_1DF9_10.bin"
SFX_1DF9_0C:
    incbin "sfx/SFX_1DF9_0C.bin"
SFX_1DF9_0F:
    incbin "sfx/SFX_1DF9_0F.bin"
SFX_1DFC_04:
    incbin "sfx/SFX_1DFC_04.bin"
SFX_1DFC_01:
    incbin "sfx/SFX_1DFC_01.bin"
SFX_1DFC_07:
    incbin "sfx/SFX_1DFC_07.bin"
SFX_1DFC_0F:
    incbin "sfx/SFX_1DFC_0F.bin"
SFX_1DFC_09:
    incbin "sfx/SFX_1DFC_09.bin"
SFX_1DFC_11:
    incbin "sfx/SFX_1DFC_11.bin"
SFX_1DFC_12:
    incbin "sfx/SFX_1DFC_12.bin"


    base off

MusicBank1:
    dw MusicBank1_End-MusicBank1-4
    dw MusicData

    base MusicData

    dw MusicB1S01
    dw MusicB1S02
    dw MusicB1S03
    dw MusicB1S04
    dw MusicB1S05
    dw MusicB1S06
    dw MusicB1S07
    dw MusicB1S08
    dw MusicB1S09


MusicB1S06:
    dw MusicB1S06L00
    dw MusicB1S06L01
    dw MusicB1S06L01
    dw MusicB1S06L02
    dw $00FF,MusicB1S06+2
    dw $0000

MusicB1S06L00:
    dw MusicB1S06P00
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB1S06L01:
    dw MusicB1S06P01
    dw MusicB1S06P02
    dw MusicB1S06P03
    dw MusicB1S06P04
    dw $0000
    dw $0000
    dw $0000
    dw MusicB1S06P05

MusicB1S06L02:
    dw MusicB1S06P06
    dw MusicB1S06P07
    dw MusicB1S06P08
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB1S05:
    dw MusicB1S05L00
    dw MusicB1S05L00
    dw MusicB1S05L01
    dw $00FF,MusicB1S05
    dw $0000

MusicB1S05L00:
    dw MusicB1S05P00
    dw MusicB1S05P01
    dw MusicB1S05P02
    dw MusicB1S05P03
    dw MusicB1S05P04
    dw MusicB1S05P05
    dw $0000
    dw $0000

MusicB1S05L01:
    dw MusicB1S05P06
    dw MusicB1S05P07
    dw MusicB1S05P08
    dw MusicB1S05P09
    dw MusicB1S05P0A
    dw MusicB1S05P0B
    dw $0000
    dw $0000

MusicB1S07:
    dw MusicB1S07L00
    dw MusicB1S07L01
    dw MusicB1S07L02
    dw $00FF,MusicB1S07+2
    dw $0000

MusicB1S07L00:
    dw MusicB1S07P00
    dw MusicB1S07P01
    dw MusicB1S07P02
    dw MusicB1S07P03
    dw MusicB1S07P04
    dw MusicB1S07P05
    dw $0000
    dw $0000

MusicB1S07L01:
    dw MusicB1S07P06
    dw MusicB1S07P01
    dw MusicB1S07P07
    dw MusicB1S07P03
    dw MusicB1S07P08
    dw MusicB1S07P05
    dw $0000
    dw $0000

MusicB1S07L02:
    dw MusicB1S07P09
    dw MusicB1S07P01
    dw MusicB1S07P0A
    dw MusicB1S07P03
    dw MusicB1S07P0B
    dw MusicB1S07P05
    dw $0000
    dw $0000

MusicB1S02:
    dw MusicB1S02L00
    dw MusicB1S02L01
    dw $00FF,MusicB1S02
    dw $0000

MusicB1S02L01:
    dw MusicB1S02P05
    dw MusicB1S02P06
    dw MusicB1S02P07
    dw MusicB1S02P08
    dw $0000
    dw $0000
    dw $0000
    dw MusicB1S02P04

MusicB1S02L00:
    dw MusicB1S02P00
    dw MusicB1S02P01
    dw MusicB1S02P02
    dw MusicB1S02P03
    dw $0000
    dw $0000
    dw $0000
    dw MusicB1S02P04

MusicB1S03:
    dw MusicB1S03L00
    dw MusicB1S03L01
    dw $00FF,MusicB1S03
    dw $0000

MusicB1S03L00:
    dw MusicB1S03P00
    dw MusicB1S03P01
    dw MusicB1S03P02
    dw MusicB1S03P03
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB1S03L01:
    dw MusicB1S03P04
    dw MusicB1S03P05
    dw MusicB1S03P06
    dw MusicB1S03P07
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB1S04:
    dw MusicB1S04L00
    dw MusicB1S04L01
    dw MusicB1S04L01
    dw MusicB1S04L02
    dw $00FF,MusicB1S04+2
    dw $0000

MusicB1S04L00:
    dw $0000
    dw $0000
    dw MusicB1S04P00
    dw MusicB1S04P01
    dw MusicB1S04P02
    dw $0000
    dw $0000
    dw MusicB1S04P03

MusicB1S04L01:
    dw MusicB1S04P04
    dw MusicB1S04P05
    dw MusicB1S04P00
    dw MusicB1S04P01
    dw MusicB1S04P02
    dw MusicB1S04P06
    dw MusicB1S04P07
    dw MusicB1S04P03

MusicB1S04L02:
    dw MusicB1S04P08
    dw MusicB1S04P09
    dw MusicB1S04P0A
    dw MusicB1S04P01
    dw MusicB1S04P0B
    dw MusicB1S04P0C
    dw MusicB1S04P0D
    dw MusicB1S04P0E

MusicB1S01:
    dw MusicB1S01L00
    dw MusicB1S01L01
    dw MusicB1S01L02
    dw MusicB1S01L03
    dw MusicB1S01L04
    dw MusicB1S01L05
    dw MusicB1S01L05
    dw MusicB1S01L06
    dw $00FF,MusicB1S01+2
    dw $0000

MusicB1S01L00:
    dw MusicB1S01P00
    dw MusicB1S01P01
    dw $0000
    dw MusicB1S01P02
    dw MusicB1S01P03
    dw $0000
    dw $0000
    dw $0000

MusicB1S01L01:
    dw MusicB1S01P04
    dw MusicB1S01P05
    dw MusicB1S01P06
    dw MusicB1S01P07
    dw MusicB1S01P08
    dw $0000
    dw $0000
    dw $0000

MusicB1S01L02:
    dw MusicB1S01P09
    dw MusicB1S01P0A
    dw MusicB1S01P0B
    dw MusicB1S01P0C
    dw MusicB1S01P0D
    dw $0000
    dw MusicB1S01P0E
    dw $0000

MusicB1S01L03:
    dw MusicB1S01P0F
    dw MusicB1S01P10
    dw MusicB1S01P11
    dw MusicB1S01P12
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB1S01L04:
    dw MusicB1S01P13
    dw MusicB1S01P14
    dw MusicB1S01P15
    dw MusicB1S01P16
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB1S01L05:
    dw MusicB1S01P17
    dw MusicB1S01P18
    dw MusicB1S01P19
    dw MusicB1S01P1A
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB1S01L06:
    dw MusicB1S01P1B
    dw MusicB1S01P1C
    dw MusicB1S01P1D
    dw MusicB1S01P1E
    dw MusicB1S01P1F
    dw $0000
    dw $0000
    dw $0000

MusicB1S08:
    dw MusicB1S08L00
    dw $0000

MusicB1S08L00:
    dw MusicB1S08P00
    dw MusicB1S08P01
    dw MusicB1S08P02
    dw MusicB1S08P03
    dw $0000
    dw MusicB1S08P04
    dw $0000
    dw MusicB1S08P05

MusicB1S09:
    dw MusicB1S09L00
    dw MusicB1S09L01
    dw MusicB1S09L02
    dw MusicB1S09L00
    dw MusicB1S09L01
    dw MusicB1S09L02
    dw MusicB1S09L00
    dw MusicB1S09L01
    dw MusicB1S09L02
    dw MusicB1S09L00
    dw MusicB1S09L01
    dw MusicB1S09L02
    dw MusicB1S09L00
    dw MusicB1S09L01
    dw MusicB1S09L02
    dw MusicB1S09L00
    dw MusicB1S09L01
    dw MusicB1S09L02
    dw MusicB1S09L00
    dw MusicB1S09L01
    dw MusicB1S09L02
    dw MusicB1S09L00
    dw MusicB1S09L01
    dw MusicB1S09L02
    dw MusicB1S09L00
    dw MusicB1S09L03
    dw MusicB1S09L04
    dw MusicB1S09L04
    dw MusicB1S09L05
    dw MusicB1S09L06
    dw MusicB1S09L05
    dw MusicB1S09L07
    dw MusicB1S09L05
    dw MusicB1S09L06
    dw MusicB1S09L05
    dw MusicB1S09L07
    dw MusicB1S09L08
    dw MusicB1S09L09
    dw MusicB1S09L08
    dw MusicB1S09L0A
    dw MusicB1S09L04
    dw MusicB1S09L04
    dw MusicB1S09L0B
    dw MusicB1S09L0C
    dw MusicB1S09L0B
    dw MusicB1S09L0D
    dw MusicB1S09L0B
    dw MusicB1S09L0C
    dw MusicB1S09L0B
    dw MusicB1S09L0D
    dw MusicB1S09L08
    dw MusicB1S09L09
    dw MusicB1S09L08
    dw MusicB1S09L0A
    dw MusicB1S09L0B
    dw MusicB1S09L0C
    dw MusicB1S09L0B
    dw MusicB1S09L0D
    dw $00FF,MusicB1S09+$34
    dw $0000

MusicB1S09L00:
    dw MusicB1S09P00
    dw MusicB1S09P01
    dw MusicB1S09P02
    dw MusicB1S09P03
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw MusicB1S09P06
    dw MusicB1S09P07

MusicB1S09L01:
    dw MusicB1S09P00
    dw MusicB1S09P08
    dw MusicB1S09P09
    dw MusicB1S09P0A
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw MusicB1S09P06
    dw MusicB1S09P07

MusicB1S09L02:
    dw MusicB1S09P0B
    dw MusicB1S09P0C
    dw MusicB1S09P0D
    dw MusicB1S09P0E
    dw MusicB1S09P0F
    dw MusicB1S09P10
    dw MusicB1S09P11
    dw MusicB1S09P12

MusicB1S09L03:
    dw MusicB1S09P13
    dw MusicB1S09P14
    dw MusicB1S09P15
    dw MusicB1S09P16
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw MusicB1S09P00
    dw MusicB1S09P07

MusicB1S09L04:
    dw MusicB1S09P17
    dw MusicB1S09P18
    dw MusicB1S09P19
    dw MusicB1S09P1A
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw MusicB1S09P00
    dw MusicB1S09P07

MusicB1S09L05:
    dw MusicB1S09P00
    dw MusicB1S09P1B
    dw MusicB1S09P1C
    dw MusicB1S09P1D
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw $0000
    dw MusicB1S09P07

MusicB1S09L06:
    dw MusicB1S09P00
    dw MusicB1S09P1E
    dw MusicB1S09P1F
    dw MusicB1S09P1D
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw $0000
    dw MusicB1S09P07

MusicB1S09L07:
    dw MusicB1S09P00
    dw MusicB1S09P20
    dw MusicB1S09P21
    dw MusicB1S09P22
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw $0000
    dw MusicB1S09P07

MusicB1S09L08:
    dw MusicB1S09P00
    dw MusicB1S09P23
    dw MusicB1S09P24
    dw MusicB1S09P25
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw MusicB1S09P26
    dw MusicB1S09P07

MusicB1S09L09:
    dw MusicB1S09P00
    dw MusicB1S09P23
    dw MusicB1S09P27
    dw MusicB1S09P28
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw MusicB1S09P26
    dw MusicB1S09P07

MusicB1S09L0A:
    dw MusicB1S09P00
    dw MusicB1S09P14
    dw MusicB1S09P15
    dw MusicB1S09P16
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw MusicB1S09P13
    dw MusicB1S09P07

MusicB1S09L0B:
    dw MusicB1S09P00
    dw MusicB1S09P29
    dw MusicB1S09P2A
    dw MusicB1S09P2B
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw $0000
    dw MusicB1S09P07

MusicB1S09L0C:
    dw MusicB1S09P00
    dw MusicB1S09P2C
    dw MusicB1S09P2D
    dw MusicB1S09P2E
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw $0000
    dw MusicB1S09P07

MusicB1S09L0D:
    dw MusicB1S09P00
    dw MusicB1S09P2F
    dw MusicB1S09P30
    dw MusicB1S09P31
    dw MusicB1S09P04
    dw MusicB1S09P05
    dw $0000
    dw MusicB1S09P07

MusicB1S09P19:
    db $DA,$04,$DB,$0A,$0C,$6C,$B0,$C7
    db $C7,$AB,$C7,$C7,$A8,$C7,$C7,$AD
    db $C7,$18,$AF,$0C,$AE,$AD,$C7,$10
    db $AB,$B4,$B7,$0C,$B9,$C7,$B5,$B7
    db $C7,$B4,$C7,$B0,$B2,$24,$AF,$00

MusicB1S09P0D:
    db $DA,$03,$DB,$0A,$0C,$6C,$A8,$C7
    db $A8,$A8,$C7,$A8,$C7,$A8,$C7,$A8
    db $C7,$A8,$C7,$A8,$A8,$A8,$0C,$A8
    db $C7,$A8,$C7,$C7,$A9,$C7,$A9,$A8
    db $C7,$C7,$C7,$C7,$C7,$C7,$C7

MusicB1S09P0C:
    db $DA,$03,$DB,$0A,$0C,$6C,$B0,$C7
    db $B4,$AF,$C7,$B4,$C7,$AD,$C7,$B4
    db $C7,$AF,$C7,$AF,$B0,$B2,$0C,$B0
    db $C7,$B0,$C7,$C7,$B0,$C7,$B0,$B0
    db $C7,$C7,$C7,$C7,$C7,$C7,$C7

MusicB1S09P18:
    db $DA,$03,$DB,$14,$0C,$69,$B0,$C7
    db $B4,$AF,$C7,$B4,$C7,$AD,$C7,$B4
    db $C7,$AF,$C7,$AF,$B0,$B2,$0C,$B0
    db $C7,$B4,$AF,$C7,$B4,$C7,$AD,$C7
    db $B4,$C7,$AF,$C7,$AF,$B0,$B2

MusicB1S09P02:
    db $DA,$03,$DB,$0A,$0C,$6C,$AB,$C7
    db $AB,$AB,$C7,$AB,$C7,$AB,$C7,$AB
    db $C7,$AB,$C7,$AB,$AB,$AB,$0C,$AB
    db $C7,$AB,$AB,$C7,$AB,$C7,$AB,$C7
    db $AB,$C7,$AB,$C7,$AB,$AB,$AB

MusicB1S09P01:
    db $DA,$03,$DB,$0A,$0C,$6C,$B0,$C7
    db $B4,$AF,$C7,$B4,$C7,$AD,$C7,$B4
    db $C7,$AF,$C7,$AF,$B0,$B2,$0C,$B0
    db $C7,$B4,$AF,$C7,$B4,$C7,$AD,$C7
    db $B4,$C7,$AF,$C7,$AF,$B0,$B1

MusicB1S09P09:
    db $DA,$03,$DB,$0A,$0C,$6C,$AD,$C7
    db $AD,$AD,$C7,$AD,$C7,$AD,$C7,$AD
    db $C7,$AD,$C7,$AD,$AD,$AD,$0C,$AD
    db $C7,$AD,$AD,$C7,$AD,$C7,$AD,$C7
    db $AD,$C7,$AD,$C7,$AD,$AD,$AD

MusicB1S09P08:
    db $DA,$03,$DB,$0A,$0C,$6C,$B2,$C7
    db $B5,$B1,$C7,$B5,$C7,$B0,$C7,$B5
    db $C7,$AF,$C7,$AF,$B0,$B1,$0C,$B2
    db $C7,$B5,$B1,$C7,$B5,$C7,$B0,$C7
    db $B5,$C7,$AF,$C7,$AF,$B0,$B2

MusicB1S09P1A:
    db $DA,$04,$DB,$0A,$0C,$6C,$A8,$C7
    db $C7,$A4,$C7,$C7,$9F,$C7,$C7,$A4
    db $C7,$18,$A6,$0C,$A5,$A4,$C7,$10
    db $A4,$AB,$AF,$0C,$B0,$C7,$AD,$AF
    db $C7,$AB,$C7,$A8,$A9,$24,$A6,$DA
    db $04,$0C,$6C,$9F,$C7,$C7,$9C,$C7
    db $C7,$98,$C7,$C7,$9D,$C7,$18,$9F
    db $0C,$9E,$9D,$C7,$60,$C7,$C7,$10
    db $9C,$A4,$A8,$0C,$A9,$C7,$A6,$A8
    db $C7,$A4,$C7,$A1,$A3,$24,$9F

MusicB1S09P03:
    db $DA,$0E,$0C,$6D,$8C,$C6,$C6,$93
    db $93,$C6,$C6,$98,$98,$C6,$C6,$93
    db $93,$C6,$93,$C6,$8C,$C6,$C6,$93
    db $93,$C6,$C6,$98,$C6,$98,$C6,$98
    db $93,$C6,$93,$C6

MusicB1S09P0E:
    db $DA,$0E,$0C,$6D,$8C,$C6,$C6,$93
    db $93,$C6,$C6,$98,$98,$C6,$C6,$93
    db $93,$C6,$93,$C6,$8C,$C6,$8C,$C6
    db $C6,$8D,$C6,$8D,$8C,$C6,$C6,$93
    db $93,$C6,$93,$C6

MusicB1S09P17:
    db $DA,$0E,$0C,$6D,$DB,$0A,$8C,$C6
    db $C6,$8C,$90,$C6,$C6,$90,$91,$C6
    db $C6,$91,$92,$C6,$93,$C6,$8C,$C6
    db $C6,$8C,$90,$C6,$C6,$90,$91,$C6
    db $C6,$91,$92,$C6,$93,$C6

MusicB1S09P0A:
    db $DA,$0E,$0C,$6D,$8E,$C6,$C6,$95
    db $95,$C6,$C6,$9A,$9A,$C6,$C6,$95
    db $95,$C6,$95,$C6,$8E,$C6,$C6,$95
    db $95,$C6,$C6,$9A,$C6,$9A,$C6,$9A
    db $95,$C6,$95,$C6

MusicB1S09P1C:
    db $DA,$07,$DB,$0A,$18,$6B,$C7,$0C
    db $B7,$B6,$B5,$B3,$C7,$B4,$C7,$AC
    db $AD,$B0,$C7,$AD,$B0,$B2,$00

MusicB1S09P1B:
    db $DA,$07,$DB,$0A,$18,$6B,$C7,$0C
    db $B4,$B3,$B2,$AF,$C7,$B0,$C7,$A8
    db $A9,$AB,$C7,$A4,$A8,$A9

MusicB1S09P1D:
    db $DA,$0E,$0C,$6D,$8C,$C6,$C6,$8C
    db $90,$C6,$C6,$90,$91,$C6,$C6,$91
    db $95,$C6,$98,$C6

MusicB1S09P07:
    db $DA,$00,$DB,$14,$0C,$7C,$D2,$C6
    db $D2,$D2,$D2,$C6,$D2,$D2,$D2,$C6
    db $D2,$D2,$D2,$C6,$D2,$D2,$D2,$C6
    db $D2,$D2,$D2,$C6,$D2,$D2,$D2,$C6
    db $D2,$D2,$D2,$C6,$D2,$D2

MusicB1S09P05:
    db $DA,$0C,$DB,$05,$18,$7C,$A9,$A9
    db $B0,$0C,$C6,$A9,$24,$B0,$0C,$A9
    db $18,$A9,$A9,$18,$A9,$A9,$B0,$0C
    db $C6,$A9,$24,$B0,$0C,$A9,$18,$A9
    db $A9

MusicB1S09P06:
    db $DA,$02,$DB,$00,$DE,$00,$00,$00
    db $0C,$15,$AB,$AB,$C6,$B2,$AB,$AB
    db $C6,$B2,$C7,$B2,$C7,$B2,$AB,$AB
    db $C6,$B2,$AB,$AB,$C6,$B2,$AB,$AB
    db $C6,$B2,$C7,$B2,$C7,$B2,$AB,$AB
    db $C6,$B2

MusicB1S09P00:
    db $F0,$DA,$0C,$DB,$0C,$E2,$29,$18
    db $6C,$98,$9F,$0C,$9F,$98,$C6,$18
    db $98,$9F,$0C,$9F,$0C,$9F,$C6,$98
    db $98,$18,$98,$9F,$0C,$9F,$98,$C6
    db $18,$98,$9F,$0C,$9F,$0C,$9F,$C6
    db $98,$98,$00

MusicB1S09P04:
    db $DA,$00,$DB,$0A,$0C,$6C,$D6,$D6
    db $C7,$D3,$D3,$D3,$C7,$D6,$C7,$D6
    db $D6,$C7,$D3,$D3,$C7,$D6,$D6,$D6
    db $C7,$D3,$D3,$D3,$C7,$D6,$C7,$D6
    db $D6,$C7,$D3,$D3,$C7,$D6

MusicB1S09P12:
    db $DA,$00,$DB,$14,$0C,$7C,$D2,$C6
    db $D2,$D2,$D2,$C6,$D2,$D2,$D2,$C6
    db $D2,$D2,$D2,$C6,$D2,$D2,$D2,$D2
    db $D2,$C6,$D2,$D2,$C6,$D2,$D2,$C6
    db $C6,$C6,$D2,$C6,$D2,$D2

MusicB1S09P10:
    db $DA,$0C,$DB,$05,$18,$7C,$A9,$A9
    db $B0,$0C,$C6,$A9,$24,$B0,$0C,$A9
    db $18,$A9,$A9,$18,$B0,$B0,$0C,$C6
    db $B0,$C6,$B0,$24,$B0,$0C,$A4,$18
    db $A4,$A4

MusicB1S09P11:
    db $DA,$02,$DB,$00,$0C,$15,$AB,$AB
    db $C6,$B2,$AB,$AB,$C6,$B2,$C7,$B2
    db $C7,$B2,$AB,$AB,$C6,$B2,$B2,$C7
    db $B2,$C7,$C7,$B2,$C7,$B2,$B2,$C7
    db $C7,$C7,$B2,$B2,$C6,$AB

MusicB1S09P0B:
    db $DA,$0C,$DB,$0C,$18,$6C,$98,$9F
    db $0C,$9F,$98,$C6,$18,$98,$9F,$0C
    db $9F,$0C,$9F,$C6,$98,$98,$18,$6C
    db $9F,$9F,$0C,$C6,$9F,$C6,$9F,$18
    db $98,$C6,$0C,$9F,$9F,$C6,$98,$00

MusicB1S09P0F:
    db $DA,$00,$DB,$0A,$0C,$6C,$D6,$D6
    db $C7,$D3,$D3,$D3,$C7,$D6,$C7,$D6
    db $D6,$C7,$D3,$D3,$C7,$D6,$D3,$C7
    db $D3,$C7,$C7,$D3,$C7,$D3,$D3,$C7
    db $C7,$C7,$D3,$D3,$C7,$D6

MusicB1S09P1F:
    db $DA,$07,$DB,$0A,$18,$6B,$C7,$0C
    db $B7,$B6,$B5,$B3,$C7,$B4,$C7,$BC
    db $C7,$BC,$18,$BC,$C7,$00

MusicB1S09P1E:
    db $DA,$07,$DB,$0A,$18,$6B,$C7,$0C
    db $B4,$B3,$B2,$AF,$C7,$B0,$C7,$B5
    db $C7,$B5,$18,$B5,$C7

MusicB1S09P21:
    db $DA,$07,$DB,$0A,$18,$6B,$C7,$0C
    db $B3,$C7,$C7,$B2,$C7,$C7,$18,$B0
    db $C6,$C6,$C7,$00

MusicB1S09P20:
    db $DA,$07,$DB,$0A,$18,$6B,$C7,$0C
    db $AC,$C7,$C7,$A9,$C7,$C7,$18,$A8
    db $C6,$C6,$C7

MusicB1S09P22:
    db $DA,$0E,$0C,$6D,$94,$C6,$C6,$94
    db $96,$C6,$C6,$96,$98,$95,$96,$97
    db $98,$C6,$C6,$C6

MusicB1S09P24:
    db $DA,$06,$DB,$0C,$0C,$6B,$B0,$B0
    db $C7,$B0,$C7,$B0,$B2,$C7,$B4,$B0
    db $C7,$AD,$30,$AB,$00

MusicB1S09P25:
    db $DA,$06,$DB,$08,$0C,$6B,$AC,$AC
    db $C7,$AC,$C7,$AC,$AE,$C7,$AB,$A8
    db $C7,$A8,$30,$A4

MusicB1S09P26:
    db $DA,$03,$DB,$14,$0C,$69,$B8,$C7
    db $BC,$B3,$C7,$B8,$C7,$B7,$C7,$BC
    db $C7,$B4,$B7,$C7,$BC,$C7

MusicB1S09P27:
    db $DA,$06,$DB,$0C,$0C,$6B,$B0,$B0
    db $C7,$B0,$C7,$B0,$B2,$24,$B4,$C6
    db $C6,$00

MusicB1S09P28:
    db $DA,$06,$DB,$08,$0C,$6B,$AC,$AC
    db $C7,$AC,$C7,$AC,$AE,$24,$AB,$C6
    db $C6

MusicB1S09P23:
    db $DA,$0E,$DB,$0A,$24,$6D,$88,$8F
    db $18,$94,$24,$93,$8C,$18,$87

MusicB1S09P15:
    db $DA,$06,$DB,$0A,$0C,$6B,$B4,$B4
    db $C7,$B4,$C7,$B0,$B4,$C7,$18,$B7
    db $C7,$DA,$0F,$A3,$C7,$00

MusicB1S09P16:
    db $DA,$06,$DB,$0A,$0C,$6B,$AA,$AA
    db $C7,$AA,$C7,$AA,$AA,$C7,$18,$AF
    db $C7,$DA,$0F,$A3,$C7

MusicB1S09P14:
    db $DA,$0E,$0C,$6D,$8E,$8E,$C7,$8E
    db $C7,$8E,$90,$91,$18,$93,$C7,$93
    db $C7

MusicB1S09P13:
    db $DA,$04,$DB,$0A,$0C,$6B,$AD,$AD
    db $C7,$AD,$C7,$AD,$AD,$C7,$18,$B2
    db $C7,$C7,$C7

MusicB1S09P2A:
    db $DA,$07,$DB,$0A,$0C,$6B,$B4,$B0
    db $C7,$24,$AB,$18,$AC,$0C,$AD,$B5
    db $C7,$B5,$30,$AD,$00

MusicB1S09P2B:
    db $DA,$07,$DB,$0A,$0C,$6B,$B0,$18
    db $AD,$24,$A8,$18,$A8,$0C,$A9,$B0
    db $C7,$B0,$30,$A9

MusicB1S09P29:
    db $DA,$0E,$DB,$0A,$24,$6D,$8C,$0C
    db $92,$18,$93,$98,$24,$91,$0C,$91
    db $0C,$98,$98,$91,$C7

MusicB1S09P2D:
    db $DA,$07,$DB,$0A,$10,$6B,$AF,$B9
    db $B9,$B9,$B7,$B5,$0C,$B4,$B0,$C7
    db $AD,$30,$AB,$00

MusicB1S09P2E:
    db $DA,$07,$DB,$0A,$10,$6B,$AB,$B5
    db $B5,$B5,$B4,$B2,$0C,$B0,$AD,$C7
    db $A9,$30,$A8

MusicB1S09P2C:
    db $DA,$0E,$DB,$0A,$24,$6D,$8E,$0C
    db $91,$18,$93,$97,$24,$93,$0C,$93
    db $0C,$98,$98,$93,$C7

MusicB1S09P30:
    db $DA,$07,$DB,$0A,$0C,$6B,$AF,$B5
    db $C7,$B5,$10,$B5,$B4,$B2,$30,$B0
    db $C7,$00

MusicB1S09P31:
    db $DA,$07,$DB,$0A,$0C,$6B,$AB,$B2
    db $C7,$B2,$10,$B2,$B0,$AF,$0C,$AB
    db $A8,$C7,$A8,$30,$A4

MusicB1S09P2F:
    db $DA,$0E,$DB,$0A,$24,$6D,$93,$0C
    db $93,$10,$93,$95,$97,$18,$98,$93
    db $30,$8C,$00

MusicB1S08P00:
    db $F0,$DA,$04,$E2,$23,$DB,$0A,$DE
    db $14,$15,$20,$30,$7E,$C7,$0C,$A9
    db $A9,$18,$4E,$A9,$B0,$48,$7E,$AF
    db $0C,$4E,$AE,$AD,$18,$AC,$B5,$60
    db $B4,$C6,$00

MusicB1S08P04:
    db $DA,$04,$DB,$0A,$DE,$14,$15,$20
    db $30,$7E,$C7,$0C,$9D,$9D,$18,$4E
    db $9D,$A4,$48,$7E,$A3,$0C,$4E,$A2
    db $A1,$18,$A0,$A9,$60,$A8,$C6

MusicB1S08P01:
    db $DA,$04,$DB,$0A,$DE,$14,$15,$20
    db $30,$7E,$C7,$0C,$A4,$A4,$18,$4E
    db $A4,$AB,$48,$7E,$AA,$0C,$4E,$A9
    db $A8,$18,$A7,$B0,$60,$AF,$C6

MusicB1S08P02:
    db $DA,$04,$DB,$0A,$DE,$14,$15,$20
    db $30,$7E,$C7,$0C,$9F,$9F,$18,$4E
    db $9F,$A6,$48,$7E,$A5,$0C,$4E,$A4
    db $A3,$18,$A2,$AB,$60,$AA,$C6

MusicB1S08P03:
    db $DA,$04,$DB,$0A,$DE,$14,$1F,$30
    db $0C,$4F,$8C,$8C,$60,$8C,$18,$C6
    db $06,$3F,$8C,$8C,$8C,$8C,$48,$6F
    db $8C,$18,$8C,$60,$8D,$C6

MusicB1S08P05:
    db $DA,$04,$DB,$0A,$0C,$4F,$D0,$D0
    db $60,$D0,$18,$C6,$06,$3F,$D0,$D0
    db $D0,$D0,$48,$6F,$D0,$18,$D0,$60
    db $D0,$C7

MusicB1S06P00:
    db $F0,$18,$C7,$00

MusicB1S06P01:
    db $DA,$01,$E2,$19,$DB,$0D,$DE,$14
    db $1F,$30,$06,$4E,$B0,$B2,$B0,$C6
    db $B0,$B2,$B0,$C6,$0C,$3E,$B0,$18
    db $5E,$BC,$0C,$BC,$0C,$5C,$BB,$0C
    db $2C,$B2,$B2,$B2,$30,$6D,$B2,$00

MusicB1S06P02:
    db $DA,$01,$DB,$08,$DE,$14,$1E,$30
    db $30,$7D,$C7,$0C,$A7,$24,$AC,$30
    db $C7,$0C,$7C,$AE,$24,$AF

MusicB1S06P03:
    db $DA,$01,$DB,$0A,$DE,$14,$1D,$30
    db $18,$7D,$C7,$C7,$0C,$A4,$24,$A7
    db $18,$C7,$C7,$0C,$7C,$AA,$24,$AB

MusicB1S06P04:
    db $DA,$01,$DB,$05,$DE,$14,$1E,$30
    db $18,$C7,$48,$4E,$9B,$18,$C7,$48
    db $4D,$9F

MusicB1S06P05:
    db $DA,$01,$DB,$00,$DE,$14,$1C,$30
    db $60,$4F,$94,$60,$4E,$93

MusicB1S06P06:
    db $0C,$6C,$B5,$0C,$2B,$B3,$B3,$0C
    db $6C,$B5,$0C,$2B,$B3,$B3,$18,$6C
    db $B5,$0C,$6C,$B4,$0C,$2B,$B2,$B2
    db $0C,$6C,$B4,$0C,$2B,$B2,$B2,$18
    db $6C,$B4,$0C,$6D,$B5,$0C,$2C,$B3
    db $B3,$0C,$6D,$B5,$0C,$2C,$B3,$B3
    db $0C,$6D,$B5,$BC,$0C,$7C,$C6,$54
    db $7C,$BB,$00

MusicB1S06P07:
    db $24,$3B,$AE,$AE,$18,$6B,$AE,$24
    db $3B,$AD,$AD,$18,$6B,$AD,$24,$3C
    db $AE,$AE,$18,$6C,$AE,$60,$5D,$AD

MusicB1S06P08:
    db $24,$3B,$AA,$AA,$18,$6B,$AA,$24
    db $3B,$A9,$A9,$18,$6B,$A9,$24,$3C
    db $AA,$AA,$18,$6C,$AA,$60,$5D,$A9

MusicB1S05P00:
    db $F0,$DA,$04,$E2,$19,$DB,$0A,$0C
    db $3B,$B0,$B0,$B0,$A6,$18,$B0,$0C
    db $A6,$AF,$C6,$AF,$AF,$A4,$AF,$AD
    db $AE,$AF,$00

MusicB1S05P04:
    db $DA,$04,$DB,$00,$0C,$3B,$AD,$AD
    db $AD,$C7,$18,$AD,$0C,$C7,$AB,$C6
    db $AB,$AB,$C7,$AB,$C7,$C7,$C7

MusicB1S05P02:
    db $DA,$04,$DB,$00,$0C,$3B,$A9,$A9
    db $A9,$C7,$18,$A9,$0C,$C7,$A8,$C6
    db $A8,$A8,$C7,$A8,$C7,$C7,$C7

MusicB1S05P01:
    db $DA,$08,$DB,$0A,$24,$3E,$8E,$0C
    db $95,$24,$9A,$0C,$95,$24,$8C,$0C
    db $93,$98,$98,$93,$C6

MusicB1S05P05:
    db $DA,$0C,$DB,$00,$0C,$6F,$A6,$C6
    db $AD,$C6,$C6,$AD,$A3,$A3,$A6,$C6
    db $AD,$C6,$C6,$AD,$A3,$A3

MusicB1S05P03:
    db $DA,$0A,$DB,$14,$0C,$6B,$C7,$C6
    db $D2,$C6,$C6,$C6,$0C,$69,$D1,$D1
    db $0C,$6B,$C7,$C6,$D2,$C6,$C6,$C6
    db $0C,$69,$D1,$D1

MusicB1S05P06:
    db $0C,$B0,$B0,$B0,$A6,$18,$B0,$0C
    db $A6,$AF,$C6,$AF,$AF,$AF,$AF,$C7
    db $C7,$C7,$00

MusicB1S05P0A:
    db $0C,$AD,$AD,$AD,$C7,$18,$AD,$0C
    db $C7,$AB,$C6,$AB,$AB,$AB,$AB,$C7
    db $C7,$C7

MusicB1S05P08:
    db $0C,$A9,$A9,$A9,$C7,$18,$A9,$0C
    db $C7,$A8,$C6,$A8,$A8,$A8,$A8,$C7
    db $C7,$C7

MusicB1S05P07:
    db $24,$8E,$0C,$95,$24,$9A,$0C,$95
    db $8C,$8C,$8C,$8C,$8C,$C6,$C6,$93

MusicB1S05P0B:
    db $0C,$A6,$C6,$AD,$C6,$C6,$AD,$A3
    db $A3,$A6,$C6,$AD,$AD,$AD,$C6,$B0
    db $C6

MusicB1S05P09:
    db $0C,$C7,$C6,$D2,$C6,$C6,$C6,$0C
    db $69,$D1,$D1,$0C,$6B,$C7,$D1,$0C
    db $69,$D1,$0C,$6B,$D1,$30,$6C,$D1

MusicB1S07P00:
    db $F0,$DA,$04,$E2,$18,$DB,$05,$DE
    db $00,$00,$00,$60,$49,$C6,$48,$C6
    db $0C,$C7,$AC,$00

MusicB1S07P02:
    db $DA,$04,$DB,$0A,$DE,$00,$00,$00
    db $60,$49,$C6,$48,$C6,$0C,$C7,$A7

MusicB1S07P04:
    db $DA,$04,$DB,$0F,$DE,$00,$00,$00
    db $60,$49,$C6,$48,$C6,$0C,$C7,$A1

MusicB1S07P06:
    db $60,$AB,$48,$C6,$0C,$C7,$AB,$00

MusicB1S07P07:
    db $60,$A6,$48,$C6,$0C,$C7,$A6

MusicB1S07P08:
    db $60,$A0,$48,$C6,$0C,$C7,$A0

MusicB1S07P09:
    db $60,$AC,$48,$C6,$0C,$C7,$AC,$00

MusicB1S07P0A:
    db $60,$A7,$48,$C6,$0C,$C7,$A7

MusicB1S07P0B:
    db $60,$A1,$48,$C6,$0C,$C7,$A1

MusicB1S07P01:
    db $DA,$0E,$E7,$FF,$DB,$0A,$06,$6F
    db $C7,$84,$84,$84,$84,$C6,$84,$84
    db $C6,$84,$84,$C6,$84,$C6,$0C,$9A
    db $DD,$06,$04,$9C,$06,$C7,$84,$84
    db $84,$84,$C6,$84,$84,$C6,$84,$84
    db $C6,$84,$C6,$0C,$95,$DD,$06,$04
    db $97

MusicB1S07P05:
    db $DA,$05,$DB,$14,$DE,$00,$00,$00
    db $E9,$8B,$1F,$20,$06,$49,$D1,$06
    db $49,$D1,$06,$4B,$D1,$06,$49,$D1
    db $06,$4C,$D1,$06,$49,$D1,$06,$4B
    db $D1,$06,$49,$D1,$06,$49,$D1,$06
    db $49,$D1,$06,$4B,$D1,$06,$49,$D1
    db $06,$4C,$D1,$06,$49,$D1,$06,$4B
    db $D1,$06,$49,$D1,$00

MusicB1S07P03:
    db $DA,$05,$E7,$FF,$DB,$0A,$DE,$00
    db $00,$00,$18,$4F,$D0,$D8,$0C,$C7
    db $D0,$18,$D8,$D0,$D8,$0C,$C7,$D0
    db $18,$D8

MusicB1S03P00:
    db $F0,$DA,$03,$E2,$1C,$DB,$0A,$12
    db $5D,$A8,$06,$A8,$0C,$A8,$9F,$18
    db $A1,$9F,$0C,$A8,$A8,$A8,$DA,$00
    db $DB,$00,$0C,$B7,$0C,$B9,$C6,$B7
    db $C7,$DA,$03,$DB,$0A,$12,$A9,$06
    db $A9,$0C,$A9,$A1,$18,$A3,$A1,$0C
    db $A9,$A9,$A9,$DA,$00,$DB,$00,$0C
    db $B9,$0C,$BB,$C6,$B9,$C7,$00

MusicB1S03P01:
    db $DA,$03,$DB,$0A,$12,$5D,$A4,$06
    db $A4,$0C,$A4,$9C,$18,$9D,$9C,$0C
    db $A4,$A4,$A4,$DA,$00,$DB,$00,$0C
    db $B4,$0C,$B5,$C6,$B4,$C7,$DA,$03
    db $DB,$0A,$12,$A6,$06,$A6,$0C,$A6
    db $9D,$18,$9F,$9D,$0C,$A6,$A6,$A6
    db $DA,$00,$DB,$00,$0C,$B5,$0C,$B7
    db $C6,$B5,$C7

MusicB1S03P02:
    db $DA,$04,$DB,$0A,$24,$6D,$8C,$0C
    db $93,$18,$98,$93,$0C,$8C,$8C,$8C
    db $C7,$0C,$C7,$C7,$8C,$C6,$24,$8E
    db $0C,$95,$18,$9A,$95,$0C,$8E,$8E
    db $8E,$C7,$0C,$C7,$C7,$8E,$C6

MusicB1S03P03:
    db $DA,$04,$DB,$14,$06,$6B,$D1,$06
    db $69,$D1,$D1,$D1,$0C,$D1,$D1,$18
    db $D1,$D1,$0C,$6B,$D1,$D1,$D1,$C7
    db $30,$C7,$06,$6B,$D1,$06,$69,$D1
    db $D1,$D1,$0C,$D1,$D1,$18,$D1,$D1
    db $0C,$6B,$D1,$D1,$D1,$C7,$30,$C7

MusicB1S03P04:
    db $DA,$03,$E2,$1C,$DB,$0A,$12,$5D
    db $A8,$06,$A8,$0C,$A8,$9F,$18,$A1
    db $9F,$DA,$01,$0C,$A8,$A7,$A6,$A5
    db $30,$A4,$00

MusicB1S03P05:
    db $DA,$03,$DB,$0A,$12,$5D,$A4,$06
    db $A4,$0C,$A4,$9C,$18,$9D,$9C,$DA
    db $01,$0C,$A2,$A1,$A0,$9F,$30,$9E

MusicB1S03P06:
    db $DA,$04,$DB,$0A,$24,$6D,$8C,$0C
    db $93,$18,$98,$93,$0C,$8C,$8B,$8A
    db $89,$30,$88

MusicB1S03P07:
    db $DA,$04,$DB,$14,$06,$6B,$D1,$06
    db $69,$D1,$D1,$D1,$0C,$D1,$D1,$18
    db $D1,$D1,$48,$C7,$D4

MusicB1S02P06:
    db $DA,$08,$E2,$1C,$DB,$0A,$18,$4F
    db $8C,$98,$89,$95,$8E,$9A,$87,$93
    db $8C,$98,$89,$95,$60,$C7,$00

MusicB1S02P05:
    db $DA,$03,$DB,$0A,$08,$6F,$C7,$C7
    db $A4,$AF,$A4,$AF,$18,$C7,$AD,$08
    db $C7,$C7,$A6,$B0,$A6,$B0,$18,$C7
    db $AF,$08,$C7,$C7,$A4,$AF,$A4,$AF
    db $18,$C7,$AD,$08,$A6,$C7,$A8,$A9
    db $C7,$AB,$DA,$00,$08,$C7,$C7,$04
    db $B7,$B9,$0C,$B7,$C7

MusicB1S02P07:
    db $DA,$03,$DB,$00,$08,$6F,$C7,$C7
    db $C7,$AB,$C7,$AB,$18,$C7,$A8,$08
    db $C7,$C7,$C7,$AD,$C7,$AD,$18,$C7
    db $AB,$08,$C7,$C7,$C7,$AB,$C7,$AB
    db $18,$C7,$A8,$60,$C7

MusicB1S02P08:
    db $DA,$03,$DB,$14,$08,$6F,$C7,$C7
    db $C7,$A8,$C7,$A8,$18,$C7,$A4,$08
    db $C7,$C7,$C7,$A9,$C7,$A9,$18,$C7
    db $A6,$08,$C7,$C7,$C7,$A8,$C7,$A8
    db $18,$C7,$A4,$60,$C7,$08,$D1,$C7
    db $D1,$18,$D2,$00

MusicB1S02P01:
    db $DA,$08,$DB,$0A,$18,$4F,$8C,$98
    db $89,$95,$8E,$9A,$87,$93,$8C,$98
    db $89,$95,$0C,$8E,$C7,$18,$C7,$30
    db $8D,$00

MusicB1S02P00:
    db $F0,$DA,$03,$E2,$1C,$DB,$0A,$08
    db $6F,$C7,$C7,$A4,$AF,$A4,$AF,$18
    db $C7,$AD,$08,$C7,$C7,$A6,$B0,$A6
    db $B0,$18,$C7,$AF,$08,$C7,$C7,$A4
    db $AF,$A4,$AF,$18,$C7,$AD,$08,$B0
    db $C7,$AD,$C7,$A9,$C7,$18,$A8,$A6

MusicB1S02P02:
    db $DA,$03,$DB,$00,$08,$6F,$C7,$C7
    db $C7,$AB,$C7,$AB,$18,$C7,$A8,$08
    db $C7,$C7,$C7,$AD,$C7,$AD,$18,$C7
    db $AB,$08,$C7,$C7,$C7,$AB,$C7,$AB
    db $18,$C7,$A8,$18,$AD,$C7,$30,$A3

MusicB1S02P03:
    db $DA,$03,$DB,$14,$08,$6F,$C7,$C7
    db $C7,$A8,$C7,$A8,$18,$C7,$A4,$08
    db $C7,$C7,$C7,$A9,$C7,$A9,$18,$C7
    db $A6,$08,$C7,$C7,$C7,$A8,$C7,$A8
    db $18,$C7,$A4,$18,$A9,$C7,$30,$9D

MusicB1S02P04:
    db $DA,$02,$DB,$14,$08,$6C,$D1,$C7
    db $D1,$18,$D2,$E9,$98,$21,$05,$18
    db $D1,$08,$D1,$D1,$D1,$18,$D2,$D2
    db $00

MusicB1S04P04:
    db $DA,$02,$DB,$05,$DE,$00,$00,$00
    db $06,$6B,$B7,$C6,$C6,$C6,$AB,$C6
    db $C6,$C6,$60,$C6,$30,$C3,$06,$B6
    db $C6,$C6,$C6,$AA,$C6,$C6,$C6,$60
    db $C6,$30,$C2,$00

MusicB1S04P05:
    db $DA,$02,$DB,$00,$DE,$00,$00,$00
    db $06,$6B,$C6,$B1,$C6,$C6,$C6,$B1
    db $C6,$C6,$60,$C6,$30,$C6,$06,$C6
    db $B0,$C6,$C6,$C6,$B0,$C6,$C6,$60
    db $C6,$30,$C6

MusicB1S04P07:
    db $DA,$02,$DB,$14,$DE,$00,$00,$00
    db $06,$6D,$C6,$C6,$AB,$C6,$C6,$C6
    db $B7,$C6,$60,$C6,$30,$C6,$06,$C6
    db $C6,$AA,$C6,$C6,$C6,$B6,$C6,$60
    db $C6,$30,$C6

MusicB1S04P06:
    db $DA,$02,$DB,$0F,$DE,$00,$00,$00
    db $06,$6D,$C6,$C6,$C6,$A5,$C6,$C6
    db $C6,$C6,$5A,$C6,$36,$B7,$06,$C6
    db $C6,$C6,$A4,$C6,$C6,$C6,$C6,$5A
    db $C6,$36,$B6

MusicB1S04P08:
    db $06,$B5,$C6,$C6,$C6,$A9,$C6,$C6
    db $C6,$60,$C6,$30,$C6,$06,$B4,$C6
    db $C6,$C6,$A8,$C6,$C6,$C6,$60,$C6
    db $30,$C6,$00

MusicB1S04P09:
    db $06,$C6,$AF,$C6,$C6,$C6,$AF,$C6
    db $C6,$60,$C6,$30,$C6,$06,$C6,$AE
    db $C6,$C6,$C6,$AE,$C6,$C6,$60,$C6
    db $30,$C6

MusicB1S04P0D:
    db $06,$C6,$C6,$A9,$C6,$C6,$C6,$B5
    db $C6,$60,$C6,$30,$C6,$06,$C6,$C6
    db $A8,$C6,$C6,$C6,$B4,$C6,$60,$C6
    db $30,$C6

MusicB1S04P0C:
    db $06,$C6,$C6,$C6,$A3,$C6,$C6,$C6
    db $C6,$5A,$C6,$36,$C6,$06,$C6,$C6
    db $C6,$A2,$C6,$C6,$C6,$C6,$5A,$C6
    db $36,$C6

MusicB1S04P00:
    db $F0,$DA,$0E,$E2,$23,$DB,$0A,$30
    db $4E,$8E,$18,$C6,$0C,$8E,$8E,$60
    db $C7,$30,$91,$18,$C6,$0C,$91,$91
    db $60,$C7,$00

MusicB1S04P02:
    db $DA,$07,$DB,$0A,$30,$4E,$8E,$18
    db $C6,$0C,$8E,$8E,$60,$C7,$30,$91
    db $18,$C6,$0C,$91,$91,$60,$C7,$00

MusicB1S04P0A:
    db $30,$4E,$94,$18,$C6,$0C,$94,$94
    db $60,$C7,$30,$8D,$18,$C6,$0C,$8D
    db $8D,$60,$C7

MusicB1S04P0B:
    db $30,$4E,$94,$18,$C6,$0C,$94,$94
    db $60,$C7,$30,$8D,$18,$C6,$0C,$8D
    db $8D,$0C,$6C,$C7,$D8,$0C,$6F,$D0
    db $D0,$0C,$7C,$D8,$0C,$7F,$D0,$0C
    db $D8,$D8

MusicB1S04P01:
    db $DA,$05,$DB,$0A,$DE,$00,$00,$00
    db $E9,$BC,$23,$08,$0C,$49,$D1,$D1
    db $0C,$4B,$D1,$0C,$49,$D1,$0C,$4C
    db $D1,$0C,$49,$D1,$0C,$4B,$D1,$0C
    db $49,$D1,$00

MusicB1S04P03:
    db $DA,$05,$DB,$0A,$DE,$00,$00,$00
    db $30,$4F,$D0,$02,$C7,$16,$D8,$0C
    db $C6,$D0,$0C,$C7,$D0,$C7,$D0,$01
    db $C7,$17,$D8,$0C,$C6,$D0,$30,$D0
    db $02,$C7,$16,$D8,$0C,$C6,$D0,$0C
    db $4D,$C7,$D0,$0C,$4E,$D0,$D0,$01
    db $C7,$17,$D8,$0C,$C6,$D0

MusicB1S04P0E:
    db $DA,$05,$DB,$0A,$DE,$00,$00,$00
    db $30,$4F,$D0,$02,$C7,$16,$D8,$0C
    db $C6,$D0,$0C,$C7,$D0,$C7,$D0,$01
    db $C7,$17,$D8,$0C,$C6,$D0,$30,$D0
    db $03,$C7,$15,$D8,$0C,$C6,$D0,$0C
    db $7F,$C7,$03,$C6,$09,$D8,$0C,$D0
    db $D0,$03,$C7,$09,$D8,$0C,$D0,$03
    db $C6,$09,$D8,$03,$C6,$09,$D8

MusicB1S01P00:
    db $F0,$DA,$03,$E2,$3C,$E0,$E6,$DB
    db $0F,$18,$3E,$B2,$B2,$B2,$A6,$B2
    db $B2,$B2,$A6,$06,$B3,$B0,$B3,$B0
    db $B3,$B0,$B3,$B0,$B3,$B0,$B3,$B0
    db $B3,$B0,$B3,$B0,$18,$B2,$AD,$A6
    db $00

MusicB1S01P01:
    db $DA,$00,$DB,$0A,$E7,$FA,$DE,$23
    db $13,$40,$18,$4E,$BE,$BE,$BE,$B2
    db $BE,$BE,$BE,$B2,$E1,$0C,$96,$0C
    db $BF,$E1,$54,$FA,$54,$C6,$E0,$E6
    db $18,$BE,$C7,$C7

MusicB1S01P02:
    db $DA,$01,$DB,$0A,$E7,$FA,$DE,$23
    db $12,$40,$18,$4E,$A6,$A6,$A6,$9A
    db $A6,$A6,$A6,$9A,$60,$AD,$18,$AA
    db $C7,$C7

MusicB1S01P03:
    db $DA,$00,$DB,$0A,$E7,$FA,$DE,$23
    db $11,$40,$60,$4E,$C7,$C7,$60,$9D
    db $18,$9A,$C7,$C7

MusicB1S01P04:
    db $DA,$02,$E0,$C8,$DB,$00,$18,$4B
    db $B2,$BB,$BB,$BB,$B2,$BB,$BB,$BB
    db $B2,$BB,$BB,$BB,$0C,$BB,$BC,$18
    db $BB,$C6,$B9,$B2,$B9,$B9,$0C,$B9
    db $C6,$18,$B2,$B9,$B9,$0C,$B9,$C6
    db $18,$B2,$B9,$B9,$0C,$B9,$C6,$B9
    db $BB,$18,$B9,$C6,$B7,$00

MusicB1S01P05:
    db $DA,$00,$DB,$0A,$E7,$DC,$DE,$23
    db $13,$40,$18,$4C,$B2,$BB,$BB,$0C
    db $4D,$BB,$C7,$18,$4C,$B2,$BB,$BB
    db $0C,$4D,$BB,$C7,$18,$4C,$B2,$BB
    db $BB,$0C,$4D,$BB,$C7,$0C,$4C,$BB
    db $BC,$18,$BB,$C6,$B9,$B2,$B9,$B9
    db $0C,$4D,$B9,$C7,$18,$4C,$B2,$B9
    db $B9,$0C,$4D,$B9,$C7,$18,$4C,$B2
    db $B9,$B9,$0C,$4D,$B9,$C7,$0C,$4C
    db $B9,$BB,$18,$B9,$C6,$B7

MusicB1S01P07:
    db $DA,$01,$DB,$0A,$18,$6E,$C7,$93
    db $AB,$AB,$C7,$93,$AB,$AB,$C7,$93
    db $AB,$AB,$C7,$8E,$AA,$AA,$C7,$8E
    db $AA,$AA,$C7,$8E,$AA,$AA,$C7,$8E
    db $AA,$C7,$AA,$93,$AB,$AB

MusicB1S01P06:
    db $DA,$01,$DB,$0F,$18,$6E,$C7,$C7
    db $A3,$A3,$C7,$C7,$A3,$A3,$C7,$C7
    db $A3,$A3,$C7,$C7,$A1,$A1,$C7,$C7
    db $A1,$A1,$C7,$C7,$A1,$A1,$C7,$C7
    db $A1,$C7,$A1,$C7,$A3,$A3

MusicB1S01P08:
    db $DA,$03,$DB,$0F,$18,$6E,$C7,$C7
    db $9A,$9F,$C7,$C7,$9A,$9F,$C7,$C7
    db $9A,$A3,$C7,$A1,$C7,$A1,$C7,$C7
    db $9A,$A1,$C7,$C7,$9A,$A1,$C7,$C7
    db $9A,$9E,$C7,$9F,$C7,$9F

MusicB1S01P0E:
    db $DA,$01,$DB,$05,$DE,$23,$12,$40
    db $18,$6C,$C7,$E0,$C8,$E1,$FF,$F0
    db $60,$B7,$B5,$B4,$B3,$E1,$64,$C8
    db $B2,$B0,$AF,$48,$C6,$C7

MusicB1S01P09:
    db $DA,$02,$DB,$00,$18,$4B,$B2,$BB
    db $BB,$BB,$B2,$BB,$BB,$BB,$B2,$BB
    db $BB,$BB,$0C,$B9,$BB,$18,$BC,$C6
    db $C0,$C6,$BE,$BE,$BE,$B2,$BC,$BC
    db $BC,$B6,$B7,$C6,$C6,$C7,$C7,$C7
    db $00

MusicB1S01P0A:
    db $DA,$00,$DB,$0A,$18,$4C,$B2,$BB
    db $BB,$0C,$4D,$BB,$C7,$18,$4C,$B2
    db $BB,$BB,$0C,$4D,$BB,$C7,$18,$4C
    db $B2,$BB,$BB,$0C,$4D,$BB,$C7,$0C
    db $4C,$B9,$BB,$30,$BC,$C0,$18,$BE
    db $BE,$0C,$4D,$BE,$C7,$18,$4C,$B2
    db $BC,$BC,$0C,$4D,$BC,$C7,$18,$4C
    db $B6,$B7,$C6,$C6,$C7,$C7,$C7

MusicB1S01P0C:
    db $DA,$01,$DB,$0A,$18,$6E,$C7,$93
    db $AB,$AB,$C7,$97,$AF,$AF,$C7,$98
    db $B0,$B0,$C7,$99,$B1,$B1,$C7,$9A
    db $AD,$AD,$C7,$92,$AA,$AA,$C7,$93
    db $C7,$8E,$C7,$93,$C7,$00

MusicB1S01P0B:
    db $DA,$01,$DB,$0F,$18,$6E,$C7,$C7
    db $A3,$A3,$C7,$C7,$A9,$A9,$C7,$C7
    db $AB,$AB,$C7,$C7,$AB,$AB,$C7,$C7
    db $A6,$A6,$C7,$C7,$A4,$A4,$C7,$A3
    db $C7,$9F,$C7,$A3,$C7,$00

MusicB1S01P0D:
    db $DA,$03,$DB,$0F,$18,$6E,$C7,$C7
    db $9A,$9F,$C7,$C7,$9D,$A3,$C7,$C7
    db $9F,$A4,$C7,$A5,$C7,$A5,$C7,$C7
    db $A1,$A6,$C7,$C7,$9E,$A4,$C7,$9A
    db $C7,$97,$C7,$93,$C7

MusicB1S01P0F:
    db $DA,$00,$DB,$05,$DE,$23,$12,$40
    db $24,$6D,$AF,$0C,$AD,$60,$AF,$B2
    db $B0,$B4,$30,$B6,$B7,$B9,$BC,$60
    db $BB,$30,$C7,$00

MusicB1S01P10:
    db $DA,$01,$E7,$F0,$DB,$0A,$DE,$23
    db $13,$40,$24,$6E,$B2,$0C,$B0,$30
    db $AF,$B2,$B7,$18,$C6,$B6,$30,$B3
    db $B4,$B9,$18,$C6,$B7,$DA,$03,$DB
    db $0F,$06,$B6,$AD,$B6,$AD,$B6,$AD
    db $B6,$C7,$B7,$AF,$B7,$AF,$B7,$AF
    db $B7,$C7,$B9,$B0,$B9,$B0,$B9,$B0
    db $B9,$C7,$BC,$B4,$BC,$B4,$BC,$B4
    db $BC,$C7,$BB,$B2,$BB,$B2,$BB,$B2
    db $BB,$B2,$BB,$B2,$BB,$B2,$BB,$B2
    db $BB,$B2,$E8,$30,$60,$06,$BB,$B2
    db $BB,$B2,$BB,$B2,$BB,$B2

MusicB1S01P12:
    db $DA,$01,$DB,$14,$30,$C7,$18,$9F
    db $A3,$A6,$A3,$9F,$A3,$A6,$A3,$A4
    db $A8,$AB,$A8,$A5,$A8,$AB,$A8,$A6
    db $AA,$AD,$AA,$A6,$AA,$AD,$AA,$9F
    db $A3,$A6,$A3,$9F,$A3,$A6,$A3

MusicB1S01P11:
    db $DA,$04,$DE,$23,$11,$40,$DB,$0A
    db $30,$6C,$C7,$60,$93,$97,$98,$99
    db $9A,$95,$97,$93

MusicB1S01P13:
    db $DA,$00,$DB,$05,$DE,$23,$12,$40
    db $24,$6D,$AF,$0C,$AD,$60,$AF,$B2
    db $B0,$B4,$30,$B6,$18,$B5,$B6,$48
    db $BC,$18,$B6,$60,$B7,$48,$C7,$00

MusicB1S01P14:
    db $DA,$01,$DB,$0A,$E7,$FA,$24,$6E
    db $B2,$0C,$B0,$30,$AF,$B2,$B7,$18
    db $C6,$B6,$30,$B3,$B4,$B9,$18,$C6
    db $B7,$DA,$03,$DB,$0F,$06,$B6,$AD
    db $B6,$AD,$B6,$AD,$B6,$C7,$B5,$AD
    db $B5,$C7,$B6,$AD,$B6,$C7,$BC,$B2
    db $BC,$B2,$BC,$B2,$BC,$B2,$BC,$B2
    db $BC,$C7,$B6,$AD,$B6,$C7,$B7,$AF
    db $B7,$AF,$B7,$AF,$B7,$AF,$B7,$AF
    db $B7,$AF,$B7,$AF,$B7,$AF,$E8,$30
    db $60,$06,$B7,$AF,$B7,$AF,$B7,$AF
    db $B7,$AF,$C7,$C7,$C7,$C7

MusicB1S01P16:
    db $DA,$01,$DB,$14,$30,$C7,$18,$9F
    db $A3,$A6,$A3,$A3,$A6,$A9,$A6,$A4
    db $A8,$AB,$A8,$A5,$A8,$AB,$A8,$A6
    db $AA,$AD,$AA,$A1,$A6,$AA,$A6,$A3
    db $A6,$A1,$A6,$9F,$C6,$C6

MusicB1S01P15:
    db $DA,$04,$DB,$0A,$DE,$23,$11,$40
    db $30,$6D,$C7,$60,$93,$97,$98,$99
    db $9A,$92,$93,$C6

MusicB1S01P17:
    db $DA,$00,$E0,$DC,$DB,$0A,$DE,$23
    db $12,$40,$18,$6E,$B3,$B4,$B4,$B4
    db $B6,$B7,$C6,$BC,$C6,$DA,$01,$E0
    db $AA,$10,$AF,$B0,$AF,$AD,$AF,$AD
    db $30,$AB,$18,$A6,$00

MusicB1S01P18:
    db $DA,$02,$DB,$05,$E7,$FA,$18,$6E
    db $C7,$06,$98,$9A,$9C,$9D,$9F,$A1
    db $A3,$A4,$A6,$A8,$A9,$AB,$AD,$AF
    db $B0,$C6,$60,$C7,$DA,$01,$DB,$0A
    db $10,$AB,$AD,$AB,$AA,$AB,$AA,$30
    db $A6,$18,$A3

MusicB1S01P1A:
    db $DA,$01,$DB,$0A,$18,$6E,$C7,$48
    db $9F,$18,$9F,$30,$9F,$C7,$60,$9F
    db $9A

MusicB1S01P19:
    db $DA,$01,$DB,$0A,$18,$6E,$C7,$48
    db $98,$18,$98,$30,$98,$C7,$60,$97
    db $93

MusicB1S01P1B:
    db $DA,$00,$E0,$DC,$DB,$0A,$DE,$23
    db $12,$40,$18,$6E,$B3,$B4,$B4,$B4
    db $B6,$B7,$C6,$BC,$C6,$DA,$01,$18
    db $2E,$B2,$B1,$B2,$AD,$A6,$A5,$A6
    db $A1,$E0,$96,$E1,$60,$FA,$60,$5E
    db $A7,$DA,$03,$DB,$0F,$18,$1E,$A6
    db $AD,$B2,$B9,$BE,$C7,$C7,$C7,$DA
    db $01,$DB,$0A,$48,$5D,$A6,$00

MusicB1S01P1C:
    db $DA,$02,$DB,$05,$18,$6E,$C7,$06
    db $98,$9A,$9C,$9D,$9F,$A1,$A3,$A4
    db $A6,$A8,$A9,$AB,$AD,$AF,$B0,$C6
    db $60,$C7,$DA,$01,$DB,$0A,$18,$AD
    db $C7,$C7,$AD,$AD,$C7,$C7,$AD,$9B
    db $C6,$C6,$C6,$DA,$00,$DB,$05,$18
    db $1E,$A6,$AD,$B2,$B9,$BE,$C7,$C7
    db $C7,$DA,$01,$48,$5D,$A1

MusicB1S01P1E:
    db $DA,$01,$DB,$0A,$18,$6E,$C7,$48
    db $9F,$18,$9F,$30,$9F,$C7,$18,$A1
    db $C7,$C7,$C7,$A1,$C7,$C7,$C7,$60
    db $9D,$18,$9E,$C7,$C7,$C7,$C7,$C7
    db $C7,$C7,$48,$5D,$9E

MusicB1S01P1F:
    db $DA,$01,$DB,$14,$18,$6E,$C7,$48
    db $C7,$18,$C7,$30,$C7,$C7,$18,$9E
    db $C7,$C7,$C7,$9E,$C7,$C7,$C7,$60
    db $A4,$18,$A1,$C7,$C7,$C7,$C7,$C7
    db $C7,$C7,$48,$5D,$A4,$00

MusicB1S01P1D:
    db $DA,$01,$DB,$0A,$18,$6E,$C7,$48
    db $98,$18,$98,$30,$98,$C7,$18,$9A
    db $C7,$C7,$C7,$9A,$C7,$C7,$C7,$60
    db $A1,$18,$9A,$C7,$C7,$C7,$C7,$C7
    db $C7,$C7,$48,$6E,$8E,$00


    base off

MusicBank1_End:
    dw $0000,SPCEngine

MusicBank2:
    dw MusicBank2_End-MusicBank2-4
    dw MusicData

    base MusicData

    dw MusicB2S01
    dw MusicB2S02
    dw MusicB2S03
    dw MusicB2S04
    dw MusicB2S05
    dw MusicB2S06
    dw MusicB2S07
    dw MusicB2S08
    dw MusicB2S09
    dw MusicB2S0A
    dw MusicB2S0B
    dw MusicB2S0C
    dw MusicB2S0D
    dw MusicB2S0E
    dw MusicB2S0F
    dw MusicB2S0F
    dw MusicB2S10
    dw MusicB2S11
    dw MusicB2S12
    dw MusicB2S13
    dw MusicB2S14
    dw MusicB2S04
    dw MusicB2S15
    dw MusicB2S16
    dw MusicB2S17
    dw MusicB2S18
    dw MusicB2S19
    dw MusicB2S1A
    dw MusicB2S1B


MusicB2S0B:
    dw MusicB2S0CL00
    dw MusicB2S0BL01
    dw $0000

MusicB2S0BL01:
    dw MusicB2S0BP02
    dw MusicB2S0BP03
    dw MusicB2S0BP04
    dw MusicB2S0BP05
    dw MusicB2S0BP06
    dw MusicB2S0BP07
    dw MusicB2S0BP08
    dw MusicB2S0BP09

MusicB2S05:
    dw MusicB2S05L00
    dw MusicB2S05L01
    dw MusicB2S05L02
    dw MusicB2S05L03
    dw MusicB2S05L04
    dw MusicB2S05L05
    dw MusicB2S05L06
    dw MusicB2S05L07
    dw MusicB2S05L08
    dw MusicB2S05L03
    dw MusicB2S05L04
    dw MusicB2S05L05
    dw MusicB2S05L06
    dw $00FF,MusicB2S05+2
    dw $0000

MusicB2S05L00:
    dw MusicB2S05P00
    dw MusicB2S05P01
    dw MusicB2S05P02
    dw MusicB2S05P03
    dw $0000
    dw MusicB2S05P04
    dw MusicB2S05P05
    dw MusicB2S05P06

MusicB2S05L01:
    dw MusicB2S05P07
    dw $0000
    dw $0000
    dw MusicB2S05P08
    dw $0000
    dw MusicB2S05P09
    dw MusicB2S05P0A
    dw MusicB2S05P0B

MusicB2S05L04:
    dw MusicB2S05P07
    dw MusicB2S05P14
    dw MusicB2S05P15
    dw MusicB2S05P08
    dw $0000
    dw MusicB2S05P09
    dw MusicB2S05P0A
    dw MusicB2S05P0B

MusicB2S05L07:
    dw MusicB2S05P07
    dw MusicB2S05P20
    dw MusicB2S05P21
    dw MusicB2S05P08
    dw $0000
    dw MusicB2S05P09
    dw MusicB2S05P0A
    dw MusicB2S05P0B

MusicB2S05L08:
    dw MusicB2S05P07
    dw MusicB2S05P22
    dw MusicB2S05P23
    dw MusicB2S05P08
    dw $0000
    dw MusicB2S05P09
    dw MusicB2S05P0A
    dw MusicB2S05P0B

MusicB2S05L02:
    dw MusicB2S05P07
    dw MusicB2S05P0C
    dw MusicB2S05P0D
    dw MusicB2S05P08
    dw $0000
    dw MusicB2S05P09
    dw MusicB2S05P0A
    dw MusicB2S05P0B

MusicB2S05Lu00:
    dw MusicB2S05P07
    dw $0000
    dw $0000
    dw MusicB2S05P1E
    dw $0000
    dw MusicB2S05P1F
    dw MusicB2S05P0A
    dw MusicB2S05P0B

MusicB2S05L06:
    dw MusicB2S05P07
    dw MusicB2S05P1C
    dw MusicB2S05P1D
    dw MusicB2S05P1E
    dw $0000
    dw MusicB2S05P1F
    dw MusicB2S05P0A
    dw MusicB2S05P0B

MusicB2S05Lu01:
    dw MusicB2S05P0E
    dw $0000
    dw $0000
    dw MusicB2S05P08
    dw $0000
    dw MusicB2S05P11
    dw MusicB2S05P12
    dw MusicB2S05P13

MusicB2S05L03:
    dw MusicB2S05P0E
    dw MusicB2S05P0F
    dw MusicB2S05P10
    dw MusicB2S05P08
    dw $0000
    dw MusicB2S05P11
    dw MusicB2S05P12
    dw MusicB2S05P13

MusicB2S05Lu02:
    dw MusicB2S05P16
    dw $0000
    dw $0000
    dw MusicB2S05P19
    dw $0000
    dw MusicB2S05P1A
    dw MusicB2S05P1B
    dw MusicB2S05Pu00

MusicB2S05L05:
    dw MusicB2S05P16
    dw MusicB2S05P17
    dw MusicB2S05P18
    dw MusicB2S05P19
    dw $0000
    dw MusicB2S05P1A
    dw MusicB2S05P1B
    dw MusicB2S05P13

MusicB2S08:
    dw MusicB2S08L00
    dw MusicB2S08L01
    dw MusicB2S08L02
    dw MusicB2S08L01
    dw MusicB2S08L02
    dw MusicB2S08L03
    dw MusicB2S08L04
    dw MusicB2S08L05
    dw MusicB2S08L06
    dw MusicB2S08L07
    dw MusicB2S08L06
    dw MusicB2S08L08
    dw MusicB2S08L09
    dw MusicB2S08L07
    dw $00FF,MusicB2S08+$10
    dw $0000

MusicB2S08L00:
    dw MusicB2S08P00
    dw MusicB2S08P01
    dw MusicB2S08P02
    dw MusicB2S08P03
    dw MusicB2S08P04
    dw MusicB2S08P05
    dw MusicB2S08P06
    dw MusicB2S08P07

MusicB2S08L01:
    dw MusicB2S08P08
    dw MusicB2S08P09
    dw $0000
    dw $0000
    dw $0000
    dw MusicB2S08P0A
    dw $0000
    dw $0000

MusicB2S08L02:
    dw MusicB2S08P08
    dw MusicB2S08P09
    dw MusicB2S08P0B
    dw MusicB2S08P0C
    dw $0000
    dw MusicB2S08P0A
    dw $0000
    dw $0000

MusicB2S08L03:
    dw MusicB2S08P0D
    dw MusicB2S08P0E
    dw MusicB2S08P0F
    dw MusicB2S08P10
    dw MusicB2S08P11
    dw MusicB2S08P12
    dw $0000
    dw MusicB2S08P13

MusicB2S08L04:
    dw MusicB2S08P14
    dw MusicB2S08P15
    dw $0000
    dw $0000
    dw $0000
    dw MusicB2S08P16
    dw $0000
    dw $0000

MusicB2S08L05:
    dw MusicB2S08P14
    dw MusicB2S08P15
    dw MusicB2S08P17
    dw $0000
    dw $0000
    dw MusicB2S08P18
    dw $0000
    dw $0000

MusicB2S08L07:
    dw MusicB2S08P14
    dw MusicB2S08P15
    dw MusicB2S08P17
    dw $0000
    dw $0000
    dw MusicB2S08P1B
    dw $0000
    dw $0000

MusicB2S08L06:
    dw MusicB2S08P14
    dw MusicB2S08P15
    dw MusicB2S08P19
    dw MusicB2S08P1A
    dw $0000
    dw MusicB2S08P1B
    dw $0000
    dw $0000

MusicB2S08L08:
    dw MusicB2S08P1C
    dw MusicB2S08P1D
    dw MusicB2S08P1E
    dw MusicB2S08P1F
    dw $0000
    dw MusicB2S08P20
    dw MusicB2S08P21
    dw MusicB2S08P22

MusicB2S08L09:
    dw MusicB2S08P23
    dw MusicB2S08P24
    dw MusicB2S08P25
    dw MusicB2S08P26
    dw $0000
    dw MusicB2S08P27
    dw MusicB2S08P28
    dw MusicB2S08P29

MusicB2S0E:
    dw MusicB2S0EL00
    dw MusicB2S0EL01
    dw MusicB2S0EL01
    dw MusicB2S0EL02
    dw MusicB2S0EL01
    dw MusicB2S0EL03
    dw MusicB2S0EL01
    dw $00FF,MusicB2S0E+$C
    dw $0000

MusicB2S0EL00:
    dw MusicB2S0EP00
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S0EL02:
    dw MusicB2S0EP04
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S0EL03:
    dw MusicB2S0EP05
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S0EL01:
    dw MusicB2S0EP01
    dw MusicB2S0EP02
    dw MusicB2S0EP03
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S0A:
    dw MusicB2S0AL00
    dw MusicB2S0AL01
    dw MusicB2S0AL02
    dw $0000

MusicB2S0AL00:
    dw MusicB2S0AP00
    dw MusicB2S0AP01
    dw MusicB2S0AP02
    dw MusicB2S0AP03
    dw MusicB2S0AP04
    dw MusicB2S0AP05
    dw MusicB2S0AP06
    dw $0000

MusicB2S0AL01:
    dw MusicB2S0AP07
    dw MusicB2S0AP08
    dw MusicB2S0AP09
    dw MusicB2S0AP0A
    dw MusicB2S0AP0B
    dw MusicB2S0AP0C
    dw MusicB2S0AP0D
    dw $0000

MusicB2S0AL02:
    dw MusicB2S0AP0E
    dw MusicB2S0AP0F
    dw MusicB2S0AP10
    dw MusicB2S0AP11
    dw MusicB2S0AP12
    dw MusicB2S0AP13
    dw MusicB2S0AP14
    dw $0000

MusicB2S09:
    dw MusicB2S09L00
    dw $0000

MusicB2S09L00:
    dw $0000
    dw MusicB2S09P00
    dw MusicB2S09P01
    dw MusicB2S09P02
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S0C:
    dw MusicB2S0CL00
    dw MusicB2S0CL01
    dw $0000

MusicB2S0CL00:
    dw $0000
    dw MusicB2S0BP00
    dw MusicB2S0BP01
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S0CL01:
    dw MusicB2S0CP00
    dw MusicB2S0CP01
    dw MusicB2S0CP02
    dw MusicB2S0CP03
    dw $0000
    dw MusicB2S0CP04
    dw $0000
    dw MusicB2S0CP05

MusicB2S01:
    dw MusicB2S01L00
    dw MusicB2S01L01
    dw MusicB2S01L02
    dw MusicB2S01L01
    dw MusicB2S01L03
    dw MusicB2S01L04
    dw MusicB2S01L05
    dw MusicB2S01L04
    dw MusicB2S01L05
    dw MusicB2S01L06
    dw MusicB2S01L07
    dw MusicB2S01L08
    dw $00FF,MusicB2S01+2
    dw $0000

MusicB2S01L00:
    dw MusicB2S01P00
    dw MusicB2S01P01
    dw MusicB2S01P02
    dw MusicB2S01P03
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S01L04:
    dw MusicB2S01P13
    dw MusicB2S01P14
    dw MusicB2S01P15
    dw MusicB2S01P16
    dw $0000
    dw MusicB2S01P08
    dw $0000
    dw $0000

MusicB2S01L05:
    dw MusicB2S01P17
    dw MusicB2S01P18
    dw MusicB2S01P19
    dw MusicB2S01P1A
    dw $0000
    dw MusicB2S01P08
    dw $0000
    dw $0000

MusicB2S01L06:
    dw MusicB2S01P1B
    dw MusicB2S01P1C
    dw MusicB2S01P1D
    dw MusicB2S01P1E
    dw $0000
    dw MusicB2S01P1F
    dw $0000
    dw $0000

MusicB2S01L07:
    dw MusicB2S01P20
    dw MusicB2S01P1C
    dw MusicB2S01P1D
    dw MusicB2S01P1E
    dw $0000
    dw MusicB2S01P1F
    dw $0000
    dw $0000

MusicB2S01L08:
    dw MusicB2S01P21
    dw MusicB2S01P22
    dw MusicB2S01P23
    dw MusicB2S01P24
    dw $0000
    dw MusicB2S01P08
    dw $0000
    dw $0000

MusicB2S01L01:
    dw MusicB2S01P04
    dw MusicB2S01P05
    dw MusicB2S01P06
    dw MusicB2S01P07
    dw $0000
    dw MusicB2S01P08
    dw $0000
    dw $0000

MusicB2S01L02:
    dw MusicB2S01P09
    dw MusicB2S01P0A
    dw MusicB2S01P0B
    dw MusicB2S01P0C
    dw $0000
    dw MusicB2S01P0D
    dw $0000
    dw $0000

MusicB2S01L03:
    dw MusicB2S01P0E
    dw MusicB2S01P0F
    dw MusicB2S01P10
    dw MusicB2S01P11
    dw $0000
    dw MusicB2S01P12
    dw $0000
    dw $0000

MusicB2S03:
    dw MusicB2S03L00
    dw MusicB2S03L01
    dw MusicB2S03L02
    dw MusicB2S03L03
    dw MusicB2S03L04
    dw MusicB2S03L05
    dw MusicB2S03L06
    dw MusicB2S03L07
    dw MusicB2S03L06
    dw MusicB2S03L08
    dw MusicB2S03L05
    dw $00FF,MusicB2S03+2
    dw $0000

MusicB2S03L01:
    dw MusicB2S03P06
    dw MusicB2S03P07
    dw MusicB2S03P08
    dw $0000
    dw $0000
    dw MusicB2S03P09
    dw MusicB2S03P0A
    dw $0000

MusicB2S03L00:
    dw MusicB2S03P00
    dw MusicB2S03P01
    dw MusicB2S03P02
    dw MusicB2S03P03
    dw $0000
    dw $0000
    dw MusicB2S03P04
    dw MusicB2S03P05

MusicB2S03L02:
    dw MusicB2S03P0B
    dw MusicB2S03P0C
    dw MusicB2S03P0D
    dw MusicB2S03P0E
    dw $0000
    dw MusicB2S03P09
    dw MusicB2S03P0F
    dw MusicB2S03P10

MusicB2S03L04:
    dw MusicB2S03P0B
    dw MusicB2S03P18
    dw MusicB2S03P0D
    dw MusicB2S03P0E
    dw MusicB2S03P0C
    dw MusicB2S03P09
    dw MusicB2S03P0F
    dw MusicB2S03P10

MusicB2S03L03:
    dw MusicB2S03P11
    dw MusicB2S03P12
    dw MusicB2S03P13
    dw MusicB2S03P14
    dw $0000
    dw MusicB2S03P15
    dw MusicB2S03P16
    dw MusicB2S03P17

MusicB2S03L05:
    dw MusicB2S03P11
    dw MusicB2S03P19
    dw MusicB2S03P13
    dw MusicB2S03P14
    dw MusicB2S03P12
    dw MusicB2S03P15
    dw MusicB2S03P16
    dw MusicB2S03P1A

MusicB2S03L06:
    dw MusicB2S03P1B
    dw MusicB2S03P1C
    dw MusicB2S03P1D
    dw MusicB2S03P1E
    dw $0000
    dw MusicB2S03P1F
    dw MusicB2S03P20
    dw MusicB2S03P21

MusicB2S03L07:
    dw MusicB2S03P22
    dw MusicB2S03P23
    dw MusicB2S03P24
    dw MusicB2S03P25
    dw $0000
    dw MusicB2S03P1F
    dw MusicB2S03P26
    dw MusicB2S03P27

MusicB2S03L08:
    dw MusicB2S03P28
    dw MusicB2S03P23
    dw MusicB2S03P24
    dw MusicB2S03P29
    dw $0000
    dw MusicB2S03P1F
    dw MusicB2S03P26
    dw MusicB2S03P2A

MusicB2S06:
    dw MusicB2S06L00
    dw MusicB2S06L01
    dw MusicB2S06L02
    dw MusicB2S06L03
    dw MusicB2S06L02
    dw MusicB2S06L03
    dw MusicB2S06L02
    dw MusicB2S06L04
    dw MusicB2S06L04
    dw $00FF,MusicB2S06+4
    dw $0000

MusicB2S06L00:
    dw MusicB2S06P00
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S06L01:
    dw MusicB2S06P01
    dw $0000
    dw $0000
    dw MusicB2S06P02
    dw $0000
    dw MusicB2S06P03
    dw $0000
    dw $0000

MusicB2S06L02:
    dw MusicB2S06P04
    dw $0000
    dw $0000
    dw MusicB2S06P02
    dw $0000
    dw MusicB2S06P03
    dw $0000
    dw $0000

MusicB2S06L03:
    dw MusicB2S06P04
    dw MusicB2S06P05
    dw MusicB2S06P06
    dw MusicB2S06P02
    dw $0000
    dw MusicB2S06P03
    dw $0000
    dw $0000

MusicB2S06L04:
    dw MusicB2S06P07
    dw MusicB2S06P08
    dw MusicB2S06P09
    dw MusicB2S06P02
    dw $0000
    dw MusicB2S06P03
    dw $0000
    dw $0000

MusicB2S07:
    dw MusicB2S07L00
    dw MusicB2S07L01
    dw MusicB2S07L02
    dw MusicB2S07L03
    dw MusicB2S07L04
    dw MusicB2S07L05
    dw MusicB2S07L06
    dw MusicB2S07L03
    dw MusicB2S07L07
    dw MusicB2S07L08
    dw MusicB2S07L02
    dw MusicB2S07L09
    dw MusicB2S07L0A
    dw $00FF,MusicB2S07
    dw $0000

MusicB2S07L00:
    dw MusicB2S07P00
    dw MusicB2S07P01
    dw MusicB2S07P02
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S07L01:
    dw MusicB2S07P00
    dw MusicB2S07P01
    dw MusicB2S07P02
    dw MusicB2S07P03
    dw $0000
    dw MusicB2S07P04
    dw $0000
    dw $0000

MusicB2S07L05:
    dw MusicB2S07P14
    dw MusicB2S07P15
    dw MusicB2S07P16
    dw MusicB2S07P17
    dw $0000
    dw MusicB2S07P18
    dw MusicB2S07P19
    dw $0000

MusicB2S07L07:
    dw MusicB2S07P1A
    dw MusicB2S07P1B
    dw MusicB2S07P1A
    dw MusicB2S07P1C
    dw $0000
    dw MusicB2S07P1D
    dw MusicB2S07P1E
    dw $0000

MusicB2S07L09:
    dw MusicB2S07P1F
    dw MusicB2S07P20
    dw MusicB2S07P1F
    dw MusicB2S07P21
    dw $0000
    dw MusicB2S07P22
    dw MusicB2S07P23
    dw $0000

MusicB2S07L02:
    dw MusicB2S07P05
    dw MusicB2S07P06
    dw MusicB2S07P07
    dw MusicB2S07P08
    dw $0000
    dw MusicB2S07P09
    dw $0000
    dw $0000

MusicB2S07L0A:
    dw MusicB2S07P05
    dw MusicB2S07P06
    dw MusicB2S07P07
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S07L03:
    dw MusicB2S07P0A
    dw MusicB2S07P0B
    dw MusicB2S07P0C
    dw MusicB2S07P0D
    dw $0000
    dw MusicB2S07P0E
    dw $0000
    dw $0000

MusicB2S07L08:
    dw MusicB2S07P0A
    dw MusicB2S07P0B
    dw MusicB2S07P0C
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S07L04:
    dw MusicB2S07P0F
    dw MusicB2S07P10
    dw MusicB2S07P11
    dw MusicB2S07P12
    dw $0000
    dw MusicB2S07P13
    dw $0000
    dw $0000

MusicB2S07L06:
    dw MusicB2S07P0F
    dw MusicB2S07P10
    dw MusicB2S07P11
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S02:
    dw MusicB2S02L00
    dw MusicB2S02L01
    dw MusicB2S02L02
    dw MusicB2S02L03
    dw MusicB2S02L02
    dw MusicB2S02L03
    dw MusicB2S02L04
    dw MusicB2S02L05
    dw MusicB2S02L06
    dw MusicB2S02L07
    dw MusicB2S02L08
    dw $00FF,MusicB2S02+2
    dw $0000

MusicB2S02L01:
    dw MusicB2S02P08
    dw MusicB2S02P09
    dw MusicB2S02P0A
    dw MusicB2S02P0B
    dw MusicB2S02P0B
    dw MusicB2S02P0C
    dw MusicB2S02P0B
    dw MusicB2S02P0D

MusicB2S02L00:
    dw MusicB2S02P00
    dw MusicB2S02P01
    dw MusicB2S02P02
    dw MusicB2S02P03
    dw MusicB2S02P04
    dw MusicB2S02P05
    dw MusicB2S02P06
    dw MusicB2S02P07

MusicB2S02L02:
    dw MusicB2S02P0E
    dw MusicB2S02P0F
    dw MusicB2S02P10
    dw MusicB2S02P11
    dw $0000
    dw MusicB2S02P0C
    dw $0000
    dw MusicB2S02P12

MusicB2S02L03:
    dw MusicB2S02P13
    dw MusicB2S02P14
    dw MusicB2S02P15
    dw MusicB2S02P16
    dw $0000
    dw MusicB2S02P0C
    dw $0000
    dw MusicB2S02P17

MusicB2S02L04:
    dw MusicB2S02P18
    dw MusicB2S02P19
    dw MusicB2S02P1A
    dw MusicB2S02P1B
    dw $0000
    dw MusicB2S02P1C
    dw $0000
    dw MusicB2S02P1D

MusicB2S02L05:
    dw MusicB2S02P1E
    dw MusicB2S02P1F
    dw MusicB2S02P20
    dw MusicB2S02P21
    dw $0000
    dw MusicB2S02P1C
    dw $0000
    dw MusicB2S02P22

MusicB2S02L07:
    dw MusicB2S02P28
    dw MusicB2S02P29
    dw MusicB2S02P2A
    dw MusicB2S02P2B
    dw $0000
    dw MusicB2S02P2C
    dw $0000
    dw MusicB2S02P28

MusicB2S02L08:
    dw MusicB2S02P28
    dw MusicB2S02P2D
    dw MusicB2S02P2E
    dw MusicB2S02P2F
    dw $0000
    dw MusicB2S02P2C
    dw $0000
    dw MusicB2S02P28

MusicB2S02L06:
    dw MusicB2S02P23
    dw MusicB2S02P24
    dw MusicB2S02P25
    dw MusicB2S02P26
    dw $0000
    dw MusicB2S02P0C
    dw $0000
    dw MusicB2S02P27

MusicB2S0D:
    dw MusicB2S0DL00
    dw $00FF,MusicB2S0D
    dw $0000

MusicB2S0DL00:
    dw MusicB2S0DP00
    dw MusicB2S0DP01
    dw MusicB2S0DP02
    dw MusicB2S0DP03
    dw $0000
    dw MusicB2S0DP04
    dw $0000
    dw $0000

MusicB2S0F:
    dw MusicB2S10L00
    dw $0000

MusicB2S10L00:
    dw MusicB2S0FP00
    dw MusicB2S0FP01
    dw MusicB2S0FP02
    dw MusicB2S0FP03
    dw MusicB2S0FP04
    dw MusicB2S0FP05
    dw MusicB2S0FP06
    dw MusicB2S0FP07

MusicB2S10:
    dw MusicB2S11L00
    dw $0000

MusicB2S11L00:
    dw MusicB2S11P00
    dw MusicB2S11P01
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S11:
    dw MusicB2S12L00
    dw MusicB2S12L01
    dw MusicB2S12L02
    dw MusicB2S12L03
    dw MusicB2S12L02
    dw MusicB2S12L03
    dw MusicB2S12L04
    dw MusicB2S12L05
    dw MusicB2S12L02
    dw MusicB2S12L03
    dw $00FF,MusicB2S11+2
    dw $0000

MusicB2S12L00:
    dw MusicB2S12P00
    dw MusicB2S12P01
    dw MusicB2S12P02
    dw MusicB2S12P03
    dw $0000
    dw MusicB2S12P04
    dw $0000
    dw $0000

MusicB2S12L01:
    dw $0000
    dw MusicB2S12P05
    dw MusicB2S12P06
    dw MusicB2S12P07
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S12L02:
    dw MusicB2S12P08
    dw MusicB2S12P09
    dw MusicB2S12P0A
    dw MusicB2S12P07
    dw $0000
    dw MusicB2S12P0B
    dw $0000
    dw MusicB2S12P0C

MusicB2S12L03:
    dw MusicB2S12P0D
    dw MusicB2S12P0E
    dw MusicB2S12P0F
    dw MusicB2S12P07
    dw $0000
    dw MusicB2S12P10
    dw $0000
    dw MusicB2S12P11

MusicB2S12L04:
    dw MusicB2S12P12
    dw MusicB2S12P13
    dw MusicB2S12P14
    dw MusicB2S12P07
    dw $0000
    dw $0000
    dw $0000
    dw MusicB2S12P15

MusicB2S12L05:
    dw MusicB2S12P16
    dw MusicB2S12P13
    dw MusicB2S12P14
    dw MusicB2S12P07
    dw $0000
    dw $0000
    dw $0000
    dw MusicB2S12P15

MusicB2S13:
    dw MusicB2S14L00
    dw $0000

MusicB2S14L00:
    dw MusicB2S14P00
    dw MusicB2S14P01
    dw MusicB2S14P02
    dw MusicB2S14P03
    dw $0000
    dw MusicB2S14P04
    dw MusicB2S14P05
    dw MusicB2S14P06

MusicB2S14:
    dw MusicB2S15L00
    dw $0000

MusicB2S15L00:
    dw MusicB2S15P00
    dw MusicB2S15P01
    dw MusicB2S15P02
    dw MusicB2S15P03
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S12:
    dw MusicB2S13L00
    dw MusicB2S13L01
    dw $0000

MusicB2S13L00:
    dw MusicB2S13P00
    dw MusicB2S13P01
    dw MusicB2S13P02
    dw MusicB2S13P03
    dw MusicB2S13P04
    dw MusicB2S13P05
    dw MusicB2S13P06
    dw MusicB2S13P07

MusicB2S13L01:
    dw MusicB2S13P08
    dw MusicB2S13P09
    dw MusicB2S13P0A
    dw MusicB2S13P0B
    dw MusicB2S13P0C
    dw MusicB2S13P0D
    dw MusicB2S13P0E
    dw MusicB2S13P0F

MusicB2S1B:
    dw MusicB2S1DL00
    dw $0000

MusicB2S04:
    dw MusicB2S1DL00
    dw MusicB2S16L01
    dw MusicB2S1AL01
    dw MusicB2S1AL02
    dw MusicB2S1AL01
    dw MusicB2S1AL03
    dw MusicB2S1AL04
    dw MusicB2S1AL05
    dw MusicB2S1AL04
    dw MusicB2S1AL06
    dw MusicB2S1AL07
    dw MusicB2S1AL08
    dw MusicB2S1AL07
    dw MusicB2S1AL08
    dw MusicB2S1AL09
    dw $00FF,MusicB2S04+6

MusicB2S1DL00:
    dw MusicB2S04P00
    dw MusicB2S04P01
    dw MusicB2S04P02
    dw MusicB2S04P03
    dw MusicB2S04P04
    dw MusicB2S04P05
    dw $0000
    dw MusicB2S04P06

MusicB2S16L01:
    dw MusicB2S04P07
    dw MusicB2S04P08
    dw MusicB2S04P09
    dw MusicB2S04P0A
    dw MusicB2S04P0B
    dw MusicB2S04P0C
    dw $0000
    dw $0000

MusicB2S1AL09:
    dw MusicB2S04P0D
    dw MusicB2S04P0E
    dw MusicB2S04P25
    dw MusicB2S04P0F
    dw MusicB2S04P10
    dw MusicB2S04P11
    dw MusicB2S04P26
    dw MusicB2S04P12

MusicB2S1AL01:
    dw MusicB2S04P0D
    dw MusicB2S04P0E
    dw $0000
    dw MusicB2S04P0F
    dw MusicB2S04P10
    dw MusicB2S04P11
    dw $0000
    dw MusicB2S04P12

MusicB2S1AL02:
    dw MusicB2S04P0D
    dw MusicB2S04P0E
    dw $0000
    dw MusicB2S04P0F
    dw MusicB2S04P13
    dw MusicB2S04P11
    dw $0000
    dw MusicB2S04P12

MusicB2S1AL03:
    dw MusicB2S04P0D
    dw MusicB2S04P0E
    dw $0000
    dw MusicB2S04P0F
    dw MusicB2S04P13
    dw MusicB2S04P14
    dw $0000
    dw MusicB2S04P12

MusicB2S1AL04:
    dw MusicB2S04P0D
    dw MusicB2S04P0E
    dw MusicB2S04P15
    dw MusicB2S04P0F
    dw MusicB2S04P10
    dw MusicB2S04P11
    dw MusicB2S04P16
    dw MusicB2S04P12

MusicB2S1AL05:
    dw MusicB2S04P0D
    dw MusicB2S04P0E
    dw MusicB2S04P17
    dw MusicB2S04P0F
    dw MusicB2S04P13
    dw MusicB2S04P11
    dw MusicB2S04P18
    dw MusicB2S04P12

MusicB2S1AL06:
    dw MusicB2S04P0D
    dw MusicB2S04P0E
    dw MusicB2S04P17
    dw MusicB2S04P0F
    dw MusicB2S04P13
    dw MusicB2S04P14
    dw MusicB2S04P18
    dw MusicB2S04P12

MusicB2S1AL07:
    dw MusicB2S04P19
    dw MusicB2S04P1A
    dw MusicB2S04P1B
    dw MusicB2S04P1C
    dw $0000
    dw MusicB2S04P1D
    dw MusicB2S04P1E
    dw MusicB2S04P1F

MusicB2S1AL08:
    dw MusicB2S04P20
    dw MusicB2S04P21
    dw MusicB2S04P22
    dw MusicB2S04P1C
    dw $0000
    dw MusicB2S04P1D
    dw MusicB2S04P23
    dw MusicB2S04P24

MusicB2S17:
    dw MusicB2S19L00
    dw MusicB2S1AL01
    dw MusicB2S1AL02
    dw MusicB2S1AL01
    dw MusicB2S1AL03
    dw MusicB2S1AL04
    dw MusicB2S1AL05
    dw MusicB2S1AL04
    dw MusicB2S1AL06
    dw MusicB2S1AL07
    dw MusicB2S1AL08
    dw MusicB2S1AL07
    dw MusicB2S1AL08
    dw MusicB2S1AL09
    dw $00FF,MusicB2S17+4

MusicB2S19L00:
    dw MusicB2S19P00
    dw MusicB2S19P01
    dw MusicB2S19P02
    dw MusicB2S19P03
    dw MusicB2S19P04
    dw MusicB2S19P05
    dw $0000
    dw $0000

MusicB2S18:
    dw MusicB2S1AL00
    dw MusicB2S1AL01
    dw MusicB2S1AL02
    dw MusicB2S1AL01
    dw MusicB2S1AL03
    dw MusicB2S1AL04
    dw MusicB2S1AL05
    dw MusicB2S1AL04
    dw MusicB2S1AL06
    dw MusicB2S1AL07
    dw MusicB2S1AL08
    dw MusicB2S1AL07
    dw MusicB2S1AL08
    dw MusicB2S1AL09
    dw $00FF,MusicB2S18+4

MusicB2S1AL00:
    dw MusicB2S1AP00
    dw MusicB2S19P01
    dw MusicB2S19P02
    dw MusicB2S19P03
    dw MusicB2S19P04
    dw MusicB2S19P05
    dw $0000
    dw $0000

MusicB2S15:
    dw MusicB2S1BL02
    dw MusicB2S17L01
    dw $0000

MusicB2S1BL02:
    dw MusicB2S17P00
    dw MusicB2S17P01
    dw MusicB2S17P02
    dw MusicB2S17P03
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S17L01:
    dw MusicB2S17P04
    dw MusicB2S17P05
    dw MusicB2S17P06
    dw MusicB2S17P07
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S16:
    dw MusicB2S18L00
    dw $0000

MusicB2S18L00:
    dw MusicB2S18P00
    dw MusicB2S18P01
    dw MusicB2S18P02
    dw MusicB2S18P03
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S19:
    dw MusicB2S1BL00
    dw MusicB2S1BL01
    dw MusicB2S1BL02
    dw $0000

MusicB2S1BL00:
    dw MusicB2S1BP00
    dw MusicB2S1BP01
    dw MusicB2S1BP02
    dw MusicB2S1BP03
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S1BL01:
    dw MusicB2S1BP04
    dw MusicB2S1BP05
    dw MusicB2S1BP06
    dw MusicB2S1BP07
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S1A:
    dw MusicB2S1CL00
    dw MusicB2S1CL01
    dw $0000

MusicB2S1CL00:
    dw MusicB2S1CP00
    dw MusicB2S1CP01
    dw MusicB2S1CP02
    dw $0000
    dw $0000
    dw $0000
    dw $0000
    dw $0000

MusicB2S1CL01:
    dw MusicB2S1CP03
    dw MusicB2S1CP04
    dw MusicB2S1CP05
    dw MusicB2S1CP06
    dw MusicB2S1CP07
    dw MusicB2S1CP08
    dw $0000
    dw $0000

MusicB2S1CP00:
    db $DA,$12,$E2,$14,$DE,$14,$14,$20
    db $DB,$0A,$0C,$6D,$AA,$0C,$3D,$AD
    db $0C,$6D,$A8,$0C,$3D,$AD,$0C,$6D
    db $A6,$0C,$3D,$AD,$18,$6D,$B2,$60
    db $B9,$C6,$00

MusicB2S1CP01:
    db $DA,$12,$DB,$0A,$06,$C7,$0C,$6B
    db $AA,$0C,$3B,$AD,$0C,$6B,$A8,$0C
    db $3B,$AD,$0C,$6B,$A6,$0C,$3B,$AD
    db $18,$6B,$B2,$42,$B9,$DA,$00,$08
    db $4B,$B9,$B2,$B2,$B9,$B9,$BE,$48
    db $BE

MusicB2S1CP02:
    db $DA,$12,$DE,$14,$14,$20,$DB,$0A
    db $18,$5D,$9A,$99,$98,$97,$60,$96
    db $C6

MusicB2S1CP03:
    db $DA,$12,$E2,$23,$DE,$14,$14,$20
    db $DB,$0A,$18,$6D,$A6,$A8,$48,$6D
    db $AB,$0C,$3D,$A8,$AB,$48,$6D,$AF
    db $0C,$3D,$AB,$AF,$18,$6E,$B2,$0C
    db $3E,$AF,$B2,$18,$6E,$B4,$0C,$3E
    db $B2,$B4,$30,$6F,$B7,$BB,$60,$BE
    db $C6,$00

MusicB2S1CP08:
    db $DA,$12,$DE,$14,$14,$20,$DB,$0A
    db $06,$C7,$18,$6B,$A6,$A8,$48,$6B
    db $AB,$0C,$3B,$A8,$AB,$48,$6B,$AF
    db $0C,$3B,$AB,$AF,$18,$6B,$B2,$0C
    db $3B,$AF,$B2,$18,$6B,$B4,$0C,$3B
    db $B2,$B4,$30,$6C,$B7,$BB,$60,$BE
    db $C6

MusicB2S1CP04:
    db $DA,$12,$DE,$14,$14,$20,$DB,$0F
    db $30,$C7,$48,$6D,$A8,$18,$C6,$48
    db $AB,$18,$C6,$AF,$C6,$B0,$C6,$30
    db $B4,$B7,$60,$BB,$C6

MusicB2S1CP06:
    db $DA,$12,$DE,$14,$14,$20,$DB,$05
    db $30,$C7,$48,$6D,$A4,$18,$C6,$48
    db $A8,$18,$C6,$AB,$C6,$AD,$C6,$30
    db $B0,$B4,$60,$B6,$C6

MusicB2S1CP07:
    db $DA,$12,$DE,$14,$14,$20,$DB,$0A
    db $30,$C7,$48,$6D,$A1,$18,$C6,$48
    db $A4,$18,$C6,$A8,$C6,$AB,$C6,$30
    db $AD,$B0,$60,$B2,$C6

MusicB2S1CP05:
    db $DA,$12,$DE,$14,$14,$20,$DB,$0A
    db $30,$C7,$48,$6D,$8E,$18,$C6,$48
    db $8E,$18,$C6,$8E,$C6,$8E,$C6,$30
    db $8E,$8E,$60,$93,$C6

MusicB2S1BP00:
    db $DA,$11,$E2,$32,$DB,$14,$0C,$7F
    db $A8,$DD,$00,$0C,$A3,$0C,$7E,$A8
    db $DD,$00,$0C,$A3,$0C,$7D,$A8,$DD
    db $00,$0C,$A3,$0C,$7C,$A8,$DD,$00
    db $0C,$A3,$0C,$7F,$A8,$DD,$00,$0C
    db $A3,$0C,$7E,$A8,$DD,$00,$0C,$A3
    db $0C,$7D,$A8,$DD,$00,$0C,$A3,$0C
    db $7C,$A8,$DD,$00,$0C,$A3,$18,$7F
    db $A8,$DD,$00,$18,$A3,$18,$7E,$A4
    db $DD,$00,$18,$9F,$60,$7E,$A8,$DD
    db $00,$60,$AB,$60,$C7,$00

MusicB2S1BP01:
    db $DA,$11,$DB,$0A,$03,$C7,$0C,$7F
    db $A2,$DD,$00,$0C,$9E,$0C,$7E,$A2
    db $DD,$00,$0C,$9E,$0C,$7D,$A2,$DD
    db $00,$0C,$9E,$0C,$7C,$A2,$DD,$00
    db $0C,$9E,$0C,$7F,$A2,$DD,$00,$0C
    db $9E,$0C,$7E,$A2,$DD,$00,$0C,$9E
    db $0C,$7D,$A2,$DD,$00,$0C,$9E,$0C
    db $7C,$A2,$DD,$00,$0C,$9E,$18,$7F
    db $A2,$DD,$00,$18,$9D,$18,$7E,$9F
    db $DD,$00,$18,$9A,$60,$7E,$A2,$DD
    db $00,$60,$A5,$60,$C7

MusicB2S1BP02:
    db $DA,$11,$DB,$05,$06,$C7,$0C,$7F
    db $9D,$DD,$00,$0C,$99,$0C,$7E,$9D
    db $DD,$00,$0C,$99,$0C,$7D,$9D,$DD
    db $00,$0C,$99,$0C,$7C,$9D,$DD,$00
    db $0C,$99,$0C,$7F,$9D,$DD,$00,$0C
    db $99,$0C,$7E,$9D,$DD,$00,$0C,$99
    db $0C,$7D,$9D,$DD,$00,$0C,$99,$0C
    db $7C,$9D,$DD,$00,$0C,$99,$18,$7F
    db $9D,$DD,$00,$18,$97,$18,$7E,$9A
    db $DD,$00,$18,$95,$60,$7E,$9D,$DD
    db $00,$60,$A2,$60,$C7

MusicB2S1BP03:
    db $DA,$11,$DB,$0A,$06,$7E,$D0,$06
    db $7D,$D0,$06,$7C,$D0,$06,$7B,$D0
    db $18,$79,$D0,$06,$7E,$D0,$06,$7D
    db $D0,$06,$7C,$D0,$06,$7B,$D0,$18
    db $79,$D0,$30,$C6,$60,$7E,$98,$DD
    db $00,$60,$9C,$60,$C7

MusicB2S1BP04:
    db $DA,$11,$E2,$19,$E0,$FF,$E1,$60
    db $C8,$DB,$14,$18,$7F,$9A,$DD,$00
    db $0C,$A1,$DD,$00,$0C,$98,$18,$7F
    db $9D,$DD,$00,$0C,$A4,$DD,$00,$0C
    db $9C,$18,$7F,$A1,$DD,$00,$0C,$A8
    db $DD,$00,$0C,$9F,$18,$7E,$A4,$DD
    db $00,$0C,$AB,$DD,$00,$0C,$A3,$00

MusicB2S1BP05:
    db $DA,$11,$DB,$00,$06,$C7,$18,$7F
    db $9A,$DD,$00,$0C,$A1,$DD,$00,$0C
    db $98,$18,$7F,$9D,$DD,$00,$0C,$A4
    db $DD,$00,$0C,$9C,$18,$7F,$A1,$DD
    db $00,$0C,$A8,$DD,$00,$0C,$9F,$18
    db $7E,$A4,$DD,$00,$0C,$AB,$DD,$00
    db $0C,$A3

MusicB2S1BP06:
    db $DA,$11,$DB,$0F,$0C,$C7,$18,$7F
    db $91,$DD,$00,$0C,$9A,$DD,$00,$0C
    db $90,$18,$7F,$95,$DD,$00,$0C,$9D
    db $DD,$00,$0C,$93,$18,$7F,$98,$DD
    db $00,$0C,$9F,$DD,$00,$0C,$97,$18
    db $7E,$9D,$DD,$00,$0C,$A3,$DD,$00
    db $0C,$9A

MusicB2S1BP07:
    db $DA,$11,$DB,$05,$12,$C7,$18,$7F
    db $91,$DD,$00,$0C,$9A,$DD,$00,$0C
    db $90,$18,$7F,$95,$DD,$00,$0C,$9D
    db $DD,$00,$0C,$93,$18,$7F,$98,$DD
    db $00,$0C,$9F,$DD,$00,$0C,$97,$18
    db $7E,$9D,$DD,$00,$18,$A3,$DD,$00
    db $18,$9A

MusicB2S17P00:
    db $DA,$11,$E2,$19,$E0,$C8,$E1,$60
    db $64,$DB,$14,$DC,$30,$0A,$18,$7E
    db $A8,$DD,$00,$0C,$AF,$DD,$00,$0C
    db $A6,$18,$7D,$AB,$DD,$00,$0C,$B0
    db $DD,$00,$0C,$A8,$18,$7C,$AF,$DD
    db $00,$0C,$B5,$DD,$00,$0C,$AD,$18
    db $7B,$B2,$DD,$00,$0C,$B9,$DD,$00
    db $0C,$B0,$00

MusicB2S17P01:
    db $DA,$11,$DB,$00,$DC,$30,$0A,$06
    db $C7,$18,$7E,$A8,$DD,$00,$0C,$AF
    db $DD,$00,$0C,$A6,$18,$7D,$AB,$DD
    db $00,$0C,$B0,$DD,$00,$0C,$A8,$18
    db $7C,$AF,$DD,$00,$0C,$B5,$DD,$00
    db $0C,$AD,$18,$7B,$B2,$DD,$00,$0C
    db $B9,$DD,$00,$0C,$B0

MusicB2S17P02:
    db $DA,$11,$DB,$0F,$DC,$30,$0A,$0C
    db $C7,$18,$7E,$9F,$DD,$00,$0C,$A6
    db $DD,$00,$0C,$9D,$18,$7D,$A3,$DD
    db $00,$0C,$A9,$DD,$00,$0C,$A1,$18
    db $7C,$A6,$DD,$00,$0C,$AB,$DD,$00
    db $0C,$A4,$18,$7B,$A9,$DD,$00,$0C
    db $AF,$DD,$00,$0C,$A8

MusicB2S17P03:
    db $DA,$11,$DB,$05,$DC,$30,$0A,$12
    db $C7,$18,$7E,$9F,$DD,$00,$0C,$A6
    db $DD,$00,$0C,$9D,$18,$7D,$A3,$DD
    db $00,$0C,$A9,$DD,$00,$0C,$A1,$18
    db $7C,$A6,$DD,$00,$0C,$AB,$DD,$00
    db $0C,$A4,$18,$7B,$A9,$DD,$00,$0C
    db $AF,$DD,$00,$0C,$A8

MusicB2S17P04:
    db $DA,$11,$E0,$64,$E1,$60,$FF,$DB
    db $0A,$DC,$60,$14,$18,$7B,$B2,$DD
    db $00,$0C,$B9,$DD,$00,$0C,$B0,$18
    db $7B,$AF,$DD,$00,$0C,$B5,$DD,$00
    db $0C,$AD,$18,$7C,$AB,$DD,$00,$0C
    db $B0,$DD,$00,$0C,$A8,$18,$7C,$A8
    db $DD,$00,$0C,$AF,$DD,$00,$0C,$B2
    db $18,$7D,$A4,$DD,$00,$0C,$AB,$DD
    db $00,$0C,$AF,$18,$7E,$A1,$DD,$00
    db $0C,$A8,$DD,$00,$0C,$9F,$2A,$7F
    db $9D,$DD,$00,$0C,$A4,$DD,$00,$1E
    db $9C,$00

MusicB2S17P05:
    db $DB,$0A,$DC,$60,$00,$06,$C7,$18
    db $7B,$B2,$DD,$00,$0C,$B9,$DD,$00
    db $0C,$B0,$18,$7B,$AF,$DD,$00,$0C
    db $B5,$DD,$00,$0C,$AD,$18,$7C,$AB
    db $DD,$00,$0C,$B0,$DD,$00,$0C,$A8
    db $18,$7C,$A8,$DD,$00,$0C,$AF,$DD
    db $00,$0C,$B2,$18,$7D,$A4,$DD,$00
    db $0C,$AB,$DD,$00,$0C,$AF,$18,$7E
    db $A1,$DD,$00,$0C,$A8,$DD,$00,$0C
    db $9F,$24,$7F,$9D,$DD,$00,$0C,$A4
    db $DD,$00,$18,$9C

MusicB2S17P06:
    db $DB,$0A,$DC,$60,$0F,$0C,$C7,$18
    db $7B,$A9,$DD,$00,$0C,$AD,$DD,$00
    db $0C,$9C,$18,$7B,$A6,$DD,$00,$0C
    db $AB,$DD,$00,$0C,$A4,$18,$7C,$A3
    db $DD,$00,$0C,$A9,$DD,$00,$0C,$A1
    db $18,$7C,$9F,$DD,$00,$0C,$A6,$DD
    db $00,$0C,$9D,$18,$7D,$9C,$DD,$00
    db $0C,$A3,$DD,$00,$0C,$9A,$18,$7E
    db $98,$DD,$00,$0C,$A1,$DD,$00,$0C
    db $97,$1E,$7F,$95,$DD,$00,$0C,$9D
    db $DD,$00,$12,$93

MusicB2S17P07:
    db $DB,$0A,$DC,$60,$05,$12,$C7,$18
    db $7B,$A9,$DD,$00,$0C,$AD,$DD,$00
    db $0C,$9C,$18,$7B,$A6,$DD,$00,$0C
    db $AB,$DD,$00,$0C,$A4,$18,$7C,$A3
    db $DD,$00,$0C,$A9,$DD,$00,$0C,$A1
    db $18,$7C,$9F,$DD,$00,$0C,$A6,$DD
    db $00,$0C,$9D,$18,$7D,$9C,$DD,$00
    db $0C,$A3,$DD,$00,$0C,$9A,$18,$7E
    db $98,$DD,$00,$0C,$A1,$DD,$00,$0C
    db $97,$18,$7F,$95,$DD,$00,$0C,$9D
    db $DD,$00,$0C,$93

MusicB2S18P00:
    db $DA,$11,$E2,$19,$E0,$FF,$E1,$60
    db $C8,$DB,$14,$DC,$60,$0A,$18,$7F
    db $A8,$DD,$00,$0C,$AF,$DD,$00,$0C
    db $B2,$18,$7E,$A4,$DD,$00,$0C,$AB
    db $DD,$00,$0C,$AF,$18,$7D,$A1,$DD
    db $00,$0C,$A8,$DD,$00,$0C,$9F,$2A
    db $7C,$9D,$DD,$00,$0C,$A4,$DD,$00
    db $1E,$9C,$00

MusicB2S18P01:
    db $DA,$11,$DB,$00,$DC,$60,$0A,$06
    db $C7,$18,$7F,$A8,$DD,$00,$0C,$AF
    db $DD,$00,$0C,$B2,$18,$7E,$A4,$DD
    db $00,$0C,$AB,$DD,$00,$0C,$AF,$18
    db $7D,$A1,$DD,$00,$0C,$A8,$DD,$00
    db $0C,$9F,$24,$7C,$9D,$DD,$00,$0C
    db $A4,$DD,$00,$18,$9C

MusicB2S18P02:
    db $DA,$11,$DB,$0F,$DC,$60,$0A,$0C
    db $C7,$18,$7F,$9F,$DD,$00,$0C,$A6
    db $DD,$00,$0C,$9D,$18,$7E,$9C,$DD
    db $00,$0C,$A3,$DD,$00,$0C,$9A,$18
    db $7D,$98,$DD,$00,$0C,$A1,$DD,$00
    db $0C,$97,$1E,$7C,$95,$DD,$00,$0C
    db $9D,$DD,$00,$12,$93

MusicB2S18P03:
    db $DA,$11,$DB,$05,$DC,$60,$0A,$12
    db $C7,$18,$7F,$9F,$DD,$00,$0C,$A6
    db $DD,$00,$0C,$9D,$18,$7E,$9C,$DD
    db $00,$0C,$A3,$DD,$00,$0C,$9A,$18
    db $7D,$98,$DD,$00,$0C,$A1,$DD,$00
    db $0C,$97,$18,$7C,$95,$DD,$00,$0C
    db $9D,$DD,$00,$0C,$93

MusicB2S19P00:
    db $DA,$04,$E2,$28,$DB,$0A,$48,$7E
    db $A3,$C6,$DD,$0C,$60,$97,$E2,$41
    db $00

MusicB2S1AP00:
    db $DA,$04,$E2,$32,$DB,$0A,$48,$7E
    db $A3,$C6,$DD,$0C,$60,$97,$E2,$46
    db $00

MusicB2S19P01:
    db $DA,$04,$DB,$14,$48,$7E,$A8,$C6
    db $DD,$0C,$60,$97

MusicB2S19P02:
    db $DA,$04,$DB,$0F,$48,$7E,$AD,$C6
    db $DD,$0C,$60,$97

MusicB2S19P03:
    db $DA,$04,$DB,$05,$48,$7E,$B2,$C6
    db $DD,$0C,$60,$97

MusicB2S19P04:
    db $DA,$04,$DB,$00,$48,$7E,$B7,$C6
    db $DD,$0C,$60,$97

MusicB2S19P05:
    db $DA,$04,$DB,$0A,$48,$7E,$BB,$C6
    db $DD,$0C,$60,$97

MusicB2S04P00:
    db $DA,$04,$E2,$0D,$E3,$FF,$1E,$DB
    db $14,$18,$7D,$84,$8A,$89,$88,$82
    db $83,$18,$7E,$84,$8A,$89,$88,$82
    db $83,$18,$7F,$84,$8A,$89,$88,$C7
    db $C7,$00

MusicB2S04P01:
    db $DA,$04,$DB,$0A,$18,$7D,$90,$96
    db $95,$94,$8E,$8F,$18,$7E,$90,$96
    db $95,$94,$8E,$8F,$18,$7F,$90,$96
    db $95,$94,$C7,$C7

MusicB2S04P02:
    db $DA,$04,$DB,$00,$18,$7D,$8B,$91
    db $90,$8F,$89,$8A,$18,$7E,$8B,$91
    db $90,$8F,$89,$8A,$18,$7F,$8B,$91
    db $90,$8F,$C7,$C7

MusicB2S04P03:
    db $DA,$04,$DB,$0F,$60,$7D,$C7,$30
    db $C7,$18,$7E,$97,$9D,$9C,$9B,$95
    db $96,$18,$7F,$97,$9D,$9C,$9B,$C7
    db $C7

MusicB2S04P04:
    db $DA,$04,$DB,$0A,$60,$C7,$C7,$C7
    db $18,$7F,$9C,$A2,$A1,$A0,$C7,$C7

MusicB2S04P05:
    db $DA,$04,$DB,$0A,$06,$C7,$18,$79
    db $90,$96,$95,$94,$8E,$8F,$18,$7B
    db $97,$9D,$9C,$9B,$95,$96,$18,$7C
    db $9C,$A2,$A1,$12,$A0,$18,$C7,$C7

MusicB2S04P06:
    db $DA,$04,$DB,$0A,$18,$7D,$D0,$D0
    db $D0,$D0,$D0,$D0,$18,$7E,$D0,$D0
    db $D0,$D0,$D0,$D0,$0C,$7F,$D0,$D0
    db $D0,$D0,$D0,$D0,$D0,$D0,$C7,$C7
    db $C7,$C7

MusicB2S04P07:
    db $DA,$04,$E2,$14,$E3,$FF,$28,$DB
    db $14,$48,$7E,$84,$DB,$08,$48,$A2
    db $DB,$0A,$48,$A3,$C6,$DD,$0C,$60
    db $97,$E2,$3C,$00

MusicB2S04P08:
    db $DA,$04,$DB,$12,$0C,$7E,$C7,$48
    db $89,$DB,$06,$3C,$A7,$DB,$14,$48
    db $A8,$C6,$DD,$0C,$60,$97

MusicB2S04P09:
    db $DA,$04,$DB,$10,$18,$7E,$C7,$48
    db $8E,$DB,$04,$30,$AC,$DB,$0F,$48
    db $AD,$C6,$DD,$0C,$60,$97

MusicB2S04P0A:
    db $DA,$04,$DB,$0E,$24,$7E,$C7,$48
    db $93,$DB,$02,$24,$B1,$DB,$05,$48
    db $B2,$C6,$DD,$0C,$60,$97

MusicB2S04P0B:
    db $DA,$04,$DB,$0C,$30,$7E,$C7,$48
    db $98,$DB,$00,$18,$B6,$DB,$00,$48
    db $B7,$C6,$DD,$0C,$60,$97

MusicB2S04P0C:
    db $DA,$04,$DB,$0A,$3C,$7E,$C7,$48
    db $9D,$DB,$00,$0C,$BA,$DB,$0A,$48
    db $BB,$C6,$DD,$0C,$60,$97

MusicB2S04P15:
    db $E7,$F0,$DA,$11,$DE,$48,$07,$30
    db $DB,$0A,$08,$7E,$97,$9A,$9D,$48
    db $A3,$54,$A2,$6C,$9C,$60,$C6,$00

MusicB2S04P16:
    db $E7,$F0,$DA,$11,$DE,$48,$07,$30
    db $DB,$0C,$08,$7C,$C6,$C6,$97,$9A
    db $9D,$48,$A3,$54,$A2,$6C,$9C,$60
    db $C6

MusicB2S04P18:
    db $08,$C6,$C6

MusicB2S04P17:
    db $08,$97,$9A,$9D,$48,$A3,$54,$A2
    db $6C,$A6,$60,$C6,$00

MusicB2S04P10:
    db $DA,$0F,$DB,$0F,$60,$7D,$C6,$54
    db $9E,$6C,$A1,$C6

MusicB2S04P13:
    db $DA,$0F,$DB,$0F,$60,$7D,$C6,$54
    db $A1,$6C,$A7,$C6

MusicB2S04P0E:
    db $DA,$11,$DB,$0F,$60,$7D,$97,$96
    db $95,$94

MusicB2S04P12:
    db $DA,$11,$DB,$05,$60,$7D,$90,$8F
    db $8E,$8D

MusicB2S04P0D:
    db $DA,$0E,$DB,$0A,$0C,$7F,$90,$C6
    db $90,$C6,$90,$C6,$90,$C6,$0C,$90
    db $90,$90,$8E,$C6,$8E,$8E,$8F,$18
    db $90,$90,$90,$90,$0C,$90,$90,$90
    db $8E,$C6,$8E,$8E,$8F,$00

MusicB2S04P0F:
    db $DA,$01,$DB,$0A,$E9,$9D,$24,$04
    db $18,$7E,$D0,$C6,$0C,$D0,$D0,$18
    db $C6,$0C,$D0,$C6,$C6,$D0,$C6,$D0
    db $C6,$C6,$00

MusicB2S04P11:
    db $DA,$01,$DB,$0A,$E9,$B8,$24,$10
    db $18,$7E,$C6,$D8,$00

MusicB2S04P14:
    db $18,$7E,$C6,$D8,$C6,$D8,$C6,$D8
    db $C6,$D8,$C6,$D8,$C6,$D8,$0C,$C6
    db $D8,$D8,$D8,$D8,$D8,$D8,$D8,$00

MusicB2S04P1E:
    db $08,$C6,$C6

MusicB2S04P1B:
    db $60,$A9,$54,$A8,$6C,$A0,$48,$C6
    db $18,$A9,$00

MusicB2S04P1A:
    db $DB,$0A,$0C,$3D,$97,$9D,$97,$C6
    db $97,$9D,$97,$C6,$0C,$3E,$97,$0C
    db $3D,$9D,$97,$0C,$3E,$9D,$0C,$3D
    db $C6,$9C,$0C,$3E,$97,$0C,$3D,$9D
    db $97,$9D,$97,$C6,$97,$9D,$97,$C6
    db $0C,$3E,$97,$0C,$3D,$9D,$97,$0C
    db $3E,$9D,$0C,$3D,$C6,$9C,$0C,$3E
    db $97,$0C,$3D,$9D

MusicB2S04P1F:
    db $DB,$05,$01,$3C,$C7,$0C,$9D,$97
    db $9D,$C6,$9D,$97,$9D,$C6,$0C,$3D
    db $9D,$0C,$3C,$97,$9D,$0C,$3D,$97
    db $0C,$3C,$C6,$97,$0C,$3D,$9C,$0C
    db $3C,$97,$0C,$9D,$97,$9D,$C6,$9D
    db $97,$9D,$C6,$0C,$3D,$9D,$0C,$3C
    db $97,$9D,$0C,$3D,$97,$0C,$3C,$C6
    db $97,$0C,$3D,$9C,$0C,$3C,$97

MusicB2S04P19:
    db $0C,$88,$C6,$88,$C6,$88,$C6,$88
    db $C6,$88,$C6,$88,$88,$C6,$88,$88
    db $88,$0C,$88,$C6,$88,$C6,$88,$C6
    db $88,$C6,$88,$C6,$88,$88,$C6,$88
    db $88,$88,$00

MusicB2S04P1C:
    db $DA,$01,$DB,$0A,$E9,$89,$25,$04
    db $18,$7E,$D0,$C6,$0C,$D0,$D0,$18
    db $C6,$0C,$C6,$D0,$D0,$C6,$D0,$D0
    db $C6,$D0,$00

MusicB2S04P1D:
    db $DA,$01,$DB,$0A,$E9,$A4,$25,$04
    db $18,$7E,$C6,$D8,$C6,$D8,$0C,$7E
    db $D8,$C6,$C6,$D8,$C6,$C6,$D8,$C6
    db $00

MusicB2S04P23:
    db $08,$C6,$C6

MusicB2S04P22:
    db $60,$A8,$54,$A7,$6C,$9F,$48,$C6
    db $30,$A8

MusicB2S04P21:
    db $0C,$96,$9C,$96,$C6,$96,$9C,$96
    db $C6,$0C,$3E,$96,$0C,$3D,$9C,$96
    db $0C,$3E,$9C,$0C,$3D,$C6,$9B,$0C
    db $3E,$96,$0C,$3D,$9C,$0C,$96,$9C
    db $96,$C6,$96,$9C,$96,$C6,$0C,$3E
    db $96,$0C,$3D,$9C,$96,$0C,$3E,$9C
    db $0C,$3D,$C6,$9B,$0C,$3E,$96,$0C
    db $3D,$9C

MusicB2S04P24:
    db $01,$C7,$0C,$9C,$96,$9C,$C6,$9C
    db $96,$9C,$C6,$0C,$3D,$9C,$0C,$3C
    db $96,$9C,$0C,$3D,$96,$0C,$3C,$C6
    db $96,$0C,$3D,$9B,$0C,$3C,$96,$0C
    db $9C,$96,$9C,$C6,$9C,$96,$9C,$C6
    db $0C,$3D,$9C,$0C,$3C,$96,$9C,$0C
    db $3D,$96,$0C,$3C,$C6,$96,$0C,$3D
    db $9B,$0C,$3C,$96

MusicB2S04P20:
    db $0C,$87,$C6,$87,$C6,$87,$C6,$87
    db $C6,$87,$C6,$87,$87,$C6,$87,$87
    db $87,$0C,$87,$C6,$87,$C6,$87,$C6
    db $87,$C6,$87,$C6,$87,$87,$C6,$87
    db $87,$87,$00

MusicB2S04P26:
    db $08,$C6,$C6

MusicB2S04P25:
    db $E8,$FF,$28,$60,$C6,$18,$C6,$DD
    db $00,$30,$BB,$48,$C6,$60,$C6,$C6
    db $00

MusicB2S15P00:
    db $DA,$01,$E2,$2D,$DE,$14,$14,$20
    db $DB,$05,$30,$5D,$B4,$B2,$B0,$60
    db $AF,$C6,$30,$C6,$00

MusicB2S15P01:
    db $DA,$01,$DE,$14,$14,$20,$DB,$0F
    db $30,$5D,$B0,$AF,$AD,$60,$AB,$C6
    db $C6

MusicB2S15P02:
    db $DA,$01,$DE,$14,$14,$20,$DB,$0A
    db $0C,$5D,$B7,$B9,$B7,$B9,$B7,$B9
    db $B7,$B9,$B7,$B9,$B7,$B9,$06,$B7
    db $B9,$B7,$B9,$B7,$B9,$B7,$B9,$60
    db $B7,$60,$59,$C3

MusicB2S15P03:
    db $DA,$00,$DE,$14,$14,$20,$DB,$0A
    db $0C,$59,$B7,$B9,$B7,$B9,$B7,$B9
    db $B7,$B9,$B7,$B9,$B7,$B9,$06,$B7
    db $B9,$B7,$B9,$B7,$B9,$B7,$B9,$60
    db $B7,$C6,$C6

MusicB2S13P00:
    db $DA,$01,$E2,$32,$DE,$14,$14,$20
    db $DB,$0A,$18,$5D,$C7,$0C,$B7,$B9
    db $C0,$C7,$B7,$B9,$30,$C0,$C6,$18
    db $C7,$0C,$B7,$B9,$C1,$C7,$B7,$B9
    db $30,$C1,$C6,$18,$C7,$0C,$B7,$B8
    db $C1,$C7,$B7,$B8,$30,$C1,$C6,$18
    db $C7,$0C,$B7,$B9,$C0,$C7,$B7,$B9
    db $30,$C0,$C6,$00

MusicB2S13P04:
    db $DA,$00,$DE,$14,$13,$20,$DB,$0A
    db $60,$59,$C7,$30,$C7,$0C,$B7,$B9
    db $B7,$B9,$60,$B7,$30,$C7,$0C,$B7
    db $B9,$B7,$B9,$60,$B7,$30,$C7,$0C
    db $B7,$B8,$B7,$B8,$B7,$B4,$B0,$AD
    db $B0,$AD,$AB,$A8,$AB,$A8,$A4,$A1
    db $60,$9F

MusicB2S13P01:
    db $DA,$01,$DE,$14,$15,$20,$DB,$0F
    db $18,$5D,$C7,$0C,$B4,$B5,$BC,$C7
    db $B4,$B5,$30,$BC,$C6,$18,$C7,$0C
    db $B4,$B5,$BE,$C7,$B4,$B5,$30,$BE
    db $C6,$18,$C7,$0C,$B2,$B5,$BE,$C7
    db $B2,$B5,$30,$BE,$C6,$18,$C7,$0C
    db $B4,$B5,$BC,$C7,$B4,$B5,$30,$BC
    db $C6

MusicB2S13P03:
    db $DA,$04,$DB,$0A,$DE,$14,$13,$20
    db $60,$5E,$8C,$48,$C6,$18,$8C,$60
    db $8C,$48,$C6,$18,$8C,$60,$8C,$48
    db $C6,$18,$8C,$60,$8C,$48,$C6,$18
    db $8C

MusicB2S13P02:
    db $DA,$01,$DB,$05,$DE,$14,$14,$20
    db $60,$5E,$98,$48,$C6,$18,$98,$60
    db $98,$48,$C6,$18,$98,$60,$98,$48
    db $C6,$18,$98,$60,$98,$48,$C6,$18
    db $98

MusicB2S13P05:
    db $DA,$01,$DB,$0F,$DE,$14,$15,$20
    db $E7,$AA,$E8,$C0,$F0,$18,$3E,$C7
    db $0C,$AB,$AB,$18,$AB,$AB,$AB,$AB
    db $AB,$AB,$E7,$AA,$E8,$C0,$F0,$18
    db $C7,$0C,$AD,$AD,$18,$AD,$AD,$AD
    db $AD,$AD,$AD,$E7,$AA,$E8,$C0,$F0
    db $18,$C7,$0C,$AC,$AC,$18,$AC,$AC
    db $AC,$AC,$AC,$AC,$E7,$AA,$E8,$C0
    db $F0,$18,$C7,$0C,$AB,$AB,$18,$AB
    db $AB,$AB,$AB,$AB,$AB

MusicB2S13P07:
    db $DA,$01,$DB,$0F,$DE,$14,$14,$20
    db $E7,$AA,$E8,$C0,$F0,$18,$3E,$C7
    db $0C,$A8,$A8,$18,$A8,$A8,$A8,$A8
    db $A8,$A8,$E7,$AA,$E8,$C0,$F0,$18
    db $C7,$0C,$A9,$A9,$18,$A9,$A9,$A9
    db $A9,$A9,$A9,$E7,$AA,$E8,$C0,$F0
    db $18,$C7,$0C,$A9,$A9,$18,$A9,$A9
    db $A9,$A9,$A9,$A9,$E7,$AA,$E8,$C0
    db $F0,$18,$C7,$0C,$A8,$A8,$18,$A8
    db $A8,$A8,$A8,$A8,$A8

MusicB2S13P06:
    db $DA,$01,$DB,$05,$E9,$67,$28,$04
    db $E7,$DC,$E8,$60,$64,$06,$7E,$D7
    db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7
    db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$E7
    db $AA,$48,$C7,$18,$5E,$D6,$00

MusicB2S13P08:
    db $60,$A9,$C6,$18,$7C,$AB,$B2,$B7
    db $B9,$30,$BA,$BB,$60,$C6,$00

MusicB2S13P0F:
    db $DA,$01,$DE,$14,$15,$20,$60,$7C
    db $A4,$C6,$18,$A3,$A9,$AF,$B0,$30
    db $B1,$B2,$60,$C6

MusicB2S13P09:
    db $30,$5B,$C6,$B9,$30,$B5,$B2,$60
    db $B0,$AF,$C6

MusicB2S13P0C:
    db $DA,$00,$DB,$0A,$DE,$14,$14,$20
    db $18,$5D,$C7,$0C,$A6,$A5,$18,$A6
    db $A9,$AD,$A9,$AD,$B5,$60,$B4,$B2
    db $C6

MusicB2S13P0B:
    db $60,$8E,$C6,$60,$93,$C6,$C6

MusicB2S13P0D:
    db $DA,$01,$DB,$0A,$60,$6D,$A1,$C6
    db $60,$A3,$DA,$10,$06,$6D,$AB,$AF
    db $B2,$B5,$B7,$BB,$BE,$C1,$30,$C3
    db $60,$C6

MusicB2S13P0A:
    db $60,$9A,$C6,$60,$9F,$C6,$C6

MusicB2S13P0E:
    db $DA,$01,$DB,$05,$E7,$C8,$E8,$30
    db $64,$06,$7E,$D7,$D7,$D7,$D7,$D7
    db $D7,$D7,$D7,$30,$C7,$60,$C7,$E7
    db $C8,$E8,$60,$64,$06,$7E,$D7,$D7
    db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7
    db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7
    db $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7
    db $D7,$D7,$D7,$D7,$D7,$D7,$60,$C7
    db $00

MusicB2S12P00:
    db $F0,$DA,$04,$E2,$40,$DB,$05,$30
    db $5C,$AB,$AB,$AA,$AA,$18,$A9,$A6
    db $AD,$60,$AB,$18,$C7,$00

MusicB2S12P04:
    db $DA,$00,$DB,$0A,$30,$5C,$B7,$B7
    db $B6,$B6,$18,$B5,$B2,$B9,$60,$B7
    db $18,$C7

MusicB2S12P02:
    db $DA,$04,$DB,$0A,$30,$5C,$A8,$A8
    db $A7,$A7,$18,$A6,$A2,$A9,$60,$A8
    db $18,$C7

MusicB2S12P03:
    db $DA,$04,$DB,$0F,$30,$5C,$A4,$A4
    db $A4,$A4,$18,$A2,$9F,$A6,$60,$A4
    db $18,$C7

MusicB2S12P01:
    db $DA,$0E,$DB,$0A,$30,$5D,$95,$95
    db $94,$94,$18,$93,$C7,$93,$8C,$C6
    db $8C,$8C,$8C

MusicB2S12P06:
    db $DA,$07,$DB,$0A,$18,$5B,$91,$A4
    db $A4,$91,$A4,$A4,$91,$A4,$8E,$A1
    db $A1,$8E,$A1,$A1,$8E,$A1,$91,$A4
    db $A4,$91,$A4,$A4,$91,$A4,$8E,$A1
    db $A1,$8E,$A1,$C6,$C6,$C6

MusicB2S12P05:
    db $DA,$07,$DB,$05,$18,$5B,$C7,$A9
    db $A9,$C7,$A9,$A9,$C7,$A9,$C7,$A6
    db $A6,$C7,$A6,$A6,$C7,$A6,$C7,$A9
    db $A9,$C7,$A9,$A9,$C7,$A9,$C7,$A6
    db $A6,$C7,$A6,$C6,$C6,$C6,$00

MusicB2S12P07:
    db $DA,$0C,$DB,$0F,$DB,$0A,$E7,$FF
    db $24,$6F,$B5,$0C,$B0,$18,$B2,$24
    db $B5,$0C,$B0,$18,$B2,$0C,$B5,$B9
    db $B0,$B2,$24,$B5,$0C,$B0,$18,$B2
    db $24,$B5,$0C,$B0,$18,$B2,$0C,$B5
    db $B9,$B0,$B2,$24,$B5,$0C,$B0,$18
    db $B2,$24,$B5,$0C,$B0,$18,$B2,$0C
    db $B5,$B9,$B0,$B2,$24,$B5,$0C,$B0
    db $18,$B2,$24,$B5,$0C,$B0,$18,$B2
    db $0C,$B5,$B9,$B0,$B2

MusicB2S12P08:
    db $DE,$00,$00,$00,$DA,$01,$DB,$0A
    db $EC,$00,$06,$08,$30,$5D,$B9,$24
    db $B5,$0C,$B0,$18,$B5,$B5,$24,$B5
    db $0C,$B0,$18,$B5,$B5,$B5,$BC,$30
    db $B9,$24,$B7,$0C,$B0,$00

MusicB2S12P0B:
    db $DE,$00,$00,$00,$DA,$02,$DB,$05
    db $30,$59,$B9,$24,$B5,$0C,$B0,$18
    db $B5,$B5,$24,$B5,$0C,$B0,$18,$B5
    db $B5,$B5,$BC,$30,$B9,$24,$B7,$0C
    db $B0

MusicB2S12P09:
    db $DA,$07,$DB,$0A,$18,$59,$91,$A4
    db $91,$A4,$91,$A4,$91,$A4,$91,$A4
    db $91,$A4,$91,$C7,$8C,$C6

MusicB2S12P0A:
    db $DA,$07,$DB,$05,$18,$59,$C7,$A1
    db $C7,$A1,$C7,$A1,$C7,$A1,$C7,$A1
    db $C7,$A1,$A1,$C7,$9F,$C6

MusicB2S12P0C:
    db $DA,$07,$DB,$0F,$18,$59,$C7,$A9
    db $C7,$A9,$C7,$A9,$C7,$A9,$C7,$A9
    db $C7,$A9,$A4,$C7,$A8,$C6

MusicB2S12P0D:
    db $30,$B9,$24,$B5,$0C,$B0,$18,$B5
    db $B5,$24,$B5,$0C,$B0,$18,$B5,$BC
    db $B9,$B7,$30,$B5,$DA,$0F,$18,$A1
    db $C6,$00

MusicB2S12P10:
    db $30,$B9,$24,$B5,$0C,$B0,$18,$B5
    db $B5,$24,$B5,$0C,$B0,$18,$B5,$BC
    db $B9,$B7,$30,$B5,$DA,$0F,$18,$AD
    db $C6

MusicB2S12P0E:
    db $18,$91,$A4,$91,$A4,$91,$A4,$91
    db $A4,$91,$A4,$98,$A8,$91,$C7,$91
    db $C7

MusicB2S12P0F:
    db $18,$C7,$A1,$C7,$A1,$C7,$A1,$C7
    db $A1,$C7,$A1,$C7,$A4,$A1,$C7,$A1
    db $C7

MusicB2S12P11:
    db $18,$C7,$A9,$C7,$A9,$C7,$A9,$C7
    db $A9,$C7,$A9,$C7,$AB,$A4,$C7,$A4
    db $C7

MusicB2S12P12:
    db $DA,$01,$30,$B9,$18,$B5,$B0,$30
    db $B9,$B5,$0C,$B8,$B5,$18,$B0,$30
    db $B8,$60,$B7,$00

MusicB2S12P13:
    db $18,$96,$A6,$96,$A6,$95,$A4,$95
    db $A4,$94,$A4,$94,$A4,$93,$A6,$8C
    db $A4,$00

MusicB2S12P14:
    db $18,$C7,$A2,$C7,$A2,$C7,$A1,$C7
    db $A1,$C7,$A0,$C7,$A0,$C7,$A2,$C7
    db $A2

MusicB2S12P15:
    db $18,$C7,$A9,$C7,$A9,$C7,$A9,$C7
    db $A9,$C7,$A9,$C7,$A9,$C7,$A9,$C7
    db $A8

MusicB2S12P16:
    db $30,$B9,$18,$B5,$B0,$30,$B9,$B5
    db $0C,$B8,$B5,$18,$B0,$60,$BC,$30
    db $C7,$00

MusicB2S14P00:
    db $DA,$01,$DB,$0A,$E2,$40,$EC,$00
    db $06,$08,$30,$5D,$BE,$BE,$BE,$BE
    db $18,$BC,$BC,$B9,$B7,$30,$B5,$DA
    db $0F,$18,$A1,$C6,$00

MusicB2S14P05:
    db $DA,$01,$DB,$0A,$EC,$00,$06,$08
    db $30,$5D,$BA,$BA,$BB,$BB,$18,$B9
    db $B9,$B5,$B4,$30,$B0,$DA,$0F,$18
    db $95,$C6,$00

MusicB2S14P04:
    db $DA,$02,$DB,$05,$30,$59,$BE,$BE
    db $BE,$BE,$18,$BC,$BC,$B9,$B7,$30
    db $B5,$DA,$0F,$18,$A1,$C6,$00

MusicB2S14P01:
    db $DA,$07,$DB,$0A,$18,$59,$96,$A6
    db $96,$A6,$97,$A6,$97,$A6,$98,$A8
    db $98,$A8,$91,$C7,$91,$C7

MusicB2S14P02:
    db $DA,$07,$DB,$05,$18,$59,$C7,$A2
    db $C7,$A2,$C7,$A3,$C7,$A3,$C7,$A4
    db $C7,$A4,$A1,$C7,$A1,$C7

MusicB2S14P06:
    db $DA,$07,$DB,$0F,$18,$59,$C7,$A9
    db $C7,$A9,$C7,$A9,$C7,$A9,$C7,$AB
    db $C7,$AB,$A4,$C7,$A4,$C7

MusicB2S14P03:
    db $DA,$0C,$DB,$0F,$DB,$0A,$E7,$FF
    db $24,$6F,$B5,$0C,$B0,$18,$B2,$24
    db $B5,$0C,$B0,$18,$B2,$0C,$B5,$B9
    db $B0,$B2,$24,$B5,$0C,$B0,$18,$B2
    db $B5,$B5,$C6,$B5,$C6

MusicB2S0BP02:
    db $F0,$DA,$04,$E2,$2D,$DE,$23,$13
    db $30,$DB,$0A,$18,$4C,$C6,$0C,$B9
    db $B9,$18,$3C,$B9,$18,$5C,$B9,$B5
    db $B0,$0C,$4C,$B2,$C7,$C7,$B5,$60
    db $B5,$30,$C6,$18,$C7,$0C,$B0,$B0
    db $18,$3C,$B0,$B5,$E3,$30,$26,$10
    db $5C,$B5,$BC,$BC,$60,$6D,$B9,$30
    db $C6,$00

MusicB2S0BP03:
    db $DA,$04,$DE,$23,$14,$30,$DB,$0A
    db $18,$4C,$C6,$0C,$B2,$B2,$18,$3C
    db $B2,$18,$5C,$B2,$AE,$A9,$0C,$4C
    db $AD,$C7,$C7,$AE,$60,$AE,$30,$C6
    db $18,$C7,$0C,$AB,$AB,$18,$3C,$AB
    db $AE,$10,$5C,$AE,$B7,$B7,$60,$B4
    db $30,$C6

MusicB2S0BP04:
    db $DA,$04,$DE,$23,$13,$30,$DB,$0A
    db $18,$4C,$C6,$0C,$AE,$AE,$18,$3C
    db $AE,$18,$5C,$AE,$A9,$A6,$0C,$4C
    db $A9,$C7,$C7,$A9,$60,$A9,$30,$C6
    db $18,$C7,$0C,$A7,$A7,$18,$3C,$A7
    db $AB,$10,$5C,$AB,$B1,$B1,$60,$B0
    db $30,$C6

MusicB2S0BP05:
    db $DA,$04,$DE,$23,$14,$30,$DB,$0A
    db $18,$4C,$C6,$0C,$A9,$A9,$18,$3C
    db $A9,$18,$5C,$A9,$A6,$A1,$0C,$4C
    db $A2,$C7,$C7,$A6,$60,$A6,$30,$C6
    db $18,$C7,$0C,$A2,$A2,$18,$3C,$A2
    db $A5,$10,$5C,$A5,$AE,$AE,$60,$AD
    db $30,$C6

MusicB2S0BP08:
    db $DA,$02,$DB,$14,$60,$6B,$C7,$C7
    db $DC,$90,$00,$06,$A6,$A9,$AD,$AE
    db $A9,$AD,$AE,$B2,$AD,$AE,$B2,$B5
    db $AE,$B2,$B5,$B9,$B2,$B5,$B9,$BA
    db $B5,$B9,$BA,$BE,$60,$C1,$C7,$C7
    db $C7

MusicB2S0BP09:
    db $DA,$02,$DB,$14,$04,$69,$C7,$60
    db $C7,$C7,$DC,$90,$00,$06,$A6,$A9
    db $AD,$AE,$A9,$AD,$AE,$B2,$AD,$AE
    db $B2,$B5,$AE,$B2,$B5,$B9,$B2,$B5
    db $B9,$BA,$B5,$B9,$BA,$BE,$60,$C1
    db $C7,$C7,$C7

MusicB2S0BP07:
    db $DA,$04,$DE,$23,$11,$30,$DB,$0A
    db $60,$7E,$8C,$C6,$18,$C6,$0C,$8C
    db $8C,$18,$8C,$8C,$10,$8C,$8D,$8E
    db $60,$8F,$10,$8F,$8F,$8F,$60,$91
    db $30,$C6

MusicB2S0BP06:
    db $DA,$04,$DB,$0A,$60,$7E,$D5,$C6
    db $18,$C6,$0C,$D5,$D5,$18,$D5,$D5
    db $10,$D5,$D5,$D5,$60,$D5,$10,$D5
    db $D5,$D5,$06,$7D,$D5,$D5,$D5,$D5
    db $D5,$D5,$D5,$D5,$06,$D5,$D5,$D5
    db $D5,$D5,$D5,$D5,$D5,$06,$D5,$D5
    db $D5,$D5,$D5,$D5,$30,$6F,$D5

MusicB2S08P00:
    db $F0,$DA,$01,$E2,$28,$E3,$8C,$46
    db $E0,$FF,$DE,$23,$11,$40,$DB,$14
    db $60,$6E,$87,$DB,$04,$60,$B0,$30
    db $C6,$00

MusicB2S08P01:
    db $DA,$01,$DE,$23,$12,$40,$DB,$12
    db $0C,$6E,$C7,$60,$8D,$DB,$02,$60
    db $B1,$24,$C6

MusicB2S08P02:
    db $DA,$01,$DE,$23,$13,$40,$DB,$10
    db $18,$6E,$C7,$60,$93,$DB,$00,$60
    db $B7,$18,$C6

MusicB2S08P03:
    db $DA,$01,$DE,$23,$12,$40,$DB,$0E
    db $24,$6E,$C7,$60,$99,$6C,$C6

MusicB2S08P04:
    db $DA,$01,$DE,$23,$13,$40,$DB,$0C
    db $30,$6E,$C7,$60,$9F,$60,$C6

MusicB2S08P05:
    db $DA,$01,$DE,$23,$12,$40,$DB,$0A
    db $30,$6E,$C7,$0C,$C7,$60,$A4,$54
    db $C6

MusicB2S08P06:
    db $DA,$01,$DE,$23,$14,$40,$DB,$08
    db $48,$6E,$C7,$60,$A5,$48,$C6

MusicB2S08P07:
    db $DA,$01,$DE,$23,$12,$40,$DB,$06
    db $48,$6E,$C7,$0C,$C7,$60,$AB,$3C
    db $C6

MusicB2S08P08:
    db $E7,$64,$E8,$60,$C8,$DA,$01,$E2
    db $14,$DB,$14,$06,$6F,$B0,$06,$6B
    db $B0,$B0,$B0,$B0,$B0,$B0,$B0,$06
    db $6D,$B0,$06,$6C,$B0,$B0,$B0,$B0
    db $B0,$B0,$B0,$E7,$64,$E8,$60,$C8
    db $06,$6F,$AF,$06,$6B,$AF,$AF,$AF
    db $AF,$AF,$AF,$AF,$06,$6D,$AF,$06
    db $6C,$AF,$AF,$AF,$AF,$AF,$AF,$AF
    db $E7,$64,$E8,$60,$C8,$06,$6F,$B0
    db $06,$6B,$B0,$B0,$B0,$B0,$B0,$B0
    db $B0,$06,$6D,$B0,$06,$6C,$B0,$B0
    db $B0,$B0,$B0,$B0,$B0,$E7,$64,$E8
    db $60,$C8,$06,$6F,$AF,$06,$6B,$AF
    db $AF,$AF,$AF,$AF,$AF,$AF,$06,$6D
    db $AF,$06,$6C,$AF,$AF,$AF,$AF,$AF
    db $AF,$AF,$00

MusicB2S08P09:
    db $E7,$64,$E8,$60,$C8,$DA,$01,$DB
    db $0F,$06,$6F,$B5,$06,$6B,$B5,$B5
    db $B5,$B5,$B5,$B5,$B5,$06,$6D,$B5
    db $06,$6C,$B5,$B5,$B5,$B5,$B5,$B5
    db $B5,$E7,$64,$E8,$60,$C8,$06,$6F
    db $B7,$06,$6B,$B7,$B7,$B7,$B7,$B7
    db $B7,$B7,$06,$6D,$B7,$06,$6C,$B7
    db $B7,$B7,$B7,$B7,$B7,$B7,$E7,$64
    db $E8,$60,$C8,$06,$6F,$B8,$06,$6B
    db $B8,$B8,$B8,$B8,$B8,$B8,$B8,$06
    db $6D,$B8,$06,$6C,$B8,$B8,$B8,$B8
    db $B8,$B8,$B8,$E7,$64,$E8,$60,$C8
    db $06,$6F,$B7,$06,$6B,$B7,$B7,$B7
    db $B7,$B7,$B7,$B7,$06,$6D,$B7,$06
    db $6C,$B7,$B7,$B7,$B7,$B7,$B7,$B7

MusicB2S08P0A:
    db $DA,$04,$E7,$C8,$DB,$0A,$DE,$28
    db $28,$20,$48,$6F,$C7,$18,$85,$30
    db $87,$C7,$48,$C7,$18,$85,$30,$87
    db $C7

MusicB2S08P0B:
    db $DA,$01,$E7,$FF,$DB,$0A,$DE,$1E
    db $29,$20,$18,$6F,$A0,$C6,$9D,$98
    db $18,$9A,$48,$9D,$18,$C7,$98,$9D
    db $A4,$30,$A0,$9F

MusicB2S08P0C:
    db $04,$C7,$DA,$01,$E7,$FF,$DB,$05
    db $DE,$1E,$28,$20,$18,$6C,$A0,$C6
    db $9D,$98,$18,$9A,$48,$9D,$18,$C7
    db $98,$9D,$A4,$30,$A0,$9F

MusicB2S08P0D:
    db $E7,$64,$E8,$48,$C8,$DA,$01,$E2
    db $14,$DB,$14,$06,$6F,$B0,$06,$6B
    db $B0,$B0,$B0,$B0,$B0,$B0,$B0,$06
    db $6D,$B0,$06,$6C,$B0,$B0,$B0,$E7
    db $DC,$18,$6E,$B0,$AF,$30,$C7,$18
    db $B0,$AF,$30,$C7,$18,$B0,$AF,$B0
    db $AE,$AF,$C6,$48,$C7,$60,$C7

MusicB2S08P0E:
    db $E7,$64,$E8,$48,$C8,$DA,$01,$DB
    db $0F,$06,$6F,$B5,$06,$6B,$B5,$B5
    db $B5,$B5,$B5,$B5,$B5,$06,$6D,$B5
    db $06,$6C,$B5,$B5,$B5,$E7,$DC,$18
    db $6E,$B5,$B7,$30,$C7,$18,$B5,$B7
    db $30,$C7,$18,$B5,$B7,$B8,$B6,$B7
    db $C6,$48,$C7,$60,$C7,$00

MusicB2S08P12:
    db $DA,$04,$E7,$FF,$DB,$0A,$DE,$23
    db $14,$40,$48,$6E,$C7,$18,$91,$93
    db $85,$87,$91,$93,$85,$87,$85,$87
    db $88,$86,$87,$C6,$48,$C7,$60,$C7

MusicB2S08P13:
    db $DA,$0A,$E7,$FF,$DB,$0A,$48,$6E
    db $C7,$18,$C7,$C7,$85,$87,$C7,$C7
    db $85,$87,$85,$87,$88,$86,$87,$C6
    db $48,$C7,$60,$C7,$C7

MusicB2S08P0F:
    db $DA,$01,$E7,$C8,$DB,$0A,$DE,$28
    db $28,$20,$48,$7E,$C7,$18,$C1,$C3
    db $C7,$C7,$C1,$C3,$C7,$C7,$C1,$C3
    db $C4,$C2,$C3,$60,$C6,$30,$C6,$E2
    db $08,$E3,$30,$19,$03,$C1,$BE,$BB
    db $B8,$B7,$B5,$B2,$AF,$AC,$AB,$A9
    db $A6,$A3,$A0,$9F,$C6,$18,$C6

MusicB2S08P11:
    db $04,$C7,$DA,$01,$E7,$C8,$DB,$0A
    db $DE,$28,$29,$20,$48,$7B,$C7,$18
    db $C1,$C3,$C7,$C7,$C1,$C3,$C7,$C7
    db $C1,$C3,$C4,$C2,$C3,$60,$C6,$30
    db $C6,$03,$C1,$BE,$BB,$B8,$B7,$B5
    db $B2,$AF,$AC,$AB,$A9,$A6,$A3,$A0
    db $9F,$C6,$18,$C6

MusicB2S08P10:
    db $DA,$01,$E7,$C8,$DB,$0A,$DE,$28
    db $28,$20,$48,$6E,$C7,$18,$AC,$B2
    db $C7,$C7,$AC,$B2,$C7,$C7,$AC,$B2
    db $B3,$B1,$B2,$C6,$48,$C7,$60,$C7

MusicB2S08P14:
    db $DA,$01,$E2,$19,$DB,$0F,$E7,$78
    db $E8,$30,$C8,$08,$7D,$A4,$A4,$A4
    db $AB,$AB,$AB,$E8,$30,$78,$B3,$B3
    db $AB,$AB,$AB,$A4,$E8,$30,$C8,$A4
    db $A4,$A4,$AD,$AD,$AD,$E8,$30,$78
    db $B3,$B3,$AD,$AD,$AD,$A4,$E8,$30
    db $C8,$A4,$A4,$A4,$AC,$AC,$AC,$E8
    db $30,$78,$B5,$B5,$AC,$AC,$AC,$A4
    db $E8,$30,$C8,$A6,$A6,$A6,$AF,$AF
    db $AF,$E8,$30,$78,$B5,$B5,$AF,$AF
    db $AF,$A6,$00

MusicB2S08P15:
    db $DA,$01,$DB,$14,$E7,$78,$E8,$30
    db $C8,$04,$7D,$C6,$08,$9F,$A7,$A7
    db $B0,$B0,$B0,$E8,$30,$78,$B0,$B0
    db $B0,$A7,$A7,$A7,$E8,$30,$C8,$A1
    db $A7,$A7,$A7,$B0,$B0,$E8,$30,$78
    db $B0,$B0,$B0,$A7,$A7,$A7,$E8,$30
    db $C8,$A0,$A9,$A9,$A9,$B0,$B0,$E8
    db $30,$78,$B0,$B0,$B0,$A9,$A9,$A9
    db $E8,$30,$C8,$A3,$A9,$A9,$A9,$B2
    db $B2,$E8,$30,$78,$B2,$B2,$B2,$A9
    db $A9,$A9

MusicB2S08P16:
    db $DA,$01,$E7,$C8,$DB,$0A,$DE,$1E
    db $28,$20,$30,$6F,$8C,$8C,$92,$92
    db $91,$91,$93,$93

MusicB2S08P18:
    db $DA,$01,$E7,$C8,$DB,$0A,$DE,$1E
    db $27,$20,$18,$6F,$8C,$8C,$8C,$8C
    db $92,$92,$92,$92,$91,$91,$91,$91
    db $93,$93,$93,$93

MusicB2S08P1B:
    db $DA,$01,$E7,$C8,$DB,$0A,$DE,$1E
    db $28,$20,$0C,$6F,$8C,$8C,$8C,$8C
    db $8C,$8C,$8C,$8C,$92,$92,$92,$92
    db $92,$92,$92,$92,$91,$91,$91,$91
    db $91,$91,$91,$91,$93,$93,$93,$93
    db $93,$93,$93,$93

MusicB2S08P17:
    db $DA,$04,$E7,$C8,$DB,$05,$DE,$1E
    db $29,$20,$60,$7B,$8C,$DD,$0C,$12
    db $98,$DD,$0C,$12,$8C,$60,$7B,$92
    db $DD,$0C,$12,$9E,$DD,$0C,$12,$92
    db $60,$7B,$91,$DD,$0C,$12,$9D,$DD
    db $0C,$12,$91,$60,$7B,$93,$DD,$0C
    db $12,$9F,$DD,$0C,$12,$93

MusicB2S08P19:
    db $DA,$01,$E7,$DC,$DB,$0A,$DE,$1E
    db $28,$20,$18,$7D,$B3,$C6,$B0,$AB
    db $18,$AA,$48,$B0,$18,$C7,$AB,$B0
    db $B7,$30,$B3,$B2

MusicB2S08P1A:
    db $DA,$01,$E7,$DC,$DB,$0A,$DE,$18
    db $29,$20,$18,$7C,$AB,$C6,$A7,$A4
    db $18,$A4,$48,$AA,$18,$C7,$A4,$AB
    db $B0,$60,$A9

MusicB2S08P1C:
    db $E7,$78,$E8,$30,$C8,$08,$A4,$A4
    db $A4,$AB,$AB,$AB,$E8,$30,$78,$B3
    db $B3,$AB,$AB,$AB,$A4,$E8,$30,$C8
    db $A6,$A6,$A6,$AC,$AC,$AC,$E8,$30
    db $78,$B5,$B5,$AC,$AC,$AC,$A0,$E8
    db $30,$C8,$A6,$A6,$A6,$AF,$AF,$AF
    db $E8,$30,$78,$B5,$B5,$AF,$AF,$AF
    db $A6,$E8,$30,$C8,$A4,$A4,$A4,$AB
    db $AB,$AB,$E8,$30,$78,$B3,$B3,$AB
    db $AB,$AB,$A4

MusicB2S08P1D:
    db $E7,$78,$E8,$30,$C8,$04,$C6,$08
    db $9F,$A7,$A7,$A7,$B0,$B0,$E8,$30
    db $78,$B0,$B0,$B0,$A7,$A7,$A7,$E8
    db $30,$C8,$A0,$A9,$A9,$A9,$B2,$B2
    db $E8,$30,$78,$B2,$B2,$B2,$A9,$A6
    db $A6,$E8,$30,$C8,$A3,$A9,$A9,$A9
    db $B2,$B2,$E8,$30,$78,$B2,$B2,$B2
    db $A9,$A9,$A9,$E8,$30,$C8,$9F,$A7
    db $A7,$A7,$B0,$B0,$E8,$30,$78,$B0
    db $B0,$B0,$A7,$A7,$A7

MusicB2S08P20:
    db $DA,$01,$E7,$C8,$DB,$0A,$DE,$1E
    db $28,$20,$0C,$6F,$94,$94,$94,$94
    db $94,$94,$94,$94,$97,$97,$97,$97
    db $97,$97,$97,$97,$93,$93,$93,$93
    db $93,$93,$93,$93,$98,$98,$98,$98
    db $98,$98,$98,$98,$00

MusicB2S08P1E:
    db $DA,$01,$E7,$DC,$DB,$0A,$DE,$1E
    db $29,$20,$18,$7D,$C7,$B0,$B7,$BC
    db $30,$B8,$B7,$18,$C7,$AB,$B2,$B7
    db $30,$B5,$B3

MusicB2S08P1F:
    db $DA,$00,$E7,$DC,$DB,$05,$DE,$1E
    db $28,$20,$60,$79,$C7,$18,$C7,$0C
    db $AF,$B0,$18,$B1,$B2,$30,$C6,$C7
    db $18,$C7,$0C,$AD,$AE,$18,$AF,$48
    db $B0

MusicB2S08P22:
    db $DA,$02,$E7,$C8,$DB,$0A,$18,$79
    db $C7,$B0,$B7,$BC,$60,$B8,$18,$C7
    db $AB,$B2,$B7,$60,$B5

MusicB2S08P21:
    db $DA,$01,$E7,$DC,$DB,$0A,$DE,$18
    db $28,$20,$18,$7C,$C7,$AB,$B0,$B7
    db $30,$B2,$B2,$18,$C7,$A3,$A9,$AF
    db $60,$AB

MusicB2S08P23:
    db $E7,$78,$E8,$30,$C8,$08,$A4,$A4
    db $A4,$AA,$AA,$AA,$E8,$30,$78,$B3
    db $B3,$AA,$AA,$AA,$A4,$E8,$30,$C8
    db $A4,$A4,$A4,$AD,$AD,$AD,$E8,$30
    db $78,$B2,$B2,$AD,$AD,$AD,$A4,$E8
    db $30,$C8,$A4,$A4,$A4,$AD,$AD,$AD
    db $E8,$30,$78,$B6,$B6,$AD,$AD,$AD
    db $A4,$E8,$30,$C8,$A4,$A4,$A4,$AB
    db $AB,$AB,$E8,$30,$78,$B2,$B2,$B2
    db $BB,$BB,$BB

MusicB2S08P24:
    db $E8,$30,$C8,$04,$C6,$08,$9E,$A7
    db $A7,$A7,$B0,$B0,$E8,$30,$78,$B0
    db $B0,$B0,$A7,$A7,$A7,$E8,$30,$C8
    db $A1,$A6,$A6,$A6,$B0,$B0,$E8,$30
    db $78,$B0,$B0,$B0,$A6,$A6,$A6,$E8
    db $30,$C8,$A1,$AA,$AA,$AA,$B0,$B0
    db $E8,$30,$78,$B0,$B0,$B0,$AA,$AA
    db $AA,$E8,$30,$C8,$9F,$A6,$A6,$A6
    db $B0,$B0,$E8,$30,$78,$AF,$B5,$B5
    db $B5,$BE,$BE

MusicB2S08P27:
    db $DA,$01,$E7,$C8,$DB,$0A,$DE,$1E
    db $27,$20,$0C,$6F,$95,$95,$95,$95
    db $95,$95,$95,$95,$92,$92,$92,$92
    db $92,$92,$92,$92,$8E,$8E,$8E,$8E
    db $8E,$8E,$8E,$8E,$93,$93,$93,$93
    db $93,$93,$93,$93,$00

MusicB2S08P25:
    db $DA,$01,$E7,$DC,$DB,$0A,$DE,$1E
    db $28,$20,$18,$7D,$C7,$B3,$B2,$B0
    db $30,$B2,$AD,$18,$C7,$B2,$B0,$B2
    db $30,$B0,$24,$AF,$0C,$C7

MusicB2S08P26:
    db $DA,$00,$60,$79,$C6,$18,$C6,$0C
    db $AA,$AB,$18,$AC,$AD,$30,$AD,$0C
    db $C6,$AC,$AD,$B0,$24,$B3,$06,$B2
    db $B0,$30,$B2

MusicB2S08P29:
    db $18,$6B,$C7,$B3,$B2,$B0,$60,$B2
    db $18,$C7,$B2,$B0,$B2,$30,$B0,$AF

MusicB2S08P28:
    db $DA,$01,$18,$7C,$C7,$AD,$AA,$AA
    db $30,$AA,$A4,$18,$C7,$AA,$AA,$AA
    db $30,$AB,$A9,$DA,$00,$E2,$32,$60
    db $6F,$C7,$00

MusicB2S05P00:
    db $F0,$DA,$00,$E2,$32,$DB,$0A,$E7
    db $C8,$DE,$18,$14,$20,$0C,$6F,$BA
    db $3C,$B8,$0C,$B5,$24,$B3,$0C,$AE
    db $54,$AC,$00

MusicB2S05P03:
    db $DA,$04,$DB,$0A,$E7,$C8,$DE,$18
    db $15,$20,$0C,$6F,$BA,$3C,$B8,$0C
    db $B5,$24,$B3,$0C,$AE,$54,$AC

MusicB2S05P04:
    db $DA,$04,$DB,$0A,$E7,$C8,$DE,$18
    db $13,$20,$0C,$6F,$A1,$3C,$9F,$0C
    db $9C,$24,$9A,$0C,$95,$30,$93,$E7
    db $FF,$24,$7F,$98,$DD,$0C,$0C,$8C

MusicB2S05P01:
    db $DA,$04,$DB,$0F,$E7,$C8,$DE,$18
    db $14,$20,$0C,$6F,$B5,$3C,$B3,$0C
    db $B0,$24,$AE,$0C,$A9,$54,$A7,$00

MusicB2S05P02:
    db $DA,$04,$DB,$05,$E7,$C8,$DE,$18
    db $14,$20,$0C,$6F,$B0,$3C,$AE,$0C
    db $AB,$24,$A9,$0C,$A4,$54,$A2

MusicB2S05P05:
    db $DA,$04,$DB,$14,$E7,$C8,$DE,$18
    db $13,$20,$0C,$6F,$AC,$3C,$AA,$0C
    db $A7,$24,$A5,$0C,$A0,$54,$9E

MusicB2S05P06:
    db $DA,$04,$DB,$00,$E7,$C8,$DE,$18
    db $15,$20,$0C,$6F,$A6,$3C,$A4,$0C
    db $AD,$24,$9F,$0C,$9A,$54,$98

MusicB2S05P07:
    db $DA,$01,$DB,$0F,$E7,$C8,$0C,$6D
    db $B0,$C7,$C7,$B0,$C7,$B0,$B0,$B0
    db $B0,$C7,$C7,$B3,$C6,$B1,$B3,$B1
    db $B0,$C7,$C7,$B0,$C7,$B0,$B0,$B0
    db $B0,$C7,$C7,$B3,$C6,$C6,$C7,$C7
    db $00

MusicB2S05P0C:
    db $12,$C7

MusicB2S05P0D:
    db $DA,$04,$DB,$0A,$E7,$C8,$60,$C7
    db $18,$7C,$C7,$60,$9D,$DD,$00,$60
    db $C1,$C6,$48,$C6

MusicB2S05P0A:
    db $DA,$01,$DB,$05,$E7,$C8,$0C,$6D
    db $AB,$C7,$C7,$AB,$C7,$AB,$AB,$AB
    db $AB,$C7,$C7,$AE,$C6,$AC,$AE,$AC
    db $AB,$C7,$C7,$AB,$C7,$AB,$AB,$AB
    db $AB,$C7,$C7,$AE,$C6,$C6,$C7,$C7

MusicB2S05P0B:
    db $DA,$01,$DB,$0A,$E7,$C8,$0C,$6D
    db $A6,$C7,$C7,$A6,$C7,$A6,$A6,$A6
    db $A6,$C7,$C7,$A9,$C6,$A7,$A9,$A7
    db $A6,$C7,$C7,$A6,$C7,$A6,$A6,$A6
    db $A6,$C7,$C7,$A9,$C6,$C6,$C7,$C7

MusicB2S05P08:
    db $DA,$0A,$DB,$0A,$E7,$C8,$E9,$C2
    db $35,$04,$0C,$6F,$D6,$D7,$D7,$D6
    db $D7,$D7,$D6,$D7,$00

MusicB2S05P1E:
    db $E9,$C2,$35,$03,$0C,$D6,$D7,$D7
    db $06,$D6,$D6,$0C,$D6,$D6,$D6,$D6

MusicB2S05P09:
    db $DA,$04,$E7,$C8,$DB,$0A,$DE,$23
    db $14,$40,$24,$6D,$8C,$93,$18,$98
    db $24,$8D,$94,$18,$99

MusicB2S05P1F:
    db $24,$8C,$93,$18,$98,$24,$8D,$94
    db $18,$99,$24,$8C,$93,$18,$98,$24
    db $8D,$3C,$99,$DD,$18,$24,$8D,$DA
    db $02,$E7,$FF,$DB,$0A,$DE,$22,$28
    db $20,$18,$6D,$B3,$C6,$B0,$AB,$18
    db $AC,$48,$B0,$18,$C7,$AB,$B0,$B7
    db $30,$B3,$C6

MusicB2S05P0E:
    db $DA,$01,$0C,$6D,$B5,$C7,$C7,$B5
    db $C7,$B5,$B5,$B5,$B5,$C7,$C7,$B8
    db $C6,$B6,$B8,$B6,$B5,$C7,$C7,$B5
    db $C7,$B5,$B5,$B5,$B5,$C7,$C7,$B8
    db $C6,$C6,$C7,$C7,$00

MusicB2S05P0F:
    db $12,$69,$C7

MusicB2S05P10:
    db $DA,$04,$0C,$C6,$BE,$BF,$BE,$BF
    db $BE,$BC,$BB,$B8,$B6,$B2,$AD,$AC
    db $AA,$A9,$A7,$A6,$A9,$AC,$AF,$C7
    db $C7,$A9,$AC,$AF,$B2,$C7,$C7,$AF
    db $B3,$B5,$B8

MusicB2S05P12:
    db $DA,$01,$0C,$6D,$B0,$C7,$C7,$B0
    db $C7,$B0,$B0,$B0,$B0,$C7,$C7,$B3
    db $C6,$B1,$B3,$B1,$B0,$C7,$C7,$B0
    db $C7,$B0,$B0,$B0,$B0,$C7,$C7,$B3
    db $C6,$C6,$C7,$C7

MusicB2S05P13:
    db $DA,$01,$0C,$6D,$AB,$C7,$C7,$AB
    db $C7,$AB,$AB,$AB,$AB,$C7,$C7,$AE
    db $C6,$AC,$AE,$AC,$AB,$C7,$C7,$AB
    db $C7,$AB,$AB,$AB,$AB,$C7,$C7,$AE
    db $C6,$C6,$C7,$C7

MusicB2S05P11:
    db $DA,$04,$24,$6D,$91,$98,$18,$9D
    db $24,$92,$99,$18,$9E,$24,$91,$98
    db $18,$9D,$24,$92,$99,$18,$9E,$DA
    db $02,$18,$6D,$B3,$C6,$B0,$AB,$18
    db $AC,$48,$B0,$18,$C7,$AB,$B0,$B7
    db $30,$B3,$C6

MusicB2S05P16:
    db $DA,$01,$0C,$6D,$B7,$B7,$C7,$B7
    db $C7,$B7,$C7,$B7,$C7,$C7,$C7,$B7
    db $C6,$B6,$B5,$C6,$B4,$B4,$C7,$B4
    db $C7,$B4,$C7,$B4,$C7,$C7,$C7,$B4
    db $C6,$B3,$B2,$C6,$00

MusicB2S05P1B:
    db $DA,$01,$0C,$6D,$B2,$B2,$C7,$B2
    db $C7,$B2,$C7,$B2,$C7,$C7,$C7,$B2
    db $C6,$B1,$B0,$C6,$AF,$AF,$C7,$AF
    db $C7,$AF,$C7,$AF,$C7,$C7,$C7,$AF
    db $C6,$AE,$AD,$C6

MusicB2S05Pu00:
    db $DA,$01,$0C,$6D,$AD,$AD,$C7,$AD
    db $C7,$AD,$C7,$AD,$C7,$C7,$C7,$AD
    db $C6,$AC,$AB,$C6,$AA,$AA,$C7,$AA
    db $C7,$AA,$C7,$AA,$C7,$C7,$C7,$AA
    db $C6,$A9,$A8,$C6

MusicB2S05P1A:
    db $DA,$04,$0C,$6D,$90,$90,$C7,$90
    db $C7,$90,$C7,$90,$C7,$C7,$C7,$90
    db $C6,$8F,$8E,$C6,$8D,$8D,$C7,$8D
    db $C7,$8D,$C7,$8D,$C7,$C7,$C7,$8D
    db $C6,$8C,$8B,$C6

MusicB2S05P19:
    db $DA,$0A,$DB,$0A,$E7,$C8,$E9,$7E
    db $37,$02,$0C,$D6,$D6,$D7,$D6,$D7
    db $D6,$D6,$D6,$D6,$D7,$D7,$D6,$D7
    db $D6,$D6,$D7,$00,$DA,$02,$18,$6D
    db $B3,$C6,$B0,$AB,$18,$AC,$48,$B0
    db $18,$C7,$AB,$B0,$B7,$30,$B3,$C6

MusicB2S05P14:
    db $12,$69,$B8

MusicB2S05P15:
    db $DA,$04,$0C,$C6,$C6,$B9,$C6,$B8
    db $C6,$B6,$B5,$B3,$AF,$AE,$AC,$A7
    db $A9,$AB,$B0,$B3,$B2,$B0,$B2,$C6
    db $B9,$B3,$B0,$AF,$B0,$AF,$AE,$AC
    db $A7,$A9,$AB

MusicB2S05P17:
    db $12,$69,$AB

MusicB2S05P18:
    db $DA,$04,$0C,$AE,$AB,$AE,$B0,$AE
    db $B0,$B3,$B0,$B3,$B5,$B3,$B5,$B7
    db $B5,$B7,$BA,$BB,$C6,$BA,$B9,$B8
    db $B7,$C6,$B7,$B5,$B1,$AF,$AB,$A9
    db $B1,$AF,$C6

MusicB2S05P1C:
    db $12,$69,$C6

MusicB2S05P1D:
    db $DA,$04,$0C,$AF,$B0,$B2,$B5,$C6
    db $B5,$B3,$B2,$B0,$A9,$C6,$A9,$C6
    db $A7,$60,$A9,$DD,$24,$48,$9D,$C6
    db $C6

MusicB2S05P20:
    db $06,$69,$C7

MusicB2S05P21:
    db $DA,$05,$60,$C6,$24,$B5,$B8,$B4
    db $BA,$B8,$BB,$C6,$C6,$60,$C6,$C6

MusicB2S05P22:
    db $06,$69,$C6

MusicB2S05P23:
    db $DA,$05,$0C,$B5,$C6,$B8,$B9,$BA
    db $BB,$BA,$B9,$B5,$C6,$B0,$B8,$C6
    db $BA,$C6,$BA,$BB,$BA,$BB,$BA,$B8
    db $B5,$C6,$B0,$B3,$B5,$C6,$C6,$C6
    db $C6,$C6,$C6

MusicB2S11P00:
    db $DA,$00,$E2,$46,$DB,$00,$DC,$60
    db $14,$6C,$7E,$B5,$DD,$18,$24,$A4
    db $DD,$00,$18,$B0,$DD,$00,$0C,$B5
    db $00

MusicB2S11P01:
    db $DA,$00,$DB,$14,$DC,$60,$00,$6C
    db $7E,$A9,$DD,$18,$24,$98,$DD,$00
    db $18,$A4,$DD,$00,$0C,$A9,$00

MusicB2S0FP00:
    db $F0,$E0,$64,$E1,$30,$FF,$DA,$01
    db $E2,$14,$DB,$0A,$DC,$30,$00,$60
    db $6F,$A9,$DD,$0A,$30,$C1,$00

MusicB2S0FP01:
    db $DA,$01,$DB,$0A,$DC,$30,$14,$60
    db $6F,$A9,$DD,$0A,$30,$91,$00

MusicB2S0FP02:
    db $DA,$01,$DB,$0A,$DC,$30,$00,$60
    db $6F,$98,$DD,$0A,$30,$B5,$00

MusicB2S0FP03:
    db $DA,$01,$DB,$0A,$DC,$30,$14,$60
    db $6F,$A4,$DD,$0A,$30,$9D,$00

MusicB2S0FP04:
    db $DA,$01,$DB,$0A,$DC,$30,$00,$60
    db $6F,$9D,$DD,$0A,$30,$B0,$00

MusicB2S0FP05:
    db $DA,$01,$DB,$0A,$DC,$30,$14,$60
    db $6F,$91,$DD,$0A,$30,$98,$00

MusicB2S0FP06:
    db $DA,$01,$DB,$0A,$DC,$30,$00,$60
    db $6F,$9D,$DD,$0A,$30,$91,$00

MusicB2S0FP07:
    db $DA,$01,$DB,$0A,$DC,$30,$14,$60
    db $6F,$A9,$DD,$0A,$30,$8C,$00

MusicB2S0EP00:
    db $E2,$20,$00

MusicB2S0EP04:
    db $E3,$FF,$30,$00

MusicB2S0EP05:
    db $E3,$FF,$40,$00

MusicB2S0EP01:
    db $DA,$03,$DB,$00,$DC,$60,$14,$18
    db $6F,$C7,$10,$A4,$08,$9F,$C7,$AB
    db $9F,$A4,$C6,$9F,$DC,$60,$00,$18
    db $C7,$10,$A5,$08,$A0,$C7,$AC,$A0
    db $A5,$C6,$A0,$00

MusicB2S0EP03:
    db $DA,$0C,$DB,$0A,$08,$6B,$B0,$B0
    db $B9,$B9,$B0,$B0,$B9,$B9,$B0,$B0
    db $B9,$B9,$B0,$B0,$B9,$B9,$B0,$B0
    db $B9,$B9,$B0,$B0,$B9,$B9,$00

MusicB2S0EP02:
    db $DA,$03,$DB,$14,$DC,$0A,$00,$10
    db $6F,$8C,$08,$93,$18,$C6,$18,$98
    db $93,$DC,$60,$14,$10,$8D,$08,$94
    db $18,$C6,$18,$99,$94

MusicB2S0DP02:
    db $E2,$38,$DA,$01,$DB,$0A,$18,$3E
    db $B0,$B0,$B0,$0C,$C7,$B0,$C7,$24
    db $B0,$18,$B0,$B0,$AF,$AF,$AF,$0C
    db $C7,$AF,$C6,$24,$AF,$18,$AF,$AF
    db $00

MusicB2S0DP00:
    db $DA,$01,$DB,$00,$18,$3E,$AD,$AD
    db $AD,$0C,$C7,$AD,$C7,$24,$AD,$18
    db $AD,$AD,$AB,$AB,$AB,$0C,$C7,$AB
    db $C6,$24,$AB,$18,$AB,$AB

MusicB2S0DP03:
    db $DA,$01,$DB,$14,$18,$3E,$A9,$A9
    db $A9,$0C,$A6,$18,$A9,$A9,$0C,$A6
    db $A9,$A6,$18,$A9,$A8,$A8,$A8,$0C
    db $A4,$18,$A8,$A8,$0C,$A4,$A8,$A4
    db $18,$A8

MusicB2S0DP01:
    db $DA,$08,$DB,$0A,$30,$5E,$8E,$24
    db $95,$9A,$18,$C7,$95,$9A,$30,$8C
    db $24,$93,$98,$18,$C7,$93,$98

MusicB2S0DP04:
    db $DB,$14,$0C,$6D,$D1,$D1,$D1,$D1
    db $18,$D2,$0C,$D1,$D1,$D1,$D1,$D1
    db $D1,$18,$D2,$0C,$D1,$D1,$D1,$D1
    db $D1,$D1,$18,$D2,$0C,$D1,$D1,$D1
    db $D1,$D1,$D1,$18,$D2,$0C,$D1,$D1

MusicB2S0BP00:
    db $F0,$DA,$02,$DB,$14,$DC,$54,$00
    db $54,$7F,$A4,$DD,$00,$0C,$B7,$DD
    db $00,$18,$B0,$DD,$00,$30,$A4,$00

MusicB2S0BP01:
    db $DA,$02,$DB,$14,$DC,$54,$00,$54
    db $7E,$9F,$DD,$00,$0C,$B0,$DD,$00
    db $18,$AB,$DD,$00,$30,$9F,$00

MusicB2S0CP01:
    db $DA,$05,$E2,$38,$DB,$0A,$DE,$00
    db $00,$00,$08,$5B,$B0,$C6,$C6,$08
    db $5C,$B0,$C7,$08,$5B,$B9,$B0,$C6
    db $C6,$08,$5C,$B0,$C7,$08,$5B,$B9
    db $B0,$C6,$C6,$08,$5C,$B0,$C7,$08
    db $5B,$B9,$B0,$C6,$C6,$08,$5C,$B0
    db $C7,$08,$5B,$B9,$B0,$C6,$C6,$08
    db $5C,$B0,$C7,$08,$5B,$B9,$B0,$C6
    db $C6,$08,$5C,$B0,$C7,$08,$5B,$B9
    db $B0,$C6,$C6,$08,$5C,$B0,$C7,$08
    db $5B,$B9,$B0,$C6,$C6,$08,$5C,$B0
    db $C7,$08,$5B,$B9,$60,$B0,$C7,$08
    db $B0,$C6,$C6,$08,$5C,$B0,$C7,$08
    db $5B,$B9,$B0,$C6,$C6,$08,$5C,$B0
    db $C7,$08,$5B,$B9,$B0,$C6,$C6,$C7
    db $C7,$C7,$18,$B0,$C7

MusicB2S0CP03:
    db $DA,$05,$DB,$0F,$01,$C7,$08,$49
    db $B9,$C6,$C6,$B9,$C7,$B0,$B9,$C6
    db $C6,$B9,$C7,$B0,$B9,$C6,$C6,$B9
    db $C7,$B0,$B9,$C6,$C6,$B9,$C7,$B0
    db $B9,$C6,$C6,$B9,$C7,$B0,$B9,$C6
    db $C6,$B9,$C7,$B0,$B9,$C6,$C6,$B9
    db $C7,$B0,$B9,$C6,$C6,$B9,$C7,$B0
    db $60,$BA,$C7,$08,$B9,$C6,$C6,$B9
    db $C7,$B0,$B9,$C6,$C6,$B9,$C7,$B0
    db $B9,$C6,$C6,$C7,$C7,$C7,$18,$B9
    db $C7

MusicB2S0CP04:
    db $DA,$06,$DB,$05,$DE,$23,$14,$20
    db $30,$3C,$B0,$B0,$0C,$AD,$C7,$30
    db $B0,$0C,$AD,$C7,$18,$6C,$B0,$18
    db $2B,$AD,$A9,$60,$6C,$B0,$0C,$AD
    db $C7,$18,$5C,$B4,$18,$1B,$B5,$B4
    db $B5,$24,$3C,$B4,$0C,$AB,$B7,$B5
    db $B4,$C6,$60,$6C,$B0,$18,$C7,$C7
    db $BC,$C7

MusicB2S0CP00:
    db $DA,$04,$E2,$38,$DB,$0A,$DE,$23
    db $14,$20,$30,$3C,$B5,$B5,$0C,$B2
    db $C7,$30,$B5,$0C,$B2,$C7,$18,$6C
    db $B5,$18,$2B,$B2,$B0,$60,$6C,$B5
    db $0C,$B2,$C7,$18,$5C,$BC,$18,$1B
    db $BE,$BC,$BE,$24,$3C,$BC,$0C,$B0
    db $BA,$B9,$B7,$C6,$60,$6C,$B5,$18
    db $C7,$C7,$C1,$C7,$00

MusicB2S0CP05:
    db $DA,$06,$DB,$0F,$DE,$23,$14,$20
    db $30,$3C,$AD,$AD,$0C,$A9,$C7,$30
    db $AD,$0C,$A9,$C7,$18,$6C,$AD,$18
    db $2B,$A9,$A9,$60,$6C,$AD,$0C,$A9
    db $C7,$18,$C7,$C7,$C7,$C7,$24,$C7
    db $0C,$A8,$B4,$B0,$AE,$C6,$60,$6C
    db $AD,$18,$C7,$C7,$B9,$C7,$00

MusicB2S0CP02:
    db $DA,$04,$DB,$0A,$18,$4B,$91,$C7
    db $91,$C7,$8F,$C7,$8F,$C7,$8E,$C7
    db $8E,$C7,$8D,$C7,$8D,$C7,$8C,$C7
    db $C7,$C7,$C7,$C7,$8E,$90,$91,$C7
    db $8C,$C7,$91,$C7,$91,$C7,$00

MusicB2S0AP00:
    db $F0,$DA,$0D,$E2,$30,$DB,$0D,$30
    db $6D,$9F,$C6,$C6

MusicB2S0AP01:
    db $DA,$0D,$DB,$0C,$04,$C7,$30,$6C
    db $A6,$C6,$C6

MusicB2S0AP02:
    db $DA,$0D,$DB,$0B,$08,$C7,$30,$6C
    db $A9,$C6,$C6

MusicB2S0AP03:
    db $DA,$0D,$DB,$0A,$0B,$C7,$30,$6C
    db $AE,$C6,$C6

MusicB2S0AP04:
    db $DA,$0D,$DB,$09,$0E,$C7,$30,$6C
    db $B2,$C6,$C6

MusicB2S0AP05:
    db $DA,$0D,$DB,$08,$11,$C7,$30,$6C
    db $B5,$30,$6D,$B5,$C6

MusicB2S0AP06:
    db $DA,$0D,$DB,$07,$14,$C7,$30,$6D
    db $B9,$18,$6D,$C6,$B0,$00

MusicB2S0AP07:
    db $DB,$0D,$60,$6D,$98,$C6,$C6

MusicB2S0AP08:
    db $DB,$0C,$04,$C7,$60,$6C,$9F,$C6
    db $C6

MusicB2S0AP09:
    db $DB,$0B,$08,$C7,$60,$6C,$A2,$C6
    db $C6

MusicB2S0AP0A:
    db $DB,$0A,$30,$6C,$AE,$AB,$C6,$C6

MusicB2S0AP0B:
    db $DB,$09,$03,$C7,$30,$6C,$B1,$AE
    db $C6,$C6

MusicB2S0AP0C:
    db $DB,$08,$06,$C7,$30,$6C,$B4,$B1
    db $C6,$C6

MusicB2S0AP0D:
    db $DB,$07,$09,$C7,$30,$6D,$B9,$B4
    db $00

MusicB2S0AP0E:
    db $DB,$0D,$60,$6D,$9D,$C6,$C6,$00

MusicB2S0AP0F:
    db $DB,$0C,$04,$C7,$60,$6C,$A4,$C6
    db $C6

MusicB2S0AP10:
    db $DB,$0B,$08,$C7,$48,$6C,$A8,$30
    db $C6,$C3,$60,$C6,$C6

MusicB2S0AP11:
    db $DB,$0A,$01,$C7,$48,$6C,$AD,$B9
    db $C6,$C6

MusicB2S0AP12:
    db $DB,$09,$03,$C7,$48,$6C,$B0,$18
    db $C6,$60,$BE,$C6

MusicB2S0AP13:
    db $DB,$08,$05,$C7,$60,$6C,$B4,$C6
    db $C6

MusicB2S0AP14:
    db $DB,$07,$07,$C7,$60,$6D,$B7,$C6
    db $C6,$00

MusicB2S09P00:
    db $F0,$DA,$03,$E2,$30,$DB,$0A,$04
    db $6F,$B4,$B2,$B4,$24,$C7,$E2,$34
    db $DA,$09,$0C,$6E,$C4,$C5,$C4,$C5
    db $C1,$BC,$BD,$BE,$B8,$B9,$B5,$B0
    db $B1,$B2,$AC,$AD,$30,$A9,$9D,$00

MusicB2S09P01:
    db $DA,$09,$DB,$0A,$30,$4E,$C7,$18
    db $C7,$AD,$C7,$AB,$C7,$A9,$C7,$A8
    db $18,$A4,$C7,$98,$C7

MusicB2S09P02:
    db $DA,$09,$DB,$0A,$30,$6E,$C7,$18
    db $9D,$18,$4E,$A9,$18,$6E,$9B,$18
    db $4E,$A7,$18,$6E,$9A,$18,$4E,$A6
    db $18,$6E,$98,$18,$4E,$A4,$18,$6E
    db $91,$C7,$30,$91

MusicB2S01P00:
    db $F0,$DA,$09,$E2,$40,$DB,$0A,$DE
    db $00,$00,$00,$0C,$6E,$B4,$0C,$6C
    db $B2,$AE,$24,$6E,$B4,$0C,$6C,$B2
    db $AE,$18,$AD,$18,$6E,$B9,$B9,$C6
    db $00

MusicB2S01P01:
    db $DA,$09,$DB,$14,$24,$6D,$96,$96
    db $18,$C6,$60,$95

MusicB2S01P02:
    db $DA,$09,$DB,$0A,$24,$6D,$9E,$9E
    db $18,$C6,$18,$9F,$B1,$B1,$C6

MusicB2S01P03:
    db $DA,$09,$DB,$00,$24,$6E,$AE,$AE
    db $18,$C6,$18,$A5,$06,$B3,$12,$B4
    db $06,$B3,$12,$B4,$18,$C6

MusicB2S01P13:
    db $DE,$00,$00,$00,$30,$6E,$B9,$24
    db $6D,$B5,$0C,$B0,$B2,$18,$B5,$30
    db $B5,$0C,$B2,$18,$B0,$B5,$B5,$BC
    db $24,$B9,$30,$B7,$0C,$B0,$00

MusicB2S01P14:
    db $18,$6C,$91,$18,$4C,$A4,$18,$6C
    db $95,$18,$4C,$A4,$18,$6C,$96,$18
    db $4C,$A6,$18,$6C,$97,$18,$4C,$A6
    db $18,$6C,$95,$18,$4C,$A4,$18,$6C
    db $94,$18,$4C,$A4,$18,$6C,$93,$18
    db $4C,$A6,$18,$6C,$8C,$18,$4C,$A4

MusicB2S01P15:
    db $18,$4C,$C7,$A1,$C7,$A1,$C7,$A2
    db $C7,$A3,$C7,$A1,$C7,$A1,$C7,$A2
    db $C7,$A2

MusicB2S01P16:
    db $18,$4C,$C7,$A9,$C7,$A9,$C7,$A9
    db $C7,$A9,$C7,$A9,$C7,$A9,$C7,$A9
    db $C7,$A8

MusicB2S01P08:
    db $DA,$0C,$0C,$6F,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5

MusicB2S01P17:
    db $30,$6E,$B9,$24,$6D,$B5,$0C,$B0
    db $B2,$18,$B5,$30,$B5,$0C,$B2,$18
    db $B0,$B5,$0C,$BA,$B9,$B7,$30,$B5
    db $C7,$0C,$C7,$00

MusicB2S01P18:
    db $18,$6C,$91,$18,$4C,$A4,$18,$6C
    db $95,$18,$4C,$A4,$18,$6C,$96,$18
    db $4C,$A6,$18,$6C,$97,$18,$4C,$A6
    db $18,$6C,$93,$18,$4C,$A6,$18,$6C
    db $98,$18,$4C,$A8,$18,$6C,$91,$18
    db $4C,$A4,$18,$6C,$91,$18,$4C,$A4

MusicB2S01P19:
    db $18,$4C,$C7,$A1,$C7,$A1,$C7,$A2
    db $C7,$A3,$C7,$A2,$C7,$A4,$C7,$A1
    db $C7,$A1

MusicB2S01P1A:
    db $18,$4C,$C7,$A9,$C7,$A9,$C7,$A9
    db $C7,$A9,$C7,$A9,$C7,$AB,$C7,$A9
    db $C7,$A9

MusicB2S01P1B:
    db $24,$6D,$B9,$24,$6C,$B5,$18,$B0
    db $24,$6D,$B9,$3C,$6C,$B5,$0C,$6D
    db $B8,$0C,$6C,$B5,$18,$B0,$24,$6D
    db $B8,$6C,$6C,$B7,$00

MusicB2S01P1C:
    db $18,$6B,$96,$18,$4B,$A6,$18,$6B
    db $96,$18,$4B,$A6,$18,$6B,$95,$18
    db $4B,$A4,$18,$6B,$95,$18,$4B,$A4
    db $18,$6B,$94,$18,$4B,$A4,$18,$6B
    db $94,$18,$4B,$A4,$18,$6B,$93,$18
    db $4B,$A6,$18,$6B,$8C,$18,$4B,$A4

MusicB2S01P1D:
    db $18,$4B,$C7,$A2,$C7,$A2,$C7,$A1
    db $C7,$A1,$C7,$A0,$C7,$A0,$C7,$A2
    db $C7,$A2

MusicB2S01P1E:
    db $18,$4B,$C7,$A9,$C7,$A9,$C7,$A9
    db $C7,$A9,$C7,$A9,$C7,$A9,$C7,$A9
    db $C7,$A8

MusicB2S01P1F:
    db $DA,$0C,$0C,$6D,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5

MusicB2S01P20:
    db $24,$6D,$B9,$24,$6C,$B5,$18,$B0
    db $24,$6D,$B9,$3C,$6C,$B5,$0C,$6D
    db $B8,$0C,$6C,$B5,$18,$B0,$60,$BC
    db $30,$C7,$00

MusicB2S01P21:
    db $30,$6E,$B9,$24,$6D,$B5,$0C,$B0
    db $B2,$18,$B5,$30,$B5,$0C,$B7,$0C
    db $6E,$B9,$0C,$6D,$B5,$18,$B0,$24
    db $B2,$60,$B5,$0C,$B2,$18,$5E,$BC
    db $BE,$BC,$BE,$24,$BC,$0C,$B0,$BA
    db $B9,$B7,$C6,$60,$B5,$C7,$00

MusicB2S01P22:
    db $18,$6C,$91,$18,$4C,$A4,$18,$6C
    db $91,$18,$4C,$A4,$18,$6C,$8F,$18
    db $4C,$A4,$18,$6C,$8F,$18,$4C,$A4
    db $18,$6C,$8E,$18,$4C,$A4,$18,$6C
    db $8E,$18,$4C,$A4,$18,$6C,$8D,$18
    db $4C,$A3,$18,$6C,$8D,$18,$4C,$A3
    db $60,$6C,$8C,$30,$C6,$18,$6C,$8E
    db $90,$18,$6C,$91,$18,$4C,$A4,$18
    db $6C,$91,$18,$4C,$A4,$18,$6C,$91
    db $18,$4C,$A4,$18,$6C,$91,$18,$4C
    db $A4

MusicB2S01P23:
    db $18,$4C,$C7,$A1,$C7,$A1,$C7,$A2
    db $C7,$A2,$C7,$A1,$C7,$A1,$C7,$A0
    db $C7,$A0,$A2,$C6,$C6,$C6,$C6,$C6
    db $C6,$C6,$0C,$C7,$C7,$0C,$6E,$A9
    db $18,$6D,$A1,$0C,$6E,$A9,$18,$6D
    db $A1,$0C,$6E,$A9,$18,$6D,$A1,$30
    db $6E,$A9

MusicB2S01P24:
    db $18,$4C,$C7,$A9,$C7,$A9,$C7,$AB
    db $C7,$AB,$C7,$A9,$C7,$A9,$C7,$A9
    db $C7,$A9,$A8,$C6,$C6,$C6,$C6,$C6
    db $C6,$C6,$0C,$C7,$C7,$0C,$6E,$A4
    db $18,$6D,$9D,$0C,$6E,$A4,$18,$6E
    db $9D,$0C,$6E,$A4,$18,$6D,$9D,$0C
    db $A4,$C6,$C6,$9D

MusicB2S01P04:
    db $DB,$0A,$0C,$5C,$C6,$A6,$B2,$AD
    db $B0,$18,$7E,$B2,$0C,$5C,$AD,$B2
    db $AA,$AD,$24,$7E,$B2,$0C,$5C,$A6
    db $C6,$C7,$A6,$B2,$A6,$AB,$18,$7E
    db $B2,$0C,$5C,$A6,$B2,$A6,$AB,$24
    db $7E,$B2,$0C,$5C,$A6,$C6,$00

MusicB2S01P05:
    db $DB,$14,$18,$6C,$8E,$18,$4C,$A6
    db $18,$6C,$95,$18,$4C,$A6,$18,$6C
    db $8E,$18,$4C,$A6,$18,$6C,$95,$18
    db $4C,$A6,$18,$6C,$93,$18,$4C,$A6
    db $18,$6C,$8E,$18,$4C,$A6,$18,$6C
    db $93,$18,$4C,$A6,$18,$6C,$8E,$18
    db $4C,$A6,$18,$6C,$8C,$18,$4C,$A4
    db $18,$6C,$93,$18,$4C,$A4,$18,$6C
    db $8C,$18,$4C,$A4,$18,$6C,$93,$18
    db $4C,$A4,$18,$6C,$91,$18,$4C,$A4
    db $18,$6C,$8C,$18,$4C,$A4,$18,$6C
    db $91,$18,$6D,$91,$18,$7E,$90,$18
    db $7E,$8F

MusicB2S01P06:
    db $DB,$0A,$0C,$5C,$C7,$C7,$AA,$C6
    db $C6,$24,$7E,$AA,$24,$5C,$AA,$54
    db $7E,$AA,$24,$5C,$AE,$24,$7E,$AE
    db $24,$5C,$AE,$3C,$7E,$AE

MusicB2S01P07:
    db $DB,$00,$18,$4C,$C7,$9E,$C7,$9E
    db $C7,$9E,$C7,$9E,$C7,$A2,$C7,$A2
    db $C7,$A2,$C7,$A2

MusicB2S01P09:
    db $0C,$5C,$C6,$A4,$B0,$AB,$AE,$18
    db $7E,$B0,$0C,$5C,$AB,$B0,$A8,$AB
    db $24,$7F,$B0,$0C,$5C,$A4,$C6,$C6
    db $A4,$B0,$A9,$AD,$18,$7E,$B0,$0C
    db $5C,$A9,$18,$7B,$B0,$18,$7D,$B0
    db $18,$7E,$AF,$18,$7E,$AE,$00

MusicB2S01P0A:
    db $18,$6C,$8C,$18,$4C,$A4,$18,$6C
    db $93,$18,$4C,$A4,$18,$6C,$8C,$18
    db $4C,$A4,$18,$6C,$93,$18,$4C,$A4
    db $18,$6C,$91,$18,$4C,$A4,$18,$6C
    db $8C,$18,$4C,$A4,$18,$7C,$91,$18
    db $7C,$91,$18,$7E,$90,$18,$7E,$8F

MusicB2S01P0B:
    db $0C,$5C,$C7,$C7,$A8,$C6,$C6,$24
    db $7E,$A8,$24,$5C,$A8,$54,$7E,$A8
    db $24,$5C,$A9,$24,$7E,$A9,$18,$7B
    db $A1,$18,$7D,$A1,$18,$7E,$A0,$18
    db $7E,$9F

MusicB2S01P0C:
    db $18,$4C,$C7,$9C,$C7,$9C,$C7,$9C
    db $C7,$9C,$C7,$9D,$C7,$9D,$A7,$A7
    db $18,$6E,$A6,$A5

MusicB2S01P0D:
    db $DA,$0C,$0C,$6F,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B5,$B0,$B5,$B0
    db $B5,$B0,$B5,$B0

MusicB2S01P0E:
    db $0C,$5C,$C6,$A8,$B4,$A8,$AB,$18
    db $7E,$B4,$0C,$5C,$A8,$B4,$A8,$AB
    db $24,$7E,$B4,$0C,$5C,$A8,$C6,$C6
    db $A9,$B5,$18,$7E,$A4,$0C,$5C,$B0
    db $B2,$B4,$18,$7E,$B5,$B4,$B5,$C6
    db $00

MusicB2S01P0F:
    db $18,$6C,$8C,$18,$4C,$A4,$18,$6C
    db $93,$18,$4C,$A4,$18,$6C,$8C,$18
    db $4C,$A4,$18,$6C,$93,$18,$4C,$A4
    db $18,$6C,$91,$18,$4C,$A4,$18,$6C
    db $8C,$18,$4C,$A4,$18,$6C,$91,$18
    db $6C,$8C,$18,$6C,$91,$18,$6C,$91

MusicB2S01P10:
    db $0C,$5C,$C7,$C7,$AE,$C6,$C6,$24
    db $7E,$AE,$24,$5C,$AE,$54,$7E,$AE
    db $0C,$5C,$AD,$18,$7E,$A9,$0C,$5C
    db $A9,$A9,$AB,$18,$7E,$AD,$AB,$AD
    db $A1

MusicB2S01P11:
    db $18,$4C,$C7,$9C,$C7,$9C,$C7,$9C
    db $C7,$9C,$C7,$9D,$C7,$9D,$B0,$B0
    db $B0,$A4

MusicB2S01P12:
    db $DA,$0C,$0C,$6F,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B0,$C6,$B5,$C6
    db $B0,$C6,$B5,$B5,$B5,$C6,$B0,$C6
    db $B5,$C6,$B0,$C6

MusicB2S06P00:
    db $EF,$F6,$00,$00,$F1,$04,$6C,$00
    db $F2,$DC,$16,$16,$DA,$03,$E2,$23
    db $24,$C7,$00

MusicB2S06P01:
    db $DA,$03,$E2,$23,$DB,$00,$18,$4E
    db $85,$8A,$0C,$88,$8A,$C7,$85,$C7
    db $85,$8A,$C7,$18,$88,$8A,$85,$8A
    db $0C,$88,$8A,$C7,$85,$C7,$85,$8A
    db $C7,$18,$88,$8A,$00

MusicB2S06P06:
    db $DA,$08,$DB,$05,$DE,$14,$08,$50
    db $18,$6E,$C7,$A0,$24,$9D,$0C,$98
    db $9A,$48,$9D,$0C,$C6,$18,$C7,$98
    db $0C,$9D,$18,$A4,$60,$A0,$DD,$0C
    db $3C,$A1,$60,$C6,$00

MusicB2S06P05:
    db $DA,$08,$DB,$0F,$DE,$14,$08,$50
    db $06,$6B,$C7,$18,$C7,$A0,$24,$9D
    db $0C,$98,$9A,$48,$9D,$0C,$C6,$18
    db $C7,$98,$0C,$9D,$18,$A4,$60,$A0
    db $DD,$0C,$3C,$A1,$60,$C6,$00

MusicB2S06P04:
    db $DA,$03,$E2,$23,$DB,$00,$18,$4E
    db $85,$8A,$0C,$88,$8A,$C7,$85,$C7
    db $85,$8A,$C7,$18,$88,$8A,$85,$8A
    db $0C,$88,$8A,$C7,$85,$C7,$85,$8A
    db $C7,$18,$88,$8A,$00

MusicB2S06P02:
    db $DA,$03,$DB,$14,$0C,$4E,$91,$8C
    db $8F,$8C,$8D,$8B,$8F,$8D,$91,$8C
    db $8F,$8C,$8D,$8B,$8F,$8D,$91,$8C
    db $8F,$8C,$8D,$8B,$8F,$8D,$91,$8C
    db $8F,$8C,$8D,$8B,$8F,$8D,$00

MusicB2S06P03:
    db $DA,$0C,$0C,$6D,$A9,$06,$A6,$A6
    db $0C,$A9,$A6,$C6,$A4,$A4,$C6,$A9
    db $06,$A6,$A6,$0C,$A9,$A6,$C6,$A4
    db $A4,$C6,$A9,$06,$A6,$A6,$0C,$A9
    db $A6,$C6,$A4,$A4,$C6,$A9,$06,$A6
    db $A6,$0C,$A9,$A6,$C6,$A4,$A4,$C6

MusicB2S06P09:
    db $DA,$08,$DB,$05,$24,$5E,$A1,$9D
    db $18,$98,$24,$A1,$30,$9D,$0C,$C7
    db $A0,$9D,$18,$98,$24,$A0,$60,$9F
    db $0C,$C7

MusicB2S06P08:
    db $DA,$08,$DB,$0F,$06,$6B,$C7,$24
    db $A1,$9D,$18,$98,$24,$A1,$30,$9D
    db $0C,$C7,$A0,$9D,$18,$98,$24,$A0
    db $60,$9F,$0C,$C7

MusicB2S06P07:
    db $DA,$03,$DB,$00,$18,$4E,$8A,$8E
    db $0C,$8C,$8E,$C7,$89,$C7,$89,$8E
    db $C7,$18,$8C,$8E,$88,$8E,$0C,$8C
    db $8E,$C7,$87,$C7,$87,$8E,$C7,$18
    db $8C,$8E,$00,$DA,$03,$DB,$14,$0C
    db $4E,$91,$06,$8A,$89,$0C,$8E,$8A
    db $8C,$8A,$8E,$8A,$91,$06,$89,$88
    db $0C,$8C,$89,$8E,$89,$8C,$89,$91
    db $06,$88,$87,$0C,$8B,$88,$8E,$88
    db $8B,$88,$91,$06,$87,$86,$0C,$8A
    db $87,$8E,$87,$8A,$87,$00

MusicB2S07P00:
    db $F0,$DA,$01,$E2,$12,$DB,$0F,$DE
    db $00,$00,$00,$E0,$80,$E1,$60,$FF
    db $06,$67,$BB,$BD,$B9,$BC,$BB,$BD
    db $B9,$BC,$BB,$BD,$B9,$BC,$BB,$BD
    db $B9,$BC,$BB,$BD,$B9,$BC,$BB,$BD
    db $B9,$BC,$BB,$BD,$B9,$BC,$BB,$BD
    db $B9,$BC,$00

MusicB2S07P02:
    db $DA,$02,$DB,$0A,$DE,$00,$00,$00
    db $06,$67,$BB,$BD,$B9,$BC,$BB,$BD
    db $B9,$BC,$BB,$BD,$B9,$BC,$BB,$BD
    db $B9,$BC,$BB,$BD,$B9,$BC,$BB,$BD
    db $B9,$BC,$BB,$BD,$B9,$BC,$BB,$BD
    db $B9,$BC

MusicB2S07P01:
    db $DA,$01,$DB,$05,$DE,$00,$00,$00
    db $06,$67,$B5,$B7,$B4,$B6,$B5,$B7
    db $B4,$B6,$B5,$B7,$B4,$B6,$B5,$B7
    db $B4,$B6,$B5,$B7,$B4,$B6,$B5,$B7
    db $B4,$B6,$B5,$B7,$B4,$B6,$B5,$B7
    db $B4,$B6

MusicB2S07P04:
    db $DA,$0B,$DB,$00,$DE,$00,$00,$00
    db $E7,$A0,$E8,$60,$FF,$60,$7F,$A9
    db $DD,$30,$60,$A7,$E8,$60,$B0,$DC
    db $60,$0A,$60,$C6

MusicB2S07P03:
    db $DA,$0B,$DB,$00,$DE,$00,$00,$00
    db $E7,$A0,$E8,$60,$FF,$60,$7F,$A3
    db $DD,$30,$60,$A1,$E8,$60,$B0,$DC
    db $60,$0A,$60,$C6

MusicB2S07P05:
    db $DA,$01,$DB,$0F,$E0,$80,$E1,$60
    db $FF,$06,$67,$BD,$BF,$BB,$BE,$BD
    db $BF,$BB,$BE,$BD,$BF,$BB,$BE,$BD
    db $BF,$BB,$BE,$BD,$BF,$BB,$BE,$BD
    db $BF,$BB,$BE,$BD,$BF,$BB,$BE,$BD
    db $BF,$BB,$BE,$00

MusicB2S07P07:
    db $DA,$02,$DB,$0A,$06,$67,$BD,$BF
    db $BB,$BE,$BD,$BF,$BB,$BE,$BD,$BF
    db $BB,$BE,$BD,$BF,$BB,$BE,$BD,$BF
    db $BB,$BE,$BD,$BF,$BB,$BE,$BD,$BF
    db $BB,$BE,$BD,$BF,$BB,$BE

MusicB2S07P06:
    db $DA,$01,$DB,$05,$06,$67,$B7,$B9
    db $B6,$B8,$B7,$B9,$B6,$B8,$B7,$B9
    db $B6,$B8,$B7,$B9,$B6,$B8,$B7,$B9
    db $B6,$B8,$B7,$B9,$B6,$B8,$B7,$B9
    db $B6,$B8,$B7,$B9,$B6,$B8

MusicB2S07P09:
    db $DA,$0B,$DB,$0A,$DE,$00,$00,$00
    db $E7,$A0,$E8,$60,$FF,$60,$7F,$AB
    db $DD,$30,$60,$A9,$E8,$60,$B0,$DC
    db $60,$14,$60,$C6

MusicB2S07P08:
    db $DA,$0B,$DB,$0A,$DE,$00,$00,$00
    db $E7,$A0,$E8,$60,$FF,$60,$7F,$A5
    db $DD,$30,$60,$A3,$E8,$60,$B0,$DC
    db $60,$14,$60,$C6

MusicB2S07P0A:
    db $DA,$01,$DB,$0F,$E0,$80,$E1,$60
    db $FF,$06,$67,$BF,$C1,$BD,$C0,$BF
    db $C1,$BD,$C0,$BF,$C1,$BD,$C0,$BF
    db $C1,$BD,$C0,$BF,$C1,$BD,$C0,$BF
    db $C1,$BD,$C0,$BF,$C1,$BD,$C0,$BF
    db $C1,$BD,$C0,$00

MusicB2S07P0C:
    db $DA,$02,$DB,$0A,$06,$67,$BF,$C1
    db $BD,$C0,$BF,$C1,$BD,$C0,$BF,$C1
    db $BD,$C0,$BF,$C1,$BD,$C0,$BF,$C1
    db $BD,$C0,$BF,$C1,$BD,$C0,$BF,$C1
    db $BD,$C0,$BF,$C1,$BD,$C0

MusicB2S07P0B:
    db $DA,$01,$DB,$05,$06,$67,$B9,$BB
    db $B8,$BA,$B9,$BB,$B8,$BA,$B9,$BB
    db $B8,$BA,$B9,$BB,$B8,$BA,$B9,$BB
    db $B8,$BA,$B9,$BB,$B8,$BA,$B9,$BB
    db $B8,$BA,$B9,$BB,$B8,$BA

MusicB2S07P0E:
    db $DA,$0B,$DB,$14,$DE,$00,$00,$00
    db $E7,$A0,$E8,$60,$FF,$60,$7F,$AD
    db $DD,$30,$60,$AB,$E8,$60,$B0,$DC
    db $60,$0A,$60,$C6

MusicB2S07P0D:
    db $DA,$0B,$DB,$14,$DE,$00,$00,$00
    db $E7,$A0,$E8,$60,$FF,$60,$7F,$A7
    db $DD,$30,$60,$A5,$E8,$60,$B0,$DC
    db $60,$0A,$60,$C6

MusicB2S07P0F:
    db $DA,$01,$DB,$0F,$E0,$80,$E1,$60
    db $FF,$06,$67,$C1,$C3,$BF,$C2,$C1
    db $C3,$BF,$C2,$C1,$C3,$BF,$C2,$C1
    db $C3,$BF,$C2,$C1,$C3,$BF,$C2,$C1
    db $C3,$BF,$C2,$C1,$C3,$BF,$C2,$C1
    db $C3,$BF,$C2,$00

MusicB2S07P11:
    db $DA,$02,$DB,$0A,$06,$67,$C1,$C3
    db $BF,$C2,$C1,$C3,$BF,$C2,$C1,$C3
    db $BF,$C2,$C1,$C3,$BF,$C2,$C1,$C3
    db $BF,$C2,$C1,$C3,$BF,$C2,$C1,$C3
    db $BF,$C2,$C1,$C3,$BF,$C2

MusicB2S07P10:
    db $DA,$01,$DB,$05,$06,$67,$BB,$BD
    db $BA,$BC,$BB,$BD,$BA,$BC,$BB,$BD
    db $BA,$BC,$BB,$BD,$BA,$BC,$BB,$BD
    db $BA,$BC,$BB,$BD,$BA,$BC,$BB,$BD
    db $BA,$BC,$BB,$BD,$BA,$BC

MusicB2S07P13:
    db $DA,$0B,$DB,$0A,$E7,$A0,$E8,$60
    db $FF,$60,$7F,$AF,$DD,$30,$60,$AD
    db $E8,$60,$B0,$DC,$60,$00,$60,$C6

MusicB2S07P12:
    db $DA,$0B,$DB,$0A,$E7,$A0,$E8,$60
    db $FF,$60,$7F,$A9,$DD,$30,$60,$A7
    db $E8,$60,$B0,$DC,$60,$00,$60,$C6

MusicB2S07P14:
    db $DA,$01,$E0,$FF,$DB,$0F,$DE,$00
    db $00,$00,$06,$67,$C1,$C3,$BF,$C2
    db $C1,$C3,$BF,$C2,$C1,$C3,$BF,$C2
    db $C1,$C3,$BF,$C2,$C1,$C3,$BF,$C2
    db $C1,$C3,$BF,$C2,$C1,$C3,$BF,$C2
    db $C1,$C3,$BF,$C2,$C1,$C3,$BF,$C2
    db $C1,$C3,$BF,$C2,$C1,$C3,$BF,$C2
    db $C1,$C3,$BF,$C2,$E1,$60,$80,$06
    db $C1,$C3,$BF,$C2,$C1,$C3,$BF,$C2
    db $C1,$C3,$BF,$C2,$C1,$C3,$BF,$C2
    db $00

MusicB2S07P16:
    db $DA,$02,$DB,$0A,$DE,$00,$00,$00
    db $06,$67,$C1,$C3,$BF,$C2,$C1,$C3
    db $BF,$C2,$C1,$C3,$BF,$C2,$C1,$C3
    db $BF,$C2,$C1,$C3,$BF,$C2,$C1,$C3
    db $BF,$C2,$C1,$C3,$BF,$C2,$C1,$C3
    db $BF,$C2,$C1,$C3,$BF,$C2,$C1,$C3
    db $BF,$C2,$C1,$C3,$BF,$C2,$C1,$C3
    db $BF,$C2,$C1,$C3,$BF,$C2,$C1,$C3
    db $BF,$C2,$C1,$C3,$BF,$C2,$C1,$C3
    db $BF,$C2

MusicB2S07P19:
    db $DA,$01,$DB,$05,$DE,$00,$00,$00
    db $06,$67,$BB,$BD,$BA,$BC,$BB,$BD
    db $BA,$BC,$BB,$BD,$BA,$BC,$BB,$BD
    db $BA,$BC,$BB,$BD,$BA,$BC,$BB,$BD
    db $BA,$BC,$BB,$BD,$BA,$BC,$BB,$BD
    db $BA,$BC,$BB,$BD,$BA,$BC,$BB,$BD
    db $BA,$BC,$BB,$BD,$BA,$BC,$BB,$BD
    db $BA,$BC,$BB,$BD,$BA,$BC,$BB,$BD
    db $BA,$BC,$BB,$BD,$BA,$BC,$BB,$BD
    db $BA,$BC

MusicB2S07P18:
    db $DA,$0B,$E7,$FF,$DB,$05,$DE,$14
    db $1E,$70,$30,$7F,$A6,$18,$A3,$9E
    db $9F,$48,$A3,$18,$C6,$9E,$A3,$AA
    db $30,$A6,$A5

MusicB2S07P15:
    db $DA,$0B,$E7,$FF,$DB,$0A,$DE,$14
    db $1E,$70,$12,$7B,$C7,$30,$A6,$18
    db $A3,$9E,$9F,$48,$A3,$18,$C6,$9E
    db $A3,$AA,$30,$A6,$A5

MusicB2S07P17:
    db $DA,$04,$E7,$FF,$DB,$0F,$DE,$00
    db $00,$00,$30,$7E,$8E,$18,$8B,$86
    db $87,$48,$8B,$18,$C6,$86,$8B,$92
    db $30,$8E,$8D

MusicB2S07P1A:
    db $E0,$FF,$06,$67,$BF,$C1,$BD,$C0
    db $BF,$C1,$BD,$C0,$BF,$C1,$BD,$C0
    db $BF,$C1,$BD,$C0,$BF,$C1,$BD,$C0
    db $BF,$C1,$BD,$C0,$BF,$C1,$BD,$C0
    db $BF,$C1,$BD,$C0,$BF,$C1,$BD,$C0
    db $BF,$C1,$BD,$C0,$BF,$C1,$BD,$C0
    db $BF,$C1,$BD,$C0,$E1,$60,$80,$06
    db $BF,$C1,$BD,$C0,$BF,$C1,$BD,$C0
    db $BF,$C1,$BD,$C0,$BF,$C1,$BD,$C0
    db $00

MusicB2S07P1E:
    db $DA,$01,$DB,$05,$06,$67,$B9,$BB
    db $B8,$BA,$B9,$BB,$B8,$BA,$B9,$BB
    db $B8,$BA,$B9,$BB,$B8,$BA,$B9,$BB
    db $B8,$BA,$B9,$BB,$B8,$BA,$B9,$BB
    db $B8,$BA,$B9,$BB,$B8,$BA,$B9,$BB
    db $B8,$BA,$B9,$BB,$B8,$BA,$B9,$BB
    db $B8,$BA,$B9,$BB,$B8,$BA,$B9,$BB
    db $B8,$BA,$B9,$BB,$B8,$BA,$B9,$BB
    db $B8,$BA,$B9,$BB,$B8,$BA

MusicB2S07P1D:
    db $DA,$0B,$E7,$FF,$DB,$05,$DE,$14
    db $1E,$70,$30,$7F,$A4,$18,$A1,$9C
    db $9D,$48,$A1,$18,$C6,$9C,$A1,$A8
    db $30,$A4,$A3

MusicB2S07P1B:
    db $DA,$0B,$E7,$FF,$DB,$0A,$DE,$14
    db $1E,$70,$12,$7B,$C7,$30,$A4,$18
    db $A1,$9C,$9D,$48,$A1,$18,$C6,$9C
    db $A1,$A8,$30,$A4,$A3

MusicB2S07P1C:
    db $DA,$04,$E7,$FF,$DB,$0F,$DE,$00
    db $00,$00,$30,$7E,$8C,$18,$89,$84
    db $85,$48,$89,$18,$C6,$84,$89,$90
    db $30,$8C,$8B

MusicB2S07P1F:
    db $E0,$FF,$06,$67,$BD,$BF,$BB,$BE
    db $BD,$BF,$BB,$BE,$BD,$BF,$BB,$BE
    db $BD,$BF,$BB,$BE,$BD,$BF,$BB,$BE
    db $BD,$BF,$BB,$BE,$BD,$BF,$BB,$BE
    db $BD,$BF,$BB,$BE,$BD,$BF,$BB,$BE
    db $BD,$BF,$BB,$BE,$BD,$BF,$BB,$BE
    db $BD,$BF,$BB,$BE,$E1,$60,$80,$06
    db $BD,$BF,$BB,$BE,$BD,$BF,$BB,$BE
    db $BD,$BF,$BB,$BE,$BD,$BF,$BB,$BE
    db $00

MusicB2S07P23:
    db $DA,$01,$DB,$05,$06,$67,$B7,$B9
    db $B6,$B8,$B7,$B9,$B6,$B8,$B7,$B9
    db $B6,$B8,$B7,$B9,$B6,$B8,$B7,$B9
    db $B6,$B8,$B7,$B9,$B6,$B8,$B7,$B9
    db $B6,$B8,$B7,$B9,$B6,$B8,$B7,$B9
    db $B6,$B8,$B7,$B9,$B6,$B8,$B7,$B9
    db $B6,$B8,$B7,$B9,$B6,$B8,$B7,$B9
    db $B6,$B8,$B7,$B9,$B6,$B8,$B7,$B9
    db $B6,$B8,$B7,$B9,$B6,$B8

MusicB2S07P22:
    db $DA,$0B,$E7,$FF,$DB,$05,$DE,$14
    db $1E,$70,$30,$7F,$A2,$18,$9F,$9A
    db $9B,$48,$9F,$18,$C6,$9A,$9F,$A6
    db $30,$A2,$A1

MusicB2S07P20:
    db $DA,$0B,$E7,$FF,$DB,$0A,$DE,$14
    db $1E,$70,$12,$7B,$C7,$30,$A2,$18
    db $9F,$9A,$9B,$48,$9F,$18,$C6,$9A
    db $9F,$A6,$30,$A2,$A1

MusicB2S07P21:
    db $DA,$04,$E7,$FF,$DB,$0F,$DE,$00
    db $00,$00,$30,$7E,$8A,$18,$87,$82
    db $83,$48,$87,$18,$C6,$82,$87,$8E
    db $30,$8A,$89

MusicB2S02P00:
    db $F0,$DA,$01,$E2,$36,$DB,$0A,$DE
    db $00,$00,$00,$30,$6D,$BE,$24,$BA
    db $0C,$B5,$0C,$B4,$C7,$B5,$B7,$30
    db $C6,$00

MusicB2S02P07:
    db $DA,$02,$DB,$0A,$DE,$00,$00,$00
    db $30,$67,$BE,$24,$BA,$0C,$B5,$0C
    db $B4,$C7,$B5,$B7,$30,$C6,$00

MusicB2S02P04:
    db $DA,$02,$DB,$8A,$DE,$00,$00,$00
    db $06,$65,$C7,$30,$BE,$24,$BA,$0C
    db $B5,$0C,$B4,$C7,$B5,$B7,$30,$C6

MusicB2S02P03:
    db $DA,$01,$DB,$8A,$DE,$00,$00,$00
    db $06,$69,$C7,$30,$BE,$24,$BA,$0C
    db $B5,$0C,$B4,$C7,$B5,$B7,$30,$C6

MusicB2S02P01:
    db $DA,$01,$DB,$0A,$DE,$00,$00,$00
    db $30,$6D,$B5,$24,$B2,$0C,$AE,$0C
    db $AB,$C7,$AD,$AE,$30,$C6

MusicB2S02P06:
    db $DA,$01,$DB,$82,$DE,$00,$00,$00
    db $06,$69,$C7,$30,$B5,$24,$B2,$0C
    db $AE,$0C,$AB,$C7,$AD,$AE,$30,$C6

MusicB2S02P02:
    db $DA,$01,$DB,$0A,$DE,$00,$00,$00
    db $30,$6D,$A2,$24,$9D,$0C,$9A,$0C
    db $98,$C7,$9A,$9C,$30,$C6

MusicB2S02P05:
    db $DA,$01,$DB,$A0,$DE,$00,$00,$00
    db $06,$69,$C7,$30,$A2,$24,$9D,$0C
    db $9A,$0C,$98,$C7,$9A,$9C,$30,$C6

MusicB2S02P08:
    db $DA,$05,$DB,$0A,$DE,$00,$00,$00
    db $08,$5B,$B0,$C6,$C6,$B0,$C7,$B9
    db $B0,$C6,$C6,$B0,$C7,$B9,$B2,$C6
    db $C6,$B2,$C7,$BA,$B1,$C6,$C6,$B1
    db $C7,$BA,$B0,$C6,$C6,$B0,$C7,$B9
    db $B0,$C6,$C6,$B0,$C7,$B9,$B2,$C6
    db $C6,$B1,$C6,$C6,$C6,$C6,$C6,$C6
    db $C6,$C6,$00

MusicB2S02P0D:
    db $DA,$05,$DB,$0F,$DE,$00,$00,$00
    db $01,$49,$C7,$08,$B5,$C6,$C6,$B5
    db $C7,$B5,$B5,$C6,$C6,$B5,$C7,$B5
    db $B5,$C6,$C6,$B5,$C7,$B5,$B4,$C6
    db $C6,$B4,$C7,$B4,$B5,$C6,$C6,$B5
    db $C7,$B5,$B5,$C6,$C6,$B5,$C7,$B5
    db $B5,$C6,$C6,$B4,$C6,$C6,$C6,$C6
    db $C6,$C6,$C6,$C6

MusicB2S02P09:
    db $DA,$05,$DB,$05,$DE,$00,$00,$00
    db $02,$C7,$08,$48,$B9,$C6,$C6,$B9
    db $C7,$B0,$B9,$C6,$C6,$B9,$C7,$B0
    db $BA,$C6,$C6,$BA,$C7,$B2,$BA,$C6
    db $C6,$BA,$C7,$B1,$B9,$C6,$C6,$B9
    db $C7,$B0,$B9,$C6,$C6,$B9,$C7,$B0
    db $BA,$C6,$C6,$BA,$C6,$C6,$C6,$C6
    db $C6,$C6,$C6,$C6

MusicB2S02P0A:
    db $DA,$04,$DB,$0A,$18,$4C,$91,$C7
    db $8E,$C7,$93,$C7,$8C,$C7,$91,$C7
    db $8E,$C7,$93,$92,$C6,$C6

MusicB2S02P0B:
    db $60,$01,$C7,$C7,$C7,$C7

MusicB2S02P0E:
    db $DA,$05,$DB,$0A,$DE,$00,$00,$00
    db $08,$5B,$B0,$C6,$C6,$08,$5C,$B0
    db $C7,$08,$5B,$B9,$B0,$C6,$C6,$08
    db $5C,$B0,$C7,$08,$5B,$B9,$B2,$C6
    db $C6,$08,$5C,$B2,$C7,$08,$5B,$BA
    db $B2,$C6,$C6,$08,$5C,$B2,$C7,$08
    db $5B,$BB,$B0,$C6,$C6,$08,$5C,$B0
    db $C7,$08,$5B,$B9,$B0,$C6,$C6,$08
    db $5C,$B0,$C7,$08,$5B,$B8,$B0,$C6
    db $C6,$08,$5C,$B0,$C7,$08,$5B,$B7
    db $B0,$C6,$C6,$08,$5C,$B0,$C7,$08
    db $5B,$BA,$00

MusicB2S02P0F:
    db $DA,$05,$DB,$05,$02,$C7,$08,$48
    db $B9,$C6,$C6,$B9,$C7,$B0,$B9,$C6
    db $C6,$B9,$C7,$B0,$BA,$C6,$C6,$BA
    db $C7,$B2,$BB,$C6,$C6,$BB,$C7,$B2
    db $B9,$C6,$C6,$B9,$C7,$B0,$B8,$C6
    db $C6,$B8,$C7,$B0,$B7,$C6,$C6,$B7
    db $C7,$B0,$BA,$C6,$C6,$BA,$C7,$B0

MusicB2S02P12:
    db $DA,$05,$DB,$0F,$01,$49,$C7,$08
    db $B5,$C6,$C6,$B5,$C7,$B5,$B5,$C6
    db $C6,$B5,$C7,$B5,$B5,$C6,$C6,$B5
    db $C7,$B5,$B5,$C6,$C6,$B5,$C7,$B5
    db $B4,$C6,$C6,$B4,$C7,$B4,$B3,$C6
    db $C6,$B3,$C7,$B3,$B2,$C6,$C6,$B2
    db $C7,$B2,$B4,$C6,$C6,$B4,$C7,$B4

MusicB2S02P11:
    db $DA,$07,$DB,$0A,$30,$5C,$AD,$24
    db $A9,$0C,$A4,$A6,$18,$A9,$30,$A9
    db $0C,$A6,$18,$A4,$A9,$A9,$B0,$24
    db $AD,$30,$AB,$0C,$A4

MusicB2S02P0C:
    db $DA,$0C,$DB,$0A,$E7,$FF,$0C,$6F
    db $B5,$B9,$B5,$B0,$B2,$C6,$B0,$C6
    db $B0,$B2,$B5,$C6,$B0,$B2,$B5,$C6
    db $B5,$B9,$B5,$B0,$B2,$C6,$B0,$C6
    db $B0,$B2,$B5,$C6,$B0,$C6,$C6,$C6
    db $B5,$B9,$B5,$B0,$B2,$C6,$B0,$C6
    db $B0,$B2,$B5,$C6,$B0,$B2,$B5,$C6
    db $B5,$B9,$B5,$B0,$B2,$C6,$B0,$C6
    db $B0,$B2,$B5,$C6,$B0,$C6,$B0,$B0

MusicB2S02P10:
    db $DA,$04,$18,$4B,$91,$C7,$95,$C7
    db $96,$C7,$97,$C7,$95,$C7,$94,$C7
    db $93,$8C,$8E,$90

MusicB2S02P13:
    db $08,$5B,$B0,$C6,$C6,$08,$5C,$B0
    db $C7,$08,$5B,$B9,$B0,$C6,$C6,$08
    db $5C,$B0,$C7,$08,$5B,$B9,$B2,$C6
    db $C6,$08,$5C,$B2,$C7,$08,$5B,$BA
    db $B2,$C6,$C6,$08,$5C,$B2,$C7,$08
    db $5B,$BB,$B2,$C6,$C6,$08,$5C,$B2
    db $C7,$08,$5B,$BA,$B0,$C6,$C6,$08
    db $5C,$B0,$C7,$08,$5B,$BA,$B0,$C6
    db $C6,$08,$5C,$B0,$C7,$08,$5B,$B9
    db $B0,$C6,$C6,$08,$5C,$B0,$C7,$08
    db $5B,$B9,$00

MusicB2S02P14:
    db $02,$C7,$08,$48,$B9,$C6,$C6,$B9
    db $C7,$B0,$B9,$C6,$C6,$B9,$C7,$B0
    db $BA,$C6,$C6,$BA,$C7,$B2,$BB,$C6
    db $C6,$BB,$C7,$B2,$BA,$C6,$C6,$BA
    db $C7,$B2,$BA,$C6,$C6,$BA,$C7,$B0
    db $B9,$C6,$C6,$B9,$C7,$B0,$B9,$C6
    db $C6,$B9,$C7,$B0

MusicB2S02P17:
    db $01,$C7,$08,$49,$B5,$C6,$C6,$B5
    db $C7,$B5,$B5,$C6,$C6,$B5,$C7,$B5
    db $B5,$C6,$C6,$B5,$C7,$B5,$B5,$C6
    db $C6,$B5,$C7,$B5,$B7,$C6,$C6,$B7
    db $C7,$B7,$B4,$C6,$C6,$B4,$C7,$B4
    db $B5,$C6,$C6,$B5,$C7,$B5,$B5,$C6
    db $C6,$B5,$C7,$B5

MusicB2S02P16:
    db $30,$5C,$AD,$24,$A9,$0C,$A4,$A6
    db $18,$A9,$30,$A9,$0C,$A6,$18,$A4
    db $A9,$0C,$AE,$AD,$AB,$30,$A9,$C7
    db $C7

MusicB2S02P15:
    db $18,$4B,$91,$C7,$95,$C7,$96,$C7
    db $97,$C7,$98,$8C,$90,$93,$91,$8C
    db $91,$C7

MusicB2S02P18:
    db $08,$5B,$B2,$C6,$C6,$08,$5C,$B2
    db $C7,$08,$5B,$BA,$B2,$C6,$C6,$08
    db $5C,$B2,$C7,$08,$5B,$BA,$B0,$C6
    db $C6,$08,$5C,$B0,$C7,$08,$5B,$B9
    db $B0,$C7,$B9,$08,$5C,$B0,$C7,$08
    db $5B,$B9,$AF,$C6,$C6,$08,$5C,$AF
    db $C7,$08,$5B,$B8,$AF,$C6,$C6,$08
    db $5C,$AF,$C7,$08,$5B,$B8,$AE,$C6
    db $C6,$08,$5C,$AE,$C7,$08,$5B,$B7
    db $B0,$C7,$B7,$08,$5C,$B0,$C7,$08
    db $5B,$B7,$00

MusicB2S02P19:
    db $02,$C7,$08,$48,$BA,$C6,$C6,$BA
    db $C7,$B2,$BA,$C6,$C6,$BA,$C7,$B2
    db $B9,$C6,$C6,$B9,$C7,$B0,$B9,$C7
    db $B0,$B9,$C7,$B0,$B8,$C6,$C6,$B8
    db $C7,$AF,$B8,$C6,$C6,$B8,$C7,$AF
    db $B7,$C6,$C6,$B7,$C7,$AE,$B7,$C7
    db $B0,$B7,$C7,$B0

MusicB2S02P1D:
    db $01,$49,$C7,$08,$B5,$C6,$C6,$B5
    db $C7,$B5,$B5,$C6,$C6,$B5,$C7,$B5
    db $B5,$C6,$C6,$B5,$C7,$B5,$B5,$C7
    db $B5,$B5,$C7,$B5,$B2,$C6,$C6,$B2
    db $C7,$B2,$B2,$C6,$C6,$B2,$C7,$B2
    db $B2,$C6,$C6,$B2,$C7,$B2,$B4,$C7
    db $B4,$B4,$C7,$B4

MusicB2S02P1B:
    db $24,$5C,$AD,$A9,$18,$A4,$24,$AD
    db $30,$A9,$0C,$C7,$AC,$A9,$18,$A4
    db $24,$AC,$60,$AB,$0C,$C7

MusicB2S02P1A:
    db $DA,$08,$DB,$0A,$18,$4B,$96,$97
    db $98,$9A,$98,$95,$91,$93,$94,$97
    db $9A,$9D,$9F,$9D,$9C,$98

MusicB2S02P1C:
    db $DA,$0C,$DB,$0A,$E7,$FF,$06,$6F
    db $B5,$B5,$0C,$B9,$B5,$B0,$B2,$C6
    db $B0,$C6,$B5,$B2,$C6,$B5,$B2,$C6
    db $C6,$C6,$06,$B5,$B5,$0C,$B9,$B5
    db $B0,$B2,$C6,$B0,$C6,$B5,$B2,$C6
    db $B5,$B2,$C6,$C6,$C6

MusicB2S02P1E:
    db $08,$5B,$B2,$C6,$C6,$08,$5C,$B2
    db $C7,$08,$5B,$BA,$B2,$C6,$C6,$08
    db $5C,$B2,$08,$5B,$C7,$BA,$B0,$C6
    db $C6,$08,$5C,$B0,$C7,$08,$5B,$B9
    db $B0,$C7,$B9,$08,$5C,$B0,$08,$5B
    db $C7,$B9,$AF,$C6,$C6,$08,$5C,$AF
    db $C7,$08,$5B,$B8,$AF,$C6,$C6,$08
    db $5C,$AF,$08,$5B,$C7,$B8,$AE,$C6
    db $C6,$08,$5C,$AE,$C7,$08,$5B,$B7
    db $B0,$C7,$B0,$08,$5C,$B7,$08,$5B
    db $B0,$B7,$00

MusicB2S02P1F:
    db $02,$C7,$08,$48,$BA,$C6,$C6,$BA
    db $C7,$B2,$BA,$C6,$C6,$BA,$C7,$B2
    db $B9,$C6,$C6,$B9,$C7,$B0,$B9,$C7
    db $B0,$B9,$C7,$B0,$B8,$C6,$C6,$B8
    db $C7,$AF,$B8,$C6,$C6,$B8,$C7,$AF
    db $B7,$C6,$C6,$B7,$C7,$AE,$B7,$C7
    db $B7,$B0,$B7,$B0

MusicB2S02P22:
    db $01,$C7,$08,$49,$B5,$C6,$C6,$B5
    db $C7,$B5,$B5,$C6,$C6,$B5,$C7,$B5
    db $B5,$C6,$C6,$B5,$C7,$B5,$B5,$C7
    db $B5,$B5,$C7,$B5,$B2,$C6,$C6,$B2
    db $C7,$B2,$B2,$C6,$C6,$B2,$C7,$B2
    db $B2,$C6,$C6,$B2,$C7,$B2,$B4,$C7
    db $B4,$B4,$B4,$B4

MusicB2S02P21:
    db $24,$5C,$AD,$A9,$18,$A4,$24,$AD
    db $30,$A9,$0C,$C7,$AC,$A9,$18,$A4
    db $60,$B0,$C6

MusicB2S02P20:
    db $18,$4B,$96,$95,$96,$9A,$9D,$9C
    db $98,$95,$97,$9A,$9D,$97,$96,$9A
    db $98,$9C

MusicB2S02P28:
    db $DA,$05,$DB,$0A,$08,$49,$A6,$C6
    db $C6,$A9,$C6,$C6,$A6,$C7,$A9,$AA
    db $C6,$AB,$AD,$C7,$AC,$AB,$C6,$AA
    db $AD,$C7,$A6,$A7,$C6,$A8,$A9,$C7
    db $C7,$A6,$C6,$C6,$A9,$C7,$AB,$AC
    db $C6,$AD,$AC,$C7,$AD,$A9,$C6,$A6
    db $A4,$C7,$A9,$A1,$C6,$A2

MusicB2S02P29:
    db $DA,$00,$DB,$0A,$DE,$23,$12,$40
    db $0C,$5C,$A6,$18,$A2,$24,$A6,$18
    db $A6,$0C,$A9,$A9,$A8,$30,$A7,$0C
    db $C7,$A6,$18,$A2,$A6,$0C,$C6,$18
    db $A8,$60,$A9

MusicB2S02P2B:
    db $DA,$00,$DB,$05,$DE,$23,$12,$40
    db $0C,$5C,$A9,$18,$A6,$24,$A9,$18
    db $AB,$0C,$AD,$AC,$AB,$30,$AA,$0C
    db $C7,$A9,$18,$A6,$A9,$0C,$C6,$18
    db $AB,$60,$AD,$00

MusicB2S02P2A:
    db $DA,$08,$DB,$0A,$18,$4C,$96,$95
    db $96,$97,$98,$99,$9A,$95,$93,$96
    db $95,$93,$91,$8E,$8C,$91,$00

MusicB2S02P2C:
    db $DA,$0C,$DB,$0A,$E7,$FF,$06,$6F
    db $B5,$B5,$B5,$C6,$B5,$C6,$B5,$C6
    db $0C,$B5,$B5,$B2,$C6,$B5,$B5,$18
    db $B5,$B2,$C6,$06,$B5,$B5,$B5,$C6
    db $B5,$C6,$B5,$C6,$0C,$B5,$B5,$B2
    db $C6,$B5,$B5,$18,$B5,$B2,$C6

MusicB2S02P2D:
    db $DA,$01,$DB,$0A,$0C,$5C,$A6,$18
    db $A2,$24,$A6,$18,$A6,$0C,$A9,$AB
    db $AD,$30,$AE,$0C,$C7,$A6,$18,$A2
    db $A6,$0C,$C6,$18,$A8,$60,$A4

MusicB2S02P2F:
    db $DA,$01,$DB,$0F,$0C,$5C,$A9,$18
    db $A6,$24,$A9,$18,$AB,$0C,$AD,$AE
    db $B0,$30,$B2,$0C,$C7,$A9,$18,$A6
    db $A9,$0C,$C6,$18,$AB,$60,$A9,$00

MusicB2S02P2E:
    db $DA,$08,$DB,$0A,$18,$4C,$96,$95
    db $96,$97,$98,$99,$9A,$95,$93,$96
    db $95,$93,$91,$8C,$91,$C6,$00

MusicB2S02P23:
    db $DA,$05,$DB,$0A,$DE,$00,$00,$00
    db $08,$5B,$B0,$C6,$C6,$08,$5C,$B0
    db $C7,$08,$5B,$B9,$B0,$C6,$C6,$08
    db $5C,$B0,$C7,$08,$5B,$B9,$B0,$C6
    db $C6,$08,$5C,$B0,$C7,$08,$5B,$B9
    db $B0,$C6,$C6,$08,$5C,$B0,$C7,$08
    db $5B,$B9,$B0,$C6,$C6,$08,$5C,$B0
    db $C7,$08,$5B,$B9,$B0,$C6,$C6,$08
    db $5C,$B0,$C7,$08,$5B,$B9,$B0,$C6
    db $C6,$08,$5C,$B0,$C7,$08,$5B,$B9
    db $B0,$C6,$C6,$08,$5C,$B0,$C7,$08
    db $5B,$B9,$48,$B0,$78,$C7,$08,$B0
    db $C6,$C6,$08,$5C,$B0,$C7,$08,$5B
    db $B9,$B0,$C6,$C6,$08,$5C,$B0,$C7
    db $08,$5B,$B9,$B0,$C6,$C6,$08,$5C
    db $B0,$C7,$08,$5B,$B9,$B0,$C6,$C6
    db $08,$5C,$B0,$C7,$08,$5B,$B9,$00

MusicB2S02P24:
    db $DA,$05,$DB,$05,$02,$C7,$08,$48
    db $B9,$C6,$C6,$B9,$C7,$B0,$B9,$C6
    db $C6,$B9,$C7,$B0,$B9,$C6,$C6,$B9
    db $C7,$B0,$B9,$C6,$C6,$B9,$C7,$B0
    db $B9,$C6,$C6,$B9,$C7,$B0,$B9,$C6
    db $C6,$B9,$C7,$B0,$B9,$C6,$C6,$B9
    db $C7,$B0,$B9,$C6,$C6,$B9,$C7,$B0
    db $02,$C7,$48,$BA,$76,$C7,$08,$B9
    db $C6,$C6,$B9,$C7,$B0,$B9,$C6,$C6
    db $B9,$C7,$B0,$B9,$C6,$C6,$B9,$C7
    db $B0,$B9,$C6,$C6,$B9,$C7,$B0

MusicB2S02P27:
    db $DA,$05,$DB,$0F,$01,$C7,$08,$49
    db $B5,$C6,$C6,$B5,$C7,$B5,$B5,$C6
    db $C6,$B5,$C7,$B5,$B5,$C6,$C6,$B5
    db $C7,$B5,$B5,$C6,$C6,$B5,$C7,$B5
    db $B5,$C6,$C6,$B5,$C7,$B5,$B5,$C6
    db $C6,$B5,$C7,$B5,$B5,$C6,$C6,$B5
    db $C7,$B5,$B5,$C6,$C6,$B5,$C7,$B5
    db $01,$C7,$48,$B7,$77,$C7,$08,$B5
    db $C6,$C6,$B5,$C7,$B5,$B5,$C6,$C6
    db $B5,$C7,$B5,$B5,$C6,$C6,$B5,$C7
    db $B5,$B5,$C6,$C6,$B5,$C7,$B5

MusicB2S02P26:
    db $DA,$07,$DB,$0A,$30,$5C,$AD,$24
    db $A9,$0C,$A4,$A6,$18,$A9,$30,$A9
    db $0C,$AB,$AD,$A9,$18,$A4,$24,$A6
    db $60,$A9,$0C,$A6,$18,$B0,$B2,$B0
    db $B2,$24,$B0,$0C,$A4,$AE,$AD,$AB
    db $C6,$60,$A9,$C7

MusicB2S02P25:
    db $DA,$04,$DB,$0A,$18,$4B,$91,$C7
    db $91,$C7,$8F,$C7,$8F,$C7,$8E,$C7
    db $8E,$C7,$8D,$C7,$8D,$C7,$8C,$C7
    db $C7,$C7,$C7,$C7,$8E,$90,$91,$C7
    db $8C,$C7,$91,$C7,$91,$C7

MusicB2S03P00:
    db $F0,$DA,$01,$E2,$32,$DB,$0A,$DE
    db $23,$12,$40,$48,$7E,$BE,$30,$BA
    db $18,$B5,$24,$B4,$0C,$B4,$06,$B5
    db $B6,$48,$B7,$00

MusicB2S03P03:
    db $DA,$01,$DB,$8A,$06,$7B,$C7,$48
    db $BE,$30,$BA,$18,$B5,$24,$B4,$0C
    db $B4,$06,$B5,$B6,$3C,$B7,$0C,$C7

MusicB2S03P02:
    db $DA,$01,$DB,$0A,$DE,$23,$12,$40
    db $48,$6E,$9F,$30,$9F,$18,$9F,$24
    db $8C,$0C,$8C,$06,$8E,$8F,$48,$90
    db $00

MusicB2S03P04:
    db $DA,$01,$DB,$8A,$DE,$23,$12,$40
    db $06,$6B,$C7,$48,$9F,$30,$9F,$18
    db $9F,$24,$8C,$0C,$8C,$06,$8E,$8F
    db $48,$90,$00

MusicB2S03P01:
    db $DA,$01,$DB,$0A,$48,$6E,$B5,$30
    db $B2,$18,$AE,$24,$AB,$0C,$AB,$06
    db $AD,$AD,$48,$AE

MusicB2S03P05:
    db $DA,$01,$DB,$A0,$06,$6E,$C7,$48
    db $B5,$30,$B2,$18,$AE,$24,$AB,$0C
    db $AB,$06,$AD,$AD,$48,$AE

MusicB2S03P08:
    db $DA,$01,$DB,$0A,$DE,$23,$12,$40
    db $48,$3E,$91,$8E,$93,$8C,$91,$8E
    db $93,$18,$8C,$8E,$90,$00

MusicB2S03P06:
    db $DA,$03,$DB,$0A,$DE,$23,$12,$40
    db $48,$79,$C7,$06,$B0,$B2,$B5,$B9
    db $30,$BC,$48,$C7,$06,$B2,$B5,$B7
    db $BA,$30,$BE,$48,$C7,$06,$B0,$B2
    db $B5,$B9,$30,$BC,$48,$C7,$06,$B4
    db $B7,$BA,$BE,$24,$C0,$0C,$2E,$C7

MusicB2S03P07:
    db $DA,$01,$DB,$0A,$18,$4D,$C7,$A4
    db $A4,$C7,$A4,$A4,$C7,$A6,$A6,$C7
    db $A5,$A5,$C7,$A4,$A4,$C7,$A4,$A4
    db $C7,$A6,$A6,$C7,$A5,$A5

MusicB2S03P0A:
    db $DA,$01,$DB,$0A,$18,$4D,$C7,$A1
    db $A1,$C7,$A1,$A1,$C7,$A2,$A2,$C7
    db $A2,$A2,$C7,$A1,$A1,$C7,$A1,$A1
    db $C7,$A2,$A2,$C7,$A2,$A2

MusicB2S03P09:
    db $DA,$0C,$DB,$0A,$18,$6D,$C7,$0C
    db $B0,$B0,$18,$B0,$C7,$AD,$B2,$C7
    db $0C,$B0,$B0,$18,$B0,$C7,$AD,$B2
    db $C7,$0C,$B0,$B0,$18,$B0,$C7,$AD
    db $B2,$C7,$0C,$B0,$B0,$18,$B0,$C7
    db $AD,$B2

MusicB2S03P0E:
    db $DA,$01,$DB,$0A,$DE,$23,$12,$40
    db $12,$7B,$C7,$48,$B9,$30,$B5,$18
    db $B0,$30,$B2,$18,$B5,$48,$B5,$30
    db $B0,$18,$B5,$30,$B5,$18,$BC,$48
    db $B9,$B7

MusicB2S03P0B:
    db $48,$6E,$B9,$30,$B5,$18,$B0,$30
    db $B2,$18,$B5,$48,$B5,$30,$B0,$18
    db $B5,$30,$B5,$18,$BC,$48,$B9,$B7
    db $00

MusicB2S03P10:
    db $DA,$01,$DB,$0F,$DE,$23,$12,$40
    db $48,$7C,$A4,$A5,$A6,$A5,$A4,$A3
    db $A2,$A8

MusicB2S03P18:
    db $DA,$02,$DB,$0A,$48,$6C,$B9,$30
    db $B5,$18,$B0,$30,$B2,$18,$B5,$48
    db $B5,$30,$B0,$18,$B5,$30,$B5,$18
    db $BC,$48,$B9,$B7

MusicB2S03P0D:
    db $DA,$01,$DB,$0A,$DE,$23,$12,$40
    db $48,$3E,$91,$95,$96,$97,$95,$94
    db $93,$18,$8C,$8E,$90

MusicB2S03P0C:
    db $DA,$01,$DB,$0A,$18,$4D,$C7,$A4
    db $A4,$C7,$A4,$A4,$C7,$A6,$A6,$C7
    db $A6,$A6,$C7,$A8,$A8,$C7,$A7,$A7
    db $C7,$A6,$A6,$C7,$A8,$A8

MusicB2S03P0F:
    db $DA,$01,$DB,$0A,$18,$4D,$C7,$A1
    db $A1,$C7,$A1,$A1,$C7,$A2,$A2,$C7
    db $A3,$A3,$C7,$A4,$A4,$C7,$A4,$A4
    db $C7,$A2,$A2,$C7,$A4,$A4

MusicB2S03P14:
    db $12,$7B,$C7

MusicB2S03P11:
    db $48,$B9,$30,$B5,$18,$B0,$30,$B2
    db $18,$B5,$48,$B5,$30,$B0,$18,$B5
    db $BA,$B9,$B7,$48,$B5,$C7,$00

MusicB2S03P17:
    db $DA,$01,$48,$7B,$A4,$A5,$A6,$A5
    db $A4,$A2,$A1,$C6,$00

MusicB2S03P1A:
    db $DA,$01,$48,$7B,$A4,$A5,$A6,$A5
    db $A4,$A8,$A9,$C6,$00

MusicB2S03P19:
    db $DA,$02,$DB,$0A,$48,$6C,$B9,$30
    db $B5,$18,$B0,$30,$B2,$18,$B5,$48
    db $B5,$30,$B0,$18,$B5,$BA,$B9,$B7
    db $48,$B5,$C7,$00

MusicB2S03P13:
    db $DA,$01,$DB,$0A,$48,$3E,$91,$95
    db $96,$97,$93,$98,$18,$91,$98,$95
    db $48,$91,$00

MusicB2S03P15:
    db $DA,$0C,$DB,$0A,$18,$6D,$C7,$0C
    db $B0,$B0,$18,$B0,$C7,$AD,$B2,$C7
    db $0C,$B0,$B0,$18,$B0,$C7,$AD,$B2
    db $C7,$0C,$B0,$B0,$18,$B0,$C7,$AD
    db $B2,$AD,$B0,$B0,$AD,$C7,$C7

MusicB2S03P12:
    db $DA,$01,$DB,$0A,$18,$4D,$C7,$A4
    db $A4,$C7,$A4,$A4,$C7,$A6,$A6,$C7
    db $A6,$A6,$C7,$A6,$A6,$C7,$A4,$A4
    db $C7,$A4,$A4,$C7,$A4,$A4,$00

MusicB2S03P16:
    db $DA,$01,$DB,$0A,$18,$4D,$C7,$A1
    db $A1,$C7,$A1,$A1,$C7,$A2,$A2,$C7
    db $A3,$A3,$C7,$A2,$A2,$C7,$A2,$A2
    db $C7,$A1,$A1,$C7,$A1,$A1,$00

MusicB2S03P1E:
    db $12,$7B,$C7

MusicB2S03P1B:
    db $DA,$01,$48,$B9,$30,$B5,$18,$B0
    db $48,$B9,$B5,$00

MusicB2S03P21:
    db $DA,$00,$60,$67,$B0,$0C,$B1,$B2
    db $B5,$B9,$48,$BC,$B9,$00

MusicB2S03P1D:
    db $DA,$01,$48,$3E,$96,$96,$95,$95
    db $00

MusicB2S03P1C:
    db $DA,$01,$18,$4D,$C7,$A9,$A9,$C7
    db $A9,$A9,$C7,$A9,$A9,$C7,$A9,$A9
    db $00

MusicB2S03P20:
    db $DA,$01,$DB,$0A,$18,$4D,$C7,$A6
    db $A6,$C7,$A6,$A6,$C7,$A4,$A4,$C7
    db $A4,$A4,$C7,$00

MusicB2S03P1F:
    db $DA,$0C,$DB,$0A,$18,$6D,$C7,$B2
    db $B2,$C7,$B2,$AD,$C7,$B2,$B2,$C7
    db $AD,$B2,$C7,$B2,$B2,$C7,$B2,$AD
    db $C7,$B2,$B2,$C7,$AD,$B2

MusicB2S03P25:
    db $12,$C6

MusicB2S03P22:
    db $48,$B8,$30,$B5,$18,$B8,$48,$B7
    db $C7,$00

MusicB2S03P27:
    db $60,$AF,$0C,$B0,$B2,$B5,$B8,$48
    db $BA,$B7,$00

MusicB2S03P24:
    db $48,$94,$94,$93,$18,$8C,$8E,$90
    db $00

MusicB2S03P23:
    db $18,$C7,$A9,$A9,$C7,$A9,$A9,$C7
    db $A9,$A9,$C7,$A8,$A8,$00

MusicB2S03P26:
    db $18,$C7,$A3,$A3,$C7,$A3,$A3,$C7
    db $A2,$A2,$C7,$A4,$A4,$C7,$00

MusicB2S03P29:
    db $12,$C6

MusicB2S03P28:
    db $48,$B8,$30,$B5,$18,$B0,$48,$BC
    db $C6,$00

MusicB2S03P2A:
    db $60,$AF,$0C,$B0,$B1,$B2,$B5,$48
    db $B9,$B7,$00


    base off

MusicBank2_End:
    dw $0000,SPCEngine

if ver_is_japanese(!_VER)                     ;\======================== J ====================
    db $98,$00,$00,$00,$00,$01,$FF,$00        ;!
    db $00,$00,$00,$00,$00                    ;!
else                                          ;<================= U, SS, E0, & E1 =============
    db $E0,$00,$00,$00,$00                    ;!
    db $00,$00,$00,$00,$00,$00,$00,$00        ;!
    db $00,$00,$00,$00,$00,$00,$00,$00        ;!
endif                                         ;/===============================================

    %insert_empty($F00,$F10,$F10,$F10,$F10)