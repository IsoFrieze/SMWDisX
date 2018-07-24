DATA_038000:                      .db $13,$14,$15,$16,$17,$18,$19

DATA_038007:                      .db $F0,$F8,$FC,$00,$04,$08,$10

DATA_03800E:                      .db $A0,$D0,$C0,$D0

Football:           22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_038016:        A5 9D         LDA RAM_SpritesLocked     
CODE_038018:        D0 6C         BNE Return038086          
CODE_03801A:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_03801D:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_038021:        BD 40 15      LDA.W $1540,X             
CODE_038024:        F0 07         BEQ CODE_03802D           
CODE_038026:        3A            DEC A                     
CODE_038027:        D0 08         BNE CODE_038031           
CODE_038029:        22 6F AB 01   JSL.L CODE_01AB6F         
CODE_03802D:        22 2A 80 01   JSL.L UpdateSpritePos     
CODE_038031:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not touching object 
CODE_038034:        29 03         AND.B #$03                ;  | 
CODE_038036:        F0 07         BEQ CODE_03803F           ; / 
CODE_038038:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_03803A:        49 FF         EOR.B #$FF                
CODE_03803C:        1A            INC A                     
CODE_03803D:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03803F:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_038042:        29 08         AND.B #$08                
CODE_038044:        F0 02         BEQ CODE_038048           
CODE_038046:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_038048:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_03804B:        29 04         AND.B #$04                ;  | 
CODE_03804D:        F0 37         BEQ Return038086          ; / 
CODE_03804F:        BD 40 15      LDA.W $1540,X             
CODE_038052:        D0 32         BNE Return038086          
CODE_038054:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_038057:        49 40         EOR.B #$40                
CODE_038059:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_03805C:        22 F9 AC 01   JSL.L GetRand             
CODE_038060:        29 03         AND.B #$03                
CODE_038062:        A8            TAY                       
CODE_038063:        B9 0E 80      LDA.W DATA_03800E,Y       
CODE_038066:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_038068:        BC B8 15      LDY.W $15B8,X             
CODE_03806B:        C8            INY                       
CODE_03806C:        C8            INY                       
CODE_03806D:        C8            INY                       
CODE_03806E:        B9 07 80      LDA.W DATA_038007,Y       
CODE_038071:        18            CLC                       
CODE_038072:        75 B6         ADC RAM_SpriteSpeedX,X    
CODE_038074:        10 08         BPL CODE_03807E           
CODE_038076:        C9 E0         CMP.B #$E0                
CODE_038078:        B0 0A         BCS CODE_038084           
CODE_03807A:        A9 E0         LDA.B #$E0                
CODE_03807C:        80 06         BRA CODE_038084           

CODE_03807E:        C9 20         CMP.B #$20                
CODE_038080:        90 02         BCC CODE_038084           
ADDR_038082:        A9 20         LDA.B #$20                
CODE_038084:        95 B6         STA RAM_SpriteSpeedX,X    
Return038086:       60            RTS                       ; Return 

BigBooBoss:         22 98 83 03   JSL.L CODE_038398         
CODE_03808B:        22 39 82 03   JSL.L CODE_038239         
CODE_03808F:        BD C8 14      LDA.W $14C8,X             
CODE_038092:        D0 0E         BNE CODE_0380A2           
CODE_038094:        EE C6 13      INC.W $13C6               
CODE_038097:        A9 FF         LDA.B #$FF                
CODE_038099:        8D 93 14      STA.W $1493               
CODE_03809C:        A9 0B         LDA.B #$0B                
CODE_03809E:        8D FB 1D      STA.W $1DFB               ; / Change music 
Return0380A1:       60            RTS                       ; Return 

CODE_0380A2:        C9 08         CMP.B #$08                
CODE_0380A4:        D0 2E         BNE Return0380D4          
CODE_0380A6:        A5 9D         LDA RAM_SpritesLocked     
CODE_0380A8:        D0 2A         BNE Return0380D4          
CODE_0380AA:        B5 C2         LDA RAM_SpriteState,X     
CODE_0380AC:        22 DF 86 00   JSL.L ExecutePtr          

BooBossPtrs:           BE 80      .dw CODE_0380BE           
                       D5 80      .dw CODE_0380D5           
                       19 81      .dw CODE_038119           
                       8B 81      .dw CODE_03818B           
                       BC 81      .dw CODE_0381BC           
                       06 81      .dw CODE_038106           
                       D3 81      .dw CODE_0381D3           

CODE_0380BE:        A9 03         LDA.B #$03                
CODE_0380C0:        9D 02 16      STA.W $1602,X             
CODE_0380C3:        FE 70 15      INC.W $1570,X             
CODE_0380C6:        BD 70 15      LDA.W $1570,X             
CODE_0380C9:        C9 90         CMP.B #$90                
CODE_0380CB:        D0 07         BNE Return0380D4          
CODE_0380CD:        A9 08         LDA.B #$08                
CODE_0380CF:        9D 40 15      STA.W $1540,X             
CODE_0380D2:        F6 C2         INC RAM_SpriteState,X     
Return0380D4:       60            RTS                       ; Return 

CODE_0380D5:        BD 40 15      LDA.W $1540,X             
CODE_0380D8:        D0 1F         BNE Return0380F9          
CODE_0380DA:        A9 08         LDA.B #$08                
CODE_0380DC:        9D 40 15      STA.W $1540,X             
CODE_0380DF:        EE 0B 19      INC.W $190B               
CODE_0380E2:        AD 0B 19      LDA.W $190B               
CODE_0380E5:        C9 02         CMP.B #$02                
CODE_0380E7:        D0 05         BNE CODE_0380EE           
CODE_0380E9:        A0 10         LDY.B #$10                ; \ Play sound effect 
CODE_0380EB:        8C F9 1D      STY.W $1DF9               ; / 
CODE_0380EE:        C9 07         CMP.B #$07                
CODE_0380F0:        D0 07         BNE Return0380F9          
CODE_0380F2:        F6 C2         INC RAM_SpriteState,X     
CODE_0380F4:        A9 40         LDA.B #$40                
CODE_0380F6:        9D 40 15      STA.W $1540,X             
Return0380F9:       60            RTS                       ; Return 


DATA_0380FA:                      .db $FF,$01

DATA_0380FC:                      .db $F0,$10

DATA_0380FE:                      .db $0C,$F4

DATA_038100:                      .db $01,$FF

DATA_038102:                      .db $01,$02,$02,$01

CODE_038106:        BD 40 15      LDA.W $1540,X             
CODE_038109:        D0 07         BNE CODE_038112           
CODE_03810B:        74 C2         STZ RAM_SpriteState,X     
CODE_03810D:        A9 40         LDA.B #$40                
CODE_03810F:        9D 70 15      STA.W $1570,X             
CODE_038112:        A9 03         LDA.B #$03                
CODE_038114:        9D 02 16      STA.W $1602,X             
CODE_038117:        80 06         BRA CODE_03811F           

CODE_038119:        9E 02 16      STZ.W $1602,X             
CODE_03811C:        20 E4 81      JSR.W CODE_0381E4         
CODE_03811F:        BD AC 15      LDA.W $15AC,X             
CODE_038122:        D0 0E         BNE CODE_038132           
CODE_038124:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_038127:        98            TYA                       
CODE_038128:        DD 7C 15      CMP.W RAM_SpriteDir,X     
CODE_03812B:        F0 1D         BEQ CODE_03814A           
CODE_03812D:        A9 1F         LDA.B #$1F                
CODE_03812F:        9D AC 15      STA.W $15AC,X             
CODE_038132:        C9 10         CMP.B #$10                
CODE_038134:        D0 0A         BNE CODE_038140           
CODE_038136:        48            PHA                       
CODE_038137:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_03813A:        49 01         EOR.B #$01                
CODE_03813C:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_03813F:        68            PLA                       
CODE_038140:        4A            LSR                       
CODE_038141:        4A            LSR                       
CODE_038142:        4A            LSR                       
CODE_038143:        A8            TAY                       
CODE_038144:        B9 02 81      LDA.W DATA_038102,Y       
CODE_038147:        9D 02 16      STA.W $1602,X             
CODE_03814A:        A5 14         LDA RAM_FrameCounterB     
CODE_03814C:        29 07         AND.B #$07                
CODE_03814E:        D0 16         BNE CODE_038166           
CODE_038150:        BD 1C 15      LDA.W $151C,X             
CODE_038153:        29 01         AND.B #$01                
CODE_038155:        A8            TAY                       
CODE_038156:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_038158:        18            CLC                       
CODE_038159:        79 FA 80      ADC.W DATA_0380FA,Y       
CODE_03815C:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03815E:        D9 FC 80      CMP.W DATA_0380FC,Y       
CODE_038161:        D0 03         BNE CODE_038166           
CODE_038163:        FE 1C 15      INC.W $151C,X             
CODE_038166:        A5 14         LDA RAM_FrameCounterB     
CODE_038168:        29 07         AND.B #$07                
CODE_03816A:        D0 16         BNE CODE_038182           
CODE_03816C:        BD 28 15      LDA.W $1528,X             
CODE_03816F:        29 01         AND.B #$01                
CODE_038171:        A8            TAY                       
CODE_038172:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_038174:        18            CLC                       
CODE_038175:        79 00 81      ADC.W DATA_038100,Y       
CODE_038178:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03817A:        D9 FE 80      CMP.W DATA_0380FE,Y       
CODE_03817D:        D0 03         BNE CODE_038182           
CODE_03817F:        FE 28 15      INC.W $1528,X             
CODE_038182:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_038186:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
Return03818A:       60            RTS                       ; Return 

CODE_03818B:        BD 40 15      LDA.W $1540,X             
CODE_03818E:        D0 1E         BNE CODE_0381AE           
CODE_038190:        F6 C2         INC RAM_SpriteState,X     
CODE_038192:        A9 08         LDA.B #$08                
CODE_038194:        9D 40 15      STA.W $1540,X             
CODE_038197:        22 8B F7 07   JSL.L LoadSpriteTables    
CODE_03819B:        FE 34 15      INC.W $1534,X             
CODE_03819E:        BD 34 15      LDA.W $1534,X             
CODE_0381A1:        C9 03         CMP.B #$03                
CODE_0381A3:        D0 08         BNE Return0381AD          
CODE_0381A5:        A9 06         LDA.B #$06                
CODE_0381A7:        95 C2         STA RAM_SpriteState,X     
CODE_0381A9:        22 C8 A6 03   JSL.L KillMostSprites     
Return0381AD:       60            RTS                       ; Return 

CODE_0381AE:        29 0E         AND.B #$0E                
CODE_0381B0:        5D F6 15      EOR.W RAM_SpritePal,X     
CODE_0381B3:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_0381B6:        A9 03         LDA.B #$03                
CODE_0381B8:        9D 02 16      STA.W $1602,X             
Return0381BB:       60            RTS                       ; Return 

CODE_0381BC:        BD 40 15      LDA.W $1540,X             
CODE_0381BF:        D0 11         BNE Return0381D2          
CODE_0381C1:        A9 08         LDA.B #$08                
CODE_0381C3:        9D 40 15      STA.W $1540,X             
CODE_0381C6:        CE 0B 19      DEC.W $190B               
CODE_0381C9:        D0 07         BNE Return0381D2          
CODE_0381CB:        F6 C2         INC RAM_SpriteState,X     
CODE_0381CD:        A9 C0         LDA.B #$C0                
CODE_0381CF:        9D 40 15      STA.W $1540,X             
Return0381D2:       60            RTS                       ; Return 

CODE_0381D3:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_0381D5:        9D C8 14      STA.W $14C8,X             ; / 
CODE_0381D8:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_0381DA:        A9 D0         LDA.B #$D0                
CODE_0381DC:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_0381DE:        A9 23         LDA.B #$23                ; \ Play sound effect 
CODE_0381E0:        8D F9 1D      STA.W $1DF9               ; / 
Return0381E3:       60            RTS                       ; Return 

CODE_0381E4:        A0 0B         LDY.B #$0B                
CODE_0381E6:        B9 C8 14      LDA.W $14C8,Y             
CODE_0381E9:        C9 09         CMP.B #$09                
CODE_0381EB:        F0 08         BEQ CODE_0381F5           
CODE_0381ED:        C9 0A         CMP.B #$0A                
CODE_0381EF:        F0 04         BEQ CODE_0381F5           
CODE_0381F1:        88            DEY                       
CODE_0381F2:        10 F2         BPL CODE_0381E6           
Return0381F4:       60            RTS                       ; Return 

CODE_0381F5:        DA            PHX                       
CODE_0381F6:        BB            TYX                       
CODE_0381F7:        22 E5 B6 03   JSL.L GetSpriteClippingB  
CODE_0381FB:        FA            PLX                       
CODE_0381FC:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_038200:        22 2B B7 03   JSL.L CheckForContact     
CODE_038204:        90 EB         BCC CODE_0381F1           
CODE_038206:        A9 03         LDA.B #$03                
CODE_038208:        95 C2         STA RAM_SpriteState,X     
CODE_03820A:        A9 40         LDA.B #$40                
CODE_03820C:        9D 40 15      STA.W $1540,X             
CODE_03820F:        DA            PHX                       
CODE_038210:        BB            TYX                       
CODE_038211:        9E C8 14      STZ.W $14C8,X             
CODE_038214:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_038216:        85 9A         STA RAM_BlockYLo          
CODE_038218:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03821B:        85 9B         STA RAM_BlockYHi          
CODE_03821D:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03821F:        85 98         STA RAM_BlockXLo          
CODE_038221:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_038224:        85 99         STA RAM_BlockXHi          
CODE_038226:        8B            PHB                       
CODE_038227:        A9 02         LDA.B #$02                
CODE_038229:        48            PHA                       
CODE_03822A:        AB            PLB                       
CODE_03822B:        A9 FF         LDA.B #$FF                
CODE_03822D:        22 63 86 02   JSL.L ShatterBlock        
CODE_038231:        AB            PLB                       
CODE_038232:        FA            PLX                       
CODE_038233:        A9 28         LDA.B #$28                ; \ Play sound effect 
CODE_038235:        8D FC 1D      STA.W $1DFC               ; / 
Return038238:       60            RTS                       ; Return 

CODE_038239:        A0 24         LDY.B #$24                
CODE_03823B:        84 40         STY $40                   
CODE_03823D:        AD 0B 19      LDA.W $190B               
CODE_038240:        C9 08         CMP.B #$08                
CODE_038242:        3A            DEC A                     
CODE_038243:        B0 05         BCS CODE_03824A           
CODE_038245:        A0 34         LDY.B #$34                
CODE_038247:        84 40         STY $40                   
CODE_038249:        1A            INC A                     
CODE_03824A:        0A            ASL                       
CODE_03824B:        0A            ASL                       
CODE_03824C:        0A            ASL                       
CODE_03824D:        0A            ASL                       
CODE_03824E:        AA            TAX                       
CODE_03824F:        64 00         STZ $00                   
CODE_038251:        AC 81 06      LDY.W $0681               
CODE_038254:        BF 82 B9 03   LDA.L BooBossPals,X       
CODE_038258:        99 84 06      STA.W $0684,Y             
CODE_03825B:        C8            INY                       
CODE_03825C:        E8            INX                       
CODE_03825D:        E6 00         INC $00                   
CODE_03825F:        A5 00         LDA $00                   
CODE_038261:        C9 10         CMP.B #$10                
CODE_038263:        D0 EF         BNE CODE_038254           
CODE_038265:        AE 81 06      LDX.W $0681               
CODE_038268:        A9 10         LDA.B #$10                
CODE_03826A:        9D 82 06      STA.W $0682,X             
CODE_03826D:        A9 F0         LDA.B #$F0                
CODE_03826F:        9D 83 06      STA.W $0683,X             
CODE_038272:        9E 94 06      STZ.W $0694,X             
CODE_038275:        8A            TXA                       
CODE_038276:        18            CLC                       
CODE_038277:        69 12         ADC.B #$12                
CODE_038279:        8D 81 06      STA.W $0681               
CODE_03827C:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return03827F:       6B            RTL                       ; Return 


BigBooDispX:                      .db $08,$08,$20,$00,$00,$00,$00,$10
                                  .db $10,$10,$10,$20,$20,$20,$20,$30
                                  .db $30,$30,$30,$FD,$0C,$0C,$27,$00
                                  .db $00,$00,$00,$10,$10,$10,$10,$1F
                                  .db $20,$20,$1F,$2E,$2E,$2C,$2C,$FB
                                  .db $12,$12,$30,$00,$00,$00,$00,$10
                                  .db $10,$10,$10,$1F,$20,$20,$1F,$2E
                                  .db $2E,$2E,$2E,$F8,$11,$FF,$08,$08
                                  .db $00,$00,$00,$00,$10,$10,$10,$10
                                  .db $20,$20,$20,$20,$30,$30,$30,$30
BigBooDispY:                      .db $12,$22,$18,$00,$10,$20,$30,$00
                                  .db $10,$20,$30,$00,$10,$20,$30,$00
                                  .db $10,$20,$30,$18,$16,$16,$12,$22
                                  .db $00,$10,$20,$30,$00,$10,$20,$30
                                  .db $00,$10,$20,$30,$00,$10,$20,$30
BigBooTiles:                      .db $C0,$E0,$E8,$80,$A0,$A0,$80,$82
                                  .db $A2,$A2,$82,$84,$A4,$C4,$E4,$86
                                  .db $A6,$C6,$E6,$E8,$C0,$E0,$E8,$80
                                  .db $A0,$A0,$80,$82,$A2,$A2,$82,$84
                                  .db $A4,$C4,$E4,$86,$A6,$C6,$E6,$E8
                                  .db $C0,$E0,$E8,$80,$A0,$A0,$80,$82
                                  .db $A2,$A2,$82,$84,$A4,$A4,$84,$86
                                  .db $A6,$A6,$86,$E8,$E8,$E8,$C2,$E2
                                  .db $80,$A0,$A0,$80,$82,$A2,$A2,$82
                                  .db $84,$A4,$C4,$E4,$86,$A6,$C6,$E6
BigBooGfxProp:                    .db $00,$00,$40,$00,$00,$80,$80,$00
                                  .db $00,$80,$80,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$40,$00
                                  .db $00,$80,$80,$00,$00,$80,$80,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$40,$00,$00,$80,$80,$00
                                  .db $00,$80,$80,$00,$00,$80,$80,$00
                                  .db $00,$80,$80,$00,$00,$40,$00,$00
                                  .db $00,$00,$80,$80,$00,$00,$80,$80
                                  .db $00,$00,$00,$00,$00,$00,$00,$00

CODE_038398:        8B            PHB                       ; Wrapper 
CODE_038399:        4B            PHK                       
CODE_03839A:        AB            PLB                       
CODE_03839B:        20 A0 83      JSR.W CODE_0383A0         
CODE_03839E:        AB            PLB                       
Return03839F:       6B            RTL                       ; Return 

CODE_0383A0:        B5 9E         LDA RAM_SpriteNum,X       
CODE_0383A2:        C9 37         CMP.B #$37                
CODE_0383A4:        D0 1C         BNE CODE_0383C2           
CODE_0383A6:        A9 00         LDA.B #$00                
CODE_0383A8:        B4 C2         LDY RAM_SpriteState,X     
CODE_0383AA:        F0 0E         BEQ CODE_0383BA           
CODE_0383AC:        A9 06         LDA.B #$06                
CODE_0383AE:        BC 58 15      LDY.W $1558,X             
CODE_0383B1:        F0 07         BEQ CODE_0383BA           
CODE_0383B3:        98            TYA                       
CODE_0383B4:        29 04         AND.B #$04                
CODE_0383B6:        4A            LSR                       
CODE_0383B7:        4A            LSR                       
CODE_0383B8:        69 02         ADC.B #$02                
CODE_0383BA:        9D 02 16      STA.W $1602,X             
CODE_0383BD:        22 B2 90 01   JSL.L GenericSprGfxRt2    
Return0383C1:       60            RTS                       ; Return 

CODE_0383C2:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_0383C5:        BD 02 16      LDA.W $1602,X             
CODE_0383C8:        85 06         STA $06                   
CODE_0383CA:        0A            ASL                       
CODE_0383CB:        0A            ASL                       
CODE_0383CC:        85 03         STA $03                   
CODE_0383CE:        0A            ASL                       
CODE_0383CF:        0A            ASL                       
CODE_0383D0:        65 03         ADC $03                   
CODE_0383D2:        85 02         STA $02                   
CODE_0383D4:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_0383D7:        85 04         STA $04                   
CODE_0383D9:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_0383DC:        85 05         STA $05                   
CODE_0383DE:        A2 00         LDX.B #$00                
CODE_0383E0:        DA            PHX                       
CODE_0383E1:        A6 02         LDX $02                   
CODE_0383E3:        BD F8 82      LDA.W BigBooTiles,X       
CODE_0383E6:        99 02 03      STA.W OAM_Tile,Y          
CODE_0383E9:        A5 04         LDA $04                   
CODE_0383EB:        4A            LSR                       
CODE_0383EC:        BD 48 83      LDA.W BigBooGfxProp,X     
CODE_0383EF:        05 05         ORA $05                   
CODE_0383F1:        B0 02         BCS CODE_0383F5           
CODE_0383F3:        49 40         EOR.B #$40                
CODE_0383F5:        05 64         ORA $64                   
CODE_0383F7:        99 03 03      STA.W OAM_Prop,Y          
CODE_0383FA:        BD 80 82      LDA.W BigBooDispX,X       
CODE_0383FD:        B0 06         BCS CODE_038405           
CODE_0383FF:        49 FF         EOR.B #$FF                
CODE_038401:        1A            INC A                     
CODE_038402:        18            CLC                       
CODE_038403:        69 28         ADC.B #$28                
CODE_038405:        18            CLC                       
CODE_038406:        65 00         ADC $00                   
CODE_038408:        99 00 03      STA.W OAM_DispX,Y         
CODE_03840B:        FA            PLX                       
CODE_03840C:        DA            PHX                       
CODE_03840D:        A5 06         LDA $06                   
CODE_03840F:        C9 03         CMP.B #$03                
CODE_038411:        90 05         BCC CODE_038418           
CODE_038413:        8A            TXA                       
CODE_038414:        18            CLC                       
CODE_038415:        69 14         ADC.B #$14                
CODE_038417:        AA            TAX                       
CODE_038418:        A5 01         LDA $01                   
CODE_03841A:        18            CLC                       
CODE_03841B:        7D D0 82      ADC.W BigBooDispY,X       
CODE_03841E:        99 01 03      STA.W OAM_DispY,Y         
CODE_038421:        FA            PLX                       
CODE_038422:        C8            INY                       
CODE_038423:        C8            INY                       
CODE_038424:        C8            INY                       
CODE_038425:        C8            INY                       
CODE_038426:        E6 02         INC $02                   
CODE_038428:        E8            INX                       
CODE_038429:        E0 14         CPX.B #$14                
CODE_03842B:        D0 B3         BNE CODE_0383E0           
CODE_03842D:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_038430:        BD 02 16      LDA.W $1602,X             
CODE_038433:        C9 03         CMP.B #$03                
CODE_038435:        D0 14         BNE CODE_03844B           
CODE_038437:        BD 58 15      LDA.W $1558,X             
CODE_03843A:        F0 0F         BEQ CODE_03844B           
ADDR_03843C:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
ADDR_03843F:        B9 01 03      LDA.W OAM_DispY,Y         
ADDR_038442:        18            CLC                       
ADDR_038443:        69 05         ADC.B #$05                
ADDR_038445:        99 01 03      STA.W OAM_DispY,Y         
ADDR_038448:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_03844B:        A9 13         LDA.B #$13                
CODE_03844D:        A0 02         LDY.B #$02                
CODE_03844F:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return038453:       60            RTS                       ; Return 

GreyFallingPlat:    20 92 84      JSR.W CODE_038492         
CODE_038457:        A5 9D         LDA RAM_SpritesLocked     
CODE_038459:        D0 2E         BNE Return038489          
CODE_03845B:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_03845E:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_038460:        F0 14         BEQ CODE_038476           
CODE_038462:        BD 40 15      LDA.W $1540,X             
CODE_038465:        D0 0B         BNE CODE_038472           
CODE_038467:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_038469:        C9 40         CMP.B #$40                
CODE_03846B:        10 05         BPL CODE_038472           
CODE_03846D:        18            CLC                       
CODE_03846E:        69 02         ADC.B #$02                
CODE_038470:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_038472:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_038476:        22 4F B4 01   JSL.L InvisBlkMainRt      
CODE_03847A:        90 0D         BCC Return038489          
CODE_03847C:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03847E:        D0 09         BNE Return038489          
CODE_038480:        A9 03         LDA.B #$03                
CODE_038482:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_038484:        A9 18         LDA.B #$18                
CODE_038486:        9D 40 15      STA.W $1540,X             
Return038489:       60            RTS                       ; Return 


FallingPlatDispX:                 .db $00,$10,$20,$30

FallingPlatTiles:                 .db $60,$61,$61,$62

CODE_038492:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_038495:        DA            PHX                       
CODE_038496:        A2 03         LDX.B #$03                
CODE_038498:        A5 00         LDA $00                   
CODE_03849A:        18            CLC                       
CODE_03849B:        7D 8A 84      ADC.W FallingPlatDispX,X  
CODE_03849E:        99 00 03      STA.W OAM_DispX,Y         
CODE_0384A1:        A5 01         LDA $01                   
CODE_0384A3:        99 01 03      STA.W OAM_DispY,Y         
CODE_0384A6:        BD 8E 84      LDA.W FallingPlatTiles,X  
CODE_0384A9:        99 02 03      STA.W OAM_Tile,Y          
CODE_0384AC:        A9 03         LDA.B #$03                
CODE_0384AE:        05 64         ORA $64                   
CODE_0384B0:        99 03 03      STA.W OAM_Prop,Y          
CODE_0384B3:        C8            INY                       
CODE_0384B4:        C8            INY                       
CODE_0384B5:        C8            INY                       
CODE_0384B6:        C8            INY                       
CODE_0384B7:        CA            DEX                       
CODE_0384B8:        10 DE         BPL CODE_038498           
CODE_0384BA:        FA            PLX                       
CODE_0384BB:        A0 02         LDY.B #$02                
CODE_0384BD:        A9 03         LDA.B #$03                
CODE_0384BF:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return0384C3:       60            RTS                       ; Return 


BlurpMaxSpeedY:                   .db $04,$FC

BlurpSpeedX:                      .db $08,$F8

BlurpAccelY:                      .db $01,$FF

Blurp:              22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_0384CE:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_0384D1:        AD 14 00      LDA.W RAM_FrameCounterB   
CODE_0384D4:        4A            LSR                       
CODE_0384D5:        4A            LSR                       
CODE_0384D6:        4A            LSR                       
CODE_0384D7:        18            CLC                       
CODE_0384D8:        6D E9 15      ADC.W $15E9               
CODE_0384DB:        4A            LSR                       
CODE_0384DC:        A9 A2         LDA.B #$A2                
CODE_0384DE:        90 02         BCC CODE_0384E2           
CODE_0384E0:        A9 EC         LDA.B #$EC                
CODE_0384E2:        99 02 03      STA.W OAM_Tile,Y          
CODE_0384E5:        BD C8 14      LDA.W $14C8,X             
CODE_0384E8:        C9 08         CMP.B #$08                
CODE_0384EA:        F0 09         BEQ CODE_0384F5           
CODE_0384EC:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_0384EF:        09 80         ORA.B #$80                
CODE_0384F1:        99 03 03      STA.W OAM_Prop,Y          
Return0384F4:       60            RTS                       ; Return 

CODE_0384F5:        A5 9D         LDA RAM_SpritesLocked     
CODE_0384F7:        D0 31         BNE Return03852A          
CODE_0384F9:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_0384FC:        A5 14         LDA RAM_FrameCounterB     
CODE_0384FE:        29 03         AND.B #$03                
CODE_038500:        D0 14         BNE CODE_038516           
CODE_038502:        B5 C2         LDA RAM_SpriteState,X     
CODE_038504:        29 01         AND.B #$01                
CODE_038506:        A8            TAY                       
CODE_038507:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_038509:        18            CLC                       
CODE_03850A:        79 C8 84      ADC.W BlurpAccelY,Y       
CODE_03850D:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03850F:        D9 C4 84      CMP.W BlurpMaxSpeedY,Y    
CODE_038512:        D0 02         BNE CODE_038516           
CODE_038514:        F6 C2         INC RAM_SpriteState,X     
CODE_038516:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_038519:        B9 C6 84      LDA.W BlurpSpeedX,Y       
CODE_03851C:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03851E:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_038522:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_038526:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
Return03852A:       60            RTS                       ; Return 


PorcuPuffAccel:                   .db $01,$FF

PorcuPuffMaxSpeed:                .db $10,$F0

PorcuPuffer:        20 A3 85      JSR.W CODE_0385A3         
CODE_038532:        A5 9D         LDA RAM_SpritesLocked     
CODE_038534:        D0 50         BNE Return038586          
CODE_038536:        BD C8 14      LDA.W $14C8,X             
CODE_038539:        C9 08         CMP.B #$08                
CODE_03853B:        D0 49         BNE Return038586          
CODE_03853D:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_038540:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_038544:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_038547:        98            TYA                       
CODE_038548:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_03854B:        A5 14         LDA RAM_FrameCounterB     
CODE_03854D:        29 03         AND.B #$03                
CODE_03854F:        D0 0D         BNE CODE_03855E           
CODE_038551:        B5 B6         LDA RAM_SpriteSpeedX,X    ; \ Branch if at max speed 
CODE_038553:        D9 2D 85      CMP.W PorcuPuffMaxSpeed,Y ;  | 
CODE_038556:        F0 06         BEQ CODE_03855E           ; / 
CODE_038558:        18            CLC                       ; \ Otherwise, accelerate 
CODE_038559:        79 2B 85      ADC.W PorcuPuffAccel,Y    ;  | 
CODE_03855C:        95 B6         STA RAM_SpriteSpeedX,X    ; / 
CODE_03855E:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_038560:        48            PHA                       
CODE_038561:        AD BD 17      LDA.W $17BD               
CODE_038564:        0A            ASL                       
CODE_038565:        0A            ASL                       
CODE_038566:        0A            ASL                       
CODE_038567:        18            CLC                       
CODE_038568:        75 B6         ADC RAM_SpriteSpeedX,X    
CODE_03856A:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03856C:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_038570:        68            PLA                       
CODE_038571:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_038573:        22 38 91 01   JSL.L CODE_019138         
CODE_038577:        A0 04         LDY.B #$04                
CODE_038579:        BD 4A 16      LDA.W $164A,X             
CODE_03857C:        F0 02         BEQ CODE_038580           
CODE_03857E:        A0 FC         LDY.B #$FC                
CODE_038580:        94 AA         STY RAM_SpriteSpeedY,X    
CODE_038582:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
Return038586:       60            RTS                       ; Return 


PocruPufferDispX:                 .db $F8,$08,$F8,$08,$08,$F8,$08,$F8
PocruPufferDispY:                 .db $F8,$F8,$08,$08

PocruPufferTiles:                 .db $86,$C0,$A6,$C2,$86,$C0,$A6,$8A
PocruPufferGfxProp:               .db $0D,$0D,$0D,$0D,$4D,$4D,$4D,$4D

CODE_0385A3:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_0385A6:        A5 14         LDA RAM_FrameCounterB     
CODE_0385A8:        29 04         AND.B #$04                
CODE_0385AA:        85 03         STA $03                   
CODE_0385AC:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_0385AF:        85 02         STA $02                   
CODE_0385B1:        DA            PHX                       
CODE_0385B2:        A2 03         LDX.B #$03                
CODE_0385B4:        A5 01         LDA $01                   
CODE_0385B6:        18            CLC                       
CODE_0385B7:        7D 8F 85      ADC.W PocruPufferDispY,X  
CODE_0385BA:        99 01 03      STA.W OAM_DispY,Y         
CODE_0385BD:        DA            PHX                       
CODE_0385BE:        A5 02         LDA $02                   
CODE_0385C0:        D0 04         BNE CODE_0385C6           
CODE_0385C2:        8A            TXA                       
CODE_0385C3:        09 04         ORA.B #$04                
CODE_0385C5:        AA            TAX                       
CODE_0385C6:        A5 00         LDA $00                   
CODE_0385C8:        18            CLC                       
CODE_0385C9:        7D 87 85      ADC.W PocruPufferDispX,X  
CODE_0385CC:        99 00 03      STA.W OAM_DispX,Y         
CODE_0385CF:        BD 9B 85      LDA.W PocruPufferGfxProp,X 
CODE_0385D2:        05 64         ORA $64                   
CODE_0385D4:        99 03 03      STA.W OAM_Prop,Y          
CODE_0385D7:        68            PLA                       
CODE_0385D8:        48            PHA                       
CODE_0385D9:        05 03         ORA $03                   
CODE_0385DB:        AA            TAX                       
CODE_0385DC:        BD 93 85      LDA.W PocruPufferTiles,X  
CODE_0385DF:        99 02 03      STA.W OAM_Tile,Y          
CODE_0385E2:        FA            PLX                       
CODE_0385E3:        C8            INY                       
CODE_0385E4:        C8            INY                       
CODE_0385E5:        C8            INY                       
CODE_0385E6:        C8            INY                       
CODE_0385E7:        CA            DEX                       
CODE_0385E8:        10 CA         BPL CODE_0385B4           
CODE_0385EA:        FA            PLX                       
CODE_0385EB:        A0 02         LDY.B #$02                
CODE_0385ED:        A9 03         LDA.B #$03                
CODE_0385EF:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return0385F3:       60            RTS                       ; Return 


FlyingBlockSpeedY:                .db $08,$F8

FlyingTurnBlocks:   20 A8 86      JSR.W CODE_0386A8         
CODE_0385F9:        A5 9D         LDA RAM_SpritesLocked     
CODE_0385FB:        D0 78         BNE Return038675          
CODE_0385FD:        AD 9A 1B      LDA.W $1B9A               
CODE_038600:        F0 27         BEQ CODE_038629           
CODE_038602:        BD 34 15      LDA.W $1534,X             
CODE_038605:        FE 34 15      INC.W $1534,X             
CODE_038608:        29 01         AND.B #$01                
CODE_03860A:        D0 12         BNE CODE_03861E           
CODE_03860C:        DE 02 16      DEC.W $1602,X             
CODE_03860F:        BD 02 16      LDA.W $1602,X             
CODE_038612:        C9 FF         CMP.B #$FF                
CODE_038614:        D0 08         BNE CODE_03861E           
CODE_038616:        A9 FF         LDA.B #$FF                
CODE_038618:        9D 02 16      STA.W $1602,X             
CODE_03861B:        FE 7C 15      INC.W RAM_SpriteDir,X     
CODE_03861E:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_038621:        29 01         AND.B #$01                
CODE_038623:        A8            TAY                       
CODE_038624:        B9 F4 85      LDA.W FlyingBlockSpeedY,Y 
CODE_038627:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_038629:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03862B:        48            PHA                       
CODE_03862C:        BC 1C 15      LDY.W $151C,X             
CODE_03862F:        D0 05         BNE CODE_038636           
CODE_038631:        49 FF         EOR.B #$FF                
CODE_038633:        1A            INC A                     
CODE_038634:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_038636:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_03863A:        68            PLA                       
CODE_03863B:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03863D:        AD 9A 1B      LDA.W $1B9A               
CODE_038640:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_038642:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_038646:        9D 28 15      STA.W $1528,X             
CODE_038649:        22 4F B4 01   JSL.L InvisBlkMainRt      
CODE_03864D:        90 26         BCC Return038675          
CODE_03864F:        AD 9A 1B      LDA.W $1B9A               
CODE_038652:        D0 21         BNE Return038675          
CODE_038654:        A9 08         LDA.B #$08                
CODE_038656:        8D 9A 1B      STA.W $1B9A               
CODE_038659:        A9 7F         LDA.B #$7F                
CODE_03865B:        9D 02 16      STA.W $1602,X             
CODE_03865E:        A0 09         LDY.B #$09                
CODE_038660:        CC E9 15      CPY.W $15E9               
CODE_038663:        F0 07         BEQ CODE_03866C           
CODE_038665:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_038668:        C9 C1         CMP.B #$C1                
CODE_03866A:        F0 04         BEQ CODE_038670           
CODE_03866C:        88            DEY                       
CODE_03866D:        10 F1         BPL CODE_038660           
ADDR_03866F:        C8            INY                       
CODE_038670:        A9 7F         LDA.B #$7F                
CODE_038672:        99 02 16      STA.W $1602,Y             
Return038675:       60            RTS                       ; Return 


ForestPlatDispX:                  .db $00,$10,$20,$F2,$2E,$00,$10,$20
                                  .db $FA,$2E

ForestPlatDispY:                  .db $00,$00,$00,$F6,$F6,$00,$00,$00
                                  .db $FE,$FE

ForestPlatTiles:                  .db $40,$40,$40,$C6,$C6,$40,$40,$40
                                  .db $5D,$5D

ForestPlatGfxProp:                .db $32,$32,$32,$72,$32,$32,$32,$32
                                  .db $72,$32

ForestPlatTileSize:               .db $02,$02,$02,$02,$02,$02,$02,$02
                                  .db $00,$00

CODE_0386A8:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_0386AB:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_0386AE:        A5 14         LDA RAM_FrameCounterB     
CODE_0386B0:        4A            LSR                       
CODE_0386B1:        29 04         AND.B #$04                
CODE_0386B3:        F0 01         BEQ CODE_0386B6           
CODE_0386B5:        1A            INC A                     
CODE_0386B6:        85 02         STA $02                   
CODE_0386B8:        DA            PHX                       
CODE_0386B9:        A2 04         LDX.B #$04                
CODE_0386BB:        86 06         STX $06                   
CODE_0386BD:        8A            TXA                       
CODE_0386BE:        18            CLC                       
CODE_0386BF:        65 02         ADC $02                   
CODE_0386C1:        AA            TAX                       
CODE_0386C2:        A5 00         LDA $00                   
CODE_0386C4:        18            CLC                       
CODE_0386C5:        7D 76 86      ADC.W ForestPlatDispX,X   
CODE_0386C8:        99 00 03      STA.W OAM_DispX,Y         
CODE_0386CB:        A5 01         LDA $01                   
CODE_0386CD:        18            CLC                       
CODE_0386CE:        7D 80 86      ADC.W ForestPlatDispY,X   
CODE_0386D1:        99 01 03      STA.W OAM_DispY,Y         
CODE_0386D4:        BD 8A 86      LDA.W ForestPlatTiles,X   
CODE_0386D7:        99 02 03      STA.W OAM_Tile,Y          
CODE_0386DA:        BD 94 86      LDA.W ForestPlatGfxProp,X 
CODE_0386DD:        99 03 03      STA.W OAM_Prop,Y          
CODE_0386E0:        5A            PHY                       
CODE_0386E1:        98            TYA                       
CODE_0386E2:        4A            LSR                       
CODE_0386E3:        4A            LSR                       
CODE_0386E4:        A8            TAY                       
CODE_0386E5:        BD 9E 86      LDA.W ForestPlatTileSize,X 
CODE_0386E8:        99 60 04      STA.W OAM_TileSize,Y      
CODE_0386EB:        7A            PLY                       
CODE_0386EC:        C8            INY                       
CODE_0386ED:        C8            INY                       
CODE_0386EE:        C8            INY                       
CODE_0386EF:        C8            INY                       
CODE_0386F0:        A6 06         LDX $06                   
CODE_0386F2:        CA            DEX                       
CODE_0386F3:        10 C6         BPL CODE_0386BB           
CODE_0386F5:        FA            PLX                       
CODE_0386F6:        A0 FF         LDY.B #$FF                
CODE_0386F8:        A9 04         LDA.B #$04                
CODE_0386FA:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return0386FE:       60            RTS                       ; Return 

GrayLavaPlatform:   20 3A 87      JSR.W CODE_03873A         
CODE_038702:        A5 9D         LDA RAM_SpritesLocked     
CODE_038704:        D0 2D         BNE Return038733          
CODE_038706:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_038709:        BD 40 15      LDA.W $1540,X             
CODE_03870C:        3A            DEC A                     
CODE_03870D:        D0 0C         BNE CODE_03871B           
CODE_03870F:        BC 1A 16      LDY.W RAM_SprIndexInLvl,X ; \ 
CODE_038712:        A9 00         LDA.B #$00                ;  | Allow sprite to be reloaded by level loading routine 
CODE_038714:        99 38 19      STA.W RAM_SprLoadStatus,Y ; / 
CODE_038717:        9E C8 14      STZ.W $14C8,X             
Return03871A:       60            RTS                       ; Return 

CODE_03871B:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_03871F:        22 4F B4 01   JSL.L InvisBlkMainRt      
CODE_038723:        90 0E         BCC Return038733          
CODE_038725:        BD 40 15      LDA.W $1540,X             
CODE_038728:        D0 09         BNE Return038733          
CODE_03872A:        A9 06         LDA.B #$06                
CODE_03872C:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03872E:        A9 40         LDA.B #$40                
CODE_038730:        9D 40 15      STA.W $1540,X             
Return038733:       60            RTS                       ; Return 


LavaPlatTiles:                    .db $85,$86,$85

DATA_038737:                      .db $43,$03,$03

CODE_03873A:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_03873D:        DA            PHX                       
CODE_03873E:        A2 02         LDX.B #$02                
CODE_038740:        A5 00         LDA $00                   
CODE_038742:        99 00 03      STA.W OAM_DispX,Y         
CODE_038745:        18            CLC                       
CODE_038746:        69 10         ADC.B #$10                
CODE_038748:        85 00         STA $00                   
CODE_03874A:        A5 01         LDA $01                   
CODE_03874C:        99 01 03      STA.W OAM_DispY,Y         
CODE_03874F:        BD 34 87      LDA.W LavaPlatTiles,X     
CODE_038752:        99 02 03      STA.W OAM_Tile,Y          
CODE_038755:        BD 37 87      LDA.W DATA_038737,X       
CODE_038758:        05 64         ORA $64                   
CODE_03875A:        99 03 03      STA.W OAM_Prop,Y          
CODE_03875D:        C8            INY                       
CODE_03875E:        C8            INY                       
CODE_03875F:        C8            INY                       
CODE_038760:        C8            INY                       
CODE_038761:        CA            DEX                       
CODE_038762:        10 DC         BPL CODE_038740           
CODE_038764:        FA            PLX                       
CODE_038765:        A0 02         LDY.B #$02                
CODE_038767:        A9 02         LDA.B #$02                
CODE_038769:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return03876D:       60            RTS                       ; Return 


MegaMoleSpeed:                    .db $10,$F0

MegaMole:           20 3F 88      JSR.W MegaMoleGfxRt       ; Graphics routine		       
CODE_038773:        BD C8 14      LDA.W $14C8,X             ; \ 			       
CODE_038776:        C9 08         CMP.B #$08                ;  | If status != 8, return	       
CODE_038778:        D0 B9         BNE Return038733          ; /				       
CODE_03877A:        20 4F B8      JSR.W SubOffscreen3Bnk3   ; Handle off screen situation      
CODE_03877D:        BC 7C 15      LDY.W RAM_SpriteDir,X     ; \ Set x speed based on direction 
CODE_038780:        B9 6E 87      LDA.W MegaMoleSpeed,Y     ;  |			       
CODE_038783:        95 B6         STA RAM_SpriteSpeedX,X    ; /				       
CODE_038785:        A5 9D         LDA RAM_SpritesLocked     ; \ If sprites locked, return      
CODE_038787:        D0 AA         BNE Return038733          ; /                                
CODE_038789:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_03878C:        29 04         AND.B #$04                
CODE_03878E:        48            PHA                       
CODE_03878F:        22 2A 80 01   JSL.L UpdateSpritePos     ; Update position based on speed values 
CODE_038793:        22 32 80 01   JSL.L SprSprInteract      ; Interact with other sprites 
CODE_038797:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_03879A:        29 04         AND.B #$04                ;  | 
CODE_03879C:        F0 05         BEQ MegaMoleInAir         ; / 
CODE_03879E:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_0387A0:        68            PLA                       
CODE_0387A1:        80 0F         BRA MegaMoleOnGround      

MegaMoleInAir:      68            PLA                       
CODE_0387A4:        F0 05         BEQ MegaMoleWasInAir      
CODE_0387A6:        A9 0A         LDA.B #$0A                
CODE_0387A8:        9D 40 15      STA.W $1540,X             
MegaMoleWasInAir:   BD 40 15      LDA.W $1540,X             
CODE_0387AE:        F0 02         BEQ MegaMoleOnGround      
CODE_0387B0:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
MegaMoleOnGround:   BC AC 15      LDY.W $15AC,X             ; \								   
CODE_0387B5:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; | If Mega Mole is in contact with an object...		   
CODE_0387B8:        29 03         AND.B #$03                ; |								   
CODE_0387BA:        F0 11         BEQ CODE_0387CD           ; |								   
CODE_0387BC:        C0 00         CPY.B #$00                ; |    ... and timer hasn't been set (time until flip == 0)... 
CODE_0387BE:        D0 05         BNE CODE_0387C5           ; |								   
CODE_0387C0:        A9 10         LDA.B #$10                ; |    ... set time until flip				   
CODE_0387C2:        9D AC 15      STA.W $15AC,X             ; /								   
CODE_0387C5:        BD 7C 15      LDA.W RAM_SpriteDir,X     ; \ Flip the temp direction status				   
CODE_0387C8:        49 01         EOR.B #$01                ; |								   
CODE_0387CA:        9D 7C 15      STA.W RAM_SpriteDir,X     ; /								   
CODE_0387CD:        C0 00         CPY.B #$00                ; \ If time until flip == 0...				   
CODE_0387CF:        D0 06         BNE CODE_0387D7           ; |								   
CODE_0387D1:        BD 7C 15      LDA.W RAM_SpriteDir,X     ; |    ...update the direction status used by the gfx routine  
CODE_0387D4:        9D 1C 15      STA.W $151C,X             ; /                                                            
CODE_0387D7:        22 DC A7 01   JSL.L MarioSprInteract    ; Check for mario/Mega Mole contact 
CODE_0387DB:        90 4D         BCC Return03882A          ; (Carry set = contact) 
CODE_0387DD:        20 29 B8      JSR.W SubVertPosBnk3      
CODE_0387E0:        A5 0E         LDA $0E                   
CODE_0387E2:        C9 D8         CMP.B #$D8                
CODE_0387E4:        10 38         BPL MegaMoleContact       
CODE_0387E6:        A5 7D         LDA RAM_MarioSpeedY       
CODE_0387E8:        30 40         BMI Return03882A          
CODE_0387EA:        A9 01         LDA.B #$01                ; \ Set "on sprite" flag				     
CODE_0387EC:        8D 71 14      STA.W $1471               ; /							     
CODE_0387EF:        A9 06         LDA.B #$06                ; \ Set riding Mega Mole				     
CODE_0387F1:        9D 4C 15      STA.W RAM_DisableInter,X  ; / 						     
CODE_0387F4:        64 7D         STZ RAM_MarioSpeedY       ; Y speed = 0					     
CODE_0387F6:        A9 D6         LDA.B #$D6                ; \							     
CODE_0387F8:        AC 7A 18      LDY.W RAM_OnYoshi         ; | Mario's y position += C6 or D6 depending if on yoshi 
CODE_0387FB:        F0 02         BEQ MegaMoleNoYoshi       ; |							     
CODE_0387FD:        A9 C6         LDA.B #$C6                ; |							     
MegaMoleNoYoshi:    18            CLC                       ; |							     
CODE_038800:        75 D8         ADC RAM_SpriteYLo,X       ; |							     
CODE_038802:        85 96         STA RAM_MarioYPos         ; |							     
CODE_038804:        BD D4 14      LDA.W RAM_SpriteYHi,X     ; |							     
CODE_038807:        69 FF         ADC.B #$FF                ; |							     
CODE_038809:        85 97         STA RAM_MarioYPosHi       ; /							     
CODE_03880B:        A0 00         LDY.B #$00                ; \ 						     
CODE_03880D:        AD 91 14      LDA.W $1491               ; | $1491 == 01 or FF, depending on direction	     
CODE_038810:        10 01         BPL CODE_038813           ; | Set mario's new x position			     
CODE_038812:        88            DEY                       ; |							     
CODE_038813:        18            CLC                       ; |							     
CODE_038814:        65 94         ADC RAM_MarioXPos         ; |							     
CODE_038816:        85 94         STA RAM_MarioXPos         ; |							     
CODE_038818:        98            TYA                       ; |							     
CODE_038819:        65 95         ADC RAM_MarioXPosHi       ; |							     
CODE_03881B:        85 95         STA RAM_MarioXPosHi       ;  /							   
Return03881D:       60            RTS                       ; Return 

MegaMoleContact:    BD 4C 15      LDA.W RAM_DisableInter,X  ; \ If riding Mega Mole...				     
CODE_038821:        1D D0 15      ORA.W $15D0,X             ; |   ...or Mega Mole being eaten...		     
CODE_038824:        D0 04         BNE Return03882A          ; /   ...return					     
CODE_038826:        22 B7 F5 00   JSL.L HurtMario           ; Hurt mario					     
Return03882A:       60            RTS                       ; Return 


MegaMoleTileDispX:                .db $00,$10,$00,$10,$10,$00,$10,$00
MegaMoleTileDispY:                .db $F0,$F0,$00,$00

MegaMoleTiles:                    .db $C6,$C8,$E6,$E8,$CA,$CC,$EA,$EC

MegaMoleGfxRt:      20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_038842:        BD 1C 15      LDA.W $151C,X             ; \ $02 = direction						      
CODE_038845:        85 02         STA $02                   ; / 							      
CODE_038847:        A5 14         LDA RAM_FrameCounterB     ; \ 							      
CODE_038849:        4A            LSR                       ; |								      
CODE_03884A:        4A            LSR                       ; |								      
CODE_03884B:        EA            NOP                       ; |								      
CODE_03884C:        18            CLC                       ; |								      
CODE_03884D:        6D E9 15      ADC.W $15E9               ; |								      
CODE_038850:        29 01         AND.B #$01                ; |								      
CODE_038852:        0A            ASL                       ; |								      
CODE_038853:        0A            ASL                       ; |								      
CODE_038854:        85 03         STA $03                   ; | $03 = index to frame start (0 or 4)			      
CODE_038856:        DA            PHX                       ; /								      
CODE_038857:        A2 03         LDX.B #$03                ; Run loop 4 times, cuz 4 tiles per frame			      
MegaMoleGfxLoopSt:  DA            PHX                       ; Push, current tile					      
CODE_03885A:        A5 02         LDA $02                   ; \								      
CODE_03885C:        D0 04         BNE MegaMoleFaceLeft      ; | If facing right, index to frame end += 4		      
CODE_03885E:        E8            INX                       ; |								      
CODE_03885F:        E8            INX                       ; |								      
CODE_038860:        E8            INX                       ; |								      
CODE_038861:        E8            INX                       ; /								      
MegaMoleFaceLeft:   A5 00         LDA $00                   ; \ Tile x position = sprite x location ($00) + tile displacement 
CODE_038864:        18            CLC                       ; |								      
CODE_038865:        7D 2B 88      ADC.W MegaMoleTileDispX,X ; |								      
CODE_038868:        99 00 03      STA.W OAM_DispX,Y         ; /								      
CODE_03886B:        FA            PLX                       ; \ Pull, X = index to frame end				      
CODE_03886C:        A5 01         LDA $01                   ; |								      
CODE_03886E:        18            CLC                       ; | Tile y position = sprite y location ($01) + tile displacement 
CODE_03886F:        7D 33 88      ADC.W MegaMoleTileDispY,X ; |						    
CODE_038872:        99 01 03      STA.W OAM_DispY,Y         ; /						    
CODE_038875:        DA            PHX                       ; \ Set current tile			    
CODE_038876:        8A            TXA                       ; | X = index of frame start + current tile	    
CODE_038877:        18            CLC                       ; |						    
CODE_038878:        65 03         ADC $03                   ; |						    
CODE_03887A:        AA            TAX                       ; |						    
CODE_03887B:        BD 37 88      LDA.W MegaMoleTiles,X     ; |						    
CODE_03887E:        99 02 03      STA.W OAM_Tile,Y          ; /						    
CODE_038881:        A9 01         LDA.B #$01                ; Tile properties xyppccct, format		    
CODE_038883:        A6 02         LDX $02                   ; \ If direction == 0...			    
CODE_038885:        D0 02         BNE MegaMoleGfxNoFlip     ; |						    
CODE_038887:        09 40         ORA.B #$40                ; /    ...flip tile				    
MegaMoleGfxNoFlip:  05 64         ORA $64                   ; Add in tile priority of level		    
CODE_03888B:        99 03 03      STA.W OAM_Prop,Y          ; Store tile properties			    
CODE_03888E:        FA            PLX                       ; \ Pull, current tile			    
CODE_03888F:        C8            INY                       ; | Increase index to sprite tile map ($300)... 
CODE_038890:        C8            INY                       ; |    ...we wrote 4 bytes    
CODE_038891:        C8            INY                       ; |    ...so increment 4 times 
CODE_038892:        C8            INY                       ; |     
CODE_038893:        CA            DEX                       ; | Go to next tile of frame and loop	    
CODE_038894:        10 C3         BPL MegaMoleGfxLoopSt     ; /                                             
CODE_038896:        FA            PLX                       ; Pull, X = sprite index			    
CODE_038897:        A0 02         LDY.B #$02                ; \ Will write 02 to $0460 (all 16x16 tiles) 
CODE_038899:        A9 03         LDA.B #$03                ; | A = number of tiles drawn - 1		    
CODE_03889B:        22 B3 B7 01   JSL.L FinishOAMWrite      ; / Don't draw if offscreen			    
Return03889F:       60            RTS                       ; Return 


BatTiles:                         .db $AE,$C0,$E8

Swooper:            22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_0388A7:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_0388AA:        DA            PHX                       
CODE_0388AB:        BD 02 16      LDA.W $1602,X             
CODE_0388AE:        AA            TAX                       
CODE_0388AF:        BD A0 88      LDA.W BatTiles,X          
CODE_0388B2:        99 02 03      STA.W OAM_Tile,Y          
CODE_0388B5:        FA            PLX                       
CODE_0388B6:        BD C8 14      LDA.W $14C8,X             
CODE_0388B9:        C9 08         CMP.B #$08                
CODE_0388BB:        F0 03         BEQ CODE_0388C0           
CODE_0388BD:        4C EC 84      JMP.W CODE_0384EC         

CODE_0388C0:        A5 9D         LDA RAM_SpritesLocked     
CODE_0388C2:        D0 1B         BNE Return0388DF          
CODE_0388C4:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_0388C7:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_0388CB:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_0388CF:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_0388D3:        B5 C2         LDA RAM_SpriteState,X     
CODE_0388D5:        22 DF 86 00   JSL.L ExecutePtr          

SwooperPtrs:           E4 88      .dw CODE_0388E4           
                       05 89      .dw CODE_038905           
                       36 89      .dw CODE_038936           

Return0388DF:       60            RTS                       ; Return 


DATA_0388E0:                      .db $10,$F0

DATA_0388E2:                      .db $01,$FF

CODE_0388E4:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_0388E7:        D0 1B         BNE Return038904          
CODE_0388E9:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_0388EC:        A5 0F         LDA $0F                   
CODE_0388EE:        18            CLC                       
CODE_0388EF:        69 50         ADC.B #$50                
CODE_0388F1:        C9 A0         CMP.B #$A0                
CODE_0388F3:        B0 0F         BCS Return038904          
CODE_0388F5:        F6 C2         INC RAM_SpriteState,X     
CODE_0388F7:        98            TYA                       
CODE_0388F8:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_0388FB:        A9 20         LDA.B #$20                
CODE_0388FD:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_0388FF:        A9 26         LDA.B #$26                ; \ Play sound effect 
CODE_038901:        8D FC 1D      STA.W $1DFC               ; / 
Return038904:       60            RTS                       ; Return 

CODE_038905:        A5 13         LDA RAM_FrameCounter      
CODE_038907:        29 03         AND.B #$03                
CODE_038909:        D0 0A         BNE CODE_038915           
CODE_03890B:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03890D:        F0 06         BEQ CODE_038915           
CODE_03890F:        D6 AA         DEC RAM_SpriteSpeedY,X    
CODE_038911:        D0 02         BNE CODE_038915           
CODE_038913:        F6 C2         INC RAM_SpriteState,X     
CODE_038915:        A5 13         LDA RAM_FrameCounter      
CODE_038917:        29 03         AND.B #$03                
CODE_038919:        D0 10         BNE CODE_03892B           
CODE_03891B:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_03891E:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_038920:        D9 E0 88      CMP.W DATA_0388E0,Y       
CODE_038923:        F0 06         BEQ CODE_03892B           
CODE_038925:        18            CLC                       
CODE_038926:        79 E2 88      ADC.W DATA_0388E2,Y       
CODE_038929:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03892B:        A5 14         LDA RAM_FrameCounterB     
CODE_03892D:        29 04         AND.B #$04                
CODE_03892F:        4A            LSR                       
CODE_038930:        4A            LSR                       
CODE_038931:        1A            INC A                     
CODE_038932:        9D 02 16      STA.W $1602,X             
Return038935:       60            RTS                       ; Return 

CODE_038936:        A5 13         LDA RAM_FrameCounter      
CODE_038938:        29 01         AND.B #$01                
CODE_03893A:        D0 16         BNE CODE_038952           
CODE_03893C:        BD 1C 15      LDA.W $151C,X             
CODE_03893F:        29 01         AND.B #$01                
CODE_038941:        A8            TAY                       
CODE_038942:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_038944:        18            CLC                       
CODE_038945:        79 C8 84      ADC.W BlurpAccelY,Y       
CODE_038948:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03894A:        D9 C4 84      CMP.W BlurpMaxSpeedY,Y    
CODE_03894D:        D0 03         BNE CODE_038952           
CODE_03894F:        FE 1C 15      INC.W $151C,X             
CODE_038952:        80 C1         BRA CODE_038915           


DATA_038954:                      .db $20,$E0

DATA_038956:                      .db $02,$FE

SlidingKoopa:       A9 00         LDA.B #$00                
CODE_03895A:        B4 B6         LDY RAM_SpriteSpeedX,X    
CODE_03895C:        F0 06         BEQ CODE_038964           
CODE_03895E:        10 01         BPL CODE_038961           
CODE_038960:        1A            INC A                     
CODE_038961:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_038964:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_038968:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_03896B:        BD 58 15      LDA.W $1558,X             
CODE_03896E:        C9 01         CMP.B #$01                
CODE_038970:        D0 11         BNE CODE_038983           
CODE_038972:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_038975:        48            PHA                       
CODE_038976:        A9 02         LDA.B #$02                
CODE_038978:        95 9E         STA RAM_SpriteNum,X       
CODE_03897A:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_03897E:        68            PLA                       
CODE_03897F:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_038982:        38            SEC                       
CODE_038983:        A9 86         LDA.B #$86                
CODE_038985:        90 02         BCC CODE_038989           
CODE_038987:        A9 E0         LDA.B #$E0                
CODE_038989:        99 02 03      STA.W OAM_Tile,Y          
CODE_03898C:        BD C8 14      LDA.W $14C8,X             
CODE_03898F:        C9 08         CMP.B #$08                
CODE_038991:        D0 6B         BNE Return0389FE          
CODE_038993:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_038996:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_03899A:        A5 9D         LDA RAM_SpritesLocked     
CODE_03899C:        1D 40 15      ORA.W $1540,X             
CODE_03899F:        1D 58 15      ORA.W $1558,X             
CODE_0389A2:        D0 5A         BNE Return0389FE          
CODE_0389A4:        22 2A 80 01   JSL.L UpdateSpritePos     
CODE_0389A8:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_0389AB:        29 04         AND.B #$04                ;  | 
CODE_0389AD:        F0 4F         BEQ Return0389FE          ; / 
CODE_0389AF:        20 FF 89      JSR.W CODE_0389FF         
CODE_0389B2:        A0 00         LDY.B #$00                
CODE_0389B4:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_0389B6:        F0 14         BEQ CODE_0389CC           
CODE_0389B8:        10 03         BPL CODE_0389BD           
CODE_0389BA:        49 FF         EOR.B #$FF                
CODE_0389BC:        1A            INC A                     
CODE_0389BD:        85 00         STA $00                   
CODE_0389BF:        BD B8 15      LDA.W $15B8,X             
CODE_0389C2:        F0 08         BEQ CODE_0389CC           
CODE_0389C4:        A4 00         LDY $00                   
CODE_0389C6:        55 B6         EOR RAM_SpriteSpeedX,X    
CODE_0389C8:        10 02         BPL CODE_0389CC           
CODE_0389CA:        A0 D0         LDY.B #$D0                
CODE_0389CC:        94 AA         STY RAM_SpriteSpeedY,X    
CODE_0389CE:        A5 13         LDA RAM_FrameCounter      
CODE_0389D0:        29 01         AND.B #$01                
CODE_0389D2:        D0 2A         BNE Return0389FE          
CODE_0389D4:        BD B8 15      LDA.W $15B8,X             
CODE_0389D7:        D0 13         BNE CODE_0389EC           
CODE_0389D9:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_0389DB:        D0 06         BNE CODE_0389E3           
CODE_0389DD:        A9 20         LDA.B #$20                
CODE_0389DF:        9D 58 15      STA.W $1558,X             
Return0389E2:       60            RTS                       ; Return 

CODE_0389E3:        10 04         BPL CODE_0389E9           
CODE_0389E5:        F6 B6         INC RAM_SpriteSpeedX,X    
CODE_0389E7:        F6 B6         INC RAM_SpriteSpeedX,X    
CODE_0389E9:        D6 B6         DEC RAM_SpriteSpeedX,X    
Return0389EB:       60            RTS                       ; Return 

CODE_0389EC:        0A            ASL                       
CODE_0389ED:        2A            ROL                       
CODE_0389EE:        29 01         AND.B #$01                
CODE_0389F0:        A8            TAY                       
CODE_0389F1:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_0389F3:        D9 54 89      CMP.W DATA_038954,Y       
CODE_0389F6:        F0 06         BEQ Return0389FE          
CODE_0389F8:        18            CLC                       
CODE_0389F9:        79 56 89      ADC.W DATA_038956,Y       
CODE_0389FC:        95 B6         STA RAM_SpriteSpeedX,X    
Return0389FE:       60            RTS                       ; Return 

CODE_0389FF:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_038A01:        F0 1D         BEQ Return038A20          
CODE_038A03:        A5 13         LDA RAM_FrameCounter      
CODE_038A05:        29 03         AND.B #$03                
CODE_038A07:        D0 17         BNE Return038A20          
CODE_038A09:        A9 04         LDA.B #$04                
CODE_038A0B:        85 00         STA $00                   
CODE_038A0D:        A9 0A         LDA.B #$0A                
CODE_038A0F:        85 01         STA $01                   
CODE_038A11:        20 FB B8      JSR.W IsSprOffScreenBnk3  
CODE_038A14:        D0 0A         BNE Return038A20          
CODE_038A16:        A0 03         LDY.B #$03                
CODE_038A18:        B9 C0 17      LDA.W $17C0,Y             
CODE_038A1B:        F0 04         BEQ CODE_038A21           
CODE_038A1D:        88            DEY                       
CODE_038A1E:        10 F8         BPL CODE_038A18           
Return038A20:       60            RTS                       ; Return 

CODE_038A21:        A9 03         LDA.B #$03                
CODE_038A23:        99 C0 17      STA.W $17C0,Y             
CODE_038A26:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_038A28:        18            CLC                       
CODE_038A29:        65 00         ADC $00                   
CODE_038A2B:        99 C8 17      STA.W $17C8,Y             
CODE_038A2E:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_038A30:        18            CLC                       
CODE_038A31:        65 01         ADC $01                   
CODE_038A33:        99 C4 17      STA.W $17C4,Y             
CODE_038A36:        A9 13         LDA.B #$13                
CODE_038A38:        99 CC 17      STA.W $17CC,Y             
Return038A3B:       60            RTS                       ; Return 

BowserStatue:       20 3D 8B      JSR.W BowserStatueGfx     
CODE_038A3F:        A5 9D         LDA RAM_SpritesLocked     
CODE_038A41:        D0 25         BNE Return038A68          
CODE_038A43:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_038A46:        B5 C2         LDA RAM_SpriteState,X     
CODE_038A48:        22 DF 86 00   JSL.L ExecutePtr          

BowserStatuePtrs:      57 8A      .dw CODE_038A57           
                       54 8A      .dw CODE_038A54           
                       69 8A      .dw CODE_038A69           
                       54 8A      .dw CODE_038A54           

CODE_038A54:        20 CB 8A      JSR.W CODE_038ACB         
CODE_038A57:        22 4F B4 01   JSL.L InvisBlkMainRt      
CODE_038A5B:        22 2A 80 01   JSL.L UpdateSpritePos     
CODE_038A5F:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_038A62:        29 04         AND.B #$04                ;  | 
CODE_038A64:        F0 02         BEQ Return038A68          ; / 
CODE_038A66:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
Return038A68:       60            RTS                       ; Return 

CODE_038A69:        1E 7A 16      ASL.W RAM_Tweaker167A,X   
CODE_038A6C:        5E 7A 16      LSR.W RAM_Tweaker167A,X   
CODE_038A6F:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_038A73:        9E 02 16      STZ.W $1602,X             
CODE_038A76:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_038A78:        C9 10         CMP.B #$10                
CODE_038A7A:        10 03         BPL CODE_038A7F           
CODE_038A7C:        FE 02 16      INC.W $1602,X             
CODE_038A7F:        22 2A 80 01   JSL.L UpdateSpritePos     
CODE_038A83:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not touching object 
CODE_038A86:        29 03         AND.B #$03                ;  | 
CODE_038A88:        F0 0F         BEQ CODE_038A99           ; / 
ADDR_038A8A:        B5 B6         LDA RAM_SpriteSpeedX,X    
ADDR_038A8C:        49 FF         EOR.B #$FF                
ADDR_038A8E:        1A            INC A                     
ADDR_038A8F:        95 B6         STA RAM_SpriteSpeedX,X    
ADDR_038A91:        BD 7C 15      LDA.W RAM_SpriteDir,X     
ADDR_038A94:        49 01         EOR.B #$01                
ADDR_038A96:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_038A99:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_038A9C:        29 04         AND.B #$04                ;  | 
CODE_038A9E:        F0 26         BEQ Return038AC6          ; / 
CODE_038AA0:        A9 10         LDA.B #$10                
CODE_038AA2:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_038AA4:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_038AA6:        BD 40 15      LDA.W $1540,X             
CODE_038AA9:        F0 16         BEQ CODE_038AC1           
CODE_038AAB:        3A            DEC A                     
CODE_038AAC:        D0 18         BNE Return038AC6          
CODE_038AAE:        A9 C0         LDA.B #$C0                
CODE_038AB0:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_038AB2:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_038AB5:        98            TYA                       
CODE_038AB6:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_038AB9:        B9 BF 8A      LDA.W BwsrStatueSpeed,Y   
CODE_038ABC:        95 B6         STA RAM_SpriteSpeedX,X    
Return038ABE:       60            RTS                       ; Return 


BwsrStatueSpeed:                  .db $10,$F0

CODE_038AC1:        A9 30         LDA.B #$30                
CODE_038AC3:        9D 40 15      STA.W $1540,X             
Return038AC6:       60            RTS                       ; Return 


BwserFireDispXLo:                 .db $10,$F0

BwserFireDispXHi:                 .db $00,$FF

CODE_038ACB:        8A            TXA                       
CODE_038ACC:        0A            ASL                       
CODE_038ACD:        0A            ASL                       
CODE_038ACE:        65 13         ADC RAM_FrameCounter      
CODE_038AD0:        29 7F         AND.B #$7F                
CODE_038AD2:        D0 50         BNE Return038B24          
CODE_038AD4:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_038AD8:        30 4A         BMI Return038B24          ; / 
CODE_038ADA:        A9 17         LDA.B #$17                ; \ Play sound effect 
CODE_038ADC:        8D FC 1D      STA.W $1DFC               ; / 
CODE_038ADF:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_038AE1:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_038AE4:        A9 B3         LDA.B #$B3                ; \ Sprite = Bowser Statue Fireball 
CODE_038AE6:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
CODE_038AE9:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_038AEB:        85 00         STA $00                   
CODE_038AED:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_038AF0:        85 01         STA $01                   
CODE_038AF2:        DA            PHX                       
CODE_038AF3:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_038AF6:        AA            TAX                       
CODE_038AF7:        A5 00         LDA $00                   
CODE_038AF9:        18            CLC                       
CODE_038AFA:        7D C7 8A      ADC.W BwserFireDispXLo,X  
CODE_038AFD:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_038B00:        A5 01         LDA $01                   
CODE_038B02:        7D C9 8A      ADC.W BwserFireDispXHi,X  
CODE_038B05:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_038B08:        BB            TYX                       ; \ Reset sprite tables 
CODE_038B09:        22 D2 F7 07   JSL.L InitSpriteTables    ;  | 
CODE_038B0D:        FA            PLX                       ; / 
CODE_038B0E:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_038B10:        38            SEC                       
CODE_038B11:        E9 02         SBC.B #$02                
CODE_038B13:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_038B16:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_038B19:        E9 00         SBC.B #$00                
CODE_038B1B:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_038B1E:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_038B21:        99 7C 15      STA.W RAM_SpriteDir,Y     
Return038B24:       60            RTS                       ; Return 


BwsrStatueDispX:                  .db $08,$F8,$00,$00,$08,$00

BwsrStatueDispY:                  .db $10,$F8,$00

BwsrStatueTiles:                  .db $56,$30,$41,$56,$30,$35

BwsrStatueTileSize:               .db $00,$02,$02

BwsrStatueGfxProp:                .db $00,$00,$00,$40,$40,$40

BowserStatueGfx:    20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_038B40:        BD 02 16      LDA.W $1602,X             
CODE_038B43:        85 04         STA $04                   
CODE_038B45:        49 01         EOR.B #$01                
CODE_038B47:        3A            DEC A                     
CODE_038B48:        85 03         STA $03                   
CODE_038B4A:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_038B4D:        85 05         STA $05                   
CODE_038B4F:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_038B52:        85 02         STA $02                   
CODE_038B54:        DA            PHX                       
CODE_038B55:        A2 02         LDX.B #$02                
CODE_038B57:        DA            PHX                       
CODE_038B58:        A5 02         LDA $02                   
CODE_038B5A:        D0 03         BNE CODE_038B5F           
CODE_038B5C:        E8            INX                       
CODE_038B5D:        E8            INX                       
CODE_038B5E:        E8            INX                       
CODE_038B5F:        A5 00         LDA $00                   
CODE_038B61:        18            CLC                       
CODE_038B62:        7D 25 8B      ADC.W BwsrStatueDispX,X   
CODE_038B65:        99 00 03      STA.W OAM_DispX,Y         
CODE_038B68:        BD 37 8B      LDA.W BwsrStatueGfxProp,X 
CODE_038B6B:        05 05         ORA $05                   
CODE_038B6D:        05 64         ORA $64                   
CODE_038B6F:        99 03 03      STA.W OAM_Prop,Y          
CODE_038B72:        FA            PLX                       
CODE_038B73:        A5 01         LDA $01                   
CODE_038B75:        18            CLC                       
CODE_038B76:        7D 2B 8B      ADC.W BwsrStatueDispY,X   
CODE_038B79:        99 01 03      STA.W OAM_DispY,Y         
CODE_038B7C:        DA            PHX                       
CODE_038B7D:        A5 04         LDA $04                   
CODE_038B7F:        F0 03         BEQ CODE_038B84           
CODE_038B81:        E8            INX                       
CODE_038B82:        E8            INX                       
CODE_038B83:        E8            INX                       
CODE_038B84:        BD 2E 8B      LDA.W BwsrStatueTiles,X   
CODE_038B87:        99 02 03      STA.W OAM_Tile,Y          
CODE_038B8A:        FA            PLX                       
CODE_038B8B:        5A            PHY                       
CODE_038B8C:        98            TYA                       
CODE_038B8D:        4A            LSR                       
CODE_038B8E:        4A            LSR                       
CODE_038B8F:        A8            TAY                       
CODE_038B90:        BD 34 8B      LDA.W BwsrStatueTileSize,X 
CODE_038B93:        99 60 04      STA.W OAM_TileSize,Y      
CODE_038B96:        7A            PLY                       
CODE_038B97:        C8            INY                       
CODE_038B98:        C8            INY                       
CODE_038B99:        C8            INY                       
CODE_038B9A:        C8            INY                       
CODE_038B9B:        CA            DEX                       
CODE_038B9C:        E4 03         CPX $03                   
CODE_038B9E:        D0 B7         BNE CODE_038B57           
CODE_038BA0:        FA            PLX                       
CODE_038BA1:        A0 FF         LDY.B #$FF                
CODE_038BA3:        A9 02         LDA.B #$02                
CODE_038BA5:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return038BA9:       60            RTS                       ; Return 


DATA_038BAA:                      .db $20,$20,$20,$20,$20,$20,$20,$20
                                  .db $20,$20,$20,$20,$20,$20,$20,$20
                                  .db $20,$1F,$1E,$1D,$1C,$1B,$1A,$19
                                  .db $18,$17,$16,$15,$14,$13,$12,$11
                                  .db $10,$0F,$0E,$0D,$0C,$0B,$0A,$09
                                  .db $08,$07,$06,$05,$04,$03,$02,$01
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $01,$02,$03,$04,$05,$06,$07,$08
                                  .db $09,$0A,$0B,$0C,$0D,$0E,$0F,$10
                                  .db $11,$12,$13,$14,$15,$16,$17,$18
                                  .db $19,$1A,$1B,$1C,$1D,$1E,$1F,$20
                                  .db $20,$20,$20,$20,$20,$20,$20,$20
                                  .db $20,$20,$20,$20,$20,$20,$20,$20
DATA_038C2A:                      .db $00,$F8,$00,$08

Return038C2E:       60            RTS                       ; Return 

CarrotTopLift:      20 24 8D      JSR.W CarrotTopLiftGfx    
CODE_038C32:        A5 9D         LDA RAM_SpritesLocked     
CODE_038C34:        D0 F8         BNE Return038C2E          
CODE_038C36:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_038C39:        BD 40 15      LDA.W $1540,X             
CODE_038C3C:        D0 07         BNE CODE_038C45           
CODE_038C3E:        F6 C2         INC RAM_SpriteState,X     
CODE_038C40:        A9 80         LDA.B #$80                
CODE_038C42:        9D 40 15      STA.W $1540,X             
CODE_038C45:        B5 C2         LDA RAM_SpriteState,X     
CODE_038C47:        29 03         AND.B #$03                
CODE_038C49:        A8            TAY                       
CODE_038C4A:        B9 2A 8C      LDA.W DATA_038C2A,Y       
CODE_038C4D:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_038C4F:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_038C51:        B4 9E         LDY RAM_SpriteNum,X       
CODE_038C53:        C0 B8         CPY.B #$B8                
CODE_038C55:        F0 03         BEQ CODE_038C5A           
CODE_038C57:        49 FF         EOR.B #$FF                
CODE_038C59:        1A            INC A                     
CODE_038C5A:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_038C5C:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_038C60:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_038C62:        9D 1C 15      STA.W $151C,X             
CODE_038C65:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_038C69:        20 E4 8C      JSR.W CODE_038CE4         
CODE_038C6C:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_038C70:        22 2B B7 03   JSL.L CheckForContact     
CODE_038C74:        90 6D         BCC Return038CE3          
CODE_038C76:        A5 7D         LDA RAM_MarioSpeedY       
CODE_038C78:        30 69         BMI Return038CE3          
CODE_038C7A:        A5 94         LDA RAM_MarioXPos         
CODE_038C7C:        38            SEC                       
CODE_038C7D:        FD 1C 15      SBC.W $151C,X             
CODE_038C80:        18            CLC                       
CODE_038C81:        69 1C         ADC.B #$1C                
CODE_038C83:        B4 9E         LDY RAM_SpriteNum,X       
CODE_038C85:        C0 B8         CPY.B #$B8                
CODE_038C87:        D0 03         BNE CODE_038C8C           
CODE_038C89:        18            CLC                       
CODE_038C8A:        69 38         ADC.B #$38                
CODE_038C8C:        A8            TAY                       
CODE_038C8D:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_038C90:        C9 01         CMP.B #$01                
CODE_038C92:        A9 20         LDA.B #$20                
CODE_038C94:        90 02         BCC CODE_038C98           
ADDR_038C96:        A9 30         LDA.B #$30                
CODE_038C98:        18            CLC                       
CODE_038C99:        65 96         ADC RAM_MarioYPos         
CODE_038C9B:        85 00         STA $00                   
CODE_038C9D:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_038C9F:        18            CLC                       
CODE_038CA0:        79 AA 8B      ADC.W DATA_038BAA,Y       
CODE_038CA3:        C5 00         CMP $00                   
CODE_038CA5:        10 3C         BPL Return038CE3          
CODE_038CA7:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_038CAA:        C9 01         CMP.B #$01                
CODE_038CAC:        A9 1D         LDA.B #$1D                
CODE_038CAE:        90 02         BCC CODE_038CB2           
ADDR_038CB0:        A9 2D         LDA.B #$2D                
CODE_038CB2:        85 00         STA $00                   
CODE_038CB4:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_038CB6:        18            CLC                       
CODE_038CB7:        79 AA 8B      ADC.W DATA_038BAA,Y       
CODE_038CBA:        08            PHP                       
CODE_038CBB:        38            SEC                       
CODE_038CBC:        E5 00         SBC $00                   
CODE_038CBE:        85 96         STA RAM_MarioYPos         
CODE_038CC0:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_038CC3:        E9 00         SBC.B #$00                
CODE_038CC5:        28            PLP                       
CODE_038CC6:        69 00         ADC.B #$00                
CODE_038CC8:        85 97         STA RAM_MarioYPosHi       
CODE_038CCA:        64 7D         STZ RAM_MarioSpeedY       
CODE_038CCC:        A9 01         LDA.B #$01                
CODE_038CCE:        8D 71 14      STA.W $1471               
CODE_038CD1:        A0 00         LDY.B #$00                
CODE_038CD3:        AD 91 14      LDA.W $1491               
CODE_038CD6:        10 01         BPL CODE_038CD9           
CODE_038CD8:        88            DEY                       
CODE_038CD9:        18            CLC                       
CODE_038CDA:        65 94         ADC RAM_MarioXPos         
CODE_038CDC:        85 94         STA RAM_MarioXPos         
CODE_038CDE:        98            TYA                       
CODE_038CDF:        65 95         ADC RAM_MarioXPosHi       
CODE_038CE1:        85 95         STA RAM_MarioXPosHi       
Return038CE3:       60            RTS                       ; Return 

CODE_038CE4:        A5 94         LDA RAM_MarioXPos         
CODE_038CE6:        18            CLC                       
CODE_038CE7:        69 04         ADC.B #$04                
CODE_038CE9:        85 00         STA $00                   
CODE_038CEB:        A5 95         LDA RAM_MarioXPosHi       
CODE_038CED:        69 00         ADC.B #$00                
CODE_038CEF:        85 08         STA $08                   
CODE_038CF1:        A9 08         LDA.B #$08                
CODE_038CF3:        85 02         STA $02                   
CODE_038CF5:        85 03         STA $03                   
CODE_038CF7:        A9 20         LDA.B #$20                
CODE_038CF9:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_038CFC:        F0 02         BEQ CODE_038D00           
ADDR_038CFE:        A9 30         LDA.B #$30                
CODE_038D00:        18            CLC                       
CODE_038D01:        65 96         ADC RAM_MarioYPos         
CODE_038D03:        85 01         STA $01                   
CODE_038D05:        A5 97         LDA RAM_MarioYPosHi       
CODE_038D07:        69 00         ADC.B #$00                
CODE_038D09:        85 09         STA $09                   
Return038D0B:       60            RTS                       ; Return 


DiagPlatDispX:                    .db $10,$00,$10,$00,$10,$00

DiagPlatDispY:                    .db $00,$10,$10,$00,$10,$10

DiagPlatTiles:                    .db $E4,$E0,$E2,$E4,$E0,$E2

DiagPlatGfxProp:                  .db $0B,$0B,$0B,$4B,$4B,$4B

CarrotTopLiftGfx:   20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_038D27:        DA            PHX                       
CODE_038D28:        B5 9E         LDA RAM_SpriteNum,X       
CODE_038D2A:        C9 B8         CMP.B #$B8                
CODE_038D2C:        A2 02         LDX.B #$02                
CODE_038D2E:        86 02         STX $02                   
CODE_038D30:        90 02         BCC CODE_038D34           
CODE_038D32:        A2 05         LDX.B #$05                
CODE_038D34:        A5 00         LDA $00                   
CODE_038D36:        18            CLC                       
CODE_038D37:        7D 0C 8D      ADC.W DiagPlatDispX,X     
CODE_038D3A:        99 00 03      STA.W OAM_DispX,Y         
CODE_038D3D:        A5 01         LDA $01                   
CODE_038D3F:        18            CLC                       
CODE_038D40:        7D 12 8D      ADC.W DiagPlatDispY,X     
CODE_038D43:        99 01 03      STA.W OAM_DispY,Y         
CODE_038D46:        BD 18 8D      LDA.W DiagPlatTiles,X     
CODE_038D49:        99 02 03      STA.W OAM_Tile,Y          
CODE_038D4C:        BD 1E 8D      LDA.W DiagPlatGfxProp,X   
CODE_038D4F:        05 64         ORA $64                   
CODE_038D51:        99 03 03      STA.W OAM_Prop,Y          
CODE_038D54:        C8            INY                       
CODE_038D55:        C8            INY                       
CODE_038D56:        C8            INY                       
CODE_038D57:        C8            INY                       
CODE_038D58:        CA            DEX                       
CODE_038D59:        C6 02         DEC $02                   
CODE_038D5B:        10 D7         BPL CODE_038D34           
CODE_038D5D:        FA            PLX                       
CODE_038D5E:        A0 02         LDY.B #$02                
CODE_038D60:        98            TYA                       
CODE_038D61:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return038D65:       60            RTS                       ; Return 


DATA_038D66:                      .db $00,$04,$07,$08,$08,$07,$04,$00
                                  .db $00

InfoBox:            22 4F B4 01   JSL.L InvisBlkMainRt      
CODE_038D73:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_038D76:        BD 58 15      LDA.W $1558,X             
CODE_038D79:        C9 01         CMP.B #$01                
CODE_038D7B:        D0 16         BNE CODE_038D93           
CODE_038D7D:        A9 22         LDA.B #$22                ; \ Play sound effect 
CODE_038D7F:        8D FC 1D      STA.W $1DFC               ; / 
CODE_038D82:        9E 58 15      STZ.W $1558,X             
CODE_038D85:        74 C2         STZ RAM_SpriteState,X     
CODE_038D87:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_038D89:        4A            LSR                       
CODE_038D8A:        4A            LSR                       
CODE_038D8B:        4A            LSR                       
CODE_038D8C:        4A            LSR                       
CODE_038D8D:        29 01         AND.B #$01                
CODE_038D8F:        1A            INC A                     
CODE_038D90:        8D 26 14      STA.W $1426               
CODE_038D93:        BD 58 15      LDA.W $1558,X             
CODE_038D96:        4A            LSR                       
CODE_038D97:        A8            TAY                       
CODE_038D98:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_038D9A:        48            PHA                       
CODE_038D9B:        18            CLC                       
CODE_038D9C:        79 66 8D      ADC.W DATA_038D66,Y       
CODE_038D9F:        85 1C         STA RAM_ScreenBndryYLo    
CODE_038DA1:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_038DA3:        48            PHA                       
CODE_038DA4:        69 00         ADC.B #$00                
CODE_038DA6:        85 1D         STA RAM_ScreenBndryYHi    
CODE_038DA8:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_038DAC:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_038DAF:        A9 C0         LDA.B #$C0                
CODE_038DB1:        99 02 03      STA.W OAM_Tile,Y          
CODE_038DB4:        68            PLA                       
CODE_038DB5:        85 1D         STA RAM_ScreenBndryYHi    
CODE_038DB7:        68            PLA                       
CODE_038DB8:        85 1C         STA RAM_ScreenBndryYLo    
Return038DBA:       60            RTS                       ; Return 

TimedLift:          20 12 8E      JSR.W TimedPlatformGfx    
CODE_038DBE:        A5 9D         LDA RAM_SpritesLocked     
CODE_038DC0:        D0 2D         BNE Return038DEF          
CODE_038DC2:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_038DC5:        A5 13         LDA RAM_FrameCounter      
CODE_038DC7:        29 00         AND.B #$00                
CODE_038DC9:        D0 0C         BNE CODE_038DD7           
CODE_038DCB:        B5 C2         LDA RAM_SpriteState,X     
CODE_038DCD:        F0 08         BEQ CODE_038DD7           
CODE_038DCF:        BD 70 15      LDA.W $1570,X             
CODE_038DD2:        F0 03         BEQ CODE_038DD7           
CODE_038DD4:        DE 70 15      DEC.W $1570,X             
CODE_038DD7:        BD 70 15      LDA.W $1570,X             
CODE_038DDA:        F0 14         BEQ CODE_038DF0           
CODE_038DDC:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_038DE0:        9D 28 15      STA.W $1528,X             
CODE_038DE3:        22 4F B4 01   JSL.L InvisBlkMainRt      
CODE_038DE7:        90 06         BCC Return038DEF          
CODE_038DE9:        A9 10         LDA.B #$10                
CODE_038DEB:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_038DED:        95 C2         STA RAM_SpriteState,X     
Return038DEF:       60            RTS                       ; Return 

CODE_038DF0:        22 2A 80 01   JSL.L UpdateSpritePos     
CODE_038DF4:        AD 91 14      LDA.W $1491               
CODE_038DF7:        9D 28 15      STA.W $1528,X             
CODE_038DFA:        22 4F B4 01   JSL.L InvisBlkMainRt      
Return038DFE:       60            RTS                       ; Return 


TimedPlatDispX:                   .db $00,$10,$0C

TimedPlatDispY:                   .db $00,$00,$04

TimedPlatTiles:                   .db $C4,$C4,$00

TimedPlatGfxProp:                 .db $0B,$4B,$0B

TimedPlatTileSize:                .db $02,$02,$00

TimedPlatNumTiles:                .db $B6,$B5,$B4,$B3

TimedPlatformGfx:   20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_038E15:        BD 70 15      LDA.W $1570,X             
CODE_038E18:        DA            PHX                       
CODE_038E19:        48            PHA                       
CODE_038E1A:        4A            LSR                       
CODE_038E1B:        4A            LSR                       
CODE_038E1C:        4A            LSR                       
CODE_038E1D:        4A            LSR                       
CODE_038E1E:        4A            LSR                       
CODE_038E1F:        4A            LSR                       
CODE_038E20:        AA            TAX                       
CODE_038E21:        BD 0E 8E      LDA.W TimedPlatNumTiles,X 
CODE_038E24:        85 02         STA $02                   
CODE_038E26:        A2 02         LDX.B #$02                
CODE_038E28:        68            PLA                       
CODE_038E29:        C9 08         CMP.B #$08                
CODE_038E2B:        B0 01         BCS CODE_038E2E           
CODE_038E2D:        CA            DEX                       
CODE_038E2E:        A5 00         LDA $00                   
CODE_038E30:        18            CLC                       
CODE_038E31:        7D FF 8D      ADC.W TimedPlatDispX,X    
CODE_038E34:        99 00 03      STA.W OAM_DispX,Y         
CODE_038E37:        A5 01         LDA $01                   
CODE_038E39:        18            CLC                       
CODE_038E3A:        7D 02 8E      ADC.W TimedPlatDispY,X    
CODE_038E3D:        99 01 03      STA.W OAM_DispY,Y         
CODE_038E40:        BD 05 8E      LDA.W TimedPlatTiles,X    
CODE_038E43:        E0 02         CPX.B #$02                
CODE_038E45:        D0 02         BNE CODE_038E49           
CODE_038E47:        A5 02         LDA $02                   
CODE_038E49:        99 02 03      STA.W OAM_Tile,Y          
CODE_038E4C:        BD 08 8E      LDA.W TimedPlatGfxProp,X  
CODE_038E4F:        05 64         ORA $64                   
CODE_038E51:        99 03 03      STA.W OAM_Prop,Y          
CODE_038E54:        5A            PHY                       
CODE_038E55:        98            TYA                       
CODE_038E56:        4A            LSR                       
CODE_038E57:        4A            LSR                       
CODE_038E58:        A8            TAY                       
CODE_038E59:        BD 0B 8E      LDA.W TimedPlatTileSize,X 
CODE_038E5C:        99 60 04      STA.W OAM_TileSize,Y      
CODE_038E5F:        7A            PLY                       
CODE_038E60:        C8            INY                       
CODE_038E61:        C8            INY                       
CODE_038E62:        C8            INY                       
CODE_038E63:        C8            INY                       
CODE_038E64:        CA            DEX                       
CODE_038E65:        10 C7         BPL CODE_038E2E           
CODE_038E67:        FA            PLX                       
CODE_038E68:        A0 FF         LDY.B #$FF                
CODE_038E6A:        A9 02         LDA.B #$02                
CODE_038E6C:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return038E70:       60            RTS                       ; Return 


GreyMoveBlkSpeed:                 .db $00,$F0,$00,$10

GreyMoveBlkTiming:                .db $40,$50,$40,$50

GreyCastleBlock:    20 B4 8E      JSR.W CODE_038EB4         
CODE_038E7C:        A5 9D         LDA RAM_SpritesLocked     
CODE_038E7E:        D0 27         BNE Return038EA7          
CODE_038E80:        BD 40 15      LDA.W $1540,X             
CODE_038E83:        D0 0D         BNE CODE_038E92           
CODE_038E85:        F6 C2         INC RAM_SpriteState,X     
CODE_038E87:        B5 C2         LDA RAM_SpriteState,X     
CODE_038E89:        29 03         AND.B #$03                
CODE_038E8B:        A8            TAY                       
CODE_038E8C:        B9 75 8E      LDA.W GreyMoveBlkTiming,Y 
CODE_038E8F:        9D 40 15      STA.W $1540,X             
CODE_038E92:        B5 C2         LDA RAM_SpriteState,X     
CODE_038E94:        29 03         AND.B #$03                
CODE_038E96:        A8            TAY                       
CODE_038E97:        B9 71 8E      LDA.W GreyMoveBlkSpeed,Y  
CODE_038E9A:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_038E9C:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_038EA0:        9D 28 15      STA.W $1528,X             
CODE_038EA3:        22 4F B4 01   JSL.L InvisBlkMainRt      
Return038EA7:       60            RTS                       ; Return 


GreyMoveBlkDispX:                 .db $00,$10,$00,$10

GreyMoveBlkDispY:                 .db $00,$00,$10,$10

GreyMoveBlkTiles:                 .db $CC,$CE,$EC,$EE

CODE_038EB4:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_038EB7:        DA            PHX                       
CODE_038EB8:        A2 03         LDX.B #$03                
CODE_038EBA:        A5 00         LDA $00                   
CODE_038EBC:        18            CLC                       
CODE_038EBD:        7D A8 8E      ADC.W GreyMoveBlkDispX,X  
CODE_038EC0:        99 00 03      STA.W OAM_DispX,Y         
CODE_038EC3:        A5 01         LDA $01                   
CODE_038EC5:        18            CLC                       
CODE_038EC6:        7D AC 8E      ADC.W GreyMoveBlkDispY,X  
CODE_038EC9:        99 01 03      STA.W OAM_DispY,Y         
CODE_038ECC:        BD B0 8E      LDA.W GreyMoveBlkTiles,X  
CODE_038ECF:        99 02 03      STA.W OAM_Tile,Y          
CODE_038ED2:        A9 03         LDA.B #$03                
CODE_038ED4:        05 64         ORA $64                   
CODE_038ED6:        99 03 03      STA.W OAM_Prop,Y          
CODE_038ED9:        C8            INY                       
CODE_038EDA:        C8            INY                       
CODE_038EDB:        C8            INY                       
CODE_038EDC:        C8            INY                       
CODE_038EDD:        CA            DEX                       
CODE_038EDE:        10 DA         BPL CODE_038EBA           
CODE_038EE0:        FA            PLX                       
CODE_038EE1:        A0 02         LDY.B #$02                
CODE_038EE3:        A9 03         LDA.B #$03                
CODE_038EE5:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return038EE9:       60            RTS                       ; Return 


StatueFireSpeed:                  .db $10,$F0

StatueFireball:     20 1B 8F      JSR.W StatueFireballGfx   
CODE_038EEF:        A5 9D         LDA RAM_SpritesLocked     
CODE_038EF1:        D0 13         BNE Return038F06          
CODE_038EF3:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_038EF6:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_038EFA:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_038EFD:        B9 EA 8E      LDA.W StatueFireSpeed,Y   
CODE_038F00:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_038F02:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
Return038F06:       60            RTS                       ; Return 


StatueFireDispX:                  .db $08,$00,$00,$08

StatueFireTiles:                  .db $32,$50,$33,$34,$32,$50,$33,$34
StatueFireGfxProp:                .db $09,$09,$09,$09,$89,$89,$89,$89

StatueFireballGfx:  20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_038F1E:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_038F21:        0A            ASL                       
CODE_038F22:        85 02         STA $02                   
CODE_038F24:        A5 14         LDA RAM_FrameCounterB     
CODE_038F26:        4A            LSR                       
CODE_038F27:        29 03         AND.B #$03                
CODE_038F29:        0A            ASL                       
CODE_038F2A:        85 03         STA $03                   
CODE_038F2C:        DA            PHX                       
CODE_038F2D:        A2 01         LDX.B #$01                
CODE_038F2F:        A5 01         LDA $01                   
CODE_038F31:        99 01 03      STA.W OAM_DispY,Y         
CODE_038F34:        DA            PHX                       
CODE_038F35:        8A            TXA                       
CODE_038F36:        05 02         ORA $02                   
CODE_038F38:        AA            TAX                       
CODE_038F39:        A5 00         LDA $00                   
CODE_038F3B:        18            CLC                       
CODE_038F3C:        7D 07 8F      ADC.W StatueFireDispX,X   
CODE_038F3F:        99 00 03      STA.W OAM_DispX,Y         
CODE_038F42:        68            PLA                       
CODE_038F43:        48            PHA                       
CODE_038F44:        05 03         ORA $03                   
CODE_038F46:        AA            TAX                       
CODE_038F47:        BD 0B 8F      LDA.W StatueFireTiles,X   
CODE_038F4A:        99 02 03      STA.W OAM_Tile,Y          
CODE_038F4D:        BD 13 8F      LDA.W StatueFireGfxProp,X 
CODE_038F50:        A6 02         LDX $02                   
CODE_038F52:        D0 02         BNE CODE_038F56           
ADDR_038F54:        49 40         EOR.B #$40                
CODE_038F56:        05 64         ORA $64                   
CODE_038F58:        99 03 03      STA.W OAM_Prop,Y          
CODE_038F5B:        FA            PLX                       
CODE_038F5C:        C8            INY                       
CODE_038F5D:        C8            INY                       
CODE_038F5E:        C8            INY                       
CODE_038F5F:        C8            INY                       
CODE_038F60:        CA            DEX                       
CODE_038F61:        10 CC         BPL CODE_038F2F           
CODE_038F63:        FA            PLX                       
CODE_038F64:        A0 00         LDY.B #$00                
CODE_038F66:        A9 01         LDA.B #$01                
CODE_038F68:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return038F6C:       60            RTS                       ; Return 


BooStreamFrntTiles:               .db $88,$8C,$8E,$A8,$AA,$AE,$88,$8C

ReflectingFireball: 20 F2 8F      JSR.W CODE_038FF2         
CODE_038F78:        80 2A         BRA CODE_038FA4           

BooStream:          A9 00         LDA.B #$00                
CODE_038F7C:        B4 B6         LDY RAM_SpriteSpeedX,X    
CODE_038F7E:        10 01         BPL CODE_038F81           
CODE_038F80:        1A            INC A                     
CODE_038F81:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_038F84:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_038F88:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_038F8B:        A5 14         LDA RAM_FrameCounterB     
CODE_038F8D:        4A            LSR                       
CODE_038F8E:        4A            LSR                       
CODE_038F8F:        4A            LSR                       
CODE_038F90:        4A            LSR                       
CODE_038F91:        29 01         AND.B #$01                
CODE_038F93:        85 00         STA $00                   
CODE_038F95:        8A            TXA                       
CODE_038F96:        29 03         AND.B #$03                
CODE_038F98:        0A            ASL                       
CODE_038F99:        05 00         ORA $00                   
CODE_038F9B:        DA            PHX                       
CODE_038F9C:        AA            TAX                       
CODE_038F9D:        BD 6D 8F      LDA.W BooStreamFrntTiles,X 
CODE_038FA0:        99 02 03      STA.W OAM_Tile,Y          
CODE_038FA3:        FA            PLX                       
CODE_038FA4:        BD C8 14      LDA.W $14C8,X             
CODE_038FA7:        C9 08         CMP.B #$08                
CODE_038FA9:        D0 46         BNE Return038FF1          
CODE_038FAB:        A5 9D         LDA RAM_SpritesLocked     
CODE_038FAD:        D0 42         BNE Return038FF1          
CODE_038FAF:        8A            TXA                       
CODE_038FB0:        45 14         EOR RAM_FrameCounterB     
CODE_038FB2:        29 07         AND.B #$07                
CODE_038FB4:        1D 6C 18      ORA.W RAM_OffscreenVert,X 
CODE_038FB7:        D0 09         BNE CODE_038FC2           
CODE_038FB9:        B5 9E         LDA RAM_SpriteNum,X       
CODE_038FBB:        C9 B0         CMP.B #$B0                
CODE_038FBD:        D0 03         BNE CODE_038FC2           
CODE_038FBF:        20 20 90      JSR.W CODE_039020         
CODE_038FC2:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_038FC6:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_038FCA:        22 38 91 01   JSL.L CODE_019138         
CODE_038FCE:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not touching object 
CODE_038FD1:        29 03         AND.B #$03                ;  | 
CODE_038FD3:        F0 07         BEQ CODE_038FDC           ; / 
CODE_038FD5:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_038FD7:        49 FF         EOR.B #$FF                
CODE_038FD9:        1A            INC A                     
CODE_038FDA:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_038FDC:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_038FDF:        29 0C         AND.B #$0C                
CODE_038FE1:        F0 07         BEQ CODE_038FEA           
CODE_038FE3:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_038FE5:        49 FF         EOR.B #$FF                
CODE_038FE7:        1A            INC A                     
CODE_038FE8:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_038FEA:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_038FEE:        20 5D B8      JSR.W SubOffscreen0Bnk3   
Return038FF1:       60            RTS                       ; Return 

CODE_038FF2:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_038FF6:        A5 14         LDA RAM_FrameCounterB     
CODE_038FF8:        4A            LSR                       
CODE_038FF9:        4A            LSR                       
CODE_038FFA:        A9 04         LDA.B #$04                
CODE_038FFC:        90 01         BCC CODE_038FFF           
CODE_038FFE:        0A            ASL                       
CODE_038FFF:        B4 B6         LDY RAM_SpriteSpeedX,X    
CODE_039001:        10 02         BPL CODE_039005           
CODE_039003:        49 40         EOR.B #$40                
CODE_039005:        B4 AA         LDY RAM_SpriteSpeedY,X    
CODE_039007:        30 02         BMI CODE_03900B           
CODE_039009:        49 80         EOR.B #$80                
CODE_03900B:        85 00         STA $00                   
CODE_03900D:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_039010:        A9 AC         LDA.B #$AC                
CODE_039012:        99 02 03      STA.W OAM_Tile,Y          
CODE_039015:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_039018:        29 31         AND.B #$31                
CODE_03901A:        05 00         ORA $00                   
CODE_03901C:        99 03 03      STA.W OAM_Prop,Y          
Return03901F:       60            RTS                       ; Return 

CODE_039020:        A0 0B         LDY.B #$0B                
CODE_039022:        B9 F0 17      LDA.W $17F0,Y             
CODE_039025:        F0 10         BEQ CODE_039037           
CODE_039027:        88            DEY                       
CODE_039028:        10 F8         BPL CODE_039022           
ADDR_03902A:        CE 5D 18      DEC.W $185D               
ADDR_03902D:        10 05         BPL ADDR_039034           
ADDR_03902F:        A9 0B         LDA.B #$0B                
ADDR_039031:        8D 5D 18      STA.W $185D               
ADDR_039034:        AC 5D 18      LDY.W $185D               
CODE_039037:        A9 0A         LDA.B #$0A                
CODE_039039:        99 F0 17      STA.W $17F0,Y             
CODE_03903C:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03903E:        99 08 18      STA.W $1808,Y             
CODE_039041:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_039044:        99 EA 18      STA.W $18EA,Y             
CODE_039047:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_039049:        99 FC 17      STA.W $17FC,Y             
CODE_03904C:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03904F:        99 14 18      STA.W $1814,Y             
CODE_039052:        A9 30         LDA.B #$30                
CODE_039054:        99 50 18      STA.W $1850,Y             
CODE_039057:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_039059:        99 2C 18      STA.W $182C,Y             
Return03905C:       60            RTS                       ; Return 


FishinBooAccelX:                  .db $01,$FF

FishinBooMaxSpeedX:               .db $20,$E0

FishinBooAccelY:                  .db $01,$FF

FishinBooMaxSpeedY:               .db $10,$F0

FishinBoo:          20 80 91      JSR.W FishinBooGfx        
CODE_039068:        A5 9D         LDA RAM_SpritesLocked     
CODE_03906A:        D0 7E         BNE Return0390EA          
CODE_03906C:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_039070:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_039073:        9E 02 16      STZ.W $1602,X             
CODE_039076:        BD AC 15      LDA.W $15AC,X             
CODE_039079:        F0 0B         BEQ CODE_039086           
CODE_03907B:        FE 02 16      INC.W $1602,X             
CODE_03907E:        C9 10         CMP.B #$10                
CODE_039080:        D0 04         BNE CODE_039086           
CODE_039082:        98            TYA                       
CODE_039083:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_039086:        8A            TXA                       
CODE_039087:        0A            ASL                       
CODE_039088:        0A            ASL                       
CODE_039089:        0A            ASL                       
CODE_03908A:        0A            ASL                       
CODE_03908B:        65 13         ADC RAM_FrameCounter      
CODE_03908D:        29 3F         AND.B #$3F                
CODE_03908F:        1D AC 15      ORA.W $15AC,X             
CODE_039092:        D0 05         BNE CODE_039099           
CODE_039094:        A9 20         LDA.B #$20                
CODE_039096:        9D AC 15      STA.W $15AC,X             
CODE_039099:        AD BF 18      LDA.W $18BF               
CODE_03909C:        F0 04         BEQ CODE_0390A2           
ADDR_03909E:        98            TYA                       
ADDR_03909F:        49 01         EOR.B #$01                
ADDR_0390A1:        A8            TAY                       
CODE_0390A2:        B5 B6         LDA RAM_SpriteSpeedX,X    ; \ If not at max X speed, accelerate 
CODE_0390A4:        D9 5F 90      CMP.W FishinBooMaxSpeedX,Y ;  | 
CODE_0390A7:        F0 06         BEQ CODE_0390AF           ;  | 
CODE_0390A9:        18            CLC                       ;  | 
CODE_0390AA:        79 5D 90      ADC.W FishinBooAccelX,Y   ;  | 
CODE_0390AD:        95 B6         STA RAM_SpriteSpeedX,X    ; / 
CODE_0390AF:        A5 13         LDA RAM_FrameCounter      
CODE_0390B1:        29 01         AND.B #$01                
CODE_0390B3:        D0 14         BNE CODE_0390C9           
CODE_0390B5:        B5 C2         LDA RAM_SpriteState,X     
CODE_0390B7:        29 01         AND.B #$01                
CODE_0390B9:        A8            TAY                       
CODE_0390BA:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_0390BC:        18            CLC                       
CODE_0390BD:        79 61 90      ADC.W FishinBooAccelY,Y   
CODE_0390C0:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_0390C2:        D9 63 90      CMP.W FishinBooMaxSpeedY,Y 
CODE_0390C5:        D0 02         BNE CODE_0390C9           
CODE_0390C7:        F6 C2         INC RAM_SpriteState,X     
CODE_0390C9:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_0390CB:        48            PHA                       
CODE_0390CC:        AC BF 18      LDY.W $18BF               
CODE_0390CF:        D0 0B         BNE CODE_0390DC           
CODE_0390D1:        AD BD 17      LDA.W $17BD               
CODE_0390D4:        0A            ASL                       
CODE_0390D5:        0A            ASL                       
CODE_0390D6:        0A            ASL                       
CODE_0390D7:        18            CLC                       
CODE_0390D8:        75 B6         ADC RAM_SpriteSpeedX,X    
CODE_0390DA:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_0390DC:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_0390E0:        68            PLA                       
CODE_0390E1:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_0390E3:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_0390E7:        20 F3 90      JSR.W CODE_0390F3         
Return0390EA:       60            RTS                       ; Return 


DATA_0390EB:                      .db $1A,$14,$EE,$F8

DATA_0390EF:                      .db $00,$00,$FF,$FF

CODE_0390F3:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_0390F6:        0A            ASL                       
CODE_0390F7:        7D 02 16      ADC.W $1602,X             
CODE_0390FA:        A8            TAY                       
CODE_0390FB:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_0390FD:        18            CLC                       
CODE_0390FE:        79 EB 90      ADC.W DATA_0390EB,Y       
CODE_039101:        85 04         STA $04                   
CODE_039103:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_039106:        79 EF 90      ADC.W DATA_0390EF,Y       
CODE_039109:        85 0A         STA $0A                   
CODE_03910B:        A9 04         LDA.B #$04                
CODE_03910D:        85 06         STA $06                   
CODE_03910F:        85 07         STA $07                   
CODE_039111:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_039113:        18            CLC                       
CODE_039114:        69 47         ADC.B #$47                
CODE_039116:        85 05         STA $05                   
CODE_039118:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03911B:        69 00         ADC.B #$00                
CODE_03911D:        85 0B         STA $0B                   
CODE_03911F:        22 64 B6 03   JSL.L GetMarioClipping    
CODE_039123:        22 2B B7 03   JSL.L CheckForContact     
CODE_039127:        90 04         BCC Return03912D          
ADDR_039129:        22 B7 F5 00   JSL.L HurtMario           
Return03912D:       60            RTS                       ; Return 


FishinBooDispX:                   .db $FB,$05,$00,$F2,$FD,$03,$EA,$EA
                                  .db $EA,$EA,$FB,$05,$00,$FA,$FD,$03
                                  .db $F2,$F2,$F2,$F2,$FB,$05,$00,$0E
                                  .db $03,$FD,$16,$16,$16,$16,$FB,$05
                                  .db $00,$06,$03,$FD,$0E,$0E,$0E,$0E
FishinBooDispY:                   .db $0B,$0B,$00,$03,$0F,$0F,$13,$23
                                  .db $33,$43

FishinBooTiles1:                  .db $60,$60,$64,$8A,$60,$60,$AC,$AC
                                  .db $AC,$CE

FishinBooGfxProp:                 .db $04,$04,$0D,$09,$04,$04,$0D,$0D
                                  .db $0D,$07

FishinBooTiles2:                  .db $CC,$CE,$CC,$CE

DATA_039178:                      .db $00,$00,$40,$40

DATA_03917C:                      .db $00,$40,$C0,$80

FishinBooGfx:       20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_039183:        BD 02 16      LDA.W $1602,X             
CODE_039186:        85 04         STA $04                   
CODE_039188:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_03918B:        85 02         STA $02                   
CODE_03918D:        DA            PHX                       
CODE_03918E:        5A            PHY                       
CODE_03918F:        A2 09         LDX.B #$09                
CODE_039191:        A5 01         LDA $01                   
CODE_039193:        18            CLC                       
CODE_039194:        7D 56 91      ADC.W FishinBooDispY,X    
CODE_039197:        99 01 03      STA.W OAM_DispY,Y         
CODE_03919A:        64 03         STZ $03                   
CODE_03919C:        BD 60 91      LDA.W FishinBooTiles1,X   
CODE_03919F:        E0 09         CPX.B #$09                
CODE_0391A1:        D0 11         BNE CODE_0391B4           
CODE_0391A3:        A5 14         LDA RAM_FrameCounterB     
CODE_0391A5:        4A            LSR                       
CODE_0391A6:        4A            LSR                       
CODE_0391A7:        DA            PHX                       
CODE_0391A8:        29 03         AND.B #$03                
CODE_0391AA:        AA            TAX                       
CODE_0391AB:        BD 78 91      LDA.W DATA_039178,X       
CODE_0391AE:        85 03         STA $03                   
CODE_0391B0:        BD 74 91      LDA.W FishinBooTiles2,X   
CODE_0391B3:        FA            PLX                       
CODE_0391B4:        99 02 03      STA.W OAM_Tile,Y          
CODE_0391B7:        A5 02         LDA $02                   
CODE_0391B9:        C9 01         CMP.B #$01                
CODE_0391BB:        BD 6A 91      LDA.W FishinBooGfxProp,X  
CODE_0391BE:        45 03         EOR $03                   
CODE_0391C0:        05 64         ORA $64                   
CODE_0391C2:        B0 02         BCS CODE_0391C6           
CODE_0391C4:        49 40         EOR.B #$40                
CODE_0391C6:        99 03 03      STA.W OAM_Prop,Y          
CODE_0391C9:        DA            PHX                       
CODE_0391CA:        A5 04         LDA $04                   
CODE_0391CC:        F0 05         BEQ CODE_0391D3           
CODE_0391CE:        8A            TXA                       
CODE_0391CF:        18            CLC                       
CODE_0391D0:        69 0A         ADC.B #$0A                
CODE_0391D2:        AA            TAX                       
CODE_0391D3:        A5 02         LDA $02                   
CODE_0391D5:        D0 05         BNE CODE_0391DC           
CODE_0391D7:        8A            TXA                       
CODE_0391D8:        18            CLC                       
CODE_0391D9:        69 14         ADC.B #$14                
CODE_0391DB:        AA            TAX                       
CODE_0391DC:        A5 00         LDA $00                   
CODE_0391DE:        18            CLC                       
CODE_0391DF:        7D 2E 91      ADC.W FishinBooDispX,X    
CODE_0391E2:        99 00 03      STA.W OAM_DispX,Y         
CODE_0391E5:        FA            PLX                       
CODE_0391E6:        C8            INY                       
CODE_0391E7:        C8            INY                       
CODE_0391E8:        C8            INY                       
CODE_0391E9:        C8            INY                       
CODE_0391EA:        CA            DEX                       
CODE_0391EB:        10 A4         BPL CODE_039191           
CODE_0391ED:        A5 14         LDA RAM_FrameCounterB     
CODE_0391EF:        4A            LSR                       
CODE_0391F0:        4A            LSR                       
CODE_0391F1:        4A            LSR                       
CODE_0391F2:        29 03         AND.B #$03                
CODE_0391F4:        AA            TAX                       
CODE_0391F5:        7A            PLY                       
CODE_0391F6:        BD 7C 91      LDA.W DATA_03917C,X       
CODE_0391F9:        59 13 03      EOR.W $0313,Y             
CODE_0391FC:        99 13 03      STA.W $0313,Y             
CODE_0391FF:        99 27 03      STA.W $0327,Y             
CODE_039202:        49 C0         EOR.B #$C0                
CODE_039204:        99 17 03      STA.W $0317,Y             
CODE_039207:        99 23 03      STA.W $0323,Y             
CODE_03920A:        FA            PLX                       
CODE_03920B:        A0 02         LDY.B #$02                
CODE_03920D:        A9 09         LDA.B #$09                
CODE_03920F:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return039213:       60            RTS                       ; Return 

FallingSpike:       22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_039218:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_03921B:        A9 E0         LDA.B #$E0                
CODE_03921D:        99 02 03      STA.W OAM_Tile,Y          
CODE_039220:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_039223:        3A            DEC A                     
CODE_039224:        99 01 03      STA.W OAM_DispY,Y         
CODE_039227:        BD 40 15      LDA.W $1540,X             
CODE_03922A:        F0 0B         BEQ CODE_039237           
CODE_03922C:        4A            LSR                       
CODE_03922D:        4A            LSR                       
CODE_03922E:        29 01         AND.B #$01                
CODE_039230:        18            CLC                       
CODE_039231:        79 00 03      ADC.W OAM_DispX,Y         
CODE_039234:        99 00 03      STA.W OAM_DispX,Y         
CODE_039237:        A5 9D         LDA RAM_SpritesLocked     
CODE_039239:        D0 31         BNE CODE_03926C           
CODE_03923B:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_03923E:        22 2A 80 01   JSL.L UpdateSpritePos     
CODE_039242:        B5 C2         LDA RAM_SpriteState,X     
CODE_039244:        22 DF 86 00   JSL.L ExecutePtr          

FallingSpikePtrs:      4C 92      .dw CODE_03924C           
                       62 92      .dw CODE_039262           

CODE_03924C:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03924E:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_039251:        A5 0F         LDA $0F                   
CODE_039253:        18            CLC                       
CODE_039254:        69 40         ADC.B #$40                
CODE_039256:        C9 80         CMP.B #$80                
CODE_039258:        B0 07         BCS Return039261          
CODE_03925A:        F6 C2         INC RAM_SpriteState,X     
CODE_03925C:        A9 40         LDA.B #$40                
CODE_03925E:        9D 40 15      STA.W $1540,X             
Return039261:       60            RTS                       ; Return 

CODE_039262:        BD 40 15      LDA.W $1540,X             
CODE_039265:        D0 05         BNE CODE_03926C           
CODE_039267:        22 DC A7 01   JSL.L MarioSprInteract    
Return03926B:       60            RTS                       ; Return 

CODE_03926C:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
Return03926E:       60            RTS                       ; Return 


CrtEatBlkSpeedX:                  .db $10,$F0,$00,$00,$00

CrtEatBlkSpeedY:                  .db $00,$00,$10,$F0,$00

DATA_039279:                      .db $00,$00,$01,$00,$02,$00,$00,$00
                                  .db $03,$00,$00

CreateEatBlock:     22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_039288:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_03928B:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_03928E:        3A            DEC A                     
CODE_03928F:        99 01 03      STA.W OAM_DispY,Y         
CODE_039292:        A9 2E         LDA.B #$2E                
CODE_039294:        99 02 03      STA.W OAM_Tile,Y          
CODE_039297:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_03929A:        29 3F         AND.B #$3F                
CODE_03929C:        99 03 03      STA.W OAM_Prop,Y          
CODE_03929F:        A0 02         LDY.B #$02                
CODE_0392A1:        A9 00         LDA.B #$00                
CODE_0392A3:        22 B3 B7 01   JSL.L FinishOAMWrite      
CODE_0392A7:        A0 04         LDY.B #$04                
CODE_0392A9:        AD 09 19      LDA.W $1909               
CODE_0392AC:        C9 FF         CMP.B #$FF                
CODE_0392AE:        F0 10         BEQ CODE_0392C0           
CODE_0392B0:        A5 13         LDA RAM_FrameCounter      
CODE_0392B2:        29 03         AND.B #$03                
CODE_0392B4:        05 9D         ORA RAM_SpritesLocked     
CODE_0392B6:        D0 05         BNE CODE_0392BD           
CODE_0392B8:        A9 04         LDA.B #$04                ; \ Play sound effect 
CODE_0392BA:        8D FA 1D      STA.W $1DFA               ; / 
CODE_0392BD:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_0392C0:        A5 9D         LDA RAM_SpritesLocked     
CODE_0392C2:        D0 67         BNE Return03932B          
CODE_0392C4:        B9 6F 92      LDA.W CrtEatBlkSpeedX,Y   
CODE_0392C7:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_0392C9:        B9 74 92      LDA.W CrtEatBlkSpeedY,Y   
CODE_0392CC:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_0392CE:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_0392D2:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_0392D6:        9E 28 15      STZ.W $1528,X             
CODE_0392D9:        22 4F B4 01   JSL.L InvisBlkMainRt      
CODE_0392DD:        AD 09 19      LDA.W $1909               
CODE_0392E0:        C9 FF         CMP.B #$FF                
CODE_0392E2:        F0 47         BEQ Return03932B          
CODE_0392E4:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_0392E6:        15 E4         ORA RAM_SpriteXLo,X       
CODE_0392E8:        29 0F         AND.B #$0F                
CODE_0392EA:        D0 3F         BNE Return03932B          
CODE_0392EC:        BD 1C 15      LDA.W $151C,X             
CODE_0392EF:        D0 3B         BNE CODE_03932C           
CODE_0392F1:        DE 70 15      DEC.W $1570,X             
CODE_0392F4:        30 02         BMI CODE_0392F8           
CODE_0392F6:        D0 27         BNE CODE_03931F           
CODE_0392F8:        AC B3 0D      LDY.W $0DB3               
CODE_0392FB:        B9 11 1F      LDA.W $1F11,Y             
CODE_0392FE:        C9 01         CMP.B #$01                
CODE_039300:        BC 34 15      LDY.W $1534,X             
CODE_039303:        FE 34 15      INC.W $1534,X             
CODE_039306:        B9 A4 93      LDA.W CrtEatBlkData1,Y    
CODE_039309:        B0 03         BCS CODE_03930E           
CODE_03930B:        B9 EF 93      LDA.W CrtEatBlkData2,Y    
CODE_03930E:        9D 02 16      STA.W $1602,X             
CODE_039311:        48            PHA                       
CODE_039312:        4A            LSR                       
CODE_039313:        4A            LSR                       
CODE_039314:        4A            LSR                       
CODE_039315:        4A            LSR                       
CODE_039316:        9D 70 15      STA.W $1570,X             
CODE_039319:        68            PLA                       
CODE_03931A:        29 03         AND.B #$03                
CODE_03931C:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_03931F:        A9 0D         LDA.B #$0D                
CODE_039321:        20 8B 93      JSR.W GenTileFromSpr1     
CODE_039324:        BD 02 16      LDA.W $1602,X             
CODE_039327:        C9 FF         CMP.B #$FF                
CODE_039329:        F0 5C         BEQ CODE_039387           
Return03932B:       60            RTS                       ; Return 

CODE_03932C:        A9 02         LDA.B #$02                
CODE_03932E:        20 8B 93      JSR.W GenTileFromSpr1     
CODE_039331:        A9 01         LDA.B #$01                
CODE_039333:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_039335:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_039337:        22 38 91 01   JSL.L CODE_019138         
CODE_03933B:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_03933E:        48            PHA                       
CODE_03933F:        A9 FF         LDA.B #$FF                
CODE_039341:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_039343:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_039345:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_039347:        48            PHA                       
CODE_039348:        38            SEC                       
CODE_039349:        E9 01         SBC.B #$01                
CODE_03934B:        95 E4         STA RAM_SpriteXLo,X       
CODE_03934D:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_039350:        48            PHA                       
CODE_039351:        E9 00         SBC.B #$00                
CODE_039353:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_039356:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_039358:        48            PHA                       
CODE_039359:        38            SEC                       
CODE_03935A:        E9 01         SBC.B #$01                
CODE_03935C:        95 D8         STA RAM_SpriteYLo,X       
CODE_03935E:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_039361:        48            PHA                       
CODE_039362:        E9 00         SBC.B #$00                
CODE_039364:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_039367:        22 38 91 01   JSL.L CODE_019138         
CODE_03936B:        68            PLA                       
CODE_03936C:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_03936F:        68            PLA                       
CODE_039370:        95 D8         STA RAM_SpriteYLo,X       
CODE_039372:        68            PLA                       
CODE_039373:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_039376:        68            PLA                       
CODE_039377:        95 E4         STA RAM_SpriteXLo,X       
CODE_039379:        68            PLA                       
CODE_03937A:        1D 88 15      ORA.W RAM_SprObjStatus,X  
CODE_03937D:        F0 08         BEQ CODE_039387           
CODE_03937F:        A8            TAY                       
CODE_039380:        B9 79 92      LDA.W DATA_039279,Y       
CODE_039383:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return039386:       60            RTS                       ; Return 

CODE_039387:        9E C8 14      STZ.W $14C8,X             
Return03938A:       60            RTS                       ; Return 

GenTileFromSpr1:    85 9C         STA RAM_BlockBlock        ; $9C = tile to generate 
CODE_03938D:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $9A = Sprite X position 
CODE_03938F:        85 9A         STA RAM_BlockYLo          ;  | for block creation 
CODE_039391:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_039394:        85 9B         STA RAM_BlockYHi          ; / 
CODE_039396:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $98 = Sprite Y position 
CODE_039398:        85 98         STA RAM_BlockXLo          ;  | for block creation 
CODE_03939A:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_03939D:        85 99         STA RAM_BlockXHi          ; / 
CODE_03939F:        22 B0 BE 00   JSL.L GenerateTile        ; Generate the tile 
Return0393A3:       60            RTS                       ; Return 


CrtEatBlkData1:                   .db $10,$13,$10,$13,$10,$13,$10,$13
                                  .db $10,$13,$10,$13,$10,$13,$10,$13
                                  .db $F0,$F0,$20,$12,$10,$12,$10,$12
                                  .db $10,$12,$10,$12,$10,$12,$10,$12
                                  .db $D0,$C3,$F1,$21,$22,$F1,$F1,$51
                                  .db $43,$10,$13,$10,$13,$10,$13,$F0
                                  .db $F0,$F0,$60,$32,$60,$32,$71,$32
                                  .db $60,$32,$61,$32,$70,$33,$10,$33
                                  .db $10,$33,$10,$33,$10,$33,$F0,$10
                                  .db $F2,$52,$FF

CrtEatBlkData2:                   .db $80,$13,$10,$13,$10,$13,$10,$13
                                  .db $60,$23,$20,$23,$B0,$22,$A1,$22
                                  .db $A0,$22,$A1,$22,$C0,$13,$10,$13
                                  .db $10,$13,$10,$13,$10,$13,$10,$13
                                  .db $10,$13,$F0,$F0,$F0,$52,$50,$33
                                  .db $50,$32,$50,$33,$50,$22,$50,$33
                                  .db $F0,$50,$82,$FF

WoodenSpike:        20 CF 94      JSR.W WoodSpikeGfx        
CODE_039426:        A5 9D         LDA RAM_SpritesLocked     
CODE_039428:        D0 16         BNE Return039440          
CODE_03942A:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_03942D:        20 88 94      JSR.W CODE_039488         
CODE_039430:        B5 C2         LDA RAM_SpriteState,X     
CODE_039432:        29 03         AND.B #$03                
CODE_039434:        22 DF 86 00   JSL.L ExecutePtr          

WoodenSpikePtrs:       58 94      .dw CODE_039458           
                       4E 94      .dw CODE_03944E           
                       41 94      .dw CODE_039441           
                       6B 94      .dw CODE_03946B           

Return039440:       60            RTS                       ; Return 

CODE_039441:        BD 40 15      LDA.W $1540,X             
CODE_039444:        F0 04         BEQ CODE_03944A           
CODE_039446:        A9 20         LDA.B #$20                
CODE_039448:        80 2B         BRA CODE_039475           

CODE_03944A:        A9 30         LDA.B #$30                
CODE_03944C:        80 17         BRA SetTimerNextState     

CODE_03944E:        BD 40 15      LDA.W $1540,X             
CODE_039451:        D0 04         BNE Return039457          
CODE_039453:        A9 18         LDA.B #$18                
CODE_039455:        80 0E         BRA SetTimerNextState     

Return039457:       60            RTS                       ; Return 

CODE_039458:        BD 40 15      LDA.W $1540,X             
CODE_03945B:        F0 06         BEQ CODE_039463           
CODE_03945D:        A9 F0         LDA.B #$F0                
CODE_03945F:        20 75 94      JSR.W CODE_039475         
Return039462:       60            RTS                       ; Return 

CODE_039463:        A9 30         LDA.B #$30                
SetTimerNextState:  9D 40 15      STA.W $1540,X             
CODE_039468:        F6 C2         INC RAM_SpriteState,X     ; Goto next state 
Return03946A:       60            RTS                       ; Return 

CODE_03946B:        BD 40 15      LDA.W $1540,X             ; \ If stall timer us up, 
CODE_03946E:        D0 04         BNE Return039474          ;  | reset it to #$2F... 
CODE_039470:        A9 2F         LDA.B #$2F                ;  | 
CODE_039472:        80 F1         BRA SetTimerNextState     ;  | ...and goto next state 

Return039474:       60            RTS                       ; / 

CODE_039475:        BC 1C 15      LDY.W $151C,X             
CODE_039478:        F0 03         BEQ CODE_03947D           
CODE_03947A:        49 FF         EOR.B #$FF                
CODE_03947C:        1A            INC A                     
CODE_03947D:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03947F:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
Return039483:       60            RTS                       ; Return 


DATA_039484:                      .db $01,$FF

DATA_039486:                      .db $00,$FF

CODE_039488:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_03948C:        90 22         BCC Return0394B0          
CODE_03948E:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_039491:        A5 0F         LDA $0F                   
CODE_039493:        18            CLC                       
CODE_039494:        69 04         ADC.B #$04                
CODE_039496:        C9 08         CMP.B #$08                
CODE_039498:        B0 05         BCS CODE_03949F           
CODE_03949A:        22 B7 F5 00   JSL.L HurtMario           
Return03949E:       60            RTS                       ; Return 

CODE_03949F:        A5 94         LDA RAM_MarioXPos         
CODE_0394A1:        18            CLC                       
CODE_0394A2:        79 84 94      ADC.W DATA_039484,Y       
CODE_0394A5:        85 94         STA RAM_MarioXPos         
CODE_0394A7:        A5 95         LDA RAM_MarioXPosHi       
CODE_0394A9:        79 86 94      ADC.W DATA_039486,Y       
CODE_0394AC:        85 95         STA RAM_MarioXPosHi       
CODE_0394AE:        64 7B         STZ RAM_MarioSpeedX       
Return0394B0:       60            RTS                       ; Return 


WoodSpikeDispY:                   .db $00,$10,$20,$30,$40,$40,$30,$20
                                  .db $10,$00

WoodSpikeTiles:                   .db $6A,$6A,$6A,$6A,$4A,$6A,$6A,$6A
                                  .db $6A,$4A

WoodSpikeGfxProp:                 .db $81,$81,$81,$81,$81,$01,$01,$01
                                  .db $01,$01

WoodSpikeGfx:       20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_0394D2:        64 02         STZ $02                   ; \ Set $02 based on sprite number 
CODE_0394D4:        B5 9E         LDA RAM_SpriteNum,X       ;  | 
CODE_0394D6:        C9 AD         CMP.B #$AD                ;  | 
CODE_0394D8:        D0 04         BNE CODE_0394DE           ;  | 
CODE_0394DA:        A9 05         LDA.B #$05                ;  | 
CODE_0394DC:        85 02         STA $02                   ; / 
CODE_0394DE:        DA            PHX                       
CODE_0394DF:        A2 04         LDX.B #$04                ; Draw 4 tiles: 
WoodSpikeGfxLoopSt: DA            PHX                       
CODE_0394E2:        8A            TXA                       
CODE_0394E3:        18            CLC                       
CODE_0394E4:        65 02         ADC $02                   
CODE_0394E6:        AA            TAX                       
CODE_0394E7:        A5 00         LDA $00                   ; \ Set X 
CODE_0394E9:        99 00 03      STA.W OAM_DispX,Y         ; / 
CODE_0394EC:        A5 01         LDA $01                   ; \ Set Y 
CODE_0394EE:        18            CLC                       ;  | 
CODE_0394EF:        7D B1 94      ADC.W WoodSpikeDispY,X    ;  | 
CODE_0394F2:        99 01 03      STA.W OAM_DispY,Y         ; / 
CODE_0394F5:        BD BB 94      LDA.W WoodSpikeTiles,X    ; \ Set tile 
CODE_0394F8:        99 02 03      STA.W OAM_Tile,Y          ; / 
CODE_0394FB:        BD C5 94      LDA.W WoodSpikeGfxProp,X  ; \ Set gfs properties 
CODE_0394FE:        99 03 03      STA.W OAM_Prop,Y          ; / 
CODE_039501:        C8            INY                       ; \ We wrote 4 times, so increase index by 4 
CODE_039502:        C8            INY                       ;  | 
CODE_039503:        C8            INY                       ;  | 
CODE_039504:        C8            INY                       ; / 
CODE_039505:        FA            PLX                       
CODE_039506:        CA            DEX                       
CODE_039507:        10 D8         BPL WoodSpikeGfxLoopSt    
CODE_039509:        FA            PLX                       
CODE_03950A:        A0 02         LDY.B #$02                ; \ Wrote 5 16x16 tiles... 
CODE_03950C:        A9 04         LDA.B #$04                ;  | 
CODE_03950E:        22 B3 B7 01   JSL.L FinishOAMWrite      ; / 
Return039512:       60            RTS                       ; Return 


RexSpeed:                         .db $08,$F8,$10,$F0

RexMainRt:          20 7E 96      JSR.W RexGfxRt            ; Draw Rex gfx							        
CODE_03951A:        BD C8 14      LDA.W $14C8,X             ; \ If Rex status != 8...						        
CODE_03951D:        C9 08         CMP.B #$08                ;  |   ... not (killed with spin jump [4] or star [2])		        
CODE_03951F:        D0 12         BNE RexReturn             ; /    ... return							        
CODE_039521:        A5 9D         LDA RAM_SpritesLocked     ; \ If sprites locked...						        
CODE_039523:        D0 0E         BNE RexReturn             ; /    ... return							        
CODE_039525:        BD 58 15      LDA.W $1558,X             ; \ If Rex not defeated (timer to show remains > 0)...		        
CODE_039528:        F0 0A         BEQ RexAlive              ; /    ... goto RexAlive						        
CODE_03952A:        9D D0 15      STA.W $15D0,X             ; \ 								        
CODE_03952D:        3A            DEC A                     ;  |   If Rex remains don't disappear next frame...			        
CODE_03952E:        D0 03         BNE RexReturn             ; /    ... return							        
CODE_039530:        9E C8 14      STZ.W $14C8,X             ; This is the last frame to show remains, so set Rex status = 0 
RexReturn:          60            RTS                       ; Return 

RexAlive:           20 5D B8      JSR.W SubOffscreen0Bnk3   ; Only process Rex while on screen		    
CODE_039537:        FE 70 15      INC.W $1570,X             ; Increment number of frames Rex has been on sc 
CODE_03953A:        BD 70 15      LDA.W $1570,X             ; \ Calculate which frame to show:		    
CODE_03953D:        4A            LSR                       ;  | 					    
CODE_03953E:        4A            LSR                       ;  | 					    
CODE_03953F:        B4 C2         LDY RAM_SpriteState,X     ;  | Number of hits determines if smushed	    
CODE_039541:        F0 07         BEQ CODE_03954A           ;  |						    
CODE_039543:        29 01         AND.B #$01                ;  | Update every 8 cycles if smushed	    
CODE_039545:        18            CLC                       ;  |						    
CODE_039546:        69 03         ADC.B #$03                ;  | Show smushed frame			    
CODE_039548:        80 03         BRA CODE_03954D           ;  |						    

CODE_03954A:        4A            LSR                       ;  | 					    
CODE_03954B:        29 01         AND.B #$01                ;  | Update every 16 cycles if normal	    
CODE_03954D:        9D 02 16      STA.W $1602,X             ; / Write frame to show			    
CODE_039550:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \  If sprite is not on ground...		    
CODE_039553:        29 04         AND.B #$04                ;  |    ...(4 = on ground) ...		    
CODE_039555:        F0 12         BEQ RexInAir              ; /     ...goto IN_AIR			    
CODE_039557:        A9 10         LDA.B #$10                ; \  Y speed = 10				    
CODE_039559:        95 AA         STA RAM_SpriteSpeedY,X    ; /						    
CODE_03955B:        BC 7C 15      LDY.W RAM_SpriteDir,X     ; Load, y = Rex direction, as index for speed   
CODE_03955E:        B5 C2         LDA RAM_SpriteState,X     ; \ If hits on Rex == 0...			    
CODE_039560:        F0 02         BEQ RexNoAdjustSpeed      ; /    ...goto DONT_ADJUST_SPEED		    
CODE_039562:        C8            INY                       ; \ Increment y twice...			    
CODE_039563:        C8            INY                       ; /    ...in order to get speed for smushed Rex 
RexNoAdjustSpeed:   B9 13 95      LDA.W RexSpeed,Y          ; \ Load x speed from ROM...		    
CODE_039567:        95 B6         STA RAM_SpriteSpeedX,X    ; /    ...and store it			    
RexInAir:           BD E2 1F      LDA.W $1FE2,X             ; \ If time to show half-smushed Rex > 0...	    
CODE_03956C:        D0 04         BNE RexHalfSmushed        ; /    ...goto HALF_SMUSHED			    
CODE_03956E:        22 2A 80 01   JSL.L UpdateSpritePos     ; Update position based on speed values	    
RexHalfSmushed:     BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ If Rex is touching the side of an object... 
CODE_039575:        29 03         AND.B #$03                ;  |					        
CODE_039577:        F0 08         BEQ CODE_039581           ;  |					        
CODE_039579:        BD 7C 15      LDA.W RAM_SpriteDir,X     ;  |					        
CODE_03957C:        49 01         EOR.B #$01                ;  |    ... change Rex direction	        
CODE_03957E:        9D 7C 15      STA.W RAM_SpriteDir,X     ; /					        
CODE_039581:        22 32 80 01   JSL.L SprSprInteract      ; Interact with other sprites	        
CODE_039585:        22 DC A7 01   JSL.L MarioSprInteract    ; Check for mario/Rex contact 
CODE_039589:        90 52         BCC NoRexContact          ; (carry set = mario/Rex contact)	        
CODE_03958B:        AD 90 14      LDA.W $1490               ; \ If mario star timer > 0 ...	        
CODE_03958E:        D0 62         BNE RexStarKill           ; /    ... goto HAS_STAR		        
CODE_039590:        BD 4C 15      LDA.W RAM_DisableInter,X  ; \ If Rex invincibility timer > 0 ...      
CODE_039593:        D0 48         BNE NoRexContact          ; /    ... goto NO_CONTACT		        
CODE_039595:        A9 08         LDA.B #$08                ; \ Rex invincibility timer = $08	        
CODE_039597:        9D 4C 15      STA.W RAM_DisableInter,X  ; /					        
CODE_03959A:        A5 7D         LDA RAM_MarioSpeedY       ; \  If mario's y speed < 10 ...	        
CODE_03959C:        C9 10         CMP.B #$10                ;  |   ... Rex will hurt mario	        
CODE_03959E:        30 2A         BMI RexWins               ; /    				        
MarioBeatsRex:      20 28 96      JSR.W RexPoints           ; Give mario points			        
CODE_0395A3:        22 33 AA 01   JSL.L BoostMarioSpeed     ; Set mario speed			        
CODE_0395A7:        22 99 AB 01   JSL.L DisplayContactGfx   ; Display contact graphic		        
CODE_0395AB:        AD 0D 14      LDA.W RAM_IsSpinJump      ; \  If mario is spin jumping...	        
CODE_0395AE:        0D 7A 18      ORA.W RAM_OnYoshi         ;  |    ... or on yoshi ...		        
CODE_0395B1:        D0 2B         BNE RexSpinKill           ; /     ... goto SPIN_KILL		        
CODE_0395B3:        F6 C2         INC RAM_SpriteState,X     ; Increment Rex hit counter		        
CODE_0395B5:        B5 C2         LDA RAM_SpriteState,X     ; \  If Rex hit counter == 2	        
CODE_0395B7:        C9 02         CMP.B #$02                ;  |   				        
CODE_0395B9:        D0 06         BNE SmushRex              ;  |				        
CODE_0395BB:        A9 20         LDA.B #$20                ;  |    ... time to show defeated Rex = $20 
CODE_0395BD:        9D 58 15      STA.W $1558,X             ; / 
Return0395C0:       60            RTS                       ; Return 

SmushRex:           A9 0C         LDA.B #$0C                ; \ Time to show semi-squashed Rex = $0C 
CODE_0395C3:        9D E2 1F      STA.W $1FE2,X             ; /					     
CODE_0395C6:        9E 62 16      STZ.W RAM_Tweaker1662,X   ; Change clipping area for squashed Rex  
Return0395C9:       60            RTS                       ; Return 

RexWins:            AD 97 14      LDA.W $1497               ; \ If mario is invincible...	  
CODE_0395CD:        0D 7A 18      ORA.W RAM_OnYoshi         ;  |  ... or mario on yoshi...	  
CODE_0395D0:        D0 0B         BNE NoRexContact          ; /   ... return			  
CODE_0395D2:        20 17 B8      JSR.W SubHorzPosBnk3      ; \  Set new Rex direction		  
CODE_0395D5:        98            TYA                       ;  |  				  
CODE_0395D6:        9D 7C 15      STA.W RAM_SpriteDir,X     ; /					  
CODE_0395D9:        22 B7 F5 00   JSL.L HurtMario           ; Hurt mario			  
NoRexContact:       60            RTS                       ; Return 

RexSpinKill:        A9 04         LDA.B #$04                ; \ Rex status = 4 (being killed by spin jump)   
CODE_0395E0:        9D C8 14      STA.W $14C8,X             ; /   					     
CODE_0395E3:        A9 1F         LDA.B #$1F                ; \ Set spin jump animation timer		     
CODE_0395E5:        9D 40 15      STA.W $1540,X             ; /						     
CODE_0395E8:        22 3B FC 07   JSL.L CODE_07FC3B         ; Show star animation			     
CODE_0395EC:        A9 08         LDA.B #$08                ; \ 
CODE_0395EE:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
Return0395F1:       60            RTS                       ; Return 

RexStarKill:        A9 02         LDA.B #$02                ; \ Rex status = 2 (being killed by star)			   
ADDR_0395F4:        9D C8 14      STA.W $14C8,X             ; /								   
ADDR_0395F7:        A9 D0         LDA.B #$D0                ; \ Set y speed						   
ADDR_0395F9:        95 AA         STA RAM_SpriteSpeedY,X    ; /								   
ADDR_0395FB:        20 17 B8      JSR.W SubHorzPosBnk3      ; Get new Rex direction					   
ADDR_0395FE:        B9 25 96      LDA.W RexKilledSpeed,Y    ; \ Set x speed based on Rex direction			   
ADDR_039601:        95 B6         STA RAM_SpriteSpeedX,X    ; /								   
ADDR_039603:        EE D2 18      INC.W $18D2               ; Increment number consecutive enemies killed		   
ADDR_039606:        AD D2 18      LDA.W $18D2               ; \								   
ADDR_039609:        C9 08         CMP.B #$08                ;  | If consecutive enemies stomped >= 8, reset to 8		   
ADDR_03960B:        90 05         BCC ADDR_039612           ;  |								   
ADDR_03960D:        A9 08         LDA.B #$08                ;  |								   
ADDR_03960F:        8D D2 18      STA.W $18D2               ; /   							   
ADDR_039612:        22 E5 AC 02   JSL.L GivePoints          ; Give mario points						   
ADDR_039616:        AC D2 18      LDY.W $18D2               ; \ 							   
ADDR_039619:        C0 08         CPY.B #$08                ;  | If consecutive enemies stomped < 8 ...			   
ADDR_03961B:        B0 06         BCS Return039623          ;  |								   
ADDR_03961D:        B9 FF 7F      LDA.W $7FFF,Y             ;  |    ... play sound effect				   
ADDR_039620:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
Return039623:       60            RTS                       ; Return 

Return039624:       60            RTS                       


RexKilledSpeed:                   .db $F0,$10

Return039627:       60            RTS                       

RexPoints:          5A            PHY                       
CODE_039629:        AD 97 16      LDA.W $1697               
CODE_03962C:        18            CLC                       
CODE_03962D:        7D 26 16      ADC.W $1626,X             
CODE_039630:        EE 97 16      INC.W $1697               ; Increase consecutive enemies stomped		       
CODE_039633:        A8            TAY                       ;  							     
CODE_039634:        C8            INY                       ;  							     
CODE_039635:        C0 08         CPY.B #$08                ; \ If consecutive enemies stomped >= 8 ...		       
CODE_039637:        B0 06         BCS CODE_03963F           ; /    ... don't play sound 			       
CODE_039639:        B9 FF 7F      LDA.W $7FFF,Y             ; \  
CODE_03963C:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_03963F:        98            TYA                       ; \							       
CODE_039640:        C9 08         CMP.B #$08                ;  | If consecutive enemies stomped >= 8, reset to 8       
CODE_039642:        90 02         BCC CODE_039646           ;  |						       
ADDR_039644:        A9 08         LDA.B #$08                ; /							       
CODE_039646:        22 E5 AC 02   JSL.L GivePoints          ; Give mario points					       
CODE_03964A:        7A            PLY                       ;  							     
Return03964B:       60            RTS                       ; Return 


RexTileDispX:                     .db $FC,$00,$FC,$00,$FE,$00,$00,$00
                                  .db $00,$00,$00,$08,$04,$00,$04,$00
                                  .db $02,$00,$00,$00,$00,$00,$08,$00
RexTileDispY:                     .db $F1,$00,$F0,$00,$F8,$00,$00,$00
                                  .db $00,$00,$08,$08

RexTiles:                         .db $8A,$AA,$8A,$AC,$8A,$AA,$8C,$8C
                                  .db $A8,$A8,$A2,$B2

RexGfxProp:                       .db $47,$07

RexGfxRt:           BD 58 15      LDA.W $1558,X             ; \ If time to show Rex remains > 0...							  
CODE_039681:        F0 05         BEQ RexGfxAlive           ;  |												  
CODE_039683:        A9 05         LDA.B #$05                ;  |    ...set Rex frame = 5 (fully squashed)						  
CODE_039685:        9D 02 16      STA.W $1602,X             ; /												  
RexGfxAlive:        BD E2 1F      LDA.W $1FE2,X             ; \ If time to show half smushed Rex > 0...							  
CODE_03968B:        F0 05         BEQ RexNotHalfSmushed     ;  |												  
CODE_03968D:        A9 02         LDA.B #$02                ;  |    ...set Rex frame = 2 (half smushed)							  
CODE_03968F:        9D 02 16      STA.W $1602,X             ; /												  
RexNotHalfSmushed:  20 60 B7      JSR.W GetDrawInfoBnk3     ; Y = index to sprite tile map, $00 = sprite x, $01 = sprite y 
CODE_039695:        BD 02 16      LDA.W $1602,X             ; \												  
CODE_039698:        0A            ASL                       ;  | $03 = index to frame start (frame to show * 2 tile per frame)				  
CODE_039699:        85 03         STA $03                   ; /												  
CODE_03969B:        BD 7C 15      LDA.W RAM_SpriteDir,X     ; \ $02 = sprite direction									  
CODE_03969E:        85 02         STA $02                   ; /												  
CODE_0396A0:        DA            PHX                       ; Push sprite index										  
CODE_0396A1:        A2 01         LDX.B #$01                ; Loop counter = (number of tiles per frame) - 1						  
RexGfxLoopStart:    DA            PHX                       ; Push current tile number									  
CODE_0396A4:        8A            TXA                       ; \ X = index to horizontal displacement							  
CODE_0396A5:        05 03         ORA $03                   ; / get index of tile (index to first tile of frame + current tile number)			  
CODE_0396A7:        48            PHA                       ; Push index of current tile								  
CODE_0396A8:        A6 02         LDX $02                   ; \ If facing right...									  
CODE_0396AA:        D0 03         BNE RexFaceLeft           ;  |												  
CODE_0396AC:        18            CLC                       ;  |    											  
CODE_0396AD:        69 0C         ADC.B #$0C                ; /    ...use row 2 of horizontal tile displacement table					  
RexFaceLeft:        AA            TAX                       ; \ 											  
CODE_0396B0:        A5 00         LDA $00                   ;  | Tile x position = sprite x location ($00) + tile displacement				  
CODE_0396B2:        18            CLC                       ;  |												  
CODE_0396B3:        7D 4C 96      ADC.W RexTileDispX,X      ;  |												  
CODE_0396B6:        99 00 03      STA.W OAM_DispX,Y         ; /												  
CODE_0396B9:        FA            PLX                       ; \ Pull, X = index to vertical displacement and tilemap					  
CODE_0396BA:        A5 01         LDA $01                   ;  | Tile y position = sprite y location ($01) + tile displacement				  
CODE_0396BC:        18            CLC                       ;  |												  
CODE_0396BD:        7D 64 96      ADC.W RexTileDispY,X      ;  |												  
CODE_0396C0:        99 01 03      STA.W OAM_DispY,Y         ; /												  
CODE_0396C3:        BD 70 96      LDA.W RexTiles,X          ; \ Store tile										  
CODE_0396C6:        99 02 03      STA.W OAM_Tile,Y          ; / 											  
CODE_0396C9:        A6 02         LDX $02                   ; \												  
CODE_0396CB:        BD 7C 96      LDA.W RexGfxProp,X        ;  | Get tile properties using sprite direction						  
CODE_0396CE:        05 64         ORA $64                   ;  | Level properties 
CODE_0396D0:        99 03 03      STA.W OAM_Prop,Y          ; / Store tile properties									  
CODE_0396D3:        98            TYA                       ; \ Get index to sprite property map ($460)...						  
CODE_0396D4:        4A            LSR                       ;  |    ...we use the sprite OAM index...							  
CODE_0396D5:        4A            LSR                       ;  |    ...and divide by 4 because a 16x16 tile is 4 8x8 tiles				  
CODE_0396D6:        A6 03         LDX $03                   ;  | If index of frame start is > 0A 							  
CODE_0396D8:        E0 0A         CPX.B #$0A                ;  |												  
CODE_0396DA:        AA            TAX                       ;  | 
CODE_0396DB:        A9 00         LDA.B #$00                ;  |     ...show only an 8x8 tile			   
CODE_0396DD:        B0 02         BCS Rex8x8Tile            ;  |							   
CODE_0396DF:        A9 02         LDA.B #$02                ;  | Else show a full 16 x 16 tile			   
Rex8x8Tile:         9D 60 04      STA.W OAM_TileSize,X      ; /							   
CODE_0396E4:        FA            PLX                       ; \ Pull, X = current tile of the frame we're drawing  
CODE_0396E5:        C8            INY                       ;  | Increase index to sprite tile map ($300)...	   
CODE_0396E6:        C8            INY                       ;  |    ...we wrote 4 times...			   
CODE_0396E7:        C8            INY                       ;  |    ...so increment 4 times			  
CODE_0396E8:        C8            INY                       ;  | 
CODE_0396E9:        CA            DEX                       ;  | Go to next tile of frame and loop		   
CODE_0396EA:        10 B7         BPL RexGfxLoopStart       ; / 						   
CODE_0396EC:        FA            PLX                       ; Pull, X = sprite index				   
CODE_0396ED:        A0 FF         LDY.B #$FF                ; \ FF because we already wrote size to $0460    		   
CODE_0396EF:        A9 01         LDA.B #$01                ;  | A = number of tiles drawn - 1			   
CODE_0396F1:        22 B3 B7 01   JSL.L FinishOAMWrite      ; / Don't draw if offscreen				   
Return0396F5:       60            RTS                       ; Return 

Fishbone:           20 8C 97      JSR.W FishboneGfx         
CODE_0396F9:        A5 9D         LDA RAM_SpritesLocked     
CODE_0396FB:        D0 2D         BNE Return03972A          
CODE_0396FD:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_039700:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_039704:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_039708:        8A            TXA                       
CODE_039709:        0A            ASL                       
CODE_03970A:        0A            ASL                       
CODE_03970B:        0A            ASL                       
CODE_03970C:        0A            ASL                       
CODE_03970D:        65 13         ADC RAM_FrameCounter      
CODE_03970F:        29 7F         AND.B #$7F                
CODE_039711:        D0 0D         BNE CODE_039720           
CODE_039713:        22 F9 AC 01   JSL.L GetRand             
CODE_039717:        29 01         AND.B #$01                
CODE_039719:        D0 05         BNE CODE_039720           
CODE_03971B:        A9 0C         LDA.B #$0C                
CODE_03971D:        9D 58 15      STA.W $1558,X             
CODE_039720:        B5 C2         LDA RAM_SpriteState,X     
CODE_039722:        22 DF 86 00   JSL.L ExecutePtr          

FishbonePtrs:          2F 97      .dw CODE_03972F           
                       5E 97      .dw CODE_03975E           

Return03972A:       60            RTS                       ; Return 


FishboneMaxSpeed:                 .db $10,$F0

FishboneAcceler:                  .db $01,$FF

CODE_03972F:        FE 70 15      INC.W $1570,X             
CODE_039732:        BD 70 15      LDA.W $1570,X             
CODE_039735:        EA            NOP                       
CODE_039736:        4A            LSR                       
CODE_039737:        29 01         AND.B #$01                
CODE_039739:        9D 02 16      STA.W $1602,X             
CODE_03973C:        BD 40 15      LDA.W $1540,X             
CODE_03973F:        F0 15         BEQ CODE_039756           
CODE_039741:        29 01         AND.B #$01                
CODE_039743:        D0 10         BNE Return039755          
CODE_039745:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_039748:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_03974A:        D9 2B 97      CMP.W FishboneMaxSpeed,Y  
CODE_03974D:        F0 06         BEQ Return039755          
CODE_03974F:        18            CLC                       
CODE_039750:        79 2D 97      ADC.W FishboneAcceler,Y   
CODE_039753:        95 B6         STA RAM_SpriteSpeedX,X    
Return039755:       60            RTS                       ; Return 

CODE_039756:        F6 C2         INC RAM_SpriteState,X     
CODE_039758:        A9 30         LDA.B #$30                
CODE_03975A:        9D 40 15      STA.W $1540,X             
Return03975D:       60            RTS                       ; Return 

CODE_03975E:        9E 02 16      STZ.W $1602,X             
CODE_039761:        BD 40 15      LDA.W $1540,X             
CODE_039764:        F0 10         BEQ CODE_039776           
CODE_039766:        29 03         AND.B #$03                
CODE_039768:        D0 0B         BNE Return039775          
CODE_03976A:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_03976C:        F0 07         BEQ Return039775          
CODE_03976E:        10 03         BPL CODE_039773           
CODE_039770:        F6 B6         INC RAM_SpriteSpeedX,X    
Return039772:       60            RTS                       ; Return 

CODE_039773:        D6 B6         DEC RAM_SpriteSpeedX,X    
Return039775:       60            RTS                       ; Return 

CODE_039776:        74 C2         STZ RAM_SpriteState,X     
CODE_039778:        A9 30         LDA.B #$30                
CODE_03977A:        9D 40 15      STA.W $1540,X             
Return03977D:       60            RTS                       ; Return 


FishboneDispX:                    .db $F8,$F8,$10,$10

FishboneDispY:                    .db $00,$08

FishboneGfxProp:                  .db $4D,$CD,$0D,$8D

FishboneTailTiles:                .db $A3,$A3,$B3,$B3

FishboneGfx:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_039790:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_039793:        BD 58 15      LDA.W $1558,X             
CODE_039796:        C9 01         CMP.B #$01                
CODE_039798:        A9 A6         LDA.B #$A6                
CODE_03979A:        90 02         BCC CODE_03979E           
CODE_03979C:        A9 A8         LDA.B #$A8                
CODE_03979E:        99 02 03      STA.W OAM_Tile,Y          
CODE_0397A1:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_0397A4:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_0397A7:        0A            ASL                       
CODE_0397A8:        85 02         STA $02                   
CODE_0397AA:        BD 02 16      LDA.W $1602,X             
CODE_0397AD:        0A            ASL                       
CODE_0397AE:        85 03         STA $03                   
CODE_0397B0:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_0397B3:        18            CLC                       
CODE_0397B4:        69 04         ADC.B #$04                
CODE_0397B6:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_0397B9:        A8            TAY                       
CODE_0397BA:        DA            PHX                       
CODE_0397BB:        A2 01         LDX.B #$01                
CODE_0397BD:        A5 01         LDA $01                   
CODE_0397BF:        18            CLC                       
CODE_0397C0:        7D 82 97      ADC.W FishboneDispY,X     
CODE_0397C3:        99 01 03      STA.W OAM_DispY,Y         
CODE_0397C6:        DA            PHX                       
CODE_0397C7:        8A            TXA                       
CODE_0397C8:        05 02         ORA $02                   
CODE_0397CA:        AA            TAX                       
CODE_0397CB:        A5 00         LDA $00                   
CODE_0397CD:        18            CLC                       
CODE_0397CE:        7D 7E 97      ADC.W FishboneDispX,X     
CODE_0397D1:        99 00 03      STA.W OAM_DispX,Y         
CODE_0397D4:        BD 84 97      LDA.W FishboneGfxProp,X   
CODE_0397D7:        05 64         ORA $64                   
CODE_0397D9:        99 03 03      STA.W OAM_Prop,Y          
CODE_0397DC:        68            PLA                       
CODE_0397DD:        48            PHA                       
CODE_0397DE:        05 03         ORA $03                   
CODE_0397E0:        AA            TAX                       
CODE_0397E1:        BD 88 97      LDA.W FishboneTailTiles,X 
CODE_0397E4:        99 02 03      STA.W OAM_Tile,Y          
CODE_0397E7:        FA            PLX                       
CODE_0397E8:        C8            INY                       
CODE_0397E9:        C8            INY                       
CODE_0397EA:        C8            INY                       
CODE_0397EB:        C8            INY                       
CODE_0397EC:        CA            DEX                       
CODE_0397ED:        10 CE         BPL CODE_0397BD           
CODE_0397EF:        FA            PLX                       
CODE_0397F0:        A0 00         LDY.B #$00                
CODE_0397F2:        A9 02         LDA.B #$02                
CODE_0397F4:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return0397F8:       60            RTS                       ; Return 

CODE_0397F9:        85 01         STA $01                   
CODE_0397FB:        DA            PHX                       
CODE_0397FC:        5A            PHY                       
CODE_0397FD:        20 29 B8      JSR.W SubVertPosBnk3      
CODE_039800:        84 02         STY $02                   
CODE_039802:        A5 0E         LDA $0E                   
CODE_039804:        10 05         BPL CODE_03980B           
CODE_039806:        49 FF         EOR.B #$FF                
CODE_039808:        18            CLC                       
CODE_039809:        69 01         ADC.B #$01                
CODE_03980B:        85 0C         STA $0C                   
CODE_03980D:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_039810:        84 03         STY $03                   
CODE_039812:        A5 0F         LDA $0F                   
CODE_039814:        10 05         BPL CODE_03981B           
CODE_039816:        49 FF         EOR.B #$FF                
CODE_039818:        18            CLC                       
CODE_039819:        69 01         ADC.B #$01                
CODE_03981B:        85 0D         STA $0D                   
CODE_03981D:        A0 00         LDY.B #$00                
CODE_03981F:        A5 0D         LDA $0D                   
CODE_039821:        C5 0C         CMP $0C                   
CODE_039823:        B0 09         BCS CODE_03982E           
CODE_039825:        C8            INY                       
CODE_039826:        48            PHA                       
CODE_039827:        A5 0C         LDA $0C                   
CODE_039829:        85 0D         STA $0D                   
CODE_03982B:        68            PLA                       
CODE_03982C:        85 0C         STA $0C                   
CODE_03982E:        A9 00         LDA.B #$00                
CODE_039830:        85 0B         STA $0B                   
CODE_039832:        85 00         STA $00                   
CODE_039834:        A6 01         LDX $01                   
CODE_039836:        A5 0B         LDA $0B                   
CODE_039838:        18            CLC                       
CODE_039839:        65 0C         ADC $0C                   
CODE_03983B:        C5 0D         CMP $0D                   
CODE_03983D:        90 04         BCC CODE_039843           
CODE_03983F:        E5 0D         SBC $0D                   
CODE_039841:        E6 00         INC $00                   
CODE_039843:        85 0B         STA $0B                   
CODE_039845:        CA            DEX                       
CODE_039846:        D0 EE         BNE CODE_039836           
CODE_039848:        98            TYA                       
CODE_039849:        F0 0A         BEQ CODE_039855           
CODE_03984B:        A5 00         LDA $00                   
CODE_03984D:        48            PHA                       
CODE_03984E:        A5 01         LDA $01                   
CODE_039850:        85 00         STA $00                   
CODE_039852:        68            PLA                       
CODE_039853:        85 01         STA $01                   
CODE_039855:        A5 00         LDA $00                   
CODE_039857:        A4 02         LDY $02                   
CODE_039859:        F0 07         BEQ CODE_039862           
CODE_03985B:        49 FF         EOR.B #$FF                
CODE_03985D:        18            CLC                       
CODE_03985E:        69 01         ADC.B #$01                
CODE_039860:        85 00         STA $00                   
CODE_039862:        A5 01         LDA $01                   
CODE_039864:        A4 03         LDY $03                   
CODE_039866:        F0 07         BEQ CODE_03986F           
CODE_039868:        49 FF         EOR.B #$FF                
CODE_03986A:        18            CLC                       
CODE_03986B:        69 01         ADC.B #$01                
CODE_03986D:        85 01         STA $01                   
CODE_03986F:        7A            PLY                       
CODE_039870:        FA            PLX                       
Return039871:       60            RTS                       ; Return 

ReznorInit:         E0 07         CPX.B #$07                
CODE_039874:        D0 08         BNE CODE_03987E           
CODE_039876:        A9 04         LDA.B #$04                
CODE_039878:        95 C2         STA RAM_SpriteState,X     
CODE_03987A:        22 7D DD 03   JSL.L CODE_03DD7D         
CODE_03987E:        22 F9 AC 01   JSL.L GetRand             
CODE_039882:        9D 70 15      STA.W $1570,X             
Return039885:       6B            RTL                       ; Return 


ReznorStartPosLo:                 .db $00,$80,$00,$80

ReznorStartPosHi:                 .db $00,$00,$01,$01

ReboundSpeedX:                    .db $20,$E0

Reznor:             EE 0F 14      INC.W $140F               
CODE_039893:        A5 9D         LDA RAM_SpritesLocked     
CODE_039895:        F0 03         BEQ ReznorNotLocked       
CODE_039897:        4C 7B 9A      JMP.W DrawReznor          

ReznorNotLocked:    E0 07         CPX.B #$07                
CODE_03989C:        D0 72         BNE CODE_039910           
CODE_03989E:        DA            PHX                       
CODE_03989F:        22 0C D7 03   JSL.L CODE_03D70C         ; Break bridge when necessary 
ReznorSignCode:     A9 80         LDA.B #$80                ; \ Set radius for Reznor sign rotation 
CODE_0398A5:        85 2A         STA $2A                   ;  | 
CODE_0398A7:        64 2B         STZ $2B                   ; / 
CODE_0398A9:        A2 00         LDX.B #$00                
CODE_0398AB:        A9 C0         LDA.B #$C0                ; \ X position of Reznor sign 
CODE_0398AD:        85 E4         STA RAM_SpriteXLo         ;  | 
CODE_0398AF:        9C E0 14      STZ.W RAM_SpriteXHi       ; / 
CODE_0398B2:        A9 B2         LDA.B #$B2                ; \ Y position of Reznor sign 
CODE_0398B4:        85 D8         STA RAM_SpriteYLo         ;  | 
CODE_0398B6:        9C D4 14      STZ.W RAM_SpriteYHi       ; / 
CODE_0398B9:        A9 2C         LDA.B #$2C                
CODE_0398BB:        8D A2 1B      STA.W $1BA2               
CODE_0398BE:        22 DF DE 03   JSL.L CODE_03DEDF         ; Applies position changes to Reznor sign 
CODE_0398C2:        FA            PLX                       ; Pull, X = sprite index 
CODE_0398C3:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0398C5:        A5 36         LDA $36                   ; \ Rotate 1 frame around the circle (clockwise) 
CODE_0398C7:        18            CLC                       ;  | $37,36 = 0 to 1FF, denotes circle position 
CODE_0398C8:        69 01 00      ADC.W #$0001              ;  | 
CODE_0398CB:        29 FF 01      AND.W #$01FF              ;  | 
CODE_0398CE:        85 36         STA $36                   ; / 
CODE_0398D0:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0398D2:        E0 07         CPX.B #$07                
CODE_0398D4:        D0 3A         BNE CODE_039910           
CODE_0398D6:        BD 3E 16      LDA.W $163E,X             ; \ Branch if timer to trigger level isn't set 
CODE_0398D9:        F0 11         BEQ ReznorNoLevelEnd      ; / 
CODE_0398DB:        3A            DEC A                     
CODE_0398DC:        D0 32         BNE CODE_039910           
CODE_0398DE:        CE C6 13      DEC.W $13C6               ; Prevent mario from walking at level end 
CODE_0398E1:        A9 FF         LDA.B #$FF                ; \ Set time before return to overworld 
CODE_0398E3:        8D 93 14      STA.W $1493               ; / 
CODE_0398E6:        A9 0B         LDA.B #$0B                ; \ 
CODE_0398E8:        8D FB 1D      STA.W $1DFB               ; / Play sound effect 
Return0398EB:       60            RTS                       ; Return 

ReznorNoLevelEnd:   AD 23 15      LDA.W RAM_Reznor4Dead     ; \ 
CODE_0398EF:        18            CLC                       ;  | 
CODE_0398F0:        6D 22 15      ADC.W RAM_Reznor3Dead     ;  | 
CODE_0398F3:        6D 21 15      ADC.W RAM_Reznor2Dead     ;  | 
CODE_0398F6:        6D 20 15      ADC.W RAM_Reznor1Dead     ;  | 
CODE_0398F9:        C9 04         CMP.B #$04                ;  | 
CODE_0398FB:        D0 13         BNE CODE_039910           ;  | 
CODE_0398FD:        A9 90         LDA.B #$90                ;  | Set time to trigger level if all Reznors are dead 
CODE_0398FF:        9D 3E 16      STA.W $163E,X             ; / 
CODE_039902:        22 C8 A6 03   JSL.L KillMostSprites     
CODE_039906:        A0 07         LDY.B #$07                ; \ Zero out extended sprite table 
CODE_039908:        A9 00         LDA.B #$00                ;  | 
CODE_03990A:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ;  | 
CODE_03990D:        88            DEY                       ;  | 
CODE_03990E:        10 FA         BPL CODE_03990A           ; / 
CODE_039910:        BD C8 14      LDA.W $14C8,X             
CODE_039913:        C9 08         CMP.B #$08                
CODE_039915:        F0 03         BEQ CODE_03991A           
CODE_039917:        4C 7B 9A      JMP.W DrawReznor          

CODE_03991A:        8A            TXA                       ; \ Load Y with Reznor number (0-3)				  
CODE_03991B:        29 03         AND.B #$03                ;  |							  
CODE_03991D:        A8            TAY                       ; /								  
CODE_03991E:        A5 36         LDA $36                   ; \								  
CODE_039920:        18            CLC                       ;  |							  
CODE_039921:        79 86 98      ADC.W ReznorStartPosLo,Y  ;  |							  
CODE_039924:        85 00         STA $00                   ;  | $01,00 = 0-1FF, position Reznors on the circle		  
CODE_039926:        A5 37         LDA $37                   ;  |							  
CODE_039928:        79 8A 98      ADC.W ReznorStartPosHi,Y  ;  |							  
CODE_03992B:        29 01         AND.B #$01                ;  |							  
CODE_03992D:        85 01         STA $01                   ; /								  
CODE_03992F:        C2 30         REP #$30                  ; \   Index (16 bit) Accum (16 bit)  ; Index (16 bit) Accum (16 bit) 
CODE_039931:        A5 00         LDA $00                   ;  | Make Reznors turn clockwise rather than counter clockwise 
CODE_039933:        49 FF 01      EOR.W #$01FF              ;  | ($01,00 = -1 * $01,00)					 							  
CODE_039936:        1A            INC A                     ;  |							  
CODE_039937:        85 00         STA $00                   ; /                                                           
CODE_039939:        18            CLC                       
CODE_03993A:        69 80 00      ADC.W #$0080              
CODE_03993D:        29 FF 01      AND.W #$01FF              
CODE_039940:        85 02         STA $02                   
CODE_039942:        A5 00         LDA $00                   
CODE_039944:        29 FF 00      AND.W #$00FF              
CODE_039947:        0A            ASL                       
CODE_039948:        AA            TAX                       
CODE_039949:        BF DB F7 07   LDA.L CircleCoords,X      
CODE_03994D:        85 04         STA $04                   
CODE_03994F:        A5 02         LDA $02                   
CODE_039951:        29 FF 00      AND.W #$00FF              
CODE_039954:        0A            ASL                       
CODE_039955:        AA            TAX                       
CODE_039956:        BF DB F7 07   LDA.L CircleCoords,X      
CODE_03995A:        85 06         STA $06                   
CODE_03995C:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_03995E:        A5 04         LDA $04                   
CODE_039960:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_039963:        A9 38         LDA.B #$38                
CODE_039965:        A4 05         LDY $05                   
CODE_039967:        D0 0F         BNE CODE_039978           
CODE_039969:        8D 03 42      STA.W $4203               ; Multplier B
CODE_03996C:        EA            NOP                       
CODE_03996D:        EA            NOP                       
CODE_03996E:        EA            NOP                       
CODE_03996F:        EA            NOP                       
CODE_039970:        0E 16 42      ASL.W $4216               ; Product/Remainder Result (Low Byte)
CODE_039973:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_039976:        69 00         ADC.B #$00                
CODE_039978:        46 01         LSR $01                   
CODE_03997A:        90 03         BCC CODE_03997F           
CODE_03997C:        49 FF         EOR.B #$FF                
CODE_03997E:        1A            INC A                     
CODE_03997F:        85 04         STA $04                   
CODE_039981:        A5 06         LDA $06                   
CODE_039983:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_039986:        A9 38         LDA.B #$38                
CODE_039988:        A4 07         LDY $07                   
CODE_03998A:        D0 0F         BNE CODE_03999B           
CODE_03998C:        8D 03 42      STA.W $4203               ; Multplier B
CODE_03998F:        EA            NOP                       
CODE_039990:        EA            NOP                       
CODE_039991:        EA            NOP                       
CODE_039992:        EA            NOP                       
CODE_039993:        0E 16 42      ASL.W $4216               ; Product/Remainder Result (Low Byte)
CODE_039996:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_039999:        69 00         ADC.B #$00                
CODE_03999B:        46 03         LSR $03                   
CODE_03999D:        90 03         BCC CODE_0399A2           
CODE_03999F:        49 FF         EOR.B #$FF                
CODE_0399A1:        1A            INC A                     
CODE_0399A2:        85 06         STA $06                   
CODE_0399A4:        AE E9 15      LDX.W $15E9               ; X = sprite index 
CODE_0399A7:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_0399A9:        48            PHA                       
CODE_0399AA:        64 00         STZ $00                   
CODE_0399AC:        A5 04         LDA $04                   
CODE_0399AE:        10 02         BPL CODE_0399B2           
CODE_0399B0:        C6 00         DEC $00                   
CODE_0399B2:        18            CLC                       
CODE_0399B3:        65 2A         ADC $2A                   
CODE_0399B5:        08            PHP                       
CODE_0399B6:        18            CLC                       
CODE_0399B7:        69 40         ADC.B #$40                
CODE_0399B9:        95 E4         STA RAM_SpriteXLo,X       
CODE_0399BB:        A5 2B         LDA $2B                   
CODE_0399BD:        69 00         ADC.B #$00                
CODE_0399BF:        28            PLP                       
CODE_0399C0:        65 00         ADC $00                   
CODE_0399C2:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_0399C5:        68            PLA                       
CODE_0399C6:        38            SEC                       
CODE_0399C7:        F5 E4         SBC RAM_SpriteXLo,X       
CODE_0399C9:        49 FF         EOR.B #$FF                
CODE_0399CB:        1A            INC A                     
CODE_0399CC:        9D 28 15      STA.W $1528,X             
CODE_0399CF:        64 01         STZ $01                   
CODE_0399D1:        A5 06         LDA $06                   
CODE_0399D3:        10 02         BPL CODE_0399D7           
CODE_0399D5:        C6 01         DEC $01                   
CODE_0399D7:        18            CLC                       
CODE_0399D8:        65 2C         ADC $2C                   
CODE_0399DA:        08            PHP                       
CODE_0399DB:        69 20         ADC.B #$20                
CODE_0399DD:        95 D8         STA RAM_SpriteYLo,X       
CODE_0399DF:        A5 2D         LDA $2D                   
CODE_0399E1:        69 00         ADC.B #$00                
CODE_0399E3:        28            PLP                       
CODE_0399E4:        65 01         ADC $01                   
CODE_0399E6:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_0399E9:        BD 1C 15      LDA.W $151C,X             ; \ If a Reznor is dead, make it's platform standable 
CODE_0399EC:        F0 07         BEQ ReznorAlive           ;  | 
CODE_0399EE:        22 4F B4 01   JSL.L InvisBlkMainRt      ;  | 
CODE_0399F2:        4C 7B 9A      JMP.W DrawReznor          ; / 

ReznorAlive:        A5 13         LDA RAM_FrameCounter      ; \ Don't try to spit fire if turning 
CODE_0399F7:        29 00         AND.B #$00                ;  | 
CODE_0399F9:        1D AC 15      ORA.W $15AC,X             ;  | 
CODE_0399FC:        D0 12         BNE NoSetRznrFireTime     ; / 
CODE_0399FE:        FE 70 15      INC.W $1570,X             
CODE_039A01:        BD 70 15      LDA.W $1570,X             
CODE_039A04:        C9 00         CMP.B #$00                
CODE_039A06:        D0 08         BNE NoSetRznrFireTime     
CODE_039A08:        9E 70 15      STZ.W $1570,X             
CODE_039A0B:        A9 40         LDA.B #$40                ; \ Set time to show firing graphic = 0A 
CODE_039A0D:        9D 58 15      STA.W $1558,X             ; / 
NoSetRznrFireTime:  8A            TXA                       
CODE_039A11:        0A            ASL                       
CODE_039A12:        0A            ASL                       
CODE_039A13:        0A            ASL                       
CODE_039A14:        0A            ASL                       
CODE_039A15:        65 14         ADC RAM_FrameCounterB     
CODE_039A17:        29 3F         AND.B #$3F                
CODE_039A19:        1D 58 15      ORA.W $1558,X             ; Firing 
CODE_039A1C:        1D AC 15      ORA.W $15AC,X             ; Turning 
CODE_039A1F:        D0 16         BNE NoSetRenrTurnTime     
CODE_039A21:        BD 7C 15      LDA.W RAM_SpriteDir,X     ; \ if direction has changed since last frame...		   
CODE_039A24:        48            PHA                       ;  |							   
CODE_039A25:        20 17 B8      JSR.W SubHorzPosBnk3      ;  |							   
CODE_039A28:        98            TYA                       ;  |							   
CODE_039A29:        9D 7C 15      STA.W RAM_SpriteDir,X     ;  |							   
CODE_039A2C:        68            PLA                       ;  |							   
CODE_039A2D:        DD 7C 15      CMP.W RAM_SpriteDir,X     ;  |							   
CODE_039A30:        F0 05         BEQ NoSetRenrTurnTime     ;  |							   
CODE_039A32:        A9 0A         LDA.B #$0A                ;  | ...set time to show turning graphic = 0A		   
CODE_039A34:        9D AC 15      STA.W $15AC,X             ; /								   
NoSetRenrTurnTime:  BD 4C 15      LDA.W RAM_DisableInter,X  ; \ If disable interaction timer > 0, just draw Reznor	   
CODE_039A3A:        D0 3F         BNE DrawReznor            ; /								   
CODE_039A3C:        22 DC A7 01   JSL.L MarioSprInteract    ; \ Interact with mario					   
CODE_039A40:        90 39         BCC DrawReznor            ; / If no contact, just draw Reznor				   
CODE_039A42:        A9 08         LDA.B #$08                ; \ Disable interaction timer = 08				   
CODE_039A44:        9D 4C 15      STA.W RAM_DisableInter,X  ; / (eg. after hitting Reznor, or getting bounced by platform) 
CODE_039A47:        A5 96         LDA RAM_MarioYPos         ; \ Compare y positions to see if mario hit Reznor		   
CODE_039A49:        38            SEC                       ;  |							   
CODE_039A4A:        F5 D8         SBC RAM_SpriteYLo,X       ;  |							   
CODE_039A4C:        C9 ED         CMP.B #$ED                ;  |							   
CODE_039A4E:        30 27         BMI HitReznor             ; /								   
CODE_039A50:        C9 F2         CMP.B #$F2                ; \ See if mario hit side of the platform			   
CODE_039A52:        30 19         BMI HitPlatSide           ;  |							   
CODE_039A54:        A5 7D         LDA RAM_MarioSpeedY       ;  |							   
CODE_039A56:        10 15         BPL HitPlatSide           ; /								   
HitPlatBottom:      A9 29         LDA.B #$29                ; ??Something about boosting mario on platform?? 
CODE_039A5A:        9D 62 16      STA.W RAM_Tweaker1662,X   ;  								   
CODE_039A5D:        A9 0F         LDA.B #$0F                ; \ Time to bounce platform = 0F				   
CODE_039A5F:        9D 64 15      STA.W $1564,X             ; /								   
CODE_039A62:        A9 10         LDA.B #$10                ; \ Set mario's y speed to rebound down off platform	   
CODE_039A64:        85 7D         STA RAM_MarioSpeedY       ; /								   
CODE_039A66:        A9 01         LDA.B #$01                ; \ 
CODE_039A68:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_039A6B:        80 0E         BRA DrawReznor            

HitPlatSide:        20 17 B8      JSR.W SubHorzPosBnk3      ; \ Set mario to bounce back				   
CODE_039A70:        B9 8E 98      LDA.W ReboundSpeedX,Y     ;  | (hit side of platform?)				   
CODE_039A73:        85 7B         STA RAM_MarioSpeedX       ;  |							   
CODE_039A75:        80 04         BRA DrawReznor            ; /                                                            

HitReznor:          22 B7 F5 00   JSL.L HurtMario           ; Hurt Mario 
DrawReznor:         9E 02 16      STZ.W $1602,X             ; Set normal image 
CODE_039A7E:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_039A81:        48            PHA                       
CODE_039A82:        BC AC 15      LDY.W $15AC,X             
CODE_039A85:        F0 0E         BEQ ReznorNoTurning       
CODE_039A87:        C0 05         CPY.B #$05                
CODE_039A89:        90 05         BCC ReznorTurning         
CODE_039A8B:        49 01         EOR.B #$01                
CODE_039A8D:        9D 7C 15      STA.W RAM_SpriteDir,X     
ReznorTurning:      A9 02         LDA.B #$02                ; \ Set turning image 
CODE_039A92:        9D 02 16      STA.W $1602,X             ; / 
ReznorNoTurning:    BD 58 15      LDA.W $1558,X             ; \ Shoot fire if "time to show firing image" == 20	        
CODE_039A98:        F0 0C         BEQ ReznorNoFiring        ;  |						        
CODE_039A9A:        C9 20         CMP.B #$20                ;  | (shows image for 20 frames after the fireball is shot) 
CODE_039A9C:        D0 03         BNE ReznorFiring          ;  |						        
CODE_039A9E:        20 F8 9A      JSR.W ReznorFireRt        ; /							        
ReznorFiring:       A9 01         LDA.B #$01                ; \ Set firing image				        
CODE_039AA3:        9D 02 16      STA.W $1602,X             ; /							        
ReznorNoFiring:     20 75 9B      JSR.W ReznorGfxRt         ; Draw Reznor                                               
CODE_039AA9:        68            PLA                       
CODE_039AAA:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_039AAD:        A5 9D         LDA RAM_SpritesLocked     ; \ If sprites locked, or mario already killed the Reznor on the platform, return		   
CODE_039AAF:        1D 1C 15      ORA.W $151C,X             ;  |											   
CODE_039AB2:        D0 43         BNE Return039AF7          ; /												   
CODE_039AB4:        BD 64 15      LDA.W $1564,X             ; \ If time to bounce platform != 0C, return						   
CODE_039AB7:        C9 0C         CMP.B #$0C                ;  | (causes delay between start of boucing platform and killing Reznor)			   
CODE_039AB9:        D0 3C         BNE Return039AF7          ; /												   
KillReznor:         A9 03         LDA.B #$03                ; \ 
CODE_039ABD:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_039AC0:        9E 58 15      STZ.W $1558,X             ; Prevent from throwing fire after death							   
CODE_039AC3:        FE 1C 15      INC.W $151C,X             ; Record a hit on Reznor									   
CODE_039AC6:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Load Y with a free sprite index for dead Reznor						   
CODE_039ACA:        30 2B         BMI Return039AF7          ; / Return if no free index									   
CODE_039ACC:        A9 02         LDA.B #$02                ; \ Set status to being killed								   
CODE_039ACE:        99 C8 14      STA.W $14C8,Y             ; /												   
CODE_039AD1:        A9 A9         LDA.B #$A9                ; \ Sprite to use for dead Reznor								   
CODE_039AD3:        99 9E 00      STA.W RAM_SpriteNum,Y     ; /												   
CODE_039AD6:        B5 E4         LDA RAM_SpriteXLo,X       ; \ Transfer x position to dead Reznor							   
CODE_039AD8:        99 E4 00      STA.W RAM_SpriteXLo,Y     ;  |											   
CODE_039ADB:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  |											   
CODE_039ADE:        99 E0 14      STA.W RAM_SpriteXHi,Y     ; /												   
CODE_039AE1:        B5 D8         LDA RAM_SpriteYLo,X       ; \ Transfer y position to dead Reznor							   
CODE_039AE3:        99 D8 00      STA.W RAM_SpriteYLo,Y     ;  |											   
CODE_039AE6:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  |											   
CODE_039AE9:        99 D4 14      STA.W RAM_SpriteYHi,Y     ; /												   
CODE_039AEC:        DA            PHX                       ; \ 											   
CODE_039AED:        BB            TYX                       ;  | Before: X must have index of sprite being generated					   
CODE_039AEE:        22 D2 F7 07   JSL.L InitSpriteTables    ; /  Routine clears all old sprite values and loads in new values for the 6 main sprite tables 
CODE_039AF2:        A9 C0         LDA.B #$C0                ; \ Set y speed for Reznor's bounce off the platform					   
CODE_039AF4:        95 AA         STA RAM_SpriteSpeedY,X    ; /												   
CODE_039AF6:        FA            PLX                       ; pull, X = sprite index                                                                       
Return039AF7:       60            RTS                       ; Return 

ReznorFireRt:       A0 07         LDY.B #$07                ; \ find a free extended sprite slot, return if all full 
CODE_039AFA:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   ;  | 
CODE_039AFD:        F0 04         BEQ FoundRznrFireSlot     ;  | 
CODE_039AFF:        88            DEY                       ;  | 
CODE_039B00:        10 F8         BPL CODE_039AFA           ;  | 
Return039B02:       60            RTS                       ; / Return if no free slots 

FoundRznrFireSlot:  A9 10         LDA.B #$10                ; \ 
CODE_039B05:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_039B08:        A9 02         LDA.B #$02                ; \ Extended sprite = Reznor fireball 
CODE_039B0A:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_039B0D:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_039B0F:        48            PHA                       
CODE_039B10:        38            SEC                       
CODE_039B11:        E9 08         SBC.B #$08                
CODE_039B13:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
CODE_039B16:        95 E4         STA RAM_SpriteXLo,X       
CODE_039B18:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_039B1B:        E9 00         SBC.B #$00                
CODE_039B1D:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
CODE_039B20:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_039B22:        48            PHA                       
CODE_039B23:        38            SEC                       
CODE_039B24:        E9 14         SBC.B #$14                
CODE_039B26:        95 D8         STA RAM_SpriteYLo,X       
CODE_039B28:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
CODE_039B2B:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_039B2E:        48            PHA                       
CODE_039B2F:        E9 00         SBC.B #$00                
CODE_039B31:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
CODE_039B34:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_039B37:        A9 10         LDA.B #$10                
CODE_039B39:        20 F9 97      JSR.W CODE_0397F9         
CODE_039B3C:        68            PLA                       
CODE_039B3D:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_039B40:        68            PLA                       
CODE_039B41:        95 D8         STA RAM_SpriteYLo,X       
CODE_039B43:        68            PLA                       
CODE_039B44:        95 E4         STA RAM_SpriteXLo,X       
CODE_039B46:        A5 00         LDA $00                   
CODE_039B48:        99 3D 17      STA.W RAM_ExSprSpeedY,Y   
CODE_039B4B:        A5 01         LDA $01                   
CODE_039B4D:        99 47 17      STA.W RAM_ExSprSpeedX,Y   
Return039B50:       60            RTS                       ; Return 


ReznorTileDispX:                  .db $00,$F0,$00,$F0,$F0,$00,$F0,$00
ReznorTileDispY:                  .db $E0,$E0,$F0,$F0

ReznorTiles:                      .db $40,$42,$60,$62,$44,$46,$64,$66
                                  .db $28,$28,$48,$48

ReznorPal:                        .db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F
                                  .db $7F,$3F,$7F,$3F

ReznorGfxRt:        BD 1C 15      LDA.W $151C,X             ; \ if the reznor is dead, only draw the platform			  
CODE_039B78:        D0 65         BNE DrawReznorPlats       ; /									  
CODE_039B7A:        20 60 B7      JSR.W GetDrawInfoBnk3     ; after: Y = index to sprite tile map, $00 = sprite x, $01 = sprite y 
CODE_039B7D:        BD 02 16      LDA.W $1602,X             ; \ $03 = index to frame start (frame to show * 4 tiles per frame)	  
CODE_039B80:        0A            ASL                       ;  | 								  
CODE_039B81:        0A            ASL                       ;  |								  
CODE_039B82:        85 03         STA $03                   ; /									  
CODE_039B84:        BD 7C 15      LDA.W RAM_SpriteDir,X     ; \ $02 = direction index						  
CODE_039B87:        0A            ASL                       ;  |								  
CODE_039B88:        0A            ASL                       ;  |								  
CODE_039B89:        85 02         STA $02                   ; /                                                                   
CODE_039B8B:        DA            PHX                       
CODE_039B8C:        A2 03         LDX.B #$03                
RznrGfxLoopStart:   DA            PHX                       
CODE_039B8F:        A5 03         LDA $03                   
CODE_039B91:        C9 08         CMP.B #$08                
CODE_039B93:        B0 04         BCS CODE_039B99           
CODE_039B95:        8A            TXA                       
CODE_039B96:        05 02         ORA $02                   
CODE_039B98:        AA            TAX                       
CODE_039B99:        A5 00         LDA $00                   
CODE_039B9B:        18            CLC                       
CODE_039B9C:        7D 51 9B      ADC.W ReznorTileDispX,X   
CODE_039B9F:        99 00 03      STA.W OAM_DispX,Y         
CODE_039BA2:        FA            PLX                       
CODE_039BA3:        A5 01         LDA $01                   
CODE_039BA5:        18            CLC                       
CODE_039BA6:        7D 59 9B      ADC.W ReznorTileDispY,X   
CODE_039BA9:        99 01 03      STA.W OAM_DispY,Y         
CODE_039BAC:        DA            PHX                       
CODE_039BAD:        8A            TXA                       
CODE_039BAE:        05 03         ORA $03                   
CODE_039BB0:        AA            TAX                       
CODE_039BB1:        BD 5D 9B      LDA.W ReznorTiles,X       ; \ set tile					  
CODE_039BB4:        99 02 03      STA.W OAM_Tile,Y          ; /							  
CODE_039BB7:        BD 69 9B      LDA.W ReznorPal,X         ; \ set palette/properties				  
CODE_039BBA:        E0 08         CPX.B #$08                ;  | if turning, don't flip				  
CODE_039BBC:        B0 06         BCS NoReznorGfxFlip       ;  | 						  
CODE_039BBE:        A6 02         LDX $02                   ;  | if direction = 0, don't flip			  
CODE_039BC0:        D0 02         BNE NoReznorGfxFlip       ;  |						  
CODE_039BC2:        49 40         EOR.B #$40                ;  |						  
NoReznorGfxFlip:    99 03 03      STA.W OAM_Prop,Y          ; /							  
CODE_039BC7:        FA            PLX                       ; \ pull, X = current tile of the frame we're drawing 
CODE_039BC8:        C8            INY                       ;  | Increase index to sprite tile map ($300)...	  
CODE_039BC9:        C8            INY                       ;  |    ...we wrote 4 bytes...			  
CODE_039BCA:        C8            INY                       ;  |    ...so increment 4 times			  
CODE_039BCB:        C8            INY                       ;  |    						  
CODE_039BCC:        CA            DEX                       ;  | Go to next tile of frame and loop		  
CODE_039BCD:        10 BF         BPL RznrGfxLoopStart      ; / 						  
CODE_039BCF:        FA            PLX                       ; \							  
CODE_039BD0:        A0 02         LDY.B #$02                ;  | Y = 02 (All 16x16 tiles)			  
CODE_039BD2:        A9 03         LDA.B #$03                ;  | A = number of tiles drawn - 1			  
CODE_039BD4:        22 B3 B7 01   JSL.L FinishOAMWrite      ; / Don't draw if offscreen                           
CODE_039BD8:        BD C8 14      LDA.W $14C8,X             
CODE_039BDB:        C9 02         CMP.B #$02                
CODE_039BDD:        F0 03         BEQ Return039BE2          
DrawReznorPlats:    20 EB 9B      JSR.W ReznorPlatGfxRt     
Return039BE2:       60            RTS                       ; Return 


ReznorPlatDispY:                  .db $00,$03,$04,$05,$05,$04,$03,$00

ReznorPlatGfxRt:    BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_039BEE:        18            CLC                       
CODE_039BEF:        69 10         ADC.B #$10                
CODE_039BF1:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_039BF4:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_039BF7:        BD 64 15      LDA.W $1564,X             
CODE_039BFA:        4A            LSR                       
CODE_039BFB:        5A            PHY                       
CODE_039BFC:        A8            TAY                       
CODE_039BFD:        B9 E3 9B      LDA.W ReznorPlatDispY,Y   
CODE_039C00:        85 02         STA $02                   
CODE_039C02:        7A            PLY                       
CODE_039C03:        A5 00         LDA $00                   
CODE_039C05:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_039C08:        38            SEC                       
CODE_039C09:        E9 10         SBC.B #$10                
CODE_039C0B:        99 00 03      STA.W OAM_DispX,Y         
CODE_039C0E:        A5 01         LDA $01                   
CODE_039C10:        38            SEC                       
CODE_039C11:        E5 02         SBC $02                   
CODE_039C13:        99 01 03      STA.W OAM_DispY,Y         
CODE_039C16:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_039C19:        A9 4E         LDA.B #$4E                ; \ Tile of reznor platform...     
CODE_039C1B:        99 02 03      STA.W OAM_Tile,Y          ;  | ...store left side	       
CODE_039C1E:        99 06 03      STA.W OAM_Tile2,Y         ; /  ...store right side	       
CODE_039C21:        A9 33         LDA.B #$33                ; \ Palette of reznor platform...  
CODE_039C23:        99 03 03      STA.W OAM_Prop,Y          ;  |			       
CODE_039C26:        09 40         ORA.B #$40                ;  | ...flip right side	       
CODE_039C28:        99 07 03      STA.W OAM_Tile2Prop,Y     ; /				       
CODE_039C2B:        A0 02         LDY.B #$02                ; \				       
CODE_039C2D:        A9 01         LDA.B #$01                ;  | A = number of tiles drawn - 1 
CODE_039C2F:        22 B3 B7 01   JSL.L FinishOAMWrite      ; / Don't draw if offscreen        
Return039C33:       60            RTS                       ; Return 

InvisBlk+DinosMain: B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if sprite isn't "Invisible solid block" 
CODE_039C36:        C9 6D         CMP.B #$6D                ;  | 
CODE_039C38:        D0 05         BNE DinoMainRt            ; / 
CODE_039C3A:        22 4F B4 01   JSL.L InvisBlkMainRt      ; \ Call "Invisible solid block" routine 
Return039C3E:       6B            RTL                       ; Return 

DinoMainRt:         8B            PHB                       
CODE_039C40:        4B            PHK                       
CODE_039C41:        AB            PLB                       
CODE_039C42:        20 47 9C      JSR.W DinoMainSubRt       
CODE_039C45:        AB            PLB                       
Return039C46:       6B            RTL                       ; Return 

DinoMainSubRt:      20 49 9E      JSR.W DinoGfxRt           
CODE_039C4A:        A5 9D         LDA RAM_SpritesLocked     
CODE_039C4C:        D0 55         BNE Return039CA3          
CODE_039C4E:        BD C8 14      LDA.W $14C8,X             
CODE_039C51:        C9 08         CMP.B #$08                
CODE_039C53:        D0 4E         BNE Return039CA3          
CODE_039C55:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_039C58:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_039C5C:        22 2A 80 01   JSL.L UpdateSpritePos     
CODE_039C60:        B5 C2         LDA RAM_SpriteState,X     
CODE_039C62:        22 DF 86 00   JSL.L ExecutePtr          

RhinoStatePtrs:        A8 9C      .dw CODE_039CA8           
                       41 9D      .dw CODE_039D41           
                       41 9D      .dw CODE_039D41           
                       74 9C      .dw CODE_039C74           

DATA_039C6E:                      .db $00,$FE,$02

DATA_039C71:                      .db $00,$FF,$00

CODE_039C74:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_039C76:        30 11         BMI CODE_039C89           
CODE_039C78:        74 C2         STZ RAM_SpriteState,X     
CODE_039C7A:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not touching object 
CODE_039C7D:        29 03         AND.B #$03                ;  | 
CODE_039C7F:        F0 08         BEQ CODE_039C89           ; / 
CODE_039C81:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_039C84:        49 01         EOR.B #$01                
CODE_039C86:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_039C89:        9E 02 16      STZ.W $1602,X             
CODE_039C8C:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_039C8F:        29 03         AND.B #$03                
CODE_039C91:        A8            TAY                       
CODE_039C92:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_039C94:        18            CLC                       
CODE_039C95:        79 6E 9C      ADC.W DATA_039C6E,Y       
CODE_039C98:        95 E4         STA RAM_SpriteXLo,X       
CODE_039C9A:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_039C9D:        79 71 9C      ADC.W DATA_039C71,Y       
CODE_039CA0:        9D E0 14      STA.W RAM_SpriteXHi,X     
Return039CA3:       60            RTS                       ; Return 


DinoSpeed:                        .db $08,$F8,$10,$F0

CODE_039CA8:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_039CAB:        29 04         AND.B #$04                ;  | 
CODE_039CAD:        F0 DA         BEQ CODE_039C89           ; / 
CODE_039CAF:        BD 40 15      LDA.W $1540,X             
CODE_039CB2:        D0 14         BNE CODE_039CC8           
CODE_039CB4:        B5 9E         LDA RAM_SpriteNum,X       
CODE_039CB6:        C9 6E         CMP.B #$6E                
CODE_039CB8:        F0 0E         BEQ CODE_039CC8           
CODE_039CBA:        A9 FF         LDA.B #$FF                ; \ Set fire breathing timer 
CODE_039CBC:        9D 40 15      STA.W $1540,X             ; / 
CODE_039CBF:        22 F9 AC 01   JSL.L GetRand             
CODE_039CC3:        29 01         AND.B #$01                
CODE_039CC5:        1A            INC A                     
CODE_039CC6:        95 C2         STA RAM_SpriteState,X     
CODE_039CC8:        8A            TXA                       
CODE_039CC9:        0A            ASL                       
CODE_039CCA:        0A            ASL                       
CODE_039CCB:        0A            ASL                       
CODE_039CCC:        0A            ASL                       
CODE_039CCD:        65 14         ADC RAM_FrameCounterB     
CODE_039CCF:        29 3F         AND.B #$3F                
CODE_039CD1:        D0 07         BNE CODE_039CDA           
CODE_039CD3:        20 17 B8      JSR.W SubHorzPosBnk3      ; \ If not facing mario, change directions 
CODE_039CD6:        98            TYA                       ;  | 
CODE_039CD7:        9D 7C 15      STA.W RAM_SpriteDir,X     ; / 
CODE_039CDA:        A9 10         LDA.B #$10                
CODE_039CDC:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_039CDE:        BC 7C 15      LDY.W RAM_SpriteDir,X     ; \ Set x speed for rhino based on direction and sprite number 
CODE_039CE1:        B5 9E         LDA RAM_SpriteNum,X       ;  | 
CODE_039CE3:        C9 6E         CMP.B #$6E                ;  | 
CODE_039CE5:        F0 02         BEQ CODE_039CE9           ;  | 
CODE_039CE7:        C8            INY                       ;  | 
CODE_039CE8:        C8            INY                       ;  | 
CODE_039CE9:        B9 A4 9C      LDA.W DinoSpeed,Y         ;  | 
CODE_039CEC:        95 B6         STA RAM_SpriteSpeedX,X    ; / 
CODE_039CEE:        20 EF 9D      JSR.W DinoSetGfxFrame     
CODE_039CF1:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not touching object 
CODE_039CF4:        29 03         AND.B #$03                ;  | 
CODE_039CF6:        F0 08         BEQ Return039D00          ; / 
CODE_039CF8:        A9 C0         LDA.B #$C0                
CODE_039CFA:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_039CFC:        A9 03         LDA.B #$03                
CODE_039CFE:        95 C2         STA RAM_SpriteState,X     
Return039D00:       60            RTS                       ; Return 


DinoFlameTable:                   .db $41,$42,$42,$32,$22,$12,$02,$02
                                  .db $02,$02,$02,$02,$02,$02,$02,$02
                                  .db $02,$02,$02,$02,$02,$02,$02,$12
                                  .db $22,$32,$42,$42,$42,$42,$41,$41
                                  .db $41,$43,$43,$33,$23,$13,$03,$03
                                  .db $03,$03,$03,$03,$03,$03,$03,$03
                                  .db $03,$03,$03,$03,$03,$03,$03,$13
                                  .db $23,$33,$43,$43,$43,$43,$41,$41

CODE_039D41:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_039D43:        BD 40 15      LDA.W $1540,X             
CODE_039D46:        D0 09         BNE DinoFlameTimerSet     
CODE_039D48:        74 C2         STZ RAM_SpriteState,X     
CODE_039D4A:        A9 40         LDA.B #$40                
CODE_039D4C:        9D 40 15      STA.W $1540,X             
CODE_039D4F:        A9 00         LDA.B #$00                
DinoFlameTimerSet:  C9 C0         CMP.B #$C0                
CODE_039D53:        D0 05         BNE CODE_039D5A           
CODE_039D55:        A0 17         LDY.B #$17                ; \ Play sound effect 
CODE_039D57:        8C FC 1D      STY.W $1DFC               ; / 
CODE_039D5A:        4A            LSR                       
CODE_039D5B:        4A            LSR                       
CODE_039D5C:        4A            LSR                       
CODE_039D5D:        B4 C2         LDY RAM_SpriteState,X     
CODE_039D5F:        C0 02         CPY.B #$02                
CODE_039D61:        D0 03         BNE CODE_039D66           
CODE_039D63:        18            CLC                       
CODE_039D64:        69 20         ADC.B #$20                
CODE_039D66:        A8            TAY                       
CODE_039D67:        B9 01 9D      LDA.W DinoFlameTable,Y    
CODE_039D6A:        48            PHA                       
CODE_039D6B:        29 0F         AND.B #$0F                
CODE_039D6D:        9D 02 16      STA.W $1602,X             
CODE_039D70:        68            PLA                       
CODE_039D71:        4A            LSR                       
CODE_039D72:        4A            LSR                       
CODE_039D73:        4A            LSR                       
CODE_039D74:        4A            LSR                       
CODE_039D75:        9D 1C 15      STA.W $151C,X             
CODE_039D78:        D0 23         BNE Return039D9D          
CODE_039D7A:        B5 9E         LDA RAM_SpriteNum,X       
CODE_039D7C:        C9 6E         CMP.B #$6E                
CODE_039D7E:        F0 1D         BEQ Return039D9D          
CODE_039D80:        8A            TXA                       
CODE_039D81:        45 13         EOR RAM_FrameCounter      
CODE_039D83:        29 03         AND.B #$03                
CODE_039D85:        D0 16         BNE Return039D9D          
CODE_039D87:        20 B6 9D      JSR.W DinoFlameClipping   
CODE_039D8A:        22 64 B6 03   JSL.L GetMarioClipping    
CODE_039D8E:        22 2B B7 03   JSL.L CheckForContact     
CODE_039D92:        90 09         BCC Return039D9D          
ADDR_039D94:        AD 90 14      LDA.W $1490               ; \ Branch if Mario has star 
ADDR_039D97:        D0 04         BNE Return039D9D          ; / 
ADDR_039D99:        22 B7 F5 00   JSL.L HurtMario           
Return039D9D:       60            RTS                       ; Return 


DinoFlame1:                       .db $DC,$02,$10,$02

DinoFlame2:                       .db $FF,$00,$00,$00

DinoFlame3:                       .db $24,$0C,$24,$0C

DinoFlame4:                       .db $02,$DC,$02,$DC

DinoFlame5:                       .db $00,$FF,$00,$FF

DinoFlame6:                       .db $0C,$24,$0C,$24

DinoFlameClipping:  BD 02 16      LDA.W $1602,X             
CODE_039DB9:        38            SEC                       
CODE_039DBA:        E9 02         SBC.B #$02                
CODE_039DBC:        A8            TAY                       
CODE_039DBD:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_039DC0:        D0 02         BNE CODE_039DC4           
CODE_039DC2:        C8            INY                       
CODE_039DC3:        C8            INY                       
CODE_039DC4:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_039DC6:        18            CLC                       
CODE_039DC7:        79 9E 9D      ADC.W DinoFlame1,Y        
CODE_039DCA:        85 04         STA $04                   
CODE_039DCC:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_039DCF:        79 A2 9D      ADC.W DinoFlame2,Y        
CODE_039DD2:        85 0A         STA $0A                   
CODE_039DD4:        B9 A6 9D      LDA.W DinoFlame3,Y        
CODE_039DD7:        85 06         STA $06                   
CODE_039DD9:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_039DDB:        18            CLC                       
CODE_039DDC:        79 AA 9D      ADC.W DinoFlame4,Y        
CODE_039DDF:        85 05         STA $05                   
CODE_039DE1:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_039DE4:        79 AE 9D      ADC.W DinoFlame5,Y        
CODE_039DE7:        85 0B         STA $0B                   
CODE_039DE9:        B9 B2 9D      LDA.W DinoFlame6,Y        
CODE_039DEC:        85 07         STA $07                   
Return039DEE:       60            RTS                       ; Return 

DinoSetGfxFrame:    FE 70 15      INC.W $1570,X             
CODE_039DF2:        BD 70 15      LDA.W $1570,X             
CODE_039DF5:        29 08         AND.B #$08                
CODE_039DF7:        4A            LSR                       
CODE_039DF8:        4A            LSR                       
CODE_039DF9:        4A            LSR                       
CODE_039DFA:        9D 02 16      STA.W $1602,X             
Return039DFD:       60            RTS                       ; Return 


DinoTorchTileDispX:               .db $D8,$E0,$EC,$F8,$00,$FF,$FF,$FF
                                  .db $FF,$00

DinoTorchTileDispY:               .db $00,$00,$00,$00,$00,$D8,$E0,$EC
                                  .db $F8,$00

DinoFlameTiles:                   .db $80,$82,$84,$86,$00,$88,$8A,$8C
                                  .db $8E,$00

DinoTorchGfxProp:                 .db $09,$05,$05,$05,$0F

DinoTorchTiles:                   .db $EA,$AA,$C4,$C6

DinoRhinoTileDispX:               .db $F8,$08,$F8,$08,$08,$F8,$08,$F8
DinoRhinoGfxProp:                 .db $2F,$2F,$2F,$2F,$6F,$6F,$6F,$6F
DinoRhinoTileDispY:               .db $F0,$F0,$00,$00

DinoRhinoTiles:                   .db $C0,$C2,$E4,$E6,$C0,$C2,$E0,$E2
                                  .db $C8,$CA,$E8,$E2,$CC,$CE,$EC,$EE

DinoGfxRt:          20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_039E4C:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_039E4F:        85 02         STA $02                   
CODE_039E51:        BD 02 16      LDA.W $1602,X             
CODE_039E54:        85 04         STA $04                   
CODE_039E56:        B5 9E         LDA RAM_SpriteNum,X       
CODE_039E58:        C9 6F         CMP.B #$6F                
CODE_039E5A:        F0 4D         BEQ CODE_039EA9           
CODE_039E5C:        DA            PHX                       
CODE_039E5D:        A2 03         LDX.B #$03                
CODE_039E5F:        86 0F         STX $0F                   
CODE_039E61:        A5 02         LDA $02                   
CODE_039E63:        C9 01         CMP.B #$01                
CODE_039E65:        B0 05         BCS CODE_039E6C           
CODE_039E67:        8A            TXA                       
CODE_039E68:        18            CLC                       
CODE_039E69:        69 04         ADC.B #$04                
CODE_039E6B:        AA            TAX                       
CODE_039E6C:        BD 2D 9E      LDA.W DinoRhinoGfxProp,X  
CODE_039E6F:        99 03 03      STA.W OAM_Prop,Y          
CODE_039E72:        BD 25 9E      LDA.W DinoRhinoTileDispX,X 
CODE_039E75:        18            CLC                       
CODE_039E76:        65 00         ADC $00                   
CODE_039E78:        99 00 03      STA.W OAM_DispX,Y         
CODE_039E7B:        A5 04         LDA $04                   
CODE_039E7D:        C9 01         CMP.B #$01                
CODE_039E7F:        A6 0F         LDX $0F                   
CODE_039E81:        BD 35 9E      LDA.W DinoRhinoTileDispY,X 
CODE_039E84:        65 01         ADC $01                   
CODE_039E86:        99 01 03      STA.W OAM_DispY,Y         
CODE_039E89:        A5 04         LDA $04                   
CODE_039E8B:        0A            ASL                       
CODE_039E8C:        0A            ASL                       
CODE_039E8D:        65 0F         ADC $0F                   
CODE_039E8F:        AA            TAX                       
CODE_039E90:        BD 39 9E      LDA.W DinoRhinoTiles,X    
CODE_039E93:        99 02 03      STA.W OAM_Tile,Y          
CODE_039E96:        C8            INY                       
CODE_039E97:        C8            INY                       
CODE_039E98:        C8            INY                       
CODE_039E99:        C8            INY                       
CODE_039E9A:        A6 0F         LDX $0F                   
CODE_039E9C:        CA            DEX                       
CODE_039E9D:        10 C0         BPL CODE_039E5F           
CODE_039E9F:        FA            PLX                       
CODE_039EA0:        A9 03         LDA.B #$03                
CODE_039EA2:        A0 02         LDY.B #$02                
CODE_039EA4:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return039EA8:       60            RTS                       ; Return 

CODE_039EA9:        BD 1C 15      LDA.W $151C,X             
CODE_039EAC:        85 03         STA $03                   
CODE_039EAE:        BD 02 16      LDA.W $1602,X             
CODE_039EB1:        85 04         STA $04                   
CODE_039EB3:        DA            PHX                       
CODE_039EB4:        A5 14         LDA RAM_FrameCounterB     
CODE_039EB6:        29 02         AND.B #$02                
CODE_039EB8:        0A            ASL                       
CODE_039EB9:        0A            ASL                       
CODE_039EBA:        0A            ASL                       
CODE_039EBB:        0A            ASL                       
CODE_039EBC:        0A            ASL                       
CODE_039EBD:        A6 04         LDX $04                   
CODE_039EBF:        E0 03         CPX.B #$03                
CODE_039EC1:        F0 01         BEQ CODE_039EC4           
CODE_039EC3:        0A            ASL                       
CODE_039EC4:        85 05         STA $05                   
CODE_039EC6:        A2 04         LDX.B #$04                
CODE_039EC8:        86 06         STX $06                   
CODE_039ECA:        A5 04         LDA $04                   
CODE_039ECC:        C9 03         CMP.B #$03                
CODE_039ECE:        D0 05         BNE CODE_039ED5           
CODE_039ED0:        8A            TXA                       
CODE_039ED1:        18            CLC                       
CODE_039ED2:        69 05         ADC.B #$05                
CODE_039ED4:        AA            TAX                       
CODE_039ED5:        DA            PHX                       
CODE_039ED6:        BD FE 9D      LDA.W DinoTorchTileDispX,X 
CODE_039ED9:        A6 02         LDX $02                   
CODE_039EDB:        D0 03         BNE CODE_039EE0           
CODE_039EDD:        49 FF         EOR.B #$FF                
CODE_039EDF:        1A            INC A                     
CODE_039EE0:        FA            PLX                       
CODE_039EE1:        18            CLC                       
CODE_039EE2:        65 00         ADC $00                   
CODE_039EE4:        99 00 03      STA.W OAM_DispX,Y         
CODE_039EE7:        BD 08 9E      LDA.W DinoTorchTileDispY,X 
CODE_039EEA:        18            CLC                       
CODE_039EEB:        65 01         ADC $01                   
CODE_039EED:        99 01 03      STA.W OAM_DispY,Y         
CODE_039EF0:        A5 06         LDA $06                   
CODE_039EF2:        C9 04         CMP.B #$04                
CODE_039EF4:        D0 07         BNE CODE_039EFD           
CODE_039EF6:        A6 04         LDX $04                   
CODE_039EF8:        BD 21 9E      LDA.W DinoTorchTiles,X    
CODE_039EFB:        80 03         BRA CODE_039F00           

CODE_039EFD:        BD 12 9E      LDA.W DinoFlameTiles,X    
CODE_039F00:        99 02 03      STA.W OAM_Tile,Y          
CODE_039F03:        A9 00         LDA.B #$00                
CODE_039F05:        A6 02         LDX $02                   
CODE_039F07:        D0 02         BNE CODE_039F0B           
CODE_039F09:        09 40         ORA.B #$40                
CODE_039F0B:        A6 06         LDX $06                   
CODE_039F0D:        E0 04         CPX.B #$04                
CODE_039F0F:        F0 02         BEQ CODE_039F13           
CODE_039F11:        45 05         EOR $05                   
CODE_039F13:        1D 1C 9E      ORA.W DinoTorchGfxProp,X  
CODE_039F16:        05 64         ORA $64                   
CODE_039F18:        99 03 03      STA.W OAM_Prop,Y          
CODE_039F1B:        C8            INY                       
CODE_039F1C:        C8            INY                       
CODE_039F1D:        C8            INY                       
CODE_039F1E:        C8            INY                       
CODE_039F1F:        CA            DEX                       
CODE_039F20:        E4 03         CPX $03                   
CODE_039F22:        10 A4         BPL CODE_039EC8           
CODE_039F24:        FA            PLX                       
CODE_039F25:        BC 1C 15      LDY.W $151C,X             
CODE_039F28:        B9 32 9F      LDA.W DinoTilesWritten,Y  
CODE_039F2B:        A0 02         LDY.B #$02                
CODE_039F2D:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return039F31:       60            RTS                       ; Return 


DinoTilesWritten:                 .db $04,$03,$02,$01,$00

Return039F37:       60            RTS                       

Blargg:             20 62 A0      JSR.W CODE_03A062         
CODE_039F3B:        A5 9D         LDA RAM_SpritesLocked     
CODE_039F3D:        D0 17         BNE Return039F56          
CODE_039F3F:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_039F43:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_039F46:        B5 C2         LDA RAM_SpriteState,X     
CODE_039F48:        22 DF 86 00   JSL.L ExecutePtr          

BlarggPtrs:            57 9F      .dw CODE_039F57           
                       8B 9F      .dw CODE_039F8B           
                       A4 9F      .dw CODE_039FA4           
                       C8 9F      .dw CODE_039FC8           
                       EF 9F      .dw CODE_039FEF           

Return039F56:       60            RTS                       ; Return 

CODE_039F57:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_039F5A:        1D 40 15      ORA.W $1540,X             
CODE_039F5D:        D0 2B         BNE Return039F8A          
CODE_039F5F:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_039F62:        A5 0F         LDA $0F                   
CODE_039F64:        18            CLC                       
CODE_039F65:        69 70         ADC.B #$70                
CODE_039F67:        C9 E0         CMP.B #$E0                
CODE_039F69:        B0 1F         BCS Return039F8A          
CODE_039F6B:        A9 E3         LDA.B #$E3                
CODE_039F6D:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_039F6F:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_039F72:        9D 1C 15      STA.W $151C,X             
CODE_039F75:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_039F77:        9D 28 15      STA.W $1528,X             
CODE_039F7A:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_039F7D:        9D 34 15      STA.W $1534,X             
CODE_039F80:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_039F82:        9D 94 15      STA.W $1594,X             
CODE_039F85:        20 C0 9F      JSR.W CODE_039FC0         
CODE_039F88:        F6 C2         INC RAM_SpriteState,X     
Return039F8A:       60            RTS                       ; Return 

CODE_039F8B:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_039F8D:        C9 10         CMP.B #$10                
CODE_039F8F:        30 0A         BMI CODE_039F9B           
CODE_039F91:        A9 50         LDA.B #$50                
CODE_039F93:        9D 40 15      STA.W $1540,X             
CODE_039F96:        F6 C2         INC RAM_SpriteState,X     
CODE_039F98:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
Return039F9A:       60            RTS                       ; Return 

CODE_039F9B:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_039F9F:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_039FA1:        F6 AA         INC RAM_SpriteSpeedY,X    
Return039FA3:       60            RTS                       ; Return 

CODE_039FA4:        BD 40 15      LDA.W $1540,X             
CODE_039FA7:        D0 08         BNE CODE_039FB1           
CODE_039FA9:        F6 C2         INC RAM_SpriteState,X     
CODE_039FAB:        A9 0A         LDA.B #$0A                
CODE_039FAD:        9D 40 15      STA.W $1540,X             
Return039FB0:       60            RTS                       ; Return 

CODE_039FB1:        C9 20         CMP.B #$20                
CODE_039FB3:        90 0B         BCC CODE_039FC0           
CODE_039FB5:        29 1F         AND.B #$1F                
CODE_039FB7:        D0 0E         BNE Return039FC7          
CODE_039FB9:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_039FBC:        49 01         EOR.B #$01                
CODE_039FBE:        80 04         BRA CODE_039FC4           

CODE_039FC0:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_039FC3:        98            TYA                       
CODE_039FC4:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return039FC7:       60            RTS                       ; Return 

CODE_039FC8:        BD 40 15      LDA.W $1540,X             
CODE_039FCB:        F0 09         BEQ CODE_039FD6           
CODE_039FCD:        A9 20         LDA.B #$20                
CODE_039FCF:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_039FD1:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
Return039FD5:       60            RTS                       ; Return 

CODE_039FD6:        A9 20         LDA.B #$20                
CODE_039FD8:        9D 40 15      STA.W $1540,X             
CODE_039FDB:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_039FDE:        B9 ED 9F      LDA.W DATA_039FED,Y       
CODE_039FE1:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_039FE3:        A9 E2         LDA.B #$E2                
CODE_039FE5:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_039FE7:        20 45 A0      JSR.W CODE_03A045         
CODE_039FEA:        F6 C2         INC RAM_SpriteState,X     
Return039FEC:       60            RTS                       ; Return 


DATA_039FED:                      .db $10,$F0

CODE_039FEF:        9E 02 16      STZ.W $1602,X             
CODE_039FF2:        BD 40 15      LDA.W $1540,X             
CODE_039FF5:        F0 0B         BEQ CODE_03A002           
CODE_039FF7:        3A            DEC A                     
CODE_039FF8:        D0 3E         BNE CODE_03A038           
CODE_039FFA:        A9 25         LDA.B #$25                ; \ Play sound effect 
CODE_039FFC:        8D F9 1D      STA.W $1DF9               ; / 
CODE_039FFF:        20 45 A0      JSR.W CODE_03A045         
CODE_03A002:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_03A006:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_03A00A:        A5 13         LDA RAM_FrameCounter      
CODE_03A00C:        29 00         AND.B #$00                
CODE_03A00E:        D0 02         BNE CODE_03A012           
CODE_03A010:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_03A012:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03A014:        C9 20         CMP.B #$20                
CODE_03A016:        30 20         BMI CODE_03A038           
CODE_03A018:        20 45 A0      JSR.W CODE_03A045         
CODE_03A01B:        74 C2         STZ RAM_SpriteState,X     
CODE_03A01D:        BD 1C 15      LDA.W $151C,X             
CODE_03A020:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_03A023:        BD 28 15      LDA.W $1528,X             
CODE_03A026:        95 E4         STA RAM_SpriteXLo,X       
CODE_03A028:        BD 34 15      LDA.W $1534,X             
CODE_03A02B:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_03A02E:        BD 94 15      LDA.W $1594,X             
CODE_03A031:        95 D8         STA RAM_SpriteYLo,X       
CODE_03A033:        A9 40         LDA.B #$40                
CODE_03A035:        9D 40 15      STA.W $1540,X             
CODE_03A038:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03A03A:        18            CLC                       
CODE_03A03B:        69 06         ADC.B #$06                
CODE_03A03D:        C9 0C         CMP.B #$0C                
CODE_03A03F:        B0 03         BCS Return03A044          
CODE_03A041:        FE 02 16      INC.W $1602,X             
Return03A044:       60            RTS                       ; Return 

CODE_03A045:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03A047:        48            PHA                       
CODE_03A048:        38            SEC                       
CODE_03A049:        E9 0C         SBC.B #$0C                
CODE_03A04B:        95 D8         STA RAM_SpriteYLo,X       
CODE_03A04D:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03A050:        48            PHA                       
CODE_03A051:        E9 00         SBC.B #$00                
CODE_03A053:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_03A056:        22 28 85 02   JSL.L CODE_028528         
CODE_03A05A:        68            PLA                       
CODE_03A05B:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_03A05E:        68            PLA                       
CODE_03A05F:        95 D8         STA RAM_SpriteYLo,X       
Return03A061:       60            RTS                       ; Return 

CODE_03A062:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_03A065:        B5 C2         LDA RAM_SpriteState,X     
CODE_03A067:        F0 CF         BEQ CODE_03A038           
CODE_03A069:        C9 04         CMP.B #$04                
CODE_03A06B:        F0 30         BEQ CODE_03A09D           
CODE_03A06D:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_03A071:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_03A074:        A9 A0         LDA.B #$A0                
CODE_03A076:        99 02 03      STA.W OAM_Tile,Y          
CODE_03A079:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_03A07C:        29 CF         AND.B #$CF                
CODE_03A07E:        99 03 03      STA.W OAM_Prop,Y          
Return03A081:       60            RTS                       ; Return 


DATA_03A082:                      .db $F8,$08,$F8,$08,$18,$08,$F8,$08
                                  .db $F8,$E8

DATA_03A08C:                      .db $F8,$F8,$08,$08,$08

BlarggTilemap:                    .db $A2,$A4,$C2,$C4,$A6,$A2,$A4,$E6
                                  .db $C8,$A6

DATA_03A09B:                      .db $45,$05

CODE_03A09D:        BD 02 16      LDA.W $1602,X             
CODE_03A0A0:        0A            ASL                       
CODE_03A0A1:        0A            ASL                       
CODE_03A0A2:        7D 02 16      ADC.W $1602,X             
CODE_03A0A5:        85 03         STA $03                   
CODE_03A0A7:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_03A0AA:        85 02         STA $02                   
CODE_03A0AC:        DA            PHX                       
CODE_03A0AD:        A2 04         LDX.B #$04                
CODE_03A0AF:        DA            PHX                       
CODE_03A0B0:        DA            PHX                       
CODE_03A0B1:        A5 01         LDA $01                   
CODE_03A0B3:        18            CLC                       
CODE_03A0B4:        7D 8C A0      ADC.W DATA_03A08C,X       
CODE_03A0B7:        99 01 03      STA.W OAM_DispY,Y         
CODE_03A0BA:        A5 02         LDA $02                   
CODE_03A0BC:        D0 05         BNE CODE_03A0C3           
CODE_03A0BE:        8A            TXA                       
CODE_03A0BF:        18            CLC                       
CODE_03A0C0:        69 05         ADC.B #$05                
CODE_03A0C2:        AA            TAX                       
CODE_03A0C3:        A5 00         LDA $00                   
CODE_03A0C5:        18            CLC                       
CODE_03A0C6:        7D 82 A0      ADC.W DATA_03A082,X       
CODE_03A0C9:        99 00 03      STA.W OAM_DispX,Y         
CODE_03A0CC:        68            PLA                       
CODE_03A0CD:        18            CLC                       
CODE_03A0CE:        65 03         ADC $03                   
CODE_03A0D0:        AA            TAX                       
CODE_03A0D1:        BD 91 A0      LDA.W BlarggTilemap,X     
CODE_03A0D4:        99 02 03      STA.W OAM_Tile,Y          
CODE_03A0D7:        A6 02         LDX $02                   
CODE_03A0D9:        BD 9B A0      LDA.W DATA_03A09B,X       
CODE_03A0DC:        99 03 03      STA.W OAM_Prop,Y          
CODE_03A0DF:        FA            PLX                       
CODE_03A0E0:        C8            INY                       
CODE_03A0E1:        C8            INY                       
CODE_03A0E2:        C8            INY                       
CODE_03A0E3:        C8            INY                       
CODE_03A0E4:        CA            DEX                       
CODE_03A0E5:        10 C8         BPL CODE_03A0AF           
CODE_03A0E7:        FA            PLX                       
CODE_03A0E8:        A0 02         LDY.B #$02                
CODE_03A0EA:        A9 04         LDA.B #$04                
CODE_03A0EC:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return03A0F0:       60            RTS                       ; Return 

CODE_03A0F1:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_03A0F5:        9E A0 15      STZ.W RAM_OffscreenHorz,X 
CODE_03A0F8:        A9 80         LDA.B #$80                
CODE_03A0FA:        95 D8         STA RAM_SpriteYLo,X       
CODE_03A0FC:        A9 FF         LDA.B #$FF                
CODE_03A0FE:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_03A101:        A9 D0         LDA.B #$D0                
CODE_03A103:        95 E4         STA RAM_SpriteXLo,X       
CODE_03A105:        A9 00         LDA.B #$00                
CODE_03A107:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_03A10A:        A9 02         LDA.B #$02                
CODE_03A10C:        9D 7B 18      STA.W $187B,X             
CODE_03A10F:        A9 03         LDA.B #$03                
CODE_03A111:        95 C2         STA RAM_SpriteState,X     
CODE_03A113:        22 7D DD 03   JSL.L CODE_03DD7D         
Return03A117:       6B            RTL                       ; Return 

Bnk3CallSprMain:    8B            PHB                       
CODE_03A119:        4B            PHK                       
CODE_03A11A:        AB            PLB                       
CODE_03A11B:        B5 9E         LDA RAM_SpriteNum,X       
CODE_03A11D:        C9 C8         CMP.B #$C8                
CODE_03A11F:        D0 05         BNE CODE_03A126           
CODE_03A121:        20 F5 C1      JSR.W LightSwitch         
CODE_03A124:        AB            PLB                       
Return03A125:       6B            RTL                       ; Return 

CODE_03A126:        C9 C7         CMP.B #$C7                
CODE_03A128:        D0 05         BNE CODE_03A12F           
CODE_03A12A:        20 0F C3      JSR.W InvisMushroom       
CODE_03A12D:        AB            PLB                       
Return03A12E:       6B            RTL                       ; Return 

CODE_03A12F:        C9 51         CMP.B #$51                
CODE_03A131:        D0 05         BNE CODE_03A138           
CODE_03A133:        20 4C C3      JSR.W Ninji               
CODE_03A136:        AB            PLB                       
Return03A137:       6B            RTL                       ; Return 

CODE_03A138:        C9 1B         CMP.B #$1B                
CODE_03A13A:        D0 05         BNE CODE_03A141           
CODE_03A13C:        20 12 80      JSR.W Football            
CODE_03A13F:        AB            PLB                       
Return03A140:       6B            RTL                       ; Return 

CODE_03A141:        C9 C6         CMP.B #$C6                
CODE_03A143:        D0 05         BNE CODE_03A14A           
CODE_03A145:        20 DC C4      JSR.W DarkRoomWithLight   
CODE_03A148:        AB            PLB                       
Return03A149:       6B            RTL                       ; Return 

CODE_03A14A:        C9 7A         CMP.B #$7A                
CODE_03A14C:        D0 05         BNE CODE_03A153           
CODE_03A14E:        20 16 C8      JSR.W Firework            
CODE_03A151:        AB            PLB                       
Return03A152:       6B            RTL                       ; Return 

CODE_03A153:        C9 7C         CMP.B #$7C                
CODE_03A155:        D0 05         BNE CODE_03A15C           
CODE_03A157:        20 97 AC      JSR.W PrincessPeach       
CODE_03A15A:        AB            PLB                       
Return03A15B:       6B            RTL                       ; Return 

CODE_03A15C:        C9 C5         CMP.B #$C5                
CODE_03A15E:        D0 05         BNE CODE_03A165           
CODE_03A160:        20 87 80      JSR.W BigBooBoss          
CODE_03A163:        AB            PLB                       
Return03A164:       6B            RTL                       ; Return 

CODE_03A165:        C9 C4         CMP.B #$C4                
CODE_03A167:        D0 05         BNE CODE_03A16E           
CODE_03A169:        20 54 84      JSR.W GreyFallingPlat     
CODE_03A16C:        AB            PLB                       
Return03A16D:       6B            RTL                       ; Return 

CODE_03A16E:        C9 C2         CMP.B #$C2                
CODE_03A170:        D0 05         BNE CODE_03A177           
CODE_03A172:        20 CA 84      JSR.W Blurp               
CODE_03A175:        AB            PLB                       
Return03A176:       6B            RTL                       ; Return 

CODE_03A177:        C9 C3         CMP.B #$C3                
CODE_03A179:        D0 05         BNE CODE_03A180           
CODE_03A17B:        20 2F 85      JSR.W PorcuPuffer         
CODE_03A17E:        AB            PLB                       
Return03A17F:       6B            RTL                       ; Return 

CODE_03A180:        C9 C1         CMP.B #$C1                
CODE_03A182:        D0 05         BNE CODE_03A189           
CODE_03A184:        20 F6 85      JSR.W FlyingTurnBlocks    
CODE_03A187:        AB            PLB                       
Return03A188:       6B            RTL                       ; Return 

CODE_03A189:        C9 C0         CMP.B #$C0                
CODE_03A18B:        D0 05         BNE CODE_03A192           
CODE_03A18D:        20 FF 86      JSR.W GrayLavaPlatform    
CODE_03A190:        AB            PLB                       
Return03A191:       6B            RTL                       ; Return 

CODE_03A192:        C9 BF         CMP.B #$BF                
CODE_03A194:        D0 05         BNE CODE_03A19B           
CODE_03A196:        20 70 87      JSR.W MegaMole            
CODE_03A199:        AB            PLB                       
Return03A19A:       6B            RTL                       ; Return 

CODE_03A19B:        C9 BE         CMP.B #$BE                
CODE_03A19D:        D0 05         BNE CODE_03A1A4           
CODE_03A19F:        20 A3 88      JSR.W Swooper             
CODE_03A1A2:        AB            PLB                       
Return03A1A3:       6B            RTL                       ; Return 

CODE_03A1A4:        C9 BD         CMP.B #$BD                
CODE_03A1A6:        D0 05         BNE CODE_03A1AD           
CODE_03A1A8:        20 58 89      JSR.W SlidingKoopa        
CODE_03A1AB:        AB            PLB                       
Return03A1AC:       6B            RTL                       ; Return 

CODE_03A1AD:        C9 BC         CMP.B #$BC                
CODE_03A1AF:        D0 05         BNE CODE_03A1B6           
CODE_03A1B1:        20 3C 8A      JSR.W BowserStatue        
CODE_03A1B4:        AB            PLB                       
Return03A1B5:       6B            RTL                       ; Return 

CODE_03A1B6:        C9 B8         CMP.B #$B8                
CODE_03A1B8:        F0 04         BEQ CODE_03A1BE           
CODE_03A1BA:        C9 B7         CMP.B #$B7                
CODE_03A1BC:        D0 05         BNE CODE_03A1C3           
CODE_03A1BE:        20 2F 8C      JSR.W CarrotTopLift       
CODE_03A1C1:        AB            PLB                       
Return03A1C2:       6B            RTL                       ; Return 

CODE_03A1C3:        C9 B9         CMP.B #$B9                
CODE_03A1C5:        D0 05         BNE CODE_03A1CC           
CODE_03A1C7:        20 6F 8D      JSR.W InfoBox             
CODE_03A1CA:        AB            PLB                       
Return03A1CB:       6B            RTL                       ; Return 

CODE_03A1CC:        C9 BA         CMP.B #$BA                
CODE_03A1CE:        D0 05         BNE CODE_03A1D5           
CODE_03A1D0:        20 BB 8D      JSR.W TimedLift           
CODE_03A1D3:        AB            PLB                       
Return03A1D4:       6B            RTL                       ; Return 

CODE_03A1D5:        C9 BB         CMP.B #$BB                
CODE_03A1D7:        D0 05         BNE CODE_03A1DE           
CODE_03A1D9:        20 79 8E      JSR.W GreyCastleBlock     
CODE_03A1DC:        AB            PLB                       
Return03A1DD:       6B            RTL                       ; Return 

CODE_03A1DE:        C9 B3         CMP.B #$B3                
CODE_03A1E0:        D0 05         BNE CODE_03A1E7           
CODE_03A1E2:        20 EC 8E      JSR.W StatueFireball      
CODE_03A1E5:        AB            PLB                       
Return03A1E6:       6B            RTL                       ; Return 

CODE_03A1E7:        B5 9E         LDA RAM_SpriteNum,X       
CODE_03A1E9:        C9 B2         CMP.B #$B2                
CODE_03A1EB:        D0 05         BNE CODE_03A1F2           
CODE_03A1ED:        20 14 92      JSR.W FallingSpike        
CODE_03A1F0:        AB            PLB                       
Return03A1F1:       6B            RTL                       ; Return 

CODE_03A1F2:        C9 AE         CMP.B #$AE                
CODE_03A1F4:        D0 05         BNE CODE_03A1FB           
CODE_03A1F6:        20 65 90      JSR.W FishinBoo           
CODE_03A1F9:        AB            PLB                       
Return03A1FA:       6B            RTL                       ; Return 

CODE_03A1FB:        C9 B6         CMP.B #$B6                
CODE_03A1FD:        D0 05         BNE CODE_03A204           
CODE_03A1FF:        20 75 8F      JSR.W ReflectingFireball  
CODE_03A202:        AB            PLB                       
Return03A203:       6B            RTL                       ; Return 

CODE_03A204:        C9 B0         CMP.B #$B0                
CODE_03A206:        D0 05         BNE CODE_03A20D           
CODE_03A208:        20 7A 8F      JSR.W BooStream           
CODE_03A20B:        AB            PLB                       
Return03A20C:       6B            RTL                       ; Return 

CODE_03A20D:        C9 B1         CMP.B #$B1                
CODE_03A20F:        D0 05         BNE CODE_03A216           
CODE_03A211:        20 84 92      JSR.W CreateEatBlock      
CODE_03A214:        AB            PLB                       
Return03A215:       6B            RTL                       ; Return 

CODE_03A216:        C9 AC         CMP.B #$AC                
CODE_03A218:        F0 04         BEQ CODE_03A21E           
CODE_03A21A:        C9 AD         CMP.B #$AD                
CODE_03A21C:        D0 05         BNE CODE_03A223           
CODE_03A21E:        20 23 94      JSR.W WoodenSpike         
CODE_03A221:        AB            PLB                       
Return03A222:       6B            RTL                       ; Return 

CODE_03A223:        C9 AB         CMP.B #$AB                
CODE_03A225:        D0 05         BNE CODE_03A22C           
CODE_03A227:        20 17 95      JSR.W RexMainRt           
CODE_03A22A:        AB            PLB                       
Return03A22B:       6B            RTL                       ; Return 

CODE_03A22C:        C9 AA         CMP.B #$AA                
CODE_03A22E:        D0 05         BNE CODE_03A235           
CODE_03A230:        20 F6 96      JSR.W Fishbone            
CODE_03A233:        AB            PLB                       
Return03A234:       6B            RTL                       ; Return 

CODE_03A235:        C9 A9         CMP.B #$A9                
CODE_03A237:        D0 05         BNE CODE_03A23E           
CODE_03A239:        20 90 98      JSR.W Reznor              
CODE_03A23C:        AB            PLB                       
Return03A23D:       6B            RTL                       ; Return 

CODE_03A23E:        C9 A8         CMP.B #$A8                
CODE_03A240:        D0 05         BNE CODE_03A247           
CODE_03A242:        20 38 9F      JSR.W Blargg              
CODE_03A245:        AB            PLB                       
Return03A246:       6B            RTL                       ; Return 

CODE_03A247:        C9 A1         CMP.B #$A1                
CODE_03A249:        D0 05         BNE CODE_03A250           
CODE_03A24B:        20 63 B1      JSR.W BowserBowlingBall   
CODE_03A24E:        AB            PLB                       
Return03A24F:       6B            RTL                       ; Return 

CODE_03A250:        C9 A2         CMP.B #$A2                
CODE_03A252:        D0 05         BNE BowserFight           
CODE_03A254:        20 A9 B2      JSR.W MechaKoopa          
CODE_03A257:        AB            PLB                       
Return03A258:       6B            RTL                       ; Return 

BowserFight:        22 CC DF 03   JSL.L CODE_03DFCC         
CODE_03A25D:        20 79 A2      JSR.W CODE_03A279         
CODE_03A260:        20 3C B4      JSR.W CODE_03B43C         
CODE_03A263:        AB            PLB                       
Return03A264:       6B            RTL                       ; Return 


DATA_03A265:                      .db $04,$03,$02,$01,$00,$01,$02,$03
                                  .db $04,$05,$06,$07,$07,$07,$07,$07
                                  .db $07,$07,$07,$07

CODE_03A279:        A5 38         LDA $38                   
CODE_03A27B:        4A            LSR                       
CODE_03A27C:        4A            LSR                       
CODE_03A27D:        4A            LSR                       
CODE_03A27E:        A8            TAY                       
CODE_03A27F:        B9 65 A2      LDA.W DATA_03A265,Y       
CODE_03A282:        8D 29 14      STA.W $1429               
CODE_03A285:        BD 70 15      LDA.W $1570,X             
CODE_03A288:        18            CLC                       
CODE_03A289:        69 1E         ADC.B #$1E                
CODE_03A28B:        1D 7C 15      ORA.W RAM_SpriteDir,X     
CODE_03A28E:        8D A2 1B      STA.W $1BA2               
CODE_03A291:        A5 14         LDA RAM_FrameCounterB     
CODE_03A293:        4A            LSR                       
CODE_03A294:        29 03         AND.B #$03                
CODE_03A296:        8D 28 14      STA.W $1428               
CODE_03A299:        A9 90         LDA.B #$90                
CODE_03A29B:        85 2A         STA $2A                   
CODE_03A29D:        A9 C8         LDA.B #$C8                
CODE_03A29F:        85 2C         STA $2C                   
CODE_03A2A1:        22 DF DE 03   JSL.L CODE_03DEDF         
CODE_03A2A5:        AD B5 14      LDA.W $14B5               
CODE_03A2A8:        F0 03         BEQ CODE_03A2AD           
CODE_03A2AA:        20 59 AF      JSR.W CODE_03AF59         
CODE_03A2AD:        BD 64 15      LDA.W $1564,X             
CODE_03A2B0:        F0 03         BEQ CODE_03A2B5           
CODE_03A2B2:        20 E2 A3      JSR.W CODE_03A3E2         
CODE_03A2B5:        BD 94 15      LDA.W $1594,X             
CODE_03A2B8:        F0 14         BEQ CODE_03A2CE           
CODE_03A2BA:        3A            DEC A                     
CODE_03A2BB:        4A            LSR                       
CODE_03A2BC:        4A            LSR                       
CODE_03A2BD:        48            PHA                       
CODE_03A2BE:        4A            LSR                       
CODE_03A2BF:        A8            TAY                       
CODE_03A2C0:        B9 BE A8      LDA.W DATA_03A8BE,Y       
CODE_03A2C3:        85 02         STA $02                   
CODE_03A2C5:        68            PLA                       
CODE_03A2C6:        29 03         AND.B #$03                
CODE_03A2C8:        85 03         STA $03                   
CODE_03A2CA:        20 6E AA      JSR.W CODE_03AA6E         
CODE_03A2CD:        EA            NOP                       
CODE_03A2CE:        A5 9D         LDA RAM_SpritesLocked     
CODE_03A2D0:        D0 6E         BNE Return03A340          
CODE_03A2D2:        9E 94 15      STZ.W $1594,X             
CODE_03A2D5:        A9 30         LDA.B #$30                
CODE_03A2D7:        85 64         STA $64                   
CODE_03A2D9:        A5 38         LDA $38                   
CODE_03A2DB:        C9 20         CMP.B #$20                
CODE_03A2DD:        B0 02         BCS CODE_03A2E1           
CODE_03A2DF:        64 64         STZ $64                   
CODE_03A2E1:        20 61 A6      JSR.W CODE_03A661         
CODE_03A2E4:        AD B0 14      LDA.W $14B0               
CODE_03A2E7:        F0 09         BEQ CODE_03A2F2           
CODE_03A2E9:        A5 13         LDA RAM_FrameCounter      
CODE_03A2EB:        29 03         AND.B #$03                
CODE_03A2ED:        D0 03         BNE CODE_03A2F2           
CODE_03A2EF:        CE B0 14      DEC.W $14B0               
CODE_03A2F2:        A5 13         LDA RAM_FrameCounter      
CODE_03A2F4:        29 7F         AND.B #$7F                
CODE_03A2F6:        D0 0D         BNE CODE_03A305           
CODE_03A2F8:        22 F9 AC 01   JSL.L GetRand             
CODE_03A2FC:        29 01         AND.B #$01                
CODE_03A2FE:        D0 05         BNE CODE_03A305           
CODE_03A300:        A9 0C         LDA.B #$0C                
CODE_03A302:        9D 58 15      STA.W $1558,X             
CODE_03A305:        20 78 B0      JSR.W CODE_03B078         
CODE_03A308:        BD 1C 15      LDA.W $151C,X             
CODE_03A30B:        C9 09         CMP.B #$09                
CODE_03A30D:        F0 0B         BEQ CODE_03A31A           
CODE_03A30F:        9C 27 14      STZ.W $1427               
CODE_03A312:        BD 58 15      LDA.W $1558,X             
CODE_03A315:        F0 03         BEQ CODE_03A31A           
CODE_03A317:        EE 27 14      INC.W $1427               
CODE_03A31A:        20 AD A5      JSR.W CODE_03A5AD         
CODE_03A31D:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_03A321:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_03A325:        BD 1C 15      LDA.W $151C,X             
CODE_03A328:        22 DF 86 00   JSL.L ExecutePtr          

BowserFightPtrs:       41 A4      .dw CODE_03A441           
                       F8 A6      .dw CODE_03A6F8           
                       4B A8      .dw CODE_03A84B           
                       AD A7      .dw CODE_03A7AD           
                       9F AB      .dw CODE_03AB9F           
                       BE AB      .dw CODE_03ABBE           
                       03 AC      .dw CODE_03AC03           
                       9C A4      .dw CODE_03A49C           
                       21 AB      .dw CODE_03AB21           
                       64 AB      .dw CODE_03AB64           

Return03A340:       60            RTS                       ; Return 


DATA_03A341:                      .db $D5,$DD,$23,$2B,$D5,$DD,$23,$2B
                                  .db $D5,$DD,$23,$2B,$D5,$DD,$23,$2B
                                  .db $D6,$DE,$22,$2A,$D6,$DE,$22,$2A
                                  .db $D7,$DF,$21,$29,$D7,$DF,$21,$29
                                  .db $D8,$E0,$20,$28,$D8,$E0,$20,$28
                                  .db $DA,$E2,$1E,$26,$DA,$E2,$1E,$26
                                  .db $DC,$E4,$1C,$24,$DC,$E4,$1C,$24
                                  .db $E0,$E8,$18,$20,$E0,$E8,$18,$20
                                  .db $E8,$F0,$10,$18,$E8,$F0,$10,$18
DATA_03A389:                      .db $DD,$D5,$D5,$DD,$23,$2B,$2B,$23
                                  .db $DD,$D5,$D5,$DD,$23,$2B,$2B,$23
                                  .db $DE,$D6,$D6,$DE,$22,$2A,$2A,$22
                                  .db $DF,$D7,$D7,$DF,$21,$29,$29,$21
                                  .db $E0,$D8,$D8,$E0,$20,$28,$28,$20
                                  .db $E2,$DA,$DA,$E2,$1E,$26,$26,$1E
                                  .db $E4,$DC,$DC,$E4,$1C,$24,$24,$1C
                                  .db $E8,$E0,$E0,$E8,$18,$20,$20,$18
                                  .db $F0,$E8,$E8,$F0,$10,$18,$18,$10
DATA_03A3D1:                      .db $80,$40,$00,$C0,$00,$C0,$80,$40
DATA_03A3D9:                      .db $E3,$ED,$ED,$EB,$EB,$E9,$E9,$E7
                                  .db $E7

CODE_03A3E2:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_03A3E5:        BD 64 15      LDA.W $1564,X             
CODE_03A3E8:        3A            DEC A                     
CODE_03A3E9:        4A            LSR                       
CODE_03A3EA:        85 03         STA $03                   
CODE_03A3EC:        0A            ASL                       
CODE_03A3ED:        0A            ASL                       
CODE_03A3EE:        0A            ASL                       
CODE_03A3EF:        85 02         STA $02                   
CODE_03A3F1:        A9 70         LDA.B #$70                
CODE_03A3F3:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_03A3F6:        A8            TAY                       
CODE_03A3F7:        DA            PHX                       
CODE_03A3F8:        A2 07         LDX.B #$07                
CODE_03A3FA:        DA            PHX                       
CODE_03A3FB:        8A            TXA                       
CODE_03A3FC:        05 02         ORA $02                   
CODE_03A3FE:        AA            TAX                       
CODE_03A3FF:        A5 00         LDA $00                   
CODE_03A401:        18            CLC                       
CODE_03A402:        7D 41 A3      ADC.W DATA_03A341,X       
CODE_03A405:        18            CLC                       
CODE_03A406:        69 08         ADC.B #$08                
CODE_03A408:        99 00 03      STA.W OAM_DispX,Y         
CODE_03A40B:        A5 01         LDA $01                   
CODE_03A40D:        18            CLC                       
CODE_03A40E:        7D 89 A3      ADC.W DATA_03A389,X       
CODE_03A411:        18            CLC                       
CODE_03A412:        69 30         ADC.B #$30                
CODE_03A414:        99 01 03      STA.W OAM_DispY,Y         
CODE_03A417:        A6 03         LDX $03                   
CODE_03A419:        BD D9 A3      LDA.W DATA_03A3D9,X       
CODE_03A41C:        99 02 03      STA.W OAM_Tile,Y          
CODE_03A41F:        FA            PLX                       
CODE_03A420:        BD D1 A3      LDA.W DATA_03A3D1,X       
CODE_03A423:        99 03 03      STA.W OAM_Prop,Y          
CODE_03A426:        C8            INY                       
CODE_03A427:        C8            INY                       
CODE_03A428:        C8            INY                       
CODE_03A429:        C8            INY                       
CODE_03A42A:        CA            DEX                       
CODE_03A42B:        10 CD         BPL CODE_03A3FA           
CODE_03A42D:        FA            PLX                       
CODE_03A42E:        A0 02         LDY.B #$02                
CODE_03A430:        A9 07         LDA.B #$07                
CODE_03A432:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return03A436:       60            RTS                       ; Return 


DATA_03A437:                      .db $00,$00,$00,$00,$02,$04,$06,$08
                                  .db $0A,$0E

CODE_03A441:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_03A444:        D0 3C         BNE CODE_03A482           
CODE_03A446:        BD 40 15      LDA.W $1540,X             
CODE_03A449:        D0 1A         BNE CODE_03A465           
CODE_03A44B:        A9 0E         LDA.B #$0E                
CODE_03A44D:        9D 70 15      STA.W $1570,X             
CODE_03A450:        A9 04         LDA.B #$04                
CODE_03A452:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03A454:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_03A456:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03A458:        38            SEC                       
CODE_03A459:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_03A45B:        C9 10         CMP.B #$10                
CODE_03A45D:        D0 05         BNE Return03A464          
CODE_03A45F:        A9 A4         LDA.B #$A4                
CODE_03A461:        9D 40 15      STA.W $1540,X             
Return03A464:       60            RTS                       ; Return 

CODE_03A465:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03A467:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_03A469:        C9 01         CMP.B #$01                
CODE_03A46B:        F0 0F         BEQ CODE_03A47C           
CODE_03A46D:        C9 40         CMP.B #$40                
CODE_03A46F:        B0 0A         BCS Return03A47B          
CODE_03A471:        4A            LSR                       
CODE_03A472:        4A            LSR                       
CODE_03A473:        4A            LSR                       
CODE_03A474:        A8            TAY                       
CODE_03A475:        B9 37 A4      LDA.W DATA_03A437,Y       
CODE_03A478:        9D 70 15      STA.W $1570,X             
Return03A47B:       60            RTS                       ; Return 

CODE_03A47C:        A9 24         LDA.B #$24                
CODE_03A47E:        9D 4C 15      STA.W RAM_DisableInter,X  
Return03A481:       60            RTS                       ; Return 

CODE_03A482:        3A            DEC A                     
CODE_03A483:        D0 0A         BNE Return03A48F          
CODE_03A485:        A9 07         LDA.B #$07                
CODE_03A487:        9D 1C 15      STA.W $151C,X             
CODE_03A48A:        A9 78         LDA.B #$78                
CODE_03A48C:        8D B0 14      STA.W $14B0               
Return03A48F:       60            RTS                       ; Return 


DATA_03A490:                      .db $FF,$01

DATA_03A492:                      .db $C8,$38

DATA_03A494:                      .db $01,$FF

DATA_03A496:                      .db $1C,$E4

DATA_03A498:                      .db $00,$02,$04,$02

CODE_03A49C:        20 D2 A4      JSR.W CODE_03A4D2         
CODE_03A49F:        20 FD A4      JSR.W CODE_03A4FD         
CODE_03A4A2:        20 ED A4      JSR.W CODE_03A4ED         
CODE_03A4A5:        BD 28 15      LDA.W $1528,X             
CODE_03A4A8:        29 01         AND.B #$01                
CODE_03A4AA:        A8            TAY                       
CODE_03A4AB:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_03A4AD:        18            CLC                       
CODE_03A4AE:        79 90 A4      ADC.W DATA_03A490,Y       
CODE_03A4B1:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03A4B3:        D9 92 A4      CMP.W DATA_03A492,Y       
CODE_03A4B6:        D0 03         BNE CODE_03A4BB           
CODE_03A4B8:        FE 28 15      INC.W $1528,X             
CODE_03A4BB:        BD 34 15      LDA.W $1534,X             
CODE_03A4BE:        29 01         AND.B #$01                
CODE_03A4C0:        A8            TAY                       
CODE_03A4C1:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03A4C3:        18            CLC                       
CODE_03A4C4:        79 94 A4      ADC.W DATA_03A494,Y       
CODE_03A4C7:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03A4C9:        D9 96 A4      CMP.W DATA_03A496,Y       
CODE_03A4CC:        D0 03         BNE Return03A4D1          
CODE_03A4CE:        FE 34 15      INC.W $1534,X             
Return03A4D1:       60            RTS                       ; Return 

CODE_03A4D2:        A0 00         LDY.B #$00                
CODE_03A4D4:        A5 13         LDA RAM_FrameCounter      
CODE_03A4D6:        29 E0         AND.B #$E0                
CODE_03A4D8:        D0 0C         BNE CODE_03A4E6           
CODE_03A4DA:        A5 13         LDA RAM_FrameCounter      
CODE_03A4DC:        29 18         AND.B #$18                
CODE_03A4DE:        4A            LSR                       
CODE_03A4DF:        4A            LSR                       
CODE_03A4E0:        4A            LSR                       
CODE_03A4E1:        A8            TAY                       
CODE_03A4E2:        B9 98 A4      LDA.W DATA_03A498,Y       
CODE_03A4E5:        A8            TAY                       
CODE_03A4E6:        98            TYA                       
CODE_03A4E7:        9D 70 15      STA.W $1570,X             
Return03A4EA:       60            RTS                       ; Return 


DATA_03A4EB:                      .db $80,$00

CODE_03A4ED:        A5 13         LDA RAM_FrameCounter      
CODE_03A4EF:        29 1F         AND.B #$1F                
CODE_03A4F1:        D0 09         BNE Return03A4FC          
CODE_03A4F3:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_03A4F6:        B9 EB A4      LDA.W DATA_03A4EB,Y       
CODE_03A4F9:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return03A4FC:       60            RTS                       ; Return 

CODE_03A4FD:        AD B0 14      LDA.W $14B0               
CODE_03A500:        D0 2A         BNE Return03A52C          
CODE_03A502:        BD 1C 15      LDA.W $151C,X             
CODE_03A505:        C9 08         CMP.B #$08                
CODE_03A507:        D0 11         BNE CODE_03A51A           
CODE_03A509:        EE B8 14      INC.W $14B8               
CODE_03A50C:        AD B8 14      LDA.W $14B8               
CODE_03A50F:        C9 03         CMP.B #$03                
CODE_03A511:        F0 07         BEQ CODE_03A51A           
CODE_03A513:        A9 FF         LDA.B #$FF                
CODE_03A515:        8D B6 14      STA.W $14B6               
CODE_03A518:        80 12         BRA Return03A52C          

CODE_03A51A:        9C B8 14      STZ.W $14B8               
CODE_03A51D:        AD C8 14      LDA.W $14C8               
CODE_03A520:        F0 05         BEQ CODE_03A527           
CODE_03A522:        AD C9 14      LDA.W $14C9               
CODE_03A525:        D0 05         BNE Return03A52C          
CODE_03A527:        A9 FF         LDA.B #$FF                
CODE_03A529:        8D B1 14      STA.W $14B1               
Return03A52C:       60            RTS                       ; Return 


DATA_03A52D:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$02,$04,$06,$08,$0A,$0E,$0E
                                  .db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
                                  .db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
                                  .db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
                                  .db $0E,$0E,$0A,$08,$06,$04,$02,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
DATA_03A56D:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$10,$20,$30,$40,$50,$60
                                  .db $80,$A0,$C0,$E0,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$C0,$80,$60
                                  .db $40,$30,$20,$10,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00

CODE_03A5AD:        AD B1 14      LDA.W $14B1               
CODE_03A5B0:        F0 26         BEQ CODE_03A5D8           
CODE_03A5B2:        CE B1 14      DEC.W $14B1               
CODE_03A5B5:        D0 06         BNE CODE_03A5BD           
CODE_03A5B7:        A9 54         LDA.B #$54                
CODE_03A5B9:        8D B0 14      STA.W $14B0               
Return03A5BC:       60            RTS                       ; Return 

CODE_03A5BD:        4A            LSR                       
CODE_03A5BE:        4A            LSR                       
CODE_03A5BF:        A8            TAY                       
CODE_03A5C0:        B9 2D A5      LDA.W DATA_03A52D,Y       
CODE_03A5C3:        9D 70 15      STA.W $1570,X             
CODE_03A5C6:        AD B1 14      LDA.W $14B1               
CODE_03A5C9:        C9 80         CMP.B #$80                
CODE_03A5CB:        D0 08         BNE CODE_03A5D5           
CODE_03A5CD:        20 19 B0      JSR.W CODE_03B019         
CODE_03A5D0:        A9 08         LDA.B #$08                ; \ Play sound effect 
CODE_03A5D2:        8D FC 1D      STA.W $1DFC               ; / 
CODE_03A5D5:        68            PLA                       
CODE_03A5D6:        68            PLA                       
Return03A5D7:       60            RTS                       ; Return 

CODE_03A5D8:        AD B6 14      LDA.W $14B6               
CODE_03A5DB:        F0 30         BEQ Return03A60D          
CODE_03A5DD:        CE B6 14      DEC.W $14B6               
CODE_03A5E0:        F0 2C         BEQ CODE_03A60E           
CODE_03A5E2:        4A            LSR                       
CODE_03A5E3:        4A            LSR                       
CODE_03A5E4:        A8            TAY                       
CODE_03A5E5:        B9 2D A5      LDA.W DATA_03A52D,Y       
CODE_03A5E8:        9D 70 15      STA.W $1570,X             
CODE_03A5EB:        B9 6D A5      LDA.W DATA_03A56D,Y       
CODE_03A5EE:        85 36         STA $36                   
CODE_03A5F0:        64 37         STZ $37                   
CODE_03A5F2:        C9 FF         CMP.B #$FF                
CODE_03A5F4:        D0 06         BNE CODE_03A5FC           
CODE_03A5F6:        64 36         STZ $36                   
CODE_03A5F8:        E6 37         INC $37                   
CODE_03A5FA:        64 64         STZ $64                   
CODE_03A5FC:        AD B6 14      LDA.W $14B6               
CODE_03A5FF:        C9 80         CMP.B #$80                
CODE_03A601:        D0 08         BNE CODE_03A60B           
CODE_03A603:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_03A605:        8D FC 1D      STA.W $1DFC               ; / 
CODE_03A608:        20 1D A6      JSR.W CODE_03A61D         
CODE_03A60B:        68            PLA                       
CODE_03A60C:        68            PLA                       
Return03A60D:       60            RTS                       ; Return 

CODE_03A60E:        A9 60         LDA.B #$60                
CODE_03A610:        AC B8 14      LDY.W $14B8               
CODE_03A613:        C0 02         CPY.B #$02                
CODE_03A615:        F0 02         BEQ CODE_03A619           
CODE_03A617:        A9 20         LDA.B #$20                
CODE_03A619:        8D B0 14      STA.W $14B0               
Return03A61C:       60            RTS                       ; Return 

CODE_03A61D:        A9 08         LDA.B #$08                
CODE_03A61F:        8D D0 14      STA.W $14D0               
CODE_03A622:        A9 A1         LDA.B #$A1                
CODE_03A624:        85 A6         STA $A6                   
CODE_03A626:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03A628:        18            CLC                       
CODE_03A629:        69 08         ADC.B #$08                
CODE_03A62B:        85 EC         STA $EC                   
CODE_03A62D:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03A630:        69 00         ADC.B #$00                
CODE_03A632:        8D E8 14      STA.W $14E8               
CODE_03A635:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03A637:        18            CLC                       
CODE_03A638:        69 40         ADC.B #$40                
CODE_03A63A:        85 E0         STA $E0                   
CODE_03A63C:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03A63F:        69 00         ADC.B #$00                
CODE_03A641:        8D DC 14      STA.W $14DC               
CODE_03A644:        DA            PHX                       
CODE_03A645:        A2 08         LDX.B #$08                
CODE_03A647:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_03A64B:        FA            PLX                       
Return03A64C:       60            RTS                       ; Return 


DATA_03A64D:                      .db $00,$00,$00,$00,$FC,$F8,$F4,$F0
                                  .db $F4,$F8,$FC,$00,$04,$08,$0C,$10
                                  .db $0C,$08,$04,$00

CODE_03A661:        AD B5 14      LDA.W $14B5               
CODE_03A664:        F0 59         BEQ Return03A6BF          
CODE_03A666:        9C B1 14      STZ.W $14B1               
CODE_03A669:        9C B6 14      STZ.W $14B6               
CODE_03A66C:        CE B5 14      DEC.W $14B5               
CODE_03A66F:        D0 20         BNE CODE_03A691           
CODE_03A671:        A9 50         LDA.B #$50                
CODE_03A673:        8D B0 14      STA.W $14B0               
CODE_03A676:        DE 7B 18      DEC.W $187B,X             
CODE_03A679:        D0 16         BNE CODE_03A691           
CODE_03A67B:        BD 1C 15      LDA.W $151C,X             
CODE_03A67E:        C9 09         CMP.B #$09                
CODE_03A680:        F0 3E         BEQ CODE_03A6C0           
CODE_03A682:        A9 02         LDA.B #$02                
CODE_03A684:        9D 7B 18      STA.W $187B,X             
CODE_03A687:        A9 01         LDA.B #$01                
CODE_03A689:        9D 1C 15      STA.W $151C,X             
CODE_03A68C:        A9 80         LDA.B #$80                
CODE_03A68E:        9D 40 15      STA.W $1540,X             
CODE_03A691:        7A            PLY                       
CODE_03A692:        7A            PLY                       
CODE_03A693:        48            PHA                       
CODE_03A694:        AD B5 14      LDA.W $14B5               
CODE_03A697:        4A            LSR                       
CODE_03A698:        4A            LSR                       
CODE_03A699:        A8            TAY                       
CODE_03A69A:        B9 4D A6      LDA.W DATA_03A64D,Y       
CODE_03A69D:        85 36         STA $36                   
CODE_03A69F:        64 37         STZ $37                   
CODE_03A6A1:        10 02         BPL CODE_03A6A5           
CODE_03A6A3:        E6 37         INC $37                   
CODE_03A6A5:        68            PLA                       
CODE_03A6A6:        A0 0C         LDY.B #$0C                
CODE_03A6A8:        C9 40         CMP.B #$40                
CODE_03A6AA:        B0 0A         BCS CODE_03A6B6           
CODE_03A6AC:        A5 13         LDA RAM_FrameCounter      
CODE_03A6AE:        A0 10         LDY.B #$10                
CODE_03A6B0:        29 04         AND.B #$04                
CODE_03A6B2:        F0 02         BEQ CODE_03A6B6           
CODE_03A6B4:        A0 12         LDY.B #$12                
CODE_03A6B6:        98            TYA                       
CODE_03A6B7:        9D 70 15      STA.W $1570,X             
CODE_03A6BA:        A9 02         LDA.B #$02                
CODE_03A6BC:        8D 27 14      STA.W $1427               
Return03A6BF:       60            RTS                       ; Return 

CODE_03A6C0:        A9 04         LDA.B #$04                
CODE_03A6C2:        9D 1C 15      STA.W $151C,X             
CODE_03A6C5:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
Return03A6C7:       60            RTS                       ; Return 

KillMostSprites:    A0 09         LDY.B #$09                
CODE_03A6CA:        B9 C8 14      LDA.W $14C8,Y             
CODE_03A6CD:        F0 1D         BEQ CODE_03A6EC           
CODE_03A6CF:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_03A6D2:        C9 A9         CMP.B #$A9                
CODE_03A6D4:        F0 16         BEQ CODE_03A6EC           
CODE_03A6D6:        C9 29         CMP.B #$29                
CODE_03A6D8:        F0 12         BEQ CODE_03A6EC           
CODE_03A6DA:        C9 A0         CMP.B #$A0                
CODE_03A6DC:        F0 0E         BEQ CODE_03A6EC           
CODE_03A6DE:        C9 C5         CMP.B #$C5                
CODE_03A6E0:        F0 0A         BEQ CODE_03A6EC           
CODE_03A6E2:        A9 04         LDA.B #$04                ; \ Sprite status = Killed by spin jump 
CODE_03A6E4:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_03A6E7:        A9 1F         LDA.B #$1F                ; \ Time to show cloud of smoke = #$1F 
CODE_03A6E9:        99 40 15      STA.W $1540,Y             ; / 
CODE_03A6EC:        88            DEY                       
CODE_03A6ED:        10 DB         BPL CODE_03A6CA           
Return03A6EF:       6B            RTL                       ; Return 


DATA_03A6F0:                      .db $0E,$0E,$0A,$08,$06,$04,$02,$00

CODE_03A6F8:        BD 40 15      LDA.W $1540,X             
CODE_03A6FB:        F0 34         BEQ CODE_03A731           
CODE_03A6FD:        C9 01         CMP.B #$01                
CODE_03A6FF:        D0 05         BNE CODE_03A706           
CODE_03A701:        A0 17         LDY.B #$17                
CODE_03A703:        8C FB 1D      STY.W $1DFB               ; / Change music 
CODE_03A706:        4A            LSR                       
CODE_03A707:        4A            LSR                       
CODE_03A708:        4A            LSR                       
CODE_03A709:        4A            LSR                       
CODE_03A70A:        A8            TAY                       
CODE_03A70B:        B9 F0 A6      LDA.W DATA_03A6F0,Y       
CODE_03A70E:        9D 70 15      STA.W $1570,X             
CODE_03A711:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_03A713:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03A715:        9E 28 15      STZ.W $1528,X             
CODE_03A718:        9E 34 15      STZ.W $1534,X             
CODE_03A71B:        9C B2 14      STZ.W $14B2               
Return03A71E:       60            RTS                       ; Return 


DATA_03A71F:                      .db $01,$FF

DATA_03A721:                      .db $10,$80

DATA_03A723:                      .db $07,$03

DATA_03A725:                      .db $FF,$01

DATA_03A727:                      .db $F0,$08

DATA_03A729:                      .db $01,$FF

DATA_03A72B:                      .db $03,$03

DATA_03A72D:                      .db $60,$02

DATA_03A72F:                      .db $01,$01

CODE_03A731:        BC 28 15      LDY.W $1528,X             
CODE_03A734:        C0 02         CPY.B #$02                
CODE_03A736:        B0 17         BCS CODE_03A74F           
CODE_03A738:        A5 13         LDA RAM_FrameCounter      
CODE_03A73A:        39 23 A7      AND.W DATA_03A723,Y       
CODE_03A73D:        D0 10         BNE CODE_03A74F           
CODE_03A73F:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_03A741:        18            CLC                       
CODE_03A742:        79 1F A7      ADC.W DATA_03A71F,Y       
CODE_03A745:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03A747:        D9 21 A7      CMP.W DATA_03A721,Y       
CODE_03A74A:        D0 03         BNE CODE_03A74F           
CODE_03A74C:        FE 28 15      INC.W $1528,X             
CODE_03A74F:        BC 34 15      LDY.W $1534,X             
CODE_03A752:        C0 02         CPY.B #$02                
CODE_03A754:        B0 17         BCS CODE_03A76D           
CODE_03A756:        A5 13         LDA RAM_FrameCounter      
CODE_03A758:        39 2B A7      AND.W DATA_03A72B,Y       
CODE_03A75B:        D0 10         BNE CODE_03A76D           
CODE_03A75D:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03A75F:        18            CLC                       
CODE_03A760:        79 25 A7      ADC.W DATA_03A725,Y       
CODE_03A763:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03A765:        D9 27 A7      CMP.W DATA_03A727,Y       
CODE_03A768:        D0 03         BNE CODE_03A76D           
CODE_03A76A:        FE 34 15      INC.W $1534,X             
CODE_03A76D:        AC B2 14      LDY.W $14B2               
CODE_03A770:        C0 02         CPY.B #$02                
CODE_03A772:        F0 20         BEQ CODE_03A794           
CODE_03A774:        A5 13         LDA RAM_FrameCounter      
CODE_03A776:        39 2F A7      AND.W DATA_03A72F,Y       
CODE_03A779:        D0 12         BNE CODE_03A78D           
CODE_03A77B:        A5 38         LDA $38                   
CODE_03A77D:        18            CLC                       
CODE_03A77E:        79 29 A7      ADC.W DATA_03A729,Y       
CODE_03A781:        85 38         STA $38                   
CODE_03A783:        85 39         STA $39                   
CODE_03A785:        D9 2D A7      CMP.W DATA_03A72D,Y       
CODE_03A788:        D0 03         BNE CODE_03A78D           
CODE_03A78A:        EE B2 14      INC.W $14B2               
CODE_03A78D:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03A790:        C9 FE         CMP.B #$FE                
CODE_03A792:        D0 18         BNE Return03A7AC          
CODE_03A794:        A9 03         LDA.B #$03                
CODE_03A796:        9D 1C 15      STA.W $151C,X             
CODE_03A799:        A9 80         LDA.B #$80                
CODE_03A79B:        8D B0 14      STA.W $14B0               
CODE_03A79E:        22 F9 AC 01   JSL.L GetRand             
CODE_03A7A2:        29 F0         AND.B #$F0                
CODE_03A7A4:        8D B7 14      STA.W $14B7               
CODE_03A7A7:        A9 1D         LDA.B #$1D                
CODE_03A7A9:        8D FB 1D      STA.W $1DFB               ; / Change music 
Return03A7AC:       60            RTS                       ; Return 

CODE_03A7AD:        A9 60         LDA.B #$60                
CODE_03A7AF:        85 38         STA $38                   
CODE_03A7B1:        85 39         STA $39                   
CODE_03A7B3:        A9 FF         LDA.B #$FF                
CODE_03A7B5:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_03A7B8:        A9 60         LDA.B #$60                
CODE_03A7BA:        95 E4         STA RAM_SpriteXLo,X       
CODE_03A7BC:        AD B0 14      LDA.W $14B0               
CODE_03A7BF:        D0 1E         BNE CODE_03A7DF           
CODE_03A7C1:        A9 18         LDA.B #$18                
CODE_03A7C3:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_03A7C6:        A9 02         LDA.B #$02                
CODE_03A7C8:        9D 1C 15      STA.W $151C,X             
CODE_03A7CB:        A9 18         LDA.B #$18                
CODE_03A7CD:        95 D8         STA RAM_SpriteYLo,X       
CODE_03A7CF:        A9 00         LDA.B #$00                
CODE_03A7D1:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_03A7D4:        A9 08         LDA.B #$08                
CODE_03A7D6:        85 38         STA $38                   
CODE_03A7D8:        85 39         STA $39                   
CODE_03A7DA:        A9 64         LDA.B #$64                
CODE_03A7DC:        95 B6         STA RAM_SpriteSpeedX,X    
Return03A7DE:       60            RTS                       ; Return 

CODE_03A7DF:        C9 60         CMP.B #$60                
CODE_03A7E1:        B0 5D         BCS Return03A840          
CODE_03A7E3:        A5 13         LDA RAM_FrameCounter      
CODE_03A7E5:        29 1F         AND.B #$1F                
CODE_03A7E7:        D0 57         BNE Return03A840          
CODE_03A7E9:        A0 07         LDY.B #$07                
CODE_03A7EB:        B9 C8 14      LDA.W $14C8,Y             
CODE_03A7EE:        F0 06         BEQ CODE_03A7F6           
CODE_03A7F0:        88            DEY                       
CODE_03A7F1:        C0 01         CPY.B #$01                
CODE_03A7F3:        D0 F6         BNE CODE_03A7EB           
Return03A7F5:       60            RTS                       ; Return 

CODE_03A7F6:        A9 17         LDA.B #$17                ; \ Play sound effect 
CODE_03A7F8:        8D FC 1D      STA.W $1DFC               ; / 
CODE_03A7FB:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_03A7FD:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_03A800:        A9 33         LDA.B #$33                
CODE_03A802:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_03A805:        AD B7 14      LDA.W $14B7               
CODE_03A808:        48            PHA                       
CODE_03A809:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_03A80C:        18            CLC                       
CODE_03A80D:        69 20         ADC.B #$20                
CODE_03A80F:        8D B7 14      STA.W $14B7               
CODE_03A812:        A9 00         LDA.B #$00                
CODE_03A814:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_03A817:        A9 00         LDA.B #$00                
CODE_03A819:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_03A81C:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_03A81F:        DA            PHX                       
CODE_03A820:        BB            TYX                       
CODE_03A821:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_03A825:        F6 C2         INC RAM_SpriteState,X     
CODE_03A827:        1E 86 16      ASL.W RAM_Tweaker1686,X   
CODE_03A82A:        5E 86 16      LSR.W RAM_Tweaker1686,X   
CODE_03A82D:        A9 39         LDA.B #$39                
CODE_03A82F:        9D 62 16      STA.W RAM_Tweaker1662,X   
CODE_03A832:        FA            PLX                       
CODE_03A833:        68            PLA                       
CODE_03A834:        4A            LSR                       
CODE_03A835:        4A            LSR                       
CODE_03A836:        4A            LSR                       
CODE_03A837:        4A            LSR                       
CODE_03A838:        4A            LSR                       
CODE_03A839:        A8            TAY                       
CODE_03A83A:        B9 41 A8      LDA.W BowserSound,Y       
CODE_03A83D:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
Return03A840:       60            RTS                       ; Return 


BowserSound:                      .db $2D

BowserSoundMusic:                 .db $2E,$2F,$30,$31,$32,$33,$34,$19
                                  .db $1A

CODE_03A84B:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03A84D:        BD 40 15      LDA.W $1540,X             
CODE_03A850:        D0 1C         BNE CODE_03A86E           
CODE_03A852:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_03A854:        F0 02         BEQ CODE_03A858           
CODE_03A856:        D6 B6         DEC RAM_SpriteSpeedX,X    
CODE_03A858:        A5 13         LDA RAM_FrameCounter      
CODE_03A85A:        29 03         AND.B #$03                
CODE_03A85C:        D0 0F         BNE Return03A86D          
CODE_03A85E:        E6 38         INC $38                   
CODE_03A860:        E6 39         INC $39                   
CODE_03A862:        A5 38         LDA $38                   
CODE_03A864:        C9 20         CMP.B #$20                
CODE_03A866:        D0 05         BNE Return03A86D          
CODE_03A868:        A9 FF         LDA.B #$FF                
CODE_03A86A:        9D 40 15      STA.W $1540,X             
Return03A86D:       60            RTS                       ; Return 

CODE_03A86E:        C9 A0         CMP.B #$A0                
CODE_03A870:        D0 05         BNE CODE_03A877           
CODE_03A872:        48            PHA                       
CODE_03A873:        20 D6 A8      JSR.W CODE_03A8D6         
CODE_03A876:        68            PLA                       
CODE_03A877:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_03A879:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03A87B:        C9 01         CMP.B #$01                
CODE_03A87D:        F0 1E         BEQ CODE_03A89D           
CODE_03A87F:        C9 40         CMP.B #$40                
CODE_03A881:        B0 2B         BCS CODE_03A8AE           
CODE_03A883:        C9 3F         CMP.B #$3F                
CODE_03A885:        D0 0B         BNE CODE_03A892           
CODE_03A887:        48            PHA                       
CODE_03A888:        AC B4 14      LDY.W $14B4               
CODE_03A88B:        B9 42 A8      LDA.W BowserSoundMusic,Y  
CODE_03A88E:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_03A891:        68            PLA                       
CODE_03A892:        4A            LSR                       
CODE_03A893:        4A            LSR                       
CODE_03A894:        4A            LSR                       
CODE_03A895:        A8            TAY                       
CODE_03A896:        B9 37 A4      LDA.W DATA_03A437,Y       
CODE_03A899:        9D 70 15      STA.W $1570,X             
Return03A89C:       60            RTS                       ; Return 

CODE_03A89D:        AD B4 14      LDA.W $14B4               
CODE_03A8A0:        1A            INC A                     
CODE_03A8A1:        9D 1C 15      STA.W $151C,X             
CODE_03A8A4:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_03A8A6:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03A8A8:        A9 80         LDA.B #$80                
CODE_03A8AA:        8D B0 14      STA.W $14B0               
Return03A8AD:       60            RTS                       ; Return 

CODE_03A8AE:        C9 E8         CMP.B #$E8                
CODE_03A8B0:        D0 05         BNE CODE_03A8B7           
CODE_03A8B2:        A0 2A         LDY.B #$2A                ; \ Play sound effect 
CODE_03A8B4:        8C F9 1D      STY.W $1DF9               ; / 
CODE_03A8B7:        38            SEC                       
CODE_03A8B8:        E9 3F         SBC.B #$3F                
CODE_03A8BA:        9D 94 15      STA.W $1594,X             
Return03A8BD:       60            RTS                       ; Return 


DATA_03A8BE:                      .db $00,$00,$00,$08,$10,$14,$14,$16
                                  .db $16,$18,$18,$17,$16,$16,$17,$18
                                  .db $18,$17,$14,$10,$0C,$08,$04,$00

CODE_03A8D6:        A0 07         LDY.B #$07                
CODE_03A8D8:        B9 C8 14      LDA.W $14C8,Y             
CODE_03A8DB:        F0 06         BEQ CODE_03A8E3           
ADDR_03A8DD:        88            DEY                       
ADDR_03A8DE:        C0 01         CPY.B #$01                
ADDR_03A8E0:        D0 F6         BNE CODE_03A8D8           
Return03A8E2:       60            RTS                       ; Return 

CODE_03A8E3:        A9 10         LDA.B #$10                ; \ Play sound effect 
CODE_03A8E5:        8D F9 1D      STA.W $1DF9               ; / 
CODE_03A8E8:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_03A8EA:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_03A8ED:        A9 74         LDA.B #$74                
CODE_03A8EF:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_03A8F2:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03A8F4:        18            CLC                       
CODE_03A8F5:        69 04         ADC.B #$04                
CODE_03A8F7:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_03A8FA:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03A8FD:        69 00         ADC.B #$00                
CODE_03A8FF:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_03A902:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03A904:        18            CLC                       
CODE_03A905:        69 18         ADC.B #$18                
CODE_03A907:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_03A90A:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03A90D:        69 00         ADC.B #$00                
CODE_03A90F:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_03A912:        DA            PHX                       
CODE_03A913:        BB            TYX                       
CODE_03A914:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_03A918:        A9 C0         LDA.B #$C0                
CODE_03A91A:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03A91C:        9E 7C 15      STZ.W RAM_SpriteDir,X     
CODE_03A91F:        A0 0C         LDY.B #$0C                
CODE_03A921:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03A923:        10 05         BPL CODE_03A92A           
CODE_03A925:        A0 F4         LDY.B #$F4                
CODE_03A927:        FE 7C 15      INC.W RAM_SpriteDir,X     
CODE_03A92A:        94 B6         STY RAM_SpriteSpeedX,X    
CODE_03A92C:        FA            PLX                       
Return03A92D:       60            RTS                       ; Return 


DATA_03A92E:                      .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $00,$08,$00,$08,$00,$08,$00,$08
                                  .db $08,$00,$08,$00,$08,$00,$08,$00
                                  .db $08,$00,$08,$00,$08,$00,$08,$00
                                  .db $08,$00,$08,$00,$08,$00,$08,$00
                                  .db $08,$00,$08,$00,$08,$00,$08,$00
DATA_03A97E:                      .db $00,$00,$08,$08,$00,$00,$08,$08
                                  .db $00,$00,$08,$08,$00,$00,$08,$08
                                  .db $00,$00,$10,$10,$00,$00,$10,$10
                                  .db $00,$00,$10,$10,$00,$00,$10,$10
                                  .db $00,$00,$10,$10,$00,$00,$10,$10
                                  .db $00,$00,$10,$10,$00,$00,$10,$10
                                  .db $00,$00,$10,$10,$00,$00,$10,$10
                                  .db $00,$00,$10,$10,$00,$00,$10,$10
                                  .db $00,$00,$10,$10,$00,$00,$10,$10
                                  .db $00,$00,$10,$10,$00,$00,$10,$10
DATA_03A9CE:                      .db $05,$06,$15,$16,$9D,$9E,$4E,$AE
                                  .db $06,$05,$16,$15,$9E,$9D,$AE,$4E
                                  .db $8A,$8B,$AA,$68,$83,$84,$AA,$68
                                  .db $8A,$8B,$80,$81,$83,$84,$80,$81
                                  .db $85,$86,$A5,$A6,$83,$84,$A5,$A6
                                  .db $82,$83,$A2,$A3,$82,$83,$A2,$A3
                                  .db $8A,$8B,$AA,$68,$83,$84,$AA,$68
                                  .db $8A,$8B,$80,$81,$83,$84,$80,$81
                                  .db $85,$86,$A5,$A6,$83,$84,$A5,$A6
                                  .db $82,$83,$A2,$A3,$82,$83,$A2,$A3
DATA_03AA1E:                      .db $01,$01,$01,$01,$01,$01,$01,$01
                                  .db $41,$41,$41,$41,$41,$41,$41,$41
                                  .db $01,$01,$01,$01,$01,$01,$01,$01
                                  .db $01,$01,$01,$01,$01,$01,$01,$01
                                  .db $00,$00,$00,$00,$01,$01,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $41,$41,$41,$41,$41,$41,$41,$41
                                  .db $41,$41,$41,$41,$41,$41,$41,$41
                                  .db $40,$40,$40,$40,$41,$41,$40,$40
                                  .db $40,$40,$40,$40,$40,$40,$40,$40

CODE_03AA6E:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03AA70:        18            CLC                       
CODE_03AA71:        69 04         ADC.B #$04                
CODE_03AA73:        38            SEC                       
CODE_03AA74:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_03AA76:        85 00         STA $00                   
CODE_03AA78:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03AA7A:        18            CLC                       
CODE_03AA7B:        69 20         ADC.B #$20                
CODE_03AA7D:        38            SEC                       
CODE_03AA7E:        E5 02         SBC $02                   
CODE_03AA80:        38            SEC                       
CODE_03AA81:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_03AA83:        85 01         STA $01                   
CODE_03AA85:        C0 08         CPY.B #$08                
CODE_03AA87:        90 3D         BCC CODE_03AAC6           
CODE_03AA89:        C0 10         CPY.B #$10                
CODE_03AA8B:        B0 39         BCS CODE_03AAC6           
CODE_03AA8D:        A5 00         LDA $00                   
CODE_03AA8F:        38            SEC                       
CODE_03AA90:        E9 04         SBC.B #$04                
CODE_03AA92:        8D A0 02      STA.W $02A0               
CODE_03AA95:        18            CLC                       
CODE_03AA96:        69 10         ADC.B #$10                
CODE_03AA98:        8D A4 02      STA.W $02A4               
CODE_03AA9B:        A5 01         LDA $01                   
CODE_03AA9D:        38            SEC                       
CODE_03AA9E:        E9 18         SBC.B #$18                
CODE_03AAA0:        8D A1 02      STA.W $02A1               
CODE_03AAA3:        8D A5 02      STA.W $02A5               
CODE_03AAA6:        A9 20         LDA.B #$20                
CODE_03AAA8:        8D A2 02      STA.W $02A2               
CODE_03AAAB:        A9 22         LDA.B #$22                
CODE_03AAAD:        8D A6 02      STA.W $02A6               
CODE_03AAB0:        A5 14         LDA RAM_FrameCounterB     
CODE_03AAB2:        4A            LSR                       
CODE_03AAB3:        29 06         AND.B #$06                
CODE_03AAB5:        1A            INC A                     
CODE_03AAB6:        1A            INC A                     
CODE_03AAB7:        1A            INC A                     
CODE_03AAB8:        8D A3 02      STA.W $02A3               
CODE_03AABB:        8D A7 02      STA.W $02A7               
CODE_03AABE:        A9 02         LDA.B #$02                
CODE_03AAC0:        8D 48 04      STA.W $0448               
CODE_03AAC3:        8D 49 04      STA.W $0449               
CODE_03AAC6:        A0 70         LDY.B #$70                
CODE_03AAC8:        A5 03         LDA $03                   
CODE_03AACA:        0A            ASL                       
CODE_03AACB:        0A            ASL                       
CODE_03AACC:        85 04         STA $04                   
CODE_03AACE:        DA            PHX                       
CODE_03AACF:        A2 03         LDX.B #$03                
CODE_03AAD1:        DA            PHX                       
CODE_03AAD2:        8A            TXA                       
CODE_03AAD3:        18            CLC                       
CODE_03AAD4:        65 04         ADC $04                   
CODE_03AAD6:        AA            TAX                       
CODE_03AAD7:        A5 00         LDA $00                   
CODE_03AAD9:        18            CLC                       
CODE_03AADA:        7D 2E A9      ADC.W DATA_03A92E,X       
CODE_03AADD:        99 00 03      STA.W OAM_DispX,Y         
CODE_03AAE0:        A5 01         LDA $01                   
CODE_03AAE2:        18            CLC                       
CODE_03AAE3:        7D 7E A9      ADC.W DATA_03A97E,X       
CODE_03AAE6:        99 01 03      STA.W OAM_DispY,Y         
CODE_03AAE9:        BD CE A9      LDA.W DATA_03A9CE,X       
CODE_03AAEC:        99 02 03      STA.W OAM_Tile,Y          
CODE_03AAEF:        BD 1E AA      LDA.W DATA_03AA1E,X       
CODE_03AAF2:        DA            PHX                       
CODE_03AAF3:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_03AAF6:        E0 09         CPX.B #$09                
CODE_03AAF8:        F0 02         BEQ CODE_03AAFC           
CODE_03AAFA:        09 30         ORA.B #$30                
CODE_03AAFC:        99 03 03      STA.W OAM_Prop,Y          
CODE_03AAFF:        FA            PLX                       
CODE_03AB00:        5A            PHY                       
CODE_03AB01:        98            TYA                       
CODE_03AB02:        4A            LSR                       
CODE_03AB03:        4A            LSR                       
CODE_03AB04:        A8            TAY                       
CODE_03AB05:        A9 02         LDA.B #$02                
CODE_03AB07:        99 60 04      STA.W OAM_TileSize,Y      
CODE_03AB0A:        7A            PLY                       
CODE_03AB0B:        C8            INY                       
CODE_03AB0C:        C8            INY                       
CODE_03AB0D:        C8            INY                       
CODE_03AB0E:        C8            INY                       
CODE_03AB0F:        FA            PLX                       
CODE_03AB10:        CA            DEX                       
CODE_03AB11:        10 BE         BPL CODE_03AAD1           
CODE_03AB13:        FA            PLX                       
Return03AB14:       60            RTS                       ; Return 


DATA_03AB15:                      .db $01,$FF

DATA_03AB17:                      .db $20,$E0

DATA_03AB19:                      .db $02,$FE

DATA_03AB1B:                      .db $20,$E0,$01,$FF,$10,$F0

CODE_03AB21:        20 FD A4      JSR.W CODE_03A4FD         
CODE_03AB24:        20 D2 A4      JSR.W CODE_03A4D2         
CODE_03AB27:        20 ED A4      JSR.W CODE_03A4ED         
CODE_03AB2A:        A5 13         LDA RAM_FrameCounter      
CODE_03AB2C:        29 00         AND.B #$00                
CODE_03AB2E:        D0 1B         BNE CODE_03AB4B           
CODE_03AB30:        A0 00         LDY.B #$00                
CODE_03AB32:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03AB34:        C5 94         CMP RAM_MarioXPos         
CODE_03AB36:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03AB39:        E5 95         SBC RAM_MarioXPosHi       
CODE_03AB3B:        30 01         BMI CODE_03AB3E           
CODE_03AB3D:        C8            INY                       
CODE_03AB3E:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_03AB40:        D9 17 AB      CMP.W DATA_03AB17,Y       
CODE_03AB43:        F0 06         BEQ CODE_03AB4B           
CODE_03AB45:        18            CLC                       
CODE_03AB46:        79 15 AB      ADC.W DATA_03AB15,Y       
CODE_03AB49:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03AB4B:        A0 00         LDY.B #$00                
CODE_03AB4D:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03AB4F:        C9 10         CMP.B #$10                
CODE_03AB51:        30 01         BMI CODE_03AB54           
CODE_03AB53:        C8            INY                       
CODE_03AB54:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03AB56:        D9 1B AB      CMP.W DATA_03AB1B,Y       
CODE_03AB59:        F0 06         BEQ Return03AB61          
CODE_03AB5B:        18            CLC                       
CODE_03AB5C:        79 19 AB      ADC.W DATA_03AB19,Y       
CODE_03AB5F:        95 AA         STA RAM_SpriteSpeedY,X    
Return03AB61:       60            RTS                       ; Return 


DATA_03AB62:                      .db $10,$F0

CODE_03AB64:        A9 03         LDA.B #$03                
CODE_03AB66:        8D 27 14      STA.W $1427               
CODE_03AB69:        20 FD A4      JSR.W CODE_03A4FD         
CODE_03AB6C:        20 D2 A4      JSR.W CODE_03A4D2         
CODE_03AB6F:        20 ED A4      JSR.W CODE_03A4ED         
CODE_03AB72:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03AB74:        18            CLC                       
CODE_03AB75:        69 03         ADC.B #$03                
CODE_03AB77:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03AB79:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03AB7B:        C9 64         CMP.B #$64                
CODE_03AB7D:        90 1F         BCC Return03AB9E          
CODE_03AB7F:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03AB82:        30 1A         BMI Return03AB9E          
CODE_03AB84:        A9 64         LDA.B #$64                
CODE_03AB86:        95 D8         STA RAM_SpriteYLo,X       
CODE_03AB88:        A9 A0         LDA.B #$A0                
CODE_03AB8A:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03AB8C:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_03AB8E:        8D FC 1D      STA.W $1DFC               ; / 
CODE_03AB91:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_03AB94:        B9 62 AB      LDA.W DATA_03AB62,Y       
CODE_03AB97:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03AB99:        A9 20         LDA.B #$20                ; \ Set ground shake timer 
CODE_03AB9B:        8D 87 18      STA.W RAM_ShakeGrndTimer  ; / 
Return03AB9E:       60            RTS                       ; Return 

CODE_03AB9F:        20 AC A6      JSR.W CODE_03A6AC         
CODE_03ABA2:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03ABA5:        30 08         BMI CODE_03ABAF           
CODE_03ABA7:        D0 10         BNE CODE_03ABB9           
CODE_03ABA9:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03ABAB:        C9 10         CMP.B #$10                
CODE_03ABAD:        B0 0A         BCS CODE_03ABB9           
CODE_03ABAF:        A9 05         LDA.B #$05                
CODE_03ABB1:        9D 1C 15      STA.W $151C,X             
CODE_03ABB4:        A9 60         LDA.B #$60                
CODE_03ABB6:        9D 40 15      STA.W $1540,X             
CODE_03ABB9:        A9 F8         LDA.B #$F8                
CODE_03ABBB:        95 AA         STA RAM_SpriteSpeedY,X    
Return03ABBD:       60            RTS                       ; Return 

CODE_03ABBE:        20 AC A6      JSR.W CODE_03A6AC         
CODE_03ABC1:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_03ABC3:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03ABC5:        BD 40 15      LDA.W $1540,X             
CODE_03ABC8:        D0 21         BNE CODE_03ABEB           
CODE_03ABCA:        A5 36         LDA $36                   
CODE_03ABCC:        18            CLC                       
CODE_03ABCD:        69 0A         ADC.B #$0A                
CODE_03ABCF:        85 36         STA $36                   
CODE_03ABD1:        A5 37         LDA $37                   
CODE_03ABD3:        69 00         ADC.B #$00                
CODE_03ABD5:        85 37         STA $37                   
CODE_03ABD7:        F0 11         BEQ Return03ABEA          
CODE_03ABD9:        64 36         STZ $36                   
CODE_03ABDB:        A9 20         LDA.B #$20                
CODE_03ABDD:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_03ABE0:        A9 60         LDA.B #$60                
CODE_03ABE2:        9D 40 15      STA.W $1540,X             
CODE_03ABE5:        A9 06         LDA.B #$06                
CODE_03ABE7:        9D 1C 15      STA.W $151C,X             
Return03ABEA:       60            RTS                       ; Return 

CODE_03ABEB:        C9 40         CMP.B #$40                
CODE_03ABED:        90 13         BCC Return03AC02          
CODE_03ABEF:        C9 5E         CMP.B #$5E                
CODE_03ABF1:        D0 05         BNE CODE_03ABF8           
CODE_03ABF3:        A0 1B         LDY.B #$1B                
CODE_03ABF5:        8C FB 1D      STY.W $1DFB               ; / Change music 
CODE_03ABF8:        BD 64 15      LDA.W $1564,X             
CODE_03ABFB:        D0 05         BNE Return03AC02          
CODE_03ABFD:        A9 12         LDA.B #$12                
CODE_03ABFF:        9D 64 15      STA.W $1564,X             
Return03AC02:       60            RTS                       ; Return 

CODE_03AC03:        20 AC A6      JSR.W CODE_03A6AC         
CODE_03AC06:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_03AC09:        C9 01         CMP.B #$01                
CODE_03AC0B:        D0 15         BNE CODE_03AC22           
CODE_03AC0D:        A9 0B         LDA.B #$0B                
CODE_03AC0F:        85 71         STA RAM_MarioAnimation    
CODE_03AC11:        EE 0D 19      INC.W $190D               
CODE_03AC14:        9C 01 07      STZ.W $0701               
CODE_03AC17:        9C 02 07      STZ.W $0702               
CODE_03AC1A:        A9 03         LDA.B #$03                
CODE_03AC1C:        8D F9 13      STA.W RAM_IsBehindScenery 
CODE_03AC1F:        20 63 AC      JSR.W CODE_03AC63         
CODE_03AC22:        BD 40 15      LDA.W $1540,X             
CODE_03AC25:        D0 25         BNE Return03AC4C          
CODE_03AC27:        A9 FA         LDA.B #$FA                
CODE_03AC29:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03AC2B:        A9 FC         LDA.B #$FC                
CODE_03AC2D:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03AC2F:        A5 36         LDA $36                   
CODE_03AC31:        18            CLC                       
CODE_03AC32:        69 05         ADC.B #$05                
CODE_03AC34:        85 36         STA $36                   
CODE_03AC36:        A5 37         LDA $37                   
CODE_03AC38:        69 00         ADC.B #$00                
CODE_03AC3A:        85 37         STA $37                   
CODE_03AC3C:        A5 13         LDA RAM_FrameCounter      
CODE_03AC3E:        29 03         AND.B #$03                
CODE_03AC40:        D0 0A         BNE Return03AC4C          
CODE_03AC42:        A5 38         LDA $38                   
CODE_03AC44:        C9 80         CMP.B #$80                
CODE_03AC46:        B0 05         BCS CODE_03AC4D           
CODE_03AC48:        E6 38         INC $38                   
CODE_03AC4A:        E6 39         INC $39                   
Return03AC4C:       60            RTS                       ; Return 

CODE_03AC4D:        BD 4A 16      LDA.W $164A,X             
CODE_03AC50:        D0 08         BNE CODE_03AC5A           
CODE_03AC52:        A9 1C         LDA.B #$1C                
CODE_03AC54:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_03AC57:        FE 4A 16      INC.W $164A,X             
CODE_03AC5A:        A9 FE         LDA.B #$FE                
CODE_03AC5C:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_03AC5F:        9D D4 14      STA.W RAM_SpriteYHi,X     
Return03AC62:       60            RTS                       ; Return 

CODE_03AC63:        A9 08         LDA.B #$08                
CODE_03AC65:        8D D0 14      STA.W $14D0               
CODE_03AC68:        A9 7C         LDA.B #$7C                
CODE_03AC6A:        85 A6         STA $A6                   
CODE_03AC6C:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03AC6E:        18            CLC                       
CODE_03AC6F:        69 08         ADC.B #$08                
CODE_03AC71:        85 EC         STA $EC                   
CODE_03AC73:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03AC76:        69 00         ADC.B #$00                
CODE_03AC78:        8D E8 14      STA.W $14E8               
CODE_03AC7B:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03AC7D:        18            CLC                       
CODE_03AC7E:        69 47         ADC.B #$47                
CODE_03AC80:        85 E0         STA $E0                   
CODE_03AC82:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03AC85:        69 00         ADC.B #$00                
CODE_03AC87:        8D DC 14      STA.W $14DC               
CODE_03AC8A:        DA            PHX                       
CODE_03AC8B:        A2 08         LDX.B #$08                
CODE_03AC8D:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_03AC91:        FA            PLX                       
Return03AC92:       60            RTS                       ; Return 


BlushTileDispY:                   .db $01,$11

BlushTiles:                       .db $6E,$88

PrincessPeach:      B5 E4         LDA RAM_SpriteXLo,X       
CODE_03AC99:        38            SEC                       
CODE_03AC9A:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_03AC9C:        85 00         STA $00                   
CODE_03AC9E:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03ACA0:        38            SEC                       
CODE_03ACA1:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_03ACA3:        85 01         STA $01                   
CODE_03ACA5:        A5 13         LDA RAM_FrameCounter      
CODE_03ACA7:        29 7F         AND.B #$7F                
CODE_03ACA9:        D0 0D         BNE CODE_03ACB8           
CODE_03ACAB:        22 F9 AC 01   JSL.L GetRand             
CODE_03ACAF:        29 07         AND.B #$07                
CODE_03ACB1:        D0 05         BNE CODE_03ACB8           
CODE_03ACB3:        A9 0C         LDA.B #$0C                
CODE_03ACB5:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_03ACB8:        BC 02 16      LDY.W $1602,X             
CODE_03ACBB:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_03ACBE:        F0 01         BEQ CODE_03ACC1           
CODE_03ACC0:        C8            INY                       
CODE_03ACC1:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_03ACC4:        D0 05         BNE CODE_03ACCB           
CODE_03ACC6:        98            TYA                       
CODE_03ACC7:        18            CLC                       
CODE_03ACC8:        69 08         ADC.B #$08                
CODE_03ACCA:        A8            TAY                       
CODE_03ACCB:        84 03         STY $03                   
CODE_03ACCD:        A9 D0         LDA.B #$D0                
CODE_03ACCF:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_03ACD2:        A8            TAY                       
CODE_03ACD3:        20 C8 AA      JSR.W CODE_03AAC8         
CODE_03ACD6:        A0 02         LDY.B #$02                
CODE_03ACD8:        A9 03         LDA.B #$03                
CODE_03ACDA:        22 B3 B7 01   JSL.L FinishOAMWrite      
CODE_03ACDE:        BD 58 15      LDA.W $1558,X             
CODE_03ACE1:        F0 35         BEQ CODE_03AD18           
CODE_03ACE3:        DA            PHX                       
CODE_03ACE4:        A2 00         LDX.B #$00                
CODE_03ACE6:        A5 19         LDA RAM_MarioPowerUp      
CODE_03ACE8:        D0 01         BNE CODE_03ACEB           
CODE_03ACEA:        E8            INX                       
CODE_03ACEB:        A0 4C         LDY.B #$4C                
CODE_03ACED:        A5 7E         LDA $7E                   
CODE_03ACEF:        99 00 03      STA.W OAM_DispX,Y         
CODE_03ACF2:        A5 80         LDA $80                   
CODE_03ACF4:        18            CLC                       
CODE_03ACF5:        7D 93 AC      ADC.W BlushTileDispY,X    
CODE_03ACF8:        99 01 03      STA.W OAM_DispY,Y         
CODE_03ACFB:        BD 95 AC      LDA.W BlushTiles,X        
CODE_03ACFE:        99 02 03      STA.W OAM_Tile,Y          
CODE_03AD01:        FA            PLX                       
CODE_03AD02:        A5 76         LDA RAM_MarioDirection    
CODE_03AD04:        C9 01         CMP.B #$01                
CODE_03AD06:        A9 31         LDA.B #$31                
CODE_03AD08:        90 02         BCC CODE_03AD0C           
CODE_03AD0A:        09 40         ORA.B #$40                
CODE_03AD0C:        99 03 03      STA.W OAM_Prop,Y          
CODE_03AD0F:        98            TYA                       
CODE_03AD10:        4A            LSR                       
CODE_03AD11:        4A            LSR                       
CODE_03AD12:        A8            TAY                       
CODE_03AD13:        A9 02         LDA.B #$02                
CODE_03AD15:        99 60 04      STA.W OAM_TileSize,Y      
CODE_03AD18:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_03AD1A:        64 7B         STZ RAM_MarioSpeedX       
CODE_03AD1C:        A9 04         LDA.B #$04                
CODE_03AD1E:        9D 02 16      STA.W $1602,X             
CODE_03AD21:        B5 C2         LDA RAM_SpriteState,X     
CODE_03AD23:        22 DF 86 00   JSL.L ExecutePtr          

PeachPtrs:             37 AD      .dw CODE_03AD37           
                       B3 AD      .dw CODE_03ADB3           
                       DD AD      .dw CODE_03ADDD           
                       25 AE      .dw CODE_03AE25           
                       32 AE      .dw CODE_03AE32           
                       AF AE      .dw CODE_03AEAF           
                       E8 AE      .dw CODE_03AEE8           
                       96 C7      .dw CODE_03C796           

CODE_03AD37:        A9 06         LDA.B #$06                
CODE_03AD39:        9D 02 16      STA.W $1602,X             
CODE_03AD3C:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_03AD40:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03AD42:        C9 08         CMP.B #$08                
CODE_03AD44:        B0 05         BCS CODE_03AD4B           
CODE_03AD46:        18            CLC                       
CODE_03AD47:        69 01         ADC.B #$01                
CODE_03AD49:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03AD4B:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03AD4E:        30 13         BMI CODE_03AD63           
CODE_03AD50:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03AD52:        C9 A0         CMP.B #$A0                
CODE_03AD54:        90 0D         BCC CODE_03AD63           
CODE_03AD56:        A9 A0         LDA.B #$A0                
CODE_03AD58:        95 D8         STA RAM_SpriteYLo,X       
CODE_03AD5A:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03AD5C:        A9 A0         LDA.B #$A0                
CODE_03AD5E:        9D 40 15      STA.W $1540,X             
CODE_03AD61:        F6 C2         INC RAM_SpriteState,X     
CODE_03AD63:        A5 13         LDA RAM_FrameCounter      
CODE_03AD65:        29 07         AND.B #$07                
CODE_03AD67:        D0 0A         BNE Return03AD73          
CODE_03AD69:        A0 0B         LDY.B #$0B                
CODE_03AD6B:        B9 F0 17      LDA.W $17F0,Y             
CODE_03AD6E:        F0 04         BEQ CODE_03AD74           
CODE_03AD70:        88            DEY                       
CODE_03AD71:        10 F8         BPL CODE_03AD6B           
Return03AD73:       60            RTS                       ; Return 

CODE_03AD74:        A9 05         LDA.B #$05                
CODE_03AD76:        99 F0 17      STA.W $17F0,Y             
CODE_03AD79:        22 F9 AC 01   JSL.L GetRand             
CODE_03AD7D:        64 00         STZ $00                   
CODE_03AD7F:        29 1F         AND.B #$1F                
CODE_03AD81:        18            CLC                       
CODE_03AD82:        69 F8         ADC.B #$F8                
CODE_03AD84:        10 02         BPL CODE_03AD88           
CODE_03AD86:        C6 00         DEC $00                   
CODE_03AD88:        18            CLC                       
CODE_03AD89:        75 E4         ADC RAM_SpriteXLo,X       
CODE_03AD8B:        99 08 18      STA.W $1808,Y             
CODE_03AD8E:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03AD91:        65 00         ADC $00                   
CODE_03AD93:        99 EA 18      STA.W $18EA,Y             
CODE_03AD96:        AD 8E 14      LDA.W RAM_RandomByte2     
CODE_03AD99:        29 1F         AND.B #$1F                
CODE_03AD9B:        75 D8         ADC RAM_SpriteYLo,X       
CODE_03AD9D:        99 FC 17      STA.W $17FC,Y             
CODE_03ADA0:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03ADA3:        69 00         ADC.B #$00                
CODE_03ADA5:        99 14 18      STA.W $1814,Y             
CODE_03ADA8:        A9 00         LDA.B #$00                
CODE_03ADAA:        99 20 18      STA.W $1820,Y             
CODE_03ADAD:        A9 17         LDA.B #$17                
CODE_03ADAF:        99 50 18      STA.W $1850,Y             
Return03ADB2:       60            RTS                       ; Return 

CODE_03ADB3:        BD 40 15      LDA.W $1540,X             
CODE_03ADB6:        D0 0A         BNE CODE_03ADC2           
CODE_03ADB8:        F6 C2         INC RAM_SpriteState,X     
CODE_03ADBA:        20 CC AD      JSR.W CODE_03ADCC         
CODE_03ADBD:        90 03         BCC CODE_03ADC2           
ADDR_03ADBF:        FE 1C 15      INC.W $151C,X             
CODE_03ADC2:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_03ADC5:        98            TYA                       
CODE_03ADC6:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_03ADC9:        85 76         STA RAM_MarioDirection    
Return03ADCB:       60            RTS                       ; Return 

CODE_03ADCC:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_03ADD0:        22 64 B6 03   JSL.L GetMarioClipping    
CODE_03ADD4:        22 2B B7 03   JSL.L CheckForContact     
Return03ADD8:       60            RTS                       ; Return 


DATA_03ADD9:                      .db $08,$F8,$F8,$08

CODE_03ADDD:        A5 14         LDA RAM_FrameCounterB     
CODE_03ADDF:        29 08         AND.B #$08                
CODE_03ADE1:        D0 05         BNE CODE_03ADE8           
CODE_03ADE3:        A9 08         LDA.B #$08                
CODE_03ADE5:        9D 02 16      STA.W $1602,X             
CODE_03ADE8:        20 CC AD      JSR.W CODE_03ADCC         
CODE_03ADEB:        08            PHP                       
CODE_03ADEC:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_03ADEF:        28            PLP                       
CODE_03ADF0:        BD 1C 15      LDA.W $151C,X             
CODE_03ADF3:        D0 04         BNE ADDR_03ADF9           
CODE_03ADF5:        B0 1D         BCS CODE_03AE14           
CODE_03ADF7:        80 06         BRA CODE_03ADFF           

ADDR_03ADF9:        90 19         BCC CODE_03AE14           
ADDR_03ADFB:        98            TYA                       
ADDR_03ADFC:        49 01         EOR.B #$01                
ADDR_03ADFE:        A8            TAY                       
CODE_03ADFF:        B9 D9 AD      LDA.W DATA_03ADD9,Y       
CODE_03AE02:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03AE04:        49 FF         EOR.B #$FF                
CODE_03AE06:        1A            INC A                     
CODE_03AE07:        85 7B         STA RAM_MarioSpeedX       
CODE_03AE09:        98            TYA                       
CODE_03AE0A:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_03AE0D:        85 76         STA RAM_MarioDirection    
CODE_03AE0F:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
Return03AE13:       60            RTS                       ; Return 

CODE_03AE14:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_03AE17:        98            TYA                       
CODE_03AE18:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_03AE1B:        85 76         STA RAM_MarioDirection    
CODE_03AE1D:        F6 C2         INC RAM_SpriteState,X     
CODE_03AE1F:        A9 60         LDA.B #$60                
CODE_03AE21:        9D 40 15      STA.W $1540,X             
Return03AE24:       60            RTS                       ; Return 

CODE_03AE25:        BD 40 15      LDA.W $1540,X             
CODE_03AE28:        D0 07         BNE Return03AE31          
CODE_03AE2A:        F6 C2         INC RAM_SpriteState,X     
CODE_03AE2C:        A9 A0         LDA.B #$A0                
CODE_03AE2E:        9D 40 15      STA.W $1540,X             
Return03AE31:       60            RTS                       ; Return 

CODE_03AE32:        BD 40 15      LDA.W $1540,X             
CODE_03AE35:        D0 08         BNE CODE_03AE3F           
CODE_03AE37:        F6 C2         INC RAM_SpriteState,X     
CODE_03AE39:        9C 8A 18      STZ.W $188A               
CODE_03AE3C:        9C 8B 18      STZ.W $188B               
CODE_03AE3F:        C9 50         CMP.B #$50                
CODE_03AE41:        90 17         BCC Return03AE5A          
CODE_03AE43:        48            PHA                       
CODE_03AE44:        D0 05         BNE CODE_03AE4B           
CODE_03AE46:        A9 14         LDA.B #$14                
CODE_03AE48:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_03AE4B:        A9 0A         LDA.B #$0A                
CODE_03AE4D:        9D 02 16      STA.W $1602,X             
CODE_03AE50:        68            PLA                       
CODE_03AE51:        C9 68         CMP.B #$68                
CODE_03AE53:        D0 05         BNE Return03AE5A          
CODE_03AE55:        A9 80         LDA.B #$80                
CODE_03AE57:        9D 58 15      STA.W $1558,X             
Return03AE5A:       60            RTS                       ; Return 


DATA_03AE5B:                      .db $08,$08,$08,$08,$08,$08,$18,$08
                                  .db $08,$08,$08,$08,$08,$08,$08,$08
                                  .db $08,$08,$08,$08,$08,$08,$20,$08
                                  .db $08,$08,$08,$08,$20,$08,$08,$10
                                  .db $08,$08,$08,$08,$08,$08,$08,$08
                                  .db $20,$08,$08,$08,$08,$08,$20,$08
                                  .db $04,$20,$08,$08,$08,$08,$08,$08
                                  .db $08,$08,$08,$08,$08,$08,$10,$08
                                  .db $08,$08,$08,$08,$08,$08,$08,$08
                                  .db $08,$08,$10,$08,$08,$08,$08,$08
                                  .db $08,$08,$08,$40

CODE_03AEAF:        20 74 D6      JSR.W CODE_03D674         
CODE_03AEB2:        BD 40 15      LDA.W $1540,X             
CODE_03AEB5:        D0 10         BNE Return03AEC7          
CODE_03AEB7:        AC 21 19      LDY.W $1921               
CODE_03AEBA:        C0 54         CPY.B #$54                
CODE_03AEBC:        F0 0A         BEQ CODE_03AEC8           
CODE_03AEBE:        EE 21 19      INC.W $1921               
CODE_03AEC1:        B9 5B AE      LDA.W DATA_03AE5B,Y       
CODE_03AEC4:        9D 40 15      STA.W $1540,X             
Return03AEC7:       60            RTS                       ; Return 

CODE_03AEC8:        F6 C2         INC RAM_SpriteState,X     
CODE_03AECA:        A9 40         LDA.B #$40                
CODE_03AECC:        9D 40 15      STA.W $1540,X             
Return03AECF:       60            RTS                       ; Return 

CODE_03AED0:        F6 C2         INC RAM_SpriteState,X     
CODE_03AED2:        A9 80         LDA.B #$80                
CODE_03AED4:        8D EB 1F      STA.W $1FEB               
Return03AED7:       60            RTS                       ; Return 


DATA_03AED8:                      .db $00,$00,$94,$18,$18,$9C,$9C,$FF
                                  .db $00,$00,$52,$63,$63,$73,$73,$7F

CODE_03AEE8:        BD 40 15      LDA.W $1540,X             
CODE_03AEEB:        F0 E3         BEQ CODE_03AED0           
CODE_03AEED:        4A            LSR                       
CODE_03AEEE:        85 00         STA $00                   
CODE_03AEF0:        64 01         STZ $01                   
CODE_03AEF2:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03AEF4:        A5 00         LDA $00                   
CODE_03AEF6:        0A            ASL                       
CODE_03AEF7:        0A            ASL                       
CODE_03AEF8:        0A            ASL                       
CODE_03AEF9:        0A            ASL                       
CODE_03AEFA:        0A            ASL                       
CODE_03AEFB:        05 00         ORA $00                   
CODE_03AEFD:        85 00         STA $00                   
CODE_03AEFF:        0A            ASL                       
CODE_03AF00:        0A            ASL                       
CODE_03AF01:        0A            ASL                       
CODE_03AF02:        0A            ASL                       
CODE_03AF03:        0A            ASL                       
CODE_03AF04:        05 00         ORA $00                   
CODE_03AF06:        85 00         STA $00                   
CODE_03AF08:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_03AF0A:        DA            PHX                       
CODE_03AF0B:        AA            TAX                       
CODE_03AF0C:        AC 81 06      LDY.W $0681               
CODE_03AF0F:        A9 02         LDA.B #$02                
CODE_03AF11:        99 82 06      STA.W $0682,Y             
CODE_03AF14:        A9 F1         LDA.B #$F1                
CODE_03AF16:        99 83 06      STA.W $0683,Y             
CODE_03AF19:        A5 00         LDA $00                   
CODE_03AF1B:        99 84 06      STA.W $0684,Y             
CODE_03AF1E:        A5 01         LDA $01                   
CODE_03AF20:        99 85 06      STA.W $0685,Y             
CODE_03AF23:        A9 00         LDA.B #$00                
CODE_03AF25:        99 86 06      STA.W $0686,Y             
CODE_03AF28:        98            TYA                       
CODE_03AF29:        18            CLC                       
CODE_03AF2A:        69 04         ADC.B #$04                
CODE_03AF2C:        8D 81 06      STA.W $0681               
CODE_03AF2F:        FA            PLX                       
CODE_03AF30:        20 74 D6      JSR.W CODE_03D674         
Return03AF33:       60            RTS                       ; Return 


DATA_03AF34:                      .db $F4,$FF,$0C,$19,$24,$19,$0C,$FF
DATA_03AF3C:                      .db $FC,$F6,$F4,$F6,$FC,$02,$04,$02
DATA_03AF44:                      .db $05,$05,$05,$05,$45,$45,$45,$45
DATA_03AF4C:                      .db $34,$34,$34,$35,$35,$36,$36,$37
                                  .db $38,$3A,$3E,$46,$54

CODE_03AF59:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_03AF5C:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_03AF5F:        85 04         STA $04                   
CODE_03AF61:        A5 14         LDA RAM_FrameCounterB     
CODE_03AF63:        4A            LSR                       
CODE_03AF64:        4A            LSR                       
CODE_03AF65:        29 07         AND.B #$07                
CODE_03AF67:        85 02         STA $02                   
CODE_03AF69:        A9 EC         LDA.B #$EC                
CODE_03AF6B:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_03AF6E:        A8            TAY                       
CODE_03AF6F:        DA            PHX                       
CODE_03AF70:        A2 03         LDX.B #$03                
CODE_03AF72:        DA            PHX                       
CODE_03AF73:        8A            TXA                       
CODE_03AF74:        0A            ASL                       
CODE_03AF75:        0A            ASL                       
CODE_03AF76:        65 02         ADC $02                   
CODE_03AF78:        29 07         AND.B #$07                
CODE_03AF7A:        AA            TAX                       
CODE_03AF7B:        A5 00         LDA $00                   
CODE_03AF7D:        18            CLC                       
CODE_03AF7E:        7D 34 AF      ADC.W DATA_03AF34,X       
CODE_03AF81:        99 00 03      STA.W OAM_DispX,Y         
CODE_03AF84:        A5 01         LDA $01                   
CODE_03AF86:        18            CLC                       
CODE_03AF87:        7D 3C AF      ADC.W DATA_03AF3C,X       
CODE_03AF8A:        99 01 03      STA.W OAM_DispY,Y         
CODE_03AF8D:        A9 59         LDA.B #$59                
CODE_03AF8F:        99 02 03      STA.W OAM_Tile,Y          
CODE_03AF92:        BD 44 AF      LDA.W DATA_03AF44,X       
CODE_03AF95:        05 64         ORA $64                   
CODE_03AF97:        99 03 03      STA.W OAM_Prop,Y          
CODE_03AF9A:        FA            PLX                       
CODE_03AF9B:        C8            INY                       
CODE_03AF9C:        C8            INY                       
CODE_03AF9D:        C8            INY                       
CODE_03AF9E:        C8            INY                       
CODE_03AF9F:        CA            DEX                       
CODE_03AFA0:        10 D0         BPL CODE_03AF72           
CODE_03AFA2:        AD B3 14      LDA.W $14B3               
CODE_03AFA5:        EE B3 14      INC.W $14B3               
CODE_03AFA8:        4A            LSR                       
CODE_03AFA9:        4A            LSR                       
CODE_03AFAA:        4A            LSR                       
CODE_03AFAB:        C9 0D         CMP.B #$0D                
CODE_03AFAD:        B0 28         BCS CODE_03AFD7           
CODE_03AFAF:        AA            TAX                       
CODE_03AFB0:        A0 FC         LDY.B #$FC                
CODE_03AFB2:        A5 04         LDA $04                   
CODE_03AFB4:        0A            ASL                       
CODE_03AFB5:        2A            ROL                       
CODE_03AFB6:        0A            ASL                       
CODE_03AFB7:        0A            ASL                       
CODE_03AFB8:        0A            ASL                       
CODE_03AFB9:        65 00         ADC $00                   
CODE_03AFBB:        18            CLC                       
CODE_03AFBC:        69 15         ADC.B #$15                
CODE_03AFBE:        99 00 03      STA.W OAM_DispX,Y         
CODE_03AFC1:        A5 01         LDA $01                   
CODE_03AFC3:        18            CLC                       
CODE_03AFC4:        7F 4C AF 03   ADC.L DATA_03AF4C,X       
CODE_03AFC8:        99 01 03      STA.W OAM_DispY,Y         
CODE_03AFCB:        A9 49         LDA.B #$49                
CODE_03AFCD:        99 02 03      STA.W OAM_Tile,Y          
CODE_03AFD0:        A9 07         LDA.B #$07                
CODE_03AFD2:        05 64         ORA $64                   
CODE_03AFD4:        99 03 03      STA.W OAM_Prop,Y          
CODE_03AFD7:        FA            PLX                       
CODE_03AFD8:        A0 00         LDY.B #$00                
CODE_03AFDA:        A9 04         LDA.B #$04                
CODE_03AFDC:        22 B3 B7 01   JSL.L FinishOAMWrite      
CODE_03AFE0:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_03AFE3:        DA            PHX                       
CODE_03AFE4:        A2 04         LDX.B #$04                
CODE_03AFE6:        B9 00 03      LDA.W OAM_DispX,Y         
CODE_03AFE9:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_03AFEC:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_03AFEF:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_03AFF2:        B9 02 03      LDA.W OAM_Tile,Y          
CODE_03AFF5:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_03AFF8:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_03AFFB:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_03AFFE:        5A            PHY                       
CODE_03AFFF:        98            TYA                       
CODE_03B000:        4A            LSR                       
CODE_03B001:        4A            LSR                       
CODE_03B002:        A8            TAY                       
CODE_03B003:        B9 60 04      LDA.W OAM_TileSize,Y      
CODE_03B006:        99 20 04      STA.W $0420,Y             
CODE_03B009:        7A            PLY                       
CODE_03B00A:        C8            INY                       
CODE_03B00B:        C8            INY                       
CODE_03B00C:        C8            INY                       
CODE_03B00D:        C8            INY                       
CODE_03B00E:        CA            DEX                       
CODE_03B00F:        10 D5         BPL CODE_03AFE6           
CODE_03B011:        FA            PLX                       
Return03B012:       60            RTS                       ; Return 


DATA_03B013:                      .db $00,$10

DATA_03B015:                      .db $00,$00

DATA_03B017:                      .db $F8,$08

CODE_03B019:        64 02         STZ $02                   
CODE_03B01B:        20 20 B0      JSR.W CODE_03B020         
CODE_03B01E:        E6 02         INC $02                   
CODE_03B020:        A0 01         LDY.B #$01                
CODE_03B022:        B9 C8 14      LDA.W $14C8,Y             
CODE_03B025:        F0 04         BEQ CODE_03B02B           
CODE_03B027:        88            DEY                       
CODE_03B028:        10 F8         BPL CODE_03B022           
Return03B02A:       60            RTS                       ; Return 

CODE_03B02B:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_03B02D:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_03B030:        A9 A2         LDA.B #$A2                
CODE_03B032:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_03B035:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03B037:        18            CLC                       
CODE_03B038:        69 10         ADC.B #$10                
CODE_03B03A:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_03B03D:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03B040:        69 00         ADC.B #$00                
CODE_03B042:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_03B045:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03B047:        85 00         STA $00                   
CODE_03B049:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03B04C:        85 01         STA $01                   
CODE_03B04E:        DA            PHX                       
CODE_03B04F:        A6 02         LDX $02                   
CODE_03B051:        A5 00         LDA $00                   
CODE_03B053:        18            CLC                       
CODE_03B054:        7D 13 B0      ADC.W DATA_03B013,X       
CODE_03B057:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_03B05A:        A5 01         LDA $01                   
CODE_03B05C:        7D 15 B0      ADC.W DATA_03B015,X       
CODE_03B05F:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_03B062:        BB            TYX                       
CODE_03B063:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_03B067:        A4 02         LDY $02                   
CODE_03B069:        B9 17 B0      LDA.W DATA_03B017,Y       
CODE_03B06C:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03B06E:        A9 C0         LDA.B #$C0                
CODE_03B070:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03B072:        FA            PLX                       
Return03B073:       60            RTS                       ; Return 


DATA_03B074:                      .db $40,$C0

DATA_03B076:                      .db $10,$F0

CODE_03B078:        A5 38         LDA $38                   
CODE_03B07A:        C9 20         CMP.B #$20                
CODE_03B07C:        D0 5D         BNE Return03B0DB          
CODE_03B07E:        BD 1C 15      LDA.W $151C,X             
CODE_03B081:        C9 07         CMP.B #$07                
CODE_03B083:        90 6D         BCC Return03B0F2          
CODE_03B085:        A5 36         LDA $36                   
CODE_03B087:        05 37         ORA $37                   
CODE_03B089:        D0 67         BNE Return03B0F2          
CODE_03B08B:        20 DC B0      JSR.W CODE_03B0DC         
CODE_03B08E:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_03B091:        D0 48         BNE Return03B0DB          
CODE_03B093:        A9 24         LDA.B #$24                
CODE_03B095:        9D 62 16      STA.W RAM_Tweaker1662,X   
CODE_03B098:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_03B09C:        90 1F         BCC CODE_03B0BD           
CODE_03B09E:        20 D6 B0      JSR.W CODE_03B0D6         
CODE_03B0A1:        64 7D         STZ RAM_MarioSpeedY       
CODE_03B0A3:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_03B0A6:        AD B1 14      LDA.W $14B1               
CODE_03B0A9:        0D B6 14      ORA.W $14B6               
CODE_03B0AC:        F0 05         BEQ CODE_03B0B3           
ADDR_03B0AE:        B9 76 B0      LDA.W DATA_03B076,Y       
ADDR_03B0B1:        80 03         BRA CODE_03B0B6           

CODE_03B0B3:        B9 74 B0      LDA.W DATA_03B074,Y       
CODE_03B0B6:        85 7B         STA RAM_MarioSpeedX       
CODE_03B0B8:        A9 01         LDA.B #$01                ; \ Play sound effect 
CODE_03B0BA:        8D F9 1D      STA.W $1DF9               ; / 
CODE_03B0BD:        FE 62 16      INC.W RAM_Tweaker1662,X   
CODE_03B0C0:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_03B0C4:        90 03         BCC CODE_03B0C9           
ADDR_03B0C6:        20 D2 B0      JSR.W CODE_03B0D2         
CODE_03B0C9:        FE 62 16      INC.W RAM_Tweaker1662,X   
CODE_03B0CC:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_03B0D0:        90 09         BCC Return03B0DB          
CODE_03B0D2:        22 B7 F5 00   JSL.L HurtMario           
CODE_03B0D6:        A9 20         LDA.B #$20                
CODE_03B0D8:        9D 4C 15      STA.W RAM_DisableInter,X  
Return03B0DB:       60            RTS                       ; Return 

CODE_03B0DC:        A0 01         LDY.B #$01                
CODE_03B0DE:        5A            PHY                       
CODE_03B0DF:        B9 C8 14      LDA.W $14C8,Y             
CODE_03B0E2:        C9 09         CMP.B #$09                
CODE_03B0E4:        D0 08         BNE CODE_03B0EE           
CODE_03B0E6:        B9 A0 15      LDA.W RAM_OffscreenHorz,Y 
CODE_03B0E9:        D0 03         BNE CODE_03B0EE           
CODE_03B0EB:        20 F3 B0      JSR.W CODE_03B0F3         
CODE_03B0EE:        7A            PLY                       
CODE_03B0EF:        88            DEY                       
CODE_03B0F0:        10 EC         BPL CODE_03B0DE           
Return03B0F2:       60            RTS                       ; Return 

CODE_03B0F3:        DA            PHX                       
CODE_03B0F4:        BB            TYX                       
CODE_03B0F5:        22 E5 B6 03   JSL.L GetSpriteClippingB  
CODE_03B0F9:        FA            PLX                       
CODE_03B0FA:        A9 24         LDA.B #$24                
CODE_03B0FC:        9D 62 16      STA.W RAM_Tweaker1662,X   
CODE_03B0FF:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_03B103:        22 2B B7 03   JSL.L CheckForContact     
CODE_03B107:        B0 39         BCS CODE_03B142           
CODE_03B109:        FE 62 16      INC.W RAM_Tweaker1662,X   
CODE_03B10C:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_03B110:        22 2B B7 03   JSL.L CheckForContact     
CODE_03B114:        90 4A         BCC Return03B160          
CODE_03B116:        AD B5 14      LDA.W $14B5               
CODE_03B119:        D0 45         BNE Return03B160          
CODE_03B11B:        A9 4C         LDA.B #$4C                
CODE_03B11D:        8D B5 14      STA.W $14B5               
CODE_03B120:        9C B3 14      STZ.W $14B3               
CODE_03B123:        BD 1C 15      LDA.W $151C,X             
CODE_03B126:        8D B4 14      STA.W $14B4               
CODE_03B129:        A9 28         LDA.B #$28                ; \ Play sound effect 
CODE_03B12B:        8D FC 1D      STA.W $1DFC               ; / 
CODE_03B12E:        BD 1C 15      LDA.W $151C,X             
CODE_03B131:        C9 09         CMP.B #$09                
CODE_03B133:        D0 0D         BNE CODE_03B142           
CODE_03B135:        BD 7B 18      LDA.W $187B,X             
CODE_03B138:        C9 01         CMP.B #$01                
CODE_03B13A:        D0 06         BNE CODE_03B142           
CODE_03B13C:        5A            PHY                       
CODE_03B13D:        22 C8 A6 03   JSL.L KillMostSprites     
CODE_03B141:        7A            PLY                       
CODE_03B142:        A9 00         LDA.B #$00                
CODE_03B144:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_03B147:        DA            PHX                       
CODE_03B148:        A2 10         LDX.B #$10                
CODE_03B14A:        B9 AA 00      LDA.W RAM_SpriteSpeedY,Y  
CODE_03B14D:        30 02         BMI CODE_03B151           
CODE_03B14F:        A2 D0         LDX.B #$D0                
CODE_03B151:        8A            TXA                       
CODE_03B152:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_03B155:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_03B157:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_03B15A:        BB            TYX                       
CODE_03B15B:        22 6F AB 01   JSL.L CODE_01AB6F         
CODE_03B15F:        FA            PLX                       
Return03B160:       60            RTS                       ; Return 


BowserBallSpeed:                  .db $10,$F0

BowserBowlingBall:  20 21 B2      JSR.W BowserBallGfx       
CODE_03B166:        A5 9D         LDA RAM_SpritesLocked     
CODE_03B168:        D0 6A         BNE Return03B1D4          
CODE_03B16A:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_03B16D:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_03B171:        22 22 80 01   JSL.L UpdateXPosNoGrvty   
CODE_03B175:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_03B179:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03B17B:        C9 40         CMP.B #$40                
CODE_03B17D:        10 07         BPL CODE_03B186           
CODE_03B17F:        18            CLC                       
CODE_03B180:        69 03         ADC.B #$03                
CODE_03B182:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03B184:        80 04         BRA CODE_03B18A           

CODE_03B186:        A9 40         LDA.B #$40                
CODE_03B188:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03B18A:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03B18C:        30 37         BMI CODE_03B1C5           
CODE_03B18E:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03B191:        30 32         BMI CODE_03B1C5           
CODE_03B193:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03B195:        C9 B0         CMP.B #$B0                
CODE_03B197:        90 2C         BCC CODE_03B1C5           
CODE_03B199:        A9 B0         LDA.B #$B0                
CODE_03B19B:        95 D8         STA RAM_SpriteYLo,X       
CODE_03B19D:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03B19F:        C9 3E         CMP.B #$3E                
CODE_03B1A1:        90 0A         BCC CODE_03B1AD           
CODE_03B1A3:        A0 25         LDY.B #$25                ; \ Play sound effect 
CODE_03B1A5:        8C FC 1D      STY.W $1DFC               ; / 
CODE_03B1A8:        A0 20         LDY.B #$20                ; \ Set ground shake timer 
CODE_03B1AA:        8C 87 18      STY.W RAM_ShakeGrndTimer  ; / 
CODE_03B1AD:        C9 08         CMP.B #$08                
CODE_03B1AF:        90 05         BCC CODE_03B1B6           
CODE_03B1B1:        A9 01         LDA.B #$01                ; \ Play sound effect 
CODE_03B1B3:        8D F9 1D      STA.W $1DF9               ; / 
CODE_03B1B6:        20 F8 B7      JSR.W CODE_03B7F8         
CODE_03B1B9:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_03B1BB:        D0 08         BNE CODE_03B1C5           
CODE_03B1BD:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_03B1C0:        B9 61 B1      LDA.W BowserBallSpeed,Y   
CODE_03B1C3:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03B1C5:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_03B1C7:        F0 0B         BEQ Return03B1D4          
CODE_03B1C9:        30 06         BMI CODE_03B1D1           
CODE_03B1CB:        DE 70 15      DEC.W $1570,X             
CODE_03B1CE:        DE 70 15      DEC.W $1570,X             
CODE_03B1D1:        FE 70 15      INC.W $1570,X             
Return03B1D4:       60            RTS                       ; Return 


BowserBallDispX:                  .db $F0,$00,$10,$F0,$00,$10,$F0,$00
                                  .db $10,$00,$00,$F8

BowserBallDispY:                  .db $E2,$E2,$E2,$F2,$F2,$F2,$02,$02
                                  .db $02,$02,$02,$EA

BowserBallTiles:                  .db $45,$47,$45,$65,$66,$65,$45,$47
                                  .db $45,$39,$38,$63

BowserBallGfxProp:                .db $0D,$0D,$4D,$0D,$0D,$4D,$8D,$8D
                                  .db $CD,$0D,$0D,$0D

BowserBallTileSize:               .db $02,$02,$02,$02,$02,$02,$02,$02
                                  .db $02,$00,$00,$02

BowserBallDispX2:                 .db $04,$0D,$10,$0D,$04,$FB,$F8,$FB
BowserBallDispY2:                 .db $00,$FD,$F4,$EB,$E8,$EB,$F4,$FD

BowserBallGfx:      A9 70         LDA.B #$70                
CODE_03B223:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_03B226:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_03B229:        DA            PHX                       
CODE_03B22A:        A2 0B         LDX.B #$0B                
CODE_03B22C:        A5 00         LDA $00                   
CODE_03B22E:        18            CLC                       
CODE_03B22F:        7D D5 B1      ADC.W BowserBallDispX,X   
CODE_03B232:        99 00 03      STA.W OAM_DispX,Y         
CODE_03B235:        A5 01         LDA $01                   
CODE_03B237:        18            CLC                       
CODE_03B238:        7D E1 B1      ADC.W BowserBallDispY,X   
CODE_03B23B:        99 01 03      STA.W OAM_DispY,Y         
CODE_03B23E:        BD ED B1      LDA.W BowserBallTiles,X   
CODE_03B241:        99 02 03      STA.W OAM_Tile,Y          
CODE_03B244:        BD F9 B1      LDA.W BowserBallGfxProp,X 
CODE_03B247:        05 64         ORA $64                   
CODE_03B249:        99 03 03      STA.W OAM_Prop,Y          
CODE_03B24C:        5A            PHY                       
CODE_03B24D:        98            TYA                       
CODE_03B24E:        4A            LSR                       
CODE_03B24F:        4A            LSR                       
CODE_03B250:        A8            TAY                       
CODE_03B251:        BD 05 B2      LDA.W BowserBallTileSize,X 
CODE_03B254:        99 60 04      STA.W OAM_TileSize,Y      
CODE_03B257:        7A            PLY                       
CODE_03B258:        C8            INY                       
CODE_03B259:        C8            INY                       
CODE_03B25A:        C8            INY                       
CODE_03B25B:        C8            INY                       
CODE_03B25C:        CA            DEX                       
CODE_03B25D:        10 CD         BPL CODE_03B22C           
CODE_03B25F:        FA            PLX                       
CODE_03B260:        DA            PHX                       
CODE_03B261:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_03B264:        BD 70 15      LDA.W $1570,X             
CODE_03B267:        4A            LSR                       
CODE_03B268:        4A            LSR                       
CODE_03B269:        4A            LSR                       
CODE_03B26A:        29 07         AND.B #$07                
CODE_03B26C:        48            PHA                       
CODE_03B26D:        AA            TAX                       
CODE_03B26E:        B9 04 03      LDA.W OAM_Tile2DispX,Y    
CODE_03B271:        18            CLC                       
CODE_03B272:        7D 11 B2      ADC.W BowserBallDispX2,X  
CODE_03B275:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_03B278:        B9 05 03      LDA.W OAM_Tile2DispY,Y    
CODE_03B27B:        18            CLC                       
CODE_03B27C:        7D 19 B2      ADC.W BowserBallDispY2,X  
CODE_03B27F:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_03B282:        68            PLA                       
CODE_03B283:        18            CLC                       
CODE_03B284:        69 02         ADC.B #$02                
CODE_03B286:        29 07         AND.B #$07                
CODE_03B288:        AA            TAX                       
CODE_03B289:        B9 08 03      LDA.W OAM_Tile3DispX,Y    
CODE_03B28C:        18            CLC                       
CODE_03B28D:        7D 11 B2      ADC.W BowserBallDispX2,X  
CODE_03B290:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_03B293:        B9 09 03      LDA.W OAM_Tile3DispY,Y    
CODE_03B296:        18            CLC                       
CODE_03B297:        7D 19 B2      ADC.W BowserBallDispY2,X  
CODE_03B29A:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_03B29D:        FA            PLX                       
CODE_03B29E:        A9 0B         LDA.B #$0B                
CODE_03B2A0:        A0 FF         LDY.B #$FF                
CODE_03B2A2:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return03B2A6:       60            RTS                       ; Return 


MechakoopaSpeed:                  .db $08,$F8

MechaKoopa:         22 07 B3 03   JSL.L CODE_03B307         
CODE_03B2AD:        BD C8 14      LDA.W $14C8,X             
CODE_03B2B0:        C9 08         CMP.B #$08                
CODE_03B2B2:        D0 52         BNE Return03B306          
CODE_03B2B4:        A5 9D         LDA RAM_SpritesLocked     
CODE_03B2B6:        D0 4E         BNE Return03B306          
CODE_03B2B8:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_03B2BB:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_03B2BF:        22 2A 80 01   JSL.L UpdateSpritePos     
CODE_03B2C3:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_03B2C6:        29 04         AND.B #$04                ;  | 
CODE_03B2C8:        F0 19         BEQ CODE_03B2E3           ; / 
CODE_03B2CA:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03B2CC:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_03B2CF:        B9 A7 B2      LDA.W MechakoopaSpeed,Y   
CODE_03B2D2:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_03B2D4:        B5 C2         LDA RAM_SpriteState,X     
CODE_03B2D6:        F6 C2         INC RAM_SpriteState,X     
CODE_03B2D8:        29 3F         AND.B #$3F                
CODE_03B2DA:        D0 07         BNE CODE_03B2E3           
CODE_03B2DC:        20 17 B8      JSR.W SubHorzPosBnk3      
CODE_03B2DF:        98            TYA                       
CODE_03B2E0:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_03B2E3:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not touching object 
CODE_03B2E6:        29 03         AND.B #$03                ;  | 
CODE_03B2E8:        F0 0F         BEQ CODE_03B2F9           ; / 
ADDR_03B2EA:        B5 B6         LDA RAM_SpriteSpeedX,X    
ADDR_03B2EC:        49 FF         EOR.B #$FF                
ADDR_03B2EE:        1A            INC A                     
ADDR_03B2EF:        95 B6         STA RAM_SpriteSpeedX,X    
ADDR_03B2F1:        BD 7C 15      LDA.W RAM_SpriteDir,X     
ADDR_03B2F4:        49 01         EOR.B #$01                
ADDR_03B2F6:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_03B2F9:        FE 70 15      INC.W $1570,X             
CODE_03B2FC:        BD 70 15      LDA.W $1570,X             
CODE_03B2FF:        29 0C         AND.B #$0C                
CODE_03B301:        4A            LSR                       
CODE_03B302:        4A            LSR                       
CODE_03B303:        9D 02 16      STA.W $1602,X             
Return03B306:       60            RTS                       ; Return 

CODE_03B307:        8B            PHB                       ; Wrapper 
CODE_03B308:        4B            PHK                       
CODE_03B309:        AB            PLB                       
CODE_03B30A:        20 55 B3      JSR.W MechaKoopaGfx       
CODE_03B30D:        AB            PLB                       
Return03B30E:       6B            RTL                       ; Return 


MechakoopaDispX:                  .db $F8,$08,$F8,$00,$08,$00,$10,$00
MechakoopaDispY:                  .db $F8,$F8,$08,$00,$F9,$F9,$09,$00
                                  .db $F8,$F8,$08,$00,$F9,$F9,$09,$00
                                  .db $FD,$00,$05,$00,$00,$00,$08,$00
MechakoopaTiles:                  .db $40,$42,$60,$51,$40,$42,$60,$0A
                                  .db $40,$42,$60,$0C,$40,$42,$60,$0E
                                  .db $00,$02,$10,$01,$00,$02,$10,$01
MechakoopaGfxProp:                .db $00,$00,$00,$00,$40,$40,$40,$40
MechakoopaTileSize:               .db $02,$00,$00,$02

MechakoopaPalette:                .db $0B,$05

MechaKoopaGfx:      A9 0B         LDA.B #$0B                
CODE_03B357:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_03B35A:        BD 40 15      LDA.W $1540,X             
CODE_03B35D:        F0 20         BEQ CODE_03B37F           
CODE_03B35F:        A0 05         LDY.B #$05                
CODE_03B361:        C9 05         CMP.B #$05                
CODE_03B363:        90 04         BCC CODE_03B369           
CODE_03B365:        C9 FA         CMP.B #$FA                
CODE_03B367:        90 02         BCC CODE_03B36B           
CODE_03B369:        A0 04         LDY.B #$04                
CODE_03B36B:        98            TYA                       
CODE_03B36C:        9D 02 16      STA.W $1602,X             
CODE_03B36F:        BD 40 15      LDA.W $1540,X             
CODE_03B372:        C9 30         CMP.B #$30                
CODE_03B374:        B0 09         BCS CODE_03B37F           
CODE_03B376:        29 01         AND.B #$01                
CODE_03B378:        A8            TAY                       
CODE_03B379:        B9 53 B3      LDA.W MechakoopaPalette,Y 
CODE_03B37C:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_03B37F:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_03B382:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_03B385:        85 04         STA $04                   
CODE_03B387:        98            TYA                       
CODE_03B388:        18            CLC                       
CODE_03B389:        69 0C         ADC.B #$0C                
CODE_03B38B:        A8            TAY                       
CODE_03B38C:        BD 02 16      LDA.W $1602,X             
CODE_03B38F:        0A            ASL                       
CODE_03B390:        0A            ASL                       
CODE_03B391:        85 03         STA $03                   
CODE_03B393:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_03B396:        0A            ASL                       
CODE_03B397:        0A            ASL                       
CODE_03B398:        49 04         EOR.B #$04                
CODE_03B39A:        85 02         STA $02                   
CODE_03B39C:        DA            PHX                       
CODE_03B39D:        A2 03         LDX.B #$03                
CODE_03B39F:        DA            PHX                       
CODE_03B3A0:        5A            PHY                       
CODE_03B3A1:        98            TYA                       
CODE_03B3A2:        4A            LSR                       
CODE_03B3A3:        4A            LSR                       
CODE_03B3A4:        A8            TAY                       
CODE_03B3A5:        BD 4F B3      LDA.W MechakoopaTileSize,X 
CODE_03B3A8:        99 60 04      STA.W OAM_TileSize,Y      
CODE_03B3AB:        7A            PLY                       
CODE_03B3AC:        68            PLA                       
CODE_03B3AD:        48            PHA                       
CODE_03B3AE:        18            CLC                       
CODE_03B3AF:        65 02         ADC $02                   
CODE_03B3B1:        AA            TAX                       
CODE_03B3B2:        A5 00         LDA $00                   
CODE_03B3B4:        18            CLC                       
CODE_03B3B5:        7D 0F B3      ADC.W MechakoopaDispX,X   
CODE_03B3B8:        99 00 03      STA.W OAM_DispX,Y         
CODE_03B3BB:        BD 47 B3      LDA.W MechakoopaGfxProp,X 
CODE_03B3BE:        05 04         ORA $04                   
CODE_03B3C0:        05 64         ORA $64                   
CODE_03B3C2:        99 03 03      STA.W OAM_Prop,Y          
CODE_03B3C5:        68            PLA                       
CODE_03B3C6:        48            PHA                       
CODE_03B3C7:        18            CLC                       
CODE_03B3C8:        65 03         ADC $03                   
CODE_03B3CA:        AA            TAX                       
CODE_03B3CB:        BD 2F B3      LDA.W MechakoopaTiles,X   
CODE_03B3CE:        99 02 03      STA.W OAM_Tile,Y          
CODE_03B3D1:        A5 01         LDA $01                   
CODE_03B3D3:        18            CLC                       
CODE_03B3D4:        7D 17 B3      ADC.W MechakoopaDispY,X   
CODE_03B3D7:        99 01 03      STA.W OAM_DispY,Y         
CODE_03B3DA:        FA            PLX                       
CODE_03B3DB:        88            DEY                       
CODE_03B3DC:        88            DEY                       
CODE_03B3DD:        88            DEY                       
CODE_03B3DE:        88            DEY                       
CODE_03B3DF:        CA            DEX                       
CODE_03B3E0:        10 BD         BPL CODE_03B39F           
CODE_03B3E2:        FA            PLX                       
CODE_03B3E3:        A0 FF         LDY.B #$FF                
CODE_03B3E5:        A9 03         LDA.B #$03                
CODE_03B3E7:        22 B3 B7 01   JSL.L FinishOAMWrite      
CODE_03B3EB:        20 F7 B3      JSR.W MechaKoopaKeyGfx    
Return03B3EE:       60            RTS                       ; Return 


MechaKeyDispX:                    .db $F9,$0F

MechaKeyGfxProp:                  .db $4D,$0D

MechaKeyTiles:                    .db $70,$71,$72,$71

MechaKoopaKeyGfx:   BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_03B3FA:        18            CLC                       
CODE_03B3FB:        69 10         ADC.B #$10                
CODE_03B3FD:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_03B400:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_03B403:        DA            PHX                       
CODE_03B404:        BD 70 15      LDA.W $1570,X             
CODE_03B407:        4A            LSR                       
CODE_03B408:        4A            LSR                       
CODE_03B409:        29 03         AND.B #$03                
CODE_03B40B:        85 02         STA $02                   
CODE_03B40D:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_03B410:        AA            TAX                       
CODE_03B411:        A5 00         LDA $00                   
CODE_03B413:        18            CLC                       
CODE_03B414:        7D EF B3      ADC.W MechaKeyDispX,X     
CODE_03B417:        99 00 03      STA.W OAM_DispX,Y         
CODE_03B41A:        A5 01         LDA $01                   
CODE_03B41C:        38            SEC                       
CODE_03B41D:        E9 00         SBC.B #$00                
CODE_03B41F:        99 01 03      STA.W OAM_DispY,Y         
CODE_03B422:        BD F1 B3      LDA.W MechaKeyGfxProp,X   
CODE_03B425:        05 64         ORA $64                   
CODE_03B427:        99 03 03      STA.W OAM_Prop,Y          
CODE_03B42A:        A6 02         LDX $02                   
CODE_03B42C:        BD F3 B3      LDA.W MechaKeyTiles,X     
CODE_03B42F:        99 02 03      STA.W OAM_Tile,Y          
CODE_03B432:        FA            PLX                       
CODE_03B433:        A0 00         LDY.B #$00                
CODE_03B435:        A9 00         LDA.B #$00                
CODE_03B437:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return03B43B:       60            RTS                       ; Return 

CODE_03B43C:        20 4F B4      JSR.W BowserItemBoxGfx    
CODE_03B43F:        20 AC B4      JSR.W BowserSceneGfx      
Return03B442:       60            RTS                       ; Return 


BowserItemBoxPosX:                .db $70,$80,$70,$80

BowserItemBoxPosY:                .db $07,$07,$17,$17

BowserItemBoxProp:                .db $37,$77,$B7,$F7

BowserItemBoxGfx:   AD 0D 19      LDA.W $190D               
CODE_03B452:        F0 03         BEQ CODE_03B457           
CODE_03B454:        9C C2 0D      STZ.W $0DC2               
CODE_03B457:        AD C2 0D      LDA.W $0DC2               
CODE_03B45A:        F0 2F         BEQ Return03B48B          
CODE_03B45C:        DA            PHX                       
CODE_03B45D:        A2 03         LDX.B #$03                
CODE_03B45F:        A0 04         LDY.B #$04                
CODE_03B461:        BD 43 B4      LDA.W BowserItemBoxPosX,X 
CODE_03B464:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_03B467:        BD 47 B4      LDA.W BowserItemBoxPosY,X 
CODE_03B46A:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_03B46D:        A9 43         LDA.B #$43                
CODE_03B46F:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_03B472:        BD 4B B4      LDA.W BowserItemBoxProp,X 
CODE_03B475:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_03B478:        5A            PHY                       
CODE_03B479:        98            TYA                       
CODE_03B47A:        4A            LSR                       
CODE_03B47B:        4A            LSR                       
CODE_03B47C:        A8            TAY                       
CODE_03B47D:        A9 02         LDA.B #$02                
CODE_03B47F:        99 20 04      STA.W $0420,Y             
CODE_03B482:        7A            PLY                       
CODE_03B483:        C8            INY                       
CODE_03B484:        C8            INY                       
CODE_03B485:        C8            INY                       
CODE_03B486:        C8            INY                       
CODE_03B487:        CA            DEX                       
CODE_03B488:        10 D7         BPL CODE_03B461           
CODE_03B48A:        FA            PLX                       
Return03B48B:       60            RTS                       ; Return 


BowserRoofPosX:                   .db $00,$30,$60,$90,$C0,$F0,$00,$30
                                  .db $40,$50,$60,$90,$A0,$B0,$C0,$F0
BowserRoofPosY:                   .db $B0,$B0,$B0,$B0,$B0,$B0,$D0,$D0
                                  .db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0

BowserSceneGfx:     DA            PHX                       
CODE_03B4AD:        A0 BC         LDY.B #$BC                
CODE_03B4AF:        64 01         STZ $01                   
CODE_03B4B1:        AD 0D 19      LDA.W $190D               
CODE_03B4B4:        85 0F         STA $0F                   
CODE_03B4B6:        C9 01         CMP.B #$01                
CODE_03B4B8:        A2 10         LDX.B #$10                
CODE_03B4BA:        90 03         BCC CODE_03B4BF           
CODE_03B4BC:        A0 90         LDY.B #$90                
CODE_03B4BE:        CA            DEX                       
CODE_03B4BF:        A9 C0         LDA.B #$C0                
CODE_03B4C1:        38            SEC                       
CODE_03B4C2:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_03B4C4:        99 01 03      STA.W OAM_DispY,Y         
CODE_03B4C7:        A5 01         LDA $01                   
CODE_03B4C9:        38            SEC                       
CODE_03B4CA:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_03B4CC:        99 00 03      STA.W OAM_DispX,Y         
CODE_03B4CF:        18            CLC                       
CODE_03B4D0:        69 10         ADC.B #$10                
CODE_03B4D2:        85 01         STA $01                   
CODE_03B4D4:        A9 08         LDA.B #$08                
CODE_03B4D6:        99 02 03      STA.W OAM_Tile,Y          
CODE_03B4D9:        A9 0D         LDA.B #$0D                
CODE_03B4DB:        05 64         ORA $64                   
CODE_03B4DD:        99 03 03      STA.W OAM_Prop,Y          
CODE_03B4E0:        5A            PHY                       
CODE_03B4E1:        98            TYA                       
CODE_03B4E2:        4A            LSR                       
CODE_03B4E3:        4A            LSR                       
CODE_03B4E4:        A8            TAY                       
CODE_03B4E5:        A9 02         LDA.B #$02                
CODE_03B4E7:        99 60 04      STA.W OAM_TileSize,Y      
CODE_03B4EA:        7A            PLY                       
CODE_03B4EB:        C8            INY                       
CODE_03B4EC:        C8            INY                       
CODE_03B4ED:        C8            INY                       
CODE_03B4EE:        C8            INY                       
CODE_03B4EF:        CA            DEX                       
CODE_03B4F0:        10 CD         BPL CODE_03B4BF           
CODE_03B4F2:        A2 0F         LDX.B #$0F                
CODE_03B4F4:        A5 0F         LDA $0F                   
CODE_03B4F6:        D0 3A         BNE CODE_03B532           
CODE_03B4F8:        A0 14         LDY.B #$14                
CODE_03B4FA:        BD 8C B4      LDA.W BowserRoofPosX,X    
CODE_03B4FD:        38            SEC                       
CODE_03B4FE:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_03B500:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_03B503:        BD 9C B4      LDA.W BowserRoofPosY,X    
CODE_03B506:        38            SEC                       
CODE_03B507:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_03B509:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_03B50C:        A9 08         LDA.B #$08                
CODE_03B50E:        E0 06         CPX.B #$06                
CODE_03B510:        B0 02         BCS CODE_03B514           
CODE_03B512:        A9 03         LDA.B #$03                
CODE_03B514:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_03B517:        A9 0D         LDA.B #$0D                
CODE_03B519:        05 64         ORA $64                   
CODE_03B51B:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_03B51E:        5A            PHY                       
CODE_03B51F:        98            TYA                       
CODE_03B520:        4A            LSR                       
CODE_03B521:        4A            LSR                       
CODE_03B522:        A8            TAY                       
CODE_03B523:        A9 02         LDA.B #$02                
CODE_03B525:        99 20 04      STA.W $0420,Y             
CODE_03B528:        7A            PLY                       
CODE_03B529:        C8            INY                       
CODE_03B52A:        C8            INY                       
CODE_03B52B:        C8            INY                       
CODE_03B52C:        C8            INY                       
CODE_03B52D:        CA            DEX                       
CODE_03B52E:        10 CA         BPL CODE_03B4FA           
CODE_03B530:        80 38         BRA CODE_03B56A           

CODE_03B532:        A0 50         LDY.B #$50                
CODE_03B534:        BD 8C B4      LDA.W BowserRoofPosX,X    
CODE_03B537:        38            SEC                       
CODE_03B538:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_03B53A:        99 00 03      STA.W OAM_DispX,Y         
CODE_03B53D:        BD 9C B4      LDA.W BowserRoofPosY,X    
CODE_03B540:        38            SEC                       
CODE_03B541:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_03B543:        99 01 03      STA.W OAM_DispY,Y         
CODE_03B546:        A9 08         LDA.B #$08                
CODE_03B548:        E0 06         CPX.B #$06                
CODE_03B54A:        B0 02         BCS CODE_03B54E           
CODE_03B54C:        A9 03         LDA.B #$03                
CODE_03B54E:        99 02 03      STA.W OAM_Tile,Y          
CODE_03B551:        A9 0D         LDA.B #$0D                
CODE_03B553:        05 64         ORA $64                   
CODE_03B555:        99 03 03      STA.W OAM_Prop,Y          
CODE_03B558:        5A            PHY                       
CODE_03B559:        98            TYA                       
CODE_03B55A:        4A            LSR                       
CODE_03B55B:        4A            LSR                       
CODE_03B55C:        A8            TAY                       
CODE_03B55D:        A9 02         LDA.B #$02                
CODE_03B55F:        99 60 04      STA.W OAM_TileSize,Y      
CODE_03B562:        7A            PLY                       
CODE_03B563:        C8            INY                       
CODE_03B564:        C8            INY                       
CODE_03B565:        C8            INY                       
CODE_03B566:        C8            INY                       
CODE_03B567:        CA            DEX                       
CODE_03B568:        10 CA         BPL CODE_03B534           
CODE_03B56A:        FA            PLX                       
Return03B56B:       60            RTS                       ; Return 


SprClippingDispX:                 .db $02,$02,$10,$14,$00,$00,$01,$08
                                  .db $F8,$FE,$03,$06,$01,$00,$06,$02
                                  .db $00,$E8,$FC,$FC,$04,$00,$FC,$02
                                  .db $02,$02,$02,$02,$00,$02,$E0,$F0
                                  .db $FC,$FC,$00,$F8,$F4,$F2,$00,$FC
                                  .db $F2,$F0,$02,$00,$F8,$04,$02,$02
                                  .db $08,$00,$00,$00,$FC,$03,$08,$00
                                  .db $08,$04,$F8,$00

SprClippingWidth:                 .db $0C,$0C,$10,$08,$30,$50,$0E,$28
                                  .db $20,$14,$01,$03,$0D,$0F,$14,$24
                                  .db $0F,$40,$08,$08,$18,$0F,$18,$0C
                                  .db $0C,$0C,$0C,$0C,$0A,$1C,$30,$30
                                  .db $08,$08,$10,$20,$38,$3C,$20,$18
                                  .db $1C,$20,$0C,$10,$10,$08,$1C,$1C
                                  .db $10,$30,$30,$40,$08,$12,$34,$0F
                                  .db $20,$08,$20,$10

SprClippingDispY:                 .db $03,$03,$FE,$08,$FE,$FE,$02,$08
                                  .db $FE,$08,$07,$06,$FE,$FC,$06,$FE
                                  .db $FE,$E8,$10,$10,$02,$FE,$F4,$08
                                  .db $13,$23,$33,$43,$0A,$FD,$F8,$FC
                                  .db $E8,$10,$00,$E8,$20,$04,$58,$FC
                                  .db $E8,$FC,$F8,$02,$F8,$04,$FE,$FE
                                  .db $F2,$FE,$FE,$FE,$FC,$00,$08,$F8
                                  .db $10,$03,$10,$00

SprClippingHeight:                .db $0A,$15,$12,$08,$0E,$0E,$18,$30
                                  .db $10,$1E,$02,$03,$16,$10,$14,$12
                                  .db $20,$40,$34,$74,$0C,$0E,$18,$45
                                  .db $3A,$2A,$1A,$0A,$30,$1B,$20,$12
                                  .db $18,$18,$10,$20,$38,$14,$08,$18
                                  .db $28,$1B,$13,$4C,$10,$04,$22,$20
                                  .db $1C,$12,$12,$12,$08,$20,$2E,$14
                                  .db $28,$0A,$10,$0D

MairoClipDispY:                   .db $06,$14,$10,$18

MarioClippingHeight:              .db $1A,$0C,$20,$18

GetMarioClipping:   DA            PHX                       
CODE_03B665:        A5 94         LDA RAM_MarioXPos         ; \ 
CODE_03B667:        18            CLC                       ;  | 
CODE_03B668:        69 02         ADC.B #$02                ;  | 
CODE_03B66A:        85 00         STA $00                   ;  | $00 = (Mario X position + #$02) Low byte 
CODE_03B66C:        A5 95         LDA RAM_MarioXPosHi       ;  | 
CODE_03B66E:        69 00         ADC.B #$00                ;  | 
CODE_03B670:        85 08         STA $08                   ; / $08 = (Mario X position + #$02) High byte 
CODE_03B672:        A9 0C         LDA.B #$0C                ; \ $06 = Clipping width X (#$0C) 
CODE_03B674:        85 02         STA $02                   ; / 
CODE_03B676:        A2 00         LDX.B #$00                ; \ If mario small or ducking, X = #$01 
CODE_03B678:        A5 73         LDA RAM_IsDucking         ;  | else, X = #$00 
CODE_03B67A:        D0 04         BNE CODE_03B680           ;  | 
CODE_03B67C:        A5 19         LDA RAM_MarioPowerUp      ;  | 
CODE_03B67E:        D0 01         BNE CODE_03B681           ;  | 
CODE_03B680:        E8            INX                       ; / 
CODE_03B681:        AD 7A 18      LDA.W RAM_OnYoshi         ; \ If on Yoshi, X += #$02 
CODE_03B684:        F0 02         BEQ CODE_03B688           ;  | 
CODE_03B686:        E8            INX                       ;  | 
CODE_03B687:        E8            INX                       ; / 
CODE_03B688:        BF 60 B6 03   LDA.L MarioClippingHeight,X ; \ $03 = Clipping height 
CODE_03B68C:        85 03         STA $03                   ; / 
CODE_03B68E:        A5 96         LDA RAM_MarioYPos         ; \ 
CODE_03B690:        18            CLC                       ;  | 
CODE_03B691:        7F 5C B6 03   ADC.L MairoClipDispY,X    ;  | 
CODE_03B695:        85 01         STA $01                   ;  | $01 = (Mario Y position + displacement) Low byte 
CODE_03B697:        A5 97         LDA RAM_MarioYPosHi       ;  | 
CODE_03B699:        69 00         ADC.B #$00                ;  | 
CODE_03B69B:        85 09         STA $09                   ; / $09 = (Mario Y position + displacement) High byte 
CODE_03B69D:        FA            PLX                       
Return03B69E:       6B            RTL                       ; Return 

GetSpriteClippingA: 5A            PHY                       
CODE_03B6A0:        DA            PHX                       
CODE_03B6A1:        9B            TXY                       ; Y = Sprite index 
CODE_03B6A2:        BD 62 16      LDA.W RAM_Tweaker1662,X   ; \ X = Clipping table index 
CODE_03B6A5:        29 3F         AND.B #$3F                ;  | 
CODE_03B6A7:        AA            TAX                       ; / 
CODE_03B6A8:        64 0F         STZ $0F                   ; \ 
CODE_03B6AA:        BF 6C B5 03   LDA.L SprClippingDispX,X  ;  | Load low byte of X displacement 
CODE_03B6AE:        10 02         BPL CODE_03B6B2           ;  | 
CODE_03B6B0:        C6 0F         DEC $0F                   ;  | $0F = High byte of X displacement 
CODE_03B6B2:        18            CLC                       ;  | 
CODE_03B6B3:        79 E4 00      ADC.W RAM_SpriteXLo,Y     ;  | 
CODE_03B6B6:        85 04         STA $04                   ;  | $04 = (Sprite X position + displacement) Low byte 
CODE_03B6B8:        B9 E0 14      LDA.W RAM_SpriteXHi,Y     ;  | 
CODE_03B6BB:        65 0F         ADC $0F                   ;  | 
CODE_03B6BD:        85 0A         STA $0A                   ; / $0A = (Sprite X position + displacement) High byte 
CODE_03B6BF:        BF A8 B5 03   LDA.L SprClippingWidth,X  ; \ $06 = Clipping width 
CODE_03B6C3:        85 06         STA $06                   ; / 
CODE_03B6C5:        64 0F         STZ $0F                   ; \ 
CODE_03B6C7:        BF E4 B5 03   LDA.L SprClippingDispY,X  ;  | Load low byte of Y displacement 
CODE_03B6CB:        10 02         BPL CODE_03B6CF           ;  | 
CODE_03B6CD:        C6 0F         DEC $0F                   ;  | $0F = High byte of Y displacement 
CODE_03B6CF:        18            CLC                       ;  | 
CODE_03B6D0:        79 D8 00      ADC.W RAM_SpriteYLo,Y     ;  | 
CODE_03B6D3:        85 05         STA $05                   ;  | $05 = (Sprite Y position + displacement) Low byte 
CODE_03B6D5:        B9 D4 14      LDA.W RAM_SpriteYHi,Y     ;  | 
CODE_03B6D8:        65 0F         ADC $0F                   ;  | 
CODE_03B6DA:        85 0B         STA $0B                   ; / $0B = (Sprite Y position + displacement) High byte 
CODE_03B6DC:        BF 20 B6 03   LDA.L SprClippingHeight,X ; \ $07 = Clipping height 
CODE_03B6E0:        85 07         STA $07                   ; / 
CODE_03B6E2:        FA            PLX                       ; X = Sprite index 
CODE_03B6E3:        7A            PLY                       
Return03B6E4:       6B            RTL                       ; Return 

GetSpriteClippingB: 5A            PHY                       
CODE_03B6E6:        DA            PHX                       
CODE_03B6E7:        9B            TXY                       ; Y = Sprite index 
CODE_03B6E8:        BD 62 16      LDA.W RAM_Tweaker1662,X   ; \ X = Clipping table index 
CODE_03B6EB:        29 3F         AND.B #$3F                ;  | 
CODE_03B6ED:        AA            TAX                       ; / 
CODE_03B6EE:        64 0F         STZ $0F                   ; \ 
CODE_03B6F0:        BF 6C B5 03   LDA.L SprClippingDispX,X  ;  | Load low byte of X displacement 
CODE_03B6F4:        10 02         BPL CODE_03B6F8           ;  | 
CODE_03B6F6:        C6 0F         DEC $0F                   ;  | $0F = High byte of X displacement 
CODE_03B6F8:        18            CLC                       ;  | 
CODE_03B6F9:        79 E4 00      ADC.W RAM_SpriteXLo,Y     ;  | 
CODE_03B6FC:        85 00         STA $00                   ;  | $00 = (Sprite X position + displacement) Low byte 
CODE_03B6FE:        B9 E0 14      LDA.W RAM_SpriteXHi,Y     ;  | 
CODE_03B701:        65 0F         ADC $0F                   ;  | 
CODE_03B703:        85 08         STA $08                   ; / $08 = (Sprite X position + displacement) High byte 
CODE_03B705:        BF A8 B5 03   LDA.L SprClippingWidth,X  ; \ $02 = Clipping width 
CODE_03B709:        85 02         STA $02                   ; / 
CODE_03B70B:        64 0F         STZ $0F                   ; \ 
CODE_03B70D:        BF E4 B5 03   LDA.L SprClippingDispY,X  ;  | Load low byte of Y displacement 
CODE_03B711:        10 02         BPL CODE_03B715           ;  | 
CODE_03B713:        C6 0F         DEC $0F                   ;  | $0F = High byte of Y displacement 
CODE_03B715:        18            CLC                       ;  | 
CODE_03B716:        79 D8 00      ADC.W RAM_SpriteYLo,Y     ;  | 
CODE_03B719:        85 01         STA $01                   ;  | $01 = (Sprite Y position + displacement) Low byte 
CODE_03B71B:        B9 D4 14      LDA.W RAM_SpriteYHi,Y     ;  | 
CODE_03B71E:        65 0F         ADC $0F                   ;  | 
CODE_03B720:        85 09         STA $09                   ; / $09 = (Sprite Y position + displacement) High byte 
CODE_03B722:        BF 20 B6 03   LDA.L SprClippingHeight,X ; \ $03 = Clipping height 
CODE_03B726:        85 03         STA $03                   ; / 
CODE_03B728:        FA            PLX                       ; X = Sprite index 
CODE_03B729:        7A            PLY                       
Return03B72A:       6B            RTL                       ; Return 

CheckForContact:    DA            PHX                       
CODE_03B72C:        A2 01         LDX.B #$01                
CODE_03B72E:        B5 00         LDA $00,X                 
CODE_03B730:        38            SEC                       
CODE_03B731:        F5 04         SBC $04,X                 
CODE_03B733:        48            PHA                       
CODE_03B734:        B5 08         LDA $08,X                 
CODE_03B736:        F5 0A         SBC $0A,X                 
CODE_03B738:        85 0C         STA $0C                   
CODE_03B73A:        68            PLA                       
CODE_03B73B:        18            CLC                       
CODE_03B73C:        69 80         ADC.B #$80                
CODE_03B73E:        A5 0C         LDA $0C                   
CODE_03B740:        69 00         ADC.B #$00                
CODE_03B742:        D0 16         BNE CODE_03B75A           
CODE_03B744:        B5 04         LDA $04,X                 
CODE_03B746:        38            SEC                       
CODE_03B747:        F5 00         SBC $00,X                 
CODE_03B749:        18            CLC                       
CODE_03B74A:        75 06         ADC $06,X                 
CODE_03B74C:        85 0F         STA $0F                   
CODE_03B74E:        B5 02         LDA $02,X                 
CODE_03B750:        18            CLC                       
CODE_03B751:        75 06         ADC $06,X                 
CODE_03B753:        C5 0F         CMP $0F                   
CODE_03B755:        90 03         BCC CODE_03B75A           
CODE_03B757:        CA            DEX                       
CODE_03B758:        10 D4         BPL CODE_03B72E           
CODE_03B75A:        FA            PLX                       
Return03B75B:       6B            RTL                       ; Return 


DATA_03B75C:                      .db $0C,$1C

DATA_03B75E:                      .db $01,$02

GetDrawInfoBnk3:    9E 6C 18      STZ.W RAM_OffscreenVert,X ; Reset sprite offscreen flag, vertical 
CODE_03B763:        9E A0 15      STZ.W RAM_OffscreenHorz,X ; Reset sprite offscreen flag, horizontal 
CODE_03B766:        B5 E4         LDA RAM_SpriteXLo,X       ; \ 
CODE_03B768:        C5 1A         CMP RAM_ScreenBndryXLo    ;  | Set horizontal offscreen if necessary 
CODE_03B76A:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_03B76D:        E5 1B         SBC RAM_ScreenBndryXHi    ;  | 
CODE_03B76F:        F0 03         BEQ CODE_03B774           ;  | 
CODE_03B771:        FE A0 15      INC.W RAM_OffscreenHorz,X ; / 
CODE_03B774:        BD E0 14      LDA.W RAM_SpriteXHi,X     ; \ 
CODE_03B777:        EB            XBA                       ;  | Mark sprite invalid if far enough off screen 
CODE_03B778:        B5 E4         LDA RAM_SpriteXLo,X       ;  | 
CODE_03B77A:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03B77C:        38            SEC                       ;  | 
CODE_03B77D:        E5 1A         SBC RAM_ScreenBndryXLo    ;  | 
CODE_03B77F:        18            CLC                       ;  | 
CODE_03B780:        69 40 00      ADC.W #$0040              ;  | 
CODE_03B783:        C9 80 01      CMP.W #$0180              ;  | 
CODE_03B786:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_03B788:        2A            ROL                       ;  | 
CODE_03B789:        29 01         AND.B #$01                ;  | 
CODE_03B78B:        9D C4 15      STA.W $15C4,X             ;  | 
CODE_03B78E:        D0 3F         BNE CODE_03B7CF           ; /  
CODE_03B790:        A0 00         LDY.B #$00                ; \ set up loop: 
CODE_03B792:        BD 62 16      LDA.W RAM_Tweaker1662,X   ;  |  
CODE_03B795:        29 20         AND.B #$20                ;  | if not smushed (1662 & 0x20), go through loop twice 
CODE_03B797:        F0 01         BEQ CODE_03B79A           ;  | else, go through loop once 
CODE_03B799:        C8            INY                       ; /                        
CODE_03B79A:        B5 D8         LDA RAM_SpriteYLo,X       ; \                        
CODE_03B79C:        18            CLC                       ;  | set vertical offscree 
CODE_03B79D:        79 5C B7      ADC.W DATA_03B75C,Y       ;  |                       
CODE_03B7A0:        08            PHP                       ;  |                       
CODE_03B7A1:        C5 1C         CMP RAM_ScreenBndryYLo    ;  | (vert screen boundry) 
CODE_03B7A3:        26 00         ROL $00                   ;  |                       
CODE_03B7A5:        28            PLP                       ;  |                       
CODE_03B7A6:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  |                       
CODE_03B7A9:        69 00         ADC.B #$00                ;  |                       
CODE_03B7AB:        46 00         LSR $00                   ;  |                       
CODE_03B7AD:        E5 1D         SBC RAM_ScreenBndryYHi    ;  |                       
CODE_03B7AF:        F0 09         BEQ CODE_03B7BA           ;  |                       
CODE_03B7B1:        BD 6C 18      LDA.W RAM_OffscreenVert,X ;  | (vert offscreen)      
CODE_03B7B4:        19 5E B7      ORA.W DATA_03B75E,Y       ;  |                       
CODE_03B7B7:        9D 6C 18      STA.W RAM_OffscreenVert,X ;  |                       
CODE_03B7BA:        88            DEY                       ;  |                       
CODE_03B7BB:        10 DD         BPL CODE_03B79A           ; /                        
CODE_03B7BD:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; get offset to sprite OAM                           
CODE_03B7C0:        B5 E4         LDA RAM_SpriteXLo,X       ; \ 
CODE_03B7C2:        38            SEC                       ;  |                                                     
CODE_03B7C3:        E5 1A         SBC RAM_ScreenBndryXLo    ;  |                                                    
CODE_03B7C5:        85 00         STA $00                   ; / $00 = sprite x position relative to screen boarder 
CODE_03B7C7:        B5 D8         LDA RAM_SpriteYLo,X       ; \                                                     
CODE_03B7C9:        38            SEC                       ;  |                                                     
CODE_03B7CA:        E5 1C         SBC RAM_ScreenBndryYLo    ;  |                                                    
CODE_03B7CC:        85 01         STA $01                   ; / $01 = sprite y position relative to screen boarder 
Return03B7CE:       60            RTS                       ; Return 

CODE_03B7CF:        68            PLA                       ; \ Return from *main gfx routine* subroutine... 
CODE_03B7D0:        68            PLA                       ;  |    ...(not just this subroutine) 
Return03B7D1:       60            RTS                       ; / 


DATA_03B7D2:                      .db $00,$00,$00,$F8,$F8,$F8,$F8,$F8
                                  .db $F8,$F7,$F6,$F5,$F4,$F3,$F2,$E8
                                  .db $E8,$E8,$E8,$00,$00,$00,$00,$FE
                                  .db $FC,$F8,$EC,$EC,$EC,$E8,$E4,$E0
                                  .db $DC,$D8,$D4,$D0,$CC,$C8

CODE_03B7F8:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03B7FA:        48            PHA                       
CODE_03B7FB:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03B7FD:        68            PLA                       
CODE_03B7FE:        4A            LSR                       
CODE_03B7FF:        4A            LSR                       
CODE_03B800:        A8            TAY                       
CODE_03B801:        B5 9E         LDA RAM_SpriteNum,X       
CODE_03B803:        C9 A1         CMP.B #$A1                
CODE_03B805:        D0 05         BNE CODE_03B80C           
CODE_03B807:        98            TYA                       
CODE_03B808:        18            CLC                       
CODE_03B809:        69 13         ADC.B #$13                
CODE_03B80B:        A8            TAY                       
CODE_03B80C:        B9 D2 B7      LDA.W DATA_03B7D2,Y       
CODE_03B80F:        BC 88 15      LDY.W RAM_SprObjStatus,X  
CODE_03B812:        30 02         BMI Return03B816          
CODE_03B814:        95 AA         STA RAM_SpriteSpeedY,X    
Return03B816:       60            RTS                       ; Return 

SubHorzPosBnk3:     A0 00         LDY.B #$00                
CODE_03B819:        A5 94         LDA RAM_MarioXPos         
CODE_03B81B:        38            SEC                       
CODE_03B81C:        F5 E4         SBC RAM_SpriteXLo,X       
CODE_03B81E:        85 0F         STA $0F                   
CODE_03B820:        A5 95         LDA RAM_MarioXPosHi       
CODE_03B822:        FD E0 14      SBC.W RAM_SpriteXHi,X     
CODE_03B825:        10 01         BPL Return03B828          
CODE_03B827:        C8            INY                       
Return03B828:       60            RTS                       ; Return 

SubVertPosBnk3:     A0 00         LDY.B #$00                
CODE_03B82B:        A5 96         LDA RAM_MarioYPos         
CODE_03B82D:        38            SEC                       
CODE_03B82E:        F5 D8         SBC RAM_SpriteYLo,X       
CODE_03B830:        85 0F         STA $0F                   
CODE_03B832:        A5 97         LDA RAM_MarioYPosHi       
CODE_03B834:        FD D4 14      SBC.W RAM_SpriteYHi,X     
CODE_03B837:        10 01         BPL Return03B83A          
CODE_03B839:        C8            INY                       
Return03B83A:       60            RTS                       ; Return 


DATA_03B83B:                      .db $40,$B0

DATA_03B83D:                      .db $01,$FF

DATA_03B83F:                      .db $30,$C0,$A0,$80,$A0,$40,$60,$B0
DATA_03B847:                      .db $01,$FF,$01,$FF,$01,$00,$01,$FF

SubOffscreen3Bnk3:  A9 06         LDA.B #$06                ; \ Entry point of routine determines value of $03 
CODE_03B851:        80 06         BRA CODE_03B859           ;  | 

SubOffscreen2Bnk3:  A9 04         LDA.B #$04                ;  | 
ADDR_03B855:        80 02         BRA CODE_03B859           ;  | 

SubOffscreen1Bnk3:  A9 02         LDA.B #$02                ;  | 
CODE_03B859:        85 03         STA $03                   ;  | 
CODE_03B85B:        80 02         BRA CODE_03B85F           ;  | 

SubOffscreen0Bnk3:  64 03         STZ $03                   ; / 
CODE_03B85F:        20 FB B8      JSR.W IsSprOffScreenBnk3  ; \ if sprite is not off screen, return 
CODE_03B862:        F0 5E         BEQ Return03B8C2          ; / 
CODE_03B864:        A5 5B         LDA RAM_IsVerticalLvl     ; \  vertical level 
CODE_03B866:        29 01         AND.B #$01                ;  | 
CODE_03B868:        D0 59         BNE VerticalLevelBnk3     ; / 
CODE_03B86A:        B5 D8         LDA RAM_SpriteYLo,X       ; \ 
CODE_03B86C:        18            CLC                       ;  | 
CODE_03B86D:        69 50         ADC.B #$50                ;  | if the sprite has gone off the bottom of the level... 
CODE_03B86F:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | (if adding 0x50 to the sprite y position would make the high byte >= 2) 
CODE_03B872:        69 00         ADC.B #$00                ;  | 
CODE_03B874:        C9 02         CMP.B #$02                ;  | 
CODE_03B876:        10 34         BPL OffScrEraseSprBnk3    ; /    ...erase the sprite 
CODE_03B878:        BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ if "process offscreen" flag is set, return 
CODE_03B87B:        29 04         AND.B #$04                ;  | 
CODE_03B87D:        D0 43         BNE Return03B8C2          ; / 
CODE_03B87F:        A5 13         LDA RAM_FrameCounter      
CODE_03B881:        29 01         AND.B #$01                
CODE_03B883:        05 03         ORA $03                   
CODE_03B885:        85 01         STA $01                   
CODE_03B887:        A8            TAY                       
CODE_03B888:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_03B88A:        18            CLC                       
CODE_03B88B:        79 3F B8      ADC.W DATA_03B83F,Y       
CODE_03B88E:        26 00         ROL $00                   
CODE_03B890:        D5 E4         CMP RAM_SpriteXLo,X       
CODE_03B892:        08            PHP                       
CODE_03B893:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_03B895:        46 00         LSR $00                   
CODE_03B897:        79 47 B8      ADC.W DATA_03B847,Y       
CODE_03B89A:        28            PLP                       
CODE_03B89B:        FD E0 14      SBC.W RAM_SpriteXHi,X     
CODE_03B89E:        85 00         STA $00                   
CODE_03B8A0:        46 01         LSR $01                   
CODE_03B8A2:        90 04         BCC CODE_03B8A8           
CODE_03B8A4:        49 80         EOR.B #$80                
CODE_03B8A6:        85 00         STA $00                   
CODE_03B8A8:        A5 00         LDA $00                   
CODE_03B8AA:        10 16         BPL Return03B8C2          
OffScrEraseSprBnk3: BD C8 14      LDA.W $14C8,X             ; \ If sprite status < 8, permanently erase sprite 
CODE_03B8AF:        C9 08         CMP.B #$08                ;  | 
CODE_03B8B1:        90 0C         BCC OffScrKillSprBnk3     ; / 
CODE_03B8B3:        BC 1A 16      LDY.W RAM_SprIndexInLvl,X ; \ Branch if should permanently erase sprite 
CODE_03B8B6:        C0 FF         CPY.B #$FF                ;  | 
CODE_03B8B8:        F0 05         BEQ OffScrKillSprBnk3     ; / 
CODE_03B8BA:        A9 00         LDA.B #$00                ; \ Allow sprite to be reloaded by level loading routine 
CODE_03B8BC:        99 38 19      STA.W RAM_SprLoadStatus,Y ; / 
OffScrKillSprBnk3:  9E C8 14      STZ.W $14C8,X             
Return03B8C2:       60            RTS                       ; Return 

VerticalLevelBnk3:  BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ If "process offscreen" flag is set, return 
CODE_03B8C6:        29 04         AND.B #$04                ;  | 
CODE_03B8C8:        D0 F8         BNE Return03B8C2          ; / 
CODE_03B8CA:        A5 13         LDA RAM_FrameCounter      ; \ Return every other frame 
CODE_03B8CC:        4A            LSR                       ;  | 
CODE_03B8CD:        B0 F3         BCS Return03B8C2          ; / 
CODE_03B8CF:        29 01         AND.B #$01                
CODE_03B8D1:        85 01         STA $01                   
CODE_03B8D3:        A8            TAY                       
CODE_03B8D4:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_03B8D6:        18            CLC                       
CODE_03B8D7:        79 3B B8      ADC.W DATA_03B83B,Y       
CODE_03B8DA:        26 00         ROL $00                   
CODE_03B8DC:        D5 D8         CMP RAM_SpriteYLo,X       
CODE_03B8DE:        08            PHP                       
CODE_03B8DF:        AD 1D 00      LDA.W RAM_ScreenBndryYHi  
CODE_03B8E2:        46 00         LSR $00                   
CODE_03B8E4:        79 3D B8      ADC.W DATA_03B83D,Y       
CODE_03B8E7:        28            PLP                       
CODE_03B8E8:        FD D4 14      SBC.W RAM_SpriteYHi,X     
CODE_03B8EB:        85 00         STA $00                   
CODE_03B8ED:        A4 01         LDY $01                   
CODE_03B8EF:        F0 04         BEQ CODE_03B8F5           
CODE_03B8F1:        49 80         EOR.B #$80                
CODE_03B8F3:        85 00         STA $00                   
CODE_03B8F5:        A5 00         LDA $00                   
CODE_03B8F7:        10 C9         BPL Return03B8C2          
CODE_03B8F9:        30 B1         BMI OffScrEraseSprBnk3    
IsSprOffScreenBnk3: BD A0 15      LDA.W RAM_OffscreenHorz,X ; \ If sprite is on screen, A = 0  
CODE_03B8FE:        1D 6C 18      ORA.W RAM_OffscreenVert,X ;  | 
Return03B901:       60            RTS                       ; / Return 


MagiKoopaPals:                    .db $FF,$7F,$4A,$29,$00,$00,$00,$14
                                  .db $00,$20,$92,$7E,$0A,$00,$2A,$00
                                  .db $FF,$7F,$AD,$35,$00,$00,$00,$24
                                  .db $00,$2C,$2F,$72,$0D,$00,$AD,$00
                                  .db $FF,$7F,$10,$42,$00,$00,$00,$30
                                  .db $00,$38,$CC,$65,$50,$00,$10,$01
                                  .db $FF,$7F,$73,$4E,$00,$00,$00,$3C
                                  .db $41,$44,$69,$59,$B3,$00,$73,$01
                                  .db $FF,$7F,$D6,$5A,$00,$00,$00,$48
                                  .db $A4,$50,$06,$4D,$16,$01,$D6,$01
                                  .db $FF,$7F,$39,$67,$00,$00,$42,$54
                                  .db $07,$5D,$A3,$40,$79,$01,$39,$02
                                  .db $FF,$7F,$9C,$73,$00,$00,$A5,$60
                                  .db $6A,$69,$40,$34,$DC,$01,$9C,$02
                                  .db $FF,$7F,$FF,$7F,$00,$00,$08,$6D
                                  .db $CD,$75,$00,$28,$3F,$02,$FF,$02
BooBossPals:                      .db $FF,$7F,$63,$0C,$00,$00,$00,$0C
                                  .db $00,$0C,$00,$0C,$00,$0C,$03,$00
                                  .db $FF,$7F,$E7,$1C,$00,$00,$00,$1C
                                  .db $00,$1C,$20,$1C,$81,$1C,$07,$00
                                  .db $FF,$7F,$6B,$2D,$00,$00,$00,$2C
                                  .db $40,$2C,$A2,$2C,$05,$2D,$0B,$00
                                  .db $FF,$7F,$EF,$3D,$00,$00,$60,$3C
                                  .db $C3,$3C,$26,$3D,$89,$3D,$0F,$00
                                  .db $FF,$7F,$73,$4E,$00,$00,$E4,$4C
                                  .db $47,$4D,$AA,$4D,$0D,$4E,$13,$10
                                  .db $FF,$7F,$F7,$5E,$00,$00,$68,$5D
                                  .db $CB,$5D,$2E,$5E,$91,$5E,$17,$20
                                  .db $FF,$7F,$7B,$6F,$00,$00,$EC,$6D
                                  .db $4F,$6E,$B2,$6E,$15,$6F,$1B,$30
                                  .db $FF,$7F,$FF,$7F,$00,$00,$70,$7E
                                  .db $D3,$7E,$36,$7F,$99,$7F,$1F,$40
DATA_03BA02:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF

GenTileFromSpr2:    85 9C         STA RAM_BlockBlock        ; $9C = tile to generate 
CODE_03C002:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $9A = Sprite X position + #$08 
CODE_03C004:        38            SEC                       ;  | for block creation 
CODE_03C005:        E9 08         SBC.B #$08                ;  | 
CODE_03C007:        85 9A         STA RAM_BlockYLo          ;  | 
CODE_03C009:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_03C00C:        E9 00         SBC.B #$00                ;  | 
CODE_03C00E:        85 9B         STA RAM_BlockYHi          ; / 
CODE_03C010:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $98 = Sprite Y position + #$08 
CODE_03C012:        18            CLC                       ;  | for block creation 
CODE_03C013:        69 08         ADC.B #$08                ;  | 
CODE_03C015:        85 98         STA RAM_BlockXLo          ;  | 
CODE_03C017:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_03C01A:        69 00         ADC.B #$00                ;  | 
CODE_03C01C:        85 99         STA RAM_BlockXHi          ; / 
CODE_03C01E:        22 B0 BE 00   JSL.L GenerateTile        ; Generate the tile 
Return03C022:       6B            RTL                       ; Return 

CODE_03C023:        8B            PHB                       ; Wrapper 
CODE_03C024:        4B            PHK                       
CODE_03C025:        AB            PLB                       
CODE_03C026:        20 2F C0      JSR.W CODE_03C02F         
CODE_03C029:        AB            PLB                       
Return03C02A:       6B            RTL                       ; Return 


DATA_03C02B:                      .db $74,$75,$77,$76

CODE_03C02F:        BC 0E 16      LDY.W $160E,X             
CODE_03C032:        A9 00         LDA.B #$00                
CODE_03C034:        99 C8 14      STA.W $14C8,Y             
CODE_03C037:        A9 06         LDA.B #$06                ; \ Play sound effect 
CODE_03C039:        8D F9 1D      STA.W $1DF9               ; / 
CODE_03C03C:        B9 0E 16      LDA.W $160E,Y             
CODE_03C03F:        D0 5A         BNE CODE_03C09B           
CODE_03C041:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_03C044:        C9 81         CMP.B #$81                
CODE_03C046:        D0 0C         BNE CODE_03C054           
ADDR_03C048:        A5 14         LDA RAM_FrameCounterB     
ADDR_03C04A:        4A            LSR                       
ADDR_03C04B:        4A            LSR                       
ADDR_03C04C:        4A            LSR                       
ADDR_03C04D:        4A            LSR                       
ADDR_03C04E:        29 03         AND.B #$03                
ADDR_03C050:        A8            TAY                       
ADDR_03C051:        B9 2B C0      LDA.W DATA_03C02B,Y       
CODE_03C054:        C9 74         CMP.B #$74                
CODE_03C056:        90 43         BCC CODE_03C09B           
ADDR_03C058:        C9 78         CMP.B #$78                
ADDR_03C05A:        B0 3F         BCS CODE_03C09B           
ADDR_03C05C:        9C AC 18      STZ.W $18AC               
ADDR_03C05F:        9C 1E 14      STZ.W RAM_YoshiHasWings   ; No Yoshi wing ability 
ADDR_03C062:        A9 35         LDA.B #$35                
ADDR_03C064:        9D 9E 00      STA.W RAM_SpriteNum,X     
ADDR_03C067:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
ADDR_03C069:        9D C8 14      STA.W $14C8,X             ; / 
ADDR_03C06C:        A9 1F         LDA.B #$1F                ; \ Play sound effect 
ADDR_03C06E:        8D FC 1D      STA.W $1DFC               ; / 
ADDR_03C071:        B5 D8         LDA RAM_SpriteYLo,X       
ADDR_03C073:        E9 10         SBC.B #$10                
ADDR_03C075:        95 D8         STA RAM_SpriteYLo,X       
ADDR_03C077:        BD D4 14      LDA.W RAM_SpriteYHi,X     
ADDR_03C07A:        E9 00         SBC.B #$00                
ADDR_03C07C:        9D D4 14      STA.W RAM_SpriteYHi,X     
ADDR_03C07F:        BD F6 15      LDA.W RAM_SpritePal,X     
ADDR_03C082:        48            PHA                       
ADDR_03C083:        22 D2 F7 07   JSL.L InitSpriteTables    
ADDR_03C087:        68            PLA                       
ADDR_03C088:        29 FE         AND.B #$FE                
ADDR_03C08A:        9D F6 15      STA.W RAM_SpritePal,X     
ADDR_03C08D:        A9 0C         LDA.B #$0C                
ADDR_03C08F:        9D 02 16      STA.W $1602,X             
ADDR_03C092:        DE 0E 16      DEC.W $160E,X             
ADDR_03C095:        A9 40         LDA.B #$40                
ADDR_03C097:        8D E8 18      STA.W $18E8               
Return03C09A:       60            RTS                       ; Return 

CODE_03C09B:        FE 70 15      INC.W $1570,X             
CODE_03C09E:        BD 70 15      LDA.W $1570,X             
CODE_03C0A1:        C9 05         CMP.B #$05                
CODE_03C0A3:        D0 02         BNE CODE_03C0A7           
ADDR_03C0A5:        80 B5         BRA ADDR_03C05C           

CODE_03C0A7:        22 4A B3 05   JSL.L CODE_05B34A         
CODE_03C0AB:        A9 01         LDA.B #$01                
CODE_03C0AD:        22 E5 AC 02   JSL.L GivePoints          
Return03C0B1:       60            RTS                       ; Return 


DATA_03C0B2:                      .db $68,$6A,$6C,$6E

DATA_03C0B6:                      .db $00,$03,$01,$02,$04,$02,$00,$01
                                  .db $00,$04,$00,$02,$00,$03,$04,$01

CODE_03C0C6:        A5 9D         LDA RAM_SpritesLocked     
CODE_03C0C8:        D0 03         BNE CODE_03C0CD           
CODE_03C0CA:        20 1E C1      JSR.W CODE_03C11E         
CODE_03C0CD:        64 00         STZ $00                   
CODE_03C0CF:        A2 13         LDX.B #$13                
CODE_03C0D1:        A0 B0         LDY.B #$B0                
CODE_03C0D3:        86 02         STX $02                   
CODE_03C0D5:        A5 00         LDA $00                   
CODE_03C0D7:        99 00 03      STA.W OAM_DispX,Y         
CODE_03C0DA:        18            CLC                       
CODE_03C0DB:        69 10         ADC.B #$10                
CODE_03C0DD:        85 00         STA $00                   
CODE_03C0DF:        A9 C4         LDA.B #$C4                
CODE_03C0E1:        99 01 03      STA.W OAM_DispY,Y         
CODE_03C0E4:        A5 64         LDA $64                   
CODE_03C0E6:        09 09         ORA.B #$09                
CODE_03C0E8:        99 03 03      STA.W OAM_Prop,Y          
CODE_03C0EB:        DA            PHX                       
CODE_03C0EC:        A5 14         LDA RAM_FrameCounterB     
CODE_03C0EE:        4A            LSR                       
CODE_03C0EF:        4A            LSR                       
CODE_03C0F0:        4A            LSR                       
CODE_03C0F1:        18            CLC                       
CODE_03C0F2:        7F B6 C0 03   ADC.L DATA_03C0B6,X       
CODE_03C0F6:        29 03         AND.B #$03                
CODE_03C0F8:        AA            TAX                       
CODE_03C0F9:        BF B2 C0 03   LDA.L DATA_03C0B2,X       
CODE_03C0FD:        99 02 03      STA.W OAM_Tile,Y          
CODE_03C100:        98            TYA                       
CODE_03C101:        4A            LSR                       
CODE_03C102:        4A            LSR                       
CODE_03C103:        AA            TAX                       
CODE_03C104:        A9 02         LDA.B #$02                
CODE_03C106:        9D 60 04      STA.W OAM_TileSize,X      
CODE_03C109:        FA            PLX                       
CODE_03C10A:        C8            INY                       
CODE_03C10B:        C8            INY                       
CODE_03C10C:        C8            INY                       
CODE_03C10D:        C8            INY                       
CODE_03C10E:        CA            DEX                       
CODE_03C10F:        10 C2         BPL CODE_03C0D3           
Return03C111:       6B            RTL                       ; Return 


IggyPlatSpeed:                    .db $FF,$01,$FF,$01

DATA_03C116:                      .db $FF,$00,$FF,$00

IggyPlatBounds:                   .db $E7,$18,$D7,$28

CODE_03C11E:        A5 9D         LDA RAM_SpritesLocked     ; \ If sprites locked... 
CODE_03C120:        0D 93 14      ORA.W $1493               ;  | ...or battle is over (set to FF when over)... 
CODE_03C123:        D0 50         BNE Return03C175          ; / ...return 
CODE_03C125:        AD 06 19      LDA.W $1906               ; \ If platform at a maximum tilt, (stationary timer > 0) 
CODE_03C128:        F0 03         BEQ CODE_03C12D           ;  | 
CODE_03C12A:        CE 06 19      DEC.W $1906               ; / decrement stationary timer 
CODE_03C12D:        A5 13         LDA RAM_FrameCounter      ; \ Return every other time through... 
CODE_03C12F:        29 01         AND.B #$01                ;  | 
CODE_03C131:        0D 06 19      ORA.W $1906               ;  | ...return if stationary 
CODE_03C134:        D0 3F         BNE Return03C175          ; / 
CODE_03C136:        AD 05 19      LDA.W $1905               ; $1907 holds the total number of tilts made 
CODE_03C139:        29 01         AND.B #$01                ; \ X=1 if platform tilted up to the right (/)... 
CODE_03C13B:        AA            TAX                       ; / ...else X=0 
CODE_03C13C:        AD 07 19      LDA.W $1907               ; $1907 holds the current phase: 0/ 1\ 2/ 3\ 4// 5\\ 
CODE_03C13F:        C9 04         CMP.B #$04                ; \ If this is phase 4 or 5... 
CODE_03C141:        90 02         BCC CODE_03C145           ;  | ...cause a steep tilt by setting X=X+2 
CODE_03C143:        E8            INX                       ;  | 
CODE_03C144:        E8            INX                       ; / 
CODE_03C145:        A5 36         LDA $36                   ; $36 is tilt of platform: //D8 /E8 -0- 18\ 28\\ 
CODE_03C147:        18            CLC                       ; \ Get new tilt of platform by adding value 
CODE_03C148:        7F 12 C1 03   ADC.L IggyPlatSpeed,X     ;  | 
CODE_03C14C:        85 36         STA $36                   ; / 
CODE_03C14E:        48            PHA                       
CODE_03C14F:        A5 37         LDA $37                   ; $37 is boolean tilt of platform: 0\ /1 
CODE_03C151:        7F 16 C1 03   ADC.L DATA_03C116,X       ; \ if tilted up to left,  $37=0 
CODE_03C155:        29 01         AND.B #$01                ;  | if tilted up to right, $37=1 
CODE_03C157:        85 37         STA $37                   ; / 
CODE_03C159:        68            PLA                       
CODE_03C15A:        DF 1A C1 03   CMP.L IggyPlatBounds,X    ; \ Return if platform not at a maximum tilt 
CODE_03C15E:        D0 15         BNE Return03C175          ; / 
CODE_03C160:        EE 05 19      INC.W $1905               ; Increment total number of tilts made 
CODE_03C163:        A9 40         LDA.B #$40                ; \ Set timer to stay stationary 
CODE_03C165:        8D 06 19      STA.W $1906               ; / 
CODE_03C168:        EE 07 19      INC.W $1907               ; Increment phase 
CODE_03C16B:        AD 07 19      LDA.W $1907               ; \ If phase > 5, phase = 0 
CODE_03C16E:        C9 06         CMP.B #$06                ;  | 
CODE_03C170:        D0 03         BNE Return03C175          ;  | 
CODE_03C172:        9C 07 19      STZ.W $1907               ; / 
Return03C175:       60            RTS                       ; Return 


DATA_03C176:                      .db $0C,$0C,$0C,$0C,$0C,$0C,$0D,$0D
                                  .db $0D,$0D,$FC,$FC,$FC,$FC,$FC,$FC
                                  .db $FB,$FB,$FB,$FB,$0C,$0C,$0C,$0C
                                  .db $0C,$0C,$0D,$0D,$0D,$0D,$FC,$FC
                                  .db $FC,$FC,$FC,$FC,$FB,$FB,$FB,$FB
DATA_03C19E:                      .db $0E,$0E,$0E,$0D,$0D,$0D,$0C,$0C
                                  .db $0B,$0B,$0E,$0E,$0E,$0D,$0D,$0D
                                  .db $0C,$0C,$0B,$0B,$12,$12,$12,$11
                                  .db $11,$11,$10,$10,$0F,$0F,$12,$12
                                  .db $12,$11,$11,$11,$10,$10,$0F,$0F
DATA_03C1C6:                      .db $02,$FE

DATA_03C1C8:                      .db $00,$FF

CODE_03C1CA:        8B            PHB                       
CODE_03C1CB:        4B            PHK                       
CODE_03C1CC:        AB            PLB                       
CODE_03C1CD:        A0 00         LDY.B #$00                
CODE_03C1CF:        BD B8 15      LDA.W $15B8,X             
CODE_03C1D2:        10 01         BPL CODE_03C1D5           
CODE_03C1D4:        C8            INY                       
CODE_03C1D5:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03C1D7:        18            CLC                       
CODE_03C1D8:        79 C6 C1      ADC.W DATA_03C1C6,Y       
CODE_03C1DB:        95 E4         STA RAM_SpriteXLo,X       
CODE_03C1DD:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03C1E0:        79 C8 C1      ADC.W DATA_03C1C8,Y       
CODE_03C1E3:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_03C1E6:        A9 18         LDA.B #$18                
CODE_03C1E8:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03C1EA:        AB            PLB                       
Return03C1EB:       6B            RTL                       ; Return 


DATA_03C1EC:                      .db $00,$04,$07,$08,$08,$07,$04,$00
                                  .db $00

LightSwitch:        A5 9D         LDA RAM_SpritesLocked     
CODE_03C1F7:        D0 32         BNE CODE_03C22B           
CODE_03C1F9:        22 4F B4 01   JSL.L InvisBlkMainRt      
CODE_03C1FD:        20 5D B8      JSR.W SubOffscreen0Bnk3   
CODE_03C200:        BD 58 15      LDA.W $1558,X             
CODE_03C203:        C9 05         CMP.B #$05                
CODE_03C205:        D0 24         BNE CODE_03C22B           
CODE_03C207:        74 C2         STZ RAM_SpriteState,X     
CODE_03C209:        A0 0B         LDY.B #$0B                ; \ Play sound effect 
CODE_03C20B:        8C F9 1D      STY.W $1DF9               ; / 
CODE_03C20E:        48            PHA                       
CODE_03C20F:        A0 09         LDY.B #$09                
CODE_03C211:        B9 C8 14      LDA.W $14C8,Y             
CODE_03C214:        C9 08         CMP.B #$08                
CODE_03C216:        D0 0F         BNE CODE_03C227           
CODE_03C218:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_03C21B:        C9 C6         CMP.B #$C6                
CODE_03C21D:        D0 08         BNE CODE_03C227           
CODE_03C21F:        B9 C2 00      LDA.W RAM_SpriteState,Y   
CODE_03C222:        49 01         EOR.B #$01                
CODE_03C224:        99 C2 00      STA.W RAM_SpriteState,Y   
CODE_03C227:        88            DEY                       
CODE_03C228:        10 E7         BPL CODE_03C211           
CODE_03C22A:        68            PLA                       
CODE_03C22B:        BD 58 15      LDA.W $1558,X             
CODE_03C22E:        4A            LSR                       
CODE_03C22F:        A8            TAY                       
CODE_03C230:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_03C232:        48            PHA                       
CODE_03C233:        18            CLC                       
CODE_03C234:        79 EC C1      ADC.W DATA_03C1EC,Y       
CODE_03C237:        85 1C         STA RAM_ScreenBndryYLo    
CODE_03C239:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_03C23B:        48            PHA                       
CODE_03C23C:        69 00         ADC.B #$00                
CODE_03C23E:        85 1D         STA RAM_ScreenBndryYHi    
CODE_03C240:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_03C244:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_03C247:        A9 2A         LDA.B #$2A                
CODE_03C249:        99 02 03      STA.W OAM_Tile,Y          
CODE_03C24C:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_03C24F:        29 BF         AND.B #$BF                
CODE_03C251:        99 03 03      STA.W OAM_Prop,Y          
CODE_03C254:        68            PLA                       
CODE_03C255:        85 1D         STA RAM_ScreenBndryYHi    
CODE_03C257:        68            PLA                       
CODE_03C258:        85 1C         STA RAM_ScreenBndryYLo    
Return03C25A:       60            RTS                       ; Return 


ChainsawMotorTiles:               .db $E0,$C2,$C0,$C2

DATA_03C25F:                      .db $F2,$0E

DATA_03C261:                      .db $33,$B3

CODE_03C263:        8B            PHB                       ; Wrapper 
CODE_03C264:        4B            PHK                       
CODE_03C265:        AB            PLB                       
CODE_03C266:        20 6B C2      JSR.W ChainsawGfx         
CODE_03C269:        AB            PLB                       
Return03C26A:       6B            RTL                       ; Return 

ChainsawGfx:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_03C26E:        DA            PHX                       
CODE_03C26F:        B5 9E         LDA RAM_SpriteNum,X       
CODE_03C271:        38            SEC                       
CODE_03C272:        E9 65         SBC.B #$65                
CODE_03C274:        AA            TAX                       
CODE_03C275:        BD 5F C2      LDA.W DATA_03C25F,X       
CODE_03C278:        85 03         STA $03                   
CODE_03C27A:        BD 61 C2      LDA.W DATA_03C261,X       
CODE_03C27D:        85 04         STA $04                   
CODE_03C27F:        FA            PLX                       
CODE_03C280:        A5 14         LDA RAM_FrameCounterB     
CODE_03C282:        29 02         AND.B #$02                
CODE_03C284:        85 02         STA $02                   
CODE_03C286:        A5 00         LDA $00                   
CODE_03C288:        38            SEC                       
CODE_03C289:        E9 08         SBC.B #$08                
CODE_03C28B:        99 00 03      STA.W OAM_DispX,Y         
CODE_03C28E:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_03C291:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_03C294:        A5 01         LDA $01                   
CODE_03C296:        38            SEC                       
CODE_03C297:        E9 08         SBC.B #$08                
CODE_03C299:        99 01 03      STA.W OAM_DispY,Y         
CODE_03C29C:        18            CLC                       
CODE_03C29D:        65 03         ADC $03                   
CODE_03C29F:        18            CLC                       
CODE_03C2A0:        65 02         ADC $02                   
CODE_03C2A2:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_03C2A5:        18            CLC                       
CODE_03C2A6:        65 03         ADC $03                   
CODE_03C2A8:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_03C2AB:        A5 14         LDA RAM_FrameCounterB     
CODE_03C2AD:        4A            LSR                       
CODE_03C2AE:        4A            LSR                       
CODE_03C2AF:        29 03         AND.B #$03                
CODE_03C2B1:        DA            PHX                       
CODE_03C2B2:        AA            TAX                       
CODE_03C2B3:        BD 5B C2      LDA.W ChainsawMotorTiles,X 
CODE_03C2B6:        99 02 03      STA.W OAM_Tile,Y          
CODE_03C2B9:        FA            PLX                       
CODE_03C2BA:        A9 AE         LDA.B #$AE                
CODE_03C2BC:        99 06 03      STA.W OAM_Tile2,Y         
CODE_03C2BF:        A9 8E         LDA.B #$8E                
CODE_03C2C1:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_03C2C4:        A9 37         LDA.B #$37                
CODE_03C2C6:        99 03 03      STA.W OAM_Prop,Y          
CODE_03C2C9:        A5 04         LDA $04                   
CODE_03C2CB:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_03C2CE:        99 0B 03      STA.W OAM_Tile3Prop,Y     
CODE_03C2D1:        A0 02         LDY.B #$02                
CODE_03C2D3:        98            TYA                       
CODE_03C2D4:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return03C2D8:       60            RTS                       ; Return 

TriggerInivis1Up:   DA            PHX                       ; \ Find free sprite slot (#$0B-#$00) 
CODE_03C2DA:        A2 0B         LDX.B #$0B                ;  | 
CODE_03C2DC:        BD C8 14      LDA.W $14C8,X             ;  | 
CODE_03C2DF:        F0 05         BEQ Generate1Up           ;  | 
ADDR_03C2E1:        CA            DEX                       ;  | 
ADDR_03C2E2:        10 F8         BPL CODE_03C2DC           ;  | 
ADDR_03C2E4:        FA            PLX                       ;  | 
Return03C2E5:       6B            RTL                       ; / 

Generate1Up:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_03C2E8:        9D C8 14      STA.W $14C8,X             ; / 
CODE_03C2EB:        A9 78         LDA.B #$78                ; \ Sprite = 1Up 
CODE_03C2ED:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_03C2EF:        A5 94         LDA RAM_MarioXPos         ; \ Sprite X position = Mario X position 
CODE_03C2F1:        95 E4         STA RAM_SpriteXLo,X       ;  | 
CODE_03C2F3:        A5 95         LDA RAM_MarioXPosHi       ;  | 
CODE_03C2F5:        9D E0 14      STA.W RAM_SpriteXHi,X     ; / 
CODE_03C2F8:        A5 96         LDA RAM_MarioYPos         ; \ Sprite Y position = Matio Y position 
CODE_03C2FA:        95 D8         STA RAM_SpriteYLo,X       ;  | 
CODE_03C2FC:        A5 97         LDA RAM_MarioYPosHi       ;  | 
CODE_03C2FE:        9D D4 14      STA.W RAM_SpriteYHi,X     ; / 
CODE_03C301:        22 D2 F7 07   JSL.L InitSpriteTables    ; Load sprite tables 
CODE_03C305:        A9 10         LDA.B #$10                ; \ Disable interaction timer = #$10 
CODE_03C307:        9D 4C 15      STA.W RAM_DisableInter,X  ; / 
CODE_03C30A:        20 34 C3      JSR.W PopupMushroom       
CODE_03C30D:        FA            PLX                       
Return03C30E:       6B            RTL                       ; Return 

InvisMushroom:      20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_03C312:        22 DC A7 01   JSL.L MarioSprInteract    ; \ Return if no interaction 
CODE_03C316:        90 2F         BCC Return03C347          ; / 
CODE_03C318:        A9 74         LDA.B #$74                ; \ Replace, Sprite = Mushroom 
CODE_03C31A:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_03C31C:        22 D2 F7 07   JSL.L InitSpriteTables    ; Reset sprite tables 
CODE_03C320:        A9 20         LDA.B #$20                ; \ Disable interaction timer = #$20 
CODE_03C322:        9D 4C 15      STA.W RAM_DisableInter,X  ; / 
CODE_03C325:        B5 D8         LDA RAM_SpriteYLo,X       ; \ Sprite Y position = Mario Y position - $000F 
CODE_03C327:        38            SEC                       ;  | 
CODE_03C328:        E9 0F         SBC.B #$0F                ;  | 
CODE_03C32A:        95 D8         STA RAM_SpriteYLo,X       ;  | 
CODE_03C32C:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_03C32F:        E9 00         SBC.B #$00                ;  | 
CODE_03C331:        9D D4 14      STA.W RAM_SpriteYHi,X     ; / 
PopupMushroom:      A9 00         LDA.B #$00                ; \ Sprite direction = dirction of Mario's X speed 
CODE_03C336:        A4 7B         LDY RAM_MarioSpeedX       ;  | 
CODE_03C338:        10 01         BPL CODE_03C33B           ;  | 
CODE_03C33A:        1A            INC A                     ;  | 
CODE_03C33B:        9D 7C 15      STA.W RAM_SpriteDir,X     ; / 
CODE_03C33E:        A9 C0         LDA.B #$C0                ; \ Set upward speed 
CODE_03C340:        95 AA         STA RAM_SpriteSpeedY,X    ; / 
CODE_03C342:        A9 02         LDA.B #$02                ; \ Play sound effect 
CODE_03C344:        8D FC 1D      STA.W $1DFC               ; / 
Return03C347:       60            RTS                       ; Return 


NinjiSpeedY:                      .db $D0,$C0,$B0,$D0

Ninji:              22 B2 90 01   JSL.L GenericSprGfxRt2    ; Draw sprite uing the routine for sprites <= 53 
CODE_03C350:        A5 9D         LDA RAM_SpritesLocked     ; \ Return if sprites locked			 
CODE_03C352:        D0 3B         BNE Return03C38F          ; /						 
CODE_03C354:        20 17 B8      JSR.W SubHorzPosBnk3      ; \ Always face mario				 
CODE_03C357:        98            TYA                       ;  |						 
CODE_03C358:        9D 7C 15      STA.W RAM_SpriteDir,X     ; /						 
CODE_03C35B:        20 5D B8      JSR.W SubOffscreen0Bnk3   ; Only process while onscreen			 
CODE_03C35E:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  ; Interact with mario				 
CODE_03C362:        22 2A 80 01   JSL.L UpdateSpritePos     ; Update position based on speed values       
CODE_03C366:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_03C369:        29 04         AND.B #$04                ;  | 
CODE_03C36B:        F0 18         BEQ CODE_03C385           ; / 
CODE_03C36D:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03C36F:        BD 40 15      LDA.W $1540,X             
CODE_03C372:        D0 11         BNE CODE_03C385           
CODE_03C374:        A9 60         LDA.B #$60                
CODE_03C376:        9D 40 15      STA.W $1540,X             
CODE_03C379:        F6 C2         INC RAM_SpriteState,X     
CODE_03C37B:        B5 C2         LDA RAM_SpriteState,X     
CODE_03C37D:        29 03         AND.B #$03                
CODE_03C37F:        A8            TAY                       
CODE_03C380:        B9 48 C3      LDA.W NinjiSpeedY,Y       
CODE_03C383:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03C385:        A9 00         LDA.B #$00                
CODE_03C387:        B4 AA         LDY RAM_SpriteSpeedY,X    
CODE_03C389:        30 01         BMI CODE_03C38C           
CODE_03C38B:        1A            INC A                     
CODE_03C38C:        9D 02 16      STA.W $1602,X             
Return03C38F:       60            RTS                       ; Return 

CODE_03C390:        8B            PHB                       
CODE_03C391:        4B            PHK                       
CODE_03C392:        AB            PLB                       
CODE_03C393:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_03C396:        48            PHA                       
CODE_03C397:        BC AC 15      LDY.W $15AC,X             
CODE_03C39A:        F0 09         BEQ CODE_03C3A5           
CODE_03C39C:        C0 05         CPY.B #$05                
CODE_03C39E:        90 05         BCC CODE_03C3A5           
CODE_03C3A0:        49 01         EOR.B #$01                
CODE_03C3A2:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_03C3A5:        20 DA C3      JSR.W CODE_03C3DA         
CODE_03C3A8:        68            PLA                       
CODE_03C3A9:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_03C3AC:        AB            PLB                       
Return03C3AD:       6B            RTL                       ; Return 

CODE_03C3AE:        22 B2 90 01   JSL.L GenericSprGfxRt2    
Return03C3B2:       60            RTS                       ; Return 


DryBonesTileDispX:                .db $00,$08,$00,$00,$F8,$00,$00,$04
                                  .db $00,$00,$FC,$00

DryBonesGfxProp:                  .db $43,$43,$43,$03,$03,$03

DryBonesTileDispY:                .db $F4,$F0,$00,$F4,$F1,$00,$F4,$F0
                                  .db $00

DryBonesTiles:                    .db $00,$64,$66,$00,$64,$68,$82,$64
                                  .db $E6

DATA_03C3D7:                      .db $00,$00,$FF

CODE_03C3DA:        B5 9E         LDA RAM_SpriteNum,X       
CODE_03C3DC:        C9 31         CMP.B #$31                
CODE_03C3DE:        F0 CE         BEQ CODE_03C3AE           
CODE_03C3E0:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_03C3E3:        BD AC 15      LDA.W $15AC,X             
CODE_03C3E6:        85 05         STA $05                   
CODE_03C3E8:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_03C3EB:        0A            ASL                       
CODE_03C3EC:        7D 7C 15      ADC.W RAM_SpriteDir,X     
CODE_03C3EF:        85 02         STA $02                   
CODE_03C3F1:        DA            PHX                       
CODE_03C3F2:        BD 02 16      LDA.W $1602,X             
CODE_03C3F5:        48            PHA                       
CODE_03C3F6:        0A            ASL                       
CODE_03C3F7:        7D 02 16      ADC.W $1602,X             
CODE_03C3FA:        85 03         STA $03                   
CODE_03C3FC:        FA            PLX                       
CODE_03C3FD:        BD D7 C3      LDA.W DATA_03C3D7,X       
CODE_03C400:        85 04         STA $04                   
CODE_03C402:        A2 02         LDX.B #$02                
CODE_03C404:        DA            PHX                       
CODE_03C405:        8A            TXA                       
CODE_03C406:        18            CLC                       
CODE_03C407:        65 02         ADC $02                   
CODE_03C409:        AA            TAX                       
CODE_03C40A:        DA            PHX                       
CODE_03C40B:        A5 05         LDA $05                   
CODE_03C40D:        F0 05         BEQ CODE_03C414           
CODE_03C40F:        8A            TXA                       
CODE_03C410:        18            CLC                       
CODE_03C411:        69 06         ADC.B #$06                
CODE_03C413:        AA            TAX                       
CODE_03C414:        A5 00         LDA $00                   
CODE_03C416:        18            CLC                       
CODE_03C417:        7D B3 C3      ADC.W DryBonesTileDispX,X 
CODE_03C41A:        99 00 03      STA.W OAM_DispX,Y         
CODE_03C41D:        FA            PLX                       
CODE_03C41E:        BD BF C3      LDA.W DryBonesGfxProp,X   
CODE_03C421:        05 64         ORA $64                   
CODE_03C423:        99 03 03      STA.W OAM_Prop,Y          
CODE_03C426:        68            PLA                       
CODE_03C427:        48            PHA                       
CODE_03C428:        18            CLC                       
CODE_03C429:        65 03         ADC $03                   
CODE_03C42B:        AA            TAX                       
CODE_03C42C:        A5 01         LDA $01                   
CODE_03C42E:        18            CLC                       
CODE_03C42F:        7D C5 C3      ADC.W DryBonesTileDispY,X 
CODE_03C432:        99 01 03      STA.W OAM_DispY,Y         
CODE_03C435:        BD CE C3      LDA.W DryBonesTiles,X     
CODE_03C438:        99 02 03      STA.W OAM_Tile,Y          
CODE_03C43B:        FA            PLX                       
CODE_03C43C:        C8            INY                       
CODE_03C43D:        C8            INY                       
CODE_03C43E:        C8            INY                       
CODE_03C43F:        C8            INY                       
CODE_03C440:        CA            DEX                       
CODE_03C441:        E4 04         CPX $04                   
CODE_03C443:        D0 BF         BNE CODE_03C404           
CODE_03C445:        FA            PLX                       
CODE_03C446:        A0 02         LDY.B #$02                
CODE_03C448:        98            TYA                       
CODE_03C449:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return03C44D:       60            RTS                       ; Return 

CODE_03C44E:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_03C451:        1D 6C 18      ORA.W RAM_OffscreenVert,X 
CODE_03C454:        D0 0A         BNE Return03C460          
CODE_03C456:        A0 07         LDY.B #$07                ; \ Find a free extended sprite slot 
CODE_03C458:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   ;  | 
CODE_03C45B:        F0 04         BEQ CODE_03C461           ;  | 
CODE_03C45D:        88            DEY                       ;  | 
CODE_03C45E:        10 F8         BPL CODE_03C458           ;  | 
Return03C460:       6B            RTL                       ; / Return if no free slots 

CODE_03C461:        A9 06         LDA.B #$06                ; \ Extended sprite = Bone 
CODE_03C463:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_03C466:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03C468:        38            SEC                       
CODE_03C469:        E9 10         SBC.B #$10                
CODE_03C46B:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
CODE_03C46E:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03C471:        E9 00         SBC.B #$00                
CODE_03C473:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
CODE_03C476:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03C478:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
CODE_03C47B:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03C47E:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
CODE_03C481:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_03C484:        4A            LSR                       
CODE_03C485:        A9 18         LDA.B #$18                
CODE_03C487:        90 02         BCC CODE_03C48B           
CODE_03C489:        A9 E8         LDA.B #$E8                
CODE_03C48B:        99 47 17      STA.W RAM_ExSprSpeedX,Y   
Return03C48E:       6B            RTL                       ; Return 


DATA_03C48F:                      .db $01,$FF

DATA_03C491:                      .db $FF,$90

DiscoBallTiles:                   .db $80,$82,$84,$86,$88,$8C,$C0,$C2
                                  .db $C2

DATA_03C49C:                      .db $31,$33,$35,$37,$31,$33,$35,$37
                                  .db $39

CODE_03C4A5:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_03C4A8:        A9 78         LDA.B #$78                
CODE_03C4AA:        99 00 03      STA.W OAM_DispX,Y         
CODE_03C4AD:        A9 28         LDA.B #$28                
CODE_03C4AF:        99 01 03      STA.W OAM_DispY,Y         
CODE_03C4B2:        DA            PHX                       
CODE_03C4B3:        B5 C2         LDA RAM_SpriteState,X     
CODE_03C4B5:        A2 08         LDX.B #$08                
CODE_03C4B7:        29 01         AND.B #$01                
CODE_03C4B9:        F0 06         BEQ CODE_03C4C1           
CODE_03C4BB:        A5 13         LDA RAM_FrameCounter      
CODE_03C4BD:        4A            LSR                       
CODE_03C4BE:        29 07         AND.B #$07                
CODE_03C4C0:        AA            TAX                       
CODE_03C4C1:        BD 93 C4      LDA.W DiscoBallTiles,X    
CODE_03C4C4:        99 02 03      STA.W OAM_Tile,Y          
CODE_03C4C7:        BD 9C C4      LDA.W DATA_03C49C,X       
CODE_03C4CA:        99 03 03      STA.W OAM_Prop,Y          
CODE_03C4CD:        98            TYA                       
CODE_03C4CE:        4A            LSR                       
CODE_03C4CF:        4A            LSR                       
CODE_03C4D0:        A8            TAY                       
CODE_03C4D1:        A9 02         LDA.B #$02                
CODE_03C4D3:        99 60 04      STA.W OAM_TileSize,Y      
CODE_03C4D6:        FA            PLX                       
Return03C4D7:       60            RTS                       ; Return 


DATA_03C4D8:                      .db $10,$8C

DATA_03C4DA:                      .db $42,$31

DarkRoomWithLight:  BD 34 15      LDA.W $1534,X             
CODE_03C4DF:        D0 1F         BNE CODE_03C500           
CODE_03C4E1:        A0 09         LDY.B #$09                
CODE_03C4E3:        CC E9 15      CPY.W $15E9               
CODE_03C4E6:        F0 12         BEQ CODE_03C4FA           
CODE_03C4E8:        B9 C8 14      LDA.W $14C8,Y             
CODE_03C4EB:        C9 08         CMP.B #$08                
CODE_03C4ED:        D0 0B         BNE CODE_03C4FA           
CODE_03C4EF:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_03C4F2:        C9 C6         CMP.B #$C6                
CODE_03C4F4:        D0 04         BNE CODE_03C4FA           
CODE_03C4F6:        9E C8 14      STZ.W $14C8,X             
Return03C4F9:       60            RTS                       ; Return 

CODE_03C4FA:        88            DEY                       
CODE_03C4FB:        10 E6         BPL CODE_03C4E3           
CODE_03C4FD:        FE 34 15      INC.W $1534,X             
CODE_03C500:        20 A5 C4      JSR.W CODE_03C4A5         
CODE_03C503:        A9 FF         LDA.B #$FF                
CODE_03C505:        85 40         STA $40                   
CODE_03C507:        A9 20         LDA.B #$20                
CODE_03C509:        85 44         STA $44                   
CODE_03C50B:        A9 20         LDA.B #$20                
CODE_03C50D:        85 43         STA $43                   
CODE_03C50F:        A9 80         LDA.B #$80                
CODE_03C511:        8D 9F 0D      STA.W $0D9F               
CODE_03C514:        B5 C2         LDA RAM_SpriteState,X     
CODE_03C516:        29 01         AND.B #$01                
CODE_03C518:        A8            TAY                       
CODE_03C519:        B9 D8 C4      LDA.W DATA_03C4D8,Y       
CODE_03C51C:        8D 01 07      STA.W $0701               
CODE_03C51F:        B9 DA C4      LDA.W DATA_03C4DA,Y       
CODE_03C522:        8D 02 07      STA.W $0702               
CODE_03C525:        A5 9D         LDA RAM_SpritesLocked     
CODE_03C527:        D0 D0         BNE Return03C4F9          
CODE_03C529:        AD 82 14      LDA.W $1482               
CODE_03C52C:        D0 1F         BNE CODE_03C54D           
CODE_03C52E:        A9 00         LDA.B #$00                
CODE_03C530:        8D 76 14      STA.W $1476               
CODE_03C533:        A9 90         LDA.B #$90                
CODE_03C535:        8D 78 14      STA.W $1478               
CODE_03C538:        A9 78         LDA.B #$78                
CODE_03C53A:        8D 72 14      STA.W $1472               
CODE_03C53D:        A9 87         LDA.B #$87                
CODE_03C53F:        8D 74 14      STA.W $1474               
CODE_03C542:        A9 01         LDA.B #$01                
CODE_03C544:        8D 86 14      STA.W $1486               
CODE_03C547:        9C 83 14      STZ.W $1483               
CODE_03C54A:        EE 82 14      INC.W $1482               
CODE_03C54D:        AC 83 14      LDY.W $1483               
CODE_03C550:        AD 76 14      LDA.W $1476               
CODE_03C553:        18            CLC                       
CODE_03C554:        79 8F C4      ADC.W DATA_03C48F,Y       
CODE_03C557:        8D 76 14      STA.W $1476               
CODE_03C55A:        AD 78 14      LDA.W $1478               
CODE_03C55D:        18            CLC                       
CODE_03C55E:        79 8F C4      ADC.W DATA_03C48F,Y       
CODE_03C561:        8D 78 14      STA.W $1478               
CODE_03C564:        D9 91 C4      CMP.W DATA_03C491,Y       
CODE_03C567:        D0 09         BNE CODE_03C572           
CODE_03C569:        AD 83 14      LDA.W $1483               
CODE_03C56C:        1A            INC A                     
CODE_03C56D:        29 01         AND.B #$01                
CODE_03C56F:        8D 83 14      STA.W $1483               
CODE_03C572:        A5 13         LDA RAM_FrameCounter      
CODE_03C574:        29 03         AND.B #$03                
CODE_03C576:        D0 81         BNE Return03C4F9          
CODE_03C578:        A0 00         LDY.B #$00                
CODE_03C57A:        AD 72 14      LDA.W $1472               
CODE_03C57D:        8D 7A 14      STA.W $147A               
CODE_03C580:        38            SEC                       
CODE_03C581:        ED 76 14      SBC.W $1476               
CODE_03C584:        B0 04         BCS CODE_03C58A           
ADDR_03C586:        C8            INY                       
ADDR_03C587:        49 FF         EOR.B #$FF                
ADDR_03C589:        1A            INC A                     
CODE_03C58A:        8D 80 14      STA.W $1480               
CODE_03C58D:        8C 84 14      STY.W $1484               
CODE_03C590:        9C 7E 14      STZ.W $147E               
CODE_03C593:        A0 00         LDY.B #$00                
CODE_03C595:        AD 74 14      LDA.W $1474               
CODE_03C598:        8D 7C 14      STA.W $147C               
CODE_03C59B:        38            SEC                       
CODE_03C59C:        ED 78 14      SBC.W $1478               
CODE_03C59F:        B0 04         BCS CODE_03C5A5           
CODE_03C5A1:        C8            INY                       
CODE_03C5A2:        49 FF         EOR.B #$FF                
CODE_03C5A4:        1A            INC A                     
CODE_03C5A5:        8D 81 14      STA.W $1481               
CODE_03C5A8:        8C 85 14      STY.W $1485               
CODE_03C5AB:        9C 7F 14      STZ.W $147F               
CODE_03C5AE:        B5 C2         LDA RAM_SpriteState,X     
CODE_03C5B0:        85 0F         STA $0F                   
CODE_03C5B2:        DA            PHX                       
CODE_03C5B3:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_03C5B5:        A2 00 00      LDX.W #$0000              
CODE_03C5B8:        E0 5F 00      CPX.W #$005F              
CODE_03C5BB:        90 4A         BCC CODE_03C607           
CODE_03C5BD:        AD 7E 14      LDA.W $147E               
CODE_03C5C0:        18            CLC                       
CODE_03C5C1:        6D 80 14      ADC.W $1480               
CODE_03C5C4:        8D 7E 14      STA.W $147E               
CODE_03C5C7:        B0 04         BCS CODE_03C5CD           
CODE_03C5C9:        C9 CF         CMP.B #$CF                
CODE_03C5CB:        90 13         BCC CODE_03C5E0           
CODE_03C5CD:        E9 CF         SBC.B #$CF                
CODE_03C5CF:        8D 7E 14      STA.W $147E               
CODE_03C5D2:        EE 7A 14      INC.W $147A               
CODE_03C5D5:        AD 84 14      LDA.W $1484               
CODE_03C5D8:        D0 06         BNE CODE_03C5E0           
CODE_03C5DA:        CE 7A 14      DEC.W $147A               
CODE_03C5DD:        CE 7A 14      DEC.W $147A               
CODE_03C5E0:        AD 7F 14      LDA.W $147F               
CODE_03C5E3:        18            CLC                       
CODE_03C5E4:        6D 81 14      ADC.W $1481               
CODE_03C5E7:        8D 7F 14      STA.W $147F               
CODE_03C5EA:        B0 04         BCS CODE_03C5F0           
CODE_03C5EC:        C9 CF         CMP.B #$CF                
CODE_03C5EE:        90 13         BCC CODE_03C603           
CODE_03C5F0:        E9 CF         SBC.B #$CF                
CODE_03C5F2:        8D 7F 14      STA.W $147F               
CODE_03C5F5:        EE 7C 14      INC.W $147C               
CODE_03C5F8:        AD 85 14      LDA.W $1485               
CODE_03C5FB:        D0 06         BNE CODE_03C603           
ADDR_03C5FD:        CE 7C 14      DEC.W $147C               
ADDR_03C600:        CE 7C 14      DEC.W $147C               
CODE_03C603:        A5 0F         LDA $0F                   
CODE_03C605:        D0 08         BNE CODE_03C60F           
CODE_03C607:        A9 01         LDA.B #$01                
CODE_03C609:        9D A0 04      STA.W $04A0,X             
CODE_03C60C:        3A            DEC A                     
CODE_03C60D:        80 09         BRA CODE_03C618           

CODE_03C60F:        AD 7A 14      LDA.W $147A               
CODE_03C612:        9D A0 04      STA.W $04A0,X             
CODE_03C615:        AD 7C 14      LDA.W $147C               
CODE_03C618:        9D A1 04      STA.W $04A1,X             
CODE_03C61B:        E8            INX                       
CODE_03C61C:        E8            INX                       
CODE_03C61D:        E0 C0 01      CPX.W #$01C0              
CODE_03C620:        D0 96         BNE CODE_03C5B8           
CODE_03C622:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_03C624:        FA            PLX                       
Return03C625:       60            RTS                       ; Return 


DATA_03C626:                      .db $14,$28,$38,$20,$30,$4C,$40,$34
                                  .db $2C,$1C,$08,$0C,$04,$0C,$1C,$24
                                  .db $2C,$38,$40,$48,$50,$5C,$5C,$6C
                                  .db $4C,$58,$24,$78,$64,$70,$78,$7C
                                  .db $70,$68,$58,$4C,$40,$34,$24,$04
                                  .db $18,$2C,$0C,$0C,$14,$18,$1C,$24
                                  .db $2C,$28,$24,$30,$30,$34,$38,$3C
                                  .db $44,$54,$48,$5C,$68,$40,$4C,$40
                                  .db $3C,$40,$50,$54,$60,$54,$4C,$5C
                                  .db $5C,$68,$74,$6C,$7C,$78,$68,$80
                                  .db $18,$48,$2C,$1C

DATA_03C67A:                      .db $1C,$0C,$08,$1C,$14,$08,$14,$24
                                  .db $28,$2C,$30,$3C,$44,$4C,$44,$34
                                  .db $40,$34,$24,$1C,$10,$0C,$18,$18
                                  .db $2C,$28,$68,$28,$34,$34,$38,$40
                                  .db $44,$44,$38,$3C,$44,$48,$4C,$5C
                                  .db $5C,$54,$64,$74,$74,$88,$80,$94
                                  .db $8C,$78,$6C,$64,$70,$7C,$8C,$98
                                  .db $90,$98,$84,$84,$88,$78,$78,$6C
                                  .db $5C,$50,$50,$48,$50,$5C,$64,$64
                                  .db $74,$78,$74,$64,$60,$58,$54,$50
                                  .db $50,$58,$30,$34

DATA_03C6CE:                      .db $20,$30,$39,$47,$50,$60,$70,$7C
                                  .db $7B,$80,$7D,$78,$6E,$60,$4F,$47
                                  .db $41,$38,$30,$2A,$20,$10,$04,$00
                                  .db $00,$08,$10,$20,$1A,$10,$0A,$06
                                  .db $0F,$17,$16,$1C,$1F,$21,$10,$18
                                  .db $20,$2C,$2E,$3B,$30,$30,$2D,$2A
                                  .db $34,$36,$3A,$3F,$45,$4D,$5F,$54
                                  .db $4E,$67,$70,$67,$70,$5C,$4E,$40
                                  .db $48,$56,$57,$5F,$68,$72,$77,$6F
                                  .db $66,$60,$67,$5C,$57,$4B,$4D,$54
                                  .db $48,$43,$3D,$3C

DATA_03C722:                      .db $18,$1E,$25,$22,$1A,$17,$20,$30
                                  .db $41,$4F,$61,$70,$7F,$8C,$94,$92
                                  .db $A0,$86,$93,$88,$88,$78,$66,$50
                                  .db $40,$30,$22,$20,$2C,$30,$40,$4F
                                  .db $59,$51,$3F,$39,$4C,$5F,$6A,$6F
                                  .db $77,$7E,$6C,$60,$58,$48,$3D,$2F
                                  .db $28,$38,$44,$30,$36,$27,$21,$2F
                                  .db $39,$2A,$2F,$39,$40,$3F,$49,$50
                                  .db $60,$59,$4C,$51,$48,$4F,$56,$67
                                  .db $5B,$68,$75,$7D,$87,$8A,$7A,$6B
                                  .db $70,$82,$73,$92

DATA_03C776:                      .db $60,$B0,$40,$80

FireworkSfx1:                     .db $26,$00,$26,$28

FireworkSfx2:                     .db $00,$2B,$00,$00

FireworkSfx3:                     .db $27,$00,$27,$29

FireworkSfx4:                     .db $00,$2C,$00,$00

DATA_03C78A:                      .db $00,$AA,$FF,$AA

DATA_03C78E:                      .db $00,$7E,$27,$7E

DATA_03C792:                      .db $C0,$C0,$FF,$C0

CODE_03C796:        BD 64 15      LDA.W $1564,X             
CODE_03C799:        F0 0C         BEQ CODE_03C7A7           
CODE_03C79B:        3A            DEC A                     
CODE_03C79C:        D0 08         BNE Return03C7A6          
CODE_03C79E:        EE C6 13      INC.W $13C6               
CODE_03C7A1:        A9 FF         LDA.B #$FF                
CODE_03C7A3:        8D 93 14      STA.W $1493               
Return03C7A6:       60            RTS                       ; Return 

CODE_03C7A7:        AD 6D 15      LDA.W $156D               
CODE_03C7AA:        29 03         AND.B #$03                
CODE_03C7AC:        A8            TAY                       
CODE_03C7AD:        B9 8A C7      LDA.W DATA_03C78A,Y       
CODE_03C7B0:        8D 01 07      STA.W $0701               
CODE_03C7B3:        B9 8E C7      LDA.W DATA_03C78E,Y       
CODE_03C7B6:        8D 02 07      STA.W $0702               
CODE_03C7B9:        AD EB 1F      LDA.W $1FEB               
CODE_03C7BC:        D0 51         BNE Return03C80F          
CODE_03C7BE:        BD 34 15      LDA.W $1534,X             
CODE_03C7C1:        C9 04         CMP.B #$04                
CODE_03C7C3:        F0 4B         BEQ CODE_03C810           
CODE_03C7C5:        A0 01         LDY.B #$01                
CODE_03C7C7:        B9 C8 14      LDA.W $14C8,Y             
CODE_03C7CA:        F0 04         BEQ CODE_03C7D0           
ADDR_03C7CC:        88            DEY                       
ADDR_03C7CD:        10 F8         BPL CODE_03C7C7           
Return03C7CF:       60            RTS                       ; Return 

CODE_03C7D0:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_03C7D2:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_03C7D5:        A9 7A         LDA.B #$7A                
CODE_03C7D7:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_03C7DA:        A9 00         LDA.B #$00                
CODE_03C7DC:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_03C7DF:        A9 A8         LDA.B #$A8                
CODE_03C7E1:        18            CLC                       
CODE_03C7E2:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_03C7E4:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_03C7E7:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_03C7E9:        69 00         ADC.B #$00                
CODE_03C7EB:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_03C7EE:        DA            PHX                       
CODE_03C7EF:        BB            TYX                       
CODE_03C7F0:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_03C7F4:        FA            PLX                       
CODE_03C7F5:        DA            PHX                       
CODE_03C7F6:        BD 34 15      LDA.W $1534,X             
CODE_03C7F9:        29 03         AND.B #$03                
CODE_03C7FB:        99 34 15      STA.W $1534,Y             
CODE_03C7FE:        AA            TAX                       
CODE_03C7FF:        BD 92 C7      LDA.W DATA_03C792,X       
CODE_03C802:        8D EB 1F      STA.W $1FEB               
CODE_03C805:        BD 76 C7      LDA.W DATA_03C776,X       
CODE_03C808:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_03C80B:        FA            PLX                       
CODE_03C80C:        FE 34 15      INC.W $1534,X             
Return03C80F:       60            RTS                       ; Return 

CODE_03C810:        A9 70         LDA.B #$70                
CODE_03C812:        9D 64 15      STA.W $1564,X             
Return03C815:       60            RTS                       ; Return 

Firework:           B5 C2         LDA RAM_SpriteState,X     
CODE_03C818:        22 DF 86 00   JSL.L ExecutePtr          

FireworkPtrs:          28 C8      .dw CODE_03C828           
                       45 C8      .dw CODE_03C845           
                       8D C8      .dw CODE_03C88D           
                       41 C9      .dw CODE_03C941           

FireworkSpeedY:                   .db $E4,$E6,$E4,$E2

CODE_03C828:        BC 34 15      LDY.W $1534,X             
CODE_03C82B:        B9 24 C8      LDA.W FireworkSpeedY,Y    
CODE_03C82E:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03C830:        A9 25         LDA.B #$25                ; \ Play sound effect 
CODE_03C832:        8D FC 1D      STA.W $1DFC               ; / 
CODE_03C835:        A9 10         LDA.B #$10                
CODE_03C837:        9D 64 15      STA.W $1564,X             
CODE_03C83A:        F6 C2         INC RAM_SpriteState,X     
Return03C83C:       60            RTS                       ; Return 


DATA_03C83D:                      .db $14,$0C,$10,$15

DATA_03C841:                      .db $08,$10,$0C,$05

CODE_03C845:        BD 64 15      LDA.W $1564,X             
CODE_03C848:        C9 01         CMP.B #$01                
CODE_03C84A:        D0 0F         BNE CODE_03C85B           
CODE_03C84C:        BC 34 15      LDY.W $1534,X             
CODE_03C84F:        B9 7A C7      LDA.W FireworkSfx1,Y      ; \ Play sound effect 
CODE_03C852:        8D F9 1D      STA.W $1DF9               ; / 
CODE_03C855:        B9 7E C7      LDA.W FireworkSfx2,Y      ; \ Play sound effect 
CODE_03C858:        8D FC 1D      STA.W $1DFC               ; / 
CODE_03C85B:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_03C85F:        F6 B6         INC RAM_SpriteSpeedX,X    
CODE_03C861:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_03C863:        29 03         AND.B #$03                
CODE_03C865:        D0 02         BNE CODE_03C869           
CODE_03C867:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_03C869:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03C86B:        C9 FC         CMP.B #$FC                
CODE_03C86D:        D0 16         BNE CODE_03C885           
CODE_03C86F:        F6 C2         INC RAM_SpriteState,X     
CODE_03C871:        BC 34 15      LDY.W $1534,X             
CODE_03C874:        B9 3D C8      LDA.W DATA_03C83D,Y       
CODE_03C877:        9D 1C 15      STA.W $151C,X             
CODE_03C87A:        B9 41 C8      LDA.W DATA_03C841,Y       
CODE_03C87D:        9D AC 15      STA.W $15AC,X             
CODE_03C880:        A9 08         LDA.B #$08                
CODE_03C882:        8D 6D 15      STA.W $156D               
CODE_03C885:        20 6D C9      JSR.W CODE_03C96D         
Return03C888:       60            RTS                       ; Return 


DATA_03C889:                      .db $FF,$80,$C0,$FF

CODE_03C88D:        BD AC 15      LDA.W $15AC,X             
CODE_03C890:        3A            DEC A                     
CODE_03C891:        D0 0F         BNE CODE_03C8A2           
CODE_03C893:        BC 34 15      LDY.W $1534,X             
CODE_03C896:        B9 82 C7      LDA.W FireworkSfx3,Y      ; \ Play sound effect 
CODE_03C899:        8D F9 1D      STA.W $1DF9               ; / 
CODE_03C89C:        B9 86 C7      LDA.W FireworkSfx4,Y      ; \ Play sound effect 
CODE_03C89F:        8D FC 1D      STA.W $1DFC               ; / 
CODE_03C8A2:        20 B1 C8      JSR.W CODE_03C8B1         
CODE_03C8A5:        B5 C2         LDA RAM_SpriteState,X     
CODE_03C8A7:        C9 02         CMP.B #$02                
CODE_03C8A9:        D0 03         BNE CODE_03C8AE           
CODE_03C8AB:        20 B1 C8      JSR.W CODE_03C8B1         
CODE_03C8AE:        4C E9 C9      JMP.W CODE_03C9E9         

CODE_03C8B1:        BC 34 15      LDY.W $1534,X             
CODE_03C8B4:        BD 70 15      LDA.W $1570,X             
CODE_03C8B7:        18            CLC                       
CODE_03C8B8:        7D 1C 15      ADC.W $151C,X             
CODE_03C8BB:        9D 70 15      STA.W $1570,X             
CODE_03C8BE:        B0 1B         BCS ADDR_03C8DB           
CODE_03C8C0:        D9 89 C8      CMP.W DATA_03C889,Y       
CODE_03C8C3:        B0 1B         BCS CODE_03C8E0           
CODE_03C8C5:        BD 1C 15      LDA.W $151C,X             
CODE_03C8C8:        C9 02         CMP.B #$02                
CODE_03C8CA:        90 08         BCC CODE_03C8D4           
CODE_03C8CC:        38            SEC                       
CODE_03C8CD:        E9 01         SBC.B #$01                
CODE_03C8CF:        9D 1C 15      STA.W $151C,X             
CODE_03C8D2:        B0 10         BCS CODE_03C8E4           
CODE_03C8D4:        A9 01         LDA.B #$01                
CODE_03C8D6:        9D 1C 15      STA.W $151C,X             
CODE_03C8D9:        80 09         BRA CODE_03C8E4           

ADDR_03C8DB:        A9 FF         LDA.B #$FF                
ADDR_03C8DD:        9D 70 15      STA.W $1570,X             
CODE_03C8E0:        F6 C2         INC RAM_SpriteState,X     
CODE_03C8E2:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03C8E4:        BD 1C 15      LDA.W $151C,X             
CODE_03C8E7:        29 FF         AND.B #$FF                
CODE_03C8E9:        A8            TAY                       
CODE_03C8EA:        B9 F1 C8      LDA.W DATA_03C8F1,Y       
CODE_03C8ED:        9D 02 16      STA.W $1602,X             
Return03C8F0:       60            RTS                       ; Return 


DATA_03C8F1:                      .db $06,$05,$04,$03,$03,$03,$03,$02
                                  .db $02,$02,$02,$02,$02,$02,$01,$01
                                  .db $01,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $03,$03,$03,$03,$03,$03,$03,$03
                                  .db $03,$03,$02,$02,$02,$02,$02,$02
                                  .db $02,$02,$02,$02,$02,$02,$02,$02
                                  .db $02,$02,$02,$02,$02,$02,$02,$02

CODE_03C941:        A5 13         LDA RAM_FrameCounter      
CODE_03C943:        29 07         AND.B #$07                
CODE_03C945:        D0 02         BNE CODE_03C949           
CODE_03C947:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_03C949:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_03C94D:        A9 07         LDA.B #$07                
CODE_03C94F:        B4 AA         LDY RAM_SpriteSpeedY,X    
CODE_03C951:        C0 08         CPY.B #$08                
CODE_03C953:        D0 03         BNE CODE_03C958           
CODE_03C955:        9E C8 14      STZ.W $14C8,X             
CODE_03C958:        C0 03         CPY.B #$03                
CODE_03C95A:        90 06         BCC CODE_03C962           
CODE_03C95C:        1A            INC A                     
CODE_03C95D:        C0 05         CPY.B #$05                
CODE_03C95F:        90 01         BCC CODE_03C962           
CODE_03C961:        1A            INC A                     
CODE_03C962:        9D 02 16      STA.W $1602,X             
CODE_03C965:        20 E9 C9      JSR.W CODE_03C9E9         
Return03C968:       60            RTS                       ; Return 


DATA_03C969:                      .db $EC,$8E,$EC,$EC

CODE_03C96D:        8A            TXA                       
CODE_03C96E:        45 13         EOR RAM_FrameCounter      
CODE_03C970:        29 03         AND.B #$03                
CODE_03C972:        D0 44         BNE Return03C9B8          
CODE_03C974:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_03C977:        A0 00         LDY.B #$00                
CODE_03C979:        A5 00         LDA $00                   
CODE_03C97B:        99 00 03      STA.W OAM_DispX,Y         
CODE_03C97E:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_03C981:        A5 01         LDA $01                   
CODE_03C983:        99 01 03      STA.W OAM_DispY,Y         
CODE_03C986:        DA            PHX                       
CODE_03C987:        BD 34 15      LDA.W $1534,X             
CODE_03C98A:        AA            TAX                       
CODE_03C98B:        A5 13         LDA RAM_FrameCounter      
CODE_03C98D:        4A            LSR                       
CODE_03C98E:        4A            LSR                       
CODE_03C98F:        29 02         AND.B #$02                
CODE_03C991:        4A            LSR                       
CODE_03C992:        7D 69 C9      ADC.W DATA_03C969,X       
CODE_03C995:        99 02 03      STA.W OAM_Tile,Y          
CODE_03C998:        FA            PLX                       
CODE_03C999:        A5 13         LDA RAM_FrameCounter      
CODE_03C99B:        0A            ASL                       
CODE_03C99C:        29 0E         AND.B #$0E                
CODE_03C99E:        85 02         STA $02                   
CODE_03C9A0:        A5 13         LDA RAM_FrameCounter      
CODE_03C9A2:        0A            ASL                       
CODE_03C9A3:        0A            ASL                       
CODE_03C9A4:        0A            ASL                       
CODE_03C9A5:        0A            ASL                       
CODE_03C9A6:        29 40         AND.B #$40                
CODE_03C9A8:        05 02         ORA $02                   
CODE_03C9AA:        09 31         ORA.B #$31                
CODE_03C9AC:        99 03 03      STA.W OAM_Prop,Y          
CODE_03C9AF:        98            TYA                       
CODE_03C9B0:        4A            LSR                       
CODE_03C9B1:        4A            LSR                       
CODE_03C9B2:        A8            TAY                       
CODE_03C9B3:        A9 00         LDA.B #$00                
CODE_03C9B5:        99 60 04      STA.W OAM_TileSize,Y      
Return03C9B8:       60            RTS                       ; Return 


DATA_03C9B9:                      .db $36,$35,$C7,$34,$34,$34,$34,$24
                                  .db $03,$03,$36,$35,$C7,$34,$34,$24
                                  .db $24,$24,$24,$03,$36,$35,$C7,$34
                                  .db $34,$34,$24,$24,$03,$24,$36,$35
                                  .db $C7,$34,$24,$24,$24,$24,$24,$03
DATA_03C9E1:                      .db $00,$01,$01,$00,$00,$FF,$FF,$00

CODE_03C9E9:        8A            TXA                       
CODE_03C9EA:        45 13         EOR RAM_FrameCounter      
CODE_03C9EC:        85 05         STA $05                   
CODE_03C9EE:        BD 70 15      LDA.W $1570,X             
CODE_03C9F1:        85 06         STA $06                   
CODE_03C9F3:        BD 02 16      LDA.W $1602,X             
CODE_03C9F6:        85 07         STA $07                   
CODE_03C9F8:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03C9FA:        85 08         STA $08                   
CODE_03C9FC:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03C9FE:        38            SEC                       
CODE_03C9FF:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_03CA01:        85 09         STA $09                   
CODE_03CA03:        BD 34 15      LDA.W $1534,X             
CODE_03CA06:        85 0A         STA $0A                   
CODE_03CA08:        DA            PHX                       
CODE_03CA09:        A2 3F         LDX.B #$3F                
CODE_03CA0B:        A0 00         LDY.B #$00                
CODE_03CA0D:        86 04         STX $04                   
CODE_03CA0F:        A5 0A         LDA $0A                   
CODE_03CA11:        C9 03         CMP.B #$03                
CODE_03CA13:        BD 26 C6      LDA.W DATA_03C626,X       
CODE_03CA16:        90 03         BCC CODE_03CA1B           
CODE_03CA18:        BD CE C6      LDA.W DATA_03C6CE,X       
CODE_03CA1B:        38            SEC                       
CODE_03CA1C:        E9 40         SBC.B #$40                
CODE_03CA1E:        85 00         STA $00                   
CODE_03CA20:        5A            PHY                       
CODE_03CA21:        A5 0A         LDA $0A                   
CODE_03CA23:        C9 03         CMP.B #$03                
CODE_03CA25:        BD 7A C6      LDA.W DATA_03C67A,X       
CODE_03CA28:        90 03         BCC CODE_03CA2D           
CODE_03CA2A:        BD 22 C7      LDA.W DATA_03C722,X       
CODE_03CA2D:        38            SEC                       
CODE_03CA2E:        E9 50         SBC.B #$50                
CODE_03CA30:        85 01         STA $01                   
CODE_03CA32:        A5 00         LDA $00                   
CODE_03CA34:        10 03         BPL CODE_03CA39           
CODE_03CA36:        49 FF         EOR.B #$FF                
CODE_03CA38:        1A            INC A                     
CODE_03CA39:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_03CA3C:        A5 06         LDA $06                   
CODE_03CA3E:        8D 03 42      STA.W $4203               ; Multplier B
CODE_03CA41:        EA            NOP                       
CODE_03CA42:        EA            NOP                       
CODE_03CA43:        EA            NOP                       
CODE_03CA44:        EA            NOP                       
CODE_03CA45:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_03CA48:        A4 00         LDY $00                   
CODE_03CA4A:        10 03         BPL CODE_03CA4F           
CODE_03CA4C:        49 FF         EOR.B #$FF                
CODE_03CA4E:        1A            INC A                     
CODE_03CA4F:        85 02         STA $02                   
CODE_03CA51:        A5 01         LDA $01                   
CODE_03CA53:        10 03         BPL CODE_03CA58           
CODE_03CA55:        49 FF         EOR.B #$FF                
CODE_03CA57:        1A            INC A                     
CODE_03CA58:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_03CA5B:        A5 06         LDA $06                   
CODE_03CA5D:        8D 03 42      STA.W $4203               ; Multplier B
CODE_03CA60:        EA            NOP                       
CODE_03CA61:        EA            NOP                       
CODE_03CA62:        EA            NOP                       
CODE_03CA63:        EA            NOP                       
CODE_03CA64:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_03CA67:        A4 01         LDY $01                   
CODE_03CA69:        10 03         BPL CODE_03CA6E           
CODE_03CA6B:        49 FF         EOR.B #$FF                
CODE_03CA6D:        1A            INC A                     
CODE_03CA6E:        85 03         STA $03                   
CODE_03CA70:        A0 00         LDY.B #$00                
CODE_03CA72:        A5 07         LDA $07                   
CODE_03CA74:        C9 06         CMP.B #$06                
CODE_03CA76:        90 0A         BCC CODE_03CA82           
CODE_03CA78:        A5 05         LDA $05                   
CODE_03CA7A:        18            CLC                       
CODE_03CA7B:        65 04         ADC $04                   
CODE_03CA7D:        4A            LSR                       
CODE_03CA7E:        4A            LSR                       
CODE_03CA7F:        29 07         AND.B #$07                
CODE_03CA81:        A8            TAY                       
CODE_03CA82:        B9 E1 C9      LDA.W DATA_03C9E1,Y       
CODE_03CA85:        7A            PLY                       
CODE_03CA86:        18            CLC                       
CODE_03CA87:        65 02         ADC $02                   
CODE_03CA89:        18            CLC                       
CODE_03CA8A:        65 08         ADC $08                   
CODE_03CA8C:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_03CA8F:        A5 03         LDA $03                   
CODE_03CA91:        18            CLC                       
CODE_03CA92:        65 09         ADC $09                   
CODE_03CA94:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_03CA97:        DA            PHX                       
CODE_03CA98:        A5 05         LDA $05                   
CODE_03CA9A:        29 03         AND.B #$03                
CODE_03CA9C:        85 0F         STA $0F                   
CODE_03CA9E:        0A            ASL                       
CODE_03CA9F:        0A            ASL                       
CODE_03CAA0:        0A            ASL                       
CODE_03CAA1:        65 0F         ADC $0F                   
CODE_03CAA3:        65 0F         ADC $0F                   
CODE_03CAA5:        65 07         ADC $07                   
CODE_03CAA7:        AA            TAX                       
CODE_03CAA8:        BD B9 C9      LDA.W DATA_03C9B9,X       
CODE_03CAAB:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_03CAAE:        FA            PLX                       
CODE_03CAAF:        A5 05         LDA $05                   
CODE_03CAB1:        4A            LSR                       
CODE_03CAB2:        EA            NOP                       
CODE_03CAB3:        EA            NOP                       
CODE_03CAB4:        DA            PHX                       
CODE_03CAB5:        A6 0A         LDX $0A                   
CODE_03CAB7:        E0 03         CPX.B #$03                
CODE_03CAB9:        F0 02         BEQ CODE_03CABD           
CODE_03CABB:        45 04         EOR $04                   
CODE_03CABD:        29 0E         AND.B #$0E                
CODE_03CABF:        09 31         ORA.B #$31                
CODE_03CAC1:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_03CAC4:        FA            PLX                       
CODE_03CAC5:        5A            PHY                       
CODE_03CAC6:        98            TYA                       
CODE_03CAC7:        4A            LSR                       
CODE_03CAC8:        4A            LSR                       
CODE_03CAC9:        A8            TAY                       
CODE_03CACA:        A9 00         LDA.B #$00                
CODE_03CACC:        99 20 04      STA.W $0420,Y             
CODE_03CACF:        7A            PLY                       
CODE_03CAD0:        C8            INY                       
CODE_03CAD1:        C8            INY                       
CODE_03CAD2:        C8            INY                       
CODE_03CAD3:        C8            INY                       
CODE_03CAD4:        CA            DEX                       
CODE_03CAD5:        30 03         BMI CODE_03CADA           
CODE_03CAD7:        4C 0D CA      JMP.W CODE_03CA0D         

CODE_03CADA:        A2 53         LDX.B #$53                
CODE_03CADC:        86 04         STX $04                   
CODE_03CADE:        A5 0A         LDA $0A                   
CODE_03CAE0:        C9 03         CMP.B #$03                
CODE_03CAE2:        BD 26 C6      LDA.W DATA_03C626,X       
CODE_03CAE5:        90 03         BCC CODE_03CAEA           
CODE_03CAE7:        BD CE C6      LDA.W DATA_03C6CE,X       
CODE_03CAEA:        38            SEC                       
CODE_03CAEB:        E9 40         SBC.B #$40                
CODE_03CAED:        85 00         STA $00                   
CODE_03CAEF:        A5 0A         LDA $0A                   
CODE_03CAF1:        C9 03         CMP.B #$03                
CODE_03CAF3:        BD 7A C6      LDA.W DATA_03C67A,X       
CODE_03CAF6:        90 03         BCC CODE_03CAFB           
CODE_03CAF8:        BD 22 C7      LDA.W DATA_03C722,X       
CODE_03CAFB:        38            SEC                       
CODE_03CAFC:        E9 50         SBC.B #$50                
CODE_03CAFE:        85 01         STA $01                   
CODE_03CB00:        5A            PHY                       
CODE_03CB01:        A5 00         LDA $00                   
CODE_03CB03:        10 03         BPL CODE_03CB08           
CODE_03CB05:        49 FF         EOR.B #$FF                
CODE_03CB07:        1A            INC A                     
CODE_03CB08:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_03CB0B:        A5 06         LDA $06                   
CODE_03CB0D:        8D 03 42      STA.W $4203               ; Multplier B
CODE_03CB10:        EA            NOP                       
CODE_03CB11:        EA            NOP                       
CODE_03CB12:        EA            NOP                       
CODE_03CB13:        EA            NOP                       
CODE_03CB14:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_03CB17:        A4 00         LDY $00                   
CODE_03CB19:        10 03         BPL CODE_03CB1E           
CODE_03CB1B:        49 FF         EOR.B #$FF                
CODE_03CB1D:        1A            INC A                     
CODE_03CB1E:        85 02         STA $02                   
CODE_03CB20:        A5 01         LDA $01                   
CODE_03CB22:        10 03         BPL CODE_03CB27           
CODE_03CB24:        49 FF         EOR.B #$FF                
CODE_03CB26:        1A            INC A                     
CODE_03CB27:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_03CB2A:        A5 06         LDA $06                   
CODE_03CB2C:        8D 03 42      STA.W $4203               ; Multplier B
CODE_03CB2F:        EA            NOP                       
CODE_03CB30:        EA            NOP                       
CODE_03CB31:        EA            NOP                       
CODE_03CB32:        EA            NOP                       
CODE_03CB33:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_03CB36:        A4 01         LDY $01                   
CODE_03CB38:        10 03         BPL CODE_03CB3D           
CODE_03CB3A:        49 FF         EOR.B #$FF                
CODE_03CB3C:        1A            INC A                     
CODE_03CB3D:        85 03         STA $03                   
CODE_03CB3F:        A0 00         LDY.B #$00                
CODE_03CB41:        A5 07         LDA $07                   
CODE_03CB43:        C9 06         CMP.B #$06                
CODE_03CB45:        90 0A         BCC CODE_03CB51           
CODE_03CB47:        A5 05         LDA $05                   
CODE_03CB49:        18            CLC                       
CODE_03CB4A:        65 04         ADC $04                   
CODE_03CB4C:        4A            LSR                       
CODE_03CB4D:        4A            LSR                       
CODE_03CB4E:        29 07         AND.B #$07                
CODE_03CB50:        A8            TAY                       
CODE_03CB51:        B9 E1 C9      LDA.W DATA_03C9E1,Y       
CODE_03CB54:        7A            PLY                       
CODE_03CB55:        18            CLC                       
CODE_03CB56:        65 02         ADC $02                   
CODE_03CB58:        18            CLC                       
CODE_03CB59:        65 08         ADC $08                   
CODE_03CB5B:        99 00 03      STA.W OAM_DispX,Y         
CODE_03CB5E:        A5 03         LDA $03                   
CODE_03CB60:        18            CLC                       
CODE_03CB61:        65 09         ADC $09                   
CODE_03CB63:        99 01 03      STA.W OAM_DispY,Y         
CODE_03CB66:        DA            PHX                       
CODE_03CB67:        A5 05         LDA $05                   
CODE_03CB69:        29 03         AND.B #$03                
CODE_03CB6B:        85 0F         STA $0F                   
CODE_03CB6D:        0A            ASL                       
CODE_03CB6E:        0A            ASL                       
CODE_03CB6F:        0A            ASL                       
CODE_03CB70:        65 0F         ADC $0F                   
CODE_03CB72:        65 0F         ADC $0F                   
CODE_03CB74:        65 07         ADC $07                   
CODE_03CB76:        AA            TAX                       
CODE_03CB77:        BD B9 C9      LDA.W DATA_03C9B9,X       
CODE_03CB7A:        99 02 03      STA.W OAM_Tile,Y          
CODE_03CB7D:        FA            PLX                       
CODE_03CB7E:        A5 05         LDA $05                   
CODE_03CB80:        4A            LSR                       
CODE_03CB81:        EA            NOP                       
CODE_03CB82:        EA            NOP                       
CODE_03CB83:        DA            PHX                       
CODE_03CB84:        A6 0A         LDX $0A                   
CODE_03CB86:        E0 03         CPX.B #$03                
CODE_03CB88:        F0 02         BEQ CODE_03CB8C           
CODE_03CB8A:        45 04         EOR $04                   
CODE_03CB8C:        29 0E         AND.B #$0E                
CODE_03CB8E:        09 31         ORA.B #$31                
CODE_03CB90:        99 03 03      STA.W OAM_Prop,Y          
CODE_03CB93:        FA            PLX                       
CODE_03CB94:        5A            PHY                       
CODE_03CB95:        98            TYA                       
CODE_03CB96:        4A            LSR                       
CODE_03CB97:        4A            LSR                       
CODE_03CB98:        A8            TAY                       
CODE_03CB99:        A9 00         LDA.B #$00                
CODE_03CB9B:        99 60 04      STA.W OAM_TileSize,Y      
CODE_03CB9E:        7A            PLY                       
CODE_03CB9F:        C8            INY                       
CODE_03CBA0:        C8            INY                       
CODE_03CBA1:        C8            INY                       
CODE_03CBA2:        C8            INY                       
CODE_03CBA3:        CA            DEX                       
CODE_03CBA4:        E0 3F         CPX.B #$3F                
CODE_03CBA6:        F0 03         BEQ CODE_03CBAB           
CODE_03CBA8:        4C DC CA      JMP.W CODE_03CADC         

CODE_03CBAB:        FA            PLX                       
Return03CBAC:       60            RTS                       ; Return 


ChuckSprGenDispX:                 .db $14,$EC

ChuckSprGenSpeedHi:               .db $00,$FF

ChuckSprGenSpeedLo:               .db $18,$E8

CODE_03CBB3:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_03CBB7:        30 4F         BMI Return03CC08          ; / 
CODE_03CBB9:        A9 1B         LDA.B #$1B                ; \ Sprite = Football 
CODE_03CBBB:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
CODE_03CBBE:        DA            PHX                       
CODE_03CBBF:        BB            TYX                       
CODE_03CBC0:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_03CBC4:        FA            PLX                       
CODE_03CBC5:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_03CBC7:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_03CBCA:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03CBCC:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_03CBCF:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03CBD2:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_03CBD5:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03CBD7:        85 01         STA $01                   
CODE_03CBD9:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03CBDC:        85 00         STA $00                   
CODE_03CBDE:        DA            PHX                       
CODE_03CBDF:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_03CBE2:        AA            TAX                       
CODE_03CBE3:        A5 01         LDA $01                   
CODE_03CBE5:        18            CLC                       
CODE_03CBE6:        7F AD CB 03   ADC.L ChuckSprGenDispX,X  
CODE_03CBEA:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_03CBED:        A5 00         LDA $00                   
CODE_03CBEF:        7F AF CB 03   ADC.L ChuckSprGenSpeedHi,X 
CODE_03CBF3:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_03CBF6:        BF B1 CB 03   LDA.L ChuckSprGenSpeedLo,X 
CODE_03CBFA:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_03CBFD:        A9 E0         LDA.B #$E0                
CODE_03CBFF:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_03CC02:        A9 10         LDA.B #$10                
CODE_03CC04:        99 40 15      STA.W $1540,Y             
CODE_03CC07:        FA            PLX                       
Return03CC08:       6B            RTL                       ; Return 

CODE_03CC09:        8B            PHB                       ; Wrapper 
CODE_03CC0A:        4B            PHK                       
CODE_03CC0B:        AB            PLB                       
CODE_03CC0C:        9E 62 16      STZ.W RAM_Tweaker1662,X   
CODE_03CC0F:        20 14 CC      JSR.W CODE_03CC14         
CODE_03CC12:        AB            PLB                       
Return03CC13:       6B            RTL                       ; Return 

CODE_03CC14:        20 84 D4      JSR.W CODE_03D484         
CODE_03CC17:        BD C8 14      LDA.W $14C8,X             
CODE_03CC1A:        C9 08         CMP.B #$08                
CODE_03CC1C:        D0 19         BNE Return03CC37          
CODE_03CC1E:        A5 9D         LDA RAM_SpritesLocked     
CODE_03CC20:        D0 15         BNE Return03CC37          
CODE_03CC22:        BD 1C 15      LDA.W $151C,X             
CODE_03CC25:        22 DF 86 00   JSL.L ExecutePtr          

PipeKoopaPtrs:         8A CC      .dw CODE_03CC8A           
                       21 CD      .dw CODE_03CD21           
                       C7 CD      .dw CODE_03CDC7           
                       EF CD      .dw CODE_03CDEF           
                       0E CE      .dw CODE_03CE0E           
                       5A CE      .dw CODE_03CE5A           
                       89 CE      .dw CODE_03CE89           

Return03CC37:       60            RTS                       ; Return 


DATA_03CC38:                      .db $18,$38,$58,$78,$98,$B8,$D8,$78
DATA_03CC40:                      .db $40,$50,$50,$40,$30,$40,$50,$40
DATA_03CC48:                      .db $50,$4A,$50,$4A,$4A,$40,$4A,$48
                                  .db $4A

DATA_03CC51:                      .db $02,$04,$06,$08,$0B,$0C,$0E,$10
                                  .db $13

DATA_03CC5A:                      .db $00,$01,$02,$03,$04,$05,$06,$00
                                  .db $01,$02,$03,$04,$05,$06,$00,$01
                                  .db $02,$03,$04,$05,$06,$00,$01,$02
                                  .db $03,$04,$05,$06,$00,$01,$02,$03
                                  .db $04,$05,$06,$00,$01,$02,$03,$04
                                  .db $05,$06,$00,$01,$02,$03,$04,$05

CODE_03CC8A:        BD 40 15      LDA.W $1540,X             
CODE_03CC8D:        D0 50         BNE Return03CCDF          
CODE_03CC8F:        BD 70 15      LDA.W $1570,X             
CODE_03CC92:        D0 09         BNE CODE_03CC9D           
CODE_03CC94:        22 F9 AC 01   JSL.L GetRand             
CODE_03CC98:        29 0F         AND.B #$0F                
CODE_03CC9A:        9D 0E 16      STA.W $160E,X             
CODE_03CC9D:        BD 0E 16      LDA.W $160E,X             
CODE_03CCA0:        1D 70 15      ORA.W $1570,X             
CODE_03CCA3:        A8            TAY                       
CODE_03CCA4:        B9 5A CC      LDA.W DATA_03CC5A,Y       
CODE_03CCA7:        A8            TAY                       
CODE_03CCA8:        B9 38 CC      LDA.W DATA_03CC38,Y       
CODE_03CCAB:        95 E4         STA RAM_SpriteXLo,X       
CODE_03CCAD:        B5 C2         LDA RAM_SpriteState,X     
CODE_03CCAF:        C9 06         CMP.B #$06                
CODE_03CCB1:        B9 40 CC      LDA.W DATA_03CC40,Y       
CODE_03CCB4:        90 02         BCC CODE_03CCB8           
CODE_03CCB6:        A9 50         LDA.B #$50                
CODE_03CCB8:        95 D8         STA RAM_SpriteYLo,X       
CODE_03CCBA:        A9 08         LDA.B #$08                
CODE_03CCBC:        BC 70 15      LDY.W $1570,X             
CODE_03CCBF:        D0 0B         BNE CODE_03CCCC           
CODE_03CCC1:        20 E2 CC      JSR.W CODE_03CCE2         
CODE_03CCC4:        22 F9 AC 01   JSL.L GetRand             
CODE_03CCC8:        4A            LSR                       
CODE_03CCC9:        4A            LSR                       
CODE_03CCCA:        29 07         AND.B #$07                
CODE_03CCCC:        9D 28 15      STA.W $1528,X             
CODE_03CCCF:        A8            TAY                       
CODE_03CCD0:        B9 48 CC      LDA.W DATA_03CC48,Y       
CODE_03CCD3:        9D 40 15      STA.W $1540,X             
CODE_03CCD6:        FE 1C 15      INC.W $151C,X             
CODE_03CCD9:        B9 51 CC      LDA.W DATA_03CC51,Y       
CODE_03CCDC:        9D 02 16      STA.W $1602,X             
Return03CCDF:       60            RTS                       ; Return 


DATA_03CCE0:                      .db $10,$20

CODE_03CCE2:        A0 01         LDY.B #$01                
CODE_03CCE4:        20 E8 CC      JSR.W CODE_03CCE8         
CODE_03CCE7:        88            DEY                       
CODE_03CCE8:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_03CCEA:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_03CCED:        A9 29         LDA.B #$29                
CODE_03CCEF:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_03CCF2:        DA            PHX                       
CODE_03CCF3:        BB            TYX                       
CODE_03CCF4:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_03CCF8:        FA            PLX                       
CODE_03CCF9:        B9 E0 CC      LDA.W DATA_03CCE0,Y       
CODE_03CCFC:        99 70 15      STA.W $1570,Y             
CODE_03CCFF:        B5 C2         LDA RAM_SpriteState,X     
CODE_03CD01:        99 C2 00      STA.W RAM_SpriteState,Y   
CODE_03CD04:        BD 0E 16      LDA.W $160E,X             
CODE_03CD07:        99 0E 16      STA.W $160E,Y             
CODE_03CD0A:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03CD0C:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_03CD0F:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03CD12:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_03CD15:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03CD17:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_03CD1A:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03CD1D:        99 D4 14      STA.W RAM_SpriteYHi,Y     
Return03CD20:       60            RTS                       ; Return 

CODE_03CD21:        BD 40 15      LDA.W $1540,X             
CODE_03CD24:        D0 08         BNE CODE_03CD2E           
CODE_03CD26:        A9 40         LDA.B #$40                
CODE_03CD28:        9D 40 15      STA.W $1540,X             
CODE_03CD2B:        FE 1C 15      INC.W $151C,X             
CODE_03CD2E:        A9 F8         LDA.B #$F8                
CODE_03CD30:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03CD32:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
Return03CD36:       60            RTS                       ; Return 


DATA_03CD37:                      .db $02,$02,$02,$02,$03,$03,$03,$03
                                  .db $03,$03,$03,$03,$02,$02,$02,$02
                                  .db $04,$04,$04,$04,$05,$05,$04,$05
                                  .db $05,$04,$05,$05,$04,$04,$04,$04
                                  .db $06,$06,$06,$06,$07,$07,$07,$07
                                  .db $07,$07,$07,$07,$06,$06,$06,$06
                                  .db $08,$08,$08,$08,$08,$09,$09,$08
                                  .db $08,$09,$09,$08,$08,$08,$08,$08
                                  .db $0B,$0B,$0B,$0B,$0B,$0A,$0B,$0A
                                  .db $0B,$0A,$0B,$0A,$0B,$0B,$0B,$0B
                                  .db $0C,$0C,$0C,$0C,$0D,$0C,$0D,$0C
                                  .db $0D,$0C,$0D,$0C,$0D,$0D,$0D,$0D
                                  .db $0E,$0E,$0E,$0E,$0E,$0F,$0E,$0F
                                  .db $0E,$0F,$0E,$0F,$0E,$0E,$0E,$0E
                                  .db $10,$10,$10,$10,$11,$12,$11,$10
                                  .db $11,$12,$11,$10,$11,$11,$11,$11
                                  .db $13,$13,$13,$13,$13,$13,$13,$13
                                  .db $13,$13,$13,$13,$13,$13,$13,$13

CODE_03CDC7:        20 A7 CE      JSR.W CODE_03CEA7         
CODE_03CDCA:        BD 40 15      LDA.W $1540,X             
CODE_03CDCD:        D0 0B         BNE CODE_03CDDA           
CODE_03CDCF:        A9 24         LDA.B #$24                
CODE_03CDD1:        9D 40 15      STA.W $1540,X             
CODE_03CDD4:        A9 03         LDA.B #$03                
CODE_03CDD6:        9D 1C 15      STA.W $151C,X             
Return03CDD9:       60            RTS                       ; Return 

CODE_03CDDA:        4A            LSR                       
CODE_03CDDB:        4A            LSR                       
CODE_03CDDC:        85 00         STA $00                   
CODE_03CDDE:        BD 28 15      LDA.W $1528,X             
CODE_03CDE1:        0A            ASL                       
CODE_03CDE2:        0A            ASL                       
CODE_03CDE3:        0A            ASL                       
CODE_03CDE4:        0A            ASL                       
CODE_03CDE5:        05 00         ORA $00                   
CODE_03CDE7:        A8            TAY                       
CODE_03CDE8:        B9 37 CD      LDA.W DATA_03CD37,Y       
CODE_03CDEB:        9D 02 16      STA.W $1602,X             
Return03CDEE:       60            RTS                       ; Return 

CODE_03CDEF:        BD 40 15      LDA.W $1540,X             
CODE_03CDF2:        D0 11         BNE CODE_03CE05           
CODE_03CDF4:        BD 70 15      LDA.W $1570,X             
CODE_03CDF7:        F0 04         BEQ CODE_03CDFD           
CODE_03CDF9:        9E C8 14      STZ.W $14C8,X             
Return03CDFC:       60            RTS                       ; Return 

CODE_03CDFD:        9E 1C 15      STZ.W $151C,X             
CODE_03CE00:        A9 30         LDA.B #$30                
CODE_03CE02:        9D 40 15      STA.W $1540,X             
CODE_03CE05:        A9 10         LDA.B #$10                
CODE_03CE07:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03CE09:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
Return03CE0D:       60            RTS                       ; Return 

CODE_03CE0E:        BD 40 15      LDA.W $1540,X             
CODE_03CE11:        D0 17         BNE CODE_03CE2A           
CODE_03CE13:        FE 34 15      INC.W $1534,X             
CODE_03CE16:        BD 34 15      LDA.W $1534,X             
CODE_03CE19:        C9 03         CMP.B #$03                
CODE_03CE1B:        D0 B2         BNE CODE_03CDCF           
CODE_03CE1D:        A9 05         LDA.B #$05                
CODE_03CE1F:        9D 1C 15      STA.W $151C,X             
CODE_03CE22:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_03CE24:        A9 23         LDA.B #$23                
CODE_03CE26:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
Return03CE29:       60            RTS                       ; Return 

CODE_03CE2A:        BC 70 15      LDY.W $1570,X             
CODE_03CE2D:        D0 13         BNE CODE_03CE42           
CODE_03CE2F:        C9 24         CMP.B #$24                
CODE_03CE31:        D0 05         BNE CODE_03CE38           
CODE_03CE33:        A0 29         LDY.B #$29                
CODE_03CE35:        8C FC 1D      STY.W $1DFC               ; / Play sound effect 
CODE_03CE38:        A5 14         LDA RAM_FrameCounterB     
CODE_03CE3A:        4A            LSR                       
CODE_03CE3B:        4A            LSR                       
CODE_03CE3C:        29 01         AND.B #$01                
CODE_03CE3E:        9D 02 16      STA.W $1602,X             
Return03CE41:       60            RTS                       ; Return 

CODE_03CE42:        C9 10         CMP.B #$10                
CODE_03CE44:        D0 05         BNE CODE_03CE4B           
CODE_03CE46:        A0 2A         LDY.B #$2A                
CODE_03CE48:        8C FC 1D      STY.W $1DFC               ; / Play sound effect 
CODE_03CE4B:        4A            LSR                       
CODE_03CE4C:        4A            LSR                       
CODE_03CE4D:        4A            LSR                       
CODE_03CE4E:        A8            TAY                       
CODE_03CE4F:        B9 56 CE      LDA.W DATA_03CE56,Y       
CODE_03CE52:        9D 02 16      STA.W $1602,X             
Return03CE55:       60            RTS                       ; Return 


DATA_03CE56:                      .db $16,$16,$15,$14

CODE_03CE5A:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_03CE5E:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_03CE60:        C9 40         CMP.B #$40                
CODE_03CE62:        10 05         BPL CODE_03CE69           
CODE_03CE64:        18            CLC                       
CODE_03CE65:        69 03         ADC.B #$03                
CODE_03CE67:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03CE69:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03CE6C:        F0 19         BEQ CODE_03CE87           
CODE_03CE6E:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03CE70:        C9 85         CMP.B #$85                
CODE_03CE72:        90 13         BCC CODE_03CE87           
CODE_03CE74:        A9 06         LDA.B #$06                
CODE_03CE76:        9D 1C 15      STA.W $151C,X             
CODE_03CE79:        A9 80         LDA.B #$80                
CODE_03CE7B:        9D 40 15      STA.W $1540,X             
CODE_03CE7E:        A9 20         LDA.B #$20                
CODE_03CE80:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_03CE83:        22 28 85 02   JSL.L CODE_028528         
CODE_03CE87:        80 A6         BRA CODE_03CE2F           

CODE_03CE89:        BD 40 15      LDA.W $1540,X             
CODE_03CE8C:        D0 10         BNE CODE_03CE9E           
CODE_03CE8E:        9E C8 14      STZ.W $14C8,X             
CODE_03CE91:        EE C6 13      INC.W $13C6               
CODE_03CE94:        A9 FF         LDA.B #$FF                
CODE_03CE96:        8D 93 14      STA.W $1493               
CODE_03CE99:        A9 0B         LDA.B #$0B                
CODE_03CE9B:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_03CE9E:        A9 04         LDA.B #$04                
CODE_03CEA0:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_03CEA2:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
Return03CEA6:       60            RTS                       ; Return 

CODE_03CEA7:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_03CEAB:        90 44         BCC Return03CEF1          
CODE_03CEAD:        A5 7D         LDA RAM_MarioSpeedY       
CODE_03CEAF:        C9 10         CMP.B #$10                
CODE_03CEB1:        30 3A         BMI CODE_03CEED           
CODE_03CEB3:        22 99 AB 01   JSL.L DisplayContactGfx   
CODE_03CEB7:        A9 02         LDA.B #$02                
CODE_03CEB9:        22 E5 AC 02   JSL.L GivePoints          
CODE_03CEBD:        22 33 AA 01   JSL.L BoostMarioSpeed     
CODE_03CEC1:        A9 02         LDA.B #$02                
CODE_03CEC3:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_03CEC6:        BD 70 15      LDA.W $1570,X             
CODE_03CEC9:        D0 10         BNE CODE_03CEDB           
CODE_03CECB:        A9 28         LDA.B #$28                
CODE_03CECD:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_03CED0:        BD 34 15      LDA.W $1534,X             
CODE_03CED3:        C9 02         CMP.B #$02                
CODE_03CED5:        D0 04         BNE CODE_03CEDB           
CODE_03CED7:        22 C8 A6 03   JSL.L KillMostSprites     
CODE_03CEDB:        A9 04         LDA.B #$04                
CODE_03CEDD:        9D 1C 15      STA.W $151C,X             
CODE_03CEE0:        A9 50         LDA.B #$50                
CODE_03CEE2:        BC 70 15      LDY.W $1570,X             
CODE_03CEE5:        F0 02         BEQ CODE_03CEE9           
CODE_03CEE7:        A9 1F         LDA.B #$1F                
CODE_03CEE9:        9D 40 15      STA.W $1540,X             
Return03CEEC:       60            RTS                       ; Return 

CODE_03CEED:        22 B7 F5 00   JSL.L HurtMario           
Return03CEF1:       60            RTS                       ; Return 


DATA_03CEF2:                      .db $F8,$08,$F8,$08,$00,$00,$F8,$08
                                  .db $F8,$08,$00,$00,$F8,$00,$00,$00
                                  .db $00,$00,$FB,$00,$FB,$03,$00,$00
                                  .db $F8,$08,$00,$00,$08,$00,$F8,$08
                                  .db $00,$00,$00,$00,$F8,$00,$00,$00
                                  .db $00,$00,$F8,$00,$08,$00,$00,$00
                                  .db $F8,$08,$00,$06,$00,$00,$F8,$08
                                  .db $00,$02,$00,$00,$F8,$08,$00,$04
                                  .db $00,$08,$F8,$08,$00,$00,$08,$00
                                  .db $F8,$08,$00,$00,$00,$00,$F8,$08
                                  .db $00,$00,$00,$00,$F8,$08,$00,$00
                                  .db $08,$00,$F8,$08,$00,$00,$08,$00
                                  .db $F8,$08,$00,$00,$00,$00,$F8,$08
                                  .db $00,$00,$00,$00,$F8,$08,$00,$00
                                  .db $00,$00,$F8,$08,$00,$00,$08,$00
                                  .db $F8,$08,$00,$00,$00,$00,$F8,$08
                                  .db $00,$00,$00,$00,$F8,$08,$00,$00
                                  .db $00,$00

DATA_03CF7C:                      .db $F8,$08,$F8,$08,$00,$00,$F8,$08
                                  .db $F8,$08,$00,$00,$F8,$00,$08,$00
                                  .db $00,$00,$FB,$00,$FB,$03,$00,$00
                                  .db $F8,$08,$00,$00,$08,$00,$F8,$08
                                  .db $00,$00,$00,$00,$F8,$00,$08,$00
                                  .db $00,$00,$F8,$00,$08,$00,$00,$00
                                  .db $F8,$08,$00,$06,$00,$08,$F8,$08
                                  .db $00,$02,$00,$08,$F8,$08,$00,$04
                                  .db $00,$08,$F8,$08,$00,$00,$08,$00
                                  .db $F8,$08,$00,$00,$00,$00,$F8,$08
                                  .db $00,$00,$00,$00,$F8,$08,$00,$00
                                  .db $08,$00,$F8,$08,$00,$00,$08,$00
                                  .db $F8,$08,$00,$00,$00,$00,$F8,$08
                                  .db $00,$00,$00,$00,$F8,$08,$00,$00
                                  .db $00,$00,$F8,$08,$00,$00,$08,$00
                                  .db $F8,$08,$00,$00,$00,$00,$F8,$08
                                  .db $00,$00,$00,$00,$F8,$08,$00,$00
                                  .db $00,$00

DATA_03D006:                      .db $04,$04,$14,$14,$00,$00,$04,$04
                                  .db $14,$14,$00,$00,$00,$08,$F8,$00
                                  .db $00,$00,$00,$08,$F8,$F8,$00,$00
                                  .db $05,$05,$00,$F8,$F8,$00,$05,$05
                                  .db $00,$00,$00,$00,$00,$08,$F8,$00
                                  .db $00,$00,$00,$08,$00,$00,$00,$00
                                  .db $05,$05,$00,$F8,$00,$00,$05,$05
                                  .db $00,$F8,$00,$00,$05,$05,$00,$0F
                                  .db $F8,$F8,$05,$05,$00,$F8,$F8,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$05,$05,$00,$F8
                                  .db $F8,$00,$05,$05,$00,$F8,$F8,$00
                                  .db $04,$04,$02,$00,$00,$00,$04,$04
                                  .db $01,$00,$00,$00,$04,$04,$00,$00
                                  .db $00,$00,$05,$05,$00,$F8,$F8,$00
                                  .db $05,$05,$00,$00,$00,$00,$05,$05
                                  .db $03,$00,$00,$00,$05,$05,$04,$00
                                  .db $00,$00

DATA_03D090:                      .db $04,$04,$14,$14,$00,$00,$04,$04
                                  .db $14,$14,$00,$00,$00,$08,$00,$00
                                  .db $00,$00,$00,$08,$F8,$F8,$00,$00
                                  .db $05,$05,$00,$F8,$F8,$00,$05,$05
                                  .db $00,$00,$00,$00,$00,$08,$00,$00
                                  .db $00,$00,$00,$08,$08,$00,$00,$00
                                  .db $05,$05,$00,$F8,$F8,$00,$05,$05
                                  .db $00,$F8,$F8,$00,$05,$05,$00,$0F
                                  .db $F8,$F8,$05,$05,$00,$F8,$F8,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$05,$05,$00,$F8
                                  .db $F8,$00,$05,$05,$00,$F8,$F8,$00
                                  .db $04,$04,$02,$00,$00,$00,$04,$04
                                  .db $01,$00,$00,$00,$04,$04,$00,$00
                                  .db $00,$00,$05,$05,$00,$F8,$F8,$00
                                  .db $05,$05,$00,$00,$00,$00,$05,$05
                                  .db $03,$00,$00,$00,$05,$05,$04,$00
                                  .db $00,$00

DATA_03D11A:                      .db $20,$20,$26,$26,$08,$00,$2E,$2E
                                  .db $24,$24,$08,$00,$00,$28,$02,$00
                                  .db $00,$00,$04,$28,$12,$12,$00,$00
                                  .db $22,$22,$04,$12,$12,$00,$20,$20
                                  .db $08,$00,$00,$00,$00,$28,$02,$00
                                  .db $00,$00,$0A,$28,$13,$00,$00,$00
                                  .db $20,$20,$0C,$02,$00,$00,$20,$20
                                  .db $0C,$02,$00,$00,$22,$22,$06,$03
                                  .db $12,$12,$20,$20,$06,$12,$12,$00
                                  .db $2A,$2A,$00,$00,$00,$00,$2C,$2C
                                  .db $00,$00,$00,$00,$20,$20,$06,$12
                                  .db $12,$00,$20,$20,$06,$12,$12,$00
                                  .db $22,$22,$08,$00,$00,$00,$20,$20
                                  .db $08,$00,$00,$00,$2E,$2E,$08,$00
                                  .db $00,$00,$4E,$4E,$60,$43,$43,$00
                                  .db $4E,$4E,$64,$00,$00,$00,$62,$62
                                  .db $64,$00,$00,$00,$62,$62,$64,$00
                                  .db $00,$00

DATA_03D1A4:                      .db $20,$20,$26,$26,$48,$00,$2E,$2E
                                  .db $24,$24,$48,$00,$40,$28,$42,$00
                                  .db $00,$00,$44,$28,$52,$52,$00,$00
                                  .db $22,$22,$44,$52,$52,$00,$20,$20
                                  .db $48,$00,$00,$00,$40,$28,$42,$00
                                  .db $00,$00,$4A,$28,$53,$00,$00,$00
                                  .db $20,$20,$4C,$1E,$1F,$00,$20,$20
                                  .db $4C,$1F,$1E,$00,$22,$22,$44,$03
                                  .db $52,$52,$20,$20,$44,$52,$52,$00
                                  .db $2A,$2A,$00,$00,$00,$00,$2C,$2C
                                  .db $00,$00,$00,$00,$20,$20,$46,$52
                                  .db $52,$00,$20,$20,$46,$52,$52,$00
                                  .db $22,$22,$48,$00,$00,$00,$20,$20
                                  .db $48,$00,$00,$00,$2E,$2E,$48,$00
                                  .db $00,$00,$4E,$4E,$66,$68,$68,$00
                                  .db $4E,$4E,$6A,$00,$00,$00,$62,$62
                                  .db $6A,$00,$00,$00,$62,$62,$6A,$00
                                  .db $00,$00

LemmyGfxProp:                     .db $05,$45,$05,$45,$05,$00,$05,$45
                                  .db $05,$45,$05,$00,$05,$05,$05,$00
                                  .db $00,$00,$05,$05,$05,$45,$00,$00
                                  .db $05,$45,$05,$05,$45,$00,$05,$45
                                  .db $05,$00,$00,$00,$05,$05,$05,$00
                                  .db $00,$00,$05,$05,$05,$00,$00,$00
                                  .db $05,$45,$05,$05,$00,$00,$05,$45
                                  .db $45,$45,$00,$00,$05,$45,$05,$05
                                  .db $05,$45,$05,$45,$45,$05,$45,$00
                                  .db $05,$45,$00,$00,$00,$00,$05,$45
                                  .db $00,$00,$00,$00,$05,$45,$45,$05
                                  .db $45,$00,$05,$45,$05,$05,$45,$00
                                  .db $05,$45,$05,$00,$00,$00,$05,$45
                                  .db $05,$00,$00,$00,$05,$45,$05,$00
                                  .db $00,$00,$07,$47,$07,$07,$47,$00
                                  .db $07,$47,$07,$00,$00,$00,$07,$47
                                  .db $07,$00,$00,$00,$07,$47,$07,$00
                                  .db $00,$00

WendyGfxProp:                     .db $09,$49,$09,$49,$09,$00,$09,$49
                                  .db $09,$49,$09,$00,$09,$09,$09,$00
                                  .db $00,$00,$09,$09,$09,$49,$00,$00
                                  .db $09,$49,$09,$09,$49,$00,$09,$49
                                  .db $09,$00,$00,$00,$09,$09,$09,$00
                                  .db $00,$00,$09,$09,$09,$00,$00,$00
                                  .db $09,$49,$09,$09,$09,$00,$09,$49
                                  .db $49,$49,$49,$00,$09,$49,$09,$09
                                  .db $09,$49,$09,$49,$49,$09,$49,$00
                                  .db $09,$49,$00,$00,$00,$00,$09,$49
                                  .db $00,$00,$00,$00,$09,$49,$49,$09
                                  .db $49,$00,$09,$49,$09,$09,$49,$00
                                  .db $09,$49,$09,$00,$00,$00,$09,$49
                                  .db $09,$00,$00,$00,$09,$49,$09,$00
                                  .db $00,$00,$05,$45,$05,$05,$45,$00
                                  .db $05,$45,$05,$00,$00,$00,$05,$45
                                  .db $05,$00,$00,$00,$05,$45,$05,$00
                                  .db $00,$00

DATA_03D342:                      .db $02,$02,$02,$02,$02,$04,$02,$02
                                  .db $02,$02,$02,$04,$02,$02,$00,$04
                                  .db $04,$04,$02,$02,$00,$00,$04,$04
                                  .db $02,$02,$02,$00,$00,$04,$02,$02
                                  .db $02,$04,$04,$04,$02,$02,$00,$04
                                  .db $04,$04,$02,$02,$00,$04,$04,$04
                                  .db $02,$02,$02,$00,$04,$04,$02,$02
                                  .db $02,$00,$04,$04,$02,$02,$02,$00
                                  .db $00,$00,$02,$02,$02,$00,$00,$04
                                  .db $02,$02,$04,$04,$04,$04,$02,$02
                                  .db $04,$04,$04,$04,$02,$02,$02,$00
                                  .db $00,$04,$02,$02,$02,$00,$00,$04
                                  .db $02,$02,$02,$04,$04,$04,$02,$02
                                  .db $02,$04,$04,$04,$02,$02,$02,$04
                                  .db $04,$04,$02,$02,$02,$00,$00,$04
                                  .db $02,$02,$02,$04,$04,$04,$02,$02
                                  .db $02,$04,$04,$04,$02,$02,$02,$04
                                  .db $04,$04

DATA_03D3CC:                      .db $02,$02,$02,$02,$02,$04,$02,$02
                                  .db $02,$02,$02,$04,$02,$02,$00,$04
                                  .db $04,$04,$02,$02,$00,$00,$04,$04
                                  .db $02,$02,$02,$00,$00,$04,$02,$02
                                  .db $02,$04,$04,$04,$02,$02,$00,$04
                                  .db $04,$04,$02,$02,$00,$04,$04,$04
                                  .db $02,$02,$02,$00,$00,$04,$02,$02
                                  .db $02,$00,$00,$04,$02,$02,$02,$00
                                  .db $00,$00,$02,$02,$02,$00,$00,$04
                                  .db $02,$02,$04,$04,$04,$04,$02,$02
                                  .db $04,$04,$04,$04,$02,$02,$02,$00
                                  .db $00,$04,$02,$02,$02,$00,$00,$04
                                  .db $02,$02,$02,$04,$04,$04,$02,$02
                                  .db $02,$04,$04,$04,$02,$02,$02,$04
                                  .db $04,$04,$02,$02,$02,$00,$00,$04
                                  .db $02,$02,$02,$04,$04,$04,$02,$02
                                  .db $02,$04,$04,$04,$02,$02,$02,$04
                                  .db $04,$04

DATA_03D456:                      .db $04,$04,$02,$03,$04,$02,$02,$02
                                  .db $03,$03,$05,$04,$01,$01,$04,$04
                                  .db $02,$02,$02,$04,$02,$02,$02

DATA_03D46D:                      .db $04,$04,$02,$03,$04,$02,$02,$02
                                  .db $04,$04,$05,$04,$01,$01,$04,$04
                                  .db $02,$02,$02,$04,$02,$02,$02

CODE_03D484:        20 60 B7      JSR.W GetDrawInfoBnk3     
CODE_03D487:        BD 02 16      LDA.W $1602,X             
CODE_03D48A:        0A            ASL                       
CODE_03D48B:        0A            ASL                       
CODE_03D48C:        7D 02 16      ADC.W $1602,X             
CODE_03D48F:        7D 02 16      ADC.W $1602,X             
CODE_03D492:        85 02         STA $02                   
CODE_03D494:        B5 C2         LDA RAM_SpriteState,X     
CODE_03D496:        C9 06         CMP.B #$06                
CODE_03D498:        F0 45         BEQ CODE_03D4DF           
CODE_03D49A:        DA            PHX                       
CODE_03D49B:        BD 02 16      LDA.W $1602,X             
CODE_03D49E:        AA            TAX                       
CODE_03D49F:        BD 56 D4      LDA.W DATA_03D456,X       
CODE_03D4A2:        AA            TAX                       
CODE_03D4A3:        DA            PHX                       
CODE_03D4A4:        8A            TXA                       
CODE_03D4A5:        18            CLC                       
CODE_03D4A6:        65 02         ADC $02                   
CODE_03D4A8:        AA            TAX                       
CODE_03D4A9:        A5 00         LDA $00                   
CODE_03D4AB:        18            CLC                       
CODE_03D4AC:        7D F2 CE      ADC.W DATA_03CEF2,X       
CODE_03D4AF:        99 00 03      STA.W OAM_DispX,Y         
CODE_03D4B2:        A5 01         LDA $01                   
CODE_03D4B4:        18            CLC                       
CODE_03D4B5:        7D 06 D0      ADC.W DATA_03D006,X       
CODE_03D4B8:        99 01 03      STA.W OAM_DispY,Y         
CODE_03D4BB:        BD 1A D1      LDA.W DATA_03D11A,X       
CODE_03D4BE:        99 02 03      STA.W OAM_Tile,Y          
CODE_03D4C1:        BD 2E D2      LDA.W LemmyGfxProp,X      
CODE_03D4C4:        09 10         ORA.B #$10                
CODE_03D4C6:        99 03 03      STA.W OAM_Prop,Y          
CODE_03D4C9:        5A            PHY                       
CODE_03D4CA:        98            TYA                       
CODE_03D4CB:        4A            LSR                       
CODE_03D4CC:        4A            LSR                       
CODE_03D4CD:        A8            TAY                       
CODE_03D4CE:        BD 42 D3      LDA.W DATA_03D342,X       
CODE_03D4D1:        99 60 04      STA.W OAM_TileSize,Y      
CODE_03D4D4:        7A            PLY                       
CODE_03D4D5:        C8            INY                       
CODE_03D4D6:        C8            INY                       
CODE_03D4D7:        C8            INY                       
CODE_03D4D8:        C8            INY                       
CODE_03D4D9:        FA            PLX                       
CODE_03D4DA:        CA            DEX                       
CODE_03D4DB:        10 C6         BPL CODE_03D4A3           
CODE_03D4DD:        FA            PLX                       
Return03D4DE:       60            RTS                       ; Return 

CODE_03D4DF:        DA            PHX                       
CODE_03D4E0:        BD 02 16      LDA.W $1602,X             
CODE_03D4E3:        AA            TAX                       
CODE_03D4E4:        BD 6D D4      LDA.W DATA_03D46D,X       
CODE_03D4E7:        AA            TAX                       
CODE_03D4E8:        DA            PHX                       
CODE_03D4E9:        8A            TXA                       
CODE_03D4EA:        18            CLC                       
CODE_03D4EB:        65 02         ADC $02                   
CODE_03D4ED:        AA            TAX                       
CODE_03D4EE:        A5 00         LDA $00                   
CODE_03D4F0:        18            CLC                       
CODE_03D4F1:        7D 7C CF      ADC.W DATA_03CF7C,X       
CODE_03D4F4:        99 00 03      STA.W OAM_DispX,Y         
CODE_03D4F7:        A5 01         LDA $01                   
CODE_03D4F9:        18            CLC                       
CODE_03D4FA:        7D 90 D0      ADC.W DATA_03D090,X       
CODE_03D4FD:        99 01 03      STA.W OAM_DispY,Y         
CODE_03D500:        BD A4 D1      LDA.W DATA_03D1A4,X       
CODE_03D503:        99 02 03      STA.W OAM_Tile,Y          
CODE_03D506:        BD B8 D2      LDA.W WendyGfxProp,X      
CODE_03D509:        09 10         ORA.B #$10                
CODE_03D50B:        99 03 03      STA.W OAM_Prop,Y          
CODE_03D50E:        5A            PHY                       
CODE_03D50F:        98            TYA                       
CODE_03D510:        4A            LSR                       
CODE_03D511:        4A            LSR                       
CODE_03D512:        A8            TAY                       
CODE_03D513:        BD CC D3      LDA.W DATA_03D3CC,X       
CODE_03D516:        99 60 04      STA.W OAM_TileSize,Y      
CODE_03D519:        7A            PLY                       
CODE_03D51A:        C8            INY                       
CODE_03D51B:        C8            INY                       
CODE_03D51C:        C8            INY                       
CODE_03D51D:        C8            INY                       
CODE_03D51E:        FA            PLX                       
CODE_03D51F:        CA            DEX                       
CODE_03D520:        10 C6         BPL CODE_03D4E8           
CODE_03D522:        80 B9         BRA CODE_03D4DD           


DATA_03D524:                      .db $18,$20

DATA_03D526:                      .db $A1,$0E,$20,$20,$88,$0E,$28,$20
                                  .db $AB,$0E,$30,$20,$99,$0E,$38,$20
                                  .db $A8,$0E,$40,$20,$BF,$0E,$48,$20
                                  .db $AC,$0E,$58,$20,$88,$0E,$60,$20
                                  .db $8B,$0E,$68,$20,$AF,$0E,$70,$20
                                  .db $8C,$0E,$78,$20,$9E,$0E,$80,$20
                                  .db $AD,$0E,$88,$20,$AE,$0E,$90,$20
                                  .db $AB,$0E,$98,$20,$8C,$0E,$A8,$20
                                  .db $99,$0E,$B0,$20,$AC,$0E,$C0,$20
                                  .db $A8,$0E,$C8,$20,$AF,$0E,$D0,$20
                                  .db $8C,$0E,$D8,$20,$AB,$0E,$E0,$20
                                  .db $BD,$0E,$18,$30,$A1,$0E,$20,$30
                                  .db $88,$0E,$28,$30,$AB,$0E,$30,$30
                                  .db $99,$0E,$38,$30,$A8,$0E,$40,$30
                                  .db $BE,$0E,$48,$30,$AD,$0E,$50,$30
                                  .db $98,$0E,$58,$30,$8C,$0E,$68,$30
                                  .db $A0,$0E,$70,$30,$AB,$0E,$78,$30
                                  .db $99,$0E,$80,$30,$9E,$0E,$88,$30
                                  .db $8A,$0E,$90,$30,$8C,$0E,$98,$30
                                  .db $AC,$0E,$A0,$30,$AC,$0E,$A8,$30
                                  .db $BE,$0E,$B0,$30,$B0,$0E,$B8,$30
                                  .db $A8,$0E,$C0,$30,$AC,$0E,$C8,$30
                                  .db $98,$0E,$D0,$30,$99,$0E,$D8,$30
                                  .db $BE,$0E,$18,$40,$88,$0E,$20,$40
                                  .db $9E,$0E,$28,$40,$8B,$0E,$38,$40
                                  .db $98,$0E,$40,$40,$99,$0E,$48,$40
                                  .db $AC,$0E,$58,$40,$8D,$0E,$60,$40
                                  .db $AB,$0E,$68,$40,$99,$0E,$70,$40
                                  .db $8C,$0E,$78,$40,$9E,$0E,$80,$40
                                  .db $8B,$0E,$88,$40,$AC,$0E,$98,$40
                                  .db $88,$0E,$A0,$40,$AB,$0E,$A8,$40
                                  .db $8C,$0E,$B8,$40,$8E,$0E,$C0,$40
                                  .db $A8,$0E,$C8,$40,$99,$0E,$D0,$40
                                  .db $9E,$0E,$D8,$40,$8E,$0E,$18,$50
                                  .db $AD,$0E,$20,$50,$A8,$0E,$30,$50
                                  .db $AD,$0E,$38,$50,$88,$0E,$40,$50
                                  .db $9B,$0E,$48,$50,$8C,$0E,$58,$50
                                  .db $88,$0E,$68,$50,$AF,$0E,$70,$50
                                  .db $88,$0E,$78,$50,$8A,$0E,$80,$50
                                  .db $88,$0E,$88,$50,$AD,$0E,$90,$50
                                  .db $99,$0E,$98,$50,$A8,$0E,$A0,$50
                                  .db $9E,$0E,$A8,$50,$BD,$0E

CODE_03D674:        DA            PHX                       
CODE_03D675:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_03D677:        AE 21 19      LDX.W $1921               
CODE_03D67A:        F0 2C         BEQ CODE_03D6A8           
CODE_03D67C:        CA            DEX                       
CODE_03D67D:        A0 00 00      LDY.W #$0000              
CODE_03D680:        DA            PHX                       
CODE_03D681:        8A            TXA                       
CODE_03D682:        0A            ASL                       
CODE_03D683:        0A            ASL                       
CODE_03D684:        AA            TAX                       
CODE_03D685:        BD 24 D5      LDA.W DATA_03D524,X       
CODE_03D688:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_03D68B:        BD 26 D5      LDA.W DATA_03D526,X       
CODE_03D68E:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_03D691:        5A            PHY                       
CODE_03D692:        98            TYA                       
CODE_03D693:        4A            LSR                       
CODE_03D694:        4A            LSR                       
CODE_03D695:        A8            TAY                       
CODE_03D696:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_03D698:        A9 00         LDA.B #$00                
CODE_03D69A:        99 20 04      STA.W $0420,Y             
CODE_03D69D:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03D69F:        7A            PLY                       
CODE_03D6A0:        FA            PLX                       
CODE_03D6A1:        C8            INY                       
CODE_03D6A2:        C8            INY                       
CODE_03D6A3:        C8            INY                       
CODE_03D6A4:        C8            INY                       
CODE_03D6A5:        CA            DEX                       
CODE_03D6A6:        10 D8         BPL CODE_03D680           
CODE_03D6A8:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_03D6AA:        FA            PLX                       
Return03D6AB:       60            RTS                       ; Return 


DATA_03D6AC:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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

DATA_03D700:                      .db $B0,$A0,$90,$80,$70,$60,$50,$40
                                  .db $30,$20,$10,$00

CODE_03D70C:        DA            PHX                       
CODE_03D70D:        AD 20 15      LDA.W RAM_Reznor1Dead     ; \ Return if less than 2 reznors killed 
CODE_03D710:        18            CLC                       ;  | 
CODE_03D711:        6D 21 15      ADC.W RAM_Reznor2Dead     ;  | 
CODE_03D714:        6D 22 15      ADC.W RAM_Reznor3Dead     ;  | 
CODE_03D717:        6D 23 15      ADC.W RAM_Reznor4Dead     ;  | 
CODE_03D71A:        C9 02         CMP.B #$02                ;  | 
CODE_03D71C:        90 39         BCC CODE_03D757           ; / 
BreakBridge:        AE 9F 1B      LDX.W $1B9F               
CODE_03D721:        E0 0C         CPX.B #$0C                
CODE_03D723:        B0 32         BCS CODE_03D757           
CODE_03D725:        BF 00 D7 03   LDA.L DATA_03D700,X       
CODE_03D729:        85 9A         STA RAM_BlockYLo          
CODE_03D72B:        64 9B         STZ RAM_BlockYHi          
CODE_03D72D:        A9 B0         LDA.B #$B0                
CODE_03D72F:        85 98         STA RAM_BlockXLo          
CODE_03D731:        64 99         STZ RAM_BlockXHi          
CODE_03D733:        AD A7 14      LDA.W $14A7               
CODE_03D736:        F0 12         BEQ CODE_03D74A           
CODE_03D738:        C9 3C         CMP.B #$3C                
CODE_03D73A:        D0 1B         BNE CODE_03D757           
CODE_03D73C:        20 7F D7      JSR.W CODE_03D77F         
CODE_03D73F:        20 59 D7      JSR.W CODE_03D759         
CODE_03D742:        20 7F D7      JSR.W CODE_03D77F         
CODE_03D745:        EE 9F 1B      INC.W $1B9F               
CODE_03D748:        80 0D         BRA CODE_03D757           

CODE_03D74A:        20 66 D7      JSR.W CODE_03D766         
CODE_03D74D:        A9 40         LDA.B #$40                
CODE_03D74F:        8D A7 14      STA.W $14A7               
CODE_03D752:        A9 07         LDA.B #$07                
CODE_03D754:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_03D757:        FA            PLX                       
Return03D758:       6B            RTL                       ; Return 

CODE_03D759:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03D75B:        A9 70 01      LDA.W #$0170              
CODE_03D75E:        38            SEC                       
CODE_03D75F:        E5 9A         SBC RAM_BlockYLo          
CODE_03D761:        85 9A         STA RAM_BlockYLo          
CODE_03D763:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return03D765:       60            RTS                       ; Return 

CODE_03D766:        20 6C D7      JSR.W CODE_03D76C         
CODE_03D769:        20 59 D7      JSR.W CODE_03D759         
CODE_03D76C:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03D76E:        A5 9A         LDA RAM_BlockYLo          
CODE_03D770:        38            SEC                       
CODE_03D771:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_03D773:        C9 00 01      CMP.W #$0100              
CODE_03D776:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_03D778:        B0 04         BCS Return03D77E          
CODE_03D77A:        22 44 8A 02   JSL.L CODE_028A44         
Return03D77E:       60            RTS                       ; Return 

CODE_03D77F:        A5 9A         LDA RAM_BlockYLo          
CODE_03D781:        4A            LSR                       
CODE_03D782:        4A            LSR                       
CODE_03D783:        4A            LSR                       
CODE_03D784:        85 01         STA $01                   
CODE_03D786:        4A            LSR                       
CODE_03D787:        05 98         ORA RAM_BlockXLo          
CODE_03D789:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03D78B:        29 FF 00      AND.W #$00FF              
CODE_03D78E:        A6 9B         LDX RAM_BlockYHi          
CODE_03D790:        F0 06         BEQ CODE_03D798           
CODE_03D792:        18            CLC                       
CODE_03D793:        69 B0 01      ADC.W #$01B0              
CODE_03D796:        A2 04         LDX.B #$04                
CODE_03D798:        86 00         STX $00                   
CODE_03D79A:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_03D79C:        AA            TAX                       
CODE_03D79D:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_03D79F:        A9 25         LDA.B #$25                
CODE_03D7A1:        9F 00 C8 7E   STA.L $7EC800,X           
CODE_03D7A5:        A9 00         LDA.B #$00                
CODE_03D7A7:        9F 00 C8 7F   STA.L $7FC800,X           
CODE_03D7AB:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03D7AD:        AF 7B 83 7F   LDA.L $7F837B             
CODE_03D7B1:        AA            TAX                       
CODE_03D7B2:        A9 5A C0      LDA.W #$C05A              
CODE_03D7B5:        18            CLC                       
CODE_03D7B6:        65 00         ADC $00                   
CODE_03D7B8:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_03D7BC:        09 00 20      ORA.W #$2000              
CODE_03D7BF:        9F 83 83 7F   STA.L $7F8383,X           
CODE_03D7C3:        A9 40 02      LDA.W #$0240              
CODE_03D7C6:        9F 7F 83 7F   STA.L $7F837F,X           
CODE_03D7CA:        9F 85 83 7F   STA.L $7F8385,X           
CODE_03D7CE:        A9 FC 38      LDA.W #$38FC              
CODE_03D7D1:        9F 81 83 7F   STA.L $7F8381,X           
CODE_03D7D5:        9F 87 83 7F   STA.L $7F8387,X           
CODE_03D7D9:        A9 FF 00      LDA.W #$00FF              
CODE_03D7DC:        9F 89 83 7F   STA.L $7F8389,X           
CODE_03D7E0:        8A            TXA                       
CODE_03D7E1:        18            CLC                       
CODE_03D7E2:        69 0C 00      ADC.W #$000C              
CODE_03D7E5:        8F 7B 83 7F   STA.L $7F837B             
CODE_03D7E9:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return03D7EB:       60            RTS                       ; Return 


IggyPlatform:                     .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$15,$16,$17,$18,$17,$18
                                  .db $17,$18,$17,$18,$19,$1A,$00,$00
                                  .db $00,$00,$01,$02,$03,$04,$03,$04
                                  .db $03,$04,$03,$04,$05,$12,$00,$00
                                  .db $00,$00,$00,$07,$04,$03,$04,$03
                                  .db $04,$03,$04,$03,$08,$00,$00,$00
                                  .db $00,$00,$00,$09,$0A,$04,$03,$04
                                  .db $03,$04,$03,$0B,$0C,$00,$00,$00
                                  .db $00,$00,$00,$00,$0D,$0E,$04,$03
                                  .db $04,$03,$0F,$10,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$11,$02,$03,$04
                                  .db $03,$04,$05,$12,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$07,$04,$03
                                  .db $04,$03,$08,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$09,$0A,$04
                                  .db $03,$0B,$0C,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$13,$03
                                  .db $04,$14,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$13
                                  .db $14,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
DATA_03D8EC:                      .db $FF,$FF

DATA_03D8EE:                      .db $FF,$FF,$FF,$FF,$24,$34,$25,$0B
                                  .db $26,$36,$0E,$1B,$0C,$1C,$0D,$1D
                                  .db $0E,$1E,$29,$39,$2A,$3A,$2B,$3B
                                  .db $26,$38,$20,$30,$21,$31,$27,$37
                                  .db $28,$38,$FF,$FF,$22,$32,$0E,$33
                                  .db $0C,$1C,$0D,$1D,$0E,$3C,$2D,$3D
                                  .db $FF,$FF,$07,$17,$0E,$23,$0E,$04
                                  .db $0C,$1C,$0D,$1D,$0E,$09,$0E,$2C
                                  .db $0A,$1A,$FF,$FF,$24,$34,$2B,$3B
                                  .db $FF,$FF,$07,$17,$0E,$18,$0E,$19
                                  .db $0A,$1A,$02,$12,$03,$13,$03,$08
                                  .db $03,$05,$03,$05,$03,$14,$03,$15
                                  .db $03,$05,$03,$05,$03,$08,$03,$06
                                  .db $0F,$1F

CODE_03D958:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_03D95A:        9C 15 21      STZ.W $2115               ; VRAM Address Increment Value
CODE_03D95D:        9C 16 21      STZ.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_03D960:        9C 17 21      STZ.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_03D963:        A2 00 40      LDX.W #$4000              
CODE_03D966:        A9 FF         LDA.B #$FF                
CODE_03D968:        8D 18 21      STA.W $2118               ; Data for VRAM Write (Low Byte)
CODE_03D96B:        CA            DEX                       
CODE_03D96C:        D0 FA         BNE CODE_03D968           
CODE_03D96E:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_03D970:        2C 9B 0D      BIT.W $0D9B               
CODE_03D973:        70 1B         BVS Return03D990          
CODE_03D975:        8B            PHB                       
CODE_03D976:        4B            PHK                       
CODE_03D977:        AB            PLB                       
CODE_03D978:        A9 EC         LDA.B #$EC                
CODE_03D97A:        85 05         STA $05                   
CODE_03D97C:        A9 D7         LDA.B #$D7                
CODE_03D97E:        85 06         STA $06                   
CODE_03D980:        A9 03         LDA.B #$03                
CODE_03D982:        85 07         STA $07                   
CODE_03D984:        A9 10         LDA.B #$10                
CODE_03D986:        85 00         STA $00                   
CODE_03D988:        A9 08         LDA.B #$08                
CODE_03D98A:        85 01         STA $01                   
CODE_03D98C:        20 91 D9      JSR.W CODE_03D991         
CODE_03D98F:        AB            PLB                       
Return03D990:       6B            RTL                       ; Return 

CODE_03D991:        9C 15 21      STZ.W $2115               ; VRAM Address Increment Value
CODE_03D994:        A0 00         LDY.B #$00                
CODE_03D996:        84 02         STY $02                   
CODE_03D998:        A9 00         LDA.B #$00                
CODE_03D99A:        85 03         STA $03                   
CODE_03D99C:        A5 00         LDA $00                   
CODE_03D99E:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_03D9A1:        A5 01         LDA $01                   
CODE_03D9A3:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_03D9A6:        A4 02         LDY $02                   
CODE_03D9A8:        A9 10         LDA.B #$10                
CODE_03D9AA:        85 04         STA $04                   
CODE_03D9AC:        B7 05         LDA [$05],Y               
CODE_03D9AE:        99 F6 0A      STA.W $0AF6,Y             
CODE_03D9B1:        0A            ASL                       
CODE_03D9B2:        0A            ASL                       
CODE_03D9B3:        05 03         ORA $03                   
CODE_03D9B5:        AA            TAX                       
CODE_03D9B6:        BF EC D8 03   LDA.L DATA_03D8EC,X       
CODE_03D9BA:        8D 18 21      STA.W $2118               ; Data for VRAM Write (Low Byte)
CODE_03D9BD:        BF EE D8 03   LDA.L DATA_03D8EE,X       
CODE_03D9C1:        8D 18 21      STA.W $2118               ; Data for VRAM Write (Low Byte)
CODE_03D9C4:        C8            INY                       
CODE_03D9C5:        C6 04         DEC $04                   
CODE_03D9C7:        D0 E3         BNE CODE_03D9AC           
CODE_03D9C9:        A5 00         LDA $00                   
CODE_03D9CB:        18            CLC                       
CODE_03D9CC:        69 80         ADC.B #$80                
CODE_03D9CE:        85 00         STA $00                   
CODE_03D9D0:        90 02         BCC CODE_03D9D4           
CODE_03D9D2:        E6 01         INC $01                   
CODE_03D9D4:        A5 03         LDA $03                   
CODE_03D9D6:        49 01         EOR.B #$01                
CODE_03D9D8:        D0 C0         BNE CODE_03D99A           
CODE_03D9DA:        98            TYA                       
CODE_03D9DB:        D0 B9         BNE CODE_03D996           
Return03D9DD:       60            RTS                       ; Return 


DATA_03D9DE:                      .db $FF,$00,$FF,$FF,$02,$04,$06,$FF
                                  .db $08,$0A,$0C,$FF,$0E,$10,$12,$FF
                                  .db $FF,$00,$FF,$FF,$02,$04,$06,$FF
                                  .db $08,$0A,$0C,$FF,$0E,$14,$16,$FF
                                  .db $FF,$00,$FF,$FF,$02,$04,$06,$FF
                                  .db $08,$0A,$0C,$FF,$0E,$18,$1A,$FF
                                  .db $46,$48,$4A,$FF,$4C,$4E,$50,$FF
                                  .db $52,$54,$0C,$FF,$0E,$18,$1A,$FF
                                  .db $FF,$FF,$FF,$FF,$B2,$B4,$06,$FF
                                  .db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF
                                  .db $FF,$1C,$FF,$FF,$1E,$20,$22,$FF
                                  .db $24,$26,$28,$FF,$FF,$2A,$2C,$FF
                                  .db $FF,$2E,$30,$FF,$32,$34,$35,$33
                                  .db $36,$38,$39,$37,$42,$44,$45,$43
                                  .db $FF,$2E,$30,$FF,$32,$34,$35,$33
                                  .db $36,$38,$39,$37,$42,$44,$45,$43
                                  .db $FF,$2E,$30,$FF,$32,$34,$35,$33
                                  .db $36,$38,$39,$37,$3E,$40,$41,$3F
                                  .db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF
                                  .db $08,$0A,$0C,$FF,$0E,$10,$12,$FF
                                  .db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF
                                  .db $08,$0A,$0C,$FF,$0E,$14,$16,$FF
                                  .db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF
                                  .db $08,$0A,$0C,$FF,$0E,$18,$1A,$FF
                                  .db $6C,$6E,$FF,$FF,$72,$74,$50,$FF
                                  .db $52,$54,$0C,$FF,$0E,$18,$1A,$FF
                                  .db $FF,$BE,$FF,$FF,$DC,$DE,$06,$FF
                                  .db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF
                                  .db $60,$62,$FF,$FF,$64,$66,$22,$FF
                                  .db $24,$26,$28,$FF,$FF,$2A,$2C,$FF
                                  .db $FF,$68,$69,$FF,$32,$6A,$6B,$33
                                  .db $36,$38,$39,$37,$42,$44,$45,$43
                                  .db $FF,$68,$69,$FF,$32,$6A,$6B,$33
                                  .db $36,$38,$39,$37,$42,$44,$45,$43
                                  .db $FF,$68,$69,$FF,$32,$6A,$6B,$33
                                  .db $36,$38,$39,$37,$3E,$40,$41,$3F
                                  .db $7A,$7C,$FF,$FF,$7E,$80,$82,$FF
                                  .db $84,$86,$0C,$FF,$0E,$10,$12,$FF
                                  .db $7A,$7C,$FF,$FF,$7E,$80,$06,$FF
                                  .db $84,$86,$0C,$FF,$0E,$14,$16,$FF
                                  .db $7A,$7C,$FF,$FF,$7E,$80,$06,$FF
                                  .db $84,$86,$0C,$FF,$0E,$18,$1A,$FF
                                  .db $A0,$A2,$A4,$FF,$A6,$A8,$AA,$FF
                                  .db $52,$54,$0C,$FF,$0E,$18,$1A,$FF
                                  .db $FF,$B8,$FF,$FF,$D6,$D8,$DA,$FF
                                  .db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF
                                  .db $88,$8A,$8C,$FF,$8E,$90,$92,$FF
                                  .db $94,$96,$28,$FF,$FF,$2A,$2C,$FF
                                  .db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D
                                  .db $36,$38,$39,$37,$42,$44,$45,$43
                                  .db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D
                                  .db $36,$38,$39,$37,$42,$44,$45,$43
                                  .db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D
                                  .db $36,$38,$39,$37,$3E,$40,$41,$3F
                                  .db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF
                                  .db $C0,$C2,$C4,$FF,$E0,$E2,$E4,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF
                                  .db $C6,$C8,$CA,$FF,$E6,$E8,$EA,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$CD,$FF,$FF
                                  .db $C5,$C3,$C1,$FF,$E5,$E3,$E1,$FF
                                  .db $FF,$90,$92,$94,$96,$FF,$FF,$FF
                                  .db $FF,$B0,$B2,$B4,$B6,$38,$FF,$FF
                                  .db $FF,$D0,$D2,$D4,$D6,$58,$5A,$FF
                                  .db $FF,$F0,$F2,$F4,$F6,$78,$7A,$FF
                                  .db $FF,$90,$92,$94,$96,$FF,$FF,$FF
                                  .db $FF,$98,$9A,$9C,$B6,$38,$FF,$FF
                                  .db $FF,$D0,$D2,$D4,$D6,$58,$5A,$FF
                                  .db $FF,$F0,$F2,$F4,$F6,$78,$7A,$FF
                                  .db $FF,$90,$92,$94,$96,$FF,$FF,$FF
                                  .db $FF,$98,$BA,$BC,$B6,$38,$FF,$FF
                                  .db $FF,$D8,$DA,$DC,$D6,$58,$5A,$FF
                                  .db $FF,$F8,$FA,$FC,$F6,$78,$7A,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$90,$92,$94,$96,$FF,$FF
                                  .db $FF,$FF,$98,$BA,$BC,$B6,$38,$FF
                                  .db $FF,$FF,$D8,$DA,$DC,$D6,$58,$5A
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$90,$92,$94,$96,$FF,$FF
                                  .db $FF,$FF,$98,$BA,$BC,$B6,$38,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$90,$92,$94,$96,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$90,$92,$94,$96,$FF,$FF,$FF
                                  .db $FF,$98,$BA,$BC,$B6,$38,$FF,$FF
                                  .db $FF,$D8,$DA,$DC,$D6,$58,$5A,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $04,$06,$08,$0A,$0B,$09,$07,$05
                                  .db $24,$26,$28,$2A,$2C,$29,$27,$25
                                  .db $FF,$84,$86,$88,$89,$87,$85,$FF
                                  .db $FF,$A4,$A6,$A8,$A9,$A7,$A5,$FF
                                  .db $04,$06,$08,$0A,$0B,$09,$07,$05
                                  .db $24,$26,$28,$2D,$2B,$29,$27,$25
                                  .db $FF,$84,$86,$88,$89,$87,$85,$FF
                                  .db $FF,$A4,$A6,$0C,$0D,$A7,$A5,$FF
                                  .db $80,$82,$83,$8A,$82,$83,$8C,$8E
                                  .db $A0,$A2,$A3,$C4,$A2,$A3,$AC,$AE
                                  .db $80,$8A,$8A,$8A,$8A,$8A,$8C,$8E
                                  .db $A0,$60,$61,$C4,$60,$61,$AC,$AE
                                  .db $80,$03,$01,$8A,$00,$02,$8C,$8E
                                  .db $A0,$23,$21,$C4,$20,$22,$AC,$AE
                                  .db $80,$00,$02,$8A,$03,$01,$AA,$8E
                                  .db $A0,$20,$22,$C4,$23,$21,$AC,$AE
                                  .db $C0,$C2,$C4,$C4,$C4,$CA,$CC,$CE
                                  .db $E0,$E2,$E4,$E6,$E8,$EA,$EC,$EE
                                  .db $40,$42,$44,$46,$48,$4A,$4C,$4E
                                  .db $FF,$62,$64,$66,$68,$6A,$6C,$FF
                                  .db $10,$12,$14,$16,$18,$1A,$1C,$1E
                                  .db $10,$30,$32,$34,$36,$1A,$1C,$1E
KoopaPalPtrLo:                    .db $BC,$A4,$98,$78,$6C

KoopaPalPtrHi:                    .db $B2,$B2,$B2,$B3,$B3

DATA_03DD78:                      .db $0B,$0B,$0B,$21,$00

CODE_03DD7D:        DA            PHX                       
CODE_03DD7E:        8B            PHB                       
CODE_03DD7F:        4B            PHK                       
CODE_03DD80:        AB            PLB                       
CODE_03DD81:        B4 C2         LDY RAM_SpriteState,X     
CODE_03DD83:        8C FC 13      STY.W $13FC               
CODE_03DD86:        C0 04         CPY.B #$04                
CODE_03DD88:        D0 0D         BNE CODE_03DD97           
CODE_03DD8A:        20 8E DE      JSR.W CODE_03DE8E         
CODE_03DD8D:        A9 48         LDA.B #$48                
CODE_03DD8F:        85 2C         STA $2C                   
CODE_03DD91:        A9 14         LDA.B #$14                
CODE_03DD93:        85 38         STA $38                   
CODE_03DD95:        85 39         STA $39                   
CODE_03DD97:        A9 FF         LDA.B #$FF                
CODE_03DD99:        85 5D         STA RAM_ScreensInLvl      
CODE_03DD9B:        1A            INC A                     
CODE_03DD9C:        85 5E         STA $5E                   
CODE_03DD9E:        AC FC 13      LDY.W $13FC               
CODE_03DDA1:        BE 78 DD      LDX.W DATA_03DD78,Y       
CODE_03DDA4:        B9 6E DD      LDA.W KoopaPalPtrLo,Y     ; \ $00 = Pointer in bank 0 (from above tables) 
CODE_03DDA7:        85 00         STA $00                   ;  | 
CODE_03DDA9:        B9 73 DD      LDA.W KoopaPalPtrHi,Y     ;  | 
CODE_03DDAC:        85 01         STA $01                   ;  | 
CODE_03DDAE:        64 02         STZ $02                   ; / 
CODE_03DDB0:        A0 0B         LDY.B #$0B                ; \ Read 0B bytes and put them in $0707 
CODE_03DDB2:        B7 00         LDA [$00],Y               ;  | 
CODE_03DDB4:        99 07 07      STA.W $0707,Y             ;  | 
CODE_03DDB7:        88            DEY                       ;  | 
CODE_03DDB8:        10 F8         BPL CODE_03DDB2           ; / 
CODE_03DDBA:        A9 80         LDA.B #$80                
CODE_03DDBC:        8D 15 21      STA.W $2115               ; VRAM Address Increment Value
CODE_03DDBF:        9C 16 21      STZ.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_03DDC2:        9C 17 21      STZ.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_03DDC5:        9B            TXY                       
CODE_03DDC6:        F0 0F         BEQ CODE_03DDD7           
CODE_03DDC8:        22 28 BA 00   JSL.L CODE_00BA28         
CODE_03DDCC:        A9 80         LDA.B #$80                
CODE_03DDCE:        85 03         STA $03                   
CODE_03DDD0:        20 E5 DD      JSR.W CODE_03DDE5         
CODE_03DDD3:        C6 03         DEC $03                   
CODE_03DDD5:        D0 F9         BNE CODE_03DDD0           
CODE_03DDD7:        A2 5F         LDX.B #$5F                
CODE_03DDD9:        A9 FF         LDA.B #$FF                
CODE_03DDDB:        9F 80 C6 7E   STA.L $7EC680,X           
CODE_03DDDF:        CA            DEX                       
CODE_03DDE0:        10 F7         BPL CODE_03DDD9           
CODE_03DDE2:        AB            PLB                       
CODE_03DDE3:        FA            PLX                       
Return03DDE4:       6B            RTL                       ; Return 

CODE_03DDE5:        A2 00         LDX.B #$00                
CODE_03DDE7:        9B            TXY                       
CODE_03DDE8:        A9 08         LDA.B #$08                
CODE_03DDEA:        85 05         STA $05                   
CODE_03DDEC:        20 39 DE      JSR.W CODE_03DE39         
CODE_03DDEF:        5A            PHY                       
CODE_03DDF0:        98            TYA                       
CODE_03DDF1:        4A            LSR                       
CODE_03DDF2:        18            CLC                       
CODE_03DDF3:        69 0F         ADC.B #$0F                
CODE_03DDF5:        A8            TAY                       
CODE_03DDF6:        20 3C DE      JSR.W CODE_03DE3C         
CODE_03DDF9:        A0 08         LDY.B #$08                
CODE_03DDFB:        BD A3 1B      LDA.W $1BA3,X             
CODE_03DDFE:        0A            ASL                       
CODE_03DDFF:        2A            ROL                       
CODE_03DE00:        2A            ROL                       
CODE_03DE01:        2A            ROL                       
CODE_03DE02:        29 07         AND.B #$07                
CODE_03DE04:        9D A3 1B      STA.W $1BA3,X             
CODE_03DE07:        8D 19 21      STA.W $2119               ; Data for VRAM Write (High Byte)
CODE_03DE0A:        E8            INX                       
CODE_03DE0B:        88            DEY                       
CODE_03DE0C:        D0 ED         BNE CODE_03DDFB           
CODE_03DE0E:        7A            PLY                       
CODE_03DE0F:        C6 05         DEC $05                   
CODE_03DE11:        D0 D9         BNE CODE_03DDEC           
CODE_03DE13:        A9 07         LDA.B #$07                
CODE_03DE15:        AA            TAX                       
CODE_03DE16:        A0 08         LDY.B #$08                
CODE_03DE18:        84 05         STY $05                   
CODE_03DE1A:        BC A3 1B      LDY.W $1BA3,X             
CODE_03DE1D:        8C 19 21      STY.W $2119               ; Data for VRAM Write (High Byte)
CODE_03DE20:        CA            DEX                       
CODE_03DE21:        C6 05         DEC $05                   
CODE_03DE23:        D0 F5         BNE CODE_03DE1A           
CODE_03DE25:        18            CLC                       
CODE_03DE26:        69 08         ADC.B #$08                
CODE_03DE28:        C9 40         CMP.B #$40                
CODE_03DE2A:        90 E9         BCC CODE_03DE15           
CODE_03DE2C:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03DE2E:        A5 00         LDA $00                   
CODE_03DE30:        18            CLC                       
CODE_03DE31:        69 18 00      ADC.W #$0018              
CODE_03DE34:        85 00         STA $00                   
CODE_03DE36:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return03DE38:       60            RTS                       ; Return 

CODE_03DE39:        20 3C DE      JSR.W CODE_03DE3C         
CODE_03DE3C:        DA            PHX                       
CODE_03DE3D:        B7 00         LDA [$00],Y               
CODE_03DE3F:        5A            PHY                       
CODE_03DE40:        A0 08         LDY.B #$08                
CODE_03DE42:        0A            ASL                       
CODE_03DE43:        7E A3 1B      ROR.W $1BA3,X             
CODE_03DE46:        E8            INX                       
CODE_03DE47:        88            DEY                       
CODE_03DE48:        D0 F8         BNE CODE_03DE42           
CODE_03DE4A:        7A            PLY                       
CODE_03DE4B:        C8            INY                       
CODE_03DE4C:        FA            PLX                       
Return03DE4D:       60            RTS                       ; Return 


DATA_03DE4E:                      .db $40,$41,$42,$43,$44,$45,$46,$47
                                  .db $50,$51,$52,$53,$54,$55,$56,$57
                                  .db $60,$61,$62,$63,$64,$65,$66,$67
                                  .db $70,$71,$72,$73,$74,$75,$76,$77
                                  .db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F
                                  .db $58,$59,$5A,$5B,$5C,$5D,$5E,$5F
                                  .db $68,$69,$6A,$6B,$6C,$6D,$6E,$6F
                                  .db $78,$79,$7A,$7B,$7C,$7D,$7E,$3F

CODE_03DE8E:        9C 15 21      STZ.W $2115               ; VRAM Address Increment Value
CODE_03DE91:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03DE93:        A9 1C 0A      LDA.W #$0A1C              
CODE_03DE96:        85 00         STA $00                   
CODE_03DE98:        A2 00         LDX.B #$00                
CODE_03DE9A:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03DE9C:        A5 00         LDA $00                   
CODE_03DE9E:        18            CLC                       
CODE_03DE9F:        69 80 00      ADC.W #$0080              
CODE_03DEA2:        85 00         STA $00                   
CODE_03DEA4:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_03DEA7:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_03DEA9:        A0 08         LDY.B #$08                
CODE_03DEAB:        BF 4E DE 03   LDA.L DATA_03DE4E,X       
CODE_03DEAF:        8D 18 21      STA.W $2118               ; Data for VRAM Write (Low Byte)
CODE_03DEB2:        E8            INX                       
CODE_03DEB3:        88            DEY                       
CODE_03DEB4:        D0 F5         BNE CODE_03DEAB           
CODE_03DEB6:        E0 40         CPX.B #$40                
CODE_03DEB8:        90 E0         BCC CODE_03DE9A           
Return03DEBA:       60            RTS                       ; Return 


DATA_03DEBB:                      .db $00,$01,$10,$01

DATA_03DEBF:                      .db $6E,$70,$FF,$50,$FE,$FE,$FF,$57
DATA_03DEC7:                      .db $72,$74,$52,$54,$3C,$3E,$55,$53
DATA_03DECF:                      .db $76,$56,$56,$FF,$FF,$FF,$51,$FF
DATA_03DED7:                      .db $20,$03,$30,$03,$40,$03,$50,$03

CODE_03DEDF:        8B            PHB                       
CODE_03DEE0:        4B            PHK                       
CODE_03DEE1:        AB            PLB                       
CODE_03DEE2:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_03DEE5:        EB            XBA                       
CODE_03DEE6:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_03DEE8:        A0 00         LDY.B #$00                
CODE_03DEEA:        20 AE DF      JSR.W CODE_03DFAE         
CODE_03DEED:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_03DEF0:        EB            XBA                       
CODE_03DEF1:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_03DEF3:        A0 02         LDY.B #$02                
CODE_03DEF5:        20 AE DF      JSR.W CODE_03DFAE         
CODE_03DEF8:        DA            PHX                       
CODE_03DEF9:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_03DEFB:        64 06         STZ $06                   
CODE_03DEFD:        A0 03 00      LDY.W #$0003              
CODE_03DF00:        AD 9B 0D      LDA.W $0D9B               
CODE_03DF03:        4A            LSR                       
CODE_03DF04:        90 3E         BCC CODE_03DF44           
CODE_03DF06:        AD 28 14      LDA.W $1428               
CODE_03DF09:        29 03 00      AND.W #$0003              
CODE_03DF0C:        0A            ASL                       
CODE_03DF0D:        AA            TAX                       
CODE_03DF0E:        BF BF DE 03   LDA.L DATA_03DEBF,X       
CODE_03DF12:        8F 81 C6 7E   STA.L $7EC681             
CODE_03DF16:        BF C7 DE 03   LDA.L DATA_03DEC7,X       
CODE_03DF1A:        8F 83 C6 7E   STA.L $7EC683             
CODE_03DF1E:        BF CF DE 03   LDA.L DATA_03DECF,X       
CODE_03DF22:        8F 85 C6 7E   STA.L $7EC685             
CODE_03DF26:        A9 08 00      LDA.W #$0008              
CODE_03DF29:        85 06         STA $06                   
CODE_03DF2B:        A2 80 03      LDX.W #$0380              
CODE_03DF2E:        AD A2 1B      LDA.W $1BA2               
CODE_03DF31:        29 7F 00      AND.W #$007F              
CODE_03DF34:        C9 2C 00      CMP.W #$002C              
CODE_03DF37:        90 03         BCC CODE_03DF3C           
CODE_03DF39:        A2 88 03      LDX.W #$0388              
CODE_03DF3C:        8A            TXA                       
CODE_03DF3D:        A2 0A 00      LDX.W #$000A              
CODE_03DF40:        A0 07 00      LDY.W #$0007              
CODE_03DF43:        38            SEC                       
CODE_03DF44:        84 00         STY $00                   
CODE_03DF46:        B0 0D         BCS CODE_03DF55           
CODE_03DF48:        AD A2 1B      LDA.W $1BA2               
CODE_03DF4B:        29 7F 00      AND.W #$007F              
CODE_03DF4E:        0A            ASL                       
CODE_03DF4F:        0A            ASL                       
CODE_03DF50:        0A            ASL                       
CODE_03DF51:        0A            ASL                       
CODE_03DF52:        A2 03 00      LDX.W #$0003              
CODE_03DF55:        86 02         STX $02                   
CODE_03DF57:        48            PHA                       
CODE_03DF58:        AC A1 1B      LDY.W $1BA1               
CODE_03DF5B:        10 03         BPL CODE_03DF60           
CODE_03DF5D:        18            CLC                       
CODE_03DF5E:        65 00         ADC $00                   
CODE_03DF60:        A8            TAY                       
CODE_03DF61:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_03DF63:        A6 06         LDX $06                   
CODE_03DF65:        A5 00         LDA $00                   
CODE_03DF67:        85 04         STA $04                   
CODE_03DF69:        B9 DE D9      LDA.W DATA_03D9DE,Y       
CODE_03DF6C:        C8            INY                       
CODE_03DF6D:        2C A2 1B      BIT.W $1BA2               
CODE_03DF70:        10 04         BPL CODE_03DF76           
CODE_03DF72:        49 01         EOR.B #$01                
CODE_03DF74:        88            DEY                       
CODE_03DF75:        88            DEY                       
CODE_03DF76:        9F 80 C6 7E   STA.L $7EC680,X           
CODE_03DF7A:        E8            INX                       
CODE_03DF7B:        C6 04         DEC $04                   
CODE_03DF7D:        10 EA         BPL CODE_03DF69           
CODE_03DF7F:        86 06         STX $06                   
CODE_03DF81:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03DF83:        68            PLA                       
CODE_03DF84:        38            SEC                       
CODE_03DF85:        65 00         ADC $00                   
CODE_03DF87:        A6 02         LDX $02                   
CODE_03DF89:        E0 04 00      CPX.W #$0004              
CODE_03DF8C:        F0 BA         BEQ CODE_03DF48           
CODE_03DF8E:        E0 08 00      CPX.W #$0008              
CODE_03DF91:        D0 03         BNE CODE_03DF96           
CODE_03DF93:        A9 60 03      LDA.W #$0360              
CODE_03DF96:        E0 0A 00      CPX.W #$000A              
CODE_03DF99:        D0 0B         BNE CODE_03DFA6           
CODE_03DF9B:        AD 27 14      LDA.W $1427               
CODE_03DF9E:        29 03 00      AND.W #$0003              
CODE_03DFA1:        0A            ASL                       
CODE_03DFA2:        A8            TAY                       
CODE_03DFA3:        B9 D7 DE      LDA.W DATA_03DED7,Y       
CODE_03DFA6:        CA            DEX                       
CODE_03DFA7:        10 AC         BPL CODE_03DF55           
CODE_03DFA9:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_03DFAB:        FA            PLX                       
CODE_03DFAC:        AB            PLB                       
Return03DFAD:       6B            RTL                       ; Return 

CODE_03DFAE:        DA            PHX                       
CODE_03DFAF:        BB            TYX                       
CODE_03DFB0:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03DFB2:        49 FF FF      EOR.W #$FFFF              
CODE_03DFB5:        1A            INC A                     
CODE_03DFB6:        18            CLC                       
CODE_03DFB7:        7F BB DE 03   ADC.L DATA_03DEBB,X       
CODE_03DFBB:        18            CLC                       
CODE_03DFBC:        75 1A         ADC RAM_ScreenBndryXLo,X  
CODE_03DFBE:        95 3A         STA $3A,X                 
CODE_03DFC0:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_03DFC2:        FA            PLX                       
Return03DFC3:       60            RTS                       ; Return 


DATA_03DFC4:                      .db $00,$0E,$1C,$2A,$38,$46,$54,$62

CODE_03DFCC:        DA            PHX                       
CODE_03DFCD:        AE 81 06      LDX.W $0681               
CODE_03DFD0:        A9 10         LDA.B #$10                
CODE_03DFD2:        9D 82 06      STA.W $0682,X             
CODE_03DFD5:        9E 83 06      STZ.W $0683,X             
CODE_03DFD8:        9E 84 06      STZ.W $0684,X             
CODE_03DFDB:        9E 85 06      STZ.W $0685,X             
CODE_03DFDE:        9B            TXY                       
CODE_03DFDF:        AE FB 1F      LDX.W $1FFB               
CODE_03DFE2:        D0 37         BNE CODE_03E01B           
CODE_03DFE4:        AD 0D 19      LDA.W $190D               
CODE_03DFE7:        F0 07         BEQ CODE_03DFF0           
CODE_03DFE9:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03DFEB:        AD 01 07      LDA.W $0701               
CODE_03DFEE:        80 41         BRA CODE_03E031           

CODE_03DFF0:        A5 14         LDA RAM_FrameCounterB     ; Accum (8 bit) 
CODE_03DFF2:        4A            LSR                       
CODE_03DFF3:        90 41         BCC CODE_03E036           
CODE_03DFF5:        CE FC 1F      DEC.W $1FFC               
CODE_03DFF8:        D0 3C         BNE CODE_03E036           
CODE_03DFFA:        AA            TAX                       
CODE_03DFFB:        BF 08 F7 04   LDA.L CODE_04F708,X       
CODE_03DFFF:        29 07         AND.B #$07                
CODE_03E001:        AA            TAX                       
CODE_03E002:        BF F8 F6 04   LDA.L DATA_04F6F8,X       
CODE_03E006:        8D FC 1F      STA.W $1FFC               
CODE_03E009:        BF 00 F7 04   LDA.L DATA_04F700,X       
CODE_03E00D:        8D FB 1F      STA.W $1FFB               
CODE_03E010:        AA            TAX                       
CODE_03E011:        A9 08         LDA.B #$08                
CODE_03E013:        8D FD 1F      STA.W $1FFD               
CODE_03E016:        A9 18         LDA.B #$18                
CODE_03E018:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_03E01B:        CE FD 1F      DEC.W $1FFD               
CODE_03E01E:        10 08         BPL CODE_03E028           
CODE_03E020:        CE FB 1F      DEC.W $1FFB               
CODE_03E023:        A9 04         LDA.B #$04                
CODE_03E025:        8D FD 1F      STA.W $1FFD               
CODE_03E028:        8A            TXA                       
CODE_03E029:        0A            ASL                       
CODE_03E02A:        AA            TAX                       
CODE_03E02B:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_03E02D:        BF DE B5 00   LDA.L DATA_00B5DE,X       
CODE_03E031:        99 84 06      STA.W $0684,Y             
CODE_03E034:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_03E036:        AE 29 14      LDX.W $1429               
CODE_03E039:        BF C4 DF 03   LDA.L DATA_03DFC4,X       
CODE_03E03D:        AA            TAX                       
CODE_03E03E:        A9 0E         LDA.B #$0E                
CODE_03E040:        85 00         STA $00                   
CODE_03E042:        BF 9E B6 00   LDA.L DATA_00B69E,X       
CODE_03E046:        99 86 06      STA.W $0686,Y             
CODE_03E049:        E8            INX                       
CODE_03E04A:        C8            INY                       
CODE_03E04B:        C6 00         DEC $00                   
CODE_03E04D:        D0 F3         BNE CODE_03E042           
CODE_03E04F:        BB            TYX                       
CODE_03E050:        9E 86 06      STZ.W $0686,X             
CODE_03E053:        E8            INX                       
CODE_03E054:        E8            INX                       
CODE_03E055:        E8            INX                       
CODE_03E056:        E8            INX                       
CODE_03E057:        8E 81 06      STX.W $0681               
CODE_03E05A:        FA            PLX                       
Return03E05B:       6B            RTL                       ; Return 


DATA_03E05C:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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

ADDR_03E400:        C6 19         DEC RAM_MarioPowerUp      ; \ Unreachable 
Return03E402:       60            RTS                       ; / Decrease Mario's Status 


DATA_03E403:                      .db $13,$78,$13,$BE,$14,$F2,$14,$1C
                                  .db $16,$78,$13,$BE,$14,$F2,$14,$1C
                                  .db $16,$78,$13,$BE,$14,$F2,$14,$1C
                                  .db $16,$9E,$13,$AE,$13,$BE,$13,$DE
                                  .db $13,$CE,$13,$EE,$13,$FE,$13,$0E
                                  .db $14,$1E,$14,$2E,$14,$3E,$14,$4E
                                  .db $14,$5E,$14,$6E,$14,$7E,$14,$8E
                                  .db $14,$9E,$14,$AE,$14,$00,$00,$94
                                  .db $21,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$97
                                  .db $21,$BB,$21,$51,$22,$F7,$21,$33
                                  .db $22,$15,$22,$D9,$21,$73,$22,$92
                                  .db $22,$B4,$23,$E2,$23,$00,$00,$00
                                  .db $00,$00,$00,$CC,$23,$0F,$24,$C9
                                  .db $22,$B4,$23,$E2,$23,$00,$23,$00
                                  .db $00,$1A,$23,$CC,$23,$0F,$24,$44
                                  .db $24,$6B,$24,$AF,$24,$00,$00,$00
                                  .db $00,$00,$00,$8E,$24,$DF,$24,$35
                                  .db $25,$6E,$25,$B2,$25,$5C,$25,$00
                                  .db $00,$0F,$25,$91,$25,$E2,$25,$12
                                  .db $26,$8D,$26,$B1,$26,$61,$26,$00
                                  .db $00,$3A,$26,$A0,$26,$E1,$26,$11
                                  .db $27,$7E,$27,$A8,$27,$54,$27,$00
                                  .db $00,$33,$27,$94,$27,$0F,$24,$D1
                                  .db $22,$B4,$23,$E2,$23,$00,$23,$7E
                                  .db $23,$50,$23,$CC,$23,$0F,$24,$14
                                  .db $28,$54,$28,$80,$28,$4C,$28,$2C
                                  .db $28,$FD,$27,$6B,$28,$A4,$28,$C8
                                  .db $28,$E7,$28,$7D,$29,$23,$29,$5F
                                  .db $29,$41,$29,$05,$29,$9F,$29,$D1
                                  .db $22,$BE,$29,$E2,$23,$00,$23,$7E
                                  .db $23,$50,$23,$CC,$23,$0F,$24,$14
                                  .db $28,$F5,$29,$0D,$2A,$4C,$28,$2C
                                  .db $28,$FD,$27,$6B,$28,$A4,$28,$47
                                  .db $2A,$66,$2A,$00,$2B,$A2,$2A,$E0
                                  .db $2A,$C0,$2A,$84,$2A,$24,$2B,$79
                                  .db $2B,$43,$2B,$E2,$23,$00,$23,$E2
                                  .db $2B,$AE,$2B,$CC,$23,$0F,$24,$47
                                  .db $2C,$18,$2C,$0D,$2A,$4C,$28,$5F
                                  .db $2C,$30,$2C,$6B,$28,$A4,$28,$25
                                  .db $2A,$66,$2A,$00,$2B,$A2,$2A,$E0
                                  .db $2A,$C0,$2A,$84,$2A,$24,$2B,$7F
                                  .db $2C,$98,$2C,$0C,$2D,$C8,$2C,$F6
                                  .db $2C,$E0,$2C,$B0,$2C,$00,$00,$C2
                                  .db $14,$00,$00,$76,$1E,$C5,$1E,$F0
                                  .db $1E,$A2,$1E,$03,$1F,$2A,$1F,$49
                                  .db $1F,$68,$1F,$A4,$1F,$0A,$20,$4C
                                  .db $20,$E9,$1F,$C8,$1F,$83,$1F,$2C
                                  .db $20,$7B,$20,$A6,$20,$C8,$20,$5A
                                  .db $21,$04,$21,$3E,$21,$22,$21,$E6
                                  .db $20,$7A,$21,$D2,$14,$E2,$14,$2C
                                  .db $15,$4C,$15,$3C,$15,$5C,$15,$6C
                                  .db $15,$7C,$15,$8C,$15,$9C,$15,$AC
                                  .db $15,$CC,$15,$BC,$15,$DC,$15,$EC
                                  .db $15,$AE,$13,$4E,$14,$5E,$14,$6E
                                  .db $14,$7E,$14,$8E,$14,$6E,$14,$FC
                                  .db $15,$6E,$14,$7E,$14,$8E,$14,$9E
                                  .db $14,$0C,$16,$00,$00,$3D,$16,$93
                                  .db $17,$BD,$17,$1B,$17,$57,$17,$99
                                  .db $16,$00,$00,$E7,$17,$3D,$16,$93
                                  .db $17,$BD,$17,$1B,$17,$57,$17,$DE
                                  .db $16,$00,$00,$E7,$17,$00,$18,$EF
                                  .db $18,$10,$19,$89,$18,$BC,$18,$55
                                  .db $18,$00,$00,$E7,$17,$31,$19,$E4
                                  .db $19,$05,$1A,$8A,$19,$B7,$19,$5F
                                  .db $19,$00,$00,$E7,$17,$C8,$1A,$AB
                                  .db $1B,$CC,$1B,$3F,$1B,$77,$1B,$91
                                  .db $1B,$00,$00,$E7,$17,$ED,$1B,$6E
                                  .db $1C,$8F,$1C,$1B,$1C,$48,$1C,$5B
                                  .db $1C,$00,$00,$E7,$17,$C8,$1A,$AB
                                  .db $1B,$CC,$1B,$3F,$1B,$77,$1B,$91
                                  .db $1B,$01,$1B,$E7,$17,$B0,$1C,$70
                                  .db $1D,$90,$1D,$19,$1D,$4A,$1D,$5D
                                  .db $1D,$E2,$1C,$AE,$1D,$3D,$16,$93
                                  .db $17,$BD,$17,$1B,$17,$57,$17,$99
                                  .db $16,$7C,$16,$E7,$17,$3D,$16,$93
                                  .db $17,$BD,$17,$1B,$17,$57,$17,$DE
                                  .db $16,$7C,$16,$E7,$17,$00,$18,$EF
                                  .db $18,$10,$19,$89,$18,$BC,$18,$55
                                  .db $18,$34,$18,$E7,$17,$26,$1A,$A6
                                  .db $1A,$B7,$1A,$4E,$1A,$67,$1A,$80
                                  .db $1A,$40,$1A,$E7,$17,$32,$16,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$3A,$16,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$C1,$1D,$D4
                                  .db $1D,$58,$1E,$F8,$1D,$3E,$1E,$0A
                                  .db $1E,$E6,$1D,$24,$1E,$2C,$15,$4C
                                  .db $15,$2C,$15,$5C,$15,$6C,$15,$7C
                                  .db $15,$6C,$15,$9C,$15,$FF,$00,$1C
                                  .db $16,$00,$00,$DA,$04,$E2,$16,$E3
                                  .db $90,$1B,$00,$E4,$01,$00,$DA,$12
                                  .db $E2,$1E,$DB,$0A,$DE,$14,$19,$27
                                  .db $0C,$6D,$B4,$0C,$2E,$B7,$B9,$30
                                  .db $6E,$B7,$0C,$2D,$B9,$0C,$6E,$BB
                                  .db $C6,$0C,$2D,$BB,$30,$6E,$B9,$0C
                                  .db $2D,$B3,$0C,$6E,$B4,$0C,$2D,$B7
                                  .db $B9,$30,$6E,$B7,$0C,$2D,$B8,$0C
                                  .db $6E,$B9,$C6,$0C,$2D,$B9,$30,$6E
                                  .db $B7,$0C,$2D,$B8,$00,$DA,$12,$DB
                                  .db $0F,$DE,$14,$14,$20,$48,$6D,$B7
                                  .db $18,$B9,$48,$B7,$0C,$B4,$B5,$30
                                  .db $B7,$0C,$C6,$B9,$B7,$B9,$48,$B7
                                  .db $18,$B4,$DA,$00,$DB,$05,$DE,$14
                                  .db $19,$27,$30,$6B,$C7,$0C,$C7,$B7
                                  .db $0C,$2C,$B9,$BC,$06,$7B,$BB,$BC
                                  .db $0C,$69,$BB,$18,$C6,$0C,$C7,$B3
                                  .db $0C,$2C,$B7,$BB,$06,$7B,$B9,$BB
                                  .db $0C,$69,$B9,$18,$C6,$0C,$C7,$B2
                                  .db $0C,$2C,$B4,$B9,$06,$7B,$B7,$B9
                                  .db $0C,$69,$B7,$18,$C6,$0C,$C7,$06
                                  .db $4B,$AD,$AF,$B0,$B2,$B4,$B5,$30
                                  .db $6B,$B4,$0C,$C7,$B7,$0C,$2C,$B9
                                  .db $BC,$06,$7B,$BB,$BC,$0C,$69,$BB
                                  .db $18,$C6,$0C,$C7,$B3,$0C,$2C,$B7
                                  .db $BB,$06,$7B,$B9,$BB,$0C,$69,$B9
                                  .db $18,$C6,$0C,$C7,$B2,$0C,$2C,$B4
                                  .db $B9,$06,$7B,$B7,$B9,$0C,$69,$B7
                                  .db $18,$C6,$0C,$C7,$06,$4B,$AD,$AF
                                  .db $B0,$B2,$B4,$B5,$DA,$12,$DB,$08
                                  .db $DE,$14,$1F,$25,$0C,$6D,$B0,$0C
                                  .db $2E,$B4,$B4,$30,$6E,$B4,$0C,$2D
                                  .db $B4,$0C,$6E,$B7,$C6,$0C,$2D,$B7
                                  .db $30,$6E,$B3,$0C,$2D,$AF,$0C,$6E
                                  .db $AE,$0C,$2D,$B2,$B2,$30,$6E,$B2
                                  .db $0C,$2D,$B2,$0C,$6E,$B4,$C6,$0C
                                  .db $2D,$B4,$30,$6E,$B4,$0C,$2D,$B4
                                  .db $DA,$12,$DB,$0C,$DE,$14,$1B,$26
                                  .db $0C,$6D,$AB,$0C,$2E,$B0,$B0,$30
                                  .db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B3
                                  .db $C6,$0C,$2D,$B3,$30,$6E,$AF,$0C
                                  .db $2D,$AB,$0C,$6E,$AB,$0C,$2E,$AE
                                  .db $AE,$30,$6E,$AE,$0C,$2D,$AE,$0C
                                  .db $6E,$B1,$C6,$0C,$2D,$B1,$30,$6E
                                  .db $B1,$0C,$2D,$B1,$DA,$04,$DB,$08
                                  .db $DE,$14,$19,$28,$0C,$3B,$C7,$9C
                                  .db $C7,$9C,$C7,$9C,$C7,$9C,$C7,$9B
                                  .db $C7,$9B,$C7,$9B,$C7,$9B,$C7,$9A
                                  .db $C7,$9A,$C7,$9A,$C7,$9A,$C7,$99
                                  .db $C7,$99,$C7,$99,$C7,$99,$DA,$08
                                  .db $DB,$0C,$DE,$14,$19,$28,$0C,$6E
                                  .db $98,$9F,$93,$9F,$98,$9F,$93,$9F
                                  .db $97,$9F,$93,$9F,$97,$9F,$93,$9F
                                  .db $96,$9F,$93,$9F,$96,$9F,$93,$9F
                                  .db $95,$9C,$90,$9C,$95,$9C,$90,$9C
                                  .db $DA,$05,$DB,$14,$DE,$00,$00,$00
                                  .db $E9,$F3,$17,$08,$0C,$4B,$D1,$0C
                                  .db $4C,$D2,$0C,$49,$D1,$0C,$4B,$D2
                                  .db $00,$0C,$6E,$B9,$0C,$2D,$BB,$BC
                                  .db $30,$6E,$B9,$0C,$2D,$B8,$0C,$6E
                                  .db $B7,$0C,$2D,$B8,$B9,$30,$6E,$B4
                                  .db $0C,$C7,$12,$6E,$B4,$06,$6D,$B3
                                  .db $0C,$2C,$B2,$12,$6E,$B4,$06,$6D
                                  .db $B3,$0C,$2C,$B2,$0C,$2E,$B4,$B2
                                  .db $30,$4E,$B7,$C6,$00,$30,$6D,$B0
                                  .db $0C,$C6,$AF,$C6,$AD,$AB,$AC,$AD
                                  .db $B4,$30,$C6,$24,$B4,$18,$B0,$0C
                                  .db $AF,$B0,$B1,$30,$B2,$06,$C7,$AB
                                  .db $AD,$AF,$B0,$B2,$B4,$B5,$06,$7B
                                  .db $B4,$B5,$0C,$69,$B4,$18,$C6,$0C
                                  .db $C7,$06,$4B,$AF,$B0,$B2,$B4,$B5
                                  .db $B6,$06,$7B,$B7,$B9,$0C,$69,$B7
                                  .db $18,$C6,$0C,$C7,$06,$4B,$B2,$B4
                                  .db $B5,$B7,$B9,$BB,$30,$BC,$C6,$BB
                                  .db $0C,$C7,$06,$4B,$BB,$BC,$BB,$B9
                                  .db $B7,$B5,$0C,$6E,$B5,$0C,$2D,$B5
                                  .db $B9,$30,$6E,$B6,$0C,$2D,$B6,$0C
                                  .db $6E,$B4,$0C,$2D,$B4,$B4,$30,$6E
                                  .db $B1,$0C,$C7,$12,$6E,$AD,$06,$6D
                                  .db $AD,$0C,$2C,$AD,$12,$6E,$AD,$06
                                  .db $6D,$AD,$0C,$2C,$AD,$0C,$2E,$AD
                                  .db $AD,$30,$4E,$B2,$C6,$0C,$6E,$B0
                                  .db $0C,$2D,$B0,$B5,$30,$6E,$B0,$0C
                                  .db $2D,$B0,$0C,$6E,$B0,$0C,$2D,$B0
                                  .db $B0,$30,$6E,$AB,$0C,$C7,$12,$6E
                                  .db $A9,$06,$6D,$A9,$0C,$2C,$A9,$12
                                  .db $6E,$A9,$06,$6D,$A9,$0C,$2C,$A9
                                  .db $0C,$2E,$A9,$A9,$30,$4E,$AF,$C6
                                  .db $0C,$C7,$9D,$C7,$9D,$C7,$9E,$C7
                                  .db $9E,$C7,$9C,$C7,$9C,$C7,$99,$C7
                                  .db $99,$C7,$9A,$C7,$9A,$C7,$9A,$C7
                                  .db $9A,$C7,$97,$C7,$97,$C7,$97,$C7
                                  .db $97,$0C,$91,$A1,$98,$A1,$92,$A1
                                  .db $98,$A1,$93,$9F,$98,$9F,$95,$9F
                                  .db $90,$9F,$8E,$9D,$95,$9D,$8E,$9D
                                  .db $90,$91,$93,$9D,$8E,$9D,$93,$9D
                                  .db $8E,$9D,$0C,$6E,$B9,$0C,$2D,$BB
                                  .db $BC,$30,$6E,$B9,$0C,$2D,$B8,$0C
                                  .db $6E,$B7,$0C,$2D,$B8,$B9,$30,$6E
                                  .db $C0,$0C,$C7,$0C,$6E,$C0,$0C,$2D
                                  .db $BF,$C0,$18,$6E,$BC,$0C,$2E,$BC
                                  .db $18,$6E,$B9,$30,$4E,$BC,$C6,$00
                                  .db $06,$7B,$B4,$B5,$0C,$69,$B4,$18
                                  .db $C6,$0C,$C7,$06,$4B,$AF,$B0,$B2
                                  .db $B4,$B5,$B6,$06,$7B,$B7,$B9,$0C
                                  .db $69,$B7,$18,$C6,$0C,$C7,$06,$4B
                                  .db $B2,$B4,$B5,$B7,$B9,$BB,$30,$BC
                                  .db $BB,$60,$BC,$0C,$6E,$B5,$0C,$2D
                                  .db $B5,$B9,$30,$6E,$B6,$0C,$2D,$B6
                                  .db $0C,$6E,$B4,$0C,$2D,$B4,$B4,$30
                                  .db $6E,$BD,$0C,$C7,$0C,$6E,$B9,$0C
                                  .db $2D,$B9,$B9,$18,$6E,$B9,$0C,$2E
                                  .db $B5,$18,$6E,$B5,$30,$4E,$B7,$C6
                                  .db $0C,$6E,$B0,$0C,$2D,$B0,$B5,$30
                                  .db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B0
                                  .db $0C,$2D,$B0,$B0,$30,$6E,$B7,$0C
                                  .db $C7,$0C,$6E,$B5,$0C,$2D,$B5,$B5
                                  .db $18,$6E,$B5,$0C,$2E,$B2,$18,$6E
                                  .db $B2,$30,$4E,$B4,$C6,$0C,$C7,$98
                                  .db $C7,$98,$C7,$98,$C7,$98,$C7,$9C
                                  .db $C7,$9C,$C7,$99,$C7,$99,$C7,$95
                                  .db $C7,$95,$C7,$97,$C7,$97,$C7,$9C
                                  .db $C7,$9C,$C7,$9C,$C7,$9C,$0C,$91
                                  .db $9D,$98,$9D,$92,$9E,$98,$9E,$93
                                  .db $9F,$9A,$9F,$95,$A1,$9C,$A1,$8E
                                  .db $9A,$95,$9A,$93,$9F,$9A,$9F,$98
                                  .db $9F,$93,$9F,$98,$98,$97,$96,$0C
                                  .db $6E,$B9,$0C,$2D,$BB,$BC,$30,$6E
                                  .db $B9,$0C,$2D,$B8,$0C,$6E,$B7,$0C
                                  .db $2D,$B8,$B9,$30,$6E,$C0,$0C,$C7
                                  .db $00,$30,$6D,$B0,$0C,$C6,$AF,$C6
                                  .db $AD,$AB,$AC,$AD,$B4,$30,$C6,$0C
                                  .db $6E,$B5,$0C,$2D,$B5,$B9,$30,$6E
                                  .db $B6,$0C,$2D,$B6,$0C,$6E,$B4,$0C
                                  .db $2D,$B4,$B4,$30,$6E,$BD,$0C,$C7
                                  .db $0C,$6E,$B0,$0C,$2D,$B0,$B5,$30
                                  .db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B0
                                  .db $0C,$2D,$B0,$B0,$30,$6E,$B7,$0C
                                  .db $C7,$06,$7B,$B4,$B5,$0C,$69,$B4
                                  .db $18,$C6,$0C,$C7,$06,$4B,$AF,$B0
                                  .db $B2,$B4,$B5,$B6,$06,$7B,$B7,$B9
                                  .db $0C,$69,$B7,$18,$C6,$0C,$C7,$06
                                  .db $4B,$B2,$B4,$B5,$B7,$B9,$BB,$0C
                                  .db $C7,$98,$C7,$98,$C7,$98,$C7,$98
                                  .db $C7,$9C,$C7,$9C,$C7,$99,$C7,$99
                                  .db $0C,$91,$9D,$98,$9D,$92,$9E,$98
                                  .db $9E,$93,$9F,$9A,$9F,$95,$A1,$9C
                                  .db $A1,$DA,$12,$18,$6D,$AD,$0C,$B4
                                  .db $C7,$C7,$0C,$2D,$B4,$0C,$6E,$B3
                                  .db $0C,$2D,$B4,$0C,$6E,$B5,$0C,$2D
                                  .db $B4,$B1,$30,$6E,$AD,$0C,$2D,$AD
                                  .db $0C,$6E,$B4,$0C,$2D,$B2,$0C,$6D
                                  .db $B4,$0C,$2D,$B2,$0C,$6E,$B4,$0C
                                  .db $2D,$B2,$C7,$0C,$6D,$AD,$30,$C6
                                  .db $C7,$00,$DB,$0F,$DE,$14,$14,$20
                                  .db $DA,$12,$18,$6D,$B9,$0C,$C0,$C7
                                  .db $C7,$0C,$2D,$C0,$0C,$6E,$BF,$0C
                                  .db $2D,$C0,$0C,$6E,$C1,$0C,$2D,$C0
                                  .db $BD,$30,$6E,$B9,$0C,$2D,$B9,$0C
                                  .db $6E,$C0,$0C,$2D,$BE,$0C,$6D,$C0
                                  .db $0C,$2D,$BE,$0C,$6E,$C0,$0C,$2D
                                  .db $BE,$C7,$0C,$6D,$B9,$30,$C6,$C7
                                  .db $DA,$12,$18,$6D,$A8,$0C,$AB,$C7
                                  .db $C7,$0C,$2D,$AB,$0C,$6E,$AA,$0C
                                  .db $2D,$AB,$0C,$6E,$AD,$0C,$2D,$AB
                                  .db $A8,$30,$6E,$A5,$0C,$2D,$A5,$0C
                                  .db $6E,$AB,$0C,$2D,$AA,$0C,$6D,$AB
                                  .db $0C,$2D,$AA,$0C,$6E,$AB,$0C,$2D
                                  .db $AA,$C7,$0C,$6D,$A4,$30,$C6,$C7
                                  .db $DB,$05,$DE,$19,$19,$35,$DA,$00
                                  .db $30,$6B,$A8,$0C,$C6,$A7,$A8,$AD
                                  .db $48,$B4,$0C,$B3,$B4,$30,$B9,$B4
                                  .db $60,$B2,$DB,$08,$DE,$19,$18,$34
                                  .db $DA,$00,$30,$6B,$9F,$0C,$C6,$9E
                                  .db $9F,$A5,$48,$AB,$0C,$AA,$AB,$30
                                  .db $B4,$AB,$60,$AA,$0C,$C7,$99,$C7
                                  .db $99,$C7,$99,$C7,$99,$C7,$99,$C7
                                  .db $99,$C7,$99,$C7,$99,$C7,$98,$C7
                                  .db $98,$C7,$98,$C7,$98,$C7,$98,$C7
                                  .db $98,$C7,$98,$C7,$98,$0C,$95,$9F
                                  .db $90,$9F,$95,$9F,$90,$9F,$95,$9F
                                  .db $90,$9F,$95,$9F,$90,$8F,$8E,$9E
                                  .db $95,$9E,$8E,$9E,$95,$9E,$8E,$9E
                                  .db $95,$9E,$8E,$9E,$90,$92,$18,$6D
                                  .db $AB,$0C,$B2,$C7,$C7,$0C,$2D,$B2
                                  .db $0C,$6E,$B1,$0C,$2D,$B2,$0C,$6E
                                  .db $B4,$0C,$2D,$B2,$AF,$30,$6E,$AB
                                  .db $0C,$2D,$B2,$18,$4E,$B0,$B0,$10
                                  .db $6D,$B0,$10,$6E,$B2,$10,$6E,$B3
                                  .db $30,$B4,$C7,$00,$18,$6D,$A3,$0C
                                  .db $A9,$C7,$C7,$0C,$2D,$A9,$0C,$6E
                                  .db $A8,$0C,$2D,$A9,$0C,$6E,$AB,$0C
                                  .db $2D,$A9,$A6,$30,$6E,$A3,$0C,$2D
                                  .db $A9,$18,$4E,$A8,$A8,$10,$6D,$A8
                                  .db $10,$6E,$A9,$10,$6E,$AA,$30,$AC
                                  .db $C7,$30,$69,$AB,$0C,$C6,$A9,$AB
                                  .db $AF,$48,$B2,$0C,$B0,$B2,$48,$B0
                                  .db $18,$B2,$60,$B4,$30,$69,$A3,$0C
                                  .db $C6,$A3,$A6,$A9,$48,$AB,$0C,$A9
                                  .db $AB,$48,$A8,$18,$AB,$60,$AC,$0C
                                  .db $C7,$97,$C7,$97,$C7,$97,$C7,$97
                                  .db $C7,$97,$C7,$97,$C7,$97,$C7,$97
                                  .db $C7,$9C,$C7,$9C,$C7,$9C,$C7,$9C
                                  .db $C7,$97,$C7,$97,$C7,$97,$C7,$97
                                  .db $0C,$93,$9D,$8E,$9D,$93,$9D,$8E
                                  .db $9D,$93,$9D,$8E,$9D,$93,$9D,$95
                                  .db $97,$98,$9F,$93,$9F,$98,$9F,$93
                                  .db $9F,$90,$A0,$97,$A0,$90,$A0,$92
                                  .db $94,$18,$6D,$AB,$0C,$B2,$C7,$C7
                                  .db $0C,$2D,$B2,$0C,$6E,$B1,$0C,$2D
                                  .db $B2,$0C,$6E,$B4,$0C,$2D,$B2,$C7
                                  .db $30,$6E,$AB,$0C,$2D,$B2,$18,$4E
                                  .db $B0,$B0,$10,$6D,$B0,$10,$6E,$B2
                                  .db $10,$6E,$B3,$18,$2E,$B4,$C7,$30
                                  .db $4E,$B7,$00,$18,$6D,$B7,$0C,$BE
                                  .db $C7,$C7,$0C,$2D,$BE,$0C,$6E,$BD
                                  .db $0C,$2D,$BE,$0C,$6E,$C0,$0C,$2D
                                  .db $BE,$C7,$30,$6E,$B7,$0C,$2D,$BE
                                  .db $18,$4E,$BC,$BC,$10,$6D,$BC,$10
                                  .db $6E,$BE,$10,$6E,$BF,$18,$2E,$C0
                                  .db $C7,$06,$C7,$AB,$AD,$AF,$B0,$B2
                                  .db $B4,$B5,$18,$6D,$A3,$0C,$A9,$C7
                                  .db $C7,$0C,$2D,$A9,$0C,$6E,$A8,$0C
                                  .db $2D,$A9,$0C,$6E,$AB,$0C,$2D,$A9
                                  .db $C7,$30,$6E,$A3,$0C,$2D,$A9,$18
                                  .db $4E,$A8,$A8,$10,$6D,$A8,$10,$6E
                                  .db $A9,$10,$6E,$AA,$18,$2E,$AB,$C7
                                  .db $30,$4E,$AF,$30,$69,$AB,$0C,$C6
                                  .db $A9,$AB,$AF,$48,$B2,$0C,$B0,$B2
                                  .db $30,$B0,$B2,$30,$B4,$B3,$30,$69
                                  .db $A3,$0C,$C6,$A3,$A6,$A9,$48,$AB
                                  .db $0C,$A9,$AB,$30,$A8,$AB,$30,$AB
                                  .db $AF,$0C,$C7,$97,$C7,$97,$C7,$97
                                  .db $C7,$97,$C7,$97,$C7,$97,$C7,$97
                                  .db $C7,$97,$C7,$9C,$C7,$9C,$C7,$9C
                                  .db $C7,$9C,$DA,$01,$18,$AF,$C7,$A7
                                  .db $C6,$0C,$93,$9D,$8E,$9D,$93,$9D
                                  .db $8E,$9D,$93,$9D,$8E,$9D,$93,$9D
                                  .db $95,$97,$98,$9F,$93,$9F,$98,$9F
                                  .db $93,$9F,$18,$8C,$C7,$93,$C6,$DA
                                  .db $05,$DB,$14,$DE,$00,$00,$00,$E9
                                  .db $F3,$17,$06,$18,$4C,$D1,$C7,$30
                                  .db $6D,$D2,$DA,$04,$DB,$0A,$DE,$22
                                  .db $19,$38,$60,$5E,$BC,$C6,$DA,$01
                                  .db $60,$C6,$C6,$C6,$00,$DA,$04,$DB
                                  .db $08,$DE,$20,$18,$36,$60,$5D,$B4
                                  .db $C6,$DA,$01,$60,$C6,$C6,$C6,$DA
                                  .db $04,$DB,$0C,$DE,$21,$1A,$37,$60
                                  .db $5D,$AB,$C6,$DA,$01,$60,$C6,$C6
                                  .db $C6,$DA,$04,$DB,$0A,$DE,$22,$18
                                  .db $36,$60,$5D,$A4,$C6,$DA,$01,$60
                                  .db $C6,$C6,$C6,$DA,$04,$DB,$0F,$10
                                  .db $5D,$B0,$C7,$B0,$AE,$C7,$AE,$AD
                                  .db $C7,$AD,$AC,$C7,$AC,$30,$AB,$24
                                  .db $A7,$6C,$A6,$60,$C6,$DA,$04,$DB
                                  .db $0F,$10,$5D,$AB,$C7,$AB,$A8,$C7
                                  .db $A8,$A9,$C7,$A9,$A9,$C7,$A9,$30
                                  .db $A6,$24,$A3,$6C,$A2,$60,$C6,$DA
                                  .db $04,$DB,$0F,$10,$5D,$A8,$C7,$A8
                                  .db $A4,$C7,$A4,$A4,$C7,$A4,$A4,$C7
                                  .db $A4,$30,$A3,$24,$9D,$6C,$9C,$60
                                  .db $C6,$DA,$08,$DB,$0A,$DE,$22,$19
                                  .db $38,$10,$5D,$8C,$8C,$8C,$90,$90
                                  .db $90,$91,$91,$91,$92,$92,$92,$30
                                  .db $93,$24,$93,$6C,$8C,$60,$C6,$DA
                                  .db $01,$E2,$12,$DB,$0A,$DE,$14,$19
                                  .db $28,$18,$7C,$A7,$0C,$A8,$AB,$AD
                                  .db $30,$AB,$0C,$AD,$AF,$C6,$AF,$30
                                  .db $AD,$0C,$A7,$A8,$AB,$AD,$30,$AB
                                  .db $0C,$AC,$AD,$C6,$AD,$60,$AB,$60
                                  .db $77,$C6,$00,$DA,$02,$DB,$0A,$18
                                  .db $79,$A7,$0C,$A8,$AB,$AD,$30,$AB
                                  .db $0C,$AD,$AF,$C6,$AF,$30,$AD,$0C
                                  .db $A7,$A8,$AB,$AD,$30,$AB,$0C,$AC
                                  .db $AD,$C6,$AD,$60,$AB,$C6,$DA,$01
                                  .db $DB,$0C,$DE,$14,$19,$28,$06,$C6
                                  .db $18,$79,$A7,$0C,$A8,$AB,$AD,$30
                                  .db $AB,$0C,$AD,$AF,$C6,$AF,$30,$AD
                                  .db $0C,$A7,$A8,$AB,$AD,$30,$AB,$0C
                                  .db $AC,$AD,$C6,$AD,$60,$AB,$60,$75
                                  .db $C6,$DA,$01,$DB,$0A,$DE,$14,$19
                                  .db $28,$18,$7B,$C7,$60,$98,$97,$96
                                  .db $95,$C6,$C6,$C6,$DA,$01,$DB,$0A
                                  .db $DE,$14,$19,$28,$18,$7B,$C7,$0C
                                  .db $C7,$24,$9F,$30,$B0,$0C,$C7,$24
                                  .db $9F,$30,$AF,$0C,$C7,$24,$9F,$30
                                  .db $AE,$0C,$C7,$24,$9F,$30,$B1,$60
                                  .db $C6,$C6,$C6,$DA,$01,$DB,$0A,$DE
                                  .db $14,$19,$28,$18,$7B,$C7,$18,$C7
                                  .db $48,$A8,$18,$C7,$48,$A7,$18,$C7
                                  .db $48,$A6,$18,$C7,$48,$A5,$60,$C6
                                  .db $C6,$C6,$DA,$01,$DB,$0A,$DE,$14
                                  .db $19,$28,$18,$7B,$C7,$24,$C7,$3C
                                  .db $AB,$24,$C7,$3C,$AB,$24,$C7,$3C
                                  .db $AB,$24,$C7,$3C,$AB,$60,$C6,$C6
                                  .db $C6,$DA,$01,$DB,$0A,$DE,$14,$19
                                  .db $28,$18,$7B,$C7,$30,$C7,$B4,$30
                                  .db $C7,$B3,$30,$C7,$B2,$30,$C7,$B4
                                  .db $60,$C6,$C6,$C6,$DA,$04,$DB,$08
                                  .db $DE,$22,$18,$14,$08,$5C,$C7,$A9
                                  .db $C7,$A9,$AD,$C7,$24,$AA,$0C,$C7
                                  .db $08,$A9,$A8,$C7,$A8,$A8,$C7,$24
                                  .db $AB,$0C,$C7,$08,$C7,$E2,$1C,$DA
                                  .db $04,$DB,$0A,$DE,$22,$18,$14,$08
                                  .db $5D,$AC,$AD,$C7,$AF,$B0,$C7,$24
                                  .db $AD,$0C,$C7,$08,$AC,$AB,$C7,$AC
                                  .db $AD,$C7,$24,$B4,$0C,$C7,$08,$C7
                                  .db $00,$DA,$04,$DB,$0C,$DE,$22,$18
                                  .db $14,$08,$5C,$C7,$A4,$C7,$A4,$A9
                                  .db $C7,$24,$A4,$0C,$C7,$08,$A4,$A4
                                  .db $C7,$A4,$A4,$C7,$24,$A5,$0C,$C7
                                  .db $08,$C7,$DA,$06,$DB,$0A,$DE,$22
                                  .db $18,$14,$08,$5D,$B8,$B9,$C7,$BB
                                  .db $BC,$C7,$24,$B9,$0C,$C7,$08,$B8
                                  .db $B7,$C7,$B8,$B9,$C7,$24,$C0,$0C
                                  .db $C7,$08,$C7,$DA,$0D,$DB,$0F,$DE
                                  .db $22,$18,$14,$01,$C7,$08,$C7,$18
                                  .db $4E,$C7,$9D,$C7,$9E,$C7,$9F,$C7
                                  .db $9F,$18,$9E,$08,$C7,$C7,$9D,$18
                                  .db $C6,$08,$C7,$C7,$AB,$DA,$0D,$DB
                                  .db $0F,$DE,$22,$18,$14,$08,$C7,$18
                                  .db $4E,$C7,$98,$C7,$98,$C7,$9A,$C7
                                  .db $99,$18,$A1,$08,$C7,$C7,$A3,$18
                                  .db $C6,$08,$C7,$C7,$A4,$DA,$08,$DB
                                  .db $0A,$DE,$22,$18,$14,$08,$C7,$18
                                  .db $5F,$91,$08,$C7,$C7,$91,$18,$92
                                  .db $08,$C7,$C7,$92,$18,$93,$08,$C7
                                  .db $C7,$93,$18,$95,$08,$95,$90,$8F
                                  .db $18,$8E,$08,$C6,$C7,$93,$18,$C6
                                  .db $08,$C7,$C7,$98,$DA,$04,$DB,$14
                                  .db $08,$C7,$18,$6C,$D1,$08,$D2,$C7
                                  .db $D1,$18,$D1,$08,$D2,$C7,$D1,$18
                                  .db $D1,$08,$D2,$C7,$D1,$D1,$C7,$D1
                                  .db $D2,$D1,$D1,$18,$D2,$08,$C6,$C7
                                  .db $D2,$18,$C6,$08,$C7,$C7,$D2,$DA
                                  .db $04,$DB,$0A,$DE,$22,$19,$38,$18
                                  .db $4D,$B4,$08,$C7,$C7,$B4,$E3,$60
                                  .db $18,$18,$B4,$08,$C7,$C7,$B7,$18
                                  .db $B7,$08,$C7,$C7,$B7,$18,$B7,$C7
                                  .db $00,$DA,$04,$DB,$08,$DE,$20,$18
                                  .db $36,$18,$4D,$A4,$08,$C7,$C7,$A4
                                  .db $18,$A4,$08,$C7,$C7,$A7,$18,$A7
                                  .db $08,$C7,$C7,$A7,$18,$A7,$C7,$DA
                                  .db $04,$DB,$0C,$DE,$21,$1A,$37,$18
                                  .db $4D,$AD,$08,$C7,$C7,$AD,$18,$AD
                                  .db $08,$C7,$C7,$AF,$18,$AF,$08,$C7
                                  .db $C7,$AF,$18,$AF,$C7,$DA,$04,$DB
                                  .db $0A,$DE,$22,$18,$36,$18,$4D,$A9
                                  .db $08,$C7,$C7,$A9,$18,$A9,$08,$C7
                                  .db $C7,$AB,$18,$AB,$08,$C7,$C7,$AB
                                  .db $18,$AB,$C7,$DA,$04,$DB,$0F,$08
                                  .db $4D,$C7,$C7,$9A,$18,$9A,$08,$C7
                                  .db $C7,$9A,$18,$9A,$08,$C7,$C7,$9F
                                  .db $18,$9F,$18,$C7,$18,$7D,$9F,$DA
                                  .db $04,$DB,$0F,$08,$4C,$C7,$C7,$8E
                                  .db $18,$8E,$08,$C7,$C7,$8E,$18,$8E
                                  .db $08,$C7,$C7,$93,$18,$93,$18,$C7
                                  .db $18,$7E,$93,$DA,$08,$DB,$0A,$DE
                                  .db $22,$19,$38,$08,$5F,$C7,$C7,$8E
                                  .db $18,$8E,$08,$C7,$C7,$8E,$18,$8E
                                  .db $08,$C7,$C7,$93,$18,$93,$18,$C7
                                  .db $18,$7F,$93,$DA,$00,$DB,$0A,$08
                                  .db $6C,$C7,$C7,$D0,$18,$D0,$08,$C7
                                  .db $C7,$D0,$18,$D0,$08,$C7,$C7,$D0
                                  .db $18,$D0,$18,$C7,$D0,$24,$C7,$00
                                  .db $DA,$04,$E2,$16,$E3,$90,$1C,$DB
                                  .db $0A,$DE,$22,$19,$38,$18,$4C,$B4
                                  .db $08,$C7,$C7,$B4,$18,$B4,$08,$C7
                                  .db $C7,$B7,$18,$B7,$08,$C7,$C7,$B7
                                  .db $18,$B7,$C7,$00,$DA,$04,$DB,$08
                                  .db $DE,$20,$18,$36,$18,$4C,$A4,$08
                                  .db $C7,$C7,$A4,$18,$A4,$08,$C7,$C7
                                  .db $A7,$18,$A7,$08,$C7,$C7,$A7,$18
                                  .db $A7,$C7,$DA,$04,$DB,$0C,$DE,$21
                                  .db $1A,$37,$18,$4C,$AD,$08,$C7,$C7
                                  .db $AD,$18,$AD,$08,$C7,$C7,$AF,$18
                                  .db $AF,$08,$C7,$C7,$AF,$18,$AF,$C7
                                  .db $DA,$04,$DB,$0A,$DE,$22,$18,$36
                                  .db $18,$4C,$A9,$08,$C7,$C7,$A9,$18
                                  .db $A9,$08,$C7,$C7,$AB,$18,$AB,$08
                                  .db $C7,$C7,$AB,$18,$AB,$C7,$DA,$04
                                  .db $DB,$0F,$08,$4C,$C7,$C7,$9A,$18
                                  .db $9A,$08,$C7,$C7,$9A,$18,$9A,$08
                                  .db $C7,$C7,$9F,$18,$9F,$08,$C7,$C7
                                  .db $C7,$18,$7D,$9F,$DA,$04,$DB,$0F
                                  .db $08,$4B,$C7,$C7,$8E,$18,$8E,$08
                                  .db $C7,$C7,$8E,$18,$8E,$08,$C7,$C7
                                  .db $93,$18,$93,$08,$C7,$C7,$C7,$18
                                  .db $7E,$93,$DA,$08,$DB,$0A,$DE,$22
                                  .db $19,$38,$08,$5E,$C7,$C7,$8E,$18
                                  .db $8E,$08,$C7,$C7,$8E,$18,$8E,$08
                                  .db $C7,$C7,$93,$18,$93,$08,$C7,$C7
                                  .db $C7,$18,$7F,$93,$DA,$00,$DB,$0A
                                  .db $08,$6B,$C7,$C7,$D0,$18,$D0,$08
                                  .db $C7,$C7,$D0,$18,$D0,$08,$C7,$C7
                                  .db $D0,$18,$D0,$C7,$08,$D0,$DB,$14
                                  .db $08,$D1,$D1,$DA,$00,$DB,$0A,$DE
                                  .db $22,$19,$38,$08,$5D,$A8,$C7,$AB
                                  .db $AD,$C7,$24,$AB,$0C,$C7,$08,$AD
                                  .db $AF,$C7,$B0,$AF,$AE,$24,$AD,$0C
                                  .db $C7,$08,$A7,$A8,$C7,$AB,$AD,$C7
                                  .db $24,$AB,$0C,$C7,$08,$AC,$AD,$C7
                                  .db $AE,$AD,$AC,$24,$AB,$0C,$C7,$08
                                  .db $AC,$00,$DA,$06,$DB,$0A,$DE,$22
                                  .db $19,$38,$08,$5D,$A8,$C7,$AB,$AD
                                  .db $C7,$24,$AB,$0C,$C7,$08,$AD,$AF
                                  .db $C7,$B0,$AF,$AE,$24,$AD,$0C,$C7
                                  .db $08,$A7,$A8,$C7,$AB,$AD,$C7,$24
                                  .db $AB,$0C,$C7,$08,$AC,$AD,$C7,$AE
                                  .db $AD,$AC,$24,$AB,$0C,$C7,$08,$AC
                                  .db $00,$DA,$12,$DB,$05,$DE,$22,$19
                                  .db $28,$60,$6B,$B4,$30,$B3,$08,$C6
                                  .db $C6,$B3,$BB,$C6,$B9,$48,$B7,$18
                                  .db $B2,$60,$B1,$DA,$06,$DB,$08,$DE
                                  .db $14,$1F,$30,$08,$6B,$A4,$C7,$A4
                                  .db $A8,$C7,$24,$A4,$0C,$C7,$08,$A8
                                  .db $AB,$C7,$AB,$A7,$A7,$24,$A7,$0C
                                  .db $C7,$08,$A3,$A2,$C7,$A6,$A6,$C7
                                  .db $24,$A6,$0C,$C7,$08,$A6,$A8,$C7
                                  .db $AB,$A8,$A8,$24,$A8,$0C,$C7,$08
                                  .db $A8,$08,$6D,$A4,$C7,$A4,$A8,$C7
                                  .db $24,$A4,$0C,$C7,$08,$A8,$AB,$C7
                                  .db $AB,$A7,$A7,$24,$A7,$0C,$C7,$08
                                  .db $A3,$A2,$C7,$A6,$A6,$C7,$24,$A6
                                  .db $0C,$C7,$08,$A6,$A8,$C7,$AB,$A8
                                  .db $A8,$24,$A8,$0C,$C7,$08,$A8,$DA
                                  .db $06,$DB,$0C,$DE,$14,$1F,$30,$08
                                  .db $6D,$9F,$C7,$A8,$A4,$C7,$24,$A8
                                  .db $0C,$C7,$08,$A4,$A7,$C7,$A7,$AB
                                  .db $AB,$24,$A3,$0C,$C7,$08,$9F,$9F
                                  .db $C7,$A2,$A2,$C7,$24,$A2,$0C,$C7
                                  .db $08,$A2,$A5,$C7,$A8,$A5,$A5,$24
                                  .db $A5,$0C,$C7,$08,$A5,$DA,$0D,$DB
                                  .db $0F,$01,$C7,$18,$4E,$C7,$9F,$C7
                                  .db $9F,$C7,$9F,$C7,$9F,$C7,$9F,$C7
                                  .db $9F,$C7,$9F,$C7,$9F,$DA,$0D,$DB
                                  .db $0F,$18,$4E,$C7,$9C,$C7,$9C,$C7
                                  .db $9B,$C7,$9B,$C7,$9A,$C7,$9A,$C7
                                  .db $99,$C7,$99,$DA,$08,$DB,$0A,$DE
                                  .db $14,$1F,$30,$18,$6F,$98,$C7,$18
                                  .db $93,$08,$C7,$C7,$93,$18,$97,$C7
                                  .db $18,$93,$08,$C7,$C7,$93,$18,$96
                                  .db $C7,$18,$93,$08,$C7,$C7,$93,$18
                                  .db $95,$C7,$18,$90,$08,$C7,$C7,$90
                                  .db $DA,$00,$DB,$14,$18,$6B,$D1,$08
                                  .db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7
                                  .db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1
                                  .db $C7,$D1,$D2,$D1,$D1,$18,$D1,$08
                                  .db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7
                                  .db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1
                                  .db $C7,$D1,$D2,$D1,$D1,$08,$AD,$C7
                                  .db $AF,$B0,$C7,$24,$AD,$0C,$C7,$08
                                  .db $AC,$AB,$C7,$AC,$AD,$C7,$24,$A8
                                  .db $0C,$C7,$08,$C7,$A8,$C7,$A4,$A1
                                  .db $C7,$A8,$A4,$C7,$A1,$A4,$C7,$AB
                                  .db $30,$C6,$C7,$00,$01,$C7,$18,$C7
                                  .db $9D,$C7,$9E,$C7,$9F,$C7,$9F,$18
                                  .db $9E,$08,$C7,$C7,$9E,$18,$C6,$08
                                  .db $9E,$C7,$9F,$18,$C6,$08,$C7,$C7
                                  .db $A3,$A4,$C7,$A4,$A6,$C7,$A6,$18
                                  .db $C7,$98,$C7,$98,$C7,$9A,$C7,$99
                                  .db $18,$A1,$08,$C7,$C7,$A1,$18,$C6
                                  .db $08,$A1,$C7,$A3,$18,$C6,$08,$C7
                                  .db $C7,$9A,$9C,$C7,$9C,$9D,$C7,$9D
                                  .db $18,$91,$08,$C7,$C7,$91,$18,$92
                                  .db $08,$C7,$C7,$92,$18,$93,$08,$C7
                                  .db $C7,$93,$18,$95,$08,$95,$90,$8F
                                  .db $18,$8E,$08,$C6,$C7,$8E,$18,$C6
                                  .db $08,$8E,$C7,$93,$18,$C6,$08,$C7
                                  .db $C7,$93,$95,$C7,$95,$97,$C7,$97
                                  .db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
                                  .db $08,$D2,$C7,$D1,$18,$D1,$08,$D2
                                  .db $C7,$D1,$D1,$C7,$D1,$D2,$D1,$D1
                                  .db $18,$D2,$08,$C6,$C7,$D2,$18,$C6
                                  .db $08,$D2,$C7,$D2,$18,$C6,$08,$C6
                                  .db $C7,$D1,$D2,$C7,$D1,$D2,$D1,$D1
                                  .db $08,$A9,$C7,$A9,$AD,$C7,$24,$AA
                                  .db $0C,$C7,$08,$A9,$A8,$C7,$A8,$A8
                                  .db $C7,$24,$AB,$0C,$C7,$08,$C7,$AD
                                  .db $C7,$AD,$AD,$C7,$A9,$C7,$C7,$A9
                                  .db $A9,$C7,$A8,$30,$C6,$C7,$08,$AD
                                  .db $C7,$AF,$B0,$C7,$24,$AD,$0C,$C7
                                  .db $08,$AC,$AB,$C7,$AC,$AD,$C7,$24
                                  .db $B4,$0C,$C7,$08,$C7,$B4,$C7,$B3
                                  .db $B4,$C7,$B0,$C7,$C7,$B0,$AD,$C7
                                  .db $B0,$30,$C6,$C7,$00,$48,$B0,$08
                                  .db $AD,$C6,$B0,$48,$B4,$08,$B3,$C6
                                  .db $B4,$30,$B9,$30,$B4,$60,$B0,$01
                                  .db $C7,$18,$C7,$9D,$C7,$9E,$C7,$9F
                                  .db $C7,$9F,$18,$9E,$08,$C7,$C7,$9D
                                  .db $18,$C6,$08,$C7,$C7,$AB,$18,$C6
                                  .db $08,$B0,$C7,$B0,$AF,$C7,$AF,$AE
                                  .db $C7,$AE,$18,$C7,$98,$C7,$98,$C7
                                  .db $9A,$C7,$99,$18,$A1,$08,$C7,$C7
                                  .db $A3,$18,$C6,$08,$C7,$C7,$A4,$18
                                  .db $C6,$08,$A8,$C7,$A8,$A7,$C7,$A7
                                  .db $A6,$C7,$A6,$18,$91,$08,$C7,$C7
                                  .db $91,$18,$92,$08,$C7,$C7,$92,$18
                                  .db $93,$08,$C7,$C7,$93,$18,$95,$08
                                  .db $95,$90,$8F,$18,$8E,$08,$C6,$C7
                                  .db $93,$18,$C6,$08,$C7,$C7,$98,$18
                                  .db $C6,$08,$98,$C7,$98,$97,$C7,$97
                                  .db $96,$C7,$96,$18,$D1,$08,$D2,$C7
                                  .db $D1,$18,$D1,$08,$D2,$C7,$D1,$18
                                  .db $D1,$08,$D2,$C7,$D1,$D1,$C7,$D1
                                  .db $D2,$D1,$D1,$18,$D2,$08,$C6,$C7
                                  .db $D2,$18,$C6,$08,$C7,$C7,$D2,$18
                                  .db $C6,$08,$D2,$C7,$D1,$D2,$C7,$D1
                                  .db $D2,$C7,$D1,$DA,$04,$18,$6C,$AD
                                  .db $B4,$08,$B4,$C7,$B4,$B3,$C7,$B4
                                  .db $B5,$C6,$B4,$B1,$C7,$24,$AD,$0C
                                  .db $C7,$08,$AD,$B4,$C6,$B2,$B4,$C6
                                  .db $B2,$B4,$C6,$B2,$B0,$C7,$AD,$30
                                  .db $C6,$C7,$00,$DA,$04,$18,$6B,$A8
                                  .db $AB,$08,$AB,$C7,$AB,$AA,$C7,$AB
                                  .db $AD,$C6,$AB,$A8,$C7,$24,$A5,$0C
                                  .db $C7,$08,$A5,$AB,$C6,$AA,$AB,$C6
                                  .db $AA,$AB,$C6,$AA,$A8,$C7,$A4,$30
                                  .db $C6,$C7,$18,$C7,$08,$AD,$C6,$AC
                                  .db $AD,$C6,$B4,$C6,$C6,$AD,$AD,$C6
                                  .db $AC,$AD,$C6,$B4,$C6,$C6,$AD,$AF
                                  .db $C6,$B1,$18,$C7,$08,$AD,$C6,$AC
                                  .db $AD,$C6,$B2,$C6,$C6,$AD,$AD,$C6
                                  .db $AC,$AD,$C6,$B2,$30,$C6,$01,$C7
                                  .db $18,$C7,$9F,$C7,$9F,$C7,$9F,$C7
                                  .db $9F,$C7,$9E,$C7,$9E,$C7,$9E,$C7
                                  .db $9E,$18,$C7,$99,$C7,$99,$C7,$99
                                  .db $C7,$99,$C7,$98,$C7,$98,$C7,$98
                                  .db $C7,$98,$18,$95,$08,$C7,$C7,$95
                                  .db $18,$90,$08,$C7,$C7,$90,$18,$95
                                  .db $08,$C7,$C7,$95,$18,$95,$08,$95
                                  .db $90,$8F,$18,$8E,$08,$C7,$C7,$8E
                                  .db $18,$95,$08,$C7,$C7,$95,$18,$8E
                                  .db $08,$C7,$C7,$8E,$8E,$C7,$8E,$90
                                  .db $C7,$92,$18,$D1,$08,$D2,$C7,$D1
                                  .db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
                                  .db $08,$D2,$C7,$D1,$D1,$C7,$D1,$D2
                                  .db $D1,$D1,$18,$D1,$08,$D2,$C7,$D1
                                  .db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
                                  .db $08,$D2,$C7,$D1,$D2,$C7,$D1,$D2
                                  .db $C7,$D1,$18,$AB,$B2,$08,$B2,$C7
                                  .db $B2,$B1,$C7,$B2,$B4,$C6,$B2,$AF
                                  .db $C7,$24,$AB,$0C,$C7,$08,$B2,$18
                                  .db $B0,$B0,$10,$B0,$B2,$B3,$18,$B4
                                  .db $C7,$AB,$C6,$00,$18,$A3,$A9,$08
                                  .db $A9,$C7,$A9,$A8,$C7,$A9,$AB,$C6
                                  .db $A9,$A6,$C7,$24,$A3,$0C,$C7,$08
                                  .db $A9,$18,$A8,$A8,$10,$A8,$A9,$AA
                                  .db $18,$AB,$C7,$A3,$C6,$18,$C7,$08
                                  .db $AB,$C6,$AA,$AB,$C6,$B2,$C6,$C6
                                  .db $AB,$AB,$C6,$AA,$AB,$C6,$B2,$C6
                                  .db $C6,$AB,$AD,$C6,$AF,$30,$B0,$10
                                  .db $B0,$AF,$AD,$AB,$06,$AD,$AF,$B0
                                  .db $B2,$B3,$B4,$B5,$B6,$30,$B7,$01
                                  .db $C7,$18,$C7,$9D,$C7,$9D,$C7,$9D
                                  .db $C7,$9D,$C7,$9C,$10,$9C,$9D,$9E
                                  .db $18,$9F,$C7,$9B,$C6,$18,$C7,$97
                                  .db $C7,$97,$C7,$97,$C7,$97,$C7,$9F
                                  .db $10,$9F,$A0,$A1,$18,$A3,$C7,$A3
                                  .db $C6,$18,$93,$08,$C7,$C7,$93,$18
                                  .db $8E,$08,$C7,$C7,$8E,$18,$93,$08
                                  .db $C7,$C7,$93,$18,$93,$08,$93,$95
                                  .db $97,$18,$98,$08,$C7,$C7,$98,$10
                                  .db $98,$9A,$9B,$18,$9C,$C7,$93,$C6
                                  .db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
                                  .db $08,$D2,$C7,$D1,$18,$D1,$08,$D2
                                  .db $C7,$D1,$D1,$C7,$D1,$D2,$D1,$D1
                                  .db $18,$D1,$08,$D2,$C7,$D1,$10,$D2
                                  .db $D2,$D2,$18,$D1,$08,$D2,$C7,$D1
                                  .db $D2,$C7,$D1,$D2,$D1,$D1,$08,$A9
                                  .db $C7,$A9,$AD,$C7,$24,$AA,$0C,$C7
                                  .db $08,$A9,$A8,$C7,$A8,$A8,$C7,$24
                                  .db $AB,$0C,$C7,$08,$C7,$08,$AD,$C7
                                  .db $AF,$B0,$C7,$24,$AD,$0C,$C7,$08
                                  .db $AC,$AB,$C7,$AC,$AD,$C7,$24,$B4
                                  .db $0C,$C7,$08,$C7,$00,$DA,$04,$DB
                                  .db $0C,$DE,$22,$18,$14,$08,$5C,$A4
                                  .db $C7,$A4,$A9,$C7,$24,$A4,$0C,$C7
                                  .db $08,$A4,$A4,$C7,$A4,$A4,$C7,$24
                                  .db $A5,$0C,$C7,$08,$C7,$48,$B0,$08
                                  .db $AD,$C6,$B0,$60,$B4,$01,$C7,$18
                                  .db $C7,$9D,$C7,$9E,$C7,$9F,$C7,$9F
                                  .db $18,$9E,$08,$C7,$C7,$9D,$18,$C6
                                  .db $08,$C7,$C7,$AB,$18,$C7,$98,$C7
                                  .db $98,$C7,$9A,$C7,$99,$18,$A1,$08
                                  .db $C7,$C7,$A3,$18,$C6,$08,$C7,$C7
                                  .db $A4,$18,$91,$08,$C7,$C7,$91,$18
                                  .db $92,$08,$C7,$C7,$92,$18,$93,$08
                                  .db $C7,$C7,$93,$18,$95,$08,$95,$90
                                  .db $8F,$18,$8E,$08,$C6,$C7,$93,$18
                                  .db $C6,$08,$C7,$C7,$98,$18,$D1,$08
                                  .db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7
                                  .db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1
                                  .db $C7,$D1,$D2,$D1,$D1,$18,$D2,$08
                                  .db $C6,$C7,$D2,$18,$C6,$08,$C7,$C7
                                  .db $D2,$DA,$04,$DB,$0A,$DE,$22,$19
                                  .db $38,$18,$4D,$B4,$08,$C7,$C7,$B4
                                  .db $18,$B4,$08,$C7,$C7,$B7,$18,$B7
                                  .db $08,$C7,$C7,$B7,$18,$B7,$C7,$00
                                  .db $DA,$04,$DB,$08,$DE,$20,$18,$36
                                  .db $18,$4D,$A4,$08,$C7,$C7,$A4,$18
                                  .db $A4,$08,$C7,$C7,$A7,$18,$A7,$08
                                  .db $C7,$C7,$A7,$18,$A7,$C7,$DA,$04
                                  .db $DB,$0C,$DE,$21,$1A,$37,$18,$4D
                                  .db $AD,$08,$C7,$C7,$AD,$18,$AD,$08
                                  .db $C7,$C7,$AF,$18,$AF,$08,$C7,$C7
                                  .db $AF,$18,$AF,$C7,$DA,$04,$DB,$0A
                                  .db $DE,$22,$18,$36,$18,$4D,$A9,$08
                                  .db $C7,$C7,$A9,$18,$A9,$08,$C7,$C7
                                  .db $AB,$18,$AB,$08,$C7,$C7,$AB,$18
                                  .db $AB,$C7,$DA,$04,$DB,$0F,$08,$4D
                                  .db $C7,$C7,$9A,$18,$9A,$08,$C7,$C7
                                  .db $9A,$18,$9A,$08,$C7,$C7,$9F,$18
                                  .db $9F,$08,$C7,$C7,$C7,$18,$7D,$9F
                                  .db $DA,$04,$DB,$0F,$08,$4C,$C7,$C7
                                  .db $8E,$18,$8E,$08,$C7,$C7,$8E,$18
                                  .db $8E,$08,$C7,$C7,$93,$18,$93,$08
                                  .db $C7,$C7,$C7,$18,$7E,$93,$DA,$08
                                  .db $DB,$0A,$DE,$22,$19,$38,$08,$5F
                                  .db $C7,$C7,$8E,$18,$8E,$08,$C7,$C7
                                  .db $8E,$18,$8E,$08,$C7,$C7,$93,$18
                                  .db $93,$08,$C7,$C7,$C7,$18,$7F,$93
                                  .db $DA,$00,$DB,$0A,$08,$6C,$C7,$C7
                                  .db $D0,$18,$D0,$08,$C7,$C7,$D0,$18
                                  .db $D0,$08,$C7,$C7,$D0,$18,$D0,$C7
                                  .db $08,$D0,$DB,$14,$08,$D1,$D1,$DA
                                  .db $06,$DB,$0A,$DE,$22,$19,$38,$08
                                  .db $6F,$B4,$C7,$B7,$B9,$C7,$24,$B7
                                  .db $0C,$C7,$08,$B9,$BB,$C7,$BC,$BB
                                  .db $BA,$24,$B9,$0C,$C7,$08,$B3,$B4
                                  .db $C7,$B7,$B9,$C7,$24,$B7,$0C,$C7
                                  .db $08,$B8,$B9,$C7,$BA,$B9,$B8,$24
                                  .db $B7,$0C,$C7,$08,$B8,$00,$08,$B9
                                  .db $C7,$BB,$BC,$C7,$24,$B9,$0C,$C7
                                  .db $08,$B8,$B7,$C7,$B8,$B9,$C7,$24
                                  .db $C0,$0C,$C7,$08,$C7,$00,$18,$91
                                  .db $08,$C7,$C7,$91,$18,$92,$08,$C7
                                  .db $C7,$92,$18,$93,$08,$C7,$C7,$93
                                  .db $18,$95,$08,$C7,$C7,$95,$DA,$04
                                  .db $DB,$0A,$DE,$22,$19,$38,$18,$5D
                                  .db $C0,$08,$C7,$C7,$C0,$E3,$78,$18
                                  .db $18,$C0,$08,$C7,$C7,$C3,$18,$C3
                                  .db $08,$C7,$C7,$C3,$18,$C3,$C3,$00
                                  .db $DA,$04,$DB,$0A,$DE,$22,$19,$38
                                  .db $18,$5D,$C0,$08,$C7,$C7,$C0,$18
                                  .db $C0,$08,$C7,$C7,$C3,$18,$C3,$08
                                  .db $C7,$C7,$C3,$18,$C3,$C3,$00,$DA
                                  .db $04,$DB,$08,$DE,$20,$18,$36,$18
                                  .db $5D,$A4,$08,$C7,$C7,$A4,$18,$A4
                                  .db $08,$C7,$C7,$A7,$18,$A7,$08,$C7
                                  .db $C7,$A7,$18,$A7,$A7,$DA,$04,$DB
                                  .db $0C,$DE,$21,$1A,$37,$18,$5D,$B9
                                  .db $08,$C7,$C7,$B9,$18,$B9,$08,$C7
                                  .db $C7,$BB,$18,$BB,$08,$C7,$C7,$BB
                                  .db $18,$BB,$BB,$DA,$04,$DB,$0A,$DE
                                  .db $22,$18,$36,$18,$5D,$A9,$08,$C7
                                  .db $C7,$A9,$18,$A9,$08,$C7,$C7,$AB
                                  .db $18,$AB,$08,$C7,$C7,$AB,$18,$AB
                                  .db $AB,$DA,$04,$DB,$0F,$08,$5D,$C7
                                  .db $C7,$9A,$18,$9A,$08,$C7,$C7,$9A
                                  .db $18,$9A,$08,$C7,$C7,$9F,$18,$9F
                                  .db $08,$C7,$C7,$9F,$08,$7D,$C7,$C7
                                  .db $9F,$DA,$04,$DB,$0F,$08,$5C,$C7
                                  .db $C7,$8E,$18,$8E,$08,$C7,$C7,$8E
                                  .db $18,$8E,$08,$C7,$C7,$93,$18,$93
                                  .db $08,$C7,$C7,$93,$08,$7E,$C7,$C7
                                  .db $93,$DA,$08,$DB,$0A,$DE,$22,$19
                                  .db $38,$08,$5F,$C7,$C7,$8E,$18,$8E
                                  .db $08,$C7,$C7,$8E,$18,$8E,$08,$C7
                                  .db $C7,$93,$18,$93,$08,$C7,$C7,$C7
                                  .db $08,$7F,$C7,$C7,$93,$DA,$00,$DB
                                  .db $0A,$08,$6C,$C7,$C7,$D0,$18,$D0
                                  .db $08,$C7,$C7,$D0,$18,$D0,$08,$C7
                                  .db $C7,$D0,$18,$D0,$C7,$08,$D0,$DB
                                  .db $14,$08,$D1,$D1,$DA,$04,$DE,$14
                                  .db $19,$30,$DB,$0A,$08,$4F,$B9,$C6
                                  .db $B7,$B9,$C6,$24,$B7,$0C,$C6,$08
                                  .db $B9,$BB,$C6,$C7,$BB,$C6,$24,$B9
                                  .db $0C,$C6,$08,$C6,$B9,$C6,$B7,$B9
                                  .db $C6,$24,$B7,$0C,$C6,$08,$B8,$B9
                                  .db $C6,$C7,$B9,$C6,$24,$B7,$0C,$C6
                                  .db $08,$B8,$DE,$16,$18,$30,$DB,$0A
                                  .db $08,$4E,$AD,$C6,$AB,$AD,$C6,$24
                                  .db $AB,$0C,$C6,$08,$AD,$AF,$C6,$C7
                                  .db $AF,$C6,$24,$AD,$0C,$C6,$08,$C6
                                  .db $AD,$C6,$AB,$AD,$C6,$24,$AB,$0C
                                  .db $C7,$08,$AC,$AD,$C6,$C7,$AD,$C6
                                  .db $24,$AB,$0C,$C6,$08,$AC,$00,$DE
                                  .db $15,$19,$31,$DB,$08,$08,$4E,$A8
                                  .db $C6,$A4,$A8,$C6,$24,$A8,$0C,$C6
                                  .db $08,$A8,$AB,$C6,$C7,$AB,$C6,$24
                                  .db $A7,$0C,$C6,$08,$C6,$A6,$C6,$A6
                                  .db $A6,$C6,$24,$A6,$0C,$C6,$08,$A6
                                  .db $A8,$C6,$C7,$A8,$C6,$24,$A8,$0C
                                  .db $C6,$08,$A8,$DA,$06,$DB,$0C,$DE
                                  .db $14,$1A,$30,$08,$4E,$A4,$C6,$A4
                                  .db $A4,$C6,$24,$A4,$0C,$C6,$08,$A4
                                  .db $A7,$C6,$C7,$A7,$C6,$24,$A3,$0C
                                  .db $C6,$08,$C6,$A2,$C6,$A2,$A2,$C6
                                  .db $24,$A2,$0C,$C6,$08,$A2,$A5,$C6
                                  .db $C7,$A5,$C6,$24,$A5,$0C,$C6,$08
                                  .db $A5,$08,$B9,$C6,$BB,$BC,$C6,$24
                                  .db $B9,$0C,$C6,$08,$B8,$B7,$C6,$B8
                                  .db $B9,$C6,$24,$C0,$0C,$C6,$08,$C6
                                  .db $00,$08,$A9,$C6,$A9,$AD,$C6,$24
                                  .db $AA,$0C,$C6,$08,$A9,$A8,$C6,$A8
                                  .db $A8,$C6,$24,$AB,$0C,$C6,$08,$C6
                                  .db $08,$AD,$C6,$AF,$B0,$C6,$24,$AD
                                  .db $0C,$C6,$08,$AC,$AB,$C6,$AC,$AD
                                  .db $C6,$24,$B4,$0C,$C6,$08,$C6,$00
                                  .db $DA,$04,$DB,$0C,$DE,$22,$18,$14
                                  .db $08,$5C,$A4,$C6,$A4,$A9,$C6,$24
                                  .db $A4,$0C,$C6,$08,$A4,$A4,$C6,$A4
                                  .db $A4,$C6,$24,$A5,$0C,$C6,$08,$C6
                                  .db $DA,$04,$DB,$0A,$DE,$22,$19,$38
                                  .db $60,$5E,$BC,$C6,$DA,$01,$10,$9F
                                  .db $C6,$C6,$C6,$AF,$C6,$60,$C6,$C6
                                  .db $00,$DA,$04,$DB,$08,$DE,$20,$18
                                  .db $36,$60,$5D,$B4,$C6,$DA,$01,$10
                                  .db $C7,$A3,$C6,$C6,$C6,$B3,$60,$C6
                                  .db $C6,$DA,$04,$DB,$0C,$DE,$21,$1A
                                  .db $37,$60,$5D,$AB,$C6,$DA,$01,$10
                                  .db $C7,$C7,$A7,$C6,$C6,$C6,$60,$B7
                                  .db $C6,$DA,$04,$DB,$0A,$DE,$22,$18
                                  .db $36,$60,$5D,$A4,$C6,$DA,$01,$10
                                  .db $C7,$C7,$C7,$AB,$C6,$C6,$60,$C6
                                  .db $C6,$DA,$04,$DB,$0F,$10,$5D,$A4
                                  .db $C7,$A4,$A2,$C7,$A2,$A1,$C7,$A1
                                  .db $A0,$C7,$A0,$60,$9F,$9B,$C6,$DA
                                  .db $0D,$DB,$0F,$10,$5D,$9C,$C7,$9C
                                  .db $9C,$C7,$9C,$98,$C7,$98,$98,$C7
                                  .db $98,$60,$97,$97,$C6,$DA,$08,$DB
                                  .db $0A,$DE,$22,$19,$38,$10,$5D,$98
                                  .db $C7,$98,$96,$C7,$96,$95,$C7,$95
                                  .db $94,$C7,$94,$60,$93,$93,$C6,$00
                                  .db $00,$00,$05,$E8,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00

DATA_03FDE0:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF