TilesetMAP16Loc:                  .db $70,$8B,$00,$BC,$00,$C8,$00,$D4     ; Addresses to tileset-specific MAP16 data 
                                  .db $00,$E3,$00,$E3,$00,$C8,$70,$8B
                                  .db $00,$C8,$00,$D4,$00,$D4,$00,$D4
                                  .db $70,$8B,$00,$E3,$00,$D4

CODE_05801E:        08            PHP                       
CODE_05801F:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_058021:        C2 10         REP #$10                  ; 16 bit X,Y ; Index (16 bit) 
CODE_058023:        A2 00 00      LDX.W #$0000              ; \ 
CODE_058026:        A9 25         LDA.B #$25                ;  | 
CODE_058028:        9F 00 B9 7E   STA.L $7EB900,X           ;  |Set all background tiles (lower bytes) to x25 
CODE_05802C:        9F 00 BB 7E   STA.L $7EBB00,X           ;  | 
CODE_058030:        E8            INX                       ;  | 
CODE_058031:        E0 00 02      CPX.W #$0200              ;  | 
CODE_058034:        D0 F0         BNE CODE_058026           ; / 
CODE_058036:        9C 28 19      STZ.W $1928               
CODE_058039:        A5 6A         LDA $6A                   ; \ 
CODE_05803B:        C9 FF         CMP.B #$FF                ;  |If the layer 2 data is a background, 
CODE_05803D:        D0 35         BNE CODE_058074           ; / branch to $8074 
CODE_05803F:        C2 10         REP #$10                  ; 16 bit X,Y ; Index (16 bit) 
CODE_058041:        A0 00 00      LDY.W #$0000              ; \ 
CODE_058044:        A6 68         LDX $68                   ;  | 
CODE_058046:        E0 FE E8      CPX.W #$E8FE              ;  |If Layer 2 pointer >= $E8FF, 
CODE_058049:        90 03         BCC CODE_05804E           ;  |the background should use Map16 page x11 instead of x10 
CODE_05804B:        A0 01 00      LDY.W #$0001              ;  | 
CODE_05804E:        A2 00 00      LDX.W #$0000              ; \ 
CODE_058051:        98            TYA                       ;  | 
CODE_058052:        9F 00 BD 7E   STA.L $7EBD00,X           ;  |Set the background's Map16 page 
CODE_058056:        9F 00 BF 7E   STA.L $7EBF00,X           ;  |(i.e. setting all high tile bytes to Y) 
CODE_05805A:        E8            INX                       ;  | 
CODE_05805B:        E0 00 02      CPX.W #$0200              ;  | 
CODE_05805E:        D0 F2         BNE CODE_058052           ; / 
CODE_058060:        A9 0C         LDA.B #$0C                ; \ Set highest Layer 2 address to x0C 
CODE_058062:        85 6A         STA $6A                   ; / (All backgrounds are stored in bank 0C) 
CODE_058064:        9C 32 19      STZ.W $1932               ; \ Set tileset to 0 
CODE_058067:        9C 31 19      STZ.W $1931               ; / 
CODE_05806A:        A2 00 B9      LDX.W #$B900              
CODE_05806D:        86 0D         STX $0D                   
CODE_05806F:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_058071:        20 26 81      JSR.W CODE_058126         
CODE_058074:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_058076:        A2 00 00      LDX.W #$0000              ; \ 
CODE_058079:        A9 00         LDA.B #$00                ;  | 
CODE_05807B:        20 3A 83      JSR.W CODE_05833A         ;  |Clear level data 
CODE_05807E:        CA            DEX                       ;  | 
CODE_05807F:        A9 25         LDA.B #$25                ;  | 
CODE_058081:        20 C8 82      JSR.W CODE_0582C8         ;  | 
CODE_058084:        E0 00 02      CPX.W #$0200              ;  | 
CODE_058087:        D0 F0         BNE CODE_058079           ; / 
CODE_058089:        9C 28 19      STZ.W $1928               
CODE_05808C:        20 AC 83      JSR.W LoadLevel           ; Load the level 
CODE_05808F:        E2 30         SEP #$30                  ; 8 bit A,X,Y ; Index (8 bit) Accum (8 bit) 
CODE_058091:        AD 00 01      LDA.W RAM_GameMode        ; \ 
CODE_058094:        C9 22         CMP.B #$22                ;  | 
CODE_058096:        10 04         BPL CODE_05809C           ;  |If level mode is less than x22, 
CODE_058098:        22 51 A7 02   JSL.L CODE_02A751         ;  |JSL to $02A751 
CODE_05809C:        28            PLP                       
Return05809D:       6B            RTL                       ; Return 

CODE_05809E:        08            PHP                       
CODE_05809F:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0580A1:        9C 28 19      STZ.W $1928               ; Zero a byte in the middle of the RAM table for the level header 
CODE_0580A4:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_0580A6:        A9 FF FF      LDA.W #$FFFF              
CODE_0580A9:        85 4D         STA $4D                   ; $4D to $50 = #$FF 
CODE_0580AB:        85 4F         STA $4F                   
CODE_0580AD:        20 7E 87      JSR.W CODE_05877E         ; -> here 
CODE_0580B0:        A5 45         LDA $45                   
CODE_0580B2:        85 47         STA $47                   
CODE_0580B4:        A5 49         LDA $49                   
CODE_0580B6:        85 4B         STA $4B                   
CODE_0580B8:        A9 02 02      LDA.W #$0202              
CODE_0580BB:        85 55         STA $55                   
CODE_0580BD:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_0580BF:        22 EC 88 05   JSL.L CODE_0588EC         
CODE_0580C3:        22 55 89 05   JSL.L CODE_058955         
CODE_0580C7:        22 AD 87 00   JSL.L CODE_0087AD         
CODE_0580CB:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_0580CD:        E6 47         INC $47                   
CODE_0580CF:        E6 4B         INC $4B                   
CODE_0580D1:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_0580D3:        A5 47         LDA $47                   
CODE_0580D5:        4A            LSR                       
CODE_0580D6:        4A            LSR                       
CODE_0580D7:        4A            LSR                       
CODE_0580D8:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_0580DA:        29 06 00      AND.W #$0006              
CODE_0580DD:        AA            TAX                       
CODE_0580DE:        A9 33 01      LDA.W #$0133              
CODE_0580E1:        0A            ASL                       
CODE_0580E2:        A8            TAY                       
CODE_0580E3:        A9 07 00      LDA.W #$0007              
CODE_0580E6:        85 00         STA $00                   
CODE_0580E8:        BF 76 87 05   LDA.L MAP16AppTable,X     
CODE_0580EC:        99 BE 0F      STA.W $0FBE,Y             
CODE_0580EF:        C8            INY                       
CODE_0580F0:        C8            INY                       
CODE_0580F1:        18            CLC                       
CODE_0580F2:        69 08 00      ADC.W #$0008              
CODE_0580F5:        C6 00         DEC $00                   
CODE_0580F7:        10 F3         BPL CODE_0580EC           
CODE_0580F9:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0580FB:        EE 28 19      INC.W $1928               
CODE_0580FE:        AD 28 19      LDA.W $1928               
CODE_058101:        C9 20         CMP.B #$20                
CODE_058103:        D0 B8         BNE CODE_0580BD           
CODE_058105:        AD 9D 0D      LDA.W $0D9D               
CODE_058108:        8D 2C 21      STA.W $212C               ; Background and Object Enable
CODE_05810B:        8D 2E 21      STA.W $212E               ; Window Mask Designation for Main Screen
CODE_05810E:        AD 9E 0D      LDA.W $0D9E               
CODE_058111:        8D 2D 21      STA.W $212D               ; Sub Screen Designation
CODE_058114:        8D 2F 21      STA.W $212F               ; Window Mask Designation for Sub Screen
CODE_058117:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058119:        A9 FF FF      LDA.W #$FFFF              
CODE_05811C:        85 4D         STA $4D                   
CODE_05811E:        85 4F         STA $4F                   
CODE_058120:        85 51         STA $51                   
CODE_058122:        85 53         STA $53                   
CODE_058124:        28            PLP                       
Return058125:       6B            RTL                       ; Return 

CODE_058126:        08            PHP                       
CODE_058127:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_058129:        A0 00 00      LDY.W #$0000              
CODE_05812C:        84 03         STY $03                   
CODE_05812E:        84 05         STY $05                   
CODE_058130:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_058132:        A9 7E         LDA.B #$7E                
CODE_058134:        85 0F         STA $0F                   
CODE_058136:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058138:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_05813A:        A4 03         LDY $03                   
CODE_05813C:        B7 68         LDA [$68],Y               
CODE_05813E:        85 07         STA $07                   
CODE_058140:        C8            INY                       
CODE_058141:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058143:        84 03         STY $03                   
CODE_058145:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058147:        29 80         AND.B #$80                
CODE_058149:        F0 1F         BEQ CODE_05816A           
CODE_05814B:        A5 07         LDA $07                   
CODE_05814D:        29 7F         AND.B #$7F                
CODE_05814F:        85 07         STA $07                   
CODE_058151:        B7 68         LDA [$68],Y               
CODE_058153:        C8            INY                       
CODE_058154:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058156:        84 03         STY $03                   
CODE_058158:        A4 05         LDY $05                   
CODE_05815A:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05815C:        97 0D         STA [$0D],Y               
CODE_05815E:        C8            INY                       
CODE_05815F:        C6 07         DEC $07                   
CODE_058161:        10 F7         BPL CODE_05815A           
CODE_058163:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058165:        84 05         STY $05                   
CODE_058167:        4C 88 81      JMP.W CODE_058188         

CODE_05816A:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05816C:        A4 03         LDY $03                   
CODE_05816E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058170:        B7 68         LDA [$68],Y               
CODE_058172:        C8            INY                       
CODE_058173:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058175:        84 03         STY $03                   
CODE_058177:        A4 05         LDY $05                   
CODE_058179:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05817B:        97 0D         STA [$0D],Y               
CODE_05817D:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05817F:        C8            INY                       
CODE_058180:        84 05         STY $05                   
CODE_058182:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058184:        C6 07         DEC $07                   
CODE_058186:        10 E2         BPL CODE_05816A           
CODE_058188:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05818A:        A4 03         LDY $03                   
CODE_05818C:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05818E:        B7 68         LDA [$68],Y               
CODE_058190:        C9 FF         CMP.B #$FF                
CODE_058192:        D0 A2         BNE CODE_058136           
CODE_058194:        C8            INY                       
CODE_058195:        B7 68         LDA [$68],Y               
CODE_058197:        C9 FF         CMP.B #$FF                
CODE_058199:        D0 9B         BNE CODE_058136           
CODE_05819B:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05819D:        A9 00 91      LDA.W #$9100              
CODE_0581A0:        85 00         STA $00                   
CODE_0581A2:        A2 00 00      LDX.W #$0000              
CODE_0581A5:        A5 00         LDA $00                   
CODE_0581A7:        9D BE 0F      STA.W $0FBE,X             
CODE_0581AA:        A5 00         LDA $00                   
CODE_0581AC:        18            CLC                       
CODE_0581AD:        69 08 00      ADC.W #$0008              
CODE_0581B0:        85 00         STA $00                   
CODE_0581B2:        E8            INX                       
CODE_0581B3:        E8            INX                       
CODE_0581B4:        E0 00 04      CPX.W #$0400              
CODE_0581B7:        D0 EC         BNE CODE_0581A5           
CODE_0581B9:        28            PLP                       
Return0581BA:       60            RTS                       ; Return 


DATA_0581BB:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$E0,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $FE,$00,$7F,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$E0,$00,$00,$03,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

CODE_0581FB:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_0581FD:        AD 31 19      LDA.W $1931               ; \ 
CODE_058200:        0A            ASL                       ;  |Store tileset*2 in X 
CODE_058201:        AA            TAX                       ; / 
CODE_058202:        A9 05         LDA.B #$05                ; \Store x05 in $0F 
CODE_058204:        85 0F         STA $0F                   ; / 
CODE_058206:        A9 00         LDA.B #$00                ; \Store x00 in $84 
CODE_058208:        85 84         STA $84                   ; / 
CODE_05820A:        A9 C4         LDA.B #$C4                ; \Store xC4 in $1430 
CODE_05820C:        8D 30 14      STA.W $1430               ; / 
CODE_05820F:        A9 CA         LDA.B #$CA                ; \Store xCA in $1431 
CODE_058211:        8D 31 14      STA.W $1431               ; / 
CODE_058214:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058216:        A9 5E E5      LDA.W #$E55E              ; \Store xE55E in $82-$83 
CODE_058219:        85 82         STA $82                   ; / 
CODE_05821B:        BF 00 80 05   LDA.L TilesetMAP16Loc,X   ; \Store address to MAP16 data in $00-$01 
CODE_05821F:        85 00         STA $00                   ; / 
CODE_058221:        A9 00 80      LDA.W #$8000              ; \Store x8000 in $02-$03 
CODE_058224:        85 02         STA $02                   ; / 
CODE_058226:        A9 BB 81      LDA.W #$81BB              ; \Store x81BB in $0D-$0E 
CODE_058229:        85 0D         STA $0D                   ; / 
CODE_05822B:        64 04         STZ $04                   ; \ 
CODE_05822D:        64 09         STZ $09                   ;  |Store x00 in $04, $09 and $0B 
CODE_05822F:        64 0B         STZ $0B                   ; / 
CODE_058231:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_058233:        A0 00 00      LDY.W #$0000              ; \Set X and Y to x0000 
CODE_058236:        BB            TYX                       ; / 
CODE_058237:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058239:        B7 0D         LDA [$0D],Y               
CODE_05823B:        85 0C         STA $0C                   
CODE_05823D:        06 0C         ASL $0C                   
CODE_05823F:        90 12         BCC CODE_058253           
CODE_058241:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058243:        A5 02         LDA $02                   
CODE_058245:        9D BE 0F      STA.W $0FBE,X             
CODE_058248:        A5 02         LDA $02                   
CODE_05824A:        18            CLC                       
CODE_05824B:        69 08 00      ADC.W #$0008              
CODE_05824E:        85 02         STA $02                   
CODE_058250:        4C 62 82      JMP.W CODE_058262         

CODE_058253:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058255:        A5 00         LDA $00                   
CODE_058257:        9D BE 0F      STA.W $0FBE,X             
CODE_05825A:        A5 00         LDA $00                   
CODE_05825C:        18            CLC                       
CODE_05825D:        69 08 00      ADC.W #$0008              
CODE_058260:        85 00         STA $00                   
CODE_058262:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058264:        E8            INX                       
CODE_058265:        E8            INX                       
CODE_058266:        E6 09         INC $09                   
CODE_058268:        E6 0B         INC $0B                   
CODE_05826A:        A5 0B         LDA $0B                   
CODE_05826C:        C9 08         CMP.B #$08                
CODE_05826E:        D0 CD         BNE CODE_05823D           
CODE_058270:        64 0B         STZ $0B                   
CODE_058272:        C8            INY                       
CODE_058273:        C0 40 00      CPY.W #$0040              
CODE_058276:        D0 BF         BNE CODE_058237           
CODE_058278:        AD 31 19      LDA.W $1931               
CODE_05827B:        F0 04         BEQ CODE_058281           
CODE_05827D:        C9 07         CMP.B #$07                
CODE_05827F:        D0 44         BNE CODE_0582C5           
CODE_058281:        A9 FF         LDA.B #$FF                
CODE_058283:        8D 30 14      STA.W $1430               
CODE_058286:        8D 31 14      STA.W $1431               
CODE_058289:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_05828B:        A9 C8 E5      LDA.W #$E5C8              
CODE_05828E:        85 82         STA $82                   
CODE_058290:        A9 C4 01      LDA.W #$01C4              
CODE_058293:        0A            ASL                       
CODE_058294:        A8            TAY                       
CODE_058295:        A9 70 8A      LDA.W #$8A70              
CODE_058298:        85 00         STA $00                   
CODE_05829A:        A2 03 00      LDX.W #$0003              
CODE_05829D:        A5 00         LDA $00                   
CODE_05829F:        99 BE 0F      STA.W $0FBE,Y             
CODE_0582A2:        18            CLC                       
CODE_0582A3:        69 08 00      ADC.W #$0008              
CODE_0582A6:        85 00         STA $00                   
CODE_0582A8:        C8            INY                       
CODE_0582A9:        C8            INY                       
CODE_0582AA:        CA            DEX                       
CODE_0582AB:        10 F0         BPL CODE_05829D           
CODE_0582AD:        A9 EC 01      LDA.W #$01EC              
CODE_0582B0:        0A            ASL                       
CODE_0582B1:        A8            TAY                       
CODE_0582B2:        A2 03 00      LDX.W #$0003              
CODE_0582B5:        A5 00         LDA $00                   
CODE_0582B7:        99 BE 0F      STA.W $0FBE,Y             
CODE_0582BA:        18            CLC                       
CODE_0582BB:        69 08 00      ADC.W #$0008              
CODE_0582BE:        85 00         STA $00                   
CODE_0582C0:        C8            INY                       
CODE_0582C1:        C8            INY                       
CODE_0582C2:        CA            DEX                       
CODE_0582C3:        10 F0         BPL CODE_0582B5           
CODE_0582C5:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return0582C7:       60            RTS                       ; Return 

CODE_0582C8:        9F 00 C8 7E   STA.L $7EC800,X           
CODE_0582CC:        9F 00 CA 7E   STA.L $7ECA00,X           
CODE_0582D0:        9F 00 CC 7E   STA.L $7ECC00,X           
CODE_0582D4:        9F 00 CE 7E   STA.L $7ECE00,X           
CODE_0582D8:        9F 00 D0 7E   STA.L $7ED000,X           
CODE_0582DC:        9F 00 D2 7E   STA.L $7ED200,X           
CODE_0582E0:        9F 00 D4 7E   STA.L $7ED400,X           
CODE_0582E4:        9F 00 D6 7E   STA.L $7ED600,X           
CODE_0582E8:        9F 00 D8 7E   STA.L $7ED800,X           
CODE_0582EC:        9F 00 DA 7E   STA.L $7EDA00,X           
CODE_0582F0:        9F 00 DC 7E   STA.L $7EDC00,X           
CODE_0582F4:        9F 00 DE 7E   STA.L $7EDE00,X           
CODE_0582F8:        9F 00 E0 7E   STA.L $7EE000,X           
CODE_0582FC:        9F 00 E2 7E   STA.L $7EE200,X           
CODE_058300:        9F 00 E4 7E   STA.L $7EE400,X           
CODE_058304:        9F 00 E6 7E   STA.L $7EE600,X           
CODE_058308:        9F 00 E8 7E   STA.L $7EE800,X           
CODE_05830C:        9F 00 EA 7E   STA.L $7EEA00,X           
CODE_058310:        9F 00 EC 7E   STA.L $7EEC00,X           
CODE_058314:        9F 00 EE 7E   STA.L $7EEE00,X           
CODE_058318:        9F 00 F0 7E   STA.L $7EF000,X           
CODE_05831C:        9F 00 F2 7E   STA.L $7EF200,X           
CODE_058320:        9F 00 F4 7E   STA.L $7EF400,X           
CODE_058324:        9F 00 F6 7E   STA.L $7EF600,X           
CODE_058328:        9F 00 F8 7E   STA.L $7EF800,X           
CODE_05832C:        9F 00 FA 7E   STA.L $7EFA00,X           
CODE_058330:        9F 00 FC 7E   STA.L $7EFC00,X           
CODE_058334:        9F 00 FE 7E   STA.L $7EFE00,X           
CODE_058338:        E8            INX                       
Return058339:       60            RTS                       ; Return 

CODE_05833A:        9F 00 C8 7F   STA.L $7FC800,X           
CODE_05833E:        9F 00 CA 7F   STA.L $7FCA00,X           
CODE_058342:        9F 00 CC 7F   STA.L $7FCC00,X           
CODE_058346:        9F 00 CE 7F   STA.L $7FCE00,X           
CODE_05834A:        9F 00 D0 7F   STA.L $7FD000,X           
CODE_05834E:        9F 00 D2 7F   STA.L $7FD200,X           
CODE_058352:        9F 00 D4 7F   STA.L $7FD400,X           
CODE_058356:        9F 00 D6 7F   STA.L $7FD600,X           
CODE_05835A:        9F 00 D8 7F   STA.L $7FD800,X           
CODE_05835E:        9F 00 DA 7F   STA.L $7FDA00,X           
CODE_058362:        9F 00 DC 7F   STA.L $7FDC00,X           
CODE_058366:        9F 00 DE 7F   STA.L $7FDE00,X           
CODE_05836A:        9F 00 E0 7F   STA.L $7FE000,X           
CODE_05836E:        9F 00 E2 7F   STA.L $7FE200,X           
CODE_058372:        9F 00 E4 7F   STA.L $7FE400,X           
CODE_058376:        9F 00 E6 7F   STA.L $7FE600,X           
CODE_05837A:        9F 00 E8 7F   STA.L $7FE800,X           
CODE_05837E:        9F 00 EA 7F   STA.L $7FEA00,X           
CODE_058382:        9F 00 EC 7F   STA.L $7FEC00,X           
CODE_058386:        9F 00 EE 7F   STA.L $7FEE00,X           
CODE_05838A:        9F 00 F0 7F   STA.L $7FF000,X           
CODE_05838E:        9F 00 F2 7F   STA.L $7FF200,X           
CODE_058392:        9F 00 F4 7F   STA.L $7FF400,X           
CODE_058396:        9F 00 F6 7F   STA.L $7FF600,X           
CODE_05839A:        9F 00 F8 7F   STA.L $7FF800,X           
CODE_05839E:        9F 00 FA 7F   STA.L $7FFA00,X           
CODE_0583A2:        9F 00 FC 7F   STA.L $7FFC00,X           
CODE_0583A6:        9F 00 FE 7F   STA.L $7FFE00,X           
CODE_0583AA:        E8            INX                       
Return0583AB:       60            RTS                       ; Return 

LoadLevel:          08            PHP                       
CODE_0583AD:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_0583AF:        9C 33 19      STZ.W $1933               ; Layer number (0=Layer 1, 1=Layer 2) 
CODE_0583B2:        20 E3 84      JSR.W CODE_0584E3         ; Loads level header 
CODE_0583B5:        20 FB 81      JSR.W CODE_0581FB         
LoadAgain:          AD 25 19      LDA.W $1925               ; Get current level mode 
CODE_0583BB:        C9 09         CMP.B #$09                ; \ 
CODE_0583BD:        F0 53         BEQ LoadLevelDone         ;  | 
CODE_0583BF:        C9 0B         CMP.B #$0B                ;  |If the current level is a boss level, 
CODE_0583C1:        F0 4F         BEQ LoadLevelDone         ;  |don't load anything else. 
CODE_0583C3:        C9 10         CMP.B #$10                ;  | 
CODE_0583C5:        F0 4B         BEQ LoadLevelDone         ; / 
CODE_0583C7:        A0 00         LDY.B #$00                ; \ 
CODE_0583C9:        B7 65         LDA [$65],Y               ;  | 
CODE_0583CB:        C9 FF         CMP.B #$FF                ;  |If level isn't empty, load the level. 
CODE_0583CD:        F0 03         BEQ LevLoadNotEmpty       ;  | 
CODE_0583CF:        20 FF 85      JSR.W LoadLevelData       ; / 
LevLoadNotEmpty:    E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_0583D4:        AD 25 19      LDA.W $1925               ; Get current level mode 
CODE_0583D7:        F0 39         BEQ LoadLevelDone         ; \ 
CODE_0583D9:        C9 0A         CMP.B #$0A                ;  | 
CODE_0583DB:        F0 35         BEQ LoadLevelDone         ;  | 
CODE_0583DD:        C9 0C         CMP.B #$0C                ;  | 
CODE_0583DF:        F0 31         BEQ LoadLevelDone         ;  |If the current level isn't a Layer 2 level, 
CODE_0583E1:        C9 0D         CMP.B #$0D                ;  |branch to LoadLevelDone 
CODE_0583E3:        F0 2D         BEQ LoadLevelDone         ;  | 
CODE_0583E5:        C9 0E         CMP.B #$0E                ;  | 
CODE_0583E7:        F0 29         BEQ LoadLevelDone         ;  | 
CODE_0583E9:        C9 11         CMP.B #$11                ;  | 
CODE_0583EB:        F0 25         BEQ LoadLevelDone         ;  | 
CODE_0583ED:        C9 1E         CMP.B #$1E                ;  | 
CODE_0583EF:        F0 21         BEQ LoadLevelDone         ; / 
CODE_0583F1:        EE 33 19      INC.W $1933               ; \Increase layer number and load into A 
CODE_0583F4:        AD 33 19      LDA.W $1933               ; / 
CODE_0583F7:        C9 02         CMP.B #$02                ; \If it is x02, end. (Layer 1 and 2 are done) 
CODE_0583F9:        F0 17         BEQ LoadLevelDone         ; / 
CODE_0583FB:        A5 68         LDA $68                   ; \ 
CODE_0583FD:        18            CLC                       ;  | 
CODE_0583FE:        69 05         ADC.B #$05                ;  | 
CODE_058400:        85 65         STA $65                   ;  |Move address stored in $68-$6A to $65-$67. 
CODE_058402:        A5 69         LDA $69                   ;  |(Move Layer 2 address to "Level to load" address) 
CODE_058404:        69 00         ADC.B #$00                ;  |It also increases the address by 5 (to ignore Layer 2's header) 
CODE_058406:        85 66         STA $66                   ;  | 
CODE_058408:        A5 6A         LDA $6A                   ;  | 
CODE_05840A:        85 67         STA $67                   ; / 
CODE_05840C:        9C 28 19      STZ.W $1928               
CODE_05840F:        4C B8 83      JMP.W LoadAgain           

LoadLevelDone:      9C 33 19      STZ.W $1933               
CODE_058415:        28            PLP                       
Return058416:       60            RTS                       ; Return 


VerticalTable:                    .db $00,$00,$80,$01,$81,$02,$82,$03     ; Vertical level settings for each level mode ; Format: 
                                  .db $83,$00,$01,$00,$00,$01,$00,$00     ; ?uuuuu?v 
                                  .db $00,$00,$00,$00,$00,$00,$00,$00     ; ?= Unknown purpose ; u= Unused? 
                                  .db $00,$00,$00,$00,$00,$00,$00,$80     ; v= Vertical level 
LevMainScrnTbl:                   .db $15,$15,$17,$15,$15,$15,$17,$15     ; Main screen settings for each level mode 
                                  .db $17,$15,$15,$15,$15,$15,$04,$04
                                  .db $15,$17,$15,$15,$15,$15,$15,$15
                                  .db $15,$15,$15,$15,$15,$15,$01,$02
LevSubScrnTbl:                    .db $02,$02,$00,$02,$02,$02,$00,$02     ; Subscreen settings for each level mode 
                                  .db $00,$00,$02,$00,$02,$02,$13,$13
                                  .db $00,$00,$02,$02,$02,$02,$02,$02
                                  .db $02,$02,$02,$02,$02,$02,$16,$15
LevCGADSUBtable:                  .db $24,$24,$24,$24,$24,$24,$20,$24     ; CGADSUB settings for each level mode 
                                  .db $24,$20,$24,$20,$70,$70,$24,$24
                                  .db $20,$FF,$24,$24,$24,$24,$24,$24
                                  .db $24,$24,$24,$24,$24,$24,$21,$22
SpecialLevTable:                  .db $00,$00,$00,$00,$00,$00,$00,$00     ; Special level settings for each level mode ; 00: Normal level 
                                  .db $00,$C0,$00,$80,$00,$00,$00,$00     ; 80: Iggy/Larry level ; C0: Morton/Ludwig/Roy level 
                                  .db $C1,$00,$00,$00,$00,$00,$00,$00     ; C1: Bowser level 
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
LevXYPPCCCTtbl:                   .db $20,$20,$20,$30,$30,$30,$30,$30     ; XYPPCCCT settings for each level mode ; (The XYPPCCCT setting appears to be XORed with nearly all 
                                  .db $30,$30,$30,$30,$30,$30,$20,$20     ; sprites' XYPPCCCT settings) 
                                  .db $30,$30,$30,$30,$30,$30,$30,$30
                                  .db $30,$30,$30,$30,$30,$30,$30,$30
TimerTable:                       .db $00,$02,$03,$04

LevelMusicTable:                  .db $02,$06,$01,$08,$07,$03,$05,$12     ; A level can choose between 8 tracks. ; This table contains the tracks to choose from. 

CODE_0584E3:        A0 00         LDY.B #$00                
CODE_0584E5:        B7 65         LDA [$65],Y               ; Get first byte 
CODE_0584E7:        AA            TAX                       ; \ 
CODE_0584E8:        29 1F         AND.B #$1F                ;  |Get amount of screens 
CODE_0584EA:        1A            INC A                     ;  | 
CODE_0584EB:        85 5D         STA RAM_ScreensInLvl      ; / 
CODE_0584ED:        8A            TXA                       ; \ 
CODE_0584EE:        4A            LSR                       ;  | 
CODE_0584EF:        4A            LSR                       ;  | 
CODE_0584F0:        4A            LSR                       ;  |Get BG color setting 
CODE_0584F1:        4A            LSR                       ;  | 
CODE_0584F2:        4A            LSR                       ;  | 
CODE_0584F3:        8D 30 19      STA.W $1930               ; / 
CODE_0584F6:        C8            INY                       ; \Get second byte 
CODE_0584F7:        B7 65         LDA [$65],Y               ; / 
CODE_0584F9:        29 1F         AND.B #$1F                ; \Get level mode 
CODE_0584FB:        8D 25 19      STA.W $1925               ; / 
CODE_0584FE:        AA            TAX                       
CODE_0584FF:        BF B7 84 05   LDA.L LevXYPPCCCTtbl,X    ; \Get XYPPCCCT settings from table 
CODE_058503:        85 64         STA $64                   ; / 
CODE_058505:        BF 37 84 05   LDA.L LevMainScrnTbl,X    ; \Get main screen setting from table 
CODE_058509:        8D 9D 0D      STA.W $0D9D               ; / 
CODE_05850C:        BF 57 84 05   LDA.L LevSubScrnTbl,X     ; \Get subscreen setting from table 
CODE_058510:        8D 9E 0D      STA.W $0D9E               ; / 
CODE_058513:        BF 77 84 05   LDA.L LevCGADSUBtable,X   ; \Get CGADSUB settings from table 
CODE_058517:        85 40         STA $40                   ; / 
CODE_058519:        BF 97 84 05   LDA.L SpecialLevTable,X   ; \Get special level setting from table 
CODE_05851D:        8D 9B 0D      STA.W $0D9B               ; / 
CODE_058520:        BF 17 84 05   LDA.L VerticalTable,X     ; \Get vertical level setting from table 
CODE_058524:        85 5B         STA RAM_IsVerticalLvl     ; / 
CODE_058526:        4A            LSR                       ; \ 
CODE_058527:        A5 5D         LDA RAM_ScreensInLvl      ;  | 
CODE_058529:        A2 01         LDX.B #$01                ;  |If level mode is even: 
CODE_05852B:        90 03         BCC LevelModeEven         ;  |Store screen amount in $5E and x01 in $5F 
CODE_05852D:        AA            TAX                       ;  |Otherwise: 
CODE_05852E:        A9 01         LDA.B #$01                ;  |Store x01 in $5E and screen amount in $5F 
LevelModeEven:      85 5E         STA $5E                   ;  | 
CODE_058532:        86 5F         STX $5F                   ; / 
CODE_058534:        B7 65         LDA [$65],Y               ; Reload second byte 
CODE_058536:        4A            LSR                       ; \ 
CODE_058537:        4A            LSR                       ;  | 
CODE_058538:        4A            LSR                       ;  |Get BG color settings 
CODE_058539:        4A            LSR                       ;  | 
CODE_05853A:        4A            LSR                       ;  | 
CODE_05853B:        8D 2F 19      STA.W $192F               ; / 
CODE_05853E:        C8            INY                       ; \Get third byte 
CODE_05853F:        B7 65         LDA [$65],Y               ; / 
CODE_058541:        85 00         STA $00                   ; "Push" third byte 
CODE_058543:        AA            TAX                       ; "Push" third byte 
CODE_058544:        29 0F         AND.B #$0F                ; \Load sprite set 
CODE_058546:        8D 2B 19      STA.W $192B               ; / 
CODE_058549:        8A            TXA                       ; "Pull" third byte 
CODE_05854A:        4A            LSR                       ; \ 
CODE_05854B:        4A            LSR                       ;  | 
CODE_05854C:        4A            LSR                       ;  | 
CODE_05854D:        4A            LSR                       ;  | 
CODE_05854E:        29 07         AND.B #$07                ;  | 
CODE_058550:        AA            TAX                       ;  |Get music 
CODE_058551:        BF DB 84 05   LDA.L LevelMusicTable,X   ;  | 
CODE_058555:        AE DA 0D      LDX.W $0DDA               ;  | \ 
CODE_058558:        10 02         BPL CODE_05855C           ;  |  | 
ADDR_05855A:        09 80         ORA.B #$80                ;  |  |Related to not restarting music if the new track 
CODE_05855C:        CD DA 0D      CMP.W $0DDA               ;  |  |is the same as the old one? 
CODE_05855F:        D0 02         BNE CODE_058563           ;  |  | 
CODE_058561:        09 40         ORA.B #$40                ;  | / 
CODE_058563:        8D DA 0D      STA.W $0DDA               ; / 
CODE_058566:        A5 00         LDA $00                   ; "Pull" third byte 
CODE_058568:        29 80         AND.B #$80                ; \ 
CODE_05856A:        4A            LSR                       ;  | 
CODE_05856B:        4A            LSR                       ;  | 
CODE_05856C:        4A            LSR                       ;  |Get Layer 3 priority 
CODE_05856D:        4A            LSR                       ;  | 
CODE_05856E:        09 01         ORA.B #$01                ;  | 
CODE_058570:        85 3E         STA $3E                   ; / 
CODE_058572:        C8            INY                       ; \Get fourth bit 
CODE_058573:        B7 65         LDA [$65],Y               ; / 
CODE_058575:        85 00         STA $00                   ; "Push" fourth bit 
CODE_058577:        4A            LSR                       ; \ 
CODE_058578:        4A            LSR                       ;  | 
CODE_058579:        4A            LSR                       ;  | 
CODE_05857A:        4A            LSR                       ;  | 
CODE_05857B:        4A            LSR                       ;  | 
CODE_05857C:        4A            LSR                       ;  | 
CODE_05857D:        AA            TAX                       ;  |Get time 
CODE_05857E:        AD 1A 14      LDA.W $141A               ;  | 
CODE_058581:        D0 0D         BNE CODE_058590           ;  | 
CODE_058583:        BF D7 84 05   LDA.L TimerTable,X        ;  | 
CODE_058587:        8D 31 0F      STA.W $0F31               ;  | 
CODE_05858A:        9C 32 0F      STZ.W $0F32               ;  | 
CODE_05858D:        9C 33 0F      STZ.W $0F33               ; / 
CODE_058590:        A5 00         LDA $00                   ; "Pull" fourth bit 
CODE_058592:        29 07         AND.B #$07                ; \Get FG color settings 
CODE_058594:        8D 2D 19      STA.W $192D               ; / 
CODE_058597:        A5 00         LDA $00                   ; "Pull" fourth bit (again) 
CODE_058599:        29 38         AND.B #$38                ; \ 
CODE_05859B:        4A            LSR                       ;  | 
CODE_05859C:        4A            LSR                       ;  |Get sprite palette 
CODE_05859D:        4A            LSR                       ;  | 
CODE_05859E:        8D 2E 19      STA.W $192E               ; / 
CODE_0585A1:        C8            INY                       ; \Get fifth byte 
CODE_0585A2:        B7 65         LDA [$65],Y               ; / 
CODE_0585A4:        29 0F         AND.B #$0F                ; \ 
CODE_0585A6:        8D 31 19      STA.W $1931               ;  |Get tileset 
CODE_0585A9:        8D 32 19      STA.W $1932               ; / 
CODE_0585AC:        B7 65         LDA [$65],Y               ; Reload fifth byte 
CODE_0585AE:        29 C0         AND.B #$C0                ; \ 
CODE_0585B0:        0A            ASL                       ;  | 
CODE_0585B1:        2A            ROL                       ;  |Get item memory settings 
CODE_0585B2:        2A            ROL                       ;  | 
CODE_0585B3:        8D BE 13      STA.W $13BE               ; / 
CODE_0585B6:        B7 65         LDA [$65],Y               ; Reload fifth byte 
CODE_0585B8:        29 30         AND.B #$30                ; \ 
CODE_0585BA:        4A            LSR                       ;  |Get horizontal/vertical scroll 
CODE_0585BB:        4A            LSR                       ;  | 
CODE_0585BC:        4A            LSR                       ;  | 
CODE_0585BD:        4A            LSR                       ;  | 
CODE_0585BE:        C9 03         CMP.B #$03                ;  | \ 
CODE_0585C0:        D0 05         BNE HeaderVHscroll        ;  |  |If scroll mode is x03, disable both 
CODE_0585C2:        9C 11 14      STZ.W $1411               ;  |  |vertical and horizontal scroll 
CODE_0585C5:        A9 00         LDA.B #$00                ;  | / 
HeaderVHscroll:     8D 12 14      STA.W $1412               ; / 
CODE_0585CA:        A5 65         LDA $65                   ; \ 
CODE_0585CC:        18            CLC                       ;  | 
CODE_0585CD:        69 05         ADC.B #$05                ;  | 
CODE_0585CF:        85 65         STA $65                   ;  |Make $65 point at the level data 
CODE_0585D1:        A5 66         LDA $66                   ;  |(Level data comes right after the header) 
CODE_0585D3:        69 00         ADC.B #$00                ;  | 
CODE_0585D5:        85 66         STA $66                   ; / 
Return0585D7:       60            RTS                       ; We're done! 

CODE_0585D8:        A5 5A         LDA $5A                   
CODE_0585DA:        D0 06         BNE CODE_0585E2           
CODE_0585DC:        A5 59         LDA $59                   
CODE_0585DE:        C9 02         CMP.B #$02                
CODE_0585E0:        90 1C         BCC Return0585FE          
CODE_0585E2:        A5 0A         LDA $0A                   
CODE_0585E4:        29 0F         AND.B #$0F                
CODE_0585E6:        85 00         STA $00                   
CODE_0585E8:        A5 0B         LDA $0B                   
CODE_0585EA:        29 0F         AND.B #$0F                
CODE_0585EC:        85 01         STA $01                   
CODE_0585EE:        A5 0A         LDA $0A                   
CODE_0585F0:        29 F0         AND.B #$F0                
CODE_0585F2:        05 01         ORA $01                   
CODE_0585F4:        85 0A         STA $0A                   
CODE_0585F6:        A5 0B         LDA $0B                   
CODE_0585F8:        29 F0         AND.B #$F0                
CODE_0585FA:        05 00         ORA $00                   
CODE_0585FC:        85 0B         STA $0B                   
Return0585FE:       60            RTS                       ; Return 

LoadLevelData:      E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_058601:        A0 00         LDY.B #$00                ; \ 
CODE_058603:        B7 65         LDA [$65],Y               ;  | 
CODE_058605:        85 0A         STA $0A                   ;  | 
CODE_058607:        C8            INY                       ;  | 
CODE_058608:        B7 65         LDA [$65],Y               ;  |Read three bytes of level data 
CODE_05860A:        85 0B         STA $0B                   ;  |Store them in $0A, $0B and $59 
CODE_05860C:        C8            INY                       ;  | 
CODE_05860D:        B7 65         LDA [$65],Y               ;  | 
CODE_05860F:        85 59         STA $59                   ;  | 
CODE_058611:        C8            INY                       ; / 
CODE_058612:        98            TYA                       ; \ 
CODE_058613:        18            CLC                       ;  | 
CODE_058614:        65 65         ADC $65                   ;  | 
CODE_058616:        85 65         STA $65                   ;  |Increase address by 3 (as 3 bytes were read) 
CODE_058618:        A5 66         LDA $66                   ;  | 
CODE_05861A:        69 00         ADC.B #$00                ;  | 
CODE_05861C:        85 66         STA $66                   ; / 
CODE_05861E:        A5 0B         LDA $0B                   ; \ 
CODE_058620:        4A            LSR                       ;  | 
CODE_058621:        4A            LSR                       ;  | 
CODE_058622:        4A            LSR                       ;  | 
CODE_058623:        4A            LSR                       ;  | 
CODE_058624:        85 5A         STA $5A                   ;  |Get block number, store in $5A 
CODE_058626:        A5 0A         LDA $0A                   ;  | 
CODE_058628:        29 60         AND.B #$60                ;  | 
CODE_05862A:        4A            LSR                       ;  | 
CODE_05862B:        05 5A         ORA $5A                   ;  | 
CODE_05862D:        85 5A         STA $5A                   ; / 
CODE_05862F:        A5 5B         LDA RAM_IsVerticalLvl     ; A = vertical level setting 
CODE_058631:        AC 33 19      LDY.W $1933               ; \ 
CODE_058634:        F0 01         BEQ CODE_058637           ;  |If $1933=x00, divide A by 2 
CODE_058636:        4A            LSR                       ; / 
CODE_058637:        29 01         AND.B #$01                ; \ 
CODE_058639:        F0 03         BEQ CODE_05863E           ;  |If lowest bit of A is set, jump to sub 
CODE_05863B:        20 D8 85      JSR.W CODE_0585D8         ; / 
CODE_05863E:        A5 0A         LDA $0A                   ; \ 
CODE_058640:        29 0F         AND.B #$0F                ;  | 
CODE_058642:        0A            ASL                       ;  | 
CODE_058643:        0A            ASL                       ;  | 
CODE_058644:        0A            ASL                       ;  |Set upper half of $57 to Y pos 
CODE_058645:        0A            ASL                       ;  |and lower half of $57 to X pos 
CODE_058646:        85 57         STA $57                   ;  | 
CODE_058648:        A5 0B         LDA $0B                   ;  | 
CODE_05864A:        29 0F         AND.B #$0F                ;  | 
CODE_05864C:        05 57         ORA $57                   ;  | 
CODE_05864E:        85 57         STA $57                   ; / 
CODE_058650:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058652:        AD 33 19      LDA.W $1933               ; \ 
CODE_058655:        29 FF 00      AND.W #$00FF              ;  |Load $1993*2 into X 
CODE_058658:        0A            ASL                       ;  | 
CODE_058659:        AA            TAX                       ; / 
CODE_05865A:        BF A8 BE 00   LDA.L LoadBlkPtrs,X       
CODE_05865E:        85 03         STA $03                   
CODE_058660:        BF AC BE 00   LDA.L LoadBlkTable2,X     
CODE_058664:        85 06         STA $06                   
CODE_058666:        AD 25 19      LDA.W $1925               ; \ 
CODE_058669:        29 1F 00      AND.W #$001F              ;  |Set Y to Level Mode*2 
CODE_05866C:        0A            ASL                       ;  | 
CODE_05866D:        A8            TAY                       ; / 
CODE_05866E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058670:        A9 00         LDA.B #$00                
CODE_058672:        85 05         STA $05                   
CODE_058674:        85 08         STA $08                   
CODE_058676:        B7 03         LDA [$03],Y               
CODE_058678:        85 00         STA $00                   
CODE_05867A:        B7 06         LDA [$06],Y               
CODE_05867C:        85 0D         STA $0D                   
CODE_05867E:        C8            INY                       
CODE_05867F:        B7 03         LDA [$03],Y               
CODE_058681:        85 01         STA $01                   
CODE_058683:        B7 06         LDA [$06],Y               
CODE_058685:        85 0E         STA $0E                   
CODE_058687:        A9 00         LDA.B #$00                
CODE_058689:        85 02         STA $02                   
CODE_05868B:        85 0F         STA $0F                   
CODE_05868D:        A5 0A         LDA $0A                   ; \ 
CODE_05868F:        29 80         AND.B #$80                ;  | 
CODE_058691:        0A            ASL                       ;  |If New Page flag is set, increase $1928 by 1 
CODE_058692:        6D 28 19      ADC.W $1928               ;  |(A = $1928) 
CODE_058695:        8D 28 19      STA.W $1928               ; / 
CODE_058698:        8D A1 1B      STA.W $1BA1               ; Store A in $1BA1 
CODE_05869B:        0A            ASL                       ; \ 
CODE_05869C:        18            CLC                       ;  |Multiply A by 2 and add $1928 to it 
CODE_05869D:        6D 28 19      ADC.W $1928               ;  |Set Y to A 
CODE_0586A0:        A8            TAY                       ; / 
CODE_0586A1:        B7 00         LDA [$00],Y               
CODE_0586A3:        85 6B         STA $6B                   
CODE_0586A5:        B7 0D         LDA [$0D],Y               
CODE_0586A7:        85 6E         STA $6E                   
CODE_0586A9:        C8            INY                       
CODE_0586AA:        B7 00         LDA [$00],Y               
CODE_0586AC:        85 6C         STA $6C                   
CODE_0586AE:        B7 0D         LDA [$0D],Y               
CODE_0586B0:        85 6F         STA $6F                   
CODE_0586B2:        C8            INY                       
CODE_0586B3:        B7 00         LDA [$00],Y               
CODE_0586B5:        85 6D         STA $6D                   
CODE_0586B7:        B7 0D         LDA [$0D],Y               
CODE_0586B9:        85 70         STA $70                   
CODE_0586BB:        A5 0A         LDA $0A                   ; \ 
CODE_0586BD:        29 10         AND.B #$10                ;  |If high coordinate is set... 
CODE_0586BF:        F0 04         BEQ LoadNoHiCoord         ;  |(Lower half of horizontal level) 
CODE_0586C1:        E6 6C         INC $6C                   ;  |(Right half of vertical level) 
CODE_0586C3:        E6 6F         INC $6F                   ;  |...increase $6C and $6F 
LoadNoHiCoord:      A5 5A         LDA $5A                   ; \ 
CODE_0586C7:        D0 06         BNE LevLoadJsrNrm         ;  |If block number is x00 (extended object), 
CODE_0586C9:        20 E3 86      JSR.W LevLoadExtObj       ;  |Jump to sub LevLoadExtObj 
CODE_0586CC:        4C D2 86      JMP.W LevLoadContinue     ;  |                  (Why didn't they use BRA here?) 

LevLoadJsrNrm:      20 EA 86      JSR.W LevLoadNrmObj       ;  |Jump to sub LevLoadNrmObj 
LevLoadContinue:    E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0586D4:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_0586D6:        A0 00 00      LDY.W #$0000              ; \ 
CODE_0586D9:        B7 65         LDA [$65],Y               ;  | 
CODE_0586DB:        C9 FF         CMP.B #$FF                ;  |If the next byte is xFF, return (loading is done). 
CODE_0586DD:        F0 03         BEQ LevelDataEnd          ;  |Otherwise, repeat this routine. 
CODE_0586DF:        4C FF 85      JMP.W LoadLevelData       ;  | 

LevelDataEnd:       60            RTS                       ; / 

LevLoadExtObj:      E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_0586E5:        22 00 A1 0D   JSL.L CODE_0DA100         
Return0586E9:       60            RTS                       ; Return 

LevLoadNrmObj:      E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_0586EC:        22 0F A4 0D   JSL.L CODE_0DA40F         
Return0586F0:       60            RTS                       ; Return 

CODE_0586F1:        08            PHP                       
CODE_0586F2:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_0586F4:        20 7E 87      JSR.W CODE_05877E         
CODE_0586F7:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0586F9:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_0586FB:        29 01         AND.B #$01                
CODE_0586FD:        D0 14         BNE CODE_058713           
CODE_0586FF:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058701:        A5 55         LDA $55                   
CODE_058703:        29 FF 00      AND.W #$00FF              
CODE_058706:        AA            TAX                       
CODE_058707:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_058709:        29 F0 FF      AND.W #$FFF0              
CODE_05870C:        D5 4D         CMP $4D,X                 
CODE_05870E:        F0 27         BEQ CODE_058737           
CODE_058710:        4C 24 87      JMP.W CODE_058724         

CODE_058713:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058715:        A5 55         LDA $55                   
CODE_058717:        29 FF 00      AND.W #$00FF              
CODE_05871A:        AA            TAX                       
CODE_05871B:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_05871D:        29 F0 FF      AND.W #$FFF0              
CODE_058720:        D5 4D         CMP $4D,X                 
CODE_058722:        F0 13         BEQ CODE_058737           
CODE_058724:        95 4D         STA $4D,X                 
CODE_058726:        8A            TXA                       
CODE_058727:        49 02 00      EOR.W #$0002              
CODE_05872A:        AA            TAX                       
CODE_05872B:        A9 FF FF      LDA.W #$FFFF              
CODE_05872E:        95 4D         STA $4D,X                 
CODE_058730:        22 1A 88 05   JSL.L CODE_05881A         
CODE_058734:        4C 74 87      JMP.W CODE_058774         

CODE_058737:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058739:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_05873B:        29 02         AND.B #$02                
CODE_05873D:        D0 14         BNE CODE_058753           
CODE_05873F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058741:        A5 56         LDA $56                   
CODE_058743:        29 FF 00      AND.W #$00FF              
CODE_058746:        AA            TAX                       
CODE_058747:        A5 1E         LDA $1E                   
CODE_058749:        29 F0 FF      AND.W #$FFF0              
CODE_05874C:        D5 51         CMP $51,X                 
CODE_05874E:        F0 24         BEQ CODE_058774           
CODE_058750:        4C 64 87      JMP.W CODE_058764         

CODE_058753:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058755:        A5 56         LDA $56                   
CODE_058757:        29 FF 00      AND.W #$00FF              
CODE_05875A:        AA            TAX                       
CODE_05875B:        A5 20         LDA $20                   
CODE_05875D:        29 F0 FF      AND.W #$FFF0              
CODE_058760:        D5 51         CMP $51,X                 
CODE_058762:        F0 10         BEQ CODE_058774           
CODE_058764:        95 51         STA $51,X                 
CODE_058766:        8A            TXA                       
CODE_058767:        49 02 00      EOR.W #$0002              
CODE_05876A:        AA            TAX                       
CODE_05876B:        A9 FF FF      LDA.W #$FFFF              
CODE_05876E:        95 51         STA $51,X                 
CODE_058770:        22 83 88 05   JSL.L CODE_058883         
CODE_058774:        28            PLP                       
Return058775:       6B            RTL                       ; Return 


MAP16AppTable:                    .db $B0,$8A,$E0,$84,$F0,$8A,$30,$8B

CODE_05877E:        08            PHP                       
CODE_05877F:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058781:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_058783:        29 01         AND.B #$01                
CODE_058785:        D0 44         BNE CODE_0587CB           
CODE_058787:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058789:        A5 1A         LDA RAM_ScreenBndryXLo    ; Load "Xpos of Screen Boundary" 
CODE_05878B:        4A            LSR                       ; \ 
CODE_05878C:        4A            LSR                       ;  |Multiply by 16 
CODE_05878D:        4A            LSR                       ;  | 
CODE_05878E:        4A            LSR                       ; / 
CODE_05878F:        A8            TAY                       
CODE_058790:        38            SEC                       ; \ 
CODE_058791:        E9 08 00      SBC.W #$0008              ; /Subtract 8 
CODE_058794:        85 45         STA $45                   ; Store to $45 (Seems to be Scratch RAM) 
CODE_058796:        98            TYA                       ; Get back the multiplied XPos 
CODE_058797:        18            CLC                       
CODE_058798:        69 17 00      ADC.W #$0017              ; Add $17 
CODE_05879B:        85 47         STA $47                   ; Store to $47 (Seems to be Scratch RAM) 
CODE_05879D:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_05879F:        A5 55         LDA $55                   ; \ 
CODE_0587A1:        AA            TAX                       ;  | LDA $45,x  / $55 
CODE_0587A2:        B5 45         LDA $45,X                 ; / 
CODE_0587A4:        4A            LSR                       ; \ multiply by 8 
CODE_0587A5:        4A            LSR                       ;  | 
CODE_0587A6:        4A            LSR                       ; / 
CODE_0587A7:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_0587A9:        29 06 00      AND.W #$0006              ; AND to make it either 6, 4, 2, or 0. 
CODE_0587AC:        AA            TAX                       
CODE_0587AD:        A9 33 01      LDA.W #$0133              ; \LDY #$0266 
CODE_0587B0:        0A            ASL                       ; | 
CODE_0587B1:        A8            TAY                       ; / 
CODE_0587B2:        A9 07 00      LDA.W #$0007              
CODE_0587B5:        85 00         STA $00                   
CODE_0587B7:        BF 76 87 05   LDA.L MAP16AppTable,X     
CODE_0587BB:        99 BE 0F      STA.W $0FBE,Y             ; MAP16 pointer table 
CODE_0587BE:        C8            INY                       
CODE_0587BF:        C8            INY                       
CODE_0587C0:        18            CLC                       
CODE_0587C1:        69 08 00      ADC.W #$0008              ; 8 bytes per tile? 
CODE_0587C4:        C6 00         DEC $00                   
CODE_0587C6:        10 F3         BPL CODE_0587BB           
CODE_0587C8:        4C E1 87      JMP.W CODE_0587E1         

CODE_0587CB:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0587CD:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_0587CF:        4A            LSR                       
CODE_0587D0:        4A            LSR                       
CODE_0587D1:        4A            LSR                       
CODE_0587D2:        4A            LSR                       
CODE_0587D3:        A8            TAY                       
CODE_0587D4:        38            SEC                       
CODE_0587D5:        E9 08 00      SBC.W #$0008              
CODE_0587D8:        85 45         STA $45                   
CODE_0587DA:        98            TYA                       
CODE_0587DB:        18            CLC                       
CODE_0587DC:        69 17 00      ADC.W #$0017              
CODE_0587DF:        85 47         STA $47                   
CODE_0587E1:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0587E3:        A5 5B         LDA RAM_IsVerticalLvl     ; Load the vertical level flag 
CODE_0587E5:        29 02         AND.B #$02                ; \if bit 1 is set, process based on that 
CODE_0587E7:        D0 19         BNE CODE_058802           ; / 
CODE_0587E9:        C2 20         REP #$20                  ; Not a vertical level ; Accum (16 bit) 
CODE_0587EB:        A5 1E         LDA $1E                   ; \Y = L2XPos * 16 
CODE_0587ED:        4A            LSR                       ; | 
CODE_0587EE:        4A            LSR                       ; | 
CODE_0587EF:        4A            LSR                       ; | 
CODE_0587F0:        4A            LSR                       ; | 
CODE_0587F1:        A8            TAY                       ; / 
CODE_0587F2:        38            SEC                       
CODE_0587F3:        E9 08 00      SBC.W #$0008              
CODE_0587F6:        85 49         STA $49                   
CODE_0587F8:        98            TYA                       
CODE_0587F9:        18            CLC                       
CODE_0587FA:        69 17 00      ADC.W #$0017              
CODE_0587FD:        85 4B         STA $4B                   
CODE_0587FF:        4C 18 88      JMP.W CODE_058818         

CODE_058802:        C2 20         REP #$20                  ; \A = Y = $04*16 (?) ; Accum (16 bit) 
CODE_058804:        A5 20         LDA $20                   ; | 
CODE_058806:        4A            LSR                       ; | 
CODE_058807:        4A            LSR                       ; | 
CODE_058808:        4A            LSR                       ; | 
CODE_058809:        4A            LSR                       ; | 
CODE_05880A:        A8            TAY                       ; / 
CODE_05880B:        38            SEC                       ; \ 
CODE_05880C:        E9 08 00      SBC.W #$0008              ;  |Subtract x08 and store in $49 
CODE_05880F:        85 49         STA $49                   ; / 
CODE_058811:        98            TYA                       ; \ 
CODE_058812:        18            CLC                       ;  |"Undo", add x17 and store in $4B 
CODE_058813:        69 17 00      ADC.W #$0017              ;  | 
CODE_058816:        85 4B         STA $4B                   ; / 
CODE_058818:        28            PLP                       
Return058819:       60            RTS                       ; Return 

CODE_05881A:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_05881C:        AD 25 19      LDA.W $1925               
CODE_05881F:        22 FA 86 00   JSL.L ExecutePtrLong      

PtrsLong058823:        CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       9B 8A 05   .dw CODE_058A9B .db :$CODE_058A9B 
                       9B 8A 05   .dw CODE_058A9B .db :$CODE_058A9B 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       9B 8A 05   .dw CODE_058A9B .db :$CODE_058A9B 
                       9B 8A 05   .dw CODE_058A9B .db :$CODE_058A9B 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9B 8A 05   .dw CODE_058A9B .db :$CODE_058A9B 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       9B 8A 05   .dw CODE_058A9B .db :$CODE_058A9B 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 

CODE_058883:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_058885:        AD 25 19      LDA.W $1925               
CODE_058888:        22 FA 86 00   JSL.L ExecutePtrLong      

PtrsLong05888C:        70 8C 05   .dw Return058C70 .db :$Return058C70 
                       8D 8B 05   .dw CODE_058B8D .db :$CODE_058B8D 
                       8D 8B 05   .dw CODE_058B8D .db :$CODE_058B8D 
                       8D 8B 05   .dw CODE_058B8D .db :$CODE_058B8D 
                       8D 8B 05   .dw CODE_058B8D .db :$CODE_058B8D 
                       71 8C 05   .dw CODE_058C71 .db :$CODE_058C71 
                       71 8C 05   .dw CODE_058C71 .db :$CODE_058C71 
                       71 8C 05   .dw CODE_058C71 .db :$CODE_058C71 
                       71 8C 05   .dw CODE_058C71 .db :$CODE_058C71 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       8D 8B 05   .dw CODE_058B8D .db :$CODE_058B8D 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       8D 8B 05   .dw CODE_058B8D .db :$CODE_058B8D 

CODE_0588EC:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_0588EE:        AD 25 19      LDA.W $1925               
CODE_0588F1:        22 FA 86 00   JSL.L ExecutePtrLong      

PtrsLong0588F5:        CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       9B 8A 05   .dw CODE_058A9B .db :$CODE_058A9B 
                       9B 8A 05   .dw CODE_058A9B .db :$CODE_058A9B 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       9B 8A 05   .dw CODE_058A9B .db :$CODE_058A9B 
                       9B 8A 05   .dw CODE_058A9B .db :$CODE_058A9B 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9B 8A 05   .dw CODE_058A9B .db :$CODE_058A9B 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       9B 8A 05   .dw CODE_058A9B .db :$CODE_058A9B 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       9A 8A 05   .dw Return058A9A .db :$Return058A9A 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 
                       CE 89 05   .dw CODE_0589CE .db :$CODE_0589CE 

CODE_058955:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_058957:        AD 25 19      LDA.W $1925               
CODE_05895A:        22 FA 86 00   JSL.L ExecutePtrLong      

PtrsLong05895E:        7A 8D 05   .dw CODE_058D7A .db :$CODE_058D7A 
                       8D 8B 05   .dw CODE_058B8D .db :$CODE_058B8D 
                       8D 8B 05   .dw CODE_058B8D .db :$CODE_058B8D 
                       8D 8B 05   .dw CODE_058B8D .db :$CODE_058B8D 
                       8D 8B 05   .dw CODE_058B8D .db :$CODE_058B8D 
                       71 8C 05   .dw CODE_058C71 .db :$CODE_058C71 
                       71 8C 05   .dw CODE_058C71 .db :$CODE_058C71 
                       71 8C 05   .dw CODE_058C71 .db :$CODE_058C71 
                       71 8C 05   .dw CODE_058C71 .db :$CODE_058C71 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       7A 8D 05   .dw CODE_058D7A .db :$CODE_058D7A 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       7A 8D 05   .dw CODE_058D7A .db :$CODE_058D7A 
                       7A 8D 05   .dw CODE_058D7A .db :$CODE_058D7A 
                       7A 8D 05   .dw CODE_058D7A .db :$CODE_058D7A 
                       8D 8B 05   .dw CODE_058B8D .db :$CODE_058B8D 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       7A 8D 05   .dw CODE_058D7A .db :$CODE_058D7A 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       70 8C 05   .dw Return058C70 .db :$Return058C70 
                       7A 8D 05   .dw CODE_058D7A .db :$CODE_058D7A 
                       8D 8B 05   .dw CODE_058B8D .db :$CODE_058B8D 

DATA_0589BE:                      .db $80,$00,$40,$00,$20,$00,$10,$00
                                  .db $08,$00,$04,$00,$02,$00,$01,$00

CODE_0589CE:        08            PHP                       
CODE_0589CF:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_0589D1:        AD 25 19      LDA.W $1925               
CODE_0589D4:        29 FF 00      AND.W #$00FF              
CODE_0589D7:        0A            ASL                       
CODE_0589D8:        AA            TAX                       
CODE_0589D9:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0589DB:        BF A8 BD 00   LDA.L Ptrs00BDA8,X        
CODE_0589DF:        85 0A         STA $0A                   
CODE_0589E1:        BF A9 BD 00   LDA.L Ptrs00BDA8+1,X      
CODE_0589E5:        85 0B         STA $0B                   
CODE_0589E7:        BF 28 BE 00   LDA.L Ptrs00BE28,X        
CODE_0589EB:        85 0D         STA $0D                   
CODE_0589ED:        BF 29 BE 00   LDA.L Ptrs00BE28+1,X      
CODE_0589F1:        85 0E         STA $0E                   
CODE_0589F3:        A9 00         LDA.B #$00                
CODE_0589F5:        85 0C         STA $0C                   
CODE_0589F7:        85 0F         STA $0F                   
CODE_0589F9:        A5 55         LDA $55                   
CODE_0589FB:        AA            TAX                       
CODE_0589FC:        B5 45         LDA $45,X                 
CODE_0589FE:        29 0F         AND.B #$0F                
CODE_058A00:        0A            ASL                       
CODE_058A01:        8D E5 1B      STA.W $1BE5               
CODE_058A04:        A0 20 00      LDY.W #$0020              
CODE_058A07:        B5 45         LDA $45,X                 
CODE_058A09:        29 10         AND.B #$10                
CODE_058A0B:        F0 03         BEQ CODE_058A10           
CODE_058A0D:        A0 24 00      LDY.W #$0024              
CODE_058A10:        98            TYA                       
CODE_058A11:        8D E4 1B      STA.W $1BE4               
CODE_058A14:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058A16:        B5 45         LDA $45,X                 
CODE_058A18:        29 F0 01      AND.W #$01F0              
CODE_058A1B:        4A            LSR                       
CODE_058A1C:        4A            LSR                       
CODE_058A1D:        4A            LSR                       
CODE_058A1E:        4A            LSR                       
CODE_058A1F:        85 00         STA $00                   
CODE_058A21:        0A            ASL                       
CODE_058A22:        18            CLC                       
CODE_058A23:        65 00         ADC $00                   
CODE_058A25:        A8            TAY                       
CODE_058A26:        B7 0A         LDA [$0A],Y               
CODE_058A28:        85 6B         STA $6B                   
CODE_058A2A:        B7 0D         LDA [$0D],Y               
CODE_058A2C:        85 6E         STA $6E                   
CODE_058A2E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058A30:        C8            INY                       
CODE_058A31:        C8            INY                       
CODE_058A32:        B7 0A         LDA [$0A],Y               
CODE_058A34:        85 6D         STA $6D                   
CODE_058A36:        B7 0D         LDA [$0D],Y               
CODE_058A38:        85 70         STA $70                   
CODE_058A3A:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_058A3C:        A0 0D         LDY.B #$0D                
CODE_058A3E:        AD 31 19      LDA.W $1931               
CODE_058A41:        C9 10         CMP.B #$10                
CODE_058A43:        30 02         BMI CODE_058A47           
ADDR_058A45:        A0 05         LDY.B #$05                
CODE_058A47:        84 0C         STY $0C                   
CODE_058A49:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_058A4B:        B5 45         LDA $45,X                 
CODE_058A4D:        29 0F 00      AND.W #$000F              
CODE_058A50:        85 08         STA $08                   
CODE_058A52:        A2 00 00      LDX.W #$0000              
CODE_058A55:        A4 08         LDY $08                   
CODE_058A57:        B7 6B         LDA [$6B],Y               
CODE_058A59:        29 FF 00      AND.W #$00FF              
CODE_058A5C:        85 00         STA $00                   
CODE_058A5E:        B7 6E         LDA [$6E],Y               
CODE_058A60:        85 01         STA $01                   
CODE_058A62:        A5 00         LDA $00                   
CODE_058A64:        0A            ASL                       
CODE_058A65:        A8            TAY                       
CODE_058A66:        B9 BE 0F      LDA.W $0FBE,Y             
CODE_058A69:        85 0A         STA $0A                   
CODE_058A6B:        A0 00 00      LDY.W #$0000              
CODE_058A6E:        B7 0A         LDA [$0A],Y               
CODE_058A70:        9D E6 1B      STA.W $1BE6,X             
CODE_058A73:        C8            INY                       
CODE_058A74:        C8            INY                       
CODE_058A75:        B7 0A         LDA [$0A],Y               
CODE_058A77:        9D E8 1B      STA.W $1BE8,X             
CODE_058A7A:        C8            INY                       
CODE_058A7B:        C8            INY                       
CODE_058A7C:        B7 0A         LDA [$0A],Y               
CODE_058A7E:        9D 66 1C      STA.W $1C66,X             
CODE_058A81:        C8            INY                       
CODE_058A82:        C8            INY                       
CODE_058A83:        B7 0A         LDA [$0A],Y               
CODE_058A85:        9D 68 1C      STA.W $1C68,X             
CODE_058A88:        E8            INX                       
CODE_058A89:        E8            INX                       
CODE_058A8A:        E8            INX                       
CODE_058A8B:        E8            INX                       
CODE_058A8C:        A5 08         LDA $08                   
CODE_058A8E:        18            CLC                       
CODE_058A8F:        69 10 00      ADC.W #$0010              
CODE_058A92:        85 08         STA $08                   
CODE_058A94:        C9 B0 01      CMP.W #$01B0              
CODE_058A97:        90 BC         BCC CODE_058A55           
CODE_058A99:        28            PLP                       
Return058A9A:       6B            RTL                       ; Return 

CODE_058A9B:        08            PHP                       
CODE_058A9C:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_058A9E:        AD 25 19      LDA.W $1925               
CODE_058AA1:        29 FF 00      AND.W #$00FF              
CODE_058AA4:        0A            ASL                       
CODE_058AA5:        AA            TAX                       
CODE_058AA6:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058AA8:        BF A8 BD 00   LDA.L Ptrs00BDA8,X        
CODE_058AAC:        85 0A         STA $0A                   
CODE_058AAE:        BF A9 BD 00   LDA.L Ptrs00BDA8+1,X      
CODE_058AB2:        85 0B         STA $0B                   
CODE_058AB4:        BF 28 BE 00   LDA.L Ptrs00BE28,X        
CODE_058AB8:        85 0D         STA $0D                   
CODE_058ABA:        BF 29 BE 00   LDA.L Ptrs00BE28+1,X      
CODE_058ABE:        85 0E         STA $0E                   
CODE_058AC0:        A9 00         LDA.B #$00                
CODE_058AC2:        85 0C         STA $0C                   
CODE_058AC4:        85 0F         STA $0F                   
CODE_058AC6:        A5 55         LDA $55                   
CODE_058AC8:        AA            TAX                       
CODE_058AC9:        A0 20 00      LDY.W #$0020              
CODE_058ACC:        B5 45         LDA $45,X                 
CODE_058ACE:        29 10         AND.B #$10                
CODE_058AD0:        F0 03         BEQ CODE_058AD5           
CODE_058AD2:        A0 28 00      LDY.W #$0028              
CODE_058AD5:        98            TYA                       
CODE_058AD6:        85 00         STA $00                   
CODE_058AD8:        B5 45         LDA $45,X                 
CODE_058ADA:        4A            LSR                       
CODE_058ADB:        4A            LSR                       
CODE_058ADC:        29 03         AND.B #$03                
CODE_058ADE:        05 00         ORA $00                   
CODE_058AE0:        8D E4 1B      STA.W $1BE4               
CODE_058AE3:        B5 45         LDA $45,X                 
CODE_058AE5:        29 03         AND.B #$03                
CODE_058AE7:        0A            ASL                       
CODE_058AE8:        0A            ASL                       
CODE_058AE9:        0A            ASL                       
CODE_058AEA:        0A            ASL                       
CODE_058AEB:        0A            ASL                       
CODE_058AEC:        0A            ASL                       
CODE_058AED:        8D E5 1B      STA.W $1BE5               
CODE_058AF0:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058AF2:        B5 45         LDA $45,X                 
CODE_058AF4:        29 F0 01      AND.W #$01F0              
CODE_058AF7:        4A            LSR                       
CODE_058AF8:        4A            LSR                       
CODE_058AF9:        4A            LSR                       
CODE_058AFA:        4A            LSR                       
CODE_058AFB:        85 00         STA $00                   
CODE_058AFD:        0A            ASL                       
CODE_058AFE:        18            CLC                       
CODE_058AFF:        65 00         ADC $00                   
CODE_058B01:        A8            TAY                       
CODE_058B02:        B7 0A         LDA [$0A],Y               
CODE_058B04:        85 6B         STA $6B                   
CODE_058B06:        B7 0D         LDA [$0D],Y               
CODE_058B08:        85 6E         STA $6E                   
CODE_058B0A:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058B0C:        C8            INY                       
CODE_058B0D:        C8            INY                       
CODE_058B0E:        B7 0A         LDA [$0A],Y               
CODE_058B10:        85 6D         STA $6D                   
CODE_058B12:        B7 0D         LDA [$0D],Y               
CODE_058B14:        85 70         STA $70                   
CODE_058B16:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_058B18:        A0 0D         LDY.B #$0D                
CODE_058B1A:        AD 31 19      LDA.W $1931               
CODE_058B1D:        C9 10         CMP.B #$10                
CODE_058B1F:        30 02         BMI CODE_058B23           
CODE_058B21:        A0 05         LDY.B #$05                
CODE_058B23:        84 0C         STY $0C                   
CODE_058B25:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_058B27:        B5 45         LDA $45,X                 
CODE_058B29:        29 0F 00      AND.W #$000F              
CODE_058B2C:        0A            ASL                       
CODE_058B2D:        0A            ASL                       
CODE_058B2E:        0A            ASL                       
CODE_058B2F:        0A            ASL                       
CODE_058B30:        85 08         STA $08                   
CODE_058B32:        A2 00 00      LDX.W #$0000              
CODE_058B35:        A4 08         LDY $08                   
CODE_058B37:        B7 6B         LDA [$6B],Y               
CODE_058B39:        29 FF 00      AND.W #$00FF              
CODE_058B3C:        85 00         STA $00                   
CODE_058B3E:        B7 6E         LDA [$6E],Y               
CODE_058B40:        85 01         STA $01                   
CODE_058B42:        A5 00         LDA $00                   
CODE_058B44:        0A            ASL                       
CODE_058B45:        A8            TAY                       
CODE_058B46:        B9 BE 0F      LDA.W $0FBE,Y             
CODE_058B49:        85 0A         STA $0A                   
CODE_058B4B:        A0 00 00      LDY.W #$0000              
CODE_058B4E:        B7 0A         LDA [$0A],Y               
CODE_058B50:        9D E6 1B      STA.W $1BE6,X             
CODE_058B53:        C8            INY                       
CODE_058B54:        C8            INY                       
CODE_058B55:        B7 0A         LDA [$0A],Y               
CODE_058B57:        9D 66 1C      STA.W $1C66,X             
CODE_058B5A:        E8            INX                       
CODE_058B5B:        E8            INX                       
CODE_058B5C:        C8            INY                       
CODE_058B5D:        C8            INY                       
CODE_058B5E:        B7 0A         LDA [$0A],Y               
CODE_058B60:        9D E6 1B      STA.W $1BE6,X             
CODE_058B63:        C8            INY                       
CODE_058B64:        C8            INY                       
CODE_058B65:        B7 0A         LDA [$0A],Y               
CODE_058B67:        9D 66 1C      STA.W $1C66,X             
CODE_058B6A:        E8            INX                       
CODE_058B6B:        E8            INX                       
CODE_058B6C:        A5 08         LDA $08                   
CODE_058B6E:        A8            TAY                       
CODE_058B6F:        18            CLC                       
CODE_058B70:        69 01 00      ADC.W #$0001              
CODE_058B73:        85 08         STA $08                   
CODE_058B75:        29 0F 00      AND.W #$000F              
CODE_058B78:        D0 0A         BNE CODE_058B84           
CODE_058B7A:        98            TYA                       
CODE_058B7B:        29 F0 FF      AND.W #$FFF0              
CODE_058B7E:        18            CLC                       
CODE_058B7F:        69 00 01      ADC.W #$0100              
CODE_058B82:        85 08         STA $08                   
CODE_058B84:        A5 08         LDA $08                   
CODE_058B86:        29 0F 01      AND.W #$010F              
CODE_058B89:        D0 AA         BNE CODE_058B35           
CODE_058B8B:        28            PLP                       
Return058B8C:       6B            RTL                       ; Return 

CODE_058B8D:        08            PHP                       
CODE_058B8E:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_058B90:        AD 25 19      LDA.W $1925               
CODE_058B93:        29 FF 00      AND.W #$00FF              
CODE_058B96:        0A            ASL                       
CODE_058B97:        AA            TAX                       
CODE_058B98:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058B9A:        A0 00 00      LDY.W #$0000              
CODE_058B9D:        AD 31 19      LDA.W $1931               
CODE_058BA0:        C9 03         CMP.B #$03                
CODE_058BA2:        D0 03         BNE CODE_058BA7           
CODE_058BA4:        A0 00 10      LDY.W #$1000              
CODE_058BA7:        84 03         STY $03                   
CODE_058BA9:        BF E8 BD 00   LDA.L Ptrs00BDE8,X        
CODE_058BAD:        85 0A         STA $0A                   
CODE_058BAF:        BF E9 BD 00   LDA.L Ptrs00BDE8+1,X      
CODE_058BB3:        85 0B         STA $0B                   
CODE_058BB5:        BF 68 BE 00   LDA.L Ptrs00BE68,X        
CODE_058BB9:        85 0D         STA $0D                   
CODE_058BBB:        BF 69 BE 00   LDA.L Ptrs00BE68+1,X      
CODE_058BBF:        85 0E         STA $0E                   
CODE_058BC1:        A9 00         LDA.B #$00                
CODE_058BC3:        85 0C         STA $0C                   
CODE_058BC5:        85 0F         STA $0F                   
CODE_058BC7:        A5 56         LDA $56                   
CODE_058BC9:        AA            TAX                       
CODE_058BCA:        B5 49         LDA $49,X                 
CODE_058BCC:        29 0F         AND.B #$0F                
CODE_058BCE:        0A            ASL                       
CODE_058BCF:        8D E7 1C      STA.W $1CE7               
CODE_058BD2:        A0 30 00      LDY.W #$0030              
CODE_058BD5:        B5 49         LDA $49,X                 
CODE_058BD7:        29 10         AND.B #$10                
CODE_058BD9:        F0 03         BEQ CODE_058BDE           
CODE_058BDB:        A0 34 00      LDY.W #$0034              
CODE_058BDE:        98            TYA                       
CODE_058BDF:        8D E6 1C      STA.W $1CE6               
CODE_058BE2:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_058BE4:        B5 49         LDA $49,X                 
CODE_058BE6:        29 F0 01      AND.W #$01F0              
CODE_058BE9:        4A            LSR                       
CODE_058BEA:        4A            LSR                       
CODE_058BEB:        4A            LSR                       
CODE_058BEC:        4A            LSR                       
CODE_058BED:        85 00         STA $00                   
CODE_058BEF:        0A            ASL                       
CODE_058BF0:        18            CLC                       
CODE_058BF1:        65 00         ADC $00                   
CODE_058BF3:        A8            TAY                       
CODE_058BF4:        B7 0A         LDA [$0A],Y               
CODE_058BF6:        85 6B         STA $6B                   
CODE_058BF8:        B7 0D         LDA [$0D],Y               
CODE_058BFA:        85 6E         STA $6E                   
CODE_058BFC:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058BFE:        C8            INY                       
CODE_058BFF:        C8            INY                       
CODE_058C00:        B7 0A         LDA [$0A],Y               
CODE_058C02:        85 6D         STA $6D                   
CODE_058C04:        B7 0D         LDA [$0D],Y               
CODE_058C06:        85 70         STA $70                   
CODE_058C08:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_058C0A:        A0 0D         LDY.B #$0D                
CODE_058C0C:        AD 31 19      LDA.W $1931               
CODE_058C0F:        C9 10         CMP.B #$10                
CODE_058C11:        30 02         BMI CODE_058C15           
ADDR_058C13:        A0 05         LDY.B #$05                
CODE_058C15:        84 0C         STY $0C                   
CODE_058C17:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_058C19:        B5 49         LDA $49,X                 
CODE_058C1B:        29 0F 00      AND.W #$000F              
CODE_058C1E:        85 08         STA $08                   
CODE_058C20:        A2 00 00      LDX.W #$0000              
CODE_058C23:        A4 08         LDY $08                   
CODE_058C25:        B7 6B         LDA [$6B],Y               
CODE_058C27:        29 FF 00      AND.W #$00FF              
CODE_058C2A:        85 00         STA $00                   
CODE_058C2C:        B7 6E         LDA [$6E],Y               
CODE_058C2E:        85 01         STA $01                   
CODE_058C30:        A5 00         LDA $00                   
CODE_058C32:        0A            ASL                       
CODE_058C33:        A8            TAY                       
CODE_058C34:        B9 BE 0F      LDA.W $0FBE,Y             
CODE_058C37:        85 0A         STA $0A                   
CODE_058C39:        A0 00 00      LDY.W #$0000              
CODE_058C3C:        B7 0A         LDA [$0A],Y               
CODE_058C3E:        05 03         ORA $03                   
CODE_058C40:        9D E8 1C      STA.W $1CE8,X             
CODE_058C43:        C8            INY                       
CODE_058C44:        C8            INY                       
CODE_058C45:        B7 0A         LDA [$0A],Y               
CODE_058C47:        05 03         ORA $03                   
CODE_058C49:        9D EA 1C      STA.W $1CEA,X             
CODE_058C4C:        C8            INY                       
CODE_058C4D:        C8            INY                       
CODE_058C4E:        B7 0A         LDA [$0A],Y               
CODE_058C50:        05 03         ORA $03                   
CODE_058C52:        9D 68 1D      STA.W $1D68,X             
CODE_058C55:        C8            INY                       
CODE_058C56:        C8            INY                       
CODE_058C57:        B7 0A         LDA [$0A],Y               
CODE_058C59:        05 03         ORA $03                   
CODE_058C5B:        9D 6A 1D      STA.W $1D6A,X             
CODE_058C5E:        E8            INX                       
CODE_058C5F:        E8            INX                       
CODE_058C60:        E8            INX                       
CODE_058C61:        E8            INX                       
CODE_058C62:        A5 08         LDA $08                   
CODE_058C64:        18            CLC                       
CODE_058C65:        69 10 00      ADC.W #$0010              
CODE_058C68:        85 08         STA $08                   
CODE_058C6A:        C9 B0 01      CMP.W #$01B0              
CODE_058C6D:        90 B4         BCC CODE_058C23           
CODE_058C6F:        28            PLP                       
Return058C70:       6B            RTL                       ; Return 

CODE_058C71:        08            PHP                       
CODE_058C72:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_058C74:        AD 25 19      LDA.W $1925               
CODE_058C77:        29 FF 00      AND.W #$00FF              
CODE_058C7A:        0A            ASL                       
CODE_058C7B:        AA            TAX                       
CODE_058C7C:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058C7E:        A0 00 00      LDY.W #$0000              
CODE_058C81:        AD 31 19      LDA.W $1931               
CODE_058C84:        C9 03         CMP.B #$03                
CODE_058C86:        D0 03         BNE CODE_058C8B           
ADDR_058C88:        A0 00 10      LDY.W #$1000              
CODE_058C8B:        84 03         STY $03                   
CODE_058C8D:        BF E8 BD 00   LDA.L Ptrs00BDE8,X        
CODE_058C91:        85 0A         STA $0A                   
CODE_058C93:        BF E9 BD 00   LDA.L Ptrs00BDE8+1,X      
CODE_058C97:        85 0B         STA $0B                   
CODE_058C99:        BF 68 BE 00   LDA.L Ptrs00BE68,X        
CODE_058C9D:        85 0D         STA $0D                   
CODE_058C9F:        BF 69 BE 00   LDA.L Ptrs00BE68+1,X      
CODE_058CA3:        85 0E         STA $0E                   
CODE_058CA5:        A9 00         LDA.B #$00                
CODE_058CA7:        85 0C         STA $0C                   
CODE_058CA9:        85 0F         STA $0F                   
CODE_058CAB:        A5 56         LDA $56                   
CODE_058CAD:        AA            TAX                       
CODE_058CAE:        A0 30 00      LDY.W #$0030              
CODE_058CB1:        B5 49         LDA $49,X                 
CODE_058CB3:        29 10         AND.B #$10                
CODE_058CB5:        F0 03         BEQ CODE_058CBA           
CODE_058CB7:        A0 38 00      LDY.W #$0038              
CODE_058CBA:        98            TYA                       
CODE_058CBB:        85 00         STA $00                   
CODE_058CBD:        B5 49         LDA $49,X                 
CODE_058CBF:        4A            LSR                       
CODE_058CC0:        4A            LSR                       
CODE_058CC1:        29 03         AND.B #$03                
CODE_058CC3:        05 00         ORA $00                   
CODE_058CC5:        8D E6 1C      STA.W $1CE6               
CODE_058CC8:        B5 49         LDA $49,X                 
CODE_058CCA:        29 03         AND.B #$03                
CODE_058CCC:        0A            ASL                       
CODE_058CCD:        0A            ASL                       
CODE_058CCE:        0A            ASL                       
CODE_058CCF:        0A            ASL                       
CODE_058CD0:        0A            ASL                       
CODE_058CD1:        0A            ASL                       
CODE_058CD2:        8D E7 1C      STA.W $1CE7               
CODE_058CD5:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058CD7:        B5 49         LDA $49,X                 
CODE_058CD9:        29 F0 01      AND.W #$01F0              
CODE_058CDC:        4A            LSR                       
CODE_058CDD:        4A            LSR                       
CODE_058CDE:        4A            LSR                       
CODE_058CDF:        4A            LSR                       
CODE_058CE0:        85 00         STA $00                   
CODE_058CE2:        0A            ASL                       
CODE_058CE3:        18            CLC                       
CODE_058CE4:        65 00         ADC $00                   
CODE_058CE6:        A8            TAY                       
CODE_058CE7:        B7 0A         LDA [$0A],Y               
CODE_058CE9:        85 6B         STA $6B                   
CODE_058CEB:        B7 0D         LDA [$0D],Y               
CODE_058CED:        85 6E         STA $6E                   
CODE_058CEF:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058CF1:        C8            INY                       
CODE_058CF2:        C8            INY                       
CODE_058CF3:        B7 0A         LDA [$0A],Y               
CODE_058CF5:        85 6D         STA $6D                   
CODE_058CF7:        B7 0D         LDA [$0D],Y               
CODE_058CF9:        85 70         STA $70                   
CODE_058CFB:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_058CFD:        A0 0D         LDY.B #$0D                
CODE_058CFF:        AD 31 19      LDA.W $1931               
CODE_058D02:        C9 10         CMP.B #$10                
CODE_058D04:        30 02         BMI CODE_058D08           
ADDR_058D06:        A0 05         LDY.B #$05                
CODE_058D08:        84 0C         STY $0C                   
CODE_058D0A:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_058D0C:        B5 49         LDA $49,X                 
CODE_058D0E:        29 0F 00      AND.W #$000F              
CODE_058D11:        0A            ASL                       
CODE_058D12:        0A            ASL                       
CODE_058D13:        0A            ASL                       
CODE_058D14:        0A            ASL                       
CODE_058D15:        85 08         STA $08                   
CODE_058D17:        A2 00 00      LDX.W #$0000              
CODE_058D1A:        A4 08         LDY $08                   
CODE_058D1C:        B7 6B         LDA [$6B],Y               
CODE_058D1E:        29 FF 00      AND.W #$00FF              
CODE_058D21:        85 00         STA $00                   
CODE_058D23:        B7 6E         LDA [$6E],Y               
CODE_058D25:        85 01         STA $01                   
CODE_058D27:        A5 00         LDA $00                   
CODE_058D29:        0A            ASL                       
CODE_058D2A:        A8            TAY                       
CODE_058D2B:        B9 BE 0F      LDA.W $0FBE,Y             
CODE_058D2E:        85 0A         STA $0A                   
CODE_058D30:        A0 00 00      LDY.W #$0000              
CODE_058D33:        B7 0A         LDA [$0A],Y               
CODE_058D35:        05 03         ORA $03                   
CODE_058D37:        9D E8 1C      STA.W $1CE8,X             
CODE_058D3A:        C8            INY                       
CODE_058D3B:        C8            INY                       
CODE_058D3C:        B7 0A         LDA [$0A],Y               
CODE_058D3E:        05 03         ORA $03                   
CODE_058D40:        9D 68 1D      STA.W $1D68,X             
CODE_058D43:        E8            INX                       
CODE_058D44:        E8            INX                       
CODE_058D45:        C8            INY                       
CODE_058D46:        C8            INY                       
CODE_058D47:        B7 0A         LDA [$0A],Y               
CODE_058D49:        05 03         ORA $03                   
CODE_058D4B:        9D E8 1C      STA.W $1CE8,X             
CODE_058D4E:        C8            INY                       
CODE_058D4F:        C8            INY                       
CODE_058D50:        B7 0A         LDA [$0A],Y               
CODE_058D52:        05 03         ORA $03                   
CODE_058D54:        9D 68 1D      STA.W $1D68,X             
CODE_058D57:        E8            INX                       
CODE_058D58:        E8            INX                       
CODE_058D59:        A5 08         LDA $08                   
CODE_058D5B:        A8            TAY                       
CODE_058D5C:        18            CLC                       
CODE_058D5D:        69 01 00      ADC.W #$0001              
CODE_058D60:        85 08         STA $08                   
CODE_058D62:        29 0F 00      AND.W #$000F              
CODE_058D65:        D0 0A         BNE CODE_058D71           
CODE_058D67:        98            TYA                       
CODE_058D68:        29 F0 FF      AND.W #$FFF0              
CODE_058D6B:        18            CLC                       
CODE_058D6C:        69 00 01      ADC.W #$0100              
CODE_058D6F:        85 08         STA $08                   
CODE_058D71:        A5 08         LDA $08                   
CODE_058D73:        29 0F 01      AND.W #$010F              
CODE_058D76:        D0 A2         BNE CODE_058D1A           
CODE_058D78:        28            PLP                       
Return058D79:       6B            RTL                       ; Return 

CODE_058D7A:        08            PHP                       
CODE_058D7B:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_058D7D:        AD 28 19      LDA.W $1928               
CODE_058D80:        29 0F         AND.B #$0F                
CODE_058D82:        0A            ASL                       
CODE_058D83:        8D E7 1C      STA.W $1CE7               
CODE_058D86:        A0 30         LDY.B #$30                
CODE_058D88:        AD 28 19      LDA.W $1928               
CODE_058D8B:        29 10         AND.B #$10                
CODE_058D8D:        F0 02         BEQ CODE_058D91           
CODE_058D8F:        A0 34         LDY.B #$34                
CODE_058D91:        98            TYA                       
CODE_058D92:        8D E6 1C      STA.W $1CE6               
CODE_058D95:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_058D97:        A9 00 B9      LDA.W #$B900              
CODE_058D9A:        85 6B         STA $6B                   
CODE_058D9C:        A9 00 BD      LDA.W #$BD00              
CODE_058D9F:        85 6E         STA $6E                   
CODE_058DA1:        A9 00 91      LDA.W #$9100              
CODE_058DA4:        85 0A         STA $0A                   
CODE_058DA6:        AD 28 19      LDA.W $1928               
CODE_058DA9:        29 F0 00      AND.W #$00F0              
CODE_058DAC:        F0 10         BEQ CODE_058DBE           
CODE_058DAE:        A5 6B         LDA $6B                   
CODE_058DB0:        18            CLC                       
CODE_058DB1:        69 B0 01      ADC.W #$01B0              
CODE_058DB4:        85 6B         STA $6B                   
CODE_058DB6:        A5 6E         LDA $6E                   
CODE_058DB8:        18            CLC                       
CODE_058DB9:        69 B0 01      ADC.W #$01B0              
CODE_058DBC:        85 6E         STA $6E                   
CODE_058DBE:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_058DC0:        A9 7E         LDA.B #$7E                
CODE_058DC2:        85 6D         STA $6D                   
CODE_058DC4:        A9 7E         LDA.B #$7E                
CODE_058DC6:        85 70         STA $70                   
CODE_058DC8:        A0 0D         LDY.B #$0D                
CODE_058DCA:        84 0C         STY $0C                   
CODE_058DCC:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_058DCE:        AD 28 19      LDA.W $1928               
CODE_058DD1:        29 0F 00      AND.W #$000F              
CODE_058DD4:        85 08         STA $08                   
CODE_058DD6:        A2 00 00      LDX.W #$0000              
CODE_058DD9:        A4 08         LDY $08                   
CODE_058DDB:        B7 6B         LDA [$6B],Y               
CODE_058DDD:        29 FF 00      AND.W #$00FF              
CODE_058DE0:        85 00         STA $00                   
CODE_058DE2:        B7 6E         LDA [$6E],Y               
CODE_058DE4:        85 01         STA $01                   
CODE_058DE6:        A5 00         LDA $00                   
CODE_058DE8:        0A            ASL                       
CODE_058DE9:        0A            ASL                       
CODE_058DEA:        0A            ASL                       
CODE_058DEB:        A8            TAY                       
CODE_058DEC:        B7 0A         LDA [$0A],Y               
CODE_058DEE:        9D E8 1C      STA.W $1CE8,X             
CODE_058DF1:        C8            INY                       
CODE_058DF2:        C8            INY                       
CODE_058DF3:        B7 0A         LDA [$0A],Y               
CODE_058DF5:        9D EA 1C      STA.W $1CEA,X             
CODE_058DF8:        C8            INY                       
CODE_058DF9:        C8            INY                       
CODE_058DFA:        B7 0A         LDA [$0A],Y               
CODE_058DFC:        9D 68 1D      STA.W $1D68,X             
CODE_058DFF:        C8            INY                       
CODE_058E00:        C8            INY                       
CODE_058E01:        B7 0A         LDA [$0A],Y               
CODE_058E03:        9D 6A 1D      STA.W $1D6A,X             
CODE_058E06:        E8            INX                       
CODE_058E07:        E8            INX                       
CODE_058E08:        E8            INX                       
CODE_058E09:        E8            INX                       
CODE_058E0A:        A5 08         LDA $08                   
CODE_058E0C:        18            CLC                       
CODE_058E0D:        69 10 00      ADC.W #$0010              
CODE_058E10:        85 08         STA $08                   
CODE_058E12:        C9 B0 01      CMP.W #$01B0              
CODE_058E15:        90 C2         BCC CODE_058DD9           
CODE_058E17:        28            PLP                       
Return058E18:       6B            RTL                       ; Return 


DATA_058E19:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF

Layer3Ptr:             49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       87 90 05   .dw DATA_059087 .db :$DATA_059087 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       94 92 05   .dw DATA_059294 .db :$DATA_059294 
                       E0 9A 05   .dw DATA_059AE0 .db :$DATA_059AE0 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       87 90 05   .dw DATA_059087 .db :$DATA_059087 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       21 A2 05   .dw DATA_05A221 .db :$DATA_05A221 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       87 90 05   .dw DATA_059087 .db :$DATA_059087 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       DE 95 05   .dw DATA_0595DE .db :$DATA_0595DE 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       87 90 05   .dw DATA_059087 .db :$DATA_059087 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       87 90 05   .dw DATA_059087 .db :$DATA_059087 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       87 90 05   .dw DATA_059087 .db :$DATA_059087 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       17 9A 05   .dw DATA_059A17 .db :$DATA_059A17 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       87 90 05   .dw DATA_059087 .db :$DATA_059087 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       87 90 05   .dw DATA_059087 .db :$DATA_059087 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       87 90 05   .dw DATA_059087 .db :$DATA_059087 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       DE 95 05   .dw DATA_0595DE .db :$DATA_0595DE 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       49 95 05   .dw DATA_059549 .db :$DATA_059549 
                       21 A2 05   .dw DATA_05A221 .db :$DATA_05A221 

DATA_059087:                      .db $58,$06,$00,$03,$87,$39,$88,$39
                                  .db $58,$12,$00,$03,$87,$39,$88,$39
                                  .db $58,$26,$00,$03,$97,$39,$98,$39
                                  .db $58,$2C,$00,$03,$87,$39,$88,$39
                                  .db $58,$32,$00,$03,$97,$39,$98,$39
                                  .db $58,$38,$00,$03,$87,$39,$88,$39
                                  .db $58,$46,$00,$03,$85,$39,$86,$39
                                  .db $58,$4C,$00,$03,$97,$39,$98,$39
                                  .db $58,$52,$00,$03,$85,$39,$86,$39
                                  .db $58,$58,$00,$03,$97,$39,$98,$39
                                  .db $58,$66,$00,$03,$95,$39,$96,$39
                                  .db $58,$6C,$00,$03,$95,$39,$96,$39
                                  .db $58,$72,$00,$03,$95,$39,$96,$39
                                  .db $58,$78,$00,$03,$95,$39,$96,$39
                                  .db $58,$84,$00,$2F,$80,$3D,$81,$3D
                                  .db $82,$3D,$82,$7D,$82,$3D,$82,$7D
                                  .db $82,$3D,$82,$7D,$82,$3D,$82,$7D
                                  .db $82,$3D,$82,$7D,$82,$3D,$82,$7D
                                  .db $82,$3D,$82,$7D,$82,$3D,$82,$7D
                                  .db $82,$3D,$82,$7D,$82,$3D,$82,$7D
                                  .db $81,$7D,$80,$7D,$58,$A4,$00,$2F
                                  .db $90,$3D,$91,$3D,$92,$3D,$92,$7D
                                  .db $92,$3D,$92,$7D,$92,$3D,$92,$7D
                                  .db $92,$3D,$92,$7D,$92,$3D,$92,$7D
                                  .db $92,$3D,$92,$7D,$92,$3D,$92,$7D
                                  .db $92,$3D,$92,$7D,$92,$3D,$92,$7D
                                  .db $92,$3D,$92,$7D,$91,$7D,$90,$7D
                                  .db $58,$C4,$80,$13,$83,$3D,$83,$BD
                                  .db $83,$3D,$83,$BD,$83,$3D,$83,$BD
                                  .db $83,$3D,$83,$BD,$83,$3D,$83,$BD
                                  .db $58,$C5,$80,$13,$84,$3D,$84,$BD
                                  .db $84,$3D,$84,$BD,$84,$3D,$84,$BD
                                  .db $84,$3D,$84,$BD,$84,$3D,$84,$BD
                                  .db $58,$C7,$C0,$12,$93,$39,$58,$C8
                                  .db $C0,$12,$94,$39,$58,$C9,$C0,$12
                                  .db $93,$39,$58,$CA,$C0,$12,$94,$39
                                  .db $58,$CB,$C0,$12,$93,$39,$58,$CC
                                  .db $C0,$12,$94,$39,$58,$CD,$C0,$12
                                  .db $93,$39,$58,$CE,$C0,$12,$94,$39
                                  .db $58,$CF,$C0,$12,$93,$39,$58,$D0
                                  .db $C0,$12,$94,$39,$58,$D1,$C0,$12
                                  .db $93,$39,$58,$D2,$C0,$12,$94,$39
                                  .db $58,$D3,$C0,$12,$93,$39,$58,$D4
                                  .db $C0,$12,$94,$39,$58,$D5,$C0,$12
                                  .db $93,$39,$58,$D6,$C0,$12,$94,$39
                                  .db $58,$D7,$C0,$12,$93,$39,$58,$D8
                                  .db $C0,$12,$94,$39,$58,$DA,$80,$13
                                  .db $83,$3D,$83,$BD,$83,$3D,$83,$BD
                                  .db $83,$3D,$83,$BD,$83,$3D,$83,$BD
                                  .db $83,$3D,$83,$BD,$58,$DB,$80,$13
                                  .db $84,$3D,$84,$BD,$84,$3D,$84,$BD
                                  .db $84,$3D,$84,$BD,$84,$3D,$84,$BD
                                  .db $84,$3D,$84,$BD,$5A,$04,$00,$2F
                                  .db $90,$BD,$91,$BD,$82,$3D,$82,$7D
                                  .db $82,$3D,$82,$7D,$82,$3D,$82,$7D
                                  .db $82,$3D,$82,$7D,$82,$3D,$82,$7D
                                  .db $82,$3D,$82,$7D,$82,$3D,$82,$7D
                                  .db $82,$3D,$82,$7D,$82,$3D,$82,$7D
                                  .db $82,$3D,$82,$7D,$91,$FD,$90,$FD
                                  .db $5A,$24,$00,$2F,$80,$BD,$81,$BD
                                  .db $92,$3D,$92,$7D,$92,$3D,$92,$7D
                                  .db $92,$3D,$92,$7D,$92,$3D,$92,$7D
                                  .db $92,$3D,$92,$7D,$92,$3D,$92,$7D
                                  .db $92,$3D,$92,$7D,$92,$3D,$92,$7D
                                  .db $92,$3D,$92,$7D,$92,$3D,$92,$7D
                                  .db $81,$FD,$80,$FD,$FF

DATA_059294:                      .db $50,$A8,$00,$1F,$99,$3D,$9A,$3D
                                  .db $A1,$AD,$B2,$2D,$B3,$2D,$B4,$2D
                                  .db $A5,$AD,$B6,$2D,$B7,$2D,$B8,$2D
                                  .db $B4,$2D,$BA,$2D,$BB,$2D,$BC,$2D
                                  .db $FE,$2C,$FE,$2C,$50,$C8,$00,$1F
                                  .db $8B,$3D,$8C,$3D,$C1,$2D,$C2,$2D
                                  .db $C3,$2D,$B4,$AD,$A3,$2D,$A4,$2D
                                  .db $C7,$2D,$C8,$2D,$B4,$AD,$BA,$AD
                                  .db $D5,$2D,$CC,$2D,$FE,$2C,$FE,$2C
                                  .db $50,$E8,$00,$1F,$9B,$3D,$9C,$3D
                                  .db $D1,$2D,$D2,$2D,$D3,$2D,$B7,$AD
                                  .db $D5,$2D,$B4,$2D,$D7,$2D,$C7,$2D
                                  .db $D9,$2D,$D9,$6D,$DB,$2D,$DC,$2D
                                  .db $FE,$2C,$FE,$2C,$51,$08,$00,$1F
                                  .db $89,$3D,$8A,$3D,$A1,$2D,$A2,$2D
                                  .db $A3,$2D,$A4,$2D,$A5,$2D,$B4,$AD
                                  .db $D5,$2D,$C7,$AD,$FD,$2C,$AA,$2D
                                  .db $AB,$2D,$AC,$2D,$FE,$2C,$FE,$2C
                                  .db $51,$28,$00,$1F,$99,$3D,$9A,$3D
                                  .db $A1,$AD,$B2,$2D,$B3,$2D,$B4,$2D
                                  .db $A5,$AD,$B6,$2D,$B7,$2D,$B8,$2D
                                  .db $B4,$2D,$BA,$2D,$BB,$2D,$BC,$2D
                                  .db $FE,$2C,$FE,$2C,$51,$48,$00,$1F
                                  .db $8B,$3D,$8C,$3D,$C1,$2D,$C2,$2D
                                  .db $C3,$2D,$B4,$AD,$A3,$2D,$A4,$2D
                                  .db $C7,$2D,$C8,$2D,$B4,$AD,$BA,$AD
                                  .db $D5,$2D,$CC,$2D,$FE,$2C,$FE,$2C
                                  .db $51,$68,$00,$1F,$9B,$3D,$9C,$3D
                                  .db $D1,$2D,$D2,$2D,$D3,$2D,$B7,$AD
                                  .db $D5,$2D,$B4,$2D,$D7,$2D,$C7,$2D
                                  .db $D9,$2D,$D9,$6D,$DB,$2D,$DC,$2D
                                  .db $FE,$2C,$FE,$2C,$51,$88,$00,$1F
                                  .db $89,$3D,$8A,$3D,$A1,$2D,$A2,$2D
                                  .db $A3,$2D,$A4,$2D,$A5,$2D,$B4,$AD
                                  .db $D5,$2D,$C7,$AD,$FD,$2C,$AA,$2D
                                  .db $AB,$2D,$AC,$2D,$FE,$2C,$FE,$2C
                                  .db $51,$A8,$00,$1F,$99,$3D,$9A,$3D
                                  .db $A1,$AD,$B2,$2D,$B3,$2D,$B4,$2D
                                  .db $A5,$AD,$B6,$2D,$B7,$2D,$B8,$2D
                                  .db $B4,$2D,$BA,$2D,$BB,$2D,$BC,$2D
                                  .db $FE,$2C,$FE,$2C,$51,$C8,$00,$1F
                                  .db $8B,$3D,$8C,$3D,$C1,$2D,$C2,$2D
                                  .db $C3,$2D,$B4,$AD,$A3,$2D,$A4,$2D
                                  .db $C7,$2D,$C8,$2D,$B4,$AD,$BA,$AD
                                  .db $D5,$2D,$CC,$2D,$FE,$2C,$FE,$2C
                                  .db $51,$E8,$00,$1F,$9B,$3D,$9C,$3D
                                  .db $D1,$2D,$D2,$2D,$D3,$2D,$B7,$AD
                                  .db $D5,$2D,$B4,$2D,$D7,$2D,$C7,$2D
                                  .db $D9,$2D,$D9,$6D,$DB,$2D,$DC,$2D
                                  .db $FE,$2C,$FE,$2C,$52,$08,$00,$1F
                                  .db $89,$3D,$8A,$3D,$A1,$2D,$A2,$2D
                                  .db $A3,$2D,$A4,$2D,$A5,$2D,$B4,$AD
                                  .db $D5,$2D,$C7,$AD,$FD,$2C,$AA,$2D
                                  .db $AB,$2D,$AC,$2D,$FE,$2C,$FE,$2C
                                  .db $52,$28,$00,$1F,$99,$3D,$9A,$3D
                                  .db $A1,$AD,$B2,$2D,$B3,$2D,$B4,$2D
                                  .db $A5,$AD,$B6,$2D,$B7,$2D,$B8,$2D
                                  .db $B4,$2D,$BA,$2D,$BB,$2D,$BC,$2D
                                  .db $FE,$2C,$FE,$2C,$52,$48,$00,$1F
                                  .db $8B,$3D,$8C,$3D,$C1,$2D,$C2,$2D
                                  .db $C3,$2D,$B4,$AD,$A3,$2D,$A4,$2D
                                  .db $C7,$2D,$C8,$2D,$B4,$AD,$BA,$AD
                                  .db $D5,$2D,$CC,$2D,$FE,$2C,$FE,$2C
                                  .db $52,$68,$00,$1F,$9B,$3D,$9C,$3D
                                  .db $D1,$2D,$D2,$2D,$D3,$2D,$B7,$AD
                                  .db $D5,$2D,$B4,$2D,$D7,$2D,$C7,$2D
                                  .db $D9,$2D,$D9,$6D,$DB,$2D,$DC,$2D
                                  .db $FE,$2C,$FE,$2C,$52,$88,$00,$1F
                                  .db $89,$3D,$8A,$3D,$A1,$2D,$A2,$2D
                                  .db $A3,$2D,$A4,$2D,$A5,$2D,$B4,$AD
                                  .db $D5,$2D,$C7,$AD,$FD,$2C,$AA,$2D
                                  .db $AB,$2D,$AC,$2D,$FE,$2C,$FE,$2C
                                  .db $52,$A8,$00,$1F,$99,$3D,$9A,$3D
                                  .db $A1,$AD,$B2,$2D,$B3,$2D,$B4,$2D
                                  .db $A5,$AD,$B6,$2D,$B7,$2D,$B8,$2D
                                  .db $B4,$2D,$BA,$2D,$BB,$2D,$BC,$2D
                                  .db $FE,$2C,$FE,$2C,$52,$C7,$00,$23
                                  .db $CD,$2D,$CE,$2D,$CF,$2D,$E1,$2D
                                  .db $E2,$2D,$E3,$2D,$E4,$2D,$E5,$2D
                                  .db $E6,$2D,$E7,$2D,$E8,$2D,$E9,$2D
                                  .db $EA,$2D,$EB,$2D,$EC,$2D,$ED,$2D
                                  .db $EE,$2D,$CD,$6D,$52,$E7,$00,$23
                                  .db $DD,$2D,$DE,$2D,$DF,$2D,$F1,$2D
                                  .db $F2,$2D,$DE,$2D,$DF,$2D,$F1,$2D
                                  .db $F2,$2D,$DE,$2D,$DF,$2D,$F1,$2D
                                  .db $F2,$2D,$DE,$2D,$DF,$2D,$F1,$2D
                                  .db $F2,$2D,$DD,$6D,$FF

DATA_059549:                      .db $58,$00,$00,$3F,$7D,$39,$7E,$39
                                  .db $7D,$39,$7E,$39,$7D,$39,$7E,$39
                                  .db $7D,$39,$7E,$39,$7D,$39,$7E,$39
                                  .db $7D,$39,$7E,$39,$7D,$39,$7E,$39
                                  .db $7D,$39,$7E,$39,$7D,$39,$7E,$39
                                  .db $7D,$39,$7E,$39,$7D,$39,$7E,$39
                                  .db $7D,$39,$7E,$39,$7D,$39,$7E,$39
                                  .db $7D,$39,$7E,$39,$7D,$39,$7E,$39
                                  .db $7D,$39,$7E,$39,$58,$20,$47,$7E
                                  .db $8E,$39,$5C,$00,$00,$3F,$7D,$39
                                  .db $7E,$39,$7D,$39,$7E,$39,$7D,$39
                                  .db $7E,$39,$7D,$39,$7E,$39,$7D,$39
                                  .db $7E,$39,$7D,$39,$7E,$39,$7D,$39
                                  .db $7E,$39,$7D,$39,$7E,$39,$7D,$39
                                  .db $7E,$39,$7D,$39,$7E,$39,$7D,$39
                                  .db $7E,$39,$7D,$39,$7E,$39,$7D,$39
                                  .db $7E,$39,$7D,$39,$7E,$39,$7D,$39
                                  .db $7E,$39,$7D,$39,$7E,$39,$5C,$20
                                  .db $47,$7E,$8E,$39,$FF

DATA_0595DE:                      .db $53,$A0,$00,$03,$FF,$60,$9E,$61
                                  .db $53,$B8,$00,$01,$9E,$21,$53,$B9
                                  .db $40,$0C,$FF,$20,$53,$C0,$00,$03
                                  .db $FF,$60,$9E,$E1,$53,$D8,$00,$01
                                  .db $9E,$A1,$53,$D9,$40,$0C,$FF,$20
                                  .db $53,$E0,$40,$08,$FF,$60,$53,$E5
                                  .db $00,$01,$9E,$61,$53,$EA,$00,$0B
                                  .db $9E,$21,$FF,$20,$FF,$20,$FF,$20
                                  .db $FF,$60,$9E,$61,$53,$FB,$00,$01
                                  .db $9E,$21,$53,$FC,$40,$06,$FF,$20
                                  .db $58,$00,$40,$08,$FF,$60,$58,$05
                                  .db $00,$01,$9E,$E1,$58,$0A,$00,$0B
                                  .db $9E,$A1,$FF,$20,$FF,$20,$FF,$20
                                  .db $FF,$60,$9E,$E1,$58,$1B,$00,$01
                                  .db $9E,$A1,$58,$1C,$40,$06,$FF,$20
                                  .db $58,$60,$80,$0F,$FF,$20,$FF,$20
                                  .db $8F,$61,$8F,$E1,$FF,$20,$FF,$20
                                  .db $FF,$60,$FF,$60,$58,$61,$80,$0F
                                  .db $FF,$20,$FF,$20,$FC,$60,$FC,$60
                                  .db $FF,$20,$FF,$20,$9E,$61,$9E,$E1
                                  .db $58,$62,$00,$03,$FF,$60,$9E,$61
                                  .db $58,$82,$00,$03,$FF,$60,$9E,$E1
                                  .db $58,$E2,$40,$06,$FF,$20,$58,$E6
                                  .db $00,$03,$FF,$60,$9E,$61,$59,$02
                                  .db $40,$06,$FF,$20,$59,$06,$00,$03
                                  .db $FF,$60,$9E,$E1,$58,$6C,$00,$01
                                  .db $9E,$21,$58,$6D,$40,$24,$FF,$20
                                  .db $58,$8C,$00,$01,$9E,$A1,$58,$8D
                                  .db $40,$24,$FF,$20,$58,$B2,$00,$01
                                  .db $9E,$21,$58,$B3,$40,$18,$FF,$20
                                  .db $58,$D2,$00,$01,$9E,$A1,$58,$D3
                                  .db $40,$18,$FF,$20,$58,$FC,$00,$07
                                  .db $FC,$20,$8F,$21,$FF,$20,$FF,$20
                                  .db $59,$1C,$00,$07,$FC,$20,$8F,$A1
                                  .db $FF,$20,$FF,$20,$59,$2E,$00,$0B
                                  .db $9E,$21,$FF,$20,$FF,$20,$FF,$20
                                  .db $FF,$60,$9E,$61,$59,$4E,$00,$0B
                                  .db $9E,$A1,$FF,$20,$FF,$20,$FF,$20
                                  .db $FF,$60,$9E,$E1,$59,$38,$00,$01
                                  .db $9E,$21,$59,$39,$40,$0C,$FF,$20
                                  .db $59,$58,$00,$01,$9E,$A1,$59,$59
                                  .db $40,$0C,$FF,$20,$59,$A4,$00,$01
                                  .db $9E,$21,$59,$A5,$40,$0E,$FF,$20
                                  .db $59,$AD,$00,$05,$FF,$60,$FF,$60
                                  .db $9E,$61,$59,$C4,$00,$01,$9E,$A1
                                  .db $59,$C5,$40,$0E,$FF,$20,$59,$CD
                                  .db $00,$05,$FF,$60,$FF,$60,$9E,$E1
                                  .db $59,$E0,$00,$03,$FF,$60,$9E,$61
                                  .db $5A,$00,$00,$03,$FF,$60,$9E,$E1
                                  .db $59,$E8,$00,$01,$9E,$21,$59,$E9
                                  .db $40,$12,$FF,$20,$59,$F3,$00,$05
                                  .db $FF,$60,$FF,$60,$9E,$61,$5A,$08
                                  .db $00,$01,$9E,$A1,$5A,$09,$40,$12
                                  .db $FF,$20,$5A,$13,$00,$05,$FF,$60
                                  .db $FF,$60,$9E,$E1,$59,$FC,$00,$07
                                  .db $9E,$21,$FF,$20,$FF,$20,$FF,$20
                                  .db $5A,$1C,$00,$07,$9E,$A1,$FF,$20
                                  .db $FF,$20,$FF,$20,$5A,$2E,$00,$03
                                  .db $FC,$20,$8F,$21,$5A,$30,$40,$0C
                                  .db $FF,$20,$5A,$37,$00,$05,$FF,$60
                                  .db $FF,$60,$9E,$61,$5A,$4E,$00,$03
                                  .db $FC,$20,$8F,$A1,$5A,$50,$40,$0C
                                  .db $FF,$20,$5A,$57,$00,$05,$FF,$60
                                  .db $FF,$60,$9E,$E1,$5A,$6C,$00,$0B
                                  .db $9E,$21,$FF,$20,$FF,$20,$FF,$20
                                  .db $FF,$60,$9E,$61,$5A,$8C,$00,$0B
                                  .db $9E,$A1,$FF,$20,$FF,$20,$FF,$20
                                  .db $FF,$60,$9E,$E1,$57,$A0,$00,$03
                                  .db $FF,$60,$9E,$61,$57,$B8,$00,$01
                                  .db $9E,$21,$57,$B9,$40,$0C,$FF,$20
                                  .db $57,$C0,$00,$03,$FF,$60,$9E,$E1
                                  .db $57,$D8,$00,$01,$9E,$A1,$57,$D9
                                  .db $40,$0C,$FF,$20,$57,$E0,$40,$08
                                  .db $FF,$60,$57,$E5,$00,$01,$9E,$61
                                  .db $57,$EA,$00,$0B,$9E,$21,$FF,$20
                                  .db $FF,$20,$FF,$20,$FF,$20,$9E,$61
                                  .db $57,$FB,$00,$01,$9E,$21,$57,$FC
                                  .db $40,$06,$FF,$20,$5C,$00,$40,$08
                                  .db $FF,$60,$5C,$05,$00,$01,$9E,$E1
                                  .db $5C,$0A,$00,$0B,$9E,$A1,$FF,$20
                                  .db $FF,$20,$FF,$20,$FF,$60,$9E,$E1
                                  .db $5C,$1B,$00,$01,$9E,$A1,$5C,$1C
                                  .db $40,$06,$FF,$20,$5C,$60,$80,$0F
                                  .db $FF,$20,$FF,$20,$8F,$61,$8F,$E1
                                  .db $FF,$20,$FF,$20,$FF,$60,$FF,$60
                                  .db $5C,$61,$80,$0F,$FF,$20,$FF,$20
                                  .db $FC,$60,$FC,$60,$FF,$20,$FF,$20
                                  .db $9E,$61,$9E,$E1,$5C,$62,$00,$03
                                  .db $FF,$60,$9E,$61,$5C,$82,$00,$03
                                  .db $FF,$60,$9E,$E1,$5C,$E2,$40,$06
                                  .db $FF,$20,$5C,$E6,$00,$03,$FF,$60
                                  .db $9E,$61,$5D,$02,$40,$06,$FF,$20
                                  .db $5D,$06,$00,$03,$FF,$60,$9E,$E1
                                  .db $5C,$6C,$00,$01,$9E,$21,$5C,$6D
                                  .db $40,$24,$FF,$20,$5C,$8C,$00,$01
                                  .db $9E,$A1,$5C,$8D,$40,$24,$FF,$20
                                  .db $5C,$B2,$00,$01,$9E,$21,$5C,$B3
                                  .db $40,$18,$FF,$20,$5C,$D2,$00,$01
                                  .db $9E,$A1,$5C,$D3,$40,$18,$FF,$20
                                  .db $5C,$FC,$00,$07,$FC,$20,$8F,$21
                                  .db $FF,$20,$FF,$20,$5D,$1C,$00,$07
                                  .db $FC,$20,$8F,$A1,$FF,$20,$FF,$20
                                  .db $5D,$2E,$00,$0B,$9E,$21,$FF,$20
                                  .db $FF,$20,$FF,$20,$FF,$60,$9E,$61
                                  .db $5D,$4E,$00,$0B,$9E,$A1,$FF,$20
                                  .db $FF,$20,$FF,$20,$FF,$60,$9E,$E1
                                  .db $5D,$38,$00,$01,$9E,$21,$5D,$39
                                  .db $40,$0C,$FF,$20,$5D,$58,$00,$01
                                  .db $9E,$A1,$5D,$59,$40,$0C,$FF,$20
                                  .db $5D,$A4,$00,$01,$9E,$21,$5D,$A5
                                  .db $40,$0E,$FF,$20,$5D,$AD,$00,$05
                                  .db $FF,$60,$FF,$60,$9E,$61,$5D,$C4
                                  .db $00,$01,$9E,$A1,$5D,$C5,$40,$0E
                                  .db $FF,$20,$5D,$CD,$00,$05,$FF,$60
                                  .db $FF,$60,$9E,$E1,$5D,$E0,$00,$03
                                  .db $FF,$60,$9E,$61,$5E,$00,$00,$03
                                  .db $FF,$60,$9E,$E1,$5D,$E8,$00,$01
                                  .db $9E,$21,$5D,$E9,$40,$12,$FF,$20
                                  .db $5D,$F3,$00,$05,$FF,$60,$FF,$60
                                  .db $9E,$61,$5E,$08,$00,$01,$9E,$A1
                                  .db $5E,$09,$40,$12,$FF,$20,$5E,$13
                                  .db $00,$05,$FF,$60,$FF,$60,$9E,$E1
                                  .db $5D,$FC,$00,$07,$9E,$21,$FF,$20
                                  .db $FF,$20,$FF,$20,$5E,$1C,$00,$07
                                  .db $9E,$A1,$FF,$20,$FF,$20,$FF,$20
                                  .db $5E,$2E,$00,$03,$FC,$20,$8F,$21
                                  .db $5E,$30,$40,$0C,$FF,$20,$5E,$37
                                  .db $00,$05,$FF,$60,$FF,$60,$9E,$61
                                  .db $5E,$4E,$00,$03,$FC,$20,$8F,$A1
                                  .db $5E,$50,$40,$0C,$FF,$20,$5E,$57
                                  .db $00,$05,$FF,$60,$FF,$60,$9E,$E1
                                  .db $5E,$6C,$00,$0B,$9E,$21,$FF,$20
                                  .db $FF,$20,$FF,$20,$FF,$60,$9E,$61
                                  .db $5E,$8C,$00,$0B,$9E,$A1,$FF,$20
                                  .db $FF,$20,$FF,$20,$FF,$60,$9E,$E1
                                  .db $FF

DATA_059A17:                      .db $51,$67,$00,$01,$9F,$39,$51,$93
                                  .db $00,$01,$9F,$29,$51,$D1,$00,$01
                                  .db $9F,$39,$52,$5A,$00,$01,$9F,$39
                                  .db $52,$77,$00,$01,$9F,$29,$52,$79
                                  .db $80,$03,$9F,$29,$9F,$39,$52,$8C
                                  .db $00,$01,$9F,$29,$53,$3D,$00,$01
                                  .db $9F,$39,$55,$67,$00,$01,$9F,$39
                                  .db $55,$93,$00,$01,$9F,$29,$55,$D1
                                  .db $00,$01,$9F,$39,$56,$5A,$00,$01
                                  .db $9F,$39,$56,$77,$00,$01,$9F,$29
                                  .db $56,$79,$80,$03,$9F,$29,$9F,$39
                                  .db $56,$8C,$00,$01,$9F,$29,$57,$3D
                                  .db $00,$01,$9F,$39,$58,$07,$00,$01
                                  .db $9F,$39,$58,$33,$00,$01,$9F,$29
                                  .db $58,$71,$00,$01,$9F,$39,$58,$FA
                                  .db $00,$01,$9F,$39,$59,$17,$00,$01
                                  .db $9F,$29,$59,$19,$80,$03,$9F,$29
                                  .db $9F,$39,$59,$2C,$00,$01,$9F,$29
                                  .db $59,$DD,$00,$01,$9F,$39,$5C,$07
                                  .db $00,$01,$9F,$39,$5C,$33,$00,$01
                                  .db $9F,$29,$5C,$71,$00,$01,$9F,$39
                                  .db $5C,$FA,$00,$01,$9F,$39,$5D,$17
                                  .db $00,$01,$9F,$29,$5D,$19,$80,$03
                                  .db $9F,$29,$9F,$39,$5D,$2C,$00,$01
                                  .db $9F,$29,$5D,$DD,$00,$01,$9F,$39
                                  .db $FF

DATA_059AE0:                      .db $58,$03,$00,$03,$80,$01,$81,$01
                                  .db $58,$07,$00,$03,$80,$01,$81,$01
                                  .db $58,$0F,$00,$07,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$58,$15,$00,$0B
                                  .db $80,$01,$81,$01,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$58,$20,$00,$0F
                                  .db $80,$01,$81,$01,$86,$15,$87,$15
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $58,$22,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$58,$23,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$58,$2C,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$58,$2D
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $58,$2F,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$58,$30,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$58,$32,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$58,$33
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $58,$36,$00,$03,$80,$01,$81,$01
                                  .db $58,$3A,$00,$03,$80,$01,$81,$01
                                  .db $58,$3C,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$58,$3D,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$58,$45,$00,$03
                                  .db $82,$15,$83,$15,$58,$8D,$00,$03
                                  .db $80,$01,$81,$01,$58,$9E,$00,$03
                                  .db $80,$01,$81,$01,$58,$BD,$00,$03
                                  .db $80,$01,$81,$01,$58,$C7,$00,$03
                                  .db $80,$01,$81,$01,$58,$D9,$00,$01
                                  .db $81,$01,$58,$DC,$00,$07,$80,$01
                                  .db $81,$01,$82,$15,$83,$15,$58,$E4
                                  .db $00,$03,$80,$01,$81,$01,$58,$E8
                                  .db $00,$07,$80,$01,$81,$01,$80,$01
                                  .db $81,$01,$58,$F9,$00,$0D,$80,$01
                                  .db $81,$01,$80,$01,$81,$01,$82,$15
                                  .db $83,$15,$82,$15,$59,$02,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$59,$03
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $59,$05,$00,$0B,$80,$01,$81,$01
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $59,$0C,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$59,$0D,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$59,$0F,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$59,$10
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $59,$12,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$59,$13,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$59,$1A,$00,$0B
                                  .db $80,$01,$81,$01,$86,$15,$87,$15
                                  .db $82,$15,$83,$15,$59,$1C,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$59,$1D
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $59,$24,$00,$0F,$80,$01,$81,$01
                                  .db $82,$15,$83,$15,$82,$15,$83,$15
                                  .db $80,$01,$81,$01,$59,$39,$00,$03
                                  .db $80,$01,$81,$01,$59,$47,$00,$07
                                  .db $80,$01,$81,$01,$82,$15,$83,$15
                                  .db $59,$5A,$00,$0B,$80,$01,$81,$01
                                  .db $90,$15,$91,$15,$80,$01,$81,$01
                                  .db $59,$64,$00,$17,$80,$01,$81,$01
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$59,$87,$00,$03
                                  .db $80,$01,$81,$01,$59,$8B,$00,$07
                                  .db $80,$01,$81,$01,$80,$01,$81,$01
                                  .db $59,$98,$00,$03,$80,$01,$81,$01
                                  .db $59,$A8,$00,$07,$80,$01,$81,$01
                                  .db $82,$15,$83,$15,$59,$B9,$00,$03
                                  .db $80,$01,$81,$01,$59,$C5,$00,$03
                                  .db $80,$01,$81,$01,$59,$C9,$00,$07
                                  .db $80,$01,$81,$01,$80,$01,$81,$01
                                  .db $59,$D6,$00,$0F,$80,$01,$81,$01
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$59,$E2,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$59,$E3
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $59,$EA,$00,$0B,$80,$01,$81,$01
                                  .db $86,$15,$87,$15,$82,$15,$83,$15
                                  .db $59,$EC,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$59,$ED,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$59,$EF,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$59,$F0
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $59,$F2,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$59,$F3,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$59,$F7,$00,$07
                                  .db $82,$15,$83,$15,$82,$15,$83,$15
                                  .db $59,$FC,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$59,$FD,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$5A,$14,$00,$0F
                                  .db $80,$01,$81,$01,$82,$15,$83,$15
                                  .db $80,$01,$81,$01,$82,$15,$83,$15
                                  .db $5A,$20,$00,$01,$81,$01,$5A,$27
                                  .db $00,$03,$80,$01,$81,$01,$5A,$35
                                  .db $00,$0B,$80,$01,$81,$01,$80,$01
                                  .db $81,$01,$82,$15,$83,$15,$5A,$40
                                  .db $00,$07,$80,$01,$81,$01,$80,$01
                                  .db $81,$01,$5A,$56,$00,$03,$80,$01
                                  .db $81,$01,$5A,$5A,$00,$03,$80,$01
                                  .db $81,$01,$5A,$60,$00,$09,$81,$01
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $5A,$67,$00,$03,$80,$01,$81,$01
                                  .db $5A,$79,$00,$07,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$5A,$80,$00,$0B
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$5A,$98,$00,$03
                                  .db $80,$01,$81,$01,$5A,$9C,$00,$03
                                  .db $80,$01,$81,$01,$5A,$A0,$00,$05
                                  .db $83,$15,$80,$01,$81,$01,$5A,$A5
                                  .db $00,$07,$80,$01,$81,$01,$80,$01
                                  .db $81,$01,$5A,$C0,$00,$07,$82,$15
                                  .db $83,$15,$82,$15,$83,$15,$5A,$C6
                                  .db $00,$03,$80,$01,$81,$01,$5A,$CA
                                  .db $00,$03,$80,$01,$81,$01,$5A,$E0
                                  .db $00,$0D,$83,$15,$82,$15,$83,$15
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $5A,$E9,$00,$03,$80,$01,$81,$01
                                  .db $5C,$03,$00,$03,$80,$01,$81,$01
                                  .db $5C,$07,$00,$03,$80,$01,$81,$01
                                  .db $5C,$0F,$00,$07,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$5C,$15,$00,$0B
                                  .db $80,$01,$81,$01,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$5C,$20,$00,$0F
                                  .db $80,$01,$81,$01,$86,$15,$87,$15
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $5C,$22,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$5C,$23,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$5C,$2C,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$5C,$2D
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $5C,$2F,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$5C,$30,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$5C,$32,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$5C,$33
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $5C,$36,$00,$03,$80,$01,$81,$01
                                  .db $5C,$3A,$00,$03,$80,$01,$81,$01
                                  .db $5C,$3C,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$5C,$3D,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$5C,$45,$00,$03
                                  .db $82,$15,$83,$15,$5C,$8D,$00,$03
                                  .db $80,$01,$81,$01,$5C,$9E,$00,$03
                                  .db $80,$01,$81,$01,$5C,$BD,$00,$03
                                  .db $80,$01,$81,$01,$5C,$C7,$00,$03
                                  .db $80,$01,$81,$01,$5C,$D9,$00,$01
                                  .db $81,$01,$5C,$DC,$00,$07,$80,$01
                                  .db $81,$01,$82,$15,$83,$15,$5C,$E4
                                  .db $00,$03,$80,$01,$81,$01,$5C,$E8
                                  .db $00,$07,$80,$01,$81,$01,$80,$01
                                  .db $81,$01,$5C,$F9,$00,$0D,$80,$01
                                  .db $81,$01,$80,$01,$81,$01,$82,$15
                                  .db $83,$15,$82,$15,$5D,$02,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$5D,$03
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $5D,$05,$00,$0B,$80,$01,$81,$01
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $5D,$0C,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$5D,$0D,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$5D,$0F,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$5D,$10
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $5D,$12,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$5D,$13,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$5D,$1A,$00,$0B
                                  .db $80,$01,$81,$01,$86,$15,$87,$15
                                  .db $82,$15,$83,$15,$5D,$1C,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$5D,$1D
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $5D,$24,$00,$0F,$80,$01,$81,$01
                                  .db $82,$15,$83,$15,$82,$15,$83,$15
                                  .db $80,$01,$81,$01,$5D,$39,$00,$03
                                  .db $80,$01,$81,$01,$5D,$47,$00,$07
                                  .db $80,$01,$81,$01,$82,$15,$83,$15
                                  .db $5D,$5A,$00,$0B,$80,$01,$81,$01
                                  .db $90,$15,$91,$15,$80,$01,$81,$01
                                  .db $5D,$64,$00,$17,$80,$01,$81,$01
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$5D,$87,$00,$03
                                  .db $80,$01,$81,$01,$5D,$8B,$00,$07
                                  .db $80,$01,$81,$01,$80,$01,$81,$01
                                  .db $5D,$98,$00,$03,$80,$01,$81,$01
                                  .db $5D,$A8,$00,$07,$80,$01,$81,$01
                                  .db $82,$15,$83,$15,$5D,$B9,$00,$03
                                  .db $80,$01,$81,$01,$5D,$C5,$00,$03
                                  .db $80,$01,$81,$01,$5D,$C9,$00,$07
                                  .db $80,$01,$81,$01,$80,$01,$81,$01
                                  .db $5D,$D6,$00,$0F,$80,$01,$81,$01
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$5D,$E2,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$5D,$E3
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $5D,$EA,$00,$0B,$80,$01,$81,$01
                                  .db $86,$15,$87,$15,$82,$15,$83,$15
                                  .db $5D,$EC,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$5D,$ED,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$5D,$EF,$80,$05
                                  .db $86,$15,$96,$15,$90,$15,$5D,$F0
                                  .db $80,$05,$87,$15,$97,$15,$91,$15
                                  .db $5D,$F2,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$5D,$F3,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$5D,$F7,$00,$07
                                  .db $82,$15,$83,$15,$82,$15,$83,$15
                                  .db $5D,$FC,$80,$05,$86,$15,$96,$15
                                  .db $90,$15,$5D,$FD,$80,$05,$87,$15
                                  .db $97,$15,$91,$15,$5E,$14,$00,$0F
                                  .db $80,$01,$81,$01,$82,$15,$83,$15
                                  .db $80,$01,$81,$01,$82,$15,$83,$15
                                  .db $5E,$20,$00,$01,$81,$01,$5E,$27
                                  .db $00,$03,$80,$01,$81,$01,$5E,$35
                                  .db $00,$0B,$80,$01,$81,$01,$80,$01
                                  .db $81,$01,$82,$15,$83,$15,$5E,$40
                                  .db $00,$07,$80,$01,$81,$01,$80,$01
                                  .db $81,$01,$5E,$56,$00,$03,$80,$01
                                  .db $81,$01,$5E,$5A,$00,$03,$80,$01
                                  .db $81,$01,$5E,$60,$00,$09,$81,$01
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $5E,$67,$00,$03,$80,$01,$81,$01
                                  .db $5E,$79,$00,$07,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$5E,$80,$00,$0B
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $80,$01,$81,$01,$5E,$98,$00,$03
                                  .db $80,$01,$81,$01,$5E,$9C,$00,$03
                                  .db $80,$01,$81,$01,$5E,$A0,$00,$05
                                  .db $83,$15,$80,$01,$81,$01,$5E,$A5
                                  .db $00,$07,$80,$01,$81,$01,$80,$01
                                  .db $81,$01,$5E,$C0,$00,$07,$82,$15
                                  .db $83,$15,$82,$15,$83,$15,$5E,$C6
                                  .db $00,$03,$80,$01,$81,$01,$5E,$CA
                                  .db $00,$03,$80,$01,$81,$01,$5E,$E0
                                  .db $00,$0D,$83,$15,$82,$15,$83,$15
                                  .db $82,$15,$83,$15,$80,$01,$81,$01
                                  .db $5E,$E9,$00,$03,$80,$01,$81,$01
                                  .db $FF

DATA_05A221:                      .db $53,$DA,$00,$05,$F9,$11,$FA,$11
                                  .db $FB,$11,$53,$FA,$00,$05,$FC,$11
                                  .db $FD,$11,$FE,$11,$58,$3C,$00,$01
                                  .db $DA,$11,$58,$6D,$00,$05,$F9,$11
                                  .db $FA,$11,$FB,$11,$58,$8D,$00,$05
                                  .db $FC,$11,$FD,$11,$FE,$11,$58,$E5
                                  .db $00,$07,$92,$11,$95,$11,$98,$11
                                  .db $AD,$11,$59,$05,$00,$07,$B1,$11
                                  .db $B5,$11,$C4,$51,$B9,$11,$59,$25
                                  .db $00,$07,$BD,$11,$C4,$11,$C4,$51
                                  .db $D8,$11,$59,$45,$00,$0D,$D6,$11
                                  .db $D8,$11,$C9,$11,$CA,$11,$F9,$15
                                  .db $FA,$15,$FB,$15,$59,$65,$00,$0D
                                  .db $C9,$11,$CA,$11,$CB,$11,$DA,$11
                                  .db $FC,$15,$FD,$15,$FE,$15,$59,$85
                                  .db $00,$0D,$CB,$11,$DA,$11,$CB,$11
                                  .db $92,$11,$95,$11,$98,$11,$AD,$11
                                  .db $59,$A4,$00,$0F,$F3,$11,$F4,$11
                                  .db $F5,$11,$FC,$38,$B1,$11,$B5,$11
                                  .db $C4,$51,$B9,$11,$59,$C4,$00,$0F
                                  .db $F6,$11,$F7,$11,$F8,$11,$DA,$05
                                  .db $BD,$11,$C4,$11,$C4,$51,$D8,$11
                                  .db $59,$CF,$00,$05,$F9,$15,$FA,$15
                                  .db $FB,$15,$59,$E3,$00,$1D,$CB,$15
                                  .db $FC,$11,$FD,$11,$FE,$11,$FC,$38
                                  .db $D6,$11,$D8,$11,$C9,$11,$CA,$11
                                  .db $F3,$15,$F4,$15,$F5,$15,$FC,$15
                                  .db $FD,$15,$FE,$15,$5A,$08,$00,$17
                                  .db $C9,$11,$CA,$11,$CB,$11,$DA,$11
                                  .db $F6,$15,$F7,$15,$F8,$15,$F9,$55
                                  .db $FC,$0D,$F3,$15,$F4,$15,$F5,$15
                                  .db $5A,$28,$00,$19,$CB,$11,$DA,$11
                                  .db $CB,$11,$DA,$11,$FD,$15,$FD,$15
                                  .db $FE,$15,$DA,$55,$F9,$15,$F6,$15
                                  .db $F7,$15,$F8,$15,$FB,$15,$5A,$49
                                  .db $00,$17,$DA,$15,$F9,$05,$FA,$05
                                  .db $FB,$05,$FC,$38,$FC,$38,$DA,$15
                                  .db $FE,$15,$FC,$15,$FD,$15,$FE,$15
                                  .db $DA,$55,$5A,$6A,$00,$09,$FC,$05
                                  .db $FD,$05,$FE,$05,$FC,$38,$DA,$05
                                  .db $58,$F6,$00,$05,$F9,$11,$FA,$11
                                  .db $FB,$11,$59,$13,$00,$0B,$F9,$11
                                  .db $FA,$11,$FB,$11,$FC,$11,$FD,$11
                                  .db $FE,$11,$59,$31,$00,$09,$F9,$15
                                  .db $FA,$15,$FB,$15,$FD,$11,$FE,$11
                                  .db $59,$51,$00,$11,$FC,$15,$FD,$15
                                  .db $FE,$15,$F3,$11,$F4,$11,$F5,$11
                                  .db $FC,$11,$FD,$11,$FE,$11,$59,$72
                                  .db $00,$0B,$FC,$15,$F9,$15,$F6,$11
                                  .db $F7,$11,$F8,$11,$DA,$51,$59,$92
                                  .db $00,$0D,$DA,$15,$FE,$15,$FC,$11
                                  .db $FD,$11,$FE,$11,$FC,$11,$DA,$55
                                  .db $57,$DA,$00,$05,$F9,$11,$FA,$11
                                  .db $FB,$11,$57,$FA,$00,$05,$FC,$11
                                  .db $FD,$11,$FE,$11,$5C,$3C,$00,$01
                                  .db $DA,$11,$5C,$6D,$00,$05,$F9,$11
                                  .db $FA,$11,$FB,$11,$5C,$8D,$00,$05
                                  .db $FC,$11,$FD,$11,$FE,$11,$5C,$E5
                                  .db $00,$07,$92,$11,$95,$11,$98,$11
                                  .db $AD,$11,$5D,$05,$00,$07,$B1,$11
                                  .db $B5,$11,$C4,$51,$B9,$11,$5D,$25
                                  .db $00,$07,$BD,$11,$C4,$11,$C4,$51
                                  .db $D8,$11,$5D,$45,$00,$0D,$D6,$11
                                  .db $D8,$11,$C9,$11,$CA,$11,$F9,$51
                                  .db $FA,$51,$FB,$51,$5D,$65,$00,$0D
                                  .db $C9,$11,$CA,$11,$CB,$11,$DA,$11
                                  .db $FC,$51,$FD,$51,$FE,$51,$5D,$85
                                  .db $00,$0D,$CB,$11,$DA,$11,$CB,$11
                                  .db $92,$11,$95,$11,$98,$11,$AD,$11
                                  .db $5D,$A4,$00,$0F,$F3,$11,$F4,$11
                                  .db $F5,$11,$FC,$38,$B1,$11,$B5,$11
                                  .db $C4,$51,$B9,$11,$5D,$C4,$00,$0F
                                  .db $F6,$11,$F7,$11,$F8,$11,$DA,$05
                                  .db $BD,$11,$C4,$11,$C4,$51,$D8,$11
                                  .db $5D,$CF,$00,$05,$F9,$15,$FA,$15
                                  .db $FB,$15,$5D,$E3,$00,$1D,$CB,$15
                                  .db $FC,$11,$FD,$11,$FE,$11,$FC,$38
                                  .db $D6,$11,$D8,$11,$C9,$11,$CA,$11
                                  .db $F3,$15,$F4,$15,$F5,$15,$FC,$15
                                  .db $FD,$15,$FE,$15,$5E,$08,$00,$17
                                  .db $C9,$11,$CA,$11,$CB,$11,$DA,$11
                                  .db $F6,$15,$F7,$15,$F8,$15,$F9,$55
                                  .db $FC,$0D,$F3,$15,$F4,$15,$F5,$15
                                  .db $5E,$28,$00,$19,$CB,$11,$DA,$11
                                  .db $CB,$11,$DA,$11,$FD,$15,$FD,$15
                                  .db $FE,$15,$DA,$55,$F9,$15,$F6,$15
                                  .db $F7,$15,$F8,$15,$FB,$15,$5E,$49
                                  .db $00,$17,$DA,$15,$F9,$05,$FA,$05
                                  .db $FB,$05,$FC,$38,$FC,$38,$DA,$15
                                  .db $FE,$15,$FC,$15,$FD,$15,$FE,$15
                                  .db $DA,$55,$5E,$6A,$00,$09,$FC,$05
                                  .db $FD,$05,$FE,$05,$FC,$38,$DA,$05
                                  .db $5C,$F6,$00,$05,$F9,$11,$FA,$11
                                  .db $FB,$11,$5D,$13,$00,$0B,$F9,$11
                                  .db $FA,$11,$FB,$11,$FC,$11,$FD,$11
                                  .db $FE,$11,$5D,$31,$00,$09,$F9,$15
                                  .db $FA,$15,$FB,$15,$FD,$11,$FE,$11
                                  .db $5D,$51,$00,$11,$FC,$15,$FD,$15
                                  .db $FE,$15,$F3,$11,$F4,$11,$F5,$11
                                  .db $FC,$11,$FD,$11,$FE,$11,$5D,$72
                                  .db $00,$0B,$FC,$15,$F9,$15,$F6,$11
                                  .db $F7,$11,$F8,$11,$DA,$51,$5D,$92
                                  .db $00,$0D,$DA,$15,$FE,$15,$FC,$11
                                  .db $FD,$11,$FE,$11,$FC,$11,$DA,$55
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF

DATA_05A580:                      .db $51,$A7,$51,$87,$51,$67,$51,$47
                                  .db $51,$27,$51,$07,$50,$E7,$50,$C7
DATA_05A590:                      .db $14,$45,$3F,$08,$00,$29,$AA,$27
                                  .db $26,$84,$95,$A9,$15,$13,$CE,$A7
                                  .db $A4,$25,$A5,$05,$A6,$2A,$28

DATA_05A5A7:                      .db $8D,$00,$8D,$00,$8D,$00,$8D,$00
                                  .db $00,$00,$91,$02,$1D,$04,$18,$05
                                  .db $1D,$06,$B7,$08,$B2,$07,$0B,$03
                                  .db $3C,$08,$9D,$09,$9E,$0A,$A0,$04
                                  .db $2C,$0A,$A6,$06,$30,$07,$11,$09
                                  .db $A4,$05,$8F,$03,$09,$01,$0A,$02
                                  .db $91,$01

DATA_05A5D9:                      .db $16,$44,$4B,$42,$4E,$4C,$44,$1A
                                  .db $1F,$1F,$1F,$13,$47,$48,$52,$1F
                                  .db $48,$D2,$03,$48,$4D,$4E,$52,$40
                                  .db $54,$51,$1F,$0B,$40,$4D,$43,$1B
                                  .db $1F,$1F,$08,$CD,$53,$47,$48,$52
                                  .db $1F,$52,$53,$51,$40,$4D,$46,$44
                                  .db $1F,$1F,$4B,$40,$4D,$C3,$56,$44
                                  .db $1F,$1F,$1F,$1F,$45,$48,$4D,$43
                                  .db $1F,$1F,$1F,$1F,$53,$47,$40,$D3
                                  .db $0F,$51,$48,$4D,$42,$44,$52,$52
                                  .db $1F,$13,$4E,$40,$43,$52,$53,$4E
                                  .db $4E,$CB,$48,$52,$1F,$1F,$4C,$48
                                  .db $52,$52,$48,$4D,$46,$1F,$40,$46
                                  .db $40,$48,$4D,$9A,$0B,$4E,$4E,$4A
                                  .db $52,$1F,$1F,$4B,$48,$4A,$44,$1F
                                  .db $01,$4E,$56,$52,$44,$D1,$48,$52
                                  .db $1F,$40,$53,$1F,$48,$53,$1F,$40
                                  .db $46,$40,$48,$4D,$9A,$1C,$1F,$12
                                  .db $16,$08,$13,$02,$07,$1F,$0F,$00
                                  .db $0B,$00,$02,$04,$1F,$9C,$13,$47
                                  .db $44,$1F,$1F,$4F,$4E,$56,$44,$51
                                  .db $1F,$1F,$4E,$45,$1F,$53,$47,$C4
                                  .db $52,$56,$48,$53,$42,$47,$1F,$1F
                                  .db $58,$4E,$54,$1F,$1F,$1F,$47,$40
                                  .db $55,$C4,$4F,$54,$52,$47,$44,$43
                                  .db $1F,$1F,$56,$48,$4B,$4B,$1F,$1F
                                  .db $53,$54,$51,$CD,$9F,$1F,$1F,$1F
                                  .db $1F,$1F,$1F,$48,$4D,$53,$4E,$1F
                                  .db $1F,$1F,$1F,$1F,$9B,$18,$4E,$54
                                  .db $51,$1F,$4F,$51,$4E,$46,$51,$44
                                  .db $52,$52,$1F,$56,$48,$4B,$CB,$40
                                  .db $4B,$52,$4E,$1F,$1F,$1F,$41,$44
                                  .db $1F,$1F,$1F,$52,$40,$55,$44,$43
                                  .db $9B,$07,$44,$4B,$4B,$4E,$1A,$1F
                                  .db $1F,$1F,$12,$4E,$51,$51,$58,$1F
                                  .db $08,$5D,$CC,$4D,$4E,$53,$1F,$1F
                                  .db $47,$4E,$4C,$44,$1D,$1F,$1F,$41
                                  .db $54,$53,$1F,$1F,$88,$47,$40,$55
                                  .db $44,$1F,$1F,$1F,$1F,$46,$4E,$4D
                                  .db $44,$1F,$1F,$1F,$1F,$53,$CE,$51
                                  .db $44,$52,$42,$54,$44,$1F,$1F,$4C
                                  .db $58,$1F,$45,$51,$48,$44,$4D,$43
                                  .db $D2,$56,$47,$4E,$1F,$56,$44,$51
                                  .db $44,$1F,$1F,$42,$40,$4F,$53,$54
                                  .db $51,$44,$C3,$41,$58,$1F,$01,$4E
                                  .db $56,$52,$44,$51,$9B,$1F,$1F,$1F
                                  .db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
                                  .db $1F,$1F,$1F,$1F,$1F,$60,$E1,$1F
                                  .db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
                                  .db $1C,$1F,$18,$4E,$52,$47,$48,$62
                                  .db $E3,$07,$4E,$4E,$51,$40,$58,$1A
                                  .db $1F,$1F,$13,$47,$40,$4D,$4A,$1F
                                  .db $58,$4E,$D4,$45,$4E,$51,$1F,$51
                                  .db $44,$52,$42,$54,$48,$4D,$46,$1F
                                  .db $1F,$1F,$4C,$44,$9B,$0C,$58,$1F
                                  .db $4D,$40,$4C,$44,$1F,$1F,$48,$52
                                  .db $1F,$18,$4E,$52,$47,$48,$9B,$0E
                                  .db $4D,$1F,$1F,$1F,$4C,$58,$1F,$1F
                                  .db $1F,$56,$40,$58,$1F,$1F,$1F,$53
                                  .db $CE,$51,$44,$52,$42,$54,$44,$1F
                                  .db $4C,$58,$1F,$45,$51,$48,$44,$4D
                                  .db $43,$52,$9D,$01,$4E,$56,$52,$44
                                  .db $51,$1F,$53,$51,$40,$4F,$4F,$44
                                  .db $43,$1F,$1F,$4C,$C4,$48,$4D,$1F
                                  .db $53,$47,$40,$53,$1F,$44,$46,$46
                                  .db $9B,$9F,$08,$53,$1F,$48,$52,$1F
                                  .db $4F,$4E,$52,$52,$48,$41,$4B,$44
                                  .db $1F,$1F,$53,$CE,$45,$48,$4B,$4B
                                  .db $1F,$48,$4D,$1F,$53,$47,$44,$1F
                                  .db $43,$4E,$53,$53,$44,$C3,$4B,$48
                                  .db $4D,$44,$1F,$41,$4B,$4E,$42,$4A
                                  .db $52,$1B,$1F,$1F,$1F,$1F,$13,$CE
                                  .db $45,$48,$4B,$4B,$1F,$48,$4D,$1F
                                  .db $53,$47,$44,$1F,$58,$44,$4B,$4B
                                  .db $4E,$D6,$4E,$4D,$44,$52,$1D,$1F
                                  .db $49,$54,$52,$53,$1F,$46,$4E,$1F
                                  .db $56,$44,$52,$D3,$53,$47,$44,$4D
                                  .db $1F,$4D,$4E,$51,$53,$47,$1F,$1F
                                  .db $53,$4E,$1F,$53,$47,$C4,$53,$4E
                                  .db $4F,$1F,$1F,$1F,$1F,$1F,$4E,$45
                                  .db $1F,$1F,$1F,$1F,$1F,$53,$47,$C4
                                  .db $4C,$4E,$54,$4D,$53,$40,$48,$4D
                                  .db $9B,$1C,$0F,$0E,$08,$0D,$13,$1F
                                  .db $0E,$05,$1F,$00,$03,$15,$08,$02
                                  .db $04,$9C,$18,$4E,$54,$1F,$1F,$42
                                  .db $40,$4D,$1F,$1F,$47,$4E,$4B,$43
                                  .db $1F,$1F,$40,$CD,$44,$57,$53,$51
                                  .db $40,$1F,$48,$53,$44,$4C,$1F,$1F
                                  .db $48,$4D,$1F,$53,$47,$C4,$41,$4E
                                  .db $57,$1F,$40,$53,$1F,$1F,$53,$47
                                  .db $44,$1F,$53,$4E,$4F,$1F,$4E,$C5
                                  .db $53,$47,$44,$1F,$52,$42,$51,$44
                                  .db $44,$4D,$1B,$1F,$1F,$1F,$1F,$1F
                                  .db $13,$CE,$54,$52,$44,$1F,$48,$53
                                  .db $1D,$1F,$1F,$4F,$51,$44,$52,$52
                                  .db $1F,$53,$47,$C4,$12,$04,$0B,$04
                                  .db $02,$13,$1F,$01,$54,$53,$53,$4E
                                  .db $4D,$9B,$9F,$1C,$0F,$0E,$08,$0D
                                  .db $13,$1F,$0E,$05,$1F,$00,$03,$15
                                  .db $08,$02,$04,$9C,$13,$4E,$1F,$1F
                                  .db $1F,$4F,$48,$42,$4A,$1F,$1F,$1F
                                  .db $54,$4F,$1F,$1F,$1F,$C0,$52,$47
                                  .db $44,$4B,$4B,$1D,$1F,$1F,$54,$52
                                  .db $44,$1F,$1F,$53,$47,$44,$1F,$97
                                  .db $4E,$51,$1F,$1F,$18,$1F,$1F,$01
                                  .db $54,$53,$53,$4E,$4D,$1B,$1F,$1F
                                  .db $13,$CE,$53,$47,$51,$4E,$56,$1F
                                  .db $1F,$1F,$1F,$40,$1F,$1F,$1F,$52
                                  .db $47,$44,$4B,$CB,$54,$4F,$56,$40
                                  .db $51,$43,$52,$1D,$1F,$1F,$4B,$4E
                                  .db $4E,$4A,$1F,$1F,$54,$CF,$40,$4D
                                  .db $43,$1F,$4B,$44,$53,$1F,$46,$4E
                                  .db $1F,$4E,$45,$1F,$1F,$53,$47,$C4
                                  .db $41,$54,$53,$53,$4E,$4D,$9B,$13
                                  .db $4E,$1F,$43,$4E,$1F,$40,$1F,$52
                                  .db $4F,$48,$4D,$1F,$49,$54,$4C,$4F
                                  .db $9D,$4F,$51,$44,$52,$52,$1F,$1F
                                  .db $1F,$1F,$53,$47,$44,$1F,$1F,$1F
                                  .db $1F,$1F,$80,$01,$54,$53,$53,$4E
                                  .db $4D,$1B,$1F,$1F,$1F,$1F,$00,$1F
                                  .db $12,$54,$4F,$44,$D1,$0C,$40,$51
                                  .db $48,$4E,$1F,$1F,$1F,$52,$4F,$48
                                  .db $4D,$1F,$1F,$49,$54,$4C,$CF,$42
                                  .db $40,$4D,$1F,$41,$51,$44,$40,$4A
                                  .db $1F,$52,$4E,$4C,$44,$1F,$1F,$4E
                                  .db $C5,$53,$47,$44,$1F,$1F,$1F,$41
                                  .db $4B,$4E,$42,$4A,$52,$1F,$1F,$1F
                                  .db $40,$4D,$C3,$43,$44,$45,$44,$40
                                  .db $53,$1F,$52,$4E,$4C,$44,$1F,$4E
                                  .db $45,$1F,$53,$47,$C4,$53,$4E,$54
                                  .db $46,$47,$44,$51,$1F,$44,$4D,$44
                                  .db $4C,$48,$44,$52,$9B,$1C,$0F,$0E
                                  .db $08,$0D,$13,$1F,$0E,$05,$1F,$00
                                  .db $03,$15,$08,$02,$04,$9C,$13,$47
                                  .db $48,$52,$1F,$1F,$1F,$46,$40,$53
                                  .db $44,$1F,$1F,$4C,$40,$51,$4A,$D2
                                  .db $53,$47,$44,$1F,$4C,$48,$43,$43
                                  .db $4B,$44,$1F,$4E,$45,$1F,$53,$47
                                  .db $48,$D2,$40,$51,$44,$40,$1B,$1F
                                  .db $1F,$1F,$01,$58,$1F,$42,$54,$53
                                  .db $53,$48,$4D,$C6,$53,$47,$44,$1F
                                  .db $53,$40,$4F,$44,$1F,$47,$44,$51
                                  .db $44,$1D,$1F,$58,$4E,$D4,$42,$40
                                  .db $4D,$1F,$42,$4E,$4D,$53,$48,$4D
                                  .db $54,$44,$1F,$1F,$45,$51,$4E,$CC
                                  .db $42,$4B,$4E,$52,$44,$1F,$1F,$1F
                                  .db $53,$4E,$1F,$1F,$1F,$1F,$53,$47
                                  .db $48,$D2,$4F,$4E,$48,$4D,$53,$9B
                                  .db $1C,$0F,$0E,$08,$0D,$13,$1F,$0E
                                  .db $05,$1F,$00,$03,$15,$08,$02,$04
                                  .db $9C,$13,$47,$44,$1F,$41,$48,$46
                                  .db $1F,$42,$4E,$48,$4D,$52,$1F,$1F
                                  .db $40,$51,$C4,$03,$51,$40,$46,$4E
                                  .db $4D,$1F,$02,$4E,$48,$4D,$52,$1B
                                  .db $1F,$1F,$1F,$08,$C5,$58,$4E,$54
                                  .db $1F,$1F,$4F,$48,$42,$4A,$1F,$54
                                  .db $4F,$1F,$1F,$45,$48,$55,$C4,$4E
                                  .db $45,$1F,$1F,$53,$47,$44,$52,$44
                                  .db $1F,$1F,$48,$4D,$1F,$1F,$4E,$4D
                                  .db $C4,$40,$51,$44,$40,$1D,$1F,$1F
                                  .db $58,$4E,$54,$1F,$1F,$46,$44,$53
                                  .db $1F,$40,$CD,$44,$57,$53,$51,$40
                                  .db $1F,$0C,$40,$51,$48,$4E,$9B,$9F
                                  .db $16,$47,$44,$4D,$1F,$58,$4E,$54
                                  .db $1F,$1F,$52,$53,$4E,$4C,$4F,$1F
                                  .db $4E,$CD,$40,$4D,$1F,$44,$4D,$44
                                  .db $4C,$58,$1D,$1F,$1F,$58,$4E,$54
                                  .db $1F,$42,$40,$CD,$49,$54,$4C,$4F
                                  .db $1F,$47,$48,$46,$47,$1F,$1F,$48
                                  .db $45,$1F,$1F,$58,$4E,$D4,$47,$4E
                                  .db $4B,$43,$1F,$1F,$1F,$1F,$53,$47
                                  .db $44,$1F,$1F,$1F,$49,$54,$4C,$CF
                                  .db $41,$54,$53,$53,$4E,$4D,$1B,$1F
                                  .db $1F,$14,$52,$44,$1F,$14,$4F,$1F
                                  .db $4E,$CD,$53,$47,$44,$1F,$02,$4E
                                  .db $4D,$53,$51,$4E,$4B,$1F,$0F,$40
                                  .db $43,$1F,$53,$CE,$49,$54,$4C,$4F
                                  .db $1F,$47,$48,$46,$47,$1F,$1F,$48
                                  .db $4D,$1F,$1F,$53,$47,$C4,$52,$47
                                  .db $40,$4B,$4B,$4E,$56,$1F,$56,$40
                                  .db $53,$44,$51,$9B,$08,$45,$1F,$1F
                                  .db $58,$4E,$54,$1F,$40,$51,$44,$1F
                                  .db $1F,$48,$4D,$1F,$40,$CD,$40,$51
                                  .db $44,$40,$1F,$53,$47,$40,$53,$1F
                                  .db $58,$4E,$54,$1F,$47,$40,$55,$C4
                                  .db $40,$4B,$51,$44,$40,$43,$58,$1F
                                  .db $1F,$1F,$42,$4B,$44,$40,$51,$44
                                  .db $43,$9D,$58,$4E,$54,$1F,$42,$40
                                  .db $4D,$1F,$1F,$51,$44,$53,$54,$51
                                  .db $4D,$1F,$53,$CE,$53,$47,$44,$1F
                                  .db $4C,$40,$4F,$1F,$52,$42,$51,$44
                                  .db $44,$4D,$1F,$1F,$41,$D8,$4F,$51
                                  .db $44,$52,$52,$48,$4D,$46,$1F,$1F
                                  .db $1F,$1F,$12,$13,$00,$11,$13,$9D
                                  .db $53,$47,$44,$4D,$1F,$12,$04,$0B
                                  .db $04,$02,$13,$9B,$9F,$18,$4E,$54
                                  .db $1F,$1F,$1F,$46,$44,$53,$1F,$1F
                                  .db $1F,$1F,$01,$4E,$4D,$54,$D2,$12
                                  .db $53,$40,$51,$52,$1F,$1F,$48,$45
                                  .db $1F,$1F,$58,$4E,$54,$1F,$42,$54
                                  .db $D3,$53,$47,$44,$1F,$1F,$53,$40
                                  .db $4F,$44,$1F,$1F,$40,$53,$1F,$1F
                                  .db $53,$47,$C4,$44,$4D,$43,$1F,$1F
                                  .db $4E,$45,$1F,$44,$40,$42,$47,$1F
                                  .db $40,$51,$44,$40,$9B,$08,$45,$1F
                                  .db $58,$4E,$54,$1F,$42,$4E,$4B,$4B
                                  .db $44,$42,$53,$1F,$64,$6B,$EB,$01
                                  .db $4E,$4D,$54,$52,$1F,$1F,$12,$53
                                  .db $40,$51,$52,$1F,$1F,$1F,$58,$4E
                                  .db $D4,$42,$40,$4D,$1F,$1F,$1F,$4F
                                  .db $4B,$40,$58,$1F,$1F,$40,$1F,$1F
                                  .db $45,$54,$CD,$41,$4E,$4D,$54,$52
                                  .db $1F,$46,$40,$4C,$44,$9B,$0F,$51
                                  .db $44,$52,$52,$1F,$14,$4F,$1F,$1F
                                  .db $1F,$4E,$4D,$1F,$1F,$53,$47,$C4
                                  .db $02,$4E,$4D,$53,$51,$4E,$4B,$1F
                                  .db $0F,$40,$43,$1F,$1F,$56,$47,$48
                                  .db $4B,$C4,$49,$54,$4C,$4F,$48,$4D
                                  .db $46,$1F,$1F,$1F,$40,$4D,$43,$1F
                                  .db $1F,$58,$4E,$D4,$42,$40,$4D,$1F
                                  .db $1F,$42,$4B,$48,$4D,$46,$1F,$1F
                                  .db $53,$4E,$1F,$53,$47,$C4,$45,$44
                                  .db $4D,$42,$44,$1B,$1F,$1F,$1F,$1F
                                  .db $13,$4E,$1F,$46,$4E,$1F,$48,$CD
                                  .db $53,$47,$44,$1F,$1F,$43,$4E,$4E
                                  .db $51,$1F,$1F,$40,$53,$1F,$1F,$53
                                  .db $47,$C4,$44,$4D,$43,$1F,$1F,$4E
                                  .db $45,$1F,$53,$47,$48,$52,$1F,$40
                                  .db $51,$44,$40,$9D,$54,$52,$44,$1F
                                  .db $14,$4F,$1F,$40,$4B,$52,$4E,$9B
                                  .db $1C,$0F,$0E,$08,$0D,$13,$1F,$0E
                                  .db $05,$1F,$00,$03,$15,$08,$02,$04
                                  .db $9C,$0E,$4D,$44,$1F,$1F,$1F,$4E
                                  .db $45,$1F,$1F,$1F,$18,$4E,$52,$47
                                  .db $48,$5D,$D2,$45,$51,$48,$44,$4D
                                  .db $43,$52,$1F,$48,$52,$1F,$53,$51
                                  .db $40,$4F,$4F,$44,$C3,$48,$4D,$1F
                                  .db $1F,$53,$47,$44,$1F,$42,$40,$52
                                  .db $53,$4B,$44,$1F,$1F,$41,$D8,$08
                                  .db $46,$46,$58,$1F,$0A,$4E,$4E,$4F
                                  .db $40,$1B,$1F,$1F,$1F,$1F,$1F,$13
                                  .db $CE,$43,$44,$45,$44,$40,$53,$1F
                                  .db $1F,$47,$48,$4C,$1D,$1F,$1F,$4F
                                  .db $54,$52,$C7,$47,$48,$4C,$1F,$48
                                  .db $4D,$53,$4E,$1F,$1F,$53,$47,$44
                                  .db $1F,$4B,$40,$55,$C0,$4F,$4E,$4E
                                  .db $4B,$9B,$14,$52,$44,$1F,$1F,$0C
                                  .db $40,$51,$48,$4E,$5D,$52,$1F,$1F
                                  .db $42,$40,$4F,$C4,$53,$4E,$1F,$1F
                                  .db $1F,$52,$4E,$40,$51,$1F,$1F,$53
                                  .db $47,$51,$4E,$54,$46,$C7,$53,$47
                                  .db $44,$1F,$40,$48,$51,$1A,$1F,$11
                                  .db $54,$4D,$1F,$45,$40,$52,$53,$9D
                                  .db $49,$54,$4C,$4F,$1D,$1F,$40,$4D
                                  .db $43,$1F,$47,$4E,$4B,$43,$1F,$53
                                  .db $47,$C4,$18,$1F,$01,$54,$53,$53
                                  .db $4E,$4D,$1B,$1F,$1F,$13,$4E,$1F
                                  .db $4A,$44,$44,$CF,$41,$40,$4B,$40
                                  .db $4D,$42,$44,$1D,$1F,$1F,$54,$52
                                  .db $44,$1F,$4B,$44,$45,$D3,$40,$4D
                                  .db $43,$1F,$1F,$51,$48,$46,$47,$53
                                  .db $1F,$1F,$4E,$4D,$1F,$53,$47,$C4
                                  .db $02,$4E,$4D,$53,$51,$4E,$4B,$1F
                                  .db $0F,$40,$43,$9B,$13,$47,$44,$1F
                                  .db $51,$44,$43,$1F,$43,$4E,$53,$1F
                                  .db $1F,$40,$51,$44,$40,$D2,$4E,$4D
                                  .db $1F,$1F,$53,$47,$44,$1F,$1F,$4C
                                  .db $40,$4F,$1F,$1F,$47,$40,$55,$C4
                                  .db $53,$56,$4E,$1F,$1F,$1F,$1F,$1F
                                  .db $1F,$43,$48,$45,$45,$44,$51,$44
                                  .db $4D,$D3,$44,$57,$48,$53,$52,$1B
                                  .db $1F,$1F,$1F,$1F,$1F,$1F,$08,$45
                                  .db $1F,$58,$4E,$D4,$47,$40,$55,$44
                                  .db $1F,$1F,$53,$47,$44,$1F,$53,$48
                                  .db $4C,$44,$1F,$40,$4D,$C3,$52,$4A
                                  .db $48,$4B,$4B,$1D,$1F,$1F,$41,$44
                                  .db $1F,$52,$54,$51,$44,$1F,$53,$CE
                                  .db $4B,$4E,$4E,$4A,$1F,$45,$4E,$51
                                  .db $1F,$53,$47,$44,$4C,$9B,$9F,$13
                                  .db $47,$48,$52,$1F,$1F,$48,$52,$1F
                                  .db $1F,$40,$1F,$1F,$06,$47,$4E,$52
                                  .db $D3,$07,$4E,$54,$52,$44,$1B,$1F
                                  .db $1F,$1F,$1F,$1F,$02,$40,$4D,$1F
                                  .db $58,$4E,$D4,$45,$48,$4D,$43,$1F
                                  .db $1F,$1F,$53,$47,$44,$1F,$1F,$1F
                                  .db $44,$57,$48,$53,$9E,$07,$44,$44
                                  .db $1D,$1F,$1F,$47,$44,$44,$1D,$1F
                                  .db $1F,$47,$44,$44,$1B,$1B,$9B,$03
                                  .db $4E,$4D,$5D,$53,$1F,$46,$44,$53
                                  .db $1F,$4B,$4E,$52,$53,$9A,$9F,$9F
                                  .db $9F,$18,$4E,$54,$1F,$42,$40,$4D
                                  .db $1F,$1F,$52,$4B,$48,$43,$44,$1F
                                  .db $53,$47,$C4,$52,$42,$51,$44,$44
                                  .db $4D,$1F,$1F,$1F,$4B,$44,$45,$53
                                  .db $1F,$1F,$1F,$4E,$D1,$51,$48,$46
                                  .db $47,$53,$1F,$1F,$41,$58,$1F,$4F
                                  .db $51,$44,$52,$52,$48,$4D,$C6,$53
                                  .db $47,$44,$1F,$0B,$1F,$4E,$51,$1F
                                  .db $11,$1F,$01,$54,$53,$53,$4E,$4D
                                  .db $D2,$4E,$4D,$1F,$1F,$1F,$53,$4E
                                  .db $4F,$1F,$1F,$1F,$4E,$45,$1F,$1F
                                  .db $53,$47,$C4,$42,$4E,$4D,$53,$51
                                  .db $4E,$4B,$4B,$44,$51,$1B,$1F,$1F
                                  .db $1F,$1F,$18,$4E,$D4,$4C,$40,$58
                                  .db $1F,$41,$44,$1F,$40,$41,$4B,$44
                                  .db $1F,$53,$4E,$1F,$52,$44,$C4,$45
                                  .db $54,$51,$53,$47,$44,$51,$1F,$40
                                  .db $47,$44,$40,$43,$9B,$13,$47,$44
                                  .db $51,$44,$1F,$1F,$1F,$40,$51,$44
                                  .db $1F,$1F,$1F,$45,$48,$55,$C4,$44
                                  .db $4D,$53,$51,$40,$4D,$42,$44,$52
                                  .db $1F,$1F,$53,$4E,$1F,$1F,$53,$47
                                  .db $C4,$12,$53,$40,$51,$1F,$1F,$1F
                                  .db $16,$4E,$51,$4B,$43,$1F,$1F,$1F
                                  .db $1F,$48,$CD,$03,$48,$4D,$4E,$52
                                  .db $40,$54,$51,$1F,$1F,$1F,$1F,$1F
                                  .db $0B,$40,$4D,$43,$9B,$05,$48,$4D
                                  .db $43,$1F,$1F,$53,$47,$44,$4C,$1F
                                  .db $40,$4B,$4B,$1F,$40,$4D,$C3,$58
                                  .db $4E,$54,$1F,$1F,$1F,$42,$40,$4D
                                  .db $1F,$1F,$1F,$53,$51,$40,$55,$44
                                  .db $CB,$41,$44,$53,$56,$44,$44,$4D
                                  .db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$4C
                                  .db $40,$4D,$D8,$43,$48,$45,$45,$44
                                  .db $51,$44,$4D,$53,$1F,$4F,$4B,$40
                                  .db $42,$44,$52,$9B,$07,$44,$51,$44
                                  .db $1D,$1F,$1F,$1F,$53,$47,$44,$1F
                                  .db $1F,$42,$4E,$48,$4D,$D2,$58,$4E
                                  .db $54,$1F,$1F,$1F,$42,$4E,$4B,$4B
                                  .db $44,$42,$53,$1F,$1F,$1F,$4E,$D1
                                  .db $53,$47,$44,$1F,$53,$48,$4C,$44
                                  .db $1F,$51,$44,$4C,$40,$48,$4D,$48
                                  .db $4D,$C6,$42,$40,$4D,$1F,$1F,$42
                                  .db $47,$40,$4D,$46,$44,$1F,$1F,$1F
                                  .db $58,$4E,$54,$D1,$4F,$51,$4E,$46
                                  .db $51,$44,$52,$52,$1B,$1F,$1F,$02
                                  .db $40,$4D,$1F,$58,$4E,$D4,$45,$48
                                  .db $4D,$43,$1F,$1F,$53,$47,$44,$1F
                                  .db $1F,$52,$4F,$44,$42,$48,$40,$CB
                                  .db $46,$4E,$40,$4B,$9E,$9F,$00,$4C
                                  .db $40,$59,$48,$4D,$46,$1A,$1F,$1F
                                  .db $05,$44,$56,$1F,$47,$40,$55,$C4
                                  .db $4C,$40,$43,$44,$1F,$48,$53,$1F
                                  .db $1F,$53,$47,$48,$52,$1F,$45,$40
                                  .db $51,$9B,$01,$44,$58,$4E,$4D,$43
                                  .db $1F,$1F,$4B,$48,$44,$52,$1F,$1F
                                  .db $1F,$53,$47,$C4,$12,$4F,$44,$42
                                  .db $48,$40,$4B,$1F,$1F,$1F,$1F,$1F
                                  .db $1F,$19,$4E,$4D,$44,$9B,$02,$4E
                                  .db $4C,$4F,$4B,$44,$53,$44,$1F,$1F
                                  .db $48,$53,$1F,$1F,$1F,$40,$4D,$C3
                                  .db $58,$4E,$54,$1F,$42,$40,$4D,$1F
                                  .db $44,$57,$4F,$4B,$4E,$51,$44,$1F
                                  .db $1F,$C0,$52,$53,$51,$40,$4D,$46
                                  .db $44,$1F,$4D,$44,$56,$1F,$56,$4E
                                  .db $51,$4B,$43,$9B,$06,$0E,$0E,$03
                                  .db $1F,$0B,$14,$02,$0A,$9A

DATA_05B0FF:                      .db $50,$C7,$41,$E2,$FC,$38,$FF

DATA_05B106:                      .db $4C,$50

DATA_05B108:                      .db $50,$00

DATA_05B10A:                      .db $04,$FC

CODE_05B10C:        8B            PHB                       ; Accum (8 bit) 
CODE_05B10D:        4B            PHK                       
CODE_05B10E:        AB            PLB                       
CODE_05B10F:        AE 88 1B      LDX.W $1B88               
CODE_05B112:        AD 89 1B      LDA.W $1B89               
CODE_05B115:        DD 08 B1      CMP.W DATA_05B108,X       
CODE_05B118:        D0 77         BNE CODE_05B191           
CODE_05B11A:        8A            TXA                       
CODE_05B11B:        F0 15         BEQ CODE_05B132           
CODE_05B11D:        9C 26 14      STZ.W $1426               
CODE_05B120:        9C 88 1B      STZ.W $1B88               
CODE_05B123:        64 41         STZ $41                   
CODE_05B125:        64 42         STZ $42                   
CODE_05B127:        64 43         STZ $43                   
CODE_05B129:        9C 9F 0D      STZ.W $0D9F               
CODE_05B12C:        A9 02         LDA.B #$02                
CODE_05B12E:        85 44         STA $44                   
CODE_05B130:        80 5C         BRA CODE_05B18E           

CODE_05B132:        AD 09 01      LDA.W $0109               
CODE_05B135:        0D D2 13      ORA.W $13D2               
CODE_05B138:        F0 34         BEQ CODE_05B16E           
CODE_05B13A:        AD F5 1D      LDA.W $1DF5               
CODE_05B13D:        F0 2F         BEQ CODE_05B16E           
CODE_05B13F:        A5 13         LDA RAM_FrameCounter      
CODE_05B141:        29 03         AND.B #$03                
CODE_05B143:        D0 49         BNE CODE_05B18E           
CODE_05B145:        CE F5 1D      DEC.W $1DF5               
CODE_05B148:        D0 44         BNE CODE_05B18E           
CODE_05B14A:        AD D2 13      LDA.W $13D2               
CODE_05B14D:        F0 1F         BEQ CODE_05B16E           
CODE_05B14F:        AB            PLB                       
CODE_05B150:        EE E9 1D      INC.W $1DE9               
CODE_05B153:        A9 01         LDA.B #$01                
CODE_05B155:        8D CE 13      STA.W $13CE               
CODE_05B158:        80 0B         BRA CODE_05B165           

CODE_05B15A:        AB            PLB                       
CODE_05B15B:        A9 8E         LDA.B #$8E                
CODE_05B15D:        8D 19 1F      STA.W $1F19               
SubSideExit:        9C 09 01      STZ.W $0109               
CODE_05B163:        A9 00         LDA.B #$00                
CODE_05B165:        8D D5 0D      STA.W $0DD5               
CODE_05B168:        A9 0B         LDA.B #$0B                
CODE_05B16A:        8D 00 01      STA.W RAM_GameMode        
Return05B16D:       6B            RTL                       ; Return 

CODE_05B16E:        A5 15         LDA RAM_ControllerA       ; Index (8 bit) 
CODE_05B170:        29 F0         AND.B #$F0                
CODE_05B172:        F0 1A         BEQ CODE_05B18E           
CODE_05B174:        45 16         EOR $16                   
CODE_05B176:        29 F0         AND.B #$F0                
CODE_05B178:        F0 0C         BEQ CODE_05B186           
CODE_05B17A:        A5 17         LDA RAM_ControllerB       
CODE_05B17C:        29 C0         AND.B #$C0                
CODE_05B17E:        F0 0E         BEQ CODE_05B18E           
CODE_05B180:        45 18         EOR $18                   
CODE_05B182:        29 C0         AND.B #$C0                
CODE_05B184:        D0 08         BNE CODE_05B18E           
CODE_05B186:        AD 09 01      LDA.W $0109               
CODE_05B189:        D0 CF         BNE CODE_05B15A           
CODE_05B18B:        EE 88 1B      INC.W $1B88               
CODE_05B18E:        4C 99 B2      JMP.W CODE_05B299         

CODE_05B191:        DD 06 B1      CMP.W DATA_05B106,X       
CODE_05B194:        D0 0A         BNE CODE_05B1A0           
CODE_05B196:        8A            TXA                       
CODE_05B197:        F0 0A         BEQ CODE_05B1A3           
CODE_05B199:        20 1B B3      JSR.W CODE_05B31B         
CODE_05B19C:        A9 09         LDA.B #$09                
CODE_05B19E:        85 12         STA $12                   
CODE_05B1A0:        4C 50 B2      JMP.W CODE_05B250         

CODE_05B1A3:        A2 16         LDX.B #$16                
CODE_05B1A5:        A0 01         LDY.B #$01                
CODE_05B1A7:        BD 90 A5      LDA.W DATA_05A590,X       
CODE_05B1AA:        10 03         BPL CODE_05B1AF           
CODE_05B1AC:        C8            INY                       
CODE_05B1AD:        29 7F         AND.B #$7F                
CODE_05B1AF:        CC 26 14      CPY.W $1426               
CODE_05B1B2:        D0 05         BNE CODE_05B1B9           
CODE_05B1B4:        CD BF 13      CMP.W $13BF               
CODE_05B1B7:        F0 03         BEQ CODE_05B1BC           
CODE_05B1B9:        CA            DEX                       
CODE_05B1BA:        D0 E9         BNE CODE_05B1A5           
CODE_05B1BC:        AC 26 14      LDY.W $1426               
CODE_05B1BF:        C0 03         CPY.B #$03                
CODE_05B1C1:        D0 02         BNE CODE_05B1C5           
CODE_05B1C3:        A2 18         LDX.B #$18                
CODE_05B1C5:        E0 04         CPX.B #$04                
CODE_05B1C7:        B0 08         BCS CODE_05B1D1           
CODE_05B1C9:        E8            INX                       
CODE_05B1CA:        8E D2 13      STX.W $13D2               
CODE_05B1CD:        CA            DEX                       
CODE_05B1CE:        20 EB B2      JSR.W CODE_05B2EB         
CODE_05B1D1:        E0 16         CPX.B #$16                
CODE_05B1D3:        D0 06         BNE CODE_05B1DB           
CODE_05B1D5:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_05B1D8:        F0 01         BEQ CODE_05B1DB           
ADDR_05B1DA:        E8            INX                       
CODE_05B1DB:        8A            TXA                       
CODE_05B1DC:        0A            ASL                       
CODE_05B1DD:        AA            TAX                       
CODE_05B1DE:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05B1E0:        BD A7 A5      LDA.W DATA_05A5A7,X       
CODE_05B1E3:        85 00         STA $00                   
CODE_05B1E5:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_05B1E7:        AF 7B 83 7F   LDA.L $7F837B             
CODE_05B1EB:        AA            TAX                       
CODE_05B1EC:        A0 0E 00      LDY.W #$000E              
CODE_05B1EF:        B9 80 A5      LDA.W DATA_05A580,Y       
CODE_05B1F2:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_05B1F6:        A9 00 23      LDA.W #$2300              
CODE_05B1F9:        9F 7F 83 7F   STA.L $7F837F,X           
CODE_05B1FD:        5A            PHY                       
CODE_05B1FE:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05B200:        A9 12         LDA.B #$12                
CODE_05B202:        85 02         STA $02                   
CODE_05B204:        64 03         STZ $03                   
CODE_05B206:        A4 00         LDY $00                   
CODE_05B208:        A9 1F         LDA.B #$1F                
CODE_05B20A:        2C 03 00      BIT.W $0003               
CODE_05B20D:        30 09         BMI CODE_05B218           
CODE_05B20F:        B9 D9 A5      LDA.W DATA_05A5D9,Y       
CODE_05B212:        8D 03 00      STA.W $0003               
CODE_05B215:        29 7F         AND.B #$7F                
CODE_05B217:        C8            INY                       
CODE_05B218:        9F 81 83 7F   STA.L $7F8381,X           
CODE_05B21C:        A9 39         LDA.B #$39                
CODE_05B21E:        9F 82 83 7F   STA.L $7F8382,X           
CODE_05B222:        E8            INX                       
CODE_05B223:        E8            INX                       
CODE_05B224:        C6 02         DEC $02                   
CODE_05B226:        D0 E0         BNE CODE_05B208           
CODE_05B228:        84 00         STY $00                   
CODE_05B22A:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05B22C:        E8            INX                       
CODE_05B22D:        E8            INX                       
CODE_05B22E:        E8            INX                       
CODE_05B22F:        E8            INX                       
CODE_05B230:        7A            PLY                       
CODE_05B231:        88            DEY                       
CODE_05B232:        88            DEY                       
CODE_05B233:        10 BA         BPL CODE_05B1EF           
CODE_05B235:        A9 FF 00      LDA.W #$00FF              
CODE_05B238:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_05B23C:        8A            TXA                       
CODE_05B23D:        8F 7B 83 7F   STA.L $7F837B             
CODE_05B241:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_05B243:        A9 01         LDA.B #$01                
CODE_05B245:        8D D5 13      STA.W $13D5               
CODE_05B248:        64 22         STZ $22                   
CODE_05B24A:        64 23         STZ $23                   
CODE_05B24C:        64 24         STZ $24                   
CODE_05B24E:        64 25         STZ $25                   
CODE_05B250:        AE 88 1B      LDX.W $1B88               
CODE_05B253:        AD 89 1B      LDA.W $1B89               
CODE_05B256:        18            CLC                       
CODE_05B257:        7D 0A B1      ADC.W DATA_05B10A,X       
CODE_05B25A:        8D 89 1B      STA.W $1B89               
CODE_05B25D:        18            CLC                       
CODE_05B25E:        69 80         ADC.B #$80                
CODE_05B260:        EB            XBA                       
CODE_05B261:        A9 80         LDA.B #$80                
CODE_05B263:        38            SEC                       
CODE_05B264:        ED 89 1B      SBC.W $1B89               
CODE_05B267:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05B269:        A2 00         LDX.B #$00                
CODE_05B26B:        A0 50         LDY.B #$50                
CODE_05B26D:        EC 89 1B      CPX.W $1B89               
CODE_05B270:        90 03         BCC CODE_05B275           
CODE_05B272:        A9 FF 00      LDA.W #$00FF              
CODE_05B275:        99 EC 04      STA.W $04EC,Y             
CODE_05B278:        9D 3C 05      STA.W $053C,X             
CODE_05B27B:        E8            INX                       
CODE_05B27C:        E8            INX                       
CODE_05B27D:        88            DEY                       
CODE_05B27E:        88            DEY                       
CODE_05B27F:        D0 EC         BNE CODE_05B26D           
CODE_05B281:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05B283:        A9 22         LDA.B #$22                
CODE_05B285:        85 41         STA $41                   
CODE_05B287:        AC D2 13      LDY.W $13D2               
CODE_05B28A:        F0 02         BEQ CODE_05B28E           
CODE_05B28C:        A9 20         LDA.B #$20                
CODE_05B28E:        85 43         STA $43                   
CODE_05B290:        A9 22         LDA.B #$22                
CODE_05B292:        85 44         STA $44                   
CODE_05B294:        A9 80         LDA.B #$80                
CODE_05B296:        8D 9F 0D      STA.W $0D9F               
CODE_05B299:        AB            PLB                       
Return05B29A:       6B            RTL                       ; Return 


DATA_05B29B:                      .db $AD,$35,$AD,$75,$AD,$B5,$AD,$F5
                                  .db $A7,$35,$A7,$75,$B7,$35,$B7,$75
                                  .db $BD,$37,$BD,$77,$BD,$B7,$BD,$F7
                                  .db $A7,$37,$A7,$77,$B7,$37,$B7,$77
                                  .db $AD,$39,$AD,$79,$AD,$B9,$AD,$F9
                                  .db $A7,$39,$A7,$79,$B7,$39,$B7,$79
                                  .db $BD,$3B,$BD,$7B,$BD,$BB,$BD,$FB
                                  .db $A7,$3B,$A7,$7B,$B7,$3B,$B7,$7B
DATA_05B2DB:                      .db $50,$4F,$58,$4F,$50,$57,$58,$57
                                  .db $92,$4F,$9A,$4F,$92,$57,$9A,$57

CODE_05B2EB:        DA            PHX                       
CODE_05B2EC:        8A            TXA                       
CODE_05B2ED:        0A            ASL                       
CODE_05B2EE:        0A            ASL                       
CODE_05B2EF:        0A            ASL                       
CODE_05B2F0:        0A            ASL                       
CODE_05B2F1:        AA            TAX                       
CODE_05B2F2:        64 00         STZ $00                   
CODE_05B2F4:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05B2F6:        A0 1C         LDY.B #$1C                
CODE_05B2F8:        BD 9B B2      LDA.W DATA_05B29B,X       
CODE_05B2FB:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_05B2FE:        DA            PHX                       
CODE_05B2FF:        A6 00         LDX $00                   
CODE_05B301:        BD DB B2      LDA.W DATA_05B2DB,X       
CODE_05B304:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_05B307:        FA            PLX                       
CODE_05B308:        E8            INX                       
CODE_05B309:        E8            INX                       
CODE_05B30A:        E6 00         INC $00                   
CODE_05B30C:        E6 00         INC $00                   
CODE_05B30E:        88            DEY                       
CODE_05B30F:        88            DEY                       
CODE_05B310:        88            DEY                       
CODE_05B311:        88            DEY                       
CODE_05B312:        10 E4         BPL CODE_05B2F8           
CODE_05B314:        9C 00 04      STZ.W $0400               
CODE_05B317:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05B319:        FA            PLX                       
Return05B31A:       60            RTS                       ; Return 

CODE_05B31B:        A0 1C         LDY.B #$1C                
CODE_05B31D:        A9 F0         LDA.B #$F0                
CODE_05B31F:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_05B322:        88            DEY                       
CODE_05B323:        88            DEY                       
CODE_05B324:        88            DEY                       
CODE_05B325:        88            DEY                       
CODE_05B326:        10 F7         BPL CODE_05B31F           
Return05B328:       60            RTS                       ; Return 

ADDR_05B329:        48            PHA                       
ADDR_05B32A:        A9 01         LDA.B #$01                
ADDR_05B32C:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
ADDR_05B32F:        68            PLA                       
CODE_05B330:        85 00         STA $00                   
CODE_05B332:        18            CLC                       
CODE_05B333:        6D CC 13      ADC.W $13CC               
CODE_05B336:        8D CC 13      STA.W $13CC               
CODE_05B339:        AD C0 0D      LDA.W $0DC0               
CODE_05B33C:        F0 1C         BEQ Return05B35A          
CODE_05B33E:        38            SEC                       
CODE_05B33F:        E5 00         SBC $00                   
CODE_05B341:        10 02         BPL CODE_05B345           
ADDR_05B343:        A9 00         LDA.B #$00                
CODE_05B345:        8D C0 0D      STA.W $0DC0               
CODE_05B348:        80 10         BRA Return05B35A          

CODE_05B34A:        EE CC 13      INC.W $13CC               
CODE_05B34D:        A9 01         LDA.B #$01                
CODE_05B34F:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_05B352:        AD C0 0D      LDA.W $0DC0               
CODE_05B355:        F0 03         BEQ Return05B35A          
CODE_05B357:        CE C0 0D      DEC.W $0DC0               
Return05B35A:       6B            RTL                       ; Return 


DATA_05B35B:                      .db $80,$40,$20,$10,$08,$04,$02,$01

ADDR_05B363:        98            TYA                       ; \ Unreachable 
ADDR_05B364:        29 07         AND.B #$07                
ADDR_05B366:        48            PHA                       
ADDR_05B367:        98            TYA                       
ADDR_05B368:        4A            LSR                       
ADDR_05B369:        4A            LSR                       
ADDR_05B36A:        4A            LSR                       
ADDR_05B36B:        AA            TAX                       
ADDR_05B36C:        BD 02 1F      LDA.W $1F02,X             
ADDR_05B36F:        FA            PLX                       
ADDR_05B370:        3F 5B B3 05   AND.L DATA_05B35B,X       
Return05B374:       6B            RTL                       ; / Return 


DATA_05B375:                      .db $50,$00,$00,$7F,$58,$2C,$59,$2C
                                  .db $55,$2C,$56,$2C,$66,$EC,$65,$EC
                                  .db $57,$2C,$58,$2C,$59,$2C,$57,$2C
                                  .db $58,$2C,$59,$2C,$57,$2C,$58,$2C
                                  .db $59,$2C,$38,$2C,$39,$2C,$66,$EC
                                  .db $65,$EC,$57,$2C,$58,$2C,$59,$2C
                                  .db $57,$2C,$58,$2C,$59,$2C,$57,$2C
                                  .db $58,$2C,$59,$2C,$38,$2C,$39,$2C
                                  .db $56,$6C,$55,$2C,$68,$2C,$69,$2C
                                  .db $65,$2C,$66,$2C,$56,$EC,$55,$AC
                                  .db $67,$2C,$68,$2C,$69,$2C,$67,$2C
                                  .db $68,$2C,$69,$2C,$67,$2C,$68,$2C
                                  .db $69,$2C,$48,$2C,$49,$2C,$56,$EC
                                  .db $55,$AC,$67,$2C,$68,$2C,$69,$2C
                                  .db $67,$2C,$68,$2C,$69,$2C,$67,$2C
                                  .db $68,$2C,$69,$2C,$48,$2C,$49,$2C
                                  .db $66,$6C,$65,$6C,$50,$40,$80,$33
                                  .db $55,$2C,$65,$2C,$38,$2C,$48,$2C
                                  .db $55,$2C,$65,$2C,$38,$2C,$48,$2C
                                  .db $55,$2C,$65,$2C,$38,$2C,$48,$2C
                                  .db $55,$2C,$65,$2C,$38,$2C,$48,$2C
                                  .db $55,$2C,$65,$2C,$38,$2C,$48,$2C
                                  .db $55,$2C,$65,$2C,$38,$2C,$48,$2C
                                  .db $55,$2C,$65,$2C,$50,$41,$80,$33
                                  .db $56,$2C,$66,$2C,$39,$2C,$49,$2C
                                  .db $56,$2C,$66,$2C,$39,$2C,$49,$2C
                                  .db $56,$2C,$66,$2C,$39,$2C,$49,$2C
                                  .db $56,$2C,$66,$2C,$39,$2C,$49,$2C
                                  .db $56,$2C,$66,$2C,$39,$2C,$49,$2C
                                  .db $56,$2C,$66,$2C,$39,$2C,$49,$2C
                                  .db $56,$2C,$66,$2C,$50,$5E,$80,$33
                                  .db $66,$EC,$56,$EC,$39,$6C,$49,$6C
                                  .db $56,$6C,$66,$6C,$39,$6C,$49,$6C
                                  .db $56,$6C,$66,$6C,$39,$6C,$49,$6C
                                  .db $56,$6C,$66,$6C,$39,$6C,$49,$6C
                                  .db $56,$6C,$66,$6C,$39,$6C,$49,$6C
                                  .db $56,$6C,$66,$6C,$39,$6C,$49,$6C
                                  .db $56,$6C,$66,$6C,$50,$5F,$80,$33
                                  .db $65,$EC,$55,$EC,$38,$6C,$48,$6C
                                  .db $55,$6C,$65,$6C,$38,$6C,$48,$6C
                                  .db $55,$6C,$65,$6C,$38,$6C,$48,$6C
                                  .db $55,$6C,$65,$6C,$38,$6C,$48,$6C
                                  .db $55,$6C,$65,$6C,$38,$6C,$48,$6C
                                  .db $55,$6C,$65,$6C,$38,$6C,$48,$6C
                                  .db $55,$6C,$65,$6C,$53,$40,$00,$7F
                                  .db $69,$AC,$67,$AC,$68,$AC,$69,$AC
                                  .db $67,$AC,$68,$AC,$69,$AC,$48,$AC
                                  .db $49,$AC,$56,$6C,$55,$2C,$67,$AC
                                  .db $68,$AC,$69,$AC,$67,$AC,$68,$AC
                                  .db $69,$AC,$67,$AC,$68,$AC,$69,$AC
                                  .db $48,$AC,$49,$AC,$66,$EC,$65,$EC
                                  .db $57,$2C,$58,$2C,$59,$2C,$57,$2C
                                  .db $58,$2C,$57,$2C,$58,$2C,$59,$2C
                                  .db $59,$AC,$57,$AC,$58,$AC,$59,$AC
                                  .db $57,$AC,$58,$AC,$59,$AC,$38,$AC
                                  .db $39,$AC,$66,$6C,$65,$6C,$57,$AC
                                  .db $58,$AC,$59,$AC,$57,$AC,$58,$AC
                                  .db $59,$AC,$57,$AC,$58,$AC,$59,$AC
                                  .db $38,$AC,$39,$AC,$56,$EC,$55,$AC
                                  .db $67,$2C,$68,$2C,$69,$2C,$67,$2C
                                  .db $68,$2C,$67,$2C,$68,$2C,$69,$2C
                                  .db $50,$AA,$00,$13,$98,$3C,$A9,$3C
                                  .db $2F,$38,$AE,$28,$E0,$B8,$2C,$38
                                  .db $4B,$28,$F0,$28,$F1,$28,$98,$68
                                  .db $50,$CA,$00,$15,$4F,$3C,$8A,$3C
                                  .db $8B,$28,$8C,$28,$8D,$38,$35,$38
                                  .db $45,$28,$2A,$28,$2B,$28,$60,$28
                                  .db $A2,$28,$50,$EA,$00,$15,$99,$3C
                                  .db $9A,$3C,$9B,$28,$9C,$28,$9D,$38
                                  .db $9E,$38,$9F,$28,$5A,$28,$5B,$28
                                  .db $90,$28,$A0,$28,$51,$0A,$00,$13
                                  .db $5C,$28,$5C,$68,$71,$28,$71,$68
                                  .db $5C,$28,$72,$28,$73,$28,$71,$68
                                  .db $75,$28,$89,$28,$51,$3B,$00,$03
                                  .db $7B,$39,$7C,$39,$51,$23,$00,$2F
                                  .db $B0,$28,$B1,$28,$B2,$28,$B3,$28
                                  .db $B4,$28,$B5,$38,$F5,$38,$2C,$38
                                  .db $AC,$3C,$F2,$3C,$F3,$3C,$F4,$3C
                                  .db $E0,$B8,$3C,$38,$FB,$38,$74,$38
                                  .db $F3,$28,$F8,$28,$F5,$3C,$2C,$3C
                                  .db $AC,$3C,$B5,$3C,$F5,$3C,$98,$68
                                  .db $51,$43,$00,$31,$6A,$28,$6B,$28
                                  .db $6C,$28,$6D,$28,$6E,$28,$6F,$38
                                  .db $C6,$38,$C7,$38,$D8,$3C,$C9,$3C
                                  .db $CA,$3C,$CB,$3C,$D0,$B8,$CD,$38
                                  .db $CE,$38,$CF,$38,$CA,$28,$A1,$28
                                  .db $C6,$3C,$C7,$3C,$D8,$3C,$A5,$3C
                                  .db $A3,$3C,$B6,$3C,$C8,$28,$51,$63
                                  .db $00,$31,$D0,$3C,$D1,$28,$D2,$28
                                  .db $D3,$28,$61,$28,$62,$38,$63,$38
                                  .db $D7,$38,$D8,$3C,$D9,$3C,$DA,$3C
                                  .db $DB,$3C,$DC,$38,$DD,$38,$DE,$38
                                  .db $DF,$38,$DA,$28,$29,$28,$63,$3C
                                  .db $D7,$3C,$D8,$3C,$2D,$3C,$4C,$3C
                                  .db $4D,$3C,$CC,$28,$51,$83,$00,$31
                                  .db $E0,$3C,$E1,$28,$E2,$28,$E3,$28
                                  .db $E4,$28,$E5,$38,$E6,$38,$E7,$38
                                  .db $E8,$3C,$E9,$3C,$EA,$3C,$EB,$3C
                                  .db $EC,$38,$ED,$38,$EE,$38,$EF,$38
                                  .db $EA,$28,$F7,$28,$E6,$3C,$E7,$3C
                                  .db $E8,$3C,$5D,$3C,$5E,$3C,$5F,$3C
                                  .db $FA,$28,$51,$A3,$00,$2F,$5C,$28
                                  .db $A4,$28,$FC,$28,$FC,$28,$A6,$38
                                  .db $75,$28,$A7,$28,$A8,$38,$FC,$28
                                  .db $FC,$28,$FC,$28,$FC,$28,$AA,$38
                                  .db $5C,$68,$AB,$38,$71,$68,$FC,$28
                                  .db $FC,$28,$A7,$28,$A8,$38,$FC,$28
                                  .db $AD,$3C,$A7,$28,$AF,$3C,$53,$07
                                  .db $00,$25,$F6,$38,$FC,$28,$36,$38
                                  .db $37,$38,$37,$38,$54,$38,$20,$39
                                  .db $36,$38,$37,$38,$37,$38,$36,$38
                                  .db $FC,$28,$46,$38,$47,$38,$AE,$39
                                  .db $AF,$39,$C5

B5L3TMAP1:                        .db $39,$C6,$39,$BF,$39,$FF

DATA_05B6FE:                      .db $51,$E5,$40,$2E,$FC,$38,$52,$08
                                  .db $40,$1C,$FC,$38,$52,$25,$40,$2E
                                  .db $FC,$38,$52,$48,$40,$1C,$FC,$38
                                  .db $52,$65,$40,$2E,$FC,$38,$52,$A5
                                  .db $40,$1C,$FC,$38,$51,$ED,$00,$1F
                                  .db $76,$31,$71,$31,$74,$31,$82,$30
                                  .db $83,$30,$FC,$38,$71,$31,$FC,$38
                                  .db $24,$38,$24,$38,$24,$38,$73,$31
                                  .db $76,$31,$6F,$31,$2F,$31,$72,$31
                                  .db $52,$2D,$00,$1F,$76,$31,$71,$31
                                  .db $74,$31,$82,$30,$83,$30,$FC,$38
                                  .db $2C,$31,$FC,$38,$24,$38,$24,$38
                                  .db $24,$38,$73,$31,$76,$31,$6F,$31
                                  .db $2F,$31,$72,$31,$52,$6D,$00,$1F
                                  .db $76,$31,$71,$31,$74,$31,$82,$30
                                  .db $83,$30,$FC,$38,$2D,$31,$FC,$38
                                  .db $24,$38,$24,$38,$24,$38,$73,$31
                                  .db $76,$31,$6F,$31,$2F,$31,$72,$31
                                  .db $51,$E7,$00,$0B,$73,$31,$74,$31
                                  .db $71,$31,$31,$31,$73,$31,$FC,$38
                                  .db $52,$27,$00,$0B,$73,$31,$74,$31
                                  .db $71,$31,$31,$31,$73,$31,$FC,$38
                                  .db $52,$67,$00,$0B,$73,$31,$74,$31
                                  .db $71,$31,$31,$31,$73,$31,$FC,$38
                                  .db $52,$A7,$00,$05,$73,$31,$79,$30
                                  .db $7C,$30,$FF,$51,$E5,$40,$2E,$FC
                                  .db $38,$52,$08,$40,$1C,$FC,$38,$52
                                  .db $25,$40,$2E,$FC,$38,$52,$48,$40
                                  .db $1C,$FC,$38,$52,$65,$40,$2E,$FC
                                  .db $38,$52,$A5,$40,$1C,$FC,$38,$51
                                  .db $EA,$00,$1F,$76,$31,$71,$31,$74
                                  .db $31,$82,$30,$83,$30,$FC,$38,$71
                                  .db $31,$FC,$38,$24,$38,$24,$38,$24
                                  .db $38,$73,$31,$76,$31,$6F,$31,$2F
                                  .db $31,$72,$31,$52,$2A,$00,$1F,$76
                                  .db $31,$71,$31,$74,$31,$82,$30,$83
                                  .db $30,$FC,$38,$2C,$31,$FC,$38,$24
                                  .db $38,$24,$38,$24,$38,$73,$31,$76
                                  .db $31,$6F,$31,$2F,$31,$72,$31,$52
                                  .db $6A,$00,$1F,$76,$31,$71,$31,$74
                                  .db $31,$82,$30,$83,$30,$FC,$38,$2D
                                  .db $31,$FC,$38,$24,$38,$24,$38,$24
                                  .db $38,$73,$31,$76,$31,$6F,$31,$2F
                                  .db $31,$72,$31,$52,$AA,$00,$13,$73
                                  .db $31,$74,$31,$71,$31,$31,$31,$73
                                  .db $31,$FC,$38,$7C,$30,$71,$31,$2F
                                  .db $31,$71,$31,$FF

DATA_05B872:                      .db $51,$E5,$40,$2F,$FC,$38,$52,$25
                                  .db $40,$2F,$FC,$38,$52,$65,$40,$2F
                                  .db $FC,$38,$52,$A5,$40,$1C,$FC,$38
                                  .db $52,$0A,$00,$19,$6D,$31,$FC,$38
                                  .db $6F,$31,$70,$31,$71,$31,$72,$31
                                  .db $73,$31,$74,$31,$FC,$38,$75,$31
                                  .db $71,$31,$76,$31,$73,$31,$52,$4A
                                  .db $00,$19,$6E,$31,$FC,$38,$6F,$31
                                  .db $70,$31,$71,$31,$72,$31,$73,$31
                                  .db $74,$31,$FC,$38,$75,$31,$71,$31
                                  .db $76,$31,$73,$31,$FF

DATA_05B8C7:                      .db $51,$C6,$00,$21,$2D,$39,$7A,$38
                                  .db $79,$38,$2F,$39,$82,$38,$79,$38
                                  .db $7B,$38,$73,$39,$FC,$38,$71,$39
                                  .db $79,$38,$7C,$38,$FC,$38,$31,$39
                                  .db $71,$39,$80,$38,$73,$39,$52,$06
                                  .db $00,$29,$2D,$39,$7A,$38,$79,$38
                                  .db $2F,$39,$82,$38,$79,$38,$7B,$38
                                  .db $73,$39,$FC,$38,$81,$38,$82,$38
                                  .db $2F,$39,$84,$38,$7A,$38,$7B,$38
                                  .db $2F,$39,$FC,$38,$31,$39,$71,$39
                                  .db $80,$38,$73,$39,$FF

DATA_05B91C:                      .db $51,$CD,$00,$0F,$2D,$39,$7A,$38
                                  .db $79,$38,$2F,$39,$82,$38,$79,$38
                                  .db $7B,$38,$73,$39,$52,$0D,$00,$05
                                  .db $73,$39,$79,$38,$7C,$38,$FF

DATA_05B93B:                      .db $00,$06

DATA_05B93D:                      .db $40,$06

DATA_05B93F:                      .db $80,$06,$40,$07,$A0,$0E,$00,$08
                                  .db $00,$05,$40,$05,$80,$05,$C0,$05
                                  .db $80,$07,$C0,$07,$A0,$0D,$C0,$06
                                  .db $00,$07,$C0,$04,$40,$04,$80,$04
                                  .db $00,$04,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00

DATA_05B96B:                      .db $00,$00,$00,$00,$00,$00,$01,$01
                                  .db $01,$01,$01,$01,$01,$01,$02,$02
                                  .db $02,$02

DATA_05B97D:                      .db $02,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$01,$00,$02,$02,$00

DATA_05B98B:                      .db $00,$05,$0A,$0F,$14,$14,$19,$14
                                  .db $0A,$14,$00,$05,$00,$14

AnimatedTileData:                 .db $00,$95,$00,$97,$00,$99,$00,$9B
                                  .db $80,$95,$80,$97,$80,$99,$80,$9B
                                  .db $00,$96,$00,$96,$00,$96,$00,$96
                                  .db $80,$9D,$80,$9F,$80,$A1,$80,$A3
                                  .db $00,$96,$00,$98,$00,$9A,$00,$9C
                                  .db $80,$6D,$80,$6F,$00,$7C,$80,$7C
                                  .db $20,$AC,$20,$AC,$20,$AC,$20,$AC
                                  .db $20,$AC,$20,$AC,$20,$AC,$20,$AC
                                  .db $80,$93,$80,$93,$80,$93,$80,$93
                                  .db $00,$A4,$80,$A4,$00,$A4,$80,$A4
                                  .db $20,$AC,$20,$AC,$20,$AC,$20,$AC
                                  .db $00,$AC,$00,$AC,$00,$AC,$00,$AC
                                  .db $00,$91,$00,$91,$00,$91,$00,$91
                                  .db $80,$96,$80,$98,$80,$9A,$80,$9C
                                  .db $00,$9D,$00,$9F,$00,$A1,$00,$A3
                                  .db $80,$8E,$80,$90,$80,$92,$80,$94
                                  .db $00,$95,$00,$95,$00,$95,$00,$95
                                  .db $00,$95,$00,$95,$00,$95,$00,$95
                                  .db $00,$95,$00,$95,$00,$95,$00,$95
                                  .db $00,$9D,$00,$9F,$00,$A1,$00,$A3
DATA_05BA39:                      .db $80,$8E,$80,$90,$80,$92,$80,$94
                                  .db $00,$7D,$00,$7F,$00,$81,$00,$83
                                  .db $00,$83,$00,$81,$00,$7F,$00,$7D
                                  .db $00,$9E,$00,$A0,$00,$A2,$00,$A0
                                  .db $00,$9D,$00,$9F,$00,$A1,$00,$A3
                                  .db $00,$A5,$00,$A7,$00,$A9,$00,$AB
                                  .db $80,$A5,$80,$A7,$80,$A9,$80,$AB
                                  .db $80,$AB,$80,$A9,$80,$A7,$80,$A5
                                  .db $00,$95,$00,$95,$00,$95,$00,$95
                                  .db $80,$9E,$80,$A0,$80,$A2,$80,$A0
                                  .db $80,$7D,$80,$7F,$80,$81,$80,$83
                                  .db $00,$7E,$00,$80,$00,$82,$00,$84
                                  .db $80,$7E,$80,$80,$80,$82,$80,$84
                                  .db $80,$83,$80,$81,$80,$7F,$80,$7D
                                  .db $00,$95,$00,$95,$00,$95,$00,$95
                                  .db $80,$A6,$80,$A8,$80,$AA,$80,$A8
                                  .db $00,$8E,$00,$90,$00,$92,$00,$94
                                  .db $00,$95,$00,$95,$00,$95,$00,$95
                                  .db $00,$95,$00,$95,$00,$95,$00,$95
                                  .db $80,$9E,$80,$A0,$80,$A2,$80,$A0
                                  .db $00,$A6,$00,$A8,$00,$AA,$00,$A8
                                  .db $00,$95,$00,$95,$00,$95,$00,$95
                                  .db $00,$95,$00,$95,$00,$95,$00,$95
                                  .db $00,$95,$00,$95,$00,$95,$00,$95
                                  .db $80,$91,$80,$91,$80,$91,$80,$91
                                  .db $80,$96,$80,$98,$80,$9A,$80,$9C
                                  .db $80,$96,$80,$98,$80,$9A,$80,$9C
                                  .db $80,$96,$80,$98,$80,$9A,$80,$9C
                                  .db $00,$95,$00,$97,$00,$99,$00,$9B
                                  .db $80,$AC,$80,$AC,$80,$AC,$80,$AC
                                  .db $00,$93,$00,$93,$00,$93,$00,$93
                                  .db $80,$93,$80,$93,$80,$93,$80,$93

CODE_05BB39:        8B            PHB                       
CODE_05BB3A:        4B            PHK                       
CODE_05BB3B:        AB            PLB                       
CODE_05BB3C:        A5 14         LDA RAM_FrameCounterB     
CODE_05BB3E:        29 07         AND.B #$07                
CODE_05BB40:        85 00         STA $00                   
CODE_05BB42:        0A            ASL                       
CODE_05BB43:        65 00         ADC $00                   
CODE_05BB45:        A8            TAY                       
CODE_05BB46:        0A            ASL                       
CODE_05BB47:        AA            TAX                       
CODE_05BB48:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05BB4A:        A5 14         LDA RAM_FrameCounterB     
CODE_05BB4C:        29 18 00      AND.W #$0018              
CODE_05BB4F:        4A            LSR                       
CODE_05BB50:        4A            LSR                       
CODE_05BB51:        85 00         STA $00                   
CODE_05BB53:        BD 3B B9      LDA.W DATA_05B93B,X       
CODE_05BB56:        8D 80 0D      STA.W $0D80               
CODE_05BB59:        BD 3D B9      LDA.W DATA_05B93D,X       
CODE_05BB5C:        8D 7E 0D      STA.W $0D7E               
CODE_05BB5F:        BD 3F B9      LDA.W DATA_05B93F,X       
CODE_05BB62:        8D 7C 0D      STA.W $0D7C               
CODE_05BB65:        A2 04         LDX.B #$04                
CODE_05BB67:        5A            PHY                       
CODE_05BB68:        DA            PHX                       
CODE_05BB69:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05BB6B:        98            TYA                       
CODE_05BB6C:        BE 6B B9      LDX.W DATA_05B96B,Y       
CODE_05BB6F:        F0 17         BEQ CODE_05BB88           
CODE_05BB71:        CA            DEX                       
CODE_05BB72:        D0 0D         BNE CODE_05BB81           
CODE_05BB74:        BE 7D B9      LDX.W DATA_05B97D,Y       
CODE_05BB77:        BC AD 14      LDY.W RAM_BluePowTimer,X  
CODE_05BB7A:        F0 0C         BEQ CODE_05BB88           
CODE_05BB7C:        18            CLC                       
CODE_05BB7D:        69 26         ADC.B #$26                
CODE_05BB7F:        80 07         BRA CODE_05BB88           

CODE_05BB81:        AC 31 19      LDY.W $1931               
CODE_05BB84:        18            CLC                       
CODE_05BB85:        79 8B B9      ADC.W DATA_05B98B,Y       
CODE_05BB88:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_05BB8A:        29 FF 00      AND.W #$00FF              
CODE_05BB8D:        0A            ASL                       
CODE_05BB8E:        0A            ASL                       
CODE_05BB8F:        0A            ASL                       
CODE_05BB90:        05 00         ORA $00                   
CODE_05BB92:        A8            TAY                       
CODE_05BB93:        B9 99 B9      LDA.W AnimatedTileData,Y  
CODE_05BB96:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_05BB98:        FA            PLX                       
CODE_05BB99:        9D 76 0D      STA.W $0D76,X             
CODE_05BB9C:        7A            PLY                       
CODE_05BB9D:        C8            INY                       
CODE_05BB9E:        CA            DEX                       
CODE_05BB9F:        CA            DEX                       
CODE_05BBA0:        10 C5         BPL CODE_05BB67           
CODE_05BBA2:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05BBA4:        AB            PLB                       
Return05BBA5:       6B            RTL                       ; Return 


DATA_05BBA6:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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

CODE_05BC00:        8B            PHB                       
CODE_05BC01:        4B            PHK                       
CODE_05BC02:        AB            PLB                       
CODE_05BC03:        20 76 BC      JSR.W CODE_05BC76         
CODE_05BC06:        20 A5 BC      JSR.W CODE_05BCA5         
CODE_05BC09:        20 4A BC      JSR.W CODE_05BC4A         
CODE_05BC0C:        AD 62 14      LDA.W $1462               
CODE_05BC0F:        38            SEC                       
CODE_05BC10:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_05BC12:        18            CLC                       
CODE_05BC13:        6D BD 17      ADC.W $17BD               
CODE_05BC16:        8D BD 17      STA.W $17BD               
CODE_05BC19:        AD 64 14      LDA.W $1464               
CODE_05BC1C:        38            SEC                       
CODE_05BC1D:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_05BC1F:        18            CLC                       
CODE_05BC20:        6D BC 17      ADC.W $17BC               
CODE_05BC23:        8D BC 17      STA.W $17BC               
CODE_05BC26:        AD 66 14      LDA.W $1466               
CODE_05BC29:        38            SEC                       
CODE_05BC2A:        E5 1E         SBC $1E                   
CODE_05BC2C:        AC 3F 14      LDY.W $143F               
CODE_05BC2F:        88            DEY                       
CODE_05BC30:        D0 01         BNE CODE_05BC33           
CODE_05BC32:        98            TYA                       
CODE_05BC33:        8D BF 17      STA.W $17BF               
CODE_05BC36:        AD 68 14      LDA.W $1468               
CODE_05BC39:        38            SEC                       
CODE_05BC3A:        E5 20         SBC $20                   
CODE_05BC3C:        8D BE 17      STA.W $17BE               
CODE_05BC3F:        AD D5 13      LDA.W $13D5               
CODE_05BC42:        D0 03         BNE CODE_05BC47           
CODE_05BC44:        20 0C C4      JSR.W CODE_05C40C         
CODE_05BC47:        AB            PLB                       
Return05BC48:       6B            RTL                       ; Return 

Return05BC49:       60            RTS                       ; Return 

CODE_05BC4A:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05BC4C:        AC 03 14      LDY.W $1403               
CODE_05BC4F:        D0 0E         BNE CODE_05BC5F           
CODE_05BC51:        AD 66 14      LDA.W $1466               
CODE_05BC54:        38            SEC                       
CODE_05BC55:        ED 62 14      SBC.W $1462               
CODE_05BC58:        85 26         STA $26                   
CODE_05BC5A:        AD 68 14      LDA.W $1468               
CODE_05BC5D:        80 0A         BRA CODE_05BC69           

CODE_05BC5F:        A5 22         LDA $22                   
CODE_05BC61:        38            SEC                       
CODE_05BC62:        ED 62 14      SBC.W $1462               
CODE_05BC65:        85 26         STA $26                   
CODE_05BC67:        A5 24         LDA $24                   
CODE_05BC69:        38            SEC                       
CODE_05BC6A:        ED 64 14      SBC.W $1464               
CODE_05BC6D:        85 28         STA $28                   
CODE_05BC6F:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return05BC71:       60            RTS                       ; Return 

CODE_05BC72:        20 4A BC      JSR.W CODE_05BC4A         
Return05BC75:       6B            RTL                       ; Return 

CODE_05BC76:        9C 56 14      STZ.W $1456               
CODE_05BC79:        AD 9D 00      LDA.W RAM_SpritesLocked   
CODE_05BC7C:        D0 CB         BNE Return05BC49          
CODE_05BC7E:        AD 3E 14      LDA.W RAM_ScrollSprNum    
CODE_05BC81:        F0 C6         BEQ Return05BC49          
CODE_05BC83:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs05BC87:            4D C0      .dw CODE_05C04D           ; 00 - Auto-Scroll, Unused?             
                       4D C0      .dw CODE_05C04D           ; 01 - Auto-Scroll                      
                       49 BC      .dw Return05BC49          ; 02 - Layer 2 Smash                    
                       49 BC      .dw Return05BC49          ; 03 - Layer 2 Scroll                   
                       83 C2      .dw ADDR_05C283           ; 04 - Unused                           
                       9E C6      .dw ADDR_05C69E           ; 05 - Unused                           
                       49 BC      .dw Return05BC49          ; 06 - Layer 2 Falls                    
                       F5 BF      .dw Return05BFF5          ; 07 - Unused                           
                       1F C5      .dw CODE_05C51F           ; 08 - Layer 2 Scroll                   
                       49 BC      .dw Return05BC49          ; 09 - Unused                           
                       2E C3      .dw ADDR_05C32E           ; 0A - Unused                           
                       27 C7      .dw CODE_05C727           ; 0B - Layer 2 On/Off Switch controlled 
                       87 C7      .dw CODE_05C787           ; 0C - Auto-Scroll level                
                       49 BC      .dw Return05BC49          ; 0D - Fast BG scroll                   
                       49 BC      .dw Return05BC49          ; 0E - Layer 2 sink/rise                

CODE_05BCA5:        A9 04         LDA.B #$04                
CODE_05BCA7:        8D 56 14      STA.W $1456               
CODE_05BCAA:        AD 3F 14      LDA.W $143F               
CODE_05BCAD:        F0 9A         BEQ Return05BC49          
CODE_05BCAF:        AC 9D 00      LDY.W RAM_SpritesLocked   
CODE_05BCB2:        D0 95         BNE Return05BC49          
CODE_05BCB4:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs05BCB8:            4D C0      .dw CODE_05C04D           
                       98 C1      .dw CODE_05C198           
                       55 C9      .dw CODE_05C955           
                       BB C5      .dw CODE_05C5BB           
                       83 C2      .dw ADDR_05C283           
                       49 BC      .dw Return05BC49          
                       59 C6      .dw ADDR_05C659           
                       F5 BF      .dw Return05BFF5          
                       1F C5      .dw CODE_05C51F           
                       C1 C7      .dw CODE_05C7C1           
                       2E C3      .dw ADDR_05C32E           
                       27 C7      .dw CODE_05C727           
                       87 C7      .dw CODE_05C787           
                       BC C7      .dw CODE_05C7BC           
                       1C C8      .dw CODE_05C81C           

CODE_05BCD6:        8B            PHB                       
CODE_05BCD7:        4B            PHK                       
CODE_05BCD8:        AB            PLB                       
CODE_05BCD9:        9C 56 14      STZ.W $1456               
CODE_05BCDC:        20 E9 BC      JSR.W CODE_05BCE9         
CODE_05BCDF:        A9 04         LDA.B #$04                
CODE_05BCE1:        8D 56 14      STA.W $1456               
CODE_05BCE4:        20 0E BD      JSR.W CODE_05BD0E         
CODE_05BCE7:        AB            PLB                       
Return05BCE8:       6B            RTL                       ; Return 

CODE_05BCE9:        AD 3E 14      LDA.W RAM_ScrollSprNum    
CODE_05BCEC:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs05BCF0:            36 BD      .dw CODE_05BD36           ; 00 - Auto-Scroll, Unused?             
                       36 BD      .dw CODE_05BD36           ; 01 - Auto-Scroll                      
                       6A BF      .dw CODE_05BF6A           ; 02 - Layer 2 Smash                    
                       0A BF      .dw CODE_05BF0A           ; 03 - Layer 2 Scroll                   
                       DD BD      .dw ADDR_05BDDD           ; 04 - Unused                           
                       BA BF      .dw ADDR_05BFBA           ; 05 - Unused                           
                       97 BF      .dw ADDR_05BF97           ; 06 - Layer 2 Falls                    
                       35 BD      .dw Return05BD35          ; 07 - Unused                           
                       A6 BE      .dw CODE_05BEA6           ; 08 - Layer 2 Scroll                   
                       49 BC      .dw Return05BC49          ; 09 - Unused                           
                       3A BE      .dw ADDR_05BE3A           ; 0A - Unused                           
                       F6 BF      .dw CODE_05BFF6           ; 0B - Layer 2 On/Off Switch controlled 
                       05 C0      .dw CODE_05C005           ; 0C - Auto-Scroll level                
                       1A C0      .dw CODE_05C01A           ; 0D - Fast BG scroll                   
                       36 C0      .dw CODE_05C036           ; 0E - Layer 2 sink/rise                              

CODE_05BD0E:        AD 3F 14      LDA.W $143F               
CODE_05BD11:        F0 22         BEQ Return05BD35          
CODE_05BD13:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs05BD17:            4C BD      .dw CODE_05BD4C           
                       4C BD      .dw CODE_05BD4C           
                       49 BC      .dw Return05BC49          
                       20 BF      .dw CODE_05BF20           
                       F0 BD      .dw ADDR_05BDF0           
                       49 BC      .dw Return05BC49          
                       49 BC      .dw Return05BC49          
                       35 BD      .dw Return05BD35          
                       C6 BE      .dw CODE_05BEC6           
                       22 C0      .dw CODE_05C022           
                       4D BE      .dw ADDR_05BE4D           
                       49 BC      .dw Return05BC49          
                       49 BC      .dw Return05BC49          
                       49 BC      .dw Return05BC49          
                       49 BC      .dw Return05BC49          

Return05BD35:       60            RTS                       ; Return 

CODE_05BD36:        9C 11 14      STZ.W $1411               
CODE_05BD39:        AD 40 14      LDA.W $1440               
CODE_05BD3C:        0A            ASL                       
CODE_05BD3D:        A8            TAY                       
CODE_05BD3E:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05BD40:        B9 D1 C9      LDA.W DATA_05C9D1,Y       
CODE_05BD43:        8D 3E 14      STA.W RAM_ScrollSprNum    
CODE_05BD46:        B9 DB C9      LDA.W DATA_05C9DB,Y       
CODE_05BD49:        8D 40 14      STA.W $1440               
CODE_05BD4C:        AE 56 14      LDX.W $1456               
CODE_05BD4F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05BD51:        9E 46 14      STZ.W $1446,X             
CODE_05BD54:        9E 48 14      STZ.W $1448,X             
CODE_05BD57:        9E 4E 14      STZ.W $144E,X             
CODE_05BD5A:        9E 50 14      STZ.W $1450,X             
CODE_05BD5D:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05BD5F:        8A            TXA                       
CODE_05BD60:        4A            LSR                       
CODE_05BD61:        4A            LSR                       
CODE_05BD62:        AA            TAX                       
CODE_05BD63:        AC 40 14      LDY.W $1440               
CODE_05BD66:        AD 56 14      LDA.W $1456               
CODE_05BD69:        F0 03         BEQ CODE_05BD6E           
CODE_05BD6B:        AC 41 14      LDY.W $1441               
CODE_05BD6E:        B9 61 CA      LDA.W DATA_05CA61,Y       
CODE_05BD71:        9D 42 14      STA.W $1442,X             
CODE_05BD74:        B9 68 CA      LDA.W DATA_05CA68,Y       
CODE_05BD77:        9D 44 14      STA.W $1444,X             
Return05BD7A:       60            RTS                       ; Return 

ADDR_05BD7B:        AD 40 14      LDA.W $1440               ; \ Unreachable 
ADDR_05BD7E:        0A            ASL                       
ADDR_05BD7F:        A8            TAY                       
ADDR_05BD80:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05BD82:        B9 E5 C9      LDA.W DATA_05C9E5,Y       
ADDR_05BD85:        8D 3E 14      STA.W RAM_ScrollSprNum    
ADDR_05BD88:        B9 E7 C9      LDA.W DATA_05C9E7,Y       
ADDR_05BD8B:        8D 40 14      STA.W $1440               
ADDR_05BD8E:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05BD90:        AC 40 14      LDY.W $1440               
ADDR_05BD93:        AD 56 14      LDA.W $1456               
ADDR_05BD96:        29 FF 00      AND.W #$00FF              
ADDR_05BD99:        F0 03         BEQ ADDR_05BD9E           
ADDR_05BD9B:        AC 41 14      LDY.W $1441               
ADDR_05BD9E:        AD 56 14      LDA.W $1456               
ADDR_05BDA1:        29 FF 00      AND.W #$00FF              
ADDR_05BDA4:        4A            LSR                       
ADDR_05BDA5:        4A            LSR                       
ADDR_05BDA6:        AA            TAX                       
ADDR_05BDA7:        B9 E9 C9      LDA.W DATA_05C9E9,Y       
ADDR_05BDAA:        9D 42 14      STA.W $1442,X             
ADDR_05BDAD:        B9 C7 CB      LDA.W DATA_05CBC7,Y       
ADDR_05BDB0:        29 FF 00      AND.W #$00FF              
ADDR_05BDB3:        F0 04         BEQ ADDR_05BDB9           
ADDR_05BDB5:        49 FF FF      EOR.W #$FFFF              
ADDR_05BDB8:        1A            INC A                     
ADDR_05BDB9:        AE 56 14      LDX.W $1456               
ADDR_05BDBC:        18            CLC                       
ADDR_05BDBD:        7D 64 14      ADC.W $1464,X             
ADDR_05BDC0:        29 FF 00      AND.W #$00FF              
ADDR_05BDC3:        9D 4E 14      STA.W $144E,X             
ADDR_05BDC6:        9E 50 14      STZ.W $1450,X             
CODE_05BDC9:        9E 46 14      STZ.W $1446,X             
CODE_05BDCC:        9E 48 14      STZ.W $1448,X             
CODE_05BDCF:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05BDD1:        8A            TXA                       
CODE_05BDD2:        4A            LSR                       
CODE_05BDD3:        4A            LSR                       
CODE_05BDD4:        29 FF         AND.B #$FF                
CODE_05BDD6:        AA            TAX                       
CODE_05BDD7:        A9 FF         LDA.B #$FF                
CODE_05BDD9:        9D 44 14      STA.W $1444,X             
Return05BDDC:       60            RTS                       ; Return 

ADDR_05BDDD:        AD 40 14      LDA.W $1440               
ADDR_05BDE0:        0A            ASL                       
ADDR_05BDE1:        A8            TAY                       
ADDR_05BDE2:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05BDE4:        B9 08 CA      LDA.W DATA_05CA08,Y       
ADDR_05BDE7:        8D 3E 14      STA.W RAM_ScrollSprNum    
ADDR_05BDEA:        B9 0C CA      LDA.W DATA_05CA0C,Y       
ADDR_05BDED:        8D 40 14      STA.W $1440               
ADDR_05BDF0:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05BDF2:        AC 40 14      LDY.W $1440               
ADDR_05BDF5:        AD 56 14      LDA.W $1456               
ADDR_05BDF8:        29 FF 00      AND.W #$00FF              
ADDR_05BDFB:        F0 03         BEQ ADDR_05BE00           
ADDR_05BDFD:        AC 41 14      LDY.W $1441               
ADDR_05BE00:        AD 56 14      LDA.W $1456               
ADDR_05BE03:        29 FF 00      AND.W #$00FF              
ADDR_05BE06:        4A            LSR                       
ADDR_05BE07:        4A            LSR                       
ADDR_05BE08:        AA            TAX                       
ADDR_05BE09:        B9 10 CA      LDA.W DATA_05CA10,Y       
ADDR_05BE0C:        9D 42 14      STA.W $1442,X             
ADDR_05BE0F:        48            PHA                       
ADDR_05BE10:        98            TYA                       
ADDR_05BE11:        0A            ASL                       
ADDR_05BE12:        A8            TAY                       
ADDR_05BE13:        B9 12 CA      LDA.W DATA_05CA12,Y       
ADDR_05BE16:        85 00         STA $00                   
ADDR_05BE18:        68            PLA                       
ADDR_05BE19:        A8            TAY                       
ADDR_05BE1A:        AE 56 14      LDX.W $1456               
ADDR_05BE1D:        A5 00         LDA $00                   
ADDR_05BE1F:        C0 01         CPY.B #$01                
ADDR_05BE21:        F0 04         BEQ ADDR_05BE27           
ADDR_05BE23:        49 FF FF      EOR.W #$FFFF              
ADDR_05BE26:        1A            INC A                     
ADDR_05BE27:        18            CLC                       
ADDR_05BE28:        7D 64 14      ADC.W $1464,X             
ADDR_05BE2B:        9D 4E 14      STA.W $144E,X             
ADDR_05BE2E:        9E 46 14      STZ.W $1446,X             
ADDR_05BE31:        9E 48 14      STZ.W $1448,X             
ADDR_05BE34:        9E 50 14      STZ.W $1450,X             
ADDR_05BE37:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return05BE39:       60            RTS                       ; Return 

ADDR_05BE3A:        AD 40 14      LDA.W $1440               
ADDR_05BE3D:        0A            ASL                       
ADDR_05BE3E:        A8            TAY                       
ADDR_05BE3F:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05BE41:        B9 16 CA      LDA.W DATA_05CA16,Y       
ADDR_05BE44:        8D 3E 14      STA.W RAM_ScrollSprNum    
ADDR_05BE47:        B9 1E CA      LDA.W DATA_05CA1E,Y       
ADDR_05BE4A:        8D 40 14      STA.W $1440               
ADDR_05BE4D:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05BE4F:        AC 40 14      LDY.W $1440               
ADDR_05BE52:        AD 56 14      LDA.W $1456               
ADDR_05BE55:        29 FF 00      AND.W #$00FF              
ADDR_05BE58:        F0 03         BEQ ADDR_05BE5D           
ADDR_05BE5A:        AC 41 14      LDY.W $1441               
ADDR_05BE5D:        AD 56 14      LDA.W $1456               
ADDR_05BE60:        29 FF 00      AND.W #$00FF              
ADDR_05BE63:        4A            LSR                       
ADDR_05BE64:        4A            LSR                       
ADDR_05BE65:        AA            TAX                       
ADDR_05BE66:        B9 26 CA      LDA.W DATA_05CA26,Y       
ADDR_05BE69:        9D 42 14      STA.W $1442,X             
ADDR_05BE6C:        A8            TAY                       
ADDR_05BE6D:        AE 56 14      LDX.W $1456               
ADDR_05BE70:        A9 17 0F      LDA.W #$0F17              
ADDR_05BE73:        C0 01         CPY.B #$01                
ADDR_05BE75:        F0 04         BEQ ADDR_05BE7B           
ADDR_05BE77:        49 FF FF      EOR.W #$FFFF              
ADDR_05BE7A:        1A            INC A                     
ADDR_05BE7B:        9D 50 14      STA.W $1450,X             
ADDR_05BE7E:        9E 46 14      STZ.W $1446,X             
ADDR_05BE81:        9E 48 14      STZ.W $1448,X             
ADDR_05BE84:        9E 4E 14      STZ.W $144E,X             
ADDR_05BE87:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return05BE89:       60            RTS                       ; Return 

CODE_05BE8A:        8B            PHB                       
CODE_05BE8B:        4B            PHK                       
CODE_05BE8C:        AB            PLB                       
CODE_05BE8D:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05BE8F:        AD 26 CA      LDA.W DATA_05CA26         
CODE_05BE92:        8D 60 14      STA.W $1460               
CODE_05BE95:        9C 58 14      STZ.W $1458               
CODE_05BE98:        9C 5A 14      STZ.W $145A               
CODE_05BE9B:        9C 5C 14      STZ.W $145C               
CODE_05BE9E:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_05BEA0:        85 24         STA $24                   
CODE_05BEA2:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05BEA4:        AB            PLB                       
Return05BEA5:       6B            RTL                       ; Return 

CODE_05BEA6:        9C 11 14      STZ.W $1411               
CODE_05BEA9:        AD 40 14      LDA.W $1440               
CODE_05BEAC:        0A            ASL                       
CODE_05BEAD:        A8            TAY                       
CODE_05BEAE:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05BEB0:        B9 3E CA      LDA.W DATA_05CA3E,Y       
CODE_05BEB3:        8D 3E 14      STA.W RAM_ScrollSprNum    
CODE_05BEB6:        B9 42 CA      LDA.W DATA_05CA42,Y       
CODE_05BEB9:        8D 40 14      STA.W $1440               
CODE_05BEBC:        64 1A         STZ RAM_ScreenBndryXLo    
CODE_05BEBE:        9C 62 14      STZ.W $1462               
CODE_05BEC1:        64 1E         STZ $1E                   
CODE_05BEC3:        9C 66 14      STZ.W $1466               
CODE_05BEC6:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05BEC8:        AC 40 14      LDY.W $1440               
CODE_05BECB:        AD 56 14      LDA.W $1456               
CODE_05BECE:        29 FF 00      AND.W #$00FF              
CODE_05BED1:        F0 03         BEQ CODE_05BED6           
CODE_05BED3:        AC 41 14      LDY.W $1441               
CODE_05BED6:        AD 56 14      LDA.W $1456               
CODE_05BED9:        29 FF 00      AND.W #$00FF              
CODE_05BEDC:        4A            LSR                       
CODE_05BEDD:        4A            LSR                       
CODE_05BEDE:        AA            TAX                       
CODE_05BEDF:        B9 46 CA      LDA.W DATA_05CA46,Y       
CODE_05BEE2:        9D 42 14      STA.W $1442,X             
CODE_05BEE5:        AA            TAX                       
CODE_05BEE6:        98            TYA                       
CODE_05BEE7:        0A            ASL                       
CODE_05BEE8:        A8            TAY                       
CODE_05BEE9:        B9 ED CB      LDA.W DATA_05CBED,Y       
CODE_05BEEC:        29 FF 00      AND.W #$00FF              
CODE_05BEEF:        E0 01         CPX.B #$01                
CODE_05BEF1:        F0 04         BEQ CODE_05BEF7           
ADDR_05BEF3:        49 FF FF      EOR.W #$FFFF              
ADDR_05BEF6:        1A            INC A                     
CODE_05BEF7:        AE 56 14      LDX.W $1456               
CODE_05BEFA:        18            CLC                       
CODE_05BEFB:        7D 62 14      ADC.W $1462,X             
CODE_05BEFE:        29 FF 00      AND.W #$00FF              
CODE_05BF01:        9D 50 14      STA.W $1450,X             
CODE_05BF04:        9E 4E 14      STZ.W $144E,X             
CODE_05BF07:        4C C9 BD      JMP.W CODE_05BDC9         

CODE_05BF0A:        9C 14 14      STZ.W $1414               
CODE_05BF0D:        AD 40 14      LDA.W $1440               
CODE_05BF10:        0A            ASL                       
CODE_05BF11:        A8            TAY                       
CODE_05BF12:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05BF14:        B9 48 CA      LDA.W DATA_05CA48,Y       
CODE_05BF17:        8D 3E 14      STA.W RAM_ScrollSprNum    
CODE_05BF1A:        B9 52 CA      LDA.W DATA_05CA52,Y       
CODE_05BF1D:        8D 40 14      STA.W $1440               
CODE_05BF20:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05BF22:        AC 40 14      LDY.W $1440               
CODE_05BF25:        AD 56 14      LDA.W $1456               
CODE_05BF28:        29 FF 00      AND.W #$00FF              
CODE_05BF2B:        F0 03         BEQ CODE_05BF30           
CODE_05BF2D:        AC 41 14      LDY.W $1441               
CODE_05BF30:        AD 56 14      LDA.W $1456               
CODE_05BF33:        29 FF 00      AND.W #$00FF              
CODE_05BF36:        4A            LSR                       
CODE_05BF37:        4A            LSR                       
CODE_05BF38:        AA            TAX                       
CODE_05BF39:        B9 5C CA      LDA.W DATA_05CA5C,Y       
CODE_05BF3C:        9D 42 14      STA.W $1442,X             
CODE_05BF3F:        AA            TAX                       
CODE_05BF40:        98            TYA                       
CODE_05BF41:        0A            ASL                       
CODE_05BF42:        A8            TAY                       
CODE_05BF43:        B9 F5 CB      LDA.W DATA_05CBF5,Y       
CODE_05BF46:        29 FF 00      AND.W #$00FF              
CODE_05BF49:        E0 01         CPX.B #$01                
CODE_05BF4B:        F0 04         BEQ CODE_05BF51           
CODE_05BF4D:        49 FF FF      EOR.W #$FFFF              
CODE_05BF50:        1A            INC A                     
CODE_05BF51:        AE 56 14      LDX.W $1456               
CODE_05BF54:        18            CLC                       
CODE_05BF55:        7D 64 14      ADC.W $1464,X             
CODE_05BF58:        29 FF 00      AND.W #$00FF              
CODE_05BF5B:        9D 4E 14      STA.W $144E,X             
CODE_05BF5E:        9E 50 14      STZ.W $1450,X             
CODE_05BF61:        9E 48 14      STZ.W $1448,X             
CODE_05BF64:        9E 48 14      STZ.W $1448,X             
CODE_05BF67:        4C CF BD      JMP.W CODE_05BDCF         

CODE_05BF6A:        AC 40 14      LDY.W $1440               ; Accum (8 bit) 
CODE_05BF6D:        B9 4F C9      LDA.W DATA_05C94F,Y       
CODE_05BF70:        8D 40 14      STA.W $1440               
CODE_05BF73:        B9 52 C9      LDA.W DATA_05C952,Y       
CODE_05BF76:        8D 41 14      STA.W $1441               
CODE_05BF79:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05BF7B:        A9 00 02      LDA.W #$0200              
CODE_05BF7E:        20 D2 BF      JSR.W CODE_05BFD2         
CODE_05BF81:        AD 40 14      LDA.W $1440               ; Accum (8 bit) 
CODE_05BF84:        18            CLC                       
CODE_05BF85:        69 0A         ADC.B #$0A                
CODE_05BF87:        AA            TAX                       
CODE_05BF88:        A0 01         LDY.B #$01                
CODE_05BF8A:        20 5B C9      JSR.W CODE_05C95B         
CODE_05BF8D:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05BF8F:        AD 68 14      LDA.W $1468               
CODE_05BF92:        85 20         STA $20                   
CODE_05BF94:        4C 2B C3      JMP.W CODE_05C32B         

ADDR_05BF97:        9C 11 14      STZ.W $1411               
ADDR_05BF9A:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05BF9C:        64 1A         STZ RAM_ScreenBndryXLo    
ADDR_05BF9E:        9C 62 14      STZ.W $1462               
ADDR_05BFA1:        64 1E         STZ $1E                   
ADDR_05BFA3:        9C 66 14      STZ.W $1466               
ADDR_05BFA6:        A9 00 06      LDA.W #$0600              
ADDR_05BFA9:        8D 3E 14      STA.W RAM_ScrollSprNum    
ADDR_05BFAC:        9C 4C 14      STZ.W $144C               
ADDR_05BFAF:        9C 54 14      STZ.W $1454               
ADDR_05BFB2:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_05BFB4:        A9 60         LDA.B #$60                
ADDR_05BFB6:        8D 41 14      STA.W $1441               
Return05BFB9:       60            RTS                       ; Return 

ADDR_05BFBA:        9C 11 14      STZ.W $1411               
ADDR_05BFBD:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05BFBF:        64 1E         STZ $1E                   
ADDR_05BFC1:        9C 66 14      STZ.W $1466               
ADDR_05BFC4:        A9 C0 03      LDA.W #$03C0              
ADDR_05BFC7:        85 20         STA $20                   
ADDR_05BFC9:        8D 68 14      STA.W $1468               
ADDR_05BFCC:        9C 40 14      STZ.W $1440               
ADDR_05BFCF:        A9 05 00      LDA.W #$0005              
CODE_05BFD2:        9C 44 14      STZ.W $1444               
CODE_05BFD5:        9C 42 14      STZ.W $1442               
CODE_05BFD8:        8D 3E 14      STA.W RAM_ScrollSprNum    
CODE_05BFDB:        9C 46 14      STZ.W $1446               
CODE_05BFDE:        9C 48 14      STZ.W $1448               
CODE_05BFE1:        9C 4E 14      STZ.W $144E               
CODE_05BFE4:        9C 50 14      STZ.W $1450               
CODE_05BFE7:        9C 4A 14      STZ.W $144A               
CODE_05BFEA:        9C 4C 14      STZ.W $144C               
CODE_05BFED:        9C 52 14      STZ.W $1452               
CODE_05BFF0:        9C 54 14      STZ.W $1454               
CODE_05BFF3:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return05BFF5:       60            RTS                       ; Return 

CODE_05BFF6:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05BFF8:        A9 00 0B      LDA.W #$0B00              
CODE_05BFFB:        80 D5         BRA CODE_05BFD2           


DATA_05BFFD:                      .db $00,$00,$02,$00

DATA_05C001:                      .db $80,$00,$00,$01

CODE_05C005:        9C 11 14      STZ.W $1411               
CODE_05C008:        AD 40 14      LDA.W $1440               
CODE_05C00B:        0A            ASL                       
CODE_05C00C:        A8            TAY                       
CODE_05C00D:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C00F:        B9 FD BF      LDA.W DATA_05BFFD,Y       
CODE_05C012:        8D 40 14      STA.W $1440               
CODE_05C015:        A9 0C 00      LDA.W #$000C              
CODE_05C018:        80 B8         BRA CODE_05BFD2           

CODE_05C01A:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C01C:        A9 00 0D      LDA.W #$0D00              
CODE_05C01F:        20 D2 BF      JSR.W CODE_05BFD2         
CODE_05C022:        9C 13 14      STZ.W $1413               
CODE_05C025:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C027:        9C 4A 14      STZ.W $144A               
CODE_05C02A:        9C 4C 14      STZ.W $144C               
CODE_05C02D:        9C 52 14      STZ.W $1452               
CODE_05C030:        9C 54 14      STZ.W $1454               
CODE_05C033:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return05C035:       60            RTS                       ; Return 

CODE_05C036:        AC 40 14      LDY.W $1440               
CODE_05C039:        B9 08 C8      LDA.W DATA_05C808,Y       
CODE_05C03C:        8D 44 14      STA.W $1444               
CODE_05C03F:        B9 0B C8      LDA.W DATA_05C80B,Y       
CODE_05C042:        8D 45 14      STA.W $1445               
CODE_05C045:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C047:        A9 00 0E      LDA.W #$0E00              
CODE_05C04A:        4C D5 BF      JMP.W CODE_05BFD5         

CODE_05C04D:        AD 56 14      LDA.W $1456               
CODE_05C050:        4A            LSR                       
CODE_05C051:        4A            LSR                       
CODE_05C052:        AA            TAX                       
CODE_05C053:        BD 44 14      LDA.W $1444,X             
CODE_05C056:        D0 07         BNE CODE_05C05F           
CODE_05C058:        AE 56 14      LDX.W $1456               
CODE_05C05B:        9E 46 14      STZ.W $1446,X             
Return05C05E:       60            RTS                       ; Return 

CODE_05C05F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C061:        BD 42 14      LDA.W $1442,X             
CODE_05C064:        A8            TAY                       
CODE_05C065:        B9 6E CA      LDA.W DATA_05CA6E,Y       
CODE_05C068:        29 FF 00      AND.W #$00FF              
CODE_05C06B:        85 04         STA $04                   
CODE_05C06D:        B9 BE CA      LDA.W DATA_05CABE,Y       
CODE_05C070:        29 FF 00      AND.W #$00FF              
CODE_05C073:        85 06         STA $06                   
CODE_05C075:        AD 56 14      LDA.W $1456               
CODE_05C078:        29 FF 00      AND.W #$00FF              
CODE_05C07B:        AA            TAX                       
CODE_05C07C:        BD 62 14      LDA.W $1462,X             
CODE_05C07F:        85 00         STA $00                   
CODE_05C081:        BD 64 14      LDA.W $1464,X             
CODE_05C084:        85 02         STA $02                   
CODE_05C086:        A2 02         LDX.B #$02                
CODE_05C088:        B9 6F CA      LDA.W DATA_05CA6F,Y       
CODE_05C08B:        29 FF 00      AND.W #$00FF              
CODE_05C08E:        C5 04         CMP $04                   
CODE_05C090:        D0 06         BNE CODE_05C098           
CODE_05C092:        64 04         STZ $04                   
CODE_05C094:        86 08         STX $08                   
CODE_05C096:        80 15         BRA CODE_05C0AD           

CODE_05C098:        0A            ASL                       
CODE_05C099:        0A            ASL                       
CODE_05C09A:        0A            ASL                       
CODE_05C09B:        0A            ASL                       
CODE_05C09C:        38            SEC                       
CODE_05C09D:        E5 00         SBC $00                   
CODE_05C09F:        85 00         STA $00                   
CODE_05C0A1:        10 06         BPL CODE_05C0A9           
CODE_05C0A3:        A2 00         LDX.B #$00                
CODE_05C0A5:        49 FF FF      EOR.W #$FFFF              
CODE_05C0A8:        1A            INC A                     
CODE_05C0A9:        85 04         STA $04                   
CODE_05C0AB:        86 08         STX $08                   
CODE_05C0AD:        A2 00         LDX.B #$00                
CODE_05C0AF:        B9 BF CA      LDA.W DATA_05CABF,Y       
CODE_05C0B2:        29 FF 00      AND.W #$00FF              
CODE_05C0B5:        C5 06         CMP $06                   
CODE_05C0B7:        D0 04         BNE CODE_05C0BD           
CODE_05C0B9:        64 06         STZ $06                   
CODE_05C0BB:        80 13         BRA CODE_05C0D0           

CODE_05C0BD:        0A            ASL                       
CODE_05C0BE:        0A            ASL                       
CODE_05C0BF:        0A            ASL                       
CODE_05C0C0:        0A            ASL                       
CODE_05C0C1:        38            SEC                       
CODE_05C0C2:        E5 02         SBC $02                   
CODE_05C0C4:        85 02         STA $02                   
CODE_05C0C6:        10 06         BPL CODE_05C0CE           
CODE_05C0C8:        A2 02         LDX.B #$02                
CODE_05C0CA:        49 FF FF      EOR.W #$FFFF              
CODE_05C0CD:        1A            INC A                     
CODE_05C0CE:        85 06         STA $06                   
CODE_05C0D0:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_05C0D2:        4A            LSR                       
CODE_05C0D3:        B0 02         BCS CODE_05C0D7           
CODE_05C0D5:        A6 08         LDX $08                   
CODE_05C0D7:        86 55         STX $55                   
CODE_05C0D9:        A9 FF FF      LDA.W #$FFFF              
CODE_05C0DC:        85 08         STA $08                   
CODE_05C0DE:        A5 04         LDA $04                   
CODE_05C0E0:        85 0A         STA $0A                   
CODE_05C0E2:        A5 06         LDA $06                   
CODE_05C0E4:        85 0C         STA $0C                   
CODE_05C0E6:        C5 04         CMP $04                   
CODE_05C0E8:        90 0B         BCC CODE_05C0F5           
CODE_05C0EA:        85 0A         STA $0A                   
CODE_05C0EC:        A5 04         LDA $04                   
CODE_05C0EE:        85 0C         STA $0C                   
CODE_05C0F0:        A9 01 00      LDA.W #$0001              
CODE_05C0F3:        85 08         STA $08                   
CODE_05C0F5:        A5 0A         LDA $0A                   
CODE_05C0F7:        8D 04 42      STA.W $4204               ; Dividend (Low Byte)
CODE_05C0FA:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05C0FC:        B9 0F CB      LDA.W DATA_05CB0F,Y       
CODE_05C0FF:        8D 06 42      STA.W $4206               ; Divisor B
CODE_05C102:        EA            NOP                       
CODE_05C103:        EA            NOP                       
CODE_05C104:        EA            NOP                       
CODE_05C105:        EA            NOP                       
CODE_05C106:        EA            NOP                       
CODE_05C107:        EA            NOP                       
CODE_05C108:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C10A:        AD 14 42      LDA.W $4214               ; Quotient of Divide Result (Low Byte)
CODE_05C10D:        D0 14         BNE CODE_05C123           
CODE_05C10F:        AD 56 14      LDA.W $1456               
CODE_05C112:        29 FF 00      AND.W #$00FF              
CODE_05C115:        4A            LSR                       
CODE_05C116:        4A            LSR                       
CODE_05C117:        AA            TAX                       
CODE_05C118:        FE 42 14      INC.W $1442,X             
CODE_05C11B:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05C11D:        DE 44 14      DEC.W $1444,X             
CODE_05C120:        4C 4D C0      JMP.W CODE_05C04D         

CODE_05C123:        85 0A         STA $0A                   ; Accum (16 bit) 
CODE_05C125:        A5 0C         LDA $0C                   
CODE_05C127:        0A            ASL                       
CODE_05C128:        0A            ASL                       
CODE_05C129:        0A            ASL                       
CODE_05C12A:        0A            ASL                       
CODE_05C12B:        85 0C         STA $0C                   
CODE_05C12D:        A0 10         LDY.B #$10                
CODE_05C12F:        A9 00 00      LDA.W #$0000              
CODE_05C132:        85 0E         STA $0E                   
CODE_05C134:        06 0C         ASL $0C                   
CODE_05C136:        2A            ROL                       
CODE_05C137:        C5 0A         CMP $0A                   
CODE_05C139:        90 02         BCC CODE_05C13D           
CODE_05C13B:        E5 0A         SBC $0A                   
CODE_05C13D:        26 0E         ROL $0E                   
CODE_05C13F:        88            DEY                       
CODE_05C140:        D0 F2         BNE CODE_05C134           
CODE_05C142:        AD 56 14      LDA.W $1456               
CODE_05C145:        29 FF 00      AND.W #$00FF              
CODE_05C148:        4A            LSR                       
CODE_05C149:        4A            LSR                       
CODE_05C14A:        AA            TAX                       
CODE_05C14B:        BD 42 14      LDA.W $1442,X             
CODE_05C14E:        A8            TAY                       
CODE_05C14F:        B9 0F CB      LDA.W DATA_05CB0F,Y       
CODE_05C152:        29 FF 00      AND.W #$00FF              
CODE_05C155:        0A            ASL                       
CODE_05C156:        0A            ASL                       
CODE_05C157:        0A            ASL                       
CODE_05C158:        0A            ASL                       
CODE_05C159:        85 0A         STA $0A                   
CODE_05C15B:        A2 02         LDX.B #$02                
CODE_05C15D:        A5 08         LDA $08                   
CODE_05C15F:        30 04         BMI CODE_05C165           
CODE_05C161:        A5 0A         LDA $0A                   
CODE_05C163:        80 02         BRA CODE_05C167           

CODE_05C165:        A5 0E         LDA $0E                   
CODE_05C167:        34 00         BIT $00,X                 
CODE_05C169:        10 04         BPL CODE_05C16F           
CODE_05C16B:        49 FF FF      EOR.W #$FFFF              
CODE_05C16E:        1A            INC A                     
CODE_05C16F:        DA            PHX                       
CODE_05C170:        48            PHA                       
CODE_05C171:        8A            TXA                       
CODE_05C172:        18            CLC                       
CODE_05C173:        6D 56 14      ADC.W $1456               
CODE_05C176:        AA            TAX                       
CODE_05C177:        68            PLA                       
CODE_05C178:        A0 00         LDY.B #$00                
CODE_05C17A:        DD 46 14      CMP.W $1446,X             
CODE_05C17D:        F0 0E         BEQ CODE_05C18D           
CODE_05C17F:        10 02         BPL CODE_05C183           
CODE_05C181:        A0 02         LDY.B #$02                
CODE_05C183:        BD 46 14      LDA.W $1446,X             
CODE_05C186:        18            CLC                       
CODE_05C187:        79 5F CB      ADC.W DATA_05CB5F,Y       
CODE_05C18A:        9D 46 14      STA.W $1446,X             
CODE_05C18D:        20 F9 C4      JSR.W CODE_05C4F9         
CODE_05C190:        FA            PLX                       
CODE_05C191:        CA            DEX                       
CODE_05C192:        CA            DEX                       
CODE_05C193:        10 C8         BPL CODE_05C15D           
CODE_05C195:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return05C197:       60            RTS                       ; Return 

CODE_05C198:        20 4D C0      JSR.W CODE_05C04D         
CODE_05C19B:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C19D:        AD 66 14      LDA.W $1466               
CODE_05C1A0:        8D 62 14      STA.W $1462               
CODE_05C1A3:        A5 20         LDA $20                   
CODE_05C1A5:        18            CLC                       
CODE_05C1A6:        6D 88 18      ADC.W RAM_Layer1DispYLo   
CODE_05C1A9:        85 20         STA $20                   
CODE_05C1AB:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return05C1AD:       60            RTS                       ; Return 

ADDR_05C1AE:        AD 56 14      LDA.W $1456               ; \ Unreachable 
ADDR_05C1B1:        4A            LSR                       
ADDR_05C1B2:        4A            LSR                       
ADDR_05C1B3:        AA            TAX                       
ADDR_05C1B4:        BD 44 14      LDA.W $1444,X             
ADDR_05C1B7:        30 1B         BMI ADDR_05C1D4           
ADDR_05C1B9:        DE 44 14      DEC.W $1444,X             
ADDR_05C1BC:        BD 44 14      LDA.W $1444,X             
ADDR_05C1BF:        C9 20         CMP.B #$20                
ADDR_05C1C1:        90 0E         BCC ADDR_05C1D1           
ADDR_05C1C3:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05C1C5:        AE 56 14      LDX.W $1456               
ADDR_05C1C8:        BD 64 14      LDA.W $1464,X             
ADDR_05C1CB:        49 01 00      EOR.W #$0001              
ADDR_05C1CE:        9D 64 14      STA.W $1464,X             
ADDR_05C1D1:        4C 2B C3      JMP.W CODE_05C32B         

ADDR_05C1D4:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
ADDR_05C1D6:        AC 56 14      LDY.W $1456               
ADDR_05C1D9:        B9 4E 14      LDA.W $144E,Y             
ADDR_05C1DC:        AA            TAX                       
ADDR_05C1DD:        B9 64 14      LDA.W $1464,Y             
ADDR_05C1E0:        D9 4E 14      CMP.W $144E,Y             
ADDR_05C1E3:        90 06         BCC ADDR_05C1EB           
ADDR_05C1E5:        85 04         STA $04                   
ADDR_05C1E7:        86 02         STX $02                   
ADDR_05C1E9:        80 04         BRA ADDR_05C1EF           

ADDR_05C1EB:        85 02         STA $02                   
ADDR_05C1ED:        86 04         STX $04                   
ADDR_05C1EF:        E2 10         SEP #$10                  ; Index (8 bit) 
ADDR_05C1F1:        A5 02         LDA $02                   
ADDR_05C1F3:        C5 04         CMP $04                   
ADDR_05C1F5:        90 56         BCC ADDR_05C24D           
ADDR_05C1F7:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_05C1F9:        AD 56 14      LDA.W $1456               
ADDR_05C1FC:        29 FF         AND.B #$FF                
ADDR_05C1FE:        4A            LSR                       
ADDR_05C1FF:        4A            LSR                       
ADDR_05C200:        AA            TAX                       
ADDR_05C201:        A9 30         LDA.B #$30                
ADDR_05C203:        9D 44 14      STA.W $1444,X             
ADDR_05C206:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05C208:        AE 56 14      LDX.W $1456               
ADDR_05C20B:        9E 48 14      STZ.W $1448,X             
ADDR_05C20E:        9E 50 14      STZ.W $1450,X             
ADDR_05C211:        AC 40 14      LDY.W $1440               
ADDR_05C214:        AD 56 14      LDA.W $1456               
ADDR_05C217:        29 FF 00      AND.W #$00FF              
ADDR_05C21A:        F0 03         BEQ ADDR_05C21F           
ADDR_05C21C:        AC 41 14      LDY.W $1441               
ADDR_05C21F:        B9 C7 CB      LDA.W DATA_05CBC7,Y       
ADDR_05C222:        29 FF 00      AND.W #$00FF              
ADDR_05C225:        85 00         STA $00                   
ADDR_05C227:        8A            TXA                       
ADDR_05C228:        4A            LSR                       
ADDR_05C229:        4A            LSR                       
ADDR_05C22A:        AA            TAX                       
ADDR_05C22B:        BD 42 14      LDA.W $1442,X             
ADDR_05C22E:        49 01 00      EOR.W #$0001              
ADDR_05C231:        9D 42 14      STA.W $1442,X             
ADDR_05C234:        29 FF 00      AND.W #$00FF              
ADDR_05C237:        D0 08         BNE ADDR_05C241           
ADDR_05C239:        A5 00         LDA $00                   
ADDR_05C23B:        49 FF FF      EOR.W #$FFFF              
ADDR_05C23E:        1A            INC A                     
ADDR_05C23F:        85 00         STA $00                   
ADDR_05C241:        AE 56 14      LDX.W $1456               
ADDR_05C244:        A5 00         LDA $00                   
ADDR_05C246:        18            CLC                       
ADDR_05C247:        7D 4E 14      ADC.W $144E,X             
ADDR_05C24A:        9D 4E 14      STA.W $144E,X             
ADDR_05C24D:        AD 56 14      LDA.W $1456               
ADDR_05C250:        29 FF 00      AND.W #$00FF              
ADDR_05C253:        4A            LSR                       
ADDR_05C254:        4A            LSR                       
ADDR_05C255:        A8            TAY                       
ADDR_05C256:        B9 42 14      LDA.W $1442,Y             
ADDR_05C259:        AA            TAX                       
ADDR_05C25A:        BD C8 CB      LDA.W DATA_05CBC8,X       
ADDR_05C25D:        29 FF 00      AND.W #$00FF              
ADDR_05C260:        E0 01         CPX.B #$01                
ADDR_05C262:        F0 04         BEQ ADDR_05C268           
ADDR_05C264:        49 FF FF      EOR.W #$FFFF              
ADDR_05C267:        1A            INC A                     
ADDR_05C268:        AE 56 14      LDX.W $1456               
ADDR_05C26B:        A0 00         LDY.B #$00                
ADDR_05C26D:        DD 48 14      CMP.W $1448,X             
ADDR_05C270:        F0 0E         BEQ ADDR_05C280           
ADDR_05C272:        10 02         BPL ADDR_05C276           
ADDR_05C274:        A0 02         LDY.B #$02                
ADDR_05C276:        BD 48 14      LDA.W $1448,X             
ADDR_05C279:        18            CLC                       
ADDR_05C27A:        79 7B CB      ADC.W DATA_05CB7B,Y       
ADDR_05C27D:        9D 48 14      STA.W $1448,X             
ADDR_05C280:        4C 1D C3      JMP.W ADDR_05C31D         

ADDR_05C283:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05C285:        AC 56 14      LDY.W $1456               
ADDR_05C288:        B9 4E 14      LDA.W $144E,Y             
ADDR_05C28B:        38            SEC                       
ADDR_05C28C:        F9 64 14      SBC.W $1464,Y             
ADDR_05C28F:        10 04         BPL ADDR_05C295           
ADDR_05C291:        49 FF FF      EOR.W #$FFFF              
ADDR_05C294:        1A            INC A                     
ADDR_05C295:        85 02         STA $02                   
ADDR_05C297:        AD 56 14      LDA.W $1456               
ADDR_05C29A:        29 FF 00      AND.W #$00FF              
ADDR_05C29D:        4A            LSR                       
ADDR_05C29E:        4A            LSR                       
ADDR_05C29F:        AA            TAX                       
ADDR_05C2A0:        BD 42 14      LDA.W $1442,X             
ADDR_05C2A3:        29 FF 00      AND.W #$00FF              
ADDR_05C2A6:        A8            TAY                       
ADDR_05C2A7:        4A            LSR                       
ADDR_05C2A8:        AA            TAX                       
ADDR_05C2A9:        A5 02         LDA $02                   
ADDR_05C2AB:        8D 04 42      STA.W $4204               ; Dividend (Low Byte)
ADDR_05C2AE:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_05C2B0:        BD E3 CB      LDA.W DATA_05CBE3,X       
ADDR_05C2B3:        8D 06 42      STA.W $4206               ; Divisor B
ADDR_05C2B6:        EA            NOP                       
ADDR_05C2B7:        EA            NOP                       
ADDR_05C2B8:        EA            NOP                       
ADDR_05C2B9:        EA            NOP                       
ADDR_05C2BA:        EA            NOP                       
ADDR_05C2BB:        EA            NOP                       
ADDR_05C2BC:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05C2BE:        AD 14 42      LDA.W $4214               ; Quotient of Divide Result (Low Byte)
ADDR_05C2C1:        D0 22         BNE ADDR_05C2E5           
ADDR_05C2C3:        AD 56 14      LDA.W $1456               
ADDR_05C2C6:        29 FF 00      AND.W #$00FF              
ADDR_05C2C9:        4A            LSR                       
ADDR_05C2CA:        4A            LSR                       
ADDR_05C2CB:        AA            TAX                       
ADDR_05C2CC:        BD 42 14      LDA.W $1442,X             
ADDR_05C2CF:        A8            TAY                       
ADDR_05C2D0:        AE 56 14      LDX.W $1456               
ADDR_05C2D3:        A9 00 02      LDA.W #$0200              
ADDR_05C2D6:        C0 01         CPY.B #$01                
ADDR_05C2D8:        D0 04         BNE ADDR_05C2DE           
ADDR_05C2DA:        49 FF FF      EOR.W #$FFFF              
ADDR_05C2DD:        1A            INC A                     
ADDR_05C2DE:        18            CLC                       
ADDR_05C2DF:        7D 64 14      ADC.W $1464,X             
ADDR_05C2E2:        9D 64 14      STA.W $1464,X             
ADDR_05C2E5:        AE 40 14      LDX.W $1440               
ADDR_05C2E8:        AD 56 14      LDA.W $1456               
ADDR_05C2EB:        29 FF 00      AND.W #$00FF              
ADDR_05C2EE:        F0 03         BEQ ADDR_05C2F3           
ADDR_05C2F0:        AE 41 14      LDX.W $1441               
ADDR_05C2F3:        BD E3 CB      LDA.W DATA_05CBE3,X       
ADDR_05C2F6:        29 FF 00      AND.W #$00FF              
ADDR_05C2F9:        0A            ASL                       
ADDR_05C2FA:        0A            ASL                       
ADDR_05C2FB:        0A            ASL                       
ADDR_05C2FC:        0A            ASL                       
ADDR_05C2FD:        C0 01         CPY.B #$01                
ADDR_05C2FF:        F0 04         BEQ ADDR_05C305           
ADDR_05C301:        49 FF FF      EOR.W #$FFFF              
ADDR_05C304:        1A            INC A                     
ADDR_05C305:        AE 56 14      LDX.W $1456               
ADDR_05C308:        A0 00         LDY.B #$00                
ADDR_05C30A:        DD 48 14      CMP.W $1448,X             
ADDR_05C30D:        F0 0E         BEQ ADDR_05C31D           
ADDR_05C30F:        10 02         BPL ADDR_05C313           
ADDR_05C311:        A0 02         LDY.B #$02                
ADDR_05C313:        BD 48 14      LDA.W $1448,X             
ADDR_05C316:        18            CLC                       
ADDR_05C317:        79 9B CB      ADC.W DATA_05CB9B,Y       
ADDR_05C31A:        9D 48 14      STA.W $1448,X             
ADDR_05C31D:        AD 56 14      LDA.W $1456               
ADDR_05C320:        29 FF 00      AND.W #$00FF              
ADDR_05C323:        18            CLC                       
ADDR_05C324:        69 02 00      ADC.W #$0002              
ADDR_05C327:        AA            TAX                       
CODE_05C328:        20 F9 C4      JSR.W CODE_05C4F9         
CODE_05C32B:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return05C32D:       60            RTS                       ; Return 

ADDR_05C32E:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05C330:        AC 56 14      LDY.W $1456               
ADDR_05C333:        B9 50 14      LDA.W $1450,Y             
ADDR_05C336:        38            SEC                       
ADDR_05C337:        F9 62 14      SBC.W $1462,Y             
ADDR_05C33A:        10 04         BPL ADDR_05C340           
ADDR_05C33C:        49 FF FF      EOR.W #$FFFF              
ADDR_05C33F:        1A            INC A                     
ADDR_05C340:        85 02         STA $02                   
ADDR_05C342:        AD 56 14      LDA.W $1456               
ADDR_05C345:        29 FF 00      AND.W #$00FF              
ADDR_05C348:        4A            LSR                       
ADDR_05C349:        4A            LSR                       
ADDR_05C34A:        AA            TAX                       
ADDR_05C34B:        BD 42 14      LDA.W $1442,X             
ADDR_05C34E:        29 FF 00      AND.W #$00FF              
ADDR_05C351:        A8            TAY                       
ADDR_05C352:        4A            LSR                       
ADDR_05C353:        AA            TAX                       
ADDR_05C354:        A5 02         LDA $02                   
ADDR_05C356:        8D 04 42      STA.W $4204               ; Dividend (Low Byte)
ADDR_05C359:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_05C35B:        BD E5 CB      LDA.W DATA_05CBE5,X       
ADDR_05C35E:        8D 06 42      STA.W $4206               ; Divisor B
ADDR_05C361:        EA            NOP                       
ADDR_05C362:        EA            NOP                       
ADDR_05C363:        EA            NOP                       
ADDR_05C364:        EA            NOP                       
ADDR_05C365:        EA            NOP                       
ADDR_05C366:        EA            NOP                       
ADDR_05C367:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05C369:        AD 14 42      LDA.W $4214               ; Quotient of Divide Result (Low Byte)
ADDR_05C36C:        D0 31         BNE ADDR_05C39F           
ADDR_05C36E:        AD 56 14      LDA.W $1456               
ADDR_05C371:        29 FF 00      AND.W #$00FF              
ADDR_05C374:        4A            LSR                       
ADDR_05C375:        4A            LSR                       
ADDR_05C376:        AA            TAX                       
ADDR_05C377:        BD 42 14      LDA.W $1442,X             
ADDR_05C37A:        A8            TAY                       
ADDR_05C37B:        AE 56 14      LDX.W $1456               
ADDR_05C37E:        A9 00 06      LDA.W #$0600              
ADDR_05C381:        C0 01         CPY.B #$01                
ADDR_05C383:        D0 04         BNE ADDR_05C389           
ADDR_05C385:        49 FF FF      EOR.W #$FFFF              
ADDR_05C388:        1A            INC A                     
ADDR_05C389:        18            CLC                       
ADDR_05C38A:        7D 62 14      ADC.W $1462,X             
ADDR_05C38D:        9D 62 14      STA.W $1462,X             
ADDR_05C390:        A9 F8 FF      LDA.W #$FFF8              
ADDR_05C393:        9D 45 00      STA.W $0045,X             
ADDR_05C396:        A9 17 00      LDA.W #$0017              
ADDR_05C399:        9D 47 00      STA.W $0047,X             
ADDR_05C39C:        9C 95 00      STZ.W RAM_MarioXPosHi     
ADDR_05C39F:        AD 56 14      LDA.W $1456               
ADDR_05C3A2:        29 FF 00      AND.W #$00FF              
ADDR_05C3A5:        4A            LSR                       
ADDR_05C3A6:        4A            LSR                       
ADDR_05C3A7:        AA            TAX                       
ADDR_05C3A8:        BD 42 14      LDA.W $1442,X             
ADDR_05C3AB:        29 FF 00      AND.W #$00FF              
ADDR_05C3AE:        48            PHA                       
ADDR_05C3AF:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_05C3B1:        A2 02         LDX.B #$02                
ADDR_05C3B3:        A0 00         LDY.B #$00                
ADDR_05C3B5:        C9 01         CMP.B #$01                
ADDR_05C3B7:        F0 04         BEQ ADDR_05C3BD           
ADDR_05C3B9:        A2 00         LDX.B #$00                
ADDR_05C3BB:        A0 01         LDY.B #$01                
ADDR_05C3BD:        8A            TXA                       
ADDR_05C3BE:        99 55 00      STA.W $0055,Y             
ADDR_05C3C1:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05C3C3:        68            PLA                       
ADDR_05C3C4:        A8            TAY                       
ADDR_05C3C5:        AE 40 14      LDX.W $1440               
ADDR_05C3C8:        AD 56 14      LDA.W $1456               
ADDR_05C3CB:        29 FF 00      AND.W #$00FF              
ADDR_05C3CE:        F0 03         BEQ ADDR_05C3D3           
ADDR_05C3D0:        AE 41 14      LDX.W $1441               
ADDR_05C3D3:        BD E5 CB      LDA.W DATA_05CBE5,X       
ADDR_05C3D6:        29 FF 00      AND.W #$00FF              
ADDR_05C3D9:        0A            ASL                       
ADDR_05C3DA:        0A            ASL                       
ADDR_05C3DB:        0A            ASL                       
ADDR_05C3DC:        0A            ASL                       
ADDR_05C3DD:        C0 01         CPY.B #$01                
ADDR_05C3DF:        F0 04         BEQ ADDR_05C3E5           
ADDR_05C3E1:        49 FF FF      EOR.W #$FFFF              
ADDR_05C3E4:        1A            INC A                     
ADDR_05C3E5:        AE 56 14      LDX.W $1456               
ADDR_05C3E8:        A0 00         LDY.B #$00                
ADDR_05C3EA:        DD 46 14      CMP.W $1446,X             
ADDR_05C3ED:        F0 0E         BEQ ADDR_05C3FD           
ADDR_05C3EF:        10 02         BPL ADDR_05C3F3           
ADDR_05C3F1:        A0 02         LDY.B #$02                
ADDR_05C3F3:        BD 46 14      LDA.W $1446,X             
ADDR_05C3F6:        18            CLC                       
ADDR_05C3F7:        79 A3 CB      ADC.W DATA_05CBA3,Y       
ADDR_05C3FA:        9D 46 14      STA.W $1446,X             
ADDR_05C3FD:        AE 56 14      LDX.W $1456               
ADDR_05C400:        20 F9 C4      JSR.W CODE_05C4F9         
ADDR_05C403:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return05C405:       60            RTS                       ; Return 


DATA_05C406:                      .db $FF,$01

DATA_05C408:                      .db $FC,$04

DATA_05C40A:                      .db $30,$A0

CODE_05C40C:        AD 03 14      LDA.W $1403               
CODE_05C40F:        F0 03         BEQ CODE_05C414           
CODE_05C411:        4C 94 C4      JMP.W CODE_05C494         

CODE_05C414:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C416:        AC 31 19      LDY.W $1931               
CODE_05C419:        C0 01         CPY.B #$01                
CODE_05C41B:        F0 04         BEQ CODE_05C421           
CODE_05C41D:        C0 03         CPY.B #$03                
CODE_05C41F:        D0 07         BNE CODE_05C428           
CODE_05C421:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_05C423:        4A            LSR                       
CODE_05C424:        85 22         STA $22                   
CODE_05C426:        80 69         BRA CODE_05C491           

CODE_05C428:        AC 9D 00      LDY.W RAM_SpritesLocked   
CODE_05C42B:        D0 60         BNE CODE_05C48D           
CODE_05C42D:        AD 60 14      LDA.W $1460               
CODE_05C430:        29 FF 00      AND.W #$00FF              
CODE_05C433:        A8            TAY                       
CODE_05C434:        AD EB CB      LDA.W DATA_05CBEB         
CODE_05C437:        29 FF 00      AND.W #$00FF              
CODE_05C43A:        0A            ASL                       
CODE_05C43B:        0A            ASL                       
CODE_05C43C:        0A            ASL                       
CODE_05C43D:        0A            ASL                       
CODE_05C43E:        C0 01         CPY.B #$01                
CODE_05C440:        F0 04         BEQ CODE_05C446           
ADDR_05C442:        49 FF FF      EOR.W #$FFFF              
ADDR_05C445:        1A            INC A                     
CODE_05C446:        A0 00         LDY.B #$00                
CODE_05C448:        CD 58 14      CMP.W $1458               
CODE_05C44B:        F0 0E         BEQ CODE_05C45B           
CODE_05C44D:        10 02         BPL CODE_05C451           
ADDR_05C44F:        A0 02         LDY.B #$02                
CODE_05C451:        AD 58 14      LDA.W $1458               
CODE_05C454:        18            CLC                       
CODE_05C455:        79 BB CB      ADC.W DATA_05CBBB,Y       
CODE_05C458:        8D 58 14      STA.W $1458               
CODE_05C45B:        AD 5C 14      LDA.W $145C               
CODE_05C45E:        29 FF 00      AND.W #$00FF              
CODE_05C461:        18            CLC                       
CODE_05C462:        6D 58 14      ADC.W $1458               
CODE_05C465:        8D 5C 14      STA.W $145C               
CODE_05C468:        29 00 FF      AND.W #$FF00              
CODE_05C46B:        10 03         BPL CODE_05C470           
ADDR_05C46D:        09 FF 00      ORA.W #$00FF              
CODE_05C470:        EB            XBA                       
CODE_05C471:        18            CLC                       
CODE_05C472:        65 22         ADC $22                   
CODE_05C474:        85 22         STA $22                   
CODE_05C476:        AD BD 17      LDA.W $17BD               
CODE_05C479:        29 FF 00      AND.W #$00FF              
CODE_05C47C:        C9 80 00      CMP.W #$0080              
CODE_05C47F:        90 03         BCC CODE_05C484           
CODE_05C481:        09 00 FF      ORA.W #$FF00              
CODE_05C484:        85 00         STA $00                   
CODE_05C486:        A5 22         LDA $22                   
CODE_05C488:        18            CLC                       
CODE_05C489:        65 00         ADC $00                   
CODE_05C48B:        85 22         STA $22                   
CODE_05C48D:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_05C48F:        85 24         STA $24                   
CODE_05C491:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return05C493:       60            RTS                       ; Return 

CODE_05C494:        3A            DEC A                     
CODE_05C495:        D0 55         BNE CODE_05C4EC           
CODE_05C497:        AD 9D 00      LDA.W RAM_SpritesLocked   
CODE_05C49A:        D0 50         BNE CODE_05C4EC           
CODE_05C49C:        AC 60 14      LDY.W $1460               
CODE_05C49F:        A5 14         LDA RAM_FrameCounterB     
CODE_05C4A1:        29 03         AND.B #$03                
CODE_05C4A3:        D0 1B         BNE CODE_05C4C0           
CODE_05C4A5:        AD 5A 14      LDA.W $145A               
CODE_05C4A8:        D0 05         BNE CODE_05C4AF           
CODE_05C4AA:        CE 9D 1B      DEC.W $1B9D               
CODE_05C4AD:        D0 3D         BNE CODE_05C4EC           
CODE_05C4AF:        D9 08 C4      CMP.W DATA_05C408,Y       
CODE_05C4B2:        F0 07         BEQ CODE_05C4BB           
CODE_05C4B4:        18            CLC                       
CODE_05C4B5:        79 06 C4      ADC.W DATA_05C406,Y       
CODE_05C4B8:        8D 5A 14      STA.W $145A               
CODE_05C4BB:        A9 4B         LDA.B #$4B                
CODE_05C4BD:        8D 9D 1B      STA.W $1B9D               
CODE_05C4C0:        A5 24         LDA $24                   
CODE_05C4C2:        D9 0A C4      CMP.W DATA_05C40A,Y       
CODE_05C4C5:        D0 06         BNE CODE_05C4CD           
CODE_05C4C7:        98            TYA                       
CODE_05C4C8:        49 01         EOR.B #$01                
CODE_05C4CA:        8D 60 14      STA.W $1460               
CODE_05C4CD:        AD 5A 14      LDA.W $145A               
CODE_05C4D0:        0A            ASL                       
CODE_05C4D1:        0A            ASL                       
CODE_05C4D2:        0A            ASL                       
CODE_05C4D3:        0A            ASL                       
CODE_05C4D4:        18            CLC                       
CODE_05C4D5:        6D 5C 14      ADC.W $145C               
CODE_05C4D8:        8D 5C 14      STA.W $145C               
CODE_05C4DB:        AD 5A 14      LDA.W $145A               
CODE_05C4DE:        08            PHP                       
CODE_05C4DF:        4A            LSR                       
CODE_05C4E0:        4A            LSR                       
CODE_05C4E1:        4A            LSR                       
CODE_05C4E2:        4A            LSR                       
CODE_05C4E3:        28            PLP                       
CODE_05C4E4:        10 02         BPL CODE_05C4E8           
CODE_05C4E6:        09 F0         ORA.B #$F0                
CODE_05C4E8:        65 24         ADC $24                   
CODE_05C4EA:        85 24         STA $24                   
CODE_05C4EC:        A5 22         LDA $22                   
CODE_05C4EE:        38            SEC                       
CODE_05C4EF:        6D BD 17      ADC.W $17BD               
CODE_05C4F2:        85 22         STA $22                   
CODE_05C4F4:        A9 01         LDA.B #$01                
CODE_05C4F6:        85 23         STA $23                   
Return05C4F8:       60            RTS                       ; Return 

CODE_05C4F9:        BD 4E 14      LDA.W $144E,X             ; Accum (16 bit) 
CODE_05C4FC:        29 FF 00      AND.W #$00FF              
CODE_05C4FF:        18            CLC                       
CODE_05C500:        7D 46 14      ADC.W $1446,X             
CODE_05C503:        9D 4E 14      STA.W $144E,X             
CODE_05C506:        29 00 FF      AND.W #$FF00              
CODE_05C509:        10 03         BPL CODE_05C50E           
CODE_05C50B:        09 FF 00      ORA.W #$00FF              
CODE_05C50E:        EB            XBA                       
CODE_05C50F:        18            CLC                       
CODE_05C510:        7D 62 14      ADC.W $1462,X             
CODE_05C513:        9D 62 14      STA.W $1462,X             
CODE_05C516:        A5 08         LDA $08                   
CODE_05C518:        49 FF FF      EOR.W #$FFFF              
CODE_05C51B:        1A            INC A                     
CODE_05C51C:        85 08         STA $08                   
Return05C51E:       60            RTS                       ; Return 

CODE_05C51F:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_05C521:        AC 56 14      LDY.W $1456               
CODE_05C524:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_05C526:        B9 50 14      LDA.W $1450,Y             
CODE_05C529:        AA            TAX                       
CODE_05C52A:        B9 62 14      LDA.W $1462,Y             
CODE_05C52D:        D9 50 14      CMP.W $1450,Y             
CODE_05C530:        90 06         BCC CODE_05C538           
CODE_05C532:        85 04         STA $04                   
CODE_05C534:        86 02         STX $02                   
CODE_05C536:        80 04         BRA CODE_05C53C           

CODE_05C538:        85 02         STA $02                   
CODE_05C53A:        86 04         STX $04                   
CODE_05C53C:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_05C53E:        A5 02         LDA $02                   
CODE_05C540:        C5 04         CMP $04                   
CODE_05C542:        90 41         BCC CODE_05C585           
CODE_05C544:        AC 40 14      LDY.W $1440               
CODE_05C547:        AD 56 14      LDA.W $1456               
CODE_05C54A:        F0 03         BEQ CODE_05C54F           
CODE_05C54C:        AC 41 14      LDY.W $1441               
CODE_05C54F:        98            TYA                       
CODE_05C550:        0A            ASL                       
CODE_05C551:        A8            TAY                       
CODE_05C552:        B9 EE CB      LDA.W DATA_05CBEE,Y       
CODE_05C555:        29 FF 00      AND.W #$00FF              
CODE_05C558:        85 00         STA $00                   
CODE_05C55A:        AD 56 14      LDA.W $1456               
CODE_05C55D:        29 FF 00      AND.W #$00FF              
CODE_05C560:        4A            LSR                       
CODE_05C561:        4A            LSR                       
CODE_05C562:        AA            TAX                       
CODE_05C563:        BD 42 14      LDA.W $1442,X             
CODE_05C566:        49 01 00      EOR.W #$0001              
CODE_05C569:        9D 42 14      STA.W $1442,X             
CODE_05C56C:        29 FF 00      AND.W #$00FF              
CODE_05C56F:        D0 08         BNE CODE_05C579           
CODE_05C571:        A5 00         LDA $00                   
CODE_05C573:        49 FF FF      EOR.W #$FFFF              
CODE_05C576:        1A            INC A                     
CODE_05C577:        85 00         STA $00                   
CODE_05C579:        AE 56 14      LDX.W $1456               
CODE_05C57C:        A5 00         LDA $00                   
CODE_05C57E:        18            CLC                       
CODE_05C57F:        7D 50 14      ADC.W $1450,X             
CODE_05C582:        9D 50 14      STA.W $1450,X             
CODE_05C585:        AD 56 14      LDA.W $1456               
CODE_05C588:        29 FF 00      AND.W #$00FF              
CODE_05C58B:        4A            LSR                       
CODE_05C58C:        4A            LSR                       
CODE_05C58D:        AA            TAX                       
CODE_05C58E:        BD 42 14      LDA.W $1442,X             
CODE_05C591:        AA            TAX                       
CODE_05C592:        BD F1 CB      LDA.W DATA_05CBF1,X       
CODE_05C595:        29 FF 00      AND.W #$00FF              
CODE_05C598:        E0 01         CPX.B #$01                
CODE_05C59A:        F0 04         BEQ CODE_05C5A0           
CODE_05C59C:        49 FF FF      EOR.W #$FFFF              
CODE_05C59F:        1A            INC A                     
CODE_05C5A0:        AE 56 14      LDX.W $1456               
CODE_05C5A3:        A0 00         LDY.B #$00                
CODE_05C5A5:        DD 46 14      CMP.W $1446,X             
CODE_05C5A8:        F0 0E         BEQ CODE_05C5B8           
CODE_05C5AA:        10 02         BPL CODE_05C5AE           
CODE_05C5AC:        A0 02         LDY.B #$02                
CODE_05C5AE:        BD 46 14      LDA.W $1446,X             
CODE_05C5B1:        18            CLC                       
CODE_05C5B2:        79 C3 CB      ADC.W DATA_05CBC3,Y       
CODE_05C5B5:        9D 46 14      STA.W $1446,X             
CODE_05C5B8:        4C 28 C3      JMP.W CODE_05C328         

CODE_05C5BB:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_05C5BD:        AC 56 14      LDY.W $1456               
CODE_05C5C0:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_05C5C2:        B9 4E 14      LDA.W $144E,Y             
CODE_05C5C5:        AA            TAX                       
CODE_05C5C6:        B9 64 14      LDA.W $1464,Y             
CODE_05C5C9:        D9 4E 14      CMP.W $144E,Y             
CODE_05C5CC:        90 06         BCC CODE_05C5D4           
CODE_05C5CE:        85 04         STA $04                   
CODE_05C5D0:        86 02         STX $02                   
CODE_05C5D2:        80 04         BRA CODE_05C5D8           

CODE_05C5D4:        85 02         STA $02                   
CODE_05C5D6:        86 04         STX $04                   
CODE_05C5D8:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_05C5DA:        A5 02         LDA $02                   
CODE_05C5DC:        C5 04         CMP $04                   
CODE_05C5DE:        90 41         BCC CODE_05C621           
CODE_05C5E0:        AC 40 14      LDY.W $1440               
CODE_05C5E3:        AD 56 14      LDA.W $1456               
CODE_05C5E6:        F0 03         BEQ CODE_05C5EB           
CODE_05C5E8:        AC 41 14      LDY.W $1441               
CODE_05C5EB:        98            TYA                       
CODE_05C5EC:        0A            ASL                       
CODE_05C5ED:        A8            TAY                       
CODE_05C5EE:        B9 F6 CB      LDA.W DATA_05CBF6,Y       
CODE_05C5F1:        29 FF 00      AND.W #$00FF              
CODE_05C5F4:        85 00         STA $00                   
CODE_05C5F6:        AD 56 14      LDA.W $1456               
CODE_05C5F9:        29 FF 00      AND.W #$00FF              
CODE_05C5FC:        4A            LSR                       
CODE_05C5FD:        4A            LSR                       
CODE_05C5FE:        AA            TAX                       
CODE_05C5FF:        BD 42 14      LDA.W $1442,X             
CODE_05C602:        49 01 00      EOR.W #$0001              
CODE_05C605:        9D 42 14      STA.W $1442,X             
CODE_05C608:        29 FF 00      AND.W #$00FF              
CODE_05C60B:        D0 08         BNE CODE_05C615           
CODE_05C60D:        A5 00         LDA $00                   
CODE_05C60F:        49 FF FF      EOR.W #$FFFF              
CODE_05C612:        1A            INC A                     
CODE_05C613:        85 00         STA $00                   
CODE_05C615:        AE 56 14      LDX.W $1456               
CODE_05C618:        A5 00         LDA $00                   
CODE_05C61A:        18            CLC                       
CODE_05C61B:        7D 4E 14      ADC.W $144E,X             
CODE_05C61E:        9D 4E 14      STA.W $144E,X             
CODE_05C621:        AD 56 14      LDA.W $1456               
CODE_05C624:        29 FF 00      AND.W #$00FF              
CODE_05C627:        4A            LSR                       
CODE_05C628:        4A            LSR                       
CODE_05C629:        AA            TAX                       
CODE_05C62A:        BD 42 14      LDA.W $1442,X             
CODE_05C62D:        AA            TAX                       
CODE_05C62E:        BD F1 CB      LDA.W DATA_05CBF1,X       
CODE_05C631:        29 FF 00      AND.W #$00FF              
CODE_05C634:        E0 01         CPX.B #$01                
CODE_05C636:        F0 04         BEQ CODE_05C63C           
CODE_05C638:        49 FF FF      EOR.W #$FFFF              
CODE_05C63B:        1A            INC A                     
CODE_05C63C:        AE 56 14      LDX.W $1456               
CODE_05C63F:        A0 00         LDY.B #$00                
CODE_05C641:        DD 48 14      CMP.W $1448,X             
CODE_05C644:        F0 0E         BEQ CODE_05C654           
CODE_05C646:        10 02         BPL CODE_05C64A           
CODE_05C648:        A0 02         LDY.B #$02                
CODE_05C64A:        BD 48 14      LDA.W $1448,X             
CODE_05C64D:        18            CLC                       
CODE_05C64E:        79 C3 CB      ADC.W DATA_05CBC3,Y       
CODE_05C651:        9D 48 14      STA.W $1448,X             
CODE_05C654:        E8            INX                       
CODE_05C655:        E8            INX                       
CODE_05C656:        4C 28 C3      JMP.W CODE_05C328         

ADDR_05C659:        AD 41 14      LDA.W $1441               
ADDR_05C65C:        F0 16         BEQ ADDR_05C674           
ADDR_05C65E:        CE 41 14      DEC.W $1441               
ADDR_05C661:        C9 20 B0      CMP.W #$B020              
ADDR_05C664:        0E A5 14      ASL.W $14A5               
ADDR_05C667:        29 01 D0      AND.W #$D001              
ADDR_05C66A:        08            PHP                       
ADDR_05C66B:        AD 64 14      LDA.W $1464               
ADDR_05C66E:        49 01 8D      EOR.W #$8D01              
ADDR_05C671:        64 14         STZ RAM_FrameCounterB     
Return05C673:       60            RTS                       ; Return 

ADDR_05C674:        64 56         STZ $56                   
ADDR_05C676:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05C678:        AD 4C 14      LDA.W $144C               
ADDR_05C67B:        C9 C0 FF      CMP.W #$FFC0              
ADDR_05C67E:        F0 04         BEQ ADDR_05C684           
ADDR_05C680:        3A            DEC A                     
ADDR_05C681:        8D 4C 14      STA.W $144C               
ADDR_05C684:        AD 68 14      LDA.W $1468               
ADDR_05C687:        C9 31 00      CMP.W #$0031              
ADDR_05C68A:        10 03         BPL ADDR_05C68F           
ADDR_05C68C:        9C 4C 14      STZ.W $144C               
ADDR_05C68F:        D0 05         BNE ADDR_05C696           
ADDR_05C691:        A0 20         LDY.B #$20                
ADDR_05C693:        8C 41 14      STY.W $1441               
ADDR_05C696:        A2 06         LDX.B #$06                
ADDR_05C698:        20 F9 C4      JSR.W CODE_05C4F9         
ADDR_05C69B:        4C 2B C3      JMP.W CODE_05C32B         

ADDR_05C69E:        A9 02 85      LDA.W #$8502              
ADDR_05C6A1:        55 64         EOR $64,X                 
ADDR_05C6A3:        56 C2         LSR RAM_SpriteState,X     
ADDR_05C6A5:        20 AE 40      JSR.W $40AE               
ADDR_05C6A8:        14 D0         TRB $D0                   
ADDR_05C6AA:        22 AD 46 14   JSL.L $1446AD             
ADDR_05C6AE:        C9 80 00      CMP.W #$0080              
ADDR_05C6B1:        F0 01         BEQ ADDR_05C6B4           
ADDR_05C6B3:        1A            INC A                     
ADDR_05C6B4:        8D 46 14      STA.W $1446               
ADDR_05C6B7:        A4 5E         LDY $5E                   
ADDR_05C6B9:        88            DEY                       
ADDR_05C6BA:        CC 63 14      CPY.W $1463               
ADDR_05C6BD:        D0 2D         BNE ADDR_05C6EC           
ADDR_05C6BF:        EE 40 14      INC.W $1440               
ADDR_05C6C2:        9C 46 14      STZ.W $1446               
ADDR_05C6C5:        A9 F0 FC      LDA.W #$FCF0              
ADDR_05C6C8:        8D 97 1B      STA.W $1B97               
ADDR_05C6CB:        80 1F         BRA ADDR_05C6EC           

ADDR_05C6CD:        A0 16         LDY.B #$16                ; \ Unreachable 
ADDR_05C6CF:        8C 2C 21      STY.W $212C               ; Background and Object Enable
ADDR_05C6D2:        AD 4C 14      LDA.W $144C               
ADDR_05C6D5:        C9 80 FF      CMP.W #$FF80              
ADDR_05C6D8:        F0 01         BEQ ADDR_05C6DB           
ADDR_05C6DA:        3A            DEC A                     
ADDR_05C6DB:        8D 4C 14      STA.W $144C               
ADDR_05C6DE:        8D 48 14      STA.W $1448               
ADDR_05C6E1:        AD 68 14      LDA.W $1468               
ADDR_05C6E4:        D0 06         BNE ADDR_05C6EC           
ADDR_05C6E6:        9C 4C 14      STZ.W $144C               
ADDR_05C6E9:        9C 48 14      STZ.W $1448               
ADDR_05C6EC:        A2 06         LDX.B #$06                
ADDR_05C6EE:        20 F9 C4      JSR.W CODE_05C4F9         
ADDR_05C6F1:        CA            DEX                       
ADDR_05C6F2:        CA            DEX                       
ADDR_05C6F3:        10 F9         BPL ADDR_05C6EE           
ADDR_05C6F5:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_05C6F7:        AD 63 14      LDA.W $1463               
ADDR_05C6FA:        38            SEC                       
ADDR_05C6FB:        E5 5E         SBC $5E                   
ADDR_05C6FD:        1A            INC A                     
ADDR_05C6FE:        1A            INC A                     
ADDR_05C6FF:        EB            XBA                       
ADDR_05C700:        AD 62 14      LDA.W $1462               
ADDR_05C703:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_05C705:        A0 82         LDY.B #$82                
ADDR_05C707:        C9 00 00      CMP.W #$0000              
ADDR_05C70A:        10 05         BPL ADDR_05C711           
ADDR_05C70C:        A9 00 00      LDA.W #$0000              
ADDR_05C70F:        A0 02         LDY.B #$02                
ADDR_05C711:        8D 66 14      STA.W $1466               
ADDR_05C714:        85 1E         STA $1E                   
ADDR_05C716:        84 5B         STY RAM_IsVerticalLvl     
ADDR_05C718:        4C 2B C3      JMP.W CODE_05C32B         


DATA_05C71B:                      .db $20,$00,$C1,$00

DATA_05C71F:                      .db $C0,$FF,$40,$00

DATA_05C723:                      .db $FF,$FF,$01,$00

CODE_05C727:        AE AF 14      LDX.W RAM_OnOffStatus     ; Accum (8 bit) 
CODE_05C72A:        F0 02         BEQ CODE_05C72E           
CODE_05C72C:        A2 02         LDX.B #$02                
CODE_05C72E:        EC 43 14      CPX.W $1443               
CODE_05C731:        F0 17         BEQ CODE_05C74A           
CODE_05C733:        CE 45 14      DEC.W $1445               
CODE_05C736:        10 03         BPL CODE_05C73B           
CODE_05C738:        8E 43 14      STX.W $1443               
CODE_05C73B:        AD 68 14      LDA.W $1468               
CODE_05C73E:        49 01         EOR.B #$01                
CODE_05C740:        8D 68 14      STA.W $1468               
CODE_05C743:        9C 4C 14      STZ.W $144C               
CODE_05C746:        9C 4D 14      STZ.W $144D               
Return05C749:       60            RTS                       ; Return 

CODE_05C74A:        A9 10         LDA.B #$10                
CODE_05C74C:        8D 45 14      STA.W $1445               
CODE_05C74F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C751:        AD 68 14      LDA.W $1468               
CODE_05C754:        DD 1B C7      CMP.W DATA_05C71B,X       
CODE_05C757:        D0 17         BNE CODE_05C770           
CODE_05C759:        E0 00         CPX.B #$00                
CODE_05C75B:        D0 0C         BNE CODE_05C769           
ADDR_05C75D:        A9 09 00      LDA.W #$0009              
ADDR_05C760:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
ADDR_05C763:        A9 20 00      LDA.W #$0020              ; \ Set ground shake timer 
ADDR_05C766:        8D 87 18      STA.W RAM_ShakeGrndTimer  ; / 
CODE_05C769:        A2 00         LDX.B #$00                
CODE_05C76B:        8E AF 14      STX.W RAM_OnOffStatus     
CODE_05C76E:        80 14         BRA CODE_05C784           

CODE_05C770:        AD 4C 14      LDA.W $144C               ; Accum (8 bit) 
CODE_05C773:        DD 1F C7      CMP.W DATA_05C71F,X       
CODE_05C776:        F0 07         BEQ CODE_05C77F           
CODE_05C778:        18            CLC                       
CODE_05C779:        7D 23 C7      ADC.W DATA_05C723,X       
CODE_05C77C:        8D 4C 14      STA.W $144C               
CODE_05C77F:        A2 06         LDX.B #$06                
CODE_05C781:        20 F9 C4      JSR.W CODE_05C4F9         
CODE_05C784:        4C 2B C3      JMP.W CODE_05C32B         

CODE_05C787:        A9 02         LDA.B #$02                
CODE_05C789:        85 55         STA $55                   
CODE_05C78B:        85 56         STA $56                   
CODE_05C78D:        AD 56 14      LDA.W $1456               
CODE_05C790:        4A            LSR                       
CODE_05C791:        4A            LSR                       
CODE_05C792:        AA            TAX                       
CODE_05C793:        BC 40 14      LDY.W $1440,X             
CODE_05C796:        AE 56 14      LDX.W $1456               
CODE_05C799:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C79B:        BD 46 14      LDA.W $1446,X             
CODE_05C79E:        D9 01 C0      CMP.W DATA_05C001,Y       
CODE_05C7A1:        F0 01         BEQ CODE_05C7A4           
CODE_05C7A3:        1A            INC A                     
CODE_05C7A4:        9D 46 14      STA.W $1446,X             
CODE_05C7A7:        A5 5E         LDA $5E                   
CODE_05C7A9:        3A            DEC A                     
CODE_05C7AA:        EB            XBA                       
CODE_05C7AB:        29 00 FF      AND.W #$FF00              
CODE_05C7AE:        DD 62 14      CMP.W $1462,X             
CODE_05C7B1:        D0 03         BNE CODE_05C7B6           
CODE_05C7B3:        9E 46 14      STZ.W $1446,X             
CODE_05C7B6:        20 F9 C4      JSR.W CODE_05C4F9         
CODE_05C7B9:        4C 2B C3      JMP.W CODE_05C32B         

CODE_05C7BC:        AD 9A 1B      LDA.W $1B9A               ; Accum (8 bit) 
CODE_05C7BF:        F0 2C         BEQ CODE_05C7ED           
CODE_05C7C1:        A9 02         LDA.B #$02                
CODE_05C7C3:        85 56         STA $56                   
CODE_05C7C5:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C7C7:        AD 4A 14      LDA.W $144A               
CODE_05C7CA:        C9 00 04      CMP.W #$0400              
CODE_05C7CD:        F0 01         BEQ CODE_05C7D0           
CODE_05C7CF:        1A            INC A                     
CODE_05C7D0:        8D 4A 14      STA.W $144A               
CODE_05C7D3:        A2 04         LDX.B #$04                
CODE_05C7D5:        20 F9 C4      JSR.W CODE_05C4F9         
CODE_05C7D8:        AD BD 17      LDA.W $17BD               
CODE_05C7DB:        29 FF 00      AND.W #$00FF              
CODE_05C7DE:        C9 80 00      CMP.W #$0080              
CODE_05C7E1:        90 03         BCC CODE_05C7E6           
CODE_05C7E3:        09 00 FF      ORA.W #$FF00              
CODE_05C7E6:        18            CLC                       
CODE_05C7E7:        6D 66 14      ADC.W $1466               
CODE_05C7EA:        8D 66 14      STA.W $1466               
CODE_05C7ED:        4C 2B C3      JMP.W CODE_05C32B         


DATA_05C7F0:                      .db $00,$00,$F0,$02,$B0,$08,$00,$00
                                  .db $00,$00,$70,$03

DATA_05C7FC:                      .db $D0,$00,$50,$03,$30,$0A,$08,$00
                                  .db $40,$00,$80,$03

DATA_05C808:                      .db $00,$06,$08

DATA_05C80B:                      .db $03,$01,$02

DATA_05C80E:                      .db $C0,$00

DATA_05C810:                      .db $00,$00,$B0,$00

DATA_05C814:                      .db $80,$FF,$C0,$00

DATA_05C818:                      .db $FF,$FF,$01,$00

CODE_05C81C:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C81E:        64 00         STZ $00                   
CODE_05C820:        AC 45 14      LDY.W $1445               
CODE_05C823:        84 00         STY $00                   
CODE_05C825:        A0 00         LDY.B #$00                
CODE_05C827:        AE 44 14      LDX.W $1444               
CODE_05C82A:        E0 08         CPX.B #$08                
CODE_05C82C:        90 02         BCC CODE_05C830           
CODE_05C82E:        A0 02         LDY.B #$02                
CODE_05C830:        AD 66 14      LDA.W $1466               
CODE_05C833:        DD F0 C7      CMP.W DATA_05C7F0,X       
CODE_05C836:        90 14         BCC CODE_05C84C           
CODE_05C838:        DD FC C7      CMP.W DATA_05C7FC,X       
CODE_05C83B:        B0 0F         BCS CODE_05C84C           
CODE_05C83D:        9C 42 14      STZ.W $1442               
CODE_05C840:        B9 0E C8      LDA.W DATA_05C80E,Y       
CODE_05C843:        8D 68 14      STA.W $1468               
CODE_05C846:        9C 4C 14      STZ.W $144C               
CODE_05C849:        9C 54 14      STZ.W $1454               
CODE_05C84C:        E8            INX                       
CODE_05C84D:        E8            INX                       
CODE_05C84E:        C6 00         DEC $00                   
CODE_05C850:        D0 DE         BNE CODE_05C830           
CODE_05C852:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05C854:        AD 42 14      LDA.W $1442               
CODE_05C857:        0D 0E 14      ORA.W $140E               
CODE_05C85A:        8D 42 14      STA.W $1442               
CODE_05C85D:        F0 1E         BEQ CODE_05C87D           
CODE_05C85F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C861:        AD 68 14      LDA.W $1468               
CODE_05C864:        D9 10 C8      CMP.W DATA_05C810,Y       
CODE_05C867:        F0 14         BEQ CODE_05C87D           
CODE_05C869:        AD 4C 14      LDA.W $144C               
CODE_05C86C:        D9 14 C8      CMP.W DATA_05C814,Y       
CODE_05C86F:        F0 04         BEQ CODE_05C875           
CODE_05C871:        18            CLC                       
CODE_05C872:        79 18 C8      ADC.W DATA_05C818,Y       
CODE_05C875:        8D 4C 14      STA.W $144C               
CODE_05C878:        A2 06         LDX.B #$06                
CODE_05C87A:        20 F9 C4      JSR.W CODE_05C4F9         
CODE_05C87D:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return05C87F:       60            RTS                       ; Return 


DATA_05C880:                      .db $00,$00,$C0,$01,$00,$03,$00,$08
                                  .db $38,$08,$00,$0A,$00,$00,$80,$03
                                  .db $50,$04,$90,$08,$60,$09,$80,$0E
                                  .db $00,$40,$00,$40,$00,$40,$00,$40
                                  .db $00,$40,$00,$00

DATA_05C8A4:                      .db $08,$00,$00,$03,$10,$04,$38,$08
                                  .db $70,$08,$00,$0B,$08,$00,$50,$04
                                  .db $A0,$04,$60,$09,$40,$0A,$FF,$0F
                                  .db $00,$50,$00,$50,$00,$50,$00,$50
                                  .db $00,$50,$80,$00

DATA_05C8C8:                      .db $C0,$00,$B0,$00,$70,$00,$C0,$00
                                  .db $C0,$00,$C0,$00,$00,$00,$00,$00
                                  .db $C0,$00,$B0,$00,$A0,$00,$70,$00
                                  .db $B0,$00,$B0,$00,$B0,$00,$00,$00
                                  .db $00,$00,$B0,$00,$20,$00,$20,$00
                                  .db $20,$00,$10,$00,$10,$00,$10,$00
                                  .db $00,$00,$00,$00,$10,$00

DATA_05C8FE:                      .db $00,$01,$00,$01,$00,$08,$00,$01
                                  .db $00,$01,$00,$08,$00,$00,$00,$00
                                  .db $80,$01,$00,$FF,$00,$FF,$00,$00
                                  .db $00,$FF,$00,$FF,$00,$FF,$00,$FF
                                  .db $00,$FF,$00,$FF,$00,$F8,$00,$F8
                                  .db $00,$F8,$00,$F8,$00,$F8,$00,$F8
                                  .db $00,$00,$00,$00,$40,$FE

DATA_05C934:                      .db $80,$40,$01,$80,$00,$00,$80,$00
                                  .db $40,$00,$00,$20,$40,$00,$20,$00
                                  .db $00,$20,$80,$80,$20,$80,$80,$20
                                  .db $00,$00,$A0

DATA_05C94F:                      .db $00,$0C,$18

DATA_05C952:                      .db $05,$05,$05

CODE_05C955:        AE 40 14      LDX.W $1440               
CODE_05C958:        AC 41 14      LDY.W $1441               
CODE_05C95B:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C95D:        AD 66 14      LDA.W $1466               
CODE_05C960:        DD 80 C8      CMP.W DATA_05C880,X       
CODE_05C963:        90 16         BCC CODE_05C97B           
CODE_05C965:        DD A4 C8      CMP.W DATA_05C8A4,X       
CODE_05C968:        B0 11         BCS CODE_05C97B           
CODE_05C96A:        8A            TXA                       
CODE_05C96B:        4A            LSR                       
CODE_05C96C:        29 FE 00      AND.W #$00FE              
CODE_05C96F:        8D 42 14      STA.W $1442               
CODE_05C972:        A9 C1 00      LDA.W #$00C1              
CODE_05C975:        8D 68 14      STA.W $1468               
CODE_05C978:        9C 44 14      STZ.W $1444               
CODE_05C97B:        E8            INX                       
CODE_05C97C:        E8            INX                       
CODE_05C97D:        88            DEY                       
CODE_05C97E:        D0 DD         BNE CODE_05C95D           
CODE_05C980:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05C982:        AD 44 14      LDA.W $1444               
CODE_05C985:        F0 04         BEQ CODE_05C98B           
CODE_05C987:        CE 44 14      DEC.W $1444               
Return05C98A:       60            RTS                       ; Return 

CODE_05C98B:        AD 42 14      LDA.W $1442               
CODE_05C98E:        18            CLC                       
CODE_05C98F:        6D 43 14      ADC.W $1443               
CODE_05C992:        A8            TAY                       
CODE_05C993:        4A            LSR                       
CODE_05C994:        AA            TAX                       
CODE_05C995:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05C997:        AD 68 14      LDA.W $1468               
CODE_05C99A:        38            SEC                       
CODE_05C99B:        F9 C8 C8      SBC.W DATA_05C8C8,Y       
CODE_05C99E:        59 FE C8      EOR.W DATA_05C8FE,Y       
CODE_05C9A1:        10 06         BPL CODE_05C9A9           
CODE_05C9A3:        B9 FE C8      LDA.W DATA_05C8FE,Y       
CODE_05C9A6:        4C 75 C8      JMP.W CODE_05C875         

CODE_05C9A9:        B9 C8 C8      LDA.W DATA_05C8C8,Y       
CODE_05C9AC:        8D 68 14      STA.W $1468               
CODE_05C9AF:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05C9B1:        BD 34 C9      LDA.W DATA_05C934,X       
CODE_05C9B4:        8D 44 14      STA.W $1444               
CODE_05C9B7:        AD 43 14      LDA.W $1443               
CODE_05C9BA:        18            CLC                       
CODE_05C9BB:        69 12         ADC.B #$12                
CODE_05C9BD:        C9 36         CMP.B #$36                
CODE_05C9BF:        90 0C         BCC CODE_05C9CD           
CODE_05C9C1:        A9 09         LDA.B #$09                
CODE_05C9C3:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_05C9C6:        A9 20         LDA.B #$20                ; \ Set ground shake timer 
CODE_05C9C8:        8D 87 18      STA.W RAM_ShakeGrndTimer  ; / 
CODE_05C9CB:        A9 00         LDA.B #$00                
CODE_05C9CD:        8D 43 14      STA.W $1443               
Return05C9D0:       60            RTS                       ; Return 


DATA_05C9D1:                      .db $01,$01,$01,$00,$01,$01,$01,$00
                                  .db $01,$09

DATA_05C9DB:                      .db $01,$00,$02,$00,$04,$03,$05,$00
                                  .db $06,$00

DATA_05C9E5:                      .db $00,$01

DATA_05C9E7:                      .db $00,$00

DATA_05C9E9:                      .db $00,$00,$02,$02,$02,$00,$02,$05
                                  .db $02,$02,$05,$00,$00,$02,$01,$00
                                  .db $03,$02,$03,$04,$03,$01,$00,$01
                                  .db $00,$00,$03,$00,$00,$00,$00

DATA_05CA08:                      .db $00,$04,$00,$04

DATA_05CA0C:                      .db $00,$00,$00,$01

DATA_05CA10:                      .db $00,$01

DATA_05CA12:                      .db $40,$01,$E0,$00

DATA_05CA16:                      .db $05,$00,$00,$05,$05,$02,$02,$05
DATA_05CA1E:                      .db $00,$00,$00,$01,$02,$03,$04,$03
DATA_05CA26:                      .db $01,$00,$01,$01,$00,$06,$00,$06
                                  .db $00,$00,$00,$01,$00,$01,$08,$00
                                  .db $00,$08,$00,$00,$00,$01,$01,$00
DATA_05CA3E:                      .db $00,$08,$00,$08

DATA_05CA42:                      .db $00,$00,$00,$01

DATA_05CA46:                      .db $01,$01

DATA_05CA48:                      .db $00,$03,$00,$03,$00,$03,$00,$03
                                  .db $00,$03

DATA_05CA52:                      .db $00,$00,$00,$01,$00,$02,$00,$03
                                  .db $00,$04

DATA_05CA5C:                      .db $01,$00,$00,$00,$00

DATA_05CA61:                      .db $01,$18,$1E,$29,$2D,$35,$47

DATA_05CA68:                      .db $16,$05,$0A,$03,$07,$11

DATA_05CA6E:                      .db $09

DATA_05CA6F:                      .db $00,$09,$14,$1C,$24,$28,$33,$3C
                                  .db $43,$4B,$54,$60,$67,$74,$77,$7B
                                  .db $83,$8A,$8D,$90,$99,$A0,$B0,$00
                                  .db $09,$14,$2C,$3C,$B0,$00,$09,$11
                                  .db $1D,$2C,$32,$41,$48,$63,$6B,$70
                                  .db $00,$27,$37,$70,$00,$07,$12,$27
                                  .db $32,$48,$5B,$70,$00,$20,$28,$3A
                                  .db $40,$5F,$66,$6B,$6B,$80,$80,$89
                                  .db $92,$96,$9A,$9E,$A0,$B0,$00,$10
                                  .db $1A,$20,$2B,$30,$3B,$40,$4B

DATA_05CABE:                      .db $50

DATA_05CABF:                      .db $0C,$0C,$06,$0B,$08,$0C,$03,$02
                                  .db $09,$03,$09,$02,$06,$06,$07,$05
                                  .db $08,$05,$0A,$04,$08,$04,$04,$0C
                                  .db $0C,$07,$07,$05,$05,$0C,$0C,$08
                                  .db $0C,$0C,$07,$07,$0A,$0A,$0C,$0C
                                  .db $00,$00,$0A,$0A,$00,$00,$09,$09
                                  .db $03,$03,$0C,$0C,$0C,$0C,$08,$08
                                  .db $05,$05,$02,$02,$09,$09,$01,$01
                                  .db $01,$02,$03,$07,$08,$08,$0C,$0C
                                  .db $02,$02,$0A,$0A,$02,$02,$0A,$0A
DATA_05CB0F:                      .db $07,$07,$07,$07,$07,$07,$07,$07
                                  .db $07,$07,$07,$07,$07,$07,$07,$07
                                  .db $07,$07,$07,$07,$07,$07,$07,$07
                                  .db $07,$07,$07,$07,$07,$07,$07,$07
                                  .db $07,$07,$07,$07,$07,$07,$07,$07
                                  .db $07,$07,$07,$07,$07,$07,$07,$07
                                  .db $07,$07,$07,$07,$08,$08,$08,$08
                                  .db $08,$08,$10,$08,$40,$08,$04,$08
                                  .db $10,$08,$08,$10,$10,$08,$08,$08
                                  .db $08,$08,$08,$08,$08,$08,$08,$08
DATA_05CB5F:                      .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
                                  .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
                                  .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
                                  .db $01,$00,$FF,$FF

DATA_05CB7B:                      .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
                                  .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
                                  .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
                                  .db $01,$00,$FF,$FF,$04,$00,$FC,$FF
DATA_05CB9B:                      .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
DATA_05CBA3:                      .db $04,$00,$FC,$FF,$04,$00,$FC,$FF
                                  .db $04,$00,$FC,$FF,$04,$00,$FC,$FF
                                  .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
DATA_05CBBB:                      .db $04,$00,$FC,$FF,$04,$00,$FC,$FF
DATA_05CBC3:                      .db $01,$00,$FF,$FF

DATA_05CBC7:                      .db $30

DATA_05CBC8:                      .db $70,$80,$10,$28,$30,$30,$30,$30
                                  .db $14,$02,$30,$30,$30,$30,$70,$80
                                  .db $70,$80,$70,$80,$70,$80,$70,$80
                                  .db $70,$80,$18

DATA_05CBE3:                      .db $18,$18

DATA_05CBE5:                      .db $18,$18,$08,$20,$06,$06

DATA_05CBEB:                      .db $04,$04

DATA_05CBED:                      .db $60

DATA_05CBEE:                      .db $42,$D0,$B2

DATA_05CBF1:                      .db $80,$80,$80,$80

DATA_05CBF5:                      .db $90

DATA_05CBF6:                      .db $72,$60,$42,$20,$10,$40,$22,$20
                                  .db $10

CODE_05CBFF:        8B            PHB                       
CODE_05CC00:        4B            PHK                       ; Wrapper 
CODE_05CC01:        AB            PLB                       
CODE_05CC02:        20 07 CC      JSR.W CODE_05CC07         
CODE_05CC05:        AB            PLB                       
Return05CC06:       6B            RTL                       ; Return 

CODE_05CC07:        AD D9 13      LDA.W $13D9               
CODE_05CC0A:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs05CC0E:            66 CC      .dw CODE_05CC66           
                       76 CD      .dw CODE_05CD76           
                       CA CE      .dw CODE_05CECA           
                       E9 CF      .dw Return05CFE9          

DATA_05CC16:                      .db $51,$0D,$00,$09,$30,$28,$31,$28
                                  .db $32,$28,$33,$28,$34,$28,$51,$49
                                  .db $00,$19,$0C,$38,$18,$38,$1E,$38
                                  .db $1B,$38,$1C,$38,$0E,$38,$FC,$38
                                  .db $0C,$38,$15,$38,$0E,$38,$0A,$38
                                  .db $1B,$38,$28,$38,$51,$A9,$00,$19
                                  .db $76,$38,$FC,$38,$FC,$38,$FC,$38
                                  .db $26,$38,$05,$38,$00,$38,$77,$38
                                  .db $FC,$38,$FC,$38,$FC,$38,$FC,$38
                                  .db $FC,$38,$FF

DATA_05CC61:                      .db $40,$41,$42,$43,$44

CODE_05CC66:        A0 00         LDY.B #$00                
CODE_05CC68:        AE B3 0D      LDX.W $0DB3               
CODE_05CC6B:        BD 48 0F      LDA.W $0F48,X             
CODE_05CC6E:        C9 0A         CMP.B #$0A                
CODE_05CC70:        90 05         BCC CODE_05CC77           
CODE_05CC72:        E9 0A         SBC.B #$0A                
CODE_05CC74:        C8            INY                       
CODE_05CC75:        80 F7         BRA CODE_05CC6E           

CODE_05CC77:        CC 32 0F      CPY.W $0F32               
CODE_05CC7A:        D0 08         BNE CODE_05CC84           
CODE_05CC7C:        CC 33 0F      CPY.W $0F33               
CODE_05CC7F:        D0 03         BNE CODE_05CC84           
ADDR_05CC81:        EE E4 18      INC.W $18E4               
CODE_05CC84:        A9 01         LDA.B #$01                
CODE_05CC86:        8D D5 13      STA.W $13D5               
CODE_05CC89:        A9 08         LDA.B #$08                
CODE_05CC8B:        04 3E         TSB $3E                   
CODE_05CC8D:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_05CC8F:        64 22         STZ $22                   
CODE_05CC91:        64 24         STZ $24                   
CODE_05CC93:        A0 4A 00      LDY.W #$004A              
CODE_05CC96:        98            TYA                       
CODE_05CC97:        18            CLC                       
CODE_05CC98:        6F 7B 83 7F   ADC.L $7F837B             
CODE_05CC9C:        AA            TAX                       
CODE_05CC9D:        B9 16 CC      LDA.W DATA_05CC16,Y       
CODE_05CCA0:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_05CCA4:        CA            DEX                       
CODE_05CCA5:        CA            DEX                       
CODE_05CCA6:        88            DEY                       
CODE_05CCA7:        88            DEY                       
CODE_05CCA8:        10 F3         BPL CODE_05CC9D           
CODE_05CCAA:        AF 7B 83 7F   LDA.L $7F837B             
CODE_05CCAE:        AA            TAX                       
CODE_05CCAF:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05CCB1:        AD B3 0D      LDA.W $0DB3               
CODE_05CCB4:        F0 12         BEQ CODE_05CCC8           
CODE_05CCB6:        A0 00 00      LDY.W #$0000              
CODE_05CCB9:        B9 61 CC      LDA.W DATA_05CC61,Y       
CODE_05CCBC:        9F 81 83 7F   STA.L $7F8381,X           
CODE_05CCC0:        E8            INX                       
CODE_05CCC1:        E8            INX                       
CODE_05CCC2:        C8            INY                       
CODE_05CCC3:        C0 05 00      CPY.W #$0005              
CODE_05CCC6:        D0 F1         BNE CODE_05CCB9           
CODE_05CCC8:        A0 02 00      LDY.W #$0002              
CODE_05CCCB:        A9 04         LDA.B #$04                
CODE_05CCCD:        18            CLC                       
CODE_05CCCE:        6F 7B 83 7F   ADC.L $7F837B             
CODE_05CCD2:        AA            TAX                       
CODE_05CCD3:        B9 31 0F      LDA.W $0F31,Y             
CODE_05CCD6:        9F AF 83 7F   STA.L $7F83AF,X           
CODE_05CCDA:        88            DEY                       
CODE_05CCDB:        CA            DEX                       
CODE_05CCDC:        CA            DEX                       
CODE_05CCDD:        10 F4         BPL CODE_05CCD3           
CODE_05CCDF:        AF 7B 83 7F   LDA.L $7F837B             
CODE_05CCE3:        AA            TAX                       
CODE_05CCE4:        BF AF 83 7F   LDA.L $7F83AF,X           
CODE_05CCE8:        29 0F         AND.B #$0F                
CODE_05CCEA:        D0 0D         BNE CODE_05CCF9           
CODE_05CCEC:        A9 FC         LDA.B #$FC                
CODE_05CCEE:        9F AF 83 7F   STA.L $7F83AF,X           
CODE_05CCF2:        E8            INX                       
CODE_05CCF3:        E8            INX                       
CODE_05CCF4:        E0 04 00      CPX.W #$0004              
CODE_05CCF7:        D0 EB         BNE CODE_05CCE4           
CODE_05CCF9:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_05CCFB:        20 4C CE      JSR.W CODE_05CE4C         
CODE_05CCFE:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05CD00:        64 00         STZ $00                   
CODE_05CD02:        A5 02         LDA $02                   
CODE_05CD04:        8D 40 0F      STA.W $0F40               
CODE_05CD07:        A2 42         LDX.B #$42                
CODE_05CD09:        A0 00         LDY.B #$00                
CODE_05CD0B:        20 FD CD      JSR.W CODE_05CDFD         
CODE_05CD0E:        A2 00         LDX.B #$00                
CODE_05CD10:        BF BD 83 7F   LDA.L $7F83BD,X           
CODE_05CD14:        29 0F 00      AND.W #$000F              
CODE_05CD17:        D0 0D         BNE CODE_05CD26           
CODE_05CD19:        A9 FC 38      LDA.W #$38FC              
CODE_05CD1C:        9F BD 83 7F   STA.L $7F83BD,X           
CODE_05CD20:        E8            INX                       
CODE_05CD21:        E8            INX                       
CODE_05CD22:        E0 08         CPX.B #$08                
CODE_05CD24:        D0 EA         BNE CODE_05CD10           
CODE_05CD26:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05CD28:        EE D9 13      INC.W $13D9               
CODE_05CD2B:        A9 28         LDA.B #$28                
CODE_05CD2D:        8D 24 14      STA.W $1424               
CODE_05CD30:        A9 4A         LDA.B #$4A                
CODE_05CD32:        18            CLC                       
CODE_05CD33:        6F 7B 83 7F   ADC.L $7F837B             
CODE_05CD37:        1A            INC A                     
CODE_05CD38:        8F 7B 83 7F   STA.L $7F837B             
CODE_05CD3C:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return05CD3E:       60            RTS                       ; Return 


DATA_05CD3F:                      .db $52,$0A,$00,$15,$0B,$38,$18,$38
                                  .db $17,$38,$1E,$38,$1C,$38,$28,$38
                                  .db $FC,$38,$64,$28,$26,$38,$FC,$38
                                  .db $FC,$38,$51,$F3,$00,$03,$FC,$38
                                  .db $FC,$38,$FF

DATA_05CD62:                      .db $B7

DATA_05CD63:                      .db $C3,$B8,$B9,$BA,$BB,$BA,$BF,$BC
                                  .db $BD,$BE,$BF,$C0,$C3,$C1,$B9,$C2
                                  .db $C4,$B7,$C5

CODE_05CD76:        AD 00 19      LDA.W $1900               
CODE_05CD79:        F0 5A         BEQ CODE_05CDD5           
CODE_05CD7B:        CE 24 14      DEC.W $1424               
CODE_05CD7E:        10 68         BPL Return05CDE8          
CODE_05CD80:        A0 22         LDY.B #$22                
CODE_05CD82:        98            TYA                       
CODE_05CD83:        18            CLC                       
CODE_05CD84:        6F 7B 83 7F   ADC.L $7F837B             
CODE_05CD88:        AA            TAX                       
CODE_05CD89:        B9 3F CD      LDA.W DATA_05CD3F,Y       
CODE_05CD8C:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_05CD90:        CA            DEX                       
CODE_05CD91:        88            DEY                       
CODE_05CD92:        10 F5         BPL CODE_05CD89           
CODE_05CD94:        AF 7B 83 7F   LDA.L $7F837B             
CODE_05CD98:        AA            TAX                       
CODE_05CD99:        AD 00 19      LDA.W $1900               
CODE_05CD9C:        29 0F         AND.B #$0F                
CODE_05CD9E:        0A            ASL                       
CODE_05CD9F:        A8            TAY                       
CODE_05CDA0:        B9 63 CD      LDA.W DATA_05CD63,Y       
CODE_05CDA3:        9F 95 83 7F   STA.L $7F8395,X           
CODE_05CDA7:        B9 62 CD      LDA.W DATA_05CD62,Y       
CODE_05CDAA:        9F 9D 83 7F   STA.L $7F839D,X           
CODE_05CDAE:        AD 00 19      LDA.W $1900               
CODE_05CDB1:        29 F0         AND.B #$F0                
CODE_05CDB3:        4A            LSR                       
CODE_05CDB4:        4A            LSR                       
CODE_05CDB5:        4A            LSR                       
CODE_05CDB6:        4A            LSR                       
CODE_05CDB7:        F0 10         BEQ CODE_05CDC9           
CODE_05CDB9:        0A            ASL                       
CODE_05CDBA:        A8            TAY                       
CODE_05CDBB:        B9 63 CD      LDA.W DATA_05CD63,Y       
CODE_05CDBE:        9F 93 83 7F   STA.L $7F8393,X           
CODE_05CDC2:        B9 62 CD      LDA.W DATA_05CD62,Y       
CODE_05CDC5:        9F 9B 83 7F   STA.L $7F839B,X           
CODE_05CDC9:        A9 22         LDA.B #$22                
CODE_05CDCB:        18            CLC                       
CODE_05CDCC:        6F 7B 83 7F   ADC.L $7F837B             
CODE_05CDD0:        1A            INC A                     
CODE_05CDD1:        8F 7B 83 7F   STA.L $7F837B             
CODE_05CDD5:        CE D6 13      DEC.W $13D6               
CODE_05CDD8:        10 0E         BPL Return05CDE8          
CODE_05CDDA:        AD 00 19      LDA.W $1900               
CODE_05CDDD:        8D 24 14      STA.W $1424               
CODE_05CDE0:        EE D9 13      INC.W $13D9               
CODE_05CDE3:        A9 11         LDA.B #$11                
CODE_05CDE5:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
Return05CDE8:       60            RTS                       ; Return 


DATA_05CDE9:                      .db $00,$00

DATA_05CDEB:                      .db $10,$27,$00,$00,$E8,$03,$00,$00
                                  .db $64,$00,$00,$00,$0A,$00,$00,$00
                                  .db $01,$00

CODE_05CDFD:        BF 7B 83 7F   LDA.L $7F837B,X           ; Accum (16 bit) 
CODE_05CE01:        29 00 FF      AND.W #$FF00              
CODE_05CE04:        9F 7B 83 7F   STA.L $7F837B,X           
CODE_05CE08:        DA            PHX                       
CODE_05CE09:        BB            TYX                       
CODE_05CE0A:        A5 02         LDA $02                   
CODE_05CE0C:        38            SEC                       
CODE_05CE0D:        FD EB CD      SBC.W DATA_05CDEB,X       
CODE_05CE10:        85 06         STA $06                   
CODE_05CE12:        A5 00         LDA $00                   
CODE_05CE14:        FD E9 CD      SBC.W DATA_05CDE9,X       
CODE_05CE17:        85 04         STA $04                   
CODE_05CE19:        FA            PLX                       
CODE_05CE1A:        90 13         BCC CODE_05CE2F           
CODE_05CE1C:        A5 06         LDA $06                   
CODE_05CE1E:        85 02         STA $02                   
CODE_05CE20:        A5 04         LDA $04                   
CODE_05CE22:        85 00         STA $00                   
CODE_05CE24:        BF 7B 83 7F   LDA.L $7F837B,X           
CODE_05CE28:        1A            INC A                     
CODE_05CE29:        9F 7B 83 7F   STA.L $7F837B,X           
CODE_05CE2D:        80 D9         BRA CODE_05CE08           

CODE_05CE2F:        E8            INX                       
CODE_05CE30:        E8            INX                       
CODE_05CE31:        C8            INY                       
CODE_05CE32:        C8            INY                       
CODE_05CE33:        C8            INY                       
CODE_05CE34:        C8            INY                       
CODE_05CE35:        C0 14         CPY.B #$14                
CODE_05CE37:        D0 C4         BNE CODE_05CDFD           
Return05CE39:       60            RTS                       ; Return 


DATA_05CE3A:                      .db $00,$00,$64,$00,$C8,$00,$2C,$01
DATA_05CE42:                      .db $00,$0A,$14,$1E,$28,$32,$3C,$46
                                  .db $50,$5A

CODE_05CE4C:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05CE4E:        AD 31 0F      LDA.W $0F31               
CODE_05CE51:        0A            ASL                       
CODE_05CE52:        AA            TAX                       
CODE_05CE53:        BD 3A CE      LDA.W DATA_05CE3A,X       
CODE_05CE56:        85 00         STA $00                   
CODE_05CE58:        AD 32 0F      LDA.W $0F32               
CODE_05CE5B:        AA            TAX                       
CODE_05CE5C:        BD 42 CE      LDA.W DATA_05CE42,X       
CODE_05CE5F:        29 FF 00      AND.W #$00FF              
CODE_05CE62:        18            CLC                       
CODE_05CE63:        65 00         ADC $00                   
CODE_05CE65:        85 00         STA $00                   
CODE_05CE67:        AD 33 0F      LDA.W $0F33               
CODE_05CE6A:        29 FF 00      AND.W #$00FF              
CODE_05CE6D:        18            CLC                       
CODE_05CE6E:        65 00         ADC $00                   
CODE_05CE70:        85 00         STA $00                   
CODE_05CE72:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05CE74:        A5 00         LDA $00                   
CODE_05CE76:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_05CE79:        A9 32         LDA.B #$32                
CODE_05CE7B:        8D 03 42      STA.W $4203               ; Multplier B
CODE_05CE7E:        EA            NOP                       
CODE_05CE7F:        EA            NOP                       
CODE_05CE80:        EA            NOP                       
CODE_05CE81:        EA            NOP                       
CODE_05CE82:        AD 16 42      LDA.W $4216               ; Product/Remainder Result (Low Byte)
CODE_05CE85:        85 02         STA $02                   
CODE_05CE87:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_05CE8A:        85 03         STA $03                   
CODE_05CE8C:        A5 01         LDA $01                   
CODE_05CE8E:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_05CE91:        A9 32         LDA.B #$32                
CODE_05CE93:        8D 03 42      STA.W $4203               ; Multplier B
CODE_05CE96:        EA            NOP                       
CODE_05CE97:        EA            NOP                       
CODE_05CE98:        EA            NOP                       
CODE_05CE99:        EA            NOP                       
CODE_05CE9A:        AD 16 42      LDA.W $4216               ; Product/Remainder Result (Low Byte)
CODE_05CE9D:        18            CLC                       
CODE_05CE9E:        65 03         ADC $03                   
CODE_05CEA0:        85 03         STA $03                   
Return05CEA2:       60            RTS                       ; Return 


DATA_05CEA3:                      .db $51,$B1,$00,$09,$FC,$38,$FC,$38
                                  .db $FC,$38,$FC,$38,$00,$38,$51,$F3
                                  .db $00,$03,$FC,$38,$FC,$38,$52,$13
                                  .db $00,$03,$FC,$38,$FC,$38,$FF

DATA_05CEC2:                      .db $0A,$00,$64,$00

DATA_05CEC6:                      .db $01,$00,$0A,$00

CODE_05CECA:        8B            PHB                       
CODE_05CECB:        4B            PHK                       
CODE_05CECC:        AB            PLB                       
CODE_05CECD:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05CECF:        A2 00         LDX.B #$00                
CODE_05CED1:        AD B3 0D      LDA.W $0DB3               
CODE_05CED4:        29 FF 00      AND.W #$00FF              
CODE_05CED7:        F0 02         BEQ CODE_05CEDB           
CODE_05CED9:        A2 03         LDX.B #$03                
CODE_05CEDB:        A0 02         LDY.B #$02                
CODE_05CEDD:        AD 40 0F      LDA.W $0F40               
CODE_05CEE0:        F0 23         BEQ CODE_05CF05           
CODE_05CEE2:        C9 63 00      CMP.W #$0063              
CODE_05CEE5:        B0 02         BCS CODE_05CEE9           
CODE_05CEE7:        A0 00         LDY.B #$00                
CODE_05CEE9:        38            SEC                       
CODE_05CEEA:        F9 C2 CE      SBC.W DATA_05CEC2,Y       
CODE_05CEED:        8D 40 0F      STA.W $0F40               
CODE_05CEF0:        85 02         STA $02                   
CODE_05CEF2:        B9 C6 CE      LDA.W DATA_05CEC6,Y       
CODE_05CEF5:        18            CLC                       
CODE_05CEF6:        7D 34 0F      ADC.W $0F34,X             
CODE_05CEF9:        9D 34 0F      STA.W $0F34,X             
CODE_05CEFC:        BD 36 0F      LDA.W $0F36,X             
CODE_05CEFF:        69 00 00      ADC.W #$0000              
CODE_05CF02:        9D 36 0F      STA.W $0F36,X             
CODE_05CF05:        AE 00 19      LDX.W $1900               
CODE_05CF08:        F0 2C         BEQ CODE_05CF36           
CODE_05CF0A:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05CF0C:        A5 13         LDA RAM_FrameCounter      
CODE_05CF0E:        29 03         AND.B #$03                
CODE_05CF10:        D0 22         BNE CODE_05CF34           
CODE_05CF12:        AE B3 0D      LDX.W $0DB3               
CODE_05CF15:        BD 48 0F      LDA.W $0F48,X             
CODE_05CF18:        18            CLC                       
CODE_05CF19:        69 01         ADC.B #$01                
CODE_05CF1B:        9D 48 0F      STA.W $0F48,X             
CODE_05CF1E:        AD 00 19      LDA.W $1900               
CODE_05CF21:        3A            DEC A                     
CODE_05CF22:        8D 00 19      STA.W $1900               
CODE_05CF25:        29 0F         AND.B #$0F                
CODE_05CF27:        C9 0F         CMP.B #$0F                
CODE_05CF29:        D0 09         BNE CODE_05CF34           
CODE_05CF2B:        AD 00 19      LDA.W $1900               
CODE_05CF2E:        38            SEC                       
CODE_05CF2F:        E9 06         SBC.B #$06                
CODE_05CF31:        8D 00 19      STA.W $1900               
CODE_05CF34:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05CF36:        AD 40 0F      LDA.W $0F40               
CODE_05CF39:        D0 12         BNE CODE_05CF4D           
CODE_05CF3B:        AE 00 19      LDX.W $1900               
CODE_05CF3E:        D0 0D         BNE CODE_05CF4D           
CODE_05CF40:        A2 30         LDX.B #$30                
CODE_05CF42:        8E D6 13      STX.W $13D6               
CODE_05CF45:        EE D9 13      INC.W $13D9               
CODE_05CF48:        A2 12         LDX.B #$12                
CODE_05CF4A:        8E FC 1D      STX.W $1DFC               ; / Play sound effect 
CODE_05CF4D:        A0 1E         LDY.B #$1E                
CODE_05CF4F:        98            TYA                       
CODE_05CF50:        18            CLC                       
CODE_05CF51:        6F 7B 83 7F   ADC.L $7F837B             
CODE_05CF55:        AA            TAX                       
CODE_05CF56:        1A            INC A                     
CODE_05CF57:        85 0A         STA $0A                   
CODE_05CF59:        B9 A3 CE      LDA.W DATA_05CEA3,Y       
CODE_05CF5C:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_05CF60:        CA            DEX                       
CODE_05CF61:        CA            DEX                       
CODE_05CF62:        88            DEY                       
CODE_05CF63:        88            DEY                       
CODE_05CF64:        10 F3         BPL CODE_05CF59           
CODE_05CF66:        AD 40 0F      LDA.W $0F40               
CODE_05CF69:        F0 35         BEQ CODE_05CFA0           
CODE_05CF6B:        64 00         STZ $00                   
CODE_05CF6D:        AF 7B 83 7F   LDA.L $7F837B             
CODE_05CF71:        18            CLC                       
CODE_05CF72:        69 06 00      ADC.W #$0006              
CODE_05CF75:        AA            TAX                       
CODE_05CF76:        A0 00         LDY.B #$00                
CODE_05CF78:        20 FD CD      JSR.W CODE_05CDFD         
CODE_05CF7B:        AF 7B 83 7F   LDA.L $7F837B             
CODE_05CF7F:        18            CLC                       
CODE_05CF80:        69 08 00      ADC.W #$0008              
CODE_05CF83:        85 00         STA $00                   
CODE_05CF85:        AF 7B 83 7F   LDA.L $7F837B             
CODE_05CF89:        AA            TAX                       
CODE_05CF8A:        BF 81 83 7F   LDA.L $7F8381,X           
CODE_05CF8E:        29 0F 00      AND.W #$000F              
CODE_05CF91:        D0 0D         BNE CODE_05CFA0           
CODE_05CF93:        A9 FC 38      LDA.W #$38FC              
CODE_05CF96:        9F 81 83 7F   STA.L $7F8381,X           
CODE_05CF9A:        E8            INX                       
CODE_05CF9B:        E8            INX                       
CODE_05CF9C:        E4 00         CPX $00                   
CODE_05CF9E:        D0 EA         BNE CODE_05CF8A           
CODE_05CFA0:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05CFA2:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_05CFA4:        AD 24 14      LDA.W $1424               
CODE_05CFA7:        F0 33         BEQ CODE_05CFDC           
CODE_05CFA9:        AF 7B 83 7F   LDA.L $7F837B             
CODE_05CFAD:        AA            TAX                       
CODE_05CFAE:        AD 00 19      LDA.W $1900               
CODE_05CFB1:        29 0F         AND.B #$0F                
CODE_05CFB3:        0A            ASL                       
CODE_05CFB4:        A8            TAY                       
CODE_05CFB5:        B9 62 CD      LDA.W DATA_05CD62,Y       
CODE_05CFB8:        9F 91 83 7F   STA.L $7F8391,X           
CODE_05CFBC:        B9 63 CD      LDA.W DATA_05CD63,Y       
CODE_05CFBF:        9F 99 83 7F   STA.L $7F8399,X           
CODE_05CFC3:        AD 00 19      LDA.W $1900               
CODE_05CFC6:        29 F0         AND.B #$F0                
CODE_05CFC8:        4A            LSR                       
CODE_05CFC9:        4A            LSR                       
CODE_05CFCA:        4A            LSR                       
CODE_05CFCB:        F0 0F         BEQ CODE_05CFDC           
CODE_05CFCD:        A8            TAY                       
CODE_05CFCE:        B9 62 CD      LDA.W DATA_05CD62,Y       
CODE_05CFD1:        9F 8F 83 7F   STA.L $7F838F,X           
CODE_05CFD5:        B9 63 CD      LDA.W DATA_05CD63,Y       
CODE_05CFD8:        9F 97 83 7F   STA.L $7F8397,X           
CODE_05CFDC:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05CFDE:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_05CFE0:        A5 0A         LDA $0A                   
CODE_05CFE2:        8F 7B 83 7F   STA.L $7F837B             
CODE_05CFE6:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_05CFE8:        AB            PLB                       
Return05CFE9:       60            RTS                       ; Return 


DATA_05CFEA:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$D8,$01
                                  .db $D9,$C1,$D9,$01,$D8,$C1,$22,$01
                                  .db $DF,$01,$22,$01,$DF,$01,$EE,$C1
                                  .db $DE,$C1,$ED,$C1,$DD,$C1,$DA,$01
                                  .db $DA,$C1,$DA,$01,$DA,$C1,$DD,$01
                                  .db $ED,$01,$DE,$01,$EE,$01,$DF,$01
                                  .db $22,$01,$DF,$01,$22,$01,$22,$01
                                  .db $D8,$01,$22,$01,$D9,$01,$22,$01
                                  .db $EB,$01,$EB,$01,$EB,$C1,$EB,$C1
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$EB,$01,$EC,$C1
                                  .db $DC,$C1,$DC,$01,$EC,$01,$DB,$01
                                  .db $DB,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$EC,$C1,$DC,$C1,$DC,$01
                                  .db $EC,$01,$22,$01,$22,$01,$D6,$01
                                  .db $E6,$01,$D7,$01,$E7,$01,$EA,$01
                                  .db $EA,$01,$EA,$C1,$EA,$C1,$D9,$C1
                                  .db $22,$01,$D8,$C1,$22,$01,$E7,$C1
                                  .db $D7,$C1,$E6,$C1,$D6,$C1,$22,$01
                                  .db $22,$01,$DB,$01,$DB,$01,$D9,$41
                                  .db $D8,$81,$D8,$41,$D9,$81,$ED,$81
                                  .db $DD,$81,$EE,$81,$DE,$81,$DE,$41
                                  .db $EE,$41,$DD,$41,$ED,$41,$22,$01
                                  .db $D9,$41,$22,$01,$D8,$41,$EB,$41
                                  .db $EB,$81,$22,$01,$EB,$41,$22,$01
                                  .db $22,$01,$EB,$81,$22,$01,$22,$01
                                  .db $EB,$41,$22,$01,$22,$01,$DC,$41
                                  .db $EC,$41,$EC,$81,$DC,$81,$EC,$81
                                  .db $DC,$81,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$DC,$41,$EC,$41,$D7,$41
                                  .db $E7,$41,$D6,$41,$E6,$41,$D8,$81
                                  .db $22,$01,$D9,$81,$22,$01,$E6,$81
                                  .db $D6,$81,$E7,$81,$D7,$81,$EB,$81
                                  .db $22,$01,$EB,$41,$EB,$81,$EB,$01
                                  .db $EB,$C1,$EB,$C1,$22,$01,$A8,$11
                                  .db $B8,$11,$A9,$11,$B9,$11,$A6,$11
                                  .db $B6,$11,$A7,$11,$B7,$11,$A6,$11
                                  .db $B6,$11,$A7,$11,$B7,$11,$20,$68
                                  .db $20,$68,$20,$28,$20,$28,$20,$28
                                  .db $20,$28,$22,$09,$22,$09,$22,$01
                                  .db $22,$01,$EC,$C1,$DC,$C1,$DC,$01
                                  .db $EC,$01,$22,$01,$22,$01,$EA,$01
                                  .db $EA,$01,$EA,$C1,$EA,$C1,$EE,$C1
                                  .db $DE,$C1,$ED,$C1,$DD,$C1,$DD,$01
                                  .db $ED,$01,$DE,$01,$EE,$01,$EB,$C1
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$EB,$01,$EC,$C1
                                  .db $DC,$C1,$DC,$01,$EC,$01,$DB,$01
                                  .db $DB,$01,$22,$01,$22,$01,$D6,$01
                                  .db $E6,$01,$D7,$01,$E7,$01,$ED,$81
                                  .db $DD,$81,$EE,$81,$DE,$81,$DF,$01
                                  .db $22,$01,$DF,$01,$22,$01,$D7,$41
                                  .db $E7,$41,$D6,$41,$E6,$41,$22,$01
                                  .db $EB,$41,$22,$01,$22,$01,$EC,$81
                                  .db $DC,$81,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$EB,$81,$22,$01,$D9,$41
                                  .db $D8,$81,$D8,$41,$D9,$81,$EB,$C1
                                  .db $EB,$C1,$EB,$C1,$22,$01,$22,$01
                                  .db $22,$01,$DB,$01,$DB,$01,$E7,$C1
                                  .db $D7,$C1,$E6,$C1,$D6,$C1,$22,$01
                                  .db $DF,$01,$22,$01,$DF,$01,$E6,$81
                                  .db $D6,$81,$E7,$81,$D7,$81,$D8,$01
                                  .db $D9,$C1,$D9,$01,$D8,$C1,$EA,$01
                                  .db $EA,$01,$EA,$C1,$EA,$C1,$EA,$01
                                  .db $EA,$01,$EA,$C1,$EA,$C1,$D6,$01
                                  .db $E6,$01,$D7,$01,$E7,$01,$DA,$01
                                  .db $DA,$C1,$DA,$01,$DA,$C1,$A4,$11
                                  .db $B4,$11,$A5,$11,$B5,$11,$22,$11
                                  .db $90,$11,$22,$11,$91,$11,$C2,$11
                                  .db $D2,$11,$C3,$11,$D3,$11,$23,$38
                                  .db $71,$38,$23,$38,$71,$38,$23,$28
                                  .db $71,$28,$23,$28,$71,$28,$23,$30
                                  .db $71,$30,$23,$30,$71,$30,$22,$01
                                  .db $22,$01,$22,$01,$EB,$01,$22,$01
                                  .db $EB,$41,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$EB,$81,$22,$01,$22,$15
                                  .db $AC,$15,$22,$15,$AD,$15,$EA,$01
                                  .db $EA,$01,$EA,$C1,$EA,$C1,$DA,$01
                                  .db $DA,$C1,$DA,$01,$DA,$C1,$DA,$01
                                  .db $DA,$C1,$DA,$01,$DA,$C1,$E7,$C1
                                  .db $D7,$C1,$E6,$C1,$D6,$C1,$EB,$C1
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$C9,$05
                                  .db $C8,$05,$C9,$05,$C8,$05,$84,$11
                                  .db $94,$11,$85,$11,$95,$11,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$88,$15
                                  .db $98,$15,$89,$15,$99,$15,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$8C,$15
                                  .db $9C,$15,$8D,$15,$9D,$15,$9E,$10
                                  .db $64,$10,$9F,$10,$65,$10,$BC,$15
                                  .db $AE,$15,$BD,$15,$AF,$15,$82,$19
                                  .db $92,$19,$83,$19,$93,$19,$C8,$19
                                  .db $F8,$19,$C9,$19,$F9,$19,$AA,$11
                                  .db $BA,$11,$AA,$51,$BA,$51,$56,$19
                                  .db $EA,$09,$56,$59,$EA,$C9,$A0,$11
                                  .db $B0,$11,$A1,$11,$B1,$11,$A2,$11
                                  .db $B2,$11,$A3,$11,$B3,$11,$CC,$15
                                  .db $CE,$15,$CD,$15,$CF,$15,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$86,$99
                                  .db $86,$19,$86,$D9,$86,$59,$96,$99
                                  .db $96,$19,$96,$D9,$96,$59,$86,$9D
                                  .db $86,$1D,$86,$DD,$86,$5D,$96,$9D
                                  .db $96,$1D,$96,$DD,$96,$5D,$86,$99
                                  .db $86,$19,$86,$D9,$86,$59,$96,$99
                                  .db $96,$19,$96,$D9,$96,$59,$86,$9D
                                  .db $86,$1D,$86,$DD,$86,$5D,$96,$9D
                                  .db $96,$1D,$96,$DD,$96,$5D,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$80,$1C
                                  .db $90,$1C,$81,$1C,$90,$5C,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$80,$14
                                  .db $90,$14,$81,$14,$90,$54,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$82,$1D
                                  .db $92,$1D,$83,$1D,$93,$1D,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$86,$99
                                  .db $86,$19,$86,$D9,$86,$59,$22,$01
                                  .db $22,$01,$22,$01,$22,$01,$86,$99
                                  .db $86,$19,$86,$D9,$86,$59,$8A,$15
                                  .db $9A,$15,$8B,$15,$9B,$15,$8C,$15
                                  .db $9C,$15,$8D,$15,$9D,$15,$C0,$11
                                  .db $D0,$11,$C1,$11,$D1,$11,$22,$11
                                  .db $22,$11,$22,$11,$22,$11,$22,$1D
                                  .db $82,$1C,$22,$1D,$83,$1C,$22,$1D
                                  .db $82,$14,$22,$1D,$83,$14,$80,$19
                                  .db $90,$19,$81,$19,$91,$19,$8E,$19
                                  .db $9E,$19,$8F,$19,$9F,$19,$A0,$19
                                  .db $B0,$19,$A1,$19,$B1,$19,$A4,$19
                                  .db $B4,$19,$A5,$19,$B5,$19,$A8,$19
                                  .db $B8,$19,$A9,$19,$B9,$19,$BE,$19
                                  .db $CE,$19,$BF,$19,$CF,$19,$C4,$19
                                  .db $D4,$19,$C5,$19,$D5,$19,$22,$09
                                  .db $C6,$0D,$22,$09,$C7,$0D,$22,$09
                                  .db $FC,$0D,$FE,$0D,$FD,$0D,$CC,$0D
                                  .db $E4,$0D,$CD,$0D,$E5,$0D,$E0,$0D
                                  .db $F0,$0D,$E1,$0D,$F1,$0D,$F4,$0D
                                  .db $22,$09,$F5,$0D,$22,$09,$E8,$0D
                                  .db $22,$09,$22,$09,$22,$09,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$75,$3C
                                  .db $75,$3C,$75,$3C,$75,$3C,$22,$09
                                  .db $79,$14,$22,$09,$9D,$14,$22,$09
                                  .db $78,$54,$22,$09,$22,$09,$22,$09
                                  .db $22,$09,$22,$09,$79,$14,$22,$09
                                  .db $9D,$14,$78,$14,$9D,$14,$9D,$14
                                  .db $78,$54,$79,$54,$22,$09,$79,$14
                                  .db $22,$09,$22,$09,$22,$09,$22,$09
                                  .db $22,$09,$78,$54,$22,$09,$22,$09
                                  .db $22,$09,$78,$14,$22,$09,$9D,$14
                                  .db $22,$09,$79,$54,$22,$09,$22,$09
                                  .db $9D,$14,$22,$09,$78,$54,$22,$09
                                  .db $78,$14,$22,$09,$22,$09,$22,$09
                                  .db $22,$09,$22,$09,$79,$54,$78,$14
                                  .db $9D,$14,$9D,$14,$9D,$14,$56,$10
                                  .db $9E,$10,$57,$10,$9F,$10,$9E,$10
                                  .db $9E,$10,$9F,$10,$9F,$10,$22,$15
                                  .db $AC,$15,$22,$15,$AD,$15,$22,$09
                                  .db $22,$09,$22,$09,$48,$19,$22,$09
                                  .db $39,$19,$22,$09,$22,$09,$22,$09
                                  .db $22,$09,$37,$15,$47,$15,$38,$15
                                  .db $48,$19,$58,$19,$49,$19,$49,$59
                                  .db $59,$59,$48,$59,$58,$59,$37,$55
                                  .db $47,$55,$22,$09,$22,$09,$22,$09
                                  .db $22,$09,$57,$15,$5A,$1D,$58,$19
                                  .db $5B,$19,$59,$19,$59,$19,$60,$19
                                  .db $70,$19,$60,$59,$70,$59,$3A,$19
                                  .db $4A,$19,$3B,$19,$4B,$11,$48,$19
                                  .db $58,$19,$48,$59,$58,$59,$22,$09
                                  .db $22,$09,$7A,$1D,$22,$09,$7B,$1D
                                  .db $22,$09,$7B,$1D,$22,$09,$7B,$1D
                                  .db $22,$09,$7A,$5D,$22,$09,$CA,$19
                                  .db $FA,$19,$CB,$19,$FB,$19,$7E,$18
                                  .db $22,$09,$22,$09,$22,$09,$7F,$10
                                  .db $22,$09,$22,$09,$22,$09,$7F,$10
                                  .db $22,$09,$22,$09,$7E,$18,$7E,$18
                                  .db $22,$09,$22,$09,$7F,$10,$22,$09
                                  .db $22,$09,$22,$09,$7E,$18,$22,$09
                                  .db $22,$09,$22,$09,$7F,$10,$3F,$10
                                  .db $3F,$10,$3F,$10,$3F,$10,$6F,$51
                                  .db $7F,$51,$6E,$51,$7E,$51,$F3,$51
                                  .db $FF,$51,$87,$51,$97,$51,$08,$00
                                  .db $09,$00,$0A,$00,$0B,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00

DATA_05D608:                      .db $FF,$1F,$20,$FF,$0B,$0D,$0E,$0F
                                  .db $28,$09,$10,$21,$22,$23,$24,$25
                                  .db $27,$60,$FF,$12,$02,$07,$FF,$FF
                                  .db $4E,$FF,$4D,$4A,$4C,$4B,$36,$35
                                  .db $61,$63,$62,$48,$46,$06,$05,$04
                                  .db $00,$01,$03,$19,$FF,$1D,$1A,$14
                                  .db $44,$45,$42,$3E,$40,$41,$43,$3D
                                  .db $3B,$39,$38,$4F,$17,$1B,$15,$29
                                  .db $1C,$30,$2A,$32,$2C,$37,$34,$2E
                                  .db $6D,$6C,$6B,$6A,$69,$64,$65,$66
                                  .db $67,$68,$56,$53,$54,$5F,$57,$59
                                  .db $51,$5A,$5D,$50,$5C

Empty05D665:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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
                                  .db $FF,$FF,$FF

DATA_05D708:                      .db $00,$60,$C0,$00

DATA_05D70C:                      .db $60,$90,$C0,$00

DATA_05D710:                      .db $03,$01,$01,$00,$00,$02,$02,$01
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
DATA_05D720:                      .db $02,$02,$01,$00,$01,$02,$01,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
DATA_05D730:                      .db $00,$30,$60,$80,$A0,$B0,$C0,$E0
                                  .db $10,$30,$50,$60,$70,$90,$00,$00
DATA_05D740:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $01,$01,$01,$01,$01,$01,$01,$01
DATA_05D750:                      .db $10,$80,$00,$E0,$10,$70,$00,$E0
DATA_05D758:                      .db $00,$00,$00,$00,$01,$01,$01,$01
DATA_05D760:                      .db $05,$01,$02,$06,$08,$01

PtrsLong05D766:        00 80 07   .dw LevelData078000 .db :$LevelData078000 
                       1E 80 07   .dw DATA_07801E .db :$DATA_07801E 
                       4E 80 07   .dw DATA_07804E .db :$DATA_07804E 
                       9F 80 07   .dw DATA_07809F .db :$DATA_07809F 
                       B1 80 07   .dw DATA_0780B1 .db :$DATA_0780B1 
                       90 80 07   .dw DATA_078090 .db :$DATA_078090 

PtrsLong05D778:        18 80 07   .dw DATA_078018 .db :$DATA_078018 
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       84 E6 FF   .dw DATA_0CE684 .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       EE E8 FF   .dw DATA_0CE8EE .db $FF   

DATA_05D78A:                      .db $03,$00,$00,$00,$00,$00

DATA_05D790:                      .db $70,$70,$60,$70,$70,$70

CODE_05D796:        8B            PHB                       
CODE_05D797:        4B            PHK                       
CODE_05D798:        AB            PLB                       
CODE_05D799:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_05D79B:        9C CF 13      STZ.W $13CF               
CODE_05D79E:        AD 95 1B      LDA.W $1B95               
CODE_05D7A1:        D0 05         BNE CODE_05D7A8           
CODE_05D7A3:        AC 25 14      LDY.W $1425               
CODE_05D7A6:        F0 03         BEQ CODE_05D7AB           
CODE_05D7A8:        20 AC DB      JSR.W CODE_05DBAC         
CODE_05D7AB:        AD 1A 14      LDA.W $141A               
CODE_05D7AE:        D0 03         BNE CODE_05D7B3           
CODE_05D7B0:        4C 3E D8      JMP.W CODE_05D83E         

CODE_05D7B3:        A6 95         LDX RAM_MarioXPosHi       
CODE_05D7B5:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_05D7B7:        29 01         AND.B #$01                
CODE_05D7B9:        F0 02         BEQ CODE_05D7BD           
CODE_05D7BB:        A6 97         LDX RAM_MarioYPosHi       
CODE_05D7BD:        BD B8 19      LDA.W $19B8,X             
CODE_05D7C0:        8D BB 17      STA.W $17BB               
CODE_05D7C3:        85 0E         STA $0E                   
CODE_05D7C5:        AD D6 0D      LDA.W $0DD6               
CODE_05D7C8:        4A            LSR                       
CODE_05D7C9:        4A            LSR                       
CODE_05D7CA:        A8            TAY                       
CODE_05D7CB:        B9 11 1F      LDA.W $1F11,Y             
CODE_05D7CE:        F0 02         BEQ CODE_05D7D2           
CODE_05D7D0:        A9 01         LDA.B #$01                
CODE_05D7D2:        85 0F         STA $0F                   
CODE_05D7D4:        AD 93 1B      LDA.W $1B93               
CODE_05D7D7:        F0 62         BEQ CODE_05D83B           
CODE_05D7D9:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_05D7DB:        A9 00 00      LDA.W #$0000              
CODE_05D7DE:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05D7E0:        A4 0E         LDY $0E                   
CODE_05D7E2:        B9 00 F8      LDA.W DATA_05F800,Y       
CODE_05D7E5:        85 0E         STA $0E                   
CODE_05D7E7:        8D BB 17      STA.W $17BB               
CODE_05D7EA:        B9 00 FA      LDA.W DATA_05FA00,Y       
CODE_05D7ED:        85 00         STA $00                   
CODE_05D7EF:        29 0F         AND.B #$0F                
CODE_05D7F1:        AA            TAX                       
CODE_05D7F2:        BF 30 D7 05   LDA.L DATA_05D730,X       
CODE_05D7F6:        85 96         STA RAM_MarioYPos         
CODE_05D7F8:        BF 40 D7 05   LDA.L DATA_05D740,X       
CODE_05D7FC:        85 97         STA RAM_MarioYPosHi       
CODE_05D7FE:        A5 00         LDA $00                   
CODE_05D800:        29 30         AND.B #$30                
CODE_05D802:        4A            LSR                       
CODE_05D803:        4A            LSR                       
CODE_05D804:        4A            LSR                       
CODE_05D805:        4A            LSR                       
CODE_05D806:        AA            TAX                       
CODE_05D807:        BF 08 D7 05   LDA.L DATA_05D708,X       
CODE_05D80B:        85 1C         STA RAM_ScreenBndryYLo    
CODE_05D80D:        A5 00         LDA $00                   
CODE_05D80F:        4A            LSR                       
CODE_05D810:        4A            LSR                       
CODE_05D811:        4A            LSR                       
CODE_05D812:        4A            LSR                       
CODE_05D813:        4A            LSR                       
CODE_05D814:        4A            LSR                       
CODE_05D815:        AA            TAX                       
CODE_05D816:        BF 0C D7 05   LDA.L DATA_05D70C,X       
CODE_05D81A:        85 20         STA $20                   
CODE_05D81C:        B9 00 FC      LDA.W DATA_05FC00,Y       
CODE_05D81F:        85 01         STA $01                   
CODE_05D821:        4A            LSR                       
CODE_05D822:        4A            LSR                       
CODE_05D823:        4A            LSR                       
CODE_05D824:        4A            LSR                       
CODE_05D825:        4A            LSR                       
CODE_05D826:        AA            TAX                       
CODE_05D827:        BF 50 D7 05   LDA.L DATA_05D750,X       
CODE_05D82B:        85 94         STA RAM_MarioXPos         
CODE_05D82D:        BF 58 D7 05   LDA.L DATA_05D758,X       
CODE_05D831:        85 95         STA RAM_MarioXPosHi       
CODE_05D833:        B9 00 FE      LDA.W DATA_05FE00,Y       
CODE_05D836:        29 07         AND.B #$07                
CODE_05D838:        8D 2A 19      STA.W $192A               
CODE_05D83B:        4C B7 D8      JMP.W CODE_05D8B7         

CODE_05D83E:        64 0F         STZ $0F                   ; Index (8 bit) 
CODE_05D840:        A0 00         LDY.B #$00                
CODE_05D842:        AD 09 01      LDA.W $0109               
CODE_05D845:        D0 5B         BNE CODE_05D8A2           
CODE_05D847:        C2 30         REP #$30                  ; 16 bit A,X,Y ; Index (16 bit) Accum (16 bit) 
CODE_05D849:        64 1A         STZ RAM_ScreenBndryXLo    ; Set "X position of screen boundary" to 0 
CODE_05D84B:        64 1E         STZ $1E                   ; Set "Layer 2 X position" to 0 
CODE_05D84D:        AE D6 0D      LDX.W $0DD6               
CODE_05D850:        BD 1F 1F      LDA.W $1F1F,X             
CODE_05D853:        29 0F 00      AND.W #$000F              
CODE_05D856:        85 00         STA $00                   
CODE_05D858:        BD 21 1F      LDA.W $1F21,X             
CODE_05D85B:        29 0F 00      AND.W #$000F              
CODE_05D85E:        0A            ASL                       
CODE_05D85F:        0A            ASL                       
CODE_05D860:        0A            ASL                       
CODE_05D861:        0A            ASL                       
CODE_05D862:        85 02         STA $02                   
CODE_05D864:        BD 1F 1F      LDA.W $1F1F,X             
CODE_05D867:        29 10 00      AND.W #$0010              
CODE_05D86A:        0A            ASL                       
CODE_05D86B:        0A            ASL                       
CODE_05D86C:        0A            ASL                       
CODE_05D86D:        0A            ASL                       
CODE_05D86E:        05 00         ORA $00                   
CODE_05D870:        85 00         STA $00                   
CODE_05D872:        BD 21 1F      LDA.W $1F21,X             
CODE_05D875:        29 10 00      AND.W #$0010              
CODE_05D878:        0A            ASL                       
CODE_05D879:        0A            ASL                       
CODE_05D87A:        0A            ASL                       
CODE_05D87B:        0A            ASL                       
CODE_05D87C:        0A            ASL                       
CODE_05D87D:        05 02         ORA $02                   
CODE_05D87F:        05 00         ORA $00                   
CODE_05D881:        AA            TAX                       
CODE_05D882:        AD D6 0D      LDA.W $0DD6               ; \ 
CODE_05D885:        29 FF 00      AND.W #$00FF              ;  | 
CODE_05D888:        4A            LSR                       ;  |Set Y to current player 
CODE_05D889:        4A            LSR                       ;  | 
CODE_05D88A:        A8            TAY                       ; / 
CODE_05D88B:        B9 11 1F      LDA.W $1F11,Y             ; \ Get current player's submap 
CODE_05D88E:        29 0F 00      AND.W #$000F              ; / 
CODE_05D891:        F0 06         BEQ CODE_05D899           ; \ 
CODE_05D893:        8A            TXA                       ;  | 
CODE_05D894:        18            CLC                       ;  |If on submap, increase X by x400 
CODE_05D895:        69 00 04      ADC.W #$0400              ;  | 
CODE_05D898:        AA            TAX                       ;  | 
CODE_05D899:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_05D89B:        BF 00 D0 7E   LDA.L $7ED000,X           
CODE_05D89F:        8D BF 13      STA.W $13BF               ; Store overworld level number 
CODE_05D8A2:        C9 25         CMP.B #$25                ; \ 
CODE_05D8A4:        90 03         BCC CODE_05D8A9           ;  | 
CODE_05D8A6:        38            SEC                       ;  |If A>= x25, 
CODE_05D8A7:        E9 24         SBC.B #$24                ;  |subtract x24 
CODE_05D8A9:        8D BB 17      STA.W $17BB               
CODE_05D8AC:        85 0E         STA $0E                   ; Store A as lower level number byte 
CODE_05D8AE:        B9 11 1F      LDA.W $1F11,Y             ; \ 
CODE_05D8B1:        F0 02         BEQ CODE_05D8B5           ;  |Set higher level number byte to: 
CODE_05D8B3:        A9 01         LDA.B #$01                ;  |0 if on overworld 
CODE_05D8B5:        85 0F         STA $0F                   ; / 
CODE_05D8B7:        C2 30         REP #$30                  ; 16 bit A,X,Y ; Index (16 bit) Accum (16 bit) 
CODE_05D8B9:        A5 0E         LDA $0E                   ; \ 
CODE_05D8BB:        0A            ASL                       ;  | 
CODE_05D8BC:        18            CLC                       ;  |Multiply level number by 3 and store in Y 
CODE_05D8BD:        65 0E         ADC $0E                   ;  |(Each L1/2 pointer table entry is 3 bytes long) 
CODE_05D8BF:        A8            TAY                       ; / 
CODE_05D8C0:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_05D8C2:        B9 00 E0      LDA.W Layer1Ptrs,Y        ; \ 
CODE_05D8C5:        85 65         STA $65                   ;  | 
CODE_05D8C7:        B9 01 E0      LDA.W Layer1Ptrs+1,Y      ;  |Load Layer 1 pointer into $65-$67 
CODE_05D8CA:        85 66         STA $66                   ;  | 
CODE_05D8CC:        B9 02 E0      LDA.W Layer1Ptrs+2,Y      ;  | 
CODE_05D8CF:        85 67         STA $67                   ; / 
CODE_05D8D1:        B9 00 E6      LDA.W Layer2Ptrs,Y        ; \ 
CODE_05D8D4:        85 68         STA $68                   ;  | 
CODE_05D8D6:        B9 01 E6      LDA.W Layer2Ptrs+1,Y      ;  |Load Layer 2 pointer into $68-$6A 
CODE_05D8D9:        85 69         STA $69                   ;  | 
CODE_05D8DB:        B9 02 E6      LDA.W Layer2Ptrs+2,Y      ;  | 
CODE_05D8DE:        85 6A         STA $6A                   ; / 
CODE_05D8E0:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_05D8E2:        A5 0E         LDA $0E                   ; \ 
CODE_05D8E4:        0A            ASL                       ;  |Multiply level number by 2 and store in Y 
CODE_05D8E5:        A8            TAY                       ; / (Each sprite pointer table entry is 2 bytes long) 
CODE_05D8E6:        A9 00 00      LDA.W #$0000              
CODE_05D8E9:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_05D8EB:        B9 00 EC      LDA.W Ptrs05EC00,Y        ; \ 
CODE_05D8EE:        85 CE         STA $CE                   ;  |Store location of sprite level Y in $CE-$CF 
CODE_05D8F0:        B9 01 EC      LDA.W ADDR_05EC01,Y       ;  | 
CODE_05D8F3:        85 CF         STA $CF                   ; / 
CODE_05D8F5:        A9 07         LDA.B #$07                ; \ Set highest byte to x07 
CODE_05D8F7:        85 D0         STA $D0                   ; / (All sprite data is stored in bank 07) 
CODE_05D8F9:        A7 CE         LDA [$CE]                 ; \ Get first byte of sprite data (header) 
CODE_05D8FB:        29 3F         AND.B #$3F                ;  |Get level's sprite memory 
CODE_05D8FD:        8D 92 16      STA.W $1692               ; / Store in $1692 
CODE_05D900:        A7 CE         LDA [$CE]                 ; \ Get first byte of sprite data (header) again 
CODE_05D902:        29 C0         AND.B #$C0                ;  |Get level's sprite buoyancy settings 
CODE_05D904:        8D 0E 19      STA.W $190E               ; / Store in $190E 
CODE_05D907:        C2 10         REP #$10                  ; 16 bit X,Y ; Index (16 bit) 
CODE_05D909:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_05D90B:        A4 0E         LDY $0E                   
CODE_05D90D:        B9 00 F0      LDA.W DATA_05F000,Y       
CODE_05D910:        4A            LSR                       
CODE_05D911:        4A            LSR                       
CODE_05D912:        4A            LSR                       
CODE_05D913:        4A            LSR                       
CODE_05D914:        AA            TAX                       
CODE_05D915:        BF 20 D7 05   LDA.L DATA_05D720,X       
CODE_05D919:        8D 13 14      STA.W $1413               
CODE_05D91C:        BF 10 D7 05   LDA.L DATA_05D710,X       
CODE_05D920:        8D 14 14      STA.W $1414               
CODE_05D923:        A9 01         LDA.B #$01                
CODE_05D925:        8D 11 14      STA.W $1411               
CODE_05D928:        B9 00 F2      LDA.W DATA_05F200,Y       
CODE_05D92B:        29 C0         AND.B #$C0                
CODE_05D92D:        18            CLC                       
CODE_05D92E:        0A            ASL                       
CODE_05D92F:        2A            ROL                       
CODE_05D930:        2A            ROL                       
CODE_05D931:        8D E3 1B      STA.W $1BE3               
CODE_05D934:        64 1D         STZ RAM_ScreenBndryYHi    
CODE_05D936:        64 21         STZ $21                   
CODE_05D938:        B9 00 F6      LDA.W DATA_05F600,Y       
CODE_05D93B:        29 80         AND.B #$80                
CODE_05D93D:        8D 1F 14      STA.W $141F               
CODE_05D940:        B9 00 F6      LDA.W DATA_05F600,Y       
CODE_05D943:        29 60         AND.B #$60                
CODE_05D945:        4A            LSR                       
CODE_05D946:        4A            LSR                       
CODE_05D947:        4A            LSR                       
CODE_05D948:        4A            LSR                       
CODE_05D949:        4A            LSR                       
CODE_05D94A:        85 5B         STA RAM_IsVerticalLvl     
CODE_05D94C:        AD 93 1B      LDA.W $1B93               
CODE_05D94F:        D0 50         BNE CODE_05D9A1           
CODE_05D951:        B9 00 F0      LDA.W DATA_05F000,Y       
CODE_05D954:        29 0F         AND.B #$0F                
CODE_05D956:        AA            TAX                       
CODE_05D957:        BF 30 D7 05   LDA.L DATA_05D730,X       
CODE_05D95B:        85 96         STA RAM_MarioYPos         
CODE_05D95D:        BF 40 D7 05   LDA.L DATA_05D740,X       
CODE_05D961:        85 97         STA RAM_MarioYPosHi       
CODE_05D963:        B9 00 F2      LDA.W DATA_05F200,Y       
CODE_05D966:        85 02         STA $02                   
CODE_05D968:        29 07         AND.B #$07                
CODE_05D96A:        AA            TAX                       
CODE_05D96B:        BF 50 D7 05   LDA.L DATA_05D750,X       
CODE_05D96F:        85 94         STA RAM_MarioXPos         
CODE_05D971:        BF 58 D7 05   LDA.L DATA_05D758,X       
CODE_05D975:        85 95         STA RAM_MarioXPosHi       
CODE_05D977:        A5 02         LDA $02                   
CODE_05D979:        29 38         AND.B #$38                
CODE_05D97B:        4A            LSR                       
CODE_05D97C:        4A            LSR                       
CODE_05D97D:        4A            LSR                       
CODE_05D97E:        8D 2A 19      STA.W $192A               
CODE_05D981:        B9 00 F4      LDA.W DATA_05F400,Y       
CODE_05D984:        85 02         STA $02                   
CODE_05D986:        29 03         AND.B #$03                
CODE_05D988:        AA            TAX                       
CODE_05D989:        BF 0C D7 05   LDA.L DATA_05D70C,X       
CODE_05D98D:        85 20         STA $20                   
CODE_05D98F:        A5 02         LDA $02                   
CODE_05D991:        29 0C         AND.B #$0C                
CODE_05D993:        4A            LSR                       
CODE_05D994:        4A            LSR                       
CODE_05D995:        AA            TAX                       
CODE_05D996:        BF 08 D7 05   LDA.L DATA_05D708,X       
CODE_05D99A:        85 1C         STA RAM_ScreenBndryYLo    
CODE_05D99C:        B9 00 F6      LDA.W DATA_05F600,Y       
CODE_05D99F:        85 01         STA $01                   
CODE_05D9A1:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_05D9A3:        29 01         AND.B #$01                
CODE_05D9A5:        F0 11         BEQ CODE_05D9B8           
CODE_05D9A7:        A0 00 00      LDY.W #$0000              
CODE_05D9AA:        B7 65         LDA [$65],Y               
CODE_05D9AC:        29 1F         AND.B #$1F                
CODE_05D9AE:        85 97         STA RAM_MarioYPosHi       
CODE_05D9B0:        1A            INC A                     
CODE_05D9B1:        85 5F         STA $5F                   
CODE_05D9B3:        A9 01         LDA.B #$01                
CODE_05D9B5:        8D 12 14      STA.W $1412               
CODE_05D9B8:        AD 1A 14      LDA.W $141A               
CODE_05D9BB:        D0 2F         BNE CODE_05D9EC           
CODE_05D9BD:        A5 02         LDA $02                   
CODE_05D9BF:        4A            LSR                       
CODE_05D9C0:        4A            LSR                       
CODE_05D9C1:        4A            LSR                       
CODE_05D9C2:        4A            LSR                       
CODE_05D9C3:        8D CD 13      STA.W $13CD               
CODE_05D9C6:        9C CE 13      STZ.W $13CE               
CODE_05D9C9:        AC BF 13      LDY.W $13BF               
CODE_05D9CC:        B9 08 D6      LDA.W DATA_05D608,Y       
CODE_05D9CF:        8D EA 1D      STA.W $1DEA               
CODE_05D9D2:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_05D9D4:        AE BF 13      LDX.W $13BF               
CODE_05D9D7:        BD A2 1E      LDA.W $1EA2,X             
CODE_05D9DA:        29 40         AND.B #$40                
CODE_05D9DC:        F0 0E         BEQ CODE_05D9EC           
CODE_05D9DE:        8D CF 13      STA.W $13CF               
CODE_05D9E1:        A5 02         LDA $02                   
CODE_05D9E3:        4A            LSR                       
CODE_05D9E4:        4A            LSR                       
CODE_05D9E5:        4A            LSR                       
CODE_05D9E6:        4A            LSR                       
CODE_05D9E7:        85 95         STA RAM_MarioXPosHi       
CODE_05D9E9:        4C 17 DA      JMP.W CODE_05DA17         

CODE_05D9EC:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_05D9EE:        A5 01         LDA $01                   
CODE_05D9F0:        29 1F         AND.B #$1F                
CODE_05D9F2:        85 01         STA $01                   
CODE_05D9F4:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_05D9F6:        29 01         AND.B #$01                
CODE_05D9F8:        D0 07         BNE CODE_05DA01           
CODE_05D9FA:        A5 01         LDA $01                   
CODE_05D9FC:        85 95         STA RAM_MarioXPosHi       
CODE_05D9FE:        4C 17 DA      JMP.W CODE_05DA17         

CODE_05DA01:        A5 01         LDA $01                   
CODE_05DA03:        85 97         STA RAM_MarioYPosHi       
CODE_05DA05:        85 1D         STA RAM_ScreenBndryYHi    
CODE_05DA07:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_05DA09:        AC 14 14      LDY.W $1414               
CODE_05DA0C:        C0 03         CPY.B #$03                
CODE_05DA0E:        F0 02         BEQ CODE_05DA12           
CODE_05DA10:        85 21         STA $21                   
CODE_05DA12:        A9 01         LDA.B #$01                
CODE_05DA14:        8D 12 14      STA.W $1412               
CODE_05DA17:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_05DA19:        AD BF 13      LDA.W $13BF               
CODE_05DA1C:        C9 52         CMP.B #$52                
CODE_05DA1E:        90 04         BCC CODE_05DA24           
CODE_05DA20:        A2 03         LDX.B #$03                
CODE_05DA22:        80 14         BRA CODE_05DA38           

CODE_05DA24:        A2 04         LDX.B #$04                
CODE_05DA26:        A0 04         LDY.B #$04                
CODE_05DA28:        B7 65         LDA [$65],Y               
CODE_05DA2A:        29 0F         AND.B #$0F                
CODE_05DA2C:        DF 60 D7 05   CMP.L DATA_05D760,X       
CODE_05DA30:        F0 06         BEQ CODE_05DA38           
CODE_05DA32:        CA            DEX                       
CODE_05DA33:        10 F7         BPL CODE_05DA2C           
CODE_05DA35:        4C D7 DA      JMP.W CODE_05DAD7         

CODE_05DA38:        AD 1A 14      LDA.W $141A               
CODE_05DA3B:        D0 F8         BNE CODE_05DA35           
CODE_05DA3D:        AD 1D 14      LDA.W $141D               
CODE_05DA40:        D0 F3         BNE CODE_05DA35           
CODE_05DA42:        AD 1F 14      LDA.W $141F               
CODE_05DA45:        D0 EE         BNE CODE_05DA35           
CODE_05DA47:        AD BF 13      LDA.W $13BF               
CODE_05DA4A:        C9 31         CMP.B #$31                
CODE_05DA4C:        F0 10         BEQ CODE_05DA5E           
CODE_05DA4E:        C9 32         CMP.B #$32                
CODE_05DA50:        F0 0C         BEQ CODE_05DA5E           
CODE_05DA52:        C9 34         CMP.B #$34                
CODE_05DA54:        F0 08         BEQ CODE_05DA5E           
CODE_05DA56:        C9 35         CMP.B #$35                
CODE_05DA58:        F0 04         BEQ CODE_05DA5E           
CODE_05DA5A:        C9 40         CMP.B #$40                
CODE_05DA5C:        D0 02         BNE CODE_05DA60           
CODE_05DA5E:        A2 05         LDX.B #$05                
CODE_05DA60:        AD CF 13      LDA.W $13CF               
CODE_05DA63:        D0 6B         BNE CODE_05DAD0           
CODE_05DA65:        BF 90 D7 05   LDA.L DATA_05D790,X       
CODE_05DA69:        85 96         STA RAM_MarioYPos         
CODE_05DA6B:        A9 01         LDA.B #$01                
CODE_05DA6D:        85 97         STA RAM_MarioYPosHi       
CODE_05DA6F:        A9 30         LDA.B #$30                
CODE_05DA71:        85 94         STA RAM_MarioXPos         
CODE_05DA73:        64 95         STZ RAM_MarioXPosHi       
CODE_05DA75:        A9 C0         LDA.B #$C0                
CODE_05DA77:        85 1C         STA RAM_ScreenBndryYLo    
CODE_05DA79:        85 20         STA $20                   
CODE_05DA7B:        9C 2A 19      STZ.W $192A               
CODE_05DA7E:        A9 EE         LDA.B #$EE                
CODE_05DA80:        85 CE         STA $CE                   
CODE_05DA82:        A9 C3         LDA.B #$C3                
CODE_05DA84:        85 CF         STA $CF                   
CODE_05DA86:        A9 07         LDA.B #$07                
CODE_05DA88:        85 D0         STA $D0                   
CODE_05DA8A:        A7 CE         LDA [$CE]                 
CODE_05DA8C:        29 3F         AND.B #$3F                
CODE_05DA8E:        8D 92 16      STA.W $1692               
CODE_05DA91:        A7 CE         LDA [$CE]                 
CODE_05DA93:        29 C0         AND.B #$C0                
CODE_05DA95:        8D 0E 19      STA.W $190E               
CODE_05DA98:        9C 13 14      STZ.W $1413               
CODE_05DA9B:        9C 14 14      STZ.W $1414               
CODE_05DA9E:        9C 11 14      STZ.W $1411               
CODE_05DAA1:        64 5B         STZ RAM_IsVerticalLvl     
CODE_05DAA3:        BF 8A D7 05   LDA.L DATA_05D78A,X       
CODE_05DAA7:        8D E3 1B      STA.W $1BE3               
CODE_05DAAA:        86 00         STX $00                   
CODE_05DAAC:        8A            TXA                       
CODE_05DAAD:        0A            ASL                       
CODE_05DAAE:        18            CLC                       
CODE_05DAAF:        65 00         ADC $00                   
CODE_05DAB1:        A8            TAY                       
CODE_05DAB2:        B9 66 D7      LDA.W PtrsLong05D766,Y    
CODE_05DAB5:        85 65         STA $65                   
CODE_05DAB7:        B9 67 D7      LDA.W PtrsLong05D766+1,Y  
CODE_05DABA:        85 66         STA $66                   
CODE_05DABC:        B9 68 D7      LDA.W PtrsLong05D766+2,Y  
CODE_05DABF:        85 67         STA $67                   
CODE_05DAC1:        B9 78 D7      LDA.W PtrsLong05D778,Y    
CODE_05DAC4:        85 68         STA $68                   
CODE_05DAC6:        B9 79 D7      LDA.W PtrsLong05D778+1,Y  
CODE_05DAC9:        85 69         STA $69                   
CODE_05DACB:        B9 7A D7      LDA.W PtrsLong05D778+2,Y  
CODE_05DACE:        85 6A         STA $6A                   
CODE_05DAD0:        BF 60 D7 05   LDA.L DATA_05D760,X       
CODE_05DAD4:        8D 31 19      STA.W $1931               
CODE_05DAD7:        AD 1A 14      LDA.W $141A               
CODE_05DADA:        F0 0F         BEQ CODE_05DAEB           
CODE_05DADC:        AD 25 14      LDA.W $1425               
CODE_05DADF:        D0 0A         BNE CODE_05DAEB           
CODE_05DAE1:        AD BF 13      LDA.W $13BF               
CODE_05DAE4:        C9 24         CMP.B #$24                
CODE_05DAE6:        D0 03         BNE CODE_05DAEB           
CODE_05DAE8:        20 EF DA      JSR.W CODE_05DAEF         
CODE_05DAEB:        AB            PLB                       
CODE_05DAEC:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return05DAEE:       6B            RTL                       ; Return 

CODE_05DAEF:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_05DAF1:        A0 04         LDY.B #$04                
CODE_05DAF3:        B7 65         LDA [$65],Y               
CODE_05DAF5:        29 C0         AND.B #$C0                
CODE_05DAF7:        18            CLC                       
CODE_05DAF8:        2A            ROL                       
CODE_05DAF9:        2A            ROL                       
CODE_05DAFA:        2A            ROL                       
CODE_05DAFB:        22 FA 86 00   JSL.L ExecutePtrLong      

PtrsLong05DAFF:        3E DB 05   .dw CODE_05DB3E .db :$CODE_05DB3E 
                       6E DB 05   .dw CODE_05DB6E .db :$CODE_05DB6E 
                       82 DB 05   .dw CODE_05DB82 .db :$CODE_05DB82 

ChocIsld2Layer1:       24 EC      .dw DATA_06EC24           
                       7E EC      .dw DATA_06EC7E           
                       7E EC      .dw DATA_06EC7E           
                       85 E9      .dw DATA_06E985           
                       FB E9      .dw DATA_06E9FB           
                       B0 EA      .dw DATA_06EAB0           
                       0B EB      .dw DATA_06EB0B           
                       72 EB      .dw DATA_06EB72           
                       BE EB      .dw DATA_06EBBE           

ChocIsld2Sprites:      99 D8      .dw DATA_07D899           
                       A1 D8      .dw DATA_07D8A1           
                       A1 D8      .dw DATA_07D8A1           
                       E5 D7      .dw DATA_07D7E5           
                       EA D7      .dw DATA_07D7EA           
                       25 D8      .dw DATA_07D825           
                       4B D8      .dw DATA_07D84B           
                       6E D8      .dw DATA_07D86E           
                       88 D8      .dw DATA_07D888           

ChocIsld2Layer2:       59 DF      .dw DATA_0CDF59           
                       59 DF      .dw DATA_0CDF59           
                       59 DF      .dw DATA_0CDF59           
                       59 DF      .dw DATA_0CDF59           
                       59 DF      .dw DATA_0CDF59           
                       59 DF      .dw DATA_0CDF59           
                       59 DF      .dw DATA_0CDF59           
                       59 DF      .dw DATA_0CDF59           
                       59 DF      .dw DATA_0CDF59           

CODE_05DB3E:        A2 00         LDX.B #$00                
CODE_05DB40:        AD 22 14      LDA.W $1422               
CODE_05DB43:        C9 04         CMP.B #$04                
CODE_05DB45:        F0 02         BEQ CODE_05DB49           
CODE_05DB47:        A2 02         LDX.B #$02                
CODE_05DB49:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_05DB4B:        BF 08 DB 05   LDA.L ChocIsld2Layer1,X   
CODE_05DB4F:        85 65         STA $65                   
CODE_05DB51:        BF 1A DB 05   LDA.L ChocIsld2Sprites,X  
CODE_05DB55:        85 CE         STA $CE                   
CODE_05DB57:        BF 2C DB 05   LDA.L ChocIsld2Layer2,X   
CODE_05DB5B:        85 68         STA $68                   
CODE_05DB5D:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05DB5F:        A7 CE         LDA [$CE]                 
CODE_05DB61:        29 7F         AND.B #$7F                
CODE_05DB63:        8D 92 16      STA.W $1692               
CODE_05DB66:        A7 CE         LDA [$CE]                 
CODE_05DB68:        29 80         AND.B #$80                
CODE_05DB6A:        8D 0E 19      STA.W $190E               
Return05DB6D:       60            RTS                       ; Return 

CODE_05DB6E:        A2 0A         LDX.B #$0A                
CODE_05DB70:        AD C0 0D      LDA.W $0DC0               
CODE_05DB73:        C9 16         CMP.B #$16                
CODE_05DB75:        10 08         BPL CODE_05DB7F           
CODE_05DB77:        A2 08         LDX.B #$08                
CODE_05DB79:        C9 0A         CMP.B #$0A                
CODE_05DB7B:        10 02         BPL CODE_05DB7F           
ADDR_05DB7D:        A2 06         LDX.B #$06                
CODE_05DB7F:        4C 49 DB      JMP.W CODE_05DB49         

CODE_05DB82:        A2 0C         LDX.B #$0C                
CODE_05DB84:        AD 31 0F      LDA.W $0F31               
CODE_05DB87:        C9 02         CMP.B #$02                
CODE_05DB89:        30 1B         BMI CODE_05DBA6           
CODE_05DB8B:        AD 32 0F      LDA.W $0F32               
CODE_05DB8E:        C9 03         CMP.B #$03                
CODE_05DB90:        30 14         BMI CODE_05DBA6           
CODE_05DB92:        D0 07         BNE CODE_05DB9B           
CODE_05DB94:        AD 33 0F      LDA.W $0F33               
CODE_05DB97:        C9 05         CMP.B #$05                
CODE_05DB99:        30 0B         BMI CODE_05DBA6           
CODE_05DB9B:        A2 0E         LDX.B #$0E                
CODE_05DB9D:        AD 32 0F      LDA.W $0F32               
CODE_05DBA0:        C9 05         CMP.B #$05                
CODE_05DBA2:        30 02         BMI CODE_05DBA6           
CODE_05DBA4:        A2 10         LDX.B #$10                
CODE_05DBA6:        4C 49 DB      JMP.W CODE_05DB49         


DATA_05DBA9:                      .db $00,$C8,$00

CODE_05DBAC:        A0 00         LDY.B #$00                
CODE_05DBAE:        AD 95 1B      LDA.W $1B95               
CODE_05DBB1:        F0 02         BEQ CODE_05DBB5           
CODE_05DBB3:        A0 01         LDY.B #$01                
CODE_05DBB5:        A6 95         LDX RAM_MarioXPosHi       
CODE_05DBB7:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_05DBB9:        29 01         AND.B #$01                
CODE_05DBBB:        F0 02         BEQ CODE_05DBBF           
ADDR_05DBBD:        A6 97         LDX RAM_MarioYPosHi       
CODE_05DBBF:        B9 A9 DB      LDA.W DATA_05DBA9,Y       
CODE_05DBC2:        9D B8 19      STA.W $19B8,X             
CODE_05DBC5:        EE 1A 14      INC.W $141A               
Return05DBC8:       60            RTS                       ; Return 


DATA_05DBC9:                      .db $50,$88,$00,$03,$FE,$38,$FE,$38
                                  .db $FF,$B8,$3C,$B9,$3C,$BA,$3C,$BB
                                  .db $3C,$BA,$3C,$BA,$BC,$BC,$3C,$BD
                                  .db $3C,$BE,$3C,$BF,$3C,$C0,$3C,$B7
                                  .db $BC,$C1,$3C,$B9,$3C,$C2,$3C,$C2
                                  .db $BC

CODE_05DBF2:        8B            PHB                       
CODE_05DBF3:        4B            PHK                       
CODE_05DBF4:        AB            PLB                       
CODE_05DBF5:        A2 08         LDX.B #$08                
CODE_05DBF7:        BD C9 DB      LDA.W DATA_05DBC9,X       
CODE_05DBFA:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_05DBFE:        CA            DEX                       
CODE_05DBFF:        10 F6         BPL CODE_05DBF7           
CODE_05DC01:        A2 00         LDX.B #$00                
CODE_05DC03:        AD B3 0D      LDA.W $0DB3               
CODE_05DC06:        F0 02         BEQ CODE_05DC0A           
CODE_05DC08:        A2 01         LDX.B #$01                
CODE_05DC0A:        BD B4 0D      LDA.W RAM_PlayerLives,X   
CODE_05DC0D:        1A            INC A                     
CODE_05DC0E:        20 3A DC      JSR.W CODE_05DC3A         
CODE_05DC11:        E0 00         CPX.B #$00                
CODE_05DC13:        F0 0E         BEQ CODE_05DC23           
CODE_05DC15:        18            CLC                       
CODE_05DC16:        69 22         ADC.B #$22                
CODE_05DC18:        8F 83 83 7F   STA.L $7F8383             
CODE_05DC1C:        A9 39         LDA.B #$39                
CODE_05DC1E:        8F 84 83 7F   STA.L $7F8384             
CODE_05DC22:        8A            TXA                       
CODE_05DC23:        18            CLC                       
CODE_05DC24:        69 22         ADC.B #$22                
CODE_05DC26:        8F 81 83 7F   STA.L $7F8381             
CODE_05DC2A:        A9 39         LDA.B #$39                
CODE_05DC2C:        8F 82 83 7F   STA.L $7F8382             
CODE_05DC30:        A9 08         LDA.B #$08                
CODE_05DC32:        8F 7B 83 7F   STA.L $7F837B             
CODE_05DC36:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_05DC38:        AB            PLB                       
Return05DC39:       6B            RTL                       ; Return 

CODE_05DC3A:        A2 00         LDX.B #$00                
CODE_05DC3C:        C9 0A         CMP.B #$0A                
CODE_05DC3E:        90 05         BCC Return05DC45          
CODE_05DC40:        E9 0A         SBC.B #$0A                
CODE_05DC42:        E8            INX                       
CODE_05DC43:        80 F7         BRA CODE_05DC3C           

Return05DC45:       60            RTS                       ; Return 


Empty05DC46:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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

Layer1Ptrs:            54 86 06   .dw DATA_068654 .db :$DATA_068654 
                       69 BA 06   .dw DATA_06BA69 .db :$DATA_06BA69 
                       33 BC 06   .dw DATA_06BC33 .db :$DATA_06BC33 
                       BF 88 06   .dw DATA_0688BF .db :$DATA_0688BF 
                       07 98 06   .dw DATA_069807 .db :$DATA_069807 
                       61 99 06   .dw DATA_069961 .db :$DATA_069961 
                       B5 9B 06   .dw DATA_069BB5 .db :$DATA_069BB5 
                       C0 9D 06   .dw DATA_069DC0 .db :$DATA_069DC0 
                       6E 87 06   .dw DATA_06876E .db :$DATA_06876E 
                       2D 96 06   .dw DATA_06962D .db :$DATA_06962D 
                       34 A1 06   .dw DATA_06A134 .db :$DATA_06A134 
                       0F BD 06   .dw DATA_06BD0F .db :$DATA_06BD0F 
                       00 D0 06   .dw DATA_06D000 .db :$DATA_06D000 
                       F4 D0 06   .dw DATA_06D0F4 .db :$DATA_06D0F4 
                       A3 C3 06   .dw DATA_06C3A3 .db :$DATA_06C3A3 
                       AD BE 06   .dw DATA_06BEAD .db :$DATA_06BEAD 
                       C4 C1 06   .dw DATA_06C1C4 .db :$DATA_06C1C4 
                       83 C7 06   .dw DATA_06C783 .db :$DATA_06C783 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       F2 A2 06   .dw DATA_06A2F2 .db :$DATA_06A2F2 
                       8D 86 06   .dw DATA_06868D .db :$DATA_06868D 
                       E5 91 06   .dw DATA_0691E5 .db :$DATA_0691E5 
                       E5 91 06   .dw DATA_0691E5 .db :$DATA_0691E5 
                       E5 91 06   .dw DATA_0691E5 .db :$DATA_0691E5 
                       14 8C 07   .dw DATA_078C14 .db :$DATA_078C14 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       CC 89 07   .dw DATA_0789CC .db :$DATA_0789CC 
                       36 EE 06   .dw DATA_06EE36 .db :$DATA_06EE36 
                       E3 86 07   .dw DATA_0786E3 .db :$DATA_0786E3 
                       00 81 07   .dw LevelData078100 .db :$LevelData078100 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       0A E2 06   .dw DATA_06E20A .db :$DATA_06E20A 
                       D9 D9 06   .dw DATA_06D9D9 .db :$DATA_06D9D9 
                       A2 E7 06   .dw DATA_06E7A2 .db :$DATA_06E7A2 
                       44 E4 06   .dw DATA_06E444 .db :$DATA_06E444 
                       C9 EC 06   .dw DATA_06ECC9 .db :$DATA_06ECC9 
                       97 E8 06   .dw DATA_06E897 .db :$DATA_06E897 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       61 85 06   .dw DATA_068561 .db :$DATA_068561 
                       8B 85 06   .dw DATA_06858B .db :$DATA_06858B 
                       58 82 06   .dw DATA_068258 .db :$DATA_068258 
                       5E 82 06   .dw DATA_06825E .db :$DATA_06825E 
                       5E 82 06   .dw DATA_06825E .db :$DATA_06825E 
                       58 82 06   .dw DATA_068258 .db :$DATA_068258 
                       58 82 06   .dw DATA_068258 .db :$DATA_068258 
                       58 82 06   .dw DATA_068258 .db :$DATA_068258 
                       52 82 06   .dw DATA_068252 .db :$DATA_068252 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       35 89 07   .dw DATA_078935 .db :$DATA_078935 
                       6E E7 06   .dw DATA_06E76E .db :$DATA_06E76E 
                       99 C1 06   .dw DATA_06C199 .db :$DATA_06C199 
                       CB 88 07   .dw DATA_0788CB .db :$DATA_0788CB 
                       75 C3 06   .dw DATA_06C375 .db :$DATA_06C375 
                       70 A2 06   .dw DATA_06A270 .db :$DATA_06A270 
                       83 9D 06   .dw DATA_069D83 .db :$DATA_069D83 
                       4F 99 06   .dw DATA_06994F .db :$DATA_06994F 
                       03 86 06   .dw DATA_068603 .db :$DATA_068603 
                       49 C9 06   .dw DATA_06C949 .db :$DATA_06C949 
                       B5 85 06   .dw DATA_0685B5 .db :$DATA_0685B5 
                       7C 97 07   .dw DATA_07977C .db :$DATA_07977C 
                       7D 88 06   .dw DATA_06887D .db :$DATA_06887D 
                       AE 87 06   .dw DATA_0687AE .db :$DATA_0687AE 
                       EE BC 06   .dw DATA_06BCEE .db :$DATA_06BCEE 
                       36 86 06   .dw DATA_068636 .db :$DATA_068636 
                       24 EC 06   .dw DATA_06EC24 .db :$DATA_06EC24 
                       0B EB 06   .dw DATA_06EB0B .db :$DATA_06EB0B 
                       85 E9 06   .dw DATA_06E985 .db :$DATA_06E985 
                       44 E4 06   .dw DATA_06E444 .db :$DATA_06E444 
                       44 E4 06   .dw DATA_06E444 .db :$DATA_06E444 
                       4C 9D 06   .dw DATA_069D4C .db :$DATA_069D4C 
                       EA 8B 07   .dw DATA_078BEA .db :$DATA_078BEA 
                       4A 8B 07   .dw DATA_078B4A .db :$DATA_078B4A 
                       36 86 06   .dw DATA_068636 .db :$DATA_068636 
                       07 E3 06   .dw DATA_06E307 .db :$DATA_06E307 
                       E7 ED 06   .dw DATA_06EDE7 .db :$DATA_06EDE7 
                       C9 BB 06   .dw DATA_06BBC9 .db :$DATA_06BBC9 
                       36 86 06   .dw DATA_068636 .db :$DATA_068636 
                       EC C6 06   .dw DATA_06C6EC .db :$DATA_06C6EC 
                       59 C5 06   .dw DATA_06C559 .db :$DATA_06C559 
                       95 C4 06   .dw DATA_06C495 .db :$DATA_06C495 
                       D6 D1 06   .dw DATA_06D1D6 .db :$DATA_06D1D6 
                       9D 98 06   .dw DATA_06989D .db :$DATA_06989D 
                       36 86 06   .dw DATA_068636 .db :$DATA_068636 
                       B6 BD 06   .dw DATA_06BDB6 .db :$DATA_06BDB6 
                       B6 BD 06   .dw DATA_06BDB6 .db :$DATA_06BDB6 
                       36 86 06   .dw DATA_068636 .db :$DATA_068636 
                       73 94 06   .dw DATA_069473 .db :$DATA_069473 
                       4F A4 06   .dw DATA_06A44F .db :$DATA_06A44F 
                       36 86 06   .dw DATA_068636 .db :$DATA_068636 
                       9D A0 06   .dw DATA_06A09D .db :$DATA_06A09D 
                       64 9F 06   .dw DATA_069F64 .db :$DATA_069F64 
                       2E 9E 06   .dw DATA_069E2E .db :$DATA_069E2E 
                       8E 97 06   .dw DATA_06978E .db :$DATA_06978E 
                       B4 85 07   .dw DATA_0785B4 .db :$DATA_0785B4 
                       21 86 06   .dw DATA_068621 .db :$DATA_068621 
                       F2 A2 06   .dw DATA_06A2F2 .db :$DATA_06A2F2 
                       74 A3 06   .dw DATA_06A374 .db :$DATA_06A374 
                       F2 A2 06   .dw DATA_06A2F2 .db :$DATA_06A2F2 
                       FD EE 06   .dw DATA_06EEFD .db :$DATA_06EEFD 
                       21 86 06   .dw DATA_068621 .db :$DATA_068621 
                       20 A4 06   .dw DATA_06A420 .db :$DATA_06A420 
                       74 A3 06   .dw DATA_06A374 .db :$DATA_06A374 
                       DC D0 06   .dw DATA_06D0DC .db :$DATA_06D0DC 
                       1E 9B 06   .dw DATA_069B1E .db :$DATA_069B1E 
                       D0 E5 06   .dw DATA_06E5D0 .db :$DATA_06E5D0 
                       D0 E5 06   .dw DATA_06E5D0 .db :$DATA_06E5D0 
                       AB 8D 07   .dw DATA_078DAB .db :$DATA_078DAB 
                       C6 8C 07   .dw DATA_078CC6 .db :$DATA_078CC6 
                       9D 98 06   .dw DATA_06989D .db :$DATA_06989D 
                       7B 98 06   .dw DATA_06987B .db :$DATA_06987B 
                       21 86 06   .dw DATA_068621 .db :$DATA_068621 
                       15 E8 06   .dw DATA_06E815 .db :$DATA_06E815 
                       DC 93 06   .dw DATA_0693DC .db :$DATA_0693DC 
                       F0 98 06   .dw DATA_0698F0 .db :$DATA_0698F0 
                       3C 86 06   .dw DATA_06863C .db :$DATA_06863C 
                       54 86 06   .dw DATA_068654 .db :$DATA_068654 
                       FD 8F 06   .dw DATA_068FFD .db :$DATA_068FFD 
                       AD 8E 06   .dw DATA_068EAD .db :$DATA_068EAD 
                       DE 8B 06   .dw DATA_068BDE .db :$DATA_068BDE 
                       2D 80 07   .dw DATA_07802D .db :$DATA_07802D 
                       DD 88 06   .dw DATA_0688DD .db :$DATA_0688DD 
                       2F 8A 06   .dw DATA_068A2F .db :$DATA_068A2F 
                       09 AD 06   .dw DATA_06AD09 .db :$DATA_06AD09 
                       C3 80 07   .dw DATA_0780C3 .db :$DATA_0780C3 
                       17 B8 06   .dw DATA_06B817 .db :$DATA_06B817 
                       7D AE 06   .dw DATA_06AE7D .db :$DATA_06AE7D 
                       61 A4 06   .dw DATA_06A461 .db :$DATA_06A461 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 A6 07   .dw LevelDataSpr07A600 .db :$LevelDataSpr07A600 
                       F9 AB 07   .dw DATA_07ABF9 .db :$DATA_07ABF9 
                       58 9B 07   .dw DATA_079B58 .db :$DATA_079B58 
                       E2 9D 07   .dw DATA_079DE2 .db :$DATA_079DE2 
                       28 A0 07   .dw DATA_07A028 .db :$DATA_07A028 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       D6 99 07   .dw DATA_0799D6 .db :$DATA_0799D6 
                       03 98 07   .dw DATA_079803 .db :$DATA_079803 
                       CA 92 07   .dw DATA_0792CA .db :$DATA_0792CA 
                       A4 8E 07   .dw DATA_078EA4 .db :$DATA_078EA4 
                       5D F0 06   .dw DATA_06F05D .db :$DATA_06F05D 
                       5F A9 06   .dw DATA_06A95F .db :$DATA_06A95F 
                       D1 B2 06   .dw DATA_06B2D1 .db :$DATA_06B2D1 
                       00 A6 06   .dw DATA_06A600 .db :$DATA_06A600 
                       D0 86 06   .dw DATA_0686D0 .db :$DATA_0686D0 
                       E0 B4 06   .dw DATA_06B4E0 .db :$DATA_06B4E0 
                       BE DA 06   .dw DATA_06DABE .db :$DATA_06DABE 
                       3A D2 06   .dw DATA_06D23A .db :$DATA_06D23A 
                       5B DF 06   .dw DATA_06DF5B .db :$DATA_06DF5B 
                       0B D4 06   .dw DATA_06D40B .db :$DATA_06D40B 
                       2B 87 06   .dw DATA_06872B .db :$DATA_06872B 
                       83 E1 06   .dw DATA_06E183 .db :$DATA_06E183 
                       F3 D6 06   .dw DATA_06D6F3 .db :$DATA_06D6F3 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       65 BF 07   .dw DATA_07BF65 .db :$DATA_07BF65 
                       E5 BD 07   .dw DATA_07BDE5 .db :$DATA_07BDE5 
                       11 BC 07   .dw DATA_07BC11 .db :$DATA_07BC11 
                       BE BA 07   .dw DATA_07BABE .db :$DATA_07BABE 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       6B B2 07   .dw DATA_07B26B .db :$DATA_07B26B 
                       6E B4 07   .dw DATA_07B46E .db :$DATA_07B46E 
                       40 B5 07   .dw DATA_07B540 .db :$DATA_07B540 
                       08 B9 07   .dw DATA_07B908 .db :$DATA_07B908 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       25 AF 07   .dw DATA_07AF25 .db :$DATA_07AF25 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       E3 AF 07   .dw DATA_07AFE3 .db :$DATA_07AFE3 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       35 AD 07   .dw DATA_07AD35 .db :$DATA_07AD35 
                       31 B0 07   .dw DATA_07B031 .db :$DATA_07B031 
                       24 B1 07   .dw DATA_07B124 .db :$DATA_07B124 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       8B 85 06   .dw DATA_06858B .db :$DATA_06858B 
                       61 85 06   .dw DATA_068561 .db :$DATA_068561 
                       58 82 06   .dw DATA_068258 .db :$DATA_068258 
                       5E 82 06   .dw DATA_06825E .db :$DATA_06825E 
                       5E 82 06   .dw DATA_06825E .db :$DATA_06825E 
                       58 82 06   .dw DATA_068258 .db :$DATA_068258 
                       58 82 06   .dw DATA_068258 .db :$DATA_068258 
                       58 82 06   .dw DATA_068258 .db :$DATA_068258 
                       52 82 06   .dw DATA_068252 .db :$DATA_068252 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       00 80 06   .dw DATA_068000 .db :$DATA_068000 
                       C1 9A 07   .dw DATA_079AC1 .db :$DATA_079AC1 
                       42 D9 06   .dw DATA_06D942 .db :$DATA_06D942 
                       C9 AA 07   .dw DATA_07AAC9 .db :$DATA_07AAC9 
                       B1 8F 06   .dw DATA_068FB1 .db :$DATA_068FB1 
                       84 9D 07   .dw DATA_079D84 .db :$DATA_079D84 
                       11 F5 06   .dw LevelData .db :$LevelData 
                       28 E1 06   .dw DATA_06E128 .db :$DATA_06E128 
                       B5 B1 06   .dw DATA_06B1B5 .db :$DATA_06B1B5 
                       A8 AC 06   .dw DATA_06ACA8 .db :$DATA_06ACA8 
                       C6 B3 07   .dw DATA_07B3C6 .db :$DATA_07B3C6 
                       C6 B3 07   .dw DATA_07B3C6 .db :$DATA_07B3C6 
                       6D A5 06   .dw DATA_06A56D .db :$DATA_06A56D 
                       2F AD 07   .dw DATA_07AD2F .db :$DATA_07AD2F 
                       96 B8 07   .dw DATA_07B896 .db :$DATA_07B896 
                       7D B8 07   .dw DATA_07B87D .db :$DATA_07B87D 
                       B3 8B 06   .dw DATA_068BB3 .db :$DATA_068BB3 
                       F8 89 06   .dw DATA_0689F8 .db :$DATA_0689F8 
                       77 AA 07   .dw DATA_07AA77 .db :$DATA_07AA77 
                       16 AA 07   .dw DATA_07AA16 .db :$DATA_07AA16 
                       61 A9 07   .dw DATA_07A961 .db :$DATA_07A961 
                       D9 A8 07   .dw DATA_07A8D9 .db :$DATA_07A8D9 
                       3F A8 07   .dw DATA_07A83F .db :$DATA_07A83F 
                       02 A8 07   .dw DATA_07A802 .db :$DATA_07A802 
                       65 A7 07   .dw DATA_07A765 .db :$DATA_07A765 
                       07 A7 07   .dw DATA_07A707 .db :$DATA_07A707 
                       8E A6 07   .dw DATA_07A68E .db :$DATA_07A68E 
                       CE AF 07   .dw DATA_07AFCE .db :$DATA_07AFCE 
                       16 AF 07   .dw DATA_07AF16 .db :$DATA_07AF16 
                       38 88 06   .dw DATA_068838 .db :$DATA_068838 
                       F3 87 06   .dw DATA_0687F3 .db :$DATA_0687F3 
                       03 98 07   .dw DATA_079803 .db :$DATA_079803 
                       21 86 06   .dw DATA_068621 .db :$DATA_068621 
                       69 99 07   .dw DATA_079969 .db :$DATA_079969 
                       69 99 07   .dw DATA_079969 .db :$DATA_079969 
                       67 98 07   .dw DATA_079867 .db :$DATA_079867 
                       36 86 06   .dw DATA_068636 .db :$DATA_068636 
                       04 E1 06   .dw DATA_06E104 .db :$DATA_06E104 
                       8A BD 07   .dw DATA_07BD8A .db :$DATA_07BD8A 
                       75 BD 07   .dw DATA_07BD75 .db :$DATA_07BD75 
                       F0 95 07   .dw DATA_0795F0 .db :$DATA_0795F0 
                       E2 93 07   .dw DATA_0793E2 .db :$DATA_0793E2 
                       33 92 07   .dw DATA_079233 .db :$DATA_079233 
                       21 92 07   .dw DATA_079221 .db :$DATA_079221 
                       46 DF 06   .dw DATA_06DF46 .db :$DATA_06DF46 
                       21 86 06   .dw DATA_068621 .db :$DATA_068621 
                       BE DA 06   .dw DATA_06DABE .db :$DATA_06DABE 
                       BE DA 06   .dw DATA_06DABE .db :$DATA_06DABE 
                       18 AE 06   .dw DATA_06AE18 .db :$DATA_06AE18 
                       87 86 06   .dw DATA_068687 .db :$DATA_068687 
                       5D F3 06   .dw DATA_06F35D .db :$DATA_06F35D 
                       64 F1 06   .dw DATA_06F164 .db :$DATA_06F164 
                       FC F4 06   .dw DATA_06F4FC .db :$DATA_06F4FC 
                       E9 A8 06   .dw DATA_06A8E9 .db :$DATA_06A8E9 
                       33 BA 06   .dw DATA_06BA33 .db :$DATA_06BA33 
                       06 BA 06   .dw DATA_06BA06 .db :$DATA_06BA06 
                       ED B7 06   .dw DATA_06B7ED .db :$DATA_06B7ED 
                       66 B6 06   .dw DATA_06B666 .db :$DATA_06B666 
                       20 B6 06   .dw DATA_06B620 .db :$DATA_06B620 
                       22 B4 06   .dw DATA_06B422 .db :$DATA_06B422 
                       87 86 06   .dw DATA_068687 .db :$DATA_068687 
                       3A B2 06   .dw DATA_06B23A .db :$DATA_06B23A 
                       14 D9 06   .dw DATA_06D914 .db :$DATA_06D914 
                       21 86 06   .dw DATA_068621 .db :$DATA_068621 
                       D2 DE 06   .dw DATA_06DED2 .db :$DATA_06DED2 
                       09 AD 06   .dw DATA_06AD09 .db :$DATA_06AD09 
                       6F 91 06   .dw DATA_06916F .db :$DATA_06916F 
                       6D 8E 06   .dw DATA_068E6D .db :$DATA_068E6D 
                       22 9F 07   .dw DATA_079F22 .db :$DATA_079F22 
                       93 8F 06   .dw DATA_068F93 .db :$DATA_068F93 

Layer2Ptrs:            74 E6 FF   .dw DATA_0CE674 .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       82 EC FF   .dw DATA_0CEC82 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       82 EC FF   .dw DATA_0CEC82 .db $FF   
                       54 DE FF   .dw DATA_0CDE54 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       6D 95 06   .dw DATA_06956D .db :$DATA_06956D 
                       B9 DA FF   .dw DATA_0CDAB9 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       6E C4 06   .dw DATA_06C46E .db :$DATA_06C46E 
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       B9 DA FF   .dw DATA_0CDAB9 .db $FF   
                       54 DE FF   .dw DATA_0CDE54 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       54 DE FF   .dw DATA_0CDE54 .db $FF   
                       54 DE FF   .dw DATA_0CDE54 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       B9 DA FF   .dw DATA_0CDAB9 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       1D 8B 07   .dw DATA_078B1D .db :$DATA_078B1D 
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       C0 E7 FF   .dw DATA_0CE7C0 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       03 E1 FF   .dw DATA_0CE103 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       54 DE FF   .dw DATA_0CDE54 .db $FF   
                       C0 E7 FF   .dw DATA_0CE7C0 .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       54 DE FF   .dw DATA_0CDE54 .db $FF   
                       1B 86 06   .dw DATA_06861B .db :$DATA_06861B 
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       72 E4 FF   .dw DATA_0CE472 .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       84 E6 FF   .dw DATA_0CE684 .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       54 DE FF   .dw DATA_0CDE54 .db $FF   
                       54 DE FF   .dw DATA_0CDE54 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       B7 8B 07   .dw DATA_078BB7 .db :$DATA_078BB7 
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       14 C5 06   .dw DATA_06C514 .db :$DATA_06C514 
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       54 DE FF   .dw DATA_0CDE54 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       BF 9E 06   .dw DATA_069EBF .db :$DATA_069EBF 
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       1B 86 06   .dw DATA_06861B .db :$DATA_06861B 
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       1B 86 06   .dw DATA_06861B .db :$DATA_06861B 
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       54 DE FF   .dw DATA_0CDE54 .db $FF   
                       54 DE FF   .dw DATA_0CDE54 .db $FF   
                       EE E8 FF   .dw DATA_0CE8EE .db $FF   
                       75 F1 FF   .dw DATA_0CF175 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       1B 86 06   .dw DATA_06861B .db :$DATA_06861B 
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       54 DE FF   .dw DATA_0CDE54 .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       03 E1 FF   .dw DATA_0CE103 .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       82 EC FF   .dw DATA_0CEC82 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       C0 E7 FF   .dw DATA_0CE7C0 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       03 E1 FF   .dw DATA_0CE103 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       34 A1 07   .dw DATA_07A134 .db :$DATA_07A134 
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       7C 93 07   .dw DATA_07937C .db :$DATA_07937C 
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       84 E6 FF   .dw DATA_0CE684 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       8D DB 06   .dw DATA_06DB8D .db :$DATA_06DB8D 
                       82 EC FF   .dw DATA_0CEC82 .db $FF   
                       82 EC FF   .dw DATA_0CEC82 .db $FF   
                       B9 DA FF   .dw DATA_0CDAB9 .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       82 EC FF   .dw DATA_0CEC82 .db $FF   
                       82 EC FF   .dw DATA_0CEC82 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       71 DC FF   .dw DATA_0CDC71 .db $FF   
                       82 EC FF   .dw DATA_0CEC82 .db $FF   
                       C0 E7 FF   .dw DATA_0CE7C0 .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       72 E4 FF   .dw DATA_0CE472 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       B9 DA FF   .dw DATA_0CDAB9 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       84 E6 FF   .dw DATA_0CE684 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       84 E6 FF   .dw DATA_0CE684 .db $FF   
                       84 E6 FF   .dw DATA_0CE684 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   
                       B9 DA FF   .dw DATA_0CDAB9 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       00 D9 FF   .dw DATA_0CD900 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       03 E1 FF   .dw DATA_0CE103 .db $FF   
                       E3 A9 07   .dw DATA_07A9E3 .db :$DATA_07A9E3 
                       34 A9 07   .dw DATA_07A934 .db :$DATA_07A934 
                       03 E1 FF   .dw DATA_0CE103 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       03 E1 FF   .dw DATA_0CE103 .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       1B 86 06   .dw DATA_06861B .db :$DATA_06861B 
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       44 DD FF   .dw DATA_0CDD44 .db $FF   
                       C0 E7 FF   .dw DATA_0CE7C0 .db $FF   
                       5E 97 07   .dw DATA_07975E .db :$DATA_07975E 
                       A5 95 07   .dw DATA_0795A5 .db :$DATA_0795A5 
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       1B 86 06   .dw DATA_06861B .db :$DATA_06861B 
                       1B 86 06   .dw DATA_06861B .db :$DATA_06861B 
                       8D DB 06   .dw DATA_06DB8D .db :$DATA_06DB8D 
                       8D DB 06   .dw DATA_06DB8D .db :$DATA_06DB8D 
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       2A F4 06   .dw DATA_06F42A .db :$DATA_06F42A 
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       3E A9 06   .dw ADDR_06A93E .db :$ADDR_06A93E 
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       4B B7 06   .dw DATA_06B74B .db :$DATA_06B74B 
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       74 E6 FF   .dw DATA_0CE674 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       1B 86 06   .dw DATA_06861B .db :$DATA_06861B 
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       80 EF FF   .dw DATA_0CEF80 .db $FF   
                       03 E1 FF   .dw DATA_0CE103 .db $FF   
                       FE E8 FF   .dw DATA_0CE8FE .db $FF   
                       5A F4 FF   .dw DATA_0CF45A .db $FF   
                       59 DF FF   .dw DATA_0CDF59 .db $FF   

Ptrs05EC00:            07 C4      .dw DATA_07C407           
                       1C CE      .dw DATA_07CE1C           
                       BF CE      .dw DATA_07CEBF           
                       C5 C4      .dw DATA_07C4C5           
                       B5 C7      .dw DATA_07C7B5           
                       D9 C7      .dw DATA_07C7D9           
                       44 C8      .dw DATA_07C844           
                       04 C9      .dw DATA_07C904           
                       9D C4      .dw DATA_07C49D           
                       51 C7      .dw DATA_07C751           
                       48 C9      .dw DATA_07C948           
                       06 CF      .dw DATA_07CF06           
                       F5 D1      .dw DATA_07D1F5           
                       5A D2      .dw DATA_07D25A           
                       D7 D0      .dw DATA_07D0D7           
                       AF CF      .dw DATA_07CFAF           
                       43 D0      .dw DATA_07D043           
                       57 D1      .dw DATA_07D157           
                       6D E7      .dw DATA_07E76D           
                       CA C9      .dw DATA_07C9CA           
                       46 C4      .dw DATA_07C446           
                       D5 C6      .dw DATA_07C6D5           
                       D5 C6      .dw DATA_07C6D5           
                       D5 C6      .dw DATA_07C6D5           
                       2D DC      .dw DATA_07DC2D           
                       6D E7      .dw DATA_07E76D           
                       BB DB      .dw DATA_07DBBB           
                       5E D9      .dw DATA_07D95E           
                       0F DB      .dw DATA_07DB0F           
                       93 DA      .dw DATA_07DA93           
                       6D E7      .dw DATA_07E76D           
                       48 D6      .dw DATA_07D648           
                       CD D4      .dw DATA_07D4CD           
                       4C D7      .dw DATA_07D74C           
                       D9 D6      .dw DATA_07D6D9           
                       BE D8      .dw DATA_07D8BE           
                       BF D7      .dw DATA_07D7BF           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       DB C3      .dw DATA_07C3DB           
                       E3 C3      .dw DATA_07C3E3           
                       67 C3      .dw DATA_07C367           
                       59 C3      .dw DATA_07C359           
                       54 C3      .dw DATA_07C354           
                       4F C3      .dw DATA_07C34F           
                       4A C3      .dw DATA_07C34A           
                       45 C3      .dw DATA_07C345           
                       40 C3      .dw DATA_07C340           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       EE C3      .dw DATA_07C3EE           
                       41 D7      .dw DATA_07D741           
                       2F D0      .dw DATA_07D02F           
                       95 DB      .dw DATA_07DB95           
                       CF D0      .dw DATA_07D0CF           
                       AA C9      .dw DATA_07C9AA           
                       EA C8      .dw DATA_07C8EA           
                       F5 C3      .dw DATA_07C3F5           
                       41 C4      .dw DATA_07C441           
                       F0 C3      .dw DATA_07C3F0           
                       27 C4      .dw DATA_07C427           
                       CF DD      .dw DATA_07DDCF           
                       C0 C4      .dw DATA_07C4C0           
                       4B C4      .dw DATA_07C44B           
                       F0 C3      .dw DATA_07C3F0           
                       1D D5      .dw DATA_07D51D           
                       99 D8      .dw DATA_07D899           
                       4B D8      .dw DATA_07D84B           
                       E5 D7      .dw DATA_07D7E5           
                       D9 D6      .dw DATA_07D6D9           
                       D9 D6      .dw DATA_07D6D9           
                       CD C8      .dw DATA_07C8CD           
                       22 DC      .dw DATA_07DC22           
                       F9 DB      .dw DATA_07DBF9           
                       14 C4      .dw DATA_07C414           
                       68 D6      .dw DATA_07D668           
                       56 D9      .dw DATA_07D956           
                       BA CE      .dw DATA_07CEBA           
                       52 D1      .dw DATA_07D152           
                       EE C3      .dw DATA_07C3EE           
                       11 D1      .dw DATA_07D111           
                       F4 D0      .dw DATA_07D0F4           
                       04 D3      .dw DATA_07D304           
                       BD C7      .dw DATA_07C7BD           
                       14 C4      .dw DATA_07C414           
                       4D CF      .dw DATA_07CF4D           
                       4D CF      .dw DATA_07CF4D           
                       14 C4      .dw DATA_07C414           
                       49 C7      .dw DATA_07C749           
                       0C CA      .dw DATA_07CA0C           
                       43 C9      .dw DATA_07C943           
                       EE C3      .dw DATA_07C3EE           
                       26 C9      .dw DATA_07C926           
                       15 C9      .dw DATA_07C915           
                       A7 C7      .dw DATA_07C7A7           
                       DD DA      .dw DATA_07DADD           
                       0C C4      .dw DATA_07C40C           
                       CA C9      .dw DATA_07C9CA           
                       DB C9      .dw DATA_07C9DB           
                       CA C9      .dw DATA_07C9CA           
                       B1 D9      .dw DATA_07D9B1           
                       F5 C3      .dw DATA_07C3F5           
                       F2 C9      .dw DATA_07C9F2           
                       DB C9      .dw DATA_07C9DB           
                       F0 C3      .dw DATA_07C3F0           
                       EE C3      .dw DATA_07C3EE           
                       D9 D6      .dw DATA_07D6D9           
                       D9 D6      .dw DATA_07D6D9           
                       61 DC      .dw DATA_07DC61           
                       3B DC      .dw DATA_07DC3B           
                       BD C7      .dw DATA_07C7BD           
                       EE C3      .dw DATA_07C3EE           
                       F5 C3      .dw DATA_07C3F5           
                       99 D7      .dw DATA_07D799           
                       EE C3      .dw DATA_07C3EE           
                       CB C7      .dw DATA_07C7CB           
                       F0 C3      .dw DATA_07C3F0           
                       07 C4      .dw DATA_07C407           
                       6F C6      .dw DATA_07C66F           
                       F4 C5      .dw DATA_07C5F4           
                       93 C5      .dw DATA_07C593           
                       59 E7      .dw DATA_07E759           
                       CA C4      .dw DATA_07C4CA           
                       32 C5      .dw DATA_07C532           
                       DC CB      .dw DATA_07CBDC           
                       6D E7      .dw DATA_07E76D           
                       C8 CD      .dw DATA_07CDC8           
                       25 CC      .dw DATA_07CC25           
                       17 CA      .dw DATA_07CA17           
                       6D E7      .dw DATA_07E76D           
                       22 C4      .dw DATA_07C422           
                       9D E1      .dw DATA_07E19D           
                       08 DF      .dw DATA_07DF08           
                       B1 DF      .dw DATA_07DFB1           
                       32 E0      .dw DATA_07E032           
                       6D E7      .dw DATA_07E76D           
                       4F DE      .dw DATA_07DE4F           
                       01 DE      .dw DATA_07DE01           
                       7B DD      .dw DATA_07DD7B           
                       14 DD      .dw DATA_07DD14           
                       EF D9      .dw DATA_07D9EF           
                       2A CB      .dw DATA_07CB2A           
                       D4 CC      .dw DATA_07CCD4           
                       87 CA      .dw DATA_07CA87           
                       50 C4      .dw DATA_07C450           
                       68 CD      .dw DATA_07CD68           
                       22 D5      .dw DATA_07D522           
                       0C D3      .dw DATA_07D30C           
                       77 D5      .dw DATA_07D577           
                       80 D3      .dw DATA_07D380           
                       78 C4      .dw DATA_07C478           
                       F5 D5      .dw DATA_07D5F5           
                       45 D4      .dw DATA_07D445           
                       6D E7      .dw DATA_07E76D           
                       F4 E6      .dw DATA_07E6F4           
                       50 E6      .dw DATA_07E650           
                       DF E5      .dw DATA_07E5DF           
                       74 E5      .dw DATA_07E574           
                       6D E7      .dw DATA_07E76D           
                       DC E3      .dw DATA_07E3DC           
                       28 E4      .dw DATA_07E428           
                       66 E4      .dw DATA_07E466           
                       F1 E4      .dw DATA_07E4F1           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       21 E2      .dw DATA_07E221           
                       6D E7      .dw DATA_07E76D           
                       9E E2      .dw DATA_07E29E           
                       6D E7      .dw DATA_07E76D           
                       C5 E1      .dw DATA_07E1C5           
                       AF E2      .dw DATA_07E2AF           
                       35 E3      .dw DATA_07E335           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       E3 C3      .dw DATA_07C3E3           
                       DB C3      .dw DATA_07C3DB           
                       67 C3      .dw DATA_07C367           
                       59 C3      .dw DATA_07C359           
                       54 C3      .dw DATA_07C354           
                       4F C3      .dw DATA_07C34F           
                       4A C3      .dw DATA_07C34A           
                       45 C3      .dw DATA_07C345           
                       40 C3      .dw DATA_07C340           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       6D E7      .dw DATA_07E76D           
                       EE C3      .dw DATA_07C3EE           
                       EE C3      .dw DATA_07C3EE           
                       9D E1      .dw DATA_07E19D           
                       61 C6      .dw DATA_07C661           
                       94 DF      .dw DATA_07DF94           
                       7F DA      .dw DATA_07DA7F           
                       CF D5      .dw DATA_07D5CF           
                       BA CC      .dw DATA_07CCBA           
                       C5 CB      .dw DATA_07CBC5           
                       02 E4      .dw DATA_07E402           
                       02 E4      .dw DATA_07E402           
                       6D CA      .dw DATA_07CA6D           
                       C0 E1      .dw DATA_07E1C0           
                       EC E4      .dw DATA_07E4EC           
                       EE C3      .dw DATA_07C3EE           
                       7F C5      .dw DATA_07C57F           
                       EE C3      .dw DATA_07C3EE           
                       83 E1      .dw DATA_07E183           
                       60 E1      .dw DATA_07E160           
                       31 E1      .dw DATA_07E131           
                       14 E1      .dw DATA_07E114           
                       22 C4      .dw DATA_07C422           
                       E8 E0      .dw DATA_07E0E8           
                       C5 E0      .dw DATA_07E0C5           
                       8D E0      .dw DATA_07E08D           
                       67 E0      .dw DATA_07E067           
                       F0 C3      .dw DATA_07C3F0           
                       F0 C3      .dw DATA_07C3F0           
                       98 C4      .dw DATA_07C498           
                       73 C4      .dw DATA_07C473           
                       01 DE      .dw DATA_07DE01           
                       F5 C3      .dw DATA_07C3F5           
                       3B DE      .dw DATA_07DE3B           
                       3B DE      .dw DATA_07DE3B           
                       0F DE      .dw DATA_07DE0F           
                       14 C4      .dw DATA_07C414           
                       C7 D5      .dw DATA_07D5C7           
                       EE C3      .dw DATA_07C3EE           
                       F0 C3      .dw DATA_07C3F0           
                       B8 DD      .dw DATA_07DDB8           
                       B3 DD      .dw DATA_07DDB3           
                       EE C3      .dw DATA_07C3EE           
                       76 DD      .dw DATA_07DD76           
                       F5 C3      .dw DATA_07C3F5           
                       0C C4      .dw DATA_07C40C           
                       22 D5      .dw DATA_07D522           
                       22 D5      .dw DATA_07D522           
                       11 CC      .dw DATA_07CC11           
                       24 E0      .dw DATA_07E024           
                       44 DA      .dw DATA_07DA44           
                       12 DA      .dw DATA_07DA12           
                       F0 C3      .dw DATA_07C3F0           
                       01 CB      .dw DATA_07CB01           
                       14 CE      .dw DATA_07CE14           
                       0C CE      .dw DATA_07CE0C           
                       C0 CD      .dw DATA_07CDC0           
                       94 CD      .dw DATA_07CD94           
                       EE C3      .dw DATA_07C3EE           
                       63 CD      .dw DATA_07CD63           
                       D0 C6      .dw DATA_07C6D0           
                       EE C3      .dw DATA_07C3EE           
                       C5 D4      .dw DATA_07D4C5           
                       F5 C3      .dw DATA_07C3F5           
                       6C D5      .dw DATA_07D56C           
                       DC CB      .dw DATA_07CBDC           
                       BF C6      .dw DATA_07C6BF           
                       EF C5      .dw DATA_07C5EF           
                       E0 DF      .dw DATA_07DFE0           
                       59 C6      .dw DATA_07C659           

DATA_05F000:                      .db $07,$5B,$19,$2B,$1B,$5B,$5B,$5B
                                  .db $27,$37,$18,$19,$59,$5B,$29,$1B
                                  .db $5B,$58,$05,$5B,$2B,$5B,$1B,$1B
                                  .db $51,$0B,$4B,$1B,$07,$52,$0B,$1B
                                  .db $57,$1B,$5B,$5B,$5B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$57,$57,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$6C,$18,$19
                                  .db $1A,$51,$0D,$1A,$2B,$5B,$1B,$5A
                                  .db $6B,$2B,$2B,$18,$0B,$1B,$1B,$5B
                                  .db $59,$58,$19,$57,$49,$0B,$5B,$52
                                  .db $19,$0B,$6C,$0C,$48,$18,$5A,$0B
                                  .db $59,$59,$0B,$5A,$2A,$0B,$6C,$7D
                                  .db $5B,$5A,$00,$2B,$5B,$5B,$5B,$17
                                  .db $2B,$5B,$58,$18,$6C,$59,$58,$01
                                  .db $17,$5B,$1B,$2B,$1B,$6C,$5A,$2A
                                  .db $07,$1B,$18,$5B,$0B,$5B,$5B,$5B
                                  .db $0B,$0D,$58,$5B,$0B,$1A,$1B,$58
                                  .db $5B,$48,$0B,$1B,$0A,$4B,$5B,$57
                                  .db $52,$17,$57,$2B,$17,$29,$1C,$5B
                                  .db $59,$2B,$56,$1C,$0B,$5B,$1C,$1B
                                  .db $1A,$0B,$05,$58,$5B,$19,$0B,$0B
                                  .db $58,$0B,$5B,$0B,$01,$5B,$5B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$57,$57,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$6C,$6C,$1B,$5A,$16
                                  .db $1A,$19,$16,$16,$58,$5C,$1A,$0B
                                  .db $5D,$19,$19,$19,$1B,$1B,$73,$4B
                                  .db $1A,$59,$59,$1B,$1B,$1B,$1B,$2B
                                  .db $2B,$09,$2B,$0B,$0B,$09,$0B,$29
                                  .db $52,$1B,$48,$4B,$6C,$5B,$2B,$2B
                                  .db $2B,$29,$5B,$0B,$4B,$01,$5B,$49
                                  .db $1B,$1B,$57,$48,$1B,$19,$0B,$6C
                                  .db $28,$2B,$1B,$5A,$1B,$19,$19,$1B
DATA_05F200:                      .db $20,$00,$80,$01,$00,$01,$00,$00
                                  .db $00,$C0,$38,$39,$00,$00,$00,$00
                                  .db $00,$F8,$00,$00,$00,$00,$00,$00
                                  .db $F8,$00,$C0,$00,$00,$01,$00,$80
                                  .db $01,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$01,$01,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$10,$A0,$20
                                  .db $18,$A0,$18,$18,$00,$01,$18,$00
                                  .db $01,$10,$10,$10,$00,$10,$10,$10
                                  .db $31,$30,$20,$01,$C0,$00,$00,$18
                                  .db $20,$00,$10,$01,$C1,$20,$01,$00
                                  .db $39,$39,$00,$18,$00,$00,$10,$C0
                                  .db $01,$18,$01,$00,$00,$03,$03,$00
                                  .db $00,$01,$00,$10,$10,$31,$30,$20
                                  .db $38,$00,$00,$00,$00,$10,$01,$18
                                  .db $20,$00,$80,$00,$01,$00,$00,$00
                                  .db $00,$01,$00,$28,$00,$00,$00,$00
                                  .db $01,$C0,$00,$00,$00,$C0,$00,$00
                                  .db $01,$00,$00,$00,$01,$00,$00,$00
                                  .db $38,$00,$00,$00,$00,$00,$00,$40
                                  .db $00,$00,$01,$01,$00,$28,$00,$00
                                  .db $F8,$00,$00,$00,$01,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$01,$01,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$10,$10,$00,$18,$28
                                  .db $18,$F8,$28,$28,$1B,$19,$18,$00
                                  .db $00,$20,$20,$20,$00,$00,$F8,$C0
                                  .db $00,$00,$00,$00,$80,$18,$10,$10
                                  .db $10,$03,$00,$03,$00,$01,$00,$20
                                  .db $18,$10,$D1,$D1,$10,$18,$00,$00
                                  .db $01,$01,$01,$00,$D1,$10,$10,$D0
                                  .db $09,$11,$01,$C0,$00,$20,$00,$10
                                  .db $20,$00,$01,$01,$80,$20,$00,$10
DATA_05F400:                      .db $0A,$9A,$8A,$0A,$0A,$AA,$AA,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$9A,$0A,$9A
                                  .db $9A,$0A,$02,$0A,$0A,$9A,$9A,$9A
                                  .db $03,$0A,$BA,$8A,$BA,$00,$0A,$0A
                                  .db $0A,$0A,$9A,$9A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$00,$00,$00
                                  .db $00,$00,$00,$00,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$09,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$00,$0A,$0A,$0A
                                  .db $9A,$9A,$0A,$0A,$0B,$00,$0A,$03
                                  .db $0A,$00,$0A,$0A,$0A,$0A,$0A,$00
                                  .db $0A,$0A,$00,$0A,$0A,$00,$0A,$03
                                  .db $0A,$0A,$00,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$03
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$7A,$0A,$9A,$0A,$9A,$9A,$0A
                                  .db $0A,$02,$FA,$0A,$0A,$0A,$6A,$9A
                                  .db $7A,$0A,$0A,$8A,$0A,$7A,$9A,$7A
                                  .db $A0,$9A,$FA,$0A,$9A,$0A,$9A,$9A
                                  .db $0A,$0A,$05,$9A,$0A,$0A,$9A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$03,$9A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$00,$00,$00
                                  .db $00,$00,$00,$00,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$00
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$03,$0A
                                  .db $0A,$09,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$00,$0A
                                  .db $03,$0A,$0B,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$00,$0A,$03,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$00,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
DATA_05F600:                      .db $00,$00,$80,$00,$00,$80,$00,$00
                                  .db $00,$00,$00,$00,$80,$80,$00,$80
                                  .db $00,$00,$64,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$80,$80,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$03,$64,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $10,$07,$00,$00,$00,$00,$00,$00
                                  .db $04,$00,$00,$64,$09,$00,$01,$00
                                  .db $04,$00,$00,$00,$00,$00,$00,$67
                                  .db $02,$00,$60,$00,$02,$04,$04,$00
                                  .db $00,$01,$00,$00,$00,$10,$07,$60
                                  .db $00,$00,$00,$00,$00,$00,$01,$00
                                  .db $00,$00,$80,$80,$00,$00,$00,$00
                                  .db $00,$66,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$80,$00,$00,$00,$00
                                  .db $00,$80,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$80,$00,$00,$00,$00,$00
                                  .db $00,$00,$E4,$00,$80,$00,$00,$00
                                  .db $80,$00,$80,$00,$E0,$80,$80,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$03
                                  .db $00,$03,$00,$00,$01,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$64,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$03,$00,$03,$00,$03,$00,$00
                                  .db $00,$00,$01,$00,$00,$00,$00,$00
                                  .db $07,$06,$00,$00,$00,$60,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$05,$00,$00,$00,$00
DATA_05F800:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$0F
                                  .db $1C,$10,$0A,$06,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$06,$00,$00,$00,$00,$23
                                  .db $01,$00,$00,$00,$00,$0D,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$1D,$00,$00,$00,$00,$14
                                  .db $00,$00,$00,$00,$05,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$15,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$13,$23,$00,$02,$0F
                                  .db $17,$1F,$00,$18,$00,$00,$0B,$00
                                  .db $00,$2C,$06,$05,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $27,$00,$00,$00,$16,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$1A
                                  .db $00,$00,$00,$00,$00,$19,$00,$0A
                                  .db $23,$00,$00,$00,$00,$03,$00,$00
DATA_05FA00:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$AB
                                  .db $A9,$C2,$A6,$AA,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$AA,$02
                                  .db $AA,$00,$A8,$00,$00,$00,$00,$A8
                                  .db $A8,$AA,$00,$AA,$00,$AB,$A9,$00
                                  .db $00,$AB,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$02,$00,$00,$00,$00,$AB
                                  .db $AA,$00,$00,$00,$A9,$00,$AA,$AB
                                  .db $00,$00,$00,$00,$00,$A9,$00,$AB
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$A8,$AA,$00,$AB,$A9
                                  .db $A7,$AA,$00,$AA,$00,$00,$A7,$00
                                  .db $00,$AB,$AB,$A9,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $AA,$00,$00,$00,$A8,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$A7
                                  .db $00,$00,$00,$00,$00,$AB,$00,$AB
                                  .db $AA,$00,$00,$00,$00,$A9,$00,$00
DATA_05FC00:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$0E
                                  .db $2A,$25,$64,$04,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$21,$68
                                  .db $26,$00,$08,$00,$00,$00,$00,$6D
                                  .db $70,$2B,$00,$0D,$00,$2D,$27,$00
                                  .db $00,$2D,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$6A,$00,$00,$00,$00,$02
                                  .db $6A,$00,$00,$00,$70,$00,$0E,$21
                                  .db $00,$00,$00,$00,$00,$2B,$00,$0A
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$08,$04,$00,$05,$03
                                  .db $26,$68,$00,$30,$00,$00,$2A,$00
                                  .db $00,$69,$70,$08,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $2A,$00,$00,$00,$29,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$2E
                                  .db $00,$00,$00,$00,$00,$2F,$00,$2F
                                  .db $32,$00,$00,$00,$00,$28,$00,$00
DATA_05FE00:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$03
                                  .db $03,$03,$07,$03,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$03,$01
                                  .db $03,$00,$06,$00,$00,$00,$00,$04
                                  .db $06,$03,$00,$03,$00,$03,$00,$00
                                  .db $00,$03,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$03,$00,$00,$00,$00,$00
                                  .db $03,$00,$00,$00,$03,$00,$03,$02
                                  .db $00,$00,$00,$00,$00,$04,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$04,$03,$00,$03,$03
                                  .db $04,$03,$00,$03,$00,$00,$05,$00
                                  .db $00,$03,$03,$06,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $03,$00,$00,$00,$03,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$02
                                  .db $00,$00,$00,$00,$00,$03,$00,$02
                                  .db $03,$00,$00,$00,$00,$03,$00,$00