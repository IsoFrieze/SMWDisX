ResetStart:         78            SEI                       ; Disable interrupts 
CODE_008001:        9C 00 42      STZ.W $4200               ; Clear NMI and V/H Count, disable joypad ; NMI, V/H Count, and Joypad Enable
CODE_008004:        9C 0C 42      STZ.W $420C               ; Disable HDMA ; H-DMA Channel Enable
CODE_008007:        9C 0B 42      STZ.W $420B               ; Disable DMA ; Regular DMA Channel Enable
CODE_00800A:        9C 40 21      STZ.W $2140               ; \ ; APU I/O Port
CODE_00800D:        9C 41 21      STZ.W $2141               ;  |Clear APU I/O ports 1-4 ; APU I/O Port
CODE_008010:        9C 42 21      STZ.W $2142               ;  | ; APU I/O Port
CODE_008013:        9C 43 21      STZ.W $2143               ; / ; APU I/O Port
CODE_008016:        A9 80         LDA.B #$80                ; \ Turn off screen 
CODE_008018:        8D 00 21      STA.W $2100               ; / ; Screen Display Register
CODE_00801B:        18            CLC                       ; \ Turn off emulation mode 
CODE_00801C:        FB            XCE                       ; /  
CODE_00801D:        C2 38         REP #$38                  ; 16 bit A,X,Y, Decimal mode off ; Index (16 bit) Accum (16 bit) 
CODE_00801F:        A9 00 00      LDA.W #$0000              ; \ Set direct page 
CODE_008022:        5B            TCD                       ; /  
CODE_008023:        A9 FF 01      LDA.W #$01FF              ; \ Set stack location 
CODE_008026:        1B            TCS                       ; /  
CODE_008027:        A9 A9 F0      LDA.W #$F0A9              ; \  
CODE_00802A:        8F 00 80 7F   STA.L RAM_7F8000          ;  | 
CODE_00802E:        A2 7D 01      LDX.W #$017D              ;  | 
CODE_008031:        A0 FD 03      LDY.W #$03FD              ;  | 
CODE_008034:        A9 8D 00      LDA.W #$008D              ;  | 
CODE_008037:        9F 02 80 7F   STA.L RAM_7F8002,X        ;  | 
CODE_00803B:        98            TYA                       ;  | 
CODE_00803C:        9F 03 80 7F   STA.L $7F8003,X           ;  |Create routine in RAM 
CODE_008040:        38            SEC                       ;  | 
CODE_008041:        E9 04 00      SBC.W #$0004              ;  | 
CODE_008044:        A8            TAY                       ;  | 
CODE_008045:        CA            DEX                       ;  | 
CODE_008046:        CA            DEX                       ;  | 
CODE_008047:        CA            DEX                       ;  | 
CODE_008048:        10 EA         BPL CODE_008034           ;  | 
CODE_00804A:        E2 30         SEP #$30                  ;  | ; Index (8 bit) Accum (8 bit) 
CODE_00804C:        A9 6B         LDA.B #$6B                ;  | 
CODE_00804E:        8F 82 81 7F   STA.L RAM_7F8182          ; / 
CODE_008052:        20 E8 80      JSR.W UploadSPCEngine     ; SPC700 Bank 02 + Main code upload handler 
CODE_008055:        9C 00 01      STZ.W RAM_GameMode        ; Set game mode to 0 
CODE_008058:        9C 09 01      STZ.W $0109               ; Set secondary game mode to 0 
CODE_00805B:        20 4E 8A      JSR.W ClearStack          
CODE_00805E:        20 FD 80      JSR.W UploadSamples       
CODE_008061:        20 50 92      JSR.W CODE_009250         
CODE_008064:        A9 03         LDA.B #$03                ; \ Set OAM Size and Data Area Designation to x03 
CODE_008066:        8D 01 21      STA.W $2101               ; /  ; OAM Size and Data Area Designation
CODE_008069:        E6 10         INC $10                   ; Skip the following loop 
CODE_00806B:        A5 10         LDA $10                   ;  |Loop until the interrupt routine sets $10 
CODE_00806D:        F0 FC         BEQ CODE_00806B           ; / to a non-zero value. 
CODE_00806F:        58            CLI                       ; Enable interrupts 
CODE_008070:        E6 13         INC RAM_FrameCounter      ; Increase frame number 
CODE_008072:        20 22 93      JSR.W GetGameMode         ; The actual game 
CODE_008075:        64 10         STZ $10                   ; \ Wait for interrupt 
CODE_008077:        80 F2         BRA CODE_00806B           ; /  

SPC700UploadLoop:   08            PHP                       
CODE_00807A:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00807C:        A0 00 00      LDY.W #$0000              
CODE_00807F:        A9 AA BB      LDA.W #$BBAA              
CODE_008082:        CD 40 21      CMP.W $2140               ; APU I/O Port
CODE_008085:        D0 FB         BNE CODE_008082           
CODE_008087:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_008089:        A9 CC         LDA.B #$CC                ; Load byte to start transfer 
CODE_00808B:        80 26         BRA CODE_0080B3           

CODE_00808D:        B7 00         LDA [$00],Y               
CODE_00808F:        C8            INY                       
CODE_008090:        EB            XBA                       
CODE_008091:        A9 00         LDA.B #$00                
CODE_008093:        80 0B         BRA CODE_0080A0           

CODE_008095:        EB            XBA                       
CODE_008096:        B7 00         LDA [$00],Y               
CODE_008098:        C8            INY                       
CODE_008099:        EB            XBA                       
CODE_00809A:        CD 40 21      CMP.W $2140               ; APU I/O Port
CODE_00809D:        D0 FB         BNE CODE_00809A           
CODE_00809F:        1A            INC A                     
CODE_0080A0:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0080A2:        8D 40 21      STA.W $2140               ; APU I/O Port
CODE_0080A5:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0080A7:        CA            DEX                       
CODE_0080A8:        D0 EB         BNE CODE_008095           
CODE_0080AA:        CD 40 21      CMP.W $2140               ; APU I/O Port
CODE_0080AD:        D0 FB         BNE CODE_0080AA           
CODE_0080AF:        69 03         ADC.B #$03                
CODE_0080B1:        F0 FC         BEQ CODE_0080AF           
CODE_0080B3:        48            PHA                       
CODE_0080B4:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0080B6:        B7 00         LDA [$00],Y               
CODE_0080B8:        C8            INY                       
CODE_0080B9:        C8            INY                       
CODE_0080BA:        AA            TAX                       
CODE_0080BB:        B7 00         LDA [$00],Y               
CODE_0080BD:        C8            INY                       
CODE_0080BE:        C8            INY                       
CODE_0080BF:        8D 42 21      STA.W $2142               ; APU I/O Port
CODE_0080C2:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0080C4:        E0 01 00      CPX.W #$0001              
CODE_0080C7:        A9 00         LDA.B #$00                
CODE_0080C9:        2A            ROL                       
CODE_0080CA:        8D 41 21      STA.W $2141               ; APU I/O Port
CODE_0080CD:        69 7F         ADC.B #$7F                
CODE_0080CF:        68            PLA                       
CODE_0080D0:        8D 40 21      STA.W $2140               ; APU I/O Port
CODE_0080D3:        CD 40 21      CMP.W $2140               ; APU I/O Port
CODE_0080D6:        D0 FB         BNE CODE_0080D3           
CODE_0080D8:        70 B3         BVS CODE_00808D           
CODE_0080DA:        9C 40 21      STZ.W $2140               ; APU I/O Port
CODE_0080DD:        9C 41 21      STZ.W $2141               ; APU I/O Port
CODE_0080E0:        9C 42 21      STZ.W $2142               ; APU I/O Port
CODE_0080E3:        9C 43 21      STZ.W $2143               ; APU I/O Port
CODE_0080E6:        28            PLP                       
CODE_0080E7:        60            RTS                       

UploadSPCEngine:    A9 00         LDA.B #$00                ; \ this address (0E:8000) is the start of the SPC engine 
CODE_0080EA:        8D 00 00      STA.W $0000               ;  | instrument settings/sound effect data 
CODE_0080ED:        A9 80         LDA.B #$80                ;  | AND the code used for all music banks. 
CODE_0080EF:        8D 01 00      STA.W $0001               ;  | 
CODE_0080F2:        A9 0E         LDA.B #$0E                ;  | 
CODE_0080F4:        8D 02 00      STA.W $0002               ; /  
UploadDataToSPC:    78            SEI                       
CODE_0080F8:        20 79 80      JSR.W SPC700UploadLoop    
CODE_0080FB:        58            CLI                       
Return0080FC:       60            RTS                       

UploadSamples:      A9 00         LDA.B #$00                ; \    Index (8 bit) ; Index (8 bit) 
CODE_0080FF:        8D 00 00      STA.W $0000               ;  | 
CODE_008102:        A9 80         LDA.B #$80                ;  |Loads The Address 0F:8000 to 00-02 	(SAMPLE DATA + PTRS)
CODE_008104:        8D 01 00      STA.W $0001               ;  |[SPC Sample Pointers/Data ROM Address, this is] 
CODE_008107:        A9 0F         LDA.B #$0F                ;  | 
CODE_008109:        8D 02 00      STA.W $0002               ; /  
CODE_00810C:        80 0F         BRA StrtSPCMscUpld        

UploadMusicBank1:   A9 B1         LDA.B #$B1                ; \ 
CODE_008110:        8D 00 00      STA.W $0000               ;  | 
CODE_008113:        A9 98         LDA.B #$98                ;  |Loads the Bank 1 music data (Map) to 00-02 
CODE_008115:        8D 01 00      STA.W $0001               ;  | ($0E:98B1) 
CODE_008118:        A9 0E         LDA.B #$0E                ;  | 
CODE_00811A:        8D 02 00      STA.W $0002               ; /  
StrtSPCMscUpld:     A9 FF         LDA.B #$FF                
CODE_00811F:        8D 41 21      STA.W $2141               ; APU I/O Port
CODE_008122:        20 F7 80      JSR.W UploadDataToSPC     
CODE_008125:        A2 03         LDX.B #$03                
SPC700ZeroLoop:     9E 40 21      STZ.W $2140,X             
CODE_00812A:        9E F9 1D      STZ.W $1DF9,X             
CODE_00812D:        9E FD 1D      STZ.W $1DFD,X             
CODE_008130:        CA            DEX                       
CODE_008131:        10 F4         BPL SPC700ZeroLoop        
Return008133:       60            RTS                       

CODE_008134:        AD 25 14      LDA.W $1425               
CODE_008137:        D0 0F         BNE UploadMusicBank2      
CODE_008139:        AD 09 01      LDA.W $0109               
CODE_00813C:        C9 E9         CMP.B #$E9                
CODE_00813E:        F0 08         BEQ UploadMusicBank2      
CODE_008140:        0D 1A 14      ORA.W $141A               
CODE_008143:        0D 1D 14      ORA.W $141D               
CODE_008146:        D0 EB         BNE Return008133          
UploadMusicBank2:   A9 D6         LDA.B #$D6                ; \ 
CODE_00814A:        8D 00 00      STA.W $0000               ;  |Loads the Bank 2 music address(Levels) 
CODE_00814D:        A9 AE         LDA.B #$AE                ;  | (0E:AED6) 
CODE_00814F:        8D 01 00      STA.W $0001               ;  | 
CODE_008152:        A9 0E         LDA.B #$0E                ;  | 
CODE_008154:        8D 02 00      STA.W $0002               ; / 
CODE_008157:        80 C4         BRA StrtSPCMscUpld        

UploadMusicBank3:   A9 00         LDA.B #$00                ; \ 
CODE_00815B:        8D 00 00      STA.W $0000               ;  |Bank 3 music(Ending) ROM address 
CODE_00815E:        A9 E4         LDA.B #$E4                ;  | 
CODE_008160:        8D 01 00      STA.W $0001               ;  | ($03:E400) 
CODE_008163:        A9 03         LDA.B #$03                ;  | 
CODE_008165:        8D 02 00      STA.W $0002               ; / 
CODE_008168:        80 B3         BRA StrtSPCMscUpld        


NMIStart:           78            SEI                       ; Looks like this might be the NMI routine here. That is correct. 
CODE_00816B:        08            PHP                       ; I thought it was, just from the address, but I wasn't too sure. 
CODE_00816C:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00816E:        48            PHA                       
CODE_00816F:        DA            PHX                       
CODE_008170:        5A            PHY                       
CODE_008171:        8B            PHB                       
CODE_008172:        4B            PHK                       
CODE_008173:        AB            PLB                       
CODE_008174:        E2 30         SEP #$30                  ; 8 bit A,X,Y ; Index (8 bit) Accum (8 bit) 
CODE_008176:        AD 10 42      LDA.W $4210               ; Load "NMI Enable."  This has the effect of clearing the Interrupt, so that ; NMI Enable
CODE_008179:        AD FB 1D      LDA.W $1DFB               ; \  
CODE_00817C:        D0 08         BNE CODE_008186           ;  | 
CODE_00817E:        AC 42 21      LDY.W $2142               ;  | ; APU I/O Port
CODE_008181:        CC FF 1D      CPY.W $1DFF               ;  |Update SPC700 I/O port 2 
CODE_008184:        D0 09         BNE CODE_00818F           ;  | 
CODE_008186:        8D 42 21      STA.W $2142               ;  | ; APU I/O Port
CODE_008189:        8D FF 1D      STA.W $1DFF               ;  | 
CODE_00818C:        9C FB 1D      STZ.W $1DFB               ;  | 
CODE_00818F:        AD F9 1D      LDA.W $1DF9               ; \  
CODE_008192:        8D 40 21      STA.W $2140               ;  | ; APU I/O Port
CODE_008195:        AD FA 1D      LDA.W $1DFA               ;  | 
CODE_008198:        8D 41 21      STA.W $2141               ;  |Update SPC700 I/O ports 0, 1 and 3 ; APU I/O Port
CODE_00819B:        AD FC 1D      LDA.W $1DFC               ;  | 
CODE_00819E:        8D 43 21      STA.W $2143               ;  | ; APU I/O Port
CODE_0081A1:        9C F9 1D      STZ.W $1DF9               ;  | 
CODE_0081A4:        9C FA 1D      STZ.W $1DFA               ;  | 
CODE_0081A7:        9C FC 1D      STZ.W $1DFC               ; /  
CODE_0081AA:        A9 80         LDA.B #$80                ; \ Screen off, brightness=0 
CODE_0081AC:        8D 00 21      STA.W $2100               ; / ; Screen Display Register
CODE_0081AF:        9C 0C 42      STZ.W $420C               ; Zero The HDMA reg ; H-DMA Channel Enable
CODE_0081B2:        A5 41         LDA $41                   
CODE_0081B4:        8D 23 21      STA.W $2123               ; BG 1 and 2 Window Mask Settings
CODE_0081B7:        A5 42         LDA $42                   
CODE_0081B9:        8D 24 21      STA.W $2124               ; BG 3 and 4 Window Mask Settings
CODE_0081BC:        A5 43         LDA $43                   
CODE_0081BE:        8D 25 21      STA.W $2125               ; OBJ and Color Window Settings
CODE_0081C1:        A5 44         LDA $44                   
CODE_0081C3:        8D 30 21      STA.W $2130               ; Initial Settings for Color Addition
CODE_0081C6:        AD 9B 0D      LDA.W $0D9B               ; \  
CODE_0081C9:        10 03         BPL CODE_0081CE           ;  |If in a "Special level", 
CODE_0081CB:        4C C4 82      JMP.W CODE_0082C4         ;  |jump to $82C4 

CODE_0081CE:        A5 40         LDA $40                   ; \ Get the CGADSUB byte... 
CODE_0081D0:        29 FB         AND.B #$FB                ;  |Get the Add/Subtract Select and Enable part... 
CODE_0081D2:        8D 31 21      STA.W $2131               ; / ...and store it to the A/SSaE register... ; Add/Subtract Select and Enable
CODE_0081D5:        A9 09         LDA.B #$09                ; \ 8x8 tiles, Graphics mode 1 
CODE_0081D7:        8D 05 21      STA.W $2105               ; /  ; BG Mode and Tile Size Setting
CODE_0081DA:        A5 10         LDA $10                   ; \ If there isn't any lag, 
CODE_0081DC:        F0 09         BEQ CODE_0081E7           ; / branch to $81E7 
CODE_0081DE:        AD 9B 0D      LDA.W $0D9B               ; \  
CODE_0081E1:        4A            LSR                       ;  |If not on a special level, branch to NMINotSpecialLv 
CODE_0081E2:        F0 62         BEQ NMINotSpecialLv       ; /  
CODE_0081E4:        4C 7A 82      JMP.W CODE_00827A         

CODE_0081E7:        E6 10         INC $10                   
CODE_0081E9:        20 88 A4      JSR.W CODE_00A488         
CODE_0081EC:        AD 9B 0D      LDA.W $0D9B               
CODE_0081EF:        4A            LSR                       
CODE_0081F0:        D0 30         BNE CODE_008222           
CODE_0081F2:        B0 03         BCS CODE_0081F7           
CODE_0081F4:        20 AC 8D      JSR.W DrawStatusBar       
CODE_0081F7:        AD C6 13      LDA.W $13C6               ; \  
CODE_0081FA:        C9 08         CMP.B #$08                ;  |If the current cutscene isn't the ending, 
CODE_0081FC:        D0 0B         BNE CODE_008209           ; / branch to $8209 
CODE_0081FE:        AD FE 1F      LDA.W $1FFE               ; \  
CODE_008201:        F0 17         BEQ CODE_00821A           ;  |Related to reloading the palettes when switching 
CODE_008203:        22 67 95 0C   JSL.L CODE_0C9567         ;  |to another background during the credits. 
CODE_008207:        80 11         BRA CODE_00821A           ; /  

CODE_008209:        22 AD 87 00   JSL.L CODE_0087AD         
CODE_00820D:        AD 3A 14      LDA.W $143A               
CODE_008210:        F0 05         BEQ CODE_008217           
CODE_008212:        20 C2 A7      JSR.W CODE_00A7C2         
CODE_008215:        80 26         BRA CODE_00823D           

CODE_008217:        20 90 A3      JSR.W CODE_00A390         
CODE_00821A:        20 36 A4      JSR.W CODE_00A436         
CODE_00821D:        20 00 A3      JSR.W MarioGFXDMA         
CODE_008220:        80 1B         BRA CODE_00823D           

CODE_008222:        AD D9 13      LDA.W $13D9               
CODE_008225:        C9 0A         CMP.B #$0A                
CODE_008227:        D0 0E         BNE CODE_008237           
CODE_008229:        AC E8 1D      LDY.W $1DE8               
CODE_00822C:        88            DEY                       
CODE_00822D:        88            DEY                       
CODE_00822E:        C0 04         CPY.B #$04                
CODE_008230:        B0 05         BCS CODE_008237           
CODE_008232:        20 29 A5      JSR.W CODE_00A529         
CODE_008235:        80 0C         BRA CODE_008243           

CODE_008237:        20 E3 A4      JSR.W CODE_00A4E3         
CODE_00823A:        20 00 A3      JSR.W MarioGFXDMA         
CODE_00823D:        20 D2 85      JSR.W LoadScrnImage       
CODE_008240:        20 49 84      JSR.W DoSomeSpriteDMA     
CODE_008243:        20 50 86      JSR.W ControllerUpdate    
NMINotSpecialLv:    A5 1A         LDA RAM_ScreenBndryXLo    ; \  
CODE_008248:        8D 0D 21      STA.W $210D               ;  |Set BG 1 Horizontal Scroll Offset ; BG 1 Horizontal Scroll Offset
CODE_00824B:        A5 1B         LDA RAM_ScreenBndryXHi    ;  |to X position of screen boundry  
CODE_00824D:        8D 0D 21      STA.W $210D               ; /  ; BG 1 Horizontal Scroll Offset
CODE_008250:        A5 1C         LDA RAM_ScreenBndryYLo    ; \  
CODE_008252:        18            CLC                       ;  | 
CODE_008253:        6D 88 18      ADC.W RAM_Layer1DispYLo   ;  |Set BG 1 Vertical Scroll Offset 
CODE_008256:        8D 0E 21      STA.W $210E               ;  |to Y position of screen boundry + Layer 1 disposition ; BG 1 Vertical Scroll Offset
CODE_008259:        A5 1D         LDA RAM_ScreenBndryYHi    ;  | 
CODE_00825B:        6D 89 18      ADC.W RAM_Layer1DispYHi   ;  | 
CODE_00825E:        8D 0E 21      STA.W $210E               ; /  ; BG 1 Vertical Scroll Offset
CODE_008261:        A5 1E         LDA $1E                   ; \  
CODE_008263:        8D 0F 21      STA.W $210F               ;  |Set BG 2 Horizontal Scroll Offset ; BG 2 Horizontal Scroll Offset
CODE_008266:        A5 1F         LDA $1F                   ;  |to X position of Layer 2 
CODE_008268:        8D 0F 21      STA.W $210F               ; /  ; BG 2 Horizontal Scroll Offset
CODE_00826B:        A5 20         LDA $20                   ; \  
CODE_00826D:        8D 10 21      STA.W $2110               ;  |Set BG 2 Vertical Scroll Offset ; BG 2 Vertical Scroll Offset
CODE_008270:        A5 21         LDA $21                   ;  |to Y position of Layer 2 
CODE_008272:        8D 10 21      STA.W $2110               ; /  ; BG 2 Vertical Scroll Offset
CODE_008275:        AD 9B 0D      LDA.W $0D9B               ; \ If in a normal (not special) level, branch 
CODE_008278:        F0 18         BEQ CODE_008292           ; /  
CODE_00827A:        A9 81         LDA.B #$81                
CODE_00827C:        AC C6 13      LDY.W $13C6               ; \  
CODE_00827F:        C0 08         CPY.B #$08                ;  |If not playing ending movie, branch to $82A1 
CODE_008281:        D0 1E         BNE CODE_0082A1           ; /  
CODE_008283:        AC AE 0D      LDY.W $0DAE               ; \  
CODE_008286:        8C 00 21      STY.W $2100               ; / Set brightness to $0DAE ; Screen Display Register
CODE_008289:        AC 9F 0D      LDY.W $0D9F               ; \  
CODE_00828C:        8C 0C 42      STY.W $420C               ; / Set HDMA channel enable to $0D9F ; H-DMA Channel Enable
CODE_00828F:        4C 8C 83      JMP.W IRQNMIEnding        

CODE_008292:        A0 24         LDY.B #$24                ; \  ; IRQ timer, at which scanline the IRQ will be fired.
CODE_008294:        AD 11 42      LDA.W $4211               ;  |(i.e. below the status bar) ; IRQ Flag By H/V Count Timer
CODE_008297:        8C 09 42      STY.W $4209               ;  | ; V-Count Timer (Upper 8 Bits)
CODE_00829A:        9C 0A 42      STZ.W $420A               ; /  ; V-Count Timer MSB (Bit 0)
CODE_00829D:        64 11         STZ $11                   
CODE_00829F:        A9 A1         LDA.B #$A1                
CODE_0082A1:        8D 00 42      STA.W $4200               ; NMI, V/H Count, and Joypad Enable
CODE_0082A4:        9C 11 21      STZ.W $2111               ; \  ; BG 3 Horizontal Scroll Offset- Write twice register
CODE_0082A7:        9C 11 21      STZ.W $2111               ;  |Set Layer 3 horizontal and vertical ; BG 3 Horizontal Scroll Offset
CODE_0082AA:        9C 12 21      STZ.W $2112               ;  |scroll to x00 ; BG 3 Vertical Scroll Offset ; Write twice register
CODE_0082AD:        9C 12 21      STZ.W $2112               ; /  ; BG 3 Vertical Scroll Offset
CODE_0082B0:        AD AE 0D      LDA.W $0DAE               ; \  
CODE_0082B3:        8D 00 21      STA.W $2100               ; / Set brightness to $0DAE ; Screen Display Register
CODE_0082B6:        AD 9F 0D      LDA.W $0D9F               ; \  
CODE_0082B9:        8D 0C 42      STA.W $420C               ; / Set HDMA channel enable to $0D9F ; H-DMA Channel Enable
CODE_0082BC:        C2 30         REP #$30                  ; \ Pull all ; Index (16 bit) Accum (16 bit) 
CODE_0082BE:        AB            PLB                       ;  | 
CODE_0082BF:        7A            PLY                       ;  | 
CODE_0082C0:        FA            PLX                       ;  | 
CODE_0082C1:        68            PLA                       ;  | 
CODE_0082C2:        28            PLP                       ; /  
CODE_0082C3:        40            RTI                       ; And return 

CODE_0082C4:        A5 10         LDA $10                   ; \ If there is lag, ; Index (8 bit) Accum (8 bit) 
CODE_0082C6:        D0 2F         BNE CODE_0082F7           ; / branch to $82F7 
CODE_0082C8:        E6 10         INC $10                   
CODE_0082CA:        AD 3A 14      LDA.W $143A               ; \ If Mario Start! graphics shouldn't be loaded, 
CODE_0082CD:        F0 05         BEQ CODE_0082D4           ; / branch to $82D4 
ADDR_0082CF:        20 C2 A7      JSR.W CODE_00A7C2         
ADDR_0082D2:        80 14         BRA CODE_0082E8           

CODE_0082D4:        20 36 A4      JSR.W CODE_00A436         
CODE_0082D7:        20 00 A3      JSR.W MarioGFXDMA         
CODE_0082DA:        2C 9B 0D      BIT.W $0D9B               
CODE_0082DD:        50 09         BVC CODE_0082E8           
CODE_0082DF:        20 A9 98      JSR.W CODE_0098A9         
CODE_0082E2:        AD 9B 0D      LDA.W $0D9B               
CODE_0082E5:        4A            LSR                       
CODE_0082E6:        B0 03         BCS CODE_0082EB           
CODE_0082E8:        20 AC 8D      JSR.W DrawStatusBar       
CODE_0082EB:        20 88 A4      JSR.W CODE_00A488         
CODE_0082EE:        20 D2 85      JSR.W LoadScrnImage       
CODE_0082F1:        20 49 84      JSR.W DoSomeSpriteDMA     
CODE_0082F4:        20 50 86      JSR.W ControllerUpdate    
CODE_0082F7:        A9 09         LDA.B #$09                
CODE_0082F9:        8D 05 21      STA.W $2105               ; BG Mode and Tile Size Setting
CODE_0082FC:        A5 2A         LDA $2A                   
CODE_0082FE:        18            CLC                       
CODE_0082FF:        69 80         ADC.B #$80                
CODE_008301:        8D 1F 21      STA.W $211F               ; Mode 7 Center Position X
CODE_008304:        A5 2B         LDA $2B                   
CODE_008306:        69 00         ADC.B #$00                
CODE_008308:        8D 1F 21      STA.W $211F               ; Mode 7 Center Position X
CODE_00830B:        A5 2C         LDA $2C                   
CODE_00830D:        18            CLC                       
CODE_00830E:        69 80         ADC.B #$80                
CODE_008310:        8D 20 21      STA.W $2120               ; Mode 7 Center Position Y
CODE_008313:        A5 2D         LDA $2D                   
CODE_008315:        69 00         ADC.B #$00                
CODE_008317:        8D 20 21      STA.W $2120               ; Mode 7 Center Position Y
CODE_00831A:        A5 2E         LDA $2E                   
CODE_00831C:        8D 1B 21      STA.W $211B               ; Mode 7 Matrix Parameter A
CODE_00831F:        A5 2F         LDA $2F                   
CODE_008321:        8D 1B 21      STA.W $211B               ; Mode 7 Matrix Parameter A
CODE_008324:        A5 30         LDA $30                   
CODE_008326:        8D 1C 21      STA.W $211C               ; Mode 7 Matrix Parameter B
CODE_008329:        A5 31         LDA $31                   
CODE_00832B:        8D 1C 21      STA.W $211C               ; Mode 7 Matrix Parameter B
CODE_00832E:        A5 32         LDA $32                   
CODE_008330:        8D 1D 21      STA.W $211D               ; Mode 7 Matrix Parameter C
CODE_008333:        A5 33         LDA $33                   
CODE_008335:        8D 1D 21      STA.W $211D               ; Mode 7 Matrix Parameter C
CODE_008338:        A5 34         LDA $34                   
CODE_00833A:        8D 1E 21      STA.W $211E               ; Mode 7 Matrix Parameter D
CODE_00833D:        A5 35         LDA $35                   
CODE_00833F:        8D 1E 21      STA.W $211E               ; Mode 7 Matrix Parameter D
CODE_008342:        20 16 84      JSR.W SETL1SCROLL         
CODE_008345:        AD 9B 0D      LDA.W $0D9B               
CODE_008348:        4A            LSR                       
CODE_008349:        90 11         BCC CODE_00835C           
CODE_00834B:        AD AE 0D      LDA.W $0DAE               
CODE_00834E:        8D 00 21      STA.W $2100               ; Screen Display Register
CODE_008351:        AD 9F 0D      LDA.W $0D9F               
CODE_008354:        8D 0C 42      STA.W $420C               ; H-DMA Channel Enable
CODE_008357:        A9 81         LDA.B #$81                
CODE_008359:        4C F3 83      JMP.W CODE_0083F3         

CODE_00835C:        A0 24         LDY.B #$24                
CODE_00835E:        2C 9B 0D      BIT.W $0D9B               
CODE_008361:        50 0E         BVC CODE_008371           
CODE_008363:        AD FC 13      LDA.W $13FC               
CODE_008366:        0A            ASL                       
CODE_008367:        AA            TAX                       
CODE_008368:        BD E8 F8      LDA.W DATA_00F8E8,X       
CODE_00836B:        C9 2A         CMP.B #$2A                
CODE_00836D:        D0 02         BNE CODE_008371           
CODE_00836F:        A0 2D         LDY.B #$2D                
CODE_008371:        4C 94 82      JMP.W CODE_008294         

IRQHandler:         78            SEI                       ; Set Interrupt flag so routine can start 
IRQStart:           08            PHP                       ; \ Save A/X/Y/P/B 
CODE_008376:        C2 30         REP #$30                  ;  |P = Processor Flags, B = bank number for all $xxxx operations ; Index (16 bit) Accum (16 bit) 
CODE_008378:        48            PHA                       ;  |Set B to 0$0 
CODE_008379:        DA            PHX                       ;  | 
CODE_00837A:        5A            PHY                       ;  | 
CODE_00837B:        8B            PHB                       ;  | 
CODE_00837C:        4B            PHK                       ;  | 
CODE_00837D:        AB            PLB                       ; /  
CODE_00837E:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_008380:        AD 11 42      LDA.W $4211               ; Read the IRQ register, 'unapply' the interrupt ; IRQ Flag By H/V Count Timer
CODE_008383:        10 2D         BPL CODE_0083B2           ; If "Timer IRQ" is clear, skip the next code block 
CODE_008385:        A9 81         LDA.B #$81                
CODE_008387:        AC 9B 0D      LDY.W $0D9B               
CODE_00838A:        30 2E         BMI CODE_0083BA           ; If Bit 7 (negative flag) is set, branch to a different IRQ mode 
IRQNMIEnding:       8D 00 42      STA.W $4200               ; Enable NMI Interrupt and Automatic Joypad reading ; NMI, V/H Count, and Joypad Enable
CODE_00838F:        A0 1F         LDY.B #$1F                
CODE_008391:        20 3B 84      JSR.W WaitForHBlank       
CODE_008394:        A5 22         LDA $22                   ; \ Adjust scroll settings for layer 3 
CODE_008396:        8D 11 21      STA.W $2111               ;  | ; BG 3 Horizontal Scroll Offset
CODE_008399:        A5 23         LDA $23                   ;  | 
CODE_00839B:        8D 11 21      STA.W $2111               ;  | ; BG 3 Horizontal Scroll Offset
CODE_00839E:        A5 24         LDA $24                   ;  | 
CODE_0083A0:        8D 12 21      STA.W $2112               ;  | ; BG 3 Vertical Scroll Offset
CODE_0083A3:        A5 25         LDA $25                   ;  | 
CODE_0083A5:        8D 12 21      STA.W $2112               ; /  ; BG 3 Vertical Scroll Offset
CODE_0083A8:        A5 3E         LDA $3E                   ; \Set the layer BG sizes, L3 priority, and BG mode 
CODE_0083AA:        8D 05 21      STA.W $2105               ; /(Effectively, this is the screen mode) ; BG Mode and Tile Size Setting
CODE_0083AD:        A5 40         LDA $40                   ; \Write CGADSUB 
CODE_0083AF:        8D 31 21      STA.W $2131               ; / ; Add/Subtract Select and Enable
CODE_0083B2:        C2 30         REP #$30                  ; \ Pull everything back ; Index (16 bit) Accum (16 bit) 
CODE_0083B4:        AB            PLB                       ;  | 
CODE_0083B5:        7A            PLY                       ;  | 
CODE_0083B6:        FA            PLX                       ;  | 
CODE_0083B7:        68            PLA                       ;  | 
CODE_0083B8:        28            PLP                       ; / 
EmptyHandler:       40            RTI                       ; And Return 

CODE_0083BA:        2C 9B 0D      BIT.W $0D9B               ; Get bit 6 of $0D9B ; Index (8 bit) Accum (8 bit) 
CODE_0083BD:        50 24         BVC CODE_0083E3           ; If clear, skip the next code section 
CODE_0083BF:        A4 11         LDY $11                   ; \Skip if $11 = 0 
CODE_0083C1:        F0 0D         BEQ CODE_0083D0           ; / 
CODE_0083C3:        8D 00 42      STA.W $4200               ; #$81 -> NMI / Controller Enable reg ; NMI, V/H Count, and Joypad Enable
CODE_0083C6:        A0 14         LDY.B #$14                
CODE_0083C8:        20 3B 84      JSR.W WaitForHBlank       
CODE_0083CB:        20 16 84      JSR.W SETL1SCROLL         
CODE_0083CE:        80 D8         BRA CODE_0083A8           

CODE_0083D0:        E6 11         INC $11                   ; $11++ 
CODE_0083D2:        AD 11 42      LDA.W $4211               ; \ Set up the IRQ routine for layer 3 ; IRQ Flag By H/V Count Timer
CODE_0083D5:        A9 AE         LDA.B #$AE                ;  |-\  
CODE_0083D7:        38            SEC                       ;  |  |Vertical Counter trigger at 174 - $1888 
CODE_0083D8:        ED 88 18      SBC.W RAM_Layer1DispYLo   ;  |-/ Oddly enough, $1888 seems to be 16-bit, but the 
CODE_0083DB:        8D 09 42      STA.W $4209               ;  |Store to Vertical Counter Timer ; V-Count Timer (Upper 8 Bits)
CODE_0083DE:        9C 0A 42      STZ.W $420A               ; / Make the high byte of said timer 0 ; V-Count Timer MSB (Bit 0)
CODE_0083E1:        A9 A1         LDA.B #$A1                ; A = NMI enable, V count enable, joypad automatic read enable, H count disable 
CODE_0083E3:        AC 93 14      LDY.W $1493               ; if $1493 = 0 skip down 
CODE_0083E6:        F0 0B         BEQ CODE_0083F3           
CODE_0083E8:        AC 95 14      LDY.W $1495               ; \ If $1495 is <#$40 
CODE_0083EB:        C0 40         CPY.B #$40                ;  | 
CODE_0083ED:        90 04         BCC CODE_0083F3           ; / Skip down 
CODE_0083EF:        A9 81         LDA.B #$81                
CODE_0083F1:        80 99         BRA IRQNMIEnding          ; Jump up to IRQNMIEnding 

CODE_0083F3:        8D 00 42      STA.W $4200               ; A -> NMI/Joypad Auto-Read/HV-Count Control Register ; NMI, V/H Count, and Joypad Enable
CODE_0083F6:        20 39 84      JSR.W CODE_008439         
CODE_0083F9:        EA            NOP                       ; \Not often you see NOP, I think there was a JSL here at one point maybe 
CODE_0083FA:        EA            NOP                       ; / 
CODE_0083FB:        A9 07         LDA.B #$07                ; \Write Screen register 
CODE_0083FD:        8D 05 21      STA.W $2105               ; / ; BG Mode and Tile Size Setting
CODE_008400:        A5 3A         LDA $3A                   ; \ Write L1 Horizontal scroll 
CODE_008402:        8D 0D 21      STA.W $210D               ;  | ; BG 1 Horizontal Scroll Offset
CODE_008405:        A5 3B         LDA $3B                   ;  | 
CODE_008407:        8D 0D 21      STA.W $210D               ; /  ; BG 1 Horizontal Scroll Offset
CODE_00840A:        A5 3C         LDA $3C                   ; \ Write L1 Vertical Scroll 
CODE_00840C:        8D 0E 21      STA.W $210E               ;  | ; BG 1 Vertical Scroll Offset
CODE_00840F:        A5 3D         LDA $3D                   ;  | 
CODE_008411:        8D 0E 21      STA.W $210E               ; /  ; BG 1 Vertical Scroll Offset
CODE_008414:        80 9C         BRA CODE_0083B2           ; And exit IRQ 

SETL1SCROLL:        A9 59         LDA.B #$59                ; \ 
CODE_008418:        8D 07 21      STA.W $2107               ; /Write L1 GFX source address ; BG 1 Address and Size
CODE_00841B:        A9 07         LDA.B #$07                ; \Write L1/L2 Tilemap address 
CODE_00841D:        8D 0B 21      STA.W $210B               ; / ; BG 1 & 2 Tile Data Designation
CODE_008420:        A5 1A         LDA RAM_ScreenBndryXLo    ; \ Write L1 Horizontal scroll 
CODE_008422:        8D 0D 21      STA.W $210D               ;  | ; BG 1 Horizontal Scroll Offset
CODE_008425:        A5 1B         LDA RAM_ScreenBndryXHi    ;  | 
CODE_008427:        8D 0D 21      STA.W $210D               ; / ; BG 1 Horizontal Scroll Offset
CODE_00842A:        A5 1C         LDA RAM_ScreenBndryYLo    ; \ $1C + $1888 -> L1 Vert scroll 
CODE_00842C:        18            CLC                       ;  |$1888 = Some sort of vertioffset 
CODE_00842D:        6D 88 18      ADC.W RAM_Layer1DispYLo   ;  | 
CODE_008430:        8D 0E 21      STA.W $210E               ; / ; BG 1 Vertical Scroll Offset
CODE_008433:        A5 1D         LDA RAM_ScreenBndryYHi    ; \Other half of L1 vert scroll 
CODE_008435:        8D 0E 21      STA.W $210E               ; / ; BG 1 Vertical Scroll Offset
Return008438:       60            RTS                       ; Return 

CODE_008439:        A0 20         LDY.B #$20                ; <<- Could this be just to waste time? 
WaitForHBlank:      2C 12 42      BIT.W $4212               ; So... LDY gets set with 20 if there is a H-Blank...? ; H/V Blank Flags and Joypad Status
CODE_00843E:        70 F9         BVS CODE_008439           ; if in H-Blank, make Y #$20 and try again 
CODE_008440:        2C 12 42      BIT.W $4212               ; Now wait until not in H-Blank ; H/V Blank Flags and Joypad Status
CODE_008443:        50 FB         BVC CODE_008440           
CODE_008445:        88            DEY                       ;  |Y = 0 
CODE_008446:        D0 FD         BNE CODE_008445           ; / ...wait a second... why didn't they just do LDY #$00? ...waste more time? 
Return008448:       60            RTS                       ; return 

DoSomeSpriteDMA:    9C 00 43      STZ.W $4300               ; Parameters for DMA Transfer
CODE_00844C:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00844E:        9C 02 21      STZ.W $2102               ; OAM address ; Address for Accessing OAM
CODE_008451:        A9 04 00      LDA.W #$0004              
CODE_008454:        8D 01 43      STA.W $4301               ; Dest. address = $2104 (data write to OAM) ; B Address
CODE_008457:        A9 02 00      LDA.W #$0002              
CODE_00845A:        8D 03 43      STA.W $4303               ; Source address = $00:0200 ; A Address (High Byte)
CODE_00845D:        A9 20 02      LDA.W #$0220              
CODE_008460:        8D 05 43      STA.W $4305               ; $0220 bytes to transfer ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_008463:        A0 01         LDY.B #$01                
CODE_008465:        8C 0B 42      STY.W $420B               ; Start DMA ; Regular DMA Channel Enable
CODE_008468:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00846A:        A9 80         LDA.B #$80                ; \  
CODE_00846C:        8D 03 21      STA.W $2103               ;  | 
CODE_00846F:        A5 3F         LDA $3F                   ;  |Change the OAM read/write address to #$8000 + $3F 
CODE_008471:        8D 02 21      STA.W $2102               ; /  ; Address for Accessing OAM
Return008474:       60            RTS                       ; Return 


DATA_008475:                      .db $00,$00,$08,$00,$10,$00,$18,$00
                                  .db $20,$00,$28,$00,$30,$00,$38,$00
                                  .db $40,$00,$48,$00,$50,$00,$58,$00
                                  .db $60,$00,$68,$00,$70,$00,$78

CODE_008494:        A0 1E         LDY.B #$1E                
CODE_008496:        BE 75 84      LDX.W DATA_008475,Y       
CODE_008499:        BD 23 04      LDA.W $0423,X             
CODE_00849C:        0A            ASL                       
CODE_00849D:        0A            ASL                       
CODE_00849E:        1D 22 04      ORA.W $0422,X             
CODE_0084A1:        0A            ASL                       
CODE_0084A2:        0A            ASL                       
CODE_0084A3:        1D 21 04      ORA.W $0421,X             
CODE_0084A6:        0A            ASL                       
CODE_0084A7:        0A            ASL                       
CODE_0084A8:        1D 20 04      ORA.W $0420,X             
CODE_0084AB:        99 00 04      STA.W $0400,Y             
CODE_0084AE:        BD 27 04      LDA.W $0427,X             
CODE_0084B1:        0A            ASL                       
CODE_0084B2:        0A            ASL                       
CODE_0084B3:        1D 26 04      ORA.W $0426,X             
CODE_0084B6:        0A            ASL                       
CODE_0084B7:        0A            ASL                       
CODE_0084B8:        1D 25 04      ORA.W $0425,X             
CODE_0084BB:        0A            ASL                       
CODE_0084BC:        0A            ASL                       
CODE_0084BD:        1D 24 04      ORA.W $0424,X             
CODE_0084C0:        99 01 04      STA.W $0401,Y             
CODE_0084C3:        88            DEY                       
CODE_0084C4:        88            DEY                       
CODE_0084C5:        10 CF         BPL CODE_008496           
Return0084C7:       60            RTS                       

CODE_0084C8:        8B            PHB                       ; Wrapper 
CODE_0084C9:        4B            PHK                       
CODE_0084CA:        AB            PLB                       
CODE_0084CB:        20 D2 85      JSR.W LoadScrnImage       
CODE_0084CE:        AB            PLB                       
Return0084CF:       6B            RTL                       


ImagePointers:         7D 83 7F   .dw $837D .db $7F         ; Not used? 
                       75 B3 05   .dw DATA_05B375 .db :$DATA_05B375 ; Title screen 
                       00 A4 04   .dw DATA_04A400 .db :$DATA_04A400 ; OW border 
                       FF B0 05   .dw DATA_05B0FF .db :$DATA_05B0FF 
                       1C B9 05   .dw DATA_05B91C .db :$DATA_05B91C ; CONTINUE/END 
                       00 B8 0C   .dw DATA_0CB800 .db :$DATA_0CB800 
                       72 B8 05   .dw DATA_05B872 .db :$DATA_05B872 ; 1 PLAYER GAME/2 PLAYER GAME 
                       9F 81 04   .dw DATA_04819F .db :$DATA_04819F ; OW scroll arrows 
                       E0 81 04   .dw DATA_0481E0 .db :$DATA_0481E0 ; Remove OW scroll arrows 
                       99 F4 04   .dw DATA_04F499 .db :$DATA_04F499 
                       C7 B8 05   .dw DATA_05B8C7 .db :$DATA_05B8C7 ; CONTINUE AND SAVE 
                       F1 BF 0C   .dw DATA_0CBFF1 .db :$DATA_0CBFF1 
                       C3 BF 0C   .dw DATA_0CBFC3 .db :$DATA_0CBFC3 ; Cutscene 1 text: Line 7 
                       8E BF 0C   .dw DATA_0CBF8E .db :$DATA_0CBF8E ; Cutscene 1 text: Line 6 
                       59 BF 0C   .dw DATA_0CBF59 .db :$DATA_0CBF59 ; Cutscene 1 text: Line 5 
                       24 BF 0C   .dw DATA_0CBF24 .db :$DATA_0CBF24 ; Cutscene 1 text: Line 4 
                       EF BE 0C   .dw DATA_0CBEEF .db :$DATA_0CBEEF ; Cutscene 1 text: Line 3 
                       BA BE 0C   .dw DATA_0CBEBA .db :$DATA_0CBEBA ; Cutscene 1 text: Line 2 
                       85 BE 0C   .dw DATA_0CBE85 .db :$DATA_0CBE85 ; Cutscene 1 text: Line 1 
                       65 C1 0C   .dw DATA_0CC165 .db :$DATA_0CC165 ; Cutscene 2 text: Line 8 
                       30 C1 0C   .dw DATA_0CC130 .db :$DATA_0CC130 ; Cutscene 2 text: Line 7 
                       FB C0 0C   .dw DATA_0CC0FB .db :$DATA_0CC0FB ; Cutscene 2 text: Line 6 
                       C6 C0 0C   .dw DATA_0CC0C6 .db :$DATA_0CC0C6 
                       91 C0 0C   .dw DATA_0CC091 .db :$DATA_0CC091 ; ...etc... 
                       5C C0 0C   .dw DATA_0CC05C .db :$DATA_0CC05C 
                       27 C0 0C   .dw DATA_0CC027 .db :$DATA_0CC027 
                       F2 BF 0C   .dw DATA_0CBFF2 .db :$DATA_0CBFF2 
                       F1 BF 0C   .dw DATA_0CBFF1 .db :$DATA_0CBFF1 
                       CE C2 0C   .dw DATA_0CC2CE .db :$DATA_0CC2CE 
                       99 C2 0C   .dw DATA_0CC299 .db :$DATA_0CC299 
                       64 C2 0C   .dw DATA_0CC264 .db :$DATA_0CC264 
                       2F C2 0C   .dw DATA_0CC22F .db :$DATA_0CC22F 
                       FA C1 0C   .dw DATA_0CC1FA .db :$DATA_0CC1FA 
                       C5 C1 0C   .dw DATA_0CC1C5 .db :$DATA_0CC1C5 
                       90 C1 0C   .dw DATA_0CC190 .db :$DATA_0CC190 
                       6C C4 0C   .dw DATA_0CC46C .db :$DATA_0CC46C 
                       37 C4 0C   .dw DATA_0CC437 .db :$DATA_0CC437 
                       02 C4 0C   .dw DATA_0CC402 .db :$DATA_0CC402 
                       CD C3 0C   .dw DATA_0CC3CD .db :$DATA_0CC3CD 
                       98 C3 0C   .dw DATA_0CC398 .db :$DATA_0CC398 
                       63 C3 0C   .dw DATA_0CC363 .db :$DATA_0CC363 
                       2E C3 0C   .dw DATA_0CC32E .db :$DATA_0CC32E 
                       F9 C2 0C   .dw DATA_0CC2F9 .db :$DATA_0CC2F9 
                       F1 BF 0C   .dw DATA_0CBFF1 .db :$DATA_0CBFF1 
                       DD C5 0C   .dw DATA_0CC5DD .db :$DATA_0CC5DD 
                       A8 C5 0C   .dw DATA_0CC5A8 .db :$DATA_0CC5A8 
                       73 C5 0C   .dw DATA_0CC573 .db :$DATA_0CC573 
                       3E C5 0C   .dw DATA_0CC53E .db :$DATA_0CC53E 
                       09 C5 0C   .dw DATA_0CC509 .db :$DATA_0CC509 
                       D4 C4 0C   .dw DATA_0CC4D4 .db :$DATA_0CC4D4 
                       9F C4 0C   .dw DATA_0CC49F .db :$DATA_0CC49F 
                       85 C7 0C   .dw DATA_0CC785 .db :$DATA_0CC785 
                       50 C7 0C   .dw DATA_0CC750 .db :$DATA_0CC750 
                       1B C7 0C   .dw DATA_0CC71B .db :$DATA_0CC71B 
                       E6 C6 0C   .dw DATA_0CC6E6 .db :$DATA_0CC6E6 
                       B1 C6 0C   .dw DATA_0CC6B1 .db :$DATA_0CC6B1 
                       7C C6 0C   .dw DATA_0CC67C .db :$DATA_0CC67C 
                       47 C6 0C   .dw DATA_0CC647 .db :$DATA_0CC647 
                       12 C6 0C   .dw DATA_0CC612 .db :$DATA_0CC612 
                       2D C9 0C   .dw DATA_0CC92D .db :$DATA_0CC92D 
                       F8 C8 0C   .dw DATA_0CC8F8 .db :$DATA_0CC8F8 
                       C3 C8 0C   .dw DATA_0CC8C3 .db :$DATA_0CC8C3 
                       8E C8 0C   .dw DATA_0CC88E .db :$DATA_0CC88E 
                       59 C8 0C   .dw DATA_0CC859 .db :$DATA_0CC859 
                       24 C8 0C   .dw DATA_0CC824 .db :$DATA_0CC824 
                       EF C7 0C   .dw DATA_0CC7EF .db :$DATA_0CC7EF 
                       BA C7 0C   .dw DATA_0CC7BA .db :$DATA_0CC7BA 
                       56 BA 0C   .dw DATA_0CBA56 .db :$DATA_0CBA56 ; Cutscene border, cave ground 
                       B9 BB 0C   .dw DATA_0CBBB9 .db :$DATA_0CBBB9 
                       BF B9 0C   .dw DATA_0CB9BF .db :$DATA_0CB9BF 
                       80 93 0C   .dw DATA_0C9380 .db :$DATA_0C9380 
                       36 B6 0C   .dw DATA_0CB636 .db :$DATA_0CB636 ; Ending: THE END 
                       00 F3 0D   .dw DATA_0DF300 .db :$DATA_0DF300 ; Ending: Enemies: Lakitu 
                       2D F4 0D   .dw DATA_0DF42D .db :$DATA_0DF42D ; Ending: Enemies: Hammer Bro. 
                       72 F5 0D   .dw DATA_0DF572 .db :$DATA_0DF572 ; Ending: Enemies: Pokey 
                       6B F6 0D   .dw DATA_0DF66B .db :$DATA_0DF66B ; Ending: Enemies: Rex 
                       42 F7 0D   .dw DATA_0DF742 .db :$DATA_0DF742 ; Ending: Enemies: Dino-Rhino 
                       37 F8 0D   .dw DATA_0DF837 .db :$DATA_0DF837 ; Ending: Enemies: Blargg 
                       FA F8 0D   .dw DATA_0DF8FA .db :$DATA_0DF8FA ; Ending: Enemies: Urchin 
                       CD F9 0D   .dw DATA_0DF9CD .db :$DATA_0DF9CD ; Ending: Enemies: Boo 
                       98 FA 0D   .dw DATA_0DFA98 .db :$DATA_0DFA98 ; Ending: Enemies: Dry Bones 
                       73 FB 0D   .dw DATA_0DFB73 .db :$DATA_0DFB73 ; Ending: Enemies: Grinder 
                       58 FC 0D   .dw DATA_0DFC58 .db :$DATA_0DFC58 ; Ending: Enemies: Reznor 
                       D5 FC 0D   .dw DATA_0DFCD5 .db :$DATA_0DFCD5 ; Ending: Enemies: Mechakoopa 
                       5C FD 0D   .dw DATA_0DFD5C .db :$DATA_0DFD5C ; Ending: Enemies: Bowser 
                       02 BD 0C   .dw DATA_0CBD02 .db :$DATA_0CBD02 

LoadScrnImage:      A4 12         LDY $12                   ; 12 = Image loader 
CODE_0085D4:        B9 D0 84      LDA.W ImagePointers,Y     ; \  
CODE_0085D7:        85 00         STA $00                   ;  | 
CODE_0085D9:        B9 D1 84      LDA.W ImagePointers+1,Y   ;  |Load pointer 
CODE_0085DC:        85 01         STA $01                   ;  | 
CODE_0085DE:        B9 D2 84      LDA.W ImagePointers+2,Y   ;  | 
CODE_0085E1:        85 02         STA $02                   ; /  
CODE_0085E3:        20 1E 87      JSR.W CODE_00871E         
CODE_0085E6:        A5 12         LDA $12                   
CODE_0085E8:        D0 0D         BNE CODE_0085F7           
CODE_0085EA:        8F 7B 83 7F   STA.L $7F837B             
CODE_0085EE:        8F 7C 83 7F   STA.L $7F837C             
CODE_0085F2:        3A            DEC A                     
CODE_0085F3:        8F 7D 83 7F   STA.L $7F837D             
CODE_0085F7:        64 12         STZ $12                   ; Do not reload the same thing next frame 
Return0085F9:       60            RTS                       

CODE_0085FA:        20 7D 93      JSR.W TurnOffIO           
CODE_0085FD:        A9 FC         LDA.B #$FC                
CODE_0085FF:        85 00         STA $00                   
CODE_008601:        9C 15 21      STZ.W $2115               ; Set "VRAM Address Increment Value" to x00 ; VRAM Address Increment Value
CODE_008604:        9C 16 21      STZ.W $2116               ; Set "Address for VRAM Read/Write (Low Byte)" to x00 ; Address for VRAM Read/Write (Low Byte)
CODE_008607:        A9 50         LDA.B #$50                ; \ Set "Address for VRAM Read/Write (High Byte)" to x50 
CODE_008609:        8D 17 21      STA.W $2117               ; /  ; Address for VRAM Read/Write (High Byte)
CODE_00860C:        A2 06         LDX.B #$06                
CODE_00860E:        BD 49 86      LDA.W DATA_008649,X       
CODE_008611:        9D 10 43      STA.W $4310,X             
CODE_008614:        CA            DEX                       
CODE_008615:        10 F7         BPL CODE_00860E           
CODE_008617:        A0 02         LDY.B #$02                ; DMA something to VRAM, my guess is a tilemap... 
CODE_008619:        8C 0B 42      STY.W $420B               ; Regular DMA Channel Enable
CODE_00861C:        A9 38         LDA.B #$38                
CODE_00861E:        85 00         STA $00                   
CODE_008620:        A9 80         LDA.B #$80                
CODE_008622:        8D 15 21      STA.W $2115               ; VRAM Address Increment Value
CODE_008625:        9C 16 21      STZ.W $2116               ; \Change CRAM address ; Address for VRAM Read/Write (Low Byte)
CODE_008628:        A9 50         LDA.B #$50                ;  | 
CODE_00862A:        8D 17 21      STA.W $2117               ; / ; Address for VRAM Read/Write (High Byte)
CODE_00862D:        A2 06         LDX.B #$06                ; And Repeat the DMA 
CODE_00862F:        BD 49 86      LDA.W DATA_008649,X       
CODE_008632:        9D 10 43      STA.W $4310,X             
CODE_008635:        CA            DEX                       
CODE_008636:        10 F7         BPL CODE_00862F           
CODE_008638:        A9 19         LDA.B #$19                ; \but change desination address to $2119 
CODE_00863A:        8D 11 43      STA.W $4311               ; / ; B Address
CODE_00863D:        8C 0B 42      STY.W $420B               ; Start DMA ; Regular DMA Channel Enable
CODE_008640:        64 3F         STZ $3F                   ; $3B = 0 (not sure what $3B is) 
CODE_008642:        22 00 80 7F   JSL.L RAM_7F8000          ; and JSL to a RAM routine 
CODE_008646:        4C 49 84      JMP.W DoSomeSpriteDMA     ; Jump to the next part of this routine 


DATA_008649:                      .db $08,$18,$00,$00,$00,$00,$10

ControllerUpdate:   AD 18 42      LDA.W $4218               ; \  ; Joypad 1Data (Low Byte)
CODE_008653:        29 F0         AND.B #$F0                ;  | 
CODE_008655:        8D A4 0D      STA.W $0DA4               ;  | 
CODE_008658:        A8            TAY                       ;  | 
CODE_008659:        4D AC 0D      EOR.W $0DAC               ;  | 
CODE_00865C:        2D A4 0D      AND.W $0DA4               ;  | 
CODE_00865F:        8D A8 0D      STA.W $0DA8               ;  | 
CODE_008662:        8C AC 0D      STY.W $0DAC               ;  | 
CODE_008665:        AD 19 42      LDA.W $4219               ;  | ; Joypad 1Data (High Byte)
CODE_008668:        8D A2 0D      STA.W $0DA2               ;  | 
CODE_00866B:        A8            TAY                       ;  | 
CODE_00866C:        4D AA 0D      EOR.W $0DAA               ;  | 
CODE_00866F:        2D A2 0D      AND.W $0DA2               ;  | 
CODE_008672:        8D A6 0D      STA.W RAM_OWControllerA   ;  | 
CODE_008675:        8C AA 0D      STY.W $0DAA               ;  |Read controller data 
CODE_008678:        AD 1A 42      LDA.W $421A               ;  | ; Joypad 2Data (Low Byte)
CODE_00867B:        29 F0         AND.B #$F0                ;  | 
CODE_00867D:        8D A5 0D      STA.W $0DA5               ;  | 
CODE_008680:        A8            TAY                       ;  | 
CODE_008681:        4D AD 0D      EOR.W $0DAD               ;  | 
CODE_008684:        2D A5 0D      AND.W $0DA5               ;  | 
CODE_008687:        8D A9 0D      STA.W $0DA9               ;  | 
CODE_00868A:        8C AD 0D      STY.W $0DAD               ;  | 
CODE_00868D:        AD 1B 42      LDA.W $421B               ;  | ; Joypad 2Data (High Byte)
CODE_008690:        8D A3 0D      STA.W $0DA3               ;  | 
CODE_008693:        A8            TAY                       ;  | 
CODE_008694:        4D AB 0D      EOR.W $0DAB               ;  | 
CODE_008697:        2D A3 0D      AND.W $0DA3               ;  | 
CODE_00869A:        8D A7 0D      STA.W $0DA7               ;  | 
CODE_00869D:        8C AB 0D      STY.W $0DAB               ; /  
CODE_0086A0:        AE A0 0D      LDX.W $0DA0               ; \  
CODE_0086A3:        10 03         BPL CODE_0086A8           ;  |If $0DA0 is positive, set X to $0DA0 
ADDR_0086A5:        AE B3 0D      LDX.W $0DB3               ;  |Otherwise, set X to current character 
CODE_0086A8:        BD A4 0D      LDA.W $0DA4,X             ; \  
CODE_0086AB:        29 C0         AND.B #$C0                ;  | 
CODE_0086AD:        1D A2 0D      ORA.W $0DA2,X             ;  | 
CODE_0086B0:        85 15         STA RAM_ControllerA       ;  | 
CODE_0086B2:        BD A4 0D      LDA.W $0DA4,X             ;  | 
CODE_0086B5:        85 17         STA RAM_ControllerB       ;  |Update controller data bytes 
CODE_0086B7:        BD A8 0D      LDA.W $0DA8,X             ;  | 
CODE_0086BA:        29 40         AND.B #$40                ;  | 
CODE_0086BC:        1D A6 0D      ORA.W RAM_OWControllerA,X ;  | 
CODE_0086BF:        85 16         STA $16                   ;  | 
CODE_0086C1:        BD A8 0D      LDA.W $0DA8,X             ;  | 
CODE_0086C4:        85 18         STA $18                   ; /  
Return0086C6:       60            RTS                       ; Return 

CODE_0086C7:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_0086C9:        A2 62 00      LDX.W #$0062              
CODE_0086CC:        A9 02 02      LDA.W #$0202              
CODE_0086CF:        9D 20 04      STA.W $0420,X             
CODE_0086D2:        CA            DEX                       
CODE_0086D3:        CA            DEX                       
CODE_0086D4:        10 F9         BPL CODE_0086CF           
CODE_0086D6:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_0086D8:        A9 F0         LDA.B #$F0                
CODE_0086DA:        22 2E 81 7F   JSL.L RAM_7F812E          
Return0086DE:       60            RTS                       

ExecutePtr:         84 03         STY $03                   ; "Push" Y 
CODE_0086E1:        7A            PLY                       
CODE_0086E2:        84 00         STY $00                   
CODE_0086E4:        C2 30         REP #$30                  ; 16 bit A ; Index (16 bit) Accum (16 bit) 
CODE_0086E6:        29 FF 00      AND.W #$00FF              ; A = Game mode 
CODE_0086E9:        0A            ASL                       ; Multiply game mode by 2 
CODE_0086EA:        A8            TAY                       
CODE_0086EB:        68            PLA                       
CODE_0086EC:        85 01         STA $01                   
CODE_0086EE:        C8            INY                       
CODE_0086EF:        B7 00         LDA [$00],Y               
CODE_0086F1:        85 00         STA $00                   ; A is 16-bit 
CODE_0086F3:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_0086F5:        A4 03         LDY $03                   ; "Pull" Y 
CODE_0086F7:        DC 00 00      JMP [$0000]               ; Jump to the game mode's routine, which has been loaded into $00-02 

ExecutePtrLong:     84 05         STY $05                   
CODE_0086FC:        7A            PLY                       
CODE_0086FD:        84 02         STY $02                   
CODE_0086FF:        C2 30         REP #$30                  ; 16 bit A,X,Y ; Index (16 bit) Accum (16 bit) 
CODE_008701:        29 FF 00      AND.W #$00FF              ; \ A = Tileset/byte 3 (TB3) 
CODE_008704:        85 03         STA $03                   ; / Store A in $03 
CODE_008706:        0A            ASL                       ; \ Multiply A by 2 
CODE_008707:        65 03         ADC $03                   ;  |Add TB3 to A 
CODE_008709:        A8            TAY                       ; / Set Y to A 
CODE_00870A:        68            PLA                       
CODE_00870B:        85 03         STA $03                   
CODE_00870D:        C8            INY                       
CODE_00870E:        B7 02         LDA [$02],Y               
CODE_008710:        85 00         STA $00                   
CODE_008712:        C8            INY                       
CODE_008713:        B7 02         LDA [$02],Y               
CODE_008715:        85 01         STA $01                   
CODE_008717:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_008719:        A4 05         LDY $05                   
CODE_00871B:        DC 00 00      JMP [$0000]               

CODE_00871E:        C2 10         REP #$10                  ; 16 bit X,Y ; Index (16 bit) 
CODE_008720:        8D 14 43      STA.W $4314               ; A Address Bank
CODE_008723:        A0 00 00      LDY.W #$0000              ; Set index to 0 
CODE_008726:        B7 00         LDA [$00],Y               ; \ Read line header byte 1 
CODE_008728:        10 03         BPL CODE_00872D           ;  |If the byte & %10000000 is true, 
CODE_00872A:        E2 30         SEP #$30                  ;  |Set A,X,Y to 8 bit and return ; Index (8 bit) Accum (8 bit) 
Return00872C:       60            RTS                       ;  | 

CODE_00872D:        85 04         STA $04                   ; Store byte in $04 ; Index (16 bit) 
CODE_00872F:        C8            INY                       ; Move onto the next byte 
CODE_008730:        B7 00         LDA [$00],Y               ; Read line header byte 2 
CODE_008732:        85 03         STA $03                   ; Store byte in $03 
CODE_008734:        C8            INY                       ; Move onto the next byte 
CODE_008735:        B7 00         LDA [$00],Y               ; Read line header byte 3 
CODE_008737:        64 07         STZ $07                   ; \  
CODE_008739:        0A            ASL                       ;  |Store direction bit in $07 
CODE_00873A:        26 07         ROL $07                   ; /  
CODE_00873C:        A9 18         LDA.B #$18                ; \ Set B address (DMA) to x18 
CODE_00873E:        8D 11 43      STA.W $4311               ; /  ; B Address
CODE_008741:        B7 00         LDA [$00],Y               ; Re-read line header byte 3 
CODE_008743:        29 40         AND.B #$40                ; \  
CODE_008745:        4A            LSR                       ;  | 
CODE_008746:        4A            LSR                       ;  |Store RLE bit << 3 in $05 
CODE_008747:        4A            LSR                       ;  | 
CODE_008748:        85 05         STA $05                   ; /  
CODE_00874A:        64 06         STZ $06                   
CODE_00874C:        09 01         ORA.B #$01                
CODE_00874E:        8D 10 43      STA.W $4310               ; Parameters for DMA Transfer
CODE_008751:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_008753:        A5 03         LDA $03                   
CODE_008755:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_008758:        B7 00         LDA [$00],Y               
CODE_00875A:        EB            XBA                       
CODE_00875B:        29 FF 3F      AND.W #$3FFF              
CODE_00875E:        AA            TAX                       
CODE_00875F:        E8            INX                       
CODE_008760:        C8            INY                       
CODE_008761:        C8            INY                       
CODE_008762:        98            TYA                       
CODE_008763:        18            CLC                       
CODE_008764:        65 00         ADC $00                   
CODE_008766:        8D 12 43      STA.W $4312               ; A Address (Low Byte)
CODE_008769:        8E 15 43      STX.W $4315               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00876C:        A5 05         LDA $05                   
CODE_00876E:        F0 25         BEQ CODE_008795           
CODE_008770:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_008772:        A5 07         LDA $07                   
CODE_008774:        8D 15 21      STA.W $2115               ; VRAM Address Increment Value
CODE_008777:        A9 02         LDA.B #$02                
CODE_008779:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_00877C:        A9 19         LDA.B #$19                
CODE_00877E:        8D 11 43      STA.W $4311               ; B Address
CODE_008781:        C2 21         REP #$21                  ; Accum (16 bit) 
CODE_008783:        A5 03         LDA $03                   
CODE_008785:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_008788:        98            TYA                       
CODE_008789:        65 00         ADC $00                   
CODE_00878B:        1A            INC A                     
CODE_00878C:        8D 12 43      STA.W $4312               ; A Address (Low Byte)
CODE_00878F:        8E 15 43      STX.W $4315               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_008792:        A2 02 00      LDX.W #$0002              
CODE_008795:        86 03         STX $03                   
CODE_008797:        98            TYA                       
CODE_008798:        18            CLC                       
CODE_008799:        65 03         ADC $03                   
CODE_00879B:        A8            TAY                       
CODE_00879C:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00879E:        A5 07         LDA $07                   
CODE_0087A0:        09 80         ORA.B #$80                
CODE_0087A2:        8D 15 21      STA.W $2115               ; VRAM Address Increment Value
CODE_0087A5:        A9 02         LDA.B #$02                
CODE_0087A7:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_0087AA:        4C 26 87      JMP.W CODE_008726         

CODE_0087AD:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_0087AF:        AD E4 1B      LDA.W $1BE4               ; \  
CODE_0087B2:        D0 03         BNE CODE_0087B7           ;  |If Layer 1 has to be updated, 
CODE_0087B4:        4C DD 88      JMP.W CODE_0088DD         ;  |jump to $88DD 

CODE_0087B7:        A5 5B         LDA RAM_IsVerticalLvl     ; \  
CODE_0087B9:        29 01         AND.B #$01                ;  | 
CODE_0087BB:        F0 03         BEQ CODE_0087C0           ;  |If on a vertical level, 
CODE_0087BD:        4C 49 88      JMP.W CODE_008849         ;  |jump to $8849 

CODE_0087C0:        A0 81         LDY.B #$81                ; \ Set "VRAM Address Increment Value" to x81 
CODE_0087C2:        8C 15 21      STY.W $2115               ; /  ; VRAM Address Increment Value
CODE_0087C5:        AD E5 1B      LDA.W $1BE5               
CODE_0087C8:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_0087CB:        AD E4 1B      LDA.W $1BE4               
CODE_0087CE:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_0087D1:        A2 06         LDX.B #$06                
CODE_0087D3:        BD 16 8A      LDA.W DATA_008A16,X       
CODE_0087D6:        9D 10 43      STA.W $4310,X             
CODE_0087D9:        CA            DEX                       
CODE_0087DA:        10 F7         BPL CODE_0087D3           
CODE_0087DC:        A9 02         LDA.B #$02                ; \ Enable DMA channel 1 
CODE_0087DE:        8D 0B 42      STA.W $420B               ; /  ; Regular DMA Channel Enable
CODE_0087E1:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_0087E4:        AD E5 1B      LDA.W $1BE5               
CODE_0087E7:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_0087EA:        AD E4 1B      LDA.W $1BE4               
CODE_0087ED:        18            CLC                       
CODE_0087EE:        69 08         ADC.B #$08                
CODE_0087F0:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_0087F3:        A2 06         LDX.B #$06                
CODE_0087F5:        BD 1D 8A      LDA.W DATA_008A1D,X       
CODE_0087F8:        9D 10 43      STA.W $4310,X             
CODE_0087FB:        CA            DEX                       
CODE_0087FC:        10 F7         BPL CODE_0087F5           
CODE_0087FE:        A9 02         LDA.B #$02                
CODE_008800:        8D 0B 42      STA.W $420B               ; \ Enable DMA channel 1 ; Regular DMA Channel Enable
CODE_008803:        8C 15 21      STY.W $2115               ; /  ; VRAM Address Increment Value
CODE_008806:        AD E5 1B      LDA.W $1BE5               
CODE_008809:        1A            INC A                     
CODE_00880A:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00880D:        AD E4 1B      LDA.W $1BE4               
CODE_008810:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_008813:        A2 06         LDX.B #$06                
CODE_008815:        BD 24 8A      LDA.W DATA_008A24,X       
CODE_008818:        9D 10 43      STA.W $4310,X             
CODE_00881B:        CA            DEX                       
CODE_00881C:        10 F7         BPL CODE_008815           
CODE_00881E:        A9 02         LDA.B #$02                ; \ Enable DMA channel 1 
CODE_008820:        8D 0B 42      STA.W $420B               ; /  ; Regular DMA Channel Enable
CODE_008823:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_008826:        AD E5 1B      LDA.W $1BE5               
CODE_008829:        1A            INC A                     
CODE_00882A:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00882D:        AD E4 1B      LDA.W $1BE4               
CODE_008830:        18            CLC                       
CODE_008831:        69 08         ADC.B #$08                
CODE_008833:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_008836:        A2 06         LDX.B #$06                
CODE_008838:        BD 2B 8A      LDA.W DATA_008A2B,X       
CODE_00883B:        9D 10 43      STA.W $4310,X             
CODE_00883E:        CA            DEX                       
CODE_00883F:        10 F7         BPL CODE_008838           
CODE_008841:        A9 02         LDA.B #$02                ; \ Enable DMA channel 1 
CODE_008843:        8D 0B 42      STA.W $420B               ; /  ; Regular DMA Channel Enable
CODE_008846:        4C DD 88      JMP.W CODE_0088DD         

CODE_008849:        A0 80         LDY.B #$80                
CODE_00884B:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_00884E:        AD E5 1B      LDA.W $1BE5               
CODE_008851:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_008854:        AD E4 1B      LDA.W $1BE4               
CODE_008857:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_00885A:        A2 06         LDX.B #$06                
CODE_00885C:        BD 16 8A      LDA.W DATA_008A16,X       
CODE_00885F:        9D 10 43      STA.W $4310,X             
CODE_008862:        CA            DEX                       
CODE_008863:        10 F7         BPL CODE_00885C           
CODE_008865:        A9 02         LDA.B #$02                
CODE_008867:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_00886A:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_00886D:        AD E5 1B      LDA.W $1BE5               
CODE_008870:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_008873:        AD E4 1B      LDA.W $1BE4               
CODE_008876:        18            CLC                       
CODE_008877:        69 04         ADC.B #$04                
CODE_008879:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_00887C:        A2 06         LDX.B #$06                
CODE_00887E:        BD 1D 8A      LDA.W DATA_008A1D,X       
CODE_008881:        9D 10 43      STA.W $4310,X             
CODE_008884:        CA            DEX                       
CODE_008885:        10 F7         BPL CODE_00887E           
CODE_008887:        A9 40         LDA.B #$40                
CODE_008889:        8D 15 43      STA.W $4315               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00888C:        A9 02         LDA.B #$02                
CODE_00888E:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_008891:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_008894:        AD E5 1B      LDA.W $1BE5               
CODE_008897:        18            CLC                       
CODE_008898:        69 20         ADC.B #$20                
CODE_00889A:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00889D:        AD E4 1B      LDA.W $1BE4               
CODE_0088A0:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_0088A3:        A2 06         LDX.B #$06                
CODE_0088A5:        BD 24 8A      LDA.W DATA_008A24,X       
CODE_0088A8:        9D 10 43      STA.W $4310,X             
CODE_0088AB:        CA            DEX                       
CODE_0088AC:        10 F7         BPL CODE_0088A5           
CODE_0088AE:        A9 02         LDA.B #$02                
CODE_0088B0:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_0088B3:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_0088B6:        AD E5 1B      LDA.W $1BE5               
CODE_0088B9:        18            CLC                       
CODE_0088BA:        69 20         ADC.B #$20                
CODE_0088BC:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_0088BF:        AD E4 1B      LDA.W $1BE4               
CODE_0088C2:        18            CLC                       
CODE_0088C3:        69 04         ADC.B #$04                
CODE_0088C5:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_0088C8:        A2 06         LDX.B #$06                
CODE_0088CA:        BD 2B 8A      LDA.W DATA_008A2B,X       
CODE_0088CD:        9D 10 43      STA.W $4310,X             
CODE_0088D0:        CA            DEX                       
CODE_0088D1:        10 F7         BPL CODE_0088CA           
CODE_0088D3:        A9 40         LDA.B #$40                
CODE_0088D5:        8D 15 43      STA.W $4315               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_0088D8:        A9 02         LDA.B #$02                
CODE_0088DA:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_0088DD:        A9 00         LDA.B #$00                
CODE_0088DF:        8D E4 1B      STA.W $1BE4               
CODE_0088E2:        AD E6 1C      LDA.W $1CE6               
CODE_0088E5:        D0 03         BNE CODE_0088EA           
CODE_0088E7:        4C 10 8A      JMP.W CODE_008A10         

CODE_0088EA:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_0088EC:        29 02         AND.B #$02                
CODE_0088EE:        F0 03         BEQ CODE_0088F3           
CODE_0088F0:        4C 7C 89      JMP.W CODE_00897C         

CODE_0088F3:        A0 81         LDY.B #$81                
CODE_0088F5:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_0088F8:        AD E7 1C      LDA.W $1CE7               
CODE_0088FB:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_0088FE:        AD E6 1C      LDA.W $1CE6               
CODE_008901:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_008904:        A2 06         LDX.B #$06                
CODE_008906:        BD 32 8A      LDA.W DATA_008A32,X       
CODE_008909:        9D 10 43      STA.W $4310,X             
CODE_00890C:        CA            DEX                       
CODE_00890D:        10 F7         BPL CODE_008906           
CODE_00890F:        A9 02         LDA.B #$02                
CODE_008911:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_008914:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_008917:        AD E7 1C      LDA.W $1CE7               
CODE_00891A:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00891D:        AD E6 1C      LDA.W $1CE6               
CODE_008920:        18            CLC                       
CODE_008921:        69 08         ADC.B #$08                
CODE_008923:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_008926:        A2 06         LDX.B #$06                
CODE_008928:        BD 39 8A      LDA.W DATA_008A39,X       
CODE_00892B:        9D 10 43      STA.W $4310,X             
CODE_00892E:        CA            DEX                       
CODE_00892F:        10 F7         BPL CODE_008928           
CODE_008931:        A9 02         LDA.B #$02                
CODE_008933:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_008936:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_008939:        AD E7 1C      LDA.W $1CE7               
CODE_00893C:        1A            INC A                     
CODE_00893D:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_008940:        AD E6 1C      LDA.W $1CE6               
CODE_008943:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_008946:        A2 06         LDX.B #$06                
CODE_008948:        BD 40 8A      LDA.W DATA_008A40,X       
CODE_00894B:        9D 10 43      STA.W $4310,X             
CODE_00894E:        CA            DEX                       
CODE_00894F:        10 F7         BPL CODE_008948           
CODE_008951:        A9 02         LDA.B #$02                
CODE_008953:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_008956:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_008959:        AD E7 1C      LDA.W $1CE7               
CODE_00895C:        1A            INC A                     
CODE_00895D:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_008960:        AD E6 1C      LDA.W $1CE6               
CODE_008963:        18            CLC                       
CODE_008964:        69 08         ADC.B #$08                
CODE_008966:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_008969:        A2 06         LDX.B #$06                
CODE_00896B:        BD 47 8A      LDA.W DATA_008A47,X       
CODE_00896E:        9D 10 43      STA.W $4310,X             
CODE_008971:        CA            DEX                       
CODE_008972:        10 F7         BPL CODE_00896B           
CODE_008974:        A9 02         LDA.B #$02                
CODE_008976:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_008979:        4C 10 8A      JMP.W CODE_008A10         

CODE_00897C:        A0 80         LDY.B #$80                
CODE_00897E:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_008981:        AD E7 1C      LDA.W $1CE7               
CODE_008984:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_008987:        AD E6 1C      LDA.W $1CE6               
CODE_00898A:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_00898D:        A2 06         LDX.B #$06                
CODE_00898F:        BD 32 8A      LDA.W DATA_008A32,X       
CODE_008992:        9D 10 43      STA.W $4310,X             
CODE_008995:        CA            DEX                       
CODE_008996:        10 F7         BPL CODE_00898F           
CODE_008998:        A9 02         LDA.B #$02                
CODE_00899A:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_00899D:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_0089A0:        AD E7 1C      LDA.W $1CE7               
CODE_0089A3:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_0089A6:        AD E6 1C      LDA.W $1CE6               
CODE_0089A9:        18            CLC                       
CODE_0089AA:        69 04         ADC.B #$04                
CODE_0089AC:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_0089AF:        A2 06         LDX.B #$06                
CODE_0089B1:        BD 39 8A      LDA.W DATA_008A39,X       
CODE_0089B4:        9D 10 43      STA.W $4310,X             
CODE_0089B7:        CA            DEX                       
CODE_0089B8:        10 F7         BPL CODE_0089B1           
CODE_0089BA:        A9 40         LDA.B #$40                
CODE_0089BC:        8D 15 43      STA.W $4315               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_0089BF:        A9 02         LDA.B #$02                
CODE_0089C1:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_0089C4:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_0089C7:        AD E7 1C      LDA.W $1CE7               
CODE_0089CA:        18            CLC                       
CODE_0089CB:        69 20         ADC.B #$20                
CODE_0089CD:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_0089D0:        AD E6 1C      LDA.W $1CE6               
CODE_0089D3:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_0089D6:        A2 06         LDX.B #$06                
CODE_0089D8:        BD 40 8A      LDA.W DATA_008A40,X       
CODE_0089DB:        9D 10 43      STA.W $4310,X             
CODE_0089DE:        CA            DEX                       
CODE_0089DF:        10 F7         BPL CODE_0089D8           
CODE_0089E1:        A9 02         LDA.B #$02                
CODE_0089E3:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_0089E6:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_0089E9:        AD E7 1C      LDA.W $1CE7               
CODE_0089EC:        18            CLC                       
CODE_0089ED:        69 20         ADC.B #$20                
CODE_0089EF:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_0089F2:        AD E6 1C      LDA.W $1CE6               
CODE_0089F5:        18            CLC                       
CODE_0089F6:        69 04         ADC.B #$04                
CODE_0089F8:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_0089FB:        A2 06         LDX.B #$06                
CODE_0089FD:        BD 47 8A      LDA.W DATA_008A47,X       
CODE_008A00:        9D 10 43      STA.W $4310,X             
CODE_008A03:        CA            DEX                       
CODE_008A04:        10 F7         BPL CODE_0089FD           
CODE_008A06:        A9 40         LDA.B #$40                
CODE_008A08:        8D 15 43      STA.W $4315               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_008A0B:        A9 02         LDA.B #$02                
CODE_008A0D:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_008A10:        A9 00         LDA.B #$00                
CODE_008A12:        8D E6 1C      STA.W $1CE6               
Return008A15:       6B            RTL                       


DATA_008A16:                      .db $01,$18,$E6,$1B,$00,$40,$00

DATA_008A1D:                      .db $01,$18,$26,$1C,$00,$2C,$00

DATA_008A24:                      .db $01,$18,$66,$1C,$00,$40,$00

DATA_008A2B:                      .db $01,$18,$A6,$1C,$00,$2C,$00

DATA_008A32:                      .db $01,$18,$E8,$1C,$00,$40,$00

DATA_008A39:                      .db $01,$18,$28,$1D,$00,$2C,$00

DATA_008A40:                      .db $01,$18,$68,$1D,$00,$40,$00

DATA_008A47:                      .db $01,$18,$A8,$1D,$00,$2C,$00

ClearStack:         C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_008A50:        A2 FE 1F      LDX.W #$1FFE              
CODE_008A53:        74 00         STZ $00,X                 
CODE_008A55:        CA            DEX                       
CODE_008A56:        CA            DEX                       
CODE_008A57:        E0 FF 01      CPX.W #$01FF              
CODE_008A5A:        10 05         BPL CODE_008A61           
CODE_008A5C:        E0 00 01      CPX.W #$0100              
CODE_008A5F:        10 F4         BPL CODE_008A55           
CODE_008A61:        E0 FE FF      CPX.W #$FFFE              
CODE_008A64:        D0 ED         BNE CODE_008A53           
CODE_008A66:        A9 00 00      LDA.W #$0000              
CODE_008A69:        8F 7B 83 7F   STA.L $7F837B             
CODE_008A6D:        9C 81 06      STZ.W $0681               
CODE_008A70:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_008A72:        A9 FF         LDA.B #$FF                
CODE_008A74:        8F 7D 83 7F   STA.L $7F837D             
Return008A78:       60            RTS                       

SetUpScreen:        9C 33 21      STZ.W $2133               ; Set "Screen Initial Settings" to x00 ; Screen Initial Settings
CODE_008A7C:        9C 06 21      STZ.W $2106               ; Turn off mosaic ; Mosaic Size and BG Enable
CODE_008A7F:        A9 23         LDA.B #$23                
CODE_008A81:        8D 07 21      STA.W $2107               ; BG 1 Address and Size
CODE_008A84:        A9 33         LDA.B #$33                
CODE_008A86:        8D 08 21      STA.W $2108               ; ; BG 2 Address and Size
CODE_008A89:        A9 53         LDA.B #$53                
CODE_008A8B:        8D 09 21      STA.W $2109               ; BG 3 Address and Size
CODE_008A8E:        A9 00         LDA.B #$00                
CODE_008A90:        8D 0B 21      STA.W $210B               ; BG 1 & 2 Tile Data Designation
CODE_008A93:        A9 04         LDA.B #$04                
CODE_008A95:        8D 0C 21      STA.W $210C               ; BG 3 & 4 Tile Data Designation
CODE_008A98:        64 41         STZ $41                   
CODE_008A9A:        64 42         STZ $42                   
CODE_008A9C:        64 43         STZ $43                   
CODE_008A9E:        9C 2A 21      STZ.W $212A               ; BG 1, 2, 3 and 4 Window Logic Settings
CODE_008AA1:        9C 2B 21      STZ.W $212B               ; Color and OBJ Window Logic Settings
CODE_008AA4:        9C 2E 21      STZ.W $212E               ; Window Mask Designation for Main Screen
CODE_008AA7:        9C 2F 21      STZ.W $212F               ; Window Mask Designation for Sub Screen
CODE_008AAA:        A9 02         LDA.B #$02                
CODE_008AAC:        85 44         STA $44                   
CODE_008AAE:        A9 80         LDA.B #$80                ; \ Set Mode7 "Screen Over" to %10000000, disable Mode7 flipping 
CODE_008AB0:        8D 1A 21      STA.W $211A               ; /  ; Initial Setting for Mode 7
Return008AB3:       60            RTS                       ; Return 


DATA_008AB4:                      .db $00,$00,$FE,$00,$00,$00,$FE,$00
DATA_008ABC:                      .db $00,$00,$02,$00,$00,$00,$02,$00
                                  .db $00,$00,$00,$01,$FF,$FF,$00,$10
                                  .db $F0

CODE_008ACD:        A5 39         LDA $39                   
CODE_008ACF:        85 00         STA $00                   
CODE_008AD1:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_008AD3:        20 E8 8A      JSR.W CODE_008AE8         
CODE_008AD6:        A5 38         LDA $38                   
CODE_008AD8:        85 00         STA $00                   
CODE_008ADA:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_008ADC:        A5 2E         LDA $2E                   
CODE_008ADE:        85 34         STA $34                   
CODE_008AE0:        A5 30         LDA $30                   
CODE_008AE2:        49 FF FF      EOR.W #$FFFF              
CODE_008AE5:        1A            INC A                     
CODE_008AE6:        85 32         STA $32                   
CODE_008AE8:        A5 36         LDA $36                   
CODE_008AEA:        0A            ASL                       
CODE_008AEB:        48            PHA                       
CODE_008AEC:        EB            XBA                       
CODE_008AED:        29 03 00      AND.W #$0003              
CODE_008AF0:        0A            ASL                       
CODE_008AF1:        A8            TAY                       
CODE_008AF2:        68            PLA                       
CODE_008AF3:        29 FE 00      AND.W #$00FE              
CODE_008AF6:        59 B4 8A      EOR.W DATA_008AB4,Y       
CODE_008AF9:        18            CLC                       
CODE_008AFA:        79 BC 8A      ADC.W DATA_008ABC,Y       
CODE_008AFD:        AA            TAX                       
CODE_008AFE:        20 2B 8B      JSR.W CODE_008B2B         
CODE_008B01:        C0 04 00      CPY.W #$0004              
CODE_008B04:        90 04         BCC CODE_008B0A           
CODE_008B06:        49 FF FF      EOR.W #$FFFF              
CODE_008B09:        1A            INC A                     
CODE_008B0A:        85 30         STA $30                   
CODE_008B0C:        8A            TXA                       
CODE_008B0D:        49 FE 00      EOR.W #$00FE              
CODE_008B10:        18            CLC                       
CODE_008B11:        69 02 00      ADC.W #$0002              
CODE_008B14:        29 FF 01      AND.W #$01FF              
CODE_008B17:        AA            TAX                       
CODE_008B18:        20 2B 8B      JSR.W CODE_008B2B         
CODE_008B1B:        88            DEY                       
CODE_008B1C:        88            DEY                       
CODE_008B1D:        C0 04 00      CPY.W #$0004              
CODE_008B20:        B0 04         BCS CODE_008B26           
CODE_008B22:        49 FF FF      EOR.W #$FFFF              
CODE_008B25:        1A            INC A                     
CODE_008B26:        85 2E         STA $2E                   
CODE_008B28:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return008B2A:       60            RTS                       

CODE_008B2B:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_008B2D:        BD 58 8B      LDA.W DATA_008B58,X       
CODE_008B30:        F0 02         BEQ CODE_008B34           
CODE_008B32:        A5 00         LDA $00                   
CODE_008B34:        85 01         STA $01                   
CODE_008B36:        BD 57 8B      LDA.W DATA_008B57,X       
CODE_008B39:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_008B3C:        A5 00         LDA $00                   
CODE_008B3E:        8D 03 42      STA.W $4203               ; Multplier B
CODE_008B41:        EA            NOP                       
CODE_008B42:        EA            NOP                       
CODE_008B43:        EA            NOP                       
CODE_008B44:        EA            NOP                       
CODE_008B45:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_008B48:        18            CLC                       
CODE_008B49:        65 01         ADC $01                   
CODE_008B4B:        EB            XBA                       
CODE_008B4C:        AD 16 42      LDA.W $4216               ; Product/Remainder Result (Low Byte)
CODE_008B4F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_008B51:        4A            LSR                       
CODE_008B52:        4A            LSR                       
CODE_008B53:        4A            LSR                       
CODE_008B54:        4A            LSR                       
CODE_008B55:        4A            LSR                       
Return008B56:       60            RTS                       


DATA_008B57:                      .db $00

DATA_008B58:                      .db $00,$03,$00,$06,$00,$09,$00,$0C
                                  .db $00,$0F,$00,$12,$00,$15,$00,$19
                                  .db $00,$1C,$00,$1F,$00,$22,$00,$25
                                  .db $00,$28,$00,$2B,$00,$2E,$00,$31
                                  .db $00,$35,$00,$38,$00,$3B,$00,$3E
                                  .db $00,$41,$00,$44,$00,$47,$00,$4A
                                  .db $00,$4D,$00,$50,$00,$53,$00,$56
                                  .db $00,$59,$00,$5C,$00,$5F,$00,$61
                                  .db $00,$64,$00,$67,$00,$6A,$00,$6D
                                  .db $00,$70,$00,$73,$00,$75,$00,$78
                                  .db $00,$7B,$00,$7E,$00,$80,$00,$83
                                  .db $00,$86,$00,$88,$00,$8B,$00,$8E
                                  .db $00,$90,$00,$93,$00,$95,$00,$98
                                  .db $00,$9B,$00,$9D,$00,$9F,$00,$A2
                                  .db $00,$A4,$00,$A7,$00,$A9,$00,$AB
                                  .db $00,$AE,$00,$B0,$00,$B2,$00,$B5
                                  .db $00,$B7,$00,$B9,$00,$BB,$00,$BD
                                  .db $00,$BF,$00,$C1,$00,$C3,$00,$C5
                                  .db $00,$C7,$00,$C9,$00,$CB,$00,$CD
                                  .db $00,$CF,$00,$D1,$00,$D3,$00,$D4
                                  .db $00,$D6,$00,$D8,$00,$D9,$00,$DB
                                  .db $00,$DD,$00,$DE,$00,$E0,$00,$E1
                                  .db $00,$E3,$00,$E4,$00,$E6,$00,$E7
                                  .db $00,$E8,$00,$EA,$00,$EB,$00,$EC
                                  .db $00,$ED,$00,$EE,$00,$EF,$00,$F1
                                  .db $00,$F2,$00,$F3,$00,$F4,$00,$F4
                                  .db $00,$F5,$00,$F6,$00,$F7,$00,$F8
                                  .db $00,$F9,$00,$F9,$00,$FA,$00,$FB
                                  .db $00,$FB,$00,$FC,$00,$FC,$00,$FD
                                  .db $00,$FD,$00,$FE,$00,$FE,$00,$FE
                                  .db $00,$FF,$00,$FF,$00,$FF,$00,$FF
                                  .db $00,$FF,$00,$FF,$00,$FF,$00,$00
                                  .db $01,$B7,$3C,$B7,$BC,$B8,$3C,$B9
                                  .db $3C,$BA,$3C,$BB,$3C,$BA,$3C,$BA
                                  .db $BC,$BC,$3C,$BD,$3C,$BE,$3C,$BF
                                  .db $3C,$C0,$3C,$B7,$BC,$C1,$3C,$B9
                                  .db $3C,$C2,$3C,$C2,$BC,$B7,$3C,$C0
                                  .db $FC,$3A,$38,$3B,$38,$3B,$38,$3A
                                  .db $78

DATA_008C89:                      .db $30,$28,$31,$28,$32,$28,$33,$28
                                  .db $34,$28,$FC,$38,$FC,$3C,$FC,$3C
                                  .db $FC,$3C,$FC,$3C,$FC,$38,$FC,$38
                                  .db $4A,$38,$FC,$38,$FC,$38,$4A,$78
                                  .db $FC,$38,$3D,$3C,$3E,$3C,$3F,$3C
                                  .db $FC,$38,$FC,$38,$FC,$38,$2E,$3C
                                  .db $26,$38,$FC,$38,$FC,$38,$00,$38
                                  .db $26,$38,$FC,$38,$00,$38,$FC,$38
                                  .db $FC,$38,$FC,$38,$64,$28,$26,$38
                                  .db $FC,$38,$FC,$38,$FC,$38,$4A,$38
                                  .db $FC,$38,$FC,$38,$4A,$78,$FC,$38
                                  .db $FE,$3C,$FE,$3C,$00,$3C,$FC,$38
                                  .db $FC,$38,$FC,$38,$FC,$38,$FC,$38
                                  .db $FC,$38,$FC,$38,$00,$38,$3A,$B8
                                  .db $3B,$B8,$3B,$B8,$3A,$F8

GM04DoDMA:          A9 80         LDA.B #$80                ; More DMA ; Accum (8 bit) 
CODE_008D01:        8D 15 21      STA.W $2115               ; Increment when $2119 accessed ; VRAM Address Increment Value
CODE_008D04:        A9 2E         LDA.B #$2E                ; \VRAM address = #$502E 
CODE_008D06:        8D 16 21      STA.W $2116               ;  | ; Address for VRAM Read/Write (Low Byte)
CODE_008D09:        A9 50         LDA.B #$50                ;  | 
CODE_008D0B:        8D 17 21      STA.W $2117               ; / ; Address for VRAM Read/Write (High Byte)
CODE_008D0E:        A2 06         LDX.B #$06                
CODE_008D10:        BD 90 8D      LDA.W DATA_008D90,X       
CODE_008D13:        9D 10 43      STA.W $4310,X             ; Load up the DMA regs 
CODE_008D16:        CA            DEX                       ; DMA Source = 8C:8118 (...) 
CODE_008D17:        10 F7         BPL CODE_008D10           ; Dest = $2118, Transfer: #$08 bytes 
CODE_008D19:        A9 02         LDA.B #$02                
CODE_008D1B:        8D 0B 42      STA.W $420B               ; Do the DMA ; Regular DMA Channel Enable
CODE_008D1E:        A9 80         LDA.B #$80                ; \ Set VRAM mode = same as above 
CODE_008D20:        8D 15 21      STA.W $2115               ;  |Address = #$5042 ; VRAM Address Increment Value
CODE_008D23:        A9 42         LDA.B #$42                ;  | 
CODE_008D25:        8D 16 21      STA.W $2116               ;  | ; Address for VRAM Read/Write (Low Byte)
CODE_008D28:        A9 50         LDA.B #$50                ;  | 
CODE_008D2A:        8D 17 21      STA.W $2117               ; /  ; Address for VRAM Read/Write (High Byte)
CODE_008D2D:        A2 06         LDX.B #$06                ; \ Set up more DMA 
CODE_008D2F:        BD 97 8D      LDA.W DATA_008D97,X       ;  |Dest = $2100 
CODE_008D32:        9D 10 43      STA.W $4310,X             ;  |Fixed source address = $89:1801 (Lunar Address: 7E:1801) 
CODE_008D35:        CA            DEX                       ;  |#$808C bytes to transfer 
CODE_008D36:        10 F7         BPL CODE_008D2F           ; /Type = One reg write once 
CODE_008D38:        A9 02         LDA.B #$02                
CODE_008D3A:        8D 0B 42      STA.W $420B               ; Start DMA ; Regular DMA Channel Enable
CODE_008D3D:        A9 80         LDA.B #$80                ; \prep VRAM for another write 
CODE_008D3F:        8D 15 21      STA.W $2115               ;  | ; VRAM Address Increment Value
CODE_008D42:        A9 63         LDA.B #$63                ;  | 
CODE_008D44:        8D 16 21      STA.W $2116               ;  | ; Address for VRAM Read/Write (Low Byte)
CODE_008D47:        A9 50         LDA.B #$50                ;  | 
CODE_008D49:        8D 17 21      STA.W $2117               ; / ; Address for VRAM Read/Write (High Byte)
CODE_008D4C:        A2 06         LDX.B #$06                ; \ Load up DMA again 
CODE_008D4E:        BD 9E 8D      LDA.W DATA_008D9E,X       ;  |Dest = $2118 
CODE_008D51:        9D 10 43      STA.W $4310,X             ;  |Source Address = $39:8CC1 
CODE_008D54:        CA            DEX                       ;  |Size = #$0100 bytes 
CODE_008D55:        10 F7         BPL CODE_008D4E           ; /Type = Two reg write once 
CODE_008D57:        A9 02         LDA.B #$02                ; \Start Transfer 
CODE_008D59:        8D 0B 42      STA.W $420B               ; / ; Regular DMA Channel Enable
CODE_008D5C:        A9 80         LDA.B #$80                ; \ 
CODE_008D5E:        8D 15 21      STA.W $2115               ;  |Set up VRAM once more ; VRAM Address Increment Value
CODE_008D61:        A9 8E         LDA.B #$8E                ;  | 
CODE_008D63:        8D 16 21      STA.W $2116               ;  | ; Address for VRAM Read/Write (Low Byte)
CODE_008D66:        A9 50         LDA.B #$50                ;  | 
CODE_008D68:        8D 17 21      STA.W $2117               ; / ; Address for VRAM Read/Write (High Byte)
CODE_008D6B:        A2 06         LDX.B #$06                ; \Last DMA... 
CODE_008D6D:        BD A5 8D      LDA.W DATA_008DA5,X       ;  |Reg = $2118 Type = Two reg write once 
CODE_008D70:        9D 10 43      STA.W $4310,X             ;  |Source Address = $08:8CF7 
CODE_008D73:        CA            DEX                       ;  |Size = #$9C00 bytes (o_o) 
CODE_008D74:        10 F7         BPL CODE_008D6D           ; / 
CODE_008D76:        A9 02         LDA.B #$02                ; \Transfer 
CODE_008D78:        8D 0B 42      STA.W $420B               ; / ; Regular DMA Channel Enable
CODE_008D7B:        A2 36         LDX.B #$36                ; \Copy some data into RAM 
CODE_008D7D:        A0 6C         LDY.B #$6C                ;  | 
CODE_008D7F:        B9 89 8C      LDA.W DATA_008C89,Y       ;  | 
CODE_008D82:        9D F9 0E      STA.W $0EF9,X             ;  | 59
CODE_008D85:        88            DEY                       ;  | 
CODE_008D86:        88            DEY                       ;  | 
CODE_008D87:        CA            DEX                       ;  | 
CODE_008D88:        10 F5         BPL CODE_008D7F           ; / 
CODE_008D8A:        A9 28         LDA.B #$28                
CODE_008D8C:        8D 30 0F      STA.W $0F30               ; #$28 -> Timer frame counter 
Return008D8F:       60            RTS                       ; Return 


DATA_008D90:                      .db $01,$18,$81,$8C,$00,$08,$00

DATA_008D97:                      .db $01,$18,$89,$8C,$00,$38,$00

DATA_008D9E:                      .db $01,$18,$C1,$8C,$00,$36,$00

DATA_008DA5:                      .db $01,$18,$F7,$8C,$00,$08,$00

DrawStatusBar:      9C 15 21      STZ.W $2115               ; Set VRAM Address Increment Value to x00 ; VRAM Address Increment Value
CODE_008DAF:        A9 42         LDA.B #$42                ; \  
CODE_008DB1:        8D 16 21      STA.W $2116               ;  |Set Address for VRAM Read/Write to x5042 ; Address for VRAM Read/Write (Low Byte)
CODE_008DB4:        A9 50         LDA.B #$50                ;  | 
CODE_008DB6:        8D 17 21      STA.W $2117               ; /  ; Address for VRAM Read/Write (High Byte)
CODE_008DB9:        A2 06         LDX.B #$06                ; \  
CODE_008DBB:        BD E7 8D      LDA.W DMAdata_StBr1,X     ;  |Load settings from DMAdata_StBr1 into DMA channel 1 
CODE_008DBE:        9D 10 43      STA.W $4310,X             ;  | 
CODE_008DC1:        CA            DEX                       ;  | 
CODE_008DC2:        10 F7         BPL CODE_008DBB           ; /  
CODE_008DC4:        A9 02         LDA.B #$02                ; \ Activate DMA channel 1 
CODE_008DC6:        8D 0B 42      STA.W $420B               ; /  ; Regular DMA Channel Enable
CODE_008DC9:        9C 15 21      STZ.W $2115               ; Set VRAM Address Increment Value to x00 ; VRAM Address Increment Value
CODE_008DCC:        A9 63         LDA.B #$63                ; \  
CODE_008DCE:        8D 16 21      STA.W $2116               ;  |Set Address for VRAM Read/Write to x5063 ; Address for VRAM Read/Write (Low Byte)
CODE_008DD1:        A9 50         LDA.B #$50                ;  | 
CODE_008DD3:        8D 17 21      STA.W $2117               ; /  ; Address for VRAM Read/Write (High Byte)
CODE_008DD6:        A2 06         LDX.B #$06                ; \  
CODE_008DD8:        BD EE 8D      LDA.W DMAdata_StBr2,X     ;  |Load settings from DMAdata_StBr2 into DMA channel 1 
CODE_008DDB:        9D 10 43      STA.W $4310,X             ;  | 
CODE_008DDE:        CA            DEX                       ;  | 
CODE_008DDF:        10 F7         BPL CODE_008DD8           ; /  
CODE_008DE1:        A9 02         LDA.B #$02                ; \ Activate DMA channel 1 
CODE_008DE3:        8D 0B 42      STA.W $420B               ; /  ; Regular DMA Channel Enable
Return008DE6:       60            RTS                       ; Return 


DMAdata_StBr1:                    .db $00,$18,$F9,$0E,$00,$1C,$00

DMAdata_StBr2:                    .db $00,$18,$15,$0F,$00,$1B,$00

DATA_008DF5:                      .db $40,$41,$42,$43

DATA_008DF9:                      .db $44,$24,$26,$48,$0E

DATA_008DFE:                      .db $00,$02,$04

DATA_008E01:                      .db $02,$08,$0A,$00,$04

DATA_008E06:                      .db $B7

DATA_008E07:                      .db $C3,$B8,$B9,$BA,$BB,$BA,$BF,$BC
                                  .db $BD,$BE,$BF,$C0,$C3,$C1,$B9,$C2
                                  .db $C4,$B7,$C5

CODE_008E1A:        AD 93 14      LDA.W $1493               ; \  
CODE_008E1D:        05 9D         ORA RAM_SpritesLocked     ;  |If level is ending or sprites are locked, 
CODE_008E1F:        D0 4E         BNE CODE_008E6F           ; / branch to $8E6F 
CODE_008E21:        AD 9B 0D      LDA.W $0D9B               
CODE_008E24:        C9 C1         CMP.B #$C1                
CODE_008E26:        F0 47         BEQ CODE_008E6F           
CODE_008E28:        CE 30 0F      DEC.W $0F30               
CODE_008E2B:        10 42         BPL CODE_008E6F           
CODE_008E2D:        A9 28         LDA.B #$28                
CODE_008E2F:        8D 30 0F      STA.W $0F30               
CODE_008E32:        AD 31 0F      LDA.W $0F31               ; \  
CODE_008E35:        0D 32 0F      ORA.W $0F32               ;  |If time is 0, 
CODE_008E38:        0D 33 0F      ORA.W $0F33               ;  |branch to $8E6F 
CODE_008E3B:        F0 32         BEQ CODE_008E6F           ; /  
CODE_008E3D:        A2 02         LDX.B #$02                
CODE_008E3F:        DE 31 0F      DEC.W $0F31,X             
CODE_008E42:        10 08         BPL CODE_008E4C           
CODE_008E44:        A9 09         LDA.B #$09                
CODE_008E46:        9D 31 0F      STA.W $0F31,X             
CODE_008E49:        CA            DEX                       
CODE_008E4A:        10 F3         BPL CODE_008E3F           
CODE_008E4C:        AD 31 0F      LDA.W $0F31               ; \  
CODE_008E4F:        D0 0F         BNE CODE_008E60           ;  | 
CODE_008E51:        AD 32 0F      LDA.W $0F32               ;  | 
CODE_008E54:        2D 33 0F      AND.W $0F33               ;  |If time is 99, 
CODE_008E57:        C9 09         CMP.B #$09                ;  |speed up the music 
CODE_008E59:        D0 05         BNE CODE_008E60           ;  | 
CODE_008E5B:        A9 FF         LDA.B #$FF                ;  | 
CODE_008E5D:        8D F9 1D      STA.W $1DF9               ;  | 
CODE_008E60:        AD 31 0F      LDA.W $0F31               ; \  
CODE_008E63:        0D 32 0F      ORA.W $0F32               ;  | 
CODE_008E66:        0D 33 0F      ORA.W $0F33               ;  |If time is 0, 
CODE_008E69:        D0 04         BNE CODE_008E6F           ;  |JSL to $00F606 
CODE_008E6B:        22 06 F6 00   JSL.L KillMario           ;  | 
CODE_008E6F:        AD 31 0F      LDA.W $0F31               ; \  
CODE_008E72:        8D 25 0F      STA.W $0F25               ;  | 
CODE_008E75:        AD 32 0F      LDA.W $0F32               ;  |Copy time to $0F25-$0F27 
CODE_008E78:        8D 26 0F      STA.W $0F26               ;  | 
CODE_008E7B:        AD 33 0F      LDA.W $0F33               ;  | 
CODE_008E7E:        8D 27 0F      STA.W $0F27               ; /  
CODE_008E81:        A2 10         LDX.B #$10                
CODE_008E83:        A0 00         LDY.B #$00                
CODE_008E85:        B9 31 0F      LDA.W $0F31,Y             
CODE_008E88:        D0 0B         BNE CODE_008E95           
CODE_008E8A:        A9 FC         LDA.B #$FC                
CODE_008E8C:        9D 15 0F      STA.W $0F15,X             
CODE_008E8F:        C8            INY                       
CODE_008E90:        E8            INX                       
CODE_008E91:        C0 02         CPY.B #$02                
CODE_008E93:        D0 F0         BNE CODE_008E85           
CODE_008E95:        A2 03         LDX.B #$03                
CODE_008E97:        BD 36 0F      LDA.W $0F36,X             
CODE_008E9A:        85 00         STA $00                   
CODE_008E9C:        64 01         STZ $01                   
CODE_008E9E:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_008EA0:        BD 34 0F      LDA.W $0F34,X             
CODE_008EA3:        38            SEC                       
CODE_008EA4:        E9 3F 42      SBC.W #$423F              
CODE_008EA7:        A5 00         LDA $00                   
CODE_008EA9:        E9 0F 00      SBC.W #$000F              
CODE_008EAC:        90 11         BCC CODE_008EBF           
ADDR_008EAE:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
ADDR_008EB0:        A9 0F         LDA.B #$0F                
ADDR_008EB2:        9D 36 0F      STA.W $0F36,X             
ADDR_008EB5:        A9 42         LDA.B #$42                
ADDR_008EB7:        9D 35 0F      STA.W $0F35,X             
ADDR_008EBA:        A9 3F         LDA.B #$3F                
ADDR_008EBC:        9D 34 0F      STA.W $0F34,X             
CODE_008EBF:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_008EC1:        CA            DEX                       
CODE_008EC2:        CA            DEX                       
CODE_008EC3:        CA            DEX                       
CODE_008EC4:        10 D1         BPL CODE_008E97           
CODE_008EC6:        AD 36 0F      LDA.W $0F36               ; \ Store high byte of Mario's score in $00 
CODE_008EC9:        85 00         STA $00                   ; /  
CODE_008ECB:        64 01         STZ $01                   ; Store x00 in $01 
CODE_008ECD:        AD 35 0F      LDA.W $0F35               ; \ Store mid byte of Mario's score in $03 
CODE_008ED0:        85 03         STA $03                   ; / 
CODE_008ED2:        AD 34 0F      LDA.W $0F34               ; \ Store low byte of Mario's score in $02 
CODE_008ED5:        85 02         STA $02                   ; / 
CODE_008ED7:        A2 14         LDX.B #$14                
CODE_008ED9:        A0 00         LDY.B #$00                
CODE_008EDB:        20 12 90      JSR.W CODE_009012         
CODE_008EDE:        A2 00         LDX.B #$00                ; \  
CODE_008EE0:        BD 29 0F      LDA.W $0F29,X             ;  | 
CODE_008EE3:        D0 0A         BNE CODE_008EEF           ;  | 
CODE_008EE5:        A9 FC         LDA.B #$FC                ;  |Replace all leading zeroes in the score with spaces 
CODE_008EE7:        9D 29 0F      STA.W $0F29,X             ;  | 
CODE_008EEA:        E8            INX                       ;  | 
CODE_008EEB:        E0 06         CPX.B #$06                ;  | 
CODE_008EED:        D0 F1         BNE CODE_008EE0           ;  | 
CODE_008EEF:        AD B3 0D      LDA.W $0DB3               ; Get current player 
CODE_008EF2:        F0 29         BEQ CODE_008F1D           ; If player is Mario, branch to $8F1D 
CODE_008EF4:        AD 39 0F      LDA.W $0F39               ; \ Store high byte of Luigi's score in $00 
CODE_008EF7:        85 00         STA $00                   ; /  
CODE_008EF9:        64 01         STZ $01                   ; Store x00 in $01 
CODE_008EFB:        AD 38 0F      LDA.W $0F38               ; \ Store mid byte of Luigi's score in $03 
CODE_008EFE:        85 03         STA $03                   ; /  
CODE_008F00:        AD 37 0F      LDA.W $0F37               ; \ Store low byte of Luigi's score in $02 
CODE_008F03:        85 02         STA $02                   ; /  
CODE_008F05:        A2 14         LDX.B #$14                
CODE_008F07:        A0 00         LDY.B #$00                
CODE_008F09:        20 12 90      JSR.W CODE_009012         
CODE_008F0C:        A2 00         LDX.B #$00                ; \  
CODE_008F0E:        BD 29 0F      LDA.W $0F29,X             ;  | 
CODE_008F11:        D0 0A         BNE CODE_008F1D           ;  | 
CODE_008F13:        A9 FC         LDA.B #$FC                ;  |Replace all leading zeroes in the score with spaces 
CODE_008F15:        9D 29 0F      STA.W $0F29,X             ;  | 
CODE_008F18:        E8            INX                       ;  | 
CODE_008F19:        E0 06         CPX.B #$06                ;  | 
CODE_008F1B:        D0 F1         BNE CODE_008F0E           ; /  
CODE_008F1D:        AD CC 13      LDA.W $13CC               ; \ If Coin increase isn't x00, 
CODE_008F20:        F0 19         BEQ CODE_008F3B           ; / branch to $8F3B 
CODE_008F22:        CE CC 13      DEC.W $13CC               ; Decrease "Coin increase" 
CODE_008F25:        EE BF 0D      INC.W RAM_StatusCoins     ; Increase coins by 1 
CODE_008F28:        AD BF 0D      LDA.W RAM_StatusCoins     ; \  
CODE_008F2B:        C9 64         CMP.B #$64                ;  |If coins<100, branch to $8F3B 
CODE_008F2D:        90 0C         BCC CODE_008F3B           ; /  
CODE_008F2F:        EE E4 18      INC.W $18E4               ; Increase lives by 1 
CODE_008F32:        AD BF 0D      LDA.W RAM_StatusCoins     ; \  
CODE_008F35:        38            SEC                       ;  |Decrease coins by 100 
CODE_008F36:        E9 64         SBC.B #$64                ;  | 
CODE_008F38:        8D BF 0D      STA.W RAM_StatusCoins     ; /  
CODE_008F3B:        AD BE 0D      LDA.W RAM_StatusLives     ; \ If amount of lives is negative, 
CODE_008F3E:        30 09         BMI CODE_008F49           ; / branch to $8F49 
CODE_008F40:        C9 62         CMP.B #$62                ; \ If amount of lives is less than 98, 
CODE_008F42:        90 05         BCC CODE_008F49           ; / branch to $8F49 
CODE_008F44:        A9 62         LDA.B #$62                ; \ Set amount of lives to 98 
CODE_008F46:        8D BE 0D      STA.W RAM_StatusLives     ; /  
CODE_008F49:        AD BE 0D      LDA.W RAM_StatusLives     ; \  
CODE_008F4C:        1A            INC A                     ;  |Get amount of lives in decimal 
CODE_008F4D:        20 45 90      JSR.W HexToDec            ; /  
CODE_008F50:        9B            TXY                       ; \  
CODE_008F51:        D0 02         BNE CODE_008F55           ;  |If 10s is 0, replace with space 
CODE_008F53:        A2 FC         LDX.B #$FC                ;  | 
CODE_008F55:        8E 16 0F      STX.W $0F16               ; \ Write lives to status bar 
CODE_008F58:        8D 17 0F      STA.W $0F17               ; /  
CODE_008F5B:        AE B3 0D      LDX.W $0DB3               ; \ Get bonus stars 
CODE_008F5E:        BD 48 0F      LDA.W $0F48,X             ; /  
CODE_008F61:        C9 64         CMP.B #$64                ; \ If bonus stars is less than 100, 
CODE_008F63:        90 0E         BCC CODE_008F73           ; / branch to $8F73 
CODE_008F65:        A9 FF         LDA.B #$FF                ; \ Start bonus game when the level ends 
CODE_008F67:        8D 25 14      STA.W $1425               ; /  
CODE_008F6A:        BD 48 0F      LDA.W $0F48,X             ; \  
CODE_008F6D:        38            SEC                       ;  |Subtract bonus stars by 100 
CODE_008F6E:        E9 64         SBC.B #$64                ;  | 
CODE_008F70:        9D 48 0F      STA.W $0F48,X             ; /  
CODE_008F73:        AD BF 0D      LDA.W RAM_StatusCoins     ; \ Get amount of coins in decimal 
CODE_008F76:        20 45 90      JSR.W HexToDec            ; /  
CODE_008F79:        9B            TXY                       ; \ 
CODE_008F7A:        D0 02         BNE CODE_008F7E           ;  |If 10s is 0, replace with space 
CODE_008F7C:        A2 FC         LDX.B #$FC                ;  | 
CODE_008F7E:        8D 14 0F      STA.W $0F14               ; \ Write coins to status bar 
CODE_008F81:        8E 13 0F      STX.W $0F13               ; /  
CODE_008F84:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_008F86:        AE B3 0D      LDX.W $0DB3               ; Load Character into X 
CODE_008F89:        64 00         STZ $00                   
CODE_008F8B:        64 01         STZ $01                   
CODE_008F8D:        64 03         STZ $03                   
CODE_008F8F:        BD 48 0F      LDA.W $0F48,X             
CODE_008F92:        85 02         STA $02                   
CODE_008F94:        A2 09         LDX.B #$09                
CODE_008F96:        A0 10         LDY.B #$10                
CODE_008F98:        20 51 90      JSR.W CODE_009051         
CODE_008F9B:        A2 00         LDX.B #$00                
CODE_008F9D:        BD 1E 0F      LDA.W $0F1E,X             
CODE_008FA0:        D0 0D         BNE CODE_008FAF           
CODE_008FA2:        A9 FC         LDA.B #$FC                
CODE_008FA4:        9D 1E 0F      STA.W $0F1E,X             
CODE_008FA7:        9D 03 0F      STA.W $0F03,X             
CODE_008FAA:        E8            INX                       
CODE_008FAB:        E0 01         CPX.B #$01                
CODE_008FAD:        D0 EE         BNE CODE_008F9D           
CODE_008FAF:        BD 1E 0F      LDA.W $0F1E,X             
CODE_008FB2:        0A            ASL                       
CODE_008FB3:        A8            TAY                       
CODE_008FB4:        B9 06 8E      LDA.W DATA_008E06,Y       
CODE_008FB7:        9D 03 0F      STA.W $0F03,X             
CODE_008FBA:        B9 07 8E      LDA.W DATA_008E07,Y       
CODE_008FBD:        9D 1E 0F      STA.W $0F1E,X             
CODE_008FC0:        E8            INX                       
CODE_008FC1:        E0 02         CPX.B #$02                
CODE_008FC3:        D0 EA         BNE CODE_008FAF           
CODE_008FC5:        20 79 90      JSR.W CODE_009079         
CODE_008FC8:        AD B3 0D      LDA.W $0DB3               
CODE_008FCB:        F0 0B         BEQ CODE_008FD8           
CODE_008FCD:        A2 04         LDX.B #$04                
CODE_008FCF:        BD F5 8D      LDA.W DATA_008DF5,X       
CODE_008FD2:        9D F9 0E      STA.W $0EF9,X             
CODE_008FD5:        CA            DEX                       
CODE_008FD6:        10 F7         BPL CODE_008FCF           
CODE_008FD8:        AD 22 14      LDA.W $1422               
CODE_008FDB:        C9 05         CMP.B #$05                
CODE_008FDD:        90 02         BCC CODE_008FE1           
CODE_008FDF:        A9 00         LDA.B #$00                
CODE_008FE1:        3A            DEC A                     
CODE_008FE2:        85 00         STA $00                   
CODE_008FE4:        A2 00         LDX.B #$00                
CODE_008FE6:        A0 FC         LDY.B #$FC                
CODE_008FE8:        A5 00         LDA $00                   
CODE_008FEA:        30 02         BMI CODE_008FEE           
CODE_008FEC:        A0 2E         LDY.B #$2E                
CODE_008FEE:        98            TYA                       
CODE_008FEF:        9D FF 0E      STA.W $0EFF,X             
CODE_008FF2:        C6 00         DEC $00                   
CODE_008FF4:        E8            INX                       
CODE_008FF5:        E0 04         CPX.B #$04                
CODE_008FF7:        D0 ED         BNE CODE_008FE6           
Return008FF9:       60            RTS                       


DATA_008FFA:                      .db $01,$00

DATA_008FFC:                      .db $A0,$86,$00,$00,$10,$27,$00,$00
                                  .db $E8,$03,$00,$00,$64,$00,$00,$00
                                  .db $0A,$00,$00,$00,$01,$00

CODE_009012:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_009014:        9E 15 0F      STZ.W $0F15,X             
CODE_009017:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_009019:        A5 02         LDA $02                   
CODE_00901B:        38            SEC                       
CODE_00901C:        F9 FC 8F      SBC.W DATA_008FFC,Y       
CODE_00901F:        85 06         STA $06                   
CODE_009021:        A5 00         LDA $00                   
CODE_009023:        F9 FA 8F      SBC.W DATA_008FFA,Y       
CODE_009026:        85 04         STA $04                   
CODE_009028:        90 0F         BCC CODE_009039           
CODE_00902A:        A5 06         LDA $06                   
CODE_00902C:        85 02         STA $02                   
CODE_00902E:        A5 04         LDA $04                   
CODE_009030:        85 00         STA $00                   
CODE_009032:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_009034:        FE 15 0F      INC.W $0F15,X             
CODE_009037:        80 DE         BRA CODE_009017           

CODE_009039:        E8            INX                       
CODE_00903A:        C8            INY                       
CODE_00903B:        C8            INY                       
CODE_00903C:        C8            INY                       
CODE_00903D:        C8            INY                       
CODE_00903E:        C0 18         CPY.B #$18                
CODE_009040:        D0 D0         BNE CODE_009012           
CODE_009042:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
Return009044:       60            RTS                       

HexToDec:           A2 00         LDX.B #$00                ;  | 
CODE_009047:        C9 0A         CMP.B #$0A                ;  | 
CODE_009049:        90 05         BCC Return009050          ;  |Sets A to 10s of original A 
CODE_00904B:        E9 0A         SBC.B #$0A                ;  |Sets X to 1s of original A 
CODE_00904D:        E8            INX                       ;  | 
CODE_00904E:        80 F7         BRA CODE_009047           ;  | 

Return009050:       60            RTS                       ; /  

CODE_009051:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_009053:        9E 15 0F      STZ.W $0F15,X             
CODE_009056:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_009058:        A5 02         LDA $02                   
CODE_00905A:        38            SEC                       
CODE_00905B:        F9 FC 8F      SBC.W DATA_008FFC,Y       
CODE_00905E:        85 06         STA $06                   
CODE_009060:        90 0B         BCC CODE_00906D           
CODE_009062:        A5 06         LDA $06                   
CODE_009064:        85 02         STA $02                   
CODE_009066:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_009068:        FE 15 0F      INC.W $0F15,X             
CODE_00906B:        80 E9         BRA CODE_009056           

CODE_00906D:        E8            INX                       
CODE_00906E:        C8            INY                       
CODE_00906F:        C8            INY                       
CODE_009070:        C8            INY                       
CODE_009071:        C8            INY                       
CODE_009072:        C0 18         CPY.B #$18                
CODE_009074:        D0 DB         BNE CODE_009051           
CODE_009076:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return009078:       60            RTS                       

CODE_009079:        A0 E0         LDY.B #$E0                
CODE_00907B:        2C 9B 0D      BIT.W $0D9B               
CODE_00907E:        50 0E         BVC CODE_00908E           
CODE_009080:        A0 00         LDY.B #$00                
CODE_009082:        AD 9B 0D      LDA.W $0D9B               
CODE_009085:        C9 C1         CMP.B #$C1                
CODE_009087:        F0 05         BEQ CODE_00908E           
CODE_009089:        A9 F0         LDA.B #$F0                
CODE_00908B:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_00908E:        84 01         STY $01                   
CODE_009090:        AC C2 0D      LDY.W $0DC2               
CODE_009093:        F0 3B         BEQ Return0090D0          
CODE_009095:        B9 01 8E      LDA.W DATA_008E01,Y       
CODE_009098:        85 00         STA $00                   
CODE_00909A:        C0 03         CPY.B #$03                
CODE_00909C:        D0 0D         BNE CODE_0090AB           
ADDR_00909E:        A5 13         LDA RAM_FrameCounter      
ADDR_0090A0:        4A            LSR                       
ADDR_0090A1:        29 03         AND.B #$03                
ADDR_0090A3:        5A            PHY                       
ADDR_0090A4:        A8            TAY                       
ADDR_0090A5:        B9 FE 8D      LDA.W DATA_008DFE,Y       
ADDR_0090A8:        7A            PLY                       
ADDR_0090A9:        85 00         STA $00                   
CODE_0090AB:        A4 01         LDY $01                   
CODE_0090AD:        A9 78         LDA.B #$78                
CODE_0090AF:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_0090B2:        A9 0F         LDA.B #$0F                
CODE_0090B4:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_0090B7:        A9 30         LDA.B #$30                
CODE_0090B9:        05 00         ORA $00                   
CODE_0090BB:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_0090BE:        AE C2 0D      LDX.W $0DC2               
CODE_0090C1:        BD F9 8D      LDA.W DATA_008DF9,X       
CODE_0090C4:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_0090C7:        98            TYA                       
CODE_0090C8:        4A            LSR                       
CODE_0090C9:        4A            LSR                       
CODE_0090CA:        A8            TAY                       
CODE_0090CB:        A9 02         LDA.B #$02                
CODE_0090CD:        99 20 04      STA.W $0420,Y             
Return0090D0:       60            RTS                       


DATA_0090D1:                      .db $00,$FF,$4D,$4C,$03,$4D,$5D,$FF
                                  .db $03,$00,$4C,$03,$04,$15,$00,$02
                                  .db $00,$4A,$4E,$FF,$4C,$4B,$4A,$03
                                  .db $5F,$05,$04,$03,$02,$00,$FF,$01
                                  .db $4A,$5F,$05,$04,$00,$4D,$5D,$03
                                  .db $02,$01,$00,$FF,$5B,$14,$5F,$01
                                  .db $5E,$FF,$FF,$FF

DATA_009105:                      .db $10,$FF,$00,$5C,$13,$00,$5D,$FF
                                  .db $03,$00,$5C,$13,$14,$15,$00,$12
                                  .db $00,$03,$5E,$FF,$5C,$4B,$5A,$03
                                  .db $5F,$05,$14,$13,$12,$10,$FF,$11
                                  .db $03,$5F,$05,$14,$00,$00,$5D,$03
                                  .db $12,$11,$10,$FF,$5B,$01,$5F,$01
                                  .db $5E,$FF,$FF,$FF

DATA_009139:                      .db $34,$00,$34,$34,$34,$34,$30,$00
                                  .db $34,$34,$34,$34,$74,$34,$34,$34
                                  .db $34,$34,$34,$00,$34,$34,$34,$34
                                  .db $34,$34,$34,$34,$34,$34,$00,$34
                                  .db $34,$34,$34,$34,$34,$34,$34,$34
                                  .db $34,$34,$34,$34,$34,$34,$34,$34
                                  .db $34

DATA_00916A:                      .db $34,$00,$B4,$34,$34,$B4,$F0,$00
                                  .db $B4,$B4,$34,$34,$74,$B4,$B4,$34
                                  .db $B4,$B4,$34,$00,$34,$B4,$34,$B4
                                  .db $B4,$B4,$34,$34,$34,$34,$00,$34
                                  .db $B4,$B4,$B4,$34,$B4,$B4,$B4,$B4
                                  .db $34,$34,$34,$34,$F4,$B4,$F4,$B4
                                  .db $B4

CODE_00919B:        A5 71         LDA RAM_MarioAnimation    
CODE_00919D:        C9 0A         CMP.B #$0A                
CODE_00919F:        D0 05         BNE CODE_0091A6           
CODE_0091A1:        20 93 C5      JSR.W CODE_00C593         
CODE_0091A4:        80 0A         BRA Return0091B0          

CODE_0091A6:        AD 1A 14      LDA.W $141A               
CODE_0091A9:        D0 05         BNE Return0091B0          
CODE_0091AB:        A9 1E         LDA.B #$1E                
CODE_0091AD:        8D C0 0D      STA.W $0DC0               
Return0091B0:       60            RTS                       

CODE_0091B1:        20 2D A8      JSR.W CODE_00A82D         
CODE_0091B4:        A2 00         LDX.B #$00                
CODE_0091B6:        A9 B0         LDA.B #$B0                
CODE_0091B8:        AC 25 14      LDY.W $1425               
CODE_0091BB:        F0 0D         BEQ CODE_0091CA           
CODE_0091BD:        9C 31 0F      STZ.W $0F31               ; \  
CODE_0091C0:        9C 32 0F      STZ.W $0F32               ;  |Set timer to 000 
CODE_0091C3:        9C 33 0F      STZ.W $0F33               ; /  
CODE_0091C6:        A2 26         LDX.B #$26                
CODE_0091C8:        A9 A4         LDA.B #$A4                
CODE_0091CA:        85 00         STA $00                   
CODE_0091CC:        64 01         STZ $01                   
CODE_0091CE:        A0 70         LDY.B #$70                
CODE_0091D0:        20 E9 91      JSR.W CODE_0091E9         
CODE_0091D3:        E8            INX                       
CODE_0091D4:        E0 08         CPX.B #$08                
CODE_0091D6:        D0 07         BNE CODE_0091DF           
CODE_0091D8:        AD B3 0D      LDA.W $0DB3               
CODE_0091DB:        F0 02         BEQ CODE_0091DF           
CODE_0091DD:        A2 0E         LDX.B #$0E                
CODE_0091DF:        98            TYA                       
CODE_0091E0:        38            SEC                       
CODE_0091E1:        E9 08         SBC.B #$08                
CODE_0091E3:        A8            TAY                       
CODE_0091E4:        D0 EA         BNE CODE_0091D0           
CODE_0091E6:        4C 94 84      JMP.W CODE_008494         

CODE_0091E9:        BD 39 91      LDA.W DATA_009139,X       
CODE_0091EC:        99 0B 03      STA.W OAM_Tile3Prop,Y     
CODE_0091EF:        BD 6A 91      LDA.W DATA_00916A,X       
CODE_0091F2:        99 0F 03      STA.W OAM_Tile4Prop,Y     
CODE_0091F5:        A5 00         LDA $00                   
CODE_0091F7:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_0091FA:        99 0C 03      STA.W OAM_Tile4DispX,Y    
CODE_0091FD:        38            SEC                       
CODE_0091FE:        E9 08         SBC.B #$08                
CODE_009200:        85 00         STA $00                   
CODE_009202:        B0 02         BCS CODE_009206           
CODE_009204:        C6 01         DEC $01                   
CODE_009206:        5A            PHY                       
CODE_009207:        98            TYA                       
CODE_009208:        4A            LSR                       
CODE_009209:        4A            LSR                       
CODE_00920A:        A8            TAY                       
CODE_00920B:        A5 01         LDA $01                   
CODE_00920D:        29 01         AND.B #$01                
CODE_00920F:        99 62 04      STA.W $0462,Y             
CODE_009212:        99 63 04      STA.W $0463,Y             
CODE_009215:        7A            PLY                       
CODE_009216:        BD D1 90      LDA.W DATA_0090D1,X       
CODE_009219:        30 13         BMI Return00922E          
CODE_00921B:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_00921E:        BD 05 91      LDA.W DATA_009105,X       
CODE_009221:        99 0E 03      STA.W OAM_Tile4,Y         
CODE_009224:        A9 68         LDA.B #$68                
CODE_009226:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_009229:        A9 70         LDA.B #$70                
CODE_00922B:        99 0D 03      STA.W OAM_Tile4DispY,Y    
Return00922E:       60            RTS                       

CODE_00922F:        9C 03 07      STZ.W $0703               
CODE_009232:        9C 04 07      STZ.W $0704               
CODE_009235:        9C 21 21      STZ.W $2121               ; Set "Address for CG-RAM Write" to 0 ; Address for CG-RAM Write
CODE_009238:        A2 06         LDX.B #$06                
CODE_00923A:        BD 49 92      LDA.W DATA_009249,X       
CODE_00923D:        9D 20 43      STA.W $4320,X             
CODE_009240:        CA            DEX                       
CODE_009241:        10 F7         BPL CODE_00923A           
CODE_009243:        A9 04         LDA.B #$04                
CODE_009245:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
Return009248:       60            RTS                       


DATA_009249:                      .db $00,$22,$03,$07,$00,$00,$02

CODE_009250:        A2 04         LDX.B #$04                
CODE_009252:        BD 77 92      LDA.W DATA_009277,X       
CODE_009255:        9D 70 43      STA.W $4370,X             
CODE_009258:        CA            DEX                       
CODE_009259:        10 F7         BPL CODE_009252           
CODE_00925B:        A9 00         LDA.B #$00                
CODE_00925D:        8D 77 43      STA.W $4377               ; Data Bank (H-DMA)
CODE_009260:        9C 9F 0D      STZ.W $0D9F               ; Disable all HDMA channels 
CODE_009263:        C2 10         REP #$10                  ; 16 bit A ; Index (16 bit) 
CODE_009265:        A2 BE 01      LDX.W #$01BE              ; \  
CODE_009268:        A9 FF         LDA.B #$FF                ;  | 
CODE_00926A:        9D A0 04      STA.W $04A0,X             ;  |Clear "HDMA table for windowing effects" 
CODE_00926D:        9E A1 04      STZ.W $04A1,X             ;  |...hang on again.  It clears one set of RAM here, but not the same 
CODE_009270:        CA            DEX                       ;  | 
CODE_009271:        CA            DEX                       ;  | 
CODE_009272:        10 F6         BPL CODE_00926A           ; /  
CODE_009274:        E2 10         SEP #$10                  ; \ Set A to 8bit and return ; Index (8 bit) 
Return009276:       60            RTS                       ; /  


DATA_009277:                      .db $41,$26,$7C,$92,$00,$F0,$A0,$04
                                  .db $F0,$80,$05,$00

CODE_009283:        20 63 92      JSR.W CODE_009263         
CODE_009286:        AD 9B 0D      LDA.W $0D9B               
CODE_009289:        4A            LSR                       
CODE_00928A:        B0 14         BCS CODE_0092A0           
CODE_00928C:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_00928E:        A2 BE 01      LDX.W #$01BE              
WindowHDMAenable:   9E A0 04      STZ.W $04A0,X             ; out? 
CODE_009294:        A9 FF         LDA.B #$FF                ; *note to self: ctrl+insert, not shift+insert* 
CODE_009296:        9D A1 04      STA.W $04A1,X             ; ...  This is, uh, strange.  It pastes $00FF into the $04A0,x table 
CODE_009299:        E8            INX                       ; instead of $FF00 o_O 
CODE_00929A:        E8            INX                       
CODE_00929B:        E0 C0 01      CPX.W #$01C0              
CODE_00929E:        90 F1         BCC WindowHDMAenable      
CODE_0092A0:        A9 80         LDA.B #$80                ;  Enable channel 7 in HDMA, disable all other HDMA channels 
CODE_0092A2:        8D 9F 0D      STA.W $0D9F               ;  $7E:0D9F - H-DMA Channel Enable RAM Mirror 
CODE_0092A5:        E2 10         SEP #$10                  ; Index (8 bit) 
Return0092A7:       60            RTS                       

CODE_0092A8:        20 63 92      JSR.W CODE_009263         ; these are somewhat the same subroutine, but also not >_> 
CODE_0092AB:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_0092AD:        A2 98 01      LDX.W #$0198              
CODE_0092B0:        80 DF         BRA WindowHDMAenable      

CODE_0092B2:        A9 58         LDA.B #$58                ; Index (8 bit) 
CODE_0092B4:        8D A0 04      STA.W $04A0               
CODE_0092B7:        8D AA 04      STA.W $04AA               
CODE_0092BA:        8D B4 04      STA.W $04B4               
CODE_0092BD:        9C A9 04      STZ.W $04A9               
CODE_0092C0:        9C B3 04      STZ.W $04B3               
CODE_0092C3:        9C BD 04      STZ.W $04BD               
CODE_0092C6:        A2 04         LDX.B #$04                
CODE_0092C8:        BD 13 93      LDA.W DATA_009313,X       
CODE_0092CB:        9D 50 43      STA.W $4350,X             
CODE_0092CE:        BD 18 93      LDA.W DATA_009318,X       
CODE_0092D1:        9D 60 43      STA.W $4360,X             
CODE_0092D4:        BD 1D 93      LDA.W DATA_00931D,X       
CODE_0092D7:        9D 70 43      STA.W $4370,X             
CODE_0092DA:        CA            DEX                       
CODE_0092DB:        10 EB         BPL CODE_0092C8           
CODE_0092DD:        A9 00         LDA.B #$00                
CODE_0092DF:        8D 57 43      STA.W $4357               ; Data Bank (H-DMA)
CODE_0092E2:        8D 67 43      STA.W $4367               ; Data Bank (H-DMA)
CODE_0092E5:        8D 77 43      STA.W $4377               ; Data Bank (H-DMA)
CODE_0092E8:        A9 E0         LDA.B #$E0                
CODE_0092EA:        8D 9F 0D      STA.W $0D9F               
CODE_0092ED:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_0092EF:        A0 08 00      LDY.W #$0008              
CODE_0092F2:        A2 14 00      LDX.W #$0014              
CODE_0092F5:        B9 1A 00      LDA.W RAM_ScreenBndryXLo,Y 
CODE_0092F8:        9D A1 04      STA.W $04A1,X             
CODE_0092FB:        9D A4 04      STA.W $04A4,X             
CODE_0092FE:        B9 62 14      LDA.W $1462,Y             
CODE_009301:        9D A7 04      STA.W $04A7,X             
CODE_009304:        8A            TXA                       
CODE_009305:        38            SEC                       
CODE_009306:        E9 0A 00      SBC.W #$000A              
CODE_009309:        AA            TAX                       
CODE_00930A:        88            DEY                       
CODE_00930B:        88            DEY                       
CODE_00930C:        88            DEY                       
CODE_00930D:        88            DEY                       
CODE_00930E:        10 E5         BPL CODE_0092F5           
CODE_009310:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return009312:       60            RTS                       


DATA_009313:                      .db $02,$0D,$A0,$04,$00

DATA_009318:                      .db $02,$0F,$AA,$04,$00

DATA_00931D:                      .db $02,$11,$B4,$04,$00

GetGameMode:        AD 00 01      LDA.W RAM_GameMode        ; Load game mode 
CODE_009325:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs009329:            91 93      .dw CODE_009391           ; 00 - 
                       0F 94      .dw CODE_00940F           ; 01 - 
                       6F 9F      .dw CODE_009F6F           ; 02 - 
                       AE 96      .dw CODE_0096AE           ; 03 - 
                       8B 9A      .dw CODE_009A8B           ; 04 - 
                       6F 9F      .dw CODE_009F6F           ; 05 - 
                       1B 94      .dw CODE_00941B           ; 06 - 
                       64 9C      .dw GAMEMODE_07           ; 07 - 
                       D1 9C      .dw CODE_009CD1           ; 08 - 
                       1A 9B      .dw CODE_009B1A           ; 09 - 
                       FA 9D      .dw CODE_009DFA           ; 0A - 
                       6F 9F      .dw CODE_009F6F           ; 0B - 
                       87 A0      .dw CODE_00A087           ; 0C - 
                       6F 9F      .dw CODE_009F6F           ; 0D - 
                       BE A1      .dw CODE_00A1BE           ; 0E - 
                       37 9F      .dw TmpFade               ; 0F - 
                       8E 96      .dw CODE_00968E           ; 10 - 
                       D5 96      .dw CODE_0096D5           ; 11 - 
                       9C A5      .dw GM04Load              ; 12 - 
                       37 9F      .dw TmpFade               ; 13 - 
                       DA A1      .dw CODE_00A1DA           ; 14 - 
                       6F 9F      .dw CODE_009F6F           ; 15 - 
                       50 97      .dw CODE_009750           ; 16 - 
                       59 97      .dw CODE_009759           ; 17 - 
                       6F 9F      .dw CODE_009F6F           ; 18 - 
                       68 94      .dw CODE_009468           ; 19 - 
                       6F 9F      .dw CODE_009F6F           ; 1A - 
                       FD 94      .dw CODE_0094FD           ; 1B - 
                       6F 9F      .dw CODE_009F6F           ; 1C - 
                       83 95      .dw CODE_009583           ; 1D - f
                       6F 9F      .dw CODE_009F6F           ; 1E - 
                       AB 95      .dw CODE_0095AB           ; 1F - f
                       6F 9F      .dw CODE_009F6F           ; 20 - 
                       BC 95      .dw CODE_0095BC           ; 21 - 
                       6F 9F      .dw CODE_009F6F           ; 22 - 
                       C1 95      .dw CODE_0095C1           ; 23 - 
                       6F 9F      .dw CODE_009F6F           ; 24 - 
                       2C 96      .dw CODE_00962C           ; 25 - 
                       6F 9F      .dw CODE_009F6F           ; 26 - 
                       3D 96      .dw CODE_00963D           ; 27 - 
                       7C 9F      .dw CODE_009F7C           ; 28 - 
                       8D 96      .dw Return00968D          ; 29 - 

TurnOffIO:          9C 00 42      STZ.W $4200               ; Disable NMI ,VIRQ, HIRQ, Joypads ; NMI, V/H Count, and Joypad Enable
CODE_009380:        9C 0C 42      STZ.W $420C               ; Turn off all HDMA ; H-DMA Channel Enable
CODE_009383:        A9 80         LDA.B #$80                ; \ 
CODE_009385:        8D 00 21      STA.W $2100               ; /Disable Screen ; Screen Display Register
Return009388:       60            RTS                       ; And return 


NintendoPos:                      .db $60,$70,$80,$90

NintendoTile:                     .db $02,$04,$06,$08     ; Nintendo Presents tilemap 

CODE_009391:        20 FA 85      JSR.W CODE_0085FA         
CODE_009394:        20 79 8A      JSR.W SetUpScreen         
CODE_009397:        20 93 A9      JSR.W CODE_00A993         
CODE_00939A:        A0 0C         LDY.B #$0C                ; \ Load Nintendo Presents logo 
CODE_00939C:        A2 03         LDX.B #$03                ;  | 
CODE_00939E:        BD 89 93      LDA.W NintendoPos,X       ;  | 
CODE_0093A1:        99 00 02      STA.W OAM_ExtendedDispX,Y ;  | 
CODE_0093A4:        A9 70         LDA.B #$70                ;  |   <-Y position of logo 
CODE_0093A6:        99 01 02      STA.W OAM_ExtendedDispY,Y ;  | 
CODE_0093A9:        BD 8D 93      LDA.W NintendoTile,X      ;  | 
CODE_0093AC:        99 02 02      STA.W OAM_ExtendedTile,Y  ;  | 
CODE_0093AF:        A9 30         LDA.B #$30                ;  | 
CODE_0093B1:        99 03 02      STA.W OAM_ExtendedProp,Y  ;  | 
CODE_0093B4:        88            DEY                       ;  | 
CODE_0093B5:        88            DEY                       ;  | 
CODE_0093B6:        88            DEY                       ;  | 
CODE_0093B7:        88            DEY                       ;  | 
CODE_0093B8:        CA            DEX                       ;  | 
CODE_0093B9:        10 E3         BPL CODE_00939E           ; /  
CODE_0093BB:        A9 AA         LDA.B #$AA                ; \ Related to making the sprites 16x16? 
CODE_0093BD:        8D 00 04      STA.W $0400               ; /  
CODE_0093C0:        A9 01         LDA.B #$01                ; \ Play "Bing" sound? 
CODE_0093C2:        8D FC 1D      STA.W $1DFC               ; /  
CODE_0093C5:        A9 40         LDA.B #$40                ; \ Set timer to x40 
CODE_0093C7:        8D F5 1D      STA.W $1DF5               ; /  
CODE_0093CA:        A9 0F         LDA.B #$0F                ; \ Set brightness to max 
CODE_0093CC:        8D AE 0D      STA.W $0DAE               ; /  
CODE_0093CF:        A9 01         LDA.B #$01                
CODE_0093D1:        8D AF 0D      STA.W $0DAF               
CODE_0093D4:        9C 2E 19      STZ.W $192E               ; Sprite palette setting = 0 
CODE_0093D7:        20 ED AB      JSR.W LoadPalette         ; Load the palette 
CODE_0093DA:        9C 01 07      STZ.W $0701               ; \ Black background 
CODE_0093DD:        9C 02 07      STZ.W $0702               ; / 
CODE_0093E0:        20 2F 92      JSR.W CODE_00922F         
CODE_0093E3:        9C 92 1B      STZ.W $1B92               ; Set menu pointer position to 0 
CODE_0093E6:        A2 10         LDX.B #$10                ; Enable sprites, disable layers 
CODE_0093E8:        A0 04         LDY.B #$04                ; Set Layer 3 to subscreen 
CODE_0093EA:        A9 01         LDA.B #$01                
CODE_0093EC:        8D 9B 0D      STA.W $0D9B               
CODE_0093EF:        A9 20         LDA.B #$20                ; CGADSUB = 20 
CODE_0093F1:        20 FD 93      JSR.W ScreenSettings      ; Apply above settings 
CODE_0093F4:        EE 00 01      INC.W RAM_GameMode        ; Move on to Game Mode 01 
Mode04Finish:       A9 81         LDA.B #$81                ; \ Enable NMI and joypad, Disable V-count and H-cout 
CODE_0093F9:        8D 00 42      STA.W $4200               ; /  ; NMI, V/H Count, and Joypad Enable
Return0093FC:       60            RTS                       

ScreenSettings:     8D 31 21      STA.W $2131               ; \ Set CGADSUB settings to A ; Add/Subtract Select and Enable
CODE_009400:        85 40         STA $40                   ; /  
CODE_009402:        8E 2C 21      STX.W $212C               ; Set "Background and Object Enable" to X ; Background and Object Enable
CODE_009405:        8C 2D 21      STY.W $212D               ; Set "Sub Screen Designation" Y ; Sub Screen Designation
CODE_009408:        9C 2E 21      STZ.W $212E               ; \ Set "Window Mask Designation" for main and sub screen to x00 ; Window Mask Designation for Main Screen
CODE_00940B:        9C 2F 21      STZ.W $212F               ; /  ; Window Mask Designation for Sub Screen
Return00940E:       60            RTS                       ; Return 

CODE_00940F:        CE F5 1D      DEC.W $1DF5               ; Decrease timer 
CODE_009412:        D0 06         BNE Return00941A          ; \ If timer is 0: 
CODE_009414:        20 88 B8      JSR.W CODE_00B888         ;  |Jump to sub $B888 
CODE_009417:        EE 00 01      INC.W RAM_GameMode        ;  |Move on to Game Mode 02 
Return00941A:       60            RTS                       ; Return 

CODE_00941B:        20 74 9A      JSR.W SetUp0DA0GM4        
CODE_00941E:        20 BE 9C      JSR.W CODE_009CBE         
CODE_009421:        F0 0B         BEQ CODE_00942E           
CODE_009423:        A9 EC         LDA.B #$EC                
CODE_009425:        20 40 94      JSR.W CODE_009440         
CODE_009428:        EE 00 01      INC.W RAM_GameMode        
CODE_00942B:        4C 9F 9C      JMP.W CODE_009C9F         

CODE_00942E:        CE F5 1D      DEC.W $1DF5               
CODE_009431:        D0 E7         BNE Return00941A          
CODE_009433:        EE F5 1D      INC.W $1DF5               
CODE_009436:        AD 33 14      LDA.W $1433               
CODE_009439:        18            CLC                       
CODE_00943A:        69 04         ADC.B #$04                
CODE_00943C:        C9 F0         CMP.B #$F0                
CODE_00943E:        B0 D7         BCS CODE_009417           
CODE_009440:        8D 33 14      STA.W $1433               
CODE_009443:        20 61 CA      JSR.W CODE_00CA61         
CODE_009446:        A9 80         LDA.B #$80                ; \  
CODE_009448:        85 00         STA $00                   ;  |Store x80 in $00, 
CODE_00944A:        A9 70         LDA.B #$70                ;  |Store x70 in $01 
CODE_00944C:        85 01         STA $01                   ; /  
CODE_00944E:        4C 88 CA      JMP.W CODE_00CA88         


CutsceneBgColor:                  .db $02,$00,$04,$01,$00,$06,$04

CutsceneCastlePal:                .db $03,$06,$05,$06,$03,$03,$06,$06     ; Castle palette to use for cutscenes ; Purpose of first byte is unknown 
DATA_009460:                      .db $03,$FF,$FF,$C9,$0F,$FF,$CC,$C9

CODE_009468:        20 FA 85      JSR.W CODE_0085FA         
CODE_00946B:        20 A6 A1      JSR.W Clear_1A_13D3       
CODE_00946E:        20 79 8A      JSR.W SetUpScreen         
CODE_009471:        AE C6 13      LDX.W $13C6               ; Cutscene number 
CODE_009474:        A9 18         LDA.B #$18                
CODE_009476:        8D 31 19      STA.W $1931               
CODE_009479:        A9 14         LDA.B #$14                
CODE_00947B:        8D 2B 19      STA.W $192B               
CODE_00947E:        BD 50 94      LDA.W CutsceneBgColor-1,X 
CODE_009481:        8D 2F 19      STA.W $192F               
CODE_009484:        BD 58 94      LDA.W CutsceneCastlePal,X 
CODE_009487:        8D 30 19      STA.W $1930               
CODE_00948A:        9C 2E 19      STZ.W $192E               
CODE_00948D:        A9 01         LDA.B #$01                
CODE_00948F:        8D 2D 19      STA.W $192D               
CODE_009492:        E0 08         CPX.B #$08                
CODE_009494:        D0 1C         BNE CODE_0094B2           
CODE_009496:        20 5E 95      JSR.W CODE_00955E         
CODE_009499:        A9 D2         LDA.B #$D2                
CODE_00949B:        85 12         STA $12                   
CODE_00949D:        20 D2 85      JSR.W LoadScrnImage       
CODE_0094A0:        20 59 81      JSR.W UploadMusicBank3    
CODE_0094A3:        22 DD 93 0C   JSL.L CODE_0C93DD         
CODE_0094A7:        20 60 92      JSR.W CODE_009260         
CODE_0094AA:        EE 31 19      INC.W $1931               
CODE_0094AD:        EE 2B 19      INC.W $192B               
CODE_0094B0:        80 25         BRA CODE_0094D7           

CODE_0094B2:        A9 15         LDA.B #$15                
CODE_0094B4:        8D FB 1D      STA.W $1DFB               
CODE_0094B7:        BD 60 94      LDA.W DATA_009460,X       
CODE_0094BA:        85 12         STA $12                   
CODE_0094BC:        20 D2 85      JSR.W LoadScrnImage       
CODE_0094BF:        A9 CF         LDA.B #$CF                
CODE_0094C1:        85 12         STA $12                   
CODE_0094C3:        20 D2 85      JSR.W LoadScrnImage       
CODE_0094C6:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0094C8:        A9 90 00      LDA.W #$0090              
CODE_0094CB:        85 94         STA RAM_MarioXPos         
CODE_0094CD:        A9 58 00      LDA.W #$0058              
CODE_0094D0:        85 96         STA RAM_MarioYPos         
CODE_0094D2:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0094D4:        EE 8F 14      INC.W $148F               
CODE_0094D7:        20 DA A9      JSR.W UploadSpriteGFX     
CODE_0094DA:        20 ED AB      JSR.W LoadPalette         
CODE_0094DD:        20 2F 92      JSR.W CODE_00922F         
CODE_0094E0:        A2 0B         LDX.B #$0B                
CODE_0094E2:        74 1A         STZ RAM_ScreenBndryXLo,X  
CODE_0094E4:        CA            DEX                       
CODE_0094E5:        10 FB         BPL CODE_0094E2           
CODE_0094E7:        A9 20         LDA.B #$20                
CODE_0094E9:        85 64         STA $64                   
CODE_0094EB:        20 35 A6      JSR.W CODE_00A635         
CODE_0094EE:        64 76         STZ RAM_MarioDirection    
CODE_0094F0:        64 72         STZ RAM_IsFlying          
CODE_0094F2:        22 B1 CE 00   JSL.L CODE_00CEB1         
CODE_0094F6:        A2 17         LDX.B #$17                
CODE_0094F8:        A0 00         LDY.B #$00                
CODE_0094FA:        20 22 96      JSR.W CODE_009622         
CODE_0094FD:        22 00 80 7F   JSL.L RAM_7F8000          
CODE_009501:        AD C6 13      LDA.W $13C6               
CODE_009504:        C9 08         CMP.B #$08                
CODE_009506:        F0 4F         BEQ CODE_009557           
CODE_009508:        A5 17         LDA RAM_ControllerB       
CODE_00950A:        29 00         AND.B #$00                ; Change to #$30 to enter debug region below 
CODE_00950C:        C9 30         CMP.B #$30                
CODE_00950E:        D0 19         BNE CODE_009529           
ADDR_009510:        A5 15         LDA RAM_ControllerA       ; \ Unreachable 
ADDR_009512:        29 08         AND.B #$08                ;  | Debug: Boss defeated scene select 
ADDR_009514:        F0 0D         BEQ ADDR_009523           ;  | 
ADDR_009516:        AD C6 13      LDA.W $13C6               ;  | 
ADDR_009519:        1A            INC A                     ;  | 
ADDR_00951A:        C9 09         CMP.B #$09                ;  | 
ADDR_00951C:        90 02         BCC ADDR_009520           ;  | 
ADDR_00951E:        A9 01         LDA.B #$01                ;  | 
ADDR_009520:        8D C6 13      STA.W $13C6               ;  | 
ADDR_009523:        A9 18         LDA.B #$18                ;  | 
ADDR_009525:        8D 00 01      STA.W RAM_GameMode        ;  | 
Return009528:       60            RTS                       ; / 

CODE_009529:        22 7E C9 0C   JSL.L CODE_0CC97E         
CODE_00952D:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00952F:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_009531:        48            PHA                       
CODE_009532:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_009534:        48            PHA                       
CODE_009535:        A5 1E         LDA $1E                   
CODE_009537:        85 1A         STA RAM_ScreenBndryXLo    
CODE_009539:        A5 20         LDA $20                   
CODE_00953B:        85 1C         STA RAM_ScreenBndryYLo    
CODE_00953D:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00953F:        22 BD E2 00   JSL.L CODE_00E2BD         
CODE_009543:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_009545:        68            PLA                       
CODE_009546:        85 1C         STA RAM_ScreenBndryYLo    
CODE_009548:        68            PLA                       
CODE_009549:        85 1A         STA RAM_ScreenBndryXLo    
CODE_00954B:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00954D:        A9 0C         LDA.B #$0C                
CODE_00954F:        85 71         STA RAM_MarioAnimation    
CODE_009551:        20 7E C4      JSR.W CODE_00C47E         
CODE_009554:        4C 94 84      JMP.W CODE_008494         

CODE_009557:        22 8D 93 0C   JSL.L CODE_0C938D         
CODE_00955B:        4C 94 84      JMP.W CODE_008494         

CODE_00955E:        A0 2F         LDY.B #$2F                
CODE_009560:        22 28 BA 00   JSL.L CODE_00BA28         
CODE_009564:        A9 80         LDA.B #$80                
CODE_009566:        8D 15 21      STA.W $2115               ; VRAM Address Increment Value
CODE_009569:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00956B:        A9 00 46      LDA.W #$4600              
CODE_00956E:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_009571:        A2 00 02      LDX.W #$0200              
CODE_009574:        A7 00         LDA [$00]                 
CODE_009576:        8D 18 21      STA.W $2118               ; Data for VRAM Write (Low Byte)
CODE_009579:        E6 00         INC $00                   
CODE_00957B:        E6 00         INC $00                   
CODE_00957D:        CA            DEX                       
CODE_00957E:        D0 F4         BNE CODE_009574           
CODE_009580:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return009582:       60            RTS                       

CODE_009583:        EE C6 13      INC.W $13C6               
CODE_009586:        A9 28         LDA.B #$28                
CODE_009588:        A0 01         LDY.B #$01                
CODE_00958A:        20 CF 96      JSR.W CODE_0096CF         
CODE_00958D:        CE 00 01      DEC.W RAM_GameMode        
CODE_009590:        A9 16         LDA.B #$16                
CODE_009592:        8D 2B 19      STA.W $192B               
CODE_009595:        20 9C A5      JSR.W GM04Load            
CODE_009598:        CE 00 01      DEC.W RAM_GameMode        
CODE_00959B:        20 7D 93      JSR.W TurnOffIO           
CODE_00959E:        20 FA 85      JSR.W CODE_0085FA         
CODE_0095A1:        20 93 A9      JSR.W CODE_00A993         
CODE_0095A4:        22 C9 A3 0C   JSL.L CODE_0CA3C9         
CODE_0095A8:        20 1E 96      JSR.W CODE_00961E         
CODE_0095AB:        22 00 80 7F   JSL.L RAM_7F8000          
CODE_0095AF:        22 9A 93 0C   JSL.L CODE_0C939A         
CODE_0095B3:        E6 14         INC RAM_FrameCounterB     
CODE_0095B5:        22 39 BB 05   JSL.L CODE_05BB39         
CODE_0095B9:        4C 94 84      JMP.W CODE_008494         

CODE_0095BC:        22 AD 93 0C   JSL.L CODE_0C93AD         
Return0095C0:       60            RTS                       

CODE_0095C1:        20 FA 85      JSR.W CODE_0085FA         
CODE_0095C4:        20 A6 A1      JSR.W Clear_1A_13D3       
CODE_0095C7:        20 79 8A      JSR.W SetUpScreen         
CODE_0095CA:        22 8C AD 0C   JSL.L CODE_0CAD8C         
CODE_0095CE:        22 1E 80 05   JSL.L CODE_05801E         
CODE_0095D2:        AD E9 1D      LDA.W $1DE9               
CODE_0095D5:        C9 0A         CMP.B #$0A                
CODE_0095D7:        D0 07         BNE CODE_0095E0           
CODE_0095D9:        A9 13         LDA.B #$13                
CODE_0095DB:        8D 2B 19      STA.W $192B               
CODE_0095DE:        80 09         BRA CODE_0095E9           

CODE_0095E0:        C9 0C         CMP.B #$0C                
CODE_0095E2:        D0 05         BNE CODE_0095E9           
CODE_0095E4:        A9 17         LDA.B #$17                
CODE_0095E6:        8D 2B 19      STA.W $192B               
CODE_0095E9:        20 DA A9      JSR.W UploadSpriteGFX     
CODE_0095EC:        20 ED AB      JSR.W LoadPalette         
CODE_0095EF:        22 9E 80 05   JSL.L CODE_05809E         
CODE_0095F3:        20 F9 A5      JSR.W CODE_00A5F9         
CODE_0095F6:        22 F6 AD 0C   JSL.L CODE_0CADF6         
CODE_0095FA:        AD E9 1D      LDA.W $1DE9               
CODE_0095FD:        C9 0C         CMP.B #$0C                
CODE_0095FF:        D0 11         BNE CODE_009612           
CODE_009601:        A2 0B         LDX.B #$0B                
CODE_009603:        BD C0 B3      LDA.W BowserEndPalette,X  
CODE_009606:        9D 07 08      STA.W $0807,X             
CODE_009609:        BD CC B3      LDA.W DATA_00B3CC,X       
CODE_00960C:        9D 27 08      STA.W $0827,X             
CODE_00960F:        CA            DEX                       
CODE_009610:        10 F1         BPL CODE_009603           
CODE_009612:        20 2F 92      JSR.W CODE_00922F         
CODE_009615:        20 B2 92      JSR.W CODE_0092B2         
CODE_009618:        20 D2 85      JSR.W LoadScrnImage       
CODE_00961B:        20 2C 96      JSR.W CODE_00962C         
CODE_00961E:        A2 15         LDX.B #$15                
CODE_009620:        A0 02         LDY.B #$02                
CODE_009622:        20 29 9F      JSR.W KeepModeActive      
CODE_009625:        A9 09         LDA.B #$09                
CODE_009627:        85 3E         STA $3E                   
CODE_009629:        4C EA 93      JMP.W CODE_0093EA         

CODE_00962C:        9C 84 0D      STZ.W $0D84               
CODE_00962F:        20 ED 92      JSR.W CODE_0092ED         
CODE_009632:        22 00 80 7F   JSL.L RAM_7F8000          
CODE_009636:        22 A5 93 0C   JSL.L CODE_0C93A5         
CODE_00963A:        4C 94 84      JMP.W CODE_008494         

CODE_00963D:        20 FA 85      JSR.W CODE_0085FA         
CODE_009640:        20 A6 A1      JSR.W Clear_1A_13D3       
CODE_009643:        20 79 8A      JSR.W SetUpScreen         
CODE_009646:        20 5E 95      JSR.W CODE_00955E         
CODE_009649:        A9 19         LDA.B #$19                
CODE_00964B:        8D 2B 19      STA.W $192B               
CODE_00964E:        A9 03         LDA.B #$03                
CODE_009650:        8D 2F 19      STA.W $192F               
CODE_009653:        A9 03         LDA.B #$03                
CODE_009655:        8D 30 19      STA.W $1930               
CODE_009658:        20 DA A9      JSR.W UploadSpriteGFX     
CODE_00965B:        20 ED AB      JSR.W LoadPalette         
CODE_00965E:        A2 0B         LDX.B #$0B                
CODE_009660:        BD 0E B7      LDA.W TheEndPalettes,X    
CODE_009663:        9D A7 08      STA.W $08A7,X             
CODE_009666:        BD 1A B7      LDA.W DATA_00B71A,X       
CODE_009669:        9D C7 08      STA.W $08C7,X             
CODE_00966C:        BD 26 B7      LDA.W DATA_00B726,X       
CODE_00966F:        9D E7 08      STA.W $08E7,X             
CODE_009672:        CA            DEX                       
CODE_009673:        10 EB         BPL CODE_009660           
CODE_009675:        20 2F 92      JSR.W CODE_00922F         
CODE_009678:        A9 D5         LDA.B #$D5                
CODE_00967A:        85 12         STA $12                   
CODE_00967C:        20 D2 85      JSR.W LoadScrnImage       
CODE_00967F:        22 DF AA 0C   JSL.L CODE_0CAADF         
CODE_009683:        20 94 84      JSR.W CODE_008494         
CODE_009686:        A2 14         LDX.B #$14                
CODE_009688:        A0 00         LDY.B #$00                
CODE_00968A:        4C 22 96      JMP.W CODE_009622         

Return00968D:       60            RTS                       

CODE_00968E:        20 FA 85      JSR.W CODE_0085FA         
CODE_009691:        AD 25 14      LDA.W $1425               
CODE_009694:        D0 12         BNE CODE_0096A8           
CODE_009696:        AD 1A 14      LDA.W $141A               
CODE_009699:        0D 1D 14      ORA.W $141D               
CODE_00969C:        0D 09 01      ORA.W $0109               
CODE_00969F:        D0 0A         BNE CODE_0096AB           
CODE_0096A1:        AD C1 13      LDA.W $13C1               
CODE_0096A4:        C9 56         CMP.B #$56                
CODE_0096A6:        F0 03         BEQ CODE_0096AB           
CODE_0096A8:        20 B1 91      JSR.W CODE_0091B1         
CODE_0096AB:        4C CA 93      JMP.W CODE_0093CA         

CODE_0096AE:        9C 00 42      STZ.W $4200               ; NMI, V/H Count, and Joypad Enable
CODE_0096B1:        20 4E 8A      JSR.W ClearStack          
CODE_0096B4:        A2 07         LDX.B #$07                
CODE_0096B6:        A9 FF         LDA.B #$FF                
CODE_0096B8:        9D 01 01      STA.W $0101,X             
CODE_0096BB:        CA            DEX                       
CODE_0096BC:        10 FA         BPL CODE_0096B8           
CODE_0096BE:        AD 09 01      LDA.W $0109               
CODE_0096C1:        D0 08         BNE CODE_0096CB           
CODE_0096C3:        20 0E 81      JSR.W UploadMusicBank1    
CODE_0096C6:        A9 01         LDA.B #$01                ; \ Set title screen music 
CODE_0096C8:        8D FB 1D      STA.W $1DFB               ; / 
CODE_0096CB:        A9 EB         LDA.B #$EB                
CODE_0096CD:        A0 00         LDY.B #$00                
CODE_0096CF:        8D 09 01      STA.W $0109               
CODE_0096D2:        8C 11 1F      STY.W $1F11               
CODE_0096D5:        9C 00 42      STZ.W $4200               ; NMI, V/H Count, and Joypad Enable
CODE_0096D8:        20 2D F6      JSR.W NoButtons           
CODE_0096DB:        AD 1A 14      LDA.W $141A               
CODE_0096DE:        D0 09         BNE CODE_0096E9           
CODE_0096E0:        AD 1D 14      LDA.W $141D               
CODE_0096E3:        F0 04         BEQ CODE_0096E9           
CODE_0096E5:        22 09 DC 04   JSL.L CODE_04DC09         
CODE_0096E9:        9C D5 13      STZ.W $13D5               
CODE_0096EC:        9C D9 13      STZ.W $13D9               
CODE_0096EF:        A9 50         LDA.B #$50                
CODE_0096F1:        8D D6 13      STA.W $13D6               
CODE_0096F4:        22 96 D7 05   JSL.L CODE_05D796         
CODE_0096F8:        A2 07         LDX.B #$07                
CODE_0096FA:        B5 1A         LDA RAM_ScreenBndryXLo,X  
CODE_0096FC:        9D 62 14      STA.W $1462,X             
CODE_0096FF:        CA            DEX                       
CODE_009700:        10 F8         BPL CODE_0096FA           
CODE_009702:        20 34 81      JSR.W CODE_008134         
CODE_009705:        20 35 A6      JSR.W CODE_00A635         
CODE_009708:        A9 20         LDA.B #$20                
CODE_00970A:        85 5E         STA $5E                   
CODE_00970C:        20 96 A7      JSR.W CODE_00A796         
CODE_00970F:        EE 04 14      INC.W $1404               
CODE_009712:        22 DB F6 00   JSL.L CODE_00F6DB         
CODE_009716:        22 1E 80 05   JSL.L CODE_05801E         
CODE_00971A:        AD 09 01      LDA.W $0109               
CODE_00971D:        F0 09         BEQ CODE_009728           
CODE_00971F:        C9 E9         CMP.B #$E9                
CODE_009721:        D0 1D         BNE CODE_009740           
CODE_009723:        A9 13         LDA.B #$13                
CODE_009725:        8D DA 0D      STA.W $0DDA               
CODE_009728:        AD DA 0D      LDA.W $0DDA               
CODE_00972B:        C9 40         CMP.B #$40                
CODE_00972D:        B0 0C         BCS CODE_00973B           
CODE_00972F:        AC 9B 0D      LDY.W $0D9B               
CODE_009732:        C0 C1         CPY.B #$C1                
CODE_009734:        D0 02         BNE CODE_009738           
CODE_009736:        A9 16         LDA.B #$16                
CODE_009738:        8D FB 1D      STA.W $1DFB               
CODE_00973B:        29 BF         AND.B #$BF                
CODE_00973D:        8D DA 0D      STA.W $0DDA               
CODE_009740:        9C AE 0D      STZ.W $0DAE               
CODE_009743:        9C AF 0D      STZ.W $0DAF               
CODE_009746:        EE 00 01      INC.W RAM_GameMode        
CODE_009749:        4C F7 93      JMP.W Mode04Finish        

CODE_00974C:        20 45 90      JSR.W HexToDec            
Return00974F:       6B            RTL                       

CODE_009750:        20 FA 85      JSR.W CODE_0085FA         
CODE_009753:        20 2D A8      JSR.W CODE_00A82D         
CODE_009756:        4C CA 93      JMP.W CODE_0093CA         

CODE_009759:        22 00 80 7F   JSL.L RAM_7F8000          
CODE_00975D:        AD 3C 14      LDA.W $143C               
CODE_009760:        D0 29         BNE CODE_00978B           
CODE_009762:        CE 3D 14      DEC.W $143D               
CODE_009765:        D0 27         BNE CODE_00978E           
CODE_009767:        AD BE 0D      LDA.W RAM_StatusLives     
CODE_00976A:        10 1C         BPL CODE_009788           
CODE_00976C:        9C C1 0D      STZ.W RAM_OWHasYoshi      
CODE_00976F:        AD B4 0D      LDA.W RAM_PlayerLives     
CODE_009772:        0D B5 0D      ORA.W $0DB5               
CODE_009775:        10 11         BPL CODE_009788           
CODE_009777:        A2 0C         LDX.B #$0C                
CODE_009779:        9E 2F 1F      STZ.W $1F2F,X             
CODE_00977C:        9E 06 00      STZ.W $0006,X             
CODE_00977F:        9E EE 1F      STZ.W $1FEE,X             
CODE_009782:        CA            DEX                       
CODE_009783:        10 F4         BPL CODE_009779           
CODE_009785:        EE C9 13      INC.W $13C9               
CODE_009788:        4C 62 9E      JMP.W CODE_009E62         

CODE_00978B:        38            SEC                       
CODE_00978C:        E9 04         SBC.B #$04                
CODE_00978E:        8D 3C 14      STA.W $143C               
CODE_009791:        18            CLC                       
CODE_009792:        69 A0         ADC.B #$A0                
CODE_009794:        85 00         STA $00                   
CODE_009796:        26 01         ROL $01                   
CODE_009798:        AE 3B 14      LDX.W $143B               
CODE_00979B:        A0 48         LDY.B #$48                
CODE_00979D:        C0 28         CPY.B #$28                
CODE_00979F:        D0 0D         BNE CODE_0097AE           
CODE_0097A1:        A9 78         LDA.B #$78                
CODE_0097A3:        38            SEC                       
CODE_0097A4:        ED 3C 14      SBC.W $143C               
CODE_0097A7:        85 00         STA $00                   
CODE_0097A9:        2A            ROL                       
CODE_0097AA:        49 01         EOR.B #$01                
CODE_0097AC:        85 01         STA $01                   
CODE_0097AE:        20 E9 91      JSR.W CODE_0091E9         
CODE_0097B1:        E8            INX                       
CODE_0097B2:        98            TYA                       
CODE_0097B3:        38            SEC                       
CODE_0097B4:        E9 08         SBC.B #$08                
CODE_0097B6:        A8            TAY                       
CODE_0097B7:        D0 E4         BNE CODE_00979D           
CODE_0097B9:        4C 94 84      JMP.W CODE_008494         

CODE_0097BC:        A9 0F         LDA.B #$0F                
CODE_0097BE:        8D AE 0D      STA.W $0DAE               ; Set brightness to full (RAM mirror) 
CODE_0097C1:        9C B0 0D      STZ.W $0DB0               
CODE_0097C4:        20 5B 9F      JSR.W GM++Mosaic          
CODE_0097C7:        A9 20         LDA.B #$20                ; \ 
CODE_0097C9:        85 38         STA $38                   ; |Not sure what these bytes are used for yet, unless they're just more  
CODE_0097CB:        85 39         STA $39                   ; /scratch (I find that unlikely) 
CODE_0097CD:        9C 88 18      STZ.W RAM_Layer1DispYLo   
CODE_0097D0:        20 FA 85      JSR.W CODE_0085FA         
CODE_0097D3:        A9 FF         LDA.B #$FF                
CODE_0097D5:        8D 31 19      STA.W $1931               
CODE_0097D8:        22 58 D9 03   JSL.L CODE_03D958         
CODE_0097DC:        2C 9B 0D      BIT.W $0D9B               
CODE_0097DF:        50 20         BVC CODE_009801           
CODE_0097E1:        20 25 99      JSR.W CODE_009925         
CODE_0097E4:        AC FC 13      LDY.W $13FC               
CODE_0097E7:        C0 03         CPY.B #$03                
CODE_0097E9:        90 06         BCC CODE_0097F1           
CODE_0097EB:        D0 4E         BNE CODE_00983B           
CODE_0097ED:        A9 18         LDA.B #$18                
CODE_0097EF:        80 0B         BRA CODE_0097FC           

CODE_0097F1:        A9 03         LDA.B #$03                
CODE_0097F3:        8D F9 13      STA.W RAM_IsBehindScenery 
CODE_0097F6:        A9 C8         LDA.B #$C8                
CODE_0097F8:        85 3F         STA $3F                   
CODE_0097FA:        A9 12         LDA.B #$12                
CODE_0097FC:        CE 31 19      DEC.W $1931               
CODE_0097FF:        80 3C         BRA CODE_00983D           

CODE_009801:        20 D9 AD      JSR.W CODE_00ADD9         
CODE_009804:        20 A8 92      JSR.W CODE_0092A8         
CODE_009807:        A2 50         LDX.B #$50                
CODE_009809:        20 3D 9A      JSR.W CODE_009A3D         
CODE_00980C:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00980E:        A9 50 00      LDA.W #$0050              
CODE_009811:        85 94         STA RAM_MarioXPos         
CODE_009813:        A9 D0 FF      LDA.W #$FFD0              
CODE_009816:        85 96         STA RAM_MarioYPos         
CODE_009818:        64 1A         STZ RAM_ScreenBndryXLo    
CODE_00981A:        9C 62 14      STZ.W $1462               
CODE_00981D:        A9 90 FF      LDA.W #$FF90              
CODE_009820:        85 1C         STA RAM_ScreenBndryYLo    
CODE_009822:        8D 64 14      STA.W $1464               
CODE_009825:        A9 80 00      LDA.W #$0080              
CODE_009828:        85 2A         STA $2A                   
CODE_00982A:        A9 50 00      LDA.W #$0050              
CODE_00982D:        85 2C         STA $2C                   
CODE_00982F:        A9 80 00      LDA.W #$0080              
CODE_009832:        85 3A         STA $3A                   
CODE_009834:        A9 10 00      LDA.W #$0010              
CODE_009837:        85 3C         STA $3C                   
CODE_009839:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00983B:        A9 13         LDA.B #$13                
CODE_00983D:        8D 2B 19      STA.W $192B               
CODE_009840:        20 DA A9      JSR.W UploadSpriteGFX     
CODE_009843:        A9 11         LDA.B #$11                
CODE_009845:        8D 2E 21      STA.W $212E               ; Window Mask Designation for Main Screen
CODE_009848:        9C 2D 21      STZ.W $212D               ; Sub Screen Designation
CODE_00984B:        9C 2F 21      STZ.W $212F               ; Window Mask Designation for Sub Screen
CODE_00984E:        A9 02         LDA.B #$02                
CODE_009850:        85 41         STA $41                   
CODE_009852:        A9 32         LDA.B #$32                
CODE_009854:        85 43         STA $43                   
CODE_009856:        A9 20         LDA.B #$20                
CODE_009858:        85 44         STA $44                   
CODE_00985A:        20 FF 8C      JSR.W GM04DoDMA           
CODE_00985D:        20 CD 8A      JSR.W CODE_008ACD         
CODE_009860:        22 BD E2 00   JSL.L CODE_00E2BD         
CODE_009864:        20 F3 A2      JSR.W CODE_00A2F3         
CODE_009867:        20 93 C5      JSR.W CODE_00C593         
CODE_00986A:        64 7D         STZ RAM_MarioSpeedY       ; Y speed = 0 
CODE_00986C:        22 8C 80 01   JSL.L CODE_01808C         
CODE_009870:        22 00 80 7F   JSL.L RAM_7F8000          
Return009874:       60            RTS                       


DATA_009875:                      .db $01,$00,$FF,$FF,$40,$00,$C0,$01

CODE_00987D:        20 CD 8A      JSR.W CODE_008ACD         
CODE_009880:        2C 9B 0D      BIT.W $0D9B               
CODE_009883:        50 03         BVC CODE_009888           
CODE_009885:        4C 52 9A      JMP.W CODE_009A52         

CODE_009888:        22 00 80 7F   JSL.L RAM_7F8000          
CODE_00988C:        22 C6 C0 03   JSL.L CODE_03C0C6         
Return009890:       60            RTS                       


DATA_009891:                      .db $9E,$12,$1E,$12,$9E,$11,$1E,$11
                                  .db $1E,$16,$9E,$15,$1E,$15,$9E,$14
                                  .db $1E,$14,$9E,$13,$1E,$13,$9E,$16

CODE_0098A9:        AD 9B 0D      LDA.W $0D9B               ; \  
CODE_0098AC:        4A            LSR                       ;  |If "Special level" is even, 
CODE_0098AD:        B0 32         BCS CODE_0098E1           ; / branch to $98E1 
CODE_0098AF:        A5 14         LDA RAM_FrameCounterB     
CODE_0098B1:        4A            LSR                       
CODE_0098B2:        4A            LSR                       
CODE_0098B3:        29 06         AND.B #$06                
CODE_0098B5:        AA            TAX                       
CODE_0098B6:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_0098B8:        A0 80         LDY.B #$80                
CODE_0098BA:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_0098BD:        A9 01 18      LDA.W #$1801              
CODE_0098C0:        8D 20 43      STA.W $4320               ; Parameters for DMA Transfer
CODE_0098C3:        A9 00 78      LDA.W #$7800              
CODE_0098C6:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_0098C9:        BF 39 BA 05   LDA.L DATA_05BA39,X       
CODE_0098CD:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_0098D0:        A0 7E         LDY.B #$7E                
CODE_0098D2:        8C 24 43      STY.W $4324               ; A Address Bank
CODE_0098D5:        A9 80 00      LDA.W #$0080              
CODE_0098D8:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_0098DB:        A0 04         LDY.B #$04                
CODE_0098DD:        8C 0B 42      STY.W $420B               ; Regular DMA Channel Enable
CODE_0098E0:        18            CLC                       
CODE_0098E1:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_0098E3:        A9 04 00      LDA.W #$0004              
CODE_0098E6:        A0 06         LDY.B #$06                
CODE_0098E8:        90 05         BCC CODE_0098EF           
CODE_0098EA:        A9 08 00      LDA.W #$0008              
CODE_0098ED:        A0 16         LDY.B #$16                
CODE_0098EF:        85 00         STA $00                   
CODE_0098F1:        A9 80 C6      LDA.W #$C680              
CODE_0098F4:        85 02         STA $02                   
CODE_0098F6:        9C 15 21      STZ.W $2115               ; VRAM Address Increment Value
CODE_0098F9:        A9 00 18      LDA.W #$1800              
CODE_0098FC:        8D 20 43      STA.W $4320               ; Parameters for DMA Transfer
CODE_0098FF:        A2 7E         LDX.B #$7E                
CODE_009901:        8E 24 43      STX.W $4324               ; A Address Bank
CODE_009904:        A2 04         LDX.B #$04                
CODE_009906:        B9 91 98      LDA.W DATA_009891,Y       
CODE_009909:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00990C:        A5 02         LDA $02                   
CODE_00990E:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_009911:        18            CLC                       
CODE_009912:        65 00         ADC $00                   
CODE_009914:        85 02         STA $02                   
CODE_009916:        A5 00         LDA $00                   
CODE_009918:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00991B:        8E 0B 42      STX.W $420B               ; Regular DMA Channel Enable
CODE_00991E:        88            DEY                       
CODE_00991F:        88            DEY                       
CODE_009920:        10 E4         BPL CODE_009906           
CODE_009922:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
Return009924:       60            RTS                       

CODE_009925:        64 97         STZ RAM_MarioYPosHi       
CODE_009927:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_009929:        A9 20 00      LDA.W #$0020              
CODE_00992C:        85 94         STA RAM_MarioXPos         
CODE_00992E:        64 1A         STZ RAM_ScreenBndryXLo    
CODE_009930:        9C 62 14      STZ.W $1462               
CODE_009933:        64 1C         STZ RAM_ScreenBndryYLo    
CODE_009935:        9C 64 14      STZ.W $1464               
CODE_009938:        A9 80 00      LDA.W #$0080              
CODE_00993B:        85 2A         STA $2A                   
CODE_00993D:        A9 A0 00      LDA.W #$00A0              
CODE_009940:        85 2C         STA $2C                   
CODE_009942:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_009944:        20 15 AE      JSR.W CODE_00AE15         
CODE_009947:        22 8C 80 01   JSL.L CODE_01808C         
CODE_00994B:        AD 9B 0D      LDA.W $0D9B               
CODE_00994E:        4A            LSR                       
CODE_00994F:        A2 C0         LDX.B #$C0                
CODE_009951:        A9 A0         LDA.B #$A0                
CODE_009953:        90 06         BCC CODE_00995B           
CODE_009955:        9C 11 14      STZ.W $1411               
CODE_009958:        4C 17 9A      JMP.W CODE_009A17         

CODE_00995B:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00995D:        AD FC 13      LDA.W $13FC               
CODE_009960:        29 FF 00      AND.W #$00FF              
CODE_009963:        0A            ASL                       
CODE_009964:        AA            TAX                       
CODE_009965:        A0 C0 02      LDY.W #$02C0              
CODE_009968:        BD E8 F8      LDA.W DATA_00F8E8,X       
CODE_00996B:        10 03         BPL CODE_009970           
CODE_00996D:        A0 80 FB      LDY.W #$FB80              
CODE_009970:        C9 12 00      CMP.W #$0012              
CODE_009973:        D0 03         BNE CODE_009978           
CODE_009975:        A0 20 03      LDY.W #$0320              
CODE_009978:        84 00         STY $00                   
CODE_00997A:        A2 00 00      LDX.W #$0000              
CODE_00997D:        A9 5A C0      LDA.W #$C05A              
CODE_009980:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_009984:        EB            XBA                       
CODE_009985:        18            CLC                       
CODE_009986:        69 80 00      ADC.W #$0080              
CODE_009989:        EB            XBA                       
CODE_00998A:        9F 01 84 7F   STA.L $7F8401,X           
CODE_00998E:        EB            XBA                       
CODE_00998F:        38            SEC                       
CODE_009990:        E5 00         SBC $00                   
CODE_009992:        EB            XBA                       
CODE_009993:        9F 85 84 7F   STA.L $7F8485,X           
CODE_009997:        A9 00 7F      LDA.W #$7F00              
CODE_00999A:        9F 7F 83 7F   STA.L $7F837F,X           
CODE_00999E:        9F 03 84 7F   STA.L $7F8403,X           
CODE_0099A2:        9F 87 84 7F   STA.L $7F8487,X           
CODE_0099A6:        A0 10 00      LDY.W #$0010              
CODE_0099A9:        A9 A2 38      LDA.W #$38A2              
CODE_0099AC:        9F 81 83 7F   STA.L $7F8381,X           
CODE_0099B0:        1A            INC A                     
CODE_0099B1:        9F 83 83 7F   STA.L $7F8383,X           
CODE_0099B5:        A9 B2 38      LDA.W #$38B2              
CODE_0099B8:        9F C1 83 7F   STA.L $7F83C1,X           
CODE_0099BC:        1A            INC A                     
CODE_0099BD:        9F C3 83 7F   STA.L $7F83C3,X           
CODE_0099C1:        A9 80 2C      LDA.W #$2C80              
CODE_0099C4:        9F 05 84 7F   STA.L $7F8405,X           
CODE_0099C8:        1A            INC A                     
CODE_0099C9:        9F 07 84 7F   STA.L $7F8407,X           
CODE_0099CD:        1A            INC A                     
CODE_0099CE:        9F 45 84 7F   STA.L $7F8445,X           
CODE_0099D2:        1A            INC A                     
CODE_0099D3:        9F 47 84 7F   STA.L $7F8447,X           
CODE_0099D7:        A9 A0 28      LDA.W #$28A0              
CODE_0099DA:        9F 89 84 7F   STA.L $7F8489,X           
CODE_0099DE:        1A            INC A                     
CODE_0099DF:        9F 8B 84 7F   STA.L $7F848B,X           
CODE_0099E3:        A9 B0 28      LDA.W #$28B0              
CODE_0099E6:        9F C9 84 7F   STA.L $7F84C9,X           
CODE_0099EA:        1A            INC A                     
CODE_0099EB:        9F CB 84 7F   STA.L $7F84CB,X           
CODE_0099EF:        E8            INX                       
CODE_0099F0:        E8            INX                       
CODE_0099F1:        E8            INX                       
CODE_0099F2:        E8            INX                       
CODE_0099F3:        88            DEY                       
CODE_0099F4:        D0 B3         BNE CODE_0099A9           
CODE_0099F6:        8A            TXA                       
CODE_0099F7:        18            CLC                       
CODE_0099F8:        69 4C 01      ADC.W #$014C              
CODE_0099FB:        AA            TAX                       
CODE_0099FC:        A9 5E C0      LDA.W #$C05E              
CODE_0099FF:        E0 18 03      CPX.W #$0318              
CODE_009A02:        B0 03         BCS CODE_009A07           
CODE_009A04:        4C 80 99      JMP.W CODE_009980         

CODE_009A07:        A9 FF 00      LDA.W #$00FF              
CODE_009A0A:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_009A0E:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_009A10:        20 D2 85      JSR.W LoadScrnImage       
CODE_009A13:        A2 B0         LDX.B #$B0                
CODE_009A15:        A9 90         LDA.B #$90                
CODE_009A17:        85 96         STA RAM_MarioYPos         
CODE_009A19:        20 1F 9A      JSR.W CODE_009A1F         
CODE_009A1C:        4C 83 92      JMP.W CODE_009283         

CODE_009A1F:        A0 10         LDY.B #$10                
CODE_009A21:        A9 32         LDA.B #$32                
CODE_009A23:        9F 00 C8 7E   STA.L $7EC800,X           
CODE_009A27:        9F B0 C9 7E   STA.L $7EC9B0,X           
CODE_009A2B:        9F 00 C8 7F   STA.L $7FC800,X           
CODE_009A2F:        9F B0 C9 7F   STA.L $7FC9B0,X           
CODE_009A33:        E8            INX                       
CODE_009A34:        88            DEY                       
CODE_009A35:        D0 EC         BNE CODE_009A23           
CODE_009A37:        E0 C0         CPX.B #$C0                
CODE_009A39:        D0 12         BNE Return009A4D          
CODE_009A3B:        A2 D0         LDX.B #$D0                
CODE_009A3D:        A0 10         LDY.B #$10                
CODE_009A3F:        A9 05         LDA.B #$05                
CODE_009A41:        9F 00 C8 7E   STA.L $7EC800,X           
CODE_009A45:        9F B0 C9 7E   STA.L $7EC9B0,X           
CODE_009A49:        E8            INX                       
CODE_009A4A:        88            DEY                       
CODE_009A4B:        D0 F4         BNE CODE_009A41           
Return009A4D:       60            RTS                       


DATA_009A4E:                      .db $FF,$01,$18,$30

CODE_009A52:        AD 9B 0D      LDA.W $0D9B               
CODE_009A55:        4A            LSR                       
CODE_009A56:        B0 17         BCS CODE_009A6F           
CODE_009A58:        22 DB F6 00   JSL.L CODE_00F6DB         
CODE_009A5C:        22 00 BC 05   JSL.L CODE_05BC00         
CODE_009A60:        AD FC 13      LDA.W $13FC               
CODE_009A63:        C9 04         CMP.B #$04                
CODE_009A65:        F0 08         BEQ CODE_009A6F           
CODE_009A67:        20 C7 86      JSR.W CODE_0086C7         
CODE_009A6A:        22 7D 82 02   JSL.L CODE_02827D         
Return009A6E:       60            RTS                       

CODE_009A6F:        22 00 80 7F   JSL.L RAM_7F8000          
Return009A73:       60            RTS                       

SetUp0DA0GM4:       AD 16 40      LDA.W $4016               ; \Read old-style controller register for player 1 
CODE_009A77:        4A            LSR                       ; /LSR A, but then discard (Is this for carry flag or something?) 
CODE_009A78:        AD 17 40      LDA.W $4017               ; \Load And Rotate left A (player 2 old-style controller regs) 
CODE_009A7B:        2A            ROL                       ; / 
CODE_009A7C:        29 03         AND.B #$03                ; AND A with #$03 
CODE_009A7E:        F0 07         BEQ CODE_009A87           ; If A AND #$03 = 0 Then STA $0DA0 (A=0) 
CODE_009A80:        C9 03         CMP.B #$03                
CODE_009A82:        D0 02         BNE CODE_009A86           
ADDR_009A84:        09 80         ORA.B #$80                
CODE_009A86:        3A            DEC A                     
CODE_009A87:        8D A0 0D      STA.W $0DA0               
Return009A8A:       60            RTS                       ; *yawn* 

CODE_009A8B:        20 74 9A      JSR.W SetUp0DA0GM4        
CODE_009A8E:        20 9C A5      JSR.W GM04Load            
CODE_009A91:        9C 31 0F      STZ.W $0F31               ; Zero the timer 
CODE_009A94:        20 FA 85      JSR.W CODE_0085FA         
CODE_009A97:        A9 03         LDA.B #$03                ; \ Load title screen Layer 3 image 
CODE_009A99:        85 12         STA $12                   ;  | 
CODE_009A9B:        20 D2 85      JSR.W LoadScrnImage       ; /  
CODE_009A9E:        20 A6 AD      JSR.W CODE_00ADA6         
CODE_009AA1:        20 2F 92      JSR.W CODE_00922F         
CODE_009AA4:        22 75 F6 04   JSL.L CODE_04F675         ; todo: NOTE TO SELF: Check this routine out after making Bank4.asm 
CODE_009AA8:        A9 01         LDA.B #$01                ; \ Set special level to x01 
CODE_009AAA:        8D 9B 0D      STA.W $0D9B               ; /  
CODE_009AAD:        A9 33         LDA.B #$33                
CODE_009AAF:        85 41         STA $41                   
CODE_009AB1:        A9 00         LDA.B #$00                
CODE_009AB3:        85 42         STA $42                   
CODE_009AB5:        A9 23         LDA.B #$23                
CODE_009AB7:        85 43         STA $43                   
CODE_009AB9:        A9 12         LDA.B #$12                
CODE_009ABB:        85 44         STA $44                   
CODE_009ABD:        20 43 94      JSR.W CODE_009443         
CODE_009AC0:        A9 10         LDA.B #$10                
CODE_009AC2:        8D F5 1D      STA.W $1DF5               
CODE_009AC5:        4C F7 93      JMP.W Mode04Finish        


DATA_009AC8:                      .db $01,$FF,$FF

CODE_009ACB:        5A            PHY                       
CODE_009ACC:        20 74 9A      JSR.W SetUp0DA0GM4        
CODE_009ACF:        7A            PLY                       
CODE_009AD0:        EE 91 1B      INC.W $1B91               ; Blinking cursor frame counter (file select, save prompt, etc) 
CODE_009AD3:        20 82 9E      JSR.W CODE_009E82         
CODE_009AD6:        AE 92 1B      LDX.W $1B92               
CODE_009AD9:        A5 16         LDA $16                   
CODE_009ADB:        29 90         AND.B #$90                
CODE_009ADD:        D0 04         BNE CODE_009AE3           
CODE_009ADF:        A5 18         LDA $18                   
CODE_009AE1:        10 07         BPL CODE_009AEA           
CODE_009AE3:        A9 01         LDA.B #$01                
CODE_009AE5:        8D FC 1D      STA.W $1DFC               
CODE_009AE8:        80 27         BRA CODE_009B11           

CODE_009AEA:        68            PLA                       
CODE_009AEB:        68            PLA                       
CODE_009AEC:        A5 16         LDA $16                   
CODE_009AEE:        29 20         AND.B #$20                
CODE_009AF0:        4A            LSR                       
CODE_009AF1:        4A            LSR                       
CODE_009AF2:        4A            LSR                       
CODE_009AF3:        05 16         ORA $16                   
CODE_009AF5:        29 0C         AND.B #$0C                
CODE_009AF7:        F0 1D         BEQ Return009B16          
CODE_009AF9:        A0 06         LDY.B #$06                
CODE_009AFB:        8C FC 1D      STY.W $1DFC               
CODE_009AFE:        9C 91 1B      STZ.W $1B91               
CODE_009B01:        4A            LSR                       
CODE_009B02:        4A            LSR                       
CODE_009B03:        A8            TAY                       
CODE_009B04:        8A            TXA                       
CODE_009B05:        79 C7 9A      ADC.W DATA_009AC8-1,Y     
CODE_009B08:        10 03         BPL CODE_009B0D           
CODE_009B0A:        A5 8A         LDA $8A                   
CODE_009B0C:        3A            DEC A                     
CODE_009B0D:        C5 8A         CMP $8A                   
CODE_009B0F:        90 02         BCC CODE_009B13           
CODE_009B11:        A9 00         LDA.B #$00                
CODE_009B13:        8D 92 1B      STA.W $1B92               
Return009B16:       60            RTS                       


DATA_009B17:                      .db $04,$02,$01

CODE_009B1A:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_009B1C:        A9 C9 39      LDA.W #$39C9              
CODE_009B1F:        A0 60         LDY.B #$60                
CODE_009B21:        20 30 9D      JSR.W CODE_009D30         
CODE_009B24:        A5 16         LDA $16                   ; Accum (8 bit) 
CODE_009B26:        05 18         ORA $18                   
CODE_009B28:        29 40         AND.B #$40                
CODE_009B2A:        F0 0C         BEQ CODE_009B38           
CODE_009B2C:        CE 00 01      DEC.W RAM_GameMode        
CODE_009B2F:        CE 00 01      DEC.W RAM_GameMode        
CODE_009B32:        20 11 9B      JSR.W CODE_009B11         
CODE_009B35:        4C B0 9C      JMP.W CODE_009CB0         

CODE_009B38:        A0 08         LDY.B #$08                
CODE_009B3A:        20 D0 9A      JSR.W CODE_009AD0         
CODE_009B3D:        E0 03         CPX.B #$03                
CODE_009B3F:        D0 2C         BNE CODE_009B6D           
CODE_009B41:        A0 02         LDY.B #$02                
CODE_009B43:        4E DE 0D      LSR.W $0DDE               
CODE_009B46:        90 1F         BCC CODE_009B67           
CODE_009B48:        5A            PHY                       
CODE_009B49:        B9 CB 9C      LDA.W DATA_009CCB,Y       
CODE_009B4C:        EB            XBA                       
CODE_009B4D:        B9 CE 9C      LDA.W DATA_009CCE,Y       
CODE_009B50:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_009B52:        AA            TAX                       
CODE_009B53:        A0 8F 00      LDY.W #$008F              
CODE_009B56:        A9 00         LDA.B #$00                
CODE_009B58:        9F 00 00 70   STA.L $700000,X           
CODE_009B5C:        9F AD 01 70   STA.L $7001AD,X           
CODE_009B60:        E8            INX                       
CODE_009B61:        88            DEY                       
CODE_009B62:        D0 F4         BNE CODE_009B58           
CODE_009B64:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_009B66:        7A            PLY                       
CODE_009B67:        88            DEY                       
CODE_009B68:        10 D9         BPL CODE_009B43           
CODE_009B6A:        4C 89 9C      JMP.W CODE_009C89         

CODE_009B6D:        8E 92 1B      STX.W $1B92               
CODE_009B70:        BD 17 9B      LDA.W DATA_009B17,X       
CODE_009B73:        0D DE 0D      ORA.W $0DDE               
CODE_009B76:        8D DE 0D      STA.W $0DDE               
CODE_009B79:        85 05         STA $05                   
CODE_009B7B:        A2 00         LDX.B #$00                
CODE_009B7D:        4C 3C 9D      JMP.W CODE_009D3C         

CODE_009B80:        8B            PHB                       ; Wrapper 
CODE_009B81:        4B            PHK                       
CODE_009B82:        AB            PLB                       
CODE_009B83:        20 88 9B      JSR.W CODE_009B88         
CODE_009B86:        AB            PLB                       
Return009B87:       6B            RTL                       

CODE_009B88:        3A            DEC A                     
CODE_009B89:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs009B8D:            91 9B      .dw CODE_009B91           
                       9A 9B      .dw CODE_009B9A           

CODE_009B91:        A0 0C         LDY.B #$0C                
CODE_009B93:        20 29 9D      JSR.W CODE_009D29         
CODE_009B96:        EE C9 13      INC.W $13C9               
Return009B99:       60            RTS                       

CODE_009B9A:        A0 00         LDY.B #$00                
CODE_009B9C:        20 D0 9A      JSR.W CODE_009AD0         
CODE_009B9F:        8A            TXA                       
CODE_009BA0:        D0 03         BNE ADDR_009BA5           
CODE_009BA2:        4C 17 9E      JMP.W CODE_009E17         

ADDR_009BA5:        4C 89 9C      JMP.W CODE_009C89         

CODE_009BA8:        8B            PHB                       ; Wrapper 
CODE_009BA9:        4B            PHK                       
CODE_009BAA:        AB            PLB                       
CODE_009BAB:        20 B0 9B      JSR.W CODE_009BB0         
CODE_009BAE:        AB            PLB                       
Return009BAF:       6B            RTL                       

CODE_009BB0:        A0 06         LDY.B #$06                
CODE_009BB2:        20 D0 9A      JSR.W CODE_009AD0         
CODE_009BB5:        8A            TXA                       
CODE_009BB6:        D0 0C         BNE CODE_009BC4           
CODE_009BB8:        9C FC 1D      STZ.W $1DFC               
CODE_009BBB:        A9 05         LDA.B #$05                
CODE_009BBD:        8D F9 1D      STA.W $1DF9               
CODE_009BC0:        22 C9 9B 00   JSL.L CODE_009BC9         
CODE_009BC4:        22 13 9C 00   JSL.L CODE_009C13         
Return009BC8:       60            RTS                       

CODE_009BC9:        8B            PHB                       
CODE_009BCA:        4B            PHK                       
CODE_009BCB:        AB            PLB                       
CODE_009BCC:        AE 0A 01      LDX.W $010A               
CODE_009BCF:        BD CB 9C      LDA.W DATA_009CCB,X       
CODE_009BD2:        EB            XBA                       
CODE_009BD3:        BD CE 9C      LDA.W DATA_009CCE,X       
CODE_009BD6:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_009BD8:        AA            TAX                       
CODE_009BD9:        A0 00 00      LDY.W #$0000              
CODE_009BDC:        84 8A         STY $8A                   
CODE_009BDE:        B9 49 1F      LDA.W $1F49,Y             
CODE_009BE1:        9F 00 00 70   STA.L $700000,X           
CODE_009BE5:        18            CLC                       
CODE_009BE6:        65 8A         ADC $8A                   
CODE_009BE8:        85 8A         STA $8A                   
CODE_009BEA:        90 02         BCC CODE_009BEE           
CODE_009BEC:        E6 8B         INC $8B                   
CODE_009BEE:        E8            INX                       
CODE_009BEF:        C8            INY                       
CODE_009BF0:        C0 8D 00      CPY.W #$008D              
CODE_009BF3:        90 E9         BCC CODE_009BDE           
CODE_009BF5:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_009BF7:        A9 5A 5A      LDA.W #$5A5A              
CODE_009BFA:        38            SEC                       
CODE_009BFB:        E5 8A         SBC $8A                   
CODE_009BFD:        9F 00 00 70   STA.L $700000,X           
CODE_009C01:        E0 AD 01      CPX.W #$01AD              
CODE_009C04:        B0 09         BCS CODE_009C0F           
CODE_009C06:        8A            TXA                       
CODE_009C07:        69 20 01      ADC.W #$0120              
CODE_009C0A:        AA            TAX                       
CODE_009C0B:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_009C0D:        80 CA         BRA CODE_009BD9           

CODE_009C0F:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_009C11:        AB            PLB                       
Return009C12:       6B            RTL                       

CODE_009C13:        EE 87 1B      INC.W $1B87               
CODE_009C16:        EE 88 1B      INC.W $1B88               
CODE_009C19:        A0 1B         LDY.B #$1B                

Instr009C1B:                      .db $20,$29,$9D

Return009C1E:       6B            RTL                       


IntroControlData:                 .db $41

ItrCntrlrSqnc:                    .db $0F,$C1,$30,$00,$10,$42,$20,$41
                                  .db $70,$81,$11,$00,$80,$82,$0C,$00
                                  .db $30,$C1,$30,$41,$60,$C1,$10,$00
                                  .db $40,$01,$30,$E1,$01,$00,$60,$41
                                  .db $4E,$80,$10,$00,$30,$41,$58,$00
                                  .db $20,$60,$01,$00,$30,$60,$01,$00
                                  .db $30,$60,$01,$00,$30,$60,$01,$00
                                  .db $30,$60,$01,$00,$30,$41,$1A,$C1
                                  .db $30,$00,$30,$FF

GAMEMODE_07:        20 74 9A      JSR.W SetUp0DA0GM4        
CODE_009C67:        20 BE 9C      JSR.W CODE_009CBE         
CODE_009C6A:        D0 33         BNE CODE_009C9F           
CODE_009C6C:        20 2D F6      JSR.W NoButtons           ; Zero controller RAM mirror 
CODE_009C6F:        AE F4 1D      LDX.W $1DF4               ; (Unknown byte) -> X 
CODE_009C72:        CE F5 1D      DEC.W $1DF5               ; Decrement $1DF5 (unknown byte) 
CODE_009C75:        D0 0B         BNE CODE_009C82           ; if !=  0 branch forward 
CODE_009C77:        BD 20 9C      LDA.W ItrCntrlrSqnc,X     ; Load $00/9C20,$1DF4 
CODE_009C7A:        8D F5 1D      STA.W $1DF5               ; And store to $1DF5 
CODE_009C7D:        E8            INX                       
CODE_009C7E:        E8            INX                       ; $1DF4+=2 
CODE_009C7F:        8E F4 1D      STX.W $1DF4               
CODE_009C82:        BD 1D 9C      LDA.W ADDR_009C1D,X       ; With the +=2 above, this is effectively LDA $9C20,$1DF4 
CODE_009C85:        C9 FF         CMP.B #$FF                
CODE_009C87:        D0 06         BNE CODE_009C8F           
CODE_009C89:        A0 02         LDY.B #$02                ; If = #$FF, switch to game mode #$02... 
CODE_009C8B:        8C 00 01      STY.W RAM_GameMode        
Return009C8E:       60            RTS                       ; ...And finish 

CODE_009C8F:        29 DF         AND.B #$DF                
CODE_009C91:        85 15         STA RAM_ControllerA       ; Write to controller RAM byte 01 
CODE_009C93:        DD 1D 9C      CMP.W ADDR_009C1D,X       
CODE_009C96:        D0 02         BNE CODE_009C9A           
CODE_009C98:        29 9F         AND.B #$9F                
CODE_009C9A:        85 16         STA $16                   ; Write to byte 01, Just-pressed variant 
CODE_009C9C:        4C DA A1      JMP.W CODE_00A1DA         ; Jump to another section of this routine 

CODE_009C9F:        22 00 80 7F   JSL.L RAM_7F8000          ; IIRC, this contains a lot of STZ instructions 
CODE_009CA3:        A9 04         LDA.B #$04                
CODE_009CA5:        8D 2C 21      STA.W $212C               ; Zero something related to PPU ; Background and Object Enable
CODE_009CA8:        A9 13         LDA.B #$13                
CODE_009CAA:        8D 2D 21      STA.W $212D               ; Sub Screen Designation
CODE_009CAD:        9C 9F 0D      STZ.W $0D9F               ; Disable all HDMA 
CODE_009CB0:        A9 E9         LDA.B #$E9                
CODE_009CB2:        8D 09 01      STA.W $0109               ; #$E9 -> Uknown RAM byte 
CODE_009CB5:        20 06 9F      JSR.W CODE_WRITEOW        
CODE_009CB8:        20 38 9D      JSR.W CODE_009D38         ; -> here 
CODE_009CBB:        4C 17 94      JMP.W CODE_009417         ; Increase the Game mode and return (at jump point) 

CODE_009CBE:        A5 17         LDA RAM_ControllerB       
CODE_009CC0:        29 C0         AND.B #$C0                
CODE_009CC2:        D0 06         BNE Return009CCA          
CODE_009CC4:        A5 15         LDA RAM_ControllerA       
CODE_009CC6:        29 F0         AND.B #$F0                
CODE_009CC8:        D0 00         BNE Return009CCA          
Return009CCA:       60            RTS                       


DATA_009CCB:                      .db $00,$00,$01

DATA_009CCE:                      .db $00,$8F,$1E

CODE_009CD1:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_009CD3:        A9 93 73      LDA.W #$7393              
CODE_009CD6:        A0 20         LDY.B #$20                
CODE_009CD8:        20 30 9D      JSR.W CODE_009D30         
CODE_009CDB:        A0 02         LDY.B #$02                
CODE_009CDD:        20 CB 9A      JSR.W CODE_009ACB         
CODE_009CE0:        EE 00 01      INC.W RAM_GameMode        
CODE_009CE3:        E0 03         CPX.B #$03                
CODE_009CE5:        D0 08         BNE CODE_009CEF           
CODE_009CE7:        9C DE 0D      STZ.W $0DDE               
CODE_009CEA:        A2 00         LDX.B #$00                
CODE_009CEC:        4C 3A 9D      JMP.W CODE_009D3A         

CODE_009CEF:        8E 0A 01      STX.W $010A               ; Index (16 bit) Accum (8 bit) 
CODE_009CF2:        20 B5 9D      JSR.W CODE_009DB5         
CODE_009CF5:        D0 2B         BNE CODE_009D22           
CODE_009CF7:        DA            PHX                       
CODE_009CF8:        9C 09 01      STZ.W $0109               
CODE_009CFB:        A9 8F         LDA.B #$8F                
CODE_009CFD:        85 00         STA $00                   
CODE_009CFF:        BF 00 00 70   LDA.L $700000,X           
CODE_009D03:        DA            PHX                       
CODE_009D04:        BB            TYX                       
CODE_009D05:        9F 00 00 70   STA.L $700000,X           
CODE_009D09:        FA            PLX                       
CODE_009D0A:        E8            INX                       
CODE_009D0B:        C8            INY                       
CODE_009D0C:        C6 00         DEC $00                   
CODE_009D0E:        D0 EF         BNE CODE_009CFF           
CODE_009D10:        FA            PLX                       
CODE_009D11:        A0 00 00      LDY.W #$0000              
CODE_009D14:        BF 00 00 70   LDA.L $700000,X           
CODE_009D18:        99 49 1F      STA.W $1F49,Y             
CODE_009D1B:        E8            INX                       
CODE_009D1C:        C8            INY                       
CODE_009D1D:        C0 8D 00      CPY.W #$008D              
CODE_009D20:        90 F2         BCC CODE_009D14           
CODE_009D22:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_009D24:        A0 12         LDY.B #$12                ; \ Draw 1 PLAYER GAME/2 PLAYER GAME text 
CODE_009D26:        EE 00 01      INC.W RAM_GameMode        ;  |Increase Game Mode 
CODE_009D29:        84 12         STY $12                   ; /  
CODE_009D2B:        A2 00         LDX.B #$00                
CODE_009D2D:        4C D4 9E      JMP.W CODE_009ED4         

CODE_009D30:        8D 01 07      STA.W $0701               ; Store A in BG color 
CODE_009D33:        84 40         STY $40                   ; Store Y in CGADSUB 
CODE_009D35:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
Return009D37:       60            RTS                       

CODE_009D38:        A2 CB         LDX.B #$CB                
CODE_009D3A:        64 05         STZ $05                   
CODE_009D3C:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_009D3E:        A0 00 00      LDY.W #$0000              
CODE_009D41:        BF FE B6 05   LDA.L DATA_05B6FE,X       ; X =  read index 
CODE_009D45:        DA            PHX                       ; Y = write index 
CODE_009D46:        BB            TYX                       
CODE_009D47:        9F 7D 83 7F   STA.L $7F837D,X           ; Layer 3-related table 
CODE_009D4B:        FA            PLX                       
CODE_009D4C:        E8            INX                       
CODE_009D4D:        C8            INY                       
CODE_009D4E:        C0 CC 00      CPY.W #$00CC              ; If not at end of loop, continue 
CODE_009D51:        D0 EE         BNE CODE_009D41           
CODE_009D53:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_009D55:        A9 84         LDA.B #$84                
CODE_009D57:        85 00         STA $00                   
CODE_009D59:        A2 02         LDX.B #$02                
CODE_009D5B:        86 04         STX $04                   
CODE_009D5D:        46 05         LSR $05                   ;  $05 = $05 / 2 
CODE_009D5F:        B0 45         BCS CODE_009DA6           
CODE_009D61:        20 B5 9D      JSR.W CODE_009DB5         
CODE_009D64:        D0 40         BNE CODE_009DA6           
CODE_009D66:        BF 8C 00 70   LDA.L $70008C,X           
CODE_009D6A:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_009D6C:        C9 60         CMP.B #$60                
CODE_009D6E:        90 06         BCC CODE_009D76           
CODE_009D70:        A0 87         LDY.B #$87                
CODE_009D72:        A9 88         LDA.B #$88                
CODE_009D74:        80 04         BRA CODE_009D7A           

CODE_009D76:        20 45 90      JSR.W HexToDec            
CODE_009D79:        9B            TXY                       
CODE_009D7A:        A6 00         LDX $00                   
CODE_009D7C:        9F 81 83 7F   STA.L $7F8381,X           
CODE_009D80:        98            TYA                       
CODE_009D81:        D0 02         BNE CODE_009D85           
CODE_009D83:        A0 FC         LDY.B #$FC                
CODE_009D85:        98            TYA                       
CODE_009D86:        9F 7F 83 7F   STA.L $7F837F,X           
CODE_009D8A:        A9 38         LDA.B #$38                
CODE_009D8C:        9F 80 83 7F   STA.L $7F8380,X           
CODE_009D90:        9F 82 83 7F   STA.L $7F8382,X           
CODE_009D94:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_009D96:        A0 03         LDY.B #$03                
CODE_009D98:        A9 FC 38      LDA.W #$38FC              
CODE_009D9B:        9F 83 83 7F   STA.L $7F8383,X           
CODE_009D9F:        E8            INX                       
CODE_009DA0:        E8            INX                       
CODE_009DA1:        88            DEY                       
CODE_009DA2:        D0 F4         BNE CODE_009D98           
CODE_009DA4:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_009DA6:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_009DA8:        A5 00         LDA $00                   
CODE_009DAA:        38            SEC                       
CODE_009DAB:        E9 24         SBC.B #$24                
CODE_009DAD:        85 00         STA $00                   
CODE_009DAF:        A6 04         LDX $04                   
CODE_009DB1:        CA            DEX                       
CODE_009DB2:        10 A7         BPL CODE_009D5B           
Return009DB4:       60            RTS                       

CODE_009DB5:        BD CB 9C      LDA.W DATA_009CCB,X       
CODE_009DB8:        EB            XBA                       
CODE_009DB9:        BD CE 9C      LDA.W DATA_009CCE,X       
CODE_009DBC:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_009DBE:        AA            TAX                       
CODE_009DBF:        18            CLC                       
CODE_009DC0:        69 AD 01      ADC.W #$01AD              
CODE_009DC3:        A8            TAY                       
CODE_009DC4:        DA            PHX                       
CODE_009DC5:        5A            PHY                       
CODE_009DC6:        BF 8D 00 70   LDA.L $70008D,X           
CODE_009DCA:        85 8A         STA $8A                   
CODE_009DCC:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_009DCE:        A0 8D 00      LDY.W #$008D              
CODE_009DD1:        BF 00 00 70   LDA.L $700000,X           
CODE_009DD5:        18            CLC                       
CODE_009DD6:        65 8A         ADC $8A                   
CODE_009DD8:        85 8A         STA $8A                   
CODE_009DDA:        90 02         BCC CODE_009DDE           
CODE_009DDC:        E6 8B         INC $8B                   
CODE_009DDE:        E8            INX                       
CODE_009DDF:        88            DEY                       
CODE_009DE0:        D0 EF         BNE CODE_009DD1           
CODE_009DE2:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_009DE4:        7A            PLY                       
CODE_009DE5:        FA            PLX                       
CODE_009DE6:        A5 8A         LDA $8A                   
CODE_009DE8:        C9 5A 5A      CMP.W #$5A5A              
CODE_009DEB:        F0 0A         BEQ CODE_009DF7           
CODE_009DED:        E0 AC 01      CPX.W #$01AC              
CODE_009DF0:        B0 05         BCS CODE_009DF7           
CODE_009DF2:        DA            PHX                       
CODE_009DF3:        BB            TYX                       
CODE_009DF4:        7A            PLY                       
CODE_009DF5:        80 CD         BRA CODE_009DC4           

CODE_009DF7:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return009DF9:       60            RTS                       

CODE_009DFA:        A5 16         LDA $16                   ; Index (8 bit) 
CODE_009DFC:        05 18         ORA $18                   
CODE_009DFE:        29 40         AND.B #$40                
CODE_009E00:        F0 06         BEQ CODE_009E08           
CODE_009E02:        CE 00 01      DEC.W RAM_GameMode        
CODE_009E05:        4C 2C 9B      JMP.W CODE_009B2C         

CODE_009E08:        A0 04         LDY.B #$04                
CODE_009E0A:        20 CB 9A      JSR.W CODE_009ACB         
CODE_009E0D:        8E B2 0D      STX.W $0DB2               
CODE_009E10:        20 95 A1      JSR.W CODE_00A195         
CODE_009E13:        22 AD DA 04   JSL.L CODE_04DAAD         
CODE_009E17:        A9 80         LDA.B #$80                
CODE_009E19:        8D FB 1D      STA.W $1DFB               
CODE_009E1C:        A9 FF         LDA.B #$FF                
CODE_009E1E:        8D B5 0D      STA.W $0DB5               
CODE_009E21:        AE B2 0D      LDX.W $0DB2               
CODE_009E24:        A9 04         LDA.B #$04                
CODE_009E26:        9D B4 0D      STA.W RAM_PlayerLives,X   
CODE_009E29:        CA            DEX                       
CODE_009E2A:        10 FA         BPL CODE_009E26           
CODE_009E2C:        8D BE 0D      STA.W RAM_StatusLives     
CODE_009E2F:        9C BF 0D      STZ.W RAM_StatusCoins     
CODE_009E32:        9C C1 0D      STZ.W RAM_OWHasYoshi      
CODE_009E35:        64 19         STZ RAM_MarioPowerUp      
CODE_009E37:        9C C2 0D      STZ.W $0DC2               
CODE_009E3A:        9C C9 13      STZ.W $13C9               
CODE_009E3D:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_009E3F:        9C B6 0D      STZ.W RAM_PlayerCoins     
CODE_009E42:        9C B8 0D      STZ.W RAM_PlayerPowerUp   
CODE_009E45:        9C BA 0D      STZ.W RAM_PlyrYoshiColor  
CODE_009E48:        9C C2 0D      STZ.W $0DC2               
CODE_009E4B:        9C 48 0F      STZ.W $0F48               
CODE_009E4E:        9C 34 0F      STZ.W $0F34               
CODE_009E51:        9C 37 0F      STZ.W $0F37               
CODE_009E54:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_009E56:        9C 36 0F      STZ.W $0F36               
CODE_009E59:        9C 39 0F      STZ.W $0F39               
CODE_009E5C:        9C D5 0D      STZ.W $0DD5               
CODE_009E5F:        9C B3 0D      STZ.W $0DB3               
CODE_009E62:        20 29 9F      JSR.W KeepModeActive      
CODE_009E65:        A0 0B         LDY.B #$0B                
CODE_009E67:        4C 8B 9C      JMP.W CODE_009C8B         


DATA_009E6A:                      .db $02,$00,$04,$00,$02,$00,$02,$00
                                  .db $04,$00

DATA_009E74:                      .db $CB,$51,$E8,$51,$08,$52,$C4,$51
                                  .db $E5,$51

DATA_009E7E:                      .db $01,$02,$04,$08

CODE_009E82:        AE 92 1B      LDX.W $1B92               
CODE_009E85:        BD 7E 9E      LDA.W DATA_009E7E,X       
CODE_009E88:        AA            TAX                       
CODE_009E89:        AD 91 1B      LDA.W $1B91               
CODE_009E8C:        49 1F         EOR.B #$1F                
CODE_009E8E:        29 18         AND.B #$18                
CODE_009E90:        D0 02         BNE CODE_009E94           
CODE_009E92:        A2 00         LDX.B #$00                
CODE_009E94:        86 00         STX $00                   
CODE_009E96:        AF 7B 83 7F   LDA.L $7F837B             
CODE_009E9A:        AA            TAX                       
CODE_009E9B:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_009E9D:        B9 6A 9E      LDA.W DATA_009E6A,Y       
CODE_009EA0:        85 8A         STA $8A                   
CODE_009EA2:        85 02         STA $02                   
CODE_009EA4:        B9 74 9E      LDA.W DATA_009E74,Y       
CODE_009EA7:        EB            XBA                       
CODE_009EA8:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_009EAC:        EB            XBA                       
CODE_009EAD:        18            CLC                       
CODE_009EAE:        69 40 00      ADC.W #$0040              
CODE_009EB1:        48            PHA                       
CODE_009EB2:        A9 00 01      LDA.W #$0100              
CODE_009EB5:        9F 7F 83 7F   STA.L $7F837F,X           
CODE_009EB9:        A9 FC 38      LDA.W #$38FC              
CODE_009EBC:        46 00         LSR $00                   
CODE_009EBE:        90 03         BCC CODE_009EC3           
CODE_009EC0:        A9 2E 3D      LDA.W #$3D2E              
CODE_009EC3:        9F 81 83 7F   STA.L $7F8381,X           
CODE_009EC7:        68            PLA                       
CODE_009EC8:        E8            INX                       
CODE_009EC9:        E8            INX                       
CODE_009ECA:        E8            INX                       
CODE_009ECB:        E8            INX                       
CODE_009ECC:        E8            INX                       
CODE_009ECD:        E8            INX                       
CODE_009ECE:        C6 02         DEC $02                   
CODE_009ED0:        D0 D5         BNE CODE_009EA7           
CODE_009ED2:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_009ED4:        8A            TXA                       
CODE_009ED5:        8F 7B 83 7F   STA.L $7F837B             
CODE_009ED9:        A9 FF         LDA.B #$FF                
CODE_009EDB:        9F 7D 83 7F   STA.L $7F837D,X           
Return009EDF:       60            RTS                       


TBL_009EE0:                       .db $28

DATA_009EE1:                      .db $03,$4D,$01,$52,$01,$53,$01,$5B
                                  .db $08,$5C,$02,$57,$04,$30,$01

TBL_009EF0:                       .db $01,$01,$02,$00,$02,$00,$68,$00
                                  .db $78,$00,$68,$00,$78,$00,$06,$00
                                  .db $07,$00,$06,$00,$07,$00

CODE_WRITEOW:       A2 8D         LDX.B #$8D                ; Index (8 bit) 
CODE_009F08:        9E 48 1F      STZ.W $1F48,X             
CODE_009F0B:        CA            DEX                       
CODE_009F0C:        D0 FA         BNE CODE_009F08           
CODE_009F0E:        A2 0E         LDX.B #$0E                
CODE_009F10:        BC E0 9E      LDY.W TBL_009EE0,X        ; \ 
CODE_009F13:        BD E1 9E      LDA.W DATA_009EE1,X       ; |Write overworld settings to OW L1 table 
CODE_009F16:        99 49 1F      STA.W $1F49,Y             ; / 
CODE_009F19:        CA            DEX                       
CODE_009F1A:        CA            DEX                       
CODE_009F1B:        10 F3         BPL CODE_009F10           
CODE_009F1D:        A2 15         LDX.B #$15                
CODE_009F1F:        BD F0 9E      LDA.W TBL_009EF0,X        
CODE_009F22:        9D B8 1F      STA.W $1FB8,X             ; <- This probably means that the table above ends at 1FB7 
CODE_009F25:        CA            DEX                       
CODE_009F26:        10 F7         BPL CODE_009F1F           
Return009F28:       60            RTS                       

KeepModeActive:     A9 01         LDA.B #$01                
CODE_009F2B:        8D B1 0D      STA.W $0DB1               
Return009F2E:       60            RTS                       


DATA_009F2F:                      .db $01,$FF

DATA_009F31:                      .db $F0,$10

DATA_009F33:                      .db $0F,$00,$00,$F0

TmpFade:            CE B1 0D      DEC.W $0DB1               ; \If 0DB1 = 0 Then Exit Ssub 
CODE_009F3A:        10 32         BPL Return009F6E          ; /Decrease it either way. 
CODE_009F3C:        20 29 9F      JSR.W KeepModeActive      ; #$01 -> $0DB1 
CODE_009F3F:        AC AF 0D      LDY.W $0DAF               
CODE_009F42:        AD B0 0D      LDA.W $0DB0               ; \  
CODE_009F45:        18            CLC                       ;  |Increase $0DB0 (mosaic size) by $9F31,y 
CODE_009F46:        79 31 9F      ADC.W DATA_009F31,Y       ;  | 
CODE_009F49:        8D B0 0D      STA.W $0DB0               ; /  
CODE_009F4C:        AD AE 0D      LDA.W $0DAE               ; Load Brightness byte from RAM 
CODE_009F4F:        18            CLC                       ; \Add $9F2F,Y 
CODE_009F50:        79 2F 9F      ADC.W DATA_009F2F,Y       ; / 
CODE_009F53:        8D AE 0D      STA.W $0DAE               ; Store back to brightness RAM byte 
CODE_009F56:        D9 33 9F      CMP.W DATA_009F33,Y       
CODE_009F59:        D0 0B         BNE CODE_009F66           
GM++Mosaic:         EE 00 01      INC.W RAM_GameMode        ; Game Mode += 1 
CODE_009F5E:        AD AF 0D      LDA.W $0DAF               ; \  
CODE_009F61:        49 01         EOR.B #$01                ;  |$0DAF = $0DAF XOR 1 
CODE_009F63:        8D AF 0D      STA.W $0DAF               ; /  
CODE_009F66:        A9 03         LDA.B #$03                ; \  
CODE_009F68:        0D B0 0D      ORA.W $0DB0               ;  |Set mosaic size to $0DB0, enable mosaic on Layer 1 and 2. 
CODE_009F6B:        8D 06 21      STA.W $2106               ; /  ; Mosaic Size and BG Enable
Return009F6E:       60            RTS                       ; I think we're done here 

CODE_009F6F:        CE B1 0D      DEC.W $0DB1               ; Decrement something...  Seems like it might be a timing counter ; Index (8 bit) 
CODE_009F72:        10 FA         BPL Return009F6E          ; If positive, return from subroutine. 
CODE_009F74:        20 29 9F      JSR.W KeepModeActive      ; Remain in this mode 
CODE_009F77:        AC AF 0D      LDY.W $0DAF               ; $0DAF -> Y, 
CODE_009F7A:        80 D0         BRA CODE_009F4C           ; BRA to the fade control routine 

CODE_009F7C:        CE B1 0D      DEC.W $0DB1               
CODE_009F7F:        10 ED         BPL Return009F6E          
CODE_009F81:        A9 08         LDA.B #$08                
CODE_009F83:        20 2B 9F      JSR.W CODE_009F2B         
CODE_009F86:        80 EF         BRA CODE_009F77           


DATA_009F88:                      .db $01,$02,$C0,$01,$80,$81,$01,$02
                                  .db $C0,$01,$02,$81,$01,$02,$80,$01
                                  .db $02,$81,$01,$02,$81,$01,$02,$C0
                                  .db $01,$02,$C0,$01,$02,$81,$01,$02
                                  .db $80,$01,$02,$80,$01,$02,$80,$01
                                  .db $02,$81,$01,$02,$81,$01,$02,$80

CODE_009FB8:        AD 31 19      LDA.W $1931               ; \  
CODE_009FBB:        0A            ASL                       ;  |Get (Tileset*3), store in $00 
CODE_009FBC:        18            CLC                       ;  | 
CODE_009FBD:        6D 31 19      ADC.W $1931               ;  | 
CODE_009FC0:        85 00         STA $00                   ; /  
CODE_009FC2:        AD E3 1B      LDA.W $1BE3               
CODE_009FC5:        F0 4B         BEQ CODE_00A012           
CODE_009FC7:        3A            DEC A                     
CODE_009FC8:        18            CLC                       
CODE_009FC9:        65 00         ADC $00                   
CODE_009FCB:        AA            TAX                       
CODE_009FCC:        BD 88 9F      LDA.W DATA_009F88,X       
CODE_009FCF:        30 19         BMI CODE_009FEA           
CODE_009FD1:        8D 03 14      STA.W $1403               
CODE_009FD4:        4A            LSR                       
CODE_009FD5:        08            PHP                       
CODE_009FD6:        20 45 A0      JSR.W CODE_00A045         
CODE_009FD9:        A9 70         LDA.B #$70                
CODE_009FDB:        28            PLP                       
CODE_009FDC:        F0 02         BEQ CODE_009FE0           
CODE_009FDE:        A9 40         LDA.B #$40                
CODE_009FE0:        85 24         STA $24                   
CODE_009FE2:        64 25         STZ $25                   
CODE_009FE4:        22 72 BC 05   JSL.L CODE_05BC72         
CODE_009FE8:        80 31         BRA CODE_00A01B           

CODE_009FEA:        0A            ASL                       
CODE_009FEB:        30 25         BMI CODE_00A012           
CODE_009FED:        F0 18         BEQ CODE_00A007           
CODE_009FEF:        AD 31 19      LDA.W $1931               
CODE_009FF2:        C9 01         CMP.B #$01                
CODE_009FF4:        F0 04         BEQ CODE_009FFA           
CODE_009FF6:        C9 03         CMP.B #$03                
CODE_009FF8:        D0 25         BNE CODE_00A01F           
CODE_009FFA:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_009FFC:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_009FFE:        4A            LSR                       
CODE_009FFF:        85 22         STA $22                   
CODE_00A001:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00A003:        A9 C0         LDA.B #$C0                
CODE_00A005:        80 10         BRA CODE_00A017           

CODE_00A007:        A2 07         LDX.B #$07                
CODE_00A009:        BD 6C B6      LDA.W DATA_00B66C,X       
CODE_00A00C:        9D 1B 07      STA.W $071B,X             
CODE_00A00F:        CA            DEX                       
CODE_00A010:        10 F7         BPL CODE_00A009           
CODE_00A012:        EE D5 13      INC.W $13D5               
CODE_00A015:        A9 D0         LDA.B #$D0                
CODE_00A017:        85 24         STA $24                   
CODE_00A019:        64 25         STZ $25                   
CODE_00A01B:        A9 04         LDA.B #$04                
CODE_00A01D:        14 40         TRB $40                   
CODE_00A01F:        AD E3 1B      LDA.W $1BE3               
CODE_00A022:        F0 20         BEQ Return00A044          
CODE_00A024:        3A            DEC A                     
CODE_00A025:        18            CLC                       
CODE_00A026:        65 00         ADC $00                   
CODE_00A028:        85 01         STA $01                   
CODE_00A02A:        0A            ASL                       
CODE_00A02B:        18            CLC                       
CODE_00A02C:        65 01         ADC $01                   
CODE_00A02E:        AA            TAX                       
CODE_00A02F:        BF 00 90 05   LDA.L Layer3Ptr,X         
CODE_00A033:        85 00         STA $00                   
CODE_00A035:        BF 01 90 05   LDA.L Layer3Ptr+1,X       
CODE_00A039:        85 01         STA $01                   
CODE_00A03B:        BF 02 90 05   LDA.L Layer3Ptr+2,X       
CODE_00A03F:        85 02         STA $02                   
CODE_00A041:        20 1E 87      JSR.W CODE_00871E         
Return00A044:       60            RTS                       

CODE_00A045:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00A047:        A2 00 01      LDX.W #$0100              
CODE_00A04A:        A0 58 00      LDY.W #$0058              
CODE_00A04D:        A9 00 00      LDA.W #$0000              
CODE_00A050:        9F 00 E3 7E   STA.L $7EE300,X           
CODE_00A054:        E8            INX                       
CODE_00A055:        E8            INX                       
CODE_00A056:        88            DEY                       
CODE_00A057:        D0 F7         BNE CODE_00A050           
CODE_00A059:        8A            TXA                       
CODE_00A05A:        18            CLC                       
CODE_00A05B:        69 00 01      ADC.W #$0100              
CODE_00A05E:        AA            TAX                       
CODE_00A05F:        E0 00 1B      CPX.W #$1B00              
CODE_00A062:        90 E6         BCC CODE_00A04A           
CODE_00A064:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_00A066:        A9 80         LDA.B #$80                
CODE_00A068:        04 5B         TSB RAM_IsVerticalLvl     
Return00A06A:       60            RTS                       


DATA_00A06B:                      .db $00,$00,$EF,$FF,$EF,$FF,$EF,$FF
                                  .db $F0,$00,$F0,$00,$F0,$00

DATA_00A079:                      .db $00,$00,$D8,$FF,$80,$00,$28,$01
                                  .db $D8,$FF,$80,$00,$28,$01

CODE_00A087:        20 7D 93      JSR.W TurnOffIO           
CODE_00A08A:        AD 9C 1B      LDA.W $1B9C               
CODE_00A08D:        F0 04         BEQ CODE_00A093           
CODE_00A08F:        22 3B 85 04   JSL.L CODE_04853B         
CODE_00A093:        20 A6 A1      JSR.W Clear_1A_13D3       
CODE_00A096:        AD 09 01      LDA.W $0109               
CODE_00A099:        F0 15         BEQ CODE_00A0B0           
CODE_00A09B:        A9 B0         LDA.B #$B0                
CODE_00A09D:        8D F5 1D      STA.W $1DF5               
CODE_00A0A0:        9C 11 1F      STZ.W $1F11               
CODE_00A0A3:        A9 F0         LDA.B #$F0                
CODE_00A0A5:        8D B0 0D      STA.W $0DB0               
CODE_00A0A8:        A9 10         LDA.B #$10                
CODE_00A0AA:        8D 00 01      STA.W RAM_GameMode        
CODE_00A0AD:        4C F7 93      JMP.W Mode04Finish        

CODE_00A0B0:        20 FA 85      JSR.W CODE_0085FA         
CODE_00A0B3:        20 0E 81      JSR.W UploadMusicBank1    
CODE_00A0B6:        20 79 8A      JSR.W SetUpScreen         
CODE_00A0B9:        9C DA 0D      STZ.W $0DDA               
CODE_00A0BC:        AE B3 0D      LDX.W $0DB3               
CODE_00A0BF:        AD BE 0D      LDA.W RAM_StatusLives     
CODE_00A0C2:        10 03         BPL CODE_00A0C7           
CODE_00A0C4:        EE 87 1B      INC.W $1B87               
CODE_00A0C7:        9D B4 0D      STA.W RAM_PlayerLives,X   
CODE_00A0CA:        A5 19         LDA RAM_MarioPowerUp      
CODE_00A0CC:        9D B8 0D      STA.W RAM_PlayerPowerUp,X 
CODE_00A0CF:        AD BF 0D      LDA.W RAM_StatusCoins     
CODE_00A0D2:        9D B6 0D      STA.W RAM_PlayerCoins,X   
CODE_00A0D5:        AD C1 0D      LDA.W RAM_OWHasYoshi      
CODE_00A0D8:        F0 03         BEQ CODE_00A0DD           
CODE_00A0DA:        AD C7 13      LDA.W RAM_YoshiColor      
CODE_00A0DD:        9D BA 0D      STA.W RAM_PlyrYoshiColor,X 
CODE_00A0E0:        AD C2 0D      LDA.W $0DC2               
CODE_00A0E3:        9D BC 0D      STA.W $0DBC,X             
CODE_00A0E6:        A9 03         LDA.B #$03                
CODE_00A0E8:        85 44         STA $44                   
CODE_00A0EA:        A9 30         LDA.B #$30                
CODE_00A0EC:        A2 15         LDX.B #$15                
CODE_00A0EE:        AC C9 13      LDY.W $13C9               
CODE_00A0F1:        F0 28         BEQ CODE_00A11B           
CODE_00A0F3:        20 95 A1      JSR.W CODE_00A195         
CODE_00A0F6:        AD 2E 1F      LDA.W $1F2E               
CODE_00A0F9:        D0 06         BNE CODE_00A101           
CODE_00A0FB:        20 89 9C      JSR.W CODE_009C89         
CODE_00A0FE:        4C F4 93      JMP.W CODE_0093F4         

CODE_00A101:        22 AD DA 04   JSL.L CODE_04DAAD         
CODE_00A105:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00A107:        A9 8C 31      LDA.W #$318C              
CODE_00A10A:        8D 01 07      STA.W $0701               
CODE_00A10D:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00A10F:        A9 30         LDA.B #$30                
CODE_00A111:        85 43         STA $43                   
CODE_00A113:        A9 20         LDA.B #$20                
CODE_00A115:        85 44         STA $44                   
CODE_00A117:        A9 B3         LDA.B #$B3                
CODE_00A119:        A2 17         LDX.B #$17                
CODE_00A11B:        A0 02         LDY.B #$02                
CODE_00A11D:        20 FD 93      JSR.W ScreenSettings      
CODE_00A120:        8E 2E 21      STX.W $212E               ; Window Mask Designation for Main Screen
CODE_00A123:        8C 2F 21      STY.W $212F               ; Window Mask Designation for Sub Screen
CODE_00A126:        22 09 DC 04   JSL.L CODE_04DC09         
CODE_00A12A:        AE B3 0D      LDX.W $0DB3               
CODE_00A12D:        BD 11 1F      LDA.W $1F11,X             
CODE_00A130:        0A            ASL                       
CODE_00A131:        AA            TAX                       
CODE_00A132:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00A134:        BD 6B A0      LDA.W DATA_00A06B,X       
CODE_00A137:        85 1A         STA RAM_ScreenBndryXLo    
CODE_00A139:        85 1E         STA $1E                   
CODE_00A13B:        BD 79 A0      LDA.W DATA_00A079,X       
CODE_00A13E:        85 1C         STA RAM_ScreenBndryYLo    
CODE_00A140:        85 20         STA $20                   
CODE_00A142:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00A144:        20 DA A9      JSR.W UploadSpriteGFX     
CODE_00A147:        A0 14         LDY.B #$14                
CODE_00A149:        22 28 BA 00   JSL.L CODE_00BA28         
CODE_00A14D:        20 25 AD      JSR.W CODE_00AD25         
CODE_00A150:        20 2F 92      JSR.W CODE_00922F         
CODE_00A153:        A9 06         LDA.B #$06                ; \ Load overworld border 
CODE_00A155:        85 12         STA $12                   ;  | 
CODE_00A157:        20 D2 85      JSR.W LoadScrnImage       ; /  
CODE_00A15A:        22 F2 DB 05   JSL.L CODE_05DBF2         
CODE_00A15E:        20 D2 85      JSR.W LoadScrnImage       
CODE_00A161:        22 91 8D 04   JSL.L CODE_048D91         
CODE_00A165:        22 E9 D6 04   JSL.L CODE_04D6E9         
CODE_00A169:        A9 F0         LDA.B #$F0                
CODE_00A16B:        85 3F         STA $3F                   
CODE_00A16D:        20 94 84      JSR.W CODE_008494         
CODE_00A170:        20 D2 85      JSR.W LoadScrnImage       
CODE_00A173:        9C D9 13      STZ.W $13D9               
CODE_00A176:        20 29 9F      JSR.W KeepModeActive      
CODE_00A179:        A9 02         LDA.B #$02                
CODE_00A17B:        8D 9B 0D      STA.W $0D9B               
CODE_00A17E:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_00A180:        A2 BE 01      LDX.W #$01BE              
CODE_00A183:        A9 FF         LDA.B #$FF                
CODE_00A185:        9E A0 04      STZ.W $04A0,X             
CODE_00A188:        9D A1 04      STA.W $04A1,X             
CODE_00A18B:        CA            DEX                       
CODE_00A18C:        CA            DEX                       
CODE_00A18D:        10 F6         BPL CODE_00A185           
CODE_00A18F:        20 A0 92      JSR.W CODE_0092A0         
CODE_00A192:        4C F4 93      JMP.W CODE_0093F4         

CODE_00A195:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_00A197:        A2 8C 00      LDX.W #$008C              
CODE_00A19A:        BD 49 1F      LDA.W $1F49,X             
CODE_00A19D:        9D A2 1E      STA.W $1EA2,X             
CODE_00A1A0:        CA            DEX                       
CODE_00A1A1:        10 F7         BPL CODE_00A19A           
CODE_00A1A3:        E2 10         SEP #$10                  ; Index (8 bit) 
Return00A1A5:       60            RTS                       

Clear_1A_13D3:      C2 10         REP #$10                  ; 16 bit X,Y ; Index (16 bit) 
CODE_00A1A8:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_00A1AA:        A2 BD 00      LDX.W #$00BD              ; \  
CODE_00A1AD:        74 1A         STZ RAM_ScreenBndryXLo,X  ;  |Clear RAM addresses $1A-$D7 
CODE_00A1AF:        CA            DEX                       ;  | 
CODE_00A1B0:        10 FB         BPL CODE_00A1AD           ; /  
CODE_00A1B2:        A2 CE 07      LDX.W #$07CE              ; \  
CODE_00A1B5:        9E D3 13      STZ.W $13D3,X             ;  |Clear RAM addresses $13D3-$1BA1 
CODE_00A1B8:        CA            DEX                       ;  | 
CODE_00A1B9:        10 FA         BPL CODE_00A1B5           ; /  
CODE_00A1BB:        E2 10         SEP #$10                  ; 16 bit X,Y ; Index (8 bit) 
Return00A1BD:       60            RTS                       ; Return 

CODE_00A1BE:        20 74 9A      JSR.W SetUp0DA0GM4        
CODE_00A1C1:        E6 14         INC RAM_FrameCounterB     ; Increase alternate frame counter 
CODE_00A1C3:        22 00 80 7F   JSL.L RAM_7F8000          
CODE_00A1C7:        22 41 82 04   JSL.L GameMode_0E_Prim    ; (Bank 4.asm) 
CODE_00A1CB:        4C 94 84      JMP.W CODE_008494         


GrndShakeDispYLo:                 .db $FE,$00,$02,$00

GrndShakeDispYHi:                 .db $FF,$00,$00,$00

DATA_00A1D6:                      .db $12,$22,$12,$02

CODE_00A1DA:        AD 26 14      LDA.W $1426               
CODE_00A1DD:        F0 05         BEQ CODE_00A1E4           
CODE_00A1DF:        22 0C B1 05   JSL.L CODE_05B10C         
Return00A1E3:       60            RTS                       

CODE_00A1E4:        AD 25 14      LDA.W $1425               
CODE_00A1E7:        F0 17         BEQ CODE_00A200           
CODE_00A1E9:        AD AB 14      LDA.W $14AB               
CODE_00A1EC:        F0 12         BEQ CODE_00A200           
CODE_00A1EE:        C9 40         CMP.B #$40                
CODE_00A1F0:        B0 0E         BCS CODE_00A200           
CODE_00A1F2:        20 2D F6      JSR.W NoButtons           
CODE_00A1F5:        C9 1C         CMP.B #$1C                
CODE_00A1F7:        B0 07         BCS CODE_00A200           
CODE_00A1F9:        20 31 CA      JSR.W SetMarioPeaceImg    
CODE_00A1FC:        A9 0D         LDA.B #$0D                
CODE_00A1FE:        85 71         STA RAM_MarioAnimation    
CODE_00A200:        05 71         ORA RAM_MarioAnimation    
CODE_00A202:        0D 93 14      ORA.W $1493               
CODE_00A205:        F0 0A         BEQ CODE_00A211           
CODE_00A207:        A9 04         LDA.B #$04                
CODE_00A209:        14 15         TRB RAM_ControllerA       
CODE_00A20B:        A9 40         LDA.B #$40                
CODE_00A20D:        14 16         TRB $16                   
CODE_00A20F:        14 18         TRB $18                   
CODE_00A211:        AD D3 13      LDA.W $13D3               
CODE_00A214:        F0 05         BEQ CODE_00A21B           
CODE_00A216:        CE D3 13      DEC.W $13D3               
CODE_00A219:        80 27         BRA CODE_00A242           

CODE_00A21B:        A5 16         LDA $16                   
CODE_00A21D:        29 10         AND.B #$10                
CODE_00A21F:        F0 21         BEQ CODE_00A242           
CODE_00A221:        AD 93 14      LDA.W $1493               
CODE_00A224:        D0 1C         BNE CODE_00A242           
CODE_00A226:        A5 71         LDA RAM_MarioAnimation    
CODE_00A228:        C9 09         CMP.B #$09                
CODE_00A22A:        B0 16         BCS CODE_00A242           
CODE_00A22C:        A9 3C         LDA.B #$3C                
CODE_00A22E:        8D D3 13      STA.W $13D3               
CODE_00A231:        A0 12         LDY.B #$12                
CODE_00A233:        AD D4 13      LDA.W $13D4               
CODE_00A236:        49 01         EOR.B #$01                
CODE_00A238:        8D D4 13      STA.W $13D4               
CODE_00A23B:        F0 02         BEQ CODE_00A23F           
CODE_00A23D:        A0 11         LDY.B #$11                
CODE_00A23F:        8C F9 1D      STY.W $1DF9               
CODE_00A242:        AD D4 13      LDA.W $13D4               
CODE_00A245:        F0 43         BEQ CODE_00A28A           
CODE_00A247:        80 12         BRA CODE_00A25B           

ADDR_00A249:        2C A7 0D      BIT.W $0DA7               ; \ Unreachable 
ADDR_00A24C:        70 0B         BVS ADDR_00A259           ;  | Debug: Slow motion 
ADDR_00A24E:        AD A3 0D      LDA.W $0DA3               ;  | 
ADDR_00A251:        10 08         BPL CODE_00A25B           ;  | 
ADDR_00A253:        A5 13         LDA RAM_FrameCounter      ;  | 
ADDR_00A255:        29 0F         AND.B #$0F                ;  | 
ADDR_00A257:        D0 02         BNE CODE_00A25B           ;  | 
ADDR_00A259:        80 2F         BRA CODE_00A28A           ; / 

CODE_00A25B:        A5 15         LDA RAM_ControllerA       
CODE_00A25D:        29 20         AND.B #$20                
CODE_00A25F:        F0 28         BEQ Return00A289          
CODE_00A261:        AC BF 13      LDY.W $13BF               
CODE_00A264:        B9 A2 1E      LDA.W $1EA2,Y             
CODE_00A267:        10 20         BPL Return00A289          
CODE_00A269:        AD D5 0D      LDA.W $0DD5               
CODE_00A26C:        F0 02         BEQ CODE_00A270           
ADDR_00A26E:        10 19         BPL Return00A289          
CODE_00A270:        A9 80         LDA.B #$80                
CODE_00A272:        80 0A         BRA CODE_00A27E           

ADDR_00A274:        A9 01         LDA.B #$01                ; \ Unreachable 
ADDR_00A276:        24 15         BIT RAM_ControllerA       ;  | Debug: Beat level with Start+Select 
ADDR_00A278:        10 01         BPL ADDR_00A27B           ;  | 
ADDR_00A27A:        1A            INC A                     ; / 
ADDR_00A27B:        8D CE 13      STA.W $13CE               
CODE_00A27E:        8D D5 0D      STA.W $0DD5               
CODE_00A281:        EE E9 1D      INC.W $1DE9               
CODE_00A284:        A9 0B         LDA.B #$0B                
CODE_00A286:        8D 00 01      STA.W RAM_GameMode        
Return00A289:       60            RTS                       

CODE_00A28A:        AD 9B 0D      LDA.W $0D9B               
CODE_00A28D:        10 06         BPL CODE_00A295           
CODE_00A28F:        20 7D 98      JSR.W CODE_00987D         
CODE_00A292:        4C A9 A2      JMP.W CODE_00A2A9         

CODE_00A295:        22 00 80 7F   JSL.L RAM_7F8000          
CODE_00A299:        22 DB F6 00   JSL.L CODE_00F6DB         
CODE_00A29D:        22 00 BC 05   JSL.L CODE_05BC00         
CODE_00A2A1:        22 F1 86 05   JSL.L CODE_0586F1         
CODE_00A2A5:        22 39 BB 05   JSL.L CODE_05BB39         
CODE_00A2A9:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_00A2AB:        48            PHA                       
CODE_00A2AC:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_00A2AE:        48            PHA                       
CODE_00A2AF:        9C 88 18      STZ.W RAM_Layer1DispYLo   ; \ Reset amout to shift level 
CODE_00A2B2:        9C 89 18      STZ.W RAM_Layer1DispYHi   ; / 
CODE_00A2B5:        AD 87 18      LDA.W RAM_ShakeGrndTimer  ; \ If shake ground timer is set 
CODE_00A2B8:        F0 1B         BEQ CODE_00A2D5           ;  | 
CODE_00A2BA:        CE 87 18      DEC.W RAM_ShakeGrndTimer  ;  | Decrement timer 
CODE_00A2BD:        29 03         AND.B #$03                ;  | 
CODE_00A2BF:        A8            TAY                       ;  | 
CODE_00A2C0:        B9 CE A1      LDA.W GrndShakeDispYLo,Y  ;  | 
CODE_00A2C3:        8D 88 18      STA.W RAM_Layer1DispYLo   ;  | $1888-$1889 = Amount to shift level 
CODE_00A2C6:        18            CLC                       ;  | 
CODE_00A2C7:        65 1C         ADC RAM_ScreenBndryYLo    ;  | 
CODE_00A2C9:        85 1C         STA RAM_ScreenBndryYLo    ;  | Adjust screen boundry accordingly 
CODE_00A2CB:        B9 D2 A1      LDA.W GrndShakeDispYHi,Y  ;  | 
CODE_00A2CE:        8D 89 18      STA.W RAM_Layer1DispYHi   ;  | 
CODE_00A2D1:        65 1D         ADC RAM_ScreenBndryYHi    ;  | 
CODE_00A2D3:        85 1D         STA RAM_ScreenBndryYHi    ; / 
CODE_00A2D5:        20 1A 8E      JSR.W CODE_008E1A         
CODE_00A2D8:        22 BD E2 00   JSL.L CODE_00E2BD         
CODE_00A2DC:        20 F3 A2      JSR.W CODE_00A2F3         
CODE_00A2DF:        20 7E C4      JSR.W CODE_00C47E         
CODE_00A2E2:        22 8C 80 01   JSL.L CODE_01808C         
CODE_00A2E6:        22 B1 8A 02   JSL.L CODE_028AB1         
CODE_00A2EA:        68            PLA                       
CODE_00A2EB:        85 1D         STA RAM_ScreenBndryYHi    
CODE_00A2ED:        68            PLA                       
CODE_00A2EE:        85 1C         STA RAM_ScreenBndryYLo    
CODE_00A2F0:        4C 94 84      JMP.W CODE_008494         

CODE_00A2F3:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00A2F5:        A5 94         LDA RAM_MarioXPos         
CODE_00A2F7:        85 D1         STA $D1                   
CODE_00A2F9:        A5 96         LDA RAM_MarioYPos         
CODE_00A2FB:        85 D3         STA $D3                   
CODE_00A2FD:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return00A2FF:       60            RTS                       

MarioGFXDMA:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_00A302:        A2 04         LDX.B #$04                ; We're using DMA channel 2 
CODE_00A304:        AC 84 0D      LDY.W $0D84               
CODE_00A307:        F0 1F         BEQ CODE_00A328           
CODE_00A309:        A0 86         LDY.B #$86                ; \ Set Address for CG-RAM Write to x86 
CODE_00A30B:        8C 21 21      STY.W $2121               ; / ; Address for CG-RAM Write
CODE_00A30E:        A9 00 22      LDA.W #$2200              
CODE_00A311:        8D 20 43      STA.W $4320               ; Parameters for DMA Transfer
CODE_00A314:        AD 82 0D      LDA.W $0D82               ; \ Get location of palette from $0D82-$0D83 
CODE_00A317:        8D 22 43      STA.W $4322               ; / ; A Address (Low Byte)
CODE_00A31A:        A0 00         LDY.B #$00                ; \ Palette is stored in bank x00 
CODE_00A31C:        8C 24 43      STY.W $4324               ; / ; A Address Bank
CODE_00A31F:        A9 14 00      LDA.W #$0014              ; \ x14 bytes will be transferred 
CODE_00A322:        8D 25 43      STA.W $4325               ; / ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A325:        8E 0B 42      STX.W $420B               ; Transfer the colors ; Regular DMA Channel Enable
CODE_00A328:        A0 80         LDY.B #$80                ; \ Set VRAM Address Increment Value to x80 
CODE_00A32A:        8C 15 21      STY.W $2115               ; / ; VRAM Address Increment Value
CODE_00A32D:        A9 01 18      LDA.W #$1801              
CODE_00A330:        8D 20 43      STA.W $4320               ; Parameters for DMA Transfer
CODE_00A333:        A9 F0 67      LDA.W #$67F0              
CODE_00A336:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A339:        AD 99 0D      LDA.W $0D99               
CODE_00A33C:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A33F:        A0 7E         LDY.B #$7E                ; \ Set bank to x7E 
CODE_00A341:        8C 24 43      STY.W $4324               ; / ; A Address Bank
CODE_00A344:        A9 20 00      LDA.W #$0020              ; \ x20 bytes will be transferred 
CODE_00A347:        8D 25 43      STA.W $4325               ; / ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A34A:        8E 0B 42      STX.W $420B               ; Transfer ; Regular DMA Channel Enable
CODE_00A34D:        A9 00 60      LDA.W #$6000              ; \ Set Address for VRAM Read/Write to x6000 
CODE_00A350:        8D 16 21      STA.W $2116               ; / ; Address for VRAM Read/Write (Low Byte)
CODE_00A353:        A2 00         LDX.B #$00                
CODE_00A355:        BD 85 0D      LDA.W $0D85,X             ; \ Get address of graphics to copy 
CODE_00A358:        8D 22 43      STA.W $4322               ; / ; A Address (Low Byte)
CODE_00A35B:        A9 40 00      LDA.W #$0040              ; \ x40 bytes will be transferred 
CODE_00A35E:        8D 25 43      STA.W $4325               ; / ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A361:        A0 04         LDY.B #$04                ; \ Transfer 
CODE_00A363:        8C 0B 42      STY.W $420B               ; / ; Regular DMA Channel Enable
CODE_00A366:        E8            INX                       ; \ Move to next address 
CODE_00A367:        E8            INX                       ; /  
CODE_00A368:        EC 84 0D      CPX.W $0D84               ; \ Repeat last segment while X<$0D84 
CODE_00A36B:        90 E8         BCC CODE_00A355           ; /  
CODE_00A36D:        A9 00 61      LDA.W #$6100              ; \ Set Address for VRAM Read/Write to x6100 
CODE_00A370:        8D 16 21      STA.W $2116               ; / ; Address for VRAM Read/Write (Low Byte)
CODE_00A373:        A2 00         LDX.B #$00                
CODE_00A375:        BD 8F 0D      LDA.W $0D8F,X             ; \ Get address of graphics to copy 
CODE_00A378:        8D 22 43      STA.W $4322               ; / ; A Address (Low Byte)
CODE_00A37B:        A9 40 00      LDA.W #$0040              ; \ x40 bytes will be transferred 
CODE_00A37E:        8D 25 43      STA.W $4325               ; / ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A381:        A0 04         LDY.B #$04                ; \ Transfer 
CODE_00A383:        8C 0B 42      STY.W $420B               ; / ; Regular DMA Channel Enable
CODE_00A386:        E8            INX                       ; \ Move to next address 
CODE_00A387:        E8            INX                       ; /  
CODE_00A388:        EC 84 0D      CPX.W $0D84               ; \ Repeat last segment while X<$0D84 
CODE_00A38B:        90 E8         BCC CODE_00A375           ; /  
CODE_00A38D:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
Return00A38F:       60            RTS                       ; Return 

CODE_00A390:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00A392:        A0 80         LDY.B #$80                
CODE_00A394:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_00A397:        A9 01 18      LDA.W #$1801              
CODE_00A39A:        8D 20 43      STA.W $4320               ; Parameters for DMA Transfer
CODE_00A39D:        A0 7E         LDY.B #$7E                
CODE_00A39F:        8C 24 43      STY.W $4324               ; A Address Bank
CODE_00A3A2:        A2 04         LDX.B #$04                
CODE_00A3A4:        AD 80 0D      LDA.W $0D80               
CODE_00A3A7:        F0 12         BEQ CODE_00A3BB           
CODE_00A3A9:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A3AC:        AD 7A 0D      LDA.W $0D7A               
CODE_00A3AF:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A3B2:        A9 80 00      LDA.W #$0080              
CODE_00A3B5:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A3B8:        8E 0B 42      STX.W $420B               ; Regular DMA Channel Enable
CODE_00A3BB:        AD 7E 0D      LDA.W $0D7E               
CODE_00A3BE:        F0 12         BEQ CODE_00A3D2           
CODE_00A3C0:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A3C3:        AD 78 0D      LDA.W $0D78               
CODE_00A3C6:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A3C9:        A9 80 00      LDA.W #$0080              
CODE_00A3CC:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A3CF:        8E 0B 42      STX.W $420B               ; Regular DMA Channel Enable
CODE_00A3D2:        AD 7C 0D      LDA.W $0D7C               
CODE_00A3D5:        F0 41         BEQ CODE_00A418           
CODE_00A3D7:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A3DA:        C9 00 08      CMP.W #$0800              
CODE_00A3DD:        F0 11         BEQ CODE_00A3F0           
CODE_00A3DF:        AD 76 0D      LDA.W $0D76               
CODE_00A3E2:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A3E5:        A9 80 00      LDA.W #$0080              
CODE_00A3E8:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A3EB:        8E 0B 42      STX.W $420B               ; Regular DMA Channel Enable
CODE_00A3EE:        80 28         BRA CODE_00A418           

CODE_00A3F0:        AD 76 0D      LDA.W $0D76               
CODE_00A3F3:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A3F6:        A9 40 00      LDA.W #$0040              
CODE_00A3F9:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A3FC:        8E 0B 42      STX.W $420B               ; Regular DMA Channel Enable
CODE_00A3FF:        A9 00 09      LDA.W #$0900              
CODE_00A402:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A405:        AD 76 0D      LDA.W $0D76               
CODE_00A408:        18            CLC                       
CODE_00A409:        69 40 00      ADC.W #$0040              
CODE_00A40C:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A40F:        A9 40 00      LDA.W #$0040              
CODE_00A412:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A415:        8E 0B 42      STX.W $420B               ; Regular DMA Channel Enable
CODE_00A418:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00A41A:        A9 64         LDA.B #$64                
CODE_00A41C:        64 00         STZ $00                   
CODE_00A41E:        8D 21 21      STA.W $2121               ; Address for CG-RAM Write
CODE_00A421:        A5 14         LDA RAM_FrameCounterB     
CODE_00A423:        29 1C         AND.B #$1C                
CODE_00A425:        4A            LSR                       
CODE_00A426:        65 00         ADC $00                   
CODE_00A428:        A8            TAY                       
CODE_00A429:        B9 0C B6      LDA.W MorePalettes,Y      
CODE_00A42C:        8D 22 21      STA.W $2122               ; Data for CG-RAM Write
CODE_00A42F:        B9 0D B6      LDA.W DATA_00B60D,Y       
CODE_00A432:        8D 22 21      STA.W $2122               ; Data for CG-RAM Write
Return00A435:       60            RTS                       

CODE_00A436:        AD 35 19      LDA.W $1935               
CODE_00A439:        F0 43         BEQ Return00A47E          
CODE_00A43B:        9C 35 19      STZ.W $1935               
CODE_00A43E:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_00A440:        A0 80         LDY.B #$80                
CODE_00A442:        8C 15 21      STY.W $2115               ; VRAM Address Increment Value
CODE_00A445:        A9 A0 64      LDA.W #$64A0              
CODE_00A448:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A44B:        A9 01 18      LDA.W #$1801              
CODE_00A44E:        8D 20 43      STA.W $4320               ; Parameters for DMA Transfer
CODE_00A451:        A9 F6 0B      LDA.W #$0BF6              
CODE_00A454:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A457:        A0 00         LDY.B #$00                
CODE_00A459:        8C 24 43      STY.W $4324               ; A Address Bank
CODE_00A45C:        A9 C0 00      LDA.W #$00C0              
CODE_00A45F:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A462:        A2 04         LDX.B #$04                
CODE_00A464:        8E 0B 42      STX.W $420B               ; Regular DMA Channel Enable
CODE_00A467:        A9 A0 65      LDA.W #$65A0              
CODE_00A46A:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A46D:        A9 B6 0C      LDA.W #$0CB6              
CODE_00A470:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A473:        A9 C0 00      LDA.W #$00C0              
CODE_00A476:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A479:        8E 0B 42      STX.W $420B               ; Regular DMA Channel Enable
CODE_00A47C:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
Return00A47E:       60            RTS                       


DATA_00A47F:                      .db $82

DATA_00A480:                      .db $06

DATA_00A481:                      .db $00,$05,$09,$00,$03,$07,$00

CODE_00A488:        AC 80 06      LDY.W $0680               
CODE_00A48B:        BE 81 A4      LDX.W DATA_00A481,Y       
CODE_00A48E:        86 02         STX $02                   
CODE_00A490:        64 01         STZ $01                   
CODE_00A492:        64 00         STZ $00                   
CODE_00A494:        64 04         STZ $04                   
CODE_00A496:        B9 80 A4      LDA.W DATA_00A480,Y       
CODE_00A499:        EB            XBA                       
CODE_00A49A:        B9 7F A4      LDA.W DATA_00A47F,Y       
CODE_00A49D:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_00A49F:        A8            TAY                       
CODE_00A4A0:        B7 00         LDA [$00],Y               
CODE_00A4A2:        F0 2B         BEQ CODE_00A4CF           
CODE_00A4A4:        8E 24 43      STX.W $4324               ; A Address Bank
CODE_00A4A7:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A4AA:        85 03         STA $03                   
CODE_00A4AC:        9C 26 43      STZ.W $4326               ; Number Bytes to Transfer (High Byte) (DMA)
CODE_00A4AF:        C8            INY                       
CODE_00A4B0:        B7 00         LDA [$00],Y               
CODE_00A4B2:        8D 21 21      STA.W $2121               ; Address for CG-RAM Write
CODE_00A4B5:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00A4B7:        A9 00 22      LDA.W #$2200              
CODE_00A4BA:        8D 20 43      STA.W $4320               ; Parameters for DMA Transfer
CODE_00A4BD:        C8            INY                       
CODE_00A4BE:        98            TYA                       
CODE_00A4BF:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A4C2:        18            CLC                       
CODE_00A4C3:        65 03         ADC $03                   
CODE_00A4C5:        A8            TAY                       
CODE_00A4C6:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00A4C8:        A9 04         LDA.B #$04                
CODE_00A4CA:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_00A4CD:        80 D1         BRA CODE_00A4A0           

CODE_00A4CF:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_00A4D1:        20 47 AE      JSR.W CODE_00AE47         
CODE_00A4D4:        AD 80 06      LDA.W $0680               
CODE_00A4D7:        D0 06         BNE CODE_00A4DF           
CODE_00A4D9:        9C 81 06      STZ.W $0681               
CODE_00A4DC:        9C 82 06      STZ.W $0682               
CODE_00A4DF:        9C 80 06      STZ.W $0680               
Return00A4E2:       60            RTS                       

CODE_00A4E3:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_00A4E5:        A9 80         LDA.B #$80                
CODE_00A4E7:        8D 15 21      STA.W $2115               ; VRAM Address Increment Value
CODE_00A4EA:        A0 50 07      LDY.W #$0750              
CODE_00A4ED:        8C 16 21      STY.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A4F0:        A0 01 18      LDY.W #$1801              
CODE_00A4F3:        8C 20 43      STY.W $4320               ; Parameters for DMA Transfer
CODE_00A4F6:        A0 F6 0A      LDY.W #$0AF6              
CODE_00A4F9:        8C 22 43      STY.W $4322               ; A Address (Low Byte)
CODE_00A4FC:        9C 24 43      STZ.W $4324               ; A Address Bank
CODE_00A4FF:        A0 60 01      LDY.W #$0160              
CODE_00A502:        8C 25 43      STY.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A505:        A9 04         LDA.B #$04                
CODE_00A507:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_00A50A:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_00A50C:        AD D9 13      LDA.W $13D9               
CODE_00A50F:        C9 0A         CMP.B #$0A                
CODE_00A511:        F0 CF         BEQ Return00A4E2          
CODE_00A513:        A9 6D         LDA.B #$6D                
CODE_00A515:        20 1C A4      JSR.W CODE_00A41C         
CODE_00A518:        A9 10         LDA.B #$10                
CODE_00A51A:        85 00         STA $00                   
CODE_00A51C:        A9 7D         LDA.B #$7D                
CODE_00A51E:        4C 1E A4      JMP.W CODE_00A41E         


DATA_00A521:                      .db $00,$04,$08,$0C

DATA_00A525:                      .db $00,$08,$10,$18

CODE_00A529:        A9 80         LDA.B #$80                
CODE_00A52B:        8D 15 21      STA.W $2115               ; VRAM Address Increment Value
CODE_00A52E:        9C 16 21      STZ.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A531:        A9 30         LDA.B #$30                
CODE_00A533:        18            CLC                       
CODE_00A534:        79 21 A5      ADC.W DATA_00A521,Y       
CODE_00A537:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_00A53A:        A2 06         LDX.B #$06                
CODE_00A53C:        BD 86 A5      LDA.W DATA_00A586,X       
CODE_00A53F:        9D 10 43      STA.W $4310,X             
CODE_00A542:        CA            DEX                       
CODE_00A543:        10 F7         BPL CODE_00A53C           
CODE_00A545:        AD D6 0D      LDA.W $0DD6               
CODE_00A548:        4A            LSR                       
CODE_00A549:        4A            LSR                       
CODE_00A54A:        AA            TAX                       
CODE_00A54B:        BD 11 1F      LDA.W $1F11,X             
CODE_00A54E:        F0 05         BEQ CODE_00A555           
CODE_00A550:        A9 60         LDA.B #$60                
CODE_00A552:        8D 13 43      STA.W $4313               ; A Address (High Byte)
CODE_00A555:        AD 13 43      LDA.W $4313               ; A Address (High Byte)
CODE_00A558:        18            CLC                       
CODE_00A559:        79 25 A5      ADC.W DATA_00A525,Y       
CODE_00A55C:        8D 13 43      STA.W $4313               ; A Address (High Byte)
CODE_00A55F:        A9 02         LDA.B #$02                
CODE_00A561:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
CODE_00A564:        A9 80         LDA.B #$80                
CODE_00A566:        8D 15 21      STA.W $2115               ; VRAM Address Increment Value
CODE_00A569:        9C 16 21      STZ.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A56C:        A9 20         LDA.B #$20                
CODE_00A56E:        18            CLC                       
CODE_00A56F:        79 21 A5      ADC.W DATA_00A521,Y       
CODE_00A572:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_00A575:        A2 06         LDX.B #$06                
CODE_00A577:        BD 8D A5      LDA.W DATA_00A58D,X       
CODE_00A57A:        9D 10 43      STA.W $4310,X             
CODE_00A57D:        CA            DEX                       
CODE_00A57E:        10 F7         BPL CODE_00A577           
CODE_00A580:        A9 02         LDA.B #$02                
CODE_00A582:        8D 0B 42      STA.W $420B               ; Regular DMA Channel Enable
Return00A585:       60            RTS                       


DATA_00A586:                      .db $01,$18,$00,$40,$7F,$00,$08

DATA_00A58D:                      .db $01,$18,$00,$E4,$7E,$00,$08

CODE_00A594:        8B            PHB                       ; Wrapper 
CODE_00A595:        4B            PHK                       
CODE_00A596:        AB            PLB                       
CODE_00A597:        20 25 AD      JSR.W CODE_00AD25         
CODE_00A59A:        AB            PLB                       
Return00A59B:       6B            RTL                       

GM04Load:           20 FA 85      JSR.W CODE_0085FA         ; gah, stupid keyboard >_< 
CODE_00A59F:        20 2D F6      JSR.W NoButtons           
CODE_00A5A2:        9C 3A 14      STZ.W $143A               
CODE_00A5A5:        20 79 8A      JSR.W SetUpScreen         
CODE_00A5A8:        20 FF 8C      JSR.W GM04DoDMA           
CODE_00A5AB:        22 9E 80 05   JSL.L CODE_05809E         ; ->here 
CODE_00A5AF:        AD 9B 0D      LDA.W $0D9B               
CODE_00A5B2:        10 05         BPL CODE_00A5B9           
CODE_00A5B4:        20 BC 97      JSR.W CODE_0097BC         ; Working on this routine 
CODE_00A5B7:        80 16         BRA CODE_00A5CF           

CODE_00A5B9:        20 DA A9      JSR.W UploadSpriteGFX     
CODE_00A5BC:        20 ED AB      JSR.W LoadPalette         
CODE_00A5BF:        22 8A BE 05   JSL.L CODE_05BE8A         
CODE_00A5C3:        20 B8 9F      JSR.W CODE_009FB8         
CODE_00A5C6:        20 F9 A5      JSR.W CODE_00A5F9         
CODE_00A5C9:        20 60 92      JSR.W CODE_009260         
CODE_00A5CC:        20 60 98      JSR.W CODE_009860         
CODE_00A5CF:        20 2F 92      JSR.W CODE_00922F         
CODE_00A5D2:        20 29 9F      JSR.W KeepModeActive      
CODE_00A5D5:        20 1A 8E      JSR.W CODE_008E1A         
CODE_00A5D8:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00A5DA:        8B            PHB                       
CODE_00A5DB:        A2 03 07      LDX.W #$0703              
CODE_00A5DE:        A0 05 09      LDY.W #$0905              
CODE_00A5E1:        A9 EF 01      LDA.W #$01EF              
CODE_00A5E4:        54 00 00      MVN $00,$00               
CODE_00A5E7:        AB            PLB                       
CODE_00A5E8:        AE 01 07      LDX.W $0701               
CODE_00A5EB:        8E 03 09      STX.W $0903               
CODE_00A5EE:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_00A5F0:        20 9B 91      JSR.W CODE_00919B         
CODE_00A5F3:        20 94 84      JSR.W CODE_008494         
CODE_00A5F6:        4C F4 93      JMP.W CODE_0093F4         

CODE_00A5F9:        A9 E7         LDA.B #$E7                
CODE_00A5FB:        14 14         TRB RAM_FrameCounterB     
CODE_00A5FD:        22 39 BB 05   JSL.L CODE_05BB39         
CODE_00A601:        20 90 A3      JSR.W CODE_00A390         
CODE_00A604:        E6 14         INC RAM_FrameCounterB     
CODE_00A606:        A5 14         LDA RAM_FrameCounterB     

Instr00A608:                      .db $29,$07

CODE_00A60A:        D0 F1         BNE CODE_00A5FD           
Return00A60C:       60            RTS                       


DATA_00A60D:                      .db $00,$01,$01,$01

DATA_00A611:                      .db $0D,$00,$F3,$FF,$FE,$FF,$FE,$FF
                                  .db $00,$00,$00,$00

DATA_00A61D:                      .db $0A,$00,$00,$00,$1A,$1A,$0A,$0A
DATA_00A625:                      .db $00,$80,$40,$00,$01,$02,$40,$00
                                  .db $40,$00,$00,$00,$00,$02,$00,$00

CODE_00A635:        AD AD 14      LDA.W RAM_BluePowTimer    ; If blue pow... 
CODE_00A638:        0D AE 14      ORA.W RAM_SilverPowTimer  ; ...or silver pow... 
CODE_00A63B:        0D 0C 19      ORA.W $190C               
CODE_00A63E:        D0 0A         BNE CODE_00A64A           
CODE_00A640:        AD 90 14      LDA.W $1490               ; \ Branch if Mario doesn't have star 
CODE_00A643:        F0 1B         BEQ CODE_00A660           ; / 
CODE_00A645:        AD DA 0D      LDA.W $0DDA               
CODE_00A648:        10 05         BPL CODE_00A64F           
CODE_00A64A:        AD DA 0D      LDA.W $0DDA               
CODE_00A64D:        29 7F         AND.B #$7F                
CODE_00A64F:        09 40         ORA.B #$40                
CODE_00A651:        8D DA 0D      STA.W $0DDA               
CODE_00A654:        9C AD 14      STZ.W RAM_BluePowTimer    ; Zero out POW timer 
CODE_00A657:        9C AE 14      STZ.W RAM_SilverPowTimer  ; Zero out silver POW timer 
CODE_00A65A:        9C 0C 19      STZ.W $190C               
CODE_00A65D:        9C 90 14      STZ.W $1490               ; Zero out star timer 
CODE_00A660:        AD F4 13      LDA.W $13F4               
CODE_00A663:        0D F5 13      ORA.W $13F5               
CODE_00A666:        0D F6 13      ORA.W $13F6               
CODE_00A669:        0D F7 13      ORA.W $13F7               
CODE_00A66C:        0D F8 13      ORA.W $13F8               
CODE_00A66F:        F0 03         BEQ CODE_00A674           
CODE_00A671:        8D 1B 14      STA.W $141B               
CODE_00A674:        A2 23         LDX.B #$23                
CODE_00A676:        74 70         STZ $70,X                 
CODE_00A678:        CA            DEX                       
CODE_00A679:        D0 FB         BNE CODE_00A676           
CODE_00A67B:        A2 37         LDX.B #$37                
CODE_00A67D:        9E D9 13      STZ.W $13D9,X             
CODE_00A680:        CA            DEX                       
CODE_00A681:        D0 FA         BNE CODE_00A67D           
CODE_00A683:        0E CB 13      ASL.W $13CB               
CODE_00A686:        9C 9A 14      STZ.W RAM_KickImgTimer    
CODE_00A689:        9C 98 14      STZ.W RAM_PickUpImgTimer  
CODE_00A68C:        9C 95 14      STZ.W $1495               
CODE_00A68F:        9C 19 14      STZ.W RAM_YoshiInPipe     
CODE_00A692:        A0 01         LDY.B #$01                
CODE_00A694:        AE 31 19      LDX.W $1931               
CODE_00A697:        E0 10         CPX.B #$10                
CODE_00A699:        B0 31         BCS CODE_00A6CC           
CODE_00A69B:        BD 25 A6      LDA.W DATA_00A625,X       
CODE_00A69E:        4A            LSR                       
CODE_00A69F:        F0 2B         BEQ CODE_00A6CC           
CODE_00A6A1:        AD 1D 14      LDA.W $141D               
CODE_00A6A4:        0D 1A 14      ORA.W $141A               
CODE_00A6A7:        0D 1F 14      ORA.W $141F               
CODE_00A6AA:        D0 20         BNE CODE_00A6CC           
CODE_00A6AC:        AD CF 13      LDA.W $13CF               
CODE_00A6AF:        F0 05         BEQ CODE_00A6B6           
CODE_00A6B1:        20 0A C9      JSR.W CODE_00C90A         
CODE_00A6B4:        80 16         BRA CODE_00A6CC           

CODE_00A6B6:        64 72         STZ RAM_IsFlying          
CODE_00A6B8:        84 76         STY RAM_MarioDirection    
CODE_00A6BA:        84 89         STY $89                   
CODE_00A6BC:        A2 0A         LDX.B #$0A                
CODE_00A6BE:        A0 00         LDY.B #$00                
CODE_00A6C0:        AD C1 0D      LDA.W RAM_OWHasYoshi      
CODE_00A6C3:        F0 02         BEQ CODE_00A6C7           
CODE_00A6C5:        A0 0F         LDY.B #$0F                
CODE_00A6C7:        86 71         STX RAM_MarioAnimation    
CODE_00A6C9:        84 88         STY $88                   
Return00A6CB:       60            RTS                       

CODE_00A6CC:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_00A6CE:        C9 C0         CMP.B #$C0                
CODE_00A6D0:        F0 03         BEQ CODE_00A6D5           
CODE_00A6D2:        EE F1 13      INC.W $13F1               
CODE_00A6D5:        AD 2A 19      LDA.W $192A               
CODE_00A6D8:        F0 06         BEQ CODE_00A6E0           
CODE_00A6DA:        C9 05         CMP.B #$05                
CODE_00A6DC:        D0 38         BNE CODE_00A716           
CODE_00A6DE:        66 86         ROR $86                   
CODE_00A6E0:        84 76         STY RAM_MarioDirection    
CODE_00A6E2:        A9 24         LDA.B #$24                
CODE_00A6E4:        85 72         STA RAM_IsFlying          
CODE_00A6E6:        64 9D         STZ RAM_SpritesLocked     
CODE_00A6E8:        AD 34 14      LDA.W $1434               
CODE_00A6EB:        F0 17         BEQ CODE_00A704           
ADDR_00A6ED:        AD DA 0D      LDA.W $0DDA               
ADDR_00A6F0:        09 7F         ORA.B #$7F                
ADDR_00A6F2:        8D DA 0D      STA.W $0DDA               
ADDR_00A6F5:        A5 94         LDA RAM_MarioXPos         
ADDR_00A6F7:        09 04         ORA.B #$04                
ADDR_00A6F9:        8D 36 14      STA.W RAM_KeyHolePos1     
ADDR_00A6FC:        A5 96         LDA RAM_MarioYPos         
ADDR_00A6FE:        18            CLC                       
ADDR_00A6FF:        69 10         ADC.B #$10                
ADDR_00A701:        8D 38 14      STA.W RAM_KeyHolePos2     
CODE_00A704:        AD 95 1B      LDA.W $1B95               
CODE_00A707:        F0 0C         BEQ Return00A715          
CODE_00A709:        A9 08         LDA.B #$08                ; \ Animation = Rise off screen, 
CODE_00A70B:        85 71         STA RAM_MarioAnimation    ; / for Yoshi Wing bonus stage 
CODE_00A70D:        A9 A0         LDA.B #$A0                
CODE_00A70F:        85 96         STA RAM_MarioYPos         
CODE_00A711:        A9 90         LDA.B #$90                ; \ Set upward speed, #$90 
CODE_00A713:        85 7D         STA RAM_MarioSpeedY       ; / 
Return00A715:       60            RTS                       

CODE_00A716:        C9 06         CMP.B #$06                
CODE_00A718:        90 26         BCC CODE_00A740           
CODE_00A71A:        D0 18         BNE CODE_00A734           
CODE_00A71C:        84 76         STY RAM_MarioDirection    
CODE_00A71E:        8C DF 13      STY.W $13DF               
CODE_00A721:        A9 FF         LDA.B #$FF                
CODE_00A723:        8D 19 14      STA.W RAM_YoshiInPipe     
CODE_00A726:        A9 08         LDA.B #$08                
CODE_00A728:        04 94         TSB RAM_MarioXPos         
CODE_00A72A:        A9 02         LDA.B #$02                
CODE_00A72C:        04 96         TSB RAM_MarioYPos         
CODE_00A72E:        A2 07         LDX.B #$07                
CODE_00A730:        A0 20         LDY.B #$20                
CODE_00A732:        80 93         BRA CODE_00A6C7           

CODE_00A734:        84 85         STY RAM_IsWaterLevel      
CODE_00A736:        AD CF 13      LDA.W $13CF               
CODE_00A739:        0D 34 14      ORA.W $1434               
CODE_00A73C:        D0 A2         BNE CODE_00A6E0           
CODE_00A73E:        A9 04         LDA.B #$04                
CODE_00A740:        18            CLC                       
CODE_00A741:        69 03         ADC.B #$03                
CODE_00A743:        85 89         STA $89                   
CODE_00A745:        A8            TAY                       
CODE_00A746:        4A            LSR                       
CODE_00A747:        3A            DEC A                     
CODE_00A748:        8D 19 14      STA.W RAM_YoshiInPipe     
CODE_00A74B:        B9 09 A6      LDA.W ADDR_00A609,Y       
CODE_00A74E:        85 76         STA RAM_MarioDirection    
CODE_00A750:        A2 05         LDX.B #$05                
CODE_00A752:        C0 06         CPY.B #$06                
CODE_00A754:        90 12         BCC CODE_00A768           
CODE_00A756:        A9 08         LDA.B #$08                
CODE_00A758:        04 94         TSB RAM_MarioXPos         
CODE_00A75A:        A2 06         LDX.B #$06                
CODE_00A75C:        C0 07         CPY.B #$07                
CODE_00A75E:        A0 1E         LDY.B #$1E                
CODE_00A760:        90 08         BCC CODE_00A76A           
CODE_00A762:        A0 0F         LDY.B #$0F                
CODE_00A764:        A5 19         LDA RAM_MarioPowerUp      
CODE_00A766:        F0 02         BEQ CODE_00A76A           
CODE_00A768:        A0 1C         LDY.B #$1C                ; \ Set downward speed, #$1C 
CODE_00A76A:        84 7D         STY RAM_MarioSpeedY       ; / 
CODE_00A76C:        20 C7 A6      JSR.W CODE_00A6C7         
CODE_00A76F:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_00A772:        F0 21         BEQ Return00A795          
CODE_00A774:        A6 89         LDX $89                   
CODE_00A776:        A5 88         LDA $88                   
CODE_00A778:        18            CLC                       
CODE_00A779:        7D 1D A6      ADC.W DATA_00A61D,X       
CODE_00A77C:        85 88         STA $88                   
CODE_00A77E:        8A            TXA                       
CODE_00A77F:        0A            ASL                       
CODE_00A780:        AA            TAX                       
CODE_00A781:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00A783:        A5 94         LDA RAM_MarioXPos         
CODE_00A785:        18            CLC                       
CODE_00A786:        7D 09 A6      ADC.W ADDR_00A609,X       
CODE_00A789:        85 94         STA RAM_MarioXPos         
CODE_00A78B:        A5 96         LDA RAM_MarioYPos         
CODE_00A78D:        18            CLC                       
CODE_00A78E:        7D 11 A6      ADC.W DATA_00A611,X       
CODE_00A791:        85 96         STA RAM_MarioYPos         
CODE_00A793:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return00A795:       60            RTS                       

CODE_00A796:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00A798:        AC 14 14      LDY.W $1414               
CODE_00A79B:        F0 1C         BEQ CODE_00A7B9           
CODE_00A79D:        88            DEY                       
CODE_00A79E:        D0 07         BNE CODE_00A7A7           
CODE_00A7A0:        A5 20         LDA $20                   
CODE_00A7A2:        38            SEC                       
CODE_00A7A3:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_00A7A5:        80 0F         BRA CODE_00A7B6           

CODE_00A7A7:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_00A7A9:        4A            LSR                       
CODE_00A7AA:        88            DEY                       
CODE_00A7AB:        F0 02         BEQ CODE_00A7AF           
CODE_00A7AD:        4A            LSR                       
CODE_00A7AE:        4A            LSR                       
CODE_00A7AF:        49 FF FF      EOR.W #$FFFF              
CODE_00A7B2:        1A            INC A                     
CODE_00A7B3:        18            CLC                       
CODE_00A7B4:        65 20         ADC $20                   
CODE_00A7B6:        8D 17 14      STA.W $1417               
CODE_00A7B9:        A9 80 00      LDA.W #$0080              
CODE_00A7BC:        8D 2A 14      STA.W $142A               
CODE_00A7BF:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return00A7C1:       60            RTS                       

CODE_00A7C2:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_00A7C4:        A2 80         LDX.B #$80                
CODE_00A7C6:        8E 15 21      STX.W $2115               ; VRAM Address Increment Value
CODE_00A7C9:        A9 00 60      LDA.W #$6000              
CODE_00A7CC:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A7CF:        A9 01 18      LDA.W #$1801              
CODE_00A7D2:        8D 20 43      STA.W $4320               ; Parameters for DMA Transfer
CODE_00A7D5:        A9 7B 97      LDA.W #$977B              
CODE_00A7D8:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A7DB:        A2 7F         LDX.B #$7F                
CODE_00A7DD:        8E 24 43      STX.W $4324               ; A Address Bank
CODE_00A7E0:        A9 C0 00      LDA.W #$00C0              
CODE_00A7E3:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A7E6:        A2 04         LDX.B #$04                
CODE_00A7E8:        8E 0B 42      STX.W $420B               ; Regular DMA Channel Enable
CODE_00A7EB:        A9 00 61      LDA.W #$6100              
CODE_00A7EE:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A7F1:        A9 3B 98      LDA.W #$983B              
CODE_00A7F4:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A7F7:        A9 C0 00      LDA.W #$00C0              
CODE_00A7FA:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A7FD:        8E 0B 42      STX.W $420B               ; Regular DMA Channel Enable
CODE_00A800:        A9 A0 64      LDA.W #$64A0              
CODE_00A803:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A806:        A9 FB 98      LDA.W #$98FB              
CODE_00A809:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A80C:        A9 C0 00      LDA.W #$00C0              
CODE_00A80F:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A812:        8E 0B 42      STX.W $420B               ; Regular DMA Channel Enable
CODE_00A815:        A9 A0 65      LDA.W #$65A0              
CODE_00A818:        8D 16 21      STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00A81B:        A9 BB 99      LDA.W #$99BB              
CODE_00A81E:        8D 22 43      STA.W $4322               ; A Address (Low Byte)
CODE_00A821:        A9 C0 00      LDA.W #$00C0              
CODE_00A824:        8D 25 43      STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A827:        8E 0B 42      STX.W $420B               ; Regular DMA Channel Enable
CODE_00A82A:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
Return00A82C:       60            RTS                       

CODE_00A82D:        A0 0F         LDY.B #$0F                
CODE_00A82F:        22 28 BA 00   JSL.L CODE_00BA28         
CODE_00A833:        AD 25 14      LDA.W $1425               
CODE_00A836:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00A838:        F0 08         BEQ CODE_00A842           
CODE_00A83A:        A5 00         LDA $00                   
CODE_00A83C:        18            CLC                       
CODE_00A83D:        69 30 00      ADC.W #$0030              
CODE_00A840:        85 00         STA $00                   
CODE_00A842:        A2 00 00      LDX.W #$0000              
CODE_00A845:        A0 08 00      LDY.W #$0008              
CODE_00A848:        A7 00         LDA [$00]                 
CODE_00A84A:        9F 7B 97 7F   STA.L $7F977B,X           
CODE_00A84E:        E8            INX                       
CODE_00A84F:        E8            INX                       
CODE_00A850:        E6 00         INC $00                   
CODE_00A852:        E6 00         INC $00                   
CODE_00A854:        88            DEY                       
CODE_00A855:        D0 F1         BNE CODE_00A848           
CODE_00A857:        A0 08 00      LDY.W #$0008              
CODE_00A85A:        A7 00         LDA [$00]                 
CODE_00A85C:        29 FF 00      AND.W #$00FF              
CODE_00A85F:        9F 7B 97 7F   STA.L $7F977B,X           
CODE_00A863:        E8            INX                       
CODE_00A864:        E8            INX                       
CODE_00A865:        E6 00         INC $00                   
CODE_00A867:        88            DEY                       
CODE_00A868:        D0 F0         BNE CODE_00A85A           
CODE_00A86A:        E0 00 03      CPX.W #$0300              
CODE_00A86D:        90 D6         BCC CODE_00A845           
CODE_00A86F:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_00A871:        A0 00         LDY.B #$00                
CODE_00A873:        22 28 BA 00   JSL.L CODE_00BA28         
CODE_00A877:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00A879:        A9 F0 B3      LDA.W #$B3F0              
CODE_00A87C:        85 00         STA $00                   
CODE_00A87E:        A9 B3 7E      LDA.W #$7EB3              
CODE_00A881:        85 01         STA $01                   
CODE_00A883:        A2 00 00      LDX.W #$0000              
CODE_00A886:        A0 08 00      LDY.W #$0008              
CODE_00A889:        A7 00         LDA [$00]                 
CODE_00A88B:        9D F6 0B      STA.W $0BF6,X             
CODE_00A88E:        E8            INX                       
CODE_00A88F:        E8            INX                       
CODE_00A890:        E6 00         INC $00                   
CODE_00A892:        E6 00         INC $00                   
CODE_00A894:        88            DEY                       
CODE_00A895:        D0 F2         BNE CODE_00A889           
CODE_00A897:        A0 08 00      LDY.W #$0008              
CODE_00A89A:        A7 00         LDA [$00]                 
CODE_00A89C:        29 FF 00      AND.W #$00FF              
CODE_00A89F:        9D F6 0B      STA.W $0BF6,X             
CODE_00A8A2:        E8            INX                       
CODE_00A8A3:        E8            INX                       
CODE_00A8A4:        E6 00         INC $00                   
CODE_00A8A6:        88            DEY                       
CODE_00A8A7:        D0 F1         BNE CODE_00A89A           
CODE_00A8A9:        E0 C0 00      CPX.W #$00C0              
CODE_00A8AC:        D0 05         BNE CODE_00A8B3           
CODE_00A8AE:        A9 70 B5      LDA.W #$B570              
CODE_00A8B1:        85 00         STA $00                   
CODE_00A8B3:        E0 80 01      CPX.W #$0180              
CODE_00A8B6:        90 CE         BCC CODE_00A886           
CODE_00A8B8:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_00A8BA:        A9 01         LDA.B #$01                
CODE_00A8BC:        8D 3A 14      STA.W $143A               
CODE_00A8BF:        8D 35 19      STA.W $1935               
Return00A8C2:       60            RTS                       


SPRITEGFXLIST:                    .db $00,$01,$13,$02,$00,$01,$12,$03     ; Forest ; Castle 
                                  .db $00,$01,$13,$05,$00,$01,$13,$04     ; Mushroom ; Underground 
                                  .db $00,$01,$13,$06,$00,$01,$13,$09     ; Water ; Pokey 
                                  .db $00,$01,$13,$04,$00,$01,$06,$11     ; Underground 2 ; Ghost House 
                                  .db $00,$01,$13,$20,$00,$01,$13,$0F     ; Banzai Bill ; Yoshi's House 
                                  .db $00,$01,$13,$23,$00,$01,$0D,$14     ; Dino-Rhino ; Switch Palace 
                                  .db $00,$01,$24,$0E,$00,$01,$0A,$22     ; Mechakoopa ; Wendy/Lemmy 
                                  .db $00,$01,$13,$0E,$00,$01,$13,$14     ; Ninji ; Unused 
                                  .db $00,$00,$00,$08,$10,$0F,$1C,$1D
                                  .db $00,$01,$24,$22,$00,$01,$25,$22
                                  .db $00,$22,$13,$2D,$00,$01,$0F,$22
                                  .db $00,$26,$2E,$22,$21,$0B,$25,$0A
                                  .db $00,$0D,$24,$22,$2C,$30,$2D,$0E
OBJECTGFXLIST:                    .db $14,$17,$19,$15,$14,$17,$1B,$18     ; Normal 1 ; Castle 1 
                                  .db $14,$17,$1B,$16,$14,$17,$0C,$1A     ; Rope 1 ; Underground 1 
                                  .db $14,$17,$1B,$08,$14,$17,$0C,$07     ; Switch Palace 1 ; Ghost House 1 
                                  .db $14,$17,$0C,$16,$14,$17,$1B,$15     ; Rope 2 ; Normal 2 
                                  .db $14,$17,$19,$16,$14,$17,$0D,$1A     ; Rope 3 ; Underground 2 
                                  .db $14,$17,$1B,$08,$14,$17,$1B,$18     ; Switch Palace 2 ; Castle 2 
                                  .db $14,$17,$19,$1F,$14,$17,$0D,$07     ; Cloud/Forest ; Ghost House 2 
                                  .db $14,$17,$19,$1A,$14,$17,$14,$14     ; Underground 2 
                                  .db $0E,$0F,$17,$17,$1C,$1D,$08,$1E
                                  .db $1C,$1D,$08,$1E,$1C,$1D,$08,$1E
                                  .db $1C,$1D,$08,$1E,$1C,$1D,$08,$1E
                                  .db $1C,$1D,$08,$1E,$1C,$1D,$08,$1E
                                  .db $14,$17,$19,$2C,$19,$17,$1B,$18

CODE_00A993:        9C 16 21      STZ.W $2116               ; \  ; Address for VRAM Read/Write (Low Byte)
CODE_00A996:        A9 40         LDA.B #$40                ;  |Set "Address for VRAM Read/Write" to x4000 
CODE_00A998:        8D 17 21      STA.W $2117               ; /  ; Address for VRAM Read/Write (High Byte)
CODE_00A99B:        A9 03         LDA.B #$03                
CODE_00A99D:        85 0F         STA $0F                   
CODE_00A99F:        A9 28         LDA.B #$28                
CODE_00A9A1:        85 0E         STA $0E                   
CODE_00A9A3:        A5 0E         LDA $0E                   
CODE_00A9A5:        A8            TAY                       
CODE_00A9A6:        22 28 BA 00   JSL.L CODE_00BA28         
CODE_00A9AA:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00A9AC:        A2 FF 03      LDX.W #$03FF              
CODE_00A9AF:        A0 00 00      LDY.W #$0000              
CODE_00A9B2:        B7 00         LDA [$00],Y               
CODE_00A9B4:        8D 18 21      STA.W $2118               ; Data for VRAM Write (Low Byte)
CODE_00A9B7:        C8            INY                       
CODE_00A9B8:        C8            INY                       
CODE_00A9B9:        CA            DEX                       
CODE_00A9BA:        10 F6         BPL CODE_00A9B2           
CODE_00A9BC:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_00A9BE:        E6 0E         INC $0E                   
CODE_00A9C0:        C6 0F         DEC $0F                   
CODE_00A9C2:        10 DF         BPL CODE_00A9A3           
CODE_00A9C4:        9C 16 21      STZ.W $2116               ; \  ; Address for VRAM Read/Write (Low Byte)
CODE_00A9C7:        A9 60         LDA.B #$60                ;  |Set "Address for VRAM Read/Write" to x6000 
CODE_00A9C9:        8D 17 21      STA.W $2117               ; /  ; Address for VRAM Read/Write (High Byte)
CODE_00A9CC:        A0 00         LDY.B #$00                
CODE_00A9CE:        20 6B AA      JSR.W UploadGFXFile       
Return00A9D1:       60            RTS                       


DATA_00A9D2:                      .db $78,$70,$68,$60

DATA_00A9D6:                      .db $18,$10,$08,$00

UploadSpriteGFX:    A9 80         LDA.B #$80                ; Decompression as well? 
CODE_00A9DC:        8D 15 21      STA.W $2115               ; VRAM transfer control port ; VRAM Address Increment Value
CODE_00A9DF:        A2 03         LDX.B #$03                
CODE_00A9E1:        AD 2B 19      LDA.W $192B               ; $192B = current sprite GFX list index 
CODE_00A9E4:        0A            ASL                       ; \ 
CODE_00A9E5:        0A            ASL                       ;  }4A -> Y 
CODE_00A9E6:        A8            TAY                       ; / 
CODE_00A9E7:        B9 C3 A8      LDA.W SPRITEGFXLIST,Y     ;  | 
CODE_00A9EA:        95 04         STA $04,X                 ;  | 
CODE_00A9EC:        C8            INY                       ;  | 
CODE_00A9ED:        CA            DEX                       ;  | 
CODE_00A9EE:        10 F7         BPL CODE_00A9E7           ; / 
CODE_00A9F0:        A9 03         LDA.B #$03                ; #$03 -> A -> $0F 
CODE_00A9F2:        85 0F         STA $0F                   
GFXTransferLoop:    A6 0F         LDX $0F                   ; $0F -> X 
CODE_00A9F6:        9C 16 21      STZ.W $2116               ; #$00 -> $2116 ; Address for VRAM Read/Write (Low Byte)
CODE_00A9F9:        BD D2 A9      LDA.W DATA_00A9D2,X       ; My guess: Locations in VRAM to upload GFX to 
CODE_00A9FC:        8D 17 21      STA.W $2117               ; Set VRAM address to $??00 ; Address for VRAM Read/Write (High Byte)
CODE_00A9FF:        B4 04         LDY $04,X                 ; Y is possibly which GFX file 
CODE_00AA01:        BD 01 01      LDA.W $0101,X             ; to upload to a section in VRAM, used in 
CODE_00AA04:        D5 04         CMP $04,X                 ; the subroutine $00:BA28 
CODE_00AA06:        F0 03         BEQ Don'tUploadSpr        ; don't upload when it''s not needed 
CODE_00AA08:        20 6B AA      JSR.W UploadGFXFile       ; JSR to a JSL... 
Don'tUploadSpr:     C6 0F         DEC $0F                   ; Decrement $0F 
CODE_00AA0D:        10 E5         BPL GFXTransferLoop       ; if >= #$00, continue transfer 
CODE_00AA0F:        A2 03         LDX.B #$03                ; \ 
UpdtCrrntSpritGFX:  B5 04         LDA $04,X                 ;  |Update $0101-$0104 to reflect the new sprite GFX 
CODE_00AA13:        9D 01 01      STA.W $0101,X             ;  |That's loaded now. 
CODE_00AA16:        CA            DEX                       ;  | 
CODE_00AA17:        10 F8         BPL UpdtCrrntSpritGFX     ; / 
CODE_00AA19:        AD 31 19      LDA.W $1931               ; LDA Tileset 
CODE_00AA1C:        C9 FE         CMP.B #$FE                
CODE_00AA1E:        B0 3B         BCS SetallFGBG80          ; Branch to a routine that uploads file #$80 to every slot in FG/BG 
CODE_00AA20:        A2 03         LDX.B #$03                
CODE_00AA22:        AD 31 19      LDA.W $1931               ; this routine is pretty close to the above 
CODE_00AA25:        0A            ASL                       ; one, I'm guessing this does 
CODE_00AA26:        0A            ASL                       ; object/BG GFX. 
CODE_00AA27:        A8            TAY                       ; 4A -> Y 
PrepLoadFGBG:       B9 2B A9      LDA.W OBJECTGFXLIST,Y     ; FG/BG GFX table 
CODE_00AA2B:        95 04         STA $04,X                 
CODE_00AA2D:        C8            INY                       
CODE_00AA2E:        CA            DEX                       
CODE_00AA2F:        10 F7         BPL PrepLoadFGBG          ; FG/Bg to upload -> $04 - $07 
CODE_00AA31:        A9 03         LDA.B #$03                
CODE_00AA33:        85 0F         STA $0F                   ; #$03 -> $0F 
CODE_00AA35:        A6 0F         LDX $0F                   ; $0F -> X 
CODE_00AA37:        9C 16 21      STZ.W $2116               ; Address for VRAM Read/Write (Low Byte)
CODE_00AA3A:        BD D6 A9      LDA.W DATA_00A9D6,X       ; Load + Store VRAM upload positions 
CODE_00AA3D:        8D 17 21      STA.W $2117               ; Address for VRAM Read/Write (High Byte)
CODE_00AA40:        B4 04         LDY $04,X                 
CODE_00AA42:        BD 05 01      LDA.W $0105,X             ; Check to see if the file to be uploaded already 
CODE_00AA45:        D5 04         CMP $04,X                 ; exists in the slot in VRAM - if so, 
CODE_00AA47:        F0 03         BEQ NoUploadFGBG          ; don't bother uploading it again. 
CODE_00AA49:        20 6B AA      JSR.W UploadGFXFile       ; Upload the GFX file 
NoUploadFGBG:       C6 0F         DEC $0F                   ; Next GFX file 
CODE_00AA4E:        10 E5         BPL CODE_00AA35           
CODE_00AA50:        A2 03         LDX.B #$03                
UpdateCurrentFGBG:  B5 04         LDA $04,X                 
CODE_00AA54:        9D 05 01      STA.W $0105,X             
CODE_00AA57:        CA            DEX                       
CODE_00AA58:        10 F8         BPL UpdateCurrentFGBG     
Return00AA5A:       60            RTS                       ; Return from uploading the GFX 

SetallFGBG80:       F0 03         BEQ NoUpdateVRAM80        ; If zero flag set, don't update the tileset 
CODE_00AA5D:        20 42 AB      JSR.W CODE_00AB42         
NoUpdateVRAM80:     A2 03         LDX.B #$03                
CODE_00AA62:        A9 80         LDA.B #$80                ; my guess is that it gets called in the same set of routines 
Store80:            9D 05 01      STA.W $0105,X             
CODE_00AA67:        CA            DEX                       
CODE_00AA68:        10 FA         BPL Store80               
Return00AA6A:       60            RTS                       ; Return 

UploadGFXFile:      22 28 BA 00   JSL.L CODE_00BA28         
CODE_00AA6F:        C0 01         CPY.B #$01                
CODE_00AA71:        D0 0D         BNE SkipSpecial           
CODE_00AA73:        AD EB 1E      LDA.W $1EEB               
CODE_00AA76:        10 08         BPL SkipSpecial           ; handle the post-special world graphics and koopa color swap. 
CODE_00AA78:        A0 31         LDY.B #$31                
CODE_00AA7A:        22 28 BA 00   JSL.L CODE_00BA28         
CODE_00AA7E:        A0 01         LDY.B #$01                
SkipSpecial:        C2 20         REP #$20                  ; A = 16bit ; Accum (16 bit) 
CODE_00AA82:        A9 00 00      LDA.W #$0000              
CODE_00AA85:        AE 31 19      LDX.W $1931               ; LDX Tileset 
CODE_00AA88:        E0 11         CPX.B #$11                ; CPX #$11 
CODE_00AA8A:        90 04         BCC CODE_00AA90           ; If Tileset < #$11 skip to lower area 
CODE_00AA8C:        C0 08         CPY.B #$08                ; if Y = #$08 skip to JSR 
CODE_00AA8E:        F0 06         BEQ JumpTo_____           
CODE_00AA90:        C0 1E         CPY.B #$1E                ; If Y = #$1E then 
CODE_00AA92:        F0 02         BEQ JumpTo_____           ; JMP otherwise 
CODE_00AA94:        D0 03         BNE CODE_00AA99           ; don't JMP 
JumpTo_____:        4C 02 AB      JMP.W FilterSomeRAM       

CODE_00AA99:        85 0A         STA $0A                   
CODE_00AA9B:        A9 FF FF      LDA.W #$FFFF              
CODE_00AA9E:        C0 01         CPY.B #$01                
CODE_00AAA0:        F0 07         BEQ CODE_00AAA9           
CODE_00AAA2:        C0 17         CPY.B #$17                
CODE_00AAA4:        F0 03         BEQ CODE_00AAA9           
CODE_00AAA6:        A9 00 00      LDA.W #$0000              
CODE_00AAA9:        8D BC 1B      STA.W $1BBC               
CODE_00AAAC:        A0 7F         LDY.B #$7F                
CODE_00AAAE:        AD BC 1B      LDA.W $1BBC               
CODE_00AAB1:        F0 1A         BEQ CODE_00AACD           
CODE_00AAB3:        C0 7E         CPY.B #$7E                
CODE_00AAB5:        90 07         BCC CODE_00AABE           
CODE_00AAB7:        A9 00 FF      LDA.W #$FF00              
CODE_00AABA:        85 0A         STA $0A                   
CODE_00AABC:        D0 0F         BNE CODE_00AACD           
CODE_00AABE:        C0 6E         CPY.B #$6E                
CODE_00AAC0:        90 06         BCC CODE_00AAC8           
CODE_00AAC2:        C0 70         CPY.B #$70                
CODE_00AAC4:        B0 02         BCS CODE_00AAC8           
CODE_00AAC6:        90 EF         BCC CODE_00AAB7           
CODE_00AAC8:        A9 00 00      LDA.W #$0000              
CODE_00AACB:        85 0A         STA $0A                   
CODE_00AACD:        A2 07         LDX.B #$07                
CODE_00AACF:        A7 00         LDA [$00]                 
CODE_00AAD1:        8D 18 21      STA.W $2118               ; Data for VRAM Write (Low Byte)
CODE_00AAD4:        EB            XBA                       
CODE_00AAD5:        07 00         ORA [$00]                 
CODE_00AAD7:        9D B2 1B      STA.W $1BB2,X             
CODE_00AADA:        E6 00         INC $00                   
CODE_00AADC:        E6 00         INC $00                   
CODE_00AADE:        CA            DEX                       
CODE_00AADF:        10 EE         BPL CODE_00AACF           
CODE_00AAE1:        A2 07         LDX.B #$07                
CODE_00AAE3:        A7 00         LDA [$00]                 
CODE_00AAE5:        29 FF 00      AND.W #$00FF              
CODE_00AAE8:        85 0C         STA $0C                   
CODE_00AAEA:        A7 00         LDA [$00]                 
CODE_00AAEC:        EB            XBA                       
CODE_00AAED:        1D B2 1B      ORA.W $1BB2,X             
CODE_00AAF0:        25 0A         AND $0A                   
CODE_00AAF2:        05 0C         ORA $0C                   
CODE_00AAF4:        8D 18 21      STA.W $2118               ; Data for VRAM Write (Low Byte)
CODE_00AAF7:        E6 00         INC $00                   
CODE_00AAF9:        CA            DEX                       
CODE_00AAFA:        10 E7         BPL CODE_00AAE3           
CODE_00AAFC:        88            DEY                       
CODE_00AAFD:        10 AF         BPL CODE_00AAAE           
CODE_00AAFF:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return00AB01:       60            RTS                       ; Return 

FilterSomeRAM:      A9 00 FF      LDA.W #$FF00              ; Accum (16 bit) 
CODE_00AB05:        85 0A         STA $0A                   
CODE_00AB07:        A0 7F         LDY.B #$7F                
Upload????ToVRAM:   C0 08         CPY.B #$08                ; \Completely pointless code. 
CODE_00AB0B:        B0 00         BCS CODE_00AB0D           ; /(Why not just NOPing it out, Nintendo?) 
CODE_00AB0D:        A2 07         LDX.B #$07                
AddressWrite1:      A7 00         LDA [$00]                 ; \ Okay, so take [$00], store 
CODE_00AB11:        8D 18 21      STA.W $2118               ;  |it to VRAM, then bitwise ; Data for VRAM Write (Low Byte)
CODE_00AB14:        EB            XBA                       ;  |OR the high and low bytes together 
CODE_00AB15:        07 00         ORA [$00]                 ;  |store in both bytes of A 
CODE_00AB17:        9D B2 1B      STA.W $1BB2,X             ; /and store to $1BB2,x 
CODE_00AB1A:        E6 00         INC $00                   ; \Increment $7E:0000 by 2 
CODE_00AB1C:        E6 00         INC $00                   ; / 
CODE_00AB1E:        CA            DEX                       ; \And continue on another 7 times (or 8 times total) 
CODE_00AB1F:        10 EE         BPL AddressWrite1         ; / 
CODE_00AB21:        A2 07         LDX.B #$07                ; hm..  It's like a FOR Y{FOR X{ } } thing ...yeah... 
AddressWrite2:      A7 00         LDA [$00]                 
CODE_00AB25:        29 FF 00      AND.W #$00FF              ; A normal byte becomes 2 anti-compressed bytes. 
CODE_00AB28:        85 0C         STA $0C                   ; I'm going up, to try and find out what's supposed to set $00-$02 for this routine. 
CODE_00AB2A:        A7 00         LDA [$00]                 ; AHA, check $00/BA28.  It writes a RAM address to $00-$02, $7EAD00 
CODE_00AB2C:        EB            XBA                       ; So...  Now to find otu what sets *That* 
CODE_00AB2D:        1D B2 1B      ORA.W $1BB2,X             ; ...this place gives me headaches... Can't we work on some other code? :( 
CODE_00AB30:        25 0A         AND $0A                   ; Sure, go ahead.  anyways, this seems to upload the decompressed GFX 
CODE_00AB32:        05 0C         ORA $0C                   ; while scrambling it afterwards (o_O). 
CODE_00AB34:        8D 18 21      STA.W $2118               ; Okay... WHAT THE HELL? ; Data for VRAM Write (Low Byte)
CODE_00AB37:        E6 00         INC $00                   ; I'll have nightmares about this routine for a few years. :( 
CODE_00AB39:        CA            DEX                       
CODE_00AB3A:        10 E7         BPL AddressWrite2         ; Ouch. 
CODE_00AB3C:        88            DEY                       
CODE_00AB3D:        10 CA         BPL Upload????ToVRAM      
CODE_00AB3F:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return00AB41:       60            RTS                       ; Return 

CODE_00AB42:        A0 27         LDY.B #$27                
CODE_00AB44:        22 28 BA 00   JSL.L CODE_00BA28         
CODE_00AB48:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_00AB4A:        A0 00 00      LDY.W #$0000              
CODE_00AB4D:        A2 FF 03      LDX.W #$03FF              
CODE_00AB50:        B7 00         LDA [$00],Y               
CODE_00AB52:        85 0F         STA $0F                   
CODE_00AB54:        20 C4 AB      JSR.W CODE_00ABC4         
CODE_00AB57:        A5 04         LDA $04                   
CODE_00AB59:        8D 19 21      STA.W $2119               ; Data for VRAM Write (High Byte)
CODE_00AB5C:        20 C4 AB      JSR.W CODE_00ABC4         
CODE_00AB5F:        A5 04         LDA $04                   
CODE_00AB61:        8D 19 21      STA.W $2119               ; Data for VRAM Write (High Byte)
CODE_00AB64:        64 04         STZ $04                   
CODE_00AB66:        26 0F         ROL $0F                   
CODE_00AB68:        26 04         ROL $04                   
CODE_00AB6A:        26 0F         ROL $0F                   
CODE_00AB6C:        26 04         ROL $04                   
CODE_00AB6E:        C8            INY                       
CODE_00AB6F:        B7 00         LDA [$00],Y               
CODE_00AB71:        85 0F         STA $0F                   
CODE_00AB73:        26 0F         ROL $0F                   
CODE_00AB75:        26 04         ROL $04                   
CODE_00AB77:        A5 04         LDA $04                   
CODE_00AB79:        8D 19 21      STA.W $2119               ; Data for VRAM Write (High Byte)
CODE_00AB7C:        20 C4 AB      JSR.W CODE_00ABC4         
CODE_00AB7F:        A5 04         LDA $04                   
CODE_00AB81:        8D 19 21      STA.W $2119               ; Data for VRAM Write (High Byte)
CODE_00AB84:        20 C4 AB      JSR.W CODE_00ABC4         
CODE_00AB87:        A5 04         LDA $04                   
CODE_00AB89:        8D 19 21      STA.W $2119               ; Data for VRAM Write (High Byte)
CODE_00AB8C:        64 04         STZ $04                   
CODE_00AB8E:        26 0F         ROL $0F                   
CODE_00AB90:        26 04         ROL $04                   
CODE_00AB92:        C8            INY                       
CODE_00AB93:        B7 00         LDA [$00],Y               
CODE_00AB95:        85 0F         STA $0F                   
CODE_00AB97:        26 0F         ROL $0F                   
CODE_00AB99:        26 04         ROL $04                   
CODE_00AB9B:        26 0F         ROL $0F                   
CODE_00AB9D:        26 04         ROL $04                   
CODE_00AB9F:        A5 04         LDA $04                   
CODE_00ABA1:        8D 19 21      STA.W $2119               ; Data for VRAM Write (High Byte)
CODE_00ABA4:        20 C4 AB      JSR.W CODE_00ABC4         
CODE_00ABA7:        A5 04         LDA $04                   
CODE_00ABA9:        8D 19 21      STA.W $2119               ; Data for VRAM Write (High Byte)
CODE_00ABAC:        20 C4 AB      JSR.W CODE_00ABC4         
CODE_00ABAF:        A5 04         LDA $04                   
CODE_00ABB1:        8D 19 21      STA.W $2119               ; Data for VRAM Write (High Byte)
CODE_00ABB4:        C8            INY                       
CODE_00ABB5:        CA            DEX                       
CODE_00ABB6:        10 98         BPL CODE_00AB50           
CODE_00ABB8:        A2 00 20      LDX.W #$2000              
CODE_00ABBB:        9C 19 21      STZ.W $2119               ; Data for VRAM Write (High Byte)
CODE_00ABBE:        CA            DEX                       
CODE_00ABBF:        D0 FA         BNE CODE_00ABBB           
CODE_00ABC1:        E2 10         SEP #$10                  ; Index (8 bit) 
Return00ABC3:       60            RTS                       ; Return 

CODE_00ABC4:        64 04         STZ $04                   
CODE_00ABC6:        26 0F         ROL $0F                   
CODE_00ABC8:        26 04         ROL $04                   
CODE_00ABCA:        26 0F         ROL $0F                   
CODE_00ABCC:        26 04         ROL $04                   
CODE_00ABCE:        26 0F         ROL $0F                   
CODE_00ABD0:        26 04         ROL $04                   
Return00ABD2:       60            RTS                       ; Return 


DATA_00ABD3:                      .db $00,$18,$30,$48,$60,$78,$90,$A8
                                  .db $00,$14,$28,$3C

DATA_00ABDF:                      .db $00,$00,$38,$00,$70,$00,$A8,$00
                                  .db $E0,$00,$18,$01,$50,$01

LoadPalette:        C2 30         REP #$30                  ; 16 bit A, X and Y ; Index (16 bit) Accum (16 bit) 
CODE_00ABEF:        A9 DD 7F      LDA.W #$7FDD              ; \  
CODE_00ABF2:        85 04         STA $04                   ;  |Set color 1 in all object palettes to white 
CODE_00ABF4:        A2 02 00      LDX.W #$0002              ;  | 
CODE_00ABF7:        20 ED AC      JSR.W LoadCol8Pal         ; /  
CODE_00ABFA:        A9 FF 7F      LDA.W #$7FFF              ; \  
CODE_00ABFD:        85 04         STA $04                   ;  |Set color 1 in all sprite palettes to white 
CODE_00ABFF:        A2 02 01      LDX.W #$0102              ;  | 
CODE_00AC02:        20 ED AC      JSR.W LoadCol8Pal         ; /  
CODE_00AC05:        A9 70 B1      LDA.W #$B170              ; \  
CODE_00AC08:        85 00         STA $00                   ;  | 
CODE_00AC0A:        A9 10 00      LDA.W #$0010              ;  |Load colors 8-16 in the first two object palettes from 00/B170 
CODE_00AC0D:        85 04         STA $04                   ;  |(Layer 3 palettes) 
CODE_00AC0F:        A9 07 00      LDA.W #$0007              ;  | 
CODE_00AC12:        85 06         STA $06                   ;  | 
CODE_00AC14:        A9 01 00      LDA.W #$0001              ;  | 
CODE_00AC17:        85 08         STA $08                   ;  | 
CODE_00AC19:        20 FF AC      JSR.W LoadColors          ; /  
CODE_00AC1C:        A9 50 B2      LDA.W #$B250              ; \  
CODE_00AC1F:        85 00         STA $00                   ;  | 
CODE_00AC21:        A9 84 00      LDA.W #$0084              ;  |Load colors 2-7 in palettes 4-D from 00/B250 
CODE_00AC24:        85 04         STA $04                   ;  |(Object and sprite palettes) 
CODE_00AC26:        A9 05 00      LDA.W #$0005              ;  | 
CODE_00AC29:        85 06         STA $06                   ;  | 
CODE_00AC2B:        A9 09 00      LDA.W #$0009              ;  | 
CODE_00AC2E:        85 08         STA $08                   ;  | 
CODE_00AC30:        20 FF AC      JSR.W LoadColors          ; /  
CODE_00AC33:        AD 2F 19      LDA.W $192F               ; \  
CODE_00AC36:        29 0F 00      AND.W #$000F              ;  | 
CODE_00AC39:        0A            ASL                       ;  |Load background color 
CODE_00AC3A:        A8            TAY                       ;  | 
CODE_00AC3B:        B9 A0 B0      LDA.W Palettes?,Y         ;  | 
CODE_00AC3E:        8D 01 07      STA.W $0701               ; /  
CODE_00AC41:        A9 90 B1      LDA.W #$B190              ; \Store base address in $00, ... 
CODE_00AC44:        85 00         STA $00                   ; / 
CODE_00AC46:        AD 2D 19      LDA.W $192D               ; \...get current object palette, ... 
CODE_00AC49:        29 0F 00      AND.W #$000F              ; / 
CODE_00AC4C:        A8            TAY                       ; \  
CODE_00AC4D:        B9 D3 AB      LDA.W DATA_00ABD3,Y       ;  | 
CODE_00AC50:        29 FF 00      AND.W #$00FF              ;  |...use it to figure out where to load from, ... 
CODE_00AC53:        18            CLC                       ;  | 
CODE_00AC54:        65 00         ADC $00                   ;  |...add it to the base address... 
CODE_00AC56:        85 00         STA $00                   ; / ...and store it in $00 
CODE_00AC58:        A9 44 00      LDA.W #$0044              ; \  
CODE_00AC5B:        85 04         STA $04                   ;  | 
CODE_00AC5D:        A9 05 00      LDA.W #$0005              ;  | 
CODE_00AC60:        85 06         STA $06                   ;  |Load colors 2-7 in object palettes 2 and 3 from the address in $00 
CODE_00AC62:        A9 01 00      LDA.W #$0001              ;  | 
CODE_00AC65:        85 08         STA $08                   ;  | 
CODE_00AC67:        20 FF AC      JSR.W LoadColors          ; /  
CODE_00AC6A:        A9 18 B3      LDA.W #$B318              ; \Store base address in $00, ... 
CODE_00AC6D:        85 00         STA $00                   ; / 
CODE_00AC6F:        AD 2E 19      LDA.W $192E               ; \...get current sprite palette, ... 
CODE_00AC72:        29 0F 00      AND.W #$000F              ; / 
CODE_00AC75:        A8            TAY                       ; \  
CODE_00AC76:        B9 D3 AB      LDA.W DATA_00ABD3,Y       ;  | 
CODE_00AC79:        29 FF 00      AND.W #$00FF              ;  |...use it to figure out where to load from, ... 
CODE_00AC7C:        18            CLC                       ;  | 
CODE_00AC7D:        65 00         ADC $00                   ;  |...add it to the base address... 
CODE_00AC7F:        85 00         STA $00                   ; / ...and store it in $00 
CODE_00AC81:        A9 C4 01      LDA.W #$01C4              ; \  
CODE_00AC84:        85 04         STA $04                   ;  | 
CODE_00AC86:        A9 05 00      LDA.W #$0005              ;  | 
CODE_00AC89:        85 06         STA $06                   ;  |Load colors 2-7 in sprite palettes 6 and 7 from the address in $00 
CODE_00AC8B:        A9 01 00      LDA.W #$0001              ;  | 
CODE_00AC8E:        85 08         STA $08                   ;  | 
CODE_00AC90:        20 FF AC      JSR.W LoadColors          ; /  
CODE_00AC93:        A9 B0 B0      LDA.W #$B0B0              ; \Store bade address in $00, ... 
CODE_00AC96:        85 00         STA $00                   ; / 
CODE_00AC98:        AD 30 19      LDA.W $1930               ; \...get current background palette, ... 
CODE_00AC9B:        29 0F 00      AND.W #$000F              ; / 
CODE_00AC9E:        A8            TAY                       ; \  
CODE_00AC9F:        B9 D3 AB      LDA.W DATA_00ABD3,Y       ;  | 
CODE_00ACA2:        29 FF 00      AND.W #$00FF              ;  |...use it to figure out where to load from, ... 
CODE_00ACA5:        18            CLC                       ;  | 
CODE_00ACA6:        65 00         ADC $00                   ;  |...add it to the base address... 
CODE_00ACA8:        85 00         STA $00                   ; / ...and store it in $00 
CODE_00ACAA:        A9 04 00      LDA.W #$0004              ; \  
CODE_00ACAD:        85 04         STA $04                   ;  | 
CODE_00ACAF:        A9 05 00      LDA.W #$0005              ;  | 
CODE_00ACB2:        85 06         STA $06                   ;  |Load colors 2-7 in object palettes 0 and 1 from the address in $00 
CODE_00ACB4:        A9 01 00      LDA.W #$0001              ;  | 
CODE_00ACB7:        85 08         STA $08                   ;  | 
CODE_00ACB9:        20 FF AC      JSR.W LoadColors          ; /  
CODE_00ACBC:        A9 74 B6      LDA.W #$B674              ; \  
CODE_00ACBF:        85 00         STA $00                   ;  | 
CODE_00ACC1:        A9 52 00      LDA.W #$0052              ;  | 
CODE_00ACC4:        85 04         STA $04                   ;  | 
CODE_00ACC6:        A9 06 00      LDA.W #$0006              ;  |Load colors 9-F in object palettes 2-4 from 00/B674 
CODE_00ACC9:        85 06         STA $06                   ;  | 
CODE_00ACCB:        A9 02 00      LDA.W #$0002              ;  | 
CODE_00ACCE:        85 08         STA $08                   ;  | 
CODE_00ACD0:        20 FF AC      JSR.W LoadColors          ; /  
CODE_00ACD3:        A9 74 B6      LDA.W #$B674              ; \  
CODE_00ACD6:        85 00         STA $00                   ;  | 
CODE_00ACD8:        A9 32 01      LDA.W #$0132              ;  | 
CODE_00ACDB:        85 04         STA $04                   ;  | 
CODE_00ACDD:        A9 06 00      LDA.W #$0006              ;  |Load colors 9-F in sprite palettes 1-3 from 00/B674 
CODE_00ACE0:        85 06         STA $06                   ;  | 
CODE_00ACE2:        A9 02 00      LDA.W #$0002              ;  | 
CODE_00ACE5:        85 08         STA $08                   ;  | 
CODE_00ACE7:        20 FF AC      JSR.W LoadColors          ; /  
CODE_00ACEA:        E2 30         SEP #$30                  ; 8 bit A, X and Y ; Index (8 bit) Accum (8 bit) 
Return00ACEC:       60            RTS                       ; Return 

LoadCol8Pal:        A0 07 00      LDY.W #$0007              ; Index (16 bit) Accum (16 bit) 
CODE_00ACF0:        A5 04         LDA $04                   
CODE_00ACF2:        9D 03 07      STA.W $0703,X             
CODE_00ACF5:        8A            TXA                       
CODE_00ACF6:        18            CLC                       
CODE_00ACF7:        69 20 00      ADC.W #$0020              
CODE_00ACFA:        AA            TAX                       
CODE_00ACFB:        88            DEY                       
CODE_00ACFC:        10 F2         BPL CODE_00ACF0           
Return00ACFE:       60            RTS                       ; Return 

LoadColors:         A6 04         LDX $04                   
CODE_00AD01:        A4 06         LDY $06                   
CODE_00AD03:        B2 00         LDA ($00)                 
CODE_00AD05:        9D 03 07      STA.W $0703,X             
CODE_00AD08:        E6 00         INC $00                   
CODE_00AD0A:        E6 00         INC $00                   
CODE_00AD0C:        E8            INX                       
CODE_00AD0D:        E8            INX                       
CODE_00AD0E:        88            DEY                       
CODE_00AD0F:        10 F2         BPL CODE_00AD03           
CODE_00AD11:        A5 04         LDA $04                   
CODE_00AD13:        18            CLC                       
CODE_00AD14:        69 20 00      ADC.W #$0020              
CODE_00AD17:        85 04         STA $04                   
CODE_00AD19:        C6 08         DEC $08                   
CODE_00AD1B:        10 E2         BPL LoadColors            
Return00AD1D:       60            RTS                       ; Return 


DATA_00AD1E:                      .db $01,$00,$03,$04,$03,$05,$02

CODE_00AD25:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00AD27:        A0 D8 B3      LDY.W #$B3D8              
CODE_00AD2A:        AD EA 1E      LDA.W $1EEA               
CODE_00AD2D:        10 03         BPL CODE_00AD32           
CODE_00AD2F:        A0 32 B7      LDY.W #$B732              
CODE_00AD32:        84 00         STY $00                   
CODE_00AD34:        AD 31 19      LDA.W $1931               
CODE_00AD37:        29 0F 00      AND.W #$000F              
CODE_00AD3A:        3A            DEC A                     
CODE_00AD3B:        A8            TAY                       
CODE_00AD3C:        B9 1E AD      LDA.W DATA_00AD1E,Y       
CODE_00AD3F:        29 FF 00      AND.W #$00FF              
CODE_00AD42:        0A            ASL                       
CODE_00AD43:        A8            TAY                       
CODE_00AD44:        B9 DF AB      LDA.W DATA_00ABDF,Y       
CODE_00AD47:        18            CLC                       
CODE_00AD48:        65 00         ADC $00                   
CODE_00AD4A:        85 00         STA $00                   
CODE_00AD4C:        A9 82 00      LDA.W #$0082              
CODE_00AD4F:        85 04         STA $04                   
CODE_00AD51:        A9 06 00      LDA.W #$0006              
CODE_00AD54:        85 06         STA $06                   
CODE_00AD56:        A9 03 00      LDA.W #$0003              
CODE_00AD59:        85 08         STA $08                   
CODE_00AD5B:        20 FF AC      JSR.W LoadColors          
CODE_00AD5E:        A9 28 B5      LDA.W #$B528              
CODE_00AD61:        85 00         STA $00                   
CODE_00AD63:        A9 52 00      LDA.W #$0052              
CODE_00AD66:        85 04         STA $04                   
CODE_00AD68:        A9 06 00      LDA.W #$0006              
CODE_00AD6B:        85 06         STA $06                   
CODE_00AD6D:        A9 05 00      LDA.W #$0005              
CODE_00AD70:        85 08         STA $08                   
CODE_00AD72:        20 FF AC      JSR.W LoadColors          
CODE_00AD75:        A9 7C B5      LDA.W #$B57C              
CODE_00AD78:        85 00         STA $00                   
CODE_00AD7A:        A9 02 01      LDA.W #$0102              
CODE_00AD7D:        85 04         STA $04                   
CODE_00AD7F:        A9 06 00      LDA.W #$0006              
CODE_00AD82:        85 06         STA $06                   
CODE_00AD84:        A9 07 00      LDA.W #$0007              
CODE_00AD87:        85 08         STA $08                   
CODE_00AD89:        20 FF AC      JSR.W LoadColors          
CODE_00AD8C:        A9 EC B5      LDA.W #$B5EC              
CODE_00AD8F:        85 00         STA $00                   
CODE_00AD91:        A9 10 00      LDA.W #$0010              
CODE_00AD94:        85 04         STA $04                   
CODE_00AD96:        A9 07 00      LDA.W #$0007              
CODE_00AD99:        85 06         STA $06                   
CODE_00AD9B:        A9 01 00      LDA.W #$0001              
CODE_00AD9E:        85 08         STA $08                   
CODE_00ADA0:        20 FF AC      JSR.W LoadColors          
CODE_00ADA3:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return00ADA5:       60            RTS                       ; Return 

CODE_00ADA6:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00ADA8:        A9 3C B6      LDA.W #$B63C              
CODE_00ADAB:        85 00         STA $00                   
CODE_00ADAD:        A9 10 00      LDA.W #$0010              
CODE_00ADB0:        85 04         STA $04                   
CODE_00ADB2:        A9 07 00      LDA.W #$0007              
CODE_00ADB5:        85 06         STA $06                   
CODE_00ADB7:        A9 00 00      LDA.W #$0000              
CODE_00ADBA:        85 08         STA $08                   
CODE_00ADBC:        20 FF AC      JSR.W LoadColors          
CODE_00ADBF:        A9 2C B6      LDA.W #$B62C              
CODE_00ADC2:        85 00         STA $00                   
CODE_00ADC4:        A9 30 00      LDA.W #$0030              
CODE_00ADC7:        85 04         STA $04                   
CODE_00ADC9:        A9 07 00      LDA.W #$0007              
CODE_00ADCC:        85 06         STA $06                   
CODE_00ADCE:        A9 00 00      LDA.W #$0000              
CODE_00ADD1:        85 08         STA $08                   
CODE_00ADD3:        20 FF AC      JSR.W LoadColors          
CODE_00ADD6:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return00ADD8:       60            RTS                       ; Return 

CODE_00ADD9:        20 ED AB      JSR.W LoadPalette         
CODE_00ADDC:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00ADDE:        A9 17 00      LDA.W #$0017              
CODE_00ADE1:        8D 01 07      STA.W $0701               
CODE_00ADE4:        A9 70 B1      LDA.W #$B170              
CODE_00ADE7:        85 00         STA $00                   
CODE_00ADE9:        A9 10 00      LDA.W #$0010              
CODE_00ADEC:        85 04         STA $04                   
CODE_00ADEE:        A9 07 00      LDA.W #$0007              
CODE_00ADF1:        85 06         STA $06                   
CODE_00ADF3:        A9 01 00      LDA.W #$0001              
CODE_00ADF6:        85 08         STA $08                   
CODE_00ADF8:        20 FF AC      JSR.W LoadColors          
CODE_00ADFB:        A9 5C B6      LDA.W #$B65C              
CODE_00ADFE:        85 00         STA $00                   
CODE_00AE00:        A9 00 00      LDA.W #$0000              
CODE_00AE03:        85 04         STA $04                   
CODE_00AE05:        A9 07 00      LDA.W #$0007              
CODE_00AE08:        85 06         STA $06                   
CODE_00AE0A:        A9 00 00      LDA.W #$0000              
CODE_00AE0D:        85 08         STA $08                   
CODE_00AE0F:        20 FF AC      JSR.W LoadColors          
CODE_00AE12:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return00AE14:       60            RTS                       ; Return 

CODE_00AE15:        A9 02         LDA.B #$02                
CODE_00AE17:        8D 2E 19      STA.W $192E               
CODE_00AE1A:        A9 07         LDA.B #$07                
CODE_00AE1C:        8D 2D 19      STA.W $192D               
CODE_00AE1F:        20 ED AB      JSR.W LoadPalette         
CODE_00AE22:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00AE24:        A9 17 00      LDA.W #$0017              
CODE_00AE27:        8D 01 07      STA.W $0701               
CODE_00AE2A:        A9 F4 B5      LDA.W #$B5F4              
CODE_00AE2D:        85 00         STA $00                   
CODE_00AE2F:        A9 18 00      LDA.W #$0018              
CODE_00AE32:        85 04         STA $04                   
CODE_00AE34:        A9 03 00      LDA.W #$0003              
CODE_00AE37:        85 06         STA $06                   
CODE_00AE39:        64 08         STZ $08                   
CODE_00AE3B:        20 FF AC      JSR.W LoadColors          
CODE_00AE3E:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
Return00AE40:       60            RTS                       ; Return 


DATA_00AE41:                      .db $00,$05,$0A

DATA_00AE44:                      .db $20,$40,$80

CODE_00AE47:        A2 02         LDX.B #$02                
CODE_00AE49:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00AE4B:        AD 01 07      LDA.W $0701               
CODE_00AE4E:        BC 41 AE      LDY.W DATA_00AE41,X       
CODE_00AE51:        88            DEY                       
CODE_00AE52:        30 03         BMI CODE_00AE57           
CODE_00AE54:        4A            LSR                       
CODE_00AE55:        80 FA         BRA CODE_00AE51           

CODE_00AE57:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00AE59:        29 1F         AND.B #$1F                
CODE_00AE5B:        1D 44 AE      ORA.W DATA_00AE44,X       
CODE_00AE5E:        8D 32 21      STA.W $2132               ; Fixed Color Data
CODE_00AE61:        CA            DEX                       
CODE_00AE62:        10 E5         BPL CODE_00AE49           
Return00AE64:       60            RTS                       ; Return 


DATA_00AE65:                      .db $1F,$00,$E0,$03,$00,$7C

DATA_00AE6B:                      .db $FF,$FF,$E0,$FF,$00,$FC

DATA_00AE71:                      .db $01,$00,$20,$00,$00,$04

DATA_00AE77:                      .db $00,$00,$00,$00,$01,$00,$00,$00
                                  .db $00,$80,$00,$80,$20,$80,$00,$04
                                  .db $80,$80,$80,$80,$08,$82,$40,$10
                                  .db $20,$84,$20,$84,$44,$88,$10,$22
                                  .db $88,$88,$88,$88,$22,$91,$88,$44
                                  .db $48,$92,$48,$92,$92,$A4,$24,$49
                                  .db $A4,$A4,$A4,$A4,$49,$A9,$94,$52
                                  .db $AA,$AA,$94,$52,$AA,$AA,$54,$55
                                  .db $AA,$AA,$AA,$AA,$AA,$D5,$AA,$AA
                                  .db $AA,$D5,$AA,$D5,$B5,$D6,$6A,$AD
                                  .db $DA,$DA,$DA,$DA,$6D,$DB,$DA,$B6
                                  .db $B6,$ED,$B6,$ED,$DD,$EE,$76,$BB
                                  .db $EE,$EE,$EE,$EE,$BB,$F7,$EE,$DD
                                  .db $DE,$FB,$DE,$FB,$F7,$FD,$BE,$EF
                                  .db $FE,$FE,$FE,$FE,$DF,$FF,$FE,$FB
                                  .db $FE,$FF,$FE,$FF,$FF,$FF,$FE,$FF
DATA_00AEF7:                      .db $00,$80,$00,$40,$00,$20,$00,$10
                                  .db $00,$08,$00,$04,$00,$02,$00,$01
                                  .db $80,$00,$40,$00,$20,$00,$10,$00
                                  .db $08,$00,$04,$00,$02,$00,$01,$00

CODE_00AF17:        AC 93 14      LDY.W $1493               
CODE_00AF1A:        A5 13         LDA RAM_FrameCounter      
CODE_00AF1C:        4A            LSR                       
CODE_00AF1D:        90 06         BCC CODE_00AF25           
CODE_00AF1F:        88            DEY                       
CODE_00AF20:        F0 03         BEQ CODE_00AF25           
CODE_00AF22:        8C 93 14      STY.W $1493               
CODE_00AF25:        C0 A0         CPY.B #$A0                
CODE_00AF27:        B0 0C         BCS CODE_00AF35           
CODE_00AF29:        A9 04         LDA.B #$04                
CODE_00AF2B:        14 40         TRB $40                   
CODE_00AF2D:        A9 09         LDA.B #$09                
CODE_00AF2F:        85 3E         STA $3E                   
CODE_00AF31:        22 FF CB 05   JSL.L CODE_05CBFF         
CODE_00AF35:        A5 13         LDA RAM_FrameCounter      
CODE_00AF37:        29 03         AND.B #$03                
CODE_00AF39:        D0 67         BNE Return00AFA2          
CODE_00AF3B:        AD 95 14      LDA.W $1495               
CODE_00AF3E:        C9 40         CMP.B #$40                
CODE_00AF40:        B0 60         BCS Return00AFA2          
CODE_00AF42:        20 A3 AF      JSR.W CODE_00AFA3         ; Index (16 bit) Accum (16 bit) 
CODE_00AF45:        A9 FE 01      LDA.W #$01FE              
CODE_00AF48:        8D 05 09      STA.W $0905               
CODE_00AF4B:        A2 EE 00      LDX.W #$00EE              
CODE_00AF4E:        A9 07 00      LDA.W #$0007              
CODE_00AF51:        85 00         STA $00                   
CODE_00AF53:        BD 05 09      LDA.W $0905,X             
CODE_00AF56:        85 02         STA $02                   
CODE_00AF58:        BD 03 07      LDA.W $0703,X             
CODE_00AF5B:        20 C0 AF      JSR.W CODE_00AFC0         
CODE_00AF5E:        A5 04         LDA $04                   
CODE_00AF60:        9D 05 09      STA.W $0905,X             
CODE_00AF63:        CA            DEX                       
CODE_00AF64:        CA            DEX                       
CODE_00AF65:        C6 00         DEC $00                   
CODE_00AF67:        D0 EA         BNE CODE_00AF53           
CODE_00AF69:        8A            TXA                       
CODE_00AF6A:        38            SEC                       
CODE_00AF6B:        E9 12 00      SBC.W #$0012              
CODE_00AF6E:        AA            TAX                       
CODE_00AF6F:        10 DD         BPL CODE_00AF4E           
CODE_00AF71:        A2 04 00      LDX.W #$0004              
CODE_00AF74:        BD 1F 09      LDA.W $091F,X             
CODE_00AF77:        85 02         STA $02                   
CODE_00AF79:        BD 1D 07      LDA.W $071D,X             
CODE_00AF7C:        20 C0 AF      JSR.W CODE_00AFC0         
CODE_00AF7F:        A5 04         LDA $04                   
CODE_00AF81:        9D 1F 09      STA.W $091F,X             
CODE_00AF84:        CA            DEX                       
CODE_00AF85:        CA            DEX                       
CODE_00AF86:        10 EC         BPL CODE_00AF74           
CODE_00AF88:        AD 01 07      LDA.W $0701               
CODE_00AF8B:        85 02         STA $02                   
CODE_00AF8D:        AD 03 09      LDA.W $0903               
CODE_00AF90:        20 C0 AF      JSR.W CODE_00AFC0         
CODE_00AF93:        A5 04         LDA $04                   
CODE_00AF95:        8D 01 07      STA.W $0701               
CODE_00AF98:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_00AF9A:        9C 05 0A      STZ.W $0A05               
CODE_00AF9D:        A9 03         LDA.B #$03                
CODE_00AF9F:        8D 80 06      STA.W $0680               
Return00AFA2:       60            RTS                       ; Return 

CODE_00AFA3:        A8            TAY                       
CODE_00AFA4:        1A            INC A                     
CODE_00AFA5:        1A            INC A                     
CODE_00AFA6:        8D 95 14      STA.W $1495               
CODE_00AFA9:        98            TYA                       
CODE_00AFAA:        4A            LSR                       
CODE_00AFAB:        4A            LSR                       
CODE_00AFAC:        4A            LSR                       
CODE_00AFAD:        4A            LSR                       
CODE_00AFAE:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00AFB0:        29 02 00      AND.W #$0002              
CODE_00AFB3:        85 0C         STA $0C                   
CODE_00AFB5:        98            TYA                       
CODE_00AFB6:        29 1E 00      AND.W #$001E              
CODE_00AFB9:        A8            TAY                       
CODE_00AFBA:        B9 F7 AE      LDA.W DATA_00AEF7,Y       
CODE_00AFBD:        85 0E         STA $0E                   
Return00AFBF:       60            RTS                       ; Return 

CODE_00AFC0:        85 0A         STA $0A                   
CODE_00AFC2:        29 1F 00      AND.W #$001F              
CODE_00AFC5:        0A            ASL                       
CODE_00AFC6:        0A            ASL                       
CODE_00AFC7:        85 06         STA $06                   
CODE_00AFC9:        A5 0A         LDA $0A                   
CODE_00AFCB:        29 E0 03      AND.W #$03E0              
CODE_00AFCE:        4A            LSR                       
CODE_00AFCF:        4A            LSR                       
CODE_00AFD0:        4A            LSR                       
CODE_00AFD1:        85 08         STA $08                   
CODE_00AFD3:        A5 0B         LDA $0B                   
CODE_00AFD5:        29 7C 00      AND.W #$007C              
CODE_00AFD8:        85 0A         STA $0A                   
CODE_00AFDA:        64 04         STZ $04                   
CODE_00AFDC:        A0 04 00      LDY.W #$0004              
CODE_00AFDF:        5A            PHY                       
CODE_00AFE0:        B9 06 00      LDA.W $0006,Y             
CODE_00AFE3:        05 0C         ORA $0C                   
CODE_00AFE5:        A8            TAY                       
CODE_00AFE6:        B9 77 AE      LDA.W DATA_00AE77,Y       
CODE_00AFE9:        7A            PLY                       
CODE_00AFEA:        25 0E         AND $0E                   
CODE_00AFEC:        F0 0B         BEQ CODE_00AFF9           
CODE_00AFEE:        B9 6B AE      LDA.W DATA_00AE6B,Y       
CODE_00AFF1:        2C 93 14      BIT.W $1493               
CODE_00AFF4:        10 03         BPL CODE_00AFF9           
CODE_00AFF6:        B9 71 AE      LDA.W DATA_00AE71,Y       
CODE_00AFF9:        18            CLC                       
CODE_00AFFA:        65 02         ADC $02                   
CODE_00AFFC:        39 65 AE      AND.W DATA_00AE65,Y       
CODE_00AFFF:        04 04         TSB $04                   
CODE_00B001:        88            DEY                       
CODE_00B002:        88            DEY                       
CODE_00B003:        10 DA         BPL CODE_00AFDF           
Return00B005:       60            RTS                       ; Return 

CODE_00B006:        8B            PHB                       
CODE_00B007:        4B            PHK                       
CODE_00B008:        AB            PLB                       
CODE_00B009:        20 A3 AF      JSR.W CODE_00AFA3         
CODE_00B00C:        A2 6E 00      LDX.W #$006E              
CODE_00B00F:        A0 08 00      LDY.W #$0008              
CODE_00B012:        BD 07 09      LDA.W $0907,X             
CODE_00B015:        85 02         STA $02                   
CODE_00B017:        BD 83 07      LDA.W $0783,X             
CODE_00B01A:        5A            PHY                       
CODE_00B01B:        20 C0 AF      JSR.W CODE_00AFC0         
CODE_00B01E:        7A            PLY                       
CODE_00B01F:        A5 04         LDA $04                   
CODE_00B021:        9D 07 09      STA.W $0907,X             
CODE_00B024:        BD 83 07      LDA.W $0783,X             
CODE_00B027:        38            SEC                       
CODE_00B028:        E5 04         SBC $04                   
CODE_00B02A:        9D 79 09      STA.W $0979,X             
CODE_00B02D:        CA            DEX                       
CODE_00B02E:        CA            DEX                       
CODE_00B02F:        88            DEY                       
CODE_00B030:        D0 E0         BNE CODE_00B012           
CODE_00B032:        8A            TXA                       
CODE_00B033:        38            SEC                       
CODE_00B034:        E9 10 00      SBC.W #$0010              
CODE_00B037:        AA            TAX                       
CODE_00B038:        10 D5         BPL CODE_00B00F           
CODE_00B03A:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_00B03C:        AB            PLB                       
Return00B03D:       6B            RTL                       ; Return 

CODE_00B03E:        20 35 AF      JSR.W CODE_00AF35         
CODE_00B041:        AD 80 06      LDA.W $0680               
CODE_00B044:        C9 03         CMP.B #$03                
CODE_00B046:        D0 48         BNE Return00B090          
CODE_00B048:        A9 00         LDA.B #$00                
CODE_00B04A:        85 02         STA $02                   
CODE_00B04C:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00B04E:        AD 82 0D      LDA.W $0D82               
CODE_00B051:        85 00         STA $00                   
CODE_00B053:        A0 14 00      LDY.W #$0014              
CODE_00B056:        B7 00         LDA [$00],Y               
CODE_00B058:        99 11 0A      STA.W $0A11,Y             
CODE_00B05B:        88            DEY                       
CODE_00B05C:        88            DEY                       
CODE_00B05D:        10 F7         BPL CODE_00B056           
CODE_00B05F:        A9 EE 81      LDA.W #$81EE              
CODE_00B062:        8D 05 0A      STA.W $0A05               
CODE_00B065:        A2 CE 00      LDX.W #$00CE              
CODE_00B068:        A9 07 00      LDA.W #$0007              
CODE_00B06B:        85 00         STA $00                   
CODE_00B06D:        BD 25 0A      LDA.W $0A25,X             
CODE_00B070:        85 02         STA $02                   
CODE_00B072:        BD 23 08      LDA.W $0823,X             
CODE_00B075:        20 C0 AF      JSR.W CODE_00AFC0         
CODE_00B078:        A5 04         LDA $04                   
CODE_00B07A:        9D 25 0A      STA.W $0A25,X             
CODE_00B07D:        CA            DEX                       
CODE_00B07E:        CA            DEX                       
CODE_00B07F:        C6 00         DEC $00                   
CODE_00B081:        D0 EA         BNE CODE_00B06D           
CODE_00B083:        8A            TXA                       
CODE_00B084:        38            SEC                       
CODE_00B085:        E9 12 00      SBC.W #$0012              
CODE_00B088:        AA            TAX                       
CODE_00B089:        10 DD         BPL CODE_00B068           
CODE_00B08B:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_00B08D:        9C F5 0A      STZ.W $0AF5               
Return00B090:       60            RTS                       ; Return 


DATA_00B091:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF

Palettes?:                        .db $9F,$5B,$FB,$6F,$80,$5D,$00,$00
                                  .db $22,$1D,$C3,$24,$93,$73,$FF,$7F
                                  .db $49,$3A,$8B,$42,$CD,$4A,$0F,$53
                                  .db $51,$5B,$93,$63,$FF,$7F,$00,$00
                                  .db $20,$7F,$80,$7F,$E0,$7F,$E0,$7F
                                  .db $42,$39,$08,$52,$CE,$6A,$12,$63
                                  .db $55,$6B,$98,$73,$42,$39,$08,$52
                                  .db $CE,$6A,$42,$39,$08,$52,$CE,$6A
                                  .db $D6,$4E,$18,$57,$5A,$5F,$9C,$67
                                  .db $DE,$6F,$FF,$77,$FF,$7F,$00,$00
                                  .db $20,$7F,$80,$7F,$E0,$7F,$E0,$7F
                                  .db $A3,$20,$48,$31,$AC,$3D,$CE,$39
                                  .db $32,$3E,$B6,$4A,$A2,$20,$25,$2D
                                  .db $68,$35,$8A,$35,$E4,$24,$52,$4A
                                  .db $C8,$50,$CC,$59,$6D,$52,$EB,$58
                                  .db $4C,$65,$D0,$5A,$80,$5D,$39,$7F
                                  .db $93,$7E,$A8,$65,$48,$56,$28,$57
                                  .db $62,$14,$46,$35,$A9,$45,$0D,$52
                                  .db $B1,$62,$77,$7B,$00,$00,$1E,$7B
                                  .db $9F,$7B,$99,$7F,$F6,$7F,$FC,$7F
                                  .db $00,$00,$C5,$24,$49,$2D,$AD,$2D
                                  .db $53,$22,$18,$3F,$60,$10,$81,$18
                                  .db $A3,$1C,$E4,$1C,$09,$29,$4B,$25
                                  .db $60,$09,$A4,$01,$E8,$01,$2C,$02
                                  .db $91,$02,$F5,$02,$FF,$7F,$00,$00
                                  .db $E0,$7E,$20,$7F,$80,$7F,$E0,$7F
                                  .db $93,$73,$00,$00,$FB,$0C,$EB,$2F
                                  .db $93,$73,$00,$00,$DD,$7F,$7F,$2D
                                  .db $93,$73,$00,$00,$AB,$7A,$FF,$7F
                                  .db $93,$73,$00,$00,$9B,$1E,$7F,$3B
                                  .db $00,$00,$AF,$0D,$79,$2E,$E0,$25
                                  .db $1C,$2B,$20,$03,$00,$00,$6B,$2D
                                  .db $EF,$3D,$73,$4E,$18,$63,$9C,$73
                                  .db $00,$00,$E9,$00,$0D,$22,$8E,$05
                                  .db $33,$1A,$B7,$32,$00,$00,$E0,$2D
                                  .db $E0,$52,$7F,$15,$5F,$32,$3F,$4B
                                  .db $00,$00,$C8,$59,$CE,$72,$CB,$39
                                  .db $30,$3E,$B3,$4A,$00,$00,$16,$00
                                  .db $1B,$00,$5F,$01,$1F,$02,$1F,$03
                                  .db $00,$00,$EC,$49,$4F,$52,$B2,$5A
                                  .db $15,$67,$DB,$7F,$00,$00,$16,$00
                                  .db $1B,$00,$5F,$01,$1F,$02,$1F,$03
                                  .db $00,$00,$C9,$08,$4E,$19,$D3,$29
                                  .db $78,$3E,$1D,$53,$00,$00,$C8,$14
                                  .db $09,$1D,$6C,$29,$CF,$35,$32,$42
                                  .db $EF,$55,$B5,$6E,$F7,$76,$39,$7F
                                  .db $7B,$7F,$BD,$7F,$00,$00,$C9,$2C
                                  .db $4E,$41,$D3,$55,$78,$6E,$1D,$7F
                                  .db $00,$00,$E9,$01,$AC,$02,$2F,$03
                                  .db $99,$03,$FE,$53,$00,$00,$00,$00
                                  .db $00,$00,$8F,$3C,$D8,$61,$7F,$7E
                                  .db $00,$00,$C5,$24,$49,$2D,$AD,$2D
                                  .db $53,$22,$18,$3F,$00,$00,$16,$00
                                  .db $1B,$00,$5F,$01,$1F,$02,$1F,$03
                                  .db $CE,$39,$00,$00,$18,$63,$34,$7F
                                  .db $95,$7F,$F8,$7F,$00,$00,$B7,$32
                                  .db $FB,$67,$00,$02,$20,$03,$E0,$03
                                  .db $00,$00,$71,$0D,$3F,$7C,$9B,$1E
                                  .db $7F,$13,$FF,$03,$00,$00,$17,$28
                                  .db $1F,$40,$29,$45,$AD,$59,$10,$66
                                  .db $00,$00,$71,$0D,$9B,$1E,$7F,$3B
                                  .db $FF,$7F,$FF,$7F,$00,$00,$CE,$39
                                  .db $94,$52,$18,$63,$9C,$73,$5F,$2C
                                  .db $00,$00,$FF,$01,$1F,$03,$FF,$03
                                  .db $B7,$00,$3F,$02,$00,$00,$08,$6D
                                  .db $AD,$6D,$31,$7E,$B7,$00,$3F,$02
                                  .db $00,$00,$11,$00,$17,$00,$1F,$00
                                  .db $B7,$00,$3F,$02,$00,$00,$E0,$01
                                  .db $E0,$02,$E0,$03,$B7,$00,$3F,$02
                                  .db $5F,$63,$1D,$58,$0A,$00,$1F,$39
                                  .db $C4,$44,$08,$4E,$70,$67,$B6,$30
                                  .db $DF,$35,$FF,$03,$3F,$4F,$1D,$58
                                  .db $40,$11,$E0,$3F,$07,$3C,$AE,$7C
                                  .db $B3,$7D,$00,$2F,$5F,$16,$FF,$03
                                  .db $5F,$63,$1D,$58,$29,$25,$FF,$7F
                                  .db $08,$00,$17,$00,$1F,$00,$7B,$57
                                  .db $DF,$0D,$FF,$03,$1F,$3B,$1D,$58
                                  .db $29,$25,$FF,$7F,$40,$11,$E0,$01
                                  .db $E0,$02,$7B,$57,$DF,$0D,$FF,$03
                                  .db $00,$00,$C5,$24,$49,$2D,$AD,$2D
                                  .db $53,$22,$18,$3F,$23,$25,$C4,$35
                                  .db $25,$3E,$86,$46,$E7,$4E,$1F,$40
                                  .db $00,$00,$C6,$41,$54,$73,$FA,$7F
                                  .db $FD,$7F,$08,$6D,$00,$00,$34,$34
                                  .db $3A,$44,$9F,$65,$16,$01,$7F,$02
                                  .db $00,$00,$C5,$24,$49,$2D,$AD,$2D
                                  .db $53,$22,$18,$3F,$00,$00,$AE,$2D
                                  .db $32,$3E,$B6,$4A,$F9,$52,$F3,$2C
                                  .db $00,$00,$6B,$51,$6D,$4E,$B3,$4F
                                  .db $BF,$30,$1D,$37,$32,$2E,$0D,$4A
                                  .db $88,$10,$4A,$21,$6D,$29,$CF,$3D
                                  .db $00,$00,$40,$29,$E0,$3D,$80,$52
                                  .db $B7,$00,$3F,$02,$00,$00,$CE,$39
                                  .db $94,$52,$18,$63,$B7,$00,$3F,$02
                                  .db $00,$00,$70,$7E,$D3,$7E,$36,$7F
                                  .db $99,$7F,$1F,$40,$00,$00,$CE,$39
                                  .db $94,$52,$18,$63,$9C,$73,$5F,$2C
                                  .db $00,$00,$DF,$4E,$DE,$5A,$BD,$66
                                  .db $7C,$72,$1F,$40,$00,$00,$F5,$7F
                                  .db $F7,$7F,$F9,$7F,$FC,$7F,$FF,$7F
BowserEndPalette:                 .db $00,$00,$FB,$63,$0C,$03,$0B,$02
                                  .db $35,$15,$5F,$1A

DATA_00B3CC:                      .db $00,$00,$34,$34,$3A,$44,$9F,$65
                                  .db $16,$01,$7F,$02,$00,$00,$28,$12
                                  .db $A8,$12,$48,$13,$7B,$32,$BF,$5B
                                  .db $60,$7D,$00,$00,$DE,$7B,$48,$13
                                  .db $60,$7D,$7B,$32,$BF,$37,$7F,$2D
                                  .db $00,$00,$68,$32,$E8,$32,$48,$13
                                  .db $FF,$5E,$7F,$6F,$60,$7D,$00,$00
                                  .db $DE,$7B,$3B,$57,$A0,$7E,$F6,$01
                                  .db $A8,$12,$48,$13,$00,$00,$28,$12
                                  .db $A8,$12,$48,$13,$7B,$32,$BF,$5B
                                  .db $28,$7E,$00,$00,$DE,$7B,$48,$13
                                  .db $28,$7E,$7B,$32,$BF,$37,$FF,$03
                                  .db $00,$00,$12,$32,$75,$3E,$3B,$57
                                  .db $7B,$32,$BF,$5B,$28,$7E,$00,$00
                                  .db $DE,$7B,$3B,$57,$28,$7E,$7B,$32
                                  .db $C4,$38,$48,$13,$C7,$2C,$F0,$69
                                  .db $B2,$66,$D5,$67,$34,$66,$DE,$53
                                  .db $FF,$7F,$C7,$2C,$60,$45,$80,$66
                                  .db $F7,$7F,$1F,$03,$7F,$03,$FF,$47
                                  .db $2C,$41,$F0,$69,$B2,$66,$D5,$67
                                  .db $1F,$00,$FF,$7F,$C7,$2C,$C7,$2C
                                  .db $F0,$69,$B2,$66,$D5,$67,$2C,$41
                                  .db $D5,$3A,$9C,$5B,$00,$00,$EC,$49
                                  .db $2E,$56,$F1,$62,$26,$31,$BF,$5B
                                  .db $00,$00,$00,$00,$DE,$7B,$95,$57
                                  .db $28,$7E,$26,$31,$BF,$37,$7F,$2D
                                  .db $00,$00,$26,$31,$89,$3D,$EC,$49
                                  .db $26,$31,$BF,$5B,$28,$7E,$00,$00
                                  .db $DE,$7B,$3B,$57,$C6,$32,$26,$31
                                  .db $7F,$03,$7F,$03,$00,$00,$05,$1A
                                  .db $C5,$0A,$EF,$22,$75,$1A,$59,$43
                                  .db $60,$7D,$00,$00,$39,$77,$EF,$22
                                  .db $60,$7D,$18,$1E,$5C,$37,$09,$7E
                                  .db $00,$00,$60,$36,$20,$4B,$EF,$22
                                  .db $5A,$4E,$3A,$53,$60,$7D,$00,$00
                                  .db $7B,$32,$EF,$22,$19,$21,$F6,$01
                                  .db $E6,$2D,$A8,$36,$C7,$2C,$F0,$69
                                  .db $00,$00,$00,$00,$34,$66,$F9,$7F
                                  .db $FF,$7F,$00,$00,$60,$45,$80,$66
                                  .db $F7,$7F,$1F,$03,$7F,$03,$FF,$47
                                  .db $2C,$41,$F0,$69,$B2,$66,$D5,$67
                                  .db $1F,$00,$FF,$7F,$C7,$2C,$C7,$2C
                                  .db $F0,$69,$B2,$66,$D5,$67,$2C,$41
                                  .db $D5,$3A,$9C,$5B,$00,$00,$E7,$2C
                                  .db $6B,$3D,$EF,$4D,$73,$5E,$F7,$6E
                                  .db $FF,$7F,$F1,$7F,$BF,$01,$00,$7E
                                  .db $BF,$03,$E0,$03,$FC,$7F,$FF,$7F
                                  .db $00,$00,$4F,$19,$78,$3E,$3E,$57
                                  .db $20,$7E,$E0,$7E,$E0,$7F,$00,$00
                                  .db $31,$52,$F6,$66,$9C,$7B,$85,$16
                                  .db $4B,$2F,$F1,$47,$00,$00,$4F,$19
                                  .db $78,$3E,$3E,$57,$FF,$03,$DE,$7B
                                  .db $1F,$7C,$00,$00,$4F,$19,$78,$3E
                                  .db $3E,$57,$7F,$2D,$4B,$2F,$F1,$47
                                  .db $FF,$7F,$00,$00,$71,$0D,$7F,$03
                                  .db $FF,$4F,$3F,$4F,$E0,$7F,$FF,$7F
                                  .db $00,$00,$E0,$01,$AD,$7D,$80,$03
                                  .db $B7,$00,$3F,$02,$FF,$7F,$00,$00
                                  .db $16,$00,$1F,$00,$08,$6D,$DD,$2D
                                  .db $5F,$63,$FF,$7F,$00,$00,$80,$02
                                  .db $E0,$03,$08,$6D,$1A,$26,$3B,$57
                                  .db $FF,$7F,$00,$00,$E0,$7E,$20,$7F
                                  .db $80,$7F,$E0,$7F,$E0,$7F,$FF,$7F
                                  .db $00,$00,$E0,$7E,$20,$7F,$80,$7F
                                  .db $E0,$7F,$E0,$7F,$00,$00,$1B,$00
                                  .db $2D,$46,$F3,$5E,$85,$16,$4B,$2F
                                  .db $F1,$47

DATA_00B5DE:                      .db $00,$00,$E7,$2C,$6B,$3D,$EF,$4D
                                  .db $73,$5E,$F7,$6E,$FF,$7F,$93,$73
                                  .db $00,$00,$FF,$03,$3B,$57,$93,$73
                                  .db $75,$3E,$12,$32,$AF,$25,$93,$73
                                  .db $3B,$57,$FF,$7F,$00,$00,$93,$73
                                  .db $00,$00,$3B,$57,$6C,$7E

MorePalettes:                     .db $DF

DATA_00B60D:                      .db $02,$5F,$03,$FF,$27,$FF,$5F,$FF
                                  .db $73,$FF,$5F,$FF,$27,$5F,$03,$BF
                                  .db $01,$1F,$00,$1B,$00,$18,$00,$18
                                  .db $00,$1B,$00,$1F,$00,$BF,$01,$7F
                                  .db $43,$00,$00,$60,$7F,$3F,$17,$7F
                                  .db $43,$00,$00,$FF,$1C,$20,$03,$7F
                                  .db $43,$00,$00,$20,$03,$60,$7F,$7F
                                  .db $43,$BF,$5B,$7B,$32,$E7,$08,$00
                                  .db $7E,$20,$7E,$A0,$7E,$E0,$7E,$20
                                  .db $7F,$80,$7F,$E0,$7F,$E0,$7F,$00
                                  .db $00,$E0,$1C,$E8,$3D,$F0,$5E,$F8
                                  .db $7F,$FF,$7F,$85,$16,$4B,$2F

DATA_00B66C:                      .db $93,$73,$00,$00,$71,$0D,$9B,$1E
                                  .db $FF,$7F,$00,$00,$20,$03,$16,$00
                                  .db $1F,$00,$7F,$01,$9F,$02,$FF,$7F
                                  .db $00,$00,$20,$03,$7D,$34,$1E,$55
                                  .db $FF,$65,$1F,$7B,$FF,$7F,$00,$00
                                  .db $20,$03,$80,$03,$F1,$1F,$F9,$03
                                  .db $FF,$4F

DATA_00B69E:                      .db $FF,$7F,$C0,$18,$FB,$63,$0C,$03
                                  .db $0B,$02,$35,$15,$5F,$1A,$9B,$77
                                  .db $60,$18,$97,$5B,$A8,$02,$A7,$01
                                  .db $D1,$0C,$FB,$11,$37,$6F,$00,$18
                                  .db $33,$53,$45,$02,$43,$01,$6E,$04
                                  .db $97,$09,$D3,$66,$00,$10,$CF,$4A
                                  .db $E1,$01,$E0,$00,$0A,$00,$33,$01
                                  .db $6F,$5E,$00,$00,$6B,$42,$80,$01
                                  .db $80,$00,$06,$00,$CF,$00,$0B,$56
                                  .db $00,$00,$07,$3A,$20,$01,$20,$00
                                  .db $02,$00,$6B,$00,$A7,$4D,$00,$00
                                  .db $A3,$31,$C0,$00,$00,$00,$00,$00
                                  .db $07,$00,$43,$45,$00,$00,$40,$29
                                  .db $60,$00,$00,$00,$00,$00,$03,$00
TheEndPalettes:                   .db $C4,$44,$20,$03,$DF,$4A,$00,$02
                                  .db $3B,$01,$08,$4E

DATA_00B71A:                      .db $C4,$44,$1F,$39,$DF,$4A,$74,$28
                                  .db $3F,$01,$08,$4E

DATA_00B726:                      .db $D2,$28,$1E,$55,$5F,$63,$1F,$7B
                                  .db $FB,$01,$DE,$02,$00,$00,$33,$15
                                  .db $B7,$25,$3B,$36,$AF,$25,$BF,$5B
                                  .db $C6,$5A,$00,$00,$DE,$7B,$3B,$36
                                  .db $C6,$5A,$AF,$25,$BF,$37,$7F,$2D
                                  .db $00,$00,$33,$15,$B7,$25,$3B,$36
                                  .db $FF,$5E,$7F,$6F,$C6,$5A,$00,$00
                                  .db $DE,$7B,$3B,$57,$C6,$5A,$AF,$25
                                  .db $A8,$12,$48,$13,$00,$00,$B7,$25
                                  .db $3B,$36,$BF,$46,$AF,$25,$5F,$5B
                                  .db $C6,$5A,$00,$00,$DE,$7B,$BF,$46
                                  .db $C6,$5A,$AF,$25,$BF,$37,$FF,$03
                                  .db $00,$00,$85,$16,$4B,$2F,$F1,$47
                                  .db $AF,$25,$5F,$5B,$C6,$5A,$00,$00
                                  .db $DE,$7B,$3B,$57,$C6,$5A,$AF,$25
                                  .db $C4,$38,$48,$13,$E7,$1C,$F3,$19
                                  .db $B9,$32,$7F,$4B,$10,$76,$B9,$2E
                                  .db $FF,$7F,$E7,$1C,$60,$45,$80,$66
                                  .db $F7,$7F,$1F,$03,$7F,$03,$FF,$47
                                  .db $E7,$1C,$F3,$19,$B9,$32,$7F,$4B
                                  .db $1F,$00,$FF,$7F,$E7,$1C,$E7,$1C
                                  .db $F3,$19,$B9,$32,$7F,$4B,$C6,$58
                                  .db $D5,$3A,$9C,$5B,$00,$00,$6D,$1D
                                  .db $D0,$29,$33,$36,$6B,$2D,$F9,$4E
                                  .db $00,$00,$00,$00,$DE,$7B,$33,$36
                                  .db $82,$30,$6B,$2D,$BF,$37,$7F,$2D
                                  .db $00,$00,$A7,$00,$2B,$15,$8E,$21
                                  .db $6B,$2D,$F9,$4E,$82,$30,$00,$00
                                  .db $DE,$7B,$F9,$4E,$82,$30,$6B,$2D
                                  .db $82,$30,$48,$13,$00,$00,$71,$21
                                  .db $F5,$31,$79,$32,$F6,$41,$3B,$57
                                  .db $60,$7D,$00,$00,$39,$77,$79,$32
                                  .db $60,$7D,$18,$1E,$5C,$37,$09,$7E
                                  .db $00,$00,$60,$36,$20,$4B,$EF,$22
                                  .db $7A,$52,$3A,$53,$60,$7D,$00,$00
                                  .db $8E,$21,$79,$32,$19,$21,$75,$3E
                                  .db $35,$11,$98,$1D,$C7,$2C,$F0,$69
                                  .db $00,$00,$00,$00,$34,$66,$F9,$7F
                                  .db $FF,$7F,$00,$00,$60,$45,$80,$66
                                  .db $F7,$7F,$1F,$03,$7F,$03,$FF,$47
                                  .db $2C,$41,$F0,$69,$B2,$66,$D5,$67
                                  .db $1F,$00,$FF,$7F,$C7,$2C,$C7,$2C
                                  .db $F0,$69,$B2,$66,$D5,$67,$2C,$41
                                  .db $D5,$3A,$9C,$5B,$C0,$BF,$08,$00
                                  .db $80,$08

CODE_00B888:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_00B88A:        A0 C0 BF      LDY.W #$BFC0              ; \  
CODE_00B88D:        84 8A         STY $8A                   ;  |Store the address 08/BFC0 at $8A-$8C 
CODE_00B88F:        A9 08         LDA.B #$08                ;  | 
CODE_00B891:        85 8C         STA $8C                   ; /  
CODE_00B893:        A0 00 20      LDY.W #$2000              ; \  
CODE_00B896:        84 00         STY $00                   ;  |Store the address 7E/2000 at $00-$02 
CODE_00B898:        A9 7E         LDA.B #$7E                ;  | 
CODE_00B89A:        85 02         STA $02                   ; /  
CODE_00B89C:        20 DE B8      JSR.W CODE_00B8DE         
CODE_00B89F:        A9 7E         LDA.B #$7E                ; \  
CODE_00B8A1:        85 8F         STA $8F                   ;  | 
CODE_00B8A3:        C2 30         REP #$30                  ;  |Store the address 7E/ACFE at $8D-$8F ; Index (16 bit) Accum (16 bit) 
CODE_00B8A5:        A9 FE AC      LDA.W #$ACFE              ;  | 
CODE_00B8A8:        85 8D         STA $8D                   ; /  
CODE_00B8AA:        A2 FF 23      LDX.W #$23FF              
CODE_00B8AD:        A0 08 00      LDY.W #$0008              
CODE_00B8B0:        BF 00 20 7E   LDA.L $7E2000,X           
CODE_00B8B4:        29 FF 00      AND.W #$00FF              
CODE_00B8B7:        87 8D         STA [$8D]                 
CODE_00B8B9:        CA            DEX                       
CODE_00B8BA:        C6 8D         DEC $8D                   
CODE_00B8BC:        C6 8D         DEC $8D                   
CODE_00B8BE:        88            DEY                       
CODE_00B8BF:        D0 EF         BNE CODE_00B8B0           
CODE_00B8C1:        A0 08 00      LDY.W #$0008              
CODE_00B8C4:        CA            DEX                       
CODE_00B8C5:        BF 00 20 7E   LDA.L $7E2000,X           
CODE_00B8C9:        87 8D         STA [$8D]                 
CODE_00B8CB:        CA            DEX                       
CODE_00B8CC:        30 09         BMI CODE_00B8D7           
CODE_00B8CE:        C6 8D         DEC $8D                   
CODE_00B8D0:        C6 8D         DEC $8D                   
CODE_00B8D2:        88            DEY                       
CODE_00B8D3:        D0 EF         BNE CODE_00B8C4           
CODE_00B8D5:        80 D6         BRA CODE_00B8AD           

CODE_00B8D7:        A9 00 80      LDA.W #$8000              
CODE_00B8DA:        85 8A         STA $8A                   
CODE_00B8DC:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00B8DE:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_00B8E0:        A0 00 00      LDY.W #$0000              ; \  
CODE_00B8E3:        20 83 B9      JSR.W ReadByte            ;  | 
CODE_00B8E6:        C9 FF         CMP.B #$FF                ;  |If the next byte is xFF, return. 
CODE_00B8E8:        D0 03         BNE CODE_00B8ED           ;  |Compressed graphics files ends with xFF IIRC 
CODE_00B8EA:        E2 10         SEP #$10                  ;  | ; Index (8 bit) 
Return00B8EC:       60            RTS                       ; /  

CODE_00B8ED:        85 8F         STA $8F                   
CODE_00B8EF:        29 E0         AND.B #$E0                
CODE_00B8F1:        C9 E0         CMP.B #$E0                
CODE_00B8F3:        F0 0A         BEQ CODE_00B8FF           
CODE_00B8F5:        48            PHA                       
CODE_00B8F6:        A5 8F         LDA $8F                   
CODE_00B8F8:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00B8FA:        29 1F 00      AND.W #$001F              
CODE_00B8FD:        80 12         BRA CODE_00B911           

CODE_00B8FF:        A5 8F         LDA $8F                   ; Accum (8 bit) 
CODE_00B901:        0A            ASL                       
CODE_00B902:        0A            ASL                       
CODE_00B903:        0A            ASL                       
CODE_00B904:        29 E0         AND.B #$E0                
CODE_00B906:        48            PHA                       
CODE_00B907:        A5 8F         LDA $8F                   
CODE_00B909:        29 03         AND.B #$03                
CODE_00B90B:        EB            XBA                       
CODE_00B90C:        20 83 B9      JSR.W ReadByte            
CODE_00B90F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00B911:        1A            INC A                     
CODE_00B912:        85 8D         STA $8D                   
CODE_00B914:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00B916:        68            PLA                       
CODE_00B917:        F0 17         BEQ CODE_00B930           
CODE_00B919:        30 4B         BMI CODE_00B966           
CODE_00B91B:        0A            ASL                       
CODE_00B91C:        10 21         BPL CODE_00B93F           
CODE_00B91E:        0A            ASL                       
CODE_00B91F:        10 2B         BPL CODE_00B94C           
CODE_00B921:        20 83 B9      JSR.W ReadByte            
CODE_00B924:        A6 8D         LDX $8D                   
CODE_00B926:        97 00         STA [$00],Y               
CODE_00B928:        1A            INC A                     
CODE_00B929:        C8            INY                       
CODE_00B92A:        CA            DEX                       
CODE_00B92B:        D0 F9         BNE CODE_00B926           
CODE_00B92D:        4C E3 B8      JMP.W CODE_00B8E3         

CODE_00B930:        20 83 B9      JSR.W ReadByte            
CODE_00B933:        97 00         STA [$00],Y               
CODE_00B935:        C8            INY                       
CODE_00B936:        A6 8D         LDX $8D                   
CODE_00B938:        CA            DEX                       
CODE_00B939:        86 8D         STX $8D                   
CODE_00B93B:        D0 F3         BNE CODE_00B930           
CODE_00B93D:        80 A4         BRA CODE_00B8E3           

CODE_00B93F:        20 83 B9      JSR.W ReadByte            
CODE_00B942:        A6 8D         LDX $8D                   
CODE_00B944:        97 00         STA [$00],Y               
CODE_00B946:        C8            INY                       
CODE_00B947:        CA            DEX                       
CODE_00B948:        D0 FA         BNE CODE_00B944           
CODE_00B94A:        80 97         BRA CODE_00B8E3           

CODE_00B94C:        20 83 B9      JSR.W ReadByte            
CODE_00B94F:        EB            XBA                       
CODE_00B950:        20 83 B9      JSR.W ReadByte            
CODE_00B953:        A6 8D         LDX $8D                   
CODE_00B955:        EB            XBA                       
CODE_00B956:        97 00         STA [$00],Y               
CODE_00B958:        C8            INY                       
CODE_00B959:        CA            DEX                       
CODE_00B95A:        F0 07         BEQ CODE_00B963           
CODE_00B95C:        EB            XBA                       
CODE_00B95D:        97 00         STA [$00],Y               
CODE_00B95F:        C8            INY                       
CODE_00B960:        CA            DEX                       
CODE_00B961:        D0 F2         BNE CODE_00B955           
CODE_00B963:        4C E3 B8      JMP.W CODE_00B8E3         

CODE_00B966:        20 83 B9      JSR.W ReadByte            
CODE_00B969:        EB            XBA                       
CODE_00B96A:        20 83 B9      JSR.W ReadByte            
CODE_00B96D:        AA            TAX                       
CODE_00B96E:        5A            PHY                       
CODE_00B96F:        9B            TXY                       
CODE_00B970:        B7 00         LDA [$00],Y               
CODE_00B972:        BB            TYX                       
CODE_00B973:        7A            PLY                       
CODE_00B974:        97 00         STA [$00],Y               
CODE_00B976:        C8            INY                       
CODE_00B977:        E8            INX                       
CODE_00B978:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00B97A:        C6 8D         DEC $8D                   
CODE_00B97C:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00B97E:        D0 EE         BNE CODE_00B96E           
CODE_00B980:        4C E3 B8      JMP.W CODE_00B8E3         

ReadByte:           A7 8A         LDA [$8A]                 ; Read the byte ; Index (16 bit) 
CODE_00B985:        A6 8A         LDX $8A                   ; \ Go to next byte 
CODE_00B987:        E8            INX                       ;  | 
CODE_00B988:        D0 05         BNE CODE_00B98F           ;  |   \  
CODE_00B98A:        A2 00 80      LDX.W #$8000              ;  |    |Handle bank crossing 
CODE_00B98D:        E6 8C         INC $8C                   ;  |   /  
CODE_00B98F:        86 8A         STX $8A                   ; /  
Return00B991:       60            RTS                       ; Return 


DATA_00B992:                      .db $F9,$31,$BB,$52,$7D,$63,$6C,$10
                                  .db $57,$A1,$15,$9C,$63,$D2,$CB,$E5
                                  .db $1E,$AF,$BD,$10,$48,$E8,$74,$B4
                                  .db $AD,$E4,$80,$66,$7E,$88,$7F,$43
                                  .db $A1,$65,$CD,$CA,$E5,$B5,$21,$44
                                  .db $6C,$A3,$7B,$F0,$B9,$06,$36,$85
                                  .db $BB,$00

DATA_00B9C4:                      .db $D9,$E2,$EC,$F5,$FF,$89,$93,$9D
                                  .db $A6,$AF,$BA,$C3,$CD,$D5,$DD,$E6
                                  .db $EF,$F7,$FF,$89,$93,$9A,$A3,$A9
                                  .db $B2,$BB,$C3,$CC,$D4,$DC,$E6,$EE
                                  .db $F6,$FF,$88,$91,$9A,$A3,$AE,$B7
                                  .db $C0,$C6,$CB,$D0,$D7,$E0,$E9,$F1
                                  .db $F3,$F8

DATA_00B9F6:                      .db $08,$08,$08,$08,$08,$09,$09,$09
                                  .db $09,$09,$09,$09,$09,$09,$09,$09
                                  .db $09,$09,$09,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                                  .db $0A,$0A,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                                  .db $0B,$0B

CODE_00BA28:        8B            PHB                       ; Accum (8 bit) 
CODE_00BA29:        5A            PHY                       
CODE_00BA2A:        4B            PHK                       
CODE_00BA2B:        AB            PLB                       
CODE_00BA2C:        B9 92 B9      LDA.W DATA_00B992,Y       
CODE_00BA2F:        85 8A         STA $8A                   
CODE_00BA31:        B9 C4 B9      LDA.W DATA_00B9C4,Y       
CODE_00BA34:        85 8B         STA $8B                   
CODE_00BA36:        B9 F6 B9      LDA.W DATA_00B9F6,Y       
CODE_00BA39:        85 8C         STA $8C                   
CODE_00BA3B:        A9 00         LDA.B #$00                
CODE_00BA3D:        85 00         STA $00                   
CODE_00BA3F:        A9 AD         LDA.B #$AD                
CODE_00BA41:        85 01         STA $01                   
CODE_00BA43:        A9 7E         LDA.B #$7E                
CODE_00BA45:        85 02         STA $02                   
CODE_00BA47:        20 DE B8      JSR.W CODE_00B8DE         
CODE_00BA4A:        7A            PLY                       
CODE_00BA4B:        AB            PLB                       
Return00BA4C:       6B            RTL                       ; Return 


DATA_00BA4D:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF

DATA_00BA60:                      .db $00,$B0,$60,$10,$C0,$70,$20,$D0
                                  .db $80,$30,$E0,$90,$40,$F0,$A0,$50
DATA_00BA70:                      .db $00,$B0,$60,$10,$C0,$70,$20,$D0
                                  .db $80,$30,$E0,$90,$40,$F0,$A0,$50
DATA_00BA80:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00

DATA_00BA8E:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00

DATA_00BA9C:                      .db $C8,$C9,$CB,$CD,$CE,$D0,$D2,$D3
                                  .db $D5,$D7,$D8,$DA,$DC,$DD,$DF,$E1
DATA_00BAAC:                      .db $E3,$E4,$E6,$E8,$E9,$EB,$ED,$EE
                                  .db $F0,$F2,$F3,$F5,$F7,$F8,$FA,$FC
DATA_00BABC:                      .db $C8,$CA,$CC,$CE,$D0,$D2,$D4,$D6
                                  .db $D8,$DA,$DC,$DE,$E0,$E2

DATA_00BACA:                      .db $E4,$E6,$E8,$EA,$EC,$EE,$F0,$F2
                                  .db $F4,$F6,$F8,$FA,$FC,$FE

DATA_00BAD8:                      .db $00,$C8,$7E,$B0,$C9,$7E,$60,$CB
                                  .db $7E,$10,$CD,$7E,$C0,$CE,$7E,$70
                                  .db $D0,$7E,$20,$D2,$7E,$D0,$D3,$7E
                                  .db $80,$D5,$7E,$30,$D7,$7E,$E0,$D8
                                  .db $7E,$90,$DA,$7E,$40,$DC,$7E,$F0
                                  .db $DD,$7E,$A0,$DF,$7E,$50,$E1,$7E
DATA_00BB08:                      .db $00,$E3,$7E,$B0,$E4,$7E,$60,$E6
                                  .db $7E,$10,$E8,$7E,$C0,$E9,$7E,$70
                                  .db $EB,$7E,$20,$ED,$7E,$D0,$EE,$7E
                                  .db $80,$F0,$7E,$30,$F2,$7E,$E0,$F3
                                  .db $7E,$90,$F5,$7E,$40,$F7,$7E,$F0
                                  .db $F8,$7E,$A0,$FA,$7E,$50,$FC,$7E
DATA_00BB38:                      .db $00,$C8,$7E,$00,$CA,$7E,$00,$CC
                                  .db $7E,$00,$CE,$7E,$00,$D0,$7E,$00
                                  .db $D2,$7E,$00,$D4,$7E,$00,$D6,$7E
                                  .db $00,$D8,$7E,$00,$DA,$7E,$00,$DC
                                  .db $7E,$00,$DE,$7E,$00,$E0,$7E,$00
                                  .db $E2,$7E

DATA_00BB62:                      .db $00,$E3,$7E,$B0,$E4,$7E,$60,$E6
                                  .db $7E,$10,$E8,$7E,$C0,$E9,$7E,$70
                                  .db $EB,$7E,$20,$ED,$7E,$D0,$EE,$7E
                                  .db $80,$F0,$7E,$30,$F2,$7E,$E0,$F3
                                  .db $7E,$90,$F5,$7E,$40,$F7,$7E,$F0
                                  .db $F8,$7E,$A0,$FA,$7E,$50,$FC,$7E
DATA_00BB92:                      .db $00,$C8,$7E,$B0,$C9,$7E,$60,$CB
                                  .db $7E,$10,$CD,$7E,$C0,$CE,$7E,$70
                                  .db $D0,$7E,$20,$D2,$7E,$D0,$D3,$7E
                                  .db $80,$D5,$7E,$30,$D7,$7E,$E0,$D8
                                  .db $7E,$90,$DA,$7E,$40,$DC,$7E,$F0
                                  .db $DD,$7E,$A0,$DF,$7E,$50,$E1,$7E
DATA_00BBC2:                      .db $00,$E4,$7E,$00,$E6,$7E,$00,$E8
                                  .db $7E,$00,$EA,$7E,$00,$EC,$7E,$00
                                  .db $EE,$7E,$00,$F0,$7E,$00,$F2,$7E
                                  .db $00,$F4,$7E,$00,$F6,$7E,$00,$F8
                                  .db $7E,$00,$FA,$7E,$00,$FC,$7E,$00
                                  .db $FE,$7E

DATA_00BBEC:                      .db $00,$C8,$7E,$00,$CA,$7E,$00,$CC
                                  .db $7E,$00,$CE,$7E,$00,$D0,$7E,$00
                                  .db $D2,$7E,$00,$D4,$7E,$00,$D6,$7E
                                  .db $00,$D8,$7E,$00,$DA,$7E,$00,$DC
                                  .db $7E,$00,$DE,$7E,$00,$E0,$7E,$00
                                  .db $E2,$7E

DATA_00BC16:                      .db $00,$E4,$7E,$00,$E6,$7E,$00,$E8
                                  .db $7E,$00,$EA,$7E,$00,$EC,$7E,$00
                                  .db $EE,$7E,$00,$F0,$7E,$00,$F2,$7E
                                  .db $00,$F4,$7E,$00,$F6,$7E,$00,$F8
                                  .db $7E,$00,$FA,$7E,$00,$FC,$7E,$00
                                  .db $FE,$7E

DATA_00BC40:                      .db $00,$C8,$7F,$B0,$C9,$7F,$60,$CB
                                  .db $7F,$10,$CD,$7F,$C0,$CE,$7F,$70
                                  .db $D0,$7F,$20,$D2,$7F,$D0,$D3,$7F
                                  .db $80,$D5,$7F,$30,$D7,$7F,$E0,$D8
                                  .db $7F,$90,$DA,$7F,$40,$DC,$7F,$F0
                                  .db $DD,$7F,$A0,$DF,$7F,$50,$E1,$7F
DATA_00BC70:                      .db $00,$E3,$7F,$B0,$E4,$7F,$60,$E6
                                  .db $7F,$10,$E8,$7F,$C0,$E9,$7F,$70
                                  .db $EB,$7F,$20,$ED,$7F,$D0,$EE,$7F
                                  .db $80,$F0,$7F,$30,$F2,$7F,$E0,$F3
                                  .db $7F,$90,$F5,$7F,$40,$F7,$7F,$F0
                                  .db $F8,$7F,$A0,$FA,$7F,$50,$FC,$7F
DATA_00BCA0:                      .db $00,$C8,$7F,$00,$CA,$7F,$00,$CC
                                  .db $7F,$00,$CE,$7F,$00,$D0,$7F,$00
                                  .db $D2,$7F,$00,$D4,$7F,$00,$D6,$7F
                                  .db $00,$D8,$7F,$00,$DA,$7F,$00,$DC
                                  .db $7F,$00,$DE,$7F,$00,$E0,$7F,$00
                                  .db $E2,$7F

DATA_00BCCA:                      .db $00,$E3,$7F,$B0,$E4,$7F,$60,$E6
                                  .db $7F,$10,$E8,$7F,$C0,$E9,$7F,$70
                                  .db $EB,$7F,$20,$ED,$7F,$D0,$EE,$7F
                                  .db $80,$F0,$7F,$30,$F2,$7F,$E0,$F3
                                  .db $7F,$90,$F5,$7F,$40,$F7,$7F,$F0
                                  .db $F8,$7F,$A0,$FA,$7F,$50,$FC,$7F
DATA_00BCFA:                      .db $00,$C8,$7F,$B0,$C9,$7F,$60,$CB
                                  .db $7F,$10,$CD,$7F,$C0,$CE,$7F,$70
                                  .db $D0,$7F,$20,$D2,$7F,$D0,$D3,$7F
                                  .db $80,$D5,$7F,$30,$D7,$7F,$E0,$D8
                                  .db $7F,$90,$DA,$7F,$40,$DC,$7F,$F0
                                  .db $DD,$7F,$A0,$DF,$7F,$50,$E1,$7F
DATA_00BD2A:                      .db $00,$E4,$7F,$00,$E6,$7F,$00,$E8
                                  .db $7F,$00,$EA,$7F,$00,$EC,$7F,$00
                                  .db $EE,$7F,$00,$F0,$7F,$00,$F2,$7F
                                  .db $00,$F4,$7F,$00,$F6,$7F,$00,$F8
                                  .db $7F,$00,$FA,$7F,$00,$FC,$7F,$00
                                  .db $FE,$7F

DATA_00BD54:                      .db $00,$C8,$7F,$00,$CA,$7F,$00,$CC
                                  .db $7F,$00,$CE,$7F,$00,$D0,$7F,$00
                                  .db $D2,$7F,$00,$D4,$7F,$00,$D6,$7F
                                  .db $00,$D8,$7F,$00,$DA,$7F,$00,$DC
                                  .db $7F,$00,$DE,$7F,$00,$E0,$7F,$00
                                  .db $E2,$7F

DATA_00BD7E:                      .db $00,$E4,$7F,$00,$E6,$7F,$00,$E8
                                  .db $7F,$00,$EA,$7F,$00,$EC,$7F,$00
                                  .db $EE,$7F,$00,$F0,$7F,$00,$F2,$7F
                                  .db $00,$F4,$7F,$00,$F6,$7F,$00,$F8
                                  .db $7F,$00,$FA,$7F,$00,$FC,$7F,$00
                                  .db $FE,$7F

Ptrs00BDA8:            D8 BA      .dw DATA_00BAD8           
                       D8 BA      .dw DATA_00BAD8           
                       D8 BA      .dw DATA_00BAD8           
                       38 BB      .dw DATA_00BB38           
                       38 BB      .dw DATA_00BB38           
                       92 BB      .dw DATA_00BB92           
                       92 BB      .dw DATA_00BB92           
                       EC BB      .dw DATA_00BBEC           
                       EC BB      .dw DATA_00BBEC           
                       00 00      .dw $0000                 
                       EC BB      .dw DATA_00BBEC           
                       00 00      .dw $0000                 
                       D8 BA      .dw DATA_00BAD8           
                       EC BB      .dw DATA_00BBEC           
                       D8 BA      .dw DATA_00BAD8           
                       D8 BA      .dw DATA_00BAD8           
                       00 00      .dw $0000                 
                       D8 BA      .dw DATA_00BAD8           
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       D8 BA      .dw DATA_00BAD8           
                       D8 BA      .dw DATA_00BAD8           

Ptrs00BDE8:            08 BB      .dw DATA_00BB08           
                       08 BB      .dw DATA_00BB08           
                       08 BB      .dw DATA_00BB08           
                       62 BB      .dw DATA_00BB62           
                       62 BB      .dw DATA_00BB62           
                       C2 BB      .dw DATA_00BBC2           
                       C2 BB      .dw DATA_00BBC2           
                       16 BC      .dw DATA_00BC16           
                       16 BC      .dw DATA_00BC16           
                       00 00      .dw $0000                 
                       16 BC      .dw DATA_00BC16           
                       00 00      .dw $0000                 
                       08 BB      .dw DATA_00BB08           
                       16 BC      .dw DATA_00BC16           
                       08 BB      .dw DATA_00BB08           
                       08 BB      .dw DATA_00BB08           
                       00 00      .dw $0000                 
                       08 BB      .dw DATA_00BB08           
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       08 BB      .dw DATA_00BB08           
                       08 BB      .dw DATA_00BB08           

Ptrs00BE28:            40 BC      .dw DATA_00BC40           
                       40 BC      .dw DATA_00BC40           
                       40 BC      .dw DATA_00BC40           
                       A0 BC      .dw DATA_00BCA0           
                       A0 BC      .dw DATA_00BCA0           
                       FA BC      .dw DATA_00BCFA           
                       FA BC      .dw DATA_00BCFA           
                       54 BD      .dw DATA_00BD54           
                       54 BD      .dw DATA_00BD54           
                       00 00      .dw $0000                 
                       54 BD      .dw DATA_00BD54           
                       00 00      .dw $0000                 
                       40 BC      .dw DATA_00BC40           
                       54 BD      .dw DATA_00BD54           
                       40 BC      .dw DATA_00BC40           
                       40 BC      .dw DATA_00BC40           
                       00 00      .dw $0000                 
                       40 BC      .dw DATA_00BC40           
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       40 BC      .dw DATA_00BC40           
                       40 BC      .dw DATA_00BC40           

Ptrs00BE68:            70 BC      .dw DATA_00BC70           
                       70 BC      .dw DATA_00BC70           
                       70 BC      .dw DATA_00BC70           
                       CA BC      .dw DATA_00BCCA           
                       CA BC      .dw DATA_00BCCA           
                       2A BD      .dw DATA_00BD2A           
                       2A BD      .dw DATA_00BD2A           
                       7E BD      .dw DATA_00BD7E           
                       7E BD      .dw DATA_00BD7E           
                       00 00      .dw $0000                 
                       7E BD      .dw DATA_00BD7E           
                       00 00      .dw $0000                 
                       70 BC      .dw DATA_00BC70           
                       7E BD      .dw DATA_00BD7E           
                       70 BC      .dw DATA_00BC70           
                       70 BC      .dw DATA_00BC70           
                       00 00      .dw $0000                 
                       70 BC      .dw DATA_00BC70           
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       00 00      .dw $0000                 
                       70 BC      .dw DATA_00BC70           
                       70 BC      .dw DATA_00BC70           

LoadBlkPtrs:           A8 BD      .dw Ptrs00BDA8            
                       E8 BD      .dw Ptrs00BDE8            
LoadBlkTable2:         28 BE      .dw Ptrs00BE28            
                       68 BE      .dw Ptrs00BE68            

GenerateTile:       08            PHP                       
CODE_00BEB1:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00BEB3:        DA            PHX                       
CODE_00BEB4:        A5 9C         LDA RAM_BlockBlock        
CODE_00BEB6:        29 FF 00      AND.W #$00FF              
CODE_00BEB9:        D0 03         BNE CODE_00BEBE           
ADDR_00BEBB:        4C B9 BF      JMP.W CODE_00BFB9         

CODE_00BEBE:        A5 9A         LDA RAM_BlockYLo          
CODE_00BEC0:        85 0C         STA $0C                   
CODE_00BEC2:        A5 98         LDA RAM_BlockXLo          
CODE_00BEC4:        85 0E         STA $0E                   
CODE_00BEC6:        A9 00 00      LDA.W #$0000              
CODE_00BEC9:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00BECB:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_00BECD:        85 09         STA $09                   
CODE_00BECF:        AD 33 19      LDA.W $1933               
CODE_00BED2:        F0 02         BEQ CODE_00BED6           
ADDR_00BED4:        46 09         LSR $09                   
CODE_00BED6:        A4 0E         LDY $0E                   
CODE_00BED8:        A5 09         LDA $09                   
CODE_00BEDA:        29 01         AND.B #$01                
CODE_00BEDC:        F0 0E         BEQ CODE_00BEEC           
CODE_00BEDE:        A5 9B         LDA RAM_BlockYHi          
CODE_00BEE0:        85 00         STA $00                   
CODE_00BEE2:        A5 99         LDA RAM_BlockXHi          
CODE_00BEE4:        85 9B         STA RAM_BlockYHi          
CODE_00BEE6:        A5 00         LDA $00                   
CODE_00BEE8:        85 99         STA RAM_BlockXHi          
CODE_00BEEA:        A4 0C         LDY $0C                   
CODE_00BEEC:        C0 00 02      CPY.W #$0200              
CODE_00BEEF:        B0 CA         BCS ADDR_00BEBB           
CODE_00BEF1:        AD 33 19      LDA.W $1933               
CODE_00BEF4:        0A            ASL                       
CODE_00BEF5:        AA            TAX                       
CODE_00BEF6:        BF A8 BE 00   LDA.L LoadBlkPtrs,X       ; Set low byte of pointer 
CODE_00BEFA:        85 65         STA $65                   
CODE_00BEFC:        BF A9 BE 00   LDA.L LoadBlkPtrs+1,X     ; Set middle byte of pointer 
CODE_00BF00:        85 66         STA $66                   
CODE_00BF02:        64 67         STZ $67                   ; High byte of pointer = #$00 
CODE_00BF04:        AD 25 19      LDA.W $1925               
CODE_00BF07:        0A            ASL                       
CODE_00BF08:        A8            TAY                       
CODE_00BF09:        B7 65         LDA [$65],Y               
CODE_00BF0B:        85 04         STA $04                   
CODE_00BF0D:        C8            INY                       
CODE_00BF0E:        B7 65         LDA [$65],Y               
CODE_00BF10:        85 05         STA $05                   
CODE_00BF12:        64 06         STZ $06                   
CODE_00BF14:        A5 9B         LDA RAM_BlockYHi          
CODE_00BF16:        85 07         STA $07                   
CODE_00BF18:        0A            ASL                       
CODE_00BF19:        18            CLC                       
CODE_00BF1A:        65 07         ADC $07                   
CODE_00BF1C:        A8            TAY                       
CODE_00BF1D:        B7 04         LDA [$04],Y               
CODE_00BF1F:        85 6B         STA $6B                   
CODE_00BF21:        85 6E         STA $6E                   
CODE_00BF23:        C8            INY                       
CODE_00BF24:        B7 04         LDA [$04],Y               
CODE_00BF26:        85 6C         STA $6C                   
CODE_00BF28:        85 6F         STA $6F                   
CODE_00BF2A:        A9 7E         LDA.B #$7E                
CODE_00BF2C:        85 6D         STA $6D                   
CODE_00BF2E:        1A            INC A                     
CODE_00BF2F:        85 70         STA $70                   
CODE_00BF31:        A5 09         LDA $09                   
CODE_00BF33:        29 01         AND.B #$01                
CODE_00BF35:        F0 0A         BEQ CODE_00BF41           
CODE_00BF37:        A5 99         LDA RAM_BlockXHi          
CODE_00BF39:        4A            LSR                       
CODE_00BF3A:        A5 9B         LDA RAM_BlockYHi          
CODE_00BF3C:        29 01         AND.B #$01                
CODE_00BF3E:        4C 46 BF      JMP.W CODE_00BF46         

CODE_00BF41:        A5 9B         LDA RAM_BlockYHi          
CODE_00BF43:        4A            LSR                       
CODE_00BF44:        A5 99         LDA RAM_BlockXHi          
CODE_00BF46:        2A            ROL                       
CODE_00BF47:        0A            ASL                       
CODE_00BF48:        0A            ASL                       
CODE_00BF49:        09 20         ORA.B #$20                
CODE_00BF4B:        85 04         STA $04                   
CODE_00BF4D:        E0 00 00      CPX.W #$0000              
CODE_00BF50:        F0 05         BEQ CODE_00BF57           
ADDR_00BF52:        18            CLC                       
ADDR_00BF53:        69 10         ADC.B #$10                
ADDR_00BF55:        85 04         STA $04                   
CODE_00BF57:        A5 98         LDA RAM_BlockXLo          
CODE_00BF59:        29 F0         AND.B #$F0                
CODE_00BF5B:        18            CLC                       
CODE_00BF5C:        0A            ASL                       
CODE_00BF5D:        2A            ROL                       
CODE_00BF5E:        85 05         STA $05                   
CODE_00BF60:        2A            ROL                       
CODE_00BF61:        29 03         AND.B #$03                
CODE_00BF63:        05 04         ORA $04                   
CODE_00BF65:        85 06         STA $06                   
CODE_00BF67:        A5 9A         LDA RAM_BlockYLo          
CODE_00BF69:        29 F0         AND.B #$F0                
CODE_00BF6B:        4A            LSR                       
CODE_00BF6C:        4A            LSR                       
CODE_00BF6D:        4A            LSR                       
CODE_00BF6E:        85 04         STA $04                   
CODE_00BF70:        A5 05         LDA $05                   
CODE_00BF72:        29 C0         AND.B #$C0                
CODE_00BF74:        05 04         ORA $04                   
CODE_00BF76:        85 07         STA $07                   
CODE_00BF78:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00BF7A:        A5 09         LDA $09                   
CODE_00BF7C:        29 01 00      AND.W #$0001              
CODE_00BF7F:        D0 1A         BNE CODE_00BF9B           
CODE_00BF81:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_00BF83:        38            SEC                       
CODE_00BF84:        E9 80 00      SBC.W #$0080              
CODE_00BF87:        AA            TAX                       
CODE_00BF88:        A4 1C         LDY RAM_ScreenBndryYLo    
CODE_00BF8A:        AD 33 19      LDA.W $1933               
CODE_00BF8D:        F0 23         BEQ CODE_00BFB2           
ADDR_00BF8F:        A6 1E         LDX $1E                   
ADDR_00BF91:        A5 20         LDA $20                   
ADDR_00BF93:        38            SEC                       
ADDR_00BF94:        E9 80 00      SBC.W #$0080              
ADDR_00BF97:        A8            TAY                       
ADDR_00BF98:        4C B2 BF      JMP.W CODE_00BFB2         

CODE_00BF9B:        A6 1A         LDX RAM_ScreenBndryXLo    
CODE_00BF9D:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_00BF9F:        38            SEC                       
CODE_00BFA0:        E9 80 00      SBC.W #$0080              
CODE_00BFA3:        A8            TAY                       
CODE_00BFA4:        AD 33 19      LDA.W $1933               
CODE_00BFA7:        F0 09         BEQ CODE_00BFB2           
ADDR_00BFA9:        A5 1E         LDA $1E                   
ADDR_00BFAB:        38            SEC                       
ADDR_00BFAC:        E9 80 00      SBC.W #$0080              
ADDR_00BFAF:        AA            TAX                       
ADDR_00BFB0:        A4 20         LDY $20                   
CODE_00BFB2:        86 08         STX $08                   
CODE_00BFB4:        84 0A         STY $0A                   
CODE_00BFB6:        20 BC BF      JSR.W CODE_00BFBC         
CODE_00BFB9:        FA            PLX                       
CODE_00BFBA:        28            PLP                       
Return00BFBB:       6B            RTL                       ; Return 

CODE_00BFBC:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_00BFBE:        A5 9C         LDA RAM_BlockBlock        
CODE_00BFC0:        3A            DEC A                     
CODE_00BFC1:        4B            PHK                       
CODE_00BFC2:        62 03 00      PER $0003                 
CODE_00BFC5:        5C DF 86 00   JMP.L ExecutePtr          ; $9C - Tile generated 


TileGenerationPtr:     74 C0      .dw CODE_00C074           ; 01 - empty space 
                       77 C0      .dw CODE_00C077           ; 02 - empty space 
                       77 C0      .dw CODE_00C077           ; 03 - vine 
                       77 C0      .dw CODE_00C077           ; 04 - tree background, for berries 
                       77 C0      .dw CODE_00C077           ; 05 - always turning block 
                       77 C0      .dw CODE_00C077           ; 06 - coin 
                       77 C0      .dw CODE_00C077           ; 07 - Mushroom scale base 
                       77 C0      .dw CODE_00C077           ; 08 - mole hole 
                       C4 C0      .dw CODE_00C0C4           ; 09 - invisible solid 
                       C4 C0      .dw CODE_00C0C4           ; 0a - multiple coin turnblock 
                       C4 C0      .dw CODE_00C0C4           ; 0b - multiple coin q block 
                       C4 C0      .dw CODE_00C0C4           ; 0c - turn block 
                       C4 C0      .dw CODE_00C0C4           ; 0d - used block 
                       C4 C0      .dw CODE_00C0C4           ; 0e - music block 
                       C4 C0      .dw CODE_00C0C4           ; 0f - music 
                       C4 C0      .dw CODE_00C0C4           ; 10 - all way music block 
                       C4 C0      .dw CODE_00C0C4           ; 11 - sideways turn block 
                       C4 C0      .dw CODE_00C0C4           ; 12 - tranlucent 
                       C4 C0      .dw CODE_00C0C4           ; 13 - on off 
                       C4 C0      .dw CODE_00C0C4           ; 14 - side of pipe, left 
                       C4 C0      .dw CODE_00C0C4           ; 15 - side of pipe, right 
                       C1 C0      .dw CODE_00C0C1           ; 16 - used 
                       C1 C0      .dw CODE_00C0C1           ; 17 - O block from 1up game 
                       AC C1      .dw CODE_00C1AC           ; 18 - invisible block containing wings 
                       34 C3      .dw CODE_00C334           ; 19 - cage 
                       34 C3      .dw CODE_00C334           ; 1a - cage 
                       D1 C3      .dw CODE_00C3D1           ; 1b -  

DATA_00BFFF:                      .db $00,$00,$80,$00,$00,$01

DATA_00C005:                      .db $80,$40,$20,$10,$08,$04,$02,$01

CODE_00C00D:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00C00F:        A5 9A         LDA RAM_BlockYLo          
CODE_00C011:        29 00 FF      AND.W #$FF00              
CODE_00C014:        4A            LSR                       
CODE_00C015:        4A            LSR                       
CODE_00C016:        4A            LSR                       
CODE_00C017:        4A            LSR                       
CODE_00C018:        4A            LSR                       
CODE_00C019:        4A            LSR                       
CODE_00C01A:        85 04         STA $04                   
CODE_00C01C:        A5 9A         LDA RAM_BlockYLo          
CODE_00C01E:        29 80 00      AND.W #$0080              
CODE_00C021:        4A            LSR                       
CODE_00C022:        4A            LSR                       
CODE_00C023:        4A            LSR                       
CODE_00C024:        4A            LSR                       
CODE_00C025:        4A            LSR                       
CODE_00C026:        4A            LSR                       
CODE_00C027:        4A            LSR                       
CODE_00C028:        05 04         ORA $04                   
CODE_00C02A:        85 04         STA $04                   
CODE_00C02C:        A5 98         LDA RAM_BlockXLo          
CODE_00C02E:        29 00 01      AND.W #$0100              
CODE_00C031:        F0 07         BEQ CODE_00C03A           
CODE_00C033:        A5 04         LDA $04                   
CODE_00C035:        09 02 00      ORA.W #$0002              
CODE_00C038:        85 04         STA $04                   
CODE_00C03A:        AD BE 13      LDA.W $13BE               
CODE_00C03D:        29 0F 00      AND.W #$000F              
CODE_00C040:        0A            ASL                       
CODE_00C041:        AA            TAX                       
CODE_00C042:        BF FF BF 00   LDA.L DATA_00BFFF,X       
CODE_00C046:        18            CLC                       
CODE_00C047:        65 04         ADC $04                   
CODE_00C049:        85 04         STA $04                   
CODE_00C04B:        A8            TAY                       
CODE_00C04C:        A5 9A         LDA RAM_BlockYLo          
CODE_00C04E:        29 70 00      AND.W #$0070              
CODE_00C051:        4A            LSR                       
CODE_00C052:        4A            LSR                       
CODE_00C053:        4A            LSR                       
CODE_00C054:        4A            LSR                       
CODE_00C055:        AA            TAX                       
CODE_00C056:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C058:        B9 F8 19      LDA.W $19F8,Y             
CODE_00C05B:        1F 05 C0 00   ORA.L DATA_00C005,X       
CODE_00C05F:        99 F8 19      STA.W $19F8,Y             
Return00C062:       60            RTS                       ; Return 


DATA_00C063:                      .db $7F,$BF,$DF,$EF,$F7,$FB,$FD,$FE
TileToGeneratePg0:                .db $25,$25,$25,$06,$49,$48,$2B,$A2
                                  .db $C6

CODE_00C074:        20 0D C0      JSR.W CODE_00C00D         
CODE_00C077:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00C079:        A5 98         LDA RAM_BlockXLo          
CODE_00C07B:        29 F0 01      AND.W #$01F0              
CODE_00C07E:        85 04         STA $04                   
CODE_00C080:        A5 9A         LDA RAM_BlockYLo          
CODE_00C082:        4A            LSR                       
CODE_00C083:        4A            LSR                       
CODE_00C084:        4A            LSR                       
CODE_00C085:        4A            LSR                       
CODE_00C086:        29 0F 00      AND.W #$000F              
CODE_00C089:        05 04         ORA $04                   
CODE_00C08B:        A8            TAY                       
CODE_00C08C:        A5 9C         LDA RAM_BlockBlock        ; \ X = index of tile to generate 
CODE_00C08E:        29 FF 00      AND.W #$00FF              ;  | 
CODE_00C091:        AA            TAX                       ; / 
CODE_00C092:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C094:        B7 6E         LDA [$6E],Y               ; \ Reset #$01 bit 
CODE_00C096:        29 FE         AND.B #$FE                ;  | 
CODE_00C098:        97 6E         STA [$6E],Y               ; / 
CODE_00C09A:        BF 6B C0 00   LDA.L TileToGeneratePg0,X ; \ Store tile 
CODE_00C09E:        97 6B         STA [$6B],Y               ; / 
CODE_00C0A0:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00C0A2:        29 FF 00      AND.W #$00FF              
CODE_00C0A5:        0A            ASL                       
CODE_00C0A6:        A8            TAY                       
CODE_00C0A7:        4C FB C0      JMP.W CODE_00C0FB         


DATA_00C0AA:                      .db $80,$40,$20,$10,$08,$04,$02,$01
TileToGeneratePg1:                .db $52,$1B,$23,$1E,$32,$13,$15,$16
                                  .db $2B,$2C,$12,$68,$69,$32,$5E

CODE_00C0C1:        20 0D C0      JSR.W CODE_00C00D         
CODE_00C0C4:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00C0C6:        A5 98         LDA RAM_BlockXLo          
CODE_00C0C8:        29 F0 01      AND.W #$01F0              
CODE_00C0CB:        85 04         STA $04                   
CODE_00C0CD:        A5 9A         LDA RAM_BlockYLo          
CODE_00C0CF:        4A            LSR                       
CODE_00C0D0:        4A            LSR                       
CODE_00C0D1:        4A            LSR                       
CODE_00C0D2:        4A            LSR                       
CODE_00C0D3:        29 0F 00      AND.W #$000F              
CODE_00C0D6:        05 04         ORA $04                   
CODE_00C0D8:        A8            TAY                       
CODE_00C0D9:        A5 9C         LDA RAM_BlockBlock        ; \ X = index of tile to generate 
CODE_00C0DB:        38            SEC                       ;  | 
CODE_00C0DC:        E9 09 00      SBC.W #$0009              ;  | 
CODE_00C0DF:        29 FF 00      AND.W #$00FF              ;  | 
CODE_00C0E2:        AA            TAX                       ; / 
CODE_00C0E3:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C0E5:        B7 6E         LDA [$6E],Y               ; \ Set #$01 bit 
CODE_00C0E7:        09 01         ORA.B #$01                ;  | 
CODE_00C0E9:        97 6E         STA [$6E],Y               ; / 
CODE_00C0EB:        BF B2 C0 00   LDA.L TileToGeneratePg1,X ; \ Store tile 
CODE_00C0EF:        97 6B         STA [$6B],Y               ; / 
CODE_00C0F1:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00C0F3:        29 FF 00      AND.W #$00FF              
CODE_00C0F6:        09 00 01      ORA.W #$0100              
CODE_00C0F9:        0A            ASL                       
CODE_00C0FA:        A8            TAY                       
CODE_00C0FB:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_00C0FD:        85 00         STA $00                   
CODE_00C0FF:        AD 33 19      LDA.W $1933               
CODE_00C102:        F0 02         BEQ CODE_00C106           
ADDR_00C104:        46 00         LSR $00                   
CODE_00C106:        A5 00         LDA $00                   
CODE_00C108:        29 01 00      AND.W #$0001              
CODE_00C10B:        D0 1A         BNE CODE_00C127           
CODE_00C10D:        A5 08         LDA $08                   
CODE_00C10F:        29 F0 FF      AND.W #$FFF0              
CODE_00C112:        30 06         BMI CODE_00C11A           
CODE_00C114:        C5 0C         CMP $0C                   
CODE_00C116:        F0 26         BEQ CODE_00C13E           
CODE_00C118:        B0 0A         BCS CODE_00C124           
CODE_00C11A:        18            CLC                       
CODE_00C11B:        69 00 02      ADC.W #$0200              
CODE_00C11E:        C5 0C         CMP $0C                   
CODE_00C120:        F0 02         BEQ CODE_00C124           
CODE_00C122:        B0 1A         BCS CODE_00C13E           
CODE_00C124:        4C AB C1      JMP.W Return00C1AB        

CODE_00C127:        A5 0A         LDA $0A                   
CODE_00C129:        29 F0 FF      AND.W #$FFF0              
CODE_00C12C:        30 06         BMI CODE_00C134           
CODE_00C12E:        C5 0E         CMP $0E                   
CODE_00C130:        F0 0C         BEQ CODE_00C13E           
CODE_00C132:        B0 77         BCS Return00C1AB          
CODE_00C134:        18            CLC                       
CODE_00C135:        69 00 02      ADC.W #$0200              
CODE_00C138:        C5 0E         CMP $0E                   
CODE_00C13A:        F0 6F         BEQ Return00C1AB          
CODE_00C13C:        90 6D         BCC Return00C1AB          
CODE_00C13E:        AF 7B 83 7F   LDA.L $7F837B             
CODE_00C142:        AA            TAX                       
CODE_00C143:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C145:        A5 06         LDA $06                   
CODE_00C147:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_00C14B:        9F 85 83 7F   STA.L $7F8385,X           
CODE_00C14F:        A5 07         LDA $07                   
CODE_00C151:        9F 7E 83 7F   STA.L $7F837E,X           
CODE_00C155:        18            CLC                       
CODE_00C156:        69 20         ADC.B #$20                
CODE_00C158:        9F 86 83 7F   STA.L $7F8386,X           
CODE_00C15C:        A9 00         LDA.B #$00                
CODE_00C15E:        9F 7F 83 7F   STA.L $7F837F,X           
CODE_00C162:        9F 87 83 7F   STA.L $7F8387,X           
CODE_00C166:        A9 03         LDA.B #$03                
CODE_00C168:        9F 80 83 7F   STA.L $7F8380,X           
CODE_00C16C:        9F 88 83 7F   STA.L $7F8388,X           
CODE_00C170:        A9 FF         LDA.B #$FF                
CODE_00C172:        9F 8D 83 7F   STA.L $7F838D,X           
CODE_00C176:        A9 0D         LDA.B #$0D                
CODE_00C178:        85 06         STA $06                   
CODE_00C17A:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00C17C:        B9 BE 0F      LDA.W $0FBE,Y             
CODE_00C17F:        85 04         STA $04                   
CODE_00C181:        A0 00 00      LDY.W #$0000              
CODE_00C184:        B7 04         LDA [$04],Y               
CODE_00C186:        9F 81 83 7F   STA.L $7F8381,X           
CODE_00C18A:        C8            INY                       
CODE_00C18B:        C8            INY                       
CODE_00C18C:        B7 04         LDA [$04],Y               
CODE_00C18E:        9F 89 83 7F   STA.L $7F8389,X           
CODE_00C192:        C8            INY                       
CODE_00C193:        C8            INY                       
CODE_00C194:        B7 04         LDA [$04],Y               
CODE_00C196:        9F 83 83 7F   STA.L $7F8383,X           
CODE_00C19A:        C8            INY                       
CODE_00C19B:        C8            INY                       
CODE_00C19C:        B7 04         LDA [$04],Y               
CODE_00C19E:        9F 8B 83 7F   STA.L $7F838B,X           
CODE_00C1A2:        8A            TXA                       
CODE_00C1A3:        18            CLC                       
CODE_00C1A4:        69 10 00      ADC.W #$0010              
CODE_00C1A7:        8F 7B 83 7F   STA.L $7F837B             
Return00C1AB:       60            RTS                       ; Return 

CODE_00C1AC:        20 0D C0      JSR.W CODE_00C00D         
CODE_00C1AF:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00C1B1:        A5 98         LDA RAM_BlockXLo          
CODE_00C1B3:        29 F0 01      AND.W #$01F0              
CODE_00C1B6:        85 04         STA $04                   
CODE_00C1B8:        A5 9A         LDA RAM_BlockYLo          
CODE_00C1BA:        4A            LSR                       
CODE_00C1BB:        4A            LSR                       
CODE_00C1BC:        4A            LSR                       
CODE_00C1BD:        4A            LSR                       
CODE_00C1BE:        29 0F 00      AND.W #$000F              
CODE_00C1C1:        05 04         ORA $04                   
CODE_00C1C3:        A8            TAY                       
CODE_00C1C4:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C1C6:        A9 25         LDA.B #$25                
CODE_00C1C8:        97 6B         STA [$6B],Y               
CODE_00C1CA:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00C1CC:        98            TYA                       
CODE_00C1CD:        18            CLC                       
CODE_00C1CE:        69 10 00      ADC.W #$0010              
CODE_00C1D1:        A8            TAY                       
CODE_00C1D2:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C1D4:        A9 25         LDA.B #$25                
CODE_00C1D6:        97 6B         STA [$6B],Y               
CODE_00C1D8:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00C1DA:        29 FF 00      AND.W #$00FF              
CODE_00C1DD:        0A            ASL                       
CODE_00C1DE:        A8            TAY                       
CODE_00C1DF:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_00C1E1:        85 00         STA $00                   
CODE_00C1E3:        AD 33 19      LDA.W $1933               
CODE_00C1E6:        F0 02         BEQ CODE_00C1EA           
ADDR_00C1E8:        46 00         LSR $00                   
CODE_00C1EA:        A5 00         LDA $00                   
CODE_00C1EC:        29 01 00      AND.W #$0001              
CODE_00C1EF:        D0 1A         BNE CODE_00C20B           
CODE_00C1F1:        A5 08         LDA $08                   
CODE_00C1F3:        29 F0 FF      AND.W #$FFF0              
CODE_00C1F6:        30 06         BMI CODE_00C1FE           
CODE_00C1F8:        C5 0C         CMP $0C                   
CODE_00C1FA:        F0 26         BEQ CODE_00C222           
CODE_00C1FC:        B0 AD         BCS Return00C1AB          
CODE_00C1FE:        18            CLC                       
CODE_00C1FF:        69 00 02      ADC.W #$0200              
CODE_00C202:        C5 0C         CMP $0C                   
CODE_00C204:        90 A5         BCC Return00C1AB          
CODE_00C206:        F0 A3         BEQ Return00C1AB          
CODE_00C208:        4C 22 C2      JMP.W CODE_00C222         

CODE_00C20B:        A5 0A         LDA $0A                   
CODE_00C20D:        29 F0 FF      AND.W #$FFF0              
CODE_00C210:        30 06         BMI CODE_00C218           
CODE_00C212:        C5 0E         CMP $0E                   
CODE_00C214:        F0 0C         BEQ CODE_00C222           
CODE_00C216:        B0 93         BCS Return00C1AB          
CODE_00C218:        18            CLC                       
CODE_00C219:        69 00 02      ADC.W #$0200              
CODE_00C21C:        C5 0E         CMP $0E                   
CODE_00C21E:        F0 8B         BEQ Return00C1AB          
CODE_00C220:        90 89         BCC Return00C1AB          
CODE_00C222:        AF 7B 83 7F   LDA.L $7F837B             
CODE_00C226:        AA            TAX                       
CODE_00C227:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C229:        A5 06         LDA $06                   
CODE_00C22B:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_00C22F:        9F 89 83 7F   STA.L $7F8389,X           
CODE_00C233:        A5 07         LDA $07                   
CODE_00C235:        9F 7E 83 7F   STA.L $7F837E,X           
CODE_00C239:        1A            INC A                     
CODE_00C23A:        9F 8A 83 7F   STA.L $7F838A,X           
CODE_00C23E:        A9 80         LDA.B #$80                
CODE_00C240:        9F 7F 83 7F   STA.L $7F837F,X           
CODE_00C244:        9F 8B 83 7F   STA.L $7F838B,X           
CODE_00C248:        A9 07         LDA.B #$07                
CODE_00C24A:        9F 80 83 7F   STA.L $7F8380,X           
CODE_00C24E:        9F 8C 83 7F   STA.L $7F838C,X           
CODE_00C252:        A9 FF         LDA.B #$FF                
CODE_00C254:        9F 95 83 7F   STA.L $7F8395,X           
CODE_00C258:        A9 0D         LDA.B #$0D                
CODE_00C25A:        85 06         STA $06                   
CODE_00C25C:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00C25E:        B9 BE 0F      LDA.W $0FBE,Y             
CODE_00C261:        85 04         STA $04                   
CODE_00C263:        A0 00 00      LDY.W #$0000              
CODE_00C266:        B7 04         LDA [$04],Y               
CODE_00C268:        9F 81 83 7F   STA.L $7F8381,X           
CODE_00C26C:        9F 85 83 7F   STA.L $7F8385,X           
CODE_00C270:        C8            INY                       
CODE_00C271:        C8            INY                       
CODE_00C272:        B7 04         LDA [$04],Y               
CODE_00C274:        9F 8D 83 7F   STA.L $7F838D,X           
CODE_00C278:        9F 91 83 7F   STA.L $7F8391,X           
CODE_00C27C:        C8            INY                       
CODE_00C27D:        C8            INY                       
CODE_00C27E:        B7 04         LDA [$04],Y               
CODE_00C280:        9F 83 83 7F   STA.L $7F8383,X           
CODE_00C284:        9F 87 83 7F   STA.L $7F8387,X           
CODE_00C288:        C8            INY                       
CODE_00C289:        C8            INY                       
CODE_00C28A:        B7 04         LDA [$04],Y               
CODE_00C28C:        9F 8F 83 7F   STA.L $7F838F,X           
CODE_00C290:        9F 93 83 7F   STA.L $7F8393,X           
CODE_00C294:        8A            TXA                       
CODE_00C295:        18            CLC                       
CODE_00C296:        69 18 00      ADC.W #$0018              
CODE_00C299:        8F 7B 83 7F   STA.L $7F837B             
Return00C29D:       60            RTS                       ; Return 


FlippedGateBgTiles?:              .db $99,$9C,$8B,$1C,$8B,$1C,$8B,$1C
                                  .db $8B,$1C,$99,$DC,$9B,$1C,$F8,$1C
                                  .db $F8,$1C,$F8,$1C,$F8,$1C,$9B,$5C
                                  .db $9B,$1C,$F8,$1C,$F8,$1C,$F8,$1C
                                  .db $F8,$1C,$9B,$5C,$9B,$1C,$F8,$1C
                                  .db $F8,$1C,$F8,$1C,$F8,$1C,$9B,$5C
                                  .db $9B,$1C,$F8,$1C,$F8,$1C,$F8,$1C
                                  .db $F8,$1C,$9B,$5C,$99,$1C,$8B,$9C
                                  .db $8B,$9C,$8B,$9C,$8B,$9C,$99,$5C
                                  .db $BA,$9C,$AB,$1C,$AB,$1C,$AB,$1C
                                  .db $AB,$1C,$BA,$DC,$AA,$1C,$82,$1C
                                  .db $82,$1C,$82,$1C,$82,$1C,$AA,$5C
                                  .db $AA,$1C,$82,$1C,$82,$1C,$82,$1C
                                  .db $82,$1C,$AA,$5C,$AA,$1C,$82,$1C
                                  .db $82,$1C,$82,$1C,$82,$1C,$AA,$5C
                                  .db $AA,$1C,$82,$1C,$82,$1C,$82,$1C
                                  .db $82,$1C,$AA,$5C,$BA,$1C,$AB,$9C
                                  .db $AB,$9C,$AB,$9C,$AB,$9C,$BA,$5C
DATA_00C32E:                      .db $9E,$C2

DATA_00C330:                      .db $00,$E6,$C2,$00

CODE_00C334:        E6 07         INC $07                   ; Accum (8 bit) 
CODE_00C336:        A5 07         LDA $07                   
CODE_00C338:        18            CLC                       
CODE_00C339:        69 20         ADC.B #$20                
CODE_00C33B:        85 07         STA $07                   
CODE_00C33D:        A5 06         LDA $06                   
CODE_00C33F:        69 00         ADC.B #$00                
CODE_00C341:        85 06         STA $06                   
CODE_00C343:        A5 9C         LDA RAM_BlockBlock        
CODE_00C345:        38            SEC                       
CODE_00C346:        E9 19         SBC.B #$19                
CODE_00C348:        85 00         STA $00                   
CODE_00C34A:        0A            ASL                       
CODE_00C34B:        18            CLC                       
CODE_00C34C:        65 00         ADC $00                   
CODE_00C34E:        AA            TAX                       
CODE_00C34F:        BF 30 C3 00   LDA.L DATA_00C330,X       
CODE_00C353:        85 04         STA $04                   
CODE_00C355:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00C357:        BF 2E C3 00   LDA.L DATA_00C32E,X       
CODE_00C35B:        85 02         STA $02                   
CODE_00C35D:        AF 7B 83 7F   LDA.L $7F837B             
CODE_00C361:        AA            TAX                       
CODE_00C362:        A0 05 00      LDY.W #$0005              
CODE_00C365:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C367:        A5 06         LDA $06                   
CODE_00C369:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_00C36D:        A5 07         LDA $07                   
CODE_00C36F:        9F 7E 83 7F   STA.L $7F837E,X           
CODE_00C373:        A9 00         LDA.B #$00                
CODE_00C375:        9F 7F 83 7F   STA.L $7F837F,X           
CODE_00C379:        A9 0B         LDA.B #$0B                
CODE_00C37B:        9F 80 83 7F   STA.L $7F8380,X           
CODE_00C37F:        A5 07         LDA $07                   
CODE_00C381:        18            CLC                       
CODE_00C382:        69 20         ADC.B #$20                
CODE_00C384:        85 07         STA $07                   
CODE_00C386:        A5 06         LDA $06                   
CODE_00C388:        69 00         ADC.B #$00                
CODE_00C38A:        85 06         STA $06                   
CODE_00C38C:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00C38E:        8A            TXA                       
CODE_00C38F:        18            CLC                       
CODE_00C390:        69 10 00      ADC.W #$0010              
CODE_00C393:        AA            TAX                       
CODE_00C394:        88            DEY                       
CODE_00C395:        10 CE         BPL CODE_00C365           
CODE_00C397:        AF 7B 83 7F   LDA.L $7F837B             
CODE_00C39B:        AA            TAX                       
CODE_00C39C:        A0 00 00      LDY.W #$0000              
CODE_00C39F:        A9 05 00      LDA.W #$0005              
CODE_00C3A2:        85 00         STA $00                   
CODE_00C3A4:        B7 02         LDA [$02],Y               
CODE_00C3A6:        9F 81 83 7F   STA.L $7F8381,X           
CODE_00C3AA:        C8            INY                       
CODE_00C3AB:        C8            INY                       
CODE_00C3AC:        E8            INX                       
CODE_00C3AD:        E8            INX                       
CODE_00C3AE:        C6 00         DEC $00                   
CODE_00C3B0:        10 F2         BPL CODE_00C3A4           
CODE_00C3B2:        8A            TXA                       
CODE_00C3B3:        18            CLC                       
CODE_00C3B4:        69 04 00      ADC.W #$0004              
CODE_00C3B7:        AA            TAX                       
CODE_00C3B8:        C0 48 00      CPY.W #$0048              
CODE_00C3BB:        D0 E2         BNE CODE_00C39F           
CODE_00C3BD:        A9 FF 00      LDA.W #$00FF              
CODE_00C3C0:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_00C3C4:        AF 7B 83 7F   LDA.L $7F837B             
CODE_00C3C8:        18            CLC                       
CODE_00C3C9:        69 60 00      ADC.W #$0060              
CODE_00C3CC:        8F 7B 83 7F   STA.L $7F837B             
Return00C3D0:       60            RTS                       ; Return 

CODE_00C3D1:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_00C3D3:        A5 98         LDA RAM_BlockXLo          
CODE_00C3D5:        29 F0 01      AND.W #$01F0              
CODE_00C3D8:        85 04         STA $04                   
CODE_00C3DA:        A5 9A         LDA RAM_BlockYLo          
CODE_00C3DC:        4A            LSR                       
CODE_00C3DD:        4A            LSR                       
CODE_00C3DE:        4A            LSR                       
CODE_00C3DF:        4A            LSR                       
CODE_00C3E0:        29 0F 00      AND.W #$000F              
CODE_00C3E3:        05 04         ORA $04                   
CODE_00C3E5:        A8            TAY                       
CODE_00C3E6:        AF 7B 83 7F   LDA.L $7F837B             
CODE_00C3EA:        AA            TAX                       
CODE_00C3EB:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C3ED:        A9 25         LDA.B #$25                
CODE_00C3EF:        97 6B         STA [$6B],Y               
CODE_00C3F1:        C8            INY                       
CODE_00C3F2:        A9 25         LDA.B #$25                
CODE_00C3F4:        97 6B         STA [$6B],Y               
CODE_00C3F6:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00C3F8:        98            TYA                       
CODE_00C3F9:        18            CLC                       
CODE_00C3FA:        69 10 00      ADC.W #$0010              
CODE_00C3FD:        A8            TAY                       
CODE_00C3FE:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C400:        A9 25         LDA.B #$25                
CODE_00C402:        97 6B         STA [$6B],Y               
CODE_00C404:        88            DEY                       
CODE_00C405:        A9 25         LDA.B #$25                
CODE_00C407:        97 6B         STA [$6B],Y               
CODE_00C409:        A0 03 00      LDY.W #$0003              
CODE_00C40C:        A5 06         LDA $06                   
CODE_00C40E:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_00C412:        A5 07         LDA $07                   
CODE_00C414:        9F 7E 83 7F   STA.L $7F837E,X           
CODE_00C418:        A9 40         LDA.B #$40                
CODE_00C41A:        9F 7F 83 7F   STA.L $7F837F,X           
CODE_00C41E:        A9 06         LDA.B #$06                
CODE_00C420:        9F 80 83 7F   STA.L $7F8380,X           
CODE_00C424:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00C426:        A9 F8 18      LDA.W #$18F8              
CODE_00C429:        9F 81 83 7F   STA.L $7F8381,X           
CODE_00C42D:        8A            TXA                       
CODE_00C42E:        18            CLC                       
CODE_00C42F:        69 06 00      ADC.W #$0006              
CODE_00C432:        AA            TAX                       
CODE_00C433:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C435:        A5 07         LDA $07                   
CODE_00C437:        18            CLC                       
CODE_00C438:        69 20         ADC.B #$20                
CODE_00C43A:        85 07         STA $07                   
CODE_00C43C:        A5 06         LDA $06                   
CODE_00C43E:        69 00         ADC.B #$00                
CODE_00C440:        85 06         STA $06                   
CODE_00C442:        88            DEY                       
CODE_00C443:        10 C7         BPL CODE_00C40C           
CODE_00C445:        A9 FF         LDA.B #$FF                
CODE_00C447:        9F 7D 83 7F   STA.L $7F837D,X           
CODE_00C44B:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00C44D:        8A            TXA                       
CODE_00C44E:        8F 7B 83 7F   STA.L $7F837B             
Return00C452:       60            RTS                       ; Return 


DATA_00C453:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$80,$40,$20
                                  .db $10,$08,$04,$02,$01,$80,$40,$20
                                  .db $10,$08,$04,$02,$01

DATA_00C470:                      .db $90,$00,$90,$00

DATA_00C474:                      .db $04,$FC,$04,$FC

DATA_00C478:                      .db $30,$33,$33,$30,$01,$00

CODE_00C47E:        64 78         STZ $78                   ; Index (8 bit) Accum (8 bit) 
CODE_00C480:        AD CB 13      LDA.W $13CB               
CODE_00C483:        10 07         BPL CODE_00C48C           
ADDR_00C485:        22 80 C5 01   JSL.L CODE_01C580         
ADDR_00C489:        9C CB 13      STZ.W $13CB               
CODE_00C48C:        AC 34 14      LDY.W $1434               
CODE_00C48F:        F0 29         BEQ CODE_00C4BA           
CODE_00C491:        8C FB 13      STY.W $13FB               
CODE_00C494:        84 9D         STY RAM_SpritesLocked     
CODE_00C496:        AE 35 14      LDX.W $1435               
CODE_00C499:        AD 33 14      LDA.W $1433               
CODE_00C49C:        DD 70 C4      CMP.W DATA_00C470,X       
CODE_00C49F:        D0 1B         BNE CODE_00C4BC           
CODE_00C4A1:        88            DEY                       
CODE_00C4A2:        D0 13         BNE CODE_00C4B7           
CODE_00C4A4:        EE 35 14      INC.W $1435               
CODE_00C4A7:        8A            TXA                       
CODE_00C4A8:        4A            LSR                       
CODE_00C4A9:        90 4D         BCC CODE_00C4F8           
CODE_00C4AB:        20 EC FC      JSR.W CODE_00FCEC         
CODE_00C4AE:        A9 02         LDA.B #$02                
CODE_00C4B0:        A0 0B         LDY.B #$0B                
CODE_00C4B2:        20 FE C9      JSR.W CODE_00C9FE         
CODE_00C4B5:        A0 00         LDY.B #$00                
CODE_00C4B7:        8C 34 14      STY.W $1434               
CODE_00C4BA:        80 3C         BRA CODE_00C4F8           

CODE_00C4BC:        18            CLC                       
CODE_00C4BD:        7D 74 C4      ADC.W DATA_00C474,X       
CODE_00C4C0:        8D 33 14      STA.W $1433               
CODE_00C4C3:        A9 22         LDA.B #$22                
CODE_00C4C5:        85 41         STA $41                   
CODE_00C4C7:        A9 02         LDA.B #$02                
CODE_00C4C9:        85 42         STA $42                   
CODE_00C4CB:        BD 78 C4      LDA.W DATA_00C478,X       
CODE_00C4CE:        85 43         STA $43                   
CODE_00C4D0:        A9 12         LDA.B #$12                
CODE_00C4D2:        85 44         STA $44                   
CODE_00C4D4:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00C4D6:        A9 93 CB      LDA.W #$CB93              
CODE_00C4D9:        85 04         STA $04                   
CODE_00C4DB:        64 06         STZ $06                   
CODE_00C4DD:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C4DF:        AD 36 14      LDA.W RAM_KeyHolePos1     
CODE_00C4E2:        38            SEC                       
CODE_00C4E3:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_00C4E5:        18            CLC                       
CODE_00C4E6:        69 04         ADC.B #$04                
CODE_00C4E8:        85 00         STA $00                   
CODE_00C4EA:        AD 38 14      LDA.W RAM_KeyHolePos2     
CODE_00C4ED:        38            SEC                       
CODE_00C4EE:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_00C4F0:        18            CLC                       
CODE_00C4F1:        69 10         ADC.B #$10                
CODE_00C4F3:        85 01         STA $01                   
CODE_00C4F5:        20 88 CA      JSR.W CODE_00CA88         
CODE_00C4F8:        AD FB 13      LDA.W $13FB               
CODE_00C4FB:        F0 03         BEQ CODE_00C500           
CODE_00C4FD:        4C 8F C5      JMP.W CODE_00C58F         

CODE_00C500:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_00C502:        D0 65         BNE CODE_00C569           ; / 
CODE_00C504:        E6 14         INC RAM_FrameCounterB     
CODE_00C506:        A2 13         LDX.B #$13                
CODE_00C508:        BD 95 14      LDA.W $1495,X             
CODE_00C50B:        F0 03         BEQ CODE_00C510           
CODE_00C50D:        DE 95 14      DEC.W $1495,X             
CODE_00C510:        CA            DEX                       
CODE_00C511:        D0 F5         BNE CODE_00C508           
CODE_00C513:        A5 14         LDA RAM_FrameCounterB     
CODE_00C515:        29 03         AND.B #$03                
CODE_00C517:        D0 50         BNE CODE_00C569           
CODE_00C519:        AD 25 14      LDA.W $1425               
CODE_00C51C:        F0 15         BEQ CODE_00C533           
CODE_00C51E:        AD AB 14      LDA.W $14AB               
CODE_00C521:        C9 44         CMP.B #$44                
CODE_00C523:        D0 05         BNE CODE_00C52A           
CODE_00C525:        A0 14         LDY.B #$14                
CODE_00C527:        8C FB 1D      STY.W $1DFB               ; / Change music 
CODE_00C52A:        C9 01         CMP.B #$01                
CODE_00C52C:        D0 05         BNE CODE_00C533           
CODE_00C52E:        A0 0B         LDY.B #$0B                
CODE_00C530:        8C 00 01      STY.W RAM_GameMode        
CODE_00C533:        AC AD 14      LDY.W RAM_BluePowTimer    
CODE_00C536:        CC AE 14      CPY.W RAM_SilverPowTimer  
CODE_00C539:        B0 03         BCS CODE_00C53E           
CODE_00C53B:        AC AE 14      LDY.W RAM_SilverPowTimer  
CODE_00C53E:        AD DA 0D      LDA.W $0DDA               
CODE_00C541:        30 0C         BMI CODE_00C54F           
CODE_00C543:        C0 01         CPY.B #$01                
CODE_00C545:        D0 08         BNE CODE_00C54F           
CODE_00C547:        AC 0C 19      LDY.W $190C               
CODE_00C54A:        D0 03         BNE CODE_00C54F           
CODE_00C54C:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_00C54F:        C9 FF         CMP.B #$FF                
CODE_00C551:        F0 09         BEQ CODE_00C55C           
CODE_00C553:        C0 1E         CPY.B #$1E                
CODE_00C555:        D0 05         BNE CODE_00C55C           
CODE_00C557:        A9 24         LDA.B #$24                ; \ Play sound effect 
CODE_00C559:        8D FC 1D      STA.W $1DFC               ; / 
CODE_00C55C:        A2 06         LDX.B #$06                
CODE_00C55E:        BD A8 14      LDA.W $14A8,X             
CODE_00C561:        F0 03         BEQ CODE_00C566           
CODE_00C563:        DE A8 14      DEC.W $14A8,X             
CODE_00C566:        CA            DEX                       
CODE_00C567:        D0 F5         BNE CODE_00C55E           
CODE_00C569:        20 93 C5      JSR.W CODE_00C593         
CODE_00C56C:        A5 16         LDA $16                   
CODE_00C56E:        29 20         AND.B #$20                
CODE_00C570:        F0 1D         BEQ CODE_00C58F           
CODE_00C572:        A5 15         LDA RAM_ControllerA       
CODE_00C574:        29 08         AND.B #$08                
CODE_00C576:        80 0D         BRA CODE_00C585           ; Change to BEQ to reach debug routine below 

ADDR_00C578:        A5 19         LDA RAM_MarioPowerUp      ; \ Unreachable 
ADDR_00C57A:        1A            INC A                     ;  | Debug: Cycle through powerups 
ADDR_00C57B:        C9 04         CMP.B #$04                ;  | 
ADDR_00C57D:        90 02         BCC ADDR_00C581           ;  | 
ADDR_00C57F:        A9 00         LDA.B #$00                ;  | 
ADDR_00C581:        85 19         STA RAM_MarioPowerUp      ;  | 
ADDR_00C583:        80 0A         BRA CODE_00C58F           ; / 

CODE_00C585:        8B            PHB                       
CODE_00C586:        A9 02         LDA.B #$02                
CODE_00C588:        48            PHA                       
CODE_00C589:        AB            PLB                       
CODE_00C58A:        22 08 80 02   JSL.L CODE_028008         
CODE_00C58E:        AB            PLB                       
CODE_00C58F:        9C 02 14      STZ.W $1402               
Return00C592:       60            RTS                       ; Return 

CODE_00C593:        A5 71         LDA RAM_MarioAnimation    
CODE_00C595:        22 DF 86 00   JSL.L ExecutePtr          

AnimationSeqPtr:       68 CC      .dw ResetAni              ; 0 - Reset                        
                       29 D1      .dw PowerDownAni          ; 1 - Power down                   
                       47 D1      .dw MushroomAni           ; 2 - Mushroom power up            
                       5F D1      .dw CapeAni               ; 3 - Cape power up                
                       6F D1      .dw FlowerAni             ; 4 - Flower power up              
                       97 D1      .dw DoorPipeAni           ; 5 - Door/Horizontal pipe exit    
                       03 D2      .dw VertPipeAni           ; 6 - Vertical pipe exit           
                       87 D2      .dw PipeCannonAni         ; 7 - Shot out of diagonal pipe    
                       FD C7      .dw YoshiWingsAni         ; 8 - Yoshi wings exit             
                       B6 D0      .dw MarioDeathAni         ; 9 - Mario Death                  
                       70 C8      .dw EnterCastleAni        ; A - Enter Castle                 
                       B5 C5      .dw UnknownAniB           ; B - freeze forever               
                       E7 C6      .dw UnknownAniC           ; C - random movement??            
                       92 C5      .dw Return00C592          ; D - freeze forever               

UnknownAniB:        9C DE 13      STZ.W $13DE               
CODE_00C5B8:        9C ED 13      STZ.W $13ED               
CODE_00C5BB:        AD 93 14      LDA.W $1493               
CODE_00C5BE:        F0 0E         BEQ CODE_00C5CE           
CODE_00C5C0:        22 13 AB 0C   JSL.L CODE_0CAB13         
CODE_00C5C4:        AD 00 01      LDA.W RAM_GameMode        
CODE_00C5C7:        C9 14         CMP.B #$14                
CODE_00C5C9:        F0 06         BEQ CODE_00C5D1           
CODE_00C5CB:        4C 5B C9      JMP.W CODE_00C95B         

CODE_00C5CE:        9C 9F 0D      STZ.W $0D9F               
CODE_00C5D1:        A9 01         LDA.B #$01                
CODE_00C5D3:        8D 88 1B      STA.W $1B88               
CODE_00C5D6:        A9 07         LDA.B #$07                

Instr00C5D8:                      .db $8D,$28,$19

CODE_00C5DB:        20 2D F6      JSR.W NoButtons           
CODE_00C5DE:        4C 24 CD      JMP.W CODE_00CD24         


DATA_00C5E1:                      .db $10,$30,$31,$32,$33,$34,$0E

DATA_00C5E8:                      .db $26

DATA_00C5E9:                      .db $11,$02,$48,$00,$60,$01,$09,$80
                                  .db $08,$00,$20,$04,$60,$00,$01,$FF
                                  .db $01,$02,$48,$00,$60,$41,$2C,$C1
                                  .db $04,$27,$04,$2F,$08,$25,$01,$2F
                                  .db $04,$27,$04,$00,$08,$41,$1B,$C1
                                  .db $04,$27,$04,$2F,$08,$25,$01,$2F
                                  .db $04,$27,$04,$00,$04,$01,$08,$20
                                  .db $01,$01,$10,$00,$08,$41,$12,$81
                                  .db $0A,$00,$40,$82,$10,$02,$20,$00
                                  .db $30,$01,$01,$00,$50,$22,$01,$FF
                                  .db $01,$02,$48,$00,$60,$01,$09,$80
                                  .db $08,$00,$20,$04,$60,$00,$20,$10
                                  .db $20,$01,$58,$00,$2C,$31,$01,$3A
                                  .db $10,$31,$01,$3A,$10,$31,$01,$3A
                                  .db $20,$28,$A0,$28,$40,$29,$04,$28
                                  .db $04,$29,$04,$28,$04,$29,$04,$28
                                  .db $40,$22,$01,$FF,$01,$02,$48,$00
                                  .db $60,$01,$09,$80,$08,$00,$20,$04
                                  .db $60,$10,$20,$31,$01,$18,$60,$31
                                  .db $01,$3B,$80,$31,$01,$3C,$40,$FF
                                  .db $01,$02,$48,$00,$60,$02,$30,$01
                                  .db $84,$00,$20,$23,$01,$01,$16,$02
                                  .db $20,$20,$01,$01,$20,$02,$20,$01
                                  .db $02,$00,$80,$FF,$01,$02,$48,$00
                                  .db $60,$02,$28,$01,$83,$00,$28,$24
                                  .db $01,$02,$01,$00,$FF,$00,$40,$20
                                  .db $01,$00,$40,$02,$60,$00,$30,$FF
                                  .db $01,$02,$48,$00,$60,$01,$4E,$00
                                  .db $40,$26,$01,$00,$1E,$20,$01,$00
                                  .db $20,$08,$10,$20,$01,$2D,$18,$00
                                  .db $A0,$20,$01,$2E,$01,$FF

DATA_00C6DF:                      .db $01,$00,$10,$A0,$84,$50,$BC,$D8

UnknownAniC:        20 2D F6      JSR.W NoButtons           
CODE_00C6EA:        9C DE 13      STZ.W $13DE               
CODE_00C6ED:        20 2D DC      JSR.W CODE_00DC2D         
CODE_00C6F0:        A5 7D         LDA RAM_MarioSpeedY       ; \ Branch if Mario has upward speed 
CODE_00C6F2:        30 4B         BMI CODE_00C73F           ; / 
CODE_00C6F4:        A5 96         LDA RAM_MarioYPos         
CODE_00C6F6:        C9 58         CMP.B #$58                
CODE_00C6F8:        B0 3F         BCS CODE_00C739           
CODE_00C6FA:        A4 94         LDY RAM_MarioXPos         
CODE_00C6FC:        C0 40         CPY.B #$40                
CODE_00C6FE:        90 3F         BCC CODE_00C73F           
CODE_00C700:        C0 60         CPY.B #$60                
CODE_00C702:        90 18         BCC CODE_00C71C           
CODE_00C704:        A4 1C         LDY RAM_ScreenBndryYLo    
CODE_00C706:        F0 37         BEQ CODE_00C73F           
CODE_00C708:        18            CLC                       
CODE_00C709:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_00C70B:        C9 1C         CMP.B #$1C                
CODE_00C70D:        30 30         BMI CODE_00C73F           
CODE_00C70F:        38            SEC                       
CODE_00C710:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_00C712:        A2 D0         LDX.B #$D0                
CODE_00C714:        A4 76         LDY RAM_MarioDirection    
CODE_00C716:        F0 18         BEQ CODE_00C730           
CODE_00C718:        A0 00         LDY.B #$00                
CODE_00C71A:        80 12         BRA CODE_00C72E           

CODE_00C71C:        C9 4C         CMP.B #$4C                
CODE_00C71E:        90 1F         BCC CODE_00C73F           
CODE_00C720:        A9 1B         LDA.B #$1B                ; \ Play sound effect 
CODE_00C722:        8D FC 1D      STA.W $1DFC               ; / 
CODE_00C725:        EE 3E 14      INC.W RAM_ScrollSprNum    
CODE_00C728:        A9 4C         LDA.B #$4C                
CODE_00C72A:        A0 F4         LDY.B #$F4                
CODE_00C72C:        A2 C0         LDX.B #$C0                
CODE_00C72E:        84 7B         STY RAM_MarioSpeedX       
CODE_00C730:        86 7D         STX RAM_MarioSpeedY       
CODE_00C732:        A2 01         LDX.B #$01                ; \ Play sound effect 
CODE_00C734:        8E F9 1D      STX.W $1DF9               ; / 
CODE_00C737:        80 04         BRA CODE_00C73D           

CODE_00C739:        64 72         STZ RAM_IsFlying          
CODE_00C73B:        A9 58         LDA.B #$58                
CODE_00C73D:        85 96         STA RAM_MarioYPos         
CODE_00C73F:        AE C6 13      LDX.W $13C6               
CODE_00C742:        A5 8F         LDA $8F                   
CODE_00C744:        18            CLC                       
CODE_00C745:        7D DF C6      ADC.W DATA_00C6DF,X       
CODE_00C748:        AA            TAX                       
CODE_00C749:        A5 88         LDA $88                   
CODE_00C74B:        D0 17         BNE CODE_00C764           
CODE_00C74D:        E6 8F         INC $8F                   
CODE_00C74F:        E6 8F         INC $8F                   
CODE_00C751:        E8            INX                       
CODE_00C752:        E8            INX                       
CODE_00C753:        BD E9 C5      LDA.W DATA_00C5E9,X       
CODE_00C756:        85 88         STA $88                   
CODE_00C758:        BD E8 C5      LDA.W DATA_00C5E8,X       
CODE_00C75B:        C9 2D         CMP.B #$2D                
CODE_00C75D:        D0 05         BNE CODE_00C764           
CODE_00C75F:        A9 1E         LDA.B #$1E                ; \ Play sound effect 
CODE_00C761:        8D F9 1D      STA.W $1DF9               ; / 
CODE_00C764:        BD E8 C5      LDA.W DATA_00C5E8,X       
CODE_00C767:        C9 FF         CMP.B #$FF                
CODE_00C769:        D0 03         BNE CODE_00C76E           
CODE_00C76B:        4C F8 C7      JMP.W Return00C7F8        

CODE_00C76E:        48            PHA                       
CODE_00C76F:        29 10         AND.B #$10                
CODE_00C771:        F0 04         BEQ CODE_00C777           
CODE_00C773:        22 A4 D4 0C   JSL.L CODE_0CD4A4         
CODE_00C777:        68            PLA                       
CODE_00C778:        A8            TAY                       
CODE_00C779:        29 20         AND.B #$20                
CODE_00C77B:        D0 0C         BNE CODE_00C789           
CODE_00C77D:        84 15         STY RAM_ControllerA       
CODE_00C77F:        98            TYA                       
CODE_00C780:        29 BF         AND.B #$BF                
CODE_00C782:        85 16         STA $16                   
CODE_00C784:        20 39 CD      JSR.W CODE_00CD39         
CODE_00C787:        80 6D         BRA CODE_00C7F6           

CODE_00C789:        98            TYA                       
CODE_00C78A:        29 0F         AND.B #$0F                
CODE_00C78C:        C9 07         CMP.B #$07                
CODE_00C78E:        B0 59         BCS CODE_00C7E9           
CODE_00C790:        3A            DEC A                     
CODE_00C791:        10 0F         BPL CODE_00C7A2           
CODE_00C793:        AD 98 14      LDA.W RAM_PickUpImgTimer  
CODE_00C796:        F0 05         BEQ CODE_00C79D           
CODE_00C798:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_00C79A:        8D F9 1D      STA.W $1DF9               ; / 
CODE_00C79D:        EE 3E 14      INC.W RAM_ScrollSprNum    
CODE_00C7A0:        80 54         BRA CODE_00C7F6           

CODE_00C7A2:        D0 05         BNE CODE_00C7A9           
CODE_00C7A4:        EE 45 14      INC.W $1445               
CODE_00C7A7:        80 4D         BRA CODE_00C7F6           

CODE_00C7A9:        3A            DEC A                     
CODE_00C7AA:        D0 0A         BNE CODE_00C7B6           
CODE_00C7AC:        A9 0E         LDA.B #$0E                ; \ Play sound effect 
CODE_00C7AE:        8D F9 1D      STA.W $1DF9               ; / 
CODE_00C7B1:        EE 46 14      INC.W $1446               
CODE_00C7B4:        80 40         BRA CODE_00C7F6           

CODE_00C7B6:        3A            DEC A                     
CODE_00C7B7:        D0 07         BNE CODE_00C7C0           
CODE_00C7B9:        A0 88         LDY.B #$88                
CODE_00C7BB:        8C 45 14      STY.W $1445               
CODE_00C7BE:        80 36         BRA CODE_00C7F6           

CODE_00C7C0:        3A            DEC A                     
CODE_00C7C1:        D0 0B         BNE CODE_00C7CE           
CODE_00C7C3:        A9 38         LDA.B #$38                
CODE_00C7C5:        8D 46 14      STA.W $1446               
CODE_00C7C8:        A9 07         LDA.B #$07                
CODE_00C7CA:        14 94         TRB RAM_MarioXPos         
CODE_00C7CC:        80 28         BRA CODE_00C7F6           

CODE_00C7CE:        3A            DEC A                     
CODE_00C7CF:        D0 0E         BNE CODE_00C7DF           
CODE_00C7D1:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_00C7D3:        8D FC 1D      STA.W $1DFC               ; / 
CODE_00C7D6:        A9 D8         LDA.B #$D8                
CODE_00C7D8:        85 7B         STA RAM_MarioSpeedX       
CODE_00C7DA:        EE 3E 14      INC.W RAM_ScrollSprNum    
CODE_00C7DD:        80 BE         BRA CODE_00C79D           

CODE_00C7DF:        A9 20         LDA.B #$20                
CODE_00C7E1:        8D 98 14      STA.W RAM_PickUpImgTimer  
CODE_00C7E4:        EE 8F 14      INC.W $148F               
CODE_00C7E7:        80 0D         BRA CODE_00C7F6           

CODE_00C7E9:        A8            TAY                       
CODE_00C7EA:        B9 DA C5      LDA.W ADDR_00C5DA,Y       
CODE_00C7ED:        8D E0 13      STA.W MarioFrame          
CODE_00C7F0:        9C 8F 14      STZ.W $148F               
CODE_00C7F3:        20 E4 D7      JSR.W CODE_00D7E4         
CODE_00C7F6:        C6 88         DEC $88                   
Return00C7F8:       60            RTS                       ; Return 


DATA_00C7F9:                      .db $C0,$FF,$A0,$00

YoshiWingsAni:      20 2D F6      JSR.W NoButtons           
CODE_00C800:        A9 0B         LDA.B #$0B                
CODE_00C802:        85 72         STA RAM_IsFlying          
CODE_00C804:        20 E4 D7      JSR.W CODE_00D7E4         
CODE_00C807:        A5 7D         LDA RAM_MarioSpeedY       ; \ Branch if Mario has downward speed 
CODE_00C809:        10 04         BPL CODE_00C80F           ; / 
CODE_00C80B:        C9 90         CMP.B #$90                ; \ Branch if Y speed < #$90 
CODE_00C80D:        90 05         BCC CODE_00C814           ; / 
CODE_00C80F:        38            SEC                       ; \ Y Speed -= #$0D 
CODE_00C810:        E9 0D         SBC.B #$0D                ;  | 
CODE_00C812:        85 7D         STA RAM_MarioSpeedY       ; / 
CODE_00C814:        A9 02         LDA.B #$02                
CODE_00C816:        A4 7B         LDY RAM_MarioSpeedX       
CODE_00C818:        F0 0D         BEQ CODE_00C827           
CODE_00C81A:        30 02         BMI CODE_00C81E           
CODE_00C81C:        A9 FE         LDA.B #$FE                
CODE_00C81E:        18            CLC                       
CODE_00C81F:        65 7B         ADC RAM_MarioSpeedX       
CODE_00C821:        85 7B         STA RAM_MarioSpeedX       
CODE_00C823:        50 02         BVC CODE_00C827           
ADDR_00C825:        64 7B         STZ RAM_MarioSpeedX       
CODE_00C827:        20 2D DC      JSR.W CODE_00DC2D         
CODE_00C82A:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00C82C:        AC 95 1B      LDY.W $1B95               
CODE_00C82F:        A5 80         LDA $80                   
CODE_00C831:        D9 F9 C7      CMP.W DATA_00C7F9,Y       
CODE_00C834:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00C836:        10 0D         BPL Instr00C845           
CODE_00C838:        64 71         STZ RAM_MarioAnimation    
CODE_00C83A:        98            TYA                       
CODE_00C83B:        D0 08         BNE Instr00C845           
CODE_00C83D:        C8            INY                       
CODE_00C83E:        C8            INY                       
CODE_00C83F:        8C 95 1B      STY.W $1B95               
CODE_00C842:        20 73 D2      JSR.W CODE_00D273         

Instr00C845:                      .db $4C,$8F,$CD

DATA_00C848:                      .db $01,$5F,$00,$30,$08,$30,$00,$20
                                  .db $40,$01,$00,$30,$01,$80,$FF,$01
                                  .db $3F,$00,$30,$20,$01,$80,$06,$00
                                  .db $3A,$01,$38,$00,$30,$08,$30,$00
                                  .db $20,$40,$01,$00,$30,$01,$80,$FF

EnterCastleAni:     9C E2 13      STZ.W $13E2               
CODE_00C873:        AE 31 19      LDX.W $1931               
CODE_00C876:        3C 25 A6      BIT.W DATA_00A625,X       
CODE_00C879:        30 0E         BMI CODE_00C889           
CODE_00C87B:        70 06         BVS ADDR_00C883           
CODE_00C87D:        22 7C F5 02   JSL.L CODE_02F57C         
CODE_00C881:        80 0A         BRA CODE_00C88D           

ADDR_00C883:        22 8C F5 02   JSL.L ADDR_02F58C         
ADDR_00C887:        80 04         BRA CODE_00C88D           

CODE_00C889:        22 84 F5 02   JSL.L CODE_02F584         
CODE_00C88D:        A6 88         LDX $88                   
CODE_00C88F:        A5 16         LDA $16                   
CODE_00C891:        05 18         ORA $18                   
CODE_00C893:        20 2D F6      JSR.W NoButtons           
CODE_00C896:        30 63         BMI CODE_00C8FB           
CODE_00C898:        9C DE 13      STZ.W $13DE               
CODE_00C89B:        C6 89         DEC $89                   
CODE_00C89D:        D0 09         BNE CODE_00C8A8           
CODE_00C89F:        E8            INX                       
CODE_00C8A0:        E8            INX                       
CODE_00C8A1:        86 88         STX $88                   
CODE_00C8A3:        BD 47 C8      LDA.W ADDR_00C847,X       
CODE_00C8A6:        85 89         STA $89                   
CODE_00C8A8:        BD 46 C8      LDA.W ADDR_00C846,X       
CODE_00C8AB:        C9 FF         CMP.B #$FF                
CODE_00C8AD:        F0 4C         BEQ CODE_00C8FB           
CODE_00C8AF:        29 DF         AND.B #$DF                
CODE_00C8B1:        85 15         STA RAM_ControllerA       
CODE_00C8B3:        DD 46 C8      CMP.W ADDR_00C846,X       
CODE_00C8B6:        F0 04         BEQ CODE_00C8BC           
CODE_00C8B8:        A0 80         LDY.B #$80                
CODE_00C8BA:        84 18         STY $18                   
CODE_00C8BC:        0A            ASL                       
CODE_00C8BD:        10 12         BPL CODE_00C8D1           
CODE_00C8BF:        20 2D F6      JSR.W NoButtons           
CODE_00C8C2:        A0 B0         LDY.B #$B0                
CODE_00C8C4:        AE 31 19      LDX.W $1931               
CODE_00C8C7:        3C 25 A6      BIT.W DATA_00A625,X       
CODE_00C8CA:        30 02         BMI CODE_00C8CE           
CODE_00C8CC:        A0 7F         LDY.B #$7F                
CODE_00C8CE:        8C D9 18      STY.W $18D9               
CODE_00C8D1:        20 2D DC      JSR.W CODE_00DC2D         
CODE_00C8D4:        A9 24         LDA.B #$24                
CODE_00C8D6:        85 72         STA RAM_IsFlying          
CODE_00C8D8:        A9 6F         LDA.B #$6F                
CODE_00C8DA:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_00C8DD:        F0 02         BEQ CODE_00C8E1           
CODE_00C8DF:        A9 5F         LDA.B #$5F                
CODE_00C8E1:        AE 31 19      LDX.W $1931               
CODE_00C8E4:        3C 25 A6      BIT.W DATA_00A625,X       
CODE_00C8E7:        50 03         BVC CODE_00C8EC           
ADDR_00C8E9:        38            SEC                       
ADDR_00C8EA:        E9 10         SBC.B #$10                
CODE_00C8EC:        C5 96         CMP RAM_MarioYPos         
CODE_00C8EE:        B0 08         BCS CODE_00C8F8           
CODE_00C8F0:        1A            INC A                     
CODE_00C8F1:        85 96         STA RAM_MarioYPos         
CODE_00C8F3:        64 72         STZ RAM_IsFlying          
CODE_00C8F5:        9C 0D 14      STZ.W RAM_IsSpinJump      
CODE_00C8F8:        4C 82 CD      JMP.W CODE_00CD82         

CODE_00C8FB:        EE 1D 14      INC.W $141D               
CODE_00C8FE:        A9 0F         LDA.B #$0F                
CODE_00C900:        8D 00 01      STA.W RAM_GameMode        
CODE_00C903:        E0 11         CPX.B #$11                
CODE_00C905:        90 03         BCC CODE_00C90A           
CODE_00C907:        EE C1 0D      INC.W RAM_OWHasYoshi      
CODE_00C90A:        A9 01         LDA.B #$01                
CODE_00C90C:        8D 9B 1B      STA.W $1B9B               
CODE_00C90F:        A9 03         LDA.B #$03                ; \ Play sound effect 
CODE_00C911:        8D FA 1D      STA.W $1DFA               ; / 
Return00C914:       60            RTS                       ; Return 

CODE_00C915:        20 2D F6      JSR.W NoButtons           
CODE_00C918:        9C C2 18      STZ.W $18C2               
CODE_00C91B:        9C DE 13      STZ.W $13DE               
CODE_00C91E:        9C ED 13      STZ.W $13ED               
CODE_00C921:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_00C923:        4A            LSR                       
CODE_00C924:        B0 1E         BCS CODE_00C944           
CODE_00C926:        AD C6 13      LDA.W $13C6               
CODE_00C929:        0D D2 13      ORA.W $13D2               
CODE_00C92C:        F0 3D         BEQ CODE_00C96B           
CODE_00C92E:        A5 72         LDA RAM_IsFlying          
CODE_00C930:        F0 03         BEQ CODE_00C935           
ADDR_00C932:        20 E0 CC      JSR.W CODE_00CCE0         
CODE_00C935:        AD D2 13      LDA.W $13D2               
CODE_00C938:        D0 0E         BNE CODE_00C948           
CODE_00C93A:        20 3E B0      JSR.W CODE_00B03E         
CODE_00C93D:        AD 95 14      LDA.W $1495               
CODE_00C940:        C9 40         CMP.B #$40                
CODE_00C942:        90 26         BCC Return00C96A          
CODE_00C944:        22 FF CB 05   JSL.L CODE_05CBFF         
CODE_00C948:        A0 01         LDY.B #$01                
CODE_00C94A:        84 9D         STY RAM_SpritesLocked     
CODE_00C94C:        A5 13         LDA RAM_FrameCounter      
CODE_00C94E:        4A            LSR                       
CODE_00C94F:        90 19         BCC Return00C96A          
CODE_00C951:        CE 93 14      DEC.W $1493               
CODE_00C954:        D0 14         BNE Return00C96A          
CODE_00C956:        AD D2 13      LDA.W $13D2               
CODE_00C959:        D0 07         BNE CODE_00C962           
CODE_00C95B:        A0 0B         LDY.B #$0B                
CODE_00C95D:        A9 01         LDA.B #$01                
CODE_00C95F:        4C FE C9      JMP.W CODE_00C9FE         

CODE_00C962:        A9 A0         LDA.B #$A0                
CODE_00C964:        8D F5 1D      STA.W $1DF5               
CODE_00C967:        EE 26 14      INC.W $1426               
Return00C96A:       60            RTS                       ; Return 

CODE_00C96B:        20 17 AF      JSR.W CODE_00AF17         
CODE_00C96E:        AD 99 1B      LDA.W $1B99               
CODE_00C971:        D0 3C         BNE CODE_00C9AF           
CODE_00C973:        AD 93 14      LDA.W $1493               
CODE_00C976:        C9 28         CMP.B #$28                
CODE_00C978:        90 0A         BCC CODE_00C984           
CODE_00C97A:        A9 01         LDA.B #$01                
CODE_00C97C:        85 76         STA RAM_MarioDirection    
CODE_00C97E:        85 15         STA RAM_ControllerA       
CODE_00C980:        A9 05         LDA.B #$05                
CODE_00C982:        85 7B         STA RAM_MarioSpeedX       
CODE_00C984:        A5 72         LDA RAM_IsFlying          
CODE_00C986:        F0 03         BEQ CODE_00C98B           
CODE_00C988:        20 6B D7      JSR.W CODE_00D76B         
CODE_00C98B:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00C98D:        D0 15         BNE Instr00C9A4           
CODE_00C98F:        9C 11 14      STZ.W $1411               
CODE_00C992:        20 3E CA      JSR.W CODE_00CA3E         
CODE_00C995:        EE 99 1B      INC.W $1B99               
CODE_00C998:        A9 40         LDA.B #$40                
CODE_00C99A:        8D 92 14      STA.W $1492               
CODE_00C99D:        0A            ASL                       
CODE_00C99E:        8D 94 14      STA.W $1494               
CODE_00C9A1:        9C 95 14      STZ.W $1495               

Instr00C9A4:                      .db $4C,$24,$CD

DATA_00C9A7:                      .db $25,$07,$40,$0E,$20,$1A,$34,$32

CODE_00C9AF:        20 31 CA      JSR.W SetMarioPeaceImg    
CODE_00C9B2:        AD 92 14      LDA.W $1492               
CODE_00C9B5:        F0 0B         BEQ CODE_00C9C2           
CODE_00C9B7:        CE 92 14      DEC.W $1492               
CODE_00C9BA:        D0 05         BNE Return00C9C1          
CODE_00C9BC:        A9 11         LDA.B #$11                
CODE_00C9BE:        8D FB 1D      STA.W $1DFB               ; / Change music 
Return00C9C1:       60            RTS                       ; Return 

CODE_00C9C2:        20 44 CA      JSR.W CODE_00CA44         
CODE_00C9C5:        A9 01         LDA.B #$01                
CODE_00C9C7:        85 15         STA RAM_ControllerA       
CODE_00C9C9:        20 24 CD      JSR.W CODE_00CD24         
CODE_00C9CC:        AD 33 14      LDA.W $1433               
CODE_00C9CF:        D0 5F         BNE Return00CA30          
CODE_00C9D1:        AD 1C 14      LDA.W $141C               ; \ Branch if Goal Tape extra bits == #$02 
CODE_00C9D4:        1A            INC A                     ;  | (never happens) 
CODE_00C9D5:        C9 03         CMP.B #$03                ;  | 
CODE_00C9D7:        D0 06         BNE CODE_00C9DF           ; / 
ADDR_00C9D9:        A9 01         LDA.B #$01                ; \ Unreachable 
ADDR_00C9DB:        8D 11 1F      STA.W $1F11               ;  | Set submap to be Yoshi's Island 
ADDR_00C9DE:        4A            LSR                       ; / 
CODE_00C9DF:        A0 0C         LDY.B #$0C                
CODE_00C9E1:        AE 25 14      LDX.W $1425               
CODE_00C9E4:        F0 12         BEQ CODE_00C9F8           
CODE_00C9E6:        A2 FF         LDX.B #$FF                
CODE_00C9E8:        8E 25 14      STX.W $1425               
CODE_00C9EB:        A2 F0         LDX.B #$F0                
CODE_00C9ED:        8E B0 0D      STX.W $0DB0               
CODE_00C9F0:        9C 93 14      STZ.W $1493               
CODE_00C9F3:        9C DA 0D      STZ.W $0DDA               
CODE_00C9F6:        A0 10         LDY.B #$10                
CODE_00C9F8:        9C AE 0D      STZ.W $0DAE               
CODE_00C9FB:        9C AF 0D      STZ.W $0DAF               
CODE_00C9FE:        8D D5 0D      STA.W $0DD5               ; Store secret/normal exit info 
CODE_00CA01:        AD C6 13      LDA.W $13C6               
CODE_00CA04:        F0 1F         BEQ CODE_00CA25           
CODE_00CA06:        A2 08         LDX.B #$08                
CODE_00CA08:        AD BF 13      LDA.W $13BF               
CODE_00CA0B:        C9 13         CMP.B #$13                
CODE_00CA0D:        D0 03         BNE CODE_00CA12           
CODE_00CA0F:        EE D5 0D      INC.W $0DD5               
CODE_00CA12:        C9 31         CMP.B #$31                
CODE_00CA14:        F0 0A         BEQ CODE_00CA20           
CODE_00CA16:        DD A6 C9      CMP.W ADDR_00C9A6,X       
CODE_00CA19:        F0 05         BEQ CODE_00CA20           
CODE_00CA1B:        CA            DEX                       
CODE_00CA1C:        D0 F8         BNE CODE_00CA16           
CODE_00CA1E:        80 05         BRA CODE_00CA25           

CODE_00CA20:        8E C6 13      STX.W $13C6               
CODE_00CA23:        A0 18         LDY.B #$18                
CODE_00CA25:        8C 00 01      STY.W RAM_GameMode        
CODE_00CA28:        EE E9 1D      INC.W $1DE9               
CODE_00CA2B:        A9 01         LDA.B #$01                
CODE_00CA2D:        8D CE 13      STA.W $13CE               
Return00CA30:       60            RTS                       ; Return 

SetMarioPeaceImg:   A9 26         LDA.B #$26                ; \ Mario's image = Peace Sign, or 
CODE_00CA33:        AC 7A 18      LDY.W RAM_OnYoshi         ;  | 
CODE_00CA36:        F0 02         BEQ CODE_00CA3A           ;  | 
CODE_00CA38:        A9 14         LDA.B #$14                ;  | Mario's image = Peace Sign on Yoshi 
CODE_00CA3A:        8D E0 13      STA.W MarioFrame          ; / 
Return00CA3D:       60            RTS                       ; Return 

CODE_00CA3E:        A9 F0         LDA.B #$F0                
CODE_00CA40:        8D 33 14      STA.W $1433               
Return00CA43:       60            RTS                       ; Return 

CODE_00CA44:        AD 33 14      LDA.W $1433               
CODE_00CA47:        D0 01         BNE CODE_00CA4A           
Return00CA49:       60            RTS                       ; Return 

CODE_00CA4A:        20 61 CA      JSR.W CODE_00CA61         
CODE_00CA4D:        A9 FC         LDA.B #$FC                
CODE_00CA4F:        20 6D CA      JSR.W CODE_00CA6D         
CODE_00CA52:        A9 33         LDA.B #$33                
CODE_00CA54:        85 41         STA $41                   
CODE_00CA56:        85 43         STA $43                   
CODE_00CA58:        A9 03         LDA.B #$03                
CODE_00CA5A:        85 42         STA $42                   
CODE_00CA5C:        A9 22         LDA.B #$22                
CODE_00CA5E:        85 44         STA $44                   
Return00CA60:       60            RTS                       ; Return 

CODE_00CA61:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_00CA63:        A9 12 CB      LDA.W #$CB12              ; \  
CODE_00CA66:        85 04         STA $04                   ;  |Load xCB12 into $04 and $06 
CODE_00CA68:        85 06         STA $06                   ; /  
CODE_00CA6A:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
Return00CA6C:       60            RTS                       ; Return 

CODE_00CA6D:        18            CLC                       
CODE_00CA6E:        6D 33 14      ADC.W $1433               
CODE_00CA71:        8D 33 14      STA.W $1433               
CODE_00CA74:        A5 7E         LDA $7E                   
CODE_00CA76:        18            CLC                       
CODE_00CA77:        69 08         ADC.B #$08                
CODE_00CA79:        85 00         STA $00                   
CODE_00CA7B:        A9 18         LDA.B #$18                
CODE_00CA7D:        A4 19         LDY RAM_MarioPowerUp      
CODE_00CA7F:        F0 02         BEQ CODE_00CA83           
CODE_00CA81:        A9 10         LDA.B #$10                
CODE_00CA83:        18            CLC                       
CODE_00CA84:        65 80         ADC $80                   
CODE_00CA86:        85 01         STA $01                   
CODE_00CA88:        C2 30         REP #$30                  ; 16 bit A ; Index (16 bit) Accum (16 bit) 
CODE_00CA8A:        29 FF 00      AND.W #$00FF              ; Keep lower byte of A 
CODE_00CA8D:        0A            ASL                       ; \  
CODE_00CA8E:        3A            DEC A                     ;  |Set Y to ((2A-1)*2) 
CODE_00CA8F:        0A            ASL                       ;  | 
CODE_00CA90:        A8            TAY                       ; /  
CODE_00CA91:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
CODE_00CA93:        A2 00 00      LDX.W #$0000              
CODE_00CA96:        A5 01         LDA $01                   
CODE_00CA98:        CD 33 14      CMP.W $1433               
CODE_00CA9B:        90 20         BCC CODE_00CABD           
CODE_00CA9D:        A9 FF         LDA.B #$FF                
CODE_00CA9F:        9D A0 04      STA.W $04A0,X             
CODE_00CAA2:        9E A1 04      STZ.W $04A1,X             
CODE_00CAA5:        C0 C0 01      CPY.W #$01C0              
CODE_00CAA8:        B0 07         BCS CODE_00CAB1           
CODE_00CAAA:        99 A0 04      STA.W $04A0,Y             
CODE_00CAAD:        1A            INC A                     
CODE_00CAAE:        99 A1 04      STA.W $04A1,Y             
CODE_00CAB1:        E8            INX                       
CODE_00CAB2:        E8            INX                       
CODE_00CAB3:        88            DEY                       
CODE_00CAB4:        88            DEY                       
CODE_00CAB5:        A5 01         LDA $01                   
CODE_00CAB7:        F0 51         BEQ CODE_00CB0A           
CODE_00CAB9:        C6 01         DEC $01                   
CODE_00CABB:        80 D9         BRA CODE_00CA96           

CODE_00CABD:        20 14 CC      JSR.W CODE_00CC14         
CODE_00CAC0:        18            CLC                       
CODE_00CAC1:        65 00         ADC $00                   
CODE_00CAC3:        90 02         BCC CODE_00CAC7           
CODE_00CAC5:        A9 FF         LDA.B #$FF                
CODE_00CAC7:        9D A1 04      STA.W $04A1,X             
CODE_00CACA:        A5 00         LDA $00                   
CODE_00CACC:        38            SEC                       
CODE_00CACD:        E5 02         SBC $02                   
CODE_00CACF:        B0 02         BCS CODE_00CAD3           
CODE_00CAD1:        A9 00         LDA.B #$00                
CODE_00CAD3:        9D A0 04      STA.W $04A0,X             
CODE_00CAD6:        C0 E0 01      CPY.W #$01E0              
CODE_00CAD9:        B0 23         BCS CODE_00CAFE           
CODE_00CADB:        A5 07         LDA $07                   
CODE_00CADD:        D0 08         BNE CODE_00CAE7           
CODE_00CADF:        A9 00         LDA.B #$00                
CODE_00CAE1:        99 A1 04      STA.W $04A1,Y             
CODE_00CAE4:        3A            DEC A                     
CODE_00CAE5:        80 14         BRA CODE_00CAFB           

CODE_00CAE7:        A5 03         LDA $03                   
CODE_00CAE9:        65 00         ADC $00                   
CODE_00CAEB:        90 02         BCC CODE_00CAEF           
CODE_00CAED:        A9 FF         LDA.B #$FF                
CODE_00CAEF:        99 A1 04      STA.W $04A1,Y             
CODE_00CAF2:        A5 00         LDA $00                   
CODE_00CAF4:        38            SEC                       
CODE_00CAF5:        E5 03         SBC $03                   
CODE_00CAF7:        B0 02         BCS CODE_00CAFB           
CODE_00CAF9:        A9 00         LDA.B #$00                
CODE_00CAFB:        99 A0 04      STA.W $04A0,Y             
CODE_00CAFE:        E8            INX                       
CODE_00CAFF:        E8            INX                       
CODE_00CB00:        88            DEY                       
CODE_00CB01:        88            DEY                       
CODE_00CB02:        A5 01         LDA $01                   
CODE_00CB04:        F0 04         BEQ CODE_00CB0A           
CODE_00CB06:        C6 01         DEC $01                   
CODE_00CB08:        D0 B3         BNE CODE_00CABD           
CODE_00CB0A:        A9 80         LDA.B #$80                
CODE_00CB0C:        8D 9F 0D      STA.W $0D9F               
CODE_00CB0F:        E2 10         SEP #$10                  ; Index (8 bit) 
Return00CB11:       60            RTS                       ; Return 


DATA_00CB12:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FE,$FE,$FE,$FE
                                  .db $FD,$FD,$FD,$FD,$FC,$FC,$FC,$FB
                                  .db $FB,$FB,$FA,$FA,$F9,$F9,$F8,$F8
                                  .db $F7,$F7,$F6,$F6,$F5,$F5,$F4,$F3
                                  .db $F3,$F2,$F1,$F1,$F0,$EF,$EE,$EE
                                  .db $ED,$EC,$EB,$EA,$E9,$E9,$E8,$E7
                                  .db $E6,$E5,$E4,$E3,$E2,$E1,$DF,$DE
                                  .db $DD,$DC,$DB,$DA,$D8,$D7,$D6,$D5
                                  .db $D3,$D2,$D0,$CF,$CD,$CC,$CA,$C9
                                  .db $C7,$C6,$C4,$C2,$C1,$BF,$BD,$BB
                                  .db $B9,$B7,$B6,$B4,$B1,$AF,$AD,$AB
                                  .db $A9,$A7,$A4,$A2,$9F,$9D,$9A,$97
                                  .db $95,$92,$8F,$8C,$89,$86,$82,$7F
                                  .db $7B,$78,$74,$70,$6C,$67,$63,$5E
                                  .db $59,$53,$4D,$46,$3F,$37,$2D,$1F
                                  .db $00,$54,$53,$52,$52,$51,$50,$50
                                  .db $4F,$4E,$4E,$4D,$4C,$4C,$4B,$4A
                                  .db $4A,$4B,$48,$48,$47,$46,$46,$45
                                  .db $44,$44,$43,$42,$42,$41,$40,$40
                                  .db $3F,$3E,$3E,$3D,$3C,$3C,$3B,$3A
                                  .db $3A,$39,$38,$38,$37,$36,$36,$35
                                  .db $34,$34,$33,$32,$32,$31,$33,$35
                                  .db $38,$3A,$3C,$3E,$3F,$41,$43,$44
                                  .db $45,$47,$48,$49,$4A,$4B,$4C,$4D
                                  .db $4E,$4E,$4F,$50,$50,$51,$51,$52
                                  .db $52,$53,$53,$53,$53,$53,$53,$53
                                  .db $53,$53,$53,$53,$53,$53,$52,$52
                                  .db $51,$51,$50,$50,$4F,$4E,$4E,$4D
                                  .db $4C,$4B,$4A,$49,$48,$47,$45,$44
                                  .db $43,$41,$3F,$3E,$3C,$3A,$38,$35
                                  .db $33,$30,$2D,$2A,$26,$23,$1E,$18
                                  .db $11,$00

CODE_00CC14:        5A            PHY                       
CODE_00CC15:        A5 01         LDA $01                   
CODE_00CC17:        8D 05 42      STA.W $4205               ; Dividend (High-Byte)
CODE_00CC1A:        9C 04 42      STZ.W $4204               ; Dividend (Low Byte)
CODE_00CC1D:        AD 33 14      LDA.W $1433               
CODE_00CC20:        8D 06 42      STA.W $4206               ; Divisor B
CODE_00CC23:        EA            NOP                       
CODE_00CC24:        EA            NOP                       
CODE_00CC25:        EA            NOP                       
CODE_00CC26:        EA            NOP                       
CODE_00CC27:        EA            NOP                       
CODE_00CC28:        EA            NOP                       
CODE_00CC29:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00CC2B:        AD 14 42      LDA.W $4214               ; Quotient of Divide Result (Low Byte)
CODE_00CC2E:        4A            LSR                       
CODE_00CC2F:        A8            TAY                       
CODE_00CC30:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00CC32:        B1 06         LDA ($06),Y               
CODE_00CC34:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_00CC37:        AD 33 14      LDA.W $1433               
CODE_00CC3A:        8D 03 42      STA.W $4203               ; Multplier B
CODE_00CC3D:        EA            NOP                       
CODE_00CC3E:        EA            NOP                       
CODE_00CC3F:        EA            NOP                       
CODE_00CC40:        EA            NOP                       
CODE_00CC41:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_00CC44:        85 03         STA $03                   
CODE_00CC46:        B1 04         LDA ($04),Y               
CODE_00CC48:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_00CC4B:        AD 33 14      LDA.W $1433               
CODE_00CC4E:        8D 03 42      STA.W $4203               ; Multplier B
CODE_00CC51:        EA            NOP                       
CODE_00CC52:        EA            NOP                       
CODE_00CC53:        EA            NOP                       
CODE_00CC54:        EA            NOP                       
CODE_00CC55:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_00CC58:        85 02         STA $02                   
CODE_00CC5A:        7A            PLY                       
Return00CC5B:       60            RTS                       ; Return 


DATA_00CC5C:                      .db $00,$00,$00,$00,$02,$00,$06,$00
                                  .db $FE,$FF,$FA,$FF

ResetAni:           A5 17         LDA RAM_ControllerB       
CODE_00CC6A:        29 20         AND.B #$20                
CODE_00CC6C:        F0 13         BEQ CODE_00CC81           
CODE_00CC6E:        A5 18         LDA $18                   
CODE_00CC70:        C9 80         CMP.B #$80                
CODE_00CC72:        D0 0D         BNE CODE_00CC81           
ADDR_00CC74:        EE 01 1E      INC.W $1E01               
ADDR_00CC77:        AD 01 1E      LDA.W $1E01               
ADDR_00CC7A:        C9 03         CMP.B #$03                
ADDR_00CC7C:        90 03         BCC CODE_00CC81           
ADDR_00CC7E:        9C 01 1E      STZ.W $1E01               
CODE_00CC81:        AD 01 1E      LDA.W $1E01               
CODE_00CC84:        80 35         BRA CODE_00CCBB           ; Change to BEQ to enable debug code below 

ADDR_00CC86:        4A            LSR                       ; \ Unreachable 
ADDR_00CC87:        F0 2A         BEQ ADDR_00CCB3           ;  | Debug: Free roaming mode 
ADDR_00CC89:        A9 FF         LDA.B #$FF                ;  | 
ADDR_00CC8B:        8D 97 14      STA.W $1497               ;  | 
ADDR_00CC8E:        A5 15         LDA RAM_ControllerA       ;  | 
ADDR_00CC90:        29 03         AND.B #$03                ;  | 
ADDR_00CC92:        0A            ASL                       ;  | 
ADDR_00CC93:        0A            ASL                       ;  | 
ADDR_00CC94:        A2 00         LDX.B #$00                ;  | 
ADDR_00CC96:        20 9F CC      JSR.W ADDR_00CC9F         ;  | 
ADDR_00CC99:        A5 15         LDA RAM_ControllerA       ;  | 
ADDR_00CC9B:        29 0C         AND.B #$0C                ;  | 
ADDR_00CC9D:        A2 02         LDX.B #$02                ;  | 
ADDR_00CC9F:        24 15         BIT RAM_ControllerA       ;  | 
ADDR_00CCA1:        50 02         BVC ADDR_00CCA5           ;  | 
ADDR_00CCA3:        09 02         ORA.B #$02                ;  | 
ADDR_00CCA5:        A8            TAY                       ;  | 
ADDR_00CCA6:        C2 20         REP #$20                  ;  | Accum (16 bit) ; Accum (16 bit) 
ADDR_00CCA8:        B5 94         LDA RAM_MarioXPos,X       ;  | 
ADDR_00CCAA:        18            CLC                       ;  | 
ADDR_00CCAB:        79 5C CC      ADC.W DATA_00CC5C,Y       ;  | 
ADDR_00CCAE:        95 94         STA RAM_MarioXPos,X       ;  | 
ADDR_00CCB0:        E2 20         SEP #$20                  ;  | Accum (8 bit) ; Accum (8 bit) 
Return00CCB2:       60            RTS                       ; / Return 

ADDR_00CCB3:        A9 70         LDA.B #$70                
ADDR_00CCB5:        8D E4 13      STA.W $13E4               
ADDR_00CCB8:        8D 9F 14      STA.W $149F               
CODE_00CCBB:        AD 93 14      LDA.W $1493               
CODE_00CCBE:        F0 03         BEQ CODE_00CCC3           
CODE_00CCC0:        4C 15 C9      JMP.W CODE_00C915         

CODE_00CCC3:        20 DD CD      JSR.W CODE_00CDDD         
CODE_00CCC6:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_00CCC8:        D0 15         BNE Return00CCDF          ; / 
CODE_00CCCA:        9C E8 13      STZ.W $13E8               
CODE_00CCCD:        9C DE 13      STZ.W $13DE               
CODE_00CCD0:        AD BD 18      LDA.W RAM_LockMarioTimer  ; \ If lock Mario timer is set... 
CODE_00CCD3:        F0 0B         BEQ CODE_00CCE0           ;  | 
CODE_00CCD5:        CE BD 18      DEC.W RAM_LockMarioTimer  ;  | Decrease the timer 
CODE_00CCD8:        64 7B         STZ RAM_MarioSpeedX       ;  | X speed = 0 
CODE_00CCDA:        A9 0F         LDA.B #$0F                ;  | Mario's image = Going down tube 
CODE_00CCDC:        8D E0 13      STA.W MarioFrame          ; / 
Return00CCDF:       60            RTS                       ; Return 

CODE_00CCE0:        AD 9B 0D      LDA.W $0D9B               
CODE_00CCE3:        10 3F         BPL CODE_00CD24           
CODE_00CCE5:        4A            LSR                       
CODE_00CCE6:        B0 3C         BCS CODE_00CD24           
CODE_00CCE8:        2C 9B 0D      BIT.W $0D9B               
CODE_00CCEB:        70 2F         BVS CODE_00CD1C           
CODE_00CCED:        A5 72         LDA RAM_IsFlying          
CODE_00CCEF:        D0 2B         BNE CODE_00CD1C           
CODE_00CCF1:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00CCF3:        AD 36 14      LDA.W RAM_KeyHolePos1     
CODE_00CCF6:        85 94         STA RAM_MarioXPos         
CODE_00CCF8:        AD 38 14      LDA.W RAM_KeyHolePos2     
CODE_00CCFB:        85 96         STA RAM_MarioYPos         
CODE_00CCFD:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00CCFF:        20 2D DC      JSR.W CODE_00DC2D         
CODE_00CD02:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00CD04:        A5 94         LDA RAM_MarioXPos         
CODE_00CD06:        8D 36 14      STA.W RAM_KeyHolePos1     
CODE_00CD09:        8D B4 14      STA.W $14B4               
CODE_00CD0C:        A5 96         LDA RAM_MarioYPos         
CODE_00CD0E:        29 F0 FF      AND.W #$FFF0              
CODE_00CD11:        8D 38 14      STA.W RAM_KeyHolePos2     
CODE_00CD14:        8D B6 14      STA.W $14B6               
CODE_00CD17:        20 C9 F9      JSR.W CODE_00F9C9         
CODE_00CD1A:        80 03         BRA CODE_00CD1F           

CODE_00CD1C:        20 2D DC      JSR.W CODE_00DC2D         ; Accum (8 bit) 
CODE_00CD1F:        20 F2 F8      JSR.W CODE_00F8F2         
CODE_00CD22:        80 12         BRA CODE_00CD36           

CODE_00CD24:        A5 7D         LDA RAM_MarioSpeedY       ; \ Branch if Mario has downward speed 
CODE_00CD26:        10 08         BPL CODE_00CD30           ; / 
CODE_00CD28:        A5 77         LDA RAM_MarioObjStatus    
CODE_00CD2A:        29 08         AND.B #$08                
CODE_00CD2C:        F0 02         BEQ CODE_00CD30           
CODE_00CD2E:        64 7D         STZ RAM_MarioSpeedY       ; Y speed = 0 
CODE_00CD30:        20 2D DC      JSR.W CODE_00DC2D         
CODE_00CD33:        20 2B E9      JSR.W CODE_00E92B         
CODE_00CD36:        20 95 F5      JSR.W CODE_00F595         
CODE_00CD39:        9C DD 13      STZ.W RAM_ChangingDir     
CODE_00CD3C:        AC F3 13      LDY.W $13F3               
CODE_00CD3F:        D0 54         BNE CODE_00CD95           
CODE_00CD41:        AD BE 18      LDA.W $18BE               
CODE_00CD44:        F0 04         BEQ CODE_00CD4A           
CODE_00CD46:        A9 1F         LDA.B #$1F                
CODE_00CD48:        85 8B         STA $8B                   
CODE_00CD4A:        A5 74         LDA RAM_IsClimbing        
CODE_00CD4C:        D0 24         BNE CODE_00CD72           
CODE_00CD4E:        AD 8F 14      LDA.W $148F               
CODE_00CD51:        0D 7A 18      ORA.W RAM_OnYoshi         
CODE_00CD54:        D0 23         BNE CODE_00CD79           
CODE_00CD56:        A5 8B         LDA $8B                   
CODE_00CD58:        29 1B         AND.B #$1B                
CODE_00CD5A:        C9 1B         CMP.B #$1B                
CODE_00CD5C:        D0 1B         BNE CODE_00CD79           
CODE_00CD5E:        A5 15         LDA RAM_ControllerA       
CODE_00CD60:        29 0C         AND.B #$0C                
CODE_00CD62:        F0 15         BEQ CODE_00CD79           
CODE_00CD64:        A4 72         LDY RAM_IsFlying          
CODE_00CD66:        D0 0A         BNE CODE_00CD72           
CODE_00CD68:        29 08         AND.B #$08                
CODE_00CD6A:        D0 06         BNE CODE_00CD72           
ADDR_00CD6C:        A5 8B         LDA $8B                   
ADDR_00CD6E:        29 04         AND.B #$04                
ADDR_00CD70:        F0 07         BEQ CODE_00CD79           
CODE_00CD72:        A5 8B         LDA $8B                   
CODE_00CD74:        85 74         STA RAM_IsClimbing        
CODE_00CD76:        4C 17 DB      JMP.W CODE_00DB17         

CODE_00CD79:        A5 75         LDA RAM_IsSwimming        
CODE_00CD7B:        F0 05         BEQ CODE_00CD82           
CODE_00CD7D:        20 88 D9      JSR.W CODE_00D988         
CODE_00CD80:        80 0D         BRA CODE_00CD8F           

CODE_00CD82:        20 F2 D5      JSR.W CODE_00D5F2         
CODE_00CD85:        20 62 D0      JSR.W CODE_00D062         
CODE_00CD88:        20 E4 D7      JSR.W CODE_00D7E4         
CODE_00CD8B:        22 B1 CE 00   JSL.L CODE_00CEB1         
CODE_00CD8F:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_00CD92:        D0 19         BNE CODE_00CDAD           
Return00CD94:       60            RTS                       ; Return 

CODE_00CD95:        A9 42         LDA.B #$42                
CODE_00CD97:        A6 19         LDX RAM_MarioPowerUp      
CODE_00CD99:        F0 02         BEQ CODE_00CD9D           
CODE_00CD9B:        A9 43         LDA.B #$43                
CODE_00CD9D:        88            DEY                       
CODE_00CD9E:        F0 05         BEQ CODE_00CDA5           
CODE_00CDA0:        8C F3 13      STY.W $13F3               
CODE_00CDA3:        A9 0F         LDA.B #$0F                ; \ Mario's image = Going down tube 
CODE_00CDA5:        8D E0 13      STA.W MarioFrame          ; / 
CODE_00CDA8:        60            RTS                       


OnYoshiAnimations:                .db $20,$21,$27,$28

CODE_00CDAD:        AE A3 14      LDX.W $14A3               
CODE_00CDB0:        F0 08         BEQ CODE_00CDBA           
CODE_00CDB2:        A0 03         LDY.B #$03                
CODE_00CDB4:        E0 0C         CPX.B #$0C                
CODE_00CDB6:        B0 02         BCS CODE_00CDBA           
CODE_00CDB8:        A0 04         LDY.B #$04                
CODE_00CDBA:        B9 A8 CD      LDA.W CODE_00CDA8,Y       
CODE_00CDBD:        88            DEY                       
CODE_00CDBE:        D0 06         BNE CODE_00CDC6           
CODE_00CDC0:        A4 73         LDY RAM_IsDucking         
CODE_00CDC2:        F0 02         BEQ CODE_00CDC6           
CODE_00CDC4:        A9 1D         LDA.B #$1D                ; \ Mario's image = Picking up object 
CODE_00CDC6:        8D E0 13      STA.W MarioFrame          ; / 
CODE_00CDC9:        AD 1E 14      LDA.W RAM_YoshiHasWings   ; \ Check Yoshi wing ability address for #$01, 
CODE_00CDCC:        C9 01         CMP.B #$01                ; / but this is an impossible value 
CODE_00CDCE:        D0 0C         BNE Return00CDDC          ; \ Unreachable/unused code 
ADDR_00CDD0:        24 16         BIT $16                   ;  | Lets Mario (any power) shoot fireballs while on Yoshi 
ADDR_00CDD2:        50 08         BVC Return00CDDC          ;  | 
ADDR_00CDD4:        A9 08         LDA.B #$08                ;  | 
ADDR_00CDD6:        8D DB 18      STA.W $18DB               ;  | 
ADDR_00CDD9:        20 A8 FE      JSR.W ShootFireball       ; / 
Return00CDDC:       60            RTS                       ; Return 

CODE_00CDDD:        AD 11 14      LDA.W $1411               
CODE_00CDE0:        F0 FA         BEQ Return00CDDC          
CODE_00CDE2:        AC FE 13      LDY.W $13FE               
CODE_00CDE5:        AD FD 13      LDA.W $13FD               
CODE_00CDE8:        85 9D         STA RAM_SpritesLocked     
CODE_00CDEA:        D0 60         BNE CODE_00CE4C           
CODE_00CDEC:        AD 00 14      LDA.W $1400               
CODE_00CDEF:        F0 05         BEQ CODE_00CDF6           
CODE_00CDF1:        9C FE 13      STZ.W $13FE               
CODE_00CDF4:        80 52         BRA CODE_00CE48           

CODE_00CDF6:        A5 17         LDA RAM_ControllerB       ; \ Branch if anything besides L/R being held 
CODE_00CDF8:        29 CF         AND.B #$CF                ;  | 
CODE_00CDFA:        05 15         ORA RAM_ControllerA       ;  | 
CODE_00CDFC:        D0 4B         BNE CODE_00CE49           ; / 
CODE_00CDFE:        A5 17         LDA RAM_ControllerB       ; \ Branch if L/R not being held 
CODE_00CE00:        29 30         AND.B #$30                ;  | 
CODE_00CE02:        F0 45         BEQ CODE_00CE49           ;  | 
CODE_00CE04:        C9 30         CMP.B #$30                ;  | 
CODE_00CE06:        F0 41         BEQ CODE_00CE49           ; / 
ScrollScreen:       4A            LSR                       
CODE_00CE09:        4A            LSR                       
CODE_00CE0A:        4A            LSR                       
CODE_00CE0B:        EE 01 14      INC.W $1401               
CODE_00CE0E:        AE 01 14      LDX.W $1401               
CODE_00CE11:        E0 10         CPX.B #$10                
CODE_00CE13:        90 37         BCC CODE_00CE4C           
CODE_00CE15:        AA            TAX                       
CODE_00CE16:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00CE18:        AD 2A 14      LDA.W $142A               
CODE_00CE1B:        DD CB F6      CMP.W DATA_00F6CB,X       
CODE_00CE1E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00CE20:        F0 2A         BEQ CODE_00CE4C           
CODE_00CE22:        A9 01         LDA.B #$01                
CODE_00CE24:        1C 2A 14      TRB.W $142A               
CODE_00CE27:        EE FD 13      INC.W $13FD               
CODE_00CE2A:        A9 00         LDA.B #$00                
CODE_00CE2C:        E0 02         CPX.B #$02                
CODE_00CE2E:        D0 03         BNE CODE_00CE33           
CODE_00CE30:        A5 5E         LDA $5E                   
CODE_00CE32:        3A            DEC A                     
CODE_00CE33:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00CE35:        EB            XBA                       
CODE_00CE36:        29 00 FF      AND.W #$FF00              
CODE_00CE39:        C5 1A         CMP RAM_ScreenBndryXLo    
CODE_00CE3B:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00CE3D:        F0 05         BEQ CODE_00CE44           
CODE_00CE3F:        A0 0E         LDY.B #$0E                ; \ Play sound effect 
CODE_00CE41:        8C FC 1D      STY.W $1DFC               ; / 
CODE_00CE44:        8A            TXA                       
CODE_00CE45:        8D FE 13      STA.W $13FE               
CODE_00CE48:        A8            TAY                       
CODE_00CE49:        9C 01 14      STZ.W $1401               
CODE_00CE4C:        A2 00         LDX.B #$00                
CODE_00CE4E:        A5 76         LDA RAM_MarioDirection    
CODE_00CE50:        0A            ASL                       
CODE_00CE51:        8D FF 13      STA.W $13FF               
CODE_00CE54:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00CE56:        AD 2A 14      LDA.W $142A               
CODE_00CE59:        D9 CB F6      CMP.W DATA_00F6CB,Y       
CODE_00CE5C:        F0 0F         BEQ CODE_00CE6D           
CODE_00CE5E:        18            CLC                       
CODE_00CE5F:        79 BF F6      ADC.W DATA_00F6BF,Y       
CODE_00CE62:        AC FF 13      LDY.W $13FF               
CODE_00CE65:        D9 B3 F6      CMP.W DATA_00F6B3,Y       
CODE_00CE68:        D0 06         BNE CODE_00CE70           
CODE_00CE6A:        8E FE 13      STX.W $13FE               
CODE_00CE6D:        8E FD 13      STX.W $13FD               
CODE_00CE70:        8D 2A 14      STA.W $142A               
CODE_00CE73:        8E 00 14      STX.W $1400               
CODE_00CE76:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00CE78:        60            RTS                       


DATA_00CE79:                      .db $2A,$2B,$2C,$2D,$2E,$2F

DATA_00CE7F:                      .db $2C,$2C,$2C,$2B,$2B,$2C,$2C,$2B
                                  .db $2B,$2C,$2D,$2A,$2A,$2D,$2D,$2A
                                  .db $2A,$2D,$2D,$2A,$2A,$2D,$2E,$2A
                                  .db $2A,$2E

DATA_00CE99:                      .db $00,$00,$25,$44,$00,$00,$0F,$45
DATA_00CEA1:                      .db $00,$00,$00,$00,$01,$01,$01,$01
DATA_00CEA9:                      .db $02,$07,$06,$09,$02,$07,$06,$09

CODE_00CEB1:        AD A2 14      LDA.W $14A2               ; Related to cape animation? 
CODE_00CEB4:        D0 60         BNE lbl14A2Not0           
CODE_00CEB6:        AE DF 13      LDX.W $13DF               ; Cape image 
CODE_00CEB9:        A5 72         LDA RAM_IsFlying          ; If Mario isn't in air, branch to $CEDE 
CODE_00CEBB:        F0 21         BEQ MarioAnimAir          ; branch to $CEDE 
CODE_00CEBD:        A0 04         LDY.B #$04                
CODE_00CEBF:        24 7D         BIT RAM_MarioSpeedY       ; \ If Mario is falling (and thus not on ground) 
CODE_00CEC1:        10 0A         BPL CODE_00CECD           ; / branch down 
CODE_00CEC3:        C9 0C         CMP.B #$0C                ; \ If making a "run jump", 
CODE_00CEC5:        F0 36         BEQ CODE_00CEFD           ; / branch to $CEFD 
CODE_00CEC7:        A5 75         LDA RAM_IsSwimming        ; \ If Mario is in water, 
CODE_00CEC9:        D0 32         BNE CODE_00CEFD           ;  |branch to $CEFD 
CODE_00CECB:        80 17         BRA MrioNtInWtr           ; / otherwise, branch to $CEE4 

CODE_00CECD:        E8            INX                       ; \  
CODE_00CECE:        E0 05         CPX.B #$05                ;  |if X >= #$04 and != #$FF then jump down <- counting the INX 
CODE_00CED0:        B0 04         BCS CODE_00CED6           ; /  
CODE_00CED2:        A2 05         LDX.B #$05                ; X = #$05 
CODE_00CED4:        80 34         BRA CODE_00CF0A           ; Branch to $CF04 

CODE_00CED6:        E0 0B         CPX.B #$0B                ; \ If X is less than #$0B, 
CODE_00CED8:        90 30         BCC CODE_00CF0A           ; / branch to $CF0A 
CODE_00CEDA:        A2 07         LDX.B #$07                ; X = #$07 
CODE_00CEDC:        80 2C         BRA CODE_00CF0A           ; Mario is not in the air, branch to $CF0A 

MarioAnimAir:       A5 7B         LDA RAM_MarioSpeedX       ; \ If Mario X speed isn't 0, 
CODE_00CEE0:        D0 0E         BNE CODE_00CEF0           ; / branch to $CEF0 
CODE_00CEE2:        A0 08         LDY.B #$08                ; Otherwise Y = #$08 
MrioNtInWtr:        8A            TXA                       ; A = X = #13DF 
CODE_00CEE5:        F0 23         BEQ CODE_00CF0A           ; If $13DF (now A) = 0 branch to $CF04 
CODE_00CEE7:        CA            DEX                       ; \  
CODE_00CEE8:        E0 03         CPX.B #$03                ;  |If X - 1 < #$03 Then Branch $CF04 
CODE_00CEEA:        90 1E         BCC CODE_00CF0A           ; /  
CODE_00CEEC:        A2 02         LDX.B #$02                ; X = #$02 
CODE_00CEEE:        80 1A         BRA CODE_00CF0A           ; Branch to $CF04 

CODE_00CEF0:        10 03         BPL CODE_00CEF5           ; \  
CODE_00CEF2:        49 FF         EOR.B #$FF                ;  |A = abs(A) 
CODE_00CEF4:        1A            INC A                     ;  | 
CODE_00CEF5:        4A            LSR                       ; \  
CODE_00CEF6:        4A            LSR                       ;  |Divide a by 8 
CODE_00CEF7:        4A            LSR                       ; /  
CODE_00CEF8:        A8            TAY                       ; Y = A 
CODE_00CEF9:        B9 7C DC      LDA.W DATA_00DC7C,Y       ; A = Mario animation speed? (I didn't know it was a table...) 
CODE_00CEFC:        A8            TAY                       ; Load Y with this table 
CODE_00CEFD:        E8            INX                       ; \  
CODE_00CEFE:        E0 03         CPX.B #$03                ;  | 
CODE_00CF00:        B0 02         BCS CODE_00CF04           ;  |If X is < #$02 and != #$FF <- counting the INX 
CODE_00CF02:        A2 05         LDX.B #$05                ;  |then X = #$05 
CODE_00CF04:        E0 07         CPX.B #$07                ; \  
CODE_00CF06:        90 02         BCC CODE_00CF0A           ;  |If X is greater than or equal to #$07 then X = #$03 
CODE_00CF08:        A2 03         LDX.B #$03                ;  | 
CODE_00CF0A:        8E DF 13      STX.W $13DF               ; And X goes right back into $13DF (cape image) after being modified 
CODE_00CF0D:        98            TYA                       ; Now Y goes back into A 
CODE_00CF0E:        A4 75         LDY RAM_IsSwimming        ; \  
CODE_00CF10:        F0 01         BEQ CODE_00CF13           ;  |If mario is in water then A = 2A 
CODE_00CF12:        0A            ASL                       ;  | 
CODE_00CF13:        8D A2 14      STA.W $14A2               ; A -> $14A2 (do we know this byte yet?) no. 
lbl14A2Not0:        AD 0D 14      LDA.W RAM_IsSpinJump      ; A = Spin Jump Flag 
CODE_00CF19:        0D A6 14      ORA.W $14A6               
CODE_00CF1C:        F0 30         BEQ CODE_00CF4E           ; If $140D OR $14A6 = 0 then branch to $CF4E 
CODE_00CF1E:        64 73         STZ RAM_IsDucking         ; 0 -> Ducking while jumping flag 
CODE_00CF20:        A5 14         LDA RAM_FrameCounterB     ; \  
CODE_00CF22:        29 06         AND.B #$06                ;  |X = Y = Alternate frame counter AND #$06 
CODE_00CF24:        AA            TAX                       ;  | 
CODE_00CF25:        A8            TAY                       ; /  
CODE_00CF26:        A5 72         LDA RAM_IsFlying          ; \ If on ground branch down 
CODE_00CF28:        F0 05         BEQ CODE_00CF2F           ; /  
CODE_00CF2A:        A5 7D         LDA RAM_MarioSpeedY       ; \ If Mario moving upwards branch down 
CODE_00CF2C:        30 01         BMI CODE_00CF2F           ; /  
CODE_00CF2E:        C8            INY                       ; Y = Y + 1 
CODE_00CF2F:        B9 A9 CE      LDA.W DATA_00CEA9,Y       ; \ After loading from this table, 
CODE_00CF32:        8D DF 13      STA.W $13DF               ; / Store A in cape image 
CODE_00CF35:        A5 19         LDA RAM_MarioPowerUp      ; A = Mario's powerup status 
CODE_00CF37:        F0 01         BEQ CODE_00CF3A           ; \  
CODE_00CF39:        E8            INX                       ;  |If not small, increase X 
CODE_00CF3A:        BD A1 CE      LDA.W DATA_00CEA1,X       ; \ Load from another table 
CODE_00CF3D:        85 76         STA RAM_MarioDirection    ; / store to Mario's Direction 
CODE_00CF3F:        A4 19         LDY RAM_MarioPowerUp      ; \  
CODE_00CF41:        C0 02         CPY.B #$02                ;  | 
CODE_00CF43:        D0 03         BNE CODE_00CF48           ;  |If Mario has cape, JSR 
CODE_00CF45:        20 44 D0      JSR.W CODE_00D044         ;  |to possibly the graphics handler 
CODE_00CF48:        BD 99 CE      LDA.W DATA_00CE99,X       ; \ Load from a table again 
CODE_00CF4B:        4C 1A D0      JMP.W CODE_00D01A         ; / And jump 

CODE_00CF4E:        AD ED 13      LDA.W $13ED               ; \ If $13ED is #$01 - #$7F then 
CODE_00CF51:        F0 0F         BEQ CODE_00CF62           ;  |branch to $CF85 
CODE_00CF53:        10 30         BPL CODE_00CF85           ;  | 
CODE_00CF55:        AD E1 13      LDA.W $13E1               
CODE_00CF58:        4A            LSR                       
CODE_00CF59:        4A            LSR                       
CODE_00CF5A:        05 76         ORA RAM_MarioDirection    
CODE_00CF5C:        A8            TAY                       
CODE_00CF5D:        B9 7F CE      LDA.W DATA_00CE7F,Y       
CODE_00CF60:        80 23         BRA CODE_00CF85           

CODE_00CF62:        A9 3C         LDA.B #$3C                ; \ Select Case $148F 
CODE_00CF64:        AC 8F 14      LDY.W $148F               ;  |Case 0:A = #$3C 
CODE_00CF67:        F0 02         BEQ CODE_00CF6B           ;  |Case Else: A = #$1D 
CODE_00CF69:        A9 1D         LDA.B #$1D                ;  |End Select 
CODE_00CF6B:        A4 73         LDY RAM_IsDucking         ; \ If Ducking while jumping 
CODE_00CF6D:        D0 16         BNE CODE_00CF85           ; / Branch to $CF85 
CODE_00CF6F:        AD 9C 14      LDA.W RAM_FireballImgTimer ; \ If (Unknown) = 0 
CODE_00CF72:        F0 0A         BEQ CODE_00CF7E           ; / Branch to $CF7E 
CODE_00CF74:        A9 3F         LDA.B #$3F                ; A = #$3F 
CODE_00CF76:        A4 72         LDY RAM_IsFlying          ; \ If Mario isn't in air,  
CODE_00CF78:        F0 0B         BEQ CODE_00CF85           ;  |branch to $CF85 
CODE_00CF7A:        A9 16         LDA.B #$16                ;  |Otherwise, set A to #$16 and 
CODE_00CF7C:        80 07         BRA CODE_00CF85           ; / branch to $CF85 

CODE_00CF7E:        A9 0E         LDA.B #$0E                ; A = #$0E 
CODE_00CF80:        AC 9A 14      LDY.W RAM_KickImgTimer    ; \ If Time to show Mario's current pose is 00, 
CODE_00CF83:        F0 03         BEQ CODE_00CF88           ;  | Don't jump to $D01A 
CODE_00CF85:        4C 1A D0      JMP.W CODE_00D01A         ;  | 

CODE_00CF88:        A9 1D         LDA.B #$1D                ; A = #$1D 
CODE_00CF8A:        AC 98 14      LDY.W RAM_PickUpImgTimer  ; \ If $1499 != 0 then Jump to $D01A 
CODE_00CF8D:        D0 F6         BNE CODE_00CF85           ; /  
CODE_00CF8F:        A9 0F         LDA.B #$0F                ; A = #$0F 
CODE_00CF91:        AC 99 14      LDY.W RAM_FaceCamImgTimer ; \ If $1499 != 0 then Jump to $D01A 
CODE_00CF94:        D0 EF         BNE CODE_00CF85           ; /  
CODE_00CF96:        A9 00         LDA.B #$00                ; A = #$00 
CODE_00CF98:        AE C2 18      LDX.W $18C2               ; X = $18C2 (Unknown) 
CODE_00CF9B:        D0 26         BNE MarioAnimNoAbs1       ; If X != 0 then branch down 
CODE_00CF9D:        A5 72         LDA RAM_IsFlying          ; \ If Mario is flying branch down 
CODE_00CF9F:        F0 16         BEQ CODE_00CFB7           ; /  
CODE_00CFA1:        AC A0 14      LDY.W $14A0               ; \ If $14A0 != 0 then 
CODE_00CFA4:        D0 16         BNE CODE_00CFBC           ; / Skip down 
CODE_00CFA6:        AC 07 14      LDY.W $1407               ; Spaghetticode(tm) 
CODE_00CFA9:        F0 03         BEQ CODE_00CFAE           
CODE_00CFAB:        B9 78 CE      LDA.W CODE_00CE78,Y       
CODE_00CFAE:        AC 8F 14      LDY.W $148F               ; \ If Mario isn't holding something, 
CODE_00CFB1:        F0 67         BEQ CODE_00D01A           ;  |branch to $D01A 
CODE_00CFB3:        A9 09         LDA.B #$09                ;  |Otherwise, set A to #$09 and 
CODE_00CFB5:        80 63         BRA CODE_00D01A           ; / branch to $D01A 

CODE_00CFB7:        AD DD 13      LDA.W RAM_ChangingDir     
CODE_00CFBA:        D0 5E         BNE CODE_00D01A           
CODE_00CFBC:        A5 7B         LDA RAM_MarioSpeedX       ; \  
CODE_00CFBE:        10 03         BPL MarioAnimNoAbs1       ;  | 
CODE_00CFC0:        49 FF         EOR.B #$FF                ;  |Set A to absolute value of Mario's X speed 
CODE_00CFC2:        1A            INC A                     ;  | 
MarioAnimNoAbs1:    AA            TAX                       ; Copy A to X 
CODE_00CFC4:        D0 0E         BNE CODE_00CFD4           ; If Mario isn't standing still, branch to $CFD4 
CODE_00CFC6:        EB            XBA                       ; "Push" A 
CODE_00CFC7:        A5 15         LDA RAM_ControllerA       ; \  
CODE_00CFC9:        29 08         AND.B #$08                ;  |If player isn't pressing up, 
CODE_00CFCB:        F0 35         BEQ CODE_00D002           ;  |branch to $D002 
CODE_00CFCD:        A9 03         LDA.B #$03                ;  |Otherwise, store x03 in $13DE and 
CODE_00CFCF:        8D DE 13      STA.W $13DE               ;  |branch to $D002 
CODE_00CFD2:        80 2E         BRA CODE_00D002           ; /  

CODE_00CFD4:        A5 86         LDA $86                   ; \ If level isn't slippery, 
CODE_00CFD6:        F0 0B         BEQ CODE_00CFE3           ; / branch to $CFE3 
CODE_00CFD8:        A5 15         LDA RAM_ControllerA       
CODE_00CFDA:        29 03         AND.B #$03                
CODE_00CFDC:        F0 25         BEQ CODE_00D003           
CODE_00CFDE:        A9 68         LDA.B #$68                
CODE_00CFE0:        8D E5 13      STA.W $13E5               
CODE_00CFE3:        AD DB 13      LDA.W $13DB               ; A = $13DB 
CODE_00CFE6:        AC 96 14      LDY.W $1496               ; \ If Mario is hurt (flashing), 
CODE_00CFE9:        D0 18         BNE CODE_00D003           ; / branch to $D003 
CODE_00CFEB:        3A            DEC A                     ; A = A - 1 
CODE_00CFEC:        10 05         BPL CODE_00CFF3           ; \If bit 7 is clear, 
CODE_00CFEE:        A4 19         LDY RAM_MarioPowerUp      ;  | Load amount of walking frames 
CODE_00CFF0:        B9 78 DC      LDA.W NumWalkingFrames,Y  ;  | for current powerup 
CODE_00CFF3:        EB            XBA                       ; \ >>-This code puts together an index to a table further down-<< 
CODE_00CFF4:        8A            TXA                       ;  |-\ Above Line: "Push" frame amount 
CODE_00CFF5:        4A            LSR                       ;  |  |A = X / 8 
CODE_00CFF6:        4A            LSR                       ;  |  | 
CODE_00CFF7:        4A            LSR                       ;  |-/  
CODE_00CFF8:        0D E5 13      ORA.W $13E5               ;  |ORA with $13E5 
CODE_00CFFB:        A8            TAY                       ;  |And store A to Y 
CODE_00CFFC:        B9 7C DC      LDA.W DATA_00DC7C,Y       ;  | 
CODE_00CFFF:        8D 96 14      STA.W $1496               ; /  
CODE_00D002:        EB            XBA                       ; \ Switch in frame amount and store it to $13DB 
CODE_00D003:        8D DB 13      STA.W $13DB               ; /  
CODE_00D006:        18            CLC                       ; \ Add walking animation type 
CODE_00D007:        6D DE 13      ADC.W $13DE               ; / (Walking, running...) 
CODE_00D00A:        AC 8F 14      LDY.W $148F               ; \  
CODE_00D00D:        F0 05         BEQ CODE_00D014           ;  | 
CODE_00D00F:        18            CLC                       ;  |If Mario is carrying something, add #$07 
CODE_00D010:        69 07         ADC.B #$07                ;  | 
CODE_00D012:        80 06         BRA CODE_00D01A           ;  | 

CODE_00D014:        E0 2F         CPX.B #$2F                ; \  
CODE_00D016:        90 02         BCC CODE_00D01A           ;  |If X is greater than #$2F, add #$04 
CODE_00D018:        69 03         ADC.B #$03                ; / <-Carry is always set here, adding #$01 to (#$03 + A) 
CODE_00D01A:        AC E3 13      LDY.W RAM_WallWalkStatus  ; \ If Mario isn't rotated 45 degrees (triangle 
CODE_00D01D:        F0 11         BEQ MarioAnimNo45         ; / block), branch to $D030 
CODE_00D01F:        98            TYA                       ; \ Y AND #$01 -> Mario's Direction RAM Byte 
CODE_00D020:        29 01         AND.B #$01                ;  | 
CODE_00D022:        85 76         STA RAM_MarioDirection    ; /  
CODE_00D024:        A9 10         LDA.B #$10                ; \  
CODE_00D026:        C0 06         CPY.B #$06                ;  |If Y < 6 then 
CODE_00D028:        90 06         BCC MarioAnimNo45         ;  |    A = #13DB + $11 
CODE_00D02A:        AD DB 13      LDA.W $13DB               ;  |Else 
CODE_00D02D:        18            CLC                       ;  |    A = #$10 
CODE_00D02E:        69 11         ADC.B #$11                ;  |End If 
MarioAnimNo45:      8D E0 13      STA.W MarioFrame          ; Store in Current animation frame 
Return00D033:       6B            RTL                       ; And Finish 


DATA_00D034:                      .db $0C,$00,$F4,$FF,$08,$00,$F8,$FF
DATA_00D03C:                      .db $10,$00,$10,$00,$02,$00,$02,$00

CODE_00D044:        A0 01         LDY.B #$01                
CODE_00D046:        8C E8 13      STY.W $13E8               
CODE_00D049:        0A            ASL                       
CODE_00D04A:        A8            TAY                       
CODE_00D04B:        C2 20         REP #$20                  ; 16 bit A ; Accum (16 bit) 
CODE_00D04D:        A5 94         LDA RAM_MarioXPos         ; \  
CODE_00D04F:        18            CLC                       ;  | 
CODE_00D050:        79 34 D0      ADC.W DATA_00D034,Y       ;  | 
CODE_00D053:        8D E9 13      STA.W $13E9               ;  |Set cape<->sprite collision coordinates 
CODE_00D056:        A5 96         LDA RAM_MarioYPos         ;  | 
CODE_00D058:        18            CLC                       ;  | 
CODE_00D059:        79 3C D0      ADC.W DATA_00D03C,Y       ;  | 
CODE_00D05C:        8D EB 13      STA.W $13EB               ; /  
CODE_00D05F:        E2 20         SEP #$20                  ; 8 bit A ; Accum (8 bit) 
Return00D061:       60            RTS                       ; Return 

CODE_00D062:        A5 19         LDA RAM_MarioPowerUp      
CODE_00D064:        C9 02         CMP.B #$02                
CODE_00D066:        D0 19         BNE CODE_00D081           
CODE_00D068:        24 16         BIT $16                   
CODE_00D06A:        50 41         BVC Return00D0AD          
CODE_00D06C:        A5 73         LDA RAM_IsDucking         
CODE_00D06E:        0D 7A 18      ORA.W RAM_OnYoshi         
CODE_00D071:        0D 0D 14      ORA.W RAM_IsSpinJump      
CODE_00D074:        D0 37         BNE Return00D0AD          
CODE_00D076:        A9 12         LDA.B #$12                
CODE_00D078:        8D A6 14      STA.W $14A6               
CODE_00D07B:        A9 04         LDA.B #$04                ; \ Play sound effect 
CODE_00D07D:        8D FC 1D      STA.W $1DFC               ; / 
Return00D080:       60            RTS                       ; Return 

CODE_00D081:        C9 03         CMP.B #$03                
CODE_00D083:        D0 28         BNE Return00D0AD          
CODE_00D085:        A5 73         LDA RAM_IsDucking         
CODE_00D087:        0D 7A 18      ORA.W RAM_OnYoshi         
CODE_00D08A:        D0 21         BNE Return00D0AD          
CODE_00D08C:        24 16         BIT $16                   
CODE_00D08E:        70 1A         BVS CODE_00D0AA           
CODE_00D090:        AD 0D 14      LDA.W RAM_IsSpinJump      
CODE_00D093:        F0 18         BEQ Return00D0AD          
CODE_00D095:        EE E2 13      INC.W $13E2               
CODE_00D098:        AD E2 13      LDA.W $13E2               
CODE_00D09B:        29 0F         AND.B #$0F                
CODE_00D09D:        D0 0E         BNE Return00D0AD          
CODE_00D09F:        A8            TAY                       
CODE_00D0A0:        AD E2 13      LDA.W $13E2               
CODE_00D0A3:        29 10         AND.B #$10                
CODE_00D0A5:        F0 01         BEQ CODE_00D0A8           
CODE_00D0A7:        C8            INY                       
CODE_00D0A8:        84 76         STY RAM_MarioDirection    
CODE_00D0AA:        20 A8 FE      JSR.W ShootFireball       ; haha, I read this as "FEAR" at first 
Return00D0AD:       60            RTS                       ; Return 


DATA_00D0AE:                      .db $7C,$00,$80,$00,$00,$06,$00,$01

MarioDeathAni:      64 19         STZ RAM_MarioPowerUp      ; Set powerup to 0 
CODE_00D0B8:        A9 3E         LDA.B #$3E                ; \  
CODE_00D0BA:        8D E0 13      STA.W MarioFrame          ; / Set Mario image to death image 
CODE_00D0BD:        A5 13         LDA RAM_FrameCounter      ; \  
CODE_00D0BF:        29 03         AND.B #$03                ;  |Decrease "Death fall timer" every four frames 
CODE_00D0C1:        D0 03         BNE CODE_00D0C6           ;  | 
CODE_00D0C3:        CE 96 14      DEC.W $1496               ;  | 
CODE_00D0C6:        AD 96 14      LDA.W $1496               ; \ If Death fall timer isn't #$00, 
CODE_00D0C9:        D0 3D         BNE DeathNotDone          ; / branch to $D108 
CODE_00D0CB:        A9 80         LDA.B #$80                
CODE_00D0CD:        8D D5 0D      STA.W $0DD5               
CODE_00D0D0:        AD 9B 1B      LDA.W $1B9B               
CODE_00D0D3:        D0 03         BNE CODE_00D0D8           
CODE_00D0D5:        9C C1 0D      STZ.W RAM_OWHasYoshi      ; Set reserve item to 0 
CODE_00D0D8:        CE BE 0D      DEC.W RAM_StatusLives     ; Decrease amount of lifes 
CODE_00D0DB:        10 09         BPL DeathNotGameOver      ; If not Game Over, branch to $D0E6 
CODE_00D0DD:        A9 0A         LDA.B #$0A                
CODE_00D0DF:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_00D0E2:        A2 14         LDX.B #$14                ; Set X (Death message) to x14 (Game Over) 
CODE_00D0E4:        80 0F         BRA DeathShowMessage      

DeathNotGameOver:   A0 0B         LDY.B #$0B                ; Set Y (game mode) to x0B (Fade to overworld) 
CODE_00D0E8:        AD 31 0F      LDA.W $0F31               ; \  
CODE_00D0EB:        0D 32 0F      ORA.W $0F32               ;  |If time isn't zero, 
CODE_00D0EE:        0D 33 0F      ORA.W $0F33               ;  |branch to $D104 
CODE_00D0F1:        D0 11         BNE DeathNotTimeUp        ; /  
CODE_00D0F3:        A2 1D         LDX.B #$1D                ; Set X (Death message) to x1D (Time Up) 
DeathShowMessage:   8E 3B 14      STX.W $143B               ; Store X in Death message 
CODE_00D0F8:        A9 C0         LDA.B #$C0                ; \ Set Death message animation to xC0 
CODE_00D0FA:        8D 3C 14      STA.W $143C               ; /(Must be divisable by 4) 
CODE_00D0FD:        A9 FF         LDA.B #$FF                ; \ Set Death message timer to xFF 
CODE_00D0FF:        8D 3D 14      STA.W $143D               ; / 
CODE_00D102:        A0 15         LDY.B #$15                ; Set Y (game mode) to x15 (Fade to Game Over) 
DeathNotTimeUp:     8C 00 01      STY.W RAM_GameMode        ; Store Y in Game Mode 
Return00D107:       60            RTS                       ; Return 

DeathNotDone:       C9 26         CMP.B #$26                ; \ If Death fall timer >= x26, 
CODE_00D10A:        B0 10         BCS DeathNotDoneEnd       ; / return 
CODE_00D10C:        64 7B         STZ RAM_MarioSpeedX       ; Set Mario X speed to 0 
CODE_00D10E:        20 2D DC      JSR.W CODE_00DC2D         
CODE_00D111:        20 2E D9      JSR.W CODE_00D92E         
CODE_00D114:        A5 13         LDA RAM_FrameCounter      ; \  
CODE_00D116:        4A            LSR                       ;  | 
CODE_00D117:        4A            LSR                       ;  |Flip death image every four frames 
CODE_00D118:        29 01         AND.B #$01                ;  | 
CODE_00D11A:        85 76         STA RAM_MarioDirection    ; /  
DeathNotDoneEnd:    60            RTS                       


GrowingAniImgs:                   .db $00,$3D,$00,$3D,$00,$3D,$46,$3D
                                  .db $46,$3D,$46,$3D

PowerDownAni:       AD 96 14      LDA.W $1496               
CODE_00D12C:        F0 12         BEQ CODE_00D140           
CODE_00D12E:        4A            LSR                       
CODE_00D12F:        4A            LSR                       
CODE_00D130:        A8            TAY                       
CODE_00D131:        B9 1D D1      LDA.W GrowingAniImgs,Y    ; \ Set Mario's image 
CODE_00D134:        8D E0 13      STA.W MarioFrame          ; / 
CODE_00D137:        AD 96 14      LDA.W $1496               
CODE_00D13A:        F0 03         BEQ Return00D13F          
CODE_00D13C:        CE 96 14      DEC.W $1496               
Return00D13F:       60            RTS                       ; Return 

CODE_00D140:        A9 7F         LDA.B #$7F                
CODE_00D142:        8D 97 14      STA.W $1497               
CODE_00D145:        80 11         BRA CODE_00D158           

MushroomAni:        AD 96 14      LDA.W $1496               
CODE_00D14A:        F0 0A         BEQ CODE_00D156           
CODE_00D14C:        4A            LSR                       
CODE_00D14D:        4A            LSR                       
CODE_00D14E:        49 FF         EOR.B #$FF                
CODE_00D150:        1A            INC A                     
CODE_00D151:        18            CLC                       
CODE_00D152:        69 0B         ADC.B #$0B                
CODE_00D154:        80 DA         BRA CODE_00D130           

CODE_00D156:        E6 19         INC RAM_MarioPowerUp      
CODE_00D158:        A9 00         LDA.B #$00                
CODE_00D15A:        85 71         STA RAM_MarioAnimation    
CODE_00D15C:        64 9D         STZ RAM_SpritesLocked     
Return00D15E:       60            RTS                       ; Return 

CapeAni:            A9 7F         LDA.B #$7F                
CODE_00D161:        85 78         STA $78                   
CODE_00D163:        CE 96 14      DEC.W $1496               
CODE_00D166:        D0 F6         BNE Return00D15E          
CODE_00D168:        A5 19         LDA RAM_MarioPowerUp      
CODE_00D16A:        4A            LSR                       
CODE_00D16B:        F0 D3         BEQ CODE_00D140           
CODE_00D16D:        D0 E9         BNE CODE_00D158           
FlowerAni:          AD ED 13      LDA.W $13ED               
CODE_00D172:        29 80         AND.B #$80                
CODE_00D174:        0D 07 14      ORA.W $1407               
CODE_00D177:        F0 0E         BEQ CODE_00D187           
ADDR_00D179:        9C 07 14      STZ.W $1407               
ADDR_00D17C:        AD ED 13      LDA.W $13ED               
ADDR_00D17F:        29 7F         AND.B #$7F                
ADDR_00D181:        8D ED 13      STA.W $13ED               
ADDR_00D184:        9C E0 13      STZ.W MarioFrame          
CODE_00D187:        CE 9B 14      DEC.W RAM_FlashingPalTimer 
CODE_00D18A:        F0 CC         BEQ CODE_00D158           
Return00D18C:       60            RTS                       ; Return 


PipeSpeedX:                       .db $F8,$08

PipeSpeedY:                       .db $00,$00,$F0

DATA_00D192:                      .db $10

DATA_00D193:                      .db $00,$63,$1C,$00

DoorPipeAni:        20 2D F6      JSR.W NoButtons           
CODE_00D19A:        9C DE 13      STZ.W $13DE               
CODE_00D19D:        22 B1 CE 00   JSL.L CODE_00CEB1         
CODE_00D1A1:        22 BC CF 00   JSL.L CODE_00CFBC         
CODE_00D1A5:        20 F4 D1      JSR.W CODE_00D1F4         
CODE_00D1A8:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_00D1AB:        F0 05         BEQ CODE_00D1B2           
CODE_00D1AD:        A9 29         LDA.B #$29                ; \ Mario's image = Entering horizontal pipe on Yoshi 
CODE_00D1AF:        8D E0 13      STA.W MarioFrame          ; / 
CODE_00D1B2:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00D1B4:        A5 96         LDA RAM_MarioYPos         
CODE_00D1B6:        38            SEC                       
CODE_00D1B7:        E9 08 00      SBC.W #$0008              
CODE_00D1BA:        29 F0 FF      AND.W #$FFF0              
CODE_00D1BD:        09 0E 00      ORA.W #$000E              
CODE_00D1C0:        85 96         STA RAM_MarioYPos         
CODE_00D1C2:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00D1C4:        A5 89         LDA $89                   
CODE_00D1C6:        4A            LSR                       
CODE_00D1C7:        A8            TAY                       
CODE_00D1C8:        C8            INY                       
CODE_00D1C9:        B9 92 D1      LDA.W DATA_00D192,Y       
CODE_00D1CC:        AE 8F 14      LDX.W $148F               
CODE_00D1CF:        F0 0A         BEQ CODE_00D1DB           
CODE_00D1D1:        49 1C         EOR.B #$1C                
CODE_00D1D3:        CE 99 14      DEC.W RAM_FaceCamImgTimer 
CODE_00D1D6:        10 03         BPL CODE_00D1DB           
CODE_00D1D8:        EE 99 14      INC.W RAM_FaceCamImgTimer 
CODE_00D1DB:        A6 88         LDX $88                   
CODE_00D1DD:        E0 1D         CPX.B #$1D                
CODE_00D1DF:        B0 0F         BCS CODE_00D1F0           
CODE_00D1E1:        C0 03         CPY.B #$03                
CODE_00D1E3:        90 08         BCC CODE_00D1ED           
CODE_00D1E5:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00D1E7:        E6 96         INC RAM_MarioYPos         
CODE_00D1E9:        E6 96         INC RAM_MarioYPos         
CODE_00D1EB:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00D1ED:        B9 93 D1      LDA.W DATA_00D193,Y       
CODE_00D1F0:        85 78         STA $78                   
CODE_00D1F2:        80 39         BRA CODE_00D22D           

CODE_00D1F4:        AD A2 14      LDA.W $14A2               
CODE_00D1F7:        F0 03         BEQ CODE_00D1FC           
CODE_00D1F9:        CE A2 14      DEC.W $14A2               
CODE_00D1FC:        4C 37 D1      JMP.W CODE_00D137         


PipeCntrBoundryX:                 .db $0A,$06

PipeCntringSpeed:                 .db $FF,$01

VertPipeAni:        20 2D F6      JSR.W NoButtons           
CODE_00D206:        9C DF 13      STZ.W $13DF               
CODE_00D209:        A9 0F         LDA.B #$0F                
CODE_00D20B:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_00D20E:        F0 1A         BEQ CODE_00D22A           
CODE_00D210:        A2 00         LDX.B #$00                
CODE_00D212:        A4 76         LDY RAM_MarioDirection    ; \ 
CODE_00D214:        A5 94         LDA RAM_MarioXPos         ;  | If not relativly centered on the pipe... 
CODE_00D216:        29 0F         AND.B #$0F                ;  | 
CODE_00D218:        D9 FF D1      CMP.W PipeCntrBoundryX,Y  ;  | 
CODE_00D21B:        F0 0B         BEQ CODE_00D228           ;  | 
CODE_00D21D:        10 01         BPL CODE_00D220           ;  | 
CODE_00D21F:        E8            INX                       ;  | 
CODE_00D220:        A5 94         LDA RAM_MarioXPos         ;  | ...adjust Mario's X postion 
CODE_00D222:        18            CLC                       ;  | 
CODE_00D223:        7D 01 D2      ADC.W PipeCntringSpeed,X  ;  | 
CODE_00D226:        85 94         STA RAM_MarioXPos         ; / 
CODE_00D228:        A9 21         LDA.B #$21                ; \ Mario's image = going down pipe 
CODE_00D22A:        8D E0 13      STA.W MarioFrame          ; / 
CODE_00D22D:        A9 40         LDA.B #$40                ; \ Set holding X/Y on controller 
CODE_00D22F:        85 15         STA RAM_ControllerA       ; / 
CODE_00D231:        A9 02         LDA.B #$02                ; \ Set behind scenery flag 
CODE_00D233:        8D F9 13      STA.W RAM_IsBehindScenery ; / 
CODE_00D236:        A5 89         LDA $89                   
CODE_00D238:        C9 04         CMP.B #$04                
CODE_00D23A:        A4 88         LDY $88                   
CODE_00D23C:        F0 2A         BEQ CODE_00D268           
CODE_00D23E:        29 03         AND.B #$03                
CODE_00D240:        A8            TAY                       
CODE_00D241:        C6 88         DEC $88                   
CODE_00D243:        D0 09         BNE CODE_00D24E           
CODE_00D245:        B0 07         BCS CODE_00D24E           
CODE_00D247:        A9 7F         LDA.B #$7F                
CODE_00D249:        85 78         STA $78                   
CODE_00D24B:        EE 05 14      INC.W $1405               
CODE_00D24E:        A5 7B         LDA RAM_MarioSpeedX       ; \ If Mario has no speed... 
CODE_00D250:        05 7D         ORA RAM_MarioSpeedY       ;  | 
CODE_00D252:        D0 05         BNE CODE_00D259           ;  | 
CODE_00D254:        A9 04         LDA.B #$04                ;  | ...play sound effect 
CODE_00D256:        8D F9 1D      STA.W $1DF9               ; / 
CODE_00D259:        B9 8D D1      LDA.W PipeSpeedX,Y        ; \ Set X speed 
CODE_00D25C:        85 7B         STA RAM_MarioSpeedX       ; / 
CODE_00D25E:        B9 8F D1      LDA.W PipeSpeedY,Y        ; \ Set Y speed 
CODE_00D261:        85 7D         STA RAM_MarioSpeedY       ; / 
CODE_00D263:        64 72         STZ RAM_IsFlying          ; Mario flying = false 
CODE_00D265:        4C 2D DC      JMP.W CODE_00DC2D         

CODE_00D268:        90 09         BCC CODE_00D273           
CODE_00D26A:        9C F9 13      STZ.W RAM_IsBehindScenery ; \ In new level, reset values 
CODE_00D26D:        9C 19 14      STZ.W RAM_YoshiInPipe     ; / 
CODE_00D270:        4C 58 D1      JMP.W CODE_00D158         

CODE_00D273:        EE 1A 14      INC.W $141A               
CODE_00D276:        A9 0F         LDA.B #$0F                
CODE_00D278:        8D 00 01      STA.W RAM_GameMode        
Return00D27B:       60            RTS                       ; Return 

ADDR_00D27C:        A5 96         LDA RAM_MarioYPos         ; \ Unreachable 
ADDR_00D27E:        38            SEC                       ;  | 
ADDR_00D27F:        E5 D3         SBC $D3                   ;  | 
ADDR_00D281:        18            CLC                       ;  | 
ADDR_00D282:        65 88         ADC $88                   ;  | 
ADDR_00D284:        85 88         STA $88                   ;  | 
Return00D286:       60            RTS                       ; / Return 

PipeCannonAni:      20 2D F6      JSR.W NoButtons           
CODE_00D28A:        A9 02         LDA.B #$02                
CODE_00D28C:        8D F9 13      STA.W RAM_IsBehindScenery 
CODE_00D28F:        A9 0C         LDA.B #$0C                
CODE_00D291:        85 72         STA RAM_IsFlying          
CODE_00D293:        20 8B CD      JSR.W CODE_00CD8B         
CODE_00D296:        C6 88         DEC $88                   
CODE_00D298:        D0 03         BNE CODE_00D29D           
CODE_00D29A:        4C 6A D2      JMP.W CODE_00D26A         

CODE_00D29D:        A5 88         LDA $88                   
CODE_00D29F:        C9 18         CMP.B #$18                
CODE_00D2A1:        90 07         BCC CODE_00D2AA           
CODE_00D2A3:        D0 0D         BNE CODE_00D2B2           
CODE_00D2A5:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_00D2A7:        8D FC 1D      STA.W $1DFC               ; / 
CODE_00D2AA:        9C F9 13      STZ.W RAM_IsBehindScenery 
CODE_00D2AD:        9C 19 14      STZ.W RAM_YoshiInPipe     
CODE_00D2B0:        64 9D         STZ RAM_SpritesLocked     ; Set sprites not locked 
CODE_00D2B2:        A9 40         LDA.B #$40                ; \ X speed = #$40 
CODE_00D2B4:        85 7B         STA RAM_MarioSpeedX       ; / 
CODE_00D2B6:        A9 C0         LDA.B #$C0                ; \ Y speed = #$C0 
CODE_00D2B8:        85 7D         STA RAM_MarioSpeedY       ; / 
CODE_00D2BA:        4C 2D DC      JMP.W CODE_00DC2D         


DATA_00D2BD:                      .db $B0,$B6,$AE,$B4,$AB,$B2,$A9,$B0
                                  .db $A6,$AE,$A4,$AB,$A1,$A9,$9F,$A6
DATA_00D2CD:                      .db $00,$FF,$00,$01,$00,$FF,$00,$01
                                  .db $00,$FF,$00,$01,$80,$FE,$C0,$00
                                  .db $40,$FF,$80,$01,$00,$FE,$40,$00
                                  .db $C0,$FF,$00,$02,$00,$FE,$40,$00
                                  .db $00,$FE,$40,$00,$C0,$FF,$00,$02
                                  .db $C0,$FF,$00,$02,$00,$FC,$00,$FF
                                  .db $00,$01,$00,$04,$00,$FF,$00,$01
                                  .db $00,$FF,$00,$01

DATA_00D309:                      .db $E0,$FF,$20,$00,$E0,$FF,$20,$00
                                  .db $E0,$FF,$20,$00,$C0,$FF,$20,$00
                                  .db $E0,$FF,$40,$00,$80,$FF,$20,$00
                                  .db $E0,$FF,$80,$00,$80,$FF,$20,$00
                                  .db $80,$FF,$20,$00,$E0,$FF,$80,$00
                                  .db $E0,$FF,$80,$00,$00,$FE,$80,$FF
                                  .db $80,$00,$00,$02,$00,$FF,$00,$01
                                  .db $00,$FF,$00,$01

MarioAccel?:                      .db $80

MarioAccel2?:                     .db $FE,$80,$FE,$80,$01,$80,$01,$80
                                  .db $FE,$80,$FE,$80,$01,$80,$01,$80
                                  .db $FE,$80,$FE,$80,$01,$80,$01,$80
                                  .db $FE,$80,$FE,$40,$01,$40,$01,$C0
                                  .db $FE,$C0,$FE,$80,$01,$80,$01,$80
                                  .db $FE,$80,$FE,$00,$01,$00,$01,$00
                                  .db $FF,$00,$FF,$80,$01,$80,$01,$80
                                  .db $FE,$80,$FE,$00,$01,$00,$01,$80
                                  .db $FE,$80,$FE,$00,$01,$00,$01,$00
                                  .db $FF,$00,$FF,$80,$01,$80,$01,$00
                                  .db $FF,$00,$FF,$80,$01,$80,$01,$00
                                  .db $FC,$00,$FC,$00,$FD,$00,$FD,$00
                                  .db $03,$00,$03,$00,$04,$00,$04,$00
                                  .db $FC,$00,$FC,$00,$06,$00,$06,$00
                                  .db $FA,$00,$FA,$00,$04,$00,$04,$80
                                  .db $FF,$80,$00,$00,$FF,$00,$01,$80
                                  .db $FE,$80,$01,$80,$FE,$80,$FE,$80
                                  .db $01,$80,$01,$80,$FE,$80,$02,$80
                                  .db $FD,$00,$FB,$80,$02,$00,$05,$80
                                  .db $FD,$00,$FB,$80,$02,$00,$05,$80
                                  .db $FD,$00,$FB,$80,$02,$00,$05,$40
                                  .db $FD,$80,$FA,$40,$02,$80,$04,$C0
                                  .db $FD,$80,$FB,$C0,$02,$80,$05,$00
                                  .db $FD,$00,$FA,$00,$02,$00,$04,$00
                                  .db $FE,$00,$FC,$00,$03,$00,$06,$00
                                  .db $FD,$00,$FA,$00,$02,$00,$04,$00
                                  .db $FD,$00,$FA,$00,$02,$00,$04,$00
                                  .db $FE,$00,$FC,$00,$03,$00,$06,$00
                                  .db $FE,$00,$FC,$00,$03,$00,$06,$00
                                  .db $FD,$00,$FA,$00,$FD,$00,$FA,$00
                                  .db $03,$00,$06,$00,$03,$00,$06

DATA_00D43D:                      .db $80,$FF,$80,$FE,$80,$00,$80,$01
                                  .db $80,$FF,$80,$FE,$80,$00,$80,$01
                                  .db $80,$FF,$80,$FE,$80,$00,$80,$01
                                  .db $80,$FE,$80,$FE,$80,$00,$40,$01
                                  .db $80,$FF,$C0,$FE,$80,$01,$80,$01
                                  .db $80,$FE,$80,$FE,$80,$00,$00,$01
                                  .db $80,$FF,$00,$FF,$80,$01,$80,$01
                                  .db $80,$FE,$80,$FE,$80,$00,$00,$01
                                  .db $80,$FE,$80,$FE,$80,$00,$00,$01
                                  .db $80,$FF,$00,$FF,$80,$01,$80,$01
                                  .db $80,$FF,$00,$FF,$80,$01,$80,$01
                                  .db $00,$FC,$00,$FC,$00,$FE,$00,$FD
                                  .db $00,$03,$00,$03,$00,$04,$00,$04
                                  .db $00,$FC,$00,$FC,$80,$00,$80,$00
                                  .db $80,$FF,$80,$FF,$00,$04,$00,$04
                                  .db $80,$FF,$80,$00,$00,$FF,$00,$01
                                  .db $80,$FE,$80,$01,$80,$FE,$80,$FE
                                  .db $80,$01,$80,$01,$80,$FE,$80,$02
                                  .db $C0,$FF,$80,$FD,$40,$00,$80,$02
                                  .db $C0,$FF,$80,$FD,$40,$00,$80,$02
                                  .db $C0,$FF,$80,$FD,$40,$00,$80,$02
                                  .db $80,$FF,$40,$FD,$40,$00,$40,$02
                                  .db $C0,$FF,$C0,$FD,$80,$00,$C0,$02
                                  .db $00,$FD,$00,$FD,$40,$00,$00,$02
                                  .db $C0,$FF,$00,$FE,$00,$03,$00,$03
                                  .db $00,$FD,$00,$FD,$40,$00,$00,$02
                                  .db $00,$FD,$00,$FD,$40,$00,$00,$02
                                  .db $C0,$FF,$00,$FE,$00,$03,$00,$03
                                  .db $C0,$FF,$00,$FE,$00,$03,$00,$03
                                  .db $00,$FD,$00,$FD,$00,$FD,$00,$FD
                                  .db $00,$03,$00,$03,$00,$03,$00,$03
DATA_00D535:                      .db $EC,$14,$DC,$24,$DC,$24,$D0,$30
                                  .db $EC,$14,$DC,$24,$DC,$24,$D0,$30
                                  .db $EC,$14,$DC,$24,$DC,$24,$D0,$30
                                  .db $E8,$12,$DC,$20,$DC,$20,$D0,$2C
                                  .db $EE,$18,$E0,$24,$E0,$24,$D4,$30
                                  .db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28
                                  .db $F0,$24,$E4,$24,$E4,$24,$D8,$30
                                  .db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28
                                  .db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28
                                  .db $F0,$24,$E4,$24,$E4,$24,$D8,$30
                                  .db $F0,$24,$E4,$24,$E4,$24,$D8,$30
                                  .db $DC,$F0,$DC,$F8,$DC,$F8,$D0,$FC
                                  .db $10,$24,$08,$24,$08,$24,$04,$30
                                  .db $D0,$08,$D0,$08,$D0,$08,$D0,$08
                                  .db $F8,$30,$F8,$30,$F8,$30,$F8,$30
                                  .db $F8,$08,$F0,$10,$F4,$04,$E8,$08
                                  .db $F0,$10,$E0,$20,$EC,$0C,$D8,$18
                                  .db $D8,$28,$D4,$2C,$D0,$30,$D0,$D0
                                  .db $30,$30,$E0,$20

DATA_00D5C9:                      .db $00

DATA_00D5CA:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$F0,$00,$10,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$E0,$00
                                  .db $20,$00,$00,$00,$00,$00,$F0,$00
                                  .db $F8

DATA_00D5EB:                      .db $FF,$FF,$02

DATA_00D5EE:                      .db $68,$70

DATA_00D5F0:                      .db $1C,$0C

CODE_00D5F2:        A5 72         LDA RAM_IsFlying          
CODE_00D5F4:        F0 03         BEQ CODE_00D5F9           
CODE_00D5F6:        4C 82 D6      JMP.W CODE_00D682         

CODE_00D5F9:        64 73         STZ RAM_IsDucking         
CODE_00D5FB:        AD ED 13      LDA.W $13ED               
CODE_00D5FE:        D0 0B         BNE CODE_00D60B           
CODE_00D600:        A5 15         LDA RAM_ControllerA       
CODE_00D602:        29 04         AND.B #$04                
CODE_00D604:        F0 05         BEQ CODE_00D60B           
CODE_00D606:        85 73         STA RAM_IsDucking         
CODE_00D608:        9C E8 13      STZ.W $13E8               
CODE_00D60B:        AD 71 14      LDA.W $1471               
CODE_00D60E:        C9 02         CMP.B #$02                
CODE_00D610:        F0 0C         BEQ CODE_00D61E           
CODE_00D612:        A5 77         LDA RAM_MarioObjStatus    
CODE_00D614:        29 08         AND.B #$08                
CODE_00D616:        D0 06         BNE CODE_00D61E           
CODE_00D618:        A5 16         LDA $16                   
CODE_00D61A:        05 18         ORA $18                   
CODE_00D61C:        30 12         BMI CODE_00D630           
CODE_00D61E:        A5 73         LDA RAM_IsDucking         
CODE_00D620:        F0 60         BEQ CODE_00D682           
CODE_00D622:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00D624:        F0 07         BEQ CODE_00D62D           
CODE_00D626:        A5 86         LDA $86                   
CODE_00D628:        D0 03         BNE CODE_00D62D           
CODE_00D62A:        20 4A FE      JSR.W CODE_00FE4A         
CODE_00D62D:        4C 64 D7      JMP.W CODE_00D764         

CODE_00D630:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00D632:        10 03         BPL CODE_00D637           
CODE_00D634:        49 FF         EOR.B #$FF                
CODE_00D636:        1A            INC A                     
CODE_00D637:        4A            LSR                       
CODE_00D638:        4A            LSR                       
CODE_00D639:        29 FE         AND.B #$FE                
CODE_00D63B:        AA            TAX                       
CODE_00D63C:        A5 18         LDA $18                   
CODE_00D63E:        10 1E         BPL CODE_00D65E           
CODE_00D640:        AD 8F 14      LDA.W $148F               
CODE_00D643:        D0 19         BNE CODE_00D65E           
CODE_00D645:        1A            INC A                     
CODE_00D646:        8D 0D 14      STA.W RAM_IsSpinJump      
CODE_00D649:        A9 04         LDA.B #$04                ; \ Play sound effect 
CODE_00D64B:        8D FC 1D      STA.W $1DFC               ; / 
CODE_00D64E:        A4 76         LDY RAM_MarioDirection    
CODE_00D650:        B9 F0 D5      LDA.W DATA_00D5F0,Y       
CODE_00D653:        8D E2 13      STA.W $13E2               
CODE_00D656:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_00D659:        D0 27         BNE CODE_00D682           
CODE_00D65B:        E8            INX                       
CODE_00D65C:        80 05         BRA CODE_00D663           

CODE_00D65E:        A9 01         LDA.B #$01                ; \ Play sound effect 
CODE_00D660:        8D FA 1D      STA.W $1DFA               ; / 
CODE_00D663:        BD BD D2      LDA.W DATA_00D2BD,X       
CODE_00D666:        85 7D         STA RAM_MarioSpeedY       
CODE_00D668:        A9 0B         LDA.B #$0B                
CODE_00D66A:        AC E4 13      LDY.W $13E4               
CODE_00D66D:        C0 70         CPY.B #$70                
CODE_00D66F:        90 0C         BCC CODE_00D67D           
CODE_00D671:        AD 9F 14      LDA.W $149F               
CODE_00D674:        D0 05         BNE CODE_00D67B           
CODE_00D676:        A9 50         LDA.B #$50                
CODE_00D678:        8D 9F 14      STA.W $149F               
CODE_00D67B:        A9 0C         LDA.B #$0C                
CODE_00D67D:        85 72         STA RAM_IsFlying          
CODE_00D67F:        9C ED 13      STZ.W $13ED               
CODE_00D682:        AD ED 13      LDA.W $13ED               
CODE_00D685:        30 0B         BMI CODE_00D692           
CODE_00D687:        A5 15         LDA RAM_ControllerA       
CODE_00D689:        29 03         AND.B #$03                
CODE_00D68B:        D0 24         BNE CODE_00D6B1           
CODE_00D68D:        AD ED 13      LDA.W $13ED               
CODE_00D690:        F0 1C         BEQ CODE_00D6AE           
CODE_00D692:        20 4A FE      JSR.W CODE_00FE4A         
CODE_00D695:        AD EE 13      LDA.W $13EE               
CODE_00D698:        F0 14         BEQ CODE_00D6AE           
CODE_00D69A:        20 68 D9      JSR.W CODE_00D968         
CODE_00D69D:        AD E1 13      LDA.W $13E1               
CODE_00D6A0:        4A            LSR                       
CODE_00D6A1:        4A            LSR                       
CODE_00D6A2:        A8            TAY                       
CODE_00D6A3:        69 76         ADC.B #$76                
CODE_00D6A5:        AA            TAX                       
CODE_00D6A6:        98            TYA                       
CODE_00D6A7:        4A            LSR                       
CODE_00D6A8:        69 87         ADC.B #$87                
CODE_00D6AA:        A8            TAY                       
CODE_00D6AB:        4C 42 D7      JMP.W CODE_00D742         

CODE_00D6AE:        4C 64 D7      JMP.W CODE_00D764         

CODE_00D6B1:        9C ED 13      STZ.W $13ED               
CODE_00D6B4:        29 01         AND.B #$01                
CODE_00D6B6:        AC 07 14      LDY.W $1407               
CODE_00D6B9:        F0 1A         BEQ CODE_00D6D5           
CODE_00D6BB:        C5 76         CMP RAM_MarioDirection    
CODE_00D6BD:        F0 04         BEQ CODE_00D6C3           
CODE_00D6BF:        A4 16         LDY $16                   
CODE_00D6C1:        10 CA         BPL CODE_00D68D           
CODE_00D6C3:        A6 76         LDX RAM_MarioDirection    
CODE_00D6C5:        BC EE D5      LDY.W DATA_00D5EE,X       
CODE_00D6C8:        8C E1 13      STY.W $13E1               
CODE_00D6CB:        85 01         STA $01                   
CODE_00D6CD:        0A            ASL                       
CODE_00D6CE:        0A            ASL                       
CODE_00D6CF:        0D E1 13      ORA.W $13E1               
CODE_00D6D2:        AA            TAX                       
CODE_00D6D3:        80 3E         BRA CODE_00D713           

CODE_00D6D5:        A4 76         LDY RAM_MarioDirection    
CODE_00D6D7:        C5 76         CMP RAM_MarioDirection    
CODE_00D6D9:        F0 11         BEQ CODE_00D6EC           
CODE_00D6DB:        AC 8F 14      LDY.W $148F               
CODE_00D6DE:        F0 0A         BEQ CODE_00D6EA           
CODE_00D6E0:        AC 99 14      LDY.W RAM_FaceCamImgTimer 
CODE_00D6E3:        D0 07         BNE CODE_00D6EC           
CODE_00D6E5:        A0 08         LDY.B #$08                
CODE_00D6E7:        8C 99 14      STY.W RAM_FaceCamImgTimer 
CODE_00D6EA:        85 76         STA RAM_MarioDirection    
CODE_00D6EC:        85 01         STA $01                   
CODE_00D6EE:        0A            ASL                       
CODE_00D6EF:        0A            ASL                       
CODE_00D6F0:        0D E1 13      ORA.W $13E1               
CODE_00D6F3:        AA            TAX                       
CODE_00D6F4:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00D6F6:        F0 1B         BEQ CODE_00D713           
CODE_00D6F8:        5D 46 D3      EOR.W MarioAccel2?,X      
CODE_00D6FB:        10 16         BPL CODE_00D713           
CODE_00D6FD:        AD A1 14      LDA.W $14A1               
CODE_00D700:        D0 11         BNE CODE_00D713           
CODE_00D702:        A5 86         LDA $86                   
CODE_00D704:        D0 08         BNE CODE_00D70E           
CODE_00D706:        A9 0D         LDA.B #$0D                
CODE_00D708:        8D DD 13      STA.W RAM_ChangingDir     
CODE_00D70B:        20 4A FE      JSR.W CODE_00FE4A         
CODE_00D70E:        8A            TXA                       
CODE_00D70F:        18            CLC                       
CODE_00D710:        69 90         ADC.B #$90                
CODE_00D712:        AA            TAX                       
CODE_00D713:        A0 00         LDY.B #$00                
CODE_00D715:        24 15         BIT RAM_ControllerA       
CODE_00D717:        50 1E         BVC CODE_00D737           
CODE_00D719:        E8            INX                       
CODE_00D71A:        E8            INX                       
CODE_00D71B:        C8            INY                       
CODE_00D71C:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00D71E:        10 03         BPL CODE_00D723           
CODE_00D720:        49 FF         EOR.B #$FF                
CODE_00D722:        1A            INC A                     
CODE_00D723:        C9 23         CMP.B #$23                
CODE_00D725:        30 10         BMI CODE_00D737           
CODE_00D727:        A5 72         LDA RAM_IsFlying          
CODE_00D729:        D0 07         BNE CODE_00D732           
CODE_00D72B:        A9 10         LDA.B #$10                
CODE_00D72D:        8D A0 14      STA.W $14A0               
CODE_00D730:        80 04         BRA CODE_00D736           

CODE_00D732:        C9 0C         CMP.B #$0C                
CODE_00D734:        D0 01         BNE CODE_00D737           
CODE_00D736:        C8            INY                       
CODE_00D737:        20 6A D9      JSR.W CODE_00D96A         
CODE_00D73A:        98            TYA                       
CODE_00D73B:        0A            ASL                       
CODE_00D73C:        0D E1 13      ORA.W $13E1               
CODE_00D73F:        05 01         ORA $01                   
CODE_00D741:        A8            TAY                       
CODE_00D742:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00D744:        38            SEC                       
CODE_00D745:        F9 35 D5      SBC.W DATA_00D535,Y       
CODE_00D748:        F0 21         BEQ CODE_00D76B           
CODE_00D74A:        59 35 D5      EOR.W DATA_00D535,Y       
CODE_00D74D:        10 1C         BPL CODE_00D76B           
CODE_00D74F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00D751:        BD 45 D3      LDA.W MarioAccel?,X       
CODE_00D754:        A4 86         LDY $86                   
CODE_00D756:        F0 07         BEQ CODE_00D75F           
CODE_00D758:        A4 72         LDY RAM_IsFlying          
CODE_00D75A:        D0 03         BNE CODE_00D75F           
CODE_00D75C:        BD 3D D4      LDA.W DATA_00D43D,X       
CODE_00D75F:        18            CLC                       
CODE_00D760:        65 7A         ADC $7A                   
CODE_00D762:        80 3C         BRA CODE_00D7A0           

CODE_00D764:        20 68 D9      JSR.W CODE_00D968         
CODE_00D767:        A5 72         LDA RAM_IsFlying          
CODE_00D769:        D0 39         BNE Return00D7A4          
CODE_00D76B:        AD E1 13      LDA.W $13E1               
CODE_00D76E:        4A            LSR                       
CODE_00D76F:        A8            TAY                       
CODE_00D770:        4A            LSR                       
CODE_00D771:        AA            TAX                       
CODE_00D772:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00D774:        38            SEC                       
CODE_00D775:        FD CA D5      SBC.W DATA_00D5CA,X       
CODE_00D778:        10 02         BPL CODE_00D77C           
CODE_00D77A:        C8            INY                       
CODE_00D77B:        C8            INY                       
CODE_00D77C:        AD 93 14      LDA.W $1493               
CODE_00D77F:        05 72         ORA RAM_IsFlying          
CODE_00D781:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00D783:        D0 07         BNE CODE_00D78C           
CODE_00D785:        B9 09 D3      LDA.W DATA_00D309,Y       
CODE_00D788:        24 85         BIT RAM_IsWaterLevel      
CODE_00D78A:        30 03         BMI CODE_00D78F           
CODE_00D78C:        B9 CD D2      LDA.W DATA_00D2CD,Y       
CODE_00D78F:        18            CLC                       
CODE_00D790:        65 7A         ADC $7A                   
CODE_00D792:        85 7A         STA $7A                   
CODE_00D794:        38            SEC                       
CODE_00D795:        FD C9 D5      SBC.W DATA_00D5C9,X       
CODE_00D798:        59 CD D2      EOR.W DATA_00D2CD,Y       
CODE_00D79B:        30 05         BMI CODE_00D7A2           
CODE_00D79D:        BD C9 D5      LDA.W DATA_00D5C9,X       
CODE_00D7A0:        85 7A         STA $7A                   
CODE_00D7A2:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return00D7A4:       60            RTS                       ; Return 


DATA_00D7A5:                      .db $06,$03,$04,$10,$F4,$01,$03,$04
                                  .db $05,$06

DATA_00D7AF:                      .db $40,$40,$20,$40,$40,$40,$40,$40
                                  .db $40,$40

DATA_00D7B9:                      .db $10,$C8,$E0,$02,$03,$03,$04,$03
                                  .db $02,$00,$01,$00,$00,$00,$00

DATA_00D7C8:                      .db $01,$10,$30,$30,$38,$38,$40

CapeSpeed:                        .db $FF,$01,$01,$FF,$FF

DATA_00D7D4:                      .db $01,$06,$03,$01,$00

DATA_00D7D9:                      .db $00,$00,$00,$F8,$F8,$F8,$F4,$F0
                                  .db $C8,$02,$01

CODE_00D7E4:        AC 07 14      LDY.W $1407               
CODE_00D7E7:        D0 3B         BNE CODE_00D824           
CODE_00D7E9:        A5 72         LDA RAM_IsFlying          
CODE_00D7EB:        F0 24         BEQ CODE_00D811           
CODE_00D7ED:        AD 8F 14      LDA.W $148F               
CODE_00D7F0:        0D 7A 18      ORA.W RAM_OnYoshi         
CODE_00D7F3:        0D 0D 14      ORA.W RAM_IsSpinJump      
CODE_00D7F6:        D0 19         BNE CODE_00D811           
CODE_00D7F8:        AD ED 13      LDA.W $13ED               
CODE_00D7FB:        30 02         BMI CODE_00D7FF           
CODE_00D7FD:        D0 12         BNE CODE_00D811           
CODE_00D7FF:        9C ED 13      STZ.W $13ED               
CODE_00D802:        A6 19         LDX RAM_MarioPowerUp      
CODE_00D804:        E0 02         CPX.B #$02                
CODE_00D806:        D0 09         BNE CODE_00D811           
CODE_00D808:        A5 7D         LDA RAM_MarioSpeedY       
CODE_00D80A:        30 05         BMI CODE_00D811           
CODE_00D80C:        AD 9F 14      LDA.W $149F               
CODE_00D80F:        D0 03         BNE CODE_00D814           
CODE_00D811:        4C CD D8      JMP.W CODE_00D8CD         

CODE_00D814:        64 73         STZ RAM_IsDucking         
CODE_00D816:        A9 0B         LDA.B #$0B                
CODE_00D818:        85 72         STA RAM_IsFlying          
CODE_00D81A:        9C 09 14      STZ.W $1409               
CODE_00D81D:        20 4F D9      JSR.W CODE_00D94F         
CODE_00D820:        A2 02         LDX.B #$02                
CODE_00D822:        80 37         BRA CODE_00D85B           

CODE_00D824:        C0 02         CPY.B #$02                
CODE_00D826:        90 03         BCC CODE_00D82B           
CODE_00D828:        20 4F D9      JSR.W CODE_00D94F         
CODE_00D82B:        AE 08 14      LDX.W $1408               
CODE_00D82E:        E0 04         CPX.B #$04                
CODE_00D830:        F0 24         BEQ CODE_00D856           
CODE_00D832:        A2 03         LDX.B #$03                
CODE_00D834:        A4 7D         LDY RAM_MarioSpeedY       
CODE_00D836:        30 1E         BMI CODE_00D856           
CODE_00D838:        A5 15         LDA RAM_ControllerA       
CODE_00D83A:        29 03         AND.B #$03                
CODE_00D83C:        A8            TAY                       
CODE_00D83D:        D0 0A         BNE CODE_00D849           
CODE_00D83F:        AD 07 14      LDA.W $1407               
CODE_00D842:        C9 04         CMP.B #$04                
CODE_00D844:        B0 10         BCS CODE_00D856           
CODE_00D846:        CA            DEX                       
CODE_00D847:        80 0D         BRA CODE_00D856           

CODE_00D849:        4A            LSR                       
CODE_00D84A:        A4 76         LDY RAM_MarioDirection    
CODE_00D84C:        F0 02         BEQ CODE_00D850           
CODE_00D84E:        49 01         EOR.B #$01                
CODE_00D850:        AA            TAX                       
CODE_00D851:        EC 08 14      CPX.W $1408               
CODE_00D854:        D0 05         BNE CODE_00D85B           
CODE_00D856:        AD A4 14      LDA.W $14A4               
CODE_00D859:        D0 23         BNE CODE_00D87E           
CODE_00D85B:        24 15         BIT RAM_ControllerA       
CODE_00D85D:        70 02         BVS CODE_00D861           
CODE_00D85F:        A2 04         LDX.B #$04                
CODE_00D861:        AD 07 14      LDA.W $1407               
CODE_00D864:        DD D4 D7      CMP.W DATA_00D7D4,X       
CODE_00D867:        F0 15         BEQ CODE_00D87E           
CODE_00D869:        18            CLC                       
CODE_00D86A:        7D CF D7      ADC.W CapeSpeed,X         
CODE_00D86D:        8D 07 14      STA.W $1407               
CODE_00D870:        A9 08         LDA.B #$08                
CODE_00D872:        AC 09 14      LDY.W $1409               
CODE_00D875:        C0 C8         CPY.B #$C8                
CODE_00D877:        D0 02         BNE CODE_00D87B           
CODE_00D879:        A9 02         LDA.B #$02                
CODE_00D87B:        8D A4 14      STA.W $14A4               
CODE_00D87E:        8E 08 14      STX.W $1408               
CODE_00D881:        AC 07 14      LDY.W $1407               
CODE_00D884:        F0 47         BEQ CODE_00D8CD           
CODE_00D886:        A5 7D         LDA RAM_MarioSpeedY       
CODE_00D888:        10 08         BPL CODE_00D892           
CODE_00D88A:        C9 C8         CMP.B #$C8                
CODE_00D88C:        B0 0C         BCS CODE_00D89A           
CODE_00D88E:        A9 C8         LDA.B #$C8                
CODE_00D890:        80 08         BRA CODE_00D89A           

CODE_00D892:        D9 C8 D7      CMP.W DATA_00D7C8,Y       
CODE_00D895:        90 03         BCC CODE_00D89A           
CODE_00D897:        B9 C8 D7      LDA.W DATA_00D7C8,Y       
CODE_00D89A:        48            PHA                       
CODE_00D89B:        C0 01         CPY.B #$01                
CODE_00D89D:        D0 27         BNE CODE_00D8C6           
CODE_00D89F:        AE 09 14      LDX.W $1409               
CODE_00D8A2:        F0 20         BEQ CODE_00D8C4           
CODE_00D8A4:        A5 7D         LDA RAM_MarioSpeedY       
CODE_00D8A6:        30 07         BMI CODE_00D8AF           
CODE_00D8A8:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_00D8AA:        8D F9 1D      STA.W $1DF9               ; / 
CODE_00D8AD:        80 0A         BRA CODE_00D8B9           

CODE_00D8AF:        CD 09 14      CMP.W $1409               
CODE_00D8B2:        B0 05         BCS CODE_00D8B9           
CODE_00D8B4:        86 7D         STX RAM_MarioSpeedY       
CODE_00D8B6:        9C 09 14      STZ.W $1409               
CODE_00D8B9:        A6 76         LDX RAM_MarioDirection    
CODE_00D8BB:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00D8BD:        F0 05         BEQ CODE_00D8C4           
CODE_00D8BF:        5D 35 D5      EOR.W DATA_00D535,X       
CODE_00D8C2:        10 02         BPL CODE_00D8C6           
CODE_00D8C4:        A0 02         LDY.B #$02                
CODE_00D8C6:        68            PLA                       
CODE_00D8C7:        C8            INY                       
CODE_00D8C8:        C8            INY                       
CODE_00D8C9:        C8            INY                       
CODE_00D8CA:        4C 48 D9      JMP.W CODE_00D948         

CODE_00D8CD:        A5 72         LDA RAM_IsFlying          ; \ Branch if not flying 
CODE_00D8CF:        F0 57         BEQ CODE_00D928           ; / 
CODE_00D8D1:        A2 00         LDX.B #$00                ; X = #$00 
CODE_00D8D3:        AD 7A 18      LDA.W RAM_OnYoshi         ; \ Branch if not on Yoshi 
CODE_00D8D6:        F0 0F         BEQ CODE_00D8E7           ; / 
CODE_00D8D8:        AD 1E 14      LDA.W RAM_YoshiHasWings   ; \ Branch if not winged Yoshi 
CODE_00D8DB:        4A            LSR                       ;  | 
CODE_00D8DC:        F0 09         BEQ CODE_00D8E7           ; / 
CODE_00D8DE:        A0 02         LDY.B #$02                ; \ Branch if not Caped Mario 
CODE_00D8E0:        C4 19         CPY RAM_MarioPowerUp      ;  | 
CODE_00D8E2:        F0 01         BEQ CODE_00D8E5           ; / 
CODE_00D8E4:        E8            INX                       ; X= #$01 
CODE_00D8E5:        80 18         BRA CODE_00D8FF           

CODE_00D8E7:        A5 19         LDA RAM_MarioPowerUp      ; \ Branch if not Caped Mario 
CODE_00D8E9:        C9 02         CMP.B #$02                ;  | 
CODE_00D8EB:        D0 3B         BNE CODE_00D928           ; / 
CODE_00D8ED:        A5 72         LDA RAM_IsFlying          ; \ Branch if $72 != 0C 
CODE_00D8EF:        C9 0C         CMP.B #$0C                ;  | 
CODE_00D8F1:        D0 0A         BNE CODE_00D8FD           ; / 
CODE_00D8F3:        A0 01         LDY.B #$01                
CODE_00D8F5:        CC 9F 14      CPY.W $149F               
CODE_00D8F8:        90 05         BCC CODE_00D8FF           
CODE_00D8FA:        EE 9F 14      INC.W $149F               
CODE_00D8FD:        A0 00         LDY.B #$00                
CODE_00D8FF:        AD A5 14      LDA.W $14A5               
CODE_00D902:        D0 09         BNE CODE_00D90D           
CODE_00D904:        B5 15         LDA RAM_ControllerA,X     
CODE_00D906:        10 1C         BPL CODE_00D924           
CODE_00D908:        A9 10         LDA.B #$10                
CODE_00D90A:        8D A5 14      STA.W $14A5               
CODE_00D90D:        A5 7D         LDA RAM_MarioSpeedY       
CODE_00D90F:        10 0A         BPL CODE_00D91B           
CODE_00D911:        BE B9 D7      LDX.W DATA_00D7B9,Y       
CODE_00D914:        10 0E         BPL CODE_00D924           
CODE_00D916:        D9 B9 D7      CMP.W DATA_00D7B9,Y       
CODE_00D919:        90 09         BCC CODE_00D924           
CODE_00D91B:        B9 B9 D7      LDA.W DATA_00D7B9,Y       
CODE_00D91E:        C5 7D         CMP RAM_MarioSpeedY       
CODE_00D920:        F0 2A         BEQ CODE_00D94C           
CODE_00D922:        30 28         BMI CODE_00D94C           
CODE_00D924:        C0 02         CPY.B #$02                
CODE_00D926:        F0 08         BEQ CODE_00D930           
CODE_00D928:        A0 01         LDY.B #$01                
CODE_00D92A:        A5 15         LDA RAM_ControllerA       
CODE_00D92C:        30 02         BMI CODE_00D930           
CODE_00D92E:        A0 00         LDY.B #$00                
CODE_00D930:        A5 7D         LDA RAM_MarioSpeedY       ; \ If Mario's Y speed is negative (up), 
CODE_00D932:        30 14         BMI CODE_00D948           ; / branch to $D948 
CODE_00D934:        D9 AF D7      CMP.W DATA_00D7AF,Y       
CODE_00D937:        90 03         BCC CODE_00D93C           
CODE_00D939:        B9 AF D7      LDA.W DATA_00D7AF,Y       
CODE_00D93C:        A6 72         LDX RAM_IsFlying          
CODE_00D93E:        F0 08         BEQ CODE_00D948           
CODE_00D940:        E0 0B         CPX.B #$0B                
CODE_00D942:        D0 04         BNE CODE_00D948           
CODE_00D944:        A2 24         LDX.B #$24                
CODE_00D946:        86 72         STX RAM_IsFlying          
CODE_00D948:        18            CLC                       
CODE_00D949:        79 A5 D7      ADC.W DATA_00D7A5,Y       
CODE_00D94C:        85 7D         STA RAM_MarioSpeedY       
Return00D94E:       60            RTS                       ; Return 

CODE_00D94F:        9C 0A 14      STZ.W $140A               
CODE_00D952:        A5 7D         LDA RAM_MarioSpeedY       
CODE_00D954:        10 02         BPL CODE_00D958           
CODE_00D956:        A9 00         LDA.B #$00                
CODE_00D958:        4A            LSR                       
CODE_00D959:        4A            LSR                       
CODE_00D95A:        4A            LSR                       
CODE_00D95B:        A8            TAY                       
CODE_00D95C:        B9 D9 D7      LDA.W DATA_00D7D9,Y       
CODE_00D95F:        CD 09 14      CMP.W $1409               
CODE_00D962:        10 03         BPL Return00D967          
CODE_00D964:        8D 09 14      STA.W $1409               
Return00D967:       60            RTS                       ; Return 

CODE_00D968:        A0 00         LDY.B #$00                
CODE_00D96A:        AD E4 13      LDA.W $13E4               
CODE_00D96D:        18            CLC                       
CODE_00D96E:        79 EB D5      ADC.W DATA_00D5EB,Y       
CODE_00D971:        10 02         BPL CODE_00D975           
CODE_00D973:        A9 00         LDA.B #$00                
CODE_00D975:        C9 70         CMP.B #$70                
CODE_00D977:        90 03         BCC CODE_00D97C           
CODE_00D979:        C8            INY                       
CODE_00D97A:        A9 70         LDA.B #$70                
CODE_00D97C:        8D E4 13      STA.W $13E4               
Return00D97F:       60            RTS                       ; Return 


DATA_00D980:                      .db $16,$1A,$1A,$18

DATA_00D984:                      .db $E8,$F8,$D0,$D0

CODE_00D988:        9C ED 13      STZ.W $13ED               
CODE_00D98B:        64 73         STZ RAM_IsDucking         
CODE_00D98D:        9C 07 14      STZ.W $1407               
CODE_00D990:        9C 0D 14      STZ.W RAM_IsSpinJump      
CODE_00D993:        A4 7D         LDY RAM_MarioSpeedY       
CODE_00D995:        AD 8F 14      LDA.W $148F               
CODE_00D998:        F0 51         BEQ CODE_00D9EB           
CODE_00D99A:        A5 72         LDA RAM_IsFlying          
CODE_00D99C:        D0 11         BNE CODE_00D9AF           
CODE_00D99E:        A5 16         LDA $16                   
CODE_00D9A0:        05 18         ORA $18                   
CODE_00D9A2:        10 0B         BPL CODE_00D9AF           
CODE_00D9A4:        A9 0B         LDA.B #$0B                
CODE_00D9A6:        85 72         STA RAM_IsFlying          
CODE_00D9A8:        9C ED 13      STZ.W $13ED               
CODE_00D9AB:        A0 F0         LDY.B #$F0                
CODE_00D9AD:        80 06         BRA CODE_00D9B5           

CODE_00D9AF:        A5 15         LDA RAM_ControllerA       
CODE_00D9B1:        29 04         AND.B #$04                
CODE_00D9B3:        F0 08         BEQ CODE_00D9BD           
CODE_00D9B5:        20 A9 DA      JSR.W CODE_00DAA9         
CODE_00D9B8:        98            TYA                       
CODE_00D9B9:        18            CLC                       
CODE_00D9BA:        69 08         ADC.B #$08                
CODE_00D9BC:        A8            TAY                       
CODE_00D9BD:        C8            INY                       
CODE_00D9BE:        AD FA 13      LDA.W $13FA               
CODE_00D9C1:        D0 09         BNE CODE_00D9CC           
CODE_00D9C3:        88            DEY                       
CODE_00D9C4:        A5 14         LDA RAM_FrameCounterB     
CODE_00D9C6:        29 03         AND.B #$03                
CODE_00D9C8:        D0 02         BNE CODE_00D9CC           
CODE_00D9CA:        88            DEY                       
CODE_00D9CB:        88            DEY                       
CODE_00D9CC:        98            TYA                       
CODE_00D9CD:        30 08         BMI CODE_00D9D7           
CODE_00D9CF:        C9 10         CMP.B #$10                
CODE_00D9D1:        90 0A         BCC CODE_00D9DD           
CODE_00D9D3:        A9 10         LDA.B #$10                
CODE_00D9D5:        80 06         BRA CODE_00D9DD           

CODE_00D9D7:        C9 F0         CMP.B #$F0                
CODE_00D9D9:        B0 02         BCS CODE_00D9DD           
CODE_00D9DB:        A9 F0         LDA.B #$F0                
CODE_00D9DD:        85 7D         STA RAM_MarioSpeedY       
CODE_00D9DF:        A0 80         LDY.B #$80                
CODE_00D9E1:        A5 15         LDA RAM_ControllerA       
CODE_00D9E3:        29 03         AND.B #$03                
CODE_00D9E5:        D0 61         BNE CODE_00DA48           
CODE_00D9E7:        A5 76         LDA RAM_MarioDirection    
CODE_00D9E9:        80 5B         BRA CODE_00DA46           

CODE_00D9EB:        A5 16         LDA $16                   
CODE_00D9ED:        05 18         ORA $18                   
CODE_00D9EF:        10 1A         BPL CODE_00DA0B           
CODE_00D9F1:        AD FA 13      LDA.W $13FA               
CODE_00D9F4:        D0 15         BNE CODE_00DA0B           
CODE_00D9F6:        20 A9 DA      JSR.W CODE_00DAA9         
CODE_00D9F9:        A5 72         LDA RAM_IsFlying          
CODE_00D9FB:        D0 09         BNE CODE_00DA06           
CODE_00D9FD:        A9 0B         LDA.B #$0B                
CODE_00D9FF:        85 72         STA RAM_IsFlying          
CODE_00DA01:        9C ED 13      STZ.W $13ED               
CODE_00DA04:        A0 F0         LDY.B #$F0                
CODE_00DA06:        98            TYA                       
CODE_00DA07:        38            SEC                       
CODE_00DA08:        E9 20         SBC.B #$20                
CODE_00DA0A:        A8            TAY                       
CODE_00DA0B:        A5 14         LDA RAM_FrameCounterB     
CODE_00DA0D:        29 03         AND.B #$03                
CODE_00DA0F:        D0 02         BNE CODE_00DA13           
CODE_00DA11:        C8            INY                       
CODE_00DA12:        C8            INY                       
CODE_00DA13:        A5 15         LDA RAM_ControllerA       
CODE_00DA15:        29 0C         AND.B #$0C                
CODE_00DA17:        4A            LSR                       
CODE_00DA18:        4A            LSR                       
CODE_00DA19:        AA            TAX                       
CODE_00DA1A:        98            TYA                       
CODE_00DA1B:        30 08         BMI CODE_00DA25           
CODE_00DA1D:        C9 40         CMP.B #$40                
CODE_00DA1F:        90 0C         BCC CODE_00DA2D           
CODE_00DA21:        A9 40         LDA.B #$40                
CODE_00DA23:        80 08         BRA CODE_00DA2D           

CODE_00DA25:        DD 84 D9      CMP.W DATA_00D984,X       
CODE_00DA28:        B0 03         BCS CODE_00DA2D           
CODE_00DA2A:        BD 84 D9      LDA.W DATA_00D984,X       
CODE_00DA2D:        85 7D         STA RAM_MarioSpeedY       
CODE_00DA2F:        A5 72         LDA RAM_IsFlying          
CODE_00DA31:        D0 0D         BNE CODE_00DA40           
CODE_00DA33:        A5 15         LDA RAM_ControllerA       
CODE_00DA35:        29 04         AND.B #$04                
CODE_00DA37:        F0 07         BEQ CODE_00DA40           
CODE_00DA39:        9C E8 13      STZ.W $13E8               
CODE_00DA3C:        E6 73         INC RAM_IsDucking         
CODE_00DA3E:        80 29         BRA CODE_00DA69           

CODE_00DA40:        A5 15         LDA RAM_ControllerA       
CODE_00DA42:        29 03         AND.B #$03                
CODE_00DA44:        F0 23         BEQ CODE_00DA69           
CODE_00DA46:        A0 78         LDY.B #$78                
CODE_00DA48:        84 00         STY $00                   
CODE_00DA4A:        29 01         AND.B #$01                
CODE_00DA4C:        85 76         STA RAM_MarioDirection    
CODE_00DA4E:        48            PHA                       
CODE_00DA4F:        0A            ASL                       
CODE_00DA50:        0A            ASL                       
CODE_00DA51:        AA            TAX                       
CODE_00DA52:        68            PLA                       
CODE_00DA53:        05 00         ORA $00                   
CODE_00DA55:        AC 03 14      LDY.W $1403               
CODE_00DA58:        F0 03         BEQ CODE_00DA5D           
CODE_00DA5A:        18            CLC                       
CODE_00DA5B:        69 04         ADC.B #$04                
CODE_00DA5D:        A8            TAY                       
CODE_00DA5E:        A5 72         LDA RAM_IsFlying          
CODE_00DA60:        F0 02         BEQ CODE_00DA64           
CODE_00DA62:        C8            INY                       
CODE_00DA63:        C8            INY                       
CODE_00DA64:        20 42 D7      JSR.W CODE_00D742         
CODE_00DA67:        80 13         BRA CODE_00DA7C           

CODE_00DA69:        A0 00         LDY.B #$00                
CODE_00DA6B:        BB            TYX                       
CODE_00DA6C:        AD 03 14      LDA.W $1403               
CODE_00DA6F:        F0 08         BEQ CODE_00DA79           
CODE_00DA71:        A2 1E         LDX.B #$1E                
CODE_00DA73:        A5 72         LDA RAM_IsFlying          
CODE_00DA75:        D0 02         BNE CODE_00DA79           
CODE_00DA77:        E8            INX                       
CODE_00DA78:        E8            INX                       
CODE_00DA79:        20 72 D7      JSR.W CODE_00D772         
CODE_00DA7C:        20 62 D0      JSR.W CODE_00D062         
CODE_00DA7F:        22 B1 CE 00   JSL.L CODE_00CEB1         
CODE_00DA83:        AD A6 14      LDA.W $14A6               
CODE_00DA86:        D0 04         BNE Return00DA8C          
CODE_00DA88:        A5 72         LDA RAM_IsFlying          
CODE_00DA8A:        D0 01         BNE CODE_00DA8D           
Return00DA8C:       60            RTS                       ; Return 

CODE_00DA8D:        A9 18         LDA.B #$18                
CODE_00DA8F:        AC 9C 14      LDY.W RAM_FireballImgTimer 
CODE_00DA92:        D0 0B         BNE CODE_00DA9F           
CODE_00DA94:        AD 96 14      LDA.W $1496               
CODE_00DA97:        4A            LSR                       
CODE_00DA98:        4A            LSR                       
CODE_00DA99:        29 03         AND.B #$03                
CODE_00DA9B:        A8            TAY                       
CODE_00DA9C:        B9 80 D9      LDA.W DATA_00D980,Y       
CODE_00DA9F:        AC 8F 14      LDY.W $148F               
CODE_00DAA2:        F0 01         BEQ CODE_00DAA5           
CODE_00DAA4:        1A            INC A                     
CODE_00DAA5:        8D E0 13      STA.W MarioFrame          
Return00DAA8:       60            RTS                       ; Return 

CODE_00DAA9:        A9 0E         LDA.B #$0E                ; \ Play sound effect 
CODE_00DAAB:        8D F9 1D      STA.W $1DF9               ; / 
CODE_00DAAE:        AD 96 14      LDA.W $1496               
CODE_00DAB1:        09 10         ORA.B #$10                
CODE_00DAB3:        8D 96 14      STA.W $1496               
Return00DAB6:       60            RTS                       ; Return 


DATA_00DAB7:                      .db $10,$08,$F0,$F8

DATA_00DABB:                      .db $B0,$F0

DATA_00DABD:                      .db $00,$01,$00,$01,$01,$01,$01,$01
                                  .db $01,$01,$01,$01,$01,$01,$01,$01
DATA_00DACD:                      .db $22,$15,$22,$15,$21,$1F,$20,$20
                                  .db $20,$20,$1F,$21,$1F,$21

ClimbingImgs:                     .db $15,$22

ClimbPunchingImgs:                .db $1E,$23

DATA_00DADF:                      .db $10,$0F,$0E,$0D,$0C,$0B,$0A,$09
                                  .db $08,$07,$06,$05,$05,$05,$05,$05
                                  .db $05,$05

DATA_00DAF1:                      .db $20,$01,$40,$01,$2A,$01,$2A,$01
                                  .db $30,$01,$33,$01,$32,$01,$34,$01
                                  .db $36,$01,$38,$01,$3A,$01,$3B,$01
                                  .db $45,$01,$45,$01,$45,$01,$45,$01
                                  .db $45,$01,$45,$01,$08,$F8

CODE_00DB17:        64 72         STZ RAM_IsFlying          
CODE_00DB19:        64 7D         STZ RAM_MarioSpeedY       
CODE_00DB1B:        9C DF 13      STZ.W $13DF               
CODE_00DB1E:        9C 0D 14      STZ.W RAM_IsSpinJump      
CODE_00DB21:        AC 9D 14      LDY.W $149D               
CODE_00DB24:        F0 57         BEQ CODE_00DB7D           
CODE_00DB26:        AD 78 18      LDA.W $1878               
CODE_00DB29:        10 03         BPL CODE_00DB2E           
CODE_00DB2B:        49 FF         EOR.B #$FF                
CODE_00DB2D:        1A            INC A                     
CODE_00DB2E:        AA            TAX                       
CODE_00DB2F:        C0 1E         CPY.B #$1E                
CODE_00DB31:        90 12         BCC CODE_00DB45           
CODE_00DB33:        BD DF DA      LDA.W DATA_00DADF,X       
CODE_00DB36:        2C 78 18      BIT.W $1878               
CODE_00DB39:        10 03         BPL CODE_00DB3E           
CODE_00DB3B:        49 FF         EOR.B #$FF                
CODE_00DB3D:        1A            INC A                     
CODE_00DB3E:        85 7B         STA RAM_MarioSpeedX       
CODE_00DB40:        64 7A         STZ $7A                   
CODE_00DB42:        9C DA 13      STZ.W $13DA               
CODE_00DB45:        8A            TXA                       
CODE_00DB46:        0A            ASL                       
CODE_00DB47:        AA            TAX                       
CODE_00DB48:        AD 78 18      LDA.W $1878               
CODE_00DB4B:        C0 08         CPY.B #$08                
CODE_00DB4D:        B0 02         BCS CODE_00DB51           
CODE_00DB4F:        49 80         EOR.B #$80                
CODE_00DB51:        0A            ASL                       
CODE_00DB52:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00DB54:        BD F1 DA      LDA.W DATA_00DAF1,X       
CODE_00DB57:        B0 04         BCS CODE_00DB5D           
CODE_00DB59:        49 FF FF      EOR.W #$FFFF              
CODE_00DB5C:        1A            INC A                     
CODE_00DB5D:        18            CLC                       
CODE_00DB5E:        65 7A         ADC $7A                   
CODE_00DB60:        85 7A         STA $7A                   
CODE_00DB62:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00DB64:        98            TYA                       
CODE_00DB65:        4A            LSR                       
CODE_00DB66:        29 0E         AND.B #$0E                
CODE_00DB68:        0D F0 13      ORA.W $13F0               
CODE_00DB6B:        A8            TAY                       
CODE_00DB6C:        B9 BD DA      LDA.W DATA_00DABD,Y       
CODE_00DB6F:        2C 78 18      BIT.W $1878               
CODE_00DB72:        30 02         BMI CODE_00DB76           
CODE_00DB74:        49 01         EOR.B #$01                
CODE_00DB76:        85 76         STA RAM_MarioDirection    
CODE_00DB78:        B9 CD DA      LDA.W DATA_00DACD,Y       
CODE_00DB7B:        80 15         BRA CODE_00DB92           

CODE_00DB7D:        64 7B         STZ RAM_MarioSpeedX       
CODE_00DB7F:        64 7A         STZ $7A                   
CODE_00DB81:        AE F9 13      LDX.W RAM_IsBehindScenery 
CODE_00DB84:        AD 9E 14      LDA.W $149E               
CODE_00DB87:        F0 0D         BEQ CODE_00DB96           
CODE_00DB89:        8A            TXA                       
CODE_00DB8A:        1A            INC A                     
CODE_00DB8B:        1A            INC A                     
CODE_00DB8C:        20 44 D0      JSR.W CODE_00D044         
CODE_00DB8F:        BD DD DA      LDA.W ClimbPunchingImgs,X 
CODE_00DB92:        8D E0 13      STA.W MarioFrame          
Return00DB95:       60            RTS                       ; Return 

CODE_00DB96:        A4 75         LDY RAM_IsSwimming        ; Mario is in Water flag 
CODE_00DB98:        24 16         BIT $16                   
CODE_00DB9A:        10 10         BPL CODE_00DBAC           
CODE_00DB9C:        A9 0B         LDA.B #$0B                
CODE_00DB9E:        85 72         STA RAM_IsFlying          
CODE_00DBA0:        B9 BB DA      LDA.W DATA_00DABB,Y       
CODE_00DBA3:        85 7D         STA RAM_MarioSpeedY       
CODE_00DBA5:        A9 01         LDA.B #$01                ; \ Play sound effect 
CODE_00DBA7:        8D FA 1D      STA.W $1DFA               ; / 
CODE_00DBAA:        80 54         BRA CODE_00DC00           

CODE_00DBAC:        50 1C         BVC CODE_00DBCA           
CODE_00DBAE:        A5 74         LDA RAM_IsClimbing        
CODE_00DBB0:        10 18         BPL CODE_00DBCA           
CODE_00DBB2:        A9 01         LDA.B #$01                ; \ Play sound effect 
CODE_00DBB4:        8D F9 1D      STA.W $1DF9               ; / 
CODE_00DBB7:        8E F0 13      STX.W $13F0               
CODE_00DBBA:        A5 94         LDA RAM_MarioXPos         ; Mario X 
CODE_00DBBC:        29 08         AND.B #$08                
CODE_00DBBE:        4A            LSR                       
CODE_00DBBF:        4A            LSR                       
CODE_00DBC0:        4A            LSR                       
CODE_00DBC1:        49 01         EOR.B #$01                
CODE_00DBC3:        85 76         STA RAM_MarioDirection    ; Mario's Direction 
CODE_00DBC5:        A9 08         LDA.B #$08                
CODE_00DBC7:        8D 9E 14      STA.W $149E               
CODE_00DBCA:        BD DB DA      LDA.W ClimbingImgs,X      
CODE_00DBCD:        8D E0 13      STA.W MarioFrame          ; Store A in Mario image 
CODE_00DBD0:        A5 15         LDA RAM_ControllerA       
CODE_00DBD2:        29 03         AND.B #$03                
CODE_00DBD4:        F0 1C         BEQ CODE_00DBF2           
CODE_00DBD6:        4A            LSR                       
CODE_00DBD7:        AA            TAX                       
CODE_00DBD8:        A5 8B         LDA $8B                   
CODE_00DBDA:        29 18         AND.B #$18                
CODE_00DBDC:        C9 18         CMP.B #$18                
CODE_00DBDE:        F0 08         BEQ CODE_00DBE8           
CODE_00DBE0:        A5 74         LDA RAM_IsClimbing        
CODE_00DBE2:        10 1C         BPL CODE_00DC00           
CODE_00DBE4:        E4 8C         CPX $8C                   
CODE_00DBE6:        F0 0A         BEQ CODE_00DBF2           
CODE_00DBE8:        8A            TXA                       
CODE_00DBE9:        0A            ASL                       
CODE_00DBEA:        05 75         ORA RAM_IsSwimming        
CODE_00DBEC:        AA            TAX                       
CODE_00DBED:        BD B7 DA      LDA.W DATA_00DAB7,X       
CODE_00DBF0:        85 7B         STA RAM_MarioSpeedX       
CODE_00DBF2:        A5 15         LDA RAM_ControllerA       ; \ 
CODE_00DBF4:        29 0C         AND.B #$0C                ;  |If up or down isn't pressed, branch to $DC16 
CODE_00DBF6:        F0 1E         BEQ CODE_00DC16           ; / 
CODE_00DBF8:        29 08         AND.B #$08                ; \ If up is pressed, branch to $DC03 
CODE_00DBFA:        D0 07         BNE CODE_00DC03           ; / 
CODE_00DBFC:        46 8B         LSR $8B                   
CODE_00DBFE:        B0 0B         BCS CODE_00DC0B           
CODE_00DC00:        64 74         STZ RAM_IsClimbing        ; Mario isn't climbing 
Return00DC02:       60            RTS                       ; Return 

CODE_00DC03:        C8            INY                       
CODE_00DC04:        C8            INY                       
CODE_00DC05:        A5 8B         LDA $8B                   
CODE_00DC07:        29 02         AND.B #$02                
CODE_00DC09:        F0 0B         BEQ CODE_00DC16           
CODE_00DC0B:        A5 74         LDA RAM_IsClimbing        
CODE_00DC0D:        30 02         BMI CODE_00DC11           
CODE_00DC0F:        64 7B         STZ RAM_MarioSpeedX       
CODE_00DC11:        B9 B7 DA      LDA.W DATA_00DAB7,Y       
CODE_00DC14:        85 7D         STA RAM_MarioSpeedY       
CODE_00DC16:        05 7B         ORA RAM_MarioSpeedX       
CODE_00DC18:        F0 12         BEQ Return00DC2C          
CODE_00DC1A:        AD 96 14      LDA.W $1496               
CODE_00DC1D:        09 08         ORA.B #$08                
CODE_00DC1F:        8D 96 14      STA.W $1496               
CODE_00DC22:        29 07         AND.B #$07                
CODE_00DC24:        D0 06         BNE Return00DC2C          
CODE_00DC26:        A5 76         LDA RAM_MarioDirection    
CODE_00DC28:        49 01         EOR.B #$01                
CODE_00DC2A:        85 76         STA RAM_MarioDirection    
Return00DC2C:       60            RTS                       ; Return 

CODE_00DC2D:        A5 7D         LDA RAM_MarioSpeedY       ; \ Store Mario's Y speed in $8A 
CODE_00DC2F:        85 8A         STA $8A                   ; /  
CODE_00DC31:        AD E3 13      LDA.W RAM_WallWalkStatus  
CODE_00DC34:        F0 0A         BEQ CODE_00DC40           
CODE_00DC36:        4A            LSR                       
CODE_00DC37:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00DC39:        90 03         BCC CODE_00DC3E           
CODE_00DC3B:        49 FF         EOR.B #$FF                
CODE_00DC3D:        1A            INC A                     
CODE_00DC3E:        85 7D         STA RAM_MarioSpeedY       
CODE_00DC40:        A2 00         LDX.B #$00                
CODE_00DC42:        20 4F DC      JSR.W CODE_00DC4F         
CODE_00DC45:        A2 02         LDX.B #$02                
CODE_00DC47:        20 4F DC      JSR.W CODE_00DC4F         
CODE_00DC4A:        A5 8A         LDA $8A                   
CODE_00DC4C:        85 7D         STA RAM_MarioSpeedY       
Return00DC4E:       60            RTS                       ; Return 

CODE_00DC4F:        B5 7B         LDA RAM_MarioSpeedX,X     
CODE_00DC51:        0A            ASL                       
CODE_00DC52:        0A            ASL                       
CODE_00DC53:        0A            ASL                       
CODE_00DC54:        0A            ASL                       
CODE_00DC55:        18            CLC                       
CODE_00DC56:        7D DA 13      ADC.W $13DA,X             
CODE_00DC59:        9D DA 13      STA.W $13DA,X             
CODE_00DC5C:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00DC5E:        08            PHP                       
CODE_00DC5F:        B5 7B         LDA RAM_MarioSpeedX,X     
CODE_00DC61:        4A            LSR                       
CODE_00DC62:        4A            LSR                       
CODE_00DC63:        4A            LSR                       
CODE_00DC64:        4A            LSR                       
CODE_00DC65:        29 0F 00      AND.W #$000F              
CODE_00DC68:        C9 08 00      CMP.W #$0008              
CODE_00DC6B:        90 03         BCC CODE_00DC70           
CODE_00DC6D:        09 F0 FF      ORA.W #$FFF0              
CODE_00DC70:        28            PLP                       
CODE_00DC71:        75 94         ADC RAM_MarioXPos,X       
CODE_00DC73:        95 94         STA RAM_MarioXPos,X       
CODE_00DC75:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return00DC77:       60            RTS                       ; Return 


NumWalkingFrames:                 .db $01,$02,$02,$02

DATA_00DC7C:                      .db $0A,$08,$06,$04,$03,$02,$01,$01
                                  .db $0A,$08,$06,$04,$03,$02,$01,$01
                                  .db $0A,$08,$06,$04,$03,$02,$01,$01
                                  .db $08,$06,$04,$03,$02,$01,$01,$01
                                  .db $08,$06,$04,$03,$02,$01,$01,$01
                                  .db $05,$04,$03,$02,$01,$01,$01,$01
                                  .db $05,$04,$03,$02,$01,$01,$01,$01
                                  .db $05,$04,$03,$02,$01,$01,$01,$01
                                  .db $05,$04,$03,$02,$01,$01,$01,$01
                                  .db $05,$04,$03,$02,$01,$01,$01,$01
                                  .db $05,$04,$03,$02,$01,$01,$01,$01
                                  .db $04,$03,$02,$01,$01,$01,$01,$01
                                  .db $04,$03,$02,$01,$01,$01,$01,$01
                                  .db $02,$02,$02,$02,$02,$02,$02,$02
DATA_00DCEC:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $02,$04,$04,$04,$0E,$08,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$08,$08
                                  .db $08,$08,$08,$08,$00,$00,$00,$00
                                  .db $0C,$10,$12,$14,$16,$18,$1A,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$06,$00,$00
                                  .db $00,$00,$00,$0A,$00,$00

DATA_00DD32:                      .db $00,$08,$10,$14,$18,$1E,$24,$24
                                  .db $28,$30,$38,$3E,$44,$4A,$50,$54
                                  .db $58,$58,$5C,$60,$64,$68,$6C,$70
                                  .db $74,$78,$7C,$80

DATA_00DD4E:                      .db $00,$00,$00,$00,$10,$00,$10,$00
                                  .db $00,$00,$00,$00,$F8,$FF,$F8,$FF
                                  .db $0E,$00,$06,$00,$F2,$FF,$FA,$FF
                                  .db $17,$00,$07,$00,$0F,$00,$EA,$FF
                                  .db $FA,$FF,$FA,$FF,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$10,$00,$10,$00
                                  .db $00,$00,$00,$00,$F8,$FF,$F8,$FF
                                  .db $00,$00,$F8,$FF,$08,$00,$00,$00
                                  .db $08,$00,$F8,$FF,$00,$00,$00,$00
                                  .db $F8,$FF,$00,$00,$00,$00,$10,$00
                                  .db $02,$00,$00,$00,$FE,$FF,$00,$00
                                  .db $00,$00,$00,$00,$FC,$FF,$05,$00
                                  .db $04,$00,$FB,$FF,$FB,$FF,$06,$00
                                  .db $05,$00,$FA,$FF,$F9,$FF,$09,$00
                                  .db $07,$00,$F7,$FF,$FD,$FF,$FD,$FF
                                  .db $03,$00,$03,$00,$FF,$FF,$07,$00
                                  .db $01,$00,$F9,$FF,$0A,$00,$F6,$FF
                                  .db $08,$00,$F8,$FF,$08,$00,$F8,$FF
                                  .db $00,$00,$04,$00,$FC,$FF,$FE,$FF
                                  .db $02,$00,$0B,$00,$F5,$FF,$14,$00
                                  .db $EC,$FF,$0E,$00,$F3,$FF,$08,$00
                                  .db $F8,$FF,$0C,$00,$14,$00,$FD,$FF
                                  .db $F4,$FF,$F4,$FF,$0B,$00,$0B,$00
                                  .db $03,$00,$13,$00,$F5,$FF,$05,$00
                                  .db $F5,$FF,$09,$00,$01,$00,$01,$00
                                  .db $F7,$FF,$07,$00,$07,$00,$05,$00
                                  .db $0D,$00,$0D,$00,$FB,$FF,$FB,$FF
                                  .db $FB,$FF,$FF,$FF,$0F,$00,$01,$00
                                  .db $F9,$FF,$00,$00

DATA_00DE32:                      .db $01,$00,$11,$00,$11,$00,$19,$00
                                  .db $01,$00,$11,$00,$11,$00,$19,$00
                                  .db $0C,$00,$14,$00,$0C,$00,$14,$00
                                  .db $18,$00,$18,$00,$28,$00,$18,$00
                                  .db $18,$00,$28,$00,$06,$00,$16,$00
                                  .db $01,$00,$11,$00,$09,$00,$11,$00
                                  .db $01,$00,$11,$00,$09,$00,$11,$00
                                  .db $01,$00,$11,$00,$11,$00,$01,$00
                                  .db $11,$00,$11,$00,$01,$00,$11,$00
                                  .db $11,$00,$01,$00,$11,$00,$11,$00
                                  .db $01,$00,$11,$00,$01,$00,$11,$00
                                  .db $11,$00,$05,$00,$04,$00,$14,$00
                                  .db $04,$00,$14,$00,$0C,$00,$14,$00
                                  .db $0C,$00,$14,$00,$10,$00,$10,$00
                                  .db $10,$00,$10,$00,$10,$00,$00,$00
                                  .db $10,$00,$00,$00,$10,$00,$00,$00
                                  .db $10,$00,$00,$00,$0B,$00,$0B,$00
                                  .db $11,$00,$11,$00,$FF,$FF,$FF,$FF
                                  .db $10,$00,$10,$00,$10,$00,$10,$00
                                  .db $10,$00,$10,$00,$10,$00,$15,$00
                                  .db $15,$00,$25,$00,$25,$00,$04,$00
                                  .db $04,$00,$04,$00,$14,$00,$14,$00
                                  .db $04,$00,$14,$00,$14,$00,$04,$00
                                  .db $04,$00,$14,$00,$04,$00,$04,$00
                                  .db $14,$00,$00,$00,$08,$00,$00,$00
                                  .db $00,$00,$08,$00,$00,$00,$00,$00
                                  .db $10,$00,$18,$00,$00,$00,$10,$00
                                  .db $18,$00,$00,$00,$10,$00,$00,$00
                                  .db $10,$00,$F8,$FF

TilesetIndex:                     .db $00,$46,$83,$46

TileExpansion?:                   .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$28,$00,$00,$00,$00
                                  .db $00,$00,$04,$04,$04,$00,$00,$00
                                  .db $00,$00,$08,$00,$00,$00,$00,$0C
                                  .db $0C,$0C,$00,$00,$10,$10,$14,$14
                                  .db $18,$18,$00,$00,$1C,$00,$00,$00
                                  .db $00,$20,$00,$00,$00,$00,$24,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$04
                                  .db $04,$04,$00,$00,$00,$00,$00,$08
                                  .db $00,$00,$00,$00,$0C,$0C,$0C,$00
                                  .db $00,$10,$10,$14,$14,$18,$18,$00
                                  .db $00,$1C,$00,$00,$00,$00,$20,$00
                                  .db $00,$00,$00,$24,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
Mario8x8Tiles:                    .db $00,$02,$80,$80,$00,$02,$0C,$80
                                  .db $00,$02,$1A,$1B,$00,$02,$0D,$80
                                  .db $00,$02,$22,$23,$00,$02,$32,$33
                                  .db $00,$02,$0A,$0B,$00,$02,$30,$31
                                  .db $00,$02,$20,$21,$00,$02,$7E,$80
                                  .db $00,$02,$02,$80,$04,$7F,$4A,$5B
                                  .db $4B,$5A

DATA_00E00C:                      .db $50,$50,$50,$09,$50,$50,$50,$50
                                  .db $50,$50,$09,$2B,$50,$2D,$50,$D5
                                  .db $2E,$C4,$C4,$C4,$D6,$B6,$50,$50
                                  .db $50,$50,$50,$50,$50,$C5,$D7,$2A
                                  .db $E0,$50,$D5,$29,$2C,$B6,$D6,$28
                                  .db $E0,$E0,$C5,$C5,$C5,$C5,$C5,$C5
                                  .db $5C,$5C,$50,$5A,$B6,$50,$28,$28
                                  .db $C5,$D7,$28,$70,$C5,$70,$1C,$93
                                  .db $C5,$C5,$0B,$85,$90,$84,$70,$70
                                  .db $70,$A0,$70,$70,$70,$70,$70,$70
                                  .db $A0,$74,$70,$80,$70,$84,$17,$A4
                                  .db $A4,$A4,$B3,$B0,$70,$70,$70,$70
                                  .db $70,$70,$70,$E2,$72,$0F,$61,$70
                                  .db $63,$82,$C7,$90,$B3,$D4,$A5,$C0
                                  .db $08,$54,$0C,$0E,$1B,$51,$49,$4A
                                  .db $48,$4B,$4C,$5D,$5E,$5F,$E3,$90
                                  .db $5F,$5F,$C5,$70,$70,$70,$A0,$70
                                  .db $70,$70,$70,$70,$70,$A0,$74,$70
                                  .db $80,$70,$84,$17,$A4,$A4,$A4,$B3
                                  .db $B0,$70,$70,$70,$70,$70,$70,$70
                                  .db $E2,$72,$0F,$61,$70,$63,$82,$C7
                                  .db $90,$B3,$D4,$A5,$C0,$08,$64,$0C
                                  .db $0E,$1B,$51,$49,$4A,$48,$4B,$4C
                                  .db $5D,$5E,$5F,$E3,$90,$5F,$5F,$C5
DATA_00E0CC:                      .db $71,$60,$60,$19,$94,$96,$96,$A2
                                  .db $97,$97,$18,$3B,$B4,$3D,$A7,$E5
                                  .db $2F,$D3,$C3,$C3,$F6,$D0,$B1,$81
                                  .db $B2,$86,$B4,$87,$A6,$D1,$F7,$3A
                                  .db $F0,$F4,$F5,$39,$3C,$C6,$E6,$38
                                  .db $F1,$F0,$C5,$C5,$C5,$C5,$C5,$C5
                                  .db $6C,$4D,$71,$6A,$6B,$60,$38,$F1
                                  .db $5B,$69,$F1,$F1,$4E,$E1,$1D,$A3
                                  .db $C5,$C5,$1A,$95,$10,$07,$02,$01
                                  .db $00,$02,$14,$13,$12,$30,$27,$26
                                  .db $30,$03,$15,$04,$31,$07,$E7,$25
                                  .db $24,$23,$62,$36,$33,$91,$34,$92
                                  .db $35,$A1,$32,$F2,$73,$1F,$C0,$C1
                                  .db $C2,$83,$D2,$10,$B7,$E4,$B5,$61
                                  .db $0A,$55,$0D,$75,$77,$1E,$59,$59
                                  .db $58,$02,$02,$6D,$6E,$6F,$F3,$68
                                  .db $6F,$6F,$06,$02,$01,$00,$02,$14
                                  .db $13,$12,$30,$27,$26,$30,$03,$15
                                  .db $04,$31,$07,$E7,$25,$24,$23,$62
                                  .db $36,$33,$91,$34,$92,$35,$A1,$32
                                  .db $F2,$73,$1F,$C0,$C1,$C2,$83,$D2
                                  .db $10,$B7,$E4,$B5,$61,$0A,$55,$0D
                                  .db $75,$77,$1E,$59,$59,$58,$02,$02
                                  .db $6D,$6E,$6F,$F3,$68,$6F,$6F,$06
MarioPalIndex:                    .db $00,$40

DATA_00E18E:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$0D,$00,$10
                                  .db $13,$22,$25,$28,$00,$16,$00,$00
                                  .db $00,$00,$00,$00,$00,$08,$19,$1C
                                  .db $04,$1F,$10,$10,$00,$16,$10,$06
                                  .db $04,$08,$2B,$30,$35,$3A,$3F,$43
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $16,$16,$00,$00,$08,$00,$00,$00
                                  .db $00,$00,$00,$10,$04,$00

DATA_00E1D4:                      .db $06

DATA_00E1D5:                      .db $00

DATA_00E1D6:                      .db $06

DATA_00E1D7:                      .db $00

DATA_00E1D8:                      .db $86,$02,$06,$03,$06,$01,$06,$CE
                                  .db $06,$06,$40,$00,$06,$2C,$06,$06
                                  .db $44,$0E,$86,$2C,$06,$86,$2C,$0A
                                  .db $86,$84,$08,$06,$0A,$02,$06,$AC
                                  .db $10,$06,$CC,$10,$06,$AE,$10,$00
                                  .db $8C,$14,$80,$2E,$00,$CA,$16,$91
                                  .db $2F,$00,$8E,$18,$81,$30,$00,$EB
                                  .db $1A,$90,$31,$04,$ED,$1C,$82,$06
                                  .db $92,$1E

DATA_00E21A:                      .db $84,$86,$88,$8A,$8C,$8E,$90,$90
                                  .db $92,$94,$96,$98,$9A,$9C,$9E,$A0
                                  .db $A2,$A4,$A6,$A8,$AA,$B0,$B6,$BC
                                  .db $C2,$C8,$CE,$D4,$DA,$DE,$E2,$E2
DATA_00E23A:                      .db $0A,$0A,$84,$0A,$88,$88,$88,$88
                                  .db $8A,$8A,$8A,$8A,$44,$44,$44,$44
                                  .db $42,$42,$42,$42,$40,$40,$40,$40
                                  .db $22,$22,$22,$22,$A4,$A4,$A4,$A4
                                  .db $A6,$A6,$A6,$A6,$86,$86,$86,$86
                                  .db $6E,$6E,$6E,$6E

DATA_00E266:                      .db $02,$02,$02,$0C,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$04,$12,$04,$04
                                  .db $04,$12,$04,$04,$04,$12,$04,$04
                                  .db $04,$12,$04,$04

DATA_00E292:                      .db $01,$01,$01,$01,$02,$02,$02,$02
                                  .db $04,$04,$04,$04,$08,$08,$08,$08
DATA_00E2A2:                      .db $C8,$B2,$DC,$B2,$C8,$B2,$DC,$B2
                                  .db $C8,$B2,$DC,$B2,$F0,$B2,$04,$B3
DATA_00E2B2:                      .db $10,$D4,$10,$E8

DATA_00E2B6:                      .db $08,$CC,$08

DATA_00E2B9:                      .db $E0,$10,$10,$30

CODE_00E2BD:        8B            PHB                       
CODE_00E2BE:        4B            PHK                       
CODE_00E2BF:        AB            PLB                       
CODE_00E2C0:        A5 78         LDA $78                   
CODE_00E2C2:        C9 FF         CMP.B #$FF                
CODE_00E2C4:        F0 04         BEQ CODE_00E2CA           
CODE_00E2C6:        22 70 EA 01   JSL.L CODE_01EA70         
CODE_00E2CA:        AC 9B 14      LDY.W RAM_FlashingPalTimer 
CODE_00E2CD:        D0 39         BNE CODE_00E308           
CODE_00E2CF:        AC 90 14      LDY.W $1490               ; \ Branch if Mario doesn't have star 
CODE_00E2D2:        F0 40         BEQ CODE_00E314           ; / 
CODE_00E2D4:        A5 78         LDA $78                   
CODE_00E2D6:        C9 FF         CMP.B #$FF                
CODE_00E2D8:        F0 09         BEQ CODE_00E2E3           
CODE_00E2DA:        A5 14         LDA RAM_FrameCounterB     
CODE_00E2DC:        29 03         AND.B #$03                
CODE_00E2DE:        D0 03         BNE CODE_00E2E3           
CODE_00E2E0:        CE 90 14      DEC.W $1490               ; Decrease star timer 
CODE_00E2E3:        A5 13         LDA RAM_FrameCounter      
CODE_00E2E5:        C0 1E         CPY.B #$1E                
CODE_00E2E7:        90 21         BCC CODE_00E30A           
CODE_00E2E9:        D0 21         BNE CODE_00E30C           
CODE_00E2EB:        AD DA 0D      LDA.W $0DDA               
CODE_00E2EE:        C9 FF         CMP.B #$FF                
CODE_00E2F0:        F0 16         BEQ CODE_00E308           
CODE_00E2F2:        29 7F         AND.B #$7F                
CODE_00E2F4:        8D DA 0D      STA.W $0DDA               
CODE_00E2F7:        AA            TAX                       
CODE_00E2F8:        AD AD 14      LDA.W RAM_BluePowTimer    
CODE_00E2FB:        0D AE 14      ORA.W RAM_SilverPowTimer  
CODE_00E2FE:        0D 0C 19      ORA.W $190C               
CODE_00E301:        F0 02         BEQ CODE_00E305           
ADDR_00E303:        A2 0E         LDX.B #$0E                
CODE_00E305:        8E FB 1D      STX.W $1DFB               ; / Change music 
CODE_00E308:        A5 13         LDA RAM_FrameCounter      
CODE_00E30A:        4A            LSR                       
CODE_00E30B:        4A            LSR                       
CODE_00E30C:        29 03         AND.B #$03                
CODE_00E30E:        1A            INC A                     
CODE_00E30F:        1A            INC A                     
CODE_00E310:        1A            INC A                     
CODE_00E311:        1A            INC A                     
CODE_00E312:        80 06         BRA CODE_00E31A           

CODE_00E314:        A5 19         LDA RAM_MarioPowerUp      
CODE_00E316:        0A            ASL                       
CODE_00E317:        0D B3 0D      ORA.W $0DB3               
CODE_00E31A:        0A            ASL                       
CODE_00E31B:        A8            TAY                       
CODE_00E31C:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00E31E:        B9 A2 E2      LDA.W DATA_00E2A2,Y       
CODE_00E321:        8D 82 0D      STA.W $0D82               
CODE_00E324:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00E326:        AE E0 13      LDX.W MarioFrame          
CODE_00E329:        A9 05         LDA.B #$05                
CODE_00E32B:        CD E3 13      CMP.W RAM_WallWalkStatus  
CODE_00E32E:        B0 0E         BCS CODE_00E33E           
CODE_00E330:        AD E3 13      LDA.W RAM_WallWalkStatus  
CODE_00E333:        A4 19         LDY RAM_MarioPowerUp      
CODE_00E335:        F0 04         BEQ CODE_00E33B           
CODE_00E337:        E0 13         CPX.B #$13                
CODE_00E339:        D0 02         BNE CODE_00E33D           
CODE_00E33B:        49 01         EOR.B #$01                
CODE_00E33D:        4A            LSR                       
CODE_00E33E:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00E340:        A5 94         LDA RAM_MarioXPos         
CODE_00E342:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_00E344:        85 7E         STA $7E                   
CODE_00E346:        AD 8B 18      LDA.W $188B               
CODE_00E349:        29 FF 00      AND.W #$00FF              
CODE_00E34C:        18            CLC                       
CODE_00E34D:        65 96         ADC RAM_MarioYPos         
CODE_00E34F:        A4 19         LDY RAM_MarioPowerUp      
CODE_00E351:        C0 01         CPY.B #$01                
CODE_00E353:        A0 01         LDY.B #$01                
CODE_00E355:        B0 02         BCS CODE_00E359           
CODE_00E357:        3A            DEC A                     
CODE_00E358:        88            DEY                       
CODE_00E359:        E0 0A         CPX.B #$0A                
CODE_00E35B:        B0 03         BCS CODE_00E360           
CODE_00E35D:        CC DB 13      CPY.W $13DB               
CODE_00E360:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_00E362:        E0 1C         CPX.B #$1C                
CODE_00E364:        D0 03         BNE CODE_00E369           
CODE_00E366:        69 01 00      ADC.W #$0001              
CODE_00E369:        85 80         STA $80                   
CODE_00E36B:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00E36D:        AD 97 14      LDA.W $1497               
CODE_00E370:        F0 13         BEQ CODE_00E385           
CODE_00E372:        4A            LSR                       
CODE_00E373:        4A            LSR                       
CODE_00E374:        4A            LSR                       
CODE_00E375:        A8            TAY                       
CODE_00E376:        B9 92 E2      LDA.W DATA_00E292,Y       
CODE_00E379:        2D 97 14      AND.W $1497               
CODE_00E37C:        05 9D         ORA RAM_SpritesLocked     
CODE_00E37E:        0D FB 13      ORA.W $13FB               
CODE_00E381:        D0 02         BNE CODE_00E385           
CODE_00E383:        AB            PLB                       
Return00E384:       6B            RTL                       ; Return 

CODE_00E385:        A9 C8         LDA.B #$C8                
CODE_00E387:        E0 43         CPX.B #$43                
CODE_00E389:        D0 02         BNE CODE_00E38D           
CODE_00E38B:        A9 E8         LDA.B #$E8                
CODE_00E38D:        85 04         STA $04                   
CODE_00E38F:        E0 29         CPX.B #$29                
CODE_00E391:        D0 06         BNE CODE_00E399           
CODE_00E393:        A5 19         LDA RAM_MarioPowerUp      
CODE_00E395:        D0 02         BNE CODE_00E399           
CODE_00E397:        A2 20         LDX.B #$20                
CODE_00E399:        BD EC DC      LDA.W DATA_00DCEC,X       
CODE_00E39C:        05 76         ORA RAM_MarioDirection    
CODE_00E39E:        A8            TAY                       
CODE_00E39F:        B9 32 DD      LDA.W DATA_00DD32,Y       
CODE_00E3A2:        85 05         STA $05                   
CODE_00E3A4:        A4 19         LDY RAM_MarioPowerUp      
CODE_00E3A6:        AD E0 13      LDA.W MarioFrame          
CODE_00E3A9:        C9 3D         CMP.B #$3D                
CODE_00E3AB:        B0 03         BCS CODE_00E3B0           
CODE_00E3AD:        79 16 DF      ADC.W TilesetIndex,Y      
CODE_00E3B0:        A8            TAY                       
CODE_00E3B1:        B9 1A DF      LDA.W TileExpansion?,Y    
CODE_00E3B4:        85 06         STA $06                   
CODE_00E3B6:        B9 0C E0      LDA.W DATA_00E00C,Y       
CODE_00E3B9:        85 0A         STA $0A                   
CODE_00E3BB:        B9 CC E0      LDA.W DATA_00E0CC,Y       
CODE_00E3BE:        85 0B         STA $0B                   
CODE_00E3C0:        A5 64         LDA $64                   
CODE_00E3C2:        AE F9 13      LDX.W RAM_IsBehindScenery 
CODE_00E3C5:        F0 03         BEQ CODE_00E3CA           
CODE_00E3C7:        BD B9 E2      LDA.W DATA_00E2B9,X       
CODE_00E3CA:        BC B2 E2      LDY.W DATA_00E2B2,X       
CODE_00E3CD:        A6 76         LDX RAM_MarioDirection    
CODE_00E3CF:        1D 8C E1      ORA.W MarioPalIndex,X     
CODE_00E3D2:        99 03 03      STA.W OAM_Prop,Y          
CODE_00E3D5:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_00E3D8:        99 0F 03      STA.W OAM_Tile4Prop,Y     
CODE_00E3DB:        99 13 03      STA.W $0313,Y             
CODE_00E3DE:        99 FB 02      STA.W $02FB,Y             
CODE_00E3E1:        99 FF 02      STA.W $02FF,Y             
CODE_00E3E4:        A6 04         LDX $04                   
CODE_00E3E6:        E0 E8         CPX.B #$E8                
CODE_00E3E8:        D0 02         BNE CODE_00E3EC           
CODE_00E3EA:        49 40         EOR.B #$40                
CODE_00E3EC:        99 0B 03      STA.W OAM_Tile3Prop,Y     
CODE_00E3EF:        20 5D E4      JSR.W CODE_00E45D         
CODE_00E3F2:        20 5D E4      JSR.W CODE_00E45D         
CODE_00E3F5:        20 5D E4      JSR.W CODE_00E45D         
CODE_00E3F8:        20 5D E4      JSR.W CODE_00E45D         
CODE_00E3FB:        A5 19         LDA RAM_MarioPowerUp      
CODE_00E3FD:        C9 02         CMP.B #$02                
CODE_00E3FF:        D0 57         BNE CODE_00E458           
CODE_00E401:        5A            PHY                       
CODE_00E402:        A9 2C         LDA.B #$2C                
CODE_00E404:        85 06         STA $06                   
CODE_00E406:        AE E0 13      LDX.W MarioFrame          
CODE_00E409:        BD 8E E1      LDA.W DATA_00E18E,X       
CODE_00E40C:        AA            TAX                       
CODE_00E40D:        BD D7 E1      LDA.W DATA_00E1D7,X       
CODE_00E410:        85 0D         STA $0D                   
CODE_00E412:        BD D8 E1      LDA.W DATA_00E1D8,X       
CODE_00E415:        85 0E         STA $0E                   
CODE_00E417:        BD D5 E1      LDA.W DATA_00E1D5,X       
CODE_00E41A:        85 0C         STA $0C                   
CODE_00E41C:        C9 04         CMP.B #$04                
CODE_00E41E:        B0 12         BCS CODE_00E432           
CODE_00E420:        AD DF 13      LDA.W $13DF               
CODE_00E423:        0A            ASL                       
CODE_00E424:        0A            ASL                       
CODE_00E425:        05 0C         ORA $0C                   
CODE_00E427:        A8            TAY                       
CODE_00E428:        B9 3A E2      LDA.W DATA_00E23A,Y       
CODE_00E42B:        85 0C         STA $0C                   
CODE_00E42D:        B9 66 E2      LDA.W DATA_00E266,Y       
CODE_00E430:        80 03         BRA CODE_00E435           

CODE_00E432:        BD D6 E1      LDA.W DATA_00E1D6,X       
CODE_00E435:        05 76         ORA RAM_MarioDirection    
CODE_00E437:        A8            TAY                       
CODE_00E438:        B9 1A E2      LDA.W DATA_00E21A,Y       
CODE_00E43B:        85 05         STA $05                   
CODE_00E43D:        7A            PLY                       
CODE_00E43E:        BD D4 E1      LDA.W DATA_00E1D4,X       
CODE_00E441:        04 78         TSB $78                   
CODE_00E443:        30 03         BMI CODE_00E448           
CODE_00E445:        20 5D E4      JSR.W CODE_00E45D         
CODE_00E448:        AE F9 13      LDX.W RAM_IsBehindScenery 
CODE_00E44B:        BC B6 E2      LDY.W DATA_00E2B6,X       
CODE_00E44E:        20 5D E4      JSR.W CODE_00E45D         
CODE_00E451:        A5 0E         LDA $0E                   
CODE_00E453:        85 06         STA $06                   
CODE_00E455:        20 5D E4      JSR.W CODE_00E45D         
CODE_00E458:        20 36 F6      JSR.W CODE_00F636         
CODE_00E45B:        AB            PLB                       
Return00E45C:       6B            RTL                       ; Return 

CODE_00E45D:        46 78         LSR $78                   
CODE_00E45F:        B0 3E         BCS CODE_00E49F           
CODE_00E461:        A6 06         LDX $06                   
CODE_00E463:        BD DA DF      LDA.W Mario8x8Tiles,X     
CODE_00E466:        30 37         BMI CODE_00E49F           
CODE_00E468:        99 02 03      STA.W OAM_Tile,Y          
CODE_00E46B:        A6 05         LDX $05                   
CODE_00E46D:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00E46F:        A5 80         LDA $80                   
CODE_00E471:        18            CLC                       
CODE_00E472:        7D 32 DE      ADC.W DATA_00DE32,X       
CODE_00E475:        48            PHA                       
CODE_00E476:        18            CLC                       
CODE_00E477:        69 10 00      ADC.W #$0010              
CODE_00E47A:        C9 00 01      CMP.W #$0100              
CODE_00E47D:        68            PLA                       
CODE_00E47E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00E480:        B0 1D         BCS CODE_00E49F           
CODE_00E482:        99 01 03      STA.W OAM_DispY,Y         
CODE_00E485:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00E487:        A5 7E         LDA $7E                   
CODE_00E489:        18            CLC                       
CODE_00E48A:        7D 4E DD      ADC.W DATA_00DD4E,X       
CODE_00E48D:        48            PHA                       
CODE_00E48E:        18            CLC                       
CODE_00E48F:        69 80 00      ADC.W #$0080              
CODE_00E492:        C9 00 02      CMP.W #$0200              
CODE_00E495:        68            PLA                       
CODE_00E496:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00E498:        B0 05         BCS CODE_00E49F           
CODE_00E49A:        99 00 03      STA.W OAM_DispX,Y         
CODE_00E49D:        EB            XBA                       
CODE_00E49E:        4A            LSR                       
CODE_00E49F:        08            PHP                       
CODE_00E4A0:        98            TYA                       
CODE_00E4A1:        4A            LSR                       
CODE_00E4A2:        4A            LSR                       
CODE_00E4A3:        AA            TAX                       
CODE_00E4A4:        06 04         ASL $04                   
CODE_00E4A6:        2A            ROL                       
CODE_00E4A7:        28            PLP                       
CODE_00E4A8:        2A            ROL                       
CODE_00E4A9:        29 03         AND.B #$03                
CODE_00E4AB:        9D 60 04      STA.W OAM_TileSize,X      
CODE_00E4AE:        C8            INY                       
CODE_00E4AF:        C8            INY                       
CODE_00E4B0:        C8            INY                       
CODE_00E4B1:        C8            INY                       
CODE_00E4B2:        E6 05         INC $05                   
CODE_00E4B4:        E6 05         INC $05                   
CODE_00E4B6:        E6 06         INC $06                   
Return00E4B8:       60            RTS                       ; Return 


DATA_00E4B9:                      .db $08,$08,$08,$08,$10,$10,$10,$10
                                  .db $18,$18,$20,$20,$28,$30,$08,$10
                                  .db $00,$00,$28,$00,$00,$00,$00,$00
                                  .db $38,$50,$48,$40,$58,$58,$60,$60
                                  .db $00

DATA_00E4DA:                      .db $10,$10,$10,$10,$10,$10,$10,$10
                                  .db $20,$20,$20,$20,$30,$30,$40,$30
                                  .db $30,$30,$30,$00,$00,$00,$00,$00
                                  .db $30,$30,$30,$30,$40,$40,$40,$40
                                  .db $00

DATA_00E4FB:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $EC,$EC,$EE,$EE,$DA,$DA,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $DA,$DA,$DA,$DA,$00,$00,$00,$00
                                  .db $00

DATA_00E51C:                      .db $08,$08,$08,$08,$08,$08,$08,$08
                                  .db $09,$09,$09,$09,$0B,$0B,$0B,$0B
                                  .db $0B,$0B,$0B,$00,$00,$00,$00,$00
                                  .db $0B,$0B,$0B,$0B,$14,$14,$14,$14
                                  .db $06

DATA_00E53D:                      .db $FF,$FF,$FF,$FF,$01,$01,$01,$01
                                  .db $FE,$FE,$02,$02,$FD,$03,$FD,$03
                                  .db $FD,$03,$FD,$00,$00,$00,$00,$00
                                  .db $08,$08,$F8,$F8,$FC,$FC,$04,$04
                                  .db $00,$00,$00,$00,$00,$00,$01,$01
                                  .db $01,$01,$01,$02,$02,$02,$02,$02
                                  .db $03,$03,$03,$03,$03,$04,$04,$04
                                  .db $04,$04,$05,$05,$05,$05,$05,$06
                                  .db $06,$06,$06,$06,$07,$07,$07,$07
                                  .db $07,$08,$08,$08,$08,$08,$09,$09
                                  .db $09,$09,$09,$0A,$0A,$0A,$0A,$0A
                                  .db $0B,$0B,$0B,$0B,$0B,$0C,$0C,$0C
                                  .db $0C,$0C,$0D,$0D,$0D,$0D,$0D,$0E
                                  .db $0F,$10,$11,$03,$03,$04,$04,$09
                                  .db $09,$0A,$0A,$0C,$0C,$0D,$0D,$12
                                  .db $13,$14,$15,$16,$17,$1C,$1D,$1E
                                  .db $1F,$18,$19,$1A,$1B,$08,$09,$0A
                                  .db $0B,$0C,$0D,$00,$00,$00,$00,$00
                                  .db $01,$01,$01,$01,$01,$02,$02,$02
                                  .db $02,$02,$03,$03,$03,$03,$03,$04
                                  .db $04,$04,$04,$04,$05,$05,$05,$05
                                  .db $05,$06,$06,$06,$06,$06,$07,$07
                                  .db $07,$07,$07,$08,$08,$08,$08,$08
                                  .db $09,$09,$09,$09,$09,$0A,$0A,$0A
                                  .db $0A,$0A,$0B,$0B,$0B,$0B,$0B,$0C
                                  .db $0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D
                                  .db $0D,$0E,$0F,$10,$11,$03,$03,$04
                                  .db $04,$09,$09,$0A,$0A,$0C,$0C,$0D
                                  .db $0D,$0C,$0D,$0D,$0C,$16,$17,$1C
                                  .db $1D,$1E,$1F,$18,$19,$1A,$1B,$08
                                  .db $09,$0A,$0B,$0C,$0D

DATA_00E632:                      .db $0F,$0F,$0F,$0F,$0E,$0E,$0E,$0E
                                  .db $0D,$0D,$0D,$0D,$0C,$0C,$0C,$0C
                                  .db $0B,$0B,$0B,$0B,$0A,$0A,$0A,$0A
                                  .db $09,$09,$09,$09,$08,$08,$08,$08
                                  .db $07,$07,$07,$07,$06,$06,$06,$06
                                  .db $05,$05,$05,$05,$04,$04,$04,$04
                                  .db $03,$03,$03,$03,$02,$02,$02,$02
                                  .db $01,$01,$01,$01,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$01,$01,$01,$01
                                  .db $02,$02,$02,$02,$03,$03,$03,$03
                                  .db $04,$04,$04,$04,$05,$05,$05,$05
                                  .db $06,$06,$06,$06,$07,$07,$07,$07
                                  .db $08,$08,$08,$08,$09,$09,$09,$09
                                  .db $0A,$0A,$0A,$0A,$0B,$0B,$0B,$0B
                                  .db $0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D
                                  .db $0E,$0E,$0E,$0E,$0F,$0F,$0F,$0F
                                  .db $0F,$0F,$0E,$0E,$0D,$0D,$0C,$0C
                                  .db $0B,$0B,$0A,$0A,$09,$09,$08,$08
                                  .db $07,$07,$06,$06,$05,$05,$04,$04
                                  .db $03,$03,$02,$02,$01,$01,$00,$00
                                  .db $00,$00,$01,$01,$02,$02,$03,$03
                                  .db $04,$04,$05,$05,$06,$06,$07,$07
                                  .db $08,$08,$09,$09,$0A,$0A,$0B,$0B
                                  .db $0C,$0C,$0D,$0D,$0E,$0E,$0F,$0F
                                  .db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08
                                  .db $07,$06,$05,$04,$03,$02,$01,$00
                                  .db $00,$01,$02,$03,$04,$05,$06,$07
                                  .db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
                                  .db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08
                                  .db $07,$06,$05,$04,$03,$02,$01,$00
                                  .db $00,$01,$02,$03,$04,$05,$06,$07
                                  .db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
                                  .db $08,$06,$04,$03,$02,$02,$01,$01
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $01,$01,$02,$02,$03,$04,$06,$08
                                  .db $FF,$FE,$FD,$FC,$FB,$FA,$F9,$F8
                                  .db $F7,$F6,$F5,$F4,$F3,$F2,$F1,$F0
                                  .db $F0,$F1,$F2,$F3,$F4,$F5,$F6,$F7
                                  .db $F8,$F9,$FA,$FB,$FC,$FD,$FE,$FF
                                  .db $FF,$FF,$FE,$FE,$FD,$FD,$FC,$FC
                                  .db $FB,$FB,$FA,$FA,$F9,$F9,$F8,$F8
                                  .db $F7,$F7,$F6,$F6,$F5,$F5,$F4,$F4
                                  .db $F3,$F3,$F2,$F2,$F1,$F1,$F0,$F0
                                  .db $F0,$F0,$F1,$F1,$F2,$F2,$F3,$F3
                                  .db $F4,$F4,$F5,$F5,$F6,$F6,$F7,$F7
                                  .db $F8,$F8,$F9,$F9,$FA,$FA,$FB,$FB
                                  .db $FC,$FC,$FD,$FD,$FE,$FE,$FF,$FF
                                  .db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08
                                  .db $07,$06,$05,$04,$03,$02,$01,$00
                                  .db $00,$01,$02,$03,$04,$05,$06,$07
                                  .db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
                                  .db $00,$01,$02,$03,$04,$05,$06,$07
                                  .db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
                                  .db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08
                                  .db $07,$06,$05,$04,$03,$02,$01,$00
                                  .db $10,$10,$10,$10,$10,$10,$10,$10
                                  .db $0E,$0C,$0A,$08,$06,$04,$02,$00
                                  .db $0E,$0C,$0A,$08,$06,$04,$02,$00
                                  .db $FE,$FC,$FA,$F8,$F6,$F4,$F2,$F0
                                  .db $00,$02,$04,$06,$08,$0A,$0C,$0E
                                  .db $10,$10,$10,$10,$10,$10,$10,$10
                                  .db $F0,$F2,$F4,$F6,$F8,$FA,$FC,$FE
                                  .db $00,$02,$04,$06,$08,$0A

DATA_00E830:                      .db $0C,$0E,$08,$00,$0E,$00,$0E,$00
                                  .db $08,$00,$05,$00,$0B,$00,$08,$00
                                  .db $02,$00,$02,$00,$08,$00,$0B,$00
                                  .db $05,$00,$08,$00,$0E,$00,$0E,$00
                                  .db $08,$00,$05,$00,$0B,$00,$08,$00
                                  .db $02,$00,$02,$00,$08,$00,$0B,$00
                                  .db $05,$00,$08,$00,$0E,$00,$0E,$00
                                  .db $08,$00,$05,$00,$0B,$00,$08,$00
                                  .db $02,$00,$02,$00,$08,$00,$0B,$00
                                  .db $05,$00,$08,$00,$0E,$00,$0E,$00
                                  .db $08,$00,$05,$00,$0B,$00,$08,$00
                                  .db $02,$00,$02,$00,$08,$00,$0B,$00
                                  .db $05,$00,$10,$00,$20,$00,$07,$00
                                  .db $00,$00,$F0,$FF

DATA_00E89C:                      .db $08,$00,$18,$00,$1A,$00,$16,$00
DATA_00E8A4:                      .db $10,$00,$20,$00,$20,$00,$18,$00
                                  .db $1A,$00,$16,$00,$10,$00,$20,$00
                                  .db $20,$00,$12,$00,$1A,$00,$0F,$00
                                  .db $08,$00,$20,$00,$20,$00,$12,$00
                                  .db $1A,$00,$0F,$00,$08,$00,$20,$00
                                  .db $20,$00,$1D,$00,$28,$00,$19,$00
                                  .db $13,$00,$30,$00,$30,$00,$1D,$00
                                  .db $28,$00,$19,$00,$13,$00,$30,$00
                                  .db $30,$00,$1A,$00,$28,$00,$16,$00
                                  .db $10,$00,$30,$00,$30,$00,$1A,$00
                                  .db $28,$00,$16,$00,$10,$00,$30,$00
                                  .db $30,$00,$18,$00,$18,$00,$18,$00
                                  .db $18,$00,$18,$00,$18,$00

DATA_00E90A:                      .db $01,$02,$11

DATA_00E90D:                      .db $FF

DATA_00E90E:                      .db $FF,$01,$00

DATA_00E911:                      .db $02,$0D

DATA_00E913:                      .db $01,$00,$FF,$FF,$01,$00,$01,$00
                                  .db $FF,$FF,$FF,$FF

DATA_00E91F:                      .db $00,$00,$00,$00,$FF,$FF,$01,$00
                                  .db $FF,$FF,$01,$00

CODE_00E92B:        20 A6 EA      JSR.W CODE_00EAA6         
CODE_00E92E:        AD 5C 18      LDA.W $185C               
CODE_00E931:        F0 05         BEQ CODE_00E938           
ADDR_00E933:        20 1D EE      JSR.W CODE_00EE1D         
ADDR_00E936:        80 54         BRA CODE_00E98C           

CODE_00E938:        AD EF 13      LDA.W $13EF               
CODE_00E93B:        85 8D         STA $8D                   
CODE_00E93D:        9C EF 13      STZ.W $13EF               
CODE_00E940:        A5 72         LDA RAM_IsFlying          
CODE_00E942:        85 8F         STA $8F                   
CODE_00E944:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_00E946:        10 30         BPL CODE_00E978           
CODE_00E948:        29 82         AND.B #$82                
CODE_00E94A:        85 8E         STA $8E                   
CODE_00E94C:        A9 01         LDA.B #$01                
CODE_00E94E:        8D 33 19      STA.W $1933               
CODE_00E951:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00E953:        A5 94         LDA RAM_MarioXPos         
CODE_00E955:        18            CLC                       
CODE_00E956:        65 26         ADC $26                   
CODE_00E958:        85 94         STA RAM_MarioXPos         
CODE_00E95A:        A5 96         LDA RAM_MarioYPos         
CODE_00E95C:        18            CLC                       
CODE_00E95D:        65 28         ADC $28                   
CODE_00E95F:        85 96         STA RAM_MarioYPos         
CODE_00E961:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00E963:        20 DB EA      JSR.W CODE_00EADB         
CODE_00E966:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00E968:        A5 94         LDA RAM_MarioXPos         
CODE_00E96A:        38            SEC                       
CODE_00E96B:        E5 26         SBC $26                   
CODE_00E96D:        85 94         STA RAM_MarioXPos         
CODE_00E96F:        A5 96         LDA RAM_MarioYPos         
CODE_00E971:        38            SEC                       
CODE_00E972:        E5 28         SBC $28                   
CODE_00E974:        85 96         STA RAM_MarioYPos         
CODE_00E976:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00E978:        0E EF 13      ASL.W $13EF               
CODE_00E97B:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_00E97D:        29 41         AND.B #$41                
CODE_00E97F:        85 8E         STA $8E                   
CODE_00E981:        0A            ASL                       
CODE_00E982:        30 08         BMI CODE_00E98C           
CODE_00E984:        9C 33 19      STZ.W $1933               
CODE_00E987:        06 8D         ASL $8D                   
CODE_00E989:        20 DB EA      JSR.W CODE_00EADB         
CODE_00E98C:        AD 96 1B      LDA.W $1B96               
CODE_00E98F:        F0 10         BEQ CODE_00E9A1           
CODE_00E991:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00E993:        A5 7E         LDA $7E                   
CODE_00E995:        C9 FA 00      CMP.W #$00FA              
CODE_00E998:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00E99A:        90 5F         BCC CODE_00E9FB           
CODE_00E99C:        22 60 B1 05   JSL.L SubSideExit         
Return00E9A0:       60            RTS                       ; Return 

CODE_00E9A1:        A5 7E         LDA $7E                   
CODE_00E9A3:        C9 F0         CMP.B #$F0                
CODE_00E9A5:        B0 61         BCS CODE_00EA08           
CODE_00E9A7:        A5 77         LDA RAM_MarioObjStatus    
CODE_00E9A9:        29 03         AND.B #$03                
CODE_00E9AB:        D0 4E         BNE CODE_00E9FB           
CODE_00E9AD:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00E9AF:        A0 00         LDY.B #$00                
CODE_00E9B1:        AD 62 14      LDA.W $1462               
CODE_00E9B4:        18            CLC                       
CODE_00E9B5:        69 E8 00      ADC.W #$00E8              
CODE_00E9B8:        C5 94         CMP RAM_MarioXPos         
CODE_00E9BA:        F0 0C         BEQ CODE_00E9C8           
CODE_00E9BC:        30 0A         BMI CODE_00E9C8           
CODE_00E9BE:        C8            INY                       
CODE_00E9BF:        A5 94         LDA RAM_MarioXPos         
CODE_00E9C1:        38            SEC                       
CODE_00E9C2:        E9 08 00      SBC.W #$0008              
CODE_00E9C5:        CD 62 14      CMP.W $1462               
CODE_00E9C8:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00E9CA:        F0 2F         BEQ CODE_00E9FB           
CODE_00E9CC:        10 2D         BPL CODE_00E9FB           
CODE_00E9CE:        AD 11 14      LDA.W $1411               
CODE_00E9D1:        D0 23         BNE CODE_00E9F6           
CODE_00E9D3:        A9 80         LDA.B #$80                
CODE_00E9D5:        04 77         TSB RAM_MarioObjStatus    
CODE_00E9D7:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00E9D9:        AD 46 14      LDA.W $1446               
CODE_00E9DC:        4A            LSR                       
CODE_00E9DD:        4A            LSR                       
CODE_00E9DE:        4A            LSR                       
CODE_00E9DF:        4A            LSR                       
CODE_00E9E0:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00E9E2:        85 00         STA $00                   
CODE_00E9E4:        38            SEC                       
CODE_00E9E5:        E5 7B         SBC RAM_MarioSpeedX       
CODE_00E9E7:        59 0E E9      EOR.W DATA_00E90E,Y       
CODE_00E9EA:        30 0A         BMI CODE_00E9F6           
CODE_00E9EC:        A5 00         LDA $00                   
CODE_00E9EE:        85 7B         STA RAM_MarioSpeedX       
CODE_00E9F0:        AD 4E 14      LDA.W $144E               
CODE_00E9F3:        8D DA 13      STA.W $13DA               
CODE_00E9F6:        B9 0A E9      LDA.W DATA_00E90A,Y       
CODE_00E9F9:        04 77         TSB RAM_MarioObjStatus    
CODE_00E9FB:        A5 77         LDA RAM_MarioObjStatus    
CODE_00E9FD:        29 1C         AND.B #$1C                
CODE_00E9FF:        C9 1C         CMP.B #$1C                
CODE_00EA01:        D0 0A         BNE CODE_00EA0D           
CODE_00EA03:        AD 71 14      LDA.W $1471               
CODE_00EA06:        D0 05         BNE CODE_00EA0D           
CODE_00EA08:        20 29 F6      JSR.W CODE_00F629         
CODE_00EA0B:        80 25         BRA CODE_00EA32           

CODE_00EA0D:        A5 77         LDA RAM_MarioObjStatus    
CODE_00EA0F:        29 03         AND.B #$03                
CODE_00EA11:        F0 21         BEQ CODE_00EA34           
CODE_00EA13:        29 02         AND.B #$02                
CODE_00EA15:        A8            TAY                       
CODE_00EA16:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00EA18:        A5 94         LDA RAM_MarioXPos         
CODE_00EA1A:        18            CLC                       
CODE_00EA1B:        79 0D E9      ADC.W DATA_00E90D,Y       
CODE_00EA1E:        85 94         STA RAM_MarioXPos         
CODE_00EA20:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00EA22:        A5 77         LDA RAM_MarioObjStatus    
CODE_00EA24:        30 0E         BMI CODE_00EA34           
CODE_00EA26:        A9 03         LDA.B #$03                
CODE_00EA28:        8D E5 13      STA.W $13E5               
CODE_00EA2B:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00EA2D:        59 0D E9      EOR.W DATA_00E90D,Y       
CODE_00EA30:        10 02         BPL CODE_00EA34           
CODE_00EA32:        64 7B         STZ RAM_MarioSpeedX       
CODE_00EA34:        AD F9 13      LDA.W RAM_IsBehindScenery 
CODE_00EA37:        C9 01         CMP.B #$01                
CODE_00EA39:        D0 07         BNE CODE_00EA42           
CODE_00EA3B:        A5 8B         LDA $8B                   
CODE_00EA3D:        D0 03         BNE CODE_00EA42           
CODE_00EA3F:        9C F9 13      STZ.W RAM_IsBehindScenery 
CODE_00EA42:        9C FA 13      STZ.W $13FA               
CODE_00EA45:        A5 85         LDA RAM_IsWaterLevel      
CODE_00EA47:        D0 15         BNE CODE_00EA5E           
CODE_00EA49:        46 8A         LSR $8A                   
CODE_00EA4B:        90 56         BCC CODE_00EAA3           
CODE_00EA4D:        A5 75         LDA RAM_IsSwimming        
CODE_00EA4F:        D0 14         BNE CODE_00EA65           
CODE_00EA51:        A5 7D         LDA RAM_MarioSpeedY       
CODE_00EA53:        30 10         BMI CODE_00EA65           
CODE_00EA55:        46 8A         LSR $8A                   
CODE_00EA57:        90 4C         BCC Return00EAA5          
CODE_00EA59:        20 A5 FD      JSR.W CODE_00FDA5         
CODE_00EA5C:        64 7D         STZ RAM_MarioSpeedY       
CODE_00EA5E:        A9 01         LDA.B #$01                
CODE_00EA60:        85 75         STA RAM_IsSwimming        
CODE_00EA62:        4C 08 FD      JMP.W CODE_00FD08         

CODE_00EA65:        46 8A         LSR $8A                   
CODE_00EA67:        B0 F5         BCS CODE_00EA5E           
CODE_00EA69:        A5 75         LDA RAM_IsSwimming        
CODE_00EA6B:        F0 38         BEQ Return00EAA5          
CODE_00EA6D:        A9 FC         LDA.B #$FC                
CODE_00EA6F:        C5 7D         CMP RAM_MarioSpeedY       
CODE_00EA71:        30 02         BMI CODE_00EA75           
CODE_00EA73:        85 7D         STA RAM_MarioSpeedY       
CODE_00EA75:        EE FA 13      INC.W $13FA               
CODE_00EA78:        A5 15         LDA RAM_ControllerA       
CODE_00EA7A:        29 88         AND.B #$88                
CODE_00EA7C:        C9 88         CMP.B #$88                
CODE_00EA7E:        D0 E2         BNE CODE_00EA62           
CODE_00EA80:        A5 17         LDA RAM_ControllerB       
CODE_00EA82:        10 0E         BPL CODE_00EA92           
CODE_00EA84:        AD 8F 14      LDA.W $148F               
CODE_00EA87:        D0 09         BNE CODE_00EA92           
CODE_00EA89:        1A            INC A                     
CODE_00EA8A:        8D 0D 14      STA.W RAM_IsSpinJump      
CODE_00EA8D:        A9 04         LDA.B #$04                ; \ Play sound effect 
CODE_00EA8F:        8D FC 1D      STA.W $1DFC               ; / 
CODE_00EA92:        A5 77         LDA RAM_MarioObjStatus    
CODE_00EA94:        29 08         AND.B #$08                
CODE_00EA96:        D0 CA         BNE CODE_00EA62           
CODE_00EA98:        20 A5 FD      JSR.W CODE_00FDA5         
CODE_00EA9B:        A9 0B         LDA.B #$0B                
CODE_00EA9D:        85 72         STA RAM_IsFlying          
CODE_00EA9F:        A9 AA         LDA.B #$AA                
CODE_00EAA1:        85 7D         STA RAM_MarioSpeedY       
CODE_00EAA3:        64 75         STZ RAM_IsSwimming        
Return00EAA5:       60            RTS                       ; Return 

CODE_00EAA6:        9C E5 13      STZ.W $13E5               
CODE_00EAA9:        64 77         STZ RAM_MarioObjStatus    
CODE_00EAAB:        9C E1 13      STZ.W $13E1               
CODE_00EAAE:        9C EE 13      STZ.W $13EE               
CODE_00EAB1:        64 8A         STZ $8A                   
CODE_00EAB3:        64 8B         STZ $8B                   
CODE_00EAB5:        9C 0E 14      STZ.W $140E               
Return00EAB8:       60            RTS                       ; Return 


DATA_00EAB9:                      .db $DE,$23

DATA_00EABB:                      .db $20,$E0

DATA_00EABD:                      .db $08,$00,$F8,$FF

DATA_00EAC1:                      .db $71,$72,$76,$77,$7B,$7C,$81,$86
                                  .db $8A,$8B,$8F,$90,$94,$95,$99,$9A
                                  .db $9E,$9F,$A3,$A4,$A8,$A9,$AD,$AE
                                  .db $B2,$B3

CODE_00EADB:        A5 96         LDA RAM_MarioYPos         
CODE_00EADD:        29 0F         AND.B #$0F                
CODE_00EADF:        85 90         STA $90                   
CODE_00EAE1:        AD E3 13      LDA.W RAM_WallWalkStatus  
CODE_00EAE4:        D0 03         BNE CODE_00EAE9           
CODE_00EAE6:        4C 77 EB      JMP.W CODE_00EB77         

CODE_00EAE9:        29 01         AND.B #$01                
CODE_00EAEB:        A8            TAY                       
CODE_00EAEC:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00EAEE:        38            SEC                       
CODE_00EAEF:        F9 B9 EA      SBC.W DATA_00EAB9,Y       
CODE_00EAF2:        59 B9 EA      EOR.W DATA_00EAB9,Y       
CODE_00EAF5:        30 51         BMI CODE_00EB48           
CODE_00EAF7:        A5 72         LDA RAM_IsFlying          
CODE_00EAF9:        0D 8F 14      ORA.W $148F               
CODE_00EAFC:        05 73         ORA RAM_IsDucking         
CODE_00EAFE:        0D 7A 18      ORA.W RAM_OnYoshi         
CODE_00EB01:        D0 45         BNE CODE_00EB48           
CODE_00EB03:        AD E3 13      LDA.W RAM_WallWalkStatus  
CODE_00EB06:        C9 06         CMP.B #$06                
CODE_00EB08:        B0 18         BCS CODE_00EB22           
CODE_00EB0A:        A6 90         LDX $90                   
CODE_00EB0C:        E0 08         CPX.B #$08                
CODE_00EB0E:        90 66         BCC Return00EB76          
CODE_00EB10:        C9 04         CMP.B #$04                
CODE_00EB12:        B0 5F         BCS CODE_00EB73           
CODE_00EB14:        09 04         ORA.B #$04                
CODE_00EB16:        8D E3 13      STA.W RAM_WallWalkStatus  
CODE_00EB19:        A5 94         LDA RAM_MarioXPos         
CODE_00EB1B:        29 F0         AND.B #$F0                
CODE_00EB1D:        09 08         ORA.B #$08                
CODE_00EB1F:        85 94         STA RAM_MarioXPos         
Return00EB21:       60            RTS                       ; Return 

CODE_00EB22:        A2 60         LDX.B #$60                
CODE_00EB24:        98            TYA                       
CODE_00EB25:        F0 02         BEQ CODE_00EB29           
CODE_00EB27:        A2 66         LDX.B #$66                
CODE_00EB29:        20 E8 EF      JSR.W CODE_00EFE8         
CODE_00EB2C:        A5 19         LDA RAM_MarioPowerUp      
CODE_00EB2E:        D0 04         BNE CODE_00EB34           
CODE_00EB30:        E8            INX                       
CODE_00EB31:        E8            INX                       
CODE_00EB32:        80 03         BRA CODE_00EB37           

CODE_00EB34:        20 E8 EF      JSR.W CODE_00EFE8         
CODE_00EB37:        20 4D F4      JSR.W CODE_00F44D         
CODE_00EB3A:        D0 DD         BNE CODE_00EB19           
CODE_00EB3C:        A9 02         LDA.B #$02                
CODE_00EB3E:        1C E3 13      TRB.W RAM_WallWalkStatus  
Return00EB41:       60            RTS                       ; Return 

ADDR_00EB42:        AD E3 13      LDA.W RAM_WallWalkStatus  
ADDR_00EB45:        29 01         AND.B #$01                
ADDR_00EB47:        A8            TAY                       
CODE_00EB48:        B9 BB EA      LDA.W DATA_00EABB,Y       
CODE_00EB4B:        85 7B         STA RAM_MarioSpeedX       
CODE_00EB4D:        98            TYA                       
CODE_00EB4E:        0A            ASL                       
CODE_00EB4F:        A8            TAY                       
CODE_00EB50:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00EB52:        A5 94         LDA RAM_MarioXPos         
CODE_00EB54:        18            CLC                       
CODE_00EB55:        79 BD EA      ADC.W DATA_00EABD,Y       
CODE_00EB58:        85 94         STA RAM_MarioXPos         
CODE_00EB5A:        A9 08 00      LDA.W #$0008              
CODE_00EB5D:        A4 19         LDY RAM_MarioPowerUp      
CODE_00EB5F:        F0 03         BEQ CODE_00EB64           
CODE_00EB61:        A9 10 00      LDA.W #$0010              
CODE_00EB64:        18            CLC                       
CODE_00EB65:        65 96         ADC RAM_MarioYPos         
CODE_00EB67:        85 96         STA RAM_MarioYPos         
CODE_00EB69:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00EB6B:        A9 24         LDA.B #$24                
CODE_00EB6D:        85 72         STA RAM_IsFlying          
CODE_00EB6F:        A9 E0         LDA.B #$E0                
CODE_00EB71:        85 7D         STA RAM_MarioSpeedY       
CODE_00EB73:        9C E3 13      STZ.W RAM_WallWalkStatus  
Return00EB76:       60            RTS                       ; Return 

CODE_00EB77:        A2 00         LDX.B #$00                
CODE_00EB79:        A5 19         LDA RAM_MarioPowerUp      
CODE_00EB7B:        F0 06         BEQ CODE_00EB83           
CODE_00EB7D:        A5 73         LDA RAM_IsDucking         
CODE_00EB7F:        D0 02         BNE CODE_00EB83           
CODE_00EB81:        A2 18         LDX.B #$18                
CODE_00EB83:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_00EB86:        F0 05         BEQ CODE_00EB8D           
CODE_00EB88:        8A            TXA                       
CODE_00EB89:        18            CLC                       
CODE_00EB8A:        69 30         ADC.B #$30                
CODE_00EB8C:        AA            TAX                       
CODE_00EB8D:        A5 94         LDA RAM_MarioXPos         
CODE_00EB8F:        29 0F         AND.B #$0F                
CODE_00EB91:        A8            TAY                       
CODE_00EB92:        18            CLC                       
CODE_00EB93:        69 08         ADC.B #$08                
CODE_00EB95:        29 0F         AND.B #$0F                
CODE_00EB97:        85 92         STA $92                   
CODE_00EB99:        64 93         STZ $93                   
CODE_00EB9B:        C0 08         CPY.B #$08                
CODE_00EB9D:        90 06         BCC CODE_00EBA5           
CODE_00EB9F:        8A            TXA                       
CODE_00EBA0:        69 0B         ADC.B #$0B                
CODE_00EBA2:        AA            TAX                       
CODE_00EBA3:        E6 93         INC $93                   
CODE_00EBA5:        A5 90         LDA $90                   
CODE_00EBA7:        18            CLC                       
CODE_00EBA8:        7D A4 E8      ADC.W DATA_00E8A4,X       
CODE_00EBAB:        29 0F         AND.B #$0F                
CODE_00EBAD:        85 91         STA $91                   
CODE_00EBAF:        20 4D F4      JSR.W CODE_00F44D         
CODE_00EBB2:        F0 29         BEQ CODE_00EBDD           
CODE_00EBB4:        C0 11         CPY.B #$11                
CODE_00EBB6:        90 6C         BCC CODE_00EC24           
CODE_00EBB8:        C0 6E         CPY.B #$6E                
CODE_00EBBA:        90 0D         BCC CODE_00EBC9           
CODE_00EBBC:        98            TYA                       
CODE_00EBBD:        22 4D F0 00   JSL.L CODE_00F04D         
CODE_00EBC1:        90 61         BCC CODE_00EC24           
ADDR_00EBC3:        A9 01         LDA.B #$01                
ADDR_00EBC5:        04 8A         TSB $8A                   
ADDR_00EBC7:        80 5B         BRA CODE_00EC24           

CODE_00EBC9:        E8            INX                       
CODE_00EBCA:        E8            INX                       
CODE_00EBCB:        E8            INX                       
CODE_00EBCC:        E8            INX                       
CODE_00EBCD:        98            TYA                       
CODE_00EBCE:        A0 00         LDY.B #$00                
CODE_00EBD0:        C9 1E         CMP.B #$1E                
CODE_00EBD2:        F0 06         BEQ CODE_00EBDA           
CODE_00EBD4:        C9 52         CMP.B #$52                
CODE_00EBD6:        F0 02         BEQ CODE_00EBDA           
CODE_00EBD8:        A0 02         LDY.B #$02                
CODE_00EBDA:        4C 6F EC      JMP.W CODE_00EC6F         

CODE_00EBDD:        C0 9C         CPY.B #$9C                
CODE_00EBDF:        D0 07         BNE CODE_00EBE8           
CODE_00EBE1:        AD 31 19      LDA.W $1931               
CODE_00EBE4:        C9 01         CMP.B #$01                
CODE_00EBE6:        F0 1E         BEQ CODE_00EC06           
CODE_00EBE8:        C0 20         CPY.B #$20                
CODE_00EBEA:        F0 15         BEQ CODE_00EC01           
CODE_00EBEC:        C0 1F         CPY.B #$1F                
CODE_00EBEE:        F0 0D         BEQ CODE_00EBFD           
CODE_00EBF0:        AD AD 14      LDA.W RAM_BluePowTimer    
CODE_00EBF3:        F0 2C         BEQ CODE_00EC21           
CODE_00EBF5:        C0 28         CPY.B #$28                
CODE_00EBF7:        F0 08         BEQ CODE_00EC01           
CODE_00EBF9:        C0 27         CPY.B #$27                
CODE_00EBFB:        D0 24         BNE CODE_00EC21           
CODE_00EBFD:        A5 19         LDA RAM_MarioPowerUp      
CODE_00EBFF:        D0 23         BNE CODE_00EC24           
CODE_00EC01:        20 43 F4      JSR.W CODE_00F443         
CODE_00EC04:        B0 1E         BCS CODE_00EC24           
CODE_00EC06:        A5 8F         LDA $8F                   
CODE_00EC08:        D0 1A         BNE CODE_00EC24           
CODE_00EC0A:        A5 16         LDA $16                   
CODE_00EC0C:        29 08         AND.B #$08                
CODE_00EC0E:        F0 14         BEQ CODE_00EC24           
CODE_00EC10:        A9 0F         LDA.B #$0F                ; \ Play sound effect 
CODE_00EC12:        8D FC 1D      STA.W $1DFC               ; / 
CODE_00EC15:        20 73 D2      JSR.W CODE_00D273         
CODE_00EC18:        A9 0D         LDA.B #$0D                
CODE_00EC1A:        85 71         STA RAM_MarioAnimation    
CODE_00EC1C:        20 2D F6      JSR.W NoButtons           
CODE_00EC1F:        80 03         BRA CODE_00EC24           

CODE_00EC21:        20 8C F2      JSR.W CODE_00F28C         
CODE_00EC24:        20 4D F4      JSR.W CODE_00F44D         
CODE_00EC27:        F0 0C         BEQ CODE_00EC35           
CODE_00EC29:        C0 11         CPY.B #$11                
CODE_00EC2B:        90 0D         BCC CODE_00EC3A           
CODE_00EC2D:        C0 6E         CPY.B #$6E                
CODE_00EC2F:        B0 09         BCS CODE_00EC3A           
CODE_00EC31:        E8            INX                       
CODE_00EC32:        E8            INX                       
CODE_00EC33:        80 19         BRA CODE_00EC4E           

CODE_00EC35:        A9 10         LDA.B #$10                
CODE_00EC37:        20 C9 F2      JSR.W CODE_00F2C9         
CODE_00EC3A:        20 4D F4      JSR.W CODE_00F44D         
CODE_00EC3D:        D0 07         BNE CODE_00EC46           
CODE_00EC3F:        A9 08         LDA.B #$08                
CODE_00EC41:        20 C9 F2      JSR.W CODE_00F2C9         
CODE_00EC44:        80 44         BRA CODE_00EC8A           

CODE_00EC46:        C0 11         CPY.B #$11                
CODE_00EC48:        90 40         BCC CODE_00EC8A           
CODE_00EC4A:        C0 6E         CPY.B #$6E                
CODE_00EC4C:        B0 3C         BCS CODE_00EC8A           
CODE_00EC4E:        A5 76         LDA RAM_MarioDirection    
CODE_00EC50:        C5 93         CMP $93                   
CODE_00EC52:        F0 0B         BEQ CODE_00EC5F           
CODE_00EC54:        20 C4 F3      JSR.W CODE_00F3C4         
CODE_00EC57:        DA            PHX                       
CODE_00EC58:        20 67 F2      JSR.W CODE_00F267         
CODE_00EC5B:        AC 93 16      LDY.W $1693               ; Current MAP16 tile number 
CODE_00EC5E:        FA            PLX                       
CODE_00EC5F:        A9 03         LDA.B #$03                
CODE_00EC61:        8D E5 13      STA.W $13E5               
CODE_00EC64:        A4 93         LDY $93                   
CODE_00EC66:        A5 94         LDA RAM_MarioXPos         
CODE_00EC68:        29 0F         AND.B #$0F                
CODE_00EC6A:        D9 11 E9      CMP.W DATA_00E911,Y       
CODE_00EC6D:        F0 1B         BEQ CODE_00EC8A           
CODE_00EC6F:        AD 02 14      LDA.W $1402               
CODE_00EC72:        F0 07         BEQ CODE_00EC7B           
CODE_00EC74:        AD 93 16      LDA.W $1693               
CODE_00EC77:        C9 52         CMP.B #$52                
CODE_00EC79:        F0 0F         BEQ CODE_00EC8A           
CODE_00EC7B:        B9 0A E9      LDA.W DATA_00E90A,Y       
CODE_00EC7E:        04 77         TSB RAM_MarioObjStatus    
CODE_00EC80:        29 03         AND.B #$03                
CODE_00EC82:        A8            TAY                       
CODE_00EC83:        AD 93 16      LDA.W $1693               ; Current MAP16 tile number 
CODE_00EC86:        22 27 F1 00   JSL.L CODE_00F127         
CODE_00EC8A:        20 4D F4      JSR.W CODE_00F44D         
CODE_00EC8D:        D0 22         BNE CODE_00ECB1           
CODE_00EC8F:        A9 02         LDA.B #$02                
CODE_00EC91:        20 C2 F2      JSR.W CODE_00F2C2         
CODE_00EC94:        A4 7D         LDY RAM_MarioSpeedY       
CODE_00EC96:        10 0B         BPL CODE_00ECA3           
CODE_00EC98:        AD 93 16      LDA.W $1693               ; Current MAP16 tile number 
CODE_00EC9B:        C9 21         CMP.B #$21                
CODE_00EC9D:        90 04         BCC CODE_00ECA3           
CODE_00EC9F:        C9 25         CMP.B #$25                
CODE_00ECA1:        90 03         BCC CODE_00ECA6           
CODE_00ECA3:        4C 4A ED      JMP.W CODE_00ED4A         

CODE_00ECA6:        38            SEC                       
CODE_00ECA7:        E9 04         SBC.B #$04                
CODE_00ECA9:        A0 00         LDY.B #$00                
CODE_00ECAB:        22 7F F1 00   JSL.L CODE_00F17F         
CODE_00ECAF:        80 5C         BRA CODE_00ED0D           

CODE_00ECB1:        C0 11         CPY.B #$11                
CODE_00ECB3:        90 EE         BCC CODE_00ECA3           
CODE_00ECB5:        C0 6E         CPY.B #$6E                
CODE_00ECB7:        90 41         BCC CODE_00ECFA           
CODE_00ECB9:        C0 D8         CPY.B #$D8                
CODE_00ECBB:        90 1D         BCC CODE_00ECDA           
CODE_00ECBD:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00ECBF:        A5 98         LDA RAM_BlockXLo          
CODE_00ECC1:        18            CLC                       
CODE_00ECC2:        69 10 00      ADC.W #$0010              
CODE_00ECC5:        85 98         STA RAM_BlockXLo          
CODE_00ECC7:        20 61 F4      JSR.W CODE_00F461         
CODE_00ECCA:        F0 2C         BEQ CODE_00ECF8           
CODE_00ECCC:        C0 6E         CPY.B #$6E                
CODE_00ECCE:        90 7A         BCC CODE_00ED4A           
CODE_00ECD0:        C0 D8         CPY.B #$D8                
CODE_00ECD2:        B0 76         BCS CODE_00ED4A           
CODE_00ECD4:        A5 91         LDA $91                   ; Accum (8 bit) 
CODE_00ECD6:        E9 0F         SBC.B #$0F                
CODE_00ECD8:        85 91         STA $91                   
CODE_00ECDA:        98            TYA                       
CODE_00ECDB:        38            SEC                       
CODE_00ECDC:        E9 6E         SBC.B #$6E                
CODE_00ECDE:        A8            TAY                       
CODE_00ECDF:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00ECE1:        B7 82         LDA [$82],Y               
CODE_00ECE3:        29 FF 00      AND.W #$00FF              
CODE_00ECE6:        0A            ASL                       
CODE_00ECE7:        0A            ASL                       
CODE_00ECE8:        0A            ASL                       
CODE_00ECE9:        0A            ASL                       
CODE_00ECEA:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00ECEC:        05 92         ORA $92                   
CODE_00ECEE:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_00ECF0:        A8            TAY                       
CODE_00ECF1:        B9 32 E6      LDA.W DATA_00E632,Y       
CODE_00ECF4:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_00ECF6:        30 17         BMI CODE_00ED0F           
CODE_00ECF8:        80 50         BRA CODE_00ED4A           

CODE_00ECFA:        A9 02         LDA.B #$02                
CODE_00ECFC:        20 E9 F3      JSR.W CODE_00F3E9         
CODE_00ECFF:        98            TYA                       
CODE_00ED00:        A0 00         LDY.B #$00                
CODE_00ED02:        22 27 F1 00   JSL.L CODE_00F127         
CODE_00ED06:        AD 93 16      LDA.W $1693               ; Current MAP16 tile number 
CODE_00ED09:        C9 1E         CMP.B #$1E                ; \ If block is turn block, branch to $ED3B 
CODE_00ED0B:        F0 2E         BEQ CODE_00ED3B           ; /  
CODE_00ED0D:        A9 F0         LDA.B #$F0                
CODE_00ED0F:        18            CLC                       
CODE_00ED10:        65 91         ADC $91                   
CODE_00ED12:        10 36         BPL CODE_00ED4A           
CODE_00ED14:        C9 F9         CMP.B #$F9                
CODE_00ED16:        B0 10         BCS CODE_00ED28           
CODE_00ED18:        A4 72         LDY RAM_IsFlying          
CODE_00ED1A:        D0 0C         BNE CODE_00ED28           
CODE_00ED1C:        A5 77         LDA RAM_MarioObjStatus    
CODE_00ED1E:        29 FC         AND.B #$FC                
CODE_00ED20:        09 09         ORA.B #$09                
CODE_00ED22:        85 77         STA RAM_MarioObjStatus    
CODE_00ED24:        64 7B         STZ RAM_MarioSpeedX       
CODE_00ED26:        80 13         BRA CODE_00ED3B           

CODE_00ED28:        A4 72         LDY RAM_IsFlying          
CODE_00ED2A:        F0 0B         BEQ CODE_00ED37           
CODE_00ED2C:        49 FF         EOR.B #$FF                
CODE_00ED2E:        18            CLC                       
CODE_00ED2F:        65 96         ADC RAM_MarioYPos         
CODE_00ED31:        85 96         STA RAM_MarioYPos         
CODE_00ED33:        90 02         BCC CODE_00ED37           
CODE_00ED35:        E6 97         INC RAM_MarioYPosHi       
CODE_00ED37:        A9 08         LDA.B #$08                
CODE_00ED39:        04 77         TSB RAM_MarioObjStatus    
CODE_00ED3B:        A5 7D         LDA RAM_MarioSpeedY       
CODE_00ED3D:        10 0B         BPL CODE_00ED4A           
CODE_00ED3F:        64 7D         STZ RAM_MarioSpeedY       
CODE_00ED41:        AD F9 1D      LDA.W $1DF9               ; / Play sound effect 
CODE_00ED44:        D0 04         BNE CODE_00ED4A           
CODE_00ED46:        1A            INC A                     
CODE_00ED47:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_00ED4A:        20 4D F4      JSR.W CODE_00F44D         
CODE_00ED4D:        D0 03         BNE CODE_00ED52           
CODE_00ED4F:        4C DB ED      JMP.W CODE_00EDDB         

CODE_00ED52:        C0 6E         CPY.B #$6E                
CODE_00ED54:        B0 08         BCS CODE_00ED5E           
CODE_00ED56:        A9 03         LDA.B #$03                
CODE_00ED58:        20 E9 F3      JSR.W CODE_00F3E9         
CODE_00ED5B:        4C F7 ED      JMP.W CODE_00EDF7         

CODE_00ED5E:        C0 D8         CPY.B #$D8                
CODE_00ED60:        90 24         BCC CODE_00ED86           
CODE_00ED62:        C0 FB         CPY.B #$FB                
CODE_00ED64:        90 03         BCC CODE_00ED69           
CODE_00ED66:        4C 29 F6      JMP.W CODE_00F629         

CODE_00ED69:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00ED6B:        A5 98         LDA RAM_BlockXLo          
CODE_00ED6D:        38            SEC                       
CODE_00ED6E:        E9 10 00      SBC.W #$0010              
CODE_00ED71:        85 98         STA RAM_BlockXLo          
CODE_00ED73:        20 61 F4      JSR.W CODE_00F461         
CODE_00ED76:        F0 71         BEQ CODE_00EDE9           
CODE_00ED78:        C0 6E         CPY.B #$6E                
CODE_00ED7A:        90 6D         BCC CODE_00EDE9           
CODE_00ED7C:        C0 D8         CPY.B #$D8                
CODE_00ED7E:        B0 69         BCS CODE_00EDE9           
CODE_00ED80:        A5 90         LDA $90                   ; Accum (8 bit) 
CODE_00ED82:        69 10         ADC.B #$10                
CODE_00ED84:        85 90         STA $90                   
CODE_00ED86:        AD 31 19      LDA.W $1931               
CODE_00ED89:        C9 03         CMP.B #$03                
CODE_00ED8B:        F0 04         BEQ CODE_00ED91           
CODE_00ED8D:        C9 0E         CMP.B #$0E                
CODE_00ED8F:        D0 04         BNE CODE_00ED95           
CODE_00ED91:        C0 D2         CPY.B #$D2                
CODE_00ED93:        B0 54         BCS CODE_00EDE9           
CODE_00ED95:        98            TYA                       
CODE_00ED96:        38            SEC                       
CODE_00ED97:        E9 6E         SBC.B #$6E                
CODE_00ED99:        A8            TAY                       
CODE_00ED9A:        B7 82         LDA [$82],Y               
CODE_00ED9C:        48            PHA                       
CODE_00ED9D:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00ED9F:        29 FF 00      AND.W #$00FF              
CODE_00EDA2:        0A            ASL                       
CODE_00EDA3:        0A            ASL                       
CODE_00EDA4:        0A            ASL                       
CODE_00EDA5:        0A            ASL                       
CODE_00EDA6:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00EDA8:        05 92         ORA $92                   
CODE_00EDAA:        DA            PHX                       
CODE_00EDAB:        C2 10         REP #$10                  ; Index (16 bit) 
CODE_00EDAD:        AA            TAX                       
CODE_00EDAE:        A5 90         LDA $90                   
CODE_00EDB0:        38            SEC                       
CODE_00EDB1:        FD 32 E6      SBC.W DATA_00E632,X       
CODE_00EDB4:        10 03         BPL CODE_00EDB9           
CODE_00EDB6:        EE EF 13      INC.W $13EF               
CODE_00EDB9:        E2 10         SEP #$10                  ; Index (8 bit) 
CODE_00EDBB:        FA            PLX                       
CODE_00EDBC:        7A            PLY                       
CODE_00EDBD:        D9 1C E5      CMP.W DATA_00E51C,Y       
CODE_00EDC0:        B0 27         BCS CODE_00EDE9           
CODE_00EDC2:        85 91         STA $91                   
CODE_00EDC4:        64 90         STZ $90                   
CODE_00EDC6:        20 05 F0      JSR.W CODE_00F005         
CODE_00EDC9:        C0 1C         CPY.B #$1C                
CODE_00EDCB:        90 08         BCC CODE_00EDD5           
CODE_00EDCD:        A9 08         LDA.B #$08                
CODE_00EDCF:        8D A1 14      STA.W $14A1               
CODE_00EDD2:        4C D1 EE      JMP.W CODE_00EED1         

CODE_00EDD5:        20 BC EF      JSR.W CODE_00EFBC         
CODE_00EDD8:        4C 85 EE      JMP.W CODE_00EE85         

CODE_00EDDB:        C0 05         CPY.B #$05                
CODE_00EDDD:        D0 05         BNE CODE_00EDE4           
CODE_00EDDF:        20 29 F6      JSR.W CODE_00F629         
CODE_00EDE2:        80 05         BRA CODE_00EDE9           

CODE_00EDE4:        A9 04         LDA.B #$04                
CODE_00EDE6:        20 C2 F2      JSR.W CODE_00F2C2         
CODE_00EDE9:        20 4D F4      JSR.W CODE_00F44D         
CODE_00EDEC:        D0 05         BNE CODE_00EDF3           
CODE_00EDEE:        20 09 F3      JSR.W CODE_00F309         
CODE_00EDF1:        80 2A         BRA CODE_00EE1D           

CODE_00EDF3:        C0 6E         CPY.B #$6E                
CODE_00EDF5:        B0 26         BCS CODE_00EE1D           
CODE_00EDF7:        A5 7D         LDA RAM_MarioSpeedY       
CODE_00EDF9:        30 3E         BMI Return00EE39          
CODE_00EDFB:        AD 31 19      LDA.W $1931               
CODE_00EDFE:        C9 03         CMP.B #$03                
CODE_00EE00:        F0 04         BEQ CODE_00EE06           
CODE_00EE02:        C9 0E         CMP.B #$0E                
CODE_00EE04:        D0 0B         BNE CODE_00EE11           
CODE_00EE06:        AC 93 16      LDY.W $1693               ; $ED3B 
CODE_00EE09:        C0 59         CPY.B #$59                
CODE_00EE0B:        90 04         BCC CODE_00EE11           
CODE_00EE0D:        C0 5C         CPY.B #$5C                
CODE_00EE0F:        90 0C         BCC CODE_00EE1D           
CODE_00EE11:        A5 90         LDA $90                   
CODE_00EE13:        29 0F         AND.B #$0F                
CODE_00EE15:        64 90         STZ $90                   
CODE_00EE17:        C9 08         CMP.B #$08                
CODE_00EE19:        85 91         STA $91                   
CODE_00EE1B:        90 1D         BCC CODE_00EE3A           
CODE_00EE1D:        AD 71 14      LDA.W $1471               ; \ If Mario isn't on a sprite platform, 
CODE_00EE20:        F0 0B         BEQ CODE_00EE2D           ; / branch to $EE2D 
CODE_00EE22:        A5 7D         LDA RAM_MarioSpeedY       ; \ If Mario is moving up, 
CODE_00EE24:        30 07         BMI CODE_00EE2D           ; / branch to $EE2D 
CODE_00EE26:        64 8E         STZ $8E                   
CODE_00EE28:        A0 20         LDY.B #$20                
CODE_00EE2A:        4C E1 EE      JMP.W CODE_00EEE1         

CODE_00EE2D:        A5 77         LDA RAM_MarioObjStatus    ; \  
CODE_00EE2F:        29 04         AND.B #$04                ;  |If Mario is on an edge or in air, 
CODE_00EE31:        05 72         ORA RAM_IsFlying          ;  |branch to $EE39 
CODE_00EE33:        D0 04         BNE Return00EE39          ; /  
CODE_00EE35:        A9 24         LDA.B #$24                ; \ Set "In air" to x24 (falling) 
CODE_00EE37:        85 72         STA RAM_IsFlying          ; /  
Return00EE39:       60            RTS                       ; Return 

CODE_00EE3A:        AC 93 16      LDY.W $1693               ; Current MAP16 tile number 
CODE_00EE3D:        AD 31 19      LDA.W $1931               ; Tileset 
CODE_00EE40:        C9 02         CMP.B #$02                ; \ If tileset is "Rope 1", 
CODE_00EE42:        F0 04         BEQ CODE_00EE48           ; / branch to $EE48 
CODE_00EE44:        C9 08         CMP.B #$08                ; \ If tileset isn't "Rope 3", 
CODE_00EE46:        D0 0F         BNE CODE_00EE57           ; / branch to $EE57 
CODE_00EE48:        98            TYA                       ; \  
CODE_00EE49:        38            SEC                       ;  |If the current tile isn't Rope 3's "Conveyor rope", 
CODE_00EE4A:        E9 0C         SBC.B #$0C                ;  |branch to $EE57 
CODE_00EE4C:        C9 02         CMP.B #$02                ;  | 
CODE_00EE4E:        B0 07         BCS CODE_00EE57           ; /  
ADDR_00EE50:        0A            ASL                       
ADDR_00EE51:        AA            TAX                       
ADDR_00EE52:        20 CD EF      JSR.W CODE_00EFCD         
ADDR_00EE55:        80 2C         BRA CODE_00EE83           

CODE_00EE57:        20 67 F2      JSR.W CODE_00F267         
CODE_00EE5A:        A0 03         LDY.B #$03                
CODE_00EE5C:        AD 93 16      LDA.W $1693               ; Current MAP16 tile number 
CODE_00EE5F:        C9 1E         CMP.B #$1E                ; \ If block isn't "Turn block", 
CODE_00EE61:        D0 15         BNE CODE_00EE78           ; / branch to $EE78 
CODE_00EE63:        A6 8F         LDX $8F                   
CODE_00EE65:        F0 1C         BEQ CODE_00EE83           
CODE_00EE67:        A6 19         LDX RAM_MarioPowerUp      
CODE_00EE69:        F0 18         BEQ CODE_00EE83           
CODE_00EE6B:        AE 0D 14      LDX.W RAM_IsSpinJump      
CODE_00EE6E:        F0 13         BEQ CODE_00EE83           
CODE_00EE70:        A9 21         LDA.B #$21                
CODE_00EE72:        22 7F F1 00   JSL.L CODE_00F17F         
CODE_00EE76:        80 A5         BRA CODE_00EE1D           

CODE_00EE78:        C9 32         CMP.B #$32                ; \ If block isn't "Brown block", 
CODE_00EE7A:        D0 03         BNE CODE_00EE7F           ; / branch to $EE7F 
CODE_00EE7C:        9C 09 19      STZ.W $1909               
CODE_00EE7F:        22 20 F1 00   JSL.L CODE_00F120         
CODE_00EE83:        A0 20         LDY.B #$20                
CODE_00EE85:        A5 7D         LDA RAM_MarioSpeedY       ; \ If Mario isn't moving up, 
CODE_00EE87:        10 06         BPL CODE_00EE8F           ; / branch to $EE8F 
CODE_00EE89:        A5 8D         LDA $8D                   
CODE_00EE8B:        C9 02         CMP.B #$02                
CODE_00EE8D:        90 AA         BCC Return00EE39          
CODE_00EE8F:        AE 23 14      LDX.W $1423               
CODE_00EE92:        F0 3D         BEQ CODE_00EED1           
CODE_00EE94:        CA            DEX                       
CODE_00EE95:        8A            TXA                       
CODE_00EE96:        29 03         AND.B #$03                
CODE_00EE98:        F0 10         BEQ CODE_00EEAA           
CODE_00EE9A:        C9 02         CMP.B #$02                
CODE_00EE9C:        B0 33         BCS CODE_00EED1           
CODE_00EE9E:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00EEA0:        A5 9A         LDA RAM_BlockYLo          
CODE_00EEA2:        38            SEC                       
CODE_00EEA3:        E9 10 00      SBC.W #$0010              
CODE_00EEA6:        85 9A         STA RAM_BlockYLo          
CODE_00EEA8:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00EEAA:        8A            TXA                       
CODE_00EEAB:        4A            LSR                       
CODE_00EEAC:        4A            LSR                       
CODE_00EEAD:        AA            TAX                       
CODE_00EEAE:        BD 27 1F      LDA.W $1F27,X             ; \ If switch block is already active, 
CODE_00EEB1:        D0 1E         BNE CODE_00EED1           ; / branch to $EED1 
CODE_00EEB3:        1A            INC A                     ; \ Activate switch block 
CODE_00EEB4:        9D 27 1F      STA.W $1F27,X             ; /  
CODE_00EEB7:        8D D2 13      STA.W $13D2               
CODE_00EEBA:        5A            PHY                       
CODE_00EEBB:        8E 1E 19      STX.W $191E               
CODE_00EEBE:        20 45 FA      JSR.W FlatPalaceSwitch    
CODE_00EEC1:        7A            PLY                       
CODE_00EEC2:        A9 0C         LDA.B #$0C                
CODE_00EEC4:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_00EEC7:        A9 FF         LDA.B #$FF                ; \  
CODE_00EEC9:        8D DA 0D      STA.W $0DDA               ; / Set music to xFF 
CODE_00EECC:        A9 08         LDA.B #$08                
CODE_00EECE:        8D 93 14      STA.W $1493               
CODE_00EED1:        EE EF 13      INC.W $13EF               
CODE_00EED4:        A5 96         LDA RAM_MarioYPos         
CODE_00EED6:        38            SEC                       
CODE_00EED7:        E5 91         SBC $91                   
CODE_00EED9:        85 96         STA RAM_MarioYPos         
CODE_00EEDB:        A5 97         LDA RAM_MarioYPosHi       
CODE_00EEDD:        E5 90         SBC $90                   
CODE_00EEDF:        85 97         STA RAM_MarioYPosHi       
CODE_00EEE1:        B9 3D E5      LDA.W DATA_00E53D,Y       
CODE_00EEE4:        D0 09         BNE CODE_00EEEF           
CODE_00EEE6:        AE ED 13      LDX.W $13ED               
CODE_00EEE9:        F0 1A         BEQ CODE_00EF05           
CODE_00EEEB:        A6 7B         LDX RAM_MarioSpeedX       
CODE_00EEED:        F0 13         BEQ CODE_00EF02           
CODE_00EEEF:        8D EE 13      STA.W $13EE               
CODE_00EEF2:        A5 15         LDA RAM_ControllerA       
CODE_00EEF4:        29 04         AND.B #$04                
CODE_00EEF6:        F0 0D         BEQ CODE_00EF05           
CODE_00EEF8:        AD 8F 14      LDA.W $148F               
CODE_00EEFB:        0D ED 13      ORA.W $13ED               
CODE_00EEFE:        D0 05         BNE CODE_00EF05           
CODE_00EF00:        A2 1C         LDX.B #$1C                
CODE_00EF02:        8E ED 13      STX.W $13ED               
CODE_00EF05:        BE B9 E4      LDX.W DATA_00E4B9,Y       
CODE_00EF08:        8E E1 13      STX.W $13E1               
CODE_00EF0B:        C0 1C         CPY.B #$1C                
CODE_00EF0D:        B0 29         BCS CODE_00EF38           
CODE_00EF0F:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00EF11:        F0 1E         BEQ CODE_00EF31           
CODE_00EF13:        B9 3D E5      LDA.W DATA_00E53D,Y       
CODE_00EF16:        F0 19         BEQ CODE_00EF31           
CODE_00EF18:        45 7B         EOR RAM_MarioSpeedX       
CODE_00EF1A:        10 15         BPL CODE_00EF31           
CODE_00EF1C:        8E E5 13      STX.W $13E5               
CODE_00EF1F:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00EF21:        10 03         BPL CODE_00EF26           
CODE_00EF23:        49 FF         EOR.B #$FF                
CODE_00EF25:        1A            INC A                     
CODE_00EF26:        C9 28         CMP.B #$28                
CODE_00EF28:        90 05         BCC CODE_00EF2F           
CODE_00EF2A:        B9 FB E4      LDA.W DATA_00E4FB,Y       
CODE_00EF2D:        80 31         BRA CODE_00EF60           

CODE_00EF2F:        A0 20         LDY.B #$20                
CODE_00EF31:        A5 7D         LDA RAM_MarioSpeedY       
CODE_00EF33:        D9 DA E4      CMP.W DATA_00E4DA,Y       
CODE_00EF36:        90 03         BCC CODE_00EF3B           
CODE_00EF38:        B9 DA E4      LDA.W DATA_00E4DA,Y       
CODE_00EF3B:        A6 8E         LDX $8E                   
CODE_00EF3D:        10 21         BPL CODE_00EF60           
CODE_00EF3F:        EE 0E 14      INC.W $140E               
CODE_00EF42:        48            PHA                       
CODE_00EF43:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00EF45:        AD BE 17      LDA.W $17BE               
CODE_00EF48:        29 00 FF      AND.W #$FF00              
CODE_00EF4B:        10 03         BPL CODE_00EF50           
CODE_00EF4D:        09 FF 00      ORA.W #$00FF              
CODE_00EF50:        EB            XBA                       
CODE_00EF51:        49 FF FF      EOR.W #$FFFF              
CODE_00EF54:        1A            INC A                     
CODE_00EF55:        18            CLC                       
CODE_00EF56:        65 94         ADC RAM_MarioXPos         
CODE_00EF58:        85 94         STA RAM_MarioXPos         
CODE_00EF5A:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00EF5C:        68            PLA                       
CODE_00EF5D:        18            CLC                       
CODE_00EF5E:        69 28         ADC.B #$28                
CODE_00EF60:        85 7D         STA RAM_MarioSpeedY       
CODE_00EF62:        AA            TAX                       
CODE_00EF63:        10 03         BPL CODE_00EF68           
CODE_00EF65:        EE EF 13      INC.W $13EF               
CODE_00EF68:        9C B5 18      STZ.W $18B5               
CODE_00EF6B:        64 72         STZ RAM_IsFlying          
CODE_00EF6D:        64 74         STZ RAM_IsClimbing        
CODE_00EF6F:        9C 06 14      STZ.W $1406               
CODE_00EF72:        9C 0D 14      STZ.W RAM_IsSpinJump      
CODE_00EF75:        A9 04         LDA.B #$04                
CODE_00EF77:        04 77         TSB RAM_MarioObjStatus    
CODE_00EF79:        AC 07 14      LDY.W $1407               
CODE_00EF7C:        D0 1B         BNE CODE_00EF99           
CODE_00EF7E:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_00EF81:        F0 12         BEQ CODE_00EF95           
CODE_00EF83:        A5 8F         LDA $8F                   
CODE_00EF85:        F0 0E         BEQ CODE_00EF95           
CODE_00EF87:        AD E7 18      LDA.W RAM_YoshiHasStomp   ; \ If Yoshi has stomp ability, 
CODE_00EF8A:        F0 09         BEQ CODE_00EF95           ;  | 
CODE_00EF8C:        22 BF 86 02   JSL.L YoshiStompRoutine   ;  | Run routine 
CODE_00EF90:        A9 25         LDA.B #$25                ;  | Play sound effect 
CODE_00EF92:        8D FC 1D      STA.W $1DFC               ; / 
CODE_00EF95:        9C 97 16      STZ.W $1697               
Return00EF98:       60            RTS                       ; Return 

CODE_00EF99:        9C 97 16      STZ.W $1697               
CODE_00EF9C:        9C 07 14      STZ.W $1407               
CODE_00EF9F:        C0 05         CPY.B #$05                
CODE_00EFA1:        B0 0B         BCS CallGroundPound       
CODE_00EFA3:        A5 19         LDA RAM_MarioPowerUp      
CODE_00EFA5:        C9 02         CMP.B #$02                
CODE_00EFA7:        D0 04         BNE Return00EFAD          
CODE_00EFA9:        38            SEC                       
CODE_00EFAA:        6E ED 13      ROR.W $13ED               
Return00EFAD:       60            RTS                       ; Return 

CallGroundPound:    A5 8F         LDA $8F                   
CODE_00EFB0:        F0 09         BEQ Return00EFBB          
CODE_00EFB2:        22 C1 94 02   JSL.L GroundPound         
CODE_00EFB6:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_00EFB8:        8D FC 1D      STA.W $1DFC               ; / 
Return00EFBB:       60            RTS                       ; Return 

CODE_00EFBC:        AE 93 16      LDX.W $1693               
CODE_00EFBF:        E0 CE         CPX.B #$CE                
CODE_00EFC1:        90 24         BCC Return00EFE7          
CODE_00EFC3:        E0 D2         CPX.B #$D2                
CODE_00EFC5:        B0 20         BCS Return00EFE7          
CODE_00EFC7:        8A            TXA                       
CODE_00EFC8:        38            SEC                       
CODE_00EFC9:        E9 CC         SBC.B #$CC                
CODE_00EFCB:        0A            ASL                       
CODE_00EFCC:        AA            TAX                       
CODE_00EFCD:        A5 13         LDA RAM_FrameCounter      
CODE_00EFCF:        29 03         AND.B #$03                
CODE_00EFD1:        D0 14         BNE Return00EFE7          
CODE_00EFD3:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00EFD5:        A5 94         LDA RAM_MarioXPos         
CODE_00EFD7:        18            CLC                       
CODE_00EFD8:        7D 13 E9      ADC.W DATA_00E913,X       
CODE_00EFDB:        85 94         STA RAM_MarioXPos         
CODE_00EFDD:        A5 96         LDA RAM_MarioYPos         
CODE_00EFDF:        18            CLC                       
CODE_00EFE0:        7D 1F E9      ADC.W DATA_00E91F,X       
CODE_00EFE3:        85 96         STA RAM_MarioYPos         
CODE_00EFE5:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return00EFE7:       60            RTS                       ; Return 

CODE_00EFE8:        20 4D F4      JSR.W CODE_00F44D         
CODE_00EFEB:        D0 03         BNE ADDR_00EFF0           
CODE_00EFED:        4C 09 F3      JMP.W CODE_00F309         

ADDR_00EFF0:        C0 11         CPY.B #$11                
ADDR_00EFF2:        90 10         BCC Return00F004          
ADDR_00EFF4:        C0 6E         CPY.B #$6E                
ADDR_00EFF6:        B0 0C         BCS Return00F004          
ADDR_00EFF8:        98            TYA                       
ADDR_00EFF9:        A0 00         LDY.B #$00                
ADDR_00EFFB:        22 60 F1 00   JSL.L CODE_00F160         
ADDR_00EFFF:        68            PLA                       
ADDR_00F000:        68            PLA                       
ADDR_00F001:        4C 42 EB      JMP.W ADDR_00EB42         

Return00F004:       60            RTS                       ; Return 

CODE_00F005:        98            TYA                       
CODE_00F006:        38            SEC                       
CODE_00F007:        E9 0E         SBC.B #$0E                
CODE_00F009:        C9 02         CMP.B #$02                
CODE_00F00B:        B0 3F         BCS Return00F04C          
CODE_00F00D:        49 01         EOR.B #$01                
CODE_00F00F:        C5 76         CMP RAM_MarioDirection    
CODE_00F011:        D0 39         BNE Return00F04C          
CODE_00F013:        AA            TAX                       
CODE_00F014:        4A            LSR                       
CODE_00F015:        A5 92         LDA $92                   
CODE_00F017:        90 02         BCC CODE_00F01B           
CODE_00F019:        49 0F         EOR.B #$0F                
CODE_00F01B:        C9 08         CMP.B #$08                
CODE_00F01D:        B0 2D         BCS Return00F04C          
CODE_00F01F:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_00F022:        F0 11         BEQ CODE_00F035           
CODE_00F024:        A9 08         LDA.B #$08                
CODE_00F026:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_00F029:        A9 80         LDA.B #$80                
CODE_00F02B:        85 7D         STA RAM_MarioSpeedY       
CODE_00F02D:        8D 06 14      STA.W $1406               
CODE_00F030:        68            PLA                       
CODE_00F031:        68            PLA                       
CODE_00F032:        4C 35 EE      JMP.W CODE_00EE35         

CODE_00F035:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00F037:        38            SEC                       
CODE_00F038:        FD B9 EA      SBC.W DATA_00EAB9,X       
CODE_00F03B:        5D B9 EA      EOR.W DATA_00EAB9,X       
CODE_00F03E:        30 0C         BMI Return00F04C          
CODE_00F040:        AD 8F 14      LDA.W $148F               
CODE_00F043:        05 73         ORA RAM_IsDucking         
CODE_00F045:        D0 05         BNE Return00F04C          
CODE_00F047:        E8            INX                       
CODE_00F048:        E8            INX                       
CODE_00F049:        8E E3 13      STX.W RAM_WallWalkStatus  
Return00F04C:       60            RTS                       ; Return 

CODE_00F04D:        DA            PHX                       
CODE_00F04E:        A2 19         LDX.B #$19                
CODE_00F050:        DF C1 EA 00   CMP.L DATA_00EAC1,X       
CODE_00F054:        F0 04         BEQ CODE_00F05A           
CODE_00F056:        CA            DEX                       
CODE_00F057:        10 F7         BPL CODE_00F050           
CODE_00F059:        18            CLC                       
CODE_00F05A:        FA            PLX                       
Return00F05B:       6B            RTL                       ; Return 


DATA_00F05C:                      .db $01,$05,$01,$02,$01,$01,$00,$00
                                  .db $00,$00,$00,$00,$00,$06,$02,$02
                                  .db $02,$02,$02,$02,$02,$02,$02,$02
                                  .db $02,$03,$03,$04,$02,$02,$02,$01
                                  .db $01,$07,$11,$10

DATA_00F080:                      .db $80,$00,$00,$1E,$00,$00,$05,$09
                                  .db $06,$81,$0E,$0C,$14,$00,$05,$09
                                  .db $06,$07,$0E,$0C,$16,$18,$1A,$1A
                                  .db $00,$09,$00,$00,$FF,$0C,$0A,$00
                                  .db $00,$00,$08,$02

DATA_00F0A4:                      .db $0C,$08,$0C,$08,$0C,$0F,$08,$08
                                  .db $08,$08,$08,$08,$08,$08,$08,$08
                                  .db $08,$08,$08,$08,$08,$08,$08,$08
                                  .db $08,$03,$03,$08,$08,$08,$08,$08
                                  .db $08,$04,$08,$08

DATA_00F0C8:                      .db $0E,$13,$0E,$0D,$0E,$10,$0D,$0D
                                  .db $0D,$0D,$0A,$0D,$0D,$0C,$0D,$0D
                                  .db $0D,$0D,$0B,$0D,$0D,$16,$0D,$0D
                                  .db $0D,$11,$11,$12,$0D,$0D,$0D,$0E
                                  .db $0F,$0C,$0D,$0D

DATA_00F0EC:                      .db $08,$01,$02,$04,$ED,$F6,$00,$7D
                                  .db $BE,$00,$6F,$B7

DATA_00F0F8:                      .db $40,$50,$00,$70,$80,$00,$A0,$B0
DATA_00F100:                      .db $05,$09,$06,$05,$09,$06,$05,$09
                                  .db $06,$05,$09,$06,$05,$09,$06,$05
                                  .db $07,$0A,$10,$07,$0A,$10,$07,$0A
                                  .db $10,$07,$0A,$10,$07,$0A,$10,$07

CODE_00F120:        EB            XBA                       
CODE_00F121:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_00F124:        D0 39         BNE CODE_00F15F           
CODE_00F126:        EB            XBA                       
CODE_00F127:        C9 2F         CMP.B #$2F                
CODE_00F129:        F0 29         BEQ CODE_00F154           
CODE_00F12B:        C9 59         CMP.B #$59                
CODE_00F12D:        90 15         BCC CODE_00F144           
CODE_00F12F:        C9 5C         CMP.B #$5C                
CODE_00F131:        B0 0D         BCS CODE_00F140           
CODE_00F133:        EB            XBA                       
CODE_00F134:        AD 31 19      LDA.W $1931               
CODE_00F137:        C9 05         CMP.B #$05                
CODE_00F139:        F0 19         BEQ CODE_00F154           
CODE_00F13B:        C9 0D         CMP.B #$0D                
CODE_00F13D:        F0 15         BEQ CODE_00F154           
CODE_00F13F:        EB            XBA                       
CODE_00F140:        C9 5D         CMP.B #$5D                
CODE_00F142:        90 08         BCC CODE_00F14C           
CODE_00F144:        C9 66         CMP.B #$66                
CODE_00F146:        90 18         BCC CODE_00F160           
CODE_00F148:        C9 6A         CMP.B #$6A                
CODE_00F14A:        B0 14         BCS CODE_00F160           
CODE_00F14C:        EB            XBA                       
CODE_00F14D:        AD 31 19      LDA.W $1931               
CODE_00F150:        C9 01         CMP.B #$01                
CODE_00F152:        D0 0B         BNE CODE_00F15F           
CODE_00F154:        8B            PHB                       
CODE_00F155:        A9 01         LDA.B #$01                
CODE_00F157:        48            PHA                       
CODE_00F158:        AB            PLB                       
CODE_00F159:        22 B7 F5 00   JSL.L HurtMario           
CODE_00F15D:        AB            PLB                       
Return00F15E:       6B            RTL                       ; Return 

CODE_00F15F:        EB            XBA                       
CODE_00F160:        38            SEC                       
CODE_00F161:        E9 11         SBC.B #$11                
CODE_00F163:        C9 1D         CMP.B #$1D                
CODE_00F165:        90 18         BCC CODE_00F17F           
CODE_00F167:        EB            XBA                       
CODE_00F168:        DA            PHX                       
CODE_00F169:        AE 31 19      LDX.W $1931               
CODE_00F16C:        BF 25 A6 00   LDA.L DATA_00A625,X       
CODE_00F170:        FA            PLX                       
CODE_00F171:        29 03         AND.B #$03                
CODE_00F173:        F0 01         BEQ CODE_00F176           
Return00F175:       6B            RTL                       ; Return 

CODE_00F176:        EB            XBA                       
CODE_00F177:        E9 59         SBC.B #$59                
CODE_00F179:        C9 02         CMP.B #$02                
CODE_00F17B:        B0 7B         BCS Return00F1F8          
CODE_00F17D:        69 22         ADC.B #$22                
CODE_00F17F:        DA            PHX                       
CODE_00F180:        48            PHA                       
CODE_00F181:        BB            TYX                       
CODE_00F182:        BF EC F0 00   LDA.L DATA_00F0EC,X       
CODE_00F186:        FA            PLX                       
CODE_00F187:        3F A4 F0 00   AND.L DATA_00F0A4,X       
CODE_00F18B:        F0 69         BEQ CODE_00F1F6           
CODE_00F18D:        84 06         STY $06                   
CODE_00F18F:        BF C8 F0 00   LDA.L DATA_00F0C8,X       
CODE_00F193:        85 07         STA $07                   
CODE_00F195:        BF 5C F0 00   LDA.L DATA_00F05C,X       
CODE_00F199:        85 04         STA $04                   
CODE_00F19B:        BF 80 F0 00   LDA.L DATA_00F080,X       
CODE_00F19F:        10 19         BPL CODE_00F1BA           
CODE_00F1A1:        C9 FF         CMP.B #$FF                
CODE_00F1A3:        D0 09         BNE CODE_00F1AE           
CODE_00F1A5:        A9 05         LDA.B #$05                
CODE_00F1A7:        AC C0 0D      LDY.W $0DC0               
CODE_00F1AA:        F0 24         BEQ CODE_00F1D0           
CODE_00F1AC:        80 20         BRA CODE_00F1CE           

CODE_00F1AE:        4A            LSR                       
CODE_00F1AF:        A5 9A         LDA RAM_BlockYLo          
CODE_00F1B1:        6A            ROR                       
CODE_00F1B2:        4A            LSR                       
CODE_00F1B3:        4A            LSR                       
CODE_00F1B4:        4A            LSR                       
CODE_00F1B5:        AA            TAX                       
CODE_00F1B6:        BF 00 F1 00   LDA.L DATA_00F100,X       
CODE_00F1BA:        4A            LSR                       
CODE_00F1BB:        90 13         BCC CODE_00F1D0           
CODE_00F1BD:        C9 03         CMP.B #$03                
CODE_00F1BF:        F0 08         BEQ CODE_00F1C9           
CODE_00F1C1:        A4 19         LDY RAM_MarioPowerUp      
CODE_00F1C3:        D0 0B         BNE CODE_00F1D0           
CODE_00F1C5:        A9 01         LDA.B #$01                
CODE_00F1C7:        80 07         BRA CODE_00F1D0           

CODE_00F1C9:        AC 90 14      LDY.W $1490               ; \ Branch if Mario has star 
CODE_00F1CC:        D0 02         BNE CODE_00F1D0           ; / 
CODE_00F1CE:        A9 06         LDA.B #$06                
CODE_00F1D0:        85 05         STA $05                   
CODE_00F1D2:        C9 05         CMP.B #$05                
CODE_00F1D4:        D0 04         BNE CODE_00F1DA           
CODE_00F1D6:        A9 16         LDA.B #$16                
CODE_00F1D8:        85 07         STA $07                   
CODE_00F1DA:        A8            TAY                       
CODE_00F1DB:        A9 0F         LDA.B #$0F                
CODE_00F1DD:        14 9A         TRB RAM_BlockYLo          
CODE_00F1DF:        14 98         TRB RAM_BlockXLo          
CODE_00F1E1:        C0 06         CPY.B #$06                
CODE_00F1E3:        D0 07         BNE CODE_00F1EC           
CODE_00F1E5:        AC 31 19      LDY.W $1931               
CODE_00F1E8:        C0 04         CPY.B #$04                
CODE_00F1EA:        F0 0D         BEQ CODE_00F1F9           
CODE_00F1EC:        8B            PHB                       
CODE_00F1ED:        A9 02         LDA.B #$02                
CODE_00F1EF:        48            PHA                       
CODE_00F1F0:        AB            PLB                       
CODE_00F1F1:        22 52 87 02   JSL.L CODE_028752         
CODE_00F1F5:        AB            PLB                       
CODE_00F1F6:        FA            PLX                       
CODE_00F1F7:        18            CLC                       
Return00F1F8:       6B            RTL                       ; Return 

CODE_00F1F9:        A5 99         LDA RAM_BlockXHi          
CODE_00F1FB:        4A            LSR                       
CODE_00F1FC:        A5 98         LDA RAM_BlockXLo          
CODE_00F1FE:        29 C0         AND.B #$C0                
CODE_00F200:        2A            ROL                       
CODE_00F201:        2A            ROL                       
CODE_00F202:        2A            ROL                       
CODE_00F203:        A8            TAY                       
CODE_00F204:        A5 9A         LDA RAM_BlockYLo          
CODE_00F206:        4A            LSR                       
CODE_00F207:        4A            LSR                       
CODE_00F208:        4A            LSR                       
CODE_00F209:        4A            LSR                       
CODE_00F20A:        AA            TAX                       
CODE_00F20B:        B9 F3 13      LDA.W $13F3,Y             
CODE_00F20E:        1F EC F0 00   ORA.L DATA_00F0EC,X       
CODE_00F212:        BE F3 13      LDX.W $13F3,Y             
CODE_00F215:        99 F3 13      STA.W $13F3,Y             
CODE_00F218:        C9 FF         CMP.B #$FF                
CODE_00F21A:        D0 0A         BNE CODE_00F226           
CODE_00F21C:        A9 05         LDA.B #$05                
CODE_00F21E:        85 05         STA $05                   
CODE_00F220:        A9 17         LDA.B #$17                
CODE_00F222:        85 07         STA $07                   
CODE_00F224:        80 C6         BRA CODE_00F1EC           

CODE_00F226:        AD 1B 14      LDA.W $141B               
CODE_00F229:        D0 0B         BNE CODE_00F236           
CODE_00F22B:        8A            TXA                       
CODE_00F22C:        F0 02         BEQ CODE_00F230           
CODE_00F22E:        A9 02         LDA.B #$02                
CODE_00F230:        49 03         EOR.B #$03                
CODE_00F232:        25 13         AND RAM_FrameCounter      
CODE_00F234:        D0 EA         BNE CODE_00F220           
CODE_00F236:        A9 2A         LDA.B #$2A                
CODE_00F238:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_00F23B:        5A            PHY                       
CODE_00F23C:        64 05         STZ $05                   
CODE_00F23E:        8B            PHB                       
CODE_00F23F:        A9 02         LDA.B #$02                ; \ Set data bank = $02 
CODE_00F241:        48            PHA                       ;  | 
CODE_00F242:        AB            PLB                       
CODE_00F243:        22 52 87 02   JSL.L CODE_028752         
CODE_00F247:        AB            PLB                       
CODE_00F248:        7A            PLY                       
CODE_00F249:        A2 07         LDX.B #$07                
CODE_00F24B:        B9 F3 13      LDA.W $13F3,Y             
CODE_00F24E:        4A            LSR                       
CODE_00F24F:        B0 10         BCS CODE_00F261           
CODE_00F251:        48            PHA                       
CODE_00F252:        A9 0D         LDA.B #$0D                ; \ Block to generate = Used block 
CODE_00F254:        85 9C         STA RAM_BlockBlock        ; / 
CODE_00F256:        BF F8 F0 00   LDA.L DATA_00F0F8,X       
CODE_00F25A:        85 9A         STA RAM_BlockYLo          
CODE_00F25C:        22 B0 BE 00   JSL.L GenerateTile        
CODE_00F260:        68            PLA                       
CODE_00F261:        CA            DEX                       
CODE_00F262:        10 EA         BPL CODE_00F24E           
CODE_00F264:        4C F6 F1      JMP.W CODE_00F1F6         

CODE_00F267:        C0 2E         CPY.B #$2E                
CODE_00F269:        D0 20         BNE Return00F28B          
CODE_00F26B:        24 16         BIT $16                   
CODE_00F26D:        50 1C         BVC Return00F28B          
CODE_00F26F:        AD 8F 14      LDA.W $148F               
CODE_00F272:        0D 7A 18      ORA.W RAM_OnYoshi         
CODE_00F275:        D0 14         BNE Return00F28B          
CODE_00F277:        A9 02         LDA.B #$02                
CODE_00F279:        48            PHA                       
CODE_00F27A:        AB            PLB                       
CODE_00F27B:        22 2F 86 02   JSL.L CODE_02862F         
CODE_00F27F:        30 08         BMI CODE_00F289           
CODE_00F281:        A9 02         LDA.B #$02                ; \ Block to generate = #$02 
CODE_00F283:        85 9C         STA RAM_BlockBlock        ; / 
CODE_00F285:        22 B0 BE 00   JSL.L GenerateTile        
CODE_00F289:        4B            PHK                       
CODE_00F28A:        AB            PLB                       
Return00F28B:       60            RTS                       ; Return 

CODE_00F28C:        98            TYA                       
CODE_00F28D:        38            SEC                       
CODE_00F28E:        E9 6F         SBC.B #$6F                
CODE_00F290:        C9 04         CMP.B #$04                
CODE_00F292:        B0 2C         BCS CODE_00F2C0           
CODE_00F294:        CD 21 14      CMP.W $1421               
CODE_00F297:        F0 0F         BEQ CODE_00F2A8           
CODE_00F299:        1A            INC A                     
CODE_00F29A:        CD 21 14      CMP.W $1421               
CODE_00F29D:        F0 20         BEQ Return00F2BF          
CODE_00F29F:        AD 21 14      LDA.W $1421               
CODE_00F2A2:        C9 04         CMP.B #$04                
CODE_00F2A4:        B0 19         BCS Return00F2BF          
CODE_00F2A6:        A9 FF         LDA.B #$FF                
CODE_00F2A8:        1A            INC A                     
CODE_00F2A9:        8D 21 14      STA.W $1421               
CODE_00F2AC:        C9 04         CMP.B #$04                
CODE_00F2AE:        D0 0F         BNE Return00F2BF          
CODE_00F2B0:        DA            PHX                       
CODE_00F2B1:        22 D9 C2 03   JSL.L TriggerInivis1Up    
CODE_00F2B5:        20 B2 F3      JSR.W CODE_00F3B2         
CODE_00F2B8:        19 3C 1F      ORA.W $1F3C,Y             
CODE_00F2BB:        99 3C 1F      STA.W $1F3C,Y             
CODE_00F2BE:        FA            PLX                       
Return00F2BF:       60            RTS                       ; Return 

CODE_00F2C0:        A9 01         LDA.B #$01                
CODE_00F2C2:        C0 06         CPY.B #$06                
CODE_00F2C4:        B0 03         BCS CODE_00F2C9           
CODE_00F2C6:        04 8A         TSB $8A                   
Return00F2C8:       60            RTS                       ; Return 

CODE_00F2C9:        C0 38         CPY.B #$38                
CODE_00F2CB:        D0 21         BNE CODE_00F2EE           
CODE_00F2CD:        A9 02         LDA.B #$02                ; \ Block to generate = #$02 
CODE_00F2CF:        85 9C         STA RAM_BlockBlock        ; / 
CODE_00F2D1:        22 B0 BE 00   JSL.L GenerateTile        
CODE_00F2D5:        20 5A FD      JSR.W CODE_00FD5A         
CODE_00F2D8:        AD CD 13      LDA.W $13CD               
CODE_00F2DB:        F0 03         BEQ CODE_00F2E0           
CODE_00F2DD:        20 2B CA      JSR.W CODE_00CA2B         
CODE_00F2E0:        A5 19         LDA RAM_MarioPowerUp      
CODE_00F2E2:        D0 04         BNE CODE_00F2E8           
CODE_00F2E4:        A9 01         LDA.B #$01                
CODE_00F2E6:        85 19         STA RAM_MarioPowerUp      
CODE_00F2E8:        A9 05         LDA.B #$05                
CODE_00F2EA:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
Return00F2ED:       60            RTS                       ; Return 

CODE_00F2EE:        C0 06         CPY.B #$06                
CODE_00F2F0:        F0 0A         BEQ CODE_00F2FC           
CODE_00F2F2:        C0 07         CPY.B #$07                
CODE_00F2F4:        90 13         BCC CODE_00F309           
CODE_00F2F6:        C0 1D         CPY.B #$1D                
CODE_00F2F8:        B0 0F         BCS CODE_00F309           
CODE_00F2FA:        09 80         ORA.B #$80                
CODE_00F2FC:        C9 01         CMP.B #$01                
CODE_00F2FE:        D0 02         BNE CODE_00F302           
CODE_00F300:        09 18         ORA.B #$18                
CODE_00F302:        04 8B         TSB $8B                   
CODE_00F304:        A5 93         LDA $93                   
CODE_00F306:        85 8C         STA $8C                   
Return00F308:       60            RTS                       ; Return 

CODE_00F309:        C0 2F         CPY.B #$2F                
CODE_00F30B:        B0 04         BCS CODE_00F311           
CODE_00F30D:        C0 2A         CPY.B #$2A                
CODE_00F30F:        B0 1A         BCS CODE_00F32B           
CODE_00F311:        C0 6E         CPY.B #$6E                
CODE_00F313:        D0 61         BNE Return00F376          
CODE_00F315:        A9 0F         LDA.B #$0F                
CODE_00F317:        22 8A F3 00   JSL.L CODE_00F38A         
CODE_00F31B:        EE C5 13      INC.W $13C5               
CODE_00F31E:        DA            PHX                       
CODE_00F31F:        20 B2 F3      JSR.W CODE_00F3B2         
CODE_00F322:        19 EE 1F      ORA.W $1FEE,Y             
CODE_00F325:        99 EE 1F      STA.W $1FEE,Y             
CODE_00F328:        FA            PLX                       
CODE_00F329:        80 40         BRA CODE_00F36B           

CODE_00F32B:        D0 05         BNE CODE_00F332   		;YOSHI COIN HANDLER        
CODE_00F32D:        AD AD 14      LDA.W RAM_BluePowTimer    
CODE_00F330:        F0 44         BEQ Return00F376          
CODE_00F332:        C0 2D         CPY.B #$2D                
CODE_00F334:        F0 09         BEQ CODE_00F33F           
CODE_00F336:        90 2F         BCC CODE_00F367           
CODE_00F338:        A5 98         LDA RAM_BlockXLo          
CODE_00F33A:        38            SEC                       
CODE_00F33B:        E9 10         SBC.B #$10                
CODE_00F33D:        85 98         STA RAM_BlockXLo          
CODE_00F33F:        22 77 F3 00   JSL.L CODE_00F377         
CODE_00F343:        EE 22 14      INC.W $1422               
CODE_00F346:        AD 22 14      LDA.W $1422               
CODE_00F349:        C9 05         CMP.B #$05                
CODE_00F34B:        90 0B         BCC CODE_00F358           
CODE_00F34D:        DA            PHX                       
CODE_00F34E:        20 B2 F3      JSR.W CODE_00F3B2         
CODE_00F351:        19 2F 1F      ORA.W $1F2F,Y             
CODE_00F354:        99 2F 1F      STA.W $1F2F,Y             
CODE_00F357:        FA            PLX                       
CODE_00F358:        A9 1C         LDA.B #$1C                
CODE_00F35A:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_00F35D:        A9 01         LDA.B #$01                
CODE_00F35F:        22 30 B3 05   JSL.L CODE_05B330         
CODE_00F363:        A0 18         LDY.B #$18                
CODE_00F365:        80 06         BRA CODE_00F36D           

CODE_00F367:        22 4A B3 05   JSL.L CODE_05B34A         
CODE_00F36B:        A0 01         LDY.B #$01                ; \ Block to generate = #$01 
CODE_00F36D:        84 9C         STY RAM_BlockBlock        ; / 
CODE_00F36F:        22 B0 BE 00   JSL.L GenerateTile        
CODE_00F373:        20 5A FD      JSR.W CODE_00FD5A         
Return00F376:       60            RTS                       ; Return 

CODE_00F377:        AD 20 14      LDA.W $1420               
CODE_00F37A:        EE 20 14      INC.W $1420               
CODE_00F37D:        18            CLC                       
CODE_00F37E:        69 09         ADC.B #$09                
CODE_00F380:        C9 0D         CMP.B #$0D                
CODE_00F382:        90 02         BCC CODE_00F386           
CODE_00F384:        A9 0D         LDA.B #$0D                
CODE_00F386:        80 02         BRA CODE_00F38A           

CODE_00F388:        A9 0D         LDA.B #$0D                
CODE_00F38A:        48            PHA                       
CODE_00F38B:        22 34 AD 02   JSL.L CODE_02AD34         
CODE_00F38F:        68            PLA                       
CODE_00F390:        99 E1 16      STA.W RAM_ScoreSprNum,Y   
CODE_00F393:        A5 94         LDA RAM_MarioXPos         
CODE_00F395:        99 ED 16      STA.W RAM_ScoreSprXLo,Y   
CODE_00F398:        A5 95         LDA RAM_MarioXPosHi       
CODE_00F39A:        99 F3 16      STA.W RAM_ScoreSprXHi,Y   
CODE_00F39D:        A5 96         LDA RAM_MarioYPos         
CODE_00F39F:        99 E7 16      STA.W RAM_ScoreSprYLo,Y   
CODE_00F3A2:        A5 97         LDA RAM_MarioYPosHi       
CODE_00F3A4:        99 F9 16      STA.W RAM_ScoreSprYHi,Y   
CODE_00F3A7:        A9 30         LDA.B #$30                
CODE_00F3A9:        99 FF 16      STA.W RAM_ScoreSprSpeedY,Y 
CODE_00F3AC:        A9 00         LDA.B #$00                
CODE_00F3AE:        99 05 17      STA.W $1705,Y             
Return00F3B1:       6B            RTL                       ; Return 

CODE_00F3B2:        AD BF 13      LDA.W $13BF               
CODE_00F3B5:        4A            LSR                       
CODE_00F3B6:        4A            LSR                       
CODE_00F3B7:        4A            LSR                       
CODE_00F3B8:        A8            TAY                       
CODE_00F3B9:        AD BF 13      LDA.W $13BF               
CODE_00F3BC:        29 07         AND.B #$07                
CODE_00F3BE:        AA            TAX                       
CODE_00F3BF:        BF 5B B3 05   LDA.L DATA_05B35B,X       
Return00F3C3:       60            RTS                       ; Return 

CODE_00F3C4:        C0 3F         CPY.B #$3F                
CODE_00F3C6:        D0 AE         BNE Return00F376          
CODE_00F3C8:        A4 8F         LDY $8F                   
CODE_00F3CA:        F0 03         BEQ CODE_00F3CF           
CODE_00F3CC:        4C 3F F4      JMP.W CODE_00F43F         

CODE_00F3CF:        DA            PHX                       
CODE_00F3D0:        AA            TAX                       
CODE_00F3D1:        A5 94         LDA RAM_MarioXPos         
CODE_00F3D3:        9B            TXY                       
CODE_00F3D4:        F0 03         BEQ CODE_00F3D9           
CODE_00F3D6:        49 FF         EOR.B #$FF                
CODE_00F3D8:        1A            INC A                     
CODE_00F3D9:        29 0F         AND.B #$0F                
CODE_00F3DB:        0A            ASL                       
CODE_00F3DC:        18            CLC                       
CODE_00F3DD:        69 20         ADC.B #$20                
CODE_00F3DF:        A0 05         LDY.B #$05                
CODE_00F3E1:        80 27         BRA CODE_00F40A           


DATA_00F3E3:                      .db $0A,$FF

DATA_00F3E5:                      .db $02,$01,$08,$04

CODE_00F3E9:        EB            XBA                       
CODE_00F3EA:        98            TYA                       
CODE_00F3EB:        38            SEC                       
CODE_00F3EC:        E9 37         SBC.B #$37                
CODE_00F3EE:        C9 02         CMP.B #$02                
CODE_00F3F0:        B0 50         BCS Return00F442          
CODE_00F3F2:        A8            TAY                       
CODE_00F3F3:        A5 92         LDA $92                   
CODE_00F3F5:        F9 E3 F3      SBC.W DATA_00F3E3,Y       
CODE_00F3F8:        C9 05         CMP.B #$05                
CODE_00F3FA:        B0 43         BCS CODE_00F43F           
CODE_00F3FC:        DA            PHX                       
CODE_00F3FD:        EB            XBA                       
CODE_00F3FE:        AA            TAX                       
CODE_00F3FF:        A9 20         LDA.B #$20                
CODE_00F401:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_00F404:        F0 02         BEQ CODE_00F408           
CODE_00F406:        A9 30         LDA.B #$30                
CODE_00F408:        A0 06         LDY.B #$06                
CODE_00F40A:        85 88         STA $88                   
CODE_00F40C:        A5 15         LDA RAM_ControllerA       
CODE_00F40E:        3D E5 F3      AND.W DATA_00F3E5,X       
CODE_00F411:        F0 2B         BEQ CODE_00F43E           
CODE_00F413:        85 9D         STA RAM_SpritesLocked     
CODE_00F415:        29 01         AND.B #$01                
CODE_00F417:        85 76         STA RAM_MarioDirection    
CODE_00F419:        86 89         STX $89                   
CODE_00F41B:        8A            TXA                       
CODE_00F41C:        4A            LSR                       
CODE_00F41D:        AA            TAX                       
CODE_00F41E:        D0 10         BNE CODE_00F430           
CODE_00F420:        AD 8F 14      LDA.W $148F               
CODE_00F423:        F0 0B         BEQ CODE_00F430           
CODE_00F425:        A5 76         LDA RAM_MarioDirection    
CODE_00F427:        49 01         EOR.B #$01                
CODE_00F429:        85 76         STA RAM_MarioDirection    
CODE_00F42B:        A9 08         LDA.B #$08                
CODE_00F42D:        8D 99 14      STA.W RAM_FaceCamImgTimer 
CODE_00F430:        E8            INX                       
CODE_00F431:        8E 19 14      STX.W RAM_YoshiInPipe     
CODE_00F434:        84 71         STY RAM_MarioAnimation    
CODE_00F436:        20 2D F6      JSR.W NoButtons           
CODE_00F439:        A9 04         LDA.B #$04                
CODE_00F43B:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_00F43E:        FA            PLX                       
CODE_00F43F:        AC 93 16      LDY.W $1693               
Return00F442:       60            RTS                       ; Return 

CODE_00F443:        A5 94         LDA RAM_MarioXPos         
CODE_00F445:        18            CLC                       
CODE_00F446:        69 04         ADC.B #$04                
CODE_00F448:        29 0F         AND.B #$0F                
CODE_00F44A:        C9 08         CMP.B #$08                
Return00F44C:       60            RTS                       ; Return 

CODE_00F44D:        E8            INX                       
CODE_00F44E:        E8            INX                       
CODE_00F44F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F451:        A5 94         LDA RAM_MarioXPos         
CODE_00F453:        18            CLC                       
CODE_00F454:        7D 30 E8      ADC.W DATA_00E830,X       
CODE_00F457:        85 9A         STA RAM_BlockYLo          
CODE_00F459:        A5 96         LDA RAM_MarioYPos         
CODE_00F45B:        18            CLC                       
CODE_00F45C:        7D 9C E8      ADC.W DATA_00E89C,X       
CODE_00F45F:        85 98         STA RAM_BlockXLo          
CODE_00F461:        20 65 F4      JSR.W CODE_00F465         
Return00F464:       60            RTS                       ; Return 

CODE_00F465:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00F467:        9C 23 14      STZ.W $1423               
CODE_00F46A:        DA            PHX                       
CODE_00F46B:        A5 8E         LDA $8E                   
CODE_00F46D:        10 03         BPL CODE_00F472           
CODE_00F46F:        4C EC F4      JMP.W CODE_00F4EC         

CODE_00F472:        D0 32         BNE CODE_00F4A6           
CODE_00F474:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F476:        A5 98         LDA RAM_BlockXLo          
CODE_00F478:        C9 B0 01      CMP.W #$01B0              
CODE_00F47B:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00F47D:        B0 21         BCS CODE_00F4A0           
CODE_00F47F:        29 F0         AND.B #$F0                
CODE_00F481:        85 00         STA $00                   
CODE_00F483:        A6 9B         LDX RAM_BlockYHi          
CODE_00F485:        E4 5D         CPX RAM_ScreensInLvl      
CODE_00F487:        B0 17         BCS CODE_00F4A0           
CODE_00F489:        A5 9A         LDA RAM_BlockYLo          
CODE_00F48B:        4A            LSR                       
CODE_00F48C:        4A            LSR                       
CODE_00F48D:        4A            LSR                       
CODE_00F48E:        4A            LSR                       
CODE_00F48F:        05 00         ORA $00                   
CODE_00F491:        18            CLC                       
CODE_00F492:        7F 60 BA 00   ADC.L DATA_00BA60,X       
CODE_00F496:        85 00         STA $00                   
CODE_00F498:        A5 99         LDA RAM_BlockXHi          
CODE_00F49A:        7F 9C BA 00   ADC.L DATA_00BA9C,X       
CODE_00F49E:        80 2D         BRA CODE_00F4CD           

CODE_00F4A0:        FA            PLX                       
CODE_00F4A1:        A0 25         LDY.B #$25                
CODE_00F4A3:        A9 00         LDA.B #$00                
Return00F4A5:       60            RTS                       ; Return 

CODE_00F4A6:        A5 9B         LDA RAM_BlockYHi          
CODE_00F4A8:        C9 02         CMP.B #$02                
CODE_00F4AA:        B0 3B         BCS CODE_00F4E7           
CODE_00F4AC:        A6 99         LDX RAM_BlockXHi          
CODE_00F4AE:        E4 5D         CPX RAM_ScreensInLvl      
CODE_00F4B0:        B0 35         BCS CODE_00F4E7           
CODE_00F4B2:        A5 98         LDA RAM_BlockXLo          
CODE_00F4B4:        29 F0         AND.B #$F0                
CODE_00F4B6:        85 00         STA $00                   
CODE_00F4B8:        A5 9A         LDA RAM_BlockYLo          
CODE_00F4BA:        4A            LSR                       
CODE_00F4BB:        4A            LSR                       
CODE_00F4BC:        4A            LSR                       
CODE_00F4BD:        4A            LSR                       
CODE_00F4BE:        05 00         ORA $00                   
CODE_00F4C0:        18            CLC                       
CODE_00F4C1:        7F 80 BA 00   ADC.L DATA_00BA80,X       
CODE_00F4C5:        85 00         STA $00                   
CODE_00F4C7:        A5 9B         LDA RAM_BlockYHi          
CODE_00F4C9:        7F BC BA 00   ADC.L DATA_00BABC,X       
CODE_00F4CD:        85 01         STA $01                   
CODE_00F4CF:        A9 7E         LDA.B #$7E                
CODE_00F4D1:        85 02         STA $02                   
CODE_00F4D3:        A7 00         LDA [$00]                 
CODE_00F4D5:        8D 93 16      STA.W $1693               
CODE_00F4D8:        E6 02         INC $02                   
CODE_00F4DA:        FA            PLX                       
CODE_00F4DB:        A7 00         LDA [$00]                 
CODE_00F4DD:        22 45 F5 00   JSL.L CODE_00F545         
CODE_00F4E1:        AC 93 16      LDY.W $1693               
CODE_00F4E4:        C9 00         CMP.B #$00                
Return00F4E6:       60            RTS                       ; Return 

CODE_00F4E7:        FA            PLX                       
CODE_00F4E8:        A0 25         LDY.B #$25                
CODE_00F4EA:        80 B7         BRA CODE_00F4A3           

CODE_00F4EC:        0A            ASL                       
CODE_00F4ED:        D0 2C         BNE CODE_00F51B           
CODE_00F4EF:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F4F1:        A5 98         LDA RAM_BlockXLo          
CODE_00F4F3:        C9 B0 01      CMP.W #$01B0              
CODE_00F4F6:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00F4F8:        B0 ED         BCS CODE_00F4E7           
CODE_00F4FA:        29 F0         AND.B #$F0                
CODE_00F4FC:        85 00         STA $00                   
CODE_00F4FE:        A6 9B         LDX RAM_BlockYHi          
CODE_00F500:        E0 10         CPX.B #$10                
CODE_00F502:        B0 E3         BCS CODE_00F4E7           
CODE_00F504:        A5 9A         LDA RAM_BlockYLo          
CODE_00F506:        4A            LSR                       
CODE_00F507:        4A            LSR                       
CODE_00F508:        4A            LSR                       
CODE_00F509:        4A            LSR                       
CODE_00F50A:        05 00         ORA $00                   
CODE_00F50C:        18            CLC                       
CODE_00F50D:        7F 70 BA 00   ADC.L DATA_00BA70,X       
CODE_00F511:        85 00         STA $00                   
CODE_00F513:        A5 99         LDA RAM_BlockXHi          
CODE_00F515:        7F AC BA 00   ADC.L DATA_00BAAC,X       
CODE_00F519:        80 B2         BRA CODE_00F4CD           

CODE_00F51B:        A5 9B         LDA RAM_BlockYHi          
CODE_00F51D:        C9 02         CMP.B #$02                
CODE_00F51F:        B0 C6         BCS CODE_00F4E7           
CODE_00F521:        A6 99         LDX RAM_BlockXHi          
CODE_00F523:        E0 0E         CPX.B #$0E                
CODE_00F525:        B0 C0         BCS CODE_00F4E7           
CODE_00F527:        A5 98         LDA RAM_BlockXLo          
CODE_00F529:        29 F0         AND.B #$F0                
CODE_00F52B:        85 00         STA $00                   
CODE_00F52D:        A5 9A         LDA RAM_BlockYLo          
CODE_00F52F:        4A            LSR                       
CODE_00F530:        4A            LSR                       
CODE_00F531:        4A            LSR                       
CODE_00F532:        4A            LSR                       
CODE_00F533:        05 00         ORA $00                   
CODE_00F535:        18            CLC                       
CODE_00F536:        7F 8E BA 00   ADC.L DATA_00BA8E,X       
CODE_00F53A:        85 00         STA $00                   
CODE_00F53C:        A5 9B         LDA RAM_BlockYHi          
CODE_00F53E:        7F CA BA 00   ADC.L DATA_00BACA,X       
CODE_00F542:        4C CD F4      JMP.W CODE_00F4CD         

CODE_00F545:        A8            TAY                       
CODE_00F546:        D0 2F         BNE CODE_00F577           
CODE_00F548:        AC 93 16      LDY.W $1693               ; Load MAP16 tile number 
CODE_00F54B:        C0 29         CPY.B #$29                ; \ If block isn't "Invisible POW ? block", 
CODE_00F54D:        D0 0B         BNE PSwitchNotInvQBlk     ; / branch to PSwitchNotInvQBlk 
CODE_00F54F:        AC AD 14      LDY.W RAM_BluePowTimer    
CODE_00F552:        F0 40         BEQ Return00F594          
CODE_00F554:        A9 24         LDA.B #$24                
CODE_00F556:        8D 93 16      STA.W $1693               
Return00F559:       6B            RTL                       ; Return 

PSwitchNotInvQBlk:  C0 2B         CPY.B #$2B                ; \ If block is "Coin", 
CODE_00F55C:        F0 0E         BEQ PSwitchCoinBrown      ; / branch to PSwitchCoinBrown 
CODE_00F55E:        98            TYA                       
CODE_00F55F:        38            SEC                       
CODE_00F560:        E9 EC         SBC.B #$EC                
CODE_00F562:        C9 10         CMP.B #$10                
CODE_00F564:        B0 2C         BCS CODE_00F592           
CODE_00F566:        1A            INC A                     
CODE_00F567:        8D 23 14      STA.W $1423               
CODE_00F56A:        80 05         BRA CODE_00F571           

PSwitchCoinBrown:   AC AD 14      LDY.W RAM_BluePowTimer    
CODE_00F56F:        F0 23         BEQ Return00F594          
CODE_00F571:        A9 32         LDA.B #$32                
CODE_00F573:        8D 93 16      STA.W $1693               
Return00F576:       6B            RTL                       ; Return 

CODE_00F577:        AC 93 16      LDY.W $1693               
CODE_00F57A:        C0 32         CPY.B #$32                
CODE_00F57C:        D0 06         BNE CODE_00F584           
CODE_00F57E:        AC AD 14      LDY.W RAM_BluePowTimer    
CODE_00F581:        D0 0A         BNE CODE_00F58D           
Return00F583:       6B            RTL                       ; Return 

CODE_00F584:        C0 2F         CPY.B #$2F                
CODE_00F586:        D0 0C         BNE Return00F594          
CODE_00F588:        AC AE 14      LDY.W RAM_SilverPowTimer  
CODE_00F58B:        F0 07         BEQ Return00F594          
CODE_00F58D:        A0 2B         LDY.B #$2B                
CODE_00F58F:        8C 93 16      STY.W $1693               
CODE_00F592:        A9 00         LDA.B #$00                
Return00F594:       6B            RTL                       ; Return 

CODE_00F595:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F597:        A9 80 FF      LDA.W #$FF80              
CODE_00F59A:        18            CLC                       
CODE_00F59B:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_00F59D:        C5 96         CMP RAM_MarioYPos         
CODE_00F59F:        30 02         BMI CODE_00F5A3           
CODE_00F5A1:        85 96         STA RAM_MarioYPos         
CODE_00F5A3:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00F5A5:        A5 81         LDA $81                   
CODE_00F5A7:        3A            DEC A                     
CODE_00F5A8:        30 0C         BMI Return00F5B6          
CODE_00F5AA:        AD 95 1B      LDA.W $1B95               
CODE_00F5AD:        F0 03         BEQ CODE_00F5B2           
CODE_00F5AF:        4C 5B C9      JMP.W CODE_00C95B         

CODE_00F5B2:        22 0A F6 00   JSL.L CODE_00F60A         
Return00F5B6:       60            RTS                       ; Return 

HurtMario:          A5 71         LDA RAM_MarioAnimation    ; \ Return if animation sequence activated 
CODE_00F5B9:        D0 6D         BNE Return00F628          ; / 
CODE_00F5BB:        AD 97 14      LDA.W $1497               ; \ If flashing... 
CODE_00F5BE:        0D 90 14      ORA.W $1490               ;  | ...or have star... 
CODE_00F5C1:        0D 93 14      ORA.W $1493               ;  | ...or level ending... 
CODE_00F5C4:        D0 62         BNE Return00F628          ; / ...return 
CODE_00F5C6:        9C E3 18      STZ.W $18E3               
CODE_00F5C9:        AD E3 13      LDA.W RAM_WallWalkStatus  
CODE_00F5CC:        F0 07         BEQ CODE_00F5D5           
ADDR_00F5CE:        8B            PHB                       
ADDR_00F5CF:        4B            PHK                       
ADDR_00F5D0:        AB            PLB                       
ADDR_00F5D1:        20 42 EB      JSR.W ADDR_00EB42         
ADDR_00F5D4:        AB            PLB                       
CODE_00F5D5:        A5 19         LDA RAM_MarioPowerUp      ; \ If Mario is small, kill him 
CODE_00F5D7:        F0 2D         BEQ KillMario             ; / 
CODE_00F5D9:        C9 02         CMP.B #$02                ; \ Branch if not Caped Mario 
CODE_00F5DB:        D0 16         BNE PowerDown             ; / 
CODE_00F5DD:        AD 07 14      LDA.W $1407               ; \ Branch if not soaring 
CODE_00F5E0:        F0 11         BEQ PowerDown             ; / 
CancelSoaring:      A0 0F         LDY.B #$0F                ; \ Break Mario out of soaring 
CODE_00F5E4:        8C F9 1D      STY.W $1DF9               ;  | (Play sound effect) 
CODE_00F5E7:        A9 01         LDA.B #$01                ;  | (Set spin jump flag) 
CODE_00F5E9:        8D 0D 14      STA.W RAM_IsSpinJump      ;  | 
CODE_00F5EC:        A9 30         LDA.B #$30                ;  | (Set flashing timer) 
CODE_00F5EE:        8D 97 14      STA.W $1497               ; / 
CODE_00F5F1:        80 2F         BRA CODE_00F622           

PowerDown:          A0 04         LDY.B #$04                ; \ Play sound effect 
CODE_00F5F5:        8C F9 1D      STY.W $1DF9               ; / 
CODE_00F5F8:        22 08 80 02   JSL.L CODE_028008         
CODE_00F5FC:        A9 01         LDA.B #$01                ; \ Set power down animation 
CODE_00F5FE:        85 71         STA RAM_MarioAnimation    ; / 
CODE_00F600:        64 19         STZ RAM_MarioPowerUp      ; Mario status = Small 
CODE_00F602:        A9 2F         LDA.B #$2F                
CODE_00F604:        80 17         BRA CODE_00F61D           

KillMario:          A9 90         LDA.B #$90                ; \ Mario Y speed = #$90 
CODE_00F608:        85 7D         STA RAM_MarioSpeedY       ; / 
CODE_00F60A:        A9 09         LDA.B #$09                ; \ 
CODE_00F60C:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_00F60F:        A9 FF         LDA.B #$FF                
CODE_00F611:        8D DA 0D      STA.W $0DDA               
CODE_00F614:        A9 09         LDA.B #$09                ; \ Animation sequence = Kill Mario 
CODE_00F616:        85 71         STA RAM_MarioAnimation    ; / 
CODE_00F618:        9C 0D 14      STZ.W RAM_IsSpinJump      ; Spin jump flag = 0 
CODE_00F61B:        A9 30         LDA.B #$30                
CODE_00F61D:        8D 96 14      STA.W $1496               ; Set hurt frame timer 
CODE_00F620:        85 9D         STA RAM_SpritesLocked     ; set lock sprite timer 
CODE_00F622:        9C 07 14      STZ.W $1407               ; Cape status = 0 
CODE_00F625:        9C 8A 18      STZ.W $188A               
Return00F628:       6B            RTL                       ; Return 

CODE_00F629:        22 06 F6 00   JSL.L KillMario           
NoButtons:          64 15         STZ RAM_ControllerA       ; Zero RAM mirrors for controller Input 
CODE_00F62F:        64 16         STZ $16                   
CODE_00F631:        64 17         STZ RAM_ControllerB       
CODE_00F633:        64 18         STZ $18                   
Return00F635:       60            RTS                       ; Return 

CODE_00F636:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F638:        A2 00         LDX.B #$00                
CODE_00F63A:        A5 09         LDA $09                   
CODE_00F63C:        09 00 08      ORA.W #$0800              
CODE_00F63F:        C5 09         CMP $09                   
CODE_00F641:        F0 01         BEQ CODE_00F644           
CODE_00F643:        18            CLC                       
CODE_00F644:        29 00 F7      AND.W #$F700              
CODE_00F647:        6A            ROR                       
CODE_00F648:        4A            LSR                       
CODE_00F649:        69 00 20      ADC.W #$2000              
CODE_00F64C:        8D 85 0D      STA.W $0D85               
CODE_00F64F:        18            CLC                       
CODE_00F650:        69 00 02      ADC.W #$0200              
CODE_00F653:        8D 8F 0D      STA.W $0D8F               
CODE_00F656:        A2 00         LDX.B #$00                
CODE_00F658:        A5 0A         LDA $0A                   
CODE_00F65A:        09 00 08      ORA.W #$0800              
CODE_00F65D:        C5 0A         CMP $0A                   
CODE_00F65F:        F0 01         BEQ CODE_00F662           
CODE_00F661:        18            CLC                       
CODE_00F662:        29 00 F7      AND.W #$F700              
CODE_00F665:        6A            ROR                       
CODE_00F666:        4A            LSR                       
CODE_00F667:        69 00 20      ADC.W #$2000              
CODE_00F66A:        8D 87 0D      STA.W $0D87               
CODE_00F66D:        18            CLC                       
CODE_00F66E:        69 00 02      ADC.W #$0200              
CODE_00F671:        8D 91 0D      STA.W $0D91               
CODE_00F674:        A5 0B         LDA $0B                   
CODE_00F676:        29 00 FF      AND.W #$FF00              
CODE_00F679:        4A            LSR                       
CODE_00F67A:        4A            LSR                       
CODE_00F67B:        4A            LSR                       
CODE_00F67C:        69 00 20      ADC.W #$2000              
CODE_00F67F:        8D 89 0D      STA.W $0D89               
CODE_00F682:        18            CLC                       
CODE_00F683:        69 00 02      ADC.W #$0200              
CODE_00F686:        8D 93 0D      STA.W $0D93               
CODE_00F689:        A5 0C         LDA $0C                   
CODE_00F68B:        29 00 FF      AND.W #$FF00              
CODE_00F68E:        4A            LSR                       
CODE_00F68F:        4A            LSR                       
CODE_00F690:        4A            LSR                       
CODE_00F691:        69 00 20      ADC.W #$2000              
CODE_00F694:        8D 99 0D      STA.W $0D99               
CODE_00F697:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00F699:        A9 0A         LDA.B #$0A                
CODE_00F69B:        8D 84 0D      STA.W $0D84               
Return00F69E:       60            RTS                       ; Return 


DATA_00F69F:                      .db $64,$00,$7C,$00

DATA_00F6A3:                      .db $00,$00,$FF,$FF

DATA_00F6A7:                      .db $FD,$FF,$05,$00,$FA,$FF

DATA_00F6AD:                      .db $00,$00,$00,$00,$C0,$00

DATA_00F6B3:                      .db $90,$00,$60,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00

DATA_00F6BF:                      .db $00,$00,$FE,$FF,$02,$00,$00,$00
                                  .db $FE,$FF,$02,$00

DATA_00F6CB:                      .db $00,$00,$20,$00

DATA_00F6CF:                      .db $D0,$00,$00,$00,$20,$00,$D0,$00
                                  .db $01,$00,$FF,$FF

CODE_00F6DB:        8B            PHB                       
CODE_00F6DC:        4B            PHK                       
CODE_00F6DD:        AB            PLB                       
CODE_00F6DE:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F6E0:        AD 2A 14      LDA.W $142A               
CODE_00F6E3:        38            SEC                       
CODE_00F6E4:        E9 0C 00      SBC.W #$000C              
CODE_00F6E7:        8D 2C 14      STA.W $142C               
CODE_00F6EA:        18            CLC                       
CODE_00F6EB:        69 18 00      ADC.W #$0018              
CODE_00F6EE:        8D 2E 14      STA.W $142E               
CODE_00F6F1:        AD 62 14      LDA.W $1462               
CODE_00F6F4:        85 1A         STA RAM_ScreenBndryXLo    
CODE_00F6F6:        AD 64 14      LDA.W $1464               
CODE_00F6F9:        85 1C         STA RAM_ScreenBndryYLo    
CODE_00F6FB:        AD 66 14      LDA.W $1466               
CODE_00F6FE:        85 1E         STA $1E                   
CODE_00F700:        AD 68 14      LDA.W $1468               
CODE_00F703:        85 20         STA $20                   
CODE_00F705:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_00F707:        4A            LSR                       
CODE_00F708:        90 03         BCC CODE_00F70D           
CODE_00F70A:        4C 5C F7      JMP.W CODE_00F75C         

CODE_00F70D:        A9 C0 00      LDA.W #$00C0              
CODE_00F710:        20 F4 F7      JSR.W CODE_00F7F4         
CODE_00F713:        AC 11 14      LDY.W $1411               
CODE_00F716:        F0 42         BEQ CODE_00F75A           
CODE_00F718:        A0 02         LDY.B #$02                
CODE_00F71A:        A5 94         LDA RAM_MarioXPos         
CODE_00F71C:        38            SEC                       
CODE_00F71D:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_00F71F:        85 00         STA $00                   
CODE_00F721:        CD 2A 14      CMP.W $142A               
CODE_00F724:        10 02         BPL CODE_00F728           
CODE_00F726:        A0 00         LDY.B #$00                
CODE_00F728:        84 55         STY $55                   
CODE_00F72A:        84 56         STY $56                   
CODE_00F72C:        38            SEC                       
CODE_00F72D:        F9 2C 14      SBC.W $142C,Y             
CODE_00F730:        F0 28         BEQ CODE_00F75A           
CODE_00F732:        85 02         STA $02                   
CODE_00F734:        59 A3 F6      EOR.W DATA_00F6A3,Y       
CODE_00F737:        10 21         BPL CODE_00F75A           
CODE_00F739:        20 AB F8      JSR.W CODE_00F8AB         
CODE_00F73C:        A5 02         LDA $02                   
CODE_00F73E:        18            CLC                       
CODE_00F73F:        65 1A         ADC RAM_ScreenBndryXLo    
CODE_00F741:        10 03         BPL CODE_00F746           
CODE_00F743:        A9 00 00      LDA.W #$0000              
CODE_00F746:        85 1A         STA RAM_ScreenBndryXLo    
CODE_00F748:        A5 5E         LDA $5E                   
CODE_00F74A:        3A            DEC A                     
CODE_00F74B:        EB            XBA                       
CODE_00F74C:        29 00 FF      AND.W #$FF00              
CODE_00F74F:        10 03         BPL CODE_00F754           
CODE_00F751:        A9 80 00      LDA.W #$0080              
CODE_00F754:        C5 1A         CMP RAM_ScreenBndryXLo    
CODE_00F756:        10 02         BPL CODE_00F75A           
CODE_00F758:        85 1A         STA RAM_ScreenBndryXLo    
CODE_00F75A:        80 41         BRA CODE_00F79D           

CODE_00F75C:        A5 5F         LDA $5F                   
CODE_00F75E:        3A            DEC A                     
CODE_00F75F:        EB            XBA                       
CODE_00F760:        29 00 FF      AND.W #$FF00              
CODE_00F763:        20 F4 F7      JSR.W CODE_00F7F4         
CODE_00F766:        AC 11 14      LDY.W $1411               
CODE_00F769:        F0 32         BEQ CODE_00F79D           
CODE_00F76B:        A0 00         LDY.B #$00                
CODE_00F76D:        A5 94         LDA RAM_MarioXPos         
CODE_00F76F:        38            SEC                       
CODE_00F770:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_00F772:        85 00         STA $00                   
CODE_00F774:        CD 2A 14      CMP.W $142A               
CODE_00F777:        30 02         BMI CODE_00F77B           
CODE_00F779:        A0 02         LDY.B #$02                
CODE_00F77B:        38            SEC                       
CODE_00F77C:        F9 2C 14      SBC.W $142C,Y             
CODE_00F77F:        85 02         STA $02                   
CODE_00F781:        59 A3 F6      EOR.W DATA_00F6A3,Y       
CODE_00F784:        10 17         BPL CODE_00F79D           
CODE_00F786:        20 AB F8      JSR.W CODE_00F8AB         
CODE_00F789:        A5 02         LDA $02                   
CODE_00F78B:        18            CLC                       
CODE_00F78C:        65 1A         ADC RAM_ScreenBndryXLo    
CODE_00F78E:        10 03         BPL CODE_00F793           
CODE_00F790:        A9 00 00      LDA.W #$0000              
CODE_00F793:        C9 01 01      CMP.W #$0101              
CODE_00F796:        30 03         BMI CODE_00F79B           
CODE_00F798:        A9 00 01      LDA.W #$0100              
CODE_00F79B:        85 1A         STA RAM_ScreenBndryXLo    
CODE_00F79D:        AC 13 14      LDY.W $1413               
CODE_00F7A0:        F0 08         BEQ CODE_00F7AA           
CODE_00F7A2:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_00F7A4:        88            DEY                       
CODE_00F7A5:        F0 01         BEQ CODE_00F7A8           
CODE_00F7A7:        4A            LSR                       
CODE_00F7A8:        85 1E         STA $1E                   
CODE_00F7AA:        AC 14 14      LDY.W $1414               
CODE_00F7AD:        F0 13         BEQ CODE_00F7C2           
CODE_00F7AF:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_00F7B1:        88            DEY                       
CODE_00F7B2:        F0 08         BEQ CODE_00F7BC           
CODE_00F7B4:        4A            LSR                       
CODE_00F7B5:        88            DEY                       
CODE_00F7B6:        F0 04         BEQ CODE_00F7BC           
CODE_00F7B8:        4A            LSR                       
CODE_00F7B9:        4A            LSR                       
CODE_00F7BA:        4A            LSR                       
CODE_00F7BB:        4A            LSR                       
CODE_00F7BC:        18            CLC                       
CODE_00F7BD:        6D 17 14      ADC.W $1417               
CODE_00F7C0:        85 20         STA $20                   
CODE_00F7C2:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00F7C4:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_00F7C6:        38            SEC                       
CODE_00F7C7:        ED 62 14      SBC.W $1462               
CODE_00F7CA:        8D BD 17      STA.W $17BD               
CODE_00F7CD:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_00F7CF:        38            SEC                       
CODE_00F7D0:        ED 64 14      SBC.W $1464               
CODE_00F7D3:        8D BC 17      STA.W $17BC               
CODE_00F7D6:        A5 1E         LDA $1E                   
CODE_00F7D8:        38            SEC                       
CODE_00F7D9:        ED 66 14      SBC.W $1466               
CODE_00F7DC:        8D BF 17      STA.W $17BF               
CODE_00F7DF:        A5 20         LDA $20                   
CODE_00F7E1:        38            SEC                       
CODE_00F7E2:        ED 68 14      SBC.W $1468               
CODE_00F7E5:        8D BE 17      STA.W $17BE               
CODE_00F7E8:        A2 07         LDX.B #$07                
CODE_00F7EA:        B5 1A         LDA RAM_ScreenBndryXLo,X  
CODE_00F7EC:        9D 62 14      STA.W $1462,X             
CODE_00F7EF:        CA            DEX                       
CODE_00F7F0:        10 F8         BPL CODE_00F7EA           
CODE_00F7F2:        AB            PLB                       
Return00F7F3:       6B            RTL                       ; Return 

CODE_00F7F4:        AE 12 14      LDX.W $1412               
CODE_00F7F7:        D0 01         BNE CODE_00F7FA           
Return00F7F9:       60            RTS                       ; Return 

CODE_00F7FA:        85 04         STA $04                   ; Accum (16 bit) 
CODE_00F7FC:        A0 00         LDY.B #$00                
CODE_00F7FE:        A5 96         LDA RAM_MarioYPos         
CODE_00F800:        38            SEC                       
CODE_00F801:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_00F803:        85 00         STA $00                   
CODE_00F805:        C9 70 00      CMP.W #$0070              
CODE_00F808:        30 02         BMI CODE_00F80C           
CODE_00F80A:        A0 02         LDY.B #$02                
CODE_00F80C:        84 55         STY $55                   
CODE_00F80E:        84 56         STY $56                   
CODE_00F810:        38            SEC                       
CODE_00F811:        F9 9F F6      SBC.W DATA_00F69F,Y       
CODE_00F814:        85 02         STA $02                   
CODE_00F816:        59 A3 F6      EOR.W DATA_00F6A3,Y       
CODE_00F819:        30 04         BMI CODE_00F81F           
CODE_00F81B:        A0 02         LDY.B #$02                
CODE_00F81D:        64 02         STZ $02                   
CODE_00F81F:        A5 02         LDA $02                   
CODE_00F821:        30 07         BMI CODE_00F82A           
CODE_00F823:        A2 00         LDX.B #$00                
CODE_00F825:        8E 04 14      STX.W $1404               
CODE_00F828:        80 59         BRA CODE_00F883           

CODE_00F82A:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00F82C:        AD E3 13      LDA.W RAM_WallWalkStatus  
CODE_00F82F:        C9 06         CMP.B #$06                
CODE_00F831:        B0 12         BCS CODE_00F845           
CODE_00F833:        AD 10 14      LDA.W RAM_YoshiHasWingsB  ; \ If winged Yoshi... 
CODE_00F836:        4A            LSR                       ;  | 
CODE_00F837:        0D 9F 14      ORA.W $149F               
CODE_00F83A:        05 74         ORA RAM_IsClimbing        ;  | ...or climbing 
CODE_00F83C:        0D F3 13      ORA.W $13F3               
CODE_00F83F:        0D C2 18      ORA.W $18C2               
CODE_00F842:        0D 06 14      ORA.W $1406               
CODE_00F845:        AA            TAX                       
CODE_00F846:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F848:        D0 1F         BNE CODE_00F869           
CODE_00F84A:        AE 7A 18      LDX.W RAM_OnYoshi         
CODE_00F84D:        F0 07         BEQ CODE_00F856           
CODE_00F84F:        AE 1E 14      LDX.W RAM_YoshiHasWings   ; \ Branch if 141E >= #$02 
CODE_00F852:        E0 02         CPX.B #$02                ;  | 
CODE_00F854:        B0 13         BCS CODE_00F869           ; / 
CODE_00F856:        A6 75         LDX RAM_IsSwimming        
CODE_00F858:        F0 04         BEQ CODE_00F85E           
CODE_00F85A:        A6 72         LDX RAM_IsFlying          
CODE_00F85C:        D0 0B         BNE CODE_00F869           
CODE_00F85E:        AE 12 14      LDX.W $1412               
CODE_00F861:        CA            DEX                       
CODE_00F862:        F0 11         BEQ CODE_00F875           
CODE_00F864:        AE F1 13      LDX.W $13F1               
CODE_00F867:        D0 0C         BNE CODE_00F875           
CODE_00F869:        8E F1 13      STX.W $13F1               
CODE_00F86C:        AE F1 13      LDX.W $13F1               
CODE_00F86F:        D0 10         BNE CODE_00F881           
CODE_00F871:        A0 04         LDY.B #$04                
CODE_00F873:        80 0C         BRA CODE_00F881           

CODE_00F875:        AE 04 14      LDX.W $1404               
CODE_00F878:        D0 07         BNE CODE_00F881           
CODE_00F87A:        A6 72         LDX RAM_IsFlying          
CODE_00F87C:        D0 2C         BNE Return00F8AA          
CODE_00F87E:        EE 04 14      INC.W $1404               
CODE_00F881:        A5 02         LDA $02                   
CODE_00F883:        38            SEC                       
CODE_00F884:        F9 A7 F6      SBC.W DATA_00F6A7,Y       
CODE_00F887:        59 A7 F6      EOR.W DATA_00F6A7,Y       
CODE_00F88A:        0A            ASL                       
CODE_00F88B:        A5 02         LDA $02                   
CODE_00F88D:        B0 03         BCS CODE_00F892           
CODE_00F88F:        B9 A7 F6      LDA.W DATA_00F6A7,Y       
CODE_00F892:        18            CLC                       
CODE_00F893:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_00F895:        D9 AD F6      CMP.W DATA_00F6AD,Y       
CODE_00F898:        10 03         BPL CODE_00F89D           
CODE_00F89A:        B9 AD F6      LDA.W DATA_00F6AD,Y       
CODE_00F89D:        85 1C         STA RAM_ScreenBndryYLo    
CODE_00F89F:        A5 04         LDA $04                   
CODE_00F8A1:        C5 1C         CMP RAM_ScreenBndryYLo    
CODE_00F8A3:        10 05         BPL Return00F8AA          
CODE_00F8A5:        85 1C         STA RAM_ScreenBndryYLo    
CODE_00F8A7:        9C F1 13      STZ.W $13F1               
Return00F8AA:       60            RTS                       ; Return 

CODE_00F8AB:        AC FD 13      LDY.W $13FD               
CODE_00F8AE:        D0 2E         BNE Return00F8DE          
CODE_00F8B0:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00F8B2:        AE FF 13      LDX.W $13FF               
CODE_00F8B5:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F8B7:        A0 08         LDY.B #$08                
CODE_00F8B9:        AD 2A 14      LDA.W $142A               
CODE_00F8BC:        DD B3 F6      CMP.W DATA_00F6B3,X       
CODE_00F8BF:        10 02         BPL CODE_00F8C3           
CODE_00F8C1:        A0 0A         LDY.B #$0A                
CODE_00F8C3:        B9 BF F6      LDA.W DATA_00F6BF,Y       
CODE_00F8C6:        45 02         EOR $02                   
CODE_00F8C8:        10 14         BPL Return00F8DE          
CODE_00F8CA:        BD BF F6      LDA.W DATA_00F6BF,X       
CODE_00F8CD:        45 02         EOR $02                   
CODE_00F8CF:        10 0D         BPL Return00F8DE          
CODE_00F8D1:        A5 02         LDA $02                   
CODE_00F8D3:        18            CLC                       
CODE_00F8D4:        79 CF F6      ADC.W DATA_00F6CF,Y       
CODE_00F8D7:        F0 05         BEQ Return00F8DE          
CODE_00F8D9:        85 02         STA $02                   
CODE_00F8DB:        8C 00 14      STY.W $1400               
Return00F8DE:       60            RTS                       ; Return 


DATA_00F8DF:                      .db $0C,$0C,$08,$00,$20,$04,$0A,$0D
                                  .db $0D

DATA_00F8E8:                      .db $2A,$00,$2A,$00,$12,$00,$00,$00
                                  .db $ED,$FF

CODE_00F8F2:        20 A6 EA      JSR.W CODE_00EAA6         
CODE_00F8F5:        2C 9B 0D      BIT.W $0D9B               
CODE_00F8F8:        50 54         BVC CODE_00F94E           
CODE_00F8FA:        20 2B E9      JSR.W CODE_00E92B         
CODE_00F8FD:        AD FC 13      LDA.W $13FC               
CODE_00F900:        0A            ASL                       
CODE_00F901:        AA            TAX                       
CODE_00F902:        DA            PHX                       
CODE_00F903:        A4 7D         LDY RAM_MarioSpeedY       
CODE_00F905:        10 17         BPL CODE_00F91E           
CODE_00F907:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F909:        A5 96         LDA RAM_MarioYPos         
CODE_00F90B:        DD E8 F8      CMP.W DATA_00F8E8,X       
CODE_00F90E:        10 0E         BPL CODE_00F91E           
CODE_00F910:        BD E8 F8      LDA.W DATA_00F8E8,X       
CODE_00F913:        85 96         STA RAM_MarioYPos         
CODE_00F915:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00F917:        64 7D         STZ RAM_MarioSpeedY       
CODE_00F919:        A9 01         LDA.B #$01                
CODE_00F91B:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_00F91E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00F920:        FA            PLX                       
CODE_00F921:        BD E8 F8      LDA.W DATA_00F8E8,X       
CODE_00F924:        C9 2A         CMP.B #$2A                
CODE_00F926:        D0 25         BNE Return00F94D          
CODE_00F928:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F92A:        A0 00         LDY.B #$00                
CODE_00F92C:        AD 17 16      LDA.W $1617               
CODE_00F92F:        29 FF 00      AND.W #$00FF              
CODE_00F932:        1A            INC A                     
CODE_00F933:        C5 94         CMP RAM_MarioXPos         
CODE_00F935:        F0 13         BEQ CODE_00F94A           
CODE_00F937:        30 11         BMI CODE_00F94A           
CODE_00F939:        AD 3D 15      LDA.W $153D               
CODE_00F93C:        29 FF 00      AND.W #$00FF              
CODE_00F93F:        85 00         STA $00                   
CODE_00F941:        C8            INY                       
CODE_00F942:        A5 94         LDA RAM_MarioXPos         
CODE_00F944:        18            CLC                       
CODE_00F945:        69 0F 00      ADC.W #$000F              
CODE_00F948:        C5 00         CMP $00                   
CODE_00F94A:        4C C8 E9      JMP.W CODE_00E9C8         

Return00F94D:       60            RTS                       ; Return 

CODE_00F94E:        A0 00         LDY.B #$00                
CODE_00F950:        A5 7D         LDA RAM_MarioSpeedY       
CODE_00F952:        10 03         BPL CODE_00F957           
CODE_00F954:        4C 97 F9      JMP.W CODE_00F997         

CODE_00F957:        20 A8 F9      JSR.W CODE_00F9A8         
CODE_00F95A:        B0 06         BCS CODE_00F962           
CODE_00F95C:        20 1D EE      JSR.W CODE_00EE1D         
CODE_00F95F:        4C 97 F9      JMP.W CODE_00F997         

CODE_00F962:        A5 72         LDA RAM_IsFlying          
CODE_00F964:        F0 1D         BEQ CODE_00F983           
CODE_00F966:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F968:        AD B8 14      LDA.W $14B8               
CODE_00F96B:        29 FF 00      AND.W #$00FF              
CODE_00F96E:        8D B4 14      STA.W $14B4               
CODE_00F971:        8D 36 14      STA.W RAM_KeyHolePos1     
CODE_00F974:        AD BA 14      LDA.W $14BA               
CODE_00F977:        29 F0 00      AND.W #$00F0              
CODE_00F97A:        8D B6 14      STA.W $14B6               
CODE_00F97D:        8D 38 14      STA.W RAM_KeyHolePos2     
CODE_00F980:        20 C9 F9      JSR.W CODE_00F9C9         
CODE_00F983:        A5 36         LDA $36                   ; Accum (8 bit) 
CODE_00F985:        18            CLC                       
CODE_00F986:        69 48         ADC.B #$48                
CODE_00F988:        4A            LSR                       
CODE_00F989:        4A            LSR                       
CODE_00F98A:        4A            LSR                       
CODE_00F98B:        4A            LSR                       
CODE_00F98C:        AA            TAX                       
CODE_00F98D:        BC DF F8      LDY.W DATA_00F8DF,X       
CODE_00F990:        A9 80         LDA.B #$80                
CODE_00F992:        85 8E         STA $8E                   
CODE_00F994:        20 E1 EE      JSR.W CODE_00EEE1         
CODE_00F997:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F999:        A5 80         LDA $80                   
CODE_00F99B:        C9 AE 00      CMP.W #$00AE              
CODE_00F99E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00F9A0:        30 03         BMI CODE_00F9A5           
ADDR_00F9A2:        20 29 F6      JSR.W CODE_00F629         
CODE_00F9A5:        4C 8C E9      JMP.W CODE_00E98C         

CODE_00F9A8:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F9AA:        A5 94         LDA RAM_MarioXPos         
CODE_00F9AC:        18            CLC                       
CODE_00F9AD:        69 08 00      ADC.W #$0008              
CODE_00F9B0:        8D B4 14      STA.W $14B4               
CODE_00F9B3:        A5 96         LDA RAM_MarioYPos         
CODE_00F9B5:        18            CLC                       
CODE_00F9B6:        69 20 00      ADC.W #$0020              
CODE_00F9B9:        8D B6 14      STA.W $14B6               
CODE_00F9BC:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00F9BE:        8B            PHB                       
CODE_00F9BF:        A9 01         LDA.B #$01                
CODE_00F9C1:        48            PHA                       
CODE_00F9C2:        AB            PLB                       
CODE_00F9C3:        22 9D CC 01   JSL.L CODE_01CC9D         
CODE_00F9C7:        AB            PLB                       
Return00F9C8:       60            RTS                       ; Return 

CODE_00F9C9:        A5 36         LDA $36                   ; Accum (16 bit) 
CODE_00F9CB:        48            PHA                       
CODE_00F9CC:        49 FF FF      EOR.W #$FFFF              
CODE_00F9CF:        1A            INC A                     
CODE_00F9D0:        85 36         STA $36                   
CODE_00F9D2:        20 BC F9      JSR.W CODE_00F9BC         
CODE_00F9D5:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00F9D7:        68            PLA                       
CODE_00F9D8:        85 36         STA $36                   
CODE_00F9DA:        AD B8 14      LDA.W $14B8               
CODE_00F9DD:        29 FF 00      AND.W #$00FF              
CODE_00F9E0:        38            SEC                       
CODE_00F9E1:        E9 08 00      SBC.W #$0008              
CODE_00F9E4:        85 94         STA RAM_MarioXPos         
CODE_00F9E6:        AD BA 14      LDA.W $14BA               
CODE_00F9E9:        29 FF 00      AND.W #$00FF              
CODE_00F9EC:        38            SEC                       
CODE_00F9ED:        E9 20 00      SBC.W #$0020              
CODE_00F9F0:        85 96         STA RAM_MarioYPos         
CODE_00F9F2:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return00F9F4:       60            RTS                       ; Return 


Empty00F9F5:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF

ADDR_00FA10:        A2 0B         LDX.B #$0B                ; \ Unreachable 
ADDR_00FA12:        9E C8 14      STZ.W $14C8,X             ;  | Clear out sprite status table 
ADDR_00FA15:        CA            DEX                       ;  | 
ADDR_00FA16:        10 FA         BPL ADDR_00FA12           ;  | 
Return00FA18:       6B            RTL                       ; / 

CODE_00FA19:        A0 32         LDY.B #$32                
CODE_00FA1B:        84 05         STY $05                   
CODE_00FA1D:        A0 E6         LDY.B #$E6                
CODE_00FA1F:        84 06         STY $06                   
CODE_00FA21:        A0 00         LDY.B #$00                
CODE_00FA23:        84 07         STY $07                   
CODE_00FA25:        38            SEC                       
CODE_00FA26:        E9 6E         SBC.B #$6E                
CODE_00FA28:        A8            TAY                       
CODE_00FA29:        B7 82         LDA [$82],Y               
CODE_00FA2B:        85 08         STA $08                   
CODE_00FA2D:        0A            ASL                       
CODE_00FA2E:        0A            ASL                       
CODE_00FA2F:        0A            ASL                       
CODE_00FA30:        0A            ASL                       
CODE_00FA31:        85 01         STA $01                   
CODE_00FA33:        90 02         BCC CODE_00FA37           
CODE_00FA35:        E6 06         INC $06                   
CODE_00FA37:        A5 0C         LDA $0C                   
CODE_00FA39:        29 0F         AND.B #$0F                
CODE_00FA3B:        85 00         STA $00                   
CODE_00FA3D:        A5 0A         LDA $0A                   
CODE_00FA3F:        29 0F         AND.B #$0F                
CODE_00FA41:        05 01         ORA $01                   
CODE_00FA43:        A8            TAY                       
Return00FA44:       6B            RTL                       ; Return 

FlatPalaceSwitch:   A9 20         LDA.B #$20                ; \ Set "Time to shake ground" to x20 
CODE_00FA47:        8D 87 18      STA.W RAM_ShakeGrndTimer  ; / 
CODE_00FA4A:        A0 02         LDY.B #$02                ; \  
CODE_00FA4C:        A9 60         LDA.B #$60                ;  |Set sprite x02 to x60 (Flat palace switch) 
CODE_00FA4E:        99 9E 00      STA.W RAM_SpriteNum,Y     ; /  
CODE_00FA51:        A9 08         LDA.B #$08                ; \ Set sprite's status to x08 
CODE_00FA53:        99 C8 14      STA.W $14C8,Y             ; /  
CODE_00FA56:        A5 9A         LDA RAM_BlockYLo          ; \  
CODE_00FA58:        29 F0         AND.B #$F0                ;  |Set sprite X (low) to $9A & 0xF0 
CODE_00FA5A:        99 E4 00      STA.W RAM_SpriteXLo,Y     ; /  
CODE_00FA5D:        A5 9B         LDA RAM_BlockYHi          ; \ Set sprite X (high) to $9B 
CODE_00FA5F:        99 E0 14      STA.W RAM_SpriteXHi,Y     ; /  
CODE_00FA62:        A5 98         LDA RAM_BlockXLo          ; \  
CODE_00FA64:        29 F0         AND.B #$F0                ;  | 
CODE_00FA66:        18            CLC                       ;  |Set sprite Y (low) to ($98 & 0xF0) + 0x10 
CODE_00FA67:        69 10         ADC.B #$10                ;  | 
CODE_00FA69:        99 D8 00      STA.W RAM_SpriteYLo,Y     ; /  
CODE_00FA6C:        A5 99         LDA RAM_BlockXHi          ; \  
CODE_00FA6E:        69 00         ADC.B #$00                ;  |Set sprite Y (high) to $99 + carry 
CODE_00FA70:        99 D4 14      STA.W RAM_SpriteYHi,Y     ; / (Carry carried over from previous addition) 
CODE_00FA73:        DA            PHX                       
CODE_00FA74:        BB            TYX                       
CODE_00FA75:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_00FA79:        FA            PLX                       
CODE_00FA7A:        A9 5F         LDA.B #$5F                ; \ Set sprite's "Spin Jump Death Frame Counter" to x5F 
CODE_00FA7C:        99 40 15      STA.W $1540,Y             ; /  
Return00FA7F:       60            RTS                       ; Return 

TriggerGoalTape:    9C F3 13      STZ.W $13F3               
CODE_00FA83:        9C 91 18      STZ.W $1891               
CODE_00FA86:        9C C0 18      STZ.W RAM_TimeTillRespawn ; Don't respawn sprites 
CODE_00FA89:        9C B9 18      STZ.W RAM_GeneratorNum    
CODE_00FA8C:        9C DD 18      STZ.W $18DD               
CODE_00FA8F:        A0 0B         LDY.B #$0B                ; Loop over sprites: 
LvlEndSprLoopStrt:  B9 C8 14      LDA.W $14C8,Y             ; \ If sprite status < 8, 
CODE_00FA94:        C9 08         CMP.B #$08                ;  | skip the current sprite 
CODE_00FA96:        90 39         BCC LvlEndNextSprite      ; / 
CODE_00FA98:        C9 0B         CMP.B #$0B                ; \ If Mario carries a sprite past the goal, 
CODE_00FA9A:        D0 07         BNE CODE_00FAA3           ;  | 
CODE_00FA9C:        DA            PHX                       ;  | 
CODE_00FA9D:        20 00 FB      JSR.W LvlEndPowerUp       ;  | he gets a powerup 
CODE_00FAA0:        FA            PLX                       ;  | 
CODE_00FAA1:        80 2E         BRA LvlEndNextSprite      ; / 

CODE_00FAA3:        B9 9E 00      LDA.W RAM_SpriteNum,Y     ; \ Branch if goal tape 
CODE_00FAA6:        C9 7B         CMP.B #$7B                ;  | 
CODE_00FAA8:        F0 08         BEQ CODE_00FAB2           ; / 
CODE_00FAAA:        B9 A0 15      LDA.W RAM_OffscreenHorz,Y ; \ If sprite on screen... 
CODE_00FAAD:        19 6C 18      ORA.W RAM_OffscreenVert,Y ;  | 
CODE_00FAB0:        D0 13         BNE CODE_00FAC5           ;  | 
CODE_00FAB2:        B9 86 16      LDA.W RAM_Tweaker1686,Y   ;  | ...and "don't turn into coin" not set, 
CODE_00FAB5:        29 20         AND.B #$20                ;  | 
CODE_00FAB7:        D0 0C         BNE CODE_00FAC5           ;  | 
CODE_00FAB9:        A9 10         LDA.B #$10                ;  | Set coin animation timer = #$10 
CODE_00FABB:        99 40 15      STA.W $1540,Y             ;  | 
CODE_00FABE:        A9 06         LDA.B #$06                ;  | Sprite status = Level end, turn to coins 
CODE_00FAC0:        99 C8 14      STA.W $14C8,Y             ;  | 
CODE_00FAC3:        80 0C         BRA LvlEndNextSprite      ; / 

CODE_00FAC5:        B9 0F 19      LDA.W RAM_Tweaker190F,Y   ; \ If "don't erase" not set, 
CODE_00FAC8:        29 02         AND.B #$02                ;  | 
CODE_00FACA:        D0 05         BNE LvlEndNextSprite      ;  | 
CODE_00FACC:        A9 00         LDA.B #$00                ;  | Erase sprite 
CODE_00FACE:        99 C8 14      STA.W $14C8,Y             ; / 
LvlEndNextSprite:   88            DEY                       ; \ Goto next sprite 
CODE_00FAD2:        10 BD         BPL LvlEndSprLoopStrt     ; / 
CODE_00FAD4:        A0 07         LDY.B #$07                ; \ 
CODE_00FAD6:        A9 00         LDA.B #$00                ;  | Clear out all extended sprites 
CODE_00FAD8:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ;  | 
CODE_00FADB:        88            DEY                       ;  | 
CODE_00FADC:        10 FA         BPL CODE_00FAD8           ; / 
Return00FADE:       6B            RTL                       ; Return 


DATA_00FADF:                      .db $74,$74,$77,$75,$76,$E0,$F0,$74
                                  .db $74,$77,$75,$76,$E0,$F1,$F0,$F0
                                  .db $F0,$F0,$F1,$E0,$F2,$E0,$E0,$E0
                                  .db $E0,$F1,$E0,$E4

DATA_00FAFB:                      .db $FF,$74,$75,$76,$77

LvlEndPowerUp:      A6 19         LDX RAM_MarioPowerUp      ; X = Mario's power up status 
CODE_00FB02:        AD 90 14      LDA.W $1490               ; \ If Mario has star, X = #$04.  However this never happens as $1490 is cleared earlier 
CODE_00FB05:        F0 02         BEQ CODE_00FB09           ;  | Otherwise Mario could get a star from carrying a sprite past the goal. 
ADDR_00FB07:        A2 04         LDX.B #$04                ; / Unreachable instruction 
CODE_00FB09:        AD 7A 18      LDA.W RAM_OnYoshi         ; \ If Mario on Yoshi, X = #$05 
CODE_00FB0C:        F0 02         BEQ CODE_00FB10           ;  | 
ADDR_00FB0E:        A2 05         LDX.B #$05                ; / 
CODE_00FB10:        B9 9E 00      LDA.W RAM_SpriteNum,Y     ; \ If Spring Board, X += #$07 
CODE_00FB13:        C9 2F         CMP.B #$2F                ;  | 
CODE_00FB15:        F0 16         BEQ CODE_00FB2D           ; / 
CODE_00FB17:        C9 3E         CMP.B #$3E                ; \ If P Switch, X += #$07 
CODE_00FB19:        F0 12         BEQ CODE_00FB2D           ; / 
CODE_00FB1B:        C9 80         CMP.B #$80                ; \ If Key, X += #$0E 
CODE_00FB1D:        F0 09         BEQ ADDR_00FB28           ; / 
CODE_00FB1F:        C9 2D         CMP.B #$2D                ; \ If Baby Yoshi, X += #$15 
CODE_00FB21:        D0 0F         BNE CODE_00FB32           ; / 
ADDR_00FB23:        8A            TXA                       
ADDR_00FB24:        18            CLC                       
ADDR_00FB25:        69 07         ADC.B #$07                
ADDR_00FB27:        AA            TAX                       
ADDR_00FB28:        8A            TXA                       
ADDR_00FB29:        18            CLC                       
ADDR_00FB2A:        69 07         ADC.B #$07                
ADDR_00FB2C:        AA            TAX                       
CODE_00FB2D:        8A            TXA                       
CODE_00FB2E:        18            CLC                       
CODE_00FB2F:        69 07         ADC.B #$07                
CODE_00FB31:        AA            TAX                       
CODE_00FB32:        BF DF FA 00   LDA.L DATA_00FADF,X       
CODE_00FB36:        AE C2 0D      LDX.W $0DC2               
CODE_00FB39:        DF FB FA 00   CMP.L DATA_00FAFB,X       
CODE_00FB3D:        D0 02         BNE CODE_00FB41           
CODE_00FB3F:        A9 78         LDA.B #$78                
CODE_00FB41:        64 0F         STZ $0F                   
CODE_00FB43:        C9 E0         CMP.B #$E0                
CODE_00FB45:        90 0E         BCC LvlEndStoreSpr        
ADDR_00FB47:        48            PHA                       
ADDR_00FB48:        29 0F         AND.B #$0F                
ADDR_00FB4A:        85 0F         STA $0F                   
ADDR_00FB4C:        68            PLA                       
ADDR_00FB4D:        C9 F0         CMP.B #$F0                
ADDR_00FB4F:        A9 78         LDA.B #$78                
ADDR_00FB51:        B0 02         BCS LvlEndStoreSpr        
ADDR_00FB53:        A9 78         LDA.B #$78                
LvlEndStoreSpr:     99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_00FB58:        C9 76         CMP.B #$76                
CODE_00FB5A:        D0 03         BNE CODE_00FB5F           
ADDR_00FB5C:        EE CB 13      INC.W $13CB               
CODE_00FB5F:        BB            TYX                       
CODE_00FB60:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_00FB64:        A5 0F         LDA $0F                   
CODE_00FB66:        99 94 15      STA.W $1594,Y             
CODE_00FB69:        A9 0C         LDA.B #$0C                ; \ Sprite status = Goal tape power up 
CODE_00FB6B:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_00FB6E:        A9 D0         LDA.B #$D0                
CODE_00FB70:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_00FB73:        A9 05         LDA.B #$05                
CODE_00FB75:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_00FB78:        A9 20         LDA.B #$20                
CODE_00FB7A:        99 4C 15      STA.W RAM_DisableInter,Y  
CODE_00FB7D:        A9 0C         LDA.B #$0C                
CODE_00FB7F:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_00FB82:        A2 03         LDX.B #$03                
CODE_00FB84:        BD C0 17      LDA.W $17C0,X             
CODE_00FB87:        F0 04         BEQ CODE_00FB8D           
ADDR_00FB89:        CA            DEX                       
ADDR_00FB8A:        10 F8         BPL CODE_00FB84           
Return00FB8C:       60            RTS                       ; Return 

CODE_00FB8D:        A9 01         LDA.B #$01                
CODE_00FB8F:        9D C0 17      STA.W $17C0,X             
CODE_00FB92:        B9 D8 00      LDA.W RAM_SpriteYLo,Y     
CODE_00FB95:        9D C4 17      STA.W $17C4,X             
CODE_00FB98:        B9 E4 00      LDA.W RAM_SpriteXLo,Y     
CODE_00FB9B:        9D C8 17      STA.W $17C8,X             
CODE_00FB9E:        A9 1B         LDA.B #$1B                
CODE_00FBA0:        9D CC 17      STA.W $17CC,X             
Return00FBA3:       60            RTS                       ; Return 


LvlEndSmokeTiles:                 .db $66,$64,$62,$60,$E8,$EA,$EC,$EA

LvlEndSprCoins:     8B            PHB                       
CODE_00FBAD:        4B            PHK                       
CODE_00FBAE:        AB            PLB                       
CODE_00FBAF:        20 B4 FB      JSR.W LvlEndSprCoinsRt    
CODE_00FBB2:        AB            PLB                       
Return00FBB3:       6B            RTL                       ; Return 

LvlEndSprCoinsRt:   A0 00         LDY.B #$00                
CODE_00FBB6:        AD BD 17      LDA.W $17BD               
CODE_00FBB9:        10 01         BPL CODE_00FBBC           
ADDR_00FBBB:        88            DEY                       
CODE_00FBBC:        18            CLC                       
CODE_00FBBD:        75 E4         ADC RAM_SpriteXLo,X       
CODE_00FBBF:        95 E4         STA RAM_SpriteXLo,X       
CODE_00FBC1:        98            TYA                       
CODE_00FBC2:        7D E0 14      ADC.W RAM_SpriteXHi,X     
CODE_00FBC5:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_00FBC8:        BD 40 15      LDA.W $1540,X             
CODE_00FBCB:        F0 23         BEQ CODE_00FBF0           
CODE_00FBCD:        C9 01         CMP.B #$01                
CODE_00FBCF:        D0 04         BNE CODE_00FBD5           
CODE_00FBD1:        A9 D0         LDA.B #$D0                
CODE_00FBD3:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_00FBD5:        DA            PHX                       
CODE_00FBD6:        A9 04         LDA.B #$04                ; \ Use Palette A 
CODE_00FBD8:        9D F6 15      STA.W RAM_SpritePal,X     ; / 
CODE_00FBDB:        22 B2 90 01   JSL.L GenericSprGfxRt2    
CODE_00FBDF:        BD 40 15      LDA.W $1540,X             
CODE_00FBE2:        4A            LSR                       
CODE_00FBE3:        4A            LSR                       
CODE_00FBE4:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_00FBE7:        AA            TAX                       
CODE_00FBE8:        BD A4 FB      LDA.W LvlEndSmokeTiles,X  
CODE_00FBEB:        99 02 03      STA.W OAM_Tile,Y          
CODE_00FBEE:        FA            PLX                       
Return00FBEF:       60            RTS                       ; Return 

CODE_00FBF0:        FE 70 15      INC.W $1570,X             
CODE_00FBF3:        22 1A 80 01   JSL.L UpdateYPosNoGrvty   
CODE_00FBF7:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_00FBF9:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_00FBFB:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_00FBFD:        C9 20         CMP.B #$20                
CODE_00FBFF:        30 1D         BMI CODE_00FC1E           
CODE_00FC01:        22 4A B3 05   JSL.L CODE_05B34A         
CODE_00FC05:        AD DD 18      LDA.W $18DD               
CODE_00FC08:        C9 0D         CMP.B #$0D                
CODE_00FC0A:        90 02         BCC CODE_00FC0E           
ADDR_00FC0C:        A9 0D         LDA.B #$0D                
CODE_00FC0E:        22 E5 AC 02   JSL.L GivePoints          
CODE_00FC12:        AD DD 18      LDA.W $18DD               
CODE_00FC15:        18            CLC                       
CODE_00FC16:        69 02         ADC.B #$02                
CODE_00FC18:        8D DD 18      STA.W $18DD               
CODE_00FC1B:        9E C8 14      STZ.W $14C8,X             
CODE_00FC1E:        22 41 C6 01   JSL.L CoinSprGfx          
Return00FC22:       60            RTS                       ; Return 

ADDR_00FC23:        A0 0B         LDY.B #$0B                ; \ Unreachable instructions 
ADDR_00FC25:        B9 C8 14      LDA.W $14C8,Y             ; / Status = Carried 
ADDR_00FC28:        C9 08         CMP.B #$08                
ADDR_00FC2A:        D0 47         BNE ADDR_00FC73           
ADDR_00FC2C:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
ADDR_00FC2F:        C9 35         CMP.B #$35                
ADDR_00FC31:        D0 40         BNE ADDR_00FC73           
ADDR_00FC33:        A9 01         LDA.B #$01                
ADDR_00FC35:        8D C1 0D      STA.W RAM_OWHasYoshi      
ADDR_00FC38:        9C 1E 14      STZ.W RAM_YoshiHasWings   ; No Yoshi wings 
ADDR_00FC3B:        B9 F6 15      LDA.W RAM_SpritePal,Y     
ADDR_00FC3E:        29 F1         AND.B #$F1                
ADDR_00FC40:        09 0A         ORA.B #$0A                
ADDR_00FC42:        99 F6 15      STA.W RAM_SpritePal,Y     
ADDR_00FC45:        AD 7A 18      LDA.W RAM_OnYoshi         
ADDR_00FC48:        D0 28         BNE Return00FC72          
ADDR_00FC4A:        A5 1A         LDA RAM_ScreenBndryXLo    
ADDR_00FC4C:        38            SEC                       
ADDR_00FC4D:        E9 10         SBC.B #$10                
ADDR_00FC4F:        99 E4 00      STA.W RAM_SpriteXLo,Y     
ADDR_00FC52:        A5 1B         LDA RAM_ScreenBndryXHi    
ADDR_00FC54:        E9 00         SBC.B #$00                
ADDR_00FC56:        99 E0 14      STA.W RAM_SpriteXHi,Y     
ADDR_00FC59:        A5 96         LDA RAM_MarioYPos         
ADDR_00FC5B:        99 D8 00      STA.W RAM_SpriteYLo,Y     
ADDR_00FC5E:        A5 97         LDA RAM_MarioYPosHi       
ADDR_00FC60:        99 D4 14      STA.W RAM_SpriteYHi,Y     
ADDR_00FC63:        A9 03         LDA.B #$03                
ADDR_00FC65:        99 C2 00      STA.W RAM_SpriteState,Y   
ADDR_00FC68:        A9 00         LDA.B #$00                
ADDR_00FC6A:        99 7C 15      STA.W RAM_SpriteDir,Y     
ADDR_00FC6D:        A9 10         LDA.B #$10                
ADDR_00FC6F:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
Return00FC72:       6B            RTL                       ; Return 

ADDR_00FC73:        88            DEY                       
ADDR_00FC74:        10 AF         BPL ADDR_00FC25           
ADDR_00FC76:        9C C1 0D      STZ.W RAM_OWHasYoshi      
Return00FC79:       6B            RTL                       ; Return 

CODE_00FC7A:        A9 02         LDA.B #$02                
CODE_00FC7C:        8D FA 1D      STA.W $1DFA               ; / Play sound effect 
CODE_00FC7F:        A2 00         LDX.B #$00                
CODE_00FC81:        AD 94 1B      LDA.W $1B94               
CODE_00FC84:        D0 12         BNE CODE_00FC98           
CODE_00FC86:        A2 05         LDX.B #$05                
CODE_00FC88:        AD 92 16      LDA.W $1692               
CODE_00FC8B:        C9 0A         CMP.B #$0A                
CODE_00FC8D:        F0 09         BEQ CODE_00FC98           
CODE_00FC8F:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ X = First free sprite slot, #$03 if none free 
CODE_00FC93:        BB            TYX                       ;  | 
CODE_00FC94:        10 02         BPL CODE_00FC98           ;  | 
CODE_00FC96:        A2 03         LDX.B #$03                ; / 
CODE_00FC98:        A9 08         LDA.B #$08                ; \ Status = Normal 
CODE_00FC9A:        9D C8 14      STA.W $14C8,X             ; / 
CODE_00FC9D:        A9 35         LDA.B #$35                ; \ Sprite = Yoshi 
CODE_00FC9F:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_00FCA1:        A5 94         LDA RAM_MarioXPos         ; \ Yoshi X position = Mario X position 
CODE_00FCA3:        95 E4         STA RAM_SpriteXLo,X       ;  | 
CODE_00FCA5:        A5 95         LDA RAM_MarioXPosHi       ;  | 
CODE_00FCA7:        9D E0 14      STA.W RAM_SpriteXHi,X     ; / 
CODE_00FCAA:        A5 96         LDA RAM_MarioYPos         ; \ Yoshi's Y position = Mario Y position - #$10 
CODE_00FCAC:        38            SEC                       ;  | Mario Y position = Mario Y position - #$10 
CODE_00FCAD:        E9 10         SBC.B #$10                ;  | 
CODE_00FCAF:        85 96         STA RAM_MarioYPos         ;  | 
CODE_00FCB1:        95 D8         STA RAM_SpriteYLo,X       ;  | 
CODE_00FCB3:        A5 97         LDA RAM_MarioYPosHi       ;  | 
CODE_00FCB5:        E9 00         SBC.B #$00                ;  | 
CODE_00FCB7:        85 97         STA RAM_MarioYPosHi       ;  | 
CODE_00FCB9:        9D D4 14      STA.W RAM_SpriteYHi,X     ; / 
CODE_00FCBC:        22 D2 F7 07   JSL.L InitSpriteTables    ; Reset sprite tables 
CODE_00FCC0:        A9 04         LDA.B #$04                
CODE_00FCC2:        9D E2 1F      STA.W $1FE2,X             
CODE_00FCC5:        AD C7 13      LDA.W RAM_YoshiColor      ; \ Set Yoshi palette 
CODE_00FCC8:        9D F6 15      STA.W RAM_SpritePal,X     ; / 
CODE_00FCCB:        AD 95 1B      LDA.W $1B95               
CODE_00FCCE:        F0 05         BEQ CODE_00FCD5           
CODE_00FCD0:        A9 06         LDA.B #$06                
CODE_00FCD2:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_00FCD5:        EE 7A 18      INC.W RAM_OnYoshi         
CODE_00FCD8:        F6 C2         INC RAM_SpriteState,X     
CODE_00FCDA:        A5 76         LDA RAM_MarioDirection    
CODE_00FCDC:        49 01         EOR.B #$01                
CODE_00FCDE:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_00FCE1:        DE 0E 16      DEC.W $160E,X             
CODE_00FCE4:        E8            INX                       
CODE_00FCE5:        8E DF 18      STX.W $18DF               
CODE_00FCE8:        8E E2 18      STX.W $18E2               
Return00FCEB:       6B            RTL                       ; Return 

CODE_00FCEC:        A2 0B         LDX.B #$0B                
CODE_00FCEE:        9E C8 14      STZ.W $14C8,X             
CODE_00FCF1:        CA            DEX                       
CODE_00FCF2:        10 FA         BPL CODE_00FCEE           
Return00FCF4:       60            RTS                       ; Return 

CODE_00FCF5:        A9 A0         LDA.B #$A0                
CODE_00FCF7:        95 E4         STA RAM_SpriteXLo,X       
CODE_00FCF9:        A9 00         LDA.B #$00                
CODE_00FCFB:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_00FCFE:        A9 00         LDA.B #$00                
CODE_00FD00:        95 D8         STA RAM_SpriteYLo,X       
CODE_00FD02:        A9 00         LDA.B #$00                
CODE_00FD04:        9D D4 14      STA.W RAM_SpriteYHi,X     
Return00FD07:       6B            RTL                       ; Return 

CODE_00FD08:        A0 3F         LDY.B #$3F                
CODE_00FD0A:        A5 15         LDA RAM_ControllerA       
CODE_00FD0C:        29 83         AND.B #$83                
CODE_00FD0E:        D0 02         BNE CODE_00FD12           
CODE_00FD10:        A0 7F         LDY.B #$7F                
CODE_00FD12:        98            TYA                       
CODE_00FD13:        25 14         AND RAM_FrameCounterB     
CODE_00FD15:        05 9D         ORA RAM_SpritesLocked     
CODE_00FD17:        D0 0A         BNE Return00FD23          
CODE_00FD19:        A2 07         LDX.B #$07                ; \ Find a free extended sprite slot 
CODE_00FD1B:        BD 0B 17      LDA.W RAM_ExSpriteNum,X   ;  | 
CODE_00FD1E:        F0 06         BEQ CODE_00FD26           ;  | 
CODE_00FD20:        CA            DEX                       ;  | 
CODE_00FD21:        10 F8         BPL CODE_00FD1B           ;  | 
Return00FD23:       60            RTS                       ; / Return if no free slots 


DATA_00FD24:                      .db $02,$0A

CODE_00FD26:        A9 12         LDA.B #$12                ; \ Extended sprite = Water buble 
CODE_00FD28:        9D 0B 17      STA.W RAM_ExSpriteNum,X   ; / 
CODE_00FD2B:        A4 76         LDY RAM_MarioDirection    
CODE_00FD2D:        A5 94         LDA RAM_MarioXPos         
CODE_00FD2F:        18            CLC                       
CODE_00FD30:        79 24 FD      ADC.W DATA_00FD24,Y       
CODE_00FD33:        9D 1F 17      STA.W RAM_ExSpriteXLo,X   
CODE_00FD36:        A5 95         LDA RAM_MarioXPosHi       
CODE_00FD38:        69 00         ADC.B #$00                
CODE_00FD3A:        9D 33 17      STA.W RAM_ExSpriteXHi,X   
CODE_00FD3D:        A5 19         LDA RAM_MarioPowerUp      
CODE_00FD3F:        F0 06         BEQ CODE_00FD47           
CODE_00FD41:        A9 04         LDA.B #$04                
CODE_00FD43:        A4 73         LDY RAM_IsDucking         
CODE_00FD45:        F0 02         BEQ CODE_00FD49           
CODE_00FD47:        A9 0C         LDA.B #$0C                
CODE_00FD49:        18            CLC                       
CODE_00FD4A:        65 96         ADC RAM_MarioYPos         
CODE_00FD4C:        9D 15 17      STA.W RAM_ExSpriteYLo,X   
CODE_00FD4F:        A5 97         LDA RAM_MarioYPosHi       
CODE_00FD51:        69 00         ADC.B #$00                
CODE_00FD53:        9D 29 17      STA.W RAM_ExSpriteYHi,X   
CODE_00FD56:        9E 6F 17      STZ.W $176F,X             
Return00FD59:       60            RTS                       ; Return 

CODE_00FD5A:        A5 7F         LDA $7F                   
CODE_00FD5C:        05 81         ORA $81                   
CODE_00FD5E:        D0 0A         BNE Return00FD6A          
CODE_00FD60:        A0 03         LDY.B #$03                
CODE_00FD62:        B9 C0 17      LDA.W $17C0,Y             
CODE_00FD65:        F0 04         BEQ CODE_00FD6B           
CODE_00FD67:        88            DEY                       
CODE_00FD68:        10 F8         BPL CODE_00FD62           
Return00FD6A:       60            RTS                       ; Return 

CODE_00FD6B:        A9 05         LDA.B #$05                
CODE_00FD6D:        99 C0 17      STA.W $17C0,Y             
CODE_00FD70:        A5 9A         LDA RAM_BlockYLo          
CODE_00FD72:        29 F0         AND.B #$F0                
CODE_00FD74:        99 C8 17      STA.W $17C8,Y             
CODE_00FD77:        A5 98         LDA RAM_BlockXLo          
CODE_00FD79:        29 F0         AND.B #$F0                
CODE_00FD7B:        99 C4 17      STA.W $17C4,Y             
CODE_00FD7E:        AD 33 19      LDA.W $1933               
CODE_00FD81:        F0 14         BEQ CODE_00FD97           
ADDR_00FD83:        A5 9A         LDA RAM_BlockYLo          
ADDR_00FD85:        38            SEC                       
ADDR_00FD86:        E5 26         SBC $26                   
ADDR_00FD88:        29 F0         AND.B #$F0                
ADDR_00FD8A:        99 C8 17      STA.W $17C8,Y             
ADDR_00FD8D:        A5 98         LDA RAM_BlockXLo          
ADDR_00FD8F:        38            SEC                       
ADDR_00FD90:        E5 28         SBC $28                   
ADDR_00FD92:        29 F0         AND.B #$F0                
ADDR_00FD94:        99 C4 17      STA.W $17C4,Y             
CODE_00FD97:        A9 10         LDA.B #$10                
CODE_00FD99:        99 CC 17      STA.W $17CC,Y             
Return00FD9C:       60            RTS                       ; Return 


DATA_00FD9D:                      .db $08,$FC,$10,$04

DATA_00FDA1:                      .db $00,$FF,$00,$00

CODE_00FDA5:        A5 72         LDA RAM_IsFlying          
CODE_00FDA7:        F0 0A         BEQ CODE_00FDB3           
CODE_00FDA9:        A0 0B         LDY.B #$0B                
CODE_00FDAB:        B9 F0 17      LDA.W $17F0,Y             
CODE_00FDAE:        F0 04         BEQ CODE_00FDB4           
CODE_00FDB0:        88            DEY                       
CODE_00FDB1:        10 F8         BPL CODE_00FDAB           
CODE_00FDB3:        C8            INY                       
CODE_00FDB4:        DA            PHX                       
CODE_00FDB5:        A2 00         LDX.B #$00                
CODE_00FDB7:        A5 19         LDA RAM_MarioPowerUp      
CODE_00FDB9:        F0 01         BEQ CODE_00FDBC           
CODE_00FDBB:        E8            INX                       
CODE_00FDBC:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_00FDBF:        F0 02         BEQ CODE_00FDC3           
CODE_00FDC1:        E8            INX                       
CODE_00FDC2:        E8            INX                       
CODE_00FDC3:        A5 96         LDA RAM_MarioYPos         
CODE_00FDC5:        18            CLC                       
CODE_00FDC6:        7D 9D FD      ADC.W DATA_00FD9D,X       
CODE_00FDC9:        08            PHP                       
CODE_00FDCA:        29 F0         AND.B #$F0                
CODE_00FDCC:        18            CLC                       
CODE_00FDCD:        69 03         ADC.B #$03                
CODE_00FDCF:        99 FC 17      STA.W $17FC,Y             
CODE_00FDD2:        A5 97         LDA RAM_MarioYPosHi       
CODE_00FDD4:        69 00         ADC.B #$00                
CODE_00FDD6:        28            PLP                       
CODE_00FDD7:        7D A1 FD      ADC.W DATA_00FDA1,X       
CODE_00FDDA:        99 14 18      STA.W $1814,Y             
CODE_00FDDD:        FA            PLX                       
CODE_00FDDE:        A5 94         LDA RAM_MarioXPos         
CODE_00FDE0:        99 08 18      STA.W $1808,Y             
CODE_00FDE3:        A5 95         LDA RAM_MarioXPosHi       
CODE_00FDE5:        99 EA 18      STA.W $18EA,Y             
CODE_00FDE8:        A9 07         LDA.B #$07                
CODE_00FDEA:        99 F0 17      STA.W $17F0,Y             
CODE_00FDED:        A9 00         LDA.B #$00                
CODE_00FDEF:        99 50 18      STA.W $1850,Y             
CODE_00FDF2:        A5 7D         LDA RAM_MarioSpeedY       
CODE_00FDF4:        30 17         BMI Return00FE0D          
CODE_00FDF6:        64 7D         STZ RAM_MarioSpeedY       
CODE_00FDF8:        A4 72         LDY RAM_IsFlying          
CODE_00FDFA:        F0 02         BEQ CODE_00FDFE           
CODE_00FDFC:        64 7B         STZ RAM_MarioSpeedX       
CODE_00FDFE:        A0 03         LDY.B #$03                
CODE_00FE00:        A5 19         LDA RAM_MarioPowerUp      
CODE_00FE02:        D0 01         BNE CODE_00FE05           
CODE_00FE04:        88            DEY                       
CODE_00FE05:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   
CODE_00FE08:        F0 0C         BEQ CODE_00FE16           
CODE_00FE0A:        88            DEY                       
CODE_00FE0B:        10 F8         BPL CODE_00FE05           
Return00FE0D:       60            RTS                       ; Return 


DATA_00FE0E:                      .db $10,$16,$13,$1C

DATA_00FE12:                      .db $00,$04,$0A,$07

CODE_00FE16:        A9 12         LDA.B #$12                ; \ Extended sprite = Water bubble 
CODE_00FE18:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_00FE1B:        98            TYA                       
CODE_00FE1C:        0A            ASL                       
CODE_00FE1D:        0A            ASL                       
CODE_00FE1E:        0A            ASL                       
CODE_00FE1F:        69 F7         ADC.B #$F7                
CODE_00FE21:        99 65 17      STA.W $1765,Y             
CODE_00FE24:        A5 96         LDA RAM_MarioYPos         
CODE_00FE26:        79 0E FE      ADC.W DATA_00FE0E,Y       
CODE_00FE29:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
CODE_00FE2C:        A5 97         LDA RAM_MarioYPosHi       
CODE_00FE2E:        69 00         ADC.B #$00                
CODE_00FE30:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
CODE_00FE33:        A5 94         LDA RAM_MarioXPos         
CODE_00FE35:        79 12 FE      ADC.W DATA_00FE12,Y       
CODE_00FE38:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
CODE_00FE3B:        A5 95         LDA RAM_MarioXPosHi       
CODE_00FE3D:        69 00         ADC.B #$00                
CODE_00FE3F:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
CODE_00FE42:        A9 00         LDA.B #$00                
CODE_00FE44:        99 6F 17      STA.W $176F,Y             
CODE_00FE47:        4C 0A FE      JMP.W CODE_00FE0A         

CODE_00FE4A:        A5 13         LDA RAM_FrameCounter      
CODE_00FE4C:        29 03         AND.B #$03                
CODE_00FE4E:        05 72         ORA RAM_IsFlying          
CODE_00FE50:        05 7F         ORA $7F                   
CODE_00FE52:        05 81         ORA $81                   
CODE_00FE54:        05 9D         ORA RAM_SpritesLocked     
CODE_00FE56:        D0 19         BNE Return00FE71          
CODE_00FE58:        A5 15         LDA RAM_ControllerA       
CODE_00FE5A:        29 04         AND.B #$04                
CODE_00FE5C:        F0 09         BEQ CODE_00FE67           
CODE_00FE5E:        A5 7B         LDA RAM_MarioSpeedX       
CODE_00FE60:        18            CLC                       
CODE_00FE61:        69 08         ADC.B #$08                
CODE_00FE63:        C9 10         CMP.B #$10                
CODE_00FE65:        90 0A         BCC Return00FE71          
CODE_00FE67:        A0 03         LDY.B #$03                
CODE_00FE69:        B9 C0 17      LDA.W $17C0,Y             
CODE_00FE6C:        F0 04         BEQ CODE_00FE72           
CODE_00FE6E:        88            DEY                       
CODE_00FE6F:        D0 F8         BNE CODE_00FE69           
Return00FE71:       60            RTS                       ; Return 

CODE_00FE72:        A9 03         LDA.B #$03                
CODE_00FE74:        99 C0 17      STA.W $17C0,Y             
CODE_00FE77:        A5 94         LDA RAM_MarioXPos         
CODE_00FE79:        69 04         ADC.B #$04                
CODE_00FE7B:        99 C8 17      STA.W $17C8,Y             
CODE_00FE7E:        A5 96         LDA RAM_MarioYPos         
CODE_00FE80:        69 1A         ADC.B #$1A                
CODE_00FE82:        DA            PHX                       
CODE_00FE83:        AE 7A 18      LDX.W RAM_OnYoshi         
CODE_00FE86:        F0 02         BEQ CODE_00FE8A           
CODE_00FE88:        69 10         ADC.B #$10                
CODE_00FE8A:        99 C4 17      STA.W $17C4,Y             
CODE_00FE8D:        FA            PLX                       
CODE_00FE8E:        A9 13         LDA.B #$13                
CODE_00FE90:        99 CC 17      STA.W $17CC,Y             
Return00FE93:       60            RTS                       ; Return 


DATA_00FE94:                      .db $FD,$03

DATA_00FE96:                      .db $00,$08,$F8,$10,$F8,$10

DATA_00FE9C:                      .db $00,$00,$FF,$00,$FF,$00

DATA_00FEA2:                      .db $08,$08,$0C,$0C,$14,$14

ShootFireball:      A2 09         LDX.B #$09                ; \ Find a free fireball slot (08-09) 
CODE_00FEAA:        BD 0B 17      LDA.W RAM_ExSpriteNum,X   ;  | 
CODE_00FEAD:        F0 06         BEQ CODE_00FEB5           ;  | 
CODE_00FEAF:        CA            DEX                       ;  | 
CODE_00FEB0:        E0 07         CPX.B #$07                ;  | 
CODE_00FEB2:        D0 F6         BNE CODE_00FEAA           ;  | 
Return00FEB4:       60            RTS                       ; / Return if no free slots 

CODE_00FEB5:        A9 06         LDA.B #$06                
CODE_00FEB7:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_00FEBA:        A9 0A         LDA.B #$0A                
CODE_00FEBC:        8D 9C 14      STA.W RAM_FireballImgTimer 
CODE_00FEBF:        A9 05         LDA.B #$05                ; \ Extended sprite = Mario fireball 
CODE_00FEC1:        9D 0B 17      STA.W RAM_ExSpriteNum,X   ; / 
CODE_00FEC4:        A9 30         LDA.B #$30                
CODE_00FEC6:        9D 3D 17      STA.W RAM_ExSprSpeedY,X   
CODE_00FEC9:        A4 76         LDY RAM_MarioDirection    
CODE_00FECB:        B9 94 FE      LDA.W DATA_00FE94,Y       
CODE_00FECE:        9D 47 17      STA.W RAM_ExSprSpeedX,X   
CODE_00FED1:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_00FED4:        F0 09         BEQ CODE_00FEDF           
ADDR_00FED6:        C8            INY                       
ADDR_00FED7:        C8            INY                       
ADDR_00FED8:        AD DC 18      LDA.W $18DC               
ADDR_00FEDB:        F0 02         BEQ CODE_00FEDF           
ADDR_00FEDD:        C8            INY                       
ADDR_00FEDE:        C8            INY                       
CODE_00FEDF:        A5 94         LDA RAM_MarioXPos         
CODE_00FEE1:        18            CLC                       
CODE_00FEE2:        79 96 FE      ADC.W DATA_00FE96,Y       
CODE_00FEE5:        9D 1F 17      STA.W RAM_ExSpriteXLo,X   
CODE_00FEE8:        A5 95         LDA RAM_MarioXPosHi       
CODE_00FEEA:        79 9C FE      ADC.W DATA_00FE9C,Y       
CODE_00FEED:        9D 33 17      STA.W RAM_ExSpriteXHi,X   
CODE_00FEF0:        A5 96         LDA RAM_MarioYPos         
CODE_00FEF2:        18            CLC                       
CODE_00FEF3:        79 A2 FE      ADC.W DATA_00FEA2,Y       
CODE_00FEF6:        9D 15 17      STA.W RAM_ExSpriteYLo,X   
CODE_00FEF9:        A5 97         LDA RAM_MarioYPosHi       
CODE_00FEFB:        69 00         ADC.B #$00                
CODE_00FEFD:        9D 29 17      STA.W RAM_ExSpriteYHi,X   
CODE_00FF00:        AD F9 13      LDA.W RAM_IsBehindScenery 
CODE_00FF03:        9D 79 17      STA.W $1779,X             
Return00FF06:       60            RTS                       ; Return 

ADDR_00FF07:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_00FF09:        AD BC 17      LDA.W $17BC               
ADDR_00FF0C:        29 00 FF      AND.W #$FF00              
ADDR_00FF0F:        10 03         BPL ADDR_00FF14           
ADDR_00FF11:        09 FF 00      ORA.W #$00FF              
ADDR_00FF14:        EB            XBA                       
ADDR_00FF15:        18            CLC                       
ADDR_00FF16:        65 94         ADC RAM_MarioXPos         
ADDR_00FF18:        85 94         STA RAM_MarioXPos         
ADDR_00FF1A:        AD BB 17      LDA.W $17BB               
ADDR_00FF1D:        29 00 FF      AND.W #$FF00              
ADDR_00FF20:        10 03         BPL ADDR_00FF25           
ADDR_00FF22:        09 FF 00      ORA.W #$00FF              
ADDR_00FF25:        EB            XBA                       
ADDR_00FF26:        49 FF FF      EOR.W #$FFFF              
ADDR_00FF29:        1A            INC A                     
ADDR_00FF2A:        18            CLC                       
ADDR_00FF2B:        65 96         ADC RAM_MarioYPos         
ADDR_00FF2D:        85 96         STA RAM_MarioYPos         
ADDR_00FF2F:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return00FF31:       6B            RTL                       ; Return 

ADDR_00FF32:        BD E0 14      LDA.W RAM_SpriteXHi,X     
ADDR_00FF35:        EB            XBA                       
ADDR_00FF36:        B5 E4         LDA RAM_SpriteXLo,X       
ADDR_00FF38:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_00FF3A:        38            SEC                       
ADDR_00FF3B:        E5 1A         SBC RAM_ScreenBndryXLo    
ADDR_00FF3D:        85 00         STA $00                   
ADDR_00FF3F:        A9 30 00      LDA.W #$0030              
ADDR_00FF42:        38            SEC                       
ADDR_00FF43:        E5 00         SBC $00                   
ADDR_00FF45:        85 22         STA $22                   
ADDR_00FF47:        E2 20         SEP #$20                  ; Accum (8 bit) 
ADDR_00FF49:        BD D4 14      LDA.W RAM_SpriteYHi,X     
ADDR_00FF4C:        EB            XBA                       
ADDR_00FF4D:        B5 D8         LDA RAM_SpriteYLo,X       
ADDR_00FF4F:        C2 20         REP #$20                  ; Accum (16 bit) 
ADDR_00FF51:        38            SEC                       
ADDR_00FF52:        E5 1C         SBC RAM_ScreenBndryYLo    
ADDR_00FF54:        85 00         STA $00                   
ADDR_00FF56:        A9 00 01      LDA.W #$0100              
ADDR_00FF59:        38            SEC                       
ADDR_00FF5A:        E5 00         SBC $00                   
ADDR_00FF5C:        85 24         STA $24                   
ADDR_00FF5E:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return00FF60:       6B            RTL                       ; Return 

CODE_00FF61:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_00FF64:        EB            XBA                       
CODE_00FF65:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_00FF67:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00FF69:        C9 00 FF      CMP.W #$FF00              
CODE_00FF6C:        30 05         BMI CODE_00FF73           
CODE_00FF6E:        C9 00 01      CMP.W #$0100              
CODE_00FF71:        30 03         BMI CODE_00FF76           
CODE_00FF73:        A9 00 01      LDA.W #$0100              
CODE_00FF76:        85 22         STA $22                   
CODE_00FF78:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_00FF7A:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_00FF7D:        EB            XBA                       
CODE_00FF7E:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_00FF80:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_00FF82:        85 00         STA $00                   
CODE_00FF84:        A9 A0 00      LDA.W #$00A0              
CODE_00FF87:        38            SEC                       
CODE_00FF88:        E5 00         SBC $00                   
CODE_00FF8A:        18            CLC                       
CODE_00FF8B:        6D 88 18      ADC.W RAM_Layer1DispYLo   
CODE_00FF8E:        85 24         STA $24                   
CODE_00FF90:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return00FF92:       6B            RTL                       ; Return 


DATA_00FF93:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$53,$55,$50
                                  .db $45,$52,$20,$4D,$41,$52,$49,$4F
                                  .db $57,$4F,$52,$4C,$44,$20,$20,$20
                                  .db $20,$20,$20,$02,$09,$01,$01,$01
                                  .db $00,$25,$5F,$DA,$A0,$FF,$FF,$FF
                                  .db $FF,$C3,$82,$FF,$FF,$C3,$82,$6A
                                  .db $81,$00,$80,$74,$83,$FF,$FF,$FF
                                  .db $FF,$C3,$82,$C3,$82,$C3,$82,$C3
                                  .db $82,$00,$80,$C3,$82