DATA_028000:                      .db $80,$40,$20,$10,$08,$04,$02,$01

CODE_028008:        DA            PHX                       
CODE_028009:        AD C2 0D      LDA.W $0DC2               
CODE_02800C:        F0 62         BEQ CODE_028070           
CODE_02800E:        9C C2 0D      STZ.W $0DC2               
CODE_028011:        48            PHA                       
CODE_028012:        A9 0C         LDA.B #$0C                ; \ Play sound effect 
CODE_028014:        8D FC 1D      STA.W $1DFC               ; / 
CODE_028017:        A2 0B         LDX.B #$0B                
CODE_028019:        BD C8 14      LDA.W $14C8,X             
CODE_02801C:        F0 24         BEQ CODE_028042           
CODE_02801E:        CA            DEX                       
CODE_02801F:        10 F8         BPL CODE_028019           
ADDR_028021:        CE 61 18      DEC.W $1861               
ADDR_028024:        10 05         BPL ADDR_02802B           
ADDR_028026:        A9 01         LDA.B #$01                
ADDR_028028:        8D 61 18      STA.W $1861               
ADDR_02802B:        AD 61 18      LDA.W $1861               
ADDR_02802E:        18            CLC                       
ADDR_02802F:        69 0A         ADC.B #$0A                
ADDR_028031:        AA            TAX                       
ADDR_028032:        B5 9E         LDA RAM_SpriteNum,X       
ADDR_028034:        C9 7D         CMP.B #$7D                
ADDR_028036:        D0 0A         BNE CODE_028042           
ADDR_028038:        BD C8 14      LDA.W $14C8,X             
ADDR_02803B:        C9 0B         CMP.B #$0B                
ADDR_02803D:        D0 03         BNE CODE_028042           
ADDR_02803F:        9C F3 13      STZ.W $13F3               
CODE_028042:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_028044:        9D C8 14      STA.W $14C8,X             ; / 
CODE_028047:        68            PLA                       
CODE_028048:        18            CLC                       
CODE_028049:        69 73         ADC.B #$73                
CODE_02804B:        95 9E         STA RAM_SpriteNum,X       
CODE_02804D:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_028051:        A9 78         LDA.B #$78                
CODE_028053:        18            CLC                       
CODE_028054:        65 1A         ADC RAM_ScreenBndryXLo    
CODE_028056:        95 E4         STA RAM_SpriteXLo,X       
CODE_028058:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02805A:        69 00         ADC.B #$00                
CODE_02805C:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02805F:        A9 20         LDA.B #$20                
CODE_028061:        18            CLC                       
CODE_028062:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_028064:        95 D8         STA RAM_SpriteYLo,X       
CODE_028066:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_028068:        69 00         ADC.B #$00                
CODE_02806A:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02806D:        FE 34 15      INC.W $1534,X             
CODE_028070:        FA            PLX                       
Return028071:       6B            RTL                       ; Return 


BombExplosionX:                   .db $00,$08,$06,$FA,$F8,$06,$08,$00
                                  .db $F8,$FA

BombExplosionY:                   .db $F8,$FE,$06,$06,$FE,$FA,$02,$08
                                  .db $02,$FA

ExplodeBombRt:      20 8A 80      JSR.W ExplodeBombSubRt   	;BOMB 
Return028089:       6B            RTL                       ; Return 

ExplodeBombSubRt:   9E 56 16      STZ.W RAM_Tweaker1656,X   ; Make sprite unstompable 
CODE_02808D:        A9 11         LDA.B #$11                ; \ Set new clipping area for explosion 
CODE_02808F:        9D 62 16      STA.W RAM_Tweaker1662,X   ; / 
CODE_028092:        20 78 D3      JSR.W GetDrawInfo2        
CODE_028095:        A5 9D         LDA RAM_SpritesLocked     ; \ Increase frame count if sprites not locked 
CODE_028097:        D0 03         BNE CODE_02809C           ;  | 
CODE_028099:        FE 70 15      INC.W $1570,X             ; / 
CODE_02809C:        BD 40 15      LDA.W $1540,X             ; \ When timer is up free up sprite slot 
CODE_02809F:        D0 04         BNE ExplodeBombGfx        ;  | 
CODE_0280A1:        9E C8 14      STZ.W $14C8,X             ; / 
Return0280A4:       60            RTS                       ; Return 

ExplodeBombGfx:     BD 40 15      LDA.W $1540,X             
CODE_0280A8:        4A            LSR                       
CODE_0280A9:        29 03         AND.B #$03                
CODE_0280AB:        C9 03         CMP.B #$03                
CODE_0280AD:        D0 11         BNE CODE_0280C0           
CODE_0280AF:        20 39 81      JSR.W ExplodeSprites      
CODE_0280B2:        BD 40 15      LDA.W $1540,X             
CODE_0280B5:        38            SEC                       
CODE_0280B6:        E9 10         SBC.B #$10                
CODE_0280B8:        C9 20         CMP.B #$20                
CODE_0280BA:        B0 04         BCS CODE_0280C0           
CODE_0280BC:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_0280C0:        A0 04         LDY.B #$04                
CODE_0280C2:        84 0F         STY $0F                   
CODE_0280C4:        BD 40 15      LDA.W $1540,X             
CODE_0280C7:        4A            LSR                       
CODE_0280C8:        48            PHA                       
CODE_0280C9:        29 03         AND.B #$03                
CODE_0280CB:        85 02         STA $02                   
CODE_0280CD:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_0280CF:        38            SEC                       
CODE_0280D0:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_0280D2:        18            CLC                       
CODE_0280D3:        69 04         ADC.B #$04                
CODE_0280D5:        85 00         STA $00                   
CODE_0280D7:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_0280D9:        38            SEC                       
CODE_0280DA:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_0280DC:        18            CLC                       
CODE_0280DD:        69 04         ADC.B #$04                
CODE_0280DF:        85 01         STA $01                   
CODE_0280E1:        A4 0F         LDY $0F                   
CODE_0280E3:        68            PLA                       
CODE_0280E4:        29 04         AND.B #$04                
CODE_0280E6:        F0 05         BEQ CODE_0280ED           
CODE_0280E8:        98            TYA                       
CODE_0280E9:        18            CLC                       
CODE_0280EA:        69 05         ADC.B #$05                
CODE_0280EC:        A8            TAY                       
CODE_0280ED:        A5 00         LDA $00                   
CODE_0280EF:        18            CLC                       
CODE_0280F0:        79 72 80      ADC.W BombExplosionX,Y    
CODE_0280F3:        85 00         STA $00                   
CODE_0280F5:        A5 01         LDA $01                   
CODE_0280F7:        18            CLC                       
CODE_0280F8:        79 7C 80      ADC.W BombExplosionY,Y    
CODE_0280FB:        85 01         STA $01                   
CODE_0280FD:        C6 02         DEC $02                   
CODE_0280FF:        10 EC         BPL CODE_0280ED           
CODE_028101:        A5 0F         LDA $0F                   
CODE_028103:        0A            ASL                       
CODE_028104:        0A            ASL                       
CODE_028105:        7D EA 15      ADC.W RAM_SprOAMIndex,X   
CODE_028108:        A8            TAY                       
CODE_028109:        A5 00         LDA $00                   
CODE_02810B:        99 00 03      STA.W OAM_DispX,Y         
CODE_02810E:        A5 01         LDA $01                   
CODE_028110:        99 01 03      STA.W OAM_DispY,Y         
CODE_028113:        A9 BC         LDA.B #$BC                
CODE_028115:        99 02 03      STA.W OAM_Tile,Y          
CODE_028118:        A5 13         LDA RAM_FrameCounter      
CODE_02811A:        4A            LSR                       
CODE_02811B:        4A            LSR                       
CODE_02811C:        29 03         AND.B #$03                
CODE_02811E:        38            SEC                       
CODE_02811F:        2A            ROL                       
CODE_028120:        05 64         ORA $64                   
CODE_028122:        99 03 03      STA.W OAM_Prop,Y          
CODE_028125:        98            TYA                       
CODE_028126:        4A            LSR                       
CODE_028127:        4A            LSR                       
CODE_028128:        A8            TAY                       
CODE_028129:        A9 00         LDA.B #$00                
CODE_02812B:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02812E:        C6 0F         DEC $0F                   
CODE_028130:        10 92         BPL CODE_0280C4           
CODE_028132:        A0 00         LDY.B #$00                
CODE_028134:        A9 04         LDA.B #$04                
CODE_028136:        4C A7 B7      JMP.W CODE_02B7A7         

ExplodeSprites:     A0 09         LDY.B #$09                ; \ Loop over sprites: 
ExplodeLoopStart:   CC E9 15      CPY.W $15E9               ;  | Don't attempt to kill self 
CODE_02813E:        F0 0C         BEQ CODE_02814C           ;  | 
CODE_028140:        5A            PHY                       ;  | 
CODE_028141:        B9 C8 14      LDA.W $14C8,Y             ;  | Skip sprite if it's already dying/dead 
CODE_028144:        C9 08         CMP.B #$08                ;  | 
CODE_028146:        90 03         BCC CODE_02814B           ;  | 
CODE_028148:        20 50 81      JSR.W ExplodeKillSpr      ;  | Check for contact 
CODE_02814B:        7A            PLY                       ;  | 
CODE_02814C:        88            DEY                       ;  | Next 
CODE_02814D:        10 EC         BPL ExplodeLoopStart      ; / 
Return02814F:       60            RTS                       ; Return 

ExplodeKillSpr:     DA            PHX                       
CODE_028151:        BB            TYX                       ; \ Return if no sprite contact 
CODE_028152:        22 E5 B6 03   JSL.L GetSpriteClippingB  ;  | 
CODE_028156:        FA            PLX                       ;  | 
CODE_028157:        22 9F B6 03   JSL.L GetSpriteClippingA  ;  | 
CODE_02815B:        22 2B B7 03   JSL.L CheckForContact     ;  | 
CODE_02815F:        90 16         BCC Return028177          ; / 
CODE_028161:        B9 7A 16      LDA.W RAM_Tweaker167A,Y   ; \ Return if sprite is invincible 
CODE_028164:        29 02         AND.B #$02                ;  | to explosions 
CODE_028166:        D0 0F         BNE Return028177          ; / 
CODE_028168:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_02816A:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02816D:        A9 C0         LDA.B #$C0                ; \ Sprite Y speed = #$C0 
CODE_02816F:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  ; / 
CODE_028172:        A9 00         LDA.B #$00                ; \ Sprite X speed = #$00 
CODE_028174:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  ; / 
Return028177:       60            RTS                       ; Return 


DATA_028178:                      .db $F8,$38,$78,$B8,$00,$10,$20,$D0
                                  .db $E0,$10,$40,$80,$C0,$10,$10,$20
                                  .db $B0,$20,$50,$60,$C0,$F0,$80,$B0
                                  .db $20,$60,$A0,$E0,$70,$F0,$70,$B0
                                  .db $F0,$10,$20,$50,$60,$90,$A0,$D0
                                  .db $E0,$10,$20,$50,$60,$90,$A0,$D0
                                  .db $E0,$10,$20,$50,$60,$90,$A0,$D0
                                  .db $E0,$50,$60,$C0,$D0,$30,$40,$70
                                  .db $80,$B0,$C0,$30,$40,$70,$80,$B0
                                  .db $C0,$40,$50,$80,$90,$C8,$D8,$30
                                  .db $40,$A0,$B0,$58,$68,$B0,$C0

DATA_0281CF:                      .db $70,$70,$70,$70,$20,$20,$20,$20
                                  .db $20,$30,$30,$30,$30,$70,$80,$80
                                  .db $80,$90,$90,$90,$A0,$50,$60,$60
                                  .db $70,$70,$70,$70,$60,$60,$70,$70
                                  .db $70,$40,$40,$40,$40,$40,$40,$40
                                  .db $40,$50,$50,$50,$50,$50,$50,$50
                                  .db $50,$60,$60,$60,$60,$60,$60,$60
                                  .db $60,$30,$30,$30,$30,$48,$48,$48
                                  .db $48,$48,$48,$58,$58,$58,$58,$58
                                  .db $58,$70,$70,$78,$78,$70,$70,$80
                                  .db $80,$88,$88,$A0,$A0,$A0,$A0

DATA_028226:                      .db $E8,$E8,$E8,$E8,$E4,$E4,$E4,$E4
                                  .db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4
                                  .db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4
                                  .db $E4,$E4,$E4,$E4,$EE,$EE,$EE,$EE
                                  .db $EE,$C0,$C2,$C0,$C2,$C0,$C2,$C0
                                  .db $C2,$E0,$E2,$E0,$E2,$E0,$E2,$E0
                                  .db $E2,$C4,$A4,$C4,$A4,$C4,$A4,$C4
                                  .db $A4,$CC,$CE,$CC,$CE,$C8,$CA,$C8
                                  .db $CA,$C8,$CA,$CA,$C8,$CA,$C8,$CA
                                  .db $C8,$CC,$CE,$CC,$CE,$CC,$CE,$CC
                                  .db $CE,$CC,$CE,$CC,$CE,$CC,$CE

CODE_02827D:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_02827F:        8D 8D 18      STA.W $188D               
CODE_028282:        49 FF         EOR.B #$FF                
CODE_028284:        1A            INC A                     
CODE_028285:        85 05         STA $05                   
CODE_028287:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_028289:        4A            LSR                       
CODE_02828A:        6E 8D 18      ROR.W $188D               
CODE_02828D:        48            PHA                       
CODE_02828E:        AD 8D 18      LDA.W $188D               
CODE_028291:        49 FF         EOR.B #$FF                
CODE_028293:        1A            INC A                     
CODE_028294:        85 06         STA $06                   
CODE_028296:        68            PLA                       
CODE_028297:        4A            LSR                       
CODE_028298:        6E 8D 18      ROR.W $188D               
CODE_02829B:        AD 8D 18      LDA.W $188D               
CODE_02829E:        49 FF         EOR.B #$FF                
CODE_0282A0:        1A            INC A                     
CODE_0282A1:        8D 8D 18      STA.W $188D               
CODE_0282A4:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_0282A6:        A0 64 01      LDY.W #$0164              
CODE_0282A9:        A9 66         LDA.B #$66                
CODE_0282AB:        84 03         STY $03                   
CODE_0282AD:        A9 F0         LDA.B #$F0                
CODE_0282AF:        99 0D 02      STA.W $020D,Y             
CODE_0282B2:        C8            INY                       
CODE_0282B3:        C8            INY                       
CODE_0282B4:        C8            INY                       
CODE_0282B5:        C8            INY                       
CODE_0282B6:        C0 8C 01      CPY.W #$018C              
CODE_0282B9:        90 F4         BCC CODE_0282AF           
CODE_0282BB:        A2 00 00      LDX.W #$0000              
CODE_0282BE:        86 0C         STX $0C                   
CODE_0282C0:        A2 38 00      LDX.W #$0038              
CODE_0282C3:        A0 E0 00      LDY.W #$00E0              
CODE_0282C6:        AD 84 18      LDA.W $1884               
CODE_0282C9:        C9 01         CMP.B #$01                
CODE_0282CB:        D0 0B         BNE CODE_0282D8           
CODE_0282CD:        A2 39 00      LDX.W #$0039              
CODE_0282D0:        86 0C         STX $0C                   
CODE_0282D2:        A2 1D 00      LDX.W #$001D              
CODE_0282D5:        A0 FC 00      LDY.W #$00FC              
CODE_0282D8:        86 00         STX $00                   
CODE_0282DA:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0282DC:        8A            TXA                       
CODE_0282DD:        18            CLC                       
CODE_0282DE:        65 0C         ADC $0C                   
CODE_0282E0:        85 0A         STA $0A                   
CODE_0282E2:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0282E4:        A5 06         LDA $06                   
CODE_0282E6:        18            CLC                       
CODE_0282E7:        A6 0A         LDX $0A                   
CODE_0282E9:        7F 78 81 02   ADC.L DATA_028178,X       
CODE_0282ED:        99 0C 02      STA.W $020C,Y             
CODE_0282F0:        85 02         STA $02                   
CODE_0282F2:        AD 88 18      LDA.W RAM_Layer1DispYLo   
CODE_0282F5:        85 07         STA $07                   
CODE_0282F7:        0A            ASL                       
CODE_0282F8:        66 07         ROR $07                   
CODE_0282FA:        BF CF 81 02   LDA.L DATA_0281CF,X       
CODE_0282FE:        3A            DEC A                     
CODE_0282FF:        38            SEC                       
CODE_028300:        E5 07         SBC $07                   
CODE_028302:        99 0D 02      STA.W $020D,Y             
CODE_028305:        A6 0A         LDX $0A                   
CODE_028307:        AD 8C 18      LDA.W $188C               
CODE_02830A:        D0 0C         BNE CODE_028318           
CODE_02830C:        BF 26 82 02   LDA.L DATA_028226,X       
CODE_028310:        99 0E 02      STA.W $020E,Y             
CODE_028313:        A9 0D         LDA.B #$0D                
CODE_028315:        99 0F 02      STA.W $020F,Y             
CODE_028318:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_02831A:        5A            PHY                       
CODE_02831B:        98            TYA                       
CODE_02831C:        4A            LSR                       
CODE_02831D:        4A            LSR                       
CODE_02831E:        A8            TAY                       
CODE_02831F:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_028321:        A9 02         LDA.B #$02                
CODE_028323:        99 23 04      STA.W $0423,Y             
CODE_028326:        A5 02         LDA $02                   
CODE_028328:        C9 F0         CMP.B #$F0                
CODE_02832A:        90 3B         BCC CODE_028367           
CODE_02832C:        AD 84 18      LDA.W $1884               
CODE_02832F:        C9 01         CMP.B #$01                
CODE_028331:        F0 34         BEQ CODE_028367           
CODE_028333:        7A            PLY                       
CODE_028334:        5A            PHY                       
CODE_028335:        A6 03         LDX $03                   
CODE_028337:        B9 0C 02      LDA.W $020C,Y             
CODE_02833A:        9D 0C 02      STA.W $020C,X             
CODE_02833D:        B9 0D 02      LDA.W $020D,Y             
CODE_028340:        9D 0D 02      STA.W $020D,X             
CODE_028343:        B9 0E 02      LDA.W $020E,Y             
CODE_028346:        9D 0E 02      STA.W $020E,X             
CODE_028349:        B9 0F 02      LDA.W $020F,Y             
CODE_02834C:        9D 0F 02      STA.W $020F,X             
CODE_02834F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_028351:        8A            TXA                       
CODE_028352:        4A            LSR                       
CODE_028353:        4A            LSR                       
CODE_028354:        A8            TAY                       
CODE_028355:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_028357:        A9 03         LDA.B #$03                
CODE_028359:        99 23 04      STA.W $0423,Y             
CODE_02835C:        A5 03         LDA $03                   
CODE_02835E:        18            CLC                       
CODE_02835F:        69 04         ADC.B #$04                
CODE_028361:        85 03         STA $03                   
CODE_028363:        90 02         BCC CODE_028367           
ADDR_028365:        E6 04         INC $04                   
CODE_028367:        7A            PLY                       
CODE_028368:        A6 00         LDX $00                   
CODE_02836A:        88            DEY                       
CODE_02836B:        88            DEY                       
CODE_02836C:        88            DEY                       
CODE_02836D:        88            DEY                       
CODE_02836E:        CA            DEX                       
CODE_02836F:        30 03         BMI CODE_028374           
CODE_028371:        4C D8 82      JMP.W CODE_0282D8         

CODE_028374:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_028376:        A9 01         LDA.B #$01                
CODE_028378:        8D 8C 18      STA.W $188C               
CODE_02837B:        AD 84 18      LDA.W $1884               
CODE_02837E:        C9 01         CMP.B #$01                
CODE_028380:        D0 16         BNE CODE_028398           
CODE_028382:        A9 CD         LDA.B #$CD                
CODE_028384:        8D BF 02      STA.W $02BF               
CODE_028387:        8D C3 02      STA.W $02C3               
CODE_02838A:        8D C7 02      STA.W $02C7               
CODE_02838D:        8D CB 02      STA.W $02CB               
CODE_028390:        8D CF 02      STA.W $02CF               
CODE_028393:        8D D3 02      STA.W $02D3               
CODE_028396:        80 2C         BRA CODE_0283C4           

CODE_028398:        A5 14         LDA RAM_FrameCounterB     
CODE_02839A:        29 03         AND.B #$03                
CODE_02839C:        D0 26         BNE CODE_0283C4           
CODE_02839E:        64 00         STZ $00                   
CODE_0283A0:        A6 00         LDX $00                   
CODE_0283A2:        BF C8 83 02   LDA.L DATA_0283C8,X       
CODE_0283A6:        A8            TAY                       
CODE_0283A7:        22 F9 AC 01   JSL.L GetRand             
CODE_0283AB:        29 01         AND.B #$01                
CODE_0283AD:        D0 08         BNE CODE_0283B7           
CODE_0283AF:        B9 0E 02      LDA.W $020E,Y             
CODE_0283B2:        49 02         EOR.B #$02                
CODE_0283B4:        99 0E 02      STA.W $020E,Y             
CODE_0283B7:        A9 09         LDA.B #$09                
CODE_0283B9:        99 0F 02      STA.W $020F,Y             
CODE_0283BC:        E6 00         INC $00                   
CODE_0283BE:        A5 00         LDA $00                   
CODE_0283C0:        C9 04         CMP.B #$04                
CODE_0283C2:        D0 DC         BNE CODE_0283A0           
CODE_0283C4:        20 CE 83      JSR.W CODE_0283CE         
Return0283C7:       6B            RTL                       ; Return 


DATA_0283C8:                      .db $00,$04,$08,$0C

DATA_0283CC:                      .db $0C,$30

CODE_0283CE:        AD 3D 15      LDA.W $153D               
CODE_0283D1:        38            SEC                       
CODE_0283D2:        E9 1E         SBC.B #$1E                
CODE_0283D4:        85 0C         STA $0C                   
CODE_0283D6:        AD 17 16      LDA.W $1617               
CODE_0283D9:        18            CLC                       
CODE_0283DA:        69 10         ADC.B #$10                
CODE_0283DC:        85 0D         STA $0D                   
CODE_0283DE:        A2 01         LDX.B #$01                
CODE_0283E0:        86 0F         STX $0F                   
CODE_0283E2:        BD A8 18      LDA.W $18A8,X             
CODE_0283E5:        F0 0D         BEQ CODE_0283F4           
CODE_0283E7:        30 08         BMI CODE_0283F1           
CODE_0283E9:        8D FB 13      STA.W $13FB               
CODE_0283EC:        85 9D         STA RAM_SpritesLocked     
CODE_0283EE:        20 F8 83      JSR.W CODE_0283F8         
CODE_0283F1:        20 39 84      JSR.W CODE_028439         
CODE_0283F4:        CA            DEX                       
CODE_0283F5:        10 E9         BPL CODE_0283E0           
Return0283F7:       60            RTS                       ; Return 

CODE_0283F8:        BD AA 18      LDA.W $18AA,X             
CODE_0283FB:        4A            LSR                       
CODE_0283FC:        4A            LSR                       
CODE_0283FD:        4A            LSR                       
CODE_0283FE:        4A            LSR                       
CODE_0283FF:        4A            LSR                       
CODE_028400:        38            SEC                       
CODE_028401:        7D AA 18      ADC.W $18AA,X             
CODE_028404:        C9 B0         CMP.B #$B0                
CODE_028406:        90 2D         BCC CODE_028435           
CODE_028408:        1E A8 18      ASL.W $18A8,X             
CODE_02840B:        38            SEC                       
CODE_02840C:        7E A8 18      ROR.W $18A8,X             
CODE_02840F:        A9 30         LDA.B #$30                ; \ Set ground shake timer 
CODE_028411:        8D 87 18      STA.W RAM_ShakeGrndTimer  ; / 
CODE_028414:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_028416:        8D FC 1D      STA.W $1DFC               ; / 
CODE_028419:        E0 00         CPX.B #$00                
CODE_02841B:        D0 0D         BNE CODE_02842A           
CODE_02841D:        AD A9 18      LDA.W $18A9               
CODE_028420:        D0 08         BNE CODE_02842A           
CODE_028422:        EE A9 18      INC.W $18A9               
CODE_028425:        9C AB 18      STZ.W $18AB               
CODE_028428:        80 09         BRA CODE_028433           

CODE_02842A:        E0 01         CPX.B #$01                
CODE_02842C:        D0 05         BNE CODE_028433           
CODE_02842E:        64 9D         STZ RAM_SpritesLocked     
CODE_028430:        9C FB 13      STZ.W $13FB               
CODE_028433:        A9 B0         LDA.B #$B0                
CODE_028435:        9D AA 18      STA.W $18AA,X             
Return028438:       60            RTS                       ; Return 

CODE_028439:        BF CC 83 02   LDA.L DATA_0283CC,X       
CODE_02843D:        A8            TAY                       
CODE_02843E:        64 00         STZ $00                   
CODE_028440:        A9 F0         LDA.B #$F0                
CODE_028442:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_028445:        BD AA 18      LDA.W $18AA,X             
CODE_028448:        38            SEC                       
CODE_028449:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02844B:        38            SEC                       
CODE_02844C:        ED 88 18      SBC.W RAM_Layer1DispYLo   
CODE_02844F:        38            SEC                       
CODE_028450:        E5 00         SBC $00                   
CODE_028452:        C9 20         CMP.B #$20                
CODE_028454:        90 36         BCC Return02848C          
CODE_028456:        C9 A4         CMP.B #$A4                
CODE_028458:        B0 03         BCS CODE_02845D           
CODE_02845A:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_02845D:        B5 0C         LDA $0C,X                 
CODE_02845F:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_028462:        A9 E6         LDA.B #$E6                
CODE_028464:        A6 00         LDX $00                   
CODE_028466:        F0 02         BEQ CODE_02846A           
CODE_028468:        A9 08         LDA.B #$08                
CODE_02846A:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02846D:        A9 0D         LDA.B #$0D                
CODE_02846F:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_028472:        98            TYA                       
CODE_028473:        4A            LSR                       
CODE_028474:        4A            LSR                       
CODE_028475:        AA            TAX                       
CODE_028476:        A9 02         LDA.B #$02                
CODE_028478:        9D 20 04      STA.W $0420,X             
CODE_02847B:        A6 0F         LDX $0F                   
CODE_02847D:        C8            INY                       
CODE_02847E:        C8            INY                       
CODE_02847F:        C8            INY                       
CODE_028480:        C8            INY                       
CODE_028481:        A5 00         LDA $00                   
CODE_028483:        18            CLC                       
CODE_028484:        69 10         ADC.B #$10                
CODE_028486:        85 00         STA $00                   
CODE_028488:        C9 90         CMP.B #$90                
CODE_02848A:        90 B4         BCC CODE_028440           
Return02848C:       60            RTS                       ; Return 

SubHorzPosBnk2:     A0 00         LDY.B #$00                
CODE_02848F:        A5 94         LDA RAM_MarioXPos         
CODE_028491:        38            SEC                       
CODE_028492:        F5 E4         SBC RAM_SpriteXLo,X       
CODE_028494:        85 0F         STA $0F                   
CODE_028496:        A5 95         LDA RAM_MarioXPosHi       
CODE_028498:        FD E0 14      SBC.W RAM_SpriteXHi,X     
CODE_02849B:        10 01         BPL Return02849E          
CODE_02849D:        C8            INY                       
Return02849E:       60            RTS                       ; Return 

IsOffScreenBnk2:    BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_0284A2:        1D 6C 18      ORA.W RAM_OffscreenVert,X 
Return0284A5:       60            RTS                       ; Return 

CODE_0284A6:        85 03         STA $03                   
CODE_0284A8:        A9 02         LDA.B #$02                
CODE_0284AA:        85 01         STA $01                   
CODE_0284AC:        22 D8 84 02   JSL.L CODE_0284D8         
CODE_0284B0:        A5 02         LDA $02                   
CODE_0284B2:        18            CLC                       
CODE_0284B3:        65 03         ADC $03                   
CODE_0284B5:        85 02         STA $02                   
CODE_0284B7:        C6 01         DEC $01                   
CODE_0284B9:        10 F1         BPL CODE_0284AC           
Return0284BB:       6B            RTL                       ; Return 

CODE_0284BC:        A9 12         LDA.B #$12                
CODE_0284BE:        80 02         BRA CODE_0284C2           

CODE_0284C0:        A9 00         LDA.B #$00                
CODE_0284C2:        85 00         STA $00                   
CODE_0284C4:        64 02         STZ $02                   
CODE_0284C6:        B5 9E         LDA RAM_SpriteNum,X       
CODE_0284C8:        C9 41         CMP.B #$41                
CODE_0284CA:        F0 04         BEQ CODE_0284D0           
CODE_0284CC:        C9 42         CMP.B #$42                
CODE_0284CE:        D0 08         BNE CODE_0284D8           
CODE_0284D0:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_0284D2:        10 13         BPL Return0284E7          
CODE_0284D4:        A9 0A         LDA.B #$0A                
CODE_0284D6:        80 CE         BRA CODE_0284A6           

CODE_0284D8:        20 9F 84      JSR.W IsOffScreenBnk2     
CODE_0284DB:        D0 0A         BNE Return0284E7          
CODE_0284DD:        A0 0B         LDY.B #$0B                
CODE_0284DF:        B9 F0 17      LDA.W $17F0,Y             
CODE_0284E2:        F0 04         BEQ CODE_0284E8           
CODE_0284E4:        88            DEY                       
CODE_0284E5:        10 F8         BPL CODE_0284DF           
Return0284E7:       6B            RTL                       ; Return 

CODE_0284E8:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_0284EA:        18            CLC                       
CODE_0284EB:        69 00         ADC.B #$00                
CODE_0284ED:        29 F0         AND.B #$F0                
CODE_0284EF:        18            CLC                       
CODE_0284F0:        69 03         ADC.B #$03                
CODE_0284F2:        99 FC 17      STA.W $17FC,Y             
CODE_0284F5:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_0284F7:        18            CLC                       
CODE_0284F8:        65 02         ADC $02                   
CODE_0284FA:        99 08 18      STA.W $1808,Y             
CODE_0284FD:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_028500:        69 00         ADC.B #$00                
CODE_028502:        99 EA 18      STA.W $18EA,Y             
CODE_028505:        A9 07         LDA.B #$07                
CODE_028507:        99 F0 17      STA.W $17F0,Y             
CODE_02850A:        A5 00         LDA $00                   
CODE_02850C:        99 50 18      STA.W $1850,Y             
Return02850F:       6B            RTL                       ; Return 


DATA_028510:                      .db $04,$FC,$06,$FA,$08,$F8,$0A,$F6
DATA_028518:                      .db $E0,$E1,$E2,$E3,$E4,$E6,$E8,$EA
DATA_028520:                      .db $1F,$13,$10,$1C,$17,$1A,$0F,$1E

CODE_028528:        20 9F 84      JSR.W IsOffScreenBnk2     
CODE_02852B:        BD 6C 18      LDA.W RAM_OffscreenVert,X 
CODE_02852E:        D0 B7         BNE Return0284E7          
CODE_028530:        A9 04         LDA.B #$04                
CODE_028532:        85 00         STA $00                   
CODE_028534:        A0 07         LDY.B #$07                ; \ Find a free extended sprite slot 
CODE_028536:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   ;  | 
CODE_028539:        F0 04         BEQ CODE_02853F           ;  | 
CODE_02853B:        88            DEY                       ;  | 
CODE_02853C:        10 F8         BPL CODE_028536           ;  | 
Return02853E:       6B            RTL                       ; / Return if no free slots 

CODE_02853F:        A9 07         LDA.B #$07                ; \ Extended sprite = Lava splash 
CODE_028541:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_028544:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_028546:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
CODE_028549:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02854C:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
CODE_02854F:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_028551:        18            CLC                       
CODE_028552:        69 04         ADC.B #$04                
CODE_028554:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
CODE_028557:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02855A:        69 00         ADC.B #$00                
CODE_02855C:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
CODE_02855F:        22 F9 AC 01   JSL.L GetRand             
CODE_028563:        DA            PHX                       
CODE_028564:        29 07         AND.B #$07                
CODE_028566:        AA            TAX                       
CODE_028567:        BF 10 85 02   LDA.L DATA_028510,X       
CODE_02856B:        99 47 17      STA.W RAM_ExSprSpeedX,Y   
CODE_02856E:        AD 8E 14      LDA.W RAM_RandomByte2     
CODE_028571:        29 07         AND.B #$07                
CODE_028573:        AA            TAX                       
CODE_028574:        BF 18 85 02   LDA.L DATA_028518,X       
CODE_028578:        99 3D 17      STA.W RAM_ExSprSpeedY,Y   
CODE_02857B:        22 F9 AC 01   JSL.L GetRand             
CODE_02857F:        29 07         AND.B #$07                
CODE_028581:        AA            TAX                       
CODE_028582:        BF 20 85 02   LDA.L DATA_028520,X       
CODE_028586:        99 6F 17      STA.W $176F,Y             
CODE_028589:        FA            PLX                       
CODE_02858A:        C6 00         DEC $00                   
CODE_02858C:        10 A8         BPL CODE_028536           
Return02858E:       6B            RTL                       ; Return 

CODE_02858F:        A0 1F         LDY.B #$1F                ; \ If Big Mario: 
CODE_028591:        A2 00         LDX.B #$00                ;  | Y = #$1F 
CODE_028593:        A5 19         LDA RAM_MarioPowerUp      ;  | X = #$00 
CODE_028595:        D0 04         BNE CODE_02859B           ;  | Small Mario: 
CODE_028597:        A0 0F         LDY.B #$0F                ;  | Y = #$0F 
CODE_028599:        A2 10         LDX.B #$10                ; / X = #$10 
CODE_02859B:        86 01         STX $01                   
CODE_02859D:        22 F9 AC 01   JSL.L GetRand             
CODE_0285A1:        98            TYA                       
CODE_0285A2:        2D 8D 14      AND.W RAM_RandomByte1     
CODE_0285A5:        18            CLC                       
CODE_0285A6:        65 01         ADC $01                   
CODE_0285A8:        18            CLC                       
CODE_0285A9:        65 96         ADC RAM_MarioYPos         
CODE_0285AB:        85 00         STA $00                   
CODE_0285AD:        AD 8E 14      LDA.W RAM_RandomByte2     
CODE_0285B0:        29 0F         AND.B #$0F                
CODE_0285B2:        18            CLC                       
CODE_0285B3:        69 FE         ADC.B #$FE                
CODE_0285B5:        18            CLC                       
CODE_0285B6:        65 94         ADC RAM_MarioXPos         
CODE_0285B8:        85 02         STA $02                   
CODE_0285BA:        A0 0B         LDY.B #$0B                
CODE_0285BC:        B9 F0 17      LDA.W $17F0,Y             
CODE_0285BF:        F0 04         BEQ CODE_0285C5           
CODE_0285C1:        88            DEY                       
CODE_0285C2:        10 F8         BPL CODE_0285BC           
Return0285C4:       6B            RTL                       ; Return 

CODE_0285C5:        A9 05         LDA.B #$05                
CODE_0285C7:        99 F0 17      STA.W $17F0,Y             
CODE_0285CA:        A9 00         LDA.B #$00                
CODE_0285CC:        99 20 18      STA.W $1820,Y             
CODE_0285CF:        A5 00         LDA $00                   
CODE_0285D1:        99 FC 17      STA.W $17FC,Y             
CODE_0285D4:        A5 02         LDA $02                   
CODE_0285D6:        99 08 18      STA.W $1808,Y             
CODE_0285D9:        A9 17         LDA.B #$17                
CODE_0285DB:        99 50 18      STA.W $1850,Y             
Return0285DE:       6B            RTL                       ; Return 

CODE_0285DF:        20 9F 84      JSR.W IsOffScreenBnk2     
CODE_0285E2:        D0 0A         BNE Return0285EE          
CODE_0285E4:        A0 0B         LDY.B #$0B                
CODE_0285E6:        B9 F0 17      LDA.W $17F0,Y             
CODE_0285E9:        F0 04         BEQ CODE_0285EF           
CODE_0285EB:        88            DEY                       
CODE_0285EC:        10 F8         BPL CODE_0285E6           
Return0285EE:       6B            RTL                       ; Return 

CODE_0285EF:        22 F9 AC 01   JSL.L GetRand             
CODE_0285F3:        A9 04         LDA.B #$04                
CODE_0285F5:        99 F0 17      STA.W $17F0,Y             
CODE_0285F8:        A9 00         LDA.B #$00                
CODE_0285FA:        99 20 18      STA.W $1820,Y             
CODE_0285FD:        AD 8D 14      LDA.W RAM_RandomByte1     
CODE_028600:        29 0F         AND.B #$0F                
CODE_028602:        38            SEC                       
CODE_028603:        E9 03         SBC.B #$03                
CODE_028605:        18            CLC                       
CODE_028606:        75 E4         ADC RAM_SpriteXLo,X       
CODE_028608:        99 08 18      STA.W $1808,Y             
CODE_02860B:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02860E:        69 00         ADC.B #$00                
CODE_028610:        99 EA 18      STA.W $18EA,Y             
CODE_028613:        AD 8E 14      LDA.W RAM_RandomByte2     
CODE_028616:        29 07         AND.B #$07                
CODE_028618:        18            CLC                       
CODE_028619:        69 07         ADC.B #$07                
CODE_02861B:        18            CLC                       
CODE_02861C:        75 D8         ADC RAM_SpriteYLo,X       
CODE_02861E:        99 FC 17      STA.W $17FC,Y             
CODE_028621:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_028624:        69 00         ADC.B #$00                
CODE_028626:        99 14 18      STA.W $1814,Y             
CODE_028629:        A9 17         LDA.B #$17                
CODE_02862B:        99 50 18      STA.W $1850,Y             
Return02862E:       6B            RTL                       ; Return 

CODE_02862F:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_028633:        30 2D         BMI Return028662          ; / 
CODE_028635:        BB            TYX                       
CODE_028636:        A9 0B         LDA.B #$0B                ; \ Sprite status = Being carried 
CODE_028638:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02863B:        A5 96         LDA RAM_MarioYPos         
CODE_02863D:        95 D8         STA RAM_SpriteYLo,X       
CODE_02863F:        A5 97         LDA RAM_MarioYPosHi       
CODE_028641:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_028644:        A5 94         LDA RAM_MarioXPos         
CODE_028646:        95 E4         STA RAM_SpriteXLo,X       
CODE_028648:        B5 95         LDA RAM_MarioXPosHi,X     
CODE_02864A:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02864D:        A9 53         LDA.B #$53                ; \ Sprite = Throw Block 
CODE_02864F:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_028651:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_028655:        A9 FF         LDA.B #$FF                
CODE_028657:        9D 40 15      STA.W $1540,X             
CODE_02865A:        A9 08         LDA.B #$08                
CODE_02865C:        8D 98 14      STA.W RAM_PickUpImgTimer  
CODE_02865F:        8D 8F 14      STA.W $148F               
Return028662:       6B            RTL                       ; Return 

ShatterBlock:       DA            PHX                       
CODE_028664:        85 00         STA $00                   
CODE_028666:        A0 03         LDY.B #$03                
CODE_028668:        A2 0B         LDX.B #$0B                
CODE_02866A:        BD F0 17      LDA.W $17F0,X             
CODE_02866D:        F0 10         BEQ CODE_02867F           
CODE_02866F:        CA            DEX                       
CODE_028670:        10 F8         BPL CODE_02866A           
CODE_028672:        CE 5D 18      DEC.W $185D               
CODE_028675:        10 05         BPL CODE_02867C           
CODE_028677:        A9 0B         LDA.B #$0B                
CODE_028679:        8D 5D 18      STA.W $185D               
CODE_02867C:        AE 5D 18      LDX.W $185D               
CODE_02867F:        A9 07         LDA.B #$07                ; \ 
CODE_028681:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_028684:        A9 01         LDA.B #$01                
CODE_028686:        9D F0 17      STA.W $17F0,X             
CODE_028689:        A5 9A         LDA RAM_BlockYLo          
CODE_02868B:        18            CLC                       
CODE_02868C:        79 46 87      ADC.W DATA_028746,Y       
CODE_02868F:        9D 08 18      STA.W $1808,X             
CODE_028692:        A5 9B         LDA RAM_BlockYHi          
CODE_028694:        69 00         ADC.B #$00                
CODE_028696:        9D EA 18      STA.W $18EA,X             
CODE_028699:        A5 98         LDA RAM_BlockXLo          
CODE_02869B:        18            CLC                       
CODE_02869C:        79 42 87      ADC.W DATA_028742,Y       
CODE_02869F:        9D FC 17      STA.W $17FC,X             
CODE_0286A2:        A5 99         LDA RAM_BlockXHi          
CODE_0286A4:        69 00         ADC.B #$00                
CODE_0286A6:        9D 14 18      STA.W $1814,X             
CODE_0286A9:        B9 4A 87      LDA.W DATA_02874A,Y       
CODE_0286AC:        9D 20 18      STA.W $1820,X             
CODE_0286AF:        B9 4E 87      LDA.W DATA_02874E,Y       
CODE_0286B2:        9D 2C 18      STA.W $182C,X             
CODE_0286B5:        A5 00         LDA $00                   
CODE_0286B7:        9D 50 18      STA.W $1850,X             
CODE_0286BA:        88            DEY                       
CODE_0286BB:        10 B2         BPL CODE_02866F           
CODE_0286BD:        FA            PLX                       
Return0286BE:       6B            RTL                       ; Return 

YoshiStompRoutine:  AD 97 16      LDA.W $1697               
CODE_0286C2:        D0 28         BNE Return0286EC          
CODE_0286C4:        8B            PHB                       
CODE_0286C5:        4B            PHK                       
CODE_0286C6:        AB            PLB                       
CODE_0286C7:        20 ED 86      JSR.W SprBlkInteract      
CODE_0286CA:        A9 02         LDA.B #$02                
CODE_0286CC:        99 CD 16      STA.W RAM_BouncBlkStatus,Y 
CODE_0286CF:        A5 94         LDA RAM_MarioXPos         
CODE_0286D1:        99 D1 16      STA.W $16D1,Y             
CODE_0286D4:        A5 95         LDA RAM_MarioXPosHi       
CODE_0286D6:        99 DD 16      STA.W $16DD,Y             
CODE_0286D9:        A5 96         LDA RAM_MarioYPos         
CODE_0286DB:        18            CLC                       
CODE_0286DC:        69 20         ADC.B #$20                
CODE_0286DE:        99 D9 16      STA.W $16D9,Y             
CODE_0286E1:        A5 97         LDA RAM_MarioYPosHi       
CODE_0286E3:        69 00         ADC.B #$00                
CODE_0286E5:        99 DD 16      STA.W $16DD,Y             
CODE_0286E8:        20 E4 9B      JSR.W CODE_029BE4         
CODE_0286EB:        AB            PLB                       
Return0286EC:       6B            RTL                       ; Return 

SprBlkInteract:     A0 03         LDY.B #$03                
CODE_0286EF:        B9 CD 16      LDA.W RAM_BouncBlkStatus,Y 
CODE_0286F2:        F0 04         BEQ CODE_0286F8           
CODE_0286F4:        88            DEY                       
CODE_0286F5:        10 F8         BPL CODE_0286EF           
CODE_0286F7:        C8            INY                       
CODE_0286F8:        A5 9A         LDA RAM_BlockYLo          
CODE_0286FA:        99 D1 16      STA.W $16D1,Y             
CODE_0286FD:        A5 9B         LDA RAM_BlockYHi          
CODE_0286FF:        99 D5 16      STA.W $16D5,Y             
CODE_028702:        A5 98         LDA RAM_BlockXLo          
CODE_028704:        99 D9 16      STA.W $16D9,Y             
CODE_028707:        A5 99         LDA RAM_BlockXHi          
CODE_028709:        99 DD 16      STA.W $16DD,Y             
CODE_02870C:        AD 33 19      LDA.W $1933               
CODE_02870F:        F0 1E         BEQ CODE_02872F           
CODE_028711:        A5 9A         LDA RAM_BlockYLo          
CODE_028713:        38            SEC                       
CODE_028714:        E5 26         SBC $26                   
CODE_028716:        99 D1 16      STA.W $16D1,Y             
CODE_028719:        A5 9B         LDA RAM_BlockYHi          
CODE_02871B:        E5 27         SBC $27                   
CODE_02871D:        99 D5 16      STA.W $16D5,Y             
CODE_028720:        A5 98         LDA RAM_BlockXLo          
CODE_028722:        38            SEC                       
CODE_028723:        E5 28         SBC $28                   
CODE_028725:        99 D9 16      STA.W $16D9,Y             
CODE_028728:        A5 99         LDA RAM_BlockXHi          
CODE_02872A:        E5 29         SBC $29                   
CODE_02872C:        99 DD 16      STA.W $16DD,Y             
CODE_02872F:        A9 01         LDA.B #$01                
CODE_028731:        99 CD 16      STA.W RAM_BouncBlkStatus,Y 
CODE_028734:        A9 06         LDA.B #$06                
CODE_028736:        99 F8 18      STA.W $18F8,Y             
Return028739:       60            RTS                       ; Return 


BlockBounceSpeedY:                .db $C0,$00,$00,$40

BlockBounceSpeedX:                .db $00,$40,$C0,$00

DATA_028742:                      .db $00,$00,$08,$08

DATA_028746:                      .db $00,$08,$00,$08

DATA_02874A:                      .db $FB,$FB,$FD,$FD

DATA_02874E:                      .db $FF,$01,$FF,$01

CODE_028752:        A5 04         LDA $04                   
CODE_028754:        C9 07         CMP.B #$07                
CODE_028756:        D0 3A         BNE NotBreakable          
BreakTurnBlock:     AD B3 0D      LDA.W $0DB3               ; \ Increase points 
CODE_02875B:        0A            ASL                       ;  | 
CODE_02875C:        6D B3 0D      ADC.W $0DB3               ;  | 
CODE_02875F:        AA            TAX                       ;  | 
CODE_028760:        BD 34 0F      LDA.W $0F34,X             ;  | 
CODE_028763:        18            CLC                       ;  | 
CODE_028764:        69 05         ADC.B #$05                ;  | 
CODE_028766:        9D 34 0F      STA.W $0F34,X             ;  | 
CODE_028769:        90 08         BCC CODE_028773           ;  | 
CODE_02876B:        FE 35 0F      INC.W $0F35,X             ;  | 
CODE_02876E:        D0 03         BNE CODE_028773           ;  | 
ADDR_028770:        FE 36 0F      INC.W $0F36,X             ; / 
CODE_028773:        A9 D0         LDA.B #$D0                ; Deflect Mario downward 
CODE_028775:        85 7D         STA RAM_MarioSpeedY       ; / 
CODE_028777:        A9 00         LDA.B #$00                ; for shatter routine? 
CODE_028779:        22 63 86 02   JSL.L ShatterBlock        ; Actually break the block 
CODE_02877D:        20 ED 86      JSR.W SprBlkInteract      ; Handle sprite/block interaction  
CODE_028780:        A9 02         LDA.B #$02                ; \ Replace block with "nothing" tile 
CODE_028782:        85 9C         STA RAM_BlockBlock        ;  | 
CODE_028784:        22 B0 BE 00   JSL.L GenerateTile        ; / 
Return028788:       6B            RTL                       ; Return 


BlockBounce:                      .db $00,$03,$00,$00,$01,$07,$00,$04
                                  .db $0A

NotBreakable:       A0 03         LDY.B #$03                ; \ Reset turning block 
FindTurningBlkSlot: B9 99 16      LDA.W RAM_BounceSprNum,Y  ;  | 
CODE_028797:        F0 6E         BEQ CODE_028807           ;  | 
CODE_028799:        88            DEY                       ;  | 
CODE_02879A:        10 F8         BPL FindTurningBlkSlot    ; / 
CODE_02879C:        CE CD 18      DEC.W $18CD               
CODE_02879F:        10 05         BPL CODE_0287A6           
CODE_0287A1:        A9 03         LDA.B #$03                
CODE_0287A3:        8D CD 18      STA.W $18CD               
CODE_0287A6:        AC CD 18      LDY.W $18CD               
CODE_0287A9:        B9 99 16      LDA.W RAM_BounceSprNum,Y  ; \ Branch if not a turn block 
CODE_0287AC:        C9 07         CMP.B #$07                ;  | 
CODE_0287AE:        D0 54         BNE NoResetTurningBlk     ; / 
CODE_0287B0:        A5 9A         LDA RAM_BlockYLo          ; \ Save [$98-$9A] 
CODE_0287B2:        48            PHA                       ;  | 
CODE_0287B3:        A5 9B         LDA RAM_BlockYHi          ;  | 
CODE_0287B5:        48            PHA                       ;  | 
CODE_0287B6:        A5 98         LDA RAM_BlockXLo          ;  | 
CODE_0287B8:        48            PHA                       ;  | 
CODE_0287B9:        A5 99         LDA RAM_BlockXHi          ;  | 
CODE_0287BB:        48            PHA                       ; / 
CODE_0287BC:        B9 A5 16      LDA.W RAM_BounceSprYLo,Y  ; \ Block Y position = Bounce Y sprite position 
CODE_0287BF:        85 9A         STA RAM_BlockYLo          ;  | 
CODE_0287C1:        B9 AD 16      LDA.W RAM_BounceSprYHi,Y  ;  | 
CODE_0287C4:        85 9B         STA RAM_BlockYHi          ; / 
CODE_0287C6:        B9 A1 16      LDA.W RAM_BounceSprXLo,Y  ; \ Block X position = Bounce X sprite position 
CODE_0287C9:        18            CLC                       ;  | 
CODE_0287CA:        69 0C         ADC.B #$0C                ;  | (Round to nearest #$10) 
CODE_0287CC:        29 F0         AND.B #$F0                ;  | 
CODE_0287CE:        85 98         STA RAM_BlockXLo          ;  | 
CODE_0287D0:        B9 A9 16      LDA.W RAM_BounceSprXHi,Y  ;  | 
CODE_0287D3:        69 00         ADC.B #$00                ;  | 
CODE_0287D5:        85 99         STA RAM_BlockXHi          ; / 
CODE_0287D7:        B9 C1 16      LDA.W RAM_BounceSprBlock,Y ; \ Block to generate = Bounce sprite block 
CODE_0287DA:        85 9C         STA RAM_BlockBlock        ; / 
CODE_0287DC:        A5 04         LDA $04                   ; \ Save [$04-$07] 
CODE_0287DE:        48            PHA                       ;  | 
CODE_0287DF:        A5 05         LDA $05                   ;  | 
CODE_0287E1:        48            PHA                       ;  | 
CODE_0287E2:        A5 06         LDA $06                   ;  | 
CODE_0287E4:        48            PHA                       ;  | 
CODE_0287E5:        A5 07         LDA $07                   ;  | 
CODE_0287E7:        48            PHA                       ; / 
CODE_0287E8:        22 B0 BE 00   JSL.L GenerateTile        
CODE_0287EC:        68            PLA                       ; \ Restore [$04-$07] 
CODE_0287ED:        85 07         STA $07                   ;  | 
CODE_0287EF:        68            PLA                       ;  | 
CODE_0287F0:        85 06         STA $06                   ;  | 
CODE_0287F2:        68            PLA                       ;  | 
CODE_0287F3:        85 05         STA $05                   ;  | 
CODE_0287F5:        68            PLA                       ;  | 
CODE_0287F6:        85 04         STA $04                   ; / 
CODE_0287F8:        68            PLA                       ; \ Restore [$98-$9A] 
CODE_0287F9:        85 99         STA RAM_BlockXHi          ;  | 
CODE_0287FB:        68            PLA                       ;  | 
CODE_0287FC:        85 98         STA RAM_BlockXLo          ;  | 
CODE_0287FE:        68            PLA                       ;  | 
CODE_0287FF:        85 9B         STA RAM_BlockYHi          ;  | 
CODE_028801:        68            PLA                       ;  | 
CODE_028802:        85 9A         STA RAM_BlockYLo          ; / 
NoResetTurningBlk:  AC CD 18      LDY.W $18CD               
CODE_028807:        A5 04         LDA $04                   
CODE_028809:        C9 10         CMP.B #$10                
CODE_02880B:        90 0B         BCC CODE_028818           
CODE_02880D:        64 04         STZ $04                   
CODE_02880F:        AA            TAX                       
CODE_028810:        BD 80 87      LDA.W CODE_028780,X       
CODE_028813:        99 01 19      STA.W $1901,Y             
CODE_028816:        80 12         BRA CODE_02882A           

CODE_028818:        A5 04         LDA $04                   ; \ Play on/off sound if appropriate 
CODE_02881A:        C9 05         CMP.B #$05                ;  | 
CODE_02881C:        D0 05         BNE CODE_028823           ;  | 
CODE_02881E:        A2 0B         LDX.B #$0B                ;  | 
CODE_028820:        8E F9 1D      STX.W $1DF9               ; / 
CODE_028823:        AA            TAX                       
CODE_028824:        BD 89 87      LDA.W BlockBounce,X       
CODE_028827:        99 01 19      STA.W $1901,Y             
CODE_02882A:        A5 04         LDA $04                   ; \ Set block bounce sprite type 
CODE_02882C:        1A            INC A                     ;  | 
CODE_02882D:        99 99 16      STA.W RAM_BounceSprNum,Y  ; / 
CODE_028830:        A9 00         LDA.B #$00                ; \ set (times can be hit?) 
CODE_028832:        99 9D 16      STA.W RAM_BounceSprInit,Y ; / 
CODE_028835:        A5 9A         LDA RAM_BlockYLo          ; \ Set bounce block y position 
CODE_028837:        99 A5 16      STA.W RAM_BounceSprYLo,Y  ;  | 
CODE_02883A:        A5 9B         LDA RAM_BlockYHi          ;  | 
CODE_02883C:        99 AD 16      STA.W RAM_BounceSprYHi,Y  ; / 
CODE_02883F:        A5 98         LDA RAM_BlockXLo          ; \ Set bounce block x position 
CODE_028841:        99 A1 16      STA.W RAM_BounceSprXLo,Y  ;  | 
CODE_028844:        A5 99         LDA RAM_BlockXHi          ;  | 
CODE_028846:        99 A9 16      STA.W RAM_BounceSprXHi,Y  ; / 
CODE_028849:        AD 33 19      LDA.W $1933               
CODE_02884C:        4A            LSR                       
CODE_02884D:        6A            ROR                       
CODE_02884E:        85 08         STA $08                   
CODE_028850:        A6 06         LDX $06                   
CODE_028852:        BD 3A 87      LDA.W BlockBounceSpeedY,X ; \ Set bounce y speed 
CODE_028855:        99 B1 16      STA.W RAM_BouncBlkSpeedX,Y ; / 
CODE_028858:        BD 3E 87      LDA.W BlockBounceSpeedX,X ; \ Set bounce x speed 
CODE_02885B:        99 B5 16      STA.W RAM_BouncBlkSpeedY,Y ; / 
CODE_02885E:        8A            TXA                       
CODE_02885F:        05 08         ORA $08                   
CODE_028861:        99 C9 16      STA.W $16C9,Y             
CODE_028864:        A5 07         LDA $07                   ; \ Set tile to turn block into 
CODE_028866:        99 C1 16      STA.W RAM_BounceSprBlock,Y ; / 
CODE_028869:        A9 08         LDA.B #$08                ; \ Time to show bouncing block 
CODE_02886B:        99 C5 16      STA.W RAM_BounceSprTimer,Y 
CODE_02886E:        B9 99 16      LDA.W RAM_BounceSprNum,Y  
CODE_028871:        C9 07         CMP.B #$07                
CODE_028873:        D0 05         BNE CODE_02887A           
CODE_028875:        A9 FF         LDA.B #$FF                
CODE_028877:        99 CE 18      STA.W $18CE,Y             
CODE_02887A:        20 ED 86      JSR.W SprBlkInteract      
CODE_02887D:        A5 05         LDA $05                   
CODE_02887F:        F0 1F         BEQ Return0288A0          
CODE_028881:        C9 0A         CMP.B #$0A                
CODE_028883:        D0 00         BNE CODE_028885           
CODE_028885:        A5 05         LDA $05                   
CODE_028887:        C9 08         CMP.B #$08                
CODE_028889:        B0 51         BCS CODE_0288DC           
CODE_02888B:        C9 06         CMP.B #$06                
CODE_02888D:        90 4D         BCC CODE_0288DC           
CODE_02888F:        C9 07         CMP.B #$07                
CODE_028891:        D0 0A         BNE CODE_02889D           
CODE_028893:        AD 6B 18      LDA.W $186B               
CODE_028896:        D0 05         BNE CODE_02889D           
CODE_028898:        A9 FF         LDA.B #$FF                
CODE_02889A:        8D 6B 18      STA.W $186B               
CODE_02889D:        20 66 8A      JSR.W CODE_028A66         
Return0288A0:       6B            RTL                       ; Return 


DATA_0288A1:                      .db $35,$78

SpriteInBlock:                    .db $00,$74,$75,$76,$77,$78,$00,$00
                                  .db $79,$00,$3E,$7D,$2C,$04,$81,$45
                                  .db $80

SpriteInBlockPow:                 .db $00,$74,$75,$76,$77,$78,$00,$00
                                  .db $79,$00,$3E,$7D,$2C,$04,$81,$45
                                  .db $80

StatusOfSprInBlk:                 .db $00,$08,$08,$08,$08,$08,$00,$00
                                  .db $08,$00,$09,$08,$09,$09,$08,$08
                                  .db $09

DATA_0288D6:                      .db $80,$7E,$7D

DATA_0288D9:                      .db $09,$08,$08

CODE_0288DC:        A4 05         LDY $05                   
CODE_0288DE:        C0 0B         CPY.B #$0B                
CODE_0288E0:        D0 08         BNE CODE_0288EA           
CODE_0288E2:        A5 9A         LDA RAM_BlockYLo          
CODE_0288E4:        29 30         AND.B #$30                
CODE_0288E6:        C9 20         CMP.B #$20                
CODE_0288E8:        F0 1B         BEQ GenSpriteFromBlk      
CODE_0288EA:        C0 10         CPY.B #$10                
CODE_0288EC:        F0 0F         BEQ CODE_0288FD           
CODE_0288EE:        C0 08         CPY.B #$08                
CODE_0288F0:        D0 07         BNE CODE_0288F9           
CODE_0288F2:        AD 92 16      LDA.W $1692               
CODE_0288F5:        F0 0E         BEQ GenSpriteFromBlk      
CODE_0288F7:        D0 04         BNE CODE_0288FD           
CODE_0288F9:        C0 0C         CPY.B #$0C                
CODE_0288FB:        D0 08         BNE GenSpriteFromBlk      
CODE_0288FD:        22 E4 A9 02   JSL.L FindFreeSprSlot     
CODE_028901:        BB            TYX                       
CODE_028902:        10 1E         BPL CODE_028922           
Return028904:       6B            RTL                       ; Return 

GenSpriteFromBlk:   A2 0B         LDX.B #$0B                ; \ Find a last free sprite slot from 00-0B 
CODE_028907:        BD C8 14      LDA.W $14C8,X             ;  | 
CODE_02890A:        F0 16         BEQ CODE_028922           ;  | 
CODE_02890C:        CA            DEX                       ;  | 
CODE_02890D:        E0 FF         CPX.B #$FF                ;  | 
CODE_02890F:        D0 F6         BNE CODE_028907           ; / 
CODE_028911:        CE 61 18      DEC.W $1861               
CODE_028914:        10 05         BPL CODE_02891B           
CODE_028916:        A9 01         LDA.B #$01                
CODE_028918:        8D 61 18      STA.W $1861               
CODE_02891B:        AD 61 18      LDA.W $1861               
CODE_02891E:        18            CLC                       
CODE_02891F:        69 0A         ADC.B #$0A                
CODE_028921:        AA            TAX                       
CODE_028922:        8E 5E 18      STX.W $185E               
CODE_028925:        A4 05         LDY $05                   
CODE_028927:        B9 C5 88      LDA.W StatusOfSprInBlk,Y  ; \ Set sprite status 
CODE_02892A:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02892D:        AD E2 18      LDA.W $18E2               
CODE_028930:        F0 05         BEQ CODE_028937           
CODE_028932:        98            TYA                       
CODE_028933:        18            CLC                       
CODE_028934:        69 11         ADC.B #$11                
CODE_028936:        A8            TAY                       
CODE_028937:        8C 95 16      STY.W $1695               
CODE_02893A:        B9 A3 88      LDA.W SpriteInBlock,Y     ; \ Set sprite number 
CODE_02893D:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_02893F:        85 0E         STA $0E                   
CODE_028941:        A0 02         LDY.B #$02                
CODE_028943:        C9 81         CMP.B #$81                
CODE_028945:        B0 05         BCS CODE_02894C           
CODE_028947:        C9 79         CMP.B #$79                
CODE_028949:        90 01         BCC CODE_02894C           
CODE_02894B:        C8            INY                       
CODE_02894C:        8C FC 1D      STY.W $1DFC               ; / Play sound effect 
CODE_02894F:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_028953:        FE A0 15      INC.W RAM_OffscreenHorz,X 
CODE_028956:        B5 9E         LDA RAM_SpriteNum,X       
CODE_028958:        C9 45         CMP.B #$45                
CODE_02895A:        D0 16         BNE CODE_028972           
CODE_02895C:        AD 32 14      LDA.W $1432               
CODE_02895F:        F0 06         BEQ CODE_028967           
ADDR_028961:        9E C8 14      STZ.W $14C8,X             
ADDR_028964:        4C 9D 88      JMP.W CODE_02889D         

CODE_028967:        A9 0E         LDA.B #$0E                
CODE_028969:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_02896C:        EE 32 14      INC.W $1432               
CODE_02896F:        9C 0C 19      STZ.W $190C               
CODE_028972:        A5 9A         LDA RAM_BlockYLo          
CODE_028974:        95 E4         STA RAM_SpriteXLo,X       
CODE_028976:        A5 9B         LDA RAM_BlockYHi          
CODE_028978:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02897B:        A5 98         LDA RAM_BlockXLo          
CODE_02897D:        95 D8         STA RAM_SpriteYLo,X       
CODE_02897F:        A5 99         LDA RAM_BlockXHi          
CODE_028981:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_028984:        AD 33 19      LDA.W $1933               
CODE_028987:        F0 1C         BEQ CODE_0289A5           
ADDR_028989:        A5 9A         LDA RAM_BlockYLo          
ADDR_02898B:        38            SEC                       
ADDR_02898C:        E5 26         SBC $26                   
ADDR_02898E:        95 E4         STA RAM_SpriteXLo,X       
ADDR_028990:        A5 9B         LDA RAM_BlockYHi          
ADDR_028992:        E5 27         SBC $27                   
ADDR_028994:        9D E0 14      STA.W RAM_SpriteXHi,X     
ADDR_028997:        A5 98         LDA RAM_BlockXLo          
ADDR_028999:        38            SEC                       
ADDR_02899A:        E5 28         SBC $28                   
ADDR_02899C:        95 D8         STA RAM_SpriteYLo,X       
ADDR_02899E:        A5 99         LDA RAM_BlockXHi          
ADDR_0289A0:        E5 29         SBC $29                   
ADDR_0289A2:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_0289A5:        B5 9E         LDA RAM_SpriteNum,X       
CODE_0289A7:        C9 7D         CMP.B #$7D                
CODE_0289A9:        D0 28         BNE CODE_0289D3           
CODE_0289AB:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_0289AD:        29 30         AND.B #$30                
CODE_0289AF:        4A            LSR                       
CODE_0289B0:        4A            LSR                       
CODE_0289B1:        4A            LSR                       
CODE_0289B2:        4A            LSR                       
CODE_0289B3:        A8            TAY                       
CODE_0289B4:        B9 D9 88      LDA.W DATA_0288D9,Y       
CODE_0289B7:        9D C8 14      STA.W $14C8,X             
CODE_0289BA:        B9 D6 88      LDA.W DATA_0288D6,Y       
CODE_0289BD:        95 9E         STA RAM_SpriteNum,X       
CODE_0289BF:        48            PHA                       
CODE_0289C0:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_0289C4:        68            PLA                       
CODE_0289C5:        C9 7D         CMP.B #$7D                
CODE_0289C7:        D0 04         BNE CODE_0289CD           
CODE_0289C9:        FE 7C 15      INC.W RAM_SpriteDir,X     
Return0289CC:       6B            RTL                       ; Return 

CODE_0289CD:        C9 7E         CMP.B #$7E                
CODE_0289CF:        F0 32         BEQ CODE_028A03           
CODE_0289D1:        80 2E         BRA CODE_028A01           

CODE_0289D3:        C9 04         CMP.B #$04                
CODE_0289D5:        F0 31         BEQ ADDR_028A08           
CODE_0289D7:        C9 3E         CMP.B #$3E                
CODE_0289D9:        F0 4F         BEQ CODE_028A2A           
CODE_0289DB:        C9 2C         CMP.B #$2C                
CODE_0289DD:        D0 32         BNE CODE_028A11           
CODE_0289DF:        A0 0B         LDY.B #$0B                
CODE_0289E1:        B9 C8 14      LDA.W $14C8,Y             
CODE_0289E4:        C9 08         CMP.B #$08                
CODE_0289E6:        90 0B         BCC CODE_0289F3           
CODE_0289E8:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_0289EB:        C9 2D         CMP.B #$2D                
CODE_0289ED:        D0 04         BNE CODE_0289F3           
CODE_0289EF:        A0 01         LDY.B #$01                
CODE_0289F1:        80 08         BRA CODE_0289FB           

CODE_0289F3:        88            DEY                       
CODE_0289F4:        10 EB         BPL CODE_0289E1           
CODE_0289F6:        AC E2 18      LDY.W $18E2               
CODE_0289F9:        D0 F4         BNE CODE_0289EF           
CODE_0289FB:        B9 A1 88      LDA.W DATA_0288A1,Y       
CODE_0289FE:        9D 1C 15      STA.W $151C,X             
CODE_028A01:        80 0A         BRA CODE_028A0D           

CODE_028A03:        F6 C2         INC RAM_SpriteState,X     
CODE_028A05:        F6 C2         INC RAM_SpriteState,X     
Return028A07:       6B            RTL                       ; Return 

ADDR_028A08:        A9 FF         LDA.B #$FF                
ADDR_028A0A:        9D 40 15      STA.W $1540,X             
CODE_028A0D:        A9 D0         LDA.B #$D0                
CODE_028A0F:        80 07         BRA CODE_028A18           

CODE_028A11:        A9 3E         LDA.B #$3E                
CODE_028A13:        9D 40 15      STA.W $1540,X             
CODE_028A16:        A9 D0         LDA.B #$D0                
CODE_028A18:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_028A1A:        A9 2C         LDA.B #$2C                
CODE_028A1C:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_028A1F:        BD 0F 19      LDA.W RAM_Tweaker190F,X   
CODE_028A22:        10 05         BPL Return028A29          
CODE_028A24:        A9 10         LDA.B #$10                
CODE_028A26:        9D AC 15      STA.W $15AC,X             
Return028A29:       6B            RTL                       ; Return 

CODE_028A2A:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_028A2C:        4A            LSR                       
CODE_028A2D:        4A            LSR                       
CODE_028A2E:        4A            LSR                       
CODE_028A2F:        4A            LSR                       
CODE_028A30:        29 01         AND.B #$01                
CODE_028A32:        9D 1C 15      STA.W $151C,X             
CODE_028A35:        A8            TAY                       
CODE_028A36:        B9 42 8A      LDA.W DATA_028A42,Y       
CODE_028A39:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_028A3C:        22 44 8A 02   JSL.L CODE_028A44         
CODE_028A40:        80 CB         BRA CODE_028A0D           


DATA_028A42:                      .db $06,$02

CODE_028A44:        DA            PHX                       
CODE_028A45:        A2 03         LDX.B #$03                
CODE_028A47:        BD C0 17      LDA.W $17C0,X             
CODE_028A4A:        F0 04         BEQ CODE_028A50           
CODE_028A4C:        CA            DEX                       
CODE_028A4D:        10 F8         BPL CODE_028A47           
CODE_028A4F:        E8            INX                       
CODE_028A50:        A9 01         LDA.B #$01                
CODE_028A52:        9D C0 17      STA.W $17C0,X             
CODE_028A55:        A5 98         LDA RAM_BlockXLo          
CODE_028A57:        9D C4 17      STA.W $17C4,X             
CODE_028A5A:        A5 9A         LDA RAM_BlockYLo          
CODE_028A5C:        9D C8 17      STA.W $17C8,X             
CODE_028A5F:        A9 1B         LDA.B #$1B                
CODE_028A61:        9D CC 17      STA.W $17CC,X             
CODE_028A64:        FA            PLX                       
Return028A65:       6B            RTL                       ; Return 

CODE_028A66:        A2 03         LDX.B #$03                
CODE_028A68:        BD D0 17      LDA.W $17D0,X             
CODE_028A6B:        F0 10         BEQ CODE_028A7D           
CODE_028A6D:        CA            DEX                       
CODE_028A6E:        10 F8         BPL CODE_028A68           
ADDR_028A70:        CE 65 18      DEC.W $1865               
ADDR_028A73:        10 05         BPL ADDR_028A7A           
ADDR_028A75:        A9 03         LDA.B #$03                
ADDR_028A77:        8D 65 18      STA.W $1865               
ADDR_028A7A:        AE 65 18      LDX.W $1865               
CODE_028A7D:        22 4A B3 05   JSL.L CODE_05B34A         
CODE_028A81:        FE D0 17      INC.W $17D0,X             
CODE_028A84:        A5 9A         LDA RAM_BlockYLo          
CODE_028A86:        9D E0 17      STA.W $17E0,X             
CODE_028A89:        A5 9B         LDA RAM_BlockYHi          
CODE_028A8B:        9D EC 17      STA.W $17EC,X             
CODE_028A8E:        A5 98         LDA RAM_BlockXLo          
CODE_028A90:        38            SEC                       
CODE_028A91:        E9 10         SBC.B #$10                
CODE_028A93:        9D D4 17      STA.W $17D4,X             
CODE_028A96:        A5 99         LDA RAM_BlockXHi          
CODE_028A98:        E9 00         SBC.B #$00                
CODE_028A9A:        9D E8 17      STA.W $17E8,X             
CODE_028A9D:        AD 33 19      LDA.W $1933               
CODE_028AA0:        9D E4 17      STA.W $17E4,X             
CODE_028AA3:        A9 D0         LDA.B #$D0                
CODE_028AA5:        9D D8 17      STA.W $17D8,X             
Return028AA8:       60            RTS                       ; Return 


DATA_028AA9:                      .db $07,$03,$03,$01,$01,$01,$01,$01

CODE_028AB1:        8B            PHB                       
CODE_028AB2:        4B            PHK                       
CODE_028AB3:        AB            PLB                       
CODE_028AB4:        AD E4 18      LDA.W $18E4               
CODE_028AB7:        F0 1C         BEQ CODE_028AD5           
CODE_028AB9:        AD E5 18      LDA.W $18E5               
CODE_028ABC:        F0 05         BEQ CODE_028AC3           
CODE_028ABE:        CE E5 18      DEC.W $18E5               
CODE_028AC1:        80 12         BRA CODE_028AD5           

CODE_028AC3:        CE E4 18      DEC.W $18E4               
CODE_028AC6:        F0 05         BEQ CODE_028ACD           
CODE_028AC8:        A9 23         LDA.B #$23                
CODE_028ACA:        8D E5 18      STA.W $18E5               
CODE_028ACD:        A9 05         LDA.B #$05                ; \ Play sound effect 
CODE_028ACF:        8D FC 1D      STA.W $1DFC               ; / 
CODE_028AD2:        EE BE 0D      INC.W RAM_StatusLives     
CODE_028AD5:        AD 90 14      LDA.W $1490               ; \ Branch if Mario doesn't have star 
CODE_028AD8:        F0 11         BEQ CODE_028AEB           ; / 
CODE_028ADA:        C9 08         CMP.B #$08                
CODE_028ADC:        90 0D         BCC CODE_028AEB           
CODE_028ADE:        4A            LSR                       
CODE_028ADF:        4A            LSR                       
CODE_028AE0:        4A            LSR                       
CODE_028AE1:        4A            LSR                       
CODE_028AE2:        4A            LSR                       
CODE_028AE3:        A8            TAY                       
CODE_028AE4:        A5 13         LDA RAM_FrameCounter      
CODE_028AE6:        39 A9 8A      AND.W DATA_028AA9,Y       
CODE_028AE9:        80 0A         BRA CODE_028AF5           

CODE_028AEB:        AD D3 18      LDA.W $18D3               
CODE_028AEE:        F0 15         BEQ CODE_028B05           
ADDR_028AF0:        CE D3 18      DEC.W $18D3               
ADDR_028AF3:        29 01         AND.B #$01                
CODE_028AF5:        05 7F         ORA $7F                   
CODE_028AF7:        05 81         ORA $81                   
CODE_028AF9:        D0 0A         BNE CODE_028B05           
CODE_028AFB:        A5 80         LDA $80                   
CODE_028AFD:        C9 D0         CMP.B #$D0                
CODE_028AFF:        B0 04         BCS CODE_028B05           
CODE_028B01:        22 8F 85 02   JSL.L CODE_02858F         
CODE_028B05:        20 67 8B      JSR.W CODE_028B67         
CODE_028B08:        20 2D 90      JSR.W CODE_02902D         
CODE_028B0B:        20 A4 AD      JSR.W ScoreSprGfx         
CODE_028B0E:        20 0A 9B      JSR.W CODE_029B0A         
CODE_028B11:        20 D2 99      JSR.W CODE_0299D2         
CODE_028B14:        20 87 B3      JSR.W CODE_02B387         
CODE_028B17:        20 FE AF      JSR.W CallGenerator       
CODE_028B1A:        20 F5 94      JSR.W CODE_0294F5         
CODE_028B1D:        20 FC A7      JSR.W LoadSprFromLevel    
CODE_028B20:        AD C0 18      LDA.W RAM_TimeTillRespawn ; \ Return if timer not set 
CODE_028B23:        F0 40         BEQ CODE_028B65           ; / 
CODE_028B25:        A5 13         LDA RAM_FrameCounter      ; \ Decrement every other frame... 
CODE_028B27:        29 01         AND.B #$01                ;  | 
CODE_028B29:        05 9D         ORA RAM_SpritesLocked     ;  | ...as long as sprites not locked... 
CODE_028B2B:        0D BF 18      ORA.W $18BF               
CODE_028B2E:        D0 35         BNE CODE_028B65           ;  | 
CODE_028B30:        CE C0 18      DEC.W RAM_TimeTillRespawn ; / 
CODE_028B33:        D0 30         BNE CODE_028B65           ; Return if the timer hasn't just run out 
CODE_028B35:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_028B39:        30 2A         BMI CODE_028B65           ; / 
CODE_028B3B:        BB            TYX                       
CODE_028B3C:        A9 01         LDA.B #$01                ; \ Sprite status = Initialization 
CODE_028B3E:        9D C8 14      STA.W $14C8,X             ; / 
CODE_028B41:        AD C1 18      LDA.W RAM_SpriteToRespawn ; \ Sprite = Sprite to respwan 
CODE_028B44:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_028B46:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_028B48:        38            SEC                       
CODE_028B49:        E9 20         SBC.B #$20                
CODE_028B4B:        29 EF         AND.B #$EF                
CODE_028B4D:        95 E4         STA RAM_SpriteXLo,X       
CODE_028B4F:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_028B51:        E9 00         SBC.B #$00                
CODE_028B53:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_028B56:        AD C3 18      LDA.W $18C3               
CODE_028B59:        95 D8         STA RAM_SpriteYLo,X       
CODE_028B5B:        AD C4 18      LDA.W $18C4               
CODE_028B5E:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_028B61:        22 D2 F7 07   JSL.L InitSpriteTables    ; Reset sprite tables 
CODE_028B65:        AB            PLB                       
Return028B66:       6B            RTL                       ; Return 

CODE_028B67:        A2 0B         LDX.B #$0B                
CODE_028B69:        BD F0 17      LDA.W $17F0,X             
CODE_028B6C:        F0 06         BEQ CODE_028B74           
CODE_028B6E:        8E 98 16      STX.W $1698               
CODE_028B71:        20 94 8B      JSR.W CODE_028B94         
CODE_028B74:        CA            DEX                       
CODE_028B75:        10 F2         BPL CODE_028B69           
Return028B77:       60            RTS                       ; Return 


BrokenBlock:                      .db $50,$54,$58,$5C,$60,$64,$68,$6C
                                  .db $70,$74,$78,$7C

BrokenBlock2:                     .db $3C,$3D,$3D,$3C,$3C,$3D,$3D,$3C
DATA_028B8C:                      .db $00,$00,$80,$80,$80,$C0,$40,$00

CODE_028B94:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs028B98:            77 8B      .dw Return028B77          
                       8B 8F      .dw CODE_028F8B           
                       D2 8E      .dw CODE_028ED2           
                       7E 8E      .dw CODE_028E7E           
                       2F 8F      .dw CODE_028F2F           
                       D2 8E      .dw CODE_028ED2           
                       DB 8D      .dw CODE_028DDB           
                       4F 8D      .dw CODE_028D4F           
                       DB 8D      .dw CODE_028DDB           
                       DB 8D      .dw CODE_028DDB           
                       C4 8C      .dw CODE_028CC4           
                       0F 8C      .dw ADDR_028C0F           

DisabledAddSmokeRt: 8B            PHB                       ; \ This routine does nothing at all 
CODE_028BB1:        4B            PHK                       ;  | I believe it used to call the below 
CODE_028BB2:        AB            PLB                       ;  | routine to add smoke when boarding 
CODE_028BB3:        20 B8 8B      JSR.W Return028BB8        ;  | Yoshi 
CODE_028BB6:        AB            PLB                       ;  | 
Return028BB7:       6B            RTL                       ; / Return 

Return028BB8:       60            RTS                       ; Return 

UnusedYoshiSmoke:   64 00         STZ $00                   ; \ Display smoke when getting on Yoshi 
ADDR_028BBB:        20 C0 8B      JSR.W ADDR_028BC0         ;  | 
ADDR_028BBE:        E6 00         INC $00                   ;  | 
ADDR_028BC0:        A0 0B         LDY.B #$0B                ;  | 
ADDR_028BC2:        B9 F0 17      LDA.W $17F0,Y             ;  | 
ADDR_028BC5:        F0 04         BEQ ADDR_028BCB           ;  | 
ADDR_028BC7:        88            DEY                       ;  | 
ADDR_028BC8:        10 F8         BPL ADDR_028BC2           ;  | 
Return028BCA:       60            RTS                       ; / Return 

ADDR_028BCB:        A9 0B         LDA.B #$0B                
ADDR_028BCD:        99 F0 17      STA.W $17F0,Y             
ADDR_028BD0:        A9 00         LDA.B #$00                
ADDR_028BD2:        99 50 18      STA.W $1850,Y             
ADDR_028BD5:        B5 D8         LDA RAM_SpriteYLo,X       
ADDR_028BD7:        18            CLC                       
ADDR_028BD8:        69 1C         ADC.B #$1C                
ADDR_028BDA:        99 FC 17      STA.W $17FC,Y             
ADDR_028BDD:        BD D4 14      LDA.W RAM_SpriteYHi,X     
ADDR_028BE0:        69 00         ADC.B #$00                
ADDR_028BE2:        99 14 18      STA.W $1814,Y             
ADDR_028BE5:        A5 94         LDA RAM_MarioXPos         
ADDR_028BE7:        85 02         STA $02                   
ADDR_028BE9:        A5 95         LDA RAM_MarioXPosHi       
ADDR_028BEB:        85 03         STA $03                   
ADDR_028BED:        DA            PHX                       
ADDR_028BEE:        A6 00         LDX $00                   
ADDR_028BF0:        BD 09 8C      LDA.W DATA_028C09,X       
ADDR_028BF3:        99 2C 18      STA.W $182C,Y             
ADDR_028BF6:        A5 02         LDA $02                   
ADDR_028BF8:        18            CLC                       
ADDR_028BF9:        7D 0B 8C      ADC.W DATA_028C0B,X       
ADDR_028BFC:        99 08 18      STA.W $1808,Y             
ADDR_028BFF:        A5 03         LDA $03                   
ADDR_028C01:        7D 0D 8C      ADC.W DATA_028C0D,X       
ADDR_028C04:        99 EA 18      STA.W $18EA,Y             
ADDR_028C07:        FA            PLX                       
Return028C08:       60            RTS                       ; Return 


DATA_028C09:                      .db $40,$C0

DATA_028C0B:                      .db $0C,$FC

DATA_028C0D:                      .db $00,$FF

ADDR_028C0F:        BD 50 18      LDA.W $1850,X             
ADDR_028C12:        D0 4D         BNE ADDR_028C61           
ADDR_028C14:        BD 2C 18      LDA.W $182C,X             
ADDR_028C17:        F0 4D         BEQ ADDR_028C66           
ADDR_028C19:        10 05         BPL ADDR_028C20           
ADDR_028C1B:        18            CLC                       
ADDR_028C1C:        69 08         ADC.B #$08                
ADDR_028C1E:        80 03         BRA ADDR_028C23           

ADDR_028C20:        38            SEC                       
ADDR_028C21:        E9 08         SBC.B #$08                
ADDR_028C23:        9D 2C 18      STA.W $182C,X             
ADDR_028C26:        20 BC B5      JSR.W CODE_02B5BC         
ADDR_028C29:        8A            TXA                       
ADDR_028C2A:        45 13         EOR RAM_FrameCounter      
ADDR_028C2C:        29 03         AND.B #$03                
ADDR_028C2E:        D0 30         BNE Return028C60          
ADDR_028C30:        A0 0B         LDY.B #$0B                
ADDR_028C32:        B9 F0 17      LDA.W $17F0,Y             
ADDR_028C35:        F0 04         BEQ ADDR_028C3B           
ADDR_028C37:        88            DEY                       
ADDR_028C38:        10 F8         BPL ADDR_028C32           
Return028C3A:       60            RTS                       ; Return 

ADDR_028C3B:        A9 0B         LDA.B #$0B                
ADDR_028C3D:        99 F0 17      STA.W $17F0,Y             
ADDR_028C40:        99 20 18      STA.W $1820,Y             
ADDR_028C43:        BD 08 18      LDA.W $1808,X             
ADDR_028C46:        99 08 18      STA.W $1808,Y             
ADDR_028C49:        BD EA 18      LDA.W $18EA,X             
ADDR_028C4C:        99 EA 18      STA.W $18EA,Y             
ADDR_028C4F:        BD FC 17      LDA.W $17FC,X             
ADDR_028C52:        99 FC 17      STA.W $17FC,Y             
ADDR_028C55:        BD 14 18      LDA.W $1814,X             
ADDR_028C58:        99 14 18      STA.W $1814,Y             
ADDR_028C5B:        A9 10         LDA.B #$10                
ADDR_028C5D:        99 50 18      STA.W $1850,Y             
Return028C60:       60            RTS                       ; Return 

ADDR_028C61:        DE 50 18      DEC.W $1850,X             
ADDR_028C64:        D0 08         BNE ADDR_028C6E           
ADDR_028C66:        9E F0 17      STZ.W $17F0,X             
Return028C69:       60            RTS                       ; Return 


DATA_028C6A:                      .db $66,$66,$64,$62

ADDR_028C6E:        BC 78 8B      LDY.W BrokenBlock,X       
ADDR_028C71:        BD 08 18      LDA.W $1808,X             
ADDR_028C74:        38            SEC                       
ADDR_028C75:        E5 1A         SBC RAM_ScreenBndryXLo    
ADDR_028C77:        85 00         STA $00                   
ADDR_028C79:        BD EA 18      LDA.W $18EA,X             
ADDR_028C7C:        E5 1B         SBC RAM_ScreenBndryXHi    
ADDR_028C7E:        D0 E6         BNE ADDR_028C66           
ADDR_028C80:        BD FC 17      LDA.W $17FC,X             
ADDR_028C83:        38            SEC                       
ADDR_028C84:        E5 1C         SBC RAM_ScreenBndryYLo    
ADDR_028C86:        85 01         STA $01                   
ADDR_028C88:        BD 14 18      LDA.W $1814,X             
ADDR_028C8B:        E5 1D         SBC RAM_ScreenBndryYHi    
ADDR_028C8D:        D0 D7         BNE ADDR_028C66           
ADDR_028C8F:        A5 00         LDA $00                   
ADDR_028C91:        99 00 02      STA.W OAM_ExtendedDispX,Y 
ADDR_028C94:        A5 01         LDA $01                   
ADDR_028C96:        99 01 02      STA.W OAM_ExtendedDispY,Y 
ADDR_028C99:        DA            PHX                       
ADDR_028C9A:        BD 50 18      LDA.W $1850,X             
ADDR_028C9D:        4A            LSR                       
ADDR_028C9E:        4A            LSR                       
ADDR_028C9F:        AA            TAX                       
ADDR_028CA0:        BD 6A 8C      LDA.W DATA_028C6A,X       
ADDR_028CA3:        99 02 02      STA.W OAM_ExtendedTile,Y  
ADDR_028CA6:        FA            PLX                       
ADDR_028CA7:        A5 64         LDA $64                   
ADDR_028CA9:        09 08         ORA.B #$08                
ADDR_028CAB:        99 03 02      STA.W OAM_ExtendedProp,Y  
ADDR_028CAE:        98            TYA                       
ADDR_028CAF:        4A            LSR                       
ADDR_028CB0:        4A            LSR                       
ADDR_028CB1:        A8            TAY                       
ADDR_028CB2:        A9 00         LDA.B #$00                
ADDR_028CB4:        99 20 04      STA.W $0420,Y             
Return028CB7:       60            RTS                       ; Return 


BooStreamTiles:                   .db $88,$A8,$AA,$8C,$8E,$AE,$88,$A8
                                  .db $AA,$8C,$8E,$AE

CODE_028CC4:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_028CC6:        D0 37         BNE CODE_028CFF           ; / 
CODE_028CC8:        BD 08 18      LDA.W $1808,X             
CODE_028CCB:        18            CLC                       
CODE_028CCC:        69 04         ADC.B #$04                
CODE_028CCE:        85 04         STA $04                   
CODE_028CD0:        BD EA 18      LDA.W $18EA,X             
CODE_028CD3:        69 00         ADC.B #$00                
CODE_028CD5:        85 0A         STA $0A                   
CODE_028CD7:        BD FC 17      LDA.W $17FC,X             
CODE_028CDA:        18            CLC                       
CODE_028CDB:        69 04         ADC.B #$04                
CODE_028CDD:        85 05         STA $05                   
CODE_028CDF:        BD 14 18      LDA.W $1814,X             
CODE_028CE2:        69 00         ADC.B #$00                
CODE_028CE4:        85 0B         STA $0B                   
CODE_028CE6:        A9 08         LDA.B #$08                
CODE_028CE8:        85 06         STA $06                   
CODE_028CEA:        85 07         STA $07                   
CODE_028CEC:        22 64 B6 03   JSL.L GetMarioClipping    
CODE_028CF0:        22 2B B7 03   JSL.L CheckForContact     
CODE_028CF4:        90 04         BCC CODE_028CFA           
CODE_028CF6:        22 B7 F5 00   JSL.L HurtMario           
CODE_028CFA:        DE 50 18      DEC.W $1850,X             
CODE_028CFD:        F0 63         BEQ CODE_028D62           
CODE_028CFF:        BC 78 8B      LDY.W BrokenBlock,X       
CODE_028D02:        BD 08 18      LDA.W $1808,X             
CODE_028D05:        38            SEC                       
CODE_028D06:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_028D08:        85 00         STA $00                   
CODE_028D0A:        BD EA 18      LDA.W $18EA,X             
CODE_028D0D:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_028D0F:        D0 30         BNE Return028D41          
CODE_028D11:        A5 00         LDA $00                   
CODE_028D13:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_028D16:        BD FC 17      LDA.W $17FC,X             
CODE_028D19:        38            SEC                       
CODE_028D1A:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_028D1C:        C9 F0         CMP.B #$F0                
CODE_028D1E:        B0 42         BCS CODE_028D62           
CODE_028D20:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_028D23:        BD B8 8C      LDA.W BooStreamTiles,X    
CODE_028D26:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_028D29:        BD 2C 18      LDA.W $182C,X             
CODE_028D2C:        4A            LSR                       
CODE_028D2D:        29 40         AND.B #$40                
CODE_028D2F:        49 40         EOR.B #$40                
CODE_028D31:        05 64         ORA $64                   
CODE_028D33:        09 0F         ORA.B #$0F                
CODE_028D35:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_028D38:        98            TYA                       
CODE_028D39:        4A            LSR                       
CODE_028D3A:        4A            LSR                       
CODE_028D3B:        A8            TAY                       
CODE_028D3C:        A9 02         LDA.B #$02                
CODE_028D3E:        99 20 04      STA.W $0420,Y             
Return028D41:       60            RTS                       ; Return 


WaterSplashTiles:                 .db $68,$68,$6A,$6A,$6A,$62,$62,$62
                                  .db $64,$64,$64,$64,$66

CODE_028D4F:        BD 08 18      LDA.W $1808,X             
CODE_028D52:        C5 1A         CMP RAM_ScreenBndryXLo    
CODE_028D54:        BD EA 18      LDA.W $18EA,X             
CODE_028D57:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_028D59:        D0 07         BNE CODE_028D62           
CODE_028D5B:        BD 50 18      LDA.W $1850,X             
CODE_028D5E:        C9 20         CMP.B #$20                
CODE_028D60:        D0 04         BNE CODE_028D66           
CODE_028D62:        9E F0 17      STZ.W $17F0,X             
Return028D65:       60            RTS                       ; Return 

CODE_028D66:        64 00         STZ $00                   
CODE_028D68:        C9 10         CMP.B #$10                
CODE_028D6A:        90 1F         BCC CODE_028D8B           
CODE_028D6C:        29 01         AND.B #$01                
CODE_028D6E:        05 9D         ORA RAM_SpritesLocked     
CODE_028D70:        D0 03         BNE CODE_028D75           
CODE_028D72:        FE FC 17      INC.W $17FC,X             
CODE_028D75:        BD 50 18      LDA.W $1850,X             
CODE_028D78:        38            SEC                       
CODE_028D79:        E9 10         SBC.B #$10                
CODE_028D7B:        4A            LSR                       
CODE_028D7C:        4A            LSR                       
CODE_028D7D:        85 02         STA $02                   
CODE_028D7F:        A5 13         LDA RAM_FrameCounter      
CODE_028D81:        4A            LSR                       
CODE_028D82:        A5 02         LDA $02                   
CODE_028D84:        90 03         BCC CODE_028D89           
CODE_028D86:        49 FF         EOR.B #$FF                
CODE_028D88:        1A            INC A                     
CODE_028D89:        85 00         STA $00                   
CODE_028D8B:        BC 78 8B      LDY.W BrokenBlock,X       
CODE_028D8E:        BD 08 18      LDA.W $1808,X             
CODE_028D91:        18            CLC                       
CODE_028D92:        65 00         ADC $00                   
CODE_028D94:        38            SEC                       
CODE_028D95:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_028D97:        C9 F0         CMP.B #$F0                
CODE_028D99:        B0 C7         BCS CODE_028D62           
CODE_028D9B:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_028D9E:        BD FC 17      LDA.W $17FC,X             
CODE_028DA1:        38            SEC                       
CODE_028DA2:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_028DA4:        C9 E8         CMP.B #$E8                
CODE_028DA6:        B0 BA         BCS CODE_028D62           
CODE_028DA8:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_028DAB:        BD 50 18      LDA.W $1850,X             
CODE_028DAE:        4A            LSR                       
CODE_028DAF:        AA            TAX                       
CODE_028DB0:        E0 0C         CPX.B #$0C                
CODE_028DB2:        90 02         BCC CODE_028DB6           
CODE_028DB4:        A2 0C         LDX.B #$0C                
CODE_028DB6:        BD 42 8D      LDA.W WaterSplashTiles,X  
CODE_028DB9:        AE 98 16      LDX.W $1698               
CODE_028DBC:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_028DBF:        A5 64         LDA $64                   
CODE_028DC1:        09 02         ORA.B #$02                
CODE_028DC3:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_028DC6:        98            TYA                       
CODE_028DC7:        4A            LSR                       
CODE_028DC8:        4A            LSR                       
CODE_028DC9:        A8            TAY                       
CODE_028DCA:        A9 02         LDA.B #$02                
CODE_028DCC:        99 20 04      STA.W $0420,Y             
CODE_028DCF:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_028DD1:        D0 03         BNE Return028DD6          ; / 
CODE_028DD3:        FE 50 18      INC.W $1850,X             
Return028DD6:       60            RTS                       ; Return 


RipVanFishZsTiles:                .db $F1,$F0,$E1,$E0

CODE_028DDB:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_028DDD:        D0 41         BNE CODE_028E20           ; / 
CODE_028DDF:        BD 50 18      LDA.W $1850,X             
CODE_028DE2:        F0 03         BEQ CODE_028DE7           
CODE_028DE4:        DE 50 18      DEC.W $1850,X             
CODE_028DE7:        BD 50 18      LDA.W $1850,X             
CODE_028DEA:        29 00         AND.B #$00                
CODE_028DEC:        D0 10         BNE CODE_028DFE           
CODE_028DEE:        BD 50 18      LDA.W $1850,X             
CODE_028DF1:        FE 2C 18      INC.W $182C,X             
CODE_028DF4:        29 10         AND.B #$10                
CODE_028DF6:        D0 06         BNE CODE_028DFE           
CODE_028DF8:        DE 2C 18      DEC.W $182C,X             
CODE_028DFB:        DE 2C 18      DEC.W $182C,X             
CODE_028DFE:        BD 2C 18      LDA.W $182C,X             
CODE_028E01:        48            PHA                       
CODE_028E02:        BC F0 17      LDY.W $17F0,X             
CODE_028E05:        C0 09         CPY.B #$09                
CODE_028E07:        D0 06         BNE CODE_028E0F           
ADDR_028E09:        49 FF         EOR.B #$FF                
ADDR_028E0B:        1A            INC A                     
ADDR_028E0C:        9D 2C 18      STA.W $182C,X             
CODE_028E0F:        20 BC B5      JSR.W CODE_02B5BC         
CODE_028E12:        68            PLA                       
CODE_028E13:        9D 2C 18      STA.W $182C,X             
CODE_028E16:        BD 50 18      LDA.W $1850,X             
CODE_028E19:        29 03         AND.B #$03                
CODE_028E1B:        D0 03         BNE CODE_028E20           
CODE_028E1D:        DE FC 17      DEC.W $17FC,X             
CODE_028E20:        BC 78 8B      LDY.W BrokenBlock,X       
CODE_028E23:        BD 08 18      LDA.W $1808,X             
CODE_028E26:        38            SEC                       
CODE_028E27:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_028E29:        C9 08         CMP.B #$08                
CODE_028E2B:        90 49         BCC CODE_028E76           
CODE_028E2D:        C9 FC         CMP.B #$FC                
CODE_028E2F:        B0 45         BCS CODE_028E76           
CODE_028E31:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_028E34:        BD FC 17      LDA.W $17FC,X             
CODE_028E37:        38            SEC                       
CODE_028E38:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_028E3A:        C9 F0         CMP.B #$F0                
CODE_028E3C:        B0 38         BCS CODE_028E76           
CODE_028E3E:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_028E41:        A5 64         LDA $64                   
CODE_028E43:        09 03         ORA.B #$03                
CODE_028E45:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_028E48:        BD 50 18      LDA.W $1850,X             
CODE_028E4B:        C9 14         CMP.B #$14                
CODE_028E4D:        F0 27         BEQ CODE_028E76           
CODE_028E4F:        BD F0 17      LDA.W $17F0,X             
CODE_028E52:        C9 08         CMP.B #$08                
CODE_028E54:        A9 7F         LDA.B #$7F                
CODE_028E56:        B0 0E         BCS CODE_028E66           
CODE_028E58:        BD 50 18      LDA.W $1850,X             
CODE_028E5B:        4A            LSR                       
CODE_028E5C:        4A            LSR                       
CODE_028E5D:        4A            LSR                       
CODE_028E5E:        4A            LSR                       
CODE_028E5F:        4A            LSR                       
CODE_028E60:        29 03         AND.B #$03                
CODE_028E62:        AA            TAX                       
CODE_028E63:        BD D7 8D      LDA.W RipVanFishZsTiles,X 
CODE_028E66:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_028E69:        98            TYA                       
CODE_028E6A:        4A            LSR                       
CODE_028E6B:        4A            LSR                       
CODE_028E6C:        A8            TAY                       
CODE_028E6D:        A9 00         LDA.B #$00                
CODE_028E6F:        99 20 04      STA.W $0420,Y             
CODE_028E72:        AE 98 16      LDX.W $1698               
Return028E75:       60            RTS                       ; Return 

CODE_028E76:        9E F0 17      STZ.W $17F0,X             
Return028E79:       60            RTS                       ; Return 


DATA_028E7A:                      .db $03,$43,$83,$C3

CODE_028E7E:        DE 50 18      DEC.W $1850,X             
CODE_028E81:        BD 50 18      LDA.W $1850,X             
CODE_028E84:        29 3F         AND.B #$3F                
CODE_028E86:        F0 4F         BEQ CODE_028ED7           
CODE_028E88:        20 BC B5      JSR.W CODE_02B5BC         
CODE_028E8B:        20 C8 B5      JSR.W CODE_02B5C8         
CODE_028E8E:        FE 20 18      INC.W $1820,X             
CODE_028E91:        FE 20 18      INC.W $1820,X             
CODE_028E94:        BC 78 8B      LDY.W BrokenBlock,X       
CODE_028E97:        BD FC 17      LDA.W $17FC,X             
CODE_028E9A:        38            SEC                       
CODE_028E9B:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_028E9D:        C9 F0         CMP.B #$F0                
CODE_028E9F:        B0 36         BCS CODE_028ED7           
CODE_028EA1:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_028EA4:        BD 08 18      LDA.W $1808,X             
CODE_028EA7:        38            SEC                       
CODE_028EA8:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_028EAA:        C9 F8         CMP.B #$F8                
CODE_028EAC:        B0 29         BCS CODE_028ED7           
CODE_028EAE:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_028EB1:        A9 6F         LDA.B #$6F                
CODE_028EB3:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_028EB6:        BD 50 18      LDA.W $1850,X             
CODE_028EB9:        29 C0         AND.B #$C0                
CODE_028EBB:        09 03         ORA.B #$03                
CODE_028EBD:        05 64         ORA $64                   
CODE_028EBF:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_028EC2:        98            TYA                       
CODE_028EC3:        4A            LSR                       
CODE_028EC4:        4A            LSR                       
CODE_028EC5:        A8            TAY                       
CODE_028EC6:        A9 00         LDA.B #$00                
CODE_028EC8:        99 20 04      STA.W $0420,Y             
Return028ECB:       60            RTS                       ; Return 


StarSparkleTiles:                 .db $66,$6E,$FF,$6D,$6C,$5C

CODE_028ED2:        BD 50 18      LDA.W $1850,X             
CODE_028ED5:        D0 03         BNE CODE_028EDA           
CODE_028ED7:        4C 87 8F      JMP.W CODE_028F87         

CODE_028EDA:        A4 9D         LDY RAM_SpritesLocked     
CODE_028EDC:        D0 03         BNE CODE_028EE1           
CODE_028EDE:        DE 50 18      DEC.W $1850,X             
CODE_028EE1:        BC 78 8B      LDY.W BrokenBlock,X       
CODE_028EE4:        BD 08 18      LDA.W $1808,X             
CODE_028EE7:        38            SEC                       
CODE_028EE8:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_028EEA:        C9 F0         CMP.B #$F0                
CODE_028EEC:        B0 E9         BCS CODE_028ED7           
CODE_028EEE:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_028EF1:        BD FC 17      LDA.W $17FC,X             
CODE_028EF4:        38            SEC                       
CODE_028EF5:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_028EF7:        C9 F0         CMP.B #$F0                
CODE_028EF9:        B0 DC         BCS CODE_028ED7           
CODE_028EFB:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_028EFE:        BD F0 17      LDA.W $17F0,X             
CODE_028F01:        48            PHA                       
CODE_028F02:        BD 50 18      LDA.W $1850,X             
CODE_028F05:        4A            LSR                       
CODE_028F06:        4A            LSR                       
CODE_028F07:        4A            LSR                       
CODE_028F08:        AA            TAX                       
CODE_028F09:        68            PLA                       
CODE_028F0A:        C9 05         CMP.B #$05                
CODE_028F0C:        D0 03         BNE CODE_028F11           
CODE_028F0E:        E8            INX                       
CODE_028F0F:        E8            INX                       
CODE_028F10:        E8            INX                       
CODE_028F11:        BD CC 8E      LDA.W StarSparkleTiles,X  
CODE_028F14:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_028F17:        A5 64         LDA $64                   
CODE_028F19:        09 06         ORA.B #$06                
CODE_028F1B:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_028F1E:        AE 98 16      LDX.W $1698               
CODE_028F21:        98            TYA                       
CODE_028F22:        4A            LSR                       
CODE_028F23:        4A            LSR                       
CODE_028F24:        A8            TAY                       
CODE_028F25:        A9 00         LDA.B #$00                
CODE_028F27:        99 20 04      STA.W $0420,Y             
Return028F2A:       60            RTS                       ; Return 


LavaSplashTiles:                  .db $D7,$C7,$D6,$C6

CODE_028F2F:        BD 08 18      LDA.W $1808,X             
CODE_028F32:        C5 1A         CMP RAM_ScreenBndryXLo    
CODE_028F34:        BD EA 18      LDA.W $18EA,X             
CODE_028F37:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_028F39:        D0 4C         BNE CODE_028F87           
CODE_028F3B:        BD 50 18      LDA.W $1850,X             
CODE_028F3E:        F0 47         BEQ CODE_028F87           
CODE_028F40:        A4 9D         LDY RAM_SpritesLocked     
CODE_028F42:        D0 09         BNE CODE_028F4D           
CODE_028F44:        DE 50 18      DEC.W $1850,X             
CODE_028F47:        20 C8 B5      JSR.W CODE_02B5C8         
CODE_028F4A:        FE 20 18      INC.W $1820,X             
CODE_028F4D:        BC 78 8B      LDY.W BrokenBlock,X       
CODE_028F50:        BD 08 18      LDA.W $1808,X             
CODE_028F53:        38            SEC                       
CODE_028F54:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_028F56:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_028F59:        BD FC 17      LDA.W $17FC,X             
CODE_028F5C:        C9 F0         CMP.B #$F0                
CODE_028F5E:        B0 27         BCS CODE_028F87           
CODE_028F60:        38            SEC                       
CODE_028F61:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_028F63:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_028F66:        BD 50 18      LDA.W $1850,X             
CODE_028F69:        4A            LSR                       
CODE_028F6A:        4A            LSR                       
CODE_028F6B:        4A            LSR                       
CODE_028F6C:        AA            TAX                       
CODE_028F6D:        BD 2B 8F      LDA.W LavaSplashTiles,X   
CODE_028F70:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_028F73:        A5 64         LDA $64                   
CODE_028F75:        09 05         ORA.B #$05                
CODE_028F77:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_028F7A:        AE 98 16      LDX.W $1698               
CODE_028F7D:        98            TYA                       
CODE_028F7E:        4A            LSR                       
CODE_028F7F:        4A            LSR                       
CODE_028F80:        A8            TAY                       
CODE_028F81:        A9 00         LDA.B #$00                
CODE_028F83:        99 20 04      STA.W $0420,Y             
Return028F86:       60            RTS                       ; Return 

CODE_028F87:        9E F0 17      STZ.W $17F0,X             
Return028F8A:       60            RTS                       ; Return 

CODE_028F8B:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_028F8D:        D0 3B         BNE CODE_028FCA           ; / 
CODE_028F8F:        A5 13         LDA RAM_FrameCounter      
CODE_028F91:        29 03         AND.B #$03                
CODE_028F93:        F0 16         BEQ CODE_028FAB           
CODE_028F95:        A0 00         LDY.B #$00                
CODE_028F97:        BD 2C 18      LDA.W $182C,X             
CODE_028F9A:        10 01         BPL CODE_028F9D           
CODE_028F9C:        88            DEY                       
CODE_028F9D:        18            CLC                       
CODE_028F9E:        7D 08 18      ADC.W $1808,X             
CODE_028FA1:        9D 08 18      STA.W $1808,X             
CODE_028FA4:        98            TYA                       
CODE_028FA5:        7D EA 18      ADC.W $18EA,X             
CODE_028FA8:        9D EA 18      STA.W $18EA,X             
CODE_028FAB:        A0 00         LDY.B #$00                
CODE_028FAD:        BD 20 18      LDA.W $1820,X             
CODE_028FB0:        10 01         BPL CODE_028FB3           
CODE_028FB2:        88            DEY                       
CODE_028FB3:        18            CLC                       
CODE_028FB4:        7D FC 17      ADC.W $17FC,X             
CODE_028FB7:        9D FC 17      STA.W $17FC,X             
CODE_028FBA:        98            TYA                       
CODE_028FBB:        7D 14 18      ADC.W $1814,X             
CODE_028FBE:        9D 14 18      STA.W $1814,X             
CODE_028FC1:        A5 13         LDA RAM_FrameCounter      
CODE_028FC3:        29 03         AND.B #$03                
CODE_028FC5:        D0 03         BNE CODE_028FCA           
CODE_028FC7:        FE 20 18      INC.W $1820,X             
CODE_028FCA:        BD FC 17      LDA.W $17FC,X             
CODE_028FCD:        38            SEC                       
CODE_028FCE:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_028FD0:        85 00         STA $00                   
CODE_028FD2:        BD 14 18      LDA.W $1814,X             
CODE_028FD5:        E5 1D         SBC RAM_ScreenBndryYHi    
CODE_028FD7:        F0 04         BEQ CODE_028FDD           
CODE_028FD9:        10 AC         BPL CODE_028F87           
CODE_028FDB:        30 4F         BMI Return02902C          
CODE_028FDD:        BC 78 8B      LDY.W BrokenBlock,X       
CODE_028FE0:        BD 08 18      LDA.W $1808,X             
CODE_028FE3:        38            SEC                       
CODE_028FE4:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_028FE6:        85 01         STA $01                   
CODE_028FE8:        BD EA 18      LDA.W $18EA,X             
CODE_028FEB:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_028FED:        D0 98         BNE CODE_028F87           
CODE_028FEF:        A5 01         LDA $01                   
CODE_028FF1:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_028FF4:        A5 00         LDA $00                   
CODE_028FF6:        C9 F0         CMP.B #$F0                
CODE_028FF8:        B0 8D         BCS CODE_028F87           
CODE_028FFA:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_028FFD:        BD 50 18      LDA.W $1850,X             
CODE_029000:        48            PHA                       
CODE_029001:        A5 14         LDA RAM_FrameCounterB     
CODE_029003:        4A            LSR                       
CODE_029004:        18            CLC                       
CODE_029005:        6D 98 16      ADC.W $1698               
CODE_029008:        29 07         AND.B #$07                
CODE_02900A:        AA            TAX                       
CODE_02900B:        BD 84 8B      LDA.W BrokenBlock2,X      
CODE_02900E:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029011:        68            PLA                       
CODE_029012:        F0 04         BEQ CODE_029018           
CODE_029014:        A5 13         LDA RAM_FrameCounter      
CODE_029016:        29 0E         AND.B #$0E                
CODE_029018:        5D 8C 8B      EOR.W DATA_028B8C,X       
CODE_02901B:        05 64         ORA $64                   
CODE_02901D:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_029020:        AE 98 16      LDX.W $1698               
CODE_029023:        98            TYA                       
CODE_029024:        4A            LSR                       
CODE_029025:        4A            LSR                       
CODE_029026:        A8            TAY                       
CODE_029027:        A9 00         LDA.B #$00                
CODE_029029:        99 20 04      STA.W $0420,Y             
Return02902C:       60            RTS                       ; Return 

CODE_02902D:        AD 6B 18      LDA.W $186B               
CODE_029030:        C9 02         CMP.B #$02                
CODE_029032:        90 07         BCC CODE_02903B           
CODE_029034:        A5 9D         LDA RAM_SpritesLocked     
CODE_029036:        D0 03         BNE CODE_02903B           
CODE_029038:        CE 6B 18      DEC.W $186B               
CODE_02903B:        A2 03         LDX.B #$03                
CODE_02903D:        8E 98 16      STX.W $1698               
CODE_029040:        20 4D 90      JSR.W CODE_02904D         
CODE_029043:        20 98 93      JSR.W CODE_029398         
CODE_029046:        20 C0 96      JSR.W CODE_0296C0         
CODE_029049:        CA            DEX                       
CODE_02904A:        10 F1         BPL CODE_02903D           
Return02904C:       60            RTS                       ; Return 

CODE_02904D:        BD 99 16      LDA.W RAM_BounceSprNum,X  
CODE_029050:        F0 FA         BEQ Return02904C          
CODE_029052:        A4 9D         LDY RAM_SpritesLocked     
CODE_029054:        D0 08         BNE CODE_02905E           
CODE_029056:        BC C5 16      LDY.W RAM_BounceSprTimer,X ; \ Decrement bounce sprite timer if > 0 
CODE_029059:        F0 03         BEQ CODE_02905E           
CODE_02905B:        DE C5 16      DEC.W RAM_BounceSprTimer,X 
CODE_02905E:        22 DF 86 00   JSL.L ExecutePtr          

BounceSpritePtrs:      4C 90      .dw Return02904C          ; 00 - Nothing (Bypassed above) 
                       DE 90      .dw BounceBlockSpr        ; 01 - Turn Block without turn 
                       DE 90      .dw BounceBlockSpr        ; 02 - Music Block 
                       DE 90      .dw BounceBlockSpr        ; 03 - Question Block 
                       DE 90      .dw BounceBlockSpr        ; 04 - Sideways Bounce Block 
                       DE 90      .dw BounceBlockSpr        ; 05 - Translucent Block 
                       DE 90      .dw BounceBlockSpr        ; 06 - On/Off Block 
                       76 90      .dw TurnBlockSpr          ; 07 - Turn Block 

DATA_029072:                      .db $13,$00,$00,$ED

TurnBlockSpr:       A5 9D         LDA RAM_SpritesLocked     ; \ Return if sprites locked 
CODE_029078:        D0 53         BNE Return0290CD          ; / 
CODE_02907A:        BD 9D 16      LDA.W RAM_BounceSprInit,X ; \ Initialize only once 
CODE_02907D:        D0 06         BNE CODE_029085           ;  | (Generate invisible tile sprite) 
CODE_02907F:        FE 9D 16      INC.W RAM_BounceSprInit,X ;  | 
CODE_029082:        20 B8 91      JSR.W InvisSldFromBncSpr  ; / 
CODE_029085:        BD C5 16      LDA.W RAM_BounceSprTimer,X 
CODE_029088:        F0 31         BEQ CODE_0290BB           
CODE_02908A:        C9 01         CMP.B #$01                
CODE_02908C:        D0 1A         BNE CODE_0290A8           
CODE_02908E:        BD A1 16      LDA.W RAM_BounceSprXLo,X  
CODE_029091:        18            CLC                       
CODE_029092:        69 08         ADC.B #$08                
CODE_029094:        29 F0         AND.B #$F0                
CODE_029096:        9D A1 16      STA.W RAM_BounceSprXLo,X  
CODE_029099:        BD A9 16      LDA.W RAM_BounceSprXHi,X  
CODE_02909C:        69 00         ADC.B #$00                
CODE_02909E:        9D A9 16      STA.W RAM_BounceSprXHi,X  
CODE_0290A1:        A9 05         LDA.B #$05                
CODE_0290A3:        20 BA 91      JSR.W TileFromBounceSpr1  
CODE_0290A6:        80 13         BRA CODE_0290BB           

CODE_0290A8:        20 26 B5      JSR.W CODE_02B526         
CODE_0290AB:        BC C9 16      LDY.W $16C9,X             
CODE_0290AE:        BD B1 16      LDA.W RAM_BouncBlkSpeedX,X 
CODE_0290B1:        18            CLC                       
CODE_0290B2:        79 72 90      ADC.W DATA_029072,Y       
CODE_0290B5:        9D B1 16      STA.W RAM_BouncBlkSpeedX,X 
CODE_0290B8:        20 F8 91      JSR.W BounceSprGfx        
CODE_0290BB:        BD CE 18      LDA.W $18CE,X             
CODE_0290BE:        F0 04         BEQ CODE_0290C4           
CODE_0290C0:        DE CE 18      DEC.W $18CE,X             
Return0290C3:       60            RTS                       ; Return 

CODE_0290C4:        BD C1 16      LDA.W RAM_BounceSprBlock,X 
CODE_0290C7:        20 BA 91      JSR.W TileFromBounceSpr1  
CODE_0290CA:        9E 99 16      STZ.W RAM_BounceSprNum,X  
Return0290CD:       60            RTS                       ; Return 


DATA_0290CE:                      .db $10,$00,$00,$F0

DATA_0290D2:                      .db $00,$F0,$10,$00

DATA_0290D6:                      .db $80,$80,$80,$00

DATA_0290DA:                      .db $80,$E0,$20,$80

BounceBlockSpr:     20 F8 91      JSR.W BounceSprGfx        
CODE_0290E1:        A5 9D         LDA RAM_SpritesLocked     
CODE_0290E3:        D0 E8         BNE Return0290CD          
CODE_0290E5:        BD 9D 16      LDA.W RAM_BounceSprInit,X 
CODE_0290E8:        D0 21         BNE CODE_02910B           
CODE_0290EA:        FE 9D 16      INC.W RAM_BounceSprInit,X 
CODE_0290ED:        20 65 92      JSR.W CODE_029265         
CODE_0290F0:        20 B8 91      JSR.W InvisSldFromBncSpr  
CODE_0290F3:        BD C9 16      LDA.W $16C9,X             
CODE_0290F6:        29 03         AND.B #$03                
CODE_0290F8:        A8            TAY                       
CODE_0290F9:        B9 D6 90      LDA.W DATA_0290D6,Y       
CODE_0290FC:        C9 80         CMP.B #$80                
CODE_0290FE:        F0 02         BEQ CODE_029102           
CODE_029100:        85 7D         STA RAM_MarioSpeedY       
CODE_029102:        B9 DA 90      LDA.W DATA_0290DA,Y       
CODE_029105:        C9 80         CMP.B #$80                
CODE_029107:        F0 02         BEQ CODE_02910B           
ADDR_029109:        85 7B         STA RAM_MarioSpeedX       
CODE_02910B:        20 26 B5      JSR.W CODE_02B526         
CODE_02910E:        20 1A B5      JSR.W CODE_02B51A         
CODE_029111:        BD C9 16      LDA.W $16C9,X             
CODE_029114:        29 03         AND.B #$03                
CODE_029116:        A8            TAY                       
CODE_029117:        BD B1 16      LDA.W RAM_BouncBlkSpeedX,X 
CODE_02911A:        18            CLC                       
CODE_02911B:        79 CE 90      ADC.W DATA_0290CE,Y       
CODE_02911E:        9D B1 16      STA.W RAM_BouncBlkSpeedX,X 
CODE_029121:        BD B5 16      LDA.W RAM_BouncBlkSpeedY,X 
CODE_029124:        18            CLC                       
CODE_029125:        79 D2 90      ADC.W DATA_0290D2,Y       
CODE_029128:        9D B5 16      STA.W RAM_BouncBlkSpeedY,X 
CODE_02912B:        BD C9 16      LDA.W $16C9,X             
CODE_02912E:        29 03         AND.B #$03                
CODE_029130:        C9 03         CMP.B #$03                
CODE_029132:        D0 2A         BNE CODE_02915E           
CODE_029134:        A5 71         LDA RAM_MarioAnimation    
CODE_029136:        C9 01         CMP.B #$01                
CODE_029138:        B0 24         BCS CODE_02915E           
CODE_02913A:        A9 20         LDA.B #$20                
CODE_02913C:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_02913F:        F0 02         BEQ CODE_029143           
CODE_029141:        A9 30         LDA.B #$30                
CODE_029143:        85 00         STA $00                   
CODE_029145:        BD A1 16      LDA.W RAM_BounceSprXLo,X  
CODE_029148:        38            SEC                       
CODE_029149:        E5 00         SBC $00                   
CODE_02914B:        85 96         STA RAM_MarioYPos         
CODE_02914D:        BD A9 16      LDA.W RAM_BounceSprXHi,X  
CODE_029150:        E9 00         SBC.B #$00                
CODE_029152:        85 97         STA RAM_MarioYPosHi       
CODE_029154:        A9 01         LDA.B #$01                
CODE_029156:        8D 71 14      STA.W $1471               
CODE_029159:        8D 02 14      STA.W $1402               
CODE_02915C:        64 7D         STZ RAM_MarioSpeedY       
CODE_02915E:        BD C5 16      LDA.W RAM_BounceSprTimer,X 
CODE_029161:        D0 39         BNE Return02919C          
CODE_029163:        BD C9 16      LDA.W $16C9,X             
CODE_029166:        29 03         AND.B #$03                
CODE_029168:        C9 03         CMP.B #$03                
CODE_02916A:        D0 16         BNE CODE_029182           
CODE_02916C:        A9 A0         LDA.B #$A0                
CODE_02916E:        85 7D         STA RAM_MarioSpeedY       
CODE_029170:        A5 96         LDA RAM_MarioYPos         
CODE_029172:        38            SEC                       
CODE_029173:        E9 02         SBC.B #$02                
CODE_029175:        85 96         STA RAM_MarioYPos         
CODE_029177:        A5 97         LDA RAM_MarioYPosHi       
CODE_029179:        E9 00         SBC.B #$00                
CODE_02917B:        85 97         STA RAM_MarioYPosHi       
CODE_02917D:        A9 08         LDA.B #$08                ; \ Play sound effect 
CODE_02917F:        8D FC 1D      STA.W $1DFC               ; / 
CODE_029182:        20 9F 91      JSR.W TileFromBounceSpr0  
CODE_029185:        BC 99 16      LDY.W RAM_BounceSprNum,X  
CODE_029188:        C0 06         CPY.B #$06                
CODE_02918A:        90 0D         BCC CODE_029199           
CODE_02918C:        A9 0B         LDA.B #$0B                ; \ Play sound effect 
CODE_02918E:        8D F9 1D      STA.W $1DF9               ; / 
CODE_029191:        AD AF 14      LDA.W RAM_OnOffStatus     ; \ Toggle On/Off 
CODE_029194:        49 01         EOR.B #$01                ;  | 
CODE_029196:        8D AF 14      STA.W RAM_OnOffStatus     ; / 
CODE_029199:        9E 99 16      STZ.W RAM_BounceSprNum,X  
Return02919C:       60            RTS                       ; Return 


DATA_02919D:                      .db $01,$00

TileFromBounceSpr0: BD C1 16      LDA.W RAM_BounceSprBlock,X ; \ If doesn't turn into multiple coin block, 
CODE_0291A2:        C9 0A         CMP.B #$0A                ;  | 
CODE_0291A4:        F0 04         BEQ CODE_0291AA           ;  | 
CODE_0291A6:        C9 0B         CMP.B #$0B                ;  | 
CODE_0291A8:        D0 0C         BNE CODE_0291B6           ; / Block to generate = Bounce sprite block to turn into 
CODE_0291AA:        AC 6B 18      LDY.W $186B               
CODE_0291AD:        C0 01         CPY.B #$01                
CODE_0291AF:        D0 05         BNE CODE_0291B6           
CODE_0291B1:        9C 6B 18      STZ.W $186B               
CODE_0291B4:        A9 0D         LDA.B #$0D                ; Block to generate = Used block 
CODE_0291B6:        80 02         BRA TileFromBounceSpr1    

InvisSldFromBncSpr: A9 09         LDA.B #$09                ; Block to generate = Invisible solid 
TileFromBounceSpr1: 85 9C         STA RAM_BlockBlock        ; Set block to generate 
CODE_0291BC:        BD A5 16      LDA.W RAM_BounceSprYLo,X  ; \ Block Y position = Bounce sprite Y position 
CODE_0291BF:        18            CLC                       ;  | 
CODE_0291C0:        69 08         ADC.B #$08                ;  | (Rounded to nearest #$10) 
CODE_0291C2:        29 F0         AND.B #$F0                ;  | 
CODE_0291C4:        85 9A         STA RAM_BlockYLo          ;  | 
CODE_0291C6:        BD AD 16      LDA.W RAM_BounceSprYHi,X  ;  | 
CODE_0291C9:        69 00         ADC.B #$00                ;  | 
CODE_0291CB:        85 9B         STA RAM_BlockYHi          ; / 
CODE_0291CD:        BD A1 16      LDA.W RAM_BounceSprXLo,X  ; \ Block X position = Bounce sprite X position 
CODE_0291D0:        18            CLC                       ;  | 
CODE_0291D1:        69 08         ADC.B #$08                ;  | (Rounded to nearest #$10) 
CODE_0291D3:        29 F0         AND.B #$F0                ;  | 
CODE_0291D5:        85 98         STA RAM_BlockXLo          ;  | 
CODE_0291D7:        BD A9 16      LDA.W RAM_BounceSprXHi,X  ;  | 
CODE_0291DA:        69 00         ADC.B #$00                ;  | 
CODE_0291DC:        85 99         STA RAM_BlockXHi          ; / 
CODE_0291DE:        BD C9 16      LDA.W $16C9,X             
CODE_0291E1:        0A            ASL                       
CODE_0291E2:        2A            ROL                       
CODE_0291E3:        29 01         AND.B #$01                
CODE_0291E5:        8D 33 19      STA.W $1933               
CODE_0291E8:        22 B0 BE 00   JSL.L GenerateTile        
Return0291EC:       60            RTS                       ; Return 


DATA_0291ED:                      .db $10,$14,$18

BounceSpriteTiles:                .db $1C,$40,$6B,$2A,$42,$EA,$8A,$40

BounceSprGfx:       A0 00         LDY.B #$00                
CODE_0291FA:        BD C9 16      LDA.W $16C9,X             
CODE_0291FD:        10 02         BPL CODE_029201           
ADDR_0291FF:        A0 04         LDY.B #$04                
CODE_029201:        B9 1C 00      LDA.W RAM_ScreenBndryYLo,Y 
CODE_029204:        85 02         STA $02                   
CODE_029206:        B9 1A 00      LDA.W RAM_ScreenBndryXLo,Y 
CODE_029209:        85 03         STA $03                   
CODE_02920B:        B9 1D 00      LDA.W RAM_ScreenBndryYHi,Y 
CODE_02920E:        85 04         STA $04                   
CODE_029210:        B9 1B 00      LDA.W RAM_ScreenBndryXHi,Y 
CODE_029213:        85 05         STA $05                   
CODE_029215:        BD A1 16      LDA.W RAM_BounceSprXLo,X  
CODE_029218:        C5 02         CMP $02                   
CODE_02921A:        BD A9 16      LDA.W RAM_BounceSprXHi,X  
CODE_02921D:        E5 04         SBC $04                   
CODE_02921F:        D0 CB         BNE Return0291EC          
CODE_029221:        BD A5 16      LDA.W RAM_BounceSprYLo,X  
CODE_029224:        C5 03         CMP $03                   
CODE_029226:        BD AD 16      LDA.W RAM_BounceSprYHi,X  
CODE_029229:        E5 05         SBC $05                   
CODE_02922B:        D0 BF         BNE Return0291EC          
CODE_02922D:        BC ED 91      LDY.W DATA_0291ED,X       
CODE_029230:        BD A1 16      LDA.W RAM_BounceSprXLo,X  
CODE_029233:        38            SEC                       
CODE_029234:        E5 02         SBC $02                   
CODE_029236:        85 01         STA $01                   
CODE_029238:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_02923B:        BD A5 16      LDA.W RAM_BounceSprYLo,X  
CODE_02923E:        38            SEC                       
CODE_02923F:        E5 03         SBC $03                   
CODE_029241:        85 00         STA $00                   
CODE_029243:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_029246:        BD 01 19      LDA.W $1901,X             
CODE_029249:        05 64         ORA $64                   
CODE_02924B:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02924E:        BD 99 16      LDA.W RAM_BounceSprNum,X  
CODE_029251:        AA            TAX                       
CODE_029252:        BD F0 91      LDA.W BounceSpriteTiles,X 
CODE_029255:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029258:        98            TYA                       
CODE_029259:        4A            LSR                       
CODE_02925A:        4A            LSR                       
CODE_02925B:        A8            TAY                       
CODE_02925C:        A9 02         LDA.B #$02                
CODE_02925E:        99 20 04      STA.W $0420,Y             
CODE_029261:        AE 98 16      LDX.W $1698               
Return029264:       60            RTS                       ; Return 

CODE_029265:        A9 01         LDA.B #$01                
CODE_029267:        BC C9 16      LDY.W $16C9,X             
CODE_02926A:        84 0F         STY $0F                   
CODE_02926C:        10 01         BPL CODE_02926F           
ADDR_02926E:        0A            ASL                       
CODE_02926F:        25 5B         AND RAM_IsVerticalLvl     
CODE_029271:        F0 57         BEQ CODE_0292CA           
CODE_029273:        BD A1 16      LDA.W RAM_BounceSprXLo,X  
CODE_029276:        38            SEC                       
CODE_029277:        E9 03         SBC.B #$03                
CODE_029279:        29 F0         AND.B #$F0                
CODE_02927B:        85 00         STA $00                   
CODE_02927D:        BD A9 16      LDA.W RAM_BounceSprXHi,X  
CODE_029280:        E9 00         SBC.B #$00                
CODE_029282:        C5 5D         CMP RAM_ScreensInLvl      
CODE_029284:        B0 43         BCS Return0292C9          
CODE_029286:        85 03         STA $03                   
CODE_029288:        29 10         AND.B #$10                
CODE_02928A:        85 08         STA $08                   
CODE_02928C:        BD A5 16      LDA.W RAM_BounceSprYLo,X  
CODE_02928F:        85 01         STA $01                   
CODE_029291:        BD AD 16      LDA.W RAM_BounceSprYHi,X  
CODE_029294:        C9 02         CMP.B #$02                
CODE_029296:        B0 31         BCS Return0292C9          
CODE_029298:        85 02         STA $02                   
CODE_02929A:        A5 01         LDA $01                   
CODE_02929C:        4A            LSR                       
CODE_02929D:        4A            LSR                       
CODE_02929E:        4A            LSR                       
CODE_02929F:        4A            LSR                       
CODE_0292A0:        05 00         ORA $00                   
CODE_0292A2:        85 00         STA $00                   
CODE_0292A4:        A6 03         LDX $03                   
CODE_0292A6:        BF 80 BA 00   LDA.L DATA_00BA80,X       
CODE_0292AA:        A4 0F         LDY $0F                   
CODE_0292AC:        F0 04         BEQ CODE_0292B2           
CODE_0292AE:        BF 8E BA 00   LDA.L DATA_00BA8E,X       
CODE_0292B2:        18            CLC                       
CODE_0292B3:        65 00         ADC $00                   
CODE_0292B5:        85 05         STA $05                   
CODE_0292B7:        BF BC BA 00   LDA.L DATA_00BABC,X       
CODE_0292BB:        A4 0F         LDY $0F                   
CODE_0292BD:        F0 04         BEQ CODE_0292C3           
CODE_0292BF:        BF CA BA 00   LDA.L DATA_00BACA,X       
CODE_0292C3:        65 02         ADC $02                   
CODE_0292C5:        85 06         STA $06                   
CODE_0292C7:        80 51         BRA CODE_02931A           

Return0292C9:       60            RTS                       ; Return 

CODE_0292CA:        BD A1 16      LDA.W RAM_BounceSprXLo,X  
CODE_0292CD:        38            SEC                       
CODE_0292CE:        E9 03         SBC.B #$03                
CODE_0292D0:        29 F0         AND.B #$F0                
CODE_0292D2:        85 00         STA $00                   
CODE_0292D4:        BD A9 16      LDA.W RAM_BounceSprXHi,X  
CODE_0292D7:        E9 00         SBC.B #$00                
CODE_0292D9:        C9 02         CMP.B #$02                
CODE_0292DB:        B0 EC         BCS Return0292C9          
CODE_0292DD:        85 02         STA $02                   
CODE_0292DF:        BD A5 16      LDA.W RAM_BounceSprYLo,X  
CODE_0292E2:        85 01         STA $01                   
CODE_0292E4:        BD AD 16      LDA.W RAM_BounceSprYHi,X  
CODE_0292E7:        C5 5D         CMP RAM_ScreensInLvl      
CODE_0292E9:        B0 DE         BCS Return0292C9          
CODE_0292EB:        85 03         STA $03                   
CODE_0292ED:        A5 01         LDA $01                   
CODE_0292EF:        4A            LSR                       
CODE_0292F0:        4A            LSR                       
CODE_0292F1:        4A            LSR                       
CODE_0292F2:        4A            LSR                       
CODE_0292F3:        05 00         ORA $00                   
CODE_0292F5:        85 00         STA $00                   
CODE_0292F7:        A6 03         LDX $03                   
CODE_0292F9:        BF 60 BA 00   LDA.L DATA_00BA60,X       
CODE_0292FD:        A4 0F         LDY $0F                   
CODE_0292FF:        F0 04         BEQ CODE_029305           
CODE_029301:        BF 70 BA 00   LDA.L DATA_00BA70,X       
CODE_029305:        18            CLC                       
CODE_029306:        65 00         ADC $00                   
CODE_029308:        85 05         STA $05                   
CODE_02930A:        BF 9C BA 00   LDA.L DATA_00BA9C,X       
CODE_02930E:        A4 0F         LDY $0F                   
CODE_029310:        F0 04         BEQ CODE_029316           
CODE_029312:        BF AC BA 00   LDA.L DATA_00BAAC,X       
CODE_029316:        65 02         ADC $02                   
CODE_029318:        85 06         STA $06                   
CODE_02931A:        A9 7E         LDA.B #$7E                
CODE_02931C:        85 07         STA $07                   
CODE_02931E:        AE 98 16      LDX.W $1698               
CODE_029321:        A7 05         LDA [$05]                 
CODE_029323:        8D 93 16      STA.W $1693               
CODE_029326:        E6 07         INC $07                   
CODE_029328:        A7 05         LDA [$05]                 
CODE_02932A:        D0 29         BNE Return029355          
CODE_02932C:        AD 93 16      LDA.W $1693               
CODE_02932F:        C9 2B         CMP.B #$2B                
CODE_029331:        D0 22         BNE Return029355          
ADDR_029333:        BD A1 16      LDA.W RAM_BounceSprXLo,X  
ADDR_029336:        48            PHA                       
ADDR_029337:        E9 03         SBC.B #$03                
ADDR_029339:        29 F0         AND.B #$F0                
ADDR_02933B:        9D A1 16      STA.W RAM_BounceSprXLo,X  
ADDR_02933E:        BD A9 16      LDA.W RAM_BounceSprXHi,X  
ADDR_029341:        48            PHA                       
ADDR_029342:        E9 00         SBC.B #$00                
ADDR_029344:        9D A9 16      STA.W RAM_BounceSprXHi,X  
ADDR_029347:        20 B8 91      JSR.W InvisSldFromBncSpr  
ADDR_02934A:        20 56 93      JSR.W ADDR_029356         
ADDR_02934D:        68            PLA                       
ADDR_02934E:        9D A9 16      STA.W RAM_BounceSprXHi,X  
ADDR_029351:        68            PLA                       
ADDR_029352:        9D A1 16      STA.W RAM_BounceSprXLo,X  
Return029355:       60            RTS                       ; Return 

ADDR_029356:        A0 03         LDY.B #$03                
ADDR_029358:        B9 D0 17      LDA.W $17D0,Y             
ADDR_02935B:        F0 04         BEQ ADDR_029361           
ADDR_02935D:        88            DEY                       
ADDR_02935E:        10 F8         BPL ADDR_029358           
ADDR_029360:        C8            INY                       
ADDR_029361:        A9 01         LDA.B #$01                
ADDR_029363:        99 D0 17      STA.W $17D0,Y             
ADDR_029366:        22 4A B3 05   JSL.L CODE_05B34A         
ADDR_02936A:        BD A5 16      LDA.W RAM_BounceSprYLo,X  
ADDR_02936D:        99 E0 17      STA.W $17E0,Y             
ADDR_029370:        BD AD 16      LDA.W RAM_BounceSprYHi,X  
ADDR_029373:        99 EC 17      STA.W $17EC,Y             
ADDR_029376:        BD A1 16      LDA.W RAM_BounceSprXLo,X  
ADDR_029379:        99 D4 17      STA.W $17D4,Y             
ADDR_02937C:        BD A9 16      LDA.W RAM_BounceSprXHi,X  
ADDR_02937F:        99 E8 17      STA.W $17E8,Y             
ADDR_029382:        BD C9 16      LDA.W $16C9,X             
ADDR_029385:        0A            ASL                       
ADDR_029386:        2A            ROL                       
ADDR_029387:        29 01         AND.B #$01                
ADDR_029389:        99 E4 17      STA.W $17E4,Y             
ADDR_02938C:        A9 D0         LDA.B #$D0                
ADDR_02938E:        99 D8 17      STA.W $17D8,Y             
Return029391:       60            RTS                       ; Return 


DATA_029392:                      .db $F8,$08

CODE_029394:        9E CD 16      STZ.W RAM_BouncBlkStatus,X 
Return029397:       60            RTS                       ; Return 

CODE_029398:        BD CD 16      LDA.W RAM_BouncBlkStatus,X 
CODE_02939B:        F0 FA         BEQ Return029397          
CODE_02939D:        DE F8 18      DEC.W $18F8,X             
CODE_0293A0:        F0 F2         BEQ CODE_029394           
CODE_0293A2:        BD F8 18      LDA.W $18F8,X             
CODE_0293A5:        C9 03         CMP.B #$03                
CODE_0293A7:        B0 E8         BCS Return029391          
CODE_0293A9:        AC 98 16      LDY.W $1698               
CODE_0293AC:        64 0E         STZ $0E                   
CODE_0293AE:        A2 0B         LDX.B #$0B                
CODE_0293B0:        8E E9 15      STX.W $15E9               
CODE_0293B3:        BD C8 14      LDA.W $14C8,X             
CODE_0293B6:        C9 0B         CMP.B #$0B                
CODE_0293B8:        F0 3D         BEQ CODE_0293F7           
CODE_0293BA:        C9 08         CMP.B #$08                
CODE_0293BC:        90 39         BCC CODE_0293F7           
CODE_0293BE:        BD 6E 16      LDA.W RAM_Tweaker166E,X   
CODE_0293C1:        29 20         AND.B #$20                
CODE_0293C3:        1D D0 15      ORA.W $15D0,X             
CODE_0293C6:        1D 4C 15      ORA.W RAM_DisableInter,X  
CODE_0293C9:        1D E2 1F      ORA.W $1FE2,X             
CODE_0293CC:        D0 29         BNE CODE_0293F7           
CODE_0293CE:        BD 32 16      LDA.W RAM_SprBehindScrn,X 
CODE_0293D1:        5A            PHY                       
CODE_0293D2:        A4 74         LDY RAM_IsClimbing        
CODE_0293D4:        F0 02         BEQ CODE_0293D8           
CODE_0293D6:        49 01         EOR.B #$01                
CODE_0293D8:        7A            PLY                       
CODE_0293D9:        4D F9 13      EOR.W RAM_IsBehindScenery 
CODE_0293DC:        D0 19         BNE CODE_0293F7           
CODE_0293DE:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_0293E2:        A5 0E         LDA $0E                   
CODE_0293E4:        F0 05         BEQ CODE_0293EB           
CODE_0293E6:        20 96 96      JSR.W CODE_029696         
CODE_0293E9:        80 03         BRA CODE_0293EE           

CODE_0293EB:        20 63 96      JSR.W CODE_029663         
CODE_0293EE:        22 2B B7 03   JSL.L CheckForContact     
CODE_0293F2:        90 03         BCC CODE_0293F7           
CODE_0293F4:        20 04 94      JSR.W CODE_029404         
CODE_0293F7:        AC 98 16      LDY.W $1698               
CODE_0293FA:        CA            DEX                       
CODE_0293FB:        30 03         BMI CODE_029400           
CODE_0293FD:        4C B0 93      JMP.W CODE_0293B0         

CODE_029400:        AE 98 16      LDX.W $1698               
Return029403:       60            RTS                       ; Return 

CODE_029404:        A9 08         LDA.B #$08                
CODE_029406:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_029409:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02940B:        C9 81         CMP.B #$81                
CODE_02940D:        D0 18         BNE CODE_029427           
CODE_02940F:        B5 C2         LDA RAM_SpriteState,X     
CODE_029411:        F0 13         BEQ Return029426          
CODE_029413:        74 C2         STZ RAM_SpriteState,X     
CODE_029415:        A9 C0         LDA.B #$C0                
CODE_029417:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_029419:        A9 10         LDA.B #$10                
CODE_02941B:        9D 40 15      STA.W $1540,X             
CODE_02941E:        9E 7C 15      STZ.W RAM_SpriteDir,X     
CODE_029421:        A9 20         LDA.B #$20                
CODE_029423:        9D 58 15      STA.W $1558,X             
Return029426:       60            RTS                       ; Return 

CODE_029427:        C9 2D         CMP.B #$2D                
CODE_029429:        F0 1D         BEQ CODE_029448           
CODE_02942B:        BD 7A 16      LDA.W RAM_Tweaker167A,X   
CODE_02942E:        29 02         AND.B #$02                
CODE_029430:        D0 70         BNE CODE_0294A2           
CODE_029432:        BD C8 14      LDA.W $14C8,X             
CODE_029435:        C9 08         CMP.B #$08                
CODE_029437:        F0 0A         BEQ CODE_029443           
CODE_029439:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02943B:        C9 0D         CMP.B #$0D                
CODE_02943D:        F0 09         BEQ CODE_029448           
CODE_02943F:        B5 C2         LDA RAM_SpriteState,X     
CODE_029441:        F0 05         BEQ CODE_029448           
CODE_029443:        A9 FF         LDA.B #$FF                
CODE_029445:        9D 40 15      STA.W $1540,X             
CODE_029448:        9E 58 15      STZ.W $1558,X             
CODE_02944B:        A5 0E         LDA $0E                   
CODE_02944D:        C9 35         CMP.B #$35                
CODE_02944F:        F0 04         BEQ CODE_029455           
CODE_029451:        22 6F AB 01   JSL.L CODE_01AB6F         
CODE_029455:        A9 00         LDA.B #$00                
CODE_029457:        22 E5 AC 02   JSL.L GivePoints          
CODE_02945B:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_02945D:        9D C8 14      STA.W $14C8,X             ; / 
CODE_029460:        B5 9E         LDA RAM_SpriteNum,X       
CODE_029462:        C9 1E         CMP.B #$1E                
CODE_029464:        D0 05         BNE CODE_02946B           
ADDR_029466:        A9 1F         LDA.B #$1F                
ADDR_029468:        8D 49 15      STA.W $1549               
CODE_02946B:        BD 62 16      LDA.W RAM_Tweaker1662,X   
CODE_02946E:        29 80         AND.B #$80                
CODE_029470:        D0 30         BNE CODE_0294A2           
CODE_029472:        BD 56 16      LDA.W RAM_Tweaker1656,X   ; \ Branch if can't be jumped on 
CODE_029475:        29 10         AND.B #$10                ;  | 
CODE_029477:        F0 29         BEQ CODE_0294A2           ; / 
CODE_029479:        BD 56 16      LDA.W RAM_Tweaker1656,X   ; \ Branch if dies when jumped on 
CODE_02947C:        29 20         AND.B #$20                ;  | 
CODE_02947E:        D0 22         BNE CODE_0294A2           ; / 
CODE_029480:        A9 09         LDA.B #$09                ; \ Sprite status = Carryable 
CODE_029482:        9D C8 14      STA.W $14C8,X             ; / 
CODE_029485:        1E F6 15      ASL.W RAM_SpritePal,X     
CODE_029488:        38            SEC                       
CODE_029489:        7E F6 15      ROR.W RAM_SpritePal,X     
CODE_02948C:        BD 86 16      LDA.W RAM_Tweaker1686,X   
CODE_02948F:        29 40         AND.B #$40                
CODE_029491:        F0 0F         BEQ CODE_0294A2           
CODE_029493:        DA            PHX                       
CODE_029494:        B5 9E         LDA RAM_SpriteNum,X       
CODE_029496:        AA            TAX                       
CODE_029497:        BF C9 A7 01   LDA.L SpriteToSpawn,X     
CODE_02949B:        FA            PLX                       
CODE_02949C:        95 9E         STA RAM_SpriteNum,X       
CODE_02949E:        22 8B F7 07   JSL.L LoadSpriteTables    
CODE_0294A2:        A9 C0         LDA.B #$C0                
CODE_0294A4:        A4 0E         LDY $0E                   
CODE_0294A6:        F0 08         BEQ CODE_0294B0           
CODE_0294A8:        A9 B0         LDA.B #$B0                
CODE_0294AA:        C0 02         CPY.B #$02                
CODE_0294AC:        D0 02         BNE CODE_0294B0           
ADDR_0294AE:        A9 C0         LDA.B #$C0                
CODE_0294B0:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_0294B2:        20 8D 84      JSR.W SubHorzPosBnk2      
CODE_0294B5:        B9 92 93      LDA.W DATA_029392,Y       
CODE_0294B8:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_0294BA:        98            TYA                       
CODE_0294BB:        49 01         EOR.B #$01                
CODE_0294BD:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return0294C0:       60            RTS                       ; Return 

GroundPound:        A9 30         LDA.B #$30                ; \ Set ground shake timer 
CODE_0294C3:        8D 87 18      STA.W RAM_ShakeGrndTimer  ; / 
CODE_0294C6:        9C A9 14      STZ.W $14A9               
CODE_0294C9:        8B            PHB                       
CODE_0294CA:        4B            PHK                       
CODE_0294CB:        AB            PLB                       
CODE_0294CC:        A2 09         LDX.B #$09                ; Loop over sprites: 
KillSprLoopStart:   BD C8 14      LDA.W $14C8,X             ; \ Skip current sprite if status < 8 
CODE_0294D1:        C9 08         CMP.B #$08                ;  | 
CODE_0294D3:        90 1B         BCC GroundPoundNextSpr    ; / 
CODE_0294D5:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Skip current sprite if not on ground 
CODE_0294D8:        29 04         AND.B #$04                ;  | 
CODE_0294DA:        F0 14         BEQ GroundPoundNextSpr    ; / 
CODE_0294DC:        BD 6E 16      LDA.W RAM_Tweaker166E,X   ; \ Skip current sprite if... 
CODE_0294DF:        29 20         AND.B #$20                ;  | ...can't be killed by cape... 
CODE_0294E1:        1D D0 15      ORA.W $15D0,X             ;  | ...or sprite being eaten... 
CODE_0294E4:        1D 4C 15      ORA.W RAM_DisableInter,X  ;  | ...or interaction disabled 
CODE_0294E7:        D0 07         BNE GroundPoundNextSpr    ; / 
CODE_0294E9:        A9 35         LDA.B #$35                
CODE_0294EB:        85 0E         STA $0E                   
CODE_0294ED:        20 04 94      JSR.W CODE_029404         
GroundPoundNextSpr: CA            DEX                       
CODE_0294F1:        10 DB         BPL KillSprLoopStart      
CODE_0294F3:        AB            PLB                       
Return0294F4:       6B            RTL                       ; Return 

CODE_0294F5:        AD E8 13      LDA.W $13E8               
CODE_0294F8:        F0 10         BEQ Return02950A          
CODE_0294FA:        85 0E         STA $0E                   
CODE_0294FC:        A5 13         LDA RAM_FrameCounter      
CODE_0294FE:        4A            LSR                       
CODE_0294FF:        90 06         BCC CODE_029507           
CODE_029501:        20 AE 93      JSR.W CODE_0293AE         
CODE_029504:        20 31 96      JSR.W CODE_029631         
CODE_029507:        20 0B 95      JSR.W CODE_02950B         
Return02950A:       60            RTS                       ; Return 

CODE_02950B:        64 0F         STZ $0F                   
CODE_02950D:        20 40 95      JSR.W CODE_029540         
CODE_029510:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_029512:        10 27         BPL Return02953B          
CODE_029514:        E6 0F         INC $0F                   
CODE_029516:        AD E9 13      LDA.W $13E9               
CODE_029519:        18            CLC                       
CODE_02951A:        65 26         ADC $26                   
CODE_02951C:        8D E9 13      STA.W $13E9               
CODE_02951F:        AD EA 13      LDA.W $13EA               
CODE_029522:        65 27         ADC $27                   
CODE_029524:        8D EA 13      STA.W $13EA               
CODE_029527:        AD EB 13      LDA.W $13EB               
CODE_02952A:        18            CLC                       
CODE_02952B:        65 28         ADC $28                   
CODE_02952D:        8D EB 13      STA.W $13EB               
CODE_029530:        AD EC 13      LDA.W $13EC               
CODE_029533:        65 29         ADC $29                   
CODE_029535:        8D EC 13      STA.W $13EC               
CODE_029538:        20 40 95      JSR.W CODE_029540         
Return02953B:       60            RTS                       ; Return 


DATA_02953C:                      .db $08,$08

DATA_02953E:                      .db $02,$0E

CODE_029540:        A5 13         LDA RAM_FrameCounter      
CODE_029542:        29 01         AND.B #$01                
CODE_029544:        A8            TAY                       
CODE_029545:        A5 0F         LDA $0F                   
CODE_029547:        1A            INC A                     
CODE_029548:        25 5B         AND RAM_IsVerticalLvl     
CODE_02954A:        F0 62         BEQ CODE_0295AE           
CODE_02954C:        AD EB 13      LDA.W $13EB               
CODE_02954F:        18            CLC                       
CODE_029550:        79 3C 95      ADC.W DATA_02953C,Y       
CODE_029553:        29 F0         AND.B #$F0                
CODE_029555:        85 00         STA $00                   
CODE_029557:        85 98         STA RAM_BlockXLo          
CODE_029559:        AD EC 13      LDA.W $13EC               
CODE_02955C:        69 00         ADC.B #$00                
CODE_02955E:        C5 5D         CMP RAM_ScreensInLvl      
CODE_029560:        B0 4B         BCS Return0295AD          
CODE_029562:        85 03         STA $03                   
CODE_029564:        85 99         STA RAM_BlockXHi          
CODE_029566:        AD E9 13      LDA.W $13E9               
CODE_029569:        18            CLC                       
CODE_02956A:        79 3E 95      ADC.W DATA_02953E,Y       
CODE_02956D:        85 01         STA $01                   
CODE_02956F:        85 9A         STA RAM_BlockYLo          
CODE_029571:        AD EA 13      LDA.W $13EA               
CODE_029574:        69 00         ADC.B #$00                
CODE_029576:        C9 02         CMP.B #$02                
CODE_029578:        B0 33         BCS Return0295AD          
CODE_02957A:        85 02         STA $02                   
CODE_02957C:        85 9B         STA RAM_BlockYHi          
CODE_02957E:        A5 01         LDA $01                   
CODE_029580:        4A            LSR                       
CODE_029581:        4A            LSR                       
CODE_029582:        4A            LSR                       
CODE_029583:        4A            LSR                       
CODE_029584:        05 00         ORA $00                   
CODE_029586:        85 00         STA $00                   
CODE_029588:        A6 03         LDX $03                   
CODE_02958A:        BF 80 BA 00   LDA.L DATA_00BA80,X       
CODE_02958E:        A4 0F         LDY $0F                   
CODE_029590:        F0 04         BEQ CODE_029596           
CODE_029592:        BF 8E BA 00   LDA.L DATA_00BA8E,X       
CODE_029596:        18            CLC                       
CODE_029597:        65 00         ADC $00                   
CODE_029599:        85 05         STA $05                   
CODE_02959B:        BF BC BA 00   LDA.L DATA_00BABC,X       
CODE_02959F:        A4 0F         LDY $0F                   
CODE_0295A1:        F0 04         BEQ CODE_0295A7           
CODE_0295A3:        BF CA BA 00   LDA.L DATA_00BACA,X       
CODE_0295A7:        65 02         ADC $02                   
CODE_0295A9:        85 06         STA $06                   
CODE_0295AB:        80 60         BRA CODE_02960D           

Return0295AD:       60            RTS                       ; Return 

CODE_0295AE:        AD EB 13      LDA.W $13EB               
CODE_0295B1:        18            CLC                       
CODE_0295B2:        79 3C 95      ADC.W DATA_02953C,Y       
CODE_0295B5:        29 F0         AND.B #$F0                
CODE_0295B7:        85 00         STA $00                   
CODE_0295B9:        85 98         STA RAM_BlockXLo          
CODE_0295BB:        AD EC 13      LDA.W $13EC               
CODE_0295BE:        69 00         ADC.B #$00                
CODE_0295C0:        C9 02         CMP.B #$02                
CODE_0295C2:        B0 E9         BCS Return0295AD          
CODE_0295C4:        85 02         STA $02                   
CODE_0295C6:        85 99         STA RAM_BlockXHi          
CODE_0295C8:        AD E9 13      LDA.W $13E9               
CODE_0295CB:        18            CLC                       
CODE_0295CC:        79 3E 95      ADC.W DATA_02953E,Y       
CODE_0295CF:        85 01         STA $01                   
CODE_0295D1:        85 9A         STA RAM_BlockYLo          
CODE_0295D3:        AD EA 13      LDA.W $13EA               
CODE_0295D6:        69 00         ADC.B #$00                
CODE_0295D8:        C5 5D         CMP RAM_ScreensInLvl      
CODE_0295DA:        B0 D1         BCS Return0295AD          
CODE_0295DC:        85 03         STA $03                   
CODE_0295DE:        85 9B         STA RAM_BlockYHi          
CODE_0295E0:        A5 01         LDA $01                   
CODE_0295E2:        4A            LSR                       
CODE_0295E3:        4A            LSR                       
CODE_0295E4:        4A            LSR                       
CODE_0295E5:        4A            LSR                       
CODE_0295E6:        05 00         ORA $00                   
CODE_0295E8:        85 00         STA $00                   
CODE_0295EA:        A6 03         LDX $03                   
CODE_0295EC:        BF 60 BA 00   LDA.L DATA_00BA60,X       
CODE_0295F0:        A4 0F         LDY $0F                   
CODE_0295F2:        F0 04         BEQ CODE_0295F8           
CODE_0295F4:        BF 70 BA 00   LDA.L DATA_00BA70,X       
CODE_0295F8:        18            CLC                       
CODE_0295F9:        65 00         ADC $00                   
CODE_0295FB:        85 05         STA $05                   
CODE_0295FD:        BF 9C BA 00   LDA.L DATA_00BA9C,X       
CODE_029601:        A4 0F         LDY $0F                   
CODE_029603:        F0 04         BEQ CODE_029609           
CODE_029605:        BF AC BA 00   LDA.L DATA_00BAAC,X       
CODE_029609:        65 02         ADC $02                   
CODE_02960B:        85 06         STA $06                   
CODE_02960D:        A9 7E         LDA.B #$7E                
CODE_02960F:        85 07         STA $07                   
CODE_029611:        A7 05         LDA [$05]                 
CODE_029613:        8D 93 16      STA.W $1693               
CODE_029616:        E6 07         INC $07                   
CODE_029618:        A7 05         LDA [$05]                 
CODE_02961A:        22 45 F5 00   JSL.L CODE_00F545         
CODE_02961E:        C9 00         CMP.B #$00                
CODE_029620:        F0 0E         BEQ Return029630          
CODE_029622:        A5 0F         LDA $0F                   
CODE_029624:        8D 33 19      STA.W $1933               
CODE_029627:        AD 93 16      LDA.W $1693               
CODE_02962A:        A0 00         LDY.B #$00                
CODE_02962C:        22 60 F1 00   JSL.L CODE_00F160         
Return029630:       60            RTS                       ; Return 

CODE_029631:        A2 07         LDX.B #$07                
CODE_029633:        8E E9 15      STX.W $15E9               
CODE_029636:        BD 0B 17      LDA.W RAM_ExSpriteNum,X   
CODE_029639:        C9 02         CMP.B #$02                
CODE_02963B:        90 16         BCC CODE_029653           
CODE_02963D:        20 19 A5      JSR.W CODE_02A519         
CODE_029640:        20 96 96      JSR.W CODE_029696         
CODE_029643:        22 2B B7 03   JSL.L CheckForContact     
CODE_029647:        90 0A         BCC CODE_029653           
CODE_029649:        BD 0B 17      LDA.W RAM_ExSpriteNum,X   
CODE_02964C:        C9 12         CMP.B #$12                
CODE_02964E:        F0 03         BEQ CODE_029653           
CODE_029650:        20 DE A4      JSR.W CODE_02A4DE         
CODE_029653:        CA            DEX                       
CODE_029654:        10 DD         BPL CODE_029633           
Return029656:       60            RTS                       ; Return 


DATA_029657:                      .db $FC

DATA_029658:                      .db $E0,$FF

DATA_02965A:                      .db $FF,$18

DATA_02965C:                      .db $50,$FC

DATA_02965E:                      .db $F8,$FF

DATA_029660:                      .db $FF,$18,$10

CODE_029663:        DA            PHX                       
CODE_029664:        B9 CD 16      LDA.W RAM_BouncBlkStatus,Y 
CODE_029667:        AA            TAX                       
CODE_029668:        B9 D1 16      LDA.W $16D1,Y             
CODE_02966B:        18            CLC                       
CODE_02966C:        7D 56 96      ADC.W Return029656,X      
CODE_02966F:        85 00         STA $00                   
CODE_029671:        B9 D5 16      LDA.W $16D5,Y             
CODE_029674:        7D 58 96      ADC.W DATA_029658,X       
CODE_029677:        85 08         STA $08                   
CODE_029679:        BD 5A 96      LDA.W DATA_02965A,X       
CODE_02967C:        85 02         STA $02                   
CODE_02967E:        B9 D9 16      LDA.W $16D9,Y             
CODE_029681:        18            CLC                       
CODE_029682:        7D 5C 96      ADC.W DATA_02965C,X       
CODE_029685:        85 01         STA $01                   
CODE_029687:        B9 DD 16      LDA.W $16DD,Y             
CODE_02968A:        7D 5E 96      ADC.W DATA_02965E,X       
CODE_02968D:        85 09         STA $09                   
CODE_02968F:        BD 60 96      LDA.W DATA_029660,X       
CODE_029692:        85 03         STA $03                   
CODE_029694:        FA            PLX                       
Return029695:       60            RTS                       ; Return 

CODE_029696:        AD E9 13      LDA.W $13E9               
CODE_029699:        38            SEC                       
CODE_02969A:        E9 02         SBC.B #$02                
CODE_02969C:        85 00         STA $00                   
CODE_02969E:        AD EA 13      LDA.W $13EA               
CODE_0296A1:        E9 00         SBC.B #$00                
CODE_0296A3:        85 08         STA $08                   
CODE_0296A5:        A9 14         LDA.B #$14                
CODE_0296A7:        85 02         STA $02                   
CODE_0296A9:        AD EB 13      LDA.W $13EB               
CODE_0296AC:        85 01         STA $01                   
CODE_0296AE:        AD EC 13      LDA.W $13EC               
CODE_0296B1:        85 09         STA $09                   
CODE_0296B3:        A9 10         LDA.B #$10                
CODE_0296B5:        85 03         STA $03                   
Return0296B7:       60            RTS                       ; Return 


DATA_0296B8:                      .db $20,$24,$28,$2C

DATA_0296BC:                      .db $90,$94,$98,$9C

CODE_0296C0:        BD C0 17      LDA.W $17C0,X             
CODE_0296C3:        F0 12         BEQ Return0296D7          
CODE_0296C5:        29 7F         AND.B #$7F                
CODE_0296C7:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs0296CB:            D7 96      .dw Return0296D7          
                       E3 96      .dw CODE_0296E3           
                       97 97      .dw CODE_029797           
                       27 99      .dw CODE_029927           
                       D7 96      .dw Return0296D7          
                       CA 98      .dw CODE_0298CA           

Return0296D7:       60            RTS                       ; Return 


DATA_0296D8:                      .db $66,$66,$64,$62,$60,$62,$60

CODE_0296DF:        9E C0 17      STZ.W $17C0,X             
Return0296E2:       60            RTS                       ; Return 

CODE_0296E3:        BD CC 17      LDA.W $17CC,X             
CODE_0296E6:        F0 F7         BEQ CODE_0296DF           
CODE_0296E8:        BD C0 17      LDA.W $17C0,X             
CODE_0296EB:        30 04         BMI CODE_0296F1           
CODE_0296ED:        A5 9D         LDA RAM_SpritesLocked     
CODE_0296EF:        D0 03         BNE CODE_0296F4           
CODE_0296F1:        DE CC 17      DEC.W $17CC,X             
CODE_0296F4:        A5 A5         LDA $A5                   
CODE_0296F6:        C9 A9         CMP.B #$A9                
CODE_0296F8:        F0 50         BEQ CODE_02974A           
CODE_0296FA:        AD 9B 0D      LDA.W $0D9B               
CODE_0296FD:        29 40         AND.B #$40                
CODE_0296FF:        F0 49         BEQ CODE_02974A           
CODE_029701:        BC BC 96      LDY.W DATA_0296BC,X       
CODE_029704:        BD C8 17      LDA.W $17C8,X             
CODE_029707:        38            SEC                       
CODE_029708:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02970A:        C9 F4         CMP.B #$F4                
CODE_02970C:        B0 D1         BCS CODE_0296DF           
CODE_02970E:        99 00 03      STA.W OAM_DispX,Y         
CODE_029711:        BD C4 17      LDA.W $17C4,X             
CODE_029714:        38            SEC                       
CODE_029715:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_029717:        C9 E0         CMP.B #$E0                
CODE_029719:        B0 C4         BCS CODE_0296DF           
CODE_02971B:        99 01 03      STA.W OAM_DispY,Y         
CODE_02971E:        BD CC 17      LDA.W $17CC,X             
CODE_029721:        C9 08         CMP.B #$08                
CODE_029723:        A9 00         LDA.B #$00                
CODE_029725:        B0 06         BCS CODE_02972D           
CODE_029727:        0A            ASL                       
CODE_029728:        0A            ASL                       
CODE_029729:        0A            ASL                       
CODE_02972A:        0A            ASL                       
CODE_02972B:        29 40         AND.B #$40                
CODE_02972D:        05 64         ORA $64                   
CODE_02972F:        99 03 03      STA.W OAM_Prop,Y          
CODE_029732:        BD CC 17      LDA.W $17CC,X             
CODE_029735:        5A            PHY                       
CODE_029736:        4A            LSR                       
CODE_029737:        4A            LSR                       
CODE_029738:        A8            TAY                       
CODE_029739:        B9 D8 96      LDA.W DATA_0296D8,Y       
CODE_02973C:        7A            PLY                       
CODE_02973D:        99 02 03      STA.W OAM_Tile,Y          
CODE_029740:        98            TYA                       
CODE_029741:        4A            LSR                       
CODE_029742:        4A            LSR                       
CODE_029743:        A8            TAY                       
CODE_029744:        A9 02         LDA.B #$02                
CODE_029746:        99 60 04      STA.W OAM_TileSize,Y      
Return029749:       60            RTS                       ; Return 

CODE_02974A:        BC B8 96      LDY.W DATA_0296B8,X       
CODE_02974D:        BD C8 17      LDA.W $17C8,X             
CODE_029750:        38            SEC                       
CODE_029751:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_029753:        C9 F4         CMP.B #$F4                
CODE_029755:        B0 3C         BCS CODE_029793           
CODE_029757:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_02975A:        BD C4 17      LDA.W $17C4,X             
CODE_02975D:        38            SEC                       
CODE_02975E:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_029760:        C9 E0         CMP.B #$E0                
CODE_029762:        B0 2F         BCS CODE_029793           
CODE_029764:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_029767:        BD CC 17      LDA.W $17CC,X             
CODE_02976A:        C9 08         CMP.B #$08                
CODE_02976C:        A9 00         LDA.B #$00                
CODE_02976E:        B0 06         BCS CODE_029776           
CODE_029770:        0A            ASL                       
CODE_029771:        0A            ASL                       
CODE_029772:        0A            ASL                       
CODE_029773:        0A            ASL                       
CODE_029774:        29 40         AND.B #$40                
CODE_029776:        05 64         ORA $64                   
CODE_029778:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02977B:        BD CC 17      LDA.W $17CC,X             
CODE_02977E:        5A            PHY                       
CODE_02977F:        4A            LSR                       
CODE_029780:        4A            LSR                       
CODE_029781:        A8            TAY                       
CODE_029782:        B9 D8 96      LDA.W DATA_0296D8,Y       
CODE_029785:        7A            PLY                       
CODE_029786:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029789:        98            TYA                       
CODE_02978A:        4A            LSR                       
CODE_02978B:        4A            LSR                       
CODE_02978C:        A8            TAY                       
CODE_02978D:        A9 02         LDA.B #$02                
CODE_02978F:        99 20 04      STA.W $0420,Y             
Return029792:       60            RTS                       ; Return 

CODE_029793:        9E C0 17      STZ.W $17C0,X             
Return029796:       60            RTS                       ; Return 

CODE_029797:        BD CC 17      LDA.W $17CC,X             
CODE_02979A:        F0 F7         BEQ CODE_029793           
CODE_02979C:        A4 9D         LDY RAM_SpritesLocked     
CODE_02979E:        D0 03         BNE CODE_0297A3           
CODE_0297A0:        DE CC 17      DEC.W $17CC,X             
CODE_0297A3:        2C 9B 0D      BIT.W $0D9B               
CODE_0297A6:        50 0A         BVC CODE_0297B2           
CODE_0297A8:        AD 9B 0D      LDA.W $0D9B               
CODE_0297AB:        C9 C1         CMP.B #$C1                
CODE_0297AD:        F0 03         BEQ CODE_0297B2           
CODE_0297AF:        4C 38 98      JMP.W CODE_029838         

CODE_0297B2:        A0 F0         LDY.B #$F0                
CODE_0297B4:        BD C8 17      LDA.W $17C8,X             
CODE_0297B7:        38            SEC                       
CODE_0297B8:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_0297BA:        C9 F0         CMP.B #$F0                
CODE_0297BC:        B0 D5         BCS CODE_029793           
CODE_0297BE:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_0297C1:        99 08 02      STA.W $0208,Y             
CODE_0297C4:        18            CLC                       
CODE_0297C5:        69 08         ADC.B #$08                
CODE_0297C7:        99 04 02      STA.W $0204,Y             
CODE_0297CA:        99 0C 02      STA.W $020C,Y             
CODE_0297CD:        BD C4 17      LDA.W $17C4,X             
CODE_0297D0:        38            SEC                       
CODE_0297D1:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_0297D3:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_0297D6:        99 05 02      STA.W $0205,Y             
CODE_0297D9:        18            CLC                       
CODE_0297DA:        69 08         ADC.B #$08                
CODE_0297DC:        99 09 02      STA.W $0209,Y             
CODE_0297DF:        99 0D 02      STA.W $020D,Y             
CODE_0297E2:        BD CC 17      LDA.W $17CC,X             
CODE_0297E5:        0A            ASL                       
CODE_0297E6:        0A            ASL                       
CODE_0297E7:        0A            ASL                       
CODE_0297E8:        0A            ASL                       
CODE_0297E9:        0A            ASL                       
CODE_0297EA:        29 40         AND.B #$40                
CODE_0297EC:        05 64         ORA $64                   
CODE_0297EE:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_0297F1:        99 07 02      STA.W $0207,Y             
CODE_0297F4:        49 C0         EOR.B #$C0                
CODE_0297F6:        99 0B 02      STA.W $020B,Y             
CODE_0297F9:        99 0F 02      STA.W $020F,Y             
CODE_0297FC:        BD CC 17      LDA.W $17CC,X             
CODE_0297FF:        29 02         AND.B #$02                
CODE_029801:        D0 12         BNE CODE_029815           
CODE_029803:        A9 7C         LDA.B #$7C                
CODE_029805:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029808:        99 0E 02      STA.W $020E,Y             
CODE_02980B:        A9 7D         LDA.B #$7D                
CODE_02980D:        99 06 02      STA.W $0206,Y             
CODE_029810:        99 0A 02      STA.W $020A,Y             
CODE_029813:        80 10         BRA CODE_029825           

CODE_029815:        A9 7D         LDA.B #$7D                
CODE_029817:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02981A:        99 0E 02      STA.W $020E,Y             
CODE_02981D:        A9 7C         LDA.B #$7C                
CODE_02981F:        99 06 02      STA.W $0206,Y             
CODE_029822:        99 0A 02      STA.W $020A,Y             
CODE_029825:        98            TYA                       
CODE_029826:        4A            LSR                       
CODE_029827:        4A            LSR                       
CODE_029828:        A8            TAY                       
CODE_029829:        A9 00         LDA.B #$00                
CODE_02982B:        99 20 04      STA.W $0420,Y             
CODE_02982E:        99 21 04      STA.W $0421,Y             
CODE_029831:        99 22 04      STA.W $0422,Y             
CODE_029834:        99 23 04      STA.W $0423,Y             
Return029837:       60            RTS                       ; Return 

CODE_029838:        A0 90         LDY.B #$90                
CODE_02983A:        BD C8 17      LDA.W $17C8,X             
CODE_02983D:        38            SEC                       
CODE_02983E:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_029840:        C9 F0         CMP.B #$F0                
CODE_029842:        B0 7A         BCS CODE_0298BE           
CODE_029844:        99 00 03      STA.W OAM_DispX,Y         
CODE_029847:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_02984A:        18            CLC                       
CODE_02984B:        69 08         ADC.B #$08                
CODE_02984D:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_029850:        99 0C 03      STA.W OAM_Tile4DispX,Y    
CODE_029853:        BD C4 17      LDA.W $17C4,X             
CODE_029856:        38            SEC                       
CODE_029857:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_029859:        99 01 03      STA.W OAM_DispY,Y         
CODE_02985C:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_02985F:        18            CLC                       
CODE_029860:        69 08         ADC.B #$08                
CODE_029862:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_029865:        99 0D 03      STA.W OAM_Tile4DispY,Y    
CODE_029868:        BD CC 17      LDA.W $17CC,X             
CODE_02986B:        0A            ASL                       
CODE_02986C:        0A            ASL                       
CODE_02986D:        0A            ASL                       
CODE_02986E:        0A            ASL                       
CODE_02986F:        0A            ASL                       
CODE_029870:        29 40         AND.B #$40                
CODE_029872:        05 64         ORA $64                   
CODE_029874:        99 03 03      STA.W OAM_Prop,Y          
CODE_029877:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02987A:        49 C0         EOR.B #$C0                
CODE_02987C:        99 0B 03      STA.W OAM_Tile3Prop,Y     
CODE_02987F:        99 0F 03      STA.W OAM_Tile4Prop,Y     
CODE_029882:        BD CC 17      LDA.W $17CC,X             
CODE_029885:        29 02         AND.B #$02                
CODE_029887:        D0 12         BNE CODE_02989B           
CODE_029889:        A9 7C         LDA.B #$7C                
CODE_02988B:        99 02 03      STA.W OAM_Tile,Y          
CODE_02988E:        99 0E 03      STA.W OAM_Tile4,Y         
CODE_029891:        A9 7D         LDA.B #$7D                
CODE_029893:        99 06 03      STA.W OAM_Tile2,Y         
CODE_029896:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_029899:        80 10         BRA CODE_0298AB           

CODE_02989B:        A9 7D         LDA.B #$7D                
CODE_02989D:        99 02 03      STA.W OAM_Tile,Y          
CODE_0298A0:        99 0E 03      STA.W OAM_Tile4,Y         
CODE_0298A3:        A9 7C         LDA.B #$7C                
CODE_0298A5:        99 06 03      STA.W OAM_Tile2,Y         
CODE_0298A8:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_0298AB:        98            TYA                       
CODE_0298AC:        4A            LSR                       
CODE_0298AD:        4A            LSR                       
CODE_0298AE:        A8            TAY                       
CODE_0298AF:        A9 00         LDA.B #$00                
CODE_0298B1:        99 60 04      STA.W OAM_TileSize,Y      
CODE_0298B4:        99 61 04      STA.W $0461,Y             
CODE_0298B7:        99 62 04      STA.W $0462,Y             
CODE_0298BA:        99 63 04      STA.W $0463,Y             
Return0298BD:       60            RTS                       ; Return 

CODE_0298BE:        9E C0 17      STZ.W $17C0,X             
Return0298C1:       60            RTS                       ; Return 


DATA_0298C2:                      .db $04,$08,$04,$00

DATA_0298C6:                      .db $FC,$04,$0C,$04

CODE_0298CA:        BD CC 17      LDA.W $17CC,X             
CODE_0298CD:        F0 EF         BEQ CODE_0298BE           
CODE_0298CF:        A4 9D         LDY RAM_SpritesLocked     
CODE_0298D1:        D0 4E         BNE Return029921          
CODE_0298D3:        DE CC 17      DEC.W $17CC,X             
CODE_0298D6:        29 03         AND.B #$03                
CODE_0298D8:        D0 47         BNE Return029921          
CODE_0298DA:        A0 0B         LDY.B #$0B                
CODE_0298DC:        B9 F0 17      LDA.W $17F0,Y             
CODE_0298DF:        F0 10         BEQ CODE_0298F1           
CODE_0298E1:        88            DEY                       
CODE_0298E2:        10 F8         BPL CODE_0298DC           
CODE_0298E4:        CE 5D 18      DEC.W $185D               
CODE_0298E7:        10 05         BPL CODE_0298EE           
CODE_0298E9:        A9 0B         LDA.B #$0B                
CODE_0298EB:        8D 5D 18      STA.W $185D               
CODE_0298EE:        AC 5D 18      LDY.W $185D               
CODE_0298F1:        A9 02         LDA.B #$02                
CODE_0298F3:        99 F0 17      STA.W $17F0,Y             
CODE_0298F6:        BD C4 17      LDA.W $17C4,X             
CODE_0298F9:        85 01         STA $01                   
CODE_0298FB:        BD C8 17      LDA.W $17C8,X             
CODE_0298FE:        85 00         STA $00                   
CODE_029900:        BD CC 17      LDA.W $17CC,X             
CODE_029903:        4A            LSR                       
CODE_029904:        4A            LSR                       
CODE_029905:        29 03         AND.B #$03                
CODE_029907:        DA            PHX                       
CODE_029908:        AA            TAX                       
CODE_029909:        BD C2 98      LDA.W DATA_0298C2,X       
CODE_02990C:        18            CLC                       
CODE_02990D:        65 00         ADC $00                   
CODE_02990F:        99 08 18      STA.W $1808,Y             
CODE_029912:        BD C6 98      LDA.W DATA_0298C6,X       
CODE_029915:        18            CLC                       
CODE_029916:        65 01         ADC $01                   
CODE_029918:        99 FC 17      STA.W $17FC,Y             
CODE_02991B:        FA            PLX                       
CODE_02991C:        A9 17         LDA.B #$17                
CODE_02991E:        99 50 18      STA.W $1850,Y             
Return029921:       60            RTS                       ; Return 


DATA_029922:                      .db $66,$66,$64,$62,$62

CODE_029927:        BD CC 17      LDA.W $17CC,X             
CODE_02992A:        D0 15         BNE CODE_029941           
CODE_02992C:        2C 9B 0D      BIT.W $0D9B               
CODE_02992F:        50 0D         BVC CODE_02993E           
CODE_029931:        AD 0F 14      LDA.W $140F               
CODE_029934:        D0 08         BNE CODE_02993E           
CODE_029936:        BC BC 96      LDY.W DATA_0296BC,X       
CODE_029939:        A9 F0         LDA.B #$F0                
CODE_02993B:        99 01 03      STA.W OAM_DispY,Y         
CODE_02993E:        4C 93 97      JMP.W CODE_029793         

CODE_029941:        A4 9D         LDY RAM_SpritesLocked     
CODE_029943:        D0 0A         BNE CODE_02994F           
CODE_029945:        DE CC 17      DEC.W $17CC,X             
CODE_029948:        29 07         AND.B #$07                
CODE_02994A:        D0 03         BNE CODE_02994F           
CODE_02994C:        DE C4 17      DEC.W $17C4,X             
CODE_02994F:        A5 A5         LDA $A5                   
CODE_029951:        C9 A9         CMP.B #$A9                
CODE_029953:        F0 17         BEQ CODE_02996C           
CODE_029955:        AD 0F 14      LDA.W $140F               
CODE_029958:        D0 12         BNE CODE_02996C           
CODE_02995A:        AD 9B 0D      LDA.W $0D9B               
CODE_02995D:        10 0D         BPL CODE_02996C           
CODE_02995F:        C9 C1         CMP.B #$C1                
CODE_029961:        F0 04         BEQ CODE_029967           
CODE_029963:        29 40         AND.B #$40                
CODE_029965:        D0 38         BNE CODE_02999F           
CODE_029967:        BC BC 96      LDY.W DATA_0296BC,X       
CODE_02996A:        80 03         BRA CODE_02996F           

CODE_02996C:        BC B8 96      LDY.W DATA_0296B8,X       
CODE_02996F:        BD C8 17      LDA.W $17C8,X             
CODE_029972:        38            SEC                       
CODE_029973:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_029975:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_029978:        BD C4 17      LDA.W $17C4,X             
CODE_02997B:        38            SEC                       
CODE_02997C:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02997E:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_029981:        A5 64         LDA $64                   
CODE_029983:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_029986:        BD CC 17      LDA.W $17CC,X             
CODE_029989:        4A            LSR                       
CODE_02998A:        4A            LSR                       
CODE_02998B:        AA            TAX                       
CODE_02998C:        BD 22 99      LDA.W DATA_029922,X       
CODE_02998F:        AE 98 16      LDX.W $1698               
CODE_029992:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029995:        98            TYA                       
CODE_029996:        4A            LSR                       
CODE_029997:        4A            LSR                       
CODE_029998:        A8            TAY                       
CODE_029999:        A9 00         LDA.B #$00                
CODE_02999B:        99 20 04      STA.W $0420,Y             
Return02999E:       60            RTS                       ; Return 

CODE_02999F:        BC BC 96      LDY.W DATA_0296BC,X       
CODE_0299A2:        BD C8 17      LDA.W $17C8,X             
CODE_0299A5:        38            SEC                       
CODE_0299A6:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_0299A8:        99 00 03      STA.W OAM_DispX,Y         
CODE_0299AB:        BD C4 17      LDA.W $17C4,X             
CODE_0299AE:        38            SEC                       
CODE_0299AF:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_0299B1:        99 01 03      STA.W OAM_DispY,Y         
CODE_0299B4:        A5 64         LDA $64                   
CODE_0299B6:        99 03 03      STA.W OAM_Prop,Y          
CODE_0299B9:        BD CC 17      LDA.W $17CC,X             
CODE_0299BC:        4A            LSR                       
CODE_0299BD:        4A            LSR                       
CODE_0299BE:        AA            TAX                       
CODE_0299BF:        BD 22 99      LDA.W DATA_029922,X       
CODE_0299C2:        AE 98 16      LDX.W $1698               
CODE_0299C5:        99 02 03      STA.W OAM_Tile,Y          
CODE_0299C8:        98            TYA                       
CODE_0299C9:        4A            LSR                       
CODE_0299CA:        4A            LSR                       
CODE_0299CB:        A8            TAY                       
CODE_0299CC:        A9 00         LDA.B #$00                
CODE_0299CE:        99 60 04      STA.W OAM_TileSize,Y      
Return0299D1:       60            RTS                       ; Return 

CODE_0299D2:        A2 03         LDX.B #$03                
CODE_0299D4:        8E E9 15      STX.W $15E9               
CODE_0299D7:        BD D0 17      LDA.W $17D0,X             
CODE_0299DA:        F0 03         BEQ CODE_0299DF           
CODE_0299DC:        20 F1 99      JSR.W CODE_0299F1         
CODE_0299DF:        CA            DEX                       
CODE_0299E0:        10 F2         BPL CODE_0299D4           
Return0299E2:       60            RTS                       ; Return 

CODE_0299E3:        A9 00         LDA.B #$00                
CODE_0299E5:        9D D0 17      STA.W $17D0,X             
Return0299E8:       60            RTS                       ; Return 


DATA_0299E9:                      .db $30,$38,$40,$48,$EC,$EA,$E8,$EC

CODE_0299F1:        A5 9D         LDA RAM_SpritesLocked     
CODE_0299F3:        D0 13         BNE CODE_029A08           
CODE_0299F5:        20 8E B5      JSR.W CODE_02B58E         
CODE_0299F8:        BD D8 17      LDA.W $17D8,X             
CODE_0299FB:        18            CLC                       
CODE_0299FC:        69 03         ADC.B #$03                
CODE_0299FE:        9D D8 17      STA.W $17D8,X             
CODE_029A01:        C9 20         CMP.B #$20                
CODE_029A03:        30 03         BMI CODE_029A08           
CODE_029A05:        4C A8 9A      JMP.W CODE_029AA8         

CODE_029A08:        BD E4 17      LDA.W $17E4,X             
CODE_029A0B:        0A            ASL                       
CODE_029A0C:        0A            ASL                       
CODE_029A0D:        A8            TAY                       
CODE_029A0E:        B9 1C 00      LDA.W RAM_ScreenBndryYLo,Y 
CODE_029A11:        85 02         STA $02                   
CODE_029A13:        B9 1A 00      LDA.W RAM_ScreenBndryXLo,Y 
CODE_029A16:        85 03         STA $03                   
CODE_029A18:        B9 1D 00      LDA.W RAM_ScreenBndryYHi,Y 
CODE_029A1B:        85 04         STA $04                   
CODE_029A1D:        BD D4 17      LDA.W $17D4,X             
CODE_029A20:        C5 02         CMP $02                   
CODE_029A22:        BD E8 17      LDA.W $17E8,X             
CODE_029A25:        E5 04         SBC $04                   
CODE_029A27:        D0 44         BNE Return029A6D          
CODE_029A29:        BD E0 17      LDA.W $17E0,X             
CODE_029A2C:        38            SEC                       
CODE_029A2D:        E5 03         SBC $03                   
CODE_029A2F:        C9 F8         CMP.B #$F8                
CODE_029A31:        B0 B0         BCS CODE_0299E3           
CODE_029A33:        85 00         STA $00                   
CODE_029A35:        BD D4 17      LDA.W $17D4,X             
CODE_029A38:        38            SEC                       
CODE_029A39:        E5 02         SBC $02                   
CODE_029A3B:        85 01         STA $01                   
CODE_029A3D:        BC E9 99      LDY.W DATA_0299E9,X       
CODE_029A40:        84 0F         STY $0F                   
CODE_029A42:        A4 0F         LDY $0F                   
CODE_029A44:        A5 00         LDA $00                   
CODE_029A46:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_029A49:        A5 01         LDA $01                   
CODE_029A4B:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_029A4E:        A9 E8         LDA.B #$E8                
CODE_029A50:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029A53:        A9 04         LDA.B #$04                
CODE_029A55:        05 64         ORA $64                   
CODE_029A57:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_029A5A:        98            TYA                       
CODE_029A5B:        4A            LSR                       
CODE_029A5C:        4A            LSR                       
CODE_029A5D:        A8            TAY                       
CODE_029A5E:        A9 02         LDA.B #$02                
CODE_029A60:        99 20 04      STA.W $0420,Y             
CODE_029A63:        8A            TXA                       
CODE_029A64:        18            CLC                       
CODE_029A65:        65 14         ADC RAM_FrameCounterB     
CODE_029A67:        4A            LSR                       
CODE_029A68:        4A            LSR                       
CODE_029A69:        29 03         AND.B #$03                
CODE_029A6B:        D0 04         BNE CODE_029A71           
Return029A6D:       60            RTS                       ; Return 


RollingCoinTiles:                 .db $EA,$FA,$EA

CODE_029A71:        A4 0F         LDY $0F                   
CODE_029A73:        DA            PHX                       
CODE_029A74:        AA            TAX                       
CODE_029A75:        A5 00         LDA $00                   
CODE_029A77:        18            CLC                       
CODE_029A78:        69 04         ADC.B #$04                
CODE_029A7A:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_029A7D:        99 04 02      STA.W $0204,Y             
CODE_029A80:        A5 01         LDA $01                   
CODE_029A82:        18            CLC                       
CODE_029A83:        69 08         ADC.B #$08                
CODE_029A85:        99 05 02      STA.W $0205,Y             
CODE_029A88:        BF 6D 9A 02   LDA.L Return029A6D,X      
CODE_029A8C:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029A8F:        99 06 02      STA.W $0206,Y             
CODE_029A92:        B9 03 02      LDA.W OAM_ExtendedProp,Y  
CODE_029A95:        09 80         ORA.B #$80                
CODE_029A97:        99 07 02      STA.W $0207,Y             
CODE_029A9A:        98            TYA                       
CODE_029A9B:        4A            LSR                       
CODE_029A9C:        4A            LSR                       
CODE_029A9D:        A8            TAY                       
CODE_029A9E:        A9 00         LDA.B #$00                
CODE_029AA0:        99 20 04      STA.W $0420,Y             
CODE_029AA3:        99 21 04      STA.W $0421,Y             
CODE_029AA6:        FA            PLX                       
Return029AA7:       60            RTS                       ; Return 

CODE_029AA8:        22 34 AD 02   JSL.L CODE_02AD34         ; Find next usable location in score sprite table 
CODE_029AAC:        A9 01         LDA.B #$01                
CODE_029AAE:        99 E1 16      STA.W RAM_ScoreSprNum,Y   ; add a "10" score sprite 
CODE_029AB1:        BD D4 17      LDA.W $17D4,X             
CODE_029AB4:        99 E7 16      STA.W RAM_ScoreSprYLo,Y   ; set Yposition low byte 
CODE_029AB7:        BD E8 17      LDA.W $17E8,X             
CODE_029ABA:        99 F9 16      STA.W RAM_ScoreSprYHi,Y   ; set Ypos high byte 
CODE_029ABD:        BD E0 17      LDA.W $17E0,X             
CODE_029AC0:        99 ED 16      STA.W RAM_ScoreSprXLo,Y   ; set Xpos low byte 
CODE_029AC3:        BD EC 17      LDA.W $17EC,X             
CODE_029AC6:        99 F3 16      STA.W RAM_ScoreSprXHi,Y   ; set Xpos high byte 
CODE_029AC9:        A9 30         LDA.B #$30                
CODE_029ACB:        99 FF 16      STA.W RAM_ScoreSprSpeedY,Y ; set initial speed to 30 
CODE_029ACE:        BD E4 17      LDA.W $17E4,X             
CODE_029AD1:        99 05 17      STA.W $1705,Y             
CODE_029AD4:        20 DA 9A      JSR.W CODE_029ADA         
CODE_029AD7:        4C E3 99      JMP.W CODE_0299E3         ; Puts #$00 into $17D0 and returns 

CODE_029ADA:        A0 03         LDY.B #$03                ; for (c=3;c>=0;c--) 
CODE_029ADC:        B9 C0 17      LDA.W $17C0,Y             ; { 
CODE_029ADF:        F0 04         BEQ CODE_029AE5           ;  check if there is empty space in smoke/dust sprite table 
CODE_029AE1:        88            DEY                       
CODE_029AE2:        10 F8         BPL CODE_029ADC           ; } 
Return029AE4:       60            RTS                       ;  if no empty space, return 

CODE_029AE5:        A9 05         LDA.B #$05                ; if there's an empty space, make it 5 (glitter sprite) 
CODE_029AE7:        99 C0 17      STA.W $17C0,Y             
CODE_029AEA:        BD E4 17      LDA.W $17E4,X             ;  nots sure what 17E4 is used for yet - copied from $1933 
CODE_029AED:        4A            LSR                       ; carryout = $17E4 % 2 
CODE_029AEE:        08            PHP                       
CODE_029AEF:        BD E0 17      LDA.W $17E0,X             ; get x coordinate low byte 
CODE_029AF2:        90 02         BCC CODE_029AF6           ; if carryout == 1 
ADDR_029AF4:        E5 26         SBC $26                   ;   x-coord -= $26 
CODE_029AF6:        99 C8 17      STA.W $17C8,Y             ; store x-coord 
CODE_029AF9:        BD D4 17      LDA.W $17D4,X             ; get y coordinate low byte 
CODE_029AFC:        28            PLP                       
CODE_029AFD:        90 02         BCC CODE_029B01           ; if carryout == 1 
ADDR_029AFF:        E5 28         SBC $28                   ;   y-coord -=$28 
CODE_029B01:        99 C4 17      STA.W $17C4,Y             ; store y-coord 
CODE_029B04:        A9 10         LDA.B #$10                
CODE_029B06:        99 CC 17      STA.W $17CC,Y             ; duration = 10 
Return029B09:       60            RTS                       ; Return 

CODE_029B0A:        A2 09         LDX.B #$09                
CODE_029B0C:        8E E9 15      STX.W $15E9               
CODE_029B0F:        20 16 9B      JSR.W CODE_029B16         
CODE_029B12:        CA            DEX                       
CODE_029B13:        10 F7         BPL CODE_029B0C           
Return029B15:       60            RTS                       ; Return 

CODE_029B16:        BD 0B 17      LDA.W RAM_ExSpriteNum,X   
CODE_029B19:        F0 FA         BEQ Return029B15          
CODE_029B1B:        A4 9D         LDY RAM_SpritesLocked     
CODE_029B1D:        D0 08         BNE CODE_029B27           
CODE_029B1F:        BC 6F 17      LDY.W $176F,X             
CODE_029B22:        F0 03         BEQ CODE_029B27           
CODE_029B24:        DE 6F 17      DEC.W $176F,X             
CODE_029B27:        22 DF 86 00   JSL.L ExecutePtr          

ExtendedSpritePtrs:    15 9B      .dw Return029B15          ; 00 - Empty slot 
                       4F A3      .dw SmokePuff             ; 01 - Puff of smoke 
                       6B A1      .dw ReznorFireball        ; 02 - Reznor fireball                             
                       19 A2      .dw FlameRemnant          ; 03 - Tiny flame left by hopping flame            
                       EF A2      .dw Hammer                ; 04 - Hammer                                      
                       AF 9F      .dw MarioFireball         ; 05 - Mario fireball 
                       54 A2      .dw Baseball              ; 06 - Bone 
                       86 9E      .dw LavaSplash            ; 07 - Lava splash 
                       3D 9E      .dw LauncherArm           ; 08 - Torpedo Ted shooter's arm                   
                       9D 9D      .dw UnusedExtendedSpr     ; 09 - Unused (Red thing that flickers from 16x16 to 8x8) 
                       B5 9C      .dw CloudCoin             ; 0A - Coin from cloud game  
                       EF A2      .dw Hammer                ; 0B - Piranha fireball                            
                       51 9B      .dw VolcanoLotusFire      ; 0C - Volcano lotus fire 
                       54 A2      .dw Baseball              ; 0D - Baseball                                    
                       B5 9C      .dw CloudCoin             ; 0E - Flower of Wiggler 
                       3E 9C      .dw SmokeTrail            ; 0F - Trail of smoke                              
                       83 9C      .dw SpinJumpStars         ; 10 - Spin Jump stars                              
                       61 9F      .dw YoshiFireball         ; 11 - Yoshi fireballs 
                       EE 9E      .dw WaterBubble           ; 12 - Water bubble                                

VolcanoLotusFire:   BC 53 A1      LDY.W DATA_02A153,X       
CODE_029B54:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_029B57:        38            SEC                       
CODE_029B58:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_029B5A:        85 00         STA $00                   
CODE_029B5C:        BD 33 17      LDA.W RAM_ExSpriteXHi,X   
CODE_029B5F:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_029B61:        D0 77         BNE CODE_029BDA           
CODE_029B63:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_029B66:        38            SEC                       
CODE_029B67:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_029B69:        85 01         STA $01                   
CODE_029B6B:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
CODE_029B6E:        E5 1D         SBC RAM_ScreenBndryYHi    
CODE_029B70:        F0 04         BEQ CODE_029B76           
CODE_029B72:        30 31         BMI CODE_029BA5           
CODE_029B74:        10 64         BPL CODE_029BDA           
CODE_029B76:        A5 00         LDA $00                   
CODE_029B78:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_029B7B:        A5 01         LDA $01                   
CODE_029B7D:        C9 F0         CMP.B #$F0                
CODE_029B7F:        B0 24         BCS CODE_029BA5           
CODE_029B81:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_029B84:        A9 09         LDA.B #$09                
CODE_029B86:        05 64         ORA $64                   
CODE_029B88:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_029B8B:        A5 14         LDA RAM_FrameCounterB     
CODE_029B8D:        4A            LSR                       
CODE_029B8E:        4D E9 15      EOR.W $15E9               
CODE_029B91:        4A            LSR                       
CODE_029B92:        4A            LSR                       
CODE_029B93:        A9 A6         LDA.B #$A6                
CODE_029B95:        90 02         BCC CODE_029B99           
CODE_029B97:        A9 B6         LDA.B #$B6                
CODE_029B99:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029B9C:        98            TYA                       
CODE_029B9D:        4A            LSR                       
CODE_029B9E:        4A            LSR                       
CODE_029B9F:        A8            TAY                       
CODE_029BA0:        A9 00         LDA.B #$00                
CODE_029BA2:        99 20 04      STA.W $0420,Y             
CODE_029BA5:        A5 9D         LDA RAM_SpritesLocked     
CODE_029BA7:        D0 30         BNE Return029BD9          
CODE_029BA9:        20 F6 A3      JSR.W CODE_02A3F6         
CODE_029BAC:        20 54 B5      JSR.W CODE_02B554         
CODE_029BAF:        20 60 B5      JSR.W CODE_02B560         
CODE_029BB2:        A5 13         LDA RAM_FrameCounter      
CODE_029BB4:        29 03         AND.B #$03                
CODE_029BB6:        D0 0A         BNE CODE_029BC2           
CODE_029BB8:        BD 3D 17      LDA.W RAM_ExSprSpeedY,X   
CODE_029BBB:        C9 18         CMP.B #$18                
CODE_029BBD:        10 03         BPL CODE_029BC2           
CODE_029BBF:        FE 3D 17      INC.W RAM_ExSprSpeedY,X   
CODE_029BC2:        BD 3D 17      LDA.W RAM_ExSprSpeedY,X   
CODE_029BC5:        30 12         BMI Return029BD9          
CODE_029BC7:        8A            TXA                       
CODE_029BC8:        0A            ASL                       
CODE_029BC9:        0A            ASL                       
CODE_029BCA:        0A            ASL                       
CODE_029BCB:        65 13         ADC RAM_FrameCounter      
CODE_029BCD:        A0 08         LDY.B #$08                
CODE_029BCF:        29 08         AND.B #$08                
CODE_029BD1:        D0 02         BNE CODE_029BD5           
CODE_029BD3:        A0 F8         LDY.B #$F8                
CODE_029BD5:        98            TYA                       
CODE_029BD6:        9D 47 17      STA.W RAM_ExSprSpeedX,X   
Return029BD9:       60            RTS                       ; Return 

CODE_029BDA:        9E 0B 17      STZ.W RAM_ExSpriteNum,X   ; Clear extended sprite 
Return029BDD:       60            RTS                       ; Return 


DATA_029BDE:                      .db $08,$F8

DATA_029BE0:                      .db $00,$FF

DATA_029BE2:                      .db $18,$E8

CODE_029BE4:        A9 05         LDA.B #$05                ; \ Set ground shake timer 
CODE_029BE6:        8D 87 18      STA.W RAM_ShakeGrndTimer  ; / 
CODE_029BE9:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_029BEB:        8D FC 1D      STA.W $1DFC               ; / 
CODE_029BEE:        64 00         STZ $00                   
CODE_029BF0:        20 F5 9B      JSR.W CODE_029BF5         
CODE_029BF3:        E6 00         INC $00                   
CODE_029BF5:        A0 07         LDY.B #$07                ; \ Find a free extended sprite slot 
CODE_029BF7:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   ;  | 
CODE_029BFA:        F0 04         BEQ CODE_029C00           ;  | 
CODE_029BFC:        88            DEY                       ;  | 
CODE_029BFD:        10 F8         BPL CODE_029BF7           ;  | 
Return029BFF:       60            RTS                       ; / Return if no free slots 

CODE_029C00:        A9 0F         LDA.B #$0F                ; \ Extended sprite = Yoshi stomp smoke 
CODE_029C02:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_029C05:        A5 96         LDA RAM_MarioYPos         
CODE_029C07:        18            CLC                       
CODE_029C08:        69 28         ADC.B #$28                
CODE_029C0A:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
CODE_029C0D:        A5 97         LDA RAM_MarioYPosHi       
CODE_029C0F:        69 00         ADC.B #$00                
CODE_029C11:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
CODE_029C14:        A6 00         LDX $00                   
CODE_029C16:        A5 94         LDA RAM_MarioXPos         
CODE_029C18:        18            CLC                       
CODE_029C19:        7D DE 9B      ADC.W DATA_029BDE,X       
CODE_029C1C:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
CODE_029C1F:        A5 95         LDA RAM_MarioXPosHi       
CODE_029C21:        7D E0 9B      ADC.W DATA_029BE0,X       
CODE_029C24:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
CODE_029C27:        BD E2 9B      LDA.W DATA_029BE2,X       
CODE_029C2A:        99 47 17      STA.W RAM_ExSprSpeedX,Y   
CODE_029C2D:        A9 15         LDA.B #$15                
CODE_029C2F:        99 6F 17      STA.W $176F,Y             
Return029C32:       60            RTS                       ; Return 


SmokeTrailTiles:                  .db $66,$64,$62,$60,$60,$60,$60,$60
                                  .db $60,$60,$60

SmokeTrail:         20 A4 A1      JSR.W CODE_02A1A4         
CODE_029C41:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_029C44:        BD 6F 17      LDA.W $176F,X             
CODE_029C47:        4A            LSR                       
CODE_029C48:        DA            PHX                       
CODE_029C49:        AA            TAX                       
CODE_029C4A:        A5 14         LDA RAM_FrameCounterB     
CODE_029C4C:        0A            ASL                       
CODE_029C4D:        0A            ASL                       
CODE_029C4E:        0A            ASL                       
CODE_029C4F:        0A            ASL                       
CODE_029C50:        29 C0         AND.B #$C0                
CODE_029C52:        09 32         ORA.B #$32                
CODE_029C54:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_029C57:        BD 33 9C      LDA.W SmokeTrailTiles,X   
CODE_029C5A:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029C5D:        98            TYA                       
CODE_029C5E:        4A            LSR                       
CODE_029C5F:        4A            LSR                       
CODE_029C60:        A8            TAY                       
CODE_029C61:        A9 02         LDA.B #$02                
CODE_029C63:        99 20 04      STA.W $0420,Y             
CODE_029C66:        FA            PLX                       
CODE_029C67:        A5 9D         LDA RAM_SpritesLocked     
CODE_029C69:        D0 13         BNE Return029C7E          
CODE_029C6B:        BD 6F 17      LDA.W $176F,X             
CODE_029C6E:        F0 0F         BEQ CODE_029C7F           
CODE_029C70:        C9 06         CMP.B #$06                
CODE_029C72:        D0 07         BNE CODE_029C7B           
CODE_029C74:        BD 47 17      LDA.W RAM_ExSprSpeedX,X   
CODE_029C77:        0A            ASL                       
CODE_029C78:        7E 47 17      ROR.W RAM_ExSprSpeedX,X   
CODE_029C7B:        20 54 B5      JSR.W CODE_02B554         
Return029C7E:       60            RTS                       ; Return 

CODE_029C7F:        9E 0B 17      STZ.W RAM_ExSpriteNum,X   ; Clear extended sprite 
Return029C82:       60            RTS                       ; Return 

SpinJumpStars:      BD 6F 17      LDA.W $176F,X             
CODE_029C86:        F0 F7         BEQ CODE_029C7F           
CODE_029C88:        20 A4 A1      JSR.W CODE_02A1A4         
CODE_029C8B:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_029C8E:        A9 34         LDA.B #$34                
CODE_029C90:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_029C93:        A9 EF         LDA.B #$EF                
CODE_029C95:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029C98:        A5 9D         LDA RAM_SpritesLocked     
CODE_029C9A:        D0 13         BNE Return029CAF          
CODE_029C9C:        BD 6F 17      LDA.W $176F,X             
CODE_029C9F:        4A            LSR                       
CODE_029CA0:        4A            LSR                       
CODE_029CA1:        A8            TAY                       
CODE_029CA2:        A5 13         LDA RAM_FrameCounter      
CODE_029CA4:        39 B0 9C      AND.W DATA_029CB0,Y       
CODE_029CA7:        D0 06         BNE Return029CAF          
CODE_029CA9:        20 54 B5      JSR.W CODE_02B554         
CODE_029CAC:        20 60 B5      JSR.W CODE_02B560         
Return029CAF:       60            RTS                       ; Return 


DATA_029CB0:                      .db $FF,$07,$01,$00,$00

CloudCoin:          A5 9D         LDA RAM_SpritesLocked     
CODE_029CB7:        D0 3F         BNE CODE_029CF8           
CODE_029CB9:        20 60 B5      JSR.W CODE_02B560         
CODE_029CBC:        BD 3D 17      LDA.W RAM_ExSprSpeedY,X   
CODE_029CBF:        C9 30         CMP.B #$30                
CODE_029CC1:        10 06         BPL CODE_029CC9           
CODE_029CC3:        18            CLC                       
CODE_029CC4:        69 02         ADC.B #$02                
CODE_029CC6:        9D 3D 17      STA.W RAM_ExSprSpeedY,X   
CODE_029CC9:        BD 0B 17      LDA.W RAM_ExSpriteNum,X   
CODE_029CCC:        C9 0E         CMP.B #$0E                
CODE_029CCE:        D0 13         BNE ADDR_029CE3           
CODE_029CD0:        A0 08         LDY.B #$08                
CODE_029CD2:        A5 14         LDA RAM_FrameCounterB     
CODE_029CD4:        29 08         AND.B #$08                
CODE_029CD6:        F0 02         BEQ CODE_029CDA           
CODE_029CD8:        A0 F8         LDY.B #$F8                
CODE_029CDA:        98            TYA                       
CODE_029CDB:        9D 47 17      STA.W RAM_ExSprSpeedX,X   
CODE_029CDE:        20 54 B5      JSR.W CODE_02B554         
CODE_029CE1:        80 15         BRA CODE_029CF8           

ADDR_029CE3:        BD 65 17      LDA.W $1765,X             
ADDR_029CE6:        D0 0D         BNE ADDR_029CF5           
ADDR_029CE8:        20 6E A5      JSR.W CODE_02A56E         
ADDR_029CEB:        90 08         BCC ADDR_029CF5           
ADDR_029CED:        A9 D0         LDA.B #$D0                
ADDR_029CEF:        9D 3D 17      STA.W RAM_ExSprSpeedY,X   
ADDR_029CF2:        FE 65 17      INC.W $1765,X             
ADDR_029CF5:        20 F6 A3      JSR.W CODE_02A3F6         
CODE_029CF8:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_029CFB:        38            SEC                       
CODE_029CFC:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_029CFE:        C9 F0         CMP.B #$F0                
CODE_029D00:        B0 58         BCS CODE_029D5A           
CODE_029D02:        85 01         STA $01                   
CODE_029D04:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_029D07:        C5 1A         CMP RAM_ScreenBndryXLo    
CODE_029D09:        BD 33 17      LDA.W RAM_ExSpriteXHi,X   
CODE_029D0C:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_029D0E:        D0 4D         BNE Return029D5D          
CODE_029D10:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_029D13:        84 0F         STY $0F                   
CODE_029D15:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_029D18:        38            SEC                       
CODE_029D19:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_029D1B:        85 00         STA $00                   
CODE_029D1D:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_029D20:        BD 0B 17      LDA.W RAM_ExSpriteNum,X   
CODE_029D23:        C9 0E         CMP.B #$0E                
CODE_029D25:        D0 1E         BNE ADDR_029D45           
CODE_029D27:        A5 01         LDA $01                   
CODE_029D29:        38            SEC                       
CODE_029D2A:        E9 05         SBC.B #$05                
CODE_029D2C:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_029D2F:        A9 98         LDA.B #$98                
CODE_029D31:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029D34:        A9 0B         LDA.B #$0B                
CODE_029D36:        05 64         ORA $64                   
CODE_029D38:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_029D3B:        98            TYA                       
CODE_029D3C:        4A            LSR                       
CODE_029D3D:        4A            LSR                       
CODE_029D3E:        A8            TAY                       
CODE_029D3F:        A9 00         LDA.B #$00                
CODE_029D41:        99 20 04      STA.W $0420,Y             
Return029D44:       60            RTS                       ; Return 

ADDR_029D45:        A5 01         LDA $01                   
ADDR_029D47:        99 01 02      STA.W OAM_ExtendedDispY,Y 
ADDR_029D4A:        A9 C2         LDA.B #$C2                
ADDR_029D4C:        99 02 02      STA.W OAM_ExtendedTile,Y  
ADDR_029D4F:        A9 04         LDA.B #$04                
ADDR_029D51:        20 36 9D      JSR.W CODE_029D36         
ADDR_029D54:        A9 02         LDA.B #$02                
ADDR_029D56:        99 20 04      STA.W $0420,Y             
Return029D59:       60            RTS                       ; Return 

CODE_029D5A:        9E 0B 17      STZ.W RAM_ExSpriteNum,X   ; Clear extended sprite 
Return029D5D:       60            RTS                       ; Return 


DATA_029D5E:                      .db $00,$01,$02,$03,$02,$03,$02,$03
                                  .db $03,$02,$03,$02,$03,$02,$01,$00
UnusedExSprDispX:                 .db $10,$F8,$03,$10,$F8,$03,$10,$F0
                                  .db $FF,$10,$F0,$FF

UnusedExSprDispY:                 .db $02,$02,$EE,$02,$02,$EE,$FE,$FE
                                  .db $E6,$FE,$FE,$E6

UnusedExSprTiles:                 .db $B3,$B3,$B1,$B2,$B2,$B0,$8E,$8E
                                  .db $A8,$8C,$8C,$88

UnusedExSprGfxProp:               .db $69,$29,$29

UnusedExSprTileSize:              .db $00,$00,$02,$02

ADDR_029D99:        9E 0B 17      STZ.W RAM_ExSpriteNum,X   ; Clear extended sprite 
Return029D9C:       60            RTS                       ; Return 

UnusedExtendedSpr:  20 F6 A3      JSR.W CODE_02A3F6         
ADDR_029DA0:        BC 47 17      LDY.W RAM_ExSprSpeedX,X   
ADDR_029DA3:        B9 C8 14      LDA.W $14C8,Y             
ADDR_029DA6:        C9 08         CMP.B #$08                
ADDR_029DA8:        D0 EF         BNE ADDR_029D99           
ADDR_029DAA:        BD 6F 17      LDA.W $176F,X             
ADDR_029DAD:        F0 EA         BEQ ADDR_029D99           
ADDR_029DAF:        4A            LSR                       
ADDR_029DB0:        4A            LSR                       
ADDR_029DB1:        EA            NOP                       
ADDR_029DB2:        EA            NOP                       
ADDR_029DB3:        A8            TAY                       
ADDR_029DB4:        B9 5E 9D      LDA.W DATA_029D5E,Y       
ADDR_029DB7:        85 0F         STA $0F                   
ADDR_029DB9:        0A            ASL                       
ADDR_029DBA:        65 0F         ADC $0F                   
ADDR_029DBC:        85 02         STA $02                   
ADDR_029DBE:        BD 65 17      LDA.W $1765,X             
ADDR_029DC1:        18            CLC                       
ADDR_029DC2:        65 02         ADC $02                   
ADDR_029DC4:        A8            TAY                       
ADDR_029DC5:        84 03         STY $03                   
ADDR_029DC7:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
ADDR_029DCA:        18            CLC                       
ADDR_029DCB:        79 6E 9D      ADC.W UnusedExSprDispX,Y  
ADDR_029DCE:        38            SEC                       
ADDR_029DCF:        E5 1A         SBC RAM_ScreenBndryXLo    
ADDR_029DD1:        85 00         STA $00                   
ADDR_029DD3:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
ADDR_029DD6:        18            CLC                       
ADDR_029DD7:        79 7A 9D      ADC.W UnusedExSprDispY,Y  
ADDR_029DDA:        38            SEC                       
ADDR_029DDB:        E5 1C         SBC RAM_ScreenBndryYLo    
ADDR_029DDD:        85 01         STA $01                   
ADDR_029DDF:        BC 53 A1      LDY.W DATA_02A153,X       
ADDR_029DE2:        C9 F0         CMP.B #$F0                
ADDR_029DE4:        B0 53         BCS CODE_029E39           
ADDR_029DE6:        99 01 02      STA.W OAM_ExtendedDispY,Y 
ADDR_029DE9:        A5 00         LDA $00                   
ADDR_029DEB:        C9 10         CMP.B #$10                
ADDR_029DED:        90 4A         BCC CODE_029E39           
ADDR_029DEF:        C9 F0         CMP.B #$F0                
ADDR_029DF1:        B0 46         BCS CODE_029E39           
ADDR_029DF3:        99 00 02      STA.W OAM_ExtendedDispX,Y 
ADDR_029DF6:        BD 65 17      LDA.W $1765,X             
ADDR_029DF9:        AA            TAX                       
ADDR_029DFA:        BD 92 9D      LDA.W UnusedExSprGfxProp,X 
ADDR_029DFD:        99 03 02      STA.W OAM_ExtendedProp,Y  
ADDR_029E00:        A6 03         LDX $03                   
ADDR_029E02:        BD 86 9D      LDA.W UnusedExSprTiles,X  
ADDR_029E05:        99 02 02      STA.W OAM_ExtendedTile,Y  
ADDR_029E08:        98            TYA                       
ADDR_029E09:        4A            LSR                       
ADDR_029E0A:        4A            LSR                       
ADDR_029E0B:        A8            TAY                       
ADDR_029E0C:        A6 0F         LDX $0F                   
ADDR_029E0E:        BD 95 9D      LDA.W UnusedExSprTileSize,X 
ADDR_029E11:        99 20 04      STA.W $0420,Y             
ADDR_029E14:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
ADDR_029E17:        A5 00         LDA $00                   
ADDR_029E19:        38            SEC                       
ADDR_029E1A:        E5 7E         SBC $7E                   
ADDR_029E1C:        18            CLC                       
ADDR_029E1D:        69 04         ADC.B #$04                
ADDR_029E1F:        C9 08         CMP.B #$08                
ADDR_029E21:        B0 12         BCS Return029E35          
ADDR_029E23:        A5 01         LDA $01                   
ADDR_029E25:        38            SEC                       
ADDR_029E26:        E5 80         SBC $80                   
ADDR_029E28:        38            SEC                       
ADDR_029E29:        E9 10         SBC.B #$10                
ADDR_029E2B:        18            CLC                       
ADDR_029E2C:        69 10         ADC.B #$10                
ADDR_029E2E:        C9 10         CMP.B #$10                
ADDR_029E30:        B0 03         BCS Return029E35          
ADDR_029E32:        4C 69 A4      JMP.W CODE_02A469         

Return029E35:       60            RTS                       ; Return 


DATA_029E36:                      .db $08,$00,$F8

CODE_029E39:        9E 0B 17      STZ.W RAM_ExSpriteNum,X   
Return029E3C:       60            RTS                       ; Return 

LauncherArm:        A0 00         LDY.B #$00                
CODE_029E3F:        BD 6F 17      LDA.W $176F,X             
CODE_029E42:        F0 F5         BEQ CODE_029E39           
CODE_029E44:        C9 60         CMP.B #$60                
CODE_029E46:        B0 06         BCS CODE_029E4E           
CODE_029E48:        C8            INY                       
CODE_029E49:        C9 30         CMP.B #$30                
CODE_029E4B:        B0 01         BCS CODE_029E4E           
CODE_029E4D:        C8            INY                       
CODE_029E4E:        5A            PHY                       
CODE_029E4F:        A5 9D         LDA RAM_SpritesLocked     
CODE_029E51:        D0 09         BNE CODE_029E5C           
CODE_029E53:        B9 36 9E      LDA.W DATA_029E36,Y       
CODE_029E56:        9D 3D 17      STA.W RAM_ExSprSpeedY,X   
CODE_029E59:        20 60 B5      JSR.W CODE_02B560         
CODE_029E5C:        20 A4 A1      JSR.W CODE_02A1A4         
CODE_029E5F:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_029E62:        68            PLA                       
CODE_029E63:        C9 01         CMP.B #$01                
CODE_029E65:        A9 84         LDA.B #$84                
CODE_029E67:        90 02         BCC CODE_029E6B           
CODE_029E69:        A9 A4         LDA.B #$A4                
CODE_029E6B:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029E6E:        B9 03 02      LDA.W OAM_ExtendedProp,Y  
CODE_029E71:        29 00         AND.B #$00                
CODE_029E73:        09 13         ORA.B #$13                
CODE_029E75:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_029E78:        98            TYA                       
CODE_029E79:        4A            LSR                       
CODE_029E7A:        4A            LSR                       
CODE_029E7B:        A8            TAY                       
CODE_029E7C:        A9 02         LDA.B #$02                
CODE_029E7E:        99 20 04      STA.W $0420,Y             
Return029E81:       60            RTS                       ; Return 


LavaSplashTiles2:                 .db $D7,$C7,$D6,$C6

LavaSplash:         A5 9D         LDA RAM_SpritesLocked     
CODE_029E88:        D0 13         BNE CODE_029E9D           
CODE_029E8A:        20 54 B5      JSR.W CODE_02B554         
CODE_029E8D:        20 60 B5      JSR.W CODE_02B560         
CODE_029E90:        BD 3D 17      LDA.W RAM_ExSprSpeedY,X   
CODE_029E93:        18            CLC                       
CODE_029E94:        69 02         ADC.B #$02                
CODE_029E96:        9D 3D 17      STA.W RAM_ExSprSpeedY,X   
CODE_029E99:        C9 30         CMP.B #$30                
CODE_029E9B:        10 49         BPL CODE_029EE6           
CODE_029E9D:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_029EA0:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_029EA3:        38            SEC                       
CODE_029EA4:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_029EA6:        85 00         STA $00                   
CODE_029EA8:        BD 33 17      LDA.W RAM_ExSpriteXHi,X   
CODE_029EAB:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_029EAD:        D0 37         BNE CODE_029EE6           
CODE_029EAF:        A5 00         LDA $00                   
CODE_029EB1:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_029EB4:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_029EB7:        38            SEC                       
CODE_029EB8:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_029EBA:        C9 F0         CMP.B #$F0                
CODE_029EBC:        B0 28         BCS CODE_029EE6           
CODE_029EBE:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_029EC1:        BD 6F 17      LDA.W $176F,X             
CODE_029EC4:        4A            LSR                       
CODE_029EC5:        4A            LSR                       
CODE_029EC6:        4A            LSR                       
CODE_029EC7:        EA            NOP                       
CODE_029EC8:        EA            NOP                       
CODE_029EC9:        29 03         AND.B #$03                
CODE_029ECB:        AA            TAX                       
CODE_029ECC:        BD 82 9E      LDA.W LavaSplashTiles2,X  
CODE_029ECF:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029ED2:        A5 64         LDA $64                   
CODE_029ED4:        09 05         ORA.B #$05                
CODE_029ED6:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_029ED9:        98            TYA                       
CODE_029EDA:        4A            LSR                       
CODE_029EDB:        4A            LSR                       
CODE_029EDC:        A8            TAY                       
CODE_029EDD:        A9 00         LDA.B #$00                
CODE_029EDF:        99 20 04      STA.W $0420,Y             
CODE_029EE2:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return029EE5:       60            RTS                       ; Return 

CODE_029EE6:        9E 0B 17      STZ.W RAM_ExSpriteNum,X   ; Clear extended sprite 
Return029EE9:       60            RTS                       ; Return 


DATA_029EEA:                      .db $00,$01,$00,$FF

WaterBubble:        A5 9D         LDA RAM_SpritesLocked     
CODE_029EF0:        D0 38         BNE CODE_029F2A           
CODE_029EF2:        FE 65 17      INC.W $1765,X             
CODE_029EF5:        BD 65 17      LDA.W $1765,X             
CODE_029EF8:        29 30         AND.B #$30                
CODE_029EFA:        F0 0C         BEQ CODE_029F08           
CODE_029EFC:        DE 15 17      DEC.W RAM_ExSpriteYLo,X   
CODE_029EFF:        BC 15 17      LDY.W RAM_ExSpriteYLo,X   
CODE_029F02:        C8            INY                       
CODE_029F03:        D0 03         BNE CODE_029F08           
CODE_029F05:        DE 29 17      DEC.W RAM_ExSpriteYHi,X   
CODE_029F08:        8A            TXA                       
CODE_029F09:        45 13         EOR RAM_FrameCounter      
CODE_029F0B:        4A            LSR                       
CODE_029F0C:        B0 1C         BCS CODE_029F2A           
CODE_029F0E:        20 6E A5      JSR.W CODE_02A56E         
CODE_029F11:        B0 14         BCS CODE_029F27           
CODE_029F13:        A5 85         LDA RAM_IsWaterLevel      
CODE_029F15:        D0 13         BNE CODE_029F2A           
CODE_029F17:        A5 0C         LDA $0C                   
CODE_029F19:        C9 06         CMP.B #$06                
CODE_029F1B:        90 0D         BCC CODE_029F2A           
CODE_029F1D:        A5 0F         LDA $0F                   
CODE_029F1F:        F0 06         BEQ CODE_029F27           
CODE_029F21:        A5 0D         LDA $0D                   
CODE_029F23:        C9 06         CMP.B #$06                
CODE_029F25:        90 03         BCC CODE_029F2A           
CODE_029F27:        4C 11 A2      JMP.W CODE_02A211         

CODE_029F2A:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_029F2D:        C5 1C         CMP RAM_ScreenBndryYLo    
CODE_029F2F:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
CODE_029F32:        E5 1D         SBC RAM_ScreenBndryYHi    
CODE_029F34:        D0 F1         BNE CODE_029F27           
CODE_029F36:        20 A4 A1      JSR.W CODE_02A1A4         
CODE_029F39:        BD 65 17      LDA.W $1765,X             
CODE_029F3C:        29 0C         AND.B #$0C                
CODE_029F3E:        4A            LSR                       
CODE_029F3F:        4A            LSR                       
CODE_029F40:        A8            TAY                       
CODE_029F41:        B9 EA 9E      LDA.W DATA_029EEA,Y       
CODE_029F44:        85 00         STA $00                   
CODE_029F46:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_029F49:        B9 00 02      LDA.W OAM_ExtendedDispX,Y 
CODE_029F4C:        18            CLC                       
CODE_029F4D:        65 00         ADC $00                   
CODE_029F4F:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_029F52:        B9 01 02      LDA.W OAM_ExtendedDispY,Y 
CODE_029F55:        18            CLC                       
CODE_029F56:        69 05         ADC.B #$05                
CODE_029F58:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_029F5B:        A9 1C         LDA.B #$1C                
CODE_029F5D:        99 02 02      STA.W OAM_ExtendedTile,Y  
Return029F60:       60            RTS                       ; Return 

YoshiFireball:      A5 9D         LDA RAM_SpritesLocked     
CODE_029F63:        D0 09         BNE CODE_029F6E           
CODE_029F65:        20 54 B5      JSR.W CODE_02B554         
CODE_029F68:        20 60 B5      JSR.W CODE_02B560         
CODE_029F6B:        20 AC A0      JSR.W ProcessFireball     
CODE_029F6E:        20 A4 A1      JSR.W CODE_02A1A4         
CODE_029F71:        A5 14         LDA RAM_FrameCounterB     
CODE_029F73:        4A            LSR                       
CODE_029F74:        4A            LSR                       
CODE_029F75:        4A            LSR                       
CODE_029F76:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_029F79:        A9 04         LDA.B #$04                
CODE_029F7B:        90 02         BCC CODE_029F7F           
CODE_029F7D:        A9 2B         LDA.B #$2B                
CODE_029F7F:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_029F82:        BD 47 17      LDA.W RAM_ExSprSpeedX,X   
CODE_029F85:        29 80         AND.B #$80                
CODE_029F87:        49 80         EOR.B #$80                
CODE_029F89:        4A            LSR                       
CODE_029F8A:        09 35         ORA.B #$35                
CODE_029F8C:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_029F8F:        98            TYA                       
CODE_029F90:        4A            LSR                       
CODE_029F91:        4A            LSR                       
CODE_029F92:        A8            TAY                       
CODE_029F93:        A9 02         LDA.B #$02                
CODE_029F95:        99 20 04      STA.W $0420,Y             
Return029F98:       60            RTS                       ; Return 


DATA_029F99:                      .db $00,$B8,$C0,$C8,$D0,$D8,$E0,$E8
                                  .db $F0

DATA_029FA2:                      .db $00

DATA_029FA3:                      .db $05,$03

DATA_029FA5:                      .db $02,$02,$02,$02,$02,$02,$F8,$FC
                                  .db $A0,$A4

MarioFireball:      A5 9D         LDA RAM_SpritesLocked     
CODE_029FB1:        D0 79         BNE CODE_02A02C           
CODE_029FB3:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_029FB6:        C5 1C         CMP RAM_ScreenBndryYLo    
CODE_029FB8:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
CODE_029FBB:        E5 1D         SBC RAM_ScreenBndryYHi    
CODE_029FBD:        F0 03         BEQ CODE_029FC2           
CODE_029FBF:        4C 11 A2      JMP.W CODE_02A211         

CODE_029FC2:        FE 65 17      INC.W $1765,X             
CODE_029FC5:        20 AC A0      JSR.W ProcessFireball     
CODE_029FC8:        BD 3D 17      LDA.W RAM_ExSprSpeedY,X   
CODE_029FCB:        C9 30         CMP.B #$30                
CODE_029FCD:        10 09         BPL CODE_029FD8           
CODE_029FCF:        BD 3D 17      LDA.W RAM_ExSprSpeedY,X   
CODE_029FD2:        18            CLC                       
CODE_029FD3:        69 04         ADC.B #$04                
CODE_029FD5:        9D 3D 17      STA.W RAM_ExSprSpeedY,X   
CODE_029FD8:        20 6E A5      JSR.W CODE_02A56E         
CODE_029FDB:        90 33         BCC CODE_02A010           
CODE_029FDD:        FE 5B 17      INC.W $175B,X             
CODE_029FE0:        BD 5B 17      LDA.W $175B,X             
CODE_029FE3:        C9 02         CMP.B #$02                
CODE_029FE5:        B0 5B         BCS CODE_02A042           
CODE_029FE7:        BD 47 17      LDA.W RAM_ExSprSpeedX,X   
CODE_029FEA:        10 07         BPL CODE_029FF3           
CODE_029FEC:        A5 0B         LDA $0B                   
CODE_029FEE:        49 FF         EOR.B #$FF                
CODE_029FF0:        1A            INC A                     
CODE_029FF1:        85 0B         STA $0B                   
CODE_029FF3:        A5 0B         LDA $0B                   
CODE_029FF5:        18            CLC                       
CODE_029FF6:        69 04         ADC.B #$04                
CODE_029FF8:        A8            TAY                       
CODE_029FF9:        B9 99 9F      LDA.W DATA_029F99,Y       
CODE_029FFC:        9D 3D 17      STA.W RAM_ExSprSpeedY,X   
CODE_029FFF:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_02A002:        38            SEC                       
CODE_02A003:        F9 A2 9F      SBC.W DATA_029FA2,Y       
CODE_02A006:        9D 15 17      STA.W RAM_ExSpriteYLo,X   
CODE_02A009:        B0 03         BCS CODE_02A00E           
CODE_02A00B:        DE 29 17      DEC.W RAM_ExSpriteYHi,X   
CODE_02A00E:        80 03         BRA CODE_02A013           

CODE_02A010:        9E 5B 17      STZ.W $175B,X             
CODE_02A013:        A0 00         LDY.B #$00                
CODE_02A015:        BD 47 17      LDA.W RAM_ExSprSpeedX,X   
CODE_02A018:        10 01         BPL CODE_02A01B           
CODE_02A01A:        88            DEY                       
CODE_02A01B:        18            CLC                       
CODE_02A01C:        7D 1F 17      ADC.W RAM_ExSpriteXLo,X   
CODE_02A01F:        9D 1F 17      STA.W RAM_ExSpriteXLo,X   
CODE_02A022:        98            TYA                       
CODE_02A023:        7D 33 17      ADC.W RAM_ExSpriteXHi,X   
CODE_02A026:        9D 33 17      STA.W RAM_ExSpriteXHi,X   
CODE_02A029:        20 60 B5      JSR.W CODE_02B560         
CODE_02A02C:        A5 A5         LDA $A5                   
CODE_02A02E:        C9 A9         CMP.B #$A9                
CODE_02A030:        F0 09         BEQ CODE_02A03B           
CODE_02A032:        AD 9B 0D      LDA.W $0D9B               
CODE_02A035:        10 04         BPL CODE_02A03B           
CODE_02A037:        29 40         AND.B #$40                
CODE_02A039:        D0 14         BNE ADDR_02A04F           
CODE_02A03B:        BC A3 9F      LDY.W DATA_029FA3,X       
CODE_02A03E:        20 A7 A1      JSR.W CODE_02A1A7         
Return02A041:       60            RTS                       ; Return 

CODE_02A042:        20 2C A0      JSR.W CODE_02A02C         
CODE_02A045:        A9 01         LDA.B #$01                ; \ Play sound effect 
CODE_02A047:        8D F9 1D      STA.W $1DF9               ; / 
CODE_02A04A:        A9 0F         LDA.B #$0F                
CODE_02A04C:        4C E0 A4      JMP.W CODE_02A4E0         

ADDR_02A04F:        BC A5 9F      LDY.W DATA_029FA5,X       
ADDR_02A052:        BD 47 17      LDA.W RAM_ExSprSpeedX,X   
ADDR_02A055:        29 80         AND.B #$80                
ADDR_02A057:        4A            LSR                       
ADDR_02A058:        85 00         STA $00                   
ADDR_02A05A:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
ADDR_02A05D:        38            SEC                       
ADDR_02A05E:        E5 1A         SBC RAM_ScreenBndryXLo    
ADDR_02A060:        C9 F8         CMP.B #$F8                
ADDR_02A062:        B0 45         BCS ADDR_02A0A9           
ADDR_02A064:        99 00 03      STA.W OAM_DispX,Y         
ADDR_02A067:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
ADDR_02A06A:        38            SEC                       
ADDR_02A06B:        E5 1C         SBC RAM_ScreenBndryYLo    
ADDR_02A06D:        C9 F0         CMP.B #$F0                
ADDR_02A06F:        B0 38         BCS ADDR_02A0A9           
ADDR_02A071:        99 01 03      STA.W OAM_DispY,Y         
ADDR_02A074:        BD 79 17      LDA.W $1779,X             
ADDR_02A077:        85 01         STA $01                   
ADDR_02A079:        BD 65 17      LDA.W $1765,X             
ADDR_02A07C:        4A            LSR                       
ADDR_02A07D:        4A            LSR                       
ADDR_02A07E:        29 03         AND.B #$03                
ADDR_02A080:        AA            TAX                       
ADDR_02A081:        BD 5B A1      LDA.W FireballTiles,X     
ADDR_02A084:        99 02 03      STA.W OAM_Tile,Y          
ADDR_02A087:        BD 5F A1      LDA.W DATA_02A15F,X       
ADDR_02A08A:        45 00         EOR $00                   
ADDR_02A08C:        05 64         ORA $64                   
ADDR_02A08E:        99 03 03      STA.W OAM_Prop,Y          
ADDR_02A091:        A6 01         LDX $01                   
ADDR_02A093:        F0 07         BEQ ADDR_02A09C           
ADDR_02A095:        29 CF         AND.B #$CF                
ADDR_02A097:        09 10         ORA.B #$10                
ADDR_02A099:        99 03 03      STA.W OAM_Prop,Y          
ADDR_02A09C:        98            TYA                       
ADDR_02A09D:        4A            LSR                       
ADDR_02A09E:        4A            LSR                       
ADDR_02A09F:        A8            TAY                       
ADDR_02A0A0:        A9 00         LDA.B #$00                
ADDR_02A0A2:        99 60 04      STA.W OAM_TileSize,Y      
ADDR_02A0A5:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return02A0A8:       60            RTS                       ; Return 

ADDR_02A0A9:        4C 11 A2      JMP.W CODE_02A211         

ProcessFireball:    8A            TXA                       ; \ Return every other frame 
CODE_02A0AD:        45 13         EOR RAM_FrameCounter      ;  | 
CODE_02A0AF:        29 03         AND.B #$03                ;  | 
CODE_02A0B1:        D0 F5         BNE Return02A0A8          ; / 
CODE_02A0B3:        DA            PHX                       
CODE_02A0B4:        9B            TXY                       
CODE_02A0B5:        8C 5E 18      STY.W $185E               ; $185E = Y = Extended sprite index 
CODE_02A0B8:        A2 09         LDX.B #$09                ; Loop over sprites: 
FireRtLoopStart:    8E E9 15      STX.W $15E9               
CODE_02A0BD:        BD C8 14      LDA.W $14C8,X             ; \ Skip current sprite if status < 8 
CODE_02A0C0:        C9 08         CMP.B #$08                ;  | 
CODE_02A0C2:        90 7F         BCC FireRtNextSprite      ; / 
CODE_02A0C4:        BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ Skip current sprite if... 
CODE_02A0C7:        29 02         AND.B #$02                ;  | ...invincible to fire/cape/etc 
CODE_02A0C9:        1D D0 15      ORA.W $15D0,X             ;  | ...sprite being eaten... 
CODE_02A0CC:        1D 32 16      ORA.W RAM_SprBehindScrn,X ;  | ...interactions disabled... 
CODE_02A0CF:        59 79 17      EOR.W $1779,Y             
CODE_02A0D2:        D0 6F         BNE FireRtNextSprite      ; / 
CODE_02A0D4:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_02A0D8:        20 47 A5      JSR.W CODE_02A547         
CODE_02A0DB:        22 2B B7 03   JSL.L CheckForContact     
CODE_02A0DF:        90 62         BCC FireRtNextSprite      
CODE_02A0E1:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   ; \ if Yoshi fireball... 
CODE_02A0E4:        C9 11         CMP.B #$11                ;  | 
CODE_02A0E6:        F0 06         BEQ CODE_02A0EE           ;  | 
CODE_02A0E8:        DA            PHX                       ;  | 
CODE_02A0E9:        BB            TYX                       ;  | 
CODE_02A0EA:        20 45 A0      JSR.W CODE_02A045         ;  | ...? 
CODE_02A0ED:        FA            PLX                       ; / 
CODE_02A0EE:        BD 6E 16      LDA.W RAM_Tweaker166E,X   ; \ Skip sprite if fire killing is disabled 
CODE_02A0F1:        29 10         AND.B #$10                ;  | 
CODE_02A0F3:        D0 4E         BNE FireRtNextSprite      ; / 
CODE_02A0F5:        BD 0F 19      LDA.W RAM_Tweaker190F,X   ; \ Branch if takes 1 fireball to kill 
CODE_02A0F8:        29 08         AND.B #$08                ;  | 
CODE_02A0FA:        F0 28         BEQ TurnSpriteToCoin      ; / 
CODE_02A0FC:        FE 28 15      INC.W $1528,X             ; Increase times Chuck hit by fireball 
CODE_02A0FF:        BD 28 15      LDA.W $1528,X             ; \ If fire count >= 5, kill Chuck: 
CODE_02A102:        C9 05         CMP.B #$05                ;  | 
CODE_02A104:        90 3D         BCC FireRtNextSprite      ;  | 
ChuckFireKill:      A9 02         LDA.B #$02                ;  | Play sound effect 
CODE_02A108:        8D F9 1D      STA.W $1DF9               ;  | 
CODE_02A10B:        A9 02         LDA.B #$02                ;  | Sprite status = Killed 
CODE_02A10D:        9D C8 14      STA.W $14C8,X             ;  | 
CODE_02A110:        A9 D0         LDA.B #$D0                ;  | Set death Y speed 
CODE_02A112:        95 AA         STA RAM_SpriteSpeedY,X    ;  | 
CODE_02A114:        20 8D 84      JSR.W SubHorzPosBnk2      
CODE_02A117:        B9 51 A1      LDA.W FireKillSpeedX,Y    ;  | Set death X speed 
CODE_02A11A:        95 B6         STA RAM_SpriteSpeedX,X    ;  | 
CODE_02A11C:        A9 04         LDA.B #$04                ;  | Increase points 
CODE_02A11E:        22 E5 AC 02   JSL.L GivePoints          ;  | 
CODE_02A122:        80 1F         BRA FireRtNextSprite      ; / 

TurnSpriteToCoin:   A9 03         LDA.B #$03                ; \ Turn sprite into coin: 
CODE_02A126:        8D F9 1D      STA.W $1DF9               ;  | Play sound effect 
CODE_02A129:        A9 21         LDA.B #$21                ;  | Sprite = Moving Coin 
CODE_02A12B:        95 9E         STA RAM_SpriteNum,X       ;  | 
CODE_02A12D:        A9 08         LDA.B #$08                ;  | Sprite status = Normal 
CODE_02A12F:        9D C8 14      STA.W $14C8,X             ;  | 
CODE_02A132:        22 D2 F7 07   JSL.L InitSpriteTables    ;  | Reset sprite tables 
CODE_02A136:        A9 D0         LDA.B #$D0                ;  | Set upward speed 
CODE_02A138:        95 AA         STA RAM_SpriteSpeedY,X    ;  | 
CODE_02A13A:        20 8D 84      JSR.W SubHorzPosBnk2      
CODE_02A13D:        98            TYA                       
CODE_02A13E:        49 01         EOR.B #$01                
CODE_02A140:        9D 7C 15      STA.W RAM_SpriteDir,X     ; / 
FireRtNextSprite:   AC 5E 18      LDY.W $185E               
CODE_02A146:        CA            DEX                       
CODE_02A147:        30 03         BMI CODE_02A14C           
CODE_02A149:        4C BA A0      JMP.W FireRtLoopStart     

CODE_02A14C:        FA            PLX                       ; $15E9 = Sprite index 
CODE_02A14D:        8E E9 15      STX.W $15E9               ; $15E9 = Sprite index 
Return02A150:       60            RTS                       ; Return 


FireKillSpeedX:                   .db $F0,$10

DATA_02A153:                      .db $90,$94,$98,$9C,$A0,$A4,$A8,$AC
FireballTiles:                    .db $2C,$2D,$2C,$2D

DATA_02A15F:                      .db $04,$04,$C4,$C4

ReznorFireTiles:                  .db $26,$2A,$26,$2A

DATA_02A167:                      .db $35,$35,$F5,$F5

ReznorFireball:     A5 9D         LDA RAM_SpritesLocked     
CODE_02A16D:        D0 09         BNE CODE_02A178           
CODE_02A16F:        20 54 B5      JSR.W CODE_02B554         
CODE_02A172:        20 60 B5      JSR.W CODE_02B560         
CODE_02A175:        20 F6 A3      JSR.W CODE_02A3F6         
CODE_02A178:        AD 9B 0D      LDA.W $0D9B               
CODE_02A17B:        10 27         BPL CODE_02A1A4           
CODE_02A17D:        20 A4 A1      JSR.W CODE_02A1A4         
CODE_02A180:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_02A183:        A5 14         LDA RAM_FrameCounterB     
CODE_02A185:        4A            LSR                       
CODE_02A186:        4A            LSR                       
CODE_02A187:        29 03         AND.B #$03                
CODE_02A189:        DA            PHX                       
CODE_02A18A:        AA            TAX                       
CODE_02A18B:        BD 63 A1      LDA.W ReznorFireTiles,X   
CODE_02A18E:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02A191:        BD 67 A1      LDA.W DATA_02A167,X       
CODE_02A194:        45 00         EOR $00                   
CODE_02A196:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02A199:        98            TYA                       
CODE_02A19A:        4A            LSR                       
CODE_02A19B:        4A            LSR                       
CODE_02A19C:        AA            TAX                       
CODE_02A19D:        A9 02         LDA.B #$02                
CODE_02A19F:        9D 20 04      STA.W $0420,X             
CODE_02A1A2:        FA            PLX                       
Return02A1A3:       60            RTS                       ; Return 

CODE_02A1A4:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_02A1A7:        BD 47 17      LDA.W RAM_ExSprSpeedX,X   
CODE_02A1AA:        29 80         AND.B #$80                
CODE_02A1AC:        49 80         EOR.B #$80                
CODE_02A1AE:        4A            LSR                       
CODE_02A1AF:        85 00         STA $00                   
CODE_02A1B1:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_02A1B4:        38            SEC                       
CODE_02A1B5:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02A1B7:        85 01         STA $01                   
CODE_02A1B9:        BD 33 17      LDA.W RAM_ExSpriteXHi,X   
CODE_02A1BC:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_02A1BE:        D0 51         BNE CODE_02A211           
CODE_02A1C0:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_02A1C3:        38            SEC                       
CODE_02A1C4:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02A1C6:        85 02         STA $02                   
CODE_02A1C8:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
CODE_02A1CB:        E5 1D         SBC RAM_ScreenBndryYHi    
CODE_02A1CD:        D0 42         BNE CODE_02A211           
CODE_02A1CF:        A5 02         LDA $02                   
CODE_02A1D1:        C9 F0         CMP.B #$F0                
CODE_02A1D3:        B0 3C         BCS CODE_02A211           
CODE_02A1D5:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_02A1D8:        A5 01         LDA $01                   
CODE_02A1DA:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_02A1DD:        BD 79 17      LDA.W $1779,X             
CODE_02A1E0:        85 01         STA $01                   
CODE_02A1E2:        A5 14         LDA RAM_FrameCounterB     
CODE_02A1E4:        4A            LSR                       
CODE_02A1E5:        4A            LSR                       
CODE_02A1E6:        29 03         AND.B #$03                
CODE_02A1E8:        AA            TAX                       
CODE_02A1E9:        BD 5B A1      LDA.W FireballTiles,X     
CODE_02A1EC:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02A1EF:        BD 5F A1      LDA.W DATA_02A15F,X       
CODE_02A1F2:        45 00         EOR $00                   
CODE_02A1F4:        05 64         ORA $64                   
CODE_02A1F6:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02A1F9:        A6 01         LDX $01                   
CODE_02A1FB:        F0 07         BEQ CODE_02A204           
ADDR_02A1FD:        29 CF         AND.B #$CF                
ADDR_02A1FF:        09 10         ORA.B #$10                
ADDR_02A201:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02A204:        98            TYA                       
CODE_02A205:        4A            LSR                       
CODE_02A206:        4A            LSR                       
CODE_02A207:        A8            TAY                       
CODE_02A208:        A9 00         LDA.B #$00                
CODE_02A20A:        99 20 04      STA.W $0420,Y             
CODE_02A20D:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return02A210:       60            RTS                       ; Return 

CODE_02A211:        A9 00         LDA.B #$00                ; \ Clear extended sprite 
CODE_02A213:        9D 0B 17      STA.W RAM_ExSpriteNum,X   ; / 
Return02A216:       60            RTS                       ; Return 


SmallFlameTiles:                  .db $AC,$AD

FlameRemnant:       A5 9D         LDA RAM_SpritesLocked     
CODE_02A21B:        D0 12         BNE CODE_02A22F           
CODE_02A21D:        FE 65 17      INC.W $1765,X             
CODE_02A220:        BD 6F 17      LDA.W $176F,X             
CODE_02A223:        F0 EC         BEQ CODE_02A211           
CODE_02A225:        C9 50         CMP.B #$50                
CODE_02A227:        B0 06         BCS CODE_02A22F           
CODE_02A229:        29 01         AND.B #$01                
CODE_02A22B:        D0 26         BNE Return02A253          
CODE_02A22D:        F0 03         BEQ CODE_02A232           
CODE_02A22F:        20 F6 A3      JSR.W CODE_02A3F6         
CODE_02A232:        20 A4 A1      JSR.W CODE_02A1A4         
CODE_02A235:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_02A238:        BD 65 17      LDA.W $1765,X             
CODE_02A23B:        4A            LSR                       
CODE_02A23C:        4A            LSR                       
CODE_02A23D:        29 01         AND.B #$01                
CODE_02A23F:        AA            TAX                       
CODE_02A240:        BD 17 A2      LDA.W SmallFlameTiles,X   
CODE_02A243:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02A246:        B9 03 02      LDA.W OAM_ExtendedProp,Y  
CODE_02A249:        29 3F         AND.B #$3F                
CODE_02A24B:        09 05         ORA.B #$05                
CODE_02A24D:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02A250:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return02A253:       60            RTS                       ; Return 

Baseball:           A5 9D         LDA RAM_SpritesLocked     
CODE_02A256:        D0 12         BNE CODE_02A26A           
CODE_02A258:        20 54 B5      JSR.W CODE_02B554         
CODE_02A25B:        FE 65 17      INC.W $1765,X             
CODE_02A25E:        A5 13         LDA RAM_FrameCounter      
CODE_02A260:        29 01         AND.B #$01                
CODE_02A262:        D0 03         BNE CODE_02A267           
CODE_02A264:        FE 65 17      INC.W $1765,X             
CODE_02A267:        20 F6 A3      JSR.W CODE_02A3F6         
CODE_02A26A:        BD 0B 17      LDA.W RAM_ExSpriteNum,X   
CODE_02A26D:        C9 0D         CMP.B #$0D                
CODE_02A26F:        D0 52         BNE CODE_02A2C3           
CODE_02A271:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_02A274:        38            SEC                       
CODE_02A275:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02A277:        85 00         STA $00                   
CODE_02A279:        BD 33 17      LDA.W RAM_ExSpriteXHi,X   
CODE_02A27C:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_02A27E:        F0 07         BEQ CODE_02A287           
CODE_02A280:        5D 47 17      EOR.W RAM_ExSprSpeedX,X   
CODE_02A283:        10 3A         BPL CODE_02A2BF           
CODE_02A285:        30 37         BMI Return02A2BE          
CODE_02A287:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_02A28A:        A5 00         LDA $00                   
CODE_02A28C:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_02A28F:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_02A292:        38            SEC                       
CODE_02A293:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02A295:        85 01         STA $01                   
CODE_02A297:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
CODE_02A29A:        E5 1D         SBC RAM_ScreenBndryYHi    
CODE_02A29C:        D0 21         BNE CODE_02A2BF           
CODE_02A29E:        A5 01         LDA $01                   
CODE_02A2A0:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_02A2A3:        A9 AD         LDA.B #$AD                
CODE_02A2A5:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02A2A8:        A5 14         LDA RAM_FrameCounterB     
CODE_02A2AA:        0A            ASL                       
CODE_02A2AB:        0A            ASL                       
CODE_02A2AC:        0A            ASL                       
CODE_02A2AD:        0A            ASL                       
CODE_02A2AE:        29 C0         AND.B #$C0                
CODE_02A2B0:        09 39         ORA.B #$39                
CODE_02A2B2:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02A2B5:        98            TYA                       
CODE_02A2B6:        4A            LSR                       
CODE_02A2B7:        4A            LSR                       
CODE_02A2B8:        A8            TAY                       
CODE_02A2B9:        A9 00         LDA.B #$00                
CODE_02A2BB:        99 20 04      STA.W $0420,Y             
Return02A2BE:       60            RTS                       ; Return 

CODE_02A2BF:        9E 0B 17      STZ.W RAM_ExSpriteNum,X   ; Clear extended sprite 
Return02A2C2:       60            RTS                       ; Return 

CODE_02A2C3:        20 17 A3      JSR.W CODE_02A317         
CODE_02A2C6:        B9 02 02      LDA.W OAM_ExtendedTile,Y  
CODE_02A2C9:        C9 26         CMP.B #$26                
CODE_02A2CB:        A9 80         LDA.B #$80                
CODE_02A2CD:        B0 02         BCS CODE_02A2D1           
CODE_02A2CF:        A9 82         LDA.B #$82                
CODE_02A2D1:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02A2D4:        B9 03 02      LDA.W OAM_ExtendedProp,Y  
CODE_02A2D7:        29 F1         AND.B #$F1                
CODE_02A2D9:        09 02         ORA.B #$02                
CODE_02A2DB:        99 03 02      STA.W OAM_ExtendedProp,Y  
Return02A2DE:       60            RTS                       ; Return 


HammerTiles:                      .db $08,$6D,$6D,$08,$08,$6D,$6D,$08
HammerGfxProp:                    .db $47,$47,$07,$07,$87,$87,$C7,$C7

Hammer:             A5 9D         LDA RAM_SpritesLocked     
CODE_02A2F1:        D0 19         BNE CODE_02A30C           
CODE_02A2F3:        20 54 B5      JSR.W CODE_02B554         
CODE_02A2F6:        20 60 B5      JSR.W CODE_02B560         
CODE_02A2F9:        BD 3D 17      LDA.W RAM_ExSprSpeedY,X   
CODE_02A2FC:        C9 40         CMP.B #$40                
CODE_02A2FE:        10 06         BPL CODE_02A306           
CODE_02A300:        FE 3D 17      INC.W RAM_ExSprSpeedY,X   
CODE_02A303:        FE 3D 17      INC.W RAM_ExSprSpeedY,X   
CODE_02A306:        20 F6 A3      JSR.W CODE_02A3F6         
CODE_02A309:        FE 65 17      INC.W $1765,X             
CODE_02A30C:        BD 0B 17      LDA.W RAM_ExSpriteNum,X   
CODE_02A30F:        C9 0B         CMP.B #$0B                
CODE_02A311:        D0 04         BNE CODE_02A317           
CODE_02A313:        20 78 A1      JSR.W CODE_02A178         
Return02A316:       60            RTS                       ; Return 

CODE_02A317:        20 A4 A1      JSR.W CODE_02A1A4         
CODE_02A31A:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_02A31D:        BD 65 17      LDA.W $1765,X             
CODE_02A320:        4A            LSR                       
CODE_02A321:        4A            LSR                       
CODE_02A322:        4A            LSR                       
CODE_02A323:        29 07         AND.B #$07                
CODE_02A325:        DA            PHX                       
CODE_02A326:        AA            TAX                       
CODE_02A327:        BD DF A2      LDA.W HammerTiles,X       
CODE_02A32A:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02A32D:        BD E7 A2      LDA.W HammerGfxProp,X     
CODE_02A330:        45 00         EOR $00                   
CODE_02A332:        49 40         EOR.B #$40                
CODE_02A334:        05 64         ORA $64                   
CODE_02A336:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02A339:        98            TYA                       
CODE_02A33A:        4A            LSR                       
CODE_02A33B:        4A            LSR                       
CODE_02A33C:        AA            TAX                       
CODE_02A33D:        A9 02         LDA.B #$02                
CODE_02A33F:        9D 20 04      STA.W $0420,X             
CODE_02A342:        FA            PLX                       
Return02A343:       60            RTS                       ; Return 

CODE_02A344:        4C 11 A2      JMP.W CODE_02A211         


DustCloudTiles:                   .db $66,$64,$60,$62

DATA_02A34B:                      .db $00,$40,$C0,$80

SmokePuff:          BD 6F 17      LDA.W $176F,X             
CODE_02A352:        F0 F0         BEQ CODE_02A344           
CODE_02A354:        AD 0F 14      LDA.W $140F               
CODE_02A357:        D0 09         BNE CODE_02A362           
CODE_02A359:        AD 9B 0D      LDA.W $0D9B               
CODE_02A35C:        10 04         BPL CODE_02A362           
CODE_02A35E:        29 40         AND.B #$40                
CODE_02A360:        D0 4F         BNE ADDR_02A3B1           
CODE_02A362:        BC 53 A1      LDY.W DATA_02A153,X       
CODE_02A365:        E0 08         CPX.B #$08                
CODE_02A367:        90 03         BCC CODE_02A36C           
CODE_02A369:        BC A3 9F      LDY.W DATA_029FA3,X       
CODE_02A36C:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_02A36F:        38            SEC                       
CODE_02A370:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02A372:        C9 F8         CMP.B #$F8                
CODE_02A374:        B0 38         BCS CODE_02A3AE           
CODE_02A376:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_02A379:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_02A37C:        38            SEC                       
CODE_02A37D:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02A37F:        C9 F0         CMP.B #$F0                
CODE_02A381:        B0 2B         BCS CODE_02A3AE           
CODE_02A383:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_02A386:        BD 6F 17      LDA.W $176F,X             
CODE_02A389:        4A            LSR                       
CODE_02A38A:        4A            LSR                       
CODE_02A38B:        AA            TAX                       
CODE_02A38C:        BD 47 A3      LDA.W DustCloudTiles,X    
CODE_02A38F:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02A392:        A5 14         LDA RAM_FrameCounterB     
CODE_02A394:        4A            LSR                       
CODE_02A395:        4A            LSR                       
CODE_02A396:        29 03         AND.B #$03                
CODE_02A398:        AA            TAX                       
CODE_02A399:        BD 4B A3      LDA.W DATA_02A34B,X       
CODE_02A39C:        05 64         ORA $64                   
CODE_02A39E:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02A3A1:        98            TYA                       
CODE_02A3A2:        4A            LSR                       
CODE_02A3A3:        4A            LSR                       
CODE_02A3A4:        A8            TAY                       
CODE_02A3A5:        A9 02         LDA.B #$02                
CODE_02A3A7:        99 20 04      STA.W $0420,Y             
CODE_02A3AA:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return02A3AD:       60            RTS                       ; Return 

CODE_02A3AE:        4C 11 A2      JMP.W CODE_02A211         

ADDR_02A3B1:        BC A5 9F      LDY.W DATA_029FA5,X       
ADDR_02A3B4:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
ADDR_02A3B7:        38            SEC                       
ADDR_02A3B8:        E5 1A         SBC RAM_ScreenBndryXLo    
ADDR_02A3BA:        C9 F8         CMP.B #$F8                
ADDR_02A3BC:        B0 F0         BCS CODE_02A3AE           
ADDR_02A3BE:        99 00 03      STA.W OAM_DispX,Y         
ADDR_02A3C1:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
ADDR_02A3C4:        38            SEC                       
ADDR_02A3C5:        E5 1C         SBC RAM_ScreenBndryYLo    
ADDR_02A3C7:        C9 F0         CMP.B #$F0                
ADDR_02A3C9:        B0 E3         BCS CODE_02A3AE           
ADDR_02A3CB:        99 01 03      STA.W OAM_DispY,Y         
ADDR_02A3CE:        BD 6F 17      LDA.W $176F,X             
ADDR_02A3D1:        4A            LSR                       
ADDR_02A3D2:        4A            LSR                       
ADDR_02A3D3:        AA            TAX                       
ADDR_02A3D4:        BD 47 A3      LDA.W DustCloudTiles,X    
ADDR_02A3D7:        99 02 03      STA.W OAM_Tile,Y          
ADDR_02A3DA:        A5 14         LDA RAM_FrameCounterB     
ADDR_02A3DC:        4A            LSR                       
ADDR_02A3DD:        4A            LSR                       
ADDR_02A3DE:        29 03         AND.B #$03                
ADDR_02A3E0:        AA            TAX                       
ADDR_02A3E1:        BD 4B A3      LDA.W DATA_02A34B,X       
ADDR_02A3E4:        05 64         ORA $64                   
ADDR_02A3E6:        99 03 03      STA.W OAM_Prop,Y          
ADDR_02A3E9:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
ADDR_02A3EC:        98            TYA                       
ADDR_02A3ED:        4A            LSR                       
ADDR_02A3EE:        4A            LSR                       
ADDR_02A3EF:        A8            TAY                       
ADDR_02A3F0:        A9 02         LDA.B #$02                
ADDR_02A3F2:        99 60 04      STA.W OAM_TileSize,Y      
Return02A3F5:       60            RTS                       ; Return 

CODE_02A3F6:        AD F9 13      LDA.W RAM_IsBehindScenery 
CODE_02A3F9:        5D 79 17      EOR.W $1779,X             
CODE_02A3FC:        D0 6A         BNE Return02A468          
CODE_02A3FE:        22 64 B6 03   JSL.L GetMarioClipping    
CODE_02A402:        20 19 A5      JSR.W CODE_02A519         
CODE_02A405:        22 2B B7 03   JSL.L CheckForContact     
CODE_02A409:        90 5D         BCC Return02A468          
CODE_02A40B:        BD 0B 17      LDA.W RAM_ExSpriteNum,X   
CODE_02A40E:        C9 0A         CMP.B #$0A                
CODE_02A410:        D0 57         BNE CODE_02A469           
ADDR_02A412:        22 4A B3 05   JSL.L CODE_05B34A         
ADDR_02A416:        EE E3 18      INC.W $18E3               
ADDR_02A419:        9E 0B 17      STZ.W RAM_ExSpriteNum,X   ; Clear extended sprite 
ADDR_02A41C:        A0 03         LDY.B #$03                
ADDR_02A41E:        B9 C0 17      LDA.W $17C0,Y             
ADDR_02A421:        F0 04         BEQ ADDR_02A427           
ADDR_02A423:        88            DEY                       
ADDR_02A424:        10 F8         BPL ADDR_02A41E           
ADDR_02A426:        C8            INY                       
ADDR_02A427:        A9 05         LDA.B #$05                
ADDR_02A429:        99 C0 17      STA.W $17C0,Y             
ADDR_02A42C:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
ADDR_02A42F:        99 C8 17      STA.W $17C8,Y             
ADDR_02A432:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
ADDR_02A435:        99 C4 17      STA.W $17C4,Y             
ADDR_02A438:        A9 0A         LDA.B #$0A                
ADDR_02A43A:        99 CC 17      STA.W $17CC,Y             
ADDR_02A43D:        22 34 AD 02   JSL.L CODE_02AD34         
ADDR_02A441:        A9 05         LDA.B #$05                
ADDR_02A443:        99 E1 16      STA.W RAM_ScoreSprNum,Y   
ADDR_02A446:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
ADDR_02A449:        99 E7 16      STA.W RAM_ScoreSprYLo,Y   
ADDR_02A44C:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
ADDR_02A44F:        99 F9 16      STA.W RAM_ScoreSprYHi,Y   
ADDR_02A452:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
ADDR_02A455:        99 ED 16      STA.W RAM_ScoreSprXLo,Y   
ADDR_02A458:        BD 33 17      LDA.W RAM_ExSpriteXHi,X   
ADDR_02A45B:        99 F3 16      STA.W RAM_ScoreSprXHi,Y   
ADDR_02A45E:        A9 30         LDA.B #$30                
ADDR_02A460:        99 FF 16      STA.W RAM_ScoreSprSpeedY,Y 
ADDR_02A463:        A9 00         LDA.B #$00                
ADDR_02A465:        99 05 17      STA.W $1705,Y             
Return02A468:       60            RTS                       ; Return 

CODE_02A469:        AD 90 14      LDA.W $1490               ; \ Branch if Mario has star 
CODE_02A46C:        D0 47         BNE CODE_02A4B5           ; / 
CODE_02A46E:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_02A471:        F0 3B         BEQ CODE_02A4AE           
CODE_02A473:        DA            PHX                       
CODE_02A474:        AE DF 18      LDX.W $18DF               
CODE_02A477:        A9 10         LDA.B #$10                
CODE_02A479:        9D 3D 16      STA.W $163D,X             
CODE_02A47C:        A9 03         LDA.B #$03                ; \ Play sound effect 
CODE_02A47E:        8D FA 1D      STA.W $1DFA               ; / 
CODE_02A481:        A9 13         LDA.B #$13                ; \ Play sound effect 
CODE_02A483:        8D FC 1D      STA.W $1DFC               ; / 
CODE_02A486:        A9 02         LDA.B #$02                
CODE_02A488:        95 C1         STA $C1,X                 
CODE_02A48A:        9C 7A 18      STZ.W RAM_OnYoshi         
CODE_02A48D:        9C C1 0D      STZ.W RAM_OWHasYoshi      
CODE_02A490:        A9 C0         LDA.B #$C0                
CODE_02A492:        85 7D         STA RAM_MarioSpeedY       
CODE_02A494:        64 7B         STZ RAM_MarioSpeedX       
CODE_02A496:        BC 7B 15      LDY.W $157B,X             
CODE_02A499:        B9 B3 A4      LDA.W DATA_02A4B3,Y       
CODE_02A49C:        95 B5         STA $B5,X                 
CODE_02A49E:        9E 93 15      STZ.W $1593,X             
CODE_02A4A1:        9E 1B 15      STZ.W $151B,X             
CODE_02A4A4:        9C AE 18      STZ.W $18AE               
CODE_02A4A7:        A9 30         LDA.B #$30                
CODE_02A4A9:        8D 97 14      STA.W $1497               
CODE_02A4AC:        FA            PLX                       
Return02A4AD:       60            RTS                       ; Return 

CODE_02A4AE:        22 B7 F5 00   JSL.L HurtMario           
Return02A4B2:       60            RTS                       ; Return 


DATA_02A4B3:                      .db $10,$F0

CODE_02A4B5:        BD 0B 17      LDA.W RAM_ExSpriteNum,X   
CODE_02A4B8:        C9 04         CMP.B #$04                
CODE_02A4BA:        F0 22         BEQ CODE_02A4DE           
CODE_02A4BC:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_02A4BF:        38            SEC                       
CODE_02A4C0:        E9 04         SBC.B #$04                
CODE_02A4C2:        9D 1F 17      STA.W RAM_ExSpriteXLo,X   
CODE_02A4C5:        BD 33 17      LDA.W RAM_ExSpriteXHi,X   
CODE_02A4C8:        E9 00         SBC.B #$00                
CODE_02A4CA:        9D 33 17      STA.W RAM_ExSpriteXHi,X   
CODE_02A4CD:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_02A4D0:        38            SEC                       
CODE_02A4D1:        E9 04         SBC.B #$04                
CODE_02A4D3:        9D 15 17      STA.W RAM_ExSpriteYLo,X   
CODE_02A4D6:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
CODE_02A4D9:        E9 00         SBC.B #$00                
CODE_02A4DB:        9D 29 17      STA.W RAM_ExSpriteYHi,X   
CODE_02A4DE:        A9 07         LDA.B #$07                
CODE_02A4E0:        9D 6F 17      STA.W $176F,X             
CODE_02A4E3:        A9 01         LDA.B #$01                
CODE_02A4E5:        9D 0B 17      STA.W $170B,X             
Return02A4E8:       60            RTS                       ; Return 


DATA_02A4E9:                      .db $03,$03,$04,$03,$04,$00,$00,$00
                                  .db $04,$03

DATA_02A4F3:                      .db $03,$03,$03,$03,$04,$03,$04,$00
                                  .db $00,$00,$02,$03

DATA_02A4FF:                      .db $03,$03,$01,$01,$08,$01,$08,$00
                                  .db $00,$0F,$08,$01

DATA_02A50B:                      .db $01,$01,$01,$01,$08,$01,$08,$00
                                  .db $00,$0F,$0C,$01,$01,$01

CODE_02A519:        BC 0B 17      LDY.W RAM_ExSpriteNum,X   
CODE_02A51C:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_02A51F:        18            CLC                       
CODE_02A520:        79 E7 A4      ADC.W ADDR_02A4E7,Y       
CODE_02A523:        85 04         STA $04                   
CODE_02A525:        BD 33 17      LDA.W RAM_ExSpriteXHi,X   
CODE_02A528:        69 00         ADC.B #$00                
CODE_02A52A:        85 0A         STA $0A                   
CODE_02A52C:        B9 FF A4      LDA.W DATA_02A4FF,Y       
CODE_02A52F:        85 06         STA $06                   
CODE_02A531:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_02A534:        18            CLC                       
CODE_02A535:        79 F3 A4      ADC.W DATA_02A4F3,Y       
CODE_02A538:        85 05         STA $05                   
CODE_02A53A:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
CODE_02A53D:        69 00         ADC.B #$00                
CODE_02A53F:        85 0B         STA $0B                   
CODE_02A541:        B9 0B A5      LDA.W DATA_02A50B,Y       
CODE_02A544:        85 07         STA $07                   
Return02A546:       60            RTS                       ; Return 

CODE_02A547:        B9 1F 17      LDA.W RAM_ExSpriteXLo,Y   
CODE_02A54A:        38            SEC                       
CODE_02A54B:        E9 02         SBC.B #$02                
CODE_02A54D:        85 00         STA $00                   
CODE_02A54F:        B9 33 17      LDA.W RAM_ExSpriteXHi,Y   
CODE_02A552:        E9 00         SBC.B #$00                
CODE_02A554:        85 08         STA $08                   
CODE_02A556:        A9 0C         LDA.B #$0C                
CODE_02A558:        85 02         STA $02                   
CODE_02A55A:        B9 15 17      LDA.W RAM_ExSpriteYLo,Y   
CODE_02A55D:        38            SEC                       
CODE_02A55E:        E9 04         SBC.B #$04                
CODE_02A560:        85 01         STA $01                   
CODE_02A562:        B9 29 17      LDA.W RAM_ExSpriteYHi,Y   
CODE_02A565:        E9 00         SBC.B #$00                
CODE_02A567:        85 09         STA $09                   
CODE_02A569:        A9 13         LDA.B #$13                
CODE_02A56B:        85 03         STA $03                   
Return02A56D:       60            RTS                       ; Return 

CODE_02A56E:        64 0F         STZ $0F                   
CODE_02A570:        64 0E         STZ $0E                   
CODE_02A572:        64 0B         STZ $0B                   
CODE_02A574:        9C 94 16      STZ.W $1694               
CODE_02A577:        AD 0F 14      LDA.W $140F               
CODE_02A57A:        D0 40         BNE CODE_02A5BC           
CODE_02A57C:        AD 9B 0D      LDA.W $0D9B               
CODE_02A57F:        10 3B         BPL CODE_02A5BC           
CODE_02A581:        29 40         AND.B #$40                
CODE_02A583:        F0 0D         BEQ CODE_02A592           
ADDR_02A585:        AD 9B 0D      LDA.W $0D9B               
ADDR_02A588:        C9 C1         CMP.B #$C1                
ADDR_02A58A:        F0 30         BEQ CODE_02A5BC           
ADDR_02A58C:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
ADDR_02A58F:        C9 A8         CMP.B #$A8                
Return02A591:       60            RTS                       ; Return 

CODE_02A592:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_02A595:        18            CLC                       
CODE_02A596:        69 04         ADC.B #$04                
CODE_02A598:        8D B4 14      STA.W $14B4               
CODE_02A59B:        BD 33 17      LDA.W RAM_ExSpriteXHi,X   
CODE_02A59E:        69 00         ADC.B #$00                
CODE_02A5A0:        8D B5 14      STA.W $14B5               
CODE_02A5A3:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_02A5A6:        18            CLC                       
CODE_02A5A7:        69 08         ADC.B #$08                
CODE_02A5A9:        8D B6 14      STA.W $14B6               
CODE_02A5AC:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
CODE_02A5AF:        69 00         ADC.B #$00                
CODE_02A5B1:        8D B7 14      STA.W $14B7               
CODE_02A5B4:        22 9D CC 01   JSL.L CODE_01CC9D         
CODE_02A5B8:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return02A5BB:       60            RTS                       ; Return 

CODE_02A5BC:        20 11 A6      JSR.W CODE_02A611         
CODE_02A5BF:        26 0E         ROL $0E                   
CODE_02A5C1:        AD 93 16      LDA.W $1693               
CODE_02A5C4:        85 0C         STA $0C                   
CODE_02A5C6:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_02A5C8:        10 42         BPL CODE_02A60C           
CODE_02A5CA:        E6 0F         INC $0F                   
CODE_02A5CC:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_02A5CF:        48            PHA                       
CODE_02A5D0:        18            CLC                       
CODE_02A5D1:        65 26         ADC $26                   
CODE_02A5D3:        9D 1F 17      STA.W RAM_ExSpriteXLo,X   
CODE_02A5D6:        BD 33 17      LDA.W RAM_ExSpriteXHi,X   
CODE_02A5D9:        48            PHA                       
CODE_02A5DA:        65 27         ADC $27                   
CODE_02A5DC:        9D 33 17      STA.W RAM_ExSpriteXHi,X   
CODE_02A5DF:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_02A5E2:        48            PHA                       
CODE_02A5E3:        18            CLC                       
CODE_02A5E4:        65 28         ADC $28                   
CODE_02A5E6:        9D 15 17      STA.W RAM_ExSpriteYLo,X   
CODE_02A5E9:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
CODE_02A5EC:        48            PHA                       
CODE_02A5ED:        65 29         ADC $29                   
CODE_02A5EF:        9D 29 17      STA.W RAM_ExSpriteYHi,X   
CODE_02A5F2:        20 11 A6      JSR.W CODE_02A611         
CODE_02A5F5:        26 0E         ROL $0E                   
CODE_02A5F7:        AD 93 16      LDA.W $1693               
CODE_02A5FA:        85 0D         STA $0D                   
CODE_02A5FC:        68            PLA                       
CODE_02A5FD:        9D 29 17      STA.W RAM_ExSpriteYHi,X   
CODE_02A600:        68            PLA                       
CODE_02A601:        9D 15 17      STA.W RAM_ExSpriteYLo,X   
CODE_02A604:        68            PLA                       
CODE_02A605:        9D 33 17      STA.W RAM_ExSpriteXHi,X   
CODE_02A608:        68            PLA                       
CODE_02A609:        9D 1F 17      STA.W RAM_ExSpriteXLo,X   
CODE_02A60C:        A5 0E         LDA $0E                   
CODE_02A60E:        C9 01         CMP.B #$01                
Return02A610:       60            RTS                       ; Return 

CODE_02A611:        A5 0F         LDA $0F                   
CODE_02A613:        1A            INC A                     
CODE_02A614:        25 5B         AND RAM_IsVerticalLvl     
CODE_02A616:        F0 61         BEQ CODE_02A679           
CODE_02A618:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_02A61B:        18            CLC                       
CODE_02A61C:        69 08         ADC.B #$08                
CODE_02A61E:        85 98         STA RAM_BlockXLo          
CODE_02A620:        29 F0         AND.B #$F0                
CODE_02A622:        85 00         STA $00                   
CODE_02A624:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
CODE_02A627:        69 00         ADC.B #$00                
CODE_02A629:        C5 5D         CMP RAM_ScreensInLvl      
CODE_02A62B:        B0 4A         BCS CODE_02A677           
CODE_02A62D:        85 03         STA $03                   
CODE_02A62F:        85 99         STA RAM_BlockXHi          
CODE_02A631:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_02A634:        18            CLC                       
CODE_02A635:        69 04         ADC.B #$04                
CODE_02A637:        85 01         STA $01                   
CODE_02A639:        85 9A         STA RAM_BlockYLo          
CODE_02A63B:        BD 33 17      LDA.W RAM_ExSpriteXHi,X   
CODE_02A63E:        69 00         ADC.B #$00                
CODE_02A640:        C9 02         CMP.B #$02                
CODE_02A642:        B0 33         BCS CODE_02A677           
CODE_02A644:        85 02         STA $02                   
CODE_02A646:        85 9B         STA RAM_BlockYHi          
CODE_02A648:        A5 01         LDA $01                   
CODE_02A64A:        4A            LSR                       
CODE_02A64B:        4A            LSR                       
CODE_02A64C:        4A            LSR                       
CODE_02A64D:        4A            LSR                       
CODE_02A64E:        05 00         ORA $00                   
CODE_02A650:        85 00         STA $00                   
CODE_02A652:        A6 03         LDX $03                   
CODE_02A654:        BF 80 BA 00   LDA.L DATA_00BA80,X       
CODE_02A658:        A4 0F         LDY $0F                   
CODE_02A65A:        F0 04         BEQ CODE_02A660           
CODE_02A65C:        BF 8E BA 00   LDA.L DATA_00BA8E,X       
CODE_02A660:        18            CLC                       
CODE_02A661:        65 00         ADC $00                   
CODE_02A663:        85 05         STA $05                   
CODE_02A665:        BF BC BA 00   LDA.L DATA_00BABC,X       
CODE_02A669:        A4 0F         LDY $0F                   
CODE_02A66B:        F0 04         BEQ CODE_02A671           
CODE_02A66D:        BF CA BA 00   LDA.L DATA_00BACA,X       
CODE_02A671:        65 02         ADC $02                   
CODE_02A673:        85 06         STA $06                   
CODE_02A675:        80 64         BRA CODE_02A6DB           

CODE_02A677:        18            CLC                       
Return02A678:       60            RTS                       ; Return 

CODE_02A679:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_02A67C:        18            CLC                       
CODE_02A67D:        69 08         ADC.B #$08                
CODE_02A67F:        85 98         STA RAM_BlockXLo          
CODE_02A681:        29 F0         AND.B #$F0                
CODE_02A683:        85 00         STA $00                   
CODE_02A685:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
CODE_02A688:        69 00         ADC.B #$00                
CODE_02A68A:        85 02         STA $02                   
CODE_02A68C:        85 99         STA RAM_BlockXHi          
CODE_02A68E:        A5 00         LDA $00                   
CODE_02A690:        38            SEC                       
CODE_02A691:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02A693:        C9 F0         CMP.B #$F0                
CODE_02A695:        B0 E0         BCS CODE_02A677           
CODE_02A697:        BD 1F 17      LDA.W RAM_ExSpriteXLo,X   
CODE_02A69A:        18            CLC                       
CODE_02A69B:        69 04         ADC.B #$04                
CODE_02A69D:        85 01         STA $01                   
CODE_02A69F:        85 9A         STA RAM_BlockYLo          
CODE_02A6A1:        BD 33 17      LDA.W RAM_ExSpriteXHi,X   
CODE_02A6A4:        69 00         ADC.B #$00                
CODE_02A6A6:        C5 5D         CMP RAM_ScreensInLvl      
CODE_02A6A8:        B0 CD         BCS CODE_02A677           
CODE_02A6AA:        85 03         STA $03                   
CODE_02A6AC:        85 9B         STA RAM_BlockYHi          
CODE_02A6AE:        A5 01         LDA $01                   
CODE_02A6B0:        4A            LSR                       
CODE_02A6B1:        4A            LSR                       
CODE_02A6B2:        4A            LSR                       
CODE_02A6B3:        4A            LSR                       
CODE_02A6B4:        05 00         ORA $00                   
CODE_02A6B6:        85 00         STA $00                   
CODE_02A6B8:        A6 03         LDX $03                   
CODE_02A6BA:        BF 60 BA 00   LDA.L DATA_00BA60,X       
CODE_02A6BE:        A4 0F         LDY $0F                   
CODE_02A6C0:        F0 04         BEQ CODE_02A6C6           
CODE_02A6C2:        BF 70 BA 00   LDA.L DATA_00BA70,X       
CODE_02A6C6:        18            CLC                       
CODE_02A6C7:        65 00         ADC $00                   
CODE_02A6C9:        85 05         STA $05                   
CODE_02A6CB:        BF 9C BA 00   LDA.L DATA_00BA9C,X       
CODE_02A6CF:        A4 0F         LDY $0F                   
CODE_02A6D1:        F0 04         BEQ CODE_02A6D7           
CODE_02A6D3:        BF AC BA 00   LDA.L DATA_00BAAC,X       
CODE_02A6D7:        65 02         ADC $02                   
CODE_02A6D9:        85 06         STA $06                   
CODE_02A6DB:        A9 7E         LDA.B #$7E                
CODE_02A6DD:        85 07         STA $07                   
CODE_02A6DF:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02A6E2:        A7 05         LDA [$05]                 
CODE_02A6E4:        8D 93 16      STA.W $1693               
CODE_02A6E7:        E6 07         INC $07                   
CODE_02A6E9:        A7 05         LDA [$05]                 
CODE_02A6EB:        22 45 F5 00   JSL.L CODE_00F545         
CODE_02A6EF:        C9 00         CMP.B #$00                
CODE_02A6F1:        F0 36         BEQ CODE_02A729           
CODE_02A6F3:        AD 93 16      LDA.W $1693               
CODE_02A6F6:        C9 11         CMP.B #$11                
CODE_02A6F8:        90 31         BCC CODE_02A72B           
CODE_02A6FA:        C9 6E         CMP.B #$6E                
CODE_02A6FC:        90 29         BCC CODE_02A727           
CODE_02A6FE:        C9 D8         CMP.B #$D8                
CODE_02A700:        B0 33         BCS CODE_02A735           
CODE_02A702:        A4 9A         LDY RAM_BlockYLo          
CODE_02A704:        84 0A         STY $0A                   
CODE_02A706:        A4 98         LDY RAM_BlockXLo          
CODE_02A708:        84 0C         STY $0C                   
CODE_02A70A:        22 19 FA 00   JSL.L CODE_00FA19         
CODE_02A70E:        A5 00         LDA $00                   
CODE_02A710:        C9 0C         CMP.B #$0C                
CODE_02A712:        B0 04         BCS CODE_02A718           
CODE_02A714:        D7 05         CMP [$05],Y               
CODE_02A716:        90 11         BCC CODE_02A729           
CODE_02A718:        B7 05         LDA [$05],Y               
CODE_02A71A:        8D 94 16      STA.W $1694               
CODE_02A71D:        DA            PHX                       
CODE_02A71E:        A6 08         LDX $08                   
CODE_02A720:        BF 3D E5 00   LDA.L DATA_00E53D,X       
CODE_02A724:        FA            PLX                       
CODE_02A725:        85 0B         STA $0B                   
CODE_02A727:        38            SEC                       
Return02A728:       60            RTS                       ; Return 

CODE_02A729:        18            CLC                       
Return02A72A:       60            RTS                       ; Return 

CODE_02A72B:        A5 98         LDA RAM_BlockXLo          
CODE_02A72D:        29 0F         AND.B #$0F                
CODE_02A72F:        C9 06         CMP.B #$06                
CODE_02A731:        B0 F6         BCS CODE_02A729           
CODE_02A733:        38            SEC                       
Return02A734:       60            RTS                       ; Return 

CODE_02A735:        A5 98         LDA RAM_BlockXLo          
CODE_02A737:        29 0F         AND.B #$0F                
CODE_02A739:        C9 06         CMP.B #$06                
CODE_02A73B:        B0 EC         BCS CODE_02A729           
CODE_02A73D:        BD 15 17      LDA.W RAM_ExSpriteYLo,X   
CODE_02A740:        38            SEC                       
CODE_02A741:        E9 02         SBC.B #$02                
CODE_02A743:        9D 15 17      STA.W RAM_ExSpriteYLo,X   
CODE_02A746:        BD 29 17      LDA.W RAM_ExSpriteYHi,X   
CODE_02A749:        E9 00         SBC.B #$00                
CODE_02A74B:        9D 29 17      STA.W RAM_ExSpriteYHi,X   
CODE_02A74E:        4C 11 A6      JMP.W CODE_02A611         

CODE_02A751:        8B            PHB                       
CODE_02A752:        4B            PHK                       
CODE_02A753:        AB            PLB                       
CODE_02A754:        20 F2 AB      JSR.W CODE_02ABF2         
CODE_02A757:        20 5C AC      JSR.W CODE_02AC5C         
CODE_02A75A:        AD 9B 0D      LDA.W $0D9B               
CODE_02A75D:        30 04         BMI CODE_02A763           
CODE_02A75F:        22 8C 80 01   JSL.L CODE_01808C         
CODE_02A763:        AD C1 0D      LDA.W RAM_OWHasYoshi      
CODE_02A766:        F0 09         BEQ CODE_02A771           
CODE_02A768:        AD 9B 1B      LDA.W $1B9B               
CODE_02A76B:        D0 04         BNE CODE_02A771           
CODE_02A76D:        22 7A FC 00   JSL.L CODE_00FC7A         
CODE_02A771:        AB            PLB                       
Return02A772:       6B            RTL                       ; Return 


SpriteSlotMax:                    .db $09,$05,$07,$07,$07,$06,$07,$06
                                  .db $06,$09,$08,$04,$07,$07,$07,$08
                                  .db $09,$05,$05

SpriteSlotMax1:                   .db $09,$07,$07,$01,$00,$01,$07,$06
                                  .db $06,$00,$02,$00,$07,$01,$07,$08
                                  .db $09,$07,$05

SpriteSlotMax2:                   .db $09,$07,$07,$01,$00,$06,$07,$06
                                  .db $06,$00,$02,$00,$07,$01,$07,$08
                                  .db $09,$07,$05

SpriteSlotStart:                  .db $FF,$FF,$00,$01,$00,$01,$FF,$01
                                  .db $FF,$00,$FF,$00,$FF,$01,$FF,$FF
                                  .db $FF,$FF,$FF

SpriteSlotStart1:                 .db $FF,$05,$FF,$FF,$FF,$FF,$FF,$01
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$05,$FF

ReservedSprite1:                  .db $FF,$5F,$54,$5E,$60,$28,$88,$FF
                                  .db $FF,$C5,$86,$28,$FF,$90,$FF,$FF
                                  .db $FF,$AE

ReservedSprite2:                  .db $FF,$64,$FF,$FF,$9F,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$9F,$FF,$FF
                                  .db $FF,$FF

DATA_02A7F6:                      .db $D0,$00,$20

DATA_02A7F9:                      .db $FF,$00,$01

LoadSprFromLevel:   A5 13         LDA RAM_FrameCounter      ; \ Return every other frame 
CODE_02A7FE:        29 01         AND.B #$01                ;  | 
CODE_02A800:        D0 49         BNE Return02A84B          ; / 
CODE_02A802:        A4 55         LDY $55                   
CODE_02A804:        A5 5B         LDA RAM_IsVerticalLvl     ; \ Branch if horizontal level 
CODE_02A806:        4A            LSR                       ;  | 
CODE_02A807:        90 0E         BCC CODE_02A817           ; / 
CODE_02A809:        A5 1C         LDA RAM_ScreenBndryYLo    ; \ Vertical level: 
CODE_02A80B:        18            CLC                       ;  | $00,$01 = Screen boundary Y + offset 
CODE_02A80C:        79 F6 A7      ADC.W DATA_02A7F6,Y       ;  | 
CODE_02A80F:        29 F0         AND.B #$F0                ;  | 
CODE_02A811:        85 00         STA $00                   ;  | 
CODE_02A813:        A5 1D         LDA RAM_ScreenBndryYHi    ;  | 
CODE_02A815:        80 0C         BRA CODE_02A823           ; / 

CODE_02A817:        A5 1A         LDA RAM_ScreenBndryXLo    ; \ Horizontal level: 
CODE_02A819:        18            CLC                       ;  | $00,$01 = Screen boundary X + offset 
CODE_02A81A:        79 F6 A7      ADC.W DATA_02A7F6,Y       ;  | 
CODE_02A81D:        29 F0         AND.B #$F0                ;  | 
CODE_02A81F:        85 00         STA $00                   ;  | 
CODE_02A821:        A5 1B         LDA RAM_ScreenBndryXHi    ;  | 
CODE_02A823:        79 F9 A7      ADC.W DATA_02A7F9,Y       ;  | 
CODE_02A826:        30 23         BMI Return02A84B          ;  | 
CODE_02A828:        85 01         STA $01                   ; / 
CODE_02A82A:        A2 00         LDX.B #$00                ; X = #$00 (Number of sprite in level) 
CODE_02A82C:        A0 01         LDY.B #$01                ; Y = #$01 (Index into level data) 
LoadSpriteLoopStrt: B7 CE         LDA [$CE],Y               ; Byte format: YYYYEEsy 
CODE_02A830:        C9 FF         CMP.B #$FF                ; \ Return when we encounter $FF, as it signals the end 
CODE_02A832:        F0 17         BEQ Return02A84B          ; / 
CODE_02A834:        0A            ASL                       ; \ If 's' is set, $02 = #$10 
CODE_02A835:        0A            ASL                       ;  | Else, $02 = #$00 
CODE_02A836:        0A            ASL                       ;  | 
CODE_02A837:        29 10         AND.B #$10                ;  | 
CODE_02A839:        85 02         STA $02                   ; / 
CODE_02A83B:        C8            INY                       ; Next byte 
CODE_02A83C:        B7 CE         LDA [$CE],Y               ; Byte format: XXXXSSSS 
CODE_02A83E:        29 0F         AND.B #$0F                ; \ Skip all sprites until we find one at the adjusted screen boundary: 
CODE_02A840:        05 02         ORA $02                   ;  | 
CODE_02A842:        C5 01         CMP $01                   ;  | If sprite screen (sSSSS) < adjusted screen boundary... 
CODE_02A844:        B0 06         BCS CODE_02A84C           ; / ...skip the sprite 
LoadNextSprite:     C8            INY                       ; \ Move on to the next sprite 
CODE_02A847:        C8            INY                       ;  | 
CODE_02A848:        E8            INX                       ;  | 
CODE_02A849:        80 E3         BRA LoadSpriteLoopStrt    ; / 

Return02A84B:       60            RTS                       ; Return 

CODE_02A84C:        D0 FD         BNE Return02A84B          ; Return if sprite screen > adjusted screen boundary 
CODE_02A84E:        B7 CE         LDA [$CE],Y               ; Byte format: XXXXSSSS 
CODE_02A850:        29 F0         AND.B #$F0                ; \ Skip sprite if not right at the screen boundary 
CODE_02A852:        C5 00         CMP $00                   ;  | 
CODE_02A854:        D0 F0         BNE LoadNextSprite        ; / 
CODE_02A856:        BD 38 19      LDA.W RAM_SprLoadStatus,X ; \ This table has a flag for every sprite in the level (not just those onscreen) 
CODE_02A859:        D0 EB         BNE LoadNextSprite        ; / Skip sprite if it's already been loaded/permanently killed 
CODE_02A85B:        86 02         STX $02                   ; $02 = Number of sprite in level 
CODE_02A85D:        FE 38 19      INC.W RAM_SprLoadStatus,X ; Mark sprite as loaded 
CODE_02A860:        C8            INY                       ; Next byte 
CODE_02A861:        B7 CE         LDA [$CE],Y               ; Byte format: Sprite number 
CODE_02A863:        85 05         STA $05                   ; $05 = Sprite number 
CODE_02A865:        88            DEY                       ; Previous byte 
CODE_02A866:        C9 E7         CMP.B #$E7                ; \ Branch if sprite number < #$E7 
CODE_02A868:        90 22         BCC CODE_02A88C           ; / 
LoadScrollSprite:   AD 3E 14      LDA.W RAM_ScrollSprNum    
CODE_02A86D:        0D 3F 14      ORA.W $143F               
CODE_02A870:        D0 18         BNE CODE_02A88A           
CODE_02A872:        5A            PHY                       
CODE_02A873:        DA            PHX                       
CODE_02A874:        A5 05         LDA $05                   ; \ $143E = Type of scroll sprite 
CODE_02A876:        38            SEC                       ;  | (Sprite number - #$E7) 
CODE_02A877:        E9 E7         SBC.B #$E7                ;  | 
CODE_02A879:        8D 3E 14      STA.W RAM_ScrollSprNum    ; / 
CODE_02A87C:        88            DEY                       ; Previous byte 
CODE_02A87D:        B7 CE         LDA [$CE],Y               ; Byte format: YYYYEEsy 
CODE_02A87F:        4A            LSR                       
CODE_02A880:        4A            LSR                       
CODE_02A881:        8D 40 14      STA.W $1440               
CODE_02A884:        22 D6 BC 05   JSL.L CODE_05BCD6         
CODE_02A888:        FA            PLX                       
CODE_02A889:        7A            PLY                       
CODE_02A88A:        80 BA         BRA LoadNextSprite        

CODE_02A88C:        C9 DE         CMP.B #$DE                ; \ Branch if sprite number != 5 Eeries 
CODE_02A88E:        D0 0C         BNE CODE_02A89C           ; / 
CODE_02A890:        5A            PHY                       
CODE_02A891:        DA            PHX                       
CODE_02A892:        88            DEY                       
CODE_02A893:        84 03         STY $03                   
CODE_02A895:        20 9D AF      JSR.W Load5Eeries         
CODE_02A898:        FA            PLX                       
CODE_02A899:        7A            PLY                       
CODE_02A89A:        80 AA         BRA LoadNextSprite        

CODE_02A89C:        C9 E0         CMP.B #$E0                ; \ Branch if sprite number != 3 Platforms on Chain 
CODE_02A89E:        D0 0C         BNE CODE_02A8AC           ; / 
CODE_02A8A0:        5A            PHY                       
CODE_02A8A1:        DA            PHX                       
CODE_02A8A2:        88            DEY                       
CODE_02A8A3:        84 03         STY $03                   
CODE_02A8A5:        20 33 AF      JSR.W Load3Platforms      
CODE_02A8A8:        FA            PLX                       
CODE_02A8A9:        7A            PLY                       
CODE_02A8AA:        80 EE         BRA CODE_02A89A           

CODE_02A8AC:        C9 CB         CMP.B #$CB                ; \ Branch if sprite number < #$CB 
CODE_02A8AE:        90 24         BCC CODE_02A8D4           ; / 
CODE_02A8B0:        C9 DA         CMP.B #$DA                ; \ Branch if sprite number >= #$DA 
CODE_02A8B2:        B0 0C         BCS CODE_02A8C0           ; / 
InitGenerator:      38            SEC                       ; \ $18B9 = Type of generator 
CODE_02A8B5:        E9 CB         SBC.B #$CB                ;  | (Sprite number - #$CA) 
CODE_02A8B7:        1A            INC A                     ;  | 
CODE_02A8B8:        8D B9 18      STA.W RAM_GeneratorNum    ; / 
CODE_02A8BB:        9E 38 19      STZ.W RAM_SprLoadStatus,X ; Allow sprite to be reloaded by level loading routine 
CODE_02A8BE:        80 DA         BRA CODE_02A89A           

CODE_02A8C0:        C9 E1         CMP.B #$E1                ; \ Branch if sprite number < #$E1 
CODE_02A8C2:        90 0C         BCC CODE_02A8D0           ; / 
CODE_02A8C4:        DA            PHX                       
CODE_02A8C5:        5A            PHY                       
CODE_02A8C6:        88            DEY                       
CODE_02A8C7:        84 03         STY $03                   
CODE_02A8C9:        20 C0 AA      JSR.W CODE_02AAC0         
CODE_02A8CC:        7A            PLY                       
CODE_02A8CD:        FA            PLX                       
CODE_02A8CE:        80 CA         BRA CODE_02A89A           

CODE_02A8D0:        A9 09         LDA.B #$09                
CODE_02A8D2:        80 0B         BRA CODE_02A8DF           

CODE_02A8D4:        C9 C9         CMP.B #$C9                ; \ Branch if sprite number < #$C9 
CODE_02A8D6:        90 05         BCC LoadNormalSprite      ; / 
CODE_02A8D8:        20 78 AB      JSR.W LoadShooter         
CODE_02A8DB:        80 BD         BRA CODE_02A89A           

LoadNormalSprite:   A9 01         LDA.B #$01                ; \ $04 = #$01 
CODE_02A8DF:        85 04         STA $04                   ; / Eventually goes into sprite status 
CODE_02A8E1:        88            DEY                       ; Previous byte 
CODE_02A8E2:        84 03         STY $03                   
CODE_02A8E4:        AC 92 16      LDY.W $1692               
CODE_02A8E7:        BE 73 A7      LDX.W SpriteSlotMax,Y     
CODE_02A8EA:        B9 AC A7      LDA.W SpriteSlotStart,Y   
CODE_02A8ED:        85 06         STA $06                   
CODE_02A8EF:        A5 05         LDA $05                   
CODE_02A8F1:        D9 D2 A7      CMP.W ReservedSprite1,Y   
CODE_02A8F4:        D0 08         BNE CODE_02A8FE           
CODE_02A8F6:        BE 86 A7      LDX.W SpriteSlotMax1,Y    
CODE_02A8F9:        B9 BF A7      LDA.W SpriteSlotStart1,Y  
CODE_02A8FC:        85 06         STA $06                   
CODE_02A8FE:        A5 05         LDA $05                   
CODE_02A900:        D9 E4 A7      CMP.W ReservedSprite2,Y   
CODE_02A903:        D0 11         BNE CODE_02A916           
CODE_02A905:        C9 64         CMP.B #$64                
CODE_02A907:        D0 06         BNE CODE_02A90F           
CODE_02A909:        A5 00         LDA $00                   
CODE_02A90B:        29 10         AND.B #$10                
CODE_02A90D:        F0 07         BEQ CODE_02A916           
CODE_02A90F:        BE 99 A7      LDX.W SpriteSlotMax2,Y    
CODE_02A912:        A9 FF         LDA.B #$FF                
CODE_02A914:        85 06         STA $06                   
CODE_02A916:        86 0F         STX $0F                   
CODE_02A918:        BD C8 14      LDA.W $14C8,X             
CODE_02A91B:        F0 1F         BEQ CODE_02A93C           
CODE_02A91D:        CA            DEX                       
CODE_02A91E:        E4 06         CPX $06                   
CODE_02A920:        D0 F6         BNE CODE_02A918           
CODE_02A922:        A5 05         LDA $05                   
CODE_02A924:        C9 7B         CMP.B #$7B                
CODE_02A926:        D0 0E         BNE CODE_02A936           
ADDR_02A928:        A6 0F         LDX $0F                   
ADDR_02A92A:        BD 7A 16      LDA.W RAM_Tweaker167A,X   
ADDR_02A92D:        29 02         AND.B #$02                
ADDR_02A92F:        F0 0B         BEQ CODE_02A93C           
ADDR_02A931:        CA            DEX                       
ADDR_02A932:        E4 06         CPX $06                   
ADDR_02A934:        D0 F4         BNE ADDR_02A92A           
CODE_02A936:        A6 02         LDX $02                   
CODE_02A938:        9E 38 19      STZ.W RAM_SprLoadStatus,X ; Allow sprite to be reloaded by level loading routine 
Return02A93B:       60            RTS                       ; Return 

CODE_02A93C:        A4 03         LDY $03                   
CODE_02A93E:        A5 5B         LDA RAM_IsVerticalLvl     ; \ Branch if horizontal level 
CODE_02A940:        4A            LSR                       ;  | 
CODE_02A941:        90 18         BCC CODE_02A95B           ; / 
CODE_02A943:        B7 CE         LDA [$CE],Y               ; \ Vertical level: 
CODE_02A945:        48            PHA                       ;  | Same as below with X and Y coords swapped 
CODE_02A946:        29 F0         AND.B #$F0                ;  | 
CODE_02A948:        95 E4         STA RAM_SpriteXLo,X       ;  | 
CODE_02A94A:        68            PLA                       ;  | 
CODE_02A94B:        29 0D         AND.B #$0D                ;  | 
CODE_02A94D:        9D E0 14      STA.W RAM_SpriteXHi,X     ;  | 
CODE_02A950:        A5 00         LDA $00                   ;  | 
CODE_02A952:        95 D8         STA RAM_SpriteYLo,X       ;  | 
CODE_02A954:        A5 01         LDA $01                   ;  | 
CODE_02A956:        9D D4 14      STA.W RAM_SpriteYHi,X     ;  | 
CODE_02A959:        80 16         BRA CODE_02A971           ; / 

CODE_02A95B:        B7 CE         LDA [$CE],Y               ; Byte format: YYYYEEsy 
CODE_02A95D:        48            PHA                       ; \ Bits 11110000 are low byte of Y position 
CODE_02A95E:        29 F0         AND.B #$F0                ;  | 
CODE_02A960:        95 D8         STA RAM_SpriteYLo,X       ; / 
CODE_02A962:        68            PLA                       ; \ Bits 00001101 are high byte of Y position 
CODE_02A963:        29 0D         AND.B #$0D                ;  | (Extra bits are stored in Y position) 
CODE_02A965:        9D D4 14      STA.W RAM_SpriteYHi,X     ; / 
CODE_02A968:        A5 00         LDA $00                   ; \ X position = adjusted screen boundary 
CODE_02A96A:        95 E4         STA RAM_SpriteXLo,X       ;  | 
CODE_02A96C:        A5 01         LDA $01                   ;  | 
CODE_02A96E:        9D E0 14      STA.W RAM_SpriteXHi,X     ; / 
CODE_02A971:        C8            INY                       
CODE_02A972:        C8            INY                       
CODE_02A973:        A5 04         LDA $04                   ; \ Sprite status = ?? 
CODE_02A975:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02A978:        C9 09         CMP.B #$09                
CODE_02A97A:        B7 CE         LDA [$CE],Y		;KKOOPA STORAGE???               
CODE_02A97C:        90 06         BCC CODE_02A984 	;NO, IT WAS STATIONARY          
CODE_02A97E:        38            SEC                       
CODE_02A97F:        E9 DA         SBC.B #$DA		;SUBTRACT DA, FIRST SHELL SPRITE [RED]                
CODE_02A981:        18            CLC                       
CODE_02A982:        69 04         ADC.B #$04                
CODE_02A984:        5A            PHY                       
CODE_02A985:        AC EB 1E      LDY.W $1EEB               
CODE_02A988:        10 0C         BPL CODE_02A996	;IF POSITIBE, JUST STORE?           
CODE_02A98A:        C9 04         CMP.B #$04                
CODE_02A98C:        D0 02         BNE CODE_02A990           
ADDR_02A98E:        A9 07         LDA.B #$07		;WHAT?                
CODE_02A990:        C9 05         CMP.B #$05                
CODE_02A992:        D0 02         BNE CODE_02A996           
ADDR_02A994:        A9 06         LDA.B #$06`			;STORING RED KOOPA SHELL TO SPRITENUM                
CODE_02A996:        95 9E         STA RAM_SpriteNum,X       
CODE_02A998:        7A            PLY                       
CODE_02A999:        A5 02         LDA $02                   ; \ $161A,x = index of the sprite in the level 
CODE_02A99B:        9D 1A 16      STA.W RAM_SprIndexInLvl,X ; / (Number of sprites in level, not just onscreen) 
CODE_02A99E:        AD AE 14      LDA.W RAM_SilverPowTimer  
CODE_02A9A1:        F0 26         BEQ CODE_02A9C9           
CODE_02A9A3:        DA            PHX                       
CODE_02A9A4:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02A9A6:        AA            TAX                       
CODE_02A9A7:        BF 59 F6 07   LDA.L Sprite190FVals,X    
CODE_02A9AB:        FA            PLX                       
CODE_02A9AC:        29 40         AND.B #$40                
CODE_02A9AE:        D0 19         BNE CODE_02A9C9           
CODE_02A9B0:        A9 21         LDA.B #$21                ; \ Sprite = Moving Coin 
CODE_02A9B2:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_02A9B4:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02A9B6:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02A9B9:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02A9BD:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_02A9C0:        29 F1         AND.B #$F1                
CODE_02A9C2:        09 02         ORA.B #$02                
CODE_02A9C4:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_02A9C7:        80 04         BRA CODE_02A9CD           

CODE_02A9C9:        22 D2 F7 07   JSL.L InitSpriteTables    ; Reset sprite tables 
CODE_02A9CD:        A9 01         LDA.B #$01                ; \ Set off screen horizontally 
CODE_02A9CF:        9D A0 15      STA.W RAM_OffscreenHorz,X ; / 
CODE_02A9D2:        A9 04         LDA.B #$04                ; \ ?? $1FE2,X = #$04 
CODE_02A9D4:        9D E2 1F      STA.W $1FE2,X             ; / 
CODE_02A9D7:        C8            INY                       
CODE_02A9D8:        A6 02         LDX $02                   
CODE_02A9DA:        E8            INX                       
CODE_02A9DB:        4C 2E A8      JMP.W LoadSpriteLoopStrt  

FindFreeSlotLowPri: A9 02         LDA.B #$02                ; \ Number of slots to leave free = 2 
CODE_02A9E0:        85 0E         STA $0E                   ;  | 
CODE_02A9E2:        80 02         BRA CODE_02A9E6           ; / 

FindFreeSprSlot:    64 0E         STZ $0E                   ; Number of slots tp leave free = 0 
CODE_02A9E6:        8B            PHB                       
CODE_02A9E7:        4B            PHK                       
CODE_02A9E8:        AB            PLB                       
CODE_02A9E9:        20 EF A9      JSR.W FindFreeSlotRt      
CODE_02A9EC:        AB            PLB                       
CODE_02A9ED:        98            TYA                       
Return02A9EE:       6B            RTL                       ; Return 

FindFreeSlotRt:     AC 92 16      LDY.W $1692               ; \ Subroutine: Return the first free sprite slot in Y (#$FF if not found) 
CODE_02A9F2:        B9 AC A7      LDA.W SpriteSlotStart,Y   ;  | Y = Sprite memory index 
CODE_02A9F5:        85 0F         STA $0F                   ;  | 
CODE_02A9F7:        B9 73 A7      LDA.W SpriteSlotMax,Y     ;  | 
CODE_02A9FA:        38            SEC                       ;  | 
CODE_02A9FB:        E5 0E         SBC $0E                   ;  | 
CODE_02A9FD:        A8            TAY                       ;  | 
CODE_02A9FE:        B9 C8 14      LDA.W $14C8,Y             ;  | If free slot... 
CODE_02AA01:        F0 07         BEQ Return02AA0A          ;  |  ...return 
CODE_02AA03:        88            DEY                       ;  | 
CODE_02AA04:        C4 0F         CPY $0F                   ;  | 
CODE_02AA06:        D0 F6         BNE CODE_02A9FE           ;  | 
CODE_02AA08:        A0 FF         LDY.B #$FF                ;  | If no free slots, Y=#$FF 
Return02AA0A:       60            RTS                       ; / 


DATA_02AA0B:                      .db $31,$71,$A1,$43,$93,$C3,$14,$65
                                  .db $E5,$36,$A7,$39,$99,$F9,$1A,$7A
                                  .db $DA,$4C,$AD,$ED

DATA_02AA1F:                      .db $01,$51,$91,$D1,$22,$62,$A2,$73
                                  .db $E3,$C7,$88,$29,$5A,$AA,$EB,$2C
                                  .db $8C,$CC,$FC,$5D

ADDR_02AA33:        A2 0E         LDX.B #$0E                ; \ Unreachable 
ADDR_02AA35:        9E 66 1E      STZ.W $1E66,X             ;  | Loop X = 00 to 0E 
ADDR_02AA38:        9E 86 0F      STZ.W $0F86,X             
ADDR_02AA3B:        A9 08         LDA.B #$08                
ADDR_02AA3D:        9D 92 18      STA.W $1892,X             
ADDR_02AA40:        22 F9 AC 01   JSL.L GetRand             
ADDR_02AA44:        18            CLC                       
ADDR_02AA45:        65 1A         ADC RAM_ScreenBndryXLo    
ADDR_02AA47:        9D 16 1E      STA.W $1E16,X             
ADDR_02AA4A:        9D 4A 0F      STA.W $0F4A,X             
ADDR_02AA4D:        A5 1B         LDA RAM_ScreenBndryXHi    
ADDR_02AA4F:        69 00         ADC.B #$00                
ADDR_02AA51:        9D 3E 1E      STA.W $1E3E,X             
ADDR_02AA54:        A4 03         LDY $03                   
ADDR_02AA56:        B7 CE         LDA [$CE],Y               
ADDR_02AA58:        48            PHA                       
ADDR_02AA59:        29 F0         AND.B #$F0                
ADDR_02AA5B:        9D 02 1E      STA.W $1E02,X             
ADDR_02AA5E:        68            PLA                       
ADDR_02AA5F:        29 01         AND.B #$01                
ADDR_02AA61:        9D 2A 1E      STA.W $1E2A,X             
ADDR_02AA64:        CA            DEX                       
ADDR_02AA65:        10 CE         BPL ADDR_02AA35           
Return02AA67:       60            RTS                       ; / Return 


DATA_02AA68:                      .db $50,$90,$D0,$10

CODE_02AA6C:        A9 07         LDA.B #$07                
CODE_02AA6E:        8D CB 14      STA.W $14CB               
CODE_02AA71:        A2 03         LDX.B #$03                
CODE_02AA73:        A9 05         LDA.B #$05                
CODE_02AA75:        9D 92 18      STA.W $1892,X             
CODE_02AA78:        BD 68 AA      LDA.W DATA_02AA68,X       
CODE_02AA7B:        9D 16 1E      STA.W $1E16,X             
CODE_02AA7E:        A9 F0         LDA.B #$F0                
CODE_02AA80:        9D 02 1E      STA.W $1E02,X             
CODE_02AA83:        8A            TXA                       
CODE_02AA84:        0A            ASL                       
CODE_02AA85:        0A            ASL                       
CODE_02AA86:        9D 4A 0F      STA.W $0F4A,X             
CODE_02AA89:        CA            DEX                       
CODE_02AA8A:        10 E7         BPL CODE_02AA73           
Return02AA8C:       60            RTS                       ; Return 

CODE_02AA8D:        9C 0A 19      STZ.W $190A               
CODE_02AA90:        A2 13         LDX.B #$13                
CODE_02AA92:        A9 07         LDA.B #$07                
CODE_02AA94:        9D 92 18      STA.W $1892,X             
CODE_02AA97:        BD 0B AA      LDA.W DATA_02AA0B,X       
CODE_02AA9A:        48            PHA                       
CODE_02AA9B:        29 F0         AND.B #$F0                
CODE_02AA9D:        9D 66 1E      STA.W $1E66,X             
CODE_02AAA0:        68            PLA                       
CODE_02AAA1:        0A            ASL                       
CODE_02AAA2:        0A            ASL                       
CODE_02AAA3:        0A            ASL                       
CODE_02AAA4:        0A            ASL                       
CODE_02AAA5:        9D 52 1E      STA.W $1E52,X             
CODE_02AAA8:        BD 1F AA      LDA.W DATA_02AA1F,X       
CODE_02AAAB:        48            PHA                       
CODE_02AAAC:        29 F0         AND.B #$F0                
CODE_02AAAE:        9D 8E 1E      STA.W $1E8E,X             
CODE_02AAB1:        68            PLA                       
CODE_02AAB2:        0A            ASL                       
CODE_02AAB3:        0A            ASL                       
CODE_02AAB4:        0A            ASL                       
CODE_02AAB5:        0A            ASL                       
CODE_02AAB6:        9D 7A 1E      STA.W $1E7A,X             
CODE_02AAB9:        CA            DEX                       
CODE_02AABA:        10 D6         BPL CODE_02AA92           
Return02AABC:       60            RTS                       ; Return 


DATA_02AABD:                      .db $4C,$33,$AA

CODE_02AAC0:        A0 01         LDY.B #$01                
CODE_02AAC2:        8C B8 18      STY.W $18B8               
CODE_02AAC5:        C9 E4         CMP.B #$E4                
CODE_02AAC7:        F0 F4         BEQ DATA_02AABD           
CODE_02AAC9:        C9 E6         CMP.B #$E6                
CODE_02AACB:        F0 9F         BEQ CODE_02AA6C           
CODE_02AACD:        C9 E5         CMP.B #$E5                
CODE_02AACF:        F0 BC         BEQ CODE_02AA8D           
CODE_02AAD1:        C9 E2         CMP.B #$E2                
CODE_02AAD3:        B0 3C         BCS CODE_02AB11           
CODE_02AAD5:        A2 13         LDX.B #$13                
CODE_02AAD7:        9E 66 1E      STZ.W $1E66,X             
CODE_02AADA:        9E 86 0F      STZ.W $0F86,X             
CODE_02AADD:        A9 03         LDA.B #$03                
CODE_02AADF:        9D 92 18      STA.W $1892,X             
CODE_02AAE2:        22 F9 AC 01   JSL.L GetRand             
CODE_02AAE6:        18            CLC                       
CODE_02AAE7:        65 1A         ADC RAM_ScreenBndryXLo    
CODE_02AAE9:        9D 16 1E      STA.W $1E16,X             
CODE_02AAEC:        9D 4A 0F      STA.W $0F4A,X             
CODE_02AAEF:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02AAF1:        69 00         ADC.B #$00                
CODE_02AAF3:        9D 3E 1E      STA.W $1E3E,X             
CODE_02AAF6:        AD 8E 14      LDA.W RAM_RandomByte2     
CODE_02AAF9:        29 3F         AND.B #$3F                
CODE_02AAFB:        69 08         ADC.B #$08                
CODE_02AAFD:        18            CLC                       
CODE_02AAFE:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_02AB00:        9D 02 1E      STA.W $1E02,X             
CODE_02AB03:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02AB05:        69 00         ADC.B #$00                
CODE_02AB07:        9D 2A 1E      STA.W $1E2A,X             
CODE_02AB0A:        CA            DEX                       
CODE_02AB0B:        10 CA         BPL CODE_02AAD7           
CODE_02AB0D:        EE BA 18      INC.W $18BA               
Return02AB10:       60            RTS                       ; Return 

CODE_02AB11:        AC BA 18      LDY.W $18BA               
CODE_02AB14:        C0 02         CPY.B #$02                
CODE_02AB16:        B0 5F         BCS Return02AB77          
CODE_02AB18:        A0 01         LDY.B #$01                
CODE_02AB1A:        C9 E2         CMP.B #$E2                
CODE_02AB1C:        F0 02         BEQ CODE_02AB20           
CODE_02AB1E:        A0 FF         LDY.B #$FF                
CODE_02AB20:        84 0F         STY $0F                   
CODE_02AB22:        A9 09         LDA.B #$09                
CODE_02AB24:        85 0E         STA $0E                   
CODE_02AB26:        A2 13         LDX.B #$13                
CODE_02AB28:        BD 92 18      LDA.W $1892,X             
CODE_02AB2B:        D0 44         BNE CODE_02AB71           
CODE_02AB2D:        A9 04         LDA.B #$04                
CODE_02AB2F:        9D 92 18      STA.W $1892,X             
CODE_02AB32:        AD BA 18      LDA.W $18BA               
CODE_02AB35:        9D 86 0F      STA.W $0F86,X             
CODE_02AB38:        A5 0E         LDA $0E                   
CODE_02AB3A:        9D 72 0F      STA.W $0F72,X             
CODE_02AB3D:        A5 0F         LDA $0F                   
CODE_02AB3F:        9D 4A 0F      STA.W $0F4A,X             
CODE_02AB42:        64 0F         STZ $0F                   
CODE_02AB44:        F0 27         BEQ CODE_02AB6D           
CODE_02AB46:        A4 03         LDY $03                   
CODE_02AB48:        B7 CE         LDA [$CE],Y               
CODE_02AB4A:        AC BA 18      LDY.W $18BA               
CODE_02AB4D:        48            PHA                       
CODE_02AB4E:        29 F0         AND.B #$F0                
CODE_02AB50:        99 B6 0F      STA.W $0FB6,Y             
CODE_02AB53:        68            PLA                       
CODE_02AB54:        29 01         AND.B #$01                
CODE_02AB56:        99 B8 0F      STA.W $0FB8,Y             
CODE_02AB59:        A5 00         LDA $00                   
CODE_02AB5B:        99 B2 0F      STA.W $0FB2,Y             
CODE_02AB5E:        A5 01         LDA $01                   
CODE_02AB60:        99 B4 0F      STA.W $0FB4,Y             
CODE_02AB63:        A9 00         LDA.B #$00                
CODE_02AB65:        99 BA 0F      STA.W $0FBA,Y             
CODE_02AB68:        A5 02         LDA $02                   
CODE_02AB6A:        99 BC 0F      STA.W $0FBC,Y             
CODE_02AB6D:        C6 0E         DEC $0E                   
CODE_02AB6F:        30 03         BMI CODE_02AB74           
CODE_02AB71:        CA            DEX                       
CODE_02AB72:        10 B4         BPL CODE_02AB28           
CODE_02AB74:        EE BA 18      INC.W $18BA               
Return02AB77:       60            RTS                       ; Return 

LoadShooter:        86 02         STX $02                   
CODE_02AB7A:        88            DEY                       
CODE_02AB7B:        84 03         STY $03                   
CODE_02AB7D:        85 04         STA $04                   
CODE_02AB7F:        A2 07         LDX.B #$07                
CODE_02AB81:        BD 83 17      LDA.W $1783,X             
CODE_02AB84:        F0 18         BEQ CODE_02AB9E           
CODE_02AB86:        CA            DEX                       
CODE_02AB87:        10 F8         BPL CODE_02AB81           
CODE_02AB89:        CE FF 18      DEC.W $18FF               
CODE_02AB8C:        10 05         BPL CODE_02AB93           
CODE_02AB8E:        A9 07         LDA.B #$07                
CODE_02AB90:        8D FF 18      STA.W $18FF               
CODE_02AB93:        AE FF 18      LDX.W $18FF               
CODE_02AB96:        BC B3 17      LDY.W $17B3,X             
CODE_02AB99:        A9 00         LDA.B #$00                ; \ Allow sprite to be reloaded by level loading routine 
CODE_02AB9B:        99 38 19      STA.W RAM_SprLoadStatus,Y ; / 
CODE_02AB9E:        A4 03         LDY $03                   
CODE_02ABA0:        A5 04         LDA $04                   
CODE_02ABA2:        38            SEC                       
CODE_02ABA3:        E9 C8         SBC.B #$C8                
CODE_02ABA5:        9D 83 17      STA.W $1783,X             
CODE_02ABA8:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_02ABAA:        4A            LSR                       
CODE_02ABAB:        90 1A         BCC CODE_02ABC7           
ADDR_02ABAD:        B7 CE         LDA [$CE],Y               
ADDR_02ABAF:        48            PHA                       
ADDR_02ABB0:        29 F0         AND.B #$F0                
ADDR_02ABB2:        9D 9B 17      STA.W RAM_ShooterXLo,X    
ADDR_02ABB5:        68            PLA                       
ADDR_02ABB6:        29 01         AND.B #$01                
ADDR_02ABB8:        9D A3 17      STA.W RAM_ShooterXHi,X    
ADDR_02ABBB:        A5 00         LDA $00                   
ADDR_02ABBD:        9D 8B 17      STA.W RAM_ShooterYLo,X    
ADDR_02ABC0:        A5 01         LDA $01                   
ADDR_02ABC2:        9D 93 17      STA.W RAM_ShooterYHi,X    
ADDR_02ABC5:        80 18         BRA CODE_02ABDF           

CODE_02ABC7:        B7 CE         LDA [$CE],Y               
CODE_02ABC9:        48            PHA                       
CODE_02ABCA:        29 F0         AND.B #$F0                
CODE_02ABCC:        9D 8B 17      STA.W RAM_ShooterYLo,X    
CODE_02ABCF:        68            PLA                       
CODE_02ABD0:        29 01         AND.B #$01                
CODE_02ABD2:        9D 93 17      STA.W RAM_ShooterYHi,X    
CODE_02ABD5:        A5 00         LDA $00                   
CODE_02ABD7:        9D 9B 17      STA.W RAM_ShooterXLo,X    
CODE_02ABDA:        A5 01         LDA $01                   
CODE_02ABDC:        9D A3 17      STA.W RAM_ShooterXHi,X    
CODE_02ABDF:        A5 02         LDA $02                   
CODE_02ABE1:        9D B3 17      STA.W $17B3,X             
CODE_02ABE4:        A9 10         LDA.B #$10                
CODE_02ABE6:        9D AB 17      STA.W RAM_ShooterTimer,X  
CODE_02ABE9:        C8            INY                       
CODE_02ABEA:        C8            INY                       
CODE_02ABEB:        C8            INY                       
CODE_02ABEC:        A6 02         LDX $02                   
CODE_02ABEE:        E8            INX                       
CODE_02ABEF:        4C 2E A8      JMP.W LoadSpriteLoopStrt  

CODE_02ABF2:        A2 3F         LDX.B #$3F                
CODE_02ABF4:        9E 38 19      STZ.W RAM_SprLoadStatus,X ; Allow sprite to be reloaded by level loading routine 
CODE_02ABF7:        CA            DEX                       
CODE_02ABF8:        10 FA         BPL CODE_02ABF4           
CODE_02ABFA:        A9 FF         LDA.B #$FF                
CODE_02ABFC:        85 00         STA $00                   
CODE_02ABFE:        A2 0B         LDX.B #$0B                
CODE_02AC00:        A9 FF         LDA.B #$FF                ; \ Set to permanently erase sprite 
CODE_02AC02:        9D 1A 16      STA.W RAM_SprIndexInLvl,X ; / 
CODE_02AC05:        BD C8 14      LDA.W $14C8,X             
CODE_02AC08:        C9 0B         CMP.B #$0B                
CODE_02AC0A:        F0 05         BEQ CODE_02AC11           
CODE_02AC0C:        9E C8 14      STZ.W $14C8,X             
CODE_02AC0F:        80 02         BRA CODE_02AC13           

CODE_02AC11:        86 00         STX $00                   
CODE_02AC13:        CA            DEX                       
CODE_02AC14:        10 EA         BPL CODE_02AC00           
CODE_02AC16:        A6 00         LDX $00                   
CODE_02AC18:        30 2E         BMI CODE_02AC48           
CODE_02AC1A:        9E C8 14      STZ.W $14C8,X             
CODE_02AC1D:        A9 0B         LDA.B #$0B                ; \ Sprite status = Being carried 
CODE_02AC1F:        8D C8 14      STA.W $14C8               ; / 
CODE_02AC22:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02AC24:        85 9E         STA RAM_SpriteNum         
CODE_02AC26:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02AC28:        85 E4         STA RAM_SpriteXLo         
CODE_02AC2A:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02AC2D:        8D E0 14      STA.W RAM_SpriteXHi       
CODE_02AC30:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02AC32:        85 D8         STA RAM_SpriteYLo         
CODE_02AC34:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02AC37:        8D D4 14      STA.W RAM_SpriteYHi       
CODE_02AC3A:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_02AC3D:        48            PHA                       
CODE_02AC3E:        A2 00         LDX.B #$00                
CODE_02AC40:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02AC44:        68            PLA                       
CODE_02AC45:        8D F6 15      STA.W RAM_SpritePal       
CODE_02AC48:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_02AC4A:        A2 7A 02      LDX.W #$027A              
CODE_02AC4D:        9E 93 16      STZ.W $1693,X             ; clear ram before entering new stage/area 
CODE_02AC50:        CA            DEX                       
CODE_02AC51:        10 FA         BPL CODE_02AC4D           
CODE_02AC53:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_02AC55:        9C 3E 14      STZ.W RAM_ScrollSprNum    
CODE_02AC58:        9C 3F 14      STZ.W $143F               
Return02AC5B:       60            RTS                       ; Return 

CODE_02AC5C:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_02AC5E:        4A            LSR                       
CODE_02AC5F:        90 40         BCC CODE_02ACA1           
CODE_02AC61:        A5 55         LDA $55                   
CODE_02AC63:        48            PHA                       
CODE_02AC64:        A9 01         LDA.B #$01                
CODE_02AC66:        85 55         STA $55                   
CODE_02AC68:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_02AC6A:        48            PHA                       
CODE_02AC6B:        38            SEC                       
CODE_02AC6C:        E9 60         SBC.B #$60                
CODE_02AC6E:        85 1C         STA RAM_ScreenBndryYLo    
CODE_02AC70:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02AC72:        48            PHA                       
CODE_02AC73:        E9 00         SBC.B #$00                
CODE_02AC75:        85 1D         STA RAM_ScreenBndryYHi    
CODE_02AC77:        9C B6 18      STZ.W $18B6               
CODE_02AC7A:        20 02 A8      JSR.W CODE_02A802         
CODE_02AC7D:        20 02 A8      JSR.W CODE_02A802         
CODE_02AC80:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_02AC82:        18            CLC                       
CODE_02AC83:        69 10         ADC.B #$10                
CODE_02AC85:        85 1C         STA RAM_ScreenBndryYLo    
CODE_02AC87:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02AC89:        69 00         ADC.B #$00                
CODE_02AC8B:        85 1D         STA RAM_ScreenBndryYHi    
CODE_02AC8D:        EE B6 18      INC.W $18B6               
CODE_02AC90:        AD B6 18      LDA.W $18B6               
CODE_02AC93:        C9 20         CMP.B #$20                
CODE_02AC95:        90 E3         BCC CODE_02AC7A           
CODE_02AC97:        68            PLA                       
CODE_02AC98:        85 1D         STA RAM_ScreenBndryYHi    
CODE_02AC9A:        68            PLA                       
CODE_02AC9B:        85 1C         STA RAM_ScreenBndryYLo    
CODE_02AC9D:        68            PLA                       
CODE_02AC9E:        85 55         STA $55                   
Return02ACA0:       60            RTS                       ; Return 

CODE_02ACA1:        A5 55         LDA $55                   
CODE_02ACA3:        48            PHA                       
CODE_02ACA4:        A9 01         LDA.B #$01                
CODE_02ACA6:        85 55         STA $55                   
CODE_02ACA8:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_02ACAA:        48            PHA                       
CODE_02ACAB:        38            SEC                       
CODE_02ACAC:        E9 60         SBC.B #$60                
CODE_02ACAE:        85 1A         STA RAM_ScreenBndryXLo    
CODE_02ACB0:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02ACB2:        48            PHA                       
CODE_02ACB3:        E9 00         SBC.B #$00                
CODE_02ACB5:        85 1B         STA RAM_ScreenBndryXHi    
CODE_02ACB7:        9C B6 18      STZ.W $18B6               
CODE_02ACBA:        20 02 A8      JSR.W CODE_02A802         
CODE_02ACBD:        20 02 A8      JSR.W CODE_02A802         
CODE_02ACC0:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_02ACC2:        18            CLC                       
CODE_02ACC3:        69 10         ADC.B #$10                
CODE_02ACC5:        85 1A         STA RAM_ScreenBndryXLo    
CODE_02ACC7:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02ACC9:        69 00         ADC.B #$00                
CODE_02ACCB:        85 1B         STA RAM_ScreenBndryXHi    
CODE_02ACCD:        EE B6 18      INC.W $18B6               
CODE_02ACD0:        AD B6 18      LDA.W $18B6               
CODE_02ACD3:        C9 20         CMP.B #$20                
CODE_02ACD5:        90 E3         BCC CODE_02ACBA           
CODE_02ACD7:        68            PLA                       
CODE_02ACD8:        85 1B         STA RAM_ScreenBndryXHi    
CODE_02ACDA:        68            PLA                       
CODE_02ACDB:        85 1A         STA RAM_ScreenBndryXLo    
CODE_02ACDD:        68            PLA                       
CODE_02ACDE:        85 55         STA $55                   
Return02ACE0:       60            RTS                       ; Return 

CODE_02ACE1:        DA            PHX                       
CODE_02ACE2:        BB            TYX                       
CODE_02ACE3:        80 01         BRA CODE_02ACE6           

GivePoints:         DA            PHX                       ;  takes sprite type -5 as input in A 
CODE_02ACE6:        18            CLC                       
CODE_02ACE7:        69 05         ADC.B #$05                ; Add 5 to sprite type (200,400,1up) 
CODE_02ACE9:        22 EF AC 02   JSL.L CODE_02ACEF         ; Set score sprite type/initial position 
CODE_02ACED:        FA            PLX                       
Return02ACEE:       6B            RTL                       ; Return 

CODE_02ACEF:        5A            PHY                       ;  - note coordinates are level coords, not screen 
CODE_02ACF0:        48            PHA                       ;    sprite type 1=10,2=20,3=40,4=80,5=100,6=200,7=400,8=800,9=1000,A=2000,B=4000,C=8000,D=1up 
CODE_02ACF1:        22 34 AD 02   JSL.L CODE_02AD34         ; Get next free position in table($16E1) to add score sprite 
CODE_02ACF5:        68            PLA                       
CODE_02ACF6:        99 E1 16      STA.W RAM_ScoreSprNum,Y   ; Set score sprite type (200,400,1up, etc) 
CODE_02ACF9:        B5 D8         LDA RAM_SpriteYLo,X       ; Load y position of sprite jumped on 
CODE_02ACFB:        38            SEC                       
CODE_02ACFC:        E9 08         SBC.B #$08                ;   - make the score sprite appear a little higher 
CODE_02ACFE:        99 E7 16      STA.W RAM_ScoreSprYLo,Y   ; Set this as score sprite y-position 
CODE_02AD01:        48            PHA                       ; save that value 
CODE_02AD02:        BD D4 14      LDA.W RAM_SpriteYHi,X     ; Get y-pos high byte for sprite jumped on 
CODE_02AD05:        E9 00         SBC.B #$00                
CODE_02AD07:        99 F9 16      STA.W RAM_ScoreSprYHi,Y   ; Set score sprite y-pos high byte 
CODE_02AD0A:        68            PLA                       ; restore score sprite y-pos to A 
CODE_02AD0B:        38            SEC                       ; \ 
CODE_02AD0C:        E5 1C         SBC RAM_ScreenBndryYLo    ; | 
CODE_02AD0E:        C9 F0         CMP.B #$F0                ; |if (score sprite ypos <1C && >=0C) 
CODE_02AD10:        90 10         BCC CODE_02AD22           ; |{ 
CODE_02AD12:        B9 E7 16      LDA.W RAM_ScoreSprYLo,Y   ; | 
CODE_02AD15:        69 10         ADC.B #$10                ; | 
CODE_02AD17:        99 E7 16      STA.W RAM_ScoreSprYLo,Y   ; |  move score sprite down by #$10 
CODE_02AD1A:        B9 F9 16      LDA.W RAM_ScoreSprYHi,Y   ; | 
CODE_02AD1D:        69 00         ADC.B #$00                ; | 
CODE_02AD1F:        99 F9 16      STA.W RAM_ScoreSprYHi,Y   ; /} 
CODE_02AD22:        B5 E4         LDA RAM_SpriteXLo,X       ; \ 
CODE_02AD24:        99 ED 16      STA.W RAM_ScoreSprXLo,Y   ; /Set score sprite x-position 
CODE_02AD27:        BD E0 14      LDA.W RAM_SpriteXHi,X     ; \ 
CODE_02AD2A:        99 F3 16      STA.W RAM_ScoreSprXHi,Y   ; /Set score sprite x-pos high byte 
CODE_02AD2D:        A9 30         LDA.B #$30                ; \ 
CODE_02AD2F:        99 FF 16      STA.W RAM_ScoreSprSpeedY,Y ; /scoreSpriteSpeed = #$30 
CODE_02AD32:        7A            PLY                       
Return02AD33:       6B            RTL                       ; Return 

CODE_02AD34:        A0 05         LDY.B #$05                ; (here css is used to index through the table of score sprites in table at $16E1 
CODE_02AD36:        B9 E1 16      LDA.W RAM_ScoreSprNum,Y   ; for (css=5;css>=0;css--){ 
CODE_02AD39:        F0 10         BEQ Return02AD4B          ;  if (css's type == 0)      --check for empty space 
CODE_02AD3B:        88            DEY                       
CODE_02AD3C:        10 F8         BPL CODE_02AD36           ; } 
CODE_02AD3E:        CE F7 18      DEC.W $18F7               ; $18f7--;                   --gives LRU 
CODE_02AD41:        10 05         BPL CODE_02AD48           ; if ($18f7 <0) 
CODE_02AD43:        A9 05         LDA.B #$05                ;   $18f7=5; 
CODE_02AD45:        8D F7 18      STA.W $18F7               
CODE_02AD48:        AC F7 18      LDY.W $18F7               ; return $18f7 in Y; 
Return02AD4B:       6B            RTL                       ; Return 


PointTile1:                       .db $00,$83,$83,$83,$83,$44,$54,$46
                                  .db $47,$44,$54,$46,$47,$56,$29,$39
                                  .db $38,$5E,$5E,$5E,$5E,$5E

PointTile2:                       .db $00,$44,$54,$46,$47,$45,$45,$45
                                  .db $45,$55,$55,$55,$55,$57,$57,$57
                                  .db $57,$4E,$44,$4F,$54,$5D

PointMultiplierLo:                .db $00,$01,$02,$04,$08,$0A,$14,$28
                                  .db $50,$64,$C8,$90,$20,$00,$00,$00
                                  .db $00

PointMultiplierHi:                .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$01,$03,$00,$00,$00
                                  .db $00

PointSpeedY:                      .db $03,$01,$00,$00

DATA_02AD9E:                      .db $B0,$B8,$C0,$C8,$D0,$D8

ScoreSprGfx:        2C 9B 0D      BIT.W $0D9B               
CODE_02ADA7:        50 0F         BVC CODE_02ADB8           
CODE_02ADA9:        AD 9B 0D      LDA.W $0D9B               
CODE_02ADAC:        C9 C1         CMP.B #$C1                
CODE_02ADAE:        F0 18         BEQ Return02ADC8          
CODE_02ADB0:        A9 F0         LDA.B #$F0                
CODE_02ADB2:        8D 05 02      STA.W $0205               
CODE_02ADB5:        8D 09 02      STA.W $0209               
CODE_02ADB8:        A2 05         LDX.B #$05                
CODE_02ADBA:        8E E9 15      STX.W $15E9               
CODE_02ADBD:        BD E1 16      LDA.W RAM_ScoreSprNum,X   
CODE_02ADC0:        F0 03         BEQ CODE_02ADC5           
CODE_02ADC2:        20 C9 AD      JSR.W CODE_02ADC9         
CODE_02ADC5:        CA            DEX                       
CODE_02ADC6:        10 F2         BPL CODE_02ADBA           
Return02ADC8:       60            RTS                       ; Return 

CODE_02ADC9:        A5 9D         LDA RAM_SpritesLocked     

Instr02ADCB:                      .db $F0,$03

CODE_02ADCD:        4C 5B AE      JMP.W CODE_02AE5B         

CODE_02ADD0:        BD FF 16      LDA.W RAM_ScoreSprSpeedY,X 

Instr02ADD3:                      .db $D0,$0F

CODE_02ADD5:        9E E1 16      STZ.W RAM_ScoreSprNum,X   
Return02ADD8:       60            RTS                       ; Return 


CoinsToGive:                      .db $01,$02,$03,$05,$05,$0A,$0F,$14
                                  .db $19

2Up3UpAttr:                       .db $04,$06

CODE_02ADE4:        DE FF 16      DEC.W RAM_ScoreSprSpeedY,X 
CODE_02ADE7:        C9 2A         CMP.B #$2A                
CODE_02ADE9:        D0 4D         BNE CODE_02AE38           
CODE_02ADEB:        BC E1 16      LDY.W RAM_ScoreSprNum,X   
CODE_02ADEE:        C0 0D         CPY.B #$0D                
CODE_02ADF0:        90 20         BCC CODE_02AE12           
CODE_02ADF2:        C0 11         CPY.B #$11                
CODE_02ADF4:        90 0D         BCC CODE_02AE03           
ADDR_02ADF6:        DA            PHX                       
ADDR_02ADF7:        5A            PHY                       
ADDR_02ADF8:        B9 CC AD      LDA.W ADDR_02ADCC,Y       
ADDR_02ADFB:        22 29 B3 05   JSL.L ADDR_05B329         
ADDR_02ADFF:        7A            PLY                       
ADDR_02AE00:        FA            PLX                       
ADDR_02AE01:        80 0F         BRA CODE_02AE12           

CODE_02AE03:        B9 CC AD      LDA.W ADDR_02ADCC,Y       
CODE_02AE06:        18            CLC                       
CODE_02AE07:        6D E4 18      ADC.W $18E4               
CODE_02AE0A:        8D E4 18      STA.W $18E4               
CODE_02AE0D:        9C E5 18      STZ.W $18E5               
CODE_02AE10:        80 23         BRA CODE_02AE35           

CODE_02AE12:        AD B3 0D      LDA.W $0DB3               
CODE_02AE15:        0A            ASL                       
CODE_02AE16:        6D B3 0D      ADC.W $0DB3               
CODE_02AE19:        AA            TAX                       
CODE_02AE1A:        BD 34 0F      LDA.W $0F34,X             
CODE_02AE1D:        18            CLC                       
CODE_02AE1E:        79 78 AD      ADC.W PointMultiplierLo,Y 
CODE_02AE21:        9D 34 0F      STA.W $0F34,X             
CODE_02AE24:        BD 35 0F      LDA.W $0F35,X             
CODE_02AE27:        79 89 AD      ADC.W PointMultiplierHi,Y 
CODE_02AE2A:        9D 35 0F      STA.W $0F35,X             
CODE_02AE2D:        BD 36 0F      LDA.W $0F36,X             
CODE_02AE30:        69 00         ADC.B #$00                
CODE_02AE32:        9D 36 0F      STA.W $0F36,X             
CODE_02AE35:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02AE38:        BD FF 16      LDA.W RAM_ScoreSprSpeedY,X 
CODE_02AE3B:        4A            LSR                       
CODE_02AE3C:        4A            LSR                       
CODE_02AE3D:        4A            LSR                       
CODE_02AE3E:        4A            LSR                       
CODE_02AE3F:        A8            TAY                       
CODE_02AE40:        A5 13         LDA RAM_FrameCounter      
CODE_02AE42:        39 9A AD      AND.W PointSpeedY,Y       
CODE_02AE45:        D0 14         BNE CODE_02AE5B           
CODE_02AE47:        BD E7 16      LDA.W RAM_ScoreSprYLo,X   
CODE_02AE4A:        A8            TAY                       
CODE_02AE4B:        38            SEC                       
CODE_02AE4C:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02AE4E:        C9 04         CMP.B #$04                
CODE_02AE50:        90 09         BCC CODE_02AE5B           
CODE_02AE52:        DE E7 16      DEC.W RAM_ScoreSprYLo,X   
CODE_02AE55:        98            TYA                       
CODE_02AE56:        D0 03         BNE CODE_02AE5B           
CODE_02AE58:        DE F9 16      DEC.W RAM_ScoreSprYHi,X   
CODE_02AE5B:        BD 05 17      LDA.W $1705,X             
CODE_02AE5E:        0A            ASL                       
CODE_02AE5F:        0A            ASL                       
CODE_02AE60:        A8            TAY                       
CODE_02AE61:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_02AE63:        B9 1C 00      LDA.W RAM_ScreenBndryYLo,Y 
CODE_02AE66:        85 02         STA $02                   
CODE_02AE68:        B9 1A 00      LDA.W RAM_ScreenBndryXLo,Y 
CODE_02AE6B:        85 04         STA $04                   
CODE_02AE6D:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_02AE6F:        BD ED 16      LDA.W RAM_ScoreSprXLo,X   
CODE_02AE72:        18            CLC                       
CODE_02AE73:        69 0C         ADC.B #$0C                
CODE_02AE75:        08            PHP                       
CODE_02AE76:        38            SEC                       
CODE_02AE77:        E5 04         SBC $04                   
CODE_02AE79:        BD F3 16      LDA.W RAM_ScoreSprXHi,X   
CODE_02AE7C:        E5 05         SBC $05                   
CODE_02AE7E:        28            PLP                       
CODE_02AE7F:        69 00         ADC.B #$00                
CODE_02AE81:        D0 78         BNE Return02AEFB          
CODE_02AE83:        BD ED 16      LDA.W RAM_ScoreSprXLo,X   
CODE_02AE86:        C5 04         CMP $04                   
CODE_02AE88:        BD F3 16      LDA.W RAM_ScoreSprXHi,X   
CODE_02AE8B:        E5 05         SBC $05                   
CODE_02AE8D:        D0 6C         BNE Return02AEFB          
CODE_02AE8F:        BD E7 16      LDA.W RAM_ScoreSprYLo,X   
CODE_02AE92:        C5 02         CMP $02                   
CODE_02AE94:        BD F9 16      LDA.W RAM_ScoreSprYHi,X   
CODE_02AE97:        E5 03         SBC $03                   
CODE_02AE99:        D0 60         BNE Return02AEFB          
CODE_02AE9B:        BC 9E AD      LDY.W DATA_02AD9E,X       
CODE_02AE9E:        2C 9B 0D      BIT.W $0D9B               
CODE_02AEA1:        50 02         BVC CODE_02AEA5           
CODE_02AEA3:        A0 04         LDY.B #$04                
CODE_02AEA5:        BD E7 16      LDA.W RAM_ScoreSprYLo,X   
CODE_02AEA8:        38            SEC                       
CODE_02AEA9:        E5 02         SBC $02                   
CODE_02AEAB:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_02AEAE:        99 05 02      STA.W $0205,Y             
CODE_02AEB1:        BD ED 16      LDA.W RAM_ScoreSprXLo,X   
CODE_02AEB4:        38            SEC                       
CODE_02AEB5:        E5 04         SBC $04                   
CODE_02AEB7:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_02AEBA:        18            CLC                       
CODE_02AEBB:        69 08         ADC.B #$08                
CODE_02AEBD:        99 04 02      STA.W $0204,Y             
CODE_02AEC0:        DA            PHX                       
CODE_02AEC1:        BD E1 16      LDA.W RAM_ScoreSprNum,X   
CODE_02AEC4:        AA            TAX                       
CODE_02AEC5:        BD 4C AD      LDA.W PointTile1,X        
CODE_02AEC8:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02AECB:        BD 62 AD      LDA.W PointTile2,X        
CODE_02AECE:        99 06 02      STA.W $0206,Y             
CODE_02AED1:        FA            PLX                       
CODE_02AED2:        5A            PHY                       
CODE_02AED3:        BC E1 16      LDY.W RAM_ScoreSprNum,X   
CODE_02AED6:        C0 0E         CPY.B #$0E                
CODE_02AED8:        A9 08         LDA.B #$08                
CODE_02AEDA:        90 03         BCC CODE_02AEDF           
CODE_02AEDC:        B9 D4 AD      LDA.W ADDR_02ADD4,Y       
CODE_02AEDF:        7A            PLY                       
CODE_02AEE0:        09 30         ORA.B #$30                
CODE_02AEE2:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02AEE5:        99 07 02      STA.W $0207,Y             
CODE_02AEE8:        98            TYA                       
CODE_02AEE9:        4A            LSR                       
CODE_02AEEA:        4A            LSR                       
CODE_02AEEB:        A8            TAY                       
CODE_02AEEC:        A9 00         LDA.B #$00                
CODE_02AEEE:        99 20 04      STA.W $0420,Y             
CODE_02AEF1:        99 21 04      STA.W $0421,Y             
CODE_02AEF4:        BD E1 16      LDA.W RAM_ScoreSprNum,X   
CODE_02AEF7:        C9 11         CMP.B #$11                
CODE_02AEF9:        B0 01         BCS ADDR_02AEFC           
Return02AEFB:       60            RTS                       ; Return 

ADDR_02AEFC:        A0 4C         LDY.B #$4C                
ADDR_02AEFE:        BD ED 16      LDA.W RAM_ScoreSprXLo,X   
ADDR_02AF01:        38            SEC                       
ADDR_02AF02:        E5 04         SBC $04                   
ADDR_02AF04:        38            SEC                       
ADDR_02AF05:        E9 08         SBC.B #$08                
ADDR_02AF07:        99 00 02      STA.W OAM_ExtendedDispX,Y 
ADDR_02AF0A:        BD E7 16      LDA.W RAM_ScoreSprYLo,X   
ADDR_02AF0D:        38            SEC                       
ADDR_02AF0E:        E5 02         SBC $02                   
ADDR_02AF10:        99 01 02      STA.W OAM_ExtendedDispY,Y 
ADDR_02AF13:        A9 5F         LDA.B #$5F                
ADDR_02AF15:        99 02 02      STA.W OAM_ExtendedTile,Y  
ADDR_02AF18:        A9 04         LDA.B #$04                
ADDR_02AF1A:        09 30         ORA.B #$30                
ADDR_02AF1C:        99 03 02      STA.W OAM_ExtendedProp,Y  
ADDR_02AF1F:        98            TYA                       
ADDR_02AF20:        4A            LSR                       
ADDR_02AF21:        4A            LSR                       
ADDR_02AF22:        A8            TAY                       
ADDR_02AF23:        A9 00         LDA.B #$00                
ADDR_02AF25:        99 20 04      STA.W $0420,Y             
Return02AF28:       60            RTS                       ; Return 

ADDR_02AF29:        9E E1 16      STZ.W RAM_ScoreSprNum,X   ; \ Unreachable 
Return02AF2C:       60            RTS                       ; / 


DATA_02AF2D:                      .db $00,$AA,$54

DATA_02AF30:                      .db $00,$00,$01

Load3Platforms:     A4 03         LDY $03                   
CODE_02AF35:        B7 CE         LDA [$CE],Y               
CODE_02AF37:        48            PHA                       
CODE_02AF38:        29 F0         AND.B #$F0                
CODE_02AF3A:        85 08         STA $08                   
CODE_02AF3C:        68            PLA                       
CODE_02AF3D:        29 01         AND.B #$01                
CODE_02AF3F:        85 09         STA $09                   
CODE_02AF41:        A9 02         LDA.B #$02                
CODE_02AF43:        85 04         STA $04                   
CODE_02AF45:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_02AF49:        30 3B         BMI Return02AF86          ; / 
CODE_02AF4B:        BB            TYX                       
CODE_02AF4C:        A9 01         LDA.B #$01                ; \ Sprite status = Initialization 
CODE_02AF4E:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02AF51:        A9 A3         LDA.B #$A3                ; \ Sprite = Grey Platform on Chain 
CODE_02AF53:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_02AF55:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02AF59:        A5 00         LDA $00                   
CODE_02AF5B:        95 E4         STA RAM_SpriteXLo,X       
CODE_02AF5D:        A5 01         LDA $01                   
CODE_02AF5F:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02AF62:        A5 08         LDA $08                   
CODE_02AF64:        95 D8         STA RAM_SpriteYLo,X       
CODE_02AF66:        A5 09         LDA $09                   
CODE_02AF68:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02AF6B:        A4 04         LDY $04                   
CODE_02AF6D:        B9 2D AF      LDA.W DATA_02AF2D,Y       
CODE_02AF70:        9D 02 16      STA.W $1602,X             
CODE_02AF73:        B9 30 AF      LDA.W DATA_02AF30,Y       
CODE_02AF76:        9D 1C 15      STA.W $151C,X             
CODE_02AF79:        C0 02         CPY.B #$02                
CODE_02AF7B:        D0 05         BNE CODE_02AF82           
CODE_02AF7D:        A5 02         LDA $02                   
CODE_02AF7F:        9D 1A 16      STA.W RAM_SprIndexInLvl,X 
CODE_02AF82:        C6 04         DEC $04                   
CODE_02AF84:        10 BF         BPL CODE_02AF45           
Return02AF86:       60            RTS                       ; Return 


EerieGroupDispXLo:                .db $E0,$F0,$00,$10,$20

EerieGroupDispXHi:                .db $FF,$FF,$00,$00,$00

EerieGroupSpeedY:                 .db $17,$E9,$17,$E9,$17

EerieGroupState:                  .db $00,$01,$00,$01,$00

EerieGroupSpeedX:                 .db $10,$F0

Load5Eeries:        A4 03         LDY $03                   
CODE_02AF9F:        B7 CE         LDA [$CE],Y               
CODE_02AFA1:        48            PHA                       
CODE_02AFA2:        29 F0         AND.B #$F0                
CODE_02AFA4:        85 08         STA $08                   
CODE_02AFA6:        68            PLA                       
CODE_02AFA7:        29 01         AND.B #$01                
CODE_02AFA9:        85 09         STA $09                   
CODE_02AFAB:        A9 04         LDA.B #$04                
CODE_02AFAD:        85 04         STA $04                   
CODE_02AFAF:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_02AFB3:        30 48         BMI Return02AFFD          ; / 
CODE_02AFB5:        BB            TYX                       
CODE_02AFB6:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02AFB8:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02AFBB:        A9 39         LDA.B #$39                ; \ Sprite = Wave Eerie 
CODE_02AFBD:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_02AFBF:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02AFC3:        A4 04         LDY $04                   
CODE_02AFC5:        A5 00         LDA $00                   
CODE_02AFC7:        18            CLC                       
CODE_02AFC8:        79 87 AF      ADC.W EerieGroupDispXLo,Y 
CODE_02AFCB:        95 E4         STA RAM_SpriteXLo,X       
CODE_02AFCD:        A5 01         LDA $01                   
CODE_02AFCF:        79 8C AF      ADC.W EerieGroupDispXHi,Y 
CODE_02AFD2:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02AFD5:        A5 08         LDA $08                   
CODE_02AFD7:        95 D8         STA RAM_SpriteYLo,X       
CODE_02AFD9:        A5 09         LDA $09                   
CODE_02AFDB:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02AFDE:        B9 91 AF      LDA.W EerieGroupSpeedY,Y  
CODE_02AFE1:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02AFE3:        B9 96 AF      LDA.W EerieGroupState,Y   
CODE_02AFE6:        95 C2         STA RAM_SpriteState,X     
CODE_02AFE8:        C0 04         CPY.B #$04                
CODE_02AFEA:        D0 05         BNE CODE_02AFF1           
CODE_02AFEC:        A5 02         LDA $02                   
CODE_02AFEE:        9D 1A 16      STA.W RAM_SprIndexInLvl,X 
CODE_02AFF1:        20 8D 84      JSR.W SubHorzPosBnk2      
CODE_02AFF4:        B9 9B AF      LDA.W EerieGroupSpeedX,Y  
CODE_02AFF7:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02AFF9:        C6 04         DEC $04                   
CODE_02AFFB:        10 B2         BPL CODE_02AFAF           
Return02AFFD:       60            RTS                       ; Return 

CallGenerator:      AD B9 18      LDA.W RAM_GeneratorNum    
CODE_02B001:        F0 27         BEQ Return02B02A          
CODE_02B003:        A4 9D         LDY RAM_SpritesLocked     
CODE_02B005:        D0 23         BNE Return02B02A          
CODE_02B007:        3A            DEC A                     
CODE_02B008:        22 DF 86 00   JSL.L ExecutePtr          

GeneratorPtrs:         D6 B2      .dw GenerateEerie         ; 00 - Eerie, generator                          
                       29 B3      .dw GenParaEnemy          ; 01 - Para-Goomba, generator                    
                       29 B3      .dw GenParaEnemy          ; 02 - Para-Bomb, generator                      
                       29 B3      .dw GenParaEnemy          ; 03 - Para-Bomb and Para-Goomba, generator      
                       6C B2      .dw GenerateDolphin       ; 04 - Dolphin, left, generator                  
                       6C B2      .dw GenerateDolphin       ; 05 - Dolphin, right, generator                 
                       5B B1      .dw GenerateFish          ; 06 - Jumping fish, generator                   
                       2B B0      .dw TurnOffGen2           ; 07 - Turn off generator 2 (sprite E5)          
                       BC B1      .dw GenSuperKoopa         ; 08 - Super Koopa, generator                    
                       07 B2      .dw GenerateBubble        ; 09 - Bubble with Goomba and Bob-omb, generator 
                       7C B0      .dw GenerateBullet        ; 0A - Bullet Bill, generator                    
                       CD B0      .dw GenMultiBullets       ; 0B - Bullet Bill surrounded, generator         
                       CD B0      .dw GenMultiBullets       ; 0C - Bullet Bill diagonal, generator           
                       36 B0      .dw GenerateFire          ; 0D - Bowser statue fire breath, generator      
                       32 B0      .dw TurnOffGenerators     ; 0E - Turn off standard generators              

Return02B02A:       60            RTS                       ; Return 

TurnOffGen2:        EE BF 18      INC.W $18BF               
CODE_02B02E:        9C C0 18      STZ.W RAM_TimeTillRespawn ; Don't respawn any sprites 
Return02B031:       60            RTS                       ; Return 

TurnOffGenerators:  9C B9 18      STZ.W RAM_GeneratorNum    
Return02B035:       60            RTS                       ; Return 

GenerateFire:       A5 14         LDA RAM_FrameCounterB     
CODE_02B038:        29 7F         AND.B #$7F                
CODE_02B03A:        D0 3F         BNE Return02B07B          
CODE_02B03C:        22 DE A9 02   JSL.L FindFreeSlotLowPri  
CODE_02B040:        30 39         BMI Return02B07B          
CODE_02B042:        BB            TYX                       
CODE_02B043:        A9 17         LDA.B #$17                ; \ Play sound effect 
CODE_02B045:        8D FC 1D      STA.W $1DFC               ; / 
CODE_02B048:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02B04A:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02B04D:        A9 B3         LDA.B #$B3                ; \ Sprite = Bowser's Statue Fireball 
CODE_02B04F:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_02B051:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02B055:        22 F9 AC 01   JSL.L GetRand             
CODE_02B059:        29 7F         AND.B #$7F                
CODE_02B05B:        69 20         ADC.B #$20                
CODE_02B05D:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_02B05F:        29 F0         AND.B #$F0                
CODE_02B061:        95 D8         STA RAM_SpriteYLo,X       
CODE_02B063:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02B065:        69 00         ADC.B #$00                
CODE_02B067:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02B06A:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_02B06C:        18            CLC                       
CODE_02B06D:        69 FF         ADC.B #$FF                
CODE_02B06F:        95 E4         STA RAM_SpriteXLo,X       
CODE_02B071:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02B073:        69 00         ADC.B #$00                
CODE_02B075:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02B078:        FE 7C 15      INC.W RAM_SpriteDir,X     
Return02B07B:       60            RTS                       ; Return 

GenerateBullet:     A5 14         LDA RAM_FrameCounterB     
CODE_02B07E:        29 7F         AND.B #$7F                ;  | 
CODE_02B080:        D0 46         BNE Return02B0C8          ; / 
CODE_02B082:        22 DE A9 02   JSL.L FindFreeSlotLowPri  
CODE_02B086:        30 40         BMI Return02B0C8          
CODE_02B088:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_02B08A:        8D FC 1D      STA.W $1DFC               ; / 
CODE_02B08D:        BB            TYX                       
CODE_02B08E:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02B090:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02B093:        A9 1C         LDA.B #$1C                ; \ Sprite = Bullet Bill 
CODE_02B095:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_02B097:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02B09B:        22 F9 AC 01   JSL.L GetRand             
CODE_02B09F:        48            PHA                       
CODE_02B0A0:        29 7F         AND.B #$7F                
CODE_02B0A2:        69 20         ADC.B #$20                
CODE_02B0A4:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_02B0A6:        29 F0         AND.B #$F0                
CODE_02B0A8:        95 D8         STA RAM_SpriteYLo,X       
CODE_02B0AA:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02B0AC:        69 00         ADC.B #$00                
CODE_02B0AE:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02B0B1:        68            PLA                       
CODE_02B0B2:        29 01         AND.B #$01                
CODE_02B0B4:        A8            TAY                       
CODE_02B0B5:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_02B0B7:        18            CLC                       
CODE_02B0B8:        79 B8 B1      ADC.W DATA_02B1B8,Y       
CODE_02B0BB:        95 E4         STA RAM_SpriteXLo,X       
CODE_02B0BD:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02B0BF:        79 BA B1      ADC.W DATA_02B1BA,Y       
CODE_02B0C2:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02B0C5:        98            TYA                       
CODE_02B0C6:        95 C2         STA RAM_SpriteState,X     
Return02B0C8:       60            RTS                       ; Return 


DATA_02B0C9:                      .db $04,$08,$04,$03

GenMultiBullets:    A5 14         LDA RAM_FrameCounterB     
CODE_02B0CF:        4A            LSR                       
CODE_02B0D0:        B0 27         BCS Return02B0F9          
CODE_02B0D2:        AD FE 18      LDA.W $18FE               
CODE_02B0D5:        EE FE 18      INC.W $18FE               
CODE_02B0D8:        C9 A0         CMP.B #$A0                
CODE_02B0DA:        D0 1D         BNE Return02B0F9          
CODE_02B0DC:        9C FE 18      STZ.W $18FE               
CODE_02B0DF:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_02B0E1:        8D FC 1D      STA.W $1DFC               ; / 
CODE_02B0E4:        AC B9 18      LDY.W RAM_GeneratorNum    
CODE_02B0E7:        B9 BD B0      LDA.W CODE_02B0BD,Y       
CODE_02B0EA:        BE BF B0      LDX.W CODE_02B0BF,Y       
CODE_02B0ED:        85 0D         STA $0D                   
CODE_02B0EF:        DA            PHX                       
CODE_02B0F0:        20 15 B1      JSR.W CODE_02B115         
CODE_02B0F3:        C6 0D         DEC $0D                   
CODE_02B0F5:        FA            PLX                       
CODE_02B0F6:        CA            DEX                       
CODE_02B0F7:        10 F6         BPL CODE_02B0EF           
Return02B0F9:       60            RTS                       ; Return 


DATA_02B0FA:                      .db $00,$00,$40,$C0,$F0,$00,$00,$F0
                                  .db $F0

DATA_02B103:                      .db $50,$B0,$E0,$E0,$80,$00,$E0,$E0
                                  .db $00

DATA_02B10C:                      .db $00,$00,$02,$02,$01,$05,$04,$07
                                  .db $06

CODE_02B115:        22 DE A9 02   JSL.L FindFreeSlotLowPri  
CODE_02B119:        30 37         BMI Return02B152          
CODE_02B11B:        A9 1C         LDA.B #$1C                ; \ Sprite = Bullet Bill 
CODE_02B11D:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
CODE_02B120:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02B122:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02B125:        BB            TYX                       
CODE_02B126:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02B12A:        A6 0D         LDX $0D                   
CODE_02B12C:        BD FA B0      LDA.W DATA_02B0FA,X       
CODE_02B12F:        18            CLC                       
CODE_02B130:        65 1A         ADC RAM_ScreenBndryXLo    
CODE_02B132:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_02B135:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02B137:        69 00         ADC.B #$00                
CODE_02B139:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_02B13C:        BD 03 B1      LDA.W DATA_02B103,X       
CODE_02B13F:        18            CLC                       
CODE_02B140:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_02B142:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_02B145:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02B147:        69 00         ADC.B #$00                
CODE_02B149:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_02B14C:        BD 0C B1      LDA.W DATA_02B10C,X       
CODE_02B14F:        99 C2 00      STA.W RAM_SpriteState,Y   
Return02B152:       60            RTS                       ; Return 


DATA_02B153:                      .db $10,$18,$20,$28

DATA_02B157:                      .db $18,$1A,$1C,$1E

GenerateFish:       A5 14         LDA RAM_FrameCounterB     
CODE_02B15D:        29 1F         AND.B #$1F                
CODE_02B15F:        D0 56         BNE Return02B1B7          
CODE_02B161:        22 DE A9 02   JSL.L FindFreeSlotLowPri  
CODE_02B165:        30 50         BMI Return02B1B7          
CODE_02B167:        BB            TYX                       
CODE_02B168:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02B16A:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02B16D:        A9 17         LDA.B #$17                ; \ Sprite = Flying Fish 
CODE_02B16F:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_02B171:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02B175:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_02B177:        18            CLC                       
CODE_02B178:        69 C0         ADC.B #$C0                
CODE_02B17A:        95 D8         STA RAM_SpriteYLo,X       
CODE_02B17C:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02B17E:        69 00         ADC.B #$00                
CODE_02B180:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02B183:        22 F9 AC 01   JSL.L GetRand             
CODE_02B187:        C9 00         CMP.B #$00                
CODE_02B189:        08            PHP                       
CODE_02B18A:        08            PHP                       
CODE_02B18B:        29 03         AND.B #$03                
CODE_02B18D:        A8            TAY                       
CODE_02B18E:        B9 53 B1      LDA.W DATA_02B153,Y       
CODE_02B191:        28            PLP                       
CODE_02B192:        10 02         BPL CODE_02B196           
CODE_02B194:        49 FF         EOR.B #$FF                
CODE_02B196:        18            CLC                       
CODE_02B197:        65 1A         ADC RAM_ScreenBndryXLo    
CODE_02B199:        95 E4         STA RAM_SpriteXLo,X       
CODE_02B19B:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02B19D:        69 00         ADC.B #$00                
CODE_02B19F:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02B1A2:        AD 8E 14      LDA.W RAM_RandomByte2     
CODE_02B1A5:        29 03         AND.B #$03                
CODE_02B1A7:        A8            TAY                       
CODE_02B1A8:        B9 57 B1      LDA.W DATA_02B157,Y       
CODE_02B1AB:        28            PLP                       
CODE_02B1AC:        10 03         BPL CODE_02B1B1           
CODE_02B1AE:        49 FF         EOR.B #$FF                
CODE_02B1B0:        1A            INC A                     
CODE_02B1B1:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02B1B3:        A9 B8         LDA.B #$B8                
CODE_02B1B5:        95 AA         STA RAM_SpriteSpeedY,X    
Return02B1B7:       60            RTS                       ; Return 


DATA_02B1B8:                      .db $E0,$10

DATA_02B1BA:                      .db $FF,$01

GenSuperKoopa:      A5 14         LDA RAM_FrameCounterB     
CODE_02B1BE:        29 3F         AND.B #$3F                
CODE_02B1C0:        D0 44         BNE Return02B206          
CODE_02B1C2:        22 DE A9 02   JSL.L FindFreeSlotLowPri  
CODE_02B1C6:        30 3E         BMI Return02B206          
CODE_02B1C8:        BB            TYX                       
CODE_02B1C9:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02B1CB:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02B1CE:        A9 71         LDA.B #$71                
CODE_02B1D0:        95 9E         STA RAM_SpriteNum,X       
CODE_02B1D2:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02B1D6:        22 F9 AC 01   JSL.L GetRand             
CODE_02B1DA:        48            PHA                       
CODE_02B1DB:        29 3F         AND.B #$3F                
CODE_02B1DD:        69 20         ADC.B #$20                
CODE_02B1DF:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_02B1E1:        95 D8         STA RAM_SpriteYLo,X       
CODE_02B1E3:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02B1E5:        69 00         ADC.B #$00                
CODE_02B1E7:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02B1EA:        A9 28         LDA.B #$28                
CODE_02B1EC:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02B1EE:        68            PLA                       
CODE_02B1EF:        29 01         AND.B #$01                
CODE_02B1F1:        A8            TAY                       
CODE_02B1F2:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_02B1F4:        18            CLC                       
CODE_02B1F5:        79 B8 B1      ADC.W DATA_02B1B8,Y       
CODE_02B1F8:        95 E4         STA RAM_SpriteXLo,X       
CODE_02B1FA:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02B1FC:        79 BA B1      ADC.W DATA_02B1BA,Y       
CODE_02B1FF:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02B202:        98            TYA                       
CODE_02B203:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return02B206:       60            RTS                       ; Return 

GenerateBubble:     A5 14         LDA RAM_FrameCounterB     
CODE_02B209:        29 7F         AND.B #$7F                
CODE_02B20B:        D0 4C         BNE Return02B259          
CODE_02B20D:        22 DE A9 02   JSL.L FindFreeSlotLowPri  
CODE_02B211:        30 46         BMI Return02B259          
CODE_02B213:        BB            TYX                       
CODE_02B214:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02B216:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02B219:        A9 9D         LDA.B #$9D                
CODE_02B21B:        95 9E         STA RAM_SpriteNum,X       
CODE_02B21D:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02B221:        22 F9 AC 01   JSL.L GetRand             
CODE_02B225:        48            PHA                       
CODE_02B226:        29 3F         AND.B #$3F                
CODE_02B228:        69 20         ADC.B #$20                
CODE_02B22A:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_02B22C:        95 D8         STA RAM_SpriteYLo,X       
CODE_02B22E:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02B230:        69 00         ADC.B #$00                
CODE_02B232:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02B235:        68            PLA                       
CODE_02B236:        29 01         AND.B #$01                
CODE_02B238:        A8            TAY                       
CODE_02B239:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_02B23B:        18            CLC                       
CODE_02B23C:        79 B8 B1      ADC.W DATA_02B1B8,Y       
CODE_02B23F:        95 E4         STA RAM_SpriteXLo,X       
CODE_02B241:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02B243:        79 BA B1      ADC.W DATA_02B1BA,Y       
CODE_02B246:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02B249:        98            TYA                       
CODE_02B24A:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02B24D:        22 F9 AC 01   JSL.L GetRand             
CODE_02B251:        29 03         AND.B #$03                
CODE_02B253:        A8            TAY                       
CODE_02B254:        B9 5A B2      LDA.W DATA_02B25A,Y       
CODE_02B257:        95 C2         STA RAM_SpriteState,X     
Return02B259:       60            RTS                       ; Return 


DATA_02B25A:                      .db $00

DATA_02B25B:                      .db $01,$02

DATA_02B25D:                      .db $00,$10,$E0,$01,$FF,$E8

DATA_02B263:                      .db $18

DATA_02B264:                      .db $F0

DATA_02B265:                      .db $E0,$00,$10,$04,$09,$FF,$04

GenerateDolphin:    A5 14         LDA RAM_FrameCounterB     
CODE_02B26E:        29 1F         AND.B #$1F                
CODE_02B270:        D0 5D         BNE Return02B2CF          
CODE_02B272:        AC B9 18      LDY.W RAM_GeneratorNum    
CODE_02B275:        BE 63 B2      LDX.W DATA_02B263,Y       
CODE_02B278:        B9 65 B2      LDA.W DATA_02B265,Y       
CODE_02B27B:        85 00         STA $00                   
CODE_02B27D:        BD C8 14      LDA.W $14C8,X             
CODE_02B280:        F0 06         BEQ CODE_02B288           
CODE_02B282:        CA            DEX                       
CODE_02B283:        E4 00         CPX $00                   
CODE_02B285:        D0 F6         BNE CODE_02B27D           
Return02B287:       60            RTS                       ; Return 

CODE_02B288:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02B28A:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02B28D:        A9 41         LDA.B #$41                
CODE_02B28F:        95 9E         STA RAM_SpriteNum,X       
CODE_02B291:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02B295:        22 F9 AC 01   JSL.L GetRand             
CODE_02B299:        29 7F         AND.B #$7F                
CODE_02B29B:        69 40         ADC.B #$40                
CODE_02B29D:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_02B29F:        95 D8         STA RAM_SpriteYLo,X       
CODE_02B2A1:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02B2A3:        69 00         ADC.B #$00                
CODE_02B2A5:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02B2A8:        22 F9 AC 01   JSL.L GetRand             
CODE_02B2AC:        29 03         AND.B #$03                
CODE_02B2AE:        A8            TAY                       
CODE_02B2AF:        B9 64 B2      LDA.W DATA_02B264,Y       
CODE_02B2B2:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02B2B4:        AC B9 18      LDY.W RAM_GeneratorNum    
CODE_02B2B7:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_02B2B9:        18            CLC                       
CODE_02B2BA:        79 59 B2      ADC.W Return02B259,Y      
CODE_02B2BD:        95 E4         STA RAM_SpriteXLo,X       
CODE_02B2BF:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02B2C1:        79 5B B2      ADC.W DATA_02B25B,Y       
CODE_02B2C4:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02B2C7:        B9 5D B2      LDA.W DATA_02B25D,Y       
CODE_02B2CA:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02B2CC:        FE 1C 15      INC.W $151C,X             
Return02B2CF:       60            RTS                       ; Return 


DATA_02B2D0:                      .db $F0,$FF

DATA_02B2D2:                      .db $FF,$00

DATA_02B2D4:                      .db $10,$F0

GenerateEerie:      A5 14         LDA RAM_FrameCounterB     
ADDR_02B2D8:        29 3F         AND.B #$3F                
ADDR_02B2DA:        D0 42         BNE Return02B31E          
ADDR_02B2DC:        22 DE A9 02   JSL.L FindFreeSlotLowPri  
ADDR_02B2E0:        30 3C         BMI Return02B31E          
ADDR_02B2E2:        BB            TYX                       
ADDR_02B2E3:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
ADDR_02B2E5:        9D C8 14      STA.W $14C8,X             ; / 
ADDR_02B2E8:        A9 38         LDA.B #$38                
ADDR_02B2EA:        95 9E         STA RAM_SpriteNum,X       
ADDR_02B2EC:        22 D2 F7 07   JSL.L InitSpriteTables    
ADDR_02B2F0:        22 F9 AC 01   JSL.L GetRand             
ADDR_02B2F4:        29 7F         AND.B #$7F                
ADDR_02B2F6:        69 40         ADC.B #$40                
ADDR_02B2F8:        65 1C         ADC RAM_ScreenBndryYLo    
ADDR_02B2FA:        95 D8         STA RAM_SpriteYLo,X       
ADDR_02B2FC:        A5 1D         LDA RAM_ScreenBndryYHi    
ADDR_02B2FE:        69 00         ADC.B #$00                
ADDR_02B300:        9D D4 14      STA.W RAM_SpriteYHi,X     
ADDR_02B303:        AD 8E 14      LDA.W RAM_RandomByte2     
ADDR_02B306:        29 01         AND.B #$01                
ADDR_02B308:        A8            TAY                       
ADDR_02B309:        B9 D0 B2      LDA.W DATA_02B2D0,Y       
ADDR_02B30C:        18            CLC                       
ADDR_02B30D:        65 1A         ADC RAM_ScreenBndryXLo    
ADDR_02B30F:        95 E4         STA RAM_SpriteXLo,X       
ADDR_02B311:        A5 1B         LDA RAM_ScreenBndryXHi    
ADDR_02B313:        79 D2 B2      ADC.W DATA_02B2D2,Y       
ADDR_02B316:        9D E0 14      STA.W RAM_SpriteXHi,X     
ADDR_02B319:        B9 D4 B2      LDA.W DATA_02B2D4,Y       

Instr02B31C:                      .db $95,$B6

Return02B31E:       60            RTS                       ; Return 


DATA_02B31F:                      .db $3F,$40,$3F,$3F,$40,$40

DATA_02B325:                      .db $FA,$FB,$FC,$FD

GenParaEnemy:       A5 14         LDA RAM_FrameCounterB     
CODE_02B32B:        29 7F         AND.B #$7F                
CODE_02B32D:        D0 57         BNE Return02B386          
CODE_02B32F:        22 DE A9 02   JSL.L FindFreeSlotLowPri  
CODE_02B333:        30 51         BMI Return02B386          
CODE_02B335:        BB            TYX                       
CODE_02B336:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02B338:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02B33B:        22 F9 AC 01   JSL.L GetRand             
CODE_02B33F:        4A            LSR                       
CODE_02B340:        AC B9 18      LDY.W RAM_GeneratorNum    
CODE_02B343:        90 03         BCC CODE_02B348           
CODE_02B345:        C8            INY                       
CODE_02B346:        C8            INY                       
CODE_02B347:        C8            INY                       
CODE_02B348:        B9 1D B3      LDA.W ADDR_02B31D,Y       
CODE_02B34B:        95 9E         STA RAM_SpriteNum,X       
CODE_02B34D:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02B351:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_02B353:        38            SEC                       
CODE_02B354:        E9 20         SBC.B #$20                
CODE_02B356:        95 D8         STA RAM_SpriteYLo,X       
CODE_02B358:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02B35A:        E9 00         SBC.B #$00                
CODE_02B35C:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02B35F:        AD 8D 14      LDA.W RAM_RandomByte1     
CODE_02B362:        29 FF         AND.B #$FF                
CODE_02B364:        18            CLC                       
CODE_02B365:        69 30         ADC.B #$30                
CODE_02B367:        08            PHP                       
CODE_02B368:        65 1A         ADC RAM_ScreenBndryXLo    
CODE_02B36A:        95 E4         STA RAM_SpriteXLo,X       
CODE_02B36C:        08            PHP                       
CODE_02B36D:        29 0E         AND.B #$0E                
CODE_02B36F:        9D 70 15      STA.W $1570,X             
CODE_02B372:        4A            LSR                       
CODE_02B373:        29 03         AND.B #$03                
CODE_02B375:        A8            TAY                       
CODE_02B376:        B9 25 B3      LDA.W DATA_02B325,Y       
CODE_02B379:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02B37B:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02B37D:        28            PLP                       
CODE_02B37E:        69 00         ADC.B #$00                
CODE_02B380:        28            PLP                       
CODE_02B381:        69 00         ADC.B #$00                
CODE_02B383:        9D E0 14      STA.W RAM_SpriteXHi,X     
Return02B386:       60            RTS                       ; Return 

CODE_02B387:        A5 9D         LDA RAM_SpritesLocked     
CODE_02B389:        D0 1F         BNE Return02B3AA          
CODE_02B38B:        A2 07         LDX.B #$07                
CODE_02B38D:        8E E9 15      STX.W $15E9               
CODE_02B390:        BD 83 17      LDA.W $1783,X             
CODE_02B393:        F0 12         BEQ CODE_02B3A7           
CODE_02B395:        BC AB 17      LDY.W RAM_ShooterTimer,X  
CODE_02B398:        F0 0A         BEQ CODE_02B3A4           
CODE_02B39A:        48            PHA                       
CODE_02B39B:        A5 13         LDA RAM_FrameCounter      
CODE_02B39D:        4A            LSR                       
CODE_02B39E:        90 03         BCC CODE_02B3A3           
CODE_02B3A0:        DE AB 17      DEC.W RAM_ShooterTimer,X  
CODE_02B3A3:        68            PLA                       
CODE_02B3A4:        20 AB B3      JSR.W CODE_02B3AB         
CODE_02B3A7:        CA            DEX                       
CODE_02B3A8:        10 E3         BPL CODE_02B38D           
Return02B3AA:       60            RTS                       ; Return 

CODE_02B3AB:        3A            DEC A                     
CODE_02B3AC:        22 DF 86 00   JSL.L ExecutePtr          

ShooterPtrs:           66 B4      .dw ShootBullet           ; 00 - Bullet Bill shooter 
                       B6 B3      .dw LaunchTorpedo         ; 01 - Torpedo Ted launcher 
                       AA B3      .dw Return02B3AA          ; 02 - Unused 

LaunchTorpedo:      BD AB 17      LDA.W RAM_ShooterTimer,X  
CODE_02B3B9:        D0 71         BNE Return02B42C          
CODE_02B3BB:        A9 50         LDA.B #$50                
CODE_02B3BD:        9D AB 17      STA.W RAM_ShooterTimer,X  
CODE_02B3C0:        BD 8B 17      LDA.W RAM_ShooterYLo,X    
CODE_02B3C3:        C5 1C         CMP RAM_ScreenBndryYLo    
CODE_02B3C5:        BD 93 17      LDA.W RAM_ShooterYHi,X    
CODE_02B3C8:        E5 1D         SBC RAM_ScreenBndryYHi    
CODE_02B3CA:        D0 DE         BNE Return02B3AA          
CODE_02B3CC:        BD 9B 17      LDA.W RAM_ShooterXLo,X    
CODE_02B3CF:        C5 1A         CMP RAM_ScreenBndryXLo    
CODE_02B3D1:        BD A3 17      LDA.W RAM_ShooterXHi,X    
CODE_02B3D4:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_02B3D6:        D0 D2         BNE Return02B3AA          
CODE_02B3D8:        BD 9B 17      LDA.W RAM_ShooterXLo,X    
CODE_02B3DB:        38            SEC                       
CODE_02B3DC:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02B3DE:        18            CLC                       
CODE_02B3DF:        69 10         ADC.B #$10                
CODE_02B3E1:        C9 20         CMP.B #$20                
CODE_02B3E3:        90 47         BCC Return02B42C          
CODE_02B3E5:        22 DE A9 02   JSL.L FindFreeSlotLowPri  
CODE_02B3E9:        30 41         BMI Return02B42C          
CODE_02B3EB:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02B3ED:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02B3F0:        A9 44         LDA.B #$44                ; \ Sprite = Torpedo Ted 
CODE_02B3F2:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
CODE_02B3F5:        BD 9B 17      LDA.W RAM_ShooterXLo,X    ; \ Sprite position = Shooter position 
CODE_02B3F8:        99 E4 00      STA.W RAM_SpriteXLo,Y     ;  | 
CODE_02B3FB:        BD A3 17      LDA.W RAM_ShooterXHi,X    ;  | 
CODE_02B3FE:        99 E0 14      STA.W RAM_SpriteXHi,Y     ;  | 
CODE_02B401:        BD 8B 17      LDA.W RAM_ShooterYLo,X    ;  | 
CODE_02B404:        99 D8 00      STA.W RAM_SpriteYLo,Y     ;  | 
CODE_02B407:        BD 93 17      LDA.W RAM_ShooterYHi,X    ;  | 
CODE_02B40A:        99 D4 14      STA.W RAM_SpriteYHi,Y     ; / 
CODE_02B40D:        DA            PHX                       
CODE_02B40E:        BB            TYX                       ; X = sprite index 
CODE_02B40F:        22 D2 F7 07   JSL.L InitSpriteTables    ; Setup sprite tables 
CODE_02B413:        20 8D 84      JSR.W SubHorzPosBnk2      ; \ Direction = Towards Mario 
CODE_02B416:        98            TYA                       ;  | 
CODE_02B417:        9D 7C 15      STA.W RAM_SpriteDir,X     ; / 
CODE_02B41A:        85 00         STA $00                   ; $00 = sprite direction 
CODE_02B41C:        A9 30         LDA.B #$30                ; \ Set time to stay behind objects 
CODE_02B41E:        9D 40 15      STA.W $1540,X             ; / 
CODE_02B421:        FA            PLX                       ; X = shooter index 
CODE_02B422:        A0 07         LDY.B #$07                ; \ Find a free extended sprite slot 
CODE_02B424:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   ;  | 
CODE_02B427:        F0 04         BEQ CODE_02B42D           ;  | 
CODE_02B429:        88            DEY                       ;  | 
CODE_02B42A:        10 F8         BPL CODE_02B424           ;  | 
Return02B42C:       60            RTS                       ; / Return if no free slots 

CODE_02B42D:        A9 08         LDA.B #$08                ; \ Extended sprite = Torpedo Ted arm 
CODE_02B42F:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_02B432:        BD 9B 17      LDA.W RAM_ShooterXLo,X    
CODE_02B435:        18            CLC                       
CODE_02B436:        69 08         ADC.B #$08                
CODE_02B438:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
CODE_02B43B:        BD A3 17      LDA.W RAM_ShooterXHi,X    
CODE_02B43E:        69 00         ADC.B #$00                
CODE_02B440:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
CODE_02B443:        BD 8B 17      LDA.W RAM_ShooterYLo,X    
CODE_02B446:        38            SEC                       
CODE_02B447:        E9 09         SBC.B #$09                
CODE_02B449:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
CODE_02B44C:        BD 93 17      LDA.W RAM_ShooterYHi,X    
CODE_02B44F:        E9 00         SBC.B #$00                
CODE_02B451:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
CODE_02B454:        A9 90         LDA.B #$90                
CODE_02B456:        99 6F 17      STA.W $176F,Y             
CODE_02B459:        DA            PHX                       
CODE_02B45A:        A6 00         LDX $00                   
CODE_02B45C:        BD 64 B4      LDA.W DATA_02B464,X       
CODE_02B45F:        99 47 17      STA.W RAM_ExSprSpeedX,Y   
CODE_02B462:        FA            PLX                       
Return02B463:       60            RTS                       ; Return 


DATA_02B464:                      .db $01,$FF

ShootBullet:        BD AB 17      LDA.W RAM_ShooterTimer,X  ; \ Return if it's not time to generate			        
CODE_02B469:        D0 72         BNE Return02B4DD          ; /								        
CODE_02B46B:        A9 60         LDA.B #$60                ; \ Set time till next generation = 60			        
CODE_02B46D:        9D AB 17      STA.W RAM_ShooterTimer,X  ; /								        
CODE_02B470:        BD 8B 17      LDA.W RAM_ShooterYLo,X    ; \ Don't generate if off screen vertically			        
CODE_02B473:        C5 1C         CMP RAM_ScreenBndryYLo    ;  |							        
CODE_02B475:        BD 93 17      LDA.W RAM_ShooterYHi,X    ;  |							        
CODE_02B478:        E5 1D         SBC RAM_ScreenBndryYHi    ;  |							        
CODE_02B47A:        D0 61         BNE Return02B4DD          ; /								        
CODE_02B47C:        BD 9B 17      LDA.W RAM_ShooterXLo,X    ; \ Don't generate if off screen horizontally		        
CODE_02B47F:        C5 1A         CMP RAM_ScreenBndryXLo    ;  |							        
CODE_02B481:        BD A3 17      LDA.W RAM_ShooterXHi,X    ;  |							        
CODE_02B484:        E5 1B         SBC RAM_ScreenBndryXHi    ;  |							        
CODE_02B486:        D0 55         BNE Return02B4DD          ; / 							        
CODE_02B488:        BD 9B 17      LDA.W RAM_ShooterXLo,X    ; \ ?? something else related to x position of generator??	        
CODE_02B48B:        38            SEC                       ;  | 							        
CODE_02B48C:        E5 1A         SBC RAM_ScreenBndryXLo    ;  |							        
CODE_02B48E:        18            CLC                       ;  |							        
CODE_02B48F:        69 10         ADC.B #$10                ;  |							        
CODE_02B491:        C9 10         CMP.B #$10                ;  |							        
CODE_02B493:        90 48         BCC Return02B4DD          ; /								        
CODE_02B495:        A5 94         LDA RAM_MarioXPos         ; \ Don't fire if mario is next to generator		        
CODE_02B497:        FD 9B 17      SBC.W RAM_ShooterXLo,X    ;  |							        
CODE_02B49A:        18            CLC                       ;  |							        
CODE_02B49B:        69 11         ADC.B #$11                ;  |							        
CODE_02B49D:        C9 22         CMP.B #$22                ;  |							        
CODE_02B49F:        90 3C         BCC Return02B4DD          ; /								        
CODE_02B4A1:        22 DE A9 02   JSL.L FindFreeSlotLowPri  ; \ Get an index to an unused sprite slot, return if all slots full 
CODE_02B4A5:        30 36         BMI Return02B4DD          ; / After: Y has index of sprite being generated		 
GenerateBullet:     A9 09         LDA.B #$09                ; \ Only shoot every #$80 frames 
CODE_02B4A9:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_02B4AC:        A9 01         LDA.B #$01                ; \ Sprite status = Initialization 
CODE_02B4AE:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02B4B1:        A9 1C         LDA.B #$1C                ; \ New sprite = Bullet Bill 
CODE_02B4B3:        99 9E 00      STA.W RAM_SpriteNum,Y     ; /								 
CODE_02B4B6:        BD 9B 17      LDA.W RAM_ShooterXLo,X    ; \ Set x position for new sprite				 
CODE_02B4B9:        99 E4 00      STA.W RAM_SpriteXLo,Y     ;  |							 
CODE_02B4BC:        BD A3 17      LDA.W RAM_ShooterXHi,X    ;  |							 
CODE_02B4BF:        99 E0 14      STA.W RAM_SpriteXHi,Y     ; /								 
CODE_02B4C2:        BD 8B 17      LDA.W RAM_ShooterYLo,X    ; \ Set y position for new sprite				 
CODE_02B4C5:        38            SEC                       ;  | (y position of generator - 1)				 
CODE_02B4C6:        E9 01         SBC.B #$01                ;  |							 
CODE_02B4C8:        99 D8 00      STA.W RAM_SpriteYLo,Y     ;  |							 
CODE_02B4CB:        BD 93 17      LDA.W RAM_ShooterYHi,X    ;  |							 
CODE_02B4CE:        E9 00         SBC.B #$00                ;  |							 
CODE_02B4D0:        99 D4 14      STA.W RAM_SpriteYHi,Y     ; /								 
CODE_02B4D3:        DA            PHX                       ; \ Before: X must have index of sprite being generated	 
CODE_02B4D4:        BB            TYX                       ;  | Routine clears *all* old sprite values...		 
CODE_02B4D5:        22 D2 F7 07   JSL.L InitSpriteTables    ;  | ...and loads in new values for the 6 main sprite tables 
CODE_02B4D9:        FA            PLX                       ; / 							 
CODE_02B4DA:        20 DE B4      JSR.W ShowShooterSmoke    ; Display smoke graphic                                      
Return02B4DD:       60            RTS                       ; Return 

ShowShooterSmoke:   A0 03         LDY.B #$03                ; \ Find a free slot to display effect 
FindFreeSmokeSlot:  B9 C0 17      LDA.W $17C0,Y             ;  | 
CODE_02B4E3:        F0 06         BEQ SetShooterSmoke       ;  | 
CODE_02B4E5:        88            DEY                       ;  | 
CODE_02B4E6:        10 F8         BPL FindFreeSmokeSlot     ;  | 
Return02B4E8:       60            RTS                       ; / Return if no free slots 


ShooterSmokeDispX:                .db $F4,$0C

SetShooterSmoke:    A9 01         LDA.B #$01                ; \ Set effect graphic to smoke graphic		  
CODE_02B4ED:        99 C0 17      STA.W $17C0,Y             ; /							  
CODE_02B4F0:        BD 8B 17      LDA.W RAM_ShooterYLo,X    ; \ Smoke y position = generator y position		  
CODE_02B4F3:        99 C4 17      STA.W $17C4,Y             ; /							  
CODE_02B4F6:        A9 1B         LDA.B #$1B                ; \ Set time to show smoke				  
CODE_02B4F8:        99 CC 17      STA.W $17CC,Y             ; /							  
CODE_02B4FB:        BD 9B 17      LDA.W RAM_ShooterXLo,X    ; \ Load generator x position and store it for later  
CODE_02B4FE:        48            PHA                       ; /							  
CODE_02B4FF:        A5 94         LDA RAM_MarioXPos         ; \ Determine which side of the generator mario is on 
CODE_02B501:        DD 9B 17      CMP.W RAM_ShooterXLo,X    ;  |						  
CODE_02B504:        A5 95         LDA RAM_MarioXPosHi       ;  |						  
CODE_02B506:        FD A3 17      SBC.W RAM_ShooterXHi,X    ;  |						  
CODE_02B509:        A2 00         LDX.B #$00                ;  |						  
CODE_02B50B:        90 01         BCC CODE_02B50E           ;  |						  
CODE_02B50D:        E8            INX                       ; /							  
CODE_02B50E:        68            PLA                       ; \ Set smoke x position from generator position	  
CODE_02B50F:        18            CLC                       ;  |						  
CODE_02B510:        7D E9 B4      ADC.W ShooterSmokeDispX,X ;  |						  
CODE_02B513:        99 C8 17      STA.W $17C8,Y             ; /   
CODE_02B516:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return02B519:       60            RTS                       ; Return 

CODE_02B51A:        8A            TXA                       
CODE_02B51B:        18            CLC                       
CODE_02B51C:        69 04         ADC.B #$04                
CODE_02B51E:        AA            TAX                       
CODE_02B51F:        20 26 B5      JSR.W CODE_02B526         
CODE_02B522:        AE 98 16      LDX.W $1698               
Return02B525:       60            RTS                       ; Return 

CODE_02B526:        BD B1 16      LDA.W RAM_BouncBlkSpeedX,X 
CODE_02B529:        0A            ASL                       
CODE_02B52A:        0A            ASL                       
CODE_02B52B:        0A            ASL                       
CODE_02B52C:        0A            ASL                       
CODE_02B52D:        18            CLC                       
CODE_02B52E:        7D B9 16      ADC.W $16B9,X             
CODE_02B531:        9D B9 16      STA.W $16B9,X             
CODE_02B534:        08            PHP                       
CODE_02B535:        BD B1 16      LDA.W RAM_BouncBlkSpeedX,X 
CODE_02B538:        4A            LSR                       
CODE_02B539:        4A            LSR                       
CODE_02B53A:        4A            LSR                       
CODE_02B53B:        4A            LSR                       
CODE_02B53C:        C9 08         CMP.B #$08                
CODE_02B53E:        A0 00         LDY.B #$00                
CODE_02B540:        90 03         BCC CODE_02B545           
CODE_02B542:        09 F0         ORA.B #$F0                
CODE_02B544:        88            DEY                       
CODE_02B545:        28            PLP                       
CODE_02B546:        7D A1 16      ADC.W RAM_BounceSprXLo,X  
CODE_02B549:        9D A1 16      STA.W RAM_BounceSprXLo,X  
CODE_02B54C:        98            TYA                       
CODE_02B54D:        7D A9 16      ADC.W RAM_BounceSprXHi,X  
CODE_02B550:        9D A9 16      STA.W RAM_BounceSprXHi,X  
Return02B553:       60            RTS                       ; Return 

CODE_02B554:        8A            TXA                       
CODE_02B555:        18            CLC                       
CODE_02B556:        69 0A         ADC.B #$0A                
CODE_02B558:        AA            TAX                       
CODE_02B559:        20 60 B5      JSR.W CODE_02B560         
CODE_02B55C:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return02B55F:       60            RTS                       ; Return 

CODE_02B560:        BD 3D 17      LDA.W RAM_ExSprSpeedY,X   
CODE_02B563:        0A            ASL                       
CODE_02B564:        0A            ASL                       
CODE_02B565:        0A            ASL                       
CODE_02B566:        0A            ASL                       
CODE_02B567:        18            CLC                       
CODE_02B568:        7D 51 17      ADC.W $1751,X             
CODE_02B56B:        9D 51 17      STA.W $1751,X             
CODE_02B56E:        08            PHP                       
CODE_02B56F:        A0 00         LDY.B #$00                
CODE_02B571:        BD 3D 17      LDA.W RAM_ExSprSpeedY,X   
CODE_02B574:        4A            LSR                       
CODE_02B575:        4A            LSR                       
CODE_02B576:        4A            LSR                       
CODE_02B577:        4A            LSR                       
CODE_02B578:        C9 08         CMP.B #$08                
CODE_02B57A:        90 03         BCC CODE_02B57F           
CODE_02B57C:        09 F0         ORA.B #$F0                
CODE_02B57E:        88            DEY                       
CODE_02B57F:        28            PLP                       
CODE_02B580:        7D 15 17      ADC.W RAM_ExSpriteYLo,X   
CODE_02B583:        9D 15 17      STA.W RAM_ExSpriteYLo,X   
CODE_02B586:        98            TYA                       
CODE_02B587:        7D 29 17      ADC.W RAM_ExSpriteYHi,X   
CODE_02B58A:        9D 29 17      STA.W RAM_ExSpriteYHi,X   
Return02B58D:       60            RTS                       ; Return 

CODE_02B58E:        BD D8 17      LDA.W $17D8,X             
CODE_02B591:        0A            ASL                       
CODE_02B592:        0A            ASL                       
CODE_02B593:        0A            ASL                       
CODE_02B594:        0A            ASL                       
CODE_02B595:        18            CLC                       
CODE_02B596:        7D DC 17      ADC.W $17DC,X             
CODE_02B599:        9D DC 17      STA.W $17DC,X             
CODE_02B59C:        08            PHP                       
CODE_02B59D:        A0 00         LDY.B #$00                
CODE_02B59F:        BD D8 17      LDA.W $17D8,X             
CODE_02B5A2:        4A            LSR                       
CODE_02B5A3:        4A            LSR                       
CODE_02B5A4:        4A            LSR                       
CODE_02B5A5:        4A            LSR                       
CODE_02B5A6:        C9 08         CMP.B #$08                
CODE_02B5A8:        90 03         BCC CODE_02B5AD           
CODE_02B5AA:        09 F0         ORA.B #$F0                
CODE_02B5AC:        88            DEY                       
CODE_02B5AD:        28            PLP                       
CODE_02B5AE:        7D D4 17      ADC.W $17D4,X             
CODE_02B5B1:        9D D4 17      STA.W $17D4,X             
CODE_02B5B4:        98            TYA                       
CODE_02B5B5:        7D E8 17      ADC.W $17E8,X             
CODE_02B5B8:        9D E8 17      STA.W $17E8,X             
Return02B5BB:       60            RTS                       ; Return 

CODE_02B5BC:        8A            TXA                       
CODE_02B5BD:        18            CLC                       
CODE_02B5BE:        69 0C         ADC.B #$0C                
CODE_02B5C0:        AA            TAX                       
CODE_02B5C1:        20 C8 B5      JSR.W CODE_02B5C8         
CODE_02B5C4:        AE 98 16      LDX.W $1698               
Return02B5C7:       60            RTS                       ; Return 

CODE_02B5C8:        BD 20 18      LDA.W $1820,X             
CODE_02B5CB:        0A            ASL                       
CODE_02B5CC:        0A            ASL                       
CODE_02B5CD:        0A            ASL                       
CODE_02B5CE:        0A            ASL                       
CODE_02B5CF:        18            CLC                       
CODE_02B5D0:        7D 38 18      ADC.W $1838,X             
CODE_02B5D3:        9D 38 18      STA.W $1838,X             
CODE_02B5D6:        08            PHP                       
CODE_02B5D7:        BD 20 18      LDA.W $1820,X             
CODE_02B5DA:        4A            LSR                       
CODE_02B5DB:        4A            LSR                       
CODE_02B5DC:        4A            LSR                       
CODE_02B5DD:        4A            LSR                       
CODE_02B5DE:        C9 08         CMP.B #$08                
CODE_02B5E0:        90 02         BCC CODE_02B5E4           
CODE_02B5E2:        09 F0         ORA.B #$F0                
CODE_02B5E4:        28            PLP                       
CODE_02B5E5:        7D FC 17      ADC.W $17FC,X             
CODE_02B5E8:        9D FC 17      STA.W $17FC,X             
Return02B5EB:       60            RTS                       ; Return 


Empty02B5EC:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF

PokeyClipIndex:                   .db $1B,$1B,$1A,$19,$18,$17

PokeyMain:          8B            PHB                       
CODE_02B637:        4B            PHK                       
CODE_02B638:        AB            PLB                       
CODE_02B639:        20 72 B6      JSR.W PokeyMainRt         
CODE_02B63C:        B5 C2         LDA RAM_SpriteState,X     ; \ After: Y = number of segments 
CODE_02B63E:        DA            PHX                       ;  | $C2,x has a bit set for each segment remaining 
CODE_02B63F:        A2 04         LDX.B #$04                ;  | for X=0 to X=4... 
CODE_02B641:        A0 00         LDY.B #$00                ;  | 
PokeyLoopStart:     4A            LSR                       ;  | 
CODE_02B644:        90 01         BCC BitNotSet             ;  | 
CODE_02B646:        C8            INY                       ;  | ...Increment Y if bit X is set 
BitNotSet:          CA            DEX                       ;  | 
CODE_02B648:        10 F9         BPL PokeyLoopStart        ;  | 
CODE_02B64A:        FA            PLX                       ; / 
CODE_02B64B:        B9 30 B6      LDA.W PokeyClipIndex,Y    ; \ Update the index into the clipping table 
CODE_02B64E:        9D 62 16      STA.W RAM_Tweaker1662,X   ; / 
CODE_02B651:        AB            PLB                       
Return02B652:       6B            RTL                       ; Return 


DATA_02B653:                      .db $01,$02,$04,$08

DATA_02B657:                      .db $00,$01,$03,$07

DATA_02B65B:                      .db $FF,$FE,$FC,$F8

PokeyTileDispX:                   .db $00,$01,$00,$FF

PokeySpeed:                       .db $02,$FE

DATA_02B665:                      .db $00,$05,$09,$0C,$0E,$0F,$10,$10
                                  .db $10,$10,$10,$10,$10

PokeyMainRt:        BD 34 15      LDA.W $1534,X             
CODE_02B675:        D0 0A         BNE CODE_02B681           
CODE_02B677:        BD C8 14      LDA.W $14C8,X             ; \ Branch if Status == Normal 
CODE_02B67A:        C9 08         CMP.B #$08                ;  | 
CODE_02B67C:        F0 29         BEQ CODE_02B6A7           ; / 
CODE_02B67E:        4C 26 B7      JMP.W CODE_02B726         

CODE_02B681:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_02B685:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02B688:        B5 C2         LDA RAM_SpriteState,X     
CODE_02B68A:        C9 01         CMP.B #$01                
CODE_02B68C:        A9 8A         LDA.B #$8A                
CODE_02B68E:        90 02         BCC CODE_02B692           
CODE_02B690:        A9 E8         LDA.B #$E8                
CODE_02B692:        99 02 03      STA.W OAM_Tile,Y          
CODE_02B695:        BD C8 14      LDA.W $14C8,X             
CODE_02B698:        C9 08         CMP.B #$08                
CODE_02B69A:        D0 0A         BNE Return02B6A6          
CODE_02B69C:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02B69F:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_02B6A1:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_02B6A3:        20 25 D0      JSR.W SubOffscreen0Bnk2   
Return02B6A6:       60            RTS                       ; Return 

CODE_02B6A7:        B5 C2         LDA RAM_SpriteState,X     ; \ Erase sprite if no segments remain 
CODE_02B6A9:        D0 04         BNE PokeyAlive            ;  | 
CODE_02B6AB:        9E C8 14      STZ.W $14C8,X             ;  | 
Return02B6AE:       60            RTS                       ; Return 

PokeyAlive:         C9 20         CMP.B #$20                
CODE_02B6B1:        B0 F8         BCS CODE_02B6AB           
CODE_02B6B3:        A5 9D         LDA RAM_SpritesLocked     
CODE_02B6B5:        D0 6F         BNE CODE_02B726           
CODE_02B6B7:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02B6BA:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_02B6BE:        FE 70 15      INC.W $1570,X             
CODE_02B6C1:        BD 70 15      LDA.W $1570,X             
CODE_02B6C4:        29 7F         AND.B #$7F                
CODE_02B6C6:        D0 07         BNE CODE_02B6CF           
CODE_02B6C8:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02B6CB:        98            TYA                       
CODE_02B6CC:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02B6CF:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02B6D2:        B9 63 B6      LDA.W PokeySpeed,Y        
CODE_02B6D5:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02B6D7:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02B6DA:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02B6DD:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02B6DF:        C9 40         CMP.B #$40                
CODE_02B6E1:        10 05         BPL CODE_02B6E8           
CODE_02B6E3:        18            CLC                       
CODE_02B6E4:        69 02         ADC.B #$02                
CODE_02B6E6:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02B6E8:        22 38 91 01   JSL.L CODE_019138         
CODE_02B6EC:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02B6EF:        29 04         AND.B #$04                ;  | 
CODE_02B6F1:        F0 02         BEQ CODE_02B6F5           ; / 
CODE_02B6F3:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_02B6F5:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_02B6F8:        29 03         AND.B #$03                
CODE_02B6FA:        F0 08         BEQ CODE_02B704           
ADDR_02B6FC:        BD 7C 15      LDA.W RAM_SpriteDir,X     
ADDR_02B6FF:        49 01         EOR.B #$01                
ADDR_02B701:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02B704:        20 AC B7      JSR.W CODE_02B7AC         
CODE_02B707:        A0 00         LDY.B #$00                
CODE_02B709:        B5 C2         LDA RAM_SpriteState,X     
CODE_02B70B:        39 53 B6      AND.W DATA_02B653,Y       
CODE_02B70E:        D0 11         BNE CODE_02B721           
CODE_02B710:        B5 C2         LDA RAM_SpriteState,X     
CODE_02B712:        48            PHA                       
CODE_02B713:        39 57 B6      AND.W DATA_02B657,Y       
CODE_02B716:        85 00         STA $00                   
CODE_02B718:        68            PLA                       
CODE_02B719:        4A            LSR                       
CODE_02B71A:        39 5B B6      AND.W DATA_02B65B,Y       
CODE_02B71D:        05 00         ORA $00                   
CODE_02B71F:        95 C2         STA RAM_SpriteState,X     
CODE_02B721:        C8            INY                       
CODE_02B722:        C0 04         CPY.B #$04                
CODE_02B724:        D0 E3         BNE CODE_02B709           
CODE_02B726:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02B729:        A5 01         LDA $01                   
CODE_02B72B:        18            CLC                       
CODE_02B72C:        69 40         ADC.B #$40                
CODE_02B72E:        85 01         STA $01                   
CODE_02B730:        B5 C2         LDA RAM_SpriteState,X     
CODE_02B732:        85 02         STA $02                   
CODE_02B734:        85 07         STA $07                   
CODE_02B736:        BD 1C 15      LDA.W $151C,X             
CODE_02B739:        85 04         STA $04                   
CODE_02B73B:        BC 40 15      LDY.W $1540,X             
CODE_02B73E:        B9 65 B6      LDA.W DATA_02B665,Y       
CODE_02B741:        85 03         STA $03                   
CODE_02B743:        64 05         STZ $05                   
CODE_02B745:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02B748:        DA            PHX                       
CODE_02B749:        A2 04         LDX.B #$04                
CODE_02B74B:        86 06         STX $06                   
CODE_02B74D:        A5 14         LDA RAM_FrameCounterB     
CODE_02B74F:        4A            LSR                       
CODE_02B750:        4A            LSR                       
CODE_02B751:        4A            LSR                       
CODE_02B752:        18            CLC                       
CODE_02B753:        65 06         ADC $06                   
CODE_02B755:        29 03         AND.B #$03                
CODE_02B757:        AA            TAX                       
CODE_02B758:        A5 07         LDA $07                   
CODE_02B75A:        C9 01         CMP.B #$01                
CODE_02B75C:        D0 02         BNE CODE_02B760           
CODE_02B75E:        A2 00         LDX.B #$00                
CODE_02B760:        A5 00         LDA $00                   
CODE_02B762:        18            CLC                       
CODE_02B763:        7D 5F B6      ADC.W PokeyTileDispX,X    
CODE_02B766:        99 00 03      STA.W OAM_DispX,Y         
CODE_02B769:        A6 06         LDX $06                   
CODE_02B76B:        A5 01         LDA $01                   
CODE_02B76D:        46 02         LSR $02                   
CODE_02B76F:        90 10         BCC CODE_02B781           
CODE_02B771:        46 04         LSR $04                   
CODE_02B773:        B0 06         BCS CODE_02B77B           
CODE_02B775:        48            PHA                       
CODE_02B776:        A5 03         LDA $03                   
CODE_02B778:        85 05         STA $05                   
CODE_02B77A:        68            PLA                       
CODE_02B77B:        38            SEC                       
CODE_02B77C:        E5 05         SBC $05                   
CODE_02B77E:        99 01 03      STA.W OAM_DispY,Y         
CODE_02B781:        A5 01         LDA $01                   
CODE_02B783:        38            SEC                       
CODE_02B784:        E9 10         SBC.B #$10                
CODE_02B786:        85 01         STA $01                   
CODE_02B788:        A5 02         LDA $02                   
CODE_02B78A:        4A            LSR                       
CODE_02B78B:        A9 E8         LDA.B #$E8                
CODE_02B78D:        B0 02         BCS CODE_02B791           
CODE_02B78F:        A9 8A         LDA.B #$8A                
CODE_02B791:        99 02 03      STA.W OAM_Tile,Y          
CODE_02B794:        A9 05         LDA.B #$05                
CODE_02B796:        05 64         ORA $64                   
CODE_02B798:        99 03 03      STA.W OAM_Prop,Y          
CODE_02B79B:        C8            INY                       
CODE_02B79C:        C8            INY                       
CODE_02B79D:        C8            INY                       
CODE_02B79E:        C8            INY                       
CODE_02B79F:        CA            DEX                       
CODE_02B7A0:        10 A9         BPL CODE_02B74B           
CODE_02B7A2:        FA            PLX                       
CODE_02B7A3:        A9 04         LDA.B #$04                
CODE_02B7A5:        A0 02         LDY.B #$02                
CODE_02B7A7:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return02B7AB:       60            RTS                       ; Return 

CODE_02B7AC:        A0 09         LDY.B #$09                
CODE_02B7AE:        98            TYA                       
CODE_02B7AF:        45 13         EOR RAM_FrameCounter      
CODE_02B7B1:        4A            LSR                       
CODE_02B7B2:        B0 1E         BCS CODE_02B7D2           
CODE_02B7B4:        B9 C8 14      LDA.W $14C8,Y             
CODE_02B7B7:        C9 0A         CMP.B #$0A                
CODE_02B7B9:        D0 17         BNE CODE_02B7D2           
CODE_02B7BB:        8B            PHB                       
CODE_02B7BC:        A9 03         LDA.B #$03                
CODE_02B7BE:        48            PHA                       
CODE_02B7BF:        AB            PLB                       
CODE_02B7C0:        DA            PHX                       
CODE_02B7C1:        BB            TYX                       
CODE_02B7C2:        22 E5 B6 03   JSL.L GetSpriteClippingB  
CODE_02B7C6:        FA            PLX                       
CODE_02B7C7:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_02B7CB:        22 2B B7 03   JSL.L CheckForContact     
CODE_02B7CF:        AB            PLB                       
CODE_02B7D0:        B0 04         BCS CODE_02B7D6           
CODE_02B7D2:        88            DEY                       
CODE_02B7D3:        10 D9         BPL CODE_02B7AE           
Return02B7D5:       60            RTS                       ; Return 

CODE_02B7D6:        BD 58 15      LDA.W $1558,X             
CODE_02B7D9:        D0 FA         BNE Return02B7D5          
CODE_02B7DB:        B9 D8 00      LDA.W RAM_SpriteYLo,Y     
CODE_02B7DE:        38            SEC                       
CODE_02B7DF:        F5 D8         SBC RAM_SpriteYLo,X       
CODE_02B7E1:        5A            PHY                       
CODE_02B7E2:        8C 95 16      STY.W $1695               
CODE_02B7E5:        20 ED B7      JSR.W RemovePokeySgmntRt  
CODE_02B7E8:        7A            PLY                       
CODE_02B7E9:        20 2E B8      JSR.W CODE_02B82E         
Return02B7EC:       60            RTS                       ; Return 

RemovePokeySgmntRt: A0 00         LDY.B #$00                
CODE_02B7EF:        C9 09         CMP.B #$09                
CODE_02B7F1:        30 10         BMI CODE_02B803           
CODE_02B7F3:        C8            INY                       
CODE_02B7F4:        C9 19         CMP.B #$19                
CODE_02B7F6:        30 0B         BMI CODE_02B803           
CODE_02B7F8:        C8            INY                       
CODE_02B7F9:        C9 29         CMP.B #$29                
CODE_02B7FB:        30 06         BMI CODE_02B803           
CODE_02B7FD:        C8            INY                       
CODE_02B7FE:        C9 39         CMP.B #$39                
CODE_02B800:        30 01         BMI CODE_02B803           
CODE_02B802:        C8            INY                       
CODE_02B803:        B5 C2         LDA RAM_SpriteState,X     ; \ Take away a segment by unsetting a bit 
CODE_02B805:        39 24 B8      AND.W PokeyUnsetBit,Y     ;  | 
CODE_02B808:        95 C2         STA RAM_SpriteState,X     ; / 
CODE_02B80A:        9D 1C 15      STA.W $151C,X             
CODE_02B80D:        B9 29 B8      LDA.W DATA_02B829,Y       
CODE_02B810:        85 0D         STA $0D                   
CODE_02B812:        A9 0C         LDA.B #$0C                
CODE_02B814:        9D 40 15      STA.W $1540,X             
CODE_02B817:        0A            ASL                       
CODE_02B818:        9D 58 15      STA.W $1558,X             
Return02B81B:       60            RTS                       ; Return 

RemovePokeySegment: 8B            PHB                       ; Wrapper 
CODE_02B81D:        4B            PHK                       
CODE_02B81E:        AB            PLB                       
CODE_02B81F:        20 ED B7      JSR.W RemovePokeySgmntRt  
CODE_02B822:        AB            PLB                       
Return02B823:       6B            RTL                       ; Return 


PokeyUnsetBit:                    .db $EF,$F7,$FB,$FD,$FE

DATA_02B829:                      .db $E0,$F0,$F8,$FC,$FE

CODE_02B82E:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_02B832:        30 4D         BMI Return02B881          ; / 
CODE_02B834:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_02B836:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02B839:        A9 70         LDA.B #$70                
CODE_02B83B:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_02B83E:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02B840:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_02B843:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02B846:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_02B849:        DA            PHX                       
CODE_02B84A:        BB            TYX                       
CODE_02B84B:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02B84F:        AE 95 16      LDX.W $1695               
CODE_02B852:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02B854:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_02B857:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02B85A:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_02B85D:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02B85F:        85 00         STA $00                   
CODE_02B861:        0A            ASL                       
CODE_02B862:        66 00         ROR $00                   
CODE_02B864:        A5 00         LDA $00                   
CODE_02B866:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_02B869:        A9 E0         LDA.B #$E0                
CODE_02B86B:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_02B86E:        FA            PLX                       
CODE_02B86F:        B5 C2         LDA RAM_SpriteState,X     
CODE_02B871:        25 0D         AND $0D                   
CODE_02B873:        99 C2 00      STA.W RAM_SpriteState,Y   
CODE_02B876:        A9 01         LDA.B #$01                
CODE_02B878:        99 34 15      STA.W $1534,Y             
CODE_02B87B:        A9 01         LDA.B #$01                
CODE_02B87D:        22 E1 AC 02   JSL.L CODE_02ACE1         
Return02B881:       60            RTS                       ; Return 

TorpedoTedMain:     8B            PHB                       
CODE_02B883:        4B            PHK                       
CODE_02B884:        AB            PLB                       
CODE_02B885:        20 8A B8      JSR.W CODE_02B88A         
CODE_02B888:        AB            PLB                       
Return02B889:       6B            RTL                       ; Return 

CODE_02B88A:        A5 64         LDA $64                   ; \ Save $64 
CODE_02B88C:        48            PHA                       ; / 
CODE_02B88D:        BD 40 15      LDA.W $1540,X             ; \ If being launched... 
CODE_02B890:        F0 04         BEQ CODE_02B896           ;  | ...set $64 = #$10... 
CODE_02B892:        A9 10         LDA.B #$10                ;  | ...so it will be drawn behind objects 
CODE_02B894:        85 64         STA $64                   ; / 
CODE_02B896:        20 F7 B8      JSR.W TorpedoGfxRt        ; Draw sprite 
CODE_02B899:        68            PLA                       ; \ Restore $64 
CODE_02B89A:        85 64         STA $64                   ; / 
CODE_02B89C:        A5 9D         LDA RAM_SpritesLocked     ; \ Return if sprites locked 
CODE_02B89E:        D0 17         BNE Return02B8B7          ; / 
CODE_02B8A0:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02B8A3:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_02B8A7:        BD 40 15      LDA.W $1540,X             ; \ Branch if not being launched 
CODE_02B8AA:        F0 10         BEQ CODE_02B8BC           ; / 
CODE_02B8AC:        A9 08         LDA.B #$08                ; \ Sprite Y speed = #$08 
CODE_02B8AE:        95 AA         STA RAM_SpriteSpeedY,X    ; / 
CODE_02B8B0:        20 94 D2      JSR.W UpdateYPosNoGrvty   ; Apply speed to position 
CODE_02B8B3:        A9 10         LDA.B #$10                ; \ Sprite Y speed = #$10 
CODE_02B8B5:        95 AA         STA RAM_SpriteSpeedY,X    ; / 
Return02B8B7:       60            RTS                       ; Return 


TorpedoMaxSpeed:                  .db $20,$F0

TorpedoAccel:                     .db $01,$FF

CODE_02B8BC:        A5 13         LDA RAM_FrameCounter      ; \ Only increase X speed every 4 frames 
CODE_02B8BE:        29 03         AND.B #$03                ;  | 
CODE_02B8C0:        D0 10         BNE CODE_02B8D2           ; / 
CODE_02B8C2:        BC 7C 15      LDY.W RAM_SpriteDir,X     ; \ If not at maximum, increase X speed 
CODE_02B8C5:        B5 B6         LDA RAM_SpriteSpeedX,X    ;  | 
CODE_02B8C7:        D9 B8 B8      CMP.W TorpedoMaxSpeed,Y   ;  | 
CODE_02B8CA:        F0 06         BEQ CODE_02B8D2           ;  | 
CODE_02B8CC:        18            CLC                       ;  | 
CODE_02B8CD:        79 BA B8      ADC.W TorpedoAccel,Y      ;  | 
CODE_02B8D0:        95 B6         STA RAM_SpriteSpeedX,X    ; / 
CODE_02B8D2:        20 88 D2      JSR.W UpdateXPosNoGrvty   ; \ Apply speed to position 
CODE_02B8D5:        20 94 D2      JSR.W UpdateYPosNoGrvty   ; / 
CODE_02B8D8:        B5 AA         LDA RAM_SpriteSpeedY,X    ; \ If sprite has Y speed... 
CODE_02B8DA:        F0 08         BEQ CODE_02B8E4           ;  | 
CODE_02B8DC:        A5 13         LDA RAM_FrameCounter      ;  | ...Decrease Y speed every other frame 
CODE_02B8DE:        29 01         AND.B #$01                ;  | 
CODE_02B8E0:        D0 02         BNE CODE_02B8E4           ;  | 
CODE_02B8E2:        D6 AA         DEC RAM_SpriteSpeedY,X    ; / 
CODE_02B8E4:        8A            TXA                       ; \ Run $02B952 every 8 frames 
CODE_02B8E5:        18            CLC                       ;  | 
CODE_02B8E6:        65 14         ADC RAM_FrameCounterB     ;  | 
CODE_02B8E8:        29 07         AND.B #$07                ;  | 
CODE_02B8EA:        D0 03         BNE Return02B8EF          ;  | 
CODE_02B8EC:        20 52 B9      JSR.W CODE_02B952         ; / 
Return02B8EF:       60            RTS                       ; Return 


DATA_02B8F0:                      .db $10

DATA_02B8F1:                      .db $00,$10,$80,$82

DATA_02B8F5:                      .db $40,$00

TorpedoGfxRt:       20 78 D3      JSR.W GetDrawInfo2        
CODE_02B8FA:        A5 01         LDA $01                   
CODE_02B8FC:        99 01 03      STA.W OAM_DispY,Y         
CODE_02B8FF:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_02B902:        DA            PHX                       
CODE_02B903:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_02B906:        05 64         ORA $64                   
CODE_02B908:        85 02         STA $02                   
CODE_02B90A:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02B90D:        AA            TAX                       
CODE_02B90E:        A5 00         LDA $00                   
CODE_02B910:        18            CLC                       
CODE_02B911:        7D F0 B8      ADC.W DATA_02B8F0,X       
CODE_02B914:        99 00 03      STA.W OAM_DispX,Y         
CODE_02B917:        A5 00         LDA $00                   
CODE_02B919:        18            CLC                       
CODE_02B91A:        7D F1 B8      ADC.W DATA_02B8F1,X       
CODE_02B91D:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_02B920:        BD F5 B8      LDA.W DATA_02B8F5,X       
CODE_02B923:        05 02         ORA $02                   
CODE_02B925:        99 03 03      STA.W OAM_Prop,Y          
CODE_02B928:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02B92B:        FA            PLX                       
CODE_02B92C:        A9 80         LDA.B #$80                
CODE_02B92E:        99 02 03      STA.W OAM_Tile,Y          
CODE_02B931:        BD 40 15      LDA.W $1540,X             
CODE_02B934:        C9 01         CMP.B #$01                
CODE_02B936:        A9 82         LDA.B #$82                
CODE_02B938:        B0 0A         BCS CODE_02B944           
CODE_02B93A:        A5 14         LDA RAM_FrameCounterB     
CODE_02B93C:        4A            LSR                       
CODE_02B93D:        4A            LSR                       
CODE_02B93E:        A9 A0         LDA.B #$A0                
CODE_02B940:        90 02         BCC CODE_02B944           
CODE_02B942:        A9 82         LDA.B #$82                
CODE_02B944:        99 06 03      STA.W OAM_Tile2,Y         
CODE_02B947:        A9 01         LDA.B #$01                
CODE_02B949:        A0 02         LDY.B #$02                
CODE_02B94B:        4C A7 B7      JMP.W CODE_02B7A7         


DATA_02B94E:                      .db $F4,$1C

DATA_02B950:                      .db $FF,$00

CODE_02B952:        A0 03         LDY.B #$03                
CODE_02B954:        B9 C0 17      LDA.W $17C0,Y             
CODE_02B957:        F0 10         BEQ CODE_02B969           
CODE_02B959:        88            DEY                       
CODE_02B95A:        10 F8         BPL CODE_02B954           
CODE_02B95C:        CE E9 18      DEC.W $18E9               
CODE_02B95F:        10 05         BPL CODE_02B966           
CODE_02B961:        A9 03         LDA.B #$03                
CODE_02B963:        8D E9 18      STA.W $18E9               
CODE_02B966:        AC E9 18      LDY.W $18E9               
CODE_02B969:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02B96B:        85 00         STA $00                   
CODE_02B96D:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02B970:        85 01         STA $01                   
CODE_02B972:        DA            PHX                       
CODE_02B973:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02B976:        AA            TAX                       
CODE_02B977:        A5 00         LDA $00                   
CODE_02B979:        18            CLC                       
CODE_02B97A:        7D 4E B9      ADC.W DATA_02B94E,X       
CODE_02B97D:        85 02         STA $02                   
CODE_02B97F:        A5 01         LDA $01                   
CODE_02B981:        7D 50 B9      ADC.W DATA_02B950,X       
CODE_02B984:        48            PHA                       
CODE_02B985:        A5 02         LDA $02                   
CODE_02B987:        C5 1A         CMP RAM_ScreenBndryXLo    
CODE_02B989:        68            PLA                       
CODE_02B98A:        FA            PLX                       
CODE_02B98B:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_02B98D:        D0 14         BNE Return02B9A3          
CODE_02B98F:        A9 01         LDA.B #$01                
CODE_02B991:        99 C0 17      STA.W $17C0,Y             
CODE_02B994:        A5 02         LDA $02                   
CODE_02B996:        99 C8 17      STA.W $17C8,Y             
CODE_02B999:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02B99B:        99 C4 17      STA.W $17C4,Y             
CODE_02B99E:        A9 0F         LDA.B #$0F                
CODE_02B9A0:        99 CC 17      STA.W $17CC,Y             
Return02B9A3:       60            RTS                       ; Return 

GenTileFromSpr0:    85 9C         STA RAM_BlockBlock        ; $9C = tile to generate 
ADDR_02B9A6:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $9A = Sprite X position 
ADDR_02B9A8:        85 9A         STA RAM_BlockYLo          ;  | for block creation 
ADDR_02B9AA:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
ADDR_02B9AD:        85 9B         STA RAM_BlockYHi          ; / 
ADDR_02B9AF:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $98 = Sprite Y position 
ADDR_02B9B1:        85 98         STA RAM_BlockXLo          ;  | for block creation 
ADDR_02B9B3:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
ADDR_02B9B6:        85 99         STA RAM_BlockXHi          ; / 
ADDR_02B9B8:        22 B0 BE 00   JSL.L GenerateTile        ; Generate the tile 
Return02B9BC:       6B            RTL                       ; Return 

CODE_02B9BD:        A9 02         LDA.B #$02                
CODE_02B9BF:        8D DD 18      STA.W $18DD               
CODE_02B9C2:        A0 09         LDY.B #$09                
CODE_02B9C4:        B9 C8 14      LDA.W $14C8,Y             
CODE_02B9C7:        C9 08         CMP.B #$08                
CODE_02B9C9:        90 0A         BCC CODE_02B9D5           
CODE_02B9CB:        B9 0F 19      LDA.W RAM_Tweaker190F,Y   
CODE_02B9CE:        29 40         AND.B #$40                
CODE_02B9D0:        D0 03         BNE CODE_02B9D5           
CODE_02B9D2:        20 D9 B9      JSR.W CODE_02B9D9         
CODE_02B9D5:        88            DEY                       
CODE_02B9D6:        10 EC         BPL CODE_02B9C4           
Return02B9D8:       6B            RTL                       ; Return 

CODE_02B9D9:        A9 21         LDA.B #$21                
CODE_02B9DB:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_02B9DE:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02B9E0:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02B9E3:        DA            PHX                       
CODE_02B9E4:        BB            TYX                       
CODE_02B9E5:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02B9E9:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_02B9EC:        29 F1         AND.B #$F1                
CODE_02B9EE:        09 02         ORA.B #$02                
CODE_02B9F0:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_02B9F3:        A9 D8         LDA.B #$D8                
CODE_02B9F5:        9D AA 00      STA.W RAM_SpriteSpeedY,X  
CODE_02B9F8:        FA            PLX                       
Return02B9F9:       60            RTS                       ; Return 

CODE_02B9FA:        64 0F         STZ $0F                   
CODE_02B9FC:        80 4A         BRA CODE_02BA48           

ADDR_02B9FE:        A5 01         LDA $01                   ; \ Unreachable 
ADDR_02BA00:        29 F0         AND.B #$F0                ;  | Very similar to code below 
ADDR_02BA02:        85 04         STA $04                   
ADDR_02BA04:        A5 09         LDA $09                   
ADDR_02BA06:        C5 5D         CMP RAM_ScreensInLvl      
ADDR_02BA08:        B0 3D         BCS Return02BA47          
ADDR_02BA0A:        85 05         STA $05                   
ADDR_02BA0C:        A5 00         LDA $00                   
ADDR_02BA0E:        85 07         STA $07                   
ADDR_02BA10:        A5 08         LDA $08                   
ADDR_02BA12:        C9 02         CMP.B #$02                
ADDR_02BA14:        B0 31         BCS Return02BA47          
ADDR_02BA16:        85 0A         STA $0A                   
ADDR_02BA18:        A5 07         LDA $07                   
ADDR_02BA1A:        4A            LSR                       
ADDR_02BA1B:        4A            LSR                       
ADDR_02BA1C:        4A            LSR                       
ADDR_02BA1D:        4A            LSR                       
ADDR_02BA1E:        05 04         ORA $04                   
ADDR_02BA20:        85 04         STA $04                   
ADDR_02BA22:        A6 05         LDX $05                   
ADDR_02BA24:        BF 80 BA 00   LDA.L DATA_00BA80,X       
ADDR_02BA28:        A4 0F         LDY $0F                   
ADDR_02BA2A:        F0 04         BEQ ADDR_02BA30           
ADDR_02BA2C:        BF 8E BA 00   LDA.L DATA_00BA8E,X       
ADDR_02BA30:        18            CLC                       
ADDR_02BA31:        65 04         ADC $04                   
ADDR_02BA33:        85 05         STA $05                   
ADDR_02BA35:        BF BC BA 00   LDA.L DATA_00BABC,X       
ADDR_02BA39:        A4 0F         LDY $0F                   
ADDR_02BA3B:        F0 04         BEQ ADDR_02BA41           
ADDR_02BA3D:        BF CA BA 00   LDA.L DATA_00BACA,X       
ADDR_02BA41:        65 0A         ADC $0A                   
ADDR_02BA43:        85 06         STA $06                   
ADDR_02BA45:        80 4B         BRA CODE_02BA92           

Return02BA47:       6B            RTL                       ; Return 

CODE_02BA48:        A5 01         LDA $01                   
CODE_02BA4A:        29 F0         AND.B #$F0                
CODE_02BA4C:        85 04         STA $04                   
CODE_02BA4E:        A5 09         LDA $09                   
CODE_02BA50:        C9 02         CMP.B #$02                
CODE_02BA52:        B0 F3         BCS Return02BA47          
CODE_02BA54:        85 0D         STA $0D                   
CODE_02BA56:        8D B3 18      STA.W $18B3               
CODE_02BA59:        A5 00         LDA $00                   
CODE_02BA5B:        85 06         STA $06                   
CODE_02BA5D:        A5 08         LDA $08                   
CODE_02BA5F:        C5 5D         CMP RAM_ScreensInLvl      
CODE_02BA61:        B0 E4         BCS Return02BA47          
CODE_02BA63:        85 07         STA $07                   
CODE_02BA65:        A5 06         LDA $06                   
CODE_02BA67:        4A            LSR                       
CODE_02BA68:        4A            LSR                       
CODE_02BA69:        4A            LSR                       
CODE_02BA6A:        4A            LSR                       
CODE_02BA6B:        05 04         ORA $04                   
CODE_02BA6D:        85 04         STA $04                   
CODE_02BA6F:        A6 07         LDX $07                   
CODE_02BA71:        BF 60 BA 00   LDA.L DATA_00BA60,X       
CODE_02BA75:        A4 0F         LDY $0F                   
CODE_02BA77:        F0 04         BEQ CODE_02BA7D           
ADDR_02BA79:        BF 70 BA 00   LDA.L DATA_00BA70,X       
CODE_02BA7D:        18            CLC                       
CODE_02BA7E:        65 04         ADC $04                   
CODE_02BA80:        85 05         STA $05                   
CODE_02BA82:        BF 9C BA 00   LDA.L DATA_00BA9C,X       
CODE_02BA86:        A4 0F         LDY $0F                   
CODE_02BA88:        F0 04         BEQ CODE_02BA8E           
ADDR_02BA8A:        BF AC BA 00   LDA.L DATA_00BAAC,X       
CODE_02BA8E:        65 0D         ADC $0D                   
CODE_02BA90:        85 06         STA $06                   
CODE_02BA92:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02BA95:        A9 7E         LDA.B #$7E                
CODE_02BA97:        85 07         STA $07                   
CODE_02BA99:        A7 05         LDA [$05]                 
CODE_02BA9B:        8D 93 16      STA.W $1693               
CODE_02BA9E:        E6 07         INC $07                   
CODE_02BAA0:        A7 05         LDA [$05]                 
CODE_02BAA2:        D0 1B         BNE Return02BABF          
CODE_02BAA4:        AD 93 16      LDA.W $1693               
CODE_02BAA7:        C9 45         CMP.B #$45                ;If it is <= the Red Berry map16 tile
CODE_02BAA9:        90 14         BCC Return02BABF          ;Return
CODE_02BAAB:        C9 48         CMP.B #$48                ;If it is => Map16 always turning block
CODE_02BAAD:        B0 10         BCS Return02BABF          ;Return
CODE_02BAAF:        38            SEC                       
CODE_02BAB0:        E9 44         SBC.B #$44                
CODE_02BAB2:        8D D6 18      STA.W $18D6               ;Berry Type
CODE_02BAB5:        A0 0B         LDY.B #$0B                
CODE_02BAB7:        B9 C8 14      LDA.W $14C8,Y             ; \ Find a free sprite slot and branch 
CODE_02BABA:        F0 04         BEQ CODE_02BAC0           ;  | 
ADDR_02BABC:        88            DEY                       ;  | 
ADDR_02BABD:        10 F8         BPL CODE_02BAB7           ; / 
Return02BABF:       6B            RTL                       ; Return if no slots found 

CODE_02BAC0:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02BAC2:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02BAC5:        A9 74         LDA.B #$74                ; \ Sprite number = Mushroom 
CODE_02BAC7:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
CODE_02BACA:        A5 00         LDA $00                   ; \ Sprite and block X position = $00,$08 
CODE_02BACC:        99 E4 00      STA.W RAM_SpriteXLo,Y     ;  | 
CODE_02BACF:        85 9A         STA RAM_BlockYLo          ;  | 
CODE_02BAD1:        A5 08         LDA $08                   ;  | 
CODE_02BAD3:        99 E0 14      STA.W RAM_SpriteXHi,Y     ;  | 
CODE_02BAD6:        85 9B         STA RAM_BlockYHi          ; / 
CODE_02BAD8:        A5 01         LDA $01                   ; \ Sprite and block Y position = $01,$09 
CODE_02BADA:        99 D8 00      STA.W RAM_SpriteYLo,Y     ;  | 
CODE_02BADD:        85 98         STA RAM_BlockXLo          ;  | 
CODE_02BADF:        A5 09         LDA $09                   ;  | 
CODE_02BAE1:        99 D4 14      STA.W RAM_SpriteYHi,Y     ;  | 
CODE_02BAE4:        85 99         STA RAM_BlockXHi          ; / 
CODE_02BAE6:        DA            PHX                       
CODE_02BAE7:        BB            TYX                       
CODE_02BAE8:        22 D2 F7 07   JSL.L InitSpriteTables    ; Reset sprite tables 
CODE_02BAEC:        FE 0E 16      INC.W $160E,X             ; ? 
CODE_02BAEF:        BD 62 16      LDA.W RAM_Tweaker1662,X   ; \ Change the index into sprite clipping table 
CODE_02BAF2:        29 F0         AND.B #$F0                ;  | to "resize" the sprite 
CODE_02BAF4:        09 0C         ORA.B #$0C                ;  | 
CODE_02BAF6:        9D 62 16      STA.W RAM_Tweaker1662,X   ; / 
CODE_02BAF9:        BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ No longer gives powerup when eaten 
CODE_02BAFC:        29 BF         AND.B #$BF                ;  | 
CODE_02BAFE:        9D 7A 16      STA.W RAM_Tweaker167A,X   ; / 
CODE_02BB01:        FA            PLX                       
CODE_02BB02:        A9 04         LDA.B #$04                ; \ Block to generate = Tree behind berry 
CODE_02BB04:        85 9C         STA RAM_BlockBlock        ; / 
CODE_02BB06:        22 B0 BE 00   JSL.L GenerateTile        ; Generate the tile 
Return02BB0A:       6B            RTL                       ; Return 


DATA_02BB0B:                      .db $02,$FA,$06,$06

DATA_02BB0F:                      .db $00,$FF,$00,$00

DATA_02BB13:                      .db $10,$08,$10,$08

YoshiWingsTiles:                  .db $5D,$C6,$5D,$C6

YoshiWingsGfxProp:                .db $46,$46,$06,$06

YoshiWingsSize:                   .db $00,$02,$00,$02

CODE_02BB23:        85 02         STA $02                   
CODE_02BB25:        20 C9 D0      JSR.W IsSprOffScreenBnk2  
CODE_02BB28:        D0 5D         BNE Return02BB87          
CODE_02BB2A:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02BB2C:        85 00         STA $00                   
CODE_02BB2E:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02BB31:        85 04         STA $04                   
CODE_02BB33:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02BB35:        85 01         STA $01                   
CODE_02BB37:        A0 F8         LDY.B #$F8                
CODE_02BB39:        DA            PHX                       
CODE_02BB3A:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02BB3D:        0A            ASL                       
CODE_02BB3E:        65 02         ADC $02                   
CODE_02BB40:        AA            TAX                       
CODE_02BB41:        A5 00         LDA $00                   
CODE_02BB43:        18            CLC                       
CODE_02BB44:        7F 0B BB 02   ADC.L DATA_02BB0B,X       
CODE_02BB48:        85 00         STA $00                   
CODE_02BB4A:        A5 04         LDA $04                   
CODE_02BB4C:        7F 0F BB 02   ADC.L DATA_02BB0F,X       
CODE_02BB50:        48            PHA                       
CODE_02BB51:        A5 00         LDA $00                   
CODE_02BB53:        38            SEC                       
CODE_02BB54:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02BB56:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_02BB59:        68            PLA                       
CODE_02BB5A:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_02BB5C:        D0 28         BNE CODE_02BB86           
CODE_02BB5E:        A5 01         LDA $01                   
CODE_02BB60:        38            SEC                       
CODE_02BB61:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02BB63:        18            CLC                       
CODE_02BB64:        7F 13 BB 02   ADC.L DATA_02BB13,X       
CODE_02BB68:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_02BB6B:        BF 17 BB 02   LDA.L YoshiWingsTiles,X   
CODE_02BB6F:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02BB72:        A5 64         LDA $64                   
CODE_02BB74:        1F 1B BB 02   ORA.L YoshiWingsGfxProp,X 
CODE_02BB78:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02BB7B:        98            TYA                       
CODE_02BB7C:        4A            LSR                       
CODE_02BB7D:        4A            LSR                       
CODE_02BB7E:        A8            TAY                       
CODE_02BB7F:        BF 1F BB 02   LDA.L YoshiWingsSize,X    
CODE_02BB83:        99 20 04      STA.W $0420,Y             
CODE_02BB86:        FA            PLX                       
Return02BB87:       6B            RTL                       ; Return 


DATA_02BB88:                      .db $FF,$01,$FF,$01,$00,$00

DATA_02BB8E:                      .db $E8,$18,$F8,$08,$00,$00

DolphinMain:        20 14 BC      JSR.W CODE_02BC14         
CODE_02BB97:        A5 9D         LDA RAM_SpritesLocked     
CODE_02BB99:        D0 64         BNE Return02BBFF          
CODE_02BB9B:        20 1F D0      JSR.W SubOffscreen1Bnk2   
CODE_02BB9E:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02BBA1:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02BBA4:        9D 28 15      STA.W $1528,X             
CODE_02BBA7:        A5 14         LDA RAM_FrameCounterB     
CODE_02BBA9:        29 00         AND.B #$00                
CODE_02BBAB:        D0 0A         BNE CODE_02BBB7           
CODE_02BBAD:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02BBAF:        30 04         BMI CODE_02BBB5           
CODE_02BBB1:        C9 3F         CMP.B #$3F                
CODE_02BBB3:        B0 02         BCS CODE_02BBB7           
CODE_02BBB5:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_02BBB7:        8A            TXA                       
CODE_02BBB8:        45 13         EOR RAM_FrameCounter      
CODE_02BBBA:        4A            LSR                       
CODE_02BBBB:        90 04         BCC CODE_02BBC1           
CODE_02BBBD:        22 38 91 01   JSL.L CODE_019138         
CODE_02BBC1:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02BBC3:        30 36         BMI CODE_02BBFB           
CODE_02BBC5:        BD 4A 16      LDA.W $164A,X             
CODE_02BBC8:        F0 31         BEQ CODE_02BBFB           
CODE_02BBCA:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02BBCC:        F0 09         BEQ CODE_02BBD7           
CODE_02BBCE:        38            SEC                       
CODE_02BBCF:        E9 08         SBC.B #$08                
CODE_02BBD1:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02BBD3:        10 02         BPL CODE_02BBD7           
CODE_02BBD5:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_02BBD7:        BD 1C 15      LDA.W $151C,X             
CODE_02BBDA:        D0 1B         BNE CODE_02BBF7           
CODE_02BBDC:        B5 C2         LDA RAM_SpriteState,X     
CODE_02BBDE:        4A            LSR                       
CODE_02BBDF:        08            PHP                       
CODE_02BBE0:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02BBE2:        38            SEC                       
CODE_02BBE3:        E9 41         SBC.B #$41                
CODE_02BBE5:        28            PLP                       
CODE_02BBE6:        2A            ROL                       
CODE_02BBE7:        A8            TAY                       
CODE_02BBE8:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02BBEA:        18            CLC                       
CODE_02BBEB:        79 88 BB      ADC.W DATA_02BB88,Y       
CODE_02BBEE:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02BBF0:        D9 8E BB      CMP.W DATA_02BB8E,Y       
CODE_02BBF3:        D0 06         BNE CODE_02BBFB           
CODE_02BBF5:        F6 C2         INC RAM_SpriteState,X     
CODE_02BBF7:        A9 C0         LDA.B #$C0                
CODE_02BBF9:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02BBFB:        22 4F B4 01   JSL.L InvisBlkMainRt      
Return02BBFF:       6B            RTL                       ; Return 

CODE_02BC00:        A5 14         LDA RAM_FrameCounterB     
CODE_02BC02:        29 04         AND.B #$04                
CODE_02BC04:        4A            LSR                       
CODE_02BC05:        4A            LSR                       
CODE_02BC06:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02BC09:        22 5F 9D 01   JSL.L GenericSprGfxRt1    
Return02BC0D:       60            RTS                       ; Return 


DolphinTiles1:                    .db $E2,$88

DolphinTiles2:                    .db $E7,$A8

DolphinTiles3:                    .db $E8,$A9

CODE_02BC14:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02BC16:        C9 43         CMP.B #$43                
CODE_02BC18:        D0 03         BNE CODE_02BC1D           
CODE_02BC1A:        4C 00 BC      JMP.W CODE_02BC00         

CODE_02BC1D:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02BC20:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02BC22:        85 02         STA $02                   
CODE_02BC24:        A5 00         LDA $00                   
CODE_02BC26:        06 02         ASL $02                   
CODE_02BC28:        08            PHP                       
CODE_02BC29:        90 11         BCC CODE_02BC3C           
CODE_02BC2B:        99 00 03      STA.W OAM_DispX,Y         
CODE_02BC2E:        18            CLC                       
CODE_02BC2F:        69 10         ADC.B #$10                
CODE_02BC31:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_02BC34:        18            CLC                       
CODE_02BC35:        69 08         ADC.B #$08                
CODE_02BC37:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_02BC3A:        80 12         BRA CODE_02BC4E           

CODE_02BC3C:        18            CLC                       
CODE_02BC3D:        69 18         ADC.B #$18                
CODE_02BC3F:        99 00 03      STA.W OAM_DispX,Y         
CODE_02BC42:        38            SEC                       
CODE_02BC43:        E9 10         SBC.B #$10                
CODE_02BC45:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_02BC48:        38            SEC                       
CODE_02BC49:        E9 08         SBC.B #$08                
CODE_02BC4B:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_02BC4E:        A5 01         LDA $01                   
CODE_02BC50:        99 01 03      STA.W OAM_DispY,Y         
CODE_02BC53:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_02BC56:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_02BC59:        DA            PHX                       
CODE_02BC5A:        A5 14         LDA RAM_FrameCounterB     
CODE_02BC5C:        29 08         AND.B #$08                
CODE_02BC5E:        4A            LSR                       
CODE_02BC5F:        4A            LSR                       
CODE_02BC60:        4A            LSR                       
CODE_02BC61:        AA            TAX                       
CODE_02BC62:        BD 0E BC      LDA.W DolphinTiles1,X     
CODE_02BC65:        99 02 03      STA.W OAM_Tile,Y          
CODE_02BC68:        BD 10 BC      LDA.W DolphinTiles2,X     
CODE_02BC6B:        99 06 03      STA.W OAM_Tile2,Y         
CODE_02BC6E:        BD 12 BC      LDA.W DolphinTiles3,X     
CODE_02BC71:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_02BC74:        FA            PLX                       
CODE_02BC75:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_02BC78:        05 64         ORA $64                   
CODE_02BC7A:        28            PLP                       
CODE_02BC7B:        B0 02         BCS CODE_02BC7F           
CODE_02BC7D:        09 40         ORA.B #$40                
CODE_02BC7F:        99 03 03      STA.W OAM_Prop,Y          
CODE_02BC82:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02BC85:        99 0B 03      STA.W OAM_Tile3Prop,Y     
CODE_02BC88:        A9 02         LDA.B #$02                
CODE_02BC8A:        A0 02         LDY.B #$02                
CODE_02BC8C:        4C A7 B7      JMP.W CODE_02B7A7         


DATA_02BC8F:                      .db $08,$00,$F8,$00,$F8,$00,$08,$00
DATA_02BC97:                      .db $00,$08,$00,$F8,$00,$08,$00,$F8
DATA_02BC9F:                      .db $01,$FF,$FF,$01,$FF,$01,$01,$FF
DATA_02BCA7:                      .db $01,$01,$FF,$FF,$01,$01,$FF,$FF
DATA_02BCAF:                      .db $01,$04,$02,$08,$02,$04,$01,$08
DATA_02BCB7:                      .db $00,$02,$00,$02,$00,$02,$00,$02
                                  .db $05,$04,$05,$04,$05,$04,$05,$04
DATA_02BCC7:                      .db $00,$C0,$C0,$00,$40,$80,$80,$40
                                  .db $80,$C0,$40,$00,$C0,$80,$00,$40
DATA_02BCD7:                      .db $00,$01,$02,$01

WallFollowersMain:  22 32 80 01   JSL.L SprSprInteract      
CODE_02BCDF:        22 F9 AC 01   JSL.L GetRand             
CODE_02BCE3:        29 FF         AND.B #$FF                
CODE_02BCE5:        05 9D         ORA RAM_SpritesLocked     
CODE_02BCE7:        D0 05         BNE CODE_02BCEE           
CODE_02BCE9:        A9 0C         LDA.B #$0C                
CODE_02BCEB:        9D 58 15      STA.W $1558,X             
CODE_02BCEE:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if not Spike Top 
CODE_02BCF0:        C9 2E         CMP.B #$2E                ;  | 
CODE_02BCF2:        D0 2F         BNE CODE_02BD23           ; / 
CODE_02BCF4:        B4 C2         LDY RAM_SpriteState,X     
CODE_02BCF6:        BD 64 15      LDA.W $1564,X             
CODE_02BCF9:        F0 09         BEQ CODE_02BD04           
CODE_02BCFB:        98            TYA                       
CODE_02BCFC:        18            CLC                       
CODE_02BCFD:        69 08         ADC.B #$08                
CODE_02BCFF:        A8            TAY                       
CODE_02BD00:        A9 00         LDA.B #$00                
CODE_02BD02:        80 07         BRA CODE_02BD0B           

CODE_02BD04:        A5 14         LDA RAM_FrameCounterB     
CODE_02BD06:        4A            LSR                       
CODE_02BD07:        4A            LSR                       
CODE_02BD08:        4A            LSR                       
CODE_02BD09:        29 01         AND.B #$01                
CODE_02BD0B:        18            CLC                       
CODE_02BD0C:        79 B7 BC      ADC.W DATA_02BCB7,Y       
CODE_02BD0F:        9D 02 16      STA.W $1602,X             
CODE_02BD12:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_02BD15:        29 3F         AND.B #$3F                
CODE_02BD17:        19 C7 BC      ORA.W DATA_02BCC7,Y       
CODE_02BD1A:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_02BD1D:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_02BD21:        80 0C         BRA CODE_02BD2F           

CODE_02BD23:        C9 A5         CMP.B #$A5                
CODE_02BD25:        90 05         BCC CODE_02BD2C           
CODE_02BD27:        20 4E BE      JSR.W CODE_02BE4E         
CODE_02BD2A:        80 03         BRA CODE_02BD2F           

CODE_02BD2C:        20 5C BF      JSR.W CODE_02BF5C         
CODE_02BD2F:        BD C8 14      LDA.W $14C8,X             
CODE_02BD32:        C9 08         CMP.B #$08                
CODE_02BD34:        F0 09         BEQ CODE_02BD3F           
CODE_02BD36:        9E 28 15      STZ.W $1528,X             
CODE_02BD39:        A9 FF         LDA.B #$FF                
CODE_02BD3B:        9D 58 15      STA.W $1558,X             
Return02BD3E:       6B            RTL                       ; Return 

CODE_02BD3F:        A5 9D         LDA RAM_SpritesLocked     
CODE_02BD41:        D0 31         BNE Return02BD74          
CODE_02BD43:        20 17 D0      JSR.W SubOffscreen3Bnk2   
CODE_02BD46:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_02BD4A:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if Spike Top 
CODE_02BD4C:        C9 2E         CMP.B #$2E                ;  | 
CODE_02BD4E:        F0 57         BEQ CODE_02BDA7           ; / 
CODE_02BD50:        C9 3C         CMP.B #$3C                ; \ Branch if Wall-follow Urchin 
CODE_02BD52:        F0 5F         BEQ CODE_02BDB3           ; / 
CODE_02BD54:        C9 A5         CMP.B #$A5                ; \ Branch if Ground-guided Fuzzball/Sparky 
CODE_02BD56:        F0 5B         BEQ CODE_02BDB3           ; / 
CODE_02BD58:        C9 A6         CMP.B #$A6                ; \ Branch if Ground-guided Hothead 
CODE_02BD5A:        F0 57         BEQ CODE_02BDB3           ; / 
CODE_02BD5C:        B5 C2         LDA RAM_SpriteState,X     
CODE_02BD5E:        29 01         AND.B #$01                
CODE_02BD60:        22 DF 86 00   JSL.L ExecutePtr          

UrchinPtrs?:           68 BD      .dw CODE_02BD68           
                       75 BD      .dw CODE_02BD75           

CODE_02BD68:        BD 40 15      LDA.W $1540,X             
CODE_02BD6B:        D0 07         BNE Return02BD74          
CODE_02BD6D:        A9 80         LDA.B #$80                
CODE_02BD6F:        9D 40 15      STA.W $1540,X             
CODE_02BD72:        F6 C2         INC RAM_SpriteState,X     
Return02BD74:       6B            RTL                       ; Return 

CODE_02BD75:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if Wall-detect Urchin 
CODE_02BD77:        C9 3B         CMP.B #$3B                ;  | 
CODE_02BD79:        F0 05         BEQ CODE_02BD80           ; / 
CODE_02BD7B:        BD 40 15      LDA.W $1540,X             
CODE_02BD7E:        F0 11         BEQ CODE_02BD91           
CODE_02BD80:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02BD83:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02BD86:        22 38 91 01   JSL.L CODE_019138         
CODE_02BD8A:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_02BD8D:        29 0F         AND.B #$0F                
CODE_02BD8F:        F0 15         BEQ Return02BDA6          
CODE_02BD91:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02BD93:        49 FF         EOR.B #$FF                
CODE_02BD95:        1A            INC A                     
CODE_02BD96:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02BD98:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02BD9A:        49 FF         EOR.B #$FF                
CODE_02BD9C:        1A            INC A                     
CODE_02BD9D:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02BD9F:        A9 40         LDA.B #$40                
CODE_02BDA1:        9D 40 15      STA.W $1540,X             
CODE_02BDA4:        F6 C2         INC RAM_SpriteState,X     
Return02BDA6:       6B            RTL                       ; Return 

CODE_02BDA7:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02BDA9:        38            SEC                       
CODE_02BDAA:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02BDAC:        C9 E0         CMP.B #$E0                
CODE_02BDAE:        90 03         BCC CODE_02BDB3           
CODE_02BDB0:        9E C8 14      STZ.W $14C8,X             
CODE_02BDB3:        BD 40 15      LDA.W $1540,X             
CODE_02BDB6:        D0 2F         BNE CODE_02BDE7           
CODE_02BDB8:        B4 C2         LDY RAM_SpriteState,X     
CODE_02BDBA:        B9 A7 BC      LDA.W DATA_02BCA7,Y       
CODE_02BDBD:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02BDBF:        B9 9F BC      LDA.W DATA_02BC9F,Y       
CODE_02BDC2:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02BDC4:        22 38 91 01   JSL.L CODE_019138         
CODE_02BDC8:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_02BDCB:        29 0F         AND.B #$0F                
CODE_02BDCD:        D0 18         BNE CODE_02BDE7           
CODE_02BDCF:        A9 08         LDA.B #$08                
CODE_02BDD1:        9D 64 15      STA.W $1564,X             
CODE_02BDD4:        A9 38         LDA.B #$38                
CODE_02BDD6:        B4 9E         LDY RAM_SpriteNum,X       ; \ Branch if Wall-follow Urchin 
CODE_02BDD8:        C0 3C         CPY.B #$3C                ;  | 
CODE_02BDDA:        F0 08         BEQ CODE_02BDE4           ; / 
CODE_02BDDC:        A9 1A         LDA.B #$1A                
CODE_02BDDE:        C0 A5         CPY.B #$A5                
CODE_02BDE0:        D0 02         BNE CODE_02BDE4           
CODE_02BDE2:        4A            LSR                       
CODE_02BDE3:        EA            NOP                       
CODE_02BDE4:        9D 40 15      STA.W $1540,X             
CODE_02BDE7:        A9 20         LDA.B #$20                
CODE_02BDE9:        B4 9E         LDY RAM_SpriteNum,X       ; \ Branch if Wall-follow Urchin 
CODE_02BDEB:        C0 3C         CPY.B #$3C                ;  | 
CODE_02BDED:        F0 08         BEQ CODE_02BDF7           ; / 
CODE_02BDEF:        A9 10         LDA.B #$10                
CODE_02BDF1:        C0 A5         CPY.B #$A5                
CODE_02BDF3:        D0 02         BNE CODE_02BDF7           
CODE_02BDF5:        4A            LSR                       
CODE_02BDF6:        EA            NOP                       
CODE_02BDF7:        DD 40 15      CMP.W $1540,X             
CODE_02BDFA:        D0 12         BNE CODE_02BE0E           
CODE_02BDFC:        F6 C2         INC RAM_SpriteState,X     
CODE_02BDFE:        B5 C2         LDA RAM_SpriteState,X     
CODE_02BE00:        C9 04         CMP.B #$04                
CODE_02BE02:        D0 02         BNE CODE_02BE06           
CODE_02BE04:        74 C2         STZ RAM_SpriteState,X     
CODE_02BE06:        C9 08         CMP.B #$08                
CODE_02BE08:        D0 04         BNE CODE_02BE0E           
CODE_02BE0A:        A9 04         LDA.B #$04                
CODE_02BE0C:        95 C2         STA RAM_SpriteState,X     
CODE_02BE0E:        B4 C2         LDY RAM_SpriteState,X     
CODE_02BE10:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_02BE13:        39 AF BC      AND.W DATA_02BCAF,Y       
CODE_02BE16:        F0 17         BEQ CODE_02BE2F           
CODE_02BE18:        A9 08         LDA.B #$08                
CODE_02BE1A:        9D 64 15      STA.W $1564,X             
CODE_02BE1D:        D6 C2         DEC RAM_SpriteState,X     
CODE_02BE1F:        B5 C2         LDA RAM_SpriteState,X     
CODE_02BE21:        10 04         BPL CODE_02BE27           
CODE_02BE23:        A9 03         LDA.B #$03                
CODE_02BE25:        80 06         BRA CODE_02BE2D           

CODE_02BE27:        C9 03         CMP.B #$03                
CODE_02BE29:        D0 04         BNE CODE_02BE2F           
CODE_02BE2B:        A9 07         LDA.B #$07                
CODE_02BE2D:        95 C2         STA RAM_SpriteState,X     
CODE_02BE2F:        B4 C2         LDY RAM_SpriteState,X     
CODE_02BE31:        B9 97 BC      LDA.W DATA_02BC97,Y       
CODE_02BE34:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02BE36:        B9 8F BC      LDA.W DATA_02BC8F,Y       
CODE_02BE39:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02BE3B:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if not Ground-guided Fuzzball/Sparky 
CODE_02BE3D:        C9 A5         CMP.B #$A5                ;  | 
CODE_02BE3F:        D0 04         BNE CODE_02BE45           ; / 
CODE_02BE41:        16 B6         ASL RAM_SpriteSpeedX,X    
CODE_02BE43:        16 AA         ASL RAM_SpriteSpeedY,X    
CODE_02BE45:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02BE48:        20 94 D2      JSR.W UpdateYPosNoGrvty   
Return02BE4B:       6B            RTL                       ; Return 


DATA_02BE4C:                      .db $05,$45

CODE_02BE4E:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02BE50:        C9 A5         CMP.B #$A5                
CODE_02BE52:        D0 61         BNE CODE_02BEB5           
CODE_02BE54:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_02BE58:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02BE5B:        AD 2B 19      LDA.W $192B               
CODE_02BE5E:        C9 02         CMP.B #$02                
CODE_02BE60:        D0 17         BNE CODE_02BE79           
CODE_02BE62:        DA            PHX                       
CODE_02BE63:        A5 14         LDA RAM_FrameCounterB     
CODE_02BE65:        4A            LSR                       
CODE_02BE66:        4A            LSR                       
CODE_02BE67:        29 01         AND.B #$01                
CODE_02BE69:        AA            TAX                       
CODE_02BE6A:        A9 C8         LDA.B #$C8                
CODE_02BE6C:        99 02 03      STA.W OAM_Tile,Y          
CODE_02BE6F:        BD 4C BE      LDA.W DATA_02BE4C,X       
CODE_02BE72:        05 64         ORA $64                   
CODE_02BE74:        99 03 03      STA.W OAM_Prop,Y          
CODE_02BE77:        FA            PLX                       
Return02BE78:       60            RTS                       ; Return 

CODE_02BE79:        A9 0A         LDA.B #$0A                
CODE_02BE7B:        99 02 03      STA.W OAM_Tile,Y          
CODE_02BE7E:        A5 14         LDA RAM_FrameCounterB     
CODE_02BE80:        29 0C         AND.B #$0C                
CODE_02BE82:        0A            ASL                       
CODE_02BE83:        0A            ASL                       
CODE_02BE84:        0A            ASL                       
CODE_02BE85:        0A            ASL                       
CODE_02BE86:        59 03 03      EOR.W OAM_Prop,Y          
CODE_02BE89:        99 03 03      STA.W OAM_Prop,Y          
Return02BE8C:       60            RTS                       ; Return 


DATA_02BE8D:                      .db $F8,$08,$F8,$08

DATA_02BE91:                      .db $F8,$F8,$08,$08

HotheadTiles:                     .db $0C,$0E,$0E,$0C,$0E,$0C,$0C,$0E
DATA_02BE9D:                      .db $05,$05,$C5,$C5,$45,$45,$85,$85
DATA_02BEA5:                      .db $07,$07,$01,$01,$01,$01,$07,$07
DATA_02BEAD:                      .db $00,$08,$08,$00,$00,$08,$08,$00

CODE_02BEB5:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02BEB8:        98            TYA                       
CODE_02BEB9:        18            CLC                       
CODE_02BEBA:        69 04         ADC.B #$04                
CODE_02BEBC:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_02BEBF:        A8            TAY                       
CODE_02BEC0:        A5 14         LDA RAM_FrameCounterB     
CODE_02BEC2:        29 04         AND.B #$04                
CODE_02BEC4:        85 03         STA $03                   
CODE_02BEC6:        DA            PHX                       
CODE_02BEC7:        A2 03         LDX.B #$03                
CODE_02BEC9:        A5 00         LDA $00                   
CODE_02BECB:        18            CLC                       
CODE_02BECC:        7D 8D BE      ADC.W DATA_02BE8D,X       
CODE_02BECF:        99 00 03      STA.W OAM_DispX,Y         
CODE_02BED2:        A5 01         LDA $01                   
CODE_02BED4:        18            CLC                       
CODE_02BED5:        7D 91 BE      ADC.W DATA_02BE91,X       
CODE_02BED8:        99 01 03      STA.W OAM_DispY,Y         
CODE_02BEDB:        DA            PHX                       
CODE_02BEDC:        8A            TXA                       
CODE_02BEDD:        05 03         ORA $03                   
CODE_02BEDF:        AA            TAX                       
CODE_02BEE0:        BD 95 BE      LDA.W HotheadTiles,X      
CODE_02BEE3:        99 02 03      STA.W OAM_Tile,Y          
CODE_02BEE6:        BD 9D BE      LDA.W DATA_02BE9D,X       
CODE_02BEE9:        05 64         ORA $64                   
CODE_02BEEB:        99 03 03      STA.W OAM_Prop,Y          
CODE_02BEEE:        FA            PLX                       
CODE_02BEEF:        C8            INY                       
CODE_02BEF0:        C8            INY                       
CODE_02BEF1:        C8            INY                       
CODE_02BEF2:        C8            INY                       
CODE_02BEF3:        CA            DEX                       
CODE_02BEF4:        10 D3         BPL CODE_02BEC9           
CODE_02BEF6:        FA            PLX                       
CODE_02BEF7:        A5 00         LDA $00                   
CODE_02BEF9:        48            PHA                       
CODE_02BEFA:        A5 01         LDA $01                   
CODE_02BEFC:        48            PHA                       
CODE_02BEFD:        A0 02         LDY.B #$02                
CODE_02BEFF:        A9 03         LDA.B #$03                
CODE_02BF01:        20 A7 B7      JSR.W CODE_02B7A7         
CODE_02BF04:        68            PLA                       
CODE_02BF05:        85 01         STA $01                   
CODE_02BF07:        68            PLA                       
CODE_02BF08:        85 00         STA $00                   
CODE_02BF0A:        A9 09         LDA.B #$09                
CODE_02BF0C:        BC 58 15      LDY.W $1558,X             
CODE_02BF0F:        F0 02         BEQ CODE_02BF13           
CODE_02BF11:        A9 19         LDA.B #$19                
CODE_02BF13:        85 02         STA $02                   
CODE_02BF15:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_02BF18:        38            SEC                       
CODE_02BF19:        E9 04         SBC.B #$04                
CODE_02BF1B:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_02BF1E:        A8            TAY                       
CODE_02BF1F:        DA            PHX                       
CODE_02BF20:        B5 C2         LDA RAM_SpriteState,X     
CODE_02BF22:        AA            TAX                       
CODE_02BF23:        A5 00         LDA $00                   
CODE_02BF25:        18            CLC                       
CODE_02BF26:        7D A5 BE      ADC.W DATA_02BEA5,X       
CODE_02BF29:        99 00 03      STA.W OAM_DispX,Y         
CODE_02BF2C:        A5 01         LDA $01                   
CODE_02BF2E:        18            CLC                       
CODE_02BF2F:        7D AD BE      ADC.W DATA_02BEAD,X       
CODE_02BF32:        99 01 03      STA.W OAM_DispY,Y         
CODE_02BF35:        A5 02         LDA $02                   
CODE_02BF37:        99 02 03      STA.W OAM_Tile,Y          
CODE_02BF3A:        A9 05         LDA.B #$05                
CODE_02BF3C:        05 64         ORA $64                   
CODE_02BF3E:        99 03 03      STA.W OAM_Prop,Y          
CODE_02BF41:        FA            PLX                       
CODE_02BF42:        A0 00         LDY.B #$00                
CODE_02BF44:        A9 00         LDA.B #$00                
CODE_02BF46:        4C A7 B7      JMP.W CODE_02B7A7         


DATA_02BF49:                      .db $08,$00,$10,$00,$10

DATA_02BF4E:                      .db $08,$00,$00,$10,$10

DATA_02BF53:                      .db $37,$37,$77,$B7,$F7

UrchinTiles:                      .db $C4,$C6,$C8,$C6

CODE_02BF5C:        BD 3E 16      LDA.W $163E,X             
CODE_02BF5F:        D0 08         BNE CODE_02BF69           
CODE_02BF61:        FE 28 15      INC.W $1528,X             
CODE_02BF64:        A9 0C         LDA.B #$0C                
CODE_02BF66:        9D 3E 16      STA.W $163E,X             
CODE_02BF69:        BD 28 15      LDA.W $1528,X             
CODE_02BF6C:        29 03         AND.B #$03                
CODE_02BF6E:        A8            TAY                       
CODE_02BF6F:        B9 D7 BC      LDA.W DATA_02BCD7,Y       
CODE_02BF72:        9D 02 16      STA.W $1602,X             
CODE_02BF75:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02BF78:        64 05         STZ $05                   
CODE_02BF7A:        BD 02 16      LDA.W $1602,X             
CODE_02BF7D:        85 02         STA $02                   
CODE_02BF7F:        BD 58 15      LDA.W $1558,X             
CODE_02BF82:        85 03         STA $03                   
CODE_02BF84:        A6 05         LDX $05                   
CODE_02BF86:        A5 00         LDA $00                   
CODE_02BF88:        18            CLC                       
CODE_02BF89:        7D 49 BF      ADC.W DATA_02BF49,X       
CODE_02BF8C:        99 00 03      STA.W OAM_DispX,Y         
CODE_02BF8F:        A5 01         LDA $01                   
CODE_02BF91:        18            CLC                       
CODE_02BF92:        7D 4E BF      ADC.W DATA_02BF4E,X       
CODE_02BF95:        99 01 03      STA.W OAM_DispY,Y         
CODE_02BF98:        BD 53 BF      LDA.W DATA_02BF53,X       
CODE_02BF9B:        99 03 03      STA.W OAM_Prop,Y          
CODE_02BF9E:        E0 00         CPX.B #$00                
CODE_02BFA0:        D0 0A         BNE CODE_02BFAC           
CODE_02BFA2:        A9 CA         LDA.B #$CA                
CODE_02BFA4:        A6 03         LDX $03                   
CODE_02BFA6:        F0 02         BEQ CODE_02BFAA           
CODE_02BFA8:        A9 CC         LDA.B #$CC                
CODE_02BFAA:        80 05         BRA CODE_02BFB1           

CODE_02BFAC:        A6 02         LDX $02                   
CODE_02BFAE:        BD 58 BF      LDA.W UrchinTiles,X       
CODE_02BFB1:        99 02 03      STA.W OAM_Tile,Y          
CODE_02BFB4:        C8            INY                       
CODE_02BFB5:        C8            INY                       
CODE_02BFB6:        C8            INY                       
CODE_02BFB7:        C8            INY                       
CODE_02BFB8:        E6 05         INC $05                   
CODE_02BFBA:        A5 05         LDA $05                   
CODE_02BFBC:        C9 05         CMP.B #$05                
CODE_02BFBE:        D0 C4         BNE CODE_02BF84           
CODE_02BFC0:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02BFC3:        A0 02         LDY.B #$02                
CODE_02BFC5:        4C 2B C8      JMP.W CODE_02C82B         


DATA_02BFC8:                      .db $10,$F0

DATA_02BFCA:                      .db $01,$FF

Return02BFCC:       6B            RTL                       ; Return 

RipVanFishMain:     22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_02BFD1:        A5 9D         LDA RAM_SpritesLocked     
CODE_02BFD3:        D0 F7         BNE Return02BFCC          
CODE_02BFD5:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02BFD8:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_02BFDC:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02BFDE:        48            PHA                       
CODE_02BFDF:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02BFE1:        48            PHA                       
CODE_02BFE2:        AC 90 14      LDY.W $1490               ; \ Branch if Mario doesn't have star 
CODE_02BFE5:        F0 0C         BEQ CODE_02BFF3           ; / 
CODE_02BFE7:        49 FF         EOR.B #$FF                
CODE_02BFE9:        1A            INC A                     
CODE_02BFEA:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02BFEC:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02BFEE:        49 FF         EOR.B #$FF                
CODE_02BFF0:        1A            INC A                     
CODE_02BFF1:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02BFF3:        20 26 C1      JSR.W CODE_02C126         
CODE_02BFF6:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02BFF9:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02BFFC:        22 38 91 01   JSL.L CODE_019138         
CODE_02C000:        68            PLA                       
CODE_02C001:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02C003:        68            PLA                       
CODE_02C004:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02C006:        FE 70 15      INC.W $1570,X             
CODE_02C009:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not touching object 
CODE_02C00C:        29 03         AND.B #$03                ;  | 
CODE_02C00E:        F0 02         BEQ CODE_02C012           ; / 
CODE_02C010:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_02C012:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_02C015:        29 0C         AND.B #$0C                
CODE_02C017:        F0 02         BEQ CODE_02C01B           
CODE_02C019:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_02C01B:        BD 4A 16      LDA.W $164A,X             
CODE_02C01E:        D0 04         BNE CODE_02C024           
ADDR_02C020:        A9 10         LDA.B #$10                
ADDR_02C022:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02C024:        B5 C2         LDA RAM_SpriteState,X     
CODE_02C026:        22 DF 86 00   JSL.L ExecutePtr          

RipVanFishPtrs:        2E C0      .dw CODE_02C02E           
                       8A C0      .dw CODE_02C08A           

CODE_02C02E:        A9 02         LDA.B #$02                
CODE_02C030:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02C032:        A5 13         LDA RAM_FrameCounter      
CODE_02C034:        29 03         AND.B #$03                
CODE_02C036:        D0 0C         BNE CODE_02C044           
CODE_02C038:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02C03A:        F0 08         BEQ CODE_02C044           
CODE_02C03C:        10 04         BPL CODE_02C042           
CODE_02C03E:        F6 B6         INC RAM_SpriteSpeedX,X    
CODE_02C040:        80 02         BRA CODE_02C044           

CODE_02C042:        D6 B6         DEC RAM_SpriteSpeedX,X    
CODE_02C044:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02C047:        29 04         AND.B #$04                ;  | 
CODE_02C049:        F0 08         BEQ CODE_02C053           ; / 
CODE_02C04B:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_02C04D:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02C04F:        29 F0         AND.B #$F0                
CODE_02C051:        95 D8         STA RAM_SpriteYLo,X       
CODE_02C053:        22 D9 C0 02   JSL.L CODE_02C0D9         
CODE_02C057:        AD FD 18      LDA.W $18FD               
CODE_02C05A:        D0 16         BNE CODE_02C072           
CODE_02C05C:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02C05F:        A5 0F         LDA $0F                   
CODE_02C061:        69 30         ADC.B #$30                
CODE_02C063:        C9 60         CMP.B #$60                
CODE_02C065:        B0 14         BCS CODE_02C07B           
CODE_02C067:        20 0C D5      JSR.W CODE_02D50C         
CODE_02C06A:        A5 0E         LDA $0E                   
CODE_02C06C:        69 30         ADC.B #$30                
CODE_02C06E:        C9 60         CMP.B #$60                
CODE_02C070:        B0 09         BCS CODE_02C07B           
CODE_02C072:        F6 C2         INC RAM_SpriteState,X     
CODE_02C074:        A9 FF         LDA.B #$FF                
CODE_02C076:        9D 1C 15      STA.W $151C,X             
CODE_02C079:        80 0F         BRA CODE_02C08A           

CODE_02C07B:        A0 02         LDY.B #$02                
CODE_02C07D:        BD 70 15      LDA.W $1570,X             
CODE_02C080:        29 30         AND.B #$30                
CODE_02C082:        D0 01         BNE CODE_02C085           
CODE_02C084:        C8            INY                       
CODE_02C085:        98            TYA                       
CODE_02C086:        9D 02 16      STA.W $1602,X             
Return02C089:       6B            RTL                       ; Return 

CODE_02C08A:        A5 13         LDA RAM_FrameCounter      
CODE_02C08C:        29 01         AND.B #$01                
CODE_02C08E:        D0 05         BNE CODE_02C095           
CODE_02C090:        DE 1C 15      DEC.W $151C,X             
CODE_02C093:        F0 35         BEQ CODE_02C0CA           
CODE_02C095:        A5 13         LDA RAM_FrameCounter      
CODE_02C097:        29 07         AND.B #$07                
CODE_02C099:        D0 20         BNE CODE_02C0BB           
CODE_02C09B:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02C09E:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02C0A0:        D9 C8 BF      CMP.W DATA_02BFC8,Y       
CODE_02C0A3:        F0 06         BEQ CODE_02C0AB           
CODE_02C0A5:        18            CLC                       
CODE_02C0A6:        79 CA BF      ADC.W DATA_02BFCA,Y       
CODE_02C0A9:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02C0AB:        20 0C D5      JSR.W CODE_02D50C         
CODE_02C0AE:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02C0B0:        D9 C8 BF      CMP.W DATA_02BFC8,Y       
CODE_02C0B3:        F0 06         BEQ CODE_02C0BB           
CODE_02C0B5:        18            CLC                       
CODE_02C0B6:        79 CA BF      ADC.W DATA_02BFCA,Y       
CODE_02C0B9:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02C0BB:        A0 00         LDY.B #$00                
CODE_02C0BD:        BD 70 15      LDA.W $1570,X             
CODE_02C0C0:        29 04         AND.B #$04                
CODE_02C0C2:        F0 01         BEQ CODE_02C0C5           
CODE_02C0C4:        C8            INY                       
CODE_02C0C5:        98            TYA                       
CODE_02C0C6:        9D 02 16      STA.W $1602,X             
Return02C0C9:       6B            RTL                       ; Return 

CODE_02C0CA:        74 C2         STZ RAM_SpriteState,X     
CODE_02C0CC:        4C 2E C0      JMP.W CODE_02C02E         

ADDR_02C0CF:        A9 08         LDA.B #$08                ; \ Unreachable 
ADDR_02C0D1:        BC 7C 15      LDY.W RAM_SpriteDir,X     ;  | A = #$08 or #$09 depending on sprite direction 
ADDR_02C0D4:        F0 01         BEQ ADDR_02C0D7           ;  | 
ADDR_02C0D6:        1A            INC A                     ; / 
ADDR_02C0D7:        80 02         BRA CODE_02C0DB           

CODE_02C0D9:        A9 06         LDA.B #$06                
CODE_02C0DB:        A8            TAY                       
CODE_02C0DC:        BD A0 15      LDA.W RAM_OffscreenHorz,X ; \ Return if sprite is offscreen 
CODE_02C0DF:        1D 6C 18      ORA.W RAM_OffscreenVert,X ;  | 
CODE_02C0E2:        D0 41         BNE Return02C125          ; / 
CODE_02C0E4:        98            TYA                       
CODE_02C0E5:        DE 28 15      DEC.W $1528,X             
CODE_02C0E8:        10 3B         BPL Return02C125          
CODE_02C0EA:        48            PHA                       
CODE_02C0EB:        A9 28         LDA.B #$28                
CODE_02C0ED:        9D 28 15      STA.W $1528,X             
CODE_02C0F0:        A0 0B         LDY.B #$0B                
CODE_02C0F2:        B9 F0 17      LDA.W $17F0,Y             
CODE_02C0F5:        F0 10         BEQ CODE_02C107           
CODE_02C0F7:        88            DEY                       
CODE_02C0F8:        10 F8         BPL CODE_02C0F2           
CODE_02C0FA:        CE 5D 18      DEC.W $185D               
CODE_02C0FD:        10 05         BPL CODE_02C104           
CODE_02C0FF:        A9 0B         LDA.B #$0B                
CODE_02C101:        8D 5D 18      STA.W $185D               
CODE_02C104:        AC 5D 18      LDY.W $185D               
CODE_02C107:        68            PLA                       
CODE_02C108:        99 F0 17      STA.W $17F0,Y             
CODE_02C10B:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02C10D:        18            CLC                       
CODE_02C10E:        69 06         ADC.B #$06                
CODE_02C110:        99 08 18      STA.W $1808,Y             
CODE_02C113:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02C115:        18            CLC                       
CODE_02C116:        69 00         ADC.B #$00                
CODE_02C118:        99 FC 17      STA.W $17FC,Y             
CODE_02C11B:        A9 7F         LDA.B #$7F                
CODE_02C11D:        99 50 18      STA.W $1850,Y             
CODE_02C120:        A9 FA         LDA.B #$FA                
CODE_02C122:        99 2C 18      STA.W $182C,Y             
Return02C125:       6B            RTL                       ; Return 

CODE_02C126:        A0 00         LDY.B #$00                
CODE_02C128:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02C12A:        10 01         BPL CODE_02C12D           
CODE_02C12C:        C8            INY                       
CODE_02C12D:        98            TYA                       
CODE_02C12E:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return02C131:       60            RTS                       ; Return 


DATA_02C132:                      .db $30,$20,$0A,$30

DATA_02C136:                      .db $05,$0E,$0F,$10

CODE_02C13A:        BD 58 15      LDA.W $1558,X             
CODE_02C13D:        F0 17         BEQ CODE_02C156           
CODE_02C13F:        C9 01         CMP.B #$01                
CODE_02C141:        D0 0D         BNE CODE_02C150           
CODE_02C143:        A9 30         LDA.B #$30                
CODE_02C145:        9D 40 15      STA.W $1540,X             
CODE_02C148:        A9 04         LDA.B #$04                
CODE_02C14A:        9D 34 15      STA.W $1534,X             
CODE_02C14D:        9E 70 15      STZ.W $1570,X             
CODE_02C150:        A9 02         LDA.B #$02                
CODE_02C152:        9D 1C 15      STA.W $151C,X             
Return02C155:       60            RTS                       ; Return 

CODE_02C156:        BD 40 15      LDA.W $1540,X             
CODE_02C159:        D0 26         BNE CODE_02C181           
CODE_02C15B:        FE 34 15      INC.W $1534,X             
CODE_02C15E:        BD 34 15      LDA.W $1534,X             
CODE_02C161:        29 03         AND.B #$03                
CODE_02C163:        9D 70 15      STA.W $1570,X             
CODE_02C166:        A8            TAY                       
CODE_02C167:        B9 32 C1      LDA.W DATA_02C132,Y       
CODE_02C16A:        9D 40 15      STA.W $1540,X             
CODE_02C16D:        C0 01         CPY.B #$01                
CODE_02C16F:        D0 10         BNE CODE_02C181           
CODE_02C171:        BD 34 15      LDA.W $1534,X             
CODE_02C174:        29 0C         AND.B #$0C                
CODE_02C176:        D0 06         BNE CODE_02C17E           
CODE_02C178:        A9 40         LDA.B #$40                
CODE_02C17A:        9D 58 15      STA.W $1558,X             
Return02C17D:       60            RTS                       ; Return 

CODE_02C17E:        20 9A C1      JSR.W CODE_02C19A         
CODE_02C181:        BC 70 15      LDY.W $1570,X             
CODE_02C184:        B9 36 C1      LDA.W DATA_02C136,Y       
CODE_02C187:        9D 02 16      STA.W $1602,X             
CODE_02C18A:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02C18D:        B9 F3 C1      LDA.W DATA_02C1F3,Y       
CODE_02C190:        9D 1C 15      STA.W $151C,X             
Return02C193:       60            RTS                       ; Return 


DATA_02C194:                      .db $14,$EC

DATA_02C196:                      .db $00,$FF

DATA_02C198:                      .db $08,$F8

CODE_02C19A:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_02C19E:        30 52         BMI Return02C1F2          ; / 
CODE_02C1A0:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02C1A2:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02C1A5:        A9 48         LDA.B #$48                
CODE_02C1A7:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_02C1AA:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02C1AD:        85 02         STA $02                   
CODE_02C1AF:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02C1B1:        85 00         STA $00                   
CODE_02C1B3:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02C1B6:        85 01         STA $01                   
CODE_02C1B8:        DA            PHX                       
CODE_02C1B9:        BB            TYX                       
CODE_02C1BA:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02C1BE:        A6 02         LDX $02                   
CODE_02C1C0:        A5 00         LDA $00                   
CODE_02C1C2:        18            CLC                       
CODE_02C1C3:        7D 94 C1      ADC.W DATA_02C194,X       
CODE_02C1C6:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_02C1C9:        A5 01         LDA $01                   
CODE_02C1CB:        7D 96 C1      ADC.W DATA_02C196,X       
CODE_02C1CE:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_02C1D1:        BD 98 C1      LDA.W DATA_02C198,X       
CODE_02C1D4:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_02C1D7:        FA            PLX                       
CODE_02C1D8:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02C1DA:        18            CLC                       
CODE_02C1DB:        69 0A         ADC.B #$0A                
CODE_02C1DD:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_02C1E0:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02C1E3:        69 00         ADC.B #$00                
CODE_02C1E5:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_02C1E8:        A9 C0         LDA.B #$C0                
CODE_02C1EA:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_02C1ED:        A9 2C         LDA.B #$2C                
CODE_02C1EF:        99 40 15      STA.W $1540,Y             
Return02C1F2:       60            RTS                       ; Return 


DATA_02C1F3:                      .db $01,$03

ChucksMain:         8B            PHB                       
CODE_02C1F6:        4B            PHK                       
CODE_02C1F7:        AB            PLB                       
CODE_02C1F8:        BD 7B 18      LDA.W $187B,X             
CODE_02C1FB:        48            PHA                       
CODE_02C1FC:        20 2C C2      JSR.W CODE_02C22C         
CODE_02C1FF:        68            PLA                       
CODE_02C200:        D0 0F         BNE CODE_02C211           
CODE_02C202:        DD 7B 18      CMP.W $187B,X             
CODE_02C205:        F0 0A         BEQ CODE_02C211           
CODE_02C207:        BD 3E 16      LDA.W $163E,X             
CODE_02C20A:        D0 05         BNE CODE_02C211           
CODE_02C20C:        A9 28         LDA.B #$28                
CODE_02C20E:        9D 3E 16      STA.W $163E,X             
CODE_02C211:        AB            PLB                       
Return02C212:       6B            RTL                       ; Return 


DATA_02C213:                      .db $01,$02,$03,$02

CODE_02C217:        A5 14         LDA RAM_FrameCounterB     
CODE_02C219:        4A            LSR                       
CODE_02C21A:        4A            LSR                       
CODE_02C21B:        29 03         AND.B #$03                
CODE_02C21D:        A8            TAY                       
CODE_02C21E:        B9 13 C2      LDA.W DATA_02C213,Y       
CODE_02C221:        9D 1C 15      STA.W $151C,X             
CODE_02C224:        20 1A C8      JSR.W CODE_02C81A         
Return02C227:       60            RTS                       ; Return 


DATA_02C228:                      .db $40,$10

DATA_02C22A:                      .db $03,$01

CODE_02C22C:        BD C8 14      LDA.W $14C8,X             
CODE_02C22F:        C9 08         CMP.B #$08                
CODE_02C231:        D0 E4         BNE CODE_02C217           
CODE_02C233:        BD AC 15      LDA.W $15AC,X             
CODE_02C236:        F0 05         BEQ CODE_02C23D           
CODE_02C238:        A9 05         LDA.B #$05                
CODE_02C23A:        9D 02 16      STA.W $1602,X             
CODE_02C23D:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if on ground 
CODE_02C240:        29 04         AND.B #$04                ;  | 
CODE_02C242:        D0 0F         BNE CODE_02C253           ; / 
CODE_02C244:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02C246:        10 0B         BPL CODE_02C253           
CODE_02C248:        B5 C2         LDA RAM_SpriteState,X     
CODE_02C24A:        C9 05         CMP.B #$05                
CODE_02C24C:        B0 05         BCS CODE_02C253           
CODE_02C24E:        A9 06         LDA.B #$06                
CODE_02C250:        9D 02 16      STA.W $1602,X             
CODE_02C253:        20 1A C8      JSR.W CODE_02C81A         
CODE_02C256:        A5 9D         LDA RAM_SpritesLocked     
CODE_02C258:        F0 01         BEQ CODE_02C25B           
Return02C25A:       60            RTS                       ; Return 

CODE_02C25B:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02C25E:        20 9D C7      JSR.W CODE_02C79D         
CODE_02C261:        22 32 80 01   JSL.L SprSprInteract      
CODE_02C265:        22 38 91 01   JSL.L CODE_019138         
CODE_02C269:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_02C26C:        29 08         AND.B #$08                
CODE_02C26E:        F0 04         BEQ CODE_02C274           
CODE_02C270:        A9 10         LDA.B #$10                
CODE_02C272:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02C274:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not touching object 
CODE_02C277:        29 03         AND.B #$03                ;  | 
CODE_02C279:        F0 79         BEQ CODE_02C2F4           ; / 
CODE_02C27B:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_02C27E:        1D 6C 18      ORA.W RAM_OffscreenVert,X 
CODE_02C281:        D0 61         BNE CODE_02C2E4           
CODE_02C283:        BD 7B 18      LDA.W $187B,X             
CODE_02C286:        F0 5C         BEQ CODE_02C2E4           
CODE_02C288:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02C28A:        38            SEC                       
CODE_02C28B:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02C28D:        18            CLC                       
CODE_02C28E:        69 14         ADC.B #$14                
CODE_02C290:        C9 1C         CMP.B #$1C                
CODE_02C292:        90 50         BCC CODE_02C2E4           
CODE_02C294:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if on ground 
CODE_02C297:        29 40         AND.B #$40                ;  | 
CODE_02C299:        D0 49         BNE CODE_02C2E4           ; / 
CODE_02C29B:        AD A7 18      LDA.W $18A7               
CODE_02C29E:        C9 2E         CMP.B #$2E                
CODE_02C2A0:        F0 04         BEQ CODE_02C2A6           
CODE_02C2A2:        C9 1E         CMP.B #$1E                
CODE_02C2A4:        D0 3E         BNE CODE_02C2E4           
CODE_02C2A6:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02C2A9:        29 04         AND.B #$04                ;  | 
CODE_02C2AB:        F0 4A         BEQ CODE_02C2F7           ; / 
CODE_02C2AD:        A5 9B         LDA RAM_BlockYHi          
CODE_02C2AF:        48            PHA                       
CODE_02C2B0:        A5 9A         LDA RAM_BlockYLo          
CODE_02C2B2:        48            PHA                       
CODE_02C2B3:        A5 99         LDA RAM_BlockXHi          
CODE_02C2B5:        48            PHA                       
CODE_02C2B6:        A5 98         LDA RAM_BlockXLo          
CODE_02C2B8:        48            PHA                       
CODE_02C2B9:        22 63 86 02   JSL.L ShatterBlock        
CODE_02C2BD:        A9 02         LDA.B #$02                ; \ Block to generate = #$02 
CODE_02C2BF:        85 9C         STA RAM_BlockBlock        ; / 
CODE_02C2C1:        22 B0 BE 00   JSL.L GenerateTile        
CODE_02C2C5:        68            PLA                       
CODE_02C2C6:        38            SEC                       
CODE_02C2C7:        E9 10         SBC.B #$10                
CODE_02C2C9:        85 98         STA RAM_BlockXLo          
CODE_02C2CB:        68            PLA                       
CODE_02C2CC:        E9 00         SBC.B #$00                
CODE_02C2CE:        85 99         STA RAM_BlockXHi          
CODE_02C2D0:        68            PLA                       
CODE_02C2D1:        85 9A         STA RAM_BlockYLo          
CODE_02C2D3:        68            PLA                       
CODE_02C2D4:        85 9B         STA RAM_BlockYHi          
CODE_02C2D6:        22 63 86 02   JSL.L ShatterBlock        
CODE_02C2DA:        A9 02         LDA.B #$02                ; \ Block to generate = #$02 
CODE_02C2DC:        85 9C         STA RAM_BlockBlock        ; / 
CODE_02C2DE:        22 B0 BE 00   JSL.L GenerateTile        
CODE_02C2E2:        80 10         BRA CODE_02C2F4           

CODE_02C2E4:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02C2E7:        29 04         AND.B #$04                ;  | 
CODE_02C2E9:        F0 0C         BEQ CODE_02C2F7           ; / 
CODE_02C2EB:        A9 C0         LDA.B #$C0                
CODE_02C2ED:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02C2EF:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02C2F2:        80 0D         BRA CODE_02C301           

CODE_02C2F4:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02C2F7:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02C2FA:        29 04         AND.B #$04                ;  | 
CODE_02C2FC:        F0 03         BEQ CODE_02C301           ; / 
CODE_02C2FE:        20 79 C5      JSR.W CODE_02C579         
CODE_02C301:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02C304:        BC 4A 16      LDY.W $164A,X             
CODE_02C307:        C0 01         CPY.B #$01                
CODE_02C309:        A0 00         LDY.B #$00                
CODE_02C30B:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02C30D:        90 0B         BCC CODE_02C31A           
CODE_02C30F:        C8            INY                       
CODE_02C310:        C9 00         CMP.B #$00                
CODE_02C312:        10 06         BPL CODE_02C31A           
ADDR_02C314:        C9 E0         CMP.B #$E0                
ADDR_02C316:        B0 02         BCS CODE_02C31A           
ADDR_02C318:        A9 E0         LDA.B #$E0                
CODE_02C31A:        18            CLC                       
CODE_02C31B:        79 2A C2      ADC.W DATA_02C22A,Y       
CODE_02C31E:        30 08         BMI CODE_02C328           
CODE_02C320:        D9 28 C2      CMP.W DATA_02C228,Y       
CODE_02C323:        90 03         BCC CODE_02C328           
CODE_02C325:        B9 28 C2      LDA.W DATA_02C228,Y       
CODE_02C328:        A8            TAY                       
CODE_02C329:        30 09         BMI CODE_02C334           
CODE_02C32B:        B4 C2         LDY RAM_SpriteState,X     
CODE_02C32D:        C0 07         CPY.B #$07                
CODE_02C32F:        D0 03         BNE CODE_02C334           
CODE_02C331:        18            CLC                       
CODE_02C332:        69 03         ADC.B #$03                
CODE_02C334:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02C336:        B5 C2         LDA RAM_SpriteState,X     
CODE_02C338:        22 DF 86 00   JSL.L ExecutePtr          

ChuckPtrs:             3B C6      .dw CODE_02C63B           
                       A7 C6      .dw CODE_02C6A7           
                       26 C7      .dw CODE_02C726           
                       4A C7      .dw CODE_02C74A           
                       3A C1      .dw CODE_02C13A           
                       82 C5      .dw CODE_02C582           
                       3C C5      .dw CODE_02C53C           
                       64 C5      .dw CODE_02C564           
                       E3 C4      .dw CODE_02C4E3           
                       BD C4      .dw CODE_02C4BD           
                       CB C3      .dw CODE_02C3CB           
                       56 C3      .dw CODE_02C356           
                       7B C3      .dw CODE_02C37B           

CODE_02C356:        A9 03         LDA.B #$03                
CODE_02C358:        9D 02 16      STA.W $1602,X             
CODE_02C35B:        BD 4A 16      LDA.W $164A,X             
CODE_02C35E:        F0 10         BEQ CODE_02C370           
CODE_02C360:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02C363:        A5 0F         LDA $0F                   
CODE_02C365:        18            CLC                       
CODE_02C366:        69 30         ADC.B #$30                
CODE_02C368:        C9 60         CMP.B #$60                
CODE_02C36A:        B0 04         BCS CODE_02C370           
CODE_02C36C:        A9 0C         LDA.B #$0C                
CODE_02C36E:        95 C2         STA RAM_SpriteState,X     
CODE_02C370:        4C 56 C5      JMP.W CODE_02C556         


DATA_02C373:                      .db $05,$05,$05,$02,$02,$06,$06,$06

CODE_02C37B:        A5 14         LDA RAM_FrameCounterB     
CODE_02C37D:        29 3F         AND.B #$3F                
CODE_02C37F:        D0 05         BNE CODE_02C386           
CODE_02C381:        A9 1E         LDA.B #$1E                ; \ Play sound effect 
CODE_02C383:        8D FC 1D      STA.W $1DFC               ; / 
CODE_02C386:        A0 03         LDY.B #$03                
CODE_02C388:        A5 14         LDA RAM_FrameCounterB     
CODE_02C38A:        29 30         AND.B #$30                
CODE_02C38C:        F0 02         BEQ CODE_02C390           
CODE_02C38E:        A0 06         LDY.B #$06                
CODE_02C390:        98            TYA                       
CODE_02C391:        9D 02 16      STA.W $1602,X             
CODE_02C394:        A5 14         LDA RAM_FrameCounterB     
CODE_02C396:        4A            LSR                       
CODE_02C397:        4A            LSR                       
CODE_02C398:        29 07         AND.B #$07                
CODE_02C39A:        A8            TAY                       
CODE_02C39B:        B9 73 C3      LDA.W DATA_02C373,Y       
CODE_02C39E:        9D 1C 15      STA.W $151C,X             
CODE_02C3A1:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02C3A3:        4A            LSR                       
CODE_02C3A4:        4A            LSR                       
CODE_02C3A5:        4A            LSR                       
CODE_02C3A6:        4A            LSR                       
CODE_02C3A7:        4A            LSR                       
CODE_02C3A8:        A9 09         LDA.B #$09                
CODE_02C3AA:        90 03         BCC CODE_02C3AF           
CODE_02C3AC:        8D B9 18      STA.W RAM_GeneratorNum    
CODE_02C3AF:        8D FD 18      STA.W $18FD               
Return02C3B2:       60            RTS                       ; Return 


DATA_02C3B3:                      .db $7F,$BF,$FF,$DF

DATA_02C3B7:                      .db $18,$19,$14,$14

DATA_02C3BB:                      .db $18,$18,$18,$18,$17,$17,$17,$17
                                  .db $17,$17,$16,$15,$15,$16,$16,$16

CODE_02C3CB:        BD 34 15      LDA.W $1534,X             
CODE_02C3CE:        D0 6A         BNE CODE_02C43A           
CODE_02C3D0:        20 0C D5      JSR.W CODE_02D50C         
CODE_02C3D3:        A5 0E         LDA $0E                   
CODE_02C3D5:        10 10         BPL CODE_02C3E7           
CODE_02C3D7:        C9 D0         CMP.B #$D0                
CODE_02C3D9:        B0 0C         BCS CODE_02C3E7           
CODE_02C3DB:        A9 C8         LDA.B #$C8                
CODE_02C3DD:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02C3DF:        A9 3E         LDA.B #$3E                
CODE_02C3E1:        9D 40 15      STA.W $1540,X             
CODE_02C3E4:        FE 34 15      INC.W $1534,X             
CODE_02C3E7:        A5 13         LDA RAM_FrameCounter      
CODE_02C3E9:        29 07         AND.B #$07                
CODE_02C3EB:        D0 08         BNE CODE_02C3F5           
CODE_02C3ED:        BD 40 15      LDA.W $1540,X             
CODE_02C3F0:        F0 03         BEQ CODE_02C3F5           
CODE_02C3F2:        FE 40 15      INC.W $1540,X             
CODE_02C3F5:        A5 14         LDA RAM_FrameCounterB     
CODE_02C3F7:        29 3F         AND.B #$3F                
CODE_02C3F9:        D0 03         BNE CODE_02C3FE           
CODE_02C3FB:        20 56 C5      JSR.W CODE_02C556         
CODE_02C3FE:        BD 40 15      LDA.W $1540,X             
CODE_02C401:        D0 09         BNE CODE_02C40C           
CODE_02C403:        BC 7B 18      LDY.W $187B,X             
CODE_02C406:        B9 B3 C3      LDA.W DATA_02C3B3,Y       
CODE_02C409:        9D 40 15      STA.W $1540,X             
CODE_02C40C:        BD 40 15      LDA.W $1540,X             
CODE_02C40F:        C9 40         CMP.B #$40                
CODE_02C411:        B0 06         BCS CODE_02C419           
CODE_02C413:        A9 00         LDA.B #$00                
CODE_02C415:        9D 02 16      STA.W $1602,X             
Return02C418:       60            RTS                       ; Return 

CODE_02C419:        38            SEC                       
CODE_02C41A:        E9 40         SBC.B #$40                
CODE_02C41C:        4A            LSR                       
CODE_02C41D:        4A            LSR                       
CODE_02C41E:        4A            LSR                       
CODE_02C41F:        29 03         AND.B #$03                
CODE_02C421:        A8            TAY                       
CODE_02C422:        B9 B7 C3      LDA.W DATA_02C3B7,Y       
CODE_02C425:        9D 02 16      STA.W $1602,X             
CODE_02C428:        BD 40 15      LDA.W $1540,X             
CODE_02C42B:        29 1F         AND.B #$1F                
CODE_02C42D:        C9 06         CMP.B #$06                
CODE_02C42F:        D0 08         BNE Return02C439          
CODE_02C431:        20 66 C4      JSR.W CODE_02C466         
CODE_02C434:        A9 08         LDA.B #$08                
CODE_02C436:        9D 58 15      STA.W $1558,X             
Return02C439:       60            RTS                       ; Return 

CODE_02C43A:        BD 40 15      LDA.W $1540,X             
CODE_02C43D:        F0 1D         BEQ CODE_02C45C           
CODE_02C43F:        48            PHA                       
CODE_02C440:        C9 20         CMP.B #$20                
CODE_02C442:        90 06         BCC CODE_02C44A           
CODE_02C444:        C9 30         CMP.B #$30                
CODE_02C446:        B0 02         BCS CODE_02C44A           
CODE_02C448:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_02C44A:        4A            LSR                       
CODE_02C44B:        4A            LSR                       
CODE_02C44C:        A8            TAY                       
CODE_02C44D:        B9 BB C3      LDA.W DATA_02C3BB,Y       
CODE_02C450:        9D 02 16      STA.W $1602,X             
CODE_02C453:        68            PLA                       
CODE_02C454:        C9 26         CMP.B #$26                
CODE_02C456:        D0 03         BNE Return02C45B          
CODE_02C458:        20 66 C4      JSR.W CODE_02C466         
Return02C45B:       60            RTS                       ; Return 

CODE_02C45C:        9E 34 15      STZ.W $1534,X             
Return02C45F:       60            RTS                       ; Return 


BaseballTileDispX:                .db $10,$F8

DATA_02C462:                      .db $00,$FF

BaseballSpeed:                    .db $18,$E8

CODE_02C466:        BD 58 15      LDA.W $1558,X             
CODE_02C469:        1D 6C 18      ORA.W RAM_OffscreenVert,X 
CODE_02C46C:        D0 CB         BNE Return02C439          
CODE_02C46E:        A0 07         LDY.B #$07                ; \ Find a free extended sprite slot 
CODE_02C470:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   ;  | 
CODE_02C473:        F0 04         BEQ CODE_02C479           ;  | 
CODE_02C475:        88            DEY                       ;  | 
CODE_02C476:        10 F8         BPL CODE_02C470           ;  | 
Return02C478:       60            RTS                       ; / Return if no free slots 

CODE_02C479:        A9 0D         LDA.B #$0D                ; \ Extended sprite = Baseball 
CODE_02C47B:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_02C47E:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02C480:        85 00         STA $00                   
CODE_02C482:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02C485:        85 01         STA $01                   
CODE_02C487:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02C489:        18            CLC                       
CODE_02C48A:        69 00         ADC.B #$00                
CODE_02C48C:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
CODE_02C48F:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02C492:        69 00         ADC.B #$00                
CODE_02C494:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
CODE_02C497:        DA            PHX                       
CODE_02C498:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02C49B:        AA            TAX                       
CODE_02C49C:        A5 00         LDA $00                   
CODE_02C49E:        18            CLC                       
CODE_02C49F:        7D 60 C4      ADC.W BaseballTileDispX,X 
CODE_02C4A2:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
CODE_02C4A5:        A5 01         LDA $01                   
CODE_02C4A7:        7D 62 C4      ADC.W DATA_02C462,X       
CODE_02C4AA:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
CODE_02C4AD:        BD 64 C4      LDA.W BaseballSpeed,X     
CODE_02C4B0:        99 47 17      STA.W RAM_ExSprSpeedX,Y   
CODE_02C4B3:        FA            PLX                       
Return02C4B4:       60            RTS                       ; Return 


DATA_02C4B5:                      .db $00,$00,$11,$11,$11,$11,$00,$00

CODE_02C4BD:        9E 02 16      STZ.W $1602,X             
CODE_02C4C0:        8A            TXA                       
CODE_02C4C1:        0A            ASL                       
CODE_02C4C2:        0A            ASL                       
CODE_02C4C3:        0A            ASL                       
CODE_02C4C4:        65 13         ADC RAM_FrameCounter      
CODE_02C4C6:        29 7F         AND.B #$7F                
CODE_02C4C8:        C9 00         CMP.B #$00                
CODE_02C4CA:        D0 09         BNE CODE_02C4D5           
CODE_02C4CC:        48            PHA                       
CODE_02C4CD:        20 56 C5      JSR.W CODE_02C556         
CODE_02C4D0:        22 B3 CB 03   JSL.L CODE_03CBB3         
CODE_02C4D4:        68            PLA                       
CODE_02C4D5:        C9 20         CMP.B #$20                
CODE_02C4D7:        B0 09         BCS Return02C4E2          
CODE_02C4D9:        4A            LSR                       
CODE_02C4DA:        4A            LSR                       
CODE_02C4DB:        A8            TAY                       
CODE_02C4DC:        B9 B5 C4      LDA.W DATA_02C4B5,Y       
CODE_02C4DF:        9D 02 16      STA.W $1602,X             
Return02C4E2:       60            RTS                       ; Return 

CODE_02C4E3:        20 56 C5      JSR.W CODE_02C556         
CODE_02C4E6:        A9 06         LDA.B #$06                
CODE_02C4E8:        B4 AA         LDY RAM_SpriteSpeedY,X    
CODE_02C4EA:        C0 F0         CPY.B #$F0                
CODE_02C4EC:        30 16         BMI CODE_02C504           
CODE_02C4EE:        BC 0E 16      LDY.W $160E,X             
CODE_02C4F1:        F0 11         BEQ CODE_02C504           
CODE_02C4F3:        BD E2 1F      LDA.W $1FE2,X             
CODE_02C4F6:        D0 0A         BNE CODE_02C502           
CODE_02C4F8:        A9 19         LDA.B #$19                ; \ Play sound effect 
CODE_02C4FA:        8D FC 1D      STA.W $1DFC               ; / 
CODE_02C4FD:        A9 20         LDA.B #$20                
CODE_02C4FF:        9D E2 1F      STA.W $1FE2,X             
CODE_02C502:        A9 07         LDA.B #$07                
CODE_02C504:        9D 02 16      STA.W $1602,X             
CODE_02C507:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02C50A:        29 04         AND.B #$04                ;  | 
CODE_02C50C:        F0 2D         BEQ Return02C53B          ; / 
CODE_02C50E:        9E 0E 16      STZ.W $160E,X             
CODE_02C511:        A9 04         LDA.B #$04                
CODE_02C513:        9D 02 16      STA.W $1602,X             
CODE_02C516:        BD 40 15      LDA.W $1540,X             
CODE_02C519:        D0 20         BNE Return02C53B          
CODE_02C51B:        A9 20         LDA.B #$20                
CODE_02C51D:        9D 40 15      STA.W $1540,X             
CODE_02C520:        A9 F0         LDA.B #$F0                
CODE_02C522:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02C524:        20 0C D5      JSR.W CODE_02D50C         
CODE_02C527:        A5 0E         LDA $0E                   
CODE_02C529:        10 10         BPL Return02C53B          
CODE_02C52B:        C9 D0         CMP.B #$D0                
CODE_02C52D:        B0 0C         BCS Return02C53B          
CODE_02C52F:        A9 C0         LDA.B #$C0                
CODE_02C531:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02C533:        FE 0E 16      INC.W $160E,X             
CODE_02C536:        A9 08         LDA.B #$08                ; \ Play sound effect 
CODE_02C538:        8D FC 1D      STA.W $1DFC               ; / 
Return02C53B:       60            RTS                       ; Return 

CODE_02C53C:        A9 06         LDA.B #$06                
CODE_02C53E:        9D 02 16      STA.W $1602,X             
CODE_02C541:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02C544:        29 04         AND.B #$04                ;  | 
CODE_02C546:        F0 0D         BEQ Return02C555          ; / 
CODE_02C548:        20 79 C5      JSR.W CODE_02C579         
CODE_02C54B:        20 56 C5      JSR.W CODE_02C556         
CODE_02C54E:        A9 08         LDA.B #$08                
CODE_02C550:        9D 40 15      STA.W $1540,X             
CODE_02C553:        F6 C2         INC RAM_SpriteState,X     
Return02C555:       60            RTS                       ; Return 

CODE_02C556:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02C559:        98            TYA                       
CODE_02C55A:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02C55D:        B9 39 C6      LDA.W DATA_02C639,Y       
CODE_02C560:        9D 1C 15      STA.W $151C,X             
Return02C563:       60            RTS                       ; Return 

CODE_02C564:        A9 03         LDA.B #$03                
CODE_02C566:        9D 02 16      STA.W $1602,X             
CODE_02C569:        BD 40 15      LDA.W $1540,X             
CODE_02C56C:        D0 0B         BNE CODE_02C579           
CODE_02C56E:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02C571:        29 04         AND.B #$04                ;  | 
CODE_02C573:        F0 08         BEQ Return02C57D          ; / 
CODE_02C575:        A9 05         LDA.B #$05                
CODE_02C577:        95 C2         STA RAM_SpriteState,X     
CODE_02C579:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_02C57B:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
Return02C57D:       60            RTS                       ; Return 


DATA_02C57E:                      .db $10,$F0

DATA_02C580:                      .db $20,$E0

CODE_02C582:        20 56 C5      JSR.W CODE_02C556         
CODE_02C585:        BD 40 15      LDA.W $1540,X             
CODE_02C588:        F0 78         BEQ CODE_02C602           
CODE_02C58A:        C9 01         CMP.B #$01                
CODE_02C58C:        D0 6E         BNE CODE_02C5FC           
CODE_02C58E:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02C590:        C9 93         CMP.B #$93                
CODE_02C592:        D0 13         BNE CODE_02C5A7           
CODE_02C594:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02C597:        B9 80 C5      LDA.W DATA_02C580,Y       
CODE_02C59A:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02C59C:        A9 B0         LDA.B #$B0                
CODE_02C59E:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02C5A0:        A9 06         LDA.B #$06                
CODE_02C5A2:        95 C2         STA RAM_SpriteState,X     
CODE_02C5A4:        4C 36 C5      JMP.W CODE_02C536         

CODE_02C5A7:        74 C2         STZ RAM_SpriteState,X     
CODE_02C5A9:        A9 50         LDA.B #$50                
CODE_02C5AB:        9D 40 15      STA.W $1540,X             
CODE_02C5AE:        A9 10         LDA.B #$10                ; \ Play sound effect 
CODE_02C5B0:        8D F9 1D      STA.W $1DF9               ; / 
CODE_02C5B3:        9C 5E 18      STZ.W $185E               
CODE_02C5B6:        20 BC C5      JSR.W CODE_02C5BC         
CODE_02C5B9:        EE 5E 18      INC.W $185E               
CODE_02C5BC:        22 E4 A9 02   JSL.L FindFreeSprSlot     
CODE_02C5C0:        30 3A         BMI CODE_02C5FC           
CODE_02C5C2:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02C5C4:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02C5C7:        A9 91         LDA.B #$91                
CODE_02C5C9:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_02C5CC:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02C5CE:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_02C5D1:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02C5D4:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_02C5D7:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02C5D9:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_02C5DC:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02C5DF:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_02C5E2:        DA            PHX                       
CODE_02C5E3:        BB            TYX                       
CODE_02C5E4:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02C5E8:        AE 5E 18      LDX.W $185E               
CODE_02C5EB:        BD 7E C5      LDA.W DATA_02C57E,X       
CODE_02C5EE:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_02C5F1:        FA            PLX                       
CODE_02C5F2:        A9 C8         LDA.B #$C8                
CODE_02C5F4:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_02C5F7:        A9 50         LDA.B #$50                
CODE_02C5F9:        99 40 15      STA.W $1540,Y             
CODE_02C5FC:        A9 09         LDA.B #$09                
CODE_02C5FE:        9D 02 16      STA.W $1602,X             
Return02C601:       60            RTS                       ; Return 

CODE_02C602:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02C605:        98            TYA                       
CODE_02C606:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02C609:        A5 0F         LDA $0F                   
CODE_02C60B:        18            CLC                       
CODE_02C60C:        69 50         ADC.B #$50                
CODE_02C60E:        C9 A0         CMP.B #$A0                
CODE_02C610:        B0 06         BCS CODE_02C618           
CODE_02C612:        A9 40         LDA.B #$40                
CODE_02C614:        9D 40 15      STA.W $1540,X             
Return02C617:       60            RTS                       ; Return 

CODE_02C618:        A9 03         LDA.B #$03                
CODE_02C61A:        9D 02 16      STA.W $1602,X             
CODE_02C61D:        A5 13         LDA RAM_FrameCounter      
CODE_02C61F:        29 3F         AND.B #$3F                
CODE_02C621:        D0 04         BNE Return02C627          
CODE_02C623:        A9 E0         LDA.B #$E0                
CODE_02C625:        95 AA         STA RAM_SpriteSpeedY,X    
Return02C627:       60            RTS                       ; Return 

CODE_02C628:        A9 08         LDA.B #$08                
CODE_02C62A:        9D AC 15      STA.W $15AC,X             
Return02C62D:       60            RTS                       ; Return 


DATA_02C62E:                      .db $00,$00,$00,$00,$01,$02,$03,$04
                                  .db $04,$04,$04

DATA_02C639:                      .db $00,$04

CODE_02C63B:        A9 03         LDA.B #$03                
CODE_02C63D:        9D 02 16      STA.W $1602,X             
CODE_02C640:        9E 7B 18      STZ.W $187B,X             
CODE_02C643:        BD 40 15      LDA.W $1540,X             
CODE_02C646:        29 0F         AND.B #$0F                
CODE_02C648:        D0 1E         BNE CODE_02C668           
CODE_02C64A:        20 0C D5      JSR.W CODE_02D50C         
CODE_02C64D:        A5 0E         LDA $0E                   
CODE_02C64F:        18            CLC                       
CODE_02C650:        69 28         ADC.B #$28                
CODE_02C652:        C9 50         CMP.B #$50                
CODE_02C654:        B0 12         BCS CODE_02C668           
CODE_02C656:        20 56 C5      JSR.W CODE_02C556         
CODE_02C659:        FE 7B 18      INC.W $187B,X             
CODE_02C65C:        A9 02         LDA.B #$02                
CODE_02C65E:        95 C2         STA RAM_SpriteState,X     
CODE_02C660:        A9 18         LDA.B #$18                
CODE_02C662:        9D 40 15      STA.W $1540,X             
Return02C665:       60            RTS                       ; Return 


DATA_02C666:                      .db $01,$FF

CODE_02C668:        BD 40 15      LDA.W $1540,X             
CODE_02C66B:        D0 0A         BNE CODE_02C677           
CODE_02C66D:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02C670:        49 01         EOR.B #$01                
CODE_02C672:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02C675:        80 E5         BRA CODE_02C65C           

CODE_02C677:        A5 14         LDA RAM_FrameCounterB     
CODE_02C679:        29 03         AND.B #$03                
CODE_02C67B:        D0 14         BNE CODE_02C691           
CODE_02C67D:        BD 34 15      LDA.W $1534,X             
CODE_02C680:        29 01         AND.B #$01                
CODE_02C682:        A8            TAY                       
CODE_02C683:        BD 94 15      LDA.W $1594,X             
CODE_02C686:        18            CLC                       
CODE_02C687:        79 66 C6      ADC.W DATA_02C666,Y       
CODE_02C68A:        C9 0B         CMP.B #$0B                
CODE_02C68C:        B0 0D         BCS CODE_02C69B           
CODE_02C68E:        9D 94 15      STA.W $1594,X             
CODE_02C691:        BC 94 15      LDY.W $1594,X             
CODE_02C694:        B9 2E C6      LDA.W DATA_02C62E,Y       
CODE_02C697:        9D 1C 15      STA.W $151C,X             
Return02C69A:       60            RTS                       ; Return 

CODE_02C69B:        FE 34 15      INC.W $1534,X             
Return02C69E:       60            RTS                       ; Return 


DATA_02C69F:                      .db $10,$F0,$18,$E8

DATA_02C6A3:                      .db $12,$13,$12,$13

CODE_02C6A7:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02C6AA:        29 04         AND.B #$04                ;  | 
CODE_02C6AC:        F0 0C         BEQ CODE_02C6BA           ; / 
CODE_02C6AE:        BD 3E 16      LDA.W $163E,X             
CODE_02C6B1:        C9 01         CMP.B #$01                
CODE_02C6B3:        80 05         BRA CODE_02C6BA           

ADDR_02C6B5:        A9 24         LDA.B #$24                ; \ Unreachable 
ADDR_02C6B7:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_02C6BA:        20 0C D5      JSR.W CODE_02D50C         
CODE_02C6BD:        A5 0E         LDA $0E                   
CODE_02C6BF:        18            CLC                       
CODE_02C6C0:        69 30         ADC.B #$30                
CODE_02C6C2:        C9 60         CMP.B #$60                
CODE_02C6C4:        B0 11         BCS CODE_02C6D7           
CODE_02C6C6:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02C6C9:        98            TYA                       
CODE_02C6CA:        DD 7C 15      CMP.W RAM_SpriteDir,X     
CODE_02C6CD:        D0 08         BNE CODE_02C6D7           
CODE_02C6CF:        A9 20         LDA.B #$20                
CODE_02C6D1:        9D 40 15      STA.W $1540,X             
CODE_02C6D4:        9D 7B 18      STA.W $187B,X             
CODE_02C6D7:        BD 40 15      LDA.W $1540,X             
CODE_02C6DA:        D0 10         BNE CODE_02C6EC           
CODE_02C6DC:        74 C2         STZ RAM_SpriteState,X     
CODE_02C6DE:        20 28 C6      JSR.W CODE_02C628         
CODE_02C6E1:        22 F9 AC 01   JSL.L GetRand             
CODE_02C6E5:        29 3F         AND.B #$3F                
CODE_02C6E7:        09 40         ORA.B #$40                
CODE_02C6E9:        9D 40 15      STA.W $1540,X             
CODE_02C6EC:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02C6EF:        B9 39 C6      LDA.W DATA_02C639,Y       
CODE_02C6F2:        9D 1C 15      STA.W $151C,X             
CODE_02C6F5:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02C6F8:        29 04         AND.B #$04                ;  | 
CODE_02C6FA:        F0 17         BEQ CODE_02C713           ; / 
CODE_02C6FC:        BD 7B 18      LDA.W $187B,X             
CODE_02C6FF:        F0 0D         BEQ CODE_02C70E           
CODE_02C701:        A5 14         LDA RAM_FrameCounterB     
CODE_02C703:        29 07         AND.B #$07                
CODE_02C705:        D0 05         BNE CODE_02C70C           
CODE_02C707:        A9 01         LDA.B #$01                ; \ Play sound effect 
CODE_02C709:        8D F9 1D      STA.W $1DF9               ; / 
CODE_02C70C:        C8            INY                       
CODE_02C70D:        C8            INY                       
CODE_02C70E:        B9 9F C6      LDA.W DATA_02C69F,Y       
CODE_02C711:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02C713:        A5 13         LDA RAM_FrameCounter      
CODE_02C715:        BC 7B 18      LDY.W $187B,X             
CODE_02C718:        D0 01         BNE CODE_02C71B           
CODE_02C71A:        4A            LSR                       
CODE_02C71B:        4A            LSR                       
CODE_02C71C:        29 03         AND.B #$03                
CODE_02C71E:        A8            TAY                       
CODE_02C71F:        B9 A3 C6      LDA.W DATA_02C6A3,Y       
CODE_02C722:        9D 02 16      STA.W $1602,X             
Return02C725:       60            RTS                       ; Return 

CODE_02C726:        A9 03         LDA.B #$03                
CODE_02C728:        9D 02 16      STA.W $1602,X             
CODE_02C72B:        BD 40 15      LDA.W $1540,X             
CODE_02C72E:        D0 0C         BNE Return02C73C          
CODE_02C730:        20 28 C6      JSR.W CODE_02C628         
CODE_02C733:        A9 01         LDA.B #$01                
CODE_02C735:        95 C2         STA RAM_SpriteState,X     
CODE_02C737:        A9 40         LDA.B #$40                
CODE_02C739:        9D 40 15      STA.W $1540,X             
Return02C73C:       60            RTS                       ; Return 


DATA_02C73D:                      .db $0A,$0B,$0A,$0C,$0D,$0C

DATA_02C743:                      .db $0C,$10,$10,$04,$08,$10,$18

CODE_02C74A:        BC 70 15      LDY.W $1570,X             
CODE_02C74D:        BD 40 15      LDA.W $1540,X             
CODE_02C750:        D0 0E         BNE CODE_02C760           
CODE_02C752:        FE 70 15      INC.W $1570,X             
CODE_02C755:        C8            INY                       
CODE_02C756:        C0 07         CPY.B #$07                
CODE_02C758:        F0 1D         BEQ CODE_02C777           
CODE_02C75A:        B9 43 C7      LDA.W DATA_02C743,Y       
CODE_02C75D:        9D 40 15      STA.W $1540,X             
CODE_02C760:        B9 3D C7      LDA.W DATA_02C73D,Y       
CODE_02C763:        9D 02 16      STA.W $1602,X             
CODE_02C766:        A9 02         LDA.B #$02                
CODE_02C768:        C0 05         CPY.B #$05                
CODE_02C76A:        D0 07         BNE CODE_02C773           
CODE_02C76C:        A5 14         LDA RAM_FrameCounterB     
CODE_02C76E:        4A            LSR                       
CODE_02C76F:        EA            NOP                       
CODE_02C770:        29 02         AND.B #$02                
CODE_02C772:        1A            INC A                     
CODE_02C773:        9D 1C 15      STA.W $151C,X             
Return02C776:       60            RTS                       ; Return 

CODE_02C777:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02C779:        C9 94         CMP.B #$94                
CODE_02C77B:        F0 17         BEQ CODE_02C794           
CODE_02C77D:        C9 46         CMP.B #$46                
CODE_02C77F:        D0 04         BNE CODE_02C785           
CODE_02C781:        A9 91         LDA.B #$91                
CODE_02C783:        95 9E         STA RAM_SpriteNum,X       
CODE_02C785:        A9 30         LDA.B #$30                
CODE_02C787:        9D 40 15      STA.W $1540,X             
CODE_02C78A:        A9 02         LDA.B #$02                
CODE_02C78C:        95 C2         STA RAM_SpriteState,X     
CODE_02C78E:        FE 7B 18      INC.W $187B,X             
CODE_02C791:        4C 56 C5      JMP.W CODE_02C556         

CODE_02C794:        A9 0C         LDA.B #$0C                
CODE_02C796:        95 C2         STA RAM_SpriteState,X     
Return02C798:       60            RTS                       ; Return 


DATA_02C799:                      .db $F0,$10

DATA_02C79B:                      .db $20,$E0

CODE_02C79D:        BD 64 15      LDA.W $1564,X             
CODE_02C7A0:        D0 6D         BNE Return02C80F          
CODE_02C7A2:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_02C7A6:        90 67         BCC Return02C80F          
CODE_02C7A8:        AD 90 14      LDA.W $1490               ; \ Branch if Mario doesn't have star 
CODE_02C7AB:        F0 17         BEQ CODE_02C7C4           ; / 
CODE_02C7AD:        A9 D0         LDA.B #$D0                
CODE_02C7AF:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02C7B1:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_02C7B3:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_02C7B5:        9D C8 14      STA.W $14C8,X             ; / 
CODE_02C7B8:        A9 03         LDA.B #$03                ; \ Play sound effect 
CODE_02C7BA:        8D F9 1D      STA.W $1DF9               ; / 
CODE_02C7BD:        A9 03         LDA.B #$03                
CODE_02C7BF:        22 E5 AC 02   JSL.L GivePoints          
Return02C7C3:       60            RTS                       ; Return 

CODE_02C7C4:        20 0C D5      JSR.W CODE_02D50C         
CODE_02C7C7:        A5 0E         LDA $0E                   
CODE_02C7C9:        C9 EC         CMP.B #$EC                
CODE_02C7CB:        10 43         BPL CODE_02C810           
CODE_02C7CD:        A9 05         LDA.B #$05                
CODE_02C7CF:        9D 64 15      STA.W $1564,X             
CODE_02C7D2:        A9 02         LDA.B #$02                ; \ Play sound effect 
CODE_02C7D4:        8D F9 1D      STA.W $1DF9               ; / 
CODE_02C7D7:        22 99 AB 01   JSL.L DisplayContactGfx   
CODE_02C7DB:        22 33 AA 01   JSL.L BoostMarioSpeed     
CODE_02C7DF:        9E 3E 16      STZ.W $163E,X             
CODE_02C7E2:        B5 C2         LDA RAM_SpriteState,X     
CODE_02C7E4:        C9 03         CMP.B #$03                
CODE_02C7E6:        F0 27         BEQ Return02C80F          
CODE_02C7E8:        FE 28 15      INC.W $1528,X             ; Increase Chuck stomp count 
CODE_02C7EB:        BD 28 15      LDA.W $1528,X             ; \ Kill Chuck if stomp count >= 3 
CODE_02C7EE:        C9 03         CMP.B #$03                ;  | 
CODE_02C7F0:        90 04         BCC CODE_02C7F6           ;  | 
CODE_02C7F2:        74 AA         STZ RAM_SpriteSpeedY,X    ;  | Sprite Y Speed = 0 
CODE_02C7F4:        80 BB         BRA CODE_02C7B1           ; / 

CODE_02C7F6:        A9 28         LDA.B #$28                ; \ Play sound effect 
CODE_02C7F8:        8D FC 1D      STA.W $1DFC               ; / 
CODE_02C7FB:        A9 03         LDA.B #$03                
CODE_02C7FD:        95 C2         STA RAM_SpriteState,X     
CODE_02C7FF:        A9 03         LDA.B #$03                
CODE_02C801:        9D 40 15      STA.W $1540,X             
CODE_02C804:        9E 70 15      STZ.W $1570,X             
CODE_02C807:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02C80A:        B9 9B C7      LDA.W DATA_02C79B,Y       
CODE_02C80D:        85 7B         STA RAM_MarioSpeedX       
Return02C80F:       60            RTS                       ; Return 

CODE_02C810:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_02C813:        D0 04         BNE Return02C819          
CODE_02C815:        22 B7 F5 00   JSL.L HurtMario           
Return02C819:       60            RTS                       ; Return 

CODE_02C81A:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02C81D:        20 8C C8      JSR.W CODE_02C88C         
CODE_02C820:        20 27 CA      JSR.W CODE_02CA27         
CODE_02C823:        20 9D CA      JSR.W CODE_02CA9D         
CODE_02C826:        20 A1 CB      JSR.W CODE_02CBA1         
CODE_02C829:        A0 FF         LDY.B #$FF                
CODE_02C82B:        A9 04         LDA.B #$04                
CODE_02C82D:        4C A7 B7      JMP.W CODE_02B7A7         


DATA_02C830:                      .db $F8,$F8,$F8,$00,$00,$FE,$00,$00
                                  .db $FA,$00,$00,$00,$00,$00,$00,$FD
                                  .db $FD,$F9,$F6,$F6,$F8,$FE,$FC,$FA
                                  .db $F8,$FA

DATA_02C84A:                      .db $F8,$F9,$F7,$F8,$FC,$F8,$F4,$F5
                                  .db $F5,$FC,$FD,$00,$F9,$F5,$F8,$FA
                                  .db $F6,$F6,$F4,$F4,$F8,$F6,$F6,$F8
                                  .db $F8,$F5

DATA_02C864:                      .db $08,$08,$08,$00,$00,$00,$08,$08
                                  .db $08,$00,$08,$08,$00,$00,$00,$00
                                  .db $00,$08,$10,$10,$0C,$0C,$0C,$0C
                                  .db $0C,$0C

ChuckHeadTiles:                   .db $06,$0A,$0E,$0A,$06,$4B,$4B

DATA_02C885:                      .db $40,$40,$00,$00,$00,$00,$40

CODE_02C88C:        64 07         STZ $07                   
CODE_02C88E:        BC 02 16      LDY.W $1602,X             
CODE_02C891:        84 04         STY $04                   
CODE_02C893:        C0 09         CPY.B #$09                
CODE_02C895:        18            CLC                       
CODE_02C896:        D0 13         BNE CODE_02C8AB           
CODE_02C898:        BD 40 15      LDA.W $1540,X             
CODE_02C89B:        38            SEC                       
CODE_02C89C:        E9 20         SBC.B #$20                
CODE_02C89E:        90 0B         BCC CODE_02C8AB           
CODE_02C8A0:        48            PHA                       
CODE_02C8A1:        4A            LSR                       
CODE_02C8A2:        4A            LSR                       
CODE_02C8A3:        4A            LSR                       
CODE_02C8A4:        4A            LSR                       
CODE_02C8A5:        4A            LSR                       
CODE_02C8A6:        85 07         STA $07                   
CODE_02C8A8:        68            PLA                       
CODE_02C8A9:        4A            LSR                       
CODE_02C8AA:        4A            LSR                       
CODE_02C8AB:        A5 00         LDA $00                   
CODE_02C8AD:        69 00         ADC.B #$00                
CODE_02C8AF:        85 00         STA $00                   
CODE_02C8B1:        BD 1C 15      LDA.W $151C,X             
CODE_02C8B4:        85 02         STA $02                   
CODE_02C8B6:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02C8B9:        85 03         STA $03                   
CODE_02C8BB:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_02C8BE:        05 64         ORA $64                   
CODE_02C8C0:        85 08         STA $08                   
CODE_02C8C2:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_02C8C5:        85 05         STA $05                   
CODE_02C8C7:        18            CLC                       
CODE_02C8C8:        79 64 C8      ADC.W DATA_02C864,Y       
CODE_02C8CB:        A8            TAY                       
CODE_02C8CC:        A6 04         LDX $04                   
CODE_02C8CE:        BD 30 C8      LDA.W DATA_02C830,X       
CODE_02C8D1:        A6 03         LDX $03                   
CODE_02C8D3:        D0 03         BNE CODE_02C8D8           
CODE_02C8D5:        49 FF         EOR.B #$FF                
CODE_02C8D7:        1A            INC A                     
CODE_02C8D8:        18            CLC                       
CODE_02C8D9:        65 00         ADC $00                   
CODE_02C8DB:        99 00 03      STA.W OAM_DispX,Y         
CODE_02C8DE:        A6 04         LDX $04                   
CODE_02C8E0:        A5 01         LDA $01                   
CODE_02C8E2:        18            CLC                       
CODE_02C8E3:        7D 4A C8      ADC.W DATA_02C84A,X       
CODE_02C8E6:        38            SEC                       
CODE_02C8E7:        E5 07         SBC $07                   
CODE_02C8E9:        99 01 03      STA.W OAM_DispY,Y         
CODE_02C8EC:        A6 02         LDX $02                   
CODE_02C8EE:        BD 85 C8      LDA.W DATA_02C885,X       
CODE_02C8F1:        05 08         ORA $08                   
CODE_02C8F3:        99 03 03      STA.W OAM_Prop,Y          
CODE_02C8F6:        BD 7E C8      LDA.W ChuckHeadTiles,X    
CODE_02C8F9:        99 02 03      STA.W OAM_Tile,Y          
CODE_02C8FC:        98            TYA                       
CODE_02C8FD:        4A            LSR                       
CODE_02C8FE:        4A            LSR                       
CODE_02C8FF:        A8            TAY                       
CODE_02C900:        A9 02         LDA.B #$02                
CODE_02C902:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02C905:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return02C908:       60            RTS                       ; Return 


DATA_02C909:                      .db $F8,$F8,$F8,$FC,$FC,$FC,$FC,$F8
                                  .db $01,$FC,$FC,$FC,$FC,$FC,$FC,$FC
                                  .db $FC,$F8,$F8,$F8,$F8,$08,$06,$F8
                                  .db $F8,$01,$10,$10,$10,$04,$04,$04
                                  .db $04,$08,$07,$04,$04,$04,$04,$04
                                  .db $04,$04,$04,$10,$08,$08,$10,$00
                                  .db $02,$10,$10,$07

DATA_02C93D:                      .db $00,$00,$00,$04,$04,$04,$04,$08
                                  .db $00,$04,$04,$04,$04,$04,$04,$04
                                  .db $04,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$FC,$FC,$FC
                                  .db $FC,$F8,$00,$FC,$FC,$FC,$FC,$FC
                                  .db $FC,$FC,$FC,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00

DATA_02C971:                      .db $06,$06,$06,$00,$00,$00,$00,$00
                                  .db $F8,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$03,$00,$00,$06,$F8,$F8,$00
                                  .db $00,$F8

ChuckBody1:                       .db $0D,$34,$35,$26,$2D,$28,$40,$42
                                  .db $5D,$2D,$64,$64,$64,$64,$E7,$28
                                  .db $82,$CB,$23,$20,$0D,$0C,$5D,$BD
                                  .db $BD,$5D

ChuckBody2:                       .db $4E,$0C,$22,$26,$2D,$29,$40,$42
                                  .db $AE,$2D,$64,$64,$64,$64,$E8,$29
                                  .db $83,$CC,$24,$21,$4E,$A0,$A0,$A2
                                  .db $A4,$AE

DATA_02C9BF:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$40,$00,$00
                                  .db $00,$00

DATA_02C9D9:                      .db $00,$00,$00,$40,$40,$00,$40,$40
                                  .db $00,$40,$40,$40,$40,$40,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00

DATA_02C9F3:                      .db $00,$00,$00,$02,$02,$02,$02,$02
                                  .db $00,$02,$02,$02,$02,$02,$02,$02
                                  .db $02,$00,$02,$02,$00,$00,$00,$00
                                  .db $00,$00

DATA_02CA0D:                      .db $00,$00,$00,$04,$04,$04,$0C,$0C
                                  .db $00,$08,$00,$00,$04,$04,$04,$04
                                  .db $04,$00,$08,$08,$00,$00,$00,$00
                                  .db $00,$00

CODE_02CA27:        64 06         STZ $06                   
CODE_02CA29:        A5 04         LDA $04                   
CODE_02CA2B:        A4 03         LDY $03                   
CODE_02CA2D:        D0 07         BNE CODE_02CA36           
CODE_02CA2F:        18            CLC                       
CODE_02CA30:        69 1A         ADC.B #$1A                
CODE_02CA32:        A2 40         LDX.B #$40                
CODE_02CA34:        86 06         STX $06                   
CODE_02CA36:        AA            TAX                       
CODE_02CA37:        A4 04         LDY $04                   
CODE_02CA39:        B9 0D CA      LDA.W DATA_02CA0D,Y       
CODE_02CA3C:        18            CLC                       
CODE_02CA3D:        65 05         ADC $05                   
CODE_02CA3F:        A8            TAY                       
CODE_02CA40:        A5 00         LDA $00                   
CODE_02CA42:        18            CLC                       
CODE_02CA43:        7D 09 C9      ADC.W DATA_02C909,X       
CODE_02CA46:        99 00 03      STA.W OAM_DispX,Y         
CODE_02CA49:        A5 00         LDA $00                   
CODE_02CA4B:        18            CLC                       
CODE_02CA4C:        7D 3D C9      ADC.W DATA_02C93D,X       
CODE_02CA4F:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_02CA52:        A6 04         LDX $04                   
CODE_02CA54:        A5 01         LDA $01                   
CODE_02CA56:        18            CLC                       
CODE_02CA57:        7D 71 C9      ADC.W DATA_02C971,X       
CODE_02CA5A:        99 01 03      STA.W OAM_DispY,Y         
CODE_02CA5D:        A5 01         LDA $01                   
CODE_02CA5F:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_02CA62:        BD 8B C9      LDA.W ChuckBody1,X        
CODE_02CA65:        99 02 03      STA.W OAM_Tile,Y          
CODE_02CA68:        BD A5 C9      LDA.W ChuckBody2,X        
CODE_02CA6B:        99 06 03      STA.W OAM_Tile2,Y         
CODE_02CA6E:        A5 08         LDA $08                   
CODE_02CA70:        05 06         ORA $06                   
CODE_02CA72:        48            PHA                       
CODE_02CA73:        5D BF C9      EOR.W DATA_02C9BF,X       
CODE_02CA76:        99 03 03      STA.W OAM_Prop,Y          
CODE_02CA79:        68            PLA                       
CODE_02CA7A:        5D D9 C9      EOR.W DATA_02C9D9,X       
CODE_02CA7D:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02CA80:        98            TYA                       
CODE_02CA81:        4A            LSR                       
CODE_02CA82:        4A            LSR                       
CODE_02CA83:        A8            TAY                       
CODE_02CA84:        BD F3 C9      LDA.W DATA_02C9F3,X       
CODE_02CA87:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02CA8A:        A9 02         LDA.B #$02                
CODE_02CA8C:        99 61 04      STA.W $0461,Y             
CODE_02CA8F:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return02CA92:       60            RTS                       ; Return 


DATA_02CA93:                      .db $FA,$00

DATA_02CA95:                      .db $0E,$00

ClappinChuckTiles:                .db $0C,$44

DATA_02CA99:                      .db $F8,$F0

DATA_02CA9B:                      .db $00,$02

CODE_02CA9D:        A5 04         LDA $04                   
CODE_02CA9F:        C9 14         CMP.B #$14                
CODE_02CAA1:        90 03         BCC CODE_02CAA6           
CODE_02CAA3:        4C 53 CB      JMP.W CODE_02CB53         

CODE_02CAA6:        C9 12         CMP.B #$12                
CODE_02CAA8:        F0 52         BEQ CODE_02CAFC           
CODE_02CAAA:        C9 13         CMP.B #$13                
CODE_02CAAC:        F0 4E         BEQ CODE_02CAFC           
CODE_02CAAE:        38            SEC                       
CODE_02CAAF:        E9 06         SBC.B #$06                
CODE_02CAB1:        C9 02         CMP.B #$02                
CODE_02CAB3:        B0 44         BCS Return02CAF9          
CODE_02CAB5:        AA            TAX                       
CODE_02CAB6:        A4 05         LDY $05                   
CODE_02CAB8:        A5 00         LDA $00                   
CODE_02CABA:        18            CLC                       
CODE_02CABB:        7D 93 CA      ADC.W DATA_02CA93,X       
CODE_02CABE:        99 00 03      STA.W OAM_DispX,Y         
CODE_02CAC1:        A5 00         LDA $00                   
CODE_02CAC3:        18            CLC                       
CODE_02CAC4:        7D 95 CA      ADC.W DATA_02CA95,X       
CODE_02CAC7:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_02CACA:        A5 01         LDA $01                   
CODE_02CACC:        18            CLC                       
CODE_02CACD:        7D 99 CA      ADC.W DATA_02CA99,X       
CODE_02CAD0:        99 01 03      STA.W OAM_DispY,Y         
CODE_02CAD3:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_02CAD6:        BD 97 CA      LDA.W ClappinChuckTiles,X 
CODE_02CAD9:        99 02 03      STA.W OAM_Tile,Y          
CODE_02CADC:        99 06 03      STA.W OAM_Tile2,Y         
CODE_02CADF:        A5 08         LDA $08                   
CODE_02CAE1:        99 03 03      STA.W OAM_Prop,Y          
CODE_02CAE4:        09 40         ORA.B #$40                
CODE_02CAE6:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02CAE9:        98            TYA                       
CODE_02CAEA:        4A            LSR                       
CODE_02CAEB:        4A            LSR                       
CODE_02CAEC:        A8            TAY                       
CODE_02CAED:        BD 9B CA      LDA.W DATA_02CA9B,X       
CODE_02CAF0:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02CAF3:        99 61 04      STA.W $0461,Y             
CODE_02CAF6:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return02CAF9:       60            RTS                       ; Return 


ChuckGfxProp:                     .db $47,$07

CODE_02CAFC:        A4 05         LDY $05                   
CODE_02CAFE:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02CB01:        DA            PHX                       
CODE_02CB02:        AA            TAX                       
CODE_02CB03:        0A            ASL                       
CODE_02CB04:        0A            ASL                       
CODE_02CB05:        0A            ASL                       
CODE_02CB06:        48            PHA                       
CODE_02CB07:        49 08         EOR.B #$08                
CODE_02CB09:        18            CLC                       
CODE_02CB0A:        65 00         ADC $00                   
CODE_02CB0C:        99 00 03      STA.W OAM_DispX,Y         
CODE_02CB0F:        68            PLA                       
CODE_02CB10:        18            CLC                       
CODE_02CB11:        65 00         ADC $00                   
CODE_02CB13:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_02CB16:        A9 1C         LDA.B #$1C                
CODE_02CB18:        99 02 03      STA.W OAM_Tile,Y          
CODE_02CB1B:        1A            INC A                     
CODE_02CB1C:        99 06 03      STA.W OAM_Tile2,Y         
CODE_02CB1F:        A5 01         LDA $01                   
CODE_02CB21:        38            SEC                       
CODE_02CB22:        E9 08         SBC.B #$08                
CODE_02CB24:        99 01 03      STA.W OAM_DispY,Y         
CODE_02CB27:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_02CB2A:        BD FA CA      LDA.W ChuckGfxProp,X      
CODE_02CB2D:        05 64         ORA $64                   
CODE_02CB2F:        99 03 03      STA.W OAM_Prop,Y          
CODE_02CB32:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02CB35:        98            TYA                       
CODE_02CB36:        4A            LSR                       
CODE_02CB37:        4A            LSR                       
CODE_02CB38:        AA            TAX                       
CODE_02CB39:        9E 60 04      STZ.W OAM_TileSize,X      
CODE_02CB3C:        9E 61 04      STZ.W $0461,X             
CODE_02CB3F:        FA            PLX                       
Return02CB40:       60            RTS                       ; Return 


DATA_02CB41:                      .db $FA,$0A,$06,$00,$00,$01,$0E,$FE
                                  .db $02,$00,$00,$09,$08,$F4,$F4,$00
                                  .db $00,$F4

CODE_02CB53:        DA            PHX                       
CODE_02CB54:        85 02         STA $02                   
CODE_02CB56:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02CB59:        D0 03         BNE CODE_02CB5E           
CODE_02CB5B:        18            CLC                       
CODE_02CB5C:        69 06         ADC.B #$06                
CODE_02CB5E:        AA            TAX                       
CODE_02CB5F:        A5 05         LDA $05                   
CODE_02CB61:        18            CLC                       
CODE_02CB62:        69 08         ADC.B #$08                
CODE_02CB64:        A8            TAY                       
CODE_02CB65:        A5 00         LDA $00                   
CODE_02CB67:        18            CLC                       
CODE_02CB68:        7D 2D CB      ADC.W CODE_02CB2D,X       
CODE_02CB6B:        99 00 03      STA.W OAM_DispX,Y         
CODE_02CB6E:        A6 02         LDX $02                   
CODE_02CB70:        BD 39 CB      LDA.W CODE_02CB39,X       
CODE_02CB73:        F0 19         BEQ CODE_02CB8E           
CODE_02CB75:        18            CLC                       
CODE_02CB76:        65 01         ADC $01                   
CODE_02CB78:        99 01 03      STA.W OAM_DispY,Y         
CODE_02CB7B:        A9 AD         LDA.B #$AD                
CODE_02CB7D:        99 02 03      STA.W OAM_Tile,Y          
CODE_02CB80:        A9 09         LDA.B #$09                
CODE_02CB82:        05 64         ORA $64                   
CODE_02CB84:        99 03 03      STA.W OAM_Prop,Y          
CODE_02CB87:        98            TYA                       
CODE_02CB88:        4A            LSR                       
CODE_02CB89:        4A            LSR                       
CODE_02CB8A:        AA            TAX                       
CODE_02CB8B:        9E 60 04      STZ.W OAM_TileSize,X      
CODE_02CB8E:        FA            PLX                       
Return02CB8F:       60            RTS                       ; Return 


DigChuckTileDispX:                .db $FC,$04,$10,$F0,$12,$EE

DigChuckTileProp:                 .db $47,$07

DigChuckTileDispY:                .db $F8,$00,$F8

DigChuckTiles:                    .db $CA,$E2,$A0

DigChuckTileSize:                 .db $00,$02,$02

CODE_02CBA1:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02CBA3:        C9 46         CMP.B #$46                
CODE_02CBA5:        D0 54         BNE Return02CBFB          
CODE_02CBA7:        BD 02 16      LDA.W $1602,X             
CODE_02CBAA:        C9 05         CMP.B #$05                
CODE_02CBAC:        D0 04         BNE CODE_02CBB2           
CODE_02CBAE:        A9 01         LDA.B #$01                
CODE_02CBB0:        80 07         BRA CODE_02CBB9           

CODE_02CBB2:        C9 0E         CMP.B #$0E                
CODE_02CBB4:        90 45         BCC Return02CBFB          
CODE_02CBB6:        38            SEC                       
CODE_02CBB7:        E9 0E         SBC.B #$0E                
CODE_02CBB9:        85 02         STA $02                   
CODE_02CBBB:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_02CBBE:        18            CLC                       
CODE_02CBBF:        69 0C         ADC.B #$0C                
CODE_02CBC1:        A8            TAY                       
CODE_02CBC2:        DA            PHX                       
CODE_02CBC3:        A5 02         LDA $02                   
CODE_02CBC5:        0A            ASL                       
CODE_02CBC6:        1D 7C 15      ORA.W RAM_SpriteDir,X     
CODE_02CBC9:        AA            TAX                       
CODE_02CBCA:        A5 00         LDA $00                   
CODE_02CBCC:        18            CLC                       
CODE_02CBCD:        7D 90 CB      ADC.W DigChuckTileDispX,X 
CODE_02CBD0:        99 00 03      STA.W OAM_DispX,Y         
CODE_02CBD3:        8A            TXA                       
CODE_02CBD4:        29 01         AND.B #$01                
CODE_02CBD6:        AA            TAX                       
CODE_02CBD7:        BD 96 CB      LDA.W DigChuckTileProp,X  
CODE_02CBDA:        05 64         ORA $64                   
CODE_02CBDC:        99 03 03      STA.W OAM_Prop,Y          
CODE_02CBDF:        A6 02         LDX $02                   
CODE_02CBE1:        A5 01         LDA $01                   
CODE_02CBE3:        18            CLC                       
CODE_02CBE4:        7D 98 CB      ADC.W DigChuckTileDispY,X 
CODE_02CBE7:        99 01 03      STA.W OAM_DispY,Y         
CODE_02CBEA:        BD 9B CB      LDA.W DigChuckTiles,X     
CODE_02CBED:        99 02 03      STA.W OAM_Tile,Y          
CODE_02CBF0:        98            TYA                       
CODE_02CBF1:        4A            LSR                       
CODE_02CBF2:        4A            LSR                       
CODE_02CBF3:        A8            TAY                       
CODE_02CBF4:        BD 9E CB      LDA.W DigChuckTileSize,X  
CODE_02CBF7:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02CBFA:        FA            PLX                       
Return02CBFB:       60            RTS                       ; Return 

Return02CBFC:       60            RTS                       ; Return 

Return02CBFD:       6B            RTL                       ; Return 

WingedCageMain:     A5 9D         LDA RAM_SpritesLocked     ; \ If sprites not locked, 
ADDR_02CC00:        D0 03         BNE ADDR_02CC05           ;  | increment sprite frame counter 
ADDR_02CC02:        FE 70 15      INC.W $1570,X             ; / 
ADDR_02CC05:        20 B9 CC      JSR.W ADDR_02CCB9         
ADDR_02CC08:        DA            PHX                       
ADDR_02CC09:        22 32 FF 00   JSL.L ADDR_00FF32         
ADDR_02CC0D:        FA            PLX                       
ADDR_02CC0E:        B5 E4         LDA RAM_SpriteXLo,X       
ADDR_02CC10:        18            CLC                       
ADDR_02CC11:        6D BD 17      ADC.W $17BD               
ADDR_02CC14:        95 E4         STA RAM_SpriteXLo,X       
ADDR_02CC16:        BD E0 14      LDA.W RAM_SpriteXHi,X     
ADDR_02CC19:        69 00         ADC.B #$00                
ADDR_02CC1B:        9D E0 14      STA.W RAM_SpriteXHi,X     
ADDR_02CC1E:        A5 71         LDA RAM_MarioAnimation    ; \ Return if Mario animation sequence active 
ADDR_02CC20:        C9 01         CMP.B #$01                ;  | 
ADDR_02CC22:        B0 D9         BCS Return02CBFD          ; / 
ADDR_02CC24:        AD B5 18      LDA.W $18B5               
ADDR_02CC27:        F0 04         BEQ ADDR_02CC2D           
ADDR_02CC29:        22 07 FF 00   JSL.L ADDR_00FF07         
ADDR_02CC2D:        A0 00         LDY.B #$00                
ADDR_02CC2F:        AD BC 17      LDA.W $17BC               
ADDR_02CC32:        10 01         BPL ADDR_02CC35           
ADDR_02CC34:        88            DEY                       
ADDR_02CC35:        18            CLC                       
ADDR_02CC36:        75 D8         ADC RAM_SpriteYLo,X       
ADDR_02CC38:        95 D8         STA RAM_SpriteYLo,X       
ADDR_02CC3A:        98            TYA                       
ADDR_02CC3B:        7D D4 14      ADC.W RAM_SpriteYHi,X     
ADDR_02CC3E:        9D D4 14      STA.W RAM_SpriteYHi,X     
ADDR_02CC41:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $00 = Sprite X position 
ADDR_02CC43:        85 00         STA $00                   ;  | 
ADDR_02CC45:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
ADDR_02CC48:        85 01         STA $01                   ; / 
ADDR_02CC4A:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $02 = Sprite Y position 
ADDR_02CC4C:        85 02         STA $02                   ;  | 
ADDR_02CC4E:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
ADDR_02CC51:        85 03         STA $03                   ; / 
ADDR_02CC53:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_02CC55:        A5 00         LDA $00                   
ADDR_02CC57:        A4 7B         LDY RAM_MarioSpeedX       
ADDR_02CC59:        88            DEY                       
ADDR_02CC5A:        10 10         BPL ADDR_02CC6C           
ADDR_02CC5C:        18            CLC                       
ADDR_02CC5D:        69 00 00      ADC.W #$0000              
ADDR_02CC60:        C5 94         CMP RAM_MarioXPos         
ADDR_02CC62:        90 1B         BCC ADDR_02CC7F           
ADDR_02CC64:        85 94         STA RAM_MarioXPos         
ADDR_02CC66:        A0 00         LDY.B #$00                ; \ Mario's X speed = 0 
ADDR_02CC68:        84 7B         STY RAM_MarioSpeedX       ; / 
ADDR_02CC6A:        80 13         BRA ADDR_02CC7F           

ADDR_02CC6C:        18            CLC                       
ADDR_02CC6D:        69 90 00      ADC.W #$0090              
ADDR_02CC70:        C5 94         CMP RAM_MarioXPos         
ADDR_02CC72:        B0 0B         BCS ADDR_02CC7F           
ADDR_02CC74:        A5 00         LDA $00                   
ADDR_02CC76:        69 91 00      ADC.W #$0091              
ADDR_02CC79:        85 94         STA RAM_MarioXPos         
ADDR_02CC7B:        A0 00         LDY.B #$00                
ADDR_02CC7D:        84 7B         STY RAM_MarioSpeedX       
ADDR_02CC7F:        A5 02         LDA $02                   
ADDR_02CC81:        A4 7D         LDY RAM_MarioSpeedY       
ADDR_02CC83:        10 0E         BPL ADDR_02CC93           
ADDR_02CC85:        18            CLC                       
ADDR_02CC86:        69 20 00      ADC.W #$0020              
ADDR_02CC89:        C5 96         CMP RAM_MarioYPos         
ADDR_02CC8B:        90 21         BCC ADDR_02CCAE           
ADDR_02CC8D:        A0 00         LDY.B #$00                
ADDR_02CC8F:        84 7D         STY RAM_MarioSpeedY       
ADDR_02CC91:        80 1B         BRA ADDR_02CCAE           

ADDR_02CC93:        18            CLC                       
ADDR_02CC94:        69 60 00      ADC.W #$0060              
ADDR_02CC97:        C5 96         CMP RAM_MarioYPos         
ADDR_02CC99:        B0 13         BCS ADDR_02CCAE           
ADDR_02CC9B:        A5 02         LDA $02                   
ADDR_02CC9D:        69 61 00      ADC.W #$0061              
ADDR_02CCA0:        85 96         STA RAM_MarioYPos         
ADDR_02CCA2:        A0 00         LDY.B #$00                
ADDR_02CCA4:        84 7D         STY RAM_MarioSpeedY       
ADDR_02CCA6:        A0 01         LDY.B #$01                
ADDR_02CCA8:        8C 71 14      STY.W $1471               
ADDR_02CCAB:        8C B5 18      STY.W $18B5               
ADDR_02CCAE:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return02CCB0:       6B            RTL                       ; Return 


CageWingTileDispX:                .db $00,$30,$60,$90

CageWingTileDispY:                .db $F8,$00,$F8,$00

ADDR_02CCB9:        A9 03         LDA.B #$03                
ADDR_02CCBB:        85 08         STA $08                   
ADDR_02CCBD:        B5 E4         LDA RAM_SpriteXLo,X       
ADDR_02CCBF:        38            SEC                       
ADDR_02CCC0:        E5 1A         SBC RAM_ScreenBndryXLo    
ADDR_02CCC2:        85 00         STA $00                   
ADDR_02CCC4:        B5 D8         LDA RAM_SpriteYLo,X       
ADDR_02CCC6:        38            SEC                       
ADDR_02CCC7:        E5 1C         SBC RAM_ScreenBndryYLo    
ADDR_02CCC9:        85 01         STA $01                   
ADDR_02CCCB:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
ADDR_02CCCE:        84 02         STY $02                   
ADDR_02CCD0:        A4 02         LDY $02                   
ADDR_02CCD2:        A6 08         LDX $08                   
ADDR_02CCD4:        A5 00         LDA $00                   
ADDR_02CCD6:        18            CLC                       
ADDR_02CCD7:        7D B1 CC      ADC.W CageWingTileDispX,X 
ADDR_02CCDA:        99 00 03      STA.W OAM_DispX,Y         
ADDR_02CCDD:        99 04 03      STA.W OAM_Tile2DispX,Y    
ADDR_02CCE0:        A5 01         LDA $01                   
ADDR_02CCE2:        18            CLC                       
ADDR_02CCE3:        7D B5 CC      ADC.W CageWingTileDispY,X 
ADDR_02CCE6:        99 01 03      STA.W OAM_DispY,Y         
ADDR_02CCE9:        18            CLC                       
ADDR_02CCEA:        69 08         ADC.B #$08                
ADDR_02CCEC:        99 05 03      STA.W OAM_Tile2DispY,Y    
ADDR_02CCEF:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
ADDR_02CCF2:        BD 70 15      LDA.W $1570,X             
ADDR_02CCF5:        4A            LSR                       
ADDR_02CCF6:        4A            LSR                       
ADDR_02CCF7:        4A            LSR                       
ADDR_02CCF8:        45 08         EOR $08                   
ADDR_02CCFA:        4A            LSR                       
ADDR_02CCFB:        A9 C6         LDA.B #$C6                
ADDR_02CCFD:        90 02         BCC ADDR_02CD01           
ADDR_02CCFF:        A9 81         LDA.B #$81                
ADDR_02CD01:        99 02 03      STA.W OAM_Tile,Y          
ADDR_02CD04:        A9 D6         LDA.B #$D6                
ADDR_02CD06:        90 02         BCC ADDR_02CD0A           
ADDR_02CD08:        A9 D7         LDA.B #$D7                
ADDR_02CD0A:        99 06 03      STA.W OAM_Tile2,Y         
ADDR_02CD0D:        A9 70         LDA.B #$70                
ADDR_02CD0F:        99 03 03      STA.W OAM_Prop,Y          
ADDR_02CD12:        99 07 03      STA.W OAM_Tile2Prop,Y     
ADDR_02CD15:        98            TYA                       
ADDR_02CD16:        4A            LSR                       
ADDR_02CD17:        4A            LSR                       
ADDR_02CD18:        A8            TAY                       
ADDR_02CD19:        A9 00         LDA.B #$00                
ADDR_02CD1B:        99 60 04      STA.W OAM_TileSize,Y      
ADDR_02CD1E:        99 61 04      STA.W $0461,Y             
ADDR_02CD21:        A5 02         LDA $02                   
ADDR_02CD23:        18            CLC                       
ADDR_02CD24:        69 08         ADC.B #$08                
ADDR_02CD26:        85 02         STA $02                   
ADDR_02CD28:        C6 08         DEC $08                   
ADDR_02CD2A:        10 A4         BPL ADDR_02CCD0           
Return02CD2C:       60            RTS                       ; Return 

CODE_02CD2D:        8B            PHB                       ; Wrapper 
CODE_02CD2E:        4B            PHK                       
CODE_02CD2F:        AB            PLB                       
CODE_02CD30:        20 59 CD      JSR.W CODE_02CD59         
CODE_02CD33:        AB            PLB                       
Return02CD34:       6B            RTL                       ; Return 


DATA_02CD35:                      .db $00,$08,$10,$18,$00,$08,$10,$18
DATA_02CD3D:                      .db $00,$00,$00,$00,$08,$08,$08,$08
DATA_02CD45:                      .db $00,$01,$01,$00,$10,$11,$11,$10
DATA_02CD4D:                      .db $31,$31,$71,$71,$31,$31,$71,$71
DATA_02CD55:                      .db $0A,$04,$06,$08

CODE_02CD59:        BD 40 15      LDA.W $1540,X             
CODE_02CD5C:        C9 5E         CMP.B #$5E                
CODE_02CD5E:        D0 1F         BNE CODE_02CD7F           
CODE_02CD60:        A9 1B         LDA.B #$1B                ; \ Block to generate = #$1B 
CODE_02CD62:        85 9C         STA RAM_BlockBlock        ; / 
CODE_02CD64:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02CD66:        85 9A         STA RAM_BlockYLo          
CODE_02CD68:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02CD6B:        85 9B         STA RAM_BlockYHi          
CODE_02CD6D:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02CD6F:        38            SEC                       
CODE_02CD70:        E9 10         SBC.B #$10                
CODE_02CD72:        85 98         STA RAM_BlockXLo          
CODE_02CD74:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02CD77:        E9 00         SBC.B #$00                
CODE_02CD79:        85 99         STA RAM_BlockXHi          
CODE_02CD7B:        22 B0 BE 00   JSL.L GenerateTile        
CODE_02CD7F:        22 4F B4 01   JSL.L InvisBlkMainRt      
CODE_02CD83:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02CD86:        DA            PHX                       
CODE_02CD87:        AE 1E 19      LDX.W $191E               
CODE_02CD8A:        BD 55 CD      LDA.W DATA_02CD55,X       
CODE_02CD8D:        85 02         STA $02                   
CODE_02CD8F:        A2 07         LDX.B #$07                
CODE_02CD91:        A5 00         LDA $00                   
CODE_02CD93:        18            CLC                       
CODE_02CD94:        7D 35 CD      ADC.W DATA_02CD35,X       
CODE_02CD97:        99 00 03      STA.W OAM_DispX,Y         
CODE_02CD9A:        A5 01         LDA $01                   
CODE_02CD9C:        18            CLC                       
CODE_02CD9D:        7D 3D CD      ADC.W DATA_02CD3D,X       
CODE_02CDA0:        99 01 03      STA.W OAM_DispY,Y         
CODE_02CDA3:        BD 45 CD      LDA.W DATA_02CD45,X       
CODE_02CDA6:        99 02 03      STA.W OAM_Tile,Y          
CODE_02CDA9:        BD 4D CD      LDA.W DATA_02CD4D,X       
CODE_02CDAC:        E0 04         CPX.B #$04                
CODE_02CDAE:        B0 02         BCS CODE_02CDB2           
CODE_02CDB0:        05 02         ORA $02                   
CODE_02CDB2:        99 03 03      STA.W OAM_Prop,Y          
CODE_02CDB5:        C8            INY                       
CODE_02CDB6:        C8            INY                       
CODE_02CDB7:        C8            INY                       
CODE_02CDB8:        C8            INY                       
CODE_02CDB9:        CA            DEX                       
CODE_02CDBA:        10 D5         BPL CODE_02CD91           
CODE_02CDBC:        FA            PLX                       
CODE_02CDBD:        A0 00         LDY.B #$00                
CODE_02CDBF:        A9 07         LDA.B #$07                
CODE_02CDC1:        4C A7 B7      JMP.W CODE_02B7A7         

Return02CDC4:       60            RTS                       ; Return 


DATA_02CDC5:                      .db $00,$07,$F9,$00,$01,$FF

PeaBouncerMain:     20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02CDCE:        20 E0 CE      JSR.W CODE_02CEE0         
CODE_02CDD1:        A5 9D         LDA RAM_SpritesLocked     
CODE_02CDD3:        D0 29         BNE Return02CDFE          
CODE_02CDD5:        BD 34 15      LDA.W $1534,X             
CODE_02CDD8:        F0 17         BEQ CODE_02CDF1           
CODE_02CDDA:        DE 34 15      DEC.W $1534,X             
CODE_02CDDD:        24 15         BIT RAM_ControllerA       
CODE_02CDDF:        10 10         BPL CODE_02CDF1           
CODE_02CDE1:        9E 34 15      STZ.W $1534,X             
CODE_02CDE4:        BC 1C 15      LDY.W $151C,X             
CODE_02CDE7:        B9 FF CD      LDA.W DATA_02CDFF,Y       
CODE_02CDEA:        85 7D         STA RAM_MarioSpeedY       
CODE_02CDEC:        A9 08         LDA.B #$08                ; \ Play sound effect 
CODE_02CDEE:        8D FC 1D      STA.W $1DFC               ; / 
CODE_02CDF1:        BD 28 15      LDA.W $1528,X             
CODE_02CDF4:        22 DF 86 00   JSL.L ExecutePtr          

PeaBouncerPtrs:        FE CD      .dw Return02CDFE          
                       0F CE      .dw CODE_02CE0F           
                       3A CE      .dw CODE_02CE3A           

Return02CDFE:       6B            RTL                       ; Return 


DATA_02CDFF:                      .db $B6,$B4,$B0,$A8,$A0,$98,$90,$88
DATA_02CE07:                      .db $00,$00,$E8,$E0,$D0,$C8,$C0,$B8

CODE_02CE0F:        BD 40 15      LDA.W $1540,X             
CODE_02CE12:        F0 0C         BEQ CODE_02CE20           
CODE_02CE14:        3A            DEC A                     
CODE_02CE15:        D0 08         BNE Return02CE1F          
CODE_02CE17:        FE 28 15      INC.W $1528,X             
CODE_02CE1A:        A9 01         LDA.B #$01                
CODE_02CE1C:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return02CE1F:       6B            RTL                       ; Return 

CODE_02CE20:        B5 C2         LDA RAM_SpriteState,X     
CODE_02CE22:        30 05         BMI CODE_02CE29           
CODE_02CE24:        DD 1C 15      CMP.W $151C,X             
CODE_02CE27:        B0 06         BCS CODE_02CE2F           
CODE_02CE29:        18            CLC                       
CODE_02CE2A:        69 01         ADC.B #$01                
CODE_02CE2C:        95 C2         STA RAM_SpriteState,X     
Return02CE2E:       6B            RTL                       ; Return 

CODE_02CE2F:        BD 1C 15      LDA.W $151C,X             
CODE_02CE32:        95 C2         STA RAM_SpriteState,X     
CODE_02CE34:        A9 08         LDA.B #$08                
CODE_02CE36:        9D 40 15      STA.W $1540,X             
Return02CE39:       6B            RTL                       ; Return 

CODE_02CE3A:        FE 70 15      INC.W $1570,X             
CODE_02CE3D:        BD 70 15      LDA.W $1570,X             
CODE_02CE40:        29 03         AND.B #$03                
CODE_02CE42:        D0 05         BNE CODE_02CE49           
CODE_02CE44:        DE 1C 15      DEC.W $151C,X             
CODE_02CE47:        F0 3D         BEQ CODE_02CE86           
CODE_02CE49:        BD 1C 15      LDA.W $151C,X             
CODE_02CE4C:        49 FF         EOR.B #$FF                
CODE_02CE4E:        1A            INC A                     
CODE_02CE4F:        85 00         STA $00                   
CODE_02CE51:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02CE54:        29 01         AND.B #$01                
CODE_02CE56:        D0 18         BNE CODE_02CE70           
CODE_02CE58:        B5 C2         LDA RAM_SpriteState,X     
CODE_02CE5A:        18            CLC                       
CODE_02CE5B:        69 04         ADC.B #$04                
CODE_02CE5D:        95 C2         STA RAM_SpriteState,X     
CODE_02CE5F:        30 05         BMI Return02CE66          
CODE_02CE61:        DD 1C 15      CMP.W $151C,X             
CODE_02CE64:        B0 01         BCS CODE_02CE67           
Return02CE66:       6B            RTL                       ; Return 

CODE_02CE67:        BD 1C 15      LDA.W $151C,X             
CODE_02CE6A:        95 C2         STA RAM_SpriteState,X     
CODE_02CE6C:        FE 7C 15      INC.W RAM_SpriteDir,X     
Return02CE6F:       6B            RTL                       ; Return 

CODE_02CE70:        B5 C2         LDA RAM_SpriteState,X     
CODE_02CE72:        38            SEC                       
CODE_02CE73:        E9 04         SBC.B #$04                
CODE_02CE75:        95 C2         STA RAM_SpriteState,X     
CODE_02CE77:        10 04         BPL Return02CE7D          
CODE_02CE79:        C5 00         CMP $00                   
CODE_02CE7B:        90 01         BCC CODE_02CE7E           
Return02CE7D:       6B            RTL                       ; Return 

CODE_02CE7E:        A5 00         LDA $00                   
CODE_02CE80:        95 C2         STA RAM_SpriteState,X     
CODE_02CE82:        FE 7C 15      INC.W RAM_SpriteDir,X     
Return02CE85:       6B            RTL                       ; Return 

CODE_02CE86:        74 C2         STZ RAM_SpriteState,X     
CODE_02CE88:        9E 28 15      STZ.W $1528,X             
Return02CE8B:       6B            RTL                       ; Return 

ADDR_02CE8C:        20 E0 CE      JSR.W CODE_02CEE0         ; \ Unreachable 
Return02CE8F:       6B            RTL                       ; / Wrapper for Pea Bouncer gfx routine 


DATA_02CE90:                      .db $00,$08,$10,$18,$20,$00,$08,$10
                                  .db $18,$20,$00,$08,$10,$18,$20,$00
                                  .db $08,$10,$18,$1F,$00,$08,$10,$17
                                  .db $1E,$00,$08,$0F,$16,$1D,$00,$07
                                  .db $0F,$16,$1C,$00,$07,$0E,$15,$1B
DATA_02CEB8:                      .db $00,$00,$00,$00,$00,$00,$01,$01
                                  .db $01,$02,$00,$00,$01,$02,$04,$00
                                  .db $01,$02,$04,$06,$00,$01,$03,$06
                                  .db $08,$00,$02,$04,$08,$0A,$00,$02
                                  .db $05,$07,$0C,$00,$02,$05,$09,$0E

CODE_02CEE0:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02CEE3:        A9 04         LDA.B #$04                
CODE_02CEE5:        85 02         STA $02                   
CODE_02CEE7:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02CEE9:        38            SEC                       
CODE_02CEEA:        E9 6B         SBC.B #$6B                
CODE_02CEEC:        85 05         STA $05                   
CODE_02CEEE:        B5 C2         LDA RAM_SpriteState,X     
CODE_02CEF0:        85 03         STA $03                   
CODE_02CEF2:        10 03         BPL CODE_02CEF7           
CODE_02CEF4:        49 FF         EOR.B #$FF                
CODE_02CEF6:        1A            INC A                     
CODE_02CEF7:        85 04         STA $04                   
CODE_02CEF9:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02CEFC:        A5 04         LDA $04                   
CODE_02CEFE:        0A            ASL                       
CODE_02CEFF:        0A            ASL                       
CODE_02CF00:        65 04         ADC $04                   
CODE_02CF02:        65 02         ADC $02                   
CODE_02CF04:        AA            TAX                       
CODE_02CF05:        A5 05         LDA $05                   
CODE_02CF07:        4A            LSR                       
CODE_02CF08:        BD 90 CE      LDA.W DATA_02CE90,X       
CODE_02CF0B:        90 03         BCC CODE_02CF10           
CODE_02CF0D:        49 FF         EOR.B #$FF                
CODE_02CF0F:        1A            INC A                     
CODE_02CF10:        85 08         STA $08                   
CODE_02CF12:        18            CLC                       
CODE_02CF13:        65 00         ADC $00                   
CODE_02CF15:        99 00 03      STA.W OAM_DispX,Y         
CODE_02CF18:        A5 03         LDA $03                   
CODE_02CF1A:        0A            ASL                       
CODE_02CF1B:        BD B8 CE      LDA.W DATA_02CEB8,X       
CODE_02CF1E:        90 03         BCC CODE_02CF23           
CODE_02CF20:        49 FF         EOR.B #$FF                
CODE_02CF22:        1A            INC A                     
CODE_02CF23:        85 09         STA $09                   
CODE_02CF25:        18            CLC                       
CODE_02CF26:        65 01         ADC $01                   
CODE_02CF28:        99 01 03      STA.W OAM_DispY,Y         
CODE_02CF2B:        A9 3D         LDA.B #$3D                
CODE_02CF2D:        99 02 03      STA.W OAM_Tile,Y          
CODE_02CF30:        A5 64         LDA $64                   
CODE_02CF32:        09 0A         ORA.B #$0A                
CODE_02CF34:        99 03 03      STA.W OAM_Prop,Y          
CODE_02CF37:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02CF3A:        5A            PHY                       
CODE_02CF3B:        20 52 CF      JSR.W CODE_02CF52         
CODE_02CF3E:        7A            PLY                       
CODE_02CF3F:        C8            INY                       
CODE_02CF40:        C8            INY                       
CODE_02CF41:        C8            INY                       
CODE_02CF42:        C8            INY                       
CODE_02CF43:        C6 02         DEC $02                   
CODE_02CF45:        30 03         BMI CODE_02CF4A           
CODE_02CF47:        4C FC CE      JMP.W CODE_02CEFC         

CODE_02CF4A:        A0 00         LDY.B #$00                
CODE_02CF4C:        A9 04         LDA.B #$04                
CODE_02CF4E:        4C A7 B7      JMP.W CODE_02B7A7         

Return02CF51:       60            RTS                       ; Return 

CODE_02CF52:        A5 71         LDA RAM_MarioAnimation    
CODE_02CF54:        C9 01         CMP.B #$01                
CODE_02CF56:        B0 F9         BCS Return02CF51          
CODE_02CF58:        A5 81         LDA $81                   
CODE_02CF5A:        05 7F         ORA $7F                   
CODE_02CF5C:        1D A0 15      ORA.W RAM_OffscreenHorz,X 
CODE_02CF5F:        1D 6C 18      ORA.W RAM_OffscreenVert,X 
CODE_02CF62:        D0 ED         BNE Return02CF51          
CODE_02CF64:        A5 7E         LDA $7E                   
CODE_02CF66:        18            CLC                       
CODE_02CF67:        69 02         ADC.B #$02                
CODE_02CF69:        85 0A         STA $0A                   
CODE_02CF6B:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_02CF6E:        C9 01         CMP.B #$01                
CODE_02CF70:        A9 10         LDA.B #$10                
CODE_02CF72:        90 02         BCC CODE_02CF76           
CODE_02CF74:        A9 20         LDA.B #$20                
CODE_02CF76:        18            CLC                       
CODE_02CF77:        65 80         ADC $80                   
CODE_02CF79:        85 0B         STA $0B                   
CODE_02CF7B:        B9 00 03      LDA.W OAM_DispX,Y         
CODE_02CF7E:        38            SEC                       
CODE_02CF7F:        E5 0A         SBC $0A                   
CODE_02CF81:        18            CLC                       
CODE_02CF82:        69 08         ADC.B #$08                
CODE_02CF84:        C9 14         CMP.B #$14                
CODE_02CF86:        B0 75         BCS Return02CFFD          
CODE_02CF88:        A5 19         LDA RAM_MarioPowerUp      
CODE_02CF8A:        C9 01         CMP.B #$01                
CODE_02CF8C:        A9 1A         LDA.B #$1A                
CODE_02CF8E:        B0 02         BCS CODE_02CF92           
CODE_02CF90:        A9 1C         LDA.B #$1C                
CODE_02CF92:        85 0F         STA $0F                   
CODE_02CF94:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_02CF97:        38            SEC                       
CODE_02CF98:        E5 0B         SBC $0B                   
CODE_02CF9A:        18            CLC                       
CODE_02CF9B:        69 08         ADC.B #$08                
CODE_02CF9D:        C5 0F         CMP $0F                   
CODE_02CF9F:        B0 5C         BCS Return02CFFD          
CODE_02CFA1:        A5 7D         LDA RAM_MarioSpeedY       
CODE_02CFA3:        30 58         BMI Return02CFFD          
CODE_02CFA5:        A9 1F         LDA.B #$1F                
CODE_02CFA7:        DA            PHX                       
CODE_02CFA8:        AE 7A 18      LDX.W RAM_OnYoshi         
CODE_02CFAB:        F0 02         BEQ CODE_02CFAF           
ADDR_02CFAD:        A9 2F         LDA.B #$2F                
CODE_02CFAF:        85 0F         STA $0F                   
CODE_02CFB1:        FA            PLX                       
CODE_02CFB2:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_02CFB5:        38            SEC                       
CODE_02CFB6:        E5 0F         SBC $0F                   
CODE_02CFB8:        08            PHP                       
CODE_02CFB9:        18            CLC                       
CODE_02CFBA:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_02CFBC:        85 96         STA RAM_MarioYPos         
CODE_02CFBE:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02CFC0:        69 00         ADC.B #$00                
CODE_02CFC2:        28            PLP                       
CODE_02CFC3:        E9 00         SBC.B #$00                
CODE_02CFC5:        85 97         STA RAM_MarioYPosHi       
CODE_02CFC7:        64 72         STZ RAM_IsFlying          
CODE_02CFC9:        A9 02         LDA.B #$02                
CODE_02CFCB:        8D 71 14      STA.W $1471               
CODE_02CFCE:        BD 28 15      LDA.W $1528,X             
CODE_02CFD1:        F0 18         BEQ CODE_02CFEB           
CODE_02CFD3:        C9 02         CMP.B #$02                
CODE_02CFD5:        F0 14         BEQ CODE_02CFEB           
CODE_02CFD7:        BD 40 15      LDA.W $1540,X             
CODE_02CFDA:        C9 01         CMP.B #$01                
CODE_02CFDC:        D0 0C         BNE Return02CFEA          
CODE_02CFDE:        A9 08         LDA.B #$08                
CODE_02CFE0:        9D 34 15      STA.W $1534,X             
CODE_02CFE3:        B4 C2         LDY RAM_SpriteState,X     
CODE_02CFE5:        B9 07 CE      LDA.W DATA_02CE07,Y       
CODE_02CFE8:        85 7D         STA RAM_MarioSpeedY       
Return02CFEA:       60            RTS                       ; Return 

CODE_02CFEB:        64 7B         STZ RAM_MarioSpeedX       
CODE_02CFED:        A4 02         LDY $02                   
CODE_02CFEF:        B9 FE CF      LDA.W PeaBouncerPhysics,Y 
CODE_02CFF2:        9D 1C 15      STA.W $151C,X             
CODE_02CFF5:        A9 01         LDA.B #$01                
CODE_02CFF7:        9D 28 15      STA.W $1528,X             
CODE_02CFFA:        9E 70 15      STZ.W $1570,X             
Return02CFFD:       60            RTS                       ; Return 


PeaBouncerPhysics:                .db $01,$01,$03,$05,$07

DATA_02D003:                      .db $40,$B0

DATA_02D005:                      .db $01,$FF

DATA_02D007:                      .db $30,$C0,$A0,$C0,$A0,$70,$60,$B0
DATA_02D00F:                      .db $01,$FF,$01,$FF,$01,$FF,$01,$FF

SubOffscreen3Bnk2:  A9 06         LDA.B #$06                ; \ Entry point of routine determines value of $03 
CODE_02D019:        80 06         BRA CODE_02D021           ;  | 

SubOffscreen2Bnk2:  A9 04         LDA.B #$04                ;  | 
CODE_02D01D:        80 02         BRA CODE_02D021           ;  | 

SubOffscreen1Bnk2:  A9 02         LDA.B #$02                ;  | 
CODE_02D021:        85 03         STA $03                   ;  | 
CODE_02D023:        80 02         BRA CODE_02D027           ;  | 

SubOffscreen0Bnk2:  64 03         STZ $03                   ; / 
CODE_02D027:        20 C9 D0      JSR.W IsSprOffScreenBnk2  ; \ if sprite is not off screen, return 
CODE_02D02A:        F0 64         BEQ Return02D090          ; / 
CODE_02D02C:        A5 5B         LDA RAM_IsVerticalLvl     ; \  vertical level 
CODE_02D02E:        29 01         AND.B #$01                ;  | 
CODE_02D030:        D0 5F         BNE VerticalLevelBnk2     ; / 
CODE_02D032:        A5 03         LDA $03                   
CODE_02D034:        C9 04         CMP.B #$04                
CODE_02D036:        F0 15         BEQ CODE_02D04D           
CODE_02D038:        B5 D8         LDA RAM_SpriteYLo,X       ; \ 
CODE_02D03A:        18            CLC                       ;  | 
CODE_02D03B:        69 50         ADC.B #$50                ;  | if the sprite has gone off the bottom of the level... 
CODE_02D03D:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | (if adding 0x50 to the sprite y position would make the high byte >= 2) 
CODE_02D040:        69 00         ADC.B #$00                ;  | 
CODE_02D042:        C9 02         CMP.B #$02                ;  | 
CODE_02D044:        10 34         BPL OffScrEraseSprBnk2    ; /    ...erase the sprite 
CODE_02D046:        BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ if "process offscreen" flag is set, return 
CODE_02D049:        29 04         AND.B #$04                ;  | 
CODE_02D04B:        D0 43         BNE Return02D090          ; / 
CODE_02D04D:        A5 13         LDA RAM_FrameCounter      
CODE_02D04F:        29 01         AND.B #$01                
CODE_02D051:        05 03         ORA $03                   
CODE_02D053:        85 01         STA $01                   
CODE_02D055:        A8            TAY                       
CODE_02D056:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_02D058:        18            CLC                       
CODE_02D059:        79 07 D0      ADC.W DATA_02D007,Y       
CODE_02D05C:        26 00         ROL $00                   
CODE_02D05E:        D5 E4         CMP RAM_SpriteXLo,X       
CODE_02D060:        08            PHP                       
CODE_02D061:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02D063:        46 00         LSR $00                   
CODE_02D065:        79 0F D0      ADC.W DATA_02D00F,Y       
CODE_02D068:        28            PLP                       
CODE_02D069:        FD E0 14      SBC.W RAM_SpriteXHi,X     
CODE_02D06C:        85 00         STA $00                   
CODE_02D06E:        46 01         LSR $01                   
CODE_02D070:        90 04         BCC CODE_02D076           
CODE_02D072:        49 80         EOR.B #$80                
CODE_02D074:        85 00         STA $00                   
CODE_02D076:        A5 00         LDA $00                   
CODE_02D078:        10 16         BPL Return02D090          
OffScrEraseSprBnk2: BD C8 14      LDA.W $14C8,X             ; \ If sprite status < 8, permanently erase sprite 
CODE_02D07D:        C9 08         CMP.B #$08                ;  | 
CODE_02D07F:        90 0C         BCC OffScrKillSprBnk2     ; / 
CODE_02D081:        BC 1A 16      LDY.W RAM_SprIndexInLvl,X ; \ Branch if should permanently erase sprite 
CODE_02D084:        C0 FF         CPY.B #$FF                ;  | 
CODE_02D086:        F0 05         BEQ OffScrKillSprBnk2     ; / 
CODE_02D088:        A9 00         LDA.B #$00                ; \ Allow sprite to be reloaded by level loading routine 
CODE_02D08A:        99 38 19      STA.W RAM_SprLoadStatus,Y ; / 
OffScrKillSprBnk2:  9E C8 14      STZ.W $14C8,X             ; Erase sprite 
Return02D090:       60            RTS                       ; Return 

VerticalLevelBnk2:  BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ If "process offscreen" flag is set, return 
CODE_02D094:        29 04         AND.B #$04                ;  | 
CODE_02D096:        D0 F8         BNE Return02D090          ; / 
CODE_02D098:        A5 13         LDA RAM_FrameCounter      ; \ Return every other frame 
CODE_02D09A:        4A            LSR                       ;  | 
CODE_02D09B:        B0 F3         BCS Return02D090          ; / 
CODE_02D09D:        29 01         AND.B #$01                
CODE_02D09F:        85 01         STA $01                   
CODE_02D0A1:        A8            TAY                       
CODE_02D0A2:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_02D0A4:        18            CLC                       
CODE_02D0A5:        79 03 D0      ADC.W DATA_02D003,Y       
CODE_02D0A8:        26 00         ROL $00                   
CODE_02D0AA:        D5 D8         CMP RAM_SpriteYLo,X       
CODE_02D0AC:        08            PHP                       
CODE_02D0AD:        AD 1D 00      LDA.W RAM_ScreenBndryYHi  
CODE_02D0B0:        46 00         LSR $00                   
CODE_02D0B2:        79 05 D0      ADC.W DATA_02D005,Y       
CODE_02D0B5:        28            PLP                       
CODE_02D0B6:        FD D4 14      SBC.W RAM_SpriteYHi,X     
CODE_02D0B9:        85 00         STA $00                   
CODE_02D0BB:        A4 01         LDY $01                   
CODE_02D0BD:        F0 04         BEQ CODE_02D0C3           
CODE_02D0BF:        49 80         EOR.B #$80                
CODE_02D0C1:        85 00         STA $00                   
CODE_02D0C3:        A5 00         LDA $00                   
CODE_02D0C5:        10 C9         BPL Return02D090          
CODE_02D0C7:        30 B1         BMI OffScrEraseSprBnk2    
IsSprOffScreenBnk2: BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_02D0CC:        1D 6C 18      ORA.W RAM_OffscreenVert,X 
Return02D0CF:       60            RTS                       ; Return 


DATA_02D0D0:                      .db $14,$FC

DATA_02D0D2:                      .db $00,$FF

CODE_02D0D4:        BD 64 15      LDA.W $1564,X             
CODE_02D0D7:        D0 0C         BNE Return02D0E5          
CODE_02D0D9:        BD 0E 16      LDA.W $160E,X             
CODE_02D0DC:        10 07         BPL Return02D0E5          
CODE_02D0DE:        8B            PHB                       
CODE_02D0DF:        4B            PHK                       
CODE_02D0E0:        AB            PLB                       
CODE_02D0E1:        20 E6 D0      JSR.W CODE_02D0E6         
CODE_02D0E4:        AB            PLB                       
Return02D0E5:       6B            RTL                       ; Return 

CODE_02D0E6:        64 0F         STZ $0F                   
CODE_02D0E8:        80 5F         BRA CODE_02D149           

ADDR_02D0EA:        B5 D8         LDA RAM_SpriteYLo,X       ; \ Unreachable 
ADDR_02D0EC:        18            CLC                       ;  | Something to do with Yoshi? 
ADDR_02D0ED:        69 08         ADC.B #$08                
ADDR_02D0EF:        29 F0         AND.B #$F0                
ADDR_02D0F1:        85 00         STA $00                   
ADDR_02D0F3:        BD D4 14      LDA.W RAM_SpriteYHi,X     
ADDR_02D0F6:        69 00         ADC.B #$00                
ADDR_02D0F8:        C5 5D         CMP RAM_ScreensInLvl      
ADDR_02D0FA:        B0 4C         BCS Return02D148          
ADDR_02D0FC:        85 03         STA $03                   
ADDR_02D0FE:        29 10         AND.B #$10                
ADDR_02D100:        85 08         STA $08                   
ADDR_02D102:        BC 7C 15      LDY.W RAM_SpriteDir,X     
ADDR_02D105:        B5 E4         LDA RAM_SpriteXLo,X       
ADDR_02D107:        18            CLC                       
ADDR_02D108:        79 D0 D0      ADC.W DATA_02D0D0,Y       
ADDR_02D10B:        85 01         STA $01                   
ADDR_02D10D:        BD E0 14      LDA.W RAM_SpriteXHi,X     
ADDR_02D110:        79 D2 D0      ADC.W DATA_02D0D2,Y       
ADDR_02D113:        C9 02         CMP.B #$02                
ADDR_02D115:        B0 31         BCS Return02D148          
ADDR_02D117:        85 02         STA $02                   
ADDR_02D119:        A5 01         LDA $01                   
ADDR_02D11B:        4A            LSR                       
ADDR_02D11C:        4A            LSR                       
ADDR_02D11D:        4A            LSR                       
ADDR_02D11E:        4A            LSR                       
ADDR_02D11F:        05 00         ORA $00                   
ADDR_02D121:        85 00         STA $00                   
ADDR_02D123:        A6 03         LDX $03                   
ADDR_02D125:        BF 80 BA 00   LDA.L DATA_00BA80,X       
ADDR_02D129:        A4 0F         LDY $0F                   
ADDR_02D12B:        F0 04         BEQ ADDR_02D131           
ADDR_02D12D:        BF 8E BA 00   LDA.L DATA_00BA8E,X       
ADDR_02D131:        18            CLC                       
ADDR_02D132:        65 00         ADC $00                   
ADDR_02D134:        85 05         STA $05                   
ADDR_02D136:        BF BC BA 00   LDA.L DATA_00BABC,X       
ADDR_02D13A:        A4 0F         LDY $0F                   
ADDR_02D13C:        F0 04         BEQ ADDR_02D142           
ADDR_02D13E:        BF CA BA 00   LDA.L DATA_00BACA,X       
ADDR_02D142:        65 02         ADC $02                   
ADDR_02D144:        85 06         STA $06                   
ADDR_02D146:        80 65         BRA CODE_02D1AD           

Return02D148:       60            RTS                       ; Return 

CODE_02D149:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $18B2 = Sprite Y position + #$08 
CODE_02D14B:        18            CLC                       ;  | 
CODE_02D14C:        69 08         ADC.B #$08                ;  | 
CODE_02D14E:        8D B2 18      STA.W $18B2               ; / 
CODE_02D151:        29 F0         AND.B #$F0                ; \ $00 = (Sprite Y position + #$08) rounded down to closest #$10 low byte 
CODE_02D153:        85 00         STA $00                   ; / 
CODE_02D155:        BD D4 14      LDA.W RAM_SpriteYHi,X     ; \ 
CODE_02D158:        69 00         ADC.B #$00                ;  | Return if off screen 
CODE_02D15A:        C9 02         CMP.B #$02                ;  | 
CODE_02D15C:        B0 EA         BCS Return02D148          ;  | 
CODE_02D15E:        85 02         STA $02                   ;  | $02 = (Sprite Y position + #$08) High byte 
CODE_02D160:        8D B3 18      STA.W $18B3               ; / 
CODE_02D163:        BC 7C 15      LDY.W RAM_SpriteDir,X     ; \ $18B0 = Sprite X position + $0014/$FFFC 
CODE_02D166:        B5 E4         LDA RAM_SpriteXLo,X       ;  | 
CODE_02D168:        18            CLC                       ;  | 
CODE_02D169:        79 D0 D0      ADC.W DATA_02D0D0,Y       ;  | 
CODE_02D16C:        85 01         STA $01                   ;  | $01 = (Sprite X position + $0014/$FFFC) Low byte 
CODE_02D16E:        8D B0 18      STA.W $18B0               ;  | 
CODE_02D171:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_02D174:        79 D2 D0      ADC.W DATA_02D0D2,Y       ;  | 
CODE_02D177:        C5 5D         CMP RAM_ScreensInLvl      ;  | Return if past end of level 
CODE_02D179:        B0 CD         BCS Return02D148          ;  | 
CODE_02D17B:        8D B1 18      STA.W $18B1               ;  | 
CODE_02D17E:        85 03         STA $03                   ; / $03 = (Sprite X position + $0014/$FFFC) High byte 
CODE_02D180:        A5 01         LDA $01                   ; \ $00 = bits 4-7 of Y position, bits 4-7 of X position 
CODE_02D182:        4A            LSR                       ;  | 
CODE_02D183:        4A            LSR                       ;  | 
CODE_02D184:        4A            LSR                       ;  | 
CODE_02D185:        4A            LSR                       ;  | 
CODE_02D186:        05 00         ORA $00                   ;  | 
CODE_02D188:        85 00         STA $00                   ; / 
CODE_02D18A:        A6 03         LDX $03                   
CODE_02D18C:        BF 60 BA 00   LDA.L DATA_00BA60,X       
CODE_02D190:        A4 0F         LDY $0F                   
CODE_02D192:        F0 04         BEQ CODE_02D198           
ADDR_02D194:        BF 70 BA 00   LDA.L DATA_00BA70,X       
CODE_02D198:        18            CLC                       
CODE_02D199:        65 00         ADC $00                   
CODE_02D19B:        85 05         STA $05                   
CODE_02D19D:        BF 9C BA 00   LDA.L DATA_00BA9C,X       
CODE_02D1A1:        A4 0F         LDY $0F                   
CODE_02D1A3:        F0 04         BEQ CODE_02D1A9           
ADDR_02D1A5:        BF AC BA 00   LDA.L DATA_00BAAC,X       
CODE_02D1A9:        65 02         ADC $02                   
CODE_02D1AB:        85 06         STA $06                   
CODE_02D1AD:        A9 7E         LDA.B #$7E                
CODE_02D1AF:        85 07         STA $07                   
CODE_02D1B1:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02D1B4:        A7 05         LDA [$05]                 
CODE_02D1B6:        8D 93 16      STA.W $1693               
CODE_02D1B9:        E6 07         INC $07                   
CODE_02D1BB:        A7 05         LDA [$05]                 
CODE_02D1BD:        D0 31         BNE Return02D1F0          
CODE_02D1BF:        AD 93 16      LDA.W $1693               
CODE_02D1C2:        C9 45         CMP.B #$45                
CODE_02D1C4:        90 2A         BCC Return02D1F0          
CODE_02D1C6:        C9 48         CMP.B #$48                
CODE_02D1C8:        B0 26         BCS Return02D1F0          
CODE_02D1CA:        38            SEC                       
CODE_02D1CB:        E9 44         SBC.B #$44                
CODE_02D1CD:        8D D6 18      STA.W $18D6               
CODE_02D1D0:        9C A3 14      STZ.W $14A3               
CODE_02D1D3:        AC DC 18      LDY.W $18DC               
CODE_02D1D6:        B9 F1 D1      LDA.W DATA_02D1F1,Y       
CODE_02D1D9:        9D 02 16      STA.W $1602,X             
CODE_02D1DC:        A9 22         LDA.B #$22                
CODE_02D1DE:        9D 64 15      STA.W $1564,X             
CODE_02D1E1:        A5 96         LDA RAM_MarioYPos         
CODE_02D1E3:        18            CLC                       
CODE_02D1E4:        69 08         ADC.B #$08                
CODE_02D1E6:        29 F0         AND.B #$F0                
CODE_02D1E8:        85 96         STA RAM_MarioYPos         
CODE_02D1EA:        A5 97         LDA RAM_MarioYPosHi       
CODE_02D1EC:        69 00         ADC.B #$00                
CODE_02D1EE:        85 97         STA RAM_MarioYPosHi       
Return02D1F0:       60            RTS                       ; Return 


DATA_02D1F1:                      .db $00,$04

SetTreeTile:        AD B0 18      LDA.W $18B0               ; \ Set X position of block 
CODE_02D1F6:        85 9A         STA RAM_BlockYLo          ;  | 
CODE_02D1F8:        AD B1 18      LDA.W $18B1               ;  | 
CODE_02D1FB:        85 9B         STA RAM_BlockYHi          ; / 
CODE_02D1FD:        AD B2 18      LDA.W $18B2               ; \ Set Y position of block 
CODE_02D200:        85 98         STA RAM_BlockXLo          ;  | 
CODE_02D202:        AD B3 18      LDA.W $18B3               ;  | 
CODE_02D205:        85 99         STA RAM_BlockXHi          ; / 
CODE_02D207:        A9 04         LDA.B #$04                ; \ Block to generate = Tree behind berry 
CODE_02D209:        85 9C         STA RAM_BlockBlock        ; / 
CODE_02D20B:        22 B0 BE 00   JSL.L GenerateTile        
Return02D20F:       6B            RTL                       ; Return 


DATA_02D210:                      .db $01

DATA_02D211:                      .db $FF,$10,$F0

CODE_02D214:        A5 15         LDA RAM_ControllerA       
CODE_02D216:        29 03         AND.B #$03                
CODE_02D218:        D0 0E         BNE CODE_02D228           
CODE_02D21A:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02D21C:        F0 08         BEQ CODE_02D226           
CODE_02D21E:        10 04         BPL CODE_02D224           
CODE_02D220:        F6 B6         INC RAM_SpriteSpeedX,X    
CODE_02D222:        F6 B6         INC RAM_SpriteSpeedX,X    
CODE_02D224:        D6 B6         DEC RAM_SpriteSpeedX,X    
CODE_02D226:        80 1F         BRA CODE_02D247           

CODE_02D228:        A8            TAY                       
CODE_02D229:        C0 01         CPY.B #$01                
CODE_02D22B:        D0 0B         BNE CODE_02D238           
CODE_02D22D:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02D22F:        D9 11 D2      CMP.W DATA_02D211,Y       
CODE_02D232:        F0 13         BEQ CODE_02D247           
CODE_02D234:        10 E4         BPL CODE_02D21A           
CODE_02D236:        80 09         BRA CODE_02D241           

CODE_02D238:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02D23A:        D9 11 D2      CMP.W DATA_02D211,Y       
CODE_02D23D:        F0 08         BEQ CODE_02D247           
CODE_02D23F:        30 D9         BMI CODE_02D21A           
CODE_02D241:        18            CLC                       
CODE_02D242:        79 0F D2      ADC.W Return02D20F,Y      
CODE_02D245:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02D247:        A0 00         LDY.B #$00                
CODE_02D249:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02D24B:        C9 87         CMP.B #$87                
CODE_02D24D:        D0 10         BNE CODE_02D25F           
CODE_02D24F:        A5 15         LDA RAM_ControllerA       
CODE_02D251:        29 0C         AND.B #$0C                
CODE_02D253:        F0 1A         BEQ CODE_02D26F           
CODE_02D255:        A0 10         LDY.B #$10                
CODE_02D257:        29 08         AND.B #$08                
CODE_02D259:        F0 14         BEQ CODE_02D26F           
CODE_02D25B:        A0 F0         LDY.B #$F0                
CODE_02D25D:        80 10         BRA CODE_02D26F           

CODE_02D25F:        A0 F8         LDY.B #$F8                
CODE_02D261:        A5 15         LDA RAM_ControllerA       
CODE_02D263:        29 0C         AND.B #$0C                
CODE_02D265:        F0 08         BEQ CODE_02D26F           
CODE_02D267:        A0 F0         LDY.B #$F0                
CODE_02D269:        29 08         AND.B #$08                
CODE_02D26B:        D0 02         BNE CODE_02D26F           
CODE_02D26D:        A0 08         LDY.B #$08                
CODE_02D26F:        84 00         STY $00                   
CODE_02D271:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02D273:        C5 00         CMP $00                   
CODE_02D275:        F0 08         BEQ CODE_02D27F           
CODE_02D277:        10 04         BPL CODE_02D27D           
CODE_02D279:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_02D27B:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_02D27D:        D6 AA         DEC RAM_SpriteSpeedY,X    
CODE_02D27F:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02D281:        85 7B         STA RAM_MarioSpeedX       
CODE_02D283:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02D285:        85 7D         STA RAM_MarioSpeedY       
Return02D287:       6B            RTL                       ; Return 

UpdateXPosNoGrvty:  8A            TXA                       ; \ Adjust index so we use X values rather than Y 
CODE_02D289:        18            CLC                       ;  | 
CODE_02D28A:        69 0C         ADC.B #$0C                ;  | 
CODE_02D28C:        AA            TAX                       ; / 
CODE_02D28D:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02D290:        AE E9 15      LDX.W $15E9               ; X = sprite index 
Return02D293:       60            RTS                       ; Return 

UpdateYPosNoGrvty:  B5 AA         LDA RAM_SpriteSpeedY,X    ; \ $14EC or $14F8 += 16 * speed 
CODE_02D296:        0A            ASL                       ;  | 
CODE_02D297:        0A            ASL                       ;  | 
CODE_02D298:        0A            ASL                       ;  | 
CODE_02D299:        0A            ASL                       ;  | 
CODE_02D29A:        18            CLC                       ;  | 
CODE_02D29B:        7D EC 14      ADC.W $14EC,X             ;  | 
CODE_02D29E:        9D EC 14      STA.W $14EC,X             ; / 
CODE_02D2A1:        08            PHP                       
CODE_02D2A2:        08            PHP                       
CODE_02D2A3:        A0 00         LDY.B #$00                
CODE_02D2A5:        B5 AA         LDA RAM_SpriteSpeedY,X    ; \ Amount to move sprite = speed / 16 
CODE_02D2A7:        4A            LSR                       ;  | 
CODE_02D2A8:        4A            LSR                       ;  | 
CODE_02D2A9:        4A            LSR                       ;  | 
CODE_02D2AA:        4A            LSR                       ; / 
CODE_02D2AB:        C9 08         CMP.B #$08                ; \ If speed was negative... 
CODE_02D2AD:        90 03         BCC CODE_02D2B2           ;  | 
CODE_02D2AF:        09 F0         ORA.B #$F0                ;  | ...set high bits 
CODE_02D2B1:        88            DEY                       ; / 
CODE_02D2B2:        28            PLP                       
CODE_02D2B3:        48            PHA                       ; \ Add to position 
CODE_02D2B4:        75 D8         ADC RAM_SpriteYLo,X       ;  | 
CODE_02D2B6:        95 D8         STA RAM_SpriteYLo,X       ;  | 
CODE_02D2B8:        98            TYA                       ;  | 
CODE_02D2B9:        7D D4 14      ADC.W RAM_SpriteYHi,X     ;  | 
CODE_02D2BC:        9D D4 14      STA.W RAM_SpriteYHi,X     ;  | 
CODE_02D2BF:        68            PLA                       ; / 
CODE_02D2C0:        28            PLP                       
CODE_02D2C1:        69 00         ADC.B #$00                
CODE_02D2C3:        8D 91 14      STA.W $1491               ; $1491 = amount sprite was moved 
Return02D2C6:       60            RTS                       ; Return 

ADDR_02D2C7:        85 00         STA $00                   ; Unreachable 
ADDR_02D2C9:        A5 94         LDA RAM_MarioXPos         ; \ Save Mario's position 
ADDR_02D2CB:        48            PHA                       ;  | 
ADDR_02D2CC:        A5 95         LDA RAM_MarioXPosHi       ;  | 
ADDR_02D2CE:        48            PHA                       ;  | 
ADDR_02D2CF:        A5 96         LDA RAM_MarioYPos         ;  | 
ADDR_02D2D1:        48            PHA                       ;  | 
ADDR_02D2D2:        A5 97         LDA RAM_MarioYPosHi       ;  | 
ADDR_02D2D4:        48            PHA                       ; / 
ADDR_02D2D5:        B9 E4 00      LDA.W RAM_SpriteXLo,Y     ; \ Mario's position = Sprite position 
ADDR_02D2D8:        85 94         STA RAM_MarioXPos         ;  | 
ADDR_02D2DA:        B9 E0 14      LDA.W RAM_SpriteXHi,Y     ;  | 
ADDR_02D2DD:        85 95         STA RAM_MarioXPosHi       ;  | 
ADDR_02D2DF:        B9 D8 00      LDA.W RAM_SpriteYLo,Y     ;  | 
ADDR_02D2E2:        85 96         STA RAM_MarioYPos         ;  | 
ADDR_02D2E4:        B9 D4 14      LDA.W RAM_SpriteYHi,Y     ;  | 
ADDR_02D2E7:        85 97         STA RAM_MarioYPosHi       ; / 
ADDR_02D2E9:        A5 00         LDA $00                   
ADDR_02D2EB:        20 FB D2      JSR.W CODE_02D2FB         
ADDR_02D2EE:        68            PLA                       ; \ Restore Mario's position 
ADDR_02D2EF:        85 97         STA RAM_MarioYPosHi       ;  | 
ADDR_02D2F1:        68            PLA                       ;  | 
ADDR_02D2F2:        85 96         STA RAM_MarioYPos         ;  | 
ADDR_02D2F4:        68            PLA                       ;  | 
ADDR_02D2F5:        85 95         STA RAM_MarioXPosHi       ;  | 
ADDR_02D2F7:        68            PLA                       ;  | 
ADDR_02D2F8:        85 94         STA RAM_MarioXPos         ; / 
Return02D2FA:       60            RTS                       ; Return 

CODE_02D2FB:        85 01         STA $01                   
CODE_02D2FD:        DA            PHX                       
CODE_02D2FE:        5A            PHY                       
CODE_02D2FF:        20 0C D5      JSR.W CODE_02D50C         
CODE_02D302:        84 02         STY $02                   
CODE_02D304:        A5 0E         LDA $0E                   
CODE_02D306:        10 05         BPL CODE_02D30D           
CODE_02D308:        49 FF         EOR.B #$FF                
CODE_02D30A:        18            CLC                       
CODE_02D30B:        69 01         ADC.B #$01                
CODE_02D30D:        85 0C         STA $0C                   
CODE_02D30F:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02D312:        84 03         STY $03                   
CODE_02D314:        A5 0F         LDA $0F                   
CODE_02D316:        10 05         BPL CODE_02D31D           
CODE_02D318:        49 FF         EOR.B #$FF                
CODE_02D31A:        18            CLC                       
CODE_02D31B:        69 01         ADC.B #$01                
CODE_02D31D:        85 0D         STA $0D                   
CODE_02D31F:        A0 00         LDY.B #$00                
CODE_02D321:        A5 0D         LDA $0D                   
CODE_02D323:        C5 0C         CMP $0C                   
CODE_02D325:        B0 09         BCS CODE_02D330           
CODE_02D327:        C8            INY                       
CODE_02D328:        48            PHA                       
CODE_02D329:        A5 0C         LDA $0C                   
CODE_02D32B:        85 0D         STA $0D                   
CODE_02D32D:        68            PLA                       
CODE_02D32E:        85 0C         STA $0C                   
CODE_02D330:        A9 00         LDA.B #$00                
CODE_02D332:        85 0B         STA $0B                   
CODE_02D334:        85 00         STA $00                   
CODE_02D336:        A6 01         LDX $01                   
CODE_02D338:        A5 0B         LDA $0B                   
CODE_02D33A:        18            CLC                       
CODE_02D33B:        65 0C         ADC $0C                   
CODE_02D33D:        C5 0D         CMP $0D                   
CODE_02D33F:        90 04         BCC CODE_02D345           
CODE_02D341:        E5 0D         SBC $0D                   
CODE_02D343:        E6 00         INC $00                   
CODE_02D345:        85 0B         STA $0B                   
CODE_02D347:        CA            DEX                       
CODE_02D348:        D0 EE         BNE CODE_02D338           
CODE_02D34A:        98            TYA                       
CODE_02D34B:        F0 0A         BEQ CODE_02D357           
CODE_02D34D:        A5 00         LDA $00                   
CODE_02D34F:        48            PHA                       
CODE_02D350:        A5 01         LDA $01                   
CODE_02D352:        85 00         STA $00                   
CODE_02D354:        68            PLA                       
CODE_02D355:        85 01         STA $01                   
CODE_02D357:        A5 00         LDA $00                   
CODE_02D359:        A4 02         LDY $02                   
CODE_02D35B:        F0 07         BEQ CODE_02D364           
CODE_02D35D:        49 FF         EOR.B #$FF                
CODE_02D35F:        18            CLC                       
CODE_02D360:        69 01         ADC.B #$01                
CODE_02D362:        85 00         STA $00                   
CODE_02D364:        A5 01         LDA $01                   
CODE_02D366:        A4 03         LDY $03                   
CODE_02D368:        F0 07         BEQ CODE_02D371           
CODE_02D36A:        49 FF         EOR.B #$FF                
CODE_02D36C:        18            CLC                       
CODE_02D36D:        69 01         ADC.B #$01                
CODE_02D36F:        85 01         STA $01                   
CODE_02D371:        7A            PLY                       
CODE_02D372:        FA            PLX                       
Return02D373:       60            RTS                       ; Return 


DATA_02D374:                      .db $0C,$1C

DATA_02D376:                      .db $01,$02

GetDrawInfo2:       9E 6C 18      STZ.W RAM_OffscreenVert,X 
CODE_02D37B:        9E A0 15      STZ.W RAM_OffscreenHorz,X 
CODE_02D37E:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02D380:        C5 1A         CMP RAM_ScreenBndryXLo    
CODE_02D382:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02D385:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_02D387:        F0 03         BEQ CODE_02D38C           
CODE_02D389:        FE A0 15      INC.W RAM_OffscreenHorz,X 
CODE_02D38C:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02D38F:        EB            XBA                       
CODE_02D390:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02D392:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_02D394:        38            SEC                       
CODE_02D395:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02D397:        18            CLC                       
CODE_02D398:        69 40 00      ADC.W #$0040              
CODE_02D39B:        C9 80 01      CMP.W #$0180              
CODE_02D39E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_02D3A0:        2A            ROL                       
CODE_02D3A1:        29 01         AND.B #$01                
CODE_02D3A3:        9D C4 15      STA.W $15C4,X             
CODE_02D3A6:        D0 3F         BNE CODE_02D3E7           
CODE_02D3A8:        A0 00         LDY.B #$00                
CODE_02D3AA:        BD 62 16      LDA.W RAM_Tweaker1662,X   
CODE_02D3AD:        29 20         AND.B #$20                
CODE_02D3AF:        F0 01         BEQ CODE_02D3B2           
CODE_02D3B1:        C8            INY                       
CODE_02D3B2:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02D3B4:        18            CLC                       
CODE_02D3B5:        79 74 D3      ADC.W DATA_02D374,Y       
CODE_02D3B8:        08            PHP                       
CODE_02D3B9:        C5 1C         CMP RAM_ScreenBndryYLo    
CODE_02D3BB:        26 00         ROL $00                   
CODE_02D3BD:        28            PLP                       
CODE_02D3BE:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02D3C1:        69 00         ADC.B #$00                
CODE_02D3C3:        46 00         LSR $00                   
CODE_02D3C5:        E5 1D         SBC RAM_ScreenBndryYHi    
CODE_02D3C7:        F0 09         BEQ CODE_02D3D2           
CODE_02D3C9:        BD 6C 18      LDA.W RAM_OffscreenVert,X 
CODE_02D3CC:        19 76 D3      ORA.W DATA_02D376,Y       
CODE_02D3CF:        9D 6C 18      STA.W RAM_OffscreenVert,X 
CODE_02D3D2:        88            DEY                       
CODE_02D3D3:        10 DD         BPL CODE_02D3B2           
CODE_02D3D5:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02D3D8:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02D3DA:        38            SEC                       
CODE_02D3DB:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02D3DD:        85 00         STA $00                   
CODE_02D3DF:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02D3E1:        38            SEC                       
CODE_02D3E2:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02D3E4:        85 01         STA $01                   
Return02D3E6:       60            RTS                       ; Return 

CODE_02D3E7:        68            PLA                       
CODE_02D3E8:        68            PLA                       
Return02D3E9:       60            RTS                       ; Return 

Layer3SmashMain:    22 61 FF 00   JSL.L CODE_00FF61         
CODE_02D3EE:        A5 9D         LDA RAM_SpritesLocked     
CODE_02D3F0:        D0 52         BNE Return02D444          
CODE_02D3F2:        20 9C D4      JSR.W CODE_02D49C         
CODE_02D3F5:        A0 00         LDY.B #$00                
CODE_02D3F7:        AD BD 17      LDA.W $17BD               
CODE_02D3FA:        10 01         BPL CODE_02D3FD           
ADDR_02D3FC:        88            DEY                       
CODE_02D3FD:        18            CLC                       
CODE_02D3FE:        75 E4         ADC RAM_SpriteXLo,X       
CODE_02D400:        95 E4         STA RAM_SpriteXLo,X       
CODE_02D402:        98            TYA                       
CODE_02D403:        7D E0 14      ADC.W RAM_SpriteXHi,X     
CODE_02D406:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02D409:        B5 C2         LDA RAM_SpriteState,X     
CODE_02D40B:        22 DF 86 00   JSL.L ExecutePtr          

Layer3SmashPtrs:       19 D4      .dw CODE_02D419           
                       45 D4      .dw CODE_02D445           
                       55 D4      .dw CODE_02D455           
                       81 D4      .dw CODE_02D481           
                       89 D4      .dw CODE_02D489           

CODE_02D419:        AD BF 18      LDA.W $18BF               
CODE_02D41C:        F0 04         BEQ CODE_02D422           
ADDR_02D41E:        20 7A D0      JSR.W OffScrEraseSprBnk2  
Return02D421:       60            RTS                       ; Return 

CODE_02D422:        BD 40 15      LDA.W $1540,X             
CODE_02D425:        D0 1D         BNE Return02D444          
CODE_02D427:        F6 C2         INC RAM_SpriteState,X     
CODE_02D429:        A9 80         LDA.B #$80                
CODE_02D42B:        9D 40 15      STA.W $1540,X             
CODE_02D42E:        22 F9 AC 01   JSL.L GetRand             
CODE_02D432:        29 3F         AND.B #$3F                
CODE_02D434:        09 80         ORA.B #$80                
CODE_02D436:        95 E4         STA RAM_SpriteXLo,X       
CODE_02D438:        A9 FF         LDA.B #$FF                
CODE_02D43A:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02D43D:        74 D8         STZ RAM_SpriteYLo,X       
CODE_02D43F:        9E D4 14      STZ.W RAM_SpriteYHi,X     
CODE_02D442:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
Return02D444:       6B            RTL                       ; Return 

CODE_02D445:        BD 40 15      LDA.W $1540,X             
CODE_02D448:        F0 08         BEQ CODE_02D452           
CODE_02D44A:        A9 04         LDA.B #$04                
CODE_02D44C:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02D44E:        20 94 D2      JSR.W UpdateYPosNoGrvty   
Return02D451:       6B            RTL                       ; Return 

CODE_02D452:        F6 C2         INC RAM_SpriteState,X     
Return02D454:       6B            RTL                       ; Return 

CODE_02D455:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02D458:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02D45A:        30 04         BMI CODE_02D460           
CODE_02D45C:        C9 40         CMP.B #$40                
CODE_02D45E:        B0 05         BCS CODE_02D465           
CODE_02D460:        18            CLC                       
CODE_02D461:        69 07         ADC.B #$07                
CODE_02D463:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02D465:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02D467:        C9 A0         CMP.B #$A0                
CODE_02D469:        90 15         BCC Return02D480          
CODE_02D46B:        29 F0         AND.B #$F0                
CODE_02D46D:        95 D8         STA RAM_SpriteYLo,X       
CODE_02D46F:        A9 50         LDA.B #$50                ; \ Set ground shake timer 
CODE_02D471:        8D 87 18      STA.W RAM_ShakeGrndTimer  ; / 
CODE_02D474:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_02D476:        8D FC 1D      STA.W $1DFC               ; / 
CODE_02D479:        A9 30         LDA.B #$30                
CODE_02D47B:        9D 40 15      STA.W $1540,X             
CODE_02D47E:        F6 C2         INC RAM_SpriteState,X     
Return02D480:       6B            RTL                       ; Return 

CODE_02D481:        BD 40 15      LDA.W $1540,X             
CODE_02D484:        D0 02         BNE Return02D488          
CODE_02D486:        F6 C2         INC RAM_SpriteState,X     
Return02D488:       6B            RTL                       ; Return 

CODE_02D489:        A9 E0         LDA.B #$E0                
CODE_02D48B:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02D48D:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02D490:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02D492:        D0 07         BNE Return02D49B          
CODE_02D494:        74 C2         STZ RAM_SpriteState,X     
CODE_02D496:        A9 A0         LDA.B #$A0                
CODE_02D498:        9D 40 15      STA.W $1540,X             
Return02D49B:       6B            RTL                       ; Return 

CODE_02D49C:        A9 00         LDA.B #$00                
CODE_02D49E:        A4 19         LDY RAM_MarioPowerUp      
CODE_02D4A0:        F0 06         BEQ CODE_02D4A8           
CODE_02D4A2:        A4 73         LDY RAM_IsDucking         
CODE_02D4A4:        D0 02         BNE CODE_02D4A8           
CODE_02D4A6:        A9 10         LDA.B #$10                
CODE_02D4A8:        18            CLC                       
CODE_02D4A9:        75 D8         ADC RAM_SpriteYLo,X       
CODE_02D4AB:        C5 80         CMP $80                   
CODE_02D4AD:        90 40         BCC CODE_02D4EF           
CODE_02D4AF:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02D4B1:        85 00         STA $00                   
CODE_02D4B3:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02D4B6:        85 01         STA $01                   
CODE_02D4B8:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_02D4BA:        A5 7E         LDA $7E                   
CODE_02D4BC:        18            CLC                       
CODE_02D4BD:        65 00         ADC $00                   
CODE_02D4BF:        38            SEC                       
CODE_02D4C0:        E9 30 00      SBC.W #$0030              
CODE_02D4C3:        C9 90 00      CMP.W #$0090              
CODE_02D4C6:        B0 27         BCS CODE_02D4EF           
CODE_02D4C8:        38            SEC                       
CODE_02D4C9:        E9 08 00      SBC.W #$0008              
CODE_02D4CC:        C9 80 00      CMP.W #$0080              
CODE_02D4CF:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_02D4D1:        B0 12         BCS CODE_02D4E5           
CODE_02D4D3:        A5 72         LDA RAM_IsFlying          
CODE_02D4D5:        D0 05         BNE CODE_02D4DC           
CODE_02D4D7:        22 B7 F5 00   JSL.L HurtMario           
Return02D4DB:       60            RTS                       ; Return 

CODE_02D4DC:        64 7D         STZ RAM_MarioSpeedY       
CODE_02D4DE:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02D4E0:        30 02         BMI Return02D4E4          
CODE_02D4E2:        85 7D         STA RAM_MarioSpeedY       
Return02D4E4:       60            RTS                       ; Return 

CODE_02D4E5:        08            PHP                       
CODE_02D4E6:        A9 08         LDA.B #$08                
CODE_02D4E8:        28            PLP                       
CODE_02D4E9:        10 02         BPL CODE_02D4ED           
CODE_02D4EB:        A9 F8         LDA.B #$F8                
CODE_02D4ED:        85 7B         STA RAM_MarioSpeedX       
CODE_02D4EF:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return02D4F1:       60            RTS                       ; Return 


DATA_02D4F2:                      .db $80,$40,$20,$10,$08,$04,$02,$01

CODE_02D4FA:        A0 00         LDY.B #$00                
CODE_02D4FC:        A5 94         LDA RAM_MarioXPos         
CODE_02D4FE:        38            SEC                       
CODE_02D4FF:        F5 E4         SBC RAM_SpriteXLo,X       
CODE_02D501:        85 0F         STA $0F                   
CODE_02D503:        A5 95         LDA RAM_MarioXPosHi       
CODE_02D505:        FD E0 14      SBC.W RAM_SpriteXHi,X     
CODE_02D508:        10 01         BPL Return02D50B          
CODE_02D50A:        C8            INY                       
Return02D50B:       60            RTS                       ; Return 

CODE_02D50C:        A0 00         LDY.B #$00                
CODE_02D50E:        A5 96         LDA RAM_MarioYPos         
CODE_02D510:        38            SEC                       
CODE_02D511:        F5 D8         SBC RAM_SpriteYLo,X       
CODE_02D513:        85 0E         STA $0E                   
CODE_02D515:        A5 97         LDA RAM_MarioYPosHi       
CODE_02D517:        FD D4 14      SBC.W RAM_SpriteYHi,X     
CODE_02D51A:        10 01         BPL Return02D51D          
CODE_02D51C:        C8            INY                       
Return02D51D:       60            RTS                       ; Return 


DATA_02D51E:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF

DATA_02D57F:                      .db $FF,$13,$14,$15,$16,$17,$18,$19

CODE_02D587:        20 E4 D5      JSR.W CODE_02D5E4         
CODE_02D58A:        BD C8 14      LDA.W $14C8,X             
CODE_02D58D:        C9 02         CMP.B #$02                
CODE_02D58F:        F0 12         BEQ Return02D5A3          
CODE_02D591:        A5 9D         LDA RAM_SpritesLocked     
CODE_02D593:        D0 0E         BNE Return02D5A3          
CODE_02D595:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02D598:        A9 E8         LDA.B #$E8                
CODE_02D59A:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02D59C:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02D59F:        22 DC A7 01   JSL.L MarioSprInteract    
Return02D5A3:       60            RTS                       ; Return 


DATA_02D5A4:                      .db $00,$10,$20,$30,$00,$10,$20,$30
                                  .db $00,$10,$20,$30,$00,$10,$20,$30
DATA_02D5B4:                      .db $00,$00,$00,$00,$10,$10,$10,$10
                                  .db $20,$20,$20,$20,$30,$30,$30,$30
BanzaiBillTiles:                  .db $80,$82,$84,$86,$A0,$88,$CE,$EE
                                  .db $C0,$C2,$CE,$EE,$8E,$AE,$84,$86
DATA_02D5D4:                      .db $33,$33,$33,$33,$33,$33,$33,$33
                                  .db $33,$33,$33,$33,$33,$33,$B3,$B3

CODE_02D5E4:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02D5E7:        DA            PHX                       
CODE_02D5E8:        A2 0F         LDX.B #$0F                
CODE_02D5EA:        A5 00         LDA $00                   
CODE_02D5EC:        18            CLC                       
CODE_02D5ED:        7D A4 D5      ADC.W DATA_02D5A4,X       
CODE_02D5F0:        99 00 03      STA.W OAM_DispX,Y         
CODE_02D5F3:        A5 01         LDA $01                   
CODE_02D5F5:        18            CLC                       
CODE_02D5F6:        7D B4 D5      ADC.W DATA_02D5B4,X       
CODE_02D5F9:        99 01 03      STA.W OAM_DispY,Y         
CODE_02D5FC:        BD C4 D5      LDA.W BanzaiBillTiles,X   
CODE_02D5FF:        99 02 03      STA.W OAM_Tile,Y          
CODE_02D602:        BD D4 D5      LDA.W DATA_02D5D4,X       
CODE_02D605:        99 03 03      STA.W OAM_Prop,Y          
CODE_02D608:        C8            INY                       
CODE_02D609:        C8            INY                       
CODE_02D60A:        C8            INY                       
CODE_02D60B:        C8            INY                       
CODE_02D60C:        CA            DEX                       
CODE_02D60D:        10 DB         BPL CODE_02D5EA           
CODE_02D60F:        FA            PLX                       
CODE_02D610:        A0 02         LDY.B #$02                
CODE_02D612:        A9 0F         LDA.B #$0F                
CODE_02D614:        4C A7 B7      JMP.W CODE_02B7A7         

Banzai+Rotating:    8B            PHB                       
CODE_02D618:        4B            PHK                       
CODE_02D619:        AB            PLB                       
CODE_02D61A:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02D61C:        C9 9F         CMP.B #$9F                
CODE_02D61E:        D0 05         BNE CODE_02D625           
CODE_02D620:        20 87 D5      JSR.W CODE_02D587         
CODE_02D623:        80 03         BRA CODE_02D628           

CODE_02D625:        20 2A D6      JSR.W CODE_02D62A         
CODE_02D628:        AB            PLB                       
Return02D629:       6B            RTL                       ; Return 

CODE_02D62A:        20 17 D0      JSR.W SubOffscreen3Bnk2   
CODE_02D62D:        A5 9D         LDA RAM_SpritesLocked     
CODE_02D62F:        D0 22         BNE CODE_02D653           
CODE_02D631:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02D633:        A0 02         LDY.B #$02                
CODE_02D635:        29 10         AND.B #$10                
CODE_02D637:        D0 02         BNE CODE_02D63B           
CODE_02D639:        A0 FE         LDY.B #$FE                
CODE_02D63B:        98            TYA                       
CODE_02D63C:        A0 00         LDY.B #$00                
CODE_02D63E:        C9 00         CMP.B #$00                
CODE_02D640:        10 01         BPL CODE_02D643           
CODE_02D642:        88            DEY                       
CODE_02D643:        18            CLC                       
CODE_02D644:        7D 02 16      ADC.W $1602,X             
CODE_02D647:        9D 02 16      STA.W $1602,X             
CODE_02D64A:        98            TYA                       
CODE_02D64B:        7D 1C 15      ADC.W $151C,X             
CODE_02D64E:        29 01         AND.B #$01                
CODE_02D650:        9D 1C 15      STA.W $151C,X             
CODE_02D653:        BD 1C 15      LDA.W $151C,X             
CODE_02D656:        85 01         STA $01                   
CODE_02D658:        BD 02 16      LDA.W $1602,X             
CODE_02D65B:        85 00         STA $00                   
CODE_02D65D:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_02D65F:        A5 00         LDA $00                   
CODE_02D661:        18            CLC                       
CODE_02D662:        69 80 00      ADC.W #$0080              
CODE_02D665:        29 FF 01      AND.W #$01FF              
CODE_02D668:        85 02         STA $02                   
CODE_02D66A:        A5 00         LDA $00                   
CODE_02D66C:        29 FF 00      AND.W #$00FF              
CODE_02D66F:        0A            ASL                       
CODE_02D670:        AA            TAX                       
CODE_02D671:        BF DB F7 07   LDA.L CircleCoords,X      
CODE_02D675:        85 04         STA $04                   
CODE_02D677:        A5 02         LDA $02                   
CODE_02D679:        29 FF 00      AND.W #$00FF              
CODE_02D67C:        0A            ASL                       
CODE_02D67D:        AA            TAX                       
CODE_02D67E:        BF DB F7 07   LDA.L CircleCoords,X      
CODE_02D682:        85 06         STA $06                   
CODE_02D684:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_02D686:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02D689:        A5 04         LDA $04                   
CODE_02D68B:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_02D68E:        BD 7B 18      LDA.W $187B,X             
CODE_02D691:        A4 05         LDY $05                   
CODE_02D693:        D0 0E         BNE CODE_02D6A3           
CODE_02D695:        8D 03 42      STA.W $4203               ; Multplier B
CODE_02D698:        20 00 D8      JSR.W CODE_02D800         
CODE_02D69B:        0E 16 42      ASL.W $4216               ; Product/Remainder Result (Low Byte)
CODE_02D69E:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_02D6A1:        69 00         ADC.B #$00                
CODE_02D6A3:        46 01         LSR $01                   
CODE_02D6A5:        90 03         BCC CODE_02D6AA           
CODE_02D6A7:        49 FF         EOR.B #$FF                
CODE_02D6A9:        1A            INC A                     
CODE_02D6AA:        85 04         STA $04                   
CODE_02D6AC:        A5 06         LDA $06                   
CODE_02D6AE:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_02D6B1:        BD 7B 18      LDA.W $187B,X             
CODE_02D6B4:        A4 07         LDY $07                   
CODE_02D6B6:        D0 0E         BNE CODE_02D6C6           
CODE_02D6B8:        8D 03 42      STA.W $4203               ; Multplier B
CODE_02D6BB:        20 00 D8      JSR.W CODE_02D800         
CODE_02D6BE:        0E 16 42      ASL.W $4216               ; Product/Remainder Result (Low Byte)
CODE_02D6C1:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_02D6C4:        69 00         ADC.B #$00                
CODE_02D6C6:        46 03         LSR $03                   
CODE_02D6C8:        90 03         BCC CODE_02D6CD           
CODE_02D6CA:        49 FF         EOR.B #$FF                
CODE_02D6CC:        1A            INC A                     
CODE_02D6CD:        85 06         STA $06                   
CODE_02D6CF:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02D6D1:        48            PHA                       
CODE_02D6D2:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02D6D5:        48            PHA                       
CODE_02D6D6:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02D6D8:        48            PHA                       
CODE_02D6D9:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02D6DC:        48            PHA                       
CODE_02D6DD:        BC 86 0F      LDY.W $0F86,X             
CODE_02D6E0:        64 00         STZ $00                   
CODE_02D6E2:        A5 04         LDA $04                   
CODE_02D6E4:        10 02         BPL CODE_02D6E8           
CODE_02D6E6:        C6 00         DEC $00                   
CODE_02D6E8:        18            CLC                       
CODE_02D6E9:        75 E4         ADC RAM_SpriteXLo,X       
CODE_02D6EB:        95 E4         STA RAM_SpriteXLo,X       
CODE_02D6ED:        08            PHP                       
CODE_02D6EE:        48            PHA                       
CODE_02D6EF:        38            SEC                       
CODE_02D6F0:        FD 34 15      SBC.W $1534,X             
CODE_02D6F3:        9D 28 15      STA.W $1528,X             
CODE_02D6F6:        68            PLA                       
CODE_02D6F7:        9D 34 15      STA.W $1534,X             
CODE_02D6FA:        28            PLP                       
CODE_02D6FB:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02D6FE:        65 00         ADC $00                   
CODE_02D700:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02D703:        64 01         STZ $01                   
CODE_02D705:        A5 06         LDA $06                   
CODE_02D707:        10 02         BPL CODE_02D70B           
CODE_02D709:        C6 01         DEC $01                   
CODE_02D70B:        18            CLC                       
CODE_02D70C:        75 D8         ADC RAM_SpriteYLo,X       
CODE_02D70E:        95 D8         STA RAM_SpriteYLo,X       
CODE_02D710:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02D713:        65 01         ADC $01                   
CODE_02D715:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02D718:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02D71A:        C9 9E         CMP.B #$9E                
CODE_02D71C:        F0 32         BEQ CODE_02D750           
CODE_02D71E:        22 4F B4 01   JSL.L InvisBlkMainRt      
CODE_02D722:        90 19         BCC CODE_02D73D           
CODE_02D724:        A9 03         LDA.B #$03                
CODE_02D726:        9D 0E 16      STA.W $160E,X             
CODE_02D729:        8D 71 14      STA.W $1471               
CODE_02D72C:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_02D72F:        D0 1A         BNE CODE_02D74B           
CODE_02D731:        DA            PHX                       
CODE_02D732:        22 BD E2 00   JSL.L CODE_00E2BD         
CODE_02D736:        FA            PLX                       
CODE_02D737:        A9 FF         LDA.B #$FF                
CODE_02D739:        85 78         STA $78                   
CODE_02D73B:        80 0E         BRA CODE_02D74B           

CODE_02D73D:        BD 0E 16      LDA.W $160E,X             
CODE_02D740:        F0 09         BEQ CODE_02D74B           
CODE_02D742:        9E 0E 16      STZ.W $160E,X             
CODE_02D745:        DA            PHX                       
CODE_02D746:        22 BD E2 00   JSL.L CODE_00E2BD         
CODE_02D74A:        FA            PLX                       
CODE_02D74B:        20 48 D8      JSR.W CODE_02D848         
CODE_02D74E:        80 07         BRA CODE_02D757           

CODE_02D750:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_02D754:        20 13 D8      JSR.W CODE_02D813         
CODE_02D757:        68            PLA                       
CODE_02D758:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02D75B:        68            PLA                       
CODE_02D75C:        95 D8         STA RAM_SpriteYLo,X       
CODE_02D75E:        68            PLA                       
CODE_02D75F:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02D762:        68            PLA                       
CODE_02D763:        95 E4         STA RAM_SpriteXLo,X       
CODE_02D765:        A5 00         LDA $00                   
CODE_02D767:        18            CLC                       
CODE_02D768:        65 1A         ADC RAM_ScreenBndryXLo    
CODE_02D76A:        38            SEC                       
CODE_02D76B:        F5 E4         SBC RAM_SpriteXLo,X       
CODE_02D76D:        20 70 D8      JSR.W CODE_02D870         
CODE_02D770:        18            CLC                       
CODE_02D771:        75 E4         ADC RAM_SpriteXLo,X       
CODE_02D773:        38            SEC                       
CODE_02D774:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02D776:        85 00         STA $00                   
CODE_02D778:        A5 01         LDA $01                   
CODE_02D77A:        18            CLC                       
CODE_02D77B:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_02D77D:        38            SEC                       
CODE_02D77E:        F5 D8         SBC RAM_SpriteYLo,X       
CODE_02D780:        20 70 D8      JSR.W CODE_02D870         
CODE_02D783:        18            CLC                       
CODE_02D784:        75 D8         ADC RAM_SpriteYLo,X       
CODE_02D786:        38            SEC                       
CODE_02D787:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02D789:        85 01         STA $01                   
CODE_02D78B:        BD C4 15      LDA.W $15C4,X             
CODE_02D78E:        D0 76         BNE Return02D806          
CODE_02D790:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_02D793:        18            CLC                       
CODE_02D794:        69 10         ADC.B #$10                
CODE_02D796:        A8            TAY                       
CODE_02D797:        DA            PHX                       
CODE_02D798:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02D79A:        85 0A         STA $0A                   
CODE_02D79C:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02D79E:        85 0B         STA $0B                   
CODE_02D7A0:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02D7A2:        AA            TAX                       
CODE_02D7A3:        A9 E8         LDA.B #$E8                
CODE_02D7A5:        E0 9E         CPX.B #$9E                
CODE_02D7A7:        F0 02         BEQ CODE_02D7AB           
CODE_02D7A9:        A9 A2         LDA.B #$A2                
CODE_02D7AB:        85 08         STA $08                   
CODE_02D7AD:        A2 01         LDX.B #$01                
CODE_02D7AF:        A5 00         LDA $00                   
CODE_02D7B1:        99 00 03      STA.W OAM_DispX,Y         
CODE_02D7B4:        A5 01         LDA $01                   
CODE_02D7B6:        99 01 03      STA.W OAM_DispY,Y         
CODE_02D7B9:        A5 08         LDA $08                   
CODE_02D7BB:        99 02 03      STA.W OAM_Tile,Y          
CODE_02D7BE:        A9 33         LDA.B #$33                
CODE_02D7C0:        99 03 03      STA.W OAM_Prop,Y          
CODE_02D7C3:        A5 00         LDA $00                   
CODE_02D7C5:        18            CLC                       
CODE_02D7C6:        65 1A         ADC RAM_ScreenBndryXLo    
CODE_02D7C8:        38            SEC                       
CODE_02D7C9:        E5 0A         SBC $0A                   
CODE_02D7CB:        85 00         STA $00                   
CODE_02D7CD:        0A            ASL                       
CODE_02D7CE:        66 00         ROR $00                   
CODE_02D7D0:        A5 00         LDA $00                   
CODE_02D7D2:        38            SEC                       
CODE_02D7D3:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02D7D5:        18            CLC                       
CODE_02D7D6:        65 0A         ADC $0A                   
CODE_02D7D8:        85 00         STA $00                   
CODE_02D7DA:        A5 01         LDA $01                   
CODE_02D7DC:        18            CLC                       
CODE_02D7DD:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_02D7DF:        38            SEC                       
CODE_02D7E0:        E5 0B         SBC $0B                   
CODE_02D7E2:        85 01         STA $01                   
CODE_02D7E4:        0A            ASL                       
CODE_02D7E5:        66 01         ROR $01                   
CODE_02D7E7:        A5 01         LDA $01                   
CODE_02D7E9:        38            SEC                       
CODE_02D7EA:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02D7EC:        18            CLC                       
CODE_02D7ED:        65 0B         ADC $0B                   
CODE_02D7EF:        85 01         STA $01                   
CODE_02D7F1:        C8            INY                       
CODE_02D7F2:        C8            INY                       
CODE_02D7F3:        C8            INY                       
CODE_02D7F4:        C8            INY                       
CODE_02D7F5:        CA            DEX                       
CODE_02D7F6:        10 B7         BPL CODE_02D7AF           
CODE_02D7F8:        FA            PLX                       
CODE_02D7F9:        A0 02         LDY.B #$02                
CODE_02D7FB:        A9 05         LDA.B #$05                
CODE_02D7FD:        4C A7 B7      JMP.W CODE_02B7A7         

CODE_02D800:        EA            NOP                       
CODE_02D801:        EA            NOP                       
CODE_02D802:        EA            NOP                       
CODE_02D803:        EA            NOP                       
CODE_02D804:        EA            NOP                       
CODE_02D805:        EA            NOP                       
Return02D806:       60            RTS                       ; Return 


DATA_02D807:                      .db $F8,$08,$F8,$08

DATA_02D80B:                      .db $F8,$F8,$08,$08

DATA_02D80F:                      .db $33,$73,$B3,$F3

CODE_02D813:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02D816:        DA            PHX                       
CODE_02D817:        A2 03         LDX.B #$03                
CODE_02D819:        A5 00         LDA $00                   
CODE_02D81B:        18            CLC                       
CODE_02D81C:        7D 07 D8      ADC.W DATA_02D807,X       
CODE_02D81F:        99 00 03      STA.W OAM_DispX,Y         
CODE_02D822:        A5 01         LDA $01                   
CODE_02D824:        18            CLC                       
CODE_02D825:        7D 0B D8      ADC.W DATA_02D80B,X       
CODE_02D828:        99 01 03      STA.W OAM_DispY,Y         
CODE_02D82B:        BD 00 D8      LDA.W CODE_02D800,X       
CODE_02D82E:        99 02 03      STA.W OAM_Tile,Y          
CODE_02D831:        BD 0F D8      LDA.W DATA_02D80F,X       
CODE_02D834:        99 03 03      STA.W OAM_Prop,Y          
CODE_02D837:        C8            INY                       
CODE_02D838:        C8            INY                       
CODE_02D839:        C8            INY                       
CODE_02D83A:        C8            INY                       
CODE_02D83B:        CA            DEX                       
CODE_02D83C:        10 DB         BPL CODE_02D819           
CODE_02D83E:        FA            PLX                       
Return02D83F:       60            RTS                       ; Return 


DATA_02D840:                      .db $00,$F0,$00,$10

WoodPlatformTiles:                .db $A2,$60,$61,$62

CODE_02D848:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02D84B:        DA            PHX                       
CODE_02D84C:        A2 03         LDX.B #$03                
CODE_02D84E:        A5 00         LDA $00                   
CODE_02D850:        18            CLC                       
CODE_02D851:        7D 40 D8      ADC.W DATA_02D840,X       
CODE_02D854:        99 00 03      STA.W OAM_DispX,Y         
CODE_02D857:        A5 01         LDA $01                   
CODE_02D859:        99 01 03      STA.W OAM_DispY,Y         
CODE_02D85C:        BD 44 D8      LDA.W WoodPlatformTiles,X 
CODE_02D85F:        99 02 03      STA.W OAM_Tile,Y          
CODE_02D862:        A9 33         LDA.B #$33                
CODE_02D864:        99 03 03      STA.W OAM_Prop,Y          
CODE_02D867:        C8            INY                       
CODE_02D868:        C8            INY                       
CODE_02D869:        C8            INY                       
CODE_02D86A:        C8            INY                       
CODE_02D86B:        CA            DEX                       
CODE_02D86C:        10 E0         BPL CODE_02D84E           
CODE_02D86E:        FA            PLX                       
Return02D86F:       60            RTS                       ; Return 

CODE_02D870:        08            PHP                       
CODE_02D871:        10 03         BPL CODE_02D876           
CODE_02D873:        49 FF         EOR.B #$FF                
CODE_02D875:        1A            INC A                     
CODE_02D876:        8D 05 42      STA.W $4205               ; Dividend (High-Byte)
CODE_02D879:        9C 04 42      STZ.W $4204               ; Dividend (Low Byte)
CODE_02D87C:        BD 7B 18      LDA.W $187B,X             
CODE_02D87F:        4A            LSR                       
CODE_02D880:        8D 06 42      STA.W $4206               ; Divisor B
CODE_02D883:        20 00 D8      JSR.W CODE_02D800         
CODE_02D886:        AD 14 42      LDA.W $4214               ; Quotient of Divide Result (Low Byte)
CODE_02D889:        85 0E         STA $0E                   
CODE_02D88B:        AD 15 42      LDA.W $4215               ; Quotient of Divide Result (High Byte)
CODE_02D88E:        06 0E         ASL $0E                   
CODE_02D890:        2A            ROL                       
CODE_02D891:        06 0E         ASL $0E                   
CODE_02D893:        2A            ROL                       
CODE_02D894:        06 0E         ASL $0E                   
CODE_02D896:        2A            ROL                       
CODE_02D897:        06 0E         ASL $0E                   
CODE_02D899:        2A            ROL                       
CODE_02D89A:        28            PLP                       
CODE_02D89B:        10 03         BPL Return02D8A0          
CODE_02D89D:        49 FF         EOR.B #$FF                
CODE_02D89F:        1A            INC A                     
Return02D8A0:       60            RTS                       ; Return 


BubbleSprTiles1:                  .db $A8,$CA,$67,$24

BubbleSprTiles2:                  .db $AA,$CC,$69,$24

BubbleSprGfxProp1:                .db $84,$85,$05,$08

BubbleSpriteMain:   8B            PHB                       
CODE_02D8AE:        4B            PHK                       
CODE_02D8AF:        AB            PLB                       
CODE_02D8B0:        20 BB D8      JSR.W CODE_02D8BB         
CODE_02D8B3:        AB            PLB                       
Return02D8B4:       6B            RTL                       ; Return 


BubbleSprGfxProp2:                .db $08,$F8

BubbleSprGfxProp3:                .db $01,$FF

BubbleSprGfxProp4:                .db $0C,$F4

CODE_02D8BB:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_02D8BE:        18            CLC                       
CODE_02D8BF:        69 14         ADC.B #$14                
CODE_02D8C1:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_02D8C4:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_02D8C8:        DA            PHX                       
CODE_02D8C9:        B5 C2         LDA RAM_SpriteState,X     
CODE_02D8CB:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02D8CE:        AA            TAX                       
CODE_02D8CF:        BD A9 D8      LDA.W BubbleSprGfxProp1,X 
CODE_02D8D2:        05 64         ORA $64                   
CODE_02D8D4:        99 03 03      STA.W OAM_Prop,Y          
CODE_02D8D7:        A5 14         LDA RAM_FrameCounterB     
CODE_02D8D9:        0A            ASL                       
CODE_02D8DA:        0A            ASL                       
CODE_02D8DB:        0A            ASL                       
CODE_02D8DC:        BD A1 D8      LDA.W BubbleSprTiles1,X   
CODE_02D8DF:        90 03         BCC CODE_02D8E4           
CODE_02D8E1:        BD A5 D8      LDA.W BubbleSprTiles2,X   
CODE_02D8E4:        99 02 03      STA.W OAM_Tile,Y          
CODE_02D8E7:        FA            PLX                       
CODE_02D8E8:        BD 34 15      LDA.W $1534,X             
CODE_02D8EB:        C9 60         CMP.B #$60                
CODE_02D8ED:        B0 04         BCS CODE_02D8F3           
CODE_02D8EF:        29 02         AND.B #$02                
CODE_02D8F1:        F0 03         BEQ CODE_02D8F6           
CODE_02D8F3:        20 D6 D9      JSR.W CODE_02D9D6         
CODE_02D8F6:        BD C8 14      LDA.W $14C8,X             
CODE_02D8F9:        C9 02         CMP.B #$02                
CODE_02D8FB:        D0 07         BNE CODE_02D904           
ADDR_02D8FD:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
ADDR_02D8FF:        9D C8 14      STA.W $14C8,X             ; / 
ADDR_02D902:        80 67         BRA CODE_02D96B           

CODE_02D904:        A5 9D         LDA RAM_SpritesLocked     
CODE_02D906:        D0 6F         BNE Return02D977          
CODE_02D908:        A5 13         LDA RAM_FrameCounter      
CODE_02D90A:        29 01         AND.B #$01                
CODE_02D90C:        D0 0F         BNE CODE_02D91D           
CODE_02D90E:        DE 34 15      DEC.W $1534,X             
CODE_02D911:        BD 34 15      LDA.W $1534,X             
CODE_02D914:        C9 04         CMP.B #$04                
CODE_02D916:        D0 05         BNE CODE_02D91D           
CODE_02D918:        A9 19         LDA.B #$19                ; \ Play sound effect 
CODE_02D91A:        8D FC 1D      STA.W $1DFC               ; / 
CODE_02D91D:        BD 34 15      LDA.W $1534,X             
CODE_02D920:        3A            DEC A                     
CODE_02D921:        F0 55         BEQ CODE_02D978           
CODE_02D923:        C9 07         CMP.B #$07                
CODE_02D925:        90 50         BCC Return02D977          
CODE_02D927:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02D92A:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02D92D:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02D930:        22 38 91 01   JSL.L CODE_019138         
CODE_02D934:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02D937:        B9 B5 D8      LDA.W BubbleSprGfxProp2,Y 
CODE_02D93A:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02D93C:        A5 13         LDA RAM_FrameCounter      
CODE_02D93E:        29 01         AND.B #$01                
CODE_02D940:        D0 16         BNE CODE_02D958           
CODE_02D942:        BD 1C 15      LDA.W $151C,X             
CODE_02D945:        29 01         AND.B #$01                
CODE_02D947:        A8            TAY                       
CODE_02D948:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02D94A:        18            CLC                       
CODE_02D94B:        79 B7 D8      ADC.W BubbleSprGfxProp3,Y 
CODE_02D94E:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02D950:        D9 B9 D8      CMP.W BubbleSprGfxProp4,Y 
CODE_02D953:        D0 03         BNE CODE_02D958           
CODE_02D955:        FE 1C 15      INC.W $151C,X             
CODE_02D958:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_02D95B:        D0 0E         BNE CODE_02D96B           
CODE_02D95D:        22 32 80 01   JSL.L SprSprInteract      
CODE_02D961:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_02D965:        90 39         BCC Return02D9A0          
CODE_02D967:        64 7D         STZ RAM_MarioSpeedY       
CODE_02D969:        64 7B         STZ RAM_MarioSpeedX       
CODE_02D96B:        BD 34 15      LDA.W $1534,X             
CODE_02D96E:        C9 07         CMP.B #$07                
CODE_02D970:        90 05         BCC Return02D977          
CODE_02D972:        A9 06         LDA.B #$06                
CODE_02D974:        9D 34 15      STA.W $1534,X             
Return02D977:       60            RTS                       ; Return 

CODE_02D978:        B4 C2         LDY RAM_SpriteState,X     
CODE_02D97A:        B9 A1 D9      LDA.W BubbleSprites,Y     
CODE_02D97D:        95 9E         STA RAM_SpriteNum,X       
CODE_02D97F:        48            PHA                       
CODE_02D980:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02D984:        7A            PLY                       
CODE_02D985:        A9 20         LDA.B #$20                
CODE_02D987:        C0 74         CPY.B #$74                
CODE_02D989:        D0 02         BNE CODE_02D98D           
CODE_02D98B:        A9 04         LDA.B #$04                
CODE_02D98D:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_02D990:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02D992:        C9 0D         CMP.B #$0D                
CODE_02D994:        D0 03         BNE CODE_02D999           
CODE_02D996:        DE 40 15      DEC.W $1540,X             
CODE_02D999:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02D99C:        98            TYA                       
CODE_02D99D:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return02D9A0:       60            RTS                       ; Return 


BubbleSprites:                    .db $0F,$0D,$15,$74

BubbleTileDispX:                  .db $F8,$08,$F8,$08,$FF,$F9,$07,$F9
                                  .db $07,$00,$FA,$06,$FA,$06,$00

BubbleTileDispY:                  .db $F6,$F6,$02,$02,$FC,$F5,$F5,$03
                                  .db $03,$FC,$F4,$F4,$04,$04,$FB

BubbleTiles:                      .db $A0,$A0,$A0,$A0,$99

BubbleGfxProp:                    .db $07,$47,$87,$C7,$03

BubbleSize:                       .db $02,$02,$02,$02,$00

DATA_02D9D2:                      .db $00,$05,$0A,$05

CODE_02D9D6:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02D9D9:        A5 14         LDA RAM_FrameCounterB     
CODE_02D9DB:        4A            LSR                       
CODE_02D9DC:        4A            LSR                       
CODE_02D9DD:        4A            LSR                       
CODE_02D9DE:        29 03         AND.B #$03                
CODE_02D9E0:        A8            TAY                       
CODE_02D9E1:        B9 D2 D9      LDA.W DATA_02D9D2,Y       
CODE_02D9E4:        85 02         STA $02                   
CODE_02D9E6:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_02D9E9:        38            SEC                       
CODE_02D9EA:        E9 14         SBC.B #$14                
CODE_02D9EC:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_02D9EF:        A8            TAY                       
CODE_02D9F0:        DA            PHX                       
CODE_02D9F1:        BD 34 15      LDA.W $1534,X             
CODE_02D9F4:        85 03         STA $03                   
CODE_02D9F6:        A2 04         LDX.B #$04                
CODE_02D9F8:        DA            PHX                       
CODE_02D9F9:        8A            TXA                       
CODE_02D9FA:        18            CLC                       
CODE_02D9FB:        65 02         ADC $02                   
CODE_02D9FD:        AA            TAX                       
CODE_02D9FE:        A5 00         LDA $00                   
CODE_02DA00:        18            CLC                       
CODE_02DA01:        7D A5 D9      ADC.W BubbleTileDispX,X   
CODE_02DA04:        99 00 03      STA.W OAM_DispX,Y         
CODE_02DA07:        A5 01         LDA $01                   
CODE_02DA09:        18            CLC                       
CODE_02DA0A:        7D B4 D9      ADC.W BubbleTileDispY,X   
CODE_02DA0D:        99 01 03      STA.W OAM_DispY,Y         
CODE_02DA10:        FA            PLX                       
CODE_02DA11:        BD C3 D9      LDA.W BubbleTiles,X       
CODE_02DA14:        99 02 03      STA.W OAM_Tile,Y          
CODE_02DA17:        BD C8 D9      LDA.W BubbleGfxProp,X     
CODE_02DA1A:        05 64         ORA $64                   
CODE_02DA1C:        99 03 03      STA.W OAM_Prop,Y          
CODE_02DA1F:        A5 03         LDA $03                   
CODE_02DA21:        C9 06         CMP.B #$06                
CODE_02DA23:        B0 12         BCS CODE_02DA37           
CODE_02DA25:        C9 03         CMP.B #$03                
CODE_02DA27:        A9 02         LDA.B #$02                
CODE_02DA29:        05 64         ORA $64                   
CODE_02DA2B:        99 03 03      STA.W OAM_Prop,Y          
CODE_02DA2E:        A9 64         LDA.B #$64                
CODE_02DA30:        B0 02         BCS CODE_02DA34           
CODE_02DA32:        A9 66         LDA.B #$66                
CODE_02DA34:        99 02 03      STA.W OAM_Tile,Y          
CODE_02DA37:        5A            PHY                       
CODE_02DA38:        98            TYA                       
CODE_02DA39:        4A            LSR                       
CODE_02DA3A:        4A            LSR                       
CODE_02DA3B:        A8            TAY                       
CODE_02DA3C:        BD CD D9      LDA.W BubbleSize,X        
CODE_02DA3F:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02DA42:        7A            PLY                       
CODE_02DA43:        C8            INY                       
CODE_02DA44:        C8            INY                       
CODE_02DA45:        C8            INY                       
CODE_02DA46:        C8            INY                       
CODE_02DA47:        CA            DEX                       
CODE_02DA48:        10 AE         BPL CODE_02D9F8           
CODE_02DA4A:        FA            PLX                       
CODE_02DA4B:        A0 FF         LDY.B #$FF                
CODE_02DA4D:        A9 04         LDA.B #$04                
CODE_02DA4F:        4C A7 B7      JMP.W CODE_02B7A7         

HammerBrotherMain:  8B            PHB                       
CODE_02DA53:        4B            PHK                       
CODE_02DA54:        AB            PLB                       
CODE_02DA55:        20 5A DA      JSR.W CODE_02DA5A         
CODE_02DA58:        AB            PLB                       
Return02DA59:       6B            RTL                       ; Return 

CODE_02DA5A:        9E 7C 15      STZ.W RAM_SpriteDir,X     
CODE_02DA5D:        BD C8 14      LDA.W $14C8,X             
CODE_02DA60:        C9 02         CMP.B #$02                
CODE_02DA62:        D0 0A         BNE CODE_02DA6E           
CODE_02DA64:        4C FD DA      JMP.W HammerBroGfx        


HammerFreq:                       .db $1F,$0F,$0F,$0F,$0F,$0F,$0F

CODE_02DA6E:        A5 9D         LDA RAM_SpritesLocked     
CODE_02DA70:        D0 76         BNE Return02DAE8          
CODE_02DA72:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_02DA76:        20 1F D0      JSR.W SubOffscreen1Bnk2   
CODE_02DA79:        AC B3 0D      LDY.W $0DB3               
CODE_02DA7C:        B9 11 1F      LDA.W $1F11,Y             
CODE_02DA7F:        A8            TAY                       
CODE_02DA80:        A5 13         LDA RAM_FrameCounter      ; \ Increment $1570,x 3 out of every 4 frames 
CODE_02DA82:        29 03         AND.B #$03                ;  | 
CODE_02DA84:        F0 03         BEQ CODE_02DA89           ;  | 
CODE_02DA86:        FE 70 15      INC.W $1570,X             ; / 
CODE_02DA89:        BD 70 15      LDA.W $1570,X             
CODE_02DA8C:        0A            ASL                       
CODE_02DA8D:        C0 00         CPY.B #$00                
CODE_02DA8F:        F0 01         BEQ CODE_02DA92           
CODE_02DA91:        0A            ASL                       
CODE_02DA92:        29 40         AND.B #$40                
CODE_02DA94:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02DA97:        BD 70 15      LDA.W $1570,X             ; \ Don't throw if... 
CODE_02DA9A:        39 67 DA      AND.W HammerFreq,Y        ;  | ...not yet time 
CODE_02DA9D:        1D A0 15      ORA.W RAM_OffscreenHorz,X ;  | ...sprite offscreen 
CODE_02DAA0:        1D 6C 18      ORA.W RAM_OffscreenVert,X ;  | 
CODE_02DAA3:        1D 40 15      ORA.W $1540,X             ;  | ...we just threw one 
CODE_02DAA6:        D0 40         BNE Return02DAE8          ; / 
CODE_02DAA8:        A9 03         LDA.B #$03                ; \ Set minimum time in between throws 
CODE_02DAAA:        9D 40 15      STA.W $1540,X             ; / 
CODE_02DAAD:        A0 10         LDY.B #$10                ; \ $00 = Hammer X speed, 
CODE_02DAAF:        BD 7C 15      LDA.W RAM_SpriteDir,X     ;  | based on sprite's direction 
CODE_02DAB2:        D0 02         BNE CODE_02DAB6           ;  | 
CODE_02DAB4:        A0 F0         LDY.B #$F0                ;  | 
CODE_02DAB6:        84 00         STY $00                   ; / 
CODE_02DAB8:        A0 07         LDY.B #$07                ; \ Find a free extended sprite slots 
CODE_02DABA:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   ;  | 
CODE_02DABD:        F0 04         BEQ GenerateHammer        ;  | 
CODE_02DABF:        88            DEY                       ;  | 
CODE_02DAC0:        10 F8         BPL CODE_02DABA           ;  | 
Return02DAC2:       60            RTS                       ; / Return if no free slots 

GenerateHammer:     A9 04         LDA.B #$04                ; \ Extended sprite = Hammer 
CODE_02DAC5:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_02DAC8:        B5 E4         LDA RAM_SpriteXLo,X       ; \ Hammer X pos = sprite X pos 
CODE_02DACA:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   ;  | 
CODE_02DACD:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_02DAD0:        99 33 17      STA.W RAM_ExSpriteXHi,Y   ; / 
CODE_02DAD3:        B5 D8         LDA RAM_SpriteYLo,X       ; \ Hammer Y pos = sprite Y pos 
CODE_02DAD5:        99 15 17      STA.W RAM_ExSpriteYLo,Y   ;  | 
CODE_02DAD8:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_02DADB:        99 29 17      STA.W RAM_ExSpriteYHi,Y   ; / 
CODE_02DADE:        A9 D0         LDA.B #$D0                ; \ Hammer Y speed = #$D0 
CODE_02DAE0:        99 3D 17      STA.W RAM_ExSprSpeedY,Y   ; / 
CODE_02DAE3:        A5 00         LDA $00                   ; \ Hammer X speed = $00 
CODE_02DAE5:        99 47 17      STA.W RAM_ExSprSpeedX,Y   ; / 
Return02DAE8:       60            RTS                       ; Return 


HammerBroDispX:                   .db $08,$10,$00,$10

HammerBroDispY:                   .db $F8,$F8,$00,$00

HammerBroTiles:                   .db $5A,$4A,$46,$48,$4A,$5A,$48,$46
HammerBroTileSize:                .db $00,$00,$02,$02

HammerBroGfx:       20 78 D3      JSR.W GetDrawInfo2        
CODE_02DB00:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02DB03:        85 02         STA $02                   
CODE_02DB05:        DA            PHX                       
CODE_02DB06:        A2 03         LDX.B #$03                
CODE_02DB08:        A5 00         LDA $00                   
CODE_02DB0A:        18            CLC                       
CODE_02DB0B:        7D E9 DA      ADC.W HammerBroDispX,X    
CODE_02DB0E:        99 00 03      STA.W OAM_DispX,Y         
CODE_02DB11:        A5 01         LDA $01                   
CODE_02DB13:        18            CLC                       
CODE_02DB14:        7D ED DA      ADC.W HammerBroDispY,X    
CODE_02DB17:        99 01 03      STA.W OAM_DispY,Y         
CODE_02DB1A:        DA            PHX                       
CODE_02DB1B:        A5 02         LDA $02                   
CODE_02DB1D:        48            PHA                       
CODE_02DB1E:        09 37         ORA.B #$37                
CODE_02DB20:        99 03 03      STA.W OAM_Prop,Y          
CODE_02DB23:        68            PLA                       
CODE_02DB24:        F0 04         BEQ CODE_02DB2A           
CODE_02DB26:        E8            INX                       
CODE_02DB27:        E8            INX                       
CODE_02DB28:        E8            INX                       
CODE_02DB29:        E8            INX                       
CODE_02DB2A:        BD F1 DA      LDA.W HammerBroTiles,X    
CODE_02DB2D:        99 02 03      STA.W OAM_Tile,Y          
CODE_02DB30:        FA            PLX                       
CODE_02DB31:        5A            PHY                       
CODE_02DB32:        98            TYA                       
CODE_02DB33:        4A            LSR                       
CODE_02DB34:        4A            LSR                       
CODE_02DB35:        A8            TAY                       
CODE_02DB36:        BD F9 DA      LDA.W HammerBroTileSize,X 
CODE_02DB39:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02DB3C:        7A            PLY                       
CODE_02DB3D:        C8            INY                       
CODE_02DB3E:        C8            INY                       
CODE_02DB3F:        C8            INY                       
CODE_02DB40:        C8            INY                       
CODE_02DB41:        CA            DEX                       
CODE_02DB42:        10 C4         BPL CODE_02DB08           
CODE_02DB44:        FA            PLX                       
CODE_02DB45:        A0 FF         LDY.B #$FF                
CODE_02DB47:        A9 03         LDA.B #$03                
CODE_02DB49:        4C A7 B7      JMP.W CODE_02B7A7         

FlyingPlatformMain: 8B            PHB                       
CODE_02DB4D:        4B            PHK                       
CODE_02DB4E:        AB            PLB                       
CODE_02DB4F:        20 5C DB      JSR.W CODE_02DB5C         
CODE_02DB52:        AB            PLB                       
Return02DB53:       6B            RTL                       ; Return 


DATA_02DB54:                      .db $01,$FF

DATA_02DB56:                      .db $20,$E0

DATA_02DB58:                      .db $02,$FE

DATA_02DB5A:                      .db $20,$E0

CODE_02DB5C:        20 3F DC      JSR.W FlyingPlatformGfx   ; Draw sprite 
CODE_02DB5F:        A9 FF         LDA.B #$FF                ; \ $1594 = #$FF 
CODE_02DB61:        9D 94 15      STA.W $1594,X             ; / 
CODE_02DB64:        A0 09         LDY.B #$09                ; \ Check sprite slots 0-9 for Hammer Brother 
CODE_02DB66:        B9 C8 14      LDA.W $14C8,Y             ;  | 
CODE_02DB69:        C9 08         CMP.B #$08                ;  | 
CODE_02DB6B:        D0 07         BNE CODE_02DB74           ;  | 
CODE_02DB6D:        B9 9E 00      LDA.W RAM_SpriteNum,Y     ;  | 
CODE_02DB70:        C9 9B         CMP.B #$9B                ;  | 
CODE_02DB72:        F0 05         BEQ PutHammerBroOnPlat    ;  | 
CODE_02DB74:        88            DEY                       ;  | 
CODE_02DB75:        10 EF         BPL CODE_02DB66           ;  | 
CODE_02DB77:        80 25         BRA CODE_02DB9E           ; / Branch if no Hammer Brother 

PutHammerBroOnPlat: 98            TYA                       ; \ $1594 = index of Hammer Bro 
CODE_02DB7A:        9D 94 15      STA.W $1594,X             ; / 
CODE_02DB7D:        B5 E4         LDA RAM_SpriteXLo,X       ; \ Hammer Bro X postion = Platform X position 
CODE_02DB7F:        99 E4 00      STA.W RAM_SpriteXLo,Y     ;  | 
CODE_02DB82:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_02DB85:        99 E0 14      STA.W RAM_SpriteXHi,Y     ; / 
CODE_02DB88:        B5 D8         LDA RAM_SpriteYLo,X       ; \ Hammer Bro Y position = Platform Y position - #$10 
CODE_02DB8A:        38            SEC                       ;  | 
CODE_02DB8B:        E9 10         SBC.B #$10                ;  | 
CODE_02DB8D:        99 D8 00      STA.W RAM_SpriteYLo,Y     ;  | 
CODE_02DB90:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_02DB93:        E9 00         SBC.B #$00                ;  | 
CODE_02DB95:        99 D4 14      STA.W RAM_SpriteYHi,Y     ; / 
CODE_02DB98:        DA            PHX                       ; \ Draw Hammer Bro 
CODE_02DB99:        BB            TYX                       ;  | 
CODE_02DB9A:        20 FD DA      JSR.W HammerBroGfx        ;  | 
CODE_02DB9D:        FA            PLX                       ; / 
CODE_02DB9E:        A5 9D         LDA RAM_SpritesLocked     
CODE_02DBA0:        D0 6C         BNE Return02DC0E          
CODE_02DBA2:        20 1F D0      JSR.W SubOffscreen1Bnk2   
CODE_02DBA5:        A5 13         LDA RAM_FrameCounter      
CODE_02DBA7:        29 01         AND.B #$01                
CODE_02DBA9:        D0 2C         BNE CODE_02DBD7           
CODE_02DBAB:        BD 34 15      LDA.W $1534,X             
CODE_02DBAE:        29 01         AND.B #$01                
CODE_02DBB0:        A8            TAY                       
CODE_02DBB1:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02DBB3:        18            CLC                       
CODE_02DBB4:        79 54 DB      ADC.W DATA_02DB54,Y       
CODE_02DBB7:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02DBB9:        D9 56 DB      CMP.W DATA_02DB56,Y       
CODE_02DBBC:        D0 03         BNE CODE_02DBC1           
CODE_02DBBE:        FE 34 15      INC.W $1534,X             
CODE_02DBC1:        BD 1C 15      LDA.W $151C,X             
CODE_02DBC4:        29 01         AND.B #$01                
CODE_02DBC6:        A8            TAY                       
CODE_02DBC7:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02DBC9:        18            CLC                       
CODE_02DBCA:        79 58 DB      ADC.W DATA_02DB58,Y       
CODE_02DBCD:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02DBCF:        D9 5A DB      CMP.W DATA_02DB5A,Y       
CODE_02DBD2:        D0 03         BNE CODE_02DBD7           
CODE_02DBD4:        FE 1C 15      INC.W $151C,X             
CODE_02DBD7:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02DBDA:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02DBDD:        9D 28 15      STA.W $1528,X             
CODE_02DBE0:        22 4F B4 01   JSL.L InvisBlkMainRt      
CODE_02DBE4:        BD 58 15      LDA.W $1558,X             
CODE_02DBE7:        F0 25         BEQ Return02DC0E          
CODE_02DBE9:        A9 01         LDA.B #$01                
CODE_02DBEB:        95 C2         STA RAM_SpriteState,X     
CODE_02DBED:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02DBF0:        A5 0F         LDA $0F                   
CODE_02DBF2:        C9 08         CMP.B #$08                
CODE_02DBF4:        30 02         BMI CODE_02DBF8           
CODE_02DBF6:        F6 C2         INC RAM_SpriteState,X     
CODE_02DBF8:        BC 94 15      LDY.W $1594,X             
CODE_02DBFB:        30 11         BMI Return02DC0E          
CODE_02DBFD:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_02DBFF:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02DC02:        A9 C0         LDA.B #$C0                
CODE_02DC04:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_02DC07:        DA            PHX                       
CODE_02DC08:        BB            TYX                       
CODE_02DC09:        22 6F AB 01   JSL.L CODE_01AB6F         
CODE_02DC0D:        FA            PLX                       
Return02DC0E:       60            RTS                       ; Return 


DATA_02DC0F:                      .db $00,$10,$F2,$1E,$00,$10,$FA,$1E
DATA_02DC17:                      .db $00,$00,$F6,$F6,$00,$00,$FE,$FE
HmrBroPlatTiles:                  .db $40,$40,$C6,$C6,$40,$40,$5D,$5D
DATA_02DC27:                      .db $32,$32,$72,$32,$32,$32,$72,$32
DATA_02DC2F:                      .db $02,$02,$02,$02,$02,$02,$00,$00
DATA_02DC37:                      .db $00,$04,$06,$08,$08,$06,$04,$00

FlyingPlatformGfx:  20 78 D3      JSR.W GetDrawInfo2        
CODE_02DC42:        B5 C2         LDA RAM_SpriteState,X     
CODE_02DC44:        85 07         STA $07                   
CODE_02DC46:        BD 58 15      LDA.W $1558,X             
CODE_02DC49:        4A            LSR                       
CODE_02DC4A:        A8            TAY                       
CODE_02DC4B:        B9 37 DC      LDA.W DATA_02DC37,Y       
CODE_02DC4E:        85 05         STA $05                   
CODE_02DC50:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02DC53:        DA            PHX                       
CODE_02DC54:        A5 14         LDA RAM_FrameCounterB     
CODE_02DC56:        4A            LSR                       
CODE_02DC57:        29 04         AND.B #$04                
CODE_02DC59:        85 02         STA $02                   
CODE_02DC5B:        A2 03         LDX.B #$03                
CODE_02DC5D:        86 06         STX $06                   
CODE_02DC5F:        8A            TXA                       
CODE_02DC60:        05 02         ORA $02                   
CODE_02DC62:        AA            TAX                       
CODE_02DC63:        A5 00         LDA $00                   
CODE_02DC65:        18            CLC                       
CODE_02DC66:        7D 0F DC      ADC.W DATA_02DC0F,X       
CODE_02DC69:        99 00 03      STA.W OAM_DispX,Y         
CODE_02DC6C:        A5 01         LDA $01                   
CODE_02DC6E:        18            CLC                       
CODE_02DC6F:        7D 17 DC      ADC.W DATA_02DC17,X       
CODE_02DC72:        99 01 03      STA.W OAM_DispY,Y         
CODE_02DC75:        DA            PHX                       
CODE_02DC76:        A6 06         LDX $06                   
CODE_02DC78:        E0 02         CPX.B #$02                
CODE_02DC7A:        B0 0E         BCS CODE_02DC8A           
CODE_02DC7C:        E8            INX                       
CODE_02DC7D:        E4 07         CPX $07                   
CODE_02DC7F:        D0 09         BNE CODE_02DC8A           
CODE_02DC81:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_02DC84:        38            SEC                       
CODE_02DC85:        E5 05         SBC $05                   
CODE_02DC87:        99 01 03      STA.W OAM_DispY,Y         
CODE_02DC8A:        FA            PLX                       
CODE_02DC8B:        BD 1F DC      LDA.W HmrBroPlatTiles,X   
CODE_02DC8E:        99 02 03      STA.W OAM_Tile,Y          
CODE_02DC91:        BD 27 DC      LDA.W DATA_02DC27,X       
CODE_02DC94:        99 03 03      STA.W OAM_Prop,Y          
CODE_02DC97:        5A            PHY                       
CODE_02DC98:        98            TYA                       
CODE_02DC99:        4A            LSR                       
CODE_02DC9A:        4A            LSR                       
CODE_02DC9B:        A8            TAY                       
CODE_02DC9C:        BD 2F DC      LDA.W DATA_02DC2F,X       
CODE_02DC9F:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02DCA2:        7A            PLY                       
CODE_02DCA3:        C8            INY                       
CODE_02DCA4:        C8            INY                       
CODE_02DCA5:        C8            INY                       
CODE_02DCA6:        C8            INY                       
CODE_02DCA7:        A6 06         LDX $06                   
CODE_02DCA9:        CA            DEX                       
CODE_02DCAA:        10 B1         BPL CODE_02DC5D           
CODE_02DCAC:        4C 44 DB      JMP.W CODE_02DB44         

SumoBrotherMain:    8B            PHB                       
CODE_02DCB0:        4B            PHK                       
CODE_02DCB1:        AB            PLB                       
CODE_02DCB2:        20 B7 DC      JSR.W CODE_02DCB7         
CODE_02DCB5:        AB            PLB                       
Return02DCB6:       6B            RTL                       ; Return 

CODE_02DCB7:        20 3E DE      JSR.W SumoBroGfx          
CODE_02DCBA:        A5 9D         LDA RAM_SpritesLocked     
CODE_02DCBC:        D0 2B         BNE Return02DCE9          
CODE_02DCBE:        BD C8 14      LDA.W $14C8,X             
CODE_02DCC1:        C9 08         CMP.B #$08                
CODE_02DCC3:        D0 24         BNE Return02DCE9          
CODE_02DCC5:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02DCC8:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_02DCCC:        22 2A 80 01   JSL.L UpdateSpritePos     
CODE_02DCD0:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02DCD3:        29 04         AND.B #$04                ;  | 
CODE_02DCD5:        F0 04         BEQ CODE_02DCDB           ; / 
CODE_02DCD7:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_02DCD9:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_02DCDB:        B5 C2         LDA RAM_SpriteState,X     
CODE_02DCDD:        22 DF 86 00   JSL.L ExecutePtr          

SumoBroPtrs:           EA DC      .dw CODE_02DCEA           
                       FF DC      .dw CODE_02DCFF           
                       0E DD      .dw CODE_02DD0E           
                       4B DD      .dw CODE_02DD4B           

Return02DCE9:       60            RTS                       ; Return 

CODE_02DCEA:        A9 01         LDA.B #$01                
CODE_02DCEC:        9D 02 16      STA.W $1602,X             
CODE_02DCEF:        BD 40 15      LDA.W $1540,X             
CODE_02DCF2:        D0 0A         BNE Return02DCFE          
CODE_02DCF4:        9E 02 16      STZ.W $1602,X             
CODE_02DCF7:        A9 03         LDA.B #$03                
CODE_02DCF9:        9D 40 15      STA.W $1540,X             
CODE_02DCFC:        F6 C2         INC RAM_SpriteState,X     
Return02DCFE:       60            RTS                       ; Return 

CODE_02DCFF:        BD 40 15      LDA.W $1540,X             
CODE_02DD02:        D0 07         BNE Return02DD0B          
CODE_02DD04:        FE 02 16      INC.W $1602,X             
CODE_02DD07:        A9 03         LDA.B #$03                
CODE_02DD09:        80 EE         BRA CODE_02DCF9           

Return02DD0B:       60            RTS                       ; Return 


DATA_02DD0C:                      .db $20,$E0

CODE_02DD0E:        BD 58 15      LDA.W $1558,X             
CODE_02DD11:        D0 32         BNE CODE_02DD45           
CODE_02DD13:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02DD16:        B9 0C DD      LDA.W DATA_02DD0C,Y       
CODE_02DD19:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02DD1B:        BD 40 15      LDA.W $1540,X             
CODE_02DD1E:        D0 24         BNE Return02DD44          
CODE_02DD20:        FE 70 15      INC.W $1570,X             
CODE_02DD23:        BD 70 15      LDA.W $1570,X             
CODE_02DD26:        29 01         AND.B #$01                
CODE_02DD28:        D0 05         BNE CODE_02DD2F           
CODE_02DD2A:        A9 20         LDA.B #$20                
CODE_02DD2C:        9D 58 15      STA.W $1558,X             
CODE_02DD2F:        BD 70 15      LDA.W $1570,X             
CODE_02DD32:        C9 03         CMP.B #$03                
CODE_02DD34:        D0 07         BNE CODE_02DD3D           
CODE_02DD36:        9E 70 15      STZ.W $1570,X             
CODE_02DD39:        A9 70         LDA.B #$70                
CODE_02DD3B:        80 BC         BRA CODE_02DCF9           

CODE_02DD3D:        A9 03         LDA.B #$03                
CODE_02DD3F:        20 F9 DC      JSR.W CODE_02DCF9         
CODE_02DD42:        74 C2         STZ RAM_SpriteState,X     
Return02DD44:       60            RTS                       ; Return 

CODE_02DD45:        A9 01         LDA.B #$01                
CODE_02DD47:        9D 02 16      STA.W $1602,X             
Return02DD4A:       60            RTS                       ; Return 

CODE_02DD4B:        A9 03         LDA.B #$03                
CODE_02DD4D:        BC 40 15      LDY.W $1540,X             
CODE_02DD50:        F0 2F         BEQ CODE_02DD81           
CODE_02DD52:        C0 2E         CPY.B #$2E                
CODE_02DD54:        D0 19         BNE CODE_02DD6F           
CODE_02DD56:        48            PHA                       
CODE_02DD57:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_02DD5A:        1D 6C 18      ORA.W RAM_OffscreenVert,X 
CODE_02DD5D:        D0 0F         BNE CODE_02DD6E           
CODE_02DD5F:        A9 30         LDA.B #$30                ; \ Set ground shake timer 
CODE_02DD61:        8D 87 18      STA.W RAM_ShakeGrndTimer  ; / 
CODE_02DD64:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_02DD66:        8D FC 1D      STA.W $1DFC               ; / 
CODE_02DD69:        5A            PHY                       
CODE_02DD6A:        20 8F DD      JSR.W GenSumoLightning    
CODE_02DD6D:        7A            PLY                       
CODE_02DD6E:        68            PLA                       
CODE_02DD6F:        C0 30         CPY.B #$30                
CODE_02DD71:        90 0A         BCC CODE_02DD7D           
CODE_02DD73:        C0 50         CPY.B #$50                
CODE_02DD75:        B0 06         BCS CODE_02DD7D           
CODE_02DD77:        1A            INC A                     
CODE_02DD78:        C0 44         CPY.B #$44                
CODE_02DD7A:        B0 01         BCS CODE_02DD7D           
CODE_02DD7C:        1A            INC A                     
CODE_02DD7D:        9D 02 16      STA.W $1602,X             
Return02DD80:       60            RTS                       ; Return 

CODE_02DD81:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02DD84:        49 01         EOR.B #$01                
CODE_02DD86:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02DD89:        A9 40         LDA.B #$40                
CODE_02DD8B:        20 3F DD      JSR.W CODE_02DD3F         
Return02DD8E:       60            RTS                       ; Return 

GenSumoLightning:   22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_02DD93:        30 30         BMI Return02DDC5          ; / 
CODE_02DD95:        A9 2B         LDA.B #$2B                ; \ Sprite = Lightning 
CODE_02DD97:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
CODE_02DD9A:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02DD9C:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02DD9F:        B5 E4         LDA RAM_SpriteXLo,X       ; \ Lightning X position = Sprite X position + #$04 
CODE_02DDA1:        69 04         ADC.B #$04                ;  | 
CODE_02DDA3:        99 E4 00      STA.W RAM_SpriteXLo,Y     ;  | 
CODE_02DDA6:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_02DDA9:        69 00         ADC.B #$00                ;  | 
CODE_02DDAB:        99 E0 14      STA.W RAM_SpriteXHi,Y     ; / 
CODE_02DDAE:        B5 D8         LDA RAM_SpriteYLo,X       ; \ Lightning Y position = Sprite Y position 
CODE_02DDB0:        99 D8 00      STA.W RAM_SpriteYLo,Y     ;  | 
CODE_02DDB3:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_02DDB6:        99 D4 14      STA.W RAM_SpriteYHi,Y     ; / 
CODE_02DDB9:        DA            PHX                       
CODE_02DDBA:        BB            TYX                       ; \ Reset sprite tables 
CODE_02DDBB:        22 D2 F7 07   JSL.L InitSpriteTables    ; / 
CODE_02DDBF:        A9 10         LDA.B #$10                ; \ $1FE2,x = #$10 
CODE_02DDC1:        9D E2 1F      STA.W $1FE2,X             ; / Time to not interact with ground?? 
CODE_02DDC4:        FA            PLX                       
Return02DDC5:       60            RTS                       ; Return 


SumoBrosDispX:                    .db $FF,$07,$FC,$04,$FF,$07,$FC,$04
                                  .db $FF,$FF,$FC,$04,$FF,$FF,$FC,$04
                                  .db $02,$02,$F4,$04,$02,$02,$F4,$04
                                  .db $09,$01,$04,$FC,$09,$01,$04,$FC
                                  .db $01,$01,$04,$FC,$01,$01,$04,$FC
                                  .db $FF,$FF,$0C,$FC,$FF,$FF,$0C,$FC
SumoBrosDispY:                    .db $F8,$F8,$00,$00,$F8,$F8,$00,$00
                                  .db $F8,$F0,$00,$00,$F8,$F8,$00,$00
                                  .db $F8,$F8,$01,$00,$F8,$F8,$FF,$00
SumoBrosTiles:                    .db $98,$99,$A7,$A8,$98,$99,$AA,$AB
                                  .db $8A,$66,$AA,$AB,$EE,$EE,$C5,$C6
                                  .db $80,$80,$C1,$C3,$80,$80,$C1,$C3
SumoBrosTileSize:                 .db $00,$00,$02,$02,$00,$00,$02,$02
                                  .db $02,$02,$02,$02,$02,$02,$02,$02
                                  .db $02,$02,$02,$02,$02,$02,$02,$02

SumoBroGfx:         20 78 D3      JSR.W GetDrawInfo2        
CODE_02DE41:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02DE44:        4A            LSR                       
CODE_02DE45:        6A            ROR                       
CODE_02DE46:        6A            ROR                       
CODE_02DE47:        29 40         AND.B #$40                
CODE_02DE49:        49 40         EOR.B #$40                
CODE_02DE4B:        85 02         STA $02                   
CODE_02DE4D:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02DE50:        BD 02 16      LDA.W $1602,X             
CODE_02DE53:        0A            ASL                       
CODE_02DE54:        0A            ASL                       
CODE_02DE55:        DA            PHX                       
CODE_02DE56:        AA            TAX                       
CODE_02DE57:        A9 03         LDA.B #$03                
CODE_02DE59:        85 05         STA $05                   
CODE_02DE5B:        DA            PHX                       
CODE_02DE5C:        A5 02         LDA $02                   
CODE_02DE5E:        F0 05         BEQ CODE_02DE65           
CODE_02DE60:        8A            TXA                       
CODE_02DE61:        18            CLC                       
CODE_02DE62:        69 18         ADC.B #$18                
CODE_02DE64:        AA            TAX                       
CODE_02DE65:        A5 00         LDA $00                   
CODE_02DE67:        18            CLC                       
CODE_02DE68:        7D C6 DD      ADC.W SumoBrosDispX,X     
CODE_02DE6B:        99 00 03      STA.W OAM_DispX,Y         
CODE_02DE6E:        FA            PLX                       
CODE_02DE6F:        A5 01         LDA $01                   
CODE_02DE71:        18            CLC                       
CODE_02DE72:        7D F6 DD      ADC.W SumoBrosDispY,X     
CODE_02DE75:        99 01 03      STA.W OAM_DispY,Y         
CODE_02DE78:        BD 0E DE      LDA.W SumoBrosTiles,X     
CODE_02DE7B:        99 02 03      STA.W OAM_Tile,Y          
CODE_02DE7E:        C9 66         CMP.B #$66                
CODE_02DE80:        38            SEC                       
CODE_02DE81:        D0 01         BNE CODE_02DE84           
ADDR_02DE83:        18            CLC                       
CODE_02DE84:        A9 34         LDA.B #$34                
CODE_02DE86:        65 02         ADC $02                   
CODE_02DE88:        99 03 03      STA.W OAM_Prop,Y          
CODE_02DE8B:        5A            PHY                       
CODE_02DE8C:        98            TYA                       
CODE_02DE8D:        4A            LSR                       
CODE_02DE8E:        4A            LSR                       
CODE_02DE8F:        A8            TAY                       
CODE_02DE90:        BD 26 DE      LDA.W SumoBrosTileSize,X  
CODE_02DE93:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02DE96:        7A            PLY                       
CODE_02DE97:        C8            INY                       
CODE_02DE98:        C8            INY                       
CODE_02DE99:        C8            INY                       
CODE_02DE9A:        C8            INY                       
CODE_02DE9B:        E8            INX                       
CODE_02DE9C:        C6 05         DEC $05                   
CODE_02DE9E:        10 BB         BPL CODE_02DE5B           
CODE_02DEA0:        FA            PLX                       
CODE_02DEA1:        A0 FF         LDY.B #$FF                
CODE_02DEA3:        A9 03         LDA.B #$03                
CODE_02DEA5:        4C A7 B7      JMP.W CODE_02B7A7         

SumosLightningMain: 8B            PHB                       
CODE_02DEA9:        4B            PHK                       
CODE_02DEAA:        AB            PLB                       
CODE_02DEAB:        20 B0 DE      JSR.W CODE_02DEB0         
CODE_02DEAE:        AB            PLB                       
Return02DEAF:       6B            RTL                       ; Return 

CODE_02DEB0:        BD 40 15      LDA.W $1540,X             
CODE_02DEB3:        D0 47         BNE CODE_02DEFC           
CODE_02DEB5:        A9 30         LDA.B #$30                
CODE_02DEB7:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02DEB9:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02DEBC:        BD E2 1F      LDA.W $1FE2,X             
CODE_02DEBF:        D0 29         BNE CODE_02DEEA           
CODE_02DEC1:        22 38 91 01   JSL.L CODE_019138         
CODE_02DEC5:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02DEC8:        29 04         AND.B #$04                ;  | 
CODE_02DECA:        F0 1E         BEQ CODE_02DEEA           ; / 
CODE_02DECC:        A9 17         LDA.B #$17                ; \ Play sound effect 
CODE_02DECE:        8D FC 1D      STA.W $1DFC               ; / 
CODE_02DED1:        A9 22         LDA.B #$22                
CODE_02DED3:        9D 40 15      STA.W $1540,X             
CODE_02DED6:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_02DED9:        1D 6C 18      ORA.W RAM_OffscreenVert,X 
CODE_02DEDC:        D0 0C         BNE CODE_02DEEA           
CODE_02DEDE:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02DEE0:        85 9A         STA RAM_BlockYLo          
CODE_02DEE2:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02DEE4:        85 98         STA RAM_BlockXLo          
CODE_02DEE6:        22 44 8A 02   JSL.L CODE_028A44         
CODE_02DEEA:        A9 00         LDA.B #$00                
CODE_02DEEC:        22 42 80 01   JSL.L GenericSprGfxRt0    
CODE_02DEF0:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02DEF3:        B9 07 03      LDA.W OAM_Tile2Prop,Y     
CODE_02DEF6:        49 C0         EOR.B #$C0                
CODE_02DEF8:        99 07 03      STA.W OAM_Tile2Prop,Y     
Return02DEFB:       60            RTS                       ; Return 

CODE_02DEFC:        85 02         STA $02                   
CODE_02DEFE:        C9 01         CMP.B #$01                
CODE_02DF00:        D0 03         BNE CODE_02DF05           
CODE_02DF02:        9E C8 14      STZ.W $14C8,X             
CODE_02DF05:        29 0F         AND.B #$0F                
CODE_02DF07:        C9 01         CMP.B #$01                
CODE_02DF09:        D0 16         BNE Return02DF21          
CODE_02DF0B:        8D B8 18      STA.W $18B8               
CODE_02DF0E:        20 2C DF      JSR.W CODE_02DF2C         
CODE_02DF11:        FE 70 15      INC.W $1570,X             
CODE_02DF14:        BD 70 15      LDA.W $1570,X             
CODE_02DF17:        C9 01         CMP.B #$01                
CODE_02DF19:        F0 06         BEQ Return02DF21          
CODE_02DF1B:        20 2C DF      JSR.W CODE_02DF2C         
CODE_02DF1E:        FE 70 15      INC.W $1570,X             
Return02DF21:       60            RTS                       ; Return 


DATA_02DF22:                      .db $FC,$0C,$EC,$1C,$DC

DATA_02DF27:                      .db $FF,$00,$FF,$00,$FF

CODE_02DF2C:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02DF2E:        85 00         STA $00                   
CODE_02DF30:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02DF33:        85 01         STA $01                   
CODE_02DF35:        A0 09         LDY.B #$09                
CODE_02DF37:        B9 92 18      LDA.W $1892,Y             
CODE_02DF3A:        F0 10         BEQ CODE_02DF4C           
CODE_02DF3C:        88            DEY                       
CODE_02DF3D:        10 F8         BPL CODE_02DF37           
CODE_02DF3F:        CE 1D 19      DEC.W $191D               
CODE_02DF42:        10 05         BPL CODE_02DF49           
CODE_02DF44:        A9 09         LDA.B #$09                
CODE_02DF46:        8D 1D 19      STA.W $191D               
CODE_02DF49:        AC 1D 19      LDY.W $191D               
CODE_02DF4C:        DA            PHX                       
CODE_02DF4D:        BD 70 15      LDA.W $1570,X             
CODE_02DF50:        AA            TAX                       
CODE_02DF51:        A5 00         LDA $00                   
CODE_02DF53:        18            CLC                       
CODE_02DF54:        7D 22 DF      ADC.W DATA_02DF22,X       
CODE_02DF57:        99 16 1E      STA.W $1E16,Y             
CODE_02DF5A:        A5 01         LDA $01                   
CODE_02DF5C:        7D 27 DF      ADC.W DATA_02DF27,X       
CODE_02DF5F:        99 3E 1E      STA.W $1E3E,Y             
CODE_02DF62:        FA            PLX                       
CODE_02DF63:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02DF65:        38            SEC                       
CODE_02DF66:        E9 10         SBC.B #$10                
CODE_02DF68:        99 02 1E      STA.W $1E02,Y             
CODE_02DF6B:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02DF6E:        38            SEC                       
CODE_02DF6F:        E9 00         SBC.B #$00                
CODE_02DF71:        99 2A 1E      STA.W $1E2A,Y             
CODE_02DF74:        A9 7F         LDA.B #$7F                
CODE_02DF76:        99 4A 0F      STA.W $0F4A,Y             
CODE_02DF79:        B9 16 1E      LDA.W $1E16,Y             
CODE_02DF7C:        C5 1A         CMP RAM_ScreenBndryXLo    
CODE_02DF7E:        B9 3E 1E      LDA.W $1E3E,Y             
CODE_02DF81:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_02DF83:        D0 05         BNE Return02DF8A          
CODE_02DF85:        A9 06         LDA.B #$06                
CODE_02DF87:        99 92 18      STA.W $1892,Y             
Return02DF8A:       60            RTS                       ; Return 

VolcanoLotusMain:   8B            PHB                       
CODE_02DF8C:        4B            PHK                       
CODE_02DF8D:        AB            PLB                       
CODE_02DF8E:        20 93 DF      JSR.W CODE_02DF93         
CODE_02DF91:        AB            PLB                       
Return02DF92:       6B            RTL                       ; Return 

CODE_02DF93:        20 0B E0      JSR.W VolcanoLotusGfx     
CODE_02DF96:        A5 9D         LDA RAM_SpritesLocked     
CODE_02DF98:        D0 2E         BNE Return02DFC8          
CODE_02DF9A:        9E 1C 15      STZ.W $151C,X             
CODE_02DF9D:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_02DFA1:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02DFA4:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02DFA7:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02DFA9:        C9 40         CMP.B #$40                
CODE_02DFAB:        10 02         BPL CODE_02DFAF           
CODE_02DFAD:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_02DFAF:        22 38 91 01   JSL.L CODE_019138         
CODE_02DFB3:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02DFB6:        29 04         AND.B #$04                ;  | 
CODE_02DFB8:        F0 02         BEQ CODE_02DFBC           ; / 
CODE_02DFBA:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_02DFBC:        B5 C2         LDA RAM_SpriteState,X     
CODE_02DFBE:        22 DF 86 00   JSL.L ExecutePtr          

VolcanoLotusPtrs:      C9 DF      .dw CODE_02DFC9           
                       DF DF      .dw CODE_02DFDF           
                       EF DF      .dw CODE_02DFEF           

Return02DFC8:       60            RTS                       ; Return 

CODE_02DFC9:        BD 40 15      LDA.W $1540,X             
CODE_02DFCC:        D0 08         BNE CODE_02DFD6           
CODE_02DFCE:        A9 40         LDA.B #$40                
CODE_02DFD0:        9D 40 15      STA.W $1540,X             
CODE_02DFD3:        F6 C2         INC RAM_SpriteState,X     
Return02DFD5:       60            RTS                       ; Return 

CODE_02DFD6:        4A            LSR                       
CODE_02DFD7:        4A            LSR                       
CODE_02DFD8:        4A            LSR                       
CODE_02DFD9:        29 01         AND.B #$01                
CODE_02DFDB:        9D 02 16      STA.W $1602,X             
Return02DFDE:       60            RTS                       ; Return 

CODE_02DFDF:        BD 40 15      LDA.W $1540,X             
CODE_02DFE2:        D0 04         BNE CODE_02DFE8           
CODE_02DFE4:        A9 40         LDA.B #$40                
CODE_02DFE6:        80 E8         BRA CODE_02DFD0           

CODE_02DFE8:        4A            LSR                       
CODE_02DFE9:        29 01         AND.B #$01                
CODE_02DFEB:        9D 1C 15      STA.W $151C,X             
Return02DFEE:       60            RTS                       ; Return 

CODE_02DFEF:        BD 40 15      LDA.W $1540,X             
CODE_02DFF2:        D0 07         BNE CODE_02DFFB           
CODE_02DFF4:        A9 80         LDA.B #$80                
CODE_02DFF6:        20 D0 DF      JSR.W CODE_02DFD0         
CODE_02DFF9:        74 C2         STZ RAM_SpriteState,X     
CODE_02DFFB:        C9 38         CMP.B #$38                
CODE_02DFFD:        D0 03         BNE CODE_02E002           
CODE_02DFFF:        20 79 E0      JSR.W CODE_02E079         
CODE_02E002:        A9 02         LDA.B #$02                
CODE_02E004:        9D 02 16      STA.W $1602,X             
Return02E007:       60            RTS                       ; Return 


VolcanoLotusTiles:                .db $8E,$9E,$E2

VolcanoLotusGfx:    20 7E E5      JSR.W MushroomScaleGfx    
CODE_02E00E:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02E011:        A9 CE         LDA.B #$CE                
CODE_02E013:        99 02 03      STA.W OAM_Tile,Y          
CODE_02E016:        99 06 03      STA.W OAM_Tile2,Y         
CODE_02E019:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_02E01C:        29 30         AND.B #$30                
CODE_02E01E:        09 0B         ORA.B #$0B                
CODE_02E020:        99 03 03      STA.W OAM_Prop,Y          
CODE_02E023:        09 40         ORA.B #$40                
CODE_02E025:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02E028:        B9 00 03      LDA.W OAM_DispX,Y         
CODE_02E02B:        18            CLC                       
CODE_02E02C:        69 08         ADC.B #$08                
CODE_02E02E:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_02E031:        18            CLC                       
CODE_02E032:        69 08         ADC.B #$08                
CODE_02E034:        99 0C 03      STA.W OAM_Tile4DispX,Y    
CODE_02E037:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_02E03A:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_02E03D:        99 0D 03      STA.W OAM_Tile4DispY,Y    
CODE_02E040:        DA            PHX                       
CODE_02E041:        BD 02 16      LDA.W $1602,X             
CODE_02E044:        AA            TAX                       
CODE_02E045:        BD 08 E0      LDA.W VolcanoLotusTiles,X 
CODE_02E048:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_02E04B:        1A            INC A                     
CODE_02E04C:        99 0E 03      STA.W OAM_Tile4,Y         
CODE_02E04F:        FA            PLX                       
CODE_02E050:        BD 1C 15      LDA.W $151C,X             
CODE_02E053:        C9 01         CMP.B #$01                
CODE_02E055:        A9 39         LDA.B #$39                
CODE_02E057:        90 02         BCC CODE_02E05B           
CODE_02E059:        A9 35         LDA.B #$35                
CODE_02E05B:        99 0B 03      STA.W OAM_Tile3Prop,Y     
CODE_02E05E:        99 0F 03      STA.W OAM_Tile4Prop,Y     
CODE_02E061:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_02E064:        18            CLC                       
CODE_02E065:        69 08         ADC.B #$08                
CODE_02E067:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_02E06A:        A0 00         LDY.B #$00                
CODE_02E06C:        A9 01         LDA.B #$01                
CODE_02E06E:        4C A7 B7      JMP.W CODE_02B7A7         


DATA_02E071:                      .db $10,$F0,$06,$FA

DATA_02E075:                      .db $EC,$EC,$E8,$E8

CODE_02E079:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_02E07C:        1D 6C 18      ORA.W RAM_OffscreenVert,X 
CODE_02E07F:        D0 43         BNE Return02E0C4          
CODE_02E081:        A9 03         LDA.B #$03                
CODE_02E083:        85 00         STA $00                   
CODE_02E085:        A0 07         LDY.B #$07                ; \ Find a free extended sprite slot 
CODE_02E087:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   ;  | 
CODE_02E08A:        F0 04         BEQ CODE_02E090           ;  | 
CODE_02E08C:        88            DEY                       ;  | 
CODE_02E08D:        10 F8         BPL CODE_02E087           ;  | 
Return02E08F:       60            RTS                       ; / Return if no free slots 

CODE_02E090:        A9 0C         LDA.B #$0C                ; \ Extended sprite = Volcano Lotus fire 
CODE_02E092:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_02E095:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02E097:        18            CLC                       
CODE_02E098:        69 04         ADC.B #$04                
CODE_02E09A:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
CODE_02E09D:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02E0A0:        69 00         ADC.B #$00                
CODE_02E0A2:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
CODE_02E0A5:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02E0A7:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
CODE_02E0AA:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02E0AD:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
CODE_02E0B0:        DA            PHX                       
CODE_02E0B1:        A6 00         LDX $00                   
CODE_02E0B3:        BD 71 E0      LDA.W DATA_02E071,X       
CODE_02E0B6:        99 47 17      STA.W RAM_ExSprSpeedX,Y   
CODE_02E0B9:        BD 75 E0      LDA.W DATA_02E075,X       
CODE_02E0BC:        99 3D 17      STA.W RAM_ExSprSpeedY,Y   
CODE_02E0BF:        FA            PLX                       
CODE_02E0C0:        C6 00         DEC $00                   
CODE_02E0C2:        10 C1         BPL CODE_02E085           
Return02E0C4:       60            RTS                       ; Return 

JumpingPiranhaMain: 8B            PHB                       
CODE_02E0C6:        4B            PHK                       
CODE_02E0C7:        AB            PLB                       
CODE_02E0C8:        20 CD E0      JSR.W CODE_02E0CD         
CODE_02E0CB:        AB            PLB                       
Return02E0CC:       6B            RTL                       ; Return 

CODE_02E0CD:        22 8B F7 07   JSL.L LoadSpriteTables    
CODE_02E0D1:        A5 64         LDA $64                   
CODE_02E0D3:        48            PHA                       
CODE_02E0D4:        A9 10         LDA.B #$10                
CODE_02E0D6:        85 64         STA $64                   
CODE_02E0D8:        BD 70 15      LDA.W $1570,X             
CODE_02E0DB:        29 08         AND.B #$08                
CODE_02E0DD:        4A            LSR                       
CODE_02E0DE:        4A            LSR                       
CODE_02E0DF:        49 02         EOR.B #$02                
CODE_02E0E1:        9D 02 16      STA.W $1602,X             
CODE_02E0E4:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_02E0E8:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_02E0EB:        18            CLC                       
CODE_02E0EC:        69 04         ADC.B #$04                
CODE_02E0EE:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_02E0F1:        BD 1C 15      LDA.W $151C,X             
CODE_02E0F4:        29 04         AND.B #$04                
CODE_02E0F6:        4A            LSR                       
CODE_02E0F7:        4A            LSR                       
CODE_02E0F8:        1A            INC A                     
CODE_02E0F9:        9D 02 16      STA.W $1602,X             
CODE_02E0FC:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02E0FE:        48            PHA                       
CODE_02E0FF:        18            CLC                       
CODE_02E100:        69 08         ADC.B #$08                
CODE_02E102:        95 D8         STA RAM_SpriteYLo,X       
CODE_02E104:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02E107:        48            PHA                       
CODE_02E108:        69 00         ADC.B #$00                
CODE_02E10A:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02E10D:        A9 0A         LDA.B #$0A                
CODE_02E10F:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_02E112:        A9 01         LDA.B #$01                
CODE_02E114:        22 42 80 01   JSL.L GenericSprGfxRt0    
CODE_02E118:        68            PLA                       
CODE_02E119:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02E11C:        68            PLA                       
CODE_02E11D:        95 D8         STA RAM_SpriteYLo,X       
CODE_02E11F:        68            PLA                       
CODE_02E120:        85 64         STA $64                   
CODE_02E122:        A5 9D         LDA RAM_SpritesLocked     
CODE_02E124:        D0 32         BNE Return02E158          
CODE_02E126:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02E129:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_02E12D:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02E130:        B5 C2         LDA RAM_SpriteState,X     
CODE_02E132:        22 DF 86 00   JSL.L ExecutePtr          

JumpingPiranhaPtrs:    3C E1      .dw CODE_02E13C           
                       59 E1      .dw CODE_02E159           
                       77 E1      .dw CODE_02E177           

CODE_02E13C:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_02E13E:        BD 40 15      LDA.W $1540,X             
CODE_02E141:        D0 15         BNE Return02E158          
CODE_02E143:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02E146:        A5 0F         LDA $0F                   
CODE_02E148:        18            CLC                       
CODE_02E149:        69 1B         ADC.B #$1B                
CODE_02E14B:        C9 37         CMP.B #$37                
CODE_02E14D:        90 09         BCC Return02E158          
CODE_02E14F:        A9 C0         LDA.B #$C0                
CODE_02E151:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02E153:        F6 C2         INC RAM_SpriteState,X     
CODE_02E155:        9E 02 16      STZ.W $1602,X             
Return02E158:       60            RTS                       ; Return 

CODE_02E159:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02E15B:        30 04         BMI CODE_02E161           
ADDR_02E15D:        C9 40         CMP.B #$40                
ADDR_02E15F:        B0 05         BCS CODE_02E166           
CODE_02E161:        18            CLC                       
CODE_02E162:        69 02         ADC.B #$02                
CODE_02E164:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02E166:        FE 70 15      INC.W $1570,X             
CODE_02E169:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02E16B:        C9 F0         CMP.B #$F0                
CODE_02E16D:        30 07         BMI Return02E176          
CODE_02E16F:        A9 50         LDA.B #$50                
CODE_02E171:        9D 40 15      STA.W $1540,X             
CODE_02E174:        F6 C2         INC RAM_SpriteState,X     
Return02E176:       60            RTS                       ; Return 

CODE_02E177:        FE 1C 15      INC.W $151C,X             
CODE_02E17A:        BD 40 15      LDA.W $1540,X             
CODE_02E17D:        D0 25         BNE CODE_02E1A4           
CODE_02E17F:        FE 70 15      INC.W $1570,X             
CODE_02E182:        A5 14         LDA RAM_FrameCounterB     
CODE_02E184:        29 03         AND.B #$03                
CODE_02E186:        D0 09         BNE CODE_02E191           
CODE_02E188:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02E18A:        C9 08         CMP.B #$08                
CODE_02E18C:        10 03         BPL CODE_02E191           
CODE_02E18E:        1A            INC A                     
CODE_02E18F:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02E191:        22 38 91 01   JSL.L CODE_019138         
CODE_02E195:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02E198:        29 04         AND.B #$04                ;  | 
CODE_02E19A:        F0 DA         BEQ Return02E176          ; / 
CODE_02E19C:        74 C2         STZ RAM_SpriteState,X     
CODE_02E19E:        A9 40         LDA.B #$40                
CODE_02E1A0:        9D 40 15      STA.W $1540,X             
Return02E1A3:       60            RTS                       ; Return 

CODE_02E1A4:        B4 9E         LDY RAM_SpriteNum,X       
CODE_02E1A6:        C0 50         CPY.B #$50                
CODE_02E1A8:        D0 4D         BNE CODE_02E1F7           
CODE_02E1AA:        9E 70 15      STZ.W $1570,X             
CODE_02E1AD:        C9 40         CMP.B #$40                
CODE_02E1AF:        D0 46         BNE CODE_02E1F7           
CODE_02E1B1:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_02E1B4:        1D 6C 18      ORA.W RAM_OffscreenVert,X 
CODE_02E1B7:        D0 3E         BNE CODE_02E1F7           
CODE_02E1B9:        A9 10         LDA.B #$10                
CODE_02E1BB:        20 C0 E1      JSR.W CODE_02E1C0         
CODE_02E1BE:        A9 F0         LDA.B #$F0                
CODE_02E1C0:        85 00         STA $00                   
CODE_02E1C2:        A0 07         LDY.B #$07                ; \ Find a free extended sprite slot 
CODE_02E1C4:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   ;  | 
CODE_02E1C7:        F0 04         BEQ CODE_02E1CD           ;  | 
CODE_02E1C9:        88            DEY                       ;  | 
CODE_02E1CA:        10 F8         BPL CODE_02E1C4           ;  | 
Return02E1CC:       60            RTS                       ; / Return if no free slots 

CODE_02E1CD:        A9 0B         LDA.B #$0B                ; \ Extended sprite = Piranha fireball 
CODE_02E1CF:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_02E1D2:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02E1D4:        18            CLC                       
CODE_02E1D5:        69 04         ADC.B #$04                
CODE_02E1D7:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
CODE_02E1DA:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02E1DD:        69 00         ADC.B #$00                
CODE_02E1DF:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
CODE_02E1E2:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02E1E4:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
CODE_02E1E7:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02E1EA:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
CODE_02E1ED:        A9 D0         LDA.B #$D0                
CODE_02E1EF:        99 3D 17      STA.W RAM_ExSprSpeedY,Y   
CODE_02E1F2:        A5 00         LDA $00                   
CODE_02E1F4:        99 47 17      STA.W RAM_ExSprSpeedX,Y   
CODE_02E1F7:        80 86         BRA CODE_02E17F           


DATA_02E1F9:                      .db $00,$00,$F0,$10

DATA_02E1FD:                      .db $F0,$10,$00,$00

DATA_02E201:                      .db $00,$03,$02,$00,$01,$03,$02,$00
                                  .db $00,$03,$02,$00,$00,$00,$00,$00
DATA_02E211:                      .db $01,$00,$03,$02

DirectionCoinsMain: 8B            PHB                       
CODE_02E216:        4B            PHK                       
CODE_02E217:        AB            PLB                       
CODE_02E218:        20 1D E2      JSR.W CODE_02E21D         
CODE_02E21B:        AB            PLB                       
Return02E21C:       6B            RTL                       ; Return 

CODE_02E21D:        A5 64         LDA $64                   
CODE_02E21F:        48            PHA                       
CODE_02E220:        BD 40 15      LDA.W $1540,X             
CODE_02E223:        C9 30         CMP.B #$30                
CODE_02E225:        90 04         BCC CODE_02E22B           
CODE_02E227:        A9 10         LDA.B #$10                
CODE_02E229:        85 64         STA $64                   
CODE_02E22B:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_02E22D:        48            PHA                       
CODE_02E22E:        18            CLC                       
CODE_02E22F:        69 01         ADC.B #$01                
CODE_02E231:        85 1C         STA RAM_ScreenBndryYLo    
CODE_02E233:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02E235:        48            PHA                       
CODE_02E236:        69 00         ADC.B #$00                
CODE_02E238:        85 1D         STA RAM_ScreenBndryYHi    
CODE_02E23A:        AD AD 14      LDA.W RAM_BluePowTimer    
CODE_02E23D:        D0 06         BNE CODE_02E245           
CODE_02E23F:        22 41 C6 01   JSL.L CoinSprGfx          
CODE_02E243:        80 14         BRA CODE_02E259           

CODE_02E245:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_02E249:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02E24C:        A9 2E         LDA.B #$2E                
CODE_02E24E:        99 02 03      STA.W OAM_Tile,Y          
CODE_02E251:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_02E254:        29 3F         AND.B #$3F                
CODE_02E256:        99 03 03      STA.W OAM_Prop,Y          
CODE_02E259:        68            PLA                       
CODE_02E25A:        85 1D         STA RAM_ScreenBndryYHi    
CODE_02E25C:        68            PLA                       
CODE_02E25D:        85 1C         STA RAM_ScreenBndryYLo    
CODE_02E25F:        68            PLA                       
CODE_02E260:        85 64         STA $64                   
CODE_02E262:        A5 9D         LDA RAM_SpritesLocked     
CODE_02E264:        D0 78         BNE CODE_02E2DE           
CODE_02E266:        A5 13         LDA RAM_FrameCounter      
CODE_02E268:        29 03         AND.B #$03                
CODE_02E26A:        D0 1C         BNE CODE_02E288           
CODE_02E26C:        CE 0C 19      DEC.W $190C               
CODE_02E26F:        D0 17         BNE CODE_02E288           
CODE_02E271:        9C 0C 19      STZ.W $190C               
CODE_02E274:        9E C8 14      STZ.W $14C8,X             
CODE_02E277:        AD AD 14      LDA.W RAM_BluePowTimer    
CODE_02E27A:        0D AE 14      ORA.W RAM_SilverPowTimer  
CODE_02E27D:        D0 08         BNE Return02E287          
CODE_02E27F:        AD DA 0D      LDA.W $0DDA               
CODE_02E282:        30 03         BMI Return02E287          
CODE_02E284:        8D FB 1D      STA.W $1DFB               ; / Change music 
Return02E287:       60            RTS                       ; Return 

CODE_02E288:        B4 C2         LDY RAM_SpriteState,X     
CODE_02E28A:        B9 F9 E1      LDA.W DATA_02E1F9,Y       
CODE_02E28D:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02E28F:        B9 FD E1      LDA.W DATA_02E1FD,Y       
CODE_02E292:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02E294:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02E297:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02E29A:        A5 15         LDA RAM_ControllerA       
CODE_02E29C:        29 0F         AND.B #$0F                
CODE_02E29E:        F0 10         BEQ CODE_02E2B0           
CODE_02E2A0:        A8            TAY                       
CODE_02E2A1:        B9 01 E2      LDA.W DATA_02E201,Y       
CODE_02E2A4:        A8            TAY                       
CODE_02E2A5:        B9 11 E2      LDA.W DATA_02E211,Y       
CODE_02E2A8:        D5 C2         CMP RAM_SpriteState,X     
CODE_02E2AA:        F0 04         BEQ CODE_02E2B0           
CODE_02E2AC:        98            TYA                       
CODE_02E2AD:        9D 1C 15      STA.W $151C,X             
CODE_02E2B0:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02E2B2:        29 0F         AND.B #$0F                
CODE_02E2B4:        85 00         STA $00                   
CODE_02E2B6:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02E2B8:        29 0F         AND.B #$0F                
CODE_02E2BA:        05 00         ORA $00                   
CODE_02E2BC:        D0 20         BNE CODE_02E2DE           
CODE_02E2BE:        BD 1C 15      LDA.W $151C,X             
CODE_02E2C1:        95 C2         STA RAM_SpriteState,X     
CODE_02E2C3:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $9A = Sprite X position 
CODE_02E2C5:        85 9A         STA RAM_BlockYLo          ;  | for block creation 
CODE_02E2C7:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_02E2CA:        85 9B         STA RAM_BlockYHi          ; / 
CODE_02E2CC:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $98 = Sprite Y position 
CODE_02E2CE:        85 98         STA RAM_BlockXLo          ;  | for block creation 
CODE_02E2D0:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_02E2D3:        85 99         STA RAM_BlockXHi          ; / 
CODE_02E2D5:        A9 06         LDA.B #$06                ; \ Block to generate = Coin 
CODE_02E2D7:        85 9C         STA RAM_BlockBlock        ; / 
CODE_02E2D9:        22 B0 BE 00   JSL.L GenerateTile        
Return02E2DD:       60            RTS                       ; Return 

CODE_02E2DE:        22 38 91 01   JSL.L CODE_019138         
CODE_02E2E2:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02E2E4:        D0 0D         BNE CODE_02E2F3           
CODE_02E2E6:        AD D7 18      LDA.W $18D7               
CODE_02E2E9:        D0 14         BNE CODE_02E2FF           
CODE_02E2EB:        AD 5F 18      LDA.W $185F               
CODE_02E2EE:        C9 25         CMP.B #$25                
CODE_02E2F0:        D0 0D         BNE CODE_02E2FF           
Return02E2F2:       60            RTS                       ; Return 

CODE_02E2F3:        AD 62 18      LDA.W $1862               
CODE_02E2F6:        D0 07         BNE CODE_02E2FF           
CODE_02E2F8:        AD 60 18      LDA.W $1860               
CODE_02E2FB:        C9 25         CMP.B #$25                
CODE_02E2FD:        F0 03         BEQ Return02E302          
CODE_02E2FF:        20 71 E2      JSR.W CODE_02E271         
Return02E302:       60            RTS                       ; Return 

GasBubbleMain:      8B            PHB                       
CODE_02E304:        4B            PHK                       
CODE_02E305:        AB            PLB                       
CODE_02E306:        20 11 E3      JSR.W CODE_02E311         
CODE_02E309:        AB            PLB                       
Return02E30A:       6B            RTL                       ; Return 


DATA_02E30B:                      .db $10,$F0

DATA_02E30D:                      .db $01,$FF

DATA_02E30F:                      .db $10,$F0

CODE_02E311:        20 AA E3      JSR.W GasBubbleGfx        
CODE_02E314:        A5 9D         LDA RAM_SpritesLocked     
CODE_02E316:        D0 39         BNE Return02E351          
CODE_02E318:        BD C8 14      LDA.W $14C8,X             
CODE_02E31B:        C9 08         CMP.B #$08                
CODE_02E31D:        D0 32         BNE Return02E351          
CODE_02E31F:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02E322:        B9 0B E3      LDA.W DATA_02E30B,Y       
CODE_02E325:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02E327:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02E32A:        A5 13         LDA RAM_FrameCounter      
CODE_02E32C:        29 03         AND.B #$03                
CODE_02E32E:        D0 14         BNE CODE_02E344           
CODE_02E330:        B5 C2         LDA RAM_SpriteState,X     
CODE_02E332:        29 01         AND.B #$01                
CODE_02E334:        A8            TAY                       
CODE_02E335:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02E337:        18            CLC                       
CODE_02E338:        79 0D E3      ADC.W DATA_02E30D,Y       
CODE_02E33B:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02E33D:        D9 0F E3      CMP.W DATA_02E30F,Y       
CODE_02E340:        D0 02         BNE CODE_02E344           
CODE_02E342:        F6 C2         INC RAM_SpriteState,X     
CODE_02E344:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02E347:        FE 70 15      INC.W $1570,X             
CODE_02E34A:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02E34D:        22 DC A7 01   JSL.L MarioSprInteract    
Return02E351:       60            RTS                       ; Return 


DATA_02E352:                      .db $00,$10,$20,$30,$00,$10,$20,$30
                                  .db $00,$10,$20,$30,$00,$10,$20,$30
DATA_02E362:                      .db $00,$00,$00,$00,$10,$10,$10,$10
                                  .db $20,$20,$20,$20,$30,$30,$30,$30
DATA_02E372:                      .db $80,$82,$84,$86,$A0,$A2,$A4,$A6
                                  .db $A0,$A2,$A4,$A6,$80,$82,$84,$86
DATA_02E382:                      .db $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B
                                  .db $BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB
DATA_02E392:                      .db $00,$00,$02,$02,$00,$00,$02,$02
                                  .db $01,$01,$03,$03,$01,$01,$03,$03
DATA_02E3A2:                      .db $00,$01,$02,$01

DATA_02E3A6:                      .db $02,$01,$00,$01

GasBubbleGfx:       20 78 D3      JSR.W GetDrawInfo2        
CODE_02E3AD:        BD 70 15      LDA.W $1570,X             
CODE_02E3B0:        4A            LSR                       
CODE_02E3B1:        4A            LSR                       
CODE_02E3B2:        4A            LSR                       
CODE_02E3B3:        29 03         AND.B #$03                
CODE_02E3B5:        A8            TAY                       
CODE_02E3B6:        B9 A2 E3      LDA.W DATA_02E3A2,Y       
CODE_02E3B9:        85 02         STA $02                   
CODE_02E3BB:        B9 A6 E3      LDA.W DATA_02E3A6,Y       
CODE_02E3BE:        85 03         STA $03                   
CODE_02E3C0:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02E3C3:        DA            PHX                       
CODE_02E3C4:        A2 0F         LDX.B #$0F                
CODE_02E3C6:        A5 00         LDA $00                   
CODE_02E3C8:        18            CLC                       
CODE_02E3C9:        7D 52 E3      ADC.W DATA_02E352,X       
CODE_02E3CC:        48            PHA                       
CODE_02E3CD:        BD 92 E3      LDA.W DATA_02E392,X       
CODE_02E3D0:        29 02         AND.B #$02                
CODE_02E3D2:        D0 06         BNE CODE_02E3DA           
CODE_02E3D4:        68            PLA                       
CODE_02E3D5:        18            CLC                       
CODE_02E3D6:        65 02         ADC $02                   
CODE_02E3D8:        80 04         BRA CODE_02E3DE           

CODE_02E3DA:        68            PLA                       
CODE_02E3DB:        38            SEC                       
CODE_02E3DC:        E5 02         SBC $02                   
CODE_02E3DE:        99 00 03      STA.W OAM_DispX,Y         
CODE_02E3E1:        A5 01         LDA $01                   
CODE_02E3E3:        18            CLC                       
CODE_02E3E4:        7D 62 E3      ADC.W DATA_02E362,X       
CODE_02E3E7:        48            PHA                       
CODE_02E3E8:        BD 92 E3      LDA.W DATA_02E392,X       
CODE_02E3EB:        29 01         AND.B #$01                
CODE_02E3ED:        D0 06         BNE CODE_02E3F5           
CODE_02E3EF:        68            PLA                       
CODE_02E3F0:        18            CLC                       
CODE_02E3F1:        65 03         ADC $03                   
CODE_02E3F3:        80 04         BRA CODE_02E3F9           

CODE_02E3F5:        68            PLA                       
CODE_02E3F6:        38            SEC                       
CODE_02E3F7:        E5 03         SBC $03                   
CODE_02E3F9:        99 01 03      STA.W OAM_DispY,Y         
CODE_02E3FC:        BD 72 E3      LDA.W DATA_02E372,X       
CODE_02E3FF:        99 02 03      STA.W OAM_Tile,Y          
CODE_02E402:        BD 82 E3      LDA.W DATA_02E382,X       
CODE_02E405:        99 03 03      STA.W OAM_Prop,Y          
CODE_02E408:        C8            INY                       
CODE_02E409:        C8            INY                       
CODE_02E40A:        C8            INY                       
CODE_02E40B:        C8            INY                       
CODE_02E40C:        CA            DEX                       
CODE_02E40D:        10 B7         BPL CODE_02E3C6           
CODE_02E40F:        FA            PLX                       
CODE_02E410:        A0 02         LDY.B #$02                
CODE_02E412:        A9 0F         LDA.B #$0F                
CODE_02E414:        4C A7 B7      JMP.W CODE_02B7A7         

ExplodingBlkMain:   8B            PHB                       
CODE_02E418:        4B            PHK                       
CODE_02E419:        AB            PLB                       
CODE_02E41A:        20 1F E4      JSR.W CODE_02E41F         
CODE_02E41D:        AB            PLB                       
Return02E41E:       6B            RTL                       ; Return 

CODE_02E41F:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_02E423:        A5 9D         LDA RAM_SpritesLocked     
CODE_02E425:        D0 3B         BNE Return02E462          
CODE_02E427:        80 04         BRA CODE_02E42D           

ADDR_02E429:        22 CF C0 02   JSL.L ADDR_02C0CF         ; Unreachable instruction 
CODE_02E42D:        A0 00         LDY.B #$00                
CODE_02E42F:        FE 70 15      INC.W $1570,X             
CODE_02E432:        BD 70 15      LDA.W $1570,X             
CODE_02E435:        29 40         AND.B #$40                
CODE_02E437:        F0 0B         BEQ CODE_02E444           
CODE_02E439:        A0 04         LDY.B #$04                
CODE_02E43B:        BD 70 15      LDA.W $1570,X             
CODE_02E43E:        29 04         AND.B #$04                
CODE_02E440:        F0 02         BEQ CODE_02E444           
CODE_02E442:        A0 FC         LDY.B #$FC                
CODE_02E444:        94 B6         STY RAM_SpriteSpeedX,X    
CODE_02E446:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02E449:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_02E44D:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02E450:        A5 0F         LDA $0F                   
CODE_02E452:        18            CLC                       
CODE_02E453:        69 60         ADC.B #$60                
CODE_02E455:        C9 C0         CMP.B #$C0                
CODE_02E457:        B0 09         BCS Return02E462          
CODE_02E459:        BC A0 15      LDY.W RAM_OffscreenHorz,X 
CODE_02E45C:        D0 04         BNE Return02E462          
CODE_02E45E:        22 63 E4 02   JSL.L CODE_02E463         
Return02E462:       60            RTS                       ; Return 

CODE_02E463:        B5 C2         LDA RAM_SpriteState,X     
CODE_02E465:        95 9E         STA RAM_SpriteNum,X       
CODE_02E467:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02E46B:        A9 D0         LDA.B #$D0                
CODE_02E46D:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02E46F:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02E472:        98            TYA                       
CODE_02E473:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02E476:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02E478:        85 9A         STA RAM_BlockYLo          
CODE_02E47A:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02E47D:        85 9B         STA RAM_BlockYHi          
CODE_02E47F:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02E481:        85 98         STA RAM_BlockXLo          
CODE_02E483:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02E486:        85 99         STA RAM_BlockXHi          
CODE_02E488:        8B            PHB                       
CODE_02E489:        A9 02         LDA.B #$02                
CODE_02E48B:        48            PHA                       
CODE_02E48C:        AB            PLB                       
CODE_02E48D:        A9 00         LDA.B #$00                
CODE_02E48F:        22 63 86 02   JSL.L ShatterBlock        
CODE_02E493:        AB            PLB                       
Return02E494:       6B            RTL                       ; Return 

ScalePlatformMain:  BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_02E498:        48            PHA                       
CODE_02E499:        8B            PHB                       
CODE_02E49A:        4B            PHK                       
CODE_02E49B:        AB            PLB                       
CODE_02E49C:        20 A5 E4      JSR.W CODE_02E4A5         
CODE_02E49F:        AB            PLB                       
CODE_02E4A0:        68            PLA                       
CODE_02E4A1:        9D EA 15      STA.W RAM_SprOAMIndex,X   
Return02E4A4:       6B            RTL                       ; Return 

CODE_02E4A5:        20 1B D0      JSR.W SubOffscreen2Bnk2   
CODE_02E4A8:        9C 5E 18      STZ.W $185E               
CODE_02E4AB:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02E4AD:        48            PHA                       
CODE_02E4AE:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02E4B1:        48            PHA                       
CODE_02E4B2:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02E4B4:        48            PHA                       
CODE_02E4B5:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02E4B8:        48            PHA                       
CODE_02E4B9:        BD 1C 15      LDA.W $151C,X             
CODE_02E4BC:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02E4BF:        BD 34 15      LDA.W $1534,X             
CODE_02E4C2:        95 D8         STA RAM_SpriteYLo,X       
CODE_02E4C4:        B5 C2         LDA RAM_SpriteState,X     
CODE_02E4C6:        95 E4         STA RAM_SpriteXLo,X       
CODE_02E4C8:        BD 02 16      LDA.W $1602,X             
CODE_02E4CB:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02E4CE:        A0 02         LDY.B #$02                
CODE_02E4D0:        20 24 E5      JSR.W CODE_02E524         
CODE_02E4D3:        68            PLA                       
CODE_02E4D4:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02E4D7:        68            PLA                       
CODE_02E4D8:        95 D8         STA RAM_SpriteYLo,X       
CODE_02E4DA:        68            PLA                       
CODE_02E4DB:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02E4DE:        68            PLA                       
CODE_02E4DF:        95 E4         STA RAM_SpriteXLo,X       
CODE_02E4E1:        90 08         BCC CODE_02E4EB           
CODE_02E4E3:        EE 5E 18      INC.W $185E               
CODE_02E4E6:        A9 F8         LDA.B #$F8                
CODE_02E4E8:        20 59 E5      JSR.W CODE_02E559         
CODE_02E4EB:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_02E4EE:        18            CLC                       
CODE_02E4EF:        69 08         ADC.B #$08                
CODE_02E4F1:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_02E4F4:        A0 00         LDY.B #$00                
CODE_02E4F6:        20 24 E5      JSR.W CODE_02E524         
CODE_02E4F9:        90 08         BCC CODE_02E503           
CODE_02E4FB:        EE 5E 18      INC.W $185E               
CODE_02E4FE:        A9 08         LDA.B #$08                
CODE_02E500:        20 59 E5      JSR.W CODE_02E559         
CODE_02E503:        AD 5E 18      LDA.W $185E               
CODE_02E506:        D0 17         BNE Return02E51F          
CODE_02E508:        A0 02         LDY.B #$02                
CODE_02E50A:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02E50C:        DD 34 15      CMP.W $1534,X             
CODE_02E50F:        F0 0E         BEQ Return02E51F          
CODE_02E511:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02E514:        FD 1C 15      SBC.W $151C,X             
CODE_02E517:        30 02         BMI CODE_02E51B           
CODE_02E519:        A0 FE         LDY.B #$FE                
CODE_02E51B:        98            TYA                       
CODE_02E51C:        20 59 E5      JSR.W CODE_02E559         
Return02E51F:       60            RTS                       ; Return 


MushrmScaleTiles:                 .db $02,$07,$07,$02

CODE_02E524:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02E526:        29 0F         AND.B #$0F                
CODE_02E528:        D0 24         BNE CODE_02E54E           
CODE_02E52A:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02E52C:        F0 20         BEQ CODE_02E54E           
CODE_02E52E:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02E530:        10 01         BPL CODE_02E533           
CODE_02E532:        C8            INY                       
CODE_02E533:        B9 20 E5      LDA.W MushrmScaleTiles,Y  
CODE_02E536:        85 9C         STA RAM_BlockBlock        ; $9C = tile to generate 
CODE_02E538:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $9A = Sprite X position 
CODE_02E53A:        85 9A         STA RAM_BlockYLo          ;  | for block creation 
CODE_02E53C:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_02E53F:        85 9B         STA RAM_BlockYHi          ; / 
CODE_02E541:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $98 = Sprite Y position 
CODE_02E543:        85 98         STA RAM_BlockXLo          ;  | for block creation 
CODE_02E545:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_02E548:        85 99         STA RAM_BlockXHi          ; / 
CODE_02E54A:        22 B0 BE 00   JSL.L GenerateTile        ; Generate the tile 
CODE_02E54E:        20 7E E5      JSR.W MushroomScaleGfx    
CODE_02E551:        9E 28 15      STZ.W $1528,X             
CODE_02E554:        22 4F B4 01   JSL.L InvisBlkMainRt      
Return02E558:       60            RTS                       ; Return 

CODE_02E559:        A4 9D         LDY RAM_SpritesLocked     
CODE_02E55B:        D0 20         BNE Return02E57D          
CODE_02E55D:        48            PHA                       
CODE_02E55E:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02E561:        68            PLA                       
CODE_02E562:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02E564:        A0 00         LDY.B #$00                
CODE_02E566:        AD 91 14      LDA.W $1491               
CODE_02E569:        49 FF         EOR.B #$FF                
CODE_02E56B:        1A            INC A                     
CODE_02E56C:        10 01         BPL CODE_02E56F           
CODE_02E56E:        88            DEY                       
CODE_02E56F:        18            CLC                       
CODE_02E570:        7D 34 15      ADC.W $1534,X             
CODE_02E573:        9D 34 15      STA.W $1534,X             
CODE_02E576:        98            TYA                       
CODE_02E577:        7D 1C 15      ADC.W $151C,X             
CODE_02E57A:        9D 1C 15      STA.W $151C,X             
Return02E57D:       60            RTS                       ; Return 

MushroomScaleGfx:   20 78 D3      JSR.W GetDrawInfo2        
CODE_02E581:        A5 00         LDA $00                   
CODE_02E583:        38            SEC                       
CODE_02E584:        E9 08         SBC.B #$08                
CODE_02E586:        99 00 03      STA.W OAM_DispX,Y         
CODE_02E589:        18            CLC                       
CODE_02E58A:        69 10         ADC.B #$10                
CODE_02E58C:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_02E58F:        A5 01         LDA $01                   
CODE_02E591:        3A            DEC A                     
CODE_02E592:        99 01 03      STA.W OAM_DispY,Y         
CODE_02E595:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_02E598:        A9 80         LDA.B #$80                
CODE_02E59A:        99 02 03      STA.W OAM_Tile,Y          
CODE_02E59D:        99 06 03      STA.W OAM_Tile2,Y         
CODE_02E5A0:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_02E5A3:        05 64         ORA $64                   
CODE_02E5A5:        99 03 03      STA.W OAM_Prop,Y          
CODE_02E5A8:        09 40         ORA.B #$40                
CODE_02E5AA:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02E5AD:        A9 01         LDA.B #$01                
CODE_02E5AF:        A0 02         LDY.B #$02                
CODE_02E5B1:        4C A7 B7      JMP.W CODE_02B7A7         

MovingLedgeMain:    8B            PHB                       
CODE_02E5B5:        4B            PHK                       
CODE_02E5B6:        AB            PLB                       
CODE_02E5B7:        20 BC E5      JSR.W CODE_02E5BC         
CODE_02E5BA:        AB            PLB                       
Return02E5BB:       6B            RTL                       ; Return 

CODE_02E5BC:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02E5BF:        A5 9D         LDA RAM_SpritesLocked     
CODE_02E5C1:        D0 14         BNE CODE_02E5D7           
CODE_02E5C3:        FE 70 15      INC.W $1570,X             
CODE_02E5C6:        A0 10         LDY.B #$10                
CODE_02E5C8:        BD 70 15      LDA.W $1570,X             
CODE_02E5CB:        29 80         AND.B #$80                
CODE_02E5CD:        D0 02         BNE CODE_02E5D1           
CODE_02E5CF:        A0 F0         LDY.B #$F0                
CODE_02E5D1:        98            TYA                       
CODE_02E5D2:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02E5D4:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02E5D7:        20 37 E6      JSR.W CODE_02E637         
CODE_02E5DA:        20 F7 E5      JSR.W CODE_02E5F7         
CODE_02E5DD:        AD 5C 18      LDA.W $185C               
CODE_02E5E0:        F0 06         BEQ CODE_02E5E8           
ADDR_02E5E2:        3A            DEC A                     
ADDR_02E5E3:        CD E9 15      CMP.W $15E9               
ADDR_02E5E6:        D0 0E         BNE Return02E5F6          
CODE_02E5E8:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_02E5EC:        9C 5C 18      STZ.W $185C               
CODE_02E5EF:        90 05         BCC Return02E5F6          
ADDR_02E5F1:        E8            INX                       
ADDR_02E5F2:        8E 5C 18      STX.W $185C               
ADDR_02E5F5:        CA            DEX                       
Return02E5F6:       60            RTS                       ; Return 

CODE_02E5F7:        A0 0B         LDY.B #$0B                
CODE_02E5F9:        CC E9 15      CPY.W $15E9               
CODE_02E5FC:        F0 35         BEQ CODE_02E633           
CODE_02E5FE:        98            TYA                       
CODE_02E5FF:        45 13         EOR RAM_FrameCounter      
CODE_02E601:        29 03         AND.B #$03                
CODE_02E603:        D0 2E         BNE CODE_02E633           
CODE_02E605:        B9 C8 14      LDA.W $14C8,Y             
CODE_02E608:        C9 08         CMP.B #$08                
CODE_02E60A:        90 27         BCC CODE_02E633           
CODE_02E60C:        B9 DC 15      LDA.W $15DC,Y             
CODE_02E60F:        F0 06         BEQ CODE_02E617           
CODE_02E611:        3A            DEC A                     
CODE_02E612:        CD E9 15      CMP.W $15E9               
CODE_02E615:        D0 1C         BNE CODE_02E633           
CODE_02E617:        BB            TYX                       
CODE_02E618:        22 E5 B6 03   JSL.L GetSpriteClippingB  
CODE_02E61C:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02E61F:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_02E623:        22 2B B7 03   JSL.L CheckForContact     
CODE_02E627:        A9 00         LDA.B #$00                
CODE_02E629:        99 DC 15      STA.W $15DC,Y             
CODE_02E62C:        90 05         BCC CODE_02E633           
CODE_02E62E:        8A            TXA                       
CODE_02E62F:        1A            INC A                     
CODE_02E630:        99 DC 15      STA.W $15DC,Y             
CODE_02E633:        88            DEY                       
CODE_02E634:        10 C3         BPL CODE_02E5F9           
Return02E636:       60            RTS                       ; Return 

CODE_02E637:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02E63A:        DA            PHX                       
CODE_02E63B:        A2 03         LDX.B #$03                
CODE_02E63D:        A5 00         LDA $00                   
CODE_02E63F:        18            CLC                       
CODE_02E640:        7D 66 E6      ADC.W DATA_02E666,X       
CODE_02E643:        99 00 03      STA.W OAM_DispX,Y         
CODE_02E646:        A5 01         LDA $01                   
CODE_02E648:        99 01 03      STA.W OAM_DispY,Y         
CODE_02E64B:        BD 6A E6      LDA.W MovingHoleTiles,X   
CODE_02E64E:        99 02 03      STA.W OAM_Tile,Y          
CODE_02E651:        BD 6E E6      LDA.W DATA_02E66E,X       
CODE_02E654:        99 03 03      STA.W OAM_Prop,Y          
CODE_02E657:        C8            INY                       
CODE_02E658:        C8            INY                       
CODE_02E659:        C8            INY                       
CODE_02E65A:        C8            INY                       
CODE_02E65B:        CA            DEX                       
CODE_02E65C:        10 DF         BPL CODE_02E63D           
CODE_02E65E:        FA            PLX                       
CODE_02E65F:        A9 03         LDA.B #$03                
CODE_02E661:        A0 02         LDY.B #$02                
CODE_02E663:        4C A7 B7      JMP.W CODE_02B7A7         


DATA_02E666:                      .db $00,$08,$18,$20

MovingHoleTiles:                  .db $EB,$EA,$EA,$EB

DATA_02E66E:                      .db $71,$31,$31,$31

CODE_02E672:        8B            PHB                       ; Wrapper 
CODE_02E673:        4B            PHK                       
CODE_02E674:        AB            PLB                       
CODE_02E675:        20 7A E6      JSR.W CODE_02E67A         
CODE_02E678:        AB            PLB                       
Return02E679:       6B            RTL                       ; Return 

CODE_02E67A:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02E67D:        98            TYA                       
CODE_02E67E:        18            CLC                       
CODE_02E67F:        69 08         ADC.B #$08                
CODE_02E681:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_02E684:        A8            TAY                       
CODE_02E685:        A5 00         LDA $00                   
CODE_02E687:        38            SEC                       
CODE_02E688:        E9 0D         SBC.B #$0D                
CODE_02E68A:        99 00 03      STA.W OAM_DispX,Y         
CODE_02E68D:        38            SEC                       
CODE_02E68E:        E9 08         SBC.B #$08                
CODE_02E690:        8D 5E 18      STA.W $185E               
CODE_02E693:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_02E696:        A5 01         LDA $01                   
CODE_02E698:        18            CLC                       
CODE_02E699:        69 02         ADC.B #$02                
CODE_02E69B:        99 01 03      STA.W OAM_DispY,Y         
CODE_02E69E:        8D B6 18      STA.W $18B6               
CODE_02E6A1:        18            CLC                       
CODE_02E6A2:        69 40         ADC.B #$40                
CODE_02E6A4:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_02E6A7:        A9 AA         LDA.B #$AA                
CODE_02E6A9:        99 02 03      STA.W OAM_Tile,Y          
CODE_02E6AC:        A9 24         LDA.B #$24                
CODE_02E6AE:        99 06 03      STA.W OAM_Tile2,Y         
CODE_02E6B1:        A9 35         LDA.B #$35                
CODE_02E6B3:        99 03 03      STA.W OAM_Prop,Y          
CODE_02E6B6:        A9 3A         LDA.B #$3A                
CODE_02E6B8:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02E6BB:        A9 01         LDA.B #$01                
CODE_02E6BD:        A0 02         LDY.B #$02                
CODE_02E6BF:        20 A7 B7      JSR.W CODE_02B7A7         
CODE_02E6C2:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_02E6C5:        D0 24         BNE CODE_02E6EB           
CODE_02E6C7:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02E6CA:        A5 7E         LDA $7E                   
CODE_02E6CC:        38            SEC                       
CODE_02E6CD:        F9 04 03      SBC.W OAM_Tile2DispX,Y    
CODE_02E6D0:        18            CLC                       
CODE_02E6D1:        69 0C         ADC.B #$0C                
CODE_02E6D3:        C9 18         CMP.B #$18                
CODE_02E6D5:        B0 14         BCS CODE_02E6EB           
CODE_02E6D7:        A5 80         LDA $80                   
CODE_02E6D9:        38            SEC                       
CODE_02E6DA:        F9 05 03      SBC.W OAM_Tile2DispY,Y    
CODE_02E6DD:        18            CLC                       
CODE_02E6DE:        69 0C         ADC.B #$0C                
CODE_02E6E0:        C9 18         CMP.B #$18                
CODE_02E6E2:        B0 07         BCS CODE_02E6EB           
CODE_02E6E4:        9E 1C 15      STZ.W $151C,X             
CODE_02E6E7:        22 88 F3 00   JSL.L CODE_00F388         
CODE_02E6EB:        DA            PHX                       
CODE_02E6EC:        A9 38         LDA.B #$38                
CODE_02E6EE:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_02E6F1:        A8            TAY                       
CODE_02E6F2:        A2 07         LDX.B #$07                
CODE_02E6F4:        AD 5E 18      LDA.W $185E               
CODE_02E6F7:        99 00 03      STA.W OAM_DispX,Y         
CODE_02E6FA:        AD B6 18      LDA.W $18B6               
CODE_02E6FD:        99 01 03      STA.W OAM_DispY,Y         
CODE_02E700:        18            CLC                       
CODE_02E701:        69 08         ADC.B #$08                
CODE_02E703:        8D B6 18      STA.W $18B6               
CODE_02E706:        A9 89         LDA.B #$89                
CODE_02E708:        99 02 03      STA.W OAM_Tile,Y          
CODE_02E70B:        A9 35         LDA.B #$35                
CODE_02E70D:        99 03 03      STA.W OAM_Prop,Y          
CODE_02E710:        C8            INY                       
CODE_02E711:        C8            INY                       
CODE_02E712:        C8            INY                       
CODE_02E713:        C8            INY                       
CODE_02E714:        CA            DEX                       
CODE_02E715:        10 DD         BPL CODE_02E6F4           
CODE_02E717:        FA            PLX                       
CODE_02E718:        A9 07         LDA.B #$07                
CODE_02E71A:        A0 00         LDY.B #$00                
CODE_02E71C:        4C A7 B7      JMP.W CODE_02B7A7         

SwimJumpFishMain:   8B            PHB                       
CODE_02E720:        4B            PHK                       
CODE_02E721:        AB            PLB                       
CODE_02E722:        20 27 E7      JSR.W CODE_02E727         
CODE_02E725:        AB            PLB                       
Return02E726:       6B            RTL                       ; Return 

CODE_02E727:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_02E72B:        A5 9D         LDA RAM_SpritesLocked     
CODE_02E72D:        D0 1C         BNE Return02E74B          
CODE_02E72F:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02E732:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_02E736:        22 38 91 01   JSL.L CODE_019138         
CODE_02E73A:        A0 00         LDY.B #$00                
CODE_02E73C:        20 3D EB      JSR.W CODE_02EB3D         
CODE_02E73F:        B5 C2         LDA RAM_SpriteState,X     
CODE_02E741:        29 01         AND.B #$01                
CODE_02E743:        22 DF 86 00   JSL.L ExecutePtr          

FishPtrs:              4E E7      .dw CODE_02E74E           
                       88 E7      .dw CODE_02E788           

Return02E74B:       60            RTS                       ; Return 


DATA_02E74C:                      .db $14,$EC

CODE_02E74E:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02E751:        B9 4C E7      LDA.W DATA_02E74C,Y       
CODE_02E754:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02E756:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02E759:        BD 40 15      LDA.W $1540,X             
CODE_02E75C:        D0 1D         BNE Return02E77B          
CODE_02E75E:        FE 70 15      INC.W $1570,X             
CODE_02E761:        BC 70 15      LDY.W $1570,X             
CODE_02E764:        C0 04         CPY.B #$04                
CODE_02E766:        F0 14         BEQ CODE_02E77C           
CODE_02E768:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02E76B:        49 01         EOR.B #$01                
CODE_02E76D:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02E770:        A9 20         LDA.B #$20                
CODE_02E772:        C0 03         CPY.B #$03                
CODE_02E774:        F0 02         BEQ CODE_02E778           
CODE_02E776:        A9 40         LDA.B #$40                
CODE_02E778:        9D 40 15      STA.W $1540,X             
Return02E77B:       60            RTS                       ; Return 

CODE_02E77C:        F6 C2         INC RAM_SpriteState,X     
CODE_02E77E:        A9 80         LDA.B #$80                
CODE_02E780:        9D 40 15      STA.W $1540,X             
CODE_02E783:        A9 A0         LDA.B #$A0                
CODE_02E785:        95 AA         STA RAM_SpriteSpeedY,X    
Return02E787:       60            RTS                       ; Return 

CODE_02E788:        BD 40 15      LDA.W $1540,X             
CODE_02E78B:        F0 17         BEQ CODE_02E7A4           
CODE_02E78D:        C9 70         CMP.B #$70                
CODE_02E78F:        B0 12         BCS Return02E7A3          
CODE_02E791:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_02E793:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02E796:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02E798:        30 04         BMI CODE_02E79E           
CODE_02E79A:        C9 30         CMP.B #$30                
CODE_02E79C:        B0 05         BCS Return02E7A3          
CODE_02E79E:        18            CLC                       
CODE_02E79F:        69 02         ADC.B #$02                
CODE_02E7A1:        95 AA         STA RAM_SpriteSpeedY,X    
Return02E7A3:       60            RTS                       ; Return 

CODE_02E7A4:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02E7A6:        29 F0         AND.B #$F0                
CODE_02E7A8:        95 D8         STA RAM_SpriteYLo,X       
CODE_02E7AA:        F6 C2         INC RAM_SpriteState,X     
CODE_02E7AC:        9E 70 15      STZ.W $1570,X             
CODE_02E7AF:        A9 20         LDA.B #$20                
CODE_02E7B1:        9D 40 15      STA.W $1540,X             
Return02E7B4:       60            RTS                       ; Return 

ChucksRockMain:     8B            PHB                       
CODE_02E7B6:        4B            PHK                       
CODE_02E7B7:        AB            PLB                       
CODE_02E7B8:        20 BD E7      JSR.W CODE_02E7BD         
CODE_02E7BB:        AB            PLB                       
Return02E7BC:       6B            RTL                       ; Return 

CODE_02E7BD:        A5 64         LDA $64                   
CODE_02E7BF:        48            PHA                       
CODE_02E7C0:        BD 40 15      LDA.W $1540,X             
CODE_02E7C3:        F0 04         BEQ CODE_02E7C9           
CODE_02E7C5:        A9 10         LDA.B #$10                
CODE_02E7C7:        85 64         STA $64                   
CODE_02E7C9:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_02E7CD:        68            PLA                       
CODE_02E7CE:        85 64         STA $64                   
CODE_02E7D0:        A5 9D         LDA RAM_SpritesLocked     
CODE_02E7D2:        D0 58         BNE Return02E82C          
CODE_02E7D4:        BD 40 15      LDA.W $1540,X             
CODE_02E7D7:        C9 08         CMP.B #$08                
CODE_02E7D9:        B0 51         BCS Return02E82C          
CODE_02E7DB:        A0 00         LDY.B #$00                
CODE_02E7DD:        A5 13         LDA RAM_FrameCounter      
CODE_02E7DF:        4A            LSR                       
CODE_02E7E0:        20 3D EB      JSR.W CODE_02EB3D         
CODE_02E7E3:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02E7E6:        22 2A 80 01   JSL.L UpdateSpritePos     
CODE_02E7EA:        BD 40 15      LDA.W $1540,X             
CODE_02E7ED:        D0 39         BNE CODE_02E828           
CODE_02E7EF:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not touching object 
CODE_02E7F2:        29 03         AND.B #$03                ;  | 
CODE_02E7F4:        F0 07         BEQ CODE_02E7FD           ; / 
ADDR_02E7F6:        B5 B6         LDA RAM_SpriteSpeedX,X    
ADDR_02E7F8:        49 FF         EOR.B #$FF                
ADDR_02E7FA:        1A            INC A                     
ADDR_02E7FB:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02E7FD:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_02E800:        29 08         AND.B #$08                
CODE_02E802:        F0 04         BEQ CODE_02E808           
CODE_02E804:        A9 10         LDA.B #$10                
CODE_02E806:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02E808:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02E80B:        29 04         AND.B #$04                ;  | 
CODE_02E80D:        F0 19         BEQ CODE_02E828           ; / 
CODE_02E80F:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02E811:        C9 38         CMP.B #$38                
CODE_02E813:        A9 E0         LDA.B #$E0                
CODE_02E815:        90 02         BCC CODE_02E819           
CODE_02E817:        A9 D0         LDA.B #$D0                
CODE_02E819:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02E81B:        A9 08         LDA.B #$08                
CODE_02E81D:        BC B8 15      LDY.W $15B8,X             
CODE_02E820:        F0 06         BEQ CODE_02E828           
CODE_02E822:        10 02         BPL CODE_02E826           
CODE_02E824:        A9 F8         LDA.B #$F8                
CODE_02E826:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02E828:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
Return02E82C:       60            RTS                       ; Return 

GrowingPipeMain:    8B            PHB                       
CODE_02E82E:        4B            PHK                       
CODE_02E82F:        AB            PLB                       
CODE_02E830:        20 45 E8      JSR.W CODE_02E845         
CODE_02E833:        AB            PLB                       
Return02E834:       6B            RTL                       ; Return 


DATA_02E835:                      .db $00,$F0,$00,$10

DATA_02E839:                      .db $20,$40,$20,$40

GrowingPipeTiles1:                .db $00,$14,$00,$02

GrowingPipeTiles2:                .db $00,$15,$00,$02

CODE_02E845:        BD 34 15      LDA.W $1534,X             
CODE_02E848:        30 28         BMI CODE_02E872           
CODE_02E84A:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02E84C:        48            PHA                       
CODE_02E84D:        38            SEC                       
CODE_02E84E:        FD 34 15      SBC.W $1534,X             
CODE_02E851:        95 D8         STA RAM_SpriteYLo,X       
CODE_02E853:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02E856:        48            PHA                       
CODE_02E857:        E9 00         SBC.B #$00                
CODE_02E859:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02E85C:        A0 03         LDY.B #$03                
CODE_02E85E:        20 BA E8      JSR.W GrowingPipeGfx      
CODE_02E861:        68            PLA                       
CODE_02E862:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02E865:        68            PLA                       
CODE_02E866:        95 D8         STA RAM_SpriteYLo,X       
CODE_02E868:        BD 34 15      LDA.W $1534,X             
CODE_02E86B:        38            SEC                       
CODE_02E86C:        E9 10         SBC.B #$10                
CODE_02E86E:        9D 34 15      STA.W $1534,X             
Return02E871:       60            RTS                       ; Return 

CODE_02E872:        20 02 E9      JSR.W CODE_02E902         
CODE_02E875:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02E878:        A5 9D         LDA RAM_SpritesLocked     
CODE_02E87A:        1D A0 15      ORA.W RAM_OffscreenHorz,X 
CODE_02E87D:        D0 36         BNE CODE_02E8B5           
CODE_02E87F:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02E882:        A5 0F         LDA $0F                   
CODE_02E884:        18            CLC                       
CODE_02E885:        69 50         ADC.B #$50                
CODE_02E887:        C9 A0         CMP.B #$A0                
CODE_02E889:        B0 2A         BCS CODE_02E8B5           
CODE_02E88B:        B5 C2         LDA RAM_SpriteState,X     
CODE_02E88D:        29 03         AND.B #$03                
CODE_02E88F:        A8            TAY                       
CODE_02E890:        FE 70 15      INC.W $1570,X             
CODE_02E893:        BD 70 15      LDA.W $1570,X             
CODE_02E896:        D9 39 E8      CMP.W DATA_02E839,Y       
CODE_02E899:        D0 07         BNE CODE_02E8A2           
CODE_02E89B:        9E 70 15      STZ.W $1570,X             
CODE_02E89E:        F6 C2         INC RAM_SpriteState,X     
CODE_02E8A0:        80 13         BRA CODE_02E8B5           

CODE_02E8A2:        B9 35 E8      LDA.W DATA_02E835,Y       
CODE_02E8A5:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02E8A7:        F0 09         BEQ CODE_02E8B2           
CODE_02E8A9:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02E8AB:        29 0F         AND.B #$0F                
CODE_02E8AD:        D0 03         BNE CODE_02E8B2           
CODE_02E8AF:        20 BA E8      JSR.W GrowingPipeGfx      
CODE_02E8B2:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02E8B5:        22 4F B4 01   JSL.L InvisBlkMainRt      
Return02E8B9:       60            RTS                       ; Return 

GrowingPipeGfx:     B9 3D E8      LDA.W GrowingPipeTiles1,Y 
CODE_02E8BD:        8D 5E 18      STA.W $185E               
CODE_02E8C0:        B9 41 E8      LDA.W GrowingPipeTiles2,Y 
CODE_02E8C3:        8D B6 18      STA.W $18B6               
CODE_02E8C6:        AD 5E 18      LDA.W $185E               
CODE_02E8C9:        85 9C         STA RAM_BlockBlock        ; $9C = tile to generate 
CODE_02E8CB:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $9A = Sprite X position 
CODE_02E8CD:        85 9A         STA RAM_BlockYLo          ;  | for block creation 
CODE_02E8CF:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_02E8D2:        85 9B         STA RAM_BlockYHi          ; / 
CODE_02E8D4:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $98 = Sprite Y position 
CODE_02E8D6:        85 98         STA RAM_BlockXLo          ;  | for block creation 
CODE_02E8D8:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_02E8DB:        85 99         STA RAM_BlockXHi          ; / 
CODE_02E8DD:        22 B0 BE 00   JSL.L GenerateTile        ; Generate the tile 
CODE_02E8E1:        AD B6 18      LDA.W $18B6               
CODE_02E8E4:        85 9C         STA RAM_BlockBlock        ; $9C = tile to generate 
CODE_02E8E6:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $9A = Sprite X position + #$10 
CODE_02E8E8:        18            CLC                       ;  | for block creation 
CODE_02E8E9:        69 10         ADC.B #$10                ;  | 
CODE_02E8EB:        85 9A         STA RAM_BlockYLo          ;  | 
CODE_02E8ED:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_02E8F0:        69 00         ADC.B #$00                ;  | 
CODE_02E8F2:        85 9B         STA RAM_BlockYHi          ; / 
CODE_02E8F4:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $98 = Sprite Y position 
CODE_02E8F6:        85 98         STA RAM_BlockXLo          ;  | for block creation 
CODE_02E8F8:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_02E8FB:        85 99         STA RAM_BlockXHi          ; / 
CODE_02E8FD:        22 B0 BE 00   JSL.L GenerateTile        ; Generate the tile 
Return02E901:       60            RTS                       ; Return 

CODE_02E902:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02E905:        A5 00         LDA $00                   
CODE_02E907:        99 00 03      STA.W OAM_DispX,Y         
CODE_02E90A:        18            CLC                       
CODE_02E90B:        69 10         ADC.B #$10                
CODE_02E90D:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_02E910:        A5 01         LDA $01                   
CODE_02E912:        3A            DEC A                     
CODE_02E913:        99 01 03      STA.W OAM_DispY,Y         
CODE_02E916:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_02E919:        A9 A4         LDA.B #$A4                
CODE_02E91B:        99 02 03      STA.W OAM_Tile,Y          
CODE_02E91E:        A9 A6         LDA.B #$A6                
CODE_02E920:        99 06 03      STA.W OAM_Tile2,Y         
CODE_02E923:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_02E926:        05 64         ORA $64                   
CODE_02E928:        99 03 03      STA.W OAM_Prop,Y          
CODE_02E92B:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02E92E:        A9 01         LDA.B #$01                
CODE_02E930:        A0 02         LDY.B #$02                
CODE_02E932:        4C A7 B7      JMP.W CODE_02B7A7         

PipeLakituMain:     8B            PHB                       
CODE_02E936:        4B            PHK                       
CODE_02E937:        AB            PLB                       
CODE_02E938:        20 3D E9      JSR.W CODE_02E93D         
CODE_02E93B:        AB            PLB                       
Return02E93C:       6B            RTL                       ; Return 

CODE_02E93D:        BD C8 14      LDA.W $14C8,X             
CODE_02E940:        C9 02         CMP.B #$02                
CODE_02E942:        D0 08         BNE CODE_02E94C           
CODE_02E944:        A9 02         LDA.B #$02                
CODE_02E946:        9D 02 16      STA.W $1602,X             
CODE_02E949:        4C EC E9      JMP.W CODE_02E9EC         

CODE_02E94C:        20 EC E9      JSR.W CODE_02E9EC         
CODE_02E94F:        A5 9D         LDA RAM_SpritesLocked     
CODE_02E951:        D0 32         BNE Return02E985          
CODE_02E953:        9E 02 16      STZ.W $1602,X             
CODE_02E956:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02E959:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_02E95D:        B5 C2         LDA RAM_SpriteState,X     
CODE_02E95F:        22 DF 86 00   JSL.L ExecutePtr          

PipeLakituPtrs:        6D E9      .dw CODE_02E96D           
                       86 E9      .dw CODE_02E986           
                       B4 E9      .dw CODE_02E9B4           
                       BD E9      .dw CODE_02E9BD           
                       D5 E9      .dw CODE_02E9D5           

CODE_02E96D:        BD 40 15      LDA.W $1540,X             
CODE_02E970:        D0 13         BNE Return02E985          
CODE_02E972:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02E975:        A5 0F         LDA $0F                   
CODE_02E977:        18            CLC                       
CODE_02E978:        69 13         ADC.B #$13                
CODE_02E97A:        C9 36         CMP.B #$36                
CODE_02E97C:        90 07         BCC Return02E985          
CODE_02E97E:        A9 90         LDA.B #$90                
CODE_02E980:        9D 40 15      STA.W $1540,X             
CODE_02E983:        F6 C2         INC RAM_SpriteState,X     
Return02E985:       60            RTS                       ; Return 

CODE_02E986:        BD 40 15      LDA.W $1540,X             
CODE_02E989:        D0 0B         BNE CODE_02E996           
CODE_02E98B:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02E98E:        98            TYA                       
CODE_02E98F:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02E992:        A9 0C         LDA.B #$0C                
CODE_02E994:        80 EA         BRA CODE_02E980           

CODE_02E996:        C9 7C         CMP.B #$7C                
CODE_02E998:        90 08         BCC CODE_02E9A2           
CODE_02E99A:        A9 F8         LDA.B #$F8                
CODE_02E99C:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02E99E:        20 94 D2      JSR.W UpdateYPosNoGrvty   
Return02E9A1:       60            RTS                       ; Return 

CODE_02E9A2:        C9 50         CMP.B #$50                
CODE_02E9A4:        B0 0D         BCS Return02E9B3          
CODE_02E9A6:        A0 00         LDY.B #$00                
CODE_02E9A8:        A5 13         LDA RAM_FrameCounter      
CODE_02E9AA:        29 20         AND.B #$20                
CODE_02E9AC:        F0 01         BEQ CODE_02E9AF           
CODE_02E9AE:        C8            INY                       
CODE_02E9AF:        98            TYA                       
CODE_02E9B0:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return02E9B3:       60            RTS                       ; Return 

CODE_02E9B4:        BD 40 15      LDA.W $1540,X             
CODE_02E9B7:        D0 E1         BNE CODE_02E99A           
CODE_02E9B9:        A9 80         LDA.B #$80                
CODE_02E9BB:        80 C3         BRA CODE_02E980           

CODE_02E9BD:        BD 40 15      LDA.W $1540,X             
CODE_02E9C0:        D0 04         BNE CODE_02E9C6           
CODE_02E9C2:        A9 20         LDA.B #$20                
CODE_02E9C4:        80 BA         BRA CODE_02E980           

CODE_02E9C6:        C9 40         CMP.B #$40                
CODE_02E9C8:        D0 05         BNE CODE_02E9CF           
CODE_02E9CA:        22 19 EA 01   JSL.L CODE_01EA19         
Return02E9CE:       60            RTS                       ; Return 

CODE_02E9CF:        B0 03         BCS Return02E9D4          
CODE_02E9D1:        FE 02 16      INC.W $1602,X             
Return02E9D4:       60            RTS                       ; Return 

CODE_02E9D5:        BD 40 15      LDA.W $1540,X             
CODE_02E9D8:        D0 08         BNE CODE_02E9E2           
CODE_02E9DA:        A9 50         LDA.B #$50                
CODE_02E9DC:        20 80 E9      JSR.W CODE_02E980         
CODE_02E9DF:        74 C2         STZ RAM_SpriteState,X     
Return02E9E1:       60            RTS                       ; Return 

CODE_02E9E2:        A9 08         LDA.B #$08                
CODE_02E9E4:        80 B6         BRA CODE_02E99C           


PipeLakitu1:                      .db $EC,$A8,$CE

PipeLakitu2:                      .db $EE,$EE,$EE

CODE_02E9EC:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02E9EF:        A5 00         LDA $00                   
CODE_02E9F1:        99 00 03      STA.W OAM_DispX,Y         
CODE_02E9F4:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_02E9F7:        A5 01         LDA $01                   
CODE_02E9F9:        99 01 03      STA.W OAM_DispY,Y         
CODE_02E9FC:        18            CLC                       
CODE_02E9FD:        69 10         ADC.B #$10                
CODE_02E9FF:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_02EA02:        DA            PHX                       
CODE_02EA03:        BD 02 16      LDA.W $1602,X             
CODE_02EA06:        AA            TAX                       
CODE_02EA07:        BD E6 E9      LDA.W PipeLakitu1,X       
CODE_02EA0A:        99 02 03      STA.W OAM_Tile,Y          
CODE_02EA0D:        BD E9 E9      LDA.W PipeLakitu2,X       
CODE_02EA10:        99 06 03      STA.W OAM_Tile2,Y         
CODE_02EA13:        FA            PLX                       
CODE_02EA14:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02EA17:        4A            LSR                       
CODE_02EA18:        6A            ROR                       
CODE_02EA19:        4A            LSR                       
CODE_02EA1A:        49 5B         EOR.B #$5B                
CODE_02EA1C:        99 03 03      STA.W OAM_Prop,Y          
CODE_02EA1F:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02EA22:        4C 2E E9      JMP.W CODE_02E92E         

CODE_02EA25:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02EA28:        B9 02 03      LDA.W OAM_Tile,Y          
CODE_02EA2B:        85 00         STA $00                   
CODE_02EA2D:        64 01         STZ $01                   
CODE_02EA2F:        A9 06         LDA.B #$06                
CODE_02EA31:        99 02 03      STA.W OAM_Tile,Y          
CODE_02EA34:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_02EA36:        A5 00         LDA $00                   
CODE_02EA38:        0A            ASL                       
CODE_02EA39:        0A            ASL                       
CODE_02EA3A:        0A            ASL                       
CODE_02EA3B:        0A            ASL                       
CODE_02EA3C:        0A            ASL                       
CODE_02EA3D:        18            CLC                       
CODE_02EA3E:        69 00 85      ADC.W #$8500              
CODE_02EA41:        8D 8B 0D      STA.W $0D8B               
CODE_02EA44:        18            CLC                       
CODE_02EA45:        69 00 02      ADC.W #$0200              
CODE_02EA48:        8D 95 0D      STA.W $0D95               
CODE_02EA4B:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return02EA4D:       6B            RTL                       ; Return 

CODE_02EA4E:        A0 0B         LDY.B #$0B                
CODE_02EA50:        98            TYA                       
CODE_02EA51:        DD 0E 16      CMP.W $160E,X             
CODE_02EA54:        F0 30         BEQ CODE_02EA86           
CODE_02EA56:        45 13         EOR RAM_FrameCounter      
CODE_02EA58:        4A            LSR                       
CODE_02EA59:        B0 2B         BCS CODE_02EA86           
CODE_02EA5B:        CC E9 15      CPY.W $15E9               
CODE_02EA5E:        F0 26         BEQ CODE_02EA86           
CODE_02EA60:        8C 95 16      STY.W $1695               
CODE_02EA63:        B9 C8 14      LDA.W $14C8,Y             
CODE_02EA66:        C9 08         CMP.B #$08                
CODE_02EA68:        90 1C         BCC CODE_02EA86           
CODE_02EA6A:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_02EA6D:        C9 70         CMP.B #$70                
CODE_02EA6F:        F0 15         BEQ CODE_02EA86           
CODE_02EA71:        C9 0E         CMP.B #$0E                
CODE_02EA73:        F0 11         BEQ CODE_02EA86           
CODE_02EA75:        C9 1D         CMP.B #$1D                
CODE_02EA77:        90 0A         BCC CODE_02EA83           
CODE_02EA79:        B9 86 16      LDA.W RAM_Tweaker1686,Y   
CODE_02EA7C:        29 03         AND.B #$03                
CODE_02EA7E:        0D E8 18      ORA.W $18E8               
CODE_02EA81:        D0 03         BNE CODE_02EA86           
CODE_02EA83:        20 8A EA      JSR.W CODE_02EA8A         
CODE_02EA86:        88            DEY                       
CODE_02EA87:        10 C7         BPL CODE_02EA50           
Return02EA89:       6B            RTL                       ; Return 

CODE_02EA8A:        DA            PHX                       
CODE_02EA8B:        BB            TYX                       
CODE_02EA8C:        22 E5 B6 03   JSL.L GetSpriteClippingB  
CODE_02EA90:        FA            PLX                       
CODE_02EA91:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_02EA95:        22 2B B7 03   JSL.L CheckForContact     
CODE_02EA99:        90 32         BCC Return02EACD          
CODE_02EA9B:        BD 3E 16      LDA.W $163E,X             
CODE_02EA9E:        F0 09         BEQ CODE_02EAA9           
CODE_02EAA0:        22 23 C0 03   JSL.L CODE_03C023         
CODE_02EAA4:        AD E8 18      LDA.W $18E8               
CODE_02EAA7:        D0 25         BNE ADDR_02EACE           
CODE_02EAA9:        A9 37         LDA.B #$37                
CODE_02EAAB:        9D 3E 16      STA.W $163E,X             
CODE_02EAAE:        AC 95 16      LDY.W $1695               
CODE_02EAB1:        99 32 16      STA.W RAM_SprBehindScrn,Y 
CODE_02EAB4:        AD 95 16      LDA.W $1695               
CODE_02EAB7:        9D 0E 16      STA.W $160E,X             
CODE_02EABA:        9E 7C 15      STZ.W RAM_SpriteDir,X     
CODE_02EABD:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02EABF:        D9 E4 00      CMP.W RAM_SpriteXLo,Y     
CODE_02EAC2:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02EAC5:        F9 E0 14      SBC.W RAM_SpriteXHi,Y     
CODE_02EAC8:        90 03         BCC Return02EACD          
CODE_02EACA:        FE 7C 15      INC.W RAM_SpriteDir,X     
Return02EACD:       60            RTS                       ; Return 

ADDR_02EACE:        9E 3E 16      STZ.W $163E,X             
Return02EAD1:       60            RTS                       ; Return 

WarpBlocksMain:     8B            PHB                       
CODE_02EAD3:        4B            PHK                       
CODE_02EAD4:        AB            PLB                       
CODE_02EAD5:        20 DA EA      JSR.W CODE_02EADA         
CODE_02EAD8:        AB            PLB                       
Return02EAD9:       6B            RTL                       ; Return 

CODE_02EADA:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_02EADE:        90 10         BCC Return02EAF0          
ADDR_02EAE0:        64 7B         STZ RAM_MarioSpeedX       
ADDR_02EAE2:        B5 E4         LDA RAM_SpriteXLo,X       
ADDR_02EAE4:        18            CLC                       
ADDR_02EAE5:        69 0A         ADC.B #$0A                
ADDR_02EAE7:        85 94         STA RAM_MarioXPos         
ADDR_02EAE9:        BD E0 14      LDA.W RAM_SpriteXHi,X     
ADDR_02EAEC:        69 00         ADC.B #$00                
ADDR_02EAEE:        85 95         STA RAM_MarioXPosHi       
Return02EAF0:       60            RTS                       ; Return 

Return02EAF1:       60            RTS                       

CODE_02EAF2:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_02EAF6:        30 2E         BMI Return02EB26          ; / 
CODE_02EAF8:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02EAFA:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02EAFD:        A9 77         LDA.B #$77                
CODE_02EAFF:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_02EB02:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02EB04:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_02EB07:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02EB0A:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_02EB0D:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02EB0F:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_02EB12:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02EB15:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_02EB18:        BB            TYX                       
CODE_02EB19:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02EB1D:        A9 30         LDA.B #$30                
CODE_02EB1F:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_02EB22:        A9 D0         LDA.B #$D0                
CODE_02EB24:        95 AA         STA RAM_SpriteSpeedY,X    
Return02EB26:       6B            RTL                       ; Return 

SuperKoopaMain:     8B            PHB                       
CODE_02EB28:        4B            PHK                       
CODE_02EB29:        AB            PLB                       
CODE_02EB2A:        20 31 EB      JSR.W CODE_02EB31         
CODE_02EB2D:        AB            PLB                       
Return02EB2E:       6B            RTL                       ; Return 


DATA_02EB2F:                      .db $18,$E8

CODE_02EB31:        20 DE EC      JSR.W CODE_02ECDE         
CODE_02EB34:        BD C8 14      LDA.W $14C8,X             
CODE_02EB37:        C9 02         CMP.B #$02                
CODE_02EB39:        D0 0E         BNE CODE_02EB49           
CODE_02EB3B:        A0 04         LDY.B #$04                
CODE_02EB3D:        A5 14         LDA RAM_FrameCounterB     
CODE_02EB3F:        29 04         AND.B #$04                
CODE_02EB41:        F0 01         BEQ CODE_02EB44           
CODE_02EB43:        C8            INY                       
CODE_02EB44:        98            TYA                       
CODE_02EB45:        9D 02 16      STA.W $1602,X             
Return02EB48:       60            RTS                       ; Return 

CODE_02EB49:        A5 9D         LDA RAM_SpritesLocked     
CODE_02EB4B:        D0 2F         BNE Return02EB7C          
CODE_02EB4D:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02EB50:        22 3A 80 01   JSL.L SprSpr+MarioSprRts  
CODE_02EB54:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02EB57:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02EB5A:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02EB5C:        C9 73         CMP.B #$73                
CODE_02EB5E:        F0 1D         BEQ CODE_02EB7D           
CODE_02EB60:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02EB63:        B9 2F EB      LDA.W DATA_02EB2F,Y       
CODE_02EB66:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02EB68:        20 F8 EB      JSR.W CODE_02EBF8         
CODE_02EB6B:        A5 13         LDA RAM_FrameCounter      
CODE_02EB6D:        29 01         AND.B #$01                
CODE_02EB6F:        D0 0B         BNE Return02EB7C          
CODE_02EB71:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02EB73:        C9 F0         CMP.B #$F0                
CODE_02EB75:        30 05         BMI Return02EB7C          
CODE_02EB77:        18            CLC                       
CODE_02EB78:        69 FF         ADC.B #$FF                
CODE_02EB7A:        95 AA         STA RAM_SpriteSpeedY,X    
Return02EB7C:       60            RTS                       ; Return 

CODE_02EB7D:        B5 C2         LDA RAM_SpriteState,X     
CODE_02EB7F:        22 DF 86 00   JSL.L ExecutePtr          

SuperKoopaPtrs:        8D EB      .dw CODE_02EB8D           
                       D1 EB      .dw CODE_02EBD1           
                       E7 EB      .dw CODE_02EBE7           

DATA_02EB89:                      .db $18,$E8

DATA_02EB8B:                      .db $01,$FF

CODE_02EB8D:        A5 13         LDA RAM_FrameCounter      
CODE_02EB8F:        29 00         AND.B #$00                
CODE_02EB91:        85 01         STA $01                   
CODE_02EB93:        64 00         STZ $00                   
CODE_02EB95:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02EB98:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02EB9A:        D9 89 EB      CMP.W DATA_02EB89,Y       
CODE_02EB9D:        F0 0C         BEQ CODE_02EBAB           
CODE_02EB9F:        18            CLC                       
CODE_02EBA0:        79 8B EB      ADC.W DATA_02EB8B,Y       
CODE_02EBA3:        A4 01         LDY $01                   
CODE_02EBA5:        D0 02         BNE CODE_02EBA9           
CODE_02EBA7:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02EBA9:        E6 00         INC $00                   
CODE_02EBAB:        FE 1C 15      INC.W $151C,X             
CODE_02EBAE:        BD 1C 15      LDA.W $151C,X             
CODE_02EBB1:        C9 30         CMP.B #$30                
CODE_02EBB3:        F0 15         BEQ CODE_02EBCA           
CODE_02EBB5:        A0 00         LDY.B #$00                
CODE_02EBB7:        A5 13         LDA RAM_FrameCounter      
CODE_02EBB9:        29 04         AND.B #$04                
CODE_02EBBB:        F0 01         BEQ CODE_02EBBE           
CODE_02EBBD:        C8            INY                       
CODE_02EBBE:        98            TYA                       
CODE_02EBBF:        A4 00         LDY $00                   
CODE_02EBC1:        D0 03         BNE CODE_02EBC6           
CODE_02EBC3:        18            CLC                       
CODE_02EBC4:        69 06         ADC.B #$06                
CODE_02EBC6:        9D 02 16      STA.W $1602,X             
Return02EBC9:       60            RTS                       ; Return 

CODE_02EBCA:        F6 C2         INC RAM_SpriteState,X     
CODE_02EBCC:        A9 D0         LDA.B #$D0                
CODE_02EBCE:        95 AA         STA RAM_SpriteSpeedY,X    
Return02EBD0:       60            RTS                       ; Return 

CODE_02EBD1:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02EBD3:        18            CLC                       
CODE_02EBD4:        69 02         ADC.B #$02                
CODE_02EBD6:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02EBD8:        C9 14         CMP.B #$14                
CODE_02EBDA:        30 02         BMI CODE_02EBDE           
CODE_02EBDC:        F6 C2         INC RAM_SpriteState,X     
CODE_02EBDE:        64 00         STZ $00                   
CODE_02EBE0:        20 B5 EB      JSR.W CODE_02EBB5         
CODE_02EBE3:        FE 02 16      INC.W $1602,X             
Return02EBE6:       60            RTS                       ; Return 

CODE_02EBE7:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02EBEA:        B9 89 EB      LDA.W DATA_02EB89,Y       
CODE_02EBED:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02EBEF:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02EBF1:        F0 05         BEQ CODE_02EBF8           
CODE_02EBF3:        18            CLC                       
CODE_02EBF4:        69 FF         ADC.B #$FF                
CODE_02EBF6:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02EBF8:        A0 02         LDY.B #$02                
CODE_02EBFA:        A5 13         LDA RAM_FrameCounter      
CODE_02EBFC:        29 04         AND.B #$04                
CODE_02EBFE:        F0 01         BEQ CODE_02EC01           
CODE_02EC00:        C8            INY                       
CODE_02EC01:        98            TYA                       
CODE_02EC02:        9D 02 16      STA.W $1602,X             
Return02EC05:       60            RTS                       ; Return 


DATA_02EC06:                      .db $08,$08,$10,$00,$08,$08,$10,$00
                                  .db $08,$10,$10,$00,$08,$10,$10,$00
                                  .db $09,$09,$00,$00,$09,$09,$00,$00
                                  .db $08,$10,$00,$00,$08,$10,$00,$00
                                  .db $08,$10,$00,$00,$00,$00,$F8,$00
                                  .db $00,$00,$F8,$00,$00,$F8,$F8,$00
                                  .db $00,$F8,$F8,$00,$FF,$FF,$00,$00
                                  .db $FF,$FF,$00,$00,$00,$F8,$00,$00
                                  .db $00,$F8,$00,$00,$00,$F8,$00,$00
DATA_02EC4E:                      .db $00,$08,$08,$00,$00,$08,$08,$00
                                  .db $03,$03,$08,$00,$03,$03,$08,$00
                                  .db $FF,$07,$00,$00,$FF,$07,$00,$00
                                  .db $FD,$FD,$00,$00,$FD,$FD,$00,$00
                                  .db $FD,$FD,$00,$00

SuperKoopaTiles:                  .db $C8,$D8,$D0,$E0,$C9,$D9,$C0,$E2
                                  .db $E4,$E5,$F2,$E0,$F4,$F5,$F2,$E0
                                  .db $DA,$CA,$E0,$CF,$DB,$CB,$E0,$CF
                                  .db $E4,$E5,$E0,$CF,$F4,$F5,$E2,$CF
                                  .db $E4,$E5,$E2,$CF

DATA_02EC96:                      .db $03,$03,$03,$00,$03,$03,$03,$00
                                  .db $03,$03,$01,$01,$03,$03,$01,$01
                                  .db $83,$83,$80,$00,$83,$83,$80,$00
                                  .db $03,$03,$00,$01,$03,$03,$00,$01
                                  .db $03,$03,$00,$01

DATA_02ECBA:                      .db $00,$00,$00,$02,$00,$00,$00,$02
                                  .db $00,$00,$00,$02,$00,$00,$00,$02
                                  .db $00,$00,$02,$00,$00,$00,$02,$00
                                  .db $00,$00,$02,$00,$00,$00,$02,$00
                                  .db $00,$00,$02,$00

CODE_02ECDE:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02ECE1:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02ECE4:        85 02         STA $02                   
CODE_02ECE6:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_02ECE9:        29 0E         AND.B #$0E                
CODE_02ECEB:        85 05         STA $05                   
CODE_02ECED:        BD 02 16      LDA.W $1602,X             
CODE_02ECF0:        0A            ASL                       
CODE_02ECF1:        0A            ASL                       
CODE_02ECF2:        85 03         STA $03                   
CODE_02ECF4:        DA            PHX                       
CODE_02ECF5:        64 04         STZ $04                   
CODE_02ECF7:        A5 03         LDA $03                   
CODE_02ECF9:        18            CLC                       
CODE_02ECFA:        65 04         ADC $04                   
CODE_02ECFC:        AA            TAX                       
CODE_02ECFD:        A5 01         LDA $01                   
CODE_02ECFF:        18            CLC                       
CODE_02ED00:        7D 4E EC      ADC.W DATA_02EC4E,X       
CODE_02ED03:        99 01 03      STA.W OAM_DispY,Y         
CODE_02ED06:        BD 72 EC      LDA.W SuperKoopaTiles,X   
CODE_02ED09:        99 02 03      STA.W OAM_Tile,Y          
CODE_02ED0C:        5A            PHY                       
CODE_02ED0D:        98            TYA                       
CODE_02ED0E:        4A            LSR                       
CODE_02ED0F:        4A            LSR                       
CODE_02ED10:        A8            TAY                       
CODE_02ED11:        BD BA EC      LDA.W DATA_02ECBA,X       
CODE_02ED14:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02ED17:        7A            PLY                       
CODE_02ED18:        A5 02         LDA $02                   
CODE_02ED1A:        4A            LSR                       
CODE_02ED1B:        BD 96 EC      LDA.W DATA_02EC96,X       
CODE_02ED1E:        29 02         AND.B #$02                
CODE_02ED20:        F0 2B         BEQ CODE_02ED4D           
CODE_02ED22:        08            PHP                       
CODE_02ED23:        DA            PHX                       
CODE_02ED24:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02ED27:        BD 34 15      LDA.W $1534,X             
CODE_02ED2A:        F0 0F         BEQ CODE_02ED3B           
CODE_02ED2C:        A5 14         LDA RAM_FrameCounterB     
CODE_02ED2E:        4A            LSR                       
CODE_02ED2F:        29 01         AND.B #$01                
CODE_02ED31:        5A            PHY                       
CODE_02ED32:        A8            TAY                       
CODE_02ED33:        B9 39 ED      LDA.W DATA_02ED39,Y       
CODE_02ED36:        7A            PLY                       
CODE_02ED37:        80 0B         BRA CODE_02ED44           


DATA_02ED39:                      .db $10,$0A

CODE_02ED3B:        B5 9E         LDA RAM_SpriteNum,X       
CODE_02ED3D:        C9 72         CMP.B #$72                
CODE_02ED3F:        A9 08         LDA.B #$08                
CODE_02ED41:        90 01         BCC CODE_02ED44           
CODE_02ED43:        4A            LSR                       
CODE_02ED44:        FA            PLX                       
CODE_02ED45:        28            PLP                       
CODE_02ED46:        1D 96 EC      ORA.W DATA_02EC96,X       
CODE_02ED49:        29 FD         AND.B #$FD                
CODE_02ED4B:        80 05         BRA CODE_02ED52           

CODE_02ED4D:        BD 96 EC      LDA.W DATA_02EC96,X       
CODE_02ED50:        05 05         ORA $05                   
CODE_02ED52:        05 64         ORA $64                   
CODE_02ED54:        B0 09         BCS CODE_02ED5F           
CODE_02ED56:        48            PHA                       
CODE_02ED57:        8A            TXA                       
CODE_02ED58:        18            CLC                       
CODE_02ED59:        69 24         ADC.B #$24                
CODE_02ED5B:        AA            TAX                       
CODE_02ED5C:        68            PLA                       
CODE_02ED5D:        09 40         ORA.B #$40                
CODE_02ED5F:        99 03 03      STA.W OAM_Prop,Y          
CODE_02ED62:        A5 00         LDA $00                   
CODE_02ED64:        18            CLC                       
CODE_02ED65:        7D 06 EC      ADC.W DATA_02EC06,X       
CODE_02ED68:        99 00 03      STA.W OAM_DispX,Y         
CODE_02ED6B:        C8            INY                       
CODE_02ED6C:        C8            INY                       
CODE_02ED6D:        C8            INY                       
CODE_02ED6E:        C8            INY                       
CODE_02ED6F:        E6 04         INC $04                   
CODE_02ED71:        A5 04         LDA $04                   
CODE_02ED73:        C9 04         CMP.B #$04                
CODE_02ED75:        D0 80         BNE CODE_02ECF7           
CODE_02ED77:        FA            PLX                       
CODE_02ED78:        A0 FF         LDY.B #$FF                
CODE_02ED7A:        A9 03         LDA.B #$03                
CODE_02ED7C:        4C A7 B7      JMP.W CODE_02B7A7         


DATA_02ED7F:                      .db $10,$20,$30

FloatingSkullInit:  8B            PHB                       
CODE_02ED83:        4B            PHK                       
CODE_02ED84:        AB            PLB                       
CODE_02ED85:        20 8A ED      JSR.W CODE_02ED8A         
CODE_02ED88:        AB            PLB                       
Return02ED89:       6B            RTL                       ; Return 

CODE_02ED8A:        9C BC 18      STZ.W $18BC               
CODE_02ED8D:        F6 C2         INC RAM_SpriteState,X     
CODE_02ED8F:        A9 02         LDA.B #$02                
CODE_02ED91:        85 00         STA $00                   
CODE_02ED93:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Branch if no free slots 
CODE_02ED97:        30 32         BMI CODE_02EDCB           ; / 
CODE_02ED99:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02ED9B:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02ED9E:        A9 61         LDA.B #$61                
CODE_02EDA0:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_02EDA3:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02EDA5:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_02EDA8:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02EDAB:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_02EDAE:        A6 00         LDX $00                   
CODE_02EDB0:        BD 7F ED      LDA.W DATA_02ED7F,X       
CODE_02EDB3:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02EDB6:        18            CLC                       
CODE_02EDB7:        75 E4         ADC RAM_SpriteXLo,X       
CODE_02EDB9:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_02EDBC:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02EDBF:        69 00         ADC.B #$00                
CODE_02EDC1:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_02EDC4:        DA            PHX                       
CODE_02EDC5:        BB            TYX                       
CODE_02EDC6:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02EDCA:        FA            PLX                       
CODE_02EDCB:        C6 00         DEC $00                   
CODE_02EDCD:        10 C4         BPL CODE_02ED93           
Return02EDCF:       60            RTS                       ; Return 

FloatingSkullMain:  8B            PHB                       
CODE_02EDD1:        4B            PHK                       
CODE_02EDD2:        AB            PLB                       
CODE_02EDD3:        20 D8 ED      JSR.W CODE_02EDD8         
CODE_02EDD6:        AB            PLB                       
Return02EDD7:       6B            RTL                       ; Return 

CODE_02EDD8:        B5 C2         LDA RAM_SpriteState,X     
CODE_02EDDA:        F0 1A         BEQ CODE_02EDF6		;IF SKULLS DIEING           
CODE_02EDDC:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02EDDF:        BD C8 14      LDA.W $14C8,X             
CODE_02EDE2:        D0 12         BNE CODE_02EDF6		;IF LIVING, DO BELOW           
CODE_02EDE4:        A0 09         LDY.B #$09                
CODE_02EDE6:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_02EDE9:        C9 61         CMP.B #$61		;SEARCH OUT OTHERS                
CODE_02EDEB:        D0 05         BNE CODE_02EDF2           
CODE_02EDED:        A9 00         LDA.B #$00 		;ERASE THEM TOO               
CODE_02EDEF:        99 C8 14      STA.W $14C8,Y             
CODE_02EDF2:        88            DEY                       
CODE_02EDF3:        10 F1         BPL CODE_02EDE6           
Return02EDF5:       60            RTS                       ; Return 

CODE_02EDF6:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_02EDFA:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02EDFD:        A5 14         LDA RAM_FrameCounterB     
CODE_02EDFF:        4A            LSR                       
CODE_02EE00:        4A            LSR                       
CODE_02EE01:        4A            LSR                       
CODE_02EE02:        4A            LSR                       
CODE_02EE03:        A9 E0         LDA.B #$E0                
CODE_02EE05:        90 02         BCC CODE_02EE09           
CODE_02EE07:        A9 E2         LDA.B #$E2                
CODE_02EE09:        99 02 03      STA.W OAM_Tile,Y          
CODE_02EE0C:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_02EE0F:        C9 F0         CMP.B #$F0                
CODE_02EE11:        B0 06         BCS CODE_02EE19           
CODE_02EE13:        18            CLC                       
CODE_02EE14:        69 03         ADC.B #$03                
CODE_02EE16:        99 01 03      STA.W OAM_DispY,Y         
CODE_02EE19:        A5 9D         LDA RAM_SpritesLocked     
CODE_02EE1B:        D0 D8         BNE Return02EDF5          
CODE_02EE1D:        64 00         STZ $00                   
CODE_02EE1F:        A0 09         LDY.B #$09                
CODE_02EE21:        B9 C8 14      LDA.W $14C8,Y             
CODE_02EE24:        F0 10         BEQ CODE_02EE36           
CODE_02EE26:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_02EE29:        C9 61         CMP.B #$61                
CODE_02EE2B:        D0 09         BNE CODE_02EE36           
CODE_02EE2D:        B9 88 15      LDA.W RAM_SprObjStatus,Y  
CODE_02EE30:        29 0F         AND.B #$0F                
CODE_02EE32:        F0 02         BEQ CODE_02EE36           
CODE_02EE34:        85 00         STA $00                   
CODE_02EE36:        88            DEY                       
CODE_02EE37:        10 E8         BPL CODE_02EE21           
CODE_02EE39:        AD BC 18      LDA.W $18BC               
CODE_02EE3C:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02EE3E:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02EE40:        C9 20         CMP.B #$20                
CODE_02EE42:        30 04         BMI CODE_02EE48           
CODE_02EE44:        A9 20         LDA.B #$20                
CODE_02EE46:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02EE48:        22 2A 80 01   JSL.L UpdateSpritePos     
CODE_02EE4C:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02EE4F:        29 04         AND.B #$04                ;  | 
CODE_02EE51:        F0 04         BEQ CODE_02EE57           ; / 
CODE_02EE53:        A9 10         LDA.B #$10                
CODE_02EE55:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02EE57:        22 DC A7 01   JSL.L MarioSprInteract    
CODE_02EE5B:        90 4B         BCC Return02EEA8          
CODE_02EE5D:        A5 7D         LDA RAM_MarioSpeedY       
CODE_02EE5F:        30 47         BMI Return02EEA8          
CODE_02EE61:        A9 0C         LDA.B #$0C                
CODE_02EE63:        8D BC 18      STA.W $18BC               
CODE_02EE66:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_02EE69:        AA            TAX                       
CODE_02EE6A:        FE 01 03      INC.W OAM_DispY,X         
CODE_02EE6D:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02EE70:        A9 01         LDA.B #$01                
CODE_02EE72:        8D 71 14      STA.W $1471               
CODE_02EE75:        64 72         STZ RAM_IsFlying          
CODE_02EE77:        A9 1C         LDA.B #$1C                
CODE_02EE79:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_02EE7C:        F0 02         BEQ CODE_02EE80           
CODE_02EE7E:        A9 2C         LDA.B #$2C                
CODE_02EE80:        85 01         STA $01                   
CODE_02EE82:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02EE84:        38            SEC                       
CODE_02EE85:        E5 01         SBC $01                   
CODE_02EE87:        85 96         STA RAM_MarioYPos         
CODE_02EE89:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_02EE8C:        E9 00         SBC.B #$00                
CODE_02EE8E:        85 97         STA RAM_MarioYPosHi       
CODE_02EE90:        A5 77         LDA RAM_MarioObjStatus    
CODE_02EE92:        29 01         AND.B #$01                
CODE_02EE94:        D0 12         BNE Return02EEA8          
CODE_02EE96:        A0 00         LDY.B #$00                
CODE_02EE98:        AD 91 14      LDA.W $1491               
CODE_02EE9B:        10 01         BPL CODE_02EE9E           
ADDR_02EE9D:        88            DEY                       
CODE_02EE9E:        18            CLC                       
CODE_02EE9F:        65 94         ADC RAM_MarioXPos         
CODE_02EEA1:        85 94         STA RAM_MarioXPos         
CODE_02EEA3:        98            TYA                       
CODE_02EEA4:        65 95         ADC RAM_MarioXPosHi       
CODE_02EEA6:        85 95         STA RAM_MarioXPosHi       
Return02EEA8:       60            RTS                       ; Return 

CoinCloudMain:      8B            PHB                       
ADDR_02EEAA:        4B            PHK                       
ADDR_02EEAB:        AB            PLB                       
ADDR_02EEAC:        20 B5 EE      JSR.W ADDR_02EEB5         
ADDR_02EEAF:        AB            PLB                       
Return02EEB0:       6B            RTL                       ; Return 


DATA_02EEB1:                      .db $01,$FF

DATA_02EEB3:                      .db $10,$F0

ADDR_02EEB5:        B5 C2         LDA RAM_SpriteState,X     
ADDR_02EEB7:        D0 05         BNE ADDR_02EEBE           
ADDR_02EEB9:        F6 C2         INC RAM_SpriteState,X     
ADDR_02EEBB:        9C E3 18      STZ.W $18E3               
ADDR_02EEBE:        A5 9D         LDA RAM_SpritesLocked     
ADDR_02EEC0:        D0 5A         BNE ADDR_02EF1C           
ADDR_02EEC2:        A5 14         LDA RAM_FrameCounterB     
ADDR_02EEC4:        29 7F         AND.B #$7F                
ADDR_02EEC6:        D0 0D         BNE ADDR_02EED5           
ADDR_02EEC8:        BD 70 15      LDA.W $1570,X             
ADDR_02EECB:        C9 0B         CMP.B #$0B                
ADDR_02EECD:        B0 06         BCS ADDR_02EED5           
ADDR_02EECF:        FE 70 15      INC.W $1570,X             
ADDR_02EED2:        20 67 EF      JSR.W ADDR_02EF67         
ADDR_02EED5:        A5 14         LDA RAM_FrameCounterB     
ADDR_02EED7:        29 01         AND.B #$01                
ADDR_02EED9:        D0 37         BNE ADDR_02EF12           
ADDR_02EEDB:        B5 D8         LDA RAM_SpriteYLo,X       
ADDR_02EEDD:        85 00         STA $00                   
ADDR_02EEDF:        BD D4 14      LDA.W RAM_SpriteYHi,X     
ADDR_02EEE2:        85 01         STA $01                   
ADDR_02EEE4:        A9 10         LDA.B #$10                
ADDR_02EEE6:        85 02         STA $02                   
ADDR_02EEE8:        A9 01         LDA.B #$01                
ADDR_02EEEA:        85 03         STA $03                   
ADDR_02EEEC:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_02EEEE:        A5 00         LDA $00                   
ADDR_02EEF0:        C5 02         CMP $02                   
ADDR_02EEF2:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_02EEF4:        A0 00         LDY.B #$00                
ADDR_02EEF6:        90 01         BCC ADDR_02EEF9           
ADDR_02EEF8:        C8            INY                       
ADDR_02EEF9:        BD 70 15      LDA.W $1570,X             
ADDR_02EEFC:        C9 0B         CMP.B #$0B                
ADDR_02EEFE:        90 05         BCC ADDR_02EF05           
ADDR_02EF00:        20 25 D0      JSR.W SubOffscreen0Bnk2   
ADDR_02EF03:        A0 01         LDY.B #$01                
ADDR_02EF05:        B5 AA         LDA RAM_SpriteSpeedY,X    
ADDR_02EF07:        D9 B3 EE      CMP.W DATA_02EEB3,Y       
ADDR_02EF0A:        F0 06         BEQ ADDR_02EF12           
ADDR_02EF0C:        18            CLC                       
ADDR_02EF0D:        79 B1 EE      ADC.W DATA_02EEB1,Y       
ADDR_02EF10:        95 AA         STA RAM_SpriteSpeedY,X    
ADDR_02EF12:        20 94 D2      JSR.W UpdateYPosNoGrvty   
ADDR_02EF15:        A9 08         LDA.B #$08                
ADDR_02EF17:        95 B6         STA RAM_SpriteSpeedX,X    
ADDR_02EF19:        20 88 D2      JSR.W UpdateXPosNoGrvty   
ADDR_02EF1C:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
ADDR_02EF1F:        48            PHA                       
ADDR_02EF20:        18            CLC                       
ADDR_02EF21:        69 04         ADC.B #$04                
ADDR_02EF23:        9D EA 15      STA.W RAM_SprOAMIndex,X   
ADDR_02EF26:        22 B2 90 01   JSL.L GenericSprGfxRt2    
ADDR_02EF2A:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
ADDR_02EF2D:        A9 60         LDA.B #$60                
ADDR_02EF2F:        99 02 03      STA.W OAM_Tile,Y          
ADDR_02EF32:        A5 14         LDA RAM_FrameCounterB     
ADDR_02EF34:        0A            ASL                       
ADDR_02EF35:        0A            ASL                       
ADDR_02EF36:        0A            ASL                       
ADDR_02EF37:        29 C0         AND.B #$C0                
ADDR_02EF39:        09 30         ORA.B #$30                
ADDR_02EF3B:        99 03 03      STA.W OAM_Prop,Y          
ADDR_02EF3E:        68            PLA                       
ADDR_02EF3F:        9D EA 15      STA.W RAM_SprOAMIndex,X   
ADDR_02EF42:        20 78 D3      JSR.W GetDrawInfo2        
ADDR_02EF45:        A5 00         LDA $00                   
ADDR_02EF47:        18            CLC                       
ADDR_02EF48:        69 04         ADC.B #$04                
ADDR_02EF4A:        99 00 03      STA.W OAM_DispX,Y         
ADDR_02EF4D:        A5 01         LDA $01                   
ADDR_02EF4F:        18            CLC                       
ADDR_02EF50:        69 04         ADC.B #$04                
ADDR_02EF52:        99 01 03      STA.W OAM_DispY,Y         
ADDR_02EF55:        A9 4D         LDA.B #$4D                
ADDR_02EF57:        99 02 03      STA.W OAM_Tile,Y          
ADDR_02EF5A:        A9 39         LDA.B #$39                
ADDR_02EF5C:        99 03 03      STA.W OAM_Prop,Y          
ADDR_02EF5F:        A0 00         LDY.B #$00                
ADDR_02EF61:        A9 00         LDA.B #$00                
ADDR_02EF63:        20 A7 B7      JSR.W CODE_02B7A7         
Return02EF66:       60            RTS                       ; Return 

ADDR_02EF67:        AD E3 18      LDA.W $18E3               
ADDR_02EF6A:        C9 0A         CMP.B #$0A                
ADDR_02EF6C:        90 3C         BCC ADDR_02EFAA           
ADDR_02EF6E:        A0 0B         LDY.B #$0B                
ADDR_02EF70:        B9 C8 14      LDA.W $14C8,Y             
ADDR_02EF73:        F0 06         BEQ ADDR_02EF7B           
ADDR_02EF75:        88            DEY                       
ADDR_02EF76:        C0 09         CPY.B #$09                
ADDR_02EF78:        D0 F6         BNE ADDR_02EF70           
Return02EF7A:       60            RTS                       ; Return 

ADDR_02EF7B:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
ADDR_02EF7D:        99 C8 14      STA.W $14C8,Y             ; / 
ADDR_02EF80:        A9 78         LDA.B #$78                
ADDR_02EF82:        99 9E 00      STA.W RAM_SpriteNum,Y     
ADDR_02EF85:        B5 E4         LDA RAM_SpriteXLo,X       
ADDR_02EF87:        99 E4 00      STA.W RAM_SpriteXLo,Y     
ADDR_02EF8A:        BD E0 14      LDA.W RAM_SpriteXHi,X     
ADDR_02EF8D:        99 E0 14      STA.W RAM_SpriteXHi,Y     
ADDR_02EF90:        B5 D8         LDA RAM_SpriteYLo,X       
ADDR_02EF92:        99 D8 00      STA.W RAM_SpriteYLo,Y     
ADDR_02EF95:        BD D4 14      LDA.W RAM_SpriteYHi,X     
ADDR_02EF98:        99 D4 14      STA.W RAM_SpriteYHi,Y     
ADDR_02EF9B:        DA            PHX                       
ADDR_02EF9C:        BB            TYX                       
ADDR_02EF9D:        22 D2 F7 07   JSL.L InitSpriteTables    
ADDR_02EFA1:        A9 E0         LDA.B #$E0                
ADDR_02EFA3:        95 AA         STA RAM_SpriteSpeedY,X    
ADDR_02EFA5:        FE 7C 15      INC.W RAM_SpriteDir,X     
ADDR_02EFA8:        FA            PLX                       
Return02EFA9:       60            RTS                       ; Return 

ADDR_02EFAA:        BD 70 15      LDA.W $1570,X             
ADDR_02EFAD:        C9 0B         CMP.B #$0B                
ADDR_02EFAF:        B0 0A         BCS Return02EFBB          
ADDR_02EFB1:        A0 07         LDY.B #$07                ; \ Find a free extended sprite slot 
ADDR_02EFB3:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   ;  | 
ADDR_02EFB6:        F0 04         BEQ ADDR_02EFBC           ;  | 
ADDR_02EFB8:        88            DEY                       ;  | 
ADDR_02EFB9:        10 F8         BPL ADDR_02EFB3           ;  | 
Return02EFBB:       60            RTS                       ; / Return if no free slots 

ADDR_02EFBC:        A9 0A         LDA.B #$0A                ; \ Extended sprite = Cloud game coin 
ADDR_02EFBE:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
ADDR_02EFC1:        B5 E4         LDA RAM_SpriteXLo,X       
ADDR_02EFC3:        18            CLC                       
ADDR_02EFC4:        69 04         ADC.B #$04                
ADDR_02EFC6:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
ADDR_02EFC9:        BD E0 14      LDA.W RAM_SpriteXHi,X     
ADDR_02EFCC:        69 00         ADC.B #$00                
ADDR_02EFCE:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
ADDR_02EFD1:        B5 D8         LDA RAM_SpriteYLo,X       
ADDR_02EFD3:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
ADDR_02EFD6:        BD D4 14      LDA.W RAM_SpriteYHi,X     
ADDR_02EFD9:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
ADDR_02EFDC:        A9 D0         LDA.B #$D0                
ADDR_02EFDE:        99 3D 17      STA.W RAM_ExSprSpeedY,Y   
ADDR_02EFE1:        A9 00         LDA.B #$00                
ADDR_02EFE3:        99 47 17      STA.W RAM_ExSprSpeedX,Y   
ADDR_02EFE6:        99 65 17      STA.W $1765,Y             
Return02EFE9:       60            RTS                       ; Return 


DATA_02EFEA:                      .db $00,$80,$00,$80

DATA_02EFEE:                      .db $00,$00,$01,$01

WigglerInit:        8B            PHB                       
CODE_02EFF3:        4B            PHK                       
CODE_02EFF4:        AB            PLB                       
CODE_02EFF5:        20 11 F0      JSR.W CODE_02F011         
CODE_02EFF8:        A0 7E         LDY.B #$7E                
CODE_02EFFA:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02EFFC:        97 D5         STA [$D5],Y               
CODE_02EFFE:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02F000:        C8            INY                       
CODE_02F001:        97 D5         STA [$D5],Y               
CODE_02F003:        88            DEY                       
CODE_02F004:        88            DEY                       
CODE_02F005:        88            DEY                       
CODE_02F006:        10 F2         BPL CODE_02EFFA           
CODE_02F008:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02F00B:        98            TYA                       
CODE_02F00C:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02F00F:        AB            PLB                       
Return02F010:       6B            RTL                       ; Return 

CODE_02F011:        8A            TXA                       
CODE_02F012:        29 03         AND.B #$03                
CODE_02F014:        A8            TAY                       
CODE_02F015:        A9 7B         LDA.B #$7B                
CODE_02F017:        18            CLC                       
CODE_02F018:        79 EA EF      ADC.W DATA_02EFEA,Y       
CODE_02F01B:        85 D5         STA $D5                   
CODE_02F01D:        A9 9A         LDA.B #$9A                
CODE_02F01F:        79 EE EF      ADC.W DATA_02EFEE,Y       
CODE_02F022:        85 D6         STA $D6                   
CODE_02F024:        A9 7F         LDA.B #$7F                
CODE_02F026:        85 D7         STA $D7                   
Return02F028:       60            RTS                       ; Return 

WigglerMain:        8B            PHB                       
CODE_02F02A:        4B            PHK                       
CODE_02F02B:        AB            PLB                       
CODE_02F02C:        20 35 F0      JSR.W WigglerMainRt       
CODE_02F02F:        AB            PLB                       
Return02F030:       6B            RTL                       ; Return 


WigglerSpeed:                     .db $08,$F8,$10,$F0

WigglerMainRt:      20 11 F0      JSR.W CODE_02F011         
CODE_02F038:        A5 9D         LDA RAM_SpritesLocked     
CODE_02F03A:        F0 03         BEQ CODE_02F03F           
CODE_02F03C:        4C D8 F0      JMP.W CODE_02F0D8         

CODE_02F03F:        22 32 80 01   JSL.L SprSprInteract      
CODE_02F043:        BD 40 15      LDA.W $1540,X             
CODE_02F046:        F0 19         BEQ CODE_02F061           
CODE_02F048:        C9 01         CMP.B #$01                
CODE_02F04A:        D0 04         BNE CODE_02F050           
CODE_02F04C:        A9 08         LDA.B #$08                
CODE_02F04E:        80 02         BRA CODE_02F052           

CODE_02F050:        29 0E         AND.B #$0E                
CODE_02F052:        85 00         STA $00                   
CODE_02F054:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_02F057:        29 F1         AND.B #$F1                
CODE_02F059:        05 00         ORA $00                   
CODE_02F05B:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_02F05E:        4C D8 F0      JMP.W CODE_02F0D8         

CODE_02F061:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02F064:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02F067:        20 25 D0      JSR.W SubOffscreen0Bnk2   
CODE_02F06A:        FE 70 15      INC.W $1570,X             
CODE_02F06D:        BD 1C 15      LDA.W $151C,X             
CODE_02F070:        F0 14         BEQ CODE_02F086           
CODE_02F072:        FE 70 15      INC.W $1570,X             
CODE_02F075:        FE 34 15      INC.W $1534,X             
CODE_02F078:        BD 34 15      LDA.W $1534,X             
CODE_02F07B:        29 3F         AND.B #$3F                
CODE_02F07D:        D0 07         BNE CODE_02F086           
CODE_02F07F:        20 FA D4      JSR.W CODE_02D4FA         
CODE_02F082:        98            TYA                       
CODE_02F083:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02F086:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02F089:        BD 1C 15      LDA.W $151C,X             
CODE_02F08C:        F0 02         BEQ CODE_02F090           
CODE_02F08E:        C8            INY                       
CODE_02F08F:        C8            INY                       
CODE_02F090:        B9 31 F0      LDA.W WigglerSpeed,Y      
CODE_02F093:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02F095:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_02F097:        22 38 91 01   JSL.L CODE_019138         
CODE_02F09B:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if touching object 
CODE_02F09E:        29 03         AND.B #$03                ;  | 
CODE_02F0A0:        D0 0C         BNE CODE_02F0AE           ; / 
CODE_02F0A2:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_02F0A5:        29 04         AND.B #$04                ;  | 
CODE_02F0A7:        F0 05         BEQ CODE_02F0AE           ; / 
CODE_02F0A9:        20 D1 FF      JSR.W CODE_02FFD1         
CODE_02F0AC:        80 15         BRA CODE_02F0C3           

CODE_02F0AE:        BD AC 15      LDA.W $15AC,X             
CODE_02F0B1:        D0 10         BNE CODE_02F0C3           
CODE_02F0B3:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02F0B6:        49 01         EOR.B #$01                
CODE_02F0B8:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02F0BB:        9E 02 16      STZ.W $1602,X             
CODE_02F0BE:        A9 08         LDA.B #$08                
CODE_02F0C0:        9D AC 15      STA.W $15AC,X             
CODE_02F0C3:        20 DB F0      JSR.W CODE_02F0DB         
CODE_02F0C6:        BD 02 16      LDA.W $1602,X             
CODE_02F0C9:        FE 02 16      INC.W $1602,X             
CODE_02F0CC:        29 07         AND.B #$07                
CODE_02F0CE:        D0 08         BNE CODE_02F0D8           
CODE_02F0D0:        B5 C2         LDA RAM_SpriteState,X     
CODE_02F0D2:        0A            ASL                       
CODE_02F0D3:        1D 7C 15      ORA.W RAM_SpriteDir,X     
CODE_02F0D6:        95 C2         STA RAM_SpriteState,X     
CODE_02F0D8:        4C 10 F1      JMP.W CODE_02F110         

CODE_02F0DB:        DA            PHX                       
CODE_02F0DC:        8B            PHB                       
CODE_02F0DD:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_02F0DF:        A5 D5         LDA $D5                   
CODE_02F0E1:        18            CLC                       
CODE_02F0E2:        69 7D 00      ADC.W #$007D              
CODE_02F0E5:        AA            TAX                       
CODE_02F0E6:        A5 D5         LDA $D5                   
CODE_02F0E8:        18            CLC                       
CODE_02F0E9:        69 7F 00      ADC.W #$007F              
CODE_02F0EC:        A8            TAY                       
CODE_02F0ED:        A9 7D 00      LDA.W #$007D              
CODE_02F0F0:        44 7F 7F      MVP $7F,$7F               
CODE_02F0F3:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_02F0F5:        AB            PLB                       
CODE_02F0F6:        FA            PLX                       
CODE_02F0F7:        A0 00         LDY.B #$00                
CODE_02F0F9:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02F0FB:        97 D5         STA [$D5],Y               
CODE_02F0FD:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02F0FF:        C8            INY                       
CODE_02F100:        97 D5         STA [$D5],Y               
Return02F102:       60            RTS                       ; Return 


DATA_02F103:                      .db $00,$1E,$3E,$5E,$7E

DATA_02F108:                      .db $00,$01,$02,$01

WigglerTiles:                     .db $C4,$C6,$C8,$C6

CODE_02F110:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02F113:        BD 70 15      LDA.W $1570,X             
CODE_02F116:        85 03         STA $03                   
CODE_02F118:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_02F11B:        85 07         STA $07                   
CODE_02F11D:        BD 1C 15      LDA.W $151C,X             
CODE_02F120:        85 08         STA $08                   
CODE_02F122:        B5 C2         LDA RAM_SpriteState,X     
CODE_02F124:        85 02         STA $02                   
CODE_02F126:        98            TYA                       
CODE_02F127:        18            CLC                       
CODE_02F128:        69 04         ADC.B #$04                
CODE_02F12A:        A8            TAY                       
CODE_02F12B:        A2 00         LDX.B #$00                
CODE_02F12D:        DA            PHX                       
CODE_02F12E:        86 05         STX $05                   
CODE_02F130:        A5 03         LDA $03                   
CODE_02F132:        4A            LSR                       
CODE_02F133:        4A            LSR                       
CODE_02F134:        4A            LSR                       
CODE_02F135:        EA            NOP                       
CODE_02F136:        EA            NOP                       
CODE_02F137:        EA            NOP                       
CODE_02F138:        EA            NOP                       
CODE_02F139:        18            CLC                       
CODE_02F13A:        65 05         ADC $05                   
CODE_02F13C:        29 03         AND.B #$03                
CODE_02F13E:        85 06         STA $06                   
CODE_02F140:        5A            PHY                       
CODE_02F141:        BC 03 F1      LDY.W DATA_02F103,X       
CODE_02F144:        A5 08         LDA $08                   
CODE_02F146:        F0 05         BEQ CODE_02F14D           
CODE_02F148:        98            TYA                       
CODE_02F149:        4A            LSR                       
CODE_02F14A:        29 FE         AND.B #$FE                
CODE_02F14C:        A8            TAY                       
CODE_02F14D:        84 09         STY $09                   
CODE_02F14F:        B7 D5         LDA [$D5],Y               
CODE_02F151:        7A            PLY                       
CODE_02F152:        38            SEC                       
CODE_02F153:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02F155:        99 00 03      STA.W OAM_DispX,Y         
CODE_02F158:        5A            PHY                       
CODE_02F159:        A4 09         LDY $09                   
CODE_02F15B:        C8            INY                       
CODE_02F15C:        B7 D5         LDA [$D5],Y               
CODE_02F15E:        7A            PLY                       
CODE_02F15F:        38            SEC                       
CODE_02F160:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02F162:        A6 06         LDX $06                   
CODE_02F164:        38            SEC                       
CODE_02F165:        FD 08 F1      SBC.W DATA_02F108,X       
CODE_02F168:        99 01 03      STA.W OAM_DispY,Y         
CODE_02F16B:        FA            PLX                       
CODE_02F16C:        DA            PHX                       
CODE_02F16D:        A9 8C         LDA.B #$8C                
CODE_02F16F:        E0 00         CPX.B #$00                
CODE_02F171:        F0 05         BEQ CODE_02F178           
CODE_02F173:        A6 06         LDX $06                   
CODE_02F175:        BD 0C F1      LDA.W WigglerTiles,X      
CODE_02F178:        99 02 03      STA.W OAM_Tile,Y          
CODE_02F17B:        FA            PLX                       
CODE_02F17C:        A5 07         LDA $07                   
CODE_02F17E:        05 64         ORA $64                   
CODE_02F180:        46 02         LSR $02                   
CODE_02F182:        B0 02         BCS CODE_02F186           
CODE_02F184:        09 40         ORA.B #$40                
CODE_02F186:        99 03 03      STA.W OAM_Prop,Y          
CODE_02F189:        5A            PHY                       
CODE_02F18A:        98            TYA                       
CODE_02F18B:        4A            LSR                       
CODE_02F18C:        4A            LSR                       
CODE_02F18D:        A8            TAY                       
CODE_02F18E:        A9 02         LDA.B #$02                
CODE_02F190:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02F193:        7A            PLY                       
CODE_02F194:        C8            INY                       
CODE_02F195:        C8            INY                       
CODE_02F196:        C8            INY                       
CODE_02F197:        C8            INY                       
CODE_02F198:        E8            INX                       
CODE_02F199:        E0 05         CPX.B #$05                
CODE_02F19B:        D0 90         BNE CODE_02F12D           
CODE_02F19D:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02F1A0:        A5 08         LDA $08                   
CODE_02F1A2:        F0 23         BEQ CODE_02F1C7           
CODE_02F1A4:        DA            PHX                       
CODE_02F1A5:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02F1A8:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02F1AB:        AA            TAX                       
CODE_02F1AC:        B9 04 03      LDA.W OAM_Tile2DispX,Y    
CODE_02F1AF:        18            CLC                       
CODE_02F1B0:        7D D5 F2      ADC.W WigglerEyesX,X      
CODE_02F1B3:        FA            PLX                       
CODE_02F1B4:        99 00 03      STA.W OAM_DispX,Y         
CODE_02F1B7:        B9 05 03      LDA.W OAM_Tile2DispY,Y    
CODE_02F1BA:        99 01 03      STA.W OAM_DispY,Y         
CODE_02F1BD:        A9 88         LDA.B #$88                
CODE_02F1BF:        99 02 03      STA.W OAM_Tile,Y          
CODE_02F1C2:        B9 07 03      LDA.W OAM_Tile2Prop,Y     
CODE_02F1C5:        80 28         BRA CODE_02F1EF           

CODE_02F1C7:        DA            PHX                       
CODE_02F1C8:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02F1CB:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02F1CE:        AA            TAX                       
CODE_02F1CF:        B9 04 03      LDA.W OAM_Tile2DispX,Y    
CODE_02F1D2:        18            CLC                       
CODE_02F1D3:        7D D3 F2      ADC.W DATA_02F2D3,X       
CODE_02F1D6:        FA            PLX                       
CODE_02F1D7:        99 00 03      STA.W OAM_DispX,Y         
CODE_02F1DA:        B9 05 03      LDA.W OAM_Tile2DispY,Y    
CODE_02F1DD:        38            SEC                       
CODE_02F1DE:        E9 08         SBC.B #$08                
CODE_02F1E0:        99 01 03      STA.W OAM_DispY,Y         
CODE_02F1E3:        A9 98         LDA.B #$98                
CODE_02F1E5:        99 02 03      STA.W OAM_Tile,Y          
CODE_02F1E8:        B9 07 03      LDA.W OAM_Tile2Prop,Y     
CODE_02F1EB:        29 F1         AND.B #$F1                
CODE_02F1ED:        09 0A         ORA.B #$0A                
CODE_02F1EF:        99 03 03      STA.W OAM_Prop,Y          
CODE_02F1F2:        98            TYA                       
CODE_02F1F3:        4A            LSR                       
CODE_02F1F4:        4A            LSR                       
CODE_02F1F5:        A8            TAY                       
CODE_02F1F6:        A9 00         LDA.B #$00                
CODE_02F1F8:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02F1FB:        A9 05         LDA.B #$05                
CODE_02F1FD:        A0 FF         LDY.B #$FF                
CODE_02F1FF:        20 A7 B7      JSR.W CODE_02B7A7         
CODE_02F202:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02F204:        85 00         STA $00                   
CODE_02F206:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02F209:        85 01         STA $01                   
CODE_02F20B:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_02F20D:        A5 00         LDA $00                   
CODE_02F20F:        38            SEC                       
CODE_02F210:        E5 94         SBC RAM_MarioXPos         
CODE_02F212:        18            CLC                       
CODE_02F213:        69 50 00      ADC.W #$0050              
CODE_02F216:        C9 A0 00      CMP.W #$00A0              
CODE_02F219:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_02F21B:        B0 78         BCS Return02F295          
CODE_02F21D:        BD C8 14      LDA.W $14C8,X             
CODE_02F220:        C9 08         CMP.B #$08                
CODE_02F222:        D0 71         BNE Return02F295          
CODE_02F224:        A9 04         LDA.B #$04                
CODE_02F226:        85 00         STA $00                   
CODE_02F228:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02F22B:        B9 04 03      LDA.W OAM_Tile2DispX,Y    
CODE_02F22E:        38            SEC                       
CODE_02F22F:        E5 7E         SBC $7E                   
CODE_02F231:        69 0C         ADC.B #$0C                
CODE_02F233:        C9 18         CMP.B #$18                
CODE_02F235:        B0 64         BCS CODE_02F29B           
CODE_02F237:        B9 05 03      LDA.W OAM_Tile2DispY,Y    
CODE_02F23A:        38            SEC                       
CODE_02F23B:        E5 80         SBC $80                   
CODE_02F23D:        E9 10         SBC.B #$10                
CODE_02F23F:        5A            PHY                       
CODE_02F240:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_02F243:        F0 02         BEQ CODE_02F247           
CODE_02F245:        E9 10         SBC.B #$10                
CODE_02F247:        7A            PLY                       
CODE_02F248:        18            CLC                       
CODE_02F249:        69 0C         ADC.B #$0C                
CODE_02F24B:        C9 18         CMP.B #$18                
CODE_02F24D:        B0 4C         BCS CODE_02F29B           
CODE_02F24F:        AD 90 14      LDA.W $1490               ; \ Branch if Mario has star 
CODE_02F252:        D0 49         BNE ADDR_02F29D           ; / 
CODE_02F254:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_02F257:        05 81         ORA $81                   
CODE_02F259:        D0 40         BNE CODE_02F29B           
CODE_02F25B:        A9 08         LDA.B #$08                
CODE_02F25D:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_02F260:        AD 97 16      LDA.W $1697               
CODE_02F263:        D0 06         BNE CODE_02F26B           
CODE_02F265:        A5 7D         LDA RAM_MarioSpeedY       
CODE_02F267:        C9 08         CMP.B #$08                
CODE_02F269:        30 2B         BMI CODE_02F296           
CODE_02F26B:        A9 03         LDA.B #$03                ; \ Play sound effect 
CODE_02F26D:        8D F9 1D      STA.W $1DF9               ; / 
CODE_02F270:        22 33 AA 01   JSL.L BoostMarioSpeed     
CODE_02F274:        BD 1C 15      LDA.W $151C,X             
CODE_02F277:        1D D0 15      ORA.W $15D0,X             
CODE_02F27A:        D0 19         BNE Return02F295          
CODE_02F27C:        22 99 AB 01   JSL.L DisplayContactGfx   
CODE_02F280:        AD 97 16      LDA.W $1697               
CODE_02F283:        EE 97 16      INC.W $1697               
CODE_02F286:        22 E5 AC 02   JSL.L GivePoints          
CODE_02F28A:        A9 40         LDA.B #$40                
CODE_02F28C:        9D 40 15      STA.W $1540,X             
CODE_02F28F:        FE 1C 15      INC.W $151C,X             
CODE_02F292:        20 D7 F2      JSR.W CODE_02F2D7         
Return02F295:       60            RTS                       ; Return 

CODE_02F296:        22 B7 F5 00   JSL.L HurtMario           
Return02F29A:       60            RTS                       ; Return 

CODE_02F29B:        80 2A         BRA CODE_02F2C7           

ADDR_02F29D:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
ADDR_02F29F:        9D C8 14      STA.W $14C8,X             ; / 
ADDR_02F2A2:        A9 D0         LDA.B #$D0                
ADDR_02F2A4:        95 AA         STA RAM_SpriteSpeedY,X    
ADDR_02F2A6:        EE D2 18      INC.W $18D2               
ADDR_02F2A9:        AD D2 18      LDA.W $18D2               
ADDR_02F2AC:        C9 09         CMP.B #$09                
ADDR_02F2AE:        90 05         BCC ADDR_02F2B5           
ADDR_02F2B0:        A9 09         LDA.B #$09                
ADDR_02F2B2:        8D D2 18      STA.W $18D2               
ADDR_02F2B5:        22 E5 AC 02   JSL.L GivePoints          
ADDR_02F2B9:        AC D2 18      LDY.W $18D2               
ADDR_02F2BC:        C0 08         CPY.B #$08                
ADDR_02F2BE:        B0 06         BCS Return02F2C6          
ADDR_02F2C0:        B9 7F D5      LDA.W DATA_02D57F,Y       ; \ Play sound effect 
ADDR_02F2C3:        8D F9 1D      STA.W $1DF9               ; / 
Return02F2C6:       60            RTS                       ; Return 

CODE_02F2C7:        C8            INY                       
CODE_02F2C8:        C8            INY                       
CODE_02F2C9:        C8            INY                       
CODE_02F2CA:        C8            INY                       
CODE_02F2CB:        C6 00         DEC $00                   
CODE_02F2CD:        30 03         BMI Return02F2D2          
CODE_02F2CF:        4C 2B F2      JMP.W CODE_02F22B         

Return02F2D2:       60            RTS                       ; Return 


DATA_02F2D3:                      .db $00,$08

WigglerEyesX:                     .db $04,$04

CODE_02F2D7:        A0 07         LDY.B #$07                ; \ Find a free extended sprite slot 
CODE_02F2D9:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   ;  | 
CODE_02F2DC:        F0 04         BEQ CODE_02F2E2           ;  | 
CODE_02F2DE:        88            DEY                       ;  | 
CODE_02F2DF:        10 F8         BPL CODE_02F2D9           ;  | 
Return02F2E1:       60            RTS                       ; / Return if no free slots 

CODE_02F2E2:        A9 0E         LDA.B #$0E                ; \ Extended sprite = Wiggler flower 
CODE_02F2E4:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_02F2E7:        A9 01         LDA.B #$01                
CODE_02F2E9:        99 65 17      STA.W $1765,Y             
CODE_02F2EC:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02F2EE:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
CODE_02F2F1:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_02F2F4:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
CODE_02F2F7:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02F2F9:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
CODE_02F2FC:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02F2FE:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
CODE_02F301:        A9 D0         LDA.B #$D0                
CODE_02F303:        99 3D 17      STA.W RAM_ExSprSpeedY,Y   
CODE_02F306:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_02F308:        49 FF         EOR.B #$FF                
CODE_02F30A:        1A            INC A                     
CODE_02F30B:        99 47 17      STA.W RAM_ExSprSpeedX,Y   
Return02F30E:       60            RTS                       ; Return 

BirdsMain:          8B            PHB                       
CODE_02F310:        4B            PHK                       
CODE_02F311:        AB            PLB                       
CODE_02F312:        20 17 F3      JSR.W CODE_02F317         
CODE_02F315:        AB            PLB                       
Return02F316:       6B            RTL                       ; Return 

CODE_02F317:        BD AC 15      LDA.W $15AC,X             
CODE_02F31A:        F0 05         BEQ CODE_02F321           
CODE_02F31C:        A9 04         LDA.B #$04                
CODE_02F31E:        9D 02 16      STA.W $1602,X             
CODE_02F321:        20 EA F3      JSR.W CODE_02F3EA         
CODE_02F324:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02F327:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02F32A:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02F32C:        18            CLC                       
CODE_02F32D:        69 03         ADC.B #$03                
CODE_02F32F:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02F331:        B5 C2         LDA RAM_SpriteState,X     
CODE_02F333:        22 DF 86 00   JSL.L ExecutePtr          

BirdsPtrs:             42 F3      .dw CODE_02F342           
                       8F F3      .dw CODE_02F38F           

Return02F33B:       60            RTS                       


DATA_02F33C:                      .db $02,$03,$05,$01

DATA_02F340:                      .db $08,$F8

CODE_02F342:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02F345:        B9 40 F3      LDA.W DATA_02F340,Y       
CODE_02F348:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_02F34A:        9E 02 16      STZ.W $1602,X             
CODE_02F34D:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_02F34F:        30 1F         BMI Return02F370          
CODE_02F351:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02F353:        C9 E8         CMP.B #$E8                
CODE_02F355:        90 19         BCC Return02F370          
CODE_02F357:        29 F8         AND.B #$F8                
CODE_02F359:        95 D8         STA RAM_SpriteYLo,X       
CODE_02F35B:        A9 F0         LDA.B #$F0                
CODE_02F35D:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02F35F:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02F361:        18            CLC                       
CODE_02F362:        69 30         ADC.B #$30                
CODE_02F364:        C9 60         CMP.B #$60                
CODE_02F366:        90 19         BCC CODE_02F381           
CODE_02F368:        BD 70 15      LDA.W $1570,X             
CODE_02F36B:        F0 04         BEQ CODE_02F371           
CODE_02F36D:        DE 70 15      DEC.W $1570,X             
Return02F370:       60            RTS                       ; Return 

CODE_02F371:        F6 C2         INC RAM_SpriteState,X     
CODE_02F373:        22 F9 AC 01   JSL.L GetRand             
CODE_02F377:        29 03         AND.B #$03                
CODE_02F379:        A8            TAY                       
CODE_02F37A:        B9 3C F3      LDA.W DATA_02F33C,Y       
CODE_02F37D:        9D 70 15      STA.W $1570,X             
Return02F380:       60            RTS                       ; Return 

CODE_02F381:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_02F384:        D0 08         BNE Return02F38E          
CODE_02F386:        20 C1 F3      JSR.W CODE_02F3C1         
CODE_02F389:        A9 10         LDA.B #$10                
CODE_02F38B:        9D 4C 15      STA.W RAM_DisableInter,X  
Return02F38E:       60            RTS                       ; Return 

CODE_02F38F:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_02F391:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_02F393:        9E 02 16      STZ.W $1602,X             
CODE_02F396:        BD 40 15      LDA.W $1540,X             
CODE_02F399:        F0 08         BEQ CODE_02F3A3           
CODE_02F39B:        C9 08         CMP.B #$08                
CODE_02F39D:        B0 03         BCS Return02F3A2          
CODE_02F39F:        FE 02 16      INC.W $1602,X             
Return02F3A2:       60            RTS                       ; Return 

CODE_02F3A3:        BD 70 15      LDA.W $1570,X             
CODE_02F3A6:        F0 0F         BEQ CODE_02F3B7           
CODE_02F3A8:        DE 70 15      DEC.W $1570,X             
CODE_02F3AB:        22 F9 AC 01   JSL.L GetRand             
CODE_02F3AF:        29 1F         AND.B #$1F                
CODE_02F3B1:        09 0A         ORA.B #$0A                
CODE_02F3B3:        9D 40 15      STA.W $1540,X             
Return02F3B6:       60            RTS                       ; Return 

CODE_02F3B7:        74 C2         STZ RAM_SpriteState,X     
CODE_02F3B9:        22 F9 AC 01   JSL.L GetRand             
CODE_02F3BD:        29 01         AND.B #$01                
CODE_02F3BF:        D0 0D         BNE CODE_02F3CE           
CODE_02F3C1:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_02F3C4:        49 01         EOR.B #$01                
CODE_02F3C6:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_02F3C9:        A9 0A         LDA.B #$0A                
CODE_02F3CB:        9D AC 15      STA.W $15AC,X             
CODE_02F3CE:        22 F9 AC 01   JSL.L GetRand             
CODE_02F3D2:        29 03         AND.B #$03                
CODE_02F3D4:        18            CLC                       
CODE_02F3D5:        69 02         ADC.B #$02                
CODE_02F3D7:        9D 70 15      STA.W $1570,X             
Return02F3DA:       60            RTS                       ; Return 


BirdsTilemap:                     .db $D2,$D3,$D0,$D1,$9B

BirdsFlip:                        .db $71,$31

BirdsPal:                         .db $08,$04,$06,$0A

FireplaceTilemap:                 .db $30,$34,$48,$3C

CODE_02F3EA:        8A            TXA                       
CODE_02F3EB:        29 03         AND.B #$03                
CODE_02F3ED:        A8            TAY                       
CODE_02F3EE:        B9 E2 F3      LDA.W BirdsPal,Y          
CODE_02F3F1:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_02F3F4:        19 E0 F3      ORA.W BirdsFlip,Y         
CODE_02F3F7:        85 02         STA $02                   
CODE_02F3F9:        8A            TXA                       
CODE_02F3FA:        29 03         AND.B #$03                
CODE_02F3FC:        A8            TAY                       
CODE_02F3FD:        B9 E6 F3      LDA.W FireplaceTilemap,Y  
CODE_02F400:        A8            TAY                       
CODE_02F401:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02F403:        38            SEC                       
CODE_02F404:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02F406:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_02F409:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02F40B:        38            SEC                       
CODE_02F40C:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02F40E:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_02F411:        DA            PHX                       
CODE_02F412:        BD 02 16      LDA.W $1602,X             
CODE_02F415:        AA            TAX                       
CODE_02F416:        BD DB F3      LDA.W BirdsTilemap,X      
CODE_02F419:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02F41C:        FA            PLX                       
CODE_02F41D:        A5 02         LDA $02                   
CODE_02F41F:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02F422:        98            TYA                       
CODE_02F423:        4A            LSR                       
CODE_02F424:        4A            LSR                       
CODE_02F425:        A8            TAY                       
CODE_02F426:        A9 00         LDA.B #$00                
CODE_02F428:        99 20 04      STA.W $0420,Y             
Return02F42B:       60            RTS                       ; Return 

SmokeMain:          8B            PHB                       
CODE_02F42D:        4B            PHK                       
CODE_02F42E:        AB            PLB                       
CODE_02F42F:        20 34 F4      JSR.W CODE_02F434         
CODE_02F432:        AB            PLB                       
Return02F433:       6B            RTL                       ; Return 

CODE_02F434:        FE 70 15      INC.W $1570,X             
CODE_02F437:        A0 04         LDY.B #$04                
CODE_02F439:        BD 70 15      LDA.W $1570,X             
CODE_02F43C:        29 40         AND.B #$40                
CODE_02F43E:        F0 02         BEQ CODE_02F442           
CODE_02F440:        A0 FE         LDY.B #$FE                
CODE_02F442:        94 B6         STY RAM_SpriteSpeedX,X    
CODE_02F444:        A9 FC         LDA.B #$FC                
CODE_02F446:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_02F448:        20 94 D2      JSR.W UpdateYPosNoGrvty   
CODE_02F44B:        BD 40 15      LDA.W $1540,X             
CODE_02F44E:        D0 03         BNE CODE_02F453           
CODE_02F450:        20 88 D2      JSR.W UpdateXPosNoGrvty   
CODE_02F453:        20 7C F4      JSR.W CODE_02F47C         
CODE_02F456:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02F458:        38            SEC                       
CODE_02F459:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02F45B:        C9 F0         CMP.B #$F0                
CODE_02F45D:        D0 03         BNE Return02F462          
CODE_02F45F:        9E C8 14      STZ.W $14C8,X             
Return02F462:       60            RTS                       ; Return 


DATA_02F463:                      .db $03,$04,$05,$04,$05,$06,$05,$06
                                  .db $07,$06,$07,$08,$07,$08,$07,$08
                                  .db $07,$08,$07,$08,$07,$08,$07,$08
                                  .db $07

CODE_02F47C:        A5 14         LDA RAM_FrameCounterB     
CODE_02F47E:        29 0F         AND.B #$0F                
CODE_02F480:        D0 03         BNE CODE_02F485           
CODE_02F482:        FE 1C 15      INC.W $151C,X             
CODE_02F485:        BC 1C 15      LDY.W $151C,X             
CODE_02F488:        B9 63 F4      LDA.W DATA_02F463,Y       
CODE_02F48B:        85 00         STA $00                   
CODE_02F48D:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_02F490:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02F492:        38            SEC                       
CODE_02F493:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02F495:        48            PHA                       
CODE_02F496:        38            SEC                       
CODE_02F497:        E5 00         SBC $00                   
CODE_02F499:        99 00 03      STA.W OAM_DispX,Y         
CODE_02F49C:        68            PLA                       
CODE_02F49D:        18            CLC                       
CODE_02F49E:        65 00         ADC $00                   
CODE_02F4A0:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_02F4A3:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_02F4A5:        38            SEC                       
CODE_02F4A6:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02F4A8:        99 01 03      STA.W OAM_DispY,Y         
CODE_02F4AB:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_02F4AE:        A9 C5         LDA.B #$C5                
CODE_02F4B0:        99 02 03      STA.W OAM_Tile,Y          
CODE_02F4B3:        99 06 03      STA.W OAM_Tile2,Y         
CODE_02F4B6:        A9 05         LDA.B #$05                
CODE_02F4B8:        99 03 03      STA.W OAM_Prop,Y          
CODE_02F4BB:        09 40         ORA.B #$40                
CODE_02F4BD:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02F4C0:        98            TYA                       
CODE_02F4C1:        4A            LSR                       
CODE_02F4C2:        4A            LSR                       
CODE_02F4C3:        A8            TAY                       
CODE_02F4C4:        A9 02         LDA.B #$02                
CODE_02F4C6:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02F4C9:        99 61 04      STA.W $0461,Y             
Return02F4CC:       60            RTS                       ; Return 

SideExitMain:       8B            PHB                       
CODE_02F4CE:        4B            PHK                       
CODE_02F4CF:        AB            PLB                       
CODE_02F4D0:        20 D5 F4      JSR.W CODE_02F4D5         
CODE_02F4D3:        AB            PLB                       
Return02F4D4:       6B            RTL                       ; Return 

CODE_02F4D5:        A9 01         LDA.B #$01                
CODE_02F4D7:        8D 96 1B      STA.W $1B96               
CODE_02F4DA:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_02F4DC:        29 10         AND.B #$10                
CODE_02F4DE:        D0 06         BNE Return02F4E6          
CODE_02F4E0:        20 EB F4      JSR.W CODE_02F4EB         
CODE_02F4E3:        20 3E F5      JSR.W CODE_02F53E         
Return02F4E6:       60            RTS                       ; Return 


DATA_02F4E7:                      .db $D4,$AB

DATA_02F4E9:                      .db $BB,$9A

CODE_02F4EB:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_02F4EE:        18            CLC                       
CODE_02F4EF:        69 08         ADC.B #$08                
CODE_02F4F1:        A8            TAY                       
CODE_02F4F2:        A9 B8         LDA.B #$B8                
CODE_02F4F4:        99 00 03      STA.W OAM_DispX,Y         
CODE_02F4F7:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_02F4FA:        A9 B0         LDA.B #$B0                
CODE_02F4FC:        99 01 03      STA.W OAM_DispY,Y         
CODE_02F4FF:        A9 B8         LDA.B #$B8                
CODE_02F501:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_02F504:        A5 13         LDA RAM_FrameCounter      
CODE_02F506:        29 03         AND.B #$03                
CODE_02F508:        D0 0C         BNE CODE_02F516           
CODE_02F50A:        5A            PHY                       
CODE_02F50B:        22 F9 AC 01   JSL.L GetRand             
CODE_02F50F:        7A            PLY                       
CODE_02F510:        29 03         AND.B #$03                
CODE_02F512:        D0 02         BNE CODE_02F516           
CODE_02F514:        F6 C2         INC RAM_SpriteState,X     
CODE_02F516:        DA            PHX                       
CODE_02F517:        B5 C2         LDA RAM_SpriteState,X     
CODE_02F519:        29 01         AND.B #$01                
CODE_02F51B:        AA            TAX                       
CODE_02F51C:        BD E7 F4      LDA.W DATA_02F4E7,X       
CODE_02F51F:        99 02 03      STA.W OAM_Tile,Y          
CODE_02F522:        BD E9 F4      LDA.W DATA_02F4E9,X       
CODE_02F525:        99 06 03      STA.W OAM_Tile2,Y         
CODE_02F528:        A9 35         LDA.B #$35                
CODE_02F52A:        99 03 03      STA.W OAM_Prop,Y          
CODE_02F52D:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_02F530:        98            TYA                       
CODE_02F531:        4A            LSR                       
CODE_02F532:        4A            LSR                       
CODE_02F533:        A8            TAY                       
CODE_02F534:        A9 00         LDA.B #$00                
CODE_02F536:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02F539:        99 61 04      STA.W $0461,Y             
CODE_02F53C:        FA            PLX                       
Return02F53D:       60            RTS                       ; Return 

CODE_02F53E:        A5 14         LDA RAM_FrameCounterB     
CODE_02F540:        29 3F         AND.B #$3F                
CODE_02F542:        D0 03         BNE Return02F547          
CODE_02F544:        20 48 F5      JSR.W CODE_02F548         
Return02F547:       60            RTS                       ; Return 

CODE_02F548:        A0 09         LDY.B #$09                
CODE_02F54A:        B9 C8 14      LDA.W $14C8,Y             
CODE_02F54D:        F0 04         BEQ CODE_02F553           
CODE_02F54F:        88            DEY                       
CODE_02F550:        10 F8         BPL CODE_02F54A           
Return02F552:       60            RTS                       ; Return 

CODE_02F553:        A9 8B         LDA.B #$8B                
CODE_02F555:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_02F558:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_02F55A:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_02F55D:        DA            PHX                       
CODE_02F55E:        BB            TYX                       
CODE_02F55F:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_02F563:        A9 BB         LDA.B #$BB                
CODE_02F565:        95 E4         STA RAM_SpriteXLo,X       
CODE_02F567:        A9 00         LDA.B #$00                
CODE_02F569:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_02F56C:        A9 00         LDA.B #$00                
CODE_02F56E:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_02F571:        A9 E0         LDA.B #$E0                
CODE_02F573:        95 D8         STA RAM_SpriteYLo,X       
CODE_02F575:        A9 20         LDA.B #$20                
CODE_02F577:        9D 40 15      STA.W $1540,X             
CODE_02F57A:        FA            PLX                       
Return02F57B:       60            RTS                       ; Return 

CODE_02F57C:        8B            PHB                       ; Wrapper 
CODE_02F57D:        4B            PHK                       
CODE_02F57E:        AB            PLB                       
CODE_02F57F:        20 59 F7      JSR.W CODE_02F759         
CODE_02F582:        AB            PLB                       
Return02F583:       6B            RTL                       ; Return 

CODE_02F584:        8B            PHB                       ; Wrapper 
CODE_02F585:        4B            PHK                       
CODE_02F586:        AB            PLB                       
CODE_02F587:        20 6E F6      JSR.W CODE_02F66E         
CODE_02F58A:        AB            PLB                       
Return02F58B:       6B            RTL                       ; Return 

ADDR_02F58C:        8B            PHB                       ; Wrapper 
ADDR_02F58D:        4B            PHK                       
ADDR_02F58E:        AB            PLB                       
ADDR_02F58F:        20 39 F6      JSR.W ADDR_02F639         
ADDR_02F592:        AB            PLB                       
Return02F593:       6B            RTL                       ; Return 

GhostExitMain:      8B            PHB                       
CODE_02F595:        4B            PHK                       
CODE_02F596:        AB            PLB                       
CODE_02F597:        DA            PHX                       
CODE_02F598:        20 D0 F5      JSR.W CODE_02F5D0         
CODE_02F59B:        FA            PLX                       
CODE_02F59C:        AB            PLB                       
Return02F59D:       6B            RTL                       ; Return 


DATA_02F59E:                      .db $08,$18,$F8,$F8,$F8,$F8,$28,$28
                                  .db $28,$28

DATA_02F5A8:                      .db $00,$00,$FF,$FF,$FF,$FF,$00,$00
                                  .db $00,$00

DATA_02F5B2:                      .db $5F,$5F,$8F,$97,$A7,$AF,$8F,$97
                                  .db $A7,$AF

DATA_02F5BC:                      .db $9C,$9E,$A0,$B0,$B0,$A0,$A0,$B0
                                  .db $B0,$A0

DATA_02F5C6:                      .db $23,$23,$2D,$2D,$AD,$AD,$6D,$6D
                                  .db $ED,$ED

CODE_02F5D0:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_02F5D2:        C9 46         CMP.B #$46                
CODE_02F5D4:        B0 42         BCS Return02F618          
CODE_02F5D6:        A2 09         LDX.B #$09                
CODE_02F5D8:        A0 A0         LDY.B #$A0                
CODE_02F5DA:        64 02         STZ $02                   
CODE_02F5DC:        BD 9E F5      LDA.W DATA_02F59E,X       
CODE_02F5DF:        38            SEC                       
CODE_02F5E0:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02F5E2:        85 00         STA $00                   
CODE_02F5E4:        BD A8 F5      LDA.W DATA_02F5A8,X       
CODE_02F5E7:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_02F5E9:        F0 02         BEQ CODE_02F5ED           
CODE_02F5EB:        E6 02         INC $02                   
CODE_02F5ED:        A5 00         LDA $00                   
CODE_02F5EF:        99 00 03      STA.W OAM_DispX,Y         
CODE_02F5F2:        BD B2 F5      LDA.W DATA_02F5B2,X       
CODE_02F5F5:        99 01 03      STA.W OAM_DispY,Y         
CODE_02F5F8:        BD BC F5      LDA.W DATA_02F5BC,X       
CODE_02F5FB:        99 02 03      STA.W OAM_Tile,Y          
CODE_02F5FE:        BD C6 F5      LDA.W DATA_02F5C6,X       
CODE_02F601:        99 03 03      STA.W OAM_Prop,Y          
CODE_02F604:        5A            PHY                       
CODE_02F605:        98            TYA                       
CODE_02F606:        4A            LSR                       
CODE_02F607:        4A            LSR                       
CODE_02F608:        A8            TAY                       
CODE_02F609:        A9 02         LDA.B #$02                
CODE_02F60B:        05 02         ORA $02                   
CODE_02F60D:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02F610:        7A            PLY                       
CODE_02F611:        C8            INY                       
CODE_02F612:        C8            INY                       
CODE_02F613:        C8            INY                       
CODE_02F614:        C8            INY                       
CODE_02F615:        CA            DEX                       
CODE_02F616:        10 C2         BPL CODE_02F5DA           
Return02F618:       60            RTS                       ; Return 


DATA_02F619:                      .db $F8,$08,$F8,$08,$00,$00,$00,$00
DATA_02F621:                      .db $00,$00,$10,$10,$20,$30,$40,$08
DATA_02F629:                      .db $C7,$A7,$A7,$C7,$A9,$C9,$C9,$E0
DATA_02F631:                      .db $A9,$69,$A9,$69,$29,$29,$29,$6B

ADDR_02F639:        A2 07         LDX.B #$07                
ADDR_02F63B:        A0 B0         LDY.B #$B0                
ADDR_02F63D:        A9 C0         LDA.B #$C0                
ADDR_02F63F:        18            CLC                       
ADDR_02F640:        7D 19 F6      ADC.W DATA_02F619,X       
ADDR_02F643:        99 00 03      STA.W OAM_DispX,Y         
ADDR_02F646:        A9 70         LDA.B #$70                
ADDR_02F648:        18            CLC                       
ADDR_02F649:        7D 21 F6      ADC.W DATA_02F621,X       
ADDR_02F64C:        99 01 03      STA.W OAM_DispY,Y         
ADDR_02F64F:        BD 29 F6      LDA.W DATA_02F629,X       
ADDR_02F652:        99 02 03      STA.W OAM_Tile,Y          
ADDR_02F655:        BD 31 F6      LDA.W DATA_02F631,X       
ADDR_02F658:        99 03 03      STA.W OAM_Prop,Y          
ADDR_02F65B:        5A            PHY                       
ADDR_02F65C:        98            TYA                       
ADDR_02F65D:        4A            LSR                       
ADDR_02F65E:        4A            LSR                       
ADDR_02F65F:        A8            TAY                       
ADDR_02F660:        A9 02         LDA.B #$02                
ADDR_02F662:        99 60 04      STA.W OAM_TileSize,Y      
ADDR_02F665:        7A            PLY                       
ADDR_02F666:        C8            INY                       
ADDR_02F667:        C8            INY                       
ADDR_02F668:        C8            INY                       
ADDR_02F669:        C8            INY                       
ADDR_02F66A:        CA            DEX                       
ADDR_02F66B:        10 D0         BPL ADDR_02F63D           
Return02F66D:       60            RTS                       ; Return 

CODE_02F66E:        AD D9 18      LDA.W $18D9               
CODE_02F671:        F0 03         BEQ CODE_02F676           
CODE_02F673:        CE D9 18      DEC.W $18D9               
CODE_02F676:        C9 B0         CMP.B #$B0                
CODE_02F678:        D0 05         BNE CODE_02F67F           
CODE_02F67A:        A0 0F         LDY.B #$0F                ; \ Play sound effect 
CODE_02F67C:        8C FC 1D      STY.W $1DFC               ; / 
CODE_02F67F:        C9 01         CMP.B #$01                
CODE_02F681:        D0 05         BNE CODE_02F688           
CODE_02F683:        A0 10         LDY.B #$10                ; \ Play sound effect 
CODE_02F685:        8C FC 1D      STY.W $1DFC               ; / 
CODE_02F688:        C9 30         CMP.B #$30                
CODE_02F68A:        90 0E         BCC CODE_02F69A           
CODE_02F68C:        C9 81         CMP.B #$81                
CODE_02F68E:        90 08         BCC CODE_02F698           
CODE_02F690:        18            CLC                       
CODE_02F691:        69 4F         ADC.B #$4F                
CODE_02F693:        49 FF         EOR.B #$FF                
CODE_02F695:        1A            INC A                     
CODE_02F696:        80 02         BRA CODE_02F69A           

CODE_02F698:        A9 30         LDA.B #$30                
CODE_02F69A:        85 00         STA $00                   
CODE_02F69C:        20 B8 F6      JSR.W CODE_02F6B8         
Return02F69F:       60            RTS                       ; Return 


DATA_02F6A0:                      .db $00,$10,$20,$00,$10,$20,$00,$10
                                  .db $20,$00,$10,$20

DATA_02F6AC:                      .db $00,$00,$00,$10,$10,$10,$20,$20
                                  .db $20,$30,$30,$30

CODE_02F6B8:        A2 0B         LDX.B #$0B                
CODE_02F6BA:        A0 B0         LDY.B #$B0                
CODE_02F6BC:        A9 B8         LDA.B #$B8                
CODE_02F6BE:        18            CLC                       
CODE_02F6BF:        7D A0 F6      ADC.W DATA_02F6A0,X       
CODE_02F6C2:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_02F6C5:        A9 50         LDA.B #$50                
CODE_02F6C7:        38            SEC                       
CODE_02F6C8:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02F6CA:        38            SEC                       
CODE_02F6CB:        E5 00         SBC $00                   
CODE_02F6CD:        18            CLC                       
CODE_02F6CE:        7D AC F6      ADC.W DATA_02F6AC,X       
CODE_02F6D1:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_02F6D4:        A9 A5         LDA.B #$A5                
CODE_02F6D6:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02F6D9:        A9 21         LDA.B #$21                
CODE_02F6DB:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02F6DE:        5A            PHY                       
CODE_02F6DF:        98            TYA                       
CODE_02F6E0:        4A            LSR                       
CODE_02F6E1:        4A            LSR                       
CODE_02F6E2:        A8            TAY                       
CODE_02F6E3:        A9 02         LDA.B #$02                
CODE_02F6E5:        99 20 04      STA.W $0420,Y             
CODE_02F6E8:        7A            PLY                       
CODE_02F6E9:        C8            INY                       
CODE_02F6EA:        C8            INY                       
CODE_02F6EB:        C8            INY                       
CODE_02F6EC:        C8            INY                       
CODE_02F6ED:        CA            DEX                       
CODE_02F6EE:        10 CC         BPL CODE_02F6BC           
Return02F6F0:       60            RTS                       ; Return 


DATA_02F6F1:                      .db $00,$00,$00,$00,$10,$10,$10,$10
                                  .db $00,$00,$00,$00,$10,$10,$10,$10
                                  .db $00,$00,$00,$00,$10,$10,$10,$10
                                  .db $F2,$F2,$F2,$F2,$1E,$1E,$1E,$1E
DATA_02F711:                      .db $00,$08,$18,$20,$00,$08,$18,$20
DATA_02F719:                      .db $7D,$7D,$FD,$FD,$3D,$3D,$BD,$BD
DATA_02F721:                      .db $A0,$B0,$B0,$A0,$A0,$B0,$B0,$A0
                                  .db $A3,$B3,$B3,$A3,$A3,$B3,$B3,$A3
                                  .db $A2,$B2,$B2,$A2,$A2,$B2,$B2,$A2
                                  .db $A3,$B3,$B3,$A3,$A3,$B3,$B3,$A3
DATA_02F741:                      .db $40,$44,$48,$4C,$F0,$F4,$F8,$FC
DATA_02F749:                      .db $00,$01,$02,$03,$03,$03,$03,$03
                                  .db $03,$03,$03,$03,$03,$02,$01,$00

CODE_02F759:        AD D9 18      LDA.W $18D9               
CODE_02F75C:        F0 03         BEQ CODE_02F761           
CODE_02F75E:        CE D9 18      DEC.W $18D9               
CODE_02F761:        C9 76         CMP.B #$76                
CODE_02F763:        D0 05         BNE CODE_02F76A           
CODE_02F765:        A0 0F         LDY.B #$0F                ; \ Play sound effect 
CODE_02F767:        8C FC 1D      STY.W $1DFC               ; / 
CODE_02F76A:        C9 08         CMP.B #$08                
CODE_02F76C:        D0 05         BNE CODE_02F773           
CODE_02F76E:        A0 10         LDY.B #$10                ; \ Play sound effect 
CODE_02F770:        8C FC 1D      STY.W $1DFC               ; / 
CODE_02F773:        4A            LSR                       
CODE_02F774:        4A            LSR                       
CODE_02F775:        4A            LSR                       
CODE_02F776:        A8            TAY                       
CODE_02F777:        B9 49 F7      LDA.W DATA_02F749,Y       
CODE_02F77A:        85 03         STA $03                   
CODE_02F77C:        A2 07         LDX.B #$07                
CODE_02F77E:        A9 B8         LDA.B #$B8                
CODE_02F780:        38            SEC                       
CODE_02F781:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02F783:        85 00         STA $00                   
CODE_02F785:        A9 60         LDA.B #$60                
CODE_02F787:        38            SEC                       
CODE_02F788:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02F78A:        85 01         STA $01                   
CODE_02F78C:        86 02         STX $02                   
CODE_02F78E:        BC 41 F7      LDY.W DATA_02F741,X       
CODE_02F791:        A5 03         LDA $03                   
CODE_02F793:        0A            ASL                       
CODE_02F794:        0A            ASL                       
CODE_02F795:        0A            ASL                       
CODE_02F796:        18            CLC                       
CODE_02F797:        65 02         ADC $02                   
CODE_02F799:        AA            TAX                       
CODE_02F79A:        98            TYA                       
CODE_02F79B:        30 33         BMI CODE_02F7D0           
CODE_02F79D:        A5 00         LDA $00                   
CODE_02F79F:        18            CLC                       
CODE_02F7A0:        7D F1 F6      ADC.W DATA_02F6F1,X       
CODE_02F7A3:        99 00 03      STA.W OAM_DispX,Y         
CODE_02F7A6:        BD 21 F7      LDA.W DATA_02F721,X       
CODE_02F7A9:        99 02 03      STA.W OAM_Tile,Y          
CODE_02F7AC:        A6 02         LDX $02                   
CODE_02F7AE:        A5 01         LDA $01                   
CODE_02F7B0:        18            CLC                       
CODE_02F7B1:        7D 11 F7      ADC.W DATA_02F711,X       
CODE_02F7B4:        99 01 03      STA.W OAM_DispY,Y         
CODE_02F7B7:        A5 03         LDA $03                   
CODE_02F7B9:        C9 03         CMP.B #$03                
CODE_02F7BB:        BD 19 F7      LDA.W DATA_02F719,X       
CODE_02F7BE:        90 02         BCC CODE_02F7C2           
CODE_02F7C0:        49 40         EOR.B #$40                
CODE_02F7C2:        99 03 03      STA.W OAM_Prop,Y          
CODE_02F7C5:        98            TYA                       
CODE_02F7C6:        4A            LSR                       
CODE_02F7C7:        4A            LSR                       
CODE_02F7C8:        A8            TAY                       
CODE_02F7C9:        A9 02         LDA.B #$02                
CODE_02F7CB:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02F7CE:        80 31         BRA CODE_02F801           

CODE_02F7D0:        A5 00         LDA $00                   
CODE_02F7D2:        18            CLC                       
CODE_02F7D3:        7D F1 F6      ADC.W DATA_02F6F1,X       
CODE_02F7D6:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_02F7D9:        BD 21 F7      LDA.W DATA_02F721,X       
CODE_02F7DC:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02F7DF:        A6 02         LDX $02                   
CODE_02F7E1:        A5 01         LDA $01                   
CODE_02F7E3:        18            CLC                       
CODE_02F7E4:        7D 11 F7      ADC.W DATA_02F711,X       
CODE_02F7E7:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_02F7EA:        A5 03         LDA $03                   
CODE_02F7EC:        C9 03         CMP.B #$03                
CODE_02F7EE:        BD 19 F7      LDA.W DATA_02F719,X       
CODE_02F7F1:        90 02         BCC CODE_02F7F5           
CODE_02F7F3:        49 40         EOR.B #$40                
CODE_02F7F5:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02F7F8:        98            TYA                       
CODE_02F7F9:        4A            LSR                       
CODE_02F7FA:        4A            LSR                       
CODE_02F7FB:        A8            TAY                       
CODE_02F7FC:        A9 02         LDA.B #$02                
CODE_02F7FE:        99 20 04      STA.W $0420,Y             
CODE_02F801:        CA            DEX                       
CODE_02F802:        30 03         BMI Return02F807          
CODE_02F804:        4C 8C F7      JMP.W CODE_02F78C         

Return02F807:       60            RTS                       ; Return 

CODE_02F808:        8B            PHB                       ; Wrapper 
CODE_02F809:        4B            PHK                       
CODE_02F80A:        AB            PLB                       
CODE_02F80B:        20 10 F8      JSR.W CODE_02F810         
CODE_02F80E:        AB            PLB                       
Return02F80F:       6B            RTL                       ; Return 

CODE_02F810:        A2 13         LDX.B #$13                
CODE_02F812:        8E E9 15      STX.W $15E9               
CODE_02F815:        BD 92 18      LDA.W $1892,X             
CODE_02F818:        F0 03         BEQ CODE_02F81D           
CODE_02F81A:        20 21 F8      JSR.W CODE_02F821         
CODE_02F81D:        CA            DEX                       
CODE_02F81E:        10 F2         BPL CODE_02F812           
Return02F820:       60            RTS                       ; Return 

CODE_02F821:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs02F825:            20 F8      .dw Return02F820          
                       BC FD      .dw CODE_02FDBC           
                       00 00      .dw $0000                 
                       C7 FB      .dw CODE_02FBC7           
                       98 FA      .dw CODE_02FA98           
                       16 FA      .dw CODE_02FA16           
                       1C F9      .dw CODE_02F91C           
                       3D F8      .dw CODE_02F83D           
                       C7 FB      .dw CODE_02FBC7           

DATA_02F837:                      .db $01,$FF

DATA_02F839:                      .db $00,$FF,$02,$0E

CODE_02F83D:        AD 0A 19      LDA.W $190A               
CODE_02F840:        8D 5E 18      STA.W $185E               
CODE_02F843:        9B            TXY                       
CODE_02F844:        D0 0F         BNE CODE_02F855           
CODE_02F846:        CE 0A 19      DEC.W $190A               
CODE_02F849:        C9 00         CMP.B #$00                
CODE_02F84B:        D0 08         BNE CODE_02F855           
CODE_02F84D:        EE BA 18      INC.W $18BA               
CODE_02F850:        A0 FF         LDY.B #$FF                
CODE_02F852:        8C 0A 19      STY.W $190A               
CODE_02F855:        C9 00         CMP.B #$00                
CODE_02F857:        D0 45         BNE CODE_02F89E           
CODE_02F859:        AD BF 18      LDA.W $18BF               
CODE_02F85C:        F0 07         BEQ CODE_02F865           
CODE_02F85E:        9E 92 18      STZ.W $1892,X             
CODE_02F861:        9C BA 18      STZ.W $18BA               
Return02F864:       60            RTS                       ; Return 

CODE_02F865:        BD 66 1E      LDA.W $1E66,X             
CODE_02F868:        85 00         STA $00                   
CODE_02F86A:        BD 52 1E      LDA.W $1E52,X             
CODE_02F86D:        85 01         STA $01                   
CODE_02F86F:        AD BA 18      LDA.W $18BA               
CODE_02F872:        29 01         AND.B #$01                
CODE_02F874:        D0 0A         BNE CODE_02F880           
CODE_02F876:        BD 8E 1E      LDA.W $1E8E,X             
CODE_02F879:        85 00         STA $00                   
CODE_02F87B:        BD 7A 1E      LDA.W $1E7A,X             
CODE_02F87E:        85 01         STA $01                   
CODE_02F880:        A5 00         LDA $00                   
CODE_02F882:        18            CLC                       
CODE_02F883:        65 1A         ADC RAM_ScreenBndryXLo    
CODE_02F885:        9D 16 1E      STA.W $1E16,X             
CODE_02F888:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02F88A:        69 00         ADC.B #$00                
CODE_02F88C:        9D 3E 1E      STA.W $1E3E,X             
CODE_02F88F:        A5 01         LDA $01                   
CODE_02F891:        18            CLC                       
CODE_02F892:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_02F894:        9D 02 1E      STA.W $1E02,X             
CODE_02F897:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02F899:        69 00         ADC.B #$00                
CODE_02F89B:        9D 2A 1E      STA.W $1E2A,X             
CODE_02F89E:        8A            TXA                       
CODE_02F89F:        0A            ASL                       
CODE_02F8A0:        0A            ASL                       
CODE_02F8A1:        65 14         ADC RAM_FrameCounterB     
CODE_02F8A3:        85 00         STA $00                   
CODE_02F8A5:        29 07         AND.B #$07                
CODE_02F8A7:        05 9D         ORA RAM_SpritesLocked     
CODE_02F8A9:        D0 1D         BNE CODE_02F8C8           
CODE_02F8AB:        A5 00         LDA $00                   
CODE_02F8AD:        29 20         AND.B #$20                
CODE_02F8AF:        4A            LSR                       
CODE_02F8B0:        4A            LSR                       
CODE_02F8B1:        4A            LSR                       
CODE_02F8B2:        4A            LSR                       
CODE_02F8B3:        4A            LSR                       
CODE_02F8B4:        A8            TAY                       
CODE_02F8B5:        BD 02 1E      LDA.W $1E02,X             
CODE_02F8B8:        18            CLC                       
CODE_02F8B9:        79 37 F8      ADC.W DATA_02F837,Y       
CODE_02F8BC:        9D 02 1E      STA.W $1E02,X             
CODE_02F8BF:        BD 2A 1E      LDA.W $1E2A,X             
CODE_02F8C2:        79 39 F8      ADC.W DATA_02F839,Y       
CODE_02F8C5:        9D 2A 1E      STA.W $1E2A,X             
CODE_02F8C8:        AC 5E 18      LDY.W $185E               
CODE_02F8CB:        C0 20         CPY.B #$20                
CODE_02F8CD:        90 2C         BCC Return02F8FB          
CODE_02F8CF:        C0 40         CPY.B #$40                
CODE_02F8D1:        B0 05         BCS CODE_02F8D8           
CODE_02F8D3:        98            TYA                       
CODE_02F8D4:        E9 1F         SBC.B #$1F                
CODE_02F8D6:        80 0A         BRA CODE_02F8E2           

CODE_02F8D8:        C0 E0         CPY.B #$E0                
CODE_02F8DA:        90 0A         BCC CODE_02F8E6           
CODE_02F8DC:        98            TYA                       
CODE_02F8DD:        E9 E0         SBC.B #$E0                
CODE_02F8DF:        49 1F         EOR.B #$1F                
CODE_02F8E1:        1A            INC A                     
CODE_02F8E2:        4A            LSR                       
CODE_02F8E3:        4A            LSR                       
CODE_02F8E4:        80 05         BRA CODE_02F8EB           

CODE_02F8E6:        20 B0 FB      JSR.W CODE_02FBB0         
CODE_02F8E9:        A9 08         LDA.B #$08                
CODE_02F8EB:        8D 0B 19      STA.W $190B               
CODE_02F8EE:        E0 00         CPX.B #$00                
CODE_02F8F0:        D0 04         BNE CODE_02F8F6           
CODE_02F8F2:        22 39 82 03   JSL.L CODE_038239         
CODE_02F8F6:        A9 0F         LDA.B #$0F                
CODE_02F8F8:        20 48 FD      JSR.W CODE_02FD48         
Return02F8FB:       60            RTS                       ; Return 


DATA_02F8FC:                      .db $00,$10,$00,$10,$08,$10,$FF,$10
SumoBroFlameTiles:                .db $DC,$EC,$CC,$EC,$CC,$DC,$00,$CC
DATA_02F90C:                      .db $03,$03,$03,$03,$02,$01,$00,$00
                                  .db $00,$00,$00,$00,$01,$02,$03,$03

CODE_02F91C:        BD 4A 0F      LDA.W $0F4A,X             
CODE_02F91F:        F0 1B         BEQ CODE_02F93C           
CODE_02F921:        A4 9D         LDY RAM_SpritesLocked     
CODE_02F923:        D0 03         BNE CODE_02F928           
CODE_02F925:        DE 4A 0F      DEC.W $0F4A,X             
CODE_02F928:        4A            LSR                       
CODE_02F929:        4A            LSR                       
CODE_02F92A:        4A            LSR                       
CODE_02F92B:        A8            TAY                       
CODE_02F92C:        B9 0C F9      LDA.W DATA_02F90C,Y       
CODE_02F92F:        0A            ASL                       
CODE_02F930:        8D 5E 18      STA.W $185E               
CODE_02F933:        20 AE F9      JSR.W CODE_02F9AE         
CODE_02F936:        DA            PHX                       
CODE_02F937:        20 40 F9      JSR.W CODE_02F940         
CODE_02F93A:        FA            PLX                       
Return02F93B:       60            RTS                       ; Return 

CODE_02F93C:        9E 92 18      STZ.W $1892,X             
Return02F93F:       60            RTS                       ; Return 

CODE_02F940:        8A            TXA                       
CODE_02F941:        0A            ASL                       
CODE_02F942:        A8            TAY                       
CODE_02F943:        B9 50 FF      LDA.W DATA_02FF50,Y       
CODE_02F946:        8D EA 15      STA.W RAM_SprOAMIndex     
CODE_02F949:        BD 16 1E      LDA.W $1E16,X             
CODE_02F94C:        85 E4         STA RAM_SpriteXLo         
CODE_02F94E:        BD 3E 1E      LDA.W $1E3E,X             
CODE_02F951:        8D E0 14      STA.W RAM_SpriteXHi       
CODE_02F954:        BD 02 1E      LDA.W $1E02,X             
CODE_02F957:        85 D8         STA RAM_SpriteYLo         
CODE_02F959:        BD 2A 1E      LDA.W $1E2A,X             
CODE_02F95C:        8D D4 14      STA.W RAM_SpriteYHi       
CODE_02F95F:        A8            TAY                       
CODE_02F960:        A2 00         LDX.B #$00                
CODE_02F962:        20 78 D3      JSR.W GetDrawInfo2        
CODE_02F965:        A2 01         LDX.B #$01                
CODE_02F967:        DA            PHX                       
CODE_02F968:        A5 00         LDA $00                   
CODE_02F96A:        99 00 03      STA.W OAM_DispX,Y         
CODE_02F96D:        8A            TXA                       
CODE_02F96E:        0D 5E 18      ORA.W $185E               
CODE_02F971:        AA            TAX                       
CODE_02F972:        BD FC F8      LDA.W DATA_02F8FC,X       
CODE_02F975:        30 1C         BMI CODE_02F993           
CODE_02F977:        18            CLC                       
CODE_02F978:        65 01         ADC $01                   
CODE_02F97A:        99 01 03      STA.W OAM_DispY,Y         
CODE_02F97D:        BD 04 F9      LDA.W SumoBroFlameTiles,X 
CODE_02F980:        99 02 03      STA.W OAM_Tile,Y          
CODE_02F983:        A5 14         LDA RAM_FrameCounterB     
CODE_02F985:        29 04         AND.B #$04                
CODE_02F987:        0A            ASL                       
CODE_02F988:        0A            ASL                       
CODE_02F989:        0A            ASL                       
CODE_02F98A:        0A            ASL                       
CODE_02F98B:        EA            NOP                       
CODE_02F98C:        05 64         ORA $64                   
CODE_02F98E:        09 05         ORA.B #$05                
CODE_02F990:        99 03 03      STA.W OAM_Prop,Y          
CODE_02F993:        FA            PLX                       
CODE_02F994:        C8            INY                       
CODE_02F995:        C8            INY                       
CODE_02F996:        C8            INY                       
CODE_02F997:        C8            INY                       
CODE_02F998:        CA            DEX                       
CODE_02F999:        10 CC         BPL CODE_02F967           
CODE_02F99B:        A2 00         LDX.B #$00                
CODE_02F99D:        A0 02         LDY.B #$02                
CODE_02F99F:        A9 01         LDA.B #$01                
CODE_02F9A1:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return02F9A5:       60            RTS                       ; Return 

ADDR_02F9A6:        9E 92 18      STZ.W $1892,X             
Return02F9A9:       60            RTS                       ; Return 


DATA_02F9AA:                      .db $02,$0A,$12,$1A

CODE_02F9AE:        8A            TXA                       
CODE_02F9AF:        45 13         EOR RAM_FrameCounter      
CODE_02F9B1:        29 03         AND.B #$03                
CODE_02F9B3:        D0 49         BNE Return02F9FE          
CODE_02F9B5:        BD 4A 0F      LDA.W $0F4A,X             
CODE_02F9B8:        C9 10         CMP.B #$10                
CODE_02F9BA:        90 42         BCC Return02F9FE          
CODE_02F9BC:        BD 16 1E      LDA.W $1E16,X             
CODE_02F9BF:        18            CLC                       
CODE_02F9C0:        69 02         ADC.B #$02                
CODE_02F9C2:        85 04         STA $04                   
CODE_02F9C4:        BD 3E 1E      LDA.W $1E3E,X             
CODE_02F9C7:        69 00         ADC.B #$00                
CODE_02F9C9:        85 0A         STA $0A                   
CODE_02F9CB:        A9 0C         LDA.B #$0C                
CODE_02F9CD:        85 06         STA $06                   
CODE_02F9CF:        AC 5E 18      LDY.W $185E               
CODE_02F9D2:        BD 02 1E      LDA.W $1E02,X             
CODE_02F9D5:        18            CLC                       
CODE_02F9D6:        79 AA F9      ADC.W DATA_02F9AA,Y       
CODE_02F9D9:        85 05         STA $05                   
CODE_02F9DB:        A9 14         LDA.B #$14                
CODE_02F9DD:        85 07         STA $07                   
CODE_02F9DF:        BD 2A 1E      LDA.W $1E2A,X             
CODE_02F9E2:        69 00         ADC.B #$00                
CODE_02F9E4:        85 0B         STA $0B                   
CODE_02F9E6:        22 64 B6 03   JSL.L GetMarioClipping    
CODE_02F9EA:        22 2B B7 03   JSL.L CheckForContact     
CODE_02F9EE:        90 0E         BCC Return02F9FE          
CODE_02F9F0:        AD 90 14      LDA.W $1490               ; \ Branch if Mario has star 
CODE_02F9F3:        D0 B1         BNE ADDR_02F9A6           ; / 
CODE_02F9F5:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_02F9F8:        D0 05         BNE CODE_02F9FF           
CODE_02F9FA:        22 B7 F5 00   JSL.L HurtMario           
Return02F9FE:       60            RTS                       ; Return 

CODE_02F9FF:        4C 73 A4      JMP.W CODE_02A473         


DATA_02FA02:                      .db $03,$07,$07,$07,$0F,$07,$07,$0F
DATA_02FA0A:                      .db $F0,$F4,$F8,$FC

CastleFlameTiles:                 .db $E2,$E4,$E2,$E4

CastleFlameGfxProp:               .db $09,$09,$49,$49

CODE_02FA16:        A5 9D         LDA RAM_SpritesLocked     
CODE_02FA18:        D0 11         BNE CODE_02FA2B           
CODE_02FA1A:        22 F9 AC 01   JSL.L GetRand             
CODE_02FA1E:        29 07         AND.B #$07                
CODE_02FA20:        A8            TAY                       
CODE_02FA21:        A5 13         LDA RAM_FrameCounter      
CODE_02FA23:        39 02 FA      AND.W DATA_02FA02,Y       
CODE_02FA26:        D0 03         BNE CODE_02FA2B           
CODE_02FA28:        FE 4A 0F      INC.W $0F4A,X             
CODE_02FA2B:        BC 0A FA      LDY.W DATA_02FA0A,X       
CODE_02FA2E:        BD 16 1E      LDA.W $1E16,X             
CODE_02FA31:        38            SEC                       
CODE_02FA32:        E5 1E         SBC $1E                   
CODE_02FA34:        99 00 03      STA.W OAM_DispX,Y         
CODE_02FA37:        BD 02 1E      LDA.W $1E02,X             
CODE_02FA3A:        38            SEC                       
CODE_02FA3B:        E5 20         SBC $20                   
CODE_02FA3D:        99 01 03      STA.W OAM_DispY,Y         
CODE_02FA40:        5A            PHY                       
CODE_02FA41:        DA            PHX                       
CODE_02FA42:        BD 4A 0F      LDA.W $0F4A,X             
CODE_02FA45:        29 03         AND.B #$03                
CODE_02FA47:        AA            TAX                       
CODE_02FA48:        BD 0E FA      LDA.W CastleFlameTiles,X  
CODE_02FA4B:        99 02 03      STA.W OAM_Tile,Y          
CODE_02FA4E:        BD 12 FA      LDA.W CastleFlameGfxProp,X 
CODE_02FA51:        99 03 03      STA.W OAM_Prop,Y          
CODE_02FA54:        FA            PLX                       
CODE_02FA55:        98            TYA                       
CODE_02FA56:        4A            LSR                       
CODE_02FA57:        4A            LSR                       
CODE_02FA58:        A8            TAY                       
CODE_02FA59:        A9 02         LDA.B #$02                
CODE_02FA5B:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02FA5E:        7A            PLY                       
CODE_02FA5F:        B9 00 03      LDA.W OAM_DispX,Y         
CODE_02FA62:        C9 F0         CMP.B #$F0                
CODE_02FA64:        90 1D         BCC Return02FA83          
CODE_02FA66:        B9 00 03      LDA.W OAM_DispX,Y         
CODE_02FA69:        8D EC 03      STA.W $03EC               
CODE_02FA6C:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_02FA6F:        8D ED 03      STA.W $03ED               
CODE_02FA72:        B9 02 03      LDA.W OAM_Tile,Y          
CODE_02FA75:        8D EE 03      STA.W $03EE               
CODE_02FA78:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_02FA7B:        8D EF 03      STA.W $03EF               
CODE_02FA7E:        A9 03         LDA.B #$03                
CODE_02FA80:        8D 9B 04      STA.W $049B               
Return02FA83:       60            RTS                       ; Return 


DATA_02FA84:                      .db $00

DATA_02FA85:                      .db $00,$28,$00,$50,$00,$78,$00,$A0
                                  .db $00,$C8,$00,$F0,$00,$18,$01,$40
                                  .db $01,$68,$01

CODE_02FA98:        BC 86 0F      LDY.W $0F86,X             
CODE_02FA9B:        B9 BA 0F      LDA.W $0FBA,Y             
CODE_02FA9E:        F0 04         BEQ CODE_02FAA4           
CODE_02FAA0:        9E 92 18      STZ.W $1892,X             
Return02FAA3:       60            RTS                       ; Return 

CODE_02FAA4:        A5 9D         LDA RAM_SpritesLocked     
CODE_02FAA6:        D0 48         BNE CODE_02FAF0           
CODE_02FAA8:        BD 4A 0F      LDA.W $0F4A,X             
CODE_02FAAB:        F0 43         BEQ CODE_02FAF0           
CODE_02FAAD:        64 00         STZ $00                   
CODE_02FAAF:        10 02         BPL CODE_02FAB3           
CODE_02FAB1:        C6 00         DEC $00                   
CODE_02FAB3:        18            CLC                       
CODE_02FAB4:        79 AE 0F      ADC.W $0FAE,Y             
CODE_02FAB7:        99 AE 0F      STA.W $0FAE,Y             
CODE_02FABA:        B9 B0 0F      LDA.W $0FB0,Y             
CODE_02FABD:        65 00         ADC $00                   
CODE_02FABF:        29 01         AND.B #$01                
CODE_02FAC1:        99 B0 0F      STA.W $0FB0,Y             
CODE_02FAC4:        B9 B2 0F      LDA.W $0FB2,Y             
CODE_02FAC7:        85 00         STA $00                   
CODE_02FAC9:        B9 B4 0F      LDA.W $0FB4,Y             
CODE_02FACC:        85 01         STA $01                   
CODE_02FACE:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_02FAD0:        A5 00         LDA $00                   
CODE_02FAD2:        38            SEC                       
CODE_02FAD3:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02FAD5:        18            CLC                       
CODE_02FAD6:        69 80 00      ADC.W #$0080              
CODE_02FAD9:        C9 00 02      CMP.W #$0200              
CODE_02FADC:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_02FADE:        90 10         BCC CODE_02FAF0           
CODE_02FAE0:        A9 01         LDA.B #$01                
CODE_02FAE2:        99 BA 0F      STA.W $0FBA,Y             
CODE_02FAE5:        DA            PHX                       
CODE_02FAE6:        BE BC 0F      LDX.W $0FBC,Y             
CODE_02FAE9:        9E 38 19      STZ.W RAM_SprLoadStatus,X ; Allow sprite to be reloaded by level loading routine 
CODE_02FAEC:        FA            PLX                       
CODE_02FAED:        CE BA 18      DEC.W $18BA               
CODE_02FAF0:        DA            PHX                       
CODE_02FAF1:        BD 72 0F      LDA.W $0F72,X             
CODE_02FAF4:        0A            ASL                       
CODE_02FAF5:        AA            TAX                       
CODE_02FAF6:        BD 84 FA      LDA.W DATA_02FA84,X       
CODE_02FAF9:        18            CLC                       
CODE_02FAFA:        79 AE 0F      ADC.W $0FAE,Y             
CODE_02FAFD:        85 00         STA $00                   
CODE_02FAFF:        BD 85 FA      LDA.W DATA_02FA85,X       
CODE_02FB02:        79 B0 0F      ADC.W $0FB0,Y             
CODE_02FB05:        29 01         AND.B #$01                
CODE_02FB07:        85 01         STA $01                   
CODE_02FB09:        FA            PLX                       
CODE_02FB0A:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_02FB0C:        A5 00         LDA $00                   
CODE_02FB0E:        18            CLC                       
CODE_02FB0F:        69 80 00      ADC.W #$0080              
CODE_02FB12:        29 FF 01      AND.W #$01FF              
CODE_02FB15:        85 02         STA $02                   
CODE_02FB17:        A5 00         LDA $00                   
CODE_02FB19:        29 FF 00      AND.W #$00FF              
CODE_02FB1C:        0A            ASL                       
CODE_02FB1D:        AA            TAX                       
CODE_02FB1E:        BF DB F7 07   LDA.L CircleCoords,X      
CODE_02FB22:        85 04         STA $04                   
CODE_02FB24:        A5 02         LDA $02                   
CODE_02FB26:        29 FF 00      AND.W #$00FF              
CODE_02FB29:        0A            ASL                       
CODE_02FB2A:        AA            TAX                       
CODE_02FB2B:        BF DB F7 07   LDA.L CircleCoords,X      
CODE_02FB2F:        85 06         STA $06                   
CODE_02FB31:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_02FB33:        A5 04         LDA $04                   
CODE_02FB35:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_02FB38:        A9 50         LDA.B #$50                
CODE_02FB3A:        A4 05         LDY $05                   
CODE_02FB3C:        D0 0F         BNE CODE_02FB4D           
CODE_02FB3E:        8D 03 42      STA.W $4203               ; Multplier B
CODE_02FB41:        EA            NOP                       
CODE_02FB42:        EA            NOP                       
CODE_02FB43:        EA            NOP                       
CODE_02FB44:        EA            NOP                       
CODE_02FB45:        0E 16 42      ASL.W $4216               ; Product/Remainder Result (Low Byte)
CODE_02FB48:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_02FB4B:        69 00         ADC.B #$00                
CODE_02FB4D:        46 01         LSR $01                   
CODE_02FB4F:        90 03         BCC CODE_02FB54           
CODE_02FB51:        49 FF         EOR.B #$FF                
CODE_02FB53:        1A            INC A                     
CODE_02FB54:        85 04         STA $04                   
CODE_02FB56:        A5 06         LDA $06                   
CODE_02FB58:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_02FB5B:        A9 50         LDA.B #$50                
CODE_02FB5D:        A4 07         LDY $07                   
CODE_02FB5F:        D0 0F         BNE CODE_02FB70           
CODE_02FB61:        8D 03 42      STA.W $4203               ; Multplier B
CODE_02FB64:        EA            NOP                       
CODE_02FB65:        EA            NOP                       
CODE_02FB66:        EA            NOP                       
CODE_02FB67:        EA            NOP                       
CODE_02FB68:        0E 16 42      ASL.W $4216               ; Product/Remainder Result (Low Byte)
CODE_02FB6B:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_02FB6E:        69 00         ADC.B #$00                
CODE_02FB70:        46 03         LSR $03                   
CODE_02FB72:        90 03         BCC CODE_02FB77           
CODE_02FB74:        49 FF         EOR.B #$FF                
CODE_02FB76:        1A            INC A                     
CODE_02FB77:        85 06         STA $06                   
CODE_02FB79:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02FB7C:        BC 86 0F      LDY.W $0F86,X             
CODE_02FB7F:        64 00         STZ $00                   
CODE_02FB81:        A5 04         LDA $04                   
CODE_02FB83:        10 02         BPL CODE_02FB87           
CODE_02FB85:        C6 00         DEC $00                   
CODE_02FB87:        18            CLC                       
CODE_02FB88:        79 B2 0F      ADC.W $0FB2,Y             
CODE_02FB8B:        9D 16 1E      STA.W $1E16,X             
CODE_02FB8E:        B9 B4 0F      LDA.W $0FB4,Y             
CODE_02FB91:        65 00         ADC $00                   
CODE_02FB93:        9D 3E 1E      STA.W $1E3E,X             
CODE_02FB96:        64 01         STZ $01                   
CODE_02FB98:        A5 06         LDA $06                   
CODE_02FB9A:        10 02         BPL CODE_02FB9E           
CODE_02FB9C:        C6 01         DEC $01                   
CODE_02FB9E:        18            CLC                       
CODE_02FB9F:        79 B6 0F      ADC.W $0FB6,Y             
CODE_02FBA2:        9D 02 1E      STA.W $1E02,X             
CODE_02FBA5:        B9 B8 0F      LDA.W $0FB8,Y             
CODE_02FBA8:        65 01         ADC $01                   
CODE_02FBAA:        9D 2A 1E      STA.W $1E2A,X             
CODE_02FBAD:        20 8D FC      JSR.W CODE_02FC8D         
CODE_02FBB0:        8A            TXA                       
CODE_02FBB1:        45 13         EOR RAM_FrameCounter      
CODE_02FBB3:        29 03         AND.B #$03                
CODE_02FBB5:        D0 03         BNE Return02FBBA          
CODE_02FBB7:        20 71 FE      JSR.W CODE_02FE71         
Return02FBBA:       60            RTS                       ; Return 


DATA_02FBBB:                      .db $01,$FF

DATA_02FBBD:                      .db $08,$F8

BooRingTiles:                     .db $88,$8C,$A8,$8E,$AA,$AE,$88,$8C

CODE_02FBC7:        E0 00         CPX.B #$00                
CODE_02FBC9:        F0 03         BEQ CODE_02FBCE           
CODE_02FBCB:        4C 41 FC      JMP.W CODE_02FC41         

CODE_02FBCE:        A5 13         LDA RAM_FrameCounter      
CODE_02FBD0:        29 07         AND.B #$07                
CODE_02FBD2:        05 9D         ORA RAM_SpritesLocked     
CODE_02FBD4:        D0 68         BNE CODE_02FC3E           
CODE_02FBD6:        22 F9 AC 01   JSL.L GetRand             
CODE_02FBDA:        29 1F         AND.B #$1F                
CODE_02FBDC:        C9 14         CMP.B #$14                
CODE_02FBDE:        90 02         BCC CODE_02FBE2           
CODE_02FBE0:        E9 14         SBC.B #$14                
CODE_02FBE2:        AA            TAX                       
CODE_02FBE3:        BD 86 0F      LDA.W $0F86,X             
CODE_02FBE6:        D0 56         BNE CODE_02FC3E           
CODE_02FBE8:        FE 86 0F      INC.W $0F86,X             
CODE_02FBEB:        A9 20         LDA.B #$20                
CODE_02FBED:        9D 9A 0F      STA.W $0F9A,X             
CODE_02FBF0:        64 00         STZ $00                   
CODE_02FBF2:        BD 16 1E      LDA.W $1E16,X             
CODE_02FBF5:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02FBF7:        65 1A         ADC RAM_ScreenBndryXLo    
CODE_02FBF9:        08            PHP                       
CODE_02FBFA:        65 00         ADC $00                   
CODE_02FBFC:        9D 16 1E      STA.W $1E16,X             
CODE_02FBFF:        85 E4         STA RAM_SpriteXLo         
CODE_02FC01:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_02FC03:        69 00         ADC.B #$00                
CODE_02FC05:        28            PLP                       
CODE_02FC06:        69 00         ADC.B #$00                
CODE_02FC08:        9D 3E 1E      STA.W $1E3E,X             
CODE_02FC0B:        8D E0 14      STA.W RAM_SpriteXHi       
CODE_02FC0E:        BD 02 1E      LDA.W $1E02,X             
CODE_02FC11:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02FC13:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_02FC15:        9D 02 1E      STA.W $1E02,X             
CODE_02FC18:        85 D8         STA RAM_SpriteYLo         
CODE_02FC1A:        29 FC         AND.B #$FC                
CODE_02FC1C:        9D 72 0F      STA.W $0F72,X             
CODE_02FC1F:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_02FC21:        69 00         ADC.B #$00                
CODE_02FC23:        9D 2A 1E      STA.W $1E2A,X             
CODE_02FC26:        8D D4 14      STA.W RAM_SpriteYHi       
CODE_02FC29:        DA            PHX                       
CODE_02FC2A:        A2 00         LDX.B #$00                
CODE_02FC2C:        A9 10         LDA.B #$10                
CODE_02FC2E:        20 FB D2      JSR.W CODE_02D2FB         
CODE_02FC31:        FA            PLX                       
CODE_02FC32:        A5 00         LDA $00                   
CODE_02FC34:        69 09         ADC.B #$09                
CODE_02FC36:        9D 52 1E      STA.W $1E52,X             
CODE_02FC39:        A5 01         LDA $01                   
CODE_02FC3B:        9D 66 1E      STA.W $1E66,X             
CODE_02FC3E:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_02FC41:        A5 9D         LDA RAM_SpritesLocked     
CODE_02FC43:        D0 08         BNE CODE_02FC4D           
CODE_02FC45:        BD 9A 0F      LDA.W $0F9A,X             
CODE_02FC48:        F0 03         BEQ CODE_02FC4D           
CODE_02FC4A:        DE 9A 0F      DEC.W $0F9A,X             
CODE_02FC4D:        BD 86 0F      LDA.W $0F86,X             
CODE_02FC50:        D0 03         BNE CODE_02FC55           
CODE_02FC52:        4C E2 FC      JMP.W CODE_02FCE2         

CODE_02FC55:        A5 9D         LDA RAM_SpritesLocked     
CODE_02FC57:        D0 34         BNE CODE_02FC8D           
CODE_02FC59:        BD 9A 0F      LDA.W $0F9A,X             
CODE_02FC5C:        D0 1A         BNE CODE_02FC78           
CODE_02FC5E:        20 98 FF      JSR.W CODE_02FF98         
CODE_02FC61:        20 A3 FF      JSR.W CODE_02FFA3         
CODE_02FC64:        8A            TXA                       
CODE_02FC65:        45 13         EOR RAM_FrameCounter      
CODE_02FC67:        29 03         AND.B #$03                
CODE_02FC69:        D0 0D         BNE CODE_02FC78           
CODE_02FC6B:        20 71 FE      JSR.W CODE_02FE71         
CODE_02FC6E:        BD 52 1E      LDA.W $1E52,X             
CODE_02FC71:        C9 E1         CMP.B #$E1                
CODE_02FC73:        30 03         BMI CODE_02FC78           
CODE_02FC75:        DE 52 1E      DEC.W $1E52,X             
CODE_02FC78:        BD 02 1E      LDA.W $1E02,X             
CODE_02FC7B:        29 FC         AND.B #$FC                
CODE_02FC7D:        DD 72 0F      CMP.W $0F72,X             
CODE_02FC80:        D0 0B         BNE CODE_02FC8D           
CODE_02FC82:        BD 52 1E      LDA.W $1E52,X             
CODE_02FC85:        10 06         BPL CODE_02FC8D           
CODE_02FC87:        9E 86 0F      STZ.W $0F86,X             
CODE_02FC8A:        9E 66 1E      STZ.W $1E66,X             
CODE_02FC8D:        BD 16 1E      LDA.W $1E16,X             
CODE_02FC90:        85 00         STA $00                   
CODE_02FC92:        BD 3E 1E      LDA.W $1E3E,X             
CODE_02FC95:        85 01         STA $01                   
CODE_02FC97:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_02FC99:        A5 00         LDA $00                   
CODE_02FC9B:        38            SEC                       
CODE_02FC9C:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02FC9E:        18            CLC                       
CODE_02FC9F:        69 40 00      ADC.W #$0040              
CODE_02FCA2:        C9 80 01      CMP.W #$0180              
CODE_02FCA5:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_02FCA7:        B0 2F         BCS Return02FCD8          
CODE_02FCA9:        A9 02         LDA.B #$02                
CODE_02FCAB:        20 48 FD      JSR.W CODE_02FD48         
CODE_02FCAE:        BD 02 1E      LDA.W $1E02,X             
CODE_02FCB1:        18            CLC                       
CODE_02FCB2:        69 10         ADC.B #$10                
CODE_02FCB4:        08            PHP                       
CODE_02FCB5:        C5 1C         CMP RAM_ScreenBndryYLo    
CODE_02FCB7:        BD 2A 1E      LDA.W $1E2A,X             
CODE_02FCBA:        E5 1D         SBC RAM_ScreenBndryYHi    
CODE_02FCBC:        28            PLP                       
CODE_02FCBD:        69 00         ADC.B #$00                
CODE_02FCBF:        D0 18         BNE CODE_02FCD9           
CODE_02FCC1:        BD 16 1E      LDA.W $1E16,X             
CODE_02FCC4:        C5 1A         CMP RAM_ScreenBndryXLo    
CODE_02FCC6:        BD 3E 1E      LDA.W $1E3E,X             
CODE_02FCC9:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_02FCCB:        F0 0B         BEQ Return02FCD8          
CODE_02FCCD:        BD 50 FF      LDA.W DATA_02FF50,X       
CODE_02FCD0:        4A            LSR                       
CODE_02FCD1:        4A            LSR                       
CODE_02FCD2:        A8            TAY                       
CODE_02FCD3:        A9 03         LDA.B #$03                
CODE_02FCD5:        99 60 04      STA.W OAM_TileSize,Y      
Return02FCD8:       60            RTS                       ; Return 

CODE_02FCD9:        BC 50 FF      LDY.W DATA_02FF50,X       
CODE_02FCDC:        A9 F0         LDA.B #$F0                
CODE_02FCDE:        99 01 03      STA.W OAM_DispY,Y         
Return02FCE1:       60            RTS                       ; Return 

CODE_02FCE2:        A5 9D         LDA RAM_SpritesLocked     
CODE_02FCE4:        D0 60         BNE CODE_02FD46           
CODE_02FCE6:        BD 92 18      LDA.W $1892,X             
CODE_02FCE9:        C9 08         CMP.B #$08                
CODE_02FCEB:        F0 59         BEQ CODE_02FD46           
CODE_02FCED:        BD 9A 0F      LDA.W $0F9A,X             
CODE_02FCF0:        D0 28         BNE CODE_02FD1A           
CODE_02FCF2:        A5 13         LDA RAM_FrameCounter      
CODE_02FCF4:        29 01         AND.B #$01                
CODE_02FCF6:        D0 22         BNE CODE_02FD1A           
CODE_02FCF8:        BD 4A 0F      LDA.W $0F4A,X             
CODE_02FCFB:        29 01         AND.B #$01                
CODE_02FCFD:        A8            TAY                       
CODE_02FCFE:        BD 66 1E      LDA.W $1E66,X             
CODE_02FD01:        18            CLC                       
CODE_02FD02:        79 BB FB      ADC.W DATA_02FBBB,Y       
CODE_02FD05:        9D 66 1E      STA.W $1E66,X             
CODE_02FD08:        D9 BD FB      CMP.W DATA_02FBBD,Y       
CODE_02FD0B:        D0 0D         BNE CODE_02FD1A           
CODE_02FD0D:        FE 4A 0F      INC.W $0F4A,X             
CODE_02FD10:        AD 8D 14      LDA.W RAM_RandomByte1     
CODE_02FD13:        29 FF         AND.B #$FF                
CODE_02FD15:        09 3F         ORA.B #$3F                
CODE_02FD17:        9D 9A 0F      STA.W $0F9A,X             
CODE_02FD1A:        20 98 FF      JSR.W CODE_02FF98         
CODE_02FD1D:        8A            TXA                       
CODE_02FD1E:        45 13         EOR RAM_FrameCounter      
CODE_02FD20:        29 03         AND.B #$03                
CODE_02FD22:        D0 22         BNE CODE_02FD46           
CODE_02FD24:        64 00         STZ $00                   
CODE_02FD26:        A0 01         LDY.B #$01                
CODE_02FD28:        8A            TXA                       
CODE_02FD29:        0A            ASL                       
CODE_02FD2A:        0A            ASL                       
CODE_02FD2B:        0A            ASL                       
CODE_02FD2C:        65 13         ADC RAM_FrameCounter      
CODE_02FD2E:        29 40         AND.B #$40                
CODE_02FD30:        F0 04         BEQ CODE_02FD36           
CODE_02FD32:        A0 FF         LDY.B #$FF                
CODE_02FD34:        C6 00         DEC $00                   
CODE_02FD36:        98            TYA                       
CODE_02FD37:        18            CLC                       
CODE_02FD38:        7D 02 1E      ADC.W $1E02,X             
CODE_02FD3B:        9D 02 1E      STA.W $1E02,X             
CODE_02FD3E:        A5 00         LDA $00                   
CODE_02FD40:        7D 2A 1E      ADC.W $1E2A,X             
CODE_02FD43:        9D 2A 1E      STA.W $1E2A,X             
CODE_02FD46:        A9 0E         LDA.B #$0E                
CODE_02FD48:        85 02         STA $02                   
CODE_02FD4A:        BC 50 FF      LDY.W DATA_02FF50,X       
CODE_02FD4D:        BD 16 1E      LDA.W $1E16,X             
CODE_02FD50:        38            SEC                       
CODE_02FD51:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02FD53:        99 00 03      STA.W OAM_DispX,Y         
CODE_02FD56:        BD 02 1E      LDA.W $1E02,X             
CODE_02FD59:        38            SEC                       
CODE_02FD5A:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02FD5C:        99 01 03      STA.W OAM_DispY,Y         
CODE_02FD5F:        A5 14         LDA RAM_FrameCounterB     
CODE_02FD61:        4A            LSR                       
CODE_02FD62:        4A            LSR                       
CODE_02FD63:        4A            LSR                       
CODE_02FD64:        29 01         AND.B #$01                
CODE_02FD66:        85 00         STA $00                   
CODE_02FD68:        8A            TXA                       
CODE_02FD69:        29 03         AND.B #$03                
CODE_02FD6B:        0A            ASL                       
CODE_02FD6C:        65 00         ADC $00                   
CODE_02FD6E:        DA            PHX                       
CODE_02FD6F:        AA            TAX                       
CODE_02FD70:        BD BF FB      LDA.W BooRingTiles,X      
CODE_02FD73:        99 02 03      STA.W OAM_Tile,Y          
CODE_02FD76:        FA            PLX                       
CODE_02FD77:        BD 66 1E      LDA.W $1E66,X             
CODE_02FD7A:        0A            ASL                       
CODE_02FD7B:        A9 00         LDA.B #$00                
CODE_02FD7D:        B0 02         BCS CODE_02FD81           
CODE_02FD7F:        A9 40         LDA.B #$40                
CODE_02FD81:        09 31         ORA.B #$31                
CODE_02FD83:        05 02         ORA $02                   
CODE_02FD85:        99 03 03      STA.W OAM_Prop,Y          
CODE_02FD88:        98            TYA                       
CODE_02FD89:        4A            LSR                       
CODE_02FD8A:        4A            LSR                       
CODE_02FD8B:        A8            TAY                       
CODE_02FD8C:        A9 02         LDA.B #$02                
CODE_02FD8E:        99 60 04      STA.W OAM_TileSize,Y      
CODE_02FD91:        BD 92 18      LDA.W $1892,X             
CODE_02FD94:        C9 08         CMP.B #$08                
CODE_02FD96:        D0 1F         BNE Return02FDB7          
ADDR_02FD98:        BC 50 FF      LDY.W DATA_02FF50,X       
ADDR_02FD9B:        A5 14         LDA RAM_FrameCounterB     
ADDR_02FD9D:        4A            LSR                       
ADDR_02FD9E:        4A            LSR                       
ADDR_02FD9F:        29 01         AND.B #$01                
ADDR_02FDA1:        85 00         STA $00                   
ADDR_02FDA3:        BD 86 0F      LDA.W $0F86,X             
ADDR_02FDA6:        0A            ASL                       
ADDR_02FDA7:        05 00         ORA $00                   
ADDR_02FDA9:        DA            PHX                       
ADDR_02FDAA:        AA            TAX                       
ADDR_02FDAB:        BD B8 FD      LDA.W BatCeilingTiles,X   
ADDR_02FDAE:        99 02 03      STA.W OAM_Tile,Y          
ADDR_02FDB1:        A9 37         LDA.B #$37                
ADDR_02FDB3:        99 03 03      STA.W OAM_Prop,Y          
ADDR_02FDB6:        FA            PLX                       
Return02FDB7:       60            RTS                       ; Return 


BatCeilingTiles:                  .db $AE,$AE,$C0,$EB

CODE_02FDBC:        20 A3 FF      JSR.W CODE_02FFA3         
CODE_02FDBF:        BD 52 1E      LDA.W $1E52,X             
CODE_02FDC2:        C9 40         CMP.B #$40                
CODE_02FDC4:        10 06         BPL CODE_02FDCC           
CODE_02FDC6:        18            CLC                       
CODE_02FDC7:        69 03         ADC.B #$03                
CODE_02FDC9:        9D 52 1E      STA.W $1E52,X             
CODE_02FDCC:        BD 2A 1E      LDA.W $1E2A,X             
CODE_02FDCF:        F0 0F         BEQ CODE_02FDE0           
CODE_02FDD1:        BD 02 1E      LDA.W $1E02,X             
CODE_02FDD4:        C9 80         CMP.B #$80                
CODE_02FDD6:        90 08         BCC CODE_02FDE0           
CODE_02FDD8:        29 F0         AND.B #$F0                
CODE_02FDDA:        9D 02 1E      STA.W $1E02,X             
CODE_02FDDD:        9E 52 1E      STZ.W $1E52,X             
CODE_02FDE0:        8A            TXA                       
CODE_02FDE1:        45 13         EOR RAM_FrameCounter      
CODE_02FDE3:        4A            LSR                       
CODE_02FDE4:        90 62         BCC CODE_02FE48           
CODE_02FDE6:        BD 52 1E      LDA.W $1E52,X             
CODE_02FDE9:        D0 25         BNE CODE_02FE10           
CODE_02FDEB:        BD 66 1E      LDA.W $1E66,X             
CODE_02FDEE:        18            CLC                       
CODE_02FDEF:        7D 16 1E      ADC.W $1E16,X             
CODE_02FDF2:        9D 16 1E      STA.W $1E16,X             
CODE_02FDF5:        BD 16 1E      LDA.W $1E16,X             
CODE_02FDF8:        5D 66 1E      EOR.W $1E66,X             
CODE_02FDFB:        10 13         BPL CODE_02FE10           
CODE_02FDFD:        BD 16 1E      LDA.W $1E16,X             
CODE_02FE00:        18            CLC                       
CODE_02FE01:        69 20         ADC.B #$20                
CODE_02FE03:        C9 30         CMP.B #$30                
CODE_02FE05:        B0 09         BCS CODE_02FE10           
CODE_02FE07:        BD 66 1E      LDA.W $1E66,X             
CODE_02FE0A:        49 FF         EOR.B #$FF                
CODE_02FE0C:        1A            INC A                     
CODE_02FE0D:        9D 66 1E      STA.W $1E66,X             
CODE_02FE10:        A5 94         LDA RAM_MarioXPos         
CODE_02FE12:        38            SEC                       
CODE_02FE13:        FD 16 1E      SBC.W $1E16,X             
CODE_02FE16:        18            CLC                       
CODE_02FE17:        69 0C         ADC.B #$0C                
CODE_02FE19:        C9 1E         CMP.B #$1E                
CODE_02FE1B:        B0 2B         BCS CODE_02FE48           
CODE_02FE1D:        A9 20         LDA.B #$20                
CODE_02FE1F:        A4 73         LDY RAM_IsDucking         
CODE_02FE21:        D0 06         BNE CODE_02FE29           
CODE_02FE23:        A4 19         LDY RAM_MarioPowerUp      
CODE_02FE25:        F0 02         BEQ CODE_02FE29           
CODE_02FE27:        A9 30         LDA.B #$30                
CODE_02FE29:        85 00         STA $00                   
CODE_02FE2B:        A5 96         LDA RAM_MarioYPos         
CODE_02FE2D:        38            SEC                       
CODE_02FE2E:        FD 02 1E      SBC.W $1E02,X             
CODE_02FE31:        18            CLC                       
CODE_02FE32:        69 20         ADC.B #$20                
CODE_02FE34:        C5 00         CMP $00                   
CODE_02FE36:        B0 10         BCS CODE_02FE48           
CODE_02FE38:        9E 92 18      STZ.W $1892,X             
CODE_02FE3B:        20 6C FF      JSR.W CODE_02FF6C         
CODE_02FE3E:        CE 20 19      DEC.W $1920               
CODE_02FE41:        D0 05         BNE CODE_02FE48           
CODE_02FE43:        A9 58         LDA.B #$58                
CODE_02FE45:        8D AB 14      STA.W $14AB               
CODE_02FE48:        BC 64 FF      LDY.W DATA_02FF64,X       
CODE_02FE4B:        BD 16 1E      LDA.W $1E16,X             
CODE_02FE4E:        38            SEC                       
CODE_02FE4F:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_02FE51:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_02FE54:        BD 02 1E      LDA.W $1E02,X             
CODE_02FE57:        38            SEC                       
CODE_02FE58:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_02FE5A:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_02FE5D:        A9 24         LDA.B #$24                
CODE_02FE5F:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_02FE62:        A9 3A         LDA.B #$3A                
CODE_02FE64:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_02FE67:        98            TYA                       
CODE_02FE68:        4A            LSR                       
CODE_02FE69:        4A            LSR                       
CODE_02FE6A:        A8            TAY                       
CODE_02FE6B:        A9 02         LDA.B #$02                
CODE_02FE6D:        99 20 04      STA.W $0420,Y             
Return02FE70:       60            RTS                       ; Return 

CODE_02FE71:        A9 14         LDA.B #$14                
CODE_02FE73:        80 02         BRA CODE_02FE77           

ADDR_02FE75:        A9 0C         LDA.B #$0C                ; Unreachable instruction 
CODE_02FE77:        85 02         STA $02                   
CODE_02FE79:        64 03         STZ $03                   
CODE_02FE7B:        BD 16 1E      LDA.W $1E16,X             
CODE_02FE7E:        85 00         STA $00                   
CODE_02FE80:        BD 3E 1E      LDA.W $1E3E,X             
CODE_02FE83:        85 01         STA $01                   
CODE_02FE85:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_02FE87:        A5 94         LDA RAM_MarioXPos         
CODE_02FE89:        38            SEC                       
CODE_02FE8A:        E5 00         SBC $00                   
CODE_02FE8C:        18            CLC                       
CODE_02FE8D:        69 0A 00      ADC.W #$000A              
CODE_02FE90:        C5 02         CMP $02                   
CODE_02FE92:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_02FE94:        B0 2E         BCS Return02FEC4          
CODE_02FE96:        BD 02 1E      LDA.W $1E02,X             
CODE_02FE99:        69 03         ADC.B #$03                
CODE_02FE9B:        85 02         STA $02                   
CODE_02FE9D:        BD 2A 1E      LDA.W $1E2A,X             
CODE_02FEA0:        69 00         ADC.B #$00                
CODE_02FEA2:        85 03         STA $03                   
CODE_02FEA4:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_02FEA6:        A9 14 00      LDA.W #$0014              
CODE_02FEA9:        A4 19         LDY RAM_MarioPowerUp      
CODE_02FEAB:        F0 03         BEQ CODE_02FEB0           
CODE_02FEAD:        A9 20 00      LDA.W #$0020              
CODE_02FEB0:        85 04         STA $04                   
CODE_02FEB2:        A5 96         LDA RAM_MarioYPos         
CODE_02FEB4:        38            SEC                       
CODE_02FEB5:        E5 02         SBC $02                   
CODE_02FEB7:        18            CLC                       
CODE_02FEB8:        69 1C 00      ADC.W #$001C              
CODE_02FEBB:        C5 04         CMP $04                   
CODE_02FEBD:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_02FEBF:        B0 03         BCS Return02FEC4          
CODE_02FEC1:        20 F5 F9      JSR.W CODE_02F9F5         
Return02FEC4:       60            RTS                       ; Return 


DATA_02FEC5:                      .db $40,$B0

DATA_02FEC7:                      .db $01,$FF

DATA_02FEC9:                      .db $30,$C0

DATA_02FECB:                      .db $01,$FF

ADDR_02FECD:        A5 5B         LDA RAM_IsVerticalLvl     ; \ Unreachable 
ADDR_02FECF:        29 01         AND.B #$01                
ADDR_02FED1:        D0 4B         BNE ADDR_02FF1E           
ADDR_02FED3:        BD 02 1E      LDA.W $1E02,X             
ADDR_02FED6:        18            CLC                       
ADDR_02FED7:        69 50         ADC.B #$50                
ADDR_02FED9:        BD 2A 1E      LDA.W $1E2A,X             
ADDR_02FEDC:        69 00         ADC.B #$00                
ADDR_02FEDE:        C9 02         CMP.B #$02                
ADDR_02FEE0:        10 2C         BPL ADDR_02FF0E           
ADDR_02FEE2:        A5 13         LDA RAM_FrameCounter      
ADDR_02FEE4:        29 01         AND.B #$01                
ADDR_02FEE6:        85 01         STA $01                   
ADDR_02FEE8:        A8            TAY                       
ADDR_02FEE9:        A5 1A         LDA RAM_ScreenBndryXLo    
ADDR_02FEEB:        18            CLC                       
ADDR_02FEEC:        79 C9 FE      ADC.W DATA_02FEC9,Y       
ADDR_02FEEF:        26 00         ROL $00                   
ADDR_02FEF1:        DD 16 1E      CMP.W $1E16,X             
ADDR_02FEF4:        08            PHP                       
ADDR_02FEF5:        A5 1B         LDA RAM_ScreenBndryXHi    
ADDR_02FEF7:        46 00         LSR $00                   
ADDR_02FEF9:        79 CB FE      ADC.W DATA_02FECB,Y       
ADDR_02FEFC:        28            PLP                       
ADDR_02FEFD:        FD 3E 1E      SBC.W $1E3E,X             
ADDR_02FF00:        85 00         STA $00                   
ADDR_02FF02:        46 01         LSR $01                   
ADDR_02FF04:        90 04         BCC ADDR_02FF0A           
ADDR_02FF06:        49 80         EOR.B #$80                
ADDR_02FF08:        85 00         STA $00                   
ADDR_02FF0A:        A5 00         LDA $00                   
ADDR_02FF0C:        10 0F         BPL Return02FF1D          
ADDR_02FF0E:        BC 86 0F      LDY.W $0F86,X             
ADDR_02FF11:        C0 FF         CPY.B #$FF                
ADDR_02FF13:        F0 05         BEQ ADDR_02FF1A           
ADDR_02FF15:        A9 00         LDA.B #$00                ; \ Allow sprite to be reloaded by level loading routine 
ADDR_02FF17:        99 38 19      STA.W RAM_SprLoadStatus,Y ; / 
ADDR_02FF1A:        9E 92 18      STZ.W $1892,X             
Return02FF1D:       60            RTS                       ; / Return 

ADDR_02FF1E:        A5 13         LDA RAM_FrameCounter      ; \ Unreachable, called from above routine 
ADDR_02FF20:        4A            LSR                       
ADDR_02FF21:        B0 FA         BCS Return02FF1D          
ADDR_02FF23:        29 01         AND.B #$01                
ADDR_02FF25:        85 01         STA $01                   
ADDR_02FF27:        A8            TAY                       
ADDR_02FF28:        A5 1A         LDA RAM_ScreenBndryXLo    
ADDR_02FF2A:        18            CLC                       
ADDR_02FF2B:        79 C5 FE      ADC.W DATA_02FEC5,Y       
ADDR_02FF2E:        26 00         ROL $00                   
ADDR_02FF30:        DD 02 1E      CMP.W $1E02,X             
ADDR_02FF33:        08            PHP                       
ADDR_02FF34:        AD 1D 00      LDA.W RAM_ScreenBndryYHi  
ADDR_02FF37:        46 00         LSR $00                   
ADDR_02FF39:        79 C7 FE      ADC.W DATA_02FEC7,Y       
ADDR_02FF3C:        28            PLP                       
ADDR_02FF3D:        FD 2A 1E      SBC.W $1E2A,X             
ADDR_02FF40:        85 00         STA $00                   
ADDR_02FF42:        A4 01         LDY $01                   
ADDR_02FF44:        F0 04         BEQ ADDR_02FF4A           
ADDR_02FF46:        49 80         EOR.B #$80                
ADDR_02FF48:        85 00         STA $00                   
ADDR_02FF4A:        A5 00         LDA $00                   
ADDR_02FF4C:        10 CF         BPL Return02FF1D          
ADDR_02FF4E:        30 BE         BMI ADDR_02FF0E           ; / 

DATA_02FF50:                      .db $E0,$E4,$E8,$EC,$F0,$F4,$F8,$FC
                                  .db $5C,$58,$54,$50,$4C,$48,$44,$40
                                  .db $3C,$38,$34,$30

DATA_02FF64:                      .db $90,$94,$98,$9C,$A0,$A4,$A8,$AC

CODE_02FF6C:        22 34 AD 02   JSL.L CODE_02AD34         
CODE_02FF70:        A9 0D         LDA.B #$0D                
CODE_02FF72:        99 E1 16      STA.W RAM_ScoreSprNum,Y   
CODE_02FF75:        BD 02 1E      LDA.W $1E02,X             
CODE_02FF78:        38            SEC                       
CODE_02FF79:        E9 08         SBC.B #$08                
CODE_02FF7B:        99 E7 16      STA.W RAM_ScoreSprYLo,Y   
CODE_02FF7E:        BD 2A 1E      LDA.W $1E2A,X             
CODE_02FF81:        E9 00         SBC.B #$00                
CODE_02FF83:        99 F9 16      STA.W RAM_ScoreSprYHi,Y   
CODE_02FF86:        BD 16 1E      LDA.W $1E16,X             
CODE_02FF89:        99 ED 16      STA.W RAM_ScoreSprXLo,Y   
CODE_02FF8C:        BD 3E 1E      LDA.W $1E3E,X             
CODE_02FF8F:        99 F3 16      STA.W RAM_ScoreSprXHi,Y   
CODE_02FF92:        A9 30         LDA.B #$30                
CODE_02FF94:        99 FF 16      STA.W RAM_ScoreSprSpeedY,Y 
Return02FF97:       60            RTS                       ; Return 

CODE_02FF98:        DA            PHX                       
CODE_02FF99:        8A            TXA                       
CODE_02FF9A:        18            CLC                       
CODE_02FF9B:        69 14         ADC.B #$14                
CODE_02FF9D:        AA            TAX                       
CODE_02FF9E:        20 A3 FF      JSR.W CODE_02FFA3         
CODE_02FFA1:        FA            PLX                       
Return02FFA2:       60            RTS                       ; Return 

CODE_02FFA3:        BD 52 1E      LDA.W $1E52,X             
CODE_02FFA6:        0A            ASL                       
CODE_02FFA7:        0A            ASL                       
CODE_02FFA8:        0A            ASL                       
CODE_02FFA9:        0A            ASL                       
CODE_02FFAA:        18            CLC                       
CODE_02FFAB:        7D 7A 1E      ADC.W $1E7A,X             
CODE_02FFAE:        9D 7A 1E      STA.W $1E7A,X             
CODE_02FFB1:        08            PHP                       
CODE_02FFB2:        BD 52 1E      LDA.W $1E52,X             
CODE_02FFB5:        4A            LSR                       
CODE_02FFB6:        4A            LSR                       
CODE_02FFB7:        4A            LSR                       
CODE_02FFB8:        4A            LSR                       
CODE_02FFB9:        C9 08         CMP.B #$08                
CODE_02FFBB:        A0 00         LDY.B #$00                
CODE_02FFBD:        90 03         BCC CODE_02FFC2           
CODE_02FFBF:        09 F0         ORA.B #$F0                
CODE_02FFC1:        88            DEY                       
CODE_02FFC2:        28            PLP                       
CODE_02FFC3:        7D 02 1E      ADC.W $1E02,X             
CODE_02FFC6:        9D 02 1E      STA.W $1E02,X             
CODE_02FFC9:        98            TYA                       
CODE_02FFCA:        7D 2A 1E      ADC.W $1E2A,X             
CODE_02FFCD:        9D 2A 1E      STA.W $1E2A,X             
Return02FFD0:       60            RTS                       ; Return 

CODE_02FFD1:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_02FFD4:        30 07         BMI ADDR_02FFDD           
CODE_02FFD6:        A9 00         LDA.B #$00                
CODE_02FFD8:        BC B8 15      LDY.W $15B8,X             
CODE_02FFDB:        F0 02         BEQ CODE_02FFDF           
ADDR_02FFDD:        A9 18         LDA.B #$18                
CODE_02FFDF:        95 AA         STA RAM_SpriteSpeedY,X    
Return02FFE1:       60            RTS                       ; Return 


DATA_02FFE2:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF