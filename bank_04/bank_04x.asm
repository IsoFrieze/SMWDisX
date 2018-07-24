DATA_048000:                      .db $80,$B4,$98,$B4,$B0,$B4

DATA_048006:                      .db $00,$B3,$18,$B3,$30,$B3,$48,$B3
                                  .db $60,$B3,$78,$B3,$90,$B3,$A8,$B3
                                  .db $C0,$B3,$D8,$B3,$F0,$B3,$08,$B4
                                  .db $20,$B4,$38,$B4,$50,$B4,$68,$B4
                                  .db $80,$B4,$98,$B4,$B0,$B4,$C8,$B4
                                  .db $E0,$B4,$F8,$B4,$10,$B5,$28,$B5
                                  .db $40,$B5,$58,$B5,$70,$B5,$88,$B5
                                  .db $A0,$B5,$B8,$B5,$D0,$B5,$E8,$B5
                                  .db $00,$B6,$18,$B6,$30,$B6,$48,$B6
                                  .db $60,$B6,$78,$B6,$90,$B6,$A8,$B6
                                  .db $C0,$B6,$D8,$B6,$F0,$B6,$08,$B7
                                  .db $20,$B7,$38,$B7,$50,$B7,$68,$B7
                                  .db $80,$B7,$98,$B7,$B0,$B7,$C8,$B7
                                  .db $E0,$B7,$F8,$B7,$10,$B8,$28,$B8
                                  .db $40,$B8,$58,$B8,$70,$B8,$88,$B8
                                  .db $A0,$B8,$B8,$B8,$D0,$B8,$E8,$B8

CODE_048086:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_048088:        64 03         STZ $03                   
CODE_04808A:        64 05         STZ $05                   
CODE_04808C:        A6 03         LDX $03                   
CODE_04808E:        BD 00 80      LDA.W DATA_048000,X       
CODE_048091:        85 00         STA $00                   
CODE_048093:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_048095:        A0 7E         LDY.B #$7E                
CODE_048097:        84 02         STY $02                   
CODE_048099:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_04809B:        A6 05         LDX $05                   
CODE_04809D:        20 B9 80      JSR.W CODE_0480B9         
CODE_0480A0:        A5 05         LDA $05                   
CODE_0480A2:        18            CLC                       
CODE_0480A3:        69 20 00      ADC.W #$0020              
CODE_0480A6:        85 05         STA $05                   
CODE_0480A8:        A5 03         LDA $03                   
CODE_0480AA:        1A            INC A                     
CODE_0480AB:        1A            INC A                     
CODE_0480AC:        85 03         STA $03                   
CODE_0480AE:        29 FF 00      AND.W #$00FF              
CODE_0480B1:        C9 06 00      CMP.W #$0006              
CODE_0480B4:        D0 D6         BNE CODE_04808C           
CODE_0480B6:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return0480B8:       60            RTS                       ; Return 

CODE_0480B9:        A0 00 00      LDY.W #$0000              ; Index (16 bit) Accum (16 bit) 
CODE_0480BC:        A9 08 00      LDA.W #$0008              
CODE_0480BF:        85 07         STA $07                   
CODE_0480C1:        85 09         STA $09                   
CODE_0480C3:        B7 00         LDA [$00],Y               
CODE_0480C5:        9D F6 0A      STA.W $0AF6,X             
CODE_0480C8:        C8            INY                       
CODE_0480C9:        C8            INY                       
CODE_0480CA:        E8            INX                       
CODE_0480CB:        E8            INX                       
CODE_0480CC:        C6 07         DEC $07                   
CODE_0480CE:        D0 F3         BNE CODE_0480C3           
CODE_0480D0:        B7 00         LDA [$00],Y               
CODE_0480D2:        29 FF 00      AND.W #$00FF              
CODE_0480D5:        9D F6 0A      STA.W $0AF6,X             
CODE_0480D8:        C8            INY                       
CODE_0480D9:        E8            INX                       
CODE_0480DA:        E8            INX                       
CODE_0480DB:        C6 09         DEC $09                   
CODE_0480DD:        D0 F1         BNE CODE_0480D0           
Return0480DF:       60            RTS                       ; Return 

OW_Tile_Animation:  A5 13         LDA RAM_FrameCounter      ; \ ; Index (8 bit) Accum (8 bit) 
CODE_0480E2:        29 07         AND.B #$07                ;  |If lower 3 bits of frame counter isn't 0, 
CODE_0480E4:        D0 1B         BNE CODE_048101           ; / don't update the water animation 
CODE_0480E6:        A2 1F         LDX.B #$1F                
CODE_0480E8:        BD F6 0A      LDA.W $0AF6,X             
CODE_0480EB:        85 00         STA $00                   
CODE_0480ED:        8A            TXA                       
CODE_0480EE:        29 08         AND.B #$08                
CODE_0480F0:        D0 07         BNE CODE_0480F9           
CODE_0480F2:        06 00         ASL $00                   
CODE_0480F4:        3E F6 0A      ROL.W $0AF6,X             
CODE_0480F7:        80 05         BRA CODE_0480FE           

CODE_0480F9:        46 00         LSR $00                   
CODE_0480FB:        7E F6 0A      ROR.W $0AF6,X             
CODE_0480FE:        CA            DEX                       
CODE_0480FF:        10 E7         BPL CODE_0480E8           
CODE_048101:        A5 13         LDA RAM_FrameCounter      ; \ 
CODE_048103:        29 07         AND.B #$07                ;  |If lower 3 bits of frame counter isn't 0, 
CODE_048105:        D0 05         BNE CODE_04810C           ; / don't update the waterfall animation 
CODE_048107:        A2 20         LDX.B #$20                
CODE_048109:        20 72 81      JSR.W CODE_048172         
CODE_04810C:        A5 13         LDA RAM_FrameCounter      ; \ 
CODE_04810E:        29 07         AND.B #$07                ;  |If lower 3 bits of frame counter isn't 0, 
CODE_048110:        D0 11         BNE CODE_048123           ; / branch to $8123 
CODE_048112:        A2 1F         LDX.B #$1F                
CODE_048114:        BD 36 0B      LDA.W $0B36,X             
CODE_048117:        0A            ASL                       
CODE_048118:        3E 36 0B      ROL.W $0B36,X             
CODE_04811B:        CA            DEX                       
CODE_04811C:        10 F6         BPL CODE_048114           
CODE_04811E:        A2 40         LDX.B #$40                
CODE_048120:        20 72 81      JSR.W CODE_048172         
CODE_048123:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_048125:        A9 60 00      LDA.W #$0060              
CODE_048128:        85 0D         STA $0D                   
CODE_04812A:        64 0B         STZ $0B                   
CODE_04812C:        A2 38 00      LDX.W #$0038              
CODE_04812F:        A5 0B         LDA $0B                   
CODE_048131:        C9 20 00      CMP.W #$0020              
CODE_048134:        B0 03         BCS CODE_048139           
CODE_048136:        A2 70 00      LDX.W #$0070              
CODE_048139:        8A            TXA                       
CODE_04813A:        25 13         AND RAM_FrameCounter      
CODE_04813C:        4A            LSR                       
CODE_04813D:        4A            LSR                       
CODE_04813E:        E0 38 00      CPX.W #$0038              
CODE_048141:        F0 01         BEQ CODE_048144           
CODE_048143:        4A            LSR                       
CODE_048144:        18            CLC                       
CODE_048145:        65 0B         ADC $0B                   
CODE_048147:        AA            TAX                       
CODE_048148:        BD 06 80      LDA.W DATA_048006,X       
CODE_04814B:        85 00         STA $00                   
CODE_04814D:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_04814F:        A0 7E         LDY.B #$7E                
CODE_048151:        84 02         STY $02                   
CODE_048153:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_048155:        A6 0D         LDX $0D                   
CODE_048157:        20 B9 80      JSR.W CODE_0480B9         
CODE_04815A:        A5 0D         LDA $0D                   
CODE_04815C:        18            CLC                       
CODE_04815D:        69 20 00      ADC.W #$0020              
CODE_048160:        85 0D         STA $0D                   
CODE_048162:        A5 0B         LDA $0B                   
CODE_048164:        18            CLC                       
CODE_048165:        69 10 00      ADC.W #$0010              
CODE_048168:        85 0B         STA $0B                   
CODE_04816A:        C9 80 00      CMP.W #$0080              
CODE_04816D:        D0 BD         BNE CODE_04812C           
CODE_04816F:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return048171:       60            RTS                       ; Return 

CODE_048172:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_048174:        A0 00         LDY.B #$00                
CODE_048176:        DA            PHX                       
CODE_048177:        8A            TXA                       
CODE_048178:        18            CLC                       
CODE_048179:        69 0E 00      ADC.W #$000E              
CODE_04817C:        AA            TAX                       
CODE_04817D:        BD F6 0A      LDA.W $0AF6,X             
CODE_048180:        85 00         STA $00                   
CODE_048182:        FA            PLX                       
CODE_048183:        BD F6 0A      LDA.W $0AF6,X             
CODE_048186:        85 02         STA $02                   
CODE_048188:        A5 00         LDA $00                   
CODE_04818A:        9D F6 0A      STA.W $0AF6,X             
CODE_04818D:        A5 02         LDA $02                   
CODE_04818F:        85 00         STA $00                   
CODE_048191:        E8            INX                       
CODE_048192:        E8            INX                       
CODE_048193:        C8            INY                       
CODE_048194:        C0 08         CPY.B #$08                
CODE_048196:        F0 DE         BEQ CODE_048176           
CODE_048198:        C0 10         CPY.B #$10                
CODE_04819A:        D0 E7         BNE CODE_048183           
CODE_04819C:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return04819E:       60            RTS                       ; Return 


DATA_04819F:                      .db $50,$CF,$00,$03,$7E,$78,$7E,$38
                                  .db $50,$EF,$00,$03,$7F,$38,$7F,$78
                                  .db $51,$C3,$00,$03,$7E,$78,$7D,$78
                                  .db $51,$E3,$00,$03,$7E,$F8,$7D,$F8
                                  .db $51,$DB,$00,$03,$7D,$38,$7E,$38
                                  .db $51,$FB,$00,$03,$7D,$B8,$7E,$B8
                                  .db $52,$EF,$00,$03,$7F,$B8,$7F,$F8
                                  .db $53,$0F,$00,$03,$7E,$F8,$7E,$B8
                                  .db $FF

DATA_0481E0:                      .db $50,$CF,$40,$02,$FC,$00,$50,$EF
                                  .db $40,$02,$FC,$00,$51,$C3,$40,$02
                                  .db $FC,$00,$51,$E3,$40,$02,$FC,$00
                                  .db $51,$DB,$40,$02,$FC,$00,$51,$FB
                                  .db $40,$02,$FC,$00,$52,$EF,$40,$02
                                  .db $FC,$00,$53,$0F,$40,$02,$FC,$00
                                  .db $FF

DATA_048211:                      .db $00,$00,$02,$00,$FE,$FF,$02,$00
                                  .db $00,$00,$02,$00,$FE,$FF,$02,$00
DATA_048221:                      .db $00,$00,$11,$01,$EF,$FF,$11,$01
                                  .db $00,$00,$32,$01,$D7,$FF,$32,$01
DATA_048231:                      .db $0F,$0F,$07,$07,$07,$03,$03,$03
                                  .db $01,$01,$03,$03,$03,$07,$07,$07

GameMode_0E_Prim:   8B            PHB                       
CODE_048242:        4B            PHK                       
CODE_048243:        AB            PLB                       
CODE_048244:        A2 01         LDX.B #$01                ; \ If player 1 pushes select... 
CODE_048246:        BD A6 0D      LDA.W RAM_OWControllerA,X ;  | 
CODE_048249:        29 20         AND.B #$20                ;  | ...disabled by BRA 
CODE_04824B:        80 14         BRA CODE_048261           ; / Change to BEQ to enable debug code below 

ADDR_04824D:        BD BA 0D      LDA.W RAM_PlyrYoshiColor,X ; \ Unreachable 
ADDR_048250:        1A            INC A                     ;  | Debug: Change Yoshi color 
ADDR_048251:        1A            INC A                     ;  | 
ADDR_048252:        C9 04         CMP.B #$04                ;  | 
ADDR_048254:        B0 02         BCS ADDR_048258           ;  | 
ADDR_048256:        A9 04         LDA.B #$04                ;  | 
ADDR_048258:        C9 0B         CMP.B #$0B                ;  | 
ADDR_04825A:        90 02         BCC ADDR_04825E           ;  | 
ADDR_04825C:        A9 00         LDA.B #$00                ;  | 
ADDR_04825E:        9D BA 0D      STA.W RAM_PlyrYoshiColor,X ; / 
CODE_048261:        CA            DEX                       
CODE_048262:        10 E2         BPL CODE_048246           
CODE_048264:        20 A7 85      JSR.W CODE_0485A7         
CODE_048267:        20 E0 80      JSR.W OW_Tile_Animation   
CODE_04826A:        AD D2 13      LDA.W $13D2               ; \ If "! blocks flying away color" is 0, 
CODE_04826D:        F0 06         BEQ CODE_048275           ; / don't play the animation 
CODE_04826F:        20 90 F2      JSR.W CODE_04F290         
CODE_048272:        4C 0D 84      JMP.W CODE_04840D         

CODE_048275:        AD C9 13      LDA.W $13C9               ; \ If not showing Continue/End message, 
CODE_048278:        F0 07         BEQ CODE_048281           ; / branch to $8281 
CODE_04827A:        22 80 9B 00   JSL.L CODE_009B80         
CODE_04827E:        4C 10 84      JMP.W CODE_048410         

CODE_048281:        AD 87 1B      LDA.W $1B87               
CODE_048284:        F0 0F         BEQ CODE_048295           
CODE_048286:        C9 05         CMP.B #$05                
CODE_048288:        B0 05         BCS CODE_04828F           
CODE_04828A:        AC B2 0D      LDY.W $0DB2               
CODE_04828D:        F0 06         BEQ CODE_048295           
CODE_04828F:        20 E5 F3      JSR.W CODE_04F3E5         
CODE_048292:        4C 13 84      JMP.W CODE_048413         

CODE_048295:        AD D4 13      LDA.W $13D4               
CODE_048298:        4A            LSR                       
CODE_048299:        D0 03         BNE CODE_04829E           
CODE_04829B:        4C 56 83      JMP.W CODE_048356         

CODE_04829E:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0482A0:        AD F2 1D      LDA.W $1DF2               
CODE_0482A3:        38            SEC                       
CODE_0482A4:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_0482A6:        85 01         STA $01                   
CODE_0482A8:        10 04         BPL CODE_0482AE           
CODE_0482AA:        49 FF FF      EOR.W #$FFFF              
CODE_0482AD:        1A            INC A                     
CODE_0482AE:        4A            LSR                       
CODE_0482AF:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0482B1:        85 05         STA $05                   
CODE_0482B3:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0482B5:        AD F0 1D      LDA.W $1DF0               
CODE_0482B8:        38            SEC                       
CODE_0482B9:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_0482BB:        85 00         STA $00                   
CODE_0482BD:        10 04         BPL CODE_0482C3           
ADDR_0482BF:        49 FF FF      EOR.W #$FFFF              
ADDR_0482C2:        1A            INC A                     
CODE_0482C3:        4A            LSR                       
CODE_0482C4:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0482C6:        85 04         STA $04                   
CODE_0482C8:        A2 01         LDX.B #$01                
CODE_0482CA:        C5 05         CMP $05                   
CODE_0482CC:        B0 03         BCS CODE_0482D1           
CODE_0482CE:        CA            DEX                       
CODE_0482CF:        A5 05         LDA $05                   
CODE_0482D1:        C9 02         CMP.B #$02                
CODE_0482D3:        B0 18         BCS CODE_0482ED           
CODE_0482D5:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0482D7:        AD F0 1D      LDA.W $1DF0               
CODE_0482DA:        85 1A         STA RAM_ScreenBndryXLo    
CODE_0482DC:        85 1E         STA $1E                   
CODE_0482DE:        AD F2 1D      LDA.W $1DF2               
CODE_0482E1:        85 1C         STA RAM_ScreenBndryYLo    
CODE_0482E3:        85 20         STA $20                   
CODE_0482E5:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0482E7:        9C D4 13      STZ.W $13D4               
CODE_0482EA:        4C BD 83      JMP.W CODE_0483BD         

CODE_0482ED:        9C 04 42      STZ.W $4204               ; Dividend (Low Byte)
CODE_0482F0:        B4 04         LDY $04,X                 
CODE_0482F2:        8C 05 42      STY.W $4205               ; Dividend (High-Byte)
CODE_0482F5:        8D 06 42      STA.W $4206               ; Divisor B
CODE_0482F8:        EA            NOP                       ; \ 
CODE_0482F9:        EA            NOP                       ;  | 
CODE_0482FA:        EA            NOP                       ;  |Makes you wonder what used to be here... 
CODE_0482FB:        EA            NOP                       ;  | 
CODE_0482FC:        EA            NOP                       ;  | 
CODE_0482FD:        EA            NOP                       ; / 
CODE_0482FE:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_048300:        AD 14 42      LDA.W $4214               ; Quotient of Divide Result (Low Byte)
CODE_048303:        4A            LSR                       
CODE_048304:        4A            LSR                       
CODE_048305:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_048307:        B4 01         LDY $01,X                 
CODE_048309:        10 03         BPL CODE_04830E           
ADDR_04830B:        49 FF         EOR.B #$FF                
ADDR_04830D:        1A            INC A                     
CODE_04830E:        95 01         STA $01,X                 
CODE_048310:        8A            TXA                       
CODE_048311:        49 01         EOR.B #$01                
CODE_048313:        AA            TAX                       
CODE_048314:        A9 40         LDA.B #$40                
CODE_048316:        B4 01         LDY $01,X                 
CODE_048318:        10 02         BPL CODE_04831C           
CODE_04831A:        A9 C0         LDA.B #$C0                
CODE_04831C:        95 01         STA $01,X                 
CODE_04831E:        A0 01         LDY.B #$01                
CODE_048320:        98            TYA                       
CODE_048321:        0A            ASL                       
CODE_048322:        AA            TAX                       
CODE_048323:        B9 01 00      LDA.W $0001,Y             
CODE_048326:        0A            ASL                       
CODE_048327:        0A            ASL                       
CODE_048328:        0A            ASL                       
CODE_048329:        0A            ASL                       
CODE_04832A:        18            CLC                       
CODE_04832B:        79 7C 1B      ADC.W $1B7C,Y             
CODE_04832E:        99 7C 1B      STA.W $1B7C,Y             
CODE_048331:        B9 01 00      LDA.W $0001,Y             
CODE_048334:        5A            PHY                       
CODE_048335:        08            PHP                       
CODE_048336:        4A            LSR                       
CODE_048337:        4A            LSR                       
CODE_048338:        4A            LSR                       
CODE_048339:        4A            LSR                       
CODE_04833A:        A0 00         LDY.B #$00                
CODE_04833C:        28            PLP                       
CODE_04833D:        10 03         BPL CODE_048342           
CODE_04833F:        09 F0         ORA.B #$F0                
CODE_048341:        88            DEY                       
CODE_048342:        75 1A         ADC RAM_ScreenBndryXLo,X  
CODE_048344:        95 1A         STA RAM_ScreenBndryXLo,X  
CODE_048346:        95 1E         STA $1E,X                 
CODE_048348:        98            TYA                       
CODE_048349:        75 1B         ADC RAM_ScreenBndryXHi,X  
CODE_04834B:        95 1B         STA RAM_ScreenBndryXHi,X  
CODE_04834D:        95 1F         STA $1F,X                 
CODE_04834F:        7A            PLY                       
CODE_048350:        88            DEY                       
CODE_048351:        10 CD         BPL CODE_048320           
CODE_048353:        4C 0D 84      JMP.W CODE_04840D         

CODE_048356:        AD D9 13      LDA.W $13D9               
CODE_048359:        C9 03         CMP.B #$03                
CODE_04835B:        F0 09         BEQ CODE_048366           
CODE_04835D:        C9 04         CMP.B #$04                
CODE_04835F:        D0 39         BNE CODE_04839A           
CODE_048361:        AD D8 0D      LDA.W $0DD8               
CODE_048364:        D0 34         BNE CODE_04839A           
CODE_048366:        AD A8 0D      LDA.W $0DA8               
CODE_048369:        0D A9 0D      ORA.W $0DA9               
CODE_04836C:        29 30         AND.B #$30                
CODE_04836E:        F0 05         BEQ CODE_048375           
CODE_048370:        A9 01         LDA.B #$01                
CODE_048372:        8D 87 1B      STA.W $1B87               
CODE_048375:        AE B3 0D      LDX.W $0DB3               
CODE_048378:        BD 11 1F      LDA.W $1F11,X             
CODE_04837B:        D0 1D         BNE CODE_04839A           
CODE_04837D:        A5 16         LDA $16                   
CODE_04837F:        29 10         AND.B #$10                
CODE_048381:        F0 17         BEQ CODE_04839A           
CODE_048383:        EE D4 13      INC.W $13D4               ; Look around overworld 
CODE_048386:        AD D4 13      LDA.W $13D4               
CODE_048389:        4A            LSR                       
CODE_04838A:        D0 0E         BNE CODE_04839A           
CODE_04838C:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04838E:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_048390:        8D F0 1D      STA.W $1DF0               
CODE_048393:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_048395:        8D F2 1D      STA.W $1DF2               
CODE_048398:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04839A:        AD D4 13      LDA.W $13D4               
CODE_04839D:        F0 24         BEQ CODE_0483C3           
CODE_04839F:        A2 00         LDX.B #$00                
CODE_0483A1:        A5 15         LDA RAM_ControllerA       
CODE_0483A3:        29 03         AND.B #$03                
CODE_0483A5:        0A            ASL                       
CODE_0483A6:        20 15 84      JSR.W CODE_048415         
CODE_0483A9:        A2 02         LDX.B #$02                
CODE_0483AB:        A5 15         LDA RAM_ControllerA       
CODE_0483AD:        29 0C         AND.B #$0C                
CODE_0483AF:        09 10         ORA.B #$10                
CODE_0483B1:        4A            LSR                       
CODE_0483B2:        20 15 84      JSR.W CODE_048415         
CODE_0483B5:        A0 15         LDY.B #$15                
CODE_0483B7:        A5 13         LDA RAM_FrameCounter      
CODE_0483B9:        29 18         AND.B #$18                
CODE_0483BB:        D0 02         BNE CODE_0483BF           
CODE_0483BD:        A0 18         LDY.B #$18                
CODE_0483BF:        84 12         STY $12                   
CODE_0483C1:        80 4A         BRA CODE_04840D           

CODE_0483C3:        AE A0 1B      LDX.W $1BA0               
CODE_0483C6:        F0 42         BEQ CODE_04840A           
CODE_0483C8:        E0 FE         CPX.B #$FE                
CODE_0483CA:        D0 0A         BNE CODE_0483D6           
CODE_0483CC:        A9 21         LDA.B #$21                
CODE_0483CE:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_0483D1:        A9 08         LDA.B #$08                
CODE_0483D3:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_0483D6:        8A            TXA                       
CODE_0483D7:        4A            LSR                       
CODE_0483D8:        4A            LSR                       
CODE_0483D9:        4A            LSR                       
CODE_0483DA:        4A            LSR                       
CODE_0483DB:        A8            TAY                       
CODE_0483DC:        A5 13         LDA RAM_FrameCounter      
CODE_0483DE:        39 31 82      AND.W DATA_048231,Y       
CODE_0483E1:        D0 10         BNE CODE_0483F3           
CODE_0483E3:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_0483E5:        49 01         EOR.B #$01                
CODE_0483E7:        85 1A         STA RAM_ScreenBndryXLo    
CODE_0483E9:        85 1E         STA $1E                   
CODE_0483EB:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_0483ED:        49 01         EOR.B #$01                
CODE_0483EF:        85 1C         STA RAM_ScreenBndryYLo    
CODE_0483F1:        85 20         STA $20                   
CODE_0483F3:        E0 80         CPX.B #$80                
CODE_0483F5:        B0 07         BCS CODE_0483FE           
CODE_0483F7:        AD D9 13      LDA.W $13D9               
CODE_0483FA:        C9 02         CMP.B #$02                
CODE_0483FC:        D0 0C         BNE CODE_04840A           
CODE_0483FE:        CE A0 1B      DEC.W $1BA0               
CODE_048401:        D0 0A         BNE CODE_04840D           
CODE_048403:        A9 22         LDA.B #$22                
CODE_048405:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_048408:        80 03         BRA CODE_04840D           

CODE_04840A:        20 76 85      JSR.W CODE_048576         
CODE_04840D:        20 08 F7      JSR.W CODE_04F708         
CODE_048410:        20 2E 86      JSR.W CODE_04862E         
CODE_048413:        AB            PLB                       
Return048414:       6B            RTL                       ; Return 

CODE_048415:        A8            TAY                       
CODE_048416:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_048418:        B5 1A         LDA RAM_ScreenBndryXLo,X  
CODE_04841A:        18            CLC                       
CODE_04841B:        79 11 82      ADC.W DATA_048211,Y       
CODE_04841E:        48            PHA                       
CODE_04841F:        38            SEC                       
CODE_048420:        F9 21 82      SBC.W DATA_048221,Y       
CODE_048423:        59 11 82      EOR.W DATA_048211,Y       
CODE_048426:        0A            ASL                       
CODE_048427:        68            PLA                       
CODE_048428:        90 04         BCC CODE_04842E           
CODE_04842A:        95 1A         STA RAM_ScreenBndryXLo,X  
CODE_04842C:        95 1E         STA $1E,X                 
CODE_04842E:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return048430:       60            RTS                       ; Return 


DATA_048431:                      .db $11,$00,$0A,$00,$09,$00,$0B,$00
                                  .db $12,$00,$0A,$00,$07,$00,$0A,$02
                                  .db $03,$02,$10,$04,$12,$04,$1C,$04
                                  .db $14,$04,$12,$06,$00,$02,$12,$06
                                  .db $10,$00,$17,$06,$14,$00,$1C,$06
                                  .db $14,$00,$1C,$06,$17,$06,$11,$05
                                  .db $11,$05,$14,$04,$06,$01

DATA_048467:                      .db $07,$00,$03,$00,$10,$00,$0E,$00
                                  .db $17,$00,$18,$00,$12,$00,$14,$00
                                  .db $0B,$00,$03,$00,$01,$00,$09,$00
                                  .db $09,$00,$1D,$00,$0E,$00,$18,$00
                                  .db $0F,$00,$16,$00,$10,$00,$18,$00
                                  .db $02,$00,$1D,$00,$18,$00,$13,$00
                                  .db $11,$00,$03,$00,$07,$00

DATA_04849D:                      .db $A8,$04,$38,$04,$08,$09,$28,$09
                                  .db $C8,$09,$48,$09,$28,$0D,$18,$01
                                  .db $A8,$00,$98,$00,$B8,$00,$28,$01
                                  .db $A8,$00,$78,$00,$28,$0D,$08,$04
                                  .db $78,$0D,$08,$01,$C8,$0D,$48,$01
                                  .db $C8,$0D,$48,$09,$18,$0B,$78,$0D
                                  .db $68,$02,$C8,$0D,$28,$0D

DATA_0484D3:                      .db $48,$01,$B8,$00,$38,$00,$18,$00
                                  .db $98,$00,$98,$00,$D8,$01,$78,$00
                                  .db $38,$00,$08,$01,$E8,$00,$78,$01
                                  .db $88,$01,$28,$01,$88,$01,$E8,$00
                                  .db $68,$01,$F8,$00,$88,$01,$08,$01
                                  .db $D8,$01,$38,$00,$38,$01,$88,$01
                                  .db $78,$00,$D8,$01,$D8,$01

CODE_048509:        AC B3 0D      LDY.W $0DB3               ; \ Get current player's submap 
CODE_04850C:        B9 11 1F      LDA.W $1F11,Y             ; / 
CODE_04850F:        85 01         STA $01                   ; Store it in $01 
CODE_048511:        64 00         STZ $00                   ; Store x00 in $00 
CODE_048513:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_048515:        AE D6 0D      LDX.W $0DD6               ; Set X to Current character*4 
CODE_048518:        A0 34         LDY.B #$34                ; Set Y to x34 
CODE_04851A:        B9 31 84      LDA.W DATA_048431,Y       
CODE_04851D:        45 00         EOR $00                   
CODE_04851F:        C9 00 02      CMP.W #$0200              
CODE_048522:        B0 0D         BCS CODE_048531           
CODE_048524:        DD 1F 1F      CMP.W $1F1F,X             
CODE_048527:        D0 08         BNE CODE_048531           
CODE_048529:        BD 21 1F      LDA.W $1F21,X             
CODE_04852C:        D9 67 84      CMP.W DATA_048467,Y       
CODE_04852F:        F0 04         BEQ CODE_048535           
CODE_048531:        88            DEY                       
CODE_048532:        88            DEY                       
CODE_048533:        10 E5         BPL CODE_04851A           
CODE_048535:        8C F6 1D      STY.W $1DF6               ; Store Y in "Warp destination" 
CODE_048538:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
Return04853A:       60            RTS                       ; Return 

CODE_04853B:        8B            PHB                       
CODE_04853C:        4B            PHK                       
CODE_04853D:        AB            PLB                       
CODE_04853E:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_048540:        AE D6 0D      LDX.W $0DD6               
CODE_048543:        AC F6 1D      LDY.W $1DF6               
CODE_048546:        B9 9D 84      LDA.W DATA_04849D,Y       
CODE_048549:        48            PHA                       
CODE_04854A:        29 FF 01      AND.W #$01FF              
CODE_04854D:        9D 17 1F      STA.W $1F17,X             
CODE_048550:        4A            LSR                       
CODE_048551:        4A            LSR                       
CODE_048552:        4A            LSR                       
CODE_048553:        4A            LSR                       
CODE_048554:        9D 1F 1F      STA.W $1F1F,X             
CODE_048557:        B9 D3 84      LDA.W DATA_0484D3,Y       
CODE_04855A:        9D 19 1F      STA.W $1F19,X             
CODE_04855D:        4A            LSR                       
CODE_04855E:        4A            LSR                       
CODE_04855F:        4A            LSR                       
CODE_048560:        4A            LSR                       
CODE_048561:        9D 21 1F      STA.W $1F21,X             
CODE_048564:        68            PLA                       
CODE_048565:        4A            LSR                       
CODE_048566:        EB            XBA                       
CODE_048567:        29 0F 00      AND.W #$000F              
CODE_04856A:        8D C3 13      STA.W $13C3               
CODE_04856D:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_04856F:        20 93 9A      JSR.W CODE_049A93         
CODE_048572:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_048574:        AB            PLB                       
Return048575:       6B            RTL                       ; Return 

CODE_048576:        AD D9 13      LDA.W $13D9               
CODE_048579:        22 FA 86 00   JSL.L ExecutePtrLong      

PtrsLong04857D:        F1 8E 04   .dw CODE_048EF1 .db :$CODE_048EF1 
                       70 E5 04   .dw CODE_04E570 .db :$CODE_04E570 
                       87 8F 04   .dw CODE_048F87 .db :$CODE_048F87 
                       20 91 04   .dw CODE_049120 .db :$CODE_049120 
                       5D 94 04   .dw CODE_04945D .db :$CODE_04945D 
                       9A 9D 04   .dw CODE_049D9A .db :$CODE_049D9A 
                       22 9E 04   .dw CODE_049E22 .db :$CODE_049E22 
                       D1 9D 04   .dw CODE_049DD1 .db :$CODE_049DD1 
                       22 9E 04   .dw CODE_049E22 .db :$CODE_049E22 
                       4C 9E 04   .dw CODE_049E4C .db :$CODE_049E4C 
                       EF DA 04   .dw CODE_04DAEF .db :$CODE_04DAEF 
                       52 9E 04   .dw CODE_049E52 .db :$CODE_049E52 
                       C6 98 04   .dw CODE_0498C6 .db :$CODE_0498C6 

DrawOWBoarder?:     20 2E 86      JSR.W CODE_04862E         
CODE_0485A7:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0485A9:        A9 1E 00      LDA.W #$001E              ; \ Mario X postion = #$001E 
CODE_0485AC:        18            CLC                       ;  | (On overworld boarder) 
CODE_0485AD:        65 1A         ADC RAM_ScreenBndryXLo    ;  | 
CODE_0485AF:        85 94         STA RAM_MarioXPos         ; / 
CODE_0485B1:        A9 06 00      LDA.W #$0006              ; \ Mario Y postion = #$0006 
CODE_0485B4:        18            CLC                       ;  | (On overworld boarder) 
CODE_0485B5:        65 1C         ADC RAM_ScreenBndryYLo    ;  | 
CODE_0485B7:        85 96         STA RAM_MarioYPos         ; / 
CODE_0485B9:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0485BB:        A9 08         LDA.B #$08                
CODE_0485BD:        8D 7B 00      STA.W RAM_MarioSpeedX     
CODE_0485C0:        8B            PHB                       
CODE_0485C1:        A9 00         LDA.B #$00                
CODE_0485C3:        48            PHA                       
CODE_0485C4:        AB            PLB                       
CODE_0485C5:        22 B1 CE 00   JSL.L CODE_00CEB1         
CODE_0485C9:        AB            PLB                       
CODE_0485CA:        A9 03         LDA.B #$03                
CODE_0485CC:        8D F9 13      STA.W RAM_IsBehindScenery 
CODE_0485CF:        22 BD E2 00   JSL.L CODE_00E2BD         
CODE_0485D3:        A9 06         LDA.B #$06                
CODE_0485D5:        8D 84 0D      STA.W $0D84               
CODE_0485D8:        AD 96 14      LDA.W $1496               
CODE_0485DB:        F0 03         BEQ CODE_0485E0           
CODE_0485DD:        CE 96 14      DEC.W $1496               
CODE_0485E0:        AD A2 14      LDA.W $14A2               
CODE_0485E3:        F0 03         BEQ CODE_0485E8           
CODE_0485E5:        CE A2 14      DEC.W $14A2               
CODE_0485E8:        A9 18         LDA.B #$18                
CODE_0485EA:        85 00         STA $00                   
CODE_0485EC:        A9 07         LDA.B #$07                
CODE_0485EE:        85 01         STA $01                   
CODE_0485F0:        A0 00         LDY.B #$00                
CODE_0485F2:        BB            TYX                       
CODE_0485F3:        A5 00         LDA $00                   
CODE_0485F5:        9D 00 02      STA.W OAM_ExtendedDispX,X 
CODE_0485F8:        18            CLC                       
CODE_0485F9:        69 08         ADC.B #$08                
CODE_0485FB:        85 00         STA $00                   
CODE_0485FD:        A5 01         LDA $01                   
CODE_0485FF:        9D 01 02      STA.W OAM_ExtendedDispY,X 
CODE_048602:        A9 7E         LDA.B #$7E                
CODE_048604:        9D 02 02      STA.W OAM_ExtendedTile,X  
CODE_048607:        A9 36         LDA.B #$36                
CODE_048609:        9D 03 02      STA.W OAM_ExtendedProp,X  
CODE_04860C:        DA            PHX                       
CODE_04860D:        BB            TYX                       
CODE_04860E:        A9 00         LDA.B #$00                
CODE_048610:        9D 20 04      STA.W $0420,X             
CODE_048613:        FA            PLX                       
CODE_048614:        C8            INY                       
CODE_048615:        98            TYA                       
CODE_048616:        29 03         AND.B #$03                
CODE_048618:        D0 0B         BNE CODE_048625           
CODE_04861A:        A9 18         LDA.B #$18                
CODE_04861C:        85 00         STA $00                   
CODE_04861E:        A5 01         LDA $01                   
CODE_048620:        18            CLC                       
CODE_048621:        69 08         ADC.B #$08                
CODE_048623:        85 01         STA $01                   
CODE_048625:        E8            INX                       
CODE_048626:        E8            INX                       
CODE_048627:        E8            INX                       
CODE_048628:        E8            INX                       
CODE_048629:        C0 10         CPY.B #$10                
CODE_04862B:        D0 C6         BNE CODE_0485F3           
Return04862D:       60            RTS                       ; Return 

CODE_04862E:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_048630:        AE D6 0D      LDX.W $0DD6               ; X = player x 4
CODE_048633:        BD 17 1F      LDA.W $1F17,X             ; A = player X-pos on OW
CODE_048636:        38            SEC                       ; 
CODE_048637:        E5 1A         SBC RAM_ScreenBndryXLo    ; A = X-pos on screen
CODE_048639:        C9 00 01      CMP.W #$0100              ; 
CODE_04863C:        B0 0F         BCS CODE_04864D           ; \ if < #$0100
CODE_04863E:        85 00         STA $00                   ; | $00 = X-pos on screen
CODE_048640:        85 08         STA $08                   ; | $08 = X-pos on screen
CODE_048642:        BD 19 1F      LDA.W $1F19,X             ; | A = player Y-pos on OW
CODE_048645:        38            SEC                       ; |
CODE_048646:        E5 1C         SBC RAM_ScreenBndryYLo    ; | A = Y-pos on screen
CODE_048648:        C9 00 01      CMP.W #$0100              ; |
CODE_04864B:        90 03         BCC CODE_048650           ; /
CODE_04864D:        A9 F0 00      LDA.W #$00F0              ; \ 
CODE_048650:        85 02         STA $02                   ; | $02 = Y-pos on screen
CODE_048652:        85 0A         STA $0A                   ; / $0A = Y-pos on screen
CODE_048654:        8A            TXA                       ; A = player x 4
CODE_048655:        49 04 00      EOR.W #$0004              ; A = other player x 4
CODE_048658:        AA            TAX                       ; X = other player x 4
CODE_048659:        BD 17 1F      LDA.W $1F17,X             ; \
CODE_04865C:        38            SEC                       ; | (same as above, but for luigi)
CODE_04865D:        E5 1A         SBC RAM_ScreenBndryXLo    ; |
CODE_04865F:        C9 00 01      CMP.W #$0100              ; |
CODE_048662:        B0 0F         BCS CODE_048673           ; |
CODE_048664:        85 04         STA $04                   ; | $04 = X-pos on screen
CODE_048666:        85 0C         STA $0C                   ; | $0C = X-pos on screen
CODE_048668:        BD 19 1F      LDA.W $1F19,X             ; |
CODE_04866B:        38            SEC                       ; |
CODE_04866C:        E5 1C         SBC RAM_ScreenBndryYLo    ; |
CODE_04866E:        C9 00 01      CMP.W #$0100              ; |
CODE_048671:        90 03         BCC CODE_048676           ; |
CODE_048673:        A9 F0 00      LDA.W #$00F0              ; |
CODE_048676:        85 06         STA $06                   ; | $06 = Y-pos on screen
CODE_048678:        85 0E         STA $0E                   ; / $0E = Y-pos on screen
CODE_04867A:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04867C:        A5 00         LDA $00                   
CODE_04867E:        38            SEC                       
CODE_04867F:        E9 08         SBC.B #$08                ; subtract 8 from 1P X-pos
CODE_048681:        85 00         STA $00                   ; $00 = 1P X-pos on screen
CODE_048683:        A5 02         LDA $02                   
CODE_048685:        38            SEC                       
CODE_048686:        E9 09         SBC.B #$09                ; subtract 9 from 1P Y-pos
CODE_048688:        85 01         STA $01                   ; $01 = 1P Y-pos on screen
CODE_04868A:        A5 04         LDA $04                   
CODE_04868C:        38            SEC                       
CODE_04868D:        E9 08         SBC.B #$08                ; subtract 8 from 2P X-pos
CODE_04868F:        85 02         STA $02                   ; $02 = 2P X-pos on screen
CODE_048691:        A5 06         LDA $06                   
CODE_048693:        38            SEC                       
CODE_048694:        E9 09         SBC.B #$09                ; subtract 9 from 2P Y-pos
CODE_048696:        85 03         STA $03                   ; $03 = 2P Y-pos on screen
CODE_048698:        A9 03         LDA.B #$03                
CODE_04869A:        85 8C         STA $8C                   ; $8C = #$03
CODE_04869C:        A5 00         LDA $00                   
CODE_04869E:        85 06         STA $06                   ; $06 = 1P X-pos on screen
CODE_0486A0:        85 8A         STA $8A                   ; $8A = 1P X-pos on screen
CODE_0486A2:        A5 01         LDA $01                   
CODE_0486A4:        85 07         STA $07                   ; $07 = 1P Y-pos on screen
CODE_0486A6:        85 8B         STA $8B                   ; $8B = 1P Y-pos on screen
CODE_0486A8:        AD D6 0D      LDA.W $0DD6               ; A = player x 4
CODE_0486AB:        4A            LSR                       ; A = player x 2
CODE_0486AC:        A8            TAY                       ; Y = player x 2
CODE_0486AD:        B9 13 1F      LDA.W $1F13,Y             ; A = player OW animation type
CODE_0486B0:        C9 12         CMP.B #$12                
CODE_0486B2:        F0 11         BEQ CODE_0486C5           ; skip if enter level in water animation
CODE_0486B4:        C9 07         CMP.B #$07                
CODE_0486B6:        90 04         BCC CODE_0486BC           ; don't skip if moving on land
CODE_0486B8:        C9 0F         CMP.B #$0F                
CODE_0486BA:        90 09         BCC CODE_0486C5           ; skip if moving in water
CODE_0486BC:        A5 8B         LDA $8B                   
CODE_0486BE:        38            SEC                       
CODE_0486BF:        E9 05         SBC.B #$05                ; subtract 5 from Y-pos if on land
CODE_0486C1:        85 8B         STA $8B                   ; $8B = 1P Y-pos on screen
CODE_0486C3:        85 07         STA $07                   ; $07 = 1P Y-pos on screen
CODE_0486C5:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_0486C7:        AD D6 0D      LDA.W $0DD6               ; A = player x 4
CODE_0486CA:        EB            XBA                       ; A = player x #$400
CODE_0486CB:        4A            LSR                       ; A = player x #$200
CODE_0486CC:        85 04         STA $04                   ; $04 = player x #$200
CODE_0486CE:        A2 00 00      LDX.W #$0000              ; X = #$0000
CODE_0486D1:        20 89 87      JSR.W CODE_048789         ; draw halo if out of lives
CODE_0486D4:        AD D6 0D      LDA.W $0DD6               ; A = player x 4
CODE_0486D7:        4A            LSR                       ; A = player x 2
CODE_0486D8:        A8            TAY                       ; Y = player x 2
CODE_0486D9:        A2 00 00      LDX.W #$0000              ; X = #$0000
CODE_0486DC:        20 4F 89      JSR.W CODE_04894F         
CODE_0486DF:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_0486E1:        9C 47 04      STZ.W $0447               ; \
CODE_0486E4:        9C 48 04      STZ.W $0448               ; | make OAM tiles 8x8
CODE_0486E7:        9C 49 04      STZ.W $0449               ; |
CODE_0486EA:        9C 4A 04      STZ.W $044A               ; |
CODE_0486ED:        9C 4B 04      STZ.W $044B               ; |
CODE_0486F0:        9C 4C 04      STZ.W $044C               ; |
CODE_0486F3:        9C 4D 04      STZ.W $044D               ; |
CODE_0486F6:        9C 4E 04      STZ.W $044E               ; /
CODE_0486F9:        A9 03         LDA.B #$03                
CODE_0486FB:        85 8C         STA $8C                   ; $8C = #$03
CODE_0486FD:        AD 11 1F      LDA.W $1F11               ; A = 1P submap
CODE_048700:        AC D9 13      LDY.W $13D9               ; Y = overworld process
CODE_048703:        C0 0A         CPY.B #$0A                
CODE_048705:        D0 02         BNE CODE_048709           
CODE_048707:        49 01         EOR.B #$01                ; ??
CODE_048709:        CD 12 1F      CMP.W $1F12               
CODE_04870C:        D0 78         BNE CODE_048786           ; skip everything if 1P and 2P are on different submaps
CODE_04870E:        A5 02         LDA $02                   
CODE_048710:        85 06         STA $06                   ; $06 = 2P X-pos on screen
CODE_048712:        85 8A         STA $8A                   ; $8A = 2P X-pos on screen
CODE_048714:        A5 03         LDA $03                   
CODE_048716:        85 07         STA $07                   ; $07 = 2P Y-pos on screen
CODE_048718:        85 8B         STA $8B                   ; $8B = 2P Y-pos on screen
CODE_04871A:        AD D6 0D      LDA.W $0DD6               ; A = player x 4
CODE_04871D:        4A            LSR                       ; A = player x 2
CODE_04871E:        49 02         EOR.B #$02                ; A = other player x 2
CODE_048720:        A8            TAY                       ; Y = other player x 2
CODE_048721:        B9 13 1F      LDA.W $1F13,Y             ; A = other player OW animation type
CODE_048724:        C9 12         CMP.B #$12                
CODE_048726:        F0 11         BEQ CODE_048739           ; skip if enter level in water animation
CODE_048728:        C9 07         CMP.B #$07                
CODE_04872A:        90 04         BCC CODE_048730           ; don't skip if moving on land
CODE_04872C:        C9 0F         CMP.B #$0F                
CODE_04872E:        90 09         BCC CODE_048739           ; skip if moving in water
CODE_048730:        A5 8B         LDA $8B                   
CODE_048732:        38            SEC                       
CODE_048733:        E9 05         SBC.B #$05                ; subtract 5 from Y-pos if on land
CODE_048735:        85 8B         STA $8B                   ; $8B = 2P Y-pos on screen
CODE_048737:        85 07         STA $07                   ; $07 = 2P Y-pos on screen
CODE_048739:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04873B:        AD B2 0D      LDA.W $0DB2               
CODE_04873E:        29 FF 00      AND.W #$00FF              
CODE_048741:        F0 43         BEQ CODE_048786           ; skip everything if we are in a 1P-game (why check that so late?)
CODE_048743:        A5 0C         LDA $0C                   
CODE_048745:        C9 F0 00      CMP.W #$00F0              
CODE_048748:        B0 3C         BCS CODE_048786           ; skip if 2P is offscreen in the X direction
CODE_04874A:        A5 0E         LDA $0E                   
CODE_04874C:        C9 F0 00      CMP.W #$00F0              
CODE_04874F:        B0 35         BCS CODE_048786           ; skip if 2P is offscreen in the Y direction
CODE_048751:        A5 04         LDA $04                   ; A = player x #$200
CODE_048753:        49 00 02      EOR.W #$0200              ; A = other player x #$200
CODE_048756:        85 04         STA $04                   ; $04 = other player x #$200
CODE_048758:        A2 20 00      LDX.W #$0020              ; X = #$0020
CODE_04875B:        20 89 87      JSR.W CODE_048789         ; draw halo if out of lives
CODE_04875E:        AD D6 0D      LDA.W $0DD6               ; A = player x 4
CODE_048761:        4A            LSR                       ; A = player x 2
CODE_048762:        49 02 00      EOR.W #$0002              ; A = other player x 2
CODE_048765:        A8            TAY                       ; Y = other player x 2
CODE_048766:        A2 20 00      LDX.W #$0020              ; X = #$0020
CODE_048769:        20 4F 89      JSR.W CODE_04894F         
CODE_04876C:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04876E:        9C 4F 04      STZ.W $044F               ; \
CODE_048771:        9C 50 04      STZ.W $0450               ; | make OAM tiles 8x8
CODE_048774:        9C 51 04      STZ.W $0451               ; |
CODE_048777:        9C 52 04      STZ.W $0452               ; |
CODE_04877A:        9C 53 04      STZ.W $0453               ; |
CODE_04877D:        9C 54 04      STZ.W $0454               ; |
CODE_048780:        9C 55 04      STZ.W $0455               ; |
CODE_048783:        9C 56 04      STZ.W $0456               ; /
CODE_048786:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return048788:       60            RTS                       ; Return 

CODE_048789:        A5 8A         LDA $8A                   ; A = Y-pos on screen | X-pos on screen
CODE_04878B:        48            PHA                       
CODE_04878C:        DA            PHX                       ; X = player x #$20
CODE_04878D:        A5 04         LDA $04                   ; A = player x #$200
CODE_04878F:        EB            XBA                       ; A = player x 2
CODE_048790:        4A            LSR                       ; A = player
CODE_048791:        AA            TAX                       ; X = player
CODE_048792:        BD B3 0D      LDA.W $0DB3,X             ; A = player lives | junk
CODE_048795:        FA            PLX                       ; X = player x #$20
CODE_048796:        29 00 FF      AND.W #$FF00              ; A = player lives | #$00
CODE_048799:        10 2C         BPL CODE_0487C7           ; skip if player lives positive
CODE_04879B:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04879D:        A5 8A         LDA $8A                   
CODE_04879F:        9D B4 02      STA.W $02B4,X             ; OAM X-pos of 1st halo tile
CODE_0487A2:        18            CLC                       
CODE_0487A3:        69 08         ADC.B #$08                
CODE_0487A5:        9D B8 02      STA.W $02B8,X             ; OAM X-pos of 2nd halo tile
CODE_0487A8:        A5 8B         LDA $8B                   
CODE_0487AA:        18            CLC                       
CODE_0487AB:        69 F9         ADC.B #$F9                
CODE_0487AD:        9D B5 02      STA.W $02B5,X             ; OAM Y-pos of 1st halo tile
CODE_0487B0:        9D B9 02      STA.W $02B9,X             ; OAM Y-pos of 2nd halo tile
CODE_0487B3:        A9 7C         LDA.B #$7C                
CODE_0487B5:        9D B6 02      STA.W $02B6,X             ; OAM tile number of 1st halo tile
CODE_0487B8:        9D BA 02      STA.W $02BA,X             ; OAM tile number of 2nd halo tile
CODE_0487BB:        A9 20         LDA.B #$20                
CODE_0487BD:        9D B7 02      STA.W $02B7,X             ; OAM yxppccct of 1st halo tile
CODE_0487C0:        A9 60         LDA.B #$60                
CODE_0487C2:        9D BB 02      STA.W $02BB,X             ; OAM yxppccct of 2nd halo tile
CODE_0487C5:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0487C7:        68            PLA                       ; A = Y-pos on screen | X-pos on screen
CODE_0487C8:        85 8A         STA $8A                   ; $8A = X-pos on screen, $8B = Y-pos on screen
Return0487CA:       60            RTS                       ; Return 


OWPlayerTiles:                    .db $0E,$24,$0F,$24,$1E,$24,$1F,$24
                                  .db $20,$24,$21,$24,$30,$24,$31,$24
                                  .db $0E,$24,$0F,$24,$1E,$24,$1F,$24
                                  .db $20,$24,$21,$24,$31,$64,$30,$64
                                  .db $0A,$24,$0B,$24,$1A,$24,$1B,$24
                                  .db $0C,$24,$0D,$24,$1C,$24,$1D,$24
                                  .db $0A,$24,$0B,$24,$1A,$24,$1B,$24
                                  .db $0C,$24,$0D,$24,$1D,$64,$1C,$64
                                  .db $08,$24,$09,$24,$18,$24,$19,$24
                                  .db $06,$24,$07,$24,$16,$24,$17,$24
                                  .db $08,$24,$09,$24,$18,$24,$19,$24
                                  .db $06,$24,$07,$24,$16,$24,$17,$24
                                  .db $09,$64,$08,$64,$19,$64,$18,$64
                                  .db $07,$64,$06,$64,$17,$64,$16,$64
                                  .db $09,$64,$08,$64,$19,$64,$18,$64
                                  .db $07,$64,$06,$64,$17,$64,$16,$64
                                  .db $0E,$24,$0F,$24,$38,$24,$38,$64
                                  .db $20,$24,$21,$24,$39,$24,$39,$64
                                  .db $0E,$24,$0F,$24,$38,$24,$38,$64
                                  .db $20,$24,$21,$24,$39,$24,$39,$64
                                  .db $0A,$24,$0B,$24,$38,$24,$38,$64
                                  .db $0C,$24,$0D,$24,$39,$24,$39,$64
                                  .db $0A,$24,$0B,$24,$38,$24,$38,$64
                                  .db $0C,$24,$0D,$24,$39,$24,$39,$64
                                  .db $08,$24,$09,$24,$38,$24,$38,$64
                                  .db $06,$24,$07,$24,$39,$24,$39,$64
                                  .db $08,$24,$09,$24,$38,$24,$38,$64
                                  .db $06,$24,$07,$24,$39,$24,$39,$64
                                  .db $09,$64,$08,$64,$38,$24,$38,$64
                                  .db $07,$64,$06,$64,$39,$24,$39,$64
                                  .db $09,$64,$08,$64,$38,$24,$38,$64
                                  .db $07,$64,$06,$64,$39,$24,$39,$64
                                  .db $24,$24,$25,$24,$34,$24,$35,$24
                                  .db $24,$24,$25,$24,$34,$24,$35,$24
                                  .db $24,$24,$25,$24,$34,$24,$35,$24
                                  .db $24,$24,$25,$24,$34,$24,$35,$24
                                  .db $24,$24,$25,$24,$38,$24,$38,$64
                                  .db $24,$24,$25,$24,$38,$24,$38,$64
                                  .db $24,$24,$25,$24,$38,$24,$38,$64
                                  .db $24,$24,$25,$24,$38,$24,$38,$64
                                  .db $46,$24,$47,$24,$56,$24,$57,$24
                                  .db $47,$64,$46,$64,$57,$64,$56,$64
                                  .db $46,$24,$47,$24,$56,$24,$57,$24
                                  .db $47,$64,$46,$64,$57,$64,$56,$64
                                  .db $46,$24,$47,$24,$56,$24,$57,$24
                                  .db $47,$64,$46,$64,$57,$64,$56,$64
                                  .db $46,$24,$47,$24,$56,$24,$57,$24
                                  .db $47,$64,$46,$64,$57,$64,$56,$64
OWWarpIndex:                      .db $20,$60,$00,$40

CODE_04894F:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_048951:        5A            PHY                       ; Y = player x 2
CODE_048952:        98            TYA                       ; A = player x 2
CODE_048953:        4A            LSR                       ; A = player
CODE_048954:        A8            TAY                       ; Y = player
CODE_048955:        B9 BA 0D      LDA.W RAM_PlyrYoshiColor,Y; A = player's yoshi color
CODE_048958:        F0 08         BEQ CODE_048962           ; branch if no yoshi
CODE_04895A:        85 0E         STA $0E                   ; $0E = player's yoshi color
CODE_04895C:        64 0F         STZ $0F                   ; $0F = #$00
CODE_04895E:        7A            PLY                       ; Y = player x 2
CODE_04895F:        4C E6 8C      JMP.W CODE_048CE6         ; jump

CODE_048962:        7A            PLY                       ; Y = player x 2
CODE_048963:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_048965:        B9 13 1F      LDA.W $1F13,Y             ; A = player OW animation type
CODE_048968:        0A            ASL                       
CODE_048969:        0A            ASL                       
CODE_04896A:        0A            ASL                       
CODE_04896B:        0A            ASL                       ; A = player OW animation type x #$10
CODE_04896C:        85 00         STA $00                   ; $00 = player OW animation type x #$10
CODE_04896E:        A5 13         LDA RAM_FrameCounter      ; A = frame counter
CODE_048970:        29 18 00      AND.W #$0018              ; A = 5 LSB of frame counter
CODE_048973:        18            CLC                       
CODE_048974:        65 00         ADC $00                   ; A = 0000 000a aaaf ffff (a = animation type, f = 5 LSB of frame counter)
CODE_048976:        A8            TAY                       ; Y = that index ^
CODE_048977:        DA            PHX                       ; X = player x #$20
CODE_048978:        A5 04         LDA $04                   ; A = player x #$200
CODE_04897A:        EB            XBA                       ; A = player x 2
CODE_04897B:        4A            LSR                       ; A = player
CODE_04897C:        AA            TAX                       ; X = player
CODE_04897D:        BD B3 0D      LDA.W $0DB3,X             ; A = player's lives | junk
CODE_048980:        FA            PLX                       ; X = player x #$20
CODE_048981:        29 00 FF      AND.W #$FF00              ; A = player's lives | #$00
CODE_048984:        10 05         BPL CODE_04898B           ; branch if player's lives positive
CODE_048986:        A5 00         LDA $00                   ; A = player OW animation type x #$10
CODE_048988:        A8            TAY                       ; Y = player OW animation type x #$10
CODE_048989:        80 1C         BRA CODE_0489A7           ; branch (basically, if player is out of lives, their sprite is static)

CODE_04898B:        E0 00 00      CPX.W #$0000              
CODE_04898E:        D0 17         BNE CODE_0489A7           ; skip if 2P
CODE_048990:        AD D9 13      LDA.W $13D9               
CODE_048993:        C9 0B 00      CMP.W #$000B              
CODE_048996:        D0 0F         BNE CODE_0489A7           ; skip if not on star warp
CODE_048998:        A5 13         LDA RAM_FrameCounter      ; A = frame counter
CODE_04899A:        29 0C 00      AND.W #$000C              ; A = 0000 ff00 (f = frame counter bits)
CODE_04899D:        4A            LSR                       
CODE_04899E:        4A            LSR                       ; A = 2 LSB of frame counter / 4
CODE_04899F:        A8            TAY                       ; Y = 2 LSB of frame counter / 4
CODE_0489A0:        B9 4B 89      LDA.W OWWarpIndex,Y       ; A = index to use when using a star warp (overrides that complicated thing)
CODE_0489A3:        29 FF 00      AND.W #$00FF              
CODE_0489A6:        A8            TAY                       ; Y = index into tilemap table
CODE_0489A7:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0489A9:        A5 8A         LDA $8A                   ; A = Y-pos on screen | X-pos on screen 
CODE_0489AB:        9D 9C 02      STA.W $029C,X             ; OAM y-pos and x-pos for tile
CODE_0489AE:        B9 CB 87      LDA.W OWPlayerTiles,Y     ; get tile | yxppccct
CODE_0489B1:        18            CLC                       
CODE_0489B2:        65 04         ADC $04                   ; add player x #$200 (increment palette of tile by 1)
CODE_0489B4:        9D 9E 02      STA.W $029E,X             ; OAM tile and yxppccct for tile
CODE_0489B7:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0489B9:        E8            INX                       
CODE_0489BA:        E8            INX                       
CODE_0489BB:        E8            INX                       
CODE_0489BC:        E8            INX                       ; increment X to next OAM tile
CODE_0489BD:        C8            INY                       
CODE_0489BE:        C8            INY                       ; increment index to tilemap table
CODE_0489BF:        A5 8A         LDA $8A                   
CODE_0489C1:        18            CLC                       
CODE_0489C2:        69 08         ADC.B #$08                ; \
CODE_0489C4:        85 8A         STA $8A                   ; | update X and Y position of tile
CODE_0489C6:        C6 8C         DEC $8C                   ; | (zig zag pattern)
CODE_0489C8:        A5 8C         LDA $8C                   ; |
CODE_0489CA:        29 01         AND.B #$01                ; |
CODE_0489CC:        F0 0B         BEQ CODE_0489D9           ; |
CODE_0489CE:        A5 06         LDA $06                   ; |
CODE_0489D0:        85 8A         STA $8A                   ; |
CODE_0489D2:        A5 8B         LDA $8B                   ; |
CODE_0489D4:        18            CLC                       ; |
CODE_0489D5:        69 08         ADC.B #$08                ; |
CODE_0489D7:        85 8B         STA $8B                   ; /
CODE_0489D9:        A5 8C         LDA $8C                   
CODE_0489DB:        10 CA         BPL CODE_0489A7           ; loop if we have tiles left
Return0489DD:       60            RTS                       ; Return 


DATA_0489DE:                      .db $66,$24,$67,$24,$76,$24,$77,$24
                                  .db $2F,$62,$2E,$62,$3F,$62,$3E,$62
                                  .db $66,$24,$67,$24,$76,$24,$77,$24
                                  .db $2E,$22,$2F,$22,$3E,$22,$3F,$22
                                  .db $2F,$62,$2E,$62,$3F,$62,$3E,$62
                                  .db $0A,$24,$0B,$24,$1A,$24,$1B,$24
                                  .db $2E,$22,$2F,$22,$3E,$22,$3F,$22
                                  .db $0A,$24,$0B,$24,$1A,$24,$1B,$24
                                  .db $64,$24,$65,$24,$74,$24,$75,$24
                                  .db $40,$22,$41,$22,$50,$22,$51,$22
                                  .db $64,$24,$65,$24,$74,$24,$75,$24
                                  .db $42,$22,$43,$24,$52,$24,$53,$24
                                  .db $65,$64,$64,$64,$75,$64,$74,$64
                                  .db $41,$62,$40,$62,$51,$62,$50,$62
                                  .db $65,$64,$64,$64,$75,$64,$74,$64
                                  .db $43,$62,$42,$62,$53,$62,$52,$62
                                  .db $38,$24,$38,$64,$66,$24,$67,$24
                                  .db $76,$24,$77,$24,$FF,$FF,$FF,$FF
                                  .db $39,$24,$39,$64,$66,$24,$67,$24
                                  .db $76,$24,$77,$24,$FF,$FF,$FF,$FF
                                  .db $38,$24,$38,$64,$2F,$62,$2E,$62
                                  .db $0A,$24,$0B,$24,$1A,$24,$1B,$24
                                  .db $39,$24,$39,$24,$2E,$22,$2F,$22
                                  .db $0A,$24,$0B,$24,$1A,$24,$1B,$24
                                  .db $38,$24,$38,$64,$64,$24,$65,$24
                                  .db $74,$24,$75,$24,$40,$22,$41,$22
                                  .db $39,$24,$39,$64,$64,$24,$65,$24
                                  .db $74,$24,$75,$24,$42,$22,$42,$22
                                  .db $38,$24,$38,$64,$65,$64,$64,$64
                                  .db $75,$64,$74,$64,$41,$62,$40,$62
                                  .db $39,$24,$39,$64,$65,$64,$64,$64
                                  .db $75,$64,$74,$64,$43,$62,$42,$62
                                  .db $2F,$62,$2E,$62,$3F,$62,$3E,$62
                                  .db $24,$24,$25,$24,$34,$24,$35,$24
                                  .db $2E,$22,$2F,$22,$3E,$22,$3F,$22
                                  .db $24,$24,$25,$24,$34,$24,$35,$24
                                  .db $38,$24,$38,$64,$2F,$62,$2E,$62
                                  .db $24,$24,$25,$24,$34,$24,$35,$24
                                  .db $39,$24,$39,$64,$2E,$22,$2F,$22
                                  .db $24,$24,$25,$24,$34,$24,$35,$24
                                  .db $66,$24,$67,$24,$76,$24,$77,$24
                                  .db $2F,$62,$2E,$62,$3F,$62,$3E,$62
                                  .db $66,$24,$67,$24,$76,$24,$77,$24
                                  .db $2E,$22,$2F,$22,$3E,$22,$3F,$22
                                  .db $66,$24,$67,$24,$76,$24,$77,$24
                                  .db $2F,$62,$2E,$62,$3F,$62,$3E,$62
                                  .db $66,$24,$67,$24,$76,$24,$77,$24
                                  .db $2E,$22,$2F,$22,$3E,$22,$3F,$22
DATA_048B5E:                      .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $07,$0F,$07,$0F,$00,$08,$00,$08
                                  .db $07,$0F,$07,$0F,$00,$08,$00,$08
                                  .db $F9,$01,$F9,$01,$00,$08,$00,$08
                                  .db $F9,$01,$F9,$01,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$07,$0F,$07,$0F,$00,$08
                                  .db $00,$08,$07,$0F,$07,$0F,$00,$08
                                  .db $00,$08,$F9,$01,$F9,$01,$00,$08
                                  .db $00,$08,$F9,$01,$F9,$01,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
DATA_048C1E:                      .db $FB,$FB,$03,$03,$00,$00,$08,$08
                                  .db $FA,$FA,$02,$02,$00,$00,$08,$08
                                  .db $00,$00,$08,$08,$F8,$F8,$00,$00
                                  .db $00,$00,$08,$08,$F9,$F9,$01,$01
                                  .db $FC,$FC,$04,$04,$00,$00,$08,$08
                                  .db $FB,$FB,$03,$03,$00,$00,$08,$08
                                  .db $FC,$FC,$04,$04,$00,$00,$08,$08
                                  .db $FB,$FB,$03,$03,$00,$00,$08,$08
                                  .db $08,$08,$FB,$FB,$03,$03,$00,$00
                                  .db $08,$08,$FA,$FA,$02,$02,$00,$00
                                  .db $08,$08,$00,$00,$F8,$F8,$00,$00
                                  .db $08,$08,$00,$00,$F9,$F9,$01,$01
                                  .db $08,$08,$FC,$FC,$04,$04,$00,$00
                                  .db $08,$08,$FB,$FB,$03,$03,$00,$00
                                  .db $08,$08,$FC,$FC,$04,$04,$00,$00
                                  .db $08,$08,$FB,$FB,$03,$03,$00,$00
                                  .db $00,$00,$08,$08,$F8,$F8,$00,$00
                                  .db $00,$00,$08,$08,$F8,$F8,$00,$00
                                  .db $08,$08,$00,$00,$F8,$F8,$00,$00
                                  .db $08,$08,$00,$00,$F8,$F8,$00,$00
                                  .db $FB,$FB,$03,$03,$00,$00,$08,$08
                                  .db $FA,$FA,$02,$02,$00,$00,$08,$08
                                  .db $FB,$FB,$03,$03,$00,$00,$08,$08
                                  .db $FA,$FA,$02,$02,$00,$00,$08,$08
DATA_048CDE:                      .db $00,$00,$00,$02,$00,$04,$00,$06

CODE_048CE6:        A9 07         LDA.B #$07                
CODE_048CE8:        85 8C         STA $8C                   ; $8C = #$07
CODE_048CEA:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_048CEC:        B9 13 1F      LDA.W $1F13,Y             
CODE_048CEF:        0A            ASL                       
CODE_048CF0:        0A            ASL                       
CODE_048CF1:        0A            ASL                       
CODE_048CF2:        0A            ASL                       
CODE_048CF3:        85 00         STA $00                   
CODE_048CF5:        A5 13         LDA RAM_FrameCounter      
CODE_048CF7:        29 08 00      AND.W #$0008              
CODE_048CFA:        0A            ASL                       
CODE_048CFB:        18            CLC                       
CODE_048CFC:        65 00         ADC $00                   
CODE_048CFE:        A8            TAY                       ; Y = 0000 000a aaaf ffff (a = animation type, f = 5 LSB of frame counter)
CODE_048CFF:        E0 00 00      CPX.W #$0000              
CODE_048D02:        D0 17         BNE CODE_048D1B           ; skip if not 1P
CODE_048D04:        AD D9 13      LDA.W $13D9               
CODE_048D07:        C9 0B 00      CMP.W #$000B              
CODE_048D0A:        D0 0F         BNE CODE_048D1B           ; skip if not star warp
CODE_048D0C:        A5 13         LDA RAM_FrameCounter      
CODE_048D0E:        29 0C 00      AND.W #$000C              
CODE_048D11:        4A            LSR                       
CODE_048D12:        4A            LSR                       
CODE_048D13:        A8            TAY                       ; Y = 2 LSB of frame counter / 4
CODE_048D14:        B9 4B 89      LDA.W OWWarpIndex,Y       
CODE_048D17:        29 FF 00      AND.W #$00FF              
CODE_048D1A:        A8            TAY                       ; Y = index into tilemap table
CODE_048D1B:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_048D1D:        5A            PHY                       ; Y = index into tilemap table
CODE_048D1E:        98            TYA                       ; A = index into tilemap table
CODE_048D1F:        4A            LSR                       ; / 2
CODE_048D20:        A8            TAY                       ; Y = index into tilemap table / 2
CODE_048D21:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_048D23:        B9 5E 8B      LDA.W DATA_048B5E,Y       ; X offset table for riding yoshi sprites
CODE_048D26:        18            CLC                       
CODE_048D27:        65 8A         ADC $8A                   
CODE_048D29:        9D 9C 02      STA.W $029C,X             ; OAM X-position
CODE_048D2C:        B9 1E 8C      LDA.W DATA_048C1E,Y       ; Y offset table for riding yoshi sprites
CODE_048D2F:        18            CLC                       
CODE_048D30:        65 8B         ADC $8B                   
CODE_048D32:        9D 9D 02      STA.W $029D,X             ; OAM Y-position
CODE_048D35:        7A            PLY                       
CODE_048D36:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_048D38:        B9 DE 89      LDA.W DATA_0489DE,Y       ; 
CODE_048D3B:        C9 FF FF      CMP.W #$FFFF              
CODE_048D3E:        F0 27         BEQ CODE_048D67           
CODE_048D40:        48            PHA                       
CODE_048D41:        29 00 0F      AND.W #$0F00              
CODE_048D44:        C9 00 02      CMP.W #$0200              
CODE_048D47:        D0 15         BNE CODE_048D5E           
CODE_048D49:        84 08         STY $08                   
CODE_048D4B:        A5 0E         LDA $0E                   
CODE_048D4D:        38            SEC                       
CODE_048D4E:        E9 04 00      SBC.W #$0004              
CODE_048D51:        A8            TAY                       
CODE_048D52:        68            PLA                       
CODE_048D53:        29 FF F0      AND.W #$F0FF              
CODE_048D56:        19 DE 8C      ORA.W DATA_048CDE,Y       
CODE_048D59:        48            PHA                       
CODE_048D5A:        A4 08         LDY $08                   
CODE_048D5C:        80 05         BRA CODE_048D63           

CODE_048D5E:        68            PLA                       
CODE_048D5F:        18            CLC                       
CODE_048D60:        65 04         ADC $04                   
CODE_048D62:        48            PHA                       
CODE_048D63:        68            PLA                       
CODE_048D64:        9D 9E 02      STA.W $029E,X             
CODE_048D67:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_048D69:        E8            INX                       
CODE_048D6A:        E8            INX                       
CODE_048D6B:        E8            INX                       
CODE_048D6C:        E8            INX                       
CODE_048D6D:        C8            INY                       
CODE_048D6E:        C8            INY                       
CODE_048D6F:        C6 8C         DEC $8C                   
CODE_048D71:        10 A8         BPL CODE_048D1B           
Return048D73:       60            RTS                       ; Return 


DATA_048D74:                      .db $0B,$00,$13,$00,$1A,$00,$1B,$00
                                  .db $1F,$00,$20,$00,$31,$00,$32,$00
                                  .db $34,$00,$35,$00,$40,$00

DATA_048D8A:                      .db $02,$03,$04,$06,$07,$09,$05

CODE_048D91:        8B            PHB                       ; Index (8 bit) 
CODE_048D92:        4B            PHK                       
CODE_048D93:        AB            PLB                       
CODE_048D94:        9C 9E 1B      STZ.W $1B9E               
CODE_048D97:        A9 0F         LDA.B #$0F                
CODE_048D99:        8D 4E 14      STA.W $144E               
CODE_048D9C:        A2 02         LDX.B #$02                
CODE_048D9E:        AD 13 1F      LDA.W $1F13               
CODE_048DA1:        C9 12         CMP.B #$12                
CODE_048DA3:        F0 04         BEQ CODE_048DA9           
CODE_048DA5:        29 08         AND.B #$08                
CODE_048DA7:        F0 02         BEQ CODE_048DAB           
CODE_048DA9:        A2 0A         LDX.B #$0A                
CODE_048DAB:        8E 13 1F      STX.W $1F13               
CODE_048DAE:        A2 02         LDX.B #$02                
CODE_048DB0:        AD 15 1F      LDA.W $1F15               
CODE_048DB3:        C9 12         CMP.B #$12                
CODE_048DB5:        F0 04         BEQ CODE_048DBB           
CODE_048DB7:        29 08         AND.B #$08                
CODE_048DB9:        F0 02         BEQ CODE_048DBD           
CODE_048DBB:        A2 0A         LDX.B #$0A                
CODE_048DBD:        8E 15 1F      STX.W $1F15               
CODE_048DC0:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_048DC2:        20 55 8E      JSR.W CODE_048E55         
CODE_048DC5:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_048DC7:        AD D4 0D      LDA.W $0DD4               
CODE_048DCA:        29 00 FF      AND.W #$FF00              
CODE_048DCD:        F0 10         BEQ CODE_048DDF           
CODE_048DCF:        30 0E         BMI CODE_048DDF           
CODE_048DD1:        AD BF 13      LDA.W $13BF               
CODE_048DD4:        29 FF 00      AND.W #$00FF              
CODE_048DD7:        C9 18 00      CMP.W #$0018              
CODE_048DDA:        D0 03         BNE CODE_048DDF           
CODE_048DDC:        82 55 00      BRL CODE_048E34           
CODE_048DDF:        AD C6 13      LDA.W $13C6               
CODE_048DE2:        29 FF 00      AND.W #$00FF              
CODE_048DE5:        F0 51         BEQ CODE_048E38           
CODE_048DE7:        AD C6 13      LDA.W $13C6               
CODE_048DEA:        29 00 FF      AND.W #$FF00              
CODE_048DED:        8D C6 13      STA.W $13C6               
CODE_048DF0:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_048DF2:        AE D6 0D      LDX.W $0DD6               
CODE_048DF5:        BD 17 1F      LDA.W $1F17,X             
CODE_048DF8:        4A            LSR                       
CODE_048DF9:        4A            LSR                       
CODE_048DFA:        4A            LSR                       
CODE_048DFB:        4A            LSR                       
CODE_048DFC:        85 00         STA $00                   
CODE_048DFE:        BD 19 1F      LDA.W $1F19,X             
CODE_048E01:        4A            LSR                       
CODE_048E02:        4A            LSR                       
CODE_048E03:        4A            LSR                       
CODE_048E04:        4A            LSR                       
CODE_048E05:        85 02         STA $02                   
CODE_048E07:        8A            TXA                       
CODE_048E08:        4A            LSR                       
CODE_048E09:        4A            LSR                       
CODE_048E0A:        AA            TAX                       
CODE_048E0B:        20 85 98      JSR.W OW_TilePos_Calc     
CODE_048E0E:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_048E10:        A6 04         LDX $04                   
CODE_048E12:        BF 00 D0 7E   LDA.L $7ED000,X           
CODE_048E16:        29 FF 00      AND.W #$00FF              
CODE_048E19:        AA            TAX                       
CODE_048E1A:        BD A2 1E      LDA.W $1EA2,X             
CODE_048E1D:        29 80 00      AND.W #$0080              
CODE_048E20:        D0 16         BNE CODE_048E38           
CODE_048E22:        A0 14 00      LDY.W #$0014              
CODE_048E25:        AD BF 13      LDA.W $13BF               
CODE_048E28:        29 FF 00      AND.W #$00FF              
CODE_048E2B:        D9 74 8D      CMP.W DATA_048D74,Y       
CODE_048E2E:        F0 08         BEQ CODE_048E38           
CODE_048E30:        88            DEY                       
CODE_048E31:        88            DEY                       
CODE_048E32:        10 F1         BPL CODE_048E25           
CODE_048E34:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_048E36:        80 0F         BRA CODE_048E47           

CODE_048E38:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_048E3A:        AE B3 0D      LDX.W $0DB3               
CODE_048E3D:        BD 11 1F      LDA.W $1F11,X             
CODE_048E40:        AA            TAX                       
CODE_048E41:        BD 8A 8D      LDA.W DATA_048D8A,X       
CODE_048E44:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_048E47:        AB            PLB                       
Return048E48:       6B            RTL                       ; Return 


DATA_048E49:                      .db $28,$01,$00,$00,$88,$01

DATA_048E4F:                      .db $C8,$01,$00,$00,$D8,$01

CODE_048E55:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_048E57:        AD B3 0D      LDA.W $0DB3               
CODE_048E5A:        29 FF 00      AND.W #$00FF              
CODE_048E5D:        0A            ASL                       
CODE_048E5E:        0A            ASL                       
CODE_048E5F:        8D D6 0D      STA.W $0DD6               
CODE_048E62:        AE D6 0D      LDX.W $0DD6               
CODE_048E65:        BD 1F 1F      LDA.W $1F1F,X             
CODE_048E68:        85 00         STA $00                   
CODE_048E6A:        BD 21 1F      LDA.W $1F21,X             
CODE_048E6D:        85 02         STA $02                   
CODE_048E6F:        8A            TXA                       
CODE_048E70:        4A            LSR                       
CODE_048E71:        4A            LSR                       
CODE_048E72:        AA            TAX                       
CODE_048E73:        20 85 98      JSR.W OW_TilePos_Calc     
CODE_048E76:        64 00         STZ $00                   
CODE_048E78:        A6 04         LDX $04                   
CODE_048E7A:        BF 00 D0 7E   LDA.L $7ED000,X           
CODE_048E7E:        29 FF 00      AND.W #$00FF              
CODE_048E81:        0A            ASL                       
CODE_048E82:        AA            TAX                       
CODE_048E83:        BD FC A0      LDA.W LevelNames,X        
CODE_048E86:        85 00         STA $00                   
CODE_048E88:        20 07 9D      JSR.W CODE_049D07         
CODE_048E8B:        A6 04         LDX $04                   
CODE_048E8D:        30 0F         BMI CODE_048E9E           
CODE_048E8F:        E0 00 08      CPX.W #$0800              
CODE_048E92:        B0 0A         BCS CODE_048E9E           
CODE_048E94:        BF 00 C8 7E   LDA.L $7EC800,X           
CODE_048E98:        29 FF 00      AND.W #$00FF              
CODE_048E9B:        8D C1 13      STA.W $13C1               
CODE_048E9E:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_048EA0:        AE F7 0E      LDX.W $0EF7               
CODE_048EA3:        F0 3C         BEQ CODE_048EE1           
ADDR_048EA5:        10 32         BPL ADDR_048ED9           
ADDR_048EA7:        8A            TXA                       
ADDR_048EA8:        29 7F         AND.B #$7F                
ADDR_048EAA:        AA            TAX                       
ADDR_048EAB:        9E F5 0D      STZ.W $0DF5,X             
ADDR_048EAE:        AD F6 0E      LDA.W $0EF6               
ADDR_048EB1:        AE D5 0D      LDX.W $0DD5               
ADDR_048EB4:        10 17         BPL ADDR_048ECD           
ADDR_048EB6:        0A            ASL                       
ADDR_048EB7:        AA            TAX                       
ADDR_048EB8:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_048EBA:        AC D6 0D      LDY.W $0DD6               
ADDR_048EBD:        BD 49 8E      LDA.W DATA_048E49,X       
ADDR_048EC0:        99 17 1F      STA.W $1F17,Y             
ADDR_048EC3:        BD 4F 8E      LDA.W DATA_048E4F,X       
ADDR_048EC6:        99 19 1F      STA.W $1F19,Y             
ADDR_048EC9:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_048ECB:        80 14         BRA CODE_048EE1           

ADDR_048ECD:        AA            TAX                       
ADDR_048ECE:        BD 85 FB      LDA.W DATA_04FB85,X       
ADDR_048ED1:        0D F5 0E      ORA.W $0EF5               
ADDR_048ED4:        8D F5 0E      STA.W $0EF5               
ADDR_048ED7:        80 08         BRA CODE_048EE1           

ADDR_048ED9:        AD D5 0D      LDA.W $0DD5               
ADDR_048EDC:        30 03         BMI CODE_048EE1           
ADDR_048EDE:        9E E5 0D      STZ.W $0DE5,X             
CODE_048EE1:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_048EE3:        20 31 98      JSR.W CODE_049831         
CODE_048EE6:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_048EE8:        20 A4 85      JSR.W DrawOWBoarder?      
CODE_048EEB:        20 86 80      JSR.W CODE_048086         
CODE_048EEE:        4C E0 80      JMP.W OW_Tile_Animation   

CODE_048EF1:        A9 08         LDA.B #$08                
CODE_048EF3:        8D B1 0D      STA.W $0DB1               
CODE_048EF6:        AD 11 1F      LDA.W $1F11               
CODE_048EF9:        C9 01         CMP.B #$01                
CODE_048EFB:        D0 16         BNE CODE_048F13           
CODE_048EFD:        AD 17 1F      LDA.W $1F17               
CODE_048F00:        C9 68         CMP.B #$68                
CODE_048F02:        D0 0F         BNE CODE_048F13           
CODE_048F04:        AD 19 1F      LDA.W $1F19               
CODE_048F07:        C9 8E         CMP.B #$8E                
CODE_048F09:        D0 08         BNE CODE_048F13           
CODE_048F0B:        A9 0C         LDA.B #$0C                
CODE_048F0D:        8D D9 13      STA.W $13D9               
CODE_048F10:        82 67 00      BRL CODE_048F7A           
CODE_048F13:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_048F15:        AE D6 0D      LDX.W $0DD6               
CODE_048F18:        BD 17 1F      LDA.W $1F17,X             
CODE_048F1B:        4A            LSR                       
CODE_048F1C:        4A            LSR                       
CODE_048F1D:        4A            LSR                       
CODE_048F1E:        4A            LSR                       
CODE_048F1F:        85 00         STA $00                   
CODE_048F21:        BD 19 1F      LDA.W $1F19,X             
CODE_048F24:        4A            LSR                       
CODE_048F25:        4A            LSR                       
CODE_048F26:        4A            LSR                       
CODE_048F27:        4A            LSR                       
CODE_048F28:        85 02         STA $02                   
CODE_048F2A:        8A            TXA                       
CODE_048F2B:        4A            LSR                       
CODE_048F2C:        4A            LSR                       
CODE_048F2D:        AA            TAX                       
CODE_048F2E:        20 85 98      JSR.W OW_TilePos_Calc     
CODE_048F31:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_048F33:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_048F35:        AD CE 13      LDA.W $13CE               
CODE_048F38:        F0 1C         BEQ CODE_048F56           
CODE_048F3A:        AD D5 0D      LDA.W $0DD5               
CODE_048F3D:        F0 17         BEQ CODE_048F56           
CODE_048F3F:        10 1E         BPL CODE_048F5F           
CODE_048F41:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_048F43:        A6 04         LDX $04                   
CODE_048F45:        BF 00 D0 7E   LDA.L $7ED000,X           
CODE_048F49:        29 FF 00      AND.W #$00FF              
CODE_048F4C:        AA            TAX                       
CODE_048F4D:        BD A2 1E      LDA.W $1EA2,X             
CODE_048F50:        09 40 00      ORA.W #$0040              
CODE_048F53:        9D A2 1E      STA.W $1EA2,X             
CODE_048F56:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_048F58:        A9 05         LDA.B #$05                
CODE_048F5A:        8D D9 13      STA.W $13D9               
CODE_048F5D:        80 1B         BRA CODE_048F7A           

CODE_048F5F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_048F61:        A6 04         LDX $04                   
CODE_048F63:        BF 00 D0 7E   LDA.L $7ED000,X           
CODE_048F67:        29 FF 00      AND.W #$00FF              
CODE_048F6A:        AA            TAX                       
CODE_048F6B:        BD A2 1E      LDA.W $1EA2,X             
CODE_048F6E:        09 80 00      ORA.W #$0080              
CODE_048F71:        29 BF FF      AND.W #$FFBF              
CODE_048F74:        9D A2 1E      STA.W $1EA2,X             
CODE_048F77:        EE D9 13      INC.W $13D9               
CODE_048F7A:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_048F7C:        4C 31 98      JMP.W CODE_049831         


DATA_048F7F:                      .db $58,$59,$5D,$63,$77,$79,$7E,$80

CODE_048F87:        20 03 99      JSR.W CODE_049903         ; Index (8 bit) 
CODE_048F8A:        A2 07         LDX.B #$07                
CODE_048F8C:        AD C1 13      LDA.W $13C1               
CODE_048F8F:        DD 7F 8F      CMP.W DATA_048F7F,X       
CODE_048F92:        D0 6C         BNE CODE_049000           
CODE_048F94:        A2 2C         LDX.B #$2C                
CODE_048F96:        BD 02 1F      LDA.W $1F02,X             
CODE_048F99:        9D A9 1F      STA.W $1FA9,X             
CODE_048F9C:        CA            DEX                       
CODE_048F9D:        10 F7         BPL CODE_048F96           
CODE_048F9F:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_048FA1:        AE D6 0D      LDX.W $0DD6               
CODE_048FA4:        8A            TXA                       
CODE_048FA5:        49 04 00      EOR.W #$0004              
CODE_048FA8:        A8            TAY                       
CODE_048FA9:        BD BE 1F      LDA.W $1FBE,X             
CODE_048FAC:        99 BE 1F      STA.W $1FBE,Y             
CODE_048FAF:        BD C0 1F      LDA.W $1FC0,X             
CODE_048FB2:        99 C0 1F      STA.W $1FC0,Y             
CODE_048FB5:        BD C6 1F      LDA.W $1FC6,X             
CODE_048FB8:        99 C6 1F      STA.W $1FC6,Y             
CODE_048FBB:        BD C8 1F      LDA.W $1FC8,X             
CODE_048FBE:        99 C8 1F      STA.W $1FC8,Y             
CODE_048FC1:        8A            TXA                       
CODE_048FC2:        4A            LSR                       
CODE_048FC3:        AA            TAX                       
CODE_048FC4:        49 02 00      EOR.W #$0002              
CODE_048FC7:        A8            TAY                       
CODE_048FC8:        BD BA 1F      LDA.W $1FBA,X             
CODE_048FCB:        99 BA 1F      STA.W $1FBA,Y             
CODE_048FCE:        8A            TXA                       
CODE_048FCF:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_048FD1:        4A            LSR                       
CODE_048FD2:        AA            TAX                       
CODE_048FD3:        49 01         EOR.B #$01                
CODE_048FD5:        A8            TAY                       
CODE_048FD6:        BD B8 1F      LDA.W $1FB8,X             
CODE_048FD9:        99 B8 1F      STA.W $1FB8,Y             
CODE_048FDC:        AD D5 0D      LDA.W $0DD5               
CODE_048FDF:        C9 E0         CMP.B #$E0                
CODE_048FE1:        D0 18         BNE CODE_048FFB           
ADDR_048FE3:        CE B1 0D      DEC.W $0DB1               
ADDR_048FE6:        30 01         BMI ADDR_048FE9           
Return048FE8:       60            RTS                       ; Return 

ADDR_048FE9:        EE CA 13      INC.W $13CA               
ADDR_048FEC:        20 37 90      JSR.W CODE_049037         
ADDR_048FEF:        A9 02         LDA.B #$02                
ADDR_048FF1:        8D B1 0D      STA.W $0DB1               
ADDR_048FF4:        A9 04         LDA.B #$04                
ADDR_048FF6:        8D D9 13      STA.W $13D9               
ADDR_048FF9:        80 08         BRA CODE_049003           

CODE_048FFB:        EE CA 13      INC.W $13CA               
CODE_048FFE:        80 03         BRA CODE_049003           

CODE_049000:        CA            DEX                       
CODE_049001:        10 89         BPL CODE_048F8C           
CODE_049003:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_049005:        64 06         STZ $06                   
CODE_049007:        AE D6 0D      LDX.W $0DD6               
CODE_04900A:        BD 17 1F      LDA.W $1F17,X             
CODE_04900D:        4A            LSR                       
CODE_04900E:        4A            LSR                       
CODE_04900F:        4A            LSR                       
CODE_049010:        4A            LSR                       
CODE_049011:        85 00         STA $00                   
CODE_049013:        BD 19 1F      LDA.W $1F19,X             
CODE_049016:        4A            LSR                       
CODE_049017:        4A            LSR                       
CODE_049018:        4A            LSR                       
CODE_049019:        4A            LSR                       
CODE_04901A:        85 02         STA $02                   
CODE_04901C:        8A            TXA                       
CODE_04901D:        4A            LSR                       
CODE_04901E:        4A            LSR                       
CODE_04901F:        AA            TAX                       
CODE_049020:        20 85 98      JSR.W OW_TilePos_Calc     
CODE_049023:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_049025:        A6 04         LDX $04                   
CODE_049027:        BF 00 C8 7E   LDA.L $7EC800,X           
CODE_04902B:        29 FF 00      AND.W #$00FF              
CODE_04902E:        8D C1 13      STA.W $13C1               
CODE_049031:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_049033:        EE D9 13      INC.W $13D9               
Return049036:       60            RTS                       ; Return 

CODE_049037:        DA            PHX                       
CODE_049038:        5A            PHY                       
CODE_049039:        08            PHP                       
CODE_04903A:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04903C:        AD CA 13      LDA.W $13CA               
CODE_04903F:        F0 13         BEQ CODE_049054           
CODE_049041:        A2 5F         LDX.B #$5F                
CODE_049043:        BD A2 1E      LDA.W $1EA2,X             
CODE_049046:        9D 49 1F      STA.W $1F49,X             
CODE_049049:        CA            DEX                       
CODE_04904A:        10 F7         BPL CODE_049043           
CODE_04904C:        9C CA 13      STZ.W $13CA               
CODE_04904F:        A9 05         LDA.B #$05                
CODE_049051:        8D 87 1B      STA.W $1B87               
CODE_049054:        28            PLP                       
CODE_049055:        7A            PLY                       
CODE_049056:        FA            PLX                       
Return049057:       60            RTS                       ; Return 


DATA_049058:                      .db $FF,$FF,$01,$00,$FF,$FF,$01,$00
DATA_049060:                      .db $05,$03,$01,$00

DATA_049064:                      .db $00,$00,$02,$00,$04,$00,$06,$00
DATA_04906C:                      .db $28,$00,$08,$00,$14,$00,$36,$00
                                  .db $3F,$00,$45,$00

HardCodedOWPaths:                 .db $09,$15,$23,$1B,$43,$44,$24,$FF
                                  .db $30,$31

DATA_049082:                      .db $78,$01

DATA_049084:                      .db $28,$01

DATA_049086:                      .db $10,$10,$1E,$19,$16,$66,$16,$19
                                  .db $1E,$10,$10,$66,$04,$04,$04,$58
                                  .db $04,$04,$04,$66,$04,$04,$04,$04
                                  .db $04,$6A,$04,$04,$04,$04,$04,$66
                                  .db $1E,$19,$06,$09,$0F,$20,$1A,$21
                                  .db $1A,$14,$19,$18,$1F,$17,$82,$17
                                  .db $1F,$18,$19,$14,$1A,$21,$1A,$20
                                  .db $0F,$09,$06,$19,$1E,$66,$04,$04
                                  .db $58,$04,$04,$5F

DATA_0490CA:                      .db $02,$02,$02,$02,$06,$06,$04,$04
                                  .db $00,$00,$00,$00,$04,$04,$04,$04
                                  .db $06,$06,$06,$06,$06,$06,$06,$06
                                  .db $06,$06,$04,$04,$04,$04,$04,$04
                                  .db $02,$02,$06,$06,$00,$00,$00,$04
                                  .db $00,$04,$04,$00,$04,$00,$04,$06
                                  .db $02,$06,$02,$06,$06,$02,$06,$02
                                  .db $02,$02,$04,$04,$00,$00,$06,$06
                                  .db $06,$04,$04,$04

DATA_04910E:                      .db $00,$06,$0C,$10,$14,$1A,$20,$2F
                                  .db $3E,$41,$08,$00,$04,$00,$02,$00
                                  .db $01,$00

CODE_049120:        9C D8 0D      STZ.W $0DD8               
CODE_049123:        AC F7 0E      LDY.W $0EF7               
CODE_049126:        30 71         BMI OWPU_NotOnPipe        
CODE_049128:        AD D5 0D      LDA.W $0DD5               
CODE_04912B:        30 05         BMI CODE_049132           
CODE_04912D:        F0 03         BEQ CODE_049132           
CODE_04912F:        82 B7 00      BRL CODE_0491E9           
CODE_049132:        A5 16         LDA $16                   
CODE_049134:        29 20         AND.B #$20                
CODE_049136:        80 09         BRA OW_Player_Update      ; Change to BEQ to enable below debug code 

ADDR_049138:        AD C1 13      LDA.W $13C1               ; \ Unreachable 
ADDR_04913B:        F0 28         BEQ CODE_049165           ;  | Debug: Warp to star road from Yoshi's house 
ADDR_04913D:        C9 56         CMP.B #$56                ;  | 
ADDR_04913F:        F0 24         BEQ CODE_049165           ; / 
OW_Player_Update:   A5 17         LDA RAM_ControllerB       ; \ 
CODE_049143:        29 30         AND.B #$30                ;  |If L and R aren't pressed, 
CODE_049145:        C9 30         CMP.B #$30                ;  |branch to OWPU_NoLR 
CODE_049147:        D0 07         BNE OWPU_NoLR             ; / 
ADDR_049149:        AD C1 13      LDA.W $13C1               ; \ 
ADDR_04914C:        C9 81         CMP.B #$81                ;  |If Mario is standing on Destroyed Castle, 
ADDR_04914E:        F0 4F         BEQ OWPU_EnterLevel       ; / branch to OWPU_EnterLevel 
OWPU_NoLR:          A5 16         LDA $16                   ; \ 
CODE_049152:        05 18         ORA $18                   ;  |If A, B, X or Y are pressed, 
CODE_049154:        29 C0         AND.B #$C0                ;  |branch to OWPU_ABXY 
CODE_049156:        D0 03         BNE OWPU_ABXY             ;  |Otherwise, 
CODE_049158:        82 8E 00      BRL CODE_0491E9           ; / branch to $91E9 
OWPU_ABXY:          9C 9E 1B      STZ.W $1B9E               
CODE_04915E:        AD C1 13      LDA.W $13C1               ; \ 
CODE_049161:        C9 5F         CMP.B #$5F                ;  |If not standing on a star tile, 
CODE_049163:        D0 18         BNE OWPU_NotOnStar        ; / branch to OWPU_NotOnStar 
CODE_049165:        20 09 85      JSR.W CODE_048509         
Return049168:       D0 2E         BNE OWPU_IsOnPipeRTS      
CODE_04916A:        9C F7 1D      STZ.W $1DF7               ; Set "Fly away" speed to 0 
CODE_04916D:        9C F8 1D      STZ.W $1DF8               ; Set "Stay on ground" timer to 0 (31 = Fly away) 
CODE_049170:        A9 0D         LDA.B #$0D                ; \ Star Road sound effect 
CODE_049172:        8D F9 1D      STA.W $1DF9               ; / 
CODE_049175:        A9 0B         LDA.B #$0B                ; \ Activate star warp 
CODE_049177:        8D D9 13      STA.W $13D9               ; / 
CODE_04917A:        4C 52 9E      JMP.W CODE_049E52         

OWPU_NotOnStar:     AD C1 13      LDA.W $13C1               ; \ 
CODE_049180:        C9 82         CMP.B #$82                ;  |If standing on Pipe#1 (unused), 
CODE_049182:        F0 04         BEQ OWPU_IsOnPipe         ; / branch to OWPU_IsOnPipe 
CODE_049184:        C9 5B         CMP.B #$5B                ; \ If not standing on Pipe#2, 
CODE_049186:        D0 11         BNE OWPU_NotOnPipe        ; / branch to OWPU_NotOnPipe 
OWPU_IsOnPipe:      20 09 85      JSR.W CODE_048509         
Return04918B:       D0 0B         BNE OWPU_IsOnPipeRTS      
CODE_04918D:        EE 9C 1B      INC.W $1B9C               
CODE_049190:        9C D5 0D      STZ.W $0DD5               ; Set auto-walk to 0 
CODE_049193:        A9 0B         LDA.B #$0B                ; \ Fade to overworld 
CODE_049195:        8D 00 01      STA.W RAM_GameMode        ; / 
OWPU_IsOnPipeRTS:   60            RTS                       ; Return 

OWPU_NotOnPipe:     C9 81         CMP.B #$81                ; \ 
CODE_04919B:        F0 4C         BEQ CODE_0491E9           ;  |If standing on a tile >= (?) Destroyed Castle, 
CODE_04919D:        B0 4A         BCS CODE_0491E9           ; / branch to $91E9 
OWPU_EnterLevel:    AD D6 0D      LDA.W $0DD6               ; \ 
CODE_0491A2:        4A            LSR                       ;  |If current player is Luigi, 
CODE_0491A3:        29 02         AND.B #$02                ;  |change Luigi's animation in the following lines 
CODE_0491A5:        AA            TAX                       ; / 
CODE_0491A6:        A0 10         LDY.B #$10                ; \ 
CODE_0491A8:        BD 13 1F      LDA.W $1F13,X             ;  | 
CODE_0491AB:        29 08         AND.B #$08                ;  |If Mario isn't swimming, use "raise hand" animation 
CODE_0491AD:        F0 02         BEQ CODE_0491B1           ;  |Otherwise, use "raise hand, swimming" animation 
CODE_0491AF:        A0 12         LDY.B #$12                ;  | 
CODE_0491B1:        98            TYA                       ;  | 
CODE_0491B2:        9D 13 1F      STA.W $1F13,X             ; / 
CODE_0491B5:        AE B3 0D      LDX.W $0DB3               ; Get current character 
CODE_0491B8:        BD B6 0D      LDA.W RAM_PlayerCoins,X   ; \ Get character's coins 
CODE_0491BB:        8D BF 0D      STA.W RAM_StatusCoins     ; / 
CODE_0491BE:        BD B4 0D      LDA.W RAM_PlayerLives,X   ; \ Get character's lives 
CODE_0491C1:        8D BE 0D      STA.W RAM_StatusLives     ; / 
CODE_0491C4:        BD B8 0D      LDA.W RAM_PlayerPowerUp,X ; \ Get character's powerup 
CODE_0491C7:        85 19         STA RAM_MarioPowerUp      ; / 
CODE_0491C9:        BD BA 0D      LDA.W RAM_PlyrYoshiColor,X ; \ 
CODE_0491CC:        8D C1 0D      STA.W RAM_OWHasYoshi      ;  |Get character's Yoshi color 
CODE_0491CF:        8D C7 13      STA.W RAM_YoshiColor      ;  | 
CODE_0491D2:        8D 7A 18      STA.W RAM_OnYoshi         ; / 
CODE_0491D5:        BD BC 0D      LDA.W $0DBC,X             ; \ Get character's reserved item 
CODE_0491D8:        8D C2 0D      STA.W $0DC2               ; / 
CODE_0491DB:        A9 02         LDA.B #$02                ; \ Related to fade speed 
CODE_0491DD:        8D B1 0D      STA.W $0DB1               ; / 
CODE_0491E0:        A9 80         LDA.B #$80                ; \ Music fade out 
CODE_0491E2:        8D FB 1D      STA.W $1DFB               ; / 
CODE_0491E5:        EE 00 01      INC.W RAM_GameMode        ; Fade to level 
Return0491E8:       60            RTS                       ; Return 

CODE_0491E9:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_0491EB:        AE D6 0D      LDX.W $0DD6               ; Get current character * 4 
CODE_0491EE:        BD 17 1F      LDA.W $1F17,X             ; Get character's X coordinate 
CODE_0491F1:        4A            LSR                       ; \ 
CODE_0491F2:        4A            LSR                       ;  |Divide X coordinate by 16 
CODE_0491F3:        4A            LSR                       ;  | 
CODE_0491F4:        4A            LSR                       ; / 
CODE_0491F5:        85 00         STA $00                   ; \ Store in $00 and $1F1F,x 
CODE_0491F7:        9D 1F 1F      STA.W $1F1F,X             ; / 
CODE_0491FA:        BD 19 1F      LDA.W $1F19,X             ; Get character's Y coordinate 
CODE_0491FD:        4A            LSR                       ; \ 
CODE_0491FE:        4A            LSR                       ;  |Divide Y coordinate by 16 
CODE_0491FF:        4A            LSR                       ;  | 
CODE_049200:        4A            LSR                       ; / 
CODE_049201:        85 02         STA $02                   ; \ Store in $02 and $1F21,x 
CODE_049203:        9D 21 1F      STA.W $1F21,X             ; / 
CODE_049206:        8A            TXA                       ; \ 
CODE_049207:        4A            LSR                       ;  |Divide (current character * 4) by 4 
CODE_049208:        4A            LSR                       ;  | 
CODE_049209:        AA            TAX                       ; / 
CODE_04920A:        20 85 98      JSR.W OW_TilePos_Calc     ; Calculate current tile pos 
CODE_04920D:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_04920F:        AE D5 0D      LDX.W $0DD5               ; \ If auto-walk=0, 
CODE_049212:        F0 46         BEQ OWPU_NotAutoWalk      ; / branch to OWPU_NotAutoWalk 
CODE_049214:        CA            DEX                       
CODE_049215:        BD 60 90      LDA.W DATA_049060,X       
CODE_049218:        85 08         STA $08                   
CODE_04921A:        64 09         STZ $09                   
CODE_04921C:        C2 30         REP #$30                  ; 16 bit A,X,Y ; Index (16 bit) Accum (16 bit) 
CODE_04921E:        A6 04         LDX $04                   ; X = tile pos 
CODE_049220:        BF 00 D0 7E   LDA.L $7ED000,X           ; \ Get level number of current tile pos 
CODE_049224:        29 FF 00      AND.W #$00FF              ; / 
CODE_049227:        A0 0A 00      LDY.W #$000A              
CODE_04922A:        D9 6C 90      CMP.W DATA_04906C,Y       
CODE_04922D:        D0 0C         BNE CODE_04923B           
CODE_04922F:        A9 05 00      LDA.W #$0005              
CODE_049232:        8D D9 13      STA.W $13D9               
CODE_049235:        20 37 90      JSR.W CODE_049037         
CODE_049238:        82 D6 01      BRL CODE_049411           
CODE_04923B:        88            DEY                       
CODE_04923C:        88            DEY                       
CODE_04923D:        10 EB         BPL CODE_04922A           
CODE_04923F:        BF 00 D8 7E   LDA.L $7ED800,X           
CODE_049243:        29 FF 00      AND.W #$00FF              
CODE_049246:        A6 08         LDX $08                   
CODE_049248:        F0 04         BEQ CODE_04924E           
CODE_04924A:        4A            LSR                       
CODE_04924B:        CA            DEX                       
CODE_04924C:        10 FC         BPL CODE_04924A           
CODE_04924E:        29 03 00      AND.W #$0003              
CODE_049251:        0A            ASL                       
CODE_049252:        AA            TAX                       
CODE_049253:        BD 64 90      LDA.W DATA_049064,X       
CODE_049256:        A8            TAY                       
CODE_049257:        4C BC 92      JMP.W CODE_0492BC         

OWPU_NotAutoWalk:   E2 30         SEP #$30                  ; 8 bit A,X,Y ; Index (8 bit) Accum (8 bit) 
CODE_04925C:        9C D5 0D      STZ.W $0DD5               ; Set auto-walk to 0 
CODE_04925F:        A5 16         LDA $16                   ; \ 
CODE_049261:        29 0F         AND.B #$0F                ;  |If no dir button is pressed (one frame), 
CODE_049263:        F0 09         BEQ CODE_04926E           ; / branch to $926E 
CODE_049265:        AE C1 13      LDX.W $13C1               ; \ 
CODE_049268:        E0 82         CPX.B #$82                ;  |If standing on Pipe#2, 
CODE_04926A:        F0 41         BEQ CODE_0492AD           ;  |branch to $92AD 
CODE_04926C:        80 1E         BRA CODE_04928C           ; / Otherwise, branch to $928C 

CODE_04926E:        CE 4E 14      DEC.W $144E               ; \ Decrease "Face walking dir" timer 
CODE_049271:        10 14         BPL CODE_049287           ; / If >= 0, branch to $9287 
CODE_049273:        9C 4E 14      STZ.W $144E               ; Set "Face walking dir" timer to 0 
CODE_049276:        AD D6 0D      LDA.W $0DD6               ; \ 
CODE_049279:        4A            LSR                       ;  |Set X to current character * 2 
CODE_04927A:        29 02         AND.B #$02                ;  | 
CODE_04927C:        AA            TAX                       ; / 
CODE_04927D:        BD 13 1F      LDA.W $1F13,X             ; \ 
CODE_049280:        29 08         AND.B #$08                ;  |Set current character's animation to "facing down" 
CODE_049282:        09 02         ORA.B #$02                ;  |or "facing down in water", depending on if character 
CODE_049284:        9D 13 1F      STA.W $1F13,X             ; / is in water or not. 
CODE_049287:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_049289:        4C 31 98      JMP.W CODE_049831         

CODE_04928C:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04928E:        29 FF 00      AND.W #$00FF              
CODE_049291:        EA            NOP                       
CODE_049292:        EA            NOP                       
CODE_049293:        EA            NOP                       
CODE_049294:        48            PHA                       
CODE_049295:        64 06         STZ $06                   
CODE_049297:        A6 04         LDX $04                   
CODE_049299:        BF 00 D0 7E   LDA.L $7ED000,X           
CODE_04929D:        29 FF 00      AND.W #$00FF              
CODE_0492A0:        AA            TAX                       
CODE_0492A1:        68            PLA                       
CODE_0492A2:        3D A2 1E      AND.W $1EA2,X             
CODE_0492A5:        29 0F 00      AND.W #$000F              
CODE_0492A8:        D0 03         BNE CODE_0492AD           
CODE_0492AA:        4C 11 94      JMP.W CODE_049411         

CODE_0492AD:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_0492AF:        29 FF 00      AND.W #$00FF              
CODE_0492B2:        A0 06 00      LDY.W #$0006              
CODE_0492B5:        4A            LSR                       
CODE_0492B6:        B0 04         BCS CODE_0492BC           
CODE_0492B8:        88            DEY                       
CODE_0492B9:        88            DEY                       
CODE_0492BA:        10 F9         BPL CODE_0492B5           
CODE_0492BC:        98            TYA                       
CODE_0492BD:        8D D3 0D      STA.W $0DD3               
CODE_0492C0:        A2 00 00      LDX.W #$0000              
CODE_0492C3:        C0 04 00      CPY.W #$0004              
CODE_0492C6:        B0 03         BCS CODE_0492CB           
CODE_0492C8:        A2 02 00      LDX.W #$0002              
CODE_0492CB:        A5 04         LDA $04                   
CODE_0492CD:        85 08         STA $08                   
CODE_0492CF:        B5 00         LDA $00,X                 
CODE_0492D1:        18            CLC                       
CODE_0492D2:        79 58 90      ADC.W DATA_049058,Y       
CODE_0492D5:        95 00         STA $00,X                 
CODE_0492D7:        AD D6 0D      LDA.W $0DD6               
CODE_0492DA:        4A            LSR                       
CODE_0492DB:        4A            LSR                       
CODE_0492DC:        AA            TAX                       
CODE_0492DD:        20 85 98      JSR.W OW_TilePos_Calc     
CODE_0492E0:        A6 04         LDX $04                   
CODE_0492E2:        30 1D         BMI CODE_049301           
CODE_0492E4:        C9 00 08      CMP.W #$0800              
CODE_0492E7:        B0 18         BCS CODE_049301           
CODE_0492E9:        BF 00 C8 7E   LDA.L $7EC800,X           
CODE_0492ED:        29 FF 00      AND.W #$00FF              
CODE_0492F0:        F0 0F         BEQ CODE_049301           
CODE_0492F2:        C9 56 00      CMP.W #$0056              
CODE_0492F5:        90 07         BCC CODE_0492FE           
CODE_0492F7:        C9 87 00      CMP.W #$0087              
CODE_0492FA:        90 02         BCC CODE_0492FE           
CODE_0492FC:        80 03         BRA CODE_049301           

CODE_0492FE:        82 83 00      BRL CODE_049384           
CODE_049301:        9C 78 1B      STZ.W $1B78               
CODE_049304:        9C 7A 1B      STZ.W $1B7A               
CODE_049307:        A6 08         LDX $08                   
CODE_049309:        BF 00 D0 7E   LDA.L $7ED000,X           
CODE_04930D:        29 FF 00      AND.W #$00FF              
CODE_049310:        85 00         STA $00                   
CODE_049312:        A2 09 00      LDX.W #$0009              
CODE_049315:        BD 78 90      LDA.W HardCodedOWPaths,X  
CODE_049318:        29 FF 00      AND.W #$00FF              
CODE_04931B:        C9 FF 00      CMP.W #$00FF              
CODE_04931E:        D0 29         BNE CODE_049349           
CODE_049320:        DA            PHX                       
CODE_049321:        AE D6 0D      LDX.W $0DD6               
CODE_049324:        BD 19 1F      LDA.W $1F19,X             
CODE_049327:        CD 82 90      CMP.W DATA_049082         
CODE_04932A:        D0 1A         BNE CODE_049346           
CODE_04932C:        BD 17 1F      LDA.W $1F17,X             
CODE_04932F:        CD 84 90      CMP.W DATA_049084         
CODE_049332:        D0 12         BNE CODE_049346           
CODE_049334:        AD B3 0D      LDA.W $0DB3               
CODE_049337:        29 FF 00      AND.W #$00FF              
CODE_04933A:        AA            TAX                       
CODE_04933B:        BD 11 1F      LDA.W $1F11,X             
CODE_04933E:        29 FF 00      AND.W #$00FF              
CODE_049341:        D0 03         BNE CODE_049346           
CODE_049343:        FA            PLX                       
CODE_049344:        80 07         BRA CODE_04934D           

CODE_049346:        FA            PLX                       
CODE_049347:        80 2B         BRA CODE_049374           

CODE_049349:        C5 00         CMP $00                   
CODE_04934B:        D0 27         BNE CODE_049374           
CODE_04934D:        86 00         STX $00                   
CODE_04934F:        BD 0E 91      LDA.W DATA_04910E,X       
CODE_049352:        29 FF 00      AND.W #$00FF              
CODE_049355:        AA            TAX                       
CODE_049356:        3A            DEC A                     
CODE_049357:        8D 7A 1B      STA.W $1B7A               
CODE_04935A:        84 02         STY $02                   
CODE_04935C:        BD CA 90      LDA.W DATA_0490CA,X       
CODE_04935F:        29 FF 00      AND.W #$00FF              
CODE_049362:        C5 02         CMP $02                   
CODE_049364:        D0 14         BNE CODE_04937A           
CODE_049366:        A9 01 00      LDA.W #$0001              
CODE_049369:        8D 78 1B      STA.W $1B78               
CODE_04936C:        BD 86 90      LDA.W DATA_049086,X       
CODE_04936F:        29 FF 00      AND.W #$00FF              
CODE_049372:        80 10         BRA CODE_049384           

CODE_049374:        CA            DEX                       
CODE_049375:        30 03         BMI CODE_04937A           
CODE_049377:        82 9B FF      BRL CODE_049315           
CODE_04937A:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04937C:        9C D5 0D      STZ.W $0DD5               
CODE_04937F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_049381:        4C 11 94      JMP.W CODE_049411         

CODE_049384:        8D C1 13      STA.W $13C1               
CODE_049387:        85 00         STA $00                   
CODE_049389:        64 02         STZ $02                   
CODE_04938B:        A2 17 00      LDX.W #$0017              
CODE_04938E:        BD 3C A0      LDA.W DATA_04A03C,X       
CODE_049391:        29 FF 00      AND.W #$00FF              
CODE_049394:        C5 00         CMP $00                   
CODE_049396:        D0 1D         BNE CODE_0493B5           
CODE_049398:        BD E4 A0      LDA.W DATA_04A0E4,X       
CODE_04939B:        18            CLC                       
CODE_04939C:        6D D6 0D      ADC.W $0DD6               
CODE_04939F:        48            PHA                       
CODE_0493A0:        8A            TXA                       
CODE_0493A1:        0A            ASL                       
CODE_0493A2:        0A            ASL                       
CODE_0493A3:        AA            TAX                       
CODE_0493A4:        BD 84 A0      LDA.W DATA_04A084,X       
CODE_0493A7:        85 00         STA $00                   
CODE_0493A9:        BD 86 A0      LDA.W DATA_04A086,X       
CODE_0493AC:        85 02         STA $02                   
CODE_0493AE:        68            PLA                       
CODE_0493AF:        29 FF 00      AND.W #$00FF              
CODE_0493B2:        AA            TAX                       
CODE_0493B3:        80 25         BRA CODE_0493DA           

CODE_0493B5:        CA            DEX                       
CODE_0493B6:        10 D6         BPL CODE_04938E           
CODE_0493B8:        A2 08 00      LDX.W #$0008              
CODE_0493BB:        98            TYA                       
CODE_0493BC:        29 02 00      AND.W #$0002              
CODE_0493BF:        D0 06         BNE CODE_0493C7           
CODE_0493C1:        8A            TXA                       
CODE_0493C2:        49 FF FF      EOR.W #$FFFF              
CODE_0493C5:        1A            INC A                     
CODE_0493C6:        AA            TAX                       
CODE_0493C7:        86 00         STX $00                   
CODE_0493C9:        A2 00 00      LDX.W #$0000              
CODE_0493CC:        C0 04 00      CPY.W #$0004              
CODE_0493CF:        B0 03         BCS CODE_0493D4           
CODE_0493D1:        A2 02 00      LDX.W #$0002              
CODE_0493D4:        8A            TXA                       
CODE_0493D5:        18            CLC                       
CODE_0493D6:        6D D6 0D      ADC.W $0DD6               
CODE_0493D9:        AA            TAX                       
CODE_0493DA:        A5 00         LDA $00                   
CODE_0493DC:        18            CLC                       
CODE_0493DD:        7D 17 1F      ADC.W $1F17,X             
CODE_0493E0:        9D C7 0D      STA.W $0DC7,X             
CODE_0493E3:        8A            TXA                       
CODE_0493E4:        49 02 00      EOR.W #$0002              
CODE_0493E7:        AA            TAX                       
CODE_0493E8:        A5 02         LDA $02                   
CODE_0493EA:        18            CLC                       
CODE_0493EB:        7D 17 1F      ADC.W $1F17,X             
CODE_0493EE:        9D C7 0D      STA.W $0DC7,X             
CODE_0493F1:        8A            TXA                       
CODE_0493F2:        4A            LSR                       
CODE_0493F3:        29 02 00      AND.W #$0002              
CODE_0493F6:        AA            TAX                       
CODE_0493F7:        98            TYA                       
CODE_0493F8:        85 00         STA $00                   
CODE_0493FA:        BD 13 1F      LDA.W $1F13,X             
CODE_0493FD:        29 08 00      AND.W #$0008              
CODE_049400:        05 00         ORA $00                   
CODE_049402:        9D 13 1F      STA.W $1F13,X             
CODE_049405:        A9 0F 00      LDA.W #$000F              
CODE_049408:        8D 4E 14      STA.W $144E               
CODE_04940B:        EE D9 13      INC.W $13D9               
CODE_04940E:        9C 44 14      STZ.W $1444               
CODE_049411:        4C 31 98      JMP.W CODE_049831         


DATA_049414:                      .db $0D,$08

DATA_049416:                      .db $EF,$FF,$D7,$FF

DATA_04941A:                      .db $11,$01,$31,$01

DATA_04941E:                      .db $08,$00,$04,$00,$02,$00,$01,$00
DATA_049426:                      .db $44,$43,$45,$46,$47,$48,$25,$40
                                  .db $42,$4D

DATA_049430:                      .db $0C

DATA_049431:                      .db $00,$0E,$00,$10,$06,$12,$00,$18
                                  .db $04,$1A,$02,$20,$06,$42,$06,$4E
                                  .db $04,$50,$02,$58,$06,$5A,$00,$70
                                  .db $06,$90,$00,$A0,$06

DATA_04944E:                      .db $01,$01,$00,$01,$01,$00,$00,$00
                                  .db $01,$00,$00,$01,$00,$01,$00

CODE_04945D:        AD D8 0D      LDA.W $0DD8               ; Accum (8 bit) 
CODE_049460:        F0 06         BEQ CODE_049468           
CODE_049462:        A9 08         LDA.B #$08                
CODE_049464:        8D D9 13      STA.W $13D9               
Return049467:       60            RTS                       ; Return 

CODE_049468:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04946A:        AD D6 0D      LDA.W $0DD6               
CODE_04946D:        18            CLC                       
CODE_04946E:        69 02 00      ADC.W #$0002              
CODE_049471:        A8            TAY                       
CODE_049472:        A2 02 00      LDX.W #$0002              
CODE_049475:        B9 C7 0D      LDA.W $0DC7,Y             
CODE_049478:        38            SEC                       
CODE_049479:        F9 17 1F      SBC.W $1F17,Y             
CODE_04947C:        95 00         STA $00,X                 
CODE_04947E:        10 04         BPL CODE_049484           
CODE_049480:        49 FF FF      EOR.W #$FFFF              
CODE_049483:        1A            INC A                     
CODE_049484:        95 04         STA $04,X                 
CODE_049486:        88            DEY                       
CODE_049487:        88            DEY                       
CODE_049488:        CA            DEX                       
CODE_049489:        CA            DEX                       
CODE_04948A:        10 E9         BPL CODE_049475           
CODE_04948C:        A0 FF FF      LDY.W #$FFFF              
CODE_04948F:        A5 04         LDA $04                   
CODE_049491:        85 0A         STA $0A                   
CODE_049493:        A5 06         LDA $06                   
CODE_049495:        85 0C         STA $0C                   
CODE_049497:        C5 04         CMP $04                   
CODE_049499:        90 09         BCC CODE_0494A4           
CODE_04949B:        85 0A         STA $0A                   
CODE_04949D:        A5 04         LDA $04                   
CODE_04949F:        85 0C         STA $0C                   
CODE_0494A1:        A0 01 00      LDY.W #$0001              
CODE_0494A4:        84 08         STY $08                   
CODE_0494A6:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0494A8:        AE 80 1B      LDX.W $1B80               
CODE_0494AB:        BD 14 94      LDA.W DATA_049414,X       
CODE_0494AE:        0A            ASL                       
CODE_0494AF:        0A            ASL                       
CODE_0494B0:        0A            ASL                       
CODE_0494B1:        0A            ASL                       
CODE_0494B2:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_0494B5:        A5 0C         LDA $0C                   
CODE_0494B7:        F0 21         BEQ CODE_0494DA           
CODE_0494B9:        8D 03 42      STA.W $4203               ; Multplier B
CODE_0494BC:        EA            NOP                       
CODE_0494BD:        EA            NOP                       
CODE_0494BE:        EA            NOP                       
CODE_0494BF:        EA            NOP                       
CODE_0494C0:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0494C2:        AD 16 42      LDA.W $4216               ; Product/Remainder Result (Low Byte)
CODE_0494C5:        8D 04 42      STA.W $4204               ; Dividend (Low Byte)
CODE_0494C8:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0494CA:        A5 0A         LDA $0A                   
CODE_0494CC:        8D 06 42      STA.W $4206               ; Divisor B
CODE_0494CF:        EA            NOP                       
CODE_0494D0:        EA            NOP                       
CODE_0494D1:        EA            NOP                       
CODE_0494D2:        EA            NOP                       
CODE_0494D3:        EA            NOP                       
CODE_0494D4:        EA            NOP                       
CODE_0494D5:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0494D7:        AD 14 42      LDA.W $4214               ; Quotient of Divide Result (Low Byte)
CODE_0494DA:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0494DC:        85 0E         STA $0E                   
CODE_0494DE:        AE 80 1B      LDX.W $1B80               
CODE_0494E1:        BD 14 94      LDA.W DATA_049414,X       
CODE_0494E4:        29 FF 00      AND.W #$00FF              
CODE_0494E7:        0A            ASL                       
CODE_0494E8:        0A            ASL                       
CODE_0494E9:        0A            ASL                       
CODE_0494EA:        0A            ASL                       
CODE_0494EB:        85 0A         STA $0A                   
CODE_0494ED:        A2 02 00      LDX.W #$0002              
CODE_0494F0:        A5 08         LDA $08                   
CODE_0494F2:        30 04         BMI CODE_0494F8           
CODE_0494F4:        A5 0A         LDA $0A                   
CODE_0494F6:        80 02         BRA CODE_0494FA           

CODE_0494F8:        A5 0E         LDA $0E                   
CODE_0494FA:        34 00         BIT $00,X                 
CODE_0494FC:        10 04         BPL CODE_049502           
CODE_0494FE:        49 FF FF      EOR.W #$FFFF              
CODE_049501:        1A            INC A                     
CODE_049502:        9D CF 0D      STA.W $0DCF,X             
CODE_049505:        A5 08         LDA $08                   
CODE_049507:        49 FF FF      EOR.W #$FFFF              
CODE_04950A:        1A            INC A                     
CODE_04950B:        85 08         STA $08                   
CODE_04950D:        CA            DEX                       
CODE_04950E:        CA            DEX                       
CODE_04950F:        10 DF         BPL CODE_0494F0           
CODE_049511:        A2 00 00      LDX.W #$0000              
CODE_049514:        A5 08         LDA $08                   
CODE_049516:        30 03         BMI CODE_04951B           
CODE_049518:        A2 02 00      LDX.W #$0002              
CODE_04951B:        B5 00         LDA $00,X                 
CODE_04951D:        F0 03         BEQ CODE_049522           
CODE_04951F:        4C 01 98      JMP.W CODE_049801         

CODE_049522:        AD 44 14      LDA.W $1444               
CODE_049525:        F0 35         BEQ CODE_04955C           
CODE_049527:        9C 78 1B      STZ.W $1B78               
CODE_04952A:        AE D6 0D      LDX.W $0DD6               
CODE_04952D:        BD 1F 1F      LDA.W $1F1F,X             
CODE_049530:        85 00         STA $00                   
CODE_049532:        BD 21 1F      LDA.W $1F21,X             
CODE_049535:        85 02         STA $02                   
CODE_049537:        8A            TXA                       
CODE_049538:        4A            LSR                       
CODE_049539:        4A            LSR                       
CODE_04953A:        AA            TAX                       
CODE_04953B:        20 85 98      JSR.W OW_TilePos_Calc     
CODE_04953E:        64 00         STZ $00                   
CODE_049540:        A6 04         LDX $04                   
CODE_049542:        BF 00 D0 7E   LDA.L $7ED000,X           
CODE_049546:        29 FF 00      AND.W #$00FF              
CODE_049549:        0A            ASL                       
CODE_04954A:        AA            TAX                       
CODE_04954B:        BD FC A0      LDA.W LevelNames,X        
CODE_04954E:        85 00         STA $00                   
CODE_049550:        20 07 9D      JSR.W CODE_049D07         
CODE_049553:        EE D9 13      INC.W $13D9               
CODE_049556:        20 37 90      JSR.W CODE_049037         
CODE_049559:        4C 31 98      JMP.W CODE_049831         

CODE_04955C:        AD C1 13      LDA.W $13C1               
CODE_04955F:        8D 7E 1B      STA.W $1B7E               
CODE_049562:        A9 08 00      LDA.W #$0008              
CODE_049565:        85 08         STA $08                   
CODE_049567:        AC D3 0D      LDY.W $0DD3               
CODE_04956A:        98            TYA                       
CODE_04956B:        29 FF 00      AND.W #$00FF              
CODE_04956E:        49 02 00      EOR.W #$0002              
CODE_049571:        85 0A         STA $0A                   
CODE_049573:        80 0D         BRA CODE_049582           

ADDR_049575:        A5 08         LDA $08                   
ADDR_049577:        38            SEC                       
ADDR_049578:        E9 02 00      SBC.W #$0002              
ADDR_04957B:        85 08         STA $08                   
ADDR_04957D:        C5 0A         CMP $0A                   
ADDR_04957F:        F0 F4         BEQ ADDR_049575           
ADDR_049581:        A8            TAY                       
CODE_049582:        AE D6 0D      LDX.W $0DD6               
CODE_049585:        BD 1F 1F      LDA.W $1F1F,X             
CODE_049588:        85 00         STA $00                   
CODE_04958A:        BD 21 1F      LDA.W $1F21,X             
CODE_04958D:        85 02         STA $02                   
CODE_04958F:        A2 00 00      LDX.W #$0000              
CODE_049592:        C0 04 00      CPY.W #$0004              
CODE_049595:        B0 03         BCS CODE_04959A           
CODE_049597:        A2 02 00      LDX.W #$0002              
CODE_04959A:        B5 00         LDA $00,X                 
CODE_04959C:        18            CLC                       
CODE_04959D:        79 58 90      ADC.W DATA_049058,Y       
CODE_0495A0:        95 00         STA $00,X                 
CODE_0495A2:        AD D6 0D      LDA.W $0DD6               
CODE_0495A5:        4A            LSR                       
CODE_0495A6:        4A            LSR                       
CODE_0495A7:        AA            TAX                       
CODE_0495A8:        20 85 98      JSR.W OW_TilePos_Calc     
CODE_0495AB:        AD 78 1B      LDA.W $1B78               
CODE_0495AE:        F0 1E         BEQ CODE_0495CE           
CODE_0495B0:        84 06         STY $06                   
CODE_0495B2:        AE 7A 1B      LDX.W $1B7A               
CODE_0495B5:        E8            INX                       
CODE_0495B6:        BD CA 90      LDA.W DATA_0490CA,X       
CODE_0495B9:        29 FF 00      AND.W #$00FF              
CODE_0495BC:        C5 06         CMP $06                   
CODE_0495BE:        D0 B5         BNE ADDR_049575           
CODE_0495C0:        8E 7A 1B      STX.W $1B7A               
CODE_0495C3:        BD 86 90      LDA.W DATA_049086,X       
CODE_0495C6:        29 FF 00      AND.W #$00FF              
CODE_0495C9:        C9 58 00      CMP.W #$0058              
CODE_0495CC:        D0 10         BNE CODE_0495DE           
CODE_0495CE:        A6 04         LDX $04                   
CODE_0495D0:        30 A3         BMI ADDR_049575           
CODE_0495D2:        C9 00 08      CMP.W #$0800              
CODE_0495D5:        B0 9E         BCS ADDR_049575           
CODE_0495D7:        BF 00 C8 7E   LDA.L $7EC800,X           ; \ Load OW tile number 
CODE_0495DB:        29 FF 00      AND.W #$00FF              ; / 
CODE_0495DE:        8D C1 13      STA.W $13C1               ; Set "Current OW tile" 
CODE_0495E1:        F0 92         BEQ ADDR_049575           
CODE_0495E3:        C9 87 00      CMP.W #$0087              
CODE_0495E6:        B0 8D         BCS ADDR_049575           
CODE_0495E8:        48            PHA                       
CODE_0495E9:        5A            PHY                       
CODE_0495EA:        AA            TAX                       
CODE_0495EB:        CA            DEX                       
CODE_0495EC:        A0 00 00      LDY.W #$0000              
CODE_0495EF:        BD EB 9F      LDA.W DATA_049FEB,X       
CODE_0495F2:        85 0E         STA $0E                   
CODE_0495F4:        29 FF 00      AND.W #$00FF              
CODE_0495F7:        C9 14 00      CMP.W #$0014              
CODE_0495FA:        D0 03         BNE CODE_0495FF           
CODE_0495FC:        A0 01 00      LDY.W #$0001              
CODE_0495FF:        8C 80 1B      STY.W $1B80               
CODE_049602:        AE D6 0D      LDX.W $0DD6               
CODE_049605:        A5 00         LDA $00                   
CODE_049607:        9D 1F 1F      STA.W $1F1F,X             
CODE_04960A:        A5 02         LDA $02                   
CODE_04960C:        9D 21 1F      STA.W $1F21,X             
CODE_04960F:        7A            PLY                       
CODE_049610:        68            PLA                       
CODE_049611:        48            PHA                       
CODE_049612:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_049614:        A2 09         LDX.B #$09                
CODE_049616:        DD 26 94      CMP.W DATA_049426,X       
CODE_049619:        D0 2A         BNE CODE_049645           
CODE_04961B:        5A            PHY                       
CODE_04961C:        20 24 9A      JSR.W CODE_049A24         
CODE_04961F:        7A            PLY                       
CODE_049620:        A9 01         LDA.B #$01                
CODE_049622:        8D 9E 1B      STA.W $1B9E               
CODE_049625:        20 07 F4      JSR.W CODE_04F407         
CODE_049628:        9C 8C 1B      STZ.W $1B8C               
CODE_04962B:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04962D:        9C 01 07      STZ.W $0701               
CODE_049630:        A9 00 70      LDA.W #$7000              
CODE_049633:        8D 8D 1B      STA.W $1B8D               
CODE_049636:        A9 00 54      LDA.W #$5400              
CODE_049639:        8D 8F 1B      STA.W $1B8F               
CODE_04963C:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04963E:        A9 0A         LDA.B #$0A                
CODE_049640:        8D D9 13      STA.W $13D9               
CODE_049643:        80 03         BRA CODE_049648           

CODE_049645:        CA            DEX                       
CODE_049646:        10 CE         BPL CODE_049616           
CODE_049648:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04964A:        68            PLA                       
CODE_04964B:        48            PHA                       
CODE_04964C:        C9 56 00      CMP.W #$0056              
CODE_04964F:        B0 03         BCS CODE_049654           
CODE_049651:        4C 1D 97      JMP.W CODE_04971D         

CODE_049654:        C9 80 00      CMP.W #$0080              
CODE_049657:        F0 0A         BEQ CODE_049663           
CODE_049659:        C9 6A 00      CMP.W #$006A              
CODE_04965C:        90 18         BCC CODE_049676           
CODE_04965E:        C9 6E 00      CMP.W #$006E              
CODE_049661:        B0 13         BCS CODE_049676           
CODE_049663:        AD D6 0D      LDA.W $0DD6               
CODE_049666:        4A            LSR                       
CODE_049667:        29 02 00      AND.W #$0002              
CODE_04966A:        AA            TAX                       
CODE_04966B:        BD 13 1F      LDA.W $1F13,X             
CODE_04966E:        09 08 00      ORA.W #$0008              
CODE_049671:        9D 13 1F      STA.W $1F13,X             
CODE_049674:        80 11         BRA CODE_049687           

CODE_049676:        AD D6 0D      LDA.W $0DD6               
CODE_049679:        4A            LSR                       
CODE_04967A:        29 02 00      AND.W #$0002              
CODE_04967D:        AA            TAX                       
CODE_04967E:        BD 13 1F      LDA.W $1F13,X             
CODE_049681:        29 F7 00      AND.W #$00F7              
CODE_049684:        9D 13 1F      STA.W $1F13,X             
CODE_049687:        A9 01 00      LDA.W #$0001              
CODE_04968A:        8D 44 14      STA.W $1444               
CODE_04968D:        AD C1 13      LDA.W $13C1               
CODE_049690:        C9 5F 00      CMP.W #$005F              
CODE_049693:        F0 10         BEQ CODE_0496A5           
CODE_049695:        C9 5B 00      CMP.W #$005B              
CODE_049698:        F0 0B         BEQ CODE_0496A5           
CODE_04969A:        C9 82 00      CMP.W #$0082              
CODE_04969D:        F0 06         BEQ CODE_0496A5           
CODE_04969F:        A9 23 00      LDA.W #$0023              
CODE_0496A2:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_0496A5:        EA            NOP                       
CODE_0496A6:        EA            NOP                       
CODE_0496A7:        EA            NOP                       
CODE_0496A8:        AD C1 13      LDA.W $13C1               
CODE_0496AB:        29 FF 00      AND.W #$00FF              
CODE_0496AE:        C9 82 00      CMP.W #$0082              
CODE_0496B1:        F0 1F         BEQ CODE_0496D2           
CODE_0496B3:        5A            PHY                       
CODE_0496B4:        98            TYA                       
CODE_0496B5:        29 FF 00      AND.W #$00FF              
CODE_0496B8:        49 02 00      EOR.W #$0002              
CODE_0496BB:        A8            TAY                       
CODE_0496BC:        64 06         STZ $06                   
CODE_0496BE:        A6 04         LDX $04                   
CODE_0496C0:        BF 00 D0 7E   LDA.L $7ED000,X           
CODE_0496C4:        29 FF 00      AND.W #$00FF              
CODE_0496C7:        AA            TAX                       
CODE_0496C8:        B9 1E 94      LDA.W DATA_04941E,Y       
CODE_0496CB:        1D A2 1E      ORA.W $1EA2,X             
CODE_0496CE:        9D A2 1E      STA.W $1EA2,X             
CODE_0496D1:        7A            PLY                       
CODE_0496D2:        AD D6 0D      LDA.W $0DD6               
CODE_0496D5:        4A            LSR                       
CODE_0496D6:        29 02 00      AND.W #$0002              
CODE_0496D9:        AA            TAX                       
CODE_0496DA:        BD 13 1F      LDA.W $1F13,X             
CODE_0496DD:        29 0C 00      AND.W #$000C              
CODE_0496E0:        85 0E         STA $0E                   
CODE_0496E2:        A9 01 00      LDA.W #$0001              
CODE_0496E5:        85 04         STA $04                   
CODE_0496E7:        AD 7E 1B      LDA.W $1B7E               
CODE_0496EA:        29 FF 00      AND.W #$00FF              
CODE_0496ED:        85 00         STA $00                   
CODE_0496EF:        A2 17 00      LDX.W #$0017              
CODE_0496F2:        BD 3C A0      LDA.W DATA_04A03C,X       
CODE_0496F5:        29 FF 00      AND.W #$00FF              
CODE_0496F8:        C5 00         CMP $00                   
CODE_0496FA:        D0 08         BNE CODE_049704           
CODE_0496FC:        8A            TXA                       
CODE_0496FD:        0A            ASL                       
CODE_0496FE:        AA            TAX                       
CODE_0496FF:        BD 54 A0      LDA.W DATA_04A054,X       
CODE_049702:        80 14         BRA CODE_049718           

CODE_049704:        CA            DEX                       
CODE_049705:        10 EB         BPL CODE_0496F2           
CODE_049707:        A9 00 00      LDA.W #$0000              
CODE_04970A:        09 00 08      ORA.W #$0800              
CODE_04970D:        C0 04 00      CPY.W #$0004              
CODE_049710:        90 06         BCC CODE_049718           
CODE_049712:        A9 00 00      LDA.W #$0000              
CODE_049715:        09 08 00      ORA.W #$0008              
CODE_049718:        A2 00 00      LDX.W #$0000              
CODE_04971B:        80 0B         BRA CODE_049728           

CODE_04971D:        3A            DEC A                     
CODE_04971E:        0A            ASL                       
CODE_04971F:        AA            TAX                       
CODE_049720:        BD 49 9F      LDA.W DATA_049F49,X       
CODE_049723:        85 04         STA $04                   
CODE_049725:        BD A7 9E      LDA.W DATA_049EA7,X       
CODE_049728:        85 00         STA $00                   
CODE_04972A:        8A            TXA                       
CODE_04972B:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04972D:        A2 1C 00      LDX.W #$001C              
CODE_049730:        DD 30 94      CMP.W DATA_049430,X       
CODE_049733:        F0 06         BEQ CODE_04973B           
CODE_049735:        CA            DEX                       
CODE_049736:        CA            DEX                       
CODE_049737:        10 F7         BPL CODE_049730           
CODE_049739:        80 0F         BRA CODE_04974A           

CODE_04973B:        98            TYA                       
CODE_04973C:        DD 31 94      CMP.W DATA_049431,X       
CODE_04973F:        F0 09         BEQ CODE_04974A           
CODE_049741:        8A            TXA                       
CODE_049742:        4A            LSR                       
CODE_049743:        AA            TAX                       
CODE_049744:        BD 4E 94      LDA.W DATA_04944E,X       
CODE_049747:        AA            TAX                       
CODE_049748:        80 0B         BRA CODE_049755           

CODE_04974A:        A2 00 00      LDX.W #$0000              
CODE_04974D:        98            TYA                       
CODE_04974E:        29 02         AND.B #$02                
CODE_049750:        F0 03         BEQ CODE_049755           
CODE_049752:        A2 01 00      LDX.W #$0001              
CODE_049755:        B5 04         LDA $04,X                 
CODE_049757:        F0 0E         BEQ CODE_049767           
CODE_049759:        A5 00         LDA $00                   
CODE_04975B:        49 FF         EOR.B #$FF                
CODE_04975D:        1A            INC A                     
CODE_04975E:        85 00         STA $00                   
CODE_049760:        A5 01         LDA $01                   
CODE_049762:        49 FF         EOR.B #$FF                
CODE_049764:        1A            INC A                     
CODE_049765:        85 01         STA $01                   
CODE_049767:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_049769:        68            PLA                       
CODE_04976A:        A2 00 00      LDX.W #$0000              
CODE_04976D:        A5 0E         LDA $0E                   
CODE_04976F:        29 07 00      AND.W #$0007              
CODE_049772:        D0 03         BNE CODE_049777           
CODE_049774:        A2 01 00      LDX.W #$0001              
CODE_049777:        A5 0E         LDA $0E                   
CODE_049779:        29 FF 00      AND.W #$00FF              
CODE_04977C:        85 04         STA $04                   
CODE_04977E:        B5 00         LDA $00,X                 
CODE_049780:        29 FF 00      AND.W #$00FF              
CODE_049783:        C9 80 00      CMP.W #$0080              
CODE_049786:        B0 08         BCS CODE_049790           
CODE_049788:        A5 04         LDA $04                   
CODE_04978A:        18            CLC                       
CODE_04978B:        69 02 00      ADC.W #$0002              
CODE_04978E:        85 04         STA $04                   
CODE_049790:        AD D6 0D      LDA.W $0DD6               
CODE_049793:        4A            LSR                       
CODE_049794:        29 02 00      AND.W #$0002              
CODE_049797:        AA            TAX                       
CODE_049798:        A5 04         LDA $04                   
CODE_04979A:        9D 13 1F      STA.W $1F13,X             
CODE_04979D:        AE D6 0D      LDX.W $0DD6               
CODE_0497A0:        A5 00         LDA $00                   
CODE_0497A2:        29 FF 00      AND.W #$00FF              
CODE_0497A5:        C9 80 00      CMP.W #$0080              
CODE_0497A8:        90 03         BCC CODE_0497AD           
CODE_0497AA:        09 00 FF      ORA.W #$FF00              
CODE_0497AD:        18            CLC                       
CODE_0497AE:        7D 17 1F      ADC.W $1F17,X             
CODE_0497B1:        29 FC FF      AND.W #$FFFC              
CODE_0497B4:        9D C7 0D      STA.W $0DC7,X             
CODE_0497B7:        A5 01         LDA $01                   
CODE_0497B9:        29 FF 00      AND.W #$00FF              
CODE_0497BC:        C9 80 00      CMP.W #$0080              
CODE_0497BF:        90 03         BCC CODE_0497C4           
CODE_0497C1:        09 00 FF      ORA.W #$FF00              
CODE_0497C4:        18            CLC                       
CODE_0497C5:        7D 19 1F      ADC.W $1F19,X             
CODE_0497C8:        29 FC FF      AND.W #$FFFC              
CODE_0497CB:        9D C9 0D      STA.W $0DC9,X             
CODE_0497CE:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0497D0:        BD C7 0D      LDA.W $0DC7,X             
CODE_0497D3:        29 0F         AND.B #$0F                
CODE_0497D5:        D0 0C         BNE CODE_0497E3           
CODE_0497D7:        A0 04 00      LDY.W #$0004              
CODE_0497DA:        A5 00         LDA $00                   
CODE_0497DC:        30 03         BMI CODE_0497E1           
CODE_0497DE:        A0 06 00      LDY.W #$0006              
CODE_0497E1:        80 11         BRA CODE_0497F4           

CODE_0497E3:        BD C9 0D      LDA.W $0DC9,X             
CODE_0497E6:        29 0F         AND.B #$0F                
CODE_0497E8:        D0 0A         BNE CODE_0497F4           
CODE_0497EA:        A0 00 00      LDY.W #$0000              
CODE_0497ED:        A5 01         LDA $01                   
CODE_0497EF:        30 03         BMI CODE_0497F4           
CODE_0497F1:        A0 02 00      LDY.W #$0002              
CODE_0497F4:        8C D3 0D      STY.W $0DD3               
CODE_0497F7:        AD D9 13      LDA.W $13D9               
CODE_0497FA:        C9 0A         CMP.B #$0A                
CODE_0497FC:        F0 33         BEQ CODE_049831           
CODE_0497FE:        4C 5D 94      JMP.W CODE_04945D         

CODE_049801:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_049803:        AD D6 0D      LDA.W $0DD6               
CODE_049806:        18            CLC                       
CODE_049807:        69 02 00      ADC.W #$0002              
CODE_04980A:        AA            TAX                       
CODE_04980B:        A0 02 00      LDY.W #$0002              
CODE_04980E:        B9 D5 13      LDA.W $13D5,Y             
CODE_049811:        29 FF 00      AND.W #$00FF              
CODE_049814:        18            CLC                       
CODE_049815:        79 CF 0D      ADC.W $0DCF,Y             
CODE_049818:        99 D5 13      STA.W $13D5,Y             
CODE_04981B:        29 00 FF      AND.W #$FF00              
CODE_04981E:        10 03         BPL CODE_049823           
CODE_049820:        09 FF 00      ORA.W #$00FF              
CODE_049823:        EB            XBA                       
CODE_049824:        18            CLC                       
CODE_049825:        7D 17 1F      ADC.W $1F17,X             
CODE_049828:        9D 17 1F      STA.W $1F17,X             
CODE_04982B:        CA            DEX                       
CODE_04982C:        CA            DEX                       
CODE_04982D:        88            DEY                       
CODE_04982E:        88            DEY                       
CODE_04982F:        10 DD         BPL CODE_04980E           
CODE_049831:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_049833:        AD D9 13      LDA.W $13D9               
CODE_049836:        C9 0A         CMP.B #$0A                
CODE_049838:        F0 48         BEQ CODE_049882           
CODE_04983A:        AD A0 1B      LDA.W $1BA0               
CODE_04983D:        D0 43         BNE CODE_049882           
CODE_04983F:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_049841:        AE D6 0D      LDX.W $0DD6               
CODE_049844:        BD 17 1F      LDA.W $1F17,X             
CODE_049847:        85 00         STA $00                   
CODE_049849:        BD 19 1F      LDA.W $1F19,X             
CODE_04984C:        85 02         STA $02                   
CODE_04984E:        8A            TXA                       
CODE_04984F:        4A            LSR                       
CODE_049850:        4A            LSR                       
CODE_049851:        AA            TAX                       
CODE_049852:        BD 11 1F      LDA.W $1F11,X             
CODE_049855:        29 FF 00      AND.W #$00FF              
CODE_049858:        D0 28         BNE CODE_049882           
CODE_04985A:        A2 02 00      LDX.W #$0002              
CODE_04985D:        9B            TXY                       
CODE_04985E:        B5 00         LDA $00,X                 
CODE_049860:        38            SEC                       
CODE_049861:        E9 80 00      SBC.W #$0080              
CODE_049864:        10 0A         BPL CODE_049870           
CODE_049866:        D9 16 94      CMP.W DATA_049416,Y       
CODE_049869:        B0 0D         BCS CODE_049878           
CODE_04986B:        B9 16 94      LDA.W DATA_049416,Y       
CODE_04986E:        80 08         BRA CODE_049878           

CODE_049870:        D9 1A 94      CMP.W DATA_04941A,Y       
CODE_049873:        90 03         BCC CODE_049878           
CODE_049875:        B9 1A 94      LDA.W DATA_04941A,Y       
CODE_049878:        95 1A         STA RAM_ScreenBndryXLo,X  
CODE_04987A:        95 1E         STA $1E,X                 
CODE_04987C:        88            DEY                       
CODE_04987D:        88            DEY                       
CODE_04987E:        CA            DEX                       
CODE_04987F:        CA            DEX                       
CODE_049880:        10 DC         BPL CODE_04985E           
CODE_049882:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return049884:       60            RTS                       ; Return 

OW_TilePos_Calc:    A5 00         LDA $00                   ; Get overworld X pos/16 (X) ; Accum (16 bit) 
CODE_049887:        29 0F 00      AND.W #$000F              ; \ 
CODE_04988A:        85 04         STA $04                   ;  | 
CODE_04988C:        A5 00         LDA $00                   ;  | 
CODE_04988E:        29 10 00      AND.W #$0010              ;  | 
CODE_049891:        0A            ASL                       ;  |Set tile pos to ((X&0xF)+((X&0x10)<<4)) 
CODE_049892:        0A            ASL                       ;  | 
CODE_049893:        0A            ASL                       ;  | 
CODE_049894:        0A            ASL                       ;  | 
CODE_049895:        65 04         ADC $04                   ;  | 
CODE_049897:        85 04         STA $04                   ; / 
CODE_049899:        A5 02         LDA $02                   ; Get overworld Y pos/16 (Y) 
CODE_04989B:        0A            ASL                       ; \ 
CODE_04989C:        0A            ASL                       ;  | 
CODE_04989D:        0A            ASL                       ;  |Increase tile pos by ((Y<<4)&0xFF) 
CODE_04989E:        0A            ASL                       ;  | 
CODE_04989F:        29 FF 00      AND.W #$00FF              ;  | 
CODE_0498A2:        65 04         ADC $04                   ;  | 
CODE_0498A4:        85 04         STA $04                   ; / 
CODE_0498A6:        A5 02         LDA $02                   ; \ 
CODE_0498A8:        29 10 00      AND.W #$0010              ;  | 
CODE_0498AB:        F0 08         BEQ CODE_0498B5           ;  |If (Y&0x10) isn't 0, 
CODE_0498AD:        A5 04         LDA $04                   ;  |increase tile pos by x200 
CODE_0498AF:        18            CLC                       ;  | 
CODE_0498B0:        69 00 02      ADC.W #$0200              ;  | 
CODE_0498B3:        85 04         STA $04                   ; / 
CODE_0498B5:        BD 11 1F      LDA.W $1F11,X             ; \ 
CODE_0498B8:        29 FF 00      AND.W #$00FF              ;  | 
CODE_0498BB:        F0 08         BEQ Return0498C5          ;  |If on submap, 
CODE_0498BD:        A5 04         LDA $04                   ;  |Increase tile pos by x400 
CODE_0498BF:        18            CLC                       ;  | 
CODE_0498C0:        69 00 04      ADC.W #$0400              ;  | 
CODE_0498C3:        85 04         STA $04                   ; / 
Return0498C5:       60            RTS                       ; Return 

CODE_0498C6:        9C 13 1F      STZ.W $1F13               ; Accum (8 bit) 
CODE_0498C9:        A9 80         LDA.B #$80                
CODE_0498CB:        18            CLC                       
CODE_0498CC:        6D D7 13      ADC.W $13D7               
CODE_0498CF:        8D D7 13      STA.W $13D7               
CODE_0498D2:        08            PHP                       
CODE_0498D3:        A9 0F         LDA.B #$0F                
CODE_0498D5:        C9 08         CMP.B #$08                
CODE_0498D7:        A0 00         LDY.B #$00                
CODE_0498D9:        90 03         BCC CODE_0498DE           
CODE_0498DB:        09 F0         ORA.B #$F0                
CODE_0498DD:        88            DEY                       
CODE_0498DE:        28            PLP                       
CODE_0498DF:        6D 19 1F      ADC.W $1F19               
CODE_0498E2:        8D 19 1F      STA.W $1F19               
CODE_0498E5:        98            TYA                       
CODE_0498E6:        6D 1A 1F      ADC.W $1F1A               
CODE_0498E9:        8D 1A 1F      STA.W $1F1A               
CODE_0498EC:        AD 19 1F      LDA.W $1F19               
CODE_0498EF:        C9 78         CMP.B #$78                
CODE_0498F1:        D0 07         BNE Return0498FA          
CODE_0498F3:        9C D9 13      STZ.W $13D9               
CODE_0498F6:        22 C9 9B 00   JSL.L CODE_009BC9         
Return0498FA:       60            RTS                       ; Return 


DATA_0498FB:                      .db $08,$00,$04,$00,$02,$00,$01,$00

CODE_049903:        AE D5 0D      LDX.W $0DD5               
CODE_049906:        F0 BD         BEQ Return0498C5          
CODE_049908:        30 BB         BMI Return0498C5          
CODE_04990A:        CA            DEX                       
CODE_04990B:        BD 60 90      LDA.W DATA_049060,X       
CODE_04990E:        85 08         STA $08                   
CODE_049910:        64 09         STZ $09                   
CODE_049912:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_049914:        AE D6 0D      LDX.W $0DD6               
CODE_049917:        BD 17 1F      LDA.W $1F17,X             
CODE_04991A:        4A            LSR                       
CODE_04991B:        4A            LSR                       
CODE_04991C:        4A            LSR                       
CODE_04991D:        4A            LSR                       
CODE_04991E:        85 00         STA $00                   
CODE_049920:        9D 1F 1F      STA.W $1F1F,X             
CODE_049923:        BD 19 1F      LDA.W $1F19,X             
CODE_049926:        4A            LSR                       
CODE_049927:        4A            LSR                       
CODE_049928:        4A            LSR                       
CODE_049929:        4A            LSR                       
CODE_04992A:        85 02         STA $02                   
CODE_04992C:        9D 21 1F      STA.W $1F21,X             
CODE_04992F:        8A            TXA                       
CODE_049930:        4A            LSR                       
CODE_049931:        4A            LSR                       
CODE_049932:        AA            TAX                       
CODE_049933:        20 85 98      JSR.W OW_TilePos_Calc     
CODE_049936:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_049938:        A6 04         LDX $04                   
CODE_04993A:        BF 00 D8 7E   LDA.L $7ED800,X           
CODE_04993E:        29 FF 00      AND.W #$00FF              
CODE_049941:        A6 08         LDX $08                   
CODE_049943:        F0 04         BEQ CODE_049949           
CODE_049945:        4A            LSR                       
CODE_049946:        CA            DEX                       
CODE_049947:        10 FC         BPL CODE_049945           
CODE_049949:        29 03 00      AND.W #$0003              
CODE_04994C:        0A            ASL                       
CODE_04994D:        A8            TAY                       
CODE_04994E:        A6 04         LDX $04                   
CODE_049950:        BF 00 D0 7E   LDA.L $7ED000,X           
CODE_049954:        29 FF 00      AND.W #$00FF              
CODE_049957:        AA            TAX                       
CODE_049958:        B9 1E 94      LDA.W DATA_04941E,Y       
CODE_04995B:        1D A2 1E      ORA.W $1EA2,X             
CODE_04995E:        9D A2 1E      STA.W $1EA2,X             
CODE_049961:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return049963:       60            RTS                       ; Return 


DATA_049964:                      .db $40,$01

DATA_049966:                      .db $28,$00

DATA_049968:                      .db $00,$50,$01,$58,$00,$00,$10,$00
                                  .db $48,$00,$01,$10,$00,$98,$00,$01
                                  .db $A0,$00,$D8,$00,$00,$40,$01,$58
                                  .db $00,$02,$90,$00,$E8,$01,$04,$60
                                  .db $01,$E8,$00,$00,$A0,$00,$C8,$01
                                  .db $00,$60,$01,$88,$00,$03,$08,$01
                                  .db $90,$01,$00,$E8,$01,$10,$00,$03
                                  .db $10,$01,$C8,$01,$00,$F0,$01,$88
                                  .db $00,$03

DATA_0499AA:                      .db $00,$00

DATA_0499AC:                      .db $48,$00

DATA_0499AE:                      .db $01,$00,$00,$98,$00,$01,$50,$01
                                  .db $28,$00,$00,$60,$01,$58,$00,$00
                                  .db $50,$01,$58,$00,$02,$90,$00,$D8
                                  .db $00,$00,$50,$01,$E8,$00,$00,$A0
                                  .db $00,$E8,$01,$04,$50,$01,$88,$00
                                  .db $03,$B0,$00,$C8,$01,$00,$E8,$01
                                  .db $00,$00,$03,$08,$01,$A0,$01,$00
                                  .db $00,$02,$88,$00,$03,$00,$01,$C8
                                  .db $01,$00

DATA_0499F0:                      .db $00

DATA_0499F1:                      .db $04,$00,$09,$14,$02,$15,$05,$14
                                  .db $05,$09,$0D,$15,$0E,$09,$1E,$15
                                  .db $08,$0A,$1C,$1E,$00,$10,$19,$1F
                                  .db $08,$10,$1C

DATA_049A0C:                      .db $EF,$FF

DATA_049A0E:                      .db $D8,$FF,$EF,$FF,$80,$00,$EF,$FF
                                  .db $28,$01,$F0,$00,$D8,$FF,$F0,$00
                                  .db $80,$00,$F0,$00,$28,$01

CODE_049A24:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_049A26:        AD D6 0D      LDA.W $0DD6               
CODE_049A29:        4A            LSR                       
CODE_049A2A:        4A            LSR                       
CODE_049A2B:        AA            TAX                       
CODE_049A2C:        BD 11 1F      LDA.W $1F11,X             
CODE_049A2F:        29 FF 00      AND.W #$00FF              
CODE_049A32:        8D C3 13      STA.W $13C3               
CODE_049A35:        A9 1A 00      LDA.W #$001A              
CODE_049A38:        85 02         STA $02                   
CODE_049A3A:        A0 41         LDY.B #$41                
CODE_049A3C:        AE D6 0D      LDX.W $0DD6               
CODE_049A3F:        BD 19 1F      LDA.W $1F19,X             
CODE_049A42:        D9 64 99      CMP.W DATA_049964,Y       
CODE_049A45:        D0 3E         BNE CODE_049A85           
CODE_049A47:        BD 17 1F      LDA.W $1F17,X             
CODE_049A4A:        D9 66 99      CMP.W DATA_049966,Y       
CODE_049A4D:        D0 36         BNE CODE_049A85           
CODE_049A4F:        B9 68 99      LDA.W DATA_049968,Y       
CODE_049A52:        29 FF 00      AND.W #$00FF              
CODE_049A55:        CD C3 13      CMP.W $13C3               
CODE_049A58:        D0 2B         BNE CODE_049A85           
CODE_049A5A:        B9 AA 99      LDA.W DATA_0499AA,Y       
CODE_049A5D:        9D 19 1F      STA.W $1F19,X             
CODE_049A60:        B9 AC 99      LDA.W DATA_0499AC,Y       
CODE_049A63:        9D 17 1F      STA.W $1F17,X             
CODE_049A66:        B9 AE 99      LDA.W DATA_0499AE,Y       
CODE_049A69:        29 FF 00      AND.W #$00FF              
CODE_049A6C:        8D C3 13      STA.W $13C3               
CODE_049A6F:        A4 02         LDY $02                   
CODE_049A71:        B9 F0 99      LDA.W DATA_0499F0,Y       
CODE_049A74:        29 FF 00      AND.W #$00FF              
CODE_049A77:        9D 21 1F      STA.W $1F21,X             
CODE_049A7A:        B9 F1 99      LDA.W DATA_0499F1,Y       
CODE_049A7D:        29 FF 00      AND.W #$00FF              
CODE_049A80:        9D 1F 1F      STA.W $1F1F,X             
CODE_049A83:        80 0B         BRA CODE_049A90           

CODE_049A85:        C6 02         DEC $02                   
CODE_049A87:        C6 02         DEC $02                   
CODE_049A89:        88            DEY                       
CODE_049A8A:        88            DEY                       
CODE_049A8B:        88            DEY                       
CODE_049A8C:        88            DEY                       
CODE_049A8D:        88            DEY                       
CODE_049A8E:        10 AF         BPL CODE_049A3F           
CODE_049A90:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return049A92:       60            RTS                       ; Return 

CODE_049A93:        AD D6 0D      LDA.W $0DD6               ; Accum (16 bit) 
CODE_049A96:        29 FF 00      AND.W #$00FF              
CODE_049A99:        4A            LSR                       
CODE_049A9A:        4A            LSR                       
CODE_049A9B:        AA            TAX                       
CODE_049A9C:        BD 11 1F      LDA.W $1F11,X             
CODE_049A9F:        29 00 FF      AND.W #$FF00              
CODE_049AA2:        0D C3 13      ORA.W $13C3               
CODE_049AA5:        9D 11 1F      STA.W $1F11,X             
CODE_049AA8:        29 FF 00      AND.W #$00FF              
CODE_049AAB:        D0 03         BNE CODE_049AB0           
CODE_049AAD:        4C 3F 98      JMP.W CODE_04983F         

CODE_049AB0:        3A            DEC A                     
CODE_049AB1:        0A            ASL                       
CODE_049AB2:        0A            ASL                       
CODE_049AB3:        A8            TAY                       
CODE_049AB4:        B9 0C 9A      LDA.W DATA_049A0C,Y       
CODE_049AB7:        85 1A         STA RAM_ScreenBndryXLo    
CODE_049AB9:        85 1E         STA $1E                   
CODE_049ABB:        B9 0E 9A      LDA.W DATA_049A0E,Y       
CODE_049ABE:        85 1C         STA RAM_ScreenBndryYLo    
CODE_049AC0:        85 20         STA $20                   
CODE_049AC2:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return049AC4:       60            RTS                       ; Return 


LevelNameStrings:                 .db $18,$0E,$12,$07,$08,$5D,$12,$9F
                                  .db $12,$13,$00,$11,$9F,$5A,$64,$1F
                                  .db $08,$06,$06,$18,$5D,$12,$9F,$5A
                                  .db $65,$1F,$0C,$0E,$11,$13,$0E,$0D
                                  .db $5D,$12,$9F,$5A,$66,$1F,$0B,$04
                                  .db $0C,$0C,$18,$5D,$12,$9F,$5A,$67
                                  .db $1F,$0B,$14,$03,$16,$08,$06,$5D
                                  .db $12,$9F,$5A,$68,$1F,$11,$0E,$18
                                  .db $5D,$12,$9F,$5A,$69,$1F,$16,$04
                                  .db $0D,$03,$18,$5D,$12,$9F,$5A,$6A
                                  .db $1F,$0B,$00,$11,$11,$18,$5D,$12
                                  .db $9F,$03,$0E,$0D,$14,$13,$9F,$06
                                  .db $11,$04,$04,$0D,$9F,$13,$0E,$0F
                                  .db $1F,$12,$04,$02,$11,$04,$13,$1F
                                  .db $00,$11,$04,$00,$9F,$15,$00,$0D
                                  .db $08,$0B,$0B,$00,$9F,$38,$39,$3A
                                  .db $3B,$3C,$9F,$11,$04,$03,$9F,$01
                                  .db $0B,$14,$04,$9F,$01,$14,$13,$13
                                  .db $04,$11,$1F,$01,$11,$08,$03,$06
                                  .db $04,$9F,$02,$07,$04,$04,$12,$04
                                  .db $1F,$01,$11,$08,$03,$06,$04,$9F
                                  .db $12,$0E,$03,$00,$1F,$0B,$00,$0A
                                  .db $04,$9F,$02,$0E,$0E,$0A,$08,$04
                                  .db $1F,$0C,$0E,$14,$0D,$13,$00,$08
                                  .db $0D,$9F,$05,$0E,$11,$04,$12,$13
                                  .db $9F,$02,$07,$0E,$02,$0E,$0B,$00
                                  .db $13,$04,$9F,$02,$07,$0E,$02,$0E
                                  .db $1C,$06,$07,$0E,$12,$13,$1F,$07
                                  .db $0E,$14,$12,$04,$9F,$12,$14,$0D
                                  .db $0A,$04,$0D,$1F,$06,$07,$0E,$12
                                  .db $13,$1F,$12,$07,$08,$0F,$9F,$15
                                  .db $00,$0B,$0B,$04,$18,$9F,$01,$00
                                  .db $02,$0A,$1F,$03,$0E,$0E,$11,$9F
                                  .db $05,$11,$0E,$0D,$13,$1F,$03,$0E
                                  .db $0E,$11,$9F,$06,$0D,$00,$11,$0B
                                  .db $18,$9F,$13,$14,$01,$14,$0B,$00
                                  .db $11,$9F,$16,$00,$18,$1F,$02,$0E
                                  .db $0E,$0B,$9F,$07,$0E,$14,$12,$04
                                  .db $9F,$08,$12,$0B,$00,$0D,$03,$9F
                                  .db $12,$16,$08,$13,$02,$07,$1F,$0F
                                  .db $00,$0B,$00,$02,$04,$9F,$02,$00
                                  .db $12,$13,$0B,$04,$9F,$0F,$0B,$00
                                  .db $08,$0D,$12,$9F,$06,$07,$0E,$12
                                  .db $13,$1F,$07,$0E,$14,$12,$04,$9F
                                  .db $12,$04,$02,$11,$04,$13,$9F,$03
                                  .db $0E,$0C,$04,$9F,$05,$0E,$11,$13
                                  .db $11,$04,$12,$12,$9F,$0E,$05,$32
                                  .db $33,$34,$35,$36,$37,$0E,$0D,$9F
                                  .db $0E,$05,$1F,$01,$0E,$16,$12,$04
                                  .db $11,$9F,$11,$0E,$00,$03,$9F,$16
                                  .db $0E,$11,$0B,$03,$9F,$00,$16,$04
                                  .db $12,$0E,$0C,$04,$9F,$E4,$E5,$E6
                                  .db $E7,$E8,$0F,$00,$0B,$00,$02,$84
                                  .db $00,$11,$04,$80,$06,$11,$0E,$0E
                                  .db $15,$98,$0C,$0E,$0D,$03,$8E,$0E
                                  .db $14,$13,$11,$00,$06,$04,$0E,$14
                                  .db $92,$05,$14,$0D,$0A,$98,$07,$0E
                                  .db $14,$12,$84,$9F

DATA_049C91:                      .db $CB,$01,$00,$00,$08,$00,$0D,$00
                                  .db $17,$00,$23,$00,$2E,$00,$3A,$00
                                  .db $43,$00,$4E,$00,$59,$00,$5F,$00
                                  .db $65,$00,$75,$00,$7D,$00,$83,$00
                                  .db $87,$00,$8C,$00,$9A,$00,$A8,$00
                                  .db $B2,$00,$C2,$00,$C9,$00,$D3,$00
                                  .db $E5,$00,$F7,$00,$FE,$00,$08,$01
                                  .db $13,$01,$1A,$01,$22,$01

DATA_049CCF:                      .db $CB,$01,$2B,$01,$31,$01,$38,$01
                                  .db $46,$01,$4D,$01,$54,$01,$60,$01
                                  .db $67,$01,$6C,$01,$75,$01,$80,$01
                                  .db $8A,$01,$8F,$01,$95,$01

DATA_049CED:                      .db $CB,$01,$9D,$01,$9E,$01,$9F,$01
                                  .db $A0,$01,$A1,$01,$A2,$01,$A8,$01
                                  .db $AC,$01,$B2,$01,$B7,$01,$C1,$01
                                  .db $C6,$01

CODE_049D07:        AF 7B 83 7F   LDA.L $7F837B             ; Index (16 bit) Accum (16 bit) 
CODE_049D0B:        AA            TAX                       
CODE_049D0C:        18            CLC                       
CODE_049D0D:        69 26 00      ADC.W #$0026              
CODE_049D10:        85 02         STA $02                   
CODE_049D12:        18            CLC                       
CODE_049D13:        69 04 00      ADC.W #$0004              
CODE_049D16:        8F 7B 83 7F   STA.L $7F837B             
CODE_049D1A:        A9 00 25      LDA.W #$2500              
CODE_049D1D:        9F 7F 83 7F   STA.L $7F837F,X           
CODE_049D21:        A9 50 8B      LDA.W #$8B50              
CODE_049D24:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_049D28:        A5 01         LDA $01                   
CODE_049D2A:        29 7F 00      AND.W #$007F              
CODE_049D2D:        0A            ASL                       
CODE_049D2E:        A8            TAY                       
CODE_049D2F:        B9 91 9C      LDA.W DATA_049C91,Y       
CODE_049D32:        A8            TAY                       
CODE_049D33:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_049D35:        B9 C5 9A      LDA.W LevelNameStrings,Y  
CODE_049D38:        30 03         BMI CODE_049D3D           
CODE_049D3A:        20 7F 9D      JSR.W CODE_049D7F         
CODE_049D3D:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_049D3F:        A5 00         LDA $00                   
CODE_049D41:        29 F0 00      AND.W #$00F0              
CODE_049D44:        4A            LSR                       
CODE_049D45:        4A            LSR                       
CODE_049D46:        4A            LSR                       
CODE_049D47:        A8            TAY                       
CODE_049D48:        B9 CF 9C      LDA.W DATA_049CCF,Y       
CODE_049D4B:        A8            TAY                       
CODE_049D4C:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_049D4E:        B9 C5 9A      LDA.W LevelNameStrings,Y  
CODE_049D51:        C9 9F         CMP.B #$9F                
CODE_049D53:        F0 03         BEQ CODE_049D58           
CODE_049D55:        20 7F 9D      JSR.W CODE_049D7F         
CODE_049D58:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_049D5A:        A5 00         LDA $00                   
CODE_049D5C:        29 0F 00      AND.W #$000F              
CODE_049D5F:        0A            ASL                       
CODE_049D60:        A8            TAY                       
CODE_049D61:        B9 ED 9C      LDA.W DATA_049CED,Y       
CODE_049D64:        A8            TAY                       
CODE_049D65:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_049D67:        20 7F 9D      JSR.W CODE_049D7F         
CODE_049D6A:        E4 02         CPX $02                   
CODE_049D6C:        B0 08         BCS CODE_049D76           
CODE_049D6E:        A0 CB 01      LDY.W #$01CB              
CODE_049D71:        20 7F 9D      JSR.W CODE_049D7F         
CODE_049D74:        80 F4         BRA CODE_049D6A           

CODE_049D76:        A9 FF         LDA.B #$FF                
CODE_049D78:        9F 81 83 7F   STA.L $7F8381,X           
CODE_049D7C:        C2 20         REP #$20                  ; Accum (16 bit) 
Return049D7E:       60            RTS                       ; Return 

CODE_049D7F:        B9 C5 9A      LDA.W LevelNameStrings,Y  ; Index (8 bit) Accum (8 bit) 
CODE_049D82:        08            PHP                       
CODE_049D83:        E4 02         CPX $02                   
CODE_049D85:        B0 0E         BCS CODE_049D95           
CODE_049D87:        29 7F         AND.B #$7F                
CODE_049D89:        9F 81 83 7F   STA.L $7F8381,X           
CODE_049D8D:        A9 39         LDA.B #$39                
CODE_049D8F:        9F 82 83 7F   STA.L $7F8382,X           
CODE_049D93:        E8            INX                       
CODE_049D94:        E8            INX                       
CODE_049D95:        C8            INY                       
CODE_049D96:        28            PLP                       
CODE_049D97:        10 E6         BPL CODE_049D7F           
Return049D99:       60            RTS                       ; Return 

CODE_049D9A:        AD B2 0D      LDA.W $0DB2               
CODE_049D9D:        F0 10         BEQ CODE_049DAF           
CODE_049D9F:        AD B3 0D      LDA.W $0DB3               
CODE_049DA2:        49 01         EOR.B #$01                
CODE_049DA4:        AA            TAX                       
CODE_049DA5:        BD B4 0D      LDA.W RAM_PlayerLives,X   
CODE_049DA8:        30 05         BMI CODE_049DAF           
CODE_049DAA:        AD D5 0D      LDA.W $0DD5               
CODE_049DAD:        D0 0D         BNE CODE_049DBC           
CODE_049DAF:        A9 03         LDA.B #$03                
CODE_049DB1:        8D D9 13      STA.W $13D9               
CODE_049DB4:        9C D5 0D      STZ.W $0DD5               
CODE_049DB7:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_049DB9:        4C 31 98      JMP.W CODE_049831         

CODE_049DBC:        CE B1 0D      DEC.W $0DB1               ; Index (8 bit) Accum (8 bit) 
CODE_049DBF:        10 0B         BPL CODE_049DCC           
CODE_049DC1:        A9 02         LDA.B #$02                
CODE_049DC3:        8D B1 0D      STA.W $0DB1               
CODE_049DC6:        9C D5 0D      STZ.W $0DD5               
CODE_049DC9:        EE D9 13      INC.W $13D9               
CODE_049DCC:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_049DCE:        4C 31 98      JMP.W CODE_049831         

CODE_049DD1:        AD B3 0D      LDA.W $0DB3               ; Index (8 bit) Accum (8 bit) 
CODE_049DD4:        49 01         EOR.B #$01                
CODE_049DD6:        8D B3 0D      STA.W $0DB3               
CODE_049DD9:        AA            TAX                       
CODE_049DDA:        BD B6 0D      LDA.W RAM_PlayerCoins,X   
CODE_049DDD:        8D BF 0D      STA.W RAM_StatusCoins     
CODE_049DE0:        BD B4 0D      LDA.W RAM_PlayerLives,X   
CODE_049DE3:        8D BE 0D      STA.W RAM_StatusLives     
CODE_049DE6:        BD B8 0D      LDA.W RAM_PlayerPowerUp,X 
CODE_049DE9:        85 19         STA RAM_MarioPowerUp      
CODE_049DEB:        BD BA 0D      LDA.W RAM_PlyrYoshiColor,X 
CODE_049DEE:        8D C1 0D      STA.W RAM_OWHasYoshi      
CODE_049DF1:        8D C7 13      STA.W RAM_YoshiColor      
CODE_049DF4:        8D 7A 18      STA.W RAM_OnYoshi         
CODE_049DF7:        BD BC 0D      LDA.W $0DBC,X             
CODE_049DFA:        8D C2 0D      STA.W $0DC2               
CODE_049DFD:        22 F2 DB 05   JSL.L CODE_05DBF2         
CODE_049E01:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_049E03:        20 55 8E      JSR.W CODE_048E55         
CODE_049E06:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_049E08:        AE B3 0D      LDX.W $0DB3               
CODE_049E0B:        BD 11 1F      LDA.W $1F11,X             
CODE_049E0E:        8D C3 13      STA.W $13C3               
CODE_049E11:        9C C4 13      STZ.W $13C4               
CODE_049E14:        A9 02         LDA.B #$02                
CODE_049E16:        8D B1 0D      STA.W $0DB1               
CODE_049E19:        A9 0A         LDA.B #$0A                
CODE_049E1B:        8D D9 13      STA.W $13D9               
CODE_049E1E:        EE D8 0D      INC.W $0DD8               
Return049E21:       60            RTS                       ; Return 

CODE_049E22:        CE B1 0D      DEC.W $0DB1               
CODE_049E25:        10 24         BPL Return049E4B          
CODE_049E27:        A9 02         LDA.B #$02                
CODE_049E29:        8D B1 0D      STA.W $0DB1               
CODE_049E2C:        AE AF 0D      LDX.W $0DAF               
CODE_049E2F:        AD AE 0D      LDA.W $0DAE               
CODE_049E32:        18            CLC                       
CODE_049E33:        7F 2F 9F 00   ADC.L DATA_009F2F,X       
CODE_049E37:        8D AE 0D      STA.W $0DAE               
CODE_049E3A:        DF 33 9F 00   CMP.L DATA_009F33,X       
CODE_049E3E:        D0 0B         BNE Return049E4B          
CODE_049E40:        EE D9 13      INC.W $13D9               
CODE_049E43:        AD AF 0D      LDA.W $0DAF               
CODE_049E46:        49 01         EOR.B #$01                
CODE_049E48:        8D AF 0D      STA.W $0DAF               
Return049E4B:       60            RTS                       ; Return 

CODE_049E4C:        A9 03         LDA.B #$03                
CODE_049E4E:        8D D9 13      STA.W $13D9               
Return049E51:       60            RTS                       ; Return 

CODE_049E52:        AD F7 1D      LDA.W $1DF7               
CODE_049E55:        D0 0C         BNE CODE_049E63           
CODE_049E57:        EE F8 1D      INC.W $1DF8               
CODE_049E5A:        AD F8 1D      LDA.W $1DF8               
CODE_049E5D:        C9 31         CMP.B #$31                
CODE_049E5F:        D0 32         BNE CODE_049E93           
CODE_049E61:        80 06         BRA CODE_049E69           

CODE_049E63:        A5 13         LDA RAM_FrameCounter      
CODE_049E65:        29 07         AND.B #$07                
CODE_049E67:        D0 0F         BNE CODE_049E78           
CODE_049E69:        EE F7 1D      INC.W $1DF7               
CODE_049E6C:        AD F7 1D      LDA.W $1DF7               
CODE_049E6F:        C9 05         CMP.B #$05                
CODE_049E71:        D0 05         BNE CODE_049E78           
CODE_049E73:        A9 04         LDA.B #$04                
CODE_049E75:        8D F7 1D      STA.W $1DF7               
CODE_049E78:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_049E7A:        AD F7 1D      LDA.W $1DF7               
CODE_049E7D:        29 FF 00      AND.W #$00FF              
CODE_049E80:        85 00         STA $00                   
CODE_049E82:        AE D6 0D      LDX.W $0DD6               
CODE_049E85:        BD 19 1F      LDA.W $1F19,X             
CODE_049E88:        38            SEC                       
CODE_049E89:        E5 00         SBC $00                   
CODE_049E8B:        9D 19 1F      STA.W $1F19,X             
CODE_049E8E:        38            SEC                       
CODE_049E8F:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_049E91:        30 03         BMI CODE_049E96           
CODE_049E93:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return049E95:       60            RTS                       ; Return 

CODE_049E96:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_049E98:        4C 8D 91      JMP.W CODE_04918D         

ADDR_049E9B:        A0 00         LDY.B #$00                ; \ Unreachable 
ADDR_049E9D:        C9 0A         CMP.B #$0A                ;  | While A >= #$0A... 
ADDR_049E9F:        90 05         BCC Return049EA6          ;  | 
ADDR_049EA1:        E9 0A         SBC.B #$0A                ;  | A -= #$0A 
ADDR_049EA3:        C8            INY                       ;  | Y++ 
ADDR_049EA4:        80 F7         BRA ADDR_049E9D           ; / 

Return049EA6:       60            RTS                       ; / Return 


DATA_049EA7:                      .db $10,$F8,$10,$00,$10,$FC,$10,$00
                                  .db $10,$FC,$10,$00,$08,$FC,$0C,$F4
                                  .db $FC,$04,$04,$FC,$F8,$10,$00,$10
                                  .db $FC,$08,$FC,$08,$FC,$10,$00,$10
                                  .db $F8,$04,$FC,$10,$00,$10,$10,$08
                                  .db $10,$04,$10,$04,$08,$04,$0C,$0C
                                  .db $04,$04,$04,$04,$08,$10,$FC,$F8
                                  .db $FC,$F8,$04,$10,$F8,$FC,$04,$10
                                  .db $F4,$F4,$0C,$F4,$10,$00,$00,$10
                                  .db $00,$10,$10,$00,$10,$00,$FC,$08
                                  .db $FC,$08,$00,$10,$10,$FC,$10,$FC
                                  .db $FC,$04,$04,$FC,$F8,$10,$00,$10
                                  .db $FC,$10,$10,$04,$10,$00,$04,$10
                                  .db $04,$04,$FC,$F8,$04,$04,$10,$08
                                  .db $0C,$F4,$00,$10,$FC,$10,$10,$00
                                  .db $04,$10,$10,$F8,$00,$10,$00,$10
                                  .db $FC,$10,$10,$00,$00,$10,$00,$10
                                  .db $00,$10,$00,$10,$00,$10,$00,$10
                                  .db $04,$FC,$04,$04,$04,$04,$00,$10
                                  .db $00,$10,$10,$00,$10,$00,$FC,$10
                                  .db $FC,$04

DATA_049F49:                      .db $01,$00,$01,$00,$01,$00,$01,$00
                                  .db $01,$00,$01,$00,$00,$01,$00,$01
                                  .db $00,$01,$00,$01,$01,$00,$01,$00
                                  .db $00,$01,$01,$00,$01,$00,$01,$00
                                  .db $00,$01,$01,$00,$01,$00,$01,$00
                                  .db $01,$00,$01,$00,$01,$00,$01,$00
                                  .db $01,$00,$01,$00,$01,$00,$00,$01
                                  .db $00,$01,$01,$00,$00,$01,$01,$00
                                  .db $00,$01,$01,$00,$01,$00,$01,$00
                                  .db $01,$00,$01,$00,$01,$00,$00,$01
                                  .db $01,$00,$01,$00,$01,$00,$01,$00
                                  .db $00,$01,$00,$01,$01,$00,$01,$00
                                  .db $01,$00,$01,$00,$01,$00,$01,$00
                                  .db $01,$00,$00,$01,$01,$00,$01,$00
                                  .db $01,$00,$01,$00,$01,$00,$01,$00
                                  .db $01,$00,$01,$00,$01,$00,$01,$00
                                  .db $01,$00,$01,$00,$01,$00,$01,$00
                                  .db $01,$00,$01,$00,$01,$00,$01,$00
                                  .db $00,$01,$01,$00,$01,$00,$01,$00
                                  .db $01,$00,$01,$00,$01,$00,$01,$00
                                  .db $00,$01

DATA_049FEB:                      .db $04,$04,$04,$04,$04,$04,$04,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $04,$00,$00,$04,$04,$04,$04,$00
                                  .db $00,$00,$00,$00,$00,$00,$04,$00
                                  .db $00,$00,$04,$00,$00,$04,$04,$08
                                  .db $08,$08,$0C,$0C,$08,$08,$08,$08
                                  .db $08,$0C,$0C,$08,$08,$08,$08,$0C
                                  .db $08,$08,$08,$0C,$08,$0C,$14,$14
                                  .db $14,$04,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$04,$04,$08
                                  .db $00

DATA_04A03C:                      .db $07,$09,$0A,$0D,$0E,$11,$17,$19
                                  .db $1A,$1C,$1D,$1F,$28,$29,$2D,$2E
                                  .db $35,$36,$37,$49,$4A,$4B,$4D,$51
DATA_04A054:                      .db $08,$FC,$FC,$08,$FC,$08,$FC,$08
                                  .db $FC,$08,$04,$00,$08,$04,$04,$08
                                  .db $04,$08,$04,$00,$04,$08,$04,$00
                                  .db $FC,$08,$00,$00,$FC,$08,$FC,$08
                                  .db $04,$00,$04,$00,$00,$00,$08,$FC
                                  .db $08,$04,$08,$04,$FC,$08,$08,$FC
DATA_04A084:                      .db $04,$00

DATA_04A086:                      .db $F8,$FF,$08,$00,$FC,$FF,$F8,$FF
                                  .db $04,$00,$F8,$FF,$04,$00,$08,$00
                                  .db $FC,$FF,$04,$00,$04,$00,$04,$00
                                  .db $08,$00,$08,$00,$04,$00,$F8,$FF
                                  .db $FC,$FF,$00,$00,$00,$00,$08,$00
                                  .db $04,$00,$04,$00,$04,$00,$F8,$FF
                                  .db $04,$00,$04,$00,$04,$00,$08,$00
                                  .db $FC,$FF,$F8,$FF,$04,$00,$04,$00
                                  .db $04,$00,$00,$00,$00,$00,$04,$00
                                  .db $04,$00,$04,$00,$F8,$FF,$04,$00
                                  .db $08,$00,$FC,$FF,$F8,$FF,$F8,$FF
                                  .db $04,$00,$FC,$FF,$08,$00

DATA_04A0E4:                      .db $02,$02,$02,$02,$02,$00,$02,$02
                                  .db $02,$00,$02,$00,$02,$00,$02,$02
                                  .db $00,$00,$00,$02,$02,$02,$02,$02
LevelNames:                       .db $00,$00,$72,$0D,$73,$0D,$00,$0C
                                  .db $60,$0A,$53,$0A,$54,$0A,$40,$04
                                  .db $30,$0B,$52,$0A,$71,$0A,$90,$0D
                                  .db $01,$11,$02,$11,$40,$06,$07,$12
                                  .db $00,$14,$00,$13,$C0,$02,$7C,$0A
                                  .db $33,$0E,$51,$0A,$C0,$02,$53,$04
                                  .db $00,$18,$53,$04,$40,$08,$90,$16
                                  .db $25,$16,$24,$16,$C0,$02,$90,$15
                                  .db $40,$07,$00,$17,$21,$16,$23,$16
                                  .db $22,$16,$40,$03,$24,$01,$23,$01
                                  .db $10,$01,$21,$01,$22,$01,$60,$0D
                                  .db $C0,$02,$71,$0D,$83,$0D,$72,$0A
                                  .db $C0,$02,$00,$1B,$00,$1A,$B4,$19
                                  .db $40,$09,$90,$19,$00,$00,$B3,$19
                                  .db $60,$19,$B2,$19,$B1,$19,$70,$16
                                  .db $82,$0D,$84,$0D,$81,$0D,$30,$0F
                                  .db $40,$05,$60,$15,$A1,$15,$A4,$15
                                  .db $A2,$15,$30,$10,$77,$15,$A3,$15
                                  .db $C0,$02,$0B,$00,$0A,$00,$09,$00
                                  .db $08,$00,$C0,$02,$00,$1C,$00,$1D
                                  .db $00,$1E,$E0,$00,$C0,$02,$C0,$02
                                  .db $D2,$02,$C0,$02,$D3,$02,$C0,$02
                                  .db $D1,$02,$D4,$02,$D5,$02,$C0,$02
                                  .db $C0,$02,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF

DATA_04A400:                      .db $50,$00,$41,$3E,$FE,$38,$50,$A0
                                  .db $C0,$28,$FE,$38,$50,$A1,$C0,$28
                                  .db $FE,$38,$50,$BE,$C0,$28,$FE,$38
                                  .db $50,$BF,$C0,$28,$FE,$38,$53,$40
                                  .db $41,$7E,$FE,$38,$50,$A2,$00,$01
                                  .db $92,$3C,$50,$A3,$40,$32,$93,$3C
                                  .db $50,$BD,$00,$01,$92,$7C,$50,$C2
                                  .db $C0,$24,$94,$7C,$50,$DD,$C0,$24
                                  .db $94,$3C,$53,$22,$00,$01,$92,$BC
                                  .db $53,$23,$40,$32,$93,$BC,$53,$3D
                                  .db $00,$01,$92,$FC,$50,$FE,$C0,$24
                                  .db $D6,$2C,$53,$44,$40,$32,$D5,$2C
                                  .db $50,$DE,$00,$01,$D4,$2C,$53,$43
                                  .db $00,$01,$D4,$EC,$53,$5E,$00,$01
                                  .db $D4,$AC,$50,$02,$00,$01,$95,$38
                                  .db $50,$09,$00,$01,$97,$38,$50,$0E
                                  .db $00,$01,$96,$38,$50,$33,$00,$01
                                  .db $97,$38,$50,$37,$00,$01,$95,$38
                                  .db $50,$3B,$00,$01,$96,$38,$50,$42
                                  .db $00,$01,$96,$38,$50,$50,$00,$01
                                  .db $95,$38,$50,$55,$00,$01,$96,$38
                                  .db $50,$5E,$00,$01,$95,$38,$51,$01
                                  .db $00,$01,$97,$38,$51,$5F,$00,$01
                                  .db $96,$38,$51,$81,$00,$01,$95,$38
                                  .db $51,$C0,$00,$01,$96,$38,$51,$FF
                                  .db $00,$01,$97,$38,$52,$60,$00,$01
                                  .db $95,$38,$52,$7F,$00,$01,$95,$38
                                  .db $53,$00,$00,$01,$97,$38,$53,$1F
                                  .db $00,$01,$96,$38,$53,$61,$00,$01
                                  .db $95,$38,$53,$6A,$00,$01,$95,$38
                                  .db $53,$73,$00,$01,$96,$38,$53,$76
                                  .db $00,$01,$95,$38,$53,$86,$00,$01
                                  .db $96,$38,$53,$91,$00,$01,$95,$38
                                  .db $53,$9A,$00,$01,$97,$38,$53,$9E
                                  .db $00,$01,$95,$38,$50,$23,$C0,$06
                                  .db $FC,$2C,$50,$24,$C0,$06,$FC,$2C
                                  .db $50,$25,$C0,$06,$FC,$2C,$50,$26
                                  .db $C0,$06,$FC,$2C,$50,$87,$00,$01
                                  .db $8F,$38,$FF,$9B,$75,$81,$20,$01
                                  .db $76,$20,$9B,$75,$81,$20,$01,$76
                                  .db $20,$9A,$75,$00,$10,$81,$20,$01
                                  .db $76,$20,$94,$75,$00,$01,$81,$02
                                  .db $81,$01,$05,$02,$11,$50,$20,$7D
                                  .db $20,$92,$75,$02,$10,$03,$11,$81
                                  .db $71,$81,$11,$81,$71,$03,$11,$43
                                  .db $10,$9C,$91,$75,$01,$10,$11,$89
                                  .db $71,$01,$11,$10,$89,$75,$04,$01
                                  .db $02,$03,$02,$01,$82,$75,$01,$3D
                                  .db $71,$83,$AD,$81,$8A,$81,$AD,$81
                                  .db $8A,$01,$11,$10,$89,$75,$00,$3D
                                  .db $82,$71,$00,$3D,$82,$75,$01,$3D
                                  .db $71,$83,$AD,$81,$8A,$81,$AD,$81
                                  .db $8A,$01,$3D,$3F,$89,$75,$00,$00
                                  .db $81,$43,$01,$42,$40,$81,$75,$01
                                  .db $10,$00,$83,$43,$00,$11,$85,$71
                                  .db $01,$11,$10,$88,$75,$01,$11,$20
                                  .db $82,$69,$03,$20,$11,$75,$3D,$81
                                  .db $20,$82,$69,$00,$00,$81,$43,$00
                                  .db $11,$83,$71,$00,$3D,$88,$75,$01
                                  .db $11,$50,$81,$69,$04,$41,$42,$11
                                  .db $75,$3D,$81,$20,$81,$69,$01,$20
                                  .db $69,$81,$20,$00,$50,$83,$43,$00
                                  .db $10,$89,$75,$00,$11,$81,$43,$00
                                  .db $11,$82,$75,$02,$3D,$50,$20,$82
                                  .db $69,$81,$20,$01,$69,$20,$82,$69
                                  .db $01,$20,$76,$86,$75,$01,$54,$55
                                  .db $87,$75,$01,$00,$11,$83,$43,$00
                                  .db $50,$81,$20,$83,$69,$01,$20,$76
                                  .db $86,$75,$03,$9E,$9F,$06,$05,$85
                                  .db $03,$01,$20,$50,$83,$43,$00,$11
                                  .db $81,$43,$00,$50,$82,$69,$01,$20
                                  .db $7D,$84,$75,$04,$01,$02,$9E,$9F
                                  .db $58,$81,$71,$02,$BA,$BD,$BF,$81
                                  .db $71,$81,$20,$83,$69,$03,$50,$11
                                  .db $71,$11,$82,$43,$01,$9C,$10,$84
                                  .db $75,$0E,$3D,$71,$9E,$9F,$71,$58
                                  .db $71,$BD,$BF,$BA,$71,$11,$20,$69
                                  .db $20,$83,$69,$00,$50,$83,$43,$02
                                  .db $10,$9C,$43,$84,$75,$04,$3D,$58
                                  .db $9E,$9F,$71,$81,$58,$06,$BF,$71
                                  .db $BD,$71,$11,$50,$20,$84,$69,$00
                                  .db $20,$82,$69,$03,$20,$76,$20,$69
                                  .db $83,$75,$05,$10,$11,$58,$9E,$9F
                                  .db $58,$81,$71,$07,$58,$BA,$BD,$BF
                                  .db $71,$11,$50,$20,$84,$69,$00,$20
                                  .db $81,$69,$03,$20,$76,$20,$69,$82
                                  .db $75,$06,$10,$11,$56,$57,$9E,$9F
                                  .db $58,$82,$71,$02,$BD,$71,$BA,$81
                                  .db $71,$81,$58,$04,$43,$58,$43,$50
                                  .db $20,$82,$69,$03,$20,$76,$20,$69
                                  .db $82,$75,$05,$3D,$58,$9E,$9F,$64
                                  .db $65,$84,$71,$81,$BD,$00,$BF,$83
                                  .db $58,$04,$71,$58,$11,$50,$20,$81
                                  .db $69,$03,$20,$76,$20,$69,$82,$75
                                  .db $03,$3D,$71,$64,$65,$81,$71,$00
                                  .db $6E,$81,$6B,$05,$6E,$BD,$BF,$BA
                                  .db $BD,$58,$81,$8A,$01,$AD,$8E,$81
                                  .db $58,$07,$11,$43,$BC,$3D,$20,$7D
                                  .db $20,$69,$82,$75,$01,$00,$11,$81
                                  .db $71,$01,$AE,$BC,$83,$68,$04,$BA
                                  .db $BD,$11,$43,$11,$81,$8A,$09,$AD
                                  .db $8A,$8F,$53,$52,$71,$BC,$3D,$43
                                  .db $3F,$81,$43,$82,$75,$06,$20,$50
                                  .db $11,$8F,$9B,$71,$6E,$81,$6B,$05
                                  .db $6E,$11,$43,$00,$69,$00,$81,$43
                                  .db $08,$58,$8F,$9B,$63,$62,$71,$BC
                                  .db $71,$10,$82,$3F,$82,$75,$02,$20
                                  .db $50,$11,$81,$AC,$01,$58,$11,$82
                                  .db $43,$04,$00,$69,$50,$43,$50,$81
                                  .db $20,$04,$50,$58,$9B,$8F,$6C,$81
                                  .db $68,$01,$6C,$3D,$82,$3F,$82,$75
                                  .db $02,$00,$11,$58,$81,$AC,$09,$11
                                  .db $50,$20,$69,$20,$50,$43,$11,$3F
                                  .db $11,$81,$43,$03,$50,$3D,$8A,$BC
                                  .db $83,$68,$00,$6C,$82,$03,$81,$75
                                  .db $03,$10,$11,$56,$57,$81,$AC,$01
                                  .db $3D,$50,$82,$43,$00,$11,$85,$3F
                                  .db $03,$10,$11,$8A,$BC,$84,$68,$81
                                  .db $71,$00,$43,$81,$75,$03,$3D,$58
                                  .db $64,$65,$81,$8A,$01,$11,$10,$87
                                  .db $3F,$03,$10,$03,$52,$53,$81,$71
                                  .db $00,$6C,$82,$68,$03,$6C,$11,$00
                                  .db $69,$81,$75,$03,$3D,$71,$56,$57
                                  .db $81,$8A,$01,$58,$3D,$86,$3F,$00
                                  .db $10,$81,$8F,$0B,$62,$63,$52,$53
                                  .db $71,$52,$53,$71,$11,$50,$69,$20
                                  .db $81,$75,$03,$00,$11,$64,$65,$81
                                  .db $AC,$02,$11,$00,$11,$84,$3F,$0F
                                  .db $10,$52,$53,$71,$8E,$71,$62,$63
                                  .db $52,$51,$63,$11,$50,$69,$20,$69
                                  .db $81,$75,$03,$20,$3D,$71,$58,$81
                                  .db $AC,$02,$3D,$50,$11,$84,$3F,$04
                                  .db $3D,$62,$63,$71,$8E,$82,$71,$03
                                  .db $62,$63,$42,$41,$82,$69,$00,$20
                                  .db $81,$75,$03,$20,$3D,$58,$71,$81
                                  .db $AC,$00,$3D,$83,$3F,$00,$10,$81
                                  .db $03,$0A,$11,$52,$53,$52,$53,$71
                                  .db $52,$53,$11,$50,$20,$82,$69,$07
                                  .db $50,$43,$75,$11,$20,$00,$11,$71
                                  .db $81,$AC,$01,$11,$10,$82,$3F,$00
                                  .db $3D,$81,$71,$09,$52,$51,$63,$62
                                  .db $63,$52,$51,$63,$3A,$20,$82,$69
                                  .db $03,$50,$11,$75,$20,$9E,$75,$00
                                  .db $20,$9E,$75,$01,$20,$10,$95,$75
                                  .db $03,$E2,$E5,$F5,$F6,$83,$75,$02
                                  .db $50,$11,$10,$90,$75,$07,$01,$02
                                  .db $03,$05,$84,$32,$33,$C4,$83,$75
                                  .db $03,$11,$71,$11,$10,$8D,$75,$02
                                  .db $01,$02,$11,$82,$71,$04,$35,$36
                                  .db $37,$38,$01,$82,$75,$01,$10,$03
                                  .db $81,$11,$00,$10,$8B,$75,$01,$10
                                  .db $11,$84,$71,$05,$49,$4A,$59,$5A
                                  .db $11,$10,$81,$75,$81,$3F,$02,$10
                                  .db $71,$3D,$8B,$75,$02,$3D,$AD,$5D
                                  .db $84,$68,$00,$5D,$82,$71,$00,$3D
                                  .db $81,$75,$82,$3F,$81,$3D,$8B,$75
                                  .db $01,$3D,$AD,$86,$68,$81,$71,$01
                                  .db $11,$00,$81,$75,$81,$3F,$02,$10
                                  .db $11,$00,$87,$75,$01,$01,$02,$81
                                  .db $03,$02,$00,$11,$5D,$84,$68,$04
                                  .db $5D,$71,$11,$50,$20,$81,$75,$05
                                  .db $3F,$10,$11,$50,$20,$10,$85,$75
                                  .db $01,$10,$11,$82,$71,$04,$20,$50
                                  .db $44,$43,$44,$81,$43,$05,$44,$43
                                  .db $42,$40,$69,$20,$81,$75,$05,$9C
                                  .db $43,$50,$69,$20,$3D,$85,$A4,$01
                                  .db $3D,$AD,$81,$8A,$03,$11,$20,$69
                                  .db $20,$87,$69,$81,$20,$81,$75,$81
                                  .db $20,$81,$69,$01,$50,$3D,$81,$B4
                                  .db $01,$B5,$A5,$81,$B4,$01,$3D,$AD
                                  .db $81,$8A,$02,$11,$50,$20,$87,$69
                                  .db $0A,$20,$69,$20,$10,$75,$20,$69
                                  .db $20,$50,$11,$4D,$85,$75,$01,$4D
                                  .db $71,$81,$AC,$03,$71,$11,$50,$20
                                  .db $87,$69,$81,$20,$01,$11,$10,$81
                                  .db $20,$00,$50,$81,$11,$01,$00,$02
                                  .db $82,$03,$05,$02,$01,$3D,$71,$8F
                                  .db $9B,$81,$71,$01,$11,$44,$81,$43
                                  .db $00,$60,$83,$69,$04,$20,$69,$20
                                  .db $71,$3D,$81,$43,$81,$11,$02,$50
                                  .db $20,$11,$82,$43,$81,$11,$03,$00
                                  .db $11,$71,$AE,$83,$BC,$02,$AE,$11
                                  .db $00,$84,$69,$0A,$20,$50,$58,$4D
                                  .db $43,$11,$71,$3D,$69,$20,$41,$82
                                  .db $69,$07,$41,$42,$20,$41,$42,$44
                                  .db $43,$44,$81,$43,$02,$44,$50,$20
                                  .db $83,$69,$0B,$20,$50,$11,$71,$3D
                                  .db $20,$50,$43,$00,$69,$20,$42,$82
                                  .db $43,$02,$42,$41,$20,$81,$69,$00
                                  .db $20,$84,$69,$81,$20,$82,$69,$0B
                                  .db $41,$42,$11,$58,$71,$4D,$69,$20
                                  .db $69,$20,$69,$20,$85,$73,$02,$20
                                  .db $69,$20,$84,$69,$02,$20,$69,$20
                                  .db $82,$43,$00,$11,$81,$58,$03,$71
                                  .db $58,$3D,$20,$81,$69,$03,$20,$69
                                  .db $50,$11,$83,$3F,$01,$11,$20,$81
                                  .db $69,$00,$20,$84,$69,$02,$20,$50
                                  .db $58,$81,$AC,$81,$89,$81,$58,$07
                                  .db $11,$00,$69,$20,$69,$20,$50,$11
                                  .db $84,$3F,$03,$11,$50,$69,$20,$84
                                  .db $69,$01,$20,$50,$81,$89,$81,$AC
                                  .db $81,$99,$81,$89,$00,$3D,$81,$20
                                  .db $81,$69,$01,$20,$11,$86,$3F,$04
                                  .db $11,$42,$41,$20,$60,$83,$43,$00
                                  .db $11,$81,$99,$81,$AC,$81,$89,$81
                                  .db $99,$06,$3D,$20,$43,$50,$69,$50
                                  .db $11,$88,$3F,$03,$11,$43,$3D,$71
                                  .db $81,$89,$01,$71,$58,$81,$89,$81
                                  .db $8F,$09,$99,$98,$89,$71,$3D,$20
                                  .db $3F,$11,$43,$11,$8A,$3F,$02,$10
                                  .db $11,$58,$81,$99,$81,$89,$01,$99
                                  .db $98,$82,$89,$81,$99,$02,$58,$3D
                                  .db $50,$82,$3F,$81,$10,$83,$3F,$81
                                  .db $10,$82,$3F,$01,$10,$11,$81,$89
                                  .db $04,$58,$89,$98,$99,$89,$82,$98
                                  .db $00,$99,$81,$89,$02,$58,$4D,$11
                                  .db $82,$03,$02,$11,$00,$11,$81,$3F
                                  .db $00,$10,$81,$11,$82,$03,$04,$11
                                  .db $58,$99,$98,$89,$81,$99,$00,$89
                                  .db $83,$98,$00,$89,$81,$99,$02,$71
                                  .db $4D,$75,$82,$43,$81,$50,$02,$11
                                  .db $3F,$9C,$82,$43,$02,$11,$71,$58
                                  .db $82,$89,$01,$98,$99,$81,$89,$85
                                  .db $99,$00,$58,$81,$89,$01,$11,$10
                                  .db $81,$69,$81,$20,$82,$76,$00,$20
                                  .db $81,$69,$03,$20,$50,$11,$71,$82
                                  .db $99,$03,$98,$89,$99,$98,$86,$89
                                  .db $81,$99,$01,$58,$3D,$81,$69,$81
                                  .db $20,$82,$76,$00,$20,$82,$69,$03
                                  .db $20,$41,$42,$11,$81,$89,$81,$99
                                  .db $01,$89,$98,$81,$99,$81,$98,$82
                                  .db $99,$81,$89,$01,$58,$3D,$81,$69
                                  .db $81,$20,$82,$7D,$00,$20,$81,$69
                                  .db $00,$20,$82,$69,$00,$3D,$81,$99
                                  .db $81,$89,$01,$99,$98,$81,$89,$81
                                  .db $98,$06,$89,$3B,$89,$98,$99,$11
                                  .db $00,$81,$69,$05,$20,$50,$11,$3F
                                  .db $11,$20,$82,$69,$00,$20,$81,$69
                                  .db $06,$3D,$71,$58,$99,$98,$89,$99
                                  .db $83,$98,$01,$99,$89,$81,$98,$02
                                  .db $89,$3D,$20,$82,$43,$00,$11,$81
                                  .db $3F,$00,$11,$83,$43,$03,$50,$41
                                  .db $42,$11,$82,$89,$82,$98,$82,$99
                                  .db $01,$98,$89,$83,$99,$01,$3D,$20
                                  .db $87,$75,$04,$08,$07,$06,$05,$11
                                  .db $81,$58,$84,$99,$00,$98,$82,$89
                                  .db $81,$99,$81,$89,$09,$58,$71,$3D
                                  .db $20,$75,$11,$50,$20,$3D,$71,$81
                                  .db $AC,$01,$71,$11,$82,$03,$00,$11
                                  .db $81,$71,$01,$62,$63,$82,$71,$08
                                  .db $62,$63,$11,$2A,$69,$20,$69,$50
                                  .db $11,$83,$75,$05,$11,$20,$00,$11
                                  .db $8F,$9B,$84,$71,$00,$5D,$81,$68
                                  .db $00,$5D,$82,$71,$03,$58,$71,$11
                                  .db $50,$81,$20,$02,$41,$42,$11,$85
                                  .db $75,$06,$00,$43,$23,$30,$AE,$AF
                                  .db $AD,$81,$8A,$01,$71,$5D,$81,$68
                                  .db $00,$5D,$83,$71,$05,$11,$50,$20
                                  .db $69,$2A,$11,$86,$75,$01,$10,$11
                                  .db $81,$71,$03,$11,$30,$8E,$AD,$81
                                  .db $8A,$01,$52,$53,$81,$71,$81,$58
                                  .db $03,$71,$58,$11,$50,$81,$69,$01
                                  .db $20,$3A,$81,$75,$01,$A6,$A7,$83
                                  .db $75,$01,$00,$11,$81,$71,$03,$11
                                  .db $00,$52,$53,$81,$AC,$02,$62,$63
                                  .db $71,$81,$58,$03,$11,$43,$42,$41
                                  .db $81,$69,$08,$20,$50,$11,$A6,$A7
                                  .db $B6,$B7,$A6,$A7,$81,$75,$01,$20
                                  .db $50,$81,$43,$03,$50,$20,$62,$63
                                  .db $81,$AC,$00,$71,$81,$58,$03,$71
                                  .db $11,$50,$20,$83,$69,$04,$50,$11
                                  .db $75,$B6,$B7,$81,$3F,$01,$B6,$B7
                                  .db $81,$75,$01,$20,$69,$81,$3E,$0C
                                  .db $69,$20,$42,$44,$43,$44,$43,$44
                                  .db $43,$42,$41,$69,$20,$82,$69,$03
                                  .db $50,$11,$A6,$A7,$85,$3F,$81,$75
                                  .db $01,$20,$69,$81,$3E,$00,$69,$82
                                  .db $20,$84,$69,$00,$20,$81,$69,$00
                                  .db $20,$81,$69,$04,$50,$11,$75,$B6
                                  .db $B7,$85,$3F,$81,$75,$01,$20,$69
                                  .db $81,$3E,$03,$69,$20,$69,$20,$83
                                  .db $69,$00,$20,$82,$69,$05,$20,$41
                                  .db $42,$11,$A6,$A7,$87,$3F,$81,$75
                                  .db $01,$20,$69,$81,$3E,$00,$69,$81
                                  .db $20,$85,$69,$04,$20,$69,$50,$43
                                  .db $11,$81,$75,$01,$B6,$B7,$87,$3F
                                  .db $81,$75,$01,$20,$69,$81,$3E,$03
                                  .db $69,$20,$41,$20,$83,$69,$03,$20
                                  .db $41,$42,$11,$83,$75,$01,$A6,$A7
                                  .db $87,$3F,$81,$75,$01,$20,$69,$81
                                  .db $3E,$02,$69,$20,$11,$85,$43,$00
                                  .db $11,$85,$75,$01,$B6,$B7,$87,$3F
                                  .db $81,$75,$01,$20,$69,$81,$3E,$08
                                  .db $69,$20,$03,$04,$03,$04,$03,$02
                                  .db $01,$87,$75,$01,$A6,$A7,$86,$3F
                                  .db $03,$75,$10,$20,$C2,$81,$C3,$03
                                  .db $C2,$20,$56,$57,$82,$71,$02,$56
                                  .db $57,$10,$86,$75,$03,$B6,$B7,$A6
                                  .db $A7,$83,$3F,$04,$A6,$75,$4D,$50
                                  .db $D2,$81,$D3,$03,$D2,$50,$9E,$9F
                                  .db $82,$71,$02,$9E,$9F,$3D,$88,$75
                                  .db $0A,$B6,$B7,$3F,$A6,$A7,$3F,$B6
                                  .db $75,$3D,$11,$20,$81,$3E,$03,$20
                                  .db $11,$9E,$9F,$82,$71,$02,$64,$65
                                  .db $4D,$8B,$75,$01,$B6,$B7,$82,$75
                                  .db $02,$4D,$11,$50,$81,$3E,$05,$50
                                  .db $11,$9E,$9F,$56,$57,$81,$71,$01
                                  .db $58,$3D,$90,$75,$02,$3D,$58,$11
                                  .db $81,$43,$06,$11,$58,$64,$65,$9E
                                  .db $9F,$71,$81,$58,$00,$3D,$83,$75
                                  .db $81,$60,$8A,$75,$00,$00,$81,$43
                                  .db $00,$11,$83,$71,$03,$58,$64,$65
                                  .db $11,$81,$43,$00,$00,$83,$75,$02
                                  .db $3D,$11,$60,$83,$75,$02,$60,$03
                                  .db $60,$82,$75,$81,$20,$01,$69,$3D
                                  .db $86,$71,$00,$3D,$81,$69,$00,$20
                                  .db $83,$75,$00,$60,$81,$11,$00,$60
                                  .db $81,$75,$03,$60,$11,$A6,$A7,$81
                                  .db $03,$00,$75,$81,$20,$01,$69,$00
                                  .db $81,$43,$05,$44,$43,$44,$43,$44
                                  .db $00,$81,$69,$00,$20,$83,$75,$03
                                  .db $20,$3D,$A6,$A7,$81,$03,$06,$11
                                  .db $A6,$A9,$B7,$A6,$A7,$11,$81,$20
                                  .db $00,$69,$81,$20,$84,$69,$81,$20
                                  .db $81,$69,$01,$20,$11,$82,$75,$03
                                  .db $60,$11,$B6,$B7,$82,$71,$08,$B6
                                  .db $A8,$A7,$B6,$A8,$11,$50,$20,$69
                                  .db $81,$20,$84,$69,$81,$20,$81,$69
                                  .db $01,$50,$11,$81,$75,$01,$60,$11
                                  .db $84,$71,$07,$A6,$A7,$B6,$B7,$71
                                  .db $B6,$75,$11,$81,$43,$81,$20,$84
                                  .db $69,$81,$20,$81,$43,$00,$11,$82
                                  .db $75,$02,$60,$11,$58,$83,$71,$02
                                  .db $B6,$B7,$58,$82,$71,$82,$75,$02
                                  .db $11,$50,$20,$84,$69,$02,$20,$50
                                  .db $11,$84,$75,$0C,$20,$3D,$58,$A6
                                  .db $A7,$A6,$A7,$A6,$A7,$A6,$A7,$A6
                                  .db $A7,$83,$75,$00,$11,$86,$43,$00
                                  .db $11,$85,$75,$0C,$60,$11,$A6,$A9
                                  .db $B7,$B6,$B7,$B6,$B7,$B6,$B7,$B6
                                  .db $B7,$92,$75,$04,$60,$11,$B6,$A8
                                  .db $A7,$81,$71,$05,$A6,$A7,$A6,$A7
                                  .db $A6,$A7,$8D,$75,$11,$A6,$A7,$75
                                  .db $A6,$A7,$20,$60,$11,$B6,$A8,$A7
                                  .db $71,$B6,$B7,$B6,$B7,$B6,$B7,$8D
                                  .db $75,$04,$B6,$B7,$A6,$A9,$B7,$81
                                  .db $20,$05,$60,$11,$B6,$B7,$11,$43
                                  .db $81,$11,$81,$43,$00,$11,$8C,$75
                                  .db $05,$A6,$A7,$A6,$A9,$B7,$3F,$82
                                  .db $20,$00,$60,$81,$43,$01,$60,$69
                                  .db $81,$3D,$81,$69,$00,$3D,$89,$75
                                  .db $08,$A6,$A7,$75,$B6,$B7,$B6,$B7
                                  .db $A6,$A7,$83,$20,$81,$69,$01,$20
                                  .db $69,$81,$60,$81,$69,$00,$60,$89
                                  .db $75,$01,$B6,$B7,$84,$75,$02,$B6
                                  .db $B7,$43,$82,$20,$81,$69,$01,$20
                                  .db $69,$81,$20,$81,$69,$00,$20,$86
                                  .db $75,$04,$10,$11,$71,$58,$6E,$82
                                  .db $6B,$83,$AD,$01,$8E,$99,$81,$98
                                  .db $00,$99,$81,$8F,$05,$99,$98,$89
                                  .db $58,$3D,$50,$86,$75,$03,$3D,$71
                                  .db $58,$71,$83,$68,$83,$AD,$01,$8E
                                  .db $89,$81,$98,$00,$89,$81,$AC,$05
                                  .db $89,$98,$99,$11,$00,$11,$86,$75
                                  .db $04,$4D,$58,$71,$58,$5D,$81,$68
                                  .db $00,$5D,$84,$89,$82,$98,$00,$99
                                  .db $81,$AC,$81,$99,$02,$11,$50,$20
                                  .db $87,$75,$03,$3D,$71,$00,$50,$81
                                  .db $43,$81,$71,$87,$99,$02,$71,$9B
                                  .db $8F,$81,$89,$02,$3D,$69,$20,$87
                                  .db $75,$01,$4D,$3D,$81,$50,$81,$20
                                  .db $02,$50,$71,$6E,$82,$6B,$83,$AD
                                  .db $08,$AF,$AE,$89,$98,$99,$3D,$69
                                  .db $20,$11,$86,$75,$03,$00,$11,$10
                                  .db $11,$81,$43,$01,$50,$3D,$83,$68
                                  .db $83,$AD,$0A,$8E,$89,$98,$99,$11
                                  .db $00,$69,$50,$11,$A6,$A7,$84,$75
                                  .db $03,$20,$50,$11,$10,$81,$3F,$02
                                  .db $11,$3D,$5D,$81,$68,$01,$5D,$58
                                  .db $82,$89,$00,$98,$81,$99,$07,$71
                                  .db $3A,$20,$50,$11,$75,$B6,$B7,$84
                                  .db $75,$04,$20,$69,$50,$11,$03,$81
                                  .db $10,$01,$58,$71,$81,$AC,$01,$58
                                  .db $89,$82,$98,$00,$99,$81,$71,$03
                                  .db $11,$2A,$20,$11,$81,$75,$81,$3F
                                  .db $01,$A6,$A7,$81,$75,$01,$11,$20
                                  .db $81,$69,$00,$50,$82,$11,$01,$71
                                  .db $58,$81,$AC,$00,$71,$83,$99,$03
                                  .db $71,$11,$42,$41,$81,$20,$00,$11
                                  .db $81,$75,$81,$3F,$01,$B6,$B7,$81
                                  .db $75,$01,$11,$50,$82,$69,$01,$41
                                  .db $42,$89,$43,$06,$42,$41,$69,$20
                                  .db $69,$50,$11,$81,$75,$81,$3F,$01
                                  .db $A6,$A7,$82,$75,$01,$11,$50,$83
                                  .db $69,$00,$20,$87,$69,$00,$20,$82
                                  .db $69,$02,$20,$2A,$11,$82,$75,$81
                                  .db $3F,$01,$B6,$B7,$83,$75,$00,$60
                                  .db $83,$43,$02,$50,$69,$50,$81,$43
                                  .db $00,$50,$83,$69,$00,$20,$81,$69
                                  .db $01,$20,$3A,$83,$75,$02,$3F,$A6
                                  .db $A7,$84,$75,$00,$3D,$82,$71,$03
                                  .db $AD,$DA,$69,$DA,$81,$8A,$00,$3D
                                  .db $82,$69,$00,$20,$82,$69,$01,$50
                                  .db $11,$83,$75,$02,$A7,$B6,$B7,$84
                                  .db $75,$01,$3D,$58,$81,$71,$03,$AD
                                  .db $DA,$69,$DA,$81,$8A,$00,$3D,$81
                                  .db $69,$07,$50,$43,$50,$41,$42,$10
                                  .db $03,$10,$82,$75,$00,$B7,$81,$75
                                  .db $02,$60,$03,$60,$81,$75,$07,$60
                                  .db $11,$A6,$A7,$58,$3D,$43,$00,$81
                                  .db $43,$00,$00,$81,$43,$07,$00,$43
                                  .db $00,$11,$75,$00,$43,$00,$85,$75
                                  .db $0B,$3D,$71,$11,$03,$60,$20,$3D
                                  .db $B6,$B7,$11,$60,$75,$83,$20,$81
                                  .db $75,$82,$20,$81,$75,$02,$20,$69
                                  .db $20,$85,$75,$0B,$3D,$A6,$A7,$A6
                                  .db $A7,$43,$11,$A6,$A7,$3D,$20,$75
                                  .db $83,$20,$81,$75,$82,$20,$81,$75
                                  .db $02,$20,$69,$20,$82,$75,$00,$60
                                  .db $81,$03,$0B,$A6,$A9,$A8,$A9,$B7
                                  .db $71,$58,$B6,$B7,$3D,$20,$11,$83
                                  .db $20,$01,$11,$75,$82,$20,$05,$75
                                  .db $11,$20,$69,$20,$11,$81,$75,$0F
                                  .db $3D,$A6,$A7,$B6,$B7,$B6,$A8,$A7
                                  .db $A6,$A7,$A6,$A7,$3D,$20,$11,$50
                                  .db $81,$20,$00,$50,$81,$11,$82,$20
                                  .db $81,$11,$03,$50,$69,$50,$11,$81
                                  .db $75,$0F,$11,$B6,$B7,$A6,$A7,$71
                                  .db $B6,$A8,$A9,$B7,$B6,$B7,$11,$60
                                  .db $75,$11,$81,$43,$0A,$11,$75,$11
                                  .db $50,$20,$50,$11,$75,$11,$43,$11
                                  .db $82,$75,$0D,$58,$A6,$A7,$B6,$A8
                                  .db $A7,$A6,$A9,$A8,$A7,$A6,$A7,$71
                                  .db $11,$81,$03,$00,$60,$83,$75,$02
                                  .db $11,$43,$11,$87,$75,$11,$A7,$B6
                                  .db $B7,$71,$B6,$B7,$B6,$B7,$B6,$A8
                                  .db $A9,$A8,$A7,$71,$A6,$A7,$11,$60
                                  .db $8D,$75,$13,$A8,$A7,$A6,$A7,$A6
                                  .db $A7,$A6,$A7,$A6,$A9,$B7,$B6,$A8
                                  .db $A7,$B6,$A8,$A7,$11,$03,$60,$8B
                                  .db $75,$13,$B6,$B7,$B6,$B7,$B6,$B7
                                  .db $B6,$B7,$B6,$B7,$A6,$A7,$B6,$B7
                                  .db $71,$B6,$A8,$A7,$11,$60,$81,$75
                                  .db $01,$A6,$A7,$87,$75,$17,$A6,$A7
                                  .db $A6,$A7,$A6,$A7,$A6,$A7,$A6,$A7
                                  .db $B6,$B7,$A6,$A7,$71,$A6,$A9,$B7
                                  .db $3D,$20,$75,$A6,$A9,$B7,$87,$75
                                  .db $16,$B6,$A8,$A9,$B7,$B6,$B7,$B6
                                  .db $B7,$B6,$A8,$A7,$A6,$A9,$A8,$A7
                                  .db $B6,$A8,$A7,$11,$60,$75,$B6,$B7
                                  .db $88,$75,$13,$A6,$A9,$B7,$A6,$A7
                                  .db $A6,$A7,$A6,$A7,$B6,$B7,$B6,$B7
                                  .db $B6,$B7,$A6,$A9,$B7,$11,$60,$8B
                                  .db $75,$09,$B6,$B7,$A6,$A9,$A8,$A9
                                  .db $A8,$A9,$B7,$11,$83,$43,$07,$11
                                  .db $B6,$B7,$11,$60,$20,$A6,$A7,$82
                                  .db $75,$01,$A6,$A7,$84,$75,$09,$A6
                                  .db $A7,$B6,$B7,$B6,$B7,$B6,$B7,$58
                                  .db $3D,$83,$69,$00,$60,$81,$11,$00
                                  .db $60,$81,$20,$06,$B6,$A8,$A7,$A6
                                  .db $A7,$B6,$B7,$84,$75,$01,$B6,$B7
                                  .db $81,$43,$81,$11,$03,$43,$11,$71
                                  .db $3D,$83,$69,$00,$20,$81,$60,$82
                                  .db $20,$04,$3F,$B6,$A8,$A9,$B7,$86
                                  .db $75,$01,$43,$60,$81,$69,$81,$60
                                  .db $03,$69,$3D,$58,$3D,$83,$69,$85
                                  .db $20,$03,$A6,$A7,$B6,$B7,$87,$75
                                  .db $01,$69,$20,$81,$69,$81,$20,$03
                                  .db $69,$60,$43,$60,$83,$69,$84,$20
                                  .db $02,$43,$B6,$B7,$89,$75,$83,$75
                                  .db $03,$20,$69,$20,$B8,$81,$B9,$06
                                  .db $B8,$20,$69,$20,$75,$54,$55,$8C
                                  .db $75,$81,$4F,$83,$75,$03,$20,$69
                                  .db $20,$B8,$81,$B9,$06,$B8,$20,$69
                                  .db $20,$04,$9E,$9F,$82,$03,$04,$05
                                  .db $06,$07,$54,$55,$84,$75,$81,$4F
                                  .db $81,$75,$05,$54,$55,$20,$69,$20
                                  .db $B8,$81,$B9,$07,$B8,$20,$69,$20
                                  .db $71,$9E,$9F,$71,$81,$AC,$04,$71
                                  .db $56,$57,$9E,$9F,$84,$75,$81,$4F
                                  .db $81,$75,$05,$9E,$9F,$20,$C6,$C7
                                  .db $C8,$81,$C9,$07,$C8,$C7,$C6,$20
                                  .db $71,$9E,$9F,$71,$81,$AC,$04,$71
                                  .db $64,$65,$9E,$9F,$84,$75,$81,$4F
                                  .db $81,$75,$05,$9E,$9F,$20,$D6,$D7
                                  .db $AA,$81,$AB,$07,$AA,$D7,$D6,$20
                                  .db $11,$9E,$67,$57,$81,$AC,$82,$71
                                  .db $02,$64,$67,$55,$83,$75,$81,$4F
                                  .db $07,$75,$0A,$9E,$9F,$50,$E6,$E7
                                  .db $AA,$81,$AB,$07,$AA,$E7,$E6,$50
                                  .db $11,$64,$9E,$9F,$81,$71,$81,$BC
                                  .db $04,$AE,$71,$64,$65,$0A,$82,$75
                                  .db $81,$4F,$07,$75,$1A,$64,$65,$11
                                  .db $50,$F7,$F8,$81,$F9,$10,$F8,$F7
                                  .db $50,$11,$71,$56,$66,$9F,$71,$53
                                  .db $52,$71,$9B,$8F,$52,$53,$1A,$82
                                  .db $75,$81,$4F,$02,$75,$00,$11,$81
                                  .db $71,$02,$11,$20,$B8,$81,$B9,$0B
                                  .db $B8,$20,$11,$56,$57,$9E,$9F,$67
                                  .db $57,$63,$51,$52,$81,$AC,$02,$62
                                  .db $63,$3D,$82,$75,$81,$4F,$07,$75
                                  .db $20,$3D,$56,$57,$11,$20,$B8,$81
                                  .db $B9,$0B,$B8,$20,$11,$9E,$67,$66
                                  .db $9F,$9E,$9F,$3C,$63,$62,$81,$8A
                                  .db $02,$71,$11,$00,$82,$75,$81,$4F
                                  .db $07,$75,$20,$3D,$64,$65,$11,$50
                                  .db $B8,$81,$B9,$02,$B8,$50,$11,$81
                                  .db $9E,$06,$9F,$67,$66,$9F,$58,$52
                                  .db $53,$81,$8A,$02,$11,$50,$20,$82
                                  .db $75,$81,$4F,$07,$11,$20,$3D,$71
                                  .db $BF,$71,$11,$43,$81,$AC,$0B,$43
                                  .db $56,$57,$64,$9E,$9F,$9E,$9F,$65
                                  .db $58,$62,$63,$81,$AC,$02,$11,$50
                                  .db $20,$82,$75,$81,$4F,$11,$11,$50
                                  .db $3D,$BD,$BA,$BD,$BF,$71,$9B,$8F
                                  .db $58,$64,$65,$71,$64,$65,$9E,$9F
                                  .db $81,$58,$07,$3C,$58,$9B,$8F,$58
                                  .db $3D,$20,$11,$81,$75,$81,$4F,$08
                                  .db $75,$11,$3D,$BF,$BD,$BF,$71,$8F
                                  .db $9B,$81,$58,$84,$2C,$01,$9E,$9F
                                  .db $81,$8A,$07,$AD,$AF,$AE,$58,$3C
                                  .db $3D,$50,$11,$81,$75,$81,$4F,$81
                                  .db $75,$09,$4D,$BA,$BF,$BD,$71,$9B
                                  .db $8F,$58,$71,$2C,$82,$71,$02,$2C
                                  .db $9E,$9F,$81,$8A,$06,$AD,$8E,$58
                                  .db $3C,$58,$4D,$11,$82,$75,$81,$43
                                  .db $81,$75,$08,$40,$42,$43,$11,$8F
                                  .db $9B,$56,$57,$2C,$83,$71,$02,$2C
                                  .db $9E,$9F,$81,$AC,$81,$58,$03,$43
                                  .db $44,$42,$40,$83,$75,$81,$69,$81
                                  .db $75,$00,$20,$81,$69,$00,$3D,$81
                                  .db $AC,$03,$64,$65,$6E,$5D,$81,$68
                                  .db $03,$5D,$6E,$64,$65,$81,$AC,$01
                                  .db $3C,$3D,$82,$69,$00,$20,$83,$75
                                  .db $81,$69,$81,$75,$00,$20,$81,$69
                                  .db $00,$3D,$81,$5D,$00,$6B,$81,$6D
                                  .db $83,$6B,$81,$6D,$00,$6B,$81,$5D
                                  .db $01,$58,$3D,$82,$69,$00,$20,$83
                                  .db $75,$81,$69,$02,$75,$11,$20,$81
                                  .db $69,$00,$3D,$81,$5D,$01,$6B,$6E
                                  .db $84,$2C,$02,$71,$6E,$6B,$81,$5D
                                  .db $01,$71,$3D,$82,$69,$01,$20,$11
                                  .db $82,$75,$81,$69,$09,$75,$11,$42
                                  .db $41,$69,$00,$43,$44,$43,$44,$81
                                  .db $43,$81,$44,$81,$43,$05,$44,$43
                                  .db $44,$43,$44,$00,$81,$69,$02,$41
                                  .db $42,$11,$82,$75,$81,$69,$82,$75
                                  .db $01,$11,$43,$81,$20,$8C,$69,$81
                                  .db $20,$81,$43,$00,$11,$84,$75,$81
                                  .db $69,$84,$75,$81,$20,$8C,$69,$81
                                  .db $20,$87,$75,$82,$69,$81,$20,$00
                                  .db $3D,$85,$71,$04,$3D,$69,$20,$69
                                  .db $20,$84,$69,$02,$20,$69,$20,$81
                                  .db $69,$81,$20,$82,$69,$81,$71,$81
                                  .db $20,$01,$69,$3D,$85,$71,$02,$3D
                                  .db $69,$20,$81,$69,$00,$00,$83,$43
                                  .db $02,$46,$47,$48,$81,$20,$81,$69
                                  .db $00,$20,$81,$69,$81,$71,$81,$20
                                  .db $02,$2A,$00,$11,$83,$71,$06,$11
                                  .db $00,$2A,$69,$20,$2A,$11,$85,$71
                                  .db $02,$11,$42,$41,$81,$20,$82,$69
                                  .db $81,$71,$81,$20,$03,$3A,$20,$40
                                  .db $42,$81,$43,$07,$42,$40,$20,$3A
                                  .db $20,$69,$3A,$71,$81,$8A,$83,$AD
                                  .db $04,$8E,$71,$11,$50,$20,$82,$69
                                  .db $81,$71,$02,$69,$00,$11,$82,$20
                                  .db $81,$69,$82,$20,$04,$3D,$20,$69
                                  .db $3D,$71,$81,$8A,$83,$AD,$81,$AF
                                  .db $03,$8E,$11,$50,$20,$81,$69,$81
                                  .db $71,$00,$43,$81,$11,$00,$50,$81
                                  .db $20,$81,$69,$81,$20,$01,$50,$3D
                                  .db $81,$43,$00,$3D,$87,$71,$04,$8E
                                  .db $8A,$8F,$11,$0F,$81,$69,$81,$71
                                  .db $05,$A6,$A7,$3C,$11,$42,$40,$81
                                  .db $69,$03,$40,$42,$11,$00,$81,$71
                                  .db $01,$40,$42,$83,$43,$00,$11,$82
                                  .db $71,$81,$AC,$01,$71,$1F,$81,$69
                                  .db $81,$71,$05,$B6,$B7,$A6,$A7,$3C
                                  .db $11,$81,$43,$81,$11,$04,$00,$20
                                  .db $71,$11,$20,$84,$69,$03,$40,$42
                                  .db $11,$71,$81,$8A,$01,$71,$2F,$81
                                  .db $69,$81,$71,$04,$A6,$A7,$B6,$B7
                                  .db $11,$82,$43,$01,$42,$40,$81,$20
                                  .db $02,$11,$50,$20,$83,$69,$04,$20
                                  .db $69,$20,$50,$11,$81,$8A,$01,$71
                                  .db $11,$83,$71,$04,$B6,$B7,$3C,$11
                                  .db $00,$83,$69,$82,$20,$02,$3D,$50
                                  .db $20,$84,$69,$03,$20,$69,$20,$3D
                                  .db $81,$AC,$85,$71,$81,$3C,$02,$11
                                  .db $50,$20,$84,$69,$05,$20,$00,$3D
                                  .db $11,$42,$41,$82,$69,$04,$20,$69
                                  .db $20,$69,$3D,$81,$AC,$85,$71,$03
                                  .db $4F,$3C,$4F,$3C,$81,$4F,$00,$3D
                                  .db $96,$3F,$81,$75,$83,$4F,$81,$3C
                                  .db $01,$11,$0A,$95,$3F,$81,$75,$81
                                  .db $8A,$81,$AD,$81,$4F,$01,$3C,$1A
                                  .db $95,$3F,$81,$75,$81,$8A,$81,$AD
                                  .db $03,$4F,$3C,$4F,$3D,$8E,$3F,$00
                                  .db $0A,$81,$03,$01,$02,$01,$81,$3F
                                  .db $81,$75,$81,$AC,$81,$4F,$03,$11
                                  .db $43,$42,$40,$8E,$3F,$00,$1A,$81
                                  .db $4F,$01,$3C,$11,$81,$23,$81,$75
                                  .db $81,$AC,$81,$4F,$00,$3A,$82,$20
                                  .db $8E,$43,$04,$3D,$4F,$3C,$4F,$3C
                                  .db $81,$4F,$81,$75,$82,$4F,$01,$11
                                  .db $2A,$82,$20,$00,$4F,$81,$3C,$01
                                  .db $4F,$3C,$87,$4F,$81,$3C,$03,$00
                                  .db $11,$4F,$3C,$82,$4F,$81,$75,$81
                                  .db $4F,$01,$11,$50,$81,$20,$06,$69
                                  .db $20,$3C,$4F,$3C,$4F,$3C,$88,$4F
                                  .db $04,$3C,$20,$40,$42,$11,$82,$4F
                                  .db $81,$75,$81,$4F,$01,$3D,$69,$81
                                  .db $20,$05,$69,$20,$4F,$3C,$4F,$3C
                                  .db $81,$4F,$81,$AC,$01,$4F,$3C,$81
                                  .db $4F,$02,$3C,$11,$43,$81,$20,$01
                                  .db $69,$50,$82,$43,$81,$75,$81,$4F
                                  .db $01,$3D,$69,$81,$20,$03,$69,$20
                                  .db $3C,$4F,$81,$3C,$01,$4F,$3C,$81
                                  .db $AC,$00,$3C,$82,$4F,$02,$11,$50
                                  .db $69,$81,$20,$84,$69,$81,$75,$03
                                  .db $4F,$3C,$11,$50,$81,$20,$01,$69
                                  .db $20,$81,$8A,$83,$AD,$81,$5D,$01
                                  .db $4F,$3C,$81,$5D,$02,$3D,$50,$43
                                  .db $81,$20,$84,$69,$81,$75,$03,$3C
                                  .db $4F,$3C,$3D,$81,$20,$01,$69,$20
                                  .db $81,$8A,$83,$AD,$81,$68,$01,$3C
                                  .db $4F,$81,$68,$00,$3D,$81,$11,$01
                                  .db $50,$20,$84,$69,$81,$75,$07,$4F
                                  .db $3C,$11,$00,$69,$20,$40,$42,$81
                                  .db $AC,$03,$3C,$4F,$3C,$4F,$81,$5D
                                  .db $81,$3C,$81,$5D,$05,$11,$10,$3F
                                  .db $10,$42,$41,$83,$69,$81,$75,$81
                                  .db $43,$05,$50,$20,$2A,$43,$11,$3C
                                  .db $81,$AC,$00,$4F,$84,$3C,$00,$4F
                                  .db $83,$3C,$05,$11,$03,$11,$3C,$4F
                                  .db $50,$82,$69,$81,$75,$81,$69,$81
                                  .db $20,$00,$3A,$82,$3C,$81,$8A,$83
                                  .db $AD,$81,$5D,$81,$AD,$81,$8A,$81
                                  .db $AD,$81,$8A,$81,$AD,$00,$8E,$82
                                  .db $43,$81,$75,$07,$69,$20,$69,$20
                                  .db $43,$11,$3C,$4F,$81,$8A,$83,$AD
                                  .db $81,$68,$81,$AD,$81,$8A,$81,$AD
                                  .db $81,$8A,$81,$AD,$81,$AF,$01,$8E
                                  .db $4F,$81,$75,$07,$69,$20,$69,$20
                                  .db $69,$50,$11,$3C,$82,$4F,$00,$3C
                                  .db $81,$4F,$81,$5D,$00,$3C,$83,$4F
                                  .db $00,$3C,$81,$4F,$81,$3C,$03,$4F
                                  .db $8E,$AF,$4F,$81,$75,$81,$69,$81
                                  .db $20,$00,$43,$81,$50,$01,$43,$11
                                  .db $81,$60,$82,$3C,$03,$4F,$3C,$4F
                                  .db $3C,$81,$60,$81,$3C,$81,$60,$00
                                  .db $3C,$81,$60,$82,$3C,$81,$75,$08
                                  .db $69,$20,$69,$20,$3F,$11,$50,$69
                                  .db $60,$81,$11,$00,$60,$81,$3C,$00
                                  .db $60,$82,$23,$81,$11,$81,$23,$81
                                  .db $11,$02,$23,$11,$3D,$82,$3C,$81
                                  .db $75,$81,$69,$81,$20,$04,$11,$3F
                                  .db $11,$60,$11,$81,$4F,$00,$11,$81
                                  .db $23,$00,$11,$8A,$4F,$00,$11,$82
                                  .db $23,$81,$75,$07,$69,$20,$69,$50
                                  .db $11,$3F,$60,$11,$95,$4F,$81,$75
                                  .db $9D,$71,$81,$69,$9D,$71,$81,$69
                                  .db $9D,$71,$81,$69,$9D,$71,$81,$69
                                  .db $9D,$71,$81,$69,$82,$71,$00,$7C
                                  .db $81,$71,$81,$7C,$81,$71,$82,$7C
                                  .db $81,$71,$00,$7C,$81,$71,$00,$7C
                                  .db $81,$71,$00,$7C,$81,$71,$00,$7C
                                  .db $84,$71,$81,$43,$81,$71,$08,$7C
                                  .db $71,$7C,$71,$7C,$71,$7C,$71,$7C
                                  .db $82,$71,$0A,$7C,$71,$7C,$71,$7C
                                  .db $71,$7C,$71,$7C,$71,$7C,$88,$71
                                  .db $00,$7C,$82,$71,$04,$7C,$71,$7C
                                  .db $71,$7C,$82,$71,$00,$7C,$82,$71
                                  .db $06,$7C,$71,$7C,$71,$7C,$71,$7C
                                  .db $89,$71,$00,$7C,$81,$71,$03,$7C
                                  .db $71,$7C,$71,$82,$7C,$01,$71,$7C
                                  .db $82,$71,$01,$7C,$71,$82,$7C,$01
                                  .db $71,$7C,$8A,$71,$01,$7C,$71,$81
                                  .db $7C,$81,$71,$00,$7C,$82,$71,$00
                                  .db $7C,$82,$71,$06,$7C,$71,$7C,$71
                                  .db $7C,$71,$7C,$88,$71,$04,$7C,$71
                                  .db $7C,$71,$7C,$82,$71,$00,$7C,$82
                                  .db $71,$0A,$7C,$71,$7C,$71,$7C,$71
                                  .db $7C,$71,$7C,$71,$7C,$86,$71,$81
                                  .db $43,$02,$00,$69,$20,$83,$69,$06
                                  .db $20,$50,$11,$71,$02,$01,$11,$83
                                  .db $43,$03,$42,$41,$20,$3D,$81,$8A
                                  .db $85,$71,$82,$69,$81,$20,$82,$69
                                  .db $06,$41,$42,$A6,$A7,$A6,$A7,$3D
                                  .db $85,$3F,$02,$11,$50,$3D,$81,$8A
                                  .db $85,$71,$81,$43,$02,$60,$20,$50
                                  .db $82,$43,$07,$11,$A6,$A9,$B7,$B6
                                  .db $B7,$00,$11,$85,$3F,$01,$60,$11
                                  .db $81,$AC,$87,$71,$04,$11,$60,$11
                                  .db $A6,$A7,$81,$71,$01,$B6,$B7,$81
                                  .db $71,$02,$3D,$50,$11,$85,$3F,$01
                                  .db $3D,$71,$81,$AC,$88,$71,$06,$11
                                  .db $60,$B6,$B7,$A6,$A7,$71,$81,$8A
                                  .db $02,$AD,$3D,$11,$85,$3F,$02,$10
                                  .db $3D,$71,$81,$AC,$89,$71,$05,$11
                                  .db $60,$71,$B6,$B7,$71,$81,$8A,$01
                                  .db $AD,$3D,$84,$3F,$04,$10,$03,$11
                                  .db $3D,$5D,$81,$68,$00,$5D,$86,$71
                                  .db $00,$3C,$81,$71,$01,$3D,$71,$81
                                  .db $60,$00,$71,$81,$AC,$02,$71,$11
                                  .db $10,$83,$3F,$00,$3D,$81,$71,$01
                                  .db $3D,$5D,$81,$68,$00,$5D,$85,$71
                                  .db $05,$3C,$71,$3C,$71,$11,$43,$81
                                  .db $11,$00,$60,$81,$AC,$00,$71,$81
                                  .db $60,$00,$10,$81,$3F,$00,$60,$82
                                  .db $43,$03,$11,$71,$9B,$8F,$87,$71
                                  .db $00,$3C,$85,$71,$00,$11,$82,$43
                                  .db $81,$11,$00,$43,$81,$03,$00,$11
                                  .db $81,$71,$81,$AD,$01,$AF,$AE,$9B
                                  .db $71,$81,$AD,$00,$8E,$87,$71,$00
                                  .db $87,$81,$88,$00,$97,$81,$86,$81
                                  .db $85,$81,$86,$02,$85,$71,$85,$81
                                  .db $86,$00,$85,$81,$89,$00,$87,$81
                                  .db $88,$01,$87,$85,$81,$86,$00,$85
                                  .db $81,$89,$81,$71,$81,$BB,$03,$58
                                  .db $71,$58,$95,$81,$96,$81,$95,$81
                                  .db $96,$02,$95,$71,$95,$81,$96,$00
                                  .db $95,$81,$99,$00,$85,$81,$86,$01
                                  .db $85,$95,$81,$96,$00,$95,$81,$99
                                  .db $81,$71,$81,$BB,$00,$85,$81,$86
                                  .db $00,$97,$81,$88,$81,$87,$81,$88
                                  .db $02,$87,$58,$87,$81,$88,$00,$87
                                  .db $81,$89,$00,$95,$81,$96,$01,$95
                                  .db $87,$81,$88,$00,$97,$81,$86,$01
                                  .db $85,$71,$81,$BB,$00,$95,$81,$96
                                  .db $01,$95,$58,$81,$71,$00,$58,$81
                                  .db $89,$85,$71,$81,$99,$00,$87,$81
                                  .db $88,$04,$87,$71,$58,$71,$95,$81
                                  .db $96,$01,$95,$71,$81,$BB,$00,$87
                                  .db $81,$88,$01,$87,$85,$81,$86,$00
                                  .db $85,$81,$99,$81,$71,$83,$89,$81
                                  .db $5D,$81,$89,$81,$71,$00,$85,$81
                                  .db $86,$00,$97,$81,$88,$01,$97,$71
                                  .db $81,$BB,$00,$85,$81,$86,$01,$85
                                  .db $95,$81,$96,$00,$95,$83,$71,$83
                                  .db $99,$81,$5D,$81,$99,$81,$89,$00
                                  .db $95,$81,$96,$00,$95,$81,$58,$81
                                  .db $71,$81,$BB,$00,$95,$81,$96,$01
                                  .db $95,$87,$81,$88,$00,$87,$81,$71
                                  .db $83,$89,$02,$58,$71,$58,$82,$71
                                  .db $81,$99,$00,$87,$81,$88,$01,$87
                                  .db $85,$81,$86,$00,$71,$81,$BB,$00
                                  .db $87,$81,$88,$01,$87,$85,$81,$86
                                  .db $00,$85,$81,$71,$83,$99,$00,$85
                                  .db $81,$86,$00,$85,$83,$89,$00,$85
                                  .db $81,$86,$01,$85,$95,$81,$96,$00
                                  .db $71,$81,$BB,$00,$85,$81,$86,$01
                                  .db $85,$95,$81,$96,$00,$95,$81,$71
                                  .db $83,$89,$00,$95,$81,$96,$00,$95
                                  .db $83,$99,$00,$95,$81,$96,$01,$95
                                  .db $87,$81,$88,$00,$71,$81,$BB,$00
                                  .db $95,$81,$96,$01,$95,$87,$81,$88
                                  .db $00,$87,$81,$71,$83,$99,$00,$87
                                  .db $81,$88,$01,$87,$58,$82,$71,$00
                                  .db $87,$81,$88,$00,$87,$83,$71,$81
                                  .db $BB,$00,$87,$81,$88,$00,$97,$81
                                  .db $86,$01,$85,$71,$81,$89,$81,$71
                                  .db $83,$89,$00,$71,$81,$89,$00,$71
                                  .db $81,$2B,$85,$89,$81,$71,$81,$BB
                                  .db $00,$71,$81,$58,$00,$95,$81,$96
                                  .db $01,$95,$71,$81,$99,$81,$71,$83
                                  .db $99,$00,$58,$81,$99,$00,$58,$81
                                  .db $2B,$85,$99,$81,$71,$81,$E8,$00
                                  .db $85,$81,$86,$00,$97,$81,$88,$00
                                  .db $87,$82,$71,$81,$89,$82,$71,$81
                                  .db $89,$00,$71,$81,$89,$81,$71,$81
                                  .db $89,$00,$85,$81,$86,$00,$85,$81
                                  .db $71,$81,$3F,$00,$95,$81,$96,$00
                                  .db $95,$81,$89,$83,$71,$81,$99,$00
                                  .db $71,$81,$89,$81,$99,$00,$71,$81
                                  .db $99,$81,$71,$81,$99,$00,$95,$81
                                  .db $96,$00,$95,$81,$71,$81,$3F,$00
                                  .db $87,$81,$88,$00,$87,$81,$99,$83
                                  .db $89,$02,$58,$71,$58,$81,$99,$00
                                  .db $71,$81,$89,$00,$71,$81,$89,$00
                                  .db $85,$81,$86,$00,$97,$81,$88,$00
                                  .db $87,$81,$71,$81,$D8,$81,$89,$00
                                  .db $85,$81,$86,$00,$85,$83,$99,$00
                                  .db $85,$81,$86,$00,$85,$81,$71,$81
                                  .db $99,$00,$71,$81,$99,$00,$95,$81
                                  .db $96,$01,$95,$71,$81,$89,$81,$71
                                  .db $81,$3F,$81,$99,$00,$95,$81,$96
                                  .db $00,$95,$83,$89,$00,$95,$81,$96
                                  .db $00,$95,$83,$89,$00,$85,$81,$86
                                  .db $00,$97,$81,$88,$01,$87,$58,$81
                                  .db $99,$81,$71,$81,$3F,$81,$71,$00
                                  .db $87,$81,$88,$00,$87,$83,$99,$00
                                  .db $87,$81,$88,$00,$87,$83,$99,$00
                                  .db $95,$81,$96,$00,$95,$81,$89,$00
                                  .db $85,$81,$86,$00,$85,$81,$71,$81
                                  .db $3F,$00,$71,$81,$89,$01,$71,$58
                                  .db $83,$89,$00,$71,$81,$89,$00,$85
                                  .db $81,$86,$00,$85,$81,$58,$00,$87
                                  .db $81,$88,$00,$87,$81,$99,$00,$95
                                  .db $81,$96,$00,$95,$81,$71,$81,$D9
                                  .db $00,$71,$81,$99,$01,$58,$71,$83
                                  .db $99,$00,$58,$81,$99,$00,$95,$81
                                  .db $96,$00,$95,$81,$89,$00,$85,$81
                                  .db $86,$00,$85,$81,$89,$00,$87,$81
                                  .db $88,$00,$87,$81,$71,$81,$D8,$01
                                  .db $71,$85,$81,$86,$03,$85,$71,$58
                                  .db $85,$81,$86,$02,$85,$71,$87,$81
                                  .db $88,$00,$87,$81,$99,$00,$95,$81
                                  .db $96,$00,$95,$81,$99,$85,$71,$81
                                  .db $3F,$83,$75,$03,$20,$69,$20,$B8
                                  .db $81,$B9,$03,$B8,$20,$69,$20,$8F
                                  .db $75,$81,$4F,$82,$71,$00,$7C,$81
                                  .db $71,$00,$7C,$82,$71,$82,$7C,$81
                                  .db $71,$00,$7C,$81,$71,$05,$7C,$71
                                  .db $7C,$71,$7C,$71,$82,$7C,$82,$71
                                  .db $81,$43,$9D,$71,$81,$69,$85,$71
                                  .db $81,$7B,$83,$71,$81,$7B,$83,$71
                                  .db $81,$7B,$83,$71,$81,$7B,$83,$71
                                  .db $81,$43,$85,$71,$81,$7B,$83,$71
                                  .db $81,$7B,$83,$71,$81,$7B,$83,$71
                                  .db $81,$7B,$C7,$71,$81,$5D,$81,$6B
                                  .db $81,$5D,$83,$71,$81,$7B,$83,$71
                                  .db $81,$7B,$83,$71,$81,$7B,$87,$71
                                  .db $81,$5D,$81,$6B,$81,$5D,$83,$71
                                  .db $81,$7B,$83,$71,$81,$7B,$83,$71
                                  .db $81,$7B,$C5,$71,$83,$BB,$00,$7C
                                  .db $88,$BB,$81,$10,$81,$BB,$81,$7B
                                  .db $89,$BB,$81,$71,$81,$BB,$01,$B0
                                  .db $B1,$86,$BB,$02,$7C,$BB,$10,$81
                                  .db $11,$01,$10,$BB,$81,$7B,$82,$BB
                                  .db $00,$7C,$85,$BB,$81,$71,$03,$BB
                                  .db $E0,$C0,$C1,$82,$BB,$81,$7B,$82
                                  .db $BB,$01,$10,$11,$81,$5D,$01,$11
                                  .db $10,$8B,$BB,$81,$71,$03,$BB,$E1
                                  .db $D0,$D1,$82,$BB,$81,$7B,$82,$BB
                                  .db $08,$3D,$4F,$5D,$68,$4F,$11,$10
                                  .db $BB,$7C,$83,$BB,$81,$7B,$82,$BB
                                  .db $81,$71,$8A,$BB,$00,$10,$82,$4F
                                  .db $81,$6C,$01,$4F,$3D,$85,$BB,$81
                                  .db $7B,$82,$BB,$81,$71,$82,$BB,$00
                                  .db $10,$86,$03,$84,$4F,$81,$6C,$04
                                  .db $11,$03,$04,$03,$04,$82,$03,$00
                                  .db $10,$82,$BB,$81,$71,$81,$7B,$01
                                  .db $BB,$3D,$81,$5D,$83,$6B,$81,$5D
                                  .db $84,$4F,$02,$6C,$68,$5D,$83,$4F
                                  .db $81,$5D,$00,$3D,$82,$BB,$81,$71
                                  .db $81,$7B,$01,$BB,$3D,$81,$5D,$83
                                  .db $6B,$81,$5D,$05,$4F,$12,$13,$14
                                  .db $15,$4F,$81,$5D,$83,$4F,$02,$68
                                  .db $5D,$3D,$82,$BB,$81,$71,$82,$BB
                                  .db $00,$00,$87,$4F,$05,$58,$31,$32
                                  .db $33,$34,$58,$84,$4F,$81,$6C,$01
                                  .db $11,$00,$82,$BB,$81,$71,$04,$BB
                                  .db $7C,$BB,$20,$50,$85,$4F,$07,$58
                                  .db $4F,$35,$36,$37,$38,$4F,$58,$82
                                  .db $4F,$81,$6C,$02,$11,$50,$20,$82
                                  .db $BB,$81,$71,$82,$BB,$02,$20,$69
                                  .db $00,$81,$4F,$81,$5D,$10,$4F,$58
                                  .db $4F,$35,$36,$37,$38,$4F,$58,$4F
                                  .db $5D,$68,$6C,$11,$00,$69,$20,$82
                                  .db $BB,$81,$71,$02,$E8,$E9,$E8,$81
                                  .db $20,$04,$69,$50,$4F,$68,$5D,$81
                                  .db $4F,$05,$58,$49,$4A,$59,$5A,$58
                                  .db $81,$4F,$81,$5D,$02,$4F,$3D,$69
                                  .db $81,$20,$82,$E8,$81,$71,$82,$3F
                                  .db $05,$20,$69,$20,$50,$4F,$68,$84
                                  .db $4F,$81,$5D,$86,$4F,$03,$3D,$20
                                  .db $69,$20,$82,$D8,$81,$71,$81,$3F
                                  .db $04,$D8,$20,$69,$00,$11,$81,$6C
                                  .db $84,$4F,$03,$5D,$68,$6D,$6E,$84
                                  .db $4F,$03,$11,$00,$69,$20,$82,$3F
                                  .db $81,$71,$05,$D8,$D9,$3F,$20,$50
                                  .db $11,$81,$6C,$85,$4F,$81,$11,$00
                                  .db $6E,$81,$6D,$00,$6E,$83,$4F,$02
                                  .db $11,$50,$20,$82,$D9,$81,$71,$04
                                  .db $3F,$D8,$D9,$00,$11,$81,$6C,$85
                                  .db $4F,$05,$11,$00,$50,$43,$11,$6E
                                  .db $81,$6D,$00,$6E,$83,$4F,$00,$00
                                  .db $82,$3F,$81,$71,$81,$3F,$03,$10
                                  .db $11,$5D,$68,$84,$4F,$09,$11,$43
                                  .db $50,$69,$20,$69,$50,$11,$4F,$6E
                                  .db $81,$6D,$00,$6E,$81,$5D,$01,$4F
                                  .db $10,$81,$3F,$81,$71,$81,$3F,$01
                                  .db $3D,$4F,$81,$5D,$81,$4F,$00,$11
                                  .db $81,$43,$00,$00,$82,$69,$00,$20
                                  .db $81,$69,$01,$00,$18,$81,$4F,$05
                                  .db $6E,$6D,$68,$5D,$4F,$3D,$81,$3F
                                  .db $81,$71,$02,$D9,$3F,$3D,$82,$4F
                                  .db $02,$11,$43,$50,$82,$69,$00,$20
                                  .db $81,$69,$08,$20,$69,$20,$69,$48
                                  .db $47,$46,$45,$11,$82,$4F,$00,$00
                                  .db $81,$3F,$81,$71,$03,$D8,$D9,$40
                                  .db $42,$81,$43,$02,$50,$69,$20,$82
                                  .db $69,$02,$20,$69,$20,$82,$69,$00
                                  .db $20,$83,$69,$00,$00,$81,$43,$01
                                  .db $50,$20,$81,$3F,$81,$71,$81,$3F
                                  .db $02,$20,$69,$20,$81,$69,$00,$20
                                  .db $83,$69,$00,$20,$81,$69,$02,$20
                                  .db $69,$20,$84,$69,$04,$20,$69,$20
                                  .db $69,$20,$81,$3F,$81,$71,$03,$4F
                                  .db $3C,$4F,$3C,$81,$4F,$00,$3D,$96
                                  .db $3F,$81,$75,$9B,$1C,$03,$58,$18
                                  .db $1C,$58,$9B,$1C,$03,$58,$18,$1C
                                  .db $58,$9A,$1C,$04,$10,$58,$18,$1C
                                  .db $58,$94,$1C,$81,$10,$81,$50,$82
                                  .db $10,$03,$50,$18,$14,$58,$90,$1C
                                  .db $81,$5C,$84,$10,$00,$50,$82,$10
                                  .db $03,$50,$10,$50,$90,$90,$1C,$00
                                  .db $5C,$81,$10,$8B,$50,$89,$1C,$82
                                  .db $10,$81,$50,$81,$1C,$00,$5C,$86
                                  .db $10,$00,$50,$82,$10,$00,$50,$81
                                  .db $D0,$89,$1C,$83,$10,$00,$50,$81
                                  .db $1C,$00,$5C,$81,$10,$84,$90,$00
                                  .db $D0,$82,$90,$02,$D0,$50,$18,$89
                                  .db $1C,$00,$50,$81,$90,$81,$D0,$81
                                  .db $1C,$01,$18,$50,$84,$90,$85,$10
                                  .db $81,$50,$88,$1C,$01,$D4,$58,$82
                                  .db $1C,$03,$18,$94,$1C,$18,$81,$58
                                  .db $82,$5C,$00,$50,$82,$90,$84,$50
                                  .db $88,$1C,$81,$54,$81,$1C,$82,$14
                                  .db $01,$1C,$18,$81,$58,$81,$5C,$03
                                  .db $18,$5C,$58,$18,$84,$90,$00,$D0
                                  .db $89,$1C,$00,$54,$82,$14,$82,$1C
                                  .db $00,$18,$81,$58,$82,$5C,$81,$58
                                  .db $01,$5C,$58,$82,$5C,$01,$18,$14
                                  .db $86,$1C,$81,$10,$87,$1C,$01,$58
                                  .db $98,$83,$18,$81,$58,$00,$18,$83
                                  .db $5C,$01,$18,$14,$86,$1C,$81,$10
                                  .db $81,$50,$85,$10,$00,$58,$85,$98
                                  .db $81,$18,$00,$58,$82,$5C,$01,$18
                                  .db $14,$84,$1C,$84,$10,$81,$50,$06
                                  .db $10,$50,$10,$50,$10,$58,$18,$83
                                  .db $5C,$81,$98,$01,$18,$58,$82,$18
                                  .db $01,$D8,$18,$84,$1C,$01,$10,$50
                                  .db $81,$10,$02,$50,$10,$50,$81,$10
                                  .db $05,$D0,$50,$D0,$58,$5C,$58,$83
                                  .db $5C,$84,$98,$02,$D8,$18,$98,$84
                                  .db $1C,$83,$10,$00,$50,$82,$10,$84
                                  .db $50,$00,$18,$84,$5C,$00,$18,$82
                                  .db $5C,$03,$18,$14,$58,$5C,$83,$1C
                                  .db $85,$10,$00,$50,$81,$10,$81,$50
                                  .db $00,$90,$82,$50,$00,$58,$84,$5C
                                  .db $00,$58,$81,$5C,$03,$18,$14,$58
                                  .db $5C,$82,$1C,$8A,$10,$83,$50,$84
                                  .db $10,$01,$50,$18,$82,$5C,$03,$18
                                  .db $14,$58,$5C,$82,$1C,$89,$10,$81
                                  .db $50,$81,$90,$85,$10,$81,$50,$00
                                  .db $58,$81,$5C,$03,$18,$14,$58,$5C
                                  .db $82,$1C,$85,$10,$00,$50,$84,$10
                                  .db $01,$50,$D0,$81,$10,$00,$50,$83
                                  .db $10,$00,$50,$81,$10,$04,$50,$18
                                  .db $14,$58,$5C,$82,$1C,$01,$50,$90
                                  .db $81,$10,$01,$50,$10,$83,$18,$02
                                  .db $10,$50,$D0,$82,$90,$00,$D0,$81
                                  .db $90,$00,$10,$81,$50,$81,$10,$02
                                  .db $50,$14,$58,$81,$14,$82,$1C,$00
                                  .db $58,$81,$90,$03,$50,$90,$10,$D0
                                  .db $82,$90,$04,$D0,$90,$10,$5C,$50
                                  .db $81,$90,$02,$10,$D0,$10,$81,$50
                                  .db $82,$10,$00,$50,$82,$58,$82,$1C
                                  .db $00,$58,$82,$10,$02,$50,$10,$D0
                                  .db $82,$90,$01,$10,$5C,$81,$14,$07
                                  .db $54,$58,$18,$90,$10,$D0,$10,$50
                                  .db $81,$18,$01,$10,$50,$82,$58,$82
                                  .db $1C,$00,$D0,$82,$10,$00,$50,$81
                                  .db $D0,$02,$58,$5C,$18,$82,$14,$01
                                  .db $58,$54,$81,$14,$00,$54,$82,$10
                                  .db $83,$18,$00,$10,$82,$50,$81,$1C
                                  .db $84,$10,$81,$50,$84,$14,$85,$58
                                  .db $81,$10,$01,$90,$10,$84,$18,$81
                                  .db $10,$00,$90,$81,$1C,$84,$10,$82
                                  .db $50,$87,$58,$01,$10,$50,$83,$10
                                  .db $00,$D0,$82,$18,$02,$90,$D0,$10
                                  .db $82,$1C,$83,$10,$03,$90,$D0,$10
                                  .db $50,$86,$58,$01,$10,$50,$88,$10
                                  .db $81,$D0,$01,$1C,$58,$81,$1C,$01
                                  .db $50,$90,$82,$10,$03,$50,$D0,$10
                                  .db $94,$84,$58,$83,$10,$00,$50,$83
                                  .db $10,$01,$18,$10,$81,$D0,$01,$1C
                                  .db $18,$82,$1C,$00,$58,$83,$10,$81
                                  .db $50,$81,$14,$84,$58,$83,$10,$00
                                  .db $D0,$84,$10,$81,$D0,$82,$1C,$00
                                  .db $58,$81,$1C,$00,$58,$83,$10,$81
                                  .db $50,$83,$58,$00,$10,$81,$50,$87
                                  .db $10,$81,$D0,$00,$58,$82,$1C,$81
                                  .db $14,$04,$1C,$D4,$58,$50,$90,$81
                                  .db $10,$82,$50,$82,$58,$83,$10,$00
                                  .db $18,$83,$10,$03,$18,$10,$D0,$18
                                  .db $82,$1C,$81,$14,$01,$1C,$18,$9E
                                  .db $1C,$00,$18,$9E,$1C,$01,$18,$50
                                  .db $95,$1C,$83,$10,$83,$1C,$00,$10
                                  .db $81,$50,$90,$1C,$87,$10,$83,$1C
                                  .db $01,$90,$10,$81,$50,$8D,$1C,$89
                                  .db $10,$01,$50,$5C,$81,$1C,$82,$90
                                  .db $81,$50,$8B,$1C,$81,$10,$84,$50
                                  .db $83,$10,$81,$50,$81,$1C,$81,$58
                                  .db $02,$90,$10,$50,$8B,$1C,$82,$10
                                  .db $84,$18,$00,$50,$82,$10,$00,$50
                                  .db $81,$1C,$82,$58,$01,$10,$50,$8B
                                  .db $1C,$01,$10,$90,$85,$18,$00,$58
                                  .db $81,$50,$01,$D0,$10,$81,$1C,$81
                                  .db $58,$02,$10,$D0,$10,$87,$1C,$83
                                  .db $18,$00,$50,$81,$90,$84,$18,$01
                                  .db $D0,$10,$81,$D0,$00,$18,$81,$1C
                                  .db $01,$58,$10,$81,$D0,$01,$18,$58
                                  .db $85,$1C,$84,$18,$00,$58,$87,$90
                                  .db $81,$D0,$01,$5C,$18,$81,$1C,$05
                                  .db $10,$90,$D0,$5C,$18,$58,$88,$18
                                  .db $04,$58,$D8,$58,$5C,$58,$81,$1C
                                  .db $85,$5C,$01,$58,$18,$81,$1C,$01
                                  .db $58,$18,$81,$5C,$01,$18,$58,$86
                                  .db $18,$81,$98,$00,$D8,$81,$58,$01
                                  .db $18,$5C,$81,$1C,$84,$5C,$07,$18
                                  .db $5C,$18,$50,$1C,$58,$5C,$58,$81
                                  .db $18,$00,$58,$85,$1C,$82,$18,$01
                                  .db $58,$18,$82,$58,$81,$1C,$85,$5C
                                  .db $01,$58,$18,$81,$50,$00,$58,$82
                                  .db $18,$01,$D8,$18,$83,$10,$81,$50
                                  .db $81,$18,$00,$D8,$82,$18,$00,$58
                                  .db $82,$18,$00,$58,$83,$5C,$04,$18
                                  .db $5C,$18,$10,$50,$82,$18,$81,$D8
                                  .db $01,$18,$D0,$83,$90,$04,$50,$58
                                  .db $98,$18,$D8,$83,$18,$02,$98,$D8
                                  .db $18,$84,$5C,$00,$58,$81,$10,$00
                                  .db $50,$81,$98,$04,$18,$58,$5C,$18
                                  .db $D0,$82,$5C,$81,$90,$00,$58,$87
                                  .db $98,$01,$D8,$18,$83,$5C,$00,$18
                                  .db $82,$10,$01,$50,$18,$81,$98,$02
                                  .db $18,$5C,$18,$83,$14,$81,$54,$00
                                  .db $58,$81,$5C,$00,$58,$84,$5C,$01
                                  .db $58,$18,$82,$5C,$83,$10,$81,$50
                                  .db $05,$5C,$58,$5C,$18,$5C,$18,$85
                                  .db $1C,$02,$58,$5C,$18,$84,$5C,$02
                                  .db $18,$5C,$18,$87,$10,$01,$50,$18
                                  .db $81,$5C,$01,$18,$5C,$81,$14,$83
                                  .db $58,$01,$D4,$58,$81,$5C,$00,$58
                                  .db $84,$5C,$00,$58,$82,$10,$02,$50
                                  .db $10,$50,$81,$10,$05,$D0,$10,$5C
                                  .db $58,$5C,$18,$81,$14,$00,$18,$83
                                  .db $58,$81,$54,$01,$5C,$18,$84,$5C
                                  .db $00,$18,$81,$10,$05,$50,$10,$50
                                  .db $10,$50,$10,$81,$50,$81,$18,$81
                                  .db $5C,$01,$18,$94,$86,$58,$82,$54
                                  .db $00,$58,$86,$10,$05,$50,$10,$50
                                  .db $10,$50,$10,$81,$50,$03,$18,$14
                                  .db $54,$5C,$81,$14,$01,$58,$18,$85
                                  .db $58,$02,$18,$54,$14,$82,$10,$00
                                  .db $50,$82,$10,$02,$50,$D0,$90,$81
                                  .db $10,$82,$50,$02,$18,$58,$54,$81
                                  .db $14,$81,$58,$84,$18,$83,$58,$83
                                  .db $10,$02,$50,$10,$50,$81,$10,$07
                                  .db $50,$10,$50,$10,$50,$10,$50,$14
                                  .db $82,$58,$02,$10,$50,$58,$82,$18
                                  .db $01,$10,$50,$82,$58,$82,$10,$00
                                  .db $50,$81,$10,$81,$50,$02,$10,$50
                                  .db $10,$81,$50,$04,$10,$50,$10,$50
                                  .db $14,$82,$50,$81,$10,$00,$94,$81
                                  .db $18,$81,$10,$01,$50,$10,$81,$50
                                  .db $83,$10,$0D,$50,$10,$50,$10,$50
                                  .db $10,$50,$10,$50,$10,$50,$10,$50
                                  .db $1C,$82,$90,$00,$D0,$81,$14,$01
                                  .db $18,$10,$83,$90,$82,$10,$01,$50
                                  .db $10,$81,$50,$07,$10,$50,$10,$50
                                  .db $10,$50,$10,$50,$81,$10,$82,$50
                                  .db $81,$1C,$81,$18,$82,$14,$00,$58
                                  .db $81,$1C,$00,$18,$81,$90,$81,$10
                                  .db $00,$50,$81,$10,$00,$50,$81,$10
                                  .db $0A,$50,$10,$50,$10,$50,$10,$50
                                  .db $10,$50,$10,$50,$81,$1C,$81,$18
                                  .db $82,$14,$00,$58,$82,$1C,$00,$58
                                  .db $82,$90,$04,$10,$50,$10,$50,$10
                                  .db $81,$50,$81,$10,$81,$50,$05,$10
                                  .db $50,$10,$50,$10,$50,$81,$1C,$81
                                  .db $18,$82,$14,$00,$58,$81,$1C,$00
                                  .db $18,$82,$1C,$81,$10,$02,$50,$10
                                  .db $50,$81,$10,$06,$50,$10,$50,$10
                                  .db $50,$14,$10,$81,$50,$01,$D0,$10
                                  .db $82,$1C,$81,$14,$02,$18,$D4,$58
                                  .db $82,$1C,$00,$58,$81,$1C,$84,$10
                                  .db $00,$50,$81,$10,$01,$50,$10,$81
                                  .db $50,$02,$10,$50,$10,$81,$50,$02
                                  .db $18,$14,$54,$81,$14,$01,$18,$58
                                  .db $85,$54,$83,$10,$06,$50,$10,$50
                                  .db $10,$50,$10,$50,$81,$10,$03,$50
                                  .db $10,$50,$10,$81,$50,$00,$18,$87
                                  .db $1C,$83,$50,$83,$10,$02,$50,$10
                                  .db $50,$81,$10,$06,$50,$10,$50,$10
                                  .db $50,$10,$50,$81,$10,$02,$50,$18
                                  .db $1C,$81,$54,$00,$58,$82,$10,$01
                                  .db $50,$10,$83,$50,$89,$10,$81,$D0
                                  .db $02,$1C,$58,$1C,$81,$14,$83,$1C
                                  .db $04,$54,$58,$50,$90,$D0,$86,$10
                                  .db $81,$18,$00,$50,$84,$10,$81,$D0
                                  .db $01,$58,$18,$82,$14,$85,$1C,$00
                                  .db $D0,$81,$10,$01,$50,$D0,$82,$10
                                  .db $02,$50,$10,$90,$81,$18,$00,$D0
                                  .db $83,$10,$81,$D0,$01,$18,$1C,$81
                                  .db $14,$86,$1C,$83,$10,$81,$50,$00
                                  .db $D0,$81,$90,$00,$D0,$87,$10,$81
                                  .db $D0,$81,$1C,$01,$58,$14,$81,$1C
                                  .db $81,$14,$83,$1C,$01,$50,$90,$81
                                  .db $10,$00,$D0,$83,$10,$00,$50,$84
                                  .db $10,$01,$D0,$90,$81,$D0,$81,$1C
                                  .db $00,$18,$87,$14,$81,$1C,$00,$58
                                  .db $82,$90,$01,$D0,$18,$82,$10,$00
                                  .db $50,$83,$10,$81,$D0,$00,$58,$83
                                  .db $1C,$81,$14,$00,$1C,$81,$14,$81
                                  .db $58,$81,$14,$81,$1C,$05,$58,$1C
                                  .db $18,$58,$1C,$18,$86,$90,$81,$D0
                                  .db $02,$1C,$58,$5C,$81,$1C,$83,$14
                                  .db $85,$58,$81,$1C,$04,$58,$1C,$18
                                  .db $58,$1C,$81,$18,$00,$58,$84,$1C
                                  .db $00,$58,$81,$1C,$00,$58,$81,$1C
                                  .db $81,$14,$00,$1C,$81,$14,$85,$58
                                  .db $81,$1C,$07,$58,$1C,$18,$58,$1C
                                  .db $18,$1C,$58,$83,$1C,$01,$18,$5C
                                  .db $81,$1C,$00,$58,$84,$14,$87,$58
                                  .db $81,$1C,$04,$58,$1C,$18,$58,$1C
                                  .db $81,$18,$01,$1C,$5C,$83,$1C,$01
                                  .db $58,$1C,$82,$14,$81,$1C,$81,$14
                                  .db $87,$58,$81,$1C,$07,$58,$1C,$18
                                  .db $58,$1C,$18,$54,$58,$83,$1C,$00
                                  .db $18,$82,$14,$83,$1C,$81,$14,$87
                                  .db $58,$81,$1C,$06,$58,$1C,$18,$58
                                  .db $1C,$18,$54,$86,$14,$85,$1C,$81
                                  .db $14,$87,$58,$81,$1C,$05,$58,$1C
                                  .db $18,$58,$1C,$18,$84,$10,$81,$50
                                  .db $87,$1C,$81,$14,$86,$58,$02,$1C
                                  .db $10,$58,$81,$10,$81,$50,$00,$18
                                  .db $86,$10,$00,$50,$86,$1C,$83,$14
                                  .db $83,$58,$03,$14,$1C,$10,$50,$81
                                  .db $10,$81,$50,$87,$10,$00,$50,$88
                                  .db $1C,$81,$14,$00,$58,$81,$14,$09
                                  .db $58,$14,$1C,$10,$D0,$58,$18,$58
                                  .db $18,$90,$86,$10,$00,$50,$8B,$1C
                                  .db $81,$14,$82,$1C,$00,$10,$81,$50
                                  .db $01,$18,$58,$88,$10,$00,$50,$90
                                  .db $1C,$81,$10,$00,$50,$8A,$10,$00
                                  .db $50,$83,$1C,$01,$18,$58,$8A,$1C
                                  .db $00,$50,$82,$90,$86,$10,$00,$D0
                                  .db $81,$90,$00,$10,$83,$1C,$00,$18
                                  .db $81,$58,$83,$1C,$81,$18,$00,$58
                                  .db $82,$1C,$81,$58,$00,$1C,$87,$10
                                  .db $00,$50,$81,$1C,$00,$18,$83,$1C
                                  .db $81,$98,$81,$58,$81,$1C,$85,$18
                                  .db $00,$1C,$81,$58,$01,$1C,$50,$86
                                  .db $90,$00,$10,$81,$1C,$00,$18,$83
                                  .db $1C,$00,$58,$8A,$18,$00,$D4,$81
                                  .db $58,$00,$1C,$81,$58,$84,$1C,$81
                                  .db $18,$81,$1C,$01,$18,$94,$82,$1C
                                  .db $8B,$18,$81,$54,$01,$58,$1C,$81
                                  .db $58,$84,$1C,$81,$18,$81,$1C,$81
                                  .db $14,$81,$1C,$8C,$18,$01,$1C,$54
                                  .db $81,$14,$81,$58,$84,$1C,$81,$18
                                  .db $82,$14,$82,$1C,$81,$98,$8A,$18
                                  .db $82,$1C,$81,$54,$00,$58,$84,$1C
                                  .db $00,$18,$81,$14,$84,$1C,$00,$58
                                  .db $8B,$18,$83,$1C,$00,$54,$87,$14
                                  .db $85,$1C,$8C,$18,$92,$1C,$81,$98
                                  .db $8A,$18,$8D,$1C,$81,$14,$00,$1C
                                  .db $81,$14,$00,$58,$81,$98,$89,$18
                                  .db $8D,$1C,$84,$14,$81,$58,$81,$98
                                  .db $81,$18,$00,$D8,$81,$98,$00,$D8
                                  .db $82,$98,$8C,$1C,$84,$14,$83,$58
                                  .db $82,$98,$03,$D8,$1C,$18,$58,$81
                                  .db $1C,$00,$18,$89,$1C,$81,$14,$00
                                  .db $1C,$85,$14,$83,$58,$81,$1C,$03
                                  .db $18,$1C,$98,$D8,$81,$1C,$00,$98
                                  .db $89,$1C,$81,$14,$84,$1C,$82,$14
                                  .db $82,$58,$81,$1C,$03,$18,$1C,$58
                                  .db $18,$81,$1C,$00,$58,$86,$1C,$83
                                  .db $10,$83,$50,$86,$10,$82,$50,$82
                                  .db $10,$03,$50,$10,$50,$14,$86,$1C
                                  .db $83,$10,$83,$18,$84,$90,$06,$10
                                  .db $50,$10,$50,$10,$50,$10,$81,$50
                                  .db $02,$D0,$10,$14,$86,$1C,$83,$10
                                  .db $00,$90,$81,$18,$07,$D0,$10,$50
                                  .db $10,$50,$10,$50,$10,$81,$50,$03
                                  .db $10,$50,$10,$50,$81,$D0,$00,$18
                                  .db $87,$1C,$82,$10,$82,$90,$82,$10
                                  .db $0A,$50,$10,$50,$10,$50,$10,$50
                                  .db $10,$50,$90,$10,$81,$50,$01,$1C
                                  .db $18,$87,$1C,$07,$10,$50,$14,$54
                                  .db $58,$18,$90,$10,$83,$50,$83,$10
                                  .db $02,$50,$90,$10,$82,$50,$02,$1C
                                  .db $18,$94,$86,$1C,$03,$50,$90,$50
                                  .db $54,$81,$14,$01,$54,$10,$83,$18
                                  .db $84,$90,$00,$10,$81,$50,$02,$D0
                                  .db $10,$1C,$83,$14,$84,$1C,$00,$58
                                  .db $81,$90,$00,$50,$81,$58,$02,$54
                                  .db $10,$90,$81,$18,$00,$D0,$81,$10
                                  .db $07,$50,$10,$50,$10,$50,$10,$D0
                                  .db $18,$81,$14,$00,$1C,$81,$14,$84
                                  .db $1C,$01,$58,$1C,$81,$90,$81,$50
                                  .db $83,$10,$00,$50,$81,$10,$01,$50
                                  .db $10,$81,$50,$81,$10,$81,$D0,$01
                                  .db $18,$14,$81,$1C,$81,$58,$81,$14
                                  .db $81,$1C,$01,$D4,$58,$81,$1C,$81
                                  .db $90,$00,$50,$83,$10,$00,$50,$81
                                  .db $10,$03,$50,$10,$50,$10,$82,$D0
                                  .db $02,$58,$18,$94,$81,$1C,$81,$58
                                  .db $81,$14,$81,$1C,$81,$54,$82,$1C
                                  .db $8B,$90,$81,$D0,$02,$1C,$18,$1C
                                  .db $81,$14,$81,$1C,$81,$58,$81,$14
                                  .db $82,$1C,$81,$54,$83,$1C,$00,$58
                                  .db $87,$1C,$00,$18,$82,$1C,$00,$18
                                  .db $81,$14,$82,$1C,$81,$58,$81,$14
                                  .db $83,$1C,$84,$18,$01,$58,$1C,$82
                                  .db $10,$00,$50,$83,$1C,$00,$58,$81
                                  .db $1C,$01,$18,$14,$83,$1C,$00,$58
                                  .db $81,$14,$84,$1C,$84,$18,$01,$58
                                  .db $1C,$81,$10,$81,$50,$82,$1C,$00
                                  .db $18,$82,$1C,$81,$14,$83,$1C,$82
                                  .db $14,$84,$1C,$83,$18,$02,$98,$D8
                                  .db $1C,$81,$90,$01,$D0,$50,$81,$1C
                                  .db $81,$18,$00,$58,$81,$14,$81,$10
                                  .db $00,$50,$82,$1C,$00,$14,$81,$1C
                                  .db $81,$18,$00,$58,$81,$1C,$81,$98
                                  .db $82,$18,$02,$58,$14,$50,$81,$90
                                  .db $00,$10,$81,$14,$07,$58,$98,$18
                                  .db $14,$1C,$50,$90,$10,$85,$1C,$81
                                  .db $18,$01,$58,$18,$81,$58,$82,$18
                                  .db $81,$D8,$00,$1C,$81,$58,$81,$18
                                  .db $81,$1C,$81,$58,$00,$18,$81,$1C
                                  .db $02,$58,$1C,$18,$85,$1C,$88,$18
                                  .db $02,$58,$18,$1C,$81,$58,$81,$18
                                  .db $81,$1C,$81,$58,$00,$18,$81,$1C
                                  .db $02,$58,$1C,$18,$82,$1C,$8B,$18
                                  .db $02,$58,$18,$D4,$81,$58,$81,$18
                                  .db $01,$94,$1C,$81,$58,$06,$18,$1C
                                  .db $D4,$58,$1C,$18,$94,$81,$1C,$8B
                                  .db $18,$01,$58,$18,$81,$54,$01,$58
                                  .db $18,$81,$14,$00,$D4,$81,$58,$01
                                  .db $18,$94,$81,$54,$00,$1C,$81,$14
                                  .db $81,$1C,$8B,$18,$81,$58,$01,$1C
                                  .db $54,$82,$14,$00,$1C,$81,$54,$00
                                  .db $58,$81,$14,$01,$1C,$54,$81,$14
                                  .db $82,$1C,$8C,$18,$00,$58,$81,$18
                                  .db $00,$58,$83,$1C,$00,$54,$81,$14
                                  .db $87,$1C,$8F,$18,$81,$58,$8D,$1C
                                  .db $90,$18,$02,$58,$18,$58,$8B,$1C
                                  .db $91,$18,$81,$D8,$81,$1C,$81,$14
                                  .db $87,$1C,$91,$18,$02,$58,$18,$1C
                                  .db $82,$14,$87,$1C,$91,$18,$81,$58
                                  .db $00,$1C,$81,$14,$88,$1C,$91,$18
                                  .db $81,$D8,$8B,$1C,$88,$18,$00,$D8
                                  .db $84,$98,$81,$18,$81,$D8,$00,$18
                                  .db $81,$14,$82,$1C,$81,$14,$84,$1C
                                  .db $88,$18,$00,$58,$83,$1C,$81,$98
                                  .db $81,$D8,$81,$18,$86,$14,$84,$1C
                                  .db $81,$18,$82,$98,$00,$D8,$81,$98
                                  .db $01,$18,$58,$83,$1C,$02,$58,$98
                                  .db $D8,$82,$18,$00,$58,$83,$14,$86
                                  .db $1C,$01,$98,$D8,$81,$1C,$02,$98
                                  .db $D8,$1C,$81,$18,$00,$58,$83,$1C
                                  .db $81,$58,$83,$18,$83,$14,$88,$1C
                                  .db $00,$18,$81,$1C,$02,$58,$18,$1C
                                  .db $81,$98,$00,$D8,$83,$1C,$81,$58
                                  .db $82,$18,$82,$14,$89,$1C,$83,$14
                                  .db $00,$50,$83,$10,$82,$50,$81,$10
                                  .db $00,$14,$81,$18,$8C,$14,$81,$10
                                  .db $83,$14,$00,$50,$83,$10,$82,$50
                                  .db $82,$10,$81,$18,$85,$10,$81,$18
                                  .db $84,$14,$81,$10,$81,$14,$81,$18
                                  .db $00,$50,$83,$10,$82,$50,$82,$10
                                  .db $81,$18,$81,$10,$01,$50,$10,$83
                                  .db $18,$84,$14,$81,$10,$81,$14,$81
                                  .db $18,$00,$50,$83,$10,$83,$50,$81
                                  .db $10,$81,$18,$81,$10,$01,$50,$10
                                  .db $83,$18,$84,$14,$81,$10,$81,$14
                                  .db $81,$18,$00,$50,$83,$10,$81,$50
                                  .db $03,$10,$50,$10,$90,$82,$18,$01
                                  .db $10,$50,$82,$10,$82,$18,$83,$14
                                  .db $81,$10,$01,$14,$10,$81,$18,$00
                                  .db $50,$81,$10,$81,$90,$81,$D0,$81
                                  .db $50,$81,$10,$82,$18,$85,$10,$81
                                  .db $18,$00,$50,$82,$14,$81,$10,$01
                                  .db $14,$10,$81,$18,$81,$50,$82,$10
                                  .db $82,$50,$82,$10,$82,$18,$00,$10
                                  .db $81,$50,$01,$10,$D0,$82,$10,$00
                                  .db $50,$82,$14,$81,$10,$02,$14,$50
                                  .db $90,$81,$10,$81,$50,$81,$10,$81
                                  .db $50,$81,$10,$85,$18,$82,$50,$01
                                  .db $10,$50,$81,$10,$00,$50,$82,$14
                                  .db $81,$10,$02,$14,$54,$10,$81,$18
                                  .db $01,$D0,$50,$81,$10,$81,$50,$01
                                  .db $10,$90,$86,$18,$81,$50,$04,$10
                                  .db $50,$10,$D0,$10,$82,$14,$81,$10
                                  .db $02,$14,$54,$10,$81,$18,$81,$50
                                  .db $81,$10,$81,$50,$81,$10,$85,$18
                                  .db $82,$10,$00,$90,$82,$D0,$83,$14
                                  .db $81,$10,$01,$D4,$54,$83,$10,$00
                                  .db $50,$81,$10,$01,$50,$10,$87,$18
                                  .db $83,$10,$82,$50,$83,$14,$81,$10
                                  .db $81,$54,$82,$10,$00,$50,$81,$10
                                  .db $02,$50,$90,$10,$81,$18,$00,$10
                                  .db $83,$18,$81,$10,$07,$18,$10,$50
                                  .db $90,$10,$50,$14,$94,$81,$14,$81
                                  .db $10,$08,$14,$54,$10,$50,$10,$90
                                  .db $10,$50,$90,$81,$10,$84,$50,$81
                                  .db $18,$07,$10,$50,$10,$50,$90,$10
                                  .db $18,$50,$83,$14,$81,$10,$81,$14
                                  .db $81,$10,$04,$90,$50,$10,$50,$90
                                  .db $85,$10,$00,$50,$81,$18,$01,$90
                                  .db $D0,$81,$90,$03,$10,$18,$10,$50
                                  .db $83,$14,$81,$D0,$81,$14,$83,$90
                                  .db $01,$50,$90,$81,$18,$00,$50,$84
                                  .db $10,$81,$18,$01,$10,$50,$81,$10
                                  .db $81,$90,$81,$D0,$83,$14,$81,$50
                                  .db $81,$14,$00,$54,$81,$14,$81,$10
                                  .db $00,$50,$81,$18,$00,$50,$82,$10
                                  .db $01,$50,$10,$81,$18,$03,$10,$50
                                  .db $18,$50,$87,$14,$81,$50,$81,$14
                                  .db $00,$54,$81,$14,$81,$10,$05,$50
                                  .db $10,$50,$90,$D0,$90,$82,$D0,$05
                                  .db $10,$50,$10,$50,$10,$50,$87,$14
                                  .db $81,$50,$02,$14,$D4,$54,$81,$14
                                  .db $02,$10,$90,$D0,$81,$90,$85,$10
                                  .db $81,$D0,$03,$90,$D0,$10,$50,$83
                                  .db $14,$00,$94,$82,$14,$81,$50,$00
                                  .db $14,$82,$54,$01,$14,$50,$8E,$90
                                  .db $00,$10,$87,$14,$81,$50,$82,$14
                                  .db $01,$54,$14,$81,$50,$8E,$10,$87
                                  .db $14,$81,$50,$84,$14,$81,$50,$8E
                                  .db $10,$87,$14,$81,$50,$00,$10,$81
                                  .db $50,$86,$10,$00,$50,$88,$10,$00
                                  .db $50,$83,$10,$00,$50,$81,$10,$81
                                  .db $50,$8B,$10,$00,$50,$83,$10,$00
                                  .db $D0,$86,$10,$00,$50,$82,$10,$82
                                  .db $50,$84,$10,$01,$50,$90,$83,$10
                                  .db $04,$D0,$10,$50,$10,$50,$87,$10
                                  .db $83,$50,$81,$10,$81,$50,$84,$10
                                  .db $00,$50,$83,$90,$81,$D0,$01,$10
                                  .db $50,$84,$10,$00,$50,$85,$10,$81
                                  .db $50,$81,$10,$81,$50,$82,$10,$01
                                  .db $D0,$10,$81,$50,$82,$10,$00,$50
                                  .db $81,$10,$00,$50,$83,$10,$01,$90
                                  .db $D0,$83,$90,$00,$D0,$81,$10,$84
                                  .db $50,$83,$10,$82,$50,$82,$10,$00
                                  .db $50,$81,$10,$00,$50,$81,$18,$88
                                  .db $10,$02,$D0,$90,$10,$83,$50,$84
                                  .db $10,$82,$50,$85,$10,$81,$18,$86
                                  .db $90,$83,$10,$01,$50,$10,$82,$50
                                  .db $86,$10,$00,$50,$82,$10,$00,$D0
                                  .db $81,$10,$02,$18,$D8,$50,$84,$10
                                  .db $82,$90,$81,$10,$01,$50,$10,$82
                                  .db $50,$85,$10,$00,$D0,$82,$90,$81
                                  .db $D0,$81,$10,$81,$D8,$00,$50,$86
                                  .db $10,$82,$90,$02,$D0,$10,$50,$86
                                  .db $10,$00,$D0,$87,$10,$02,$58,$14
                                  .db $50,$84,$10,$02,$50,$10,$50,$81
                                  .db $10,$00,$50,$87,$10,$81,$D0,$85
                                  .db $10,$03,$50,$D8,$58,$14,$81,$54
                                  .db $88,$10,$00,$50,$8B,$10,$00,$50
                                  .db $96,$10,$81,$14,$85,$10,$81,$50
                                  .db $95,$10,$81,$14,$01,$10,$50,$84
                                  .db $10,$00,$50,$95,$10,$81,$14,$01
                                  .db $90,$D0,$81,$90,$82,$10,$00,$50
                                  .db $91,$10,$81,$50,$81,$10,$81,$14
                                  .db $01,$10,$50,$81,$10,$83,$D0,$92
                                  .db $10,$00,$50,$81,$10,$81,$14,$01
                                  .db $10,$50,$81,$10,$00,$D0,$81,$50
                                  .db $00,$10,$8E,$18,$86,$10,$81,$14
                                  .db $82,$10,$81,$D0,$81,$50,$00,$10
                                  .db $8E,$18,$01,$50,$90,$84,$10,$81
                                  .db $14,$81,$10,$81,$D0,$81,$10,$01
                                  .db $50,$10,$8E,$18,$00,$50,$82,$90
                                  .db $82,$10,$81,$14,$81,$10,$81,$50
                                  .db $81,$10,$01,$50,$10,$86,$18,$00
                                  .db $58,$84,$18,$01,$D8,$98,$82,$50
                                  .db $00,$90,$82,$D0,$81,$14,$81,$10
                                  .db $81,$50,$81,$10,$01,$50,$10,$86
                                  .db $18,$00,$58,$83,$18,$81,$D8,$87
                                  .db $50,$81,$14,$81,$10,$81,$50,$81
                                  .db $10,$03,$50,$10,$18,$58,$84,$18
                                  .db $00,$58,$82,$18,$81,$58,$81,$14
                                  .db $86,$50,$81,$14,$82,$10,$00,$50
                                  .db $81,$10,$03,$50,$10,$98,$D8,$83
                                  .db $98,$85,$18,$01,$58,$14,$81,$54
                                  .db $85,$50,$81,$14,$81,$10,$01,$D0
                                  .db $10,$81,$50,$82,$18,$00,$58,$83
                                  .db $18,$01,$98,$D8,$81,$18,$01,$98
                                  .db $D8,$81,$58,$81,$18,$81,$58,$83
                                  .db $50,$81,$14,$82,$D0,$00,$10,$84
                                  .db $18,$00,$58,$8A,$18,$00,$58,$83
                                  .db $18,$00,$58,$82,$50,$81,$14,$82
                                  .db $50,$00,$10,$84,$18,$00,$58,$84
                                  .db $18,$00,$58,$82,$18,$00,$58,$82
                                  .db $18,$00,$58,$85,$18,$81,$14,$03
                                  .db $50,$10,$50,$10,$81,$98,$81,$18
                                  .db $01,$98,$D8,$83,$98,$81,$18,$82
                                  .db $98,$00,$D8,$82,$98,$00,$D8,$81
                                  .db $98,$00,$D8,$82,$18,$81,$14,$04
                                  .db $50,$10,$50,$10,$50,$81,$98,$86
                                  .db $18,$01,$98,$D8,$8A,$18,$81,$D8
                                  .db $00,$18,$81,$14,$82,$50,$02,$10
                                  .db $14,$54,$82,$98,$01,$10,$50,$86
                                  .db $18,$01,$10,$50,$81,$18,$04,$10
                                  .db $50,$18,$10,$50,$82,$18,$81,$14
                                  .db $04,$50,$10,$50,$10,$18,$81,$54
                                  .db $00,$50,$81,$10,$81,$50,$81,$18
                                  .db $84,$10,$00,$50,$82,$10,$00,$50
                                  .db $81,$10,$00,$50,$82,$18,$81,$14
                                  .db $82,$50,$03,$10,$94,$18,$54,$83
                                  .db $10,$00,$50,$8D,$10,$00,$50,$82
                                  .db $10,$81,$14,$02,$50,$10,$50,$81
                                  .db $14,$00,$18,$97,$10,$81,$14,$9D
                                  .db $10,$81,$50,$9D,$10,$81,$50,$9D
                                  .db $10,$81,$50,$9D,$10,$81,$50,$9D
                                  .db $10,$81,$50,$82,$10,$00,$14,$81
                                  .db $10,$81,$14,$81,$10,$82,$14,$81
                                  .db $10,$00,$14,$81,$10,$00,$14,$81
                                  .db $10,$00,$14,$81,$10,$00,$14,$88
                                  .db $10,$08,$14,$10,$14,$10,$14,$10
                                  .db $14,$10,$14,$82,$10,$0A,$14,$10
                                  .db $14,$10,$14,$10,$14,$10,$14,$10
                                  .db $14,$88,$10,$00,$14,$82,$10,$04
                                  .db $14,$10,$14,$10,$14,$82,$10,$00
                                  .db $14,$82,$10,$06,$14,$10,$14,$10
                                  .db $14,$10,$14,$89,$10,$00,$14,$81
                                  .db $10,$03,$14,$10,$14,$10,$82,$14
                                  .db $01,$10,$14,$82,$10,$01,$14,$10
                                  .db $82,$14,$01,$10,$14,$8A,$10,$01
                                  .db $14,$10,$81,$14,$81,$10,$00,$14
                                  .db $82,$10,$00,$14,$82,$10,$06,$14
                                  .db $10,$14,$10,$14,$10,$14,$88,$10
                                  .db $04,$14,$10,$14,$10,$14,$82,$10
                                  .db $00,$14,$82,$10,$0A,$14,$10,$14
                                  .db $10,$14,$10,$14,$10,$14,$10,$14
                                  .db $86,$10,$81,$90,$87,$10,$82,$18
                                  .db $81,$58,$00,$54,$83,$14,$81,$54
                                  .db $00,$50,$81,$10,$00,$50,$88,$10
                                  .db $00,$50,$83,$10,$85,$18,$00,$58
                                  .db $85,$18,$81,$54,$02,$10,$90,$D0
                                  .db $87,$10,$81,$50,$8A,$18,$00,$94
                                  .db $85,$18,$82,$10,$00,$50,$87,$10
                                  .db $81,$50,$88,$18,$00,$58,$81,$14
                                  .db $85,$18,$82,$10,$00,$50,$88,$10
                                  .db $81,$50,$85,$18,$03,$58,$18,$58
                                  .db $14,$86,$18,$82,$10,$00,$50,$89
                                  .db $10,$81,$50,$83,$18,$03,$98,$D8
                                  .db $98,$58,$87,$18,$83,$10,$00,$50
                                  .db $89,$10,$03,$50,$18,$10,$50,$81
                                  .db $18,$01,$58,$18,$81,$58,$86,$18
                                  .db $01,$10,$90,$81,$10,$00,$D0,$89
                                  .db $10,$00,$50,$81,$10,$81,$50,$05
                                  .db $18,$58,$18,$10,$50,$58,$81,$18
                                  .db $85,$10,$01,$50,$90,$8E,$10,$00
                                  .db $50,$83,$10,$00,$50,$87,$10,$01
                                  .db $50,$90,$9B,$10,$82,$90,$87,$10
                                  .db $81,$1C,$00,$5C,$81,$1C,$81,$5C
                                  .db $81,$1C,$81,$5C,$00,$10,$81,$1C
                                  .db $81,$5C,$01,$10,$50,$81,$1C,$81
                                  .db $5C,$81,$1C,$81,$5C,$01,$10,$50
                                  .db $81,$10,$81,$1C,$82,$10,$81,$1C
                                  .db $81,$5C,$81,$1C,$81,$5C,$00,$10
                                  .db $81,$1C,$81,$5C,$01,$10,$50,$81
                                  .db $1C,$81,$5C,$81,$1C,$81,$5C,$01
                                  .db $10,$50,$81,$10,$83,$1C,$81,$5C
                                  .db $00,$1C,$81,$5C,$81,$1C,$81,$5C
                                  .db $00,$10,$81,$1C,$81,$5C,$01,$10
                                  .db $50,$81,$1C,$81,$5C,$81,$1C,$00
                                  .db $5C,$81,$1C,$81,$5C,$00,$10,$83
                                  .db $1C,$81,$5C,$84,$10,$00,$50,$86
                                  .db $10,$00,$50,$81,$1C,$81,$5C,$82
                                  .db $10,$81,$1C,$81,$5C,$00,$10,$83
                                  .db $1C,$81,$5C,$81,$1C,$81,$5C,$01
                                  .db $10,$50,$82,$10,$06,$50,$10,$50
                                  .db $10,$50,$10,$50,$81,$10,$81,$1C
                                  .db $81,$5C,$03,$1C,$5C,$1C,$10,$83
                                  .db $1C,$81,$5C,$81,$1C,$81,$5C,$84
                                  .db $10,$08,$50,$10,$50,$90,$D0,$10
                                  .db $50,$10,$50,$81,$1C,$81,$5C,$83
                                  .db $10,$83,$1C,$81,$5C,$81,$1C,$81
                                  .db $5C,$82,$10,$02,$50,$10,$50,$86
                                  .db $10,$00,$50,$81,$1C,$81,$5C,$81
                                  .db $1C,$01,$5C,$10,$83,$1C,$81,$5C
                                  .db $81,$1C,$81,$5C,$82,$10,$02,$50
                                  .db $10,$50,$81,$1C,$81,$5C,$03,$10
                                  .db $50,$10,$50,$81,$1C,$81,$5C,$81
                                  .db $1C,$01,$5C,$10,$83,$1C,$81,$5C
                                  .db $81,$1C,$81,$5C,$82,$10,$02,$50
                                  .db $10,$50,$81,$1C,$81,$5C,$03,$10
                                  .db $50,$10,$50,$81,$1C,$81,$5C,$81
                                  .db $1C,$01,$5C,$10,$83,$1C,$81,$5C
                                  .db $81,$1C,$81,$5C,$82,$10,$02,$50
                                  .db $10,$50,$81,$1C,$81,$5C,$83,$10
                                  .db $81,$1C,$81,$5C,$83,$10,$83,$1C
                                  .db $00,$5C,$81,$1C,$81,$5C,$81,$10
                                  .db $00,$50,$82,$10,$02,$50,$10,$50
                                  .db $81,$10,$09,$50,$10,$14,$54,$10
                                  .db $50,$10,$50,$10,$50,$81,$10,$81
                                  .db $1C,$82,$10,$81,$1C,$81,$5C,$81
                                  .db $10,$00,$50,$82,$10,$02,$50,$10
                                  .db $50,$81,$10,$09,$50,$10,$94,$D4
                                  .db $10,$50,$10,$50,$10,$50,$81,$10
                                  .db $81,$18,$81,$1C,$81,$5C,$00,$1C
                                  .db $81,$5C,$83,$10,$00,$50,$83,$10
                                  .db $00,$50,$81,$10,$00,$50,$82,$10
                                  .db $00,$50,$81,$1C,$81,$5C,$83,$10
                                  .db $81,$1C,$81,$5C,$01,$10,$50,$84
                                  .db $10,$00,$50,$81,$10,$02,$50,$10
                                  .db $50,$81,$10,$00,$50,$82,$10,$00
                                  .db $50,$81,$1C,$81,$5C,$83,$10,$81
                                  .db $1C,$81,$5C,$05,$10,$50,$10,$50
                                  .db $10,$50,$83,$10,$00,$50,$81,$10
                                  .db $00,$50,$81,$10,$00,$50,$81,$1C
                                  .db $81,$5C,$00,$1C,$81,$5C,$81,$10
                                  .db $81,$18,$01,$10,$50,$81,$1C,$81
                                  .db $5C,$03,$10,$50,$10,$50,$81,$1C
                                  .db $81,$5C,$82,$10,$00,$50,$81,$10
                                  .db $00,$50,$81,$1C,$81,$5C,$81,$10
                                  .db $00,$50,$84,$10,$00,$50,$81,$1C
                                  .db $81,$5C,$03,$10,$50,$10,$50,$81
                                  .db $1C,$81,$5C,$03,$10,$50,$10,$50
                                  .db $81,$1C,$81,$5C,$00,$1C,$81,$5C
                                  .db $81,$10,$00,$50,$85,$10,$81,$1C
                                  .db $81,$5C,$03,$10,$50,$10,$50,$81
                                  .db $1C,$81,$5C,$03,$10,$50,$10,$50
                                  .db $81,$1C,$81,$5C,$01,$10,$50,$81
                                  .db $1C,$81,$5C,$85,$10,$00,$50,$82
                                  .db $10,$02,$50,$10,$50,$81,$10,$00
                                  .db $50,$81,$1C,$81,$5C,$81,$10,$81
                                  .db $1C,$81,$5C,$01,$10,$50,$81,$1C
                                  .db $81,$5C,$81,$10,$81,$18,$81,$10
                                  .db $00,$50,$82,$10,$02,$50,$10,$50
                                  .db $81,$10,$00,$50,$81,$1C,$81,$5C
                                  .db $01,$10,$50,$81,$1C,$81,$5C,$01
                                  .db $10,$50,$81,$1C,$81,$5C,$81,$10
                                  .db $81,$18,$00,$10,$81,$1C,$81,$5C
                                  .db $81,$10,$81,$1C,$81,$5C,$00,$10
                                  .db $81,$1C,$81,$5C,$01,$10,$50,$81
                                  .db $1C,$81,$5C,$01,$10,$50,$87,$10
                                  .db $83,$14,$00,$50,$83,$10,$82,$50
                                  .db $81,$10,$8F,$14,$84,$10,$00,$14
                                  .db $81,$10,$00,$14,$82,$10,$82,$14
                                  .db $81,$10,$00,$14,$81,$10,$05,$14
                                  .db $10,$14,$10,$14,$10,$82,$14,$82
                                  .db $10,$81,$90,$A5,$10,$01,$54,$14
                                  .db $83,$10,$01,$54,$14,$83,$10,$01
                                  .db $54,$14,$83,$10,$01,$54,$14,$8B
                                  .db $10,$01,$D4,$94,$83,$10,$01,$D4
                                  .db $94,$83,$10,$01,$D4,$94,$83,$10
                                  .db $01,$D4,$94,$C8,$10,$82,$50,$01
                                  .db $10,$50,$83,$10,$01,$54,$14,$83
                                  .db $10,$01,$54,$14,$83,$10,$01,$54
                                  .db $14,$87,$10,$00,$90,$82,$D0,$01
                                  .db $90,$D0,$83,$10,$01,$D4,$94,$83
                                  .db $10,$01,$D4,$94,$83,$10,$01,$D4
                                  .db $94,$C5,$10,$83,$1C,$00,$14,$88
                                  .db $1C,$01,$18,$58,$81,$1C,$01,$54
                                  .db $14,$89,$1C,$81,$10,$81,$1C,$81
                                  .db $14,$86,$1C,$08,$14,$1C,$18,$10
                                  .db $50,$58,$1C,$D4,$94,$82,$1C,$00
                                  .db $14,$85,$1C,$81,$10,$00,$1C,$82
                                  .db $14,$82,$1C,$01,$54,$14,$82,$1C
                                  .db $00,$18,$81,$10,$81,$50,$00,$58
                                  .db $8B,$1C,$81,$10,$00,$1C,$82,$14
                                  .db $82,$1C,$01,$D4,$94,$82,$1C,$81
                                  .db $10,$00,$90,$81,$10,$03,$50,$58
                                  .db $1C,$14,$83,$1C,$01,$54,$14,$82
                                  .db $1C,$81,$10,$8A,$1C,$00,$18,$82
                                  .db $10,$00,$D0,$81,$10,$00,$50,$85
                                  .db $1C,$01,$D4,$94,$82,$1C,$81,$10
                                  .db $82,$1C,$87,$18,$84,$10,$02,$D0
                                  .db $10,$50,$86,$18,$00,$58,$82,$1C
                                  .db $81,$10,$02,$54,$14,$1C,$81,$10
                                  .db $00,$50,$84,$10,$00,$50,$84,$10
                                  .db $02,$D0,$10,$50,$84,$10,$81,$50
                                  .db $82,$1C,$81,$10,$05,$D4,$94,$1C
                                  .db $10,$90,$D0,$84,$90,$00,$D0,$85
                                  .db $10,$01,$90,$D0,$84,$10,$01,$D0
                                  .db $50,$82,$1C,$81,$10,$82,$1C,$00
                                  .db $50,$87,$10,$00,$18,$83,$10,$00
                                  .db $18,$84,$10,$02,$50,$90,$D0,$83
                                  .db $1C,$81,$10,$04,$1C,$14,$1C,$50
                                  .db $90,$85,$10,$00,$18,$85,$10,$00
                                  .db $18,$82,$10,$03,$50,$90,$D0,$DC
                                  .db $83,$1C,$81,$10,$82,$1C,$02,$50
                                  .db $10,$50,$82,$10,$02,$50,$10,$18
                                  .db $85,$10,$00,$18,$82,$10,$01,$90
                                  .db $D0,$85,$1C,$81,$10,$82,$18,$00
                                  .db $50,$81,$10,$00,$90,$81,$10,$00
                                  .db $D0,$81,$10,$00,$18,$83,$10,$00
                                  .db $18,$81,$10,$06,$90,$D0,$10,$5C
                                  .db $1C,$5C,$1C,$82,$18,$84,$10,$02
                                  .db $50,$10,$50,$88,$10,$00,$50,$83
                                  .db $10,$00,$50,$81,$10,$00,$5C,$82
                                  .db $1C,$82,$18,$83,$10,$06,$18,$50
                                  .db $10,$D0,$10,$50,$90,$84,$10,$00
                                  .db $90,$84,$10,$00,$50,$81,$10,$01
                                  .db $50,$9C,$81,$1C,$84,$10,$81,$18
                                  .db $01,$10,$50,$81,$10,$01,$50,$90
                                  .db $85,$10,$01,$D0,$90,$81,$D0,$85
                                  .db $10,$02,$50,$5C,$1C,$82,$18,$82
                                  .db $10,$81,$18,$03,$D0,$10,$50,$90
                                  .db $85,$10,$01,$D0,$1C,$82,$90,$81
                                  .db $D0,$85,$10,$00,$9C,$8F,$10,$05
                                  .db $D0,$9C,$DC,$1C,$50,$10,$81,$90
                                  .db $00,$10,$81,$D0,$82,$10,$02,$50
                                  .db $10,$50,$87,$10,$01,$90,$D0,$81
                                  .db $10,$00,$D0,$81,$9C,$83,$1C,$00
                                  .db $50,$81,$10,$01,$50,$D0,$81,$10
                                  .db $81,$D0,$03,$10,$D0,$10,$50,$83
                                  .db $10,$00,$18,$84,$10,$02,$D0,$9C
                                  .db $DC,$82,$1C,$00,$5C,$81,$1C,$00
                                  .db $50,$82,$10,$83,$D0,$00,$90,$82
                                  .db $10,$00,$1C,$83,$10,$81,$18,$81
                                  .db $90,$81,$9C,$02,$DC,$1C,$5C,$82
                                  .db $1C,$00,$5C,$81,$1C,$82,$10,$00
                                  .db $50,$83,$10,$00,$50,$81,$90,$01
                                  .db $DC,$1C,$85,$10,$02,$50,$10,$5C
                                  .db $86,$1C,$00,$5C,$81,$1C,$00,$50
                                  .db $86,$10,$00,$50,$81,$10,$81,$1C
                                  .db $89,$10,$00,$50,$96,$10,$81,$14
DATA_04D678:                      .db $00,$C0,$C0,$C0,$30,$C0,$C0,$00
                                  .db $C0,$20,$30,$C0,$C0,$C0,$C0,$D0
                                  .db $40,$40,$40,$D0,$40,$80,$80,$00
                                  .db $00,$00,$00,$40,$00,$80,$20,$80
                                  .db $40,$40,$80,$60,$90,$00,$00,$C0
                                  .db $00,$00,$00,$C0,$40,$20,$40,$C0
                                  .db $E0,$C0,$00,$C0,$00,$00,$C0,$20
                                  .db $80,$80,$80,$80,$30,$40,$E0,$00
                                  .db $40,$E0,$E0,$D0,$70,$FF,$40,$90
                                  .db $55,$80,$80,$80,$80,$00,$C0,$C0
                                  .db $C0,$C0,$40,$00,$80,$A0,$30,$AA
                                  .db $60,$D0,$80,$00,$55,$55,$00,$00
                                  .db $AA,$55,$FF,$FF,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00

CODE_04D6E9:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04D6EB:        64 1C         STZ RAM_ScreenBndryYLo    
CODE_04D6ED:        A9 FF FF      LDA.W #$FFFF              
CODE_04D6F0:        85 4D         STA $4D                   
CODE_04D6F2:        85 4F         STA $4F                   
CODE_04D6F4:        A9 02 02      LDA.W #$0202              
CODE_04D6F7:        85 55         STA $55                   
CODE_04D6F9:        AD D6 0D      LDA.W $0DD6               
CODE_04D6FC:        4A            LSR                       
CODE_04D6FD:        4A            LSR                       
CODE_04D6FE:        29 FF 00      AND.W #$00FF              
CODE_04D701:        AA            TAX                       
CODE_04D702:        BD 11 1F      LDA.W $1F11,X             
CODE_04D705:        29 0F 00      AND.W #$000F              
CODE_04D708:        F0 0A         BEQ CODE_04D714           
CODE_04D70A:        A9 20 00      LDA.W #$0020              
CODE_04D70D:        85 47         STA $47                   
CODE_04D70F:        A9 00 02      LDA.W #$0200              
CODE_04D712:        85 1C         STA RAM_ScreenBndryYLo    
CODE_04D714:        22 1A 88 05   JSL.L CODE_05881A         
CODE_04D718:        22 AD 87 00   JSL.L CODE_0087AD         
CODE_04D71C:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04D71E:        E6 47         INC $47                   
CODE_04D720:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_04D722:        18            CLC                       
CODE_04D723:        69 10 00      ADC.W #$0010              
CODE_04D726:        85 1C         STA RAM_ScreenBndryYLo    
CODE_04D728:        29 FF 01      AND.W #$01FF              
CODE_04D72B:        D0 E7         BNE CODE_04D714           
CODE_04D72D:        A5 20         LDA $20                   
CODE_04D72F:        85 1C         STA RAM_ScreenBndryYLo    
CODE_04D731:        64 47         STZ $47                   
CODE_04D733:        9C 25 19      STZ.W $1925               
CODE_04D736:        64 5B         STZ RAM_IsVerticalLvl     
CODE_04D738:        A9 FF FF      LDA.W #$FFFF              
CODE_04D73B:        85 4D         STA $4D                   
CODE_04D73D:        85 4F         STA $4F                   
CODE_04D73F:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04D741:        A9 80         LDA.B #$80                
CODE_04D743:        8D 15 21      STA.W $2115               ; VRAM Address Increment Value
CODE_04D746:        9C 16 21      STZ.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_04D749:        A9 30         LDA.B #$30                
CODE_04D74B:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_04D74E:        A2 06         LDX.B #$06                
CODE_04D750:        BF B3 DA 04   LDA.L DATA_04DAB3,X       
CODE_04D754:        9D 10 43      STA.W $4310,X             
CODE_04D757:        CA            DEX                       
CODE_04D758:        10 F6         BPL CODE_04D750           
CODE_04D75A:        AD D6 0D      LDA.W $0DD6               
CODE_04D75D:        4A            LSR                       
CODE_04D75E:        4A            LSR                       
CODE_04D75F:        AA            TAX                       
CODE_04D760:        BD 11 1F      LDA.W $1F11,X             
CODE_04D763:        F0 05         BEQ CODE_04D76A           
CODE_04D765:        A9 60         LDA.B #$60                
CODE_04D767:        8D 13 43      STA.W $4313               ; A Address (High Byte)
CODE_04D76A:        A9 02         LDA.B #$02                
CODE_04D76C:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
Return04D76F:       6B            RTL                       ; Return 

CODE_04D770:        9F 00 C8 7F   STA.L $7FC800,X           
CODE_04D774:        9F B0 C9 7F   STA.L $7FC9B0,X           
CODE_04D778:        9F 60 CB 7F   STA.L $7FCB60,X           
CODE_04D77C:        9F 10 CD 7F   STA.L $7FCD10,X           
CODE_04D780:        9F C0 CE 7F   STA.L $7FCEC0,X           
CODE_04D784:        9F 70 D0 7F   STA.L $7FD070,X           
CODE_04D788:        9F 20 D2 7F   STA.L $7FD220,X           
CODE_04D78C:        9F D0 D3 7F   STA.L $7FD3D0,X           
CODE_04D790:        9F 80 D5 7F   STA.L $7FD580,X           
CODE_04D794:        9F 30 D7 7F   STA.L $7FD730,X           
CODE_04D798:        9F E0 D8 7F   STA.L $7FD8E0,X           
CODE_04D79C:        9F 90 DA 7F   STA.L $7FDA90,X           
CODE_04D7A0:        9F 40 DC 7F   STA.L $7FDC40,X           
CODE_04D7A4:        9F F0 DD 7F   STA.L $7FDDF0,X           
CODE_04D7A8:        9F A0 DF 7F   STA.L $7FDFA0,X           
CODE_04D7AC:        9F 50 E1 7F   STA.L $7FE150,X           
CODE_04D7B0:        9F 00 E3 7F   STA.L $7FE300,X           
CODE_04D7B4:        9F B0 E4 7F   STA.L $7FE4B0,X           
CODE_04D7B8:        9F 60 E6 7F   STA.L $7FE660,X           
CODE_04D7BC:        9F 10 E8 7F   STA.L $7FE810,X           
CODE_04D7C0:        9F C0 E9 7F   STA.L $7FE9C0,X           
CODE_04D7C4:        9F 70 EB 7F   STA.L $7FEB70,X           
CODE_04D7C8:        9F 20 ED 7F   STA.L $7FED20,X           
CODE_04D7CC:        9F D0 EE 7F   STA.L $7FEED0,X           
CODE_04D7D0:        9F 80 F0 7F   STA.L $7FF080,X           
CODE_04D7D4:        9F 30 F2 7F   STA.L $7FF230,X           
CODE_04D7D8:        9F E0 F3 7F   STA.L $7FF3E0,X           
CODE_04D7DC:        9F 90 F5 7F   STA.L $7FF590,X           
CODE_04D7E0:        9F 40 F7 7F   STA.L $7FF740,X           
CODE_04D7E4:        9F F0 F8 7F   STA.L $7FF8F0,X           
CODE_04D7E8:        9F A0 FA 7F   STA.L $7FFAA0,X           
CODE_04D7EC:        9F 50 FC 7F   STA.L $7FFC50,X           
CODE_04D7F0:        E8            INX                       
Return04D7F1:       60            RTS                       ; Return 

CODE_04D7F2:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04D7F4:        A9 00 00      LDA.W #$0000              
CODE_04D7F7:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04D7F9:        A9 00         LDA.B #$00                
CODE_04D7FB:        85 0D         STA $0D                   
CODE_04D7FD:        A9 D0         LDA.B #$D0                
CODE_04D7FF:        85 0E         STA $0E                   
CODE_04D801:        A9 7E         LDA.B #$7E                
CODE_04D803:        85 0F         STA $0F                   
CODE_04D805:        A9 00         LDA.B #$00                
CODE_04D807:        85 0A         STA $0A                   
CODE_04D809:        A9 D8         LDA.B #$D8                
CODE_04D80B:        85 0B         STA $0B                   
CODE_04D80D:        A9 7E         LDA.B #$7E                
CODE_04D80F:        85 0C         STA $0C                   
CODE_04D811:        A9 00         LDA.B #$00                
CODE_04D813:        85 04         STA $04                   
CODE_04D815:        A9 C8         LDA.B #$C8                
CODE_04D817:        85 05         STA $05                   
CODE_04D819:        A9 7E         LDA.B #$7E                
CODE_04D81B:        85 06         STA $06                   
CODE_04D81D:        A0 01 00      LDY.W #$0001              
CODE_04D820:        84 00         STY $00                   
CODE_04D822:        A0 FF 07      LDY.W #$07FF              
CODE_04D825:        A9 00         LDA.B #$00                
CODE_04D827:        97 0A         STA [$0A],Y               
CODE_04D829:        97 0D         STA [$0D],Y               
CODE_04D82B:        88            DEY                       
CODE_04D82C:        10 F9         BPL CODE_04D827           
CODE_04D82E:        A0 00 00      LDY.W #$0000              
CODE_04D831:        BB            TYX                       
CODE_04D832:        B7 04         LDA [$04],Y               
CODE_04D834:        C9 56         CMP.B #$56                
CODE_04D836:        90 11         BCC CODE_04D849           
CODE_04D838:        C9 81         CMP.B #$81                
CODE_04D83A:        B0 0D         BCS CODE_04D849           
CODE_04D83C:        A5 00         LDA $00                   
CODE_04D83E:        97 0D         STA [$0D],Y               
CODE_04D840:        AA            TAX                       
CODE_04D841:        BF 78 D6 04   LDA.L DATA_04D678,X       
CODE_04D845:        97 0A         STA [$0A],Y               
CODE_04D847:        E6 00         INC $00                   
CODE_04D849:        C8            INY                       
CODE_04D84A:        C0 00 08      CPY.W #$0800              
CODE_04D84D:        D0 E3         BNE CODE_04D832           
CODE_04D84F:        64 0F         STZ $0F                   
CODE_04D851:        20 49 DA      JSR.W CODE_04DA49         
CODE_04D854:        E6 0F         INC $0F                   
CODE_04D856:        A5 0F         LDA $0F                   
CODE_04D858:        C9 6F         CMP.B #$6F                
CODE_04D85A:        D0 F5         BNE CODE_04D851           
Return04D85C:       60            RTS                       ; Return 


DATA_04D85D:                      .db $00,$00,$00,$00,$00,$00,$69,$04
                                  .db $4B,$04,$29,$04,$09,$04,$D3,$00
                                  .db $E5,$00,$A5,$00,$D1,$00,$85,$00
                                  .db $A9,$00,$CB,$00,$BD,$00,$9D,$00
                                  .db $A5,$00,$07,$02,$00,$00,$27,$02
                                  .db $12,$05,$08,$06,$E3,$04,$C8,$04
                                  .db $2A,$06,$EC,$04,$0C,$06,$1C,$06
                                  .db $4A,$06,$00,$00,$E0,$04,$3E,$00
                                  .db $30,$01,$34,$01,$36,$01,$3A,$01
                                  .db $00,$00,$57,$01,$84,$01,$3A,$01
                                  .db $00,$00,$00,$00,$AA,$06,$76,$06
                                  .db $C8,$06,$AC,$06,$76,$06,$00,$00
                                  .db $00,$00,$A4,$06,$AA,$06,$C4,$06
                                  .db $00,$00,$04,$03,$00,$00,$00,$00
                                  .db $79,$05,$77,$05,$59,$05,$74,$05
                                  .db $00,$00,$54,$05,$00,$00,$34,$05
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$B3,$03,$00,$00
                                  .db $00,$00,$00,$00,$DF,$02,$DC,$02
                                  .db $00,$00,$7E,$02,$00,$00,$00,$00
                                  .db $00,$00,$E0,$04,$E0,$04,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$34,$05,$34,$05
                                  .db $00,$00,$00,$00,$87,$07,$00,$00
                                  .db $F0,$01,$68,$03,$65,$03,$B5,$03
                                  .db $00,$00,$36,$07,$39,$07,$3C,$07
                                  .db $1C,$07,$19,$07,$16,$07,$13,$07
                                  .db $11,$07,$00,$00,$00,$00,$00,$00
DATA_04D93D:                      .db $00,$00,$00,$00,$00,$00,$21,$92
                                  .db $21,$16,$20,$92,$20,$12,$23,$46
                                  .db $23,$8A,$22,$8A,$23,$42,$22,$0A
                                  .db $22,$92,$23,$16,$22,$DA,$22,$5A
                                  .db $22,$8A,$28,$0E,$00,$00,$28,$8E
                                  .db $24,$04,$28,$10,$23,$86,$23,$10
                                  .db $28,$94,$23,$98,$28,$18,$28,$58
                                  .db $29,$14,$00,$00,$23,$80,$20,$DC
                                  .db $24,$C0,$24,$C8,$24,$CC,$24,$D4
                                  .db $00,$00,$25,$4E,$26,$08,$24,$D4
                                  .db $00,$00,$00,$00,$2A,$94,$29,$CC
                                  .db $2B,$10,$2A,$98,$29,$CC,$00,$00
                                  .db $00,$00,$2A,$88,$2A,$94,$2B,$08
                                  .db $00,$00,$2C,$08,$00,$00,$00,$00
                                  .db $25,$D2,$25,$CE,$25,$52,$25,$C8
                                  .db $00,$00,$25,$48,$00,$00,$24,$C8
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$2E,$C6,$00,$00
                                  .db $00,$00,$00,$00,$2B,$5E,$2B,$58
                                  .db $00,$00,$29,$DC,$00,$00,$00,$00
                                  .db $00,$00,$23,$80,$23,$80,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$24,$C8,$24,$C8
                                  .db $00,$00,$00,$00,$2E,$0E,$00,$00
                                  .db $27,$C0,$2D,$90,$2D,$8A,$2E,$CA
                                  .db $00,$00,$2C,$CC,$2C,$D2,$2C,$D8
                                  .db $2C,$58,$2C,$52,$2C,$4C,$2C,$46
                                  .db $2C,$42,$00,$00,$00,$00,$00,$00
DATA_04DA1D:                      .db $6E,$6F,$70,$71,$72,$73,$74,$75
                                  .db $59,$53,$52,$83,$4D,$57,$5A,$76
                                  .db $78,$7A,$7B,$7D,$7F,$54

DATA_04DA33:                      .db $66,$67,$68,$69,$6A,$6B,$6C,$6D
                                  .db $58,$43,$44,$45,$25,$5E,$5F,$77
                                  .db $79,$63,$7C,$7E,$80,$23

CODE_04DA49:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04DA4B:        A5 0F         LDA $0F                   
CODE_04DA4D:        29 F8 00      AND.W #$00F8              
CODE_04DA50:        4A            LSR                       
CODE_04DA51:        4A            LSR                       
CODE_04DA52:        4A            LSR                       
CODE_04DA53:        A8            TAY                       
CODE_04DA54:        A5 0F         LDA $0F                   
CODE_04DA56:        29 07 00      AND.W #$0007              
CODE_04DA59:        AA            TAX                       
CODE_04DA5A:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04DA5C:        B9 02 1F      LDA.W $1F02,Y             
CODE_04DA5F:        3F 4B E4 04   AND.L DATA_04E44B,X       
CODE_04DA63:        F0 47         BEQ Return04DAAC          
CODE_04DA65:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04DA67:        A9 00 C8      LDA.W #$C800              
CODE_04DA6A:        85 04         STA $04                   
CODE_04DA6C:        A5 0F         LDA $0F                   
CODE_04DA6E:        29 FF 00      AND.W #$00FF              
CODE_04DA71:        0A            ASL                       
CODE_04DA72:        AA            TAX                       
CODE_04DA73:        BF 5D D8 04   LDA.L DATA_04D85D,X       
CODE_04DA77:        A8            TAY                       
CODE_04DA78:        A2 15 00      LDX.W #$0015              
CODE_04DA7B:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04DA7D:        A9 7E         LDA.B #$7E                
CODE_04DA7F:        85 06         STA $06                   
CODE_04DA81:        B7 04         LDA [$04],Y               
CODE_04DA83:        DF 1D DA 04   CMP.L DATA_04DA1D,X       
CODE_04DA87:        F0 06         BEQ CODE_04DA8F           
CODE_04DA89:        CA            DEX                       
CODE_04DA8A:        10 F7         BPL CODE_04DA83           
CODE_04DA8C:        4C 9D DA      JMP.W CODE_04DA9D         

CODE_04DA8F:        BF 33 DA 04   LDA.L DATA_04DA33,X       
CODE_04DA93:        97 04         STA [$04],Y               
CODE_04DA95:        E0 15 00      CPX.W #$0015              
CODE_04DA98:        D0 03         BNE CODE_04DA9D           
ADDR_04DA9A:        C8            INY                       
ADDR_04DA9B:        97 04         STA [$04],Y               
CODE_04DA9D:        A5 0F         LDA $0F                   
CODE_04DA9F:        20 77 E6      JSR.W CODE_04E677         
CODE_04DAA2:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_04DAA4:        9C 86 1B      STZ.W $1B86               
CODE_04DAA7:        A5 0F         LDA $0F                   
CODE_04DAA9:        20 F1 E9      JSR.W CODE_04E9F1         
Return04DAAC:       60            RTS                       ; Return 

CODE_04DAAD:        08            PHP                       
CODE_04DAAE:        20 6A DC      JSR.W CODE_04DC6A         
CODE_04DAB1:        28            PLP                       
Return04DAB2:       6B            RTL                       ; Return 


DATA_04DAB3:                      .db $01,$18,$00,$40,$7F,$00,$20

CODE_04DABA:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04DABC:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_04DABE:        B7 00         LDA [$00],Y               
CODE_04DAC0:        85 03         STA $03                   
CODE_04DAC2:        29 80         AND.B #$80                
CODE_04DAC4:        D0 10         BNE CODE_04DAD6           
CODE_04DAC6:        C8            INY                       
CODE_04DAC7:        B7 00         LDA [$00],Y               
CODE_04DAC9:        9F 00 40 7F   STA.L $7F4000,X           
CODE_04DACD:        E8            INX                       
CODE_04DACE:        E8            INX                       
CODE_04DACF:        C6 03         DEC $03                   
CODE_04DAD1:        10 F3         BPL CODE_04DAC6           
CODE_04DAD3:        4C E9 DA      JMP.W CODE_04DAE9         

CODE_04DAD6:        A5 03         LDA $03                   
CODE_04DAD8:        29 7F         AND.B #$7F                
CODE_04DADA:        85 03         STA $03                   
CODE_04DADC:        C8            INY                       
CODE_04DADD:        B7 00         LDA [$00],Y               
CODE_04DADF:        9F 00 40 7F   STA.L $7F4000,X           
CODE_04DAE3:        E8            INX                       
CODE_04DAE4:        E8            INX                       
CODE_04DAE5:        C6 03         DEC $03                   
CODE_04DAE7:        10 F6         BPL CODE_04DADF           
CODE_04DAE9:        C8            INY                       
CODE_04DAEA:        E4 0E         CPX $0E                   
CODE_04DAEC:        90 CC         BCC CODE_04DABA           
Return04DAEE:       60            RTS                       ; Return 

CODE_04DAEF:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04DAF1:        AD E8 1D      LDA.W $1DE8               
CODE_04DAF4:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs04DAF8:            18 DB      .dw CODE_04DB18           
                       B6 DC      .dw CODE_04DCB6           
                       B6 DC      .dw CODE_04DCB6           
                       B6 DC      .dw CODE_04DCB6           
                       B6 DC      .dw CODE_04DCB6           
                       9D DB      .dw CODE_04DB9D           
                       18 DB      .dw CODE_04DB18           
                       CF DB      .dw CODE_04DBCF           

DATA_04DB08:                      .db $00,$F9,$00,$07

DATA_04DB0C:                      .db $00,$00,$00,$70

DATA_04DB10:                      .db $C0,$FA,$40,$05

DATA_04DB14:                      .db $00,$00,$00,$54

CODE_04DB18:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04DB1A:        AE 8C 1B      LDX.W $1B8C               
CODE_04DB1D:        AD 8D 1B      LDA.W $1B8D               
CODE_04DB20:        18            CLC                       
CODE_04DB21:        7D 08 DB      ADC.W DATA_04DB08,X       
CODE_04DB24:        8D 8D 1B      STA.W $1B8D               
CODE_04DB27:        38            SEC                       
CODE_04DB28:        FD 0C DB      SBC.W DATA_04DB0C,X       
CODE_04DB2B:        5D 08 DB      EOR.W DATA_04DB08,X       
CODE_04DB2E:        10 13         BPL CODE_04DB43           
CODE_04DB30:        AD 8F 1B      LDA.W $1B8F               
CODE_04DB33:        18            CLC                       
CODE_04DB34:        7D 10 DB      ADC.W DATA_04DB10,X       
CODE_04DB37:        8D 8F 1B      STA.W $1B8F               
CODE_04DB3A:        38            SEC                       
CODE_04DB3B:        FD 14 DB      SBC.W DATA_04DB14,X       
CODE_04DB3E:        5D 10 DB      EOR.W DATA_04DB10,X       
CODE_04DB41:        30 1C         BMI CODE_04DB5F           
CODE_04DB43:        BD 0C DB      LDA.W DATA_04DB0C,X       
CODE_04DB46:        8D 8D 1B      STA.W $1B8D               
CODE_04DB49:        BD 14 DB      LDA.W DATA_04DB14,X       
CODE_04DB4C:        8D 8F 1B      STA.W $1B8F               
CODE_04DB4F:        EE E8 1D      INC.W $1DE8               
CODE_04DB52:        8A            TXA                       
CODE_04DB53:        49 02 00      EOR.W #$0002              
CODE_04DB56:        AA            TAX                       
CODE_04DB57:        8E 8C 1B      STX.W $1B8C               
CODE_04DB5A:        F0 03         BEQ CODE_04DB5F           
CODE_04DB5C:        20 93 9A      JSR.W CODE_049A93         
CODE_04DB5F:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04DB61:        AD 90 1B      LDA.W $1B90               
CODE_04DB64:        0A            ASL                       
CODE_04DB65:        85 00         STA $00                   
CODE_04DB67:        AD 8E 1B      LDA.W $1B8E               
CODE_04DB6A:        18            CLC                       
CODE_04DB6B:        69 80         ADC.B #$80                
CODE_04DB6D:        EB            XBA                       
CODE_04DB6E:        A9 80         LDA.B #$80                
CODE_04DB70:        38            SEC                       
CODE_04DB71:        ED 8E 1B      SBC.W $1B8E               
CODE_04DB74:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04DB76:        A2 00         LDX.B #$00                
CODE_04DB78:        A0 A8         LDY.B #$A8                
CODE_04DB7A:        E4 00         CPX $00                   
CODE_04DB7C:        90 03         BCC CODE_04DB81           
CODE_04DB7E:        A9 FF 00      LDA.W #$00FF              
CODE_04DB81:        99 EE 04      STA.W $04EE,Y             
CODE_04DB84:        9D 98 05      STA.W $0598,X             
CODE_04DB87:        E8            INX                       
CODE_04DB88:        E8            INX                       
CODE_04DB89:        88            DEY                       
CODE_04DB8A:        88            DEY                       
CODE_04DB8B:        D0 ED         BNE CODE_04DB7A           
CODE_04DB8D:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04DB8F:        A9 33         LDA.B #$33                
CODE_04DB91:        85 41         STA $41                   
CODE_04DB93:        A9 33         LDA.B #$33                
CODE_04DB95:        85 43         STA $43                   
CODE_04DB97:        A9 80         LDA.B #$80                
CODE_04DB99:        8D 9F 0D      STA.W $0D9F               
Return04DB9C:       60            RTS                       ; Return 

CODE_04DB9D:        AD D6 0D      LDA.W $0DD6               
CODE_04DBA0:        4A            LSR                       
CODE_04DBA1:        4A            LSR                       
CODE_04DBA2:        AA            TAX                       
CODE_04DBA3:        BD 11 1F      LDA.W $1F11,X             
CODE_04DBA6:        AA            TAX                       
CODE_04DBA7:        BF 02 DC 04   LDA.L DATA_04DC02,X       
CODE_04DBAB:        8D 31 19      STA.W $1931               
CODE_04DBAE:        22 94 A5 00   JSL.L CODE_00A594         
CODE_04DBB2:        A9 FE         LDA.B #$FE                
CODE_04DBB4:        8D 03 07      STA.W $0703               
CODE_04DBB7:        A9 01         LDA.B #$01                
CODE_04DBB9:        8D 04 07      STA.W $0704               
CODE_04DBBC:        9C 03 08      STZ.W $0803               
CODE_04DBBF:        A9 06         LDA.B #$06                
CODE_04DBC1:        8D 80 06      STA.W $0680               
CODE_04DBC4:        EE E8 1D      INC.W $1DE8               
Return04DBC7:       60            RTS                       ; Return 


DATA_04DBC8:                      .db $02,$03,$04,$06,$07,$09,$05

CODE_04DBCF:        9C E8 1D      STZ.W $1DE8               
CODE_04DBD2:        A9 04         LDA.B #$04                
CODE_04DBD4:        8D D9 13      STA.W $13D9               
CODE_04DBD7:        AD D6 0D      LDA.W $0DD6               
CODE_04DBDA:        4A            LSR                       
CODE_04DBDB:        4A            LSR                       
CODE_04DBDC:        A8            TAY                       
CODE_04DBDD:        AD B2 0D      LDA.W $0DB2               
CODE_04DBE0:        F0 11         BEQ CODE_04DBF3           
CODE_04DBE2:        AD 9E 1B      LDA.W $1B9E               
CODE_04DBE5:        D0 0C         BNE CODE_04DBF3           
CODE_04DBE7:        98            TYA                       
CODE_04DBE8:        49 01         EOR.B #$01                
CODE_04DBEA:        AA            TAX                       
CODE_04DBEB:        B9 11 1F      LDA.W $1F11,Y             
CODE_04DBEE:        DD 11 1F      CMP.W $1F11,X             
CODE_04DBF1:        F0 0E         BEQ Return04DC01          
CODE_04DBF3:        B9 11 1F      LDA.W $1F11,Y             
CODE_04DBF6:        AA            TAX                       
CODE_04DBF7:        BF C8 DB 04   LDA.L DATA_04DBC8,X       
CODE_04DBFB:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_04DBFE:        9C 9E 1B      STZ.W $1B9E               
Return04DC01:       60            RTS                       ; Return 


DATA_04DC02:                      .db $11,$12,$13,$14,$15,$16,$17

CODE_04DC09:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04DC0B:        AD D6 0D      LDA.W $0DD6               
CODE_04DC0E:        4A            LSR                       
CODE_04DC0F:        4A            LSR                       
CODE_04DC10:        AA            TAX                       
CODE_04DC11:        BD 11 1F      LDA.W $1F11,X             
CODE_04DC14:        AA            TAX                       
CODE_04DC15:        BF 02 DC 04   LDA.L DATA_04DC02,X       
CODE_04DC19:        8D 31 19      STA.W $1931               
CODE_04DC1C:        A9 11         LDA.B #$11                
CODE_04DC1E:        8D 2B 19      STA.W $192B               
CODE_04DC21:        A9 07         LDA.B #$07                
CODE_04DC23:        8D 25 19      STA.W $1925               
CODE_04DC26:        A9 03         LDA.B #$03                
CODE_04DC28:        85 5B         STA RAM_IsVerticalLvl     
CODE_04DC2A:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_04DC2C:        A2 00 00      LDX.W #$0000              
CODE_04DC2F:        8A            TXA                       
CODE_04DC30:        20 70 D7      JSR.W CODE_04D770         
CODE_04DC33:        E0 B0 01      CPX.W #$01B0              
CODE_04DC36:        D0 F8         BNE CODE_04DC30           
CODE_04DC38:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04DC3A:        A9 00 D0      LDA.W #$D000              
CODE_04DC3D:        85 00         STA $00                   
CODE_04DC3F:        A2 00 00      LDX.W #$0000              
CODE_04DC42:        A5 00         LDA $00                   
CODE_04DC44:        9D BE 0F      STA.W $0FBE,X             
CODE_04DC47:        A5 00         LDA $00                   
CODE_04DC49:        18            CLC                       
CODE_04DC4A:        69 08 00      ADC.W #$0008              
CODE_04DC4D:        85 00         STA $00                   
CODE_04DC4F:        E8            INX                       
CODE_04DC50:        E8            INX                       
CODE_04DC51:        E0 00 04      CPX.W #$0400              
CODE_04DC54:        D0 EC         BNE CODE_04DC42           
CODE_04DC56:        8B            PHB                       
CODE_04DC57:        A9 FF 07      LDA.W #$07FF              
CODE_04DC5A:        A2 DF F7      LDX.W #$F7DF              
CODE_04DC5D:        A0 00 C8      LDY.W #$C800              
CODE_04DC60:        54 7E 0C      MVN $7E,$0C               
CODE_04DC63:        AB            PLB                       
CODE_04DC64:        20 F2 D7      JSR.W CODE_04D7F2         
CODE_04DC67:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return04DC69:       6B            RTL                       ; Return 

CODE_04DC6A:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04DC6C:        20 40 DD      JSR.W CODE_04DD40         
CODE_04DC6F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04DC71:        A9 33 A5      LDA.W #$A533              
CODE_04DC74:        85 00         STA $00                   
CODE_04DC76:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04DC78:        A9 04         LDA.B #$04                
CODE_04DC7A:        85 02         STA $02                   
CODE_04DC7C:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_04DC7E:        A0 00 40      LDY.W #$4000              
CODE_04DC81:        84 0E         STY $0E                   
CODE_04DC83:        A0 00 00      LDY.W #$0000              
CODE_04DC86:        BB            TYX                       
CODE_04DC87:        20 BA DA      JSR.W CODE_04DABA         
CODE_04DC8A:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04DC8C:        A9 2B C0      LDA.W #$C02B              
CODE_04DC8F:        85 00         STA $00                   
CODE_04DC91:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04DC93:        A2 01 00      LDX.W #$0001              
CODE_04DC96:        A0 00 00      LDY.W #$0000              
CODE_04DC99:        20 BA DA      JSR.W CODE_04DABA         
CODE_04DC9C:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04DC9E:        A9 00         LDA.B #$00                
CODE_04DCA0:        85 0F         STA $0F                   
CODE_04DCA2:        20 53 E4      JSR.W CODE_04E453         
CODE_04DCA5:        E6 0F         INC $0F                   
CODE_04DCA7:        A5 0F         LDA $0F                   
CODE_04DCA9:        C9 6F         CMP.B #$6F                
CODE_04DCAB:        D0 F5         BNE CODE_04DCA2           
Return04DCAD:       60            RTS                       ; Return 


DATA_04DCAE:                      .db $80,$40,$20,$10,$08,$04,$02,$01

CODE_04DCB6:        08            PHP                       
CODE_04DCB7:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_04DCB9:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04DCBB:        A2 00 D0      LDX.W #$D000              
CODE_04DCBE:        86 65         STX $65                   
CODE_04DCC0:        A9 05         LDA.B #$05                
CODE_04DCC2:        85 67         STA $67                   
CODE_04DCC4:        A2 00 00      LDX.W #$0000              
CODE_04DCC7:        86 00         STX $00                   
CODE_04DCC9:        AD E8 1D      LDA.W $1DE8               
CODE_04DCCC:        3A            DEC A                     
CODE_04DCCD:        85 01         STA $01                   
CODE_04DCCF:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04DCD1:        AD D6 0D      LDA.W $0DD6               
CODE_04DCD4:        4A            LSR                       
CODE_04DCD5:        4A            LSR                       
CODE_04DCD6:        29 FF 00      AND.W #$00FF              
CODE_04DCD9:        AA            TAX                       
CODE_04DCDA:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04DCDC:        BD 11 1F      LDA.W $1F11,X             
CODE_04DCDF:        F0 07         BEQ CODE_04DCE8           
CODE_04DCE1:        A5 01         LDA $01                   
CODE_04DCE3:        18            CLC                       
CODE_04DCE4:        69 04         ADC.B #$04                
CODE_04DCE6:        85 01         STA $01                   
CODE_04DCE8:        A6 00         LDX $00                   
CODE_04DCEA:        BF 00 C8 7E   LDA.L $7EC800,X           
CODE_04DCEE:        85 02         STA $02                   
CODE_04DCF0:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04DCF2:        BF 00 C8 7F   LDA.L $7FC800,X           
CODE_04DCF6:        85 03         STA $03                   
CODE_04DCF8:        A5 02         LDA $02                   
CODE_04DCFA:        0A            ASL                       
CODE_04DCFB:        0A            ASL                       
CODE_04DCFC:        0A            ASL                       
CODE_04DCFD:        A8            TAY                       
CODE_04DCFE:        A5 00         LDA $00                   
CODE_04DD00:        29 FF 00      AND.W #$00FF              
CODE_04DD03:        0A            ASL                       
CODE_04DD04:        0A            ASL                       
CODE_04DD05:        48            PHA                       
CODE_04DD06:        29 3F 00      AND.W #$003F              
CODE_04DD09:        85 02         STA $02                   
CODE_04DD0B:        68            PLA                       
CODE_04DD0C:        0A            ASL                       
CODE_04DD0D:        29 80 0F      AND.W #$0F80              
CODE_04DD10:        05 02         ORA $02                   
CODE_04DD12:        AA            TAX                       
CODE_04DD13:        B7 65         LDA [$65],Y               
CODE_04DD15:        9F 00 E4 7E   STA.L $7EE400,X           
CODE_04DD19:        C8            INY                       
CODE_04DD1A:        C8            INY                       
CODE_04DD1B:        B7 65         LDA [$65],Y               
CODE_04DD1D:        9F 40 E4 7E   STA.L $7EE440,X           
CODE_04DD21:        C8            INY                       
CODE_04DD22:        C8            INY                       
CODE_04DD23:        B7 65         LDA [$65],Y               
CODE_04DD25:        9F 02 E4 7E   STA.L $7EE402,X           
CODE_04DD29:        C8            INY                       
CODE_04DD2A:        C8            INY                       
CODE_04DD2B:        B7 65         LDA [$65],Y               
CODE_04DD2D:        9F 42 E4 7E   STA.L $7EE442,X           
CODE_04DD31:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04DD33:        E6 00         INC $00                   
CODE_04DD35:        A5 00         LDA $00                   
CODE_04DD37:        29 FF         AND.B #$FF                
CODE_04DD39:        D0 AD         BNE CODE_04DCE8           
CODE_04DD3B:        EE E8 1D      INC.W $1DE8               
CODE_04DD3E:        28            PLP                       
Return04DD3F:       60            RTS                       ; Return 

CODE_04DD40:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_04DD42:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04DD44:        A0 00 8D      LDY.W #$8D00              
CODE_04DD47:        84 02         STY $02                   
CODE_04DD49:        A9 0C         LDA.B #$0C                
CODE_04DD4B:        85 04         STA $04                   
CODE_04DD4D:        A2 00 00      LDX.W #$0000              
CODE_04DD50:        9B            TXY                       
CODE_04DD51:        20 57 DD      JSR.W CODE_04DD57         
CODE_04DD54:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return04DD56:       60            RTS                       ; Return 

CODE_04DD57:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04DD59:        B7 02         LDA [$02],Y               
CODE_04DD5B:        C8            INY                       
CODE_04DD5C:        85 05         STA $05                   
CODE_04DD5E:        29 80         AND.B #$80                
CODE_04DD60:        D0 0F         BNE CODE_04DD71           
CODE_04DD62:        B7 02         LDA [$02],Y               
CODE_04DD64:        9F 00 00 7F   STA.L $7F0000,X           
CODE_04DD68:        C8            INY                       
CODE_04DD69:        E8            INX                       
CODE_04DD6A:        C6 05         DEC $05                   
CODE_04DD6C:        10 F4         BPL CODE_04DD62           
CODE_04DD6E:        4C 83 DD      JMP.W CODE_04DD83         

CODE_04DD71:        A5 05         LDA $05                   
CODE_04DD73:        29 7F         AND.B #$7F                
CODE_04DD75:        85 05         STA $05                   
CODE_04DD77:        B7 02         LDA [$02],Y               
CODE_04DD79:        9F 00 00 7F   STA.L $7F0000,X           
CODE_04DD7D:        E8            INX                       
CODE_04DD7E:        C6 05         DEC $05                   
CODE_04DD80:        10 F7         BPL CODE_04DD79           
CODE_04DD82:        C8            INY                       
CODE_04DD83:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04DD85:        B7 02         LDA [$02],Y               
CODE_04DD87:        C9 FF FF      CMP.W #$FFFF              
CODE_04DD8A:        D0 CB         BNE CODE_04DD57           
Return04DD8C:       60            RTS                       ; Return 


DATA_04DD8D:                      .db $00,$09

DATA_04DD8F:                      .db $CC,$23,$04,$09,$8C,$23,$08,$09
                                  .db $4E,$23,$0C,$09,$0E,$23,$10,$09
                                  .db $D0,$22,$14,$09,$90,$22,$8C,$01
                                  .db $02,$22,$B0,$01,$02,$22,$D4,$01
                                  .db $02,$22,$44,$0A,$C6,$21,$48,$0A
                                  .db $44,$20,$4C,$0A,$86,$21,$48,$0A
                                  .db $04,$20,$00,$09,$E4,$23,$38,$09
                                  .db $A4,$23,$28,$09,$24,$23,$18,$09
                                  .db $26,$23,$1C,$09,$28,$23,$20,$09
                                  .db $EC,$22,$24,$09,$AC,$22,$0C,$0B
                                  .db $2C,$22,$10,$0B,$EC,$21,$30,$09
                                  .db $6C,$21,$34,$09,$68,$21,$38,$09
                                  .db $E4,$20,$38,$09,$A4,$20,$3C,$09
                                  .db $90,$10,$40,$09,$4C,$10,$44,$09
                                  .db $0C,$10,$38,$09,$8C,$07,$38,$09
                                  .db $0C,$07,$28,$09,$8C,$06,$48,$09
                                  .db $14,$10,$4C,$09,$94,$07,$50,$09
                                  .db $54,$07,$38,$09,$0C,$06,$04,$09
                                  .db $8C,$05,$54,$09,$0E,$05,$E8,$09
                                  .db $48,$06,$E8,$09,$C8,$06,$98,$09
                                  .db $88,$06,$EC,$09,$12,$05,$F0,$09
                                  .db $D2,$04,$F4,$09,$92,$04,$00,$00
                                  .db $D8,$04,$24,$00,$98,$04,$48,$00
                                  .db $D8,$03,$6C,$00,$56,$03,$90,$00
                                  .db $56,$03,$B4,$00,$56,$03,$10,$05
                                  .db $18,$05,$28,$09,$24,$05,$38,$0B
                                  .db $14,$07,$60,$09,$28,$05,$64,$09
                                  .db $6A,$05,$68,$09,$AC,$05,$6C,$09
                                  .db $2C,$06,$70,$09,$30,$06,$74,$09
                                  .db $B2,$05,$78,$09,$32,$05,$68,$01
                                  .db $FC,$07,$50,$0A,$C0,$0F,$D8,$00
                                  .db $7C,$07,$FC,$00,$7C,$07,$20,$01
                                  .db $7C,$07,$44,$01,$7C,$07,$50,$09
                                  .db $D4,$06,$4C,$09,$94,$06,$7C,$09
                                  .db $14,$06,$80,$09,$94,$05,$84,$09
                                  .db $18,$07,$88,$09,$1A,$07,$48,$09
                                  .db $9C,$07,$8C,$09,$1C,$10,$90,$09
                                  .db $60,$10,$94,$09,$64,$10,$38,$09
                                  .db $DC,$10,$98,$09,$84,$28,$A4,$09
                                  .db $18,$31,$84,$09,$1C,$31,$A8,$09
                                  .db $E0,$30,$4C,$09,$60,$30,$A0,$09
                                  .db $CA,$30,$A0,$09,$0E,$31,$B0,$09
                                  .db $10,$31,$B4,$09,$CC,$30,$B8,$09
                                  .db $8C,$30,$BC,$09,$0C,$30,$BC,$09
                                  .db $8C,$27,$BC,$09,$A0,$27,$BC,$09
                                  .db $20,$27,$AC,$09,$A0,$26,$28,$09
                                  .db $20,$26,$00,$0A,$64,$30,$04,$0A
                                  .db $A8,$30,$08,$0A,$28,$31,$18,$09
                                  .db $22,$26,$98,$09,$26,$26,$C0,$09
                                  .db $2A,$26,$C4,$09,$6C,$26,$C8,$09
                                  .db $70,$26,$CC,$09,$B0,$26,$28,$09
                                  .db $30,$27,$D0,$09,$70,$27,$38,$09
                                  .db $B0,$27,$28,$09,$30,$30,$38,$09
                                  .db $B0,$30,$38,$09,$F0,$30,$D4,$09
                                  .db $B0,$31,$D8,$09,$2E,$32,$98,$09
                                  .db $2A,$32,$E0,$09,$CC,$26,$BC,$09
                                  .db $8C,$26,$E4,$09,$0C,$26,$DC,$09
                                  .db $04,$27,$DC,$09,$C0,$26,$DC,$09
                                  .db $40,$27,$98,$09,$B4,$01,$0C,$0B
                                  .db $B8,$01,$30,$0B,$88,$09,$34,$0B
                                  .db $A0,$09,$10,$0A,$8A,$09,$10,$0A
                                  .db $9E,$09,$0C,$0A,$8C,$09,$0C,$0A
                                  .db $9C,$09,$10,$0A,$8E,$09,$10,$0A
                                  .db $9A,$09,$0C,$0A,$90,$09,$0C,$0A
                                  .db $98,$09,$10,$0A,$92,$09,$10,$0A
                                  .db $96,$09,$14,$0A,$A4,$09,$A8,$03
                                  .db $30,$08,$18,$0A,$AC,$09,$1C,$0A
                                  .db $F0,$09,$9C,$09,$70,$0A,$20,$0A
                                  .db $F0,$0A,$20,$0A,$70,$0B,$20,$0A
                                  .db $F0,$0B,$24,$0A,$70,$0C,$38,$09
                                  .db $F0,$0C,$28,$0A,$30,$0D,$2C,$0A
                                  .db $98,$0A,$30,$0A,$9C,$0A,$14,$0B
                                  .db $10,$0B,$18,$0B,$90,$0B,$34,$0A
                                  .db $1C,$0B,$38,$0A,$5E,$0B,$3C,$0A
                                  .db $62,$0B,$40,$0A,$66,$0B,$20,$0A
                                  .db $E8,$0A,$9C,$09,$68,$0A,$7C,$0A
                                  .db $A4,$33,$7C,$0A,$E8,$33,$7C,$0A
                                  .db $68,$34,$18,$09,$A2,$33,$C0,$09
                                  .db $A4,$33,$30,$09,$E8,$33,$54,$0A
                                  .db $28,$34,$38,$09,$A8,$34,$7C,$0A
                                  .db $98,$33,$7C,$0A,$9C,$33,$58,$0A
                                  .db $9E,$33,$98,$09,$9C,$33,$28,$09
                                  .db $98,$33,$7C,$0A,$26,$36,$7C,$0A
                                  .db $20,$36,$5C,$0A,$68,$35,$14,$09
                                  .db $A8,$35,$D8,$09,$26,$36,$1C,$09
                                  .db $24,$36,$28,$09,$20,$36,$7C,$0A
                                  .db $2C,$35,$7C,$0A,$30,$35,$60,$0A
                                  .db $2A,$35,$98,$09,$2C,$35,$98,$09
                                  .db $2E,$35,$98,$09,$30,$35,$7C,$0A
                                  .db $DA,$35,$7C,$0A,$98,$34,$7C,$0A
                                  .db $18,$34,$58,$0A,$1E,$36,$3C,$09
                                  .db $1C,$36,$64,$0A,$D8,$35,$44,$09
                                  .db $98,$35,$28,$09,$18,$35,$38,$09
                                  .db $98,$34,$38,$09,$18,$34,$28,$09
                                  .db $98,$33,$7C,$0A,$A0,$36,$7C,$0A
                                  .db $60,$37,$D0,$09,$60,$36,$38,$09
                                  .db $E0,$36,$38,$09,$60,$37,$7C,$0A
                                  .db $9C,$33,$18,$09,$9A,$33,$98,$09
                                  .db $9C,$33,$7C,$0A,$10,$35,$58,$0A
                                  .db $96,$33,$6C,$0A,$92,$33,$70,$0A
                                  .db $D0,$33,$74,$0A,$10,$34,$38,$09
                                  .db $90,$34,$28,$09,$10,$35,$7C,$0A
                                  .db $1C,$35,$7C,$0A,$22,$35,$98,$09
                                  .db $14,$35,$28,$09,$18,$35,$98,$09
                                  .db $1C,$35,$98,$09,$20,$35,$98,$09
                                  .db $24,$35,$7C,$0A,$10,$36,$D0,$09
                                  .db $50,$35,$38,$09,$90,$35,$28,$09
                                  .db $10,$36,$7C,$0A,$90,$36,$7C,$0A
                                  .db $0E,$37,$7C,$0A,$0A,$37,$7C,$0A
                                  .db $02,$37,$D0,$09,$50,$36,$78,$0A
                                  .db $D0,$36,$1C,$09,$0C,$37,$98,$09
                                  .db $08,$37,$98,$09,$04,$37,$98,$09
                                  .db $00,$37,$90,$0A,$12,$18,$94,$0A
                                  .db $AA,$2B,$98,$0A,$A8,$2B,$9C,$0A
                                  .db $A4,$2B,$94,$0A,$A2,$2B,$98,$0A
                                  .db $A0,$2B,$A0,$0A,$64,$2B,$A4,$0A
                                  .db $9A,$2B,$98,$0A,$98,$2B,$98,$0A
                                  .db $96,$2B,$98,$0A,$94,$2B,$9C,$0A
                                  .db $90,$2B,$A0,$0A,$5C,$2B,$A0,$0A
                                  .db $50,$2B,$A8,$0A,$10,$2B,$9C,$0A
                                  .db $90,$2A,$AC,$0A,$92,$2A,$98,$0A
                                  .db $94,$2A,$98,$0A,$96,$2A,$98,$0A
                                  .db $98,$2A,$A0,$0A,$50,$2A,$A8,$0A
                                  .db $10,$2A,$3C,$0B,$90,$29,$40,$0B
                                  .db $94,$29,$40,$0B,$98,$29,$A0,$0A
                                  .db $5C,$2A,$A8,$0A,$1C,$2A,$A8,$0A
                                  .db $DC,$29,$A0,$0A,$64,$2A,$A8,$0A
                                  .db $24,$2A,$A8,$0A,$E4,$29,$B0,$0A
                                  .db $90,$1D,$A0,$09,$8C,$1D,$B0,$0A
                                  .db $56,$1E,$B4,$0A,$5A,$1E,$B8,$0A
                                  .db $5C,$1D,$A0,$09,$18,$1D,$BC,$0A
                                  .db $90,$1C,$BC,$0A,$0C,$1C,$A0,$09
                                  .db $0C,$1E,$C0,$0A,$8A,$1E,$C0,$0A
                                  .db $86,$1E,$BC,$0A,$04,$1E,$A0,$09
                                  .db $84,$1D,$B8,$0A,$C6,$1C,$B0,$0A
                                  .db $0C,$1D,$A0,$09,$88,$1D,$A0,$09
                                  .db $84,$1D,$B4,$0A,$80,$1D,$A0,$09
                                  .db $3C,$16,$A0,$09,$BC,$16,$A0,$09
                                  .db $B8,$16,$A0,$09,$B4,$16,$A0,$09
                                  .db $30,$16,$A8,$0A,$70,$15,$C4,$0A
                                  .db $30,$15,$D8,$0A,$B8,$13,$4C,$09
                                  .db $B0,$14,$C8,$0A,$32,$14,$CC,$0A
                                  .db $F4,$13,$D0,$0A,$B8,$13,$D4,$0A
                                  .db $B8,$12,$F8,$01,$F4,$11,$1C,$02
                                  .db $F4,$11,$40,$02,$F4,$11,$64,$02
                                  .db $F4,$11,$88,$02,$F4,$11,$AC,$02
                                  .db $F4,$11,$D0,$02,$F4,$11,$F4,$02
                                  .db $F4,$11,$18,$03,$F4,$11,$3C,$03
                                  .db $B4,$11,$60,$03,$B4,$11,$3C,$03
                                  .db $B4,$11,$DC,$0A,$10,$3D,$E0,$0A
                                  .db $CE,$3C,$E4,$0A,$8C,$3C,$E8,$0A
                                  .db $48,$3C,$EC,$0A,$14,$3C,$F0,$0A
                                  .db $D6,$3B,$F4,$0A,$98,$3B,$F8,$0A
                                  .db $5A,$3B,$18,$09,$26,$3C,$98,$09
                                  .db $28,$3C,$98,$09,$2A,$3C,$98,$09
                                  .db $2C,$3C,$6C,$09,$28,$3D,$FC,$0A
                                  .db $68,$3D,$00,$0B,$AA,$3D,$E4,$0A
                                  .db $EC,$3D,$E4,$0A,$2E,$3E,$DC,$0A
                                  .db $B0,$3E,$3C,$0B,$90,$29,$40,$0B
                                  .db $94,$29,$40,$0B,$98,$29,$04,$0B
                                  .db $9C,$3D,$08,$0B,$D8,$3D,$08,$0B
                                  .db $14,$3E,$08,$0B,$50,$3E,$08,$0B
                                  .db $8C,$3E,$6C,$09,$88,$3E,$44,$01
                                  .db $7C,$07,$38,$09,$E0,$19,$1C,$0B
                                  .db $20,$1A,$CC,$03,$DC,$1A,$F0,$03
                                  .db $DC,$1A,$14,$04,$DC,$1A,$38,$04
                                  .db $9C,$1B,$5C,$04,$9C,$1B,$80,$04
                                  .db $5C,$1B,$A4,$04,$1C,$1B,$C8,$04
                                  .db $DC,$1A,$EC,$04,$9C,$1A,$58,$0A
                                  .db $1E,$1B,$20,$0B,$1C,$1B,$24,$0B
                                  .db $1A,$1B,$28,$0B,$18,$1B,$A0,$09
                                  .db $94,$1B,$A0,$09,$14,$1C,$A0,$09
                                  .db $94,$1C,$C0,$0A,$14,$1D,$2C,$0B
                                  .db $56,$1D,$A0,$09,$D4,$1D,$98,$09
                                  .db $90,$39,$98,$09,$94,$39,$28,$09
                                  .db $98,$39,$98,$09,$9C,$39,$98,$09
                                  .db $A0,$39,$28,$09,$A4,$39,$98,$09
                                  .db $A8,$39,$98,$09,$AC,$39,$28,$09
                                  .db $B0,$39,$98,$09,$B4,$39,$98,$09
                                  .db $B4,$38,$28,$09,$B0,$38,$98,$09
                                  .db $AC,$38,$98,$09,$A8,$38,$28,$09
                                  .db $A4,$38,$98,$09,$A0,$38,$98,$09
                                  .db $9C,$38,$28,$09,$98,$38,$98,$09
                                  .db $94,$38,$98,$09,$90,$38,$28,$09
                                  .db $8C,$38,$98,$09,$88,$38,$28,$09
                                  .db $84,$38

DATA_04E359:                      .db $00,$00

DATA_04E35B:                      .db $00,$00,$0D,$00,$0D,$00,$10,$00
                                  .db $15,$00,$18,$00,$1A,$00,$20,$00
                                  .db $23,$00,$26,$00,$29,$00,$2C,$00
                                  .db $35,$00,$39,$00,$3A,$00,$42,$00
                                  .db $46,$00,$4A,$00,$4C,$00,$4D,$00
                                  .db $4E,$00,$52,$00,$59,$00,$5D,$00
                                  .db $60,$00,$67,$00,$6A,$00,$6C,$00
                                  .db $6F,$00,$72,$00,$75,$00,$77,$00
                                  .db $77,$00,$83,$00,$83,$00,$84,$00
                                  .db $8E,$00,$90,$00,$92,$00,$98,$00
                                  .db $98,$00,$98,$00,$A0,$00,$A5,$00
                                  .db $AC,$00,$B2,$00,$BD,$00,$C2,$00
                                  .db $C5,$00,$CC,$00,$D3,$00,$D7,$00
                                  .db $E1,$00,$E2,$00,$E2,$00,$E2,$00
                                  .db $E5,$00,$E7,$00,$E8,$00,$ED,$00
                                  .db $EE,$00,$F1,$00,$F5,$00,$FA,$00
                                  .db $FD,$00,$00,$01,$00,$01,$00,$01
                                  .db $00,$01,$00,$01,$02,$01,$08,$01
                                  .db $0F,$01,$12,$01,$14,$01,$16,$01
                                  .db $17,$01,$1E,$01,$2B,$01,$2B,$01
                                  .db $2B,$01,$2B,$01,$2F,$01,$2F,$01
                                  .db $2F,$01,$33,$01,$33,$01,$33,$01
                                  .db $37,$01,$37,$01,$37,$01,$40,$01
                                  .db $40,$01,$46,$01,$46,$01,$46,$01
                                  .db $47,$01,$52,$01,$56,$01,$5C,$01
                                  .db $5C,$01,$5F,$01,$62,$01,$65,$01
                                  .db $68,$01,$6B,$01,$6E,$01,$71,$01
                                  .db $73,$01,$73,$01,$73,$01,$73,$01
                                  .db $73,$01,$73,$01,$73,$01,$73,$01
                                  .db $73,$01,$73,$01,$73,$01,$73,$01
DATA_04E44B:                      .db $80,$40,$20,$10,$08,$04,$02,$01

CODE_04E453:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04E455:        A5 0F         LDA $0F                   
CODE_04E457:        29 07         AND.B #$07                
CODE_04E459:        AA            TAX                       
CODE_04E45A:        A5 0F         LDA $0F                   
CODE_04E45C:        4A            LSR                       
CODE_04E45D:        4A            LSR                       
CODE_04E45E:        4A            LSR                       
CODE_04E45F:        A8            TAY                       
CODE_04E460:        B9 02 1F      LDA.W $1F02,Y             
CODE_04E463:        3F 4B E4 04   AND.L DATA_04E44B,X       
CODE_04E467:        D0 01         BNE CODE_04E46A           
Return04E469:       60            RTS                       ; Return 

CODE_04E46A:        A5 0F         LDA $0F                   
CODE_04E46C:        0A            ASL                       
CODE_04E46D:        AA            TAX                       
CODE_04E46E:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04E470:        BF 59 E3 04   LDA.L DATA_04E359,X       
CODE_04E474:        8D EB 1D      STA.W $1DEB               
CODE_04E477:        BF 5B E3 04   LDA.L DATA_04E35B,X       
CODE_04E47B:        8D ED 1D      STA.W $1DED               
CODE_04E47E:        CD EB 1D      CMP.W $1DEB               
CODE_04E481:        F0 10         BEQ CODE_04E493           
CODE_04E483:        20 96 E4      JSR.W CODE_04E496         
CODE_04E486:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04E488:        EE EB 1D      INC.W $1DEB               
CODE_04E48B:        AD EB 1D      LDA.W $1DEB               
CODE_04E48E:        CD ED 1D      CMP.W $1DED               
CODE_04E491:        D0 F0         BNE CODE_04E483           
CODE_04E493:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return04E495:       60            RTS                       ; Return 

CODE_04E496:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04E498:        AD EB 1D      LDA.W $1DEB               
CODE_04E49B:        0A            ASL                       
CODE_04E49C:        0A            ASL                       
CODE_04E49D:        AA            TAX                       
CODE_04E49E:        BF 8D DD 04   LDA.L DATA_04DD8D,X       
CODE_04E4A2:        A8            TAY                       
CODE_04E4A3:        BF 8F DD 04   LDA.L DATA_04DD8F,X       
CODE_04E4A7:        85 04         STA $04                   
CODE_04E4A9:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04E4AB:        A9 7F         LDA.B #$7F                
CODE_04E4AD:        85 08         STA $08                   
CODE_04E4AF:        A9 0C         LDA.B #$0C                
CODE_04E4B1:        85 0B         STA $0B                   
CODE_04E4B3:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04E4B5:        A9 00 00      LDA.W #$0000              
CODE_04E4B8:        85 06         STA $06                   
CODE_04E4BA:        A9 00 80      LDA.W #$8000              
CODE_04E4BD:        85 09         STA $09                   
CODE_04E4BF:        C0 00 09      CPY.W #$0900              
CODE_04E4C2:        90 06         BCC CODE_04E4CA           
CODE_04E4C4:        20 D0 E4      JSR.W CODE_04E4D0         
CODE_04E4C7:        4C CD E4      JMP.W CODE_04E4CD         

CODE_04E4CA:        20 20 E5      JSR.W CODE_04E520         
CODE_04E4CD:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return04E4CF:       60            RTS                       ; Return 

CODE_04E4D0:        A9 01 00      LDA.W #$0001              ; Accum (16 bit) 
CODE_04E4D3:        85 00         STA $00                   
CODE_04E4D5:        A6 04         LDX $04                   
CODE_04E4D7:        A9 01 00      LDA.W #$0001              
CODE_04E4DA:        85 0C         STA $0C                   
CODE_04E4DC:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04E4DE:        B7 09         LDA [$09],Y               
CODE_04E4E0:        9F 00 40 7F   STA.L $7F4000,X           
CODE_04E4E4:        E8            INX                       
CODE_04E4E5:        B7 06         LDA [$06],Y               
CODE_04E4E7:        9F 00 40 7F   STA.L $7F4000,X           
CODE_04E4EB:        C8            INY                       
CODE_04E4EC:        E8            INX                       
CODE_04E4ED:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04E4EF:        8A            TXA                       
CODE_04E4F0:        29 3F 00      AND.W #$003F              
CODE_04E4F3:        D0 0A         BNE CODE_04E4FF           
CODE_04E4F5:        CA            DEX                       
CODE_04E4F6:        8A            TXA                       
CODE_04E4F7:        29 C0 FF      AND.W #$FFC0              
CODE_04E4FA:        18            CLC                       
CODE_04E4FB:        69 00 08      ADC.W #$0800              
CODE_04E4FE:        AA            TAX                       
CODE_04E4FF:        C6 0C         DEC $0C                   
CODE_04E501:        10 D9         BPL CODE_04E4DC           
CODE_04E503:        A5 04         LDA $04                   
CODE_04E505:        AA            TAX                       
CODE_04E506:        18            CLC                       
CODE_04E507:        69 40 00      ADC.W #$0040              
CODE_04E50A:        85 04         STA $04                   
CODE_04E50C:        29 C0 07      AND.W #$07C0              
CODE_04E50F:        D0 0A         BNE CODE_04E51B           
CODE_04E511:        8A            TXA                       
CODE_04E512:        29 3F F8      AND.W #$F83F              
CODE_04E515:        18            CLC                       
CODE_04E516:        69 00 10      ADC.W #$1000              
CODE_04E519:        85 04         STA $04                   
CODE_04E51B:        C6 00         DEC $00                   
CODE_04E51D:        10 B6         BPL CODE_04E4D5           
Return04E51F:       60            RTS                       ; Return 

CODE_04E520:        A9 05 00      LDA.W #$0005              
CODE_04E523:        85 00         STA $00                   
CODE_04E525:        A6 04         LDX $04                   
CODE_04E527:        A9 05 00      LDA.W #$0005              
CODE_04E52A:        85 0C         STA $0C                   
CODE_04E52C:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04E52E:        B7 09         LDA [$09],Y               
CODE_04E530:        9F 00 40 7F   STA.L $7F4000,X           
CODE_04E534:        E8            INX                       
CODE_04E535:        B7 06         LDA [$06],Y               
CODE_04E537:        9F 00 40 7F   STA.L $7F4000,X           
CODE_04E53B:        C8            INY                       
CODE_04E53C:        E8            INX                       
CODE_04E53D:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04E53F:        8A            TXA                       
CODE_04E540:        29 3F 00      AND.W #$003F              
CODE_04E543:        D0 0A         BNE CODE_04E54F           
CODE_04E545:        CA            DEX                       
CODE_04E546:        8A            TXA                       
CODE_04E547:        29 C0 FF      AND.W #$FFC0              
CODE_04E54A:        18            CLC                       
CODE_04E54B:        69 00 08      ADC.W #$0800              
CODE_04E54E:        AA            TAX                       
CODE_04E54F:        C6 0C         DEC $0C                   
CODE_04E551:        10 D9         BPL CODE_04E52C           
CODE_04E553:        A5 04         LDA $04                   
CODE_04E555:        AA            TAX                       
CODE_04E556:        18            CLC                       
CODE_04E557:        69 40 00      ADC.W #$0040              
CODE_04E55A:        85 04         STA $04                   
CODE_04E55C:        29 C0 07      AND.W #$07C0              
CODE_04E55F:        D0 0A         BNE CODE_04E56B           
CODE_04E561:        8A            TXA                       
CODE_04E562:        29 3F F8      AND.W #$F83F              
CODE_04E565:        18            CLC                       
CODE_04E566:        69 00 10      ADC.W #$1000              
CODE_04E569:        85 04         STA $04                   
CODE_04E56B:        C6 00         DEC $00                   
CODE_04E56D:        10 B6         BPL CODE_04E525           
Return04E56F:       60            RTS                       ; Return 

CODE_04E570:        AD 86 1B      LDA.W $1B86               
CODE_04E573:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs04E577:            EE E5      .dw CODE_04E5EE           
                       EB EB      .dw CODE_04EBEB           
                       D3 E6      .dw CODE_04E6D3           
                       F9 E6      .dw CODE_04E6F9           
                       A4 EA      .dw CODE_04EAA4           
                       78 EC      .dw CODE_04EC78           
                       EB EB      .dw CODE_04EBEB           
                       EC E9      .dw CODE_04E9EC           

DATA_04E587:                      .db $20,$52,$22,$DA,$28,$58,$24,$C0
                                  .db $24,$94,$23,$42,$28,$94,$2A,$98
                                  .db $25,$0E,$25,$52,$25,$C4,$2A,$DE
                                  .db $2A,$98,$28,$44,$2C,$50,$2C,$0C
DATA_04E5A7:                      .db $77,$79,$58,$4C,$A6

DATA_04E5AC:                      .db $85,$86,$00,$10,$00

DATA_04E5B1:                      .db $85,$86,$81,$81,$81

DATA_04E5B6:                      .db $19,$04,$BD,$00,$1C,$06,$30,$01
                                  .db $2A,$01,$D1,$00,$2A,$06,$AC,$06
                                  .db $47,$05,$59,$05,$72,$05,$BF,$02
                                  .db $AC,$02,$12,$02,$18,$03,$06,$03
DATA_04E5D6:                      .db $06,$0F,$1C,$21,$24,$28,$29,$37
                                  .db $40,$41,$43,$4A,$4D,$02,$61,$35
DATA_04E5E6:                      .db $58,$59,$5D,$63,$77,$79,$7E,$80

CODE_04E5EE:        AD D5 0D      LDA.W $0DD5               ; Accum (8 bit) 
CODE_04E5F1:        C9 02         CMP.B #$02                
CODE_04E5F3:        D0 03         BNE CODE_04E5F8           
CODE_04E5F5:        EE EA 1D      INC.W $1DEA               
CODE_04E5F8:        AD E9 1D      LDA.W $1DE9               
CODE_04E5FB:        F0 1D         BEQ CODE_04E61A           
CODE_04E5FD:        AD EA 1D      LDA.W $1DEA               
CODE_04E600:        C9 FF         CMP.B #$FF                
CODE_04E602:        F0 16         BEQ CODE_04E61A           
CODE_04E604:        AD EA 1D      LDA.W $1DEA               
CODE_04E607:        29 07         AND.B #$07                
CODE_04E609:        AA            TAX                       
CODE_04E60A:        AD EA 1D      LDA.W $1DEA               
CODE_04E60D:        4A            LSR                       
CODE_04E60E:        4A            LSR                       
CODE_04E60F:        4A            LSR                       
CODE_04E610:        A8            TAY                       
CODE_04E611:        B9 02 1F      LDA.W $1F02,Y             
CODE_04E614:        3F 4B E4 04   AND.L DATA_04E44B,X       
CODE_04E618:        F0 26         BEQ CODE_04E640           
CODE_04E61A:        A2 07         LDX.B #$07                
CODE_04E61C:        BD E6 E5      LDA.W DATA_04E5E6,X       
CODE_04E61F:        CD C1 13      CMP.W $13C1               
CODE_04E622:        D0 0E         BNE CODE_04E632           
ADDR_04E624:        EE D9 13      INC.W $13D9               
ADDR_04E627:        A9 E0         LDA.B #$E0                
ADDR_04E629:        8D D5 0D      STA.W $0DD5               
ADDR_04E62C:        A9 0F         LDA.B #$0F                
ADDR_04E62E:        8D B1 0D      STA.W $0DB1               
Return04E631:       60            RTS                       ; Return 

CODE_04E632:        CA            DEX                       
CODE_04E633:        10 E7         BPL CODE_04E61C           
CODE_04E635:        A9 05         LDA.B #$05                
CODE_04E637:        8D D9 13      STA.W $13D9               
CODE_04E63A:        A9 80         LDA.B #$80                
CODE_04E63C:        8D D5 0D      STA.W $0DD5               
Return04E63F:       60            RTS                       ; Return 

CODE_04E640:        EE 86 1B      INC.W $1B86               
CODE_04E643:        AD EA 1D      LDA.W $1DEA               
CODE_04E646:        20 77 E6      JSR.W CODE_04E677         
CODE_04E649:        98            TYA                       
CODE_04E64A:        0A            ASL                       
CODE_04E64B:        0A            ASL                       
CODE_04E64C:        0A            ASL                       
CODE_04E64D:        0A            ASL                       
CODE_04E64E:        8D 82 1B      STA.W $1B82               
CODE_04E651:        98            TYA                       
CODE_04E652:        29 F0         AND.B #$F0                
CODE_04E654:        8D 83 1B      STA.W $1B83               
CODE_04E657:        A9 28         LDA.B #$28                
CODE_04E659:        8D 84 1B      STA.W $1B84               
CODE_04E65C:        AD BF 13      LDA.W $13BF               
CODE_04E65F:        C9 18         CMP.B #$18                
CODE_04E661:        D0 05         BNE CODE_04E668           
CODE_04E663:        A9 FF         LDA.B #$FF                
CODE_04E665:        8D A0 1B      STA.W $1BA0               
CODE_04E668:        AD 86 1B      LDA.W $1B86               
CODE_04E66B:        C9 02         CMP.B #$02                
CODE_04E66D:        F0 05         BEQ CODE_04E674           
CODE_04E66F:        A9 16         LDA.B #$16                
CODE_04E671:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_04E674:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return04E676:       60            RTS                       ; Return 

CODE_04E677:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04E679:        A2 17         LDX.B #$17                
CODE_04E67B:        DF D6 E5 04   CMP.L DATA_04E5D6,X       
CODE_04E67F:        F0 09         BEQ CODE_04E68A           
CODE_04E681:        CA            DEX                       
CODE_04E682:        10 F7         BPL CODE_04E67B           
CODE_04E684:        A9 02         LDA.B #$02                
CODE_04E686:        8D 86 1B      STA.W $1B86               
Return04E689:       60            RTS                       ; Return 

CODE_04E68A:        8E D1 13      STX.W $13D1               
CODE_04E68D:        8A            TXA                       
CODE_04E68E:        0A            ASL                       
CODE_04E68F:        AA            TAX                       
CODE_04E690:        A9 7E         LDA.B #$7E                
CODE_04E692:        85 0C         STA $0C                   
CODE_04E694:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04E696:        A9 00 C8      LDA.W #$C800              
CODE_04E699:        85 0A         STA $0A                   
CODE_04E69B:        BF B6 E5 04   LDA.L DATA_04E5B6,X       
CODE_04E69F:        A8            TAY                       
CODE_04E6A0:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04E6A2:        A2 04 00      LDX.W #$0004              
CODE_04E6A5:        B7 0A         LDA [$0A],Y               
CODE_04E6A7:        DF A7 E5 04   CMP.L DATA_04E5A7,X       
CODE_04E6AB:        F0 06         BEQ CODE_04E6B3           
CODE_04E6AD:        CA            DEX                       
CODE_04E6AE:        10 F7         BPL CODE_04E6A7           
CODE_04E6B0:        4C 84 E6      JMP.W CODE_04E684         

CODE_04E6B3:        8A            TXA                       
CODE_04E6B4:        8D D0 13      STA.W $13D0               
CODE_04E6B7:        E0 03 00      CPX.W #$0003              
CODE_04E6BA:        30 0E         BMI CODE_04E6CA           
CODE_04E6BC:        BF AC E5 04   LDA.L DATA_04E5AC,X       
CODE_04E6C0:        97 0A         STA [$0A],Y               
CODE_04E6C2:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04E6C4:        98            TYA                       
CODE_04E6C5:        18            CLC                       
CODE_04E6C6:        69 10 00      ADC.W #$0010              
CODE_04E6C9:        A8            TAY                       
CODE_04E6CA:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04E6CC:        BF B1 E5 04   LDA.L DATA_04E5B1,X       
CODE_04E6D0:        97 0A         STA [$0A],Y               
Return04E6D2:       60            RTS                       ; Return 

CODE_04E6D3:        EE 86 1B      INC.W $1B86               
CODE_04E6D6:        AD EA 1D      LDA.W $1DEA               
CODE_04E6D9:        0A            ASL                       
CODE_04E6DA:        AA            TAX                       
CODE_04E6DB:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04E6DD:        BF 59 E3 04   LDA.L DATA_04E359,X       
CODE_04E6E1:        8D EB 1D      STA.W $1DEB               
CODE_04E6E4:        BF 5B E3 04   LDA.L DATA_04E35B,X       
CODE_04E6E8:        8D ED 1D      STA.W $1DED               
CODE_04E6EB:        CD EB 1D      CMP.W $1DEB               
CODE_04E6EE:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04E6F0:        D0 06         BNE Return04E6F8          
CODE_04E6F2:        EE 86 1B      INC.W $1B86               
CODE_04E6F5:        EE 86 1B      INC.W $1B86               
Return04E6F8:       60            RTS                       ; Return 

CODE_04E6F9:        20 62 EA      JSR.W CODE_04EA62         
CODE_04E6FC:        A9 7F         LDA.B #$7F                
CODE_04E6FE:        85 0E         STA $0E                   
CODE_04E700:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04E702:        AD EB 1D      LDA.W $1DEB               
CODE_04E705:        0A            ASL                       
CODE_04E706:        0A            ASL                       
CODE_04E707:        AA            TAX                       
CODE_04E708:        BF 8D DD 04   LDA.L DATA_04DD8D,X       
CODE_04E70C:        8D 84 1B      STA.W $1B84               
CODE_04E70F:        BF 8F DD 04   LDA.L DATA_04DD8F,X       
CODE_04E713:        85 00         STA $00                   
CODE_04E715:        29 FF 1F      AND.W #$1FFF              
CODE_04E718:        4A            LSR                       
CODE_04E719:        18            CLC                       
CODE_04E71A:        69 00 30      ADC.W #$3000              
CODE_04E71D:        EB            XBA                       
CODE_04E71E:        85 02         STA $02                   
CODE_04E720:        A5 00         LDA $00                   
CODE_04E722:        4A            LSR                       
CODE_04E723:        4A            LSR                       
CODE_04E724:        4A            LSR                       
CODE_04E725:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04E727:        29 F8         AND.B #$F8                
CODE_04E729:        8D 83 1B      STA.W $1B83               
CODE_04E72C:        A5 00         LDA $00                   
CODE_04E72E:        29 3E         AND.B #$3E                
CODE_04E730:        0A            ASL                       
CODE_04E731:        0A            ASL                       
CODE_04E732:        8D 82 1B      STA.W $1B82               
CODE_04E735:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04E737:        A9 00 40      LDA.W #$4000              
CODE_04E73A:        85 0C         STA $0C                   
CODE_04E73C:        A9 FF EF      LDA.W #$EFFF              
CODE_04E73F:        85 0A         STA $0A                   
CODE_04E741:        AD 84 1B      LDA.W $1B84               
CODE_04E744:        C9 00 09      CMP.W #$0900              
CODE_04E747:        90 06         BCC CODE_04E74F           
CODE_04E749:        20 6C E7      JSR.W CODE_04E76C         
CODE_04E74C:        4C 52 E7      JMP.W CODE_04E752         

CODE_04E74F:        20 24 E8      JSR.W CODE_04E824         
CODE_04E752:        A9 FF 00      LDA.W #$00FF              
CODE_04E755:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04E759:        8A            TXA                       
CODE_04E75A:        8F 7B 83 7F   STA.L $7F837B             
CODE_04E75E:        20 96 E4      JSR.W CODE_04E496         
CODE_04E761:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04E763:        A9 15         LDA.B #$15                
CODE_04E765:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_04E768:        EE 86 1B      INC.W $1B86               
Return04E76B:       60            RTS                       ; Return 

CODE_04E76C:        A9 01 00      LDA.W #$0001              ; Index (16 bit) Accum (16 bit) 
CODE_04E76F:        85 06         STA $06                   
CODE_04E771:        AF 7B 83 7F   LDA.L $7F837B             
CODE_04E775:        AA            TAX                       
CODE_04E776:        A5 02         LDA $02                   
CODE_04E778:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04E77C:        E8            INX                       
CODE_04E77D:        E8            INX                       
CODE_04E77E:        A0 00 03      LDY.W #$0300              
CODE_04E781:        A5 03         LDA $03                   
CODE_04E783:        29 1F 00      AND.W #$001F              
CODE_04E786:        85 08         STA $08                   
CODE_04E788:        A9 20 00      LDA.W #$0020              
CODE_04E78B:        38            SEC                       
CODE_04E78C:        E5 08         SBC $08                   
CODE_04E78E:        85 08         STA $08                   
CODE_04E790:        C9 01 00      CMP.W #$0001              
CODE_04E793:        D0 06         BNE CODE_04E79B           
ADDR_04E795:        A5 08         LDA $08                   
ADDR_04E797:        0A            ASL                       
ADDR_04E798:        3A            DEC A                     
ADDR_04E799:        EB            XBA                       
ADDR_04E79A:        A8            TAY                       
CODE_04E79B:        98            TYA                       
CODE_04E79C:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04E7A0:        E8            INX                       
CODE_04E7A1:        E8            INX                       
CODE_04E7A2:        A9 01 00      LDA.W #$0001              
CODE_04E7A5:        85 04         STA $04                   
CODE_04E7A7:        A4 00         LDY $00                   
CODE_04E7A9:        B7 0C         LDA [$0C],Y               
CODE_04E7AB:        25 0A         AND $0A                   
CODE_04E7AD:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04E7B1:        E8            INX                       
CODE_04E7B2:        E8            INX                       
CODE_04E7B3:        C8            INY                       
CODE_04E7B4:        C8            INY                       
CODE_04E7B5:        98            TYA                       
CODE_04E7B6:        29 3F 00      AND.W #$003F              
CODE_04E7B9:        D0 2A         BNE CODE_04E7E5           
CODE_04E7BB:        A5 04         LDA $04                   
CODE_04E7BD:        F0 26         BEQ CODE_04E7E5           
ADDR_04E7BF:        88            DEY                       
ADDR_04E7C0:        98            TYA                       
ADDR_04E7C1:        29 C0 FF      AND.W #$FFC0              
ADDR_04E7C4:        18            CLC                       
ADDR_04E7C5:        69 00 08      ADC.W #$0800              
ADDR_04E7C8:        A8            TAY                       
ADDR_04E7C9:        A5 02         LDA $02                   
ADDR_04E7CB:        EB            XBA                       
ADDR_04E7CC:        29 E0 3B      AND.W #$3BE0              
ADDR_04E7CF:        18            CLC                       
ADDR_04E7D0:        69 00 04      ADC.W #$0400              
ADDR_04E7D3:        EB            XBA                       
ADDR_04E7D4:        9F 7D 83 7F   STA.L $7F837D,X           
ADDR_04E7D8:        E8            INX                       
ADDR_04E7D9:        E8            INX                       
ADDR_04E7DA:        A5 08         LDA $08                   
ADDR_04E7DC:        0A            ASL                       
ADDR_04E7DD:        3A            DEC A                     
ADDR_04E7DE:        EB            XBA                       
ADDR_04E7DF:        9F 7D 83 7F   STA.L $7F837D,X           
ADDR_04E7E3:        E8            INX                       
ADDR_04E7E4:        E8            INX                       
CODE_04E7E5:        C6 04         DEC $04                   
CODE_04E7E7:        10 C0         BPL CODE_04E7A9           
CODE_04E7E9:        A5 02         LDA $02                   
CODE_04E7EB:        EB            XBA                       
CODE_04E7EC:        18            CLC                       
CODE_04E7ED:        69 20 00      ADC.W #$0020              
CODE_04E7F0:        EB            XBA                       
CODE_04E7F1:        85 02         STA $02                   
CODE_04E7F3:        A5 00         LDA $00                   
CODE_04E7F5:        A8            TAY                       
CODE_04E7F6:        18            CLC                       
CODE_04E7F7:        69 40 00      ADC.W #$0040              
CODE_04E7FA:        85 00         STA $00                   
CODE_04E7FC:        29 C0 07      AND.W #$07C0              
CODE_04E7FF:        D0 1B         BNE CODE_04E81C           
CODE_04E801:        98            TYA                       
CODE_04E802:        29 3F F8      AND.W #$F83F              
CODE_04E805:        18            CLC                       
CODE_04E806:        69 00 10      ADC.W #$1000              
CODE_04E809:        85 00         STA $00                   
CODE_04E80B:        A5 02         LDA $02                   
CODE_04E80D:        EB            XBA                       
CODE_04E80E:        38            SEC                       
CODE_04E80F:        E9 20 00      SBC.W #$0020              
CODE_04E812:        29 1F 34      AND.W #$341F              
CODE_04E815:        18            CLC                       
CODE_04E816:        69 00 08      ADC.W #$0800              
CODE_04E819:        EB            XBA                       
CODE_04E81A:        85 02         STA $02                   
CODE_04E81C:        C6 06         DEC $06                   
CODE_04E81E:        30 03         BMI Return04E823          
CODE_04E820:        4C 76 E7      JMP.W CODE_04E776         

Return04E823:       60            RTS                       ; Return 

CODE_04E824:        A9 05 00      LDA.W #$0005              
CODE_04E827:        85 06         STA $06                   
CODE_04E829:        AF 7B 83 7F   LDA.L $7F837B             
CODE_04E82D:        AA            TAX                       
CODE_04E82E:        A5 02         LDA $02                   
CODE_04E830:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04E834:        E8            INX                       
CODE_04E835:        E8            INX                       
CODE_04E836:        A0 00 0B      LDY.W #$0B00              
CODE_04E839:        A5 03         LDA $03                   
CODE_04E83B:        29 1F 00      AND.W #$001F              
CODE_04E83E:        85 08         STA $08                   
CODE_04E840:        A9 20 00      LDA.W #$0020              
CODE_04E843:        38            SEC                       
CODE_04E844:        E5 08         SBC $08                   
CODE_04E846:        85 08         STA $08                   
CODE_04E848:        C9 06 00      CMP.W #$0006              
CODE_04E84B:        B0 0E         BCS CODE_04E85B           
CODE_04E84D:        A5 08         LDA $08                   
CODE_04E84F:        0A            ASL                       
CODE_04E850:        3A            DEC A                     
CODE_04E851:        EB            XBA                       
CODE_04E852:        A8            TAY                       
CODE_04E853:        A9 06 00      LDA.W #$0006              
CODE_04E856:        38            SEC                       
CODE_04E857:        E5 08         SBC $08                   
CODE_04E859:        85 08         STA $08                   
CODE_04E85B:        98            TYA                       
CODE_04E85C:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04E860:        E8            INX                       
CODE_04E861:        E8            INX                       
CODE_04E862:        A9 05 00      LDA.W #$0005              
CODE_04E865:        85 04         STA $04                   
CODE_04E867:        A4 00         LDY $00                   
CODE_04E869:        B7 0C         LDA [$0C],Y               
CODE_04E86B:        25 0A         AND $0A                   
CODE_04E86D:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04E871:        E8            INX                       
CODE_04E872:        E8            INX                       
CODE_04E873:        C8            INY                       
CODE_04E874:        C8            INY                       
CODE_04E875:        98            TYA                       
CODE_04E876:        29 3F 00      AND.W #$003F              
CODE_04E879:        D0 2A         BNE CODE_04E8A5           
CODE_04E87B:        A5 04         LDA $04                   
CODE_04E87D:        F0 26         BEQ CODE_04E8A5           
CODE_04E87F:        88            DEY                       
CODE_04E880:        98            TYA                       
CODE_04E881:        29 C0 FF      AND.W #$FFC0              
CODE_04E884:        18            CLC                       
CODE_04E885:        69 00 08      ADC.W #$0800              
CODE_04E888:        A8            TAY                       
CODE_04E889:        A5 02         LDA $02                   
CODE_04E88B:        EB            XBA                       
CODE_04E88C:        29 E0 3B      AND.W #$3BE0              
CODE_04E88F:        18            CLC                       
CODE_04E890:        69 00 04      ADC.W #$0400              
CODE_04E893:        EB            XBA                       
CODE_04E894:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04E898:        E8            INX                       
CODE_04E899:        E8            INX                       
CODE_04E89A:        A5 08         LDA $08                   
CODE_04E89C:        0A            ASL                       
CODE_04E89D:        3A            DEC A                     
CODE_04E89E:        EB            XBA                       
CODE_04E89F:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04E8A3:        E8            INX                       
CODE_04E8A4:        E8            INX                       
CODE_04E8A5:        C6 04         DEC $04                   
CODE_04E8A7:        10 C0         BPL CODE_04E869           
CODE_04E8A9:        A5 02         LDA $02                   
CODE_04E8AB:        EB            XBA                       
CODE_04E8AC:        18            CLC                       
CODE_04E8AD:        69 20 00      ADC.W #$0020              
CODE_04E8B0:        EB            XBA                       
CODE_04E8B1:        85 02         STA $02                   
CODE_04E8B3:        A5 00         LDA $00                   
CODE_04E8B5:        A8            TAY                       
CODE_04E8B6:        18            CLC                       
CODE_04E8B7:        69 40 00      ADC.W #$0040              
CODE_04E8BA:        85 00         STA $00                   
CODE_04E8BC:        29 C0 07      AND.W #$07C0              
CODE_04E8BF:        D0 1B         BNE CODE_04E8DC           
CODE_04E8C1:        98            TYA                       
CODE_04E8C2:        29 3F F8      AND.W #$F83F              
CODE_04E8C5:        18            CLC                       
CODE_04E8C6:        69 00 10      ADC.W #$1000              
CODE_04E8C9:        85 00         STA $00                   
CODE_04E8CB:        A5 02         LDA $02                   
CODE_04E8CD:        EB            XBA                       
CODE_04E8CE:        38            SEC                       
CODE_04E8CF:        E9 20 00      SBC.W #$0020              
CODE_04E8D2:        29 1F 34      AND.W #$341F              
CODE_04E8D5:        18            CLC                       
CODE_04E8D6:        69 00 08      ADC.W #$0800              
CODE_04E8D9:        EB            XBA                       
CODE_04E8DA:        85 02         STA $02                   
CODE_04E8DC:        C6 06         DEC $06                   
CODE_04E8DE:        30 03         BMI Return04E8E3          
CODE_04E8E0:        4C 2E E8      JMP.W CODE_04E82E         

Return04E8E3:       60            RTS                       ; Return 


DATA_04E8E4:                      .db $06,$06,$06,$06,$06,$06,$06,$06
                                  .db $14,$14,$14,$14,$14,$1D,$1D,$1D
                                  .db $1D,$12,$12,$12,$1C,$2F,$2F,$2F
                                  .db $2F,$2F,$34,$34,$34,$47,$4E,$4E
                                  .db $01,$0F,$24,$24,$6C,$0F,$0F,$54
                                  .db $55,$57,$58,$5D

DATA_04E910:                      .db $00,$00,$00,$00,$00,$00,$01,$01
                                  .db $00,$01,$01,$01,$01,$01,$01,$01
                                  .db $00,$01,$01,$00,$00,$01,$01,$01
                                  .db $01,$01,$01,$01,$01,$00,$01,$00
                                  .db $00,$01,$01,$01,$01,$01,$00,$00
                                  .db $00,$00,$00,$00

DATA_04E93C:                      .db $15,$02,$35,$02,$45,$02,$55,$02
                                  .db $65,$02,$75,$02,$14,$11,$94,$10
                                  .db $A9,$00,$A4,$05,$24,$05,$28,$07
                                  .db $A4,$06,$A8,$01,$AC,$01,$B0,$01
                                  .db $3C,$00,$00,$29,$80,$28,$10,$05
                                  .db $54,$01,$30,$18,$B0,$18,$2E,$19
                                  .db $2A,$19,$26,$19,$24,$18,$20,$18
                                  .db $1C,$18,$97,$05,$EC,$2A,$7B,$05
                                  .db $12,$02,$94,$31,$A0,$32,$20,$33
                                  .db $16,$1D,$14,$31,$25,$06,$F0,$01
                                  .db $F0,$01,$04,$03,$04,$03,$27,$02
DATA_04E994:                      .db $68,$00,$24,$00,$24,$00,$25,$00
                                  .db $00,$00,$81,$00,$38,$09,$28,$09
                                  .db $66,$00,$9C,$09,$28,$09,$F8,$09
                                  .db $FC,$09,$98,$09,$98,$09,$28,$09
                                  .db $66,$00,$38,$09,$28,$09,$66,$00
                                  .db $68,$00,$80,$0A,$84,$0A,$88,$0A
                                  .db $98,$09,$98,$09,$94,$09,$98,$09
                                  .db $8C,$0A,$66,$00,$84,$03,$66,$00
                                  .db $79,$00,$A8,$0A,$38,$09,$38,$09
                                  .db $A0,$09,$30,$0A,$69,$00,$5F,$00
                                  .db $5F,$00,$5F,$00,$5F,$00,$5F,$00

CODE_04E9EC:        AD EA 1D      LDA.W $1DEA               ; Index (8 bit) Accum (8 bit) 
CODE_04E9EF:        85 0F         STA $0F                   
CODE_04E9F1:        A2 2B         LDX.B #$2B                
CODE_04E9F3:        DF E4 E8 04   CMP.L DATA_04E8E4,X       
CODE_04E9F7:        F0 2C         BEQ CODE_04EA25           
CODE_04E9F9:        CA            DEX                       
CODE_04E9FA:        10 F7         BPL CODE_04E9F3           
CODE_04E9FC:        AD 86 1B      LDA.W $1B86               
CODE_04E9FF:        F0 23         BEQ Return04EA24          
CODE_04EA01:        9C 86 1B      STZ.W $1B86               
CODE_04EA04:        EE D9 13      INC.W $13D9               
CODE_04EA07:        AD EA 1D      LDA.W $1DEA               
CODE_04EA0A:        29 07         AND.B #$07                
CODE_04EA0C:        AA            TAX                       
CODE_04EA0D:        AD EA 1D      LDA.W $1DEA               
CODE_04EA10:        4A            LSR                       
CODE_04EA11:        4A            LSR                       
CODE_04EA12:        4A            LSR                       
CODE_04EA13:        A8            TAY                       
CODE_04EA14:        B9 02 1F      LDA.W $1F02,Y             
CODE_04EA17:        1F 4B E4 04   ORA.L DATA_04E44B,X       
CODE_04EA1B:        99 02 1F      STA.W $1F02,Y             
CODE_04EA1E:        EE 2E 1F      INC.W $1F2E               
CODE_04EA21:        9C E9 1D      STZ.W $1DE9               
Return04EA24:       60            RTS                       ; Return 

CODE_04EA25:        DA            PHX                       
CODE_04EA26:        BF 10 E9 04   LDA.L DATA_04E910,X       
CODE_04EA2A:        85 02         STA $02                   
CODE_04EA2C:        8A            TXA                       
CODE_04EA2D:        0A            ASL                       
CODE_04EA2E:        AA            TAX                       
CODE_04EA2F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04EA31:        BF 94 E9 04   LDA.L DATA_04E994,X       
CODE_04EA35:        85 00         STA $00                   
CODE_04EA37:        BF 3C E9 04   LDA.L DATA_04E93C,X       
CODE_04EA3B:        85 04         STA $04                   
CODE_04EA3D:        A5 02         LDA $02                   
CODE_04EA3F:        29 01 00      AND.W #$0001              
CODE_04EA42:        F0 0A         BEQ CODE_04EA4E           
CODE_04EA44:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_04EA46:        A4 00         LDY $00                   
CODE_04EA48:        20 A9 E4      JSR.W CODE_04E4A9         
CODE_04EA4B:        4C 5A EA      JMP.W CODE_04EA5A         

CODE_04EA4E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04EA50:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_04EA52:        A6 04         LDX $04                   
CODE_04EA54:        A5 00         LDA $00                   
CODE_04EA56:        9F 00 C8 7E   STA.L $7EC800,X           
CODE_04EA5A:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04EA5C:        FA            PLX                       
CODE_04EA5D:        A5 0F         LDA $0F                   
CODE_04EA5F:        4C F9 E9      JMP.W CODE_04E9F9         

CODE_04EA62:        9C 95 14      STZ.W $1495               
CODE_04EA65:        9C 94 14      STZ.W $1494               
CODE_04EA68:        A2 6F         LDX.B #$6F                
CODE_04EA6A:        BD 03 07      LDA.W $0703,X             
CODE_04EA6D:        9D 07 09      STA.W $0907,X             
CODE_04EA70:        9E 79 09      STZ.W $0979,X             
CODE_04EA73:        CA            DEX                       
CODE_04EA74:        10 F4         BPL CODE_04EA6A           
CODE_04EA76:        A2 6F         LDX.B #$6F                
CODE_04EA78:        A0 10         LDY.B #$10                
CODE_04EA7A:        BD 83 07      LDA.W $0783,X             
CODE_04EA7D:        9D 07 09      STA.W $0907,X             
CODE_04EA80:        CA            DEX                       
CODE_04EA81:        88            DEY                       
CODE_04EA82:        D0 F6         BNE CODE_04EA7A           
CODE_04EA84:        8A            TXA                       
CODE_04EA85:        38            SEC                       
CODE_04EA86:        E9 10         SBC.B #$10                
CODE_04EA88:        AA            TAX                       
CODE_04EA89:        10 ED         BPL CODE_04EA78           
CODE_04EA8B:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04EA8D:        A9 70 00      LDA.W #$0070              
CODE_04EA90:        8D 05 09      STA.W $0905               
CODE_04EA93:        A9 70 C0      LDA.W #$C070              
CODE_04EA96:        8D 77 09      STA.W $0977               
CODE_04EA99:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04EA9B:        9C E9 09      STZ.W $09E9               
CODE_04EA9E:        A9 03         LDA.B #$03                
CODE_04EAA0:        8D 80 06      STA.W $0680               
Return04EAA3:       60            RTS                       ; Return 

CODE_04EAA4:        AD 95 14      LDA.W $1495               
CODE_04EAA7:        C9 40         CMP.B #$40                
CODE_04EAA9:        90 1E         BCC CODE_04EAC9           
CODE_04EAAB:        EE 86 1B      INC.W $1B86               
CODE_04EAAE:        20 30 EE      JSR.W CODE_04EE30         
CODE_04EAB1:        20 96 E4      JSR.W CODE_04E496         
CODE_04EAB4:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04EAB6:        EE EB 1D      INC.W $1DEB               
CODE_04EAB9:        AD EB 1D      LDA.W $1DEB               
CODE_04EABC:        CD ED 1D      CMP.W $1DED               
CODE_04EABF:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04EAC1:        B0 05         BCS Return04EAC8          
CODE_04EAC3:        A9 03         LDA.B #$03                
CODE_04EAC5:        8D 86 1B      STA.W $1B86               
Return04EAC8:       60            RTS                       ; Return 

CODE_04EAC9:        20 67 EC      JSR.W CODE_04EC67         
CODE_04EACC:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04EACE:        A0 8C 00      LDY.W #$008C              
CODE_04EAD1:        A2 06 00      LDX.W #$0006              
CODE_04EAD4:        AD 84 1B      LDA.W $1B84               
CODE_04EAD7:        C9 00 09      CMP.W #$0900              
CODE_04EADA:        90 06         BCC CODE_04EAE2           
CODE_04EADC:        A0 0C 00      LDY.W #$000C              
CODE_04EADF:        A2 02 00      LDX.W #$0002              
CODE_04EAE2:        86 05         STX $05                   
CODE_04EAE4:        AA            TAX                       
CODE_04EAE5:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04EAE7:        A5 05         LDA $05                   
CODE_04EAE9:        85 03         STA $03                   
CODE_04EAEB:        A5 00         LDA $00                   
CODE_04EAED:        85 02         STA $02                   
CODE_04EAEF:        A5 01         LDA $01                   
CODE_04EAF1:        99 51 03      STA.W $0351,Y             
CODE_04EAF4:        BF 00 80 0C   LDA.L DATA_0C8000,X       
CODE_04EAF8:        99 52 03      STA.W $0352,Y             
CODE_04EAFB:        BF 00 00 7F   LDA.L $7F0000,X           
CODE_04EAFF:        29 C0         AND.B #$C0                
CODE_04EB01:        85 04         STA $04                   
CODE_04EB03:        BF 00 00 7F   LDA.L $7F0000,X           
CODE_04EB07:        29 1C         AND.B #$1C                
CODE_04EB09:        4A            LSR                       
CODE_04EB0A:        05 04         ORA $04                   
CODE_04EB0C:        09 11         ORA.B #$11                
CODE_04EB0E:        99 53 03      STA.W $0353,Y             
CODE_04EB11:        A5 02         LDA $02                   
CODE_04EB13:        99 50 03      STA.W $0350,Y             
CODE_04EB16:        18            CLC                       
CODE_04EB17:        69 08         ADC.B #$08                
CODE_04EB19:        E8            INX                       
CODE_04EB1A:        88            DEY                       
CODE_04EB1B:        88            DEY                       
CODE_04EB1C:        88            DEY                       
CODE_04EB1D:        88            DEY                       
CODE_04EB1E:        C6 03         DEC $03                   
CODE_04EB20:        D0 CB         BNE CODE_04EAED           
CODE_04EB22:        A5 01         LDA $01                   
CODE_04EB24:        18            CLC                       
CODE_04EB25:        69 08         ADC.B #$08                
CODE_04EB27:        85 01         STA $01                   
CODE_04EB29:        C0 FC FF      CPY.W #$FFFC              
CODE_04EB2C:        D0 B9         BNE CODE_04EAE7           
CODE_04EB2E:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_04EB30:        A2 23         LDX.B #$23                
CODE_04EB32:        9E 74 04      STZ.W $0474,X             
CODE_04EB35:        CA            DEX                       
CODE_04EB36:        10 FA         BPL CODE_04EB32           
CODE_04EB38:        A0 08         LDY.B #$08                
CODE_04EB3A:        AE B3 0D      LDX.W $0DB3               
CODE_04EB3D:        BD 11 1F      LDA.W $1F11,X             
CODE_04EB40:        C9 03         CMP.B #$03                
CODE_04EB42:        D0 02         BNE CODE_04EB46           
CODE_04EB44:        A0 01         LDY.B #$01                
CODE_04EB46:        84 8A         STY $8A                   
CODE_04EB48:        AD 95 14      LDA.W $1495               
CODE_04EB4B:        22 06 B0 00   JSL.L CODE_00B006         
CODE_04EB4F:        C6 8A         DEC $8A                   
CODE_04EB51:        D0 F5         BNE CODE_04EB48           
CODE_04EB53:        4C 8B EA      JMP.W CODE_04EA8B         


DATA_04EB56:                      .db $F5,$11,$F2,$15,$F5,$11,$F3,$14
                                  .db $F5,$11,$F3,$14,$F6,$10,$F4,$13
                                  .db $F7,$0F,$F5,$12,$F8,$0E,$F7,$11
                                  .db $FA,$0D,$F9,$10,$FC,$0C,$FB,$0D
                                  .db $FF,$0A,$FE,$0B,$01,$07,$01,$07
                                  .db $00,$08,$00,$08

DATA_04EB82:                      .db $F8,$F8,$11,$12,$F8,$F8,$10,$11
                                  .db $F8,$F8,$10,$11,$F9,$F9,$0F,$10
                                  .db $FA,$FA,$0E,$0F,$FB,$FB,$0C,$0D
                                  .db $FC,$FC,$0B,$0B,$FE,$FE,$0A,$0A
                                  .db $00,$00,$08,$08,$01,$01,$07,$07
                                  .db $00,$00,$08,$08

DATA_04EBAE:                      .db $F6,$B6,$76,$36,$F6,$B6,$76,$36
                                  .db $36,$76,$B6,$F6,$36,$76,$B6,$F6
                                  .db $36,$36,$36,$36,$36,$36,$36,$36
                                  .db $36,$36,$36,$36,$36,$36,$36,$36
                                  .db $36,$36,$36,$36,$36,$36,$36,$36
                                  .db $30,$70,$B0,$F0

DATA_04EBDA:                      .db $22,$23,$32,$33,$32,$23,$22

DATA_04EBE1:                      .db $73,$73,$72,$72,$5F,$5F,$28,$28
                                  .db $28,$28

CODE_04EBEB:        CE 84 1B      DEC.W $1B84               
CODE_04EBEE:        10 04         BPL CODE_04EBF4           
CODE_04EBF0:        EE 86 1B      INC.W $1B86               
Return04EBF3:       60            RTS                       ; Return 

CODE_04EBF4:        AD 84 1B      LDA.W $1B84               
CODE_04EBF7:        AC 86 1B      LDY.W $1B86               
CODE_04EBFA:        C0 01         CPY.B #$01                
CODE_04EBFC:        F0 19         BEQ CODE_04EC17           
CODE_04EBFE:        C9 10         CMP.B #$10                
CODE_04EC00:        D0 05         BNE CODE_04EC07           
CODE_04EC02:        48            PHA                       
CODE_04EC03:        20 83 ED      JSR.W CODE_04ED83         
CODE_04EC06:        68            PLA                       
CODE_04EC07:        4A            LSR                       
CODE_04EC08:        4A            LSR                       
CODE_04EC09:        AA            TAX                       
CODE_04EC0A:        BD DA EB      LDA.W DATA_04EBDA,X       
CODE_04EC0D:        85 02         STA $02                   
CODE_04EC0F:        20 67 EC      JSR.W CODE_04EC67         
CODE_04EC12:        A2 28         LDX.B #$28                
CODE_04EC14:        4C 2E EC      JMP.W CODE_04EC2E         

CODE_04EC17:        C9 18         CMP.B #$18                
CODE_04EC19:        D0 05         BNE CODE_04EC20           
CODE_04EC1B:        48            PHA                       
CODE_04EC1C:        20 AA EE      JSR.W CODE_04EEAA         
CODE_04EC1F:        68            PLA                       
CODE_04EC20:        29 FC         AND.B #$FC                
CODE_04EC22:        AA            TAX                       
CODE_04EC23:        4A            LSR                       
CODE_04EC24:        4A            LSR                       
CODE_04EC25:        A8            TAY                       
CODE_04EC26:        B9 E1 EB      LDA.W DATA_04EBE1,Y       
CODE_04EC29:        85 02         STA $02                   
CODE_04EC2B:        20 67 EC      JSR.W CODE_04EC67         
CODE_04EC2E:        A9 03         LDA.B #$03                
CODE_04EC30:        85 03         STA $03                   
CODE_04EC32:        A0 00         LDY.B #$00                
CODE_04EC34:        A5 00         LDA $00                   
CODE_04EC36:        18            CLC                       
CODE_04EC37:        7D 56 EB      ADC.W DATA_04EB56,X       
CODE_04EC3A:        99 80 02      STA.W $0280,Y             
CODE_04EC3D:        A5 01         LDA $01                   
CODE_04EC3F:        18            CLC                       
CODE_04EC40:        7D 82 EB      ADC.W DATA_04EB82,X       
CODE_04EC43:        99 81 02      STA.W $0281,Y             
CODE_04EC46:        A5 02         LDA $02                   
CODE_04EC48:        99 82 02      STA.W $0282,Y             
CODE_04EC4B:        BD AE EB      LDA.W DATA_04EBAE,X       
CODE_04EC4E:        99 83 02      STA.W $0283,Y             
CODE_04EC51:        C8            INY                       
CODE_04EC52:        C8            INY                       
CODE_04EC53:        C8            INY                       
CODE_04EC54:        C8            INY                       
CODE_04EC55:        E8            INX                       
CODE_04EC56:        C6 03         DEC $03                   
CODE_04EC58:        10 DA         BPL CODE_04EC34           
CODE_04EC5A:        9C 40 04      STZ.W $0440               
CODE_04EC5D:        9C 41 04      STZ.W $0441               
CODE_04EC60:        9C 42 04      STZ.W $0442               
CODE_04EC63:        9C 43 04      STZ.W $0443               
Return04EC66:       60            RTS                       ; Return 

CODE_04EC67:        AD 82 1B      LDA.W $1B82               
CODE_04EC6A:        38            SEC                       
CODE_04EC6B:        E5 1E         SBC $1E                   
CODE_04EC6D:        85 00         STA $00                   
CODE_04EC6F:        AD 83 1B      LDA.W $1B83               
CODE_04EC72:        18            CLC                       
CODE_04EC73:        E5 20         SBC $20                   
CODE_04EC75:        85 01         STA $01                   
Return04EC77:       60            RTS                       ; Return 

CODE_04EC78:        A9 7E         LDA.B #$7E                
CODE_04EC7A:        85 0F         STA $0F                   
CODE_04EC7C:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04EC7E:        A9 00 C8      LDA.W #$C800              
CODE_04EC81:        85 0D         STA $0D                   
CODE_04EC83:        AD EA 1D      LDA.W $1DEA               
CODE_04EC86:        29 FF 00      AND.W #$00FF              
CODE_04EC89:        0A            ASL                       
CODE_04EC8A:        AA            TAX                       
CODE_04EC8B:        BF 5D D8 04   LDA.L DATA_04D85D,X       
CODE_04EC8F:        A8            TAY                       
CODE_04EC90:        A2 15 00      LDX.W #$0015              
CODE_04EC93:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04EC95:        B7 0D         LDA [$0D],Y               
CODE_04EC97:        DF 1D DA 04   CMP.L DATA_04DA1D,X       
CODE_04EC9B:        F0 0B         BEQ CODE_04ECA8           
CODE_04EC9D:        CA            DEX                       
CODE_04EC9E:        10 F7         BPL CODE_04EC97           
CODE_04ECA0:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_04ECA2:        A9 07         LDA.B #$07                
CODE_04ECA4:        8D 86 1B      STA.W $1B86               
Return04ECA7:       60            RTS                       ; Return 

CODE_04ECA8:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04ECAA:        A9 01         LDA.B #$01                
CODE_04ECAC:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_04ECAF:        EE 86 1B      INC.W $1B86               
CODE_04ECB2:        AD EA 1D      LDA.W $1DEA               
CODE_04ECB5:        29 FF         AND.B #$FF                
CODE_04ECB7:        0A            ASL                       
CODE_04ECB8:        AA            TAX                       
CODE_04ECB9:        BF 5D D8 04   LDA.L DATA_04D85D,X       
CODE_04ECBD:        0A            ASL                       
CODE_04ECBE:        0A            ASL                       
CODE_04ECBF:        0A            ASL                       
CODE_04ECC0:        0A            ASL                       
CODE_04ECC1:        8D 82 1B      STA.W $1B82               
CODE_04ECC4:        BF 5D D8 04   LDA.L DATA_04D85D,X       
CODE_04ECC8:        29 F0         AND.B #$F0                
CODE_04ECCA:        8D 83 1B      STA.W $1B83               
CODE_04ECCD:        A9 1C         LDA.B #$1C                
CODE_04ECCF:        8D 84 1B      STA.W $1B84               
Return04ECD2:       60            RTS                       ; Return 


DATA_04ECD3:                      .db $86,$99,$86,$19,$86,$D9,$86,$59
                                  .db $96,$99,$96,$19,$96,$D9,$96,$59
                                  .db $86,$9D,$86,$1D,$86,$DD,$86,$5D
                                  .db $96,$9D,$96,$1D,$96,$DD,$96,$5D
                                  .db $86,$99,$86,$19,$86,$D9,$86,$59
                                  .db $96,$99,$96,$19,$96,$D9,$96,$59
                                  .db $86,$9D,$86,$1D,$86,$DD,$86,$5D
                                  .db $96,$9D,$96,$1D,$96,$DD,$96,$5D
                                  .db $88,$15,$98,$15,$89,$15,$99,$15
                                  .db $A4,$11,$B4,$11,$A5,$11,$B5,$11
                                  .db $22,$11,$90,$11,$22,$11,$91,$11
                                  .db $C2,$11,$D2,$11,$C3,$11,$D3,$11
                                  .db $A6,$11,$B6,$11,$A7,$11,$B7,$11
                                  .db $82,$19,$92,$19,$83,$19,$93,$19
                                  .db $C8,$19,$F8,$19,$C9,$19,$F9,$19
                                  .db $80,$1C,$90,$1C,$81,$1C,$90,$5C
                                  .db $80,$14,$90,$14,$81,$14,$90,$54
                                  .db $A2,$11,$B2,$11,$A3,$11,$B3,$11
                                  .db $82,$1D,$92,$1D,$83,$1D,$93,$1D
                                  .db $86,$99,$86,$19,$86,$D9,$86,$59
                                  .db $86,$99,$86,$19,$86,$D9,$86,$59
                                  .db $A8,$11,$B8,$11,$A9,$11,$B9,$11

CODE_04ED83:        A9 7E         LDA.B #$7E                
CODE_04ED85:        85 0F         STA $0F                   
CODE_04ED87:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04ED89:        A9 00 C8      LDA.W #$C800              
CODE_04ED8C:        85 0D         STA $0D                   
CODE_04ED8E:        AD EA 1D      LDA.W $1DEA               
CODE_04ED91:        29 FF 00      AND.W #$00FF              
CODE_04ED94:        0A            ASL                       
CODE_04ED95:        AA            TAX                       
CODE_04ED96:        BF 5D D8 04   LDA.L DATA_04D85D,X       
CODE_04ED9A:        A8            TAY                       
CODE_04ED9B:        A2 15 00      LDX.W #$0015              
CODE_04ED9E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04EDA0:        B7 0D         LDA [$0D],Y               
CODE_04EDA2:        DF 1D DA 04   CMP.L DATA_04DA1D,X       
CODE_04EDA6:        F0 03         BEQ CODE_04EDAB           
CODE_04EDA8:        CA            DEX                       
CODE_04EDA9:        D0 F7         BNE CODE_04EDA2           
CODE_04EDAB:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04EDAD:        86 0E         STX $0E                   
CODE_04EDAF:        AD EA 1D      LDA.W $1DEA               
CODE_04EDB2:        29 FF 00      AND.W #$00FF              
CODE_04EDB5:        0A            ASL                       
CODE_04EDB6:        AA            TAX                       
CODE_04EDB7:        BF 3D D9 04   LDA.L DATA_04D93D,X       
CODE_04EDBB:        85 00         STA $00                   
CODE_04EDBD:        BF 5D D8 04   LDA.L DATA_04D85D,X       
CODE_04EDC1:        AA            TAX                       
CODE_04EDC2:        DA            PHX                       
CODE_04EDC3:        A6 0E         LDX $0E                   
CODE_04EDC5:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04EDC7:        BF 33 DA 04   LDA.L DATA_04DA33,X       
CODE_04EDCB:        FA            PLX                       
CODE_04EDCC:        9F 00 C8 7E   STA.L $7EC800,X           
CODE_04EDD0:        A9 04         LDA.B #$04                
CODE_04EDD2:        85 0C         STA $0C                   
CODE_04EDD4:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04EDD6:        A9 D3 EC      LDA.W #$ECD3              
CODE_04EDD9:        85 0A         STA $0A                   
CODE_04EDDB:        A5 0E         LDA $0E                   
CODE_04EDDD:        0A            ASL                       
CODE_04EDDE:        0A            ASL                       
CODE_04EDDF:        0A            ASL                       
CODE_04EDE0:        A8            TAY                       
CODE_04EDE1:        AF 7B 83 7F   LDA.L $7F837B             
CODE_04EDE5:        AA            TAX                       
CODE_04EDE6:        A5 00         LDA $00                   
CODE_04EDE8:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04EDEC:        18            CLC                       
CODE_04EDED:        69 00 20      ADC.W #$2000              
CODE_04EDF0:        9F 85 83 7F   STA.L $7F8385,X           
CODE_04EDF4:        A9 00 03      LDA.W #$0300              
CODE_04EDF7:        9F 7F 83 7F   STA.L $7F837F,X           
CODE_04EDFB:        9F 87 83 7F   STA.L $7F8387,X           
CODE_04EDFF:        B7 0A         LDA [$0A],Y               
CODE_04EE01:        9F 81 83 7F   STA.L $7F8381,X           
CODE_04EE05:        C8            INY                       
CODE_04EE06:        C8            INY                       
CODE_04EE07:        B7 0A         LDA [$0A],Y               
CODE_04EE09:        9F 89 83 7F   STA.L $7F8389,X           
CODE_04EE0D:        C8            INY                       
CODE_04EE0E:        C8            INY                       
CODE_04EE0F:        B7 0A         LDA [$0A],Y               
CODE_04EE11:        9F 83 83 7F   STA.L $7F8383,X           
CODE_04EE15:        C8            INY                       
CODE_04EE16:        C8            INY                       
CODE_04EE17:        B7 0A         LDA [$0A],Y               
CODE_04EE19:        9F 8B 83 7F   STA.L $7F838B,X           
CODE_04EE1D:        A9 FF 00      LDA.W #$00FF              
CODE_04EE20:        9F 8D 83 7F   STA.L $7F838D,X           
CODE_04EE24:        8A            TXA                       
CODE_04EE25:        18            CLC                       
CODE_04EE26:        69 10 00      ADC.W #$0010              
CODE_04EE29:        8F 7B 83 7F   STA.L $7F837B             
CODE_04EE2D:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return04EE2F:       60            RTS                       ; Return 

CODE_04EE30:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04EE32:        A9 7F         LDA.B #$7F                
CODE_04EE34:        85 0E         STA $0E                   
CODE_04EE36:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04EE38:        AD EB 1D      LDA.W $1DEB               
CODE_04EE3B:        0A            ASL                       
CODE_04EE3C:        0A            ASL                       
CODE_04EE3D:        AA            TAX                       
CODE_04EE3E:        BF 8F DD 04   LDA.L DATA_04DD8F,X       
CODE_04EE42:        85 00         STA $00                   
CODE_04EE44:        29 FF 1F      AND.W #$1FFF              
CODE_04EE47:        4A            LSR                       
CODE_04EE48:        18            CLC                       
CODE_04EE49:        69 00 30      ADC.W #$3000              
CODE_04EE4C:        EB            XBA                       
CODE_04EE4D:        85 02         STA $02                   
CODE_04EE4F:        A9 00 40      LDA.W #$4000              
CODE_04EE52:        85 0C         STA $0C                   
CODE_04EE54:        A9 FF FF      LDA.W #$FFFF              
CODE_04EE57:        85 0A         STA $0A                   
CODE_04EE59:        BF 8D DD 04   LDA.L DATA_04DD8D,X       
CODE_04EE5D:        C9 00 09      CMP.W #$0900              
CODE_04EE60:        90 06         BCC CODE_04EE68           
CODE_04EE62:        20 6C E7      JSR.W CODE_04E76C         
CODE_04EE65:        4C 6B EE      JMP.W CODE_04EE6B         

CODE_04EE68:        20 24 E8      JSR.W CODE_04E824         
CODE_04EE6B:        A9 FF 00      LDA.W #$00FF              
CODE_04EE6E:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04EE72:        8A            TXA                       
CODE_04EE73:        8F 7B 83 7F   STA.L $7F837B             
CODE_04EE77:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return04EE79:       60            RTS                       ; Return 


DATA_04EE7A:                      .db $22,$01,$82,$1C,$22,$01,$83,$1C
                                  .db $22,$01,$82,$14,$22,$01,$83,$14
                                  .db $EA,$01,$EA,$01,$EA,$C1,$EA,$C1
                                  .db $EA,$01,$EA,$01,$EA,$C1,$EA,$C1
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $8A,$15,$9A,$15,$8B,$15,$9B,$15

CODE_04EEAA:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_04EEAC:        A9 7E         LDA.B #$7E                
CODE_04EEAE:        85 0F         STA $0F                   
CODE_04EEB0:        A9 04         LDA.B #$04                
CODE_04EEB2:        85 0C         STA $0C                   
CODE_04EEB4:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_04EEB6:        A9 00 C8      LDA.W #$C800              
CODE_04EEB9:        85 0D         STA $0D                   
CODE_04EEBB:        A9 7A EE      LDA.W #$EE7A              
CODE_04EEBE:        85 0A         STA $0A                   
CODE_04EEC0:        AD D1 13      LDA.W $13D1               
CODE_04EEC3:        29 FF 00      AND.W #$00FF              
CODE_04EEC6:        0A            ASL                       
CODE_04EEC7:        AA            TAX                       
CODE_04EEC8:        BF 87 E5 04   LDA.L DATA_04E587,X       
CODE_04EECC:        85 00         STA $00                   
CODE_04EECE:        AF 7B 83 7F   LDA.L $7F837B             
CODE_04EED2:        AA            TAX                       
CODE_04EED3:        AD D0 13      LDA.W $13D0               
CODE_04EED6:        29 FF 00      AND.W #$00FF              
CODE_04EED9:        C9 03 00      CMP.W #$0003              
CODE_04EEDC:        30 49         BMI CODE_04EF27           
CODE_04EEDE:        0A            ASL                       
CODE_04EEDF:        0A            ASL                       
CODE_04EEE0:        0A            ASL                       
CODE_04EEE1:        A8            TAY                       
CODE_04EEE2:        A5 00         LDA $00                   
CODE_04EEE4:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04EEE8:        18            CLC                       
CODE_04EEE9:        69 00 20      ADC.W #$2000              
CODE_04EEEC:        9F 85 83 7F   STA.L $7F8385,X           
CODE_04EEF0:        EB            XBA                       
CODE_04EEF1:        18            CLC                       
CODE_04EEF2:        69 20 00      ADC.W #$0020              
CODE_04EEF5:        EB            XBA                       
CODE_04EEF6:        85 00         STA $00                   
CODE_04EEF8:        A9 00 03      LDA.W #$0300              
CODE_04EEFB:        9F 7F 83 7F   STA.L $7F837F,X           
CODE_04EEFF:        9F 87 83 7F   STA.L $7F8387,X           
CODE_04EF03:        B7 0A         LDA [$0A],Y               
CODE_04EF05:        9F 81 83 7F   STA.L $7F8381,X           
CODE_04EF09:        C8            INY                       
CODE_04EF0A:        C8            INY                       
CODE_04EF0B:        B7 0A         LDA [$0A],Y               
CODE_04EF0D:        9F 89 83 7F   STA.L $7F8389,X           
CODE_04EF11:        C8            INY                       
CODE_04EF12:        C8            INY                       
CODE_04EF13:        B7 0A         LDA [$0A],Y               
CODE_04EF15:        9F 83 83 7F   STA.L $7F8383,X           
CODE_04EF19:        C8            INY                       
CODE_04EF1A:        C8            INY                       
CODE_04EF1B:        B7 0A         LDA [$0A],Y               
CODE_04EF1D:        9F 8B 83 7F   STA.L $7F838B,X           
CODE_04EF21:        8A            TXA                       
CODE_04EF22:        18            CLC                       
CODE_04EF23:        69 10 00      ADC.W #$0010              
CODE_04EF26:        AA            TAX                       
CODE_04EF27:        AD D0 13      LDA.W $13D0               
CODE_04EF2A:        29 FF 00      AND.W #$00FF              
CODE_04EF2D:        C9 02 00      CMP.W #$0002              
CODE_04EF30:        10 06         BPL CODE_04EF38           
CODE_04EF32:        0A            ASL                       
CODE_04EF33:        0A            ASL                       
CODE_04EF34:        0A            ASL                       
CODE_04EF35:        A8            TAY                       
CODE_04EF36:        80 03         BRA CODE_04EF3B           

CODE_04EF38:        A0 28 00      LDY.W #$0028              
CODE_04EF3B:        4C E6 ED      JMP.W CODE_04EDE6         


DATA_04EF3E:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF

DATA_04F280:                      .db $00,$D8,$28,$D0,$30,$D8,$28,$00
DATA_04F288:                      .db $D0,$D8,$D8,$00,$00,$28,$28,$30

CODE_04F290:        AC 39 14      LDY.W $1439               ; Index (8 bit) Accum (8 bit) 
CODE_04F293:        C0 0C         CPY.B #$0C                
CODE_04F295:        90 04         BCC CODE_04F29B           
CODE_04F297:        9C D2 13      STZ.W $13D2               
Return04F29A:       60            RTS                       ; Return 

CODE_04F29B:        AD 37 14      LDA.W $1437               
CODE_04F29E:        D0 74         BNE CODE_04F314           
CODE_04F2A0:        C0 08         CPY.B #$08                
CODE_04F2A2:        B0 68         BCS CODE_04F30C           
CODE_04F2A4:        A9 1C         LDA.B #$1C                
CODE_04F2A6:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_04F2A9:        A9 07         LDA.B #$07                
CODE_04F2AB:        85 00         STA $00                   
CODE_04F2AD:        AE 36 14      LDX.W RAM_KeyHolePos1     
CODE_04F2B0:        AC D6 0D      LDY.W $0DD6               
CODE_04F2B3:        B9 17 1F      LDA.W $1F17,Y             
CODE_04F2B6:        9F 78 B9 7E   STA.L $7EB978,X           
CODE_04F2BA:        B9 18 1F      LDA.W $1F18,Y             
CODE_04F2BD:        9F 00 B9 7E   STA.L $7EB900,X           
CODE_04F2C1:        B9 19 1F      LDA.W $1F19,Y             
CODE_04F2C4:        9F A0 B9 7E   STA.L $7EB9A0,X           
CODE_04F2C8:        B9 1A 1F      LDA.W $1F1A,Y             
CODE_04F2CB:        9F 28 B9 7E   STA.L $7EB928,X           
CODE_04F2CF:        A9 00         LDA.B #$00                
CODE_04F2D1:        9F C8 B9 7E   STA.L $7EB9C8,X           
CODE_04F2D5:        9F 50 B9 7E   STA.L $7EB950,X           
CODE_04F2D9:        A4 00         LDY $00                   
CODE_04F2DB:        B9 80 F2      LDA.W DATA_04F280,Y       
CODE_04F2DE:        9F F0 B9 7E   STA.L $7EB9F0,X           
CODE_04F2E2:        B9 88 F2      LDA.W DATA_04F288,Y       
CODE_04F2E5:        9F 18 BA 7E   STA.L $7EBA18,X           
CODE_04F2E9:        A9 D0         LDA.B #$D0                
CODE_04F2EB:        9F 40 BA 7E   STA.L $7EBA40,X           
CODE_04F2EF:        E8            INX                       
CODE_04F2F0:        C6 00         DEC $00                   
CODE_04F2F2:        10 BC         BPL CODE_04F2B0           
CODE_04F2F4:        E0 28         CPX.B #$28                
CODE_04F2F6:        90 11         BCC CODE_04F309           
CODE_04F2F8:        AD 38 14      LDA.W RAM_KeyHolePos2     
CODE_04F2FB:        18            CLC                       
CODE_04F2FC:        69 20         ADC.B #$20                
CODE_04F2FE:        C9 A0         CMP.B #$A0                
CODE_04F300:        90 02         BCC CODE_04F304           
ADDR_04F302:        A9 00         LDA.B #$00                
CODE_04F304:        8D 38 14      STA.W RAM_KeyHolePos2     
CODE_04F307:        A2 00         LDX.B #$00                
CODE_04F309:        8E 36 14      STX.W RAM_KeyHolePos1     
CODE_04F30C:        A9 10         LDA.B #$10                
CODE_04F30E:        8D 37 14      STA.W $1437               
CODE_04F311:        EE 39 14      INC.W $1439               
CODE_04F314:        CE 37 14      DEC.W $1437               
CODE_04F317:        AD 38 14      LDA.W RAM_KeyHolePos2     
CODE_04F31A:        85 0F         STA $0F                   
CODE_04F31C:        A2 00         LDX.B #$00                
CODE_04F31E:        DA            PHX                       
CODE_04F31F:        A0 00         LDY.B #$00                
CODE_04F321:        20 9C F3      JSR.W CODE_04F39C         
CODE_04F324:        20 97 F3      JSR.W CODE_04F397         
CODE_04F327:        20 97 F3      JSR.W CODE_04F397         
CODE_04F32A:        FA            PLX                       
CODE_04F32B:        BF 40 BA 7E   LDA.L $7EBA40,X           
CODE_04F32F:        18            CLC                       
CODE_04F330:        69 01         ADC.B #$01                
CODE_04F332:        30 06         BMI CODE_04F33A           
CODE_04F334:        C9 40         CMP.B #$40                
CODE_04F336:        90 02         BCC CODE_04F33A           
CODE_04F338:        A9 40         LDA.B #$40                
CODE_04F33A:        9F 40 BA 7E   STA.L $7EBA40,X           
CODE_04F33E:        BF 50 B9 7E   LDA.L $7EB950,X           
CODE_04F342:        EB            XBA                       
CODE_04F343:        BF C8 B9 7E   LDA.L $7EB9C8,X           
CODE_04F347:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04F349:        18            CLC                       
CODE_04F34A:        65 02         ADC $02                   
CODE_04F34C:        85 02         STA $02                   
CODE_04F34E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04F350:        EB            XBA                       
CODE_04F351:        05 01         ORA $01                   
CODE_04F353:        D0 23         BNE CODE_04F378           
CODE_04F355:        A4 0F         LDY $0F                   
CODE_04F357:        EB            XBA                       
CODE_04F358:        99 41 03      STA.W $0341,Y             
CODE_04F35B:        A5 00         LDA $00                   
CODE_04F35D:        99 40 03      STA.W $0340,Y             
CODE_04F360:        A9 E6         LDA.B #$E6                
CODE_04F362:        99 42 03      STA.W $0342,Y             
CODE_04F365:        AD D2 13      LDA.W $13D2               
CODE_04F368:        3A            DEC A                     
CODE_04F369:        0A            ASL                       
CODE_04F36A:        09 30         ORA.B #$30                
CODE_04F36C:        99 43 03      STA.W $0343,Y             
CODE_04F36F:        98            TYA                       
CODE_04F370:        4A            LSR                       
CODE_04F371:        4A            LSR                       
CODE_04F372:        A8            TAY                       
CODE_04F373:        A9 02         LDA.B #$02                
CODE_04F375:        99 70 04      STA.W $0470,Y             
CODE_04F378:        A5 0F         LDA $0F                   
CODE_04F37A:        18            CLC                       
CODE_04F37B:        69 04         ADC.B #$04                
CODE_04F37D:        C9 A0         CMP.B #$A0                
CODE_04F37F:        90 02         BCC CODE_04F383           
CODE_04F381:        A9 00         LDA.B #$00                
CODE_04F383:        85 0F         STA $0F                   
CODE_04F385:        E8            INX                       
CODE_04F386:        EC 36 14      CPX.W RAM_KeyHolePos1     
CODE_04F389:        90 93         BCC CODE_04F31E           
CODE_04F38B:        AD 39 14      LDA.W $1439               
CODE_04F38E:        C9 05         CMP.B #$05                
CODE_04F390:        90 04         BCC Return04F396          
CODE_04F392:        E0 28         CPX.B #$28                
CODE_04F394:        90 88         BCC CODE_04F31E           
Return04F396:       60            RTS                       ; Return 

CODE_04F397:        8A            TXA                       
CODE_04F398:        18            CLC                       
CODE_04F399:        69 28         ADC.B #$28                
CODE_04F39B:        AA            TAX                       
CODE_04F39C:        5A            PHY                       
CODE_04F39D:        BF F0 B9 7E   LDA.L $7EB9F0,X           
CODE_04F3A1:        0A            ASL                       
CODE_04F3A2:        0A            ASL                       
CODE_04F3A3:        0A            ASL                       
CODE_04F3A4:        0A            ASL                       
CODE_04F3A5:        18            CLC                       
CODE_04F3A6:        7F 68 BA 7E   ADC.L $7EBA68,X           
CODE_04F3AA:        9F 68 BA 7E   STA.L $7EBA68,X           
CODE_04F3AE:        BF F0 B9 7E   LDA.L $7EB9F0,X           
CODE_04F3B2:        08            PHP                       
CODE_04F3B3:        4A            LSR                       
CODE_04F3B4:        4A            LSR                       
CODE_04F3B5:        4A            LSR                       
CODE_04F3B6:        4A            LSR                       
CODE_04F3B7:        A0 00         LDY.B #$00                
CODE_04F3B9:        28            PLP                       
CODE_04F3BA:        10 03         BPL CODE_04F3BF           
CODE_04F3BC:        09 F0         ORA.B #$F0                
CODE_04F3BE:        88            DEY                       
CODE_04F3BF:        7F 78 B9 7E   ADC.L $7EB978,X           
CODE_04F3C3:        9F 78 B9 7E   STA.L $7EB978,X           
CODE_04F3C7:        EB            XBA                       
CODE_04F3C8:        98            TYA                       
CODE_04F3C9:        7F 00 B9 7E   ADC.L $7EB900,X           
CODE_04F3CD:        9F 00 B9 7E   STA.L $7EB900,X           
CODE_04F3D1:        EB            XBA                       
CODE_04F3D2:        7A            PLY                       
CODE_04F3D3:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04F3D5:        38            SEC                       
CODE_04F3D6:        F9 1A 00      SBC.W RAM_ScreenBndryXLo,Y 
CODE_04F3D9:        38            SEC                       
CODE_04F3DA:        E9 08 00      SBC.W #$0008              
CODE_04F3DD:        99 00 00      STA.W $0000,Y             
CODE_04F3E0:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04F3E2:        C8            INY                       
CODE_04F3E3:        C8            INY                       
Return04F3E4:       60            RTS                       ; Return 

CODE_04F3E5:        3A            DEC A                     
CODE_04F3E6:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs04F3EA:            FF F3      .dw CODE_04F3FF           
                       15 F4      .dw CODE_04F415           
                       13 F5      .dw CODE_04F513           
                       15 F4      .dw CODE_04F415           
                       FF F3      .dw CODE_04F3FF           
                       15 F4      .dw CODE_04F415           
                       FA F3      .dw CODE_04F3FA           
                       15 F4      .dw CODE_04F415           

CODE_04F3FA:        22 A8 9B 00   JSL.L CODE_009BA8         
Return04F3FE:       60            RTS                       ; Return 

CODE_04F3FF:        A9 22         LDA.B #$22                
CODE_04F401:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_04F404:        EE 87 1B      INC.W $1B87               
CODE_04F407:        64 41         STZ $41                   
CODE_04F409:        64 42         STZ $42                   
CODE_04F40B:        64 43         STZ $43                   
CODE_04F40D:        9C 9F 0D      STZ.W $0D9F               
Return04F410:       60            RTS                       ; Return 


DATA_04F411:                      .db $04,$FC

DATA_04F413:                      .db $68,$00

CODE_04F415:        A2 00         LDX.B #$00                
CODE_04F417:        AD B4 0D      LDA.W RAM_PlayerLives     
CODE_04F41A:        CD B5 0D      CMP.W $0DB5               
CODE_04F41D:        10 01         BPL CODE_04F420           
ADDR_04F41F:        E8            INX                       
CODE_04F420:        8E 8A 1B      STX.W $1B8A               
CODE_04F423:        AE 88 1B      LDX.W $1B88               
CODE_04F426:        AD 89 1B      LDA.W $1B89               
CODE_04F429:        DF 13 F4 04   CMP.L DATA_04F413,X       
CODE_04F42D:        D0 1C         BNE CODE_04F44B           
CODE_04F42F:        EE 87 1B      INC.W $1B87               
CODE_04F432:        AD 87 1B      LDA.W $1B87               
CODE_04F435:        C9 07         CMP.B #$07                
CODE_04F437:        D0 04         BNE CODE_04F43D           
CODE_04F439:        A0 1E         LDY.B #$1E                
CODE_04F43B:        84 12         STY $12                   
CODE_04F43D:        3A            DEC A                     
CODE_04F43E:        29 03         AND.B #$03                
CODE_04F440:        D0 08         BNE Return04F44A          
CODE_04F442:        9C 87 1B      STZ.W $1B87               
CODE_04F445:        9C 88 1B      STZ.W $1B88               
CODE_04F448:        80 BD         BRA CODE_04F407           

Return04F44A:       60            RTS                       ; Return 

CODE_04F44B:        18            CLC                       
CODE_04F44C:        7F 11 F4 04   ADC.L DATA_04F411,X       
CODE_04F450:        8D 89 1B      STA.W $1B89               
CODE_04F453:        18            CLC                       
CODE_04F454:        69 80         ADC.B #$80                
CODE_04F456:        EB            XBA                       
CODE_04F457:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_04F459:        A2 6E 01      LDX.W #$016E              
CODE_04F45C:        A9 FF         LDA.B #$FF                
CODE_04F45E:        9D F0 04      STA.W $04F0,X             
CODE_04F461:        9E F1 04      STZ.W $04F1,X             
CODE_04F464:        CA            DEX                       
CODE_04F465:        CA            DEX                       
CODE_04F466:        10 F6         BPL CODE_04F45E           
CODE_04F468:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_04F46A:        AD 89 1B      LDA.W $1B89               
CODE_04F46D:        4A            LSR                       
CODE_04F46E:        6D 89 1B      ADC.W $1B89               
CODE_04F471:        4A            LSR                       
CODE_04F472:        29 FE         AND.B #$FE                
CODE_04F474:        AA            TAX                       
CODE_04F475:        A9 80         LDA.B #$80                
CODE_04F477:        38            SEC                       
CODE_04F478:        ED 89 1B      SBC.W $1B89               
CODE_04F47B:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04F47D:        A0 48         LDY.B #$48                
CODE_04F47F:        99 48 05      STA.W $0548,Y             
CODE_04F482:        9D 90 05      STA.W $0590,X             
CODE_04F485:        88            DEY                       
CODE_04F486:        88            DEY                       
CODE_04F487:        CA            DEX                       
CODE_04F488:        CA            DEX                       
CODE_04F489:        10 F4         BPL CODE_04F47F           
CODE_04F48B:        9C 01 07      STZ.W $0701               
CODE_04F48E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04F490:        A9 22         LDA.B #$22                
CODE_04F492:        85 41         STA $41                   
CODE_04F494:        A9 20         LDA.B #$20                
CODE_04F496:        4C 95 DB      JMP.W CODE_04DB95         


DATA_04F499:                      .db $51,$C4,$40,$24,$FC,$38,$52,$04
                                  .db $40,$2C,$FC,$38,$52,$2F,$40,$02
                                  .db $FC,$38,$52,$48,$40,$1C,$FC,$38
                                  .db $FF

DATA_04F4B2:                      .db $52,$49,$00,$09,$16,$28,$0A,$28
                                  .db $1B,$28,$12,$28,$18,$28,$52,$52
                                  .db $00,$09,$15,$28,$1E,$28,$12,$28
                                  .db $10,$28,$12,$28,$52,$0B,$00,$05
                                  .db $26,$28,$00,$28,$00,$28,$52,$14
                                  .db $00,$05,$26,$28,$00,$28,$00,$28
                                  .db $52,$0F,$00,$03,$FC,$38,$FC,$38
                                  .db $52,$2F,$00,$03,$FC,$38,$FC,$38
                                  .db $51,$C9,$00,$03,$85,$29,$85,$69
                                  .db $51,$D2,$00,$03,$85,$29,$85,$69
                                  .db $FF

DATA_04F503:                      .db $7D,$38,$7E,$78

DATA_04F507:                      .db $7E,$38,$7D,$78

DATA_04F50B:                      .db $7D,$B8,$7E,$F8

DATA_04F50F:                      .db $7E,$B8,$7D,$F8

CODE_04F513:        AD A6 0D      LDA.W RAM_OWControllerA   
CODE_04F516:        0D A7 0D      ORA.W $0DA7               
CODE_04F519:        29 10         AND.B #$10                
CODE_04F51B:        F0 0E         BEQ CODE_04F52B           
CODE_04F51D:        AE B3 0D      LDX.W $0DB3               
CODE_04F520:        BD B4 0D      LDA.W RAM_PlayerLives,X   
CODE_04F523:        8D BE 0D      STA.W RAM_StatusLives     
CODE_04F526:        22 13 9C 00   JSL.L CODE_009C13         
Return04F52A:       60            RTS                       ; Return 

CODE_04F52B:        AD A6 0D      LDA.W RAM_OWControllerA   
CODE_04F52E:        29 C0         AND.B #$C0                
CODE_04F530:        D0 09         BNE CODE_04F53B           
CODE_04F532:        AD A7 0D      LDA.W $0DA7               
CODE_04F535:        29 C0         AND.B #$C0                
CODE_04F537:        F0 33         BEQ CODE_04F56C           
ADDR_04F539:        49 C0         EOR.B #$C0                
CODE_04F53B:        A2 01         LDX.B #$01                
CODE_04F53D:        0A            ASL                       
CODE_04F53E:        B0 01         BCS CODE_04F541           
CODE_04F540:        CA            DEX                       
CODE_04F541:        EC 8A 1B      CPX.W $1B8A               
CODE_04F544:        F0 05         BEQ CODE_04F54B           
CODE_04F546:        A9 18         LDA.B #$18                
CODE_04F548:        8D 8B 1B      STA.W $1B8B               
CODE_04F54B:        8E 8A 1B      STX.W $1B8A               
CODE_04F54E:        8A            TXA                       
CODE_04F54F:        49 01         EOR.B #$01                
CODE_04F551:        A8            TAY                       
CODE_04F552:        BD B4 0D      LDA.W RAM_PlayerLives,X   
CODE_04F555:        F0 15         BEQ CODE_04F56C           
CODE_04F557:        30 13         BMI CODE_04F56C           
CODE_04F559:        B9 B4 0D      LDA.W RAM_PlayerLives,Y   
CODE_04F55C:        C9 62         CMP.B #$62                
CODE_04F55E:        10 0C         BPL CODE_04F56C           
CODE_04F560:        1A            INC A                     
CODE_04F561:        99 B4 0D      STA.W RAM_PlayerLives,Y   
CODE_04F564:        DE B4 0D      DEC.W RAM_PlayerLives,X   
CODE_04F567:        A9 23         LDA.B #$23                
CODE_04F569:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_04F56C:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04F56E:        A9 48 78      LDA.W #$7848              
CODE_04F571:        8D 9C 02      STA.W $029C               
CODE_04F574:        A9 90 78      LDA.W #$7890              
CODE_04F577:        8D A0 02      STA.W $02A0               
CODE_04F57A:        A9 0A 34      LDA.W #$340A              
CODE_04F57D:        8D 9E 02      STA.W $029E               
CODE_04F580:        A9 0A 36      LDA.W #$360A              
CODE_04F583:        8D A2 02      STA.W $02A2               
CODE_04F586:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04F588:        A9 02         LDA.B #$02                
CODE_04F58A:        8D 47 04      STA.W $0447               
CODE_04F58D:        8D 48 04      STA.W $0448               
CODE_04F590:        22 F2 DB 05   JSL.L CODE_05DBF2         
CODE_04F594:        A0 50         LDY.B #$50                
CODE_04F596:        98            TYA                       
CODE_04F597:        18            CLC                       
CODE_04F598:        6F 7B 83 7F   ADC.L $7F837B             
CODE_04F59C:        8F 7B 83 7F   STA.L $7F837B             
CODE_04F5A0:        AA            TAX                       
CODE_04F5A1:        B9 B2 F4      LDA.W DATA_04F4B2,Y       
CODE_04F5A4:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_04F5A8:        CA            DEX                       
CODE_04F5A9:        88            DEY                       
CODE_04F5AA:        10 F5         BPL CODE_04F5A1           
CODE_04F5AC:        E8            INX                       
CODE_04F5AD:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04F5AF:        AC B4 0D      LDY.W RAM_PlayerLives     
CODE_04F5B2:        30 0B         BMI CODE_04F5BF           
CODE_04F5B4:        A9 FC 38      LDA.W #$38FC              
CODE_04F5B7:        9F C1 83 7F   STA.L $7F83C1,X           
CODE_04F5BB:        9F C3 83 7F   STA.L $7F83C3,X           
CODE_04F5BF:        AC B5 0D      LDY.W $0DB5               
CODE_04F5C2:        30 0B         BMI CODE_04F5CF           
CODE_04F5C4:        A9 FC 38      LDA.W #$38FC              
CODE_04F5C7:        9F C9 83 7F   STA.L $7F83C9,X           
CODE_04F5CB:        9F CB 83 7F   STA.L $7F83CB,X           
CODE_04F5CF:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04F5D1:        EE 8B 1B      INC.W $1B8B               
CODE_04F5D4:        AD 8B 1B      LDA.W $1B8B               
CODE_04F5D7:        29 18         AND.B #$18                
CODE_04F5D9:        F0 25         BEQ CODE_04F600           
CODE_04F5DB:        AD 8A 1B      LDA.W $1B8A               
CODE_04F5DE:        0A            ASL                       
CODE_04F5DF:        A8            TAY                       
CODE_04F5E0:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04F5E2:        B9 03 F5      LDA.W DATA_04F503,Y       
CODE_04F5E5:        9F B1 83 7F   STA.L $7F83B1,X           
CODE_04F5E9:        B9 07 F5      LDA.W DATA_04F507,Y       
CODE_04F5EC:        9F B3 83 7F   STA.L $7F83B3,X           
CODE_04F5F0:        B9 0B F5      LDA.W DATA_04F50B,Y       
CODE_04F5F3:        9F B9 83 7F   STA.L $7F83B9,X           
CODE_04F5F7:        B9 0F F5      LDA.W DATA_04F50F,Y       
CODE_04F5FA:        9F BB 83 7F   STA.L $7F83BB,X           
CODE_04F5FE:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04F600:        AD B4 0D      LDA.W RAM_PlayerLives     
CODE_04F603:        20 0E F6      JSR.W CODE_04F60E         
CODE_04F606:        8A            TXA                       
CODE_04F607:        18            CLC                       
CODE_04F608:        69 0A         ADC.B #$0A                
CODE_04F60A:        AA            TAX                       
CODE_04F60B:        AD B5 0D      LDA.W $0DB5               
CODE_04F60E:        1A            INC A                     
CODE_04F60F:        DA            PHX                       
CODE_04F610:        22 4C 97 00   JSL.L CODE_00974C         
CODE_04F614:        9B            TXY                       

Instr04F615:                      .db $D0,$02

Instr04F617:                      .db $A2,$FC

CODE_04F619:        9B            TXY                       
CODE_04F61A:        FA            PLX                       
CODE_04F61B:        9F A1 83 7F   STA.L $7F83A1,X           
CODE_04F61F:        98            TYA                       
CODE_04F620:        9F 9F 83 7F   STA.L $7F839F,X           
Return04F624:       60            RTS                       ; Return 


DATA_04F625:                      .db $00,$00,$01,$E0,$00,$00,$00,$01
                                  .db $60,$00,$06,$70,$01,$20,$00,$07
                                  .db $38,$00,$8A,$01,$00,$58,$00,$7A
                                  .db $00,$08,$88,$01,$18,$00,$09,$48
                                  .db $01,$FC,$FF,$00,$80,$00,$00

DATA_04F64C:                      .db $01,$00,$50,$00,$40,$01

DATA_04F652:                      .db $03,$00,$00,$00,$00,$0A,$40,$00
                                  .db $98,$00,$0A,$60,$00,$F8,$00,$0A
                                  .db $40,$01,$58

DATA_04F665:                      .db $01,$30,$00,$00,$01,$10,$FF,$20
                                  .db $00,$70,$FF,$10,$00,$01,$40,$80

CODE_04F675:        8B            PHB                       
CODE_04F676:        4B            PHK                       
CODE_04F677:        AB            PLB                       
CODE_04F678:        A2 0C         LDX.B #$0C                
CODE_04F67A:        A0 4B         LDY.B #$4B                
CODE_04F67C:        B9 16 F6      LDA.W ADDR_04F616,Y       
CODE_04F67F:        9D E8 0D      STA.W $0DE8,X             
CODE_04F682:        C9 01         CMP.B #$01                
CODE_04F684:        F0 04         BEQ ADDR_04F68A           
CODE_04F686:        C9 02         CMP.B #$02                
CODE_04F688:        D0 05         BNE CODE_04F68F           
ADDR_04F68A:        A9 40         LDA.B #$40                
ADDR_04F68C:        9D 58 0E      STA.W $0E58,X             
CODE_04F68F:        B9 17 F6      LDA.W Instr04F617,Y       
CODE_04F692:        9D 38 0E      STA.W $0E38,X             
CODE_04F695:        B9 18 F6      LDA.W ADDR_04F618,Y       
CODE_04F698:        9D 68 0E      STA.W $0E68,X             
CODE_04F69B:        B9 19 F6      LDA.W CODE_04F619,Y       
CODE_04F69E:        9D 48 0E      STA.W $0E48,X             
CODE_04F6A1:        B9 1A F6      LDA.W CODE_04F61A,Y       
CODE_04F6A4:        9D 78 0E      STA.W $0E78,X             
CODE_04F6A7:        98            TYA                       
CODE_04F6A8:        38            SEC                       
CODE_04F6A9:        E9 05         SBC.B #$05                
CODE_04F6AB:        A8            TAY                       
CODE_04F6AC:        CA            DEX                       
CODE_04F6AD:        10 CD         BPL CODE_04F67C           
CODE_04F6AF:        A2 0D         LDX.B #$0D                
CODE_04F6B1:        9E 25 0E      STZ.W $0E25,X             
CODE_04F6B4:        AD 22 FD      LDA.W DATA_04FD22         
CODE_04F6B7:        3A            DEC A                     
CODE_04F6B8:        9D B5 0E      STA.W $0EB5,X             
CODE_04F6BB:        BD 65 F6      LDA.W DATA_04F665,X       
CODE_04F6BE:        48            PHA                       
CODE_04F6BF:        8E DE 0D      STX.W $0DDE               
CODE_04F6C2:        20 53 F8      JSR.W CODE_04F853         
CODE_04F6C5:        68            PLA                       
CODE_04F6C6:        3A            DEC A                     
CODE_04F6C7:        D0 F5         BNE CODE_04F6BE           
CODE_04F6C9:        E8            INX                       
CODE_04F6CA:        E0 10         CPX.B #$10                
CODE_04F6CC:        90 E3         BCC CODE_04F6B1           
CODE_04F6CE:        AB            PLB                       
Return04F6CF:       6B            RTL                       ; Return 


DATA_04F6D0:                      .db $70,$7F,$78,$7F,$70,$7F,$78,$7F
DATA_04F6D8:                      .db $F0,$FF,$20,$00,$C0,$00,$F0,$FF
                                  .db $F0,$FF,$80,$00,$F0,$FF,$00,$00
DATA_04F6E8:                      .db $70,$00,$60,$01,$58,$01,$B0,$00
                                  .db $60,$01,$60,$01,$70,$00,$60,$01
DATA_04F6F8:                      .db $20,$58,$43,$CF,$18,$34,$A2,$5E
DATA_04F700:                      .db $07,$05,$06,$07,$04,$06,$07,$05

CODE_04F708:        A9 F7         LDA.B #$F7                
CODE_04F70A:        20 82 F8      JSR.W CODE_04F882         
CODE_04F70D:        D0 5F         BNE CODE_04F76E           
CODE_04F70F:        AC FB 1F      LDY.W $1FFB               
CODE_04F712:        D0 27         BNE CODE_04F73B           
CODE_04F714:        A5 13         LDA RAM_FrameCounter      
CODE_04F716:        4A            LSR                       
CODE_04F717:        90 55         BCC CODE_04F76E           
CODE_04F719:        CE FC 1F      DEC.W $1FFC               
CODE_04F71C:        D0 50         BNE CODE_04F76E           
CODE_04F71E:        A8            TAY                       
CODE_04F71F:        B9 08 F7      LDA.W CODE_04F708,Y       
CODE_04F722:        29 07         AND.B #$07                
CODE_04F724:        AA            TAX                       
CODE_04F725:        BD F8 F6      LDA.W DATA_04F6F8,X       
CODE_04F728:        8D FC 1F      STA.W $1FFC               
CODE_04F72B:        BC 00 F7      LDY.W DATA_04F700,X       
CODE_04F72E:        8C FB 1F      STY.W $1FFB               
CODE_04F731:        A9 08         LDA.B #$08                
CODE_04F733:        8D FD 1F      STA.W $1FFD               
CODE_04F736:        A9 18         LDA.B #$18                
CODE_04F738:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_04F73B:        CE FD 1F      DEC.W $1FFD               
CODE_04F73E:        10 08         BPL CODE_04F748           
CODE_04F740:        CE FB 1F      DEC.W $1FFB               
CODE_04F743:        A9 04         LDA.B #$04                
CODE_04F745:        8D FD 1F      STA.W $1FFD               
CODE_04F748:        98            TYA                       
CODE_04F749:        0A            ASL                       
CODE_04F74A:        A8            TAY                       
CODE_04F74B:        AE 81 06      LDX.W $0681               
CODE_04F74E:        A9 02         LDA.B #$02                
CODE_04F750:        9D 82 06      STA.W $0682,X             
CODE_04F753:        A9 47         LDA.B #$47                
CODE_04F755:        9D 83 06      STA.W $0683,X             
CODE_04F758:        B9 53 07      LDA.W $0753,Y             
CODE_04F75B:        9D 84 06      STA.W $0684,X             
CODE_04F75E:        B9 54 07      LDA.W $0754,Y             
CODE_04F761:        9D 85 06      STA.W $0685,X             
CODE_04F764:        9E 86 06      STZ.W $0686,X             
CODE_04F767:        8A            TXA                       
CODE_04F768:        18            CLC                       
CODE_04F769:        69 04         ADC.B #$04                
CODE_04F76B:        8D 81 06      STA.W $0681               
CODE_04F76E:        A2 02         LDX.B #$02                
CODE_04F770:        BD E5 0D      LDA.W $0DE5,X             
CODE_04F773:        D0 36         BNE CODE_04F7AB           
CODE_04F775:        A9 05         LDA.B #$05                
CODE_04F777:        9D E5 0D      STA.W $0DE5,X             
CODE_04F77A:        20 5B FE      JSR.W CODE_04FE5B         
CODE_04F77D:        29 07         AND.B #$07                
CODE_04F77F:        A8            TAY                       
CODE_04F780:        B9 D0 F6      LDA.W DATA_04F6D0,Y       
CODE_04F783:        9D 55 0E      STA.W $0E55,X             
CODE_04F786:        98            TYA                       
CODE_04F787:        0A            ASL                       
CODE_04F788:        A8            TAY                       
CODE_04F789:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04F78B:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_04F78D:        18            CLC                       
CODE_04F78E:        79 D8 F6      ADC.W DATA_04F6D8,Y       
CODE_04F791:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04F793:        9D 35 0E      STA.W $0E35,X             
CODE_04F796:        EB            XBA                       
CODE_04F797:        9D 65 0E      STA.W $0E65,X             
CODE_04F79A:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04F79C:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_04F79E:        18            CLC                       
CODE_04F79F:        79 E8 F6      ADC.W DATA_04F6E8,Y       
CODE_04F7A2:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04F7A4:        9D 45 0E      STA.W $0E45,X             
CODE_04F7A7:        EB            XBA                       
CODE_04F7A8:        9D 75 0E      STA.W $0E75,X             
CODE_04F7AB:        CA            DEX                       
CODE_04F7AC:        10 C2         BPL CODE_04F770           
CODE_04F7AE:        A2 04         LDX.B #$04                
CODE_04F7B0:        8A            TXA                       
CODE_04F7B1:        9D E0 0D      STA.W $0DE0,X             
CODE_04F7B4:        CA            DEX                       
CODE_04F7B5:        10 F9         BPL CODE_04F7B0           
CODE_04F7B7:        A2 04         LDX.B #$04                
CODE_04F7B9:        86 00         STX $00                   
CODE_04F7BB:        86 01         STX $01                   
CODE_04F7BD:        A6 00         LDX $00                   
CODE_04F7BF:        BC E0 0D      LDY.W $0DE0,X             
CODE_04F7C2:        B9 45 0E      LDA.W $0E45,Y             
CODE_04F7C5:        85 02         STA $02                   
CODE_04F7C7:        B9 75 0E      LDA.W $0E75,Y             
CODE_04F7CA:        85 03         STA $03                   
CODE_04F7CC:        A6 01         LDX $01                   
CODE_04F7CE:        BC DF 0D      LDY.W $0DDF,X             
CODE_04F7D1:        B9 75 0E      LDA.W $0E75,Y             
CODE_04F7D4:        EB            XBA                       
CODE_04F7D5:        B9 45 0E      LDA.W $0E45,Y             
CODE_04F7D8:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04F7DA:        C5 02         CMP $02                   
CODE_04F7DC:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04F7DE:        10 0D         BPL CODE_04F7ED           
CODE_04F7E0:        5A            PHY                       
CODE_04F7E1:        A4 00         LDY $00                   
CODE_04F7E3:        B9 E0 0D      LDA.W $0DE0,Y             
CODE_04F7E6:        9D DF 0D      STA.W $0DDF,X             
CODE_04F7E9:        68            PLA                       
CODE_04F7EA:        99 E0 0D      STA.W $0DE0,Y             
CODE_04F7ED:        CA            DEX                       
CODE_04F7EE:        D0 CB         BNE CODE_04F7BB           
CODE_04F7F0:        A6 00         LDX $00                   
CODE_04F7F2:        CA            DEX                       
CODE_04F7F3:        D0 C4         BNE CODE_04F7B9           
CODE_04F7F5:        A9 30         LDA.B #$30                
CODE_04F7F7:        8D DF 0D      STA.W $0DDF               
CODE_04F7FA:        9C F7 0E      STZ.W $0EF7               
CODE_04F7FD:        A2 0F         LDX.B #$0F                
CODE_04F7FF:        A0 2D         LDY.B #$2D                
CODE_04F801:        E0 0D         CPX.B #$0D                
CODE_04F803:        B0 08         BCS CODE_04F80D           
CODE_04F805:        BD 25 0E      LDA.W $0E25,X             
CODE_04F808:        F0 03         BEQ CODE_04F80D           
CODE_04F80A:        DE 25 0E      DEC.W $0E25,X             
CODE_04F80D:        E0 05         CPX.B #$05                
CODE_04F80F:        90 08         BCC CODE_04F819           
CODE_04F811:        8E DE 0D      STX.W $0DDE               
CODE_04F814:        20 53 F8      JSR.W CODE_04F853         
CODE_04F817:        80 0C         BRA CODE_04F825           

CODE_04F819:        DA            PHX                       
CODE_04F81A:        BD E0 0D      LDA.W $0DE0,X             
CODE_04F81D:        AA            TAX                       
CODE_04F81E:        8E DE 0D      STX.W $0DDE               
CODE_04F821:        20 53 F8      JSR.W CODE_04F853         
CODE_04F824:        FA            PLX                       
CODE_04F825:        CA            DEX                       
CODE_04F826:        10 D9         BPL CODE_04F801           
Return04F828:       60            RTS                       ; Return 


DATA_04F829:                      .db $7F,$21,$7F,$7F,$7F,$77,$3F,$F7
                                  .db $F7,$00

DATA_04F833:                      .db $00,$52,$31,$19,$45,$2A,$03,$8B
                                  .db $94,$3C,$78,$0D,$36,$5E,$87,$1F
DATA_04F843:                      .db $F4,$F4,$F4,$F4,$F4,$9C,$3C,$48
                                  .db $C8,$CC,$A0,$A4,$D8,$DC,$E0,$E4

CODE_04F853:        20 7C F8      JSR.W CODE_04F87C         
CODE_04F856:        D0 D0         BNE Return04F828          
CODE_04F858:        BD E5 0D      LDA.W $0DE5,X             
CODE_04F85B:        22 DF 86 00   JSL.L ExecutePtr          

OWSprites?:            28 F8      .dw Return04F828          
                       CC F8      .dw ADDR_04F8CC           
                       B8 F9      .dw ADDR_04F9B8           
                       3E FA      .dw CODE_04FA3E           
                       F1 FA      .dw ADDR_04FAF1           
                       37 FB      .dw CODE_04FB37           
                       98 FB      .dw CODE_04FB98           
                       46 FC      .dw CODE_04FC46           
                       E1 FC      .dw CODE_04FCE1           
                       24 FD      .dw CODE_04FD24           
                       70 FD      .dw CODE_04FD70           

DATA_04F875:                      .db $80,$40,$20,$10,$08,$04,$02

CODE_04F87C:        BC E5 0D      LDY.W $0DE5,X             
CODE_04F87F:        B9 28 F8      LDA.W Return04F828,Y      
CODE_04F882:        85 00         STA $00                   
CODE_04F884:        AC D9 13      LDY.W $13D9               
CODE_04F887:        C0 0A         CPY.B #$0A                
CODE_04F889:        D0 07         BNE CODE_04F892           
CODE_04F88B:        AC E8 1D      LDY.W $1DE8               
CODE_04F88E:        C0 01         CPY.B #$01                
CODE_04F890:        D0 11         BNE CODE_04F8A3           
CODE_04F892:        AD D6 0D      LDA.W $0DD6               
CODE_04F895:        4A            LSR                       
CODE_04F896:        4A            LSR                       
CODE_04F897:        A8            TAY                       
CODE_04F898:        B9 11 1F      LDA.W $1F11,Y             
CODE_04F89B:        A8            TAY                       
CODE_04F89C:        B9 75 F8      LDA.W DATA_04F875,Y       
CODE_04F89F:        25 00         AND $00                   
CODE_04F8A1:        F0 02         BEQ Return04F8A5          
CODE_04F8A3:        A9 01         LDA.B #$01                
Return04F8A5:       60            RTS                       ; Return 


DATA_04F8A6:                      .db $01,$01,$03,$01,$01,$01,$01,$02
DATA_04F8AE:                      .db $0C,$0C,$12,$12,$12,$12,$0C,$0C
DATA_04F8B6:                      .db $10,$00,$08,$00,$20,$00,$20,$00
DATA_04F8BE:                      .db $10,$00,$30,$00,$08,$00,$10,$00
DATA_04F8C6:                      .db $01,$FF

DATA_04F8C8:                      .db $10,$F0

DATA_04F8CA:                      .db $10,$F0

ADDR_04F8CC:        20 90 FE      JSR.W CODE_04FE90         
ADDR_04F8CF:        18            CLC                       
ADDR_04F8D0:        20 00 FE      JSR.W ADDR_04FE00         
ADDR_04F8D3:        20 62 FE      JSR.W CODE_04FE62         
ADDR_04F8D6:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_04F8D8:        A5 02         LDA $02                   
ADDR_04F8DA:        85 04         STA $04                   
ADDR_04F8DC:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_04F8DE:        20 5B FE      JSR.W CODE_04FE5B         
ADDR_04F8E1:        A2 06         LDX.B #$06                
ADDR_04F8E3:        29 10         AND.B #$10                
ADDR_04F8E5:        F0 01         BEQ ADDR_04F8E8           
ADDR_04F8E7:        E8            INX                       
ADDR_04F8E8:        86 06         STX $06                   
ADDR_04F8EA:        A5 00         LDA $00                   
ADDR_04F8EC:        18            CLC                       
ADDR_04F8ED:        7D A6 F8      ADC.W DATA_04F8A6,X       
ADDR_04F8F0:        85 00         STA $00                   
ADDR_04F8F2:        90 02         BCC ADDR_04F8F6           
ADDR_04F8F4:        E6 01         INC $01                   
ADDR_04F8F6:        A5 04         LDA $04                   
ADDR_04F8F8:        18            CLC                       
ADDR_04F8F9:        7D AE F8      ADC.W DATA_04F8AE,X       
ADDR_04F8FC:        85 02         STA $02                   
ADDR_04F8FE:        A5 05         LDA $05                   
ADDR_04F900:        69 00         ADC.B #$00                
ADDR_04F902:        85 03         STA $03                   
ADDR_04F904:        A9 32         LDA.B #$32                
ADDR_04F906:        EB            XBA                       
ADDR_04F907:        A9 28         LDA.B #$28                
ADDR_04F909:        20 7B FB      JSR.W CODE_04FB7B         
ADDR_04F90C:        A6 06         LDX $06                   
ADDR_04F90E:        CA            DEX                       
ADDR_04F90F:        CA            DEX                       
ADDR_04F910:        10 D6         BPL ADDR_04F8E8           
ADDR_04F912:        AE DE 0D      LDX.W $0DDE               
ADDR_04F915:        20 62 FE      JSR.W CODE_04FE62         
ADDR_04F918:        A9 32         LDA.B #$32                
ADDR_04F91A:        EB            XBA                       
ADDR_04F91B:        A9 26         LDA.B #$26                
ADDR_04F91D:        20 7A FB      JSR.W CODE_04FB7A         
ADDR_04F920:        BD 15 0E      LDA.W $0E15,X             
ADDR_04F923:        F0 03         BEQ ADDR_04F928           
ADDR_04F925:        4C 2E FF      JMP.W ADDR_04FF2E         

ADDR_04F928:        BD 05 0E      LDA.W $0E05,X             
ADDR_04F92B:        29 01         AND.B #$01                
ADDR_04F92D:        A8            TAY                       
ADDR_04F92E:        BD B5 0E      LDA.W $0EB5,X             
ADDR_04F931:        18            CLC                       
ADDR_04F932:        79 C6 F8      ADC.W DATA_04F8C6,Y       
ADDR_04F935:        9D B5 0E      STA.W $0EB5,X             
ADDR_04F938:        D9 CA F8      CMP.W DATA_04F8CA,Y       
ADDR_04F93B:        D0 08         BNE ADDR_04F945           
ADDR_04F93D:        BD 05 0E      LDA.W $0E05,X             
ADDR_04F940:        49 01         EOR.B #$01                
ADDR_04F942:        9D 05 0E      STA.W $0E05,X             
ADDR_04F945:        20 EF FE      JSR.W ADDR_04FEEF         
ADDR_04F948:        BC F5 0D      LDY.W $0DF5,X             ; Accum (16 bit) 
ADDR_04F94B:        BD 04 0E      LDA.W $0E04,X             
ADDR_04F94E:        0A            ASL                       
ADDR_04F94F:        45 00         EOR $00                   
ADDR_04F951:        10 0A         BPL ADDR_04F95D           
ADDR_04F953:        A5 06         LDA $06                   
ADDR_04F955:        D9 B6 F8      CMP.W DATA_04F8B6,Y       
ADDR_04F958:        A9 40 00      LDA.W #$0040              
ADDR_04F95B:        B0 10         BCS ADDR_04F96D           
ADDR_04F95D:        BD 04 0E      LDA.W $0E04,X             
ADDR_04F960:        45 02         EOR $02                   
ADDR_04F962:        0A            ASL                       
ADDR_04F963:        90 08         BCC ADDR_04F96D           
ADDR_04F965:        A5 08         LDA $08                   
ADDR_04F967:        D9 BE F8      CMP.W DATA_04F8BE,Y       
ADDR_04F96A:        A9 80 00      LDA.W #$0080              
ADDR_04F96D:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_04F96F:        90 0E         BCC ADDR_04F97F           
ADDR_04F971:        5D 05 0E      EOR.W $0E05,X             
ADDR_04F974:        9D 05 0E      STA.W $0E05,X             
ADDR_04F977:        20 5B FE      JSR.W CODE_04FE5B         
ADDR_04F97A:        29 06         AND.B #$06                
ADDR_04F97C:        9D F5 0D      STA.W $0DF5,X             
ADDR_04F97F:        8A            TXA                       
ADDR_04F980:        18            CLC                       
ADDR_04F981:        69 10         ADC.B #$10                
ADDR_04F983:        AA            TAX                       
ADDR_04F984:        BD F5 0D      LDA.W $0DF5,X             
ADDR_04F987:        0A            ASL                       
ADDR_04F988:        20 93 F9      JSR.W ADDR_04F993         
ADDR_04F98B:        AE DE 0D      LDX.W $0DDE               
ADDR_04F98E:        BD 05 0E      LDA.W $0E05,X             
ADDR_04F991:        0A            ASL                       
ADDR_04F992:        0A            ASL                       
ADDR_04F993:        A0 00         LDY.B #$00                
ADDR_04F995:        B0 01         BCS ADDR_04F998           
ADDR_04F997:        C8            INY                       
ADDR_04F998:        BD 95 0E      LDA.W $0E95,X             
ADDR_04F99B:        18            CLC                       
ADDR_04F99C:        79 C6 F8      ADC.W DATA_04F8C6,Y       
ADDR_04F99F:        D9 C8 F8      CMP.W DATA_04F8C8,Y       
ADDR_04F9A2:        F0 03         BEQ Return04F9A7          
ADDR_04F9A4:        9D 95 0E      STA.W $0E95,X             
Return04F9A7:       60            RTS                       ; Return 


DATA_04F9A8:                      .db $4E,$4F,$5E,$4F

DATA_04F9AC:                      .db $08,$07,$04,$07

DATA_04F9B0:                      .db $00,$01,$04,$01

DATA_04F9B4:                      .db $01,$07,$09,$07

ADDR_04F9B8:        18            CLC                       
ADDR_04F9B9:        20 00 FE      JSR.W ADDR_04FE00         
ADDR_04F9BC:        20 EF FE      JSR.W ADDR_04FEEF         
ADDR_04F9BF:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_04F9C1:        A0 00         LDY.B #$00                
ADDR_04F9C3:        A5 01         LDA $01                   
ADDR_04F9C5:        30 01         BMI ADDR_04F9C8           
ADDR_04F9C7:        C8            INY                       
ADDR_04F9C8:        BD 95 0E      LDA.W $0E95,X             
ADDR_04F9CB:        18            CLC                       
ADDR_04F9CC:        79 C6 F8      ADC.W DATA_04F8C6,Y       
ADDR_04F9CF:        D9 C8 F8      CMP.W DATA_04F8C8,Y       
ADDR_04F9D2:        F0 03         BEQ ADDR_04F9D7           
ADDR_04F9D4:        9D 95 0E      STA.W $0E95,X             
ADDR_04F9D7:        AC D6 0D      LDY.W $0DD6               
ADDR_04F9DA:        B9 19 1F      LDA.W $1F19,Y             
ADDR_04F9DD:        9D 45 0E      STA.W $0E45,X             
ADDR_04F9E0:        B9 1A 1F      LDA.W $1F1A,Y             
ADDR_04F9E3:        9D 75 0E      STA.W $0E75,X             
ADDR_04F9E6:        20 90 FE      JSR.W CODE_04FE90         
ADDR_04F9E9:        20 62 FE      JSR.W CODE_04FE62         
ADDR_04F9EC:        A9 36         LDA.B #$36                
ADDR_04F9EE:        BC 95 0E      LDY.W $0E95,X             
ADDR_04F9F1:        30 02         BMI ADDR_04F9F5           
ADDR_04F9F3:        09 40         ORA.B #$40                
ADDR_04F9F5:        48            PHA                       
ADDR_04F9F6:        EB            XBA                       
ADDR_04F9F7:        A9 4C         LDA.B #$4C                
ADDR_04F9F9:        20 7A FB      JSR.W CODE_04FB7A         
ADDR_04F9FC:        68            PLA                       
ADDR_04F9FD:        EB            XBA                       
ADDR_04F9FE:        20 5B FE      JSR.W CODE_04FE5B         
ADDR_04FA01:        4A            LSR                       
ADDR_04FA02:        4A            LSR                       
ADDR_04FA03:        4A            LSR                       
ADDR_04FA04:        29 03         AND.B #$03                
ADDR_04FA06:        A8            TAY                       
ADDR_04FA07:        B9 AC F9      LDA.W DATA_04F9AC,Y       
ADDR_04FA0A:        3C 95 0E      BIT.W $0E95,X             
ADDR_04FA0D:        30 03         BMI ADDR_04FA12           
ADDR_04FA0F:        B9 B0 F9      LDA.W DATA_04F9B0,Y       
ADDR_04FA12:        18            CLC                       
ADDR_04FA13:        65 00         ADC $00                   
ADDR_04FA15:        85 00         STA $00                   
ADDR_04FA17:        90 02         BCC ADDR_04FA1B           
ADDR_04FA19:        E6 01         INC $01                   
ADDR_04FA1B:        B9 B4 F9      LDA.W DATA_04F9B4,Y       
ADDR_04FA1E:        18            CLC                       
ADDR_04FA1F:        65 02         ADC $02                   
ADDR_04FA21:        85 02         STA $02                   
ADDR_04FA23:        90 02         BCC ADDR_04FA27           
ADDR_04FA25:        E6 03         INC $03                   
ADDR_04FA27:        B9 A8 F9      LDA.W DATA_04F9A8,Y       
ADDR_04FA2A:        18            CLC                       
ADDR_04FA2B:        4C 7B FB      JMP.W CODE_04FB7B         


DATA_04FA2E:                      .db $70,$50,$B0

DATA_04FA31:                      .db $00,$01,$00

DATA_04FA34:                      .db $CF,$8F,$7F

DATA_04FA37:                      .db $00,$00,$01

DATA_04FA3A:                      .db $73,$72,$63,$62

CODE_04FA3E:        BD F5 0D      LDA.W $0DF5,X             
CODE_04FA41:        D0 40         BNE CODE_04FA83           
CODE_04FA43:        AD C1 13      LDA.W $13C1               
CODE_04FA46:        38            SEC                       
CODE_04FA47:        E9 4E         SBC.B #$4E                
CODE_04FA49:        C9 03         CMP.B #$03                
CODE_04FA4B:        B0 35         BCS Return04FA82          
CODE_04FA4D:        A8            TAY                       
CODE_04FA4E:        B9 2E FA      LDA.W DATA_04FA2E,Y       
CODE_04FA51:        9D 35 0E      STA.W $0E35,X             
CODE_04FA54:        B9 31 FA      LDA.W DATA_04FA31,Y       
CODE_04FA57:        9D 65 0E      STA.W $0E65,X             
CODE_04FA5A:        B9 34 FA      LDA.W DATA_04FA34,Y       
CODE_04FA5D:        9D 45 0E      STA.W $0E45,X             
CODE_04FA60:        B9 37 FA      LDA.W DATA_04FA37,Y       
CODE_04FA63:        9D 75 0E      STA.W $0E75,X             
CODE_04FA66:        20 5B FE      JSR.W CODE_04FE5B         
CODE_04FA69:        4A            LSR                       
CODE_04FA6A:        6A            ROR                       
CODE_04FA6B:        4A            LSR                       
CODE_04FA6C:        29 40         AND.B #$40                
CODE_04FA6E:        09 12         ORA.B #$12                
CODE_04FA70:        9D F5 0D      STA.W $0DF5,X             
CODE_04FA73:        A9 24         LDA.B #$24                
CODE_04FA75:        9D B5 0E      STA.W $0EB5,X             
CODE_04FA78:        A9 0E         LDA.B #$0E                
CODE_04FA7A:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_04FA7D:        A9 0F         LDA.B #$0F                
CODE_04FA7F:        9D 25 0E      STA.W $0E25,X             
Return04FA82:       60            RTS                       ; Return 

CODE_04FA83:        DE B5 0E      DEC.W $0EB5,X             
CODE_04FA86:        BD B5 0E      LDA.W $0EB5,X             
CODE_04FA89:        C9 E4         CMP.B #$E4                
CODE_04FA8B:        D0 03         BNE CODE_04FA90           
CODE_04FA8D:        20 7D FA      JSR.W CODE_04FA7D         
CODE_04FA90:        20 90 FE      JSR.W CODE_04FE90         
CODE_04FA93:        BD 55 0E      LDA.W $0E55,X             
CODE_04FA96:        1D 25 0E      ORA.W $0E25,X             
CODE_04FA99:        D0 03         BNE CODE_04FA9E           
CODE_04FA9B:        9E F5 0D      STZ.W $0DF5,X             
CODE_04FA9E:        20 62 FE      JSR.W CODE_04FE62         
CODE_04FAA1:        BD F5 0D      LDA.W $0DF5,X             
CODE_04FAA4:        A0 08         LDY.B #$08                
CODE_04FAA6:        3C B5 0E      BIT.W $0EB5,X             
CODE_04FAA9:        10 04         BPL CODE_04FAAF           
CODE_04FAAB:        49 C0         EOR.B #$C0                
CODE_04FAAD:        A0 10         LDY.B #$10                
CODE_04FAAF:        EB            XBA                       
CODE_04FAB0:        98            TYA                       
CODE_04FAB1:        A0 4A         LDY.B #$4A                
CODE_04FAB3:        25 13         AND RAM_FrameCounter      
CODE_04FAB5:        F0 02         BEQ CODE_04FAB9           
CODE_04FAB7:        A0 48         LDY.B #$48                
CODE_04FAB9:        98            TYA                       
CODE_04FABA:        20 06 FB      JSR.W CODE_04FB06         
CODE_04FABD:        20 4E FE      JSR.W CODE_04FE4E         
CODE_04FAC0:        38            SEC                       
CODE_04FAC1:        E9 08         SBC.B #$08                
CODE_04FAC3:        85 02         STA $02                   
CODE_04FAC5:        B0 02         BCS CODE_04FAC9           
ADDR_04FAC7:        C6 03         DEC $03                   
CODE_04FAC9:        A9 36         LDA.B #$36                
CODE_04FACB:        EB            XBA                       
CODE_04FACC:        BD 25 0E      LDA.W $0E25,X             
CODE_04FACF:        F0 B1         BEQ Return04FA82          
CODE_04FAD1:        4A            LSR                       
CODE_04FAD2:        4A            LSR                       
CODE_04FAD3:        5A            PHY                       
CODE_04FAD4:        A8            TAY                       
CODE_04FAD5:        B9 3A FA      LDA.W DATA_04FA3A,Y       
CODE_04FAD8:        7A            PLY                       
CODE_04FAD9:        48            PHA                       
CODE_04FADA:        20 ED FA      JSR.W CODE_04FAED         
CODE_04FADD:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04FADF:        A5 00         LDA $00                   
CODE_04FAE1:        18            CLC                       
CODE_04FAE2:        69 08 00      ADC.W #$0008              
CODE_04FAE5:        85 00         STA $00                   
CODE_04FAE7:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04FAE9:        A9 76         LDA.B #$76                
CODE_04FAEB:        EB            XBA                       
CODE_04FAEC:        68            PLA                       
CODE_04FAED:        18            CLC                       
CODE_04FAEE:        4C 0A FB      JMP.W CODE_04FB0A         

ADDR_04FAF1:        20 D7 FE      JSR.W ADDR_04FED7         
ADDR_04FAF4:        20 62 FE      JSR.W CODE_04FE62         ; NOP this and the sprite doesn't appear
ADDR_04FAF7:        20 5B FE      JSR.W CODE_04FE5B        ; NOP this and the sprite stops animating.
ADDR_04FAFA:        A0 2A         LDY.B #$2A                ;Tile for pirahna plant, #1
ADDR_04FAFC:        29 08         AND.B #$08                
ADDR_04FAFE:        F0 02         BEQ ADDR_04FB02           
ADDR_04FB00:        A0 2C         LDY.B #$2C               ; Tile for pirahna plant, #2, stored in $0242
ADDR_04FB02:        A9 32         LDA.B #$32                ; YXPPCCCT - 00110010
ADDR_04FB04:        EB            XBA                       
ADDR_04FB05:        98            TYA                       
CODE_04FB06:        38            SEC                       
CODE_04FB07:        BC 43 F8      LDY.W DATA_04F843,X       
CODE_04FB0A:        99 42 02      STA.W $0242,Y             ;Tilemap
CODE_04FB0D:        EB            XBA                       
CODE_04FB0E:        99 43 02      STA.W $0243,Y             ;Property
CODE_04FB11:        A5 01         LDA $01                   
CODE_04FB13:        D0 21         BNE Return04FB36          
CODE_04FB15:        A5 00         LDA $00                   
CODE_04FB17:        99 40 02      STA.W $0240,Y             ;X Position
CODE_04FB1A:        A5 03         LDA $03                   
CODE_04FB1C:        D0 18         BNE Return04FB36          
CODE_04FB1E:        08            PHP                       
CODE_04FB1F:        A5 02         LDA $02                   
CODE_04FB21:        99 41 02      STA.W $0241,Y             ;Y Position
CODE_04FB24:        98            TYA                       
CODE_04FB25:        4A            LSR                       
CODE_04FB26:        4A            LSR                       
CODE_04FB27:        28            PLP                       
CODE_04FB28:        5A            PHY                       
CODE_04FB29:        A8            TAY                       
CODE_04FB2A:        2A            ROL                       
CODE_04FB2B:        0A            ASL                       
CODE_04FB2C:        29 03         AND.B #$03                
CODE_04FB2E:        99 30 04      STA.W $0430,Y             
CODE_04FB31:        7A            PLY 
CODE_04FB32:        88            DEY
CODE_04FB33:        88            DEY 
CODE_04FB34:        88            DEY 
CODE_04FB35:        88            DEY
Return04FB36:       60            RTS                       ; Return 

CODE_04FB37:        A9 02         LDA.B #$02                ;\Overworld Sprite X Speed
CODE_04FB39:        9D 95 0E      STA.W $0E95,X             ;/
CODE_04FB3C:        A9 FF         LDA.B #$FF                ;\Overworld Sprite Y Speed
CODE_04FB3E:        9D A5 0E      STA.W $0EA5,X             ;/
CODE_04FB41:        20 90 FE      JSR.W CODE_04FE90         ;Move the overworld cloud
CODE_04FB44:        20 62 FE      JSR.W CODE_04FE62         
CODE_04FB47:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04FB49:        A5 00         LDA $00                   
CODE_04FB4B:        18            CLC                       
CODE_04FB4C:        69 20 00      ADC.W #$0020              
CODE_04FB4F:        C9 40 01      CMP.W #$0140              
CODE_04FB52:        B0 09         BCS CODE_04FB5D           
CODE_04FB54:        A5 02         LDA $02                   
CODE_04FB56:        18            CLC                       
CODE_04FB57:        69 80 00      ADC.W #$0080              
CODE_04FB5A:        C9 A0 01      CMP.W #$01A0              
CODE_04FB5D:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04FB5F:        90 03         BCC CODE_04FB64           
CODE_04FB61:        9E E5 0D      STZ.W $0DE5,X             
CODE_04FB64:        A9 32         LDA.B #$32                
CODE_04FB66:        20 77 FB      JSR.W CODE_04FB77         
CODE_04FB69:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04FB6B:        A5 00         LDA $00                   
CODE_04FB6D:        18            CLC                       
CODE_04FB6E:        69 10 00      ADC.W #$0010              
CODE_04FB71:        85 00         STA $00                   
CODE_04FB73:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04FB75:        A9 72         LDA.B #$72                
CODE_04FB77:        EB            XBA                       
CODE_04FB78:        A9 44         LDA.B #$44                
CODE_04FB7A:        38            SEC                       
CODE_04FB7B:        AC DF 0D      LDY.W $0DDF               
CODE_04FB7E:        20 0A FB      JSR.W CODE_04FB0A         
CODE_04FB81:        8C DF 0D      STY.W $0DDF               
Return04FB84:       60            RTS                       ; Return 


DATA_04FB85:                      .db $80,$40,$20

DATA_04FB88:                      .db $30,$10,$C0

DATA_04FB8B:                      .db $01,$01,$01

DATA_04FB8E:                      .db $7F,$7F,$8F

DATA_04FB91:                      .db $01,$00

DATA_04FB93:                      .db $01,$08

DATA_04FB95:                      .db $02,$0F,$00

CODE_04FB98:        BD F5 0D      LDA.W $0DF5,X             
CODE_04FB9B:        D0 3B         BNE ADDR_04FBD8           
CODE_04FB9D:        AD C1 13      LDA.W $13C1               
CODE_04FBA0:        38            SEC                       
CODE_04FBA1:        E9 49         SBC.B #$49                
CODE_04FBA3:        C9 03         CMP.B #$03                
CODE_04FBA5:        B0 DD         BCS Return04FB84          
ADDR_04FBA7:        A8            TAY                       
ADDR_04FBA8:        8D F6 0E      STA.W $0EF6               
ADDR_04FBAB:        AD F5 0E      LDA.W $0EF5               
ADDR_04FBAE:        39 85 FB      AND.W DATA_04FB85,Y       
ADDR_04FBB1:        D0 D1         BNE Return04FB84          
ADDR_04FBB3:        B9 88 FB      LDA.W DATA_04FB88,Y       
ADDR_04FBB6:        9D 35 0E      STA.W $0E35,X             
ADDR_04FBB9:        B9 8B FB      LDA.W DATA_04FB8B,Y       
ADDR_04FBBC:        9D 65 0E      STA.W $0E65,X             
ADDR_04FBBF:        B9 8E FB      LDA.W DATA_04FB8E,Y       
ADDR_04FBC2:        9D 45 0E      STA.W $0E45,X             
ADDR_04FBC5:        B9 91 FB      LDA.W DATA_04FB91,Y       
ADDR_04FBC8:        9D 75 0E      STA.W $0E75,X             
ADDR_04FBCB:        A9 02         LDA.B #$02                
ADDR_04FBCD:        9D F5 0D      STA.W $0DF5,X             
ADDR_04FBD0:        A9 F0         LDA.B #$F0                
ADDR_04FBD2:        9D 95 0E      STA.W $0E95,X             
ADDR_04FBD5:        9E 25 0E      STZ.W $0E25,X             
ADDR_04FBD8:        20 62 FE      JSR.W CODE_04FE62         
ADDR_04FBDB:        BD 25 0E      LDA.W $0E25,X             
ADDR_04FBDE:        D0 20         BNE ADDR_04FC00           
ADDR_04FBE0:        FE 05 0E      INC.W $0E05,X             
ADDR_04FBE3:        20 AB FE      JSR.W CODE_04FEAB         
ADDR_04FBE6:        BC F5 0D      LDY.W $0DF5,X             
ADDR_04FBE9:        BD 35 0E      LDA.W $0E35,X             
ADDR_04FBEC:        29 0F         AND.B #$0F                
ADDR_04FBEE:        D9 95 FB      CMP.W DATA_04FB95,Y       
ADDR_04FBF1:        D0 0D         BNE ADDR_04FC00           
ADDR_04FBF3:        DE F5 0D      DEC.W $0DF5,X             
ADDR_04FBF6:        A9 04         LDA.B #$04                
ADDR_04FBF8:        9D 95 0E      STA.W $0E95,X             
ADDR_04FBFB:        A9 60         LDA.B #$60                
ADDR_04FBFD:        9D 25 0E      STA.W $0E25,X             
ADDR_04FC00:        B9 93 FB      LDA.W DATA_04FB93,Y       
ADDR_04FC03:        A0 22         LDY.B #$22                
ADDR_04FC05:        3D 05 0E      AND.W $0E05,X             
ADDR_04FC08:        D0 02         BNE ADDR_04FC0C           
ADDR_04FC0A:        A0 62         LDY.B #$62                
ADDR_04FC0C:        98            TYA                       
ADDR_04FC0D:        EB            XBA                       
ADDR_04FC0E:        A9 6A         LDA.B #$6A                
ADDR_04FC10:        20 06 FB      JSR.W CODE_04FB06         
ADDR_04FC13:        20 D7 FE      JSR.W ADDR_04FED7         
ADDR_04FC16:        B0 05         BCS Return04FC1D          
ADDR_04FC18:        09 80         ORA.B #$80                
ADDR_04FC1A:        8D F7 0E      STA.W $0EF7               
Return04FC1D:       60            RTS                       ; Return 


DATA_04FC1E:                      .db $38

DATA_04FC1F:                      .db $00,$68,$00

DATA_04FC22:                      .db $8A

DATA_04FC23:                      .db $01,$6A,$00

DATA_04FC26:                      .db $01,$02,$03,$04,$03,$02,$01,$00
                                  .db $01,$02,$03,$04,$03,$02,$01,$00
DATA_04FC36:                      .db $FF,$FF,$FE,$FD,$FD,$FC,$FB,$FB
                                  .db $FA,$F9,$F9,$F8,$F7,$F7,$F6,$F5

CODE_04FC46:        AD D6 0D      LDA.W $0DD6               
CODE_04FC49:        4A            LSR                       
CODE_04FC4A:        4A            LSR                       
CODE_04FC4B:        A8            TAY                       
CODE_04FC4C:        B9 11 1F      LDA.W $1F11,Y             
CODE_04FC4F:        0A            ASL                       
CODE_04FC50:        A8            TAY                       
CODE_04FC51:        B9 1E FC      LDA.W DATA_04FC1E,Y       
CODE_04FC54:        9D 35 0E      STA.W $0E35,X             
CODE_04FC57:        B9 1F FC      LDA.W DATA_04FC1F,Y       
CODE_04FC5A:        9D 65 0E      STA.W $0E65,X             
CODE_04FC5D:        B9 22 FC      LDA.W DATA_04FC22,Y       
CODE_04FC60:        9D 45 0E      STA.W $0E45,X             
CODE_04FC63:        B9 23 FC      LDA.W DATA_04FC23,Y       
CODE_04FC66:        9D 75 0E      STA.W $0E75,X             
CODE_04FC69:        A5 13         LDA RAM_FrameCounter      
CODE_04FC6B:        29 0F         AND.B #$0F                
CODE_04FC6D:        D0 0D         BNE CODE_04FC7C           
CODE_04FC6F:        BD F5 0D      LDA.W $0DF5,X             
CODE_04FC72:        1A            INC A                     
CODE_04FC73:        C9 0C         CMP.B #$0C                
CODE_04FC75:        90 02         BCC CODE_04FC79           
CODE_04FC77:        A9 00         LDA.B #$00                
CODE_04FC79:        9D F5 0D      STA.W $0DF5,X             
CODE_04FC7C:        A9 03         LDA.B #$03                
CODE_04FC7E:        85 04         STA $04                   
CODE_04FC80:        A5 13         LDA RAM_FrameCounter      
CODE_04FC82:        85 06         STA $06                   
CODE_04FC84:        64 07         STZ $07                   
CODE_04FC86:        BC 43 F8      LDY.W DATA_04F843,X       
CODE_04FC89:        BD F5 0D      LDA.W $0DF5,X             
CODE_04FC8C:        AA            TAX                       
CODE_04FC8D:        5A            PHY                       
CODE_04FC8E:        DA            PHX                       
CODE_04FC8F:        AE DE 0D      LDX.W $0DDE               
CODE_04FC92:        20 62 FE      JSR.W CODE_04FE62         
CODE_04FC95:        FA            PLX                       
CODE_04FC96:        A5 07         LDA $07                   
CODE_04FC98:        18            CLC                       
CODE_04FC99:        7D 36 FC      ADC.W DATA_04FC36,X       
CODE_04FC9C:        18            CLC                       
CODE_04FC9D:        65 02         ADC $02                   
CODE_04FC9F:        85 02         STA $02                   
CODE_04FCA1:        B0 02         BCS CODE_04FCA5           
CODE_04FCA3:        C6 03         DEC $03                   
CODE_04FCA5:        A5 00         LDA $00                   
CODE_04FCA7:        18            CLC                       
CODE_04FCA8:        7D 26 FC      ADC.W DATA_04FC26,X       
CODE_04FCAB:        85 00         STA $00                   
CODE_04FCAD:        90 02         BCC CODE_04FCB1           
CODE_04FCAF:        E6 01         INC $01                   
CODE_04FCB1:        8A            TXA                       
CODE_04FCB2:        18            CLC                       
CODE_04FCB3:        69 0C         ADC.B #$0C                
CODE_04FCB5:        C9 10         CMP.B #$10                
CODE_04FCB7:        29 0F         AND.B #$0F                
CODE_04FCB9:        AA            TAX                       
CODE_04FCBA:        90 06         BCC CODE_04FCC2           
CODE_04FCBC:        A5 07         LDA $07                   
CODE_04FCBE:        E9 0C         SBC.B #$0C                
CODE_04FCC0:        85 07         STA $07                   
CODE_04FCC2:        A9 30         LDA.B #$30                
CODE_04FCC4:        EB            XBA                       
CODE_04FCC5:        A0 28         LDY.B #$28                
CODE_04FCC7:        A5 06         LDA $06                   
CODE_04FCC9:        18            CLC                       
CODE_04FCCA:        69 0A         ADC.B #$0A                
CODE_04FCCC:        85 06         STA $06                   
CODE_04FCCE:        29 20         AND.B #$20                
CODE_04FCD0:        F0 02         BEQ CODE_04FCD4           
CODE_04FCD2:        A0 5F         LDY.B #$5F                
CODE_04FCD4:        98            TYA                       
CODE_04FCD5:        7A            PLY                       
CODE_04FCD6:        20 ED FA      JSR.W CODE_04FAED         
CODE_04FCD9:        C6 04         DEC $04                   
CODE_04FCDB:        D0 B0         BNE CODE_04FC8D           
CODE_04FCDD:        AE DE 0D      LDX.W $0DDE               
Return04FCE0:       60            RTS                       ; Return 


;Bowser's sign code starts here.
CODE_04FCE1:        20 62 FE      JSR.W CODE_04FE62         
CODE_04FCE4:        A9 04         LDA.B #$04                ;\How many tiles to show up for Bowser's sign
CODE_04FCE6:        85 04         STA $04                      ;/            
CODE_04FCE8:        A9 6F         LDA.B #$6F                ;
CODE_04FCEA:        85 05         STA $05                      ; 
CODE_04FCEC:        BC 43 F8      LDY.W DATA_04F843,X       
CODE_04FCEF:        A5 13         LDA RAM_FrameCounter      
CODE_04FCF1:        4A            LSR                       
CODE_04FCF2:        29 06         AND.B #$06                
CODE_04FCF4:        09 30         ORA.B #$30                
CODE_04FCF6:        EB            XBA                       
CODE_04FCF7:        A5 05         LDA $05                   
CODE_04FCF9:        20 ED FA      JSR.W CODE_04FAED         ;Jump to CLC, then the OAM part of the Pirahna Plant code.
CODE_04FCFC:        A5 00         LDA $00                   
CODE_04FCFE:        38            SEC                       
CODE_04FCFF:        E9 08         SBC.B #$08                
CODE_04FD01:        85 00         STA $00                   
CODE_04FD03:        C6 05         DEC $05                   
CODE_04FD05:        C6 04         DEC $04
CODE_04FD07:        D0 E6         BNE CODE_04FCEF           
Return04FD09:       60            RTS                       ; Return 


DATA_04FD0A:                      .db $07,$07,$03,$03,$5F,$5F

DATA_04FD10:                      .db $01,$FF,$01,$FF,$01,$FF,$01,$FF
                                  .db $01,$FF

DATA_04FD1A:                      .db $18,$E8,$0A,$F6,$08,$F8,$03,$FD
DATA_04FD22:                      .db $01,$FF

CODE_04FD24:        20 90 FE      JSR.W CODE_04FE90         
CODE_04FD27:        20 62 FE      JSR.W CODE_04FE62         
CODE_04FD2A:        20 62 FE      JSR.W CODE_04FE62         
CODE_04FD2D:        A9 00         LDA.B #$00                
CODE_04FD2F:        BC 95 0E      LDY.W $0E95,X             
CODE_04FD32:        30 02         BMI CODE_04FD36           
CODE_04FD34:        A9 40         LDA.B #$40                
CODE_04FD36:        EB            XBA                       
CODE_04FD37:        A9 68         LDA.B #$68                
CODE_04FD39:        20 06 FB      JSR.W CODE_04FB06         
CODE_04FD3C:        FE 15 0E      INC.W $0E15,X             
CODE_04FD3F:        BD 15 0E      LDA.W $0E15,X             
CODE_04FD42:        4A            LSR                       
CODE_04FD43:        B0 2A         BCS Return04FD6F          
CODE_04FD45:        BD 05 0E      LDA.W $0E05,X             
CODE_04FD48:        09 02         ORA.B #$02                
CODE_04FD4A:        A8            TAY                       
CODE_04FD4B:        8A            TXA                       
CODE_04FD4C:        69 10         ADC.B #$10                
CODE_04FD4E:        AA            TAX                       
CODE_04FD4F:        20 55 FD      JSR.W CODE_04FD55         
CODE_04FD52:        BC F5 0D      LDY.W $0DF5,X             
CODE_04FD55:        BD 95 0E      LDA.W $0E95,X             
CODE_04FD58:        18            CLC                       
CODE_04FD59:        79 10 FD      ADC.W DATA_04FD10,Y       
CODE_04FD5C:        9D 95 0E      STA.W $0E95,X             
CODE_04FD5F:        D9 1A FD      CMP.W DATA_04FD1A,Y       
CODE_04FD62:        D0 04         BNE CODE_04FD68           
CODE_04FD64:        98            TYA                       
CODE_04FD65:        49 01         EOR.B #$01                
CODE_04FD67:        A8            TAY                       
CODE_04FD68:        98            TYA                       
CODE_04FD69:        9D F5 0D      STA.W $0DF5,X             
CODE_04FD6C:        AE DE 0D      LDX.W $0DDE               
Return04FD6F:       60            RTS                       ; Return 

CODE_04FD70:        20 90 FE      JSR.W CODE_04FE90         
CODE_04FD73:        20 62 FE      JSR.W CODE_04FE62         
CODE_04FD76:        20 62 FE      JSR.W CODE_04FE62         
CODE_04FD79:        AC B3 0D      LDY.W $0DB3               
CODE_04FD7C:        B9 11 1F      LDA.W $1F11,Y             
CODE_04FD7F:        F0 24         BEQ CODE_04FDA5           
CODE_04FD81:        E0 0F         CPX.B #$0F                
CODE_04FD83:        D0 09         BNE CODE_04FD8E           
CODE_04FD85:        AD 07 1F      LDA.W $1F07               
CODE_04FD88:        29 12         AND.B #$12                
CODE_04FD8A:        D0 02         BNE CODE_04FD8E           
CODE_04FD8C:        86 03         STX $03                   
CODE_04FD8E:        8A            TXA                       
CODE_04FD8F:        0A            ASL                       
CODE_04FD90:        A8            TAY                       
CODE_04FD91:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04FD93:        A5 00         LDA $00                   
CODE_04FD95:        18            CLC                       
CODE_04FD96:        79 4C F6      ADC.W DATA_04F64C,Y       
CODE_04FD99:        85 00         STA $00                   
CODE_04FD9B:        A5 02         LDA $02                   
CODE_04FD9D:        18            CLC                       
CODE_04FD9E:        79 52 F6      ADC.W DATA_04F652,Y       
CODE_04FDA1:        85 02         STA $02                   
CODE_04FDA3:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_04FDA5:        A9 34         LDA.B #$34                
CODE_04FDA7:        BC 95 0E      LDY.W $0E95,X             
CODE_04FDAA:        30 02         BMI CODE_04FDAE           
CODE_04FDAC:        A9 44         LDA.B #$44                
CODE_04FDAE:        EB            XBA                       
CODE_04FDAF:        A9 60         LDA.B #$60                
CODE_04FDB1:        20 06 FB      JSR.W CODE_04FB06         
CODE_04FDB4:        BD 25 0E      LDA.W $0E25,X             
CODE_04FDB7:        85 00         STA $00                   
CODE_04FDB9:        FE 25 0E      INC.W $0E25,X             
CODE_04FDBC:        8A            TXA                       
CODE_04FDBD:        18            CLC                       
CODE_04FDBE:        69 20         ADC.B #$20                
CODE_04FDC0:        AA            TAX                       
CODE_04FDC1:        A9 08         LDA.B #$08                
CODE_04FDC3:        20 D2 FD      JSR.W CODE_04FDD2         
CODE_04FDC6:        8A            TXA                       
CODE_04FDC7:        18            CLC                       
CODE_04FDC8:        69 10         ADC.B #$10                
CODE_04FDCA:        AA            TAX                       
CODE_04FDCB:        A9 06         LDA.B #$06                
CODE_04FDCD:        20 D2 FD      JSR.W CODE_04FDD2         
CODE_04FDD0:        A9 04         LDA.B #$04                
CODE_04FDD2:        1D F5 0D      ORA.W $0DF5,X             
CODE_04FDD5:        A8            TAY                       
CODE_04FDD6:        B9 06 FD      LDA.W ADDR_04FD06,Y       
CODE_04FDD9:        25 00         AND $00                   
CODE_04FDDB:        D0 8B         BNE CODE_04FD68           
CODE_04FDDD:        4C 55 FD      JMP.W CODE_04FD55         


DATA_04FDE0:                      .db $00,$00,$00,$00,$01,$02,$02,$02
                                  .db $00,$00,$01,$01,$02,$02,$03,$03
DATA_04FDF0:                      .db $08,$08,$08,$08,$07,$06,$05,$05
                                  .db $00,$00,$0E,$0E,$0C,$0C,$0A,$0A

ADDR_04FE00:        66 04         ROR $04                   
ADDR_04FE02:        20 62 FE      JSR.W CODE_04FE62         
ADDR_04FE05:        20 4E FE      JSR.W CODE_04FE4E         
ADDR_04FE08:        BD 55 0E      LDA.W $0E55,X             
ADDR_04FE0B:        4A            LSR                       
ADDR_04FE0C:        4A            LSR                       
ADDR_04FE0D:        4A            LSR                       
ADDR_04FE0E:        4A            LSR                       
ADDR_04FE0F:        A0 29         LDY.B #$29                
ADDR_04FE11:        24 04         BIT $04                   
ADDR_04FE13:        10 05         BPL ADDR_04FE1A           
ADDR_04FE15:        A0 2E         LDY.B #$2E                
ADDR_04FE17:        18            CLC                       
ADDR_04FE18:        69 08         ADC.B #$08                
ADDR_04FE1A:        84 05         STY $05                   
ADDR_04FE1C:        A8            TAY                       
ADDR_04FE1D:        84 06         STY $06                   
ADDR_04FE1F:        A5 00         LDA $00                   
ADDR_04FE21:        18            CLC                       
ADDR_04FE22:        79 E0 FD      ADC.W DATA_04FDE0,Y       
ADDR_04FE25:        85 00         STA $00                   
ADDR_04FE27:        90 02         BCC ADDR_04FE2B           
ADDR_04FE29:        E6 01         INC $01                   
ADDR_04FE2B:        A9 32         LDA.B #$32                
ADDR_04FE2D:        BC 43 F8      LDY.W DATA_04F843,X       
ADDR_04FE30:        20 45 FE      JSR.W ADDR_04FE45         
ADDR_04FE33:        5A            PHY                       
ADDR_04FE34:        A4 06         LDY $06                   
ADDR_04FE36:        A5 00         LDA $00                   
ADDR_04FE38:        18            CLC                       
ADDR_04FE39:        79 F0 FD      ADC.W DATA_04FDF0,Y       
ADDR_04FE3C:        85 00         STA $00                   
ADDR_04FE3E:        90 02         BCC ADDR_04FE42           
ADDR_04FE40:        E6 01         INC $01                   
ADDR_04FE42:        A9 72         LDA.B #$72                
ADDR_04FE44:        7A            PLY                       
ADDR_04FE45:        EB            XBA                       
ADDR_04FE46:        A5 04         LDA $04                   
ADDR_04FE48:        0A            ASL                       
ADDR_04FE49:        A5 05         LDA $05                   
ADDR_04FE4B:        4C 0A FB      JMP.W CODE_04FB0A         

CODE_04FE4E:        A5 02         LDA $02                   
CODE_04FE50:        18            CLC                       
CODE_04FE51:        7D 55 0E      ADC.W $0E55,X             
CODE_04FE54:        85 02         STA $02                   
CODE_04FE56:        90 02         BCC Return04FE5A          
ADDR_04FE58:        E6 03         INC $03                   
Return04FE5A:       60            RTS                       ; Return 

CODE_04FE5B:        A5 13         LDA RAM_FrameCounter      
CODE_04FE5D:        18            CLC                       
CODE_04FE5E:        7D 33 F8      ADC.W DATA_04F833,X       
Return04FE61:       60            RTS                       ; Return 

CODE_04FE62:        8A            TXA                       
CODE_04FE63:        18            CLC                       
CODE_04FE64:        69 10         ADC.B #$10                
CODE_04FE66:        AA            TAX                       
CODE_04FE67:        A0 02         LDY.B #$02                
CODE_04FE69:        20 7D FE      JSR.W CODE_04FE7D         
CODE_04FE6C:        AE DE 0D      LDX.W $0DDE               
CODE_04FE6F:        A5 02         LDA $02                   
CODE_04FE71:        38            SEC                       
CODE_04FE72:        FD 55 0E      SBC.W $0E55,X             
CODE_04FE75:        85 02         STA $02                   
CODE_04FE77:        B0 02         BCS CODE_04FE7B           
CODE_04FE79:        C6 03         DEC $03                   
CODE_04FE7B:        A0 00         LDY.B #$00                
CODE_04FE7D:        BD 65 0E      LDA.W $0E65,X             
CODE_04FE80:        EB            XBA                       
CODE_04FE81:        BD 35 0E      LDA.W $0E35,X             
CODE_04FE84:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_04FE86:        38            SEC                       
CODE_04FE87:        F9 1A 00      SBC.W RAM_ScreenBndryXLo,Y 
CODE_04FE8A:        99 00 00      STA.W $0000,Y             
CODE_04FE8D:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return04FE8F:       60            RTS                       ; Return 

CODE_04FE90:        8A            TXA                       ;Transfer X to A
CODE_04FE91:        18            CLC                       ;Clear Carry Flag
CODE_04FE92:        69 20         ADC.B #$20                ;Add #$20 to A
CODE_04FE94:        AA            TAX                       ;Transfer A to X
CODE_04FE95:        20 AB FE      JSR.W CODE_04FEAB         
CODE_04FE98:        BD 35 0E      LDA.W $0E35,X             ;Load OW Sprite XPos Low
CODE_04FE9B:        10 03         BPL CODE_04FEA0           ;If it is => 80
CODE_04FE9D:        9E 35 0E      STZ.W $0E35,X             ;Store 00 OW Sprite Xpos Low
CODE_04FEA0:        8A            TXA                       ;Transfer X to A
CODE_04FEA1:        38            SEC                       ;Set Carry Flag...
CODE_04FEA2:        E9 10         SBC.B #$10                ;...for substraction
CODE_04FEA4:        AA            TAX                       ;Transfer A to X
CODE_04FEA5:        20 AB FE      JSR.W CODE_04FEAB         ;
CODE_04FEA8:        AE DE 0D      LDX.W $0DDE               ;
CODE_04FEAB:        BD 95 0E      LDA.W $0E95,X             ;Load OW Sprite X Speed
CODE_04FEAE:        0A            ASL                       ;Multiply it by 2
CODE_04FEAF:        0A            ASL                       ;4...
CODE_04FEB0:        0A            ASL                       ;8...
CODE_04FEB1:        0A            ASL                       ;16...
CODE_04FEB2:        18            CLC                       ;Clear Carry Flag
CODE_04FEB3:        7D C5 0E      ADC.W $0EC5,X             ;
CODE_04FEB6:        9D C5 0E      STA.W $0EC5,X             ;And store it in
CODE_04FEB9:        BD 95 0E      LDA.W $0E95,X             ;Load OW Sprite X Speed
CODE_04FEBC:        08            PHP                       ;
CODE_04FEBD:        4A            LSR                       ;Divide by 2
CODE_04FEBE:        4A            LSR                       ;4
CODE_04FEBF:        4A            LSR                       ;8
CODE_04FEC0:        4A            LSR                       ;16
CODE_04FEC1:        A0 00         LDY.B #$00                ;Load $00 in Y
CODE_04FEC3:        28            PLP                       ;
CODE_04FEC4:        10 03         BPL CODE_04FEC9           
CODE_04FEC6:        09 F0         ORA.B #$F0                
CODE_04FEC8:        88            DEY                       
CODE_04FEC9:        7D 35 0E      ADC.W $0E35,X             
CODE_04FECC:        9D 35 0E      STA.W $0E35,X             
CODE_04FECF:        98            TYA                       
CODE_04FED0:        7D 65 0E      ADC.W $0E65,X             
CODE_04FED3:        9D 65 0E      STA.W $0E65,X             
Return04FED6:       60            RTS                       ; Return 

ADDR_04FED7:        20 EF FE      JSR.W ADDR_04FEEF         ; Accum (16 bit) 
ADDR_04FEDA:        A5 06         LDA $06                   
ADDR_04FEDC:        C9 08 00      CMP.W #$0008              
ADDR_04FEDF:        B0 05         BCS ADDR_04FEE6           
ADDR_04FEE1:        A5 08         LDA $08                   
ADDR_04FEE3:        C9 08 00      CMP.W #$0008              
ADDR_04FEE6:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_04FEE8:        8A            TXA                       
ADDR_04FEE9:        B0 03         BCS Return04FEEE          
ADDR_04FEEB:        8D F7 0E      STA.W $0EF7               
Return04FEEE:       60            RTS                       ; Return 

ADDR_04FEEF:        BD 65 0E      LDA.W $0E65,X             
ADDR_04FEF2:        EB            XBA                       
ADDR_04FEF3:        BD 35 0E      LDA.W $0E35,X             
ADDR_04FEF6:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_04FEF8:        18            CLC                       
ADDR_04FEF9:        69 08 00      ADC.W #$0008              
ADDR_04FEFC:        AC D6 0D      LDY.W $0DD6               
ADDR_04FEFF:        38            SEC                       
ADDR_04FF00:        F9 17 1F      SBC.W $1F17,Y             
ADDR_04FF03:        85 00         STA $00                   
ADDR_04FF05:        10 04         BPL ADDR_04FF0B           
ADDR_04FF07:        49 FF FF      EOR.W #$FFFF              
ADDR_04FF0A:        1A            INC A                     
ADDR_04FF0B:        85 06         STA $06                   
ADDR_04FF0D:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_04FF0F:        BD 75 0E      LDA.W $0E75,X             
ADDR_04FF12:        EB            XBA                       
ADDR_04FF13:        BD 45 0E      LDA.W $0E45,X             
ADDR_04FF16:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_04FF18:        18            CLC                       
ADDR_04FF19:        69 08 00      ADC.W #$0008              
ADDR_04FF1C:        AC D6 0D      LDY.W $0DD6               
ADDR_04FF1F:        38            SEC                       
ADDR_04FF20:        F9 19 1F      SBC.W $1F19,Y             
ADDR_04FF23:        85 02         STA $02                   
ADDR_04FF25:        10 04         BPL ADDR_04FF2B           
ADDR_04FF27:        49 FF FF      EOR.W #$FFFF              
ADDR_04FF2A:        1A            INC A                     
ADDR_04FF2B:        85 08         STA $08                   
Return04FF2D:       60            RTS                       ; Return 

ADDR_04FF2E:        20 EF FE      JSR.W ADDR_04FEEF         
ADDR_04FF31:        46 06         LSR $06                   
ADDR_04FF33:        46 08         LSR $08                   
ADDR_04FF35:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_04FF37:        BD 55 0E      LDA.W $0E55,X             
ADDR_04FF3A:        4A            LSR                       
ADDR_04FF3B:        85 0A         STA $0A                   
ADDR_04FF3D:        64 05         STZ $05                   
ADDR_04FF3F:        A0 04         LDY.B #$04                
ADDR_04FF41:        C5 08         CMP $08                   
ADDR_04FF43:        B0 04         BCS ADDR_04FF49           
ADDR_04FF45:        A0 02         LDY.B #$02                
ADDR_04FF47:        A5 08         LDA $08                   
ADDR_04FF49:        C5 06         CMP $06                   
ADDR_04FF4B:        B0 04         BCS ADDR_04FF51           
ADDR_04FF4D:        A0 00         LDY.B #$00                
ADDR_04FF4F:        A5 06         LDA $06                   
ADDR_04FF51:        C9 01         CMP.B #$01                
ADDR_04FF53:        B0 12         BCS ADDR_04FF67           
ADDR_04FF55:        9E 15 0E      STZ.W $0E15,X             
ADDR_04FF58:        9E 95 0E      STZ.W $0E95,X             
ADDR_04FF5B:        9E A5 0E      STZ.W $0EA5,X             
ADDR_04FF5E:        9E B5 0E      STZ.W $0EB5,X             
ADDR_04FF61:        A9 40         LDA.B #$40                
ADDR_04FF63:        9D 55 0E      STA.W $0E55,X             
Return04FF66:       60            RTS                       ; Return 

ADDR_04FF67:        84 0C         STY $0C                   
ADDR_04FF69:        A2 04         LDX.B #$04                
ADDR_04FF6B:        E4 0C         CPX $0C                   
ADDR_04FF6D:        D0 04         BNE ADDR_04FF73           
ADDR_04FF6F:        A9 20         LDA.B #$20                
ADDR_04FF71:        80 1E         BRA ADDR_04FF91           

ADDR_04FF73:        9C 04 42      STZ.W $4204               ; Dividend (Low Byte)
ADDR_04FF76:        B5 06         LDA $06,X                 
ADDR_04FF78:        8D 05 42      STA.W $4205               ; Dividend (High-Byte)
ADDR_04FF7B:        B9 06 00      LDA.W $0006,Y             
ADDR_04FF7E:        8D 06 42      STA.W $4206               ; Divisor B
ADDR_04FF81:        EA            NOP                       
ADDR_04FF82:        EA            NOP                       
ADDR_04FF83:        EA            NOP                       
ADDR_04FF84:        EA            NOP                       
ADDR_04FF85:        EA            NOP                       
ADDR_04FF86:        EA            NOP                       
ADDR_04FF87:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_04FF89:        AD 14 42      LDA.W $4214               ; Quotient of Divide Result (Low Byte)
ADDR_04FF8C:        4A            LSR                       
ADDR_04FF8D:        4A            LSR                       
ADDR_04FF8E:        4A            LSR                       
ADDR_04FF8F:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_04FF91:        34 01         BIT $01,X                 
ADDR_04FF93:        30 03         BMI ADDR_04FF98           
ADDR_04FF95:        49 FF         EOR.B #$FF                
ADDR_04FF97:        1A            INC A                     
ADDR_04FF98:        95 00         STA $00,X                 
ADDR_04FF9A:        CA            DEX                       
ADDR_04FF9B:        CA            DEX                       
ADDR_04FF9C:        10 CD         BPL ADDR_04FF6B           
ADDR_04FF9E:        AE DE 0D      LDX.W $0DDE               
ADDR_04FFA1:        A5 00         LDA $00                   
ADDR_04FFA3:        9D 95 0E      STA.W $0E95,X             
ADDR_04FFA6:        A5 02         LDA $02                   
ADDR_04FFA8:        9D A5 0E      STA.W $0EA5,X             
ADDR_04FFAB:        A5 04         LDA $04                   
ADDR_04FFAD:        9D B5 0E      STA.W $0EB5,X             
Return04FFB0:       60            RTS                       ; Return 


DATA_04FFB1:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF