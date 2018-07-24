DATA_048000:          .db $80,$B4,$98,$B4,$B0,$B4         ;; 048000               ;
                                                          ;;                      ;
DATA_048006:          .db $00,$B3,$18,$B3,$30,$B3,$48,$B3 ;; 048006               ;
                      .db $60,$B3,$78,$B3,$90,$B3,$A8,$B3 ;; ?QPWZ?               ;
                      .db $C0,$B3,$D8,$B3,$F0,$B3,$08,$B4 ;; ?QPWZ?               ;
                      .db $20,$B4,$38,$B4,$50,$B4,$68,$B4 ;; ?QPWZ?               ;
                      .db $80,$B4,$98,$B4,$B0,$B4,$C8,$B4 ;; ?QPWZ?               ;
                      .db $E0,$B4,$F8,$B4,$10,$B5,$28,$B5 ;; ?QPWZ?               ;
                      .db $40,$B5,$58,$B5,$70,$B5,$88,$B5 ;; ?QPWZ?               ;
                      .db $A0,$B5,$B8,$B5,$D0,$B5,$E8,$B5 ;; ?QPWZ?               ;
                      .db $00,$B6,$18,$B6,$30,$B6,$48,$B6 ;; ?QPWZ?               ;
                      .db $60,$B6,$78,$B6,$90,$B6,$A8,$B6 ;; ?QPWZ?               ;
                      .db $C0,$B6,$D8,$B6,$F0,$B6,$08,$B7 ;; ?QPWZ?               ;
                      .db $20,$B7,$38,$B7,$50,$B7,$68,$B7 ;; ?QPWZ?               ;
                      .db $80,$B7,$98,$B7,$B0,$B7,$C8,$B7 ;; ?QPWZ?               ;
                      .db $E0,$B7,$F8,$B7,$10,$B8,$28,$B8 ;; ?QPWZ?               ;
                      .db $40,$B8,$58,$B8,$70,$B8,$88,$B8 ;; ?QPWZ?               ;
                      .db $A0,$B8,$B8,$B8,$D0,$B8,$E8,$B8 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_048086:          REP #$30                            ;; 048086 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_048088:          STZ $03                             ;; 048088 : 64 03       ;
CODE_04808A:          STZ $05                             ;; 04808A : 64 05       ;
CODE_04808C:          LDX $03                             ;; 04808C : A6 03       ;
CODE_04808E:          LDA.W DATA_048000,X                 ;; 04808E : BD 00 80    ;
CODE_048091:          STA $00                             ;; 048091 : 85 00       ;
CODE_048093:          SEP #$10                            ;; 048093 : E2 10       ; Index (8 bit) 
CODE_048095:          LDY.B #$7E                          ;; 048095 : A0 7E       ;
CODE_048097:          STY $02                             ;; 048097 : 84 02       ;
CODE_048099:          REP #$10                            ;; 048099 : C2 10       ; Index (16 bit) 
CODE_04809B:          LDX $05                             ;; 04809B : A6 05       ;
CODE_04809D:          JSR.W CODE_0480B9                   ;; 04809D : 20 B9 80    ;
CODE_0480A0:          LDA $05                             ;; 0480A0 : A5 05       ;
CODE_0480A2:          CLC                                 ;; 0480A2 : 18          ;
CODE_0480A3:          ADC.W #$0020                        ;; 0480A3 : 69 20 00    ;
CODE_0480A6:          STA $05                             ;; 0480A6 : 85 05       ;
CODE_0480A8:          LDA $03                             ;; 0480A8 : A5 03       ;
CODE_0480AA:          INC A                               ;; 0480AA : 1A          ;
CODE_0480AB:          INC A                               ;; 0480AB : 1A          ;
CODE_0480AC:          STA $03                             ;; 0480AC : 85 03       ;
CODE_0480AE:          AND.W #$00FF                        ;; 0480AE : 29 FF 00    ;
CODE_0480B1:          CMP.W #$0006                        ;; 0480B1 : C9 06 00    ;
CODE_0480B4:          BNE CODE_04808C                     ;; 0480B4 : D0 D6       ;
CODE_0480B6:          SEP #$30                            ;; 0480B6 : E2 30       ; Index (8 bit) Accum (8 bit) 
Return0480B8:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0480B9:          LDY.W #$0000                        ;; 0480B9 : A0 00 00    ; Index (16 bit) Accum (16 bit) 
CODE_0480BC:          LDA.W #$0008                        ;; 0480BC : A9 08 00    ;
CODE_0480BF:          STA $07                             ;; 0480BF : 85 07       ;
CODE_0480C1:          STA $09                             ;; 0480C1 : 85 09       ;
CODE_0480C3:          LDA [$00],Y                         ;; 0480C3 : B7 00       ;
CODE_0480C5:          STA.W $0AF6,X                       ;; 0480C5 : 9D F6 0A    ;
CODE_0480C8:          INY                                 ;; 0480C8 : C8          ;
CODE_0480C9:          INY                                 ;; 0480C9 : C8          ;
CODE_0480CA:          INX                                 ;; 0480CA : E8          ;
CODE_0480CB:          INX                                 ;; 0480CB : E8          ;
CODE_0480CC:          DEC $07                             ;; 0480CC : C6 07       ;
CODE_0480CE:          BNE CODE_0480C3                     ;; 0480CE : D0 F3       ;
CODE_0480D0:          LDA [$00],Y                         ;; 0480D0 : B7 00       ;
CODE_0480D2:          AND.W #$00FF                        ;; 0480D2 : 29 FF 00    ;
CODE_0480D5:          STA.W $0AF6,X                       ;; 0480D5 : 9D F6 0A    ;
CODE_0480D8:          INY                                 ;; 0480D8 : C8          ;
CODE_0480D9:          INX                                 ;; 0480D9 : E8          ;
CODE_0480DA:          INX                                 ;; 0480DA : E8          ;
CODE_0480DB:          DEC $09                             ;; 0480DB : C6 09       ;
CODE_0480DD:          BNE CODE_0480D0                     ;; 0480DD : D0 F1       ;
Return0480DF:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
OW_Tile_Animation:    LDA RAM_FrameCounter                ;; Tile_Animation : A5 13       ; \ ; Index (8 bit) Accum (8 bit) 
CODE_0480E2:          AND.B #$07                          ;; 0480E2 : 29 07       ;  |If lower 3 bits of frame counter isn't 0, 
CODE_0480E4:          BNE CODE_048101                     ;; 0480E4 : D0 1B       ; / don't update the water animation 
CODE_0480E6:          LDX.B #$1F                          ;; 0480E6 : A2 1F       ;
CODE_0480E8:          LDA.W $0AF6,X                       ;; 0480E8 : BD F6 0A    ;
CODE_0480EB:          STA $00                             ;; 0480EB : 85 00       ;
CODE_0480ED:          TXA                                 ;; 0480ED : 8A          ;
CODE_0480EE:          AND.B #$08                          ;; 0480EE : 29 08       ;
CODE_0480F0:          BNE CODE_0480F9                     ;; 0480F0 : D0 07       ;
CODE_0480F2:          ASL $00                             ;; 0480F2 : 06 00       ;
CODE_0480F4:          ROL.W $0AF6,X                       ;; 0480F4 : 3E F6 0A    ;
CODE_0480F7:          BRA CODE_0480FE                     ;; 0480F7 : 80 05       ;
                                                          ;;                      ;
CODE_0480F9:          LSR $00                             ;; 0480F9 : 46 00       ;
CODE_0480FB:          ROR.W $0AF6,X                       ;; 0480FB : 7E F6 0A    ;
CODE_0480FE:          DEX                                 ;; 0480FE : CA          ;
CODE_0480FF:          BPL CODE_0480E8                     ;; 0480FF : 10 E7       ;
CODE_048101:          LDA RAM_FrameCounter                ;; 048101 : A5 13       ; \ 
CODE_048103:          AND.B #$07                          ;; 048103 : 29 07       ;  |If lower 3 bits of frame counter isn't 0, 
CODE_048105:          BNE CODE_04810C                     ;; 048105 : D0 05       ; / don't update the waterfall animation 
CODE_048107:          LDX.B #$20                          ;; 048107 : A2 20       ;
CODE_048109:          JSR.W CODE_048172                   ;; 048109 : 20 72 81    ;
CODE_04810C:          LDA RAM_FrameCounter                ;; 04810C : A5 13       ; \ 
CODE_04810E:          AND.B #$07                          ;; 04810E : 29 07       ;  |If lower 3 bits of frame counter isn't 0, 
CODE_048110:          BNE CODE_048123                     ;; 048110 : D0 11       ; / branch to $8123 
CODE_048112:          LDX.B #$1F                          ;; 048112 : A2 1F       ;
CODE_048114:          LDA.W $0B36,X                       ;; 048114 : BD 36 0B    ;
CODE_048117:          ASL                                 ;; 048117 : 0A          ;
CODE_048118:          ROL.W $0B36,X                       ;; 048118 : 3E 36 0B    ;
CODE_04811B:          DEX                                 ;; 04811B : CA          ;
CODE_04811C:          BPL CODE_048114                     ;; 04811C : 10 F6       ;
CODE_04811E:          LDX.B #$40                          ;; 04811E : A2 40       ;
CODE_048120:          JSR.W CODE_048172                   ;; 048120 : 20 72 81    ;
CODE_048123:          REP #$30                            ;; 048123 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_048125:          LDA.W #$0060                        ;; 048125 : A9 60 00    ;
CODE_048128:          STA $0D                             ;; 048128 : 85 0D       ;
CODE_04812A:          STZ $0B                             ;; 04812A : 64 0B       ;
CODE_04812C:          LDX.W #$0038                        ;; 04812C : A2 38 00    ;
CODE_04812F:          LDA $0B                             ;; 04812F : A5 0B       ;
CODE_048131:          CMP.W #$0020                        ;; 048131 : C9 20 00    ;
CODE_048134:          BCS CODE_048139                     ;; 048134 : B0 03       ;
CODE_048136:          LDX.W #$0070                        ;; 048136 : A2 70 00    ;
CODE_048139:          TXA                                 ;; 048139 : 8A          ;
CODE_04813A:          AND RAM_FrameCounter                ;; 04813A : 25 13       ;
CODE_04813C:          LSR                                 ;; 04813C : 4A          ;
CODE_04813D:          LSR                                 ;; 04813D : 4A          ;
CODE_04813E:          CPX.W #$0038                        ;; 04813E : E0 38 00    ;
CODE_048141:          BEQ CODE_048144                     ;; 048141 : F0 01       ;
CODE_048143:          LSR                                 ;; 048143 : 4A          ;
CODE_048144:          CLC                                 ;; 048144 : 18          ;
CODE_048145:          ADC $0B                             ;; 048145 : 65 0B       ;
CODE_048147:          TAX                                 ;; 048147 : AA          ;
CODE_048148:          LDA.W DATA_048006,X                 ;; 048148 : BD 06 80    ;
CODE_04814B:          STA $00                             ;; 04814B : 85 00       ;
CODE_04814D:          SEP #$10                            ;; 04814D : E2 10       ; Index (8 bit) 
CODE_04814F:          LDY.B #$7E                          ;; 04814F : A0 7E       ;
CODE_048151:          STY $02                             ;; 048151 : 84 02       ;
CODE_048153:          REP #$10                            ;; 048153 : C2 10       ; Index (16 bit) 
CODE_048155:          LDX $0D                             ;; 048155 : A6 0D       ;
CODE_048157:          JSR.W CODE_0480B9                   ;; 048157 : 20 B9 80    ;
CODE_04815A:          LDA $0D                             ;; 04815A : A5 0D       ;
CODE_04815C:          CLC                                 ;; 04815C : 18          ;
CODE_04815D:          ADC.W #$0020                        ;; 04815D : 69 20 00    ;
CODE_048160:          STA $0D                             ;; 048160 : 85 0D       ;
CODE_048162:          LDA $0B                             ;; 048162 : A5 0B       ;
CODE_048164:          CLC                                 ;; 048164 : 18          ;
CODE_048165:          ADC.W #$0010                        ;; 048165 : 69 10 00    ;
CODE_048168:          STA $0B                             ;; 048168 : 85 0B       ;
CODE_04816A:          CMP.W #$0080                        ;; 04816A : C9 80 00    ;
CODE_04816D:          BNE CODE_04812C                     ;; 04816D : D0 BD       ;
CODE_04816F:          SEP #$30                            ;; 04816F : E2 30       ; Index (8 bit) Accum (8 bit) 
Return048171:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_048172:          REP #$20                            ;; 048172 : C2 20       ; Accum (16 bit) 
CODE_048174:          LDY.B #$00                          ;; 048174 : A0 00       ;
CODE_048176:          PHX                                 ;; 048176 : DA          ;
CODE_048177:          TXA                                 ;; 048177 : 8A          ;
CODE_048178:          CLC                                 ;; 048178 : 18          ;
CODE_048179:          ADC.W #$000E                        ;; 048179 : 69 0E 00    ;
CODE_04817C:          TAX                                 ;; 04817C : AA          ;
CODE_04817D:          LDA.W $0AF6,X                       ;; 04817D : BD F6 0A    ;
CODE_048180:          STA $00                             ;; 048180 : 85 00       ;
CODE_048182:          PLX                                 ;; 048182 : FA          ;
CODE_048183:          LDA.W $0AF6,X                       ;; 048183 : BD F6 0A    ;
CODE_048186:          STA $02                             ;; 048186 : 85 02       ;
CODE_048188:          LDA $00                             ;; 048188 : A5 00       ;
CODE_04818A:          STA.W $0AF6,X                       ;; 04818A : 9D F6 0A    ;
CODE_04818D:          LDA $02                             ;; 04818D : A5 02       ;
CODE_04818F:          STA $00                             ;; 04818F : 85 00       ;
CODE_048191:          INX                                 ;; 048191 : E8          ;
CODE_048192:          INX                                 ;; 048192 : E8          ;
CODE_048193:          INY                                 ;; 048193 : C8          ;
CODE_048194:          CPY.B #$08                          ;; 048194 : C0 08       ;
CODE_048196:          BEQ CODE_048176                     ;; 048196 : F0 DE       ;
CODE_048198:          CPY.B #$10                          ;; 048198 : C0 10       ;
CODE_04819A:          BNE CODE_048183                     ;; 04819A : D0 E7       ;
CODE_04819C:          SEP #$20                            ;; 04819C : E2 20       ; Accum (8 bit) 
Return04819E:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04819F:          .db $50,$CF,$00,$03,$7E,$78,$7E,$38 ;; 04819F               ;
                      .db $50,$EF,$00,$03,$7F,$38,$7F,$78 ;; ?QPWZ?               ;
                      .db $51,$C3,$00,$03,$7E,$78,$7D,$78 ;; ?QPWZ?               ;
                      .db $51,$E3,$00,$03,$7E,$F8,$7D,$F8 ;; ?QPWZ?               ;
                      .db $51,$DB,$00,$03,$7D,$38,$7E,$38 ;; ?QPWZ?               ;
                      .db $51,$FB,$00,$03,$7D,$B8,$7E,$B8 ;; ?QPWZ?               ;
                      .db $52,$EF,$00,$03,$7F,$B8,$7F,$F8 ;; ?QPWZ?               ;
                      .db $53,$0F,$00,$03,$7E,$F8,$7E,$B8 ;; ?QPWZ?               ;
                      .db $FF                             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_0481E0:          .db $50,$CF,$40,$02,$FC,$00,$50,$EF ;; 0481E0               ;
                      .db $40,$02,$FC,$00,$51,$C3,$40,$02 ;; ?QPWZ?               ;
                      .db $FC,$00,$51,$E3,$40,$02,$FC,$00 ;; ?QPWZ?               ;
                      .db $51,$DB,$40,$02,$FC,$00,$51,$FB ;; ?QPWZ?               ;
                      .db $40,$02,$FC,$00,$52,$EF,$40,$02 ;; ?QPWZ?               ;
                      .db $FC,$00,$53,$0F,$40,$02,$FC,$00 ;; ?QPWZ?               ;
                      .db $FF                             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_048211:          .db $00,$00,$02,$00,$FE,$FF,$02,$00 ;; 048211               ;
                      .db $00,$00,$02,$00,$FE,$FF,$02,$00 ;; ?QPWZ?               ;
DATA_048221:          .db $00,$00,$11,$01,$EF,$FF,$11,$01 ;; 048221               ;
                      .db $00,$00,$32,$01,$D7,$FF,$32,$01 ;; ?QPWZ?               ;
DATA_048231:          .db $0F,$0F,$07,$07,$07,$03,$03,$03 ;; 048231               ;
                      .db $01,$01,$03,$03,$03,$07,$07,$07 ;; ?QPWZ?               ;
                                                          ;;                      ;
GameMode_0E_Prim:     PHB                                 ;; 0E_Prim : 8B          ;
CODE_048242:          PHK                                 ;; 048242 : 4B          ;
CODE_048243:          PLB                                 ;; 048243 : AB          ;
CODE_048244:          LDX.B #$01                          ;; 048244 : A2 01       ; \ If player 1 pushes select... 
CODE_048246:          LDA.W RAM_OWControllerA,X           ;; 048246 : BD A6 0D    ;  | 
CODE_048249:          AND.B #$20                          ;; 048249 : 29 20       ;  | ...disabled by BRA 
CODE_04824B:          BRA CODE_048261                     ;; 04824B : 80 14       ; / Change to BEQ to enable debug code below 
                                                          ;;                      ;
ADDR_04824D:          LDA.W RAM_PlyrYoshiColor,X          ;; 04824D : BD BA 0D    ; \ Unreachable 
ADDR_048250:          INC A                               ;; 048250 : 1A          ;  | Debug: Change Yoshi color 
ADDR_048251:          INC A                               ;; 048251 : 1A          ;  | 
ADDR_048252:          CMP.B #$04                          ;; 048252 : C9 04       ;  | 
ADDR_048254:          BCS ADDR_048258                     ;; 048254 : B0 02       ;  | 
ADDR_048256:          LDA.B #$04                          ;; 048256 : A9 04       ;  | 
ADDR_048258:          CMP.B #$0B                          ;; 048258 : C9 0B       ;  | 
ADDR_04825A:          BCC ADDR_04825E                     ;; 04825A : 90 02       ;  | 
ADDR_04825C:          LDA.B #$00                          ;; 04825C : A9 00       ;  | 
ADDR_04825E:          STA.W RAM_PlyrYoshiColor,X          ;; 04825E : 9D BA 0D    ; / 
CODE_048261:          DEX                                 ;; 048261 : CA          ;
CODE_048262:          BPL CODE_048246                     ;; 048262 : 10 E2       ;
CODE_048264:          JSR.W CODE_0485A7                   ;; 048264 : 20 A7 85    ;
CODE_048267:          JSR.W OW_Tile_Animation             ;; 048267 : 20 E0 80    ;
CODE_04826A:          LDA.W $13D2                         ;; 04826A : AD D2 13    ; \ If "! blocks flying away color" is 0, 
CODE_04826D:          BEQ CODE_048275                     ;; 04826D : F0 06       ; / don't play the animation 
CODE_04826F:          JSR.W CODE_04F290                   ;; 04826F : 20 90 F2    ;
CODE_048272:          JMP.W CODE_04840D                   ;; 048272 : 4C 0D 84    ;
                                                          ;;                      ;
CODE_048275:          LDA.W $13C9                         ;; 048275 : AD C9 13    ; \ If not showing Continue/End message, 
CODE_048278:          BEQ CODE_048281                     ;; 048278 : F0 07       ; / branch to $8281 
CODE_04827A:          JSL.L CODE_009B80                   ;; 04827A : 22 80 9B 00 ;
CODE_04827E:          JMP.W CODE_048410                   ;; 04827E : 4C 10 84    ;
                                                          ;;                      ;
CODE_048281:          LDA.W $1B87                         ;; 048281 : AD 87 1B    ;
CODE_048284:          BEQ CODE_048295                     ;; 048284 : F0 0F       ;
CODE_048286:          CMP.B #$05                          ;; 048286 : C9 05       ;
CODE_048288:          BCS CODE_04828F                     ;; 048288 : B0 05       ;
CODE_04828A:          LDY.W $0DB2                         ;; 04828A : AC B2 0D    ;
CODE_04828D:          BEQ CODE_048295                     ;; 04828D : F0 06       ;
CODE_04828F:          JSR.W CODE_04F3E5                   ;; 04828F : 20 E5 F3    ;
CODE_048292:          JMP.W CODE_048413                   ;; 048292 : 4C 13 84    ;
                                                          ;;                      ;
CODE_048295:          LDA.W $13D4                         ;; 048295 : AD D4 13    ;
CODE_048298:          LSR                                 ;; 048298 : 4A          ;
CODE_048299:          BNE CODE_04829E                     ;; 048299 : D0 03       ;
CODE_04829B:          JMP.W CODE_048356                   ;; 04829B : 4C 56 83    ;
                                                          ;;                      ;
CODE_04829E:          REP #$20                            ;; 04829E : C2 20       ; Accum (16 bit) 
CODE_0482A0:          LDA.W $1DF2                         ;; 0482A0 : AD F2 1D    ;
CODE_0482A3:          SEC                                 ;; 0482A3 : 38          ;
CODE_0482A4:          SBC RAM_ScreenBndryYLo              ;; 0482A4 : E5 1C       ;
CODE_0482A6:          STA $01                             ;; 0482A6 : 85 01       ;
CODE_0482A8:          BPL CODE_0482AE                     ;; 0482A8 : 10 04       ;
CODE_0482AA:          EOR.W #$FFFF                        ;; 0482AA : 49 FF FF    ;
CODE_0482AD:          INC A                               ;; 0482AD : 1A          ;
CODE_0482AE:          LSR                                 ;; 0482AE : 4A          ;
CODE_0482AF:          SEP #$20                            ;; 0482AF : E2 20       ; Accum (8 bit) 
CODE_0482B1:          STA $05                             ;; 0482B1 : 85 05       ;
CODE_0482B3:          REP #$20                            ;; 0482B3 : C2 20       ; Accum (16 bit) 
CODE_0482B5:          LDA.W $1DF0                         ;; 0482B5 : AD F0 1D    ;
CODE_0482B8:          SEC                                 ;; 0482B8 : 38          ;
CODE_0482B9:          SBC RAM_ScreenBndryXLo              ;; 0482B9 : E5 1A       ;
CODE_0482BB:          STA $00                             ;; 0482BB : 85 00       ;
CODE_0482BD:          BPL CODE_0482C3                     ;; 0482BD : 10 04       ;
ADDR_0482BF:          EOR.W #$FFFF                        ;; 0482BF : 49 FF FF    ;
ADDR_0482C2:          INC A                               ;; 0482C2 : 1A          ;
CODE_0482C3:          LSR                                 ;; 0482C3 : 4A          ;
CODE_0482C4:          SEP #$20                            ;; 0482C4 : E2 20       ; Accum (8 bit) 
CODE_0482C6:          STA $04                             ;; 0482C6 : 85 04       ;
CODE_0482C8:          LDX.B #$01                          ;; 0482C8 : A2 01       ;
CODE_0482CA:          CMP $05                             ;; 0482CA : C5 05       ;
CODE_0482CC:          BCS CODE_0482D1                     ;; 0482CC : B0 03       ;
CODE_0482CE:          DEX                                 ;; 0482CE : CA          ;
CODE_0482CF:          LDA $05                             ;; 0482CF : A5 05       ;
CODE_0482D1:          CMP.B #$02                          ;; 0482D1 : C9 02       ;
CODE_0482D3:          BCS CODE_0482ED                     ;; 0482D3 : B0 18       ;
CODE_0482D5:          REP #$20                            ;; 0482D5 : C2 20       ; Accum (16 bit) 
CODE_0482D7:          LDA.W $1DF0                         ;; 0482D7 : AD F0 1D    ;
CODE_0482DA:          STA RAM_ScreenBndryXLo              ;; 0482DA : 85 1A       ;
CODE_0482DC:          STA $1E                             ;; 0482DC : 85 1E       ;
CODE_0482DE:          LDA.W $1DF2                         ;; 0482DE : AD F2 1D    ;
CODE_0482E1:          STA RAM_ScreenBndryYLo              ;; 0482E1 : 85 1C       ;
CODE_0482E3:          STA $20                             ;; 0482E3 : 85 20       ;
CODE_0482E5:          SEP #$20                            ;; 0482E5 : E2 20       ; Accum (8 bit) 
CODE_0482E7:          STZ.W $13D4                         ;; 0482E7 : 9C D4 13    ;
CODE_0482EA:          JMP.W CODE_0483BD                   ;; 0482EA : 4C BD 83    ;
                                                          ;;                      ;
CODE_0482ED:          STZ.W $4204                         ;; 0482ED : 9C 04 42    ; Dividend (Low Byte)
CODE_0482F0:          LDY $04,X                           ;; 0482F0 : B4 04       ;
CODE_0482F2:          STY.W $4205                         ;; 0482F2 : 8C 05 42    ; Dividend (High-Byte)
CODE_0482F5:          STA.W $4206                         ;; 0482F5 : 8D 06 42    ; Divisor B
CODE_0482F8:          NOP                                 ;; 0482F8 : EA          ; \ 
CODE_0482F9:          NOP                                 ;; 0482F9 : EA          ;  | 
CODE_0482FA:          NOP                                 ;; 0482FA : EA          ;  |Makes you wonder what used to be here... 
CODE_0482FB:          NOP                                 ;; 0482FB : EA          ;  | 
CODE_0482FC:          NOP                                 ;; 0482FC : EA          ;  | 
CODE_0482FD:          NOP                                 ;; 0482FD : EA          ; / 
CODE_0482FE:          REP #$20                            ;; 0482FE : C2 20       ; Accum (16 bit) 
CODE_048300:          LDA.W $4214                         ;; 048300 : AD 14 42    ; Quotient of Divide Result (Low Byte)
CODE_048303:          LSR                                 ;; 048303 : 4A          ;
CODE_048304:          LSR                                 ;; 048304 : 4A          ;
CODE_048305:          SEP #$20                            ;; 048305 : E2 20       ; Accum (8 bit) 
CODE_048307:          LDY $01,X                           ;; 048307 : B4 01       ;
CODE_048309:          BPL CODE_04830E                     ;; 048309 : 10 03       ;
ADDR_04830B:          EOR.B #$FF                          ;; 04830B : 49 FF       ;
ADDR_04830D:          INC A                               ;; 04830D : 1A          ;
CODE_04830E:          STA $01,X                           ;; 04830E : 95 01       ;
CODE_048310:          TXA                                 ;; 048310 : 8A          ;
CODE_048311:          EOR.B #$01                          ;; 048311 : 49 01       ;
CODE_048313:          TAX                                 ;; 048313 : AA          ;
CODE_048314:          LDA.B #$40                          ;; 048314 : A9 40       ;
CODE_048316:          LDY $01,X                           ;; 048316 : B4 01       ;
CODE_048318:          BPL CODE_04831C                     ;; 048318 : 10 02       ;
CODE_04831A:          LDA.B #$C0                          ;; 04831A : A9 C0       ;
CODE_04831C:          STA $01,X                           ;; 04831C : 95 01       ;
CODE_04831E:          LDY.B #$01                          ;; 04831E : A0 01       ;
CODE_048320:          TYA                                 ;; 048320 : 98          ;
CODE_048321:          ASL                                 ;; 048321 : 0A          ;
CODE_048322:          TAX                                 ;; 048322 : AA          ;
CODE_048323:          LDA.W $0001,Y                       ;; 048323 : B9 01 00    ;
CODE_048326:          ASL                                 ;; 048326 : 0A          ;
CODE_048327:          ASL                                 ;; 048327 : 0A          ;
CODE_048328:          ASL                                 ;; 048328 : 0A          ;
CODE_048329:          ASL                                 ;; 048329 : 0A          ;
CODE_04832A:          CLC                                 ;; 04832A : 18          ;
CODE_04832B:          ADC.W $1B7C,Y                       ;; 04832B : 79 7C 1B    ;
CODE_04832E:          STA.W $1B7C,Y                       ;; 04832E : 99 7C 1B    ;
CODE_048331:          LDA.W $0001,Y                       ;; 048331 : B9 01 00    ;
CODE_048334:          PHY                                 ;; 048334 : 5A          ;
CODE_048335:          PHP                                 ;; 048335 : 08          ;
CODE_048336:          LSR                                 ;; 048336 : 4A          ;
CODE_048337:          LSR                                 ;; 048337 : 4A          ;
CODE_048338:          LSR                                 ;; 048338 : 4A          ;
CODE_048339:          LSR                                 ;; 048339 : 4A          ;
CODE_04833A:          LDY.B #$00                          ;; 04833A : A0 00       ;
CODE_04833C:          PLP                                 ;; 04833C : 28          ;
CODE_04833D:          BPL CODE_048342                     ;; 04833D : 10 03       ;
CODE_04833F:          ORA.B #$F0                          ;; 04833F : 09 F0       ;
CODE_048341:          DEY                                 ;; 048341 : 88          ;
CODE_048342:          ADC RAM_ScreenBndryXLo,X            ;; 048342 : 75 1A       ;
CODE_048344:          STA RAM_ScreenBndryXLo,X            ;; 048344 : 95 1A       ;
CODE_048346:          STA $1E,X                           ;; 048346 : 95 1E       ;
CODE_048348:          TYA                                 ;; 048348 : 98          ;
CODE_048349:          ADC RAM_ScreenBndryXHi,X            ;; 048349 : 75 1B       ;
CODE_04834B:          STA RAM_ScreenBndryXHi,X            ;; 04834B : 95 1B       ;
CODE_04834D:          STA $1F,X                           ;; 04834D : 95 1F       ;
CODE_04834F:          PLY                                 ;; 04834F : 7A          ;
CODE_048350:          DEY                                 ;; 048350 : 88          ;
CODE_048351:          BPL CODE_048320                     ;; 048351 : 10 CD       ;
CODE_048353:          JMP.W CODE_04840D                   ;; 048353 : 4C 0D 84    ;
                                                          ;;                      ;
CODE_048356:          LDA.W $13D9                         ;; 048356 : AD D9 13    ;
CODE_048359:          CMP.B #$03                          ;; 048359 : C9 03       ;
CODE_04835B:          BEQ CODE_048366                     ;; 04835B : F0 09       ;
CODE_04835D:          CMP.B #$04                          ;; 04835D : C9 04       ;
CODE_04835F:          BNE CODE_04839A                     ;; 04835F : D0 39       ;
CODE_048361:          LDA.W $0DD8                         ;; 048361 : AD D8 0D    ;
CODE_048364:          BNE CODE_04839A                     ;; 048364 : D0 34       ;
CODE_048366:          LDA.W $0DA8                         ;; 048366 : AD A8 0D    ;
CODE_048369:          ORA.W $0DA9                         ;; 048369 : 0D A9 0D    ;
CODE_04836C:          AND.B #$30                          ;; 04836C : 29 30       ;
CODE_04836E:          BEQ CODE_048375                     ;; 04836E : F0 05       ;
CODE_048370:          LDA.B #$01                          ;; 048370 : A9 01       ;
CODE_048372:          STA.W $1B87                         ;; 048372 : 8D 87 1B    ;
CODE_048375:          LDX.W $0DB3                         ;; 048375 : AE B3 0D    ;
CODE_048378:          LDA.W $1F11,X                       ;; 048378 : BD 11 1F    ;
CODE_04837B:          BNE CODE_04839A                     ;; 04837B : D0 1D       ;
CODE_04837D:          LDA $16                             ;; 04837D : A5 16       ;
CODE_04837F:          AND.B #$10                          ;; 04837F : 29 10       ;
CODE_048381:          BEQ CODE_04839A                     ;; 048381 : F0 17       ;
CODE_048383:          INC.W $13D4                         ;; 048383 : EE D4 13    ; Look around overworld 
CODE_048386:          LDA.W $13D4                         ;; 048386 : AD D4 13    ;
CODE_048389:          LSR                                 ;; 048389 : 4A          ;
CODE_04838A:          BNE CODE_04839A                     ;; 04838A : D0 0E       ;
CODE_04838C:          REP #$20                            ;; 04838C : C2 20       ; Accum (16 bit) 
CODE_04838E:          LDA RAM_ScreenBndryXLo              ;; 04838E : A5 1A       ;
CODE_048390:          STA.W $1DF0                         ;; 048390 : 8D F0 1D    ;
CODE_048393:          LDA RAM_ScreenBndryYLo              ;; 048393 : A5 1C       ;
CODE_048395:          STA.W $1DF2                         ;; 048395 : 8D F2 1D    ;
CODE_048398:          SEP #$20                            ;; 048398 : E2 20       ; Accum (8 bit) 
CODE_04839A:          LDA.W $13D4                         ;; 04839A : AD D4 13    ;
CODE_04839D:          BEQ CODE_0483C3                     ;; 04839D : F0 24       ;
CODE_04839F:          LDX.B #$00                          ;; 04839F : A2 00       ;
CODE_0483A1:          LDA RAM_ControllerA                 ;; 0483A1 : A5 15       ;
CODE_0483A3:          AND.B #$03                          ;; 0483A3 : 29 03       ;
CODE_0483A5:          ASL                                 ;; 0483A5 : 0A          ;
CODE_0483A6:          JSR.W CODE_048415                   ;; 0483A6 : 20 15 84    ;
CODE_0483A9:          LDX.B #$02                          ;; 0483A9 : A2 02       ;
CODE_0483AB:          LDA RAM_ControllerA                 ;; 0483AB : A5 15       ;
CODE_0483AD:          AND.B #$0C                          ;; 0483AD : 29 0C       ;
CODE_0483AF:          ORA.B #$10                          ;; 0483AF : 09 10       ;
CODE_0483B1:          LSR                                 ;; 0483B1 : 4A          ;
CODE_0483B2:          JSR.W CODE_048415                   ;; 0483B2 : 20 15 84    ;
CODE_0483B5:          LDY.B #$15                          ;; 0483B5 : A0 15       ;
CODE_0483B7:          LDA RAM_FrameCounter                ;; 0483B7 : A5 13       ;
CODE_0483B9:          AND.B #$18                          ;; 0483B9 : 29 18       ;
CODE_0483BB:          BNE CODE_0483BF                     ;; 0483BB : D0 02       ;
CODE_0483BD:          LDY.B #$18                          ;; 0483BD : A0 18       ;
CODE_0483BF:          STY $12                             ;; 0483BF : 84 12       ;
CODE_0483C1:          BRA CODE_04840D                     ;; 0483C1 : 80 4A       ;
                                                          ;;                      ;
CODE_0483C3:          LDX.W $1BA0                         ;; 0483C3 : AE A0 1B    ;
CODE_0483C6:          BEQ CODE_04840A                     ;; 0483C6 : F0 42       ;
CODE_0483C8:          CPX.B #$FE                          ;; 0483C8 : E0 FE       ;
CODE_0483CA:          BNE CODE_0483D6                     ;; 0483CA : D0 0A       ;
CODE_0483CC:          LDA.B #$21                          ;; 0483CC : A9 21       ;
CODE_0483CE:          STA.W $1DF9                         ;; 0483CE : 8D F9 1D    ; / Play sound effect 
CODE_0483D1:          LDA.B #$08                          ;; 0483D1 : A9 08       ;
CODE_0483D3:          STA.W $1DFB                         ;; 0483D3 : 8D FB 1D    ; / Change music 
CODE_0483D6:          TXA                                 ;; 0483D6 : 8A          ;
CODE_0483D7:          LSR                                 ;; 0483D7 : 4A          ;
CODE_0483D8:          LSR                                 ;; 0483D8 : 4A          ;
CODE_0483D9:          LSR                                 ;; 0483D9 : 4A          ;
CODE_0483DA:          LSR                                 ;; 0483DA : 4A          ;
CODE_0483DB:          TAY                                 ;; 0483DB : A8          ;
CODE_0483DC:          LDA RAM_FrameCounter                ;; 0483DC : A5 13       ;
CODE_0483DE:          AND.W DATA_048231,Y                 ;; 0483DE : 39 31 82    ;
CODE_0483E1:          BNE CODE_0483F3                     ;; 0483E1 : D0 10       ;
CODE_0483E3:          LDA RAM_ScreenBndryXLo              ;; 0483E3 : A5 1A       ;
CODE_0483E5:          EOR.B #$01                          ;; 0483E5 : 49 01       ;
CODE_0483E7:          STA RAM_ScreenBndryXLo              ;; 0483E7 : 85 1A       ;
CODE_0483E9:          STA $1E                             ;; 0483E9 : 85 1E       ;
CODE_0483EB:          LDA RAM_ScreenBndryYLo              ;; 0483EB : A5 1C       ;
CODE_0483ED:          EOR.B #$01                          ;; 0483ED : 49 01       ;
CODE_0483EF:          STA RAM_ScreenBndryYLo              ;; 0483EF : 85 1C       ;
CODE_0483F1:          STA $20                             ;; 0483F1 : 85 20       ;
CODE_0483F3:          CPX.B #$80                          ;; 0483F3 : E0 80       ;
CODE_0483F5:          BCS CODE_0483FE                     ;; 0483F5 : B0 07       ;
CODE_0483F7:          LDA.W $13D9                         ;; 0483F7 : AD D9 13    ;
CODE_0483FA:          CMP.B #$02                          ;; 0483FA : C9 02       ;
CODE_0483FC:          BNE CODE_04840A                     ;; 0483FC : D0 0C       ;
CODE_0483FE:          DEC.W $1BA0                         ;; 0483FE : CE A0 1B    ;
CODE_048401:          BNE CODE_04840D                     ;; 048401 : D0 0A       ;
CODE_048403:          LDA.B #$22                          ;; 048403 : A9 22       ;
CODE_048405:          STA.W $1DF9                         ;; 048405 : 8D F9 1D    ; / Play sound effect 
CODE_048408:          BRA CODE_04840D                     ;; 048408 : 80 03       ;
                                                          ;;                      ;
CODE_04840A:          JSR.W CODE_048576                   ;; 04840A : 20 76 85    ;
CODE_04840D:          JSR.W CODE_04F708                   ;; 04840D : 20 08 F7    ;
CODE_048410:          JSR.W CODE_04862E                   ;; 048410 : 20 2E 86    ;
CODE_048413:          PLB                                 ;; 048413 : AB          ;
Return048414:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_048415:          TAY                                 ;; 048415 : A8          ;
CODE_048416:          REP #$20                            ;; 048416 : C2 20       ; Accum (16 bit) 
CODE_048418:          LDA RAM_ScreenBndryXLo,X            ;; 048418 : B5 1A       ;
CODE_04841A:          CLC                                 ;; 04841A : 18          ;
CODE_04841B:          ADC.W DATA_048211,Y                 ;; 04841B : 79 11 82    ;
CODE_04841E:          PHA                                 ;; 04841E : 48          ;
CODE_04841F:          SEC                                 ;; 04841F : 38          ;
CODE_048420:          SBC.W DATA_048221,Y                 ;; 048420 : F9 21 82    ;
CODE_048423:          EOR.W DATA_048211,Y                 ;; 048423 : 59 11 82    ;
CODE_048426:          ASL                                 ;; 048426 : 0A          ;
CODE_048427:          PLA                                 ;; 048427 : 68          ;
CODE_048428:          BCC CODE_04842E                     ;; 048428 : 90 04       ;
CODE_04842A:          STA RAM_ScreenBndryXLo,X            ;; 04842A : 95 1A       ;
CODE_04842C:          STA $1E,X                           ;; 04842C : 95 1E       ;
CODE_04842E:          SEP #$20                            ;; 04842E : E2 20       ; Accum (8 bit) 
Return048430:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_048431:          .db $11,$00,$0A,$00,$09,$00,$0B,$00 ;; 048431               ;
                      .db $12,$00,$0A,$00,$07,$00,$0A,$02 ;; ?QPWZ?               ;
                      .db $03,$02,$10,$04,$12,$04,$1C,$04 ;; ?QPWZ?               ;
                      .db $14,$04,$12,$06,$00,$02,$12,$06 ;; ?QPWZ?               ;
                      .db $10,$00,$17,$06,$14,$00,$1C,$06 ;; ?QPWZ?               ;
                      .db $14,$00,$1C,$06,$17,$06,$11,$05 ;; ?QPWZ?               ;
                      .db $11,$05,$14,$04,$06,$01         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_048467:          .db $07,$00,$03,$00,$10,$00,$0E,$00 ;; 048467               ;
                      .db $17,$00,$18,$00,$12,$00,$14,$00 ;; ?QPWZ?               ;
                      .db $0B,$00,$03,$00,$01,$00,$09,$00 ;; ?QPWZ?               ;
                      .db $09,$00,$1D,$00,$0E,$00,$18,$00 ;; ?QPWZ?               ;
                      .db $0F,$00,$16,$00,$10,$00,$18,$00 ;; ?QPWZ?               ;
                      .db $02,$00,$1D,$00,$18,$00,$13,$00 ;; ?QPWZ?               ;
                      .db $11,$00,$03,$00,$07,$00         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04849D:          .db $A8,$04,$38,$04,$08,$09,$28,$09 ;; 04849D               ;
                      .db $C8,$09,$48,$09,$28,$0D,$18,$01 ;; ?QPWZ?               ;
                      .db $A8,$00,$98,$00,$B8,$00,$28,$01 ;; ?QPWZ?               ;
                      .db $A8,$00,$78,$00,$28,$0D,$08,$04 ;; ?QPWZ?               ;
                      .db $78,$0D,$08,$01,$C8,$0D,$48,$01 ;; ?QPWZ?               ;
                      .db $C8,$0D,$48,$09,$18,$0B,$78,$0D ;; ?QPWZ?               ;
                      .db $68,$02,$C8,$0D,$28,$0D         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_0484D3:          .db $48,$01,$B8,$00,$38,$00,$18,$00 ;; 0484D3               ;
                      .db $98,$00,$98,$00,$D8,$01,$78,$00 ;; ?QPWZ?               ;
                      .db $38,$00,$08,$01,$E8,$00,$78,$01 ;; ?QPWZ?               ;
                      .db $88,$01,$28,$01,$88,$01,$E8,$00 ;; ?QPWZ?               ;
                      .db $68,$01,$F8,$00,$88,$01,$08,$01 ;; ?QPWZ?               ;
                      .db $D8,$01,$38,$00,$38,$01,$88,$01 ;; ?QPWZ?               ;
                      .db $78,$00,$D8,$01,$D8,$01         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_048509:          LDY.W $0DB3                         ;; 048509 : AC B3 0D    ; \ Get current player's submap 
CODE_04850C:          LDA.W $1F11,Y                       ;; 04850C : B9 11 1F    ; / 
CODE_04850F:          STA $01                             ;; 04850F : 85 01       ; Store it in $01 
CODE_048511:          STZ $00                             ;; 048511 : 64 00       ; Store x00 in $00 
CODE_048513:          REP #$20                            ;; 048513 : C2 20       ; 16 bit A ; Accum (16 bit) 
CODE_048515:          LDX.W $0DD6                         ;; 048515 : AE D6 0D    ; Set X to Current character*4 
CODE_048518:          LDY.B #$34                          ;; 048518 : A0 34       ; Set Y to x34 
CODE_04851A:          LDA.W DATA_048431,Y                 ;; 04851A : B9 31 84    ;
CODE_04851D:          EOR $00                             ;; 04851D : 45 00       ;
CODE_04851F:          CMP.W #$0200                        ;; 04851F : C9 00 02    ;
CODE_048522:          BCS CODE_048531                     ;; 048522 : B0 0D       ;
CODE_048524:          CMP.W $1F1F,X                       ;; 048524 : DD 1F 1F    ;
CODE_048527:          BNE CODE_048531                     ;; 048527 : D0 08       ;
CODE_048529:          LDA.W $1F21,X                       ;; 048529 : BD 21 1F    ;
CODE_04852C:          CMP.W DATA_048467,Y                 ;; 04852C : D9 67 84    ;
CODE_04852F:          BEQ CODE_048535                     ;; 04852F : F0 04       ;
CODE_048531:          DEY                                 ;; 048531 : 88          ;
CODE_048532:          DEY                                 ;; 048532 : 88          ;
CODE_048533:          BPL CODE_04851A                     ;; 048533 : 10 E5       ;
CODE_048535:          STY.W $1DF6                         ;; 048535 : 8C F6 1D    ; Store Y in "Warp destination" 
CODE_048538:          SEP #$20                            ;; 048538 : E2 20       ; 8 bit A ; Accum (8 bit) 
Return04853A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04853B:          PHB                                 ;; 04853B : 8B          ;
CODE_04853C:          PHK                                 ;; 04853C : 4B          ;
CODE_04853D:          PLB                                 ;; 04853D : AB          ;
CODE_04853E:          REP #$20                            ;; 04853E : C2 20       ; Accum (16 bit) 
CODE_048540:          LDX.W $0DD6                         ;; 048540 : AE D6 0D    ;
CODE_048543:          LDY.W $1DF6                         ;; 048543 : AC F6 1D    ;
CODE_048546:          LDA.W DATA_04849D,Y                 ;; 048546 : B9 9D 84    ;
CODE_048549:          PHA                                 ;; 048549 : 48          ;
CODE_04854A:          AND.W #$01FF                        ;; 04854A : 29 FF 01    ;
CODE_04854D:          STA.W $1F17,X                       ;; 04854D : 9D 17 1F    ;
CODE_048550:          LSR                                 ;; 048550 : 4A          ;
CODE_048551:          LSR                                 ;; 048551 : 4A          ;
CODE_048552:          LSR                                 ;; 048552 : 4A          ;
CODE_048553:          LSR                                 ;; 048553 : 4A          ;
CODE_048554:          STA.W $1F1F,X                       ;; 048554 : 9D 1F 1F    ;
CODE_048557:          LDA.W DATA_0484D3,Y                 ;; 048557 : B9 D3 84    ;
CODE_04855A:          STA.W $1F19,X                       ;; 04855A : 9D 19 1F    ;
CODE_04855D:          LSR                                 ;; 04855D : 4A          ;
CODE_04855E:          LSR                                 ;; 04855E : 4A          ;
CODE_04855F:          LSR                                 ;; 04855F : 4A          ;
CODE_048560:          LSR                                 ;; 048560 : 4A          ;
CODE_048561:          STA.W $1F21,X                       ;; 048561 : 9D 21 1F    ;
CODE_048564:          PLA                                 ;; 048564 : 68          ;
CODE_048565:          LSR                                 ;; 048565 : 4A          ;
CODE_048566:          XBA                                 ;; 048566 : EB          ;
CODE_048567:          AND.W #$000F                        ;; 048567 : 29 0F 00    ;
CODE_04856A:          STA.W $13C3                         ;; 04856A : 8D C3 13    ;
CODE_04856D:          REP #$10                            ;; 04856D : C2 10       ; Index (16 bit) 
CODE_04856F:          JSR.W CODE_049A93                   ;; 04856F : 20 93 9A    ;
CODE_048572:          SEP #$30                            ;; 048572 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_048574:          PLB                                 ;; 048574 : AB          ;
Return048575:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_048576:          LDA.W $13D9                         ;; 048576 : AD D9 13    ;
CODE_048579:          JSL.L ExecutePtrLong                ;; 048579 : 22 FA 86 00 ;
                                                          ;;                      ;
PtrsLong04857D:       .dw CODE_048EF1 .db :$CODE_048EF1   ;; ?QPWZ? : F1 8E 04    ;
                      .dw CODE_04E570 .db :$CODE_04E570   ;; ?QPWZ? : 70 E5 04    ;
                      .dw CODE_048F87 .db :$CODE_048F87   ;; ?QPWZ? : 87 8F 04    ;
                      .dw CODE_049120 .db :$CODE_049120   ;; ?QPWZ? : 20 91 04    ;
                      .dw CODE_04945D .db :$CODE_04945D   ;; ?QPWZ? : 5D 94 04    ;
                      .dw CODE_049D9A .db :$CODE_049D9A   ;; ?QPWZ? : 9A 9D 04    ;
                      .dw CODE_049E22 .db :$CODE_049E22   ;; ?QPWZ? : 22 9E 04    ;
                      .dw CODE_049DD1 .db :$CODE_049DD1   ;; ?QPWZ? : D1 9D 04    ;
                      .dw CODE_049E22 .db :$CODE_049E22   ;; ?QPWZ? : 22 9E 04    ;
                      .dw CODE_049E4C .db :$CODE_049E4C   ;; ?QPWZ? : 4C 9E 04    ;
                      .dw CODE_04DAEF .db :$CODE_04DAEF   ;; ?QPWZ? : EF DA 04    ;
                      .dw CODE_049E52 .db :$CODE_049E52   ;; ?QPWZ? : 52 9E 04    ;
                      .dw CODE_0498C6 .db :$CODE_0498C6   ;; ?QPWZ? : C6 98 04    ;
                                                          ;;                      ;
DrawOWBoarder?:       JSR.W CODE_04862E                   ;; ?QPWZ? : 20 2E 86    ;
CODE_0485A7:          REP #$20                            ;; 0485A7 : C2 20       ; Accum (16 bit) 
CODE_0485A9:          LDA.W #$001E                        ;; 0485A9 : A9 1E 00    ; \ Mario X postion = #$001E 
CODE_0485AC:          CLC                                 ;; 0485AC : 18          ;  | (On overworld boarder) 
CODE_0485AD:          ADC RAM_ScreenBndryXLo              ;; 0485AD : 65 1A       ;  | 
CODE_0485AF:          STA RAM_MarioXPos                   ;; 0485AF : 85 94       ; / 
CODE_0485B1:          LDA.W #$0006                        ;; 0485B1 : A9 06 00    ; \ Mario Y postion = #$0006 
CODE_0485B4:          CLC                                 ;; 0485B4 : 18          ;  | (On overworld boarder) 
CODE_0485B5:          ADC RAM_ScreenBndryYLo              ;; 0485B5 : 65 1C       ;  | 
CODE_0485B7:          STA RAM_MarioYPos                   ;; 0485B7 : 85 96       ; / 
CODE_0485B9:          SEP #$20                            ;; 0485B9 : E2 20       ; Accum (8 bit) 
CODE_0485BB:          LDA.B #$08                          ;; 0485BB : A9 08       ;
CODE_0485BD:          STA.W RAM_MarioSpeedX               ;; 0485BD : 8D 7B 00    ;
CODE_0485C0:          PHB                                 ;; 0485C0 : 8B          ;
CODE_0485C1:          LDA.B #$00                          ;; 0485C1 : A9 00       ;
CODE_0485C3:          PHA                                 ;; 0485C3 : 48          ;
CODE_0485C4:          PLB                                 ;; 0485C4 : AB          ;
CODE_0485C5:          JSL.L CODE_00CEB1                   ;; 0485C5 : 22 B1 CE 00 ;
CODE_0485C9:          PLB                                 ;; 0485C9 : AB          ;
CODE_0485CA:          LDA.B #$03                          ;; 0485CA : A9 03       ;
CODE_0485CC:          STA.W RAM_IsBehindScenery           ;; 0485CC : 8D F9 13    ;
CODE_0485CF:          JSL.L CODE_00E2BD                   ;; 0485CF : 22 BD E2 00 ;
CODE_0485D3:          LDA.B #$06                          ;; 0485D3 : A9 06       ;
CODE_0485D5:          STA.W $0D84                         ;; 0485D5 : 8D 84 0D    ;
CODE_0485D8:          LDA.W $1496                         ;; 0485D8 : AD 96 14    ;
CODE_0485DB:          BEQ CODE_0485E0                     ;; 0485DB : F0 03       ;
CODE_0485DD:          DEC.W $1496                         ;; 0485DD : CE 96 14    ;
CODE_0485E0:          LDA.W $14A2                         ;; 0485E0 : AD A2 14    ;
CODE_0485E3:          BEQ CODE_0485E8                     ;; 0485E3 : F0 03       ;
CODE_0485E5:          DEC.W $14A2                         ;; 0485E5 : CE A2 14    ;
CODE_0485E8:          LDA.B #$18                          ;; 0485E8 : A9 18       ;
CODE_0485EA:          STA $00                             ;; 0485EA : 85 00       ;
CODE_0485EC:          LDA.B #$07                          ;; 0485EC : A9 07       ;
CODE_0485EE:          STA $01                             ;; 0485EE : 85 01       ;
CODE_0485F0:          LDY.B #$00                          ;; 0485F0 : A0 00       ;
CODE_0485F2:          TYX                                 ;; 0485F2 : BB          ;
CODE_0485F3:          LDA $00                             ;; 0485F3 : A5 00       ;
CODE_0485F5:          STA.W OAM_ExtendedDispX,X           ;; 0485F5 : 9D 00 02    ;
CODE_0485F8:          CLC                                 ;; 0485F8 : 18          ;
CODE_0485F9:          ADC.B #$08                          ;; 0485F9 : 69 08       ;
CODE_0485FB:          STA $00                             ;; 0485FB : 85 00       ;
CODE_0485FD:          LDA $01                             ;; 0485FD : A5 01       ;
CODE_0485FF:          STA.W OAM_ExtendedDispY,X           ;; 0485FF : 9D 01 02    ;
CODE_048602:          LDA.B #$7E                          ;; 048602 : A9 7E       ;
CODE_048604:          STA.W OAM_ExtendedTile,X            ;; 048604 : 9D 02 02    ;
CODE_048607:          LDA.B #$36                          ;; 048607 : A9 36       ;
CODE_048609:          STA.W OAM_ExtendedProp,X            ;; 048609 : 9D 03 02    ;
CODE_04860C:          PHX                                 ;; 04860C : DA          ;
CODE_04860D:          TYX                                 ;; 04860D : BB          ;
CODE_04860E:          LDA.B #$00                          ;; 04860E : A9 00       ;
CODE_048610:          STA.W $0420,X                       ;; 048610 : 9D 20 04    ;
CODE_048613:          PLX                                 ;; 048613 : FA          ;
CODE_048614:          INY                                 ;; 048614 : C8          ;
CODE_048615:          TYA                                 ;; 048615 : 98          ;
CODE_048616:          AND.B #$03                          ;; 048616 : 29 03       ;
CODE_048618:          BNE CODE_048625                     ;; 048618 : D0 0B       ;
CODE_04861A:          LDA.B #$18                          ;; 04861A : A9 18       ;
CODE_04861C:          STA $00                             ;; 04861C : 85 00       ;
CODE_04861E:          LDA $01                             ;; 04861E : A5 01       ;
CODE_048620:          CLC                                 ;; 048620 : 18          ;
CODE_048621:          ADC.B #$08                          ;; 048621 : 69 08       ;
CODE_048623:          STA $01                             ;; 048623 : 85 01       ;
CODE_048625:          INX                                 ;; 048625 : E8          ;
CODE_048626:          INX                                 ;; 048626 : E8          ;
CODE_048627:          INX                                 ;; 048627 : E8          ;
CODE_048628:          INX                                 ;; 048628 : E8          ;
CODE_048629:          CPY.B #$10                          ;; 048629 : C0 10       ;
CODE_04862B:          BNE CODE_0485F3                     ;; 04862B : D0 C6       ;
Return04862D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04862E:          REP #$30                            ;; 04862E : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_048630:          LDX.W $0DD6                         ;; 048630 : AE D6 0D    ; X = player x 4
CODE_048633:          LDA.W $1F17,X                       ;; 048633 : BD 17 1F    ; A = player X-pos on OW
CODE_048636:          SEC                                 ;; 048636 : 38          ; 
CODE_048637:          SBC RAM_ScreenBndryXLo              ;; 048637 : E5 1A       ; A = X-pos on screen
CODE_048639:          CMP.W #$0100                        ;; 048639 : C9 00 01    ; 
CODE_04863C:          BCS CODE_04864D                     ;; 04863C : B0 0F       ; \ if < #$0100
CODE_04863E:          STA $00                             ;; 04863E : 85 00       ; | $00 = X-pos on screen
CODE_048640:          STA $08                             ;; 048640 : 85 08       ; | $08 = X-pos on screen
CODE_048642:          LDA.W $1F19,X                       ;; 048642 : BD 19 1F    ; | A = player Y-pos on OW
CODE_048645:          SEC                                 ;; 048645 : 38          ; |
CODE_048646:          SBC RAM_ScreenBndryYLo              ;; 048646 : E5 1C       ; | A = Y-pos on screen
CODE_048648:          CMP.W #$0100                        ;; 048648 : C9 00 01    ; |
CODE_04864B:          BCC CODE_048650                     ;; 04864B : 90 03       ; /
CODE_04864D:          LDA.W #$00F0                        ;; 04864D : A9 F0 00    ; \ 
CODE_048650:          STA $02                             ;; 048650 : 85 02       ; | $02 = Y-pos on screen
CODE_048652:          STA $0A                             ;; 048652 : 85 0A       ; / $0A = Y-pos on screen
CODE_048654:          TXA                                 ;; 048654 : 8A          ; A = player x 4
CODE_048655:          EOR.W #$0004                        ;; 048655 : 49 04 00    ; A = other player x 4
CODE_048658:          TAX                                 ;; 048658 : AA          ; X = other player x 4
CODE_048659:          LDA.W $1F17,X                       ;; 048659 : BD 17 1F    ; \
CODE_04865C:          SEC                                 ;; 04865C : 38          ; | (same as above, but for luigi)
CODE_04865D:          SBC RAM_ScreenBndryXLo              ;; 04865D : E5 1A       ; |
CODE_04865F:          CMP.W #$0100                        ;; 04865F : C9 00 01    ; |
CODE_048662:          BCS CODE_048673                     ;; 048662 : B0 0F       ; |
CODE_048664:          STA $04                             ;; 048664 : 85 04       ; | $04 = X-pos on screen
CODE_048666:          STA $0C                             ;; 048666 : 85 0C       ; | $0C = X-pos on screen
CODE_048668:          LDA.W $1F19,X                       ;; 048668 : BD 19 1F    ; |
CODE_04866B:          SEC                                 ;; 04866B : 38          ; |
CODE_04866C:          SBC RAM_ScreenBndryYLo              ;; 04866C : E5 1C       ; |
CODE_04866E:          CMP.W #$0100                        ;; 04866E : C9 00 01    ; |
CODE_048671:          BCC CODE_048676                     ;; 048671 : 90 03       ; |
CODE_048673:          LDA.W #$00F0                        ;; 048673 : A9 F0 00    ; |
CODE_048676:          STA $06                             ;; 048676 : 85 06       ; | $06 = Y-pos on screen
CODE_048678:          STA $0E                             ;; 048678 : 85 0E       ; / $0E = Y-pos on screen
CODE_04867A:          SEP #$30                            ;; 04867A : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04867C:          LDA $00                             ;; 04867C : A5 00       ;
CODE_04867E:          SEC                                 ;; 04867E : 38          ;
CODE_04867F:          SBC.B #$08                          ;; 04867F : E9 08       ; subtract 8 from 1P X-pos
CODE_048681:          STA $00                             ;; 048681 : 85 00       ; $00 = 1P X-pos on screen
CODE_048683:          LDA $02                             ;; 048683 : A5 02       ;
CODE_048685:          SEC                                 ;; 048685 : 38          ;
CODE_048686:          SBC.B #$09                          ;; 048686 : E9 09       ; subtract 9 from 1P Y-pos
CODE_048688:          STA $01                             ;; 048688 : 85 01       ; $01 = 1P Y-pos on screen
CODE_04868A:          LDA $04                             ;; 04868A : A5 04       ;
CODE_04868C:          SEC                                 ;; 04868C : 38          ;
CODE_04868D:          SBC.B #$08                          ;; 04868D : E9 08       ; subtract 8 from 2P X-pos
CODE_04868F:          STA $02                             ;; 04868F : 85 02       ; $02 = 2P X-pos on screen
CODE_048691:          LDA $06                             ;; 048691 : A5 06       ;
CODE_048693:          SEC                                 ;; 048693 : 38          ;
CODE_048694:          SBC.B #$09                          ;; 048694 : E9 09       ; subtract 9 from 2P Y-pos
CODE_048696:          STA $03                             ;; 048696 : 85 03       ; $03 = 2P Y-pos on screen
CODE_048698:          LDA.B #$03                          ;; 048698 : A9 03       ;
CODE_04869A:          STA $8C                             ;; 04869A : 85 8C       ; $8C = #$03
CODE_04869C:          LDA $00                             ;; 04869C : A5 00       ;
CODE_04869E:          STA $06                             ;; 04869E : 85 06       ; $06 = 1P X-pos on screen
CODE_0486A0:          STA $8A                             ;; 0486A0 : 85 8A       ; $8A = 1P X-pos on screen
CODE_0486A2:          LDA $01                             ;; 0486A2 : A5 01       ;
CODE_0486A4:          STA $07                             ;; 0486A4 : 85 07       ; $07 = 1P Y-pos on screen
CODE_0486A6:          STA $8B                             ;; 0486A6 : 85 8B       ; $8B = 1P Y-pos on screen
CODE_0486A8:          LDA.W $0DD6                         ;; 0486A8 : AD D6 0D    ; A = player x 4
CODE_0486AB:          LSR                                 ;; 0486AB : 4A          ; A = player x 2
CODE_0486AC:          TAY                                 ;; 0486AC : A8          ; Y = player x 2
CODE_0486AD:          LDA.W $1F13,Y                       ;; 0486AD : B9 13 1F    ; A = player OW animation type
CODE_0486B0:          CMP.B #$12                          ;; 0486B0 : C9 12       ;
CODE_0486B2:          BEQ CODE_0486C5                     ;; 0486B2 : F0 11       ; skip if enter level in water animation
CODE_0486B4:          CMP.B #$07                          ;; 0486B4 : C9 07       ;
CODE_0486B6:          BCC CODE_0486BC                     ;; 0486B6 : 90 04       ; don't skip if moving on land
CODE_0486B8:          CMP.B #$0F                          ;; 0486B8 : C9 0F       ;
CODE_0486BA:          BCC CODE_0486C5                     ;; 0486BA : 90 09       ; skip if moving in water
CODE_0486BC:          LDA $8B                             ;; 0486BC : A5 8B       ;
CODE_0486BE:          SEC                                 ;; 0486BE : 38          ;
CODE_0486BF:          SBC.B #$05                          ;; 0486BF : E9 05       ; subtract 5 from Y-pos if on land
CODE_0486C1:          STA $8B                             ;; 0486C1 : 85 8B       ; $8B = 1P Y-pos on screen
CODE_0486C3:          STA $07                             ;; 0486C3 : 85 07       ; $07 = 1P Y-pos on screen
CODE_0486C5:          REP #$30                            ;; 0486C5 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_0486C7:          LDA.W $0DD6                         ;; 0486C7 : AD D6 0D    ; A = player x 4
CODE_0486CA:          XBA                                 ;; 0486CA : EB          ; A = player x #$400
CODE_0486CB:          LSR                                 ;; 0486CB : 4A          ; A = player x #$200
CODE_0486CC:          STA $04                             ;; 0486CC : 85 04       ; $04 = player x #$200
CODE_0486CE:          LDX.W #$0000                        ;; 0486CE : A2 00 00    ; X = #$0000
CODE_0486D1:          JSR.W CODE_048789                   ;; 0486D1 : 20 89 87    ; draw halo if out of lives
CODE_0486D4:          LDA.W $0DD6                         ;; 0486D4 : AD D6 0D    ; A = player x 4
CODE_0486D7:          LSR                                 ;; 0486D7 : 4A          ; A = player x 2
CODE_0486D8:          TAY                                 ;; 0486D8 : A8          ; Y = player x 2
CODE_0486D9:          LDX.W #$0000                        ;; 0486D9 : A2 00 00    ; X = #$0000
CODE_0486DC:          JSR.W CODE_04894F                   ;; 0486DC : 20 4F 89    ;
CODE_0486DF:          SEP #$30                            ;; 0486DF : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_0486E1:          STZ.W $0447                         ;; 0486E1 : 9C 47 04    ; \
CODE_0486E4:          STZ.W $0448                         ;; 0486E4 : 9C 48 04    ; | make OAM tiles 8x8
CODE_0486E7:          STZ.W $0449                         ;; 0486E7 : 9C 49 04    ; |
CODE_0486EA:          STZ.W $044A                         ;; 0486EA : 9C 4A 04    ; |
CODE_0486ED:          STZ.W $044B                         ;; 0486ED : 9C 4B 04    ; |
CODE_0486F0:          STZ.W $044C                         ;; 0486F0 : 9C 4C 04    ; |
CODE_0486F3:          STZ.W $044D                         ;; 0486F3 : 9C 4D 04    ; |
CODE_0486F6:          STZ.W $044E                         ;; 0486F6 : 9C 4E 04    ; /
CODE_0486F9:          LDA.B #$03                          ;; 0486F9 : A9 03       ;
CODE_0486FB:          STA $8C                             ;; 0486FB : 85 8C       ; $8C = #$03
CODE_0486FD:          LDA.W $1F11                         ;; 0486FD : AD 11 1F    ; A = 1P submap
CODE_048700:          LDY.W $13D9                         ;; 048700 : AC D9 13    ; Y = overworld process
CODE_048703:          CPY.B #$0A                          ;; 048703 : C0 0A       ;
CODE_048705:          BNE CODE_048709                     ;; 048705 : D0 02       ;
CODE_048707:          EOR.B #$01                          ;; 048707 : 49 01       ; ??
CODE_048709:          CMP.W $1F12                         ;; 048709 : CD 12 1F    ;
CODE_04870C:          BNE CODE_048786                     ;; 04870C : D0 78       ; skip everything if 1P and 2P are on different submaps
CODE_04870E:          LDA $02                             ;; 04870E : A5 02       ;
CODE_048710:          STA $06                             ;; 048710 : 85 06       ; $06 = 2P X-pos on screen
CODE_048712:          STA $8A                             ;; 048712 : 85 8A       ; $8A = 2P X-pos on screen
CODE_048714:          LDA $03                             ;; 048714 : A5 03       ;
CODE_048716:          STA $07                             ;; 048716 : 85 07       ; $07 = 2P Y-pos on screen
CODE_048718:          STA $8B                             ;; 048718 : 85 8B       ; $8B = 2P Y-pos on screen
CODE_04871A:          LDA.W $0DD6                         ;; 04871A : AD D6 0D    ; A = player x 4
CODE_04871D:          LSR                                 ;; 04871D : 4A          ; A = player x 2
CODE_04871E:          EOR.B #$02                          ;; 04871E : 49 02       ; A = other player x 2
CODE_048720:          TAY                                 ;; 048720 : A8          ; Y = other player x 2
CODE_048721:          LDA.W $1F13,Y                       ;; 048721 : B9 13 1F    ; A = other player OW animation type
CODE_048724:          CMP.B #$12                          ;; 048724 : C9 12       ;
CODE_048726:          BEQ CODE_048739                     ;; 048726 : F0 11       ; skip if enter level in water animation
CODE_048728:          CMP.B #$07                          ;; 048728 : C9 07       ;
CODE_04872A:          BCC CODE_048730                     ;; 04872A : 90 04       ; don't skip if moving on land
CODE_04872C:          CMP.B #$0F                          ;; 04872C : C9 0F       ;
CODE_04872E:          BCC CODE_048739                     ;; 04872E : 90 09       ; skip if moving in water
CODE_048730:          LDA $8B                             ;; 048730 : A5 8B       ;
CODE_048732:          SEC                                 ;; 048732 : 38          ;
CODE_048733:          SBC.B #$05                          ;; 048733 : E9 05       ; subtract 5 from Y-pos if on land
CODE_048735:          STA $8B                             ;; 048735 : 85 8B       ; $8B = 2P Y-pos on screen
CODE_048737:          STA $07                             ;; 048737 : 85 07       ; $07 = 2P Y-pos on screen
CODE_048739:          REP #$30                            ;; 048739 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04873B:          LDA.W $0DB2                         ;; 04873B : AD B2 0D    ;
CODE_04873E:          AND.W #$00FF                        ;; 04873E : 29 FF 00    ;
CODE_048741:          BEQ CODE_048786                     ;; 048741 : F0 43       ; skip everything if we are in a 1P-game (why check that so late?)
CODE_048743:          LDA $0C                             ;; 048743 : A5 0C       ;
CODE_048745:          CMP.W #$00F0                        ;; 048745 : C9 F0 00    ;
CODE_048748:          BCS CODE_048786                     ;; 048748 : B0 3C       ; skip if 2P is offscreen in the X direction
CODE_04874A:          LDA $0E                             ;; 04874A : A5 0E       ;
CODE_04874C:          CMP.W #$00F0                        ;; 04874C : C9 F0 00    ;
CODE_04874F:          BCS CODE_048786                     ;; 04874F : B0 35       ; skip if 2P is offscreen in the Y direction
CODE_048751:          LDA $04                             ;; 048751 : A5 04       ; A = player x #$200
CODE_048753:          EOR.W #$0200                        ;; 048753 : 49 00 02    ; A = other player x #$200
CODE_048756:          STA $04                             ;; 048756 : 85 04       ; $04 = other player x #$200
CODE_048758:          LDX.W #$0020                        ;; 048758 : A2 20 00    ; X = #$0020
CODE_04875B:          JSR.W CODE_048789                   ;; 04875B : 20 89 87    ; draw halo if out of lives
CODE_04875E:          LDA.W $0DD6                         ;; 04875E : AD D6 0D    ; A = player x 4
CODE_048761:          LSR                                 ;; 048761 : 4A          ; A = player x 2
CODE_048762:          EOR.W #$0002                        ;; 048762 : 49 02 00    ; A = other player x 2
CODE_048765:          TAY                                 ;; 048765 : A8          ; Y = other player x 2
CODE_048766:          LDX.W #$0020                        ;; 048766 : A2 20 00    ; X = #$0020
CODE_048769:          JSR.W CODE_04894F                   ;; 048769 : 20 4F 89    ;
CODE_04876C:          SEP #$30                            ;; 04876C : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04876E:          STZ.W $044F                         ;; 04876E : 9C 4F 04    ; \
CODE_048771:          STZ.W $0450                         ;; 048771 : 9C 50 04    ; | make OAM tiles 8x8
CODE_048774:          STZ.W $0451                         ;; 048774 : 9C 51 04    ; |
CODE_048777:          STZ.W $0452                         ;; 048777 : 9C 52 04    ; |
CODE_04877A:          STZ.W $0453                         ;; 04877A : 9C 53 04    ; |
CODE_04877D:          STZ.W $0454                         ;; 04877D : 9C 54 04    ; |
CODE_048780:          STZ.W $0455                         ;; 048780 : 9C 55 04    ; |
CODE_048783:          STZ.W $0456                         ;; 048783 : 9C 56 04    ; /
CODE_048786:          SEP #$30                            ;; 048786 : E2 30       ; Index (8 bit) Accum (8 bit) 
Return048788:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_048789:          LDA $8A                             ;; 048789 : A5 8A       ; A = Y-pos on screen | X-pos on screen
CODE_04878B:          PHA                                 ;; 04878B : 48          ;
CODE_04878C:          PHX                                 ;; 04878C : DA          ; X = player x #$20
CODE_04878D:          LDA $04                             ;; 04878D : A5 04       ; A = player x #$200
CODE_04878F:          XBA                                 ;; 04878F : EB          ; A = player x 2
CODE_048790:          LSR                                 ;; 048790 : 4A          ; A = player
CODE_048791:          TAX                                 ;; 048791 : AA          ; X = player
CODE_048792:          LDA.W $0DB3,X                       ;; 048792 : BD B3 0D    ; A = player lives | junk
CODE_048795:          PLX                                 ;; 048795 : FA          ; X = player x #$20
CODE_048796:          AND.W #$FF00                        ;; 048796 : 29 00 FF    ; A = player lives | #$00
CODE_048799:          BPL CODE_0487C7                     ;; 048799 : 10 2C       ; skip if player lives positive
CODE_04879B:          SEP #$20                            ;; 04879B : E2 20       ; Accum (8 bit) 
CODE_04879D:          LDA $8A                             ;; 04879D : A5 8A       ;
CODE_04879F:          STA.W $02B4,X                       ;; 04879F : 9D B4 02    ; OAM X-pos of 1st halo tile
CODE_0487A2:          CLC                                 ;; 0487A2 : 18          ;
CODE_0487A3:          ADC.B #$08                          ;; 0487A3 : 69 08       ;
CODE_0487A5:          STA.W $02B8,X                       ;; 0487A5 : 9D B8 02    ; OAM X-pos of 2nd halo tile
CODE_0487A8:          LDA $8B                             ;; 0487A8 : A5 8B       ;
CODE_0487AA:          CLC                                 ;; 0487AA : 18          ;
CODE_0487AB:          ADC.B #$F9                          ;; 0487AB : 69 F9       ;
CODE_0487AD:          STA.W $02B5,X                       ;; 0487AD : 9D B5 02    ; OAM Y-pos of 1st halo tile
CODE_0487B0:          STA.W $02B9,X                       ;; 0487B0 : 9D B9 02    ; OAM Y-pos of 2nd halo tile
CODE_0487B3:          LDA.B #$7C                          ;; 0487B3 : A9 7C       ;
CODE_0487B5:          STA.W $02B6,X                       ;; 0487B5 : 9D B6 02    ; OAM tile number of 1st halo tile
CODE_0487B8:          STA.W $02BA,X                       ;; 0487B8 : 9D BA 02    ; OAM tile number of 2nd halo tile
CODE_0487BB:          LDA.B #$20                          ;; 0487BB : A9 20       ;
CODE_0487BD:          STA.W $02B7,X                       ;; 0487BD : 9D B7 02    ; OAM yxppccct of 1st halo tile
CODE_0487C0:          LDA.B #$60                          ;; 0487C0 : A9 60       ;
CODE_0487C2:          STA.W $02BB,X                       ;; 0487C2 : 9D BB 02    ; OAM yxppccct of 2nd halo tile
CODE_0487C5:          REP #$20                            ;; 0487C5 : C2 20       ; Accum (16 bit) 
CODE_0487C7:          PLA                                 ;; 0487C7 : 68          ; A = Y-pos on screen | X-pos on screen
CODE_0487C8:          STA $8A                             ;; 0487C8 : 85 8A       ; $8A = X-pos on screen, $8B = Y-pos on screen
Return0487CA:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
OWPlayerTiles:        .db $0E,$24,$0F,$24,$1E,$24,$1F,$24 ;; ?QPWZ?               ;
                      .db $20,$24,$21,$24,$30,$24,$31,$24 ;; ?QPWZ?               ;
                      .db $0E,$24,$0F,$24,$1E,$24,$1F,$24 ;; ?QPWZ?               ;
                      .db $20,$24,$21,$24,$31,$64,$30,$64 ;; ?QPWZ?               ;
                      .db $0A,$24,$0B,$24,$1A,$24,$1B,$24 ;; ?QPWZ?               ;
                      .db $0C,$24,$0D,$24,$1C,$24,$1D,$24 ;; ?QPWZ?               ;
                      .db $0A,$24,$0B,$24,$1A,$24,$1B,$24 ;; ?QPWZ?               ;
                      .db $0C,$24,$0D,$24,$1D,$64,$1C,$64 ;; ?QPWZ?               ;
                      .db $08,$24,$09,$24,$18,$24,$19,$24 ;; ?QPWZ?               ;
                      .db $06,$24,$07,$24,$16,$24,$17,$24 ;; ?QPWZ?               ;
                      .db $08,$24,$09,$24,$18,$24,$19,$24 ;; ?QPWZ?               ;
                      .db $06,$24,$07,$24,$16,$24,$17,$24 ;; ?QPWZ?               ;
                      .db $09,$64,$08,$64,$19,$64,$18,$64 ;; ?QPWZ?               ;
                      .db $07,$64,$06,$64,$17,$64,$16,$64 ;; ?QPWZ?               ;
                      .db $09,$64,$08,$64,$19,$64,$18,$64 ;; ?QPWZ?               ;
                      .db $07,$64,$06,$64,$17,$64,$16,$64 ;; ?QPWZ?               ;
                      .db $0E,$24,$0F,$24,$38,$24,$38,$64 ;; ?QPWZ?               ;
                      .db $20,$24,$21,$24,$39,$24,$39,$64 ;; ?QPWZ?               ;
                      .db $0E,$24,$0F,$24,$38,$24,$38,$64 ;; ?QPWZ?               ;
                      .db $20,$24,$21,$24,$39,$24,$39,$64 ;; ?QPWZ?               ;
                      .db $0A,$24,$0B,$24,$38,$24,$38,$64 ;; ?QPWZ?               ;
                      .db $0C,$24,$0D,$24,$39,$24,$39,$64 ;; ?QPWZ?               ;
                      .db $0A,$24,$0B,$24,$38,$24,$38,$64 ;; ?QPWZ?               ;
                      .db $0C,$24,$0D,$24,$39,$24,$39,$64 ;; ?QPWZ?               ;
                      .db $08,$24,$09,$24,$38,$24,$38,$64 ;; ?QPWZ?               ;
                      .db $06,$24,$07,$24,$39,$24,$39,$64 ;; ?QPWZ?               ;
                      .db $08,$24,$09,$24,$38,$24,$38,$64 ;; ?QPWZ?               ;
                      .db $06,$24,$07,$24,$39,$24,$39,$64 ;; ?QPWZ?               ;
                      .db $09,$64,$08,$64,$38,$24,$38,$64 ;; ?QPWZ?               ;
                      .db $07,$64,$06,$64,$39,$24,$39,$64 ;; ?QPWZ?               ;
                      .db $09,$64,$08,$64,$38,$24,$38,$64 ;; ?QPWZ?               ;
                      .db $07,$64,$06,$64,$39,$24,$39,$64 ;; ?QPWZ?               ;
                      .db $24,$24,$25,$24,$34,$24,$35,$24 ;; ?QPWZ?               ;
                      .db $24,$24,$25,$24,$34,$24,$35,$24 ;; ?QPWZ?               ;
                      .db $24,$24,$25,$24,$34,$24,$35,$24 ;; ?QPWZ?               ;
                      .db $24,$24,$25,$24,$34,$24,$35,$24 ;; ?QPWZ?               ;
                      .db $24,$24,$25,$24,$38,$24,$38,$64 ;; ?QPWZ?               ;
                      .db $24,$24,$25,$24,$38,$24,$38,$64 ;; ?QPWZ?               ;
                      .db $24,$24,$25,$24,$38,$24,$38,$64 ;; ?QPWZ?               ;
                      .db $24,$24,$25,$24,$38,$24,$38,$64 ;; ?QPWZ?               ;
                      .db $46,$24,$47,$24,$56,$24,$57,$24 ;; ?QPWZ?               ;
                      .db $47,$64,$46,$64,$57,$64,$56,$64 ;; ?QPWZ?               ;
                      .db $46,$24,$47,$24,$56,$24,$57,$24 ;; ?QPWZ?               ;
                      .db $47,$64,$46,$64,$57,$64,$56,$64 ;; ?QPWZ?               ;
                      .db $46,$24,$47,$24,$56,$24,$57,$24 ;; ?QPWZ?               ;
                      .db $47,$64,$46,$64,$57,$64,$56,$64 ;; ?QPWZ?               ;
                      .db $46,$24,$47,$24,$56,$24,$57,$24 ;; ?QPWZ?               ;
                      .db $47,$64,$46,$64,$57,$64,$56,$64 ;; ?QPWZ?               ;
OWWarpIndex:          .db $20,$60,$00,$40                 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_04894F:          SEP #$30                            ;; 04894F : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_048951:          PHY                                 ;; 048951 : 5A          ; Y = player x 2
CODE_048952:          TYA                                 ;; 048952 : 98          ; A = player x 2
CODE_048953:          LSR                                 ;; 048953 : 4A          ; A = player
CODE_048954:          TAY                                 ;; 048954 : A8          ; Y = player
CODE_048955:          LDA.W RAM_PlyrYoshiColor,Y          ;; 048955 : B9 BA 0D    ; A = player's yoshi color
CODE_048958:          BEQ CODE_048962                     ;; 048958 : F0 08       ; branch if no yoshi
CODE_04895A:          STA $0E                             ;; 04895A : 85 0E       ; $0E = player's yoshi color
CODE_04895C:          STZ $0F                             ;; 04895C : 64 0F       ; $0F = #$00
CODE_04895E:          PLY                                 ;; 04895E : 7A          ; Y = player x 2
CODE_04895F:          JMP.W CODE_048CE6                   ;; 04895F : 4C E6 8C    ; jump
                                                          ;;                      ;
CODE_048962:          PLY                                 ;; 048962 : 7A          ; Y = player x 2
CODE_048963:          REP #$30                            ;; 048963 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_048965:          LDA.W $1F13,Y                       ;; 048965 : B9 13 1F    ; A = player OW animation type
CODE_048968:          ASL                                 ;; 048968 : 0A          ;
CODE_048969:          ASL                                 ;; 048969 : 0A          ;
CODE_04896A:          ASL                                 ;; 04896A : 0A          ;
CODE_04896B:          ASL                                 ;; 04896B : 0A          ; A = player OW animation type x #$10
CODE_04896C:          STA $00                             ;; 04896C : 85 00       ; $00 = player OW animation type x #$10
CODE_04896E:          LDA RAM_FrameCounter                ;; 04896E : A5 13       ; A = frame counter
CODE_048970:          AND.W #$0018                        ;; 048970 : 29 18 00    ; A = 5 LSB of frame counter
CODE_048973:          CLC                                 ;; 048973 : 18          ;
CODE_048974:          ADC $00                             ;; 048974 : 65 00       ; A = 0000 000a aaaf ffff (a = animation type, f = 5 LSB of frame counter)
CODE_048976:          TAY                                 ;; 048976 : A8          ; Y = that index ^
CODE_048977:          PHX                                 ;; 048977 : DA          ; X = player x #$20
CODE_048978:          LDA $04                             ;; 048978 : A5 04       ; A = player x #$200
CODE_04897A:          XBA                                 ;; 04897A : EB          ; A = player x 2
CODE_04897B:          LSR                                 ;; 04897B : 4A          ; A = player
CODE_04897C:          TAX                                 ;; 04897C : AA          ; X = player
CODE_04897D:          LDA.W $0DB3,X                       ;; 04897D : BD B3 0D    ; A = player's lives | junk
CODE_048980:          PLX                                 ;; 048980 : FA          ; X = player x #$20
CODE_048981:          AND.W #$FF00                        ;; 048981 : 29 00 FF    ; A = player's lives | #$00
CODE_048984:          BPL CODE_04898B                     ;; 048984 : 10 05       ; branch if player's lives positive
CODE_048986:          LDA $00                             ;; 048986 : A5 00       ; A = player OW animation type x #$10
CODE_048988:          TAY                                 ;; 048988 : A8          ; Y = player OW animation type x #$10
CODE_048989:          BRA CODE_0489A7                     ;; 048989 : 80 1C       ; branch (basically, if player is out of lives, their sprite is static)
                                                          ;;                      ;
CODE_04898B:          CPX.W #$0000                        ;; 04898B : E0 00 00    ;
CODE_04898E:          BNE CODE_0489A7                     ;; 04898E : D0 17       ; skip if 2P
CODE_048990:          LDA.W $13D9                         ;; 048990 : AD D9 13    ;
CODE_048993:          CMP.W #$000B                        ;; 048993 : C9 0B 00    ;
CODE_048996:          BNE CODE_0489A7                     ;; 048996 : D0 0F       ; skip if not on star warp
CODE_048998:          LDA RAM_FrameCounter                ;; 048998 : A5 13       ; A = frame counter
CODE_04899A:          AND.W #$000C                        ;; 04899A : 29 0C 00    ; A = 0000 ff00 (f = frame counter bits)
CODE_04899D:          LSR                                 ;; 04899D : 4A          ;
CODE_04899E:          LSR                                 ;; 04899E : 4A          ; A = 2 LSB of frame counter / 4
CODE_04899F:          TAY                                 ;; 04899F : A8          ; Y = 2 LSB of frame counter / 4
CODE_0489A0:          LDA.W OWWarpIndex,Y                 ;; 0489A0 : B9 4B 89    ; A = index to use when using a star warp (overrides that complicated thing)
CODE_0489A3:          AND.W #$00FF                        ;; 0489A3 : 29 FF 00    ;
CODE_0489A6:          TAY                                 ;; 0489A6 : A8          ; Y = index into tilemap table
CODE_0489A7:          REP #$20                            ;; 0489A7 : C2 20       ; Accum (16 bit) 
CODE_0489A9:          LDA $8A                             ;; 0489A9 : A5 8A       ; A = Y-pos on screen | X-pos on screen 
CODE_0489AB:          STA.W $029C,X                       ;; 0489AB : 9D 9C 02    ; OAM y-pos and x-pos for tile
CODE_0489AE:          LDA.W OWPlayerTiles,Y               ;; 0489AE : B9 CB 87    ; get tile | yxppccct
CODE_0489B1:          CLC                                 ;; 0489B1 : 18          ;
CODE_0489B2:          ADC $04                             ;; 0489B2 : 65 04       ; add player x #$200 (increment palette of tile by 1)
CODE_0489B4:          STA.W $029E,X                       ;; 0489B4 : 9D 9E 02    ; OAM tile and yxppccct for tile
CODE_0489B7:          SEP #$20                            ;; 0489B7 : E2 20       ; Accum (8 bit) 
CODE_0489B9:          INX                                 ;; 0489B9 : E8          ;
CODE_0489BA:          INX                                 ;; 0489BA : E8          ;
CODE_0489BB:          INX                                 ;; 0489BB : E8          ;
CODE_0489BC:          INX                                 ;; 0489BC : E8          ; increment X to next OAM tile
CODE_0489BD:          INY                                 ;; 0489BD : C8          ;
CODE_0489BE:          INY                                 ;; 0489BE : C8          ; increment index to tilemap table
CODE_0489BF:          LDA $8A                             ;; 0489BF : A5 8A       ;
CODE_0489C1:          CLC                                 ;; 0489C1 : 18          ;
CODE_0489C2:          ADC.B #$08                          ;; 0489C2 : 69 08       ; \
CODE_0489C4:          STA $8A                             ;; 0489C4 : 85 8A       ; | update X and Y position of tile
CODE_0489C6:          DEC $8C                             ;; 0489C6 : C6 8C       ; | (zig zag pattern)
CODE_0489C8:          LDA $8C                             ;; 0489C8 : A5 8C       ; |
CODE_0489CA:          AND.B #$01                          ;; 0489CA : 29 01       ; |
CODE_0489CC:          BEQ CODE_0489D9                     ;; 0489CC : F0 0B       ; |
CODE_0489CE:          LDA $06                             ;; 0489CE : A5 06       ; |
CODE_0489D0:          STA $8A                             ;; 0489D0 : 85 8A       ; |
CODE_0489D2:          LDA $8B                             ;; 0489D2 : A5 8B       ; |
CODE_0489D4:          CLC                                 ;; 0489D4 : 18          ; |
CODE_0489D5:          ADC.B #$08                          ;; 0489D5 : 69 08       ; |
CODE_0489D7:          STA $8B                             ;; 0489D7 : 85 8B       ; /
CODE_0489D9:          LDA $8C                             ;; 0489D9 : A5 8C       ;
CODE_0489DB:          BPL CODE_0489A7                     ;; 0489DB : 10 CA       ; loop if we have tiles left
Return0489DD:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_0489DE:          .db $66,$24,$67,$24,$76,$24,$77,$24 ;; 0489DE               ;
                      .db $2F,$62,$2E,$62,$3F,$62,$3E,$62 ;; ?QPWZ?               ;
                      .db $66,$24,$67,$24,$76,$24,$77,$24 ;; ?QPWZ?               ;
                      .db $2E,$22,$2F,$22,$3E,$22,$3F,$22 ;; ?QPWZ?               ;
                      .db $2F,$62,$2E,$62,$3F,$62,$3E,$62 ;; ?QPWZ?               ;
                      .db $0A,$24,$0B,$24,$1A,$24,$1B,$24 ;; ?QPWZ?               ;
                      .db $2E,$22,$2F,$22,$3E,$22,$3F,$22 ;; ?QPWZ?               ;
                      .db $0A,$24,$0B,$24,$1A,$24,$1B,$24 ;; ?QPWZ?               ;
                      .db $64,$24,$65,$24,$74,$24,$75,$24 ;; ?QPWZ?               ;
                      .db $40,$22,$41,$22,$50,$22,$51,$22 ;; ?QPWZ?               ;
                      .db $64,$24,$65,$24,$74,$24,$75,$24 ;; ?QPWZ?               ;
                      .db $42,$22,$43,$24,$52,$24,$53,$24 ;; ?QPWZ?               ;
                      .db $65,$64,$64,$64,$75,$64,$74,$64 ;; ?QPWZ?               ;
                      .db $41,$62,$40,$62,$51,$62,$50,$62 ;; ?QPWZ?               ;
                      .db $65,$64,$64,$64,$75,$64,$74,$64 ;; ?QPWZ?               ;
                      .db $43,$62,$42,$62,$53,$62,$52,$62 ;; ?QPWZ?               ;
                      .db $38,$24,$38,$64,$66,$24,$67,$24 ;; ?QPWZ?               ;
                      .db $76,$24,$77,$24,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $39,$24,$39,$64,$66,$24,$67,$24 ;; ?QPWZ?               ;
                      .db $76,$24,$77,$24,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $38,$24,$38,$64,$2F,$62,$2E,$62 ;; ?QPWZ?               ;
                      .db $0A,$24,$0B,$24,$1A,$24,$1B,$24 ;; ?QPWZ?               ;
                      .db $39,$24,$39,$24,$2E,$22,$2F,$22 ;; ?QPWZ?               ;
                      .db $0A,$24,$0B,$24,$1A,$24,$1B,$24 ;; ?QPWZ?               ;
                      .db $38,$24,$38,$64,$64,$24,$65,$24 ;; ?QPWZ?               ;
                      .db $74,$24,$75,$24,$40,$22,$41,$22 ;; ?QPWZ?               ;
                      .db $39,$24,$39,$64,$64,$24,$65,$24 ;; ?QPWZ?               ;
                      .db $74,$24,$75,$24,$42,$22,$42,$22 ;; ?QPWZ?               ;
                      .db $38,$24,$38,$64,$65,$64,$64,$64 ;; ?QPWZ?               ;
                      .db $75,$64,$74,$64,$41,$62,$40,$62 ;; ?QPWZ?               ;
                      .db $39,$24,$39,$64,$65,$64,$64,$64 ;; ?QPWZ?               ;
                      .db $75,$64,$74,$64,$43,$62,$42,$62 ;; ?QPWZ?               ;
                      .db $2F,$62,$2E,$62,$3F,$62,$3E,$62 ;; ?QPWZ?               ;
                      .db $24,$24,$25,$24,$34,$24,$35,$24 ;; ?QPWZ?               ;
                      .db $2E,$22,$2F,$22,$3E,$22,$3F,$22 ;; ?QPWZ?               ;
                      .db $24,$24,$25,$24,$34,$24,$35,$24 ;; ?QPWZ?               ;
                      .db $38,$24,$38,$64,$2F,$62,$2E,$62 ;; ?QPWZ?               ;
                      .db $24,$24,$25,$24,$34,$24,$35,$24 ;; ?QPWZ?               ;
                      .db $39,$24,$39,$64,$2E,$22,$2F,$22 ;; ?QPWZ?               ;
                      .db $24,$24,$25,$24,$34,$24,$35,$24 ;; ?QPWZ?               ;
                      .db $66,$24,$67,$24,$76,$24,$77,$24 ;; ?QPWZ?               ;
                      .db $2F,$62,$2E,$62,$3F,$62,$3E,$62 ;; ?QPWZ?               ;
                      .db $66,$24,$67,$24,$76,$24,$77,$24 ;; ?QPWZ?               ;
                      .db $2E,$22,$2F,$22,$3E,$22,$3F,$22 ;; ?QPWZ?               ;
                      .db $66,$24,$67,$24,$76,$24,$77,$24 ;; ?QPWZ?               ;
                      .db $2F,$62,$2E,$62,$3F,$62,$3E,$62 ;; ?QPWZ?               ;
                      .db $66,$24,$67,$24,$76,$24,$77,$24 ;; ?QPWZ?               ;
                      .db $2E,$22,$2F,$22,$3E,$22,$3F,$22 ;; ?QPWZ?               ;
DATA_048B5E:          .db $00,$08,$00,$08,$00,$08,$00,$08 ;; 048B5E               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $07,$0F,$07,$0F,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $07,$0F,$07,$0F,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $F9,$01,$F9,$01,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $F9,$01,$F9,$01,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$07,$0F,$07,$0F,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$07,$0F,$07,$0F,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$F9,$01,$F9,$01,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$F9,$01,$F9,$01,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
DATA_048C1E:          .db $FB,$FB,$03,$03,$00,$00,$08,$08 ;; 048C1E               ;
                      .db $FA,$FA,$02,$02,$00,$00,$08,$08 ;; ?QPWZ?               ;
                      .db $00,$00,$08,$08,$F8,$F8,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$08,$08,$F9,$F9,$01,$01 ;; ?QPWZ?               ;
                      .db $FC,$FC,$04,$04,$00,$00,$08,$08 ;; ?QPWZ?               ;
                      .db $FB,$FB,$03,$03,$00,$00,$08,$08 ;; ?QPWZ?               ;
                      .db $FC,$FC,$04,$04,$00,$00,$08,$08 ;; ?QPWZ?               ;
                      .db $FB,$FB,$03,$03,$00,$00,$08,$08 ;; ?QPWZ?               ;
                      .db $08,$08,$FB,$FB,$03,$03,$00,$00 ;; ?QPWZ?               ;
                      .db $08,$08,$FA,$FA,$02,$02,$00,$00 ;; ?QPWZ?               ;
                      .db $08,$08,$00,$00,$F8,$F8,$00,$00 ;; ?QPWZ?               ;
                      .db $08,$08,$00,$00,$F9,$F9,$01,$01 ;; ?QPWZ?               ;
                      .db $08,$08,$FC,$FC,$04,$04,$00,$00 ;; ?QPWZ?               ;
                      .db $08,$08,$FB,$FB,$03,$03,$00,$00 ;; ?QPWZ?               ;
                      .db $08,$08,$FC,$FC,$04,$04,$00,$00 ;; ?QPWZ?               ;
                      .db $08,$08,$FB,$FB,$03,$03,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$08,$08,$F8,$F8,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$08,$08,$F8,$F8,$00,$00 ;; ?QPWZ?               ;
                      .db $08,$08,$00,$00,$F8,$F8,$00,$00 ;; ?QPWZ?               ;
                      .db $08,$08,$00,$00,$F8,$F8,$00,$00 ;; ?QPWZ?               ;
                      .db $FB,$FB,$03,$03,$00,$00,$08,$08 ;; ?QPWZ?               ;
                      .db $FA,$FA,$02,$02,$00,$00,$08,$08 ;; ?QPWZ?               ;
                      .db $FB,$FB,$03,$03,$00,$00,$08,$08 ;; ?QPWZ?               ;
                      .db $FA,$FA,$02,$02,$00,$00,$08,$08 ;; ?QPWZ?               ;
DATA_048CDE:          .db $00,$00,$00,$02,$00,$04,$00,$06 ;; 048CDE               ;
                                                          ;;                      ;
CODE_048CE6:          LDA.B #$07                          ;; 048CE6 : A9 07       ;
CODE_048CE8:          STA $8C                             ;; 048CE8 : 85 8C       ; $8C = #$07
CODE_048CEA:          REP #$30                            ;; 048CEA : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_048CEC:          LDA.W $1F13,Y                       ;; 048CEC : B9 13 1F    ;
CODE_048CEF:          ASL                                 ;; 048CEF : 0A          ;
CODE_048CF0:          ASL                                 ;; 048CF0 : 0A          ;
CODE_048CF1:          ASL                                 ;; 048CF1 : 0A          ;
CODE_048CF2:          ASL                                 ;; 048CF2 : 0A          ;
CODE_048CF3:          STA $00                             ;; 048CF3 : 85 00       ;
CODE_048CF5:          LDA RAM_FrameCounter                ;; 048CF5 : A5 13       ;
CODE_048CF7:          AND.W #$0008                        ;; 048CF7 : 29 08 00    ;
CODE_048CFA:          ASL                                 ;; 048CFA : 0A          ;
CODE_048CFB:          CLC                                 ;; 048CFB : 18          ;
CODE_048CFC:          ADC $00                             ;; 048CFC : 65 00       ;
CODE_048CFE:          TAY                                 ;; 048CFE : A8          ; Y = 0000 000a aaaf ffff (a = animation type, f = 5 LSB of frame counter)
CODE_048CFF:          CPX.W #$0000                        ;; 048CFF : E0 00 00    ;
CODE_048D02:          BNE CODE_048D1B                     ;; 048D02 : D0 17       ; skip if not 1P
CODE_048D04:          LDA.W $13D9                         ;; 048D04 : AD D9 13    ;
CODE_048D07:          CMP.W #$000B                        ;; 048D07 : C9 0B 00    ;
CODE_048D0A:          BNE CODE_048D1B                     ;; 048D0A : D0 0F       ; skip if not star warp
CODE_048D0C:          LDA RAM_FrameCounter                ;; 048D0C : A5 13       ;
CODE_048D0E:          AND.W #$000C                        ;; 048D0E : 29 0C 00    ;
CODE_048D11:          LSR                                 ;; 048D11 : 4A          ;
CODE_048D12:          LSR                                 ;; 048D12 : 4A          ;
CODE_048D13:          TAY                                 ;; 048D13 : A8          ; Y = 2 LSB of frame counter / 4
CODE_048D14:          LDA.W OWWarpIndex,Y                 ;; 048D14 : B9 4B 89    ;
CODE_048D17:          AND.W #$00FF                        ;; 048D17 : 29 FF 00    ;
CODE_048D1A:          TAY                                 ;; 048D1A : A8          ; Y = index into tilemap table
CODE_048D1B:          REP #$20                            ;; 048D1B : C2 20       ; Accum (16 bit) 
CODE_048D1D:          PHY                                 ;; 048D1D : 5A          ; Y = index into tilemap table
CODE_048D1E:          TYA                                 ;; 048D1E : 98          ; A = index into tilemap table
CODE_048D1F:          LSR                                 ;; 048D1F : 4A          ; / 2
CODE_048D20:          TAY                                 ;; 048D20 : A8          ; Y = index into tilemap table / 2
CODE_048D21:          SEP #$20                            ;; 048D21 : E2 20       ; Accum (8 bit) 
CODE_048D23:          LDA.W DATA_048B5E,Y                 ;; 048D23 : B9 5E 8B    ; X offset table for riding yoshi sprites
CODE_048D26:          CLC                                 ;; 048D26 : 18          ;
CODE_048D27:          ADC $8A                             ;; 048D27 : 65 8A       ;
CODE_048D29:          STA.W $029C,X                       ;; 048D29 : 9D 9C 02    ; OAM X-position
CODE_048D2C:          LDA.W DATA_048C1E,Y                 ;; 048D2C : B9 1E 8C    ; Y offset table for riding yoshi sprites
CODE_048D2F:          CLC                                 ;; 048D2F : 18          ;
CODE_048D30:          ADC $8B                             ;; 048D30 : 65 8B       ;
CODE_048D32:          STA.W $029D,X                       ;; 048D32 : 9D 9D 02    ; OAM Y-position
CODE_048D35:          PLY                                 ;; 048D35 : 7A          ;
CODE_048D36:          REP #$20                            ;; 048D36 : C2 20       ; Accum (16 bit) 
CODE_048D38:          LDA.W DATA_0489DE,Y                 ;; 048D38 : B9 DE 89    ; 
CODE_048D3B:          CMP.W #$FFFF                        ;; 048D3B : C9 FF FF    ;
CODE_048D3E:          BEQ CODE_048D67                     ;; 048D3E : F0 27       ;
CODE_048D40:          PHA                                 ;; 048D40 : 48          ;
CODE_048D41:          AND.W #$0F00                        ;; 048D41 : 29 00 0F    ;
CODE_048D44:          CMP.W #$0200                        ;; 048D44 : C9 00 02    ;
CODE_048D47:          BNE CODE_048D5E                     ;; 048D47 : D0 15       ;
CODE_048D49:          STY $08                             ;; 048D49 : 84 08       ;
CODE_048D4B:          LDA $0E                             ;; 048D4B : A5 0E       ;
CODE_048D4D:          SEC                                 ;; 048D4D : 38          ;
CODE_048D4E:          SBC.W #$0004                        ;; 048D4E : E9 04 00    ;
CODE_048D51:          TAY                                 ;; 048D51 : A8          ;
CODE_048D52:          PLA                                 ;; 048D52 : 68          ;
CODE_048D53:          AND.W #$F0FF                        ;; 048D53 : 29 FF F0    ;
CODE_048D56:          ORA.W DATA_048CDE,Y                 ;; 048D56 : 19 DE 8C    ;
CODE_048D59:          PHA                                 ;; 048D59 : 48          ;
CODE_048D5A:          LDY $08                             ;; 048D5A : A4 08       ;
CODE_048D5C:          BRA CODE_048D63                     ;; 048D5C : 80 05       ;
                                                          ;;                      ;
CODE_048D5E:          PLA                                 ;; 048D5E : 68          ;
CODE_048D5F:          CLC                                 ;; 048D5F : 18          ;
CODE_048D60:          ADC $04                             ;; 048D60 : 65 04       ;
CODE_048D62:          PHA                                 ;; 048D62 : 48          ;
CODE_048D63:          PLA                                 ;; 048D63 : 68          ;
CODE_048D64:          STA.W $029E,X                       ;; 048D64 : 9D 9E 02    ;
CODE_048D67:          SEP #$20                            ;; 048D67 : E2 20       ; Accum (8 bit) 
CODE_048D69:          INX                                 ;; 048D69 : E8          ;
CODE_048D6A:          INX                                 ;; 048D6A : E8          ;
CODE_048D6B:          INX                                 ;; 048D6B : E8          ;
CODE_048D6C:          INX                                 ;; 048D6C : E8          ;
CODE_048D6D:          INY                                 ;; 048D6D : C8          ;
CODE_048D6E:          INY                                 ;; 048D6E : C8          ;
CODE_048D6F:          DEC $8C                             ;; 048D6F : C6 8C       ;
CODE_048D71:          BPL CODE_048D1B                     ;; 048D71 : 10 A8       ;
Return048D73:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_048D74:          .db $0B,$00,$13,$00,$1A,$00,$1B,$00 ;; 048D74               ;
                      .db $1F,$00,$20,$00,$31,$00,$32,$00 ;; ?QPWZ?               ;
                      .db $34,$00,$35,$00,$40,$00         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_048D8A:          .db $02,$03,$04,$06,$07,$09,$05     ;; 048D8A               ;
                                                          ;;                      ;
CODE_048D91:          PHB                                 ;; 048D91 : 8B          ; Index (8 bit) 
CODE_048D92:          PHK                                 ;; 048D92 : 4B          ;
CODE_048D93:          PLB                                 ;; 048D93 : AB          ;
CODE_048D94:          STZ.W $1B9E                         ;; 048D94 : 9C 9E 1B    ;
CODE_048D97:          LDA.B #$0F                          ;; 048D97 : A9 0F       ;
CODE_048D99:          STA.W $144E                         ;; 048D99 : 8D 4E 14    ;
CODE_048D9C:          LDX.B #$02                          ;; 048D9C : A2 02       ;
CODE_048D9E:          LDA.W $1F13                         ;; 048D9E : AD 13 1F    ;
CODE_048DA1:          CMP.B #$12                          ;; 048DA1 : C9 12       ;
CODE_048DA3:          BEQ CODE_048DA9                     ;; 048DA3 : F0 04       ;
CODE_048DA5:          AND.B #$08                          ;; 048DA5 : 29 08       ;
CODE_048DA7:          BEQ CODE_048DAB                     ;; 048DA7 : F0 02       ;
CODE_048DA9:          LDX.B #$0A                          ;; 048DA9 : A2 0A       ;
CODE_048DAB:          STX.W $1F13                         ;; 048DAB : 8E 13 1F    ;
CODE_048DAE:          LDX.B #$02                          ;; 048DAE : A2 02       ;
CODE_048DB0:          LDA.W $1F15                         ;; 048DB0 : AD 15 1F    ;
CODE_048DB3:          CMP.B #$12                          ;; 048DB3 : C9 12       ;
CODE_048DB5:          BEQ CODE_048DBB                     ;; 048DB5 : F0 04       ;
CODE_048DB7:          AND.B #$08                          ;; 048DB7 : 29 08       ;
CODE_048DB9:          BEQ CODE_048DBD                     ;; 048DB9 : F0 02       ;
CODE_048DBB:          LDX.B #$0A                          ;; 048DBB : A2 0A       ;
CODE_048DBD:          STX.W $1F15                         ;; 048DBD : 8E 15 1F    ;
CODE_048DC0:          SEP #$10                            ;; 048DC0 : E2 10       ; Index (8 bit) 
CODE_048DC2:          JSR.W CODE_048E55                   ;; 048DC2 : 20 55 8E    ;
CODE_048DC5:          REP #$30                            ;; 048DC5 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_048DC7:          LDA.W $0DD4                         ;; 048DC7 : AD D4 0D    ;
CODE_048DCA:          AND.W #$FF00                        ;; 048DCA : 29 00 FF    ;
CODE_048DCD:          BEQ CODE_048DDF                     ;; 048DCD : F0 10       ;
CODE_048DCF:          BMI CODE_048DDF                     ;; 048DCF : 30 0E       ;
CODE_048DD1:          LDA.W $13BF                         ;; 048DD1 : AD BF 13    ;
CODE_048DD4:          AND.W #$00FF                        ;; 048DD4 : 29 FF 00    ;
CODE_048DD7:          CMP.W #$0018                        ;; 048DD7 : C9 18 00    ;
CODE_048DDA:          BNE CODE_048DDF                     ;; 048DDA : D0 03       ;
CODE_048DDC:          BRL CODE_048E34                     ;; 048DDC : 82 55 00    ;
CODE_048DDF:          LDA.W $13C6                         ;; 048DDF : AD C6 13    ;
CODE_048DE2:          AND.W #$00FF                        ;; 048DE2 : 29 FF 00    ;
CODE_048DE5:          BEQ CODE_048E38                     ;; 048DE5 : F0 51       ;
CODE_048DE7:          LDA.W $13C6                         ;; 048DE7 : AD C6 13    ;
CODE_048DEA:          AND.W #$FF00                        ;; 048DEA : 29 00 FF    ;
CODE_048DED:          STA.W $13C6                         ;; 048DED : 8D C6 13    ;
CODE_048DF0:          SEP #$10                            ;; 048DF0 : E2 10       ; Index (8 bit) 
CODE_048DF2:          LDX.W $0DD6                         ;; 048DF2 : AE D6 0D    ;
CODE_048DF5:          LDA.W $1F17,X                       ;; 048DF5 : BD 17 1F    ;
CODE_048DF8:          LSR                                 ;; 048DF8 : 4A          ;
CODE_048DF9:          LSR                                 ;; 048DF9 : 4A          ;
CODE_048DFA:          LSR                                 ;; 048DFA : 4A          ;
CODE_048DFB:          LSR                                 ;; 048DFB : 4A          ;
CODE_048DFC:          STA $00                             ;; 048DFC : 85 00       ;
CODE_048DFE:          LDA.W $1F19,X                       ;; 048DFE : BD 19 1F    ;
CODE_048E01:          LSR                                 ;; 048E01 : 4A          ;
CODE_048E02:          LSR                                 ;; 048E02 : 4A          ;
CODE_048E03:          LSR                                 ;; 048E03 : 4A          ;
CODE_048E04:          LSR                                 ;; 048E04 : 4A          ;
CODE_048E05:          STA $02                             ;; 048E05 : 85 02       ;
CODE_048E07:          TXA                                 ;; 048E07 : 8A          ;
CODE_048E08:          LSR                                 ;; 048E08 : 4A          ;
CODE_048E09:          LSR                                 ;; 048E09 : 4A          ;
CODE_048E0A:          TAX                                 ;; 048E0A : AA          ;
CODE_048E0B:          JSR.W OW_TilePos_Calc               ;; 048E0B : 20 85 98    ;
CODE_048E0E:          REP #$10                            ;; 048E0E : C2 10       ; Index (16 bit) 
CODE_048E10:          LDX $04                             ;; 048E10 : A6 04       ;
CODE_048E12:          LDA.L $7ED000,X                     ;; 048E12 : BF 00 D0 7E ;
CODE_048E16:          AND.W #$00FF                        ;; 048E16 : 29 FF 00    ;
CODE_048E19:          TAX                                 ;; 048E19 : AA          ;
CODE_048E1A:          LDA.W $1EA2,X                       ;; 048E1A : BD A2 1E    ;
CODE_048E1D:          AND.W #$0080                        ;; 048E1D : 29 80 00    ;
CODE_048E20:          BNE CODE_048E38                     ;; 048E20 : D0 16       ;
CODE_048E22:          LDY.W #$0014                        ;; 048E22 : A0 14 00    ;
CODE_048E25:          LDA.W $13BF                         ;; 048E25 : AD BF 13    ;
CODE_048E28:          AND.W #$00FF                        ;; 048E28 : 29 FF 00    ;
CODE_048E2B:          CMP.W DATA_048D74,Y                 ;; 048E2B : D9 74 8D    ;
CODE_048E2E:          BEQ CODE_048E38                     ;; 048E2E : F0 08       ;
CODE_048E30:          DEY                                 ;; 048E30 : 88          ;
CODE_048E31:          DEY                                 ;; 048E31 : 88          ;
CODE_048E32:          BPL CODE_048E25                     ;; 048E32 : 10 F1       ;
CODE_048E34:          SEP #$30                            ;; 048E34 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_048E36:          BRA CODE_048E47                     ;; 048E36 : 80 0F       ;
                                                          ;;                      ;
CODE_048E38:          SEP #$30                            ;; 048E38 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_048E3A:          LDX.W $0DB3                         ;; 048E3A : AE B3 0D    ;
CODE_048E3D:          LDA.W $1F11,X                       ;; 048E3D : BD 11 1F    ;
CODE_048E40:          TAX                                 ;; 048E40 : AA          ;
CODE_048E41:          LDA.W DATA_048D8A,X                 ;; 048E41 : BD 8A 8D    ;
CODE_048E44:          STA.W $1DFB                         ;; 048E44 : 8D FB 1D    ; / Change music 
CODE_048E47:          PLB                                 ;; 048E47 : AB          ;
Return048E48:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_048E49:          .db $28,$01,$00,$00,$88,$01         ;; 048E49               ;
                                                          ;;                      ;
DATA_048E4F:          .db $C8,$01,$00,$00,$D8,$01         ;; 048E4F               ;
                                                          ;;                      ;
CODE_048E55:          REP #$30                            ;; 048E55 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_048E57:          LDA.W $0DB3                         ;; 048E57 : AD B3 0D    ;
CODE_048E5A:          AND.W #$00FF                        ;; 048E5A : 29 FF 00    ;
CODE_048E5D:          ASL                                 ;; 048E5D : 0A          ;
CODE_048E5E:          ASL                                 ;; 048E5E : 0A          ;
CODE_048E5F:          STA.W $0DD6                         ;; 048E5F : 8D D6 0D    ;
CODE_048E62:          LDX.W $0DD6                         ;; 048E62 : AE D6 0D    ;
CODE_048E65:          LDA.W $1F1F,X                       ;; 048E65 : BD 1F 1F    ;
CODE_048E68:          STA $00                             ;; 048E68 : 85 00       ;
CODE_048E6A:          LDA.W $1F21,X                       ;; 048E6A : BD 21 1F    ;
CODE_048E6D:          STA $02                             ;; 048E6D : 85 02       ;
CODE_048E6F:          TXA                                 ;; 048E6F : 8A          ;
CODE_048E70:          LSR                                 ;; 048E70 : 4A          ;
CODE_048E71:          LSR                                 ;; 048E71 : 4A          ;
CODE_048E72:          TAX                                 ;; 048E72 : AA          ;
CODE_048E73:          JSR.W OW_TilePos_Calc               ;; 048E73 : 20 85 98    ;
CODE_048E76:          STZ $00                             ;; 048E76 : 64 00       ;
CODE_048E78:          LDX $04                             ;; 048E78 : A6 04       ;
CODE_048E7A:          LDA.L $7ED000,X                     ;; 048E7A : BF 00 D0 7E ;
CODE_048E7E:          AND.W #$00FF                        ;; 048E7E : 29 FF 00    ;
CODE_048E81:          ASL                                 ;; 048E81 : 0A          ;
CODE_048E82:          TAX                                 ;; 048E82 : AA          ;
CODE_048E83:          LDA.W LevelNames,X                  ;; 048E83 : BD FC A0    ;
CODE_048E86:          STA $00                             ;; 048E86 : 85 00       ;
CODE_048E88:          JSR.W CODE_049D07                   ;; 048E88 : 20 07 9D    ;
CODE_048E8B:          LDX $04                             ;; 048E8B : A6 04       ;
CODE_048E8D:          BMI CODE_048E9E                     ;; 048E8D : 30 0F       ;
CODE_048E8F:          CPX.W #$0800                        ;; 048E8F : E0 00 08    ;
CODE_048E92:          BCS CODE_048E9E                     ;; 048E92 : B0 0A       ;
CODE_048E94:          LDA.L $7EC800,X                     ;; 048E94 : BF 00 C8 7E ;
CODE_048E98:          AND.W #$00FF                        ;; 048E98 : 29 FF 00    ;
CODE_048E9B:          STA.W $13C1                         ;; 048E9B : 8D C1 13    ;
CODE_048E9E:          SEP #$30                            ;; 048E9E : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_048EA0:          LDX.W $0EF7                         ;; 048EA0 : AE F7 0E    ;
CODE_048EA3:          BEQ CODE_048EE1                     ;; 048EA3 : F0 3C       ;
ADDR_048EA5:          BPL ADDR_048ED9                     ;; 048EA5 : 10 32       ;
ADDR_048EA7:          TXA                                 ;; 048EA7 : 8A          ;
ADDR_048EA8:          AND.B #$7F                          ;; 048EA8 : 29 7F       ;
ADDR_048EAA:          TAX                                 ;; 048EAA : AA          ;
ADDR_048EAB:          STZ.W $0DF5,X                       ;; 048EAB : 9E F5 0D    ;
ADDR_048EAE:          LDA.W $0EF6                         ;; 048EAE : AD F6 0E    ;
ADDR_048EB1:          LDX.W $0DD5                         ;; 048EB1 : AE D5 0D    ;
ADDR_048EB4:          BPL ADDR_048ECD                     ;; 048EB4 : 10 17       ;
ADDR_048EB6:          ASL                                 ;; 048EB6 : 0A          ;
ADDR_048EB7:          TAX                                 ;; 048EB7 : AA          ;
ADDR_048EB8:          REP #$20                            ;; 048EB8 : C2 20       ; Accum (16 bit) 
ADDR_048EBA:          LDY.W $0DD6                         ;; 048EBA : AC D6 0D    ;
ADDR_048EBD:          LDA.W DATA_048E49,X                 ;; 048EBD : BD 49 8E    ;
ADDR_048EC0:          STA.W $1F17,Y                       ;; 048EC0 : 99 17 1F    ;
ADDR_048EC3:          LDA.W DATA_048E4F,X                 ;; 048EC3 : BD 4F 8E    ;
ADDR_048EC6:          STA.W $1F19,Y                       ;; 048EC6 : 99 19 1F    ;
ADDR_048EC9:          SEP #$20                            ;; 048EC9 : E2 20       ; Accum (8 bit) 
ADDR_048ECB:          BRA CODE_048EE1                     ;; 048ECB : 80 14       ;
                                                          ;;                      ;
ADDR_048ECD:          TAX                                 ;; 048ECD : AA          ;
ADDR_048ECE:          LDA.W DATA_04FB85,X                 ;; 048ECE : BD 85 FB    ;
ADDR_048ED1:          ORA.W $0EF5                         ;; 048ED1 : 0D F5 0E    ;
ADDR_048ED4:          STA.W $0EF5                         ;; 048ED4 : 8D F5 0E    ;
ADDR_048ED7:          BRA CODE_048EE1                     ;; 048ED7 : 80 08       ;
                                                          ;;                      ;
ADDR_048ED9:          LDA.W $0DD5                         ;; 048ED9 : AD D5 0D    ;
ADDR_048EDC:          BMI CODE_048EE1                     ;; 048EDC : 30 03       ;
ADDR_048EDE:          STZ.W $0DE5,X                       ;; 048EDE : 9E E5 0D    ;
CODE_048EE1:          REP #$30                            ;; 048EE1 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_048EE3:          JSR.W CODE_049831                   ;; 048EE3 : 20 31 98    ;
CODE_048EE6:          SEP #$30                            ;; 048EE6 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_048EE8:          JSR.W DrawOWBoarder?                ;; 048EE8 : 20 A4 85    ;
CODE_048EEB:          JSR.W CODE_048086                   ;; 048EEB : 20 86 80    ;
CODE_048EEE:          JMP.W OW_Tile_Animation             ;; 048EEE : 4C E0 80    ;
                                                          ;;                      ;
CODE_048EF1:          LDA.B #$08                          ;; 048EF1 : A9 08       ;
CODE_048EF3:          STA.W $0DB1                         ;; 048EF3 : 8D B1 0D    ;
CODE_048EF6:          LDA.W $1F11                         ;; 048EF6 : AD 11 1F    ;
CODE_048EF9:          CMP.B #$01                          ;; 048EF9 : C9 01       ;
CODE_048EFB:          BNE CODE_048F13                     ;; 048EFB : D0 16       ;
CODE_048EFD:          LDA.W $1F17                         ;; 048EFD : AD 17 1F    ;
CODE_048F00:          CMP.B #$68                          ;; 048F00 : C9 68       ;
CODE_048F02:          BNE CODE_048F13                     ;; 048F02 : D0 0F       ;
CODE_048F04:          LDA.W $1F19                         ;; 048F04 : AD 19 1F    ;
CODE_048F07:          CMP.B #$8E                          ;; 048F07 : C9 8E       ;
CODE_048F09:          BNE CODE_048F13                     ;; 048F09 : D0 08       ;
CODE_048F0B:          LDA.B #$0C                          ;; 048F0B : A9 0C       ;
CODE_048F0D:          STA.W $13D9                         ;; 048F0D : 8D D9 13    ;
CODE_048F10:          BRL CODE_048F7A                     ;; 048F10 : 82 67 00    ;
CODE_048F13:          REP #$20                            ;; 048F13 : C2 20       ; Accum (16 bit) 
CODE_048F15:          LDX.W $0DD6                         ;; 048F15 : AE D6 0D    ;
CODE_048F18:          LDA.W $1F17,X                       ;; 048F18 : BD 17 1F    ;
CODE_048F1B:          LSR                                 ;; 048F1B : 4A          ;
CODE_048F1C:          LSR                                 ;; 048F1C : 4A          ;
CODE_048F1D:          LSR                                 ;; 048F1D : 4A          ;
CODE_048F1E:          LSR                                 ;; 048F1E : 4A          ;
CODE_048F1F:          STA $00                             ;; 048F1F : 85 00       ;
CODE_048F21:          LDA.W $1F19,X                       ;; 048F21 : BD 19 1F    ;
CODE_048F24:          LSR                                 ;; 048F24 : 4A          ;
CODE_048F25:          LSR                                 ;; 048F25 : 4A          ;
CODE_048F26:          LSR                                 ;; 048F26 : 4A          ;
CODE_048F27:          LSR                                 ;; 048F27 : 4A          ;
CODE_048F28:          STA $02                             ;; 048F28 : 85 02       ;
CODE_048F2A:          TXA                                 ;; 048F2A : 8A          ;
CODE_048F2B:          LSR                                 ;; 048F2B : 4A          ;
CODE_048F2C:          LSR                                 ;; 048F2C : 4A          ;
CODE_048F2D:          TAX                                 ;; 048F2D : AA          ;
CODE_048F2E:          JSR.W OW_TilePos_Calc               ;; 048F2E : 20 85 98    ;
CODE_048F31:          REP #$10                            ;; 048F31 : C2 10       ; Index (16 bit) 
CODE_048F33:          SEP #$20                            ;; 048F33 : E2 20       ; Accum (8 bit) 
CODE_048F35:          LDA.W $13CE                         ;; 048F35 : AD CE 13    ;
CODE_048F38:          BEQ CODE_048F56                     ;; 048F38 : F0 1C       ;
CODE_048F3A:          LDA.W $0DD5                         ;; 048F3A : AD D5 0D    ;
CODE_048F3D:          BEQ CODE_048F56                     ;; 048F3D : F0 17       ;
CODE_048F3F:          BPL CODE_048F5F                     ;; 048F3F : 10 1E       ;
CODE_048F41:          REP #$20                            ;; 048F41 : C2 20       ; Accum (16 bit) 
CODE_048F43:          LDX $04                             ;; 048F43 : A6 04       ;
CODE_048F45:          LDA.L $7ED000,X                     ;; 048F45 : BF 00 D0 7E ;
CODE_048F49:          AND.W #$00FF                        ;; 048F49 : 29 FF 00    ;
CODE_048F4C:          TAX                                 ;; 048F4C : AA          ;
CODE_048F4D:          LDA.W $1EA2,X                       ;; 048F4D : BD A2 1E    ;
CODE_048F50:          ORA.W #$0040                        ;; 048F50 : 09 40 00    ;
CODE_048F53:          STA.W $1EA2,X                       ;; 048F53 : 9D A2 1E    ;
CODE_048F56:          SEP #$20                            ;; 048F56 : E2 20       ; Accum (8 bit) 
CODE_048F58:          LDA.B #$05                          ;; 048F58 : A9 05       ;
CODE_048F5A:          STA.W $13D9                         ;; 048F5A : 8D D9 13    ;
CODE_048F5D:          BRA CODE_048F7A                     ;; 048F5D : 80 1B       ;
                                                          ;;                      ;
CODE_048F5F:          REP #$20                            ;; 048F5F : C2 20       ; Accum (16 bit) 
CODE_048F61:          LDX $04                             ;; 048F61 : A6 04       ;
CODE_048F63:          LDA.L $7ED000,X                     ;; 048F63 : BF 00 D0 7E ;
CODE_048F67:          AND.W #$00FF                        ;; 048F67 : 29 FF 00    ;
CODE_048F6A:          TAX                                 ;; 048F6A : AA          ;
CODE_048F6B:          LDA.W $1EA2,X                       ;; 048F6B : BD A2 1E    ;
CODE_048F6E:          ORA.W #$0080                        ;; 048F6E : 09 80 00    ;
CODE_048F71:          AND.W #$FFBF                        ;; 048F71 : 29 BF FF    ;
CODE_048F74:          STA.W $1EA2,X                       ;; 048F74 : 9D A2 1E    ;
CODE_048F77:          INC.W $13D9                         ;; 048F77 : EE D9 13    ;
CODE_048F7A:          REP #$30                            ;; 048F7A : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_048F7C:          JMP.W CODE_049831                   ;; 048F7C : 4C 31 98    ;
                                                          ;;                      ;
                                                          ;;                      ;
DATA_048F7F:          .db $58,$59,$5D,$63,$77,$79,$7E,$80 ;; 048F7F               ;
                                                          ;;                      ;
CODE_048F87:          JSR.W CODE_049903                   ;; 048F87 : 20 03 99    ; Index (8 bit) 
CODE_048F8A:          LDX.B #$07                          ;; 048F8A : A2 07       ;
CODE_048F8C:          LDA.W $13C1                         ;; 048F8C : AD C1 13    ;
CODE_048F8F:          CMP.W DATA_048F7F,X                 ;; 048F8F : DD 7F 8F    ;
CODE_048F92:          BNE CODE_049000                     ;; 048F92 : D0 6C       ;
CODE_048F94:          LDX.B #$2C                          ;; 048F94 : A2 2C       ;
CODE_048F96:          LDA.W $1F02,X                       ;; 048F96 : BD 02 1F    ;
CODE_048F99:          STA.W $1FA9,X                       ;; 048F99 : 9D A9 1F    ;
CODE_048F9C:          DEX                                 ;; 048F9C : CA          ;
CODE_048F9D:          BPL CODE_048F96                     ;; 048F9D : 10 F7       ;
CODE_048F9F:          REP #$30                            ;; 048F9F : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_048FA1:          LDX.W $0DD6                         ;; 048FA1 : AE D6 0D    ;
CODE_048FA4:          TXA                                 ;; 048FA4 : 8A          ;
CODE_048FA5:          EOR.W #$0004                        ;; 048FA5 : 49 04 00    ;
CODE_048FA8:          TAY                                 ;; 048FA8 : A8          ;
CODE_048FA9:          LDA.W $1FBE,X                       ;; 048FA9 : BD BE 1F    ;
CODE_048FAC:          STA.W $1FBE,Y                       ;; 048FAC : 99 BE 1F    ;
CODE_048FAF:          LDA.W $1FC0,X                       ;; 048FAF : BD C0 1F    ;
CODE_048FB2:          STA.W $1FC0,Y                       ;; 048FB2 : 99 C0 1F    ;
CODE_048FB5:          LDA.W $1FC6,X                       ;; 048FB5 : BD C6 1F    ;
CODE_048FB8:          STA.W $1FC6,Y                       ;; 048FB8 : 99 C6 1F    ;
CODE_048FBB:          LDA.W $1FC8,X                       ;; 048FBB : BD C8 1F    ;
CODE_048FBE:          STA.W $1FC8,Y                       ;; 048FBE : 99 C8 1F    ;
CODE_048FC1:          TXA                                 ;; 048FC1 : 8A          ;
CODE_048FC2:          LSR                                 ;; 048FC2 : 4A          ;
CODE_048FC3:          TAX                                 ;; 048FC3 : AA          ;
CODE_048FC4:          EOR.W #$0002                        ;; 048FC4 : 49 02 00    ;
CODE_048FC7:          TAY                                 ;; 048FC7 : A8          ;
CODE_048FC8:          LDA.W $1FBA,X                       ;; 048FC8 : BD BA 1F    ;
CODE_048FCB:          STA.W $1FBA,Y                       ;; 048FCB : 99 BA 1F    ;
CODE_048FCE:          TXA                                 ;; 048FCE : 8A          ;
CODE_048FCF:          SEP #$30                            ;; 048FCF : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_048FD1:          LSR                                 ;; 048FD1 : 4A          ;
CODE_048FD2:          TAX                                 ;; 048FD2 : AA          ;
CODE_048FD3:          EOR.B #$01                          ;; 048FD3 : 49 01       ;
CODE_048FD5:          TAY                                 ;; 048FD5 : A8          ;
CODE_048FD6:          LDA.W $1FB8,X                       ;; 048FD6 : BD B8 1F    ;
CODE_048FD9:          STA.W $1FB8,Y                       ;; 048FD9 : 99 B8 1F    ;
CODE_048FDC:          LDA.W $0DD5                         ;; 048FDC : AD D5 0D    ;
CODE_048FDF:          CMP.B #$E0                          ;; 048FDF : C9 E0       ;
CODE_048FE1:          BNE CODE_048FFB                     ;; 048FE1 : D0 18       ;
ADDR_048FE3:          DEC.W $0DB1                         ;; 048FE3 : CE B1 0D    ;
ADDR_048FE6:          BMI ADDR_048FE9                     ;; 048FE6 : 30 01       ;
Return048FE8:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
ADDR_048FE9:          INC.W $13CA                         ;; 048FE9 : EE CA 13    ;
ADDR_048FEC:          JSR.W CODE_049037                   ;; 048FEC : 20 37 90    ;
ADDR_048FEF:          LDA.B #$02                          ;; 048FEF : A9 02       ;
ADDR_048FF1:          STA.W $0DB1                         ;; 048FF1 : 8D B1 0D    ;
ADDR_048FF4:          LDA.B #$04                          ;; 048FF4 : A9 04       ;
ADDR_048FF6:          STA.W $13D9                         ;; 048FF6 : 8D D9 13    ;
ADDR_048FF9:          BRA CODE_049003                     ;; 048FF9 : 80 08       ;
                                                          ;;                      ;
CODE_048FFB:          INC.W $13CA                         ;; 048FFB : EE CA 13    ;
CODE_048FFE:          BRA CODE_049003                     ;; 048FFE : 80 03       ;
                                                          ;;                      ;
CODE_049000:          DEX                                 ;; 049000 : CA          ;
CODE_049001:          BPL CODE_048F8C                     ;; 049001 : 10 89       ;
CODE_049003:          REP #$20                            ;; 049003 : C2 20       ; Accum (16 bit) 
CODE_049005:          STZ $06                             ;; 049005 : 64 06       ;
CODE_049007:          LDX.W $0DD6                         ;; 049007 : AE D6 0D    ;
CODE_04900A:          LDA.W $1F17,X                       ;; 04900A : BD 17 1F    ;
CODE_04900D:          LSR                                 ;; 04900D : 4A          ;
CODE_04900E:          LSR                                 ;; 04900E : 4A          ;
CODE_04900F:          LSR                                 ;; 04900F : 4A          ;
CODE_049010:          LSR                                 ;; 049010 : 4A          ;
CODE_049011:          STA $00                             ;; 049011 : 85 00       ;
CODE_049013:          LDA.W $1F19,X                       ;; 049013 : BD 19 1F    ;
CODE_049016:          LSR                                 ;; 049016 : 4A          ;
CODE_049017:          LSR                                 ;; 049017 : 4A          ;
CODE_049018:          LSR                                 ;; 049018 : 4A          ;
CODE_049019:          LSR                                 ;; 049019 : 4A          ;
CODE_04901A:          STA $02                             ;; 04901A : 85 02       ;
CODE_04901C:          TXA                                 ;; 04901C : 8A          ;
CODE_04901D:          LSR                                 ;; 04901D : 4A          ;
CODE_04901E:          LSR                                 ;; 04901E : 4A          ;
CODE_04901F:          TAX                                 ;; 04901F : AA          ;
CODE_049020:          JSR.W OW_TilePos_Calc               ;; 049020 : 20 85 98    ;
CODE_049023:          REP #$10                            ;; 049023 : C2 10       ; Index (16 bit) 
CODE_049025:          LDX $04                             ;; 049025 : A6 04       ;
CODE_049027:          LDA.L $7EC800,X                     ;; 049027 : BF 00 C8 7E ;
CODE_04902B:          AND.W #$00FF                        ;; 04902B : 29 FF 00    ;
CODE_04902E:          STA.W $13C1                         ;; 04902E : 8D C1 13    ;
CODE_049031:          SEP #$30                            ;; 049031 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_049033:          INC.W $13D9                         ;; 049033 : EE D9 13    ;
Return049036:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_049037:          PHX                                 ;; 049037 : DA          ;
CODE_049038:          PHY                                 ;; 049038 : 5A          ;
CODE_049039:          PHP                                 ;; 049039 : 08          ;
CODE_04903A:          SEP #$30                            ;; 04903A : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04903C:          LDA.W $13CA                         ;; 04903C : AD CA 13    ;
CODE_04903F:          BEQ CODE_049054                     ;; 04903F : F0 13       ;
CODE_049041:          LDX.B #$5F                          ;; 049041 : A2 5F       ;
CODE_049043:          LDA.W $1EA2,X                       ;; 049043 : BD A2 1E    ;
CODE_049046:          STA.W $1F49,X                       ;; 049046 : 9D 49 1F    ;
CODE_049049:          DEX                                 ;; 049049 : CA          ;
CODE_04904A:          BPL CODE_049043                     ;; 04904A : 10 F7       ;
CODE_04904C:          STZ.W $13CA                         ;; 04904C : 9C CA 13    ;
CODE_04904F:          LDA.B #$05                          ;; 04904F : A9 05       ;
CODE_049051:          STA.W $1B87                         ;; 049051 : 8D 87 1B    ;
CODE_049054:          PLP                                 ;; 049054 : 28          ;
CODE_049055:          PLY                                 ;; 049055 : 7A          ;
CODE_049056:          PLX                                 ;; 049056 : FA          ;
Return049057:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_049058:          .db $FF,$FF,$01,$00,$FF,$FF,$01,$00 ;; 049058               ;
DATA_049060:          .db $05,$03,$01,$00                 ;; 049060               ;
                                                          ;;                      ;
DATA_049064:          .db $00,$00,$02,$00,$04,$00,$06,$00 ;; 049064               ;
DATA_04906C:          .db $28,$00,$08,$00,$14,$00,$36,$00 ;; 04906C               ;
                      .db $3F,$00,$45,$00                 ;; ?QPWZ?               ;
                                                          ;;                      ;
HardCodedOWPaths:     .db $09,$15,$23,$1B,$43,$44,$24,$FF ;; ?QPWZ?               ;
                      .db $30,$31                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_049082:          .db $78,$01                         ;; 049082               ;
                                                          ;;                      ;
DATA_049084:          .db $28,$01                         ;; 049084               ;
                                                          ;;                      ;
DATA_049086:          .db $10,$10,$1E,$19,$16,$66,$16,$19 ;; 049086               ;
                      .db $1E,$10,$10,$66,$04,$04,$04,$58 ;; ?QPWZ?               ;
                      .db $04,$04,$04,$66,$04,$04,$04,$04 ;; ?QPWZ?               ;
                      .db $04,$6A,$04,$04,$04,$04,$04,$66 ;; ?QPWZ?               ;
                      .db $1E,$19,$06,$09,$0F,$20,$1A,$21 ;; ?QPWZ?               ;
                      .db $1A,$14,$19,$18,$1F,$17,$82,$17 ;; ?QPWZ?               ;
                      .db $1F,$18,$19,$14,$1A,$21,$1A,$20 ;; ?QPWZ?               ;
                      .db $0F,$09,$06,$19,$1E,$66,$04,$04 ;; ?QPWZ?               ;
                      .db $58,$04,$04,$5F                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_0490CA:          .db $02,$02,$02,$02,$06,$06,$04,$04 ;; 0490CA               ;
                      .db $00,$00,$00,$00,$04,$04,$04,$04 ;; ?QPWZ?               ;
                      .db $06,$06,$06,$06,$06,$06,$06,$06 ;; ?QPWZ?               ;
                      .db $06,$06,$04,$04,$04,$04,$04,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$06,$06,$00,$00,$00,$04 ;; ?QPWZ?               ;
                      .db $00,$04,$04,$00,$04,$00,$04,$06 ;; ?QPWZ?               ;
                      .db $02,$06,$02,$06,$06,$02,$06,$02 ;; ?QPWZ?               ;
                      .db $02,$02,$04,$04,$00,$00,$06,$06 ;; ?QPWZ?               ;
                      .db $06,$04,$04,$04                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04910E:          .db $00,$06,$0C,$10,$14,$1A,$20,$2F ;; 04910E               ;
                      .db $3E,$41,$08,$00,$04,$00,$02,$00 ;; ?QPWZ?               ;
                      .db $01,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_049120:          STZ.W $0DD8                         ;; 049120 : 9C D8 0D    ;
CODE_049123:          LDY.W $0EF7                         ;; 049123 : AC F7 0E    ;
CODE_049126:          BMI OWPU_NotOnPipe                  ;; 049126 : 30 71       ;
CODE_049128:          LDA.W $0DD5                         ;; 049128 : AD D5 0D    ;
CODE_04912B:          BMI CODE_049132                     ;; 04912B : 30 05       ;
CODE_04912D:          BEQ CODE_049132                     ;; 04912D : F0 03       ;
CODE_04912F:          BRL CODE_0491E9                     ;; 04912F : 82 B7 00    ;
CODE_049132:          LDA $16                             ;; 049132 : A5 16       ;
CODE_049134:          AND.B #$20                          ;; 049134 : 29 20       ;
CODE_049136:          BRA OW_Player_Update                ;; 049136 : 80 09       ; Change to BEQ to enable below debug code 
                                                          ;;                      ;
ADDR_049138:          LDA.W $13C1                         ;; 049138 : AD C1 13    ; \ Unreachable 
ADDR_04913B:          BEQ CODE_049165                     ;; 04913B : F0 28       ;  | Debug: Warp to star road from Yoshi's house 
ADDR_04913D:          CMP.B #$56                          ;; 04913D : C9 56       ;  | 
ADDR_04913F:          BEQ CODE_049165                     ;; 04913F : F0 24       ; / 
OW_Player_Update:     LDA RAM_ControllerB                 ;; Player_Update : A5 17       ; \ 
CODE_049143:          AND.B #$30                          ;; 049143 : 29 30       ;  |If L and R aren't pressed, 
CODE_049145:          CMP.B #$30                          ;; 049145 : C9 30       ;  |branch to OWPU_NoLR 
CODE_049147:          BNE OWPU_NoLR                       ;; 049147 : D0 07       ; / 
ADDR_049149:          LDA.W $13C1                         ;; 049149 : AD C1 13    ; \ 
ADDR_04914C:          CMP.B #$81                          ;; 04914C : C9 81       ;  |If Mario is standing on Destroyed Castle, 
ADDR_04914E:          BEQ OWPU_EnterLevel                 ;; 04914E : F0 4F       ; / branch to OWPU_EnterLevel 
OWPU_NoLR:            LDA $16                             ;;   NoLR : A5 16       ; \ 
CODE_049152:          ORA $18                             ;; 049152 : 05 18       ;  |If A, B, X or Y are pressed, 
CODE_049154:          AND.B #$C0                          ;; 049154 : 29 C0       ;  |branch to OWPU_ABXY 
CODE_049156:          BNE OWPU_ABXY                       ;; 049156 : D0 03       ;  |Otherwise, 
CODE_049158:          BRL CODE_0491E9                     ;; 049158 : 82 8E 00    ; / branch to $91E9 
OWPU_ABXY:            STZ.W $1B9E                         ;;   ABXY : 9C 9E 1B    ;
CODE_04915E:          LDA.W $13C1                         ;; 04915E : AD C1 13    ; \ 
CODE_049161:          CMP.B #$5F                          ;; 049161 : C9 5F       ;  |If not standing on a star tile, 
CODE_049163:          BNE OWPU_NotOnStar                  ;; 049163 : D0 18       ; / branch to OWPU_NotOnStar 
CODE_049165:          JSR.W CODE_048509                   ;; 049165 : 20 09 85    ;
Return049168:         BNE OWPU_IsOnPipeRTS                ;; ?QPWZ? : D0 2E       ;
CODE_04916A:          STZ.W $1DF7                         ;; 04916A : 9C F7 1D    ; Set "Fly away" speed to 0 
CODE_04916D:          STZ.W $1DF8                         ;; 04916D : 9C F8 1D    ; Set "Stay on ground" timer to 0 (31 = Fly away) 
CODE_049170:          LDA.B #$0D                          ;; 049170 : A9 0D       ; \ Star Road sound effect 
CODE_049172:          STA.W $1DF9                         ;; 049172 : 8D F9 1D    ; / 
CODE_049175:          LDA.B #$0B                          ;; 049175 : A9 0B       ; \ Activate star warp 
CODE_049177:          STA.W $13D9                         ;; 049177 : 8D D9 13    ; / 
CODE_04917A:          JMP.W CODE_049E52                   ;; 04917A : 4C 52 9E    ;
                                                          ;;                      ;
OWPU_NotOnStar:       LDA.W $13C1                         ;; NotOnStar : AD C1 13    ; \ 
CODE_049180:          CMP.B #$82                          ;; 049180 : C9 82       ;  |If standing on Pipe#1 (unused), 
CODE_049182:          BEQ OWPU_IsOnPipe                   ;; 049182 : F0 04       ; / branch to OWPU_IsOnPipe 
CODE_049184:          CMP.B #$5B                          ;; 049184 : C9 5B       ; \ If not standing on Pipe#2, 
CODE_049186:          BNE OWPU_NotOnPipe                  ;; 049186 : D0 11       ; / branch to OWPU_NotOnPipe 
OWPU_IsOnPipe:        JSR.W CODE_048509                   ;; IsOnPipe : 20 09 85    ;
Return04918B:         BNE OWPU_IsOnPipeRTS                ;; ?QPWZ? : D0 0B       ;
CODE_04918D:          INC.W $1B9C                         ;; 04918D : EE 9C 1B    ;
CODE_049190:          STZ.W $0DD5                         ;; 049190 : 9C D5 0D    ; Set auto-walk to 0 
CODE_049193:          LDA.B #$0B                          ;; 049193 : A9 0B       ; \ Fade to overworld 
CODE_049195:          STA.W RAM_GameMode                  ;; 049195 : 8D 00 01    ; / 
OWPU_IsOnPipeRTS:     RTS                                 ;; IsOnPipeRTS : 60          ; Return 
                                                          ;;                      ;
OWPU_NotOnPipe:       CMP.B #$81                          ;; NotOnPipe : C9 81       ; \ 
CODE_04919B:          BEQ CODE_0491E9                     ;; 04919B : F0 4C       ;  |If standing on a tile >= (?) Destroyed Castle, 
CODE_04919D:          BCS CODE_0491E9                     ;; 04919D : B0 4A       ; / branch to $91E9 
OWPU_EnterLevel:      LDA.W $0DD6                         ;; EnterLevel : AD D6 0D    ; \ 
CODE_0491A2:          LSR                                 ;; 0491A2 : 4A          ;  |If current player is Luigi, 
CODE_0491A3:          AND.B #$02                          ;; 0491A3 : 29 02       ;  |change Luigi's animation in the following lines 
CODE_0491A5:          TAX                                 ;; 0491A5 : AA          ; / 
CODE_0491A6:          LDY.B #$10                          ;; 0491A6 : A0 10       ; \ 
CODE_0491A8:          LDA.W $1F13,X                       ;; 0491A8 : BD 13 1F    ;  | 
CODE_0491AB:          AND.B #$08                          ;; 0491AB : 29 08       ;  |If Mario isn't swimming, use "raise hand" animation 
CODE_0491AD:          BEQ CODE_0491B1                     ;; 0491AD : F0 02       ;  |Otherwise, use "raise hand, swimming" animation 
CODE_0491AF:          LDY.B #$12                          ;; 0491AF : A0 12       ;  | 
CODE_0491B1:          TYA                                 ;; 0491B1 : 98          ;  | 
CODE_0491B2:          STA.W $1F13,X                       ;; 0491B2 : 9D 13 1F    ; / 
CODE_0491B5:          LDX.W $0DB3                         ;; 0491B5 : AE B3 0D    ; Get current character 
CODE_0491B8:          LDA.W RAM_PlayerCoins,X             ;; 0491B8 : BD B6 0D    ; \ Get character's coins 
CODE_0491BB:          STA.W RAM_StatusCoins               ;; 0491BB : 8D BF 0D    ; / 
CODE_0491BE:          LDA.W RAM_PlayerLives,X             ;; 0491BE : BD B4 0D    ; \ Get character's lives 
CODE_0491C1:          STA.W RAM_StatusLives               ;; 0491C1 : 8D BE 0D    ; / 
CODE_0491C4:          LDA.W RAM_PlayerPowerUp,X           ;; 0491C4 : BD B8 0D    ; \ Get character's powerup 
CODE_0491C7:          STA RAM_MarioPowerUp                ;; 0491C7 : 85 19       ; / 
CODE_0491C9:          LDA.W RAM_PlyrYoshiColor,X          ;; 0491C9 : BD BA 0D    ; \ 
CODE_0491CC:          STA.W RAM_OWHasYoshi                ;; 0491CC : 8D C1 0D    ;  |Get character's Yoshi color 
CODE_0491CF:          STA.W RAM_YoshiColor                ;; 0491CF : 8D C7 13    ;  | 
CODE_0491D2:          STA.W RAM_OnYoshi                   ;; 0491D2 : 8D 7A 18    ; / 
CODE_0491D5:          LDA.W $0DBC,X                       ;; 0491D5 : BD BC 0D    ; \ Get character's reserved item 
CODE_0491D8:          STA.W $0DC2                         ;; 0491D8 : 8D C2 0D    ; / 
CODE_0491DB:          LDA.B #$02                          ;; 0491DB : A9 02       ; \ Related to fade speed 
CODE_0491DD:          STA.W $0DB1                         ;; 0491DD : 8D B1 0D    ; / 
CODE_0491E0:          LDA.B #$80                          ;; 0491E0 : A9 80       ; \ Music fade out 
CODE_0491E2:          STA.W $1DFB                         ;; 0491E2 : 8D FB 1D    ; / 
CODE_0491E5:          INC.W RAM_GameMode                  ;; 0491E5 : EE 00 01    ; Fade to level 
Return0491E8:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0491E9:          REP #$20                            ;; 0491E9 : C2 20       ; 16 bit A ; Accum (16 bit) 
CODE_0491EB:          LDX.W $0DD6                         ;; 0491EB : AE D6 0D    ; Get current character * 4 
CODE_0491EE:          LDA.W $1F17,X                       ;; 0491EE : BD 17 1F    ; Get character's X coordinate 
CODE_0491F1:          LSR                                 ;; 0491F1 : 4A          ; \ 
CODE_0491F2:          LSR                                 ;; 0491F2 : 4A          ;  |Divide X coordinate by 16 
CODE_0491F3:          LSR                                 ;; 0491F3 : 4A          ;  | 
CODE_0491F4:          LSR                                 ;; 0491F4 : 4A          ; / 
CODE_0491F5:          STA $00                             ;; 0491F5 : 85 00       ; \ Store in $00 and $1F1F,x 
CODE_0491F7:          STA.W $1F1F,X                       ;; 0491F7 : 9D 1F 1F    ; / 
CODE_0491FA:          LDA.W $1F19,X                       ;; 0491FA : BD 19 1F    ; Get character's Y coordinate 
CODE_0491FD:          LSR                                 ;; 0491FD : 4A          ; \ 
CODE_0491FE:          LSR                                 ;; 0491FE : 4A          ;  |Divide Y coordinate by 16 
CODE_0491FF:          LSR                                 ;; 0491FF : 4A          ;  | 
CODE_049200:          LSR                                 ;; 049200 : 4A          ; / 
CODE_049201:          STA $02                             ;; 049201 : 85 02       ; \ Store in $02 and $1F21,x 
CODE_049203:          STA.W $1F21,X                       ;; 049203 : 9D 21 1F    ; / 
CODE_049206:          TXA                                 ;; 049206 : 8A          ; \ 
CODE_049207:          LSR                                 ;; 049207 : 4A          ;  |Divide (current character * 4) by 4 
CODE_049208:          LSR                                 ;; 049208 : 4A          ;  | 
CODE_049209:          TAX                                 ;; 049209 : AA          ; / 
CODE_04920A:          JSR.W OW_TilePos_Calc               ;; 04920A : 20 85 98    ; Calculate current tile pos 
CODE_04920D:          SEP #$20                            ;; 04920D : E2 20       ; 8 bit A ; Accum (8 bit) 
CODE_04920F:          LDX.W $0DD5                         ;; 04920F : AE D5 0D    ; \ If auto-walk=0, 
CODE_049212:          BEQ OWPU_NotAutoWalk                ;; 049212 : F0 46       ; / branch to OWPU_NotAutoWalk 
CODE_049214:          DEX                                 ;; 049214 : CA          ;
CODE_049215:          LDA.W DATA_049060,X                 ;; 049215 : BD 60 90    ;
CODE_049218:          STA $08                             ;; 049218 : 85 08       ;
CODE_04921A:          STZ $09                             ;; 04921A : 64 09       ;
CODE_04921C:          REP #$30                            ;; 04921C : C2 30       ; 16 bit A,X,Y ; Index (16 bit) Accum (16 bit) 
CODE_04921E:          LDX $04                             ;; 04921E : A6 04       ; X = tile pos 
CODE_049220:          LDA.L $7ED000,X                     ;; 049220 : BF 00 D0 7E ; \ Get level number of current tile pos 
CODE_049224:          AND.W #$00FF                        ;; 049224 : 29 FF 00    ; / 
CODE_049227:          LDY.W #$000A                        ;; 049227 : A0 0A 00    ;
CODE_04922A:          CMP.W DATA_04906C,Y                 ;; 04922A : D9 6C 90    ;
CODE_04922D:          BNE CODE_04923B                     ;; 04922D : D0 0C       ;
CODE_04922F:          LDA.W #$0005                        ;; 04922F : A9 05 00    ;
CODE_049232:          STA.W $13D9                         ;; 049232 : 8D D9 13    ;
CODE_049235:          JSR.W CODE_049037                   ;; 049235 : 20 37 90    ;
CODE_049238:          BRL CODE_049411                     ;; 049238 : 82 D6 01    ;
CODE_04923B:          DEY                                 ;; 04923B : 88          ;
CODE_04923C:          DEY                                 ;; 04923C : 88          ;
CODE_04923D:          BPL CODE_04922A                     ;; 04923D : 10 EB       ;
CODE_04923F:          LDA.L $7ED800,X                     ;; 04923F : BF 00 D8 7E ;
CODE_049243:          AND.W #$00FF                        ;; 049243 : 29 FF 00    ;
CODE_049246:          LDX $08                             ;; 049246 : A6 08       ;
CODE_049248:          BEQ CODE_04924E                     ;; 049248 : F0 04       ;
CODE_04924A:          LSR                                 ;; 04924A : 4A          ;
CODE_04924B:          DEX                                 ;; 04924B : CA          ;
CODE_04924C:          BPL CODE_04924A                     ;; 04924C : 10 FC       ;
CODE_04924E:          AND.W #$0003                        ;; 04924E : 29 03 00    ;
CODE_049251:          ASL                                 ;; 049251 : 0A          ;
CODE_049252:          TAX                                 ;; 049252 : AA          ;
CODE_049253:          LDA.W DATA_049064,X                 ;; 049253 : BD 64 90    ;
CODE_049256:          TAY                                 ;; 049256 : A8          ;
CODE_049257:          JMP.W CODE_0492BC                   ;; 049257 : 4C BC 92    ;
                                                          ;;                      ;
OWPU_NotAutoWalk:     SEP #$30                            ;; NotAutoWalk : E2 30       ; 8 bit A,X,Y ; Index (8 bit) Accum (8 bit) 
CODE_04925C:          STZ.W $0DD5                         ;; 04925C : 9C D5 0D    ; Set auto-walk to 0 
CODE_04925F:          LDA $16                             ;; 04925F : A5 16       ; \ 
CODE_049261:          AND.B #$0F                          ;; 049261 : 29 0F       ;  |If no dir button is pressed (one frame), 
CODE_049263:          BEQ CODE_04926E                     ;; 049263 : F0 09       ; / branch to $926E 
CODE_049265:          LDX.W $13C1                         ;; 049265 : AE C1 13    ; \ 
CODE_049268:          CPX.B #$82                          ;; 049268 : E0 82       ;  |If standing on Pipe#2, 
CODE_04926A:          BEQ CODE_0492AD                     ;; 04926A : F0 41       ;  |branch to $92AD 
CODE_04926C:          BRA CODE_04928C                     ;; 04926C : 80 1E       ; / Otherwise, branch to $928C 
                                                          ;;                      ;
CODE_04926E:          DEC.W $144E                         ;; 04926E : CE 4E 14    ; \ Decrease "Face walking dir" timer 
CODE_049271:          BPL CODE_049287                     ;; 049271 : 10 14       ; / If >= 0, branch to $9287 
CODE_049273:          STZ.W $144E                         ;; 049273 : 9C 4E 14    ; Set "Face walking dir" timer to 0 
CODE_049276:          LDA.W $0DD6                         ;; 049276 : AD D6 0D    ; \ 
CODE_049279:          LSR                                 ;; 049279 : 4A          ;  |Set X to current character * 2 
CODE_04927A:          AND.B #$02                          ;; 04927A : 29 02       ;  | 
CODE_04927C:          TAX                                 ;; 04927C : AA          ; / 
CODE_04927D:          LDA.W $1F13,X                       ;; 04927D : BD 13 1F    ; \ 
CODE_049280:          AND.B #$08                          ;; 049280 : 29 08       ;  |Set current character's animation to "facing down" 
CODE_049282:          ORA.B #$02                          ;; 049282 : 09 02       ;  |or "facing down in water", depending on if character 
CODE_049284:          STA.W $1F13,X                       ;; 049284 : 9D 13 1F    ; / is in water or not. 
CODE_049287:          REP #$30                            ;; 049287 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_049289:          JMP.W CODE_049831                   ;; 049289 : 4C 31 98    ;
                                                          ;;                      ;
CODE_04928C:          REP #$30                            ;; 04928C : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04928E:          AND.W #$00FF                        ;; 04928E : 29 FF 00    ;
CODE_049291:          NOP                                 ;; 049291 : EA          ;
CODE_049292:          NOP                                 ;; 049292 : EA          ;
CODE_049293:          NOP                                 ;; 049293 : EA          ;
CODE_049294:          PHA                                 ;; 049294 : 48          ;
CODE_049295:          STZ $06                             ;; 049295 : 64 06       ;
CODE_049297:          LDX $04                             ;; 049297 : A6 04       ;
CODE_049299:          LDA.L $7ED000,X                     ;; 049299 : BF 00 D0 7E ;
CODE_04929D:          AND.W #$00FF                        ;; 04929D : 29 FF 00    ;
CODE_0492A0:          TAX                                 ;; 0492A0 : AA          ;
CODE_0492A1:          PLA                                 ;; 0492A1 : 68          ;
CODE_0492A2:          AND.W $1EA2,X                       ;; 0492A2 : 3D A2 1E    ;
CODE_0492A5:          AND.W #$000F                        ;; 0492A5 : 29 0F 00    ;
CODE_0492A8:          BNE CODE_0492AD                     ;; 0492A8 : D0 03       ;
CODE_0492AA:          JMP.W CODE_049411                   ;; 0492AA : 4C 11 94    ;
                                                          ;;                      ;
CODE_0492AD:          REP #$30                            ;; 0492AD : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_0492AF:          AND.W #$00FF                        ;; 0492AF : 29 FF 00    ;
CODE_0492B2:          LDY.W #$0006                        ;; 0492B2 : A0 06 00    ;
CODE_0492B5:          LSR                                 ;; 0492B5 : 4A          ;
CODE_0492B6:          BCS CODE_0492BC                     ;; 0492B6 : B0 04       ;
CODE_0492B8:          DEY                                 ;; 0492B8 : 88          ;
CODE_0492B9:          DEY                                 ;; 0492B9 : 88          ;
CODE_0492BA:          BPL CODE_0492B5                     ;; 0492BA : 10 F9       ;
CODE_0492BC:          TYA                                 ;; 0492BC : 98          ;
CODE_0492BD:          STA.W $0DD3                         ;; 0492BD : 8D D3 0D    ;
CODE_0492C0:          LDX.W #$0000                        ;; 0492C0 : A2 00 00    ;
CODE_0492C3:          CPY.W #$0004                        ;; 0492C3 : C0 04 00    ;
CODE_0492C6:          BCS CODE_0492CB                     ;; 0492C6 : B0 03       ;
CODE_0492C8:          LDX.W #$0002                        ;; 0492C8 : A2 02 00    ;
CODE_0492CB:          LDA $04                             ;; 0492CB : A5 04       ;
CODE_0492CD:          STA $08                             ;; 0492CD : 85 08       ;
CODE_0492CF:          LDA $00,X                           ;; 0492CF : B5 00       ;
CODE_0492D1:          CLC                                 ;; 0492D1 : 18          ;
CODE_0492D2:          ADC.W DATA_049058,Y                 ;; 0492D2 : 79 58 90    ;
CODE_0492D5:          STA $00,X                           ;; 0492D5 : 95 00       ;
CODE_0492D7:          LDA.W $0DD6                         ;; 0492D7 : AD D6 0D    ;
CODE_0492DA:          LSR                                 ;; 0492DA : 4A          ;
CODE_0492DB:          LSR                                 ;; 0492DB : 4A          ;
CODE_0492DC:          TAX                                 ;; 0492DC : AA          ;
CODE_0492DD:          JSR.W OW_TilePos_Calc               ;; 0492DD : 20 85 98    ;
CODE_0492E0:          LDX $04                             ;; 0492E0 : A6 04       ;
CODE_0492E2:          BMI CODE_049301                     ;; 0492E2 : 30 1D       ;
CODE_0492E4:          CMP.W #$0800                        ;; 0492E4 : C9 00 08    ;
CODE_0492E7:          BCS CODE_049301                     ;; 0492E7 : B0 18       ;
CODE_0492E9:          LDA.L $7EC800,X                     ;; 0492E9 : BF 00 C8 7E ;
CODE_0492ED:          AND.W #$00FF                        ;; 0492ED : 29 FF 00    ;
CODE_0492F0:          BEQ CODE_049301                     ;; 0492F0 : F0 0F       ;
CODE_0492F2:          CMP.W #$0056                        ;; 0492F2 : C9 56 00    ;
CODE_0492F5:          BCC CODE_0492FE                     ;; 0492F5 : 90 07       ;
CODE_0492F7:          CMP.W #$0087                        ;; 0492F7 : C9 87 00    ;
CODE_0492FA:          BCC CODE_0492FE                     ;; 0492FA : 90 02       ;
CODE_0492FC:          BRA CODE_049301                     ;; 0492FC : 80 03       ;
                                                          ;;                      ;
CODE_0492FE:          BRL CODE_049384                     ;; 0492FE : 82 83 00    ;
CODE_049301:          STZ.W $1B78                         ;; 049301 : 9C 78 1B    ;
CODE_049304:          STZ.W $1B7A                         ;; 049304 : 9C 7A 1B    ;
CODE_049307:          LDX $08                             ;; 049307 : A6 08       ;
CODE_049309:          LDA.L $7ED000,X                     ;; 049309 : BF 00 D0 7E ;
CODE_04930D:          AND.W #$00FF                        ;; 04930D : 29 FF 00    ;
CODE_049310:          STA $00                             ;; 049310 : 85 00       ;
CODE_049312:          LDX.W #$0009                        ;; 049312 : A2 09 00    ;
CODE_049315:          LDA.W HardCodedOWPaths,X            ;; 049315 : BD 78 90    ;
CODE_049318:          AND.W #$00FF                        ;; 049318 : 29 FF 00    ;
CODE_04931B:          CMP.W #$00FF                        ;; 04931B : C9 FF 00    ;
CODE_04931E:          BNE CODE_049349                     ;; 04931E : D0 29       ;
CODE_049320:          PHX                                 ;; 049320 : DA          ;
CODE_049321:          LDX.W $0DD6                         ;; 049321 : AE D6 0D    ;
CODE_049324:          LDA.W $1F19,X                       ;; 049324 : BD 19 1F    ;
CODE_049327:          CMP.W DATA_049082                   ;; 049327 : CD 82 90    ;
CODE_04932A:          BNE CODE_049346                     ;; 04932A : D0 1A       ;
CODE_04932C:          LDA.W $1F17,X                       ;; 04932C : BD 17 1F    ;
CODE_04932F:          CMP.W DATA_049084                   ;; 04932F : CD 84 90    ;
CODE_049332:          BNE CODE_049346                     ;; 049332 : D0 12       ;
CODE_049334:          LDA.W $0DB3                         ;; 049334 : AD B3 0D    ;
CODE_049337:          AND.W #$00FF                        ;; 049337 : 29 FF 00    ;
CODE_04933A:          TAX                                 ;; 04933A : AA          ;
CODE_04933B:          LDA.W $1F11,X                       ;; 04933B : BD 11 1F    ;
CODE_04933E:          AND.W #$00FF                        ;; 04933E : 29 FF 00    ;
CODE_049341:          BNE CODE_049346                     ;; 049341 : D0 03       ;
CODE_049343:          PLX                                 ;; 049343 : FA          ;
CODE_049344:          BRA CODE_04934D                     ;; 049344 : 80 07       ;
                                                          ;;                      ;
CODE_049346:          PLX                                 ;; 049346 : FA          ;
CODE_049347:          BRA CODE_049374                     ;; 049347 : 80 2B       ;
                                                          ;;                      ;
CODE_049349:          CMP $00                             ;; 049349 : C5 00       ;
CODE_04934B:          BNE CODE_049374                     ;; 04934B : D0 27       ;
CODE_04934D:          STX $00                             ;; 04934D : 86 00       ;
CODE_04934F:          LDA.W DATA_04910E,X                 ;; 04934F : BD 0E 91    ;
CODE_049352:          AND.W #$00FF                        ;; 049352 : 29 FF 00    ;
CODE_049355:          TAX                                 ;; 049355 : AA          ;
CODE_049356:          DEC A                               ;; 049356 : 3A          ;
CODE_049357:          STA.W $1B7A                         ;; 049357 : 8D 7A 1B    ;
CODE_04935A:          STY $02                             ;; 04935A : 84 02       ;
CODE_04935C:          LDA.W DATA_0490CA,X                 ;; 04935C : BD CA 90    ;
CODE_04935F:          AND.W #$00FF                        ;; 04935F : 29 FF 00    ;
CODE_049362:          CMP $02                             ;; 049362 : C5 02       ;
CODE_049364:          BNE CODE_04937A                     ;; 049364 : D0 14       ;
CODE_049366:          LDA.W #$0001                        ;; 049366 : A9 01 00    ;
CODE_049369:          STA.W $1B78                         ;; 049369 : 8D 78 1B    ;
CODE_04936C:          LDA.W DATA_049086,X                 ;; 04936C : BD 86 90    ;
CODE_04936F:          AND.W #$00FF                        ;; 04936F : 29 FF 00    ;
CODE_049372:          BRA CODE_049384                     ;; 049372 : 80 10       ;
                                                          ;;                      ;
CODE_049374:          DEX                                 ;; 049374 : CA          ;
CODE_049375:          BMI CODE_04937A                     ;; 049375 : 30 03       ;
CODE_049377:          BRL CODE_049315                     ;; 049377 : 82 9B FF    ;
CODE_04937A:          SEP #$20                            ;; 04937A : E2 20       ; Accum (8 bit) 
CODE_04937C:          STZ.W $0DD5                         ;; 04937C : 9C D5 0D    ;
CODE_04937F:          REP #$20                            ;; 04937F : C2 20       ; Accum (16 bit) 
CODE_049381:          JMP.W CODE_049411                   ;; 049381 : 4C 11 94    ;
                                                          ;;                      ;
CODE_049384:          STA.W $13C1                         ;; 049384 : 8D C1 13    ;
CODE_049387:          STA $00                             ;; 049387 : 85 00       ;
CODE_049389:          STZ $02                             ;; 049389 : 64 02       ;
CODE_04938B:          LDX.W #$0017                        ;; 04938B : A2 17 00    ;
CODE_04938E:          LDA.W DATA_04A03C,X                 ;; 04938E : BD 3C A0    ;
CODE_049391:          AND.W #$00FF                        ;; 049391 : 29 FF 00    ;
CODE_049394:          CMP $00                             ;; 049394 : C5 00       ;
CODE_049396:          BNE CODE_0493B5                     ;; 049396 : D0 1D       ;
CODE_049398:          LDA.W DATA_04A0E4,X                 ;; 049398 : BD E4 A0    ;
CODE_04939B:          CLC                                 ;; 04939B : 18          ;
CODE_04939C:          ADC.W $0DD6                         ;; 04939C : 6D D6 0D    ;
CODE_04939F:          PHA                                 ;; 04939F : 48          ;
CODE_0493A0:          TXA                                 ;; 0493A0 : 8A          ;
CODE_0493A1:          ASL                                 ;; 0493A1 : 0A          ;
CODE_0493A2:          ASL                                 ;; 0493A2 : 0A          ;
CODE_0493A3:          TAX                                 ;; 0493A3 : AA          ;
CODE_0493A4:          LDA.W DATA_04A084,X                 ;; 0493A4 : BD 84 A0    ;
CODE_0493A7:          STA $00                             ;; 0493A7 : 85 00       ;
CODE_0493A9:          LDA.W DATA_04A086,X                 ;; 0493A9 : BD 86 A0    ;
CODE_0493AC:          STA $02                             ;; 0493AC : 85 02       ;
CODE_0493AE:          PLA                                 ;; 0493AE : 68          ;
CODE_0493AF:          AND.W #$00FF                        ;; 0493AF : 29 FF 00    ;
CODE_0493B2:          TAX                                 ;; 0493B2 : AA          ;
CODE_0493B3:          BRA CODE_0493DA                     ;; 0493B3 : 80 25       ;
                                                          ;;                      ;
CODE_0493B5:          DEX                                 ;; 0493B5 : CA          ;
CODE_0493B6:          BPL CODE_04938E                     ;; 0493B6 : 10 D6       ;
CODE_0493B8:          LDX.W #$0008                        ;; 0493B8 : A2 08 00    ;
CODE_0493BB:          TYA                                 ;; 0493BB : 98          ;
CODE_0493BC:          AND.W #$0002                        ;; 0493BC : 29 02 00    ;
CODE_0493BF:          BNE CODE_0493C7                     ;; 0493BF : D0 06       ;
CODE_0493C1:          TXA                                 ;; 0493C1 : 8A          ;
CODE_0493C2:          EOR.W #$FFFF                        ;; 0493C2 : 49 FF FF    ;
CODE_0493C5:          INC A                               ;; 0493C5 : 1A          ;
CODE_0493C6:          TAX                                 ;; 0493C6 : AA          ;
CODE_0493C7:          STX $00                             ;; 0493C7 : 86 00       ;
CODE_0493C9:          LDX.W #$0000                        ;; 0493C9 : A2 00 00    ;
CODE_0493CC:          CPY.W #$0004                        ;; 0493CC : C0 04 00    ;
CODE_0493CF:          BCS CODE_0493D4                     ;; 0493CF : B0 03       ;
CODE_0493D1:          LDX.W #$0002                        ;; 0493D1 : A2 02 00    ;
CODE_0493D4:          TXA                                 ;; 0493D4 : 8A          ;
CODE_0493D5:          CLC                                 ;; 0493D5 : 18          ;
CODE_0493D6:          ADC.W $0DD6                         ;; 0493D6 : 6D D6 0D    ;
CODE_0493D9:          TAX                                 ;; 0493D9 : AA          ;
CODE_0493DA:          LDA $00                             ;; 0493DA : A5 00       ;
CODE_0493DC:          CLC                                 ;; 0493DC : 18          ;
CODE_0493DD:          ADC.W $1F17,X                       ;; 0493DD : 7D 17 1F    ;
CODE_0493E0:          STA.W $0DC7,X                       ;; 0493E0 : 9D C7 0D    ;
CODE_0493E3:          TXA                                 ;; 0493E3 : 8A          ;
CODE_0493E4:          EOR.W #$0002                        ;; 0493E4 : 49 02 00    ;
CODE_0493E7:          TAX                                 ;; 0493E7 : AA          ;
CODE_0493E8:          LDA $02                             ;; 0493E8 : A5 02       ;
CODE_0493EA:          CLC                                 ;; 0493EA : 18          ;
CODE_0493EB:          ADC.W $1F17,X                       ;; 0493EB : 7D 17 1F    ;
CODE_0493EE:          STA.W $0DC7,X                       ;; 0493EE : 9D C7 0D    ;
CODE_0493F1:          TXA                                 ;; 0493F1 : 8A          ;
CODE_0493F2:          LSR                                 ;; 0493F2 : 4A          ;
CODE_0493F3:          AND.W #$0002                        ;; 0493F3 : 29 02 00    ;
CODE_0493F6:          TAX                                 ;; 0493F6 : AA          ;
CODE_0493F7:          TYA                                 ;; 0493F7 : 98          ;
CODE_0493F8:          STA $00                             ;; 0493F8 : 85 00       ;
CODE_0493FA:          LDA.W $1F13,X                       ;; 0493FA : BD 13 1F    ;
CODE_0493FD:          AND.W #$0008                        ;; 0493FD : 29 08 00    ;
CODE_049400:          ORA $00                             ;; 049400 : 05 00       ;
CODE_049402:          STA.W $1F13,X                       ;; 049402 : 9D 13 1F    ;
CODE_049405:          LDA.W #$000F                        ;; 049405 : A9 0F 00    ;
CODE_049408:          STA.W $144E                         ;; 049408 : 8D 4E 14    ;
CODE_04940B:          INC.W $13D9                         ;; 04940B : EE D9 13    ;
CODE_04940E:          STZ.W $1444                         ;; 04940E : 9C 44 14    ;
CODE_049411:          JMP.W CODE_049831                   ;; 049411 : 4C 31 98    ;
                                                          ;;                      ;
                                                          ;;                      ;
DATA_049414:          .db $0D,$08                         ;; 049414               ;
                                                          ;;                      ;
DATA_049416:          .db $EF,$FF,$D7,$FF                 ;; 049416               ;
                                                          ;;                      ;
DATA_04941A:          .db $11,$01,$31,$01                 ;; 04941A               ;
                                                          ;;                      ;
DATA_04941E:          .db $08,$00,$04,$00,$02,$00,$01,$00 ;; 04941E               ;
DATA_049426:          .db $44,$43,$45,$46,$47,$48,$25,$40 ;; 049426               ;
                      .db $42,$4D                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_049430:          .db $0C                             ;; 049430               ;
                                                          ;;                      ;
DATA_049431:          .db $00,$0E,$00,$10,$06,$12,$00,$18 ;; 049431               ;
                      .db $04,$1A,$02,$20,$06,$42,$06,$4E ;; ?QPWZ?               ;
                      .db $04,$50,$02,$58,$06,$5A,$00,$70 ;; ?QPWZ?               ;
                      .db $06,$90,$00,$A0,$06             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04944E:          .db $01,$01,$00,$01,$01,$00,$00,$00 ;; 04944E               ;
                      .db $01,$00,$00,$01,$00,$01,$00     ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_04945D:          LDA.W $0DD8                         ;; 04945D : AD D8 0D    ; Accum (8 bit) 
CODE_049460:          BEQ CODE_049468                     ;; 049460 : F0 06       ;
CODE_049462:          LDA.B #$08                          ;; 049462 : A9 08       ;
CODE_049464:          STA.W $13D9                         ;; 049464 : 8D D9 13    ;
Return049467:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_049468:          REP #$30                            ;; 049468 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04946A:          LDA.W $0DD6                         ;; 04946A : AD D6 0D    ;
CODE_04946D:          CLC                                 ;; 04946D : 18          ;
CODE_04946E:          ADC.W #$0002                        ;; 04946E : 69 02 00    ;
CODE_049471:          TAY                                 ;; 049471 : A8          ;
CODE_049472:          LDX.W #$0002                        ;; 049472 : A2 02 00    ;
CODE_049475:          LDA.W $0DC7,Y                       ;; 049475 : B9 C7 0D    ;
CODE_049478:          SEC                                 ;; 049478 : 38          ;
CODE_049479:          SBC.W $1F17,Y                       ;; 049479 : F9 17 1F    ;
CODE_04947C:          STA $00,X                           ;; 04947C : 95 00       ;
CODE_04947E:          BPL CODE_049484                     ;; 04947E : 10 04       ;
CODE_049480:          EOR.W #$FFFF                        ;; 049480 : 49 FF FF    ;
CODE_049483:          INC A                               ;; 049483 : 1A          ;
CODE_049484:          STA $04,X                           ;; 049484 : 95 04       ;
CODE_049486:          DEY                                 ;; 049486 : 88          ;
CODE_049487:          DEY                                 ;; 049487 : 88          ;
CODE_049488:          DEX                                 ;; 049488 : CA          ;
CODE_049489:          DEX                                 ;; 049489 : CA          ;
CODE_04948A:          BPL CODE_049475                     ;; 04948A : 10 E9       ;
CODE_04948C:          LDY.W #$FFFF                        ;; 04948C : A0 FF FF    ;
CODE_04948F:          LDA $04                             ;; 04948F : A5 04       ;
CODE_049491:          STA $0A                             ;; 049491 : 85 0A       ;
CODE_049493:          LDA $06                             ;; 049493 : A5 06       ;
CODE_049495:          STA $0C                             ;; 049495 : 85 0C       ;
CODE_049497:          CMP $04                             ;; 049497 : C5 04       ;
CODE_049499:          BCC CODE_0494A4                     ;; 049499 : 90 09       ;
CODE_04949B:          STA $0A                             ;; 04949B : 85 0A       ;
CODE_04949D:          LDA $04                             ;; 04949D : A5 04       ;
CODE_04949F:          STA $0C                             ;; 04949F : 85 0C       ;
CODE_0494A1:          LDY.W #$0001                        ;; 0494A1 : A0 01 00    ;
CODE_0494A4:          STY $08                             ;; 0494A4 : 84 08       ;
CODE_0494A6:          SEP #$20                            ;; 0494A6 : E2 20       ; Accum (8 bit) 
CODE_0494A8:          LDX.W $1B80                         ;; 0494A8 : AE 80 1B    ;
CODE_0494AB:          LDA.W DATA_049414,X                 ;; 0494AB : BD 14 94    ;
CODE_0494AE:          ASL                                 ;; 0494AE : 0A          ;
CODE_0494AF:          ASL                                 ;; 0494AF : 0A          ;
CODE_0494B0:          ASL                                 ;; 0494B0 : 0A          ;
CODE_0494B1:          ASL                                 ;; 0494B1 : 0A          ;
CODE_0494B2:          STA.W $4202                         ;; 0494B2 : 8D 02 42    ; Multiplicand A
CODE_0494B5:          LDA $0C                             ;; 0494B5 : A5 0C       ;
CODE_0494B7:          BEQ CODE_0494DA                     ;; 0494B7 : F0 21       ;
CODE_0494B9:          STA.W $4203                         ;; 0494B9 : 8D 03 42    ; Multplier B
CODE_0494BC:          NOP                                 ;; 0494BC : EA          ;
CODE_0494BD:          NOP                                 ;; 0494BD : EA          ;
CODE_0494BE:          NOP                                 ;; 0494BE : EA          ;
CODE_0494BF:          NOP                                 ;; 0494BF : EA          ;
CODE_0494C0:          REP #$20                            ;; 0494C0 : C2 20       ; Accum (16 bit) 
CODE_0494C2:          LDA.W $4216                         ;; 0494C2 : AD 16 42    ; Product/Remainder Result (Low Byte)
CODE_0494C5:          STA.W $4204                         ;; 0494C5 : 8D 04 42    ; Dividend (Low Byte)
CODE_0494C8:          SEP #$20                            ;; 0494C8 : E2 20       ; Accum (8 bit) 
CODE_0494CA:          LDA $0A                             ;; 0494CA : A5 0A       ;
CODE_0494CC:          STA.W $4206                         ;; 0494CC : 8D 06 42    ; Divisor B
CODE_0494CF:          NOP                                 ;; 0494CF : EA          ;
CODE_0494D0:          NOP                                 ;; 0494D0 : EA          ;
CODE_0494D1:          NOP                                 ;; 0494D1 : EA          ;
CODE_0494D2:          NOP                                 ;; 0494D2 : EA          ;
CODE_0494D3:          NOP                                 ;; 0494D3 : EA          ;
CODE_0494D4:          NOP                                 ;; 0494D4 : EA          ;
CODE_0494D5:          REP #$20                            ;; 0494D5 : C2 20       ; Accum (16 bit) 
CODE_0494D7:          LDA.W $4214                         ;; 0494D7 : AD 14 42    ; Quotient of Divide Result (Low Byte)
CODE_0494DA:          REP #$20                            ;; 0494DA : C2 20       ; Accum (16 bit) 
CODE_0494DC:          STA $0E                             ;; 0494DC : 85 0E       ;
CODE_0494DE:          LDX.W $1B80                         ;; 0494DE : AE 80 1B    ;
CODE_0494E1:          LDA.W DATA_049414,X                 ;; 0494E1 : BD 14 94    ;
CODE_0494E4:          AND.W #$00FF                        ;; 0494E4 : 29 FF 00    ;
CODE_0494E7:          ASL                                 ;; 0494E7 : 0A          ;
CODE_0494E8:          ASL                                 ;; 0494E8 : 0A          ;
CODE_0494E9:          ASL                                 ;; 0494E9 : 0A          ;
CODE_0494EA:          ASL                                 ;; 0494EA : 0A          ;
CODE_0494EB:          STA $0A                             ;; 0494EB : 85 0A       ;
CODE_0494ED:          LDX.W #$0002                        ;; 0494ED : A2 02 00    ;
CODE_0494F0:          LDA $08                             ;; 0494F0 : A5 08       ;
CODE_0494F2:          BMI CODE_0494F8                     ;; 0494F2 : 30 04       ;
CODE_0494F4:          LDA $0A                             ;; 0494F4 : A5 0A       ;
CODE_0494F6:          BRA CODE_0494FA                     ;; 0494F6 : 80 02       ;
                                                          ;;                      ;
CODE_0494F8:          LDA $0E                             ;; 0494F8 : A5 0E       ;
CODE_0494FA:          BIT $00,X                           ;; 0494FA : 34 00       ;
CODE_0494FC:          BPL CODE_049502                     ;; 0494FC : 10 04       ;
CODE_0494FE:          EOR.W #$FFFF                        ;; 0494FE : 49 FF FF    ;
CODE_049501:          INC A                               ;; 049501 : 1A          ;
CODE_049502:          STA.W $0DCF,X                       ;; 049502 : 9D CF 0D    ;
CODE_049505:          LDA $08                             ;; 049505 : A5 08       ;
CODE_049507:          EOR.W #$FFFF                        ;; 049507 : 49 FF FF    ;
CODE_04950A:          INC A                               ;; 04950A : 1A          ;
CODE_04950B:          STA $08                             ;; 04950B : 85 08       ;
CODE_04950D:          DEX                                 ;; 04950D : CA          ;
CODE_04950E:          DEX                                 ;; 04950E : CA          ;
CODE_04950F:          BPL CODE_0494F0                     ;; 04950F : 10 DF       ;
CODE_049511:          LDX.W #$0000                        ;; 049511 : A2 00 00    ;
CODE_049514:          LDA $08                             ;; 049514 : A5 08       ;
CODE_049516:          BMI CODE_04951B                     ;; 049516 : 30 03       ;
CODE_049518:          LDX.W #$0002                        ;; 049518 : A2 02 00    ;
CODE_04951B:          LDA $00,X                           ;; 04951B : B5 00       ;
CODE_04951D:          BEQ CODE_049522                     ;; 04951D : F0 03       ;
CODE_04951F:          JMP.W CODE_049801                   ;; 04951F : 4C 01 98    ;
                                                          ;;                      ;
CODE_049522:          LDA.W $1444                         ;; 049522 : AD 44 14    ;
CODE_049525:          BEQ CODE_04955C                     ;; 049525 : F0 35       ;
CODE_049527:          STZ.W $1B78                         ;; 049527 : 9C 78 1B    ;
CODE_04952A:          LDX.W $0DD6                         ;; 04952A : AE D6 0D    ;
CODE_04952D:          LDA.W $1F1F,X                       ;; 04952D : BD 1F 1F    ;
CODE_049530:          STA $00                             ;; 049530 : 85 00       ;
CODE_049532:          LDA.W $1F21,X                       ;; 049532 : BD 21 1F    ;
CODE_049535:          STA $02                             ;; 049535 : 85 02       ;
CODE_049537:          TXA                                 ;; 049537 : 8A          ;
CODE_049538:          LSR                                 ;; 049538 : 4A          ;
CODE_049539:          LSR                                 ;; 049539 : 4A          ;
CODE_04953A:          TAX                                 ;; 04953A : AA          ;
CODE_04953B:          JSR.W OW_TilePos_Calc               ;; 04953B : 20 85 98    ;
CODE_04953E:          STZ $00                             ;; 04953E : 64 00       ;
CODE_049540:          LDX $04                             ;; 049540 : A6 04       ;
CODE_049542:          LDA.L $7ED000,X                     ;; 049542 : BF 00 D0 7E ;
CODE_049546:          AND.W #$00FF                        ;; 049546 : 29 FF 00    ;
CODE_049549:          ASL                                 ;; 049549 : 0A          ;
CODE_04954A:          TAX                                 ;; 04954A : AA          ;
CODE_04954B:          LDA.W LevelNames,X                  ;; 04954B : BD FC A0    ;
CODE_04954E:          STA $00                             ;; 04954E : 85 00       ;
CODE_049550:          JSR.W CODE_049D07                   ;; 049550 : 20 07 9D    ;
CODE_049553:          INC.W $13D9                         ;; 049553 : EE D9 13    ;
CODE_049556:          JSR.W CODE_049037                   ;; 049556 : 20 37 90    ;
CODE_049559:          JMP.W CODE_049831                   ;; 049559 : 4C 31 98    ;
                                                          ;;                      ;
CODE_04955C:          LDA.W $13C1                         ;; 04955C : AD C1 13    ;
CODE_04955F:          STA.W $1B7E                         ;; 04955F : 8D 7E 1B    ;
CODE_049562:          LDA.W #$0008                        ;; 049562 : A9 08 00    ;
CODE_049565:          STA $08                             ;; 049565 : 85 08       ;
CODE_049567:          LDY.W $0DD3                         ;; 049567 : AC D3 0D    ;
CODE_04956A:          TYA                                 ;; 04956A : 98          ;
CODE_04956B:          AND.W #$00FF                        ;; 04956B : 29 FF 00    ;
CODE_04956E:          EOR.W #$0002                        ;; 04956E : 49 02 00    ;
CODE_049571:          STA $0A                             ;; 049571 : 85 0A       ;
CODE_049573:          BRA CODE_049582                     ;; 049573 : 80 0D       ;
                                                          ;;                      ;
ADDR_049575:          LDA $08                             ;; 049575 : A5 08       ;
ADDR_049577:          SEC                                 ;; 049577 : 38          ;
ADDR_049578:          SBC.W #$0002                        ;; 049578 : E9 02 00    ;
ADDR_04957B:          STA $08                             ;; 04957B : 85 08       ;
ADDR_04957D:          CMP $0A                             ;; 04957D : C5 0A       ;
ADDR_04957F:          BEQ ADDR_049575                     ;; 04957F : F0 F4       ;
ADDR_049581:          TAY                                 ;; 049581 : A8          ;
CODE_049582:          LDX.W $0DD6                         ;; 049582 : AE D6 0D    ;
CODE_049585:          LDA.W $1F1F,X                       ;; 049585 : BD 1F 1F    ;
CODE_049588:          STA $00                             ;; 049588 : 85 00       ;
CODE_04958A:          LDA.W $1F21,X                       ;; 04958A : BD 21 1F    ;
CODE_04958D:          STA $02                             ;; 04958D : 85 02       ;
CODE_04958F:          LDX.W #$0000                        ;; 04958F : A2 00 00    ;
CODE_049592:          CPY.W #$0004                        ;; 049592 : C0 04 00    ;
CODE_049595:          BCS CODE_04959A                     ;; 049595 : B0 03       ;
CODE_049597:          LDX.W #$0002                        ;; 049597 : A2 02 00    ;
CODE_04959A:          LDA $00,X                           ;; 04959A : B5 00       ;
CODE_04959C:          CLC                                 ;; 04959C : 18          ;
CODE_04959D:          ADC.W DATA_049058,Y                 ;; 04959D : 79 58 90    ;
CODE_0495A0:          STA $00,X                           ;; 0495A0 : 95 00       ;
CODE_0495A2:          LDA.W $0DD6                         ;; 0495A2 : AD D6 0D    ;
CODE_0495A5:          LSR                                 ;; 0495A5 : 4A          ;
CODE_0495A6:          LSR                                 ;; 0495A6 : 4A          ;
CODE_0495A7:          TAX                                 ;; 0495A7 : AA          ;
CODE_0495A8:          JSR.W OW_TilePos_Calc               ;; 0495A8 : 20 85 98    ;
CODE_0495AB:          LDA.W $1B78                         ;; 0495AB : AD 78 1B    ;
CODE_0495AE:          BEQ CODE_0495CE                     ;; 0495AE : F0 1E       ;
CODE_0495B0:          STY $06                             ;; 0495B0 : 84 06       ;
CODE_0495B2:          LDX.W $1B7A                         ;; 0495B2 : AE 7A 1B    ;
CODE_0495B5:          INX                                 ;; 0495B5 : E8          ;
CODE_0495B6:          LDA.W DATA_0490CA,X                 ;; 0495B6 : BD CA 90    ;
CODE_0495B9:          AND.W #$00FF                        ;; 0495B9 : 29 FF 00    ;
CODE_0495BC:          CMP $06                             ;; 0495BC : C5 06       ;
CODE_0495BE:          BNE ADDR_049575                     ;; 0495BE : D0 B5       ;
CODE_0495C0:          STX.W $1B7A                         ;; 0495C0 : 8E 7A 1B    ;
CODE_0495C3:          LDA.W DATA_049086,X                 ;; 0495C3 : BD 86 90    ;
CODE_0495C6:          AND.W #$00FF                        ;; 0495C6 : 29 FF 00    ;
CODE_0495C9:          CMP.W #$0058                        ;; 0495C9 : C9 58 00    ;
CODE_0495CC:          BNE CODE_0495DE                     ;; 0495CC : D0 10       ;
CODE_0495CE:          LDX $04                             ;; 0495CE : A6 04       ;
CODE_0495D0:          BMI ADDR_049575                     ;; 0495D0 : 30 A3       ;
CODE_0495D2:          CMP.W #$0800                        ;; 0495D2 : C9 00 08    ;
CODE_0495D5:          BCS ADDR_049575                     ;; 0495D5 : B0 9E       ;
CODE_0495D7:          LDA.L $7EC800,X                     ;; 0495D7 : BF 00 C8 7E ; \ Load OW tile number 
CODE_0495DB:          AND.W #$00FF                        ;; 0495DB : 29 FF 00    ; / 
CODE_0495DE:          STA.W $13C1                         ;; 0495DE : 8D C1 13    ; Set "Current OW tile" 
CODE_0495E1:          BEQ ADDR_049575                     ;; 0495E1 : F0 92       ;
CODE_0495E3:          CMP.W #$0087                        ;; 0495E3 : C9 87 00    ;
CODE_0495E6:          BCS ADDR_049575                     ;; 0495E6 : B0 8D       ;
CODE_0495E8:          PHA                                 ;; 0495E8 : 48          ;
CODE_0495E9:          PHY                                 ;; 0495E9 : 5A          ;
CODE_0495EA:          TAX                                 ;; 0495EA : AA          ;
CODE_0495EB:          DEX                                 ;; 0495EB : CA          ;
CODE_0495EC:          LDY.W #$0000                        ;; 0495EC : A0 00 00    ;
CODE_0495EF:          LDA.W DATA_049FEB,X                 ;; 0495EF : BD EB 9F    ;
CODE_0495F2:          STA $0E                             ;; 0495F2 : 85 0E       ;
CODE_0495F4:          AND.W #$00FF                        ;; 0495F4 : 29 FF 00    ;
CODE_0495F7:          CMP.W #$0014                        ;; 0495F7 : C9 14 00    ;
CODE_0495FA:          BNE CODE_0495FF                     ;; 0495FA : D0 03       ;
CODE_0495FC:          LDY.W #$0001                        ;; 0495FC : A0 01 00    ;
CODE_0495FF:          STY.W $1B80                         ;; 0495FF : 8C 80 1B    ;
CODE_049602:          LDX.W $0DD6                         ;; 049602 : AE D6 0D    ;
CODE_049605:          LDA $00                             ;; 049605 : A5 00       ;
CODE_049607:          STA.W $1F1F,X                       ;; 049607 : 9D 1F 1F    ;
CODE_04960A:          LDA $02                             ;; 04960A : A5 02       ;
CODE_04960C:          STA.W $1F21,X                       ;; 04960C : 9D 21 1F    ;
CODE_04960F:          PLY                                 ;; 04960F : 7A          ;
CODE_049610:          PLA                                 ;; 049610 : 68          ;
CODE_049611:          PHA                                 ;; 049611 : 48          ;
CODE_049612:          SEP #$30                            ;; 049612 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_049614:          LDX.B #$09                          ;; 049614 : A2 09       ;
CODE_049616:          CMP.W DATA_049426,X                 ;; 049616 : DD 26 94    ;
CODE_049619:          BNE CODE_049645                     ;; 049619 : D0 2A       ;
CODE_04961B:          PHY                                 ;; 04961B : 5A          ;
CODE_04961C:          JSR.W CODE_049A24                   ;; 04961C : 20 24 9A    ;
CODE_04961F:          PLY                                 ;; 04961F : 7A          ;
CODE_049620:          LDA.B #$01                          ;; 049620 : A9 01       ;
CODE_049622:          STA.W $1B9E                         ;; 049622 : 8D 9E 1B    ;
CODE_049625:          JSR.W CODE_04F407                   ;; 049625 : 20 07 F4    ;
CODE_049628:          STZ.W $1B8C                         ;; 049628 : 9C 8C 1B    ;
CODE_04962B:          REP #$20                            ;; 04962B : C2 20       ; Accum (16 bit) 
CODE_04962D:          STZ.W $0701                         ;; 04962D : 9C 01 07    ;
CODE_049630:          LDA.W #$7000                        ;; 049630 : A9 00 70    ;
CODE_049633:          STA.W $1B8D                         ;; 049633 : 8D 8D 1B    ;
CODE_049636:          LDA.W #$5400                        ;; 049636 : A9 00 54    ;
CODE_049639:          STA.W $1B8F                         ;; 049639 : 8D 8F 1B    ;
CODE_04963C:          SEP #$20                            ;; 04963C : E2 20       ; Accum (8 bit) 
CODE_04963E:          LDA.B #$0A                          ;; 04963E : A9 0A       ;
CODE_049640:          STA.W $13D9                         ;; 049640 : 8D D9 13    ;
CODE_049643:          BRA CODE_049648                     ;; 049643 : 80 03       ;
                                                          ;;                      ;
CODE_049645:          DEX                                 ;; 049645 : CA          ;
CODE_049646:          BPL CODE_049616                     ;; 049646 : 10 CE       ;
CODE_049648:          REP #$30                            ;; 049648 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04964A:          PLA                                 ;; 04964A : 68          ;
CODE_04964B:          PHA                                 ;; 04964B : 48          ;
CODE_04964C:          CMP.W #$0056                        ;; 04964C : C9 56 00    ;
CODE_04964F:          BCS CODE_049654                     ;; 04964F : B0 03       ;
CODE_049651:          JMP.W CODE_04971D                   ;; 049651 : 4C 1D 97    ;
                                                          ;;                      ;
CODE_049654:          CMP.W #$0080                        ;; 049654 : C9 80 00    ;
CODE_049657:          BEQ CODE_049663                     ;; 049657 : F0 0A       ;
CODE_049659:          CMP.W #$006A                        ;; 049659 : C9 6A 00    ;
CODE_04965C:          BCC CODE_049676                     ;; 04965C : 90 18       ;
CODE_04965E:          CMP.W #$006E                        ;; 04965E : C9 6E 00    ;
CODE_049661:          BCS CODE_049676                     ;; 049661 : B0 13       ;
CODE_049663:          LDA.W $0DD6                         ;; 049663 : AD D6 0D    ;
CODE_049666:          LSR                                 ;; 049666 : 4A          ;
CODE_049667:          AND.W #$0002                        ;; 049667 : 29 02 00    ;
CODE_04966A:          TAX                                 ;; 04966A : AA          ;
CODE_04966B:          LDA.W $1F13,X                       ;; 04966B : BD 13 1F    ;
CODE_04966E:          ORA.W #$0008                        ;; 04966E : 09 08 00    ;
CODE_049671:          STA.W $1F13,X                       ;; 049671 : 9D 13 1F    ;
CODE_049674:          BRA CODE_049687                     ;; 049674 : 80 11       ;
                                                          ;;                      ;
CODE_049676:          LDA.W $0DD6                         ;; 049676 : AD D6 0D    ;
CODE_049679:          LSR                                 ;; 049679 : 4A          ;
CODE_04967A:          AND.W #$0002                        ;; 04967A : 29 02 00    ;
CODE_04967D:          TAX                                 ;; 04967D : AA          ;
CODE_04967E:          LDA.W $1F13,X                       ;; 04967E : BD 13 1F    ;
CODE_049681:          AND.W #$00F7                        ;; 049681 : 29 F7 00    ;
CODE_049684:          STA.W $1F13,X                       ;; 049684 : 9D 13 1F    ;
CODE_049687:          LDA.W #$0001                        ;; 049687 : A9 01 00    ;
CODE_04968A:          STA.W $1444                         ;; 04968A : 8D 44 14    ;
CODE_04968D:          LDA.W $13C1                         ;; 04968D : AD C1 13    ;
CODE_049690:          CMP.W #$005F                        ;; 049690 : C9 5F 00    ;
CODE_049693:          BEQ CODE_0496A5                     ;; 049693 : F0 10       ;
CODE_049695:          CMP.W #$005B                        ;; 049695 : C9 5B 00    ;
CODE_049698:          BEQ CODE_0496A5                     ;; 049698 : F0 0B       ;
CODE_04969A:          CMP.W #$0082                        ;; 04969A : C9 82 00    ;
CODE_04969D:          BEQ CODE_0496A5                     ;; 04969D : F0 06       ;
CODE_04969F:          LDA.W #$0023                        ;; 04969F : A9 23 00    ;
CODE_0496A2:          STA.W $1DFC                         ;; 0496A2 : 8D FC 1D    ; / Play sound effect 
CODE_0496A5:          NOP                                 ;; 0496A5 : EA          ;
CODE_0496A6:          NOP                                 ;; 0496A6 : EA          ;
CODE_0496A7:          NOP                                 ;; 0496A7 : EA          ;
CODE_0496A8:          LDA.W $13C1                         ;; 0496A8 : AD C1 13    ;
CODE_0496AB:          AND.W #$00FF                        ;; 0496AB : 29 FF 00    ;
CODE_0496AE:          CMP.W #$0082                        ;; 0496AE : C9 82 00    ;
CODE_0496B1:          BEQ CODE_0496D2                     ;; 0496B1 : F0 1F       ;
CODE_0496B3:          PHY                                 ;; 0496B3 : 5A          ;
CODE_0496B4:          TYA                                 ;; 0496B4 : 98          ;
CODE_0496B5:          AND.W #$00FF                        ;; 0496B5 : 29 FF 00    ;
CODE_0496B8:          EOR.W #$0002                        ;; 0496B8 : 49 02 00    ;
CODE_0496BB:          TAY                                 ;; 0496BB : A8          ;
CODE_0496BC:          STZ $06                             ;; 0496BC : 64 06       ;
CODE_0496BE:          LDX $04                             ;; 0496BE : A6 04       ;
CODE_0496C0:          LDA.L $7ED000,X                     ;; 0496C0 : BF 00 D0 7E ;
CODE_0496C4:          AND.W #$00FF                        ;; 0496C4 : 29 FF 00    ;
CODE_0496C7:          TAX                                 ;; 0496C7 : AA          ;
CODE_0496C8:          LDA.W DATA_04941E,Y                 ;; 0496C8 : B9 1E 94    ;
CODE_0496CB:          ORA.W $1EA2,X                       ;; 0496CB : 1D A2 1E    ;
CODE_0496CE:          STA.W $1EA2,X                       ;; 0496CE : 9D A2 1E    ;
CODE_0496D1:          PLY                                 ;; 0496D1 : 7A          ;
CODE_0496D2:          LDA.W $0DD6                         ;; 0496D2 : AD D6 0D    ;
CODE_0496D5:          LSR                                 ;; 0496D5 : 4A          ;
CODE_0496D6:          AND.W #$0002                        ;; 0496D6 : 29 02 00    ;
CODE_0496D9:          TAX                                 ;; 0496D9 : AA          ;
CODE_0496DA:          LDA.W $1F13,X                       ;; 0496DA : BD 13 1F    ;
CODE_0496DD:          AND.W #$000C                        ;; 0496DD : 29 0C 00    ;
CODE_0496E0:          STA $0E                             ;; 0496E0 : 85 0E       ;
CODE_0496E2:          LDA.W #$0001                        ;; 0496E2 : A9 01 00    ;
CODE_0496E5:          STA $04                             ;; 0496E5 : 85 04       ;
CODE_0496E7:          LDA.W $1B7E                         ;; 0496E7 : AD 7E 1B    ;
CODE_0496EA:          AND.W #$00FF                        ;; 0496EA : 29 FF 00    ;
CODE_0496ED:          STA $00                             ;; 0496ED : 85 00       ;
CODE_0496EF:          LDX.W #$0017                        ;; 0496EF : A2 17 00    ;
CODE_0496F2:          LDA.W DATA_04A03C,X                 ;; 0496F2 : BD 3C A0    ;
CODE_0496F5:          AND.W #$00FF                        ;; 0496F5 : 29 FF 00    ;
CODE_0496F8:          CMP $00                             ;; 0496F8 : C5 00       ;
CODE_0496FA:          BNE CODE_049704                     ;; 0496FA : D0 08       ;
CODE_0496FC:          TXA                                 ;; 0496FC : 8A          ;
CODE_0496FD:          ASL                                 ;; 0496FD : 0A          ;
CODE_0496FE:          TAX                                 ;; 0496FE : AA          ;
CODE_0496FF:          LDA.W DATA_04A054,X                 ;; 0496FF : BD 54 A0    ;
CODE_049702:          BRA CODE_049718                     ;; 049702 : 80 14       ;
                                                          ;;                      ;
CODE_049704:          DEX                                 ;; 049704 : CA          ;
CODE_049705:          BPL CODE_0496F2                     ;; 049705 : 10 EB       ;
CODE_049707:          LDA.W #$0000                        ;; 049707 : A9 00 00    ;
CODE_04970A:          ORA.W #$0800                        ;; 04970A : 09 00 08    ;
CODE_04970D:          CPY.W #$0004                        ;; 04970D : C0 04 00    ;
CODE_049710:          BCC CODE_049718                     ;; 049710 : 90 06       ;
CODE_049712:          LDA.W #$0000                        ;; 049712 : A9 00 00    ;
CODE_049715:          ORA.W #$0008                        ;; 049715 : 09 08 00    ;
CODE_049718:          LDX.W #$0000                        ;; 049718 : A2 00 00    ;
CODE_04971B:          BRA CODE_049728                     ;; 04971B : 80 0B       ;
                                                          ;;                      ;
CODE_04971D:          DEC A                               ;; 04971D : 3A          ;
CODE_04971E:          ASL                                 ;; 04971E : 0A          ;
CODE_04971F:          TAX                                 ;; 04971F : AA          ;
CODE_049720:          LDA.W DATA_049F49,X                 ;; 049720 : BD 49 9F    ;
CODE_049723:          STA $04                             ;; 049723 : 85 04       ;
CODE_049725:          LDA.W DATA_049EA7,X                 ;; 049725 : BD A7 9E    ;
CODE_049728:          STA $00                             ;; 049728 : 85 00       ;
CODE_04972A:          TXA                                 ;; 04972A : 8A          ;
CODE_04972B:          SEP #$20                            ;; 04972B : E2 20       ; Accum (8 bit) 
CODE_04972D:          LDX.W #$001C                        ;; 04972D : A2 1C 00    ;
CODE_049730:          CMP.W DATA_049430,X                 ;; 049730 : DD 30 94    ;
CODE_049733:          BEQ CODE_04973B                     ;; 049733 : F0 06       ;
CODE_049735:          DEX                                 ;; 049735 : CA          ;
CODE_049736:          DEX                                 ;; 049736 : CA          ;
CODE_049737:          BPL CODE_049730                     ;; 049737 : 10 F7       ;
CODE_049739:          BRA CODE_04974A                     ;; 049739 : 80 0F       ;
                                                          ;;                      ;
CODE_04973B:          TYA                                 ;; 04973B : 98          ;
CODE_04973C:          CMP.W DATA_049431,X                 ;; 04973C : DD 31 94    ;
CODE_04973F:          BEQ CODE_04974A                     ;; 04973F : F0 09       ;
CODE_049741:          TXA                                 ;; 049741 : 8A          ;
CODE_049742:          LSR                                 ;; 049742 : 4A          ;
CODE_049743:          TAX                                 ;; 049743 : AA          ;
CODE_049744:          LDA.W DATA_04944E,X                 ;; 049744 : BD 4E 94    ;
CODE_049747:          TAX                                 ;; 049747 : AA          ;
CODE_049748:          BRA CODE_049755                     ;; 049748 : 80 0B       ;
                                                          ;;                      ;
CODE_04974A:          LDX.W #$0000                        ;; 04974A : A2 00 00    ;
CODE_04974D:          TYA                                 ;; 04974D : 98          ;
CODE_04974E:          AND.B #$02                          ;; 04974E : 29 02       ;
CODE_049750:          BEQ CODE_049755                     ;; 049750 : F0 03       ;
CODE_049752:          LDX.W #$0001                        ;; 049752 : A2 01 00    ;
CODE_049755:          LDA $04,X                           ;; 049755 : B5 04       ;
CODE_049757:          BEQ CODE_049767                     ;; 049757 : F0 0E       ;
CODE_049759:          LDA $00                             ;; 049759 : A5 00       ;
CODE_04975B:          EOR.B #$FF                          ;; 04975B : 49 FF       ;
CODE_04975D:          INC A                               ;; 04975D : 1A          ;
CODE_04975E:          STA $00                             ;; 04975E : 85 00       ;
CODE_049760:          LDA $01                             ;; 049760 : A5 01       ;
CODE_049762:          EOR.B #$FF                          ;; 049762 : 49 FF       ;
CODE_049764:          INC A                               ;; 049764 : 1A          ;
CODE_049765:          STA $01                             ;; 049765 : 85 01       ;
CODE_049767:          REP #$20                            ;; 049767 : C2 20       ; Accum (16 bit) 
CODE_049769:          PLA                                 ;; 049769 : 68          ;
CODE_04976A:          LDX.W #$0000                        ;; 04976A : A2 00 00    ;
CODE_04976D:          LDA $0E                             ;; 04976D : A5 0E       ;
CODE_04976F:          AND.W #$0007                        ;; 04976F : 29 07 00    ;
CODE_049772:          BNE CODE_049777                     ;; 049772 : D0 03       ;
CODE_049774:          LDX.W #$0001                        ;; 049774 : A2 01 00    ;
CODE_049777:          LDA $0E                             ;; 049777 : A5 0E       ;
CODE_049779:          AND.W #$00FF                        ;; 049779 : 29 FF 00    ;
CODE_04977C:          STA $04                             ;; 04977C : 85 04       ;
CODE_04977E:          LDA $00,X                           ;; 04977E : B5 00       ;
CODE_049780:          AND.W #$00FF                        ;; 049780 : 29 FF 00    ;
CODE_049783:          CMP.W #$0080                        ;; 049783 : C9 80 00    ;
CODE_049786:          BCS CODE_049790                     ;; 049786 : B0 08       ;
CODE_049788:          LDA $04                             ;; 049788 : A5 04       ;
CODE_04978A:          CLC                                 ;; 04978A : 18          ;
CODE_04978B:          ADC.W #$0002                        ;; 04978B : 69 02 00    ;
CODE_04978E:          STA $04                             ;; 04978E : 85 04       ;
CODE_049790:          LDA.W $0DD6                         ;; 049790 : AD D6 0D    ;
CODE_049793:          LSR                                 ;; 049793 : 4A          ;
CODE_049794:          AND.W #$0002                        ;; 049794 : 29 02 00    ;
CODE_049797:          TAX                                 ;; 049797 : AA          ;
CODE_049798:          LDA $04                             ;; 049798 : A5 04       ;
CODE_04979A:          STA.W $1F13,X                       ;; 04979A : 9D 13 1F    ;
CODE_04979D:          LDX.W $0DD6                         ;; 04979D : AE D6 0D    ;
CODE_0497A0:          LDA $00                             ;; 0497A0 : A5 00       ;
CODE_0497A2:          AND.W #$00FF                        ;; 0497A2 : 29 FF 00    ;
CODE_0497A5:          CMP.W #$0080                        ;; 0497A5 : C9 80 00    ;
CODE_0497A8:          BCC CODE_0497AD                     ;; 0497A8 : 90 03       ;
CODE_0497AA:          ORA.W #$FF00                        ;; 0497AA : 09 00 FF    ;
CODE_0497AD:          CLC                                 ;; 0497AD : 18          ;
CODE_0497AE:          ADC.W $1F17,X                       ;; 0497AE : 7D 17 1F    ;
CODE_0497B1:          AND.W #$FFFC                        ;; 0497B1 : 29 FC FF    ;
CODE_0497B4:          STA.W $0DC7,X                       ;; 0497B4 : 9D C7 0D    ;
CODE_0497B7:          LDA $01                             ;; 0497B7 : A5 01       ;
CODE_0497B9:          AND.W #$00FF                        ;; 0497B9 : 29 FF 00    ;
CODE_0497BC:          CMP.W #$0080                        ;; 0497BC : C9 80 00    ;
CODE_0497BF:          BCC CODE_0497C4                     ;; 0497BF : 90 03       ;
CODE_0497C1:          ORA.W #$FF00                        ;; 0497C1 : 09 00 FF    ;
CODE_0497C4:          CLC                                 ;; 0497C4 : 18          ;
CODE_0497C5:          ADC.W $1F19,X                       ;; 0497C5 : 7D 19 1F    ;
CODE_0497C8:          AND.W #$FFFC                        ;; 0497C8 : 29 FC FF    ;
CODE_0497CB:          STA.W $0DC9,X                       ;; 0497CB : 9D C9 0D    ;
CODE_0497CE:          SEP #$20                            ;; 0497CE : E2 20       ; Accum (8 bit) 
CODE_0497D0:          LDA.W $0DC7,X                       ;; 0497D0 : BD C7 0D    ;
CODE_0497D3:          AND.B #$0F                          ;; 0497D3 : 29 0F       ;
CODE_0497D5:          BNE CODE_0497E3                     ;; 0497D5 : D0 0C       ;
CODE_0497D7:          LDY.W #$0004                        ;; 0497D7 : A0 04 00    ;
CODE_0497DA:          LDA $00                             ;; 0497DA : A5 00       ;
CODE_0497DC:          BMI CODE_0497E1                     ;; 0497DC : 30 03       ;
CODE_0497DE:          LDY.W #$0006                        ;; 0497DE : A0 06 00    ;
CODE_0497E1:          BRA CODE_0497F4                     ;; 0497E1 : 80 11       ;
                                                          ;;                      ;
CODE_0497E3:          LDA.W $0DC9,X                       ;; 0497E3 : BD C9 0D    ;
CODE_0497E6:          AND.B #$0F                          ;; 0497E6 : 29 0F       ;
CODE_0497E8:          BNE CODE_0497F4                     ;; 0497E8 : D0 0A       ;
CODE_0497EA:          LDY.W #$0000                        ;; 0497EA : A0 00 00    ;
CODE_0497ED:          LDA $01                             ;; 0497ED : A5 01       ;
CODE_0497EF:          BMI CODE_0497F4                     ;; 0497EF : 30 03       ;
CODE_0497F1:          LDY.W #$0002                        ;; 0497F1 : A0 02 00    ;
CODE_0497F4:          STY.W $0DD3                         ;; 0497F4 : 8C D3 0D    ;
CODE_0497F7:          LDA.W $13D9                         ;; 0497F7 : AD D9 13    ;
CODE_0497FA:          CMP.B #$0A                          ;; 0497FA : C9 0A       ;
CODE_0497FC:          BEQ CODE_049831                     ;; 0497FC : F0 33       ;
CODE_0497FE:          JMP.W CODE_04945D                   ;; 0497FE : 4C 5D 94    ;
                                                          ;;                      ;
CODE_049801:          REP #$20                            ;; 049801 : C2 20       ; Accum (16 bit) 
CODE_049803:          LDA.W $0DD6                         ;; 049803 : AD D6 0D    ;
CODE_049806:          CLC                                 ;; 049806 : 18          ;
CODE_049807:          ADC.W #$0002                        ;; 049807 : 69 02 00    ;
CODE_04980A:          TAX                                 ;; 04980A : AA          ;
CODE_04980B:          LDY.W #$0002                        ;; 04980B : A0 02 00    ;
CODE_04980E:          LDA.W $13D5,Y                       ;; 04980E : B9 D5 13    ;
CODE_049811:          AND.W #$00FF                        ;; 049811 : 29 FF 00    ;
CODE_049814:          CLC                                 ;; 049814 : 18          ;
CODE_049815:          ADC.W $0DCF,Y                       ;; 049815 : 79 CF 0D    ;
CODE_049818:          STA.W $13D5,Y                       ;; 049818 : 99 D5 13    ;
CODE_04981B:          AND.W #$FF00                        ;; 04981B : 29 00 FF    ;
CODE_04981E:          BPL CODE_049823                     ;; 04981E : 10 03       ;
CODE_049820:          ORA.W #$00FF                        ;; 049820 : 09 FF 00    ;
CODE_049823:          XBA                                 ;; 049823 : EB          ;
CODE_049824:          CLC                                 ;; 049824 : 18          ;
CODE_049825:          ADC.W $1F17,X                       ;; 049825 : 7D 17 1F    ;
CODE_049828:          STA.W $1F17,X                       ;; 049828 : 9D 17 1F    ;
CODE_04982B:          DEX                                 ;; 04982B : CA          ;
CODE_04982C:          DEX                                 ;; 04982C : CA          ;
CODE_04982D:          DEY                                 ;; 04982D : 88          ;
CODE_04982E:          DEY                                 ;; 04982E : 88          ;
CODE_04982F:          BPL CODE_04980E                     ;; 04982F : 10 DD       ;
CODE_049831:          SEP #$20                            ;; 049831 : E2 20       ; Accum (8 bit) 
CODE_049833:          LDA.W $13D9                         ;; 049833 : AD D9 13    ;
CODE_049836:          CMP.B #$0A                          ;; 049836 : C9 0A       ;
CODE_049838:          BEQ CODE_049882                     ;; 049838 : F0 48       ;
CODE_04983A:          LDA.W $1BA0                         ;; 04983A : AD A0 1B    ;
CODE_04983D:          BNE CODE_049882                     ;; 04983D : D0 43       ;
CODE_04983F:          REP #$30                            ;; 04983F : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_049841:          LDX.W $0DD6                         ;; 049841 : AE D6 0D    ;
CODE_049844:          LDA.W $1F17,X                       ;; 049844 : BD 17 1F    ;
CODE_049847:          STA $00                             ;; 049847 : 85 00       ;
CODE_049849:          LDA.W $1F19,X                       ;; 049849 : BD 19 1F    ;
CODE_04984C:          STA $02                             ;; 04984C : 85 02       ;
CODE_04984E:          TXA                                 ;; 04984E : 8A          ;
CODE_04984F:          LSR                                 ;; 04984F : 4A          ;
CODE_049850:          LSR                                 ;; 049850 : 4A          ;
CODE_049851:          TAX                                 ;; 049851 : AA          ;
CODE_049852:          LDA.W $1F11,X                       ;; 049852 : BD 11 1F    ;
CODE_049855:          AND.W #$00FF                        ;; 049855 : 29 FF 00    ;
CODE_049858:          BNE CODE_049882                     ;; 049858 : D0 28       ;
CODE_04985A:          LDX.W #$0002                        ;; 04985A : A2 02 00    ;
CODE_04985D:          TXY                                 ;; 04985D : 9B          ;
CODE_04985E:          LDA $00,X                           ;; 04985E : B5 00       ;
CODE_049860:          SEC                                 ;; 049860 : 38          ;
CODE_049861:          SBC.W #$0080                        ;; 049861 : E9 80 00    ;
CODE_049864:          BPL CODE_049870                     ;; 049864 : 10 0A       ;
CODE_049866:          CMP.W DATA_049416,Y                 ;; 049866 : D9 16 94    ;
CODE_049869:          BCS CODE_049878                     ;; 049869 : B0 0D       ;
CODE_04986B:          LDA.W DATA_049416,Y                 ;; 04986B : B9 16 94    ;
CODE_04986E:          BRA CODE_049878                     ;; 04986E : 80 08       ;
                                                          ;;                      ;
CODE_049870:          CMP.W DATA_04941A,Y                 ;; 049870 : D9 1A 94    ;
CODE_049873:          BCC CODE_049878                     ;; 049873 : 90 03       ;
CODE_049875:          LDA.W DATA_04941A,Y                 ;; 049875 : B9 1A 94    ;
CODE_049878:          STA RAM_ScreenBndryXLo,X            ;; 049878 : 95 1A       ;
CODE_04987A:          STA $1E,X                           ;; 04987A : 95 1E       ;
CODE_04987C:          DEY                                 ;; 04987C : 88          ;
CODE_04987D:          DEY                                 ;; 04987D : 88          ;
CODE_04987E:          DEX                                 ;; 04987E : CA          ;
CODE_04987F:          DEX                                 ;; 04987F : CA          ;
CODE_049880:          BPL CODE_04985E                     ;; 049880 : 10 DC       ;
CODE_049882:          SEP #$30                            ;; 049882 : E2 30       ; Index (8 bit) Accum (8 bit) 
Return049884:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
OW_TilePos_Calc:      LDA $00                             ;; TilePos_Calc : A5 00       ; Get overworld X pos/16 (X) ; Accum (16 bit) 
CODE_049887:          AND.W #$000F                        ;; 049887 : 29 0F 00    ; \ 
CODE_04988A:          STA $04                             ;; 04988A : 85 04       ;  | 
CODE_04988C:          LDA $00                             ;; 04988C : A5 00       ;  | 
CODE_04988E:          AND.W #$0010                        ;; 04988E : 29 10 00    ;  | 
CODE_049891:          ASL                                 ;; 049891 : 0A          ;  |Set tile pos to ((X&0xF)+((X&0x10)<<4)) 
CODE_049892:          ASL                                 ;; 049892 : 0A          ;  | 
CODE_049893:          ASL                                 ;; 049893 : 0A          ;  | 
CODE_049894:          ASL                                 ;; 049894 : 0A          ;  | 
CODE_049895:          ADC $04                             ;; 049895 : 65 04       ;  | 
CODE_049897:          STA $04                             ;; 049897 : 85 04       ; / 
CODE_049899:          LDA $02                             ;; 049899 : A5 02       ; Get overworld Y pos/16 (Y) 
CODE_04989B:          ASL                                 ;; 04989B : 0A          ; \ 
CODE_04989C:          ASL                                 ;; 04989C : 0A          ;  | 
CODE_04989D:          ASL                                 ;; 04989D : 0A          ;  |Increase tile pos by ((Y<<4)&0xFF) 
CODE_04989E:          ASL                                 ;; 04989E : 0A          ;  | 
CODE_04989F:          AND.W #$00FF                        ;; 04989F : 29 FF 00    ;  | 
CODE_0498A2:          ADC $04                             ;; 0498A2 : 65 04       ;  | 
CODE_0498A4:          STA $04                             ;; 0498A4 : 85 04       ; / 
CODE_0498A6:          LDA $02                             ;; 0498A6 : A5 02       ; \ 
CODE_0498A8:          AND.W #$0010                        ;; 0498A8 : 29 10 00    ;  | 
CODE_0498AB:          BEQ CODE_0498B5                     ;; 0498AB : F0 08       ;  |If (Y&0x10) isn't 0, 
CODE_0498AD:          LDA $04                             ;; 0498AD : A5 04       ;  |increase tile pos by x200 
CODE_0498AF:          CLC                                 ;; 0498AF : 18          ;  | 
CODE_0498B0:          ADC.W #$0200                        ;; 0498B0 : 69 00 02    ;  | 
CODE_0498B3:          STA $04                             ;; 0498B3 : 85 04       ; / 
CODE_0498B5:          LDA.W $1F11,X                       ;; 0498B5 : BD 11 1F    ; \ 
CODE_0498B8:          AND.W #$00FF                        ;; 0498B8 : 29 FF 00    ;  | 
CODE_0498BB:          BEQ Return0498C5                    ;; 0498BB : F0 08       ;  |If on submap, 
CODE_0498BD:          LDA $04                             ;; 0498BD : A5 04       ;  |Increase tile pos by x400 
CODE_0498BF:          CLC                                 ;; 0498BF : 18          ;  | 
CODE_0498C0:          ADC.W #$0400                        ;; 0498C0 : 69 00 04    ;  | 
CODE_0498C3:          STA $04                             ;; 0498C3 : 85 04       ; / 
Return0498C5:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0498C6:          STZ.W $1F13                         ;; 0498C6 : 9C 13 1F    ; Accum (8 bit) 
CODE_0498C9:          LDA.B #$80                          ;; 0498C9 : A9 80       ;
CODE_0498CB:          CLC                                 ;; 0498CB : 18          ;
CODE_0498CC:          ADC.W $13D7                         ;; 0498CC : 6D D7 13    ;
CODE_0498CF:          STA.W $13D7                         ;; 0498CF : 8D D7 13    ;
CODE_0498D2:          PHP                                 ;; 0498D2 : 08          ;
CODE_0498D3:          LDA.B #$0F                          ;; 0498D3 : A9 0F       ;
CODE_0498D5:          CMP.B #$08                          ;; 0498D5 : C9 08       ;
CODE_0498D7:          LDY.B #$00                          ;; 0498D7 : A0 00       ;
CODE_0498D9:          BCC CODE_0498DE                     ;; 0498D9 : 90 03       ;
CODE_0498DB:          ORA.B #$F0                          ;; 0498DB : 09 F0       ;
CODE_0498DD:          DEY                                 ;; 0498DD : 88          ;
CODE_0498DE:          PLP                                 ;; 0498DE : 28          ;
CODE_0498DF:          ADC.W $1F19                         ;; 0498DF : 6D 19 1F    ;
CODE_0498E2:          STA.W $1F19                         ;; 0498E2 : 8D 19 1F    ;
CODE_0498E5:          TYA                                 ;; 0498E5 : 98          ;
CODE_0498E6:          ADC.W $1F1A                         ;; 0498E6 : 6D 1A 1F    ;
CODE_0498E9:          STA.W $1F1A                         ;; 0498E9 : 8D 1A 1F    ;
CODE_0498EC:          LDA.W $1F19                         ;; 0498EC : AD 19 1F    ;
CODE_0498EF:          CMP.B #$78                          ;; 0498EF : C9 78       ;
CODE_0498F1:          BNE Return0498FA                    ;; 0498F1 : D0 07       ;
CODE_0498F3:          STZ.W $13D9                         ;; 0498F3 : 9C D9 13    ;
CODE_0498F6:          JSL.L CODE_009BC9                   ;; 0498F6 : 22 C9 9B 00 ;
Return0498FA:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_0498FB:          .db $08,$00,$04,$00,$02,$00,$01,$00 ;; 0498FB               ;
                                                          ;;                      ;
CODE_049903:          LDX.W $0DD5                         ;; 049903 : AE D5 0D    ;
CODE_049906:          BEQ Return0498C5                    ;; 049906 : F0 BD       ;
CODE_049908:          BMI Return0498C5                    ;; 049908 : 30 BB       ;
CODE_04990A:          DEX                                 ;; 04990A : CA          ;
CODE_04990B:          LDA.W DATA_049060,X                 ;; 04990B : BD 60 90    ;
CODE_04990E:          STA $08                             ;; 04990E : 85 08       ;
CODE_049910:          STZ $09                             ;; 049910 : 64 09       ;
CODE_049912:          REP #$20                            ;; 049912 : C2 20       ; Accum (16 bit) 
CODE_049914:          LDX.W $0DD6                         ;; 049914 : AE D6 0D    ;
CODE_049917:          LDA.W $1F17,X                       ;; 049917 : BD 17 1F    ;
CODE_04991A:          LSR                                 ;; 04991A : 4A          ;
CODE_04991B:          LSR                                 ;; 04991B : 4A          ;
CODE_04991C:          LSR                                 ;; 04991C : 4A          ;
CODE_04991D:          LSR                                 ;; 04991D : 4A          ;
CODE_04991E:          STA $00                             ;; 04991E : 85 00       ;
CODE_049920:          STA.W $1F1F,X                       ;; 049920 : 9D 1F 1F    ;
CODE_049923:          LDA.W $1F19,X                       ;; 049923 : BD 19 1F    ;
CODE_049926:          LSR                                 ;; 049926 : 4A          ;
CODE_049927:          LSR                                 ;; 049927 : 4A          ;
CODE_049928:          LSR                                 ;; 049928 : 4A          ;
CODE_049929:          LSR                                 ;; 049929 : 4A          ;
CODE_04992A:          STA $02                             ;; 04992A : 85 02       ;
CODE_04992C:          STA.W $1F21,X                       ;; 04992C : 9D 21 1F    ;
CODE_04992F:          TXA                                 ;; 04992F : 8A          ;
CODE_049930:          LSR                                 ;; 049930 : 4A          ;
CODE_049931:          LSR                                 ;; 049931 : 4A          ;
CODE_049932:          TAX                                 ;; 049932 : AA          ;
CODE_049933:          JSR.W OW_TilePos_Calc               ;; 049933 : 20 85 98    ;
CODE_049936:          REP #$10                            ;; 049936 : C2 10       ; Index (16 bit) 
CODE_049938:          LDX $04                             ;; 049938 : A6 04       ;
CODE_04993A:          LDA.L $7ED800,X                     ;; 04993A : BF 00 D8 7E ;
CODE_04993E:          AND.W #$00FF                        ;; 04993E : 29 FF 00    ;
CODE_049941:          LDX $08                             ;; 049941 : A6 08       ;
CODE_049943:          BEQ CODE_049949                     ;; 049943 : F0 04       ;
CODE_049945:          LSR                                 ;; 049945 : 4A          ;
CODE_049946:          DEX                                 ;; 049946 : CA          ;
CODE_049947:          BPL CODE_049945                     ;; 049947 : 10 FC       ;
CODE_049949:          AND.W #$0003                        ;; 049949 : 29 03 00    ;
CODE_04994C:          ASL                                 ;; 04994C : 0A          ;
CODE_04994D:          TAY                                 ;; 04994D : A8          ;
CODE_04994E:          LDX $04                             ;; 04994E : A6 04       ;
CODE_049950:          LDA.L $7ED000,X                     ;; 049950 : BF 00 D0 7E ;
CODE_049954:          AND.W #$00FF                        ;; 049954 : 29 FF 00    ;
CODE_049957:          TAX                                 ;; 049957 : AA          ;
CODE_049958:          LDA.W DATA_04941E,Y                 ;; 049958 : B9 1E 94    ;
CODE_04995B:          ORA.W $1EA2,X                       ;; 04995B : 1D A2 1E    ;
CODE_04995E:          STA.W $1EA2,X                       ;; 04995E : 9D A2 1E    ;
CODE_049961:          SEP #$30                            ;; 049961 : E2 30       ; Index (8 bit) Accum (8 bit) 
Return049963:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_049964:          .db $40,$01                         ;; 049964               ;
                                                          ;;                      ;
DATA_049966:          .db $28,$00                         ;; 049966               ;
                                                          ;;                      ;
DATA_049968:          .db $00,$50,$01,$58,$00,$00,$10,$00 ;; 049968               ;
                      .db $48,$00,$01,$10,$00,$98,$00,$01 ;; ?QPWZ?               ;
                      .db $A0,$00,$D8,$00,$00,$40,$01,$58 ;; ?QPWZ?               ;
                      .db $00,$02,$90,$00,$E8,$01,$04,$60 ;; ?QPWZ?               ;
                      .db $01,$E8,$00,$00,$A0,$00,$C8,$01 ;; ?QPWZ?               ;
                      .db $00,$60,$01,$88,$00,$03,$08,$01 ;; ?QPWZ?               ;
                      .db $90,$01,$00,$E8,$01,$10,$00,$03 ;; ?QPWZ?               ;
                      .db $10,$01,$C8,$01,$00,$F0,$01,$88 ;; ?QPWZ?               ;
                      .db $00,$03                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_0499AA:          .db $00,$00                         ;; 0499AA               ;
                                                          ;;                      ;
DATA_0499AC:          .db $48,$00                         ;; 0499AC               ;
                                                          ;;                      ;
DATA_0499AE:          .db $01,$00,$00,$98,$00,$01,$50,$01 ;; 0499AE               ;
                      .db $28,$00,$00,$60,$01,$58,$00,$00 ;; ?QPWZ?               ;
                      .db $50,$01,$58,$00,$02,$90,$00,$D8 ;; ?QPWZ?               ;
                      .db $00,$00,$50,$01,$E8,$00,$00,$A0 ;; ?QPWZ?               ;
                      .db $00,$E8,$01,$04,$50,$01,$88,$00 ;; ?QPWZ?               ;
                      .db $03,$B0,$00,$C8,$01,$00,$E8,$01 ;; ?QPWZ?               ;
                      .db $00,$00,$03,$08,$01,$A0,$01,$00 ;; ?QPWZ?               ;
                      .db $00,$02,$88,$00,$03,$00,$01,$C8 ;; ?QPWZ?               ;
                      .db $01,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_0499F0:          .db $00                             ;; 0499F0               ;
                                                          ;;                      ;
DATA_0499F1:          .db $04,$00,$09,$14,$02,$15,$05,$14 ;; 0499F1               ;
                      .db $05,$09,$0D,$15,$0E,$09,$1E,$15 ;; ?QPWZ?               ;
                      .db $08,$0A,$1C,$1E,$00,$10,$19,$1F ;; ?QPWZ?               ;
                      .db $08,$10,$1C                     ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_049A0C:          .db $EF,$FF                         ;; 049A0C               ;
                                                          ;;                      ;
DATA_049A0E:          .db $D8,$FF,$EF,$FF,$80,$00,$EF,$FF ;; 049A0E               ;
                      .db $28,$01,$F0,$00,$D8,$FF,$F0,$00 ;; ?QPWZ?               ;
                      .db $80,$00,$F0,$00,$28,$01         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_049A24:          REP #$20                            ;; 049A24 : C2 20       ; Accum (16 bit) 
CODE_049A26:          LDA.W $0DD6                         ;; 049A26 : AD D6 0D    ;
CODE_049A29:          LSR                                 ;; 049A29 : 4A          ;
CODE_049A2A:          LSR                                 ;; 049A2A : 4A          ;
CODE_049A2B:          TAX                                 ;; 049A2B : AA          ;
CODE_049A2C:          LDA.W $1F11,X                       ;; 049A2C : BD 11 1F    ;
CODE_049A2F:          AND.W #$00FF                        ;; 049A2F : 29 FF 00    ;
CODE_049A32:          STA.W $13C3                         ;; 049A32 : 8D C3 13    ;
CODE_049A35:          LDA.W #$001A                        ;; 049A35 : A9 1A 00    ;
CODE_049A38:          STA $02                             ;; 049A38 : 85 02       ;
CODE_049A3A:          LDY.B #$41                          ;; 049A3A : A0 41       ;
CODE_049A3C:          LDX.W $0DD6                         ;; 049A3C : AE D6 0D    ;
CODE_049A3F:          LDA.W $1F19,X                       ;; 049A3F : BD 19 1F    ;
CODE_049A42:          CMP.W DATA_049964,Y                 ;; 049A42 : D9 64 99    ;
CODE_049A45:          BNE CODE_049A85                     ;; 049A45 : D0 3E       ;
CODE_049A47:          LDA.W $1F17,X                       ;; 049A47 : BD 17 1F    ;
CODE_049A4A:          CMP.W DATA_049966,Y                 ;; 049A4A : D9 66 99    ;
CODE_049A4D:          BNE CODE_049A85                     ;; 049A4D : D0 36       ;
CODE_049A4F:          LDA.W DATA_049968,Y                 ;; 049A4F : B9 68 99    ;
CODE_049A52:          AND.W #$00FF                        ;; 049A52 : 29 FF 00    ;
CODE_049A55:          CMP.W $13C3                         ;; 049A55 : CD C3 13    ;
CODE_049A58:          BNE CODE_049A85                     ;; 049A58 : D0 2B       ;
CODE_049A5A:          LDA.W DATA_0499AA,Y                 ;; 049A5A : B9 AA 99    ;
CODE_049A5D:          STA.W $1F19,X                       ;; 049A5D : 9D 19 1F    ;
CODE_049A60:          LDA.W DATA_0499AC,Y                 ;; 049A60 : B9 AC 99    ;
CODE_049A63:          STA.W $1F17,X                       ;; 049A63 : 9D 17 1F    ;
CODE_049A66:          LDA.W DATA_0499AE,Y                 ;; 049A66 : B9 AE 99    ;
CODE_049A69:          AND.W #$00FF                        ;; 049A69 : 29 FF 00    ;
CODE_049A6C:          STA.W $13C3                         ;; 049A6C : 8D C3 13    ;
CODE_049A6F:          LDY $02                             ;; 049A6F : A4 02       ;
CODE_049A71:          LDA.W DATA_0499F0,Y                 ;; 049A71 : B9 F0 99    ;
CODE_049A74:          AND.W #$00FF                        ;; 049A74 : 29 FF 00    ;
CODE_049A77:          STA.W $1F21,X                       ;; 049A77 : 9D 21 1F    ;
CODE_049A7A:          LDA.W DATA_0499F1,Y                 ;; 049A7A : B9 F1 99    ;
CODE_049A7D:          AND.W #$00FF                        ;; 049A7D : 29 FF 00    ;
CODE_049A80:          STA.W $1F1F,X                       ;; 049A80 : 9D 1F 1F    ;
CODE_049A83:          BRA CODE_049A90                     ;; 049A83 : 80 0B       ;
                                                          ;;                      ;
CODE_049A85:          DEC $02                             ;; 049A85 : C6 02       ;
CODE_049A87:          DEC $02                             ;; 049A87 : C6 02       ;
CODE_049A89:          DEY                                 ;; 049A89 : 88          ;
CODE_049A8A:          DEY                                 ;; 049A8A : 88          ;
CODE_049A8B:          DEY                                 ;; 049A8B : 88          ;
CODE_049A8C:          DEY                                 ;; 049A8C : 88          ;
CODE_049A8D:          DEY                                 ;; 049A8D : 88          ;
CODE_049A8E:          BPL CODE_049A3F                     ;; 049A8E : 10 AF       ;
CODE_049A90:          SEP #$20                            ;; 049A90 : E2 20       ; Accum (8 bit) 
Return049A92:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_049A93:          LDA.W $0DD6                         ;; 049A93 : AD D6 0D    ; Accum (16 bit) 
CODE_049A96:          AND.W #$00FF                        ;; 049A96 : 29 FF 00    ;
CODE_049A99:          LSR                                 ;; 049A99 : 4A          ;
CODE_049A9A:          LSR                                 ;; 049A9A : 4A          ;
CODE_049A9B:          TAX                                 ;; 049A9B : AA          ;
CODE_049A9C:          LDA.W $1F11,X                       ;; 049A9C : BD 11 1F    ;
CODE_049A9F:          AND.W #$FF00                        ;; 049A9F : 29 00 FF    ;
CODE_049AA2:          ORA.W $13C3                         ;; 049AA2 : 0D C3 13    ;
CODE_049AA5:          STA.W $1F11,X                       ;; 049AA5 : 9D 11 1F    ;
CODE_049AA8:          AND.W #$00FF                        ;; 049AA8 : 29 FF 00    ;
CODE_049AAB:          BNE CODE_049AB0                     ;; 049AAB : D0 03       ;
CODE_049AAD:          JMP.W CODE_04983F                   ;; 049AAD : 4C 3F 98    ;
                                                          ;;                      ;
CODE_049AB0:          DEC A                               ;; 049AB0 : 3A          ;
CODE_049AB1:          ASL                                 ;; 049AB1 : 0A          ;
CODE_049AB2:          ASL                                 ;; 049AB2 : 0A          ;
CODE_049AB3:          TAY                                 ;; 049AB3 : A8          ;
CODE_049AB4:          LDA.W DATA_049A0C,Y                 ;; 049AB4 : B9 0C 9A    ;
CODE_049AB7:          STA RAM_ScreenBndryXLo              ;; 049AB7 : 85 1A       ;
CODE_049AB9:          STA $1E                             ;; 049AB9 : 85 1E       ;
CODE_049ABB:          LDA.W DATA_049A0E,Y                 ;; 049ABB : B9 0E 9A    ;
CODE_049ABE:          STA RAM_ScreenBndryYLo              ;; 049ABE : 85 1C       ;
CODE_049AC0:          STA $20                             ;; 049AC0 : 85 20       ;
CODE_049AC2:          SEP #$30                            ;; 049AC2 : E2 30       ; Index (8 bit) Accum (8 bit) 
Return049AC4:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
LevelNameStrings:     .db $18,$0E,$12,$07,$08,$5D,$12,$9F ;; ?QPWZ?               ;
                      .db $12,$13,$00,$11,$9F,$5A,$64,$1F ;; ?QPWZ?               ;
                      .db $08,$06,$06,$18,$5D,$12,$9F,$5A ;; ?QPWZ?               ;
                      .db $65,$1F,$0C,$0E,$11,$13,$0E,$0D ;; ?QPWZ?               ;
                      .db $5D,$12,$9F,$5A,$66,$1F,$0B,$04 ;; ?QPWZ?               ;
                      .db $0C,$0C,$18,$5D,$12,$9F,$5A,$67 ;; ?QPWZ?               ;
                      .db $1F,$0B,$14,$03,$16,$08,$06,$5D ;; ?QPWZ?               ;
                      .db $12,$9F,$5A,$68,$1F,$11,$0E,$18 ;; ?QPWZ?               ;
                      .db $5D,$12,$9F,$5A,$69,$1F,$16,$04 ;; ?QPWZ?               ;
                      .db $0D,$03,$18,$5D,$12,$9F,$5A,$6A ;; ?QPWZ?               ;
                      .db $1F,$0B,$00,$11,$11,$18,$5D,$12 ;; ?QPWZ?               ;
                      .db $9F,$03,$0E,$0D,$14,$13,$9F,$06 ;; ?QPWZ?               ;
                      .db $11,$04,$04,$0D,$9F,$13,$0E,$0F ;; ?QPWZ?               ;
                      .db $1F,$12,$04,$02,$11,$04,$13,$1F ;; ?QPWZ?               ;
                      .db $00,$11,$04,$00,$9F,$15,$00,$0D ;; ?QPWZ?               ;
                      .db $08,$0B,$0B,$00,$9F,$38,$39,$3A ;; ?QPWZ?               ;
                      .db $3B,$3C,$9F,$11,$04,$03,$9F,$01 ;; ?QPWZ?               ;
                      .db $0B,$14,$04,$9F,$01,$14,$13,$13 ;; ?QPWZ?               ;
                      .db $04,$11,$1F,$01,$11,$08,$03,$06 ;; ?QPWZ?               ;
                      .db $04,$9F,$02,$07,$04,$04,$12,$04 ;; ?QPWZ?               ;
                      .db $1F,$01,$11,$08,$03,$06,$04,$9F ;; ?QPWZ?               ;
                      .db $12,$0E,$03,$00,$1F,$0B,$00,$0A ;; ?QPWZ?               ;
                      .db $04,$9F,$02,$0E,$0E,$0A,$08,$04 ;; ?QPWZ?               ;
                      .db $1F,$0C,$0E,$14,$0D,$13,$00,$08 ;; ?QPWZ?               ;
                      .db $0D,$9F,$05,$0E,$11,$04,$12,$13 ;; ?QPWZ?               ;
                      .db $9F,$02,$07,$0E,$02,$0E,$0B,$00 ;; ?QPWZ?               ;
                      .db $13,$04,$9F,$02,$07,$0E,$02,$0E ;; ?QPWZ?               ;
                      .db $1C,$06,$07,$0E,$12,$13,$1F,$07 ;; ?QPWZ?               ;
                      .db $0E,$14,$12,$04,$9F,$12,$14,$0D ;; ?QPWZ?               ;
                      .db $0A,$04,$0D,$1F,$06,$07,$0E,$12 ;; ?QPWZ?               ;
                      .db $13,$1F,$12,$07,$08,$0F,$9F,$15 ;; ?QPWZ?               ;
                      .db $00,$0B,$0B,$04,$18,$9F,$01,$00 ;; ?QPWZ?               ;
                      .db $02,$0A,$1F,$03,$0E,$0E,$11,$9F ;; ?QPWZ?               ;
                      .db $05,$11,$0E,$0D,$13,$1F,$03,$0E ;; ?QPWZ?               ;
                      .db $0E,$11,$9F,$06,$0D,$00,$11,$0B ;; ?QPWZ?               ;
                      .db $18,$9F,$13,$14,$01,$14,$0B,$00 ;; ?QPWZ?               ;
                      .db $11,$9F,$16,$00,$18,$1F,$02,$0E ;; ?QPWZ?               ;
                      .db $0E,$0B,$9F,$07,$0E,$14,$12,$04 ;; ?QPWZ?               ;
                      .db $9F,$08,$12,$0B,$00,$0D,$03,$9F ;; ?QPWZ?               ;
                      .db $12,$16,$08,$13,$02,$07,$1F,$0F ;; ?QPWZ?               ;
                      .db $00,$0B,$00,$02,$04,$9F,$02,$00 ;; ?QPWZ?               ;
                      .db $12,$13,$0B,$04,$9F,$0F,$0B,$00 ;; ?QPWZ?               ;
                      .db $08,$0D,$12,$9F,$06,$07,$0E,$12 ;; ?QPWZ?               ;
                      .db $13,$1F,$07,$0E,$14,$12,$04,$9F ;; ?QPWZ?               ;
                      .db $12,$04,$02,$11,$04,$13,$9F,$03 ;; ?QPWZ?               ;
                      .db $0E,$0C,$04,$9F,$05,$0E,$11,$13 ;; ?QPWZ?               ;
                      .db $11,$04,$12,$12,$9F,$0E,$05,$32 ;; ?QPWZ?               ;
                      .db $33,$34,$35,$36,$37,$0E,$0D,$9F ;; ?QPWZ?               ;
                      .db $0E,$05,$1F,$01,$0E,$16,$12,$04 ;; ?QPWZ?               ;
                      .db $11,$9F,$11,$0E,$00,$03,$9F,$16 ;; ?QPWZ?               ;
                      .db $0E,$11,$0B,$03,$9F,$00,$16,$04 ;; ?QPWZ?               ;
                      .db $12,$0E,$0C,$04,$9F,$E4,$E5,$E6 ;; ?QPWZ?               ;
                      .db $E7,$E8,$0F,$00,$0B,$00,$02,$84 ;; ?QPWZ?               ;
                      .db $00,$11,$04,$80,$06,$11,$0E,$0E ;; ?QPWZ?               ;
                      .db $15,$98,$0C,$0E,$0D,$03,$8E,$0E ;; ?QPWZ?               ;
                      .db $14,$13,$11,$00,$06,$04,$0E,$14 ;; ?QPWZ?               ;
                      .db $92,$05,$14,$0D,$0A,$98,$07,$0E ;; ?QPWZ?               ;
                      .db $14,$12,$84,$9F                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_049C91:          .db $CB,$01,$00,$00,$08,$00,$0D,$00 ;; 049C91               ;
                      .db $17,$00,$23,$00,$2E,$00,$3A,$00 ;; ?QPWZ?               ;
                      .db $43,$00,$4E,$00,$59,$00,$5F,$00 ;; ?QPWZ?               ;
                      .db $65,$00,$75,$00,$7D,$00,$83,$00 ;; ?QPWZ?               ;
                      .db $87,$00,$8C,$00,$9A,$00,$A8,$00 ;; ?QPWZ?               ;
                      .db $B2,$00,$C2,$00,$C9,$00,$D3,$00 ;; ?QPWZ?               ;
                      .db $E5,$00,$F7,$00,$FE,$00,$08,$01 ;; ?QPWZ?               ;
                      .db $13,$01,$1A,$01,$22,$01         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_049CCF:          .db $CB,$01,$2B,$01,$31,$01,$38,$01 ;; 049CCF               ;
                      .db $46,$01,$4D,$01,$54,$01,$60,$01 ;; ?QPWZ?               ;
                      .db $67,$01,$6C,$01,$75,$01,$80,$01 ;; ?QPWZ?               ;
                      .db $8A,$01,$8F,$01,$95,$01         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_049CED:          .db $CB,$01,$9D,$01,$9E,$01,$9F,$01 ;; 049CED               ;
                      .db $A0,$01,$A1,$01,$A2,$01,$A8,$01 ;; ?QPWZ?               ;
                      .db $AC,$01,$B2,$01,$B7,$01,$C1,$01 ;; ?QPWZ?               ;
                      .db $C6,$01                         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_049D07:          LDA.L $7F837B                       ;; 049D07 : AF 7B 83 7F ; Index (16 bit) Accum (16 bit) 
CODE_049D0B:          TAX                                 ;; 049D0B : AA          ;
CODE_049D0C:          CLC                                 ;; 049D0C : 18          ;
CODE_049D0D:          ADC.W #$0026                        ;; 049D0D : 69 26 00    ;
CODE_049D10:          STA $02                             ;; 049D10 : 85 02       ;
CODE_049D12:          CLC                                 ;; 049D12 : 18          ;
CODE_049D13:          ADC.W #$0004                        ;; 049D13 : 69 04 00    ;
CODE_049D16:          STA.L $7F837B                       ;; 049D16 : 8F 7B 83 7F ;
CODE_049D1A:          LDA.W #$2500                        ;; 049D1A : A9 00 25    ;
CODE_049D1D:          STA.L $7F837F,X                     ;; 049D1D : 9F 7F 83 7F ;
CODE_049D21:          LDA.W #$8B50                        ;; 049D21 : A9 50 8B    ;
CODE_049D24:          STA.L $7F837D,X                     ;; 049D24 : 9F 7D 83 7F ;
CODE_049D28:          LDA $01                             ;; 049D28 : A5 01       ;
CODE_049D2A:          AND.W #$007F                        ;; 049D2A : 29 7F 00    ;
CODE_049D2D:          ASL                                 ;; 049D2D : 0A          ;
CODE_049D2E:          TAY                                 ;; 049D2E : A8          ;
CODE_049D2F:          LDA.W DATA_049C91,Y                 ;; 049D2F : B9 91 9C    ;
CODE_049D32:          TAY                                 ;; 049D32 : A8          ;
CODE_049D33:          SEP #$20                            ;; 049D33 : E2 20       ; Accum (8 bit) 
CODE_049D35:          LDA.W LevelNameStrings,Y            ;; 049D35 : B9 C5 9A    ;
CODE_049D38:          BMI CODE_049D3D                     ;; 049D38 : 30 03       ;
CODE_049D3A:          JSR.W CODE_049D7F                   ;; 049D3A : 20 7F 9D    ;
CODE_049D3D:          REP #$20                            ;; 049D3D : C2 20       ; Accum (16 bit) 
CODE_049D3F:          LDA $00                             ;; 049D3F : A5 00       ;
CODE_049D41:          AND.W #$00F0                        ;; 049D41 : 29 F0 00    ;
CODE_049D44:          LSR                                 ;; 049D44 : 4A          ;
CODE_049D45:          LSR                                 ;; 049D45 : 4A          ;
CODE_049D46:          LSR                                 ;; 049D46 : 4A          ;
CODE_049D47:          TAY                                 ;; 049D47 : A8          ;
CODE_049D48:          LDA.W DATA_049CCF,Y                 ;; 049D48 : B9 CF 9C    ;
CODE_049D4B:          TAY                                 ;; 049D4B : A8          ;
CODE_049D4C:          SEP #$20                            ;; 049D4C : E2 20       ; Accum (8 bit) 
CODE_049D4E:          LDA.W LevelNameStrings,Y            ;; 049D4E : B9 C5 9A    ;
CODE_049D51:          CMP.B #$9F                          ;; 049D51 : C9 9F       ;
CODE_049D53:          BEQ CODE_049D58                     ;; 049D53 : F0 03       ;
CODE_049D55:          JSR.W CODE_049D7F                   ;; 049D55 : 20 7F 9D    ;
CODE_049D58:          REP #$20                            ;; 049D58 : C2 20       ; Accum (16 bit) 
CODE_049D5A:          LDA $00                             ;; 049D5A : A5 00       ;
CODE_049D5C:          AND.W #$000F                        ;; 049D5C : 29 0F 00    ;
CODE_049D5F:          ASL                                 ;; 049D5F : 0A          ;
CODE_049D60:          TAY                                 ;; 049D60 : A8          ;
CODE_049D61:          LDA.W DATA_049CED,Y                 ;; 049D61 : B9 ED 9C    ;
CODE_049D64:          TAY                                 ;; 049D64 : A8          ;
CODE_049D65:          SEP #$20                            ;; 049D65 : E2 20       ; Accum (8 bit) 
CODE_049D67:          JSR.W CODE_049D7F                   ;; 049D67 : 20 7F 9D    ;
CODE_049D6A:          CPX $02                             ;; 049D6A : E4 02       ;
CODE_049D6C:          BCS CODE_049D76                     ;; 049D6C : B0 08       ;
CODE_049D6E:          LDY.W #$01CB                        ;; 049D6E : A0 CB 01    ;
CODE_049D71:          JSR.W CODE_049D7F                   ;; 049D71 : 20 7F 9D    ;
CODE_049D74:          BRA CODE_049D6A                     ;; 049D74 : 80 F4       ;
                                                          ;;                      ;
CODE_049D76:          LDA.B #$FF                          ;; 049D76 : A9 FF       ;
CODE_049D78:          STA.L $7F8381,X                     ;; 049D78 : 9F 81 83 7F ;
CODE_049D7C:          REP #$20                            ;; 049D7C : C2 20       ; Accum (16 bit) 
Return049D7E:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_049D7F:          LDA.W LevelNameStrings,Y            ;; 049D7F : B9 C5 9A    ; Index (8 bit) Accum (8 bit) 
CODE_049D82:          PHP                                 ;; 049D82 : 08          ;
CODE_049D83:          CPX $02                             ;; 049D83 : E4 02       ;
CODE_049D85:          BCS CODE_049D95                     ;; 049D85 : B0 0E       ;
CODE_049D87:          AND.B #$7F                          ;; 049D87 : 29 7F       ;
CODE_049D89:          STA.L $7F8381,X                     ;; 049D89 : 9F 81 83 7F ;
CODE_049D8D:          LDA.B #$39                          ;; 049D8D : A9 39       ;
CODE_049D8F:          STA.L $7F8382,X                     ;; 049D8F : 9F 82 83 7F ;
CODE_049D93:          INX                                 ;; 049D93 : E8          ;
CODE_049D94:          INX                                 ;; 049D94 : E8          ;
CODE_049D95:          INY                                 ;; 049D95 : C8          ;
CODE_049D96:          PLP                                 ;; 049D96 : 28          ;
CODE_049D97:          BPL CODE_049D7F                     ;; 049D97 : 10 E6       ;
Return049D99:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_049D9A:          LDA.W $0DB2                         ;; 049D9A : AD B2 0D    ;
CODE_049D9D:          BEQ CODE_049DAF                     ;; 049D9D : F0 10       ;
CODE_049D9F:          LDA.W $0DB3                         ;; 049D9F : AD B3 0D    ;
CODE_049DA2:          EOR.B #$01                          ;; 049DA2 : 49 01       ;
CODE_049DA4:          TAX                                 ;; 049DA4 : AA          ;
CODE_049DA5:          LDA.W RAM_PlayerLives,X             ;; 049DA5 : BD B4 0D    ;
CODE_049DA8:          BMI CODE_049DAF                     ;; 049DA8 : 30 05       ;
CODE_049DAA:          LDA.W $0DD5                         ;; 049DAA : AD D5 0D    ;
CODE_049DAD:          BNE CODE_049DBC                     ;; 049DAD : D0 0D       ;
CODE_049DAF:          LDA.B #$03                          ;; 049DAF : A9 03       ;
CODE_049DB1:          STA.W $13D9                         ;; 049DB1 : 8D D9 13    ;
CODE_049DB4:          STZ.W $0DD5                         ;; 049DB4 : 9C D5 0D    ;
CODE_049DB7:          REP #$30                            ;; 049DB7 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_049DB9:          JMP.W CODE_049831                   ;; 049DB9 : 4C 31 98    ;
                                                          ;;                      ;
CODE_049DBC:          DEC.W $0DB1                         ;; 049DBC : CE B1 0D    ; Index (8 bit) Accum (8 bit) 
CODE_049DBF:          BPL CODE_049DCC                     ;; 049DBF : 10 0B       ;
CODE_049DC1:          LDA.B #$02                          ;; 049DC1 : A9 02       ;
CODE_049DC3:          STA.W $0DB1                         ;; 049DC3 : 8D B1 0D    ;
CODE_049DC6:          STZ.W $0DD5                         ;; 049DC6 : 9C D5 0D    ;
CODE_049DC9:          INC.W $13D9                         ;; 049DC9 : EE D9 13    ;
CODE_049DCC:          REP #$30                            ;; 049DCC : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_049DCE:          JMP.W CODE_049831                   ;; 049DCE : 4C 31 98    ;
                                                          ;;                      ;
CODE_049DD1:          LDA.W $0DB3                         ;; 049DD1 : AD B3 0D    ; Index (8 bit) Accum (8 bit) 
CODE_049DD4:          EOR.B #$01                          ;; 049DD4 : 49 01       ;
CODE_049DD6:          STA.W $0DB3                         ;; 049DD6 : 8D B3 0D    ;
CODE_049DD9:          TAX                                 ;; 049DD9 : AA          ;
CODE_049DDA:          LDA.W RAM_PlayerCoins,X             ;; 049DDA : BD B6 0D    ;
CODE_049DDD:          STA.W RAM_StatusCoins               ;; 049DDD : 8D BF 0D    ;
CODE_049DE0:          LDA.W RAM_PlayerLives,X             ;; 049DE0 : BD B4 0D    ;
CODE_049DE3:          STA.W RAM_StatusLives               ;; 049DE3 : 8D BE 0D    ;
CODE_049DE6:          LDA.W RAM_PlayerPowerUp,X           ;; 049DE6 : BD B8 0D    ;
CODE_049DE9:          STA RAM_MarioPowerUp                ;; 049DE9 : 85 19       ;
CODE_049DEB:          LDA.W RAM_PlyrYoshiColor,X          ;; 049DEB : BD BA 0D    ;
CODE_049DEE:          STA.W RAM_OWHasYoshi                ;; 049DEE : 8D C1 0D    ;
CODE_049DF1:          STA.W RAM_YoshiColor                ;; 049DF1 : 8D C7 13    ;
CODE_049DF4:          STA.W RAM_OnYoshi                   ;; 049DF4 : 8D 7A 18    ;
CODE_049DF7:          LDA.W $0DBC,X                       ;; 049DF7 : BD BC 0D    ;
CODE_049DFA:          STA.W $0DC2                         ;; 049DFA : 8D C2 0D    ;
CODE_049DFD:          JSL.L CODE_05DBF2                   ;; 049DFD : 22 F2 DB 05 ;
CODE_049E01:          REP #$20                            ;; 049E01 : C2 20       ; Accum (16 bit) 
CODE_049E03:          JSR.W CODE_048E55                   ;; 049E03 : 20 55 8E    ;
CODE_049E06:          SEP #$20                            ;; 049E06 : E2 20       ; Accum (8 bit) 
CODE_049E08:          LDX.W $0DB3                         ;; 049E08 : AE B3 0D    ;
CODE_049E0B:          LDA.W $1F11,X                       ;; 049E0B : BD 11 1F    ;
CODE_049E0E:          STA.W $13C3                         ;; 049E0E : 8D C3 13    ;
CODE_049E11:          STZ.W $13C4                         ;; 049E11 : 9C C4 13    ;
CODE_049E14:          LDA.B #$02                          ;; 049E14 : A9 02       ;
CODE_049E16:          STA.W $0DB1                         ;; 049E16 : 8D B1 0D    ;
CODE_049E19:          LDA.B #$0A                          ;; 049E19 : A9 0A       ;
CODE_049E1B:          STA.W $13D9                         ;; 049E1B : 8D D9 13    ;
CODE_049E1E:          INC.W $0DD8                         ;; 049E1E : EE D8 0D    ;
Return049E21:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_049E22:          DEC.W $0DB1                         ;; 049E22 : CE B1 0D    ;
CODE_049E25:          BPL Return049E4B                    ;; 049E25 : 10 24       ;
CODE_049E27:          LDA.B #$02                          ;; 049E27 : A9 02       ;
CODE_049E29:          STA.W $0DB1                         ;; 049E29 : 8D B1 0D    ;
CODE_049E2C:          LDX.W $0DAF                         ;; 049E2C : AE AF 0D    ;
CODE_049E2F:          LDA.W $0DAE                         ;; 049E2F : AD AE 0D    ;
CODE_049E32:          CLC                                 ;; 049E32 : 18          ;
CODE_049E33:          ADC.L DATA_009F2F,X                 ;; 049E33 : 7F 2F 9F 00 ;
CODE_049E37:          STA.W $0DAE                         ;; 049E37 : 8D AE 0D    ;
CODE_049E3A:          CMP.L DATA_009F33,X                 ;; 049E3A : DF 33 9F 00 ;
CODE_049E3E:          BNE Return049E4B                    ;; 049E3E : D0 0B       ;
CODE_049E40:          INC.W $13D9                         ;; 049E40 : EE D9 13    ;
CODE_049E43:          LDA.W $0DAF                         ;; 049E43 : AD AF 0D    ;
CODE_049E46:          EOR.B #$01                          ;; 049E46 : 49 01       ;
CODE_049E48:          STA.W $0DAF                         ;; 049E48 : 8D AF 0D    ;
Return049E4B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_049E4C:          LDA.B #$03                          ;; 049E4C : A9 03       ;
CODE_049E4E:          STA.W $13D9                         ;; 049E4E : 8D D9 13    ;
Return049E51:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_049E52:          LDA.W $1DF7                         ;; 049E52 : AD F7 1D    ;
CODE_049E55:          BNE CODE_049E63                     ;; 049E55 : D0 0C       ;
CODE_049E57:          INC.W $1DF8                         ;; 049E57 : EE F8 1D    ;
CODE_049E5A:          LDA.W $1DF8                         ;; 049E5A : AD F8 1D    ;
CODE_049E5D:          CMP.B #$31                          ;; 049E5D : C9 31       ;
CODE_049E5F:          BNE CODE_049E93                     ;; 049E5F : D0 32       ;
CODE_049E61:          BRA CODE_049E69                     ;; 049E61 : 80 06       ;
                                                          ;;                      ;
CODE_049E63:          LDA RAM_FrameCounter                ;; 049E63 : A5 13       ;
CODE_049E65:          AND.B #$07                          ;; 049E65 : 29 07       ;
CODE_049E67:          BNE CODE_049E78                     ;; 049E67 : D0 0F       ;
CODE_049E69:          INC.W $1DF7                         ;; 049E69 : EE F7 1D    ;
CODE_049E6C:          LDA.W $1DF7                         ;; 049E6C : AD F7 1D    ;
CODE_049E6F:          CMP.B #$05                          ;; 049E6F : C9 05       ;
CODE_049E71:          BNE CODE_049E78                     ;; 049E71 : D0 05       ;
CODE_049E73:          LDA.B #$04                          ;; 049E73 : A9 04       ;
CODE_049E75:          STA.W $1DF7                         ;; 049E75 : 8D F7 1D    ;
CODE_049E78:          REP #$20                            ;; 049E78 : C2 20       ; Accum (16 bit) 
CODE_049E7A:          LDA.W $1DF7                         ;; 049E7A : AD F7 1D    ;
CODE_049E7D:          AND.W #$00FF                        ;; 049E7D : 29 FF 00    ;
CODE_049E80:          STA $00                             ;; 049E80 : 85 00       ;
CODE_049E82:          LDX.W $0DD6                         ;; 049E82 : AE D6 0D    ;
CODE_049E85:          LDA.W $1F19,X                       ;; 049E85 : BD 19 1F    ;
CODE_049E88:          SEC                                 ;; 049E88 : 38          ;
CODE_049E89:          SBC $00                             ;; 049E89 : E5 00       ;
CODE_049E8B:          STA.W $1F19,X                       ;; 049E8B : 9D 19 1F    ;
CODE_049E8E:          SEC                                 ;; 049E8E : 38          ;
CODE_049E8F:          SBC RAM_ScreenBndryYLo              ;; 049E8F : E5 1C       ;
CODE_049E91:          BMI CODE_049E96                     ;; 049E91 : 30 03       ;
CODE_049E93:          SEP #$20                            ;; 049E93 : E2 20       ; Accum (8 bit) 
Return049E95:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_049E96:          SEP #$20                            ;; 049E96 : E2 20       ; Accum (8 bit) 
CODE_049E98:          JMP.W CODE_04918D                   ;; 049E98 : 4C 8D 91    ;
                                                          ;;                      ;
ADDR_049E9B:          LDY.B #$00                          ;; 049E9B : A0 00       ; \ Unreachable 
ADDR_049E9D:          CMP.B #$0A                          ;; 049E9D : C9 0A       ;  | While A >= #$0A... 
ADDR_049E9F:          BCC Return049EA6                    ;; 049E9F : 90 05       ;  | 
ADDR_049EA1:          SBC.B #$0A                          ;; 049EA1 : E9 0A       ;  | A -= #$0A 
ADDR_049EA3:          INY                                 ;; 049EA3 : C8          ;  | Y++ 
ADDR_049EA4:          BRA ADDR_049E9D                     ;; 049EA4 : 80 F7       ; / 
                                                          ;;                      ;
Return049EA6:         RTS                                 ;; ?QPWZ? : 60          ; / Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_049EA7:          .db $10,$F8,$10,$00,$10,$FC,$10,$00 ;; 049EA7               ;
                      .db $10,$FC,$10,$00,$08,$FC,$0C,$F4 ;; ?QPWZ?               ;
                      .db $FC,$04,$04,$FC,$F8,$10,$00,$10 ;; ?QPWZ?               ;
                      .db $FC,$08,$FC,$08,$FC,$10,$00,$10 ;; ?QPWZ?               ;
                      .db $F8,$04,$FC,$10,$00,$10,$10,$08 ;; ?QPWZ?               ;
                      .db $10,$04,$10,$04,$08,$04,$0C,$0C ;; ?QPWZ?               ;
                      .db $04,$04,$04,$04,$08,$10,$FC,$F8 ;; ?QPWZ?               ;
                      .db $FC,$F8,$04,$10,$F8,$FC,$04,$10 ;; ?QPWZ?               ;
                      .db $F4,$F4,$0C,$F4,$10,$00,$00,$10 ;; ?QPWZ?               ;
                      .db $00,$10,$10,$00,$10,$00,$FC,$08 ;; ?QPWZ?               ;
                      .db $FC,$08,$00,$10,$10,$FC,$10,$FC ;; ?QPWZ?               ;
                      .db $FC,$04,$04,$FC,$F8,$10,$00,$10 ;; ?QPWZ?               ;
                      .db $FC,$10,$10,$04,$10,$00,$04,$10 ;; ?QPWZ?               ;
                      .db $04,$04,$FC,$F8,$04,$04,$10,$08 ;; ?QPWZ?               ;
                      .db $0C,$F4,$00,$10,$FC,$10,$10,$00 ;; ?QPWZ?               ;
                      .db $04,$10,$10,$F8,$00,$10,$00,$10 ;; ?QPWZ?               ;
                      .db $FC,$10,$10,$00,$00,$10,$00,$10 ;; ?QPWZ?               ;
                      .db $00,$10,$00,$10,$00,$10,$00,$10 ;; ?QPWZ?               ;
                      .db $04,$FC,$04,$04,$04,$04,$00,$10 ;; ?QPWZ?               ;
                      .db $00,$10,$10,$00,$10,$00,$FC,$10 ;; ?QPWZ?               ;
                      .db $FC,$04                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_049F49:          .db $01,$00,$01,$00,$01,$00,$01,$00 ;; 049F49               ;
                      .db $01,$00,$01,$00,$00,$01,$00,$01 ;; ?QPWZ?               ;
                      .db $00,$01,$00,$01,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $00,$01,$01,$00,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $00,$01,$01,$00,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $01,$00,$01,$00,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $01,$00,$01,$00,$01,$00,$00,$01 ;; ?QPWZ?               ;
                      .db $00,$01,$01,$00,$00,$01,$01,$00 ;; ?QPWZ?               ;
                      .db $00,$01,$01,$00,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $01,$00,$01,$00,$01,$00,$00,$01 ;; ?QPWZ?               ;
                      .db $01,$00,$01,$00,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $00,$01,$00,$01,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $01,$00,$01,$00,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $01,$00,$00,$01,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $01,$00,$01,$00,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $01,$00,$01,$00,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $01,$00,$01,$00,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $01,$00,$01,$00,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $00,$01,$01,$00,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $01,$00,$01,$00,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $00,$01                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_049FEB:          .db $04,$04,$04,$04,$04,$04,$04,$00 ;; 049FEB               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $04,$00,$00,$04,$04,$04,$04,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$04,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$04,$00,$00,$04,$04,$08 ;; ?QPWZ?               ;
                      .db $08,$08,$0C,$0C,$08,$08,$08,$08 ;; ?QPWZ?               ;
                      .db $08,$0C,$0C,$08,$08,$08,$08,$0C ;; ?QPWZ?               ;
                      .db $08,$08,$08,$0C,$08,$0C,$14,$14 ;; ?QPWZ?               ;
                      .db $14,$04,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$04,$04,$08 ;; ?QPWZ?               ;
                      .db $00                             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04A03C:          .db $07,$09,$0A,$0D,$0E,$11,$17,$19 ;; 04A03C               ;
                      .db $1A,$1C,$1D,$1F,$28,$29,$2D,$2E ;; ?QPWZ?               ;
                      .db $35,$36,$37,$49,$4A,$4B,$4D,$51 ;; ?QPWZ?               ;
DATA_04A054:          .db $08,$FC,$FC,$08,$FC,$08,$FC,$08 ;; 04A054               ;
                      .db $FC,$08,$04,$00,$08,$04,$04,$08 ;; ?QPWZ?               ;
                      .db $04,$08,$04,$00,$04,$08,$04,$00 ;; ?QPWZ?               ;
                      .db $FC,$08,$00,$00,$FC,$08,$FC,$08 ;; ?QPWZ?               ;
                      .db $04,$00,$04,$00,$00,$00,$08,$FC ;; ?QPWZ?               ;
                      .db $08,$04,$08,$04,$FC,$08,$08,$FC ;; ?QPWZ?               ;
DATA_04A084:          .db $04,$00                         ;; 04A084               ;
                                                          ;;                      ;
DATA_04A086:          .db $F8,$FF,$08,$00,$FC,$FF,$F8,$FF ;; 04A086               ;
                      .db $04,$00,$F8,$FF,$04,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $FC,$FF,$04,$00,$04,$00,$04,$00 ;; ?QPWZ?               ;
                      .db $08,$00,$08,$00,$04,$00,$F8,$FF ;; ?QPWZ?               ;
                      .db $FC,$FF,$00,$00,$00,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $04,$00,$04,$00,$04,$00,$F8,$FF ;; ?QPWZ?               ;
                      .db $04,$00,$04,$00,$04,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $FC,$FF,$F8,$FF,$04,$00,$04,$00 ;; ?QPWZ?               ;
                      .db $04,$00,$00,$00,$00,$00,$04,$00 ;; ?QPWZ?               ;
                      .db $04,$00,$04,$00,$F8,$FF,$04,$00 ;; ?QPWZ?               ;
                      .db $08,$00,$FC,$FF,$F8,$FF,$F8,$FF ;; ?QPWZ?               ;
                      .db $04,$00,$FC,$FF,$08,$00         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04A0E4:          .db $02,$02,$02,$02,$02,$00,$02,$02 ;; 04A0E4               ;
                      .db $02,$00,$02,$00,$02,$00,$02,$02 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$02,$02,$02,$02,$02 ;; ?QPWZ?               ;
LevelNames:           .db $00,$00,$72,$0D,$73,$0D,$00,$0C ;; ?QPWZ?               ;
                      .db $60,$0A,$53,$0A,$54,$0A,$40,$04 ;; ?QPWZ?               ;
                      .db $30,$0B,$52,$0A,$71,$0A,$90,$0D ;; ?QPWZ?               ;
                      .db $01,$11,$02,$11,$40,$06,$07,$12 ;; ?QPWZ?               ;
                      .db $00,$14,$00,$13,$C0,$02,$7C,$0A ;; ?QPWZ?               ;
                      .db $33,$0E,$51,$0A,$C0,$02,$53,$04 ;; ?QPWZ?               ;
                      .db $00,$18,$53,$04,$40,$08,$90,$16 ;; ?QPWZ?               ;
                      .db $25,$16,$24,$16,$C0,$02,$90,$15 ;; ?QPWZ?               ;
                      .db $40,$07,$00,$17,$21,$16,$23,$16 ;; ?QPWZ?               ;
                      .db $22,$16,$40,$03,$24,$01,$23,$01 ;; ?QPWZ?               ;
                      .db $10,$01,$21,$01,$22,$01,$60,$0D ;; ?QPWZ?               ;
                      .db $C0,$02,$71,$0D,$83,$0D,$72,$0A ;; ?QPWZ?               ;
                      .db $C0,$02,$00,$1B,$00,$1A,$B4,$19 ;; ?QPWZ?               ;
                      .db $40,$09,$90,$19,$00,$00,$B3,$19 ;; ?QPWZ?               ;
                      .db $60,$19,$B2,$19,$B1,$19,$70,$16 ;; ?QPWZ?               ;
                      .db $82,$0D,$84,$0D,$81,$0D,$30,$0F ;; ?QPWZ?               ;
                      .db $40,$05,$60,$15,$A1,$15,$A4,$15 ;; ?QPWZ?               ;
                      .db $A2,$15,$30,$10,$77,$15,$A3,$15 ;; ?QPWZ?               ;
                      .db $C0,$02,$0B,$00,$0A,$00,$09,$00 ;; ?QPWZ?               ;
                      .db $08,$00,$C0,$02,$00,$1C,$00,$1D ;; ?QPWZ?               ;
                      .db $00,$1E,$E0,$00,$C0,$02,$C0,$02 ;; ?QPWZ?               ;
                      .db $D2,$02,$C0,$02,$D3,$02,$C0,$02 ;; ?QPWZ?               ;
                      .db $D1,$02,$D4,$02,$D5,$02,$C0,$02 ;; ?QPWZ?               ;
                      .db $C0,$02,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04A400:          .db $50,$00,$41,$3E,$FE,$38,$50,$A0 ;; 04A400               ;
                      .db $C0,$28,$FE,$38,$50,$A1,$C0,$28 ;; ?QPWZ?               ;
                      .db $FE,$38,$50,$BE,$C0,$28,$FE,$38 ;; ?QPWZ?               ;
                      .db $50,$BF,$C0,$28,$FE,$38,$53,$40 ;; ?QPWZ?               ;
                      .db $41,$7E,$FE,$38,$50,$A2,$00,$01 ;; ?QPWZ?               ;
                      .db $92,$3C,$50,$A3,$40,$32,$93,$3C ;; ?QPWZ?               ;
                      .db $50,$BD,$00,$01,$92,$7C,$50,$C2 ;; ?QPWZ?               ;
                      .db $C0,$24,$94,$7C,$50,$DD,$C0,$24 ;; ?QPWZ?               ;
                      .db $94,$3C,$53,$22,$00,$01,$92,$BC ;; ?QPWZ?               ;
                      .db $53,$23,$40,$32,$93,$BC,$53,$3D ;; ?QPWZ?               ;
                      .db $00,$01,$92,$FC,$50,$FE,$C0,$24 ;; ?QPWZ?               ;
                      .db $D6,$2C,$53,$44,$40,$32,$D5,$2C ;; ?QPWZ?               ;
                      .db $50,$DE,$00,$01,$D4,$2C,$53,$43 ;; ?QPWZ?               ;
                      .db $00,$01,$D4,$EC,$53,$5E,$00,$01 ;; ?QPWZ?               ;
                      .db $D4,$AC,$50,$02,$00,$01,$95,$38 ;; ?QPWZ?               ;
                      .db $50,$09,$00,$01,$97,$38,$50,$0E ;; ?QPWZ?               ;
                      .db $00,$01,$96,$38,$50,$33,$00,$01 ;; ?QPWZ?               ;
                      .db $97,$38,$50,$37,$00,$01,$95,$38 ;; ?QPWZ?               ;
                      .db $50,$3B,$00,$01,$96,$38,$50,$42 ;; ?QPWZ?               ;
                      .db $00,$01,$96,$38,$50,$50,$00,$01 ;; ?QPWZ?               ;
                      .db $95,$38,$50,$55,$00,$01,$96,$38 ;; ?QPWZ?               ;
                      .db $50,$5E,$00,$01,$95,$38,$51,$01 ;; ?QPWZ?               ;
                      .db $00,$01,$97,$38,$51,$5F,$00,$01 ;; ?QPWZ?               ;
                      .db $96,$38,$51,$81,$00,$01,$95,$38 ;; ?QPWZ?               ;
                      .db $51,$C0,$00,$01,$96,$38,$51,$FF ;; ?QPWZ?               ;
                      .db $00,$01,$97,$38,$52,$60,$00,$01 ;; ?QPWZ?               ;
                      .db $95,$38,$52,$7F,$00,$01,$95,$38 ;; ?QPWZ?               ;
                      .db $53,$00,$00,$01,$97,$38,$53,$1F ;; ?QPWZ?               ;
                      .db $00,$01,$96,$38,$53,$61,$00,$01 ;; ?QPWZ?               ;
                      .db $95,$38,$53,$6A,$00,$01,$95,$38 ;; ?QPWZ?               ;
                      .db $53,$73,$00,$01,$96,$38,$53,$76 ;; ?QPWZ?               ;
                      .db $00,$01,$95,$38,$53,$86,$00,$01 ;; ?QPWZ?               ;
                      .db $96,$38,$53,$91,$00,$01,$95,$38 ;; ?QPWZ?               ;
                      .db $53,$9A,$00,$01,$97,$38,$53,$9E ;; ?QPWZ?               ;
                      .db $00,$01,$95,$38,$50,$23,$C0,$06 ;; ?QPWZ?               ;
                      .db $FC,$2C,$50,$24,$C0,$06,$FC,$2C ;; ?QPWZ?               ;
                      .db $50,$25,$C0,$06,$FC,$2C,$50,$26 ;; ?QPWZ?               ;
                      .db $C0,$06,$FC,$2C,$50,$87,$00,$01 ;; ?QPWZ?               ;
                      .db $8F,$38,$FF,$9B,$75,$81,$20,$01 ;; ?QPWZ?               ;
                      .db $76,$20,$9B,$75,$81,$20,$01,$76 ;; ?QPWZ?               ;
                      .db $20,$9A,$75,$00,$10,$81,$20,$01 ;; ?QPWZ?               ;
                      .db $76,$20,$94,$75,$00,$01,$81,$02 ;; ?QPWZ?               ;
                      .db $81,$01,$05,$02,$11,$50,$20,$7D ;; ?QPWZ?               ;
                      .db $20,$92,$75,$02,$10,$03,$11,$81 ;; ?QPWZ?               ;
                      .db $71,$81,$11,$81,$71,$03,$11,$43 ;; ?QPWZ?               ;
                      .db $10,$9C,$91,$75,$01,$10,$11,$89 ;; ?QPWZ?               ;
                      .db $71,$01,$11,$10,$89,$75,$04,$01 ;; ?QPWZ?               ;
                      .db $02,$03,$02,$01,$82,$75,$01,$3D ;; ?QPWZ?               ;
                      .db $71,$83,$AD,$81,$8A,$81,$AD,$81 ;; ?QPWZ?               ;
                      .db $8A,$01,$11,$10,$89,$75,$00,$3D ;; ?QPWZ?               ;
                      .db $82,$71,$00,$3D,$82,$75,$01,$3D ;; ?QPWZ?               ;
                      .db $71,$83,$AD,$81,$8A,$81,$AD,$81 ;; ?QPWZ?               ;
                      .db $8A,$01,$3D,$3F,$89,$75,$00,$00 ;; ?QPWZ?               ;
                      .db $81,$43,$01,$42,$40,$81,$75,$01 ;; ?QPWZ?               ;
                      .db $10,$00,$83,$43,$00,$11,$85,$71 ;; ?QPWZ?               ;
                      .db $01,$11,$10,$88,$75,$01,$11,$20 ;; ?QPWZ?               ;
                      .db $82,$69,$03,$20,$11,$75,$3D,$81 ;; ?QPWZ?               ;
                      .db $20,$82,$69,$00,$00,$81,$43,$00 ;; ?QPWZ?               ;
                      .db $11,$83,$71,$00,$3D,$88,$75,$01 ;; ?QPWZ?               ;
                      .db $11,$50,$81,$69,$04,$41,$42,$11 ;; ?QPWZ?               ;
                      .db $75,$3D,$81,$20,$81,$69,$01,$20 ;; ?QPWZ?               ;
                      .db $69,$81,$20,$00,$50,$83,$43,$00 ;; ?QPWZ?               ;
                      .db $10,$89,$75,$00,$11,$81,$43,$00 ;; ?QPWZ?               ;
                      .db $11,$82,$75,$02,$3D,$50,$20,$82 ;; ?QPWZ?               ;
                      .db $69,$81,$20,$01,$69,$20,$82,$69 ;; ?QPWZ?               ;
                      .db $01,$20,$76,$86,$75,$01,$54,$55 ;; ?QPWZ?               ;
                      .db $87,$75,$01,$00,$11,$83,$43,$00 ;; ?QPWZ?               ;
                      .db $50,$81,$20,$83,$69,$01,$20,$76 ;; ?QPWZ?               ;
                      .db $86,$75,$03,$9E,$9F,$06,$05,$85 ;; ?QPWZ?               ;
                      .db $03,$01,$20,$50,$83,$43,$00,$11 ;; ?QPWZ?               ;
                      .db $81,$43,$00,$50,$82,$69,$01,$20 ;; ?QPWZ?               ;
                      .db $7D,$84,$75,$04,$01,$02,$9E,$9F ;; ?QPWZ?               ;
                      .db $58,$81,$71,$02,$BA,$BD,$BF,$81 ;; ?QPWZ?               ;
                      .db $71,$81,$20,$83,$69,$03,$50,$11 ;; ?QPWZ?               ;
                      .db $71,$11,$82,$43,$01,$9C,$10,$84 ;; ?QPWZ?               ;
                      .db $75,$0E,$3D,$71,$9E,$9F,$71,$58 ;; ?QPWZ?               ;
                      .db $71,$BD,$BF,$BA,$71,$11,$20,$69 ;; ?QPWZ?               ;
                      .db $20,$83,$69,$00,$50,$83,$43,$02 ;; ?QPWZ?               ;
                      .db $10,$9C,$43,$84,$75,$04,$3D,$58 ;; ?QPWZ?               ;
                      .db $9E,$9F,$71,$81,$58,$06,$BF,$71 ;; ?QPWZ?               ;
                      .db $BD,$71,$11,$50,$20,$84,$69,$00 ;; ?QPWZ?               ;
                      .db $20,$82,$69,$03,$20,$76,$20,$69 ;; ?QPWZ?               ;
                      .db $83,$75,$05,$10,$11,$58,$9E,$9F ;; ?QPWZ?               ;
                      .db $58,$81,$71,$07,$58,$BA,$BD,$BF ;; ?QPWZ?               ;
                      .db $71,$11,$50,$20,$84,$69,$00,$20 ;; ?QPWZ?               ;
                      .db $81,$69,$03,$20,$76,$20,$69,$82 ;; ?QPWZ?               ;
                      .db $75,$06,$10,$11,$56,$57,$9E,$9F ;; ?QPWZ?               ;
                      .db $58,$82,$71,$02,$BD,$71,$BA,$81 ;; ?QPWZ?               ;
                      .db $71,$81,$58,$04,$43,$58,$43,$50 ;; ?QPWZ?               ;
                      .db $20,$82,$69,$03,$20,$76,$20,$69 ;; ?QPWZ?               ;
                      .db $82,$75,$05,$3D,$58,$9E,$9F,$64 ;; ?QPWZ?               ;
                      .db $65,$84,$71,$81,$BD,$00,$BF,$83 ;; ?QPWZ?               ;
                      .db $58,$04,$71,$58,$11,$50,$20,$81 ;; ?QPWZ?               ;
                      .db $69,$03,$20,$76,$20,$69,$82,$75 ;; ?QPWZ?               ;
                      .db $03,$3D,$71,$64,$65,$81,$71,$00 ;; ?QPWZ?               ;
                      .db $6E,$81,$6B,$05,$6E,$BD,$BF,$BA ;; ?QPWZ?               ;
                      .db $BD,$58,$81,$8A,$01,$AD,$8E,$81 ;; ?QPWZ?               ;
                      .db $58,$07,$11,$43,$BC,$3D,$20,$7D ;; ?QPWZ?               ;
                      .db $20,$69,$82,$75,$01,$00,$11,$81 ;; ?QPWZ?               ;
                      .db $71,$01,$AE,$BC,$83,$68,$04,$BA ;; ?QPWZ?               ;
                      .db $BD,$11,$43,$11,$81,$8A,$09,$AD ;; ?QPWZ?               ;
                      .db $8A,$8F,$53,$52,$71,$BC,$3D,$43 ;; ?QPWZ?               ;
                      .db $3F,$81,$43,$82,$75,$06,$20,$50 ;; ?QPWZ?               ;
                      .db $11,$8F,$9B,$71,$6E,$81,$6B,$05 ;; ?QPWZ?               ;
                      .db $6E,$11,$43,$00,$69,$00,$81,$43 ;; ?QPWZ?               ;
                      .db $08,$58,$8F,$9B,$63,$62,$71,$BC ;; ?QPWZ?               ;
                      .db $71,$10,$82,$3F,$82,$75,$02,$20 ;; ?QPWZ?               ;
                      .db $50,$11,$81,$AC,$01,$58,$11,$82 ;; ?QPWZ?               ;
                      .db $43,$04,$00,$69,$50,$43,$50,$81 ;; ?QPWZ?               ;
                      .db $20,$04,$50,$58,$9B,$8F,$6C,$81 ;; ?QPWZ?               ;
                      .db $68,$01,$6C,$3D,$82,$3F,$82,$75 ;; ?QPWZ?               ;
                      .db $02,$00,$11,$58,$81,$AC,$09,$11 ;; ?QPWZ?               ;
                      .db $50,$20,$69,$20,$50,$43,$11,$3F ;; ?QPWZ?               ;
                      .db $11,$81,$43,$03,$50,$3D,$8A,$BC ;; ?QPWZ?               ;
                      .db $83,$68,$00,$6C,$82,$03,$81,$75 ;; ?QPWZ?               ;
                      .db $03,$10,$11,$56,$57,$81,$AC,$01 ;; ?QPWZ?               ;
                      .db $3D,$50,$82,$43,$00,$11,$85,$3F ;; ?QPWZ?               ;
                      .db $03,$10,$11,$8A,$BC,$84,$68,$81 ;; ?QPWZ?               ;
                      .db $71,$00,$43,$81,$75,$03,$3D,$58 ;; ?QPWZ?               ;
                      .db $64,$65,$81,$8A,$01,$11,$10,$87 ;; ?QPWZ?               ;
                      .db $3F,$03,$10,$03,$52,$53,$81,$71 ;; ?QPWZ?               ;
                      .db $00,$6C,$82,$68,$03,$6C,$11,$00 ;; ?QPWZ?               ;
                      .db $69,$81,$75,$03,$3D,$71,$56,$57 ;; ?QPWZ?               ;
                      .db $81,$8A,$01,$58,$3D,$86,$3F,$00 ;; ?QPWZ?               ;
                      .db $10,$81,$8F,$0B,$62,$63,$52,$53 ;; ?QPWZ?               ;
                      .db $71,$52,$53,$71,$11,$50,$69,$20 ;; ?QPWZ?               ;
                      .db $81,$75,$03,$00,$11,$64,$65,$81 ;; ?QPWZ?               ;
                      .db $AC,$02,$11,$00,$11,$84,$3F,$0F ;; ?QPWZ?               ;
                      .db $10,$52,$53,$71,$8E,$71,$62,$63 ;; ?QPWZ?               ;
                      .db $52,$51,$63,$11,$50,$69,$20,$69 ;; ?QPWZ?               ;
                      .db $81,$75,$03,$20,$3D,$71,$58,$81 ;; ?QPWZ?               ;
                      .db $AC,$02,$3D,$50,$11,$84,$3F,$04 ;; ?QPWZ?               ;
                      .db $3D,$62,$63,$71,$8E,$82,$71,$03 ;; ?QPWZ?               ;
                      .db $62,$63,$42,$41,$82,$69,$00,$20 ;; ?QPWZ?               ;
                      .db $81,$75,$03,$20,$3D,$58,$71,$81 ;; ?QPWZ?               ;
                      .db $AC,$00,$3D,$83,$3F,$00,$10,$81 ;; ?QPWZ?               ;
                      .db $03,$0A,$11,$52,$53,$52,$53,$71 ;; ?QPWZ?               ;
                      .db $52,$53,$11,$50,$20,$82,$69,$07 ;; ?QPWZ?               ;
                      .db $50,$43,$75,$11,$20,$00,$11,$71 ;; ?QPWZ?               ;
                      .db $81,$AC,$01,$11,$10,$82,$3F,$00 ;; ?QPWZ?               ;
                      .db $3D,$81,$71,$09,$52,$51,$63,$62 ;; ?QPWZ?               ;
                      .db $63,$52,$51,$63,$3A,$20,$82,$69 ;; ?QPWZ?               ;
                      .db $03,$50,$11,$75,$20,$9E,$75,$00 ;; ?QPWZ?               ;
                      .db $20,$9E,$75,$01,$20,$10,$95,$75 ;; ?QPWZ?               ;
                      .db $03,$E2,$E5,$F5,$F6,$83,$75,$02 ;; ?QPWZ?               ;
                      .db $50,$11,$10,$90,$75,$07,$01,$02 ;; ?QPWZ?               ;
                      .db $03,$05,$84,$32,$33,$C4,$83,$75 ;; ?QPWZ?               ;
                      .db $03,$11,$71,$11,$10,$8D,$75,$02 ;; ?QPWZ?               ;
                      .db $01,$02,$11,$82,$71,$04,$35,$36 ;; ?QPWZ?               ;
                      .db $37,$38,$01,$82,$75,$01,$10,$03 ;; ?QPWZ?               ;
                      .db $81,$11,$00,$10,$8B,$75,$01,$10 ;; ?QPWZ?               ;
                      .db $11,$84,$71,$05,$49,$4A,$59,$5A ;; ?QPWZ?               ;
                      .db $11,$10,$81,$75,$81,$3F,$02,$10 ;; ?QPWZ?               ;
                      .db $71,$3D,$8B,$75,$02,$3D,$AD,$5D ;; ?QPWZ?               ;
                      .db $84,$68,$00,$5D,$82,$71,$00,$3D ;; ?QPWZ?               ;
                      .db $81,$75,$82,$3F,$81,$3D,$8B,$75 ;; ?QPWZ?               ;
                      .db $01,$3D,$AD,$86,$68,$81,$71,$01 ;; ?QPWZ?               ;
                      .db $11,$00,$81,$75,$81,$3F,$02,$10 ;; ?QPWZ?               ;
                      .db $11,$00,$87,$75,$01,$01,$02,$81 ;; ?QPWZ?               ;
                      .db $03,$02,$00,$11,$5D,$84,$68,$04 ;; ?QPWZ?               ;
                      .db $5D,$71,$11,$50,$20,$81,$75,$05 ;; ?QPWZ?               ;
                      .db $3F,$10,$11,$50,$20,$10,$85,$75 ;; ?QPWZ?               ;
                      .db $01,$10,$11,$82,$71,$04,$20,$50 ;; ?QPWZ?               ;
                      .db $44,$43,$44,$81,$43,$05,$44,$43 ;; ?QPWZ?               ;
                      .db $42,$40,$69,$20,$81,$75,$05,$9C ;; ?QPWZ?               ;
                      .db $43,$50,$69,$20,$3D,$85,$A4,$01 ;; ?QPWZ?               ;
                      .db $3D,$AD,$81,$8A,$03,$11,$20,$69 ;; ?QPWZ?               ;
                      .db $20,$87,$69,$81,$20,$81,$75,$81 ;; ?QPWZ?               ;
                      .db $20,$81,$69,$01,$50,$3D,$81,$B4 ;; ?QPWZ?               ;
                      .db $01,$B5,$A5,$81,$B4,$01,$3D,$AD ;; ?QPWZ?               ;
                      .db $81,$8A,$02,$11,$50,$20,$87,$69 ;; ?QPWZ?               ;
                      .db $0A,$20,$69,$20,$10,$75,$20,$69 ;; ?QPWZ?               ;
                      .db $20,$50,$11,$4D,$85,$75,$01,$4D ;; ?QPWZ?               ;
                      .db $71,$81,$AC,$03,$71,$11,$50,$20 ;; ?QPWZ?               ;
                      .db $87,$69,$81,$20,$01,$11,$10,$81 ;; ?QPWZ?               ;
                      .db $20,$00,$50,$81,$11,$01,$00,$02 ;; ?QPWZ?               ;
                      .db $82,$03,$05,$02,$01,$3D,$71,$8F ;; ?QPWZ?               ;
                      .db $9B,$81,$71,$01,$11,$44,$81,$43 ;; ?QPWZ?               ;
                      .db $00,$60,$83,$69,$04,$20,$69,$20 ;; ?QPWZ?               ;
                      .db $71,$3D,$81,$43,$81,$11,$02,$50 ;; ?QPWZ?               ;
                      .db $20,$11,$82,$43,$81,$11,$03,$00 ;; ?QPWZ?               ;
                      .db $11,$71,$AE,$83,$BC,$02,$AE,$11 ;; ?QPWZ?               ;
                      .db $00,$84,$69,$0A,$20,$50,$58,$4D ;; ?QPWZ?               ;
                      .db $43,$11,$71,$3D,$69,$20,$41,$82 ;; ?QPWZ?               ;
                      .db $69,$07,$41,$42,$20,$41,$42,$44 ;; ?QPWZ?               ;
                      .db $43,$44,$81,$43,$02,$44,$50,$20 ;; ?QPWZ?               ;
                      .db $83,$69,$0B,$20,$50,$11,$71,$3D ;; ?QPWZ?               ;
                      .db $20,$50,$43,$00,$69,$20,$42,$82 ;; ?QPWZ?               ;
                      .db $43,$02,$42,$41,$20,$81,$69,$00 ;; ?QPWZ?               ;
                      .db $20,$84,$69,$81,$20,$82,$69,$0B ;; ?QPWZ?               ;
                      .db $41,$42,$11,$58,$71,$4D,$69,$20 ;; ?QPWZ?               ;
                      .db $69,$20,$69,$20,$85,$73,$02,$20 ;; ?QPWZ?               ;
                      .db $69,$20,$84,$69,$02,$20,$69,$20 ;; ?QPWZ?               ;
                      .db $82,$43,$00,$11,$81,$58,$03,$71 ;; ?QPWZ?               ;
                      .db $58,$3D,$20,$81,$69,$03,$20,$69 ;; ?QPWZ?               ;
                      .db $50,$11,$83,$3F,$01,$11,$20,$81 ;; ?QPWZ?               ;
                      .db $69,$00,$20,$84,$69,$02,$20,$50 ;; ?QPWZ?               ;
                      .db $58,$81,$AC,$81,$89,$81,$58,$07 ;; ?QPWZ?               ;
                      .db $11,$00,$69,$20,$69,$20,$50,$11 ;; ?QPWZ?               ;
                      .db $84,$3F,$03,$11,$50,$69,$20,$84 ;; ?QPWZ?               ;
                      .db $69,$01,$20,$50,$81,$89,$81,$AC ;; ?QPWZ?               ;
                      .db $81,$99,$81,$89,$00,$3D,$81,$20 ;; ?QPWZ?               ;
                      .db $81,$69,$01,$20,$11,$86,$3F,$04 ;; ?QPWZ?               ;
                      .db $11,$42,$41,$20,$60,$83,$43,$00 ;; ?QPWZ?               ;
                      .db $11,$81,$99,$81,$AC,$81,$89,$81 ;; ?QPWZ?               ;
                      .db $99,$06,$3D,$20,$43,$50,$69,$50 ;; ?QPWZ?               ;
                      .db $11,$88,$3F,$03,$11,$43,$3D,$71 ;; ?QPWZ?               ;
                      .db $81,$89,$01,$71,$58,$81,$89,$81 ;; ?QPWZ?               ;
                      .db $8F,$09,$99,$98,$89,$71,$3D,$20 ;; ?QPWZ?               ;
                      .db $3F,$11,$43,$11,$8A,$3F,$02,$10 ;; ?QPWZ?               ;
                      .db $11,$58,$81,$99,$81,$89,$01,$99 ;; ?QPWZ?               ;
                      .db $98,$82,$89,$81,$99,$02,$58,$3D ;; ?QPWZ?               ;
                      .db $50,$82,$3F,$81,$10,$83,$3F,$81 ;; ?QPWZ?               ;
                      .db $10,$82,$3F,$01,$10,$11,$81,$89 ;; ?QPWZ?               ;
                      .db $04,$58,$89,$98,$99,$89,$82,$98 ;; ?QPWZ?               ;
                      .db $00,$99,$81,$89,$02,$58,$4D,$11 ;; ?QPWZ?               ;
                      .db $82,$03,$02,$11,$00,$11,$81,$3F ;; ?QPWZ?               ;
                      .db $00,$10,$81,$11,$82,$03,$04,$11 ;; ?QPWZ?               ;
                      .db $58,$99,$98,$89,$81,$99,$00,$89 ;; ?QPWZ?               ;
                      .db $83,$98,$00,$89,$81,$99,$02,$71 ;; ?QPWZ?               ;
                      .db $4D,$75,$82,$43,$81,$50,$02,$11 ;; ?QPWZ?               ;
                      .db $3F,$9C,$82,$43,$02,$11,$71,$58 ;; ?QPWZ?               ;
                      .db $82,$89,$01,$98,$99,$81,$89,$85 ;; ?QPWZ?               ;
                      .db $99,$00,$58,$81,$89,$01,$11,$10 ;; ?QPWZ?               ;
                      .db $81,$69,$81,$20,$82,$76,$00,$20 ;; ?QPWZ?               ;
                      .db $81,$69,$03,$20,$50,$11,$71,$82 ;; ?QPWZ?               ;
                      .db $99,$03,$98,$89,$99,$98,$86,$89 ;; ?QPWZ?               ;
                      .db $81,$99,$01,$58,$3D,$81,$69,$81 ;; ?QPWZ?               ;
                      .db $20,$82,$76,$00,$20,$82,$69,$03 ;; ?QPWZ?               ;
                      .db $20,$41,$42,$11,$81,$89,$81,$99 ;; ?QPWZ?               ;
                      .db $01,$89,$98,$81,$99,$81,$98,$82 ;; ?QPWZ?               ;
                      .db $99,$81,$89,$01,$58,$3D,$81,$69 ;; ?QPWZ?               ;
                      .db $81,$20,$82,$7D,$00,$20,$81,$69 ;; ?QPWZ?               ;
                      .db $00,$20,$82,$69,$00,$3D,$81,$99 ;; ?QPWZ?               ;
                      .db $81,$89,$01,$99,$98,$81,$89,$81 ;; ?QPWZ?               ;
                      .db $98,$06,$89,$3B,$89,$98,$99,$11 ;; ?QPWZ?               ;
                      .db $00,$81,$69,$05,$20,$50,$11,$3F ;; ?QPWZ?               ;
                      .db $11,$20,$82,$69,$00,$20,$81,$69 ;; ?QPWZ?               ;
                      .db $06,$3D,$71,$58,$99,$98,$89,$99 ;; ?QPWZ?               ;
                      .db $83,$98,$01,$99,$89,$81,$98,$02 ;; ?QPWZ?               ;
                      .db $89,$3D,$20,$82,$43,$00,$11,$81 ;; ?QPWZ?               ;
                      .db $3F,$00,$11,$83,$43,$03,$50,$41 ;; ?QPWZ?               ;
                      .db $42,$11,$82,$89,$82,$98,$82,$99 ;; ?QPWZ?               ;
                      .db $01,$98,$89,$83,$99,$01,$3D,$20 ;; ?QPWZ?               ;
                      .db $87,$75,$04,$08,$07,$06,$05,$11 ;; ?QPWZ?               ;
                      .db $81,$58,$84,$99,$00,$98,$82,$89 ;; ?QPWZ?               ;
                      .db $81,$99,$81,$89,$09,$58,$71,$3D ;; ?QPWZ?               ;
                      .db $20,$75,$11,$50,$20,$3D,$71,$81 ;; ?QPWZ?               ;
                      .db $AC,$01,$71,$11,$82,$03,$00,$11 ;; ?QPWZ?               ;
                      .db $81,$71,$01,$62,$63,$82,$71,$08 ;; ?QPWZ?               ;
                      .db $62,$63,$11,$2A,$69,$20,$69,$50 ;; ?QPWZ?               ;
                      .db $11,$83,$75,$05,$11,$20,$00,$11 ;; ?QPWZ?               ;
                      .db $8F,$9B,$84,$71,$00,$5D,$81,$68 ;; ?QPWZ?               ;
                      .db $00,$5D,$82,$71,$03,$58,$71,$11 ;; ?QPWZ?               ;
                      .db $50,$81,$20,$02,$41,$42,$11,$85 ;; ?QPWZ?               ;
                      .db $75,$06,$00,$43,$23,$30,$AE,$AF ;; ?QPWZ?               ;
                      .db $AD,$81,$8A,$01,$71,$5D,$81,$68 ;; ?QPWZ?               ;
                      .db $00,$5D,$83,$71,$05,$11,$50,$20 ;; ?QPWZ?               ;
                      .db $69,$2A,$11,$86,$75,$01,$10,$11 ;; ?QPWZ?               ;
                      .db $81,$71,$03,$11,$30,$8E,$AD,$81 ;; ?QPWZ?               ;
                      .db $8A,$01,$52,$53,$81,$71,$81,$58 ;; ?QPWZ?               ;
                      .db $03,$71,$58,$11,$50,$81,$69,$01 ;; ?QPWZ?               ;
                      .db $20,$3A,$81,$75,$01,$A6,$A7,$83 ;; ?QPWZ?               ;
                      .db $75,$01,$00,$11,$81,$71,$03,$11 ;; ?QPWZ?               ;
                      .db $00,$52,$53,$81,$AC,$02,$62,$63 ;; ?QPWZ?               ;
                      .db $71,$81,$58,$03,$11,$43,$42,$41 ;; ?QPWZ?               ;
                      .db $81,$69,$08,$20,$50,$11,$A6,$A7 ;; ?QPWZ?               ;
                      .db $B6,$B7,$A6,$A7,$81,$75,$01,$20 ;; ?QPWZ?               ;
                      .db $50,$81,$43,$03,$50,$20,$62,$63 ;; ?QPWZ?               ;
                      .db $81,$AC,$00,$71,$81,$58,$03,$71 ;; ?QPWZ?               ;
                      .db $11,$50,$20,$83,$69,$04,$50,$11 ;; ?QPWZ?               ;
                      .db $75,$B6,$B7,$81,$3F,$01,$B6,$B7 ;; ?QPWZ?               ;
                      .db $81,$75,$01,$20,$69,$81,$3E,$0C ;; ?QPWZ?               ;
                      .db $69,$20,$42,$44,$43,$44,$43,$44 ;; ?QPWZ?               ;
                      .db $43,$42,$41,$69,$20,$82,$69,$03 ;; ?QPWZ?               ;
                      .db $50,$11,$A6,$A7,$85,$3F,$81,$75 ;; ?QPWZ?               ;
                      .db $01,$20,$69,$81,$3E,$00,$69,$82 ;; ?QPWZ?               ;
                      .db $20,$84,$69,$00,$20,$81,$69,$00 ;; ?QPWZ?               ;
                      .db $20,$81,$69,$04,$50,$11,$75,$B6 ;; ?QPWZ?               ;
                      .db $B7,$85,$3F,$81,$75,$01,$20,$69 ;; ?QPWZ?               ;
                      .db $81,$3E,$03,$69,$20,$69,$20,$83 ;; ?QPWZ?               ;
                      .db $69,$00,$20,$82,$69,$05,$20,$41 ;; ?QPWZ?               ;
                      .db $42,$11,$A6,$A7,$87,$3F,$81,$75 ;; ?QPWZ?               ;
                      .db $01,$20,$69,$81,$3E,$00,$69,$81 ;; ?QPWZ?               ;
                      .db $20,$85,$69,$04,$20,$69,$50,$43 ;; ?QPWZ?               ;
                      .db $11,$81,$75,$01,$B6,$B7,$87,$3F ;; ?QPWZ?               ;
                      .db $81,$75,$01,$20,$69,$81,$3E,$03 ;; ?QPWZ?               ;
                      .db $69,$20,$41,$20,$83,$69,$03,$20 ;; ?QPWZ?               ;
                      .db $41,$42,$11,$83,$75,$01,$A6,$A7 ;; ?QPWZ?               ;
                      .db $87,$3F,$81,$75,$01,$20,$69,$81 ;; ?QPWZ?               ;
                      .db $3E,$02,$69,$20,$11,$85,$43,$00 ;; ?QPWZ?               ;
                      .db $11,$85,$75,$01,$B6,$B7,$87,$3F ;; ?QPWZ?               ;
                      .db $81,$75,$01,$20,$69,$81,$3E,$08 ;; ?QPWZ?               ;
                      .db $69,$20,$03,$04,$03,$04,$03,$02 ;; ?QPWZ?               ;
                      .db $01,$87,$75,$01,$A6,$A7,$86,$3F ;; ?QPWZ?               ;
                      .db $03,$75,$10,$20,$C2,$81,$C3,$03 ;; ?QPWZ?               ;
                      .db $C2,$20,$56,$57,$82,$71,$02,$56 ;; ?QPWZ?               ;
                      .db $57,$10,$86,$75,$03,$B6,$B7,$A6 ;; ?QPWZ?               ;
                      .db $A7,$83,$3F,$04,$A6,$75,$4D,$50 ;; ?QPWZ?               ;
                      .db $D2,$81,$D3,$03,$D2,$50,$9E,$9F ;; ?QPWZ?               ;
                      .db $82,$71,$02,$9E,$9F,$3D,$88,$75 ;; ?QPWZ?               ;
                      .db $0A,$B6,$B7,$3F,$A6,$A7,$3F,$B6 ;; ?QPWZ?               ;
                      .db $75,$3D,$11,$20,$81,$3E,$03,$20 ;; ?QPWZ?               ;
                      .db $11,$9E,$9F,$82,$71,$02,$64,$65 ;; ?QPWZ?               ;
                      .db $4D,$8B,$75,$01,$B6,$B7,$82,$75 ;; ?QPWZ?               ;
                      .db $02,$4D,$11,$50,$81,$3E,$05,$50 ;; ?QPWZ?               ;
                      .db $11,$9E,$9F,$56,$57,$81,$71,$01 ;; ?QPWZ?               ;
                      .db $58,$3D,$90,$75,$02,$3D,$58,$11 ;; ?QPWZ?               ;
                      .db $81,$43,$06,$11,$58,$64,$65,$9E ;; ?QPWZ?               ;
                      .db $9F,$71,$81,$58,$00,$3D,$83,$75 ;; ?QPWZ?               ;
                      .db $81,$60,$8A,$75,$00,$00,$81,$43 ;; ?QPWZ?               ;
                      .db $00,$11,$83,$71,$03,$58,$64,$65 ;; ?QPWZ?               ;
                      .db $11,$81,$43,$00,$00,$83,$75,$02 ;; ?QPWZ?               ;
                      .db $3D,$11,$60,$83,$75,$02,$60,$03 ;; ?QPWZ?               ;
                      .db $60,$82,$75,$81,$20,$01,$69,$3D ;; ?QPWZ?               ;
                      .db $86,$71,$00,$3D,$81,$69,$00,$20 ;; ?QPWZ?               ;
                      .db $83,$75,$00,$60,$81,$11,$00,$60 ;; ?QPWZ?               ;
                      .db $81,$75,$03,$60,$11,$A6,$A7,$81 ;; ?QPWZ?               ;
                      .db $03,$00,$75,$81,$20,$01,$69,$00 ;; ?QPWZ?               ;
                      .db $81,$43,$05,$44,$43,$44,$43,$44 ;; ?QPWZ?               ;
                      .db $00,$81,$69,$00,$20,$83,$75,$03 ;; ?QPWZ?               ;
                      .db $20,$3D,$A6,$A7,$81,$03,$06,$11 ;; ?QPWZ?               ;
                      .db $A6,$A9,$B7,$A6,$A7,$11,$81,$20 ;; ?QPWZ?               ;
                      .db $00,$69,$81,$20,$84,$69,$81,$20 ;; ?QPWZ?               ;
                      .db $81,$69,$01,$20,$11,$82,$75,$03 ;; ?QPWZ?               ;
                      .db $60,$11,$B6,$B7,$82,$71,$08,$B6 ;; ?QPWZ?               ;
                      .db $A8,$A7,$B6,$A8,$11,$50,$20,$69 ;; ?QPWZ?               ;
                      .db $81,$20,$84,$69,$81,$20,$81,$69 ;; ?QPWZ?               ;
                      .db $01,$50,$11,$81,$75,$01,$60,$11 ;; ?QPWZ?               ;
                      .db $84,$71,$07,$A6,$A7,$B6,$B7,$71 ;; ?QPWZ?               ;
                      .db $B6,$75,$11,$81,$43,$81,$20,$84 ;; ?QPWZ?               ;
                      .db $69,$81,$20,$81,$43,$00,$11,$82 ;; ?QPWZ?               ;
                      .db $75,$02,$60,$11,$58,$83,$71,$02 ;; ?QPWZ?               ;
                      .db $B6,$B7,$58,$82,$71,$82,$75,$02 ;; ?QPWZ?               ;
                      .db $11,$50,$20,$84,$69,$02,$20,$50 ;; ?QPWZ?               ;
                      .db $11,$84,$75,$0C,$20,$3D,$58,$A6 ;; ?QPWZ?               ;
                      .db $A7,$A6,$A7,$A6,$A7,$A6,$A7,$A6 ;; ?QPWZ?               ;
                      .db $A7,$83,$75,$00,$11,$86,$43,$00 ;; ?QPWZ?               ;
                      .db $11,$85,$75,$0C,$60,$11,$A6,$A9 ;; ?QPWZ?               ;
                      .db $B7,$B6,$B7,$B6,$B7,$B6,$B7,$B6 ;; ?QPWZ?               ;
                      .db $B7,$92,$75,$04,$60,$11,$B6,$A8 ;; ?QPWZ?               ;
                      .db $A7,$81,$71,$05,$A6,$A7,$A6,$A7 ;; ?QPWZ?               ;
                      .db $A6,$A7,$8D,$75,$11,$A6,$A7,$75 ;; ?QPWZ?               ;
                      .db $A6,$A7,$20,$60,$11,$B6,$A8,$A7 ;; ?QPWZ?               ;
                      .db $71,$B6,$B7,$B6,$B7,$B6,$B7,$8D ;; ?QPWZ?               ;
                      .db $75,$04,$B6,$B7,$A6,$A9,$B7,$81 ;; ?QPWZ?               ;
                      .db $20,$05,$60,$11,$B6,$B7,$11,$43 ;; ?QPWZ?               ;
                      .db $81,$11,$81,$43,$00,$11,$8C,$75 ;; ?QPWZ?               ;
                      .db $05,$A6,$A7,$A6,$A9,$B7,$3F,$82 ;; ?QPWZ?               ;
                      .db $20,$00,$60,$81,$43,$01,$60,$69 ;; ?QPWZ?               ;
                      .db $81,$3D,$81,$69,$00,$3D,$89,$75 ;; ?QPWZ?               ;
                      .db $08,$A6,$A7,$75,$B6,$B7,$B6,$B7 ;; ?QPWZ?               ;
                      .db $A6,$A7,$83,$20,$81,$69,$01,$20 ;; ?QPWZ?               ;
                      .db $69,$81,$60,$81,$69,$00,$60,$89 ;; ?QPWZ?               ;
                      .db $75,$01,$B6,$B7,$84,$75,$02,$B6 ;; ?QPWZ?               ;
                      .db $B7,$43,$82,$20,$81,$69,$01,$20 ;; ?QPWZ?               ;
                      .db $69,$81,$20,$81,$69,$00,$20,$86 ;; ?QPWZ?               ;
                      .db $75,$04,$10,$11,$71,$58,$6E,$82 ;; ?QPWZ?               ;
                      .db $6B,$83,$AD,$01,$8E,$99,$81,$98 ;; ?QPWZ?               ;
                      .db $00,$99,$81,$8F,$05,$99,$98,$89 ;; ?QPWZ?               ;
                      .db $58,$3D,$50,$86,$75,$03,$3D,$71 ;; ?QPWZ?               ;
                      .db $58,$71,$83,$68,$83,$AD,$01,$8E ;; ?QPWZ?               ;
                      .db $89,$81,$98,$00,$89,$81,$AC,$05 ;; ?QPWZ?               ;
                      .db $89,$98,$99,$11,$00,$11,$86,$75 ;; ?QPWZ?               ;
                      .db $04,$4D,$58,$71,$58,$5D,$81,$68 ;; ?QPWZ?               ;
                      .db $00,$5D,$84,$89,$82,$98,$00,$99 ;; ?QPWZ?               ;
                      .db $81,$AC,$81,$99,$02,$11,$50,$20 ;; ?QPWZ?               ;
                      .db $87,$75,$03,$3D,$71,$00,$50,$81 ;; ?QPWZ?               ;
                      .db $43,$81,$71,$87,$99,$02,$71,$9B ;; ?QPWZ?               ;
                      .db $8F,$81,$89,$02,$3D,$69,$20,$87 ;; ?QPWZ?               ;
                      .db $75,$01,$4D,$3D,$81,$50,$81,$20 ;; ?QPWZ?               ;
                      .db $02,$50,$71,$6E,$82,$6B,$83,$AD ;; ?QPWZ?               ;
                      .db $08,$AF,$AE,$89,$98,$99,$3D,$69 ;; ?QPWZ?               ;
                      .db $20,$11,$86,$75,$03,$00,$11,$10 ;; ?QPWZ?               ;
                      .db $11,$81,$43,$01,$50,$3D,$83,$68 ;; ?QPWZ?               ;
                      .db $83,$AD,$0A,$8E,$89,$98,$99,$11 ;; ?QPWZ?               ;
                      .db $00,$69,$50,$11,$A6,$A7,$84,$75 ;; ?QPWZ?               ;
                      .db $03,$20,$50,$11,$10,$81,$3F,$02 ;; ?QPWZ?               ;
                      .db $11,$3D,$5D,$81,$68,$01,$5D,$58 ;; ?QPWZ?               ;
                      .db $82,$89,$00,$98,$81,$99,$07,$71 ;; ?QPWZ?               ;
                      .db $3A,$20,$50,$11,$75,$B6,$B7,$84 ;; ?QPWZ?               ;
                      .db $75,$04,$20,$69,$50,$11,$03,$81 ;; ?QPWZ?               ;
                      .db $10,$01,$58,$71,$81,$AC,$01,$58 ;; ?QPWZ?               ;
                      .db $89,$82,$98,$00,$99,$81,$71,$03 ;; ?QPWZ?               ;
                      .db $11,$2A,$20,$11,$81,$75,$81,$3F ;; ?QPWZ?               ;
                      .db $01,$A6,$A7,$81,$75,$01,$11,$20 ;; ?QPWZ?               ;
                      .db $81,$69,$00,$50,$82,$11,$01,$71 ;; ?QPWZ?               ;
                      .db $58,$81,$AC,$00,$71,$83,$99,$03 ;; ?QPWZ?               ;
                      .db $71,$11,$42,$41,$81,$20,$00,$11 ;; ?QPWZ?               ;
                      .db $81,$75,$81,$3F,$01,$B6,$B7,$81 ;; ?QPWZ?               ;
                      .db $75,$01,$11,$50,$82,$69,$01,$41 ;; ?QPWZ?               ;
                      .db $42,$89,$43,$06,$42,$41,$69,$20 ;; ?QPWZ?               ;
                      .db $69,$50,$11,$81,$75,$81,$3F,$01 ;; ?QPWZ?               ;
                      .db $A6,$A7,$82,$75,$01,$11,$50,$83 ;; ?QPWZ?               ;
                      .db $69,$00,$20,$87,$69,$00,$20,$82 ;; ?QPWZ?               ;
                      .db $69,$02,$20,$2A,$11,$82,$75,$81 ;; ?QPWZ?               ;
                      .db $3F,$01,$B6,$B7,$83,$75,$00,$60 ;; ?QPWZ?               ;
                      .db $83,$43,$02,$50,$69,$50,$81,$43 ;; ?QPWZ?               ;
                      .db $00,$50,$83,$69,$00,$20,$81,$69 ;; ?QPWZ?               ;
                      .db $01,$20,$3A,$83,$75,$02,$3F,$A6 ;; ?QPWZ?               ;
                      .db $A7,$84,$75,$00,$3D,$82,$71,$03 ;; ?QPWZ?               ;
                      .db $AD,$DA,$69,$DA,$81,$8A,$00,$3D ;; ?QPWZ?               ;
                      .db $82,$69,$00,$20,$82,$69,$01,$50 ;; ?QPWZ?               ;
                      .db $11,$83,$75,$02,$A7,$B6,$B7,$84 ;; ?QPWZ?               ;
                      .db $75,$01,$3D,$58,$81,$71,$03,$AD ;; ?QPWZ?               ;
                      .db $DA,$69,$DA,$81,$8A,$00,$3D,$81 ;; ?QPWZ?               ;
                      .db $69,$07,$50,$43,$50,$41,$42,$10 ;; ?QPWZ?               ;
                      .db $03,$10,$82,$75,$00,$B7,$81,$75 ;; ?QPWZ?               ;
                      .db $02,$60,$03,$60,$81,$75,$07,$60 ;; ?QPWZ?               ;
                      .db $11,$A6,$A7,$58,$3D,$43,$00,$81 ;; ?QPWZ?               ;
                      .db $43,$00,$00,$81,$43,$07,$00,$43 ;; ?QPWZ?               ;
                      .db $00,$11,$75,$00,$43,$00,$85,$75 ;; ?QPWZ?               ;
                      .db $0B,$3D,$71,$11,$03,$60,$20,$3D ;; ?QPWZ?               ;
                      .db $B6,$B7,$11,$60,$75,$83,$20,$81 ;; ?QPWZ?               ;
                      .db $75,$82,$20,$81,$75,$02,$20,$69 ;; ?QPWZ?               ;
                      .db $20,$85,$75,$0B,$3D,$A6,$A7,$A6 ;; ?QPWZ?               ;
                      .db $A7,$43,$11,$A6,$A7,$3D,$20,$75 ;; ?QPWZ?               ;
                      .db $83,$20,$81,$75,$82,$20,$81,$75 ;; ?QPWZ?               ;
                      .db $02,$20,$69,$20,$82,$75,$00,$60 ;; ?QPWZ?               ;
                      .db $81,$03,$0B,$A6,$A9,$A8,$A9,$B7 ;; ?QPWZ?               ;
                      .db $71,$58,$B6,$B7,$3D,$20,$11,$83 ;; ?QPWZ?               ;
                      .db $20,$01,$11,$75,$82,$20,$05,$75 ;; ?QPWZ?               ;
                      .db $11,$20,$69,$20,$11,$81,$75,$0F ;; ?QPWZ?               ;
                      .db $3D,$A6,$A7,$B6,$B7,$B6,$A8,$A7 ;; ?QPWZ?               ;
                      .db $A6,$A7,$A6,$A7,$3D,$20,$11,$50 ;; ?QPWZ?               ;
                      .db $81,$20,$00,$50,$81,$11,$82,$20 ;; ?QPWZ?               ;
                      .db $81,$11,$03,$50,$69,$50,$11,$81 ;; ?QPWZ?               ;
                      .db $75,$0F,$11,$B6,$B7,$A6,$A7,$71 ;; ?QPWZ?               ;
                      .db $B6,$A8,$A9,$B7,$B6,$B7,$11,$60 ;; ?QPWZ?               ;
                      .db $75,$11,$81,$43,$0A,$11,$75,$11 ;; ?QPWZ?               ;
                      .db $50,$20,$50,$11,$75,$11,$43,$11 ;; ?QPWZ?               ;
                      .db $82,$75,$0D,$58,$A6,$A7,$B6,$A8 ;; ?QPWZ?               ;
                      .db $A7,$A6,$A9,$A8,$A7,$A6,$A7,$71 ;; ?QPWZ?               ;
                      .db $11,$81,$03,$00,$60,$83,$75,$02 ;; ?QPWZ?               ;
                      .db $11,$43,$11,$87,$75,$11,$A7,$B6 ;; ?QPWZ?               ;
                      .db $B7,$71,$B6,$B7,$B6,$B7,$B6,$A8 ;; ?QPWZ?               ;
                      .db $A9,$A8,$A7,$71,$A6,$A7,$11,$60 ;; ?QPWZ?               ;
                      .db $8D,$75,$13,$A8,$A7,$A6,$A7,$A6 ;; ?QPWZ?               ;
                      .db $A7,$A6,$A7,$A6,$A9,$B7,$B6,$A8 ;; ?QPWZ?               ;
                      .db $A7,$B6,$A8,$A7,$11,$03,$60,$8B ;; ?QPWZ?               ;
                      .db $75,$13,$B6,$B7,$B6,$B7,$B6,$B7 ;; ?QPWZ?               ;
                      .db $B6,$B7,$B6,$B7,$A6,$A7,$B6,$B7 ;; ?QPWZ?               ;
                      .db $71,$B6,$A8,$A7,$11,$60,$81,$75 ;; ?QPWZ?               ;
                      .db $01,$A6,$A7,$87,$75,$17,$A6,$A7 ;; ?QPWZ?               ;
                      .db $A6,$A7,$A6,$A7,$A6,$A7,$A6,$A7 ;; ?QPWZ?               ;
                      .db $B6,$B7,$A6,$A7,$71,$A6,$A9,$B7 ;; ?QPWZ?               ;
                      .db $3D,$20,$75,$A6,$A9,$B7,$87,$75 ;; ?QPWZ?               ;
                      .db $16,$B6,$A8,$A9,$B7,$B6,$B7,$B6 ;; ?QPWZ?               ;
                      .db $B7,$B6,$A8,$A7,$A6,$A9,$A8,$A7 ;; ?QPWZ?               ;
                      .db $B6,$A8,$A7,$11,$60,$75,$B6,$B7 ;; ?QPWZ?               ;
                      .db $88,$75,$13,$A6,$A9,$B7,$A6,$A7 ;; ?QPWZ?               ;
                      .db $A6,$A7,$A6,$A7,$B6,$B7,$B6,$B7 ;; ?QPWZ?               ;
                      .db $B6,$B7,$A6,$A9,$B7,$11,$60,$8B ;; ?QPWZ?               ;
                      .db $75,$09,$B6,$B7,$A6,$A9,$A8,$A9 ;; ?QPWZ?               ;
                      .db $A8,$A9,$B7,$11,$83,$43,$07,$11 ;; ?QPWZ?               ;
                      .db $B6,$B7,$11,$60,$20,$A6,$A7,$82 ;; ?QPWZ?               ;
                      .db $75,$01,$A6,$A7,$84,$75,$09,$A6 ;; ?QPWZ?               ;
                      .db $A7,$B6,$B7,$B6,$B7,$B6,$B7,$58 ;; ?QPWZ?               ;
                      .db $3D,$83,$69,$00,$60,$81,$11,$00 ;; ?QPWZ?               ;
                      .db $60,$81,$20,$06,$B6,$A8,$A7,$A6 ;; ?QPWZ?               ;
                      .db $A7,$B6,$B7,$84,$75,$01,$B6,$B7 ;; ?QPWZ?               ;
                      .db $81,$43,$81,$11,$03,$43,$11,$71 ;; ?QPWZ?               ;
                      .db $3D,$83,$69,$00,$20,$81,$60,$82 ;; ?QPWZ?               ;
                      .db $20,$04,$3F,$B6,$A8,$A9,$B7,$86 ;; ?QPWZ?               ;
                      .db $75,$01,$43,$60,$81,$69,$81,$60 ;; ?QPWZ?               ;
                      .db $03,$69,$3D,$58,$3D,$83,$69,$85 ;; ?QPWZ?               ;
                      .db $20,$03,$A6,$A7,$B6,$B7,$87,$75 ;; ?QPWZ?               ;
                      .db $01,$69,$20,$81,$69,$81,$20,$03 ;; ?QPWZ?               ;
                      .db $69,$60,$43,$60,$83,$69,$84,$20 ;; ?QPWZ?               ;
                      .db $02,$43,$B6,$B7,$89,$75,$83,$75 ;; ?QPWZ?               ;
                      .db $03,$20,$69,$20,$B8,$81,$B9,$06 ;; ?QPWZ?               ;
                      .db $B8,$20,$69,$20,$75,$54,$55,$8C ;; ?QPWZ?               ;
                      .db $75,$81,$4F,$83,$75,$03,$20,$69 ;; ?QPWZ?               ;
                      .db $20,$B8,$81,$B9,$06,$B8,$20,$69 ;; ?QPWZ?               ;
                      .db $20,$04,$9E,$9F,$82,$03,$04,$05 ;; ?QPWZ?               ;
                      .db $06,$07,$54,$55,$84,$75,$81,$4F ;; ?QPWZ?               ;
                      .db $81,$75,$05,$54,$55,$20,$69,$20 ;; ?QPWZ?               ;
                      .db $B8,$81,$B9,$07,$B8,$20,$69,$20 ;; ?QPWZ?               ;
                      .db $71,$9E,$9F,$71,$81,$AC,$04,$71 ;; ?QPWZ?               ;
                      .db $56,$57,$9E,$9F,$84,$75,$81,$4F ;; ?QPWZ?               ;
                      .db $81,$75,$05,$9E,$9F,$20,$C6,$C7 ;; ?QPWZ?               ;
                      .db $C8,$81,$C9,$07,$C8,$C7,$C6,$20 ;; ?QPWZ?               ;
                      .db $71,$9E,$9F,$71,$81,$AC,$04,$71 ;; ?QPWZ?               ;
                      .db $64,$65,$9E,$9F,$84,$75,$81,$4F ;; ?QPWZ?               ;
                      .db $81,$75,$05,$9E,$9F,$20,$D6,$D7 ;; ?QPWZ?               ;
                      .db $AA,$81,$AB,$07,$AA,$D7,$D6,$20 ;; ?QPWZ?               ;
                      .db $11,$9E,$67,$57,$81,$AC,$82,$71 ;; ?QPWZ?               ;
                      .db $02,$64,$67,$55,$83,$75,$81,$4F ;; ?QPWZ?               ;
                      .db $07,$75,$0A,$9E,$9F,$50,$E6,$E7 ;; ?QPWZ?               ;
                      .db $AA,$81,$AB,$07,$AA,$E7,$E6,$50 ;; ?QPWZ?               ;
                      .db $11,$64,$9E,$9F,$81,$71,$81,$BC ;; ?QPWZ?               ;
                      .db $04,$AE,$71,$64,$65,$0A,$82,$75 ;; ?QPWZ?               ;
                      .db $81,$4F,$07,$75,$1A,$64,$65,$11 ;; ?QPWZ?               ;
                      .db $50,$F7,$F8,$81,$F9,$10,$F8,$F7 ;; ?QPWZ?               ;
                      .db $50,$11,$71,$56,$66,$9F,$71,$53 ;; ?QPWZ?               ;
                      .db $52,$71,$9B,$8F,$52,$53,$1A,$82 ;; ?QPWZ?               ;
                      .db $75,$81,$4F,$02,$75,$00,$11,$81 ;; ?QPWZ?               ;
                      .db $71,$02,$11,$20,$B8,$81,$B9,$0B ;; ?QPWZ?               ;
                      .db $B8,$20,$11,$56,$57,$9E,$9F,$67 ;; ?QPWZ?               ;
                      .db $57,$63,$51,$52,$81,$AC,$02,$62 ;; ?QPWZ?               ;
                      .db $63,$3D,$82,$75,$81,$4F,$07,$75 ;; ?QPWZ?               ;
                      .db $20,$3D,$56,$57,$11,$20,$B8,$81 ;; ?QPWZ?               ;
                      .db $B9,$0B,$B8,$20,$11,$9E,$67,$66 ;; ?QPWZ?               ;
                      .db $9F,$9E,$9F,$3C,$63,$62,$81,$8A ;; ?QPWZ?               ;
                      .db $02,$71,$11,$00,$82,$75,$81,$4F ;; ?QPWZ?               ;
                      .db $07,$75,$20,$3D,$64,$65,$11,$50 ;; ?QPWZ?               ;
                      .db $B8,$81,$B9,$02,$B8,$50,$11,$81 ;; ?QPWZ?               ;
                      .db $9E,$06,$9F,$67,$66,$9F,$58,$52 ;; ?QPWZ?               ;
                      .db $53,$81,$8A,$02,$11,$50,$20,$82 ;; ?QPWZ?               ;
                      .db $75,$81,$4F,$07,$11,$20,$3D,$71 ;; ?QPWZ?               ;
                      .db $BF,$71,$11,$43,$81,$AC,$0B,$43 ;; ?QPWZ?               ;
                      .db $56,$57,$64,$9E,$9F,$9E,$9F,$65 ;; ?QPWZ?               ;
                      .db $58,$62,$63,$81,$AC,$02,$11,$50 ;; ?QPWZ?               ;
                      .db $20,$82,$75,$81,$4F,$11,$11,$50 ;; ?QPWZ?               ;
                      .db $3D,$BD,$BA,$BD,$BF,$71,$9B,$8F ;; ?QPWZ?               ;
                      .db $58,$64,$65,$71,$64,$65,$9E,$9F ;; ?QPWZ?               ;
                      .db $81,$58,$07,$3C,$58,$9B,$8F,$58 ;; ?QPWZ?               ;
                      .db $3D,$20,$11,$81,$75,$81,$4F,$08 ;; ?QPWZ?               ;
                      .db $75,$11,$3D,$BF,$BD,$BF,$71,$8F ;; ?QPWZ?               ;
                      .db $9B,$81,$58,$84,$2C,$01,$9E,$9F ;; ?QPWZ?               ;
                      .db $81,$8A,$07,$AD,$AF,$AE,$58,$3C ;; ?QPWZ?               ;
                      .db $3D,$50,$11,$81,$75,$81,$4F,$81 ;; ?QPWZ?               ;
                      .db $75,$09,$4D,$BA,$BF,$BD,$71,$9B ;; ?QPWZ?               ;
                      .db $8F,$58,$71,$2C,$82,$71,$02,$2C ;; ?QPWZ?               ;
                      .db $9E,$9F,$81,$8A,$06,$AD,$8E,$58 ;; ?QPWZ?               ;
                      .db $3C,$58,$4D,$11,$82,$75,$81,$43 ;; ?QPWZ?               ;
                      .db $81,$75,$08,$40,$42,$43,$11,$8F ;; ?QPWZ?               ;
                      .db $9B,$56,$57,$2C,$83,$71,$02,$2C ;; ?QPWZ?               ;
                      .db $9E,$9F,$81,$AC,$81,$58,$03,$43 ;; ?QPWZ?               ;
                      .db $44,$42,$40,$83,$75,$81,$69,$81 ;; ?QPWZ?               ;
                      .db $75,$00,$20,$81,$69,$00,$3D,$81 ;; ?QPWZ?               ;
                      .db $AC,$03,$64,$65,$6E,$5D,$81,$68 ;; ?QPWZ?               ;
                      .db $03,$5D,$6E,$64,$65,$81,$AC,$01 ;; ?QPWZ?               ;
                      .db $3C,$3D,$82,$69,$00,$20,$83,$75 ;; ?QPWZ?               ;
                      .db $81,$69,$81,$75,$00,$20,$81,$69 ;; ?QPWZ?               ;
                      .db $00,$3D,$81,$5D,$00,$6B,$81,$6D ;; ?QPWZ?               ;
                      .db $83,$6B,$81,$6D,$00,$6B,$81,$5D ;; ?QPWZ?               ;
                      .db $01,$58,$3D,$82,$69,$00,$20,$83 ;; ?QPWZ?               ;
                      .db $75,$81,$69,$02,$75,$11,$20,$81 ;; ?QPWZ?               ;
                      .db $69,$00,$3D,$81,$5D,$01,$6B,$6E ;; ?QPWZ?               ;
                      .db $84,$2C,$02,$71,$6E,$6B,$81,$5D ;; ?QPWZ?               ;
                      .db $01,$71,$3D,$82,$69,$01,$20,$11 ;; ?QPWZ?               ;
                      .db $82,$75,$81,$69,$09,$75,$11,$42 ;; ?QPWZ?               ;
                      .db $41,$69,$00,$43,$44,$43,$44,$81 ;; ?QPWZ?               ;
                      .db $43,$81,$44,$81,$43,$05,$44,$43 ;; ?QPWZ?               ;
                      .db $44,$43,$44,$00,$81,$69,$02,$41 ;; ?QPWZ?               ;
                      .db $42,$11,$82,$75,$81,$69,$82,$75 ;; ?QPWZ?               ;
                      .db $01,$11,$43,$81,$20,$8C,$69,$81 ;; ?QPWZ?               ;
                      .db $20,$81,$43,$00,$11,$84,$75,$81 ;; ?QPWZ?               ;
                      .db $69,$84,$75,$81,$20,$8C,$69,$81 ;; ?QPWZ?               ;
                      .db $20,$87,$75,$82,$69,$81,$20,$00 ;; ?QPWZ?               ;
                      .db $3D,$85,$71,$04,$3D,$69,$20,$69 ;; ?QPWZ?               ;
                      .db $20,$84,$69,$02,$20,$69,$20,$81 ;; ?QPWZ?               ;
                      .db $69,$81,$20,$82,$69,$81,$71,$81 ;; ?QPWZ?               ;
                      .db $20,$01,$69,$3D,$85,$71,$02,$3D ;; ?QPWZ?               ;
                      .db $69,$20,$81,$69,$00,$00,$83,$43 ;; ?QPWZ?               ;
                      .db $02,$46,$47,$48,$81,$20,$81,$69 ;; ?QPWZ?               ;
                      .db $00,$20,$81,$69,$81,$71,$81,$20 ;; ?QPWZ?               ;
                      .db $02,$2A,$00,$11,$83,$71,$06,$11 ;; ?QPWZ?               ;
                      .db $00,$2A,$69,$20,$2A,$11,$85,$71 ;; ?QPWZ?               ;
                      .db $02,$11,$42,$41,$81,$20,$82,$69 ;; ?QPWZ?               ;
                      .db $81,$71,$81,$20,$03,$3A,$20,$40 ;; ?QPWZ?               ;
                      .db $42,$81,$43,$07,$42,$40,$20,$3A ;; ?QPWZ?               ;
                      .db $20,$69,$3A,$71,$81,$8A,$83,$AD ;; ?QPWZ?               ;
                      .db $04,$8E,$71,$11,$50,$20,$82,$69 ;; ?QPWZ?               ;
                      .db $81,$71,$02,$69,$00,$11,$82,$20 ;; ?QPWZ?               ;
                      .db $81,$69,$82,$20,$04,$3D,$20,$69 ;; ?QPWZ?               ;
                      .db $3D,$71,$81,$8A,$83,$AD,$81,$AF ;; ?QPWZ?               ;
                      .db $03,$8E,$11,$50,$20,$81,$69,$81 ;; ?QPWZ?               ;
                      .db $71,$00,$43,$81,$11,$00,$50,$81 ;; ?QPWZ?               ;
                      .db $20,$81,$69,$81,$20,$01,$50,$3D ;; ?QPWZ?               ;
                      .db $81,$43,$00,$3D,$87,$71,$04,$8E ;; ?QPWZ?               ;
                      .db $8A,$8F,$11,$0F,$81,$69,$81,$71 ;; ?QPWZ?               ;
                      .db $05,$A6,$A7,$3C,$11,$42,$40,$81 ;; ?QPWZ?               ;
                      .db $69,$03,$40,$42,$11,$00,$81,$71 ;; ?QPWZ?               ;
                      .db $01,$40,$42,$83,$43,$00,$11,$82 ;; ?QPWZ?               ;
                      .db $71,$81,$AC,$01,$71,$1F,$81,$69 ;; ?QPWZ?               ;
                      .db $81,$71,$05,$B6,$B7,$A6,$A7,$3C ;; ?QPWZ?               ;
                      .db $11,$81,$43,$81,$11,$04,$00,$20 ;; ?QPWZ?               ;
                      .db $71,$11,$20,$84,$69,$03,$40,$42 ;; ?QPWZ?               ;
                      .db $11,$71,$81,$8A,$01,$71,$2F,$81 ;; ?QPWZ?               ;
                      .db $69,$81,$71,$04,$A6,$A7,$B6,$B7 ;; ?QPWZ?               ;
                      .db $11,$82,$43,$01,$42,$40,$81,$20 ;; ?QPWZ?               ;
                      .db $02,$11,$50,$20,$83,$69,$04,$20 ;; ?QPWZ?               ;
                      .db $69,$20,$50,$11,$81,$8A,$01,$71 ;; ?QPWZ?               ;
                      .db $11,$83,$71,$04,$B6,$B7,$3C,$11 ;; ?QPWZ?               ;
                      .db $00,$83,$69,$82,$20,$02,$3D,$50 ;; ?QPWZ?               ;
                      .db $20,$84,$69,$03,$20,$69,$20,$3D ;; ?QPWZ?               ;
                      .db $81,$AC,$85,$71,$81,$3C,$02,$11 ;; ?QPWZ?               ;
                      .db $50,$20,$84,$69,$05,$20,$00,$3D ;; ?QPWZ?               ;
                      .db $11,$42,$41,$82,$69,$04,$20,$69 ;; ?QPWZ?               ;
                      .db $20,$69,$3D,$81,$AC,$85,$71,$03 ;; ?QPWZ?               ;
                      .db $4F,$3C,$4F,$3C,$81,$4F,$00,$3D ;; ?QPWZ?               ;
                      .db $96,$3F,$81,$75,$83,$4F,$81,$3C ;; ?QPWZ?               ;
                      .db $01,$11,$0A,$95,$3F,$81,$75,$81 ;; ?QPWZ?               ;
                      .db $8A,$81,$AD,$81,$4F,$01,$3C,$1A ;; ?QPWZ?               ;
                      .db $95,$3F,$81,$75,$81,$8A,$81,$AD ;; ?QPWZ?               ;
                      .db $03,$4F,$3C,$4F,$3D,$8E,$3F,$00 ;; ?QPWZ?               ;
                      .db $0A,$81,$03,$01,$02,$01,$81,$3F ;; ?QPWZ?               ;
                      .db $81,$75,$81,$AC,$81,$4F,$03,$11 ;; ?QPWZ?               ;
                      .db $43,$42,$40,$8E,$3F,$00,$1A,$81 ;; ?QPWZ?               ;
                      .db $4F,$01,$3C,$11,$81,$23,$81,$75 ;; ?QPWZ?               ;
                      .db $81,$AC,$81,$4F,$00,$3A,$82,$20 ;; ?QPWZ?               ;
                      .db $8E,$43,$04,$3D,$4F,$3C,$4F,$3C ;; ?QPWZ?               ;
                      .db $81,$4F,$81,$75,$82,$4F,$01,$11 ;; ?QPWZ?               ;
                      .db $2A,$82,$20,$00,$4F,$81,$3C,$01 ;; ?QPWZ?               ;
                      .db $4F,$3C,$87,$4F,$81,$3C,$03,$00 ;; ?QPWZ?               ;
                      .db $11,$4F,$3C,$82,$4F,$81,$75,$81 ;; ?QPWZ?               ;
                      .db $4F,$01,$11,$50,$81,$20,$06,$69 ;; ?QPWZ?               ;
                      .db $20,$3C,$4F,$3C,$4F,$3C,$88,$4F ;; ?QPWZ?               ;
                      .db $04,$3C,$20,$40,$42,$11,$82,$4F ;; ?QPWZ?               ;
                      .db $81,$75,$81,$4F,$01,$3D,$69,$81 ;; ?QPWZ?               ;
                      .db $20,$05,$69,$20,$4F,$3C,$4F,$3C ;; ?QPWZ?               ;
                      .db $81,$4F,$81,$AC,$01,$4F,$3C,$81 ;; ?QPWZ?               ;
                      .db $4F,$02,$3C,$11,$43,$81,$20,$01 ;; ?QPWZ?               ;
                      .db $69,$50,$82,$43,$81,$75,$81,$4F ;; ?QPWZ?               ;
                      .db $01,$3D,$69,$81,$20,$03,$69,$20 ;; ?QPWZ?               ;
                      .db $3C,$4F,$81,$3C,$01,$4F,$3C,$81 ;; ?QPWZ?               ;
                      .db $AC,$00,$3C,$82,$4F,$02,$11,$50 ;; ?QPWZ?               ;
                      .db $69,$81,$20,$84,$69,$81,$75,$03 ;; ?QPWZ?               ;
                      .db $4F,$3C,$11,$50,$81,$20,$01,$69 ;; ?QPWZ?               ;
                      .db $20,$81,$8A,$83,$AD,$81,$5D,$01 ;; ?QPWZ?               ;
                      .db $4F,$3C,$81,$5D,$02,$3D,$50,$43 ;; ?QPWZ?               ;
                      .db $81,$20,$84,$69,$81,$75,$03,$3C ;; ?QPWZ?               ;
                      .db $4F,$3C,$3D,$81,$20,$01,$69,$20 ;; ?QPWZ?               ;
                      .db $81,$8A,$83,$AD,$81,$68,$01,$3C ;; ?QPWZ?               ;
                      .db $4F,$81,$68,$00,$3D,$81,$11,$01 ;; ?QPWZ?               ;
                      .db $50,$20,$84,$69,$81,$75,$07,$4F ;; ?QPWZ?               ;
                      .db $3C,$11,$00,$69,$20,$40,$42,$81 ;; ?QPWZ?               ;
                      .db $AC,$03,$3C,$4F,$3C,$4F,$81,$5D ;; ?QPWZ?               ;
                      .db $81,$3C,$81,$5D,$05,$11,$10,$3F ;; ?QPWZ?               ;
                      .db $10,$42,$41,$83,$69,$81,$75,$81 ;; ?QPWZ?               ;
                      .db $43,$05,$50,$20,$2A,$43,$11,$3C ;; ?QPWZ?               ;
                      .db $81,$AC,$00,$4F,$84,$3C,$00,$4F ;; ?QPWZ?               ;
                      .db $83,$3C,$05,$11,$03,$11,$3C,$4F ;; ?QPWZ?               ;
                      .db $50,$82,$69,$81,$75,$81,$69,$81 ;; ?QPWZ?               ;
                      .db $20,$00,$3A,$82,$3C,$81,$8A,$83 ;; ?QPWZ?               ;
                      .db $AD,$81,$5D,$81,$AD,$81,$8A,$81 ;; ?QPWZ?               ;
                      .db $AD,$81,$8A,$81,$AD,$00,$8E,$82 ;; ?QPWZ?               ;
                      .db $43,$81,$75,$07,$69,$20,$69,$20 ;; ?QPWZ?               ;
                      .db $43,$11,$3C,$4F,$81,$8A,$83,$AD ;; ?QPWZ?               ;
                      .db $81,$68,$81,$AD,$81,$8A,$81,$AD ;; ?QPWZ?               ;
                      .db $81,$8A,$81,$AD,$81,$AF,$01,$8E ;; ?QPWZ?               ;
                      .db $4F,$81,$75,$07,$69,$20,$69,$20 ;; ?QPWZ?               ;
                      .db $69,$50,$11,$3C,$82,$4F,$00,$3C ;; ?QPWZ?               ;
                      .db $81,$4F,$81,$5D,$00,$3C,$83,$4F ;; ?QPWZ?               ;
                      .db $00,$3C,$81,$4F,$81,$3C,$03,$4F ;; ?QPWZ?               ;
                      .db $8E,$AF,$4F,$81,$75,$81,$69,$81 ;; ?QPWZ?               ;
                      .db $20,$00,$43,$81,$50,$01,$43,$11 ;; ?QPWZ?               ;
                      .db $81,$60,$82,$3C,$03,$4F,$3C,$4F ;; ?QPWZ?               ;
                      .db $3C,$81,$60,$81,$3C,$81,$60,$00 ;; ?QPWZ?               ;
                      .db $3C,$81,$60,$82,$3C,$81,$75,$08 ;; ?QPWZ?               ;
                      .db $69,$20,$69,$20,$3F,$11,$50,$69 ;; ?QPWZ?               ;
                      .db $60,$81,$11,$00,$60,$81,$3C,$00 ;; ?QPWZ?               ;
                      .db $60,$82,$23,$81,$11,$81,$23,$81 ;; ?QPWZ?               ;
                      .db $11,$02,$23,$11,$3D,$82,$3C,$81 ;; ?QPWZ?               ;
                      .db $75,$81,$69,$81,$20,$04,$11,$3F ;; ?QPWZ?               ;
                      .db $11,$60,$11,$81,$4F,$00,$11,$81 ;; ?QPWZ?               ;
                      .db $23,$00,$11,$8A,$4F,$00,$11,$82 ;; ?QPWZ?               ;
                      .db $23,$81,$75,$07,$69,$20,$69,$50 ;; ?QPWZ?               ;
                      .db $11,$3F,$60,$11,$95,$4F,$81,$75 ;; ?QPWZ?               ;
                      .db $9D,$71,$81,$69,$9D,$71,$81,$69 ;; ?QPWZ?               ;
                      .db $9D,$71,$81,$69,$9D,$71,$81,$69 ;; ?QPWZ?               ;
                      .db $9D,$71,$81,$69,$82,$71,$00,$7C ;; ?QPWZ?               ;
                      .db $81,$71,$81,$7C,$81,$71,$82,$7C ;; ?QPWZ?               ;
                      .db $81,$71,$00,$7C,$81,$71,$00,$7C ;; ?QPWZ?               ;
                      .db $81,$71,$00,$7C,$81,$71,$00,$7C ;; ?QPWZ?               ;
                      .db $84,$71,$81,$43,$81,$71,$08,$7C ;; ?QPWZ?               ;
                      .db $71,$7C,$71,$7C,$71,$7C,$71,$7C ;; ?QPWZ?               ;
                      .db $82,$71,$0A,$7C,$71,$7C,$71,$7C ;; ?QPWZ?               ;
                      .db $71,$7C,$71,$7C,$71,$7C,$88,$71 ;; ?QPWZ?               ;
                      .db $00,$7C,$82,$71,$04,$7C,$71,$7C ;; ?QPWZ?               ;
                      .db $71,$7C,$82,$71,$00,$7C,$82,$71 ;; ?QPWZ?               ;
                      .db $06,$7C,$71,$7C,$71,$7C,$71,$7C ;; ?QPWZ?               ;
                      .db $89,$71,$00,$7C,$81,$71,$03,$7C ;; ?QPWZ?               ;
                      .db $71,$7C,$71,$82,$7C,$01,$71,$7C ;; ?QPWZ?               ;
                      .db $82,$71,$01,$7C,$71,$82,$7C,$01 ;; ?QPWZ?               ;
                      .db $71,$7C,$8A,$71,$01,$7C,$71,$81 ;; ?QPWZ?               ;
                      .db $7C,$81,$71,$00,$7C,$82,$71,$00 ;; ?QPWZ?               ;
                      .db $7C,$82,$71,$06,$7C,$71,$7C,$71 ;; ?QPWZ?               ;
                      .db $7C,$71,$7C,$88,$71,$04,$7C,$71 ;; ?QPWZ?               ;
                      .db $7C,$71,$7C,$82,$71,$00,$7C,$82 ;; ?QPWZ?               ;
                      .db $71,$0A,$7C,$71,$7C,$71,$7C,$71 ;; ?QPWZ?               ;
                      .db $7C,$71,$7C,$71,$7C,$86,$71,$81 ;; ?QPWZ?               ;
                      .db $43,$02,$00,$69,$20,$83,$69,$06 ;; ?QPWZ?               ;
                      .db $20,$50,$11,$71,$02,$01,$11,$83 ;; ?QPWZ?               ;
                      .db $43,$03,$42,$41,$20,$3D,$81,$8A ;; ?QPWZ?               ;
                      .db $85,$71,$82,$69,$81,$20,$82,$69 ;; ?QPWZ?               ;
                      .db $06,$41,$42,$A6,$A7,$A6,$A7,$3D ;; ?QPWZ?               ;
                      .db $85,$3F,$02,$11,$50,$3D,$81,$8A ;; ?QPWZ?               ;
                      .db $85,$71,$81,$43,$02,$60,$20,$50 ;; ?QPWZ?               ;
                      .db $82,$43,$07,$11,$A6,$A9,$B7,$B6 ;; ?QPWZ?               ;
                      .db $B7,$00,$11,$85,$3F,$01,$60,$11 ;; ?QPWZ?               ;
                      .db $81,$AC,$87,$71,$04,$11,$60,$11 ;; ?QPWZ?               ;
                      .db $A6,$A7,$81,$71,$01,$B6,$B7,$81 ;; ?QPWZ?               ;
                      .db $71,$02,$3D,$50,$11,$85,$3F,$01 ;; ?QPWZ?               ;
                      .db $3D,$71,$81,$AC,$88,$71,$06,$11 ;; ?QPWZ?               ;
                      .db $60,$B6,$B7,$A6,$A7,$71,$81,$8A ;; ?QPWZ?               ;
                      .db $02,$AD,$3D,$11,$85,$3F,$02,$10 ;; ?QPWZ?               ;
                      .db $3D,$71,$81,$AC,$89,$71,$05,$11 ;; ?QPWZ?               ;
                      .db $60,$71,$B6,$B7,$71,$81,$8A,$01 ;; ?QPWZ?               ;
                      .db $AD,$3D,$84,$3F,$04,$10,$03,$11 ;; ?QPWZ?               ;
                      .db $3D,$5D,$81,$68,$00,$5D,$86,$71 ;; ?QPWZ?               ;
                      .db $00,$3C,$81,$71,$01,$3D,$71,$81 ;; ?QPWZ?               ;
                      .db $60,$00,$71,$81,$AC,$02,$71,$11 ;; ?QPWZ?               ;
                      .db $10,$83,$3F,$00,$3D,$81,$71,$01 ;; ?QPWZ?               ;
                      .db $3D,$5D,$81,$68,$00,$5D,$85,$71 ;; ?QPWZ?               ;
                      .db $05,$3C,$71,$3C,$71,$11,$43,$81 ;; ?QPWZ?               ;
                      .db $11,$00,$60,$81,$AC,$00,$71,$81 ;; ?QPWZ?               ;
                      .db $60,$00,$10,$81,$3F,$00,$60,$82 ;; ?QPWZ?               ;
                      .db $43,$03,$11,$71,$9B,$8F,$87,$71 ;; ?QPWZ?               ;
                      .db $00,$3C,$85,$71,$00,$11,$82,$43 ;; ?QPWZ?               ;
                      .db $81,$11,$00,$43,$81,$03,$00,$11 ;; ?QPWZ?               ;
                      .db $81,$71,$81,$AD,$01,$AF,$AE,$9B ;; ?QPWZ?               ;
                      .db $71,$81,$AD,$00,$8E,$87,$71,$00 ;; ?QPWZ?               ;
                      .db $87,$81,$88,$00,$97,$81,$86,$81 ;; ?QPWZ?               ;
                      .db $85,$81,$86,$02,$85,$71,$85,$81 ;; ?QPWZ?               ;
                      .db $86,$00,$85,$81,$89,$00,$87,$81 ;; ?QPWZ?               ;
                      .db $88,$01,$87,$85,$81,$86,$00,$85 ;; ?QPWZ?               ;
                      .db $81,$89,$81,$71,$81,$BB,$03,$58 ;; ?QPWZ?               ;
                      .db $71,$58,$95,$81,$96,$81,$95,$81 ;; ?QPWZ?               ;
                      .db $96,$02,$95,$71,$95,$81,$96,$00 ;; ?QPWZ?               ;
                      .db $95,$81,$99,$00,$85,$81,$86,$01 ;; ?QPWZ?               ;
                      .db $85,$95,$81,$96,$00,$95,$81,$99 ;; ?QPWZ?               ;
                      .db $81,$71,$81,$BB,$00,$85,$81,$86 ;; ?QPWZ?               ;
                      .db $00,$97,$81,$88,$81,$87,$81,$88 ;; ?QPWZ?               ;
                      .db $02,$87,$58,$87,$81,$88,$00,$87 ;; ?QPWZ?               ;
                      .db $81,$89,$00,$95,$81,$96,$01,$95 ;; ?QPWZ?               ;
                      .db $87,$81,$88,$00,$97,$81,$86,$01 ;; ?QPWZ?               ;
                      .db $85,$71,$81,$BB,$00,$95,$81,$96 ;; ?QPWZ?               ;
                      .db $01,$95,$58,$81,$71,$00,$58,$81 ;; ?QPWZ?               ;
                      .db $89,$85,$71,$81,$99,$00,$87,$81 ;; ?QPWZ?               ;
                      .db $88,$04,$87,$71,$58,$71,$95,$81 ;; ?QPWZ?               ;
                      .db $96,$01,$95,$71,$81,$BB,$00,$87 ;; ?QPWZ?               ;
                      .db $81,$88,$01,$87,$85,$81,$86,$00 ;; ?QPWZ?               ;
                      .db $85,$81,$99,$81,$71,$83,$89,$81 ;; ?QPWZ?               ;
                      .db $5D,$81,$89,$81,$71,$00,$85,$81 ;; ?QPWZ?               ;
                      .db $86,$00,$97,$81,$88,$01,$97,$71 ;; ?QPWZ?               ;
                      .db $81,$BB,$00,$85,$81,$86,$01,$85 ;; ?QPWZ?               ;
                      .db $95,$81,$96,$00,$95,$83,$71,$83 ;; ?QPWZ?               ;
                      .db $99,$81,$5D,$81,$99,$81,$89,$00 ;; ?QPWZ?               ;
                      .db $95,$81,$96,$00,$95,$81,$58,$81 ;; ?QPWZ?               ;
                      .db $71,$81,$BB,$00,$95,$81,$96,$01 ;; ?QPWZ?               ;
                      .db $95,$87,$81,$88,$00,$87,$81,$71 ;; ?QPWZ?               ;
                      .db $83,$89,$02,$58,$71,$58,$82,$71 ;; ?QPWZ?               ;
                      .db $81,$99,$00,$87,$81,$88,$01,$87 ;; ?QPWZ?               ;
                      .db $85,$81,$86,$00,$71,$81,$BB,$00 ;; ?QPWZ?               ;
                      .db $87,$81,$88,$01,$87,$85,$81,$86 ;; ?QPWZ?               ;
                      .db $00,$85,$81,$71,$83,$99,$00,$85 ;; ?QPWZ?               ;
                      .db $81,$86,$00,$85,$83,$89,$00,$85 ;; ?QPWZ?               ;
                      .db $81,$86,$01,$85,$95,$81,$96,$00 ;; ?QPWZ?               ;
                      .db $71,$81,$BB,$00,$85,$81,$86,$01 ;; ?QPWZ?               ;
                      .db $85,$95,$81,$96,$00,$95,$81,$71 ;; ?QPWZ?               ;
                      .db $83,$89,$00,$95,$81,$96,$00,$95 ;; ?QPWZ?               ;
                      .db $83,$99,$00,$95,$81,$96,$01,$95 ;; ?QPWZ?               ;
                      .db $87,$81,$88,$00,$71,$81,$BB,$00 ;; ?QPWZ?               ;
                      .db $95,$81,$96,$01,$95,$87,$81,$88 ;; ?QPWZ?               ;
                      .db $00,$87,$81,$71,$83,$99,$00,$87 ;; ?QPWZ?               ;
                      .db $81,$88,$01,$87,$58,$82,$71,$00 ;; ?QPWZ?               ;
                      .db $87,$81,$88,$00,$87,$83,$71,$81 ;; ?QPWZ?               ;
                      .db $BB,$00,$87,$81,$88,$00,$97,$81 ;; ?QPWZ?               ;
                      .db $86,$01,$85,$71,$81,$89,$81,$71 ;; ?QPWZ?               ;
                      .db $83,$89,$00,$71,$81,$89,$00,$71 ;; ?QPWZ?               ;
                      .db $81,$2B,$85,$89,$81,$71,$81,$BB ;; ?QPWZ?               ;
                      .db $00,$71,$81,$58,$00,$95,$81,$96 ;; ?QPWZ?               ;
                      .db $01,$95,$71,$81,$99,$81,$71,$83 ;; ?QPWZ?               ;
                      .db $99,$00,$58,$81,$99,$00,$58,$81 ;; ?QPWZ?               ;
                      .db $2B,$85,$99,$81,$71,$81,$E8,$00 ;; ?QPWZ?               ;
                      .db $85,$81,$86,$00,$97,$81,$88,$00 ;; ?QPWZ?               ;
                      .db $87,$82,$71,$81,$89,$82,$71,$81 ;; ?QPWZ?               ;
                      .db $89,$00,$71,$81,$89,$81,$71,$81 ;; ?QPWZ?               ;
                      .db $89,$00,$85,$81,$86,$00,$85,$81 ;; ?QPWZ?               ;
                      .db $71,$81,$3F,$00,$95,$81,$96,$00 ;; ?QPWZ?               ;
                      .db $95,$81,$89,$83,$71,$81,$99,$00 ;; ?QPWZ?               ;
                      .db $71,$81,$89,$81,$99,$00,$71,$81 ;; ?QPWZ?               ;
                      .db $99,$81,$71,$81,$99,$00,$95,$81 ;; ?QPWZ?               ;
                      .db $96,$00,$95,$81,$71,$81,$3F,$00 ;; ?QPWZ?               ;
                      .db $87,$81,$88,$00,$87,$81,$99,$83 ;; ?QPWZ?               ;
                      .db $89,$02,$58,$71,$58,$81,$99,$00 ;; ?QPWZ?               ;
                      .db $71,$81,$89,$00,$71,$81,$89,$00 ;; ?QPWZ?               ;
                      .db $85,$81,$86,$00,$97,$81,$88,$00 ;; ?QPWZ?               ;
                      .db $87,$81,$71,$81,$D8,$81,$89,$00 ;; ?QPWZ?               ;
                      .db $85,$81,$86,$00,$85,$83,$99,$00 ;; ?QPWZ?               ;
                      .db $85,$81,$86,$00,$85,$81,$71,$81 ;; ?QPWZ?               ;
                      .db $99,$00,$71,$81,$99,$00,$95,$81 ;; ?QPWZ?               ;
                      .db $96,$01,$95,$71,$81,$89,$81,$71 ;; ?QPWZ?               ;
                      .db $81,$3F,$81,$99,$00,$95,$81,$96 ;; ?QPWZ?               ;
                      .db $00,$95,$83,$89,$00,$95,$81,$96 ;; ?QPWZ?               ;
                      .db $00,$95,$83,$89,$00,$85,$81,$86 ;; ?QPWZ?               ;
                      .db $00,$97,$81,$88,$01,$87,$58,$81 ;; ?QPWZ?               ;
                      .db $99,$81,$71,$81,$3F,$81,$71,$00 ;; ?QPWZ?               ;
                      .db $87,$81,$88,$00,$87,$83,$99,$00 ;; ?QPWZ?               ;
                      .db $87,$81,$88,$00,$87,$83,$99,$00 ;; ?QPWZ?               ;
                      .db $95,$81,$96,$00,$95,$81,$89,$00 ;; ?QPWZ?               ;
                      .db $85,$81,$86,$00,$85,$81,$71,$81 ;; ?QPWZ?               ;
                      .db $3F,$00,$71,$81,$89,$01,$71,$58 ;; ?QPWZ?               ;
                      .db $83,$89,$00,$71,$81,$89,$00,$85 ;; ?QPWZ?               ;
                      .db $81,$86,$00,$85,$81,$58,$00,$87 ;; ?QPWZ?               ;
                      .db $81,$88,$00,$87,$81,$99,$00,$95 ;; ?QPWZ?               ;
                      .db $81,$96,$00,$95,$81,$71,$81,$D9 ;; ?QPWZ?               ;
                      .db $00,$71,$81,$99,$01,$58,$71,$83 ;; ?QPWZ?               ;
                      .db $99,$00,$58,$81,$99,$00,$95,$81 ;; ?QPWZ?               ;
                      .db $96,$00,$95,$81,$89,$00,$85,$81 ;; ?QPWZ?               ;
                      .db $86,$00,$85,$81,$89,$00,$87,$81 ;; ?QPWZ?               ;
                      .db $88,$00,$87,$81,$71,$81,$D8,$01 ;; ?QPWZ?               ;
                      .db $71,$85,$81,$86,$03,$85,$71,$58 ;; ?QPWZ?               ;
                      .db $85,$81,$86,$02,$85,$71,$87,$81 ;; ?QPWZ?               ;
                      .db $88,$00,$87,$81,$99,$00,$95,$81 ;; ?QPWZ?               ;
                      .db $96,$00,$95,$81,$99,$85,$71,$81 ;; ?QPWZ?               ;
                      .db $3F,$83,$75,$03,$20,$69,$20,$B8 ;; ?QPWZ?               ;
                      .db $81,$B9,$03,$B8,$20,$69,$20,$8F ;; ?QPWZ?               ;
                      .db $75,$81,$4F,$82,$71,$00,$7C,$81 ;; ?QPWZ?               ;
                      .db $71,$00,$7C,$82,$71,$82,$7C,$81 ;; ?QPWZ?               ;
                      .db $71,$00,$7C,$81,$71,$05,$7C,$71 ;; ?QPWZ?               ;
                      .db $7C,$71,$7C,$71,$82,$7C,$82,$71 ;; ?QPWZ?               ;
                      .db $81,$43,$9D,$71,$81,$69,$85,$71 ;; ?QPWZ?               ;
                      .db $81,$7B,$83,$71,$81,$7B,$83,$71 ;; ?QPWZ?               ;
                      .db $81,$7B,$83,$71,$81,$7B,$83,$71 ;; ?QPWZ?               ;
                      .db $81,$43,$85,$71,$81,$7B,$83,$71 ;; ?QPWZ?               ;
                      .db $81,$7B,$83,$71,$81,$7B,$83,$71 ;; ?QPWZ?               ;
                      .db $81,$7B,$C7,$71,$81,$5D,$81,$6B ;; ?QPWZ?               ;
                      .db $81,$5D,$83,$71,$81,$7B,$83,$71 ;; ?QPWZ?               ;
                      .db $81,$7B,$83,$71,$81,$7B,$87,$71 ;; ?QPWZ?               ;
                      .db $81,$5D,$81,$6B,$81,$5D,$83,$71 ;; ?QPWZ?               ;
                      .db $81,$7B,$83,$71,$81,$7B,$83,$71 ;; ?QPWZ?               ;
                      .db $81,$7B,$C5,$71,$83,$BB,$00,$7C ;; ?QPWZ?               ;
                      .db $88,$BB,$81,$10,$81,$BB,$81,$7B ;; ?QPWZ?               ;
                      .db $89,$BB,$81,$71,$81,$BB,$01,$B0 ;; ?QPWZ?               ;
                      .db $B1,$86,$BB,$02,$7C,$BB,$10,$81 ;; ?QPWZ?               ;
                      .db $11,$01,$10,$BB,$81,$7B,$82,$BB ;; ?QPWZ?               ;
                      .db $00,$7C,$85,$BB,$81,$71,$03,$BB ;; ?QPWZ?               ;
                      .db $E0,$C0,$C1,$82,$BB,$81,$7B,$82 ;; ?QPWZ?               ;
                      .db $BB,$01,$10,$11,$81,$5D,$01,$11 ;; ?QPWZ?               ;
                      .db $10,$8B,$BB,$81,$71,$03,$BB,$E1 ;; ?QPWZ?               ;
                      .db $D0,$D1,$82,$BB,$81,$7B,$82,$BB ;; ?QPWZ?               ;
                      .db $08,$3D,$4F,$5D,$68,$4F,$11,$10 ;; ?QPWZ?               ;
                      .db $BB,$7C,$83,$BB,$81,$7B,$82,$BB ;; ?QPWZ?               ;
                      .db $81,$71,$8A,$BB,$00,$10,$82,$4F ;; ?QPWZ?               ;
                      .db $81,$6C,$01,$4F,$3D,$85,$BB,$81 ;; ?QPWZ?               ;
                      .db $7B,$82,$BB,$81,$71,$82,$BB,$00 ;; ?QPWZ?               ;
                      .db $10,$86,$03,$84,$4F,$81,$6C,$04 ;; ?QPWZ?               ;
                      .db $11,$03,$04,$03,$04,$82,$03,$00 ;; ?QPWZ?               ;
                      .db $10,$82,$BB,$81,$71,$81,$7B,$01 ;; ?QPWZ?               ;
                      .db $BB,$3D,$81,$5D,$83,$6B,$81,$5D ;; ?QPWZ?               ;
                      .db $84,$4F,$02,$6C,$68,$5D,$83,$4F ;; ?QPWZ?               ;
                      .db $81,$5D,$00,$3D,$82,$BB,$81,$71 ;; ?QPWZ?               ;
                      .db $81,$7B,$01,$BB,$3D,$81,$5D,$83 ;; ?QPWZ?               ;
                      .db $6B,$81,$5D,$05,$4F,$12,$13,$14 ;; ?QPWZ?               ;
                      .db $15,$4F,$81,$5D,$83,$4F,$02,$68 ;; ?QPWZ?               ;
                      .db $5D,$3D,$82,$BB,$81,$71,$82,$BB ;; ?QPWZ?               ;
                      .db $00,$00,$87,$4F,$05,$58,$31,$32 ;; ?QPWZ?               ;
                      .db $33,$34,$58,$84,$4F,$81,$6C,$01 ;; ?QPWZ?               ;
                      .db $11,$00,$82,$BB,$81,$71,$04,$BB ;; ?QPWZ?               ;
                      .db $7C,$BB,$20,$50,$85,$4F,$07,$58 ;; ?QPWZ?               ;
                      .db $4F,$35,$36,$37,$38,$4F,$58,$82 ;; ?QPWZ?               ;
                      .db $4F,$81,$6C,$02,$11,$50,$20,$82 ;; ?QPWZ?               ;
                      .db $BB,$81,$71,$82,$BB,$02,$20,$69 ;; ?QPWZ?               ;
                      .db $00,$81,$4F,$81,$5D,$10,$4F,$58 ;; ?QPWZ?               ;
                      .db $4F,$35,$36,$37,$38,$4F,$58,$4F ;; ?QPWZ?               ;
                      .db $5D,$68,$6C,$11,$00,$69,$20,$82 ;; ?QPWZ?               ;
                      .db $BB,$81,$71,$02,$E8,$E9,$E8,$81 ;; ?QPWZ?               ;
                      .db $20,$04,$69,$50,$4F,$68,$5D,$81 ;; ?QPWZ?               ;
                      .db $4F,$05,$58,$49,$4A,$59,$5A,$58 ;; ?QPWZ?               ;
                      .db $81,$4F,$81,$5D,$02,$4F,$3D,$69 ;; ?QPWZ?               ;
                      .db $81,$20,$82,$E8,$81,$71,$82,$3F ;; ?QPWZ?               ;
                      .db $05,$20,$69,$20,$50,$4F,$68,$84 ;; ?QPWZ?               ;
                      .db $4F,$81,$5D,$86,$4F,$03,$3D,$20 ;; ?QPWZ?               ;
                      .db $69,$20,$82,$D8,$81,$71,$81,$3F ;; ?QPWZ?               ;
                      .db $04,$D8,$20,$69,$00,$11,$81,$6C ;; ?QPWZ?               ;
                      .db $84,$4F,$03,$5D,$68,$6D,$6E,$84 ;; ?QPWZ?               ;
                      .db $4F,$03,$11,$00,$69,$20,$82,$3F ;; ?QPWZ?               ;
                      .db $81,$71,$05,$D8,$D9,$3F,$20,$50 ;; ?QPWZ?               ;
                      .db $11,$81,$6C,$85,$4F,$81,$11,$00 ;; ?QPWZ?               ;
                      .db $6E,$81,$6D,$00,$6E,$83,$4F,$02 ;; ?QPWZ?               ;
                      .db $11,$50,$20,$82,$D9,$81,$71,$04 ;; ?QPWZ?               ;
                      .db $3F,$D8,$D9,$00,$11,$81,$6C,$85 ;; ?QPWZ?               ;
                      .db $4F,$05,$11,$00,$50,$43,$11,$6E ;; ?QPWZ?               ;
                      .db $81,$6D,$00,$6E,$83,$4F,$00,$00 ;; ?QPWZ?               ;
                      .db $82,$3F,$81,$71,$81,$3F,$03,$10 ;; ?QPWZ?               ;
                      .db $11,$5D,$68,$84,$4F,$09,$11,$43 ;; ?QPWZ?               ;
                      .db $50,$69,$20,$69,$50,$11,$4F,$6E ;; ?QPWZ?               ;
                      .db $81,$6D,$00,$6E,$81,$5D,$01,$4F ;; ?QPWZ?               ;
                      .db $10,$81,$3F,$81,$71,$81,$3F,$01 ;; ?QPWZ?               ;
                      .db $3D,$4F,$81,$5D,$81,$4F,$00,$11 ;; ?QPWZ?               ;
                      .db $81,$43,$00,$00,$82,$69,$00,$20 ;; ?QPWZ?               ;
                      .db $81,$69,$01,$00,$18,$81,$4F,$05 ;; ?QPWZ?               ;
                      .db $6E,$6D,$68,$5D,$4F,$3D,$81,$3F ;; ?QPWZ?               ;
                      .db $81,$71,$02,$D9,$3F,$3D,$82,$4F ;; ?QPWZ?               ;
                      .db $02,$11,$43,$50,$82,$69,$00,$20 ;; ?QPWZ?               ;
                      .db $81,$69,$08,$20,$69,$20,$69,$48 ;; ?QPWZ?               ;
                      .db $47,$46,$45,$11,$82,$4F,$00,$00 ;; ?QPWZ?               ;
                      .db $81,$3F,$81,$71,$03,$D8,$D9,$40 ;; ?QPWZ?               ;
                      .db $42,$81,$43,$02,$50,$69,$20,$82 ;; ?QPWZ?               ;
                      .db $69,$02,$20,$69,$20,$82,$69,$00 ;; ?QPWZ?               ;
                      .db $20,$83,$69,$00,$00,$81,$43,$01 ;; ?QPWZ?               ;
                      .db $50,$20,$81,$3F,$81,$71,$81,$3F ;; ?QPWZ?               ;
                      .db $02,$20,$69,$20,$81,$69,$00,$20 ;; ?QPWZ?               ;
                      .db $83,$69,$00,$20,$81,$69,$02,$20 ;; ?QPWZ?               ;
                      .db $69,$20,$84,$69,$04,$20,$69,$20 ;; ?QPWZ?               ;
                      .db $69,$20,$81,$3F,$81,$71,$03,$4F ;; ?QPWZ?               ;
                      .db $3C,$4F,$3C,$81,$4F,$00,$3D,$96 ;; ?QPWZ?               ;
                      .db $3F,$81,$75,$9B,$1C,$03,$58,$18 ;; ?QPWZ?               ;
                      .db $1C,$58,$9B,$1C,$03,$58,$18,$1C ;; ?QPWZ?               ;
                      .db $58,$9A,$1C,$04,$10,$58,$18,$1C ;; ?QPWZ?               ;
                      .db $58,$94,$1C,$81,$10,$81,$50,$82 ;; ?QPWZ?               ;
                      .db $10,$03,$50,$18,$14,$58,$90,$1C ;; ?QPWZ?               ;
                      .db $81,$5C,$84,$10,$00,$50,$82,$10 ;; ?QPWZ?               ;
                      .db $03,$50,$10,$50,$90,$90,$1C,$00 ;; ?QPWZ?               ;
                      .db $5C,$81,$10,$8B,$50,$89,$1C,$82 ;; ?QPWZ?               ;
                      .db $10,$81,$50,$81,$1C,$00,$5C,$86 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$82,$10,$00,$50,$81 ;; ?QPWZ?               ;
                      .db $D0,$89,$1C,$83,$10,$00,$50,$81 ;; ?QPWZ?               ;
                      .db $1C,$00,$5C,$81,$10,$84,$90,$00 ;; ?QPWZ?               ;
                      .db $D0,$82,$90,$02,$D0,$50,$18,$89 ;; ?QPWZ?               ;
                      .db $1C,$00,$50,$81,$90,$81,$D0,$81 ;; ?QPWZ?               ;
                      .db $1C,$01,$18,$50,$84,$90,$85,$10 ;; ?QPWZ?               ;
                      .db $81,$50,$88,$1C,$01,$D4,$58,$82 ;; ?QPWZ?               ;
                      .db $1C,$03,$18,$94,$1C,$18,$81,$58 ;; ?QPWZ?               ;
                      .db $82,$5C,$00,$50,$82,$90,$84,$50 ;; ?QPWZ?               ;
                      .db $88,$1C,$81,$54,$81,$1C,$82,$14 ;; ?QPWZ?               ;
                      .db $01,$1C,$18,$81,$58,$81,$5C,$03 ;; ?QPWZ?               ;
                      .db $18,$5C,$58,$18,$84,$90,$00,$D0 ;; ?QPWZ?               ;
                      .db $89,$1C,$00,$54,$82,$14,$82,$1C ;; ?QPWZ?               ;
                      .db $00,$18,$81,$58,$82,$5C,$81,$58 ;; ?QPWZ?               ;
                      .db $01,$5C,$58,$82,$5C,$01,$18,$14 ;; ?QPWZ?               ;
                      .db $86,$1C,$81,$10,$87,$1C,$01,$58 ;; ?QPWZ?               ;
                      .db $98,$83,$18,$81,$58,$00,$18,$83 ;; ?QPWZ?               ;
                      .db $5C,$01,$18,$14,$86,$1C,$81,$10 ;; ?QPWZ?               ;
                      .db $81,$50,$85,$10,$00,$58,$85,$98 ;; ?QPWZ?               ;
                      .db $81,$18,$00,$58,$82,$5C,$01,$18 ;; ?QPWZ?               ;
                      .db $14,$84,$1C,$84,$10,$81,$50,$06 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$50,$10,$58,$18,$83 ;; ?QPWZ?               ;
                      .db $5C,$81,$98,$01,$18,$58,$82,$18 ;; ?QPWZ?               ;
                      .db $01,$D8,$18,$84,$1C,$01,$10,$50 ;; ?QPWZ?               ;
                      .db $81,$10,$02,$50,$10,$50,$81,$10 ;; ?QPWZ?               ;
                      .db $05,$D0,$50,$D0,$58,$5C,$58,$83 ;; ?QPWZ?               ;
                      .db $5C,$84,$98,$02,$D8,$18,$98,$84 ;; ?QPWZ?               ;
                      .db $1C,$83,$10,$00,$50,$82,$10,$84 ;; ?QPWZ?               ;
                      .db $50,$00,$18,$84,$5C,$00,$18,$82 ;; ?QPWZ?               ;
                      .db $5C,$03,$18,$14,$58,$5C,$83,$1C ;; ?QPWZ?               ;
                      .db $85,$10,$00,$50,$81,$10,$81,$50 ;; ?QPWZ?               ;
                      .db $00,$90,$82,$50,$00,$58,$84,$5C ;; ?QPWZ?               ;
                      .db $00,$58,$81,$5C,$03,$18,$14,$58 ;; ?QPWZ?               ;
                      .db $5C,$82,$1C,$8A,$10,$83,$50,$84 ;; ?QPWZ?               ;
                      .db $10,$01,$50,$18,$82,$5C,$03,$18 ;; ?QPWZ?               ;
                      .db $14,$58,$5C,$82,$1C,$89,$10,$81 ;; ?QPWZ?               ;
                      .db $50,$81,$90,$85,$10,$81,$50,$00 ;; ?QPWZ?               ;
                      .db $58,$81,$5C,$03,$18,$14,$58,$5C ;; ?QPWZ?               ;
                      .db $82,$1C,$85,$10,$00,$50,$84,$10 ;; ?QPWZ?               ;
                      .db $01,$50,$D0,$81,$10,$00,$50,$83 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$81,$10,$04,$50,$18 ;; ?QPWZ?               ;
                      .db $14,$58,$5C,$82,$1C,$01,$50,$90 ;; ?QPWZ?               ;
                      .db $81,$10,$01,$50,$10,$83,$18,$02 ;; ?QPWZ?               ;
                      .db $10,$50,$D0,$82,$90,$00,$D0,$81 ;; ?QPWZ?               ;
                      .db $90,$00,$10,$81,$50,$81,$10,$02 ;; ?QPWZ?               ;
                      .db $50,$14,$58,$81,$14,$82,$1C,$00 ;; ?QPWZ?               ;
                      .db $58,$81,$90,$03,$50,$90,$10,$D0 ;; ?QPWZ?               ;
                      .db $82,$90,$04,$D0,$90,$10,$5C,$50 ;; ?QPWZ?               ;
                      .db $81,$90,$02,$10,$D0,$10,$81,$50 ;; ?QPWZ?               ;
                      .db $82,$10,$00,$50,$82,$58,$82,$1C ;; ?QPWZ?               ;
                      .db $00,$58,$82,$10,$02,$50,$10,$D0 ;; ?QPWZ?               ;
                      .db $82,$90,$01,$10,$5C,$81,$14,$07 ;; ?QPWZ?               ;
                      .db $54,$58,$18,$90,$10,$D0,$10,$50 ;; ?QPWZ?               ;
                      .db $81,$18,$01,$10,$50,$82,$58,$82 ;; ?QPWZ?               ;
                      .db $1C,$00,$D0,$82,$10,$00,$50,$81 ;; ?QPWZ?               ;
                      .db $D0,$02,$58,$5C,$18,$82,$14,$01 ;; ?QPWZ?               ;
                      .db $58,$54,$81,$14,$00,$54,$82,$10 ;; ?QPWZ?               ;
                      .db $83,$18,$00,$10,$82,$50,$81,$1C ;; ?QPWZ?               ;
                      .db $84,$10,$81,$50,$84,$14,$85,$58 ;; ?QPWZ?               ;
                      .db $81,$10,$01,$90,$10,$84,$18,$81 ;; ?QPWZ?               ;
                      .db $10,$00,$90,$81,$1C,$84,$10,$82 ;; ?QPWZ?               ;
                      .db $50,$87,$58,$01,$10,$50,$83,$10 ;; ?QPWZ?               ;
                      .db $00,$D0,$82,$18,$02,$90,$D0,$10 ;; ?QPWZ?               ;
                      .db $82,$1C,$83,$10,$03,$90,$D0,$10 ;; ?QPWZ?               ;
                      .db $50,$86,$58,$01,$10,$50,$88,$10 ;; ?QPWZ?               ;
                      .db $81,$D0,$01,$1C,$58,$81,$1C,$01 ;; ?QPWZ?               ;
                      .db $50,$90,$82,$10,$03,$50,$D0,$10 ;; ?QPWZ?               ;
                      .db $94,$84,$58,$83,$10,$00,$50,$83 ;; ?QPWZ?               ;
                      .db $10,$01,$18,$10,$81,$D0,$01,$1C ;; ?QPWZ?               ;
                      .db $18,$82,$1C,$00,$58,$83,$10,$81 ;; ?QPWZ?               ;
                      .db $50,$81,$14,$84,$58,$83,$10,$00 ;; ?QPWZ?               ;
                      .db $D0,$84,$10,$81,$D0,$82,$1C,$00 ;; ?QPWZ?               ;
                      .db $58,$81,$1C,$00,$58,$83,$10,$81 ;; ?QPWZ?               ;
                      .db $50,$83,$58,$00,$10,$81,$50,$87 ;; ?QPWZ?               ;
                      .db $10,$81,$D0,$00,$58,$82,$1C,$81 ;; ?QPWZ?               ;
                      .db $14,$04,$1C,$D4,$58,$50,$90,$81 ;; ?QPWZ?               ;
                      .db $10,$82,$50,$82,$58,$83,$10,$00 ;; ?QPWZ?               ;
                      .db $18,$83,$10,$03,$18,$10,$D0,$18 ;; ?QPWZ?               ;
                      .db $82,$1C,$81,$14,$01,$1C,$18,$9E ;; ?QPWZ?               ;
                      .db $1C,$00,$18,$9E,$1C,$01,$18,$50 ;; ?QPWZ?               ;
                      .db $95,$1C,$83,$10,$83,$1C,$00,$10 ;; ?QPWZ?               ;
                      .db $81,$50,$90,$1C,$87,$10,$83,$1C ;; ?QPWZ?               ;
                      .db $01,$90,$10,$81,$50,$8D,$1C,$89 ;; ?QPWZ?               ;
                      .db $10,$01,$50,$5C,$81,$1C,$82,$90 ;; ?QPWZ?               ;
                      .db $81,$50,$8B,$1C,$81,$10,$84,$50 ;; ?QPWZ?               ;
                      .db $83,$10,$81,$50,$81,$1C,$81,$58 ;; ?QPWZ?               ;
                      .db $02,$90,$10,$50,$8B,$1C,$82,$10 ;; ?QPWZ?               ;
                      .db $84,$18,$00,$50,$82,$10,$00,$50 ;; ?QPWZ?               ;
                      .db $81,$1C,$82,$58,$01,$10,$50,$8B ;; ?QPWZ?               ;
                      .db $1C,$01,$10,$90,$85,$18,$00,$58 ;; ?QPWZ?               ;
                      .db $81,$50,$01,$D0,$10,$81,$1C,$81 ;; ?QPWZ?               ;
                      .db $58,$02,$10,$D0,$10,$87,$1C,$83 ;; ?QPWZ?               ;
                      .db $18,$00,$50,$81,$90,$84,$18,$01 ;; ?QPWZ?               ;
                      .db $D0,$10,$81,$D0,$00,$18,$81,$1C ;; ?QPWZ?               ;
                      .db $01,$58,$10,$81,$D0,$01,$18,$58 ;; ?QPWZ?               ;
                      .db $85,$1C,$84,$18,$00,$58,$87,$90 ;; ?QPWZ?               ;
                      .db $81,$D0,$01,$5C,$18,$81,$1C,$05 ;; ?QPWZ?               ;
                      .db $10,$90,$D0,$5C,$18,$58,$88,$18 ;; ?QPWZ?               ;
                      .db $04,$58,$D8,$58,$5C,$58,$81,$1C ;; ?QPWZ?               ;
                      .db $85,$5C,$01,$58,$18,$81,$1C,$01 ;; ?QPWZ?               ;
                      .db $58,$18,$81,$5C,$01,$18,$58,$86 ;; ?QPWZ?               ;
                      .db $18,$81,$98,$00,$D8,$81,$58,$01 ;; ?QPWZ?               ;
                      .db $18,$5C,$81,$1C,$84,$5C,$07,$18 ;; ?QPWZ?               ;
                      .db $5C,$18,$50,$1C,$58,$5C,$58,$81 ;; ?QPWZ?               ;
                      .db $18,$00,$58,$85,$1C,$82,$18,$01 ;; ?QPWZ?               ;
                      .db $58,$18,$82,$58,$81,$1C,$85,$5C ;; ?QPWZ?               ;
                      .db $01,$58,$18,$81,$50,$00,$58,$82 ;; ?QPWZ?               ;
                      .db $18,$01,$D8,$18,$83,$10,$81,$50 ;; ?QPWZ?               ;
                      .db $81,$18,$00,$D8,$82,$18,$00,$58 ;; ?QPWZ?               ;
                      .db $82,$18,$00,$58,$83,$5C,$04,$18 ;; ?QPWZ?               ;
                      .db $5C,$18,$10,$50,$82,$18,$81,$D8 ;; ?QPWZ?               ;
                      .db $01,$18,$D0,$83,$90,$04,$50,$58 ;; ?QPWZ?               ;
                      .db $98,$18,$D8,$83,$18,$02,$98,$D8 ;; ?QPWZ?               ;
                      .db $18,$84,$5C,$00,$58,$81,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$81,$98,$04,$18,$58,$5C,$18 ;; ?QPWZ?               ;
                      .db $D0,$82,$5C,$81,$90,$00,$58,$87 ;; ?QPWZ?               ;
                      .db $98,$01,$D8,$18,$83,$5C,$00,$18 ;; ?QPWZ?               ;
                      .db $82,$10,$01,$50,$18,$81,$98,$02 ;; ?QPWZ?               ;
                      .db $18,$5C,$18,$83,$14,$81,$54,$00 ;; ?QPWZ?               ;
                      .db $58,$81,$5C,$00,$58,$84,$5C,$01 ;; ?QPWZ?               ;
                      .db $58,$18,$82,$5C,$83,$10,$81,$50 ;; ?QPWZ?               ;
                      .db $05,$5C,$58,$5C,$18,$5C,$18,$85 ;; ?QPWZ?               ;
                      .db $1C,$02,$58,$5C,$18,$84,$5C,$02 ;; ?QPWZ?               ;
                      .db $18,$5C,$18,$87,$10,$01,$50,$18 ;; ?QPWZ?               ;
                      .db $81,$5C,$01,$18,$5C,$81,$14,$83 ;; ?QPWZ?               ;
                      .db $58,$01,$D4,$58,$81,$5C,$00,$58 ;; ?QPWZ?               ;
                      .db $84,$5C,$00,$58,$82,$10,$02,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$81,$10,$05,$D0,$10,$5C ;; ?QPWZ?               ;
                      .db $58,$5C,$18,$81,$14,$00,$18,$83 ;; ?QPWZ?               ;
                      .db $58,$81,$54,$01,$5C,$18,$84,$5C ;; ?QPWZ?               ;
                      .db $00,$18,$81,$10,$05,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$81,$50,$81,$18,$81 ;; ?QPWZ?               ;
                      .db $5C,$01,$18,$94,$86,$58,$82,$54 ;; ?QPWZ?               ;
                      .db $00,$58,$86,$10,$05,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$81,$50,$03,$18,$14 ;; ?QPWZ?               ;
                      .db $54,$5C,$81,$14,$01,$58,$18,$85 ;; ?QPWZ?               ;
                      .db $58,$02,$18,$54,$14,$82,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$82,$10,$02,$50,$D0,$90,$81 ;; ?QPWZ?               ;
                      .db $10,$82,$50,$02,$18,$58,$54,$81 ;; ?QPWZ?               ;
                      .db $14,$81,$58,$84,$18,$83,$58,$83 ;; ?QPWZ?               ;
                      .db $10,$02,$50,$10,$50,$81,$10,$07 ;; ?QPWZ?               ;
                      .db $50,$10,$50,$10,$50,$10,$50,$14 ;; ?QPWZ?               ;
                      .db $82,$58,$02,$10,$50,$58,$82,$18 ;; ?QPWZ?               ;
                      .db $01,$10,$50,$82,$58,$82,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$81,$50,$02,$10,$50 ;; ?QPWZ?               ;
                      .db $10,$81,$50,$04,$10,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $14,$82,$50,$81,$10,$00,$94,$81 ;; ?QPWZ?               ;
                      .db $18,$81,$10,$01,$50,$10,$81,$50 ;; ?QPWZ?               ;
                      .db $83,$10,$0D,$50,$10,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$50,$10,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $1C,$82,$90,$00,$D0,$81,$14,$01 ;; ?QPWZ?               ;
                      .db $18,$10,$83,$90,$82,$10,$01,$50 ;; ?QPWZ?               ;
                      .db $10,$81,$50,$07,$10,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$50,$81,$10,$82,$50 ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$18,$82,$14,$00,$58 ;; ?QPWZ?               ;
                      .db $81,$1C,$00,$18,$81,$90,$81,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$81,$10,$00,$50,$81,$10 ;; ?QPWZ?               ;
                      .db $0A,$50,$10,$50,$10,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$50,$81,$1C,$81,$18 ;; ?QPWZ?               ;
                      .db $82,$14,$00,$58,$82,$1C,$00,$58 ;; ?QPWZ?               ;
                      .db $82,$90,$04,$10,$50,$10,$50,$10 ;; ?QPWZ?               ;
                      .db $81,$50,$81,$10,$81,$50,$05,$10 ;; ?QPWZ?               ;
                      .db $50,$10,$50,$10,$50,$81,$1C,$81 ;; ?QPWZ?               ;
                      .db $18,$82,$14,$00,$58,$81,$1C,$00 ;; ?QPWZ?               ;
                      .db $18,$82,$1C,$81,$10,$02,$50,$10 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$06,$50,$10,$50,$10 ;; ?QPWZ?               ;
                      .db $50,$14,$10,$81,$50,$01,$D0,$10 ;; ?QPWZ?               ;
                      .db $82,$1C,$81,$14,$02,$18,$D4,$58 ;; ?QPWZ?               ;
                      .db $82,$1C,$00,$58,$81,$1C,$84,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$81,$10,$01,$50,$10,$81 ;; ?QPWZ?               ;
                      .db $50,$02,$10,$50,$10,$81,$50,$02 ;; ?QPWZ?               ;
                      .db $18,$14,$54,$81,$14,$01,$18,$58 ;; ?QPWZ?               ;
                      .db $85,$54,$83,$10,$06,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$50,$81,$10,$03,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$81,$50,$00,$18,$87 ;; ?QPWZ?               ;
                      .db $1C,$83,$50,$83,$10,$02,$50,$10 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$06,$50,$10,$50,$10 ;; ?QPWZ?               ;
                      .db $50,$10,$50,$81,$10,$02,$50,$18 ;; ?QPWZ?               ;
                      .db $1C,$81,$54,$00,$58,$82,$10,$01 ;; ?QPWZ?               ;
                      .db $50,$10,$83,$50,$89,$10,$81,$D0 ;; ?QPWZ?               ;
                      .db $02,$1C,$58,$1C,$81,$14,$83,$1C ;; ?QPWZ?               ;
                      .db $04,$54,$58,$50,$90,$D0,$86,$10 ;; ?QPWZ?               ;
                      .db $81,$18,$00,$50,$84,$10,$81,$D0 ;; ?QPWZ?               ;
                      .db $01,$58,$18,$82,$14,$85,$1C,$00 ;; ?QPWZ?               ;
                      .db $D0,$81,$10,$01,$50,$D0,$82,$10 ;; ?QPWZ?               ;
                      .db $02,$50,$10,$90,$81,$18,$00,$D0 ;; ?QPWZ?               ;
                      .db $83,$10,$81,$D0,$01,$18,$1C,$81 ;; ?QPWZ?               ;
                      .db $14,$86,$1C,$83,$10,$81,$50,$00 ;; ?QPWZ?               ;
                      .db $D0,$81,$90,$00,$D0,$87,$10,$81 ;; ?QPWZ?               ;
                      .db $D0,$81,$1C,$01,$58,$14,$81,$1C ;; ?QPWZ?               ;
                      .db $81,$14,$83,$1C,$01,$50,$90,$81 ;; ?QPWZ?               ;
                      .db $10,$00,$D0,$83,$10,$00,$50,$84 ;; ?QPWZ?               ;
                      .db $10,$01,$D0,$90,$81,$D0,$81,$1C ;; ?QPWZ?               ;
                      .db $00,$18,$87,$14,$81,$1C,$00,$58 ;; ?QPWZ?               ;
                      .db $82,$90,$01,$D0,$18,$82,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$83,$10,$81,$D0,$00,$58,$83 ;; ?QPWZ?               ;
                      .db $1C,$81,$14,$00,$1C,$81,$14,$81 ;; ?QPWZ?               ;
                      .db $58,$81,$14,$81,$1C,$05,$58,$1C ;; ?QPWZ?               ;
                      .db $18,$58,$1C,$18,$86,$90,$81,$D0 ;; ?QPWZ?               ;
                      .db $02,$1C,$58,$5C,$81,$1C,$83,$14 ;; ?QPWZ?               ;
                      .db $85,$58,$81,$1C,$04,$58,$1C,$18 ;; ?QPWZ?               ;
                      .db $58,$1C,$81,$18,$00,$58,$84,$1C ;; ?QPWZ?               ;
                      .db $00,$58,$81,$1C,$00,$58,$81,$1C ;; ?QPWZ?               ;
                      .db $81,$14,$00,$1C,$81,$14,$85,$58 ;; ?QPWZ?               ;
                      .db $81,$1C,$07,$58,$1C,$18,$58,$1C ;; ?QPWZ?               ;
                      .db $18,$1C,$58,$83,$1C,$01,$18,$5C ;; ?QPWZ?               ;
                      .db $81,$1C,$00,$58,$84,$14,$87,$58 ;; ?QPWZ?               ;
                      .db $81,$1C,$04,$58,$1C,$18,$58,$1C ;; ?QPWZ?               ;
                      .db $81,$18,$01,$1C,$5C,$83,$1C,$01 ;; ?QPWZ?               ;
                      .db $58,$1C,$82,$14,$81,$1C,$81,$14 ;; ?QPWZ?               ;
                      .db $87,$58,$81,$1C,$07,$58,$1C,$18 ;; ?QPWZ?               ;
                      .db $58,$1C,$18,$54,$58,$83,$1C,$00 ;; ?QPWZ?               ;
                      .db $18,$82,$14,$83,$1C,$81,$14,$87 ;; ?QPWZ?               ;
                      .db $58,$81,$1C,$06,$58,$1C,$18,$58 ;; ?QPWZ?               ;
                      .db $1C,$18,$54,$86,$14,$85,$1C,$81 ;; ?QPWZ?               ;
                      .db $14,$87,$58,$81,$1C,$05,$58,$1C ;; ?QPWZ?               ;
                      .db $18,$58,$1C,$18,$84,$10,$81,$50 ;; ?QPWZ?               ;
                      .db $87,$1C,$81,$14,$86,$58,$02,$1C ;; ?QPWZ?               ;
                      .db $10,$58,$81,$10,$81,$50,$00,$18 ;; ?QPWZ?               ;
                      .db $86,$10,$00,$50,$86,$1C,$83,$14 ;; ?QPWZ?               ;
                      .db $83,$58,$03,$14,$1C,$10,$50,$81 ;; ?QPWZ?               ;
                      .db $10,$81,$50,$87,$10,$00,$50,$88 ;; ?QPWZ?               ;
                      .db $1C,$81,$14,$00,$58,$81,$14,$09 ;; ?QPWZ?               ;
                      .db $58,$14,$1C,$10,$D0,$58,$18,$58 ;; ?QPWZ?               ;
                      .db $18,$90,$86,$10,$00,$50,$8B,$1C ;; ?QPWZ?               ;
                      .db $81,$14,$82,$1C,$00,$10,$81,$50 ;; ?QPWZ?               ;
                      .db $01,$18,$58,$88,$10,$00,$50,$90 ;; ?QPWZ?               ;
                      .db $1C,$81,$10,$00,$50,$8A,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$83,$1C,$01,$18,$58,$8A,$1C ;; ?QPWZ?               ;
                      .db $00,$50,$82,$90,$86,$10,$00,$D0 ;; ?QPWZ?               ;
                      .db $81,$90,$00,$10,$83,$1C,$00,$18 ;; ?QPWZ?               ;
                      .db $81,$58,$83,$1C,$81,$18,$00,$58 ;; ?QPWZ?               ;
                      .db $82,$1C,$81,$58,$00,$1C,$87,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$81,$1C,$00,$18,$83,$1C ;; ?QPWZ?               ;
                      .db $81,$98,$81,$58,$81,$1C,$85,$18 ;; ?QPWZ?               ;
                      .db $00,$1C,$81,$58,$01,$1C,$50,$86 ;; ?QPWZ?               ;
                      .db $90,$00,$10,$81,$1C,$00,$18,$83 ;; ?QPWZ?               ;
                      .db $1C,$00,$58,$8A,$18,$00,$D4,$81 ;; ?QPWZ?               ;
                      .db $58,$00,$1C,$81,$58,$84,$1C,$81 ;; ?QPWZ?               ;
                      .db $18,$81,$1C,$01,$18,$94,$82,$1C ;; ?QPWZ?               ;
                      .db $8B,$18,$81,$54,$01,$58,$1C,$81 ;; ?QPWZ?               ;
                      .db $58,$84,$1C,$81,$18,$81,$1C,$81 ;; ?QPWZ?               ;
                      .db $14,$81,$1C,$8C,$18,$01,$1C,$54 ;; ?QPWZ?               ;
                      .db $81,$14,$81,$58,$84,$1C,$81,$18 ;; ?QPWZ?               ;
                      .db $82,$14,$82,$1C,$81,$98,$8A,$18 ;; ?QPWZ?               ;
                      .db $82,$1C,$81,$54,$00,$58,$84,$1C ;; ?QPWZ?               ;
                      .db $00,$18,$81,$14,$84,$1C,$00,$58 ;; ?QPWZ?               ;
                      .db $8B,$18,$83,$1C,$00,$54,$87,$14 ;; ?QPWZ?               ;
                      .db $85,$1C,$8C,$18,$92,$1C,$81,$98 ;; ?QPWZ?               ;
                      .db $8A,$18,$8D,$1C,$81,$14,$00,$1C ;; ?QPWZ?               ;
                      .db $81,$14,$00,$58,$81,$98,$89,$18 ;; ?QPWZ?               ;
                      .db $8D,$1C,$84,$14,$81,$58,$81,$98 ;; ?QPWZ?               ;
                      .db $81,$18,$00,$D8,$81,$98,$00,$D8 ;; ?QPWZ?               ;
                      .db $82,$98,$8C,$1C,$84,$14,$83,$58 ;; ?QPWZ?               ;
                      .db $82,$98,$03,$D8,$1C,$18,$58,$81 ;; ?QPWZ?               ;
                      .db $1C,$00,$18,$89,$1C,$81,$14,$00 ;; ?QPWZ?               ;
                      .db $1C,$85,$14,$83,$58,$81,$1C,$03 ;; ?QPWZ?               ;
                      .db $18,$1C,$98,$D8,$81,$1C,$00,$98 ;; ?QPWZ?               ;
                      .db $89,$1C,$81,$14,$84,$1C,$82,$14 ;; ?QPWZ?               ;
                      .db $82,$58,$81,$1C,$03,$18,$1C,$58 ;; ?QPWZ?               ;
                      .db $18,$81,$1C,$00,$58,$86,$1C,$83 ;; ?QPWZ?               ;
                      .db $10,$83,$50,$86,$10,$82,$50,$82 ;; ?QPWZ?               ;
                      .db $10,$03,$50,$10,$50,$14,$86,$1C ;; ?QPWZ?               ;
                      .db $83,$10,$83,$18,$84,$90,$06,$10 ;; ?QPWZ?               ;
                      .db $50,$10,$50,$10,$50,$10,$81,$50 ;; ?QPWZ?               ;
                      .db $02,$D0,$10,$14,$86,$1C,$83,$10 ;; ?QPWZ?               ;
                      .db $00,$90,$81,$18,$07,$D0,$10,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$50,$10,$81,$50,$03 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$50,$81,$D0,$00,$18 ;; ?QPWZ?               ;
                      .db $87,$1C,$82,$10,$82,$90,$82,$10 ;; ?QPWZ?               ;
                      .db $0A,$50,$10,$50,$10,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$90,$10,$81,$50,$01,$1C ;; ?QPWZ?               ;
                      .db $18,$87,$1C,$07,$10,$50,$14,$54 ;; ?QPWZ?               ;
                      .db $58,$18,$90,$10,$83,$50,$83,$10 ;; ?QPWZ?               ;
                      .db $02,$50,$90,$10,$82,$50,$02,$1C ;; ?QPWZ?               ;
                      .db $18,$94,$86,$1C,$03,$50,$90,$50 ;; ?QPWZ?               ;
                      .db $54,$81,$14,$01,$54,$10,$83,$18 ;; ?QPWZ?               ;
                      .db $84,$90,$00,$10,$81,$50,$02,$D0 ;; ?QPWZ?               ;
                      .db $10,$1C,$83,$14,$84,$1C,$00,$58 ;; ?QPWZ?               ;
                      .db $81,$90,$00,$50,$81,$58,$02,$54 ;; ?QPWZ?               ;
                      .db $10,$90,$81,$18,$00,$D0,$81,$10 ;; ?QPWZ?               ;
                      .db $07,$50,$10,$50,$10,$50,$10,$D0 ;; ?QPWZ?               ;
                      .db $18,$81,$14,$00,$1C,$81,$14,$84 ;; ?QPWZ?               ;
                      .db $1C,$01,$58,$1C,$81,$90,$81,$50 ;; ?QPWZ?               ;
                      .db $83,$10,$00,$50,$81,$10,$01,$50 ;; ?QPWZ?               ;
                      .db $10,$81,$50,$81,$10,$81,$D0,$01 ;; ?QPWZ?               ;
                      .db $18,$14,$81,$1C,$81,$58,$81,$14 ;; ?QPWZ?               ;
                      .db $81,$1C,$01,$D4,$58,$81,$1C,$81 ;; ?QPWZ?               ;
                      .db $90,$00,$50,$83,$10,$00,$50,$81 ;; ?QPWZ?               ;
                      .db $10,$03,$50,$10,$50,$10,$82,$D0 ;; ?QPWZ?               ;
                      .db $02,$58,$18,$94,$81,$1C,$81,$58 ;; ?QPWZ?               ;
                      .db $81,$14,$81,$1C,$81,$54,$82,$1C ;; ?QPWZ?               ;
                      .db $8B,$90,$81,$D0,$02,$1C,$18,$1C ;; ?QPWZ?               ;
                      .db $81,$14,$81,$1C,$81,$58,$81,$14 ;; ?QPWZ?               ;
                      .db $82,$1C,$81,$54,$83,$1C,$00,$58 ;; ?QPWZ?               ;
                      .db $87,$1C,$00,$18,$82,$1C,$00,$18 ;; ?QPWZ?               ;
                      .db $81,$14,$82,$1C,$81,$58,$81,$14 ;; ?QPWZ?               ;
                      .db $83,$1C,$84,$18,$01,$58,$1C,$82 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$83,$1C,$00,$58,$81 ;; ?QPWZ?               ;
                      .db $1C,$01,$18,$14,$83,$1C,$00,$58 ;; ?QPWZ?               ;
                      .db $81,$14,$84,$1C,$84,$18,$01,$58 ;; ?QPWZ?               ;
                      .db $1C,$81,$10,$81,$50,$82,$1C,$00 ;; ?QPWZ?               ;
                      .db $18,$82,$1C,$81,$14,$83,$1C,$82 ;; ?QPWZ?               ;
                      .db $14,$84,$1C,$83,$18,$02,$98,$D8 ;; ?QPWZ?               ;
                      .db $1C,$81,$90,$01,$D0,$50,$81,$1C ;; ?QPWZ?               ;
                      .db $81,$18,$00,$58,$81,$14,$81,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$82,$1C,$00,$14,$81,$1C ;; ?QPWZ?               ;
                      .db $81,$18,$00,$58,$81,$1C,$81,$98 ;; ?QPWZ?               ;
                      .db $82,$18,$02,$58,$14,$50,$81,$90 ;; ?QPWZ?               ;
                      .db $00,$10,$81,$14,$07,$58,$98,$18 ;; ?QPWZ?               ;
                      .db $14,$1C,$50,$90,$10,$85,$1C,$81 ;; ?QPWZ?               ;
                      .db $18,$01,$58,$18,$81,$58,$82,$18 ;; ?QPWZ?               ;
                      .db $81,$D8,$00,$1C,$81,$58,$81,$18 ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$58,$00,$18,$81,$1C ;; ?QPWZ?               ;
                      .db $02,$58,$1C,$18,$85,$1C,$88,$18 ;; ?QPWZ?               ;
                      .db $02,$58,$18,$1C,$81,$58,$81,$18 ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$58,$00,$18,$81,$1C ;; ?QPWZ?               ;
                      .db $02,$58,$1C,$18,$82,$1C,$8B,$18 ;; ?QPWZ?               ;
                      .db $02,$58,$18,$D4,$81,$58,$81,$18 ;; ?QPWZ?               ;
                      .db $01,$94,$1C,$81,$58,$06,$18,$1C ;; ?QPWZ?               ;
                      .db $D4,$58,$1C,$18,$94,$81,$1C,$8B ;; ?QPWZ?               ;
                      .db $18,$01,$58,$18,$81,$54,$01,$58 ;; ?QPWZ?               ;
                      .db $18,$81,$14,$00,$D4,$81,$58,$01 ;; ?QPWZ?               ;
                      .db $18,$94,$81,$54,$00,$1C,$81,$14 ;; ?QPWZ?               ;
                      .db $81,$1C,$8B,$18,$81,$58,$01,$1C ;; ?QPWZ?               ;
                      .db $54,$82,$14,$00,$1C,$81,$54,$00 ;; ?QPWZ?               ;
                      .db $58,$81,$14,$01,$1C,$54,$81,$14 ;; ?QPWZ?               ;
                      .db $82,$1C,$8C,$18,$00,$58,$81,$18 ;; ?QPWZ?               ;
                      .db $00,$58,$83,$1C,$00,$54,$81,$14 ;; ?QPWZ?               ;
                      .db $87,$1C,$8F,$18,$81,$58,$8D,$1C ;; ?QPWZ?               ;
                      .db $90,$18,$02,$58,$18,$58,$8B,$1C ;; ?QPWZ?               ;
                      .db $91,$18,$81,$D8,$81,$1C,$81,$14 ;; ?QPWZ?               ;
                      .db $87,$1C,$91,$18,$02,$58,$18,$1C ;; ?QPWZ?               ;
                      .db $82,$14,$87,$1C,$91,$18,$81,$58 ;; ?QPWZ?               ;
                      .db $00,$1C,$81,$14,$88,$1C,$91,$18 ;; ?QPWZ?               ;
                      .db $81,$D8,$8B,$1C,$88,$18,$00,$D8 ;; ?QPWZ?               ;
                      .db $84,$98,$81,$18,$81,$D8,$00,$18 ;; ?QPWZ?               ;
                      .db $81,$14,$82,$1C,$81,$14,$84,$1C ;; ?QPWZ?               ;
                      .db $88,$18,$00,$58,$83,$1C,$81,$98 ;; ?QPWZ?               ;
                      .db $81,$D8,$81,$18,$86,$14,$84,$1C ;; ?QPWZ?               ;
                      .db $81,$18,$82,$98,$00,$D8,$81,$98 ;; ?QPWZ?               ;
                      .db $01,$18,$58,$83,$1C,$02,$58,$98 ;; ?QPWZ?               ;
                      .db $D8,$82,$18,$00,$58,$83,$14,$86 ;; ?QPWZ?               ;
                      .db $1C,$01,$98,$D8,$81,$1C,$02,$98 ;; ?QPWZ?               ;
                      .db $D8,$1C,$81,$18,$00,$58,$83,$1C ;; ?QPWZ?               ;
                      .db $81,$58,$83,$18,$83,$14,$88,$1C ;; ?QPWZ?               ;
                      .db $00,$18,$81,$1C,$02,$58,$18,$1C ;; ?QPWZ?               ;
                      .db $81,$98,$00,$D8,$83,$1C,$81,$58 ;; ?QPWZ?               ;
                      .db $82,$18,$82,$14,$89,$1C,$83,$14 ;; ?QPWZ?               ;
                      .db $00,$50,$83,$10,$82,$50,$81,$10 ;; ?QPWZ?               ;
                      .db $00,$14,$81,$18,$8C,$14,$81,$10 ;; ?QPWZ?               ;
                      .db $83,$14,$00,$50,$83,$10,$82,$50 ;; ?QPWZ?               ;
                      .db $82,$10,$81,$18,$85,$10,$81,$18 ;; ?QPWZ?               ;
                      .db $84,$14,$81,$10,$81,$14,$81,$18 ;; ?QPWZ?               ;
                      .db $00,$50,$83,$10,$82,$50,$82,$10 ;; ?QPWZ?               ;
                      .db $81,$18,$81,$10,$01,$50,$10,$83 ;; ?QPWZ?               ;
                      .db $18,$84,$14,$81,$10,$81,$14,$81 ;; ?QPWZ?               ;
                      .db $18,$00,$50,$83,$10,$83,$50,$81 ;; ?QPWZ?               ;
                      .db $10,$81,$18,$81,$10,$01,$50,$10 ;; ?QPWZ?               ;
                      .db $83,$18,$84,$14,$81,$10,$81,$14 ;; ?QPWZ?               ;
                      .db $81,$18,$00,$50,$83,$10,$81,$50 ;; ?QPWZ?               ;
                      .db $03,$10,$50,$10,$90,$82,$18,$01 ;; ?QPWZ?               ;
                      .db $10,$50,$82,$10,$82,$18,$83,$14 ;; ?QPWZ?               ;
                      .db $81,$10,$01,$14,$10,$81,$18,$00 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$81,$90,$81,$D0,$81 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$82,$18,$85,$10,$81 ;; ?QPWZ?               ;
                      .db $18,$00,$50,$82,$14,$81,$10,$01 ;; ?QPWZ?               ;
                      .db $14,$10,$81,$18,$81,$50,$82,$10 ;; ?QPWZ?               ;
                      .db $82,$50,$82,$10,$82,$18,$00,$10 ;; ?QPWZ?               ;
                      .db $81,$50,$01,$10,$D0,$82,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$82,$14,$81,$10,$02,$14,$50 ;; ?QPWZ?               ;
                      .db $90,$81,$10,$81,$50,$81,$10,$81 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$85,$18,$82,$50,$01 ;; ?QPWZ?               ;
                      .db $10,$50,$81,$10,$00,$50,$82,$14 ;; ?QPWZ?               ;
                      .db $81,$10,$02,$14,$54,$10,$81,$18 ;; ?QPWZ?               ;
                      .db $01,$D0,$50,$81,$10,$81,$50,$01 ;; ?QPWZ?               ;
                      .db $10,$90,$86,$18,$81,$50,$04,$10 ;; ?QPWZ?               ;
                      .db $50,$10,$D0,$10,$82,$14,$81,$10 ;; ?QPWZ?               ;
                      .db $02,$14,$54,$10,$81,$18,$81,$50 ;; ?QPWZ?               ;
                      .db $81,$10,$81,$50,$81,$10,$85,$18 ;; ?QPWZ?               ;
                      .db $82,$10,$00,$90,$82,$D0,$83,$14 ;; ?QPWZ?               ;
                      .db $81,$10,$01,$D4,$54,$83,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$01,$50,$10,$87,$18 ;; ?QPWZ?               ;
                      .db $83,$10,$82,$50,$83,$14,$81,$10 ;; ?QPWZ?               ;
                      .db $81,$54,$82,$10,$00,$50,$81,$10 ;; ?QPWZ?               ;
                      .db $02,$50,$90,$10,$81,$18,$00,$10 ;; ?QPWZ?               ;
                      .db $83,$18,$81,$10,$07,$18,$10,$50 ;; ?QPWZ?               ;
                      .db $90,$10,$50,$14,$94,$81,$14,$81 ;; ?QPWZ?               ;
                      .db $10,$08,$14,$54,$10,$50,$10,$90 ;; ?QPWZ?               ;
                      .db $10,$50,$90,$81,$10,$84,$50,$81 ;; ?QPWZ?               ;
                      .db $18,$07,$10,$50,$10,$50,$90,$10 ;; ?QPWZ?               ;
                      .db $18,$50,$83,$14,$81,$10,$81,$14 ;; ?QPWZ?               ;
                      .db $81,$10,$04,$90,$50,$10,$50,$90 ;; ?QPWZ?               ;
                      .db $85,$10,$00,$50,$81,$18,$01,$90 ;; ?QPWZ?               ;
                      .db $D0,$81,$90,$03,$10,$18,$10,$50 ;; ?QPWZ?               ;
                      .db $83,$14,$81,$D0,$81,$14,$83,$90 ;; ?QPWZ?               ;
                      .db $01,$50,$90,$81,$18,$00,$50,$84 ;; ?QPWZ?               ;
                      .db $10,$81,$18,$01,$10,$50,$81,$10 ;; ?QPWZ?               ;
                      .db $81,$90,$81,$D0,$83,$14,$81,$50 ;; ?QPWZ?               ;
                      .db $81,$14,$00,$54,$81,$14,$81,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$81,$18,$00,$50,$82,$10 ;; ?QPWZ?               ;
                      .db $01,$50,$10,$81,$18,$03,$10,$50 ;; ?QPWZ?               ;
                      .db $18,$50,$87,$14,$81,$50,$81,$14 ;; ?QPWZ?               ;
                      .db $00,$54,$81,$14,$81,$10,$05,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$90,$D0,$90,$82,$D0,$05 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$50,$10,$50,$87,$14 ;; ?QPWZ?               ;
                      .db $81,$50,$02,$14,$D4,$54,$81,$14 ;; ?QPWZ?               ;
                      .db $02,$10,$90,$D0,$81,$90,$85,$10 ;; ?QPWZ?               ;
                      .db $81,$D0,$03,$90,$D0,$10,$50,$83 ;; ?QPWZ?               ;
                      .db $14,$00,$94,$82,$14,$81,$50,$00 ;; ?QPWZ?               ;
                      .db $14,$82,$54,$01,$14,$50,$8E,$90 ;; ?QPWZ?               ;
                      .db $00,$10,$87,$14,$81,$50,$82,$14 ;; ?QPWZ?               ;
                      .db $01,$54,$14,$81,$50,$8E,$10,$87 ;; ?QPWZ?               ;
                      .db $14,$81,$50,$84,$14,$81,$50,$8E ;; ?QPWZ?               ;
                      .db $10,$87,$14,$81,$50,$00,$10,$81 ;; ?QPWZ?               ;
                      .db $50,$86,$10,$00,$50,$88,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$83,$10,$00,$50,$81,$10,$81 ;; ?QPWZ?               ;
                      .db $50,$8B,$10,$00,$50,$83,$10,$00 ;; ?QPWZ?               ;
                      .db $D0,$86,$10,$00,$50,$82,$10,$82 ;; ?QPWZ?               ;
                      .db $50,$84,$10,$01,$50,$90,$83,$10 ;; ?QPWZ?               ;
                      .db $04,$D0,$10,$50,$10,$50,$87,$10 ;; ?QPWZ?               ;
                      .db $83,$50,$81,$10,$81,$50,$84,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$83,$90,$81,$D0,$01,$10 ;; ?QPWZ?               ;
                      .db $50,$84,$10,$00,$50,$85,$10,$81 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$81,$50,$82,$10,$01 ;; ?QPWZ?               ;
                      .db $D0,$10,$81,$50,$82,$10,$00,$50 ;; ?QPWZ?               ;
                      .db $81,$10,$00,$50,$83,$10,$01,$90 ;; ?QPWZ?               ;
                      .db $D0,$83,$90,$00,$D0,$81,$10,$84 ;; ?QPWZ?               ;
                      .db $50,$83,$10,$82,$50,$82,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$00,$50,$81,$18,$88 ;; ?QPWZ?               ;
                      .db $10,$02,$D0,$90,$10,$83,$50,$84 ;; ?QPWZ?               ;
                      .db $10,$82,$50,$85,$10,$81,$18,$86 ;; ?QPWZ?               ;
                      .db $90,$83,$10,$01,$50,$10,$82,$50 ;; ?QPWZ?               ;
                      .db $86,$10,$00,$50,$82,$10,$00,$D0 ;; ?QPWZ?               ;
                      .db $81,$10,$02,$18,$D8,$50,$84,$10 ;; ?QPWZ?               ;
                      .db $82,$90,$81,$10,$01,$50,$10,$82 ;; ?QPWZ?               ;
                      .db $50,$85,$10,$00,$D0,$82,$90,$81 ;; ?QPWZ?               ;
                      .db $D0,$81,$10,$81,$D8,$00,$50,$86 ;; ?QPWZ?               ;
                      .db $10,$82,$90,$02,$D0,$10,$50,$86 ;; ?QPWZ?               ;
                      .db $10,$00,$D0,$87,$10,$02,$58,$14 ;; ?QPWZ?               ;
                      .db $50,$84,$10,$02,$50,$10,$50,$81 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$87,$10,$81,$D0,$85 ;; ?QPWZ?               ;
                      .db $10,$03,$50,$D8,$58,$14,$81,$54 ;; ?QPWZ?               ;
                      .db $88,$10,$00,$50,$8B,$10,$00,$50 ;; ?QPWZ?               ;
                      .db $96,$10,$81,$14,$85,$10,$81,$50 ;; ?QPWZ?               ;
                      .db $95,$10,$81,$14,$01,$10,$50,$84 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$95,$10,$81,$14,$01 ;; ?QPWZ?               ;
                      .db $90,$D0,$81,$90,$82,$10,$00,$50 ;; ?QPWZ?               ;
                      .db $91,$10,$81,$50,$81,$10,$81,$14 ;; ?QPWZ?               ;
                      .db $01,$10,$50,$81,$10,$83,$D0,$92 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$81,$10,$81,$14,$01 ;; ?QPWZ?               ;
                      .db $10,$50,$81,$10,$00,$D0,$81,$50 ;; ?QPWZ?               ;
                      .db $00,$10,$8E,$18,$86,$10,$81,$14 ;; ?QPWZ?               ;
                      .db $82,$10,$81,$D0,$81,$50,$00,$10 ;; ?QPWZ?               ;
                      .db $8E,$18,$01,$50,$90,$84,$10,$81 ;; ?QPWZ?               ;
                      .db $14,$81,$10,$81,$D0,$81,$10,$01 ;; ?QPWZ?               ;
                      .db $50,$10,$8E,$18,$00,$50,$82,$90 ;; ?QPWZ?               ;
                      .db $82,$10,$81,$14,$81,$10,$81,$50 ;; ?QPWZ?               ;
                      .db $81,$10,$01,$50,$10,$86,$18,$00 ;; ?QPWZ?               ;
                      .db $58,$84,$18,$01,$D8,$98,$82,$50 ;; ?QPWZ?               ;
                      .db $00,$90,$82,$D0,$81,$14,$81,$10 ;; ?QPWZ?               ;
                      .db $81,$50,$81,$10,$01,$50,$10,$86 ;; ?QPWZ?               ;
                      .db $18,$00,$58,$83,$18,$81,$D8,$87 ;; ?QPWZ?               ;
                      .db $50,$81,$14,$81,$10,$81,$50,$81 ;; ?QPWZ?               ;
                      .db $10,$03,$50,$10,$18,$58,$84,$18 ;; ?QPWZ?               ;
                      .db $00,$58,$82,$18,$81,$58,$81,$14 ;; ?QPWZ?               ;
                      .db $86,$50,$81,$14,$82,$10,$00,$50 ;; ?QPWZ?               ;
                      .db $81,$10,$03,$50,$10,$98,$D8,$83 ;; ?QPWZ?               ;
                      .db $98,$85,$18,$01,$58,$14,$81,$54 ;; ?QPWZ?               ;
                      .db $85,$50,$81,$14,$81,$10,$01,$D0 ;; ?QPWZ?               ;
                      .db $10,$81,$50,$82,$18,$00,$58,$83 ;; ?QPWZ?               ;
                      .db $18,$01,$98,$D8,$81,$18,$01,$98 ;; ?QPWZ?               ;
                      .db $D8,$81,$58,$81,$18,$81,$58,$83 ;; ?QPWZ?               ;
                      .db $50,$81,$14,$82,$D0,$00,$10,$84 ;; ?QPWZ?               ;
                      .db $18,$00,$58,$8A,$18,$00,$58,$83 ;; ?QPWZ?               ;
                      .db $18,$00,$58,$82,$50,$81,$14,$82 ;; ?QPWZ?               ;
                      .db $50,$00,$10,$84,$18,$00,$58,$84 ;; ?QPWZ?               ;
                      .db $18,$00,$58,$82,$18,$00,$58,$82 ;; ?QPWZ?               ;
                      .db $18,$00,$58,$85,$18,$81,$14,$03 ;; ?QPWZ?               ;
                      .db $50,$10,$50,$10,$81,$98,$81,$18 ;; ?QPWZ?               ;
                      .db $01,$98,$D8,$83,$98,$81,$18,$82 ;; ?QPWZ?               ;
                      .db $98,$00,$D8,$82,$98,$00,$D8,$81 ;; ?QPWZ?               ;
                      .db $98,$00,$D8,$82,$18,$81,$14,$04 ;; ?QPWZ?               ;
                      .db $50,$10,$50,$10,$50,$81,$98,$86 ;; ?QPWZ?               ;
                      .db $18,$01,$98,$D8,$8A,$18,$81,$D8 ;; ?QPWZ?               ;
                      .db $00,$18,$81,$14,$82,$50,$02,$10 ;; ?QPWZ?               ;
                      .db $14,$54,$82,$98,$01,$10,$50,$86 ;; ?QPWZ?               ;
                      .db $18,$01,$10,$50,$81,$18,$04,$10 ;; ?QPWZ?               ;
                      .db $50,$18,$10,$50,$82,$18,$81,$14 ;; ?QPWZ?               ;
                      .db $04,$50,$10,$50,$10,$18,$81,$54 ;; ?QPWZ?               ;
                      .db $00,$50,$81,$10,$81,$50,$81,$18 ;; ?QPWZ?               ;
                      .db $84,$10,$00,$50,$82,$10,$00,$50 ;; ?QPWZ?               ;
                      .db $81,$10,$00,$50,$82,$18,$81,$14 ;; ?QPWZ?               ;
                      .db $82,$50,$03,$10,$94,$18,$54,$83 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$8D,$10,$00,$50,$82 ;; ?QPWZ?               ;
                      .db $10,$81,$14,$02,$50,$10,$50,$81 ;; ?QPWZ?               ;
                      .db $14,$00,$18,$97,$10,$81,$14,$9D ;; ?QPWZ?               ;
                      .db $10,$81,$50,$9D,$10,$81,$50,$9D ;; ?QPWZ?               ;
                      .db $10,$81,$50,$9D,$10,$81,$50,$9D ;; ?QPWZ?               ;
                      .db $10,$81,$50,$82,$10,$00,$14,$81 ;; ?QPWZ?               ;
                      .db $10,$81,$14,$81,$10,$82,$14,$81 ;; ?QPWZ?               ;
                      .db $10,$00,$14,$81,$10,$00,$14,$81 ;; ?QPWZ?               ;
                      .db $10,$00,$14,$81,$10,$00,$14,$88 ;; ?QPWZ?               ;
                      .db $10,$08,$14,$10,$14,$10,$14,$10 ;; ?QPWZ?               ;
                      .db $14,$10,$14,$82,$10,$0A,$14,$10 ;; ?QPWZ?               ;
                      .db $14,$10,$14,$10,$14,$10,$14,$10 ;; ?QPWZ?               ;
                      .db $14,$88,$10,$00,$14,$82,$10,$04 ;; ?QPWZ?               ;
                      .db $14,$10,$14,$10,$14,$82,$10,$00 ;; ?QPWZ?               ;
                      .db $14,$82,$10,$06,$14,$10,$14,$10 ;; ?QPWZ?               ;
                      .db $14,$10,$14,$89,$10,$00,$14,$81 ;; ?QPWZ?               ;
                      .db $10,$03,$14,$10,$14,$10,$82,$14 ;; ?QPWZ?               ;
                      .db $01,$10,$14,$82,$10,$01,$14,$10 ;; ?QPWZ?               ;
                      .db $82,$14,$01,$10,$14,$8A,$10,$01 ;; ?QPWZ?               ;
                      .db $14,$10,$81,$14,$81,$10,$00,$14 ;; ?QPWZ?               ;
                      .db $82,$10,$00,$14,$82,$10,$06,$14 ;; ?QPWZ?               ;
                      .db $10,$14,$10,$14,$10,$14,$88,$10 ;; ?QPWZ?               ;
                      .db $04,$14,$10,$14,$10,$14,$82,$10 ;; ?QPWZ?               ;
                      .db $00,$14,$82,$10,$0A,$14,$10,$14 ;; ?QPWZ?               ;
                      .db $10,$14,$10,$14,$10,$14,$10,$14 ;; ?QPWZ?               ;
                      .db $86,$10,$81,$90,$87,$10,$82,$18 ;; ?QPWZ?               ;
                      .db $81,$58,$00,$54,$83,$14,$81,$54 ;; ?QPWZ?               ;
                      .db $00,$50,$81,$10,$00,$50,$88,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$83,$10,$85,$18,$00,$58 ;; ?QPWZ?               ;
                      .db $85,$18,$81,$54,$02,$10,$90,$D0 ;; ?QPWZ?               ;
                      .db $87,$10,$81,$50,$8A,$18,$00,$94 ;; ?QPWZ?               ;
                      .db $85,$18,$82,$10,$00,$50,$87,$10 ;; ?QPWZ?               ;
                      .db $81,$50,$88,$18,$00,$58,$81,$14 ;; ?QPWZ?               ;
                      .db $85,$18,$82,$10,$00,$50,$88,$10 ;; ?QPWZ?               ;
                      .db $81,$50,$85,$18,$03,$58,$18,$58 ;; ?QPWZ?               ;
                      .db $14,$86,$18,$82,$10,$00,$50,$89 ;; ?QPWZ?               ;
                      .db $10,$81,$50,$83,$18,$03,$98,$D8 ;; ?QPWZ?               ;
                      .db $98,$58,$87,$18,$83,$10,$00,$50 ;; ?QPWZ?               ;
                      .db $89,$10,$03,$50,$18,$10,$50,$81 ;; ?QPWZ?               ;
                      .db $18,$01,$58,$18,$81,$58,$86,$18 ;; ?QPWZ?               ;
                      .db $01,$10,$90,$81,$10,$00,$D0,$89 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$81,$10,$81,$50,$05 ;; ?QPWZ?               ;
                      .db $18,$58,$18,$10,$50,$58,$81,$18 ;; ?QPWZ?               ;
                      .db $85,$10,$01,$50,$90,$8E,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$83,$10,$00,$50,$87,$10,$01 ;; ?QPWZ?               ;
                      .db $50,$90,$9B,$10,$82,$90,$87,$10 ;; ?QPWZ?               ;
                      .db $81,$1C,$00,$5C,$81,$1C,$81,$5C ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$5C,$00,$10,$81,$1C ;; ?QPWZ?               ;
                      .db $81,$5C,$01,$10,$50,$81,$1C,$81 ;; ?QPWZ?               ;
                      .db $5C,$81,$1C,$81,$5C,$01,$10,$50 ;; ?QPWZ?               ;
                      .db $81,$10,$81,$1C,$82,$10,$81,$1C ;; ?QPWZ?               ;
                      .db $81,$5C,$81,$1C,$81,$5C,$00,$10 ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$5C,$01,$10,$50,$81 ;; ?QPWZ?               ;
                      .db $1C,$81,$5C,$81,$1C,$81,$5C,$01 ;; ?QPWZ?               ;
                      .db $10,$50,$81,$10,$83,$1C,$81,$5C ;; ?QPWZ?               ;
                      .db $00,$1C,$81,$5C,$81,$1C,$81,$5C ;; ?QPWZ?               ;
                      .db $00,$10,$81,$1C,$81,$5C,$01,$10 ;; ?QPWZ?               ;
                      .db $50,$81,$1C,$81,$5C,$81,$1C,$00 ;; ?QPWZ?               ;
                      .db $5C,$81,$1C,$81,$5C,$00,$10,$83 ;; ?QPWZ?               ;
                      .db $1C,$81,$5C,$84,$10,$00,$50,$86 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$81,$1C,$81,$5C,$82 ;; ?QPWZ?               ;
                      .db $10,$81,$1C,$81,$5C,$00,$10,$83 ;; ?QPWZ?               ;
                      .db $1C,$81,$5C,$81,$1C,$81,$5C,$01 ;; ?QPWZ?               ;
                      .db $10,$50,$82,$10,$06,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$50,$81,$10,$81,$1C ;; ?QPWZ?               ;
                      .db $81,$5C,$03,$1C,$5C,$1C,$10,$83 ;; ?QPWZ?               ;
                      .db $1C,$81,$5C,$81,$1C,$81,$5C,$84 ;; ?QPWZ?               ;
                      .db $10,$08,$50,$10,$50,$90,$D0,$10 ;; ?QPWZ?               ;
                      .db $50,$10,$50,$81,$1C,$81,$5C,$83 ;; ?QPWZ?               ;
                      .db $10,$83,$1C,$81,$5C,$81,$1C,$81 ;; ?QPWZ?               ;
                      .db $5C,$82,$10,$02,$50,$10,$50,$86 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$81,$1C,$81,$5C,$81 ;; ?QPWZ?               ;
                      .db $1C,$01,$5C,$10,$83,$1C,$81,$5C ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$5C,$82,$10,$02,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$81,$1C,$81,$5C,$03,$10 ;; ?QPWZ?               ;
                      .db $50,$10,$50,$81,$1C,$81,$5C,$81 ;; ?QPWZ?               ;
                      .db $1C,$01,$5C,$10,$83,$1C,$81,$5C ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$5C,$82,$10,$02,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$81,$1C,$81,$5C,$03,$10 ;; ?QPWZ?               ;
                      .db $50,$10,$50,$81,$1C,$81,$5C,$81 ;; ?QPWZ?               ;
                      .db $1C,$01,$5C,$10,$83,$1C,$81,$5C ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$5C,$82,$10,$02,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$81,$1C,$81,$5C,$83,$10 ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$5C,$83,$10,$83,$1C ;; ?QPWZ?               ;
                      .db $00,$5C,$81,$1C,$81,$5C,$81,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$82,$10,$02,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $81,$10,$09,$50,$10,$14,$54,$10 ;; ?QPWZ?               ;
                      .db $50,$10,$50,$10,$50,$81,$10,$81 ;; ?QPWZ?               ;
                      .db $1C,$82,$10,$81,$1C,$81,$5C,$81 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$82,$10,$02,$50,$10 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$09,$50,$10,$94,$D4 ;; ?QPWZ?               ;
                      .db $10,$50,$10,$50,$10,$50,$81,$10 ;; ?QPWZ?               ;
                      .db $81,$18,$81,$1C,$81,$5C,$00,$1C ;; ?QPWZ?               ;
                      .db $81,$5C,$83,$10,$00,$50,$83,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$81,$10,$00,$50,$82,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$81,$1C,$81,$5C,$83,$10 ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$5C,$01,$10,$50,$84 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$81,$10,$02,$50,$10 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$00,$50,$82,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$81,$1C,$81,$5C,$83,$10,$81 ;; ?QPWZ?               ;
                      .db $1C,$81,$5C,$05,$10,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$83,$10,$00,$50,$81,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$81,$10,$00,$50,$81,$1C ;; ?QPWZ?               ;
                      .db $81,$5C,$00,$1C,$81,$5C,$81,$10 ;; ?QPWZ?               ;
                      .db $81,$18,$01,$10,$50,$81,$1C,$81 ;; ?QPWZ?               ;
                      .db $5C,$03,$10,$50,$10,$50,$81,$1C ;; ?QPWZ?               ;
                      .db $81,$5C,$82,$10,$00,$50,$81,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$81,$1C,$81,$5C,$81,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$84,$10,$00,$50,$81,$1C ;; ?QPWZ?               ;
                      .db $81,$5C,$03,$10,$50,$10,$50,$81 ;; ?QPWZ?               ;
                      .db $1C,$81,$5C,$03,$10,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$5C,$00,$1C,$81,$5C ;; ?QPWZ?               ;
                      .db $81,$10,$00,$50,$85,$10,$81,$1C ;; ?QPWZ?               ;
                      .db $81,$5C,$03,$10,$50,$10,$50,$81 ;; ?QPWZ?               ;
                      .db $1C,$81,$5C,$03,$10,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$5C,$01,$10,$50,$81 ;; ?QPWZ?               ;
                      .db $1C,$81,$5C,$85,$10,$00,$50,$82 ;; ?QPWZ?               ;
                      .db $10,$02,$50,$10,$50,$81,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$81,$1C,$81,$5C,$81,$10,$81 ;; ?QPWZ?               ;
                      .db $1C,$81,$5C,$01,$10,$50,$81,$1C ;; ?QPWZ?               ;
                      .db $81,$5C,$81,$10,$81,$18,$81,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$82,$10,$02,$50,$10,$50 ;; ?QPWZ?               ;
                      .db $81,$10,$00,$50,$81,$1C,$81,$5C ;; ?QPWZ?               ;
                      .db $01,$10,$50,$81,$1C,$81,$5C,$01 ;; ?QPWZ?               ;
                      .db $10,$50,$81,$1C,$81,$5C,$81,$10 ;; ?QPWZ?               ;
                      .db $81,$18,$00,$10,$81,$1C,$81,$5C ;; ?QPWZ?               ;
                      .db $81,$10,$81,$1C,$81,$5C,$00,$10 ;; ?QPWZ?               ;
                      .db $81,$1C,$81,$5C,$01,$10,$50,$81 ;; ?QPWZ?               ;
                      .db $1C,$81,$5C,$01,$10,$50,$87,$10 ;; ?QPWZ?               ;
                      .db $83,$14,$00,$50,$83,$10,$82,$50 ;; ?QPWZ?               ;
                      .db $81,$10,$8F,$14,$84,$10,$00,$14 ;; ?QPWZ?               ;
                      .db $81,$10,$00,$14,$82,$10,$82,$14 ;; ?QPWZ?               ;
                      .db $81,$10,$00,$14,$81,$10,$05,$14 ;; ?QPWZ?               ;
                      .db $10,$14,$10,$14,$10,$82,$14,$82 ;; ?QPWZ?               ;
                      .db $10,$81,$90,$A5,$10,$01,$54,$14 ;; ?QPWZ?               ;
                      .db $83,$10,$01,$54,$14,$83,$10,$01 ;; ?QPWZ?               ;
                      .db $54,$14,$83,$10,$01,$54,$14,$8B ;; ?QPWZ?               ;
                      .db $10,$01,$D4,$94,$83,$10,$01,$D4 ;; ?QPWZ?               ;
                      .db $94,$83,$10,$01,$D4,$94,$83,$10 ;; ?QPWZ?               ;
                      .db $01,$D4,$94,$C8,$10,$82,$50,$01 ;; ?QPWZ?               ;
                      .db $10,$50,$83,$10,$01,$54,$14,$83 ;; ?QPWZ?               ;
                      .db $10,$01,$54,$14,$83,$10,$01,$54 ;; ?QPWZ?               ;
                      .db $14,$87,$10,$00,$90,$82,$D0,$01 ;; ?QPWZ?               ;
                      .db $90,$D0,$83,$10,$01,$D4,$94,$83 ;; ?QPWZ?               ;
                      .db $10,$01,$D4,$94,$83,$10,$01,$D4 ;; ?QPWZ?               ;
                      .db $94,$C5,$10,$83,$1C,$00,$14,$88 ;; ?QPWZ?               ;
                      .db $1C,$01,$18,$58,$81,$1C,$01,$54 ;; ?QPWZ?               ;
                      .db $14,$89,$1C,$81,$10,$81,$1C,$81 ;; ?QPWZ?               ;
                      .db $14,$86,$1C,$08,$14,$1C,$18,$10 ;; ?QPWZ?               ;
                      .db $50,$58,$1C,$D4,$94,$82,$1C,$00 ;; ?QPWZ?               ;
                      .db $14,$85,$1C,$81,$10,$00,$1C,$82 ;; ?QPWZ?               ;
                      .db $14,$82,$1C,$01,$54,$14,$82,$1C ;; ?QPWZ?               ;
                      .db $00,$18,$81,$10,$81,$50,$00,$58 ;; ?QPWZ?               ;
                      .db $8B,$1C,$81,$10,$00,$1C,$82,$14 ;; ?QPWZ?               ;
                      .db $82,$1C,$01,$D4,$94,$82,$1C,$81 ;; ?QPWZ?               ;
                      .db $10,$00,$90,$81,$10,$03,$50,$58 ;; ?QPWZ?               ;
                      .db $1C,$14,$83,$1C,$01,$54,$14,$82 ;; ?QPWZ?               ;
                      .db $1C,$81,$10,$8A,$1C,$00,$18,$82 ;; ?QPWZ?               ;
                      .db $10,$00,$D0,$81,$10,$00,$50,$85 ;; ?QPWZ?               ;
                      .db $1C,$01,$D4,$94,$82,$1C,$81,$10 ;; ?QPWZ?               ;
                      .db $82,$1C,$87,$18,$84,$10,$02,$D0 ;; ?QPWZ?               ;
                      .db $10,$50,$86,$18,$00,$58,$82,$1C ;; ?QPWZ?               ;
                      .db $81,$10,$02,$54,$14,$1C,$81,$10 ;; ?QPWZ?               ;
                      .db $00,$50,$84,$10,$00,$50,$84,$10 ;; ?QPWZ?               ;
                      .db $02,$D0,$10,$50,$84,$10,$81,$50 ;; ?QPWZ?               ;
                      .db $82,$1C,$81,$10,$05,$D4,$94,$1C ;; ?QPWZ?               ;
                      .db $10,$90,$D0,$84,$90,$00,$D0,$85 ;; ?QPWZ?               ;
                      .db $10,$01,$90,$D0,$84,$10,$01,$D0 ;; ?QPWZ?               ;
                      .db $50,$82,$1C,$81,$10,$82,$1C,$00 ;; ?QPWZ?               ;
                      .db $50,$87,$10,$00,$18,$83,$10,$00 ;; ?QPWZ?               ;
                      .db $18,$84,$10,$02,$50,$90,$D0,$83 ;; ?QPWZ?               ;
                      .db $1C,$81,$10,$04,$1C,$14,$1C,$50 ;; ?QPWZ?               ;
                      .db $90,$85,$10,$00,$18,$85,$10,$00 ;; ?QPWZ?               ;
                      .db $18,$82,$10,$03,$50,$90,$D0,$DC ;; ?QPWZ?               ;
                      .db $83,$1C,$81,$10,$82,$1C,$02,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$82,$10,$02,$50,$10,$18 ;; ?QPWZ?               ;
                      .db $85,$10,$00,$18,$82,$10,$01,$90 ;; ?QPWZ?               ;
                      .db $D0,$85,$1C,$81,$10,$82,$18,$00 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$00,$90,$81,$10,$00 ;; ?QPWZ?               ;
                      .db $D0,$81,$10,$00,$18,$83,$10,$00 ;; ?QPWZ?               ;
                      .db $18,$81,$10,$06,$90,$D0,$10,$5C ;; ?QPWZ?               ;
                      .db $1C,$5C,$1C,$82,$18,$84,$10,$02 ;; ?QPWZ?               ;
                      .db $50,$10,$50,$88,$10,$00,$50,$83 ;; ?QPWZ?               ;
                      .db $10,$00,$50,$81,$10,$00,$5C,$82 ;; ?QPWZ?               ;
                      .db $1C,$82,$18,$83,$10,$06,$18,$50 ;; ?QPWZ?               ;
                      .db $10,$D0,$10,$50,$90,$84,$10,$00 ;; ?QPWZ?               ;
                      .db $90,$84,$10,$00,$50,$81,$10,$01 ;; ?QPWZ?               ;
                      .db $50,$9C,$81,$1C,$84,$10,$81,$18 ;; ?QPWZ?               ;
                      .db $01,$10,$50,$81,$10,$01,$50,$90 ;; ?QPWZ?               ;
                      .db $85,$10,$01,$D0,$90,$81,$D0,$85 ;; ?QPWZ?               ;
                      .db $10,$02,$50,$5C,$1C,$82,$18,$82 ;; ?QPWZ?               ;
                      .db $10,$81,$18,$03,$D0,$10,$50,$90 ;; ?QPWZ?               ;
                      .db $85,$10,$01,$D0,$1C,$82,$90,$81 ;; ?QPWZ?               ;
                      .db $D0,$85,$10,$00,$9C,$8F,$10,$05 ;; ?QPWZ?               ;
                      .db $D0,$9C,$DC,$1C,$50,$10,$81,$90 ;; ?QPWZ?               ;
                      .db $00,$10,$81,$D0,$82,$10,$02,$50 ;; ?QPWZ?               ;
                      .db $10,$50,$87,$10,$01,$90,$D0,$81 ;; ?QPWZ?               ;
                      .db $10,$00,$D0,$81,$9C,$83,$1C,$00 ;; ?QPWZ?               ;
                      .db $50,$81,$10,$01,$50,$D0,$81,$10 ;; ?QPWZ?               ;
                      .db $81,$D0,$03,$10,$D0,$10,$50,$83 ;; ?QPWZ?               ;
                      .db $10,$00,$18,$84,$10,$02,$D0,$9C ;; ?QPWZ?               ;
                      .db $DC,$82,$1C,$00,$5C,$81,$1C,$00 ;; ?QPWZ?               ;
                      .db $50,$82,$10,$83,$D0,$00,$90,$82 ;; ?QPWZ?               ;
                      .db $10,$00,$1C,$83,$10,$81,$18,$81 ;; ?QPWZ?               ;
                      .db $90,$81,$9C,$02,$DC,$1C,$5C,$82 ;; ?QPWZ?               ;
                      .db $1C,$00,$5C,$81,$1C,$82,$10,$00 ;; ?QPWZ?               ;
                      .db $50,$83,$10,$00,$50,$81,$90,$01 ;; ?QPWZ?               ;
                      .db $DC,$1C,$85,$10,$02,$50,$10,$5C ;; ?QPWZ?               ;
                      .db $86,$1C,$00,$5C,$81,$1C,$00,$50 ;; ?QPWZ?               ;
                      .db $86,$10,$00,$50,$81,$10,$81,$1C ;; ?QPWZ?               ;
                      .db $89,$10,$00,$50,$96,$10,$81,$14 ;; ?QPWZ?               ;
DATA_04D678:          .db $00,$C0,$C0,$C0,$30,$C0,$C0,$00 ;; 04D678               ;
                      .db $C0,$20,$30,$C0,$C0,$C0,$C0,$D0 ;; ?QPWZ?               ;
                      .db $40,$40,$40,$D0,$40,$80,$80,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$40,$00,$80,$20,$80 ;; ?QPWZ?               ;
                      .db $40,$40,$80,$60,$90,$00,$00,$C0 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$C0,$40,$20,$40,$C0 ;; ?QPWZ?               ;
                      .db $E0,$C0,$00,$C0,$00,$00,$C0,$20 ;; ?QPWZ?               ;
                      .db $80,$80,$80,$80,$30,$40,$E0,$00 ;; ?QPWZ?               ;
                      .db $40,$E0,$E0,$D0,$70,$FF,$40,$90 ;; ?QPWZ?               ;
                      .db $55,$80,$80,$80,$80,$00,$C0,$C0 ;; ?QPWZ?               ;
                      .db $C0,$C0,$40,$00,$80,$A0,$30,$AA ;; ?QPWZ?               ;
                      .db $60,$D0,$80,$00,$55,$55,$00,$00 ;; ?QPWZ?               ;
                      .db $AA,$55,$FF,$FF,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00                             ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_04D6E9:          REP #$30                            ;; 04D6E9 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04D6EB:          STZ RAM_ScreenBndryYLo              ;; 04D6EB : 64 1C       ;
CODE_04D6ED:          LDA.W #$FFFF                        ;; 04D6ED : A9 FF FF    ;
CODE_04D6F0:          STA $4D                             ;; 04D6F0 : 85 4D       ;
CODE_04D6F2:          STA $4F                             ;; 04D6F2 : 85 4F       ;
CODE_04D6F4:          LDA.W #$0202                        ;; 04D6F4 : A9 02 02    ;
CODE_04D6F7:          STA $55                             ;; 04D6F7 : 85 55       ;
CODE_04D6F9:          LDA.W $0DD6                         ;; 04D6F9 : AD D6 0D    ;
CODE_04D6FC:          LSR                                 ;; 04D6FC : 4A          ;
CODE_04D6FD:          LSR                                 ;; 04D6FD : 4A          ;
CODE_04D6FE:          AND.W #$00FF                        ;; 04D6FE : 29 FF 00    ;
CODE_04D701:          TAX                                 ;; 04D701 : AA          ;
CODE_04D702:          LDA.W $1F11,X                       ;; 04D702 : BD 11 1F    ;
CODE_04D705:          AND.W #$000F                        ;; 04D705 : 29 0F 00    ;
CODE_04D708:          BEQ CODE_04D714                     ;; 04D708 : F0 0A       ;
CODE_04D70A:          LDA.W #$0020                        ;; 04D70A : A9 20 00    ;
CODE_04D70D:          STA $47                             ;; 04D70D : 85 47       ;
CODE_04D70F:          LDA.W #$0200                        ;; 04D70F : A9 00 02    ;
CODE_04D712:          STA RAM_ScreenBndryYLo              ;; 04D712 : 85 1C       ;
CODE_04D714:          JSL.L CODE_05881A                   ;; 04D714 : 22 1A 88 05 ;
CODE_04D718:          JSL.L CODE_0087AD                   ;; 04D718 : 22 AD 87 00 ;
CODE_04D71C:          REP #$30                            ;; 04D71C : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04D71E:          INC $47                             ;; 04D71E : E6 47       ;
CODE_04D720:          LDA RAM_ScreenBndryYLo              ;; 04D720 : A5 1C       ;
CODE_04D722:          CLC                                 ;; 04D722 : 18          ;
CODE_04D723:          ADC.W #$0010                        ;; 04D723 : 69 10 00    ;
CODE_04D726:          STA RAM_ScreenBndryYLo              ;; 04D726 : 85 1C       ;
CODE_04D728:          AND.W #$01FF                        ;; 04D728 : 29 FF 01    ;
CODE_04D72B:          BNE CODE_04D714                     ;; 04D72B : D0 E7       ;
CODE_04D72D:          LDA $20                             ;; 04D72D : A5 20       ;
CODE_04D72F:          STA RAM_ScreenBndryYLo              ;; 04D72F : 85 1C       ;
CODE_04D731:          STZ $47                             ;; 04D731 : 64 47       ;
CODE_04D733:          STZ.W $1925                         ;; 04D733 : 9C 25 19    ;
CODE_04D736:          STZ RAM_IsVerticalLvl               ;; 04D736 : 64 5B       ;
CODE_04D738:          LDA.W #$FFFF                        ;; 04D738 : A9 FF FF    ;
CODE_04D73B:          STA $4D                             ;; 04D73B : 85 4D       ;
CODE_04D73D:          STA $4F                             ;; 04D73D : 85 4F       ;
CODE_04D73F:          SEP #$30                            ;; 04D73F : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04D741:          LDA.B #$80                          ;; 04D741 : A9 80       ;
CODE_04D743:          STA.W $2115                         ;; 04D743 : 8D 15 21    ; VRAM Address Increment Value
CODE_04D746:          STZ.W $2116                         ;; 04D746 : 9C 16 21    ; Address for VRAM Read/Write (Low Byte)
CODE_04D749:          LDA.B #$30                          ;; 04D749 : A9 30       ;
CODE_04D74B:          STA.W $2117                         ;; 04D74B : 8D 17 21    ; Address for VRAM Read/Write (High Byte)
CODE_04D74E:          LDX.B #$06                          ;; 04D74E : A2 06       ;
CODE_04D750:          LDA.L DATA_04DAB3,X                 ;; 04D750 : BF B3 DA 04 ;
CODE_04D754:          STA.W $4310,X                       ;; 04D754 : 9D 10 43    ;
CODE_04D757:          DEX                                 ;; 04D757 : CA          ;
CODE_04D758:          BPL CODE_04D750                     ;; 04D758 : 10 F6       ;
CODE_04D75A:          LDA.W $0DD6                         ;; 04D75A : AD D6 0D    ;
CODE_04D75D:          LSR                                 ;; 04D75D : 4A          ;
CODE_04D75E:          LSR                                 ;; 04D75E : 4A          ;
CODE_04D75F:          TAX                                 ;; 04D75F : AA          ;
CODE_04D760:          LDA.W $1F11,X                       ;; 04D760 : BD 11 1F    ;
CODE_04D763:          BEQ CODE_04D76A                     ;; 04D763 : F0 05       ;
CODE_04D765:          LDA.B #$60                          ;; 04D765 : A9 60       ;
CODE_04D767:          STA.W $4313                         ;; 04D767 : 8D 13 43    ; A Address (High Byte)
CODE_04D76A:          LDA.B #$02                          ;; 04D76A : A9 02       ;
CODE_04D76C:          STA.W $420B                         ;; 04D76C : 8D 0B 42    ; Regular DMA Channel Enable
Return04D76F:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_04D770:          STA.L $7FC800,X                     ;; 04D770 : 9F 00 C8 7F ;
CODE_04D774:          STA.L $7FC9B0,X                     ;; 04D774 : 9F B0 C9 7F ;
CODE_04D778:          STA.L $7FCB60,X                     ;; 04D778 : 9F 60 CB 7F ;
CODE_04D77C:          STA.L $7FCD10,X                     ;; 04D77C : 9F 10 CD 7F ;
CODE_04D780:          STA.L $7FCEC0,X                     ;; 04D780 : 9F C0 CE 7F ;
CODE_04D784:          STA.L $7FD070,X                     ;; 04D784 : 9F 70 D0 7F ;
CODE_04D788:          STA.L $7FD220,X                     ;; 04D788 : 9F 20 D2 7F ;
CODE_04D78C:          STA.L $7FD3D0,X                     ;; 04D78C : 9F D0 D3 7F ;
CODE_04D790:          STA.L $7FD580,X                     ;; 04D790 : 9F 80 D5 7F ;
CODE_04D794:          STA.L $7FD730,X                     ;; 04D794 : 9F 30 D7 7F ;
CODE_04D798:          STA.L $7FD8E0,X                     ;; 04D798 : 9F E0 D8 7F ;
CODE_04D79C:          STA.L $7FDA90,X                     ;; 04D79C : 9F 90 DA 7F ;
CODE_04D7A0:          STA.L $7FDC40,X                     ;; 04D7A0 : 9F 40 DC 7F ;
CODE_04D7A4:          STA.L $7FDDF0,X                     ;; 04D7A4 : 9F F0 DD 7F ;
CODE_04D7A8:          STA.L $7FDFA0,X                     ;; 04D7A8 : 9F A0 DF 7F ;
CODE_04D7AC:          STA.L $7FE150,X                     ;; 04D7AC : 9F 50 E1 7F ;
CODE_04D7B0:          STA.L $7FE300,X                     ;; 04D7B0 : 9F 00 E3 7F ;
CODE_04D7B4:          STA.L $7FE4B0,X                     ;; 04D7B4 : 9F B0 E4 7F ;
CODE_04D7B8:          STA.L $7FE660,X                     ;; 04D7B8 : 9F 60 E6 7F ;
CODE_04D7BC:          STA.L $7FE810,X                     ;; 04D7BC : 9F 10 E8 7F ;
CODE_04D7C0:          STA.L $7FE9C0,X                     ;; 04D7C0 : 9F C0 E9 7F ;
CODE_04D7C4:          STA.L $7FEB70,X                     ;; 04D7C4 : 9F 70 EB 7F ;
CODE_04D7C8:          STA.L $7FED20,X                     ;; 04D7C8 : 9F 20 ED 7F ;
CODE_04D7CC:          STA.L $7FEED0,X                     ;; 04D7CC : 9F D0 EE 7F ;
CODE_04D7D0:          STA.L $7FF080,X                     ;; 04D7D0 : 9F 80 F0 7F ;
CODE_04D7D4:          STA.L $7FF230,X                     ;; 04D7D4 : 9F 30 F2 7F ;
CODE_04D7D8:          STA.L $7FF3E0,X                     ;; 04D7D8 : 9F E0 F3 7F ;
CODE_04D7DC:          STA.L $7FF590,X                     ;; 04D7DC : 9F 90 F5 7F ;
CODE_04D7E0:          STA.L $7FF740,X                     ;; 04D7E0 : 9F 40 F7 7F ;
CODE_04D7E4:          STA.L $7FF8F0,X                     ;; 04D7E4 : 9F F0 F8 7F ;
CODE_04D7E8:          STA.L $7FFAA0,X                     ;; 04D7E8 : 9F A0 FA 7F ;
CODE_04D7EC:          STA.L $7FFC50,X                     ;; 04D7EC : 9F 50 FC 7F ;
CODE_04D7F0:          INX                                 ;; 04D7F0 : E8          ;
Return04D7F1:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04D7F2:          REP #$30                            ;; 04D7F2 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04D7F4:          LDA.W #$0000                        ;; 04D7F4 : A9 00 00    ;
CODE_04D7F7:          SEP #$20                            ;; 04D7F7 : E2 20       ; Accum (8 bit) 
CODE_04D7F9:          LDA.B #$00                          ;; 04D7F9 : A9 00       ;
CODE_04D7FB:          STA $0D                             ;; 04D7FB : 85 0D       ;
CODE_04D7FD:          LDA.B #$D0                          ;; 04D7FD : A9 D0       ;
CODE_04D7FF:          STA $0E                             ;; 04D7FF : 85 0E       ;
CODE_04D801:          LDA.B #$7E                          ;; 04D801 : A9 7E       ;
CODE_04D803:          STA $0F                             ;; 04D803 : 85 0F       ;
CODE_04D805:          LDA.B #$00                          ;; 04D805 : A9 00       ;
CODE_04D807:          STA $0A                             ;; 04D807 : 85 0A       ;
CODE_04D809:          LDA.B #$D8                          ;; 04D809 : A9 D8       ;
CODE_04D80B:          STA $0B                             ;; 04D80B : 85 0B       ;
CODE_04D80D:          LDA.B #$7E                          ;; 04D80D : A9 7E       ;
CODE_04D80F:          STA $0C                             ;; 04D80F : 85 0C       ;
CODE_04D811:          LDA.B #$00                          ;; 04D811 : A9 00       ;
CODE_04D813:          STA $04                             ;; 04D813 : 85 04       ;
CODE_04D815:          LDA.B #$C8                          ;; 04D815 : A9 C8       ;
CODE_04D817:          STA $05                             ;; 04D817 : 85 05       ;
CODE_04D819:          LDA.B #$7E                          ;; 04D819 : A9 7E       ;
CODE_04D81B:          STA $06                             ;; 04D81B : 85 06       ;
CODE_04D81D:          LDY.W #$0001                        ;; 04D81D : A0 01 00    ;
CODE_04D820:          STY $00                             ;; 04D820 : 84 00       ;
CODE_04D822:          LDY.W #$07FF                        ;; 04D822 : A0 FF 07    ;
CODE_04D825:          LDA.B #$00                          ;; 04D825 : A9 00       ;
CODE_04D827:          STA [$0A],Y                         ;; 04D827 : 97 0A       ;
CODE_04D829:          STA [$0D],Y                         ;; 04D829 : 97 0D       ;
CODE_04D82B:          DEY                                 ;; 04D82B : 88          ;
CODE_04D82C:          BPL CODE_04D827                     ;; 04D82C : 10 F9       ;
CODE_04D82E:          LDY.W #$0000                        ;; 04D82E : A0 00 00    ;
CODE_04D831:          TYX                                 ;; 04D831 : BB          ;
CODE_04D832:          LDA [$04],Y                         ;; 04D832 : B7 04       ;
CODE_04D834:          CMP.B #$56                          ;; 04D834 : C9 56       ;
CODE_04D836:          BCC CODE_04D849                     ;; 04D836 : 90 11       ;
CODE_04D838:          CMP.B #$81                          ;; 04D838 : C9 81       ;
CODE_04D83A:          BCS CODE_04D849                     ;; 04D83A : B0 0D       ;
CODE_04D83C:          LDA $00                             ;; 04D83C : A5 00       ;
CODE_04D83E:          STA [$0D],Y                         ;; 04D83E : 97 0D       ;
CODE_04D840:          TAX                                 ;; 04D840 : AA          ;
CODE_04D841:          LDA.L DATA_04D678,X                 ;; 04D841 : BF 78 D6 04 ;
CODE_04D845:          STA [$0A],Y                         ;; 04D845 : 97 0A       ;
CODE_04D847:          INC $00                             ;; 04D847 : E6 00       ;
CODE_04D849:          INY                                 ;; 04D849 : C8          ;
CODE_04D84A:          CPY.W #$0800                        ;; 04D84A : C0 00 08    ;
CODE_04D84D:          BNE CODE_04D832                     ;; 04D84D : D0 E3       ;
CODE_04D84F:          STZ $0F                             ;; 04D84F : 64 0F       ;
CODE_04D851:          JSR.W CODE_04DA49                   ;; 04D851 : 20 49 DA    ;
CODE_04D854:          INC $0F                             ;; 04D854 : E6 0F       ;
CODE_04D856:          LDA $0F                             ;; 04D856 : A5 0F       ;
CODE_04D858:          CMP.B #$6F                          ;; 04D858 : C9 6F       ;
CODE_04D85A:          BNE CODE_04D851                     ;; 04D85A : D0 F5       ;
Return04D85C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04D85D:          .db $00,$00,$00,$00,$00,$00,$69,$04 ;; 04D85D               ;
                      .db $4B,$04,$29,$04,$09,$04,$D3,$00 ;; ?QPWZ?               ;
                      .db $E5,$00,$A5,$00,$D1,$00,$85,$00 ;; ?QPWZ?               ;
                      .db $A9,$00,$CB,$00,$BD,$00,$9D,$00 ;; ?QPWZ?               ;
                      .db $A5,$00,$07,$02,$00,$00,$27,$02 ;; ?QPWZ?               ;
                      .db $12,$05,$08,$06,$E3,$04,$C8,$04 ;; ?QPWZ?               ;
                      .db $2A,$06,$EC,$04,$0C,$06,$1C,$06 ;; ?QPWZ?               ;
                      .db $4A,$06,$00,$00,$E0,$04,$3E,$00 ;; ?QPWZ?               ;
                      .db $30,$01,$34,$01,$36,$01,$3A,$01 ;; ?QPWZ?               ;
                      .db $00,$00,$57,$01,$84,$01,$3A,$01 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$AA,$06,$76,$06 ;; ?QPWZ?               ;
                      .db $C8,$06,$AC,$06,$76,$06,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$A4,$06,$AA,$06,$C4,$06 ;; ?QPWZ?               ;
                      .db $00,$00,$04,$03,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $79,$05,$77,$05,$59,$05,$74,$05 ;; ?QPWZ?               ;
                      .db $00,$00,$54,$05,$00,$00,$34,$05 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$B3,$03,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$DF,$02,$DC,$02 ;; ?QPWZ?               ;
                      .db $00,$00,$7E,$02,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$E0,$04,$E0,$04,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$34,$05,$34,$05 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$87,$07,$00,$00 ;; ?QPWZ?               ;
                      .db $F0,$01,$68,$03,$65,$03,$B5,$03 ;; ?QPWZ?               ;
                      .db $00,$00,$36,$07,$39,$07,$3C,$07 ;; ?QPWZ?               ;
                      .db $1C,$07,$19,$07,$16,$07,$13,$07 ;; ?QPWZ?               ;
                      .db $11,$07,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
DATA_04D93D:          .db $00,$00,$00,$00,$00,$00,$21,$92 ;; 04D93D               ;
                      .db $21,$16,$20,$92,$20,$12,$23,$46 ;; ?QPWZ?               ;
                      .db $23,$8A,$22,$8A,$23,$42,$22,$0A ;; ?QPWZ?               ;
                      .db $22,$92,$23,$16,$22,$DA,$22,$5A ;; ?QPWZ?               ;
                      .db $22,$8A,$28,$0E,$00,$00,$28,$8E ;; ?QPWZ?               ;
                      .db $24,$04,$28,$10,$23,$86,$23,$10 ;; ?QPWZ?               ;
                      .db $28,$94,$23,$98,$28,$18,$28,$58 ;; ?QPWZ?               ;
                      .db $29,$14,$00,$00,$23,$80,$20,$DC ;; ?QPWZ?               ;
                      .db $24,$C0,$24,$C8,$24,$CC,$24,$D4 ;; ?QPWZ?               ;
                      .db $00,$00,$25,$4E,$26,$08,$24,$D4 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$2A,$94,$29,$CC ;; ?QPWZ?               ;
                      .db $2B,$10,$2A,$98,$29,$CC,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$2A,$88,$2A,$94,$2B,$08 ;; ?QPWZ?               ;
                      .db $00,$00,$2C,$08,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $25,$D2,$25,$CE,$25,$52,$25,$C8 ;; ?QPWZ?               ;
                      .db $00,$00,$25,$48,$00,$00,$24,$C8 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$2E,$C6,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$2B,$5E,$2B,$58 ;; ?QPWZ?               ;
                      .db $00,$00,$29,$DC,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$23,$80,$23,$80,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$24,$C8,$24,$C8 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$2E,$0E,$00,$00 ;; ?QPWZ?               ;
                      .db $27,$C0,$2D,$90,$2D,$8A,$2E,$CA ;; ?QPWZ?               ;
                      .db $00,$00,$2C,$CC,$2C,$D2,$2C,$D8 ;; ?QPWZ?               ;
                      .db $2C,$58,$2C,$52,$2C,$4C,$2C,$46 ;; ?QPWZ?               ;
                      .db $2C,$42,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
DATA_04DA1D:          .db $6E,$6F,$70,$71,$72,$73,$74,$75 ;; 04DA1D               ;
                      .db $59,$53,$52,$83,$4D,$57,$5A,$76 ;; ?QPWZ?               ;
                      .db $78,$7A,$7B,$7D,$7F,$54         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04DA33:          .db $66,$67,$68,$69,$6A,$6B,$6C,$6D ;; 04DA33               ;
                      .db $58,$43,$44,$45,$25,$5E,$5F,$77 ;; ?QPWZ?               ;
                      .db $79,$63,$7C,$7E,$80,$23         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_04DA49:          REP #$30                            ;; 04DA49 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04DA4B:          LDA $0F                             ;; 04DA4B : A5 0F       ;
CODE_04DA4D:          AND.W #$00F8                        ;; 04DA4D : 29 F8 00    ;
CODE_04DA50:          LSR                                 ;; 04DA50 : 4A          ;
CODE_04DA51:          LSR                                 ;; 04DA51 : 4A          ;
CODE_04DA52:          LSR                                 ;; 04DA52 : 4A          ;
CODE_04DA53:          TAY                                 ;; 04DA53 : A8          ;
CODE_04DA54:          LDA $0F                             ;; 04DA54 : A5 0F       ;
CODE_04DA56:          AND.W #$0007                        ;; 04DA56 : 29 07 00    ;
CODE_04DA59:          TAX                                 ;; 04DA59 : AA          ;
CODE_04DA5A:          SEP #$20                            ;; 04DA5A : E2 20       ; Accum (8 bit) 
CODE_04DA5C:          LDA.W $1F02,Y                       ;; 04DA5C : B9 02 1F    ;
CODE_04DA5F:          AND.L DATA_04E44B,X                 ;; 04DA5F : 3F 4B E4 04 ;
CODE_04DA63:          BEQ Return04DAAC                    ;; 04DA63 : F0 47       ;
CODE_04DA65:          REP #$20                            ;; 04DA65 : C2 20       ; Accum (16 bit) 
CODE_04DA67:          LDA.W #$C800                        ;; 04DA67 : A9 00 C8    ;
CODE_04DA6A:          STA $04                             ;; 04DA6A : 85 04       ;
CODE_04DA6C:          LDA $0F                             ;; 04DA6C : A5 0F       ;
CODE_04DA6E:          AND.W #$00FF                        ;; 04DA6E : 29 FF 00    ;
CODE_04DA71:          ASL                                 ;; 04DA71 : 0A          ;
CODE_04DA72:          TAX                                 ;; 04DA72 : AA          ;
CODE_04DA73:          LDA.L DATA_04D85D,X                 ;; 04DA73 : BF 5D D8 04 ;
CODE_04DA77:          TAY                                 ;; 04DA77 : A8          ;
CODE_04DA78:          LDX.W #$0015                        ;; 04DA78 : A2 15 00    ;
CODE_04DA7B:          SEP #$20                            ;; 04DA7B : E2 20       ; Accum (8 bit) 
CODE_04DA7D:          LDA.B #$7E                          ;; 04DA7D : A9 7E       ;
CODE_04DA7F:          STA $06                             ;; 04DA7F : 85 06       ;
CODE_04DA81:          LDA [$04],Y                         ;; 04DA81 : B7 04       ;
CODE_04DA83:          CMP.L DATA_04DA1D,X                 ;; 04DA83 : DF 1D DA 04 ;
CODE_04DA87:          BEQ CODE_04DA8F                     ;; 04DA87 : F0 06       ;
CODE_04DA89:          DEX                                 ;; 04DA89 : CA          ;
CODE_04DA8A:          BPL CODE_04DA83                     ;; 04DA8A : 10 F7       ;
CODE_04DA8C:          JMP.W CODE_04DA9D                   ;; 04DA8C : 4C 9D DA    ;
                                                          ;;                      ;
CODE_04DA8F:          LDA.L DATA_04DA33,X                 ;; 04DA8F : BF 33 DA 04 ;
CODE_04DA93:          STA [$04],Y                         ;; 04DA93 : 97 04       ;
CODE_04DA95:          CPX.W #$0015                        ;; 04DA95 : E0 15 00    ;
CODE_04DA98:          BNE CODE_04DA9D                     ;; 04DA98 : D0 03       ;
ADDR_04DA9A:          INY                                 ;; 04DA9A : C8          ;
ADDR_04DA9B:          STA [$04],Y                         ;; 04DA9B : 97 04       ;
CODE_04DA9D:          LDA $0F                             ;; 04DA9D : A5 0F       ;
CODE_04DA9F:          JSR.W CODE_04E677                   ;; 04DA9F : 20 77 E6    ;
CODE_04DAA2:          SEP #$10                            ;; 04DAA2 : E2 10       ; Index (8 bit) 
CODE_04DAA4:          STZ.W $1B86                         ;; 04DAA4 : 9C 86 1B    ;
CODE_04DAA7:          LDA $0F                             ;; 04DAA7 : A5 0F       ;
CODE_04DAA9:          JSR.W CODE_04E9F1                   ;; 04DAA9 : 20 F1 E9    ;
Return04DAAC:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04DAAD:          PHP                                 ;; 04DAAD : 08          ;
CODE_04DAAE:          JSR.W CODE_04DC6A                   ;; 04DAAE : 20 6A DC    ;
CODE_04DAB1:          PLP                                 ;; 04DAB1 : 28          ;
Return04DAB2:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04DAB3:          .db $01,$18,$00,$40,$7F,$00,$20     ;; 04DAB3               ;
                                                          ;;                      ;
CODE_04DABA:          SEP #$20                            ;; 04DABA : E2 20       ; Accum (8 bit) 
CODE_04DABC:          REP #$10                            ;; 04DABC : C2 10       ; Index (16 bit) 
CODE_04DABE:          LDA [$00],Y                         ;; 04DABE : B7 00       ;
CODE_04DAC0:          STA $03                             ;; 04DAC0 : 85 03       ;
CODE_04DAC2:          AND.B #$80                          ;; 04DAC2 : 29 80       ;
CODE_04DAC4:          BNE CODE_04DAD6                     ;; 04DAC4 : D0 10       ;
CODE_04DAC6:          INY                                 ;; 04DAC6 : C8          ;
CODE_04DAC7:          LDA [$00],Y                         ;; 04DAC7 : B7 00       ;
CODE_04DAC9:          STA.L $7F4000,X                     ;; 04DAC9 : 9F 00 40 7F ;
CODE_04DACD:          INX                                 ;; 04DACD : E8          ;
CODE_04DACE:          INX                                 ;; 04DACE : E8          ;
CODE_04DACF:          DEC $03                             ;; 04DACF : C6 03       ;
CODE_04DAD1:          BPL CODE_04DAC6                     ;; 04DAD1 : 10 F3       ;
CODE_04DAD3:          JMP.W CODE_04DAE9                   ;; 04DAD3 : 4C E9 DA    ;
                                                          ;;                      ;
CODE_04DAD6:          LDA $03                             ;; 04DAD6 : A5 03       ;
CODE_04DAD8:          AND.B #$7F                          ;; 04DAD8 : 29 7F       ;
CODE_04DADA:          STA $03                             ;; 04DADA : 85 03       ;
CODE_04DADC:          INY                                 ;; 04DADC : C8          ;
CODE_04DADD:          LDA [$00],Y                         ;; 04DADD : B7 00       ;
CODE_04DADF:          STA.L $7F4000,X                     ;; 04DADF : 9F 00 40 7F ;
CODE_04DAE3:          INX                                 ;; 04DAE3 : E8          ;
CODE_04DAE4:          INX                                 ;; 04DAE4 : E8          ;
CODE_04DAE5:          DEC $03                             ;; 04DAE5 : C6 03       ;
CODE_04DAE7:          BPL CODE_04DADF                     ;; 04DAE7 : 10 F6       ;
CODE_04DAE9:          INY                                 ;; 04DAE9 : C8          ;
CODE_04DAEA:          CPX $0E                             ;; 04DAEA : E4 0E       ;
CODE_04DAEC:          BCC CODE_04DABA                     ;; 04DAEC : 90 CC       ;
Return04DAEE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04DAEF:          SEP #$30                            ;; 04DAEF : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04DAF1:          LDA.W $1DE8                         ;; 04DAF1 : AD E8 1D    ;
CODE_04DAF4:          JSL.L ExecutePtr                    ;; 04DAF4 : 22 DF 86 00 ;
                                                          ;;                      ;
Ptrs04DAF8:           .dw CODE_04DB18                     ;; ?QPWZ? : 18 DB       ;
                      .dw CODE_04DCB6                     ;; ?QPWZ? : B6 DC       ;
                      .dw CODE_04DCB6                     ;; ?QPWZ? : B6 DC       ;
                      .dw CODE_04DCB6                     ;; ?QPWZ? : B6 DC       ;
                      .dw CODE_04DCB6                     ;; ?QPWZ? : B6 DC       ;
                      .dw CODE_04DB9D                     ;; ?QPWZ? : 9D DB       ;
                      .dw CODE_04DB18                     ;; ?QPWZ? : 18 DB       ;
                      .dw CODE_04DBCF                     ;; ?QPWZ? : CF DB       ;
                                                          ;;                      ;
DATA_04DB08:          .db $00,$F9,$00,$07                 ;; 04DB08               ;
                                                          ;;                      ;
DATA_04DB0C:          .db $00,$00,$00,$70                 ;; 04DB0C               ;
                                                          ;;                      ;
DATA_04DB10:          .db $C0,$FA,$40,$05                 ;; 04DB10               ;
                                                          ;;                      ;
DATA_04DB14:          .db $00,$00,$00,$54                 ;; 04DB14               ;
                                                          ;;                      ;
CODE_04DB18:          REP #$20                            ;; 04DB18 : C2 20       ; Accum (16 bit) 
CODE_04DB1A:          LDX.W $1B8C                         ;; 04DB1A : AE 8C 1B    ;
CODE_04DB1D:          LDA.W $1B8D                         ;; 04DB1D : AD 8D 1B    ;
CODE_04DB20:          CLC                                 ;; 04DB20 : 18          ;
CODE_04DB21:          ADC.W DATA_04DB08,X                 ;; 04DB21 : 7D 08 DB    ;
CODE_04DB24:          STA.W $1B8D                         ;; 04DB24 : 8D 8D 1B    ;
CODE_04DB27:          SEC                                 ;; 04DB27 : 38          ;
CODE_04DB28:          SBC.W DATA_04DB0C,X                 ;; 04DB28 : FD 0C DB    ;
CODE_04DB2B:          EOR.W DATA_04DB08,X                 ;; 04DB2B : 5D 08 DB    ;
CODE_04DB2E:          BPL CODE_04DB43                     ;; 04DB2E : 10 13       ;
CODE_04DB30:          LDA.W $1B8F                         ;; 04DB30 : AD 8F 1B    ;
CODE_04DB33:          CLC                                 ;; 04DB33 : 18          ;
CODE_04DB34:          ADC.W DATA_04DB10,X                 ;; 04DB34 : 7D 10 DB    ;
CODE_04DB37:          STA.W $1B8F                         ;; 04DB37 : 8D 8F 1B    ;
CODE_04DB3A:          SEC                                 ;; 04DB3A : 38          ;
CODE_04DB3B:          SBC.W DATA_04DB14,X                 ;; 04DB3B : FD 14 DB    ;
CODE_04DB3E:          EOR.W DATA_04DB10,X                 ;; 04DB3E : 5D 10 DB    ;
CODE_04DB41:          BMI CODE_04DB5F                     ;; 04DB41 : 30 1C       ;
CODE_04DB43:          LDA.W DATA_04DB0C,X                 ;; 04DB43 : BD 0C DB    ;
CODE_04DB46:          STA.W $1B8D                         ;; 04DB46 : 8D 8D 1B    ;
CODE_04DB49:          LDA.W DATA_04DB14,X                 ;; 04DB49 : BD 14 DB    ;
CODE_04DB4C:          STA.W $1B8F                         ;; 04DB4C : 8D 8F 1B    ;
CODE_04DB4F:          INC.W $1DE8                         ;; 04DB4F : EE E8 1D    ;
CODE_04DB52:          TXA                                 ;; 04DB52 : 8A          ;
CODE_04DB53:          EOR.W #$0002                        ;; 04DB53 : 49 02 00    ;
CODE_04DB56:          TAX                                 ;; 04DB56 : AA          ;
CODE_04DB57:          STX.W $1B8C                         ;; 04DB57 : 8E 8C 1B    ;
CODE_04DB5A:          BEQ CODE_04DB5F                     ;; 04DB5A : F0 03       ;
CODE_04DB5C:          JSR.W CODE_049A93                   ;; 04DB5C : 20 93 9A    ;
CODE_04DB5F:          SEP #$20                            ;; 04DB5F : E2 20       ; Accum (8 bit) 
CODE_04DB61:          LDA.W $1B90                         ;; 04DB61 : AD 90 1B    ;
CODE_04DB64:          ASL                                 ;; 04DB64 : 0A          ;
CODE_04DB65:          STA $00                             ;; 04DB65 : 85 00       ;
CODE_04DB67:          LDA.W $1B8E                         ;; 04DB67 : AD 8E 1B    ;
CODE_04DB6A:          CLC                                 ;; 04DB6A : 18          ;
CODE_04DB6B:          ADC.B #$80                          ;; 04DB6B : 69 80       ;
CODE_04DB6D:          XBA                                 ;; 04DB6D : EB          ;
CODE_04DB6E:          LDA.B #$80                          ;; 04DB6E : A9 80       ;
CODE_04DB70:          SEC                                 ;; 04DB70 : 38          ;
CODE_04DB71:          SBC.W $1B8E                         ;; 04DB71 : ED 8E 1B    ;
CODE_04DB74:          REP #$20                            ;; 04DB74 : C2 20       ; Accum (16 bit) 
CODE_04DB76:          LDX.B #$00                          ;; 04DB76 : A2 00       ;
CODE_04DB78:          LDY.B #$A8                          ;; 04DB78 : A0 A8       ;
CODE_04DB7A:          CPX $00                             ;; 04DB7A : E4 00       ;
CODE_04DB7C:          BCC CODE_04DB81                     ;; 04DB7C : 90 03       ;
CODE_04DB7E:          LDA.W #$00FF                        ;; 04DB7E : A9 FF 00    ;
CODE_04DB81:          STA.W $04EE,Y                       ;; 04DB81 : 99 EE 04    ;
CODE_04DB84:          STA.W $0598,X                       ;; 04DB84 : 9D 98 05    ;
CODE_04DB87:          INX                                 ;; 04DB87 : E8          ;
CODE_04DB88:          INX                                 ;; 04DB88 : E8          ;
CODE_04DB89:          DEY                                 ;; 04DB89 : 88          ;
CODE_04DB8A:          DEY                                 ;; 04DB8A : 88          ;
CODE_04DB8B:          BNE CODE_04DB7A                     ;; 04DB8B : D0 ED       ;
CODE_04DB8D:          SEP #$20                            ;; 04DB8D : E2 20       ; Accum (8 bit) 
CODE_04DB8F:          LDA.B #$33                          ;; 04DB8F : A9 33       ;
CODE_04DB91:          STA $41                             ;; 04DB91 : 85 41       ;
CODE_04DB93:          LDA.B #$33                          ;; 04DB93 : A9 33       ;
CODE_04DB95:          STA $43                             ;; 04DB95 : 85 43       ;
CODE_04DB97:          LDA.B #$80                          ;; 04DB97 : A9 80       ;
CODE_04DB99:          STA.W $0D9F                         ;; 04DB99 : 8D 9F 0D    ;
Return04DB9C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04DB9D:          LDA.W $0DD6                         ;; 04DB9D : AD D6 0D    ;
CODE_04DBA0:          LSR                                 ;; 04DBA0 : 4A          ;
CODE_04DBA1:          LSR                                 ;; 04DBA1 : 4A          ;
CODE_04DBA2:          TAX                                 ;; 04DBA2 : AA          ;
CODE_04DBA3:          LDA.W $1F11,X                       ;; 04DBA3 : BD 11 1F    ;
CODE_04DBA6:          TAX                                 ;; 04DBA6 : AA          ;
CODE_04DBA7:          LDA.L DATA_04DC02,X                 ;; 04DBA7 : BF 02 DC 04 ;
CODE_04DBAB:          STA.W $1931                         ;; 04DBAB : 8D 31 19    ;
CODE_04DBAE:          JSL.L CODE_00A594                   ;; 04DBAE : 22 94 A5 00 ;
CODE_04DBB2:          LDA.B #$FE                          ;; 04DBB2 : A9 FE       ;
CODE_04DBB4:          STA.W $0703                         ;; 04DBB4 : 8D 03 07    ;
CODE_04DBB7:          LDA.B #$01                          ;; 04DBB7 : A9 01       ;
CODE_04DBB9:          STA.W $0704                         ;; 04DBB9 : 8D 04 07    ;
CODE_04DBBC:          STZ.W $0803                         ;; 04DBBC : 9C 03 08    ;
CODE_04DBBF:          LDA.B #$06                          ;; 04DBBF : A9 06       ;
CODE_04DBC1:          STA.W $0680                         ;; 04DBC1 : 8D 80 06    ;
CODE_04DBC4:          INC.W $1DE8                         ;; 04DBC4 : EE E8 1D    ;
Return04DBC7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04DBC8:          .db $02,$03,$04,$06,$07,$09,$05     ;; 04DBC8               ;
                                                          ;;                      ;
CODE_04DBCF:          STZ.W $1DE8                         ;; 04DBCF : 9C E8 1D    ;
CODE_04DBD2:          LDA.B #$04                          ;; 04DBD2 : A9 04       ;
CODE_04DBD4:          STA.W $13D9                         ;; 04DBD4 : 8D D9 13    ;
CODE_04DBD7:          LDA.W $0DD6                         ;; 04DBD7 : AD D6 0D    ;
CODE_04DBDA:          LSR                                 ;; 04DBDA : 4A          ;
CODE_04DBDB:          LSR                                 ;; 04DBDB : 4A          ;
CODE_04DBDC:          TAY                                 ;; 04DBDC : A8          ;
CODE_04DBDD:          LDA.W $0DB2                         ;; 04DBDD : AD B2 0D    ;
CODE_04DBE0:          BEQ CODE_04DBF3                     ;; 04DBE0 : F0 11       ;
CODE_04DBE2:          LDA.W $1B9E                         ;; 04DBE2 : AD 9E 1B    ;
CODE_04DBE5:          BNE CODE_04DBF3                     ;; 04DBE5 : D0 0C       ;
CODE_04DBE7:          TYA                                 ;; 04DBE7 : 98          ;
CODE_04DBE8:          EOR.B #$01                          ;; 04DBE8 : 49 01       ;
CODE_04DBEA:          TAX                                 ;; 04DBEA : AA          ;
CODE_04DBEB:          LDA.W $1F11,Y                       ;; 04DBEB : B9 11 1F    ;
CODE_04DBEE:          CMP.W $1F11,X                       ;; 04DBEE : DD 11 1F    ;
CODE_04DBF1:          BEQ Return04DC01                    ;; 04DBF1 : F0 0E       ;
CODE_04DBF3:          LDA.W $1F11,Y                       ;; 04DBF3 : B9 11 1F    ;
CODE_04DBF6:          TAX                                 ;; 04DBF6 : AA          ;
CODE_04DBF7:          LDA.L DATA_04DBC8,X                 ;; 04DBF7 : BF C8 DB 04 ;
CODE_04DBFB:          STA.W $1DFB                         ;; 04DBFB : 8D FB 1D    ; / Change music 
CODE_04DBFE:          STZ.W $1B9E                         ;; 04DBFE : 9C 9E 1B    ;
Return04DC01:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04DC02:          .db $11,$12,$13,$14,$15,$16,$17     ;; 04DC02               ;
                                                          ;;                      ;
CODE_04DC09:          SEP #$30                            ;; 04DC09 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04DC0B:          LDA.W $0DD6                         ;; 04DC0B : AD D6 0D    ;
CODE_04DC0E:          LSR                                 ;; 04DC0E : 4A          ;
CODE_04DC0F:          LSR                                 ;; 04DC0F : 4A          ;
CODE_04DC10:          TAX                                 ;; 04DC10 : AA          ;
CODE_04DC11:          LDA.W $1F11,X                       ;; 04DC11 : BD 11 1F    ;
CODE_04DC14:          TAX                                 ;; 04DC14 : AA          ;
CODE_04DC15:          LDA.L DATA_04DC02,X                 ;; 04DC15 : BF 02 DC 04 ;
CODE_04DC19:          STA.W $1931                         ;; 04DC19 : 8D 31 19    ;
CODE_04DC1C:          LDA.B #$11                          ;; 04DC1C : A9 11       ;
CODE_04DC1E:          STA.W $192B                         ;; 04DC1E : 8D 2B 19    ;
CODE_04DC21:          LDA.B #$07                          ;; 04DC21 : A9 07       ;
CODE_04DC23:          STA.W $1925                         ;; 04DC23 : 8D 25 19    ;
CODE_04DC26:          LDA.B #$03                          ;; 04DC26 : A9 03       ;
CODE_04DC28:          STA RAM_IsVerticalLvl               ;; 04DC28 : 85 5B       ;
CODE_04DC2A:          REP #$10                            ;; 04DC2A : C2 10       ; Index (16 bit) 
CODE_04DC2C:          LDX.W #$0000                        ;; 04DC2C : A2 00 00    ;
CODE_04DC2F:          TXA                                 ;; 04DC2F : 8A          ;
CODE_04DC30:          JSR.W CODE_04D770                   ;; 04DC30 : 20 70 D7    ;
CODE_04DC33:          CPX.W #$01B0                        ;; 04DC33 : E0 B0 01    ;
CODE_04DC36:          BNE CODE_04DC30                     ;; 04DC36 : D0 F8       ;
CODE_04DC38:          REP #$30                            ;; 04DC38 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04DC3A:          LDA.W #$D000                        ;; 04DC3A : A9 00 D0    ;
CODE_04DC3D:          STA $00                             ;; 04DC3D : 85 00       ;
CODE_04DC3F:          LDX.W #$0000                        ;; 04DC3F : A2 00 00    ;
CODE_04DC42:          LDA $00                             ;; 04DC42 : A5 00       ;
CODE_04DC44:          STA.W $0FBE,X                       ;; 04DC44 : 9D BE 0F    ;
CODE_04DC47:          LDA $00                             ;; 04DC47 : A5 00       ;
CODE_04DC49:          CLC                                 ;; 04DC49 : 18          ;
CODE_04DC4A:          ADC.W #$0008                        ;; 04DC4A : 69 08 00    ;
CODE_04DC4D:          STA $00                             ;; 04DC4D : 85 00       ;
CODE_04DC4F:          INX                                 ;; 04DC4F : E8          ;
CODE_04DC50:          INX                                 ;; 04DC50 : E8          ;
CODE_04DC51:          CPX.W #$0400                        ;; 04DC51 : E0 00 04    ;
CODE_04DC54:          BNE CODE_04DC42                     ;; 04DC54 : D0 EC       ;
CODE_04DC56:          PHB                                 ;; 04DC56 : 8B          ;
CODE_04DC57:          LDA.W #$07FF                        ;; 04DC57 : A9 FF 07    ;
CODE_04DC5A:          LDX.W #$F7DF                        ;; 04DC5A : A2 DF F7    ;
CODE_04DC5D:          LDY.W #$C800                        ;; 04DC5D : A0 00 C8    ;
CODE_04DC60:          MVN $7E,$0C                         ;; 04DC60 : 54 7E 0C    ;
CODE_04DC63:          PLB                                 ;; 04DC63 : AB          ;
CODE_04DC64:          JSR.W CODE_04D7F2                   ;; 04DC64 : 20 F2 D7    ;
CODE_04DC67:          SEP #$30                            ;; 04DC67 : E2 30       ; Index (8 bit) Accum (8 bit) 
Return04DC69:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_04DC6A:          SEP #$30                            ;; 04DC6A : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04DC6C:          JSR.W CODE_04DD40                   ;; 04DC6C : 20 40 DD    ;
CODE_04DC6F:          REP #$20                            ;; 04DC6F : C2 20       ; Accum (16 bit) 
CODE_04DC71:          LDA.W #$A533                        ;; 04DC71 : A9 33 A5    ;
CODE_04DC74:          STA $00                             ;; 04DC74 : 85 00       ;
CODE_04DC76:          SEP #$30                            ;; 04DC76 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04DC78:          LDA.B #$04                          ;; 04DC78 : A9 04       ;
CODE_04DC7A:          STA $02                             ;; 04DC7A : 85 02       ;
CODE_04DC7C:          REP #$10                            ;; 04DC7C : C2 10       ; Index (16 bit) 
CODE_04DC7E:          LDY.W #$4000                        ;; 04DC7E : A0 00 40    ;
CODE_04DC81:          STY $0E                             ;; 04DC81 : 84 0E       ;
CODE_04DC83:          LDY.W #$0000                        ;; 04DC83 : A0 00 00    ;
CODE_04DC86:          TYX                                 ;; 04DC86 : BB          ;
CODE_04DC87:          JSR.W CODE_04DABA                   ;; 04DC87 : 20 BA DA    ;
CODE_04DC8A:          REP #$20                            ;; 04DC8A : C2 20       ; Accum (16 bit) 
CODE_04DC8C:          LDA.W #$C02B                        ;; 04DC8C : A9 2B C0    ;
CODE_04DC8F:          STA $00                             ;; 04DC8F : 85 00       ;
CODE_04DC91:          SEP #$20                            ;; 04DC91 : E2 20       ; Accum (8 bit) 
CODE_04DC93:          LDX.W #$0001                        ;; 04DC93 : A2 01 00    ;
CODE_04DC96:          LDY.W #$0000                        ;; 04DC96 : A0 00 00    ;
CODE_04DC99:          JSR.W CODE_04DABA                   ;; 04DC99 : 20 BA DA    ;
CODE_04DC9C:          SEP #$30                            ;; 04DC9C : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04DC9E:          LDA.B #$00                          ;; 04DC9E : A9 00       ;
CODE_04DCA0:          STA $0F                             ;; 04DCA0 : 85 0F       ;
CODE_04DCA2:          JSR.W CODE_04E453                   ;; 04DCA2 : 20 53 E4    ;
CODE_04DCA5:          INC $0F                             ;; 04DCA5 : E6 0F       ;
CODE_04DCA7:          LDA $0F                             ;; 04DCA7 : A5 0F       ;
CODE_04DCA9:          CMP.B #$6F                          ;; 04DCA9 : C9 6F       ;
CODE_04DCAB:          BNE CODE_04DCA2                     ;; 04DCAB : D0 F5       ;
Return04DCAD:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04DCAE:          .db $80,$40,$20,$10,$08,$04,$02,$01 ;; 04DCAE               ;
                                                          ;;                      ;
CODE_04DCB6:          PHP                                 ;; 04DCB6 : 08          ;
CODE_04DCB7:          REP #$10                            ;; 04DCB7 : C2 10       ; Index (16 bit) 
CODE_04DCB9:          SEP #$20                            ;; 04DCB9 : E2 20       ; Accum (8 bit) 
CODE_04DCBB:          LDX.W #$D000                        ;; 04DCBB : A2 00 D0    ;
CODE_04DCBE:          STX $65                             ;; 04DCBE : 86 65       ;
CODE_04DCC0:          LDA.B #$05                          ;; 04DCC0 : A9 05       ;
CODE_04DCC2:          STA $67                             ;; 04DCC2 : 85 67       ;
CODE_04DCC4:          LDX.W #$0000                        ;; 04DCC4 : A2 00 00    ;
CODE_04DCC7:          STX $00                             ;; 04DCC7 : 86 00       ;
CODE_04DCC9:          LDA.W $1DE8                         ;; 04DCC9 : AD E8 1D    ;
CODE_04DCCC:          DEC A                               ;; 04DCCC : 3A          ;
CODE_04DCCD:          STA $01                             ;; 04DCCD : 85 01       ;
CODE_04DCCF:          REP #$20                            ;; 04DCCF : C2 20       ; Accum (16 bit) 
CODE_04DCD1:          LDA.W $0DD6                         ;; 04DCD1 : AD D6 0D    ;
CODE_04DCD4:          LSR                                 ;; 04DCD4 : 4A          ;
CODE_04DCD5:          LSR                                 ;; 04DCD5 : 4A          ;
CODE_04DCD6:          AND.W #$00FF                        ;; 04DCD6 : 29 FF 00    ;
CODE_04DCD9:          TAX                                 ;; 04DCD9 : AA          ;
CODE_04DCDA:          SEP #$20                            ;; 04DCDA : E2 20       ; Accum (8 bit) 
CODE_04DCDC:          LDA.W $1F11,X                       ;; 04DCDC : BD 11 1F    ;
CODE_04DCDF:          BEQ CODE_04DCE8                     ;; 04DCDF : F0 07       ;
CODE_04DCE1:          LDA $01                             ;; 04DCE1 : A5 01       ;
CODE_04DCE3:          CLC                                 ;; 04DCE3 : 18          ;
CODE_04DCE4:          ADC.B #$04                          ;; 04DCE4 : 69 04       ;
CODE_04DCE6:          STA $01                             ;; 04DCE6 : 85 01       ;
CODE_04DCE8:          LDX $00                             ;; 04DCE8 : A6 00       ;
CODE_04DCEA:          LDA.L $7EC800,X                     ;; 04DCEA : BF 00 C8 7E ;
CODE_04DCEE:          STA $02                             ;; 04DCEE : 85 02       ;
CODE_04DCF0:          REP #$20                            ;; 04DCF0 : C2 20       ; Accum (16 bit) 
CODE_04DCF2:          LDA.L $7FC800,X                     ;; 04DCF2 : BF 00 C8 7F ;
CODE_04DCF6:          STA $03                             ;; 04DCF6 : 85 03       ;
CODE_04DCF8:          LDA $02                             ;; 04DCF8 : A5 02       ;
CODE_04DCFA:          ASL                                 ;; 04DCFA : 0A          ;
CODE_04DCFB:          ASL                                 ;; 04DCFB : 0A          ;
CODE_04DCFC:          ASL                                 ;; 04DCFC : 0A          ;
CODE_04DCFD:          TAY                                 ;; 04DCFD : A8          ;
CODE_04DCFE:          LDA $00                             ;; 04DCFE : A5 00       ;
CODE_04DD00:          AND.W #$00FF                        ;; 04DD00 : 29 FF 00    ;
CODE_04DD03:          ASL                                 ;; 04DD03 : 0A          ;
CODE_04DD04:          ASL                                 ;; 04DD04 : 0A          ;
CODE_04DD05:          PHA                                 ;; 04DD05 : 48          ;
CODE_04DD06:          AND.W #$003F                        ;; 04DD06 : 29 3F 00    ;
CODE_04DD09:          STA $02                             ;; 04DD09 : 85 02       ;
CODE_04DD0B:          PLA                                 ;; 04DD0B : 68          ;
CODE_04DD0C:          ASL                                 ;; 04DD0C : 0A          ;
CODE_04DD0D:          AND.W #$0F80                        ;; 04DD0D : 29 80 0F    ;
CODE_04DD10:          ORA $02                             ;; 04DD10 : 05 02       ;
CODE_04DD12:          TAX                                 ;; 04DD12 : AA          ;
CODE_04DD13:          LDA [$65],Y                         ;; 04DD13 : B7 65       ;
CODE_04DD15:          STA.L $7EE400,X                     ;; 04DD15 : 9F 00 E4 7E ;
CODE_04DD19:          INY                                 ;; 04DD19 : C8          ;
CODE_04DD1A:          INY                                 ;; 04DD1A : C8          ;
CODE_04DD1B:          LDA [$65],Y                         ;; 04DD1B : B7 65       ;
CODE_04DD1D:          STA.L $7EE440,X                     ;; 04DD1D : 9F 40 E4 7E ;
CODE_04DD21:          INY                                 ;; 04DD21 : C8          ;
CODE_04DD22:          INY                                 ;; 04DD22 : C8          ;
CODE_04DD23:          LDA [$65],Y                         ;; 04DD23 : B7 65       ;
CODE_04DD25:          STA.L $7EE402,X                     ;; 04DD25 : 9F 02 E4 7E ;
CODE_04DD29:          INY                                 ;; 04DD29 : C8          ;
CODE_04DD2A:          INY                                 ;; 04DD2A : C8          ;
CODE_04DD2B:          LDA [$65],Y                         ;; 04DD2B : B7 65       ;
CODE_04DD2D:          STA.L $7EE442,X                     ;; 04DD2D : 9F 42 E4 7E ;
CODE_04DD31:          SEP #$20                            ;; 04DD31 : E2 20       ; Accum (8 bit) 
CODE_04DD33:          INC $00                             ;; 04DD33 : E6 00       ;
CODE_04DD35:          LDA $00                             ;; 04DD35 : A5 00       ;
CODE_04DD37:          AND.B #$FF                          ;; 04DD37 : 29 FF       ;
CODE_04DD39:          BNE CODE_04DCE8                     ;; 04DD39 : D0 AD       ;
CODE_04DD3B:          INC.W $1DE8                         ;; 04DD3B : EE E8 1D    ;
CODE_04DD3E:          PLP                                 ;; 04DD3E : 28          ;
Return04DD3F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04DD40:          REP #$10                            ;; 04DD40 : C2 10       ; Index (16 bit) 
CODE_04DD42:          SEP #$20                            ;; 04DD42 : E2 20       ; Accum (8 bit) 
CODE_04DD44:          LDY.W #$8D00                        ;; 04DD44 : A0 00 8D    ;
CODE_04DD47:          STY $02                             ;; 04DD47 : 84 02       ;
CODE_04DD49:          LDA.B #$0C                          ;; 04DD49 : A9 0C       ;
CODE_04DD4B:          STA $04                             ;; 04DD4B : 85 04       ;
CODE_04DD4D:          LDX.W #$0000                        ;; 04DD4D : A2 00 00    ;
CODE_04DD50:          TXY                                 ;; 04DD50 : 9B          ;
CODE_04DD51:          JSR.W CODE_04DD57                   ;; 04DD51 : 20 57 DD    ;
CODE_04DD54:          SEP #$30                            ;; 04DD54 : E2 30       ; Index (8 bit) Accum (8 bit) 
Return04DD56:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04DD57:          SEP #$20                            ;; 04DD57 : E2 20       ; Accum (8 bit) 
CODE_04DD59:          LDA [$02],Y                         ;; 04DD59 : B7 02       ;
CODE_04DD5B:          INY                                 ;; 04DD5B : C8          ;
CODE_04DD5C:          STA $05                             ;; 04DD5C : 85 05       ;
CODE_04DD5E:          AND.B #$80                          ;; 04DD5E : 29 80       ;
CODE_04DD60:          BNE CODE_04DD71                     ;; 04DD60 : D0 0F       ;
CODE_04DD62:          LDA [$02],Y                         ;; 04DD62 : B7 02       ;
CODE_04DD64:          STA.L $7F0000,X                     ;; 04DD64 : 9F 00 00 7F ;
CODE_04DD68:          INY                                 ;; 04DD68 : C8          ;
CODE_04DD69:          INX                                 ;; 04DD69 : E8          ;
CODE_04DD6A:          DEC $05                             ;; 04DD6A : C6 05       ;
CODE_04DD6C:          BPL CODE_04DD62                     ;; 04DD6C : 10 F4       ;
CODE_04DD6E:          JMP.W CODE_04DD83                   ;; 04DD6E : 4C 83 DD    ;
                                                          ;;                      ;
CODE_04DD71:          LDA $05                             ;; 04DD71 : A5 05       ;
CODE_04DD73:          AND.B #$7F                          ;; 04DD73 : 29 7F       ;
CODE_04DD75:          STA $05                             ;; 04DD75 : 85 05       ;
CODE_04DD77:          LDA [$02],Y                         ;; 04DD77 : B7 02       ;
CODE_04DD79:          STA.L $7F0000,X                     ;; 04DD79 : 9F 00 00 7F ;
CODE_04DD7D:          INX                                 ;; 04DD7D : E8          ;
CODE_04DD7E:          DEC $05                             ;; 04DD7E : C6 05       ;
CODE_04DD80:          BPL CODE_04DD79                     ;; 04DD80 : 10 F7       ;
CODE_04DD82:          INY                                 ;; 04DD82 : C8          ;
CODE_04DD83:          REP #$20                            ;; 04DD83 : C2 20       ; Accum (16 bit) 
CODE_04DD85:          LDA [$02],Y                         ;; 04DD85 : B7 02       ;
CODE_04DD87:          CMP.W #$FFFF                        ;; 04DD87 : C9 FF FF    ;
CODE_04DD8A:          BNE CODE_04DD57                     ;; 04DD8A : D0 CB       ;
Return04DD8C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04DD8D:          .db $00,$09                         ;; 04DD8D               ;
                                                          ;;                      ;
DATA_04DD8F:          .db $CC,$23,$04,$09,$8C,$23,$08,$09 ;; 04DD8F               ;
                      .db $4E,$23,$0C,$09,$0E,$23,$10,$09 ;; ?QPWZ?               ;
                      .db $D0,$22,$14,$09,$90,$22,$8C,$01 ;; ?QPWZ?               ;
                      .db $02,$22,$B0,$01,$02,$22,$D4,$01 ;; ?QPWZ?               ;
                      .db $02,$22,$44,$0A,$C6,$21,$48,$0A ;; ?QPWZ?               ;
                      .db $44,$20,$4C,$0A,$86,$21,$48,$0A ;; ?QPWZ?               ;
                      .db $04,$20,$00,$09,$E4,$23,$38,$09 ;; ?QPWZ?               ;
                      .db $A4,$23,$28,$09,$24,$23,$18,$09 ;; ?QPWZ?               ;
                      .db $26,$23,$1C,$09,$28,$23,$20,$09 ;; ?QPWZ?               ;
                      .db $EC,$22,$24,$09,$AC,$22,$0C,$0B ;; ?QPWZ?               ;
                      .db $2C,$22,$10,$0B,$EC,$21,$30,$09 ;; ?QPWZ?               ;
                      .db $6C,$21,$34,$09,$68,$21,$38,$09 ;; ?QPWZ?               ;
                      .db $E4,$20,$38,$09,$A4,$20,$3C,$09 ;; ?QPWZ?               ;
                      .db $90,$10,$40,$09,$4C,$10,$44,$09 ;; ?QPWZ?               ;
                      .db $0C,$10,$38,$09,$8C,$07,$38,$09 ;; ?QPWZ?               ;
                      .db $0C,$07,$28,$09,$8C,$06,$48,$09 ;; ?QPWZ?               ;
                      .db $14,$10,$4C,$09,$94,$07,$50,$09 ;; ?QPWZ?               ;
                      .db $54,$07,$38,$09,$0C,$06,$04,$09 ;; ?QPWZ?               ;
                      .db $8C,$05,$54,$09,$0E,$05,$E8,$09 ;; ?QPWZ?               ;
                      .db $48,$06,$E8,$09,$C8,$06,$98,$09 ;; ?QPWZ?               ;
                      .db $88,$06,$EC,$09,$12,$05,$F0,$09 ;; ?QPWZ?               ;
                      .db $D2,$04,$F4,$09,$92,$04,$00,$00 ;; ?QPWZ?               ;
                      .db $D8,$04,$24,$00,$98,$04,$48,$00 ;; ?QPWZ?               ;
                      .db $D8,$03,$6C,$00,$56,$03,$90,$00 ;; ?QPWZ?               ;
                      .db $56,$03,$B4,$00,$56,$03,$10,$05 ;; ?QPWZ?               ;
                      .db $18,$05,$28,$09,$24,$05,$38,$0B ;; ?QPWZ?               ;
                      .db $14,$07,$60,$09,$28,$05,$64,$09 ;; ?QPWZ?               ;
                      .db $6A,$05,$68,$09,$AC,$05,$6C,$09 ;; ?QPWZ?               ;
                      .db $2C,$06,$70,$09,$30,$06,$74,$09 ;; ?QPWZ?               ;
                      .db $B2,$05,$78,$09,$32,$05,$68,$01 ;; ?QPWZ?               ;
                      .db $FC,$07,$50,$0A,$C0,$0F,$D8,$00 ;; ?QPWZ?               ;
                      .db $7C,$07,$FC,$00,$7C,$07,$20,$01 ;; ?QPWZ?               ;
                      .db $7C,$07,$44,$01,$7C,$07,$50,$09 ;; ?QPWZ?               ;
                      .db $D4,$06,$4C,$09,$94,$06,$7C,$09 ;; ?QPWZ?               ;
                      .db $14,$06,$80,$09,$94,$05,$84,$09 ;; ?QPWZ?               ;
                      .db $18,$07,$88,$09,$1A,$07,$48,$09 ;; ?QPWZ?               ;
                      .db $9C,$07,$8C,$09,$1C,$10,$90,$09 ;; ?QPWZ?               ;
                      .db $60,$10,$94,$09,$64,$10,$38,$09 ;; ?QPWZ?               ;
                      .db $DC,$10,$98,$09,$84,$28,$A4,$09 ;; ?QPWZ?               ;
                      .db $18,$31,$84,$09,$1C,$31,$A8,$09 ;; ?QPWZ?               ;
                      .db $E0,$30,$4C,$09,$60,$30,$A0,$09 ;; ?QPWZ?               ;
                      .db $CA,$30,$A0,$09,$0E,$31,$B0,$09 ;; ?QPWZ?               ;
                      .db $10,$31,$B4,$09,$CC,$30,$B8,$09 ;; ?QPWZ?               ;
                      .db $8C,$30,$BC,$09,$0C,$30,$BC,$09 ;; ?QPWZ?               ;
                      .db $8C,$27,$BC,$09,$A0,$27,$BC,$09 ;; ?QPWZ?               ;
                      .db $20,$27,$AC,$09,$A0,$26,$28,$09 ;; ?QPWZ?               ;
                      .db $20,$26,$00,$0A,$64,$30,$04,$0A ;; ?QPWZ?               ;
                      .db $A8,$30,$08,$0A,$28,$31,$18,$09 ;; ?QPWZ?               ;
                      .db $22,$26,$98,$09,$26,$26,$C0,$09 ;; ?QPWZ?               ;
                      .db $2A,$26,$C4,$09,$6C,$26,$C8,$09 ;; ?QPWZ?               ;
                      .db $70,$26,$CC,$09,$B0,$26,$28,$09 ;; ?QPWZ?               ;
                      .db $30,$27,$D0,$09,$70,$27,$38,$09 ;; ?QPWZ?               ;
                      .db $B0,$27,$28,$09,$30,$30,$38,$09 ;; ?QPWZ?               ;
                      .db $B0,$30,$38,$09,$F0,$30,$D4,$09 ;; ?QPWZ?               ;
                      .db $B0,$31,$D8,$09,$2E,$32,$98,$09 ;; ?QPWZ?               ;
                      .db $2A,$32,$E0,$09,$CC,$26,$BC,$09 ;; ?QPWZ?               ;
                      .db $8C,$26,$E4,$09,$0C,$26,$DC,$09 ;; ?QPWZ?               ;
                      .db $04,$27,$DC,$09,$C0,$26,$DC,$09 ;; ?QPWZ?               ;
                      .db $40,$27,$98,$09,$B4,$01,$0C,$0B ;; ?QPWZ?               ;
                      .db $B8,$01,$30,$0B,$88,$09,$34,$0B ;; ?QPWZ?               ;
                      .db $A0,$09,$10,$0A,$8A,$09,$10,$0A ;; ?QPWZ?               ;
                      .db $9E,$09,$0C,$0A,$8C,$09,$0C,$0A ;; ?QPWZ?               ;
                      .db $9C,$09,$10,$0A,$8E,$09,$10,$0A ;; ?QPWZ?               ;
                      .db $9A,$09,$0C,$0A,$90,$09,$0C,$0A ;; ?QPWZ?               ;
                      .db $98,$09,$10,$0A,$92,$09,$10,$0A ;; ?QPWZ?               ;
                      .db $96,$09,$14,$0A,$A4,$09,$A8,$03 ;; ?QPWZ?               ;
                      .db $30,$08,$18,$0A,$AC,$09,$1C,$0A ;; ?QPWZ?               ;
                      .db $F0,$09,$9C,$09,$70,$0A,$20,$0A ;; ?QPWZ?               ;
                      .db $F0,$0A,$20,$0A,$70,$0B,$20,$0A ;; ?QPWZ?               ;
                      .db $F0,$0B,$24,$0A,$70,$0C,$38,$09 ;; ?QPWZ?               ;
                      .db $F0,$0C,$28,$0A,$30,$0D,$2C,$0A ;; ?QPWZ?               ;
                      .db $98,$0A,$30,$0A,$9C,$0A,$14,$0B ;; ?QPWZ?               ;
                      .db $10,$0B,$18,$0B,$90,$0B,$34,$0A ;; ?QPWZ?               ;
                      .db $1C,$0B,$38,$0A,$5E,$0B,$3C,$0A ;; ?QPWZ?               ;
                      .db $62,$0B,$40,$0A,$66,$0B,$20,$0A ;; ?QPWZ?               ;
                      .db $E8,$0A,$9C,$09,$68,$0A,$7C,$0A ;; ?QPWZ?               ;
                      .db $A4,$33,$7C,$0A,$E8,$33,$7C,$0A ;; ?QPWZ?               ;
                      .db $68,$34,$18,$09,$A2,$33,$C0,$09 ;; ?QPWZ?               ;
                      .db $A4,$33,$30,$09,$E8,$33,$54,$0A ;; ?QPWZ?               ;
                      .db $28,$34,$38,$09,$A8,$34,$7C,$0A ;; ?QPWZ?               ;
                      .db $98,$33,$7C,$0A,$9C,$33,$58,$0A ;; ?QPWZ?               ;
                      .db $9E,$33,$98,$09,$9C,$33,$28,$09 ;; ?QPWZ?               ;
                      .db $98,$33,$7C,$0A,$26,$36,$7C,$0A ;; ?QPWZ?               ;
                      .db $20,$36,$5C,$0A,$68,$35,$14,$09 ;; ?QPWZ?               ;
                      .db $A8,$35,$D8,$09,$26,$36,$1C,$09 ;; ?QPWZ?               ;
                      .db $24,$36,$28,$09,$20,$36,$7C,$0A ;; ?QPWZ?               ;
                      .db $2C,$35,$7C,$0A,$30,$35,$60,$0A ;; ?QPWZ?               ;
                      .db $2A,$35,$98,$09,$2C,$35,$98,$09 ;; ?QPWZ?               ;
                      .db $2E,$35,$98,$09,$30,$35,$7C,$0A ;; ?QPWZ?               ;
                      .db $DA,$35,$7C,$0A,$98,$34,$7C,$0A ;; ?QPWZ?               ;
                      .db $18,$34,$58,$0A,$1E,$36,$3C,$09 ;; ?QPWZ?               ;
                      .db $1C,$36,$64,$0A,$D8,$35,$44,$09 ;; ?QPWZ?               ;
                      .db $98,$35,$28,$09,$18,$35,$38,$09 ;; ?QPWZ?               ;
                      .db $98,$34,$38,$09,$18,$34,$28,$09 ;; ?QPWZ?               ;
                      .db $98,$33,$7C,$0A,$A0,$36,$7C,$0A ;; ?QPWZ?               ;
                      .db $60,$37,$D0,$09,$60,$36,$38,$09 ;; ?QPWZ?               ;
                      .db $E0,$36,$38,$09,$60,$37,$7C,$0A ;; ?QPWZ?               ;
                      .db $9C,$33,$18,$09,$9A,$33,$98,$09 ;; ?QPWZ?               ;
                      .db $9C,$33,$7C,$0A,$10,$35,$58,$0A ;; ?QPWZ?               ;
                      .db $96,$33,$6C,$0A,$92,$33,$70,$0A ;; ?QPWZ?               ;
                      .db $D0,$33,$74,$0A,$10,$34,$38,$09 ;; ?QPWZ?               ;
                      .db $90,$34,$28,$09,$10,$35,$7C,$0A ;; ?QPWZ?               ;
                      .db $1C,$35,$7C,$0A,$22,$35,$98,$09 ;; ?QPWZ?               ;
                      .db $14,$35,$28,$09,$18,$35,$98,$09 ;; ?QPWZ?               ;
                      .db $1C,$35,$98,$09,$20,$35,$98,$09 ;; ?QPWZ?               ;
                      .db $24,$35,$7C,$0A,$10,$36,$D0,$09 ;; ?QPWZ?               ;
                      .db $50,$35,$38,$09,$90,$35,$28,$09 ;; ?QPWZ?               ;
                      .db $10,$36,$7C,$0A,$90,$36,$7C,$0A ;; ?QPWZ?               ;
                      .db $0E,$37,$7C,$0A,$0A,$37,$7C,$0A ;; ?QPWZ?               ;
                      .db $02,$37,$D0,$09,$50,$36,$78,$0A ;; ?QPWZ?               ;
                      .db $D0,$36,$1C,$09,$0C,$37,$98,$09 ;; ?QPWZ?               ;
                      .db $08,$37,$98,$09,$04,$37,$98,$09 ;; ?QPWZ?               ;
                      .db $00,$37,$90,$0A,$12,$18,$94,$0A ;; ?QPWZ?               ;
                      .db $AA,$2B,$98,$0A,$A8,$2B,$9C,$0A ;; ?QPWZ?               ;
                      .db $A4,$2B,$94,$0A,$A2,$2B,$98,$0A ;; ?QPWZ?               ;
                      .db $A0,$2B,$A0,$0A,$64,$2B,$A4,$0A ;; ?QPWZ?               ;
                      .db $9A,$2B,$98,$0A,$98,$2B,$98,$0A ;; ?QPWZ?               ;
                      .db $96,$2B,$98,$0A,$94,$2B,$9C,$0A ;; ?QPWZ?               ;
                      .db $90,$2B,$A0,$0A,$5C,$2B,$A0,$0A ;; ?QPWZ?               ;
                      .db $50,$2B,$A8,$0A,$10,$2B,$9C,$0A ;; ?QPWZ?               ;
                      .db $90,$2A,$AC,$0A,$92,$2A,$98,$0A ;; ?QPWZ?               ;
                      .db $94,$2A,$98,$0A,$96,$2A,$98,$0A ;; ?QPWZ?               ;
                      .db $98,$2A,$A0,$0A,$50,$2A,$A8,$0A ;; ?QPWZ?               ;
                      .db $10,$2A,$3C,$0B,$90,$29,$40,$0B ;; ?QPWZ?               ;
                      .db $94,$29,$40,$0B,$98,$29,$A0,$0A ;; ?QPWZ?               ;
                      .db $5C,$2A,$A8,$0A,$1C,$2A,$A8,$0A ;; ?QPWZ?               ;
                      .db $DC,$29,$A0,$0A,$64,$2A,$A8,$0A ;; ?QPWZ?               ;
                      .db $24,$2A,$A8,$0A,$E4,$29,$B0,$0A ;; ?QPWZ?               ;
                      .db $90,$1D,$A0,$09,$8C,$1D,$B0,$0A ;; ?QPWZ?               ;
                      .db $56,$1E,$B4,$0A,$5A,$1E,$B8,$0A ;; ?QPWZ?               ;
                      .db $5C,$1D,$A0,$09,$18,$1D,$BC,$0A ;; ?QPWZ?               ;
                      .db $90,$1C,$BC,$0A,$0C,$1C,$A0,$09 ;; ?QPWZ?               ;
                      .db $0C,$1E,$C0,$0A,$8A,$1E,$C0,$0A ;; ?QPWZ?               ;
                      .db $86,$1E,$BC,$0A,$04,$1E,$A0,$09 ;; ?QPWZ?               ;
                      .db $84,$1D,$B8,$0A,$C6,$1C,$B0,$0A ;; ?QPWZ?               ;
                      .db $0C,$1D,$A0,$09,$88,$1D,$A0,$09 ;; ?QPWZ?               ;
                      .db $84,$1D,$B4,$0A,$80,$1D,$A0,$09 ;; ?QPWZ?               ;
                      .db $3C,$16,$A0,$09,$BC,$16,$A0,$09 ;; ?QPWZ?               ;
                      .db $B8,$16,$A0,$09,$B4,$16,$A0,$09 ;; ?QPWZ?               ;
                      .db $30,$16,$A8,$0A,$70,$15,$C4,$0A ;; ?QPWZ?               ;
                      .db $30,$15,$D8,$0A,$B8,$13,$4C,$09 ;; ?QPWZ?               ;
                      .db $B0,$14,$C8,$0A,$32,$14,$CC,$0A ;; ?QPWZ?               ;
                      .db $F4,$13,$D0,$0A,$B8,$13,$D4,$0A ;; ?QPWZ?               ;
                      .db $B8,$12,$F8,$01,$F4,$11,$1C,$02 ;; ?QPWZ?               ;
                      .db $F4,$11,$40,$02,$F4,$11,$64,$02 ;; ?QPWZ?               ;
                      .db $F4,$11,$88,$02,$F4,$11,$AC,$02 ;; ?QPWZ?               ;
                      .db $F4,$11,$D0,$02,$F4,$11,$F4,$02 ;; ?QPWZ?               ;
                      .db $F4,$11,$18,$03,$F4,$11,$3C,$03 ;; ?QPWZ?               ;
                      .db $B4,$11,$60,$03,$B4,$11,$3C,$03 ;; ?QPWZ?               ;
                      .db $B4,$11,$DC,$0A,$10,$3D,$E0,$0A ;; ?QPWZ?               ;
                      .db $CE,$3C,$E4,$0A,$8C,$3C,$E8,$0A ;; ?QPWZ?               ;
                      .db $48,$3C,$EC,$0A,$14,$3C,$F0,$0A ;; ?QPWZ?               ;
                      .db $D6,$3B,$F4,$0A,$98,$3B,$F8,$0A ;; ?QPWZ?               ;
                      .db $5A,$3B,$18,$09,$26,$3C,$98,$09 ;; ?QPWZ?               ;
                      .db $28,$3C,$98,$09,$2A,$3C,$98,$09 ;; ?QPWZ?               ;
                      .db $2C,$3C,$6C,$09,$28,$3D,$FC,$0A ;; ?QPWZ?               ;
                      .db $68,$3D,$00,$0B,$AA,$3D,$E4,$0A ;; ?QPWZ?               ;
                      .db $EC,$3D,$E4,$0A,$2E,$3E,$DC,$0A ;; ?QPWZ?               ;
                      .db $B0,$3E,$3C,$0B,$90,$29,$40,$0B ;; ?QPWZ?               ;
                      .db $94,$29,$40,$0B,$98,$29,$04,$0B ;; ?QPWZ?               ;
                      .db $9C,$3D,$08,$0B,$D8,$3D,$08,$0B ;; ?QPWZ?               ;
                      .db $14,$3E,$08,$0B,$50,$3E,$08,$0B ;; ?QPWZ?               ;
                      .db $8C,$3E,$6C,$09,$88,$3E,$44,$01 ;; ?QPWZ?               ;
                      .db $7C,$07,$38,$09,$E0,$19,$1C,$0B ;; ?QPWZ?               ;
                      .db $20,$1A,$CC,$03,$DC,$1A,$F0,$03 ;; ?QPWZ?               ;
                      .db $DC,$1A,$14,$04,$DC,$1A,$38,$04 ;; ?QPWZ?               ;
                      .db $9C,$1B,$5C,$04,$9C,$1B,$80,$04 ;; ?QPWZ?               ;
                      .db $5C,$1B,$A4,$04,$1C,$1B,$C8,$04 ;; ?QPWZ?               ;
                      .db $DC,$1A,$EC,$04,$9C,$1A,$58,$0A ;; ?QPWZ?               ;
                      .db $1E,$1B,$20,$0B,$1C,$1B,$24,$0B ;; ?QPWZ?               ;
                      .db $1A,$1B,$28,$0B,$18,$1B,$A0,$09 ;; ?QPWZ?               ;
                      .db $94,$1B,$A0,$09,$14,$1C,$A0,$09 ;; ?QPWZ?               ;
                      .db $94,$1C,$C0,$0A,$14,$1D,$2C,$0B ;; ?QPWZ?               ;
                      .db $56,$1D,$A0,$09,$D4,$1D,$98,$09 ;; ?QPWZ?               ;
                      .db $90,$39,$98,$09,$94,$39,$28,$09 ;; ?QPWZ?               ;
                      .db $98,$39,$98,$09,$9C,$39,$98,$09 ;; ?QPWZ?               ;
                      .db $A0,$39,$28,$09,$A4,$39,$98,$09 ;; ?QPWZ?               ;
                      .db $A8,$39,$98,$09,$AC,$39,$28,$09 ;; ?QPWZ?               ;
                      .db $B0,$39,$98,$09,$B4,$39,$98,$09 ;; ?QPWZ?               ;
                      .db $B4,$38,$28,$09,$B0,$38,$98,$09 ;; ?QPWZ?               ;
                      .db $AC,$38,$98,$09,$A8,$38,$28,$09 ;; ?QPWZ?               ;
                      .db $A4,$38,$98,$09,$A0,$38,$98,$09 ;; ?QPWZ?               ;
                      .db $9C,$38,$28,$09,$98,$38,$98,$09 ;; ?QPWZ?               ;
                      .db $94,$38,$98,$09,$90,$38,$28,$09 ;; ?QPWZ?               ;
                      .db $8C,$38,$98,$09,$88,$38,$28,$09 ;; ?QPWZ?               ;
                      .db $84,$38                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04E359:          .db $00,$00                         ;; 04E359               ;
                                                          ;;                      ;
DATA_04E35B:          .db $00,$00,$0D,$00,$0D,$00,$10,$00 ;; 04E35B               ;
                      .db $15,$00,$18,$00,$1A,$00,$20,$00 ;; ?QPWZ?               ;
                      .db $23,$00,$26,$00,$29,$00,$2C,$00 ;; ?QPWZ?               ;
                      .db $35,$00,$39,$00,$3A,$00,$42,$00 ;; ?QPWZ?               ;
                      .db $46,$00,$4A,$00,$4C,$00,$4D,$00 ;; ?QPWZ?               ;
                      .db $4E,$00,$52,$00,$59,$00,$5D,$00 ;; ?QPWZ?               ;
                      .db $60,$00,$67,$00,$6A,$00,$6C,$00 ;; ?QPWZ?               ;
                      .db $6F,$00,$72,$00,$75,$00,$77,$00 ;; ?QPWZ?               ;
                      .db $77,$00,$83,$00,$83,$00,$84,$00 ;; ?QPWZ?               ;
                      .db $8E,$00,$90,$00,$92,$00,$98,$00 ;; ?QPWZ?               ;
                      .db $98,$00,$98,$00,$A0,$00,$A5,$00 ;; ?QPWZ?               ;
                      .db $AC,$00,$B2,$00,$BD,$00,$C2,$00 ;; ?QPWZ?               ;
                      .db $C5,$00,$CC,$00,$D3,$00,$D7,$00 ;; ?QPWZ?               ;
                      .db $E1,$00,$E2,$00,$E2,$00,$E2,$00 ;; ?QPWZ?               ;
                      .db $E5,$00,$E7,$00,$E8,$00,$ED,$00 ;; ?QPWZ?               ;
                      .db $EE,$00,$F1,$00,$F5,$00,$FA,$00 ;; ?QPWZ?               ;
                      .db $FD,$00,$00,$01,$00,$01,$00,$01 ;; ?QPWZ?               ;
                      .db $00,$01,$00,$01,$02,$01,$08,$01 ;; ?QPWZ?               ;
                      .db $0F,$01,$12,$01,$14,$01,$16,$01 ;; ?QPWZ?               ;
                      .db $17,$01,$1E,$01,$2B,$01,$2B,$01 ;; ?QPWZ?               ;
                      .db $2B,$01,$2B,$01,$2F,$01,$2F,$01 ;; ?QPWZ?               ;
                      .db $2F,$01,$33,$01,$33,$01,$33,$01 ;; ?QPWZ?               ;
                      .db $37,$01,$37,$01,$37,$01,$40,$01 ;; ?QPWZ?               ;
                      .db $40,$01,$46,$01,$46,$01,$46,$01 ;; ?QPWZ?               ;
                      .db $47,$01,$52,$01,$56,$01,$5C,$01 ;; ?QPWZ?               ;
                      .db $5C,$01,$5F,$01,$62,$01,$65,$01 ;; ?QPWZ?               ;
                      .db $68,$01,$6B,$01,$6E,$01,$71,$01 ;; ?QPWZ?               ;
                      .db $73,$01,$73,$01,$73,$01,$73,$01 ;; ?QPWZ?               ;
                      .db $73,$01,$73,$01,$73,$01,$73,$01 ;; ?QPWZ?               ;
                      .db $73,$01,$73,$01,$73,$01,$73,$01 ;; ?QPWZ?               ;
DATA_04E44B:          .db $80,$40,$20,$10,$08,$04,$02,$01 ;; 04E44B               ;
                                                          ;;                      ;
CODE_04E453:          SEP #$30                            ;; 04E453 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04E455:          LDA $0F                             ;; 04E455 : A5 0F       ;
CODE_04E457:          AND.B #$07                          ;; 04E457 : 29 07       ;
CODE_04E459:          TAX                                 ;; 04E459 : AA          ;
CODE_04E45A:          LDA $0F                             ;; 04E45A : A5 0F       ;
CODE_04E45C:          LSR                                 ;; 04E45C : 4A          ;
CODE_04E45D:          LSR                                 ;; 04E45D : 4A          ;
CODE_04E45E:          LSR                                 ;; 04E45E : 4A          ;
CODE_04E45F:          TAY                                 ;; 04E45F : A8          ;
CODE_04E460:          LDA.W $1F02,Y                       ;; 04E460 : B9 02 1F    ;
CODE_04E463:          AND.L DATA_04E44B,X                 ;; 04E463 : 3F 4B E4 04 ;
CODE_04E467:          BNE CODE_04E46A                     ;; 04E467 : D0 01       ;
Return04E469:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E46A:          LDA $0F                             ;; 04E46A : A5 0F       ;
CODE_04E46C:          ASL                                 ;; 04E46C : 0A          ;
CODE_04E46D:          TAX                                 ;; 04E46D : AA          ;
CODE_04E46E:          REP #$20                            ;; 04E46E : C2 20       ; Accum (16 bit) 
CODE_04E470:          LDA.L DATA_04E359,X                 ;; 04E470 : BF 59 E3 04 ;
CODE_04E474:          STA.W $1DEB                         ;; 04E474 : 8D EB 1D    ;
CODE_04E477:          LDA.L DATA_04E35B,X                 ;; 04E477 : BF 5B E3 04 ;
CODE_04E47B:          STA.W $1DED                         ;; 04E47B : 8D ED 1D    ;
CODE_04E47E:          CMP.W $1DEB                         ;; 04E47E : CD EB 1D    ;
CODE_04E481:          BEQ CODE_04E493                     ;; 04E481 : F0 10       ;
CODE_04E483:          JSR.W CODE_04E496                   ;; 04E483 : 20 96 E4    ;
CODE_04E486:          REP #$20                            ;; 04E486 : C2 20       ; Accum (16 bit) 
CODE_04E488:          INC.W $1DEB                         ;; 04E488 : EE EB 1D    ;
CODE_04E48B:          LDA.W $1DEB                         ;; 04E48B : AD EB 1D    ;
CODE_04E48E:          CMP.W $1DED                         ;; 04E48E : CD ED 1D    ;
CODE_04E491:          BNE CODE_04E483                     ;; 04E491 : D0 F0       ;
CODE_04E493:          SEP #$30                            ;; 04E493 : E2 30       ; Index (8 bit) Accum (8 bit) 
Return04E495:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E496:          REP #$30                            ;; 04E496 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04E498:          LDA.W $1DEB                         ;; 04E498 : AD EB 1D    ;
CODE_04E49B:          ASL                                 ;; 04E49B : 0A          ;
CODE_04E49C:          ASL                                 ;; 04E49C : 0A          ;
CODE_04E49D:          TAX                                 ;; 04E49D : AA          ;
CODE_04E49E:          LDA.L DATA_04DD8D,X                 ;; 04E49E : BF 8D DD 04 ;
CODE_04E4A2:          TAY                                 ;; 04E4A2 : A8          ;
CODE_04E4A3:          LDA.L DATA_04DD8F,X                 ;; 04E4A3 : BF 8F DD 04 ;
CODE_04E4A7:          STA $04                             ;; 04E4A7 : 85 04       ;
CODE_04E4A9:          SEP #$20                            ;; 04E4A9 : E2 20       ; Accum (8 bit) 
CODE_04E4AB:          LDA.B #$7F                          ;; 04E4AB : A9 7F       ;
CODE_04E4AD:          STA $08                             ;; 04E4AD : 85 08       ;
CODE_04E4AF:          LDA.B #$0C                          ;; 04E4AF : A9 0C       ;
CODE_04E4B1:          STA $0B                             ;; 04E4B1 : 85 0B       ;
CODE_04E4B3:          REP #$20                            ;; 04E4B3 : C2 20       ; Accum (16 bit) 
CODE_04E4B5:          LDA.W #$0000                        ;; 04E4B5 : A9 00 00    ;
CODE_04E4B8:          STA $06                             ;; 04E4B8 : 85 06       ;
CODE_04E4BA:          LDA.W #$8000                        ;; 04E4BA : A9 00 80    ;
CODE_04E4BD:          STA $09                             ;; 04E4BD : 85 09       ;
CODE_04E4BF:          CPY.W #$0900                        ;; 04E4BF : C0 00 09    ;
CODE_04E4C2:          BCC CODE_04E4CA                     ;; 04E4C2 : 90 06       ;
CODE_04E4C4:          JSR.W CODE_04E4D0                   ;; 04E4C4 : 20 D0 E4    ;
CODE_04E4C7:          JMP.W CODE_04E4CD                   ;; 04E4C7 : 4C CD E4    ;
                                                          ;;                      ;
CODE_04E4CA:          JSR.W CODE_04E520                   ;; 04E4CA : 20 20 E5    ;
CODE_04E4CD:          SEP #$30                            ;; 04E4CD : E2 30       ; Index (8 bit) Accum (8 bit) 
Return04E4CF:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E4D0:          LDA.W #$0001                        ;; 04E4D0 : A9 01 00    ; Accum (16 bit) 
CODE_04E4D3:          STA $00                             ;; 04E4D3 : 85 00       ;
CODE_04E4D5:          LDX $04                             ;; 04E4D5 : A6 04       ;
CODE_04E4D7:          LDA.W #$0001                        ;; 04E4D7 : A9 01 00    ;
CODE_04E4DA:          STA $0C                             ;; 04E4DA : 85 0C       ;
CODE_04E4DC:          SEP #$20                            ;; 04E4DC : E2 20       ; Accum (8 bit) 
CODE_04E4DE:          LDA [$09],Y                         ;; 04E4DE : B7 09       ;
CODE_04E4E0:          STA.L $7F4000,X                     ;; 04E4E0 : 9F 00 40 7F ;
CODE_04E4E4:          INX                                 ;; 04E4E4 : E8          ;
CODE_04E4E5:          LDA [$06],Y                         ;; 04E4E5 : B7 06       ;
CODE_04E4E7:          STA.L $7F4000,X                     ;; 04E4E7 : 9F 00 40 7F ;
CODE_04E4EB:          INY                                 ;; 04E4EB : C8          ;
CODE_04E4EC:          INX                                 ;; 04E4EC : E8          ;
CODE_04E4ED:          REP #$20                            ;; 04E4ED : C2 20       ; Accum (16 bit) 
CODE_04E4EF:          TXA                                 ;; 04E4EF : 8A          ;
CODE_04E4F0:          AND.W #$003F                        ;; 04E4F0 : 29 3F 00    ;
CODE_04E4F3:          BNE CODE_04E4FF                     ;; 04E4F3 : D0 0A       ;
CODE_04E4F5:          DEX                                 ;; 04E4F5 : CA          ;
CODE_04E4F6:          TXA                                 ;; 04E4F6 : 8A          ;
CODE_04E4F7:          AND.W #$FFC0                        ;; 04E4F7 : 29 C0 FF    ;
CODE_04E4FA:          CLC                                 ;; 04E4FA : 18          ;
CODE_04E4FB:          ADC.W #$0800                        ;; 04E4FB : 69 00 08    ;
CODE_04E4FE:          TAX                                 ;; 04E4FE : AA          ;
CODE_04E4FF:          DEC $0C                             ;; 04E4FF : C6 0C       ;
CODE_04E501:          BPL CODE_04E4DC                     ;; 04E501 : 10 D9       ;
CODE_04E503:          LDA $04                             ;; 04E503 : A5 04       ;
CODE_04E505:          TAX                                 ;; 04E505 : AA          ;
CODE_04E506:          CLC                                 ;; 04E506 : 18          ;
CODE_04E507:          ADC.W #$0040                        ;; 04E507 : 69 40 00    ;
CODE_04E50A:          STA $04                             ;; 04E50A : 85 04       ;
CODE_04E50C:          AND.W #$07C0                        ;; 04E50C : 29 C0 07    ;
CODE_04E50F:          BNE CODE_04E51B                     ;; 04E50F : D0 0A       ;
CODE_04E511:          TXA                                 ;; 04E511 : 8A          ;
CODE_04E512:          AND.W #$F83F                        ;; 04E512 : 29 3F F8    ;
CODE_04E515:          CLC                                 ;; 04E515 : 18          ;
CODE_04E516:          ADC.W #$1000                        ;; 04E516 : 69 00 10    ;
CODE_04E519:          STA $04                             ;; 04E519 : 85 04       ;
CODE_04E51B:          DEC $00                             ;; 04E51B : C6 00       ;
CODE_04E51D:          BPL CODE_04E4D5                     ;; 04E51D : 10 B6       ;
Return04E51F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E520:          LDA.W #$0005                        ;; 04E520 : A9 05 00    ;
CODE_04E523:          STA $00                             ;; 04E523 : 85 00       ;
CODE_04E525:          LDX $04                             ;; 04E525 : A6 04       ;
CODE_04E527:          LDA.W #$0005                        ;; 04E527 : A9 05 00    ;
CODE_04E52A:          STA $0C                             ;; 04E52A : 85 0C       ;
CODE_04E52C:          SEP #$20                            ;; 04E52C : E2 20       ; Accum (8 bit) 
CODE_04E52E:          LDA [$09],Y                         ;; 04E52E : B7 09       ;
CODE_04E530:          STA.L $7F4000,X                     ;; 04E530 : 9F 00 40 7F ;
CODE_04E534:          INX                                 ;; 04E534 : E8          ;
CODE_04E535:          LDA [$06],Y                         ;; 04E535 : B7 06       ;
CODE_04E537:          STA.L $7F4000,X                     ;; 04E537 : 9F 00 40 7F ;
CODE_04E53B:          INY                                 ;; 04E53B : C8          ;
CODE_04E53C:          INX                                 ;; 04E53C : E8          ;
CODE_04E53D:          REP #$20                            ;; 04E53D : C2 20       ; Accum (16 bit) 
CODE_04E53F:          TXA                                 ;; 04E53F : 8A          ;
CODE_04E540:          AND.W #$003F                        ;; 04E540 : 29 3F 00    ;
CODE_04E543:          BNE CODE_04E54F                     ;; 04E543 : D0 0A       ;
CODE_04E545:          DEX                                 ;; 04E545 : CA          ;
CODE_04E546:          TXA                                 ;; 04E546 : 8A          ;
CODE_04E547:          AND.W #$FFC0                        ;; 04E547 : 29 C0 FF    ;
CODE_04E54A:          CLC                                 ;; 04E54A : 18          ;
CODE_04E54B:          ADC.W #$0800                        ;; 04E54B : 69 00 08    ;
CODE_04E54E:          TAX                                 ;; 04E54E : AA          ;
CODE_04E54F:          DEC $0C                             ;; 04E54F : C6 0C       ;
CODE_04E551:          BPL CODE_04E52C                     ;; 04E551 : 10 D9       ;
CODE_04E553:          LDA $04                             ;; 04E553 : A5 04       ;
CODE_04E555:          TAX                                 ;; 04E555 : AA          ;
CODE_04E556:          CLC                                 ;; 04E556 : 18          ;
CODE_04E557:          ADC.W #$0040                        ;; 04E557 : 69 40 00    ;
CODE_04E55A:          STA $04                             ;; 04E55A : 85 04       ;
CODE_04E55C:          AND.W #$07C0                        ;; 04E55C : 29 C0 07    ;
CODE_04E55F:          BNE CODE_04E56B                     ;; 04E55F : D0 0A       ;
CODE_04E561:          TXA                                 ;; 04E561 : 8A          ;
CODE_04E562:          AND.W #$F83F                        ;; 04E562 : 29 3F F8    ;
CODE_04E565:          CLC                                 ;; 04E565 : 18          ;
CODE_04E566:          ADC.W #$1000                        ;; 04E566 : 69 00 10    ;
CODE_04E569:          STA $04                             ;; 04E569 : 85 04       ;
CODE_04E56B:          DEC $00                             ;; 04E56B : C6 00       ;
CODE_04E56D:          BPL CODE_04E525                     ;; 04E56D : 10 B6       ;
Return04E56F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E570:          LDA.W $1B86                         ;; 04E570 : AD 86 1B    ;
CODE_04E573:          JSL.L ExecutePtr                    ;; 04E573 : 22 DF 86 00 ;
                                                          ;;                      ;
Ptrs04E577:           .dw CODE_04E5EE                     ;; ?QPWZ? : EE E5       ;
                      .dw CODE_04EBEB                     ;; ?QPWZ? : EB EB       ;
                      .dw CODE_04E6D3                     ;; ?QPWZ? : D3 E6       ;
                      .dw CODE_04E6F9                     ;; ?QPWZ? : F9 E6       ;
                      .dw CODE_04EAA4                     ;; ?QPWZ? : A4 EA       ;
                      .dw CODE_04EC78                     ;; ?QPWZ? : 78 EC       ;
                      .dw CODE_04EBEB                     ;; ?QPWZ? : EB EB       ;
                      .dw CODE_04E9EC                     ;; ?QPWZ? : EC E9       ;
                                                          ;;                      ;
DATA_04E587:          .db $20,$52,$22,$DA,$28,$58,$24,$C0 ;; 04E587               ;
                      .db $24,$94,$23,$42,$28,$94,$2A,$98 ;; ?QPWZ?               ;
                      .db $25,$0E,$25,$52,$25,$C4,$2A,$DE ;; ?QPWZ?               ;
                      .db $2A,$98,$28,$44,$2C,$50,$2C,$0C ;; ?QPWZ?               ;
DATA_04E5A7:          .db $77,$79,$58,$4C,$A6             ;; 04E5A7               ;
                                                          ;;                      ;
DATA_04E5AC:          .db $85,$86,$00,$10,$00             ;; 04E5AC               ;
                                                          ;;                      ;
DATA_04E5B1:          .db $85,$86,$81,$81,$81             ;; 04E5B1               ;
                                                          ;;                      ;
DATA_04E5B6:          .db $19,$04,$BD,$00,$1C,$06,$30,$01 ;; 04E5B6               ;
                      .db $2A,$01,$D1,$00,$2A,$06,$AC,$06 ;; ?QPWZ?               ;
                      .db $47,$05,$59,$05,$72,$05,$BF,$02 ;; ?QPWZ?               ;
                      .db $AC,$02,$12,$02,$18,$03,$06,$03 ;; ?QPWZ?               ;
DATA_04E5D6:          .db $06,$0F,$1C,$21,$24,$28,$29,$37 ;; 04E5D6               ;
                      .db $40,$41,$43,$4A,$4D,$02,$61,$35 ;; ?QPWZ?               ;
DATA_04E5E6:          .db $58,$59,$5D,$63,$77,$79,$7E,$80 ;; 04E5E6               ;
                                                          ;;                      ;
CODE_04E5EE:          LDA.W $0DD5                         ;; 04E5EE : AD D5 0D    ; Accum (8 bit) 
CODE_04E5F1:          CMP.B #$02                          ;; 04E5F1 : C9 02       ;
CODE_04E5F3:          BNE CODE_04E5F8                     ;; 04E5F3 : D0 03       ;
CODE_04E5F5:          INC.W $1DEA                         ;; 04E5F5 : EE EA 1D    ;
CODE_04E5F8:          LDA.W $1DE9                         ;; 04E5F8 : AD E9 1D    ;
CODE_04E5FB:          BEQ CODE_04E61A                     ;; 04E5FB : F0 1D       ;
CODE_04E5FD:          LDA.W $1DEA                         ;; 04E5FD : AD EA 1D    ;
CODE_04E600:          CMP.B #$FF                          ;; 04E600 : C9 FF       ;
CODE_04E602:          BEQ CODE_04E61A                     ;; 04E602 : F0 16       ;
CODE_04E604:          LDA.W $1DEA                         ;; 04E604 : AD EA 1D    ;
CODE_04E607:          AND.B #$07                          ;; 04E607 : 29 07       ;
CODE_04E609:          TAX                                 ;; 04E609 : AA          ;
CODE_04E60A:          LDA.W $1DEA                         ;; 04E60A : AD EA 1D    ;
CODE_04E60D:          LSR                                 ;; 04E60D : 4A          ;
CODE_04E60E:          LSR                                 ;; 04E60E : 4A          ;
CODE_04E60F:          LSR                                 ;; 04E60F : 4A          ;
CODE_04E610:          TAY                                 ;; 04E610 : A8          ;
CODE_04E611:          LDA.W $1F02,Y                       ;; 04E611 : B9 02 1F    ;
CODE_04E614:          AND.L DATA_04E44B,X                 ;; 04E614 : 3F 4B E4 04 ;
CODE_04E618:          BEQ CODE_04E640                     ;; 04E618 : F0 26       ;
CODE_04E61A:          LDX.B #$07                          ;; 04E61A : A2 07       ;
CODE_04E61C:          LDA.W DATA_04E5E6,X                 ;; 04E61C : BD E6 E5    ;
CODE_04E61F:          CMP.W $13C1                         ;; 04E61F : CD C1 13    ;
CODE_04E622:          BNE CODE_04E632                     ;; 04E622 : D0 0E       ;
ADDR_04E624:          INC.W $13D9                         ;; 04E624 : EE D9 13    ;
ADDR_04E627:          LDA.B #$E0                          ;; 04E627 : A9 E0       ;
ADDR_04E629:          STA.W $0DD5                         ;; 04E629 : 8D D5 0D    ;
ADDR_04E62C:          LDA.B #$0F                          ;; 04E62C : A9 0F       ;
ADDR_04E62E:          STA.W $0DB1                         ;; 04E62E : 8D B1 0D    ;
Return04E631:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E632:          DEX                                 ;; 04E632 : CA          ;
CODE_04E633:          BPL CODE_04E61C                     ;; 04E633 : 10 E7       ;
CODE_04E635:          LDA.B #$05                          ;; 04E635 : A9 05       ;
CODE_04E637:          STA.W $13D9                         ;; 04E637 : 8D D9 13    ;
CODE_04E63A:          LDA.B #$80                          ;; 04E63A : A9 80       ;
CODE_04E63C:          STA.W $0DD5                         ;; 04E63C : 8D D5 0D    ;
Return04E63F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E640:          INC.W $1B86                         ;; 04E640 : EE 86 1B    ;
CODE_04E643:          LDA.W $1DEA                         ;; 04E643 : AD EA 1D    ;
CODE_04E646:          JSR.W CODE_04E677                   ;; 04E646 : 20 77 E6    ;
CODE_04E649:          TYA                                 ;; 04E649 : 98          ;
CODE_04E64A:          ASL                                 ;; 04E64A : 0A          ;
CODE_04E64B:          ASL                                 ;; 04E64B : 0A          ;
CODE_04E64C:          ASL                                 ;; 04E64C : 0A          ;
CODE_04E64D:          ASL                                 ;; 04E64D : 0A          ;
CODE_04E64E:          STA.W $1B82                         ;; 04E64E : 8D 82 1B    ;
CODE_04E651:          TYA                                 ;; 04E651 : 98          ;
CODE_04E652:          AND.B #$F0                          ;; 04E652 : 29 F0       ;
CODE_04E654:          STA.W $1B83                         ;; 04E654 : 8D 83 1B    ;
CODE_04E657:          LDA.B #$28                          ;; 04E657 : A9 28       ;
CODE_04E659:          STA.W $1B84                         ;; 04E659 : 8D 84 1B    ;
CODE_04E65C:          LDA.W $13BF                         ;; 04E65C : AD BF 13    ;
CODE_04E65F:          CMP.B #$18                          ;; 04E65F : C9 18       ;
CODE_04E661:          BNE CODE_04E668                     ;; 04E661 : D0 05       ;
CODE_04E663:          LDA.B #$FF                          ;; 04E663 : A9 FF       ;
CODE_04E665:          STA.W $1BA0                         ;; 04E665 : 8D A0 1B    ;
CODE_04E668:          LDA.W $1B86                         ;; 04E668 : AD 86 1B    ;
CODE_04E66B:          CMP.B #$02                          ;; 04E66B : C9 02       ;
CODE_04E66D:          BEQ CODE_04E674                     ;; 04E66D : F0 05       ;
CODE_04E66F:          LDA.B #$16                          ;; 04E66F : A9 16       ;
CODE_04E671:          STA.W $1DFC                         ;; 04E671 : 8D FC 1D    ; / Play sound effect 
CODE_04E674:          SEP #$30                            ;; 04E674 : E2 30       ; Index (8 bit) Accum (8 bit) 
Return04E676:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E677:          SEP #$30                            ;; 04E677 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04E679:          LDX.B #$17                          ;; 04E679 : A2 17       ;
CODE_04E67B:          CMP.L DATA_04E5D6,X                 ;; 04E67B : DF D6 E5 04 ;
CODE_04E67F:          BEQ CODE_04E68A                     ;; 04E67F : F0 09       ;
CODE_04E681:          DEX                                 ;; 04E681 : CA          ;
CODE_04E682:          BPL CODE_04E67B                     ;; 04E682 : 10 F7       ;
CODE_04E684:          LDA.B #$02                          ;; 04E684 : A9 02       ;
CODE_04E686:          STA.W $1B86                         ;; 04E686 : 8D 86 1B    ;
Return04E689:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E68A:          STX.W $13D1                         ;; 04E68A : 8E D1 13    ;
CODE_04E68D:          TXA                                 ;; 04E68D : 8A          ;
CODE_04E68E:          ASL                                 ;; 04E68E : 0A          ;
CODE_04E68F:          TAX                                 ;; 04E68F : AA          ;
CODE_04E690:          LDA.B #$7E                          ;; 04E690 : A9 7E       ;
CODE_04E692:          STA $0C                             ;; 04E692 : 85 0C       ;
CODE_04E694:          REP #$30                            ;; 04E694 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04E696:          LDA.W #$C800                        ;; 04E696 : A9 00 C8    ;
CODE_04E699:          STA $0A                             ;; 04E699 : 85 0A       ;
CODE_04E69B:          LDA.L DATA_04E5B6,X                 ;; 04E69B : BF B6 E5 04 ;
CODE_04E69F:          TAY                                 ;; 04E69F : A8          ;
CODE_04E6A0:          SEP #$20                            ;; 04E6A0 : E2 20       ; Accum (8 bit) 
CODE_04E6A2:          LDX.W #$0004                        ;; 04E6A2 : A2 04 00    ;
CODE_04E6A5:          LDA [$0A],Y                         ;; 04E6A5 : B7 0A       ;
CODE_04E6A7:          CMP.L DATA_04E5A7,X                 ;; 04E6A7 : DF A7 E5 04 ;
CODE_04E6AB:          BEQ CODE_04E6B3                     ;; 04E6AB : F0 06       ;
CODE_04E6AD:          DEX                                 ;; 04E6AD : CA          ;
CODE_04E6AE:          BPL CODE_04E6A7                     ;; 04E6AE : 10 F7       ;
CODE_04E6B0:          JMP.W CODE_04E684                   ;; 04E6B0 : 4C 84 E6    ;
                                                          ;;                      ;
CODE_04E6B3:          TXA                                 ;; 04E6B3 : 8A          ;
CODE_04E6B4:          STA.W $13D0                         ;; 04E6B4 : 8D D0 13    ;
CODE_04E6B7:          CPX.W #$0003                        ;; 04E6B7 : E0 03 00    ;
CODE_04E6BA:          BMI CODE_04E6CA                     ;; 04E6BA : 30 0E       ;
CODE_04E6BC:          LDA.L DATA_04E5AC,X                 ;; 04E6BC : BF AC E5 04 ;
CODE_04E6C0:          STA [$0A],Y                         ;; 04E6C0 : 97 0A       ;
CODE_04E6C2:          REP #$20                            ;; 04E6C2 : C2 20       ; Accum (16 bit) 
CODE_04E6C4:          TYA                                 ;; 04E6C4 : 98          ;
CODE_04E6C5:          CLC                                 ;; 04E6C5 : 18          ;
CODE_04E6C6:          ADC.W #$0010                        ;; 04E6C6 : 69 10 00    ;
CODE_04E6C9:          TAY                                 ;; 04E6C9 : A8          ;
CODE_04E6CA:          SEP #$20                            ;; 04E6CA : E2 20       ; Accum (8 bit) 
CODE_04E6CC:          LDA.L DATA_04E5B1,X                 ;; 04E6CC : BF B1 E5 04 ;
CODE_04E6D0:          STA [$0A],Y                         ;; 04E6D0 : 97 0A       ;
Return04E6D2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E6D3:          INC.W $1B86                         ;; 04E6D3 : EE 86 1B    ;
CODE_04E6D6:          LDA.W $1DEA                         ;; 04E6D6 : AD EA 1D    ;
CODE_04E6D9:          ASL                                 ;; 04E6D9 : 0A          ;
CODE_04E6DA:          TAX                                 ;; 04E6DA : AA          ;
CODE_04E6DB:          REP #$20                            ;; 04E6DB : C2 20       ; Accum (16 bit) 
CODE_04E6DD:          LDA.L DATA_04E359,X                 ;; 04E6DD : BF 59 E3 04 ;
CODE_04E6E1:          STA.W $1DEB                         ;; 04E6E1 : 8D EB 1D    ;
CODE_04E6E4:          LDA.L DATA_04E35B,X                 ;; 04E6E4 : BF 5B E3 04 ;
CODE_04E6E8:          STA.W $1DED                         ;; 04E6E8 : 8D ED 1D    ;
CODE_04E6EB:          CMP.W $1DEB                         ;; 04E6EB : CD EB 1D    ;
CODE_04E6EE:          SEP #$20                            ;; 04E6EE : E2 20       ; Accum (8 bit) 
CODE_04E6F0:          BNE Return04E6F8                    ;; 04E6F0 : D0 06       ;
CODE_04E6F2:          INC.W $1B86                         ;; 04E6F2 : EE 86 1B    ;
CODE_04E6F5:          INC.W $1B86                         ;; 04E6F5 : EE 86 1B    ;
Return04E6F8:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E6F9:          JSR.W CODE_04EA62                   ;; 04E6F9 : 20 62 EA    ;
CODE_04E6FC:          LDA.B #$7F                          ;; 04E6FC : A9 7F       ;
CODE_04E6FE:          STA $0E                             ;; 04E6FE : 85 0E       ;
CODE_04E700:          REP #$30                            ;; 04E700 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04E702:          LDA.W $1DEB                         ;; 04E702 : AD EB 1D    ;
CODE_04E705:          ASL                                 ;; 04E705 : 0A          ;
CODE_04E706:          ASL                                 ;; 04E706 : 0A          ;
CODE_04E707:          TAX                                 ;; 04E707 : AA          ;
CODE_04E708:          LDA.L DATA_04DD8D,X                 ;; 04E708 : BF 8D DD 04 ;
CODE_04E70C:          STA.W $1B84                         ;; 04E70C : 8D 84 1B    ;
CODE_04E70F:          LDA.L DATA_04DD8F,X                 ;; 04E70F : BF 8F DD 04 ;
CODE_04E713:          STA $00                             ;; 04E713 : 85 00       ;
CODE_04E715:          AND.W #$1FFF                        ;; 04E715 : 29 FF 1F    ;
CODE_04E718:          LSR                                 ;; 04E718 : 4A          ;
CODE_04E719:          CLC                                 ;; 04E719 : 18          ;
CODE_04E71A:          ADC.W #$3000                        ;; 04E71A : 69 00 30    ;
CODE_04E71D:          XBA                                 ;; 04E71D : EB          ;
CODE_04E71E:          STA $02                             ;; 04E71E : 85 02       ;
CODE_04E720:          LDA $00                             ;; 04E720 : A5 00       ;
CODE_04E722:          LSR                                 ;; 04E722 : 4A          ;
CODE_04E723:          LSR                                 ;; 04E723 : 4A          ;
CODE_04E724:          LSR                                 ;; 04E724 : 4A          ;
CODE_04E725:          SEP #$20                            ;; 04E725 : E2 20       ; Accum (8 bit) 
CODE_04E727:          AND.B #$F8                          ;; 04E727 : 29 F8       ;
CODE_04E729:          STA.W $1B83                         ;; 04E729 : 8D 83 1B    ;
CODE_04E72C:          LDA $00                             ;; 04E72C : A5 00       ;
CODE_04E72E:          AND.B #$3E                          ;; 04E72E : 29 3E       ;
CODE_04E730:          ASL                                 ;; 04E730 : 0A          ;
CODE_04E731:          ASL                                 ;; 04E731 : 0A          ;
CODE_04E732:          STA.W $1B82                         ;; 04E732 : 8D 82 1B    ;
CODE_04E735:          REP #$20                            ;; 04E735 : C2 20       ; Accum (16 bit) 
CODE_04E737:          LDA.W #$4000                        ;; 04E737 : A9 00 40    ;
CODE_04E73A:          STA $0C                             ;; 04E73A : 85 0C       ;
CODE_04E73C:          LDA.W #$EFFF                        ;; 04E73C : A9 FF EF    ;
CODE_04E73F:          STA $0A                             ;; 04E73F : 85 0A       ;
CODE_04E741:          LDA.W $1B84                         ;; 04E741 : AD 84 1B    ;
CODE_04E744:          CMP.W #$0900                        ;; 04E744 : C9 00 09    ;
CODE_04E747:          BCC CODE_04E74F                     ;; 04E747 : 90 06       ;
CODE_04E749:          JSR.W CODE_04E76C                   ;; 04E749 : 20 6C E7    ;
CODE_04E74C:          JMP.W CODE_04E752                   ;; 04E74C : 4C 52 E7    ;
                                                          ;;                      ;
CODE_04E74F:          JSR.W CODE_04E824                   ;; 04E74F : 20 24 E8    ;
CODE_04E752:          LDA.W #$00FF                        ;; 04E752 : A9 FF 00    ;
CODE_04E755:          STA.L $7F837D,X                     ;; 04E755 : 9F 7D 83 7F ;
CODE_04E759:          TXA                                 ;; 04E759 : 8A          ;
CODE_04E75A:          STA.L $7F837B                       ;; 04E75A : 8F 7B 83 7F ;
CODE_04E75E:          JSR.W CODE_04E496                   ;; 04E75E : 20 96 E4    ;
CODE_04E761:          SEP #$30                            ;; 04E761 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04E763:          LDA.B #$15                          ;; 04E763 : A9 15       ;
CODE_04E765:          STA.W $1DFC                         ;; 04E765 : 8D FC 1D    ; / Play sound effect 
CODE_04E768:          INC.W $1B86                         ;; 04E768 : EE 86 1B    ;
Return04E76B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E76C:          LDA.W #$0001                        ;; 04E76C : A9 01 00    ; Index (16 bit) Accum (16 bit) 
CODE_04E76F:          STA $06                             ;; 04E76F : 85 06       ;
CODE_04E771:          LDA.L $7F837B                       ;; 04E771 : AF 7B 83 7F ;
CODE_04E775:          TAX                                 ;; 04E775 : AA          ;
CODE_04E776:          LDA $02                             ;; 04E776 : A5 02       ;
CODE_04E778:          STA.L $7F837D,X                     ;; 04E778 : 9F 7D 83 7F ;
CODE_04E77C:          INX                                 ;; 04E77C : E8          ;
CODE_04E77D:          INX                                 ;; 04E77D : E8          ;
CODE_04E77E:          LDY.W #$0300                        ;; 04E77E : A0 00 03    ;
CODE_04E781:          LDA $03                             ;; 04E781 : A5 03       ;
CODE_04E783:          AND.W #$001F                        ;; 04E783 : 29 1F 00    ;
CODE_04E786:          STA $08                             ;; 04E786 : 85 08       ;
CODE_04E788:          LDA.W #$0020                        ;; 04E788 : A9 20 00    ;
CODE_04E78B:          SEC                                 ;; 04E78B : 38          ;
CODE_04E78C:          SBC $08                             ;; 04E78C : E5 08       ;
CODE_04E78E:          STA $08                             ;; 04E78E : 85 08       ;
CODE_04E790:          CMP.W #$0001                        ;; 04E790 : C9 01 00    ;
CODE_04E793:          BNE CODE_04E79B                     ;; 04E793 : D0 06       ;
ADDR_04E795:          LDA $08                             ;; 04E795 : A5 08       ;
ADDR_04E797:          ASL                                 ;; 04E797 : 0A          ;
ADDR_04E798:          DEC A                               ;; 04E798 : 3A          ;
ADDR_04E799:          XBA                                 ;; 04E799 : EB          ;
ADDR_04E79A:          TAY                                 ;; 04E79A : A8          ;
CODE_04E79B:          TYA                                 ;; 04E79B : 98          ;
CODE_04E79C:          STA.L $7F837D,X                     ;; 04E79C : 9F 7D 83 7F ;
CODE_04E7A0:          INX                                 ;; 04E7A0 : E8          ;
CODE_04E7A1:          INX                                 ;; 04E7A1 : E8          ;
CODE_04E7A2:          LDA.W #$0001                        ;; 04E7A2 : A9 01 00    ;
CODE_04E7A5:          STA $04                             ;; 04E7A5 : 85 04       ;
CODE_04E7A7:          LDY $00                             ;; 04E7A7 : A4 00       ;
CODE_04E7A9:          LDA [$0C],Y                         ;; 04E7A9 : B7 0C       ;
CODE_04E7AB:          AND $0A                             ;; 04E7AB : 25 0A       ;
CODE_04E7AD:          STA.L $7F837D,X                     ;; 04E7AD : 9F 7D 83 7F ;
CODE_04E7B1:          INX                                 ;; 04E7B1 : E8          ;
CODE_04E7B2:          INX                                 ;; 04E7B2 : E8          ;
CODE_04E7B3:          INY                                 ;; 04E7B3 : C8          ;
CODE_04E7B4:          INY                                 ;; 04E7B4 : C8          ;
CODE_04E7B5:          TYA                                 ;; 04E7B5 : 98          ;
CODE_04E7B6:          AND.W #$003F                        ;; 04E7B6 : 29 3F 00    ;
CODE_04E7B9:          BNE CODE_04E7E5                     ;; 04E7B9 : D0 2A       ;
CODE_04E7BB:          LDA $04                             ;; 04E7BB : A5 04       ;
CODE_04E7BD:          BEQ CODE_04E7E5                     ;; 04E7BD : F0 26       ;
ADDR_04E7BF:          DEY                                 ;; 04E7BF : 88          ;
ADDR_04E7C0:          TYA                                 ;; 04E7C0 : 98          ;
ADDR_04E7C1:          AND.W #$FFC0                        ;; 04E7C1 : 29 C0 FF    ;
ADDR_04E7C4:          CLC                                 ;; 04E7C4 : 18          ;
ADDR_04E7C5:          ADC.W #$0800                        ;; 04E7C5 : 69 00 08    ;
ADDR_04E7C8:          TAY                                 ;; 04E7C8 : A8          ;
ADDR_04E7C9:          LDA $02                             ;; 04E7C9 : A5 02       ;
ADDR_04E7CB:          XBA                                 ;; 04E7CB : EB          ;
ADDR_04E7CC:          AND.W #$3BE0                        ;; 04E7CC : 29 E0 3B    ;
ADDR_04E7CF:          CLC                                 ;; 04E7CF : 18          ;
ADDR_04E7D0:          ADC.W #$0400                        ;; 04E7D0 : 69 00 04    ;
ADDR_04E7D3:          XBA                                 ;; 04E7D3 : EB          ;
ADDR_04E7D4:          STA.L $7F837D,X                     ;; 04E7D4 : 9F 7D 83 7F ;
ADDR_04E7D8:          INX                                 ;; 04E7D8 : E8          ;
ADDR_04E7D9:          INX                                 ;; 04E7D9 : E8          ;
ADDR_04E7DA:          LDA $08                             ;; 04E7DA : A5 08       ;
ADDR_04E7DC:          ASL                                 ;; 04E7DC : 0A          ;
ADDR_04E7DD:          DEC A                               ;; 04E7DD : 3A          ;
ADDR_04E7DE:          XBA                                 ;; 04E7DE : EB          ;
ADDR_04E7DF:          STA.L $7F837D,X                     ;; 04E7DF : 9F 7D 83 7F ;
ADDR_04E7E3:          INX                                 ;; 04E7E3 : E8          ;
ADDR_04E7E4:          INX                                 ;; 04E7E4 : E8          ;
CODE_04E7E5:          DEC $04                             ;; 04E7E5 : C6 04       ;
CODE_04E7E7:          BPL CODE_04E7A9                     ;; 04E7E7 : 10 C0       ;
CODE_04E7E9:          LDA $02                             ;; 04E7E9 : A5 02       ;
CODE_04E7EB:          XBA                                 ;; 04E7EB : EB          ;
CODE_04E7EC:          CLC                                 ;; 04E7EC : 18          ;
CODE_04E7ED:          ADC.W #$0020                        ;; 04E7ED : 69 20 00    ;
CODE_04E7F0:          XBA                                 ;; 04E7F0 : EB          ;
CODE_04E7F1:          STA $02                             ;; 04E7F1 : 85 02       ;
CODE_04E7F3:          LDA $00                             ;; 04E7F3 : A5 00       ;
CODE_04E7F5:          TAY                                 ;; 04E7F5 : A8          ;
CODE_04E7F6:          CLC                                 ;; 04E7F6 : 18          ;
CODE_04E7F7:          ADC.W #$0040                        ;; 04E7F7 : 69 40 00    ;
CODE_04E7FA:          STA $00                             ;; 04E7FA : 85 00       ;
CODE_04E7FC:          AND.W #$07C0                        ;; 04E7FC : 29 C0 07    ;
CODE_04E7FF:          BNE CODE_04E81C                     ;; 04E7FF : D0 1B       ;
CODE_04E801:          TYA                                 ;; 04E801 : 98          ;
CODE_04E802:          AND.W #$F83F                        ;; 04E802 : 29 3F F8    ;
CODE_04E805:          CLC                                 ;; 04E805 : 18          ;
CODE_04E806:          ADC.W #$1000                        ;; 04E806 : 69 00 10    ;
CODE_04E809:          STA $00                             ;; 04E809 : 85 00       ;
CODE_04E80B:          LDA $02                             ;; 04E80B : A5 02       ;
CODE_04E80D:          XBA                                 ;; 04E80D : EB          ;
CODE_04E80E:          SEC                                 ;; 04E80E : 38          ;
CODE_04E80F:          SBC.W #$0020                        ;; 04E80F : E9 20 00    ;
CODE_04E812:          AND.W #$341F                        ;; 04E812 : 29 1F 34    ;
CODE_04E815:          CLC                                 ;; 04E815 : 18          ;
CODE_04E816:          ADC.W #$0800                        ;; 04E816 : 69 00 08    ;
CODE_04E819:          XBA                                 ;; 04E819 : EB          ;
CODE_04E81A:          STA $02                             ;; 04E81A : 85 02       ;
CODE_04E81C:          DEC $06                             ;; 04E81C : C6 06       ;
CODE_04E81E:          BMI Return04E823                    ;; 04E81E : 30 03       ;
CODE_04E820:          JMP.W CODE_04E776                   ;; 04E820 : 4C 76 E7    ;
                                                          ;;                      ;
Return04E823:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04E824:          LDA.W #$0005                        ;; 04E824 : A9 05 00    ;
CODE_04E827:          STA $06                             ;; 04E827 : 85 06       ;
CODE_04E829:          LDA.L $7F837B                       ;; 04E829 : AF 7B 83 7F ;
CODE_04E82D:          TAX                                 ;; 04E82D : AA          ;
CODE_04E82E:          LDA $02                             ;; 04E82E : A5 02       ;
CODE_04E830:          STA.L $7F837D,X                     ;; 04E830 : 9F 7D 83 7F ;
CODE_04E834:          INX                                 ;; 04E834 : E8          ;
CODE_04E835:          INX                                 ;; 04E835 : E8          ;
CODE_04E836:          LDY.W #$0B00                        ;; 04E836 : A0 00 0B    ;
CODE_04E839:          LDA $03                             ;; 04E839 : A5 03       ;
CODE_04E83B:          AND.W #$001F                        ;; 04E83B : 29 1F 00    ;
CODE_04E83E:          STA $08                             ;; 04E83E : 85 08       ;
CODE_04E840:          LDA.W #$0020                        ;; 04E840 : A9 20 00    ;
CODE_04E843:          SEC                                 ;; 04E843 : 38          ;
CODE_04E844:          SBC $08                             ;; 04E844 : E5 08       ;
CODE_04E846:          STA $08                             ;; 04E846 : 85 08       ;
CODE_04E848:          CMP.W #$0006                        ;; 04E848 : C9 06 00    ;
CODE_04E84B:          BCS CODE_04E85B                     ;; 04E84B : B0 0E       ;
CODE_04E84D:          LDA $08                             ;; 04E84D : A5 08       ;
CODE_04E84F:          ASL                                 ;; 04E84F : 0A          ;
CODE_04E850:          DEC A                               ;; 04E850 : 3A          ;
CODE_04E851:          XBA                                 ;; 04E851 : EB          ;
CODE_04E852:          TAY                                 ;; 04E852 : A8          ;
CODE_04E853:          LDA.W #$0006                        ;; 04E853 : A9 06 00    ;
CODE_04E856:          SEC                                 ;; 04E856 : 38          ;
CODE_04E857:          SBC $08                             ;; 04E857 : E5 08       ;
CODE_04E859:          STA $08                             ;; 04E859 : 85 08       ;
CODE_04E85B:          TYA                                 ;; 04E85B : 98          ;
CODE_04E85C:          STA.L $7F837D,X                     ;; 04E85C : 9F 7D 83 7F ;
CODE_04E860:          INX                                 ;; 04E860 : E8          ;
CODE_04E861:          INX                                 ;; 04E861 : E8          ;
CODE_04E862:          LDA.W #$0005                        ;; 04E862 : A9 05 00    ;
CODE_04E865:          STA $04                             ;; 04E865 : 85 04       ;
CODE_04E867:          LDY $00                             ;; 04E867 : A4 00       ;
CODE_04E869:          LDA [$0C],Y                         ;; 04E869 : B7 0C       ;
CODE_04E86B:          AND $0A                             ;; 04E86B : 25 0A       ;
CODE_04E86D:          STA.L $7F837D,X                     ;; 04E86D : 9F 7D 83 7F ;
CODE_04E871:          INX                                 ;; 04E871 : E8          ;
CODE_04E872:          INX                                 ;; 04E872 : E8          ;
CODE_04E873:          INY                                 ;; 04E873 : C8          ;
CODE_04E874:          INY                                 ;; 04E874 : C8          ;
CODE_04E875:          TYA                                 ;; 04E875 : 98          ;
CODE_04E876:          AND.W #$003F                        ;; 04E876 : 29 3F 00    ;
CODE_04E879:          BNE CODE_04E8A5                     ;; 04E879 : D0 2A       ;
CODE_04E87B:          LDA $04                             ;; 04E87B : A5 04       ;
CODE_04E87D:          BEQ CODE_04E8A5                     ;; 04E87D : F0 26       ;
CODE_04E87F:          DEY                                 ;; 04E87F : 88          ;
CODE_04E880:          TYA                                 ;; 04E880 : 98          ;
CODE_04E881:          AND.W #$FFC0                        ;; 04E881 : 29 C0 FF    ;
CODE_04E884:          CLC                                 ;; 04E884 : 18          ;
CODE_04E885:          ADC.W #$0800                        ;; 04E885 : 69 00 08    ;
CODE_04E888:          TAY                                 ;; 04E888 : A8          ;
CODE_04E889:          LDA $02                             ;; 04E889 : A5 02       ;
CODE_04E88B:          XBA                                 ;; 04E88B : EB          ;
CODE_04E88C:          AND.W #$3BE0                        ;; 04E88C : 29 E0 3B    ;
CODE_04E88F:          CLC                                 ;; 04E88F : 18          ;
CODE_04E890:          ADC.W #$0400                        ;; 04E890 : 69 00 04    ;
CODE_04E893:          XBA                                 ;; 04E893 : EB          ;
CODE_04E894:          STA.L $7F837D,X                     ;; 04E894 : 9F 7D 83 7F ;
CODE_04E898:          INX                                 ;; 04E898 : E8          ;
CODE_04E899:          INX                                 ;; 04E899 : E8          ;
CODE_04E89A:          LDA $08                             ;; 04E89A : A5 08       ;
CODE_04E89C:          ASL                                 ;; 04E89C : 0A          ;
CODE_04E89D:          DEC A                               ;; 04E89D : 3A          ;
CODE_04E89E:          XBA                                 ;; 04E89E : EB          ;
CODE_04E89F:          STA.L $7F837D,X                     ;; 04E89F : 9F 7D 83 7F ;
CODE_04E8A3:          INX                                 ;; 04E8A3 : E8          ;
CODE_04E8A4:          INX                                 ;; 04E8A4 : E8          ;
CODE_04E8A5:          DEC $04                             ;; 04E8A5 : C6 04       ;
CODE_04E8A7:          BPL CODE_04E869                     ;; 04E8A7 : 10 C0       ;
CODE_04E8A9:          LDA $02                             ;; 04E8A9 : A5 02       ;
CODE_04E8AB:          XBA                                 ;; 04E8AB : EB          ;
CODE_04E8AC:          CLC                                 ;; 04E8AC : 18          ;
CODE_04E8AD:          ADC.W #$0020                        ;; 04E8AD : 69 20 00    ;
CODE_04E8B0:          XBA                                 ;; 04E8B0 : EB          ;
CODE_04E8B1:          STA $02                             ;; 04E8B1 : 85 02       ;
CODE_04E8B3:          LDA $00                             ;; 04E8B3 : A5 00       ;
CODE_04E8B5:          TAY                                 ;; 04E8B5 : A8          ;
CODE_04E8B6:          CLC                                 ;; 04E8B6 : 18          ;
CODE_04E8B7:          ADC.W #$0040                        ;; 04E8B7 : 69 40 00    ;
CODE_04E8BA:          STA $00                             ;; 04E8BA : 85 00       ;
CODE_04E8BC:          AND.W #$07C0                        ;; 04E8BC : 29 C0 07    ;
CODE_04E8BF:          BNE CODE_04E8DC                     ;; 04E8BF : D0 1B       ;
CODE_04E8C1:          TYA                                 ;; 04E8C1 : 98          ;
CODE_04E8C2:          AND.W #$F83F                        ;; 04E8C2 : 29 3F F8    ;
CODE_04E8C5:          CLC                                 ;; 04E8C5 : 18          ;
CODE_04E8C6:          ADC.W #$1000                        ;; 04E8C6 : 69 00 10    ;
CODE_04E8C9:          STA $00                             ;; 04E8C9 : 85 00       ;
CODE_04E8CB:          LDA $02                             ;; 04E8CB : A5 02       ;
CODE_04E8CD:          XBA                                 ;; 04E8CD : EB          ;
CODE_04E8CE:          SEC                                 ;; 04E8CE : 38          ;
CODE_04E8CF:          SBC.W #$0020                        ;; 04E8CF : E9 20 00    ;
CODE_04E8D2:          AND.W #$341F                        ;; 04E8D2 : 29 1F 34    ;
CODE_04E8D5:          CLC                                 ;; 04E8D5 : 18          ;
CODE_04E8D6:          ADC.W #$0800                        ;; 04E8D6 : 69 00 08    ;
CODE_04E8D9:          XBA                                 ;; 04E8D9 : EB          ;
CODE_04E8DA:          STA $02                             ;; 04E8DA : 85 02       ;
CODE_04E8DC:          DEC $06                             ;; 04E8DC : C6 06       ;
CODE_04E8DE:          BMI Return04E8E3                    ;; 04E8DE : 30 03       ;
CODE_04E8E0:          JMP.W CODE_04E82E                   ;; 04E8E0 : 4C 2E E8    ;
                                                          ;;                      ;
Return04E8E3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04E8E4:          .db $06,$06,$06,$06,$06,$06,$06,$06 ;; 04E8E4               ;
                      .db $14,$14,$14,$14,$14,$1D,$1D,$1D ;; ?QPWZ?               ;
                      .db $1D,$12,$12,$12,$1C,$2F,$2F,$2F ;; ?QPWZ?               ;
                      .db $2F,$2F,$34,$34,$34,$47,$4E,$4E ;; ?QPWZ?               ;
                      .db $01,$0F,$24,$24,$6C,$0F,$0F,$54 ;; ?QPWZ?               ;
                      .db $55,$57,$58,$5D                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04E910:          .db $00,$00,$00,$00,$00,$00,$01,$01 ;; 04E910               ;
                      .db $00,$01,$01,$01,$01,$01,$01,$01 ;; ?QPWZ?               ;
                      .db $00,$01,$01,$00,$00,$01,$01,$01 ;; ?QPWZ?               ;
                      .db $01,$01,$01,$01,$01,$00,$01,$00 ;; ?QPWZ?               ;
                      .db $00,$01,$01,$01,$01,$01,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04E93C:          .db $15,$02,$35,$02,$45,$02,$55,$02 ;; 04E93C               ;
                      .db $65,$02,$75,$02,$14,$11,$94,$10 ;; ?QPWZ?               ;
                      .db $A9,$00,$A4,$05,$24,$05,$28,$07 ;; ?QPWZ?               ;
                      .db $A4,$06,$A8,$01,$AC,$01,$B0,$01 ;; ?QPWZ?               ;
                      .db $3C,$00,$00,$29,$80,$28,$10,$05 ;; ?QPWZ?               ;
                      .db $54,$01,$30,$18,$B0,$18,$2E,$19 ;; ?QPWZ?               ;
                      .db $2A,$19,$26,$19,$24,$18,$20,$18 ;; ?QPWZ?               ;
                      .db $1C,$18,$97,$05,$EC,$2A,$7B,$05 ;; ?QPWZ?               ;
                      .db $12,$02,$94,$31,$A0,$32,$20,$33 ;; ?QPWZ?               ;
                      .db $16,$1D,$14,$31,$25,$06,$F0,$01 ;; ?QPWZ?               ;
                      .db $F0,$01,$04,$03,$04,$03,$27,$02 ;; ?QPWZ?               ;
DATA_04E994:          .db $68,$00,$24,$00,$24,$00,$25,$00 ;; 04E994               ;
                      .db $00,$00,$81,$00,$38,$09,$28,$09 ;; ?QPWZ?               ;
                      .db $66,$00,$9C,$09,$28,$09,$F8,$09 ;; ?QPWZ?               ;
                      .db $FC,$09,$98,$09,$98,$09,$28,$09 ;; ?QPWZ?               ;
                      .db $66,$00,$38,$09,$28,$09,$66,$00 ;; ?QPWZ?               ;
                      .db $68,$00,$80,$0A,$84,$0A,$88,$0A ;; ?QPWZ?               ;
                      .db $98,$09,$98,$09,$94,$09,$98,$09 ;; ?QPWZ?               ;
                      .db $8C,$0A,$66,$00,$84,$03,$66,$00 ;; ?QPWZ?               ;
                      .db $79,$00,$A8,$0A,$38,$09,$38,$09 ;; ?QPWZ?               ;
                      .db $A0,$09,$30,$0A,$69,$00,$5F,$00 ;; ?QPWZ?               ;
                      .db $5F,$00,$5F,$00,$5F,$00,$5F,$00 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_04E9EC:          LDA.W $1DEA                         ;; 04E9EC : AD EA 1D    ; Index (8 bit) Accum (8 bit) 
CODE_04E9EF:          STA $0F                             ;; 04E9EF : 85 0F       ;
CODE_04E9F1:          LDX.B #$2B                          ;; 04E9F1 : A2 2B       ;
CODE_04E9F3:          CMP.L DATA_04E8E4,X                 ;; 04E9F3 : DF E4 E8 04 ;
CODE_04E9F7:          BEQ CODE_04EA25                     ;; 04E9F7 : F0 2C       ;
CODE_04E9F9:          DEX                                 ;; 04E9F9 : CA          ;
CODE_04E9FA:          BPL CODE_04E9F3                     ;; 04E9FA : 10 F7       ;
CODE_04E9FC:          LDA.W $1B86                         ;; 04E9FC : AD 86 1B    ;
CODE_04E9FF:          BEQ Return04EA24                    ;; 04E9FF : F0 23       ;
CODE_04EA01:          STZ.W $1B86                         ;; 04EA01 : 9C 86 1B    ;
CODE_04EA04:          INC.W $13D9                         ;; 04EA04 : EE D9 13    ;
CODE_04EA07:          LDA.W $1DEA                         ;; 04EA07 : AD EA 1D    ;
CODE_04EA0A:          AND.B #$07                          ;; 04EA0A : 29 07       ;
CODE_04EA0C:          TAX                                 ;; 04EA0C : AA          ;
CODE_04EA0D:          LDA.W $1DEA                         ;; 04EA0D : AD EA 1D    ;
CODE_04EA10:          LSR                                 ;; 04EA10 : 4A          ;
CODE_04EA11:          LSR                                 ;; 04EA11 : 4A          ;
CODE_04EA12:          LSR                                 ;; 04EA12 : 4A          ;
CODE_04EA13:          TAY                                 ;; 04EA13 : A8          ;
CODE_04EA14:          LDA.W $1F02,Y                       ;; 04EA14 : B9 02 1F    ;
CODE_04EA17:          ORA.L DATA_04E44B,X                 ;; 04EA17 : 1F 4B E4 04 ;
CODE_04EA1B:          STA.W $1F02,Y                       ;; 04EA1B : 99 02 1F    ;
CODE_04EA1E:          INC.W $1F2E                         ;; 04EA1E : EE 2E 1F    ;
CODE_04EA21:          STZ.W $1DE9                         ;; 04EA21 : 9C E9 1D    ;
Return04EA24:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04EA25:          PHX                                 ;; 04EA25 : DA          ;
CODE_04EA26:          LDA.L DATA_04E910,X                 ;; 04EA26 : BF 10 E9 04 ;
CODE_04EA2A:          STA $02                             ;; 04EA2A : 85 02       ;
CODE_04EA2C:          TXA                                 ;; 04EA2C : 8A          ;
CODE_04EA2D:          ASL                                 ;; 04EA2D : 0A          ;
CODE_04EA2E:          TAX                                 ;; 04EA2E : AA          ;
CODE_04EA2F:          REP #$20                            ;; 04EA2F : C2 20       ; Accum (16 bit) 
CODE_04EA31:          LDA.L DATA_04E994,X                 ;; 04EA31 : BF 94 E9 04 ;
CODE_04EA35:          STA $00                             ;; 04EA35 : 85 00       ;
CODE_04EA37:          LDA.L DATA_04E93C,X                 ;; 04EA37 : BF 3C E9 04 ;
CODE_04EA3B:          STA $04                             ;; 04EA3B : 85 04       ;
CODE_04EA3D:          LDA $02                             ;; 04EA3D : A5 02       ;
CODE_04EA3F:          AND.W #$0001                        ;; 04EA3F : 29 01 00    ;
CODE_04EA42:          BEQ CODE_04EA4E                     ;; 04EA42 : F0 0A       ;
CODE_04EA44:          REP #$10                            ;; 04EA44 : C2 10       ; Index (16 bit) 
CODE_04EA46:          LDY $00                             ;; 04EA46 : A4 00       ;
CODE_04EA48:          JSR.W CODE_04E4A9                   ;; 04EA48 : 20 A9 E4    ;
CODE_04EA4B:          JMP.W CODE_04EA5A                   ;; 04EA4B : 4C 5A EA    ;
                                                          ;;                      ;
CODE_04EA4E:          SEP #$20                            ;; 04EA4E : E2 20       ; Accum (8 bit) 
CODE_04EA50:          REP #$10                            ;; 04EA50 : C2 10       ; Index (16 bit) 
CODE_04EA52:          LDX $04                             ;; 04EA52 : A6 04       ;
CODE_04EA54:          LDA $00                             ;; 04EA54 : A5 00       ;
CODE_04EA56:          STA.L $7EC800,X                     ;; 04EA56 : 9F 00 C8 7E ;
CODE_04EA5A:          SEP #$30                            ;; 04EA5A : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04EA5C:          PLX                                 ;; 04EA5C : FA          ;
CODE_04EA5D:          LDA $0F                             ;; 04EA5D : A5 0F       ;
CODE_04EA5F:          JMP.W CODE_04E9F9                   ;; 04EA5F : 4C F9 E9    ;
                                                          ;;                      ;
CODE_04EA62:          STZ.W $1495                         ;; 04EA62 : 9C 95 14    ;
CODE_04EA65:          STZ.W $1494                         ;; 04EA65 : 9C 94 14    ;
CODE_04EA68:          LDX.B #$6F                          ;; 04EA68 : A2 6F       ;
CODE_04EA6A:          LDA.W $0703,X                       ;; 04EA6A : BD 03 07    ;
CODE_04EA6D:          STA.W $0907,X                       ;; 04EA6D : 9D 07 09    ;
CODE_04EA70:          STZ.W $0979,X                       ;; 04EA70 : 9E 79 09    ;
CODE_04EA73:          DEX                                 ;; 04EA73 : CA          ;
CODE_04EA74:          BPL CODE_04EA6A                     ;; 04EA74 : 10 F4       ;
CODE_04EA76:          LDX.B #$6F                          ;; 04EA76 : A2 6F       ;
CODE_04EA78:          LDY.B #$10                          ;; 04EA78 : A0 10       ;
CODE_04EA7A:          LDA.W $0783,X                       ;; 04EA7A : BD 83 07    ;
CODE_04EA7D:          STA.W $0907,X                       ;; 04EA7D : 9D 07 09    ;
CODE_04EA80:          DEX                                 ;; 04EA80 : CA          ;
CODE_04EA81:          DEY                                 ;; 04EA81 : 88          ;
CODE_04EA82:          BNE CODE_04EA7A                     ;; 04EA82 : D0 F6       ;
CODE_04EA84:          TXA                                 ;; 04EA84 : 8A          ;
CODE_04EA85:          SEC                                 ;; 04EA85 : 38          ;
CODE_04EA86:          SBC.B #$10                          ;; 04EA86 : E9 10       ;
CODE_04EA88:          TAX                                 ;; 04EA88 : AA          ;
CODE_04EA89:          BPL CODE_04EA78                     ;; 04EA89 : 10 ED       ;
CODE_04EA8B:          REP #$20                            ;; 04EA8B : C2 20       ; Accum (16 bit) 
CODE_04EA8D:          LDA.W #$0070                        ;; 04EA8D : A9 70 00    ;
CODE_04EA90:          STA.W $0905                         ;; 04EA90 : 8D 05 09    ;
CODE_04EA93:          LDA.W #$C070                        ;; 04EA93 : A9 70 C0    ;
CODE_04EA96:          STA.W $0977                         ;; 04EA96 : 8D 77 09    ;
CODE_04EA99:          SEP #$20                            ;; 04EA99 : E2 20       ; Accum (8 bit) 
CODE_04EA9B:          STZ.W $09E9                         ;; 04EA9B : 9C E9 09    ;
CODE_04EA9E:          LDA.B #$03                          ;; 04EA9E : A9 03       ;
CODE_04EAA0:          STA.W $0680                         ;; 04EAA0 : 8D 80 06    ;
Return04EAA3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04EAA4:          LDA.W $1495                         ;; 04EAA4 : AD 95 14    ;
CODE_04EAA7:          CMP.B #$40                          ;; 04EAA7 : C9 40       ;
CODE_04EAA9:          BCC CODE_04EAC9                     ;; 04EAA9 : 90 1E       ;
CODE_04EAAB:          INC.W $1B86                         ;; 04EAAB : EE 86 1B    ;
CODE_04EAAE:          JSR.W CODE_04EE30                   ;; 04EAAE : 20 30 EE    ;
CODE_04EAB1:          JSR.W CODE_04E496                   ;; 04EAB1 : 20 96 E4    ;
CODE_04EAB4:          REP #$20                            ;; 04EAB4 : C2 20       ; Accum (16 bit) 
CODE_04EAB6:          INC.W $1DEB                         ;; 04EAB6 : EE EB 1D    ;
CODE_04EAB9:          LDA.W $1DEB                         ;; 04EAB9 : AD EB 1D    ;
CODE_04EABC:          CMP.W $1DED                         ;; 04EABC : CD ED 1D    ;
CODE_04EABF:          SEP #$20                            ;; 04EABF : E2 20       ; Accum (8 bit) 
CODE_04EAC1:          BCS Return04EAC8                    ;; 04EAC1 : B0 05       ;
CODE_04EAC3:          LDA.B #$03                          ;; 04EAC3 : A9 03       ;
CODE_04EAC5:          STA.W $1B86                         ;; 04EAC5 : 8D 86 1B    ;
Return04EAC8:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04EAC9:          JSR.W CODE_04EC67                   ;; 04EAC9 : 20 67 EC    ;
CODE_04EACC:          REP #$30                            ;; 04EACC : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04EACE:          LDY.W #$008C                        ;; 04EACE : A0 8C 00    ;
CODE_04EAD1:          LDX.W #$0006                        ;; 04EAD1 : A2 06 00    ;
CODE_04EAD4:          LDA.W $1B84                         ;; 04EAD4 : AD 84 1B    ;
CODE_04EAD7:          CMP.W #$0900                        ;; 04EAD7 : C9 00 09    ;
CODE_04EADA:          BCC CODE_04EAE2                     ;; 04EADA : 90 06       ;
CODE_04EADC:          LDY.W #$000C                        ;; 04EADC : A0 0C 00    ;
CODE_04EADF:          LDX.W #$0002                        ;; 04EADF : A2 02 00    ;
CODE_04EAE2:          STX $05                             ;; 04EAE2 : 86 05       ;
CODE_04EAE4:          TAX                                 ;; 04EAE4 : AA          ;
CODE_04EAE5:          SEP #$20                            ;; 04EAE5 : E2 20       ; Accum (8 bit) 
CODE_04EAE7:          LDA $05                             ;; 04EAE7 : A5 05       ;
CODE_04EAE9:          STA $03                             ;; 04EAE9 : 85 03       ;
CODE_04EAEB:          LDA $00                             ;; 04EAEB : A5 00       ;
CODE_04EAED:          STA $02                             ;; 04EAED : 85 02       ;
CODE_04EAEF:          LDA $01                             ;; 04EAEF : A5 01       ;
CODE_04EAF1:          STA.W $0351,Y                       ;; 04EAF1 : 99 51 03    ;
CODE_04EAF4:          LDA.L DATA_0C8000,X                 ;; 04EAF4 : BF 00 80 0C ;
CODE_04EAF8:          STA.W $0352,Y                       ;; 04EAF8 : 99 52 03    ;
CODE_04EAFB:          LDA.L $7F0000,X                     ;; 04EAFB : BF 00 00 7F ;
CODE_04EAFF:          AND.B #$C0                          ;; 04EAFF : 29 C0       ;
CODE_04EB01:          STA $04                             ;; 04EB01 : 85 04       ;
CODE_04EB03:          LDA.L $7F0000,X                     ;; 04EB03 : BF 00 00 7F ;
CODE_04EB07:          AND.B #$1C                          ;; 04EB07 : 29 1C       ;
CODE_04EB09:          LSR                                 ;; 04EB09 : 4A          ;
CODE_04EB0A:          ORA $04                             ;; 04EB0A : 05 04       ;
CODE_04EB0C:          ORA.B #$11                          ;; 04EB0C : 09 11       ;
CODE_04EB0E:          STA.W $0353,Y                       ;; 04EB0E : 99 53 03    ;
CODE_04EB11:          LDA $02                             ;; 04EB11 : A5 02       ;
CODE_04EB13:          STA.W $0350,Y                       ;; 04EB13 : 99 50 03    ;
CODE_04EB16:          CLC                                 ;; 04EB16 : 18          ;
CODE_04EB17:          ADC.B #$08                          ;; 04EB17 : 69 08       ;
CODE_04EB19:          INX                                 ;; 04EB19 : E8          ;
CODE_04EB1A:          DEY                                 ;; 04EB1A : 88          ;
CODE_04EB1B:          DEY                                 ;; 04EB1B : 88          ;
CODE_04EB1C:          DEY                                 ;; 04EB1C : 88          ;
CODE_04EB1D:          DEY                                 ;; 04EB1D : 88          ;
CODE_04EB1E:          DEC $03                             ;; 04EB1E : C6 03       ;
CODE_04EB20:          BNE CODE_04EAED                     ;; 04EB20 : D0 CB       ;
CODE_04EB22:          LDA $01                             ;; 04EB22 : A5 01       ;
CODE_04EB24:          CLC                                 ;; 04EB24 : 18          ;
CODE_04EB25:          ADC.B #$08                          ;; 04EB25 : 69 08       ;
CODE_04EB27:          STA $01                             ;; 04EB27 : 85 01       ;
CODE_04EB29:          CPY.W #$FFFC                        ;; 04EB29 : C0 FC FF    ;
CODE_04EB2C:          BNE CODE_04EAE7                     ;; 04EB2C : D0 B9       ;
CODE_04EB2E:          SEP #$10                            ;; 04EB2E : E2 10       ; Index (8 bit) 
CODE_04EB30:          LDX.B #$23                          ;; 04EB30 : A2 23       ;
CODE_04EB32:          STZ.W $0474,X                       ;; 04EB32 : 9E 74 04    ;
CODE_04EB35:          DEX                                 ;; 04EB35 : CA          ;
CODE_04EB36:          BPL CODE_04EB32                     ;; 04EB36 : 10 FA       ;
CODE_04EB38:          LDY.B #$08                          ;; 04EB38 : A0 08       ;
CODE_04EB3A:          LDX.W $0DB3                         ;; 04EB3A : AE B3 0D    ;
CODE_04EB3D:          LDA.W $1F11,X                       ;; 04EB3D : BD 11 1F    ;
CODE_04EB40:          CMP.B #$03                          ;; 04EB40 : C9 03       ;
CODE_04EB42:          BNE CODE_04EB46                     ;; 04EB42 : D0 02       ;
CODE_04EB44:          LDY.B #$01                          ;; 04EB44 : A0 01       ;
CODE_04EB46:          STY $8A                             ;; 04EB46 : 84 8A       ;
CODE_04EB48:          LDA.W $1495                         ;; 04EB48 : AD 95 14    ;
CODE_04EB4B:          JSL.L CODE_00B006                   ;; 04EB4B : 22 06 B0 00 ;
CODE_04EB4F:          DEC $8A                             ;; 04EB4F : C6 8A       ;
CODE_04EB51:          BNE CODE_04EB48                     ;; 04EB51 : D0 F5       ;
CODE_04EB53:          JMP.W CODE_04EA8B                   ;; 04EB53 : 4C 8B EA    ;
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04EB56:          .db $F5,$11,$F2,$15,$F5,$11,$F3,$14 ;; 04EB56               ;
                      .db $F5,$11,$F3,$14,$F6,$10,$F4,$13 ;; ?QPWZ?               ;
                      .db $F7,$0F,$F5,$12,$F8,$0E,$F7,$11 ;; ?QPWZ?               ;
                      .db $FA,$0D,$F9,$10,$FC,$0C,$FB,$0D ;; ?QPWZ?               ;
                      .db $FF,$0A,$FE,$0B,$01,$07,$01,$07 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04EB82:          .db $F8,$F8,$11,$12,$F8,$F8,$10,$11 ;; 04EB82               ;
                      .db $F8,$F8,$10,$11,$F9,$F9,$0F,$10 ;; ?QPWZ?               ;
                      .db $FA,$FA,$0E,$0F,$FB,$FB,$0C,$0D ;; ?QPWZ?               ;
                      .db $FC,$FC,$0B,$0B,$FE,$FE,$0A,$0A ;; ?QPWZ?               ;
                      .db $00,$00,$08,$08,$01,$01,$07,$07 ;; ?QPWZ?               ;
                      .db $00,$00,$08,$08                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04EBAE:          .db $F6,$B6,$76,$36,$F6,$B6,$76,$36 ;; 04EBAE               ;
                      .db $36,$76,$B6,$F6,$36,$76,$B6,$F6 ;; ?QPWZ?               ;
                      .db $36,$36,$36,$36,$36,$36,$36,$36 ;; ?QPWZ?               ;
                      .db $36,$36,$36,$36,$36,$36,$36,$36 ;; ?QPWZ?               ;
                      .db $36,$36,$36,$36,$36,$36,$36,$36 ;; ?QPWZ?               ;
                      .db $30,$70,$B0,$F0                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04EBDA:          .db $22,$23,$32,$33,$32,$23,$22     ;; 04EBDA               ;
                                                          ;;                      ;
DATA_04EBE1:          .db $73,$73,$72,$72,$5F,$5F,$28,$28 ;; 04EBE1               ;
                      .db $28,$28                         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_04EBEB:          DEC.W $1B84                         ;; 04EBEB : CE 84 1B    ;
CODE_04EBEE:          BPL CODE_04EBF4                     ;; 04EBEE : 10 04       ;
CODE_04EBF0:          INC.W $1B86                         ;; 04EBF0 : EE 86 1B    ;
Return04EBF3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04EBF4:          LDA.W $1B84                         ;; 04EBF4 : AD 84 1B    ;
CODE_04EBF7:          LDY.W $1B86                         ;; 04EBF7 : AC 86 1B    ;
CODE_04EBFA:          CPY.B #$01                          ;; 04EBFA : C0 01       ;
CODE_04EBFC:          BEQ CODE_04EC17                     ;; 04EBFC : F0 19       ;
CODE_04EBFE:          CMP.B #$10                          ;; 04EBFE : C9 10       ;
CODE_04EC00:          BNE CODE_04EC07                     ;; 04EC00 : D0 05       ;
CODE_04EC02:          PHA                                 ;; 04EC02 : 48          ;
CODE_04EC03:          JSR.W CODE_04ED83                   ;; 04EC03 : 20 83 ED    ;
CODE_04EC06:          PLA                                 ;; 04EC06 : 68          ;
CODE_04EC07:          LSR                                 ;; 04EC07 : 4A          ;
CODE_04EC08:          LSR                                 ;; 04EC08 : 4A          ;
CODE_04EC09:          TAX                                 ;; 04EC09 : AA          ;
CODE_04EC0A:          LDA.W DATA_04EBDA,X                 ;; 04EC0A : BD DA EB    ;
CODE_04EC0D:          STA $02                             ;; 04EC0D : 85 02       ;
CODE_04EC0F:          JSR.W CODE_04EC67                   ;; 04EC0F : 20 67 EC    ;
CODE_04EC12:          LDX.B #$28                          ;; 04EC12 : A2 28       ;
CODE_04EC14:          JMP.W CODE_04EC2E                   ;; 04EC14 : 4C 2E EC    ;
                                                          ;;                      ;
CODE_04EC17:          CMP.B #$18                          ;; 04EC17 : C9 18       ;
CODE_04EC19:          BNE CODE_04EC20                     ;; 04EC19 : D0 05       ;
CODE_04EC1B:          PHA                                 ;; 04EC1B : 48          ;
CODE_04EC1C:          JSR.W CODE_04EEAA                   ;; 04EC1C : 20 AA EE    ;
CODE_04EC1F:          PLA                                 ;; 04EC1F : 68          ;
CODE_04EC20:          AND.B #$FC                          ;; 04EC20 : 29 FC       ;
CODE_04EC22:          TAX                                 ;; 04EC22 : AA          ;
CODE_04EC23:          LSR                                 ;; 04EC23 : 4A          ;
CODE_04EC24:          LSR                                 ;; 04EC24 : 4A          ;
CODE_04EC25:          TAY                                 ;; 04EC25 : A8          ;
CODE_04EC26:          LDA.W DATA_04EBE1,Y                 ;; 04EC26 : B9 E1 EB    ;
CODE_04EC29:          STA $02                             ;; 04EC29 : 85 02       ;
CODE_04EC2B:          JSR.W CODE_04EC67                   ;; 04EC2B : 20 67 EC    ;
CODE_04EC2E:          LDA.B #$03                          ;; 04EC2E : A9 03       ;
CODE_04EC30:          STA $03                             ;; 04EC30 : 85 03       ;
CODE_04EC32:          LDY.B #$00                          ;; 04EC32 : A0 00       ;
CODE_04EC34:          LDA $00                             ;; 04EC34 : A5 00       ;
CODE_04EC36:          CLC                                 ;; 04EC36 : 18          ;
CODE_04EC37:          ADC.W DATA_04EB56,X                 ;; 04EC37 : 7D 56 EB    ;
CODE_04EC3A:          STA.W $0280,Y                       ;; 04EC3A : 99 80 02    ;
CODE_04EC3D:          LDA $01                             ;; 04EC3D : A5 01       ;
CODE_04EC3F:          CLC                                 ;; 04EC3F : 18          ;
CODE_04EC40:          ADC.W DATA_04EB82,X                 ;; 04EC40 : 7D 82 EB    ;
CODE_04EC43:          STA.W $0281,Y                       ;; 04EC43 : 99 81 02    ;
CODE_04EC46:          LDA $02                             ;; 04EC46 : A5 02       ;
CODE_04EC48:          STA.W $0282,Y                       ;; 04EC48 : 99 82 02    ;
CODE_04EC4B:          LDA.W DATA_04EBAE,X                 ;; 04EC4B : BD AE EB    ;
CODE_04EC4E:          STA.W $0283,Y                       ;; 04EC4E : 99 83 02    ;
CODE_04EC51:          INY                                 ;; 04EC51 : C8          ;
CODE_04EC52:          INY                                 ;; 04EC52 : C8          ;
CODE_04EC53:          INY                                 ;; 04EC53 : C8          ;
CODE_04EC54:          INY                                 ;; 04EC54 : C8          ;
CODE_04EC55:          INX                                 ;; 04EC55 : E8          ;
CODE_04EC56:          DEC $03                             ;; 04EC56 : C6 03       ;
CODE_04EC58:          BPL CODE_04EC34                     ;; 04EC58 : 10 DA       ;
CODE_04EC5A:          STZ.W $0440                         ;; 04EC5A : 9C 40 04    ;
CODE_04EC5D:          STZ.W $0441                         ;; 04EC5D : 9C 41 04    ;
CODE_04EC60:          STZ.W $0442                         ;; 04EC60 : 9C 42 04    ;
CODE_04EC63:          STZ.W $0443                         ;; 04EC63 : 9C 43 04    ;
Return04EC66:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04EC67:          LDA.W $1B82                         ;; 04EC67 : AD 82 1B    ;
CODE_04EC6A:          SEC                                 ;; 04EC6A : 38          ;
CODE_04EC6B:          SBC $1E                             ;; 04EC6B : E5 1E       ;
CODE_04EC6D:          STA $00                             ;; 04EC6D : 85 00       ;
CODE_04EC6F:          LDA.W $1B83                         ;; 04EC6F : AD 83 1B    ;
CODE_04EC72:          CLC                                 ;; 04EC72 : 18          ;
CODE_04EC73:          SBC $20                             ;; 04EC73 : E5 20       ;
CODE_04EC75:          STA $01                             ;; 04EC75 : 85 01       ;
Return04EC77:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04EC78:          LDA.B #$7E                          ;; 04EC78 : A9 7E       ;
CODE_04EC7A:          STA $0F                             ;; 04EC7A : 85 0F       ;
CODE_04EC7C:          REP #$30                            ;; 04EC7C : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04EC7E:          LDA.W #$C800                        ;; 04EC7E : A9 00 C8    ;
CODE_04EC81:          STA $0D                             ;; 04EC81 : 85 0D       ;
CODE_04EC83:          LDA.W $1DEA                         ;; 04EC83 : AD EA 1D    ;
CODE_04EC86:          AND.W #$00FF                        ;; 04EC86 : 29 FF 00    ;
CODE_04EC89:          ASL                                 ;; 04EC89 : 0A          ;
CODE_04EC8A:          TAX                                 ;; 04EC8A : AA          ;
CODE_04EC8B:          LDA.L DATA_04D85D,X                 ;; 04EC8B : BF 5D D8 04 ;
CODE_04EC8F:          TAY                                 ;; 04EC8F : A8          ;
CODE_04EC90:          LDX.W #$0015                        ;; 04EC90 : A2 15 00    ;
CODE_04EC93:          SEP #$20                            ;; 04EC93 : E2 20       ; Accum (8 bit) 
CODE_04EC95:          LDA [$0D],Y                         ;; 04EC95 : B7 0D       ;
CODE_04EC97:          CMP.L DATA_04DA1D,X                 ;; 04EC97 : DF 1D DA 04 ;
CODE_04EC9B:          BEQ CODE_04ECA8                     ;; 04EC9B : F0 0B       ;
CODE_04EC9D:          DEX                                 ;; 04EC9D : CA          ;
CODE_04EC9E:          BPL CODE_04EC97                     ;; 04EC9E : 10 F7       ;
CODE_04ECA0:          SEP #$10                            ;; 04ECA0 : E2 10       ; Index (8 bit) 
CODE_04ECA2:          LDA.B #$07                          ;; 04ECA2 : A9 07       ;
CODE_04ECA4:          STA.W $1B86                         ;; 04ECA4 : 8D 86 1B    ;
Return04ECA7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04ECA8:          SEP #$30                            ;; 04ECA8 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04ECAA:          LDA.B #$01                          ;; 04ECAA : A9 01       ;
CODE_04ECAC:          STA.W $1DFC                         ;; 04ECAC : 8D FC 1D    ; / Play sound effect 
CODE_04ECAF:          INC.W $1B86                         ;; 04ECAF : EE 86 1B    ;
CODE_04ECB2:          LDA.W $1DEA                         ;; 04ECB2 : AD EA 1D    ;
CODE_04ECB5:          AND.B #$FF                          ;; 04ECB5 : 29 FF       ;
CODE_04ECB7:          ASL                                 ;; 04ECB7 : 0A          ;
CODE_04ECB8:          TAX                                 ;; 04ECB8 : AA          ;
CODE_04ECB9:          LDA.L DATA_04D85D,X                 ;; 04ECB9 : BF 5D D8 04 ;
CODE_04ECBD:          ASL                                 ;; 04ECBD : 0A          ;
CODE_04ECBE:          ASL                                 ;; 04ECBE : 0A          ;
CODE_04ECBF:          ASL                                 ;; 04ECBF : 0A          ;
CODE_04ECC0:          ASL                                 ;; 04ECC0 : 0A          ;
CODE_04ECC1:          STA.W $1B82                         ;; 04ECC1 : 8D 82 1B    ;
CODE_04ECC4:          LDA.L DATA_04D85D,X                 ;; 04ECC4 : BF 5D D8 04 ;
CODE_04ECC8:          AND.B #$F0                          ;; 04ECC8 : 29 F0       ;
CODE_04ECCA:          STA.W $1B83                         ;; 04ECCA : 8D 83 1B    ;
CODE_04ECCD:          LDA.B #$1C                          ;; 04ECCD : A9 1C       ;
CODE_04ECCF:          STA.W $1B84                         ;; 04ECCF : 8D 84 1B    ;
Return04ECD2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04ECD3:          .db $86,$99,$86,$19,$86,$D9,$86,$59 ;; 04ECD3               ;
                      .db $96,$99,$96,$19,$96,$D9,$96,$59 ;; ?QPWZ?               ;
                      .db $86,$9D,$86,$1D,$86,$DD,$86,$5D ;; ?QPWZ?               ;
                      .db $96,$9D,$96,$1D,$96,$DD,$96,$5D ;; ?QPWZ?               ;
                      .db $86,$99,$86,$19,$86,$D9,$86,$59 ;; ?QPWZ?               ;
                      .db $96,$99,$96,$19,$96,$D9,$96,$59 ;; ?QPWZ?               ;
                      .db $86,$9D,$86,$1D,$86,$DD,$86,$5D ;; ?QPWZ?               ;
                      .db $96,$9D,$96,$1D,$96,$DD,$96,$5D ;; ?QPWZ?               ;
                      .db $88,$15,$98,$15,$89,$15,$99,$15 ;; ?QPWZ?               ;
                      .db $A4,$11,$B4,$11,$A5,$11,$B5,$11 ;; ?QPWZ?               ;
                      .db $22,$11,$90,$11,$22,$11,$91,$11 ;; ?QPWZ?               ;
                      .db $C2,$11,$D2,$11,$C3,$11,$D3,$11 ;; ?QPWZ?               ;
                      .db $A6,$11,$B6,$11,$A7,$11,$B7,$11 ;; ?QPWZ?               ;
                      .db $82,$19,$92,$19,$83,$19,$93,$19 ;; ?QPWZ?               ;
                      .db $C8,$19,$F8,$19,$C9,$19,$F9,$19 ;; ?QPWZ?               ;
                      .db $80,$1C,$90,$1C,$81,$1C,$90,$5C ;; ?QPWZ?               ;
                      .db $80,$14,$90,$14,$81,$14,$90,$54 ;; ?QPWZ?               ;
                      .db $A2,$11,$B2,$11,$A3,$11,$B3,$11 ;; ?QPWZ?               ;
                      .db $82,$1D,$92,$1D,$83,$1D,$93,$1D ;; ?QPWZ?               ;
                      .db $86,$99,$86,$19,$86,$D9,$86,$59 ;; ?QPWZ?               ;
                      .db $86,$99,$86,$19,$86,$D9,$86,$59 ;; ?QPWZ?               ;
                      .db $A8,$11,$B8,$11,$A9,$11,$B9,$11 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_04ED83:          LDA.B #$7E                          ;; 04ED83 : A9 7E       ;
CODE_04ED85:          STA $0F                             ;; 04ED85 : 85 0F       ;
CODE_04ED87:          REP #$30                            ;; 04ED87 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04ED89:          LDA.W #$C800                        ;; 04ED89 : A9 00 C8    ;
CODE_04ED8C:          STA $0D                             ;; 04ED8C : 85 0D       ;
CODE_04ED8E:          LDA.W $1DEA                         ;; 04ED8E : AD EA 1D    ;
CODE_04ED91:          AND.W #$00FF                        ;; 04ED91 : 29 FF 00    ;
CODE_04ED94:          ASL                                 ;; 04ED94 : 0A          ;
CODE_04ED95:          TAX                                 ;; 04ED95 : AA          ;
CODE_04ED96:          LDA.L DATA_04D85D,X                 ;; 04ED96 : BF 5D D8 04 ;
CODE_04ED9A:          TAY                                 ;; 04ED9A : A8          ;
CODE_04ED9B:          LDX.W #$0015                        ;; 04ED9B : A2 15 00    ;
CODE_04ED9E:          SEP #$20                            ;; 04ED9E : E2 20       ; Accum (8 bit) 
CODE_04EDA0:          LDA [$0D],Y                         ;; 04EDA0 : B7 0D       ;
CODE_04EDA2:          CMP.L DATA_04DA1D,X                 ;; 04EDA2 : DF 1D DA 04 ;
CODE_04EDA6:          BEQ CODE_04EDAB                     ;; 04EDA6 : F0 03       ;
CODE_04EDA8:          DEX                                 ;; 04EDA8 : CA          ;
CODE_04EDA9:          BNE CODE_04EDA2                     ;; 04EDA9 : D0 F7       ;
CODE_04EDAB:          REP #$30                            ;; 04EDAB : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04EDAD:          STX $0E                             ;; 04EDAD : 86 0E       ;
CODE_04EDAF:          LDA.W $1DEA                         ;; 04EDAF : AD EA 1D    ;
CODE_04EDB2:          AND.W #$00FF                        ;; 04EDB2 : 29 FF 00    ;
CODE_04EDB5:          ASL                                 ;; 04EDB5 : 0A          ;
CODE_04EDB6:          TAX                                 ;; 04EDB6 : AA          ;
CODE_04EDB7:          LDA.L DATA_04D93D,X                 ;; 04EDB7 : BF 3D D9 04 ;
CODE_04EDBB:          STA $00                             ;; 04EDBB : 85 00       ;
CODE_04EDBD:          LDA.L DATA_04D85D,X                 ;; 04EDBD : BF 5D D8 04 ;
CODE_04EDC1:          TAX                                 ;; 04EDC1 : AA          ;
CODE_04EDC2:          PHX                                 ;; 04EDC2 : DA          ;
CODE_04EDC3:          LDX $0E                             ;; 04EDC3 : A6 0E       ;
CODE_04EDC5:          SEP #$20                            ;; 04EDC5 : E2 20       ; Accum (8 bit) 
CODE_04EDC7:          LDA.L DATA_04DA33,X                 ;; 04EDC7 : BF 33 DA 04 ;
CODE_04EDCB:          PLX                                 ;; 04EDCB : FA          ;
CODE_04EDCC:          STA.L $7EC800,X                     ;; 04EDCC : 9F 00 C8 7E ;
CODE_04EDD0:          LDA.B #$04                          ;; 04EDD0 : A9 04       ;
CODE_04EDD2:          STA $0C                             ;; 04EDD2 : 85 0C       ;
CODE_04EDD4:          REP #$20                            ;; 04EDD4 : C2 20       ; Accum (16 bit) 
CODE_04EDD6:          LDA.W #$ECD3                        ;; 04EDD6 : A9 D3 EC    ;
CODE_04EDD9:          STA $0A                             ;; 04EDD9 : 85 0A       ;
CODE_04EDDB:          LDA $0E                             ;; 04EDDB : A5 0E       ;
CODE_04EDDD:          ASL                                 ;; 04EDDD : 0A          ;
CODE_04EDDE:          ASL                                 ;; 04EDDE : 0A          ;
CODE_04EDDF:          ASL                                 ;; 04EDDF : 0A          ;
CODE_04EDE0:          TAY                                 ;; 04EDE0 : A8          ;
CODE_04EDE1:          LDA.L $7F837B                       ;; 04EDE1 : AF 7B 83 7F ;
CODE_04EDE5:          TAX                                 ;; 04EDE5 : AA          ;
CODE_04EDE6:          LDA $00                             ;; 04EDE6 : A5 00       ;
CODE_04EDE8:          STA.L $7F837D,X                     ;; 04EDE8 : 9F 7D 83 7F ;
CODE_04EDEC:          CLC                                 ;; 04EDEC : 18          ;
CODE_04EDED:          ADC.W #$2000                        ;; 04EDED : 69 00 20    ;
CODE_04EDF0:          STA.L $7F8385,X                     ;; 04EDF0 : 9F 85 83 7F ;
CODE_04EDF4:          LDA.W #$0300                        ;; 04EDF4 : A9 00 03    ;
CODE_04EDF7:          STA.L $7F837F,X                     ;; 04EDF7 : 9F 7F 83 7F ;
CODE_04EDFB:          STA.L $7F8387,X                     ;; 04EDFB : 9F 87 83 7F ;
CODE_04EDFF:          LDA [$0A],Y                         ;; 04EDFF : B7 0A       ;
CODE_04EE01:          STA.L $7F8381,X                     ;; 04EE01 : 9F 81 83 7F ;
CODE_04EE05:          INY                                 ;; 04EE05 : C8          ;
CODE_04EE06:          INY                                 ;; 04EE06 : C8          ;
CODE_04EE07:          LDA [$0A],Y                         ;; 04EE07 : B7 0A       ;
CODE_04EE09:          STA.L $7F8389,X                     ;; 04EE09 : 9F 89 83 7F ;
CODE_04EE0D:          INY                                 ;; 04EE0D : C8          ;
CODE_04EE0E:          INY                                 ;; 04EE0E : C8          ;
CODE_04EE0F:          LDA [$0A],Y                         ;; 04EE0F : B7 0A       ;
CODE_04EE11:          STA.L $7F8383,X                     ;; 04EE11 : 9F 83 83 7F ;
CODE_04EE15:          INY                                 ;; 04EE15 : C8          ;
CODE_04EE16:          INY                                 ;; 04EE16 : C8          ;
CODE_04EE17:          LDA [$0A],Y                         ;; 04EE17 : B7 0A       ;
CODE_04EE19:          STA.L $7F838B,X                     ;; 04EE19 : 9F 8B 83 7F ;
CODE_04EE1D:          LDA.W #$00FF                        ;; 04EE1D : A9 FF 00    ;
CODE_04EE20:          STA.L $7F838D,X                     ;; 04EE20 : 9F 8D 83 7F ;
CODE_04EE24:          TXA                                 ;; 04EE24 : 8A          ;
CODE_04EE25:          CLC                                 ;; 04EE25 : 18          ;
CODE_04EE26:          ADC.W #$0010                        ;; 04EE26 : 69 10 00    ;
CODE_04EE29:          STA.L $7F837B                       ;; 04EE29 : 8F 7B 83 7F ;
CODE_04EE2D:          SEP #$30                            ;; 04EE2D : E2 30       ; Index (8 bit) Accum (8 bit) 
Return04EE2F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04EE30:          SEP #$20                            ;; 04EE30 : E2 20       ; Accum (8 bit) 
CODE_04EE32:          LDA.B #$7F                          ;; 04EE32 : A9 7F       ;
CODE_04EE34:          STA $0E                             ;; 04EE34 : 85 0E       ;
CODE_04EE36:          REP #$30                            ;; 04EE36 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04EE38:          LDA.W $1DEB                         ;; 04EE38 : AD EB 1D    ;
CODE_04EE3B:          ASL                                 ;; 04EE3B : 0A          ;
CODE_04EE3C:          ASL                                 ;; 04EE3C : 0A          ;
CODE_04EE3D:          TAX                                 ;; 04EE3D : AA          ;
CODE_04EE3E:          LDA.L DATA_04DD8F,X                 ;; 04EE3E : BF 8F DD 04 ;
CODE_04EE42:          STA $00                             ;; 04EE42 : 85 00       ;
CODE_04EE44:          AND.W #$1FFF                        ;; 04EE44 : 29 FF 1F    ;
CODE_04EE47:          LSR                                 ;; 04EE47 : 4A          ;
CODE_04EE48:          CLC                                 ;; 04EE48 : 18          ;
CODE_04EE49:          ADC.W #$3000                        ;; 04EE49 : 69 00 30    ;
CODE_04EE4C:          XBA                                 ;; 04EE4C : EB          ;
CODE_04EE4D:          STA $02                             ;; 04EE4D : 85 02       ;
CODE_04EE4F:          LDA.W #$4000                        ;; 04EE4F : A9 00 40    ;
CODE_04EE52:          STA $0C                             ;; 04EE52 : 85 0C       ;
CODE_04EE54:          LDA.W #$FFFF                        ;; 04EE54 : A9 FF FF    ;
CODE_04EE57:          STA $0A                             ;; 04EE57 : 85 0A       ;
CODE_04EE59:          LDA.L DATA_04DD8D,X                 ;; 04EE59 : BF 8D DD 04 ;
CODE_04EE5D:          CMP.W #$0900                        ;; 04EE5D : C9 00 09    ;
CODE_04EE60:          BCC CODE_04EE68                     ;; 04EE60 : 90 06       ;
CODE_04EE62:          JSR.W CODE_04E76C                   ;; 04EE62 : 20 6C E7    ;
CODE_04EE65:          JMP.W CODE_04EE6B                   ;; 04EE65 : 4C 6B EE    ;
                                                          ;;                      ;
CODE_04EE68:          JSR.W CODE_04E824                   ;; 04EE68 : 20 24 E8    ;
CODE_04EE6B:          LDA.W #$00FF                        ;; 04EE6B : A9 FF 00    ;
CODE_04EE6E:          STA.L $7F837D,X                     ;; 04EE6E : 9F 7D 83 7F ;
CODE_04EE72:          TXA                                 ;; 04EE72 : 8A          ;
CODE_04EE73:          STA.L $7F837B                       ;; 04EE73 : 8F 7B 83 7F ;
CODE_04EE77:          SEP #$30                            ;; 04EE77 : E2 30       ; Index (8 bit) Accum (8 bit) 
Return04EE79:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04EE7A:          .db $22,$01,$82,$1C,$22,$01,$83,$1C ;; 04EE7A               ;
                      .db $22,$01,$82,$14,$22,$01,$83,$14 ;; ?QPWZ?               ;
                      .db $EA,$01,$EA,$01,$EA,$C1,$EA,$C1 ;; ?QPWZ?               ;
                      .db $EA,$01,$EA,$01,$EA,$C1,$EA,$C1 ;; ?QPWZ?               ;
                      .db $22,$01,$22,$01,$22,$01,$22,$01 ;; ?QPWZ?               ;
                      .db $8A,$15,$9A,$15,$8B,$15,$9B,$15 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_04EEAA:          SEP #$30                            ;; 04EEAA : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_04EEAC:          LDA.B #$7E                          ;; 04EEAC : A9 7E       ;
CODE_04EEAE:          STA $0F                             ;; 04EEAE : 85 0F       ;
CODE_04EEB0:          LDA.B #$04                          ;; 04EEB0 : A9 04       ;
CODE_04EEB2:          STA $0C                             ;; 04EEB2 : 85 0C       ;
CODE_04EEB4:          REP #$30                            ;; 04EEB4 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_04EEB6:          LDA.W #$C800                        ;; 04EEB6 : A9 00 C8    ;
CODE_04EEB9:          STA $0D                             ;; 04EEB9 : 85 0D       ;
CODE_04EEBB:          LDA.W #$EE7A                        ;; 04EEBB : A9 7A EE    ;
CODE_04EEBE:          STA $0A                             ;; 04EEBE : 85 0A       ;
CODE_04EEC0:          LDA.W $13D1                         ;; 04EEC0 : AD D1 13    ;
CODE_04EEC3:          AND.W #$00FF                        ;; 04EEC3 : 29 FF 00    ;
CODE_04EEC6:          ASL                                 ;; 04EEC6 : 0A          ;
CODE_04EEC7:          TAX                                 ;; 04EEC7 : AA          ;
CODE_04EEC8:          LDA.L DATA_04E587,X                 ;; 04EEC8 : BF 87 E5 04 ;
CODE_04EECC:          STA $00                             ;; 04EECC : 85 00       ;
CODE_04EECE:          LDA.L $7F837B                       ;; 04EECE : AF 7B 83 7F ;
CODE_04EED2:          TAX                                 ;; 04EED2 : AA          ;
CODE_04EED3:          LDA.W $13D0                         ;; 04EED3 : AD D0 13    ;
CODE_04EED6:          AND.W #$00FF                        ;; 04EED6 : 29 FF 00    ;
CODE_04EED9:          CMP.W #$0003                        ;; 04EED9 : C9 03 00    ;
CODE_04EEDC:          BMI CODE_04EF27                     ;; 04EEDC : 30 49       ;
CODE_04EEDE:          ASL                                 ;; 04EEDE : 0A          ;
CODE_04EEDF:          ASL                                 ;; 04EEDF : 0A          ;
CODE_04EEE0:          ASL                                 ;; 04EEE0 : 0A          ;
CODE_04EEE1:          TAY                                 ;; 04EEE1 : A8          ;
CODE_04EEE2:          LDA $00                             ;; 04EEE2 : A5 00       ;
CODE_04EEE4:          STA.L $7F837D,X                     ;; 04EEE4 : 9F 7D 83 7F ;
CODE_04EEE8:          CLC                                 ;; 04EEE8 : 18          ;
CODE_04EEE9:          ADC.W #$2000                        ;; 04EEE9 : 69 00 20    ;
CODE_04EEEC:          STA.L $7F8385,X                     ;; 04EEEC : 9F 85 83 7F ;
CODE_04EEF0:          XBA                                 ;; 04EEF0 : EB          ;
CODE_04EEF1:          CLC                                 ;; 04EEF1 : 18          ;
CODE_04EEF2:          ADC.W #$0020                        ;; 04EEF2 : 69 20 00    ;
CODE_04EEF5:          XBA                                 ;; 04EEF5 : EB          ;
CODE_04EEF6:          STA $00                             ;; 04EEF6 : 85 00       ;
CODE_04EEF8:          LDA.W #$0300                        ;; 04EEF8 : A9 00 03    ;
CODE_04EEFB:          STA.L $7F837F,X                     ;; 04EEFB : 9F 7F 83 7F ;
CODE_04EEFF:          STA.L $7F8387,X                     ;; 04EEFF : 9F 87 83 7F ;
CODE_04EF03:          LDA [$0A],Y                         ;; 04EF03 : B7 0A       ;
CODE_04EF05:          STA.L $7F8381,X                     ;; 04EF05 : 9F 81 83 7F ;
CODE_04EF09:          INY                                 ;; 04EF09 : C8          ;
CODE_04EF0A:          INY                                 ;; 04EF0A : C8          ;
CODE_04EF0B:          LDA [$0A],Y                         ;; 04EF0B : B7 0A       ;
CODE_04EF0D:          STA.L $7F8389,X                     ;; 04EF0D : 9F 89 83 7F ;
CODE_04EF11:          INY                                 ;; 04EF11 : C8          ;
CODE_04EF12:          INY                                 ;; 04EF12 : C8          ;
CODE_04EF13:          LDA [$0A],Y                         ;; 04EF13 : B7 0A       ;
CODE_04EF15:          STA.L $7F8383,X                     ;; 04EF15 : 9F 83 83 7F ;
CODE_04EF19:          INY                                 ;; 04EF19 : C8          ;
CODE_04EF1A:          INY                                 ;; 04EF1A : C8          ;
CODE_04EF1B:          LDA [$0A],Y                         ;; 04EF1B : B7 0A       ;
CODE_04EF1D:          STA.L $7F838B,X                     ;; 04EF1D : 9F 8B 83 7F ;
CODE_04EF21:          TXA                                 ;; 04EF21 : 8A          ;
CODE_04EF22:          CLC                                 ;; 04EF22 : 18          ;
CODE_04EF23:          ADC.W #$0010                        ;; 04EF23 : 69 10 00    ;
CODE_04EF26:          TAX                                 ;; 04EF26 : AA          ;
CODE_04EF27:          LDA.W $13D0                         ;; 04EF27 : AD D0 13    ;
CODE_04EF2A:          AND.W #$00FF                        ;; 04EF2A : 29 FF 00    ;
CODE_04EF2D:          CMP.W #$0002                        ;; 04EF2D : C9 02 00    ;
CODE_04EF30:          BPL CODE_04EF38                     ;; 04EF30 : 10 06       ;
CODE_04EF32:          ASL                                 ;; 04EF32 : 0A          ;
CODE_04EF33:          ASL                                 ;; 04EF33 : 0A          ;
CODE_04EF34:          ASL                                 ;; 04EF34 : 0A          ;
CODE_04EF35:          TAY                                 ;; 04EF35 : A8          ;
CODE_04EF36:          BRA CODE_04EF3B                     ;; 04EF36 : 80 03       ;
                                                          ;;                      ;
CODE_04EF38:          LDY.W #$0028                        ;; 04EF38 : A0 28 00    ;
CODE_04EF3B:          JMP.W CODE_04EDE6                   ;; 04EF3B : 4C E6 ED    ;
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04EF3E:          .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; 04EF3E               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04F280:          .db $00,$D8,$28,$D0,$30,$D8,$28,$00 ;; 04F280               ;
DATA_04F288:          .db $D0,$D8,$D8,$00,$00,$28,$28,$30 ;; 04F288               ;
                                                          ;;                      ;
CODE_04F290:          LDY.W $1439                         ;; 04F290 : AC 39 14    ; Index (8 bit) Accum (8 bit) 
CODE_04F293:          CPY.B #$0C                          ;; 04F293 : C0 0C       ;
CODE_04F295:          BCC CODE_04F29B                     ;; 04F295 : 90 04       ;
CODE_04F297:          STZ.W $13D2                         ;; 04F297 : 9C D2 13    ;
Return04F29A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04F29B:          LDA.W $1437                         ;; 04F29B : AD 37 14    ;
CODE_04F29E:          BNE CODE_04F314                     ;; 04F29E : D0 74       ;
CODE_04F2A0:          CPY.B #$08                          ;; 04F2A0 : C0 08       ;
CODE_04F2A2:          BCS CODE_04F30C                     ;; 04F2A2 : B0 68       ;
CODE_04F2A4:          LDA.B #$1C                          ;; 04F2A4 : A9 1C       ;
CODE_04F2A6:          STA.W $1DFC                         ;; 04F2A6 : 8D FC 1D    ; / Play sound effect 
CODE_04F2A9:          LDA.B #$07                          ;; 04F2A9 : A9 07       ;
CODE_04F2AB:          STA $00                             ;; 04F2AB : 85 00       ;
CODE_04F2AD:          LDX.W RAM_KeyHolePos1               ;; 04F2AD : AE 36 14    ;
CODE_04F2B0:          LDY.W $0DD6                         ;; 04F2B0 : AC D6 0D    ;
CODE_04F2B3:          LDA.W $1F17,Y                       ;; 04F2B3 : B9 17 1F    ;
CODE_04F2B6:          STA.L $7EB978,X                     ;; 04F2B6 : 9F 78 B9 7E ;
CODE_04F2BA:          LDA.W $1F18,Y                       ;; 04F2BA : B9 18 1F    ;
CODE_04F2BD:          STA.L $7EB900,X                     ;; 04F2BD : 9F 00 B9 7E ;
CODE_04F2C1:          LDA.W $1F19,Y                       ;; 04F2C1 : B9 19 1F    ;
CODE_04F2C4:          STA.L $7EB9A0,X                     ;; 04F2C4 : 9F A0 B9 7E ;
CODE_04F2C8:          LDA.W $1F1A,Y                       ;; 04F2C8 : B9 1A 1F    ;
CODE_04F2CB:          STA.L $7EB928,X                     ;; 04F2CB : 9F 28 B9 7E ;
CODE_04F2CF:          LDA.B #$00                          ;; 04F2CF : A9 00       ;
CODE_04F2D1:          STA.L $7EB9C8,X                     ;; 04F2D1 : 9F C8 B9 7E ;
CODE_04F2D5:          STA.L $7EB950,X                     ;; 04F2D5 : 9F 50 B9 7E ;
CODE_04F2D9:          LDY $00                             ;; 04F2D9 : A4 00       ;
CODE_04F2DB:          LDA.W DATA_04F280,Y                 ;; 04F2DB : B9 80 F2    ;
CODE_04F2DE:          STA.L $7EB9F0,X                     ;; 04F2DE : 9F F0 B9 7E ;
CODE_04F2E2:          LDA.W DATA_04F288,Y                 ;; 04F2E2 : B9 88 F2    ;
CODE_04F2E5:          STA.L $7EBA18,X                     ;; 04F2E5 : 9F 18 BA 7E ;
CODE_04F2E9:          LDA.B #$D0                          ;; 04F2E9 : A9 D0       ;
CODE_04F2EB:          STA.L $7EBA40,X                     ;; 04F2EB : 9F 40 BA 7E ;
CODE_04F2EF:          INX                                 ;; 04F2EF : E8          ;
CODE_04F2F0:          DEC $00                             ;; 04F2F0 : C6 00       ;
CODE_04F2F2:          BPL CODE_04F2B0                     ;; 04F2F2 : 10 BC       ;
CODE_04F2F4:          CPX.B #$28                          ;; 04F2F4 : E0 28       ;
CODE_04F2F6:          BCC CODE_04F309                     ;; 04F2F6 : 90 11       ;
CODE_04F2F8:          LDA.W RAM_KeyHolePos2               ;; 04F2F8 : AD 38 14    ;
CODE_04F2FB:          CLC                                 ;; 04F2FB : 18          ;
CODE_04F2FC:          ADC.B #$20                          ;; 04F2FC : 69 20       ;
CODE_04F2FE:          CMP.B #$A0                          ;; 04F2FE : C9 A0       ;
CODE_04F300:          BCC CODE_04F304                     ;; 04F300 : 90 02       ;
ADDR_04F302:          LDA.B #$00                          ;; 04F302 : A9 00       ;
CODE_04F304:          STA.W RAM_KeyHolePos2               ;; 04F304 : 8D 38 14    ;
CODE_04F307:          LDX.B #$00                          ;; 04F307 : A2 00       ;
CODE_04F309:          STX.W RAM_KeyHolePos1               ;; 04F309 : 8E 36 14    ;
CODE_04F30C:          LDA.B #$10                          ;; 04F30C : A9 10       ;
CODE_04F30E:          STA.W $1437                         ;; 04F30E : 8D 37 14    ;
CODE_04F311:          INC.W $1439                         ;; 04F311 : EE 39 14    ;
CODE_04F314:          DEC.W $1437                         ;; 04F314 : CE 37 14    ;
CODE_04F317:          LDA.W RAM_KeyHolePos2               ;; 04F317 : AD 38 14    ;
CODE_04F31A:          STA $0F                             ;; 04F31A : 85 0F       ;
CODE_04F31C:          LDX.B #$00                          ;; 04F31C : A2 00       ;
CODE_04F31E:          PHX                                 ;; 04F31E : DA          ;
CODE_04F31F:          LDY.B #$00                          ;; 04F31F : A0 00       ;
CODE_04F321:          JSR.W CODE_04F39C                   ;; 04F321 : 20 9C F3    ;
CODE_04F324:          JSR.W CODE_04F397                   ;; 04F324 : 20 97 F3    ;
CODE_04F327:          JSR.W CODE_04F397                   ;; 04F327 : 20 97 F3    ;
CODE_04F32A:          PLX                                 ;; 04F32A : FA          ;
CODE_04F32B:          LDA.L $7EBA40,X                     ;; 04F32B : BF 40 BA 7E ;
CODE_04F32F:          CLC                                 ;; 04F32F : 18          ;
CODE_04F330:          ADC.B #$01                          ;; 04F330 : 69 01       ;
CODE_04F332:          BMI CODE_04F33A                     ;; 04F332 : 30 06       ;
CODE_04F334:          CMP.B #$40                          ;; 04F334 : C9 40       ;
CODE_04F336:          BCC CODE_04F33A                     ;; 04F336 : 90 02       ;
CODE_04F338:          LDA.B #$40                          ;; 04F338 : A9 40       ;
CODE_04F33A:          STA.L $7EBA40,X                     ;; 04F33A : 9F 40 BA 7E ;
CODE_04F33E:          LDA.L $7EB950,X                     ;; 04F33E : BF 50 B9 7E ;
CODE_04F342:          XBA                                 ;; 04F342 : EB          ;
CODE_04F343:          LDA.L $7EB9C8,X                     ;; 04F343 : BF C8 B9 7E ;
CODE_04F347:          REP #$20                            ;; 04F347 : C2 20       ; Accum (16 bit) 
CODE_04F349:          CLC                                 ;; 04F349 : 18          ;
CODE_04F34A:          ADC $02                             ;; 04F34A : 65 02       ;
CODE_04F34C:          STA $02                             ;; 04F34C : 85 02       ;
CODE_04F34E:          SEP #$20                            ;; 04F34E : E2 20       ; Accum (8 bit) 
CODE_04F350:          XBA                                 ;; 04F350 : EB          ;
CODE_04F351:          ORA $01                             ;; 04F351 : 05 01       ;
CODE_04F353:          BNE CODE_04F378                     ;; 04F353 : D0 23       ;
CODE_04F355:          LDY $0F                             ;; 04F355 : A4 0F       ;
CODE_04F357:          XBA                                 ;; 04F357 : EB          ;
CODE_04F358:          STA.W $0341,Y                       ;; 04F358 : 99 41 03    ;
CODE_04F35B:          LDA $00                             ;; 04F35B : A5 00       ;
CODE_04F35D:          STA.W $0340,Y                       ;; 04F35D : 99 40 03    ;
CODE_04F360:          LDA.B #$E6                          ;; 04F360 : A9 E6       ;
CODE_04F362:          STA.W $0342,Y                       ;; 04F362 : 99 42 03    ;
CODE_04F365:          LDA.W $13D2                         ;; 04F365 : AD D2 13    ;
CODE_04F368:          DEC A                               ;; 04F368 : 3A          ;
CODE_04F369:          ASL                                 ;; 04F369 : 0A          ;
CODE_04F36A:          ORA.B #$30                          ;; 04F36A : 09 30       ;
CODE_04F36C:          STA.W $0343,Y                       ;; 04F36C : 99 43 03    ;
CODE_04F36F:          TYA                                 ;; 04F36F : 98          ;
CODE_04F370:          LSR                                 ;; 04F370 : 4A          ;
CODE_04F371:          LSR                                 ;; 04F371 : 4A          ;
CODE_04F372:          TAY                                 ;; 04F372 : A8          ;
CODE_04F373:          LDA.B #$02                          ;; 04F373 : A9 02       ;
CODE_04F375:          STA.W $0470,Y                       ;; 04F375 : 99 70 04    ;
CODE_04F378:          LDA $0F                             ;; 04F378 : A5 0F       ;
CODE_04F37A:          CLC                                 ;; 04F37A : 18          ;
CODE_04F37B:          ADC.B #$04                          ;; 04F37B : 69 04       ;
CODE_04F37D:          CMP.B #$A0                          ;; 04F37D : C9 A0       ;
CODE_04F37F:          BCC CODE_04F383                     ;; 04F37F : 90 02       ;
CODE_04F381:          LDA.B #$00                          ;; 04F381 : A9 00       ;
CODE_04F383:          STA $0F                             ;; 04F383 : 85 0F       ;
CODE_04F385:          INX                                 ;; 04F385 : E8          ;
CODE_04F386:          CPX.W RAM_KeyHolePos1               ;; 04F386 : EC 36 14    ;
CODE_04F389:          BCC CODE_04F31E                     ;; 04F389 : 90 93       ;
CODE_04F38B:          LDA.W $1439                         ;; 04F38B : AD 39 14    ;
CODE_04F38E:          CMP.B #$05                          ;; 04F38E : C9 05       ;
CODE_04F390:          BCC Return04F396                    ;; 04F390 : 90 04       ;
CODE_04F392:          CPX.B #$28                          ;; 04F392 : E0 28       ;
CODE_04F394:          BCC CODE_04F31E                     ;; 04F394 : 90 88       ;
Return04F396:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04F397:          TXA                                 ;; 04F397 : 8A          ;
CODE_04F398:          CLC                                 ;; 04F398 : 18          ;
CODE_04F399:          ADC.B #$28                          ;; 04F399 : 69 28       ;
CODE_04F39B:          TAX                                 ;; 04F39B : AA          ;
CODE_04F39C:          PHY                                 ;; 04F39C : 5A          ;
CODE_04F39D:          LDA.L $7EB9F0,X                     ;; 04F39D : BF F0 B9 7E ;
CODE_04F3A1:          ASL                                 ;; 04F3A1 : 0A          ;
CODE_04F3A2:          ASL                                 ;; 04F3A2 : 0A          ;
CODE_04F3A3:          ASL                                 ;; 04F3A3 : 0A          ;
CODE_04F3A4:          ASL                                 ;; 04F3A4 : 0A          ;
CODE_04F3A5:          CLC                                 ;; 04F3A5 : 18          ;
CODE_04F3A6:          ADC.L $7EBA68,X                     ;; 04F3A6 : 7F 68 BA 7E ;
CODE_04F3AA:          STA.L $7EBA68,X                     ;; 04F3AA : 9F 68 BA 7E ;
CODE_04F3AE:          LDA.L $7EB9F0,X                     ;; 04F3AE : BF F0 B9 7E ;
CODE_04F3B2:          PHP                                 ;; 04F3B2 : 08          ;
CODE_04F3B3:          LSR                                 ;; 04F3B3 : 4A          ;
CODE_04F3B4:          LSR                                 ;; 04F3B4 : 4A          ;
CODE_04F3B5:          LSR                                 ;; 04F3B5 : 4A          ;
CODE_04F3B6:          LSR                                 ;; 04F3B6 : 4A          ;
CODE_04F3B7:          LDY.B #$00                          ;; 04F3B7 : A0 00       ;
CODE_04F3B9:          PLP                                 ;; 04F3B9 : 28          ;
CODE_04F3BA:          BPL CODE_04F3BF                     ;; 04F3BA : 10 03       ;
CODE_04F3BC:          ORA.B #$F0                          ;; 04F3BC : 09 F0       ;
CODE_04F3BE:          DEY                                 ;; 04F3BE : 88          ;
CODE_04F3BF:          ADC.L $7EB978,X                     ;; 04F3BF : 7F 78 B9 7E ;
CODE_04F3C3:          STA.L $7EB978,X                     ;; 04F3C3 : 9F 78 B9 7E ;
CODE_04F3C7:          XBA                                 ;; 04F3C7 : EB          ;
CODE_04F3C8:          TYA                                 ;; 04F3C8 : 98          ;
CODE_04F3C9:          ADC.L $7EB900,X                     ;; 04F3C9 : 7F 00 B9 7E ;
CODE_04F3CD:          STA.L $7EB900,X                     ;; 04F3CD : 9F 00 B9 7E ;
CODE_04F3D1:          XBA                                 ;; 04F3D1 : EB          ;
CODE_04F3D2:          PLY                                 ;; 04F3D2 : 7A          ;
CODE_04F3D3:          REP #$20                            ;; 04F3D3 : C2 20       ; Accum (16 bit) 
CODE_04F3D5:          SEC                                 ;; 04F3D5 : 38          ;
CODE_04F3D6:          SBC.W RAM_ScreenBndryXLo,Y          ;; 04F3D6 : F9 1A 00    ;
CODE_04F3D9:          SEC                                 ;; 04F3D9 : 38          ;
CODE_04F3DA:          SBC.W #$0008                        ;; 04F3DA : E9 08 00    ;
CODE_04F3DD:          STA.W $0000,Y                       ;; 04F3DD : 99 00 00    ;
CODE_04F3E0:          SEP #$20                            ;; 04F3E0 : E2 20       ; Accum (8 bit) 
CODE_04F3E2:          INY                                 ;; 04F3E2 : C8          ;
CODE_04F3E3:          INY                                 ;; 04F3E3 : C8          ;
Return04F3E4:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04F3E5:          DEC A                               ;; 04F3E5 : 3A          ;
CODE_04F3E6:          JSL.L ExecutePtr                    ;; 04F3E6 : 22 DF 86 00 ;
                                                          ;;                      ;
Ptrs04F3EA:           .dw CODE_04F3FF                     ;; ?QPWZ? : FF F3       ;
                      .dw CODE_04F415                     ;; ?QPWZ? : 15 F4       ;
                      .dw CODE_04F513                     ;; ?QPWZ? : 13 F5       ;
                      .dw CODE_04F415                     ;; ?QPWZ? : 15 F4       ;
                      .dw CODE_04F3FF                     ;; ?QPWZ? : FF F3       ;
                      .dw CODE_04F415                     ;; ?QPWZ? : 15 F4       ;
                      .dw CODE_04F3FA                     ;; ?QPWZ? : FA F3       ;
                      .dw CODE_04F415                     ;; ?QPWZ? : 15 F4       ;
                                                          ;;                      ;
CODE_04F3FA:          JSL.L CODE_009BA8                   ;; 04F3FA : 22 A8 9B 00 ;
Return04F3FE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04F3FF:          LDA.B #$22                          ;; 04F3FF : A9 22       ;
CODE_04F401:          STA.W $1DFC                         ;; 04F401 : 8D FC 1D    ; / Play sound effect 
CODE_04F404:          INC.W $1B87                         ;; 04F404 : EE 87 1B    ;
CODE_04F407:          STZ $41                             ;; 04F407 : 64 41       ;
CODE_04F409:          STZ $42                             ;; 04F409 : 64 42       ;
CODE_04F40B:          STZ $43                             ;; 04F40B : 64 43       ;
CODE_04F40D:          STZ.W $0D9F                         ;; 04F40D : 9C 9F 0D    ;
Return04F410:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04F411:          .db $04,$FC                         ;; 04F411               ;
                                                          ;;                      ;
DATA_04F413:          .db $68,$00                         ;; 04F413               ;
                                                          ;;                      ;
CODE_04F415:          LDX.B #$00                          ;; 04F415 : A2 00       ;
CODE_04F417:          LDA.W RAM_PlayerLives               ;; 04F417 : AD B4 0D    ;
CODE_04F41A:          CMP.W $0DB5                         ;; 04F41A : CD B5 0D    ;
CODE_04F41D:          BPL CODE_04F420                     ;; 04F41D : 10 01       ;
ADDR_04F41F:          INX                                 ;; 04F41F : E8          ;
CODE_04F420:          STX.W $1B8A                         ;; 04F420 : 8E 8A 1B    ;
CODE_04F423:          LDX.W $1B88                         ;; 04F423 : AE 88 1B    ;
CODE_04F426:          LDA.W $1B89                         ;; 04F426 : AD 89 1B    ;
CODE_04F429:          CMP.L DATA_04F413,X                 ;; 04F429 : DF 13 F4 04 ;
CODE_04F42D:          BNE CODE_04F44B                     ;; 04F42D : D0 1C       ;
CODE_04F42F:          INC.W $1B87                         ;; 04F42F : EE 87 1B    ;
CODE_04F432:          LDA.W $1B87                         ;; 04F432 : AD 87 1B    ;
CODE_04F435:          CMP.B #$07                          ;; 04F435 : C9 07       ;
CODE_04F437:          BNE CODE_04F43D                     ;; 04F437 : D0 04       ;
CODE_04F439:          LDY.B #$1E                          ;; 04F439 : A0 1E       ;
CODE_04F43B:          STY $12                             ;; 04F43B : 84 12       ;
CODE_04F43D:          DEC A                               ;; 04F43D : 3A          ;
CODE_04F43E:          AND.B #$03                          ;; 04F43E : 29 03       ;
CODE_04F440:          BNE Return04F44A                    ;; 04F440 : D0 08       ;
CODE_04F442:          STZ.W $1B87                         ;; 04F442 : 9C 87 1B    ;
CODE_04F445:          STZ.W $1B88                         ;; 04F445 : 9C 88 1B    ;
CODE_04F448:          BRA CODE_04F407                     ;; 04F448 : 80 BD       ;
                                                          ;;                      ;
Return04F44A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04F44B:          CLC                                 ;; 04F44B : 18          ;
CODE_04F44C:          ADC.L DATA_04F411,X                 ;; 04F44C : 7F 11 F4 04 ;
CODE_04F450:          STA.W $1B89                         ;; 04F450 : 8D 89 1B    ;
CODE_04F453:          CLC                                 ;; 04F453 : 18          ;
CODE_04F454:          ADC.B #$80                          ;; 04F454 : 69 80       ;
CODE_04F456:          XBA                                 ;; 04F456 : EB          ;
CODE_04F457:          REP #$10                            ;; 04F457 : C2 10       ; Index (16 bit) 
CODE_04F459:          LDX.W #$016E                        ;; 04F459 : A2 6E 01    ;
CODE_04F45C:          LDA.B #$FF                          ;; 04F45C : A9 FF       ;
CODE_04F45E:          STA.W $04F0,X                       ;; 04F45E : 9D F0 04    ;
CODE_04F461:          STZ.W $04F1,X                       ;; 04F461 : 9E F1 04    ;
CODE_04F464:          DEX                                 ;; 04F464 : CA          ;
CODE_04F465:          DEX                                 ;; 04F465 : CA          ;
CODE_04F466:          BPL CODE_04F45E                     ;; 04F466 : 10 F6       ;
CODE_04F468:          SEP #$10                            ;; 04F468 : E2 10       ; Index (8 bit) 
CODE_04F46A:          LDA.W $1B89                         ;; 04F46A : AD 89 1B    ;
CODE_04F46D:          LSR                                 ;; 04F46D : 4A          ;
CODE_04F46E:          ADC.W $1B89                         ;; 04F46E : 6D 89 1B    ;
CODE_04F471:          LSR                                 ;; 04F471 : 4A          ;
CODE_04F472:          AND.B #$FE                          ;; 04F472 : 29 FE       ;
CODE_04F474:          TAX                                 ;; 04F474 : AA          ;
CODE_04F475:          LDA.B #$80                          ;; 04F475 : A9 80       ;
CODE_04F477:          SEC                                 ;; 04F477 : 38          ;
CODE_04F478:          SBC.W $1B89                         ;; 04F478 : ED 89 1B    ;
CODE_04F47B:          REP #$20                            ;; 04F47B : C2 20       ; Accum (16 bit) 
CODE_04F47D:          LDY.B #$48                          ;; 04F47D : A0 48       ;
CODE_04F47F:          STA.W $0548,Y                       ;; 04F47F : 99 48 05    ;
CODE_04F482:          STA.W $0590,X                       ;; 04F482 : 9D 90 05    ;
CODE_04F485:          DEY                                 ;; 04F485 : 88          ;
CODE_04F486:          DEY                                 ;; 04F486 : 88          ;
CODE_04F487:          DEX                                 ;; 04F487 : CA          ;
CODE_04F488:          DEX                                 ;; 04F488 : CA          ;
CODE_04F489:          BPL CODE_04F47F                     ;; 04F489 : 10 F4       ;
CODE_04F48B:          STZ.W $0701                         ;; 04F48B : 9C 01 07    ;
CODE_04F48E:          SEP #$20                            ;; 04F48E : E2 20       ; Accum (8 bit) 
CODE_04F490:          LDA.B #$22                          ;; 04F490 : A9 22       ;
CODE_04F492:          STA $41                             ;; 04F492 : 85 41       ;
CODE_04F494:          LDA.B #$20                          ;; 04F494 : A9 20       ;
CODE_04F496:          JMP.W CODE_04DB95                   ;; 04F496 : 4C 95 DB    ;
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04F499:          .db $51,$C4,$40,$24,$FC,$38,$52,$04 ;; 04F499               ;
                      .db $40,$2C,$FC,$38,$52,$2F,$40,$02 ;; ?QPWZ?               ;
                      .db $FC,$38,$52,$48,$40,$1C,$FC,$38 ;; ?QPWZ?               ;
                      .db $FF                             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04F4B2:          .db $52,$49,$00,$09,$16,$28,$0A,$28 ;; 04F4B2               ;
                      .db $1B,$28,$12,$28,$18,$28,$52,$52 ;; ?QPWZ?               ;
                      .db $00,$09,$15,$28,$1E,$28,$12,$28 ;; ?QPWZ?               ;
                      .db $10,$28,$12,$28,$52,$0B,$00,$05 ;; ?QPWZ?               ;
                      .db $26,$28,$00,$28,$00,$28,$52,$14 ;; ?QPWZ?               ;
                      .db $00,$05,$26,$28,$00,$28,$00,$28 ;; ?QPWZ?               ;
                      .db $52,$0F,$00,$03,$FC,$38,$FC,$38 ;; ?QPWZ?               ;
                      .db $52,$2F,$00,$03,$FC,$38,$FC,$38 ;; ?QPWZ?               ;
                      .db $51,$C9,$00,$03,$85,$29,$85,$69 ;; ?QPWZ?               ;
                      .db $51,$D2,$00,$03,$85,$29,$85,$69 ;; ?QPWZ?               ;
                      .db $FF                             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04F503:          .db $7D,$38,$7E,$78                 ;; 04F503               ;
                                                          ;;                      ;
DATA_04F507:          .db $7E,$38,$7D,$78                 ;; 04F507               ;
                                                          ;;                      ;
DATA_04F50B:          .db $7D,$B8,$7E,$F8                 ;; 04F50B               ;
                                                          ;;                      ;
DATA_04F50F:          .db $7E,$B8,$7D,$F8                 ;; 04F50F               ;
                                                          ;;                      ;
CODE_04F513:          LDA.W RAM_OWControllerA             ;; 04F513 : AD A6 0D    ;
CODE_04F516:          ORA.W $0DA7                         ;; 04F516 : 0D A7 0D    ;
CODE_04F519:          AND.B #$10                          ;; 04F519 : 29 10       ;
CODE_04F51B:          BEQ CODE_04F52B                     ;; 04F51B : F0 0E       ;
CODE_04F51D:          LDX.W $0DB3                         ;; 04F51D : AE B3 0D    ;
CODE_04F520:          LDA.W RAM_PlayerLives,X             ;; 04F520 : BD B4 0D    ;
CODE_04F523:          STA.W RAM_StatusLives               ;; 04F523 : 8D BE 0D    ;
CODE_04F526:          JSL.L CODE_009C13                   ;; 04F526 : 22 13 9C 00 ;
Return04F52A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04F52B:          LDA.W RAM_OWControllerA             ;; 04F52B : AD A6 0D    ;
CODE_04F52E:          AND.B #$C0                          ;; 04F52E : 29 C0       ;
CODE_04F530:          BNE CODE_04F53B                     ;; 04F530 : D0 09       ;
CODE_04F532:          LDA.W $0DA7                         ;; 04F532 : AD A7 0D    ;
CODE_04F535:          AND.B #$C0                          ;; 04F535 : 29 C0       ;
CODE_04F537:          BEQ CODE_04F56C                     ;; 04F537 : F0 33       ;
ADDR_04F539:          EOR.B #$C0                          ;; 04F539 : 49 C0       ;
CODE_04F53B:          LDX.B #$01                          ;; 04F53B : A2 01       ;
CODE_04F53D:          ASL                                 ;; 04F53D : 0A          ;
CODE_04F53E:          BCS CODE_04F541                     ;; 04F53E : B0 01       ;
CODE_04F540:          DEX                                 ;; 04F540 : CA          ;
CODE_04F541:          CPX.W $1B8A                         ;; 04F541 : EC 8A 1B    ;
CODE_04F544:          BEQ CODE_04F54B                     ;; 04F544 : F0 05       ;
CODE_04F546:          LDA.B #$18                          ;; 04F546 : A9 18       ;
CODE_04F548:          STA.W $1B8B                         ;; 04F548 : 8D 8B 1B    ;
CODE_04F54B:          STX.W $1B8A                         ;; 04F54B : 8E 8A 1B    ;
CODE_04F54E:          TXA                                 ;; 04F54E : 8A          ;
CODE_04F54F:          EOR.B #$01                          ;; 04F54F : 49 01       ;
CODE_04F551:          TAY                                 ;; 04F551 : A8          ;
CODE_04F552:          LDA.W RAM_PlayerLives,X             ;; 04F552 : BD B4 0D    ;
CODE_04F555:          BEQ CODE_04F56C                     ;; 04F555 : F0 15       ;
CODE_04F557:          BMI CODE_04F56C                     ;; 04F557 : 30 13       ;
CODE_04F559:          LDA.W RAM_PlayerLives,Y             ;; 04F559 : B9 B4 0D    ;
CODE_04F55C:          CMP.B #$62                          ;; 04F55C : C9 62       ;
CODE_04F55E:          BPL CODE_04F56C                     ;; 04F55E : 10 0C       ;
CODE_04F560:          INC A                               ;; 04F560 : 1A          ;
CODE_04F561:          STA.W RAM_PlayerLives,Y             ;; 04F561 : 99 B4 0D    ;
CODE_04F564:          DEC.W RAM_PlayerLives,X             ;; 04F564 : DE B4 0D    ;
CODE_04F567:          LDA.B #$23                          ;; 04F567 : A9 23       ;
CODE_04F569:          STA.W $1DFC                         ;; 04F569 : 8D FC 1D    ; / Play sound effect 
CODE_04F56C:          REP #$20                            ;; 04F56C : C2 20       ; Accum (16 bit) 
CODE_04F56E:          LDA.W #$7848                        ;; 04F56E : A9 48 78    ;
CODE_04F571:          STA.W $029C                         ;; 04F571 : 8D 9C 02    ;
CODE_04F574:          LDA.W #$7890                        ;; 04F574 : A9 90 78    ;
CODE_04F577:          STA.W $02A0                         ;; 04F577 : 8D A0 02    ;
CODE_04F57A:          LDA.W #$340A                        ;; 04F57A : A9 0A 34    ;
CODE_04F57D:          STA.W $029E                         ;; 04F57D : 8D 9E 02    ;
CODE_04F580:          LDA.W #$360A                        ;; 04F580 : A9 0A 36    ;
CODE_04F583:          STA.W $02A2                         ;; 04F583 : 8D A2 02    ;
CODE_04F586:          SEP #$20                            ;; 04F586 : E2 20       ; Accum (8 bit) 
CODE_04F588:          LDA.B #$02                          ;; 04F588 : A9 02       ;
CODE_04F58A:          STA.W $0447                         ;; 04F58A : 8D 47 04    ;
CODE_04F58D:          STA.W $0448                         ;; 04F58D : 8D 48 04    ;
CODE_04F590:          JSL.L CODE_05DBF2                   ;; 04F590 : 22 F2 DB 05 ;
CODE_04F594:          LDY.B #$50                          ;; 04F594 : A0 50       ;
CODE_04F596:          TYA                                 ;; 04F596 : 98          ;
CODE_04F597:          CLC                                 ;; 04F597 : 18          ;
CODE_04F598:          ADC.L $7F837B                       ;; 04F598 : 6F 7B 83 7F ;
CODE_04F59C:          STA.L $7F837B                       ;; 04F59C : 8F 7B 83 7F ;
CODE_04F5A0:          TAX                                 ;; 04F5A0 : AA          ;
CODE_04F5A1:          LDA.W DATA_04F4B2,Y                 ;; 04F5A1 : B9 B2 F4    ;
CODE_04F5A4:          STA.L $7F837D,X                     ;; 04F5A4 : 9F 7D 83 7F ;
CODE_04F5A8:          DEX                                 ;; 04F5A8 : CA          ;
CODE_04F5A9:          DEY                                 ;; 04F5A9 : 88          ;
CODE_04F5AA:          BPL CODE_04F5A1                     ;; 04F5AA : 10 F5       ;
CODE_04F5AC:          INX                                 ;; 04F5AC : E8          ;
CODE_04F5AD:          REP #$20                            ;; 04F5AD : C2 20       ; Accum (16 bit) 
CODE_04F5AF:          LDY.W RAM_PlayerLives               ;; 04F5AF : AC B4 0D    ;
CODE_04F5B2:          BMI CODE_04F5BF                     ;; 04F5B2 : 30 0B       ;
CODE_04F5B4:          LDA.W #$38FC                        ;; 04F5B4 : A9 FC 38    ;
CODE_04F5B7:          STA.L $7F83C1,X                     ;; 04F5B7 : 9F C1 83 7F ;
CODE_04F5BB:          STA.L $7F83C3,X                     ;; 04F5BB : 9F C3 83 7F ;
CODE_04F5BF:          LDY.W $0DB5                         ;; 04F5BF : AC B5 0D    ;
CODE_04F5C2:          BMI CODE_04F5CF                     ;; 04F5C2 : 30 0B       ;
CODE_04F5C4:          LDA.W #$38FC                        ;; 04F5C4 : A9 FC 38    ;
CODE_04F5C7:          STA.L $7F83C9,X                     ;; 04F5C7 : 9F C9 83 7F ;
CODE_04F5CB:          STA.L $7F83CB,X                     ;; 04F5CB : 9F CB 83 7F ;
CODE_04F5CF:          SEP #$20                            ;; 04F5CF : E2 20       ; Accum (8 bit) 
CODE_04F5D1:          INC.W $1B8B                         ;; 04F5D1 : EE 8B 1B    ;
CODE_04F5D4:          LDA.W $1B8B                         ;; 04F5D4 : AD 8B 1B    ;
CODE_04F5D7:          AND.B #$18                          ;; 04F5D7 : 29 18       ;
CODE_04F5D9:          BEQ CODE_04F600                     ;; 04F5D9 : F0 25       ;
CODE_04F5DB:          LDA.W $1B8A                         ;; 04F5DB : AD 8A 1B    ;
CODE_04F5DE:          ASL                                 ;; 04F5DE : 0A          ;
CODE_04F5DF:          TAY                                 ;; 04F5DF : A8          ;
CODE_04F5E0:          REP #$20                            ;; 04F5E0 : C2 20       ; Accum (16 bit) 
CODE_04F5E2:          LDA.W DATA_04F503,Y                 ;; 04F5E2 : B9 03 F5    ;
CODE_04F5E5:          STA.L $7F83B1,X                     ;; 04F5E5 : 9F B1 83 7F ;
CODE_04F5E9:          LDA.W DATA_04F507,Y                 ;; 04F5E9 : B9 07 F5    ;
CODE_04F5EC:          STA.L $7F83B3,X                     ;; 04F5EC : 9F B3 83 7F ;
CODE_04F5F0:          LDA.W DATA_04F50B,Y                 ;; 04F5F0 : B9 0B F5    ;
CODE_04F5F3:          STA.L $7F83B9,X                     ;; 04F5F3 : 9F B9 83 7F ;
CODE_04F5F7:          LDA.W DATA_04F50F,Y                 ;; 04F5F7 : B9 0F F5    ;
CODE_04F5FA:          STA.L $7F83BB,X                     ;; 04F5FA : 9F BB 83 7F ;
CODE_04F5FE:          SEP #$20                            ;; 04F5FE : E2 20       ; Accum (8 bit) 
CODE_04F600:          LDA.W RAM_PlayerLives               ;; 04F600 : AD B4 0D    ;
CODE_04F603:          JSR.W CODE_04F60E                   ;; 04F603 : 20 0E F6    ;
CODE_04F606:          TXA                                 ;; 04F606 : 8A          ;
CODE_04F607:          CLC                                 ;; 04F607 : 18          ;
CODE_04F608:          ADC.B #$0A                          ;; 04F608 : 69 0A       ;
CODE_04F60A:          TAX                                 ;; 04F60A : AA          ;
CODE_04F60B:          LDA.W $0DB5                         ;; 04F60B : AD B5 0D    ;
CODE_04F60E:          INC A                               ;; 04F60E : 1A          ;
CODE_04F60F:          PHX                                 ;; 04F60F : DA          ;
CODE_04F610:          JSL.L CODE_00974C                   ;; 04F610 : 22 4C 97 00 ;
CODE_04F614:          TXY                                 ;; 04F614 : 9B          ;
                                                          ;;                      ;
Instr04F615:          .db $D0,$02                         ;; ?QPWZ?               ;
                                                          ;;                      ;
Instr04F617:          .db $A2,$FC                         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_04F619:          TXY                                 ;; 04F619 : 9B          ;
CODE_04F61A:          PLX                                 ;; 04F61A : FA          ;
CODE_04F61B:          STA.L $7F83A1,X                     ;; 04F61B : 9F A1 83 7F ;
CODE_04F61F:          TYA                                 ;; 04F61F : 98          ;
CODE_04F620:          STA.L $7F839F,X                     ;; 04F620 : 9F 9F 83 7F ;
Return04F624:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04F625:          .db $00,$00,$01,$E0,$00,$00,$00,$01 ;; 04F625               ;
                      .db $60,$00,$06,$70,$01,$20,$00,$07 ;; ?QPWZ?               ;
                      .db $38,$00,$8A,$01,$00,$58,$00,$7A ;; ?QPWZ?               ;
                      .db $00,$08,$88,$01,$18,$00,$09,$48 ;; ?QPWZ?               ;
                      .db $01,$FC,$FF,$00,$80,$00,$00     ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04F64C:          .db $01,$00,$50,$00,$40,$01         ;; 04F64C               ;
                                                          ;;                      ;
DATA_04F652:          .db $03,$00,$00,$00,$00,$0A,$40,$00 ;; 04F652               ;
                      .db $98,$00,$0A,$60,$00,$F8,$00,$0A ;; ?QPWZ?               ;
                      .db $40,$01,$58                     ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04F665:          .db $01,$30,$00,$00,$01,$10,$FF,$20 ;; 04F665               ;
                      .db $00,$70,$FF,$10,$00,$01,$40,$80 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_04F675:          PHB                                 ;; 04F675 : 8B          ;
CODE_04F676:          PHK                                 ;; 04F676 : 4B          ;
CODE_04F677:          PLB                                 ;; 04F677 : AB          ;
CODE_04F678:          LDX.B #$0C                          ;; 04F678 : A2 0C       ;
CODE_04F67A:          LDY.B #$4B                          ;; 04F67A : A0 4B       ;
CODE_04F67C:          LDA.W ADDR_04F616,Y                 ;; 04F67C : B9 16 F6    ;
CODE_04F67F:          STA.W $0DE8,X                       ;; 04F67F : 9D E8 0D    ;
CODE_04F682:          CMP.B #$01                          ;; 04F682 : C9 01       ;
CODE_04F684:          BEQ ADDR_04F68A                     ;; 04F684 : F0 04       ;
CODE_04F686:          CMP.B #$02                          ;; 04F686 : C9 02       ;
CODE_04F688:          BNE CODE_04F68F                     ;; 04F688 : D0 05       ;
ADDR_04F68A:          LDA.B #$40                          ;; 04F68A : A9 40       ;
ADDR_04F68C:          STA.W $0E58,X                       ;; 04F68C : 9D 58 0E    ;
CODE_04F68F:          LDA.W Instr04F617,Y                 ;; 04F68F : B9 17 F6    ;
CODE_04F692:          STA.W $0E38,X                       ;; 04F692 : 9D 38 0E    ;
CODE_04F695:          LDA.W ADDR_04F618,Y                 ;; 04F695 : B9 18 F6    ;
CODE_04F698:          STA.W $0E68,X                       ;; 04F698 : 9D 68 0E    ;
CODE_04F69B:          LDA.W CODE_04F619,Y                 ;; 04F69B : B9 19 F6    ;
CODE_04F69E:          STA.W $0E48,X                       ;; 04F69E : 9D 48 0E    ;
CODE_04F6A1:          LDA.W CODE_04F61A,Y                 ;; 04F6A1 : B9 1A F6    ;
CODE_04F6A4:          STA.W $0E78,X                       ;; 04F6A4 : 9D 78 0E    ;
CODE_04F6A7:          TYA                                 ;; 04F6A7 : 98          ;
CODE_04F6A8:          SEC                                 ;; 04F6A8 : 38          ;
CODE_04F6A9:          SBC.B #$05                          ;; 04F6A9 : E9 05       ;
CODE_04F6AB:          TAY                                 ;; 04F6AB : A8          ;
CODE_04F6AC:          DEX                                 ;; 04F6AC : CA          ;
CODE_04F6AD:          BPL CODE_04F67C                     ;; 04F6AD : 10 CD       ;
CODE_04F6AF:          LDX.B #$0D                          ;; 04F6AF : A2 0D       ;
CODE_04F6B1:          STZ.W $0E25,X                       ;; 04F6B1 : 9E 25 0E    ;
CODE_04F6B4:          LDA.W DATA_04FD22                   ;; 04F6B4 : AD 22 FD    ;
CODE_04F6B7:          DEC A                               ;; 04F6B7 : 3A          ;
CODE_04F6B8:          STA.W $0EB5,X                       ;; 04F6B8 : 9D B5 0E    ;
CODE_04F6BB:          LDA.W DATA_04F665,X                 ;; 04F6BB : BD 65 F6    ;
CODE_04F6BE:          PHA                                 ;; 04F6BE : 48          ;
CODE_04F6BF:          STX.W $0DDE                         ;; 04F6BF : 8E DE 0D    ;
CODE_04F6C2:          JSR.W CODE_04F853                   ;; 04F6C2 : 20 53 F8    ;
CODE_04F6C5:          PLA                                 ;; 04F6C5 : 68          ;
CODE_04F6C6:          DEC A                               ;; 04F6C6 : 3A          ;
CODE_04F6C7:          BNE CODE_04F6BE                     ;; 04F6C7 : D0 F5       ;
CODE_04F6C9:          INX                                 ;; 04F6C9 : E8          ;
CODE_04F6CA:          CPX.B #$10                          ;; 04F6CA : E0 10       ;
CODE_04F6CC:          BCC CODE_04F6B1                     ;; 04F6CC : 90 E3       ;
CODE_04F6CE:          PLB                                 ;; 04F6CE : AB          ;
Return04F6CF:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04F6D0:          .db $70,$7F,$78,$7F,$70,$7F,$78,$7F ;; 04F6D0               ;
DATA_04F6D8:          .db $F0,$FF,$20,$00,$C0,$00,$F0,$FF ;; 04F6D8               ;
                      .db $F0,$FF,$80,$00,$F0,$FF,$00,$00 ;; ?QPWZ?               ;
DATA_04F6E8:          .db $70,$00,$60,$01,$58,$01,$B0,$00 ;; 04F6E8               ;
                      .db $60,$01,$60,$01,$70,$00,$60,$01 ;; ?QPWZ?               ;
DATA_04F6F8:          .db $20,$58,$43,$CF,$18,$34,$A2,$5E ;; 04F6F8               ;
DATA_04F700:          .db $07,$05,$06,$07,$04,$06,$07,$05 ;; 04F700               ;
                                                          ;;                      ;
CODE_04F708:          LDA.B #$F7                          ;; 04F708 : A9 F7       ;
CODE_04F70A:          JSR.W CODE_04F882                   ;; 04F70A : 20 82 F8    ;
CODE_04F70D:          BNE CODE_04F76E                     ;; 04F70D : D0 5F       ;
CODE_04F70F:          LDY.W $1FFB                         ;; 04F70F : AC FB 1F    ;
CODE_04F712:          BNE CODE_04F73B                     ;; 04F712 : D0 27       ;
CODE_04F714:          LDA RAM_FrameCounter                ;; 04F714 : A5 13       ;
CODE_04F716:          LSR                                 ;; 04F716 : 4A          ;
CODE_04F717:          BCC CODE_04F76E                     ;; 04F717 : 90 55       ;
CODE_04F719:          DEC.W $1FFC                         ;; 04F719 : CE FC 1F    ;
CODE_04F71C:          BNE CODE_04F76E                     ;; 04F71C : D0 50       ;
CODE_04F71E:          TAY                                 ;; 04F71E : A8          ;
CODE_04F71F:          LDA.W CODE_04F708,Y                 ;; 04F71F : B9 08 F7    ;
CODE_04F722:          AND.B #$07                          ;; 04F722 : 29 07       ;
CODE_04F724:          TAX                                 ;; 04F724 : AA          ;
CODE_04F725:          LDA.W DATA_04F6F8,X                 ;; 04F725 : BD F8 F6    ;
CODE_04F728:          STA.W $1FFC                         ;; 04F728 : 8D FC 1F    ;
CODE_04F72B:          LDY.W DATA_04F700,X                 ;; 04F72B : BC 00 F7    ;
CODE_04F72E:          STY.W $1FFB                         ;; 04F72E : 8C FB 1F    ;
CODE_04F731:          LDA.B #$08                          ;; 04F731 : A9 08       ;
CODE_04F733:          STA.W $1FFD                         ;; 04F733 : 8D FD 1F    ;
CODE_04F736:          LDA.B #$18                          ;; 04F736 : A9 18       ;
CODE_04F738:          STA.W $1DFC                         ;; 04F738 : 8D FC 1D    ; / Play sound effect 
CODE_04F73B:          DEC.W $1FFD                         ;; 04F73B : CE FD 1F    ;
CODE_04F73E:          BPL CODE_04F748                     ;; 04F73E : 10 08       ;
CODE_04F740:          DEC.W $1FFB                         ;; 04F740 : CE FB 1F    ;
CODE_04F743:          LDA.B #$04                          ;; 04F743 : A9 04       ;
CODE_04F745:          STA.W $1FFD                         ;; 04F745 : 8D FD 1F    ;
CODE_04F748:          TYA                                 ;; 04F748 : 98          ;
CODE_04F749:          ASL                                 ;; 04F749 : 0A          ;
CODE_04F74A:          TAY                                 ;; 04F74A : A8          ;
CODE_04F74B:          LDX.W $0681                         ;; 04F74B : AE 81 06    ;
CODE_04F74E:          LDA.B #$02                          ;; 04F74E : A9 02       ;
CODE_04F750:          STA.W $0682,X                       ;; 04F750 : 9D 82 06    ;
CODE_04F753:          LDA.B #$47                          ;; 04F753 : A9 47       ;
CODE_04F755:          STA.W $0683,X                       ;; 04F755 : 9D 83 06    ;
CODE_04F758:          LDA.W $0753,Y                       ;; 04F758 : B9 53 07    ;
CODE_04F75B:          STA.W $0684,X                       ;; 04F75B : 9D 84 06    ;
CODE_04F75E:          LDA.W $0754,Y                       ;; 04F75E : B9 54 07    ;
CODE_04F761:          STA.W $0685,X                       ;; 04F761 : 9D 85 06    ;
CODE_04F764:          STZ.W $0686,X                       ;; 04F764 : 9E 86 06    ;
CODE_04F767:          TXA                                 ;; 04F767 : 8A          ;
CODE_04F768:          CLC                                 ;; 04F768 : 18          ;
CODE_04F769:          ADC.B #$04                          ;; 04F769 : 69 04       ;
CODE_04F76B:          STA.W $0681                         ;; 04F76B : 8D 81 06    ;
CODE_04F76E:          LDX.B #$02                          ;; 04F76E : A2 02       ;
CODE_04F770:          LDA.W $0DE5,X                       ;; 04F770 : BD E5 0D    ;
CODE_04F773:          BNE CODE_04F7AB                     ;; 04F773 : D0 36       ;
CODE_04F775:          LDA.B #$05                          ;; 04F775 : A9 05       ;
CODE_04F777:          STA.W $0DE5,X                       ;; 04F777 : 9D E5 0D    ;
CODE_04F77A:          JSR.W CODE_04FE5B                   ;; 04F77A : 20 5B FE    ;
CODE_04F77D:          AND.B #$07                          ;; 04F77D : 29 07       ;
CODE_04F77F:          TAY                                 ;; 04F77F : A8          ;
CODE_04F780:          LDA.W DATA_04F6D0,Y                 ;; 04F780 : B9 D0 F6    ;
CODE_04F783:          STA.W $0E55,X                       ;; 04F783 : 9D 55 0E    ;
CODE_04F786:          TYA                                 ;; 04F786 : 98          ;
CODE_04F787:          ASL                                 ;; 04F787 : 0A          ;
CODE_04F788:          TAY                                 ;; 04F788 : A8          ;
CODE_04F789:          REP #$20                            ;; 04F789 : C2 20       ; Accum (16 bit) 
CODE_04F78B:          LDA RAM_ScreenBndryXLo              ;; 04F78B : A5 1A       ;
CODE_04F78D:          CLC                                 ;; 04F78D : 18          ;
CODE_04F78E:          ADC.W DATA_04F6D8,Y                 ;; 04F78E : 79 D8 F6    ;
CODE_04F791:          SEP #$20                            ;; 04F791 : E2 20       ; Accum (8 bit) 
CODE_04F793:          STA.W $0E35,X                       ;; 04F793 : 9D 35 0E    ;
CODE_04F796:          XBA                                 ;; 04F796 : EB          ;
CODE_04F797:          STA.W $0E65,X                       ;; 04F797 : 9D 65 0E    ;
CODE_04F79A:          REP #$20                            ;; 04F79A : C2 20       ; Accum (16 bit) 
CODE_04F79C:          LDA RAM_ScreenBndryYLo              ;; 04F79C : A5 1C       ;
CODE_04F79E:          CLC                                 ;; 04F79E : 18          ;
CODE_04F79F:          ADC.W DATA_04F6E8,Y                 ;; 04F79F : 79 E8 F6    ;
CODE_04F7A2:          SEP #$20                            ;; 04F7A2 : E2 20       ; Accum (8 bit) 
CODE_04F7A4:          STA.W $0E45,X                       ;; 04F7A4 : 9D 45 0E    ;
CODE_04F7A7:          XBA                                 ;; 04F7A7 : EB          ;
CODE_04F7A8:          STA.W $0E75,X                       ;; 04F7A8 : 9D 75 0E    ;
CODE_04F7AB:          DEX                                 ;; 04F7AB : CA          ;
CODE_04F7AC:          BPL CODE_04F770                     ;; 04F7AC : 10 C2       ;
CODE_04F7AE:          LDX.B #$04                          ;; 04F7AE : A2 04       ;
CODE_04F7B0:          TXA                                 ;; 04F7B0 : 8A          ;
CODE_04F7B1:          STA.W $0DE0,X                       ;; 04F7B1 : 9D E0 0D    ;
CODE_04F7B4:          DEX                                 ;; 04F7B4 : CA          ;
CODE_04F7B5:          BPL CODE_04F7B0                     ;; 04F7B5 : 10 F9       ;
CODE_04F7B7:          LDX.B #$04                          ;; 04F7B7 : A2 04       ;
CODE_04F7B9:          STX $00                             ;; 04F7B9 : 86 00       ;
CODE_04F7BB:          STX $01                             ;; 04F7BB : 86 01       ;
CODE_04F7BD:          LDX $00                             ;; 04F7BD : A6 00       ;
CODE_04F7BF:          LDY.W $0DE0,X                       ;; 04F7BF : BC E0 0D    ;
CODE_04F7C2:          LDA.W $0E45,Y                       ;; 04F7C2 : B9 45 0E    ;
CODE_04F7C5:          STA $02                             ;; 04F7C5 : 85 02       ;
CODE_04F7C7:          LDA.W $0E75,Y                       ;; 04F7C7 : B9 75 0E    ;
CODE_04F7CA:          STA $03                             ;; 04F7CA : 85 03       ;
CODE_04F7CC:          LDX $01                             ;; 04F7CC : A6 01       ;
CODE_04F7CE:          LDY.W $0DDF,X                       ;; 04F7CE : BC DF 0D    ;
CODE_04F7D1:          LDA.W $0E75,Y                       ;; 04F7D1 : B9 75 0E    ;
CODE_04F7D4:          XBA                                 ;; 04F7D4 : EB          ;
CODE_04F7D5:          LDA.W $0E45,Y                       ;; 04F7D5 : B9 45 0E    ;
CODE_04F7D8:          REP #$20                            ;; 04F7D8 : C2 20       ; Accum (16 bit) 
CODE_04F7DA:          CMP $02                             ;; 04F7DA : C5 02       ;
CODE_04F7DC:          SEP #$20                            ;; 04F7DC : E2 20       ; Accum (8 bit) 
CODE_04F7DE:          BPL CODE_04F7ED                     ;; 04F7DE : 10 0D       ;
CODE_04F7E0:          PHY                                 ;; 04F7E0 : 5A          ;
CODE_04F7E1:          LDY $00                             ;; 04F7E1 : A4 00       ;
CODE_04F7E3:          LDA.W $0DE0,Y                       ;; 04F7E3 : B9 E0 0D    ;
CODE_04F7E6:          STA.W $0DDF,X                       ;; 04F7E6 : 9D DF 0D    ;
CODE_04F7E9:          PLA                                 ;; 04F7E9 : 68          ;
CODE_04F7EA:          STA.W $0DE0,Y                       ;; 04F7EA : 99 E0 0D    ;
CODE_04F7ED:          DEX                                 ;; 04F7ED : CA          ;
CODE_04F7EE:          BNE CODE_04F7BB                     ;; 04F7EE : D0 CB       ;
CODE_04F7F0:          LDX $00                             ;; 04F7F0 : A6 00       ;
CODE_04F7F2:          DEX                                 ;; 04F7F2 : CA          ;
CODE_04F7F3:          BNE CODE_04F7B9                     ;; 04F7F3 : D0 C4       ;
CODE_04F7F5:          LDA.B #$30                          ;; 04F7F5 : A9 30       ;
CODE_04F7F7:          STA.W $0DDF                         ;; 04F7F7 : 8D DF 0D    ;
CODE_04F7FA:          STZ.W $0EF7                         ;; 04F7FA : 9C F7 0E    ;
CODE_04F7FD:          LDX.B #$0F                          ;; 04F7FD : A2 0F       ;
CODE_04F7FF:          LDY.B #$2D                          ;; 04F7FF : A0 2D       ;
CODE_04F801:          CPX.B #$0D                          ;; 04F801 : E0 0D       ;
CODE_04F803:          BCS CODE_04F80D                     ;; 04F803 : B0 08       ;
CODE_04F805:          LDA.W $0E25,X                       ;; 04F805 : BD 25 0E    ;
CODE_04F808:          BEQ CODE_04F80D                     ;; 04F808 : F0 03       ;
CODE_04F80A:          DEC.W $0E25,X                       ;; 04F80A : DE 25 0E    ;
CODE_04F80D:          CPX.B #$05                          ;; 04F80D : E0 05       ;
CODE_04F80F:          BCC CODE_04F819                     ;; 04F80F : 90 08       ;
CODE_04F811:          STX.W $0DDE                         ;; 04F811 : 8E DE 0D    ;
CODE_04F814:          JSR.W CODE_04F853                   ;; 04F814 : 20 53 F8    ;
CODE_04F817:          BRA CODE_04F825                     ;; 04F817 : 80 0C       ;
                                                          ;;                      ;
CODE_04F819:          PHX                                 ;; 04F819 : DA          ;
CODE_04F81A:          LDA.W $0DE0,X                       ;; 04F81A : BD E0 0D    ;
CODE_04F81D:          TAX                                 ;; 04F81D : AA          ;
CODE_04F81E:          STX.W $0DDE                         ;; 04F81E : 8E DE 0D    ;
CODE_04F821:          JSR.W CODE_04F853                   ;; 04F821 : 20 53 F8    ;
CODE_04F824:          PLX                                 ;; 04F824 : FA          ;
CODE_04F825:          DEX                                 ;; 04F825 : CA          ;
CODE_04F826:          BPL CODE_04F801                     ;; 04F826 : 10 D9       ;
Return04F828:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04F829:          .db $7F,$21,$7F,$7F,$7F,$77,$3F,$F7 ;; 04F829               ;
                      .db $F7,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04F833:          .db $00,$52,$31,$19,$45,$2A,$03,$8B ;; 04F833               ;
                      .db $94,$3C,$78,$0D,$36,$5E,$87,$1F ;; ?QPWZ?               ;
DATA_04F843:          .db $F4,$F4,$F4,$F4,$F4,$9C,$3C,$48 ;; 04F843               ;
                      .db $C8,$CC,$A0,$A4,$D8,$DC,$E0,$E4 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_04F853:          JSR.W CODE_04F87C                   ;; 04F853 : 20 7C F8    ;
CODE_04F856:          BNE Return04F828                    ;; 04F856 : D0 D0       ;
CODE_04F858:          LDA.W $0DE5,X                       ;; 04F858 : BD E5 0D    ;
CODE_04F85B:          JSL.L ExecutePtr                    ;; 04F85B : 22 DF 86 00 ;
                                                          ;;                      ;
OWSprites?:           .dw Return04F828                    ;; ?QPWZ? : 28 F8       ;
                      .dw ADDR_04F8CC                     ;; ?QPWZ? : CC F8       ;
                      .dw ADDR_04F9B8                     ;; ?QPWZ? : B8 F9       ;
                      .dw CODE_04FA3E                     ;; ?QPWZ? : 3E FA       ;
                      .dw ADDR_04FAF1                     ;; ?QPWZ? : F1 FA       ;
                      .dw CODE_04FB37                     ;; ?QPWZ? : 37 FB       ;
                      .dw CODE_04FB98                     ;; ?QPWZ? : 98 FB       ;
                      .dw CODE_04FC46                     ;; ?QPWZ? : 46 FC       ;
                      .dw CODE_04FCE1                     ;; ?QPWZ? : E1 FC       ;
                      .dw CODE_04FD24                     ;; ?QPWZ? : 24 FD       ;
                      .dw CODE_04FD70                     ;; ?QPWZ? : 70 FD       ;
                                                          ;;                      ;
DATA_04F875:          .db $80,$40,$20,$10,$08,$04,$02     ;; 04F875               ;
                                                          ;;                      ;
CODE_04F87C:          LDY.W $0DE5,X                       ;; 04F87C : BC E5 0D    ;
CODE_04F87F:          LDA.W Return04F828,Y                ;; 04F87F : B9 28 F8    ;
CODE_04F882:          STA $00                             ;; 04F882 : 85 00       ;
CODE_04F884:          LDY.W $13D9                         ;; 04F884 : AC D9 13    ;
CODE_04F887:          CPY.B #$0A                          ;; 04F887 : C0 0A       ;
CODE_04F889:          BNE CODE_04F892                     ;; 04F889 : D0 07       ;
CODE_04F88B:          LDY.W $1DE8                         ;; 04F88B : AC E8 1D    ;
CODE_04F88E:          CPY.B #$01                          ;; 04F88E : C0 01       ;
CODE_04F890:          BNE CODE_04F8A3                     ;; 04F890 : D0 11       ;
CODE_04F892:          LDA.W $0DD6                         ;; 04F892 : AD D6 0D    ;
CODE_04F895:          LSR                                 ;; 04F895 : 4A          ;
CODE_04F896:          LSR                                 ;; 04F896 : 4A          ;
CODE_04F897:          TAY                                 ;; 04F897 : A8          ;
CODE_04F898:          LDA.W $1F11,Y                       ;; 04F898 : B9 11 1F    ;
CODE_04F89B:          TAY                                 ;; 04F89B : A8          ;
CODE_04F89C:          LDA.W DATA_04F875,Y                 ;; 04F89C : B9 75 F8    ;
CODE_04F89F:          AND $00                             ;; 04F89F : 25 00       ;
CODE_04F8A1:          BEQ Return04F8A5                    ;; 04F8A1 : F0 02       ;
CODE_04F8A3:          LDA.B #$01                          ;; 04F8A3 : A9 01       ;
Return04F8A5:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04F8A6:          .db $01,$01,$03,$01,$01,$01,$01,$02 ;; 04F8A6               ;
DATA_04F8AE:          .db $0C,$0C,$12,$12,$12,$12,$0C,$0C ;; 04F8AE               ;
DATA_04F8B6:          .db $10,$00,$08,$00,$20,$00,$20,$00 ;; 04F8B6               ;
DATA_04F8BE:          .db $10,$00,$30,$00,$08,$00,$10,$00 ;; 04F8BE               ;
DATA_04F8C6:          .db $01,$FF                         ;; 04F8C6               ;
                                                          ;;                      ;
DATA_04F8C8:          .db $10,$F0                         ;; 04F8C8               ;
                                                          ;;                      ;
DATA_04F8CA:          .db $10,$F0                         ;; 04F8CA               ;
                                                          ;;                      ;
ADDR_04F8CC:          JSR.W CODE_04FE90                   ;; 04F8CC : 20 90 FE    ;
ADDR_04F8CF:          CLC                                 ;; 04F8CF : 18          ;
ADDR_04F8D0:          JSR.W ADDR_04FE00                   ;; 04F8D0 : 20 00 FE    ;
ADDR_04F8D3:          JSR.W CODE_04FE62                   ;; 04F8D3 : 20 62 FE    ;
ADDR_04F8D6:          REP #$20                            ;; 04F8D6 : C2 20       ; Accum (16 bit) 
ADDR_04F8D8:          LDA $02                             ;; 04F8D8 : A5 02       ;
ADDR_04F8DA:          STA $04                             ;; 04F8DA : 85 04       ;
ADDR_04F8DC:          SEP #$20                            ;; 04F8DC : E2 20       ; Accum (8 bit) 
ADDR_04F8DE:          JSR.W CODE_04FE5B                   ;; 04F8DE : 20 5B FE    ;
ADDR_04F8E1:          LDX.B #$06                          ;; 04F8E1 : A2 06       ;
ADDR_04F8E3:          AND.B #$10                          ;; 04F8E3 : 29 10       ;
ADDR_04F8E5:          BEQ ADDR_04F8E8                     ;; 04F8E5 : F0 01       ;
ADDR_04F8E7:          INX                                 ;; 04F8E7 : E8          ;
ADDR_04F8E8:          STX $06                             ;; 04F8E8 : 86 06       ;
ADDR_04F8EA:          LDA $00                             ;; 04F8EA : A5 00       ;
ADDR_04F8EC:          CLC                                 ;; 04F8EC : 18          ;
ADDR_04F8ED:          ADC.W DATA_04F8A6,X                 ;; 04F8ED : 7D A6 F8    ;
ADDR_04F8F0:          STA $00                             ;; 04F8F0 : 85 00       ;
ADDR_04F8F2:          BCC ADDR_04F8F6                     ;; 04F8F2 : 90 02       ;
ADDR_04F8F4:          INC $01                             ;; 04F8F4 : E6 01       ;
ADDR_04F8F6:          LDA $04                             ;; 04F8F6 : A5 04       ;
ADDR_04F8F8:          CLC                                 ;; 04F8F8 : 18          ;
ADDR_04F8F9:          ADC.W DATA_04F8AE,X                 ;; 04F8F9 : 7D AE F8    ;
ADDR_04F8FC:          STA $02                             ;; 04F8FC : 85 02       ;
ADDR_04F8FE:          LDA $05                             ;; 04F8FE : A5 05       ;
ADDR_04F900:          ADC.B #$00                          ;; 04F900 : 69 00       ;
ADDR_04F902:          STA $03                             ;; 04F902 : 85 03       ;
ADDR_04F904:          LDA.B #$32                          ;; 04F904 : A9 32       ;
ADDR_04F906:          XBA                                 ;; 04F906 : EB          ;
ADDR_04F907:          LDA.B #$28                          ;; 04F907 : A9 28       ;
ADDR_04F909:          JSR.W CODE_04FB7B                   ;; 04F909 : 20 7B FB    ;
ADDR_04F90C:          LDX $06                             ;; 04F90C : A6 06       ;
ADDR_04F90E:          DEX                                 ;; 04F90E : CA          ;
ADDR_04F90F:          DEX                                 ;; 04F90F : CA          ;
ADDR_04F910:          BPL ADDR_04F8E8                     ;; 04F910 : 10 D6       ;
ADDR_04F912:          LDX.W $0DDE                         ;; 04F912 : AE DE 0D    ;
ADDR_04F915:          JSR.W CODE_04FE62                   ;; 04F915 : 20 62 FE    ;
ADDR_04F918:          LDA.B #$32                          ;; 04F918 : A9 32       ;
ADDR_04F91A:          XBA                                 ;; 04F91A : EB          ;
ADDR_04F91B:          LDA.B #$26                          ;; 04F91B : A9 26       ;
ADDR_04F91D:          JSR.W CODE_04FB7A                   ;; 04F91D : 20 7A FB    ;
ADDR_04F920:          LDA.W $0E15,X                       ;; 04F920 : BD 15 0E    ;
ADDR_04F923:          BEQ ADDR_04F928                     ;; 04F923 : F0 03       ;
ADDR_04F925:          JMP.W ADDR_04FF2E                   ;; 04F925 : 4C 2E FF    ;
                                                          ;;                      ;
ADDR_04F928:          LDA.W $0E05,X                       ;; 04F928 : BD 05 0E    ;
ADDR_04F92B:          AND.B #$01                          ;; 04F92B : 29 01       ;
ADDR_04F92D:          TAY                                 ;; 04F92D : A8          ;
ADDR_04F92E:          LDA.W $0EB5,X                       ;; 04F92E : BD B5 0E    ;
ADDR_04F931:          CLC                                 ;; 04F931 : 18          ;
ADDR_04F932:          ADC.W DATA_04F8C6,Y                 ;; 04F932 : 79 C6 F8    ;
ADDR_04F935:          STA.W $0EB5,X                       ;; 04F935 : 9D B5 0E    ;
ADDR_04F938:          CMP.W DATA_04F8CA,Y                 ;; 04F938 : D9 CA F8    ;
ADDR_04F93B:          BNE ADDR_04F945                     ;; 04F93B : D0 08       ;
ADDR_04F93D:          LDA.W $0E05,X                       ;; 04F93D : BD 05 0E    ;
ADDR_04F940:          EOR.B #$01                          ;; 04F940 : 49 01       ;
ADDR_04F942:          STA.W $0E05,X                       ;; 04F942 : 9D 05 0E    ;
ADDR_04F945:          JSR.W ADDR_04FEEF                   ;; 04F945 : 20 EF FE    ;
ADDR_04F948:          LDY.W $0DF5,X                       ;; 04F948 : BC F5 0D    ; Accum (16 bit) 
ADDR_04F94B:          LDA.W $0E04,X                       ;; 04F94B : BD 04 0E    ;
ADDR_04F94E:          ASL                                 ;; 04F94E : 0A          ;
ADDR_04F94F:          EOR $00                             ;; 04F94F : 45 00       ;
ADDR_04F951:          BPL ADDR_04F95D                     ;; 04F951 : 10 0A       ;
ADDR_04F953:          LDA $06                             ;; 04F953 : A5 06       ;
ADDR_04F955:          CMP.W DATA_04F8B6,Y                 ;; 04F955 : D9 B6 F8    ;
ADDR_04F958:          LDA.W #$0040                        ;; 04F958 : A9 40 00    ;
ADDR_04F95B:          BCS ADDR_04F96D                     ;; 04F95B : B0 10       ;
ADDR_04F95D:          LDA.W $0E04,X                       ;; 04F95D : BD 04 0E    ;
ADDR_04F960:          EOR $02                             ;; 04F960 : 45 02       ;
ADDR_04F962:          ASL                                 ;; 04F962 : 0A          ;
ADDR_04F963:          BCC ADDR_04F96D                     ;; 04F963 : 90 08       ;
ADDR_04F965:          LDA $08                             ;; 04F965 : A5 08       ;
ADDR_04F967:          CMP.W DATA_04F8BE,Y                 ;; 04F967 : D9 BE F8    ;
ADDR_04F96A:          LDA.W #$0080                        ;; 04F96A : A9 80 00    ;
ADDR_04F96D:          SEP #$20                            ;; 04F96D : E2 20       ; Accum (8 bit) 
ADDR_04F96F:          BCC ADDR_04F97F                     ;; 04F96F : 90 0E       ;
ADDR_04F971:          EOR.W $0E05,X                       ;; 04F971 : 5D 05 0E    ;
ADDR_04F974:          STA.W $0E05,X                       ;; 04F974 : 9D 05 0E    ;
ADDR_04F977:          JSR.W CODE_04FE5B                   ;; 04F977 : 20 5B FE    ;
ADDR_04F97A:          AND.B #$06                          ;; 04F97A : 29 06       ;
ADDR_04F97C:          STA.W $0DF5,X                       ;; 04F97C : 9D F5 0D    ;
ADDR_04F97F:          TXA                                 ;; 04F97F : 8A          ;
ADDR_04F980:          CLC                                 ;; 04F980 : 18          ;
ADDR_04F981:          ADC.B #$10                          ;; 04F981 : 69 10       ;
ADDR_04F983:          TAX                                 ;; 04F983 : AA          ;
ADDR_04F984:          LDA.W $0DF5,X                       ;; 04F984 : BD F5 0D    ;
ADDR_04F987:          ASL                                 ;; 04F987 : 0A          ;
ADDR_04F988:          JSR.W ADDR_04F993                   ;; 04F988 : 20 93 F9    ;
ADDR_04F98B:          LDX.W $0DDE                         ;; 04F98B : AE DE 0D    ;
ADDR_04F98E:          LDA.W $0E05,X                       ;; 04F98E : BD 05 0E    ;
ADDR_04F991:          ASL                                 ;; 04F991 : 0A          ;
ADDR_04F992:          ASL                                 ;; 04F992 : 0A          ;
ADDR_04F993:          LDY.B #$00                          ;; 04F993 : A0 00       ;
ADDR_04F995:          BCS ADDR_04F998                     ;; 04F995 : B0 01       ;
ADDR_04F997:          INY                                 ;; 04F997 : C8          ;
ADDR_04F998:          LDA.W $0E95,X                       ;; 04F998 : BD 95 0E    ;
ADDR_04F99B:          CLC                                 ;; 04F99B : 18          ;
ADDR_04F99C:          ADC.W DATA_04F8C6,Y                 ;; 04F99C : 79 C6 F8    ;
ADDR_04F99F:          CMP.W DATA_04F8C8,Y                 ;; 04F99F : D9 C8 F8    ;
ADDR_04F9A2:          BEQ Return04F9A7                    ;; 04F9A2 : F0 03       ;
ADDR_04F9A4:          STA.W $0E95,X                       ;; 04F9A4 : 9D 95 0E    ;
Return04F9A7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04F9A8:          .db $4E,$4F,$5E,$4F                 ;; 04F9A8               ;
                                                          ;;                      ;
DATA_04F9AC:          .db $08,$07,$04,$07                 ;; 04F9AC               ;
                                                          ;;                      ;
DATA_04F9B0:          .db $00,$01,$04,$01                 ;; 04F9B0               ;
                                                          ;;                      ;
DATA_04F9B4:          .db $01,$07,$09,$07                 ;; 04F9B4               ;
                                                          ;;                      ;
ADDR_04F9B8:          CLC                                 ;; 04F9B8 : 18          ;
ADDR_04F9B9:          JSR.W ADDR_04FE00                   ;; 04F9B9 : 20 00 FE    ;
ADDR_04F9BC:          JSR.W ADDR_04FEEF                   ;; 04F9BC : 20 EF FE    ;
ADDR_04F9BF:          SEP #$20                            ;; 04F9BF : E2 20       ; Accum (8 bit) 
ADDR_04F9C1:          LDY.B #$00                          ;; 04F9C1 : A0 00       ;
ADDR_04F9C3:          LDA $01                             ;; 04F9C3 : A5 01       ;
ADDR_04F9C5:          BMI ADDR_04F9C8                     ;; 04F9C5 : 30 01       ;
ADDR_04F9C7:          INY                                 ;; 04F9C7 : C8          ;
ADDR_04F9C8:          LDA.W $0E95,X                       ;; 04F9C8 : BD 95 0E    ;
ADDR_04F9CB:          CLC                                 ;; 04F9CB : 18          ;
ADDR_04F9CC:          ADC.W DATA_04F8C6,Y                 ;; 04F9CC : 79 C6 F8    ;
ADDR_04F9CF:          CMP.W DATA_04F8C8,Y                 ;; 04F9CF : D9 C8 F8    ;
ADDR_04F9D2:          BEQ ADDR_04F9D7                     ;; 04F9D2 : F0 03       ;
ADDR_04F9D4:          STA.W $0E95,X                       ;; 04F9D4 : 9D 95 0E    ;
ADDR_04F9D7:          LDY.W $0DD6                         ;; 04F9D7 : AC D6 0D    ;
ADDR_04F9DA:          LDA.W $1F19,Y                       ;; 04F9DA : B9 19 1F    ;
ADDR_04F9DD:          STA.W $0E45,X                       ;; 04F9DD : 9D 45 0E    ;
ADDR_04F9E0:          LDA.W $1F1A,Y                       ;; 04F9E0 : B9 1A 1F    ;
ADDR_04F9E3:          STA.W $0E75,X                       ;; 04F9E3 : 9D 75 0E    ;
ADDR_04F9E6:          JSR.W CODE_04FE90                   ;; 04F9E6 : 20 90 FE    ;
ADDR_04F9E9:          JSR.W CODE_04FE62                   ;; 04F9E9 : 20 62 FE    ;
ADDR_04F9EC:          LDA.B #$36                          ;; 04F9EC : A9 36       ;
ADDR_04F9EE:          LDY.W $0E95,X                       ;; 04F9EE : BC 95 0E    ;
ADDR_04F9F1:          BMI ADDR_04F9F5                     ;; 04F9F1 : 30 02       ;
ADDR_04F9F3:          ORA.B #$40                          ;; 04F9F3 : 09 40       ;
ADDR_04F9F5:          PHA                                 ;; 04F9F5 : 48          ;
ADDR_04F9F6:          XBA                                 ;; 04F9F6 : EB          ;
ADDR_04F9F7:          LDA.B #$4C                          ;; 04F9F7 : A9 4C       ;
ADDR_04F9F9:          JSR.W CODE_04FB7A                   ;; 04F9F9 : 20 7A FB    ;
ADDR_04F9FC:          PLA                                 ;; 04F9FC : 68          ;
ADDR_04F9FD:          XBA                                 ;; 04F9FD : EB          ;
ADDR_04F9FE:          JSR.W CODE_04FE5B                   ;; 04F9FE : 20 5B FE    ;
ADDR_04FA01:          LSR                                 ;; 04FA01 : 4A          ;
ADDR_04FA02:          LSR                                 ;; 04FA02 : 4A          ;
ADDR_04FA03:          LSR                                 ;; 04FA03 : 4A          ;
ADDR_04FA04:          AND.B #$03                          ;; 04FA04 : 29 03       ;
ADDR_04FA06:          TAY                                 ;; 04FA06 : A8          ;
ADDR_04FA07:          LDA.W DATA_04F9AC,Y                 ;; 04FA07 : B9 AC F9    ;
ADDR_04FA0A:          BIT.W $0E95,X                       ;; 04FA0A : 3C 95 0E    ;
ADDR_04FA0D:          BMI ADDR_04FA12                     ;; 04FA0D : 30 03       ;
ADDR_04FA0F:          LDA.W DATA_04F9B0,Y                 ;; 04FA0F : B9 B0 F9    ;
ADDR_04FA12:          CLC                                 ;; 04FA12 : 18          ;
ADDR_04FA13:          ADC $00                             ;; 04FA13 : 65 00       ;
ADDR_04FA15:          STA $00                             ;; 04FA15 : 85 00       ;
ADDR_04FA17:          BCC ADDR_04FA1B                     ;; 04FA17 : 90 02       ;
ADDR_04FA19:          INC $01                             ;; 04FA19 : E6 01       ;
ADDR_04FA1B:          LDA.W DATA_04F9B4,Y                 ;; 04FA1B : B9 B4 F9    ;
ADDR_04FA1E:          CLC                                 ;; 04FA1E : 18          ;
ADDR_04FA1F:          ADC $02                             ;; 04FA1F : 65 02       ;
ADDR_04FA21:          STA $02                             ;; 04FA21 : 85 02       ;
ADDR_04FA23:          BCC ADDR_04FA27                     ;; 04FA23 : 90 02       ;
ADDR_04FA25:          INC $03                             ;; 04FA25 : E6 03       ;
ADDR_04FA27:          LDA.W DATA_04F9A8,Y                 ;; 04FA27 : B9 A8 F9    ;
ADDR_04FA2A:          CLC                                 ;; 04FA2A : 18          ;
ADDR_04FA2B:          JMP.W CODE_04FB7B                   ;; 04FA2B : 4C 7B FB    ;
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04FA2E:          .db $70,$50,$B0                     ;; 04FA2E               ;
                                                          ;;                      ;
DATA_04FA31:          .db $00,$01,$00                     ;; 04FA31               ;
                                                          ;;                      ;
DATA_04FA34:          .db $CF,$8F,$7F                     ;; 04FA34               ;
                                                          ;;                      ;
DATA_04FA37:          .db $00,$00,$01                     ;; 04FA37               ;
                                                          ;;                      ;
DATA_04FA3A:          .db $73,$72,$63,$62                 ;; 04FA3A               ;
                                                          ;;                      ;
CODE_04FA3E:          LDA.W $0DF5,X                       ;; 04FA3E : BD F5 0D    ;
CODE_04FA41:          BNE CODE_04FA83                     ;; 04FA41 : D0 40       ;
CODE_04FA43:          LDA.W $13C1                         ;; 04FA43 : AD C1 13    ;
CODE_04FA46:          SEC                                 ;; 04FA46 : 38          ;
CODE_04FA47:          SBC.B #$4E                          ;; 04FA47 : E9 4E       ;
CODE_04FA49:          CMP.B #$03                          ;; 04FA49 : C9 03       ;
CODE_04FA4B:          BCS Return04FA82                    ;; 04FA4B : B0 35       ;
CODE_04FA4D:          TAY                                 ;; 04FA4D : A8          ;
CODE_04FA4E:          LDA.W DATA_04FA2E,Y                 ;; 04FA4E : B9 2E FA    ;
CODE_04FA51:          STA.W $0E35,X                       ;; 04FA51 : 9D 35 0E    ;
CODE_04FA54:          LDA.W DATA_04FA31,Y                 ;; 04FA54 : B9 31 FA    ;
CODE_04FA57:          STA.W $0E65,X                       ;; 04FA57 : 9D 65 0E    ;
CODE_04FA5A:          LDA.W DATA_04FA34,Y                 ;; 04FA5A : B9 34 FA    ;
CODE_04FA5D:          STA.W $0E45,X                       ;; 04FA5D : 9D 45 0E    ;
CODE_04FA60:          LDA.W DATA_04FA37,Y                 ;; 04FA60 : B9 37 FA    ;
CODE_04FA63:          STA.W $0E75,X                       ;; 04FA63 : 9D 75 0E    ;
CODE_04FA66:          JSR.W CODE_04FE5B                   ;; 04FA66 : 20 5B FE    ;
CODE_04FA69:          LSR                                 ;; 04FA69 : 4A          ;
CODE_04FA6A:          ROR                                 ;; 04FA6A : 6A          ;
CODE_04FA6B:          LSR                                 ;; 04FA6B : 4A          ;
CODE_04FA6C:          AND.B #$40                          ;; 04FA6C : 29 40       ;
CODE_04FA6E:          ORA.B #$12                          ;; 04FA6E : 09 12       ;
CODE_04FA70:          STA.W $0DF5,X                       ;; 04FA70 : 9D F5 0D    ;
CODE_04FA73:          LDA.B #$24                          ;; 04FA73 : A9 24       ;
CODE_04FA75:          STA.W $0EB5,X                       ;; 04FA75 : 9D B5 0E    ;
CODE_04FA78:          LDA.B #$0E                          ;; 04FA78 : A9 0E       ;
CODE_04FA7A:          STA.W $1DF9                         ;; 04FA7A : 8D F9 1D    ; / Play sound effect 
CODE_04FA7D:          LDA.B #$0F                          ;; 04FA7D : A9 0F       ;
CODE_04FA7F:          STA.W $0E25,X                       ;; 04FA7F : 9D 25 0E    ;
Return04FA82:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04FA83:          DEC.W $0EB5,X                       ;; 04FA83 : DE B5 0E    ;
CODE_04FA86:          LDA.W $0EB5,X                       ;; 04FA86 : BD B5 0E    ;
CODE_04FA89:          CMP.B #$E4                          ;; 04FA89 : C9 E4       ;
CODE_04FA8B:          BNE CODE_04FA90                     ;; 04FA8B : D0 03       ;
CODE_04FA8D:          JSR.W CODE_04FA7D                   ;; 04FA8D : 20 7D FA    ;
CODE_04FA90:          JSR.W CODE_04FE90                   ;; 04FA90 : 20 90 FE    ;
CODE_04FA93:          LDA.W $0E55,X                       ;; 04FA93 : BD 55 0E    ;
CODE_04FA96:          ORA.W $0E25,X                       ;; 04FA96 : 1D 25 0E    ;
CODE_04FA99:          BNE CODE_04FA9E                     ;; 04FA99 : D0 03       ;
CODE_04FA9B:          STZ.W $0DF5,X                       ;; 04FA9B : 9E F5 0D    ;
CODE_04FA9E:          JSR.W CODE_04FE62                   ;; 04FA9E : 20 62 FE    ;
CODE_04FAA1:          LDA.W $0DF5,X                       ;; 04FAA1 : BD F5 0D    ;
CODE_04FAA4:          LDY.B #$08                          ;; 04FAA4 : A0 08       ;
CODE_04FAA6:          BIT.W $0EB5,X                       ;; 04FAA6 : 3C B5 0E    ;
CODE_04FAA9:          BPL CODE_04FAAF                     ;; 04FAA9 : 10 04       ;
CODE_04FAAB:          EOR.B #$C0                          ;; 04FAAB : 49 C0       ;
CODE_04FAAD:          LDY.B #$10                          ;; 04FAAD : A0 10       ;
CODE_04FAAF:          XBA                                 ;; 04FAAF : EB          ;
CODE_04FAB0:          TYA                                 ;; 04FAB0 : 98          ;
CODE_04FAB1:          LDY.B #$4A                          ;; 04FAB1 : A0 4A       ;
CODE_04FAB3:          AND RAM_FrameCounter                ;; 04FAB3 : 25 13       ;
CODE_04FAB5:          BEQ CODE_04FAB9                     ;; 04FAB5 : F0 02       ;
CODE_04FAB7:          LDY.B #$48                          ;; 04FAB7 : A0 48       ;
CODE_04FAB9:          TYA                                 ;; 04FAB9 : 98          ;
CODE_04FABA:          JSR.W CODE_04FB06                   ;; 04FABA : 20 06 FB    ;
CODE_04FABD:          JSR.W CODE_04FE4E                   ;; 04FABD : 20 4E FE    ;
CODE_04FAC0:          SEC                                 ;; 04FAC0 : 38          ;
CODE_04FAC1:          SBC.B #$08                          ;; 04FAC1 : E9 08       ;
CODE_04FAC3:          STA $02                             ;; 04FAC3 : 85 02       ;
CODE_04FAC5:          BCS CODE_04FAC9                     ;; 04FAC5 : B0 02       ;
ADDR_04FAC7:          DEC $03                             ;; 04FAC7 : C6 03       ;
CODE_04FAC9:          LDA.B #$36                          ;; 04FAC9 : A9 36       ;
CODE_04FACB:          XBA                                 ;; 04FACB : EB          ;
CODE_04FACC:          LDA.W $0E25,X                       ;; 04FACC : BD 25 0E    ;
CODE_04FACF:          BEQ Return04FA82                    ;; 04FACF : F0 B1       ;
CODE_04FAD1:          LSR                                 ;; 04FAD1 : 4A          ;
CODE_04FAD2:          LSR                                 ;; 04FAD2 : 4A          ;
CODE_04FAD3:          PHY                                 ;; 04FAD3 : 5A          ;
CODE_04FAD4:          TAY                                 ;; 04FAD4 : A8          ;
CODE_04FAD5:          LDA.W DATA_04FA3A,Y                 ;; 04FAD5 : B9 3A FA    ;
CODE_04FAD8:          PLY                                 ;; 04FAD8 : 7A          ;
CODE_04FAD9:          PHA                                 ;; 04FAD9 : 48          ;
CODE_04FADA:          JSR.W CODE_04FAED                   ;; 04FADA : 20 ED FA    ;
CODE_04FADD:          REP #$20                            ;; 04FADD : C2 20       ; Accum (16 bit) 
CODE_04FADF:          LDA $00                             ;; 04FADF : A5 00       ;
CODE_04FAE1:          CLC                                 ;; 04FAE1 : 18          ;
CODE_04FAE2:          ADC.W #$0008                        ;; 04FAE2 : 69 08 00    ;
CODE_04FAE5:          STA $00                             ;; 04FAE5 : 85 00       ;
CODE_04FAE7:          SEP #$20                            ;; 04FAE7 : E2 20       ; Accum (8 bit) 
CODE_04FAE9:          LDA.B #$76                          ;; 04FAE9 : A9 76       ;
CODE_04FAEB:          XBA                                 ;; 04FAEB : EB          ;
CODE_04FAEC:          PLA                                 ;; 04FAEC : 68          ;
CODE_04FAED:          CLC                                 ;; 04FAED : 18          ;
CODE_04FAEE:          JMP.W CODE_04FB0A                   ;; 04FAEE : 4C 0A FB    ;
                                                          ;;                      ;
ADDR_04FAF1:          JSR.W ADDR_04FED7                   ;; 04FAF1 : 20 D7 FE    ;
ADDR_04FAF4:          JSR.W CODE_04FE62                   ;; 04FAF4 : 20 62 FE    ; NOP this and the sprite doesn't appear
ADDR_04FAF7:          JSR.W CODE_04FE5B                   ;; 04FAF7 : 20 5B FE    ; NOP this and the sprite stops animating.
ADDR_04FAFA:          LDY.B #$2A                          ;; 04FAFA : A0 2A       ;Tile for pirahna plant, #1
ADDR_04FAFC:          AND.B #$08                          ;; 04FAFC : 29 08       ;
ADDR_04FAFE:          BEQ ADDR_04FB02                     ;; 04FAFE : F0 02       ;
ADDR_04FB00:          LDY.B #$2C                          ;; 04FB00 : A0 2C       ; Tile for pirahna plant, #2, stored in $0242
ADDR_04FB02:          LDA.B #$32                          ;; 04FB02 : A9 32       ; YXPPCCCT - 00110010
ADDR_04FB04:          XBA                                 ;; 04FB04 : EB          ;
ADDR_04FB05:          TYA                                 ;; 04FB05 : 98          ;
CODE_04FB06:          SEC                                 ;; 04FB06 : 38          ;
CODE_04FB07:          LDY.W DATA_04F843,X                 ;; 04FB07 : BC 43 F8    ;
CODE_04FB0A:          STA.W $0242,Y                       ;; 04FB0A : 99 42 02    ;Tilemap
CODE_04FB0D:          XBA                                 ;; 04FB0D : EB          ;
CODE_04FB0E:          STA.W $0243,Y                       ;; 04FB0E : 99 43 02    ;Property
CODE_04FB11:          LDA $01                             ;; 04FB11 : A5 01       ;
CODE_04FB13:          BNE Return04FB36                    ;; 04FB13 : D0 21       ;
CODE_04FB15:          LDA $00                             ;; 04FB15 : A5 00       ;
CODE_04FB17:          STA.W $0240,Y                       ;; 04FB17 : 99 40 02    ;X Position
CODE_04FB1A:          LDA $03                             ;; 04FB1A : A5 03       ;
CODE_04FB1C:          BNE Return04FB36                    ;; 04FB1C : D0 18       ;
CODE_04FB1E:          PHP                                 ;; 04FB1E : 08          ;
CODE_04FB1F:          LDA $02                             ;; 04FB1F : A5 02       ;
CODE_04FB21:          STA.W $0241,Y                       ;; 04FB21 : 99 41 02    ;Y Position
CODE_04FB24:          TYA                                 ;; 04FB24 : 98          ;
CODE_04FB25:          LSR                                 ;; 04FB25 : 4A          ;
CODE_04FB26:          LSR                                 ;; 04FB26 : 4A          ;
CODE_04FB27:          PLP                                 ;; 04FB27 : 28          ;
CODE_04FB28:          PHY                                 ;; 04FB28 : 5A          ;
CODE_04FB29:          TAY                                 ;; 04FB29 : A8          ;
CODE_04FB2A:          ROL                                 ;; 04FB2A : 2A          ;
CODE_04FB2B:          ASL                                 ;; 04FB2B : 0A          ;
CODE_04FB2C:          AND.B #$03                          ;; 04FB2C : 29 03       ;
CODE_04FB2E:          STA.W $0430,Y                       ;; 04FB2E : 99 30 04    ;
CODE_04FB31:          PLY                                 ;; 04FB31 : 7A          ;
CODE_04FB32:          DEY                                 ;; 04FB32 : 88          ;
CODE_04FB33:          DEY                                 ;; 04FB33 : 88          ;
CODE_04FB34:          DEY                                 ;; 04FB34 : 88          ;
CODE_04FB35:          DEY                                 ;; 04FB35 : 88          ;
Return04FB36:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04FB37:          LDA.B #$02                          ;; 04FB37 : A9 02       ;\Overworld Sprite X Speed
CODE_04FB39:          STA.W $0E95,X                       ;; 04FB39 : 9D 95 0E    ;/
CODE_04FB3C:          LDA.B #$FF                          ;; 04FB3C : A9 FF       ;\Overworld Sprite Y Speed
CODE_04FB3E:          STA.W $0EA5,X                       ;; 04FB3E : 9D A5 0E    ;/
CODE_04FB41:          JSR.W CODE_04FE90                   ;; 04FB41 : 20 90 FE    ;Move the overworld cloud
CODE_04FB44:          JSR.W CODE_04FE62                   ;; 04FB44 : 20 62 FE    ;
CODE_04FB47:          REP #$20                            ;; 04FB47 : C2 20       ; Accum (16 bit) 
CODE_04FB49:          LDA $00                             ;; 04FB49 : A5 00       ;
CODE_04FB4B:          CLC                                 ;; 04FB4B : 18          ;
CODE_04FB4C:          ADC.W #$0020                        ;; 04FB4C : 69 20 00    ;
CODE_04FB4F:          CMP.W #$0140                        ;; 04FB4F : C9 40 01    ;
CODE_04FB52:          BCS CODE_04FB5D                     ;; 04FB52 : B0 09       ;
CODE_04FB54:          LDA $02                             ;; 04FB54 : A5 02       ;
CODE_04FB56:          CLC                                 ;; 04FB56 : 18          ;
CODE_04FB57:          ADC.W #$0080                        ;; 04FB57 : 69 80 00    ;
CODE_04FB5A:          CMP.W #$01A0                        ;; 04FB5A : C9 A0 01    ;
CODE_04FB5D:          SEP #$20                            ;; 04FB5D : E2 20       ; Accum (8 bit) 
CODE_04FB5F:          BCC CODE_04FB64                     ;; 04FB5F : 90 03       ;
CODE_04FB61:          STZ.W $0DE5,X                       ;; 04FB61 : 9E E5 0D    ;
CODE_04FB64:          LDA.B #$32                          ;; 04FB64 : A9 32       ;
CODE_04FB66:          JSR.W CODE_04FB77                   ;; 04FB66 : 20 77 FB    ;
CODE_04FB69:          REP #$20                            ;; 04FB69 : C2 20       ; Accum (16 bit) 
CODE_04FB6B:          LDA $00                             ;; 04FB6B : A5 00       ;
CODE_04FB6D:          CLC                                 ;; 04FB6D : 18          ;
CODE_04FB6E:          ADC.W #$0010                        ;; 04FB6E : 69 10 00    ;
CODE_04FB71:          STA $00                             ;; 04FB71 : 85 00       ;
CODE_04FB73:          SEP #$20                            ;; 04FB73 : E2 20       ; Accum (8 bit) 
CODE_04FB75:          LDA.B #$72                          ;; 04FB75 : A9 72       ;
CODE_04FB77:          XBA                                 ;; 04FB77 : EB          ;
CODE_04FB78:          LDA.B #$44                          ;; 04FB78 : A9 44       ;
CODE_04FB7A:          SEC                                 ;; 04FB7A : 38          ;
CODE_04FB7B:          LDY.W $0DDF                         ;; 04FB7B : AC DF 0D    ;
CODE_04FB7E:          JSR.W CODE_04FB0A                   ;; 04FB7E : 20 0A FB    ;
CODE_04FB81:          STY.W $0DDF                         ;; 04FB81 : 8C DF 0D    ;
Return04FB84:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04FB85:          .db $80,$40,$20                     ;; 04FB85               ;
                                                          ;;                      ;
DATA_04FB88:          .db $30,$10,$C0                     ;; 04FB88               ;
                                                          ;;                      ;
DATA_04FB8B:          .db $01,$01,$01                     ;; 04FB8B               ;
                                                          ;;                      ;
DATA_04FB8E:          .db $7F,$7F,$8F                     ;; 04FB8E               ;
                                                          ;;                      ;
DATA_04FB91:          .db $01,$00                         ;; 04FB91               ;
                                                          ;;                      ;
DATA_04FB93:          .db $01,$08                         ;; 04FB93               ;
                                                          ;;                      ;
DATA_04FB95:          .db $02,$0F,$00                     ;; 04FB95               ;
                                                          ;;                      ;
CODE_04FB98:          LDA.W $0DF5,X                       ;; 04FB98 : BD F5 0D    ;
CODE_04FB9B:          BNE ADDR_04FBD8                     ;; 04FB9B : D0 3B       ;
CODE_04FB9D:          LDA.W $13C1                         ;; 04FB9D : AD C1 13    ;
CODE_04FBA0:          SEC                                 ;; 04FBA0 : 38          ;
CODE_04FBA1:          SBC.B #$49                          ;; 04FBA1 : E9 49       ;
CODE_04FBA3:          CMP.B #$03                          ;; 04FBA3 : C9 03       ;
CODE_04FBA5:          BCS Return04FB84                    ;; 04FBA5 : B0 DD       ;
ADDR_04FBA7:          TAY                                 ;; 04FBA7 : A8          ;
ADDR_04FBA8:          STA.W $0EF6                         ;; 04FBA8 : 8D F6 0E    ;
ADDR_04FBAB:          LDA.W $0EF5                         ;; 04FBAB : AD F5 0E    ;
ADDR_04FBAE:          AND.W DATA_04FB85,Y                 ;; 04FBAE : 39 85 FB    ;
ADDR_04FBB1:          BNE Return04FB84                    ;; 04FBB1 : D0 D1       ;
ADDR_04FBB3:          LDA.W DATA_04FB88,Y                 ;; 04FBB3 : B9 88 FB    ;
ADDR_04FBB6:          STA.W $0E35,X                       ;; 04FBB6 : 9D 35 0E    ;
ADDR_04FBB9:          LDA.W DATA_04FB8B,Y                 ;; 04FBB9 : B9 8B FB    ;
ADDR_04FBBC:          STA.W $0E65,X                       ;; 04FBBC : 9D 65 0E    ;
ADDR_04FBBF:          LDA.W DATA_04FB8E,Y                 ;; 04FBBF : B9 8E FB    ;
ADDR_04FBC2:          STA.W $0E45,X                       ;; 04FBC2 : 9D 45 0E    ;
ADDR_04FBC5:          LDA.W DATA_04FB91,Y                 ;; 04FBC5 : B9 91 FB    ;
ADDR_04FBC8:          STA.W $0E75,X                       ;; 04FBC8 : 9D 75 0E    ;
ADDR_04FBCB:          LDA.B #$02                          ;; 04FBCB : A9 02       ;
ADDR_04FBCD:          STA.W $0DF5,X                       ;; 04FBCD : 9D F5 0D    ;
ADDR_04FBD0:          LDA.B #$F0                          ;; 04FBD0 : A9 F0       ;
ADDR_04FBD2:          STA.W $0E95,X                       ;; 04FBD2 : 9D 95 0E    ;
ADDR_04FBD5:          STZ.W $0E25,X                       ;; 04FBD5 : 9E 25 0E    ;
ADDR_04FBD8:          JSR.W CODE_04FE62                   ;; 04FBD8 : 20 62 FE    ;
ADDR_04FBDB:          LDA.W $0E25,X                       ;; 04FBDB : BD 25 0E    ;
ADDR_04FBDE:          BNE ADDR_04FC00                     ;; 04FBDE : D0 20       ;
ADDR_04FBE0:          INC.W $0E05,X                       ;; 04FBE0 : FE 05 0E    ;
ADDR_04FBE3:          JSR.W CODE_04FEAB                   ;; 04FBE3 : 20 AB FE    ;
ADDR_04FBE6:          LDY.W $0DF5,X                       ;; 04FBE6 : BC F5 0D    ;
ADDR_04FBE9:          LDA.W $0E35,X                       ;; 04FBE9 : BD 35 0E    ;
ADDR_04FBEC:          AND.B #$0F                          ;; 04FBEC : 29 0F       ;
ADDR_04FBEE:          CMP.W DATA_04FB95,Y                 ;; 04FBEE : D9 95 FB    ;
ADDR_04FBF1:          BNE ADDR_04FC00                     ;; 04FBF1 : D0 0D       ;
ADDR_04FBF3:          DEC.W $0DF5,X                       ;; 04FBF3 : DE F5 0D    ;
ADDR_04FBF6:          LDA.B #$04                          ;; 04FBF6 : A9 04       ;
ADDR_04FBF8:          STA.W $0E95,X                       ;; 04FBF8 : 9D 95 0E    ;
ADDR_04FBFB:          LDA.B #$60                          ;; 04FBFB : A9 60       ;
ADDR_04FBFD:          STA.W $0E25,X                       ;; 04FBFD : 9D 25 0E    ;
ADDR_04FC00:          LDA.W DATA_04FB93,Y                 ;; 04FC00 : B9 93 FB    ;
ADDR_04FC03:          LDY.B #$22                          ;; 04FC03 : A0 22       ;
ADDR_04FC05:          AND.W $0E05,X                       ;; 04FC05 : 3D 05 0E    ;
ADDR_04FC08:          BNE ADDR_04FC0C                     ;; 04FC08 : D0 02       ;
ADDR_04FC0A:          LDY.B #$62                          ;; 04FC0A : A0 62       ;
ADDR_04FC0C:          TYA                                 ;; 04FC0C : 98          ;
ADDR_04FC0D:          XBA                                 ;; 04FC0D : EB          ;
ADDR_04FC0E:          LDA.B #$6A                          ;; 04FC0E : A9 6A       ;
ADDR_04FC10:          JSR.W CODE_04FB06                   ;; 04FC10 : 20 06 FB    ;
ADDR_04FC13:          JSR.W ADDR_04FED7                   ;; 04FC13 : 20 D7 FE    ;
ADDR_04FC16:          BCS Return04FC1D                    ;; 04FC16 : B0 05       ;
ADDR_04FC18:          ORA.B #$80                          ;; 04FC18 : 09 80       ;
ADDR_04FC1A:          STA.W $0EF7                         ;; 04FC1A : 8D F7 0E    ;
Return04FC1D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04FC1E:          .db $38                             ;; 04FC1E               ;
                                                          ;;                      ;
DATA_04FC1F:          .db $00,$68,$00                     ;; 04FC1F               ;
                                                          ;;                      ;
DATA_04FC22:          .db $8A                             ;; 04FC22               ;
                                                          ;;                      ;
DATA_04FC23:          .db $01,$6A,$00                     ;; 04FC23               ;
                                                          ;;                      ;
DATA_04FC26:          .db $01,$02,$03,$04,$03,$02,$01,$00 ;; 04FC26               ;
                      .db $01,$02,$03,$04,$03,$02,$01,$00 ;; ?QPWZ?               ;
DATA_04FC36:          .db $FF,$FF,$FE,$FD,$FD,$FC,$FB,$FB ;; 04FC36               ;
                      .db $FA,$F9,$F9,$F8,$F7,$F7,$F6,$F5 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_04FC46:          LDA.W $0DD6                         ;; 04FC46 : AD D6 0D    ;
CODE_04FC49:          LSR                                 ;; 04FC49 : 4A          ;
CODE_04FC4A:          LSR                                 ;; 04FC4A : 4A          ;
CODE_04FC4B:          TAY                                 ;; 04FC4B : A8          ;
CODE_04FC4C:          LDA.W $1F11,Y                       ;; 04FC4C : B9 11 1F    ;
CODE_04FC4F:          ASL                                 ;; 04FC4F : 0A          ;
CODE_04FC50:          TAY                                 ;; 04FC50 : A8          ;
CODE_04FC51:          LDA.W DATA_04FC1E,Y                 ;; 04FC51 : B9 1E FC    ;
CODE_04FC54:          STA.W $0E35,X                       ;; 04FC54 : 9D 35 0E    ;
CODE_04FC57:          LDA.W DATA_04FC1F,Y                 ;; 04FC57 : B9 1F FC    ;
CODE_04FC5A:          STA.W $0E65,X                       ;; 04FC5A : 9D 65 0E    ;
CODE_04FC5D:          LDA.W DATA_04FC22,Y                 ;; 04FC5D : B9 22 FC    ;
CODE_04FC60:          STA.W $0E45,X                       ;; 04FC60 : 9D 45 0E    ;
CODE_04FC63:          LDA.W DATA_04FC23,Y                 ;; 04FC63 : B9 23 FC    ;
CODE_04FC66:          STA.W $0E75,X                       ;; 04FC66 : 9D 75 0E    ;
CODE_04FC69:          LDA RAM_FrameCounter                ;; 04FC69 : A5 13       ;
CODE_04FC6B:          AND.B #$0F                          ;; 04FC6B : 29 0F       ;
CODE_04FC6D:          BNE CODE_04FC7C                     ;; 04FC6D : D0 0D       ;
CODE_04FC6F:          LDA.W $0DF5,X                       ;; 04FC6F : BD F5 0D    ;
CODE_04FC72:          INC A                               ;; 04FC72 : 1A          ;
CODE_04FC73:          CMP.B #$0C                          ;; 04FC73 : C9 0C       ;
CODE_04FC75:          BCC CODE_04FC79                     ;; 04FC75 : 90 02       ;
CODE_04FC77:          LDA.B #$00                          ;; 04FC77 : A9 00       ;
CODE_04FC79:          STA.W $0DF5,X                       ;; 04FC79 : 9D F5 0D    ;
CODE_04FC7C:          LDA.B #$03                          ;; 04FC7C : A9 03       ;
CODE_04FC7E:          STA $04                             ;; 04FC7E : 85 04       ;
CODE_04FC80:          LDA RAM_FrameCounter                ;; 04FC80 : A5 13       ;
CODE_04FC82:          STA $06                             ;; 04FC82 : 85 06       ;
CODE_04FC84:          STZ $07                             ;; 04FC84 : 64 07       ;
CODE_04FC86:          LDY.W DATA_04F843,X                 ;; 04FC86 : BC 43 F8    ;
CODE_04FC89:          LDA.W $0DF5,X                       ;; 04FC89 : BD F5 0D    ;
CODE_04FC8C:          TAX                                 ;; 04FC8C : AA          ;
CODE_04FC8D:          PHY                                 ;; 04FC8D : 5A          ;
CODE_04FC8E:          PHX                                 ;; 04FC8E : DA          ;
CODE_04FC8F:          LDX.W $0DDE                         ;; 04FC8F : AE DE 0D    ;
CODE_04FC92:          JSR.W CODE_04FE62                   ;; 04FC92 : 20 62 FE    ;
CODE_04FC95:          PLX                                 ;; 04FC95 : FA          ;
CODE_04FC96:          LDA $07                             ;; 04FC96 : A5 07       ;
CODE_04FC98:          CLC                                 ;; 04FC98 : 18          ;
CODE_04FC99:          ADC.W DATA_04FC36,X                 ;; 04FC99 : 7D 36 FC    ;
CODE_04FC9C:          CLC                                 ;; 04FC9C : 18          ;
CODE_04FC9D:          ADC $02                             ;; 04FC9D : 65 02       ;
CODE_04FC9F:          STA $02                             ;; 04FC9F : 85 02       ;
CODE_04FCA1:          BCS CODE_04FCA5                     ;; 04FCA1 : B0 02       ;
CODE_04FCA3:          DEC $03                             ;; 04FCA3 : C6 03       ;
CODE_04FCA5:          LDA $00                             ;; 04FCA5 : A5 00       ;
CODE_04FCA7:          CLC                                 ;; 04FCA7 : 18          ;
CODE_04FCA8:          ADC.W DATA_04FC26,X                 ;; 04FCA8 : 7D 26 FC    ;
CODE_04FCAB:          STA $00                             ;; 04FCAB : 85 00       ;
CODE_04FCAD:          BCC CODE_04FCB1                     ;; 04FCAD : 90 02       ;
CODE_04FCAF:          INC $01                             ;; 04FCAF : E6 01       ;
CODE_04FCB1:          TXA                                 ;; 04FCB1 : 8A          ;
CODE_04FCB2:          CLC                                 ;; 04FCB2 : 18          ;
CODE_04FCB3:          ADC.B #$0C                          ;; 04FCB3 : 69 0C       ;
CODE_04FCB5:          CMP.B #$10                          ;; 04FCB5 : C9 10       ;
CODE_04FCB7:          AND.B #$0F                          ;; 04FCB7 : 29 0F       ;
CODE_04FCB9:          TAX                                 ;; 04FCB9 : AA          ;
CODE_04FCBA:          BCC CODE_04FCC2                     ;; 04FCBA : 90 06       ;
CODE_04FCBC:          LDA $07                             ;; 04FCBC : A5 07       ;
CODE_04FCBE:          SBC.B #$0C                          ;; 04FCBE : E9 0C       ;
CODE_04FCC0:          STA $07                             ;; 04FCC0 : 85 07       ;
CODE_04FCC2:          LDA.B #$30                          ;; 04FCC2 : A9 30       ;
CODE_04FCC4:          XBA                                 ;; 04FCC4 : EB          ;
CODE_04FCC5:          LDY.B #$28                          ;; 04FCC5 : A0 28       ;
CODE_04FCC7:          LDA $06                             ;; 04FCC7 : A5 06       ;
CODE_04FCC9:          CLC                                 ;; 04FCC9 : 18          ;
CODE_04FCCA:          ADC.B #$0A                          ;; 04FCCA : 69 0A       ;
CODE_04FCCC:          STA $06                             ;; 04FCCC : 85 06       ;
CODE_04FCCE:          AND.B #$20                          ;; 04FCCE : 29 20       ;
CODE_04FCD0:          BEQ CODE_04FCD4                     ;; 04FCD0 : F0 02       ;
CODE_04FCD2:          LDY.B #$5F                          ;; 04FCD2 : A0 5F       ;
CODE_04FCD4:          TYA                                 ;; 04FCD4 : 98          ;
CODE_04FCD5:          PLY                                 ;; 04FCD5 : 7A          ;
CODE_04FCD6:          JSR.W CODE_04FAED                   ;; 04FCD6 : 20 ED FA    ;
CODE_04FCD9:          DEC $04                             ;; 04FCD9 : C6 04       ;
CODE_04FCDB:          BNE CODE_04FC8D                     ;; 04FCDB : D0 B0       ;
CODE_04FCDD:          LDX.W $0DDE                         ;; 04FCDD : AE DE 0D    ;
Return04FCE0:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
                                                          ;;                      ;Bowser's sign code starts here.
CODE_04FCE1:          JSR.W CODE_04FE62                   ;; 04FCE1 : 20 62 FE    ;
CODE_04FCE4:          LDA.B #$04                          ;; 04FCE4 : A9 04       ;\How many tiles to show up for Bowser's sign
CODE_04FCE6:          STA $04                             ;; 04FCE6 : 85 04       ;/            
CODE_04FCE8:          LDA.B #$6F                          ;; 04FCE8 : A9 6F       ;
CODE_04FCEA:          STA $05                             ;; 04FCEA : 85 05       ; 
CODE_04FCEC:          LDY.W DATA_04F843,X                 ;; 04FCEC : BC 43 F8    ;
CODE_04FCEF:          LDA RAM_FrameCounter                ;; 04FCEF : A5 13       ;
CODE_04FCF1:          LSR                                 ;; 04FCF1 : 4A          ;
CODE_04FCF2:          AND.B #$06                          ;; 04FCF2 : 29 06       ;
CODE_04FCF4:          ORA.B #$30                          ;; 04FCF4 : 09 30       ;
CODE_04FCF6:          XBA                                 ;; 04FCF6 : EB          ;
CODE_04FCF7:          LDA $05                             ;; 04FCF7 : A5 05       ;
CODE_04FCF9:          JSR.W CODE_04FAED                   ;; 04FCF9 : 20 ED FA    ;Jump to CLC, then the OAM part of the Pirahna Plant code.
CODE_04FCFC:          LDA $00                             ;; 04FCFC : A5 00       ;
CODE_04FCFE:          SEC                                 ;; 04FCFE : 38          ;
CODE_04FCFF:          SBC.B #$08                          ;; 04FCFF : E9 08       ;
CODE_04FD01:          STA $00                             ;; 04FD01 : 85 00       ;
CODE_04FD03:          DEC $05                             ;; 04FD03 : C6 05       ;
CODE_04FD05:          DEC $04                             ;; 04FD05 : C6 04       ;
CODE_04FD07:          BNE CODE_04FCEF                     ;; 04FD07 : D0 E6       ;
Return04FD09:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04FD0A:          .db $07,$07,$03,$03,$5F,$5F         ;; 04FD0A               ;
                                                          ;;                      ;
DATA_04FD10:          .db $01,$FF,$01,$FF,$01,$FF,$01,$FF ;; 04FD10               ;
                      .db $01,$FF                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_04FD1A:          .db $18,$E8,$0A,$F6,$08,$F8,$03,$FD ;; 04FD1A               ;
DATA_04FD22:          .db $01,$FF                         ;; 04FD22               ;
                                                          ;;                      ;
CODE_04FD24:          JSR.W CODE_04FE90                   ;; 04FD24 : 20 90 FE    ;
CODE_04FD27:          JSR.W CODE_04FE62                   ;; 04FD27 : 20 62 FE    ;
CODE_04FD2A:          JSR.W CODE_04FE62                   ;; 04FD2A : 20 62 FE    ;
CODE_04FD2D:          LDA.B #$00                          ;; 04FD2D : A9 00       ;
CODE_04FD2F:          LDY.W $0E95,X                       ;; 04FD2F : BC 95 0E    ;
CODE_04FD32:          BMI CODE_04FD36                     ;; 04FD32 : 30 02       ;
CODE_04FD34:          LDA.B #$40                          ;; 04FD34 : A9 40       ;
CODE_04FD36:          XBA                                 ;; 04FD36 : EB          ;
CODE_04FD37:          LDA.B #$68                          ;; 04FD37 : A9 68       ;
CODE_04FD39:          JSR.W CODE_04FB06                   ;; 04FD39 : 20 06 FB    ;
CODE_04FD3C:          INC.W $0E15,X                       ;; 04FD3C : FE 15 0E    ;
CODE_04FD3F:          LDA.W $0E15,X                       ;; 04FD3F : BD 15 0E    ;
CODE_04FD42:          LSR                                 ;; 04FD42 : 4A          ;
CODE_04FD43:          BCS Return04FD6F                    ;; 04FD43 : B0 2A       ;
CODE_04FD45:          LDA.W $0E05,X                       ;; 04FD45 : BD 05 0E    ;
CODE_04FD48:          ORA.B #$02                          ;; 04FD48 : 09 02       ;
CODE_04FD4A:          TAY                                 ;; 04FD4A : A8          ;
CODE_04FD4B:          TXA                                 ;; 04FD4B : 8A          ;
CODE_04FD4C:          ADC.B #$10                          ;; 04FD4C : 69 10       ;
CODE_04FD4E:          TAX                                 ;; 04FD4E : AA          ;
CODE_04FD4F:          JSR.W CODE_04FD55                   ;; 04FD4F : 20 55 FD    ;
CODE_04FD52:          LDY.W $0DF5,X                       ;; 04FD52 : BC F5 0D    ;
CODE_04FD55:          LDA.W $0E95,X                       ;; 04FD55 : BD 95 0E    ;
CODE_04FD58:          CLC                                 ;; 04FD58 : 18          ;
CODE_04FD59:          ADC.W DATA_04FD10,Y                 ;; 04FD59 : 79 10 FD    ;
CODE_04FD5C:          STA.W $0E95,X                       ;; 04FD5C : 9D 95 0E    ;
CODE_04FD5F:          CMP.W DATA_04FD1A,Y                 ;; 04FD5F : D9 1A FD    ;
CODE_04FD62:          BNE CODE_04FD68                     ;; 04FD62 : D0 04       ;
CODE_04FD64:          TYA                                 ;; 04FD64 : 98          ;
CODE_04FD65:          EOR.B #$01                          ;; 04FD65 : 49 01       ;
CODE_04FD67:          TAY                                 ;; 04FD67 : A8          ;
CODE_04FD68:          TYA                                 ;; 04FD68 : 98          ;
CODE_04FD69:          STA.W $0DF5,X                       ;; 04FD69 : 9D F5 0D    ;
CODE_04FD6C:          LDX.W $0DDE                         ;; 04FD6C : AE DE 0D    ;
Return04FD6F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04FD70:          JSR.W CODE_04FE90                   ;; 04FD70 : 20 90 FE    ;
CODE_04FD73:          JSR.W CODE_04FE62                   ;; 04FD73 : 20 62 FE    ;
CODE_04FD76:          JSR.W CODE_04FE62                   ;; 04FD76 : 20 62 FE    ;
CODE_04FD79:          LDY.W $0DB3                         ;; 04FD79 : AC B3 0D    ;
CODE_04FD7C:          LDA.W $1F11,Y                       ;; 04FD7C : B9 11 1F    ;
CODE_04FD7F:          BEQ CODE_04FDA5                     ;; 04FD7F : F0 24       ;
CODE_04FD81:          CPX.B #$0F                          ;; 04FD81 : E0 0F       ;
CODE_04FD83:          BNE CODE_04FD8E                     ;; 04FD83 : D0 09       ;
CODE_04FD85:          LDA.W $1F07                         ;; 04FD85 : AD 07 1F    ;
CODE_04FD88:          AND.B #$12                          ;; 04FD88 : 29 12       ;
CODE_04FD8A:          BNE CODE_04FD8E                     ;; 04FD8A : D0 02       ;
CODE_04FD8C:          STX $03                             ;; 04FD8C : 86 03       ;
CODE_04FD8E:          TXA                                 ;; 04FD8E : 8A          ;
CODE_04FD8F:          ASL                                 ;; 04FD8F : 0A          ;
CODE_04FD90:          TAY                                 ;; 04FD90 : A8          ;
CODE_04FD91:          REP #$20                            ;; 04FD91 : C2 20       ; Accum (16 bit) 
CODE_04FD93:          LDA $00                             ;; 04FD93 : A5 00       ;
CODE_04FD95:          CLC                                 ;; 04FD95 : 18          ;
CODE_04FD96:          ADC.W DATA_04F64C,Y                 ;; 04FD96 : 79 4C F6    ;
CODE_04FD99:          STA $00                             ;; 04FD99 : 85 00       ;
CODE_04FD9B:          LDA $02                             ;; 04FD9B : A5 02       ;
CODE_04FD9D:          CLC                                 ;; 04FD9D : 18          ;
CODE_04FD9E:          ADC.W DATA_04F652,Y                 ;; 04FD9E : 79 52 F6    ;
CODE_04FDA1:          STA $02                             ;; 04FDA1 : 85 02       ;
CODE_04FDA3:          SEP #$20                            ;; 04FDA3 : E2 20       ; Accum (8 bit) 
CODE_04FDA5:          LDA.B #$34                          ;; 04FDA5 : A9 34       ;
CODE_04FDA7:          LDY.W $0E95,X                       ;; 04FDA7 : BC 95 0E    ;
CODE_04FDAA:          BMI CODE_04FDAE                     ;; 04FDAA : 30 02       ;
CODE_04FDAC:          LDA.B #$44                          ;; 04FDAC : A9 44       ;
CODE_04FDAE:          XBA                                 ;; 04FDAE : EB          ;
CODE_04FDAF:          LDA.B #$60                          ;; 04FDAF : A9 60       ;
CODE_04FDB1:          JSR.W CODE_04FB06                   ;; 04FDB1 : 20 06 FB    ;
CODE_04FDB4:          LDA.W $0E25,X                       ;; 04FDB4 : BD 25 0E    ;
CODE_04FDB7:          STA $00                             ;; 04FDB7 : 85 00       ;
CODE_04FDB9:          INC.W $0E25,X                       ;; 04FDB9 : FE 25 0E    ;
CODE_04FDBC:          TXA                                 ;; 04FDBC : 8A          ;
CODE_04FDBD:          CLC                                 ;; 04FDBD : 18          ;
CODE_04FDBE:          ADC.B #$20                          ;; 04FDBE : 69 20       ;
CODE_04FDC0:          TAX                                 ;; 04FDC0 : AA          ;
CODE_04FDC1:          LDA.B #$08                          ;; 04FDC1 : A9 08       ;
CODE_04FDC3:          JSR.W CODE_04FDD2                   ;; 04FDC3 : 20 D2 FD    ;
CODE_04FDC6:          TXA                                 ;; 04FDC6 : 8A          ;
CODE_04FDC7:          CLC                                 ;; 04FDC7 : 18          ;
CODE_04FDC8:          ADC.B #$10                          ;; 04FDC8 : 69 10       ;
CODE_04FDCA:          TAX                                 ;; 04FDCA : AA          ;
CODE_04FDCB:          LDA.B #$06                          ;; 04FDCB : A9 06       ;
CODE_04FDCD:          JSR.W CODE_04FDD2                   ;; 04FDCD : 20 D2 FD    ;
CODE_04FDD0:          LDA.B #$04                          ;; 04FDD0 : A9 04       ;
CODE_04FDD2:          ORA.W $0DF5,X                       ;; 04FDD2 : 1D F5 0D    ;
CODE_04FDD5:          TAY                                 ;; 04FDD5 : A8          ;
CODE_04FDD6:          LDA.W ADDR_04FD06,Y                 ;; 04FDD6 : B9 06 FD    ;
CODE_04FDD9:          AND $00                             ;; 04FDD9 : 25 00       ;
CODE_04FDDB:          BNE CODE_04FD68                     ;; 04FDDB : D0 8B       ;
CODE_04FDDD:          JMP.W CODE_04FD55                   ;; 04FDDD : 4C 55 FD    ;
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04FDE0:          .db $00,$00,$00,$00,$01,$02,$02,$02 ;; 04FDE0               ;
                      .db $00,$00,$01,$01,$02,$02,$03,$03 ;; ?QPWZ?               ;
DATA_04FDF0:          .db $08,$08,$08,$08,$07,$06,$05,$05 ;; 04FDF0               ;
                      .db $00,$00,$0E,$0E,$0C,$0C,$0A,$0A ;; ?QPWZ?               ;
                                                          ;;                      ;
ADDR_04FE00:          ROR $04                             ;; 04FE00 : 66 04       ;
ADDR_04FE02:          JSR.W CODE_04FE62                   ;; 04FE02 : 20 62 FE    ;
ADDR_04FE05:          JSR.W CODE_04FE4E                   ;; 04FE05 : 20 4E FE    ;
ADDR_04FE08:          LDA.W $0E55,X                       ;; 04FE08 : BD 55 0E    ;
ADDR_04FE0B:          LSR                                 ;; 04FE0B : 4A          ;
ADDR_04FE0C:          LSR                                 ;; 04FE0C : 4A          ;
ADDR_04FE0D:          LSR                                 ;; 04FE0D : 4A          ;
ADDR_04FE0E:          LSR                                 ;; 04FE0E : 4A          ;
ADDR_04FE0F:          LDY.B #$29                          ;; 04FE0F : A0 29       ;
ADDR_04FE11:          BIT $04                             ;; 04FE11 : 24 04       ;
ADDR_04FE13:          BPL ADDR_04FE1A                     ;; 04FE13 : 10 05       ;
ADDR_04FE15:          LDY.B #$2E                          ;; 04FE15 : A0 2E       ;
ADDR_04FE17:          CLC                                 ;; 04FE17 : 18          ;
ADDR_04FE18:          ADC.B #$08                          ;; 04FE18 : 69 08       ;
ADDR_04FE1A:          STY $05                             ;; 04FE1A : 84 05       ;
ADDR_04FE1C:          TAY                                 ;; 04FE1C : A8          ;
ADDR_04FE1D:          STY $06                             ;; 04FE1D : 84 06       ;
ADDR_04FE1F:          LDA $00                             ;; 04FE1F : A5 00       ;
ADDR_04FE21:          CLC                                 ;; 04FE21 : 18          ;
ADDR_04FE22:          ADC.W DATA_04FDE0,Y                 ;; 04FE22 : 79 E0 FD    ;
ADDR_04FE25:          STA $00                             ;; 04FE25 : 85 00       ;
ADDR_04FE27:          BCC ADDR_04FE2B                     ;; 04FE27 : 90 02       ;
ADDR_04FE29:          INC $01                             ;; 04FE29 : E6 01       ;
ADDR_04FE2B:          LDA.B #$32                          ;; 04FE2B : A9 32       ;
ADDR_04FE2D:          LDY.W DATA_04F843,X                 ;; 04FE2D : BC 43 F8    ;
ADDR_04FE30:          JSR.W ADDR_04FE45                   ;; 04FE30 : 20 45 FE    ;
ADDR_04FE33:          PHY                                 ;; 04FE33 : 5A          ;
ADDR_04FE34:          LDY $06                             ;; 04FE34 : A4 06       ;
ADDR_04FE36:          LDA $00                             ;; 04FE36 : A5 00       ;
ADDR_04FE38:          CLC                                 ;; 04FE38 : 18          ;
ADDR_04FE39:          ADC.W DATA_04FDF0,Y                 ;; 04FE39 : 79 F0 FD    ;
ADDR_04FE3C:          STA $00                             ;; 04FE3C : 85 00       ;
ADDR_04FE3E:          BCC ADDR_04FE42                     ;; 04FE3E : 90 02       ;
ADDR_04FE40:          INC $01                             ;; 04FE40 : E6 01       ;
ADDR_04FE42:          LDA.B #$72                          ;; 04FE42 : A9 72       ;
ADDR_04FE44:          PLY                                 ;; 04FE44 : 7A          ;
ADDR_04FE45:          XBA                                 ;; 04FE45 : EB          ;
ADDR_04FE46:          LDA $04                             ;; 04FE46 : A5 04       ;
ADDR_04FE48:          ASL                                 ;; 04FE48 : 0A          ;
ADDR_04FE49:          LDA $05                             ;; 04FE49 : A5 05       ;
ADDR_04FE4B:          JMP.W CODE_04FB0A                   ;; 04FE4B : 4C 0A FB    ;
                                                          ;;                      ;
CODE_04FE4E:          LDA $02                             ;; 04FE4E : A5 02       ;
CODE_04FE50:          CLC                                 ;; 04FE50 : 18          ;
CODE_04FE51:          ADC.W $0E55,X                       ;; 04FE51 : 7D 55 0E    ;
CODE_04FE54:          STA $02                             ;; 04FE54 : 85 02       ;
CODE_04FE56:          BCC Return04FE5A                    ;; 04FE56 : 90 02       ;
ADDR_04FE58:          INC $03                             ;; 04FE58 : E6 03       ;
Return04FE5A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04FE5B:          LDA RAM_FrameCounter                ;; 04FE5B : A5 13       ;
CODE_04FE5D:          CLC                                 ;; 04FE5D : 18          ;
CODE_04FE5E:          ADC.W DATA_04F833,X                 ;; 04FE5E : 7D 33 F8    ;
Return04FE61:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04FE62:          TXA                                 ;; 04FE62 : 8A          ;
CODE_04FE63:          CLC                                 ;; 04FE63 : 18          ;
CODE_04FE64:          ADC.B #$10                          ;; 04FE64 : 69 10       ;
CODE_04FE66:          TAX                                 ;; 04FE66 : AA          ;
CODE_04FE67:          LDY.B #$02                          ;; 04FE67 : A0 02       ;
CODE_04FE69:          JSR.W CODE_04FE7D                   ;; 04FE69 : 20 7D FE    ;
CODE_04FE6C:          LDX.W $0DDE                         ;; 04FE6C : AE DE 0D    ;
CODE_04FE6F:          LDA $02                             ;; 04FE6F : A5 02       ;
CODE_04FE71:          SEC                                 ;; 04FE71 : 38          ;
CODE_04FE72:          SBC.W $0E55,X                       ;; 04FE72 : FD 55 0E    ;
CODE_04FE75:          STA $02                             ;; 04FE75 : 85 02       ;
CODE_04FE77:          BCS CODE_04FE7B                     ;; 04FE77 : B0 02       ;
CODE_04FE79:          DEC $03                             ;; 04FE79 : C6 03       ;
CODE_04FE7B:          LDY.B #$00                          ;; 04FE7B : A0 00       ;
CODE_04FE7D:          LDA.W $0E65,X                       ;; 04FE7D : BD 65 0E    ;
CODE_04FE80:          XBA                                 ;; 04FE80 : EB          ;
CODE_04FE81:          LDA.W $0E35,X                       ;; 04FE81 : BD 35 0E    ;
CODE_04FE84:          REP #$20                            ;; 04FE84 : C2 20       ; Accum (16 bit) 
CODE_04FE86:          SEC                                 ;; 04FE86 : 38          ;
CODE_04FE87:          SBC.W RAM_ScreenBndryXLo,Y          ;; 04FE87 : F9 1A 00    ;
CODE_04FE8A:          STA.W $0000,Y                       ;; 04FE8A : 99 00 00    ;
CODE_04FE8D:          SEP #$20                            ;; 04FE8D : E2 20       ; Accum (8 bit) 
Return04FE8F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_04FE90:          TXA                                 ;; 04FE90 : 8A          ;Transfer X to A
CODE_04FE91:          CLC                                 ;; 04FE91 : 18          ;Clear Carry Flag
CODE_04FE92:          ADC.B #$20                          ;; 04FE92 : 69 20       ;Add #$20 to A
CODE_04FE94:          TAX                                 ;; 04FE94 : AA          ;Transfer A to X
CODE_04FE95:          JSR.W CODE_04FEAB                   ;; 04FE95 : 20 AB FE    ;
CODE_04FE98:          LDA.W $0E35,X                       ;; 04FE98 : BD 35 0E    ;Load OW Sprite XPos Low
CODE_04FE9B:          BPL CODE_04FEA0                     ;; 04FE9B : 10 03       ;If it is => 80
CODE_04FE9D:          STZ.W $0E35,X                       ;; 04FE9D : 9E 35 0E    ;Store 00 OW Sprite Xpos Low
CODE_04FEA0:          TXA                                 ;; 04FEA0 : 8A          ;Transfer X to A
CODE_04FEA1:          SEC                                 ;; 04FEA1 : 38          ;Set Carry Flag...
CODE_04FEA2:          SBC.B #$10                          ;; 04FEA2 : E9 10       ;...for substraction
CODE_04FEA4:          TAX                                 ;; 04FEA4 : AA          ;Transfer A to X
CODE_04FEA5:          JSR.W CODE_04FEAB                   ;; 04FEA5 : 20 AB FE    ;
CODE_04FEA8:          LDX.W $0DDE                         ;; 04FEA8 : AE DE 0D    ;
CODE_04FEAB:          LDA.W $0E95,X                       ;; 04FEAB : BD 95 0E    ;Load OW Sprite X Speed
CODE_04FEAE:          ASL                                 ;; 04FEAE : 0A          ;Multiply it by 2
CODE_04FEAF:          ASL                                 ;; 04FEAF : 0A          ;4...
CODE_04FEB0:          ASL                                 ;; 04FEB0 : 0A          ;8...
CODE_04FEB1:          ASL                                 ;; 04FEB1 : 0A          ;16...
CODE_04FEB2:          CLC                                 ;; 04FEB2 : 18          ;Clear Carry Flag
CODE_04FEB3:          ADC.W $0EC5,X                       ;; 04FEB3 : 7D C5 0E    ;
CODE_04FEB6:          STA.W $0EC5,X                       ;; 04FEB6 : 9D C5 0E    ;And store it in
CODE_04FEB9:          LDA.W $0E95,X                       ;; 04FEB9 : BD 95 0E    ;Load OW Sprite X Speed
CODE_04FEBC:          PHP                                 ;; 04FEBC : 08          ;
CODE_04FEBD:          LSR                                 ;; 04FEBD : 4A          ;Divide by 2
CODE_04FEBE:          LSR                                 ;; 04FEBE : 4A          ;4
CODE_04FEBF:          LSR                                 ;; 04FEBF : 4A          ;8
CODE_04FEC0:          LSR                                 ;; 04FEC0 : 4A          ;16
CODE_04FEC1:          LDY.B #$00                          ;; 04FEC1 : A0 00       ;Load $00 in Y
CODE_04FEC3:          PLP                                 ;; 04FEC3 : 28          ;
CODE_04FEC4:          BPL CODE_04FEC9                     ;; 04FEC4 : 10 03       ;
CODE_04FEC6:          ORA.B #$F0                          ;; 04FEC6 : 09 F0       ;
CODE_04FEC8:          DEY                                 ;; 04FEC8 : 88          ;
CODE_04FEC9:          ADC.W $0E35,X                       ;; 04FEC9 : 7D 35 0E    ;
CODE_04FECC:          STA.W $0E35,X                       ;; 04FECC : 9D 35 0E    ;
CODE_04FECF:          TYA                                 ;; 04FECF : 98          ;
CODE_04FED0:          ADC.W $0E65,X                       ;; 04FED0 : 7D 65 0E    ;
CODE_04FED3:          STA.W $0E65,X                       ;; 04FED3 : 9D 65 0E    ;
Return04FED6:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
ADDR_04FED7:          JSR.W ADDR_04FEEF                   ;; 04FED7 : 20 EF FE    ; Accum (16 bit) 
ADDR_04FEDA:          LDA $06                             ;; 04FEDA : A5 06       ;
ADDR_04FEDC:          CMP.W #$0008                        ;; 04FEDC : C9 08 00    ;
ADDR_04FEDF:          BCS ADDR_04FEE6                     ;; 04FEDF : B0 05       ;
ADDR_04FEE1:          LDA $08                             ;; 04FEE1 : A5 08       ;
ADDR_04FEE3:          CMP.W #$0008                        ;; 04FEE3 : C9 08 00    ;
ADDR_04FEE6:          SEP #$20                            ;; 04FEE6 : E2 20       ; Accum (8 bit) 
ADDR_04FEE8:          TXA                                 ;; 04FEE8 : 8A          ;
ADDR_04FEE9:          BCS Return04FEEE                    ;; 04FEE9 : B0 03       ;
ADDR_04FEEB:          STA.W $0EF7                         ;; 04FEEB : 8D F7 0E    ;
Return04FEEE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
ADDR_04FEEF:          LDA.W $0E65,X                       ;; 04FEEF : BD 65 0E    ;
ADDR_04FEF2:          XBA                                 ;; 04FEF2 : EB          ;
ADDR_04FEF3:          LDA.W $0E35,X                       ;; 04FEF3 : BD 35 0E    ;
ADDR_04FEF6:          REP #$20                            ;; 04FEF6 : C2 20       ; Accum (16 bit) 
ADDR_04FEF8:          CLC                                 ;; 04FEF8 : 18          ;
ADDR_04FEF9:          ADC.W #$0008                        ;; 04FEF9 : 69 08 00    ;
ADDR_04FEFC:          LDY.W $0DD6                         ;; 04FEFC : AC D6 0D    ;
ADDR_04FEFF:          SEC                                 ;; 04FEFF : 38          ;
ADDR_04FF00:          SBC.W $1F17,Y                       ;; 04FF00 : F9 17 1F    ;
ADDR_04FF03:          STA $00                             ;; 04FF03 : 85 00       ;
ADDR_04FF05:          BPL ADDR_04FF0B                     ;; 04FF05 : 10 04       ;
ADDR_04FF07:          EOR.W #$FFFF                        ;; 04FF07 : 49 FF FF    ;
ADDR_04FF0A:          INC A                               ;; 04FF0A : 1A          ;
ADDR_04FF0B:          STA $06                             ;; 04FF0B : 85 06       ;
ADDR_04FF0D:          SEP #$20                            ;; 04FF0D : E2 20       ; Accum (8 bit) 
ADDR_04FF0F:          LDA.W $0E75,X                       ;; 04FF0F : BD 75 0E    ;
ADDR_04FF12:          XBA                                 ;; 04FF12 : EB          ;
ADDR_04FF13:          LDA.W $0E45,X                       ;; 04FF13 : BD 45 0E    ;
ADDR_04FF16:          REP #$20                            ;; 04FF16 : C2 20       ; Accum (16 bit) 
ADDR_04FF18:          CLC                                 ;; 04FF18 : 18          ;
ADDR_04FF19:          ADC.W #$0008                        ;; 04FF19 : 69 08 00    ;
ADDR_04FF1C:          LDY.W $0DD6                         ;; 04FF1C : AC D6 0D    ;
ADDR_04FF1F:          SEC                                 ;; 04FF1F : 38          ;
ADDR_04FF20:          SBC.W $1F19,Y                       ;; 04FF20 : F9 19 1F    ;
ADDR_04FF23:          STA $02                             ;; 04FF23 : 85 02       ;
ADDR_04FF25:          BPL ADDR_04FF2B                     ;; 04FF25 : 10 04       ;
ADDR_04FF27:          EOR.W #$FFFF                        ;; 04FF27 : 49 FF FF    ;
ADDR_04FF2A:          INC A                               ;; 04FF2A : 1A          ;
ADDR_04FF2B:          STA $08                             ;; 04FF2B : 85 08       ;
Return04FF2D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
ADDR_04FF2E:          JSR.W ADDR_04FEEF                   ;; 04FF2E : 20 EF FE    ;
ADDR_04FF31:          LSR $06                             ;; 04FF31 : 46 06       ;
ADDR_04FF33:          LSR $08                             ;; 04FF33 : 46 08       ;
ADDR_04FF35:          SEP #$20                            ;; 04FF35 : E2 20       ; Accum (8 bit) 
ADDR_04FF37:          LDA.W $0E55,X                       ;; 04FF37 : BD 55 0E    ;
ADDR_04FF3A:          LSR                                 ;; 04FF3A : 4A          ;
ADDR_04FF3B:          STA $0A                             ;; 04FF3B : 85 0A       ;
ADDR_04FF3D:          STZ $05                             ;; 04FF3D : 64 05       ;
ADDR_04FF3F:          LDY.B #$04                          ;; 04FF3F : A0 04       ;
ADDR_04FF41:          CMP $08                             ;; 04FF41 : C5 08       ;
ADDR_04FF43:          BCS ADDR_04FF49                     ;; 04FF43 : B0 04       ;
ADDR_04FF45:          LDY.B #$02                          ;; 04FF45 : A0 02       ;
ADDR_04FF47:          LDA $08                             ;; 04FF47 : A5 08       ;
ADDR_04FF49:          CMP $06                             ;; 04FF49 : C5 06       ;
ADDR_04FF4B:          BCS ADDR_04FF51                     ;; 04FF4B : B0 04       ;
ADDR_04FF4D:          LDY.B #$00                          ;; 04FF4D : A0 00       ;
ADDR_04FF4F:          LDA $06                             ;; 04FF4F : A5 06       ;
ADDR_04FF51:          CMP.B #$01                          ;; 04FF51 : C9 01       ;
ADDR_04FF53:          BCS ADDR_04FF67                     ;; 04FF53 : B0 12       ;
ADDR_04FF55:          STZ.W $0E15,X                       ;; 04FF55 : 9E 15 0E    ;
ADDR_04FF58:          STZ.W $0E95,X                       ;; 04FF58 : 9E 95 0E    ;
ADDR_04FF5B:          STZ.W $0EA5,X                       ;; 04FF5B : 9E A5 0E    ;
ADDR_04FF5E:          STZ.W $0EB5,X                       ;; 04FF5E : 9E B5 0E    ;
ADDR_04FF61:          LDA.B #$40                          ;; 04FF61 : A9 40       ;
ADDR_04FF63:          STA.W $0E55,X                       ;; 04FF63 : 9D 55 0E    ;
Return04FF66:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
ADDR_04FF67:          STY $0C                             ;; 04FF67 : 84 0C       ;
ADDR_04FF69:          LDX.B #$04                          ;; 04FF69 : A2 04       ;
ADDR_04FF6B:          CPX $0C                             ;; 04FF6B : E4 0C       ;
ADDR_04FF6D:          BNE ADDR_04FF73                     ;; 04FF6D : D0 04       ;
ADDR_04FF6F:          LDA.B #$20                          ;; 04FF6F : A9 20       ;
ADDR_04FF71:          BRA ADDR_04FF91                     ;; 04FF71 : 80 1E       ;
                                                          ;;                      ;
ADDR_04FF73:          STZ.W $4204                         ;; 04FF73 : 9C 04 42    ; Dividend (Low Byte)
ADDR_04FF76:          LDA $06,X                           ;; 04FF76 : B5 06       ;
ADDR_04FF78:          STA.W $4205                         ;; 04FF78 : 8D 05 42    ; Dividend (High-Byte)
ADDR_04FF7B:          LDA.W $0006,Y                       ;; 04FF7B : B9 06 00    ;
ADDR_04FF7E:          STA.W $4206                         ;; 04FF7E : 8D 06 42    ; Divisor B
ADDR_04FF81:          NOP                                 ;; 04FF81 : EA          ;
ADDR_04FF82:          NOP                                 ;; 04FF82 : EA          ;
ADDR_04FF83:          NOP                                 ;; 04FF83 : EA          ;
ADDR_04FF84:          NOP                                 ;; 04FF84 : EA          ;
ADDR_04FF85:          NOP                                 ;; 04FF85 : EA          ;
ADDR_04FF86:          NOP                                 ;; 04FF86 : EA          ;
ADDR_04FF87:          REP #$20                            ;; 04FF87 : C2 20       ; Accum (16 bit) 
ADDR_04FF89:          LDA.W $4214                         ;; 04FF89 : AD 14 42    ; Quotient of Divide Result (Low Byte)
ADDR_04FF8C:          LSR                                 ;; 04FF8C : 4A          ;
ADDR_04FF8D:          LSR                                 ;; 04FF8D : 4A          ;
ADDR_04FF8E:          LSR                                 ;; 04FF8E : 4A          ;
ADDR_04FF8F:          SEP #$20                            ;; 04FF8F : E2 20       ; Accum (8 bit) 
ADDR_04FF91:          BIT $01,X                           ;; 04FF91 : 34 01       ;
ADDR_04FF93:          BMI ADDR_04FF98                     ;; 04FF93 : 30 03       ;
ADDR_04FF95:          EOR.B #$FF                          ;; 04FF95 : 49 FF       ;
ADDR_04FF97:          INC A                               ;; 04FF97 : 1A          ;
ADDR_04FF98:          STA $00,X                           ;; 04FF98 : 95 00       ;
ADDR_04FF9A:          DEX                                 ;; 04FF9A : CA          ;
ADDR_04FF9B:          DEX                                 ;; 04FF9B : CA          ;
ADDR_04FF9C:          BPL ADDR_04FF6B                     ;; 04FF9C : 10 CD       ;
ADDR_04FF9E:          LDX.W $0DDE                         ;; 04FF9E : AE DE 0D    ;
ADDR_04FFA1:          LDA $00                             ;; 04FFA1 : A5 00       ;
ADDR_04FFA3:          STA.W $0E95,X                       ;; 04FFA3 : 9D 95 0E    ;
ADDR_04FFA6:          LDA $02                             ;; 04FFA6 : A5 02       ;
ADDR_04FFA8:          STA.W $0EA5,X                       ;; 04FFA8 : 9D A5 0E    ;
ADDR_04FFAB:          LDA $04                             ;; 04FFAB : A5 04       ;
ADDR_04FFAD:          STA.W $0EB5,X                       ;; 04FFAD : 9D B5 0E    ;
Return04FFB0:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_04FFB1:          .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; 04FFB1               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF     ;; ?QPWZ?               ;
