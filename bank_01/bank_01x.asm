DATA_018000:                      .db $80,$40,$20,$10,$08,$04,$02,$01

IsTouchingObjSide:  BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Set A to lower two bits of 
CODE_01800B:        29 03         AND.B #$03                ; / current sprite's Position Status 
Return01800D:       60            RTS                       ; Return 

IsOnGround:         BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Set A to bit 2 of 
CODE_018011:        29 04         AND.B #$04                ; / current sprite's Position Status 
Return018013:       60            RTS                       ; Return 

IsTouchingCeiling:  BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Set A to bit 3 of 
CODE_018017:        29 08         AND.B #$08                ; / current sprite's Position Status 
Return018019:       60            RTS                       ; Return 

UpdateYPosNoGrvty:  8B            PHB                       
CODE_01801B:        4B            PHK                       
CODE_01801C:        AB            PLB                       
CODE_01801D:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_018020:        AB            PLB                       
Return018021:       6B            RTL                       ; Return 

UpdateXPosNoGrvty:  8B            PHB                       
CODE_018023:        4B            PHK                       
CODE_018024:        AB            PLB                       
CODE_018025:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_018028:        AB            PLB                       
Return018029:       6B            RTL                       ; Return 

UpdateSpritePos:    8B            PHB                       
CODE_01802B:        4B            PHK                       
CODE_01802C:        AB            PLB                       
CODE_01802D:        20 32 90      JSR.W SubUpdateSprPos     
CODE_018030:        AB            PLB                       
Return018031:       6B            RTL                       ; Return 

SprSprInteract:     8B            PHB                       
CODE_018033:        4B            PHK                       
CODE_018034:        AB            PLB                       
CODE_018035:        20 0D A4      JSR.W SubSprSprInteract   
CODE_018038:        AB            PLB                       
Return018039:       6B            RTL                       ; Return 

SprSpr+MarioSprRts: 8B            PHB                       
CODE_01803B:        4B            PHK                       
CODE_01803C:        AB            PLB                       
CODE_01803D:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  
CODE_018040:        AB            PLB                       
Return018041:       6B            RTL                       ; Return 

GenericSprGfxRt0:   8B            PHB                       
CODE_018043:        4B            PHK                       
CODE_018044:        AB            PLB                       
CODE_018045:        20 F3 9C      JSR.W SubSprGfx0Entry0    
CODE_018048:        AB            PLB                       
Return018049:       6B            RTL                       ; Return 

InvertAccum:        49 FF         EOR.B #$FF                ; \ Set A to -A 
CODE_01804C:        1A            INC A                     ; /  
Return01804D:       60            RTS                       ; Return 

CODE_01804E:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if in air 
CODE_018051:        F0 1F         BEQ Return018072          ; / 
CODE_018053:        A5 13         LDA RAM_FrameCounter      
CODE_018055:        29 03         AND.B #$03                
CODE_018057:        05 86         ORA $86                   
CODE_018059:        D0 17         BNE Return018072          
CODE_01805B:        A9 04         LDA.B #$04                
CODE_01805D:        85 00         STA $00                   
CODE_01805F:        A9 0A         LDA.B #$0A                
CODE_018061:        85 01         STA $01                   
CODE_018063:        20 CB 80      JSR.W IsSprOffScreen      
CODE_018066:        D0 0A         BNE Return018072          
CODE_018068:        A0 03         LDY.B #$03                
CODE_01806A:        B9 C0 17      LDA.W $17C0,Y             
CODE_01806D:        F0 04         BEQ CODE_018073           
CODE_01806F:        88            DEY                       
CODE_018070:        10 F8         BPL CODE_01806A           
Return018072:       60            RTS                       ; Return 

CODE_018073:        A9 03         LDA.B #$03                
CODE_018075:        99 C0 17      STA.W $17C0,Y             
CODE_018078:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01807A:        65 00         ADC $00                   
CODE_01807C:        99 C8 17      STA.W $17C8,Y             
CODE_01807F:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_018081:        65 01         ADC $01                   
CODE_018083:        99 C4 17      STA.W $17C4,Y             
CODE_018086:        A9 13         LDA.B #$13                
CODE_018088:        99 CC 17      STA.W $17CC,Y             
Return01808B:       60            RTS                       ; Return 

CODE_01808C:        8B            PHB                       
CODE_01808D:        4B            PHK                       
CODE_01808E:        AB            PLB                       
CODE_01808F:        AD 8F 14      LDA.W $148F               
CODE_018092:        8D 70 14      STA.W $1470               ; Reset carrying enemy flag 
CODE_018095:        9C 8F 14      STZ.W $148F               
CODE_018098:        9C 71 14      STZ.W $1471               
CODE_01809B:        9C C2 18      STZ.W $18C2               
CODE_01809E:        AD DF 18      LDA.W $18DF               
CODE_0180A1:        8D E2 18      STA.W $18E2               
CODE_0180A4:        9C DF 18      STZ.W $18DF               
CODE_0180A7:        A2 0B         LDX.B #$0B                
CODE_0180A9:        8E E9 15      STX.W $15E9               
CODE_0180AC:        20 D2 80      JSR.W CODE_0180D2         
CODE_0180AF:        20 27 81      JSR.W HandleSprite        
CODE_0180B2:        CA            DEX                       
CODE_0180B3:        10 F4         BPL CODE_0180A9           
CODE_0180B5:        AD B8 18      LDA.W $18B8               
CODE_0180B8:        F0 04         BEQ CODE_0180BE           
CODE_0180BA:        22 08 F8 02   JSL.L CODE_02F808         
CODE_0180BE:        AD DF 18      LDA.W $18DF               
CODE_0180C1:        D0 06         BNE CODE_0180C9           
CODE_0180C3:        9C 7A 18      STZ.W RAM_OnYoshi         
CODE_0180C6:        9C 8B 18      STZ.W $188B               
CODE_0180C9:        AB            PLB                       
Return0180CA:       6B            RTL                       ; Return 

IsSprOffScreen:     BD A0 15      LDA.W RAM_OffscreenHorz,X ; \ A = Current sprite is offscreen 
CODE_0180CE:        1D 6C 18      ORA.W RAM_OffscreenVert,X ; /  
Return0180D1:       60            RTS                       ; Return 

CODE_0180D2:        DA            PHX                       ; In all sprite routines, X = current sprite 
CODE_0180D3:        8A            TXA                       
CODE_0180D4:        AE 92 16      LDX.W $1692               ; $1692 = Current Sprite memory settings 
CODE_0180D7:        18            CLC                       ; \  
CODE_0180D8:        7F B4 F0 07   ADC.L DATA_07F0B4,X       ;  |Add $07:F0B4,$1692 to sprite index.  i.e. minimum one tile allotted to each sprite 
CODE_0180DC:        AA            TAX                       ;  |the bytes read go straight to the OAM indexes 
CODE_0180DD:        BF 00 F0 07   LDA.L DATA_07F000,X       ;  | 
CODE_0180E1:        FA            PLX                       ; /  
CODE_0180E2:        9D EA 15      STA.W RAM_SprOAMIndex,X   ; Current sprite's OAM index 
CODE_0180E5:        BD C8 14      LDA.W $14C8,X             ; If  (something related to current sprite) is 0 
CODE_0180E8:        F0 3C         BEQ Return018126          ; do not decrement these counters 
CODE_0180EA:        A5 9D         LDA RAM_SpritesLocked     ; Lock sprites timer 
CODE_0180EC:        D0 38         BNE Return018126          ; if sprites locked, do not decrement counters 
CODE_0180EE:        BD 40 15      LDA.W $1540,X             ; \ Decrement a bunch of sprite counter tables 
CODE_0180F1:        F0 03         BEQ CODE_0180F6           ;  | 
CODE_0180F3:        DE 40 15      DEC.W $1540,X             ;  |Do not decrement any individual counter if it's already at zero 
CODE_0180F6:        BD 4C 15      LDA.W RAM_DisableInter,X  ;  | 
CODE_0180F9:        F0 03         BEQ CODE_0180FE           ;  | 
CODE_0180FB:        DE 4C 15      DEC.W RAM_DisableInter,X  ;  | 
CODE_0180FE:        BD 58 15      LDA.W $1558,X             ;  | 
CODE_018101:        F0 03         BEQ CODE_018106           ;  | 
CODE_018103:        DE 58 15      DEC.W $1558,X             ;  | 
CODE_018106:        BD 64 15      LDA.W $1564,X             ;  | 
CODE_018109:        F0 03         BEQ CODE_01810E           ;  | 
CODE_01810B:        DE 64 15      DEC.W $1564,X             ;  | 
CODE_01810E:        BD E2 1F      LDA.W $1FE2,X             ;  | 
CODE_018111:        F0 03         BEQ CODE_018116           ;  | 
CODE_018113:        DE E2 1F      DEC.W $1FE2,X             ;  | 
CODE_018116:        BD AC 15      LDA.W $15AC,X             ;  | 
CODE_018119:        F0 03         BEQ CODE_01811E           ;  | 
CODE_01811B:        DE AC 15      DEC.W $15AC,X             ;  | 
CODE_01811E:        BD 3E 16      LDA.W $163E,X             ;  | 
CODE_018121:        F0 03         BEQ Return018126          ;  | 
CODE_018123:        DE 3E 16      DEC.W $163E,X             ;  | 
Return018126:       60            RTS                       ; / Return 

HandleSprite:       BD C8 14      LDA.W $14C8,X             ; Call a routine based on the sprite's status 
CODE_01812A:        F0 25         BEQ EraseSprite           ; Routine for status 0 hardcoded, maybe for performance 
CODE_01812C:        C9 08         CMP.B #$08                
CODE_01812E:        D0 03         BNE CODE_018133           ; Routine for status 8 hardcoded, maybe for preformance 
CODE_018130:        4C C3 85      JMP.W CallSpriteMain      

CODE_018133:        22 DF 86 00   JSL.L ExecutePtr          

SpriteStatusRtPtr:     51 81      .dw EraseSprite           ; 0 - Non-existant (Bypassed above) 
                       72 81      .dw CallSpriteInit        ; 1 - Initialization 
                       A2 9A      .dw HandleSprKilled       ; 2 - Falling off screen (hit by star, shell, etc) 
                       E4 9A      .dw HandleSprSmushed      ; 3 - Smushed 
                       52 9A      .dw HandleSprSpinJump     ; 4 - Spin Jumped 
                       7B 9A      .dw CODE_019A7B           ; 5 
                       6D 81      .dw HandleSprLvlEnd       ; 6 - End of level turn to coin 
                       56 81      .dw Return018156          ; 7 - Unused 
                       C2 85      .dw Return0185C2          ; 8 - Normal (Bypassed above) 
                       3C 95      .dw HandleSprStunned      ; 9 - Stationary (Carryable, flipped, stunned) 
                       13 99      .dw HandleSprKicked       ; A - Kicked 
                       71 9F      .dw HandleSprCarried      ; B - Carried 
                       57 81      .dw HandleGoalPowerup     ; C - Power up from carrying a sprite past the goal tape 

EraseSprite:        A9 FF         LDA.B #$FF                ; \ Permanently erase sprite: 
CODE_018153:        9D 1A 16      STA.W RAM_SprIndexInLvl,X ;  | By changing the sprite's index into the level tables 
Return018156:       60            RTS                       ; / the actual sprite won't get marked for reloading 

HandleGoalPowerup:  20 C3 85      JSR.W CallSpriteMain      
CODE_01815A:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01815D:        20 32 90      JSR.W SubUpdateSprPos     
CODE_018160:        D6 AA         DEC RAM_SpriteSpeedY,X    
CODE_018162:        D6 AA         DEC RAM_SpriteSpeedY,X    
CODE_018164:        20 0E 80      JSR.W IsOnGround          
CODE_018167:        F0 03         BEQ Return01816C          
ADDR_018169:        20 04 9A      JSR.W SetSomeYSpeed??     
Return01816C:       60            RTS                       ; Return 

HandleSprLvlEnd:    22 AC FB 00   JSL.L LvlEndSprCoins      
Return018171:       60            RTS                       ; Return 

CallSpriteInit:     A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_018174:        9D C8 14      STA.W $14C8,X             ; / 
CODE_018177:        B5 9E         LDA RAM_SpriteNum,X       
CODE_018179:        22 DF 86 00   JSL.L ExecutePtr          

SpriteInitPtr:         75 85      .dw InitStandardSprite    ; 00 - Green Koopa, no shell 
                       75 85      .dw InitStandardSprite    ; 01 - Red Koopa, no shell 
                       75 85      .dw InitStandardSprite    ; 02 - Blue Koopa, no shell 
                       75 85      .dw InitStandardSprite    ; 03 - Yellow Koopa, no shell 
                       75 85      .dw InitStandardSprite    ; 04 - Green Koopa 
                       75 85      .dw InitStandardSprite    ; 05 - Red Koopa 
                       75 85      .dw InitStandardSprite    ; 06 - Blue Koopa 
                       75 85      .dw InitStandardSprite    ; 07 - Yellow Koopa 
                       75 85      .dw InitStandardSprite    ; 08 - Green Koopa, flying left 
                       6E 85      .dw InitGrnBounceKoopa    ; 09 - Green bouncing Koopa 
                       75 85      .dw InitStandardSprite    ; 0A - Red vertical flying Koopa 
                       75 85      .dw InitStandardSprite    ; 0B - Red horizontal flying Koopa 
                       75 85      .dw InitStandardSprite    ; 0C - Yellow Koopa with wings 
                       5D 85      .dw InitBomb              ; 0D - Bob-omb 
                       B8 E1      .dw InitKeyHole           ; 0E - Keyhole 
                       75 85      .dw InitStandardSprite    ; 0F - Goomba 
                       75 85      .dw InitStandardSprite    ; 10 - Bouncing Goomba with wings 
                       75 85      .dw InitStandardSprite    ; 11 - Buzzy Beetle 
                       75 F8      .dw UnusedInit            ; 12 - Unused 
                       75 85      .dw InitStandardSprite    ; 13 - Spiny 
                       75 85      .dw InitStandardSprite    ; 14 - Spiny falling 
                       11 B0      .dw Return01B011          ; 15 - Fish, horizontal 
                       0B B0      .dw InitVerticalFish      ; 16 - Fish, vertical 
                       14 B0      .dw InitFish              ; 17 - Fish, created from generator 
                       14 B0      .dw InitFish              ; 18 - Surface jumping fish 
                       DA 83      .dw InitMsg+SideExit      ; 19 - Display text from level Message Box #1 
                       B0 85      .dw InitPiranha           ; 1A - Classic Piranha Plant 
                       C2 85      .dw Return0185C2          ; 1B - Bouncing football in place 
                       DD 84      .dw InitBulletBill        ; 1C - Bullet Bill 
                       75 85      .dw InitStandardSprite    ; 1D - Hopping flame 
                       6B 84      .dw InitLakitu            ; 1E - Lakitu 
                       B8 BD      .dw InitMagikoopa         ; 1F - Magikoopa 
                       83 85      .dw Return018583          ; 20 - Magikoopa's magic 
                       7C 85      .dw FaceMario             ; 21 - Moving coin 
                       48 B9      .dw InitVertNetKoopa      ; 22 - Green vertical net Koopa 
                       48 B9      .dw InitVertNetKoopa      ; 23 - Red vertical net Koopa 
                       3E B9      .dw InitHorzNetKoopa      ; 24 - Green horizontal net Koopa 
                       3E B9      .dw InitHorzNetKoopa      ; 25 - Red horizontal net Koopa 
                       96 AE      .dw InitThwomp            ; 26 - Thwomp 
                       A2 AE      .dw Return01AEA2          ; 27 - Thwimp 
                       84 F8      .dw InitBigBoo            ; 28 - Big Boo 
                       2F CD      .dw InitKoopaKid          ; 29 - Koopa Kid 
                       9A 85      .dw InitDownPiranha       ; 2A - Upside down Piranha Plant 
                       C2 85      .dw Return0185C2          ; 2B - Sumo Brother's fire lightning 
                       39 83      .dw InitYoshiEgg          ; 2C - Yoshi egg 
                       35 84      .dw InitKey+BabyYoshi     ; 2D - Baby green Yoshi 
                       F2 83      .dw InitSpikeTop          ; 2E - Spike Top 
                       C2 85      .dw Return0185C2          ; 2F - Portable spring board 
                       7C 85      .dw FaceMario             ; 30 - Dry Bones, throws bones 
                       7C 85      .dw FaceMario             ; 31 - Bony Beetle 
                       7C 85      .dw FaceMario             ; 32 - Dry Bones, stay on ledge 
                       50 E0      .dw InitFireball          ; 33 - Fireball 
                       C2 85      .dw Return0185C2          ; 34 - Boss fireball 
                       E0 83      .dw InitYoshi             ; 35 - Green Yoshi 
                       C2 85      .dw Return0185C2          ; 36 - Unused 
                       84 F8      .dw InitBigBoo            ; 37 - Boo 
                       7C F8      .dw InitEerie             ; 38 - Eerie 
                       7C F8      .dw InitEerie             ; 39 - Eerie, wave motion 
                       1B 84      .dw InitUrchin            ; 3A - Urchin, fixed 
                       1B 84      .dw InitUrchin            ; 3B - Urchin, wall detect 
                       04 84      .dw InitUrchinWallFllw    ; 3C - Urchin, wall follow 
                       31 84      .dw InitRipVanFish        ; 3D - Rip Van Fish 
                       4E 84      .dw InitPSwitch           ; 3E - POW 
                       C2 85      .dw Return0185C2          ; 3F - Para-Goomba 
                       C2 85      .dw Return0185C2          ; 40 - Para-Bomb 
                       3D 84      .dw Return01843D          ; 41 - Dolphin, horizontal 
                       3D 84      .dw Return01843D          ; 42 - Dolphin2, horizontal 
                       3D 84      .dw Return01843D          ; 43 - Dolphin, vertical 
                       3D 84      .dw Return01843D          ; 44 - Torpedo Ted 
                       C2 85      .dw Return0185C2          ; 45 - Directional coins 
                       08 85      .dw InitDigginChuck       ; 46 - Diggin' Chuck 
                       EE 83      .dw Return0183EE          ; 47 - Swimming/Jumping fish 
                       EE 83      .dw Return0183EE          ; 48 - Diggin' Chuck's rock 
                       81 83      .dw InitGrowingPipe       ; 49 - Growing/shrinking pipe end 
                       EE 83      .dw Return0183EE          ; 4A - Goal Point Question Sphere 
                       B0 85      .dw InitPiranha           ; 4B - Pipe dwelling Lakitu 
                       A4 83      .dw InitExplodingBlk      ; 4C - Exploding Block 
                       CE 84      .dw InitMontyMole         ; 4D - Ground dwelling Monty Mole 
                       CE 84      .dw InitMontyMole         ; 4E - Ledge dwelling Monty Mole 
                       B0 85      .dw InitPiranha           ; 4F - Jumping Piranha Plant 
                       B0 85      .dw InitPiranha           ; 50 - Jumping Piranha Plant, spit fire 
                       7C 85      .dw FaceMario             ; 51 - Ninji 
                       90 88      .dw InitMovingLedge       ; 52 - Moving ledge hole in ghost house 
                       C2 85      .dw Return0185C2          ; 53 - Throw block sprite 
                       87 BA      .dw InitClimbingDoor      ; 54 - Climbing net door 
                       5E B2      .dw InitChckbrdPlat       ; 55 - Checkerboard platform, horizontal 
                       5D B2      .dw Return01B25D          ; 56 - Flying rock platform, horizontal 
                       5E B2      .dw InitChckbrdPlat       ; 57 - Checkerboard platform, vertical 
                       5D B2      .dw Return01B25D          ; 58 - Flying rock platform, vertical 
                       67 B2      .dw Return01B267          ; 59 - Turn block bridge, horizontal and vertical 
                       67 B2      .dw Return01B267          ; 5A - Turn block bridge, horizontal 
                       36 B2      .dw InitFloatingPlat      ; 5B - Brown platform floating in water 
                       2B B2      .dw InitFallingPlat       ; 5C - Checkerboard platform that falls 
                       36 B2      .dw InitFloatingPlat      ; 5D - Orange platform floating in water 
                       2E B2      .dw InitOrangePlat        ; 5E - Orange platform, goes on forever 
                       4A C7      .dw InitBrwnChainPlat     ; 5F - Brown platform on a chain 
                       90 AE      .dw Return01AE90          ; 60 - Flat green switch palace switch 
                       D9 87      .dw InitFloatingSkull     ; 61 - Floating skulls 
                       11 D7      .dw InitLineBrwnPlat      ; 62 - Brown platform, line-guided 
                       D2 D6      .dw InitLinePlat          ; 63 - Checker/brown platform, line-guided 
                       C4 D6      .dw InitLineRope          ; 64 - Rope mechanism, line-guided 
                       ED D6      .dw InitLineGuidedSpr     ; 65 - Chainsaw, line-guided 
                       ED D6      .dw InitLineGuidedSpr     ; 66 - Upside down chainsaw, line-guided 
                       ED D6      .dw InitLineGuidedSpr     ; 67 - Grinder, line-guided 
                       ED D6      .dw InitLineGuidedSpr     ; 68 - Fuzz ball, line-guided 
                       C3 D6      .dw Return01D6C3          ; 69 - Unused 
                       C2 85      .dw Return0185C2          ; 6A - Coin game cloud 
                       3D 84      .dw Return01843D          ; 6B - Spring board, left wall 
                       3E 84      .dw InitPeaBouncer        ; 6C - Spring board, right wall 
                       C2 85      .dw Return0185C2          ; 6D - Invisible solid block 
                       58 85      .dw InitDinos             ; 6E - Dino Rhino 
                       58 85      .dw InitDinos             ; 6F - Dino Torch 
                       4B 85      .dw InitPokey             ; 70 - Pokey 
                       28 85      .dw InitSuperKoopa        ; 71 - Super Koopa, red cape 
                       28 85      .dw InitSuperKoopa        ; 72 - Super Koopa, yellow cape 
                       2E 85      .dw InitSuperKoopaFthr    ; 73 - Super Koopa, feather 
                       8B 85      .dw InitPowerUp           ; 74 - Mushroom 
                       8B 85      .dw InitPowerUp           ; 75 - Flower 
                       8B 85      .dw InitPowerUp           ; 76 - Star 
                       8B 85      .dw InitPowerUp           ; 77 - Feather 
                       8B 85      .dw InitPowerUp           ; 78 - 1-Up 
                       83 85      .dw Return018583          ; 79 - Growing Vine 
                       83 85      .dw Return018583          ; 7A - Firework 
                       75 C0      .dw InitGoalTape          ; 7B - Goal Point 
                       C2 85      .dw Return0185C2          ; 7C - Princess Peach 
                       C2 85      .dw Return0185C2          ; 7D - Balloon 
                       C2 85      .dw Return0185C2          ; 7E - Flying Red coin 
                       C2 85      .dw Return0185C2          ; 7F - Flying yellow 1-Up 
                       35 84      .dw InitKey+BabyYoshi     ; 80 - Key 
                       3B 84      .dw InitChangingItem      ; 81 - Changing item from translucent block 
                       AC DD      .dw InitBonusGame         ; 82 - Bonus game sprite 
                       59 AD      .dw InitFlying?Block      ; 83 - Left flying question block 
                       59 AD      .dw InitFlying?Block      ; 84 - Flying question block 
                       C2 85      .dw Return0185C2          ; 85 - Unused (Pretty sure) 
                       29 88      .dw InitWiggler           ; 86 - Wiggler 
                       C2 85      .dw Return0185C2          ; 87 - Lakitu's cloud 
                       6F 88      .dw InitWingedCage        ; 88 - Unused (Winged cage sprite) 
                       3D 84      .dw Return01843D          ; 89 - Layer 3 smash 
                       C2 85      .dw Return0185C2          ; 8A - Bird from Yoshi's house 
                       C2 85      .dw Return0185C2          ; 8B - Puff of smoke from Yoshi's house 
                       DA 83      .dw InitMsg+SideExit      ; 8C - Fireplace smoke/exit from side screen 
                       C2 85      .dw Return0185C2          ; 8D - Ghost house exit sign and door 
                       C2 85      .dw Return0185C2          ; 8E - Invisible "Warp Hole" blocks 
                       B5 83      .dw InitScalePlats        ; 8F - Scale platforms 
                       7C 85      .dw FaceMario             ; 90 - Large green gas bubble 
                       69 88      .dw Return018869          ; 91 - Chargin' Chuck 
                       04 85      .dw InitChuck             ; 92 - Splittin' Chuck 
                       04 85      .dw InitChuck             ; 93 - Bouncin' Chuck 
                       00 85      .dw InitWhistlinChuck     ; 94 - Whistlin' Chuck 
                       E9 84      .dw InitClappinChuck      ; 95 - Clapin' Chuck 
                       69 88      .dw Return018869          ; 96 - Unused (Chargin' Chuck clone) 
                       FC 84      .dw InitPuntinChuck       ; 97 - Puntin' Chuck 
                       ED 84      .dw InitPitchinChuck      ; 98 - Pitchin' Chuck 
                       EE 83      .dw Return0183EE          ; 99 - Volcano Lotus 
                       73 83      .dw InitSumoBrother       ; 9A - Sumo Brother 
                       A7 87      .dw InitHammerBrother     ; 9B - Hammer Brother 
                       C2 85      .dw Return0185C2          ; 9C - Flying blocks for Hammer Brother 
                       64 85      .dw InitBubbleSpr         ; 9D - Bubble with sprite 
                       96 83      .dw InitBallNChain        ; 9E - Ball and Chain 
                       87 83      .dw InitBanzai            ; 9F - Banzai Bill 
                       6E 83      .dw InitBowserScene       ; A0 - Activates Bowser scene 
                       C2 85      .dw Return0185C2          ; A1 - Bowser's bowling ball 
                       C2 85      .dw Return0185C2          ; A2 - MechaKoopa 
                       9A 83      .dw InitGreyChainPlat     ; A3 - Grey platform on chain 
                       16 B2      .dw InitFloatSpkBall      ; A4 - Floating Spike ball 
                       0B 84      .dw InitFuzzBall+Spark    ; A5 - Fuzzball/Sparky, ground-guided 
                       0B 84      .dw InitFuzzBall+Spark    ; A6 - HotHead, ground-guided 
                       C2 85      .dw Return0185C2          ; A7 - Iggy's ball 
                       C2 85      .dw Return0185C2          ; A8 - Blargg 
                       89 87      .dw InitReznor            ; A9 - Reznor 
                       8E 85      .dw InitFishbone          ; AA - Fishbone 
                       7C 85      .dw FaceMario             ; AB - Rex 
                       5B 83      .dw InitWoodSpike         ; AC - Wooden Spike, moving down and up 
                       6B 83      .dw InitWoodSpike2        ; AD - Wooden Spike, moving up/down first 
                       C2 85      .dw Return0185C2          ; AE - Fishin' Boo 
                       C2 85      .dw Return0185C2          ; AF - Boo Block 
                       4E 83      .dw InitDiagBouncer       ; B0 - Reflecting stream of Boo Buddies 
                       D6 84      .dw InitCreateEatBlk      ; B1 - Creating/Eating block 
                       C2 85      .dw Return0185C2          ; B2 - Falling Spike 
                       84 85      .dw InitBowsersFire       ; B3 - Bowser statue fireball 
                       7C 85      .dw FaceMario             ; B4 - Grinder, non-line-guided 
                       C2 85      .dw Return0185C2          ; B5 - Sinking fireball used in boss battles 
                       4E 83      .dw InitDiagBouncer       ; B6 - Reflecting fireball 
                       C2 85      .dw Return0185C2          ; B7 - Carrot Top lift, upper right 
                       C2 85      .dw Return0185C2          ; B8 - Carrot Top lift, upper left 
                       C2 85      .dw Return0185C2          ; B9 - Info Box 
                       26 83      .dw InitTimedPlat         ; BA - Timed lift 
                       C2 85      .dw Return0185C2          ; BB - Grey moving castle block 
                       14 83      .dw InitBowserStatue      ; BC - Bowser statue 
                       7D 83      .dw InitSlidingKoopa      ; BD - Sliding Koopa without a shell 
                       C2 85      .dw Return0185C2          ; BE - Swooper bat 
                       7C 85      .dw FaceMario             ; BF - Mega Mole 
                       0F 83      .dw InitGreyLavaPlat      ; C0 - Grey platform on lava 
                       CE 84      .dw InitMontyMole         ; C1 - Flying grey turnblocks 
                       7C 85      .dw FaceMario             ; C2 - Blurp fish 
                       7C 85      .dw FaceMario             ; C3 - Porcu-Puffer fish 
                       C2 85      .dw Return0185C2          ; C4 - Grey platform that falls 
                       7C 85      .dw FaceMario             ; C5 - Big Boo Boss 
                       13 83      .dw Return018313          ; C6 - Dark room with spot light 
                       C2 85      .dw Return0185C2          ; C7 - Invisible mushroom 
                       C2 85      .dw Return0185C2          ; C8 - Light switch block for dark room 

InitGreyLavaPlat:   F6 D8         INC RAM_SpriteYLo,X       
CODE_018311:        F6 D8         INC RAM_SpriteYLo,X       
Return018313:       60            RTS                       

InitBowserStatue:   FE 7C 15      INC.W RAM_SpriteDir,X     
CODE_018317:        20 A4 83      JSR.W InitExplodingBlk    
CODE_01831A:        94 C2         STY RAM_SpriteState,X     
CODE_01831C:        C0 02         CPY.B #$02                
CODE_01831E:        D0 05         BNE Return018325          
CODE_018320:        A9 01         LDA.B #$01                
CODE_018322:        9D F6 15      STA.W RAM_SpritePal,X     
Return018325:       60            RTS                       ; Return 

InitTimedPlat:      A0 3F         LDY.B #$3F                
CODE_018328:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01832A:        29 10         AND.B #$10                
CODE_01832C:        D0 02         BNE CODE_018330           
CODE_01832E:        A0 FF         LDY.B #$FF                
CODE_018330:        98            TYA                       
CODE_018331:        9D 70 15      STA.W $1570,X             
Return018334:       60            RTS                       ; Return 


YoshiPal:                         .db $09,$07,$05,$07

InitYoshiEgg:       B5 E4         LDA RAM_SpriteXLo,X       
CODE_01833B:        4A            LSR                       
CODE_01833C:        4A            LSR                       
CODE_01833D:        4A            LSR                       
CODE_01833E:        4A            LSR                       
CODE_01833F:        29 03         AND.B #$03                
CODE_018341:        A8            TAY                       
CODE_018342:        B9 35 83      LDA.W YoshiPal,Y          
CODE_018345:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_018348:        FE 7B 18      INC.W $187B,X             
Return01834B:       60            RTS                       ; Return 


DATA_01834C:                      .db $10,$F0

InitDiagBouncer:    20 7C 85      JSR.W FaceMario           
CODE_018351:        B9 4C 83      LDA.W DATA_01834C,Y       
CODE_018354:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_018356:        A9 F0         LDA.B #$F0                
CODE_018358:        95 AA         STA RAM_SpriteSpeedY,X    
Return01835A:       60            RTS                       ; Return 

InitWoodSpike:      B5 D8         LDA RAM_SpriteYLo,X       
CODE_01835D:        38            SEC                       
CODE_01835E:        E9 40         SBC.B #$40                
CODE_018360:        95 D8         STA RAM_SpriteYLo,X       
CODE_018362:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_018365:        E9 00         SBC.B #$00                
CODE_018367:        9D D4 14      STA.W RAM_SpriteYHi,X     
Return01836A:       60            RTS                       ; Return 

InitWoodSpike2:     4C CE 84      JMP.W InitMontyMole       

InitBowserScene:    22 F1 A0 03   JSL.L CODE_03A0F1         
Return018372:       60            RTS                       ; Return 

InitSumoBrother:    A9 03         LDA.B #$03                
CODE_018375:        95 C2         STA RAM_SpriteState,X     
CODE_018377:        A9 70         LDA.B #$70                
CODE_018379:        9D 40 15      STA.W $1540,X             
Return01837C:       60            RTS                       ; Return 

InitSlidingKoopa:   A9 04         LDA.B #$04                
CODE_01837F:        80 F8         BRA CODE_018379           

InitGrowingPipe:    A9 40         LDA.B #$40                
CODE_018383:        9D 34 15      STA.W $1534,X             
Return018386:       60            RTS                       ; Return 

InitBanzai:         20 30 AD      JSR.W SubHorizPos         
CODE_01838A:        98            TYA                       
CODE_01838B:        D0 03         BNE CODE_018390           
ADDR_01838D:        4C 80 AC      JMP.W OffScrEraseSprite   

CODE_018390:        A9 09         LDA.B #$09                
CODE_018392:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
Return018395:       60            RTS                       ; Return 

InitBallNChain:     A9 38         LDA.B #$38                
CODE_018398:        80 02         BRA CODE_01839C           

InitGreyChainPlat:  A9 30         LDA.B #$30                
CODE_01839C:        9D 7B 18      STA.W $187B,X             
Return01839F:       60            RTS                       ; Return 


ExplodingBlkSpr:                  .db $15,$0F,$00,$04

InitExplodingBlk:   B5 E4         LDA RAM_SpriteXLo,X       
CODE_0183A6:        4A            LSR                       
CODE_0183A7:        4A            LSR                       
CODE_0183A8:        4A            LSR                       
CODE_0183A9:        4A            LSR                       
CODE_0183AA:        29 03         AND.B #$03                
CODE_0183AC:        A8            TAY                       
CODE_0183AD:        B9 A0 83      LDA.W ExplodingBlkSpr,Y   
CODE_0183B0:        95 C2         STA RAM_SpriteState,X     
Return0183B2:       60            RTS                       ; Return 


DATA_0183B3:                      .db $80,$40

InitScalePlats:     B5 D8         LDA RAM_SpriteYLo,X       
CODE_0183B7:        9D 34 15      STA.W $1534,X             
CODE_0183BA:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_0183BD:        9D 1C 15      STA.W $151C,X             
CODE_0183C0:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_0183C2:        29 10         AND.B #$10                
CODE_0183C4:        4A            LSR                       
CODE_0183C5:        4A            LSR                       
CODE_0183C6:        4A            LSR                       
CODE_0183C7:        4A            LSR                       
CODE_0183C8:        A8            TAY                       
CODE_0183C9:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_0183CB:        18            CLC                       
CODE_0183CC:        79 B3 83      ADC.W DATA_0183B3,Y       
CODE_0183CF:        95 C2         STA RAM_SpriteState,X     
CODE_0183D1:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_0183D4:        69 00         ADC.B #$00                
CODE_0183D6:        9D 02 16      STA.W $1602,X             
Return0183D9:       60            RTS                       ; Return 

InitMsg+SideExit:   A9 28         LDA.B #$28                ; \ Set current sprite's "disable contact with other sprites" timer to x28 
CODE_0183DC:        9D 64 15      STA.W $1564,X             ; /  
Return0183DF:       60            RTS                       ; Return 

InitYoshi:          DE 0E 16      DEC.W $160E,X             
ADDR_0183E3:        FE 7C 15      INC.W RAM_SpriteDir,X     
ADDR_0183E6:        AD C1 0D      LDA.W RAM_OWHasYoshi      
ADDR_0183E9:        F0 03         BEQ Return0183EE          
ADDR_0183EB:        9E C8 14      STZ.W $14C8,X             
Return0183EE:       60            RTS                       


DATA_0183EF:                      .db $08

DATA_0183F0:                      .db $00,$08

InitSpikeTop:       20 30 AD      JSR.W SubHorizPos         
CODE_0183F5:        98            TYA                       
CODE_0183F6:        49 01         EOR.B #$01                
CODE_0183F8:        0A            ASL                       
CODE_0183F9:        0A            ASL                       
CODE_0183FA:        0A            ASL                       
CODE_0183FB:        0A            ASL                       
CODE_0183FC:        20 1D 84      JSR.W CODE_01841D         
CODE_0183FF:        9E 4A 16      STZ.W $164A,X             
CODE_018402:        80 0A         BRA CODE_01840E           

InitUrchinWallFllw: F6 D8         INC RAM_SpriteYLo,X       
CODE_018406:        D0 03         BNE InitFuzzBall+Spark    
ADDR_018408:        FE D4 14      INC.W RAM_SpriteYHi,X     
InitFuzzBall+Spark: 20 1B 84      JSR.W InitUrchin          
CODE_01840E:        BD 1C 15      LDA.W $151C,X             
CODE_018411:        49 10         EOR.B #$10                
CODE_018413:        9D 1C 15      STA.W $151C,X             
CODE_018416:        4A            LSR                       
CODE_018417:        4A            LSR                       
CODE_018418:        95 C2         STA RAM_SpriteState,X     
Return01841A:       60            RTS                       ; Return 

InitUrchin:         B5 E4         LDA RAM_SpriteXLo,X       
CODE_01841D:        A0 00         LDY.B #$00                
CODE_01841F:        29 10         AND.B #$10                
CODE_018421:        9D 1C 15      STA.W $151C,X             
CODE_018424:        D0 01         BNE CODE_018427           
CODE_018426:        C8            INY                       
CODE_018427:        B9 EF 83      LDA.W DATA_0183EF,Y       
CODE_01842A:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01842C:        B9 F0 83      LDA.W DATA_0183F0,Y       
CODE_01842F:        95 AA         STA RAM_SpriteSpeedY,X    
InitRipVanFish:     FE 4A 16      INC.W $164A,X             
Return018434:       60            RTS                       ; Return 

InitKey+BabyYoshi:  A9 09         LDA.B #$09                ; \ Sprite status = Carryable 
CODE_018437:        9D C8 14      STA.W $14C8,X             ; / 
Return01843A:       60            RTS                       ; Return 

InitChangingItem:   F6 C2         INC RAM_SpriteState,X     
Return01843D:       60            RTS                       

InitPeaBouncer:     B5 E4         LDA RAM_SpriteXLo,X       
CODE_018440:        38            SEC                       
CODE_018441:        E9 08         SBC.B #$08                
CODE_018443:        95 E4         STA RAM_SpriteXLo,X       
CODE_018445:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_018448:        E9 00         SBC.B #$00                
CODE_01844A:        9D E0 14      STA.W RAM_SpriteXHi,X     
Return01844D:       60            RTS                       ; Return 

InitPSwitch:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $151C,x = Blue/Silver, 
CODE_018450:        4A            LSR                       ;  | depending on initial X position 
CODE_018451:        4A            LSR                       ;  | 
CODE_018452:        4A            LSR                       ;  | 
CODE_018453:        4A            LSR                       ;  | 
CODE_018454:        29 01         AND.B #$01                ;  | 
CODE_018456:        9D 1C 15      STA.W $151C,X             ; / 
CODE_018459:        A8            TAY                       ; \ Store appropriate palette to RAM 
CODE_01845A:        B9 66 84      LDA.W PSwitchPal,Y        ;  | 
CODE_01845D:        9D F6 15      STA.W RAM_SpritePal,X     ; / 
CODE_018460:        A9 09         LDA.B #$09                ; \ Sprite status = Carryable 
CODE_018462:        9D C8 14      STA.W $14C8,X             ; / 
Return018465:       60            RTS                       ; Return 


PSwitchPal:                       .db $06,$02

ADDR_018468:        4C 80 AC      JMP.W OffScrEraseSprite   

InitLakitu:         A0 09         LDY.B #$09                
CODE_01846D:        CC E9 15      CPY.W $15E9               
CODE_018470:        F0 12         BEQ CODE_018484           
CODE_018472:        B9 C8 14      LDA.W $14C8,Y             
CODE_018475:        C9 08         CMP.B #$08                
CODE_018477:        D0 0B         BNE CODE_018484           
CODE_018479:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01847C:        C9 87         CMP.B #$87                
CODE_01847E:        F0 E8         BEQ ADDR_018468           
CODE_018480:        C9 1E         CMP.B #$1E                
CODE_018482:        F0 E4         BEQ ADDR_018468           
CODE_018484:        88            DEY                       
CODE_018485:        10 E6         BPL CODE_01846D           
CODE_018487:        9C C0 18      STZ.W RAM_TimeTillRespawn 
CODE_01848A:        9C BF 18      STZ.W $18BF               
CODE_01848D:        9C B9 18      STZ.W RAM_GeneratorNum    
CODE_018490:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_018492:        8D C3 18      STA.W $18C3               
CODE_018495:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_018498:        8D C4 18      STA.W $18C4               
CODE_01849B:        22 E4 A9 02   JSL.L FindFreeSprSlot     
CODE_01849F:        30 2D         BMI InitMontyMole         
CODE_0184A1:        8C E1 18      STY.W $18E1               
CODE_0184A4:        A9 87         LDA.B #$87                ; \ Sprite = Lakitu Cloud 
CODE_0184A6:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
CODE_0184A9:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_0184AB:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_0184AE:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_0184B0:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_0184B3:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_0184B6:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_0184B9:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_0184BB:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_0184BE:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_0184C1:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_0184C4:        DA            PHX                       
CODE_0184C5:        BB            TYX                       
CODE_0184C6:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_0184CA:        FA            PLX                       
CODE_0184CB:        9C E0 18      STZ.W $18E0               
InitMontyMole:      B5 E4         LDA RAM_SpriteXLo,X       
CODE_0184D0:        29 10         AND.B #$10                
CODE_0184D2:        9D 1C 15      STA.W $151C,X             
Return0184D5:       60            RTS                       ; Return 

InitCreateEatBlk:   A9 FF         LDA.B #$FF                
CODE_0184D8:        8D 09 19      STA.W $1909               
CODE_0184DB:        80 F1         BRA InitMontyMole         

InitBulletBill:     20 30 AD      JSR.W SubHorizPos         
CODE_0184E0:        98            TYA                       
CODE_0184E1:        95 C2         STA RAM_SpriteState,X     
CODE_0184E3:        A9 10         LDA.B #$10                
CODE_0184E5:        9D 40 15      STA.W $1540,X             
Return0184E8:       60            RTS                       ; Return 

InitClappinChuck:   A9 08         LDA.B #$08                
CODE_0184EB:        80 2D         BRA CODE_01851A           

InitPitchinChuck:   B5 E4         LDA RAM_SpriteXLo,X       
CODE_0184EF:        29 30         AND.B #$30                
CODE_0184F1:        4A            LSR                       
CODE_0184F2:        4A            LSR                       
CODE_0184F3:        4A            LSR                       
CODE_0184F4:        4A            LSR                       
CODE_0184F5:        9D 7B 18      STA.W $187B,X             
CODE_0184F8:        A9 0A         LDA.B #$0A                
CODE_0184FA:        80 1E         BRA CODE_01851A           

InitPuntinChuck:    A9 09         LDA.B #$09                
CODE_0184FE:        80 1A         BRA CODE_01851A           

InitWhistlinChuck:  A9 0B         LDA.B #$0B                
CODE_018502:        80 16         BRA CODE_01851A           

InitChuck:          A9 05         LDA.B #$05                
CODE_018506:        80 12         BRA CODE_01851A           

InitDigginChuck:    A9 30         LDA.B #$30                
CODE_01850A:        9D 40 15      STA.W $1540,X             
CODE_01850D:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01850F:        29 10         AND.B #$10                
CODE_018511:        4A            LSR                       
CODE_018512:        4A            LSR                       
CODE_018513:        4A            LSR                       
CODE_018514:        4A            LSR                       
CODE_018515:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_018518:        A9 04         LDA.B #$04                
CODE_01851A:        95 C2         STA RAM_SpriteState,X     
CODE_01851C:        20 7C 85      JSR.W FaceMario           
CODE_01851F:        B9 26 85      LDA.W DATA_018526,Y       
CODE_018522:        9D 1C 15      STA.W $151C,X             
Return018525:       60            RTS                       ; Return 


DATA_018526:                      .db $00,$04

InitSuperKoopa:     A9 28         LDA.B #$28                
CODE_01852A:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01852C:        80 4E         BRA FaceMario             

InitSuperKoopaFthr: 20 7C 85      JSR.W FaceMario           
CODE_018531:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_018533:        29 10         AND.B #$10                
CODE_018535:        F0 10         BEQ CODE_018547           
CODE_018537:        A9 10         LDA.B #$10                ; \ Can be jumped on 
CODE_018539:        9D 56 16      STA.W RAM_Tweaker1656,X   ; / 
CODE_01853C:        A9 80         LDA.B #$80                
CODE_01853E:        9D 62 16      STA.W RAM_Tweaker1662,X   
CODE_018541:        A9 10         LDA.B #$10                
CODE_018543:        9D 86 16      STA.W RAM_Tweaker1686,X   
Return018546:       60            RTS                       ; Return 

CODE_018547:        FE 34 15      INC.W $1534,X             
Return01854A:       60            RTS                       ; Return 

InitPokey:          A9 1F         LDA.B #$1F                ; \ If on Yoshi, $C2,x = #$1F 
CODE_01854D:        AC 7A 18      LDY.W RAM_OnYoshi         ;  | (5 segments, 1 bit each) 
CODE_018550:        D0 02         BNE CODE_018554           ;  | 
CODE_018552:        A9 07         LDA.B #$07                ;  | If not on Yoshi, $C2,x = #$07 
CODE_018554:        95 C2         STA RAM_SpriteState,X     ; /   (3 segments, 1 bit each) 
CODE_018556:        80 24         BRA FaceMario             

InitDinos:          A9 04         LDA.B #$04                
CODE_01855A:        9D 1C 15      STA.W $151C,X             
InitBomb:           A9 FF         LDA.B #$FF                
CODE_01855F:        9D 40 15      STA.W $1540,X             
CODE_018562:        80 18         BRA FaceMario             

InitBubbleSpr:      20 A4 83      JSR.W InitExplodingBlk    
CODE_018567:        94 C2         STY RAM_SpriteState,X     
CODE_018569:        DE 34 15      DEC.W $1534,X             
CODE_01856C:        80 0E         BRA FaceMario             

InitGrnBounceKoopa: B5 D8         LDA RAM_SpriteYLo,X       
CODE_018570:        29 10         AND.B #$10                
CODE_018572:        9D 0E 16      STA.W $160E,X             
InitStandardSprite: 22 F9 AC 01   JSL.L GetRand             
CODE_018579:        9D 70 15      STA.W $1570,X             
FaceMario:          20 30 AD      JSR.W SubHorizPos         
CODE_01857F:        98            TYA                       
CODE_018580:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return018583:       60            RTS                       

InitBowsersFire:    A9 17         LDA.B #$17                
CODE_018586:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_018589:        80 F1         BRA FaceMario             

InitPowerUp:        F6 C2         INC RAM_SpriteState,X     
Return01858D:       60            RTS                       ; Return 

InitFishbone:       22 F9 AC 01   JSL.L GetRand             
CODE_018592:        29 1F         AND.B #$1F                
CODE_018594:        9D 40 15      STA.W $1540,X             
CODE_018597:        4C 7C 85      JMP.W FaceMario           

InitDownPiranha:    1E F6 15      ASL.W RAM_SpritePal,X     
CODE_01859D:        38            SEC                       
CODE_01859E:        7E F6 15      ROR.W RAM_SpritePal,X     
CODE_0185A1:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_0185A3:        38            SEC                       
CODE_0185A4:        E9 10         SBC.B #$10                
CODE_0185A6:        95 D8         STA RAM_SpriteYLo,X       
CODE_0185A8:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_0185AB:        E9 00         SBC.B #$00                
CODE_0185AD:        9D D4 14      STA.W RAM_SpriteYHi,X     
InitPiranha:        B5 E4         LDA RAM_SpriteXLo,X       ; \ Center sprite between two tiles 
CODE_0185B2:        18            CLC                       ;  | 
CODE_0185B3:        69 08         ADC.B #$08                ;  | 
CODE_0185B5:        95 E4         STA RAM_SpriteXLo,X       ; / 
CODE_0185B7:        D6 D8         DEC RAM_SpriteYLo,X       
CODE_0185B9:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_0185BB:        C9 FF         CMP.B #$FF                
CODE_0185BD:        D0 03         BNE Return0185C2          
CODE_0185BF:        DE D4 14      DEC.W RAM_SpriteYHi,X     
Return0185C2:       60            RTS                       

CallSpriteMain:     9C 91 14      STZ.W $1491               ; CallSpriteMain 
CODE_0185C6:        B5 9E         LDA RAM_SpriteNum,X       
CODE_0185C8:        22 DF 86 00   JSL.L ExecutePtr          

SpriteMainPtr:         04 89      .dw ShellessKoopas        ; 00 - Green Koopa, no shell 
                       04 89      .dw ShellessKoopas        ; 01 - Red Koopa, no shell 
                       04 89      .dw ShellessKoopas        ; 02 - Blue Koopa, no shell 
                       04 89      .dw ShellessKoopas        ; 03 - Yellow Koopa, no shell 
                       FC 8A      .dw Spr0to13Start         ; 04 - Green Koopa 
                       FC 8A      .dw Spr0to13Start         ; 05 - Red Koopa 
                       FC 8A      .dw Spr0to13Start         ; 06 - Blue Koopa 
                       FC 8A      .dw Spr0to13Start         ; 07 - Yellow Koopa 
                       4D 8C      .dw GreenParaKoopa        ; 08 - Green Koopa, flying left 
                       4D 8C      .dw GreenParaKoopa        ; 09 - Green bouncing Koopa 
                       C3 8C      .dw RedVertParaKoopa      ; 0A - Red vertical flying Koopa 
                       BE 8C      .dw RedHorzParaKoopa      ; 0B - Red horizontal flying Koopa 
                       FC 8A      .dw Spr0to13Start         ; 0C - Yellow Koopa with wings 
                       E5 8A      .dw Bobomb                ; 0D - Bob-omb 
                       C8 E1      .dw Keyhole               ; 0E - Keyhole 
                       FC 8A      .dw Spr0to13Start         ; 0F - Goomba 
                       2E 8D      .dw WingedGoomba          ; 10 - Bouncing Goomba with wings 
                       FC 8A      .dw Spr0to13Start         ; 11 - Buzzy Beetle 
                       7B F8      .dw Return01F87B          ; 12 - Unused 
                       FC 8A      .dw Spr0to13Start         ; 13 - Spiny 
                       18 8C      .dw SpinyEgg              ; 14 - Spiny falling 
                       33 B0      .dw Fish                  ; 15 - Fish, horizontal 
                       33 B0      .dw Fish                  ; 16 - Fish, vertical 
                       92 B1      .dw GeneratedFish         ; 17 - Fish, created from generator 
                       B4 B1      .dw JumpingFish           ; 18 - Surface jumping fish 
                       5B E7      .dw PSwitch               ; 19 - Display text from level Message Box #1 
                       76 8E      .dw ClassicPiranhas       ; 1A - Classic Piranha Plant 
                       8E 87      .dw Bank3SprHandler       ; 1B - Bouncing football in place 
                       E7 8F      .dw BulletBill            ; 1C - Bullet Bill 
                       0D 8F      .dw HoppingFlame          ; 1D - Hopping flame 
                       97 8F      .dw Lakitu                ; 1E - Lakitu 
                       D6 BD      .dw Magikoopa             ; 1F - Magikoopa 
                       38 BC      .dw MagikoopasMagic       ; 20 - Magikoopa's magic 
                       53 C3      .dw PowerUpRt             ; 21 - Moving coin 
                       7F B9      .dw ClimbingKoopa         ; 22 - Green vertical net Koopa 
                       7F B9      .dw ClimbingKoopa         ; 23 - Red vertical net Koopa 
                       7F B9      .dw ClimbingKoopa         ; 24 - Green horizontal net Koopa 
                       7F B9      .dw ClimbingKoopa         ; 25 - Red horizontal net Koopa 
                       A3 AE      .dw Thwomp                ; 26 - Thwomp 
                       9F AF      .dw Thwimp                ; 27 - Thwimp 
                       D5 F8      .dw BigBoo                ; 28 - Big Boo 
                       C1 FA      .dw KoopaKid              ; 29 - Koopa Kid 
                       76 8E      .dw ClassicPiranhas       ; 2A - Upside down Piranha Plant 
                       B6 87      .dw SumosLightning        ; 2B - Sumo Brother's fire lightning 
                       64 F7      .dw YoshiEgg              ; 2C - Yoshi egg 
                       C2 85      .dw Return0185C2          ; 2D - Baby green Yoshi 
                       5E 88      .dw WallFollowers         ; 2E - Spike Top 
                       23 E6      .dw SpringBoard           ; 2F - Portable spring board 
                       2B E4      .dw DryBonesAndBeetle     ; 30 - Dry Bones, throws bones 
                       2B E4      .dw DryBonesAndBeetle     ; 31 - Bony Beetle 
                       2B E4      .dw DryBonesAndBeetle     ; 32 - Dry Bones, stay on ledge 
                       93 E0      .dw Fireballs             ; 33 - Fireball 
                       4E D4      .dw BossFireball          ; 34 - Boss fireball 
                       CA EB      .dw Yoshi                 ; 35 - Green Yoshi 
                       1F E4      .dw DATA_01E41F           ; 36 - Unused 
                       DC F8      .dw Boo+BooBlock          ; 37 - Boo 
                       90 F8      .dw Eerie                 ; 38 - Eerie 
                       90 F8      .dw Eerie                 ; 39 - Eerie, wave motion 
                       5E 88      .dw WallFollowers         ; 3A - Urchin, fixed 
                       5E 88      .dw WallFollowers         ; 3B - Urchin, wall detect 
                       5E 88      .dw WallFollowers         ; 3C - Urchin, wall follow 
                       53 88      .dw RipVanFish            ; 3D - Rip Van Fish 
                       5B E7      .dw PSwitch               ; 3E - POW 
                       FB D4      .dw ParachuteSprites      ; 3F - Para-Goomba 
                       FB D4      .dw ParachuteSprites      ; 40 - Para-Bomb 
                       85 88      .dw Dolphin               ; 41 - Dolphin, horizontal 
                       85 88      .dw Dolphin               ; 42 - Dolphin2, horizontal 
                       85 88      .dw Dolphin               ; 43 - Dolphin, vertical 
                       38 88      .dw TorpedoTed            ; 44 - Torpedo Ted 
                       CA 87      .dw DirectionalCoins      ; 45 - Directional coins 
                       06 88      .dw DigginChuck           ; 46 - Diggin' Chuck 
                       0B 88      .dw SwimJumpFish          ; 47 - Swimming/Jumping fish 
                       10 88      .dw DigginChucksRock      ; 48 - Diggin' Chuck's rock 
                       15 88      .dw GrowingPipe           ; 49 - Growing/shrinking pipe end 
                       63 87      .dw GoalSphere            ; 4A - Goal Point Question Sphere 
                       01 88      .dw PipeLakitu            ; 4B - Pipe dwelling Lakitu 
                       CF 87      .dw ExplodingBlock        ; 4C - Exploding Block 
                       CF E2      .dw MontyMole             ; 4D - Ground dwelling Monty Mole 
                       CF E2      .dw MontyMole             ; 4E - Ledge dwelling Monty Mole 
                       BB 87      .dw JumpingPiranha        ; 4F - Jumping Piranha Plant 
                       BB 87      .dw JumpingPiranha        ; 50 - Jumping Piranha Plant, spit fire 
                       8E 87      .dw Bank3SprHandler       ; 51 - Ninji 
                       93 88      .dw MovingLedge           ; 52 - Moving ledge hole in ghost house 
                       C2 85      .dw Return0185C2          ; 53 - Throw block sprite 
                       CD BA      .dw ClimbingDoor          ; 54 - Climbing net door 
                       6C B2      .dw Platforms             ; 55 - Checkerboard platform, horizontal 
                       6C B2      .dw Platforms             ; 56 - Flying rock platform, horizontal 
                       6C B2      .dw Platforms             ; 57 - Checkerboard platform, vertical 
                       6C B2      .dw Platforms             ; 58 - Flying rock platform, vertical 
                       A5 B6      .dw TurnBlockBridge       ; 59 - Turn block bridge, horizontal and vertical 
                       DA B6      .dw HorzTurnBlkBridge     ; 5A - Turn block bridge, horizontal 
                       63 B5      .dw Platforms2            ; 5B - Brown platform floating in water 
                       63 B5      .dw Platforms2            ; 5C - Checkerboard platform that falls 
                       63 B5      .dw Platforms2            ; 5D - Orange platform floating in water 
                       36 B5      .dw OrangePlatform        ; 5E - Orange platform, goes on forever 
                       73 C7      .dw BrownChainedPlat      ; 5F - Brown platform on a chain 
                       91 AE      .dw PalaceSwitch          ; 60 - Flat green switch palace switch 
                       DE 87      .dw FloatingSkulls        ; 61 - Floating skulls 
                       4A D7      .dw LineFuzzy+Plats       ; 62 - Brown platform, line-guided 
                       4A D7      .dw LineFuzzy+Plats       ; 63 - Checker/brown platform, line-guided 
                       19 D7      .dw LineRope+Chainsaw     ; 64 - Rope mechanism, line-guided 
                       19 D7      .dw LineRope+Chainsaw     ; 65 - Chainsaw, line-guided 
                       19 D7      .dw LineRope+Chainsaw     ; 66 - Upside down chainsaw, line-guided 
                       3A D7      .dw LineGrinder           ; 67 - Grinder, line-guided 
                       4A D7      .dw LineFuzzy+Plats       ; 68 - Fuzz ball, line-guided 
                       C3 D6      .dw Return01D6C3          ; 69 - Unused 
                       33 88      .dw CoinCloud             ; 6A - Coin game cloud 
                       48 88      .dw PeaBouncer            ; 6B - Spring board, left wall 
                       48 88      .dw PeaBouncer            ; 6C - Spring board, right wall 
                       5E 87      .dw InvisSolid+Dinos      ; 6D - Invisible solid block 
                       5E 87      .dw InvisSolid+Dinos      ; 6E - Dino Rhino 
                       5E 87      .dw InvisSolid+Dinos      ; 6F - Dino Torch 
                       ED 87      .dw Pokey                 ; 70 - Pokey 
                       F2 87      .dw RedSuperKoopa         ; 71 - Super Koopa, red cape 
                       F7 87      .dw YellowSuperKoopa      ; 72 - Super Koopa, yellow cape 
                       FC 87      .dw FeatherSuperKoopa     ; 73 - Super Koopa, feather 
                       53 C3      .dw PowerUpRt             ; 74 - Mushroom 
                       49 C3      .dw FireFlower            ; 75 - Flower 
                       53 C3      .dw PowerUpRt             ; 76 - Star 
                       ED C6      .dw Feather               ; 77 - Feather 
                       53 C3      .dw PowerUpRt             ; 78 - 1-Up 
                       83 C1      .dw GrowingVine           ; 79 - Growing Vine 
                       8E 87      .dw Bank3SprHandler       ; 7A - Firework 
                       98 C0      .dw GoalTape              ; 7B - Goal Point 
                       8E 87      .dw Bank3SprHandler       ; 7C - Princess Peach 
                       F2 C1      .dw BalloonKeyFlyObjs     ; 7D - Balloon 
                       F2 C1      .dw BalloonKeyFlyObjs     ; 7E - Flying Red coin 
                       F2 C1      .dw BalloonKeyFlyObjs     ; 7F - Flying yellow 1-Up 
                       F2 C1      .dw BalloonKeyFlyObjs     ; 80 - Key 
                       17 C3      .dw ChangingItem          ; 81 - Changing item from translucent block 
                       2A DE      .dw BonusGame             ; 82 - Bonus game sprite 
                       6E AD      .dw Flying?Block          ; 83 - Left flying question block 
                       6E AD      .dw Flying?Block          ; 84 - Flying question block 
                       59 AD      .dw InitFlying?Block      ; 85 - Unused (Pretty sure) 
                       2E 88      .dw Wiggler               ; 86 - Wiggler 
                       A4 E7      .dw LakituCloud           ; 87 - Lakitu's cloud 
                       7A 88      .dw WingedCage            ; 88 - Unused (Winged cage sprite) 
                       3D 88      .dw Layer3Smash           ; 89 - Layer 3 smash 
                       1A 88      .dw YoshisHouseBirds      ; 8A - Bird from Yoshi's house 
                       1F 88      .dw YoshisHouseSmoke      ; 8B - Puff of smoke from Yoshi's house 
                       24 88      .dw SideExit              ; 8C - Fireplace smoke/exit from side screen 
                       E3 87      .dw GhostHouseExit        ; 8D - Ghost house exit sign and door 
                       E8 87      .dw WarpBlocks            ; 8E - Invisible "Warp Hole" blocks 
                       D4 87      .dw ScalePlatforms        ; 8F - Scale platforms 
                       C0 87      .dw GasBubble             ; 90 - Large green gas bubble 
                       6A 88      .dw Chucks                ; 91 - Chargin' Chuck 
                       6A 88      .dw Chucks                ; 92 - Splittin' Chuck 
                       6A 88      .dw Chucks                ; 93 - Bouncin' Chuck 
                       6A 88      .dw Chucks                ; 94 - Whistlin' Chuck 
                       6A 88      .dw Chucks                ; 95 - Clapin' Chuck 
                       6A 88      .dw Chucks                ; 96 - Unused (Chargin' Chuck clone) 
                       6A 88      .dw Chucks                ; 97 - Puntin' Chuck 
                       6A 88      .dw Chucks                ; 98 - Pitchin' Chuck 
                       AC 87      .dw VolcanoLotus          ; 99 - Volcano Lotus 
                       B1 87      .dw SumoBrother           ; 9A - Sumo Brother 
                       9D 87      .dw HammerBrother         ; 9B - Hammer Brother 
                       A2 87      .dw FlyingPlatform        ; 9C - Flying blocks for Hammer Brother 
                       98 87      .dw BubbleWithSprite      ; 9D - Bubble with sprite 
                       93 87      .dw BanzaiBnCGrayPlat     ; 9E - Ball and Chain 
                       93 87      .dw BanzaiBnCGrayPlat     ; 9F - Banzai Bill 
                       8E 87      .dw Bank3SprHandler       ; A0 - Activates Bowser scene 
                       8E 87      .dw Bank3SprHandler       ; A1 - Bowser's bowling ball 
                       8E 87      .dw Bank3SprHandler       ; A2 - MechaKoopa 
                       93 87      .dw BanzaiBnCGrayPlat     ; A3 - Grey platform on chain 
                       59 B5      .dw FloatingSpikeBall     ; A4 - Floating Spike ball 
                       5E 88      .dw WallFollowers         ; A5 - Fuzzball/Sparky, ground-guided 
                       5E 88      .dw WallFollowers         ; A6 - HotHead, ground-guided 
                       58 FA      .dw Iggy'sBall            ; A7 - Iggy's ball 
                       8E 87      .dw Bank3SprHandler       ; A8 - Blargg 
                       8E 87      .dw Bank3SprHandler       ; A9 - Reznor 
                       8E 87      .dw Bank3SprHandler       ; AA - Fishbone 
                       8E 87      .dw Bank3SprHandler       ; AB - Rex 
                       8E 87      .dw Bank3SprHandler       ; AC - Wooden Spike, moving down and up 
                       8E 87      .dw Bank3SprHandler       ; AD - Wooden Spike, moving up/down first 
                       8E 87      .dw Bank3SprHandler       ; AE - Fishin' Boo 
                       DC F8      .dw Boo+BooBlock          ; AF - Boo Block 
                       8E 87      .dw Bank3SprHandler       ; B0 - Reflecting stream of Boo Buddies 
                       8E 87      .dw Bank3SprHandler       ; B1 - Creating/Eating block 
                       8E 87      .dw Bank3SprHandler       ; B2 - Falling Spike 
                       8E 87      .dw Bank3SprHandler       ; B3 - Bowser statue fireball 
                       5C DB      .dw Grinder               ; B4 - Grinder, non-line-guided 
                       93 E0      .dw Fireballs             ; B5 - Sinking fireball used in boss battles 
                       8E 87      .dw Bank3SprHandler       ; B6 - Reflecting fireball 
                       8E 87      .dw Bank3SprHandler       ; B7 - Carrot Top lift, upper right 
                       8E 87      .dw Bank3SprHandler       ; B8 - Carrot Top lift, upper left 
                       8E 87      .dw Bank3SprHandler       ; B9 - Info Box 
                       8E 87      .dw Bank3SprHandler       ; BA - Timed lift 
                       8E 87      .dw Bank3SprHandler       ; BB - Grey moving castle block 
                       8E 87      .dw Bank3SprHandler       ; BC - Bowser statue 
                       8E 87      .dw Bank3SprHandler       ; BD - Sliding Koopa without a shell 
                       8E 87      .dw Bank3SprHandler       ; BE - Swooper bat 
                       8E 87      .dw Bank3SprHandler       ; BF - Mega Mole 
                       8E 87      .dw Bank3SprHandler       ; C0 - Grey platform on lava 
                       8E 87      .dw Bank3SprHandler       ; C1 - Flying grey turnblocks 
                       8E 87      .dw Bank3SprHandler       ; C2 - Blurp fish 
                       8E 87      .dw Bank3SprHandler       ; C3 - Porcu-Puffer fish 
                       8E 87      .dw Bank3SprHandler       ; C4 - Grey platform that falls 
                       8E 87      .dw Bank3SprHandler       ; C5 - Big Boo Boss 
                       8E 87      .dw Bank3SprHandler       ; C6 - Dark room with spot light 
                       8E 87      .dw Bank3SprHandler       ; C7 - Invisible mushroom 
                       8E 87      .dw Bank3SprHandler       ; C8 - Light switch block for dark room 

InvisSolid+Dinos:   22 34 9C 03   JSL.L InvisBlk+DinosMain  
Return018762:       60            RTS                       ; Return 

GoalSphere:         20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_018766:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_018768:        D0 1E         BNE Return018788          ; / 
CODE_01876A:        A5 13         LDA RAM_FrameCounter      
CODE_01876C:        29 1F         AND.B #$1F                
CODE_01876E:        05 9D         ORA RAM_SpritesLocked     
CODE_018770:        20 52 B1      JSR.W CODE_01B152         
CODE_018773:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_018776:        90 10         BCC Return018788          
CODE_018778:        9E C8 14      STZ.W $14C8,X             
CODE_01877B:        A9 FF         LDA.B #$FF                
CODE_01877D:        8D 93 14      STA.W $1493               
CODE_018780:        8D DA 0D      STA.W $0DDA               
CODE_018783:        A9 0B         LDA.B #$0B                
CODE_018785:        8D FB 1D      STA.W $1DFB               ; / Change music 
Return018788:       60            RTS                       ; Return 

InitReznor:         22 72 98 03   JSL.L ReznorInit          
Return01878D:       60            RTS                       ; Return 

Bank3SprHandler:    22 18 A1 03   JSL.L Bnk3CallSprMain     
Return018792:       60            RTS                       ; Return 

BanzaiBnCGrayPlat:  22 17 D6 02   JSL.L Banzai+Rotating     
Return018797:       60            RTS                       ; Return 

BubbleWithSprite:   22 AD D8 02   JSL.L BubbleSpriteMain    
Return01879C:       60            RTS                       ; Return 

HammerBrother:      22 52 DA 02   JSL.L HammerBrotherMain   
Return0187A1:       60            RTS                       ; Return 

FlyingPlatform:     22 4C DB 02   JSL.L FlyingPlatformMain  
Return0187A6:       60            RTS                       ; Return 

InitHammerBrother:  22 59 DA 02   JSL.L Return02DA59        ; Do nothing at all (Might as well be NOPs) 
Return0187AB:       60            RTS                       ; Return 

VolcanoLotus:       22 8B DF 02   JSL.L VolcanoLotusMain    
Return0187B0:       60            RTS                       ; Return 

SumoBrother:        22 AF DC 02   JSL.L SumoBrotherMain     
Return0187B5:       60            RTS                       ; Return 

SumosLightning:     22 A8 DE 02   JSL.L SumosLightningMain  
Return0187BA:       60            RTS                       ; Return 

JumpingPiranha:     22 C5 E0 02   JSL.L JumpingPiranhaMain  
Return0187BF:       60            RTS                       ; Return 

GasBubble:          22 03 E3 02   JSL.L GasBubbleMain       
Return0187C4:       60            RTS                       ; Return 

Unused0187C5:       22 AF DC 02   JSL.L SumoBrotherMain     ; Unused call to main Sumo Brother routine 
Return0187C9:       60            RTS                       ; Return 

DirectionalCoins:   22 15 E2 02   JSL.L DirectionCoinsMain  
Return0187CE:       60            RTS                       ; Return 

ExplodingBlock:     22 17 E4 02   JSL.L ExplodingBlkMain    
Return0187D3:       60            RTS                       ; Return 

ScalePlatforms:     22 95 E4 02   JSL.L ScalePlatformMain   
Return0187D8:       60            RTS                       ; Return 

InitFloatingSkull:  22 82 ED 02   JSL.L FloatingSkullInit   
Return0187DD:       60            RTS                       ; Return 

FloatingSkulls:     22 D0 ED 02   JSL.L FloatingSkullMain   
Return0187E2:       60            RTS                       ; Return 

GhostHouseExit:     22 94 F5 02   JSL.L GhostExitMain       
Return0187E7:       60            RTS                       ; Return 

WarpBlocks:         22 D2 EA 02   JSL.L WarpBlocksMain      
Return0187EC:       60            RTS                       ; Return 

Pokey:              22 36 B6 02   JSL.L PokeyMain           
Return0187F1:       60            RTS                       ; Return 

RedSuperKoopa:      22 27 EB 02   JSL.L SuperKoopaMain      
Return0187F6:       60            RTS                       ; Return 

YellowSuperKoopa:   22 27 EB 02   JSL.L SuperKoopaMain      
Return0187FB:       60            RTS                       ; Return 

FeatherSuperKoopa:  22 27 EB 02   JSL.L SuperKoopaMain      
Return018800:       60            RTS                       ; Return 

PipeLakitu:         22 35 E9 02   JSL.L PipeLakituMain      
Return018805:       60            RTS                       ; Return 

DigginChuck:        22 F5 C1 02   JSL.L ChucksMain          
Return01880A:       60            RTS                       ; Return 

SwimJumpFish:       22 1F E7 02   JSL.L SwimJumpFishMain    
Return01880F:       60            RTS                       ; Return 

DigginChucksRock:   22 B5 E7 02   JSL.L ChucksRockMain      
Return018814:       60            RTS                       ; Return 

GrowingPipe:        22 2D E8 02   JSL.L GrowingPipeMain     
Return018819:       60            RTS                       ; Return 

YoshisHouseBirds:   22 0F F3 02   JSL.L BirdsMain           
Return01881E:       60            RTS                       ; Return 

YoshisHouseSmoke:   22 2C F4 02   JSL.L SmokeMain           
Return018823:       60            RTS                       ; Return 

SideExit:           22 CD F4 02   JSL.L SideExitMain        
Return018828:       60            RTS                       ; Return 

InitWiggler:        22 F2 EF 02   JSL.L WigglerInit         
Return01882D:       60            RTS                       ; Return 

Wiggler:            22 29 F0 02   JSL.L WigglerMain         
Return018832:       60            RTS                       ; Return 

CoinCloud:          22 A9 EE 02   JSL.L CoinCloudMain       
Return018837:       60            RTS                       ; Return 

TorpedoTed:         22 82 B8 02   JSL.L TorpedoTedMain      
Return01883C:       60            RTS                       ; Return 

Layer3Smash:        8B            PHB                       
CODE_01883E:        A9 02         LDA.B #$02                
CODE_018840:        48            PHA                       
CODE_018841:        AB            PLB                       
CODE_018842:        22 EA D3 02   JSL.L Layer3SmashMain     
CODE_018846:        AB            PLB                       
Return018847:       60            RTS                       ; Return 

PeaBouncer:         8B            PHB                       
CODE_018849:        A9 02         LDA.B #$02                
CODE_01884B:        48            PHA                       
CODE_01884C:        AB            PLB                       
CODE_01884D:        22 CB CD 02   JSL.L PeaBouncerMain      
CODE_018851:        AB            PLB                       
Return018852:       60            RTS                       ; Return 

RipVanFish:         8B            PHB                       
CODE_018854:        A9 02         LDA.B #$02                
CODE_018856:        48            PHA                       
CODE_018857:        AB            PLB                       
CODE_018858:        22 CD BF 02   JSL.L RipVanFishMain      
CODE_01885C:        AB            PLB                       
Return01885D:       60            RTS                       ; Return 

WallFollowers:      8B            PHB                       
CODE_01885F:        A9 02         LDA.B #$02                
CODE_018861:        48            PHA                       
CODE_018862:        AB            PLB                       
CODE_018863:        22 DB BC 02   JSL.L WallFollowersMain   
CODE_018867:        AB            PLB                       
Return018868:       60            RTS                       ; Return 

Return018869:       60            RTS                       

Chucks:             22 F5 C1 02   JSL.L ChucksMain          
Return01886E:       60            RTS                       ; Return 

InitWingedCage:     8B            PHB                       ; \ Do nothing at all 
ADDR_018870:        A9 02         LDA.B #$02                ;  | (Might as well be NOPs) 
ADDR_018872:        48            PHA                       ;  | 
ADDR_018873:        AB            PLB                       ;  | 
ADDR_018874:        22 FD CB 02   JSL.L Return02CBFD        ;  | 
ADDR_018878:        AB            PLB                       ; / 
Return018879:       60            RTS                       ; Return 

WingedCage:         8B            PHB                       
ADDR_01887B:        A9 02         LDA.B #$02                
ADDR_01887D:        48            PHA                       
ADDR_01887E:        AB            PLB                       
ADDR_01887F:        22 FE CB 02   JSL.L WingedCageMain      
ADDR_018883:        AB            PLB                       
Return018884:       60            RTS                       ; Return 

Dolphin:            8B            PHB                       
CODE_018886:        A9 02         LDA.B #$02                
CODE_018888:        48            PHA                       
CODE_018889:        AB            PLB                       
CODE_01888A:        22 94 BB 02   JSL.L DolphinMain         
CODE_01888E:        AB            PLB                       
Return01888F:       60            RTS                       ; Return 

InitMovingLedge:    D6 D8         DEC RAM_SpriteYLo,X       
Return018892:       60            RTS                       ; Return 

MovingLedge:        22 B4 E5 02   JSL.L MovingLedgeMain     
Return018897:       60            RTS                       ; Return 

JumpOverShells:     8A            TXA                       ; \ Process every 4 frames 
CODE_018899:        45 13         EOR RAM_FrameCounter      ;  | 
CODE_01889B:        29 03         AND.B #$03                ;  | 
CODE_01889D:        D0 0C         BNE Return0188AB          ; / 
CODE_01889F:        A0 09         LDY.B #$09                ; \ Loop over sprites: 
JumpLoopStart:      B9 C8 14      LDA.W $14C8,Y             ;  | 
CODE_0188A4:        C9 0A         CMP.B #$0A                ;  | If sprite status = kicked, try to jump it 
CODE_0188A6:        F0 04         BEQ HandleJumpOver        ;  | 
JumpLoopNext:       88            DEY                       ;  | 
CODE_0188A9:        10 F6         BPL JumpLoopStart         ; / 
Return0188AB:       60            RTS                       ; Return 

HandleJumpOver:     B9 E4 00      LDA.W RAM_SpriteXLo,Y     
CODE_0188AF:        38            SEC                       
CODE_0188B0:        E9 1A         SBC.B #$1A                
CODE_0188B2:        85 00         STA $00                   
CODE_0188B4:        B9 E0 14      LDA.W RAM_SpriteXHi,Y     
CODE_0188B7:        E9 00         SBC.B #$00                
CODE_0188B9:        85 08         STA $08                   
CODE_0188BB:        A9 44         LDA.B #$44                
CODE_0188BD:        85 02         STA $02                   
CODE_0188BF:        B9 D8 00      LDA.W RAM_SpriteYLo,Y     
CODE_0188C2:        85 01         STA $01                   
CODE_0188C4:        B9 D4 14      LDA.W RAM_SpriteYHi,Y     
CODE_0188C7:        85 09         STA $09                   
CODE_0188C9:        A9 10         LDA.B #$10                
CODE_0188CB:        85 03         STA $03                   
CODE_0188CD:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_0188D1:        22 2B B7 03   JSL.L CheckForContact     
CODE_0188D5:        90 D1         BCC JumpLoopNext          ; If not close to shell, go back to main loop 
CODE_0188D7:        20 0E 80      JSR.W IsOnGround          ; \ If sprite not on ground, go back to main loop 
CODE_0188DA:        F0 CC         BEQ JumpLoopNext          ; / 
CODE_0188DC:        B9 7C 15      LDA.W RAM_SpriteDir,Y     ; \ If sprite not facing shell, don't jump 
CODE_0188DF:        DD 7C 15      CMP.W RAM_SpriteDir,X     ;  | 
CODE_0188E2:        F0 07         BEQ Return0188EB          ; / 
CODE_0188E4:        A9 C0         LDA.B #$C0                ; \ Finally set jump speed 
CODE_0188E6:        95 AA         STA RAM_SpriteSpeedY,X    ; / 
CODE_0188E8:        9E 3E 16      STZ.W $163E,X             
Return0188EB:       60            RTS                       ; Return 


Spr0to13SpeedX:                   .db $08,$F8,$0C,$F4

Spr0to13Prop:                     .db $00,$02,$03,$0D,$40,$42,$43,$45
                                  .db $50,$50,$50,$5C,$DD,$05,$00,$20
                                  .db $20,$00,$00,$00

ShellessKoopas:     A5 9D         LDA RAM_SpritesLocked     ; \ If sprites aren't locked, 
CODE_018906:        F0 4A         BEQ CODE_018952           ; / branch to $8952 
CODE_018908:        BD 3E 16      LDA.W $163E,X		;COME BACK HERE ON NOT STATIONARY BRANCH             
CODE_01890B:        C9 80         CMP.B #$80                
CODE_01890D:        90 10         BCC CODE_01891F           
CODE_01890F:        A5 9D         LDA RAM_SpritesLocked     ; \ If sprites are locked, 
CODE_018911:        D0 0C         BNE CODE_01891F           ; / branch to $891F 
CODE_018913:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_018916:        BD 02 16      LDA.W $1602,X             ; \  
CODE_018919:        18            CLC                       ;  |Increase sprite's image by x05 
CODE_01891A:        69 05         ADC.B #$05                ;  | 
CODE_01891C:        9D 02 16      STA.W $1602,X             ; /  
CODE_01891F:        20 31 89      JSR.W CODE_018931         
CODE_018922:        20 32 90      JSR.W SubUpdateSprPos     
CODE_018925:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_018927:        20 0E 80      JSR.W IsOnGround          ; \ If sprite is on edge (on ground), 
CODE_01892A:        F0 02         BEQ CODE_01892E           ;  |Sprite Y Speed = 0 
CODE_01892C:        74 AA         STZ RAM_SpriteSpeedY,X    ; /  
CODE_01892E:        4C 03 8B      JMP.W CODE_018B03         

CODE_018931:        B5 9E         LDA RAM_SpriteNum,X       ; \  
CODE_018933:        C9 02         CMP.B #$02                ;  |If sprite isn't Blue shelless Koopa, 
CODE_018935:        D0 05         BNE CODE_01893C           ; / branch to $893C 
CODE_018937:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01893A:        80 15         BRA Return018951          

CODE_01893C:        1E 7A 16      ASL.W RAM_Tweaker167A,X   
CODE_01893F:        38            SEC                       
CODE_018940:        7E 7A 16      ROR.W RAM_Tweaker167A,X   
CODE_018943:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_018946:        90 03         BCC CODE_01894B           
CODE_018948:        20 2A B1      JSR.W CODE_01B12A         
CODE_01894B:        1E 7A 16      ASL.W RAM_Tweaker167A,X   
CODE_01894E:        5E 7A 16      LSR.W RAM_Tweaker167A,X   
Return018951:       60            RTS                       ; Return 

CODE_018952:        BD 3E 16      LDA.W $163E,X    	;CODE RUNA T START?        
CODE_018955:        F0 5D         BEQ CODE_0189B4 	;SKIP IF $163E IS ZERO FOR SPRITE.  IS KICKING SHELL TIMER / GENREAL TIME          
CODE_018957:        C9 80         CMP.B #$80                
CODE_018959:        D0 10         BNE CODE_01896B           
CODE_01895B:        20 7C 85      JSR.W FaceMario           
CODE_01895E:        B5 9E         LDA RAM_SpriteNum,X       ; \  
CODE_018960:        C9 02         CMP.B #$02                ;  |If sprite is Blue shelless Koopa, 
CODE_018962:        F0 04         BEQ CODE_018968           ;  |Set Y speed to xE0 
CODE_018964:        A9 E0         LDA.B #$E0                ;  | 
CODE_018966:        95 AA         STA RAM_SpriteSpeedY,X    ; /  
CODE_018968:        9E 3E 16      STZ.W $163E,X			;ZERO KICKING SHELL TIMER             
CODE_01896B:        C9 01         CMP.B #$01                
CODE_01896D:        D0 99         BNE CODE_018908           
CODE_01896F:        BC 0E 16      LDY.W $160E,X		;IT KICKS THIS? !@#             
CODE_018972:        B9 C8 14      LDA.W $14C8,Y             
CODE_018975:        C9 09         CMP.B #$09		;IF NOT STATIONARY, BRANCH                
CODE_018977:        D0 8F         BNE CODE_018908           
CODE_018979:        B5 E4         LDA RAM_SpriteXLo,X		;KOOPA BLUE KICK SHELL!       
CODE_01897B:        38            SEC                       
CODE_01897C:        F9 E4 00      SBC.W RAM_SpriteXLo,Y     
CODE_01897F:        18            CLC                       
CODE_018980:        69 12         ADC.B #$12                
CODE_018982:        C9 24         CMP.B #$24                
CODE_018984:        B0 82         BCS CODE_018908           
CODE_018986:        20 28 A7      JSR.W PlayKickSfx         
CODE_018989:        20 55 A7      JSR.W CODE_01A755         
CODE_01898C:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01898F:        B9 D7 A6      LDA.W DATA_01A6D7,Y       
CODE_018992:        BC 0E 16      LDY.W $160E,X             
CODE_018995:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_018998:        A9 0A         LDA.B #$0A                ; \ Sprite status = Kicked 
CODE_01899A:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01899D:        B9 40 15      LDA.W $1540,Y             
CODE_0189A0:        99 C2 00      STA.W RAM_SpriteState,Y   
CODE_0189A3:        A9 08         LDA.B #$08                
CODE_0189A5:        99 64 15      STA.W $1564,Y             
CODE_0189A8:        B9 7A 16      LDA.W RAM_Tweaker167A,Y   
CODE_0189AB:        29 10         AND.B #$10                
CODE_0189AD:        F0 05         BEQ CODE_0189B4           
ADDR_0189AF:        A9 E0         LDA.B #$E0                
ADDR_0189B1:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_0189B4:        BD 28 15      LDA.W $1528,X             
CODE_0189B7:        F0 5C         BEQ CODE_018A15           
CODE_0189B9:        20 08 80      JSR.W IsTouchingObjSide   
CODE_0189BC:        F0 02         BEQ CODE_0189C0           
CODE_0189BE:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_0189C0:        20 0E 80      JSR.W IsOnGround          
CODE_0189C3:        F0 21         BEQ CODE_0189E6           
CODE_0189C5:        A5 86         LDA $86                   
CODE_0189C7:        C9 01         CMP.B #$01                
CODE_0189C9:        A9 02         LDA.B #$02                
CODE_0189CB:        90 01         BCC CODE_0189CE           
CODE_0189CD:        4A            LSR                       
CODE_0189CE:        85 00         STA $00                   
CODE_0189D0:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_0189D2:        C9 02         CMP.B #$02                
CODE_0189D4:        90 27         BCC CODE_0189FD           
CODE_0189D6:        10 06         BPL CODE_0189DE           
CODE_0189D8:        18            CLC                       
CODE_0189D9:        65 00         ADC $00                   
CODE_0189DB:        18            CLC                       
CODE_0189DC:        65 00         ADC $00                   
CODE_0189DE:        38            SEC                       
CODE_0189DF:        E5 00         SBC $00                   
CODE_0189E1:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_0189E3:        20 4E 80      JSR.W CODE_01804E         
CODE_0189E6:        9E 70 15      STZ.W $1570,X             
CODE_0189E9:        20 43 8B      JSR.W CODE_018B43         
CODE_0189EC:        A9 E6         LDA.B #$E6                
CODE_0189EE:        B4 9E         LDY RAM_SpriteNum,X       ; \ Branch if Blue shelless
CODE_0189F0:        C0 02         CPY.B #$02                ;  |
CODE_0189F2:        F0 02         BEQ CODE_0189F6           ; /
CODE_0189F4:        A9 86         LDA.B #$86                
CODE_0189F6:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_0189F9:        99 02 03      STA.W OAM_Tile,Y          
Return0189FC:       60            RTS                       ; Return 

CODE_0189FD:        20 0E 80      JSR.W IsOnGround 	;KOOPA CODE         
CODE_018A00:        F0 0D         BEQ CODE_018A0F           
CODE_018A02:        A9 FF         LDA.B #$FF                
CODE_018A04:        B4 9E         LDY RAM_SpriteNum,X       
CODE_018A06:        C0 02         CPY.B #$02                
CODE_018A08:        D0 02         BNE CODE_018A0C           
CODE_018A0A:        A9 A0         LDA.B #$A0                
CODE_018A0C:        9D 3E 16      STA.W $163E,X             
CODE_018A0F:        9E 28 15      STZ.W $1528,X             
CODE_018A12:        4C 13 89      JMP.W CODE_018913         

CODE_018A15:        BD 34 15      LDA.W $1534,X             
CODE_018A18:        F0 6E         BEQ CODE_018A88           
CODE_018A1A:        BC 0E 16      LDY.W $160E,X             
CODE_018A1D:        B9 C8 14      LDA.W $14C8,Y             
CODE_018A20:        C9 0A         CMP.B #$0A                
CODE_018A22:        F0 05         BEQ CODE_018A29           
CODE_018A24:        9E 34 15      STZ.W $1534,X             
CODE_018A27:        80 39         BRA CODE_018A62           

CODE_018A29:        99 28 15      STA.W $1528,Y             
CODE_018A2C:        20 08 80      JSR.W IsTouchingObjSide   
CODE_018A2F:        F0 07         BEQ CODE_018A38           
CODE_018A31:        A9 00         LDA.B #$00                
CODE_018A33:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_018A36:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_018A38:        20 0E 80      JSR.W IsOnGround          
CODE_018A3B:        F0 25         BEQ CODE_018A62           
CODE_018A3D:        A5 86         LDA $86                   
CODE_018A3F:        C9 01         CMP.B #$01                
CODE_018A41:        A9 02         LDA.B #$02                
CODE_018A43:        90 01         BCC CODE_018A46           
ADDR_018A45:        4A            LSR                       
CODE_018A46:        85 00         STA $00                   
CODE_018A48:        B9 B6 00      LDA.W RAM_SpriteSpeedX,Y  
CODE_018A4B:        C9 02         CMP.B #$02                
CODE_018A4D:        90 1A         BCC CODE_018A69           
CODE_018A4F:        10 06         BPL CODE_018A57           
CODE_018A51:        18            CLC                       
CODE_018A52:        65 00         ADC $00                   
CODE_018A54:        18            CLC                       
CODE_018A55:        65 00         ADC $00                   
CODE_018A57:        38            SEC                       
CODE_018A58:        E5 00         SBC $00                   
CODE_018A5A:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_018A5D:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_018A5F:        20 4E 80      JSR.W CODE_01804E         
CODE_018A62:        9E 70 15      STZ.W $1570,X             
CODE_018A65:        20 43 8B      JSR.W CODE_018B43         
Return018A68:       60            RTS                       ; Return 

CODE_018A69:        A9 00         LDA.B #$00                
CODE_018A6B:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_018A6D:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_018A70:        9E 34 15      STZ.W $1534,X             
CODE_018A73:        A9 09         LDA.B #$09                ; \ Sprite status = Carryable 
CODE_018A75:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_018A78:        DA            PHX                       
CODE_018A79:        BB            TYX                       
CODE_018A7A:        20 0B AA      JSR.W CODE_01AA0B         
CODE_018A7D:        BD 40 15      LDA.W $1540,X             
CODE_018A80:        F0 05         BEQ CODE_018A87           
ADDR_018A82:        A9 FF         LDA.B #$FF                
ADDR_018A84:        9D 40 15      STA.W $1540,X             
CODE_018A87:        FA            PLX                       
CODE_018A88:        B5 C2         LDA RAM_SpriteState,X     
CODE_018A8A:        F0 0F         BEQ CODE_018A9B           
CODE_018A8C:        D6 C2         DEC RAM_SpriteState,X     
CODE_018A8E:        C9 08         CMP.B #$08                
CODE_018A90:        A9 04         LDA.B #$04                
CODE_018A92:        B0 02         BCS CODE_018A96           
CODE_018A94:        A9 00         LDA.B #$00                
CODE_018A96:        9D 02 16      STA.W $1602,X             
CODE_018A99:        80 65         BRA CODE_018B00           

CODE_018A9B:        BD 58 15      LDA.W $1558,X             
CODE_018A9E:        C9 01         CMP.B #$01                
CODE_018AA0:        D0 68         BNE Spr0to13Main          
CODE_018AA2:        BC 94 15      LDY.W $1594,X		;SHELL TO INTERACT WITH???             
CODE_018AA5:        B9 C8 14      LDA.W $14C8,Y             
CODE_018AA8:        C9 08         CMP.B #$08                
CODE_018AAA:        90 2D         BCC Return018AD9          
CODE_018AAC:        B9 AA 00      LDA.W RAM_SpriteSpeedY,Y  
CODE_018AAF:        30 28         BMI Return018AD9          
CODE_018AB1:        B9 9E 00      LDA.W RAM_SpriteNum,Y     ; \ Return if Coin sprite
CODE_018AB4:        C9 21         CMP.B #$21                ;  |
CODE_018AB6:        F0 21         BEQ Return018AD9          ; /
CODE_018AB8:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_018ABC:        DA            PHX                       
CODE_018ABD:        BB            TYX                       
CODE_018ABE:        22 E5 B6 03   JSL.L GetSpriteClippingB  
CODE_018AC2:        FA            PLX                       
CODE_018AC3:        22 2B B7 03   JSL.L CheckForContact     
CODE_018AC7:        90 10         BCC Return018AD9          
CODE_018AC9:        20 80 AC      JSR.W OffScrEraseSprite   
CODE_018ACC:        BC 94 15      LDY.W $1594,X             
CODE_018ACF:        A9 10         LDA.B #$10                
CODE_018AD1:        99 58 15      STA.W $1558,Y             
CODE_018AD4:        B5 9E         LDA RAM_SpriteNum,X       
CODE_018AD6:        99 0E 16      STA.W $160E,Y		;SPRITE NUMBER TO DEAL WITH ?            
Return018AD9:       60            RTS                       ; Return 

ExplodeBomb:        8B            PHB                       ; \ Change Bob-omb into explosion 
CODE_018ADB:        A9 02         LDA.B #$02                ;  | 
CODE_018ADD:        48            PHA                       ;  | 
CODE_018ADE:        AB            PLB                       ;  | 
CODE_018ADF:        22 86 80 02   JSL.L ExplodeBombRt       ;  | 
CODE_018AE3:        AB            PLB                       ;  | 
Return018AE4:       60            RTS                       ; / 

Bobomb:             BD 34 15      LDA.W $1534,X             ; \ Branch if exploding 
CODE_018AE8:        D0 F0         BNE ExplodeBomb           ; / 
CODE_018AEA:        BD 40 15      LDA.W $1540,X             ; \ Branch if not set to explode 
CODE_018AED:        D0 0D         BNE Spr0to13Start         ; / 
CODE_018AEF:        A9 09         LDA.B #$09                ; \ Sprite status = Stunned 
CODE_018AF1:        9D C8 14      STA.W $14C8,X             ; / 
CODE_018AF4:        A9 40         LDA.B #$40                ; \ Time until explosion = #$40 
CODE_018AF6:        9D 40 15      STA.W $1540,X             ; / 
CODE_018AF9:        4C 0D 9F      JMP.W SubSprGfx2Entry1    ; Draw sprite 

Spr0to13Start:      A5 9D         LDA RAM_SpritesLocked     ; \ If sprites locked... 
CODE_018AFE:        F0 0A         BEQ Spr0to13Main          ;  | 
CODE_018B00:        20 E4 A7      JSR.W MarioSprInteractRt  ;  | ...interact with Mario 
CODE_018B03:        20 0D A4      JSR.W SubSprSprInteract   ;  | ...interact with sprites 
CODE_018B06:        20 C3 8B      JSR.W Spr0to13Gfx         ;  | ...draw sprite 
Return018B09:       60            RTS                       ; / Return 

Spr0to13Main:       20 0E 80      JSR.W IsOnGround          ; \ If sprite on ground... 
CODE_018B0D:        F0 1F         BEQ CODE_018B2E           ;  | 
CODE_018B0F:        B4 9E         LDY RAM_SpriteNum,X       ;  | 
CODE_018B11:        B9 F0 88      LDA.W Spr0to13Prop,Y      ;  | Set sprite X speed 
CODE_018B14:        4A            LSR                       ;  | 
CODE_018B15:        BC 7C 15      LDY.W RAM_SpriteDir,X     ;  | 
CODE_018B18:        90 02         BCC CODE_018B1C           ;  | 
CODE_018B1A:        C8            INY                       ;  | Increase index if sprite set to go fast 
CODE_018B1B:        C8            INY                       ;  | 
CODE_018B1C:        B9 EC 88      LDA.W Spr0to13SpeedX,Y    ;  | 
CODE_018B1F:        5D B8 15      EOR.W $15B8,X             ;  | what does $15B8,x do? 
CODE_018B22:        0A            ASL                       ;  | 
CODE_018B23:        B9 EC 88      LDA.W Spr0to13SpeedX,Y    ;  | 
CODE_018B26:        90 04         BCC CODE_018B2C           ;  | 
CODE_018B28:        18            CLC                       ;  | 
CODE_018B29:        7D B8 15      ADC.W $15B8,X             ;  | 
CODE_018B2C:        95 B6         STA RAM_SpriteSpeedX,X    ; / 
CODE_018B2E:        BC 7C 15      LDY.W RAM_SpriteDir,X     ; \ If touching an object in the direction 
CODE_018B31:        98            TYA                       ;  | that Mario is moving... 
CODE_018B32:        1A            INC A                     ;  | 
CODE_018B33:        3D 88 15      AND.W RAM_SprObjStatus,X  ;  | 
CODE_018B36:        29 03         AND.B #$03                ;  | 
CODE_018B38:        F0 02         BEQ CODE_018B3C           ;  | 
CODE_018B3A:        74 B6         STZ RAM_SpriteSpeedX,X    ; / ...Sprite X Speed = 0 
CODE_018B3C:        20 14 80      JSR.W IsTouchingCeiling   ; \ If touching ceiling... 
CODE_018B3F:        F0 02         BEQ CODE_018B43           ;  | 
ADDR_018B41:        74 AA         STZ RAM_SpriteSpeedY,X    ; / ...Sprite Y Speed = 0 
CODE_018B43:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_018B46:        20 32 90      JSR.W SubUpdateSprPos     ; Apply speed to position 
CODE_018B49:        20 5F 8E      JSR.W SetAnimationFrame   ; Set the animation frame 
CODE_018B4C:        20 0E 80      JSR.W IsOnGround          ; \ Branch if not on ground 
CODE_018B4F:        F0 33         BEQ SpriteInAir           ; / 
SpriteOnGround:     20 04 9A      JSR.W SetSomeYSpeed??     
CODE_018B54:        9E 1C 15      STZ.W $151C,X             
CODE_018B57:        B4 9E         LDY RAM_SpriteNum,X       ; \ 
CODE_018B59:        B9 F0 88      LDA.W Spr0to13Prop,Y      ;  | If follow Mario is set... 
CODE_018B5C:        48            PHA                       ;  | 
CODE_018B5D:        29 04         AND.B #$04                ;  | 
CODE_018B5F:        F0 19         BEQ DontFollowMario       ;  | 
CODE_018B61:        BD 70 15      LDA.W $1570,X             ;  | ...and time until turn == 0... 
CODE_018B64:        29 7F         AND.B #$7F                ;  | 
CODE_018B66:        D0 12         BNE DontFollowMario       ;  | 
CODE_018B68:        BD 7C 15      LDA.W RAM_SpriteDir,X     ;  | 
CODE_018B6B:        48            PHA                       ;  | 
CODE_018B6C:        20 7C 85      JSR.W FaceMario           ;  | ...face Mario 
CODE_018B6F:        68            PLA                       ;  | If was facing the other direction... 
CODE_018B70:        DD 7C 15      CMP.W RAM_SpriteDir,X     ;  | 
CODE_018B73:        F0 05         BEQ DontFollowMario       ;  | 
CODE_018B75:        A9 08         LDA.B #$08                ;  | ...set turning timer 
CODE_018B77:        9D AC 15      STA.W $15AC,X             ; / 
DontFollowMario:    68            PLA                       ; \ If jump over shells is set call routine 
CODE_018B7B:        29 08         AND.B #$08                ;  | 
CODE_018B7D:        F0 03         BEQ CODE_018B82           ;  | 
CODE_018B7F:        20 98 88      JSR.W JumpOverShells      ;  | 
CODE_018B82:        80 2C         BRA CODE_018BB0           ; / 

SpriteInAir:        B4 9E         LDY RAM_SpriteNum,X       
CODE_018B86:        B9 F0 88      LDA.W Spr0to13Prop,Y      ; \ If flutter wings is set... 
CODE_018B89:        10 05         BPL CODE_018B90           ;  | 
ADDR_018B8B:        20 5F 8E      JSR.W SetAnimationFrame   ;  | ...set frame... 
ADDR_018B8E:        80 03         BRA CODE_018B93           ;  | ...and don't zero out $1570,x 

CODE_018B90:        9E 70 15      STZ.W $1570,X             ; / 
CODE_018B93:        B9 F0 88      LDA.W Spr0to13Prop,Y      ; \ If stay on ledges is set... 
CODE_018B96:        29 02         AND.B #$02                ;  | 
CODE_018B98:        F0 16         BEQ CODE_018BB0           ;  | 
CODE_018B9A:        BD 1C 15      LDA.W $151C,X             ;  | todo: what are all these? 
CODE_018B9D:        1D 58 15      ORA.W $1558,X             ;  | 
CODE_018BA0:        1D 28 15      ORA.W $1528,X             ;  | 
CODE_018BA3:        1D 34 15      ORA.W $1534,X             ;  | 
CODE_018BA6:        D0 08         BNE CODE_018BB0           ;  | 
CODE_018BA8:        20 98 90      JSR.W FlipSpriteDir       ;  | ...change sprite direction 
CODE_018BAB:        A9 01         LDA.B #$01                ;  | 
CODE_018BAD:        9D 1C 15      STA.W $151C,X             ; / 
CODE_018BB0:        BD 28 15      LDA.W $1528,X             
CODE_018BB3:        F0 05         BEQ CODE_018BBA           
CODE_018BB5:        20 31 89      JSR.W CODE_018931         
CODE_018BB8:        80 03         BRA CODE_018BBD           

CODE_018BBA:        20 E4 A7      JSR.W MarioSprInteractRt  ; Interact with Mario 
CODE_018BBD:        20 0D A4      JSR.W SubSprSprInteract   ; Interact with other sprites 
CODE_018BC0:        20 89 90      JSR.W FlipIfTouchingObj   ; Change direction if touching an object 
Spr0to13Gfx:        BD 7C 15      LDA.W RAM_SpriteDir,X     ; \ Store sprite direction 
CODE_018BC6:        48            PHA                       ; / 
CODE_018BC7:        BC AC 15      LDY.W $15AC,X             ; \ If turning timer is set... 
CODE_018BCA:        F0 12         BEQ CODE_018BDE           ;  | 
CODE_018BCC:        A9 02         LDA.B #$02                ;  | ...set turning image 
CODE_018BCE:        9D 02 16      STA.W $1602,X             ;  | 
CODE_018BD1:        A9 00         LDA.B #$00                ;  | 
CODE_018BD3:        C0 05         CPY.B #$05                ;  | If turning timer >= 5... 
CODE_018BD5:        90 01         BCC CODE_018BD8           ;  | 
CODE_018BD7:        1A            INC A                     ;  | ...flip sprite direction (temporarily) 
CODE_018BD8:        5D 7C 15      EOR.W RAM_SpriteDir,X     ;  | 
CODE_018BDB:        9D 7C 15      STA.W RAM_SpriteDir,X     ; / 
CODE_018BDE:        B4 9E         LDY RAM_SpriteNum,X       ; \ Branch if sprite is 2 tiles high 
CODE_018BE0:        B9 F0 88      LDA.W Spr0to13Prop,Y      ;  | 
CODE_018BE3:        29 40         AND.B #$40                ;  | 
CODE_018BE5:        D0 05         BNE CODE_018BEC           ; / 
CODE_018BE7:        20 0D 9F      JSR.W SubSprGfx2Entry1    ; \ Draw 1 tile high sprite and return 
CODE_018BEA:        80 27         BRA DoneWithSprite        ; / 

CODE_018BEC:        BD 02 16      LDA.W $1602,X             ; \ Nothing? 
CODE_018BEF:        4A            LSR                       ; / 
CODE_018BF0:        B5 D8         LDA RAM_SpriteYLo,X       ; \ Y position -= #$0F (temporarily) 
CODE_018BF2:        48            PHA                       ;  | 
CODE_018BF3:        E9 0F         SBC.B #$0F                ;  | 
CODE_018BF5:        95 D8         STA RAM_SpriteYLo,X       ;  | 
CODE_018BF7:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_018BFA:        48            PHA                       ;  | 
CODE_018BFB:        E9 00         SBC.B #$00                ;  | 
CODE_018BFD:        9D D4 14      STA.W RAM_SpriteYHi,X     ; / 
CODE_018C00:        20 67 9D      JSR.W SubSprGfx1          ; Draw sprite 
CODE_018C03:        68            PLA                       ; \ Restore Y position 
CODE_018C04:        9D D4 14      STA.W RAM_SpriteYHi,X     ;  | 
CODE_018C07:        68            PLA                       ;  | 
CODE_018C08:        95 D8         STA RAM_SpriteYLo,X       ; / 
CODE_018C0A:        B5 9E         LDA RAM_SpriteNum,X       ; \ Add wings if sprite number > #$08 
CODE_018C0C:        C9 08         CMP.B #$08                ;  | 
CODE_018C0E:        90 03         BCC DoneWithSprite        ;  | 
CODE_018C10:        20 28 9E      JSR.W KoopaWingGfxRt      ; / 
DoneWithSprite:     68            PLA                       ; \ Restore sprite direction 
CODE_018C14:        9D 7C 15      STA.W RAM_SpriteDir,X     ; / 
Return018C17:       60            RTS                       ; Return 

SpinyEgg:           A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_018C1A:        D0 28         BNE CODE_018C44           ; / 
CODE_018C1C:        BD C8 14      LDA.W $14C8,X             
CODE_018C1F:        C9 08         CMP.B #$08                
CODE_018C21:        D0 21         BNE CODE_018C44           
CODE_018C23:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_018C26:        20 32 90      JSR.W SubUpdateSprPos     
CODE_018C29:        D6 AA         DEC RAM_SpriteSpeedY,X    
CODE_018C2B:        20 0E 80      JSR.W IsOnGround          
CODE_018C2E:        F0 0E         BEQ CODE_018C3E           
CODE_018C30:        A9 13         LDA.B #$13                ; \ Sprite = Spiny 
CODE_018C32:        95 9E         STA RAM_SpriteNum,X       ; / 
CODE_018C34:        22 D2 F7 07   JSL.L InitSpriteTables    ; Reset sprite tables 
CODE_018C38:        20 7C 85      JSR.W FaceMario           
CODE_018C3B:        20 D5 97      JSR.W CODE_0197D5         
CODE_018C3E:        20 89 90      JSR.W FlipIfTouchingObj   
CODE_018C41:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  
CODE_018C44:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_018C47:        A9 02         LDA.B #$02                
CODE_018C49:        20 F3 9C      JSR.W SubSprGfx0Entry0    
Return018C4C:       60            RTS                       ; Return 

GreenParaKoopa:     A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_018C4F:        D0 66         BNE CODE_018CB7           ; / 
CODE_018C51:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_018C54:        B9 EC 88      LDA.W Spr0to13SpeedX,Y    
CODE_018C57:        5D B8 15      EOR.W $15B8,X             
CODE_018C5A:        0A            ASL                       
CODE_018C5B:        B9 EC 88      LDA.W Spr0to13SpeedX,Y    
CODE_018C5E:        90 04         BCC CODE_018C64           
CODE_018C60:        18            CLC                       
CODE_018C61:        7D B8 15      ADC.W $15B8,X             
CODE_018C64:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_018C66:        98            TYA                       
CODE_018C67:        1A            INC A                     
CODE_018C68:        3D 88 15      AND.W RAM_SprObjStatus,X  ; \ If touching object,
CODE_018C6B:        29 03         AND.B #$03                ;  | 
CODE_018C6D:        F0 02         BEQ CODE_018C71           ;  | 
ADDR_018C6F:        74 B6         STZ RAM_SpriteSpeedX,X    ; / Sprite X Speed = 0 
CODE_018C71:        B5 9E         LDA RAM_SpriteNum,X       ; \ If flying left Green Koopa...
CODE_018C73:        C9 08         CMP.B #$08                ;  |
CODE_018C75:        D0 15         BNE CODE_018C8C           ;  |
CODE_018C77:        20 CC AB      JSR.W SubSprXPosNoGrvty   ;  | Update X position
CODE_018C7A:        A0 FC         LDY.B #$FC                ;  |
CODE_018C7C:        BD 70 15      LDA.W $1570,X             ;  | Y speed = #$FC or #$04,
CODE_018C7F:        29 20         AND.B #$20                ;  | depending on 1570,x
CODE_018C81:        F0 02         BEQ CODE_018C85           ;  | 
CODE_018C83:        A0 04         LDY.B #$04                ;  |
CODE_018C85:        94 AA         STY RAM_SpriteSpeedY,X    ;  |
CODE_018C87:        20 D8 AB      JSR.W SubSprYPosNoGrvty   ; / Update Y position
CODE_018C8A:        80 05         BRA CODE_018C91           

CODE_018C8C:        20 32 90      JSR.W SubUpdateSprPos     
CODE_018C8F:        D6 AA         DEC RAM_SpriteSpeedY,X    
CODE_018C91:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  
CODE_018C94:        20 14 80      JSR.W IsTouchingCeiling   
CODE_018C97:        F0 02         BEQ CODE_018C9B           
CODE_018C99:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_018C9B:        20 0E 80      JSR.W IsOnGround          
CODE_018C9E:        F0 0E         BEQ CODE_018CAE           
CODE_018CA0:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_018CA3:        A9 D0         LDA.B #$D0                
CODE_018CA5:        BC 0E 16      LDY.W $160E,X             
CODE_018CA8:        D0 02         BNE CODE_018CAC           
CODE_018CAA:        A9 B0         LDA.B #$B0                
CODE_018CAC:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_018CAE:        20 89 90      JSR.W FlipIfTouchingObj   
CODE_018CB1:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_018CB4:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_018CB7:        4C C3 8B      JMP.W Spr0to13Gfx         


DATA_018CBA:                      .db $FF,$01

DATA_018CBC:                      .db $F0,$10

RedHorzParaKoopa:   20 2B AC      JSR.W SubOffscreen1Bnk1   
CODE_018CC1:        80 03         BRA CODE_018CC6           

RedVertParaKoopa:   20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_018CC6:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_018CC8:        D0 60         BNE CODE_018D2A           ; / 
CODE_018CCA:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_018CCD:        48            PHA                       
CODE_018CCE:        20 15 9A      JSR.W UpdateDirection     
CODE_018CD1:        68            PLA                       
CODE_018CD2:        DD 7C 15      CMP.W RAM_SpriteDir,X     
CODE_018CD5:        F0 05         BEQ CODE_018CDC           
CODE_018CD7:        A9 08         LDA.B #$08                ; \ Set turning timer 
CODE_018CD9:        9D AC 15      STA.W $15AC,X             ; / 
CODE_018CDC:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_018CDF:        B5 9E         LDA RAM_SpriteNum,X       
CODE_018CE1:        C9 0A         CMP.B #$0A                
CODE_018CE3:        D0 05         BNE CODE_018CEA           
CODE_018CE5:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_018CE8:        80 13         BRA CODE_018CFD           

CODE_018CEA:        A0 FC         LDY.B #$FC                
CODE_018CEC:        BD 70 15      LDA.W $1570,X             
CODE_018CEF:        29 20         AND.B #$20                
CODE_018CF1:        F0 02         BEQ CODE_018CF5           
CODE_018CF3:        A0 04         LDY.B #$04                
CODE_018CF5:        94 AA         STY RAM_SpriteSpeedY,X    
CODE_018CF7:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_018CFA:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_018CFD:        BD 40 15      LDA.W $1540,X             
CODE_018D00:        D0 25         BNE CODE_018D27           
CODE_018D02:        F6 C2         INC RAM_SpriteState,X     
CODE_018D04:        B5 C2         LDA RAM_SpriteState,X     
CODE_018D06:        29 03         AND.B #$03                
CODE_018D08:        D0 1D         BNE CODE_018D27           
CODE_018D0A:        BD 1C 15      LDA.W $151C,X             
CODE_018D0D:        29 01         AND.B #$01                
CODE_018D0F:        A8            TAY                       
CODE_018D10:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_018D12:        18            CLC                       
CODE_018D13:        79 BA 8C      ADC.W DATA_018CBA,Y       
CODE_018D16:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_018D18:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_018D1A:        D9 BC 8C      CMP.W DATA_018CBC,Y       
CODE_018D1D:        D0 08         BNE CODE_018D27           
CODE_018D1F:        FE 1C 15      INC.W $151C,X             
CODE_018D22:        A9 30         LDA.B #$30                
CODE_018D24:        9D 40 15      STA.W $1540,X             
CODE_018D27:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  
CODE_018D2A:        20 B7 8C      JSR.W CODE_018CB7         
Return018D2D:       60            RTS                       ; Return 

WingedGoomba:       20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_018D31:        A5 9D         LDA RAM_SpritesLocked     
CODE_018D33:        F0 04         BEQ CODE_018D39           
CODE_018D35:        20 AC 8D      JSR.W CODE_018DAC         
Return018D38:       60            RTS                       ; Return 

CODE_018D39:        20 BB 8D      JSR.W CODE_018DBB         
CODE_018D3C:        20 32 90      JSR.W SubUpdateSprPos     
CODE_018D3F:        D6 AA         DEC RAM_SpriteSpeedY,X    
CODE_018D41:        B5 C2         LDA RAM_SpriteState,X     
CODE_018D43:        4A            LSR                       
CODE_018D44:        4A            LSR                       
CODE_018D45:        4A            LSR                       
CODE_018D46:        29 01         AND.B #$01                
CODE_018D48:        9D 02 16      STA.W $1602,X             
CODE_018D4B:        20 AC 8D      JSR.W CODE_018DAC         
CODE_018D4E:        F6 C2         INC RAM_SpriteState,X     
CODE_018D50:        BD 1C 15      LDA.W $151C,X             
CODE_018D53:        D0 0A         BNE CODE_018D5F           
CODE_018D55:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_018D57:        10 06         BPL CODE_018D5F           
CODE_018D59:        FE 70 15      INC.W $1570,X             
CODE_018D5C:        FE 70 15      INC.W $1570,X             
CODE_018D5F:        FE 70 15      INC.W $1570,X             
CODE_018D62:        20 14 80      JSR.W IsTouchingCeiling   
CODE_018D65:        F0 02         BEQ CODE_018D69           
CODE_018D67:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_018D69:        20 0E 80      JSR.W IsOnGround          
CODE_018D6C:        F0 37         BEQ CODE_018DA5           
CODE_018D6E:        B5 C2         LDA RAM_SpriteState,X     
CODE_018D70:        29 3F         AND.B #$3F                
CODE_018D72:        D0 03         BNE CODE_018D77           
CODE_018D74:        20 7C 85      JSR.W FaceMario           
CODE_018D77:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_018D7A:        BD 1C 15      LDA.W $151C,X             
CODE_018D7D:        D0 03         BNE CODE_018D82           
CODE_018D7F:        9E 70 15      STZ.W $1570,X             
CODE_018D82:        BD 40 15      LDA.W $1540,X             
CODE_018D85:        D0 1E         BNE CODE_018DA5           
CODE_018D87:        FE 1C 15      INC.W $151C,X             
CODE_018D8A:        A0 F0         LDY.B #$F0                
CODE_018D8C:        BD 1C 15      LDA.W $151C,X             
CODE_018D8F:        C9 04         CMP.B #$04                
CODE_018D91:        D0 10         BNE CODE_018DA3           
CODE_018D93:        9E 1C 15      STZ.W $151C,X             
CODE_018D96:        22 F9 AC 01   JSL.L GetRand             
CODE_018D9A:        29 3F         AND.B #$3F                
CODE_018D9C:        09 50         ORA.B #$50                
CODE_018D9E:        9D 40 15      STA.W $1540,X             
CODE_018DA1:        A0 D0         LDY.B #$D0                
CODE_018DA3:        94 AA         STY RAM_SpriteSpeedY,X    
CODE_018DA5:        20 89 90      JSR.W FlipIfTouchingObj   
CODE_018DA8:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  
Return018DAB:       60            RTS                       ; Return 

CODE_018DAC:        20 E9 8D      JSR.W GoombaWingGfxRt     
CODE_018DAF:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_018DB2:        18            CLC                       
CODE_018DB3:        69 04         ADC.B #$04                
CODE_018DB5:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_018DB8:        4C 0D 9F      JMP.W SubSprGfx2Entry1    

CODE_018DBB:        A9 F8         LDA.B #$F8                
CODE_018DBD:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_018DC0:        D0 02         BNE CODE_018DC4           
CODE_018DC2:        A9 08         LDA.B #$08                
CODE_018DC4:        95 B6         STA RAM_SpriteSpeedX,X    
Return018DC6:       60            RTS                       ; Return 


DATA_018DC7:                      .db $F7,$0B,$F6,$0D,$FD,$0C,$FC,$0D
                                  .db $0B,$F5,$0A,$F3,$0B,$FC,$0C,$FB
DATA_018DD7:                      .db $F7,$F7,$F8,$F8,$01,$01,$02,$02
GoombaWingGfxProp:                .db $46,$06

GoombaWingTiles:                  .db $C6,$C6,$5D,$5D

GoombaWingTileSize:               .db $02,$02,$00,$00

GoombaWingGfxRt:    20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_018DEC:        BD 70 15      LDA.W $1570,X             
CODE_018DEF:        4A            LSR                       
CODE_018DF0:        4A            LSR                       
CODE_018DF1:        29 02         AND.B #$02                
CODE_018DF3:        18            CLC                       
CODE_018DF4:        7D 02 16      ADC.W $1602,X             
CODE_018DF7:        85 05         STA $05                   
CODE_018DF9:        0A            ASL                       
CODE_018DFA:        85 02         STA $02                   
CODE_018DFC:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_018DFF:        85 04         STA $04                   
CODE_018E01:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_018E04:        DA            PHX                       
CODE_018E05:        A2 01         LDX.B #$01                
CODE_018E07:        86 03         STX $03                   
CODE_018E09:        8A            TXA                       
CODE_018E0A:        18            CLC                       
CODE_018E0B:        65 02         ADC $02                   
CODE_018E0D:        48            PHA                       
CODE_018E0E:        A6 04         LDX $04                   
CODE_018E10:        D0 03         BNE CODE_018E15           
CODE_018E12:        18            CLC                       
CODE_018E13:        69 08         ADC.B #$08                
CODE_018E15:        AA            TAX                       
CODE_018E16:        A5 00         LDA $00                   
CODE_018E18:        18            CLC                       
CODE_018E19:        7D C7 8D      ADC.W DATA_018DC7,X       
CODE_018E1C:        99 00 03      STA.W OAM_DispX,Y         
CODE_018E1F:        FA            PLX                       
CODE_018E20:        A5 01         LDA $01                   
CODE_018E22:        18            CLC                       
CODE_018E23:        7D D7 8D      ADC.W DATA_018DD7,X       
CODE_018E26:        99 01 03      STA.W OAM_DispY,Y         
CODE_018E29:        A6 05         LDX $05                   
CODE_018E2B:        BD E1 8D      LDA.W GoombaWingTiles,X   
CODE_018E2E:        99 02 03      STA.W OAM_Tile,Y          
CODE_018E31:        5A            PHY                       
CODE_018E32:        98            TYA                       
CODE_018E33:        4A            LSR                       
CODE_018E34:        4A            LSR                       
CODE_018E35:        A8            TAY                       
CODE_018E36:        BD E5 8D      LDA.W GoombaWingTileSize,X 
CODE_018E39:        99 60 04      STA.W OAM_TileSize,Y      
CODE_018E3C:        7A            PLY                       
CODE_018E3D:        A6 03         LDX $03                   
CODE_018E3F:        A5 04         LDA $04                   
CODE_018E41:        4A            LSR                       
CODE_018E42:        BD DF 8D      LDA.W GoombaWingGfxProp,X 
CODE_018E45:        B0 02         BCS CODE_018E49           
CODE_018E47:        49 40         EOR.B #$40                
CODE_018E49:        05 64         ORA $64                   
CODE_018E4B:        99 03 03      STA.W OAM_Prop,Y          
CODE_018E4E:        98            TYA                       
CODE_018E4F:        18            CLC                       
CODE_018E50:        69 08         ADC.B #$08                
CODE_018E52:        A8            TAY                       
CODE_018E53:        CA            DEX                       
CODE_018E54:        10 B1         BPL CODE_018E07           
CODE_018E56:        FA            PLX                       
CODE_018E57:        A0 FF         LDY.B #$FF                
CODE_018E59:        A9 02         LDA.B #$02                
CODE_018E5B:        20 BB B7      JSR.W FinishOAMWriteRt    
Return018E5E:       60            RTS                       ; Return 

SetAnimationFrame:  FE 70 15      INC.W $1570,X             
CODE_018E62:        BD 70 15      LDA.W $1570,X             ; \ Change animation image every 8 cycles 
CODE_018E65:        4A            LSR                       ;  | 
CODE_018E66:        4A            LSR                       ;  | 
CODE_018E67:        4A            LSR                       ;  | 
CODE_018E68:        29 01         AND.B #$01                ;  | 
CODE_018E6A:        9D 02 16      STA.W $1602,X             ; / 
Return018E6D:       60            RTS                       ; Return 


PiranhaSpeed:                     .db $00,$F0,$00,$10

PiranTimeInState:                 .db $20,$30,$20,$30

ClassicPiranhas:    BD 94 15      LDA.W $1594,X             ; \ Don't draw the sprite if in pipe and Mario naerby 
CODE_018E79:        D0 1F         BNE CODE_018E9A           ; / 
CODE_018E7B:        A5 64         LDA $64                   ; \ Set sprite to go behind objects 
CODE_018E7D:        48            PHA                       ;  | for the graphics routine 
CODE_018E7E:        BD D0 15      LDA.W $15D0,X             ;  | 
CODE_018E81:        D0 04         BNE CODE_018E87           ;  | 
CODE_018E83:        A9 10         LDA.B #$10                ;  | 
CODE_018E85:        85 64         STA $64                   ; / 
CODE_018E87:        20 67 9D      JSR.W SubSprGfx1          ; Draw the sprite 
CODE_018E8A:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; \ Modify the palette and page of the stem 
CODE_018E8D:        B9 0B 03      LDA.W OAM_Tile3Prop,Y     ;  | 
CODE_018E90:        29 F1         AND.B #$F1                ;  | 
CODE_018E92:        09 0B         ORA.B #$0B                ;  | 
CODE_018E94:        99 0B 03      STA.W OAM_Tile3Prop,Y     ; / 
CODE_018E97:        68            PLA                       ; \ Restore value of $64 
CODE_018E98:        85 64         STA $64                   ; / 
CODE_018E9A:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_018E9D:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_018E9F:        D0 26         BNE Return018EC7          ; / 
CODE_018EA1:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_018EA4:        BD 94 15      LDA.W $1594,X             ; \ Don't don't process interactions if in pipe and Mario nearby 
CODE_018EA7:        D0 03         BNE CODE_018EAC           ;  | 
CODE_018EA9:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  ; / 
CODE_018EAC:        B5 C2         LDA RAM_SpriteState,X     ; \ Y = Piranha state 
CODE_018EAE:        29 03         AND.B #$03                ;  | 
CODE_018EB0:        A8            TAY                       ; / 
CODE_018EB1:        BD 40 15      LDA.W $1540,X             ; \ Change state if it's time 
CODE_018EB4:        F0 12         BEQ ChangePiranhaState    ; / 
CODE_018EB6:        B9 6E 8E      LDA.W PiranhaSpeed,Y      ; Load Y speed 
CODE_018EB9:        B4 9E         LDY RAM_SpriteNum,X       ; \ Invert speed if upside-down piranha 
CODE_018EBB:        C0 2A         CPY.B #$2A                ;  | 
CODE_018EBD:        D0 03         BNE CODE_018EC2           ;  | 
CODE_018EBF:        49 FF         EOR.B #$FF                ;  | 
CODE_018EC1:        1A            INC A                     ; / 
CODE_018EC2:        95 AA         STA RAM_SpriteSpeedY,X    ; Store Y Speed 
CODE_018EC4:        20 D8 AB      JSR.W SubSprYPosNoGrvty   ; Update position based on speed 
Return018EC7:       60            RTS                       ; Return 

ChangePiranhaState: B5 C2         LDA RAM_SpriteState,X     ; \ $00 = Sprite state (00 - 03) 
CODE_018ECA:        29 03         AND.B #$03                ;  | 
CODE_018ECC:        85 00         STA $00                   ; / 
CODE_018ECE:        D0 11         BNE CODE_018EE1           ; \ If the piranha is in the pipe (State 0)... 
CODE_018ED0:        20 30 AD      JSR.W SubHorizPos         ;  | ...check if Mario is nearby... 
CODE_018ED3:        A5 0F         LDA $0F                   ;  | 
CODE_018ED5:        18            CLC                       ;  | 
CODE_018ED6:        69 1B         ADC.B #$1B                ;  | 
CODE_018ED8:        C9 37         CMP.B #$37                ;  | 
CODE_018EDA:        A9 01         LDA.B #$01                ;  | 
CODE_018EDC:        9D 94 15      STA.W $1594,X             ;  | ...and set $1594,x if so 
CODE_018EDF:        90 0D         BCC Return018EEE          ;  | 
CODE_018EE1:        9E 94 15      STZ.W $1594,X             ; / 
CODE_018EE4:        A4 00         LDY $00                   ; \ Set time in state 
CODE_018EE6:        B9 72 8E      LDA.W PiranTimeInState,Y  ;  | 
CODE_018EE9:        9D 40 15      STA.W $1540,X             ; / 
CODE_018EEC:        F6 C2         INC RAM_SpriteState,X     ; Go to next state 
Return018EEE:       60            RTS                       ; Return 

CODE_018EEF:        A0 07         LDY.B #$07                ; \ Find a free extended sprite slot 
CODE_018EF1:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   
CODE_018EF4:        F0 11         BEQ CODE_018F07           
CODE_018EF6:        88            DEY                       
CODE_018EF7:        10 F8         BPL CODE_018EF1           
ADDR_018EF9:        CE FC 18      DEC.W $18FC               
ADDR_018EFC:        10 05         BPL ADDR_018F03           
ADDR_018EFE:        A9 07         LDA.B #$07                
ADDR_018F00:        8D FC 18      STA.W $18FC               
ADDR_018F03:        AC FC 18      LDY.W $18FC               
Return018F06:       60            RTS                       ; Return 

CODE_018F07:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_018F0A:        D0 FA         BNE Return018F06          
Return018F0C:       60            RTS                       ; Return 

HoppingFlame:       A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_018F0F:        D0 38         BNE CODE_018F49           ; / 
CODE_018F11:        FE 02 16      INC.W $1602,X             
CODE_018F14:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_018F17:        20 32 90      JSR.W SubUpdateSprPos     
CODE_018F1A:        D6 AA         DEC RAM_SpriteSpeedY,X    
CODE_018F1C:        20 BB 8D      JSR.W CODE_018DBB         
CODE_018F1F:        16 B6         ASL RAM_SpriteSpeedX,X    
CODE_018F21:        20 0E 80      JSR.W IsOnGround          
CODE_018F24:        F0 1D         BEQ CODE_018F43           
CODE_018F26:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_018F28:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_018F2B:        BD 40 15      LDA.W $1540,X             
CODE_018F2E:        F0 08         BEQ CODE_018F38           
CODE_018F30:        3A            DEC A                     
CODE_018F31:        D0 10         BNE CODE_018F43           
CODE_018F33:        20 50 8F      JSR.W CODE_018F50         
CODE_018F36:        80 0B         BRA CODE_018F43           

CODE_018F38:        22 F9 AC 01   JSL.L GetRand             
CODE_018F3C:        29 1F         AND.B #$1F                
CODE_018F3E:        09 20         ORA.B #$20                
CODE_018F40:        9D 40 15      STA.W $1540,X             
CODE_018F43:        20 89 90      JSR.W FlipIfTouchingObj   
CODE_018F46:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_018F49:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_018F4C:        20 0D 9F      JSR.W SubSprGfx2Entry1    
Return018F4F:       60            RTS                       ; Return 

CODE_018F50:        22 F9 AC 01   JSL.L GetRand             
CODE_018F54:        29 0F         AND.B #$0F                
CODE_018F56:        09 D0         ORA.B #$D0                
CODE_018F58:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_018F5A:        AD 8D 14      LDA.W RAM_RandomByte1     
CODE_018F5D:        29 03         AND.B #$03                
CODE_018F5F:        D0 03         BNE CODE_018F64           
CODE_018F61:        20 7C 85      JSR.W FaceMario           
CODE_018F64:        20 CB 80      JSR.W IsSprOffScreen      
CODE_018F67:        D0 2D         BNE Return018F96          
CODE_018F69:        20 EF 8E      JSR.W CODE_018EEF         
CODE_018F6C:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_018F6E:        18            CLC                       
CODE_018F6F:        69 04         ADC.B #$04                
CODE_018F71:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
CODE_018F74:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_018F77:        69 00         ADC.B #$00                
CODE_018F79:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
CODE_018F7C:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_018F7E:        18            CLC                       
CODE_018F7F:        69 08         ADC.B #$08                
CODE_018F81:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
CODE_018F84:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_018F87:        69 00         ADC.B #$00                
CODE_018F89:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
CODE_018F8C:        A9 03         LDA.B #$03                ; \ Extended sprite = Hopping flame's flame 
CODE_018F8E:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_018F91:        A9 FF         LDA.B #$FF                
CODE_018F93:        99 6F 17      STA.W $176F,Y             
Return018F96:       60            RTS                       ; Return 

Lakitu:             A0 00         LDY.B #$00                
CODE_018F99:        BD 58 15      LDA.W $1558,X             
CODE_018F9C:        F0 02         BEQ CODE_018FA0           
CODE_018F9E:        A0 02         LDY.B #$02                
CODE_018FA0:        98            TYA                       
CODE_018FA1:        9D 02 16      STA.W $1602,X             
CODE_018FA4:        20 67 9D      JSR.W SubSprGfx1          
CODE_018FA7:        BD 58 15      LDA.W $1558,X             
CODE_018FAA:        F0 0C         BEQ CODE_018FB8           
CODE_018FAC:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_018FAF:        B9 05 03      LDA.W OAM_Tile2DispY,Y    
CODE_018FB2:        38            SEC                       
CODE_018FB3:        E9 03         SBC.B #$03                
CODE_018FB5:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_018FB8:        BD 1C 15      LDA.W $151C,X             
CODE_018FBB:        F0 04         BEQ SubSprSpr+MarioSpr    
CODE_018FBD:        22 72 E6 02   JSL.L CODE_02E672         
SubSprSpr+MarioSpr: 20 0D A4      JSR.W SubSprSprInteract   
CODE_018FC4:        4C E4 A7      JMP.W MarioSprInteractRt  


BulletGfxProp:                    .db $42,$02,$03,$83,$03,$43,$03,$43
DATA_018FCF:                      .db $00,$00,$01,$01,$02,$03,$03,$02
BulletSpeedX:                     .db $20,$E0,$00,$00,$18,$18,$E8,$E8
BulletSpeedY:                     .db $00,$00,$E0,$20,$E8,$18,$18,$E8

BulletBill:         A9 01         LDA.B #$01                
CODE_018FE9:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_018FEC:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_018FEE:        D0 24         BNE CODE_019014           ; / 
CODE_018FF0:        B4 C2         LDY RAM_SpriteState,X     
CODE_018FF2:        B9 C7 8F      LDA.W BulletGfxProp,Y     ; \ Store gfx properties into palette byte
CODE_018FF5:        9D F6 15      STA.W RAM_SpritePal,X     ; /
CODE_018FF8:        B9 CF 8F      LDA.W DATA_018FCF,Y       
CODE_018FFB:        9D 02 16      STA.W $1602,X             
CODE_018FFE:        B9 D7 8F      LDA.W BulletSpeedX,Y      ; \ Set X speed
CODE_019001:        95 B6         STA RAM_SpriteSpeedX,X    ; /
CODE_019003:        B9 DF 8F      LDA.W BulletSpeedY,Y      ; \ Set Y speed
CODE_019006:        95 AA         STA RAM_SpriteSpeedY,X    ; /
CODE_019008:        20 CC AB      JSR.W SubSprXPosNoGrvty   ; \ Update position
CODE_01900B:        20 D8 AB      JSR.W SubSprYPosNoGrvty   ; /
CODE_01900E:        20 40 91      JSR.W CODE_019140         
CODE_019011:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  ; Interact with Mario and sprites
CODE_019014:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_019017:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_019019:        38            SEC                       
CODE_01901A:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01901C:        C9 F0         CMP.B #$F0                
CODE_01901E:        90 03         BCC CODE_019023           
CODE_019020:        9E C8 14      STZ.W $14C8,X             
CODE_019023:        BD 40 15      LDA.W $1540,X             
CODE_019026:        F0 03         BEQ CODE_01902B           
CODE_019028:        4C 46 95      JMP.W CODE_019546         

CODE_01902B:        4C 0D 9F      JMP.W SubSprGfx2Entry1    


DATA_01902E:                      .db $40,$10

DATA_019030:                      .db $03,$01

SubUpdateSprPos:    20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_019035:        A0 00         LDY.B #$00                
CODE_019037:        BD 4A 16      LDA.W $164A,X             
CODE_01903A:        F0 0D         BEQ CODE_019049           
CODE_01903C:        C8            INY                       
CODE_01903D:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01903F:        10 08         BPL CODE_019049           
CODE_019041:        C9 E8         CMP.B #$E8                
CODE_019043:        B0 04         BCS CODE_019049           
CODE_019045:        A9 E8         LDA.B #$E8                
CODE_019047:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_019049:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01904B:        18            CLC                       
CODE_01904C:        79 30 90      ADC.W DATA_019030,Y       
CODE_01904F:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_019051:        30 0A         BMI CODE_01905D           
CODE_019053:        D9 2E 90      CMP.W DATA_01902E,Y       
CODE_019056:        90 05         BCC CODE_01905D           
CODE_019058:        B9 2E 90      LDA.W DATA_01902E,Y       
CODE_01905B:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01905D:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01905F:        48            PHA                       
CODE_019060:        BC 4A 16      LDY.W $164A,X             
CODE_019063:        F0 11         BEQ CODE_019076           
CODE_019065:        0A            ASL                       
CODE_019066:        76 B6         ROR RAM_SpriteSpeedX,X    
CODE_019068:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01906A:        48            PHA                       
CODE_01906B:        85 00         STA $00                   
CODE_01906D:        0A            ASL                       
CODE_01906E:        66 00         ROR $00                   
CODE_019070:        68            PLA                       
CODE_019071:        18            CLC                       
CODE_019072:        65 00         ADC $00                   
CODE_019074:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_019076:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_019079:        68            PLA                       
CODE_01907A:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01907C:        BD DC 15      LDA.W $15DC,X             
CODE_01907F:        D0 04         BNE ADDR_019085           
CODE_019081:        20 40 91      JSR.W CODE_019140         
Return019084:       60            RTS                       ; Return 

ADDR_019085:        9E 88 15      STZ.W RAM_SprObjStatus,X  
Return019088:       60            RTS                       ; Return 

FlipIfTouchingObj:  BD 7C 15      LDA.W RAM_SpriteDir,X     ; \ If touching an object in the direction 
CODE_01908C:        1A            INC A                     ;  | that the sprite is moving... 
CODE_01908D:        3D 88 15      AND.W RAM_SprObjStatus,X  ;  | 
CODE_019090:        29 03         AND.B #$03                ;  | 
CODE_019092:        F0 03         BEQ Return019097          ;  | 
CODE_019094:        20 98 90      JSR.W FlipSpriteDir       ;  | ...flip direction 
Return019097:       60            RTS                       ; / 

FlipSpriteDir:      BD AC 15      LDA.W $15AC,X             ; \ Return if turning timer is set 
CODE_01909B:        D0 14         BNE Return0190B1          ; / 
CODE_01909D:        A9 08         LDA.B #$08                ; \ Set turning timer 
CODE_01909F:        9D AC 15      STA.W $15AC,X             ; / 
CODE_0190A2:        B5 B6         LDA RAM_SpriteSpeedX,X    ; \ Invert speed 
CODE_0190A4:        49 FF         EOR.B #$FF                ;  | 
CODE_0190A6:        1A            INC A                     ;  | 
CODE_0190A7:        95 B6         STA RAM_SpriteSpeedX,X    ; / 
CODE_0190A9:        BD 7C 15      LDA.W RAM_SpriteDir,X     ; \ Flip sprite direction 
CODE_0190AC:        49 01         EOR.B #$01                ;  | 
CODE_0190AE:        9D 7C 15      STA.W RAM_SpriteDir,X     ; / 
Return0190B1:       60            RTS                       ; Return 

GenericSprGfxRt2:   8B            PHB                       
CODE_0190B3:        4B            PHK                       
CODE_0190B4:        AB            PLB                       
CODE_0190B5:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_0190B8:        AB            PLB                       
Return0190B9:       6B            RTL                       ; Return 


SpriteObjClippingX:               .db $0E,$02,$08,$08,$0E,$02,$07,$07
                                  .db $07,$07,$07,$07,$0E,$02,$08,$08
                                  .db $10,$00,$08,$08,$0D,$02,$08,$08
                                  .db $07,$00,$04,$04,$1F,$01,$10,$10
                                  .db $0F,$00,$08,$08,$10,$00,$08,$08
                                  .db $0D,$02,$08,$08,$0E,$02,$08,$08
                                  .db $0D,$02,$08,$08,$10,$00,$08,$08
                                  .db $1F,$00,$10,$10,$08

SpriteObjClippingY:               .db $08,$08,$10,$02,$12,$12,$20,$02
                                  .db $07,$07,$07,$07,$10,$10,$20,$0B
                                  .db $12,$12,$20,$02,$18,$18,$20,$10
                                  .db $04,$04,$08,$00,$10,$10,$1F,$01
                                  .db $08,$08,$0F,$00,$08,$08,$10,$00
                                  .db $48,$48,$50,$42,$04,$04,$08,$00
                                  .db $00,$00,$00,$00,$08,$08,$10,$00
                                  .db $08,$08,$10,$00,$04

DATA_019134:                      .db $01,$02,$04,$08

CODE_019138:        8B            PHB                       
CODE_019139:        4B            PHK                       
CODE_01913A:        AB            PLB                       
CODE_01913B:        20 40 91      JSR.W CODE_019140         
CODE_01913E:        AB            PLB                       
Return01913F:       6B            RTL                       ; Return 

CODE_019140:        9C 94 16      STZ.W $1694               
CODE_019143:        9E 88 15      STZ.W RAM_SprObjStatus,X  ; Set sprite's position status to 0 (in air) 
CODE_019146:        9E B8 15      STZ.W $15B8,X             
CODE_019149:        9C 5E 18      STZ.W $185E               
CODE_01914C:        BD 4A 16      LDA.W $164A,X             
CODE_01914F:        8D 95 16      STA.W $1695               
CODE_019152:        9E 4A 16      STZ.W $164A,X             
CODE_019155:        20 11 92      JSR.W CODE_019211         
CODE_019158:        A5 5B         LDA RAM_IsVerticalLvl     ; Vertical level flag 
CODE_01915A:        10 62         BPL CODE_0191BE           
CODE_01915C:        EE 5E 18      INC.W $185E               
CODE_01915F:        B5 E4         LDA RAM_SpriteXLo,X       ; \ Sprite's X position += $26 
CODE_019161:        18            CLC                       ;  | for call to below routine 
CODE_019162:        65 26         ADC $26                   ;  | 
CODE_019164:        95 E4         STA RAM_SpriteXLo,X       ;  | 
CODE_019166:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_019169:        65 27         ADC $27                   ;  | 
CODE_01916B:        9D E0 14      STA.W RAM_SpriteXHi,X     ; / 
CODE_01916E:        B5 D8         LDA RAM_SpriteYLo,X       ; \ Sprite's Y position += $28 
CODE_019170:        18            CLC                       ;  | for call to below routine 
CODE_019171:        65 28         ADC $28                   ;  | 
CODE_019173:        95 D8         STA RAM_SpriteYLo,X       ;  | 
CODE_019175:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_019178:        65 29         ADC $29                   ;  | 
CODE_01917A:        9D D4 14      STA.W RAM_SpriteYHi,X     ; / 
CODE_01917D:        20 11 92      JSR.W CODE_019211         
CODE_019180:        B5 E4         LDA RAM_SpriteXLo,X       ; \ Restore sprite's original position 
CODE_019182:        38            SEC                       ;  | 
CODE_019183:        E5 26         SBC $26                   ;  | 
CODE_019185:        95 E4         STA RAM_SpriteXLo,X       ;  | 
CODE_019187:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_01918A:        E5 27         SBC $27                   ;  | 
CODE_01918C:        9D E0 14      STA.W RAM_SpriteXHi,X     ;  | 
CODE_01918F:        B5 D8         LDA RAM_SpriteYLo,X       ;  | 
CODE_019191:        38            SEC                       ;  | 
CODE_019192:        E5 28         SBC $28                   ;  | 
CODE_019194:        95 D8         STA RAM_SpriteYLo,X       ;  | 
CODE_019196:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_019199:        E5 29         SBC $29                   ;  | 
CODE_01919B:        9D D4 14      STA.W RAM_SpriteYHi,X     ; / 
CODE_01919E:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_0191A1:        10 1B         BPL CODE_0191BE           
CODE_0191A3:        29 03         AND.B #$03                
CODE_0191A5:        D0 17         BNE CODE_0191BE           
CODE_0191A7:        A0 00         LDY.B #$00                
CODE_0191A9:        AD BF 17      LDA.W $17BF               ; \ A = -$17BF 
CODE_0191AC:        49 FF         EOR.B #$FF                ;  | 
CODE_0191AE:        1A            INC A                     ;  | 
CODE_0191AF:        10 01         BPL CODE_0191B2           
ADDR_0191B1:        88            DEY                       
CODE_0191B2:        18            CLC                       
CODE_0191B3:        75 E4         ADC RAM_SpriteXLo,X       
CODE_0191B5:        95 E4         STA RAM_SpriteXLo,X       
CODE_0191B7:        98            TYA                       
CODE_0191B8:        7D E0 14      ADC.W RAM_SpriteXHi,X     
CODE_0191BB:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_0191BE:        BD 0F 19      LDA.W RAM_Tweaker190F,X   ; \ Branch if "Don't get stuck in walls" is not set 
CODE_0191C1:        10 2A         BPL CODE_0191ED           ; / 
CODE_0191C3:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not touching object 
CODE_0191C6:        29 03         AND.B #$03                ;  | 
CODE_0191C8:        F0 23         BEQ CODE_0191ED           ; / 
CODE_0191CA:        A8            TAY                       
CODE_0191CB:        BD D0 15      LDA.W $15D0,X             
CODE_0191CE:        D0 1D         BNE CODE_0191ED           
CODE_0191D0:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_0191D2:        18            CLC                       
CODE_0191D3:        79 83 92      ADC.W Return019283,Y      
CODE_0191D6:        95 E4         STA RAM_SpriteXLo,X       
CODE_0191D8:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_0191DB:        79 85 92      ADC.W DATA_019285,Y       
CODE_0191DE:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_0191E1:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_0191E3:        D0 08         BNE CODE_0191ED           
CODE_0191E5:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_0191E8:        29 FC         AND.B #$FC                
CODE_0191EA:        9D 88 15      STA.W RAM_SprObjStatus,X  
CODE_0191ED:        BD 4A 16      LDA.W $164A,X             
CODE_0191F0:        4D 95 16      EOR.W $1695               
CODE_0191F3:        F0 1B         BEQ Return019210          
CODE_0191F5:        0A            ASL                       
CODE_0191F6:        BD 6E 16      LDA.W RAM_Tweaker166E,X   ; \ TODO: Unknown Bit A... 
CODE_0191F9:        29 40         AND.B #$40                ;  | ... may be related to cape 
CODE_0191FB:        1D E2 1F      ORA.W $1FE2,X             
CODE_0191FE:        D0 10         BNE Return019210          
CODE_019200:        B0 0A         BCS CODE_01920C           
CODE_019202:        2C 9B 0D      BIT.W $0D9B               
CODE_019205:        30 05         BMI CODE_01920C           
CODE_019207:        22 C0 84 02   JSL.L CODE_0284C0         
Return01920B:       60            RTS                       ; Return 

CODE_01920C:        22 28 85 02   JSL.L CODE_028528         
Return019210:       60            RTS                       ; Return 

CODE_019211:        AD 0E 19      LDA.W $190E               
CODE_019214:        F0 45         BEQ CODE_01925B           
CODE_019216:        A5 85         LDA RAM_IsWaterLevel      
CODE_019218:        D0 3E         BNE CODE_019258           
CODE_01921A:        A0 3C         LDY.B #$3C                
CODE_01921C:        20 4D 94      JSR.W CODE_01944D         
CODE_01921F:        F0 12         BEQ CODE_019233           
CODE_019221:        AD 93 16      LDA.W $1693               
CODE_019224:        C9 6E         CMP.B #$6E                
CODE_019226:        90 33         BCC CODE_01925B           
CODE_019228:        22 4D F0 00   JSL.L CODE_00F04D         
CODE_01922C:        AD 93 16      LDA.W $1693               
CODE_01922F:        90 2A         BCC CODE_01925B           
CODE_019231:        B0 07         BCS CODE_01923A           
CODE_019233:        AD 93 16      LDA.W $1693               
CODE_019236:        C9 06         CMP.B #$06                
CODE_019238:        B0 21         BCS CODE_01925B           
CODE_01923A:        A8            TAY                       
CODE_01923B:        BD 4A 16      LDA.W $164A,X             
CODE_01923E:        09 01         ORA.B #$01                
CODE_019240:        C0 04         CPY.B #$04                
CODE_019242:        D0 14         BNE CODE_019258           
CODE_019244:        48            PHA                       
CODE_019245:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if Yoshi 
CODE_019247:        C9 35         CMP.B #$35                ;  | 
CODE_019249:        F0 07         BEQ CODE_019252           ; / 
CODE_01924B:        BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ Branch if "Process interaction every frame" 
CODE_01924E:        29 02         AND.B #$02                ;  | is set 
CODE_019250:        D0 03         BNE CODE_019255           ; / 
CODE_019252:        20 30 93      JSR.W CODE_019330         
CODE_019255:        68            PLA                       
CODE_019256:        09 80         ORA.B #$80                
CODE_019258:        9D 4A 16      STA.W $164A,X             
CODE_01925B:        BD 86 16      LDA.W RAM_Tweaker1686,X   
CODE_01925E:        30 B0         BMI Return019210          
CODE_019260:        AD 5E 18      LDA.W $185E               
CODE_019263:        F0 0A         BEQ CODE_01926F           
CODE_019265:        2C 0E 19      BIT.W $190E               
CODE_019268:        70 56         BVS Return0192C0          
CODE_01926A:        BD 6E 16      LDA.W RAM_Tweaker166E,X   ; \ TODO: Return if Unknown Bit B is set 
CODE_01926D:        30 51         BMI Return0192C0          ; / 
CODE_01926F:        20 C9 92      JSR.W CODE_0192C9         
CODE_019272:        BD 0F 19      LDA.W RAM_Tweaker190F,X   ; \ Branch if "Don't get stuck in walls" is not set 
CODE_019275:        10 11         BPL CODE_019288           ; / 
CODE_019277:        B5 B6         LDA RAM_SpriteSpeedX,X    ; \ Branch if sprite has X speed... 
CODE_019279:        1D AC 15      ORA.W $15AC,X             ;  | ...or sprite is turning 
CODE_01927C:        D0 0A         BNE CODE_019288           ; / 
CODE_01927E:        A5 13         LDA RAM_FrameCounter      
CODE_019280:        20 8E 92      JSR.W CODE_01928E         
Return019283:       60            RTS                       ; Return 


DATA_019284:                      .db $FC

DATA_019285:                      .db $04,$FF,$00

CODE_019288:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01928A:        F0 34         BEQ Return0192C0          
CODE_01928C:        0A            ASL                       
CODE_01928D:        2A            ROL                       
CODE_01928E:        29 01         AND.B #$01                
CODE_019290:        A8            TAY                       
CODE_019291:        20 41 94      JSR.W CODE_019441         
CODE_019294:        8D 62 18      STA.W $1862               
CODE_019297:        F0 21         BEQ CODE_0192BA           
CODE_019299:        AD 93 16      LDA.W $1693               
CODE_01929C:        C9 11         CMP.B #$11                
CODE_01929E:        90 1A         BCC CODE_0192BA           
CODE_0192A0:        C9 6E         CMP.B #$6E                
CODE_0192A2:        B0 16         BCS CODE_0192BA           
CODE_0192A4:        20 25 94      JSR.W CODE_019425         
CODE_0192A7:        AD 93 16      LDA.W $1693               
CODE_0192AA:        8D A7 18      STA.W $18A7               
CODE_0192AD:        AD 5E 18      LDA.W $185E               
CODE_0192B0:        F0 08         BEQ CODE_0192BA           
CODE_0192B2:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_0192B5:        09 40         ORA.B #$40                
CODE_0192B7:        9D 88 15      STA.W RAM_SprObjStatus,X  
CODE_0192BA:        AD 93 16      LDA.W $1693               
CODE_0192BD:        8D 60 18      STA.W $1860               
Return0192C0:       60            RTS                       ; Return 


DATA_0192C1:                      .db $FE,$02,$FF,$00

DATA_0192C5:                      .db $01,$FF

DATA_0192C7:                      .db $00,$FF

CODE_0192C9:        A0 02         LDY.B #$02                
CODE_0192CB:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_0192CD:        10 01         BPL CODE_0192D0           
CODE_0192CF:        C8            INY                       
CODE_0192D0:        20 41 94      JSR.W CODE_019441         
CODE_0192D3:        8D D7 18      STA.W $18D7               
CODE_0192D6:        08            PHP                       
CODE_0192D7:        AD 93 16      LDA.W $1693               
CODE_0192DA:        8D 5F 18      STA.W $185F               
CODE_0192DD:        28            PLP                       
CODE_0192DE:        F0 2F         BEQ Return01930F          
CODE_0192E0:        AD 93 16      LDA.W $1693               
CODE_0192E3:        C0 02         CPY.B #$02                
CODE_0192E5:        F0 29         BEQ CODE_019310           
CODE_0192E7:        C9 11         CMP.B #$11                
CODE_0192E9:        90 24         BCC Return01930F          
CODE_0192EB:        C9 6E         CMP.B #$6E                
CODE_0192ED:        90 0A         BCC CODE_0192F9           
CODE_0192EF:        CD 30 14      CMP.W $1430               
CODE_0192F2:        90 1B         BCC Return01930F          
CODE_0192F4:        CD 31 14      CMP.W $1431               
CODE_0192F7:        B0 16         BCS Return01930F          
CODE_0192F9:        20 25 94      JSR.W CODE_019425         
CODE_0192FC:        AD 93 16      LDA.W $1693               
CODE_0192FF:        8D 68 18      STA.W $1868               
CODE_019302:        AD 5E 18      LDA.W $185E               
CODE_019305:        F0 08         BEQ Return01930F          
CODE_019307:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_01930A:        09 20         ORA.B #$20                
CODE_01930C:        9D 88 15      STA.W RAM_SprObjStatus,X  
Return01930F:       60            RTS                       ; Return 

CODE_019310:        C9 59         CMP.B #$59                
CODE_019312:        90 27         BCC CODE_01933B           
CODE_019314:        C9 5C         CMP.B #$5C                
CODE_019316:        B0 23         BCS CODE_01933B           
CODE_019318:        AC 31 19      LDY.W $1931               
CODE_01931B:        C0 0E         CPY.B #$0E                
CODE_01931D:        F0 04         BEQ CODE_019323           
CODE_01931F:        C0 03         CPY.B #$03                
CODE_019321:        D0 18         BNE CODE_01933B           
CODE_019323:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if sprite == Yoshi 
CODE_019325:        C9 35         CMP.B #$35                ;  | 
CODE_019327:        F0 07         BEQ CODE_019330           ; / 
CODE_019329:        BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ Branch if "Process interaction every frame" 
CODE_01932C:        29 02         AND.B #$02                ;  | is set 
CODE_01932E:        D0 0B         BNE CODE_01933B           ; / 
CODE_019330:        A9 05         LDA.B #$05                ; \ Sprite status = #$05 ??? 
CODE_019332:        9D C8 14      STA.W $14C8,X             ; / 
CODE_019335:        A9 40         LDA.B #$40                
CODE_019337:        9D 58 15      STA.W $1558,X             
Return01933A:       60            RTS                       ; Return 

CODE_01933B:        C9 11         CMP.B #$11                
CODE_01933D:        90 71         BCC CODE_0193B0           
CODE_01933F:        C9 6E         CMP.B #$6E                
CODE_019341:        90 75         BCC CODE_0193B8           
CODE_019343:        C9 D8         CMP.B #$D8                
CODE_019345:        B0 3F         BCS CODE_019386           
CODE_019347:        22 19 FA 00   JSL.L CODE_00FA19         
CODE_01934B:        B7 05         LDA [$05],Y               
CODE_01934D:        C9 10         CMP.B #$10                
CODE_01934F:        F0 5E         BEQ Return0193AF          
CODE_019351:        B0 33         BCS CODE_019386           
CODE_019353:        A5 00         LDA $00                   
CODE_019355:        C9 0C         CMP.B #$0C                
CODE_019357:        B0 04         BCS CODE_01935D           
CODE_019359:        D7 05         CMP [$05],Y               
CODE_01935B:        90 52         BCC Return0193AF          
CODE_01935D:        B7 05         LDA [$05],Y               
CODE_01935F:        8D 94 16      STA.W $1694               
CODE_019362:        DA            PHX                       
CODE_019363:        A6 08         LDX $08                   
CODE_019365:        BF 3D E5 00   LDA.L DATA_00E53D,X       
CODE_019369:        FA            PLX                       
CODE_01936A:        9D B8 15      STA.W $15B8,X             
CODE_01936D:        C9 04         CMP.B #$04                
CODE_01936F:        F0 04         BEQ CODE_019375           
CODE_019371:        C9 FC         CMP.B #$FC                
CODE_019373:        D0 0F         BNE CODE_019384           
CODE_019375:        55 B6         EOR RAM_SpriteSpeedX,X    
CODE_019377:        10 07         BPL CODE_019380           
CODE_019379:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01937B:        F0 03         BEQ CODE_019380           
CODE_01937D:        20 98 90      JSR.W FlipSpriteDir       
CODE_019380:        22 CA C1 03   JSL.L CODE_03C1CA         
CODE_019384:        80 32         BRA CODE_0193B8           

CODE_019386:        A5 0C         LDA $0C                   
CODE_019388:        29 0F         AND.B #$0F                
CODE_01938A:        C9 05         CMP.B #$05                
CODE_01938C:        B0 21         BCS Return0193AF          
CODE_01938E:        BD C8 14      LDA.W $14C8,X             ; \ Return if sprite status == Killed 
CODE_019391:        C9 02         CMP.B #$02                ;  | 
CODE_019393:        F0 1A         BEQ Return0193AF          ; / 
CODE_019395:        C9 05         CMP.B #$05                ; \ Return if sprite status == #$05 
CODE_019397:        F0 16         BEQ Return0193AF          ; / 
CODE_019399:        C9 0B         CMP.B #$0B                ; \ Return if sprite status == Carried 
CODE_01939B:        F0 12         BEQ Return0193AF          ; / 
CODE_01939D:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01939F:        38            SEC                       
CODE_0193A0:        E9 01         SBC.B #$01                
CODE_0193A2:        95 D8         STA RAM_SpriteYLo,X       
CODE_0193A4:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_0193A7:        E9 00         SBC.B #$00                
CODE_0193A9:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_0193AC:        20 C9 92      JSR.W CODE_0192C9         
Return0193AF:       60            RTS                       ; Return 

CODE_0193B0:        A5 0C         LDA $0C                   
CODE_0193B2:        29 0F         AND.B #$0F                
CODE_0193B4:        C9 05         CMP.B #$05                
CODE_0193B6:        B0 6C         BCS Return019424          
CODE_0193B8:        BD 86 16      LDA.W RAM_Tweaker1686,X   
CODE_0193BB:        29 04         AND.B #$04                
CODE_0193BD:        D0 55         BNE CODE_019414           
CODE_0193BF:        BD C8 14      LDA.W $14C8,X             ; \ Return if sprite status == Killed 
CODE_0193C2:        C9 02         CMP.B #$02                ;  | 
CODE_0193C4:        F0 5E         BEQ Return019424          ; / 
CODE_0193C6:        C9 05         CMP.B #$05                ; \ Return if sprite status == #$05 
CODE_0193C8:        F0 5A         BEQ Return019424          ; / 
CODE_0193CA:        C9 0B         CMP.B #$0B                ; \ Return if sprite status == Carried 
CODE_0193CC:        F0 56         BEQ Return019424          ; / 
CODE_0193CE:        AC 93 16      LDY.W $1693               
CODE_0193D1:        C0 0C         CPY.B #$0C                
CODE_0193D3:        F0 04         BEQ CODE_0193D9           
CODE_0193D5:        C0 0D         CPY.B #$0D                
CODE_0193D7:        D0 2C         BNE CODE_019405           
CODE_0193D9:        A5 13         LDA RAM_FrameCounter      
CODE_0193DB:        29 03         AND.B #$03                
CODE_0193DD:        D0 26         BNE CODE_019405           
CODE_0193DF:        20 08 80      JSR.W IsTouchingObjSide   
CODE_0193E2:        D0 21         BNE CODE_019405           
CODE_0193E4:        AD 31 19      LDA.W $1931               
CODE_0193E7:        C9 02         CMP.B #$02                
CODE_0193E9:        F0 04         BEQ ADDR_0193EF           
CODE_0193EB:        C9 08         CMP.B #$08                
CODE_0193ED:        D0 16         BNE CODE_019405           
ADDR_0193EF:        98            TYA                       
ADDR_0193F0:        38            SEC                       
ADDR_0193F1:        E9 0C         SBC.B #$0C                
ADDR_0193F3:        A8            TAY                       
ADDR_0193F4:        B5 E4         LDA RAM_SpriteXLo,X       
ADDR_0193F6:        18            CLC                       
ADDR_0193F7:        79 C5 92      ADC.W DATA_0192C5,Y       
ADDR_0193FA:        95 E4         STA RAM_SpriteXLo,X       
ADDR_0193FC:        BD E0 14      LDA.W RAM_SpriteXHi,X     
ADDR_0193FF:        79 C7 92      ADC.W DATA_0192C7,Y       
ADDR_019402:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_019405:        BD D0 15      LDA.W $15D0,X             
CODE_019408:        D0 0A         BNE CODE_019414           
CODE_01940A:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01940C:        29 F0         AND.B #$F0                
CODE_01940E:        18            CLC                       
CODE_01940F:        6D 94 16      ADC.W $1694               
CODE_019412:        95 D8         STA RAM_SpriteYLo,X       
CODE_019414:        20 35 94      JSR.W CODE_019435         
CODE_019417:        AD 5E 18      LDA.W $185E               
CODE_01941A:        F0 08         BEQ Return019424          
CODE_01941C:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_01941F:        09 80         ORA.B #$80                
CODE_019421:        9D 88 15      STA.W RAM_SprObjStatus,X  
Return019424:       60            RTS                       ; Return 

CODE_019425:        A5 0A         LDA $0A                   
CODE_019427:        85 9A         STA RAM_BlockYLo          
CODE_019429:        A5 0B         LDA $0B                   
CODE_01942B:        85 9B         STA RAM_BlockYHi          
CODE_01942D:        A5 0C         LDA $0C                   
CODE_01942F:        85 98         STA RAM_BlockXLo          
CODE_019431:        A5 0D         LDA $0D                   
CODE_019433:        85 99         STA RAM_BlockXHi          
CODE_019435:        A4 0F         LDY $0F                   
CODE_019437:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_01943A:        19 34 91      ORA.W DATA_019134,Y       
CODE_01943D:        9D 88 15      STA.W RAM_SprObjStatus,X  
Return019440:       60            RTS                       ; Return 

CODE_019441:        84 0F         STY $0F                   ; Can be 00-03 
CODE_019443:        BD 56 16      LDA.W RAM_Tweaker1656,X   ; \ Y = $1656,x (Upper 4 bits) + $0F (Lower 2 bits) 
CODE_019446:        29 0F         AND.B #$0F                ;  | 
CODE_019448:        0A            ASL                       ;  | 
CODE_019449:        0A            ASL                       ;  | 
CODE_01944A:        65 0F         ADC $0F                   ;  | 
CODE_01944C:        A8            TAY                       ; / 
CODE_01944D:        AD 5E 18      LDA.W $185E               
CODE_019450:        1A            INC A                     
CODE_019451:        25 5B         AND RAM_IsVerticalLvl     
CODE_019453:        F0 6A         BEQ CODE_0194BF           
CODE_019455:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_019457:        18            CLC                       
CODE_019458:        79 F7 90      ADC.W SpriteObjClippingY,Y 
CODE_01945B:        85 0C         STA $0C                   
CODE_01945D:        29 F0         AND.B #$F0                
CODE_01945F:        85 00         STA $00                   
CODE_019461:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_019464:        69 00         ADC.B #$00                
CODE_019466:        C5 5D         CMP RAM_ScreensInLvl      
CODE_019468:        B0 4A         BCS CODE_0194B4           
CODE_01946A:        85 0D         STA $0D                   
CODE_01946C:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01946E:        18            CLC                       
CODE_01946F:        79 BA 90      ADC.W SpriteObjClippingX,Y 
CODE_019472:        85 0A         STA $0A                   
CODE_019474:        85 01         STA $01                   
CODE_019476:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_019479:        69 00         ADC.B #$00                
CODE_01947B:        C9 02         CMP.B #$02                
CODE_01947D:        B0 35         BCS CODE_0194B4           
CODE_01947F:        85 0B         STA $0B                   
CODE_019481:        A5 01         LDA $01                   
CODE_019483:        4A            LSR                       
CODE_019484:        4A            LSR                       
CODE_019485:        4A            LSR                       
CODE_019486:        4A            LSR                       
CODE_019487:        05 00         ORA $00                   
CODE_019489:        85 00         STA $00                   
CODE_01948B:        A6 0D         LDX $0D                   
CODE_01948D:        BF 80 BA 00   LDA.L DATA_00BA80,X       
CODE_019491:        AC 5E 18      LDY.W $185E               
CODE_019494:        F0 04         BEQ CODE_01949A           
CODE_019496:        BF 8E BA 00   LDA.L DATA_00BA8E,X       
CODE_01949A:        18            CLC                       
CODE_01949B:        65 00         ADC $00                   
CODE_01949D:        85 05         STA $05                   
CODE_01949F:        BF BC BA 00   LDA.L DATA_00BABC,X       
CODE_0194A3:        AC 5E 18      LDY.W $185E               
CODE_0194A6:        F0 04         BEQ CODE_0194AC           
CODE_0194A8:        BF CA BA 00   LDA.L DATA_00BACA,X       
CODE_0194AC:        65 0B         ADC $0B                   
CODE_0194AE:        85 06         STA $06                   
CODE_0194B0:        20 23 95      JSR.W CODE_019523         
Return0194B3:       60            RTS                       ; Return 

CODE_0194B4:        A4 0F         LDY $0F                   
CODE_0194B6:        A9 00         LDA.B #$00                
CODE_0194B8:        8D 93 16      STA.W $1693               
CODE_0194BB:        8D 94 16      STA.W $1694               
Return0194BE:       60            RTS                       ; Return 

CODE_0194BF:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_0194C1:        18            CLC                       
CODE_0194C2:        79 F7 90      ADC.W SpriteObjClippingY,Y 
CODE_0194C5:        85 0C         STA $0C                   
CODE_0194C7:        29 F0         AND.B #$F0                
CODE_0194C9:        85 00         STA $00                   
CODE_0194CB:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_0194CE:        69 00         ADC.B #$00                
CODE_0194D0:        85 0D         STA $0D                   
CODE_0194D2:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_0194D4:        A5 0C         LDA $0C                   
CODE_0194D6:        C9 B0 01      CMP.W #$01B0              
CODE_0194D9:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_0194DB:        B0 D7         BCS CODE_0194B4           
CODE_0194DD:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_0194DF:        18            CLC                       
CODE_0194E0:        79 BA 90      ADC.W SpriteObjClippingX,Y 
CODE_0194E3:        85 0A         STA $0A                   
CODE_0194E5:        85 01         STA $01                   
CODE_0194E7:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_0194EA:        69 00         ADC.B #$00                
CODE_0194EC:        85 0B         STA $0B                   
CODE_0194EE:        30 C4         BMI CODE_0194B4           
CODE_0194F0:        C5 5D         CMP RAM_ScreensInLvl      
CODE_0194F2:        B0 C0         BCS CODE_0194B4           
CODE_0194F4:        A5 01         LDA $01                   
CODE_0194F6:        4A            LSR                       
CODE_0194F7:        4A            LSR                       
CODE_0194F8:        4A            LSR                       
CODE_0194F9:        4A            LSR                       
CODE_0194FA:        05 00         ORA $00                   
CODE_0194FC:        85 00         STA $00                   
CODE_0194FE:        A6 0B         LDX $0B                   
CODE_019500:        BF 60 BA 00   LDA.L DATA_00BA60,X       
CODE_019504:        AC 5E 18      LDY.W $185E               
CODE_019507:        F0 04         BEQ CODE_01950D           
CODE_019509:        BF 70 BA 00   LDA.L DATA_00BA70,X       
CODE_01950D:        18            CLC                       
CODE_01950E:        65 00         ADC $00                   
CODE_019510:        85 05         STA $05                   
CODE_019512:        BF 9C BA 00   LDA.L DATA_00BA9C,X       
CODE_019516:        AC 5E 18      LDY.W $185E               
CODE_019519:        F0 04         BEQ CODE_01951F           
CODE_01951B:        BF AC BA 00   LDA.L DATA_00BAAC,X       
CODE_01951F:        65 0D         ADC $0D                   
CODE_019521:        85 06         STA $06                   
CODE_019523:        A9 7E         LDA.B #$7E                
CODE_019525:        85 07         STA $07                   
CODE_019527:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01952A:        A7 05         LDA [$05]                 
CODE_01952C:        8D 93 16      STA.W $1693               
CODE_01952F:        E6 07         INC $07                   
CODE_019531:        A7 05         LDA [$05]                 
CODE_019533:        22 45 F5 00   JSL.L CODE_00F545         
CODE_019537:        A4 0F         LDY $0F                   
CODE_019539:        C9 00         CMP.B #$00                
Return01953B:       60            RTS                       ; Return 

HandleSprStunned:   B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if not Yoshi shell 
CODE_01953E:        C9 2C         CMP.B #$2C                ; / 
YoshiShellSts9:     D0 12         BNE CODE_019554           
CODE_019542:        B5 C2         LDA RAM_SpriteState,X     
CODE_019544:        F0 24         BEQ CODE_01956A           
CODE_019546:        A5 64         LDA $64                   ; \ Temporarily set $64 = #$10... 
CODE_019548:        48            PHA                       ;  | 
CODE_019549:        A9 10         LDA.B #$10                ;  | 
CODE_01954B:        85 64         STA $64                   ;  | 
CODE_01954D:        20 0D 9F      JSR.W SubSprGfx2Entry1    ;  | ...and call gfx routine 
CODE_019550:        68            PLA                       ;  | 
CODE_019551:        85 64         STA $64                   ; / 
Return019553:       60            RTS                       ; Return 

CODE_019554:        C9 2F         CMP.B #$2F                ; \ If Spring Board... 
CODE_019556:        F0 0A         BEQ SetNormalStatus       ;  | ...Unused Sprite 85... 
CODE_019558:        C9 85         CMP.B #$85                ;  | ...or Balloon, 
CODE_01955A:        F0 06         BEQ SetNormalStatus       ;  | Set Status = Normal... 
CODE_01955C:        C9 7D         CMP.B #$7D                ;  |  ...and jump to $01A187 
CODE_01955E:        D0 0A         BNE CODE_01956A           ;  | 
ADDR_019560:        74 AA         STZ RAM_SpriteSpeedY,X    ;  | Balloon Y Speed = 0 
SetNormalStatus:    A9 08         LDA.B #$08                ;  | 
CODE_019564:        9D C8 14      STA.W $14C8,X             ;  | 
CODE_019567:        4C 87 A1      JMP.W CODE_01A187         ; / 

CODE_01956A:        A5 9D         LDA RAM_SpritesLocked     ; \ If sprites locked, 
CODE_01956C:        F0 03         BEQ CODE_019571           ;  | jump to $0195F5 
CODE_01956E:        4C F5 95      JMP.W CODE_0195F5         ; / 

CODE_019571:        20 24 96      JSR.W CODE_019624         
CODE_019574:        20 32 90      JSR.W SubUpdateSprPos     
CODE_019577:        20 0E 80      JSR.W IsOnGround          
CODE_01957A:        F0 1C         BEQ CODE_019598           
CODE_01957C:        20 D5 97      JSR.W CODE_0197D5         
CODE_01957F:        B5 9E         LDA RAM_SpriteNum,X       
CODE_019581:        C9 16         CMP.B #$16                ; \ If Vertical or Horizontal Fish, 
CODE_019583:        F0 04         BEQ ADDR_019589           ;  | 
CODE_019585:        C9 15         CMP.B #$15                ;  | jump to $019562 
CODE_019587:        D0 03         BNE CODE_01958C           ;  | 
ADDR_019589:        4C 62 95      JMP.W SetNormalStatus     ; / 

CODE_01958C:        C9 2C         CMP.B #$2C                ; \ Branch if not Yoshi Egg 
CODE_01958E:        D0 08         BNE CODE_019598           ; / 
CODE_019590:        A9 F0         LDA.B #$F0                ; \ Set upward speed 
CODE_019592:        95 AA         STA RAM_SpriteSpeedY,X    ; / 
CODE_019594:        22 4C F7 01   JSL.L CODE_01F74C         
CODE_019598:        20 14 80      JSR.W IsTouchingCeiling   
CODE_01959B:        F0 3E         BEQ CODE_0195DB           
CODE_01959D:        A9 10         LDA.B #$10                ; \ Set downward speed 
CODE_01959F:        95 AA         STA RAM_SpriteSpeedY,X    ; / 
CODE_0195A1:        20 08 80      JSR.W IsTouchingObjSide   
CODE_0195A4:        D0 35         BNE CODE_0195DB           
CODE_0195A6:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $9A = Sprite X position + #$08 
CODE_0195A8:        18            CLC                       ;  | 
CODE_0195A9:        69 08         ADC.B #$08                ;  | 
CODE_0195AB:        85 9A         STA RAM_BlockYLo          ;  | 
CODE_0195AD:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_0195B0:        69 00         ADC.B #$00                ;  | 
CODE_0195B2:        85 9B         STA RAM_BlockYHi          ; / 
CODE_0195B4:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $9A = Sprite X position 
CODE_0195B6:        29 F0         AND.B #$F0                ;  | (Rounded down to nearest #$10) 
CODE_0195B8:        85 98         STA RAM_BlockXLo          ;  | 
CODE_0195BA:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_0195BD:        85 99         STA RAM_BlockXHi          ; / 
CODE_0195BF:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_0195C2:        29 20         AND.B #$20                
CODE_0195C4:        0A            ASL                       
CODE_0195C5:        0A            ASL                       
CODE_0195C6:        0A            ASL                       
CODE_0195C7:        2A            ROL                       
CODE_0195C8:        29 01         AND.B #$01                
CODE_0195CA:        8D 33 19      STA.W $1933               
CODE_0195CD:        A0 00         LDY.B #$00                
CODE_0195CF:        AD 68 18      LDA.W $1868               
CODE_0195D2:        22 60 F1 00   JSL.L CODE_00F160         
CODE_0195D6:        A9 08         LDA.B #$08                
CODE_0195D8:        9D E2 1F      STA.W $1FE2,X             
CODE_0195DB:        20 08 80      JSR.W IsTouchingObjSide   
CODE_0195DE:        F0 12         BEQ CODE_0195F2           
CODE_0195E0:        B5 9E         LDA RAM_SpriteNum,X       ; \ Call $0195E9 if sprite number < #$0D 
CODE_0195E2:        C9 0D         CMP.B #$0D                ;  | (Koopa Troopas) 
CODE_0195E4:        90 03         BCC CODE_0195E9           ;  | 
CODE_0195E6:        20 9E 99      JSR.W CODE_01999E         ; / 
CODE_0195E9:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_0195EB:        0A            ASL                       
CODE_0195EC:        08            PHP                       
CODE_0195ED:        76 B6         ROR RAM_SpriteSpeedX,X    
CODE_0195EF:        28            PLP                       
CODE_0195F0:        76 B6         ROR RAM_SpriteSpeedX,X    
CODE_0195F2:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  
CODE_0195F5:        20 87 A1      JSR.W CODE_01A187         
CODE_0195F8:        20 31 AC      JSR.W SubOffscreen0Bnk1   
Return0195FB:       60            RTS                       ; Return 


Unused0195FC:                     .db $00,$00,$00,$00,$04,$05,$06,$07
                                  .db $00,$00,$00,$00,$04,$05,$06,$07
                                  .db $00,$00,$00,$00,$04,$05,$06,$07
                                  .db $00,$00,$00,$00,$04,$05,$06,$07
SpriteKoopasSpawn:                .db $00,$00,$00,$00,$00,$01,$02,$03

CODE_019624:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch away if sprite isn't a Bob-omb 
CODE_019626:        C9 0D         CMP.B #$0D                ;  | 
CODE_019628:        D0 32         BNE CODE_01965C           ; / 
CODE_01962A:        BD 40 15      LDA.W $1540,X             ; \ Branch away if it's not time to explode 
CODE_01962D:        C9 01         CMP.B #$01                ;  | 
CODE_01962F:        D0 1D         BNE CODE_01964E           ; / 
CODE_019631:        A9 09         LDA.B #$09                ; \ Bomb sound effect 
CODE_019633:        8D FC 1D      STA.W $1DFC               ; / 
CODE_019636:        A9 01         LDA.B #$01                
CODE_019638:        9D 34 15      STA.W $1534,X             
CODE_01963B:        A9 40         LDA.B #$40                ; \ Set explosion timer 
CODE_01963D:        9D 40 15      STA.W $1540,X             ; / 
CODE_019640:        A9 08         LDA.B #$08                ; \ Set normal status 
CODE_019642:        9D C8 14      STA.W $14C8,X             ; / 
CODE_019645:        BD 86 16      LDA.W RAM_Tweaker1686,X   ; \ Set to interact with other sprites 
CODE_019648:        29 F7         AND.B #$F7                ;  | 
CODE_01964A:        9D 86 16      STA.W RAM_Tweaker1686,X   ; / 
Return01964D:       60            RTS                       ; Return 

CODE_01964E:        C9 40         CMP.B #$40                
CODE_019650:        B0 09         BCS Return01965B          
CODE_019652:        0A            ASL                       
CODE_019653:        29 0E         AND.B #$0E                
CODE_019655:        5D F6 15      EOR.W RAM_SpritePal,X     
CODE_019658:        9D F6 15      STA.W RAM_SpritePal,X     
Return01965B:       60            RTS                       ; Return 

CODE_01965C:        BD 40 15      LDA.W $1540,X             
CODE_01965F:        1D 58 15      ORA.W $1558,X             
CODE_019662:        95 C2         STA RAM_SpriteState,X     
CODE_019664:        BD 58 15      LDA.W $1558,X             
CODE_019667:        F0 33         BEQ CODE_01969C           
CODE_019669:        C9 01         CMP.B #$01                
CODE_01966B:        D0 2F         BNE CODE_01969C           
CODE_01966D:        BC 94 15      LDY.W $1594,X             
CODE_019670:        B9 D0 15      LDA.W $15D0,Y             
CODE_019673:        D0 27         BNE CODE_01969C           
CODE_019675:        22 8B F7 07   JSL.L LoadSpriteTables    
CODE_019679:        20 7C 85      JSR.W FaceMario           
CODE_01967C:        1E F6 15      ASL.W RAM_SpritePal,X     
CODE_01967F:        5E F6 15      LSR.W RAM_SpritePal,X     
CODE_019682:        BC 0E 16      LDY.W $160E,X             
CODE_019685:        A9 08         LDA.B #$08                
CODE_019687:        C0 03         CPY.B #$03                
CODE_019689:        D0 0D         BNE CODE_019698           
CODE_01968B:        FE 7B 18      INC.W $187B,X             
CODE_01968E:        BD 6E 16      LDA.W RAM_Tweaker166E,X   ; \ Disable fireball/cape killing 
CODE_019691:        09 30         ORA.B #$30                ;  | 
CODE_019693:        9D 6E 16      STA.W RAM_Tweaker166E,X   ; / 
CODE_019696:        A9 0A         LDA.B #$0A                ; \ Sprite status = Kicked 
CODE_019698:        9D C8 14      STA.W $14C8,X             ; / 
Return01969B:       60            RTS                       ; Return 

CODE_01969C:        BD 40 15      LDA.W $1540,X             ; \ Return if stun timer == 0 
CODE_01969F:        F0 FA         BEQ Return01969B          ; / 
CODE_0196A1:        C9 03         CMP.B #$03                ; \ If stun timer == 3, un-stun the sprite 
CODE_0196A3:        F0 04         BEQ UnstunSprite          ; / 
CODE_0196A5:        C9 01         CMP.B #$01                ; \ Every other frame, increment the stall timer 
CODE_0196A7:        D0 2E         BNE IncrmntStunTimer      ; /  to emulates a slower timer 
UnstunSprite:       B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if Buzzy Beetle 
CODE_0196AB:        C9 11         CMP.B #$11                ;  | 
CODE_0196AD:        F0 1C         BEQ SetNormalStatus       ; / 
CODE_0196AF:        C9 2E         CMP.B #$2E                ; \ Branch if Spike Top 
CODE_0196B1:        F0 18         BEQ SetNormalStatus       ; / 
CODE_0196B3:        C9 2D         CMP.B #$2D                ; \ Return if Baby Yoshi 
CODE_0196B5:        F0 13         BEQ Return0196CA          ; / 
CODE_0196B7:        C9 A2         CMP.B #$A2                ; \ Branch if MechaKoopa 
CODE_0196B9:        F0 10         BEQ SetNormalStatus       ; / 
CODE_0196BB:        C9 0F         CMP.B #$0F                ; \ Branch if Goomba 
CODE_0196BD:        F0 0C         BEQ SetNormalStatus       ; / 
CODE_0196BF:        C9 2C         CMP.B #$2C                ; \ Branch if Yoshi Egg 
CODE_0196C1:        F0 07         BEQ Return0196CA          ; / 
CODE_0196C3:        C9 53         CMP.B #$53                ; \ Branch if not Throw Block 
CODE_0196C5:        D0 1A         BNE GeneralResetSpr       ; / 
CODE_0196C7:        20 CB 9A      JSR.W CODE_019ACB         ; Set throw block to vanish 
Return0196CA:       60            RTS                       ; Return 

SetNormalStatus:    A9 08         LDA.B #$08                ; \ Sprite Status = Normal 
CODE_0196CD:        9D C8 14      STA.W $14C8,X             ; / 
CODE_0196D0:        1E F6 15      ASL.W RAM_SpritePal,X     ; \ Clear vertical flip bit 
CODE_0196D3:        5E F6 15      LSR.W RAM_SpritePal,X     ; / 
Return0196D6:       60            RTS                       ; Return 

IncrmntStunTimer:   A5 13         LDA RAM_FrameCounter      ; \ Increment timer every other frame 
CODE_0196D9:        29 01         AND.B #$01                ;  | 
CODE_0196DB:        D0 03         BNE Return0196E0          ;  | 
CODE_0196DD:        FE 40 15      INC.W $1540,X             ;  | 
Return0196E0:       60            RTS                       ; / 

GeneralResetSpr:    22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free sprite slot found 
CODE_0196E5:        30 E3         BMI Return0196CA          ; / 
CODE_0196E7:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_0196E9:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_0196EC:        B5 9E         LDA RAM_SpriteNum,X       ; \ Store sprite number for shelless koopa 
CODE_0196EE:        AA            TAX                       ;  | 
CODE_0196EF:        BD 1C 96      LDA.W SpriteKoopasSpawn,X ;  | 
CODE_0196F2:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
CODE_0196F5:        BB            TYX                       ; \ Reset sprite tables 
CODE_0196F6:        22 D2 F7 07   JSL.L InitSpriteTables    ;  | 
CODE_0196FA:        AE E9 15      LDX.W $15E9               ; / 
CODE_0196FD:        B5 E4         LDA RAM_SpriteXLo,X       ; \ Shelless Koopa position = Koopa position 
CODE_0196FF:        99 E4 00      STA.W RAM_SpriteXLo,Y     ;  | 
CODE_019702:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_019705:        99 E0 14      STA.W RAM_SpriteXHi,Y     ;  | 
CODE_019708:        B5 D8         LDA RAM_SpriteYLo,X       ;  | 
CODE_01970A:        99 D8 00      STA.W RAM_SpriteYLo,Y     ;  | 
CODE_01970D:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_019710:        99 D4 14      STA.W RAM_SpriteYHi,Y     ; / 
CODE_019713:        A9 00         LDA.B #$00                ; \ Direction = 0 
CODE_019715:        99 7C 15      STA.W RAM_SpriteDir,Y     ; / 
CODE_019718:        A9 10         LDA.B #$10                
CODE_01971A:        99 64 15      STA.W $1564,Y             
CODE_01971D:        BD 4A 16      LDA.W $164A,X             
CODE_019720:        99 4A 16      STA.W $164A,Y             
CODE_019723:        BD 40 15      LDA.W $1540,X             
CODE_019726:        9E 40 15      STZ.W $1540,X             
CODE_019729:        C9 01         CMP.B #$01                
CODE_01972B:        F0 1A         BEQ CODE_019747           
CODE_01972D:        A9 D0         LDA.B #$D0                ; \ Set upward speed 
CODE_01972F:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  ; / 
CODE_019732:        5A            PHY                       ; \ Make Shelless Koopa face away from Mario 
CODE_019733:        20 30 AD      JSR.W SubHorizPos         ;  | 
CODE_019736:        98            TYA                       ;  | 
CODE_019737:        49 01         EOR.B #$01                ;  | 
CODE_019739:        7A            PLY                       ;  | 
CODE_01973A:        99 7C 15      STA.W RAM_SpriteDir,Y     ; / 
CODE_01973D:        DA            PHX                       ; \ Set Shelless X speed 
CODE_01973E:        AA            TAX                       ;  | 
CODE_01973F:        BD EC 88      LDA.W Spr0to13SpeedX,X    ;  | 
CODE_019742:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  ;  | 
CODE_019745:        FA            PLX                       ; / 
Return019746:       60            RTS                       ; Return 

CODE_019747:        5A            PHY                       
CODE_019748:        20 30 AD      JSR.W SubHorizPos         
CODE_01974B:        B9 AD 97      LDA.W DATA_0197AD,Y       
CODE_01974E:        84 00         STY $00                   
CODE_019750:        7A            PLY                       
CODE_019751:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_019754:        A5 00         LDA $00                   
CODE_019756:        49 01         EOR.B #$01                
CODE_019758:        99 7C 15      STA.W RAM_SpriteDir,Y     
CODE_01975B:        85 01         STA $01                   
CODE_01975D:        A9 10         LDA.B #$10                
CODE_01975F:        99 4C 15      STA.W RAM_DisableInter,Y  
CODE_019762:        99 28 15      STA.W $1528,Y             
CODE_019765:        B5 9E         LDA RAM_SpriteNum,X       ; \ If Yellow Koopa... 
CODE_019767:        C9 07         CMP.B #$07                ;  | 
CODE_019769:        D0 0A         BNE Return019775          ;  | 
CODE_01976B:        A0 08         LDY.B #$08                ;  | ...find free sprite slot... 
CODE_01976D:        B9 C8 14      LDA.W $14C8,Y             ;  | 
CODE_019770:        F0 04         BEQ SpawnMovingCoin       ;  | ...and spawn moving coin 
CODE_019772:        88            DEY                       ;  | 
CODE_019773:        10 F8         BPL CODE_01976D           ; / 
Return019775:       60            RTS                       ; Return 

SpawnMovingCoin:    A9 08         LDA.B #$08                ; \ Sprite status = normal 
CODE_019778:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01977B:        A9 21         LDA.B #$21                ; \ Sprite = Moving Coin 
CODE_01977D:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
CODE_019780:        B5 E4         LDA RAM_SpriteXLo,X       ; \ Copy X position to coin 
CODE_019782:        99 E4 00      STA.W RAM_SpriteXLo,Y     ;  | 
CODE_019785:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_019788:        99 E0 14      STA.W RAM_SpriteXHi,Y     ; / 
CODE_01978B:        B5 D8         LDA RAM_SpriteYLo,X       ; \ Copy Y position to coin 
CODE_01978D:        99 D8 00      STA.W RAM_SpriteYLo,Y     ;  | 
CODE_019790:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_019793:        99 D4 14      STA.W RAM_SpriteYHi,Y     ; / 
CODE_019796:        DA            PHX                       ; \ 
CODE_019797:        BB            TYX                       ;  | 
CODE_019798:        22 D2 F7 07   JSL.L InitSpriteTables    ;  | Clear all sprite tables, and load new values 
CODE_01979C:        FA            PLX                       ; / 
CODE_01979D:        A9 D0         LDA.B #$D0                ; \ Set Y speed 
CODE_01979F:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  ; / 
CODE_0197A2:        A5 01         LDA $01                   ; \ Set direction 
CODE_0197A4:        99 7C 15      STA.W RAM_SpriteDir,Y     ; / 
CODE_0197A7:        A9 20         LDA.B #$20                
CODE_0197A9:        99 4C 15      STA.W RAM_DisableInter,Y  
Return0197AC:       60            RTS                       ; Return 


DATA_0197AD:                      .db $C0,$40

DATA_0197AF:                      .db $00,$00,$00,$F8,$F8,$F8,$F8,$F8
                                  .db $F8,$F7,$F6,$F5,$F4,$F3,$F2,$E8
                                  .db $E8,$E8,$E8,$00,$00,$00,$00,$FE
                                  .db $FC,$F8,$EC,$EC,$EC,$E8,$E4,$E0
                                  .db $DC,$D8,$D4,$D0,$CC,$C8

CODE_0197D5:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_0197D7:        08            PHP                       
CODE_0197D8:        10 03         BPL CODE_0197DD           
CODE_0197DA:        20 4A 80      JSR.W InvertAccum         
CODE_0197DD:        4A            LSR                       
CODE_0197DE:        28            PLP                       
CODE_0197DF:        10 03         BPL CODE_0197E4           
CODE_0197E1:        20 4A 80      JSR.W InvertAccum         
CODE_0197E4:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_0197E6:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_0197E8:        48            PHA                       
CODE_0197E9:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_0197EC:        68            PLA                       
CODE_0197ED:        4A            LSR                       
CODE_0197EE:        4A            LSR                       
CODE_0197EF:        A8            TAY                       
CODE_0197F0:        B5 9E         LDA RAM_SpriteNum,X       ; \ If Goomba, Y += #$13 
CODE_0197F2:        C9 0F         CMP.B #$0F                ;  | 
CODE_0197F4:        D0 05         BNE CODE_0197FB           ;  | 
CODE_0197F6:        98            TYA                       ;  | 
CODE_0197F7:        18            CLC                       ;  | 
CODE_0197F8:        69 13         ADC.B #$13                ;  | 
CODE_0197FA:        A8            TAY                       ; / 
CODE_0197FB:        B9 AF 97      LDA.W DATA_0197AF,Y       
CODE_0197FE:        BC 88 15      LDY.W RAM_SprObjStatus,X  
CODE_019801:        30 02         BMI Return019805          
CODE_019803:        95 AA         STA RAM_SpriteSpeedY,X    
Return019805:       60            RTS                       ; Return 

CODE_019806:        A9 06         LDA.B #$06                
CODE_019808:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01980B:        D0 02         BNE CODE_01980F           
CODE_01980D:        A9 08         LDA.B #$08                
CODE_01980F:        9D 02 16      STA.W $1602,X             
CODE_019812:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_019815:        48            PHA                       
CODE_019816:        F0 03         BEQ CODE_01981B           
CODE_019818:        18            CLC                       
CODE_019819:        69 08         ADC.B #$08                
CODE_01981B:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_01981E:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_019821:        68            PLA                       
CODE_019822:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_019825:        AD EB 1E      LDA.W $1EEB               
CODE_019828:        30 7C         BMI Return0198A6          
CODE_01982A:        BD 02 16      LDA.W $1602,X             
CODE_01982D:        C9 06         CMP.B #$06                
CODE_01982F:        D0 75         BNE Return0198A6          
CODE_019831:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_019834:        BD 58 15      LDA.W $1558,X             
CODE_019837:        D0 09         BNE CODE_019842           
CODE_019839:        BD 40 15      LDA.W $1540,X             
CODE_01983C:        F0 68         BEQ Return0198A6          
CODE_01983E:        C9 30         CMP.B #$30                
CODE_019840:        B0 0B         BCS CODE_01984D           
CODE_019842:        4A            LSR                       
CODE_019843:        B9 08 03      LDA.W OAM_Tile3DispX,Y    
CODE_019846:        69 00         ADC.B #$00                
CODE_019848:        B0 03         BCS CODE_01984D           
CODE_01984A:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_01984D:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch away if a Buzzy Beetle 
CODE_01984F:        C9 11         CMP.B #$11                ;  | 
CODE_019851:        F0 53         BEQ Return0198A6          ; / 
CODE_019853:        20 CB 80      JSR.W IsSprOffScreen      
CODE_019856:        D0 4E         BNE Return0198A6          
CODE_019858:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01985B:        0A            ASL                       
CODE_01985C:        A9 08         LDA.B #$08                
CODE_01985E:        90 02         BCC CODE_019862           
CODE_019860:        A9 00         LDA.B #$00                
CODE_019862:        85 00         STA $00                   
CODE_019864:        B9 08 03      LDA.W OAM_Tile3DispX,Y    
CODE_019867:        18            CLC                       
CODE_019868:        69 02         ADC.B #$02                
CODE_01986A:        99 00 03      STA.W OAM_DispX,Y         
CODE_01986D:        18            CLC                       
CODE_01986E:        69 04         ADC.B #$04                
CODE_019870:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_019873:        B9 09 03      LDA.W OAM_Tile3DispY,Y    
CODE_019876:        18            CLC                       
CODE_019877:        65 00         ADC $00                   
CODE_019879:        99 01 03      STA.W OAM_DispY,Y         
CODE_01987C:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_01987F:        5A            PHY                       
CODE_019880:        A0 64         LDY.B #$64                
CODE_019882:        A5 14         LDA RAM_FrameCounterB     
CODE_019884:        29 F8         AND.B #$F8                
CODE_019886:        D0 02         BNE CODE_01988A           
CODE_019888:        A0 4D         LDY.B #$4D                
CODE_01988A:        98            TYA                       
CODE_01988B:        7A            PLY                       
CODE_01988C:        99 02 03      STA.W OAM_Tile,Y          
CODE_01988F:        99 06 03      STA.W OAM_Tile2,Y         
CODE_019892:        A5 64         LDA $64                   
CODE_019894:        99 03 03      STA.W OAM_Prop,Y          
CODE_019897:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_01989A:        98            TYA                       
CODE_01989B:        4A            LSR                       
CODE_01989C:        4A            LSR                       
CODE_01989D:        A8            TAY                       
CODE_01989E:        A9 00         LDA.B #$00                
CODE_0198A0:        99 60 04      STA.W OAM_TileSize,Y      
CODE_0198A3:        99 61 04      STA.W $0461,Y             
Return0198A6:       60            RTS                       ; Return 


DATA_0198A7:                      .db $E0,$20

CODE_0198A9:        A5 9D         LDA RAM_SpritesLocked     
CODE_0198AB:        F0 03         BEQ CODE_0198B0           
CODE_0198AD:        4C 2A 9A      JMP.W CODE_019A2A         

CODE_0198B0:        20 32 90      JSR.W SubUpdateSprPos     
CODE_0198B3:        BD 1C 15      LDA.W $151C,X             
CODE_0198B6:        29 1F         AND.B #$1F                
CODE_0198B8:        D0 03         BNE CODE_0198BD           
CODE_0198BA:        20 7C 85      JSR.W FaceMario           
CODE_0198BD:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_0198BF:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_0198C2:        C0 00         CPY.B #$00                
CODE_0198C4:        D0 0A         BNE CODE_0198D0           
CODE_0198C6:        C9 20         CMP.B #$20                
CODE_0198C8:        10 0E         BPL CODE_0198D8           
CODE_0198CA:        F6 B6         INC RAM_SpriteSpeedX,X    
CODE_0198CC:        F6 B6         INC RAM_SpriteSpeedX,X    
CODE_0198CE:        80 08         BRA CODE_0198D8           

CODE_0198D0:        C9 E0         CMP.B #$E0                
CODE_0198D2:        30 04         BMI CODE_0198D8           
CODE_0198D4:        D6 B6         DEC RAM_SpriteSpeedX,X    
CODE_0198D6:        D6 B6         DEC RAM_SpriteSpeedX,X    
CODE_0198D8:        20 08 80      JSR.W IsTouchingObjSide   
CODE_0198DB:        F0 0D         BEQ CODE_0198EA           
CODE_0198DD:        48            PHA                       
CODE_0198DE:        20 9E 99      JSR.W CODE_01999E         
CODE_0198E1:        68            PLA                       
CODE_0198E2:        29 03         AND.B #$03                
CODE_0198E4:        A8            TAY                       
CODE_0198E5:        B9 A6 98      LDA.W Return0198A6,Y      
CODE_0198E8:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_0198EA:        20 0E 80      JSR.W IsOnGround          
CODE_0198ED:        F0 07         BEQ CODE_0198F6           
CODE_0198EF:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_0198F2:        A9 10         LDA.B #$10                
CODE_0198F4:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_0198F6:        20 14 80      JSR.W IsTouchingCeiling   
CODE_0198F9:        F0 02         BEQ CODE_0198FD           
ADDR_0198FB:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_0198FD:        A5 13         LDA RAM_FrameCounter      
CODE_0198FF:        29 01         AND.B #$01                
CODE_019901:        D0 0A         BNE CODE_01990D           
CODE_019903:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_019906:        1A            INC A                     
CODE_019907:        1A            INC A                     
CODE_019908:        29 CF         AND.B #$CF                
CODE_01990A:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01990D:        4C 8C 99      JMP.W CODE_01998C         


DATA_019910:                      .db $F0,$EE,$EC

HandleSprKicked:    BD 7B 18      LDA.W $187B,X             
CODE_019916:        F0 03         BEQ CODE_01991B           
CODE_019918:        4C A9 98      JMP.W CODE_0198A9         

CODE_01991B:        BD 7A 16      LDA.W RAM_Tweaker167A,X   
CODE_01991E:        29 10         AND.B #$10                
CODE_019920:        F0 06         BEQ CODE_019928           
CODE_019922:        20 0B AA      JSR.W CODE_01AA0B         
CODE_019925:        4C 87 A1      JMP.W CODE_01A187         

CODE_019928:        BD 28 15      LDA.W $1528,X             
CODE_01992B:        D0 0C         BNE CODE_019939           
CODE_01992D:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01992F:        18            CLC                       
CODE_019930:        69 20         ADC.B #$20                
CODE_019932:        C9 40         CMP.B #$40                
CODE_019934:        B0 03         BCS CODE_019939           
CODE_019936:        20 0B AA      JSR.W CODE_01AA0B         
CODE_019939:        9E 28 15      STZ.W $1528,X             
CODE_01993C:        A5 9D         LDA RAM_SpritesLocked     
CODE_01993E:        1D 3E 16      ORA.W $163E,X             
CODE_019941:        F0 03         BEQ CODE_019946           
CODE_019943:        4C 8F 99      JMP.W CODE_01998F         

CODE_019946:        20 15 9A      JSR.W UpdateDirection     
CODE_019949:        BD B8 15      LDA.W $15B8,X             
CODE_01994C:        48            PHA                       
CODE_01994D:        20 32 90      JSR.W SubUpdateSprPos     
CODE_019950:        68            PLA                       
CODE_019951:        F0 16         BEQ CODE_019969           
CODE_019953:        85 00         STA $00                   
CODE_019955:        BC 4A 16      LDY.W $164A,X             
CODE_019958:        D0 0F         BNE CODE_019969           
CODE_01995A:        DD B8 15      CMP.W $15B8,X             
CODE_01995D:        F0 0A         BEQ CODE_019969           
CODE_01995F:        55 B6         EOR RAM_SpriteSpeedX,X    
CODE_019961:        30 06         BMI CODE_019969           
CODE_019963:        A9 F8         LDA.B #$F8                ; \ Set upward speed 
CODE_019965:        95 AA         STA RAM_SpriteSpeedY,X    ; / 
CODE_019967:        80 0C         BRA CODE_019975           

CODE_019969:        20 0E 80      JSR.W IsOnGround          
CODE_01996C:        F0 16         BEQ CODE_019984           
CODE_01996E:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_019971:        A9 10         LDA.B #$10                ; \ Set downward speed 
CODE_019973:        95 AA         STA RAM_SpriteSpeedY,X    ; / 
CODE_019975:        AD 60 18      LDA.W $1860               
CODE_019978:        C9 B5         CMP.B #$B5                
CODE_01997A:        F0 04         BEQ CODE_019980           
CODE_01997C:        C9 B4         CMP.B #$B4                
CODE_01997E:        D0 04         BNE CODE_019984           
CODE_019980:        A9 B8         LDA.B #$B8                
CODE_019982:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_019984:        20 08 80      JSR.W IsTouchingObjSide   
CODE_019987:        F0 03         BEQ CODE_01998C           
CODE_019989:        20 9E 99      JSR.W CODE_01999E         
CODE_01998C:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  
CODE_01998F:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_019992:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if throw block sprite 
CODE_019994:        C9 53         CMP.B #$53                ;  | 
CODE_019996:        F0 03         BEQ CODE_01999B           ; / 
CODE_019998:        4C 2A 9A      JMP.W CODE_019A2A         

CODE_01999B:        4C D4 A1      JMP.W StunThrowBlock      

CODE_01999E:        A9 01         LDA.B #$01                
CODE_0199A0:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_0199A3:        20 A2 90      JSR.W CODE_0190A2         
CODE_0199A6:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_0199A9:        D0 27         BNE CODE_0199D2           
CODE_0199AB:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_0199AD:        38            SEC                       
CODE_0199AE:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_0199B0:        18            CLC                       
CODE_0199B1:        69 14         ADC.B #$14                
CODE_0199B3:        C9 1C         CMP.B #$1C                
CODE_0199B5:        90 1B         BCC CODE_0199D2           
CODE_0199B7:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_0199BA:        29 40         AND.B #$40                
CODE_0199BC:        0A            ASL                       
CODE_0199BD:        0A            ASL                       
CODE_0199BE:        2A            ROL                       
CODE_0199BF:        29 01         AND.B #$01                
CODE_0199C1:        8D 33 19      STA.W $1933               
CODE_0199C4:        A0 00         LDY.B #$00                
CODE_0199C6:        AD A7 18      LDA.W $18A7               
CODE_0199C9:        22 60 F1 00   JSL.L CODE_00F160         
CODE_0199CD:        A9 05         LDA.B #$05                
CODE_0199CF:        9D E2 1F      STA.W $1FE2,X             
CODE_0199D2:        B5 9E         LDA RAM_SpriteNum,X       ; \ If Throw Block, break it 
CODE_0199D4:        C9 53         CMP.B #$53                ;  | 
CODE_0199D6:        D0 03         BNE Return0199DB          ;  | 
CODE_0199D8:        20 DC 99      JSR.W BreakThrowBlock     ; / 
Return0199DB:       60            RTS                       ; Return 

BreakThrowBlock:    9E C8 14      STZ.W $14C8,X             ; Free up sprite slot 
CODE_0199DF:        A0 FF         LDY.B #$FF                ; Is this for the shatter routine?? 
CODE_0199E1:        20 CB 80      JSR.W IsSprOffScreen      ; \ Return if off screen 
CODE_0199E4:        D0 1D         BNE Return019A03          ; / 
CODE_0199E6:        B5 E4         LDA RAM_SpriteXLo,X       ; \ Store Y position in $9A-$9B 
CODE_0199E8:        85 9A         STA RAM_BlockYLo          ;  | 
CODE_0199EA:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_0199ED:        85 9B         STA RAM_BlockYHi          ; / 
CODE_0199EF:        B5 D8         LDA RAM_SpriteYLo,X       ; \ Store X position in $98-$99 
CODE_0199F1:        85 98         STA RAM_BlockXLo          ;  | 
CODE_0199F3:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_0199F6:        85 99         STA RAM_BlockXHi          ; / 
CODE_0199F8:        8B            PHB                       ; \ Shatter the brick 
CODE_0199F9:        A9 02         LDA.B #$02                ;  | 
CODE_0199FB:        48            PHA                       ;  | 
CODE_0199FC:        AB            PLB                       ;  | 
CODE_0199FD:        98            TYA                       ;  | 
CODE_0199FE:        22 63 86 02   JSL.L ShatterBlock        ;  | 
CODE_019A02:        AB            PLB                       ; / 
Return019A03:       60            RTS                       ; Return 

SetSomeYSpeed??:    BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_019A07:        30 07         BMI CODE_019A10           
CODE_019A09:        A9 00         LDA.B #$00                ; \ Sprite Y speed = #$00 or #$18 
CODE_019A0B:        BC B8 15      LDY.W $15B8,X             ;  | Depending on 15B8,x ??? 
CODE_019A0E:        F0 02         BEQ CODE_019A12           ;  | 
CODE_019A10:        A9 18         LDA.B #$18                ;  | 
CODE_019A12:        95 AA         STA RAM_SpriteSpeedY,X    ; / 
Return019A14:       60            RTS                       ; Return 

UpdateDirection:    A9 00         LDA.B #$00                ; \ Subroutine: Set direction from speed value 
CODE_019A17:        B4 B6         LDY RAM_SpriteSpeedX,X    ;  | 
CODE_019A19:        F0 06         BEQ Return019A21          ;  | 
CODE_019A1B:        10 01         BPL CODE_019A1E           ;  | 
CODE_019A1D:        1A            INC A                     ;  | 
CODE_019A1E:        9D 7C 15      STA.W RAM_SpriteDir,X     ;  | 
Return019A21:       60            RTS                       ; / 


ShellAniTiles:                    .db $06,$07,$08,$07

ShellGfxProp:                     .db $00,$00,$00,$40

CODE_019A2A:        B5 C2         LDA RAM_SpriteState,X     
CODE_019A2C:        9D 58 15      STA.W $1558,X             
CODE_019A2F:        A5 14         LDA RAM_FrameCounterB     
CODE_019A31:        4A            LSR                       
CODE_019A32:        4A            LSR                       
CODE_019A33:        29 03         AND.B #$03                
CODE_019A35:        A8            TAY                       
CODE_019A36:        5A            PHY                       
CODE_019A37:        B9 22 9A      LDA.W ShellAniTiles,Y     
CODE_019A3A:        20 0F 98      JSR.W CODE_01980F         
CODE_019A3D:        9E 58 15      STZ.W $1558,X             
CODE_019A40:        7A            PLY                       
CODE_019A41:        B9 26 9A      LDA.W ShellGfxProp,Y      
CODE_019A44:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_019A47:        59 0B 03      EOR.W OAM_Tile3Prop,Y     
CODE_019A4A:        99 0B 03      STA.W OAM_Tile3Prop,Y     
Return019A4D:       60            RTS                       ; Return 


SpinJumpSmokeTiles:               .db $64,$62,$60,$62

HandleSprSpinJump:  BD 40 15      LDA.W $1540,X             ; \ Erase sprite if time up 
CODE_019A55:        F0 20         BEQ SpinJumpEraseSpr      ; / 
CODE_019A57:        20 0D 9F      JSR.W SubSprGfx2Entry1    ; Call generic gfx routine 
CODE_019A5A:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_019A5D:        BD 40 15      LDA.W $1540,X             ; \ Load tile based on timer 
CODE_019A60:        4A            LSR                       ;  | 
CODE_019A61:        4A            LSR                       ;  | 
CODE_019A62:        4A            LSR                       ;  | 
CODE_019A63:        29 03         AND.B #$03                ;  | 
CODE_019A65:        DA            PHX                       ;  | 
CODE_019A66:        AA            TAX                       ;  | 
CODE_019A67:        BD 4E 9A      LDA.W SpinJumpSmokeTiles,X ;  | 
CODE_019A6A:        FA            PLX                       ;  / 
CODE_019A6B:        99 02 03      STA.W OAM_Tile,Y          ; Overwrite tile 
CODE_019A6E:        99 03 03      STA.W OAM_Prop,Y          ; \ Overwrite properties 
CODE_019A71:        29 30         AND.B #$30                ;  | 
CODE_019A73:        99 03 03      STA.W OAM_Prop,Y          ; / 
Return019A76:       60            RTS                       ; Return 

SpinJumpEraseSpr:   20 80 AC      JSR.W OffScrEraseSprite   ; Permanently kill the sprite 
Return019A7A:       60            RTS                       ; Return 

CODE_019A7B:        BD 58 15      LDA.W $1558,X             
CODE_019A7E:        F0 F7         BEQ SpinJumpEraseSpr      
CODE_019A80:        A9 04         LDA.B #$04                
CODE_019A82:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_019A84:        1E 0F 19      ASL.W RAM_Tweaker190F,X   
CODE_019A87:        5E 0F 19      LSR.W RAM_Tweaker190F,X   
CODE_019A8A:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_019A8C:        F0 0F         BEQ CODE_019A9D           
CODE_019A8E:        10 04         BPL CODE_019A94           
CODE_019A90:        F6 B6         INC RAM_SpriteSpeedX,X    
CODE_019A92:        80 09         BRA CODE_019A9D           

CODE_019A94:        D6 B6         DEC RAM_SpriteSpeedX,X    
CODE_019A96:        20 08 80      JSR.W IsTouchingObjSide   
CODE_019A99:        F0 02         BEQ CODE_019A9D           
CODE_019A9B:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_019A9D:        A9 01         LDA.B #$01                
CODE_019A9F:        9D 32 16      STA.W RAM_SprBehindScrn,X 
HandleSprKilled:    B5 9E         LDA RAM_SpriteNum,X       ; \ If Wiggler, call main sprite routine 
CODE_019AA4:        C9 86         CMP.B #$86                ;  | 
CODE_019AA6:        D0 03         BNE CODE_019AAB           ;  | 
CODE_019AA8:        4C C3 85      JMP.W CallSpriteMain      ; / 

CODE_019AAB:        C9 1E         CMP.B #$1E                ; \ If Lakitu, $18E0 = #$FF 
CODE_019AAD:        D0 05         BNE CODE_019AB4           ;  | 
CODE_019AAF:        A0 FF         LDY.B #$FF                ;  | 
CODE_019AB1:        8C E0 18      STY.W $18E0               ; / 
CODE_019AB4:        C9 53         CMP.B #$53                ; \ If Throw Block sprite... 
CODE_019AB6:        D0 04         BNE CODE_019ABC           ;  | 
CODE_019AB8:        20 DC 99      JSR.W BreakThrowBlock     ;  | ...break block... 
Return019ABB:       60            RTS                       ; / ...and return 

CODE_019ABC:        C9 4C         CMP.B #$4C                ; \ If Exploding Block Enemy 
CODE_019ABE:        D0 04         BNE CODE_019AC4           ;  | 
ADDR_019AC0:        22 63 E4 02   JSL.L CODE_02E463         ; / 
CODE_019AC4:        BD 56 16      LDA.W RAM_Tweaker1656,X   ; \ If "disappears in puff of smoke" is set... 
CODE_019AC7:        29 80         AND.B #$80                ;  | 
CODE_019AC9:        F0 0B         BEQ CODE_019AD6           ;  | 
CODE_019ACB:        A9 04         LDA.B #$04                ;  | ...Sprite status = Spin Jump Killed... 
CODE_019ACD:        9D C8 14      STA.W $14C8,X             ;  | 
CODE_019AD0:        A9 1F         LDA.B #$1F                ;  | ...Set Time to show smoke cloud... 
CODE_019AD2:        9D 40 15      STA.W $1540,X             ;  | 
Return019AD5:       60            RTS                       ; / ... and return 

CODE_019AD6:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_019AD8:        D0 03         BNE CODE_019ADD           ; / 
CODE_019ADA:        20 32 90      JSR.W SubUpdateSprPos     
CODE_019ADD:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_019AE0:        20 13 9B      JSR.W HandleSpriteDeath   
Return019AE3:       60            RTS                       ; Return 

HandleSprSmushed:   A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_019AE6:        D0 16         BNE CODE_019AFE           ; / 
CODE_019AE8:        BD 40 15      LDA.W $1540,X             ; \ Free sprite slot when timer runs out 
CODE_019AEB:        D0 04         BNE ShowSmushedGfx        ;  | 
CODE_019AED:        9E C8 14      STZ.W $14C8,X             ; / 
Return019AF0:       60            RTS                       ; Return 

ShowSmushedGfx:     20 32 90      JSR.W SubUpdateSprPos     
CODE_019AF4:        20 0E 80      JSR.W IsOnGround          
CODE_019AF7:        F0 05         BEQ CODE_019AFE           
CODE_019AF9:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_019AFC:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_019AFE:        B5 9E         LDA RAM_SpriteNum,X       ; \ If Dino Torch... 
CODE_019B00:        C9 6F         CMP.B #$6F                ;  | 
CODE_019B02:        D0 0C         BNE CODE_019B10           ;  | 
CODE_019B04:        20 0D 9F      JSR.W SubSprGfx2Entry1    ;  | ...call standard gfx routine... 
CODE_019B07:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ;  | 
CODE_019B0A:        A9 AC         LDA.B #$AC                ;  | ...and replace the tile with #$AC 
CODE_019B0C:        99 02 03      STA.W OAM_Tile,Y          ;  | 
Return019B0F:       60            RTS                       ; / Return 

CODE_019B10:        4C 00 E7      JMP.W SmushedGfxRt        ; Call smushed gfx routine 

HandleSpriteDeath:  BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ If the main routine handles the death state... 
CODE_019B16:        29 01         AND.B #$01                ;  | 
CODE_019B18:        F0 03         BEQ CODE_019B1D           ;  | 
CODE_019B1A:        4C C3 85      JMP.W CallSpriteMain      ; / ...jump to the main routine 

CODE_019B1D:        9E 02 16      STZ.W $1602,X             
CODE_019B20:        BD 0F 19      LDA.W RAM_Tweaker190F,X   ; \ Branch if "Death frame 2 tiles high" 
CODE_019B23:        29 20         AND.B #$20                ;  | is NOT set 
CODE_019B25:        F0 3D         BEQ CODE_019B64           ; / 
CODE_019B27:        BD 62 16      LDA.W RAM_Tweaker1662,X   ; \ Branch if "Use shell as death frame" 
CODE_019B2A:        29 40         AND.B #$40                ;  | is set 
CODE_019B2C:        D0 31         BNE CODE_019B5F           ; / 
CODE_019B2E:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if Lakitu 
CODE_019B30:        C9 1E         CMP.B #$1E                ;  | 
CODE_019B32:        F0 09         BEQ CODE_019B3D           ; / 
CODE_019B34:        C9 4B         CMP.B #$4B                ; \ If Pipe Lakitu, 
CODE_019B36:        D0 0C         BNE CODE_019B44           ;  | 
ADDR_019B38:        A9 01         LDA.B #$01                ;  | set behind scenery flag 
ADDR_019B3A:        9D 32 16      STA.W RAM_SprBehindScrn,X ; / 
CODE_019B3D:        A9 01         LDA.B #$01                
CODE_019B3F:        9D 02 16      STA.W $1602,X             
CODE_019B42:        80 08         BRA CODE_019B4C           

CODE_019B44:        BD F6 15      LDA.W RAM_SpritePal,X     ; \ Set to flip tiles vertically 
CODE_019B47:        09 80         ORA.B #$80                ;  | 
CODE_019B49:        9D F6 15      STA.W RAM_SpritePal,X     ; / 
CODE_019B4C:        A5 64         LDA $64                   ; \ If sprite is behind scenery, 
CODE_019B4E:        48            PHA                       ;  | 
CODE_019B4F:        BC 32 16      LDY.W RAM_SprBehindScrn,X ;  | 
CODE_019B52:        F0 02         BEQ CODE_019B56           ;  | 
CODE_019B54:        A9 10         LDA.B #$10                ;  | temorarily set layer priority for gfx routine 
CODE_019B56:        85 64         STA $64                   ;  | 
CODE_019B58:        20 67 9D      JSR.W SubSprGfx1          ;  | Draw sprite 
CODE_019B5B:        68            PLA                       ;  | 
CODE_019B5C:        85 64         STA $64                   ; / 
Return019B5E:       60            RTS                       ; Return 

CODE_019B5F:        A9 06         LDA.B #$06                
CODE_019B61:        9D 02 16      STA.W $1602,X             
CODE_019B64:        A9 00         LDA.B #$00                
CODE_019B66:        C0 1C         CPY.B #$1C                
CODE_019B68:        F0 02         BEQ CODE_019B6C           
CODE_019B6A:        A9 80         LDA.B #$80                
CODE_019B6C:        85 00         STA $00                   
CODE_019B6E:        A5 64         LDA $64                   ; \ If sprite is behind scenery, 
CODE_019B70:        48            PHA                       ;  | 
CODE_019B71:        BC 32 16      LDY.W RAM_SprBehindScrn,X ;  | 
CODE_019B74:        F0 02         BEQ CODE_019B78           ;  | 
CODE_019B76:        A9 10         LDA.B #$10                ;  | temorarily set layer priority for gfx routine 
CODE_019B78:        85 64         STA $64                   ;  | 
CODE_019B7A:        A5 00         LDA $00                   
CODE_019B7C:        20 09 9F      JSR.W SubSprGfx2Entry0    ;  | Draw sprite 
CODE_019B7F:        68            PLA                       ;  | 
CODE_019B80:        85 64         STA $64                   ; / 
Return019B82:       60            RTS                       ; Return 


SprTilemap:                       .db $82,$A0,$82,$A2,$84,$A4,$8C,$8A
                                  .db $8E,$C8,$CA,$CA,$CE,$CC,$86,$4E
                                  .db $E0,$E2,$E2,$CE,$E4,$E0,$E0,$A3
                                  .db $A3,$B3,$B3,$E9,$E8,$F9,$F8,$E8
                                  .db $E9,$F8,$F9,$E2,$E6,$AA,$A8,$A8
                                  .db $AA,$A2,$A2,$B2,$B2,$C3,$C2,$D3
                                  .db $D2,$C2,$C3,$D2,$D3,$E2,$E6,$CA
                                  .db $CC,$CA,$AC,$CE,$AE,$CE,$83,$83
                                  .db $C4,$C4,$83,$83,$C5,$C5,$8A,$A6
                                  .db $A4,$A6,$A8,$80,$82,$80,$84,$84
                                  .db $84,$84,$94,$94,$94,$94,$A0,$B0
                                  .db $A0,$D0,$82,$80,$82,$00,$00,$00
                                  .db $86,$84,$88,$EC,$8C,$A8,$AA,$8E
                                  .db $AC,$AE,$8E,$EC,$EE,$CE,$EE,$A8
                                  .db $EE,$40,$40,$A0,$C0,$A0,$C0,$A4
                                  .db $C4,$A4,$C4,$A0,$C0,$A0,$C0,$40
                                  .db $07,$27,$4C,$29,$4E,$2B,$82,$A0
                                  .db $84,$A4,$67,$69,$88,$CE,$8E,$AE
                                  .db $A2,$A2,$B2,$B2,$00,$40,$44,$42
                                  .db $2C,$42,$28,$28,$28,$28,$4C,$4C
                                  .db $4C,$4C,$83,$83,$6F,$6F,$AC,$BC
                                  .db $AC,$A6,$8C,$AA,$86,$84,$DC,$EC
                                  .db $DE,$EE,$06,$06,$16,$16,$07,$07
                                  .db $17,$17,$16,$16,$06,$06,$17,$17
                                  .db $07,$07,$84,$86,$00,$00,$00,$0E
                                  .db $2A,$24,$02,$06,$0A,$20,$22,$28
                                  .db $26,$2E,$40,$42,$0C,$04,$2B,$6A
                                  .db $ED,$88,$8C,$A8,$8E,$AA,$AE,$8C
                                  .db $88,$A8,$AE,$AC,$8C,$8E,$CE,$EE
                                  .db $C4,$C6,$82,$84,$86,$8C,$CE,$CE
                                  .db $88,$89,$CE,$CE,$89,$88,$F3,$CE
                                  .db $F3,$CE,$A7,$A9

SprTilemapOffset:                 .db $09,$09,$10,$09,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$37,$00,$25
                                  .db $25,$5A,$00,$4B,$4E,$8A,$8A,$8A
                                  .db $8A,$56,$3A,$46,$47,$69,$6B,$73
                                  .db $00,$00,$80,$80,$80,$80,$8E,$90
                                  .db $00,$00,$3A,$F6,$94,$95,$63,$9A
                                  .db $A6,$AA,$AE,$B2,$C2,$C4,$D5,$D9
                                  .db $D7,$D7,$E6,$E6,$E6,$E2,$99,$17
                                  .db $29,$E6,$E6,$E6,$00,$E8,$00,$8A
                                  .db $E8,$00,$ED,$EA,$7F,$EA,$EA,$3A
                                  .db $3A,$FA,$71,$7F

GeneralSprDispX:                  .db $00,$08,$00,$08

GeneralSprDispY:                  .db $00,$00,$08,$08

GeneralSprGfxProp:                .db $00,$00,$00,$00,$00,$40,$00,$40
                                  .db $00,$40,$80,$C0,$40,$40,$00,$00
                                  .db $40,$00,$C0,$80,$40,$40,$40,$40

SubSprGfx0Entry0:   A0 00         LDY.B #$00                
SubSprGfx0Entry1:   85 05         STA $05                   
CODE_019CF7:        84 0F         STY $0F                   
CODE_019CF9:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_019CFC:        A4 0F         LDY $0F                   
CODE_019CFE:        98            TYA                       
CODE_019CFF:        18            CLC                       
CODE_019D00:        65 01         ADC $01                   
CODE_019D02:        85 01         STA $01                   
CODE_019D04:        B4 9E         LDY RAM_SpriteNum,X       
CODE_019D06:        BD 02 16      LDA.W $1602,X             
CODE_019D09:        0A            ASL                       
CODE_019D0A:        0A            ASL                       
CODE_019D0B:        79 7F 9C      ADC.W SprTilemapOffset,Y  
CODE_019D0E:        85 02         STA $02                   
CODE_019D10:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_019D13:        05 64         ORA $64                   
CODE_019D15:        85 03         STA $03                   
CODE_019D17:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_019D1A:        A9 03         LDA.B #$03                
CODE_019D1C:        85 04         STA $04                   
CODE_019D1E:        DA            PHX                       
CODE_019D1F:        A6 04         LDX $04                   
CODE_019D21:        A5 00         LDA $00                   
CODE_019D23:        18            CLC                       
CODE_019D24:        7D D3 9C      ADC.W GeneralSprDispX,X   
CODE_019D27:        99 00 03      STA.W OAM_DispX,Y         
CODE_019D2A:        A5 01         LDA $01                   
CODE_019D2C:        18            CLC                       
CODE_019D2D:        7D D7 9C      ADC.W GeneralSprDispY,X   
CODE_019D30:        99 01 03      STA.W OAM_DispY,Y         
CODE_019D33:        A5 02         LDA $02                   
CODE_019D35:        18            CLC                       
CODE_019D36:        65 04         ADC $04                   
CODE_019D38:        AA            TAX                       
CODE_019D39:        BD 83 9B      LDA.W SprTilemap,X        
CODE_019D3C:        99 02 03      STA.W OAM_Tile,Y          
CODE_019D3F:        A5 05         LDA $05                   
CODE_019D41:        0A            ASL                       
CODE_019D42:        0A            ASL                       
CODE_019D43:        65 04         ADC $04                   
CODE_019D45:        AA            TAX                       
CODE_019D46:        BD DB 9C      LDA.W GeneralSprGfxProp,X 
CODE_019D49:        05 03         ORA $03                   
CODE_019D4B:        99 03 03      STA.W OAM_Prop,Y          
CODE_019D4E:        C8            INY                       
CODE_019D4F:        C8            INY                       
CODE_019D50:        C8            INY                       
CODE_019D51:        C8            INY                       
CODE_019D52:        C6 04         DEC $04                   
CODE_019D54:        10 C9         BPL CODE_019D1F           
CODE_019D56:        FA            PLX                       
CODE_019D57:        A9 03         LDA.B #$03                
CODE_019D59:        A0 00         LDY.B #$00                
CODE_019D5B:        20 BB B7      JSR.W FinishOAMWriteRt    
Return019D5E:       60            RTS                       ; Return 

GenericSprGfxRt1:   8B            PHB                       
CODE_019D60:        4B            PHK                       
CODE_019D61:        AB            PLB                       
CODE_019D62:        20 67 9D      JSR.W SubSprGfx1          
CODE_019D65:        AB            PLB                       
Return019D66:       6B            RTL                       ; Return 

SubSprGfx1:         BD F6 15      LDA.W RAM_SpritePal,X     
CODE_019D6A:        10 04         BPL SubSprGfx1Hlpr0       
CODE_019D6C:        20 D9 9D      JSR.W SubSprGfx1Hlpr1     
Return019D6F:       60            RTS                       ; Return 

SubSprGfx1Hlpr0:    20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_019D73:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_019D76:        85 02         STA $02                   
CODE_019D78:        98            TYA                       
CODE_019D79:        B4 9E         LDY RAM_SpriteNum,X       
CODE_019D7B:        C0 0F         CPY.B #$0F                
CODE_019D7D:        B0 02         BCS CODE_019D81           
CODE_019D7F:        69 04         ADC.B #$04                
CODE_019D81:        A8            TAY                       
CODE_019D82:        5A            PHY                       
CODE_019D83:        B4 9E         LDY RAM_SpriteNum,X       
CODE_019D85:        BD 02 16      LDA.W $1602,X             
CODE_019D88:        0A            ASL                       
CODE_019D89:        18            CLC                       
CODE_019D8A:        79 7F 9C      ADC.W SprTilemapOffset,Y  
CODE_019D8D:        AA            TAX                       
CODE_019D8E:        7A            PLY                       
CODE_019D8F:        BD 83 9B      LDA.W SprTilemap,X        
CODE_019D92:        99 02 03      STA.W OAM_Tile,Y          
CODE_019D95:        BD 84 9B      LDA.W SprTilemap+1,X      
CODE_019D98:        99 06 03      STA.W OAM_Tile2,Y         
CODE_019D9B:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_019D9E:        A5 01         LDA $01                   
CODE_019DA0:        99 01 03      STA.W OAM_DispY,Y         
CODE_019DA3:        18            CLC                       
CODE_019DA4:        69 10         ADC.B #$10                
CODE_019DA6:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_019DA9:        A5 00         LDA $00                   
CODE_019DAB:        99 00 03      STA.W OAM_DispX,Y         
CODE_019DAE:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_019DB1:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_019DB4:        4A            LSR                       
CODE_019DB5:        A9 00         LDA.B #$00                
CODE_019DB7:        1D F6 15      ORA.W RAM_SpritePal,X     
CODE_019DBA:        B0 02         BCS CODE_019DBE           
CODE_019DBC:        09 40         ORA.B #$40                
CODE_019DBE:        05 64         ORA $64                   
CODE_019DC0:        99 03 03      STA.W OAM_Prop,Y          
CODE_019DC3:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_019DC6:        98            TYA                       
CODE_019DC7:        4A            LSR                       
CODE_019DC8:        4A            LSR                       
CODE_019DC9:        A8            TAY                       
CODE_019DCA:        A9 02         LDA.B #$02                
CODE_019DCC:        1D A0 15      ORA.W RAM_OffscreenHorz,X 
CODE_019DCF:        99 60 04      STA.W OAM_TileSize,Y      
CODE_019DD2:        99 61 04      STA.W $0461,Y             
CODE_019DD5:        20 DF A3      JSR.W CODE_01A3DF         
Return019DD8:       60            RTS                       ; Return 

SubSprGfx1Hlpr1:    20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_019DDC:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_019DDF:        85 02         STA $02                   
CODE_019DE1:        98            TYA                       
CODE_019DE2:        18            CLC                       
CODE_019DE3:        69 08         ADC.B #$08                
CODE_019DE5:        A8            TAY                       
CODE_019DE6:        5A            PHY                       
CODE_019DE7:        B4 9E         LDY RAM_SpriteNum,X       
CODE_019DE9:        BD 02 16      LDA.W $1602,X             
CODE_019DEC:        0A            ASL                       
CODE_019DED:        18            CLC                       
CODE_019DEE:        79 7F 9C      ADC.W SprTilemapOffset,Y  
CODE_019DF1:        AA            TAX                       
CODE_019DF2:        7A            PLY                       
CODE_019DF3:        BD 83 9B      LDA.W SprTilemap,X        
CODE_019DF6:        99 06 03      STA.W OAM_Tile2,Y         
CODE_019DF9:        BD 84 9B      LDA.W SprTilemap+1,X      
CODE_019DFC:        99 02 03      STA.W OAM_Tile,Y          
CODE_019DFF:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_019E02:        A5 01         LDA $01                   
CODE_019E04:        99 01 03      STA.W OAM_DispY,Y         
CODE_019E07:        18            CLC                       
CODE_019E08:        69 10         ADC.B #$10                
CODE_019E0A:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_019E0D:        4C A9 9D      JMP.W CODE_019DA9         


KoopaWingDispXLo:                 .db $FF,$F7,$09,$09

KoopaWingDispXHi:                 .db $FF,$FF,$00,$00

KoopaWingDispY:                   .db $FC,$F4,$FC,$F4

KoopaWingTiles:                   .db $5D,$C6,$5D,$C6

KoopaWingGfxProp:                 .db $46,$46,$06,$06

KoopaWingTileSize:                .db $00,$02,$00,$02

KoopaWingGfxRt:     A0 00         LDY.B #$00                ; \ If not on ground, $02 = animation frame (00 or 01) 
CODE_019E2A:        20 0E 80      JSR.W IsOnGround          ;  | else, $02 = 0 
CODE_019E2D:        D0 06         BNE CODE_019E35           ;  | 
CODE_019E2F:        BD 02 16      LDA.W $1602,X             ;  | 
CODE_019E32:        29 01         AND.B #$01                ;  | 
CODE_019E34:        A8            TAY                       ;  | 
CODE_019E35:        84 02         STY $02                   ; / 
CODE_019E37:        BD 6C 18      LDA.W RAM_OffscreenVert,X ; \ Return if offscreen vertically 
CODE_019E3A:        D0 58         BNE Return019E94          ; / 
CODE_019E3C:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $00 = X position low 
CODE_019E3E:        85 00         STA $00                   ; / 
CODE_019E40:        BD E0 14      LDA.W RAM_SpriteXHi,X     ; \ $04 = X position high 
CODE_019E43:        85 04         STA $04                   ; / 
CODE_019E45:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $01 = Y position low 
CODE_019E47:        85 01         STA $01                   ; / 
CODE_019E49:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = index to OAM 
CODE_019E4C:        DA            PHX                       
CODE_019E4D:        BD 7C 15      LDA.W RAM_SpriteDir,X     ; \ X = index into tables 
CODE_019E50:        0A            ASL                       ;  | 
CODE_019E51:        65 02         ADC $02                   ;  | 
CODE_019E53:        AA            TAX                       ; / 
CODE_019E54:        A5 00         LDA $00                   ; \ Store X position (relative to screen) 
CODE_019E56:        18            CLC                       ;  | 
CODE_019E57:        7D 10 9E      ADC.W KoopaWingDispXLo,X  ;  | 
CODE_019E5A:        85 00         STA $00                   ;  | 
CODE_019E5C:        A5 04         LDA $04                   ;  | 
CODE_019E5E:        7D 14 9E      ADC.W KoopaWingDispXHi,X  ;  | 
CODE_019E61:        48            PHA                       ;  | 
CODE_019E62:        A5 00         LDA $00                   ;  | 
CODE_019E64:        38            SEC                       ;  | 
CODE_019E65:        E5 1A         SBC RAM_ScreenBndryXLo    ;  | 
CODE_019E67:        99 00 03      STA.W OAM_DispX,Y         ; / 
CODE_019E6A:        68            PLA                       ; \ Return if off screen horizontally 
CODE_019E6B:        E5 1B         SBC RAM_ScreenBndryXHi    ;  | 
CODE_019E6D:        D0 24         BNE CODE_019E93           ; / 
CODE_019E6F:        A5 01         LDA $01                   ; \ Store Y position (relative to screen) 
CODE_019E71:        38            SEC                       ;  | 
CODE_019E72:        E5 1C         SBC RAM_ScreenBndryYLo    ;  | 
CODE_019E74:        18            CLC                       ;  | 
CODE_019E75:        7D 18 9E      ADC.W KoopaWingDispY,X    ;  | 
CODE_019E78:        99 01 03      STA.W OAM_DispY,Y         ; / 
CODE_019E7B:        BD 1C 9E      LDA.W KoopaWingTiles,X    ; \ Store tile 
CODE_019E7E:        99 02 03      STA.W OAM_Tile,Y          ; / 
CODE_019E81:        A5 64         LDA $64                   ; \ Store tile properties 
CODE_019E83:        1D 20 9E      ORA.W KoopaWingGfxProp,X  ;  | 
CODE_019E86:        99 03 03      STA.W OAM_Prop,Y          ; / 
CODE_019E89:        98            TYA                       
CODE_019E8A:        4A            LSR                       
CODE_019E8B:        4A            LSR                       
CODE_019E8C:        A8            TAY                       
CODE_019E8D:        BD 24 9E      LDA.W KoopaWingTileSize,X ; \ Store tile size 
CODE_019E90:        99 60 04      STA.W OAM_TileSize,Y      ; / 
CODE_019E93:        FA            PLX                       
Return019E94:       60            RTS                       ; Return 

CODE_019E95:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_019E97:        48            PHA                       
CODE_019E98:        18            CLC                       
CODE_019E99:        69 02         ADC.B #$02                
CODE_019E9B:        95 D8         STA RAM_SpriteYLo,X       
CODE_019E9D:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_019EA0:        48            PHA                       
CODE_019EA1:        69 00         ADC.B #$00                
CODE_019EA3:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_019EA6:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_019EA8:        48            PHA                       
CODE_019EA9:        38            SEC                       
CODE_019EAA:        E9 02         SBC.B #$02                
CODE_019EAC:        95 E4         STA RAM_SpriteXLo,X       
CODE_019EAE:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_019EB1:        48            PHA                       
CODE_019EB2:        E9 00         SBC.B #$00                
CODE_019EB4:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_019EB7:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_019EBA:        48            PHA                       
CODE_019EBB:        18            CLC                       
CODE_019EBC:        69 04         ADC.B #$04                
CODE_019EBE:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_019EC1:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_019EC4:        48            PHA                       
CODE_019EC5:        9E 7C 15      STZ.W RAM_SpriteDir,X     
CODE_019EC8:        BD 70 15      LDA.W $1570,X             
CODE_019ECB:        4A            LSR                       
CODE_019ECC:        4A            LSR                       
CODE_019ECD:        4A            LSR                       
CODE_019ECE:        29 01         AND.B #$01                
CODE_019ED0:        A8            TAY                       
CODE_019ED1:        20 35 9E      JSR.W CODE_019E35         
CODE_019ED4:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_019ED6:        18            CLC                       
CODE_019ED7:        69 04         ADC.B #$04                
CODE_019ED9:        95 E4         STA RAM_SpriteXLo,X       
CODE_019EDB:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_019EDE:        69 00         ADC.B #$00                
CODE_019EE0:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_019EE3:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_019EE6:        18            CLC                       
CODE_019EE7:        69 04         ADC.B #$04                
CODE_019EE9:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_019EEC:        FE 7C 15      INC.W RAM_SpriteDir,X     
CODE_019EEF:        20 37 9E      JSR.W CODE_019E37         
CODE_019EF2:        68            PLA                       
CODE_019EF3:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_019EF6:        68            PLA                       
CODE_019EF7:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_019EFA:        68            PLA                       
CODE_019EFB:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_019EFE:        68            PLA                       
CODE_019EFF:        95 E4         STA RAM_SpriteXLo,X       
CODE_019F01:        68            PLA                       
CODE_019F02:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_019F05:        68            PLA                       
CODE_019F06:        95 D8         STA RAM_SpriteYLo,X       
Return019F08:       60            RTS                       ; Return 

SubSprGfx2Entry0:   85 04         STA $04                   
CODE_019F0B:        80 02         BRA CODE_019F0F           

SubSprGfx2Entry1:   64 04         STZ $04                   
CODE_019F0F:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_019F12:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_019F15:        85 02         STA $02                   
CODE_019F17:        B4 9E         LDY RAM_SpriteNum,X       
CODE_019F19:        BD 02 16      LDA.W $1602,X             
CODE_019F1C:        18            CLC                       
CODE_019F1D:        79 7F 9C      ADC.W SprTilemapOffset,Y  
CODE_019F20:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_019F23:        AA            TAX                       
CODE_019F24:        BD 83 9B      LDA.W SprTilemap,X        
CODE_019F27:        99 02 03      STA.W OAM_Tile,Y          
CODE_019F2A:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_019F2D:        A5 00         LDA $00                   
CODE_019F2F:        99 00 03      STA.W OAM_DispX,Y         
CODE_019F32:        A5 01         LDA $01                   
CODE_019F34:        99 01 03      STA.W OAM_DispY,Y         
CODE_019F37:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_019F3A:        4A            LSR                       
CODE_019F3B:        A9 00         LDA.B #$00                
CODE_019F3D:        1D F6 15      ORA.W RAM_SpritePal,X     
CODE_019F40:        B0 02         BCS CODE_019F44           
CODE_019F42:        49 40         EOR.B #$40                
CODE_019F44:        05 04         ORA $04                   
CODE_019F46:        05 64         ORA $64                   
CODE_019F48:        99 03 03      STA.W OAM_Prop,Y          
CODE_019F4B:        98            TYA                       
CODE_019F4C:        4A            LSR                       
CODE_019F4D:        4A            LSR                       
CODE_019F4E:        A8            TAY                       
CODE_019F4F:        A9 02         LDA.B #$02                
CODE_019F51:        1D A0 15      ORA.W RAM_OffscreenHorz,X 
CODE_019F54:        99 60 04      STA.W OAM_TileSize,Y      
CODE_019F57:        20 DF A3      JSR.W CODE_01A3DF         
Return019F5A:       60            RTS                       ; Return 


DATA_019F5B:                      .db $0B,$F5,$04,$FC,$04,$00

DATA_019F61:                      .db $00,$FF,$00,$FF,$00,$00

DATA_019F67:                      .db $F3,$0D

DATA_019F69:                      .db $FF,$00

ShellSpeedX:                      .db $D2,$2E,$CC,$34,$00,$10

HandleSprCarried:   20 9B 9F      JSR.W CODE_019F9B         
CODE_019F74:        AD DD 13      LDA.W RAM_ChangingDir     
CODE_019F77:        D0 0A         BNE CODE_019F83           
CODE_019F79:        AD 19 14      LDA.W RAM_YoshiInPipe     ; \ Branch if Yoshi going down pipe 
CODE_019F7C:        D0 05         BNE CODE_019F83           ; / 
CODE_019F7E:        AD 99 14      LDA.W RAM_FaceCamImgTimer ; \ Branch if Mario facing camera 
CODE_019F81:        F0 03         BEQ CODE_019F86           ; / 
CODE_019F83:        9E EA 15      STZ.W RAM_SprOAMIndex,X   
CODE_019F86:        A5 64         LDA $64                   
CODE_019F88:        48            PHA                       
CODE_019F89:        AD 19 14      LDA.W RAM_YoshiInPipe     
CODE_019F8C:        F0 04         BEQ CODE_019F92           
CODE_019F8E:        A9 10         LDA.B #$10                
CODE_019F90:        85 64         STA $64                   
CODE_019F92:        20 87 A1      JSR.W CODE_01A187         
CODE_019F95:        68            PLA                       
CODE_019F96:        85 64         STA $64                   
Return019F98:       60            RTS                       ; Return 


DATA_019F99:                      .db $FC,$04

CODE_019F9B:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if not Balloon 
CODE_019F9D:        C9 7D         CMP.B #$7D                ;  | 
CODE_019F9F:        D0 3F         BNE CODE_019FE0           ; / 
CODE_019FA1:        A5 13         LDA RAM_FrameCounter      
CODE_019FA3:        29 03         AND.B #$03                
CODE_019FA5:        D0 17         BNE CODE_019FBE           
CODE_019FA7:        CE 91 18      DEC.W $1891               
CODE_019FAA:        F0 18         BEQ CODE_019FC4           
CODE_019FAC:        AD 91 18      LDA.W $1891               
CODE_019FAF:        C9 30         CMP.B #$30                
CODE_019FB1:        B0 0B         BCS CODE_019FBE           
CODE_019FB3:        A0 01         LDY.B #$01                
CODE_019FB5:        29 04         AND.B #$04                
CODE_019FB7:        F0 02         BEQ CODE_019FBB           
CODE_019FB9:        A0 09         LDY.B #$09                
CODE_019FBB:        8C F3 13      STY.W $13F3               
CODE_019FBE:        A5 71         LDA RAM_MarioAnimation    ; \ Branch if no Mario animation sequence in progress 
CODE_019FC0:        C9 01         CMP.B #$01                ;  | 
CODE_019FC2:        90 06         BCC CODE_019FCA           ; / 
CODE_019FC4:        9C F3 13      STZ.W $13F3               
CODE_019FC7:        4C 80 AC      JMP.W OffScrEraseSprite   

CODE_019FCA:        8B            PHB                       
CODE_019FCB:        A9 02         LDA.B #$02                
CODE_019FCD:        48            PHA                       
CODE_019FCE:        AB            PLB                       
CODE_019FCF:        22 14 D2 02   JSL.L CODE_02D214         
CODE_019FD3:        AB            PLB                       
CODE_019FD4:        20 B1 A0      JSR.W CODE_01A0B1         
CODE_019FD7:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_019FDA:        A9 F0         LDA.B #$F0                
CODE_019FDC:        99 01 03      STA.W OAM_DispY,Y         
Return019FDF:       60            RTS                       ; Return 

CODE_019FE0:        20 40 91      JSR.W CODE_019140         
CODE_019FE3:        A5 71         LDA RAM_MarioAnimation    ; \ Branch if no Mario animation sequence in progress 
CODE_019FE5:        C9 01         CMP.B #$01                ;  | 
CODE_019FE7:        90 0B         BCC CODE_019FF4           ; / 
CODE_019FE9:        AD 19 14      LDA.W RAM_YoshiInPipe     ; \ Branch if in pipe 
CODE_019FEC:        D0 06         BNE CODE_019FF4           ; / 
CODE_019FEE:        A9 09         LDA.B #$09                ; \ Sprite status = Stunned 
CODE_019FF0:        9D C8 14      STA.W $14C8,X             ; / 
Return019FF3:       60            RTS                       ; Return 

CODE_019FF4:        BD C8 14      LDA.W $14C8,X             ; \ Return if sprite status == Normal 
CODE_019FF7:        C9 08         CMP.B #$08                ;  | 
CODE_019FF9:        F0 19         BEQ Return01A014          ; / 
CODE_019FFB:        A5 9D         LDA RAM_SpritesLocked     ; \ Jump if sprites locked 
CODE_019FFD:        F0 03         BEQ CODE_01A002           ;  | 
CODE_019FFF:        4C B1 A0      JMP.W CODE_01A0B1         ; / 

CODE_01A002:        20 24 96      JSR.W CODE_019624         
CODE_01A005:        20 0D A4      JSR.W SubSprSprInteract   
CODE_01A008:        AD 19 14      LDA.W RAM_YoshiInPipe     
CODE_01A00B:        D0 04         BNE CODE_01A011           
CODE_01A00D:        24 15         BIT RAM_ControllerA       
CODE_01A00F:        50 04         BVC CODE_01A015           
CODE_01A011:        20 B1 A0      JSR.W CODE_01A0B1         
Return01A014:       60            RTS                       ; Return 

CODE_01A015:        9E 26 16      STZ.W $1626,X             
CODE_01A018:        A0 00         LDY.B #$00                
CODE_01A01A:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if not Goomba 
CODE_01A01C:        C9 0F         CMP.B #$0F                ;  | 
CODE_01A01E:        D0 06         BNE CODE_01A026           ; / 
CODE_01A020:        A5 72         LDA RAM_IsFlying          
CODE_01A022:        D0 02         BNE CODE_01A026           
CODE_01A024:        A0 EC         LDY.B #$EC                
CODE_01A026:        94 AA         STY RAM_SpriteSpeedY,X    
CODE_01A028:        A9 09         LDA.B #$09                ; \ Sprite status = Carryable 
CODE_01A02A:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01A02D:        A5 15         LDA RAM_ControllerA       
CODE_01A02F:        29 08         AND.B #$08                
CODE_01A031:        D0 35         BNE CODE_01A068           
CODE_01A033:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if sprite >= #$15 
CODE_01A035:        C9 15         CMP.B #$15                ;  | 
CODE_01A037:        B0 08         BCS CODE_01A041           ; / 
CODE_01A039:        A5 15         LDA RAM_ControllerA       
CODE_01A03B:        29 04         AND.B #$04                
CODE_01A03D:        F0 3A         BEQ CODE_01A079           
CODE_01A03F:        80 06         BRA CODE_01A047           

CODE_01A041:        A5 15         LDA RAM_ControllerA       
CODE_01A043:        29 03         AND.B #$03                
CODE_01A045:        D0 32         BNE CODE_01A079           
CODE_01A047:        A4 76         LDY RAM_MarioDirection    
CODE_01A049:        A5 D1         LDA $D1                   
CODE_01A04B:        18            CLC                       
CODE_01A04C:        79 67 9F      ADC.W DATA_019F67,Y       
CODE_01A04F:        95 E4         STA RAM_SpriteXLo,X       
CODE_01A051:        A5 D2         LDA $D2                   
CODE_01A053:        79 69 9F      ADC.W DATA_019F69,Y       
CODE_01A056:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01A059:        20 30 AD      JSR.W SubHorizPos         
CODE_01A05C:        B9 99 9F      LDA.W DATA_019F99,Y       
CODE_01A05F:        18            CLC                       
CODE_01A060:        65 7B         ADC RAM_MarioSpeedX       
CODE_01A062:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01A064:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_01A066:        80 3E         BRA CODE_01A0A6           

CODE_01A068:        22 6F AB 01   JSL.L CODE_01AB6F         
CODE_01A06C:        A9 90         LDA.B #$90                
CODE_01A06E:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01A070:        A5 7B         LDA RAM_MarioSpeedX       
CODE_01A072:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01A074:        0A            ASL                       
CODE_01A075:        76 B6         ROR RAM_SpriteSpeedX,X    
CODE_01A077:        80 2D         BRA CODE_01A0A6           

CODE_01A079:        22 6F AB 01   JSL.L CODE_01AB6F         
CODE_01A07D:        BD 40 15      LDA.W $1540,X             
CODE_01A080:        95 C2         STA RAM_SpriteState,X     
CODE_01A082:        A9 0A         LDA.B #$0A                ; \ Sprite status = Kicked 
CODE_01A084:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01A087:        A4 76         LDY RAM_MarioDirection    
CODE_01A089:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01A08C:        F0 02         BEQ CODE_01A090           
ADDR_01A08E:        C8            INY                       
ADDR_01A08F:        C8            INY                       
CODE_01A090:        B9 6B 9F      LDA.W ShellSpeedX,Y       
CODE_01A093:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01A095:        45 7B         EOR RAM_MarioSpeedX       
CODE_01A097:        30 0D         BMI CODE_01A0A6           
CODE_01A099:        A5 7B         LDA RAM_MarioSpeedX       
CODE_01A09B:        85 00         STA $00                   
CODE_01A09D:        06 00         ASL $00                   
CODE_01A09F:        6A            ROR                       
CODE_01A0A0:        18            CLC                       
CODE_01A0A1:        79 6B 9F      ADC.W ShellSpeedX,Y       
CODE_01A0A4:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01A0A6:        A9 10         LDA.B #$10                
CODE_01A0A8:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_01A0AB:        A9 0C         LDA.B #$0C                
CODE_01A0AD:        8D 9A 14      STA.W RAM_KickImgTimer    
Return01A0B0:       60            RTS                       ; Return 

CODE_01A0B1:        A0 00         LDY.B #$00                
CODE_01A0B3:        A5 76         LDA RAM_MarioDirection    ; \ Y = Mario's direction 
CODE_01A0B5:        D0 01         BNE CODE_01A0B8           ;  | 
CODE_01A0B7:        C8            INY                       ; / 
CODE_01A0B8:        AD 99 14      LDA.W RAM_FaceCamImgTimer 
CODE_01A0BB:        F0 07         BEQ CODE_01A0C4           
CODE_01A0BD:        C8            INY                       
CODE_01A0BE:        C8            INY                       
CODE_01A0BF:        C9 05         CMP.B #$05                
CODE_01A0C1:        90 01         BCC CODE_01A0C4           
CODE_01A0C3:        C8            INY                       
CODE_01A0C4:        AD 19 14      LDA.W RAM_YoshiInPipe     
CODE_01A0C7:        F0 04         BEQ CODE_01A0CD           
CODE_01A0C9:        C9 02         CMP.B #$02                
CODE_01A0CB:        F0 07         BEQ CODE_01A0D4           
CODE_01A0CD:        AD DD 13      LDA.W RAM_ChangingDir     
CODE_01A0D0:        05 74         ORA RAM_IsClimbing        
CODE_01A0D2:        F0 02         BEQ CODE_01A0D6           
CODE_01A0D4:        A0 05         LDY.B #$05                
CODE_01A0D6:        5A            PHY                       
CODE_01A0D7:        A0 00         LDY.B #$00                
CODE_01A0D9:        AD 71 14      LDA.W $1471               
CODE_01A0DC:        C9 03         CMP.B #$03                
CODE_01A0DE:        F0 02         BEQ CODE_01A0E2           
CODE_01A0E0:        A0 3D         LDY.B #$3D                
CODE_01A0E2:        B9 94 00      LDA.W RAM_MarioXPos,Y     ; \ $00 = Mario's X position 
CODE_01A0E5:        85 00         STA $00                   ;  | 
CODE_01A0E7:        B9 95 00      LDA.W RAM_MarioXPosHi,Y   ;  | 
CODE_01A0EA:        85 01         STA $01                   ; / 
CODE_01A0EC:        B9 96 00      LDA.W RAM_MarioYPos,Y     ; \ $02 = Mario's Y position 
CODE_01A0EF:        85 02         STA $02                   ;  | 
CODE_01A0F1:        B9 97 00      LDA.W RAM_MarioYPosHi,Y   ;  | 
CODE_01A0F4:        85 03         STA $03                   ; / 
CODE_01A0F6:        7A            PLY                       
CODE_01A0F7:        A5 00         LDA $00                   
CODE_01A0F9:        18            CLC                       
CODE_01A0FA:        79 5B 9F      ADC.W DATA_019F5B,Y       
CODE_01A0FD:        95 E4         STA RAM_SpriteXLo,X       
CODE_01A0FF:        A5 01         LDA $01                   
CODE_01A101:        79 61 9F      ADC.W DATA_019F61,Y       
CODE_01A104:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01A107:        A9 0D         LDA.B #$0D                
CODE_01A109:        A4 73         LDY RAM_IsDucking         ; \ Branch if ducking 
CODE_01A10B:        D0 04         BNE CODE_01A111           ; / 
CODE_01A10D:        A4 19         LDY RAM_MarioPowerUp      ; \ Branch if Mario isn't small 
CODE_01A10F:        D0 02         BNE CODE_01A113           ; / 
CODE_01A111:        A9 0F         LDA.B #$0F                
CODE_01A113:        AC 98 14      LDY.W RAM_PickUpImgTimer  
CODE_01A116:        F0 02         BEQ CODE_01A11A           
CODE_01A118:        A9 0F         LDA.B #$0F                
CODE_01A11A:        18            CLC                       
CODE_01A11B:        65 02         ADC $02                   
CODE_01A11D:        95 D8         STA RAM_SpriteYLo,X       
CODE_01A11F:        A5 03         LDA $03                   
CODE_01A121:        69 00         ADC.B #$00                
CODE_01A123:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01A126:        A9 01         LDA.B #$01                
CODE_01A128:        8D 8F 14      STA.W $148F               
CODE_01A12B:        8D 70 14      STA.W $1470               ; Set carrying enemy flag 
Return01A12E:       60            RTS                       ; Return 

StunGoomba:         A5 14         LDA RAM_FrameCounterB     
CODE_01A131:        4A            LSR                       
CODE_01A132:        4A            LSR                       
CODE_01A133:        BC 40 15      LDY.W $1540,X             
CODE_01A136:        C0 30         CPY.B #$30                
CODE_01A138:        90 01         BCC CODE_01A13B           
CODE_01A13A:        4A            LSR                       
CODE_01A13B:        29 01         AND.B #$01                
CODE_01A13D:        9D 02 16      STA.W $1602,X             
CODE_01A140:        C0 08         CPY.B #$08                
CODE_01A142:        D0 09         BNE CODE_01A14D           
ADDR_01A144:        20 0E 80      JSR.W IsOnGround          
ADDR_01A147:        F0 04         BEQ CODE_01A14D           
ADDR_01A149:        A9 D8         LDA.B #$D8                
ADDR_01A14B:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01A14D:        A9 80         LDA.B #$80                
CODE_01A14F:        4C 09 9F      JMP.W SubSprGfx2Entry0    

StunMechaKoopa:     A5 1A         LDA RAM_ScreenBndryXLo    
CODE_01A154:        48            PHA                       
CODE_01A155:        BD 40 15      LDA.W $1540,X             
CODE_01A158:        C9 30         CMP.B #$30                
CODE_01A15A:        B0 06         BCS CODE_01A162           
CODE_01A15C:        29 01         AND.B #$01                
CODE_01A15E:        45 1A         EOR RAM_ScreenBndryXLo    
CODE_01A160:        85 1A         STA RAM_ScreenBndryXLo    
CODE_01A162:        22 07 B3 03   JSL.L CODE_03B307         
CODE_01A166:        68            PLA                       
CODE_01A167:        85 1A         STA RAM_ScreenBndryXLo    
CODE_01A169:        BD C8 14      LDA.W $14C8,X             ; \ If sprite status == Carried, 
CODE_01A16C:        C9 0B         CMP.B #$0B                ;  | 
CODE_01A16E:        D0 07         BNE Return01A177          ;  | 
CODE_01A170:        A5 76         LDA RAM_MarioDirection    ;  | Sprite direction = Opposite direction of Mario 
CODE_01A172:        49 01         EOR.B #$01                ;  | 
CODE_01A174:        9D 7C 15      STA.W RAM_SpriteDir,X     ; / 
Return01A177:       60            RTS                       ; Return 

StunFish:           20 5F 8E      JSR.W SetAnimationFrame   
ADDR_01A17B:        BD F6 15      LDA.W RAM_SpritePal,X     
ADDR_01A17E:        09 80         ORA.B #$80                
ADDR_01A180:        9D F6 15      STA.W RAM_SpritePal,X     
ADDR_01A183:        20 0D 9F      JSR.W SubSprGfx2Entry1    
Return01A186:       60            RTS                       ; Return 

CODE_01A187:        BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ Branch if sprite changes into a shell 
CODE_01A18A:        29 08         AND.B #$08                ;  | 
CODE_01A18C:        F0 42         BEQ CODE_01A1D0           ; / 
CODE_01A18E:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01A190:        C9 A2         CMP.B #$A2                
CODE_01A192:        F0 BE         BEQ StunMechaKoopa        
CODE_01A194:        C9 15         CMP.B #$15                
CODE_01A196:        F0 E0         BEQ StunFish              
CODE_01A198:        C9 16         CMP.B #$16                
CODE_01A19A:        F0 DC         BEQ StunFish              
CODE_01A19C:        C9 0F         CMP.B #$0F                
CODE_01A19E:        F0 8F         BEQ StunGoomba            
CODE_01A1A0:        C9 53         CMP.B #$53                
CODE_01A1A2:        F0 30         BEQ StunThrowBlock        
CODE_01A1A4:        C9 2C         CMP.B #$2C                
CODE_01A1A6:        F0 40         BEQ StunYoshiEgg          
CODE_01A1A8:        C9 80         CMP.B #$80                
CODE_01A1AA:        F0 47         BEQ StunKey               
CODE_01A1AC:        C9 7D         CMP.B #$7D                
CODE_01A1AE:        F0 23         BEQ Return01A1D3          
CODE_01A1B0:        C9 3E         CMP.B #$3E                
CODE_01A1B2:        F0 49         BEQ StunPow               
CODE_01A1B4:        C9 2F         CMP.B #$2F                
CODE_01A1B6:        F0 71         BEQ StunSpringBoard       
CODE_01A1B8:        C9 0D         CMP.B #$0D                
CODE_01A1BA:        F0 30         BEQ StunBomb              
CODE_01A1BC:        C9 2D         CMP.B #$2D                
CODE_01A1BE:        F0 6C         BEQ StunBabyYoshi         
ADDR_01A1C0:        C9 85         CMP.B #$85                
ADDR_01A1C2:        D0 0C         BNE CODE_01A1D0           
ADDR_01A1C4:        20 0D 9F      JSR.W SubSprGfx2Entry1    ; \ Handle unused sprite 85 
ADDR_01A1C7:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ;  | 
ADDR_01A1CA:        A9 47         LDA.B #$47                ;  | Set OAM with tile #$47 
ADDR_01A1CC:        99 02 03      STA.W OAM_Tile,Y          ; / 
Return01A1CF:       60            RTS                       ; Return 

CODE_01A1D0:        20 06 98      JSR.W CODE_019806         
Return01A1D3:       60            RTS                       ; Return 

StunThrowBlock:     BD 40 15      LDA.W $1540,X             
CODE_01A1D7:        C9 40         CMP.B #$40                
CODE_01A1D9:        B0 03         BCS CODE_01A1DE           
CODE_01A1DB:        4A            LSR                       
CODE_01A1DC:        B0 0A         BCS StunYoshiEgg          
CODE_01A1DE:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01A1E1:        1A            INC A                     
CODE_01A1E2:        1A            INC A                     
CODE_01A1E3:        29 0F         AND.B #$0F                
CODE_01A1E5:        9D F6 15      STA.W RAM_SpritePal,X     
StunYoshiEgg:       20 0D 9F      JSR.W SubSprGfx2Entry1    
Return01A1EB:       60            RTS                       ; Return 

StunBomb:           20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01A1EF:        A9 CA         LDA.B #$CA                
CODE_01A1F1:        80 2F         BRA CODE_01A222           

StunKey:            20 69 A1      JSR.W CODE_01A169         
CODE_01A1F6:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01A1F9:        A9 EC         LDA.B #$EC                
CODE_01A1FB:        80 25         BRA CODE_01A222           

StunPow:            BC 3E 16      LDY.W $163E,X             
CODE_01A200:        F0 16         BEQ CODE_01A218           
CODE_01A202:        C0 01         CPY.B #$01                
CODE_01A204:        D0 03         BNE CODE_01A209           
CODE_01A206:        4C CB 9A      JMP.W CODE_019ACB         

CODE_01A209:        20 00 E7      JSR.W SmushedGfxRt        
CODE_01A20C:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01A20F:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_01A212:        29 FE         AND.B #$FE                
CODE_01A214:        99 03 03      STA.W OAM_Prop,Y          
Return01A217:       60            RTS                       ; Return 

CODE_01A218:        A9 01         LDA.B #$01                
CODE_01A21A:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01A21D:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01A220:        A9 42         LDA.B #$42                
CODE_01A222:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01A225:        99 02 03      STA.W OAM_Tile,Y          
Return01A228:       60            RTS                       ; Return 

StunSpringBoard:    4C F0 E6      JMP.W CODE_01E6F0         

StunBabyYoshi:      A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01A22E:        D0 4B         BNE CODE_01A27B           ; / 
CODE_01A230:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01A232:        18            CLC                       
CODE_01A233:        69 08         ADC.B #$08                
CODE_01A235:        85 00         STA $00                   
CODE_01A237:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01A23A:        69 00         ADC.B #$00                
CODE_01A23C:        85 08         STA $08                   
CODE_01A23E:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01A240:        18            CLC                       
CODE_01A241:        69 08         ADC.B #$08                
CODE_01A243:        85 01         STA $01                   
CODE_01A245:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01A248:        69 00         ADC.B #$00                
CODE_01A24A:        85 09         STA $09                   
CODE_01A24C:        22 FA B9 02   JSL.L CODE_02B9FA         
CODE_01A250:        22 4E EA 02   JSL.L CODE_02EA4E         
CODE_01A254:        BD 3E 16      LDA.W $163E,X             
CODE_01A257:        D0 25         BNE CODE_01A27E           
CODE_01A259:        3A            DEC A                     
CODE_01A25A:        9D 0E 16      STA.W $160E,X             
CODE_01A25D:        BD C8 14      LDA.W $14C8,X             ; \ Branch if sprite status != Stunned 
CODE_01A260:        C9 09         CMP.B #$09                ;  | 
CODE_01A262:        D0 09         BNE CODE_01A26D           ; / 
CODE_01A264:        20 0E 80      JSR.W IsOnGround          
CODE_01A267:        F0 04         BEQ CODE_01A26D           
CODE_01A269:        A9 F0         LDA.B #$F0                
CODE_01A26B:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01A26D:        A0 00         LDY.B #$00                
CODE_01A26F:        A5 14         LDA RAM_FrameCounterB     
CODE_01A271:        29 18         AND.B #$18                
CODE_01A273:        D0 02         BNE CODE_01A277           
CODE_01A275:        A0 03         LDY.B #$03                
CODE_01A277:        98            TYA                       
CODE_01A278:        9D 02 16      STA.W $1602,X             
CODE_01A27B:        4C 4F A3      JMP.W CODE_01A34F         

CODE_01A27E:        9E EA 15      STZ.W RAM_SprOAMIndex,X   
CODE_01A281:        C9 20         CMP.B #$20                
CODE_01A283:        F0 03         BEQ CODE_01A288           
CODE_01A285:        4C 0A A3      JMP.W CODE_01A30A         

CODE_01A288:        BC 0E 16      LDY.W $160E,X             
CODE_01A28B:        A9 00         LDA.B #$00                ; \ Clear sprite status 
CODE_01A28D:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01A290:        A9 06         LDA.B #$06                
CODE_01A292:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_01A295:        B9 0E 16      LDA.W $160E,Y             
CODE_01A298:        D0 5A         BNE CODE_01A2F4           
CODE_01A29A:        B9 9E 00      LDA.W RAM_SpriteNum,Y     ; \ Branch if not Changing power up 
CODE_01A29D:        C9 81         CMP.B #$81                ;  | 
CODE_01A29F:        D0 0C         BNE CODE_01A2AD           ; / 
ADDR_01A2A1:        A5 14         LDA RAM_FrameCounterB     
ADDR_01A2A3:        4A            LSR                       
ADDR_01A2A4:        4A            LSR                       
ADDR_01A2A5:        4A            LSR                       
ADDR_01A2A6:        4A            LSR                       
ADDR_01A2A7:        29 03         AND.B #$03                
ADDR_01A2A9:        A8            TAY                       
ADDR_01A2AA:        B9 13 C3      LDA.W ChangingItemSprite,Y 
CODE_01A2AD:        C9 74         CMP.B #$74                
CODE_01A2AF:        90 43         BCC CODE_01A2F4           
CODE_01A2B1:        C9 78         CMP.B #$78                
CODE_01A2B3:        B0 3F         BCS CODE_01A2F4           
CODE_01A2B5:        9C AC 18      STZ.W $18AC               
CODE_01A2B8:        9C 1E 14      STZ.W RAM_YoshiHasWings   ; No Yoshi wings 
CODE_01A2BB:        A9 35         LDA.B #$35                ; \ Sprite = Yoshi 
CODE_01A2BD:        9D 9E 00      STA.W RAM_SpriteNum,X     ; / 
CODE_01A2C0:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_01A2C2:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01A2C5:        A9 1F         LDA.B #$1F                
CODE_01A2C7:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_01A2CA:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01A2CC:        E9 10         SBC.B #$10                
CODE_01A2CE:        95 D8         STA RAM_SpriteYLo,X       
CODE_01A2D0:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01A2D3:        E9 00         SBC.B #$00                
CODE_01A2D5:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01A2D8:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01A2DB:        48            PHA                       ; \ Reset sprite tables 
CODE_01A2DC:        22 D2 F7 07   JSL.L InitSpriteTables    ;  | 
CODE_01A2E0:        68            PLA                       ; / 
CODE_01A2E1:        29 FE         AND.B #$FE                
CODE_01A2E3:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01A2E6:        A9 0C         LDA.B #$0C                
CODE_01A2E8:        9D 02 16      STA.W $1602,X             
CODE_01A2EB:        DE 0E 16      DEC.W $160E,X             
CODE_01A2EE:        A9 40         LDA.B #$40                
CODE_01A2F0:        8D E8 18      STA.W $18E8               
Return01A2F3:       60            RTS                       ; Return 

CODE_01A2F4:        FE 70 15      INC.W $1570,X             
CODE_01A2F7:        BD 70 15      LDA.W $1570,X             
CODE_01A2FA:        C9 05         CMP.B #$05                
CODE_01A2FC:        D0 02         BNE CODE_01A300           
CODE_01A2FE:        80 B5         BRA CODE_01A2B5           

CODE_01A300:        22 4A B3 05   JSL.L CODE_05B34A         
CODE_01A304:        A9 01         LDA.B #$01                
CODE_01A306:        22 E5 AC 02   JSL.L GivePoints          
CODE_01A30A:        BD 3E 16      LDA.W $163E,X             
CODE_01A30D:        4A            LSR                       
CODE_01A30E:        4A            LSR                       
CODE_01A30F:        4A            LSR                       
CODE_01A310:        A8            TAY                       
CODE_01A311:        B9 5A A3      LDA.W DATA_01A35A,Y       
CODE_01A314:        9D 02 16      STA.W $1602,X             
CODE_01A317:        64 01         STZ $01                   
CODE_01A319:        BD 3E 16      LDA.W $163E,X             
CODE_01A31C:        C9 20         CMP.B #$20                
CODE_01A31E:        90 2F         BCC CODE_01A34F           
CODE_01A320:        E9 10         SBC.B #$10                
CODE_01A322:        4A            LSR                       
CODE_01A323:        4A            LSR                       
CODE_01A324:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01A327:        F0 05         BEQ CODE_01A32E           
CODE_01A329:        49 FF         EOR.B #$FF                
CODE_01A32B:        1A            INC A                     
CODE_01A32C:        C6 01         DEC $01                   
CODE_01A32E:        BC 0E 16      LDY.W $160E,X             
CODE_01A331:        18            CLC                       
CODE_01A332:        75 E4         ADC RAM_SpriteXLo,X       
CODE_01A334:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_01A337:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01A33A:        65 01         ADC $01                   
CODE_01A33C:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_01A33F:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01A341:        38            SEC                       
CODE_01A342:        E9 02         SBC.B #$02                
CODE_01A344:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_01A347:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01A34A:        E9 00         SBC.B #$00                
CODE_01A34C:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_01A34F:        20 69 A1      JSR.W CODE_01A169         
CODE_01A352:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01A355:        22 25 EA 02   JSL.L CODE_02EA25         
Return01A359:       60            RTS                       ; Return 


DATA_01A35A:                      .db $00,$03,$02,$02,$01,$01,$01

DATA_01A361:                      .db $10,$20

DATA_01A363:                      .db $01,$02

GetDrawInfoBnk1:    9E 6C 18      STZ.W RAM_OffscreenVert,X 
CODE_01A368:        9E A0 15      STZ.W RAM_OffscreenHorz,X 
CODE_01A36B:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01A36D:        C5 1A         CMP RAM_ScreenBndryXLo    
CODE_01A36F:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01A372:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_01A374:        F0 03         BEQ CODE_01A379           
CODE_01A376:        FE A0 15      INC.W RAM_OffscreenHorz,X 
CODE_01A379:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01A37C:        EB            XBA                       
CODE_01A37D:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01A37F:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01A381:        38            SEC                       
CODE_01A382:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01A384:        18            CLC                       
CODE_01A385:        69 40 00      ADC.W #$0040              
CODE_01A388:        C9 80 01      CMP.W #$0180              
CODE_01A38B:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01A38D:        2A            ROL                       
CODE_01A38E:        29 01         AND.B #$01                
CODE_01A390:        9D C4 15      STA.W $15C4,X             
CODE_01A393:        D0 36         BNE CODE_01A3CB           
CODE_01A395:        A0 00         LDY.B #$00                
CODE_01A397:        BD C8 14      LDA.W $14C8,X             ; \ Branch if sprite status == Stunned 
CODE_01A39A:        C9 09         CMP.B #$09                ;  | 
CODE_01A39C:        F0 08         BEQ CODE_01A3A6           ; / 
CODE_01A39E:        BD 0F 19      LDA.W RAM_Tweaker190F,X   ; \ Branch if "Death frame 2 tiles high" 
CODE_01A3A1:        29 20         AND.B #$20                ;  | is NOT set 
CODE_01A3A3:        F0 01         BEQ CODE_01A3A6           ; / 
CODE_01A3A5:        C8            INY                       
CODE_01A3A6:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01A3A8:        18            CLC                       
CODE_01A3A9:        79 61 A3      ADC.W DATA_01A361,Y       
CODE_01A3AC:        08            PHP                       
CODE_01A3AD:        C5 1C         CMP RAM_ScreenBndryYLo    
CODE_01A3AF:        26 00         ROL $00                   
CODE_01A3B1:        28            PLP                       
CODE_01A3B2:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01A3B5:        69 00         ADC.B #$00                
CODE_01A3B7:        46 00         LSR $00                   
CODE_01A3B9:        E5 1D         SBC RAM_ScreenBndryYHi    
CODE_01A3BB:        F0 09         BEQ CODE_01A3C6           
CODE_01A3BD:        BD 6C 18      LDA.W RAM_OffscreenVert,X 
CODE_01A3C0:        19 63 A3      ORA.W DATA_01A363,Y       
CODE_01A3C3:        9D 6C 18      STA.W RAM_OffscreenVert,X 
CODE_01A3C6:        88            DEY                       
CODE_01A3C7:        10 DD         BPL CODE_01A3A6           
CODE_01A3C9:        80 02         BRA CODE_01A3CD           

CODE_01A3CB:        68            PLA                       
CODE_01A3CC:        68            PLA                       
CODE_01A3CD:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01A3D0:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01A3D2:        38            SEC                       
CODE_01A3D3:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01A3D5:        85 00         STA $00                   
CODE_01A3D7:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01A3D9:        38            SEC                       
CODE_01A3DA:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01A3DC:        85 01         STA $01                   
Return01A3DE:       60            RTS                       ; Return 

CODE_01A3DF:        BD 6C 18      LDA.W RAM_OffscreenVert,X 
CODE_01A3E2:        F0 26         BEQ Return01A40A          
CODE_01A3E4:        DA            PHX                       
CODE_01A3E5:        4A            LSR                       
CODE_01A3E6:        90 10         BCC CODE_01A3F8           
CODE_01A3E8:        48            PHA                       
CODE_01A3E9:        A9 01         LDA.B #$01                
CODE_01A3EB:        99 60 04      STA.W OAM_TileSize,Y      
CODE_01A3EE:        98            TYA                       
CODE_01A3EF:        0A            ASL                       
CODE_01A3F0:        0A            ASL                       
CODE_01A3F1:        AA            TAX                       
CODE_01A3F2:        A9 80         LDA.B #$80                
CODE_01A3F4:        9D 00 03      STA.W OAM_DispX,X         
CODE_01A3F7:        68            PLA                       
CODE_01A3F8:        4A            LSR                       
CODE_01A3F9:        90 0E         BCC CODE_01A409           
CODE_01A3FB:        A9 01         LDA.B #$01                
CODE_01A3FD:        99 61 04      STA.W $0461,Y             
CODE_01A400:        98            TYA                       
CODE_01A401:        0A            ASL                       
CODE_01A402:        0A            ASL                       
CODE_01A403:        AA            TAX                       
CODE_01A404:        A9 80         LDA.B #$80                
CODE_01A406:        9D 04 03      STA.W OAM_Tile2DispX,X    
CODE_01A409:        FA            PLX                       
Return01A40A:       60            RTS                       ; Return 


DATA_01A40B:                      .db $02,$0A

SubSprSprInteract:  8A            TXA                       
CODE_01A40E:        F0 FA         BEQ Return01A40A          
CODE_01A410:        A8            TAY                       
CODE_01A411:        45 13         EOR RAM_FrameCounter      ; \ Return every other frame 
CODE_01A413:        4A            LSR                       ;  | 
CODE_01A414:        90 F4         BCC Return01A40A          ; / 
CODE_01A416:        CA            DEX                       
CODE_01A417:        BD C8 14      LDA.W $14C8,X             ; \ Jump to $01A4B0 if 
CODE_01A41A:        C9 08         CMP.B #$08                ;  | sprite status < 8 
CODE_01A41C:        B0 03         BCS CODE_01A421           ;  | 
CODE_01A41E:        4C B0 A4      JMP.W CODE_01A4B0         ; / 

CODE_01A421:        BD 86 16      LDA.W RAM_Tweaker1686,X   
CODE_01A424:        19 86 16      ORA.W RAM_Tweaker1686,Y   
CODE_01A427:        29 08         AND.B #$08                
CODE_01A429:        1D 64 15      ORA.W $1564,X             
CODE_01A42C:        19 64 15      ORA.W $1564,Y             
CODE_01A42F:        1D D0 15      ORA.W $15D0,X             
CODE_01A432:        1D 32 16      ORA.W RAM_SprBehindScrn,X 
CODE_01A435:        59 32 16      EOR.W RAM_SprBehindScrn,Y 
CODE_01A438:        D0 76         BNE CODE_01A4B0           
CODE_01A43A:        8E 95 16      STX.W $1695               
CODE_01A43D:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01A43F:        85 00         STA $00                   
CODE_01A441:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01A444:        85 01         STA $01                   
CODE_01A446:        B9 E4 00      LDA.W RAM_SpriteXLo,Y     
CODE_01A449:        85 02         STA $02                   
CODE_01A44B:        B9 E0 14      LDA.W RAM_SpriteXHi,Y     
CODE_01A44E:        85 03         STA $03                   
CODE_01A450:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01A452:        A5 00         LDA $00                   
CODE_01A454:        38            SEC                       
CODE_01A455:        E5 02         SBC $02                   
CODE_01A457:        18            CLC                       
CODE_01A458:        69 10 00      ADC.W #$0010              
CODE_01A45B:        C9 20 00      CMP.W #$0020              
CODE_01A45E:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01A460:        B0 4E         BCS CODE_01A4B0           
CODE_01A462:        A0 00         LDY.B #$00                
CODE_01A464:        BD 62 16      LDA.W RAM_Tweaker1662,X   
CODE_01A467:        29 0F         AND.B #$0F                
CODE_01A469:        F0 01         BEQ CODE_01A46C           
CODE_01A46B:        C8            INY                       
CODE_01A46C:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01A46E:        18            CLC                       
CODE_01A46F:        79 0B A4      ADC.W DATA_01A40B,Y       
CODE_01A472:        85 00         STA $00                   
CODE_01A474:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01A477:        69 00         ADC.B #$00                
CODE_01A479:        85 01         STA $01                   
CODE_01A47B:        AC E9 15      LDY.W $15E9               ; Y = Sprite index 
CODE_01A47E:        A2 00         LDX.B #$00                
CODE_01A480:        B9 62 16      LDA.W RAM_Tweaker1662,Y   
CODE_01A483:        29 0F         AND.B #$0F                
CODE_01A485:        F0 01         BEQ CODE_01A488           
CODE_01A487:        E8            INX                       
CODE_01A488:        B9 D8 00      LDA.W RAM_SpriteYLo,Y     
CODE_01A48B:        18            CLC                       
CODE_01A48C:        7D 0B A4      ADC.W DATA_01A40B,X       
CODE_01A48F:        85 02         STA $02                   
CODE_01A491:        B9 D4 14      LDA.W RAM_SpriteYHi,Y     
CODE_01A494:        69 00         ADC.B #$00                
CODE_01A496:        85 03         STA $03                   
CODE_01A498:        AE 95 16      LDX.W $1695               
CODE_01A49B:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01A49D:        A5 00         LDA $00                   
CODE_01A49F:        38            SEC                       
CODE_01A4A0:        E5 02         SBC $02                   
CODE_01A4A2:        18            CLC                       
CODE_01A4A3:        69 0C 00      ADC.W #$000C              
CODE_01A4A6:        C9 18 00      CMP.W #$0018              
CODE_01A4A9:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01A4AB:        B0 03         BCS CODE_01A4B0           
CODE_01A4AD:        20 BA A4      JSR.W CODE_01A4BA         
CODE_01A4B0:        CA            DEX                       
CODE_01A4B1:        30 03         BMI CODE_01A4B6           
CODE_01A4B3:        4C 17 A4      JMP.W CODE_01A417         

CODE_01A4B6:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return01A4B9:       60            RTS                       ; Return 

CODE_01A4BA:        B9 C8 14      LDA.W $14C8,Y             ; \ Branch if sprite 2 status == Normal 
CODE_01A4BD:        C9 08         CMP.B #$08                ;  | 
CODE_01A4BF:        F0 0D         BEQ CODE_01A4CE           ; / 
CODE_01A4C1:        C9 09         CMP.B #$09                ; \ Branch if sprite 2 status == Carryable 
CODE_01A4C3:        F0 1D         BEQ CODE_01A4E2           ; / 
CODE_01A4C5:        C9 0A         CMP.B #$0A                ; \ Branch if sprite 2 status == Kicked 
CODE_01A4C7:        F0 3D         BEQ CODE_01A506           ; / 
CODE_01A4C9:        C9 0B         CMP.B #$0B                ; \ Branch if sprite 2 status == Carried 
CODE_01A4CB:        F0 4D         BEQ CODE_01A51A           ; / 
Return01A4CD:       60            RTS                       ; Return 

CODE_01A4CE:        BD C8 14      LDA.W $14C8,X             ; \ Branch if sprite status == Normal 
CODE_01A4D1:        C9 08         CMP.B #$08                ;  | 
CODE_01A4D3:        F0 68         BEQ CODE_01A53D           ; / 
CODE_01A4D5:        C9 09         CMP.B #$09                ; \ Branch if sprite status == Carryable 
CODE_01A4D7:        F0 67         BEQ CODE_01A540           ; / 
CODE_01A4D9:        C9 0A         CMP.B #$0A                ; \ Branch if sprite status == Kicked 
CODE_01A4DB:        F0 5A         BEQ CODE_01A537           ; / 
CODE_01A4DD:        C9 0B         CMP.B #$0B                ; \ Branch if sprite status == Carried 
CODE_01A4DF:        F0 53         BEQ CODE_01A534           ; / 
Return01A4E1:       60            RTS                       ; Return 

CODE_01A4E2:        B9 88 15      LDA.W RAM_SprObjStatus,Y  ; \ Branch if on ground 
CODE_01A4E5:        29 04         AND.B #$04                ;  | 
CODE_01A4E7:        D0 09         BNE CODE_01A4F2           ; / 
CODE_01A4E9:        B9 9E 00      LDA.W RAM_SpriteNum,Y     ; \ Branch if Goomba 
CODE_01A4EC:        C9 0F         CMP.B #$0F                ;  | 
CODE_01A4EE:        F0 44         BEQ CODE_01A534           ; / 
CODE_01A4F0:        80 14         BRA CODE_01A506           

CODE_01A4F2:        BD C8 14      LDA.W $14C8,X             ; \ Branch if sprite status == Normal 
CODE_01A4F5:        C9 08         CMP.B #$08                ;  | 
CODE_01A4F7:        F0 47         BEQ CODE_01A540           ; / 
CODE_01A4F9:        C9 09         CMP.B #$09                ; \ Branch if sprite status == Carryable 
CODE_01A4FB:        F0 58         BEQ CODE_01A555           ; / 
CODE_01A4FD:        C9 0A         CMP.B #$0A                ; \ Branch if sprite status == Kicked 
CODE_01A4FF:        F0 39         BEQ ADDR_01A53A           ; / 
CODE_01A501:        C9 0B         CMP.B #$0B                ; \ Branch if sprite status == Carried 
CODE_01A503:        F0 2F         BEQ CODE_01A534           ; / 
Return01A505:       60            RTS                       ; Return 

CODE_01A506:        BD C8 14      LDA.W $14C8,X             ; \ Branch if sprite status == Normal 
CODE_01A509:        C9 08         CMP.B #$08                ;  | 
CODE_01A50B:        F0 21         BEQ CODE_01A52E           ; / 
CODE_01A50D:        C9 09         CMP.B #$09                ; \ Branch if sprite status == Carryable 
CODE_01A50F:        F0 20         BEQ CODE_01A531           ; / 
CODE_01A511:        C9 0A         CMP.B #$0A                ; \ Branch if sprite status == Kicked 
CODE_01A513:        F0 1F         BEQ CODE_01A534           ; / 
CODE_01A515:        C9 0B         CMP.B #$0B                ; \ Branch if sprite status == Carried 
CODE_01A517:        F0 1B         BEQ CODE_01A534           ; / 
Return01A519:       60            RTS                       ; Return 

CODE_01A51A:        BD C8 14      LDA.W $14C8,X             ; \ Branch if sprite status == Normal 
CODE_01A51D:        C9 08         CMP.B #$08                ;  | 
CODE_01A51F:        F0 13         BEQ CODE_01A534           ; / 
CODE_01A521:        C9 09         CMP.B #$09                ; \ Branch if sprite status == Carryable 
CODE_01A523:        F0 0F         BEQ CODE_01A534           ; / 
ADDR_01A525:        C9 0A         CMP.B #$0A                ; \ Branch if sprite status == Kicked 
ADDR_01A527:        F0 0B         BEQ CODE_01A534           ; / 
ADDR_01A529:        C9 0B         CMP.B #$0B                ; \ Branch if sprite status == Carried 
ADDR_01A52B:        F0 07         BEQ CODE_01A534           ; / 
Return01A52D:       60            RTS                       ; Return 

CODE_01A52E:        4C 25 A6      JMP.W CODE_01A625         

CODE_01A531:        4C 42 A6      JMP.W CODE_01A642         

CODE_01A534:        4C 85 A6      JMP.W CODE_01A685         

CODE_01A537:        4C C4 A5      JMP.W CODE_01A5C4         

ADDR_01A53A:        4C C4 A5      JMP.W CODE_01A5C4         

CODE_01A53D:        4C 6D A5      JMP.W CODE_01A56D         

CODE_01A540:        20 D9 A6      JSR.W CODE_01A6D9         
CODE_01A543:        DA            PHX                       
CODE_01A544:        5A            PHY                       
CODE_01A545:        98            TYA                       
CODE_01A546:        9B            TXY                       
CODE_01A547:        AA            TAX                       
CODE_01A548:        20 D9 A6      JSR.W CODE_01A6D9         
CODE_01A54B:        7A            PLY                       
CODE_01A54C:        FA            PLX                       
CODE_01A54D:        BD 58 15      LDA.W $1558,X             
CODE_01A550:        19 58 15      ORA.W $1558,Y             
CODE_01A553:        D0 6E         BNE Return01A5C3          
CODE_01A555:        BD C8 14      LDA.W $14C8,X             
CODE_01A558:        C9 09         CMP.B #$09                
CODE_01A55A:        D0 11         BNE CODE_01A56D           
CODE_01A55C:        20 0E 80      JSR.W IsOnGround          
CODE_01A55F:        D0 0C         BNE CODE_01A56D           
CODE_01A561:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if not Goomba 
CODE_01A563:        C9 0F         CMP.B #$0F                ;  | 
CODE_01A565:        D0 03         BNE CODE_01A56A           ; / 
ADDR_01A567:        4C 85 A6      JMP.W CODE_01A685         

CODE_01A56A:        4C C4 A5      JMP.W CODE_01A5C4         

CODE_01A56D:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01A56F:        38            SEC                       
CODE_01A570:        F9 E4 00      SBC.W RAM_SpriteXLo,Y     
CODE_01A573:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01A576:        F9 E0 14      SBC.W RAM_SpriteXHi,Y     
CODE_01A579:        2A            ROL                       
CODE_01A57A:        29 01         AND.B #$01                
CODE_01A57C:        85 00         STA $00                   
CODE_01A57E:        B9 86 16      LDA.W RAM_Tweaker1686,Y   
CODE_01A581:        29 10         AND.B #$10                
CODE_01A583:        D0 1C         BNE CODE_01A5A1           
CODE_01A585:        AC E9 15      LDY.W $15E9               ; Y = Sprite index 
CODE_01A588:        B9 7C 15      LDA.W RAM_SpriteDir,Y     
CODE_01A58B:        48            PHA                       
CODE_01A58C:        A5 00         LDA $00                   
CODE_01A58E:        99 7C 15      STA.W RAM_SpriteDir,Y     
CODE_01A591:        68            PLA                       
CODE_01A592:        D9 7C 15      CMP.W RAM_SpriteDir,Y     
CODE_01A595:        F0 0A         BEQ CODE_01A5A1           
CODE_01A597:        B9 AC 15      LDA.W $15AC,Y             
CODE_01A59A:        D0 05         BNE CODE_01A5A1           
CODE_01A59C:        A9 08         LDA.B #$08                ; \ Set turning timer 
CODE_01A59E:        99 AC 15      STA.W $15AC,Y             ; / 
CODE_01A5A1:        BD 86 16      LDA.W RAM_Tweaker1686,X   
CODE_01A5A4:        29 10         AND.B #$10                
CODE_01A5A6:        D0 1B         BNE Return01A5C3          
CODE_01A5A8:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01A5AB:        48            PHA                       
CODE_01A5AC:        A5 00         LDA $00                   
CODE_01A5AE:        49 01         EOR.B #$01                
CODE_01A5B0:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01A5B3:        68            PLA                       
CODE_01A5B4:        DD 7C 15      CMP.W RAM_SpriteDir,X     
CODE_01A5B7:        F0 0A         BEQ Return01A5C3          
CODE_01A5B9:        BD AC 15      LDA.W $15AC,X             
CODE_01A5BC:        D0 05         BNE Return01A5C3          
CODE_01A5BE:        A9 08         LDA.B #$08                ; \ Set turning timer 
CODE_01A5C0:        9D AC 15      STA.W $15AC,X             ; / 
Return01A5C3:       60            RTS                       ; Return 

CODE_01A5C4:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01A5C7:        38            SEC                       
CODE_01A5C8:        E9 83         SBC.B #$83                
CODE_01A5CA:        C9 02         CMP.B #$02                
CODE_01A5CC:        B0 0C         BCS CODE_01A5DA           
CODE_01A5CE:        20 98 90      JSR.W FlipSpriteDir       
CODE_01A5D1:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_01A5D3:        DA            PHX                       
CODE_01A5D4:        BB            TYX                       
CODE_01A5D5:        20 E2 B4      JSR.W CODE_01B4E2         
CODE_01A5D8:        FA            PLX                       
Return01A5D9:       60            RTS                       ; Return 

CODE_01A5DA:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01A5DD:        AC 95 16      LDY.W $1695               
CODE_01A5E0:        20 7C A7      JSR.W CODE_01A77C         
CODE_01A5E3:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_01A5E5:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01A5E8:        DA            PHX                       
CODE_01A5E9:        BB            TYX                       
CODE_01A5EA:        22 72 AB 01   JSL.L CODE_01AB72         
CODE_01A5EE:        FA            PLX                       
CODE_01A5EF:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01A5F1:        0A            ASL                       
CODE_01A5F2:        A9 10         LDA.B #$10                
CODE_01A5F4:        90 02         BCC CODE_01A5F8           
CODE_01A5F6:        A9 F0         LDA.B #$F0                
CODE_01A5F8:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_01A5FB:        A9 D0         LDA.B #$D0                
CODE_01A5FD:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_01A600:        5A            PHY                       
CODE_01A601:        FE 26 16      INC.W $1626,X             
CODE_01A604:        BC 26 16      LDY.W $1626,X             
CODE_01A607:        C0 08         CPY.B #$08                
CODE_01A609:        B0 06         BCS CODE_01A611           
CODE_01A60B:        B9 1D A6      LDA.W Return01A61D,Y      
CODE_01A60E:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_01A611:        98            TYA                       
CODE_01A612:        C9 08         CMP.B #$08                
CODE_01A614:        90 02         BCC CODE_01A618           
CODE_01A616:        A9 08         LDA.B #$08                
CODE_01A618:        7A            PLY                       
CODE_01A619:        22 E1 AC 02   JSL.L CODE_02ACE1         
Return01A61D:       60            RTS                       ; Return 


DATA_01A61E:                      .db $13,$14,$15,$16,$17,$18,$19

CODE_01A625:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01A627:        38            SEC                       
CODE_01A628:        E9 83         SBC.B #$83                
CODE_01A62A:        C9 02         CMP.B #$02                
CODE_01A62C:        B0 0F         BCS CODE_01A63D           
CODE_01A62E:        DA            PHX                       
CODE_01A62F:        BB            TYX                       
CODE_01A630:        20 98 90      JSR.W FlipSpriteDir       
CODE_01A633:        FA            PLX                       
CODE_01A634:        A9 00         LDA.B #$00                
CODE_01A636:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_01A639:        20 E2 B4      JSR.W CODE_01B4E2         
Return01A63C:       60            RTS                       ; Return 

CODE_01A63D:        20 7C A7      JSR.W CODE_01A77C         
CODE_01A640:        80 08         BRA CODE_01A64A           

CODE_01A642:        20 0E 80      JSR.W IsOnGround          
CODE_01A645:        D0 03         BNE CODE_01A64A           
ADDR_01A647:        4C 85 A6      JMP.W CODE_01A685         

CODE_01A64A:        DA            PHX                       
CODE_01A64B:        B9 26 16      LDA.W $1626,Y             
CODE_01A64E:        1A            INC A                     
CODE_01A64F:        99 26 16      STA.W $1626,Y             
CODE_01A652:        BE 26 16      LDX.W $1626,Y             
CODE_01A655:        E0 08         CPX.B #$08                
CODE_01A657:        B0 06         BCS CODE_01A65F           
CODE_01A659:        BD 1D A6      LDA.W Return01A61D,X      
CODE_01A65C:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_01A65F:        8A            TXA                       
CODE_01A660:        C9 08         CMP.B #$08                
CODE_01A662:        90 02         BCC CODE_01A666           
CODE_01A664:        A9 08         LDA.B #$08                
CODE_01A666:        FA            PLX                       
CODE_01A667:        22 E5 AC 02   JSL.L GivePoints          
CODE_01A66B:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_01A66D:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01A670:        22 72 AB 01   JSL.L CODE_01AB72         
CODE_01A674:        B9 B6 00      LDA.W RAM_SpriteSpeedX,Y  
CODE_01A677:        0A            ASL                       
CODE_01A678:        A9 10         LDA.B #$10                
CODE_01A67A:        90 02         BCC CODE_01A67E           
CODE_01A67C:        A9 F0         LDA.B #$F0                
CODE_01A67E:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01A680:        A9 D0         LDA.B #$D0                
CODE_01A682:        95 AA         STA RAM_SpriteSpeedY,X    
Return01A684:       60            RTS                       ; Return 

CODE_01A685:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if Flying Question Block 
CODE_01A687:        C9 83         CMP.B #$83                ;  | 
CODE_01A689:        F0 0F         BEQ ADDR_01A69A           ;  | 
CODE_01A68B:        C9 84         CMP.B #$84                ;  | 
CODE_01A68D:        F0 0B         BEQ ADDR_01A69A           ; / 
CODE_01A68F:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_01A691:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01A694:        A9 D0         LDA.B #$D0                
CODE_01A696:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01A698:        80 03         BRA CODE_01A69D           

ADDR_01A69A:        20 E2 B4      JSR.W CODE_01B4E2         
CODE_01A69D:        B9 9E 00      LDA.W RAM_SpriteNum,Y     ; \ Branch if Flying Question Block or Key 
CODE_01A6A0:        C9 80         CMP.B #$80                ;  | 
CODE_01A6A2:        F0 17         BEQ CODE_01A6BB           ;  | 
CODE_01A6A4:        C9 83         CMP.B #$83                ;  | 
CODE_01A6A6:        F0 10         BEQ ADDR_01A6B8           ;  | 
CODE_01A6A8:        C9 84         CMP.B #$84                ;  | 
CODE_01A6AA:        F0 0C         BEQ ADDR_01A6B8           ; / 
CODE_01A6AC:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_01A6AE:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01A6B1:        A9 D0         LDA.B #$D0                
CODE_01A6B3:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_01A6B6:        80 03         BRA CODE_01A6BB           

ADDR_01A6B8:        20 D3 A5      JSR.W CODE_01A5D3         
CODE_01A6BB:        22 6F AB 01   JSL.L CODE_01AB6F         
CODE_01A6BF:        A9 04         LDA.B #$04                
CODE_01A6C1:        22 E5 AC 02   JSL.L GivePoints          
CODE_01A6C5:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01A6C7:        0A            ASL                       
CODE_01A6C8:        A9 10         LDA.B #$10                
CODE_01A6CA:        B0 02         BCS CODE_01A6CE           
CODE_01A6CC:        A9 F0         LDA.B #$F0                
CODE_01A6CE:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01A6D0:        49 FF         EOR.B #$FF                
CODE_01A6D2:        1A            INC A                     
CODE_01A6D3:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
Return01A6D6:       60            RTS                       ; Return 


DATA_01A6D7:                      .db $30,$D0

CODE_01A6D9:        84 00         STY $00                   
CODE_01A6DB:        20 0E 80      JSR.W IsOnGround          
CODE_01A6DE:        F0 4D         BEQ Return01A72D          
CODE_01A6E0:        B9 88 15      LDA.W RAM_SprObjStatus,Y  ; \ Branch if not on ground 
CODE_01A6E3:        29 04         AND.B #$04                ;  | 
CODE_01A6E5:        F0 46         BEQ Return01A72D          ; / 
CODE_01A6E7:        BD 56 16      LDA.W RAM_Tweaker1656,X   ; \ Return if doesn't kick/hop into shells 
CODE_01A6EA:        29 40         AND.B #$40                ;  | 
CODE_01A6EC:        F0 3F         BEQ Return01A72D          ; / 
CODE_01A6EE:        B9 58 15      LDA.W $1558,Y             
CODE_01A6F1:        1D 58 15      ORA.W $1558,X             
CODE_01A6F4:        D0 37         BNE Return01A72D          
CODE_01A6F6:        64 02         STZ $02                   
CODE_01A6F8:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01A6FA:        38            SEC                       
CODE_01A6FB:        F9 E4 00      SBC.W RAM_SpriteXLo,Y     
CODE_01A6FE:        30 02         BMI CODE_01A702           
CODE_01A700:        E6 02         INC $02                   
CODE_01A702:        18            CLC                       
CODE_01A703:        69 08         ADC.B #$08                
CODE_01A705:        C9 10         CMP.B #$10                
CODE_01A707:        90 24         BCC Return01A72D          
CODE_01A709:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01A70C:        C5 02         CMP $02                   
CODE_01A70E:        D0 1D         BNE Return01A72D          
CODE_01A710:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if not Blue Shelless 
CODE_01A712:        C9 02         CMP.B #$02                ;  | 
CODE_01A714:        D0 18         BNE HopIntoShell          ; / 
CODE_01A716:        A9 20         LDA.B #$20                
CODE_01A718:        9D 3E 16      STA.W $163E,X             
CODE_01A71B:        9D 58 15      STA.W $1558,X             
CODE_01A71E:        A9 23         LDA.B #$23                
CODE_01A720:        9D 64 15      STA.W $1564,X             
CODE_01A723:        98            TYA                       
CODE_01A724:        9D 0E 16      STA.W $160E,X             
Return01A727:       60            RTS                       ; Return 

PlayKickSfx:        A9 03         LDA.B #$03                ; \ Play sound effect 
CODE_01A72A:        8D F9 1D      STA.W $1DF9               ; / 
Return01A72D:       60            RTS                       ; Return 

HopIntoShell:       B9 40 15      LDA.W $1540,Y             ; \ Return if timer is set 
CODE_01A731:        D0 44         BNE Return01A777          ; / 
CODE_01A733:        B9 9E 00      LDA.W RAM_SpriteNum,Y     ; \ Return if sprite >= #$0F 
CODE_01A736:        C9 0F         CMP.B #$0F                ;  | 
CODE_01A738:        B0 3D         BCS Return01A777          ; / 
CODE_01A73A:        B9 88 15      LDA.W RAM_SprObjStatus,Y  ; \ Return if not on ground 
CODE_01A73D:        29 04         AND.B #$04                ;  | 
CODE_01A73F:        F0 36         BEQ Return01A777          ; / 
CODE_01A741:        B9 F6 15      LDA.W RAM_SpritePal,Y     ; \ Branch if $15F6,y positive... 
CODE_01A744:        10 17         BPL CODE_01A75D           ; / 
CODE_01A746:        29 7F         AND.B #$7F                ; \ ...otherwise make it positive 
CODE_01A748:        99 F6 15      STA.W RAM_SpritePal,Y     ; / 
CODE_01A74B:        A9 E0         LDA.B #$E0                ; \ Set upward speed 
CODE_01A74D:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  ; / 
CODE_01A750:        A9 20         LDA.B #$20                ; \ $1564,y = #$20 
CODE_01A752:        99 64 15      STA.W $1564,Y             ; / 
CODE_01A755:        A9 20         LDA.B #$20                ; \ C2,x and 1558,x = #$20 
CODE_01A757:        95 C2         STA RAM_SpriteState,X     ;  | (These are for the shell sprite) 
CODE_01A759:        9D 58 15      STA.W $1558,X             ; / 
Return01A75C:       60            RTS                       ; Return 

CODE_01A75D:        A9 E0         LDA.B #$E0                ; \ Set upward speed 
CODE_01A75F:        95 AA         STA RAM_SpriteSpeedY,X    ; / 
CODE_01A761:        BD 4A 16      LDA.W $164A,X             
CODE_01A764:        C9 01         CMP.B #$01                
CODE_01A766:        A9 18         LDA.B #$18                
CODE_01A768:        90 02         BCC CODE_01A76C           
ADDR_01A76A:        A9 2C         LDA.B #$2C                
CODE_01A76C:        9D 58 15      STA.W $1558,X             
CODE_01A76F:        8A            TXA                       
CODE_01A770:        99 94 15      STA.W $1594,Y             
CODE_01A773:        98            TYA                       
CODE_01A774:        9D 94 15      STA.W $1594,X             
Return01A777:       60            RTS                       ; Return 


DATA_01A778:                      .db $10,$F0

DATA_01A77A:                      .db $00,$FF

CODE_01A77C:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01A77E:        C9 02         CMP.B #$02                
CODE_01A780:        D0 40         BNE CODE_01A7C2           
CODE_01A782:        B9 7B 18      LDA.W $187B,Y             
CODE_01A785:        D0 3B         BNE CODE_01A7C2           
CODE_01A787:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01A78A:        D9 7C 15      CMP.W RAM_SpriteDir,Y     
CODE_01A78D:        F0 33         BEQ CODE_01A7C2           
CODE_01A78F:        84 01         STY $01                   
CODE_01A791:        BC 34 15      LDY.W $1534,X             
CODE_01A794:        D0 2A         BNE CODE_01A7C0           
CODE_01A796:        9E 28 15      STZ.W $1528,X             

Instr01A799:                      .db $9E,$3E,$16

CODE_01A79C:        A8            TAY                       
CODE_01A79D:        84 00         STY $00                   
CODE_01A79F:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01A7A1:        18            CLC                       
CODE_01A7A2:        79 78 A7      ADC.W DATA_01A778,Y       
CODE_01A7A5:        A4 01         LDY $01                   
CODE_01A7A7:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_01A7AA:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01A7AD:        A4 00         LDY $00                   
CODE_01A7AF:        79 7A A7      ADC.W DATA_01A77A,Y       
CODE_01A7B2:        A4 01         LDY $01                   
CODE_01A7B4:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_01A7B7:        98            TYA                       
CODE_01A7B8:        9D 0E 16      STA.W $160E,X             
CODE_01A7BB:        A9 01         LDA.B #$01                
CODE_01A7BD:        9D 34 15      STA.W $1534,X             
CODE_01A7C0:        68            PLA                       
CODE_01A7C1:        68            PLA                       
CODE_01A7C2:        AE 95 16      LDX.W $1695               
CODE_01A7C5:        AC E9 15      LDY.W $15E9               ; Y = Sprite index 
Return01A7C8:       60            RTS                       ; Return 


SpriteToSpawn:                    .db $00,$01,$02,$03,$04,$05,$06,$07
                                  .db $04,$04,$05,$05,$07,$00,$00,$0F
                                  .db $0F,$0F,$0D

MarioSprInteract:   8B            PHB                       
CODE_01A7DD:        4B            PHK                       
CODE_01A7DE:        AB            PLB                       
CODE_01A7DF:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01A7E2:        AB            PLB                       
Return01A7E3:       6B            RTL                       ; Return 

MarioSprInteractRt: BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ Branch if "Process interaction every frame" is set 
CODE_01A7E7:        29 20         AND.B #$20                ;  | 
CODE_01A7E9:        D0 0C         BNE ProcessInteract       ; / 
CODE_01A7EB:        8A            TXA                       ; \ Otherwise, return every other frame 
CODE_01A7EC:        45 13         EOR RAM_FrameCounter      ;  | 
CODE_01A7EE:        29 01         AND.B #$01                ;  | 
CODE_01A7F0:        1D A0 15      ORA.W RAM_OffscreenHorz,X ;  | 
CODE_01A7F3:        F0 02         BEQ ProcessInteract       ;  | 
ReturnNoContact:    18            CLC                       ;  | 
Return01A7F6:       60            RTS                       ; / 

ProcessInteract:    20 30 AD      JSR.W SubHorizPos         
CODE_01A7FA:        A5 0F         LDA $0F                   
CODE_01A7FC:        18            CLC                       
CODE_01A7FD:        69 50         ADC.B #$50                
CODE_01A7FF:        C9 A0         CMP.B #$A0                
CODE_01A801:        B0 F2         BCS ReturnNoContact       ; No contact, return 
CODE_01A803:        20 42 AD      JSR.W CODE_01AD42         
CODE_01A806:        A5 0E         LDA $0E                   
CODE_01A808:        18            CLC                       
CODE_01A809:        69 60         ADC.B #$60                
CODE_01A80B:        C9 C0         CMP.B #$C0                
CODE_01A80D:        B0 E6         BCS ReturnNoContact       ; No contact, return 
CODE_01A80F:        A5 71         LDA RAM_MarioAnimation    ; \ If animation sequence activated... 
CODE_01A811:        C9 01         CMP.B #$01                ;  | 
CODE_01A813:        B0 E0         BCS ReturnNoContact       ; / ...no contact, return 
CODE_01A815:        A9 00         LDA.B #$00                ; \ Branch if bit 6 of $0D9B set? 
CODE_01A817:        2C 9B 0D      BIT.W $0D9B               ;  | 
CODE_01A81A:        70 06         BVS CODE_01A822           ; / 
CODE_01A81C:        AD F9 13      LDA.W RAM_IsBehindScenery ; \ If Mario and Sprite not on same side of scenery... 
CODE_01A81F:        5D 32 16      EOR.W RAM_SprBehindScrn,X ;  | 
CODE_01A822:        D0 58         BNE ReturnNoContact2      ; / ...no contact, return 
CODE_01A824:        22 64 B6 03   JSL.L GetMarioClipping    
CODE_01A828:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_01A82C:        22 2B B7 03   JSL.L CheckForContact     
CODE_01A830:        90 4A         BCC ReturnNoContact2      ; No contact, return 
CODE_01A832:        BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ Branch if sprite uses default Mario interaction 
CODE_01A835:        10 04         BPL DefaultInteractR      ; / 
CODE_01A837:        38            SEC                       ; Contact, return 
Return01A838:       60            RTS                       ; Return 


DATA_01A839:                      .db $F0,$10

DefaultInteractR:   AD 90 14      LDA.W $1490               ; \ Branch if Mario doesn't have star 
CODE_01A83E:        F0 3E         BEQ CODE_01A87E           ; / 
CODE_01A840:        BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ Branch if "Process interaction every frame" is set 
CODE_01A843:        29 02         AND.B #$02                ;  | 
CODE_01A845:        D0 37         BNE CODE_01A87E           ; / 
CODE_01A847:        22 6F AB 01   JSL.L CODE_01AB6F         
CODE_01A84B:        EE D2 18      INC.W $18D2               
CODE_01A84E:        AD D2 18      LDA.W $18D2               
CODE_01A851:        C9 08         CMP.B #$08                
CODE_01A853:        90 05         BCC CODE_01A85A           
CODE_01A855:        A9 08         LDA.B #$08                
CODE_01A857:        8D D2 18      STA.W $18D2               
CODE_01A85A:        22 E5 AC 02   JSL.L GivePoints          
CODE_01A85E:        AC D2 18      LDY.W $18D2               
CODE_01A861:        C0 08         CPY.B #$08                
CODE_01A863:        B0 06         BCS CODE_01A86B           
CODE_01A865:        B9 1D A6      LDA.W Return01A61D,Y      
CODE_01A868:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_01A86B:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_01A86D:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01A870:        A9 D0         LDA.B #$D0                
CODE_01A872:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01A874:        20 30 AD      JSR.W SubHorizPos         
CODE_01A877:        B9 39 A8      LDA.W DATA_01A839,Y       
CODE_01A87A:        95 B6         STA RAM_SpriteSpeedX,X    
ReturnNoContact2:   18            CLC                       
Return01A87D:       60            RTS                       ; Return 

CODE_01A87E:        9C D2 18      STZ.W $18D2               
CODE_01A881:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_01A884:        D0 0F         BNE CODE_01A895           
CODE_01A886:        A9 08         LDA.B #$08                
CODE_01A888:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_01A88B:        BD C8 14      LDA.W $14C8,X             
CODE_01A88E:        C9 09         CMP.B #$09                
CODE_01A890:        D0 05         BNE CODE_01A897           
CODE_01A892:        20 42 AA      JSR.W CODE_01AA42         
CODE_01A895:        18            CLC                       
Return01A896:       60            RTS                       ; Return 

CODE_01A897:        A9 14         LDA.B #$14                
CODE_01A899:        85 01         STA $01                   
CODE_01A89B:        A5 05         LDA $05                   
CODE_01A89D:        38            SEC                       
CODE_01A89E:        E5 01         SBC $01                   
CODE_01A8A0:        26 00         ROL $00                   
CODE_01A8A2:        C5 D3         CMP $D3                   
CODE_01A8A4:        08            PHP                       
CODE_01A8A5:        46 00         LSR $00                   
CODE_01A8A7:        A5 0B         LDA $0B                   
CODE_01A8A9:        E9 00         SBC.B #$00                
CODE_01A8AB:        28            PLP                       
CODE_01A8AC:        E5 D4         SBC $D4                   
CODE_01A8AE:        30 36         BMI CODE_01A8E6           
CODE_01A8B0:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01A8B2:        10 0C         BPL CODE_01A8C0           
CODE_01A8B4:        BD 0F 19      LDA.W RAM_Tweaker190F,X   ; \ TODO: Branch if Unknown Bit 11 is set 
CODE_01A8B7:        29 10         AND.B #$10                ;  | 
CODE_01A8B9:        D0 05         BNE CODE_01A8C0           ; / 
CODE_01A8BB:        AD 97 16      LDA.W $1697               
CODE_01A8BE:        F0 26         BEQ CODE_01A8E6           
CODE_01A8C0:        20 0E 80      JSR.W IsOnGround          
CODE_01A8C3:        F0 04         BEQ CODE_01A8C9           
CODE_01A8C5:        A5 72         LDA RAM_IsFlying          
CODE_01A8C7:        F0 1D         BEQ CODE_01A8E6           
CODE_01A8C9:        BD 56 16      LDA.W RAM_Tweaker1656,X   ; \ Branch if can be jumped on 
CODE_01A8CC:        29 10         AND.B #$10                ;  | 
CODE_01A8CE:        D0 4C         BNE CODE_01A91C           ; / 
CODE_01A8D0:        AD 0D 14      LDA.W RAM_IsSpinJump      
CODE_01A8D3:        0D 7A 18      ORA.W RAM_OnYoshi         
CODE_01A8D6:        F0 0E         BEQ CODE_01A8E6           
CODE_01A8D8:        A9 02         LDA.B #$02                
CODE_01A8DA:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_01A8DD:        22 33 AA 01   JSL.L BoostMarioSpeed     
CODE_01A8E1:        22 99 AB 01   JSL.L DisplayContactGfx   
Return01A8E5:       60            RTS                       ; Return 

CODE_01A8E6:        AD ED 13      LDA.W $13ED               
CODE_01A8E9:        F0 0E         BEQ CODE_01A8F9           
CODE_01A8EB:        BD 0F 19      LDA.W RAM_Tweaker190F,X   ; \ Branch if "Takes 5 fireballs to kill"... 
CODE_01A8EE:        29 04         AND.B #$04                ;  | ...is set 
CODE_01A8F0:        D0 07         BNE CODE_01A8F9           ; / 
CODE_01A8F2:        20 28 A7      JSR.W PlayKickSfx         
CODE_01A8F5:        20 47 A8      JSR.W CODE_01A847         
Return01A8F8:       60            RTS                       ; Return 

CODE_01A8F9:        AD 97 14      LDA.W $1497               ; \ Return if Mario is invincible 
CODE_01A8FC:        D0 1D         BNE Return01A91B          ; / 
CODE_01A8FE:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01A901:        D0 18         BNE Return01A91B          
CODE_01A903:        BD 86 16      LDA.W RAM_Tweaker1686,X   
CODE_01A906:        29 10         AND.B #$10                
CODE_01A908:        D0 07         BNE CODE_01A911           
CODE_01A90A:        20 30 AD      JSR.W SubHorizPos         
CODE_01A90D:        98            TYA                       
CODE_01A90E:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01A911:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01A913:        C9 53         CMP.B #$53                
CODE_01A915:        F0 04         BEQ Return01A91B          
CODE_01A917:        22 B7 F5 00   JSL.L HurtMario           
Return01A91B:       60            RTS                       ; Return 

CODE_01A91C:        AD 0D 14      LDA.W RAM_IsSpinJump      
CODE_01A91F:        0D 7A 18      ORA.W RAM_OnYoshi         
CODE_01A922:        F0 23         BEQ CODE_01A947           
CODE_01A924:        22 99 AB 01   JSL.L DisplayContactGfx   
CODE_01A928:        A9 F8         LDA.B #$F8                
CODE_01A92A:        85 7D         STA RAM_MarioSpeedY       
CODE_01A92C:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01A92F:        F0 04         BEQ CODE_01A935           
CODE_01A931:        22 33 AA 01   JSL.L BoostMarioSpeed     
CODE_01A935:        20 CB 9A      JSR.W CODE_019ACB         
CODE_01A938:        22 3B FC 07   JSL.L CODE_07FC3B         
CODE_01A93C:        20 46 AB      JSR.W CODE_01AB46         
CODE_01A93F:        A9 08         LDA.B #$08                
CODE_01A941:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_01A944:        4C F2 A9      JMP.W CODE_01A9F2         

CODE_01A947:        20 D8 A8      JSR.W CODE_01A8D8         
CODE_01A94A:        BD 7B 18      LDA.W $187B,X             
CODE_01A94D:        F0 0E         BEQ CODE_01A95D           
CODE_01A94F:        20 30 AD      JSR.W SubHorizPos         
CODE_01A952:        A9 18         LDA.B #$18                
CODE_01A954:        C0 00         CPY.B #$00                
CODE_01A956:        F0 02         BEQ CODE_01A95A           
CODE_01A958:        A9 E8         LDA.B #$E8                
CODE_01A95A:        85 7B         STA RAM_MarioSpeedX       
Return01A95C:       60            RTS                       ; Return 

CODE_01A95D:        20 46 AB      JSR.W CODE_01AB46         
CODE_01A960:        B4 9E         LDY RAM_SpriteNum,X       
CODE_01A962:        BD 86 16      LDA.W RAM_Tweaker1686,X   
CODE_01A965:        29 40         AND.B #$40                
CODE_01A967:        F0 55         BEQ CODE_01A9BE           
CODE_01A969:        C0 72         CPY.B #$72                
CODE_01A96B:        90 0C         BCC CODE_01A979           
CODE_01A96D:        DA            PHX                       
CODE_01A96E:        5A            PHY                       
CODE_01A96F:        22 F2 EA 02   JSL.L CODE_02EAF2         
CODE_01A973:        7A            PLY                       
CODE_01A974:        FA            PLX                       
CODE_01A975:        A9 02         LDA.B #$02                
CODE_01A977:        80 22         BRA CODE_01A99B           

CODE_01A979:        C0 6E         CPY.B #$6E                
CODE_01A97B:        D0 0D         BNE CODE_01A98A           
CODE_01A97D:        A9 02         LDA.B #$02                
CODE_01A97F:        95 C2         STA RAM_SpriteState,X     
CODE_01A981:        A9 FF         LDA.B #$FF                
CODE_01A983:        9D 40 15      STA.W $1540,X             
CODE_01A986:        A9 6F         LDA.B #$6F		;DINO TORCH SPRITE NUM                
CODE_01A988:        80 11         BRA CODE_01A99B           

CODE_01A98A:        C0 3F         CPY.B #$3F                
CODE_01A98C:        90 0A         BCC CODE_01A998           
CODE_01A98E:        A9 80         LDA.B #$80                
CODE_01A990:        9D 40 15      STA.W $1540,X             
CODE_01A993:        B9 9B A7      LDA.W ADDR_01A79B,Y       
CODE_01A996:        80 03         BRA CODE_01A99B           

CODE_01A998:        B9 C9 A7      LDA.W SpriteToSpawn,Y     
CODE_01A99B:        95 9E         STA RAM_SpriteNum,X       
CODE_01A99D:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01A9A0:        29 0E         AND.B #$0E                
CODE_01A9A2:        85 0F         STA $0F                   
CODE_01A9A4:        22 8B F7 07   JSL.L LoadSpriteTables    
CODE_01A9A8:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01A9AB:        29 F1         AND.B #$F1                
CODE_01A9AD:        05 0F         ORA $0F                   
CODE_01A9AF:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01A9B2:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_01A9B4:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01A9B6:        C9 02         CMP.B #$02                
CODE_01A9B8:        D0 03         BNE Return01A9BD          
CODE_01A9BA:        FE 1C 15      INC.W $151C,X             
Return01A9BD:       60            RTS                       ; Return 

CODE_01A9BE:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01A9C0:        38            SEC                       
CODE_01A9C1:        E9 04         SBC.B #$04                
CODE_01A9C3:        C9 0D         CMP.B #$0D                
CODE_01A9C5:        B0 05         BCS CODE_01A9CC           
CODE_01A9C7:        AD 07 14      LDA.W $1407               
CODE_01A9CA:        D0 07         BNE CODE_01A9D3           
CODE_01A9CC:        BD 56 16      LDA.W RAM_Tweaker1656,X   ; \ Branch if doesn't die when jumped on 
CODE_01A9CF:        29 20         AND.B #$20                ;  | 
CODE_01A9D1:        F0 0F         BEQ CODE_01A9E2           ; / 
CODE_01A9D3:        A9 03         LDA.B #$03                ; \ Sprite status = Smushed 
CODE_01A9D5:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01A9D8:        A9 20         LDA.B #$20                
CODE_01A9DA:        9D 40 15      STA.W $1540,X             
CODE_01A9DD:        74 B6         STZ RAM_SpriteSpeedX,X    ; \ Sprite Speed = 0 
CODE_01A9DF:        74 AA         STZ RAM_SpriteSpeedY,X    ; / 
Return01A9E1:       60            RTS                       ; Return 

CODE_01A9E2:        BD 62 16      LDA.W RAM_Tweaker1662,X   ; \ Branch if Tweaker bit... 
CODE_01A9E5:        29 80         AND.B #$80                ;  | ..."Falls straight down when killed"... 
CODE_01A9E7:        F0 18         BEQ CODE_01AA01           ; / ...is NOT set. 
CODE_01A9E9:        A9 02         LDA.B #$02                ; \ Sprite status = Falling off screen 
CODE_01A9EB:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01A9EE:        74 B6         STZ RAM_SpriteSpeedX,X    ; \ Sprite Speed = 0 
CODE_01A9F0:        74 AA         STZ RAM_SpriteSpeedY,X    ; / 
CODE_01A9F2:        B5 9E         LDA RAM_SpriteNum,X       ; \ Return if NOT Lakitu 
CODE_01A9F4:        C9 1E         CMP.B #$1E                ;  | 
CODE_01A9F6:        D0 08         BNE Return01AA00          ; / 
CODE_01A9F8:        AC E1 18      LDY.W $18E1               
CODE_01A9FB:        A9 1F         LDA.B #$1F                
CODE_01A9FD:        99 40 15      STA.W $1540,Y             
Return01AA00:       60            RTS                       ; Return 

CODE_01AA01:        BC C8 14      LDY.W $14C8,X             
CODE_01AA04:        9E 26 16      STZ.W $1626,X             
CODE_01AA07:        C0 08         CPY.B #$08                
CODE_01AA09:        F0 09         BEQ SetStunnedTimer       
CODE_01AA0B:        B5 C2         LDA RAM_SpriteState,X     
CODE_01AA0D:        D0 05         BNE SetStunnedTimer       
CODE_01AA0F:        9E 40 15      STZ.W $1540,X             
CODE_01AA12:        80 19         BRA SetAsStunned          

SetStunnedTimer:    A9 02         LDA.B #$02                ; \ 
CODE_01AA16:        B4 9E         LDY RAM_SpriteNum,X       ;  | 
CODE_01AA18:        C0 0F         CPY.B #$0F                ;  | Set stunnned timer with: 
CODE_01AA1A:        F0 0C         BEQ CODE_01AA28           ;  | 
CODE_01AA1C:        C0 11         CPY.B #$11                ;  | #$FF for Goomba, Buzzy Beetle, Mechakoopa, or Bob-omb... 
CODE_01AA1E:        F0 08         BEQ CODE_01AA28           ;  | #$02 for others 
CODE_01AA20:        C0 A2         CPY.B #$A2                ;  | 
CODE_01AA22:        F0 04         BEQ CODE_01AA28           ;  | 
CODE_01AA24:        C0 0D         CPY.B #$0D                ;  | 
CODE_01AA26:        D0 02         BNE CODE_01AA2A           ;  | 
CODE_01AA28:        A9 FF         LDA.B #$FF                ;  | 
CODE_01AA2A:        9D 40 15      STA.W $1540,X             ; / 
SetAsStunned:       A9 09         LDA.B #$09                ; \ Status = stunned 
CODE_01AA2F:        9D C8 14      STA.W $14C8,X             ; / 
Return01AA32:       60            RTS                       ; Return 

BoostMarioSpeed:    A5 74         LDA RAM_IsClimbing        ; \ Return if climbing 
CODE_01AA35:        D0 0A         BNE Return01AA41          ; / 
CODE_01AA37:        A9 D0         LDA.B #$D0                
CODE_01AA39:        24 15         BIT RAM_ControllerA       
CODE_01AA3B:        10 02         BPL CODE_01AA3F           
CODE_01AA3D:        A9 A8         LDA.B #$A8                
CODE_01AA3F:        85 7D         STA RAM_MarioSpeedY       
Return01AA41:       6B            RTL                       ; Return 

CODE_01AA42:        AD 0D 14      LDA.W RAM_IsSpinJump      
CODE_01AA45:        0D 7A 18      ORA.W RAM_OnYoshi         
CODE_01AA48:        F0 0E         BEQ CODE_01AA58           
CODE_01AA4A:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01AA4C:        30 0A         BMI CODE_01AA58           
CODE_01AA4E:        BD 56 16      LDA.W RAM_Tweaker1656,X   ; \ Branch if can't be jumped on 
CODE_01AA51:        29 10         AND.B #$10                ;  | 
CODE_01AA53:        F0 03         BEQ CODE_01AA58           ; / 
CODE_01AA55:        4C 24 A9      JMP.W CODE_01A924         

CODE_01AA58:        A5 15         LDA RAM_ControllerA       
CODE_01AA5A:        29 40         AND.B #$40                
CODE_01AA5C:        F0 16         BEQ CODE_01AA74           
CODE_01AA5E:        AD 70 14      LDA.W $1470               ; \ Branch if carrying an enemy... 
CODE_01AA61:        0D 7A 18      ORA.W RAM_OnYoshi         ;  | ...or on Yoshi 
CODE_01AA64:        D0 0E         BNE CODE_01AA74           ; / 
CODE_01AA66:        A9 0B         LDA.B #$0B                ; \ Sprite status = Being carried 
CODE_01AA68:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01AA6B:        EE 70 14      INC.W $1470               ; Set carrying enemy flag 
CODE_01AA6E:        A9 08         LDA.B #$08                
CODE_01AA70:        8D 98 14      STA.W RAM_PickUpImgTimer  
Return01AA73:       60            RTS                       ; Return 

CODE_01AA74:        B5 9E         LDA RAM_SpriteNum,X       ; \ Branch if Key 
CODE_01AA76:        C9 80         CMP.B #$80                ;  | 
CODE_01AA78:        F0 3D         BEQ CODE_01AAB7           ; / 
CODE_01AA7A:        C9 3E         CMP.B #$3E                ; \ Branch if P Switch 
CODE_01AA7C:        F0 34         BEQ CODE_01AAB2           ; / 
CODE_01AA7E:        C9 0D         CMP.B #$0D                ; \ Branch if Bobomb 
CODE_01AA80:        F0 15         BEQ CODE_01AA97           ; / 
CODE_01AA82:        C9 2D         CMP.B #$2D                ; \ Branch if Baby Yoshi 
CODE_01AA84:        F0 11         BEQ CODE_01AA97           ; / 
CODE_01AA86:        C9 A2         CMP.B #$A2                ; \ Branch if MechaKoopa 
CODE_01AA88:        F0 0D         BEQ CODE_01AA97           ; / 
CODE_01AA8A:        C9 0F         CMP.B #$0F                ; \ Branch if not Goomba 
CODE_01AA8C:        D0 06         BNE CODE_01AA94           ; / 
ADDR_01AA8E:        A9 F0         LDA.B #$F0                
ADDR_01AA90:        95 AA         STA RAM_SpriteSpeedY,X    
ADDR_01AA92:        80 03         BRA CODE_01AA97           

CODE_01AA94:        20 46 AB      JSR.W CODE_01AB46         
CODE_01AA97:        20 28 A7      JSR.W PlayKickSfx         
CODE_01AA9A:        BD 40 15      LDA.W $1540,X             
CODE_01AA9D:        95 C2         STA RAM_SpriteState,X     
CODE_01AA9F:        A9 0A         LDA.B #$0A                ; \ Sprite status = Kicked 
CODE_01AAA1:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01AAA4:        A9 10         LDA.B #$10                
CODE_01AAA6:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_01AAA9:        20 30 AD      JSR.W SubHorizPos         
CODE_01AAAC:        B9 6B 9F      LDA.W ShellSpeedX,Y       
CODE_01AAAF:        95 B6         STA RAM_SpriteSpeedX,X    
Return01AAB1:       60            RTS                       ; Return 

CODE_01AAB2:        BD 3E 16      LDA.W $163E,X             
CODE_01AAB5:        D0 75         BNE Return01AB2C          
CODE_01AAB7:        9E 4C 15      STZ.W RAM_DisableInter,X  
CODE_01AABA:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01AABC:        38            SEC                       
CODE_01AABD:        E5 D3         SBC $D3                   
CODE_01AABF:        18            CLC                       
CODE_01AAC0:        69 08         ADC.B #$08                
CODE_01AAC2:        C9 20         CMP.B #$20                
CODE_01AAC4:        90 6B         BCC CODE_01AB31           
CODE_01AAC6:        10 05         BPL CODE_01AACD           
CODE_01AAC8:        A9 10         LDA.B #$10                
CODE_01AACA:        85 7D         STA RAM_MarioSpeedY       
Return01AACC:       60            RTS                       ; Return 

CODE_01AACD:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01AACF:        30 5B         BMI Return01AB2C          
CODE_01AAD1:        64 7D         STZ RAM_MarioSpeedY       
CODE_01AAD3:        64 72         STZ RAM_IsFlying          
CODE_01AAD5:        EE 71 14      INC.W $1471               
CODE_01AAD8:        A9 1F         LDA.B #$1F                
CODE_01AADA:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_01AADD:        F0 02         BEQ CODE_01AAE1           
CODE_01AADF:        A9 2F         LDA.B #$2F                
CODE_01AAE1:        85 00         STA $00                   
CODE_01AAE3:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01AAE5:        38            SEC                       
CODE_01AAE6:        E5 00         SBC $00                   
CODE_01AAE8:        85 96         STA RAM_MarioYPos         
CODE_01AAEA:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01AAED:        E9 00         SBC.B #$00                
CODE_01AAEF:        85 97         STA RAM_MarioYPosHi       
CODE_01AAF1:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01AAF3:        C9 3E         CMP.B #$3E                
CODE_01AAF5:        D0 35         BNE Return01AB2C          
CODE_01AAF7:        1E 7A 16      ASL.W RAM_Tweaker167A,X   
CODE_01AAFA:        5E 7A 16      LSR.W RAM_Tweaker167A,X   
CODE_01AAFD:        A9 0B         LDA.B #$0B                
CODE_01AAFF:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_01AB02:        AD DA 0D      LDA.W $0DDA               
CODE_01AB05:        30 05         BMI CODE_01AB0C           
CODE_01AB07:        A9 0E         LDA.B #$0E                
CODE_01AB09:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_01AB0C:        A9 20         LDA.B #$20                
CODE_01AB0E:        9D 3E 16      STA.W $163E,X             
CODE_01AB11:        5E F6 15      LSR.W RAM_SpritePal,X     
CODE_01AB14:        1E F6 15      ASL.W RAM_SpritePal,X     
CODE_01AB17:        BC 1C 15      LDY.W $151C,X             
CODE_01AB1A:        A9 B0         LDA.B #$B0                
CODE_01AB1C:        99 AD 14      STA.W RAM_BluePowTimer,Y  
CODE_01AB1F:        A9 20         LDA.B #$20                ; \ Set ground shake timer 
CODE_01AB21:        8D 87 18      STA.W RAM_ShakeGrndTimer  ; / 
CODE_01AB24:        C0 01         CPY.B #$01                
CODE_01AB26:        D0 04         BNE Return01AB2C          
CODE_01AB28:        22 BD B9 02   JSL.L CODE_02B9BD         
Return01AB2C:       60            RTS                       ; Return 


DATA_01AB2D:                      .db $01,$00,$FF,$FF

CODE_01AB31:        64 7B         STZ RAM_MarioSpeedX       
CODE_01AB33:        20 30 AD      JSR.W SubHorizPos         
CODE_01AB36:        98            TYA                       
CODE_01AB37:        0A            ASL                       
CODE_01AB38:        A8            TAY                       
CODE_01AB39:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01AB3B:        A5 94         LDA RAM_MarioXPos         
CODE_01AB3D:        18            CLC                       
CODE_01AB3E:        79 2D AB      ADC.W DATA_01AB2D,Y       
CODE_01AB41:        85 94         STA RAM_MarioXPos         
CODE_01AB43:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return01AB45:       60            RTS                       ; Return 

CODE_01AB46:        5A            PHY                       
CODE_01AB47:        AD 97 16      LDA.W $1697               
CODE_01AB4A:        18            CLC                       
CODE_01AB4B:        7D 26 16      ADC.W $1626,X             
CODE_01AB4E:        EE 97 16      INC.W $1697               
CODE_01AB51:        A8            TAY                       
CODE_01AB52:        C8            INY                       
CODE_01AB53:        C0 08         CPY.B #$08                
CODE_01AB55:        B0 06         BCS CODE_01AB5D           
CODE_01AB57:        B9 1D A6      LDA.W Return01A61D,Y      
CODE_01AB5A:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_01AB5D:        98            TYA                       
CODE_01AB5E:        C9 08         CMP.B #$08                
CODE_01AB60:        90 02         BCC CODE_01AB64           
CODE_01AB62:        A9 08         LDA.B #$08                
CODE_01AB64:        22 E5 AC 02   JSL.L GivePoints          
CODE_01AB68:        7A            PLY                       
Return01AB69:       60            RTS                       ; Return 


DATA_01AB6A:                      .db $0C,$FC,$EC,$DC,$CC

CODE_01AB6F:        20 28 A7      JSR.W PlayKickSfx         
CODE_01AB72:        20 CB 80      JSR.W IsSprOffScreen      
CODE_01AB75:        D0 21         BNE Return01AB98          
CODE_01AB77:        5A            PHY                       
CODE_01AB78:        A0 03         LDY.B #$03                
CODE_01AB7A:        B9 C0 17      LDA.W $17C0,Y             
CODE_01AB7D:        F0 04         BEQ CODE_01AB83           
CODE_01AB7F:        88            DEY                       
CODE_01AB80:        10 F8         BPL CODE_01AB7A           
CODE_01AB82:        C8            INY                       
CODE_01AB83:        A9 02         LDA.B #$02                
CODE_01AB85:        99 C0 17      STA.W $17C0,Y             
CODE_01AB88:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01AB8A:        99 C8 17      STA.W $17C8,Y             
CODE_01AB8D:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01AB8F:        99 C4 17      STA.W $17C4,Y             
CODE_01AB92:        A9 08         LDA.B #$08                
CODE_01AB94:        99 CC 17      STA.W $17CC,Y             
CODE_01AB97:        7A            PLY                       
Return01AB98:       6B            RTL                       ; Return 

DisplayContactGfx:  20 CB 80      JSR.W IsSprOffScreen      
CODE_01AB9C:        D0 2D         BNE Return01ABCB          
CODE_01AB9E:        5A            PHY                       
CODE_01AB9F:        A0 03         LDY.B #$03                
CODE_01ABA1:        B9 C0 17      LDA.W $17C0,Y             
CODE_01ABA4:        F0 04         BEQ CODE_01ABAA           
CODE_01ABA6:        88            DEY                       
CODE_01ABA7:        10 F8         BPL CODE_01ABA1           
CODE_01ABA9:        C8            INY                       
CODE_01ABAA:        A9 02         LDA.B #$02                
CODE_01ABAC:        99 C0 17      STA.W $17C0,Y             
CODE_01ABAF:        A5 94         LDA RAM_MarioXPos         
CODE_01ABB1:        99 C8 17      STA.W $17C8,Y             
CODE_01ABB4:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01ABB7:        C9 01         CMP.B #$01                
CODE_01ABB9:        A9 14         LDA.B #$14                
CODE_01ABBB:        90 02         BCC CODE_01ABBF           
CODE_01ABBD:        A9 1E         LDA.B #$1E                
CODE_01ABBF:        18            CLC                       
CODE_01ABC0:        65 96         ADC RAM_MarioYPos         
CODE_01ABC2:        99 C4 17      STA.W $17C4,Y             
CODE_01ABC5:        A9 08         LDA.B #$08                
CODE_01ABC7:        99 CC 17      STA.W $17CC,Y             
CODE_01ABCA:        7A            PLY                       
Return01ABCB:       6B            RTL                       ; Return 

SubSprXPosNoGrvty:  8A            TXA                       
CODE_01ABCD:        18            CLC                       
CODE_01ABCE:        69 0C         ADC.B #$0C                
CODE_01ABD0:        AA            TAX                       
CODE_01ABD1:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01ABD4:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return01ABD7:       60            RTS                       ; Return 

SubSprYPosNoGrvty:  B5 AA         LDA RAM_SpriteSpeedY,X    ; Load current sprite's Y speed 
CODE_01ABDA:        F0 2D         BEQ CODE_01AC09           ; If speed is 0, branch to $AC09 
CODE_01ABDC:        0A            ASL                       ; \  
CODE_01ABDD:        0A            ASL                       ;  |Multiply speed by 16 
CODE_01ABDE:        0A            ASL                       ;  | 
CODE_01ABDF:        0A            ASL                       ; /  
CODE_01ABE0:        18            CLC                       ; \  
CODE_01ABE1:        7D EC 14      ADC.W $14EC,X             ;  |Increase (unknown sprite table) by that value 
CODE_01ABE4:        9D EC 14      STA.W $14EC,X             ; /  
CODE_01ABE7:        08            PHP                       
CODE_01ABE8:        08            PHP                       
CODE_01ABE9:        A0 00         LDY.B #$00                
CODE_01ABEB:        B5 AA         LDA RAM_SpriteSpeedY,X    ; Load current sprite's Y speed 
CODE_01ABED:        4A            LSR                       ; \  
CODE_01ABEE:        4A            LSR                       ;  |Multiply speed by 16 
CODE_01ABEF:        4A            LSR                       ;  | 
CODE_01ABF0:        4A            LSR                       ; /  
CODE_01ABF1:        C9 08         CMP.B #$08                
CODE_01ABF3:        90 03         BCC CODE_01ABF8           
CODE_01ABF5:        09 F0         ORA.B #$F0                
CODE_01ABF7:        88            DEY                       
CODE_01ABF8:        28            PLP                       
CODE_01ABF9:        48            PHA                       
CODE_01ABFA:        75 D8         ADC RAM_SpriteYLo,X       ; \ Add value to current sprite's Y position 
CODE_01ABFC:        95 D8         STA RAM_SpriteYLo,X       ; /  
CODE_01ABFE:        98            TYA                       
CODE_01ABFF:        7D D4 14      ADC.W RAM_SpriteYHi,X     
CODE_01AC02:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01AC05:        68            PLA                       
CODE_01AC06:        28            PLP                       
CODE_01AC07:        69 00         ADC.B #$00                
CODE_01AC09:        8D 91 14      STA.W $1491               
Return01AC0C:       60            RTS                       ; Return 


SpriteOffScreen1:                 .db $40,$B0

SpriteOffScreen2:                 .db $01,$FF

SpriteOffScreen3:                 .db $30,$C0,$A0,$C0,$A0,$F0,$60,$90
SpriteOffScreen4:                 .db $01,$FF,$01,$FF,$01,$FF,$01,$FF

SubOffscreen3Bnk1:  A9 06         LDA.B #$06                ; \ Entry point of routine determines value of $03 
CODE_01AC23:        85 03         STA $03                   ;  | 
CODE_01AC25:        80 06         BRA CODE_01AC2D           ;  | 

SubOffscreen2Bnk1:  A9 04         LDA.B #$04                ;  | 
CODE_01AC29:        80 02         BRA CODE_01AC2D           ;  | 

SubOffscreen1Bnk1:  A9 02         LDA.B #$02                ;  | 
CODE_01AC2D:        85 03         STA $03                   ;  | 
CODE_01AC2F:        80 02         BRA CODE_01AC33           ;  | 

SubOffscreen0Bnk1:  64 03         STZ $03                   ; / 
CODE_01AC33:        20 CB 80      JSR.W IsSprOffScreen      ; \ if sprite is not off screen, return                                       
CODE_01AC36:        F0 6C         BEQ Return01ACA4          ; /                                                                           
CODE_01AC38:        A5 5B         LDA RAM_IsVerticalLvl     ; \  vertical level                                    
CODE_01AC3A:        29 01         AND.B #$01                ;  | 
CODE_01AC3C:        D0 67         BNE VerticalLevel         ; /                                                                           
CODE_01AC3E:        B5 D8         LDA RAM_SpriteYLo,X       ; \                                                                           
CODE_01AC40:        18            CLC                       ;  | 
CODE_01AC41:        69 50         ADC.B #$50                ;  | if the sprite has gone off the bottom of the level... 
CODE_01AC43:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | (if adding 0x50 to the sprite y position would make the high byte >= 2) 
CODE_01AC46:        69 00         ADC.B #$00                ;  | 
CODE_01AC48:        C9 02         CMP.B #$02                ;  | 
CODE_01AC4A:        10 34         BPL OffScrEraseSprite     ; /    ...erase the sprite                                                    
CODE_01AC4C:        BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ if "process offscreen" flag is set, return                                
CODE_01AC4F:        29 04         AND.B #$04                ;  | 
CODE_01AC51:        D0 51         BNE Return01ACA4          ; /                                                                           
CODE_01AC53:        A5 13         LDA RAM_FrameCounter      
CODE_01AC55:        29 01         AND.B #$01                
CODE_01AC57:        05 03         ORA $03                   
CODE_01AC59:        85 01         STA $01                   
CODE_01AC5B:        A8            TAY                       
CODE_01AC5C:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_01AC5E:        18            CLC                       
CODE_01AC5F:        79 11 AC      ADC.W SpriteOffScreen3,Y  
CODE_01AC62:        26 00         ROL $00                   
CODE_01AC64:        D5 E4         CMP RAM_SpriteXLo,X       
CODE_01AC66:        08            PHP                       
CODE_01AC67:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_01AC69:        46 00         LSR $00                   
CODE_01AC6B:        79 19 AC      ADC.W SpriteOffScreen4,Y  
CODE_01AC6E:        28            PLP                       
CODE_01AC6F:        FD E0 14      SBC.W RAM_SpriteXHi,X     
CODE_01AC72:        85 00         STA $00                   
CODE_01AC74:        46 01         LSR $01                   
CODE_01AC76:        90 04         BCC CODE_01AC7C           
CODE_01AC78:        49 80         EOR.B #$80                
CODE_01AC7A:        85 00         STA $00                   
CODE_01AC7C:        A5 00         LDA $00                   
CODE_01AC7E:        10 24         BPL Return01ACA4          
OffScrEraseSprite:  B5 9E         LDA RAM_SpriteNum,X       ; \ If MagiKoopa... 
CODE_01AC82:        C9 1F         CMP.B #$1F                ;  | 
CODE_01AC84:        D0 08         BNE CODE_01AC8E           ;  | Sprite to respawn = MagiKoopa 
CODE_01AC86:        8D C1 18      STA.W RAM_SpriteToRespawn ;  | 
CODE_01AC89:        A9 FF         LDA.B #$FF                ;  | Set timer until respawn 
CODE_01AC8B:        8D C0 18      STA.W RAM_TimeTillRespawn ; / 
CODE_01AC8E:        BD C8 14      LDA.W $14C8,X             ; \ If sprite status < 8, permanently erase sprite 
CODE_01AC91:        C9 08         CMP.B #$08                ;  | 
CODE_01AC93:        90 0C         BCC OffScrKillSprite      ; / 
CODE_01AC95:        BC 1A 16      LDY.W RAM_SprIndexInLvl,X ; \ Branch if should permanently erase sprite 
CODE_01AC98:        C0 FF         CPY.B #$FF                ;  | 
CODE_01AC9A:        F0 05         BEQ OffScrKillSprite      ; / 
CODE_01AC9C:        A9 00         LDA.B #$00                ; \ Allow sprite to be reloaded by level loading routine 
CODE_01AC9E:        99 38 19      STA.W RAM_SprLoadStatus,Y ; / 
OffScrKillSprite:   9E C8 14      STZ.W $14C8,X             ; Erase sprite 
Return01ACA4:       60            RTS                       

VerticalLevel:      BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ If "process offscreen" flag is set, return                
CODE_01ACA8:        29 04         AND.B #$04                ;  | 
CODE_01ACAA:        D0 F8         BNE Return01ACA4          ; /                                                           
CODE_01ACAC:        A5 13         LDA RAM_FrameCounter      ; \ Return every other frame 
CODE_01ACAE:        4A            LSR                       ;  | 
CODE_01ACAF:        B0 F3         BCS Return01ACA4          ; /                                                           
CODE_01ACB1:        B5 E4         LDA RAM_SpriteXLo,X       ; \                                                           
CODE_01ACB3:        C9 00         CMP.B #$00                ;  | If the sprite has gone off the side of the level...      
CODE_01ACB5:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  |                                                          
CODE_01ACB8:        E9 00         SBC.B #$00                ;  |                                                          
CODE_01ACBA:        C9 02         CMP.B #$02                ;  |                                                          
CODE_01ACBC:        B0 C2         BCS OffScrEraseSprite     ; /  ...erase the sprite      
CODE_01ACBE:        A5 13         LDA RAM_FrameCounter      
CODE_01ACC0:        4A            LSR                       
CODE_01ACC1:        29 01         AND.B #$01                
CODE_01ACC3:        85 01         STA $01                   
CODE_01ACC5:        A8            TAY                       
CODE_01ACC6:        F0 0A         BEQ CODE_01ACD2           
CODE_01ACC8:        B5 9E         LDA RAM_SpriteNum,X       ; \ Return if Green Net Koopa 
CODE_01ACCA:        C9 22         CMP.B #$22                ;  | 
CODE_01ACCC:        F0 D6         BEQ Return01ACA4          ;  | 
CODE_01ACCE:        C9 24         CMP.B #$24                ;  | 
CODE_01ACD0:        F0 D2         BEQ Return01ACA4          ; / 
CODE_01ACD2:        A5 1C         LDA RAM_ScreenBndryYLo    
CODE_01ACD4:        18            CLC                       
CODE_01ACD5:        79 0D AC      ADC.W SpriteOffScreen1,Y  
CODE_01ACD8:        26 00         ROL $00                   
CODE_01ACDA:        D5 D8         CMP RAM_SpriteYLo,X       
CODE_01ACDC:        08            PHP                       
CODE_01ACDD:        AD 1D 00      LDA.W RAM_ScreenBndryYHi  
CODE_01ACE0:        46 00         LSR $00                   
CODE_01ACE2:        79 0F AC      ADC.W SpriteOffScreen2,Y  
CODE_01ACE5:        28            PLP                       
CODE_01ACE6:        FD D4 14      SBC.W RAM_SpriteYHi,X     
CODE_01ACE9:        85 00         STA $00                   
CODE_01ACEB:        A4 01         LDY $01                   
CODE_01ACED:        F0 04         BEQ CODE_01ACF3           
CODE_01ACEF:        49 80         EOR.B #$80                
CODE_01ACF1:        85 00         STA $00                   
CODE_01ACF3:        A5 00         LDA $00                   
CODE_01ACF5:        10 AD         BPL Return01ACA4          
CODE_01ACF7:        30 87         BMI OffScrEraseSprite     
GetRand:            5A            PHY                       
CODE_01ACFA:        A0 01         LDY.B #$01                
CODE_01ACFC:        22 07 AD 01   JSL.L CODE_01AD07         
CODE_01AD00:        88            DEY                       
CODE_01AD01:        22 07 AD 01   JSL.L CODE_01AD07         
CODE_01AD05:        7A            PLY                       
Return01AD06:       6B            RTL                       ; Return 

CODE_01AD07:        AD 8B 14      LDA.W $148B               
CODE_01AD0A:        0A            ASL                       
CODE_01AD0B:        0A            ASL                       
CODE_01AD0C:        38            SEC                       
CODE_01AD0D:        6D 8B 14      ADC.W $148B               
CODE_01AD10:        8D 8B 14      STA.W $148B               
CODE_01AD13:        0E 8C 14      ASL.W $148C               
CODE_01AD16:        A9 20         LDA.B #$20                
CODE_01AD18:        2C 8C 14      BIT.W $148C               
CODE_01AD1B:        90 04         BCC CODE_01AD21           
CODE_01AD1D:        F0 07         BEQ CODE_01AD26           
CODE_01AD1F:        D0 02         BNE CODE_01AD23           
CODE_01AD21:        D0 03         BNE CODE_01AD26           
CODE_01AD23:        EE 8C 14      INC.W $148C               
CODE_01AD26:        AD 8C 14      LDA.W $148C               
CODE_01AD29:        4D 8B 14      EOR.W $148B               
CODE_01AD2C:        99 8D 14      STA.W RAM_RandomByte1,Y   
Return01AD2F:       6B            RTL                       ; Return 

SubHorizPos:        A0 00         LDY.B #$00                
CODE_01AD32:        A5 D1         LDA $D1                   
CODE_01AD34:        38            SEC                       
CODE_01AD35:        F5 E4         SBC RAM_SpriteXLo,X       
CODE_01AD37:        85 0F         STA $0F                   
CODE_01AD39:        A5 D2         LDA $D2                   
CODE_01AD3B:        FD E0 14      SBC.W RAM_SpriteXHi,X     
CODE_01AD3E:        10 01         BPL Return01AD41          
CODE_01AD40:        C8            INY                       
Return01AD41:       60            RTS                       ; Return 

CODE_01AD42:        A0 00         LDY.B #$00                
CODE_01AD44:        A5 D3         LDA $D3                   
CODE_01AD46:        38            SEC                       
CODE_01AD47:        F5 D8         SBC RAM_SpriteYLo,X       
CODE_01AD49:        85 0E         STA $0E                   
CODE_01AD4B:        A5 D4         LDA $D4                   
CODE_01AD4D:        FD D4 14      SBC.W RAM_SpriteYHi,X     
CODE_01AD50:        10 01         BPL Return01AD53          
CODE_01AD52:        C8            INY                       
Return01AD53:       60            RTS                       ; Return 


DATA_01AD54:                      .db $FF,$FF,$FF,$FF,$FF

InitFlying?Block:   B5 E4         LDA RAM_SpriteXLo,X       
CODE_01AD5B:        4A            LSR                       
CODE_01AD5C:        4A            LSR                       
CODE_01AD5D:        4A            LSR                       
CODE_01AD5E:        4A            LSR                       
CODE_01AD5F:        29 03         AND.B #$03                
CODE_01AD61:        9D 1C 15      STA.W $151C,X             
CODE_01AD64:        FE 7C 15      INC.W RAM_SpriteDir,X     
Return01AD67:       60            RTS                       ; Return 


DATA_01AD68:                      .db $FF,$01

DATA_01AD6A:                      .db $F4,$0C

DATA_01AD6C:                      .db $F0,$10

Flying?Block:       BD 3E 16      LDA.W $163E,X             
CODE_01AD71:        F0 0D         BEQ CODE_01AD80           
CODE_01AD73:        9E EA 15      STZ.W RAM_SprOAMIndex,X   
CODE_01AD76:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01AD79:        D0 05         BNE CODE_01AD80           
CODE_01AD7B:        A9 04         LDA.B #$04                
CODE_01AD7D:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_01AD80:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01AD83:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01AD86:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_01AD89:        3A            DEC A                     
CODE_01AD8A:        99 01 03      STA.W OAM_DispY,Y         
CODE_01AD8D:        9E 28 15      STZ.W $1528,X             
CODE_01AD90:        B5 C2         LDA RAM_SpriteState,X     
CODE_01AD92:        D0 64         BNE CODE_01ADF8           
CODE_01AD94:        20 95 9E      JSR.W CODE_019E95         
CODE_01AD97:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01AD99:        D0 5D         BNE CODE_01ADF8           ; / 
CODE_01AD9B:        A5 13         LDA RAM_FrameCounter      
CODE_01AD9D:        29 01         AND.B #$01                
CODE_01AD9F:        D0 16         BNE CODE_01ADB7           
CODE_01ADA1:        BD 94 15      LDA.W $1594,X             
CODE_01ADA4:        29 01         AND.B #$01                
CODE_01ADA6:        A8            TAY                       
CODE_01ADA7:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01ADA9:        18            CLC                       
CODE_01ADAA:        79 68 AD      ADC.W DATA_01AD68,Y       
CODE_01ADAD:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01ADAF:        D9 6A AD      CMP.W DATA_01AD6A,Y       
CODE_01ADB2:        D0 03         BNE CODE_01ADB7           
CODE_01ADB4:        FE 94 15      INC.W $1594,X             
CODE_01ADB7:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01ADBA:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01ADBC:        C9 83         CMP.B #$83                
CODE_01ADBE:        F0 28         BEQ CODE_01ADE8           
CODE_01ADC0:        BD 40 15      LDA.W $1540,X             
CODE_01ADC3:        D0 21         BNE CODE_01ADE6           
CODE_01ADC5:        A5 13         LDA RAM_FrameCounter      
CODE_01ADC7:        29 03         AND.B #$03                
CODE_01ADC9:        D0 1B         BNE CODE_01ADE6           
CODE_01ADCB:        BD 34 15      LDA.W $1534,X             
CODE_01ADCE:        29 01         AND.B #$01                
CODE_01ADD0:        A8            TAY                       
CODE_01ADD1:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01ADD3:        18            CLC                       
CODE_01ADD4:        79 68 AD      ADC.W DATA_01AD68,Y       
CODE_01ADD7:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01ADD9:        D9 6C AD      CMP.W DATA_01AD6C,Y       
CODE_01ADDC:        D0 08         BNE CODE_01ADE6           
CODE_01ADDE:        FE 34 15      INC.W $1534,X             
CODE_01ADE1:        A9 20         LDA.B #$20                
CODE_01ADE3:        9D 40 15      STA.W $1540,X             
CODE_01ADE6:        80 04         BRA CODE_01ADEC           

CODE_01ADE8:        A9 F4         LDA.B #$F4                
CODE_01ADEA:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01ADEC:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01ADEF:        AD 91 14      LDA.W $1491               
CODE_01ADF2:        9D 28 15      STA.W $1528,X             
CODE_01ADF5:        FE 70 15      INC.W $1570,X             
CODE_01ADF8:        20 0D A4      JSR.W SubSprSprInteract   
CODE_01ADFB:        20 57 B4      JSR.W CODE_01B457         
CODE_01ADFE:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01AE01:        BD 58 15      LDA.W $1558,X             
CODE_01AE04:        C9 08         CMP.B #$08                
CODE_01AE06:        D0 56         BNE CODE_01AE5E           
CODE_01AE08:        B4 C2         LDY RAM_SpriteState,X     
CODE_01AE0A:        C0 02         CPY.B #$02                
CODE_01AE0C:        F0 50         BEQ CODE_01AE5E           
CODE_01AE0E:        48            PHA                       
CODE_01AE0F:        F6 C2         INC RAM_SpriteState,X     
CODE_01AE11:        A9 50         LDA.B #$50                
CODE_01AE13:        9D 3E 16      STA.W $163E,X             
CODE_01AE16:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01AE18:        85 9A         STA RAM_BlockYLo          
CODE_01AE1A:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01AE1D:        85 9B         STA RAM_BlockYHi          
CODE_01AE1F:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01AE21:        85 98         STA RAM_BlockXLo          
CODE_01AE23:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01AE26:        85 99         STA RAM_BlockXHi          
CODE_01AE28:        A9 FF         LDA.B #$FF                ; \ Set to permanently erase sprite 
CODE_01AE2A:        9D 1A 16      STA.W RAM_SprIndexInLvl,X ; / 
CODE_01AE2D:        BC 1C 15      LDY.W $151C,X             
CODE_01AE30:        A5 19         LDA RAM_MarioPowerUp      
CODE_01AE32:        D0 04         BNE CODE_01AE38           
CODE_01AE34:        C8            INY                       
CODE_01AE35:        C8            INY                       
CODE_01AE36:        C8            INY                       
CODE_01AE37:        C8            INY                       
CODE_01AE38:        B9 88 AE      LDA.W DATA_01AE88,Y       
CODE_01AE3B:        85 05         STA $05                   
CODE_01AE3D:        8B            PHB                       
CODE_01AE3E:        A9 02         LDA.B #$02                
CODE_01AE40:        48            PHA                       
CODE_01AE41:        AB            PLB                       
CODE_01AE42:        DA            PHX                       
CODE_01AE43:        22 7D 88 02   JSL.L CODE_02887D         
CODE_01AE47:        FA            PLX                       
CODE_01AE48:        AC 5E 18      LDY.W $185E               
CODE_01AE4B:        A9 01         LDA.B #$01                
CODE_01AE4D:        99 28 15      STA.W $1528,Y             
CODE_01AE50:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01AE53:        C9 75         CMP.B #$75                
CODE_01AE55:        D0 05         BNE CODE_01AE5C           
CODE_01AE57:        A9 FF         LDA.B #$FF                
CODE_01AE59:        99 C2 00      STA.W RAM_SpriteState,Y   
CODE_01AE5C:        AB            PLB                       
CODE_01AE5D:        68            PLA                       
CODE_01AE5E:        4A            LSR                       
CODE_01AE5F:        A8            TAY                       
CODE_01AE60:        B9 7F AE      LDA.W DATA_01AE7F,Y       
CODE_01AE63:        85 00         STA $00                   
CODE_01AE65:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01AE68:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_01AE6B:        38            SEC                       
CODE_01AE6C:        E5 00         SBC $00                   
CODE_01AE6E:        99 01 03      STA.W OAM_DispY,Y         
CODE_01AE71:        B5 C2         LDA RAM_SpriteState,X     
CODE_01AE73:        C9 01         CMP.B #$01                
CODE_01AE75:        A9 2A         LDA.B #$2A                
CODE_01AE77:        90 02         BCC CODE_01AE7B           
CODE_01AE79:        A9 2E         LDA.B #$2E                
CODE_01AE7B:        99 02 03      STA.W OAM_Tile,Y          
Return01AE7E:       60            RTS                       ; Return 


DATA_01AE7F:                      .db $00,$03,$05,$07,$08,$08,$07,$05
                                  .db $03

DATA_01AE88:                      .db $06,$02,$04,$05,$06,$01,$01,$05

Return01AE90:       60            RTS                       

PalaceSwitch:       22 2D CD 02   JSL.L CODE_02CD2D         
Return01AE95:       60            RTS                       ; Return 

InitThwomp:         B5 D8         LDA RAM_SpriteYLo,X       
CODE_01AE98:        9D 1C 15      STA.W $151C,X             
CODE_01AE9B:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01AE9D:        18            CLC                       
CODE_01AE9E:        69 08         ADC.B #$08                
CODE_01AEA0:        95 E4         STA RAM_SpriteXLo,X       
Return01AEA2:       60            RTS                       

Thwomp:             20 54 AF      JSR.W ThwompGfx           
CODE_01AEA6:        BD C8 14      LDA.W $14C8,X             
CODE_01AEA9:        C9 08         CMP.B #$08                
CODE_01AEAB:        D0 F5         BNE Return01AEA2          
CODE_01AEAD:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01AEAF:        D0 F1         BNE Return01AEA2          ; / 
CODE_01AEB1:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01AEB4:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01AEB7:        B5 C2         LDA RAM_SpriteState,X     
CODE_01AEB9:        22 DF 86 00   JSL.L ExecutePtr          

ThwompStatePtrs:       C3 AE      .dw CODE_01AEC3           
                       FA AE      .dw CODE_01AEFA           
                       24 AF      .dw CODE_01AF24           

CODE_01AEC3:        BD 6C 18      LDA.W RAM_OffscreenVert,X 
CODE_01AEC6:        D0 26         BNE CODE_01AEEE           
CODE_01AEC8:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_01AECB:        D0 2C         BNE Return01AEF9          
CODE_01AECD:        20 30 AD      JSR.W SubHorizPos         
CODE_01AED0:        98            TYA                       
CODE_01AED1:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01AED4:        9E 28 15      STZ.W $1528,X             
CODE_01AED7:        A5 0F         LDA $0F                   
CODE_01AED9:        18            CLC                       
CODE_01AEDA:        69 40         ADC.B #$40                
CODE_01AEDC:        C9 80         CMP.B #$80                
CODE_01AEDE:        B0 05         BCS CODE_01AEE5           
CODE_01AEE0:        A9 01         LDA.B #$01                
CODE_01AEE2:        9D 28 15      STA.W $1528,X             
CODE_01AEE5:        A5 0F         LDA $0F                   
CODE_01AEE7:        18            CLC                       
CODE_01AEE8:        69 24         ADC.B #$24                
CODE_01AEEA:        C9 50         CMP.B #$50                
CODE_01AEEC:        B0 0B         BCS Return01AEF9          
CODE_01AEEE:        A9 02         LDA.B #$02                
CODE_01AEF0:        9D 28 15      STA.W $1528,X             
CODE_01AEF3:        F6 C2         INC RAM_SpriteState,X     
CODE_01AEF5:        A9 00         LDA.B #$00                
CODE_01AEF7:        95 AA         STA RAM_SpriteSpeedY,X    
Return01AEF9:       60            RTS                       ; Return 

CODE_01AEFA:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01AEFD:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01AEFF:        C9 3E         CMP.B #$3E                
CODE_01AF01:        B0 04         BCS CODE_01AF07           
CODE_01AF03:        69 04         ADC.B #$04                
CODE_01AF05:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01AF07:        20 40 91      JSR.W CODE_019140         
CODE_01AF0A:        20 0E 80      JSR.W IsOnGround          
CODE_01AF0D:        F0 14         BEQ Return01AF23          
CODE_01AF0F:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_01AF12:        A9 18         LDA.B #$18                ; \ Set ground shake timer 
CODE_01AF14:        8D 87 18      STA.W RAM_ShakeGrndTimer  ; / 
CODE_01AF17:        A9 09         LDA.B #$09                
CODE_01AF19:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
CODE_01AF1C:        A9 40         LDA.B #$40                
CODE_01AF1E:        9D 40 15      STA.W $1540,X             
CODE_01AF21:        F6 C2         INC RAM_SpriteState,X     
Return01AF23:       60            RTS                       ; Return 

CODE_01AF24:        BD 40 15      LDA.W $1540,X             
CODE_01AF27:        D0 16         BNE Return01AF3F          
CODE_01AF29:        9E 28 15      STZ.W $1528,X             
CODE_01AF2C:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01AF2E:        DD 1C 15      CMP.W $151C,X             
CODE_01AF31:        D0 05         BNE CODE_01AF38           
CODE_01AF33:        A9 00         LDA.B #$00                
CODE_01AF35:        95 C2         STA RAM_SpriteState,X     
Return01AF37:       60            RTS                       ; Return 

CODE_01AF38:        A9 F0         LDA.B #$F0                
CODE_01AF3A:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01AF3C:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
Return01AF3F:       60            RTS                       ; Return 


ThwompDispX:                      .db $FC,$04,$FC,$04,$00

ThwompDispY:                      .db $00,$00,$10,$10,$08

ThwompTiles:                      .db $8E,$8E,$AE,$AE,$C8

ThwompGfxProp:                    .db $03,$43,$03,$43,$03

ThwompGfx:          20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01AF57:        BD 28 15      LDA.W $1528,X             
CODE_01AF5A:        85 02         STA $02                   
CODE_01AF5C:        DA            PHX                       
CODE_01AF5D:        A2 03         LDX.B #$03                
CODE_01AF5F:        C9 00         CMP.B #$00                
CODE_01AF61:        F0 01         BEQ CODE_01AF64           
CODE_01AF63:        E8            INX                       
CODE_01AF64:        A5 00         LDA $00                   
CODE_01AF66:        18            CLC                       
CODE_01AF67:        7D 40 AF      ADC.W ThwompDispX,X       
CODE_01AF6A:        99 00 03      STA.W OAM_DispX,Y         
CODE_01AF6D:        A5 01         LDA $01                   
CODE_01AF6F:        18            CLC                       
CODE_01AF70:        7D 45 AF      ADC.W ThwompDispY,X       
CODE_01AF73:        99 01 03      STA.W OAM_DispY,Y         
CODE_01AF76:        BD 4F AF      LDA.W ThwompGfxProp,X     
CODE_01AF79:        05 64         ORA $64                   
CODE_01AF7B:        99 03 03      STA.W OAM_Prop,Y          
CODE_01AF7E:        BD 4A AF      LDA.W ThwompTiles,X       
CODE_01AF81:        E0 04         CPX.B #$04                
CODE_01AF83:        D0 0A         BNE CODE_01AF8F           
CODE_01AF85:        DA            PHX                       
CODE_01AF86:        A6 02         LDX $02                   
CODE_01AF88:        E0 02         CPX.B #$02                
CODE_01AF8A:        D0 02         BNE CODE_01AF8E           
CODE_01AF8C:        A9 CA         LDA.B #$CA                
CODE_01AF8E:        FA            PLX                       
CODE_01AF8F:        99 02 03      STA.W OAM_Tile,Y          
CODE_01AF92:        C8            INY                       
CODE_01AF93:        C8            INY                       
CODE_01AF94:        C8            INY                       
CODE_01AF95:        C8            INY                       
CODE_01AF96:        CA            DEX                       
CODE_01AF97:        10 CB         BPL CODE_01AF64           
CODE_01AF99:        FA            PLX                       
CODE_01AF9A:        A9 04         LDA.B #$04                
CODE_01AF9C:        4C 7E B3      JMP.W CODE_01B37E         

Thwimp:             BD C8 14      LDA.W $14C8,X             
CODE_01AFA2:        C9 08         CMP.B #$08                
CODE_01AFA4:        D0 60         BNE CODE_01B006           
CODE_01AFA6:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01AFA8:        D0 5C         BNE CODE_01B006           ; / 
CODE_01AFAA:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01AFAD:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01AFB0:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01AFB3:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01AFB6:        20 40 91      JSR.W CODE_019140         
CODE_01AFB9:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01AFBB:        30 06         BMI CODE_01AFC3           
CODE_01AFBD:        C9 40         CMP.B #$40                
CODE_01AFBF:        B0 07         BCS CODE_01AFC8           
CODE_01AFC1:        69 05         ADC.B #$05                
CODE_01AFC3:        18            CLC                       
CODE_01AFC4:        69 03         ADC.B #$03                
CODE_01AFC6:        80 02         BRA CODE_01AFCA           

CODE_01AFC8:        A9 40         LDA.B #$40                
CODE_01AFCA:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01AFCC:        20 14 80      JSR.W IsTouchingCeiling   ; \ If touching ceiling, 
CODE_01AFCF:        F0 04         BEQ CODE_01AFD5           ;  | 
CODE_01AFD1:        A9 10         LDA.B #$10                ;  | Y speed = #$10 
CODE_01AFD3:        95 AA         STA RAM_SpriteSpeedY,X    ; / 
CODE_01AFD5:        20 0E 80      JSR.W IsOnGround          
CODE_01AFD8:        F0 2C         BEQ CODE_01B006           
CODE_01AFDA:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_01AFDD:        74 B6         STZ RAM_SpriteSpeedX,X    ; \ Sprite Speed = 0 
CODE_01AFDF:        74 AA         STZ RAM_SpriteSpeedY,X    ; / 
CODE_01AFE1:        BD 40 15      LDA.W $1540,X             
CODE_01AFE4:        F0 16         BEQ CODE_01AFFC           
CODE_01AFE6:        3A            DEC A                     
CODE_01AFE7:        D0 1D         BNE CODE_01B006           
CODE_01AFE9:        A9 A0         LDA.B #$A0                
CODE_01AFEB:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01AFED:        F6 C2         INC RAM_SpriteState,X     
CODE_01AFEF:        B5 C2         LDA RAM_SpriteState,X     
CODE_01AFF1:        4A            LSR                       
CODE_01AFF2:        A9 10         LDA.B #$10                
CODE_01AFF4:        90 02         BCC CODE_01AFF8           
CODE_01AFF6:        A9 F0         LDA.B #$F0                
CODE_01AFF8:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01AFFA:        80 0A         BRA CODE_01B006           

CODE_01AFFC:        A9 01         LDA.B #$01                
CODE_01AFFE:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_01B001:        A9 40         LDA.B #$40                
CODE_01B003:        9D 40 15      STA.W $1540,X             
CODE_01B006:        A9 01         LDA.B #$01                
CODE_01B008:        4C F3 9C      JMP.W SubSprGfx0Entry0    

InitVerticalFish:   20 7C 85      JSR.W FaceMario           
CODE_01B00E:        FE 1C 15      INC.W $151C,X             
Return01B011:       60            RTS                       


DATA_01B012:                      .db $10,$F0

InitFish:           20 30 AD      JSR.W SubHorizPos         
CODE_01B017:        B9 12 B0      LDA.W DATA_01B012,Y       
CODE_01B01A:        95 B6         STA RAM_SpriteSpeedX,X    
Return01B01C:       60            RTS                       ; Return 


DATA_01B01D:                      .db $08,$F8

DATA_01B01F:                      .db $00,$00,$08,$F8

DATA_01B023:                      .db $F0,$10

DATA_01B025:                      .db $E0,$E8,$D0,$D8

DATA_01B029:                      .db $08,$F8,$10,$F0,$04,$FC,$14,$EC
DATA_01B031:                      .db $03,$0C

Fish:               BD C8 14      LDA.W $14C8,X             
CODE_01B036:        C9 08         CMP.B #$08                
CODE_01B038:        D0 04         BNE CODE_01B03E           
CODE_01B03A:        A5 9D         LDA RAM_SpritesLocked     
CODE_01B03C:        F0 03         BEQ CODE_01B041           
CODE_01B03E:        4C 0A B1      JMP.W CODE_01B10A         

CODE_01B041:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01B044:        BD 4A 16      LDA.W $164A,X             
CODE_01B047:        D0 5E         BNE CODE_01B0A7           
CODE_01B049:        20 32 90      JSR.W SubUpdateSprPos     
CODE_01B04C:        20 08 80      JSR.W IsTouchingObjSide   
CODE_01B04F:        F0 03         BEQ CODE_01B054           
CODE_01B051:        20 98 90      JSR.W FlipSpriteDir       
CODE_01B054:        20 0E 80      JSR.W IsOnGround          
CODE_01B057:        F0 43         BEQ CODE_01B09C           
CODE_01B059:        AD 0E 19      LDA.W $190E               
CODE_01B05C:        F0 04         BEQ CODE_01B062           
CODE_01B05E:        22 BC 84 02   JSL.L CODE_0284BC         
CODE_01B062:        22 F9 AC 01   JSL.L GetRand             
CODE_01B066:        65 13         ADC RAM_FrameCounter      
CODE_01B068:        29 07         AND.B #$07                
CODE_01B06A:        A8            TAY                       
CODE_01B06B:        B9 29 B0      LDA.W DATA_01B029,Y       
CODE_01B06E:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01B070:        22 F9 AC 01   JSL.L GetRand             
CODE_01B074:        AD 8E 14      LDA.W RAM_RandomByte2     
CODE_01B077:        29 03         AND.B #$03                
CODE_01B079:        A8            TAY                       
CODE_01B07A:        B9 25 B0      LDA.W DATA_01B025,Y       
CODE_01B07D:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01B07F:        AD 8D 14      LDA.W RAM_RandomByte1     
CODE_01B082:        29 40         AND.B #$40                
CODE_01B084:        D0 08         BNE CODE_01B08E           
CODE_01B086:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01B089:        49 80         EOR.B #$80                
CODE_01B08B:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01B08E:        22 F9 AC 01   JSL.L GetRand             
CODE_01B092:        AD 8D 14      LDA.W RAM_RandomByte1     
CODE_01B095:        29 80         AND.B #$80                
CODE_01B097:        D0 03         BNE CODE_01B09C           
CODE_01B099:        20 15 9A      JSR.W UpdateDirection     
CODE_01B09C:        BD 02 16      LDA.W $1602,X             
CODE_01B09F:        18            CLC                       
CODE_01B0A0:        69 02         ADC.B #$02                
CODE_01B0A2:        9D 02 16      STA.W $1602,X             
CODE_01B0A5:        80 43         BRA CODE_01B0EA           

CODE_01B0A7:        20 40 91      JSR.W CODE_019140         
CODE_01B0AA:        20 15 9A      JSR.W UpdateDirection     
CODE_01B0AD:        1E F6 15      ASL.W RAM_SpritePal,X     
CODE_01B0B0:        5E F6 15      LSR.W RAM_SpritePal,X     
CODE_01B0B3:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_01B0B6:        BC 1C 15      LDY.W $151C,X             
CODE_01B0B9:        39 31 B0      AND.W DATA_01B031,Y       
CODE_01B0BC:        D0 05         BNE CODE_01B0C3           
CODE_01B0BE:        BD 40 15      LDA.W $1540,X             
CODE_01B0C1:        D0 07         BNE CODE_01B0CA           
CODE_01B0C3:        A9 80         LDA.B #$80                
CODE_01B0C5:        9D 40 15      STA.W $1540,X             
CODE_01B0C8:        F6 C2         INC RAM_SpriteState,X     
CODE_01B0CA:        B5 C2         LDA RAM_SpriteState,X     
CODE_01B0CC:        29 01         AND.B #$01                
CODE_01B0CE:        A8            TAY                       
CODE_01B0CF:        BD 1C 15      LDA.W $151C,X             
CODE_01B0D2:        F0 02         BEQ CODE_01B0D6           
CODE_01B0D4:        C8            INY                       
CODE_01B0D5:        C8            INY                       
CODE_01B0D6:        B9 1D B0      LDA.W DATA_01B01D,Y       
CODE_01B0D9:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01B0DB:        B9 1F B0      LDA.W DATA_01B01F,Y       
CODE_01B0DE:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01B0E0:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01B0E3:        29 0C         AND.B #$0C                
CODE_01B0E5:        D0 03         BNE CODE_01B0EA           
CODE_01B0E7:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01B0EA:        20 0D A4      JSR.W SubSprSprInteract   
CODE_01B0ED:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01B0F0:        90 18         BCC CODE_01B10A           
CODE_01B0F2:        BD 4A 16      LDA.W $164A,X             
CODE_01B0F5:        F0 10         BEQ CODE_01B107           
CODE_01B0F7:        AD 90 14      LDA.W $1490               ; \ Branch if Mario has star 
CODE_01B0FA:        D0 0B         BNE CODE_01B107           ; / 
CODE_01B0FC:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01B0FF:        D0 09         BNE CODE_01B10A           
CODE_01B101:        22 B7 F5 00   JSL.L HurtMario           
CODE_01B105:        80 03         BRA CODE_01B10A           

CODE_01B107:        20 2A B1      JSR.W CODE_01B12A         
CODE_01B10A:        BD 02 16      LDA.W $1602,X             
CODE_01B10D:        4A            LSR                       
CODE_01B10E:        49 01         EOR.B #$01                
CODE_01B110:        85 00         STA $00                   
CODE_01B112:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01B115:        29 FE         AND.B #$FE                
CODE_01B117:        05 00         ORA $00                   
CODE_01B119:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01B11C:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01B11F:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01B122:        5E F6 15      LSR.W RAM_SpritePal,X     
CODE_01B125:        38            SEC                       
CODE_01B126:        3E F6 15      ROL.W RAM_SpritePal,X     
Return01B129:       60            RTS                       ; Return 

CODE_01B12A:        A9 10         LDA.B #$10                
CODE_01B12C:        8D 9A 14      STA.W RAM_KickImgTimer    
CODE_01B12F:        A9 03         LDA.B #$03                
CODE_01B131:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_01B134:        20 30 AD      JSR.W SubHorizPos         
CODE_01B137:        B9 23 B0      LDA.W DATA_01B023,Y       
CODE_01B13A:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01B13C:        A9 E0         LDA.B #$E0                
CODE_01B13E:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01B140:        A9 02         LDA.B #$02                ; \ Sprite status = Killed 
CODE_01B142:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01B145:        84 76         STY RAM_MarioDirection    
CODE_01B147:        A9 01         LDA.B #$01                
CODE_01B149:        22 E5 AC 02   JSL.L GivePoints          
Return01B14D:       60            RTS                       ; Return 

CODE_01B14E:        A5 13         LDA RAM_FrameCounter      
CODE_01B150:        29 03         AND.B #$03                
CODE_01B152:        1D 6C 18      ORA.W RAM_OffscreenVert,X 
CODE_01B155:        05 9D         ORA RAM_SpritesLocked     
CODE_01B157:        D0 38         BNE Return01B191          
CODE_01B159:        22 F9 AC 01   JSL.L GetRand             
CODE_01B15D:        29 0F         AND.B #$0F                
CODE_01B15F:        18            CLC                       
CODE_01B160:        A0 00         LDY.B #$00                
CODE_01B162:        69 FC         ADC.B #$FC                
CODE_01B164:        10 01         BPL CODE_01B167           
CODE_01B166:        88            DEY                       
CODE_01B167:        18            CLC                       
CODE_01B168:        75 E4         ADC RAM_SpriteXLo,X       
CODE_01B16A:        85 02         STA $02                   
CODE_01B16C:        98            TYA                       
CODE_01B16D:        7D E0 14      ADC.W RAM_SpriteXHi,X     
CODE_01B170:        48            PHA                       
CODE_01B171:        A5 02         LDA $02                   
CODE_01B173:        C5 1A         CMP RAM_ScreenBndryXLo    
CODE_01B175:        68            PLA                       
CODE_01B176:        E5 1B         SBC RAM_ScreenBndryXHi    
CODE_01B178:        D0 17         BNE Return01B191          
CODE_01B17A:        AD 8E 14      LDA.W RAM_RandomByte2     
CODE_01B17D:        29 0F         AND.B #$0F                
CODE_01B17F:        18            CLC                       
CODE_01B180:        69 FE         ADC.B #$FE                
CODE_01B182:        75 D8         ADC RAM_SpriteYLo,X       
CODE_01B184:        85 00         STA $00                   
CODE_01B186:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01B189:        69 00         ADC.B #$00                
CODE_01B18B:        85 01         STA $01                   
CODE_01B18D:        22 BA 85 02   JSL.L CODE_0285BA         
Return01B191:       60            RTS                       ; Return 

GeneratedFish:      20 09 B2      JSR.W CODE_01B209         
CODE_01B195:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01B197:        D0 17         BNE Return01B1B0          ; / 
CODE_01B199:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01B19C:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01B19F:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01B1A2:        20 40 91      JSR.W CODE_019140         
CODE_01B1A5:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01B1A7:        C9 20         CMP.B #$20                
CODE_01B1A9:        10 03         BPL CODE_01B1AE           
CODE_01B1AB:        18            CLC                       
CODE_01B1AC:        69 01         ADC.B #$01                
CODE_01B1AE:        95 AA         STA RAM_SpriteSpeedY,X    
Return01B1B0:       60            RTS                       ; Return 


DATA_01B1B1:                      .db $D0,$D0,$B0

JumpingFish:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01B1B6:        D0 51         BNE CODE_01B209           ; / 
CODE_01B1B8:        BD 4A 16      LDA.W $164A,X             
CODE_01B1BB:        9D 1C 15      STA.W $151C,X             
CODE_01B1BE:        20 32 90      JSR.W SubUpdateSprPos     
CODE_01B1C1:        BD 4A 16      LDA.W $164A,X             
CODE_01B1C4:        F0 24         BEQ CODE_01B1EA           
CODE_01B1C6:        B5 C2         LDA RAM_SpriteState,X     
CODE_01B1C8:        C9 03         CMP.B #$03                
CODE_01B1CA:        F0 12         BEQ CODE_01B1DE           
CODE_01B1CC:        F6 C2         INC RAM_SpriteState,X     
CODE_01B1CE:        A8            TAY                       
CODE_01B1CF:        B9 B1 B1      LDA.W DATA_01B1B1,Y       
CODE_01B1D2:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01B1D4:        A9 10         LDA.B #$10                
CODE_01B1D6:        9D 40 15      STA.W $1540,X             
CODE_01B1D9:        9E 4A 16      STZ.W $164A,X             
CODE_01B1DC:        80 28         BRA CODE_01B206           

CODE_01B1DE:        D6 AA         DEC RAM_SpriteSpeedY,X    
CODE_01B1E0:        A5 13         LDA RAM_FrameCounter      
CODE_01B1E2:        29 03         AND.B #$03                
CODE_01B1E4:        D0 02         BNE CODE_01B1E8           
CODE_01B1E6:        D6 AA         DEC RAM_SpriteSpeedY,X    
CODE_01B1E8:        80 1C         BRA CODE_01B206           

CODE_01B1EA:        FE 70 15      INC.W $1570,X             
CODE_01B1ED:        FE 70 15      INC.W $1570,X             
CODE_01B1F0:        DD 1C 15      CMP.W $151C,X             
CODE_01B1F3:        F0 11         BEQ CODE_01B206           
CODE_01B1F5:        A9 10         LDA.B #$10                
CODE_01B1F7:        9D 40 15      STA.W $1540,X             
CODE_01B1FA:        B5 C2         LDA RAM_SpriteState,X     
CODE_01B1FC:        C9 03         CMP.B #$03                
CODE_01B1FE:        D0 06         BNE CODE_01B206           
CODE_01B200:        74 C2         STZ RAM_SpriteState,X     
CODE_01B202:        A9 D0         LDA.B #$D0                
CODE_01B204:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01B206:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01B209:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  
CODE_01B20C:        20 15 9A      JSR.W UpdateDirection     
CODE_01B20F:        4C 0A B1      JMP.W CODE_01B10A         


DATA_01B212:                      .db $08,$F8,$10,$F0

InitFloatSpkBall:   20 7C 85      JSR.W FaceMario           
CODE_01B219:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01B21C:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01B21E:        29 10         AND.B #$10                
CODE_01B220:        F0 02         BEQ CODE_01B224           
CODE_01B222:        C8            INY                       
CODE_01B223:        C8            INY                       
CODE_01B224:        B9 12 B2      LDA.W DATA_01B212,Y       
CODE_01B227:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01B229:        80 0B         BRA InitFloatingPlat      

InitFallingPlat:    FE 02 16      INC.W $1602,X             
InitOrangePlat:     AD 0E 19      LDA.W $190E               
ADDR_01B231:        D0 03         BNE InitFloatingPlat      
ADDR_01B233:        F6 C2         INC RAM_SpriteState,X     
Return01B235:       60            RTS                       ; Return 

InitFloatingPlat:   A9 03         LDA.B #$03                
CODE_01B238:        9D 1C 15      STA.W $151C,X             
CODE_01B23B:        20 40 91      JSR.W CODE_019140         
CODE_01B23E:        BD 4A 16      LDA.W $164A,X             
CODE_01B241:        D0 1A         BNE Return01B25D          
CODE_01B243:        DE 1C 15      DEC.W $151C,X             
CODE_01B246:        30 1A         BMI CODE_01B262           
CODE_01B248:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01B24A:        18            CLC                       
CODE_01B24B:        69 08         ADC.B #$08                
CODE_01B24D:        95 D8         STA RAM_SpriteYLo,X       
CODE_01B24F:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01B252:        69 00         ADC.B #$00                
CODE_01B254:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01B257:        C9 02         CMP.B #$02                
CODE_01B259:        B0 02         BCS Return01B25D          
CODE_01B25B:        80 DE         BRA CODE_01B23B           

Return01B25D:       60            RTS                       

InitChckbrdPlat:    FE 02 16      INC.W $1602,X             
Return01B261:       60            RTS                       ; Return 

CODE_01B262:        A9 01         LDA.B #$01                ; \ Sprite status = Initialization 
CODE_01B264:        9D C8 14      STA.W $14C8,X             ; / 
Return01B267:       60            RTS                       


DATA_01B268:                      .db $FF,$01

DATA_01B26A:                      .db $F0,$10

Platforms:          20 D1 B2      JSR.W CODE_01B2D1         
CODE_01B26F:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01B271:        D0 4F         BNE Return01B2C2          ; / 
CODE_01B273:        BD 40 15      LDA.W $1540,X             
CODE_01B276:        D0 2D         BNE CODE_01B2A5           
CODE_01B278:        F6 C2         INC RAM_SpriteState,X     
CODE_01B27A:        B5 C2         LDA RAM_SpriteState,X     
CODE_01B27C:        29 03         AND.B #$03                
CODE_01B27E:        D0 25         BNE CODE_01B2A5           
CODE_01B280:        BD 1C 15      LDA.W $151C,X             
CODE_01B283:        29 01         AND.B #$01                
CODE_01B285:        A8            TAY                       
CODE_01B286:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01B288:        18            CLC                       
CODE_01B289:        79 68 B2      ADC.W DATA_01B268,Y       
CODE_01B28C:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01B28E:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01B290:        D9 6A B2      CMP.W DATA_01B26A,Y       
CODE_01B293:        D0 10         BNE CODE_01B2A5           
CODE_01B295:        FE 1C 15      INC.W $151C,X             
CODE_01B298:        A9 18         LDA.B #$18                
CODE_01B29A:        B4 9E         LDY RAM_SpriteNum,X       
CODE_01B29C:        C0 55         CPY.B #$55                
CODE_01B29E:        D0 02         BNE CODE_01B2A2           
CODE_01B2A0:        A9 08         LDA.B #$08                
CODE_01B2A2:        9D 40 15      STA.W $1540,X             
CODE_01B2A5:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01B2A7:        C9 57         CMP.B #$57                
CODE_01B2A9:        B0 05         BCS CODE_01B2B0           
CODE_01B2AB:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01B2AE:        80 06         BRA CODE_01B2B6           

CODE_01B2B0:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01B2B3:        9C 91 14      STZ.W $1491               
CODE_01B2B6:        AD 91 14      LDA.W $1491               
CODE_01B2B9:        9D 28 15      STA.W $1528,X             
CODE_01B2BC:        20 57 B4      JSR.W CODE_01B457         
CODE_01B2BF:        20 2B AC      JSR.W SubOffscreen1Bnk1   
Return01B2C2:       60            RTS                       ; Return 


DATA_01B2C3:                      .db $00,$01,$00,$01,$00,$00,$00,$00
                                  .db $01,$01,$00,$00,$00,$00

CODE_01B2D1:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01B2D3:        38            SEC                       
CODE_01B2D4:        E9 55         SBC.B #$55                
CODE_01B2D6:        A8            TAY                       
CODE_01B2D7:        B9 C3 B2      LDA.W DATA_01B2C3,Y       
CODE_01B2DA:        F0 03         BEQ CODE_01B2DF           
CODE_01B2DC:        4C 95 B3      JMP.W CODE_01B395         

CODE_01B2DF:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01B2E2:        BD 02 16      LDA.W $1602,X             
CODE_01B2E5:        85 01         STA $01                   
CODE_01B2E7:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01B2E9:        38            SEC                       
CODE_01B2EA:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01B2EC:        99 01 03      STA.W OAM_DispY,Y         
CODE_01B2EF:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_01B2F2:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_01B2F5:        A6 01         LDX $01                   
CODE_01B2F7:        F0 06         BEQ CODE_01B2FF           
CODE_01B2F9:        99 0D 03      STA.W OAM_Tile4DispY,Y    
CODE_01B2FC:        99 11 03      STA.W $0311,Y             
CODE_01B2FF:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01B302:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01B304:        38            SEC                       
CODE_01B305:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01B307:        99 00 03      STA.W OAM_DispX,Y         
CODE_01B30A:        18            CLC                       
CODE_01B30B:        69 10         ADC.B #$10                
CODE_01B30D:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_01B310:        18            CLC                       
CODE_01B311:        69 10         ADC.B #$10                
CODE_01B313:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_01B316:        A6 01         LDX $01                   
CODE_01B318:        F0 0C         BEQ CODE_01B326           
CODE_01B31A:        18            CLC                       
CODE_01B31B:        69 10         ADC.B #$10                
CODE_01B31D:        99 0C 03      STA.W OAM_Tile4DispX,Y    
CODE_01B320:        18            CLC                       
CODE_01B321:        69 10         ADC.B #$10                
CODE_01B323:        99 10 03      STA.W $0310,Y             
CODE_01B326:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01B329:        A5 01         LDA $01                   
CODE_01B32B:        F0 17         BEQ CODE_01B344           
CODE_01B32D:        A9 EA         LDA.B #$EA                
CODE_01B32F:        99 02 03      STA.W OAM_Tile,Y          
CODE_01B332:        A9 EB         LDA.B #$EB                
CODE_01B334:        99 06 03      STA.W OAM_Tile2,Y         
CODE_01B337:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_01B33A:        99 0E 03      STA.W OAM_Tile4,Y         
CODE_01B33D:        A9 EC         LDA.B #$EC                
CODE_01B33F:        99 12 03      STA.W $0312,Y             
CODE_01B342:        80 15         BRA CODE_01B359           

CODE_01B344:        A9 60         LDA.B #$60                
CODE_01B346:        99 02 03      STA.W OAM_Tile,Y          
CODE_01B349:        A9 61         LDA.B #$61                
CODE_01B34B:        99 06 03      STA.W OAM_Tile2,Y         
CODE_01B34E:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_01B351:        99 0E 03      STA.W OAM_Tile4,Y         
CODE_01B354:        A9 62         LDA.B #$62                
CODE_01B356:        99 12 03      STA.W $0312,Y             
CODE_01B359:        A5 64         LDA $64                   
CODE_01B35B:        1D F6 15      ORA.W RAM_SpritePal,X     
CODE_01B35E:        99 03 03      STA.W OAM_Prop,Y          
CODE_01B361:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_01B364:        99 0B 03      STA.W OAM_Tile3Prop,Y     
CODE_01B367:        99 0F 03      STA.W OAM_Tile4Prop,Y     
CODE_01B36A:        99 13 03      STA.W $0313,Y             
CODE_01B36D:        A5 01         LDA $01                   
CODE_01B36F:        D0 05         BNE CODE_01B376           
CODE_01B371:        A9 62         LDA.B #$62                
CODE_01B373:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_01B376:        A9 04         LDA.B #$04                
CODE_01B378:        A4 01         LDY $01                   
CODE_01B37A:        D0 02         BNE CODE_01B37E           
CODE_01B37C:        A9 02         LDA.B #$02                
CODE_01B37E:        A0 02         LDY.B #$02                
CODE_01B380:        4C BB B7      JMP.W FinishOAMWriteRt    


DiagPlatTiles:                    .db $CB,$E4,$CC,$E5,$CC,$E5,$CC,$E4
                                  .db $CB

FlyRockPlatTiles:                 .db $85,$88,$86,$89,$86,$89,$86,$88
                                  .db $85

CODE_01B395:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01B398:        5A            PHY                       
CODE_01B399:        A0 00         LDY.B #$00                
CODE_01B39B:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01B39D:        C9 5E         CMP.B #$5E                
CODE_01B39F:        D0 01         BNE CODE_01B3A2           
ADDR_01B3A1:        C8            INY                       
CODE_01B3A2:        84 00         STY $00                   
CODE_01B3A4:        7A            PLY                       
CODE_01B3A5:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01B3A7:        38            SEC                       
CODE_01B3A8:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01B3AA:        99 01 03      STA.W OAM_DispY,Y         
CODE_01B3AD:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_01B3B0:        99 11 03      STA.W $0311,Y             
CODE_01B3B3:        A6 00         LDX $00                   
CODE_01B3B5:        F0 06         BEQ CODE_01B3BD           
ADDR_01B3B7:        99 19 03      STA.W $0319,Y             
ADDR_01B3BA:        99 21 03      STA.W $0321,Y             
CODE_01B3BD:        18            CLC                       
CODE_01B3BE:        69 10         ADC.B #$10                
CODE_01B3C0:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_01B3C3:        99 0D 03      STA.W OAM_Tile4DispY,Y    
CODE_01B3C6:        A6 00         LDX $00                   
CODE_01B3C8:        F0 06         BEQ CODE_01B3D0           
ADDR_01B3CA:        99 15 03      STA.W $0315,Y             
ADDR_01B3CD:        99 1D 03      STA.W $031D,Y             
CODE_01B3D0:        A9 08         LDA.B #$08                
CODE_01B3D2:        A6 00         LDX $00                   
CODE_01B3D4:        D0 02         BNE CODE_01B3D8           
CODE_01B3D6:        A9 04         LDA.B #$04                
CODE_01B3D8:        85 01         STA $01                   
CODE_01B3DA:        3A            DEC A                     
CODE_01B3DB:        85 02         STA $02                   
CODE_01B3DD:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01B3E0:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01B3E3:        85 03         STA $03                   
CODE_01B3E5:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01B3E7:        C9 5B         CMP.B #$5B                
CODE_01B3E9:        A9 00         LDA.B #$00                
CODE_01B3EB:        B0 02         BCS CODE_01B3EF           
ADDR_01B3ED:        A9 09         LDA.B #$09                
CODE_01B3EF:        48            PHA                       
CODE_01B3F0:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01B3F2:        38            SEC                       
CODE_01B3F3:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01B3F5:        FA            PLX                       
CODE_01B3F6:        99 00 03      STA.W OAM_DispX,Y         
CODE_01B3F9:        18            CLC                       
CODE_01B3FA:        69 08         ADC.B #$08                
CODE_01B3FC:        48            PHA                       
CODE_01B3FD:        BD 83 B3      LDA.W DiagPlatTiles,X     
CODE_01B400:        99 02 03      STA.W OAM_Tile,Y          
CODE_01B403:        A5 64         LDA $64                   
CODE_01B405:        05 03         ORA $03                   
CODE_01B407:        DA            PHX                       
CODE_01B408:        A6 01         LDX $01                   
CODE_01B40A:        E4 02         CPX $02                   
CODE_01B40C:        FA            PLX                       
CODE_01B40D:        B0 02         BCS CODE_01B411           
CODE_01B40F:        09 40         ORA.B #$40                
CODE_01B411:        99 03 03      STA.W OAM_Prop,Y          
CODE_01B414:        68            PLA                       
CODE_01B415:        C8            INY                       
CODE_01B416:        C8            INY                       
CODE_01B417:        C8            INY                       
CODE_01B418:        C8            INY                       
CODE_01B419:        E8            INX                       
CODE_01B41A:        C6 01         DEC $01                   
CODE_01B41C:        10 D8         BPL CODE_01B3F6           
CODE_01B41E:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01B421:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01B424:        A5 00         LDA $00                   
CODE_01B426:        D0 1C         BNE CODE_01B444           
CODE_01B428:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01B42A:        C9 5B         CMP.B #$5B                
CODE_01B42C:        B0 0C         BCS CODE_01B43A           
ADDR_01B42E:        A9 85         LDA.B #$85                
ADDR_01B430:        99 12 03      STA.W $0312,Y             
ADDR_01B433:        A9 88         LDA.B #$88                
ADDR_01B435:        99 0E 03      STA.W OAM_Tile4,Y         
ADDR_01B438:        80 0A         BRA CODE_01B444           

CODE_01B43A:        A9 CB         LDA.B #$CB                
CODE_01B43C:        99 12 03      STA.W $0312,Y             
CODE_01B43F:        A9 E4         LDA.B #$E4                
CODE_01B441:        99 0E 03      STA.W OAM_Tile4,Y         
CODE_01B444:        A9 08         LDA.B #$08                
CODE_01B446:        A4 00         LDY $00                   
CODE_01B448:        D0 02         BNE CODE_01B44C           
CODE_01B44A:        A9 04         LDA.B #$04                
CODE_01B44C:        4C 7E B3      JMP.W CODE_01B37E         

InvisBlkMainRt:     8B            PHB                       
CODE_01B450:        4B            PHK                       
CODE_01B451:        AB            PLB                       
CODE_01B452:        20 57 B4      JSR.W CODE_01B457         
CODE_01B455:        AB            PLB                       
Return01B456:       6B            RTL                       ; Return 

CODE_01B457:        20 F7 A7      JSR.W ProcessInteract     
CODE_01B45A:        90 56         BCC CODE_01B4B2           
CODE_01B45C:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01B45E:        38            SEC                       
CODE_01B45F:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01B461:        85 00         STA $00                   
CODE_01B463:        A5 80         LDA $80                   
CODE_01B465:        18            CLC                       
CODE_01B466:        69 18         ADC.B #$18                
CODE_01B468:        C5 00         CMP $00                   
CODE_01B46A:        10 48         BPL CODE_01B4B4           
CODE_01B46C:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01B46E:        30 42         BMI CODE_01B4B2           
CODE_01B470:        A5 77         LDA RAM_MarioObjStatus    
CODE_01B472:        29 08         AND.B #$08                
CODE_01B474:        D0 3C         BNE CODE_01B4B2           
CODE_01B476:        A9 10         LDA.B #$10                
CODE_01B478:        85 7D         STA RAM_MarioSpeedY       
CODE_01B47A:        A9 01         LDA.B #$01                
CODE_01B47C:        8D 71 14      STA.W $1471               
CODE_01B47F:        A9 1F         LDA.B #$1F                
CODE_01B481:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_01B484:        F0 02         BEQ CODE_01B488           
CODE_01B486:        A9 2F         LDA.B #$2F                
CODE_01B488:        85 01         STA $01                   
CODE_01B48A:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01B48C:        38            SEC                       
CODE_01B48D:        E5 01         SBC $01                   
CODE_01B48F:        85 96         STA RAM_MarioYPos         
CODE_01B491:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01B494:        E9 00         SBC.B #$00                
CODE_01B496:        85 97         STA RAM_MarioYPosHi       
CODE_01B498:        A5 77         LDA RAM_MarioObjStatus    
CODE_01B49A:        29 03         AND.B #$03                
CODE_01B49C:        D0 12         BNE CODE_01B4B0           
CODE_01B49E:        A0 00         LDY.B #$00                
CODE_01B4A0:        BD 28 15      LDA.W $1528,X             
CODE_01B4A3:        10 01         BPL CODE_01B4A6           
CODE_01B4A5:        88            DEY                       
CODE_01B4A6:        18            CLC                       
CODE_01B4A7:        65 94         ADC RAM_MarioXPos         
CODE_01B4A9:        85 94         STA RAM_MarioXPos         
CODE_01B4AB:        98            TYA                       
CODE_01B4AC:        65 95         ADC RAM_MarioXPosHi       
CODE_01B4AE:        85 95         STA RAM_MarioXPosHi       
CODE_01B4B0:        38            SEC                       
Return01B4B1:       60            RTS                       ; Return 

CODE_01B4B2:        18            CLC                       
Return01B4B3:       60            RTS                       ; Return 

CODE_01B4B4:        BD 0F 19      LDA.W RAM_Tweaker190F,X   ; \ Branch if "Make Platform Passable" is set 
CODE_01B4B7:        4A            LSR                       ;  | 
CODE_01B4B8:        B0 F8         BCS CODE_01B4B2           ; / 
CODE_01B4BA:        A9 00         LDA.B #$00                
CODE_01B4BC:        A4 73         LDY RAM_IsDucking         
CODE_01B4BE:        D0 04         BNE CODE_01B4C4           
CODE_01B4C0:        A4 19         LDY RAM_MarioPowerUp      
CODE_01B4C2:        D0 02         BNE CODE_01B4C6           
CODE_01B4C4:        A9 08         LDA.B #$08                
CODE_01B4C6:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_01B4C9:        F0 02         BEQ CODE_01B4CD           
CODE_01B4CB:        69 08         ADC.B #$08                
CODE_01B4CD:        18            CLC                       
CODE_01B4CE:        65 80         ADC $80                   
CODE_01B4D0:        C5 00         CMP $00                   
CODE_01B4D2:        90 31         BCC CODE_01B505           
CODE_01B4D4:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01B4D6:        10 1F         BPL CODE_01B4F7           
CODE_01B4D8:        A9 10         LDA.B #$10                
CODE_01B4DA:        85 7D         STA RAM_MarioSpeedY       
CODE_01B4DC:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01B4DE:        C9 83         CMP.B #$83                
CODE_01B4E0:        90 10         BCC CODE_01B4F2           
CODE_01B4E2:        A9 0F         LDA.B #$0F                
CODE_01B4E4:        9D 64 15      STA.W $1564,X             
CODE_01B4E7:        B5 C2         LDA RAM_SpriteState,X     
CODE_01B4E9:        D0 07         BNE CODE_01B4F2           
CODE_01B4EB:        F6 C2         INC RAM_SpriteState,X     
CODE_01B4ED:        A9 10         LDA.B #$10                
CODE_01B4EF:        9D 58 15      STA.W $1558,X             
CODE_01B4F2:        A9 01         LDA.B #$01                
CODE_01B4F4:        8D F9 1D      STA.W $1DF9               ; / Play sound effect 
CODE_01B4F7:        18            CLC                       
Return01B4F8:       60            RTS                       ; Return 


DATA_01B4F9:                      .db $0E,$F1,$10,$E0,$1F,$F1

DATA_01B4FF:                      .db $00,$FF,$00,$FF,$00,$FF

CODE_01B505:        20 30 AD      JSR.W SubHorizPos         
CODE_01B508:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01B50A:        C9 A9         CMP.B #$A9                
CODE_01B50C:        F0 12         BEQ CODE_01B520           
CODE_01B50E:        C9 9C         CMP.B #$9C                
CODE_01B510:        F0 0C         BEQ CODE_01B51E           
CODE_01B512:        C9 BB         CMP.B #$BB                
CODE_01B514:        F0 08         BEQ CODE_01B51E           
CODE_01B516:        C9 60         CMP.B #$60                
CODE_01B518:        F0 04         BEQ CODE_01B51E           
CODE_01B51A:        C9 49         CMP.B #$49                
CODE_01B51C:        D0 04         BNE CODE_01B522           
CODE_01B51E:        C8            INY                       
CODE_01B51F:        C8            INY                       
CODE_01B520:        C8            INY                       
CODE_01B521:        C8            INY                       
CODE_01B522:        B9 F9 B4      LDA.W DATA_01B4F9,Y       
CODE_01B525:        18            CLC                       
CODE_01B526:        75 E4         ADC RAM_SpriteXLo,X       
CODE_01B528:        85 94         STA RAM_MarioXPos         
CODE_01B52A:        B9 FF B4      LDA.W DATA_01B4FF,Y       
CODE_01B52D:        7D E0 14      ADC.W RAM_SpriteXHi,X     
CODE_01B530:        85 95         STA RAM_MarioXPosHi       
CODE_01B532:        64 7B         STZ RAM_MarioSpeedX       
CODE_01B534:        18            CLC                       
Return01B535:       60            RTS                       ; Return 

OrangePlatform:     B5 C2         LDA RAM_SpriteState,X     
ADDR_01B538:        F0 29         BEQ Platforms2            
ADDR_01B53A:        20 D1 B2      JSR.W CODE_01B2D1         
ADDR_01B53D:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
ADDR_01B53F:        D0 17         BNE Return01B558          ; / 
ADDR_01B541:        20 CC AB      JSR.W SubSprXPosNoGrvty   
ADDR_01B544:        AD 91 14      LDA.W $1491               
ADDR_01B547:        9D 28 15      STA.W $1528,X             
ADDR_01B54A:        20 57 B4      JSR.W CODE_01B457         
ADDR_01B54D:        90 09         BCC Return01B558          
ADDR_01B54F:        A9 01         LDA.B #$01                
ADDR_01B551:        8D 9A 1B      STA.W $1B9A               
ADDR_01B554:        A9 08         LDA.B #$08                
ADDR_01B556:        95 B6         STA RAM_SpriteSpeedX,X    
Return01B558:       60            RTS                       ; Return 

FloatingSpikeBall:  BD C8 14      LDA.W $14C8,X             
CODE_01B55C:        C9 08         CMP.B #$08                
CODE_01B55E:        F0 03         BEQ Platforms2            
CODE_01B560:        4C 66 B6      JMP.W CODE_01B666         

Platforms2:         A5 9D         LDA RAM_SpritesLocked     
CODE_01B565:        F0 03         BEQ CODE_01B56A           
CODE_01B567:        4C 4E B6      JMP.W CODE_01B64E         

CODE_01B56A:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_01B56D:        29 0C         AND.B #$0C                
CODE_01B56F:        D0 03         BNE CODE_01B574           
CODE_01B571:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01B574:        9C 91 14      STZ.W $1491               
CODE_01B577:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01B579:        C9 A4         CMP.B #$A4                
CODE_01B57B:        D0 03         BNE CODE_01B580           
CODE_01B57D:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01B580:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01B582:        C9 40         CMP.B #$40                
CODE_01B584:        10 02         BPL CODE_01B588           
CODE_01B586:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_01B588:        BD 4A 16      LDA.W $164A,X             
CODE_01B58B:        F0 19         BEQ CODE_01B5A6           
CODE_01B58D:        A0 F8         LDY.B #$F8                
CODE_01B58F:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01B591:        C9 5D         CMP.B #$5D                
CODE_01B593:        90 02         BCC CODE_01B597           
CODE_01B595:        A0 FC         LDY.B #$FC                
CODE_01B597:        84 00         STY $00                   
CODE_01B599:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01B59B:        10 04         BPL CODE_01B5A1           
CODE_01B59D:        C5 00         CMP $00                   
CODE_01B59F:        90 05         BCC CODE_01B5A6           
CODE_01B5A1:        38            SEC                       
CODE_01B5A2:        E9 02         SBC.B #$02                
CODE_01B5A4:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01B5A6:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01B5A8:        48            PHA                       
CODE_01B5A9:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01B5AB:        C9 A4         CMP.B #$A4                
CODE_01B5AD:        D0 06         BNE CODE_01B5B5           
CODE_01B5AF:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01B5B2:        18            CLC                       
CODE_01B5B3:        80 03         BRA CODE_01B5B8           

CODE_01B5B5:        20 57 B4      JSR.W CODE_01B457         
CODE_01B5B8:        68            PLA                       
CODE_01B5B9:        85 00         STA $00                   
CODE_01B5BB:        9C 5E 18      STZ.W $185E               
CODE_01B5BE:        90 27         BCC CODE_01B5E7           
CODE_01B5C0:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01B5C2:        C9 5D         CMP.B #$5D                
CODE_01B5C4:        90 14         BCC CODE_01B5DA           
CODE_01B5C6:        A0 03         LDY.B #$03                
CODE_01B5C8:        A5 19         LDA RAM_MarioPowerUp      
CODE_01B5CA:        D0 01         BNE CODE_01B5CD           
ADDR_01B5CC:        88            DEY                       
CODE_01B5CD:        84 00         STY $00                   
CODE_01B5CF:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01B5D1:        C5 00         CMP $00                   
CODE_01B5D3:        10 05         BPL CODE_01B5DA           
CODE_01B5D5:        18            CLC                       
CODE_01B5D6:        69 02         ADC.B #$02                
CODE_01B5D8:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01B5DA:        EE 5E 18      INC.W $185E               
CODE_01B5DD:        A5 00         LDA $00                   
CODE_01B5DF:        C9 20         CMP.B #$20                
CODE_01B5E1:        90 04         BCC CODE_01B5E7           
CODE_01B5E3:        4A            LSR                       
CODE_01B5E4:        4A            LSR                       
CODE_01B5E5:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01B5E7:        AD 5E 18      LDA.W $185E               
CODE_01B5EA:        DD 1C 15      CMP.W $151C,X             
CODE_01B5ED:        9D 1C 15      STA.W $151C,X             
CODE_01B5F0:        F0 1E         BEQ CODE_01B610           
CODE_01B5F2:        AD 5E 18      LDA.W $185E               
CODE_01B5F5:        D0 19         BNE CODE_01B610           
CODE_01B5F7:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01B5F9:        10 15         BPL CODE_01B610           
CODE_01B5FB:        A0 08         LDY.B #$08                
CODE_01B5FD:        A5 19         LDA RAM_MarioPowerUp      
CODE_01B5FF:        D0 02         BNE CODE_01B603           
CODE_01B601:        A0 06         LDY.B #$06                
CODE_01B603:        84 00         STY $00                   
CODE_01B605:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01B607:        C9 20         CMP.B #$20                
CODE_01B609:        10 05         BPL CODE_01B610           
CODE_01B60B:        18            CLC                       
CODE_01B60C:        65 00         ADC $00                   
CODE_01B60E:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01B610:        A9 01         LDA.B #$01                
CODE_01B612:        25 13         AND RAM_FrameCounter      
CODE_01B614:        D0 38         BNE CODE_01B64E           
CODE_01B616:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01B618:        F0 0A         BEQ CODE_01B624           
CODE_01B61A:        10 03         BPL CODE_01B61F           
CODE_01B61C:        18            CLC                       
CODE_01B61D:        69 02         ADC.B #$02                
CODE_01B61F:        38            SEC                       
CODE_01B620:        E9 01         SBC.B #$01                
CODE_01B622:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01B624:        AC 5E 18      LDY.W $185E               
CODE_01B627:        F0 08         BEQ CODE_01B631           
CODE_01B629:        A0 05         LDY.B #$05                
CODE_01B62B:        A5 19         LDA RAM_MarioPowerUp      
CODE_01B62D:        D0 02         BNE CODE_01B631           
ADDR_01B62F:        A0 02         LDY.B #$02                
CODE_01B631:        84 00         STY $00                   
CODE_01B633:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01B635:        48            PHA                       
CODE_01B636:        38            SEC                       
CODE_01B637:        E5 00         SBC $00                   
CODE_01B639:        95 D8         STA RAM_SpriteYLo,X       
CODE_01B63B:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01B63E:        48            PHA                       
CODE_01B63F:        E9 00         SBC.B #$00                
CODE_01B641:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01B644:        20 40 91      JSR.W CODE_019140         
CODE_01B647:        68            PLA                       
CODE_01B648:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01B64B:        68            PLA                       
CODE_01B64C:        95 D8         STA RAM_SpriteYLo,X       
CODE_01B64E:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01B651:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01B653:        C9 A4         CMP.B #$A4                
CODE_01B655:        F0 0F         BEQ CODE_01B666           
CODE_01B657:        4C D1 B2      JMP.W CODE_01B2D1         


DATA_01B65A:                      .db $F8,$08,$F8,$08

DATA_01B65E:                      .db $F8,$F8,$08,$08

FloatMineGfxProp:                 .db $31,$71,$A1,$F1

CODE_01B666:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01B669:        DA            PHX                       
CODE_01B66A:        A2 03         LDX.B #$03                
CODE_01B66C:        A5 00         LDA $00                   
CODE_01B66E:        18            CLC                       
CODE_01B66F:        7D 5A B6      ADC.W DATA_01B65A,X       
CODE_01B672:        99 00 03      STA.W OAM_DispX,Y         
CODE_01B675:        A5 01         LDA $01                   
CODE_01B677:        18            CLC                       
CODE_01B678:        7D 5E B6      ADC.W DATA_01B65E,X       
CODE_01B67B:        99 01 03      STA.W OAM_DispY,Y         
CODE_01B67E:        A5 14         LDA RAM_FrameCounterB     
CODE_01B680:        4A            LSR                       
CODE_01B681:        4A            LSR                       
CODE_01B682:        29 04         AND.B #$04                
CODE_01B684:        4A            LSR                       
CODE_01B685:        69 AA         ADC.B #$AA                
CODE_01B687:        99 02 03      STA.W OAM_Tile,Y          
CODE_01B68A:        BD 62 B6      LDA.W FloatMineGfxProp,X  
CODE_01B68D:        99 03 03      STA.W OAM_Prop,Y          
CODE_01B690:        C8            INY                       
CODE_01B691:        C8            INY                       
CODE_01B692:        C8            INY                       
CODE_01B693:        C8            INY                       
CODE_01B694:        CA            DEX                       
CODE_01B695:        10 D5         BPL CODE_01B66C           
CODE_01B697:        FA            PLX                       
CODE_01B698:        A0 02         LDY.B #$02                
CODE_01B69A:        A9 03         LDA.B #$03                
CODE_01B69C:        4C BB B7      JMP.W FinishOAMWriteRt    


BlkBridgeLength:                  .db $20,$00

TurnBlkBridgeSpeed:               .db $01,$FF

BlkBridgeTiming:                  .db $40,$40

TurnBlockBridge:    20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01B6A8:        20 10 B7      JSR.W CODE_01B710         
CODE_01B6AB:        20 52 B8      JSR.W CODE_01B852         
CODE_01B6AE:        20 B2 B6      JSR.W CODE_01B6B2         
Return01B6B1:       60            RTS                       ; Return 

CODE_01B6B2:        B5 C2         LDA RAM_SpriteState,X     
CODE_01B6B4:        29 01         AND.B #$01                
CODE_01B6B6:        A8            TAY                       
CODE_01B6B7:        BD 1C 15      LDA.W $151C,X             
CODE_01B6BA:        D9 9F B6      CMP.W BlkBridgeLength,Y   
CODE_01B6BD:        F0 12         BEQ CODE_01B6D1           
CODE_01B6BF:        BD 40 15      LDA.W $1540,X             
CODE_01B6C2:        05 9D         ORA RAM_SpritesLocked     
CODE_01B6C4:        D0 0A         BNE Return01B6D0          
CODE_01B6C6:        BD 1C 15      LDA.W $151C,X             
CODE_01B6C9:        18            CLC                       
CODE_01B6CA:        79 A1 B6      ADC.W TurnBlkBridgeSpeed,Y 
CODE_01B6CD:        9D 1C 15      STA.W $151C,X             
Return01B6D0:       60            RTS                       ; Return 

CODE_01B6D1:        B9 A3 B6      LDA.W BlkBridgeTiming,Y   
CODE_01B6D4:        9D 40 15      STA.W $1540,X             
CODE_01B6D7:        F6 C2         INC RAM_SpriteState,X     
Return01B6D9:       60            RTS                       ; Return 

HorzTurnBlkBridge:  20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01B6DD:        20 10 B7      JSR.W CODE_01B710         
CODE_01B6E0:        20 52 B8      JSR.W CODE_01B852         
CODE_01B6E3:        20 E7 B6      JSR.W CODE_01B6E7         
Return01B6E6:       60            RTS                       ; Return 

CODE_01B6E7:        B4 C2         LDY RAM_SpriteState,X     
CODE_01B6E9:        BD 1C 15      LDA.W $151C,X             
CODE_01B6EC:        D9 9F B6      CMP.W BlkBridgeLength,Y   
CODE_01B6EF:        F0 12         BEQ CODE_01B703           
CODE_01B6F1:        BD 40 15      LDA.W $1540,X             
CODE_01B6F4:        05 9D         ORA RAM_SpritesLocked     
CODE_01B6F6:        D0 0A         BNE Return01B702          
CODE_01B6F8:        BD 1C 15      LDA.W $151C,X             
CODE_01B6FB:        18            CLC                       
CODE_01B6FC:        79 A1 B6      ADC.W TurnBlkBridgeSpeed,Y 
CODE_01B6FF:        9D 1C 15      STA.W $151C,X             
Return01B702:       60            RTS                       ; Return 

CODE_01B703:        B9 A3 B6      LDA.W BlkBridgeTiming,Y   
CODE_01B706:        9D 40 15      STA.W $1540,X             
CODE_01B709:        B5 C2         LDA RAM_SpriteState,X     
CODE_01B70B:        49 01         EOR.B #$01                
CODE_01B70D:        95 C2         STA RAM_SpriteState,X     
Return01B70F:       60            RTS                       ; Return 

CODE_01B710:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01B713:        64 00         STZ $00                   
CODE_01B715:        64 01         STZ $01                   
CODE_01B717:        64 02         STZ $02                   
CODE_01B719:        64 03         STZ $03                   
CODE_01B71B:        B5 C2         LDA RAM_SpriteState,X     
CODE_01B71D:        29 02         AND.B #$02                
CODE_01B71F:        A8            TAY                       
CODE_01B720:        BD 1C 15      LDA.W $151C,X             
CODE_01B723:        99 00 00      STA.W $0000,Y             
CODE_01B726:        4A            LSR                       
CODE_01B727:        99 01 00      STA.W $0001,Y             
CODE_01B72A:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01B72D:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01B72F:        38            SEC                       
CODE_01B730:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01B732:        99 11 03      STA.W $0311,Y             
CODE_01B735:        48            PHA                       
CODE_01B736:        48            PHA                       
CODE_01B737:        48            PHA                       
CODE_01B738:        38            SEC                       
CODE_01B739:        E5 02         SBC $02                   
CODE_01B73B:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_01B73E:        68            PLA                       
CODE_01B73F:        38            SEC                       
CODE_01B740:        E5 03         SBC $03                   
CODE_01B742:        99 0D 03      STA.W OAM_Tile4DispY,Y    
CODE_01B745:        68            PLA                       
CODE_01B746:        18            CLC                       
CODE_01B747:        65 02         ADC $02                   
CODE_01B749:        99 01 03      STA.W OAM_DispY,Y         
CODE_01B74C:        68            PLA                       
CODE_01B74D:        18            CLC                       
CODE_01B74E:        65 03         ADC $03                   
CODE_01B750:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_01B753:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01B755:        38            SEC                       
CODE_01B756:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01B758:        99 10 03      STA.W $0310,Y             
CODE_01B75B:        48            PHA                       
CODE_01B75C:        48            PHA                       
CODE_01B75D:        48            PHA                       
CODE_01B75E:        38            SEC                       
CODE_01B75F:        E5 00         SBC $00                   
CODE_01B761:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_01B764:        68            PLA                       
CODE_01B765:        38            SEC                       
CODE_01B766:        E5 01         SBC $01                   
CODE_01B768:        99 0C 03      STA.W OAM_Tile4DispX,Y    
CODE_01B76B:        68            PLA                       
CODE_01B76C:        18            CLC                       
CODE_01B76D:        65 00         ADC $00                   
CODE_01B76F:        99 00 03      STA.W OAM_DispX,Y         
CODE_01B772:        68            PLA                       
CODE_01B773:        18            CLC                       
CODE_01B774:        65 01         ADC $01                   
CODE_01B776:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_01B779:        B5 C2         LDA RAM_SpriteState,X     
CODE_01B77B:        4A            LSR                       
CODE_01B77C:        4A            LSR                       
CODE_01B77D:        A9 40         LDA.B #$40                
CODE_01B77F:        99 06 03      STA.W OAM_Tile2,Y         
CODE_01B782:        99 0E 03      STA.W OAM_Tile4,Y         
CODE_01B785:        99 12 03      STA.W $0312,Y             
CODE_01B788:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_01B78B:        99 02 03      STA.W OAM_Tile,Y          
CODE_01B78E:        A5 64         LDA $64                   
CODE_01B790:        99 0F 03      STA.W OAM_Tile4Prop,Y     
CODE_01B793:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_01B796:        99 0B 03      STA.W OAM_Tile3Prop,Y     
CODE_01B799:        99 13 03      STA.W $0313,Y             
CODE_01B79C:        09 60         ORA.B #$60                
CODE_01B79E:        99 03 03      STA.W OAM_Prop,Y          
CODE_01B7A1:        A5 00         LDA $00                   
CODE_01B7A3:        48            PHA                       
CODE_01B7A4:        A5 02         LDA $02                   
CODE_01B7A6:        48            PHA                       
CODE_01B7A7:        A9 04         LDA.B #$04                
CODE_01B7A9:        20 7E B3      JSR.W CODE_01B37E         
CODE_01B7AC:        68            PLA                       
CODE_01B7AD:        85 02         STA $02                   
CODE_01B7AF:        68            PLA                       
CODE_01B7B0:        85 00         STA $00                   
Return01B7B2:       60            RTS                       ; Return 

FinishOAMWrite:     8B            PHB                       ; Wrapper 
CODE_01B7B4:        4B            PHK                       
CODE_01B7B5:        AB            PLB                       
CODE_01B7B6:        20 BB B7      JSR.W FinishOAMWriteRt    
CODE_01B7B9:        AB            PLB                       
Return01B7BA:       6B            RTL                       ; Return 

FinishOAMWriteRt:   84 0B         STY $0B                   
CODE_01B7BD:        85 08         STA $08                   
CODE_01B7BF:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01B7C2:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01B7C4:        85 00         STA $00                   
CODE_01B7C6:        38            SEC                       
CODE_01B7C7:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01B7C9:        85 06         STA $06                   
CODE_01B7CB:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01B7CE:        85 01         STA $01                   
CODE_01B7D0:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01B7D2:        85 02         STA $02                   
CODE_01B7D4:        38            SEC                       
CODE_01B7D5:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01B7D7:        85 07         STA $07                   
CODE_01B7D9:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01B7DC:        85 03         STA $03                   
CODE_01B7DE:        98            TYA                       
CODE_01B7DF:        4A            LSR                       
CODE_01B7E0:        4A            LSR                       
CODE_01B7E1:        AA            TAX                       
CODE_01B7E2:        A5 0B         LDA $0B                   
CODE_01B7E4:        10 0A         BPL CODE_01B7F0           
CODE_01B7E6:        BD 60 04      LDA.W OAM_TileSize,X      
CODE_01B7E9:        29 02         AND.B #$02                
CODE_01B7EB:        9D 60 04      STA.W OAM_TileSize,X      
CODE_01B7EE:        80 03         BRA CODE_01B7F3           

CODE_01B7F0:        9D 60 04      STA.W OAM_TileSize,X      
CODE_01B7F3:        A2 00         LDX.B #$00                
CODE_01B7F5:        B9 00 03      LDA.W OAM_DispX,Y         
CODE_01B7F8:        38            SEC                       
CODE_01B7F9:        E5 07         SBC $07                   
CODE_01B7FB:        10 01         BPL CODE_01B7FE           
CODE_01B7FD:        CA            DEX                       
CODE_01B7FE:        18            CLC                       
CODE_01B7FF:        65 02         ADC $02                   
CODE_01B801:        85 04         STA $04                   
CODE_01B803:        8A            TXA                       
CODE_01B804:        65 03         ADC $03                   
CODE_01B806:        85 05         STA $05                   
CODE_01B808:        20 44 B8      JSR.W CODE_01B844         
CODE_01B80B:        90 0C         BCC CODE_01B819           
CODE_01B80D:        98            TYA                       
CODE_01B80E:        4A            LSR                       
CODE_01B80F:        4A            LSR                       
CODE_01B810:        AA            TAX                       
CODE_01B811:        BD 60 04      LDA.W OAM_TileSize,X      
CODE_01B814:        09 01         ORA.B #$01                
CODE_01B816:        9D 60 04      STA.W OAM_TileSize,X      
CODE_01B819:        A2 00         LDX.B #$00                
CODE_01B81B:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_01B81E:        38            SEC                       
CODE_01B81F:        E5 06         SBC $06                   
CODE_01B821:        10 01         BPL CODE_01B824           
CODE_01B823:        CA            DEX                       
CODE_01B824:        18            CLC                       
CODE_01B825:        65 00         ADC $00                   
CODE_01B827:        85 09         STA $09                   
CODE_01B829:        8A            TXA                       
CODE_01B82A:        65 01         ADC $01                   
CODE_01B82C:        85 0A         STA $0A                   
CODE_01B82E:        20 BF C9      JSR.W CODE_01C9BF         
CODE_01B831:        90 05         BCC CODE_01B838           
CODE_01B833:        A9 F0         LDA.B #$F0                
CODE_01B835:        99 01 03      STA.W OAM_DispY,Y         
CODE_01B838:        C8            INY                       
CODE_01B839:        C8            INY                       
CODE_01B83A:        C8            INY                       
CODE_01B83B:        C8            INY                       
CODE_01B83C:        C6 08         DEC $08                   
CODE_01B83E:        10 9E         BPL CODE_01B7DE           
CODE_01B840:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return01B843:       60            RTS                       ; Return 

CODE_01B844:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01B846:        A5 04         LDA $04                   
CODE_01B848:        38            SEC                       
CODE_01B849:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01B84B:        C9 00 01      CMP.W #$0100              
CODE_01B84E:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return01B850:       60            RTS                       ; Return 

Return01B851:       60            RTS                       

CODE_01B852:        BD C4 15      LDA.W $15C4,X             
CODE_01B855:        D0 5A         BNE Return01B8B1          
CODE_01B857:        A5 71         LDA RAM_MarioAnimation    
CODE_01B859:        C9 01         CMP.B #$01                
CODE_01B85B:        B0 54         BCS Return01B8B1          
CODE_01B85D:        20 FF B8      JSR.W CODE_01B8FF         
CODE_01B860:        90 4F         BCC Return01B8B1          
CODE_01B862:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01B864:        38            SEC                       
CODE_01B865:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01B867:        85 02         STA $02                   
CODE_01B869:        38            SEC                       
CODE_01B86A:        E5 0D         SBC $0D                   
CODE_01B86C:        85 09         STA $09                   
CODE_01B86E:        A5 80         LDA $80                   
CODE_01B870:        18            CLC                       
CODE_01B871:        69 18         ADC.B #$18                
CODE_01B873:        C5 09         CMP $09                   
CODE_01B875:        B0 3B         BCS ADDR_01B8B2           
CODE_01B877:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01B879:        30 36         BMI Return01B8B1          
CODE_01B87B:        64 7D         STZ RAM_MarioSpeedY       
CODE_01B87D:        A9 01         LDA.B #$01                
CODE_01B87F:        8D 71 14      STA.W $1471               
CODE_01B882:        A5 0D         LDA $0D                   
CODE_01B884:        18            CLC                       
CODE_01B885:        69 1F         ADC.B #$1F                
CODE_01B887:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_01B88A:        F0 03         BEQ CODE_01B88F           
CODE_01B88C:        18            CLC                       
CODE_01B88D:        69 10         ADC.B #$10                
CODE_01B88F:        85 00         STA $00                   
CODE_01B891:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01B893:        38            SEC                       
CODE_01B894:        E5 00         SBC $00                   
CODE_01B896:        85 96         STA RAM_MarioYPos         
CODE_01B898:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01B89B:        E9 00         SBC.B #$00                
CODE_01B89D:        85 97         STA RAM_MarioYPosHi       
CODE_01B89F:        A0 00         LDY.B #$00                
CODE_01B8A1:        AD 91 14      LDA.W $1491               
CODE_01B8A4:        10 01         BPL CODE_01B8A7           
ADDR_01B8A6:        88            DEY                       
CODE_01B8A7:        18            CLC                       
CODE_01B8A8:        65 94         ADC RAM_MarioXPos         
CODE_01B8AA:        85 94         STA RAM_MarioXPos         
CODE_01B8AC:        98            TYA                       
CODE_01B8AD:        65 95         ADC RAM_MarioXPosHi       
CODE_01B8AF:        85 95         STA RAM_MarioXPosHi       
Return01B8B1:       60            RTS                       ; Return 

ADDR_01B8B2:        A5 02         LDA $02                   
ADDR_01B8B4:        18            CLC                       
ADDR_01B8B5:        65 0D         ADC $0D                   
ADDR_01B8B7:        85 02         STA $02                   
ADDR_01B8B9:        A9 FF         LDA.B #$FF                
ADDR_01B8BB:        A4 73         LDY RAM_IsDucking         
ADDR_01B8BD:        D0 04         BNE ADDR_01B8C3           
ADDR_01B8BF:        A4 19         LDY RAM_MarioPowerUp      
ADDR_01B8C1:        D0 02         BNE ADDR_01B8C5           
ADDR_01B8C3:        A9 08         LDA.B #$08                
ADDR_01B8C5:        18            CLC                       
ADDR_01B8C6:        65 80         ADC $80                   
ADDR_01B8C8:        C5 02         CMP $02                   
ADDR_01B8CA:        90 09         BCC ADDR_01B8D5           
ADDR_01B8CC:        A5 7D         LDA RAM_MarioSpeedY       
ADDR_01B8CE:        10 04         BPL Return01B8D4          
ADDR_01B8D0:        A9 10         LDA.B #$10                
ADDR_01B8D2:        85 7D         STA RAM_MarioSpeedY       
Return01B8D4:       60            RTS                       ; Return 

ADDR_01B8D5:        A5 0E         LDA $0E                   
ADDR_01B8D7:        18            CLC                       
ADDR_01B8D8:        69 10         ADC.B #$10                
ADDR_01B8DA:        85 00         STA $00                   
ADDR_01B8DC:        A0 00         LDY.B #$00                
ADDR_01B8DE:        B5 E4         LDA RAM_SpriteXLo,X       
ADDR_01B8E0:        38            SEC                       
ADDR_01B8E1:        E5 1A         SBC RAM_ScreenBndryXLo    
ADDR_01B8E3:        C5 7E         CMP $7E                   
ADDR_01B8E5:        90 08         BCC ADDR_01B8EF           
ADDR_01B8E7:        A5 00         LDA $00                   
ADDR_01B8E9:        49 FF         EOR.B #$FF                
ADDR_01B8EB:        1A            INC A                     
ADDR_01B8EC:        85 00         STA $00                   
ADDR_01B8EE:        88            DEY                       
ADDR_01B8EF:        B5 E4         LDA RAM_SpriteXLo,X       
ADDR_01B8F1:        18            CLC                       
ADDR_01B8F2:        65 00         ADC $00                   
ADDR_01B8F4:        85 94         STA RAM_MarioXPos         
ADDR_01B8F6:        98            TYA                       
ADDR_01B8F7:        7D E0 14      ADC.W RAM_SpriteXHi,X     
ADDR_01B8FA:        85 95         STA RAM_MarioXPosHi       
ADDR_01B8FC:        64 7B         STZ RAM_MarioSpeedX       
Return01B8FE:       60            RTS                       ; Return 

CODE_01B8FF:        A5 00         LDA $00                   
CODE_01B901:        85 0E         STA $0E                   
CODE_01B903:        A5 02         LDA $02                   
CODE_01B905:        85 0D         STA $0D                   
CODE_01B907:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01B909:        38            SEC                       
CODE_01B90A:        E5 00         SBC $00                   
CODE_01B90C:        85 04         STA $04                   
CODE_01B90E:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01B911:        E9 00         SBC.B #$00                
CODE_01B913:        85 0A         STA $0A                   
CODE_01B915:        A5 00         LDA $00                   
CODE_01B917:        0A            ASL                       
CODE_01B918:        18            CLC                       
CODE_01B919:        69 10         ADC.B #$10                
CODE_01B91B:        85 06         STA $06                   
CODE_01B91D:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01B91F:        38            SEC                       
CODE_01B920:        E5 02         SBC $02                   
CODE_01B922:        85 05         STA $05                   
CODE_01B924:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01B927:        E9 00         SBC.B #$00                
CODE_01B929:        85 0B         STA $0B                   
CODE_01B92B:        A5 02         LDA $02                   
CODE_01B92D:        0A            ASL                       
CODE_01B92E:        18            CLC                       
CODE_01B92F:        69 10         ADC.B #$10                
CODE_01B931:        85 07         STA $07                   
CODE_01B933:        22 64 B6 03   JSL.L GetMarioClipping    
CODE_01B937:        22 2B B7 03   JSL.L CheckForContact     
Return01B93B:       60            RTS                       ; Return 


HorzNetKoopaSpeed:                .db $08,$F8

InitHorzNetKoopa:   20 30 AD      JSR.W SubHorizPos         
CODE_01B941:        B9 3C B9      LDA.W HorzNetKoopaSpeed,Y 
CODE_01B944:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01B946:        80 08         BRA CODE_01B950           

InitVertNetKoopa:   F6 C2         INC RAM_SpriteState,X     
CODE_01B94A:        F6 B6         INC RAM_SpriteSpeedX,X    
CODE_01B94C:        A9 F8         LDA.B #$F8                
CODE_01B94E:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01B950:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01B952:        A0 00         LDY.B #$00                
CODE_01B954:        29 10         AND.B #$10                
CODE_01B956:        D0 01         BNE CODE_01B959           
CODE_01B958:        C8            INY                       
CODE_01B959:        98            TYA                       
CODE_01B95A:        9D 32 16      STA.W RAM_SprBehindScrn,X 
CODE_01B95D:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01B960:        29 02         AND.B #$02                
CODE_01B962:        D0 04         BNE Return01B968          
CODE_01B964:        16 B6         ASL RAM_SpriteSpeedX,X    
CODE_01B966:        16 AA         ASL RAM_SpriteSpeedY,X    
Return01B968:       60            RTS                       ; Return 


DATA_01B969:                      .db $02,$02,$03,$04,$03,$02,$02,$02
                                  .db $01,$02

DATA_01B973:                      .db $01,$01,$00,$00,$00,$01,$01,$01
                                  .db $01,$01

DATA_01B97D:                      .db $03,$0C

ClimbingKoopa:      BD 40 15      LDA.W $1540,X             
CODE_01B982:        F0 77         BEQ CODE_01B9FB           
CODE_01B984:        C9 30         CMP.B #$30                
CODE_01B986:        90 18         BCC CODE_01B9A0           
CODE_01B988:        C9 40         CMP.B #$40                
CODE_01B98A:        90 17         BCC CODE_01B9A3           
CODE_01B98C:        D0 12         BNE CODE_01B9A0           
CODE_01B98E:        A4 9D         LDY RAM_SpritesLocked     
CODE_01B990:        D0 0E         BNE CODE_01B9A0           
CODE_01B992:        BD 32 16      LDA.W RAM_SprBehindScrn,X 
CODE_01B995:        49 01         EOR.B #$01                
CODE_01B997:        9D 32 16      STA.W RAM_SprBehindScrn,X 
CODE_01B99A:        20 98 90      JSR.W FlipSpriteDir       
CODE_01B99D:        20 7F BA      JSR.W CODE_01BA7F         
CODE_01B9A0:        4C 37 BA      JMP.W CODE_01BA37         

CODE_01B9A3:        B4 D8         LDY RAM_SpriteYLo,X       
CODE_01B9A5:        5A            PHY                       
CODE_01B9A6:        BC D4 14      LDY.W RAM_SpriteYHi,X     
CODE_01B9A9:        5A            PHY                       
CODE_01B9AA:        A0 00         LDY.B #$00                
CODE_01B9AC:        C9 38         CMP.B #$38                
CODE_01B9AE:        90 01         BCC CODE_01B9B1           
CODE_01B9B0:        C8            INY                       
CODE_01B9B1:        B5 C2         LDA RAM_SpriteState,X     
CODE_01B9B3:        F0 17         BEQ CODE_01B9CC           
CODE_01B9B5:        C8            INY                       
CODE_01B9B6:        C8            INY                       
CODE_01B9B7:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01B9B9:        38            SEC                       
CODE_01B9BA:        E9 0C         SBC.B #$0C                
CODE_01B9BC:        95 D8         STA RAM_SpriteYLo,X       
CODE_01B9BE:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01B9C1:        E9 00         SBC.B #$00                
CODE_01B9C3:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01B9C6:        BD 32 16      LDA.W RAM_SprBehindScrn,X 
CODE_01B9C9:        F0 01         BEQ CODE_01B9CC           
CODE_01B9CB:        C8            INY                       
CODE_01B9CC:        AD EB 1E      LDA.W $1EEB               
CODE_01B9CF:        10 05         BPL CODE_01B9D6           
ADDR_01B9D1:        C8            INY                       
ADDR_01B9D2:        C8            INY                       
ADDR_01B9D3:        C8            INY                       
ADDR_01B9D4:        C8            INY                       
ADDR_01B9D5:        C8            INY                       
CODE_01B9D6:        B9 69 B9      LDA.W DATA_01B969,Y       
CODE_01B9D9:        9D 02 16      STA.W $1602,X             
CODE_01B9DC:        B9 73 B9      LDA.W DATA_01B973,Y       
CODE_01B9DF:        85 00         STA $00                   
CODE_01B9E1:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01B9E4:        48            PHA                       
CODE_01B9E5:        29 FE         AND.B #$FE                
CODE_01B9E7:        05 00         ORA $00                   
CODE_01B9E9:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01B9EC:        20 67 9D      JSR.W SubSprGfx1          
CODE_01B9EF:        68            PLA                       
CODE_01B9F0:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01B9F3:        68            PLA                       
CODE_01B9F4:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01B9F7:        68            PLA                       
CODE_01B9F8:        95 D8         STA RAM_SpriteYLo,X       
Return01B9FA:       60            RTS                       ; Return 

CODE_01B9FB:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01B9FD:        D0 54         BNE CODE_01BA53           ; / 
CODE_01B9FF:        20 40 91      JSR.W CODE_019140         
CODE_01BA02:        B4 C2         LDY RAM_SpriteState,X     
CODE_01BA04:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_01BA07:        39 7D B9      AND.W DATA_01B97D,Y       
CODE_01BA0A:        F0 08         BEQ CODE_01BA14           
CODE_01BA0C:        20 98 90      JSR.W FlipSpriteDir       
CODE_01BA0F:        20 7F BA      JSR.W CODE_01BA7F         
CODE_01BA12:        80 23         BRA CODE_01BA37           

CODE_01BA14:        AD 5F 18      LDA.W $185F               
CODE_01BA17:        B4 AA         LDY RAM_SpriteSpeedY,X    
CODE_01BA19:        F0 0C         BEQ CODE_01BA27           
CODE_01BA1B:        10 02         BPL CODE_01BA1F           
CODE_01BA1D:        30 0B         BMI CODE_01BA2A           
CODE_01BA1F:        C9 07         CMP.B #$07                
CODE_01BA21:        90 E9         BCC CODE_01BA0C           
CODE_01BA23:        C9 1D         CMP.B #$1D                
CODE_01BA25:        B0 E5         BCS CODE_01BA0C           
CODE_01BA27:        AD 60 18      LDA.W $1860               
CODE_01BA2A:        C9 07         CMP.B #$07                
CODE_01BA2C:        90 04         BCC CODE_01BA32           
CODE_01BA2E:        C9 1D         CMP.B #$1D                
CODE_01BA30:        90 05         BCC CODE_01BA37           
CODE_01BA32:        A9 50         LDA.B #$50                
CODE_01BA34:        9D 40 15      STA.W $1540,X             
CODE_01BA37:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01BA39:        D0 18         BNE CODE_01BA53           ; / 
CODE_01BA3B:        FE 70 15      INC.W $1570,X             
CODE_01BA3E:        20 15 9A      JSR.W UpdateDirection     
CODE_01BA41:        B5 C2         LDA RAM_SpriteState,X     
CODE_01BA43:        D0 05         BNE CODE_01BA4A           
CODE_01BA45:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01BA48:        80 03         BRA CODE_01BA4D           

CODE_01BA4A:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01BA4D:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01BA50:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01BA53:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01BA56:        48            PHA                       
CODE_01BA57:        BD 70 15      LDA.W $1570,X             
CODE_01BA5A:        29 08         AND.B #$08                
CODE_01BA5C:        4A            LSR                       
CODE_01BA5D:        4A            LSR                       
CODE_01BA5E:        4A            LSR                       
CODE_01BA5F:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01BA62:        A5 64         LDA $64                   
CODE_01BA64:        48            PHA                       
CODE_01BA65:        BD 32 16      LDA.W RAM_SprBehindScrn,X 
CODE_01BA68:        9D 02 16      STA.W $1602,X             
CODE_01BA6B:        BD 32 16      LDA.W RAM_SprBehindScrn,X 
CODE_01BA6E:        F0 04         BEQ CODE_01BA74           
CODE_01BA70:        A9 10         LDA.B #$10                
CODE_01BA72:        85 64         STA $64                   
CODE_01BA74:        20 67 9D      JSR.W SubSprGfx1          
CODE_01BA77:        68            PLA                       
CODE_01BA78:        85 64         STA $64                   
CODE_01BA7A:        68            PLA                       
CODE_01BA7B:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return01BA7E:       60            RTS                       ; Return 

CODE_01BA7F:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01BA81:        49 FF         EOR.B #$FF                
CODE_01BA83:        1A            INC A                     
CODE_01BA84:        95 AA         STA RAM_SpriteSpeedY,X    
Return01BA86:       60            RTS                       ; Return 

InitClimbingDoor:   B5 E4         LDA RAM_SpriteXLo,X       
CODE_01BA89:        18            CLC                       
CODE_01BA8A:        69 08         ADC.B #$08                
CODE_01BA8C:        95 E4         STA RAM_SpriteXLo,X       
CODE_01BA8E:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01BA90:        69 07         ADC.B #$07                
CODE_01BA92:        95 D8         STA RAM_SpriteYLo,X       
Return01BA94:       60            RTS                       ; Return 


DATA_01BA95:                      .db $30,$54

DATA_01BA97:                      .db $00,$01,$02,$04,$06,$09,$0C,$0D
                                  .db $14,$0D,$0C,$09,$06,$04,$02,$01
DATA_01BAA7:                      .db $00,$00,$00,$00,$00,$01,$01,$01
                                  .db $02,$01,$01,$01,$00,$00,$00,$00
DATA_01BAB7:                      .db $00,$10,$00,$00,$10,$00,$01,$11
                                  .db $01,$05,$15,$05,$05,$15,$05,$00
                                  .db $00,$00,$03,$13,$03

Return01BACC:       60            RTS                       ; Return 

ClimbingDoor:       20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01BAD0:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_01BAD3:        C9 01         CMP.B #$01                
CODE_01BAD5:        D0 1E         BNE CODE_01BAF5           
CODE_01BAD7:        A9 0F         LDA.B #$0F                ; \ Play sound effect 
CODE_01BAD9:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01BADC:        A9 19         LDA.B #$19                
CODE_01BADE:        22 00 C0 03   JSL.L GenTileFromSpr2     
CODE_01BAE2:        A9 1F         LDA.B #$1F                
CODE_01BAE4:        9D 40 15      STA.W $1540,X             
CODE_01BAE7:        8D 9D 14      STA.W $149D               
CODE_01BAEA:        A5 94         LDA RAM_MarioXPos         
CODE_01BAEC:        38            SEC                       
CODE_01BAED:        E9 10         SBC.B #$10                
CODE_01BAEF:        38            SEC                       
CODE_01BAF0:        F5 E4         SBC RAM_SpriteXLo,X       
CODE_01BAF2:        8D 78 18      STA.W $1878               
CODE_01BAF5:        BD 40 15      LDA.W $1540,X             
CODE_01BAF8:        1D 4C 15      ORA.W RAM_DisableInter,X  
CODE_01BAFB:        D0 19         BNE CODE_01BB16           
CODE_01BAFD:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_01BB01:        20 1D BC      JSR.W CODE_01BC1D         
CODE_01BB04:        22 2B B7 03   JSL.L CheckForContact     
CODE_01BB08:        90 0C         BCC CODE_01BB16           
CODE_01BB0A:        AD 9E 14      LDA.W $149E               
CODE_01BB0D:        C9 01         CMP.B #$01                
CODE_01BB0F:        D0 05         BNE CODE_01BB16           
CODE_01BB11:        A9 06         LDA.B #$06                
CODE_01BB13:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_01BB16:        BD 40 15      LDA.W $1540,X             
CODE_01BB19:        F0 B1         BEQ Return01BACC          
CODE_01BB1B:        C9 01         CMP.B #$01                
CODE_01BB1D:        D0 08         BNE CODE_01BB27           
CODE_01BB1F:        48            PHA                       
CODE_01BB20:        A9 1A         LDA.B #$1A                
CODE_01BB22:        22 00 C0 03   JSL.L GenTileFromSpr2     
CODE_01BB26:        68            PLA                       
CODE_01BB27:        C9 10         CMP.B #$10                
CODE_01BB29:        D0 08         BNE CODE_01BB33           
CODE_01BB2B:        AD F9 13      LDA.W RAM_IsBehindScenery 
CODE_01BB2E:        49 01         EOR.B #$01                
CODE_01BB30:        8D F9 13      STA.W RAM_IsBehindScenery 
CODE_01BB33:        A9 30         LDA.B #$30                
CODE_01BB35:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_01BB38:        85 03         STA $03                   
CODE_01BB3A:        A8            TAY                       
CODE_01BB3B:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01BB3D:        38            SEC                       
CODE_01BB3E:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01BB40:        85 00         STA $00                   
CODE_01BB42:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01BB44:        38            SEC                       
CODE_01BB45:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01BB47:        85 01         STA $01                   
CODE_01BB49:        BD 40 15      LDA.W $1540,X             
CODE_01BB4C:        4A            LSR                       
CODE_01BB4D:        85 02         STA $02                   
CODE_01BB4F:        AA            TAX                       
CODE_01BB50:        BD A7 BA      LDA.W DATA_01BAA7,X       
CODE_01BB53:        85 06         STA $06                   
CODE_01BB55:        A5 00         LDA $00                   
CODE_01BB57:        18            CLC                       
CODE_01BB58:        7D 97 BA      ADC.W DATA_01BA97,X       
CODE_01BB5B:        99 00 03      STA.W OAM_DispX,Y         
CODE_01BB5E:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_01BB61:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_01BB64:        A5 06         LDA $06                   
CODE_01BB66:        C9 02         CMP.B #$02                
CODE_01BB68:        F0 24         BEQ CODE_01BB8E           
CODE_01BB6A:        A5 00         LDA $00                   
CODE_01BB6C:        18            CLC                       
CODE_01BB6D:        69 20         ADC.B #$20                
CODE_01BB6F:        38            SEC                       
CODE_01BB70:        FD 97 BA      SBC.W DATA_01BA97,X       
CODE_01BB73:        99 0C 03      STA.W OAM_Tile4DispX,Y    
CODE_01BB76:        99 10 03      STA.W $0310,Y             
CODE_01BB79:        99 14 03      STA.W $0314,Y             
CODE_01BB7C:        A5 06         LDA $06                   
CODE_01BB7E:        D0 0E         BNE CODE_01BB8E           
CODE_01BB80:        A5 00         LDA $00                   
CODE_01BB82:        18            CLC                       
CODE_01BB83:        69 10         ADC.B #$10                
CODE_01BB85:        99 18 03      STA.W $0318,Y             
CODE_01BB88:        99 1C 03      STA.W $031C,Y             
CODE_01BB8B:        99 20 03      STA.W $0320,Y             
CODE_01BB8E:        A5 01         LDA $01                   
CODE_01BB90:        99 01 03      STA.W OAM_DispY,Y         
CODE_01BB93:        99 0D 03      STA.W OAM_Tile4DispY,Y    
CODE_01BB96:        99 19 03      STA.W $0319,Y             
CODE_01BB99:        18            CLC                       
CODE_01BB9A:        69 10         ADC.B #$10                
CODE_01BB9C:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_01BB9F:        99 11 03      STA.W $0311,Y             
CODE_01BBA2:        99 1D 03      STA.W $031D,Y             
CODE_01BBA5:        18            CLC                       
CODE_01BBA6:        69 10         ADC.B #$10                
CODE_01BBA8:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_01BBAB:        99 15 03      STA.W $0315,Y             
CODE_01BBAE:        99 21 03      STA.W $0321,Y             
CODE_01BBB1:        A9 08         LDA.B #$08                
CODE_01BBB3:        85 07         STA $07                   
CODE_01BBB5:        A5 06         LDA $06                   
CODE_01BBB7:        0A            ASL                       
CODE_01BBB8:        0A            ASL                       
CODE_01BBB9:        0A            ASL                       
CODE_01BBBA:        65 06         ADC $06                   
CODE_01BBBC:        AA            TAX                       
CODE_01BBBD:        BD B7 BA      LDA.W DATA_01BAB7,X       
CODE_01BBC0:        99 02 03      STA.W OAM_Tile,Y          
CODE_01BBC3:        C8            INY                       
CODE_01BBC4:        C8            INY                       
CODE_01BBC5:        C8            INY                       
CODE_01BBC6:        C8            INY                       
CODE_01BBC7:        E8            INX                       
CODE_01BBC8:        C6 07         DEC $07                   
CODE_01BBCA:        10 F1         BPL CODE_01BBBD           
CODE_01BBCC:        A4 03         LDY $03                   
CODE_01BBCE:        A2 08         LDX.B #$08                
CODE_01BBD0:        A5 64         LDA $64                   
CODE_01BBD2:        09 09         ORA.B #$09                
CODE_01BBD4:        E0 06         CPX.B #$06                
CODE_01BBD6:        B0 02         BCS CODE_01BBDA           
CODE_01BBD8:        09 40         ORA.B #$40                
CODE_01BBDA:        E0 00         CPX.B #$00                
CODE_01BBDC:        F0 08         BEQ CODE_01BBE6           
CODE_01BBDE:        E0 03         CPX.B #$03                
CODE_01BBE0:        F0 04         BEQ CODE_01BBE6           
CODE_01BBE2:        E0 06         CPX.B #$06                
CODE_01BBE4:        D0 02         BNE CODE_01BBE8           
CODE_01BBE6:        09 80         ORA.B #$80                
CODE_01BBE8:        99 03 03      STA.W OAM_Prop,Y          
CODE_01BBEB:        C8            INY                       
CODE_01BBEC:        C8            INY                       
CODE_01BBED:        C8            INY                       
CODE_01BBEE:        C8            INY                       
CODE_01BBEF:        CA            DEX                       
CODE_01BBF0:        10 DE         BPL CODE_01BBD0           
CODE_01BBF2:        A5 06         LDA $06                   
CODE_01BBF4:        48            PHA                       
CODE_01BBF5:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01BBF8:        A9 08         LDA.B #$08                
CODE_01BBFA:        20 7E B3      JSR.W CODE_01B37E         
CODE_01BBFD:        A0 0C         LDY.B #$0C                
CODE_01BBFF:        68            PLA                       
CODE_01BC00:        F0 1A         BEQ Return01BC1C          
CODE_01BC02:        C9 02         CMP.B #$02                
CODE_01BC04:        D0 0B         BNE CODE_01BC11           
CODE_01BC06:        A9 03         LDA.B #$03                
CODE_01BC08:        99 63 04      STA.W $0463,Y             
CODE_01BC0B:        99 64 04      STA.W $0464,Y             
CODE_01BC0E:        99 65 04      STA.W $0465,Y             
CODE_01BC11:        A9 03         LDA.B #$03                
CODE_01BC13:        99 66 04      STA.W $0466,Y             
CODE_01BC16:        99 67 04      STA.W $0467,Y             
CODE_01BC19:        99 68 04      STA.W $0468,Y             
Return01BC1C:       60            RTS                       ; Return 

CODE_01BC1D:        A5 94         LDA RAM_MarioXPos         ; \ $00 = Mario X Low 
CODE_01BC1F:        85 00         STA $00                   ; / 
CODE_01BC21:        A5 96         LDA RAM_MarioYPos         ; \ $01 = Mario Y Low 
CODE_01BC23:        85 01         STA $01                   ; / 
CODE_01BC25:        A9 10         LDA.B #$10                ; \ $02 = $03 = #$10 
CODE_01BC27:        85 02         STA $02                   ;  | 
CODE_01BC29:        85 03         STA $03                   ; / 
CODE_01BC2B:        A5 95         LDA RAM_MarioXPosHi       ; \ $08 = Mario X High 
CODE_01BC2D:        85 08         STA $08                   ; / 
CODE_01BC2F:        A5 97         LDA RAM_MarioYPosHi       ; \ $09 = Mario Y High 
CODE_01BC31:        85 09         STA $09                   ; / 
Return01BC33:       60            RTS                       ; Return 


MagiKoopasMagicPals:              .db $05,$07,$09,$0B

MagikoopasMagic:    A5 9D         LDA RAM_SpritesLocked     
CODE_01BC3A:        F0 03         BEQ CODE_01BC3F           
CODE_01BC3C:        4C BD BC      JMP.W CODE_01BCBD         

CODE_01BC3F:        20 4E B1      JSR.W CODE_01B14E         
CODE_01BC42:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01BC45:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01BC48:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01BC4A:        48            PHA                       
CODE_01BC4B:        A9 FF         LDA.B #$FF                
CODE_01BC4D:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01BC4F:        20 40 91      JSR.W CODE_019140         
CODE_01BC52:        68            PLA                       
CODE_01BC53:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01BC55:        20 14 80      JSR.W IsTouchingCeiling   
CODE_01BC58:        F0 63         BEQ CODE_01BCBD           
CODE_01BC5A:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_01BC5D:        D0 5E         BNE CODE_01BCBD           
CODE_01BC5F:        A9 01         LDA.B #$01                ; \ Play sound effect 
CODE_01BC61:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01BC64:        9E C8 14      STZ.W $14C8,X             
CODE_01BC67:        AD 5F 18      LDA.W $185F               
CODE_01BC6A:        38            SEC                       
CODE_01BC6B:        E9 11         SBC.B #$11                
CODE_01BC6D:        C9 1D         CMP.B #$1D                
CODE_01BC6F:        B0 48         BCS CODE_01BCB9           
CODE_01BC71:        22 F9 AC 01   JSL.L GetRand             
CODE_01BC75:        6D 8E 14      ADC.W RAM_RandomByte2     
CODE_01BC78:        65 7B         ADC RAM_MarioSpeedX       
CODE_01BC7A:        65 13         ADC RAM_FrameCounter      
CODE_01BC7C:        A0 78         LDY.B #$78                
CODE_01BC7E:        C9 35         CMP.B #$35                
CODE_01BC80:        F0 0E         BEQ StoreSpriteNum        
CODE_01BC82:        A0 21         LDY.B #$21                
CODE_01BC84:        C9 08         CMP.B #$08                
CODE_01BC86:        90 08         BCC StoreSpriteNum        
CODE_01BC88:        A0 27         LDY.B #$27                
CODE_01BC8A:        C9 F7         CMP.B #$F7                
CODE_01BC8C:        B0 02         BCS StoreSpriteNum        
CODE_01BC8E:        A0 07         LDY.B #$07                
StoreSpriteNum:     94 9E         STY RAM_SpriteNum,X       
CODE_01BC92:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_01BC94:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01BC97:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_01BC9B:        A5 9B         LDA RAM_BlockYHi          ; \ Sprite X position = block X position 
CODE_01BC9D:        9D E0 14      STA.W RAM_SpriteXHi,X     ;  | 
CODE_01BCA0:        A5 9A         LDA RAM_BlockYLo          ;  | 
CODE_01BCA2:        29 F0         AND.B #$F0                ;  | 
CODE_01BCA4:        95 E4         STA RAM_SpriteXLo,X       ;  | 
CODE_01BCA6:        A5 99         LDA RAM_BlockXHi          ; / 
CODE_01BCA8:        9D D4 14      STA.W RAM_SpriteYHi,X     ; \ Sprite Y position = block Y position 
CODE_01BCAB:        A5 98         LDA RAM_BlockXLo          ;  | 
CODE_01BCAD:        29 F0         AND.B #$F0                ;  | 
CODE_01BCAF:        95 D8         STA RAM_SpriteYLo,X       ; / 
CODE_01BCB1:        A9 02         LDA.B #$02                ; \ Block to generate = #$02 
CODE_01BCB3:        85 9C         STA RAM_BlockBlock        ; / 
CODE_01BCB5:        22 B0 BE 00   JSL.L GenerateTile        
CODE_01BCB9:        20 98 BD      JSR.W CODE_01BD98         
Return01BCBC:       60            RTS                       ; Return 

CODE_01BCBD:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  
CODE_01BCC0:        A5 13         LDA RAM_FrameCounter      
CODE_01BCC2:        4A            LSR                       
CODE_01BCC3:        4A            LSR                       
CODE_01BCC4:        29 03         AND.B #$03                
CODE_01BCC6:        A8            TAY                       
CODE_01BCC7:        B9 34 BC      LDA.W MagiKoopasMagicPals,Y 
CODE_01BCCA:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01BCCD:        20 F0 BC      JSR.W MagiKoopasMagicGfx  
CODE_01BCD0:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01BCD3:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01BCD5:        38            SEC                       
CODE_01BCD6:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01BCD8:        C9 E0         CMP.B #$E0                
CODE_01BCDA:        90 03         BCC Return01BCDF          
CODE_01BCDC:        9E C8 14      STZ.W $14C8,X             
Return01BCDF:       60            RTS                       ; Return 


MagiKoopasMagicDisp:              .db $00,$01,$02,$05,$08,$0B,$0E,$0F
                                  .db $10,$0F,$0E,$0B,$08,$05,$02,$01

MagiKoopasMagicGfx: 20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01BCF3:        A5 14         LDA RAM_FrameCounterB     
CODE_01BCF5:        4A            LSR                       
CODE_01BCF6:        29 0F         AND.B #$0F                
CODE_01BCF8:        85 03         STA $03                   
CODE_01BCFA:        18            CLC                       
CODE_01BCFB:        69 0C         ADC.B #$0C                
CODE_01BCFD:        29 0F         AND.B #$0F                
CODE_01BCFF:        85 02         STA $02                   
CODE_01BD01:        A5 01         LDA $01                   
CODE_01BD03:        38            SEC                       
CODE_01BD04:        E9 04         SBC.B #$04                
CODE_01BD06:        85 01         STA $01                   
CODE_01BD08:        A5 00         LDA $00                   
CODE_01BD0A:        38            SEC                       
CODE_01BD0B:        E9 04         SBC.B #$04                
CODE_01BD0D:        85 00         STA $00                   
CODE_01BD0F:        A6 02         LDX $02                   
CODE_01BD11:        A5 01         LDA $01                   
CODE_01BD13:        18            CLC                       
CODE_01BD14:        7D E0 BC      ADC.W MagiKoopasMagicDisp,X 
CODE_01BD17:        99 01 03      STA.W OAM_DispY,Y         
CODE_01BD1A:        A6 03         LDX $03                   
CODE_01BD1C:        A5 00         LDA $00                   
CODE_01BD1E:        18            CLC                       
CODE_01BD1F:        7D E0 BC      ADC.W MagiKoopasMagicDisp,X 
CODE_01BD22:        99 00 03      STA.W OAM_DispX,Y         
CODE_01BD25:        A5 02         LDA $02                   
CODE_01BD27:        18            CLC                       
CODE_01BD28:        69 05         ADC.B #$05                
CODE_01BD2A:        29 0F         AND.B #$0F                
CODE_01BD2C:        85 02         STA $02                   
CODE_01BD2E:        AA            TAX                       
CODE_01BD2F:        A5 01         LDA $01                   
CODE_01BD31:        18            CLC                       
CODE_01BD32:        7D E0 BC      ADC.W MagiKoopasMagicDisp,X 
CODE_01BD35:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_01BD38:        A5 03         LDA $03                   
CODE_01BD3A:        18            CLC                       
CODE_01BD3B:        69 05         ADC.B #$05                
CODE_01BD3D:        29 0F         AND.B #$0F                
CODE_01BD3F:        85 03         STA $03                   
CODE_01BD41:        AA            TAX                       
CODE_01BD42:        A5 00         LDA $00                   
CODE_01BD44:        18            CLC                       
CODE_01BD45:        7D E0 BC      ADC.W MagiKoopasMagicDisp,X 
CODE_01BD48:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_01BD4B:        A5 02         LDA $02                   
CODE_01BD4D:        18            CLC                       
CODE_01BD4E:        69 05         ADC.B #$05                
CODE_01BD50:        29 0F         AND.B #$0F                
CODE_01BD52:        85 02         STA $02                   
CODE_01BD54:        AA            TAX                       
CODE_01BD55:        A5 01         LDA $01                   
CODE_01BD57:        18            CLC                       
CODE_01BD58:        7D E0 BC      ADC.W MagiKoopasMagicDisp,X 
CODE_01BD5B:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_01BD5E:        A5 03         LDA $03                   
CODE_01BD60:        18            CLC                       
CODE_01BD61:        69 05         ADC.B #$05                
CODE_01BD63:        29 0F         AND.B #$0F                
CODE_01BD65:        85 03         STA $03                   
CODE_01BD67:        AA            TAX                       
CODE_01BD68:        A5 00         LDA $00                   
CODE_01BD6A:        18            CLC                       
CODE_01BD6B:        7D E0 BC      ADC.W MagiKoopasMagicDisp,X 
CODE_01BD6E:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_01BD71:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01BD74:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01BD77:        05 64         ORA $64                   
CODE_01BD79:        99 03 03      STA.W OAM_Prop,Y          
CODE_01BD7C:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_01BD7F:        99 0B 03      STA.W OAM_Tile3Prop,Y     
CODE_01BD82:        A9 88         LDA.B #$88                
CODE_01BD84:        99 02 03      STA.W OAM_Tile,Y          
CODE_01BD87:        A9 89         LDA.B #$89                
CODE_01BD89:        99 06 03      STA.W OAM_Tile2,Y         
CODE_01BD8C:        A9 98         LDA.B #$98                
CODE_01BD8E:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_01BD91:        A0 00         LDY.B #$00                ; \ 3 8x8 tiles 
CODE_01BD93:        A9 02         LDA.B #$02                ;  | 
CODE_01BD95:        4C BB B7      JMP.W FinishOAMWriteRt    

CODE_01BD98:        A0 03         LDY.B #$03                
CODE_01BD9A:        B9 C0 17      LDA.W $17C0,Y             
CODE_01BD9D:        F0 04         BEQ CODE_01BDA3           
CODE_01BD9F:        88            DEY                       
CODE_01BDA0:        10 F8         BPL CODE_01BD9A           
Return01BDA2:       60            RTS                       ; Return 

CODE_01BDA3:        A9 01         LDA.B #$01                
CODE_01BDA5:        99 C0 17      STA.W $17C0,Y             
CODE_01BDA8:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01BDAA:        99 C8 17      STA.W $17C8,Y             
CODE_01BDAD:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01BDAF:        99 C4 17      STA.W $17C4,Y             
CODE_01BDB2:        A9 1B         LDA.B #$1B                
CODE_01BDB4:        99 CC 17      STA.W $17CC,Y             
Return01BDB7:       60            RTS                       ; Return 

InitMagikoopa:      A0 09         LDY.B #$09                
CODE_01BDBA:        CC E9 15      CPY.W $15E9               
CODE_01BDBD:        F0 10         BEQ CODE_01BDCF           
CODE_01BDBF:        B9 C8 14      LDA.W $14C8,Y             
CODE_01BDC2:        F0 0B         BEQ CODE_01BDCF           
CODE_01BDC4:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01BDC7:        C9 1F         CMP.B #$1F                
CODE_01BDC9:        D0 04         BNE CODE_01BDCF           
ADDR_01BDCB:        9E C8 14      STZ.W $14C8,X             
Return01BDCE:       60            RTS                       ; Return 

CODE_01BDCF:        88            DEY                       
CODE_01BDD0:        10 E8         BPL CODE_01BDBA           
CODE_01BDD2:        9C BF 18      STZ.W $18BF               
Return01BDD5:       60            RTS                       ; Return 

Magikoopa:          A9 01         LDA.B #$01                
CODE_01BDD8:        9D D0 15      STA.W $15D0,X             
CODE_01BDDB:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_01BDDE:        F0 02         BEQ CODE_01BDE2           
CODE_01BDE0:        74 C2         STZ RAM_SpriteState,X     
CODE_01BDE2:        B5 C2         LDA RAM_SpriteState,X     
CODE_01BDE4:        29 03         AND.B #$03                
CODE_01BDE6:        22 DF 86 00   JSL.L ExecutePtr          

MagiKoopaPtrs:         F2 BD      .dw CODE_01BDF2           
                       5F BE      .dw CODE_01BE5F           
                       6E BE      .dw CODE_01BE6E           
                       16 BF      .dw CODE_01BF16           

CODE_01BDF2:        AD BF 18      LDA.W $18BF               
CODE_01BDF5:        F0 04         BEQ CODE_01BDFB           
ADDR_01BDF7:        9E C8 14      STZ.W $14C8,X             
Return01BDFA:       60            RTS                       ; Return 

CODE_01BDFB:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01BDFD:        D0 5F         BNE Return01BE5E          ; / 
CODE_01BDFF:        A0 24         LDY.B #$24                
CODE_01BE01:        84 40         STY $40                   
CODE_01BE03:        BD 40 15      LDA.W $1540,X             
CODE_01BE06:        D0 56         BNE Return01BE5E          
CODE_01BE08:        22 F9 AC 01   JSL.L GetRand             
CODE_01BE0C:        C9 D1         CMP.B #$D1                
CODE_01BE0E:        B0 4E         BCS Return01BE5E          
CODE_01BE10:        18            CLC                       
CODE_01BE11:        65 1C         ADC RAM_ScreenBndryYLo    
CODE_01BE13:        29 F0         AND.B #$F0                
CODE_01BE15:        95 D8         STA RAM_SpriteYLo,X       
CODE_01BE17:        A5 1D         LDA RAM_ScreenBndryYHi    
CODE_01BE19:        69 00         ADC.B #$00                
CODE_01BE1B:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01BE1E:        22 F9 AC 01   JSL.L GetRand             
CODE_01BE22:        18            CLC                       
CODE_01BE23:        65 1A         ADC RAM_ScreenBndryXLo    
CODE_01BE25:        29 F0         AND.B #$F0                
CODE_01BE27:        95 E4         STA RAM_SpriteXLo,X       
CODE_01BE29:        A5 1B         LDA RAM_ScreenBndryXHi    
CODE_01BE2B:        69 00         ADC.B #$00                
CODE_01BE2D:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01BE30:        20 30 AD      JSR.W SubHorizPos         
CODE_01BE33:        A5 0F         LDA $0F                   
CODE_01BE35:        18            CLC                       
CODE_01BE36:        69 20         ADC.B #$20                
CODE_01BE38:        C9 40         CMP.B #$40                
CODE_01BE3A:        90 22         BCC Return01BE5E          
CODE_01BE3C:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_01BE3E:        A9 01         LDA.B #$01                
CODE_01BE40:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01BE42:        20 40 91      JSR.W CODE_019140         
CODE_01BE45:        20 0E 80      JSR.W IsOnGround          
CODE_01BE48:        F0 14         BEQ Return01BE5E          
CODE_01BE4A:        AD 62 18      LDA.W $1862               
CODE_01BE4D:        D0 0F         BNE Return01BE5E          
CODE_01BE4F:        F6 C2         INC RAM_SpriteState,X     
CODE_01BE51:        9E 70 15      STZ.W $1570,X             
CODE_01BE54:        20 82 BE      JSR.W CODE_01BE82         
CODE_01BE57:        20 30 AD      JSR.W SubHorizPos         
CODE_01BE5A:        98            TYA                       
CODE_01BE5B:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return01BE5E:       60            RTS                       ; Return 

CODE_01BE5F:        20 04 C0      JSR.W CODE_01C004         
CODE_01BE62:        9E 02 16      STZ.W $1602,X             
CODE_01BE65:        20 67 9D      JSR.W SubSprGfx1          
Return01BE68:       60            RTS                       ; Return 


DATA_01BE69:                      .db $04,$02,$00

DATA_01BE6C:                      .db $10,$F8

CODE_01BE6E:        9E D0 15      STZ.W $15D0,X             
CODE_01BE71:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  
CODE_01BE74:        20 30 AD      JSR.W SubHorizPos         
CODE_01BE77:        98            TYA                       
CODE_01BE78:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01BE7B:        BD 40 15      LDA.W $1540,X             
CODE_01BE7E:        D0 06         BNE CODE_01BE86           
CODE_01BE80:        F6 C2         INC RAM_SpriteState,X     
CODE_01BE82:        A0 34         LDY.B #$34                
CODE_01BE84:        84 40         STY $40                   
CODE_01BE86:        C9 40         CMP.B #$40                
CODE_01BE88:        D0 0C         BNE CODE_01BE96           
CODE_01BE8A:        48            PHA                       
CODE_01BE8B:        A5 9D         LDA RAM_SpritesLocked     
CODE_01BE8D:        1D A0 15      ORA.W RAM_OffscreenHorz,X 
CODE_01BE90:        D0 03         BNE CODE_01BE95           
CODE_01BE92:        20 1D BF      JSR.W CODE_01BF1D	;JUMP TO GENERATE MAGIC         
CODE_01BE95:        68            PLA                       
CODE_01BE96:        4A            LSR                       
CODE_01BE97:        4A            LSR                       
CODE_01BE98:        4A            LSR                       
CODE_01BE99:        4A            LSR                       
CODE_01BE9A:        4A            LSR                       
CODE_01BE9B:        4A            LSR                       
CODE_01BE9C:        A8            TAY                       
CODE_01BE9D:        5A            PHY                       
CODE_01BE9E:        BD 40 15      LDA.W $1540,X             
CODE_01BEA1:        4A            LSR                       
CODE_01BEA2:        4A            LSR                       
CODE_01BEA3:        4A            LSR                       
CODE_01BEA4:        29 01         AND.B #$01                
CODE_01BEA6:        19 69 BE      ORA.W DATA_01BE69,Y       
CODE_01BEA9:        9D 02 16      STA.W $1602,X             
CODE_01BEAC:        20 67 9D      JSR.W SubSprGfx1          
CODE_01BEAF:        BD 02 16      LDA.W $1602,X             
CODE_01BEB2:        38            SEC                       
CODE_01BEB3:        E9 02         SBC.B #$02                
CODE_01BEB5:        C9 02         CMP.B #$02                
CODE_01BEB7:        90 0D         BCC CODE_01BEC6           
CODE_01BEB9:        4A            LSR                       
CODE_01BEBA:        90 0A         BCC CODE_01BEC6           
CODE_01BEBC:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_01BEBF:        AA            TAX                       
CODE_01BEC0:        FE 01 03      INC.W OAM_DispY,X         
CODE_01BEC3:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01BEC6:        7A            PLY                       
CODE_01BEC7:        C0 01         CPY.B #$01                
CODE_01BEC9:        D0 03         BNE CODE_01BECE           
CODE_01BECB:        20 4E B1      JSR.W CODE_01B14E         
CODE_01BECE:        BD 02 16      LDA.W $1602,X             
CODE_01BED1:        C9 04         CMP.B #$04                
CODE_01BED3:        90 40         BCC Return01BF15          
CODE_01BED5:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01BED8:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01BEDA:        18            CLC                       
CODE_01BEDB:        79 6C BE      ADC.W DATA_01BE6C,Y       
CODE_01BEDE:        38            SEC                       
CODE_01BEDF:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01BEE1:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01BEE4:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_01BEE7:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01BEE9:        38            SEC                       
CODE_01BEEA:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01BEEC:        18            CLC                       
CODE_01BEED:        69 10         ADC.B #$10                
CODE_01BEEF:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_01BEF2:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01BEF5:        4A            LSR                       
CODE_01BEF6:        A9 00         LDA.B #$00                
CODE_01BEF8:        B0 02         BCS CODE_01BEFC           
CODE_01BEFA:        09 40         ORA.B #$40                
CODE_01BEFC:        05 64         ORA $64                   
CODE_01BEFE:        1D F6 15      ORA.W RAM_SpritePal,X     
CODE_01BF01:        99 0B 03      STA.W OAM_Tile3Prop,Y     
CODE_01BF04:        A9 99         LDA.B #$99                
CODE_01BF06:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_01BF09:        98            TYA                       
CODE_01BF0A:        4A            LSR                       
CODE_01BF0B:        4A            LSR                       
CODE_01BF0C:        A8            TAY                       
CODE_01BF0D:        A9 00         LDA.B #$00                
CODE_01BF0F:        1D A0 15      ORA.W RAM_OffscreenHorz,X 
CODE_01BF12:        99 62 04      STA.W $0462,Y             
Return01BF15:       60            RTS                       ; Return 

CODE_01BF16:        20 E3 BF      JSR.W CODE_01BFE3         
CODE_01BF19:        20 67 9D      JSR.W SubSprGfx1          
Return01BF1C:       60            RTS                       ; Return 

CODE_01BF1D:        A0 09         LDY.B #$09                
CODE_01BF1F:        B9 C8 14      LDA.W $14C8,Y             
CODE_01BF22:        F0 04         BEQ CODE_01BF28           
CODE_01BF24:        88            DEY                       
CODE_01BF25:        10 F8         BPL CODE_01BF1F           
Return01BF27:       60            RTS                       ; Return 

CODE_01BF28:        A9 10         LDA.B #$10                ; \ Play sound effect 
CODE_01BF2A:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01BF2D:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_01BF2F:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01BF32:        A9 20         LDA.B #$20 			;GENERATES MAGIC HERE!   !@#            
CODE_01BF34:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_01BF37:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01BF39:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_01BF3C:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01BF3F:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_01BF42:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01BF44:        18            CLC                       
CODE_01BF45:        69 0A         ADC.B #$0A                
CODE_01BF47:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_01BF4A:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01BF4D:        69 00         ADC.B #$00                
CODE_01BF4F:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_01BF52:        BB            TYX                       
CODE_01BF53:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_01BF57:        A9 20         LDA.B #$20                
CODE_01BF59:        20 6A BF      JSR.W CODE_01BF6A         
CODE_01BF5C:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01BF5F:        A5 00         LDA $00		    ;PULLS SPEED FROM RAM HERE?                   
CODE_01BF61:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_01BF64:        A5 01         LDA $01                   
CODE_01BF66:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
Return01BF69:       60            RTS                       ; Return 

CODE_01BF6A:        85 01         STA $01			;FILLS OUT RAM TO USE FOR SPEED?                   
CODE_01BF6C:        DA            PHX                       
CODE_01BF6D:        5A            PHY                       
CODE_01BF6E:        20 42 AD      JSR.W CODE_01AD42         
CODE_01BF71:        84 02         STY $02                   
CODE_01BF73:        A5 0E         LDA $0E                   
CODE_01BF75:        10 05         BPL CODE_01BF7C           
CODE_01BF77:        49 FF         EOR.B #$FF                
CODE_01BF79:        18            CLC                       
CODE_01BF7A:        69 01         ADC.B #$01                
CODE_01BF7C:        85 0C         STA $0C                   
CODE_01BF7E:        20 30 AD      JSR.W SubHorizPos         
CODE_01BF81:        84 03         STY $03                   
CODE_01BF83:        A5 0F         LDA $0F                   
CODE_01BF85:        10 05         BPL CODE_01BF8C           
CODE_01BF87:        49 FF         EOR.B #$FF                
CODE_01BF89:        18            CLC                       
CODE_01BF8A:        69 01         ADC.B #$01                
CODE_01BF8C:        85 0D         STA $0D                   
CODE_01BF8E:        A0 00         LDY.B #$00                
CODE_01BF90:        A5 0D         LDA $0D                   
CODE_01BF92:        C5 0C         CMP $0C                   
CODE_01BF94:        B0 09         BCS CODE_01BF9F           
CODE_01BF96:        C8            INY                       
CODE_01BF97:        48            PHA                       
CODE_01BF98:        A5 0C         LDA $0C                   
CODE_01BF9A:        85 0D         STA $0D                   
CODE_01BF9C:        68            PLA                       
CODE_01BF9D:        85 0C         STA $0C                   
CODE_01BF9F:        A9 00         LDA.B #$00                
CODE_01BFA1:        85 0B         STA $0B                   
CODE_01BFA3:        85 00         STA $00                   
CODE_01BFA5:        A6 01         LDX $01                   
CODE_01BFA7:        A5 0B         LDA $0B                   
CODE_01BFA9:        18            CLC                       
CODE_01BFAA:        65 0C         ADC $0C                   
CODE_01BFAC:        C5 0D         CMP $0D                   
CODE_01BFAE:        90 04         BCC CODE_01BFB4           
CODE_01BFB0:        E5 0D         SBC $0D                   
CODE_01BFB2:        E6 00         INC $00                   
CODE_01BFB4:        85 0B         STA $0B                   
CODE_01BFB6:        CA            DEX                       
CODE_01BFB7:        D0 EE         BNE CODE_01BFA7           
CODE_01BFB9:        98            TYA                       
CODE_01BFBA:        F0 0A         BEQ CODE_01BFC6           
CODE_01BFBC:        A5 00         LDA $00                   
CODE_01BFBE:        48            PHA                       
CODE_01BFBF:        A5 01         LDA $01                   
CODE_01BFC1:        85 00         STA $00                   
CODE_01BFC3:        68            PLA                       
CODE_01BFC4:        85 01         STA $01                   
CODE_01BFC6:        A5 00         LDA $00                   
CODE_01BFC8:        A4 02         LDY $02                   
CODE_01BFCA:        F0 07         BEQ CODE_01BFD3           
CODE_01BFCC:        49 FF         EOR.B #$FF                
CODE_01BFCE:        18            CLC                       
CODE_01BFCF:        69 01         ADC.B #$01                
CODE_01BFD1:        85 00         STA $00                   
CODE_01BFD3:        A5 01         LDA $01                   
CODE_01BFD5:        A4 03         LDY $03                   
CODE_01BFD7:        F0 07         BEQ CODE_01BFE0           
CODE_01BFD9:        49 FF         EOR.B #$FF                
CODE_01BFDB:        18            CLC                       
CODE_01BFDC:        69 01         ADC.B #$01                
CODE_01BFDE:        85 01         STA $01                   
CODE_01BFE0:        7A            PLY                       
CODE_01BFE1:        FA            PLX                       
Return01BFE2:       60            RTS                       ; Return 

CODE_01BFE3:        BD 40 15      LDA.W $1540,X             
CODE_01BFE6:        D0 18         BNE Return01C000          
CODE_01BFE8:        A9 02         LDA.B #$02                
CODE_01BFEA:        9D 40 15      STA.W $1540,X             
CODE_01BFED:        DE 70 15      DEC.W $1570,X             
CODE_01BFF0:        BD 70 15      LDA.W $1570,X             
CODE_01BFF3:        C9 00         CMP.B #$00                
CODE_01BFF5:        D0 0A         BNE CODE_01C001           
CODE_01BFF7:        F6 C2         INC RAM_SpriteState,X     
CODE_01BFF9:        A9 10         LDA.B #$10                
CODE_01BFFB:        9D 40 15      STA.W $1540,X             
CODE_01BFFE:        68            PLA                       
CODE_01BFFF:        68            PLA                       
Return01C000:       60            RTS                       ; Return 

CODE_01C001:        4C 28 C0      JMP.W CODE_01C028         

CODE_01C004:        BD 40 15      LDA.W $1540,X             
CODE_01C007:        D0 55         BNE CODE_01C05E           
CODE_01C009:        A9 04         LDA.B #$04                
CODE_01C00B:        9D 40 15      STA.W $1540,X             
CODE_01C00E:        FE 70 15      INC.W $1570,X             
CODE_01C011:        BD 70 15      LDA.W $1570,X             
CODE_01C014:        C9 09         CMP.B #$09                
CODE_01C016:        D0 04         BNE CODE_01C01C           
CODE_01C018:        A0 24         LDY.B #$24                
CODE_01C01A:        84 40         STY $40                   
CODE_01C01C:        C9 09         CMP.B #$09                
CODE_01C01E:        D0 08         BNE CODE_01C028           
CODE_01C020:        F6 C2         INC RAM_SpriteState,X     
CODE_01C022:        A9 70         LDA.B #$70                
CODE_01C024:        9D 40 15      STA.W $1540,X             
Return01C027:       60            RTS                       ; Return 

CODE_01C028:        BD 70 15      LDA.W $1570,X             
CODE_01C02B:        3A            DEC A                     
CODE_01C02C:        0A            ASL                       
CODE_01C02D:        0A            ASL                       
CODE_01C02E:        0A            ASL                       
CODE_01C02F:        0A            ASL                       
CODE_01C030:        AA            TAX                       
CODE_01C031:        64 00         STZ $00                   
CODE_01C033:        AC 81 06      LDY.W $0681               
CODE_01C036:        BF 02 B9 03   LDA.L MagiKoopaPals,X     
CODE_01C03A:        99 84 06      STA.W $0684,Y             
CODE_01C03D:        C8            INY                       
CODE_01C03E:        E8            INX                       
CODE_01C03F:        E6 00         INC $00                   
CODE_01C041:        A5 00         LDA $00                   
CODE_01C043:        C9 10         CMP.B #$10                
CODE_01C045:        D0 EF         BNE CODE_01C036           
CODE_01C047:        AE 81 06      LDX.W $0681               
CODE_01C04A:        A9 10         LDA.B #$10                
CODE_01C04C:        9D 82 06      STA.W $0682,X             
CODE_01C04F:        A9 F0         LDA.B #$F0                
CODE_01C051:        9D 83 06      STA.W $0683,X             
CODE_01C054:        9E 94 06      STZ.W $0694,X             
CODE_01C057:        8A            TXA                       
CODE_01C058:        18            CLC                       
CODE_01C059:        69 12         ADC.B #$12                
CODE_01C05B:        8D 81 06      STA.W $0681               
CODE_01C05E:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return01C061:       60            RTS                       ; Return 

ADDR_01C062:        20 75 C0      JSR.W InitGoalTape        ; \ Unreachable 
ADDR_01C065:        B5 D8         LDA RAM_SpriteYLo,X       ;  | Call Goal Tape INIT, then 
ADDR_01C067:        38            SEC                       ;  | Sprite Y position -= #$4C 
ADDR_01C068:        E9 4C         SBC.B #$4C                ;  | 
ADDR_01C06A:        95 D8         STA RAM_SpriteYLo,X       ;  | 
ADDR_01C06C:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
ADDR_01C06F:        E9 00         SBC.B #$00                ;  | 
ADDR_01C071:        9D D4 14      STA.W RAM_SpriteYHi,X     ;  | 
Return01C074:       60            RTS                       ; / 

InitGoalTape:       B5 E4         LDA RAM_SpriteXLo,X       
CODE_01C077:        38            SEC                       
CODE_01C078:        E9 08         SBC.B #$08                
CODE_01C07A:        95 C2         STA RAM_SpriteState,X     
CODE_01C07C:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01C07F:        E9 00         SBC.B #$00                
CODE_01C081:        9D 1C 15      STA.W $151C,X             
CODE_01C084:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01C086:        9D 28 15      STA.W $1528,X             
CODE_01C089:        BD D4 14      LDA.W RAM_SpriteYHi,X     ; \ Save extra bits into $187B,x 
CODE_01C08C:        9D 7B 18      STA.W $187B,X             ; / 
CODE_01C08F:        29 01         AND.B #$01                ; \ Clear extra bits out of position 
CODE_01C091:        9D D4 14      STA.W RAM_SpriteYHi,X     ; / 
CODE_01C094:        9D 34 15      STA.W $1534,X             
Return01C097:       60            RTS                       ; Return 

GoalTape:           20 2D C1      JSR.W CODE_01C12D         
CODE_01C09B:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01C09D:        D0 05         BNE Return01C0A4          ; / 
CODE_01C09F:        BD 02 16      LDA.W $1602,X             
CODE_01C0A2:        F0 03         BEQ CODE_01C0A7           
Return01C0A4:       60            RTS                       ; Return 


DATA_01C0A5:                      .db $10,$F0

CODE_01C0A7:        BD 40 15      LDA.W $1540,X             
CODE_01C0AA:        D0 08         BNE CODE_01C0B4           
CODE_01C0AC:        A9 7C         LDA.B #$7C                
CODE_01C0AE:        9D 40 15      STA.W $1540,X             
CODE_01C0B1:        FE 88 15      INC.W RAM_SprObjStatus,X  
CODE_01C0B4:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_01C0B7:        29 01         AND.B #$01                
CODE_01C0B9:        A8            TAY                       
CODE_01C0BA:        B9 A5 C0      LDA.W DATA_01C0A5,Y       
CODE_01C0BD:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01C0BF:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01C0C2:        B5 C2         LDA RAM_SpriteState,X     
CODE_01C0C4:        85 00         STA $00                   
CODE_01C0C6:        BD 1C 15      LDA.W $151C,X             
CODE_01C0C9:        85 01         STA $01                   
CODE_01C0CB:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01C0CD:        A5 94         LDA RAM_MarioXPos         
CODE_01C0CF:        38            SEC                       
CODE_01C0D0:        E5 00         SBC $00                   
CODE_01C0D2:        C9 10 00      CMP.W #$0010              
CODE_01C0D5:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01C0D7:        B0 53         BCS Return01C12C          
CODE_01C0D9:        BD 28 15      LDA.W $1528,X             
CODE_01C0DC:        C5 96         CMP RAM_MarioYPos         
CODE_01C0DE:        BD 34 15      LDA.W $1534,X             
CODE_01C0E1:        29 01         AND.B #$01                
CODE_01C0E3:        E5 97         SBC RAM_MarioYPosHi       
CODE_01C0E5:        90 45         BCC Return01C12C          
CODE_01C0E7:        BD 7B 18      LDA.W $187B,X             ; \ $141C = #01 if Goal Tape triggers secret exit 
CODE_01C0EA:        4A            LSR                       ;  | 
CODE_01C0EB:        4A            LSR                       ;  | 
CODE_01C0EC:        8D 1C 14      STA.W $141C               ; / 
CODE_01C0EF:        A9 0C         LDA.B #$0C                
CODE_01C0F1:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_01C0F4:        A9 FF         LDA.B #$FF                
CODE_01C0F6:        8D DA 0D      STA.W $0DDA               
CODE_01C0F9:        A9 FF         LDA.B #$FF                
CODE_01C0FB:        8D 93 14      STA.W $1493               
CODE_01C0FE:        9C 90 14      STZ.W $1490               ; Zero out star timer 
CODE_01C101:        FE 02 16      INC.W $1602,X             
CODE_01C104:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01C107:        90 1C         BCC CODE_01C125           
CODE_01C109:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_01C10B:        8D FC 1D      STA.W $1DFC               ; / 
CODE_01C10E:        FE 0E 16      INC.W $160E,X             
CODE_01C111:        BD 28 15      LDA.W $1528,X             
CODE_01C114:        38            SEC                       
CODE_01C115:        F5 D8         SBC RAM_SpriteYLo,X       
CODE_01C117:        9D 94 15      STA.W $1594,X             
CODE_01C11A:        A9 80         LDA.B #$80                
CODE_01C11C:        9D 40 15      STA.W $1540,X             
CODE_01C11F:        22 52 F2 07   JSL.L CODE_07F252         
CODE_01C123:        80 03         BRA CODE_01C128           

CODE_01C125:        9E 86 16      STZ.W RAM_Tweaker1686,X   
CODE_01C128:        22 80 FA 00   JSL.L TriggerGoalTape     
Return01C12C:       60            RTS                       ; Return 

CODE_01C12D:        BD 0E 16      LDA.W $160E,X             
CODE_01C130:        D0 43         BNE CODE_01C175           
CODE_01C132:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01C135:        A5 00         LDA $00                   
CODE_01C137:        38            SEC                       
CODE_01C138:        E9 08         SBC.B #$08                
CODE_01C13A:        99 00 03      STA.W OAM_DispX,Y         
CODE_01C13D:        18            CLC                       
CODE_01C13E:        69 08         ADC.B #$08                
CODE_01C140:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_01C143:        18            CLC                       
CODE_01C144:        69 08         ADC.B #$08                
CODE_01C146:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_01C149:        A5 01         LDA $01                   
CODE_01C14B:        18            CLC                       
CODE_01C14C:        69 08         ADC.B #$08                
CODE_01C14E:        99 01 03      STA.W OAM_DispY,Y         
CODE_01C151:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_01C154:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_01C157:        A9 D4         LDA.B #$D4                
CODE_01C159:        99 02 03      STA.W OAM_Tile,Y          
CODE_01C15C:        1A            INC A                     
CODE_01C15D:        99 06 03      STA.W OAM_Tile2,Y         
CODE_01C160:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_01C163:        A9 32         LDA.B #$32                
CODE_01C165:        99 03 03      STA.W OAM_Prop,Y          
CODE_01C168:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_01C16B:        99 0B 03      STA.W OAM_Tile3Prop,Y     
CODE_01C16E:        A0 00         LDY.B #$00                
CODE_01C170:        A9 02         LDA.B #$02                
CODE_01C172:        4C BB B7      JMP.W FinishOAMWriteRt    

CODE_01C175:        BD 40 15      LDA.W $1540,X             
CODE_01C178:        F0 05         BEQ CODE_01C17F           
CODE_01C17A:        22 CA F1 07   JSL.L CODE_07F1CA         
Return01C17E:       60            RTS                       ; Return 

CODE_01C17F:        9E C8 14      STZ.W $14C8,X             
Return01C182:       60            RTS                       ; Return 

GrowingVine:        A5 64         LDA $64                   
CODE_01C185:        48            PHA                       
CODE_01C186:        BD 40 15      LDA.W $1540,X             
CODE_01C189:        C9 20         CMP.B #$20                
CODE_01C18B:        90 04         BCC CODE_01C191           
CODE_01C18D:        A9 10         LDA.B #$10                
CODE_01C18F:        85 64         STA $64                   
CODE_01C191:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01C194:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01C197:        A5 14         LDA RAM_FrameCounterB     
CODE_01C199:        4A            LSR                       
CODE_01C19A:        4A            LSR                       
CODE_01C19B:        4A            LSR                       
CODE_01C19C:        4A            LSR                       
CODE_01C19D:        A9 AC         LDA.B #$AC                
CODE_01C19F:        90 02         BCC CODE_01C1A3           
CODE_01C1A1:        A9 AE         LDA.B #$AE                
CODE_01C1A3:        99 02 03      STA.W OAM_Tile,Y          
CODE_01C1A6:        68            PLA                       
CODE_01C1A7:        85 64         STA $64                   
CODE_01C1A9:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01C1AB:        D0 40         BNE Return01C1ED          ; / 
CODE_01C1AD:        A9 F0         LDA.B #$F0                
CODE_01C1AF:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01C1B1:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01C1B4:        BD 40 15      LDA.W $1540,X             
CODE_01C1B7:        C9 20         CMP.B #$20                
CODE_01C1B9:        B0 10         BCS CODE_01C1CB           
CODE_01C1BB:        20 40 91      JSR.W CODE_019140         
CODE_01C1BE:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_01C1C1:        D0 05         BNE CODE_01C1C8           
CODE_01C1C3:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01C1C6:        10 03         BPL CODE_01C1CB           
CODE_01C1C8:        4C 80 AC      JMP.W OffScrEraseSprite   

CODE_01C1CB:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01C1CD:        29 0F         AND.B #$0F                
CODE_01C1CF:        C9 00         CMP.B #$00                
CODE_01C1D1:        D0 1A         BNE Return01C1ED          
CODE_01C1D3:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $9A = Sprite X position 
CODE_01C1D5:        85 9A         STA RAM_BlockYLo          ;  | for block creation 
CODE_01C1D7:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_01C1DA:        85 9B         STA RAM_BlockYHi          ; / 
CODE_01C1DC:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $98 = Sprite Y position 
CODE_01C1DE:        85 98         STA RAM_BlockXLo          ;  | for block creation 
CODE_01C1E0:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_01C1E3:        85 99         STA RAM_BlockXHi          ; / 
CODE_01C1E5:        A9 03         LDA.B #$03                ; \ Block to generate = Vine 
CODE_01C1E7:        85 9C         STA RAM_BlockBlock        ; / 
CODE_01C1E9:        22 B0 BE 00   JSL.L GenerateTile        ; Generate the tile 
Return01C1ED:       60            RTS                       ; Return 


DATA_01C1EE:                      .db $FF,$01

DATA_01C1F0:                      .db $F0,$10

BalloonKeyFlyObjs:  BD C8 14      LDA.W $14C8,X             
CODE_01C1F5:        C9 0C         CMP.B #$0C                
CODE_01C1F7:        F0 5C         BEQ CODE_01C255           
CODE_01C1F9:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01C1FB:        D0 58         BNE CODE_01C255           ; / 
CODE_01C1FD:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01C1FF:        C9 7D         CMP.B #$7D                
CODE_01C201:        D0 1A         BNE CODE_01C21D           
CODE_01C203:        BD 40 15      LDA.W $1540,X             
CODE_01C206:        F0 15         BEQ CODE_01C21D           
ADDR_01C208:        A5 64         LDA $64                   
ADDR_01C20A:        48            PHA                       
ADDR_01C20B:        A9 10         LDA.B #$10                
ADDR_01C20D:        85 64         STA $64                   
ADDR_01C20F:        20 1A C6      JSR.W CODE_01C61A         
ADDR_01C212:        68            PLA                       
ADDR_01C213:        85 64         STA $64                   
ADDR_01C215:        A9 F8         LDA.B #$F8                
ADDR_01C217:        95 AA         STA RAM_SpriteSpeedY,X    
ADDR_01C219:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
Return01C21C:       60            RTS                       ; Return 

CODE_01C21D:        A5 13         LDA RAM_FrameCounter      
CODE_01C21F:        29 01         AND.B #$01                
CODE_01C221:        D0 16         BNE CODE_01C239           
CODE_01C223:        BD 1C 15      LDA.W $151C,X             
CODE_01C226:        29 01         AND.B #$01                
CODE_01C228:        A8            TAY                       
CODE_01C229:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01C22B:        18            CLC                       
CODE_01C22C:        79 EE C1      ADC.W DATA_01C1EE,Y       
CODE_01C22F:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01C231:        D9 F0 C1      CMP.W DATA_01C1F0,Y       
CODE_01C234:        D0 03         BNE CODE_01C239           
CODE_01C236:        FE 1C 15      INC.W $151C,X             
CODE_01C239:        A9 0C         LDA.B #$0C                
CODE_01C23B:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01C23D:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01C240:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01C242:        48            PHA                       
CODE_01C243:        18            CLC                       
CODE_01C244:        38            SEC                       
CODE_01C245:        E9 02         SBC.B #$02                
CODE_01C247:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01C249:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01C24C:        68            PLA                       
CODE_01C24D:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01C24F:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01C252:        FE 70 15      INC.W $1570,X             
CODE_01C255:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01C257:        C9 7D         CMP.B #$7D                
CODE_01C259:        D0 07         BNE CODE_01C262           
CODE_01C25B:        A9 01         LDA.B #$01                
CODE_01C25D:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01C260:        80 1D         BRA CODE_01C27F           

CODE_01C262:        B5 C2         LDA RAM_SpriteState,X     
CODE_01C264:        C9 02         CMP.B #$02                
CODE_01C266:        D0 14         BNE CODE_01C27C           
CODE_01C268:        A5 13         LDA RAM_FrameCounter      
CODE_01C26A:        29 03         AND.B #$03                
CODE_01C26C:        D0 03         BNE CODE_01C271           
CODE_01C26E:        20 4E B1      JSR.W CODE_01B14E         
CODE_01C271:        A5 14         LDA RAM_FrameCounterB     
CODE_01C273:        4A            LSR                       
CODE_01C274:        29 0E         AND.B #$0E                
CODE_01C276:        5D F6 15      EOR.W RAM_SpritePal,X     
CODE_01C279:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01C27C:        20 95 9E      JSR.W CODE_019E95         
CODE_01C27F:        B5 C2         LDA RAM_SpriteState,X     
CODE_01C281:        F0 04         BEQ CODE_01C287           
CODE_01C283:        20 65 A3      JSR.W GetDrawInfoBnk1     
Return01C286:       60            RTS                       ; Return 

CODE_01C287:        20 1A C6      JSR.W CODE_01C61A         
CODE_01C28A:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01C28D:        90 43         BCC Return01C2D2          
CODE_01C28F:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01C291:        C9 7E         CMP.B #$7E                
CODE_01C293:        D0 11         BNE CODE_01C2A6           
ADDR_01C295:        20 F0 C4      JSR.W CODE_01C4F0         
ADDR_01C298:        A9 05         LDA.B #$05                
ADDR_01C29A:        22 29 B3 05   JSL.L ADDR_05B329         
ADDR_01C29E:        A9 03         LDA.B #$03                
ADDR_01C2A0:        22 E5 AC 02   JSL.L GivePoints          
ADDR_01C2A4:        80 69         BRA ADDR_01C30F           

CODE_01C2A6:        C9 7F         CMP.B #$7F                
CODE_01C2A8:        D0 05         BNE CODE_01C2AF           
ADDR_01C2AA:        20 FE C5      JSR.W GiveMario1Up        
ADDR_01C2AD:        80 60         BRA ADDR_01C30F           

CODE_01C2AF:        C9 80         CMP.B #$80                
CODE_01C2B1:        D0 1B         BNE CODE_01C2CE           
ADDR_01C2B3:        A5 7D         LDA RAM_MarioSpeedY       
ADDR_01C2B5:        30 1B         BMI Return01C2D2          
ADDR_01C2B7:        A9 09         LDA.B #$09                ; \ Sprite status = Carryable 
ADDR_01C2B9:        9D C8 14      STA.W $14C8,X             ; / 
ADDR_01C2BC:        A9 D0         LDA.B #$D0                
ADDR_01C2BE:        85 7D         STA RAM_MarioSpeedY       
ADDR_01C2C0:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
ADDR_01C2C2:        9E 40 15      STZ.W $1540,X             
ADDR_01C2C5:        BD 7A 16      LDA.W RAM_Tweaker167A,X   ; \ Use default interation with Mario 
ADDR_01C2C8:        29 7F         AND.B #$7F                ;  | 
ADDR_01C2CA:        9D 7A 16      STA.W RAM_Tweaker167A,X   ; / 
Return01C2CD:       60            RTS                       ; Return 

CODE_01C2CE:        C9 7D         CMP.B #$7D                
CODE_01C2D0:        F0 01         BEQ CODE_01C2D3           
Return01C2D2:       60            RTS                       ; Return 

CODE_01C2D3:        A0 0B         LDY.B #$0B                
CODE_01C2D5:        B9 C8 14      LDA.W $14C8,Y             
CODE_01C2D8:        C9 0B         CMP.B #$0B                
CODE_01C2DA:        D0 0C         BNE CODE_01C2E8           
CODE_01C2DC:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01C2DF:        C9 7D         CMP.B #$7D                
CODE_01C2E1:        F0 05         BEQ CODE_01C2E8           
CODE_01C2E3:        A9 09         LDA.B #$09                ; \ Sprite status = Carryable 
CODE_01C2E5:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01C2E8:        88            DEY                       
CODE_01C2E9:        10 EA         BPL CODE_01C2D5           
CODE_01C2EB:        A9 00         LDA.B #$00                
CODE_01C2ED:        AC F3 13      LDY.W $13F3               
CODE_01C2F0:        D0 02         BNE CODE_01C2F4           
CODE_01C2F2:        A9 0B         LDA.B #$0B                ; \ Sprite status = Being carried 
CODE_01C2F4:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01C2F7:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01C2F9:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01C2FB:        A5 7B         LDA RAM_MarioSpeedX       
CODE_01C2FD:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01C2FF:        A9 09         LDA.B #$09                
CODE_01C301:        8D F3 13      STA.W $13F3               
CODE_01C304:        A9 FF         LDA.B #$FF                
CODE_01C306:        8D 91 18      STA.W $1891               
CODE_01C309:        A9 1E         LDA.B #$1E                ; \ Play sound effect 
CODE_01C30B:        8D F9 1D      STA.W $1DF9               ; / 
Return01C30E:       60            RTS                       ; Return 

ADDR_01C30F:        9E C8 14      STZ.W $14C8,X             
Return01C312:       60            RTS                       ; Return 


ChangingItemSprite:               .db $74,$75,$77,$76

ChangingItem:       A9 01         LDA.B #$01                
CODE_01C319:        9D 1C 15      STA.W $151C,X             
CODE_01C31C:        BD D0 15      LDA.W $15D0,X             
CODE_01C31F:        D0 03         BNE CODE_01C324           
CODE_01C321:        FE 7B 18      INC.W $187B,X             
CODE_01C324:        BD 7B 18      LDA.W $187B,X             ; \ Determine which power-up to act like 
CODE_01C327:        4A            LSR                       ;  | 
CODE_01C328:        4A            LSR                       ;  | 
CODE_01C329:        4A            LSR                       ;  | 
CODE_01C32A:        4A            LSR                       ;  | 
CODE_01C32B:        4A            LSR                       ;  | 
CODE_01C32C:        4A            LSR                       ;  | 
CODE_01C32D:        29 03         AND.B #$03                ;  | 
CODE_01C32F:        A8            TAY                       ;  | 
CODE_01C330:        B9 13 C3      LDA.W ChangingItemSprite,Y ;  / 
CODE_01C333:        95 9E         STA RAM_SpriteNum,X       ; \ Change into the appropriate power up 
CODE_01C335:        22 8B F7 07   JSL.L LoadSpriteTables    ; / 
CODE_01C339:        20 53 C3      JSR.W PowerUpRt           ; Run the power up code 
CODE_01C33C:        A9 81         LDA.B #$81                ; \ Change it back to the turning item 
CODE_01C33E:        95 9E         STA RAM_SpriteNum,X       ;  | 
CODE_01C340:        22 8B F7 07   JSL.L LoadSpriteTables    ; / 
Return01C344:       60            RTS                       ; Return 


EatenBerryGfxProp:                .db $02,$02,$04,$06

FireFlower:         A5 14         LDA RAM_FrameCounterB     ; \ Flip flower every 8 frames 
CODE_01C34B:        29 08         AND.B #$08                ;  | 
CODE_01C34D:        4A            LSR                       ;  | 
CODE_01C34E:        4A            LSR                       ;  | 
CODE_01C34F:        4A            LSR                       ;  | ($157C,x = 0 or 1) 
CODE_01C350:        9D 7C 15      STA.W RAM_SpriteDir,X     ; / 
PowerUpRt:          BD 0E 16      LDA.W $160E,X             
CODE_01C356:        F0 19         BEQ CODE_01C371           
DrawBerryGfx:       20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01C35B:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01C35E:        A9 80         LDA.B #$80                ; \ Set berry tile to OAM 
CODE_01C360:        99 02 03      STA.W OAM_Tile,Y          ; / 
CODE_01C363:        DA            PHX                       ; \ Set gfx properties of berry 
CODE_01C364:        AE D6 18      LDX.W $18D6               ;  | X = type of berry being eaten 
CODE_01C367:        BD 45 C3      LDA.W EatenBerryGfxProp,X ;  | 
CODE_01C36A:        05 64         ORA $64                   ;  | 
CODE_01C36C:        99 03 03      STA.W OAM_Prop,Y          ; / 
CODE_01C36F:        FA            PLX                       ; X = sprite index 
Return01C370:       60            RTS                       ; Return 

CODE_01C371:        A5 64         LDA $64                   
CODE_01C373:        48            PHA                       
CODE_01C374:        20 AC C4      JSR.W CODE_01C4AC         
CODE_01C377:        BD 34 15      LDA.W $1534,X             
CODE_01C37A:        F0 13         BEQ CODE_01C38F           
CODE_01C37C:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01C37E:        D0 07         BNE CODE_01C387           ; / 
CODE_01C380:        A9 10         LDA.B #$10                
CODE_01C382:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01C384:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01C387:        A5 14         LDA RAM_FrameCounterB     
CODE_01C389:        29 0C         AND.B #$0C                
CODE_01C38B:        D0 1E         BNE CODE_01C3AB           
CODE_01C38D:        68            PLA                       
Return01C38E:       60            RTS                       ; Return 

CODE_01C38F:        BD 40 15      LDA.W $1540,X             
CODE_01C392:        F0 1A         BEQ CODE_01C3AE           
CODE_01C394:        20 40 91      JSR.W CODE_019140         
CODE_01C397:        BD 28 15      LDA.W $1528,X             
CODE_01C39A:        D0 04         BNE CODE_01C3A0           
CODE_01C39C:        A9 10         LDA.B #$10                
CODE_01C39E:        85 64         STA $64                   
CODE_01C3A0:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01C3A2:        D0 07         BNE CODE_01C3AB           ; / 
CODE_01C3A4:        A9 FC         LDA.B #$FC                
CODE_01C3A6:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01C3A8:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01C3AB:        4C 8D C4      JMP.W CODE_01C48D         

CODE_01C3AE:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01C3B0:        D0 F9         BNE CODE_01C3AB           ; / 
CODE_01C3B2:        BD C8 14      LDA.W $14C8,X             
CODE_01C3B5:        C9 0C         CMP.B #$0C                
CODE_01C3B7:        F0 F2         BEQ CODE_01C3AB           
CODE_01C3B9:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01C3BB:        C9 76         CMP.B #$76                ; \ Useless code, branch nowhere if not a star 
CODE_01C3BD:        D0 00         BNE CODE_01C3BF           ; / 
CODE_01C3BF:        FE 70 15      INC.W $1570,X             
CODE_01C3C2:        20 BB 8D      JSR.W CODE_018DBB         
CODE_01C3C5:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01C3C7:        C9 75         CMP.B #$75                ; flower 
CODE_01C3C9:        D0 07         BNE CODE_01C3D2           
CODE_01C3CB:        BD 1C 15      LDA.W $151C,X             
CODE_01C3CE:        D0 02         BNE CODE_01C3D2           
CODE_01C3D0:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_01C3D2:        C9 76         CMP.B #$76                ; star 
CODE_01C3D4:        F0 0B         BEQ CODE_01C3E1           
CODE_01C3D6:        C9 21         CMP.B #$21                ; sprite coin 
CODE_01C3D8:        F0 07         BEQ CODE_01C3E1           
CODE_01C3DA:        BD 1C 15      LDA.W $151C,X             
CODE_01C3DD:        D0 02         BNE CODE_01C3E1           
CODE_01C3DF:        16 B6         ASL RAM_SpriteSpeedX,X    
CODE_01C3E1:        B5 C2         LDA RAM_SpriteState,X     
CODE_01C3E3:        F0 0E         BEQ CODE_01C3F3           
CODE_01C3E5:        30 0A         BMI CODE_01C3F1           
CODE_01C3E7:        20 40 91      JSR.W CODE_019140         
CODE_01C3EA:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_01C3ED:        D0 02         BNE CODE_01C3F1           
CODE_01C3EF:        74 C2         STZ RAM_SpriteState,X     
CODE_01C3F1:        80 44         BRA CODE_01C437           

CODE_01C3F3:        AD 9B 0D      LDA.W $0D9B               
CODE_01C3F6:        C9 C1         CMP.B #$C1                
CODE_01C3F8:        F0 32         BEQ CODE_01C42C           
CODE_01C3FA:        2C 9B 0D      BIT.W $0D9B               
CODE_01C3FD:        50 2D         BVC CODE_01C42C           
ADDR_01C3FF:        9E 88 15      STZ.W RAM_SprObjStatus,X  
ADDR_01C402:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
ADDR_01C404:        BD D4 14      LDA.W RAM_SpriteYHi,X     
ADDR_01C407:        D0 15         BNE ADDR_01C41E           
ADDR_01C409:        B5 D8         LDA RAM_SpriteYLo,X       
ADDR_01C40B:        C9 A0         CMP.B #$A0                
ADDR_01C40D:        90 0F         BCC ADDR_01C41E           
ADDR_01C40F:        29 F0         AND.B #$F0                
ADDR_01C411:        95 D8         STA RAM_SpriteYLo,X       
ADDR_01C413:        BD 88 15      LDA.W RAM_SprObjStatus,X  
ADDR_01C416:        09 04         ORA.B #$04                
ADDR_01C418:        9D 88 15      STA.W RAM_SprObjStatus,X  
ADDR_01C41B:        20 BB 8D      JSR.W CODE_018DBB         
ADDR_01C41E:        20 CC AB      JSR.W SubSprXPosNoGrvty   
ADDR_01C421:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
ADDR_01C424:        F6 AA         INC RAM_SpriteSpeedY,X    
ADDR_01C426:        F6 AA         INC RAM_SpriteSpeedY,X    
ADDR_01C428:        F6 AA         INC RAM_SpriteSpeedY,X    
ADDR_01C42A:        80 03         BRA CODE_01C42F           

CODE_01C42C:        20 32 90      JSR.W SubUpdateSprPos     
CODE_01C42F:        A5 13         LDA RAM_FrameCounter      
CODE_01C431:        29 03         AND.B #$03                
CODE_01C433:        F0 02         BEQ CODE_01C437           
CODE_01C435:        D6 AA         DEC RAM_SpriteSpeedY,X    
CODE_01C437:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01C43A:        20 14 80      JSR.W IsTouchingCeiling   
CODE_01C43D:        F0 04         BEQ CODE_01C443           
CODE_01C43F:        A9 00         LDA.B #$00                
CODE_01C441:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01C443:        20 0E 80      JSR.W IsOnGround          
CODE_01C446:        D0 02         BNE CODE_01C44A           
CODE_01C448:        80 34         BRA CODE_01C47E           

CODE_01C44A:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01C44C:        C9 21         CMP.B #$21                ; sprite coin 
CODE_01C44E:        D0 1C         BNE CODE_01C46C           
CODE_01C450:        20 BB 8D      JSR.W CODE_018DBB         
CODE_01C453:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01C455:        1A            INC A                     
CODE_01C456:        48            PHA                       
CODE_01C457:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_01C45A:        68            PLA                       
CODE_01C45B:        4A            LSR                       
CODE_01C45C:        20 EC CC      JSR.W CODE_01CCEC         
CODE_01C45F:        C9 FC         CMP.B #$FC                
CODE_01C461:        B0 07         BCS CODE_01C46A           
CODE_01C463:        BC 88 15      LDY.W RAM_SprObjStatus,X  
CODE_01C466:        30 02         BMI CODE_01C46A           
CODE_01C468:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01C46A:        80 12         BRA CODE_01C47E           

CODE_01C46C:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_01C46F:        BD 1C 15      LDA.W $151C,X             
CODE_01C472:        D0 06         BNE CODE_01C47A           
CODE_01C474:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01C476:        C9 76         CMP.B #$76                ; star 
CODE_01C478:        D0 04         BNE CODE_01C47E           
CODE_01C47A:        A9 C8         LDA.B #$C8                
CODE_01C47C:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01C47E:        BD 58 15      LDA.W $1558,X             
CODE_01C481:        15 C2         ORA RAM_SpriteState,X     
CODE_01C483:        D0 08         BNE CODE_01C48D           
CODE_01C485:        20 08 80      JSR.W IsTouchingObjSide   
CODE_01C488:        F0 03         BEQ CODE_01C48D           
CODE_01C48A:        20 98 90      JSR.W FlipSpriteDir       
CODE_01C48D:        BD 40 15      LDA.W $1540,X             
CODE_01C490:        C9 36         CMP.B #$36                
CODE_01C492:        B0 14         BCS CODE_01C4A8           
CODE_01C494:        B5 C2         LDA RAM_SpriteState,X     
CODE_01C496:        F0 04         BEQ CODE_01C49C           
CODE_01C498:        C9 FF         CMP.B #$FF                
CODE_01C49A:        D0 05         BNE CODE_01C4A1           
CODE_01C49C:        BD 32 16      LDA.W RAM_SprBehindScrn,X 
CODE_01C49F:        F0 04         BEQ CODE_01C4A5           
CODE_01C4A1:        A9 10         LDA.B #$10                
CODE_01C4A3:        85 64         STA $64                   
CODE_01C4A5:        20 1A C6      JSR.W CODE_01C61A         
CODE_01C4A8:        68            PLA                       
CODE_01C4A9:        85 64         STA $64                   
Return01C4AB:       60            RTS                       ; Return 

CODE_01C4AC:        20 0F A8      JSR.W CODE_01A80F         
CODE_01C4AF:        90 FA         BCC Return01C4AB          
CODE_01C4B1:        BD 1C 15      LDA.W $151C,X             
CODE_01C4B4:        F0 04         BEQ CODE_01C4BA           
CODE_01C4B6:        B5 C2         LDA RAM_SpriteState,X     
CODE_01C4B8:        D0 40         BNE Return01C4FA          
CODE_01C4BA:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_01C4BD:        D0 3B         BNE Return01C4FA          
CODE_01C4BF:        BD 40 15      LDA.W $1540,X             
CODE_01C4C2:        C9 18         CMP.B #$18                
CODE_01C4C4:        B0 34         BCS Return01C4FA          
CODE_01C4C6:        9E C8 14      STZ.W $14C8,X             
CODE_01C4C9:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01C4CB:        C9 21         CMP.B #$21                
CODE_01C4CD:        D0 69         BNE TouchedPowerUp        
CODE_01C4CF:        22 4A B3 05   JSL.L CODE_05B34A         
CODE_01C4D3:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01C4D6:        29 0E         AND.B #$0E                
CODE_01C4D8:        C9 02         CMP.B #$02                
CODE_01C4DA:        F0 04         BEQ CODE_01C4E0           
CODE_01C4DC:        A9 01         LDA.B #$01                
CODE_01C4DE:        80 0C         BRA CODE_01C4EC           

CODE_01C4E0:        AD DD 18      LDA.W $18DD               
CODE_01C4E3:        EE DD 18      INC.W $18DD               
CODE_01C4E6:        C9 0A         CMP.B #$0A                
CODE_01C4E8:        90 02         BCC CODE_01C4EC           
CODE_01C4EA:        A9 0A         LDA.B #$0A                
CODE_01C4EC:        22 E5 AC 02   JSL.L GivePoints          
CODE_01C4F0:        A0 03         LDY.B #$03                
CODE_01C4F2:        B9 C0 17      LDA.W $17C0,Y             
CODE_01C4F5:        F0 04         BEQ CODE_01C4FB           
CODE_01C4F7:        88            DEY                       
CODE_01C4F8:        10 F8         BPL CODE_01C4F2           
Return01C4FA:       60            RTS                       ; Return 

CODE_01C4FB:        A9 05         LDA.B #$05                
CODE_01C4FD:        99 C0 17      STA.W $17C0,Y             
CODE_01C500:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01C502:        99 C8 17      STA.W $17C8,Y             
CODE_01C505:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01C507:        99 C4 17      STA.W $17C4,Y             
CODE_01C50A:        A9 10         LDA.B #$10                
CODE_01C50C:        99 CC 17      STA.W $17CC,Y             
Return01C50F:       60            RTS                       ; Return 


ItemBoxSprite:                    .db $00,$01,$01,$01,$00,$01,$04,$02
                                  .db $00,$00,$00,$00,$00,$01,$04,$02
                                  .db $00,$00,$00,$00

GivePowerPtrIndex:                .db $00,$01,$01,$01,$04,$04,$04,$01
                                  .db $02,$02,$02,$02,$03,$03,$01,$03
                                  .db $05,$05,$05,$05

TouchedPowerUp:     38            SEC                       ; \ Index created from... 
CODE_01C539:        E9 74         SBC.B #$74                ;  | ... powerup touched (upper 2 bits)  
CODE_01C53B:        0A            ASL                       ;  | 
CODE_01C53C:        0A            ASL                       ;  | 
CODE_01C53D:        05 19         ORA RAM_MarioPowerUp      ;  | ... Mario's status (lower 3 bits) 
CODE_01C53F:        A8            TAY                       ; / 
CODE_01C540:        B9 10 C5      LDA.W ItemBoxSprite,Y     ; \ Put appropriate item in item box 
CODE_01C543:        F0 08         BEQ NoItem                ;  | 
CODE_01C545:        8D C2 0D      STA.W $0DC2               ; / 
CODE_01C548:        A9 0B         LDA.B #$0B                ; \  
CODE_01C54A:        8D FC 1D      STA.W $1DFC               ; / Play sound effect 
NoItem:             B9 24 C5      LDA.W GivePowerPtrIndex,Y ; \ Call routine to change Mario's status 
CODE_01C550:        22 DF 86 00   JSL.L ExecutePtr          ; / 

HandlePowerUpPtrs:     61 C5      .dw GiveMarioMushroom     ; 0 - Big 
                       6F C5      .dw CODE_01C56F           ; 1 - No change 
                       92 C5      .dw GiveMarioStar         ; 2 - Star 
                       98 C5      .dw GiveMarioCape         ; 3 - Cape 
                       EC C5      .dw GiveMarioFire         ; 4 - Fire 
                       FE C5      .dw GiveMario1Up          ; 5 - 1Up 13

Return01C560:       60            RTS                       

GiveMarioMushroom:  A9 02         LDA.B #$02                ; \ Set growing action 
CODE_01C563:        85 71         STA RAM_MarioAnimation    ; / 
CODE_01C565:        A9 2F         LDA.B #$2F                ; \  
CODE_01C567:        99 96 14      STA.W $1496,Y             ;  | Set animation timer 
CODE_01C56A:        85 9D         STA RAM_SpritesLocked     ; / Set lock sprites timer 
CODE_01C56C:        4C 6F C5      JMP.W CODE_01C56F         ; JMP to next instruction? 

CODE_01C56F:        A9 04         LDA.B #$04                
CODE_01C571:        BC 34 15      LDY.W $1534,X             
CODE_01C574:        D0 04         BNE CODE_01C57A           
CODE_01C576:        22 E5 AC 02   JSL.L GivePoints          
CODE_01C57A:        A9 0A         LDA.B #$0A                ; \ 
CODE_01C57C:        8D F9 1D      STA.W $1DF9               ; / 
Return01C57F:       60            RTS                       ; Return 

CODE_01C580:        A9 FF         LDA.B #$FF                ; \ Set star timer 
CODE_01C582:        8D 90 14      STA.W $1490               ; / 
CODE_01C585:        A9 0D         LDA.B #$0D                
CODE_01C587:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_01C58A:        0E DA 0D      ASL.W $0DDA               
CODE_01C58D:        38            SEC                       
CODE_01C58E:        6E DA 0D      ROR.W $0DDA               
Return01C591:       6B            RTL                       ; Return 

GiveMarioStar:      22 80 C5 01   JSL.L CODE_01C580         
CODE_01C596:        80 D7         BRA CODE_01C56F           

GiveMarioCape:      A9 02         LDA.B #$02                
CODE_01C59A:        85 19         STA RAM_MarioPowerUp      
CODE_01C59C:        A9 0D         LDA.B #$0D                ; \ Play sound effect 
CODE_01C59E:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01C5A1:        A9 04         LDA.B #$04                
CODE_01C5A3:        22 E5 AC 02   JSL.L GivePoints          
CODE_01C5A7:        22 AE C5 01   JSL.L CODE_01C5AE         
CODE_01C5AB:        E6 9D         INC RAM_SpritesLocked     
Return01C5AD:       60            RTS                       ; Return 

CODE_01C5AE:        A5 81         LDA $81                   
CODE_01C5B0:        05 7F         ORA $7F                   
CODE_01C5B2:        D0 37         BNE Return01C5EB          
CODE_01C5B4:        A9 03         LDA.B #$03                
CODE_01C5B6:        85 71         STA RAM_MarioAnimation    
CODE_01C5B8:        A9 18         LDA.B #$18                
CODE_01C5BA:        8D 96 14      STA.W $1496               
CODE_01C5BD:        A0 03         LDY.B #$03                
CODE_01C5BF:        B9 C0 17      LDA.W $17C0,Y             
CODE_01C5C2:        F0 10         BEQ CODE_01C5D4           
CODE_01C5C4:        88            DEY                       
CODE_01C5C5:        10 F8         BPL CODE_01C5BF           
CODE_01C5C7:        CE 63 18      DEC.W $1863               
CODE_01C5CA:        10 05         BPL CODE_01C5D1           
CODE_01C5CC:        A9 03         LDA.B #$03                
CODE_01C5CE:        8D 63 18      STA.W $1863               
CODE_01C5D1:        AC 63 18      LDY.W $1863               
CODE_01C5D4:        A9 81         LDA.B #$81                
CODE_01C5D6:        99 C0 17      STA.W $17C0,Y             
CODE_01C5D9:        A9 1B         LDA.B #$1B                
CODE_01C5DB:        99 CC 17      STA.W $17CC,Y             
CODE_01C5DE:        A5 96         LDA RAM_MarioYPos         
CODE_01C5E0:        18            CLC                       
CODE_01C5E1:        69 08         ADC.B #$08                
CODE_01C5E3:        99 C4 17      STA.W $17C4,Y             
CODE_01C5E6:        A5 94         LDA RAM_MarioXPos         
CODE_01C5E8:        99 C8 17      STA.W $17C8,Y             
Return01C5EB:       6B            RTL                       ; Return 

GiveMarioFire:      A9 20         LDA.B #$20                
CODE_01C5EE:        8D 9B 14      STA.W RAM_FlashingPalTimer 
CODE_01C5F1:        85 9D         STA RAM_SpritesLocked     
CODE_01C5F3:        A9 04         LDA.B #$04                
CODE_01C5F5:        85 71         STA RAM_MarioAnimation    
CODE_01C5F7:        A9 03         LDA.B #$03                
CODE_01C5F9:        85 19         STA RAM_MarioPowerUp      
CODE_01C5FB:        4C 6F C5      JMP.W CODE_01C56F         

GiveMario1Up:       A9 08         LDA.B #$08                
CODE_01C600:        18            CLC                       
CODE_01C601:        7D 94 15      ADC.W $1594,X             
CODE_01C604:        22 E5 AC 02   JSL.L GivePoints          
Return01C608:       60            RTS                       ; Return 


PowerUpTiles:                     .db $24,$26,$48,$0E,$24,$00,$00,$00
                                  .db $00,$E4,$E8,$24,$EC

StarPalValues:                    .db $00,$04,$08,$04

CODE_01C61A:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01C61D:        64 0A         STZ $0A                   
CODE_01C61F:        AD 0F 14      LDA.W $140F               
CODE_01C622:        D0 12         BNE CODE_01C636           
CODE_01C624:        AD 9B 0D      LDA.W $0D9B               
CODE_01C627:        C9 C1         CMP.B #$C1                
CODE_01C629:        F0 0B         BEQ CODE_01C636           
CODE_01C62B:        2C 9B 0D      BIT.W $0D9B               
CODE_01C62E:        50 06         BVC CODE_01C636           
CODE_01C630:        A9 D8         LDA.B #$D8                
CODE_01C632:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_01C635:        A8            TAY                       
CODE_01C636:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01C638:        C9 21         CMP.B #$21                ; sprite coin 
CODE_01C63A:        D0 65         BNE PowerUpGfxRt          
CODE_01C63C:        22 41 C6 01   JSL.L CoinSprGfx          
Return01C640:       60            RTS                       ; Return 

CoinSprGfx:         20 45 C6      JSR.W CoinSprGfxSub       
Return01C644:       6B            RTL                       ; Return 

CoinSprGfxSub:      20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01C648:        A5 00         LDA $00                   
CODE_01C64A:        99 00 03      STA.W OAM_DispX,Y         
CODE_01C64D:        A5 01         LDA $01                   
CODE_01C64F:        99 01 03      STA.W OAM_DispY,Y         
CODE_01C652:        A9 E8         LDA.B #$E8                
CODE_01C654:        99 02 03      STA.W OAM_Tile,Y          
CODE_01C657:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01C65A:        05 64         ORA $64                   
CODE_01C65C:        99 03 03      STA.W OAM_Prop,Y          
CODE_01C65F:        8A            TXA                       
CODE_01C660:        18            CLC                       
CODE_01C661:        65 14         ADC RAM_FrameCounterB     
CODE_01C663:        4A            LSR                       
CODE_01C664:        4A            LSR                       
CODE_01C665:        29 03         AND.B #$03                
CODE_01C667:        D0 07         BNE CODE_01C670           
CODE_01C669:        A0 02         LDY.B #$02                
CODE_01C66B:        80 2D         BRA CODE_01C69A           


MovingCoinTiles:                  .db $EA,$FA,$EA

CODE_01C670:        DA            PHX                       
CODE_01C671:        AA            TAX                       
CODE_01C672:        A5 00         LDA $00                   
CODE_01C674:        18            CLC                       
CODE_01C675:        69 04         ADC.B #$04                
CODE_01C677:        99 00 03      STA.W OAM_DispX,Y         
CODE_01C67A:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_01C67D:        A5 01         LDA $01                   
CODE_01C67F:        18            CLC                       
CODE_01C680:        69 08         ADC.B #$08                
CODE_01C682:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_01C685:        BF 6C C6 01   LDA.L MovingCoinTiles-1,X 
CODE_01C689:        99 02 03      STA.W OAM_Tile,Y          
CODE_01C68C:        99 06 03      STA.W OAM_Tile2,Y         
CODE_01C68F:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_01C692:        09 80         ORA.B #$80                
CODE_01C694:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_01C697:        FA            PLX                       
CODE_01C698:        A0 00         LDY.B #$00                
CODE_01C69A:        A9 01         LDA.B #$01                
CODE_01C69C:        22 B3 B7 01   JSL.L FinishOAMWrite      
Return01C6A0:       60            RTS                       ; Return 

PowerUpGfxRt:       C9 76         CMP.B #$76                ; \ Setup flashing palette for star 
CODE_01C6A3:        D0 0D         BNE NoFlashingPal         ;  | 
CODE_01C6A5:        A5 13         LDA RAM_FrameCounter      ;  |  
CODE_01C6A7:        4A            LSR                       ;  | 
CODE_01C6A8:        29 03         AND.B #$03                ;  | 
CODE_01C6AA:        5A            PHY                       ;  | 
CODE_01C6AB:        A8            TAY                       ;  | 
CODE_01C6AC:        B9 16 C6      LDA.W StarPalValues,Y     ;  | 
CODE_01C6AF:        7A            PLY                       ;  | 
CODE_01C6B0:        85 0A         STA $0A                   ; / $0A contains palette info, will be applied later 
NoFlashingPal:      A5 00         LDA $00                   ; \ Set tile x position 
CODE_01C6B4:        99 00 03      STA.W OAM_DispX,Y         ; / 
CODE_01C6B7:        A5 01         LDA $01                   ; \ Set tile y position 
CODE_01C6B9:        3A            DEC A                     ;  | 
CODE_01C6BA:        99 01 03      STA.W OAM_DispY,Y         ; / 
CODE_01C6BD:        BD 7C 15      LDA.W RAM_SpriteDir,X     ; \ Flip flower/cape if 157C,x is set 
CODE_01C6C0:        4A            LSR                       ;  | 
CODE_01C6C1:        A9 00         LDA.B #$00                ;  | 
CODE_01C6C3:        B0 02         BCS CODE_01C6C7           ;  | 
CODE_01C6C5:        09 40         ORA.B #$40                ; / 
CODE_01C6C7:        05 64         ORA $64                   ; \ Add in level priority information 
CODE_01C6C9:        1D F6 15      ORA.W RAM_SpritePal,X     ;  | Add in palette/gfx page 
CODE_01C6CC:        45 0A         EOR $0A                   ;  | Adjust palette for star 
CODE_01C6CE:        99 03 03      STA.W OAM_Prop,Y          ; / Set property byte 
CODE_01C6D1:        B5 9E         LDA RAM_SpriteNum,X       ; \ Set powerup tile 
CODE_01C6D3:        38            SEC                       ;  | 
CODE_01C6D4:        E9 74         SBC.B #$74                ;  | 
CODE_01C6D6:        AA            TAX                       ;  | X = Sprite number - #$74 
CODE_01C6D7:        BD 09 C6      LDA.W PowerUpTiles,X      ;  | 
CODE_01C6DA:        99 02 03      STA.W OAM_Tile,Y          ; / 
CODE_01C6DD:        AE E9 15      LDX.W $15E9               ; X = sprite index 
CODE_01C6E0:        A9 00         LDA.B #$00                
CODE_01C6E2:        20 7E B3      JSR.W CODE_01B37E         
Return01C6E5:       60            RTS                       ; Return 


DATA_01C6E6:                      .db $02,$FE

DATA_01C6E8:                      .db $20,$E0

DATA_01C6EA:                      .db $0A,$F6,$08

Feather:            A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01C6EF:        D0 53         BNE CODE_01C744           ; / 
CODE_01C6F1:        B5 C2         LDA RAM_SpriteState,X     
CODE_01C6F3:        F0 0C         BEQ CODE_01C701           
CODE_01C6F5:        20 40 91      JSR.W CODE_019140         
CODE_01C6F8:        BD 88 15      LDA.W RAM_SprObjStatus,X  
CODE_01C6FB:        D0 02         BNE CODE_01C6FF           
ADDR_01C6FD:        74 C2         STZ RAM_SpriteState,X     
CODE_01C6FF:        80 40         BRA CODE_01C741           

CODE_01C701:        BD C8 14      LDA.W $14C8,X             
CODE_01C704:        C9 0C         CMP.B #$0C                
CODE_01C706:        F0 3C         BEQ CODE_01C744           
CODE_01C708:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_01C70B:        F0 08         BEQ CODE_01C715           
CODE_01C70D:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01C710:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_01C712:        4C 41 C7      JMP.W CODE_01C741         

CODE_01C715:        BD 28 15      LDA.W $1528,X             
CODE_01C718:        29 01         AND.B #$01                
CODE_01C71A:        A8            TAY                       
CODE_01C71B:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01C71D:        18            CLC                       
CODE_01C71E:        79 E6 C6      ADC.W DATA_01C6E6,Y       
CODE_01C721:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01C723:        D9 E8 C6      CMP.W DATA_01C6E8,Y       
CODE_01C726:        D0 03         BNE CODE_01C72B           
CODE_01C728:        FE 28 15      INC.W $1528,X             
CODE_01C72B:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01C72D:        10 01         BPL CODE_01C730           
CODE_01C72F:        C8            INY                       
CODE_01C730:        B9 EA C6      LDA.W DATA_01C6EA,Y       
CODE_01C733:        18            CLC                       
CODE_01C734:        69 06         ADC.B #$06                
CODE_01C736:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01C738:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01C73B:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01C73E:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01C741:        20 15 9A      JSR.W UpdateDirection     
CODE_01C744:        20 AC C4      JSR.W CODE_01C4AC         
CODE_01C747:        4C 1A C6      JMP.W CODE_01C61A         

InitBrwnChainPlat:  A9 80         LDA.B #$80                
CODE_01C74C:        9D 1C 15      STA.W $151C,X             
CODE_01C74F:        A9 01         LDA.B #$01                
CODE_01C751:        9D 28 15      STA.W $1528,X             
CODE_01C754:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01C756:        18            CLC                       
CODE_01C757:        69 78         ADC.B #$78                
CODE_01C759:        95 E4         STA RAM_SpriteXLo,X       
CODE_01C75B:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01C75E:        69 00         ADC.B #$00                
CODE_01C760:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01C763:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01C765:        18            CLC                       
CODE_01C766:        69 68         ADC.B #$68                
CODE_01C768:        95 D8         STA RAM_SpriteYLo,X       
CODE_01C76A:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01C76D:        69 00         ADC.B #$00                
CODE_01C76F:        9D D4 14      STA.W RAM_SpriteYHi,X     
Return01C772:       60            RTS                       ; Return 

BrownChainedPlat:   20 27 AC      JSR.W SubOffscreen2Bnk1   
CODE_01C776:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01C778:        D0 1B         BNE CODE_01C795           ; / 
CODE_01C77A:        A5 13         LDA RAM_FrameCounter      
CODE_01C77C:        29 03         AND.B #$03                
CODE_01C77E:        1D 02 16      ORA.W $1602,X             
CODE_01C781:        D0 12         BNE CODE_01C795           
CODE_01C783:        A9 01         LDA.B #$01                
CODE_01C785:        BC 04 15      LDY.W $1504,X             
CODE_01C788:        F0 0B         BEQ CODE_01C795           
CODE_01C78A:        30 02         BMI CODE_01C78E           
CODE_01C78C:        A9 FF         LDA.B #$FF                
CODE_01C78E:        18            CLC                       
CODE_01C78F:        7D 04 15      ADC.W $1504,X             
CODE_01C792:        9D 04 15      STA.W $1504,X             
CODE_01C795:        BD 1C 15      LDA.W $151C,X             
CODE_01C798:        48            PHA                       
CODE_01C799:        BD 28 15      LDA.W $1528,X             
CODE_01C79C:        48            PHA                       
CODE_01C79D:        A9 00         LDA.B #$00                
CODE_01C79F:        38            SEC                       
CODE_01C7A0:        FD 1C 15      SBC.W $151C,X             
CODE_01C7A3:        9D 1C 15      STA.W $151C,X             
CODE_01C7A6:        A9 02         LDA.B #$02                
CODE_01C7A8:        FD 28 15      SBC.W $1528,X             
CODE_01C7AB:        29 01         AND.B #$01                
CODE_01C7AD:        9D 28 15      STA.W $1528,X             
CODE_01C7B0:        20 CB CA      JSR.W CODE_01CACB         
CODE_01C7B3:        20 20 CB      JSR.W CODE_01CB20         
CODE_01C7B6:        20 53 CB      JSR.W CODE_01CB53         
CODE_01C7B9:        68            PLA                       
CODE_01C7BA:        9D 28 15      STA.W $1528,X             
CODE_01C7BD:        68            PLA                       
CODE_01C7BE:        9D 1C 15      STA.W $151C,X             
CODE_01C7C1:        AD B8 14      LDA.W $14B8               
CODE_01C7C4:        48            PHA                       
CODE_01C7C5:        38            SEC                       
CODE_01C7C6:        F5 C2         SBC RAM_SpriteState,X     
CODE_01C7C8:        8D 91 14      STA.W $1491               
CODE_01C7CB:        68            PLA                       
CODE_01C7CC:        95 C2         STA RAM_SpriteState,X     
CODE_01C7CE:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01C7D1:        AD BA 14      LDA.W $14BA               
CODE_01C7D4:        38            SEC                       
CODE_01C7D5:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01C7D7:        38            SEC                       
CODE_01C7D8:        E9 08         SBC.B #$08                
CODE_01C7DA:        99 01 03      STA.W OAM_DispY,Y         
CODE_01C7DD:        AD B8 14      LDA.W $14B8               
CODE_01C7E0:        38            SEC                       
CODE_01C7E1:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01C7E3:        38            SEC                       
CODE_01C7E4:        E9 08         SBC.B #$08                
CODE_01C7E6:        99 00 03      STA.W OAM_DispX,Y         
CODE_01C7E9:        A9 A2         LDA.B #$A2                
CODE_01C7EB:        99 02 03      STA.W OAM_Tile,Y          
CODE_01C7EE:        A9 31         LDA.B #$31                
CODE_01C7F0:        99 03 03      STA.W OAM_Prop,Y          
CODE_01C7F3:        A0 00         LDY.B #$00                
CODE_01C7F5:        AD BA 14      LDA.W $14BA               
CODE_01C7F8:        38            SEC                       
CODE_01C7F9:        ED B2 14      SBC.W $14B2               
CODE_01C7FC:        10 04         BPL CODE_01C802           
CODE_01C7FE:        49 FF         EOR.B #$FF                
CODE_01C800:        1A            INC A                     
CODE_01C801:        C8            INY                       
CODE_01C802:        84 00         STY $00                   
CODE_01C804:        8D 05 42      STA.W $4205               ; Dividend (High-Byte)
CODE_01C807:        9C 04 42      STZ.W $4204               ; Dividend (Low Byte)
CODE_01C80A:        A9 05         LDA.B #$05                
CODE_01C80C:        8D 06 42      STA.W $4206               ; Divisor B
CODE_01C80F:        20 94 CC      JSR.W DoNothing           
CODE_01C812:        AD 14 42      LDA.W $4214               ; Quotient of Divide Result (Low Byte)
CODE_01C815:        85 02         STA $02                   
CODE_01C817:        85 06         STA $06                   
CODE_01C819:        AD 15 42      LDA.W $4215               ; Quotient of Divide Result (High Byte)
CODE_01C81C:        85 03         STA $03                   
CODE_01C81E:        85 07         STA $07                   
CODE_01C820:        A0 00         LDY.B #$00                
CODE_01C822:        AD B8 14      LDA.W $14B8               
CODE_01C825:        38            SEC                       
CODE_01C826:        ED B0 14      SBC.W $14B0               
CODE_01C829:        10 04         BPL CODE_01C82F           
CODE_01C82B:        49 FF         EOR.B #$FF                
CODE_01C82D:        1A            INC A                     
CODE_01C82E:        C8            INY                       
CODE_01C82F:        84 01         STY $01                   
CODE_01C831:        8D 05 42      STA.W $4205               ; Dividend (High-Byte)
CODE_01C834:        9C 04 42      STZ.W $4204               ; Dividend (Low Byte)
CODE_01C837:        A9 05         LDA.B #$05                
CODE_01C839:        8D 06 42      STA.W $4206               ; Divisor B
CODE_01C83C:        20 94 CC      JSR.W DoNothing           
CODE_01C83F:        AD 14 42      LDA.W $4214               ; Quotient of Divide Result (Low Byte)
CODE_01C842:        85 04         STA $04                   
CODE_01C844:        85 08         STA $08                   
CODE_01C846:        AD 15 42      LDA.W $4215               ; Quotient of Divide Result (High Byte)
CODE_01C849:        85 05         STA $05                   
CODE_01C84B:        85 09         STA $09                   
CODE_01C84D:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01C850:        C8            INY                       
CODE_01C851:        C8            INY                       
CODE_01C852:        C8            INY                       
CODE_01C853:        C8            INY                       
CODE_01C854:        AD B2 14      LDA.W $14B2               
CODE_01C857:        38            SEC                       
CODE_01C858:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01C85A:        38            SEC                       
CODE_01C85B:        E9 08         SBC.B #$08                
CODE_01C85D:        85 0A         STA $0A                   
CODE_01C85F:        99 01 03      STA.W OAM_DispY,Y         
CODE_01C862:        AD B0 14      LDA.W $14B0               
CODE_01C865:        38            SEC                       
CODE_01C866:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01C868:        38            SEC                       
CODE_01C869:        E9 08         SBC.B #$08                
CODE_01C86B:        85 0B         STA $0B                   
CODE_01C86D:        99 00 03      STA.W OAM_DispX,Y         
CODE_01C870:        A9 A2         LDA.B #$A2                
CODE_01C872:        99 02 03      STA.W OAM_Tile,Y          
CODE_01C875:        A9 31         LDA.B #$31                
CODE_01C877:        99 03 03      STA.W OAM_Prop,Y          
CODE_01C87A:        A2 03         LDX.B #$03                
CODE_01C87C:        C8            INY                       
CODE_01C87D:        C8            INY                       
CODE_01C87E:        C8            INY                       
CODE_01C87F:        C8            INY                       
CODE_01C880:        A5 00         LDA $00                   
CODE_01C882:        D0 0A         BNE CODE_01C88E           
CODE_01C884:        A5 0A         LDA $0A                   
CODE_01C886:        18            CLC                       
CODE_01C887:        65 07         ADC $07                   
CODE_01C889:        99 01 03      STA.W OAM_DispY,Y         
CODE_01C88C:        80 08         BRA CODE_01C896           

CODE_01C88E:        A5 0A         LDA $0A                   
CODE_01C890:        38            SEC                       
CODE_01C891:        E5 07         SBC $07                   
CODE_01C893:        99 01 03      STA.W OAM_DispY,Y         
CODE_01C896:        A5 06         LDA $06                   
CODE_01C898:        18            CLC                       
CODE_01C899:        65 02         ADC $02                   
CODE_01C89B:        85 06         STA $06                   
CODE_01C89D:        A5 07         LDA $07                   
CODE_01C89F:        65 03         ADC $03                   
CODE_01C8A1:        85 07         STA $07                   
CODE_01C8A3:        A5 01         LDA $01                   
CODE_01C8A5:        D0 0A         BNE CODE_01C8B1           
CODE_01C8A7:        A5 0B         LDA $0B                   
CODE_01C8A9:        18            CLC                       
CODE_01C8AA:        65 09         ADC $09                   
CODE_01C8AC:        99 00 03      STA.W OAM_DispX,Y         
CODE_01C8AF:        80 08         BRA CODE_01C8B9           

CODE_01C8B1:        A5 0B         LDA $0B                   
CODE_01C8B3:        38            SEC                       
CODE_01C8B4:        E5 09         SBC $09                   
CODE_01C8B6:        99 00 03      STA.W OAM_DispX,Y         
CODE_01C8B9:        A5 08         LDA $08                   
CODE_01C8BB:        18            CLC                       
CODE_01C8BC:        65 04         ADC $04                   
CODE_01C8BE:        85 08         STA $08                   
CODE_01C8C0:        A5 09         LDA $09                   
CODE_01C8C2:        65 05         ADC $05                   
CODE_01C8C4:        85 09         STA $09                   
CODE_01C8C6:        A9 A2         LDA.B #$A2                
CODE_01C8C8:        99 02 03      STA.W OAM_Tile,Y          
CODE_01C8CB:        A9 31         LDA.B #$31                
CODE_01C8CD:        99 03 03      STA.W OAM_Prop,Y          
CODE_01C8D0:        CA            DEX                       
CODE_01C8D1:        10 A9         BPL CODE_01C87C           
CODE_01C8D3:        A2 03         LDX.B #$03                
CODE_01C8D5:        86 02         STX $02                   
CODE_01C8D7:        C8            INY                       
CODE_01C8D8:        C8            INY                       
CODE_01C8D9:        C8            INY                       
CODE_01C8DA:        C8            INY                       
CODE_01C8DB:        AD BA 14      LDA.W $14BA               
CODE_01C8DE:        38            SEC                       
CODE_01C8DF:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01C8E1:        38            SEC                       
CODE_01C8E2:        E9 10         SBC.B #$10                
CODE_01C8E4:        99 01 03      STA.W OAM_DispY,Y         
CODE_01C8E7:        AD B8 14      LDA.W $14B8               
CODE_01C8EA:        38            SEC                       
CODE_01C8EB:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01C8ED:        18            CLC                       
CODE_01C8EE:        7D B7 C9      ADC.W DATA_01C9B7,X       
CODE_01C8F1:        99 00 03      STA.W OAM_DispX,Y         
CODE_01C8F4:        BD BB C9      LDA.W BrwnChainPlatTiles,X 
CODE_01C8F7:        99 02 03      STA.W OAM_Tile,Y          
CODE_01C8FA:        A9 31         LDA.B #$31                
CODE_01C8FC:        99 03 03      STA.W OAM_Prop,Y          
CODE_01C8FF:        CA            DEX                       
CODE_01C900:        10 D3         BPL CODE_01C8D5           
CODE_01C902:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01C905:        A9 09         LDA.B #$09                
CODE_01C907:        85 08         STA $08                   
CODE_01C909:        AD B2 14      LDA.W $14B2               
CODE_01C90C:        38            SEC                       
CODE_01C90D:        E9 08         SBC.B #$08                
CODE_01C90F:        85 00         STA $00                   
CODE_01C911:        AD B3 14      LDA.W $14B3               
CODE_01C914:        E9 00         SBC.B #$00                
CODE_01C916:        85 01         STA $01                   
CODE_01C918:        AD B0 14      LDA.W $14B0               
CODE_01C91B:        38            SEC                       
CODE_01C91C:        E9 08         SBC.B #$08                
CODE_01C91E:        85 02         STA $02                   
CODE_01C920:        AD B1 14      LDA.W $14B1               
CODE_01C923:        E9 00         SBC.B #$00                
CODE_01C925:        85 03         STA $03                   
CODE_01C927:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01C92A:        B9 05 03      LDA.W OAM_Tile2DispY,Y    
CODE_01C92D:        85 06         STA $06                   
CODE_01C92F:        B9 04 03      LDA.W OAM_Tile2DispX,Y    
CODE_01C932:        85 07         STA $07                   
CODE_01C934:        98            TYA                       
CODE_01C935:        4A            LSR                       
CODE_01C936:        4A            LSR                       
CODE_01C937:        AA            TAX                       
CODE_01C938:        A9 02         LDA.B #$02                
CODE_01C93A:        9D 60 04      STA.W OAM_TileSize,X      
CODE_01C93D:        A2 00         LDX.B #$00                
CODE_01C93F:        B9 00 03      LDA.W OAM_DispX,Y         
CODE_01C942:        38            SEC                       
CODE_01C943:        E5 07         SBC $07                   
CODE_01C945:        10 01         BPL CODE_01C948           
CODE_01C947:        CA            DEX                       
CODE_01C948:        18            CLC                       
CODE_01C949:        65 02         ADC $02                   
CODE_01C94B:        85 04         STA $04                   
CODE_01C94D:        8A            TXA                       
CODE_01C94E:        65 03         ADC $03                   
CODE_01C950:        85 05         STA $05                   
CODE_01C952:        20 44 B8      JSR.W CODE_01B844         
CODE_01C955:        90 09         BCC CODE_01C960           
CODE_01C957:        98            TYA                       
CODE_01C958:        4A            LSR                       
CODE_01C959:        4A            LSR                       
CODE_01C95A:        AA            TAX                       
CODE_01C95B:        A9 03         LDA.B #$03                
CODE_01C95D:        9D 60 04      STA.W OAM_TileSize,X      
CODE_01C960:        A2 00         LDX.B #$00                
CODE_01C962:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_01C965:        38            SEC                       
CODE_01C966:        E5 06         SBC $06                   
CODE_01C968:        10 01         BPL CODE_01C96B           
CODE_01C96A:        CA            DEX                       
CODE_01C96B:        18            CLC                       
CODE_01C96C:        65 00         ADC $00                   
CODE_01C96E:        85 09         STA $09                   
CODE_01C970:        8A            TXA                       
CODE_01C971:        65 01         ADC $01                   
CODE_01C973:        85 0A         STA $0A                   
CODE_01C975:        20 BF C9      JSR.W CODE_01C9BF         
CODE_01C978:        90 05         BCC CODE_01C97F           
CODE_01C97A:        A9 F0         LDA.B #$F0                
CODE_01C97C:        99 01 03      STA.W OAM_DispY,Y         
CODE_01C97F:        A5 08         LDA $08                   
CODE_01C981:        C9 09         CMP.B #$09                
CODE_01C983:        D0 14         BNE CODE_01C999           
CODE_01C985:        A5 04         LDA $04                   
CODE_01C987:        8D B8 14      STA.W $14B8               
CODE_01C98A:        A5 05         LDA $05                   
CODE_01C98C:        8D B9 14      STA.W $14B9               
CODE_01C98F:        A5 09         LDA $09                   
CODE_01C991:        8D BA 14      STA.W $14BA               
CODE_01C994:        A5 0A         LDA $0A                   
CODE_01C996:        8D BB 14      STA.W $14BB               
CODE_01C999:        C8            INY                       
CODE_01C99A:        C8            INY                       
CODE_01C99B:        C8            INY                       
CODE_01C99C:        C8            INY                       
CODE_01C99D:        C6 08         DEC $08                   
CODE_01C99F:        10 93         BPL CODE_01C934           
CODE_01C9A1:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01C9A4:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01C9A7:        A9 F0         LDA.B #$F0                
CODE_01C9A9:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_01C9AC:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01C9AE:        D0 06         BNE Return01C9B6          ; / 
CODE_01C9B0:        20 F0 CC      JSR.W CODE_01CCF0         
CODE_01C9B3:        4C EC C9      JMP.W CODE_01C9EC         

Return01C9B6:       60            RTS                       ; Return 


DATA_01C9B7:                      .db $E0,$F0,$00,$10

BrwnChainPlatTiles:               .db $60,$61,$61,$62

CODE_01C9BF:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01C9C1:        A5 09         LDA $09                   
CODE_01C9C3:        48            PHA                       
CODE_01C9C4:        18            CLC                       
CODE_01C9C5:        69 10 00      ADC.W #$0010              
CODE_01C9C8:        85 09         STA $09                   
CODE_01C9CA:        38            SEC                       
CODE_01C9CB:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01C9CD:        C9 00 01      CMP.W #$0100              
CODE_01C9D0:        68            PLA                       
CODE_01C9D1:        85 09         STA $09                   
CODE_01C9D3:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return01C9D5:       60            RTS                       ; Return 


DATA_01C9D6:                      .db $01,$FF

DATA_01C9D8:                      .db $40,$C0

CODE_01C9DA:        BD 0E 16      LDA.W $160E,X             
CODE_01C9DD:        F0 0C         BEQ Return01C9EB          
CODE_01C9DF:        9E 0E 16      STZ.W $160E,X             
CODE_01C9E2:        DA            PHX                       
CODE_01C9E3:        22 BD E2 00   JSL.L CODE_00E2BD         
CODE_01C9E7:        FA            PLX                       
CODE_01C9E8:        8E E9 15      STX.W $15E9               
Return01C9EB:       60            RTS                       ; Return 

CODE_01C9EC:        AD B9 14      LDA.W $14B9               
CODE_01C9EF:        EB            XBA                       
CODE_01C9F0:        AD B8 14      LDA.W $14B8               
CODE_01C9F3:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01C9F5:        38            SEC                       
CODE_01C9F6:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01C9F8:        18            CLC                       
CODE_01C9F9:        69 10 00      ADC.W #$0010              
CODE_01C9FC:        C9 20 01      CMP.W #$0120              
CODE_01C9FF:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01CA01:        2A            ROL                       
CODE_01CA02:        29 01         AND.B #$01                
CODE_01CA04:        05 9D         ORA RAM_SpritesLocked     
CODE_01CA06:        9D C4 15      STA.W $15C4,X             
CODE_01CA09:        D0 CA         BNE Return01C9D5          
CODE_01CA0B:        20 9C CA      JSR.W CODE_01CA9C         
CODE_01CA0E:        9E 02 16      STZ.W $1602,X             
CODE_01CA11:        90 C7         BCC CODE_01C9DA           
CODE_01CA13:        A9 01         LDA.B #$01                
CODE_01CA15:        9D 0E 16      STA.W $160E,X             
CODE_01CA18:        AD BA 14      LDA.W $14BA               
CODE_01CA1B:        38            SEC                       
CODE_01CA1C:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01CA1E:        85 03         STA $03                   
CODE_01CA20:        38            SEC                       
CODE_01CA21:        E9 08         SBC.B #$08                
CODE_01CA23:        85 0E         STA $0E                   
CODE_01CA25:        A5 80         LDA $80                   
CODE_01CA27:        18            CLC                       
CODE_01CA28:        69 18         ADC.B #$18                
CODE_01CA2A:        C5 0E         CMP $0E                   
CODE_01CA2C:        B0 6D         BCS Return01CA9B          
CODE_01CA2E:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01CA30:        30 B0         BMI CODE_01C9E2           
CODE_01CA32:        64 7D         STZ RAM_MarioSpeedY       
CODE_01CA34:        A9 03         LDA.B #$03                
CODE_01CA36:        8D 71 14      STA.W $1471               
CODE_01CA39:        9D 02 16      STA.W $1602,X             
CODE_01CA3C:        A9 28         LDA.B #$28                
CODE_01CA3E:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_01CA41:        F0 02         BEQ CODE_01CA45           
CODE_01CA43:        A9 38         LDA.B #$38                
CODE_01CA45:        85 0F         STA $0F                   
CODE_01CA47:        AD BA 14      LDA.W $14BA               
CODE_01CA4A:        38            SEC                       
CODE_01CA4B:        E5 0F         SBC $0F                   
CODE_01CA4D:        85 96         STA RAM_MarioYPos         
CODE_01CA4F:        AD BB 14      LDA.W $14BB               
CODE_01CA52:        E9 00         SBC.B #$00                
CODE_01CA54:        85 97         STA RAM_MarioYPosHi       
CODE_01CA56:        A5 77         LDA RAM_MarioObjStatus    
CODE_01CA58:        29 03         AND.B #$03                
CODE_01CA5A:        D0 12         BNE CODE_01CA6E           
CODE_01CA5C:        A0 00         LDY.B #$00                
CODE_01CA5E:        AD 91 14      LDA.W $1491               
CODE_01CA61:        10 01         BPL CODE_01CA64           
CODE_01CA63:        88            DEY                       
CODE_01CA64:        18            CLC                       
CODE_01CA65:        65 94         ADC RAM_MarioXPos         
CODE_01CA67:        85 94         STA RAM_MarioXPos         
CODE_01CA69:        98            TYA                       
CODE_01CA6A:        65 95         ADC RAM_MarioXPosHi       
CODE_01CA6C:        85 95         STA RAM_MarioXPosHi       
CODE_01CA6E:        20 E2 C9      JSR.W CODE_01C9E2         
CODE_01CA71:        A5 16         LDA $16                   
CODE_01CA73:        30 04         BMI CODE_01CA79           
CODE_01CA75:        A9 FF         LDA.B #$FF                
CODE_01CA77:        85 78         STA $78                   
CODE_01CA79:        A5 13         LDA RAM_FrameCounter      
CODE_01CA7B:        4A            LSR                       
CODE_01CA7C:        90 1D         BCC Return01CA9B          
CODE_01CA7E:        BD 1C 15      LDA.W $151C,X             
CODE_01CA81:        18            CLC                       
CODE_01CA82:        69 80         ADC.B #$80                
CODE_01CA84:        BD 28 15      LDA.W $1528,X             
CODE_01CA87:        69 00         ADC.B #$00                
CODE_01CA89:        29 01         AND.B #$01                
CODE_01CA8B:        A8            TAY                       
CODE_01CA8C:        BD 04 15      LDA.W $1504,X             
CODE_01CA8F:        D9 D8 C9      CMP.W DATA_01C9D8,Y       
CODE_01CA92:        F0 07         BEQ Return01CA9B          
CODE_01CA94:        18            CLC                       
CODE_01CA95:        79 D6 C9      ADC.W DATA_01C9D6,Y       
CODE_01CA98:        9D 04 15      STA.W $1504,X             
Return01CA9B:       60            RTS                       ; Return 

CODE_01CA9C:        AD B8 14      LDA.W $14B8               
CODE_01CA9F:        38            SEC                       
CODE_01CAA0:        E9 18         SBC.B #$18                
CODE_01CAA2:        85 04         STA $04                   
CODE_01CAA4:        AD B9 14      LDA.W $14B9               
CODE_01CAA7:        E9 00         SBC.B #$00                
CODE_01CAA9:        85 0A         STA $0A                   
CODE_01CAAB:        A9 40         LDA.B #$40                
CODE_01CAAD:        85 06         STA $06                   
CODE_01CAAF:        AD BA 14      LDA.W $14BA               
CODE_01CAB2:        38            SEC                       
CODE_01CAB3:        E9 0C         SBC.B #$0C                
CODE_01CAB5:        85 05         STA $05                   
CODE_01CAB7:        AD BB 14      LDA.W $14BB               
CODE_01CABA:        E9 00         SBC.B #$00                
CODE_01CABC:        85 0B         STA $0B                   
CODE_01CABE:        A9 13         LDA.B #$13                
CODE_01CAC0:        85 07         STA $07                   
CODE_01CAC2:        22 64 B6 03   JSL.L GetMarioClipping    
CODE_01CAC6:        22 2B B7 03   JSL.L CheckForContact     
Return01CACA:       60            RTS                       ; Return 

CODE_01CACB:        A9 50         LDA.B #$50                
CODE_01CACD:        8D BC 14      STA.W $14BC               
CODE_01CAD0:        9C BF 14      STZ.W $14BF               
CODE_01CAD3:        9C BD 14      STZ.W $14BD               
CODE_01CAD6:        9C C0 14      STZ.W $14C0               
CODE_01CAD9:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01CADB:        8D B4 14      STA.W $14B4               
CODE_01CADE:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01CAE1:        8D B5 14      STA.W $14B5               
CODE_01CAE4:        AD B4 14      LDA.W $14B4               
CODE_01CAE7:        38            SEC                       
CODE_01CAE8:        ED BC 14      SBC.W $14BC               
CODE_01CAEB:        8D B0 14      STA.W $14B0               
CODE_01CAEE:        AD B5 14      LDA.W $14B5               
CODE_01CAF1:        ED BD 14      SBC.W $14BD               
CODE_01CAF4:        8D B1 14      STA.W $14B1               
CODE_01CAF7:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01CAF9:        8D B6 14      STA.W $14B6               
CODE_01CAFC:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01CAFF:        8D B7 14      STA.W $14B7               
CODE_01CB02:        AD B6 14      LDA.W $14B6               
CODE_01CB05:        38            SEC                       
CODE_01CB06:        ED BF 14      SBC.W $14BF               
CODE_01CB09:        8D B2 14      STA.W $14B2               
CODE_01CB0C:        AD B7 14      LDA.W $14B7               
CODE_01CB0F:        ED C0 14      SBC.W $14C0               
CODE_01CB12:        8D B3 14      STA.W $14B3               
CODE_01CB15:        BD 1C 15      LDA.W $151C,X             
CODE_01CB18:        85 36         STA $36                   
CODE_01CB1A:        BD 28 15      LDA.W $1528,X             
CODE_01CB1D:        85 37         STA $37                   
Return01CB1F:       60            RTS                       ; Return 

CODE_01CB20:        A5 37         LDA $37                   
CODE_01CB22:        8D 66 18      STA.W $1866               
CODE_01CB25:        DA            PHX                       
CODE_01CB26:        C2 30         REP #$30                  ; Index (16 bit) Accum (16 bit) 
CODE_01CB28:        A5 36         LDA $36                   
CODE_01CB2A:        0A            ASL                       
CODE_01CB2B:        29 FF 01      AND.W #$01FF              
CODE_01CB2E:        AA            TAX                       
CODE_01CB2F:        BF DB F7 07   LDA.L CircleCoords,X      
CODE_01CB33:        8D C2 14      STA.W $14C2               
CODE_01CB36:        A5 36         LDA $36                   
CODE_01CB38:        18            CLC                       
CODE_01CB39:        69 80 00      ADC.W #$0080              
CODE_01CB3C:        85 00         STA $00                   
CODE_01CB3E:        0A            ASL                       
CODE_01CB3F:        29 FF 01      AND.W #$01FF              
CODE_01CB42:        AA            TAX                       
CODE_01CB43:        BF DB F7 07   LDA.L CircleCoords,X      
CODE_01CB47:        8D C5 14      STA.W $14C5               
CODE_01CB4A:        E2 30         SEP #$30                  ; Index (8 bit) Accum (8 bit) 
CODE_01CB4C:        A5 01         LDA $01                   
CODE_01CB4E:        8D 67 18      STA.W $1867               
CODE_01CB51:        FA            PLX                       
Return01CB52:       60            RTS                       ; Return 

CODE_01CB53:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01CB55:        AD C5 14      LDA.W $14C5               
CODE_01CB58:        85 02         STA $02                   
CODE_01CB5A:        AD BC 14      LDA.W $14BC               
CODE_01CB5D:        85 00         STA $00                   
CODE_01CB5F:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01CB61:        20 28 CC      JSR.W CODE_01CC28         
CODE_01CB64:        AD 67 18      LDA.W $1867               
CODE_01CB67:        4A            LSR                       
CODE_01CB68:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01CB6A:        A5 04         LDA $04                   
CODE_01CB6C:        90 04         BCC CODE_01CB72           
CODE_01CB6E:        49 FF FF      EOR.W #$FFFF              
CODE_01CB71:        1A            INC A                     
CODE_01CB72:        85 08         STA $08                   
CODE_01CB74:        A5 06         LDA $06                   
CODE_01CB76:        90 04         BCC CODE_01CB7C           
CODE_01CB78:        49 FF FF      EOR.W #$FFFF              
CODE_01CB7B:        1A            INC A                     
CODE_01CB7C:        85 0A         STA $0A                   
CODE_01CB7E:        AD C2 14      LDA.W $14C2               
CODE_01CB81:        85 02         STA $02                   
CODE_01CB83:        AD BF 14      LDA.W $14BF               
CODE_01CB86:        85 00         STA $00                   
CODE_01CB88:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01CB8A:        20 28 CC      JSR.W CODE_01CC28         
CODE_01CB8D:        AD 66 18      LDA.W $1866               
CODE_01CB90:        4A            LSR                       
CODE_01CB91:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01CB93:        A5 04         LDA $04                   
CODE_01CB95:        90 04         BCC CODE_01CB9B           
CODE_01CB97:        49 FF FF      EOR.W #$FFFF              
CODE_01CB9A:        1A            INC A                     
CODE_01CB9B:        85 04         STA $04                   
CODE_01CB9D:        A5 06         LDA $06                   
CODE_01CB9F:        90 04         BCC CODE_01CBA5           
CODE_01CBA1:        49 FF FF      EOR.W #$FFFF              
CODE_01CBA4:        1A            INC A                     
CODE_01CBA5:        85 06         STA $06                   
CODE_01CBA7:        A5 04         LDA $04                   
CODE_01CBA9:        18            CLC                       
CODE_01CBAA:        65 08         ADC $08                   
CODE_01CBAC:        85 04         STA $04                   
CODE_01CBAE:        A5 06         LDA $06                   
CODE_01CBB0:        65 0A         ADC $0A                   
CODE_01CBB2:        85 06         STA $06                   
CODE_01CBB4:        A5 05         LDA $05                   
CODE_01CBB6:        18            CLC                       
CODE_01CBB7:        6D B0 14      ADC.W $14B0               
CODE_01CBBA:        8D B8 14      STA.W $14B8               
CODE_01CBBD:        AD C5 14      LDA.W $14C5               
CODE_01CBC0:        85 02         STA $02                   
CODE_01CBC2:        AD BF 14      LDA.W $14BF               
CODE_01CBC5:        85 00         STA $00                   
CODE_01CBC7:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01CBC9:        20 28 CC      JSR.W CODE_01CC28         
CODE_01CBCC:        AD 67 18      LDA.W $1867               
CODE_01CBCF:        4A            LSR                       
CODE_01CBD0:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01CBD2:        A5 04         LDA $04                   
CODE_01CBD4:        90 04         BCC CODE_01CBDA           
CODE_01CBD6:        49 FF FF      EOR.W #$FFFF              
CODE_01CBD9:        1A            INC A                     
CODE_01CBDA:        85 08         STA $08                   
CODE_01CBDC:        A5 06         LDA $06                   
CODE_01CBDE:        90 04         BCC CODE_01CBE4           
CODE_01CBE0:        49 FF FF      EOR.W #$FFFF              
CODE_01CBE3:        1A            INC A                     
CODE_01CBE4:        85 0A         STA $0A                   
CODE_01CBE6:        AD C2 14      LDA.W $14C2               
CODE_01CBE9:        85 02         STA $02                   
CODE_01CBEB:        AD BC 14      LDA.W $14BC               
CODE_01CBEE:        85 00         STA $00                   
CODE_01CBF0:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01CBF2:        20 28 CC      JSR.W CODE_01CC28         
CODE_01CBF5:        AD 66 18      LDA.W $1866               
CODE_01CBF8:        4A            LSR                       
CODE_01CBF9:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01CBFB:        A5 04         LDA $04                   
CODE_01CBFD:        90 04         BCC CODE_01CC03           
CODE_01CBFF:        49 FF FF      EOR.W #$FFFF              
CODE_01CC02:        1A            INC A                     
CODE_01CC03:        85 04         STA $04                   
CODE_01CC05:        A5 06         LDA $06                   
CODE_01CC07:        90 04         BCC CODE_01CC0D           
CODE_01CC09:        49 FF FF      EOR.W #$FFFF              
CODE_01CC0C:        1A            INC A                     
CODE_01CC0D:        85 06         STA $06                   
CODE_01CC0F:        A5 04         LDA $04                   
CODE_01CC11:        38            SEC                       
CODE_01CC12:        E5 08         SBC $08                   
CODE_01CC14:        85 04         STA $04                   
CODE_01CC16:        A5 06         LDA $06                   
CODE_01CC18:        E5 0A         SBC $0A                   
CODE_01CC1A:        85 06         STA $06                   
CODE_01CC1C:        AD B2 14      LDA.W $14B2               
CODE_01CC1F:        38            SEC                       
CODE_01CC20:        E5 05         SBC $05                   
CODE_01CC22:        8D BA 14      STA.W $14BA               
CODE_01CC25:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return01CC27:       60            RTS                       ; Return 

CODE_01CC28:        A5 00         LDA $00                   
CODE_01CC2A:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_01CC2D:        A5 02         LDA $02                   
CODE_01CC2F:        8D 03 42      STA.W $4203               ; Multplier B
CODE_01CC32:        20 94 CC      JSR.W DoNothing           
CODE_01CC35:        AD 16 42      LDA.W $4216               ; Product/Remainder Result (Low Byte)
CODE_01CC38:        85 04         STA $04                   
CODE_01CC3A:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_01CC3D:        85 05         STA $05                   
CODE_01CC3F:        A5 00         LDA $00                   
CODE_01CC41:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_01CC44:        A5 03         LDA $03                   
CODE_01CC46:        8D 03 42      STA.W $4203               ; Multplier B
CODE_01CC49:        20 94 CC      JSR.W DoNothing           
CODE_01CC4C:        AD 16 42      LDA.W $4216               ; Product/Remainder Result (Low Byte)
CODE_01CC4F:        18            CLC                       
CODE_01CC50:        65 05         ADC $05                   
CODE_01CC52:        85 05         STA $05                   
CODE_01CC54:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_01CC57:        69 00         ADC.B #$00                
CODE_01CC59:        85 06         STA $06                   
CODE_01CC5B:        A5 01         LDA $01                   
CODE_01CC5D:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_01CC60:        A5 02         LDA $02                   
CODE_01CC62:        8D 03 42      STA.W $4203               ; Multplier B
CODE_01CC65:        20 94 CC      JSR.W DoNothing           
CODE_01CC68:        AD 16 42      LDA.W $4216               ; Product/Remainder Result (Low Byte)
CODE_01CC6B:        18            CLC                       
CODE_01CC6C:        65 05         ADC $05                   
CODE_01CC6E:        85 05         STA $05                   
CODE_01CC70:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_01CC73:        65 06         ADC $06                   
CODE_01CC75:        85 06         STA $06                   
CODE_01CC77:        A5 01         LDA $01                   
CODE_01CC79:        8D 02 42      STA.W $4202               ; Multiplicand A
CODE_01CC7C:        A5 03         LDA $03                   
CODE_01CC7E:        8D 03 42      STA.W $4203               ; Multplier B
CODE_01CC81:        20 94 CC      JSR.W DoNothing           
CODE_01CC84:        AD 16 42      LDA.W $4216               ; Product/Remainder Result (Low Byte)
CODE_01CC87:        18            CLC                       
CODE_01CC88:        65 06         ADC $06                   
CODE_01CC8A:        85 06         STA $06                   
CODE_01CC8C:        AD 17 42      LDA.W $4217               ; Product/Remainder Result (High Byte)
CODE_01CC8F:        69 00         ADC.B #$00                
CODE_01CC91:        85 07         STA $07                   
Return01CC93:       60            RTS                       ; Return 

DoNothing:          EA            NOP                       ; \ Do nothing at all 
CODE_01CC95:        EA            NOP                       ;  | 
CODE_01CC96:        EA            NOP                       ;  | 
CODE_01CC97:        EA            NOP                       ;  | 
CODE_01CC98:        EA            NOP                       ;  | 
CODE_01CC99:        EA            NOP                       ;  | 
CODE_01CC9A:        EA            NOP                       ;  | 
CODE_01CC9B:        EA            NOP                       ;  | 
Return01CC9C:       60            RTS                       ; / 

CODE_01CC9D:        AD B5 14      LDA.W $14B5               
CODE_01CCA0:        0D B7 14      ORA.W $14B7               
CODE_01CCA3:        D0 20         BNE CODE_01CCC5           
CODE_01CCA5:        20 C7 CC      JSR.W CODE_01CCC7         
CODE_01CCA8:        20 20 CB      JSR.W CODE_01CB20         
CODE_01CCAB:        20 53 CB      JSR.W CODE_01CB53         
CODE_01CCAE:        AD BA 14      LDA.W $14BA               
CODE_01CCB1:        29 F0         AND.B #$F0                
CODE_01CCB3:        85 00         STA $00                   
CODE_01CCB5:        AD B8 14      LDA.W $14B8               
CODE_01CCB8:        4A            LSR                       
CODE_01CCB9:        4A            LSR                       
CODE_01CCBA:        4A            LSR                       
CODE_01CCBB:        4A            LSR                       
CODE_01CCBC:        05 00         ORA $00                   
CODE_01CCBE:        A8            TAY                       
CODE_01CCBF:        B9 F6 0A      LDA.W $0AF6,Y             
CODE_01CCC2:        C9 15         CMP.B #$15                
Return01CCC4:       6B            RTL                       ; Return 

CODE_01CCC5:        18            CLC                       
Return01CCC6:       6B            RTL                       ; Return 

CODE_01CCC7:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01CCC9:        A5 2A         LDA $2A                   
CODE_01CCCB:        8D B0 14      STA.W $14B0               
CODE_01CCCE:        A5 2C         LDA $2C                   
CODE_01CCD0:        8D B2 14      STA.W $14B2               
CODE_01CCD3:        AD B4 14      LDA.W $14B4               
CODE_01CCD6:        38            SEC                       
CODE_01CCD7:        ED B0 14      SBC.W $14B0               
CODE_01CCDA:        8D BC 14      STA.W $14BC               
CODE_01CCDD:        AD B6 14      LDA.W $14B6               
CODE_01CCE0:        38            SEC                       
CODE_01CCE1:        ED B2 14      SBC.W $14B2               
CODE_01CCE4:        8D BF 14      STA.W $14BF               
CODE_01CCE7:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return01CCE9:       60            RTS                       ; Return 

Return01CCEA:       60            RTS                       

Return01CCEB:       60            RTS                       

CODE_01CCEC:        49 FF         EOR.B #$FF                
CODE_01CCEE:        1A            INC A                     
Return01CCEF:       60            RTS                       ; Return 

CODE_01CCF0:        BD 04 15      LDA.W $1504,X             
CODE_01CCF3:        0A            ASL                       
CODE_01CCF4:        0A            ASL                       
CODE_01CCF5:        0A            ASL                       
CODE_01CCF6:        0A            ASL                       
CODE_01CCF7:        18            CLC                       
CODE_01CCF8:        7D 10 15      ADC.W $1510,X             
CODE_01CCFB:        9D 10 15      STA.W $1510,X             
CODE_01CCFE:        08            PHP                       
CODE_01CCFF:        A0 00         LDY.B #$00                
CODE_01CD01:        BD 04 15      LDA.W $1504,X             
CODE_01CD04:        4A            LSR                       
CODE_01CD05:        4A            LSR                       
CODE_01CD06:        4A            LSR                       
CODE_01CD07:        4A            LSR                       
CODE_01CD08:        C9 08         CMP.B #$08                
CODE_01CD0A:        90 03         BCC CODE_01CD0F           
CODE_01CD0C:        09 F0         ORA.B #$F0                
CODE_01CD0E:        88            DEY                       
CODE_01CD0F:        28            PLP                       
CODE_01CD10:        7D 1C 15      ADC.W $151C,X             
CODE_01CD13:        9D 1C 15      STA.W $151C,X             
CODE_01CD16:        98            TYA                       
CODE_01CD17:        7D 28 15      ADC.W $1528,X             
CODE_01CD1A:        9D 28 15      STA.W $1528,X             
Return01CD1D:       60            RTS                       ; Return 


DATA_01CD1E:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF

PipeKoopaKids:      22 09 CC 03   JSL.L CODE_03CC09         
Return01CD2E:       60            RTS                       ; Return 

InitKoopaKid:       B5 D8         LDA RAM_SpriteYLo,X       
CODE_01CD31:        4A            LSR                       
CODE_01CD32:        4A            LSR                       
CODE_01CD33:        4A            LSR                       
CODE_01CD34:        4A            LSR                       
CODE_01CD35:        95 C2         STA RAM_SpriteState,X     
CODE_01CD37:        C9 05         CMP.B #$05                
CODE_01CD39:        90 13         BCC CODE_01CD4E           
CODE_01CD3B:        A9 78         LDA.B #$78                
CODE_01CD3D:        95 E4         STA RAM_SpriteXLo,X       
CODE_01CD3F:        A9 40         LDA.B #$40                
CODE_01CD41:        95 D8         STA RAM_SpriteYLo,X       
CODE_01CD43:        A9 01         LDA.B #$01                
CODE_01CD45:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01CD48:        A9 80         LDA.B #$80                
CODE_01CD4A:        9D 40 15      STA.W $1540,X             
Return01CD4D:       60            RTS                       ; Return 

CODE_01CD4E:        A0 90         LDY.B #$90                
CODE_01CD50:        94 D8         STY RAM_SpriteYLo,X       
CODE_01CD52:        C9 03         CMP.B #$03                
CODE_01CD54:        90 08         BCC CODE_01CD5E           
CODE_01CD56:        22 F5 FC 00   JSL.L CODE_00FCF5         
CODE_01CD5A:        20 7C 85      JSR.W FaceMario           
Return01CD5D:       60            RTS                       ; Return 

CODE_01CD5E:        A9 01         LDA.B #$01                
CODE_01CD60:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01CD63:        A9 20         LDA.B #$20                
CODE_01CD65:        85 38         STA $38                   
CODE_01CD67:        85 39         STA $39                   
CODE_01CD69:        22 7D DD 03   JSL.L CODE_03DD7D         
CODE_01CD6D:        B4 C2         LDY RAM_SpriteState,X     
CODE_01CD6F:        B9 92 CD      LDA.W DATA_01CD92,Y       
CODE_01CD72:        9D 7B 18      STA.W $187B,X             
CODE_01CD75:        C9 01         CMP.B #$01                
CODE_01CD77:        F0 0E         BEQ CODE_01CD87           
CODE_01CD79:        C9 00         CMP.B #$00                
CODE_01CD7B:        D0 04         BNE CODE_01CD81           
CODE_01CD7D:        A9 70         LDA.B #$70                
CODE_01CD7F:        95 E4         STA RAM_SpriteXLo,X       
CODE_01CD81:        A9 01         LDA.B #$01                
CODE_01CD83:        9D E0 14      STA.W RAM_SpriteXHi,X     
Return01CD86:       60            RTS                       ; Return 

CODE_01CD87:        A9 26         LDA.B #$26                
CODE_01CD89:        9D 34 15      STA.W $1534,X             
CODE_01CD8C:        A9 D8         LDA.B #$D8                
CODE_01CD8E:        9D 0E 16      STA.W $160E,X             
Return01CD91:       60            RTS                       ; Return 


DATA_01CD92:                      .db $01,$01,$00,$02,$02,$03,$03

DATA_01CD99:                      .db $00,$09,$12

DATA_01CD9C:                      .db $00,$01,$02,$03,$04,$05,$06,$07
                                  .db $08

DATA_01CDA5:                      .db $00,$80

CODE_01CDA7:        20 65 A3      JSR.W GetDrawInfoBnk1     
Return01CDAA:       60            RTS                       ; Return 

WallKoopaKids:      9C FB 13      STZ.W $13FB               
CODE_01CDAE:        BD 02 16      LDA.W $1602,X             
CODE_01CDB1:        C9 1B         CMP.B #$1B                
CODE_01CDB3:        B0 20         BCS CODE_01CDD5           
CODE_01CDB5:        BD AC 15      LDA.W $15AC,X             
CODE_01CDB8:        C9 08         CMP.B #$08                
CODE_01CDBA:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01CDBD:        B9 A5 CD      LDA.W DATA_01CDA5,Y       
CODE_01CDC0:        B0 02         BCS CODE_01CDC4           
CODE_01CDC2:        49 80         EOR.B #$80                
CODE_01CDC4:        85 00         STA $00                   
CODE_01CDC6:        B4 C2         LDY RAM_SpriteState,X     
CODE_01CDC8:        B9 99 CD      LDA.W DATA_01CD99,Y       
CODE_01CDCB:        BC 02 16      LDY.W $1602,X             
CODE_01CDCE:        18            CLC                       
CODE_01CDCF:        79 9C CD      ADC.W DATA_01CD9C,Y       
CODE_01CDD2:        18            CLC                       
CODE_01CDD3:        65 00         ADC $00                   
CODE_01CDD5:        8D A2 1B      STA.W $1BA2               
CODE_01CDD8:        22 DF DE 03   JSL.L CODE_03DEDF         
CODE_01CDDC:        20 A7 CD      JSR.W CODE_01CDA7         
CODE_01CDDF:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01CDE1:        D0 5A         BNE Return01CE3D          ; / 
CODE_01CDE3:        20 A8 D2      JSR.W CODE_01D2A8         
CODE_01CDE6:        20 B1 D3      JSR.W CODE_01D3B1         
CODE_01CDE9:        BD 7B 18      LDA.W $187B,X             
CODE_01CDEC:        C9 01         CMP.B #$01                
CODE_01CDEE:        F0 1B         BEQ CODE_01CE0B           
CODE_01CDF0:        BD 3E 16      LDA.W $163E,X             
CODE_01CDF3:        D0 16         BNE CODE_01CE0B           
CODE_01CDF5:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01CDF8:        48            PHA                       
CODE_01CDF9:        20 30 AD      JSR.W SubHorizPos         
CODE_01CDFC:        98            TYA                       
CODE_01CDFD:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01CE00:        68            PLA                       
CODE_01CE01:        DD 7C 15      CMP.W RAM_SpriteDir,X     
CODE_01CE04:        F0 05         BEQ CODE_01CE0B           
CODE_01CE06:        A9 10         LDA.B #$10                ; \ Set turning timer 
CODE_01CE08:        9D AC 15      STA.W $15AC,X             ; / 
CODE_01CE0B:        BD 1C 15      LDA.W $151C,X             
CODE_01CE0E:        22 DF 86 00   JSL.L ExecutePtr          

MortonPtrs1:           1E CE      .dw CODE_01CE1E           
                       3E CE      .dw CODE_01CE3E           
                       5F CE      .dw CODE_01CE5F           
                       7D CF      .dw CODE_01CF7D           
                       E0 CF      .dw CODE_01CFE0           
                       43 D0      .dw CODE_01D043           

CODE_01CE1E:        BD 7B 18      LDA.W $187B,X             
CODE_01CE21:        C9 01         CMP.B #$01                
CODE_01CE23:        D0 0F         BNE CODE_01CE34           
CODE_01CE25:        9C 11 14      STZ.W $1411               
CODE_01CE28:        EE A8 18      INC.W $18A8               
CODE_01CE2B:        9C AA 18      STZ.W $18AA               
CODE_01CE2E:        E6 9D         INC RAM_SpritesLocked     
CODE_01CE30:        FE 1C 15      INC.W $151C,X             
Return01CE33:       60            RTS                       ; Return 

CODE_01CE34:        A5 1A         LDA RAM_ScreenBndryXLo    
CODE_01CE36:        C9 7E         CMP.B #$7E                
CODE_01CE38:        90 03         BCC Return01CE3D          
CODE_01CE3A:        FE 1C 15      INC.W $151C,X             
Return01CE3D:       60            RTS                       ; Return 

CODE_01CE3E:        64 7B         STZ RAM_MarioSpeedX       
CODE_01CE40:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01CE43:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01CE45:        C9 40         CMP.B #$40                
CODE_01CE47:        10 03         BPL CODE_01CE4C           
CODE_01CE49:        18            CLC                       
CODE_01CE4A:        69 03         ADC.B #$03                
CODE_01CE4C:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01CE4E:        20 C0 D0      JSR.W CODE_01D0C0         
CODE_01CE51:        90 EA         BCC Return01CE3D          
CODE_01CE53:        FE 1C 15      INC.W $151C,X             
CODE_01CE56:        B5 C2         LDA RAM_SpriteState,X     
CODE_01CE58:        C9 02         CMP.B #$02                
CODE_01CE5A:        90 E1         BCC Return01CE3D          
CODE_01CE5C:        4C A8 CE      JMP.W CODE_01CEA8         

CODE_01CE5F:        B5 C2         LDA RAM_SpriteState,X     
CODE_01CE61:        22 DF 86 00   JSL.L ExecutePtr          

MortonPtrs2:           16 D1      .dw CODE_01D116           
                       16 D1      .dw CODE_01D116           
                       6B CE      .dw CODE_01CE6B           

CODE_01CE6B:        BD 28 15      LDA.W $1528,X             
CODE_01CE6E:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs01CE72:            78 CE      .dw CODE_01CE78           
                       B6 CE      .dw CODE_01CEB6           
                       FD CE      .dw CODE_01CEFD           

CODE_01CE78:        64 36         STZ $36                   
CODE_01CE7A:        64 37         STZ $37                   
CODE_01CE7C:        BD 40 15      LDA.W $1540,X             
CODE_01CE7F:        F0 24         BEQ CODE_01CEA5           
CODE_01CE81:        A0 03         LDY.B #$03                
CODE_01CE83:        29 30         AND.B #$30                
CODE_01CE85:        D0 01         BNE CODE_01CE88           
CODE_01CE87:        C8            INY                       
CODE_01CE88:        98            TYA                       
CODE_01CE89:        BC AC 15      LDY.W $15AC,X             
CODE_01CE8C:        F0 02         BEQ CODE_01CE90           
ADDR_01CE8E:        A9 05         LDA.B #$05                
CODE_01CE90:        9D 02 16      STA.W $1602,X             
CODE_01CE93:        BD 40 15      LDA.W $1540,X             
CODE_01CE96:        29 3F         AND.B #$3F                
CODE_01CE98:        C9 2E         CMP.B #$2E                
CODE_01CE9A:        D0 08         BNE Return01CEA4          
CODE_01CE9C:        A9 30         LDA.B #$30                
CODE_01CE9E:        9D 3E 16      STA.W $163E,X             
CODE_01CEA1:        20 59 D0      JSR.W CODE_01D059         
Return01CEA4:       60            RTS                       ; Return 

CODE_01CEA5:        FE 28 15      INC.W $1528,X             
CODE_01CEA8:        A9 FF         LDA.B #$FF                
CODE_01CEAA:        9D 40 15      STA.W $1540,X             
Return01CEAD:       60            RTS                       ; Return 


DATA_01CEAE:                      .db $30,$D0

DATA_01CEB0:                      .db $1B,$1C,$1D,$1B

DATA_01CEB4:                      .db $14,$EC

CODE_01CEB6:        BD 40 15      LDA.W $1540,X             
CODE_01CEB9:        D0 21         BNE CODE_01CEDC           
CODE_01CEBB:        20 30 AD      JSR.W SubHorizPos         
CODE_01CEBE:        98            TYA                       
CODE_01CEBF:        DD E0 14      CMP.W RAM_SpriteXHi,X     
CODE_01CEC2:        D0 18         BNE CODE_01CEDC           
CODE_01CEC4:        FE 28 15      INC.W $1528,X             
CODE_01CEC7:        B9 B4 CE      LDA.W DATA_01CEB4,Y       
CODE_01CECA:        9D 0E 16      STA.W $160E,X             
CODE_01CECD:        A9 30         LDA.B #$30                
CODE_01CECF:        9D 40 15      STA.W $1540,X             
CODE_01CED2:        A9 60         LDA.B #$60                
CODE_01CED4:        9D 58 15      STA.W $1558,X             
CODE_01CED7:        A9 D8         LDA.B #$D8                
CODE_01CED9:        95 AA         STA RAM_SpriteSpeedY,X    
Return01CEDB:       60            RTS                       ; Return 

CODE_01CEDC:        20 30 AD      JSR.W SubHorizPos         
CODE_01CEDF:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01CEE1:        D9 AE CE      CMP.W DATA_01CEAE,Y       
CODE_01CEE4:        F0 06         BEQ CODE_01CEEC           
CODE_01CEE6:        18            CLC                       
CODE_01CEE7:        79 E7 D4      ADC.W DATA_01D4E7,Y       
CODE_01CEEA:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01CEEC:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01CEEF:        A5 14         LDA RAM_FrameCounterB     
CODE_01CEF1:        4A            LSR                       
CODE_01CEF2:        4A            LSR                       
CODE_01CEF3:        29 03         AND.B #$03                
CODE_01CEF5:        A8            TAY                       
CODE_01CEF6:        B9 B0 CE      LDA.W DATA_01CEB0,Y       
CODE_01CEF9:        9D 02 16      STA.W $1602,X             
Return01CEFC:       60            RTS                       ; Return 

CODE_01CEFD:        BD 40 15      LDA.W $1540,X             
CODE_01CF00:        F0 1A         BEQ CODE_01CF1C           
CODE_01CF02:        3A            DEC A                     
CODE_01CF03:        D0 0A         BNE CODE_01CF0F           
CODE_01CF05:        BD 0E 16      LDA.W $160E,X             
CODE_01CF08:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01CF0A:        A9 08         LDA.B #$08                ; \ Play sound effect 
CODE_01CF0C:        8D FC 1D      STA.W $1DFC               ; / 
CODE_01CF0F:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01CF11:        F0 08         BEQ Return01CF1B          
CODE_01CF13:        10 04         BPL CODE_01CF19           
CODE_01CF15:        F6 B6         INC RAM_SpriteSpeedX,X    
CODE_01CF17:        F6 B6         INC RAM_SpriteSpeedX,X    
CODE_01CF19:        D6 B6         DEC RAM_SpriteSpeedX,X    
Return01CF1B:       60            RTS                       ; Return 

CODE_01CF1C:        20 C0 D0      JSR.W CODE_01D0C0         
CODE_01CF1F:        90 0E         BCC CODE_01CF2F           
CODE_01CF21:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01CF23:        30 0A         BMI CODE_01CF2F           
CODE_01CF25:        74 B6         STZ RAM_SpriteSpeedX,X    ; \ Sprite Speed = 0 
CODE_01CF27:        74 AA         STZ RAM_SpriteSpeedY,X    ; / 
CODE_01CF29:        9E 28 15      STZ.W $1528,X             
CODE_01CF2C:        4C A8 CE      JMP.W CODE_01CEA8         

CODE_01CF2F:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01CF32:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01CF35:        A5 13         LDA RAM_FrameCounter      
CODE_01CF37:        4A            LSR                       
CODE_01CF38:        B0 0A         BCS CODE_01CF44           
CODE_01CF3A:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01CF3C:        30 04         BMI CODE_01CF42           
CODE_01CF3E:        C9 70         CMP.B #$70                
CODE_01CF40:        B0 02         BCS CODE_01CF44           
CODE_01CF42:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_01CF44:        BD 58 15      LDA.W $1558,X             
CODE_01CF47:        D0 06         BNE CODE_01CF4F           
CODE_01CF49:        A5 36         LDA $36                   
CODE_01CF4B:        05 37         ORA $37                   
CODE_01CF4D:        F0 18         BEQ CODE_01CF67           
CODE_01CF4F:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01CF51:        0A            ASL                       
CODE_01CF52:        A9 04         LDA.B #$04                
CODE_01CF54:        A0 00         LDY.B #$00                
CODE_01CF56:        90 03         BCC CODE_01CF5B           
ADDR_01CF58:        A9 FC         LDA.B #$FC                
ADDR_01CF5A:        88            DEY                       
CODE_01CF5B:        18            CLC                       
CODE_01CF5C:        65 36         ADC $36                   
CODE_01CF5E:        85 36         STA $36                   
CODE_01CF60:        98            TYA                       
CODE_01CF61:        65 37         ADC $37                   
CODE_01CF63:        29 01         AND.B #$01                
CODE_01CF65:        85 37         STA $37                   
CODE_01CF67:        A9 06         LDA.B #$06                
CODE_01CF69:        B4 AA         LDY RAM_SpriteSpeedY,X    
CODE_01CF6B:        30 0C         BMI CODE_01CF79           
CODE_01CF6D:        C0 08         CPY.B #$08                
CODE_01CF6F:        90 08         BCC CODE_01CF79           
CODE_01CF71:        A9 05         LDA.B #$05                
CODE_01CF73:        C0 10         CPY.B #$10                
CODE_01CF75:        90 02         BCC CODE_01CF79           
CODE_01CF77:        A9 02         LDA.B #$02                
CODE_01CF79:        9D 02 16      STA.W $1602,X             
Return01CF7C:       60            RTS                       ; Return 

CODE_01CF7D:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01CF80:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_01CF82:        20 C0 D0      JSR.W CODE_01D0C0         
CODE_01CF85:        BD 40 15      LDA.W $1540,X             
CODE_01CF88:        F0 2D         BEQ CODE_01CFB7           
CODE_01CF8A:        C9 40         CMP.B #$40                
CODE_01CF8C:        90 10         BCC CODE_01CF9E           
CODE_01CF8E:        F0 36         BEQ CODE_01CFC6           
CODE_01CF90:        A0 06         LDY.B #$06                
CODE_01CF92:        A5 14         LDA RAM_FrameCounterB     
CODE_01CF94:        29 04         AND.B #$04                
CODE_01CF96:        F0 01         BEQ CODE_01CF99           
CODE_01CF98:        C8            INY                       
CODE_01CF99:        98            TYA                       
CODE_01CF9A:        9D 02 16      STA.W $1602,X             
Return01CF9D:       60            RTS                       ; Return 

CODE_01CF9E:        AC A6 18      LDY.W $18A6               
CODE_01CFA1:        A5 38         LDA $38                   
CODE_01CFA3:        C9 20         CMP.B #$20                
CODE_01CFA5:        F0 02         BEQ CODE_01CFA9           
CODE_01CFA7:        E6 38         INC $38                   
CODE_01CFA9:        A5 39         LDA $39                   
CODE_01CFAB:        C9 20         CMP.B #$20                
CODE_01CFAD:        F0 02         BEQ CODE_01CFB1           
CODE_01CFAF:        C6 39         DEC $39                   
CODE_01CFB1:        A9 07         LDA.B #$07                
CODE_01CFB3:        9D 02 16      STA.W $1602,X             
Return01CFB6:       60            RTS                       ; Return 

CODE_01CFB7:        A9 02         LDA.B #$02                
CODE_01CFB9:        9D 1C 15      STA.W $151C,X             
CODE_01CFBC:        B5 C2         LDA RAM_SpriteState,X     
CODE_01CFBE:        F0 05         BEQ Return01CFC5          
CODE_01CFC0:        A9 20         LDA.B #$20                
CODE_01CFC2:        9D 4A 16      STA.W $164A,X             
Return01CFC5:       60            RTS                       ; Return 

CODE_01CFC6:        FE 26 16      INC.W $1626,X             
CODE_01CFC9:        BD 26 16      LDA.W $1626,X             
CODE_01CFCC:        C9 03         CMP.B #$03                
CODE_01CFCE:        90 0F         BCC Return01CFDF          
CODE_01CFD0:        A9 1F         LDA.B #$1F                ; \ Play sound effect 
CODE_01CFD2:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01CFD5:        A9 04         LDA.B #$04                
CODE_01CFD7:        9D 1C 15      STA.W $151C,X             
CODE_01CFDA:        A9 13         LDA.B #$13                
CODE_01CFDC:        9D 40 15      STA.W $1540,X             
Return01CFDF:       60            RTS                       ; Return 

CODE_01CFE0:        BC 40 15      LDY.W $1540,X             
CODE_01CFE3:        F0 17         BEQ CODE_01CFFC           
CODE_01CFE5:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01CFE7:        38            SEC                       
CODE_01CFE8:        E9 01         SBC.B #$01                
CODE_01CFEA:        95 D8         STA RAM_SpriteYLo,X       
CODE_01CFEC:        B0 03         BCS CODE_01CFF1           
ADDR_01CFEE:        DE D4 14      DEC.W RAM_SpriteYHi,X     
CODE_01CFF1:        C6 39         DEC $39                   
CODE_01CFF3:        98            TYA                       
CODE_01CFF4:        29 03         AND.B #$03                
CODE_01CFF6:        F0 02         BEQ CODE_01CFFA           
CODE_01CFF8:        C6 38         DEC $38                   
CODE_01CFFA:        80 13         BRA CODE_01D00F           

CODE_01CFFC:        A5 36         LDA $36                   
CODE_01CFFE:        18            CLC                       
CODE_01CFFF:        69 06         ADC.B #$06                
CODE_01D001:        85 36         STA $36                   
CODE_01D003:        A5 37         LDA $37                   
CODE_01D005:        69 00         ADC.B #$00                
CODE_01D007:        29 01         AND.B #$01                
CODE_01D009:        85 37         STA $37                   
CODE_01D00B:        E6 38         INC $38                   
CODE_01D00D:        E6 39         INC $39                   
CODE_01D00F:        A5 39         LDA $39                   
CODE_01D011:        C9 A0         CMP.B #$A0                
CODE_01D013:        90 2D         BCC Return01D042          
CODE_01D015:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_01D018:        D0 18         BNE CODE_01D032           
CODE_01D01A:        A9 01         LDA.B #$01                
CODE_01D01C:        8D C0 17      STA.W $17C0               
CODE_01D01F:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D021:        E9 08         SBC.B #$08                
CODE_01D023:        8D C8 17      STA.W $17C8               
CODE_01D026:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D028:        69 08         ADC.B #$08                
CODE_01D02A:        8D C4 17      STA.W $17C4               
CODE_01D02D:        A9 1B         LDA.B #$1B                
CODE_01D02F:        8D CC 17      STA.W $17CC               
CODE_01D032:        A9 D0         LDA.B #$D0                
CODE_01D034:        95 D8         STA RAM_SpriteYLo,X       
CODE_01D036:        22 DF DE 03   JSL.L CODE_03DEDF         
CODE_01D03A:        FE 1C 15      INC.W $151C,X             
CODE_01D03D:        A9 30         LDA.B #$30                
CODE_01D03F:        9D 40 15      STA.W $1540,X             
Return01D042:       60            RTS                       ; Return 

CODE_01D043:        BD 40 15      LDA.W $1540,X             
CODE_01D046:        D0 0E         BNE Return01D056          
CODE_01D048:        EE C6 13      INC.W $13C6               
CODE_01D04B:        CE 93 14      DEC.W $1493               
CODE_01D04E:        A9 0B         LDA.B #$0B                
CODE_01D050:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_01D053:        9E C8 14      STZ.W $14C8,X             
Return01D056:       60            RTS                       ; Return 


DATA_01D057:                      .db $FF,$F1

CODE_01D059:        A9 17         LDA.B #$17                ; \ Play sound effect 
CODE_01D05B:        8D FC 1D      STA.W $1DFC               ; / 
CODE_01D05E:        A0 04         LDY.B #$04                
CODE_01D060:        B9 C8 14      LDA.W $14C8,Y             
CODE_01D063:        F0 04         BEQ CODE_01D069           
CODE_01D065:        88            DEY                       
CODE_01D066:        10 F8         BPL CODE_01D060           
Return01D068:       60            RTS                       ; Return 

CODE_01D069:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_01D06B:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01D06E:        A9 34         LDA.B #$34                
CODE_01D070:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_01D073:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D075:        85 00         STA $00                   
CODE_01D077:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01D07A:        85 01         STA $01                   
CODE_01D07C:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D07E:        18            CLC                       
CODE_01D07F:        69 03         ADC.B #$03                
CODE_01D081:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_01D084:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01D087:        69 00         ADC.B #$00                
CODE_01D089:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_01D08C:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01D08F:        DA            PHX                       
CODE_01D090:        AA            TAX                       
CODE_01D091:        A5 00         LDA $00                   
CODE_01D093:        18            CLC                       
CODE_01D094:        7D 57 D0      ADC.W DATA_01D057,X       
CODE_01D097:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_01D09A:        A5 01         LDA $01                   
CODE_01D09C:        69 FF         ADC.B #$FF                
CODE_01D09E:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_01D0A1:        FA            PLX                       
CODE_01D0A2:        DA            PHX                       
CODE_01D0A3:        BB            TYX                       
CODE_01D0A4:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_01D0A8:        FA            PLX                       
CODE_01D0A9:        DA            PHX                       
CODE_01D0AA:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01D0AD:        99 7C 15      STA.W RAM_SpriteDir,Y     
CODE_01D0B0:        AA            TAX                       
CODE_01D0B1:        BD BE D0      LDA.W DATA_01D0BE,X       
CODE_01D0B4:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_01D0B7:        A9 30         LDA.B #$30                
CODE_01D0B9:        99 40 15      STA.W $1540,Y             
CODE_01D0BC:        FA            PLX                       
Return01D0BD:       60            RTS                       ; Return 


DATA_01D0BE:                      .db $20,$E0

CODE_01D0C0:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01D0C2:        30 18         BMI CODE_01D0DC           
CODE_01D0C4:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01D0C7:        D0 13         BNE CODE_01D0DC           
CODE_01D0C9:        A5 39         LDA $39                   
CODE_01D0CB:        4A            LSR                       
CODE_01D0CC:        A8            TAY                       
CODE_01D0CD:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D0CF:        D9 D6 D0      CMP.W ADDR_01D0D6,Y       
CODE_01D0D2:        90 08         BCC CODE_01D0DC           

Instr01D0D4:                      .db $B9,$D6,$D0

CODE_01D0D7:        95 D8         STA RAM_SpriteYLo,X       
CODE_01D0D9:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
Return01D0DB:       60            RTS                       ; Return 

CODE_01D0DC:        18            CLC                       
Return01D0DD:       60            RTS                       ; Return 


DATA_01D0DE:                      .db $80,$83,$85,$88,$8A,$8B,$8D,$8F
                                  .db $90,$91,$91,$92,$92,$93,$93,$94
                                  .db $94,$95,$95,$96,$96,$97,$97,$98
                                  .db $98,$98,$99,$99,$9A,$9A,$9B,$9B
                                  .db $9C,$9C,$9C,$9C,$9D,$9D,$9D,$9D
                                  .db $9E,$9E,$9E,$9E,$9E,$9F,$9F,$9F
                                  .db $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F

CODE_01D116:        BD 28 15      LDA.W $1528,X             
CODE_01D119:        22 DF 86 00   JSL.L ExecutePtr          

MortonPtrs3:           46 D1      .dw CODE_01D146           
                       3F D2      .dw CODE_01D23F           

Return01D121:       60            RTS                       


DATA_01D122:                      .db $F0,$00,$10,$00,$F0,$00,$10,$00
                                  .db $E8,$00,$18,$00

DATA_01D12E:                      .db $00,$F0,$00,$10,$00,$F0,$00,$10
                                  .db $00,$E8,$00,$18,$26,$26,$D8,$D8
DATA_01D13E:                      .db $90,$30,$30,$90

DATA_01D142:                      .db $00,$01,$02,$01

CODE_01D146:        A5 14         LDA RAM_FrameCounterB     
CODE_01D148:        4A            LSR                       
CODE_01D149:        BC 26 16      LDY.W $1626,X             
CODE_01D14C:        C0 02         CPY.B #$02                
CODE_01D14E:        B0 01         BCS CODE_01D151           
CODE_01D150:        4A            LSR                       
CODE_01D151:        29 03         AND.B #$03                
CODE_01D153:        A8            TAY                       
CODE_01D154:        B9 42 D1      LDA.W DATA_01D142,Y       
CODE_01D157:        BC AC 15      LDY.W $15AC,X             
CODE_01D15A:        F0 02         BEQ CODE_01D15E           
CODE_01D15C:        A9 05         LDA.B #$05                
CODE_01D15E:        9D 02 16      STA.W $1602,X             
CODE_01D161:        BD 4A 16      LDA.W $164A,X             
CODE_01D164:        F0 16         BEQ CODE_01D17C           
CODE_01D166:        B4 E4         LDY RAM_SpriteXLo,X       
CODE_01D168:        C0 50         CPY.B #$50                
CODE_01D16A:        90 10         BCC CODE_01D17C           
CODE_01D16C:        C0 80         CPY.B #$80                
CODE_01D16E:        B0 0C         BCS CODE_01D17C           
CODE_01D170:        DE 4A 16      DEC.W $164A,X             
CODE_01D173:        4A            LSR                       
CODE_01D174:        B0 06         BCS CODE_01D17C           
CODE_01D176:        FE 34 15      INC.W $1534,X             
CODE_01D179:        DE 0E 16      DEC.W $160E,X             
CODE_01D17C:        BD 34 15      LDA.W $1534,X             
CODE_01D17F:        85 05         STA $05                   
CODE_01D181:        85 06         STA $06                   
CODE_01D183:        85 0B         STA $0B                   
CODE_01D185:        85 0C         STA $0C                   
CODE_01D187:        BD 0E 16      LDA.W $160E,X             
CODE_01D18A:        85 07         STA $07                   
CODE_01D18C:        85 08         STA $08                   
CODE_01D18E:        85 09         STA $09                   
CODE_01D190:        85 0A         STA $0A                   
CODE_01D192:        A5 36         LDA $36                   
CODE_01D194:        0A            ASL                       
CODE_01D195:        F0 03         BEQ CODE_01D19A           
CODE_01D197:        4C 24 D2      JMP.W CODE_01D224         

CODE_01D19A:        BC 94 15      LDY.W $1594,X             
CODE_01D19D:        98            TYA                       
CODE_01D19E:        4A            LSR                       
CODE_01D19F:        B0 14         BCS CODE_01D1B5           
CODE_01D1A1:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D1A3:        C0 00         CPY.B #$00                
CODE_01D1A5:        D0 07         BNE CODE_01D1AE           
CODE_01D1A7:        DD 34 15      CMP.W $1534,X             
CODE_01D1AA:        90 69         BCC CODE_01D215           
CODE_01D1AC:        80 2A         BRA CODE_01D1D8           

CODE_01D1AE:        DD 0E 16      CMP.W $160E,X             
CODE_01D1B1:        B0 62         BCS CODE_01D215           
CODE_01D1B3:        80 23         BRA CODE_01D1D8           

CODE_01D1B5:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01D1B8:        D0 04         BNE CODE_01D1BE           
ADDR_01D1BA:        C8            INY                       
ADDR_01D1BB:        C8            INY                       
ADDR_01D1BC:        C8            INY                       
ADDR_01D1BD:        C8            INY                       
CODE_01D1BE:        B9 05 00      LDA.W $0005,Y             
CODE_01D1C1:        95 E4         STA RAM_SpriteXLo,X       
CODE_01D1C3:        BC 94 15      LDY.W $1594,X             
CODE_01D1C6:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D1C8:        C0 03         CPY.B #$03                
CODE_01D1CA:        F0 07         BEQ ADDR_01D1D3           
CODE_01D1CC:        D9 3E D1      CMP.W DATA_01D13E,Y       
CODE_01D1CF:        90 44         BCC CODE_01D215           
CODE_01D1D1:        80 05         BRA CODE_01D1D8           

ADDR_01D1D3:        D9 3E D1      CMP.W DATA_01D13E,Y       
ADDR_01D1D6:        B0 3D         BCS CODE_01D215           
CODE_01D1D8:        BD 26 16      LDA.W $1626,X             
CODE_01D1DB:        C9 02         CMP.B #$02                
CODE_01D1DD:        90 02         BCC CODE_01D1E1           
CODE_01D1DF:        A9 02         LDA.B #$02                
CODE_01D1E1:        0A            ASL                       
CODE_01D1E2:        0A            ASL                       
CODE_01D1E3:        7D 94 15      ADC.W $1594,X             
CODE_01D1E6:        A8            TAY                       
CODE_01D1E7:        B9 22 D1      LDA.W DATA_01D122,Y       
CODE_01D1EA:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01D1EC:        B9 2E D1      LDA.W DATA_01D12E,Y       
CODE_01D1EF:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01D1F1:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01D1F4:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01D1F7:        BD 94 15      LDA.W $1594,X             
CODE_01D1FA:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01D1FD:        D0 02         BNE CODE_01D201           
ADDR_01D1FF:        49 02         EOR.B #$02                
CODE_01D201:        C9 02         CMP.B #$02                
CODE_01D203:        D0 0F         BNE Return01D214          
CODE_01D205:        20 30 AD      JSR.W SubHorizPos         
CODE_01D208:        A5 0F         LDA $0F                   
CODE_01D20A:        18            CLC                       
CODE_01D20B:        69 10         ADC.B #$10                
CODE_01D20D:        C9 20         CMP.B #$20                
CODE_01D20F:        B0 03         BCS Return01D214          
CODE_01D211:        FE 28 15      INC.W $1528,X             
Return01D214:       60            RTS                       ; Return 

CODE_01D215:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01D218:        BD 94 15      LDA.W $1594,X             
CODE_01D21B:        18            CLC                       
CODE_01D21C:        79 3D D2      ADC.W DATA_01D23D,Y       
CODE_01D21F:        29 03         AND.B #$03                
CODE_01D221:        9D 94 15      STA.W $1594,X             
CODE_01D224:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01D227:        A5 36         LDA $36                   
CODE_01D229:        18            CLC                       
CODE_01D22A:        79 39 D2      ADC.W DATA_01D239,Y       
CODE_01D22D:        85 36         STA $36                   
CODE_01D22F:        A5 37         LDA $37                   
CODE_01D231:        79 3B D2      ADC.W DATA_01D23B,Y       
CODE_01D234:        29 01         AND.B #$01                
CODE_01D236:        85 37         STA $37                   
Return01D238:       60            RTS                       ; Return 


DATA_01D239:                      .db $FC,$04

DATA_01D23B:                      .db $FF,$00

DATA_01D23D:                      .db $FF,$01

CODE_01D23F:        BD 40 15      LDA.W $1540,X             
CODE_01D242:        F0 1A         BEQ CODE_01D25E           
CODE_01D244:        C9 01         CMP.B #$01                
CODE_01D246:        D0 5F         BNE Return01D2A7          
CODE_01D248:        9E 28 15      STZ.W $1528,X             
CODE_01D24B:        20 30 AD      JSR.W SubHorizPos         
CODE_01D24E:        98            TYA                       
CODE_01D24F:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01D252:        0A            ASL                       
CODE_01D253:        49 02         EOR.B #$02                
CODE_01D255:        9D 94 15      STA.W $1594,X             
CODE_01D258:        A9 0A         LDA.B #$0A                ; \ Set turning timer 
CODE_01D25A:        9D AC 15      STA.W $15AC,X             ; / 
Return01D25D:       60            RTS                       ; Return 

CODE_01D25E:        A9 06         LDA.B #$06                
CODE_01D260:        9D 02 16      STA.W $1602,X             
CODE_01D263:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01D266:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01D268:        C9 70         CMP.B #$70                
CODE_01D26A:        B0 05         BCS CODE_01D271           
CODE_01D26C:        18            CLC                       
CODE_01D26D:        69 04         ADC.B #$04                
CODE_01D26F:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01D271:        A5 36         LDA $36                   
CODE_01D273:        05 37         ORA $37                   
CODE_01D275:        F0 0F         BEQ CODE_01D286           
CODE_01D277:        A5 36         LDA $36                   
CODE_01D279:        18            CLC                       
CODE_01D27A:        69 08         ADC.B #$08                
CODE_01D27C:        85 36         STA $36                   
CODE_01D27E:        A5 37         LDA $37                   
CODE_01D280:        69 00         ADC.B #$00                
CODE_01D282:        29 01         AND.B #$01                
CODE_01D284:        85 37         STA $37                   
CODE_01D286:        20 C0 D0      JSR.W CODE_01D0C0         
CODE_01D289:        90 1C         BCC Return01D2A7          
CODE_01D28B:        A9 20         LDA.B #$20                ; \ Set ground shake timer 
CODE_01D28D:        8D 87 18      STA.W RAM_ShakeGrndTimer  ; / 
CODE_01D290:        A5 72         LDA RAM_IsFlying          
CODE_01D292:        D0 05         BNE CODE_01D299           
CODE_01D294:        A9 28         LDA.B #$28                ; \ Lock Mario in place 
CODE_01D296:        8D BD 18      STA.W RAM_LockMarioTimer  ; / 
CODE_01D299:        A9 09         LDA.B #$09                ; \ Play sound effect 
CODE_01D29B:        8D FC 1D      STA.W $1DFC               ; / 
CODE_01D29E:        A9 28         LDA.B #$28                
CODE_01D2A0:        9D 40 15      STA.W $1540,X             
CODE_01D2A3:        64 36         STZ $36                   
CODE_01D2A5:        64 37         STZ $37                   
Return01D2A7:       60            RTS                       ; Return 

CODE_01D2A8:        BD 1C 15      LDA.W $151C,X             
CODE_01D2AB:        C9 03         CMP.B #$03                
CODE_01D2AD:        B0 69         BCS Return01D318          
CODE_01D2AF:        BD 7B 18      LDA.W $187B,X             
CODE_01D2B2:        C9 03         CMP.B #$03                
CODE_01D2B4:        D0 07         BNE CODE_01D2BD           
ADDR_01D2B6:        BD 28 15      LDA.W $1528,X             
ADDR_01D2B9:        C9 03         CMP.B #$03                
ADDR_01D2BB:        B0 5B         BCS Return01D318          
CODE_01D2BD:        22 64 B6 03   JSL.L GetMarioClipping    
CODE_01D2C1:        20 0B D4      JSR.W CODE_01D40B         
CODE_01D2C4:        22 2B B7 03   JSL.L CheckForContact     
CODE_01D2C8:        90 4E         BCC Return01D318          
CODE_01D2CA:        BD E2 1F      LDA.W $1FE2,X             
CODE_01D2CD:        D0 49         BNE Return01D318          
CODE_01D2CF:        A9 08         LDA.B #$08                
CODE_01D2D1:        9D E2 1F      STA.W $1FE2,X             
CODE_01D2D4:        A5 72         LDA RAM_IsFlying          
CODE_01D2D6:        F0 41         BEQ CODE_01D319           
CODE_01D2D8:        BD 02 16      LDA.W $1602,X             
CODE_01D2DB:        C9 10         CMP.B #$10                
CODE_01D2DD:        B0 04         BCS CODE_01D2E3           
CODE_01D2DF:        C9 06         CMP.B #$06                
CODE_01D2E1:        B0 3B         BCS ADDR_01D31E           
CODE_01D2E3:        A5 96         LDA RAM_MarioYPos         
CODE_01D2E5:        18            CLC                       
CODE_01D2E6:        69 08         ADC.B #$08                
CODE_01D2E8:        D5 D8         CMP RAM_SpriteYLo,X       
CODE_01D2EA:        B0 32         BCS ADDR_01D31E           
CODE_01D2EC:        BD 94 15      LDA.W $1594,X             
CODE_01D2EF:        4A            LSR                       
CODE_01D2F0:        B0 42         BCS CODE_01D334           
CODE_01D2F2:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01D2F4:        30 27         BMI Return01D31D          
CODE_01D2F6:        20 51 D3      JSR.W CODE_01D351         
CODE_01D2F9:        A9 D0         LDA.B #$D0                
CODE_01D2FB:        85 7D         STA RAM_MarioSpeedY       
CODE_01D2FD:        A9 02         LDA.B #$02                ; \ Play sound effect 
CODE_01D2FF:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01D302:        BD 02 16      LDA.W $1602,X             
CODE_01D305:        C9 1B         CMP.B #$1B                
CODE_01D307:        90 70         BCC CODE_01D379           
ADDR_01D309:        A0 20         LDY.B #$20                
ADDR_01D30B:        B5 E4         LDA RAM_SpriteXLo,X       
ADDR_01D30D:        38            SEC                       
ADDR_01D30E:        E9 08         SBC.B #$08                
ADDR_01D310:        C5 94         CMP RAM_MarioXPos         
ADDR_01D312:        30 02         BMI ADDR_01D316           
ADDR_01D314:        A0 E0         LDY.B #$E0                
ADDR_01D316:        84 7B         STY RAM_MarioSpeedX       
Return01D318:       60            RTS                       ; Return 

CODE_01D319:        22 B7 F5 00   JSL.L HurtMario           
Return01D31D:       60            RTS                       ; Return 

ADDR_01D31E:        A9 01         LDA.B #$01                ; \ Play sound effect 
ADDR_01D320:        8D F9 1D      STA.W $1DF9               ; / 
ADDR_01D323:        A5 7D         LDA RAM_MarioSpeedY       
ADDR_01D325:        10 05         BPL ADDR_01D32C           
ADDR_01D327:        A9 10         LDA.B #$10                
ADDR_01D329:        85 7D         STA RAM_MarioSpeedY       
Return01D32B:       60            RTS                       ; Return 

ADDR_01D32C:        20 09 D3      JSR.W ADDR_01D309         
ADDR_01D32F:        A9 D0         LDA.B #$D0                
ADDR_01D331:        85 7D         STA RAM_MarioSpeedY       
Return01D333:       60            RTS                       ; Return 

CODE_01D334:        A9 01         LDA.B #$01                ; \ Play sound effect 
CODE_01D336:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01D339:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01D33B:        10 05         BPL CODE_01D342           
ADDR_01D33D:        A9 20         LDA.B #$20                
ADDR_01D33F:        85 7D         STA RAM_MarioSpeedY       
Return01D341:       60            RTS                       ; Return 

CODE_01D342:        A0 20         LDY.B #$20                
CODE_01D344:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D346:        10 02         BPL CODE_01D34A           
ADDR_01D348:        A0 E0         LDY.B #$E0                
CODE_01D34A:        84 7B         STY RAM_MarioSpeedX       
CODE_01D34C:        A9 B0         LDA.B #$B0                
CODE_01D34E:        85 7D         STA RAM_MarioSpeedY       
Return01D350:       60            RTS                       ; Return 

CODE_01D351:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D353:        48            PHA                       
CODE_01D354:        38            SEC                       
CODE_01D355:        E9 08         SBC.B #$08                
CODE_01D357:        95 E4         STA RAM_SpriteXLo,X       
CODE_01D359:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01D35C:        48            PHA                       
CODE_01D35D:        E9 00         SBC.B #$00                
CODE_01D35F:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01D362:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D364:        48            PHA                       
CODE_01D365:        18            CLC                       
CODE_01D366:        69 08         ADC.B #$08                
CODE_01D368:        95 D8         STA RAM_SpriteYLo,X       
CODE_01D36A:        22 99 AB 01   JSL.L DisplayContactGfx   
CODE_01D36E:        68            PLA                       
CODE_01D36F:        95 D8         STA RAM_SpriteYLo,X       
CODE_01D371:        68            PLA                       
CODE_01D372:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01D375:        68            PLA                       
CODE_01D376:        95 E4         STA RAM_SpriteXLo,X       
Return01D378:       60            RTS                       ; Return 

CODE_01D379:        A9 18         LDA.B #$18                
CODE_01D37B:        85 38         STA $38                   
CODE_01D37D:        DA            PHX                       
CODE_01D37E:        A5 39         LDA $39                   
CODE_01D380:        4A            LSR                       
CODE_01D381:        AA            TAX                       
CODE_01D382:        A9 28         LDA.B #$28                
CODE_01D384:        85 39         STA $39                   
CODE_01D386:        4A            LSR                       
CODE_01D387:        A8            TAY                       
CODE_01D388:        B9 D6 D0      LDA.W ADDR_01D0D6,Y       
CODE_01D38B:        38            SEC                       
CODE_01D38C:        FD D6 D0      SBC.W ADDR_01D0D6,X       
CODE_01D38F:        FA            PLX                       
CODE_01D390:        18            CLC                       
CODE_01D391:        75 D8         ADC RAM_SpriteYLo,X       
CODE_01D393:        95 D8         STA RAM_SpriteYLo,X       
CODE_01D395:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01D398:        69 00         ADC.B #$00                
CODE_01D39A:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01D39D:        74 B6         STZ RAM_SpriteSpeedX,X    ; \ Sprite Speed = 0 
CODE_01D39F:        74 AA         STZ RAM_SpriteSpeedY,X    ; / 
CODE_01D3A1:        A9 80         LDA.B #$80                
CODE_01D3A3:        9D 40 15      STA.W $1540,X             
CODE_01D3A6:        A9 03         LDA.B #$03                
CODE_01D3A8:        9D 1C 15      STA.W $151C,X             
CODE_01D3AB:        A9 28         LDA.B #$28                ; \ Play sound effect 
CODE_01D3AD:        8D FC 1D      STA.W $1DFC               ; / 
Return01D3B0:       60            RTS                       ; Return 

CODE_01D3B1:        BD 1C 15      LDA.W $151C,X             
CODE_01D3B4:        C9 03         CMP.B #$03                
CODE_01D3B6:        B0 52         BCS Return01D40A          
CODE_01D3B8:        A0 0A         LDY.B #$0A                
CODE_01D3BA:        8C 95 16      STY.W $1695               
CODE_01D3BD:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   
CODE_01D3C0:        C9 05         CMP.B #$05                
CODE_01D3C2:        D0 41         BNE CODE_01D405           
ADDR_01D3C4:        B9 1F 17      LDA.W RAM_ExSpriteXLo,Y   
ADDR_01D3C7:        85 00         STA $00                   
ADDR_01D3C9:        B9 33 17      LDA.W RAM_ExSpriteXHi,Y   
ADDR_01D3CC:        85 08         STA $08                   
ADDR_01D3CE:        B9 15 17      LDA.W RAM_ExSpriteYLo,Y   
ADDR_01D3D1:        85 01         STA $01                   
ADDR_01D3D3:        B9 29 17      LDA.W RAM_ExSpriteYHi,Y   
ADDR_01D3D6:        85 09         STA $09                   
ADDR_01D3D8:        A9 08         LDA.B #$08                
ADDR_01D3DA:        85 02         STA $02                   
ADDR_01D3DC:        85 03         STA $03                   
ADDR_01D3DE:        5A            PHY                       
ADDR_01D3DF:        20 0B D4      JSR.W CODE_01D40B         
ADDR_01D3E2:        7A            PLY                       
ADDR_01D3E3:        22 2B B7 03   JSL.L CheckForContact     
ADDR_01D3E7:        90 1C         BCC CODE_01D405           
ADDR_01D3E9:        A9 01         LDA.B #$01                ; \ Extended sprite = Smoke puff 
ADDR_01D3EB:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
ADDR_01D3EE:        A9 0F         LDA.B #$0F                
ADDR_01D3F0:        99 6F 17      STA.W $176F,Y             
ADDR_01D3F3:        A9 01         LDA.B #$01                ; \ Play sound effect 
ADDR_01D3F5:        8D F9 1D      STA.W $1DF9               ; / 
ADDR_01D3F8:        FE 26 16      INC.W $1626,X             
ADDR_01D3FB:        BD 26 16      LDA.W $1626,X             
ADDR_01D3FE:        C9 0C         CMP.B #$0C                
ADDR_01D400:        90 03         BCC CODE_01D405           
ADDR_01D402:        20 D0 CF      JSR.W CODE_01CFD0         
CODE_01D405:        88            DEY                       
CODE_01D406:        C0 07         CPY.B #$07                
CODE_01D408:        D0 B0         BNE CODE_01D3BA           
Return01D40A:       60            RTS                       ; Return 

CODE_01D40B:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D40D:        38            SEC                       
CODE_01D40E:        E9 08         SBC.B #$08                
CODE_01D410:        85 04         STA $04                   
CODE_01D412:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01D415:        E9 00         SBC.B #$00                
CODE_01D417:        85 0A         STA $0A                   
CODE_01D419:        A9 10         LDA.B #$10                
CODE_01D41B:        85 06         STA $06                   
CODE_01D41D:        A9 10         LDA.B #$10                
CODE_01D41F:        85 07         STA $07                   
CODE_01D421:        BD 02 16      LDA.W $1602,X             
CODE_01D424:        C9 69         CMP.B #$69                
CODE_01D426:        A9 08         LDA.B #$08                
CODE_01D428:        90 02         BCC CODE_01D42C           
ADDR_01D42A:        69 0A         ADC.B #$0A                
CODE_01D42C:        18            CLC                       
CODE_01D42D:        75 D8         ADC RAM_SpriteYLo,X       
CODE_01D42F:        85 05         STA $05                   
CODE_01D431:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01D434:        69 00         ADC.B #$00                
CODE_01D436:        85 0B         STA $0B                   
Return01D438:       60            RTS                       ; Return 


DATA_01D439:                      .db $A8,$B0,$B8,$C0,$C8

ADDR_01D43E:        9E C8 14      STZ.W $14C8,X             ; \ Unreachable 
Return01D441:       60            RTS                       ; / Erase sprite 


DATA_01D442:                      .db $00,$F0,$00,$10

LudwigFireTiles:                  .db $4A,$4C,$6A,$6C

DATA_01D44A:                      .db $45,$45,$05,$05

BossFireball:       A5 9D         LDA RAM_SpritesLocked     
CODE_01D450:        0D FB 13      ORA.W $13FB               
CODE_01D453:        D0 32         BNE CODE_01D487           
CODE_01D455:        BD 40 15      LDA.W $1540,X             
CODE_01D458:        C9 10         CMP.B #$10                
CODE_01D45A:        B0 2B         BCS CODE_01D487           
CODE_01D45C:        A8            TAY                       
CODE_01D45D:        D0 09         BNE CODE_01D468           
CODE_01D45F:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01D462:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01D465:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01D468:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01D46B:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D46D:        18            CLC                       
CODE_01D46E:        69 20         ADC.B #$20                
CODE_01D470:        85 00         STA $00                   
CODE_01D472:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01D475:        69 00         ADC.B #$00                
CODE_01D477:        85 01         STA $01                   
CODE_01D479:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01D47B:        A5 00         LDA $00                   
CODE_01D47D:        C9 30 02      CMP.W #$0230              
CODE_01D480:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01D482:        90 03         BCC CODE_01D487           
CODE_01D484:        9E C8 14      STZ.W $14C8,X             
CODE_01D487:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01D48A:        BD 02 16      LDA.W $1602,X             
CODE_01D48D:        0A            ASL                       
CODE_01D48E:        85 03         STA $03                   
CODE_01D490:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01D493:        0A            ASL                       
CODE_01D494:        85 02         STA $02                   
CODE_01D496:        BD 39 D4      LDA.W DATA_01D439,X       
CODE_01D499:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_01D49C:        A8            TAY                       
CODE_01D49D:        DA            PHX                       
CODE_01D49E:        BD 40 15      LDA.W $1540,X             
CODE_01D4A1:        A2 01         LDX.B #$01                
CODE_01D4A3:        C9 08         CMP.B #$08                
CODE_01D4A5:        90 01         BCC CODE_01D4A8           
CODE_01D4A7:        CA            DEX                       
CODE_01D4A8:        DA            PHX                       
CODE_01D4A9:        DA            PHX                       
CODE_01D4AA:        8A            TXA                       
CODE_01D4AB:        18            CLC                       
CODE_01D4AC:        65 02         ADC $02                   
CODE_01D4AE:        AA            TAX                       
CODE_01D4AF:        A5 00         LDA $00                   
CODE_01D4B1:        18            CLC                       
CODE_01D4B2:        7D 42 D4      ADC.W DATA_01D442,X       
CODE_01D4B5:        99 00 03      STA.W OAM_DispX,Y         
CODE_01D4B8:        A5 14         LDA RAM_FrameCounterB     
CODE_01D4BA:        4A            LSR                       
CODE_01D4BB:        4A            LSR                       
CODE_01D4BC:        6A            ROR                       
CODE_01D4BD:        29 80         AND.B #$80                
CODE_01D4BF:        1D 4A D4      ORA.W DATA_01D44A,X       
CODE_01D4C2:        99 03 03      STA.W OAM_Prop,Y          
CODE_01D4C5:        A5 01         LDA $01                   
CODE_01D4C7:        1A            INC A                     
CODE_01D4C8:        1A            INC A                     
CODE_01D4C9:        99 01 03      STA.W OAM_DispY,Y         
CODE_01D4CC:        68            PLA                       
CODE_01D4CD:        18            CLC                       
CODE_01D4CE:        65 03         ADC $03                   
CODE_01D4D0:        AA            TAX                       
CODE_01D4D1:        BD 46 D4      LDA.W LudwigFireTiles,X   
CODE_01D4D4:        99 02 03      STA.W OAM_Tile,Y          
CODE_01D4D7:        FA            PLX                       
CODE_01D4D8:        C8            INY                       
CODE_01D4D9:        C8            INY                       
CODE_01D4DA:        C8            INY                       
CODE_01D4DB:        C8            INY                       
CODE_01D4DC:        CA            DEX                       
CODE_01D4DD:        10 C9         BPL CODE_01D4A8           
CODE_01D4DF:        FA            PLX                       
CODE_01D4E0:        A0 02         LDY.B #$02                
CODE_01D4E2:        A9 01         LDA.B #$01                
CODE_01D4E4:        4C BB B7      JMP.W FinishOAMWriteRt    


DATA_01D4E7:                      .db $01,$FF

DATA_01D4E9:                      .db $0F,$00

DATA_01D4EB:                      .db $00,$02,$04,$06,$08,$0A,$0C,$0E
                                  .db $0E,$0C,$0A,$08,$06,$04,$02,$00

ParachuteSprites:   BD C8 14      LDA.W $14C8,X             
CODE_01D4FE:        C9 08         CMP.B #$08                
CODE_01D500:        F0 03         BEQ CODE_01D505           
ADDR_01D502:        4C 71 D6      JMP.W CODE_01D671         

CODE_01D505:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01D507:        D0 4F         BNE CODE_01D558           ; / 
CODE_01D509:        BD 40 15      LDA.W $1540,X             
CODE_01D50C:        D0 4A         BNE CODE_01D558           
CODE_01D50E:        A5 13         LDA RAM_FrameCounter      
CODE_01D510:        4A            LSR                       
CODE_01D511:        90 07         BCC CODE_01D51A           
CODE_01D513:        F6 D8         INC RAM_SpriteYLo,X       
CODE_01D515:        D0 03         BNE CODE_01D51A           
CODE_01D517:        FE D4 14      INC.W RAM_SpriteYHi,X     
CODE_01D51A:        BD 1C 15      LDA.W $151C,X             
CODE_01D51D:        D0 39         BNE CODE_01D558           
CODE_01D51F:        A5 13         LDA RAM_FrameCounter      
CODE_01D521:        4A            LSR                       
CODE_01D522:        90 16         BCC CODE_01D53A           
CODE_01D524:        B5 C2         LDA RAM_SpriteState,X     
CODE_01D526:        29 01         AND.B #$01                
CODE_01D528:        A8            TAY                       
CODE_01D529:        BD 70 15      LDA.W $1570,X             
CODE_01D52C:        18            CLC                       
CODE_01D52D:        79 E7 D4      ADC.W DATA_01D4E7,Y       
CODE_01D530:        9D 70 15      STA.W $1570,X             
CODE_01D533:        D9 E9 D4      CMP.W DATA_01D4E9,Y       
CODE_01D536:        D0 02         BNE CODE_01D53A           
CODE_01D538:        F6 C2         INC RAM_SpriteState,X     
CODE_01D53A:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01D53C:        48            PHA                       
CODE_01D53D:        BC 70 15      LDY.W $1570,X             
CODE_01D540:        B5 C2         LDA RAM_SpriteState,X     
CODE_01D542:        4A            LSR                       
CODE_01D543:        B9 EB D4      LDA.W DATA_01D4EB,Y       
CODE_01D546:        90 03         BCC CODE_01D54B           
CODE_01D548:        49 FF         EOR.B #$FF                
CODE_01D54A:        1A            INC A                     
CODE_01D54B:        18            CLC                       
CODE_01D54C:        75 B6         ADC RAM_SpriteSpeedX,X    
CODE_01D54E:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01D550:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01D553:        68            PLA                       
CODE_01D554:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01D556:        80 00         BRA CODE_01D558           

CODE_01D558:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01D55B:        4C B3 D5      JMP.W CODE_01D5B3         


DATA_01D55E:                      .db $0D,$0D,$0D,$0D,$0C,$0C,$0C,$0C
                                  .db $0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D
DATA_01D56E:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $01,$01,$01,$01,$01,$01,$01,$01
DATA_01D57E:                      .db $F8,$F8,$FA,$FA,$FC,$FC,$FE,$FE
                                  .db $02,$02,$04,$04,$06,$06,$08,$08
DATA_01D58E:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $00,$00,$00,$00,$00,$00,$00,$00
DATA_01D59E:                      .db $0E,$0E,$0F,$0F,$10,$10,$10,$10
                                  .db $10,$10,$10,$10,$0F,$0F,$0E,$0E
DATA_01D5AE:                      .db $0F,$0D

DATA_01D5B0:                      .db $01,$05,$00

CODE_01D5B3:        9C 5E 18      STZ.W $185E               
CODE_01D5B6:        A0 F0         LDY.B #$F0                
CODE_01D5B8:        BD 40 15      LDA.W $1540,X             
CODE_01D5BB:        F0 0A         BEQ CODE_01D5C7           
CODE_01D5BD:        4A            LSR                       
CODE_01D5BE:        49 0F         EOR.B #$0F                
CODE_01D5C0:        8D 5E 18      STA.W $185E               
CODE_01D5C3:        18            CLC                       
CODE_01D5C4:        69 F0         ADC.B #$F0                
CODE_01D5C6:        A8            TAY                       
CODE_01D5C7:        84 00         STY $00                   
CODE_01D5C9:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D5CB:        48            PHA                       
CODE_01D5CC:        18            CLC                       
CODE_01D5CD:        65 00         ADC $00                   
CODE_01D5CF:        95 D8         STA RAM_SpriteYLo,X       
CODE_01D5D1:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01D5D4:        48            PHA                       
CODE_01D5D5:        69 FF         ADC.B #$FF                
CODE_01D5D7:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01D5DA:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01D5DD:        48            PHA                       
CODE_01D5DE:        29 F1         AND.B #$F1                
CODE_01D5E0:        09 06         ORA.B #$06                
CODE_01D5E2:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01D5E5:        BC 70 15      LDY.W $1570,X             
CODE_01D5E8:        B9 5E D5      LDA.W DATA_01D55E,Y       
CODE_01D5EB:        9D 02 16      STA.W $1602,X             
CODE_01D5EE:        B9 6E D5      LDA.W DATA_01D56E,Y       
CODE_01D5F1:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01D5F4:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01D5F7:        68            PLA                       
CODE_01D5F8:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01D5FB:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_01D5FE:        18            CLC                       
CODE_01D5FF:        69 04         ADC.B #$04                
CODE_01D601:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_01D604:        BC 70 15      LDY.W $1570,X             
CODE_01D607:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D609:        48            PHA                       
CODE_01D60A:        18            CLC                       
CODE_01D60B:        79 7E D5      ADC.W DATA_01D57E,Y       
CODE_01D60E:        95 E4         STA RAM_SpriteXLo,X       
CODE_01D610:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01D613:        48            PHA                       
CODE_01D614:        79 8E D5      ADC.W DATA_01D58E,Y       
CODE_01D617:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01D61A:        64 00         STZ $00                   
CODE_01D61C:        B9 9E D5      LDA.W DATA_01D59E,Y       
CODE_01D61F:        38            SEC                       
CODE_01D620:        ED 5E 18      SBC.W $185E               
CODE_01D623:        10 02         BPL CODE_01D627           
CODE_01D625:        C6 00         DEC $00                   
CODE_01D627:        18            CLC                       
CODE_01D628:        75 D8         ADC RAM_SpriteYLo,X       
CODE_01D62A:        95 D8         STA RAM_SpriteYLo,X       
CODE_01D62C:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01D62F:        65 00         ADC $00                   
CODE_01D631:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01D634:        BD 02 16      LDA.W $1602,X             
CODE_01D637:        38            SEC                       
CODE_01D638:        E9 0C         SBC.B #$0C                
CODE_01D63A:        C9 01         CMP.B #$01                
CODE_01D63C:        D0 04         BNE CODE_01D642           
CODE_01D63E:        18            CLC                       
CODE_01D63F:        7D 7C 15      ADC.W RAM_SpriteDir,X     
CODE_01D642:        9D 02 16      STA.W $1602,X             
CODE_01D645:        BD 40 15      LDA.W $1540,X             
CODE_01D648:        F0 03         BEQ CODE_01D64D           
CODE_01D64A:        9E 02 16      STZ.W $1602,X             
CODE_01D64D:        BC 02 16      LDY.W $1602,X             
CODE_01D650:        B9 B0 D5      LDA.W DATA_01D5B0,Y       
CODE_01D653:        20 F3 9C      JSR.W SubSprGfx0Entry0    
CODE_01D656:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  
CODE_01D659:        BD 40 15      LDA.W $1540,X             
CODE_01D65C:        F0 35         BEQ CODE_01D693           
CODE_01D65E:        3A            DEC A                     
CODE_01D65F:        D0 20         BNE CODE_01D681           
CODE_01D661:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_01D663:        68            PLA                       
CODE_01D664:        68            PLA                       
CODE_01D665:        68            PLA                       
CODE_01D666:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01D669:        68            PLA                       
CODE_01D66A:        95 D8         STA RAM_SpriteYLo,X       
CODE_01D66C:        A9 80         LDA.B #$80                
CODE_01D66E:        9D 40 15      STA.W $1540,X             
CODE_01D671:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01D673:        38            SEC                       
CODE_01D674:        E9 3F         SBC.B #$3F                
CODE_01D676:        A8            TAY                       
CODE_01D677:        B9 AE D5      LDA.W DATA_01D5AE,Y       
CODE_01D67A:        95 9E         STA RAM_SpriteNum,X       
CODE_01D67C:        22 8B F7 07   JSL.L LoadSpriteTables    
Return01D680:       60            RTS                       ; Return 

CODE_01D681:        20 40 91      JSR.W CODE_019140         
CODE_01D684:        20 0E 80      JSR.W IsOnGround          
CODE_01D687:        F0 03         BEQ CODE_01D68C           
CODE_01D689:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_01D68C:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01D68F:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_01D691:        80 22         BRA CODE_01D6B5           

CODE_01D693:        8A            TXA                       
CODE_01D694:        45 13         EOR RAM_FrameCounter      
CODE_01D696:        4A            LSR                       
CODE_01D697:        90 1C         BCC CODE_01D6B5           
CODE_01D699:        20 40 91      JSR.W CODE_019140         
CODE_01D69C:        20 08 80      JSR.W IsTouchingObjSide   
CODE_01D69F:        F0 0A         BEQ CODE_01D6AB           
ADDR_01D6A1:        A9 01         LDA.B #$01                
ADDR_01D6A3:        9D 1C 15      STA.W $151C,X             
ADDR_01D6A6:        A9 07         LDA.B #$07                
ADDR_01D6A8:        9D 70 15      STA.W $1570,X             
CODE_01D6AB:        20 0E 80      JSR.W IsOnGround          
CODE_01D6AE:        F0 05         BEQ CODE_01D6B5           
CODE_01D6B0:        A9 20         LDA.B #$20                
CODE_01D6B2:        9D 40 15      STA.W $1540,X             
CODE_01D6B5:        68            PLA                       
CODE_01D6B6:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01D6B9:        68            PLA                       
CODE_01D6BA:        95 E4         STA RAM_SpriteXLo,X       
CODE_01D6BC:        68            PLA                       
CODE_01D6BD:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01D6C0:        68            PLA                       
CODE_01D6C1:        95 D8         STA RAM_SpriteYLo,X       
Return01D6C3:       60            RTS                       

InitLineRope:       E0 06         CPX.B #$06                
CODE_01D6C6:        90 18         BCC CODE_01D6E0           
CODE_01D6C8:        AD 92 16      LDA.W $1692               
CODE_01D6CB:        F0 13         BEQ CODE_01D6E0           
CODE_01D6CD:        FE 62 16      INC.W RAM_Tweaker1662,X   
CODE_01D6D0:        80 0E         BRA CODE_01D6E0           

InitLinePlat:       B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D6D4:        29 10         AND.B #$10                
CODE_01D6D6:        49 10         EOR.B #$10                
CODE_01D6D8:        9D 02 16      STA.W $1602,X             
CODE_01D6DB:        F0 03         BEQ CODE_01D6E0           
CODE_01D6DD:        FE 62 16      INC.W RAM_Tweaker1662,X   
CODE_01D6E0:        FE 40 15      INC.W $1540,X             
CODE_01D6E3:        20 4A D7      JSR.W LineFuzzy+Plats     
CODE_01D6E6:        20 4A D7      JSR.W LineFuzzy+Plats     
CODE_01D6E9:        FE 26 16      INC.W $1626,X             
Return01D6EC:       60            RTS                       ; Return 

InitLineGuidedSpr:  FE 7B 18      INC.W $187B,X             
CODE_01D6F0:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D6F2:        29 10         AND.B #$10                
CODE_01D6F4:        D0 11         BNE CODE_01D707           
CODE_01D6F6:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D6F8:        38            SEC                       
CODE_01D6F9:        E9 40         SBC.B #$40                
CODE_01D6FB:        95 E4         STA RAM_SpriteXLo,X       
CODE_01D6FD:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01D700:        E9 01         SBC.B #$01                
CODE_01D702:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01D705:        80 0A         BRA InitLineBrwnPlat      

CODE_01D707:        FE 7C 15      INC.W RAM_SpriteDir,X     
CODE_01D70A:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D70C:        18            CLC                       
CODE_01D70D:        69 0F         ADC.B #$0F                
CODE_01D70F:        95 E4         STA RAM_SpriteXLo,X       
InitLineBrwnPlat:   A9 02         LDA.B #$02                
CODE_01D713:        9D 40 15      STA.W $1540,X             
Return01D716:       60            RTS                       ; Return 


DATA_01D717:                      .db $F8,$00

LineRope+Chainsaw:  8A            TXA                       
CODE_01D71A:        0A            ASL                       
CODE_01D71B:        0A            ASL                       
CODE_01D71C:        45 14         EOR RAM_FrameCounterB     
CODE_01D71E:        85 02         STA $02                   
CODE_01D720:        29 07         AND.B #$07                
CODE_01D722:        05 9D         ORA RAM_SpritesLocked     
CODE_01D724:        D0 14         BNE LineGrinder           
CODE_01D726:        A5 02         LDA $02                   
CODE_01D728:        4A            LSR                       
CODE_01D729:        4A            LSR                       
CODE_01D72A:        4A            LSR                       
CODE_01D72B:        29 01         AND.B #$01                
CODE_01D72D:        A8            TAY                       
CODE_01D72E:        B9 17 D7      LDA.W DATA_01D717,Y       
CODE_01D731:        85 00         STA $00                   
CODE_01D733:        A9 F2         LDA.B #$F2                
CODE_01D735:        85 01         STA $01                   
CODE_01D737:        20 63 80      JSR.W CODE_018063         
LineGrinder:        A5 13         LDA RAM_FrameCounter      
CODE_01D73C:        29 07         AND.B #$07                
CODE_01D73E:        1D 26 16      ORA.W $1626,X             
CODE_01D741:        05 9D         ORA RAM_SpritesLocked     
CODE_01D743:        D0 05         BNE LineFuzzy+Plats       
CODE_01D745:        A9 04         LDA.B #$04                ; \ Play sound effect 
CODE_01D747:        8D FA 1D      STA.W $1DFA               ; / 
LineFuzzy+Plats:    4C A7 D9      JMP.W CODE_01D9A7         

CODE_01D74D:        20 2B AC      JSR.W SubOffscreen1Bnk1   
CODE_01D750:        BD 40 15      LDA.W $1540,X             
CODE_01D753:        D0 07         BNE CODE_01D75C           
CODE_01D755:        A5 9D         LDA RAM_SpritesLocked     
CODE_01D757:        1D 26 16      ORA.W $1626,X             
CODE_01D75A:        D0 90         BNE Return01D6EC          
CODE_01D75C:        B5 C2         LDA RAM_SpriteState,X     
CODE_01D75E:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs01D762:            F4 D7      .dw CODE_01D7F4           
                       68 D7      .dw CODE_01D768           
                       44 DB      .dw CODE_01DB44           

CODE_01D768:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01D76A:        D0 25         BNE Return01D791          ; / 
CODE_01D76C:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01D76F:        D0 21         BNE CODE_01D792           
CODE_01D771:        BC 34 15      LDY.W $1534,X             
CODE_01D774:        20 B0 D7      JSR.W CODE_01D7B0         
CODE_01D777:        FE 34 15      INC.W $1534,X             
CODE_01D77A:        BD 7B 18      LDA.W $187B,X             
CODE_01D77D:        F0 08         BEQ CODE_01D787           
CODE_01D77F:        A5 13         LDA RAM_FrameCounter      
CODE_01D781:        4A            LSR                       
CODE_01D782:        90 03         BCC CODE_01D787           
CODE_01D784:        FE 34 15      INC.W $1534,X             
CODE_01D787:        BD 34 15      LDA.W $1534,X             
CODE_01D78A:        DD 70 15      CMP.W $1570,X             
CODE_01D78D:        90 02         BCC Return01D791          
CODE_01D78F:        74 C2         STZ RAM_SpriteState,X     
Return01D791:       60            RTS                       ; Return 

CODE_01D792:        BC 70 15      LDY.W $1570,X             
CODE_01D795:        88            DEY                       
CODE_01D796:        20 B0 D7      JSR.W CODE_01D7B0         
CODE_01D799:        DE 70 15      DEC.W $1570,X             
CODE_01D79C:        F0 0F         BEQ CODE_01D7AD           
CODE_01D79E:        BD 7B 18      LDA.W $187B,X             
CODE_01D7A1:        F0 0C         BEQ Return01D7AF          
CODE_01D7A3:        A5 13         LDA RAM_FrameCounter      
CODE_01D7A5:        4A            LSR                       
CODE_01D7A6:        90 07         BCC Return01D7AF          
CODE_01D7A8:        DE 70 15      DEC.W $1570,X             
CODE_01D7AB:        D0 02         BNE Return01D7AF          
CODE_01D7AD:        74 C2         STZ RAM_SpriteState,X     
Return01D7AF:       60            RTS                       ; Return 

CODE_01D7B0:        8B            PHB                       ; Sprites calling this routine must be modified 
CODE_01D7B1:        A9 07         LDA.B #$07                ; to set $151C,x and $1528,x to a location in 
CODE_01D7B3:        48            PHA                       ; LineTable instead of $07/F9DB+something 
CODE_01D7B4:        AB            PLB                       
CODE_01D7B5:        BD 1C 15      LDA.W $151C,X             
CODE_01D7B8:        85 04         STA $04                   
CODE_01D7BA:        BD 28 15      LDA.W $1528,X             
CODE_01D7BD:        85 05         STA $05                   
CODE_01D7BF:        B1 04         LDA ($04),Y               
CODE_01D7C1:        29 0F         AND.B #$0F                
CODE_01D7C3:        85 06         STA $06                   
CODE_01D7C5:        B1 04         LDA ($04),Y               
CODE_01D7C7:        AB            PLB                       
CODE_01D7C8:        4A            LSR                       
CODE_01D7C9:        4A            LSR                       
CODE_01D7CA:        4A            LSR                       
CODE_01D7CB:        4A            LSR                       
CODE_01D7CC:        85 07         STA $07                   
CODE_01D7CE:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D7D0:        29 F0         AND.B #$F0                
CODE_01D7D2:        18            CLC                       
CODE_01D7D3:        65 07         ADC $07                   
CODE_01D7D5:        95 D8         STA RAM_SpriteYLo,X       
CODE_01D7D7:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D7D9:        29 F0         AND.B #$F0                
CODE_01D7DB:        18            CLC                       
CODE_01D7DC:        65 06         ADC $06                   
CODE_01D7DE:        95 E4         STA RAM_SpriteXLo,X       
Return01D7E0:       60            RTS                       ; Return 


DATA_01D7E1:                      .db $FC,$04,$FC,$04

DATA_01D7E5:                      .db $FF,$00,$FF,$00

DATA_01D7E9:                      .db $FC,$FC,$04,$04

DATA_01D7ED:                      .db $FF,$FF,$00,$00

CODE_01D7F1:        4C 9F D8      JMP.W CODE_01D89F         

CODE_01D7F4:        A0 03         LDY.B #$03                
CODE_01D7F6:        8C 95 16      STY.W $1695               
CODE_01D7F9:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D7FB:        18            CLC                       
CODE_01D7FC:        79 E1 D7      ADC.W DATA_01D7E1,Y       
CODE_01D7FF:        85 02         STA $02                   
CODE_01D801:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01D804:        79 E5 D7      ADC.W DATA_01D7E5,Y       
CODE_01D807:        85 03         STA $03                   
CODE_01D809:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D80B:        18            CLC                       
CODE_01D80C:        79 E9 D7      ADC.W DATA_01D7E9,Y       
CODE_01D80F:        85 00         STA $00                   
CODE_01D811:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01D814:        79 ED D7      ADC.W DATA_01D7ED,Y       
CODE_01D817:        85 01         STA $01                   
CODE_01D819:        BD 40 15      LDA.W $1540,X             
CODE_01D81C:        D0 1C         BNE CODE_01D83A           
CODE_01D81E:        A5 00         LDA $00                   
CODE_01D820:        29 F0         AND.B #$F0                
CODE_01D822:        85 04         STA $04                   
CODE_01D824:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D826:        29 F0         AND.B #$F0                
CODE_01D828:        C5 04         CMP $04                   
CODE_01D82A:        D0 0E         BNE CODE_01D83A           
CODE_01D82C:        A5 02         LDA $02                   
CODE_01D82E:        29 F0         AND.B #$F0                
CODE_01D830:        85 05         STA $05                   
CODE_01D832:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D834:        29 F0         AND.B #$F0                
CODE_01D836:        C5 05         CMP $05                   
CODE_01D838:        F0 27         BEQ CODE_01D861           
CODE_01D83A:        20 4D D9      JSR.W CODE_01D94D	;WIERD ROUTINE INVOLVING POSITIONS.  ALL VARIABLES SET ABOVE...         
CODE_01D83D:        D0 B2         BNE CODE_01D7F1           
CODE_01D83F:        AD 93 16      LDA.W $1693		;"# OF CUSTOM BLOCK???"               
CODE_01D842:        C9 94         CMP.B #$94                
CODE_01D844:        F0 0B         BEQ CODE_01D851           
CODE_01D846:        C9 95         CMP.B #$95                
CODE_01D848:        D0 0C         BNE CODE_01D856           
CODE_01D84A:        AD AF 14      LDA.W RAM_OnOffStatus     
CODE_01D84D:        F0 12         BEQ CODE_01D861           
CODE_01D84F:        D0 05         BNE CODE_01D856           
CODE_01D851:        AD AF 14      LDA.W RAM_OnOffStatus     
CODE_01D854:        D0 0B         BNE CODE_01D861           
CODE_01D856:        AD 93 16      LDA.W $1693               
CODE_01D859:        C9 76         CMP.B #$76                
CODE_01D85B:        90 04         BCC CODE_01D861           
CODE_01D85D:        C9 9A         CMP.B #$9A                
CODE_01D85F:        90 34         BCC CODE_01D895           
CODE_01D861:        AC 95 16      LDY.W $1695               
CODE_01D864:        88            DEY                       
CODE_01D865:        10 8F         BPL CODE_01D7F6           
CODE_01D867:        B5 C2         LDA RAM_SpriteState,X     
CODE_01D869:        C9 02         CMP.B #$02                ; ?? #00 - platforms stop at end rather than fall off 
CODE_01D86B:        F0 27         BEQ Return01D894          
CODE_01D86D:        A9 02         LDA.B #$02                
CODE_01D86F:        95 C2         STA RAM_SpriteState,X     
CODE_01D871:        BC 0E 16      LDY.W $160E,X             
CODE_01D874:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01D877:        F0 05         BEQ CODE_01D87E           
CODE_01D879:        98            TYA                       
CODE_01D87A:        18            CLC                       
CODE_01D87B:        69 20         ADC.B #$20                
CODE_01D87D:        A8            TAY                       
CODE_01D87E:        B9 11 DD      LDA.W DATA_01DD11,Y       
CODE_01D881:        10 01         BPL CODE_01D884           
CODE_01D883:        0A            ASL                       
CODE_01D884:        5A            PHY                       
CODE_01D885:        0A            ASL                       
CODE_01D886:        95 AA         STA RAM_SpriteSpeedY,X 	;SPEED SETTINGS!   
CODE_01D888:        7A            PLY                       
CODE_01D889:        B9 51 DD      LDA.W DATA_01DD51,Y       
CODE_01D88C:        0A            ASL                       
CODE_01D88D:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01D88F:        A9 10         LDA.B #$10                
CODE_01D891:        9D 40 15      STA.W $1540,X             
Return01D894:       60            RTS                       ; Return 

CODE_01D895:        48            PHA                       
CODE_01D896:        38            SEC                       
CODE_01D897:        E9 76         SBC.B #$76                
CODE_01D899:        A8            TAY                       
CODE_01D89A:        68            PLA                       
CODE_01D89B:        C9 96         CMP.B #$96                
CODE_01D89D:        90 05         BCC CODE_01D8A4           
CODE_01D89F:        BC 0E 16      LDY.W $160E,X             
CODE_01D8A2:        80 24         BRA CODE_01D8C8           

CODE_01D8A4:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D8A6:        85 08         STA $08                   
CODE_01D8A8:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01D8AB:        85 09         STA $09                   
CODE_01D8AD:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D8AF:        85 0A         STA $0A                   
CODE_01D8B1:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01D8B4:        85 0B         STA $0B                   
CODE_01D8B6:        A5 00         LDA $00                   
CODE_01D8B8:        95 D8         STA RAM_SpriteYLo,X       
CODE_01D8BA:        A5 01         LDA $01                   
CODE_01D8BC:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01D8BF:        A5 02         LDA $02                   
CODE_01D8C1:        95 E4         STA RAM_SpriteXLo,X       
CODE_01D8C3:        A5 03         LDA $03                   
CODE_01D8C5:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01D8C8:        8B            PHB                       
CODE_01D8C9:        A9 07         LDA.B #$07                
CODE_01D8CB:        48            PHA                       
CODE_01D8CC:        AB            PLB                       
CODE_01D8CD:        B9 F3 FB      LDA.W CODE_01FBF3,Y       
CODE_01D8D0:        9D 1C 15      STA.W $151C,X             
CODE_01D8D3:        B9 13 FC      LDA.W CODE_01FC13,Y       
CODE_01D8D6:        9D 28 15      STA.W $1528,X             
CODE_01D8D9:        AB            PLB                       
CODE_01D8DA:        B9 D1 DC      LDA.W DATA_01DCD1,Y       
CODE_01D8DD:        9D 70 15      STA.W $1570,X             
CODE_01D8E0:        9E 34 15      STZ.W $1534,X             
CODE_01D8E3:        98            TYA                       
CODE_01D8E4:        9D 0E 16      STA.W $160E,X             
CODE_01D8E7:        BD 40 15      LDA.W $1540,X             
CODE_01D8EA:        D0 47         BNE CODE_01D933           
CODE_01D8EC:        9E 7C 15      STZ.W RAM_SpriteDir,X     
CODE_01D8EF:        B9 F1 DC      LDA.W DATA_01DCF1,Y       
CODE_01D8F2:        F0 0B         BEQ CODE_01D8FF           
CODE_01D8F4:        A8            TAY                       
CODE_01D8F5:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D8F7:        C0 01         CPY.B #$01                
CODE_01D8F9:        D0 02         BNE CODE_01D8FD           
CODE_01D8FB:        49 0F         EOR.B #$0F                
CODE_01D8FD:        80 02         BRA CODE_01D901           

CODE_01D8FF:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D901:        29 0F         AND.B #$0F                
CODE_01D903:        C9 0A         CMP.B #$0A                
CODE_01D905:        90 09         BCC CODE_01D910           
CODE_01D907:        B5 C2         LDA RAM_SpriteState,X     
CODE_01D909:        C9 02         CMP.B #$02                
CODE_01D90B:        F0 03         BEQ CODE_01D910           
CODE_01D90D:        FE 7C 15      INC.W RAM_SpriteDir,X     
CODE_01D910:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D912:        85 0C         STA $0C                   
CODE_01D914:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D916:        85 0D         STA $0D                   
CODE_01D918:        20 68 D7      JSR.W CODE_01D768         
CODE_01D91B:        A5 0C         LDA $0C                   
CODE_01D91D:        38            SEC                       
CODE_01D91E:        F5 D8         SBC RAM_SpriteYLo,X       
CODE_01D920:        18            CLC                       
CODE_01D921:        69 08         ADC.B #$08                
CODE_01D923:        C9 10         CMP.B #$10                
CODE_01D925:        B0 11         BCS CODE_01D938           
CODE_01D927:        A5 0D         LDA $0D                   
CODE_01D929:        38            SEC                       
CODE_01D92A:        F5 E4         SBC RAM_SpriteXLo,X       
CODE_01D92C:        18            CLC                       
CODE_01D92D:        69 08         ADC.B #$08                
CODE_01D92F:        C9 10         CMP.B #$10                
CODE_01D931:        B0 05         BCS CODE_01D938           
CODE_01D933:        A9 01         LDA.B #$01                
CODE_01D935:        95 C2         STA RAM_SpriteState,X     
Return01D937:       60            RTS                       ; Return 

CODE_01D938:        A5 08         LDA $08                   
CODE_01D93A:        95 D8         STA RAM_SpriteYLo,X       
CODE_01D93C:        A5 09         LDA $09                   
CODE_01D93E:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01D941:        A5 0A         LDA $0A                   
CODE_01D943:        95 E4         STA RAM_SpriteXLo,X       
CODE_01D945:        A5 0B         LDA $0B                   
CODE_01D947:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01D94A:        4C 61 D8      JMP.W CODE_01D861         

CODE_01D94D:        A5 00         LDA $00                   
CODE_01D94F:        29 F0         AND.B #$F0                
CODE_01D951:        85 06         STA $06                   
CODE_01D953:        A5 02         LDA $02                   
CODE_01D955:        4A            LSR                       
CODE_01D956:        4A            LSR                       
CODE_01D957:        4A            LSR                       
CODE_01D958:        4A            LSR                       
CODE_01D959:        48            PHA                       
CODE_01D95A:        05 06         ORA $06                   
CODE_01D95C:        48            PHA                       
CODE_01D95D:        A5 5B         LDA RAM_IsVerticalLvl     
CODE_01D95F:        29 01         AND.B #$01                
CODE_01D961:        F0 14         BEQ CODE_01D977           
CODE_01D963:        68            PLA                       
CODE_01D964:        A6 01         LDX $01                   
CODE_01D966:        18            CLC                       
CODE_01D967:        7F 80 BA 00   ADC.L DATA_00BA80,X       
CODE_01D96B:        85 05         STA $05                   
CODE_01D96D:        BF BC BA 00   LDA.L DATA_00BABC,X       
CODE_01D971:        65 03         ADC $03                   
CODE_01D973:        85 06         STA $06                   
CODE_01D975:        80 12         BRA CODE_01D989           

CODE_01D977:        68            PLA                       
CODE_01D978:        A6 03         LDX $03                   
CODE_01D97A:        18            CLC                       
CODE_01D97B:        7F 60 BA 00   ADC.L DATA_00BA60,X       
CODE_01D97F:        85 05         STA $05                   
CODE_01D981:        BF 9C BA 00   LDA.L DATA_00BA9C,X       
CODE_01D985:        65 01         ADC $01                   
CODE_01D987:        85 06         STA $06                   
CODE_01D989:        A9 7E         LDA.B #$7E                
CODE_01D98B:        85 07         STA $07                   
CODE_01D98D:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01D990:        A7 05         LDA [$05]                 
CODE_01D992:        8D 93 16      STA.W $1693               
CODE_01D995:        E6 07         INC $07                   
CODE_01D997:        A7 05         LDA [$05]                 
CODE_01D999:        7A            PLY                       
CODE_01D99A:        84 05         STY $05                   
CODE_01D99C:        48            PHA                       
CODE_01D99D:        A5 05         LDA $05                   
CODE_01D99F:        29 07         AND.B #$07                
CODE_01D9A1:        A8            TAY                       
CODE_01D9A2:        68            PLA                       
CODE_01D9A3:        39 00 80      AND.W DATA_018000,Y       
Return01D9A6:       60            RTS                       ; Return 

CODE_01D9A7:        B5 9E         LDA RAM_SpriteNum,X	;LINE GUIDE PLATFORM FUZZY       
CODE_01D9A9:        C9 64         CMP.B #$64		;DETERMINE SPRITE ITS DEALING WITH                
CODE_01D9AB:        F0 26         BEQ CODE_01D9D3           
CODE_01D9AD:        C9 65         CMP.B #$65                
CODE_01D9AF:        90 1F         BCC CODE_01D9D0 	;PLATFORM!          
CODE_01D9B1:        C9 68         CMP.B #$68                
CODE_01D9B3:        D0 05         BNE CODE_01D9BA           
CODE_01D9B5:        20 D4 DB      JSR.W CODE_01DBD4         
CODE_01D9B8:        80 07         BRA CODE_01D9C1           

CODE_01D9BA:        C9 67         CMP.B #$67                
CODE_01D9BC:        D0 08         BNE CODE_01D9C6           
CODE_01D9BE:        20 0B DC      JSR.W CODE_01DC0B         
CODE_01D9C1:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01D9C4:        80 07         BRA CODE_01D9CD           

CODE_01D9C6:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01D9C9:        22 63 C2 03   JSL.L CODE_03C263         
CODE_01D9CD:        4C 4D D7      JMP.W CODE_01D74D         

CODE_01D9D0:        4C A2 DA      JMP.W CODE_01DAA2         

CODE_01D9D3:        20 54 DC      JSR.W CODE_01DC54         
CODE_01D9D6:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01D9D8:        48            PHA                       
CODE_01D9D9:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01D9DB:        48            PHA                       
CODE_01D9DC:        20 4D D7      JSR.W CODE_01D74D         
CODE_01D9DF:        68            PLA                       
CODE_01D9E0:        38            SEC                       
CODE_01D9E1:        F5 D8         SBC RAM_SpriteYLo,X       
CODE_01D9E3:        49 FF         EOR.B #$FF                
CODE_01D9E5:        1A            INC A                     
CODE_01D9E6:        8D 5E 18      STA.W $185E               
CODE_01D9E9:        68            PLA                       
CODE_01D9EA:        38            SEC                       
CODE_01D9EB:        F5 E4         SBC RAM_SpriteXLo,X       
CODE_01D9ED:        49 FF         EOR.B #$FF                
CODE_01D9EF:        1A            INC A                     
CODE_01D9F0:        8D B6 18      STA.W $18B6               
CODE_01D9F3:        A5 77         LDA RAM_MarioObjStatus    
CODE_01D9F5:        29 03         AND.B #$03                
CODE_01D9F7:        D0 10         BNE Return01DA09          
CODE_01D9F9:        20 0F A8      JSR.W CODE_01A80F         
CODE_01D9FC:        B0 0C         BCS CODE_01DA0A           
CODE_01D9FE:        BD 3E 16      LDA.W $163E,X             
CODE_01DA01:        F0 06         BEQ Return01DA09          
CODE_01DA03:        9E 3E 16      STZ.W $163E,X             
CODE_01DA06:        9C BE 18      STZ.W $18BE               
Return01DA09:       60            RTS                       ; Return 

CODE_01DA0A:        BD C8 14      LDA.W $14C8,X             
CODE_01DA0D:        F0 28         BEQ CODE_01DA37           
CODE_01DA0F:        AD 70 14      LDA.W $1470               ; \ Branch if carrying an enemy... 
CODE_01DA12:        0D 7A 18      ORA.W RAM_OnYoshi         ;  | ...or if on Yoshi 
CODE_01DA15:        D0 E7         BNE CODE_01D9FE           ; / 
CODE_01DA17:        A9 03         LDA.B #$03                
CODE_01DA19:        9D 3E 16      STA.W $163E,X             
CODE_01DA1C:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_01DA1F:        D0 6E         BNE Return01DA8F          
CODE_01DA21:        AD BE 18      LDA.W $18BE               
CODE_01DA24:        D0 09         BNE CODE_01DA2F           
CODE_01DA26:        A5 15         LDA RAM_ControllerA       
CODE_01DA28:        29 08         AND.B #$08                
CODE_01DA2A:        F0 63         BEQ Return01DA8F          
CODE_01DA2C:        8D BE 18      STA.W $18BE               
CODE_01DA2F:        24 16         BIT $16                   
CODE_01DA31:        10 0C         BPL CODE_01DA3F           
CODE_01DA33:        A9 B0         LDA.B #$B0                
CODE_01DA35:        85 7D         STA RAM_MarioSpeedY       
CODE_01DA37:        9C BE 18      STZ.W $18BE               
CODE_01DA3A:        A9 10         LDA.B #$10                
CODE_01DA3C:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_01DA3F:        A0 00         LDY.B #$00                
CODE_01DA41:        AD 5E 18      LDA.W $185E               
CODE_01DA44:        10 01         BPL CODE_01DA47           
CODE_01DA46:        88            DEY                       
CODE_01DA47:        18            CLC                       
CODE_01DA48:        65 96         ADC RAM_MarioYPos         
CODE_01DA4A:        85 96         STA RAM_MarioYPos         
CODE_01DA4C:        98            TYA                       
CODE_01DA4D:        65 97         ADC RAM_MarioYPosHi       
CODE_01DA4F:        85 97         STA RAM_MarioYPosHi       
CODE_01DA51:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01DA53:        85 00         STA $00                   
CODE_01DA55:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01DA58:        85 01         STA $01                   
CODE_01DA5A:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01DA5C:        A5 96         LDA RAM_MarioYPos         
CODE_01DA5E:        38            SEC                       
CODE_01DA5F:        E5 00         SBC $00                   
CODE_01DA61:        C9 00 00      CMP.W #$0000              
CODE_01DA64:        10 02         BPL CODE_01DA68           
ADDR_01DA66:        E6 96         INC RAM_MarioYPos         
CODE_01DA68:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01DA6A:        AD B6 18      LDA.W $18B6               
CODE_01DA6D:        20 90 DA      JSR.W CODE_01DA90         
CODE_01DA70:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01DA72:        38            SEC                       
CODE_01DA73:        E9 08         SBC.B #$08                
CODE_01DA75:        C5 94         CMP RAM_MarioXPos         
CODE_01DA77:        F0 0B         BEQ CODE_01DA84           
CODE_01DA79:        10 04         BPL CODE_01DA7F           
CODE_01DA7B:        A9 FF         LDA.B #$FF                
CODE_01DA7D:        80 02         BRA CODE_01DA81           

CODE_01DA7F:        A9 01         LDA.B #$01                
CODE_01DA81:        20 90 DA      JSR.W CODE_01DA90         
CODE_01DA84:        BD 26 16      LDA.W $1626,X             
CODE_01DA87:        F0 06         BEQ Return01DA8F          
CODE_01DA89:        9E 26 16      STZ.W $1626,X             
CODE_01DA8C:        9E 40 15      STZ.W $1540,X             
Return01DA8F:       60            RTS                       ; Return 

CODE_01DA90:        A0 00         LDY.B #$00                
CODE_01DA92:        C9 00         CMP.B #$00                
CODE_01DA94:        10 01         BPL CODE_01DA97           
CODE_01DA96:        88            DEY                       
CODE_01DA97:        18            CLC                       
CODE_01DA98:        65 94         ADC RAM_MarioXPos         
CODE_01DA9A:        85 94         STA RAM_MarioXPos         
CODE_01DA9C:        98            TYA                       
CODE_01DA9D:        65 95         ADC RAM_MarioXPosHi       
CODE_01DA9F:        85 95         STA RAM_MarioXPosHi       
Return01DAA1:       60            RTS                       ; Return 

CODE_01DAA2:        A0 18         LDY.B #$18 			;LINE GUIDED PLATFORM CODE               
CODE_01DAA4:        BD 02 16      LDA.W $1602,X             
CODE_01DAA7:        F0 02         BEQ CODE_01DAAB           
CODE_01DAA9:        A0 28         LDY.B #$28 			;CONDITIONAL DEPENDING ON PLATFORM TYPE?               
CODE_01DAAB:        84 00         STY $00                   
CODE_01DAAD:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01DAAF:        48            PHA                       
CODE_01DAB0:        38            SEC                       
CODE_01DAB1:        E5 00         SBC $00                   
CODE_01DAB3:        95 E4         STA RAM_SpriteXLo,X       
CODE_01DAB5:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01DAB8:        48            PHA                       
CODE_01DAB9:        E9 00         SBC.B #$00                
CODE_01DABB:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01DABE:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01DAC0:        48            PHA                       
CODE_01DAC1:        38            SEC                       
CODE_01DAC2:        E9 08         SBC.B #$08                
CODE_01DAC4:        95 D8         STA RAM_SpriteYLo,X       
CODE_01DAC6:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01DAC9:        48            PHA                       
CODE_01DACA:        E9 00         SBC.B #$00                
CODE_01DACC:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01DACF:        20 DF B2      JSR.W CODE_01B2DF 		;DRAW GFX  .  RELIES ON NEW POSITIONS MADE UP THERE.      
CODE_01DAD2:        68            PLA 				;RESTORE POSITIONS                     
CODE_01DAD3:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01DAD6:        68            PLA                       
CODE_01DAD7:        95 D8         STA RAM_SpriteYLo,X       
CODE_01DAD9:        68            PLA                       
CODE_01DADA:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01DADD:        68            PLA                       
CODE_01DADE:        95 E4         STA RAM_SpriteXLo,X       
CODE_01DAE0:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01DAE2:        48            PHA                       
CODE_01DAE3:        20 4D D7      JSR.W CODE_01D74D 		;LINE GUIDE HANDLER???        
CODE_01DAE6:        68            PLA                       
CODE_01DAE7:        38            SEC                       
CODE_01DAE8:        F5 E4         SBC RAM_SpriteXLo,X       
CODE_01DAEA:        BC 28 15      LDY.W $1528,X             
CODE_01DAED:        5A            PHY                       
CODE_01DAEE:        49 FF         EOR.B #$FF                
CODE_01DAF0:        1A            INC A                     
CODE_01DAF1:        9D 28 15      STA.W $1528,X             
CODE_01DAF4:        A0 18         LDY.B #$18                
CODE_01DAF6:        BD 02 16      LDA.W $1602,X             
CODE_01DAF9:        F0 02         BEQ CODE_01DAFD           
CODE_01DAFB:        A0 28         LDY.B #$28                
CODE_01DAFD:        84 00         STY $00                   
CODE_01DAFF:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01DB01:        48            PHA                       
CODE_01DB02:        38            SEC                       
CODE_01DB03:        E5 00         SBC $00                   
CODE_01DB05:        95 E4         STA RAM_SpriteXLo,X       
CODE_01DB07:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01DB0A:        48            PHA                       
CODE_01DB0B:        E9 00         SBC.B #$00                
CODE_01DB0D:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01DB10:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01DB12:        48            PHA                       
CODE_01DB13:        38            SEC                       
CODE_01DB14:        E9 08         SBC.B #$08                
CODE_01DB16:        95 D8         STA RAM_SpriteYLo,X       
CODE_01DB18:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01DB1B:        48            PHA                       
CODE_01DB1C:        E9 00         SBC.B #$00                
CODE_01DB1E:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01DB21:        20 57 B4      JSR.W CODE_01B457		;CUSTOM INTERACTION HANDLER         
CODE_01DB24:        90 0B         BCC CODE_01DB31           
CODE_01DB26:        BD 26 16      LDA.W $1626,X             
CODE_01DB29:        F0 06         BEQ CODE_01DB31           
CODE_01DB2B:        9E 26 16      STZ.W $1626,X             
CODE_01DB2E:        9E 40 15      STZ.W $1540,X             
CODE_01DB31:        68            PLA                       
CODE_01DB32:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01DB35:        68            PLA                       
CODE_01DB36:        95 D8         STA RAM_SpriteYLo,X       
CODE_01DB38:        68            PLA                       
CODE_01DB39:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01DB3C:        68            PLA                       
CODE_01DB3D:        95 E4         STA RAM_SpriteXLo,X       
CODE_01DB3F:        68            PLA                       
CODE_01DB40:        9D 28 15      STA.W $1528,X             
Return01DB43:       60            RTS                       ; Return 

CODE_01DB44:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01DB46:        D0 11         BNE Return01DB59          ; / 
CODE_01DB48:        20 32 90      JSR.W SubUpdateSprPos     
CODE_01DB4B:        BD 40 15      LDA.W $1540,X             
CODE_01DB4E:        D0 09         BNE Return01DB59          
CODE_01DB50:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01DB52:        C9 20         CMP.B #$20                
CODE_01DB54:        30 03         BMI Return01DB59          
CODE_01DB56:        20 F4 D7      JSR.W CODE_01D7F4         
Return01DB59:       60            RTS                       ; Return 


DATA_01DB5A:                      .db $18,$E8

Grinder:            20 A2 DB      JSR.W CODE_01DBA2         
CODE_01DB5F:        BD C8 14      LDA.W $14C8,X             
CODE_01DB62:        C9 08         CMP.B #$08                
CODE_01DB64:        D0 2F         BNE Return01DB95          
CODE_01DB66:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01DB68:        D0 2B         BNE Return01DB95          ; / 
CODE_01DB6A:        A5 13         LDA RAM_FrameCounter      
CODE_01DB6C:        29 03         AND.B #$03                
CODE_01DB6E:        D0 05         BNE CODE_01DB75           
CODE_01DB70:        A9 04         LDA.B #$04                ; \ Play sound effect 
CODE_01DB72:        8D FA 1D      STA.W $1DFA               ; / 
CODE_01DB75:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01DB78:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01DB7B:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01DB7E:        B9 5A DB      LDA.W DATA_01DB5A,Y       
CODE_01DB81:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01DB83:        20 32 90      JSR.W SubUpdateSprPos     
CODE_01DB86:        20 0E 80      JSR.W IsOnGround          
CODE_01DB89:        F0 02         BEQ CODE_01DB8D           
CODE_01DB8B:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_01DB8D:        20 08 80      JSR.W IsTouchingObjSide   
CODE_01DB90:        F0 03         BEQ Return01DB95          
CODE_01DB92:        20 98 90      JSR.W FlipSpriteDir       
Return01DB95:       60            RTS                       ; Return 


DATA_01DB96:                      .db $F8,$08,$F8,$08

DATA_01DB9A:                      .db $00,$00,$10,$10

DATA_01DB9E:                      .db $03,$43,$83,$C3

CODE_01DBA2:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01DBA5:        DA            PHX                       
CODE_01DBA6:        A2 03         LDX.B #$03                
CODE_01DBA8:        A5 00         LDA $00                   
CODE_01DBAA:        18            CLC                       
CODE_01DBAB:        7D 96 DB      ADC.W DATA_01DB96,X       
CODE_01DBAE:        99 00 03      STA.W OAM_DispX,Y         
CODE_01DBB1:        A5 01         LDA $01                   
CODE_01DBB3:        18            CLC                       
CODE_01DBB4:        7D 9A DB      ADC.W DATA_01DB9A,X       
CODE_01DBB7:        99 01 03      STA.W OAM_DispY,Y         
CODE_01DBBA:        A5 14         LDA RAM_FrameCounterB     
CODE_01DBBC:        29 02         AND.B #$02                
CODE_01DBBE:        09 6C         ORA.B #$6C                
CODE_01DBC0:        99 02 03      STA.W OAM_Tile,Y          
CODE_01DBC3:        BD 9E DB      LDA.W DATA_01DB9E,X       
CODE_01DBC6:        99 03 03      STA.W OAM_Prop,Y          
CODE_01DBC9:        C8            INY                       
CODE_01DBCA:        C8            INY                       
CODE_01DBCB:        C8            INY                       
CODE_01DBCC:        C8            INY                       
CODE_01DBCD:        CA            DEX                       
CODE_01DBCE:        10 D8         BPL CODE_01DBA8           
CODE_01DBD0:        A9 03         LDA.B #$03                
CODE_01DBD2:        80 2F         BRA CODE_01DC03           

CODE_01DBD4:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01DBD7:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01DBDA:        B9 00 03      LDA.W OAM_DispX,Y         
CODE_01DBDD:        38            SEC                       
CODE_01DBDE:        E9 08         SBC.B #$08                
CODE_01DBE0:        99 00 03      STA.W OAM_DispX,Y         
CODE_01DBE3:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_01DBE6:        38            SEC                       
CODE_01DBE7:        E9 08         SBC.B #$08                
CODE_01DBE9:        99 01 03      STA.W OAM_DispY,Y         
CODE_01DBEC:        DA            PHX                       
CODE_01DBED:        A5 14         LDA RAM_FrameCounterB     
CODE_01DBEF:        4A            LSR                       
CODE_01DBF0:        4A            LSR                       
CODE_01DBF1:        29 01         AND.B #$01                
CODE_01DBF3:        AA            TAX                       
CODE_01DBF4:        A9 C8         LDA.B #$C8                
CODE_01DBF6:        99 02 03      STA.W OAM_Tile,Y          
CODE_01DBF9:        BD 09 DC      LDA.W DATA_01DC09,X       
CODE_01DBFC:        05 64         ORA $64                   
CODE_01DBFE:        99 03 03      STA.W OAM_Prop,Y          
CODE_01DC01:        A9 00         LDA.B #$00                
CODE_01DC03:        FA            PLX                       
CODE_01DC04:        A0 02         LDY.B #$02                
CODE_01DC06:        4C BB B7      JMP.W FinishOAMWriteRt    


DATA_01DC09:                      .db $05,$45

CODE_01DC0B:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01DC0E:        DA            PHX                       
CODE_01DC0F:        A2 03         LDX.B #$03                
CODE_01DC11:        A5 00         LDA $00                   
CODE_01DC13:        18            CLC                       
CODE_01DC14:        7D 3B DC      ADC.W DATA_01DC3B,X       
CODE_01DC17:        99 00 03      STA.W OAM_DispX,Y         
CODE_01DC1A:        A5 01         LDA $01                   
CODE_01DC1C:        18            CLC                       
CODE_01DC1D:        7D 3F DC      ADC.W DATA_01DC3F,X       
CODE_01DC20:        99 01 03      STA.W OAM_DispY,Y         
CODE_01DC23:        A5 14         LDA RAM_FrameCounterB     
CODE_01DC25:        29 02         AND.B #$02                
CODE_01DC27:        09 6C         ORA.B #$6C                
CODE_01DC29:        99 02 03      STA.W OAM_Tile,Y          
CODE_01DC2C:        BD 43 DC      LDA.W DATA_01DC43,X       
CODE_01DC2F:        99 03 03      STA.W OAM_Prop,Y          
CODE_01DC32:        C8            INY                       
CODE_01DC33:        C8            INY                       
CODE_01DC34:        C8            INY                       
CODE_01DC35:        C8            INY                       
CODE_01DC36:        CA            DEX                       
CODE_01DC37:        10 D8         BPL CODE_01DC11           
CODE_01DC39:        80 95         BRA CODE_01DBD0           


DATA_01DC3B:                      .db $F0,$00,$F0,$00

DATA_01DC3F:                      .db $F0,$F0,$00,$00

DATA_01DC43:                      .db $33,$73,$B3,$F3

RopeMotorTiles:                   .db $C0,$C2,$E0,$C2

LineGuideRopeTiles:               .db $C0,$CE,$CE,$CE,$CE,$CE,$CE,$CE
                                  .db $CE

CODE_01DC54:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01DC57:        A5 00         LDA $00                   
CODE_01DC59:        38            SEC                       
CODE_01DC5A:        E9 08         SBC.B #$08                
CODE_01DC5C:        85 00         STA $00                   
CODE_01DC5E:        A5 01         LDA $01                   
CODE_01DC60:        38            SEC                       
CODE_01DC61:        E9 08         SBC.B #$08                
CODE_01DC63:        85 01         STA $01                   
CODE_01DC65:        8A            TXA                       
CODE_01DC66:        0A            ASL                       
CODE_01DC67:        0A            ASL                       
CODE_01DC68:        45 14         EOR RAM_FrameCounterB     
CODE_01DC6A:        4A            LSR                       
CODE_01DC6B:        4A            LSR                       
CODE_01DC6C:        4A            LSR                       
CODE_01DC6D:        29 03         AND.B #$03                
CODE_01DC6F:        85 02         STA $02                   
CODE_01DC71:        A9 05         LDA.B #$05                
CODE_01DC73:        E0 06         CPX.B #$06                
CODE_01DC75:        90 07         BCC CODE_01DC7E           
CODE_01DC77:        AC 92 16      LDY.W $1692               
CODE_01DC7A:        F0 02         BEQ CODE_01DC7E           
CODE_01DC7C:        A9 09         LDA.B #$09                
CODE_01DC7E:        85 03         STA $03                   
CODE_01DC80:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01DC83:        A2 00         LDX.B #$00                
CODE_01DC85:        A5 00         LDA $00                   
CODE_01DC87:        99 00 03      STA.W OAM_DispX,Y         
CODE_01DC8A:        A5 01         LDA $01                   
CODE_01DC8C:        99 01 03      STA.W OAM_DispY,Y         
CODE_01DC8F:        18            CLC                       
CODE_01DC90:        69 10         ADC.B #$10                
CODE_01DC92:        85 01         STA $01                   
CODE_01DC94:        BD 4B DC      LDA.W LineGuideRopeTiles,X 
CODE_01DC97:        E0 00         CPX.B #$00                
CODE_01DC99:        D0 07         BNE CODE_01DCA2           
CODE_01DC9B:        DA            PHX                       
CODE_01DC9C:        A6 02         LDX $02                   
CODE_01DC9E:        BD 47 DC      LDA.W RopeMotorTiles,X    
CODE_01DCA1:        FA            PLX                       
CODE_01DCA2:        99 02 03      STA.W OAM_Tile,Y          
CODE_01DCA5:        A9 37         LDA.B #$37                
CODE_01DCA7:        E0 01         CPX.B #$01                
CODE_01DCA9:        90 02         BCC CODE_01DCAD           
CODE_01DCAB:        A9 31         LDA.B #$31                
CODE_01DCAD:        99 03 03      STA.W OAM_Prop,Y          
CODE_01DCB0:        C8            INY                       
CODE_01DCB1:        C8            INY                       
CODE_01DCB2:        C8            INY                       
CODE_01DCB3:        C8            INY                       
CODE_01DCB4:        E8            INX                       
CODE_01DCB5:        E4 03         CPX $03                   
CODE_01DCB7:        D0 CC         BNE CODE_01DC85           
CODE_01DCB9:        A9 DE         LDA.B #$DE                
CODE_01DCBB:        99 FE 02      STA.W $02FE,Y             
CODE_01DCBE:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01DCC1:        A9 04         LDA.B #$04                
CODE_01DCC3:        E0 06         CPX.B #$06                
CODE_01DCC5:        90 07         BCC CODE_01DCCE           
CODE_01DCC7:        AC 92 16      LDY.W $1692               
CODE_01DCCA:        F0 02         BEQ CODE_01DCCE           
CODE_01DCCC:        A9 08         LDA.B #$08                
CODE_01DCCE:        4C 04 DC      JMP.W CODE_01DC04         


DATA_01DCD1:                      .db $15,$15,$15,$15,$0C,$10,$10,$10
                                  .db $10,$0C,$0C,$10,$10,$10,$10,$0C
                                  .db $15,$15,$10,$10,$10,$10,$10,$10
                                  .db $10,$10,$10,$10,$10,$10,$15,$15
DATA_01DCF1:                      .db $00,$00,$00,$00,$00,$00,$01,$02
                                  .db $00,$00,$00,$00,$02,$01,$00,$00
                                  .db $00,$00,$01,$02,$01,$02,$00,$00
                                  .db $00,$00,$02,$02,$00,$00,$00,$00
DATA_01DD11:                      .db $00,$10,$00,$F0,$F4,$FC,$F0,$10
                                  .db $04,$0C,$0C,$00,$10,$F0,$FC,$F4
                                  .db $F0,$10,$F0,$10,$F0,$10,$F8,$F8
                                  .db $08,$08,$10,$10,$00,$00,$F0,$10
                                  .db $10,$00,$F0,$F0,$0C,$04,$10,$F0
                                  .db $00,$F4,$F4,$FC,$F0,$10,$00,$0C
                                  .db $10,$F0,$10,$00,$10,$F0,$08,$08
                                  .db $F8,$F8,$F0,$F0,$00,$00,$10,$F0
DATA_01DD51:                      .db $10,$00,$10,$00,$0C,$10,$04,$00
                                  .db $10,$0C,$0C,$10,$04,$00,$10,$0C
                                  .db $10,$10,$08,$08,$08,$08,$10,$10
                                  .db $10,$10,$00,$00,$10,$10,$10,$10
                                  .db $00,$F0,$00,$F0,$F4,$F0,$00,$FC
                                  .db $F0,$F4,$F4,$F0,$00,$FC,$F0,$F4
                                  .db $F0,$F0,$F8,$F8,$F8,$F8,$F0,$F0
                                  .db $F0,$F0,$00,$00,$F0,$F0,$F0

DATA_01DD90:                      .db $F0

DATA_01DD91:                      .db $50,$78,$A0,$A0,$A0,$78,$50,$50
DATA_01DD99:                      .db $78

DATA_01DD9A:                      .db $F0,$F0,$F0,$18,$40,$40,$40,$18
DATA_01DDA2:                      .db $18,$03,$00,$00,$01,$01,$02,$02
                                  .db $03,$FF

InitBonusGame:      AD 94 1B      LDA.W $1B94               
CODE_01DDAF:        F0 04         BEQ CODE_01DDB5           
ADDR_01DDB1:        9E C8 14      STZ.W $14C8,X             
Return01DDB4:       60            RTS                       ; Return 

CODE_01DDB5:        A2 09         LDX.B #$09                
CODE_01DDB7:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_01DDB9:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01DDBC:        A9 82         LDA.B #$82                
CODE_01DDBE:        9D 9E 00      STA.W RAM_SpriteNum,X     
CODE_01DDC1:        BD 90 DD      LDA.W DATA_01DD90,X       
CODE_01DDC4:        95 E4         STA RAM_SpriteXLo,X       
CODE_01DDC6:        A9 00         LDA.B #$00                
CODE_01DDC8:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01DDCB:        BD 99 DD      LDA.W DATA_01DD99,X       
CODE_01DDCE:        95 D8         STA RAM_SpriteYLo,X       
CODE_01DDD0:        0A            ASL                       
CODE_01DDD1:        A9 00         LDA.B #$00                
CODE_01DDD3:        B0 01         BCS CODE_01DDD6           
CODE_01DDD5:        1A            INC A                     
CODE_01DDD6:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01DDD9:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_01DDDD:        BD A2 DD      LDA.W DATA_01DDA2,X       
CODE_01DDE0:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01DDE3:        8A            TXA                       
CODE_01DDE4:        18            CLC                       
CODE_01DDE5:        65 13         ADC RAM_FrameCounter      
CODE_01DDE7:        29 07         AND.B #$07                
CODE_01DDE9:        9D 70 15      STA.W $1570,X             
CODE_01DDEC:        CA            DEX                       
CODE_01DDED:        D0 C8         BNE CODE_01DDB7           
CODE_01DDEF:        9C 8F 18      STZ.W $188F               
CODE_01DDF2:        9C 90 18      STZ.W $1890               
CODE_01DDF5:        22 F9 AC 01   JSL.L GetRand             
CODE_01DDF9:        45 13         EOR RAM_FrameCounter      
CODE_01DDFB:        65 14         ADC RAM_FrameCounterB     
CODE_01DDFD:        29 07         AND.B #$07                
CODE_01DDFF:        A8            TAY                       
CODE_01DE00:        B9 21 DE      LDA.W DATA_01DE21,Y       
CODE_01DE03:        8D 79 15      STA.W $1579               
CODE_01DE06:        A9 01         LDA.B #$01                
CODE_01DE08:        85 CB         STA $CB                   
CODE_01DE0A:        EE 94 1B      INC.W $1B94               
CODE_01DE0D:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
Return01DE10:       60            RTS                       ; Return 


DATA_01DE11:                      .db $10,$00,$F0,$00

DATA_01DE15:                      .db $00,$10,$00,$F0

DATA_01DE19:                      .db $A0,$A0,$50,$50

DATA_01DE1D:                      .db $F0,$40,$40,$F0

DATA_01DE21:                      .db $01,$01,$01,$04,$04,$04,$07,$07
                                  .db $07

BonusGame:          9E A0 15      STZ.W RAM_OffscreenHorz,X 
CODE_01DE2D:        E0 01         CPX.B #$01                
CODE_01DE2F:        D0 03         BNE CODE_01DE34           
CODE_01DE31:        20 6A E2      JSR.W CODE_01E26A         
CODE_01DE34:        20 19 DF      JSR.W CODE_01DF19         
CODE_01DE37:        A5 9D         LDA RAM_SpritesLocked     ; \ Return if sprites locked 
CODE_01DE39:        D0 05         BNE Return01DE40          ; / 
CODE_01DE3B:        AD 8F 18      LDA.W $188F               
CODE_01DE3E:        F0 01         BEQ CODE_01DE41           
Return01DE40:       60            RTS                       ; Return 

CODE_01DE41:        B5 C2         LDA RAM_SpriteState,X     
CODE_01DE43:        D0 47         BNE CODE_01DE8C           
CODE_01DE45:        A5 14         LDA RAM_FrameCounterB     
CODE_01DE47:        29 03         AND.B #$03                
CODE_01DE49:        D0 0D         BNE CODE_01DE58           
CODE_01DE4B:        FE 70 15      INC.W $1570,X             
CODE_01DE4E:        BD 70 15      LDA.W $1570,X             
CODE_01DE51:        C9 09         CMP.B #$09                
CODE_01DE53:        D0 03         BNE CODE_01DE58           
CODE_01DE55:        9E 70 15      STZ.W $1570,X             
CODE_01DE58:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01DE5B:        90 2F         BCC CODE_01DE8C           
CODE_01DE5D:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01DE5F:        10 2B         BPL CODE_01DE8C           
CODE_01DE61:        A9 F4         LDA.B #$F4                
CODE_01DE63:        A4 19         LDY RAM_MarioPowerUp      
CODE_01DE65:        F0 02         BEQ CODE_01DE69           
CODE_01DE67:        A9 00         LDA.B #$00                
CODE_01DE69:        18            CLC                       
CODE_01DE6A:        75 D8         ADC RAM_SpriteYLo,X       
CODE_01DE6C:        38            SEC                       
CODE_01DE6D:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01DE6F:        C5 80         CMP $80                   
CODE_01DE71:        B0 19         BCS CODE_01DE8C           
CODE_01DE73:        A9 10         LDA.B #$10                
CODE_01DE75:        85 7D         STA RAM_MarioSpeedY       
CODE_01DE77:        A9 0B         LDA.B #$0B                ; \ Play sound effect 
CODE_01DE79:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01DE7C:        F6 C2         INC RAM_SpriteState,X     
CODE_01DE7E:        BC 70 15      LDY.W $1570,X             
CODE_01DE81:        B9 21 DE      LDA.W DATA_01DE21,Y       
CODE_01DE84:        9D 70 15      STA.W $1570,X             
CODE_01DE87:        A9 10         LDA.B #$10                
CODE_01DE89:        9D 40 15      STA.W $1540,X             
CODE_01DE8C:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01DE8F:        30 1E         BMI Return01DEAF          
CODE_01DE91:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01DE93:        D9 19 DE      CMP.W DATA_01DE19,Y       
CODE_01DE96:        D0 07         BNE CODE_01DE9F           
CODE_01DE98:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01DE9A:        D9 1D DE      CMP.W DATA_01DE1D,Y       
CODE_01DE9D:        F0 11         BEQ CODE_01DEB0           
CODE_01DE9F:        B9 11 DE      LDA.W DATA_01DE11,Y       
CODE_01DEA2:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01DEA4:        B9 15 DE      LDA.W DATA_01DE15,Y       
CODE_01DEA7:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01DEA9:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01DEAC:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
Return01DEAF:       60            RTS                       ; Return 

CODE_01DEB0:        A0 09         LDY.B #$09                
CODE_01DEB2:        B9 C2 00      LDA.W RAM_SpriteState,Y   
CODE_01DEB5:        F0 20         BEQ CODE_01DED7           
CODE_01DEB7:        B9 D8 00      LDA.W RAM_SpriteYLo,Y     
CODE_01DEBA:        18            CLC                       
CODE_01DEBB:        69 04         ADC.B #$04                
CODE_01DEBD:        29 F8         AND.B #$F8                
CODE_01DEBF:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_01DEC2:        B9 E4 00      LDA.W RAM_SpriteXLo,Y     
CODE_01DEC5:        18            CLC                       
CODE_01DEC6:        69 04         ADC.B #$04                
CODE_01DEC8:        29 F8         AND.B #$F8                
CODE_01DECA:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_01DECD:        88            DEY                       
CODE_01DECE:        D0 E2         BNE CODE_01DEB2           
CODE_01DED0:        EE 8F 18      INC.W $188F               
CODE_01DED3:        20 D9 DF      JSR.W CODE_01DFD9         
Return01DED6:       60            RTS                       ; Return 

CODE_01DED7:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01DEDA:        1A            INC A                     
CODE_01DEDB:        29 03         AND.B #$03                
CODE_01DEDD:        A8            TAY                       
CODE_01DEDE:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01DEE1:        80 BC         BRA CODE_01DE9F           


DATA_01DEE3:                      .db $58

DATA_01DEE4:                      .db $59

DATA_01DEE5:                      .db $83

DATA_01DEE6:                      .db $83,$48,$49,$58,$59,$83,$83,$48
                                  .db $49,$34,$35,$83,$83,$24,$25,$34
                                  .db $35,$83,$83,$24,$25,$36,$37,$83
                                  .db $83,$26,$27,$36,$37,$83,$83,$26
                                  .db $27

DATA_01DF07:                      .db $04,$04,$04,$08,$08,$08,$0A,$0A
                                  .db $0A

DATA_01DF10:                      .db $00,$03,$05,$07,$08,$08,$07,$05
                                  .db $03

CODE_01DF19:        BD 40 15      LDA.W $1540,X             
CODE_01DF1C:        4A            LSR                       
CODE_01DF1D:        A8            TAY                       
CODE_01DF1E:        B9 10 DF      LDA.W DATA_01DF10,Y       
CODE_01DF21:        85 00         STA $00                   
CODE_01DF23:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01DF26:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01DF28:        38            SEC                       
CODE_01DF29:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01DF2B:        99 10 03      STA.W $0310,Y             
CODE_01DF2E:        99 00 03      STA.W OAM_DispX,Y         
CODE_01DF31:        99 08 03      STA.W OAM_Tile3DispX,Y    
CODE_01DF34:        18            CLC                       
CODE_01DF35:        69 08         ADC.B #$08                
CODE_01DF37:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_01DF3A:        99 0C 03      STA.W OAM_Tile4DispX,Y    
CODE_01DF3D:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_01DF40:        18            CLC                       
CODE_01DF41:        F0 0B         BEQ CODE_01DF4E           
CODE_01DF43:        4A            LSR                       
CODE_01DF44:        4A            LSR                       
CODE_01DF45:        4A            LSR                       
CODE_01DF46:        4A            LSR                       
CODE_01DF47:        80 04         BRA CODE_01DF4D           

ADDR_01DF49:        18            CLC                       ; \ Unreachable instructions 
ADDR_01DF4A:        6D E9 15      ADC.W $15E9               ; / 
CODE_01DF4D:        4A            LSR                       
CODE_01DF4E:        08            PHP                       
CODE_01DF4F:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01DF51:        38            SEC                       
CODE_01DF52:        E5 00         SBC $00                   
CODE_01DF54:        38            SEC                       
CODE_01DF55:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01DF57:        99 11 03      STA.W $0311,Y             
CODE_01DF5A:        28            PLP                       
CODE_01DF5B:        B0 0F         BCS CODE_01DF6C           
CODE_01DF5D:        99 01 03      STA.W OAM_DispY,Y         
CODE_01DF60:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_01DF63:        18            CLC                       
CODE_01DF64:        69 08         ADC.B #$08                
CODE_01DF66:        99 09 03      STA.W OAM_Tile3DispY,Y    
CODE_01DF69:        99 0D 03      STA.W OAM_Tile4DispY,Y    
CODE_01DF6C:        BD 70 15      LDA.W $1570,X             
CODE_01DF6F:        DA            PHX                       
CODE_01DF70:        48            PHA                       
CODE_01DF71:        0A            ASL                       
CODE_01DF72:        0A            ASL                       
CODE_01DF73:        AA            TAX                       
CODE_01DF74:        BD E3 DE      LDA.W DATA_01DEE3,X       
CODE_01DF77:        99 02 03      STA.W OAM_Tile,Y          
CODE_01DF7A:        BD E4 DE      LDA.W DATA_01DEE4,X       
CODE_01DF7D:        99 06 03      STA.W OAM_Tile2,Y         
CODE_01DF80:        BD E5 DE      LDA.W DATA_01DEE5,X       
CODE_01DF83:        99 0A 03      STA.W OAM_Tile3,Y         
CODE_01DF86:        BD E6 DE      LDA.W DATA_01DEE6,X       
CODE_01DF89:        99 0E 03      STA.W OAM_Tile4,Y         
CODE_01DF8C:        A9 E4         LDA.B #$E4                
CODE_01DF8E:        99 12 03      STA.W $0312,Y             
CODE_01DF91:        FA            PLX                       
CODE_01DF92:        A5 64         LDA $64                   
CODE_01DF94:        1D 07 DF      ORA.W DATA_01DF07,X       
CODE_01DF97:        99 03 03      STA.W OAM_Prop,Y          
CODE_01DF9A:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_01DF9D:        99 0B 03      STA.W OAM_Tile3Prop,Y     
CODE_01DFA0:        99 0F 03      STA.W OAM_Tile4Prop,Y     
CODE_01DFA3:        09 01         ORA.B #$01                
CODE_01DFA5:        99 13 03      STA.W $0313,Y             
CODE_01DFA8:        FA            PLX                       
CODE_01DFA9:        98            TYA                       
CODE_01DFAA:        4A            LSR                       
CODE_01DFAB:        4A            LSR                       
CODE_01DFAC:        A8            TAY                       
CODE_01DFAD:        A9 00         LDA.B #$00                
CODE_01DFAF:        99 60 04      STA.W OAM_TileSize,Y      
CODE_01DFB2:        99 61 04      STA.W $0461,Y             
CODE_01DFB5:        99 62 04      STA.W $0462,Y             
CODE_01DFB8:        99 63 04      STA.W $0463,Y             
CODE_01DFBB:        A9 02         LDA.B #$02                
CODE_01DFBD:        99 64 04      STA.W $0464,Y             
Return01DFC0:       60            RTS                       ; Return 


DATA_01DFC1:                      .db $00,$01,$02,$02,$03,$04,$04,$05
                                  .db $06,$06,$07,$00,$00,$08,$04,$02
                                  .db $08,$06,$03,$08,$07,$01,$08,$05

CODE_01DFD9:        A9 07         LDA.B #$07                
CODE_01DFDB:        85 00         STA $00                   
CODE_01DFDD:        A2 02         LDX.B #$02                
CODE_01DFDF:        86 01         STX $01                   
CODE_01DFE1:        A5 00         LDA $00                   
CODE_01DFE3:        0A            ASL                       
CODE_01DFE4:        65 00         ADC $00                   
CODE_01DFE6:        18            CLC                       
CODE_01DFE7:        65 01         ADC $01                   
CODE_01DFE9:        A8            TAY                       
CODE_01DFEA:        B9 C1 DF      LDA.W DATA_01DFC1,Y       
CODE_01DFED:        A8            TAY                       
CODE_01DFEE:        B9 9A DD      LDA.W DATA_01DD9A,Y       
CODE_01DFF1:        85 02         STA $02                   
CODE_01DFF3:        B9 91 DD      LDA.W DATA_01DD91,Y       
CODE_01DFF6:        85 03         STA $03                   
CODE_01DFF8:        A0 09         LDY.B #$09                
CODE_01DFFA:        B9 D8 00      LDA.W RAM_SpriteYLo,Y     
CODE_01DFFD:        C5 02         CMP $02                   
CODE_01DFFF:        D0 07         BNE CODE_01E008           
CODE_01E001:        B9 E4 00      LDA.W RAM_SpriteXLo,Y     
CODE_01E004:        C5 03         CMP $03                   
CODE_01E006:        F0 05         BEQ CODE_01E00D           
CODE_01E008:        88            DEY                       
CODE_01E009:        C0 01         CPY.B #$01                
CODE_01E00B:        D0 ED         BNE CODE_01DFFA           
CODE_01E00D:        B9 70 15      LDA.W $1570,Y             
CODE_01E010:        95 04         STA $04,X                 
CODE_01E012:        94 07         STY $07,X                 
CODE_01E014:        CA            DEX                       
CODE_01E015:        10 C8         BPL CODE_01DFDF           
CODE_01E017:        A5 04         LDA $04                   
CODE_01E019:        C5 05         CMP $05                   
CODE_01E01B:        D0 18         BNE CODE_01E035           
CODE_01E01D:        C5 06         CMP $06                   
CODE_01E01F:        D0 14         BNE CODE_01E035           
CODE_01E021:        EE 90 18      INC.W $1890               
CODE_01E024:        A9 70         LDA.B #$70                
CODE_01E026:        A4 07         LDY $07                   
CODE_01E028:        99 4C 15      STA.W RAM_DisableInter,Y  
CODE_01E02B:        A4 08         LDY $08                   
CODE_01E02D:        99 4C 15      STA.W RAM_DisableInter,Y  
CODE_01E030:        A4 09         LDY $09                   
CODE_01E032:        99 4C 15      STA.W RAM_DisableInter,Y  
CODE_01E035:        C6 00         DEC $00                   
CODE_01E037:        10 A4         BPL CODE_01DFDD           
CODE_01E039:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01E03C:        A0 29         LDY.B #$29                
CODE_01E03E:        AD 90 18      LDA.W $1890               
CODE_01E041:        8D 20 19      STA.W $1920               
CODE_01E044:        D0 06         BNE CODE_01E04C           
ADDR_01E046:        A9 58         LDA.B #$58                
ADDR_01E048:        8D AB 14      STA.W $14AB               
ADDR_01E04B:        C8            INY                       
CODE_01E04C:        8C FC 1D      STY.W $1DFC               ; / Play sound effect 
Return01E04F:       60            RTS                       ; Return 

InitFireball:       B5 D8         LDA RAM_SpriteYLo,X       
CODE_01E052:        9D 28 15      STA.W $1528,X             
CODE_01E055:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01E058:        9D 1C 15      STA.W $151C,X             
CODE_01E05B:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01E05D:        18            CLC                       
CODE_01E05E:        69 10         ADC.B #$10                
CODE_01E060:        95 D8         STA RAM_SpriteYLo,X       
CODE_01E062:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01E065:        69 00         ADC.B #$00                
CODE_01E067:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01E06A:        20 40 91      JSR.W CODE_019140         
CODE_01E06D:        BD 4A 16      LDA.W $164A,X             
CODE_01E070:        F0 E9         BEQ CODE_01E05B           
CODE_01E072:        20 E2 E0      JSR.W CODE_01E0E2         
CODE_01E075:        A9 20         LDA.B #$20                
CODE_01E077:        9D 40 15      STA.W $1540,X             
Return01E07A:       60            RTS                       ; Return 


DATA_01E07B:                      .db $F0,$DC,$D0,$C8,$C0,$B8,$B2,$AC
                                  .db $A6,$A0,$9A,$96,$92,$8C,$88,$84
                                  .db $80,$04,$08,$0C,$10,$14

DATA_01E091:                      .db $70,$20

Fireballs:          9E D0 15      STZ.W $15D0,X             
CODE_01E096:        BD 40 15      LDA.W $1540,X             
CODE_01E099:        F0 0C         BEQ CODE_01E0A7           
CODE_01E09B:        9D D0 15      STA.W $15D0,X             
CODE_01E09E:        3A            DEC A                     
CODE_01E09F:        D0 05         BNE Return01E0A6          
CODE_01E0A1:        A9 27         LDA.B #$27                ; \ Play sound effect 
CODE_01E0A3:        8D FC 1D      STA.W $1DFC               ; / 
Return01E0A6:       60            RTS                       ; Return 

CODE_01E0A7:        A5 9D         LDA RAM_SpritesLocked     
CODE_01E0A9:        F0 03         BEQ CODE_01E0AE           
CODE_01E0AB:        4C 2D E1      JMP.W CODE_01E12D         

CODE_01E0AE:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01E0B1:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01E0B4:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01E0B7:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01E0BA:        29 7F         AND.B #$7F                
CODE_01E0BC:        B4 AA         LDY RAM_SpriteSpeedY,X    
CODE_01E0BE:        30 08         BMI CODE_01E0C8           
CODE_01E0C0:        FE 02 16      INC.W $1602,X             
CODE_01E0C3:        FE 02 16      INC.W $1602,X             
CODE_01E0C6:        09 80         ORA.B #$80                
CODE_01E0C8:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01E0CB:        20 40 91      JSR.W CODE_019140         
CODE_01E0CE:        BD 4A 16      LDA.W $164A,X             
CODE_01E0D1:        F0 33         BEQ CODE_01E106           
CODE_01E0D3:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01E0D5:        30 2F         BMI CODE_01E106           
CODE_01E0D7:        22 F9 AC 01   JSL.L GetRand             
CODE_01E0DB:        29 3F         AND.B #$3F                
CODE_01E0DD:        69 60         ADC.B #$60                
CODE_01E0DF:        9D 40 15      STA.W $1540,X             
CODE_01E0E2:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01E0E4:        38            SEC                       
CODE_01E0E5:        FD 28 15      SBC.W $1528,X             
CODE_01E0E8:        85 00         STA $00                   
CODE_01E0EA:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01E0ED:        FD 1C 15      SBC.W $151C,X             
CODE_01E0F0:        4A            LSR                       
CODE_01E0F1:        66 00         ROR $00                   
CODE_01E0F3:        A5 00         LDA $00                   
CODE_01E0F5:        4A            LSR                       
CODE_01E0F6:        4A            LSR                       
CODE_01E0F7:        4A            LSR                       
CODE_01E0F8:        A8            TAY                       
CODE_01E0F9:        B9 7B E0      LDA.W DATA_01E07B,Y       
CODE_01E0FC:        30 05         BMI CODE_01E103           
ADDR_01E0FE:        9D 64 15      STA.W $1564,X             
ADDR_01E101:        A9 80         LDA.B #$80                
CODE_01E103:        95 AA         STA RAM_SpriteSpeedY,X    
Return01E105:       60            RTS                       ; Return 

CODE_01E106:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01E109:        A5 14         LDA RAM_FrameCounterB     
CODE_01E10B:        29 07         AND.B #$07                
CODE_01E10D:        15 C2         ORA RAM_SpriteState,X     
CODE_01E10F:        D0 04         BNE CODE_01E115           
CODE_01E111:        22 DF 85 02   JSL.L CODE_0285DF         
CODE_01E115:        BD 64 15      LDA.W $1564,X             
CODE_01E118:        D0 10         BNE CODE_01E12A           
CODE_01E11A:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01E11C:        30 07         BMI CODE_01E125           
CODE_01E11E:        B4 C2         LDY RAM_SpriteState,X     
CODE_01E120:        D9 91 E0      CMP.W DATA_01E091,Y       
CODE_01E123:        B0 05         BCS CODE_01E12A           
CODE_01E125:        18            CLC                       
CODE_01E126:        69 02         ADC.B #$02                
CODE_01E128:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01E12A:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01E12D:        B5 C2         LDA RAM_SpriteState,X     
CODE_01E12F:        F0 67         BEQ CODE_01E198           
CODE_01E131:        A4 9D         LDY RAM_SpritesLocked     
CODE_01E133:        D0 2F         BNE CODE_01E164           
CODE_01E135:        BD 88 15      LDA.W RAM_SprObjStatus,X  ; \ Branch if not on ground 
CODE_01E138:        29 04         AND.B #$04                ;  | 
CODE_01E13A:        F0 15         BEQ CODE_01E151           ; / 
CODE_01E13C:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_01E13E:        BD 58 15      LDA.W $1558,X             
CODE_01E141:        F0 07         BEQ CODE_01E14A           
CODE_01E143:        C9 01         CMP.B #$01                
CODE_01E145:        D0 08         BNE CODE_01E14F           
CODE_01E147:        4C CB 9A      JMP.W CODE_019ACB         

CODE_01E14A:        A9 80         LDA.B #$80                
CODE_01E14C:        9D 58 15      STA.W $1558,X             
CODE_01E14F:        80 13         BRA CODE_01E164           

CODE_01E151:        8A            TXA                       
CODE_01E152:        0A            ASL                       
CODE_01E153:        0A            ASL                       
CODE_01E154:        18            CLC                       
CODE_01E155:        65 13         ADC RAM_FrameCounter      
CODE_01E157:        A0 F0         LDY.B #$F0                
CODE_01E159:        29 04         AND.B #$04                
CODE_01E15B:        F0 02         BEQ CODE_01E15F           
CODE_01E15D:        A0 10         LDY.B #$10                
CODE_01E15F:        94 B6         STY RAM_SpriteSpeedX,X    
CODE_01E161:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01E164:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01E166:        C9 F0         CMP.B #$F0                
CODE_01E168:        90 03         BCC CODE_01E16D           
ADDR_01E16A:        9E C8 14      STZ.W $14C8,X             
CODE_01E16D:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01E170:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01E173:        DA            PHX                       
CODE_01E174:        A5 14         LDA RAM_FrameCounterB     
CODE_01E176:        29 0C         AND.B #$0C                
CODE_01E178:        4A            LSR                       
CODE_01E179:        6D E9 15      ADC.W $15E9               
CODE_01E17C:        4A            LSR                       
CODE_01E17D:        29 03         AND.B #$03                
CODE_01E17F:        AA            TAX                       
CODE_01E180:        BD 90 E1      LDA.W BowserFlameTiles,X  
CODE_01E183:        99 02 03      STA.W OAM_Tile,Y          
CODE_01E186:        BD 94 E1      LDA.W DATA_01E194,X       
CODE_01E189:        05 64         ORA $64                   
CODE_01E18B:        99 03 03      STA.W OAM_Prop,Y          
CODE_01E18E:        FA            PLX                       
Return01E18F:       60            RTS                       ; Return 


BowserFlameTiles:                 .db $2A,$2C,$2A,$2C

DATA_01E194:                      .db $05,$05,$45,$45

CODE_01E198:        A9 01         LDA.B #$01                
CODE_01E19A:        20 F3 9C      JSR.W SubSprGfx0Entry0    
CODE_01E19D:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01E19F:        A9 08 00      LDA.W #$0008              
CODE_01E1A2:        0A            ASL                       
CODE_01E1A3:        0A            ASL                       
CODE_01E1A4:        0A            ASL                       
CODE_01E1A5:        0A            ASL                       
CODE_01E1A6:        0A            ASL                       
CODE_01E1A7:        18            CLC                       
CODE_01E1A8:        69 00 85      ADC.W #$8500              
CODE_01E1AB:        8D 8B 0D      STA.W $0D8B               
CODE_01E1AE:        18            CLC                       
CODE_01E1AF:        69 00 02      ADC.W #$0200              
CODE_01E1B2:        8D 95 0D      STA.W $0D95               
CODE_01E1B5:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return01E1B7:       60            RTS                       ; Return 

InitKeyHole:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01E1BA:        18            CLC                       
CODE_01E1BB:        69 08         ADC.B #$08                
CODE_01E1BD:        95 E4         STA RAM_SpriteXLo,X       
CODE_01E1BF:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01E1C2:        69 00         ADC.B #$00                
CODE_01E1C4:        9D E0 14      STA.W RAM_SpriteXHi,X     
Return01E1C7:       60            RTS                       ; Return 

Keyhole:            A0 0B         LDY.B #$0B                
CODE_01E1CA:        B9 C8 14      LDA.W $14C8,Y             
CODE_01E1CD:        C9 08         CMP.B #$08                
CODE_01E1CF:        90 07         BCC CODE_01E1D8           
CODE_01E1D1:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01E1D4:        C9 80         CMP.B #$80                
CODE_01E1D6:        F0 03         BEQ CODE_01E1DB           
CODE_01E1D8:        88            DEY                       
CODE_01E1D9:        10 EF         BPL CODE_01E1CA           
CODE_01E1DB:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01E1DE:        F0 05         BEQ CODE_01E1E5           
CODE_01E1E0:        AD 1C 19      LDA.W $191C               
CODE_01E1E3:        D0 08         BNE CODE_01E1ED           
CODE_01E1E5:        98            TYA                       
CODE_01E1E6:        9D 1C 15      STA.W $151C,X             
CODE_01E1E9:        30 4F         BMI CODE_01E23A           
CODE_01E1EB:        80 06         BRA CODE_01E1F3           

CODE_01E1ED:        22 64 B6 03   JSL.L GetMarioClipping    
CODE_01E1F1:        80 0E         BRA CODE_01E201           

CODE_01E1F3:        B9 C8 14      LDA.W $14C8,Y             
CODE_01E1F6:        C9 0B         CMP.B #$0B                
CODE_01E1F8:        D0 40         BNE CODE_01E23A           
CODE_01E1FA:        DA            PHX                       
CODE_01E1FB:        BB            TYX                       
CODE_01E1FC:        22 E5 B6 03   JSL.L GetSpriteClippingB  
CODE_01E200:        FA            PLX                       
CODE_01E201:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_01E205:        22 2B B7 03   JSL.L CheckForContact     
CODE_01E209:        90 2F         BCC CODE_01E23A           
CODE_01E20B:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_01E20E:        D0 2A         BNE CODE_01E23A           
CODE_01E210:        A9 30         LDA.B #$30                
CODE_01E212:        8D 34 14      STA.W $1434               
CODE_01E215:        A9 10         LDA.B #$10                
CODE_01E217:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_01E21A:        EE FB 13      INC.W $13FB               
CODE_01E21D:        E6 9D         INC RAM_SpritesLocked     
CODE_01E21F:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01E222:        8D 37 14      STA.W $1437               
CODE_01E225:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01E227:        8D 36 14      STA.W RAM_KeyHolePos1     
CODE_01E22A:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01E22D:        8D 39 14      STA.W $1439               
CODE_01E230:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01E232:        8D 38 14      STA.W RAM_KeyHolePos2     
CODE_01E235:        A9 30         LDA.B #$30                
CODE_01E237:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_01E23A:        20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01E23D:        A5 00         LDA $00                   
CODE_01E23F:        99 00 03      STA.W OAM_DispX,Y         
CODE_01E242:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_01E245:        A5 01         LDA $01                   
CODE_01E247:        99 01 03      STA.W OAM_DispY,Y         
CODE_01E24A:        18            CLC                       
CODE_01E24B:        69 08         ADC.B #$08                
CODE_01E24D:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_01E250:        A9 EB         LDA.B #$EB                
CODE_01E252:        99 02 03      STA.W OAM_Tile,Y          
CODE_01E255:        A9 FB         LDA.B #$FB                
CODE_01E257:        99 06 03      STA.W OAM_Tile2,Y         
CODE_01E25A:        A9 30         LDA.B #$30                
CODE_01E25C:        99 03 03      STA.W OAM_Prop,Y          
CODE_01E25F:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_01E262:        A0 00         LDY.B #$00                
CODE_01E264:        A9 01         LDA.B #$01                
CODE_01E266:        20 BB B7      JSR.W FinishOAMWriteRt    
Return01E269:       60            RTS                       ; Return 

CODE_01E26A:        A5 13         LDA RAM_FrameCounter      
CODE_01E26C:        29 3F         AND.B #$3F                
CODE_01E26E:        D0 0B         BNE CODE_01E27B           
CODE_01E270:        AD 90 18      LDA.W $1890               
CODE_01E273:        F0 06         BEQ CODE_01E27B           
CODE_01E275:        CE 90 18      DEC.W $1890               
CODE_01E278:        20 81 E2      JSR.W CODE_01E281         
CODE_01E27B:        A9 01         LDA.B #$01                
CODE_01E27D:        8D B8 18      STA.W $18B8               
Return01E280:       60            RTS                       ; Return 

CODE_01E281:        A0 07         LDY.B #$07                
CODE_01E283:        B9 92 18      LDA.W $1892,Y             
CODE_01E286:        F0 04         BEQ CODE_01E28C           
CODE_01E288:        88            DEY                       
CODE_01E289:        10 F8         BPL CODE_01E283           
Return01E28B:       60            RTS                       ; Return 

CODE_01E28C:        A9 01         LDA.B #$01                
CODE_01E28E:        99 92 18      STA.W $1892,Y             
CODE_01E291:        A9 00         LDA.B #$00                
CODE_01E293:        99 02 1E      STA.W $1E02,Y             
CODE_01E296:        A9 01         LDA.B #$01                
CODE_01E298:        99 2A 1E      STA.W $1E2A,Y             
CODE_01E29B:        A9 18         LDA.B #$18                
CODE_01E29D:        99 16 1E      STA.W $1E16,Y             
CODE_01E2A0:        A9 00         LDA.B #$00                
CODE_01E2A2:        99 3E 1E      STA.W $1E3E,Y             
CODE_01E2A5:        A9 01         LDA.B #$01                
CODE_01E2A7:        99 66 1E      STA.W $1E66,Y             
CODE_01E2AA:        A9 10         LDA.B #$10                
CODE_01E2AC:        99 52 1E      STA.W $1E52,Y             
Return01E2AF:       60            RTS                       ; Return 


DATA_01E2B0:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $13,$14,$15,$16,$17,$18,$19

MontyMole:          20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01E2D2:        B5 C2         LDA RAM_SpriteState,X     
CODE_01E2D4:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs01E2D8:            E0 E2      .dw CODE_01E2E0           
                       09 E3      .dw CODE_01E309           
                       7F E3      .dw CODE_01E37F           
                       93 E3      .dw CODE_01E393           

CODE_01E2E0:        20 30 AD      JSR.W SubHorizPos         
CODE_01E2E3:        A5 0F         LDA $0F                   
CODE_01E2E5:        18            CLC                       
CODE_01E2E6:        69 60         ADC.B #$60                
CODE_01E2E8:        C9 C0         CMP.B #$C0                
CODE_01E2EA:        B0 19         BCS CODE_01E305           
CODE_01E2EC:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_01E2EF:        D0 14         BNE CODE_01E305           
CODE_01E2F1:        F6 C2         INC RAM_SpriteState,X     
CODE_01E2F3:        AC B3 0D      LDY.W $0DB3               
CODE_01E2F6:        B9 11 1F      LDA.W $1F11,Y             
CODE_01E2F9:        A8            TAY                       
CODE_01E2FA:        A9 68         LDA.B #$68                
CODE_01E2FC:        C0 01         CPY.B #$01                
CODE_01E2FE:        F0 02         BEQ CODE_01E302           
CODE_01E300:        A9 20         LDA.B #$20                
CODE_01E302:        9D 40 15      STA.W $1540,X             
CODE_01E305:        20 65 A3      JSR.W GetDrawInfoBnk1     
Return01E308:       60            RTS                       ; Return 

CODE_01E309:        BD 40 15      LDA.W $1540,X             
CODE_01E30C:        1D D0 15      ORA.W $15D0,X             
CODE_01E30F:        D0 32         BNE CODE_01E343           
CODE_01E311:        F6 C2         INC RAM_SpriteState,X     
CODE_01E313:        A9 B0         LDA.B #$B0                
CODE_01E315:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01E317:        20 CB 80      JSR.W IsSprOffScreen      
CODE_01E31A:        D0 04         BNE CODE_01E320           
CODE_01E31C:        A8            TAY                       
CODE_01E31D:        20 E1 99      JSR.W CODE_0199E1         
CODE_01E320:        20 7C 85      JSR.W FaceMario           
CODE_01E323:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01E325:        C9 4E         CMP.B #$4E                
CODE_01E327:        D0 1A         BNE CODE_01E343           
CODE_01E329:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $9A = Sprite X position 
CODE_01E32B:        85 9A         STA RAM_BlockYLo          ;  | for block creation 
CODE_01E32D:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_01E330:        85 9B         STA RAM_BlockYHi          ; / 
CODE_01E332:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $98 = Sprite Y position 
CODE_01E334:        85 98         STA RAM_BlockXLo          ;  | for block creation 
CODE_01E336:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_01E339:        85 99         STA RAM_BlockXHi          ; / 
CODE_01E33B:        A9 08         LDA.B #$08                ; \ Block to generate = Mole hole 
CODE_01E33D:        85 9C         STA RAM_BlockBlock        ; / 
CODE_01E33F:        22 B0 BE 00   JSL.L GenerateTile        
CODE_01E343:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01E345:        C9 4D         CMP.B #$4D                
CODE_01E347:        D0 1A         BNE CODE_01E363           
CODE_01E349:        A5 14         LDA RAM_FrameCounterB     
CODE_01E34B:        4A            LSR                       
CODE_01E34C:        4A            LSR                       
CODE_01E34D:        4A            LSR                       
CODE_01E34E:        4A            LSR                       
CODE_01E34F:        29 01         AND.B #$01                
CODE_01E351:        A8            TAY                       
CODE_01E352:        B9 5F E3      LDA.W DATA_01E35F,Y       
CODE_01E355:        9D 02 16      STA.W $1602,X             
CODE_01E358:        B9 61 E3      LDA.W DATA_01E361,Y       
CODE_01E35B:        20 F3 9C      JSR.W SubSprGfx0Entry0    
Return01E35E:       60            RTS                       ; Return 


DATA_01E35F:                      .db $01,$02

DATA_01E361:                      .db $00,$05

CODE_01E363:        A5 14         LDA RAM_FrameCounterB     
CODE_01E365:        0A            ASL                       
CODE_01E366:        0A            ASL                       
CODE_01E367:        29 C0         AND.B #$C0                
CODE_01E369:        09 31         ORA.B #$31                
CODE_01E36B:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01E36E:        A9 03         LDA.B #$03                
CODE_01E370:        9D 02 16      STA.W $1602,X             
CODE_01E373:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01E376:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01E379:        29 3F         AND.B #$3F                
CODE_01E37B:        9D F6 15      STA.W RAM_SpritePal,X     
Return01E37E:       60            RTS                       ; Return 

CODE_01E37F:        20 EF E3      JSR.W CODE_01E3EF         
CODE_01E382:        A9 02         LDA.B #$02                
CODE_01E384:        9D 02 16      STA.W $1602,X             
CODE_01E387:        20 0E 80      JSR.W IsOnGround          
CODE_01E38A:        F0 02         BEQ Return01E38E          
CODE_01E38C:        F6 C2         INC RAM_SpriteState,X     
Return01E38E:       60            RTS                       ; Return 


DATA_01E38F:                      .db $10,$F0

DATA_01E391:                      .db $18,$E8

CODE_01E393:        20 EF E3      JSR.W CODE_01E3EF         
CODE_01E396:        BD 1C 15      LDA.W $151C,X             
CODE_01E399:        D0 2C         BNE CODE_01E3C7           
CODE_01E39B:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01E39E:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01E3A1:        22 F9 AC 01   JSL.L GetRand             
CODE_01E3A5:        29 01         AND.B #$01                
CODE_01E3A7:        D0 1D         BNE Return01E3C6          
CODE_01E3A9:        20 7C 85      JSR.W FaceMario           
CODE_01E3AC:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01E3AE:        D9 91 E3      CMP.W DATA_01E391,Y       
CODE_01E3B1:        F0 13         BEQ Return01E3C6          
CODE_01E3B3:        18            CLC                       
CODE_01E3B4:        79 B4 EB      ADC.W DATA_01EBB4,Y       
CODE_01E3B7:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01E3B9:        98            TYA                       
CODE_01E3BA:        4A            LSR                       
CODE_01E3BB:        6A            ROR                       
CODE_01E3BC:        55 B6         EOR RAM_SpriteSpeedX,X    
CODE_01E3BE:        10 06         BPL Return01E3C6          
CODE_01E3C0:        20 4E 80      JSR.W CODE_01804E         
CODE_01E3C3:        20 5F 8E      JSR.W SetAnimationFrame   
Return01E3C6:       60            RTS                       ; Return 

CODE_01E3C7:        20 0E 80      JSR.W IsOnGround          
CODE_01E3CA:        F0 1D         BEQ CODE_01E3E9           
CODE_01E3CC:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01E3CF:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01E3D2:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01E3D5:        B9 8F E3      LDA.W DATA_01E38F,Y       
CODE_01E3D8:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01E3DA:        BD 58 15      LDA.W $1558,X             
CODE_01E3DD:        D0 09         BNE Return01E3E8          
CODE_01E3DF:        A9 50         LDA.B #$50                
CODE_01E3E1:        9D 58 15      STA.W $1558,X             
CODE_01E3E4:        A9 D8         LDA.B #$D8                
CODE_01E3E6:        95 AA         STA RAM_SpriteSpeedY,X    
Return01E3E8:       60            RTS                       ; Return 

CODE_01E3E9:        A9 01         LDA.B #$01                
CODE_01E3EB:        9D 02 16      STA.W $1602,X             
Return01E3EE:       60            RTS                       ; Return 

CODE_01E3EF:        A5 64         LDA $64                   
CODE_01E3F1:        48            PHA                       
CODE_01E3F2:        BD 40 15      LDA.W $1540,X             
CODE_01E3F5:        F0 04         BEQ CODE_01E3FB           
ADDR_01E3F7:        A9 10         LDA.B #$10                
ADDR_01E3F9:        85 64         STA $64                   
CODE_01E3FB:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01E3FE:        68            PLA                       
CODE_01E3FF:        85 64         STA $64                   
CODE_01E401:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01E403:        D0 17         BNE CODE_01E41C           ; / 
CODE_01E405:        20 C1 8F      JSR.W SubSprSpr+MarioSpr  
CODE_01E408:        20 32 90      JSR.W SubUpdateSprPos     
CODE_01E40B:        20 0E 80      JSR.W IsOnGround          
CODE_01E40E:        F0 03         BEQ CODE_01E413           
CODE_01E410:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_01E413:        20 08 80      JSR.W IsTouchingObjSide   
CODE_01E416:        F0 03         BEQ Return01E41B          
CODE_01E418:        20 98 90      JSR.W FlipSpriteDir       
Return01E41B:       60            RTS                       ; Return 

CODE_01E41C:        68            PLA                       
CODE_01E41D:        68            PLA                       
Return01E41E:       60            RTS                       ; Return 


DATA_01E41F:                      .db $08,$F8,$02,$03,$04,$04,$04,$04
                                  .db $04,$04,$04,$04

DryBonesAndBeetle:  BD C8 14      LDA.W $14C8,X             
CODE_01E42E:        C9 08         CMP.B #$08                
CODE_01E430:        F0 0C         BEQ CODE_01E43E           
CODE_01E432:        1E F6 15      ASL.W RAM_SpritePal,X     
CODE_01E435:        38            SEC                       
CODE_01E436:        7E F6 15      ROR.W RAM_SpritePal,X     
CODE_01E439:        4C BF E5      JMP.W CODE_01E5BF         


DATA_01E43C:                      .db $08,$F8

CODE_01E43E:        BD 34 15      LDA.W $1534,X             
CODE_01E441:        F0 7D         BEQ CODE_01E4C0           
CODE_01E443:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01E446:        BC 40 15      LDY.W $1540,X             
CODE_01E449:        D0 08         BNE CODE_01E453           
CODE_01E44B:        9E 34 15      STZ.W $1534,X             
CODE_01E44E:        5A            PHY                       
CODE_01E44F:        20 7C 85      JSR.W FaceMario           
CODE_01E452:        7A            PLY                       
CODE_01E453:        A9 48         LDA.B #$48                
CODE_01E455:        C0 10         CPY.B #$10                
CODE_01E457:        90 06         BCC CODE_01E45F           
CODE_01E459:        C0 F0         CPY.B #$F0                
CODE_01E45B:        B0 02         BCS CODE_01E45F           
CODE_01E45D:        A9 2E         LDA.B #$2E                
CODE_01E45F:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01E462:        99 02 03      STA.W OAM_Tile,Y          
CODE_01E465:        98            TYA                       
CODE_01E466:        18            CLC                       
CODE_01E467:        69 04         ADC.B #$04                
CODE_01E469:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_01E46C:        DA            PHX                       
CODE_01E46D:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01E470:        AA            TAX                       
CODE_01E471:        B9 00 03      LDA.W OAM_DispX,Y         
CODE_01E474:        18            CLC                       
CODE_01E475:        7D 3C E4      ADC.W DATA_01E43C,X       
CODE_01E478:        FA            PLX                       
CODE_01E479:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_01E47C:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_01E47F:        99 05 03      STA.W OAM_Tile2DispY,Y    
CODE_01E482:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_01E485:        99 07 03      STA.W OAM_Tile2Prop,Y     
CODE_01E488:        B9 02 03      LDA.W OAM_Tile,Y          
CODE_01E48B:        3A            DEC A                     
CODE_01E48C:        99 06 03      STA.W OAM_Tile2,Y         
CODE_01E48F:        BD 40 15      LDA.W $1540,X             
CODE_01E492:        F0 18         BEQ CODE_01E4AC           
CODE_01E494:        C9 40         CMP.B #$40                
CODE_01E496:        B0 14         BCS CODE_01E4AC           
CODE_01E498:        4A            LSR                       
CODE_01E499:        4A            LSR                       
CODE_01E49A:        08            PHP                       
CODE_01E49B:        B9 00 03      LDA.W OAM_DispX,Y         
CODE_01E49E:        69 00         ADC.B #$00                
CODE_01E4A0:        99 00 03      STA.W OAM_DispX,Y         
CODE_01E4A3:        28            PLP                       
CODE_01E4A4:        B9 04 03      LDA.W OAM_Tile2DispX,Y    
CODE_01E4A7:        69 00         ADC.B #$00                
CODE_01E4A9:        99 04 03      STA.W OAM_Tile2DispX,Y    
CODE_01E4AC:        A0 02         LDY.B #$02                
CODE_01E4AE:        A9 01         LDA.B #$01                
CODE_01E4B0:        20 BB B7      JSR.W FinishOAMWriteRt    
CODE_01E4B3:        20 32 90      JSR.W SubUpdateSprPos     
CODE_01E4B6:        20 0E 80      JSR.W IsOnGround          
CODE_01E4B9:        F0 04         BEQ Return01E4BF          
CODE_01E4BB:        74 AA         STZ RAM_SpriteSpeedY,X    ; \ Sprite Speed = 0 
CODE_01E4BD:        74 B6         STZ RAM_SpriteSpeedX,X    ; / 
Return01E4BF:       60            RTS                       ; Return 

CODE_01E4C0:        A5 9D         LDA RAM_SpritesLocked     
CODE_01E4C2:        1D 3E 16      ORA.W $163E,X             
CODE_01E4C5:        F0 03         BEQ CODE_01E4CA           
CODE_01E4C7:        4C B6 E5      JMP.W CODE_01E5B6         

CODE_01E4CA:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01E4CD:        B9 1F E4      LDA.W DATA_01E41F,Y       
CODE_01E4D0:        5D B8 15      EOR.W $15B8,X             
CODE_01E4D3:        0A            ASL                       
CODE_01E4D4:        B9 1F E4      LDA.W DATA_01E41F,Y       
CODE_01E4D7:        90 04         BCC CODE_01E4DD           
CODE_01E4D9:        18            CLC                       
CODE_01E4DA:        7D B8 15      ADC.W $15B8,X             
CODE_01E4DD:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01E4DF:        BD 40 15      LDA.W $1540,X             
CODE_01E4E2:        D0 09         BNE CODE_01E4ED           
CODE_01E4E4:        98            TYA                       
CODE_01E4E5:        1A            INC A                     
CODE_01E4E6:        3D 88 15      AND.W RAM_SprObjStatus,X  ; \ Branch if not touching object 
CODE_01E4E9:        29 03         AND.B #$03                ;  | 
CODE_01E4EB:        F0 02         BEQ CODE_01E4EF           ; / 
CODE_01E4ED:        74 B6         STZ RAM_SpriteSpeedX,X    
CODE_01E4EF:        20 14 80      JSR.W IsTouchingCeiling   
CODE_01E4F2:        F0 02         BEQ CODE_01E4F6           
ADDR_01E4F4:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_01E4F6:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01E4F9:        20 32 90      JSR.W SubUpdateSprPos     
CODE_01E4FC:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01E4FE:        C9 31         CMP.B #$31                
CODE_01E500:        D0 1C         BNE CODE_01E51E           
CODE_01E502:        BD 40 15      LDA.W $1540,X             
CODE_01E505:        F0 3B         BEQ CODE_01E542           
CODE_01E507:        A0 00         LDY.B #$00                
CODE_01E509:        C9 70         CMP.B #$70                
CODE_01E50B:        B0 0B         BCS CODE_01E518           
CODE_01E50D:        C8            INY                       
CODE_01E50E:        C8            INY                       
CODE_01E50F:        C9 08         CMP.B #$08                
CODE_01E511:        90 05         BCC CODE_01E518           
CODE_01E513:        C9 68         CMP.B #$68                
CODE_01E515:        B0 01         BCS CODE_01E518           
CODE_01E517:        C8            INY                       
CODE_01E518:        98            TYA                       
CODE_01E519:        9D 02 16      STA.W $1602,X             
CODE_01E51C:        80 45         BRA CODE_01E563           

CODE_01E51E:        C9 30         CMP.B #$30                
CODE_01E520:        F0 0B         BEQ CODE_01E52D           
CODE_01E522:        C9 32         CMP.B #$32                
CODE_01E524:        D0 1C         BNE CODE_01E542           
CODE_01E526:        AD BF 13      LDA.W $13BF               
CODE_01E529:        C9 31         CMP.B #$31                
CODE_01E52B:        D0 15         BNE CODE_01E542           
CODE_01E52D:        BD 40 15      LDA.W $1540,X             
CODE_01E530:        F0 10         BEQ CODE_01E542           
CODE_01E532:        C9 01         CMP.B #$01                
CODE_01E534:        D0 04         BNE CODE_01E53A           
CODE_01E536:        22 4E C4 03   JSL.L CODE_03C44E         
CODE_01E53A:        A9 02         LDA.B #$02                
CODE_01E53C:        9D 02 16      STA.W $1602,X             
CODE_01E53F:        4C B6 E5      JMP.W CODE_01E5B6         

CODE_01E542:        20 0E 80      JSR.W IsOnGround          
CODE_01E545:        F0 1C         BEQ CODE_01E563           
CODE_01E547:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_01E54A:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01E54D:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01E54F:        C9 32         CMP.B #$32                
CODE_01E551:        D0 04         BNE CODE_01E557           
CODE_01E553:        74 C2         STZ RAM_SpriteState,X     
CODE_01E555:        80 0A         BRA CODE_01E561           

CODE_01E557:        BD 70 15      LDA.W $1570,X             
CODE_01E55A:        29 7F         AND.B #$7F                
CODE_01E55C:        D0 03         BNE CODE_01E561           
CODE_01E55E:        20 7C 85      JSR.W FaceMario           
CODE_01E561:        80 18         BRA CODE_01E57B           

CODE_01E563:        9E 70 15      STZ.W $1570,X             
CODE_01E566:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01E568:        C9 32         CMP.B #$32                
CODE_01E56A:        D0 0F         BNE CODE_01E57B           
CODE_01E56C:        B5 C2         LDA RAM_SpriteState,X     
CODE_01E56E:        D0 0B         BNE CODE_01E57B           
CODE_01E570:        F6 C2         INC RAM_SpriteState,X     
CODE_01E572:        20 98 90      JSR.W FlipSpriteDir       
CODE_01E575:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01E578:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01E57B:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01E57D:        C9 31         CMP.B #$31                
CODE_01E57F:        D0 17         BNE CODE_01E598           
CODE_01E581:        A5 13         LDA RAM_FrameCounter      
CODE_01E583:        4A            LSR                       
CODE_01E584:        90 03         BCC CODE_01E589           
CODE_01E586:        FE 28 15      INC.W $1528,X             
CODE_01E589:        BD 28 15      LDA.W $1528,X             
CODE_01E58C:        D0 28         BNE CODE_01E5B6           
CODE_01E58E:        FE 28 15      INC.W $1528,X             
CODE_01E591:        A9 A0         LDA.B #$A0                
CODE_01E593:        9D 40 15      STA.W $1540,X             
CODE_01E596:        80 1E         BRA CODE_01E5B6           

CODE_01E598:        C9 30         CMP.B #$30                
CODE_01E59A:        F0 0B         BEQ CODE_01E5A7           
CODE_01E59C:        C9 32         CMP.B #$32                
CODE_01E59E:        D0 16         BNE CODE_01E5B6           
CODE_01E5A0:        AD BF 13      LDA.W $13BF               
CODE_01E5A3:        C9 31         CMP.B #$31                
CODE_01E5A5:        D0 0F         BNE CODE_01E5B6           
CODE_01E5A7:        BD 70 15      LDA.W $1570,X             
CODE_01E5AA:        18            CLC                       
CODE_01E5AB:        69 40         ADC.B #$40                
CODE_01E5AD:        29 7F         AND.B #$7F                
CODE_01E5AF:        D0 05         BNE CODE_01E5B6           
CODE_01E5B1:        A9 3F         LDA.B #$3F                
CODE_01E5B3:        9D 40 15      STA.W $1540,X             
CODE_01E5B6:        20 C4 E5      JSR.W CODE_01E5C4         
CODE_01E5B9:        20 0D A4      JSR.W SubSprSprInteract   
CODE_01E5BC:        20 89 90      JSR.W FlipIfTouchingObj   
CODE_01E5BF:        22 90 C3 03   JSL.L CODE_03C390         
Return01E5C3:       60            RTS                       ; Return 

CODE_01E5C4:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01E5C7:        90 47         BCC Return01E610          
CODE_01E5C9:        A5 D3         LDA $D3                   
CODE_01E5CB:        18            CLC                       
CODE_01E5CC:        69 14         ADC.B #$14                
CODE_01E5CE:        D5 D8         CMP RAM_SpriteYLo,X       
CODE_01E5D0:        10 32         BPL CODE_01E604           
CODE_01E5D2:        AD 97 16      LDA.W $1697               
CODE_01E5D5:        D0 04         BNE CODE_01E5DB           
CODE_01E5D7:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01E5D9:        30 29         BMI CODE_01E604           
CODE_01E5DB:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01E5DD:        C9 31         CMP.B #$31                
CODE_01E5DF:        D0 0A         BNE CODE_01E5EB           
CODE_01E5E1:        BD 40 15      LDA.W $1540,X             
CODE_01E5E4:        38            SEC                       
CODE_01E5E5:        E9 08         SBC.B #$08                
CODE_01E5E7:        C9 60         CMP.B #$60                
CODE_01E5E9:        90 19         BCC CODE_01E604           
CODE_01E5EB:        20 46 AB      JSR.W CODE_01AB46         
CODE_01E5EE:        22 99 AB 01   JSL.L DisplayContactGfx   
CODE_01E5F2:        A9 07         LDA.B #$07                ; \ Play sound effect 
CODE_01E5F4:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01E5F7:        22 33 AA 01   JSL.L BoostMarioSpeed     
CODE_01E5FB:        FE 34 15      INC.W $1534,X             
CODE_01E5FE:        A9 FF         LDA.B #$FF                
CODE_01E600:        9D 40 15      STA.W $1540,X             
Return01E603:       60            RTS                       ; Return 

CODE_01E604:        22 B7 F5 00   JSL.L HurtMario           
CODE_01E608:        AD 97 14      LDA.W $1497               ; \ Return if Mario is invincible 
CODE_01E60B:        D0 03         BNE Return01E610          ; / 
CODE_01E60D:        20 7C 85      JSR.W FaceMario           
Return01E610:       60            RTS                       ; Return 


DATA_01E611:                      .db $00,$01,$02,$02,$02,$01,$01,$00
                                  .db $00

DATA_01E61A:                      .db $1E,$1B,$18,$18,$18,$1A,$1C,$1D
                                  .db $1E

SpringBoard:        A5 9D         LDA RAM_SpritesLocked     
CODE_01E625:        F0 03         BEQ CODE_01E62A           
CODE_01E627:        4C F0 E6      JMP.W CODE_01E6F0         

CODE_01E62A:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01E62D:        20 32 90      JSR.W SubUpdateSprPos     
CODE_01E630:        20 0E 80      JSR.W IsOnGround          
CODE_01E633:        F0 03         BEQ CODE_01E638           
CODE_01E635:        20 D5 97      JSR.W CODE_0197D5         
CODE_01E638:        20 08 80      JSR.W IsTouchingObjSide   
CODE_01E63B:        F0 0C         BEQ CODE_01E649           
CODE_01E63D:        20 98 90      JSR.W FlipSpriteDir       
CODE_01E640:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01E642:        0A            ASL                       
CODE_01E643:        08            PHP                       
CODE_01E644:        76 B6         ROR RAM_SpriteSpeedX,X    
CODE_01E646:        28            PLP                       
CODE_01E647:        76 B6         ROR RAM_SpriteSpeedX,X    
CODE_01E649:        20 14 80      JSR.W IsTouchingCeiling   
CODE_01E64C:        F0 02         BEQ CODE_01E650           
ADDR_01E64E:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_01E650:        BD 40 15      LDA.W $1540,X             
CODE_01E653:        F0 5B         BEQ CODE_01E6B0           
CODE_01E655:        4A            LSR                       
CODE_01E656:        A8            TAY                       
CODE_01E657:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01E65A:        C9 01         CMP.B #$01                
CODE_01E65C:        B9 1A E6      LDA.W DATA_01E61A,Y       
CODE_01E65F:        90 03         BCC CODE_01E664           
CODE_01E661:        18            CLC                       
CODE_01E662:        69 12         ADC.B #$12                
CODE_01E664:        85 00         STA $00                   
CODE_01E666:        B9 11 E6      LDA.W DATA_01E611,Y       
CODE_01E669:        9D 02 16      STA.W $1602,X             
CODE_01E66C:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01E66E:        38            SEC                       
CODE_01E66F:        E5 00         SBC $00                   
CODE_01E671:        85 96         STA RAM_MarioYPos         
CODE_01E673:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01E676:        E9 00         SBC.B #$00                
CODE_01E678:        85 97         STA RAM_MarioYPosHi       
CODE_01E67A:        64 72         STZ RAM_IsFlying          
CODE_01E67C:        64 7B         STZ RAM_MarioSpeedX       
CODE_01E67E:        A9 02         LDA.B #$02                
CODE_01E680:        8D 71 14      STA.W $1471               
CODE_01E683:        BD 40 15      LDA.W $1540,X             
CODE_01E686:        C9 07         CMP.B #$07                
CODE_01E688:        B0 24         BCS CODE_01E6AE           
CODE_01E68A:        9C 71 14      STZ.W $1471               
CODE_01E68D:        A0 B0         LDY.B #$B0                
CODE_01E68F:        A5 17         LDA RAM_ControllerB       
CODE_01E691:        10 07         BPL CODE_01E69A           
ADDR_01E693:        A9 01         LDA.B #$01                
ADDR_01E695:        8D 0D 14      STA.W RAM_IsSpinJump      
ADDR_01E698:        80 04         BRA CODE_01E69E           

CODE_01E69A:        A5 15         LDA RAM_ControllerA       
CODE_01E69C:        10 09         BPL CODE_01E6A7           
CODE_01E69E:        A9 0B         LDA.B #$0B                
CODE_01E6A0:        85 72         STA RAM_IsFlying          
CODE_01E6A2:        A0 80         LDY.B #$80                
CODE_01E6A4:        8C 06 14      STY.W $1406               
CODE_01E6A7:        84 7D         STY RAM_MarioSpeedY       
CODE_01E6A9:        A9 08         LDA.B #$08                ; \ Play sound effect 
CODE_01E6AB:        8D FC 1D      STA.W $1DFC               ; / 
CODE_01E6AE:        80 40         BRA CODE_01E6F0           

CODE_01E6B0:        20 F7 A7      JSR.W ProcessInteract     
CODE_01E6B3:        90 3B         BCC CODE_01E6F0           
CODE_01E6B5:        9E 4C 15      STZ.W RAM_DisableInter,X  
CODE_01E6B8:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01E6BA:        38            SEC                       
CODE_01E6BB:        E5 96         SBC RAM_MarioYPos         
CODE_01E6BD:        18            CLC                       
CODE_01E6BE:        69 04         ADC.B #$04                
CODE_01E6C0:        C9 1C         CMP.B #$1C                
CODE_01E6C2:        90 0A         BCC CODE_01E6CE           
CODE_01E6C4:        10 21         BPL CODE_01E6E7           
ADDR_01E6C6:        A5 7D         LDA RAM_MarioSpeedY       
ADDR_01E6C8:        10 26         BPL CODE_01E6F0           
ADDR_01E6CA:        64 7D         STZ RAM_MarioSpeedY       
ADDR_01E6CC:        80 22         BRA CODE_01E6F0           

CODE_01E6CE:        24 15         BIT RAM_ControllerA       
CODE_01E6D0:        50 10         BVC CODE_01E6E2           
CODE_01E6D2:        AD 70 14      LDA.W $1470               ; \ Branch if carrying an enemy... 
CODE_01E6D5:        0D 7A 18      ORA.W RAM_OnYoshi         ;  | ...or if on Yoshi 
CODE_01E6D8:        D0 08         BNE CODE_01E6E2           ; / 
CODE_01E6DA:        A9 0B         LDA.B #$0B                ; \ Sprite status = carried 
CODE_01E6DC:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01E6DF:        9E 02 16      STZ.W $1602,X             
CODE_01E6E2:        20 31 AB      JSR.W CODE_01AB31         
CODE_01E6E5:        80 09         BRA CODE_01E6F0           

CODE_01E6E7:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01E6E9:        30 05         BMI CODE_01E6F0           
CODE_01E6EB:        A9 11         LDA.B #$11                
CODE_01E6ED:        9D 40 15      STA.W $1540,X             
CODE_01E6F0:        BC 02 16      LDY.W $1602,X             
CODE_01E6F3:        B9 FD E6      LDA.W DATA_01E6FD,Y       
CODE_01E6F6:        A8            TAY                       
CODE_01E6F7:        A9 02         LDA.B #$02                
CODE_01E6F9:        20 F5 9C      JSR.W SubSprGfx0Entry1    
Return01E6FC:       60            RTS                       ; Return 


DATA_01E6FD:                      .db $00,$02,$00

SmushedGfxRt:       20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01E703:        20 CB 80      JSR.W IsSprOffScreen      
CODE_01E706:        D0 52         BNE Return01E75A          
CODE_01E708:        A5 00         LDA $00                   ; \ Set X displacement for both tiles 
CODE_01E70A:        99 00 03      STA.W OAM_DispX,Y         ;  | (Sprite position + #$00/#$08) 
CODE_01E70D:        18            CLC                       ;  | 
CODE_01E70E:        69 08         ADC.B #$08                ;  | 
CODE_01E710:        99 04 03      STA.W OAM_Tile2DispX,Y    ; / 
CODE_01E713:        A5 01         LDA $01                   ; \ Set Y displacement for both tiles 
CODE_01E715:        18            CLC                       ;  | (Sprite position + #$08) 
CODE_01E716:        69 08         ADC.B #$08                ;  | 
CODE_01E718:        99 01 03      STA.W OAM_DispY,Y         ;  | 
CODE_01E71B:        99 05 03      STA.W OAM_Tile2DispY,Y    ; / 
CODE_01E71E:        DA            PHX                       
CODE_01E71F:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01E721:        AA            TAX                       
CODE_01E722:        A9 FE         LDA.B #$FE                ; \ If P Switch, tile = #$FE 
CODE_01E724:        E0 3E         CPX.B #$3E                ;  | 
CODE_01E726:        F0 12         BEQ CODE_01E73A           ; / 
CODE_01E728:        A9 EE         LDA.B #$EE                ; \ If Sliding Koopa... 
CODE_01E72A:        E0 BD         CPX.B #$BD                ;  | 
CODE_01E72C:        F0 0C         BEQ CODE_01E73A           ;  | 
CODE_01E72E:        E0 04         CPX.B #$04                ;  | ...or a shelless, tile = #$EE 
CODE_01E730:        90 08         BCC CODE_01E73A           ; / 
CODE_01E732:        A9 C7         LDA.B #$C7                ; \ If sprite num >= #$0F, tile = #$C7 (is this used?) 
CODE_01E734:        E0 0F         CPX.B #$0F                ;  | 
CODE_01E736:        B0 02         BCS CODE_01E73A           ; / 
CODE_01E738:        A9 4D         LDA.B #$4D                ; If #$04 <= sprite num < #$0F, tile = #$4D (Koopas) 
CODE_01E73A:        99 02 03      STA.W OAM_Tile,Y          ; \ Same value for both tiles 
CODE_01E73D:        99 06 03      STA.W OAM_Tile2,Y         ; / 
CODE_01E740:        FA            PLX                       
CODE_01E741:        A5 64         LDA $64                   ; \ Store the first tile's properties 
CODE_01E743:        1D F6 15      ORA.W RAM_SpritePal,X     ;  | 
CODE_01E746:        99 03 03      STA.W OAM_Prop,Y          ; / 
CODE_01E749:        09 40         ORA.B #$40                ; \ Horizontally flip the second tile and store it 
CODE_01E74B:        99 07 03      STA.W OAM_Tile2Prop,Y     ; / 
CODE_01E74E:        98            TYA                       ; \ Y = index to size table 
CODE_01E74F:        4A            LSR                       ;  | 
CODE_01E750:        4A            LSR                       ;  | 
CODE_01E751:        A8            TAY                       ; / 
CODE_01E752:        A9 00         LDA.B #$00                ; \ Two 8x8 tiles 
CODE_01E754:        99 60 04      STA.W OAM_TileSize,Y      ;  | 
CODE_01E757:        99 61 04      STA.W $0461,Y             ; / 
Return01E75A:       60            RTS                       ; Return 

PSwitch:            BD 64 15      LDA.W $1564,X             
CODE_01E75E:        C9 01         CMP.B #$01                
CODE_01E760:        D0 0C         BNE Return01E76E          
CODE_01E762:        8D 11 1F      STA.W $1F11               
CODE_01E765:        8D B8 1F      STA.W $1FB8               
CODE_01E768:        9E C8 14      STZ.W $14C8,X             
CODE_01E76B:        EE 26 14      INC.W $1426               
Return01E76E:       60            RTS                       ; Return 


DATA_01E76F:                      .db $FC,$04,$FE,$02,$FB,$05,$FD,$03
                                  .db $FA,$06,$FC,$04,$FB,$05,$FD,$03
DATA_01E77F:                      .db $00,$FF,$03,$04,$FF,$FE,$04,$03
                                  .db $FE,$FF,$03,$03,$FF,$00,$03,$03
                                  .db $F8,$FC,$00,$04

DATA_01E793:                      .db $0E,$0F,$10,$11,$12,$11,$10,$0F
                                  .db $1A,$1B,$1C,$1D,$1E,$1D,$1C,$1B
                                  .db $1A

LakituCloud:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01E7A6:        F0 03         BEQ NoCloudGfx            ; / 
CODE_01E7A8:        4C CA E8      JMP.W LakituCloudGfx      

NoCloudGfx:         AC E0 18      LDY.W $18E0               
CODE_01E7AE:        F0 15         BEQ CODE_01E7C5           
CODE_01E7B0:        A5 14         LDA RAM_FrameCounterB     
CODE_01E7B2:        29 03         AND.B #$03                
CODE_01E7B4:        D0 0F         BNE CODE_01E7C5           
CODE_01E7B6:        AD E0 18      LDA.W $18E0               
CODE_01E7B9:        F0 0A         BEQ CODE_01E7C5           
CODE_01E7BB:        CE E0 18      DEC.W $18E0               
CODE_01E7BE:        D0 05         BNE CODE_01E7C5           
CODE_01E7C0:        A9 1F         LDA.B #$1F                
CODE_01E7C2:        9D 40 15      STA.W $1540,X             
CODE_01E7C5:        BD 40 15      LDA.W $1540,X             
CODE_01E7C8:        F0 11         BEQ CODE_01E7DB           
CODE_01E7CA:        3A            DEC A                     
CODE_01E7CB:        D0 DB         BNE CODE_01E7A8           
CODE_01E7CD:        9E C8 14      STZ.W $14C8,X             
CODE_01E7D0:        A9 FF         LDA.B #$FF                ; \ Set time until respawn 
CODE_01E7D2:        8D C0 18      STA.W RAM_TimeTillRespawn ;  | 
CODE_01E7D5:        A9 1E         LDA.B #$1E                ;  | Sprite to respawn = Lakitu 
CODE_01E7D7:        8D C1 18      STA.W RAM_SpriteToRespawn ; / 
Return01E7DA:       60            RTS                       ; Return 

CODE_01E7DB:        A0 09         LDY.B #$09                
CODE_01E7DD:        B9 C8 14      LDA.W $14C8,Y             
CODE_01E7E0:        C9 08         CMP.B #$08                
CODE_01E7E2:        D0 0E         BNE CODE_01E7F2           
CODE_01E7E4:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01E7E7:        C9 1E         CMP.B #$1E                
CODE_01E7E9:        D0 07         BNE CODE_01E7F2           
CODE_01E7EB:        98            TYA                       
CODE_01E7EC:        9D 0E 16      STA.W $160E,X             
CODE_01E7EF:        4C 98 E8      JMP.W CODE_01E898         

CODE_01E7F2:        88            DEY                       
CODE_01E7F3:        10 E8         BPL CODE_01E7DD           
CODE_01E7F5:        B5 C2         LDA RAM_SpriteState,X     
CODE_01E7F7:        D0 47         BNE CODE_01E840           
CODE_01E7F9:        BD 1C 15      LDA.W $151C,X             
CODE_01E7FC:        F0 06         BEQ CODE_01E804           
CODE_01E7FE:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01E801:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01E804:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_01E807:        D0 34         BNE CODE_01E83D           
CODE_01E809:        20 F7 A7      JSR.W ProcessInteract     
CODE_01E80C:        90 2F         BCC CODE_01E83D           
CODE_01E80E:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01E810:        30 2B         BMI CODE_01E83D           
CODE_01E812:        F6 C2         INC RAM_SpriteState,X     
CODE_01E814:        A9 11         LDA.B #$11                
CODE_01E816:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_01E819:        F0 02         BEQ CODE_01E81D           
ADDR_01E81B:        A9 22         LDA.B #$22                
CODE_01E81D:        18            CLC                       
CODE_01E81E:        65 D3         ADC $D3                   
CODE_01E820:        95 D8         STA RAM_SpriteYLo,X       
CODE_01E822:        A5 D4         LDA $D4                   
CODE_01E824:        69 00         ADC.B #$00                
CODE_01E826:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01E829:        A5 D1         LDA $D1                   
CODE_01E82B:        95 E4         STA RAM_SpriteXLo,X       
CODE_01E82D:        A5 D2         LDA $D2                   
CODE_01E82F:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01E832:        A9 10         LDA.B #$10                
CODE_01E834:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01E836:        9D 1C 15      STA.W $151C,X             
CODE_01E839:        A5 7B         LDA RAM_MarioSpeedX       
CODE_01E83B:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01E83D:        4C CA E8      JMP.W LakituCloudGfx      

CODE_01E840:        20 CA E8      JSR.W LakituCloudGfx      
CODE_01E843:        8B            PHB                       
CODE_01E844:        A9 02         LDA.B #$02                
CODE_01E846:        48            PHA                       
CODE_01E847:        AB            PLB                       
CODE_01E848:        22 14 D2 02   JSL.L CODE_02D214         
CODE_01E84C:        AB            PLB                       
CODE_01E84D:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01E84F:        18            CLC                       
CODE_01E850:        69 03         ADC.B #$03                
CODE_01E852:        85 7D         STA RAM_MarioSpeedY       
CODE_01E854:        A5 14         LDA RAM_FrameCounterB     
CODE_01E856:        4A            LSR                       
CODE_01E857:        4A            LSR                       
CODE_01E858:        4A            LSR                       
CODE_01E859:        29 07         AND.B #$07                
CODE_01E85B:        A8            TAY                       
CODE_01E85C:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01E85F:        F0 05         BEQ CODE_01E866           
ADDR_01E861:        98            TYA                       
ADDR_01E862:        18            CLC                       
ADDR_01E863:        69 08         ADC.B #$08                
ADDR_01E865:        A8            TAY                       
CODE_01E866:        A5 D1         LDA $D1                   
CODE_01E868:        95 E4         STA RAM_SpriteXLo,X       
CODE_01E86A:        A5 D2         LDA $D2                   
CODE_01E86C:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01E86F:        A5 D3         LDA $D3                   
CODE_01E871:        18            CLC                       
CODE_01E872:        79 93 E7      ADC.W DATA_01E793,Y       
CODE_01E875:        95 D8         STA RAM_SpriteYLo,X       
CODE_01E877:        A5 D4         LDA $D4                   
CODE_01E879:        69 00         ADC.B #$00                
CODE_01E87B:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01E87E:        64 72         STZ RAM_IsFlying          
CODE_01E880:        EE 71 14      INC.W $1471               
CODE_01E883:        EE C2 18      INC.W $18C2               
CODE_01E886:        A5 16         LDA $16                   
CODE_01E888:        29 80         AND.B #$80                
CODE_01E88A:        F0 0B         BEQ Return01E897          
CODE_01E88C:        A9 C0         LDA.B #$C0                
CODE_01E88E:        85 7D         STA RAM_MarioSpeedY       
CODE_01E890:        A9 10         LDA.B #$10                
CODE_01E892:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_01E895:        74 C2         STZ RAM_SpriteState,X     
Return01E897:       60            RTS                       ; Return 

CODE_01E898:        5A            PHY                       
CODE_01E899:        20 8D E9      JSR.W CODE_01E98D         
CODE_01E89C:        A5 14         LDA RAM_FrameCounterB     
CODE_01E89E:        4A            LSR                       
CODE_01E89F:        4A            LSR                       
CODE_01E8A0:        4A            LSR                       
CODE_01E8A1:        29 07         AND.B #$07                
CODE_01E8A3:        A8            TAY                       
CODE_01E8A4:        B9 93 E7      LDA.W DATA_01E793,Y       
CODE_01E8A7:        85 00         STA $00                   
CODE_01E8A9:        7A            PLY                       
CODE_01E8AA:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01E8AC:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_01E8AF:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01E8B2:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_01E8B5:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01E8B7:        38            SEC                       
CODE_01E8B8:        E5 00         SBC $00                   
CODE_01E8BA:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_01E8BD:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01E8C0:        E9 00         SBC.B #$00                
CODE_01E8C2:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_01E8C5:        A9 10         LDA.B #$10                
CODE_01E8C7:        9D 4C 15      STA.W RAM_DisableInter,X  
LakituCloudGfx:     20 65 A3      JSR.W GetDrawInfoBnk1     
CODE_01E8CD:        BD 6C 18      LDA.W RAM_OffscreenVert,X 
CODE_01E8D0:        D0 C5         BNE Return01E897          
CODE_01E8D2:        A9 F8         LDA.B #$F8                
CODE_01E8D4:        85 0C         STA $0C                   
CODE_01E8D6:        A9 FC         LDA.B #$FC                
CODE_01E8D8:        85 0D         STA $0D                   
CODE_01E8DA:        A9 00         LDA.B #$00                
CODE_01E8DC:        B4 C2         LDY RAM_SpriteState,X     
CODE_01E8DE:        D0 02         BNE CODE_01E8E2           
CODE_01E8E0:        A9 30         LDA.B #$30                
CODE_01E8E2:        85 0E         STA $0E                   
CODE_01E8E4:        8D B6 18      STA.W $18B6               
CODE_01E8E7:        09 04         ORA.B #$04                
CODE_01E8E9:        85 0F         STA $0F                   
CODE_01E8EB:        A5 00         LDA $00                   
CODE_01E8ED:        8D B0 14      STA.W $14B0               
CODE_01E8F0:        A5 01         LDA $01                   
CODE_01E8F2:        8D B2 14      STA.W $14B2               
CODE_01E8F5:        A5 14         LDA RAM_FrameCounterB     
CODE_01E8F7:        4A            LSR                       
CODE_01E8F8:        4A            LSR                       
CODE_01E8F9:        29 0C         AND.B #$0C                
CODE_01E8FB:        85 02         STA $02                   
CODE_01E8FD:        A9 03         LDA.B #$03                
CODE_01E8FF:        85 03         STA $03                   
CODE_01E901:        A5 03         LDA $03                   
CODE_01E903:        AA            TAX                       
CODE_01E904:        B4 0C         LDY $0C,X                 
CODE_01E906:        18            CLC                       
CODE_01E907:        65 02         ADC $02                   
CODE_01E909:        AA            TAX                       
CODE_01E90A:        BD 6F E7      LDA.W DATA_01E76F,X       
CODE_01E90D:        18            CLC                       
CODE_01E90E:        6D B0 14      ADC.W $14B0               
CODE_01E911:        99 00 03      STA.W OAM_DispX,Y         
CODE_01E914:        BD 7F E7      LDA.W DATA_01E77F,X       
CODE_01E917:        18            CLC                       
CODE_01E918:        6D B2 14      ADC.W $14B2               
CODE_01E91B:        99 01 03      STA.W OAM_DispY,Y         
CODE_01E91E:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01E921:        A9 60         LDA.B #$60                
CODE_01E923:        99 02 03      STA.W OAM_Tile,Y          
CODE_01E926:        BD 40 15      LDA.W $1540,X             
CODE_01E929:        F0 0A         BEQ CODE_01E935           
CODE_01E92B:        4A            LSR                       
CODE_01E92C:        4A            LSR                       
CODE_01E92D:        4A            LSR                       
CODE_01E92E:        AA            TAX                       
CODE_01E92F:        BD 85 E9      LDA.W CloudTiles,X        
CODE_01E932:        99 02 03      STA.W OAM_Tile,Y          
CODE_01E935:        A5 64         LDA $64                   
CODE_01E937:        99 03 03      STA.W OAM_Prop,Y          
CODE_01E93A:        C8            INY                       
CODE_01E93B:        C8            INY                       
CODE_01E93C:        C8            INY                       
CODE_01E93D:        C8            INY                       
CODE_01E93E:        C6 03         DEC $03                   
CODE_01E940:        10 BF         BPL CODE_01E901           
CODE_01E942:        AE E9 15      LDX.W $15E9               ; X = Sprite index 
CODE_01E945:        A9 F8         LDA.B #$F8                
CODE_01E947:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_01E94A:        A0 02         LDY.B #$02                
CODE_01E94C:        A9 01         LDA.B #$01                
CODE_01E94E:        20 BB B7      JSR.W FinishOAMWriteRt    
CODE_01E951:        AD B6 18      LDA.W $18B6               
CODE_01E954:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_01E957:        A0 02         LDY.B #$02                
CODE_01E959:        A9 01         LDA.B #$01                
CODE_01E95B:        20 BB B7      JSR.W FinishOAMWriteRt    
CODE_01E95E:        BD A0 15      LDA.W RAM_OffscreenHorz,X 
CODE_01E961:        D0 21         BNE Return01E984          
CODE_01E963:        AD B0 14      LDA.W $14B0               
CODE_01E966:        18            CLC                       
CODE_01E967:        69 04         ADC.B #$04                
CODE_01E969:        8D 08 02      STA.W $0208               
CODE_01E96C:        AD B2 14      LDA.W $14B2               
CODE_01E96F:        18            CLC                       
CODE_01E970:        69 07         ADC.B #$07                
CODE_01E972:        8D 09 02      STA.W $0209               
CODE_01E975:        A9 4D         LDA.B #$4D                
CODE_01E977:        8D 0A 02      STA.W $020A               
CODE_01E97A:        A9 39         LDA.B #$39                
CODE_01E97C:        8D 0B 02      STA.W $020B               
CODE_01E97F:        A9 00         LDA.B #$00                
CODE_01E981:        8D 22 04      STA.W $0422               
Return01E984:       60            RTS                       ; Return 


CloudTiles:                       .db $66,$64,$62,$60

DATA_01E989:                      .db $20,$E0

DATA_01E98B:                      .db $10,$F0

CODE_01E98D:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01E98F:        D0 F3         BNE Return01E984          ; / 
CODE_01E991:        20 30 AD      JSR.W SubHorizPos         
CODE_01E994:        98            TYA                       
CODE_01E995:        BC 0E 16      LDY.W $160E,X             
CODE_01E998:        99 7C 15      STA.W RAM_SpriteDir,Y     
CODE_01E99B:        85 00         STA $00                   
CODE_01E99D:        A4 00         LDY $00                   
CODE_01E99F:        AD BF 18      LDA.W $18BF               
CODE_01E9A2:        F0 19         BEQ CODE_01E9BD           
CODE_01E9A4:        5A            PHY                       
CODE_01E9A5:        DA            PHX                       
CODE_01E9A6:        BD 0E 16      LDA.W $160E,X             
CODE_01E9A9:        AA            TAX                       
CODE_01E9AA:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01E9AD:        BD C8 14      LDA.W $14C8,X             
CODE_01E9B0:        FA            PLX                       
CODE_01E9B1:        C9 00         CMP.B #$00                
CODE_01E9B3:        D0 03         BNE CODE_01E9B8           
CODE_01E9B5:        9E C8 14      STZ.W $14C8,X             
CODE_01E9B8:        7A            PLY                       
CODE_01E9B9:        98            TYA                       
CODE_01E9BA:        49 01         EOR.B #$01                
CODE_01E9BC:        A8            TAY                       
CODE_01E9BD:        A5 13         LDA RAM_FrameCounter      
CODE_01E9BF:        29 01         AND.B #$01                
CODE_01E9C1:        D0 23         BNE CODE_01E9E6           
CODE_01E9C3:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01E9C5:        D9 89 E9      CMP.W DATA_01E989,Y       
CODE_01E9C8:        F0 06         BEQ CODE_01E9D0           
CODE_01E9CA:        18            CLC                       
CODE_01E9CB:        79 B4 EB      ADC.W DATA_01EBB4,Y       
CODE_01E9CE:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01E9D0:        BD 34 15      LDA.W $1534,X             
CODE_01E9D3:        29 01         AND.B #$01                
CODE_01E9D5:        A8            TAY                       
CODE_01E9D6:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01E9D8:        18            CLC                       
CODE_01E9D9:        79 B4 EB      ADC.W DATA_01EBB4,Y       
CODE_01E9DC:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01E9DE:        D9 8B E9      CMP.W DATA_01E98B,Y       
CODE_01E9E1:        D0 03         BNE CODE_01E9E6           
CODE_01E9E3:        FE 34 15      INC.W $1534,X             
CODE_01E9E6:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01E9E8:        48            PHA                       
CODE_01E9E9:        AC BF 18      LDY.W $18BF               
CODE_01E9EC:        D0 0B         BNE CODE_01E9F9           
CODE_01E9EE:        AD BD 17      LDA.W $17BD               
CODE_01E9F1:        0A            ASL                       
CODE_01E9F2:        0A            ASL                       
CODE_01E9F3:        0A            ASL                       
CODE_01E9F4:        18            CLC                       
CODE_01E9F5:        75 B6         ADC RAM_SpriteSpeedX,X    
CODE_01E9F7:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01E9F9:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01E9FC:        68            PLA                       
CODE_01E9FD:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01E9FF:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01EA02:        BC 0E 16      LDY.W $160E,X             
CODE_01EA05:        A5 13         LDA RAM_FrameCounter      
CODE_01EA07:        29 7F         AND.B #$7F                
CODE_01EA09:        19 1C 15      ORA.W $151C,Y             
CODE_01EA0C:        D0 08         BNE Return01EA16          
CODE_01EA0E:        A9 20         LDA.B #$20                
CODE_01EA10:        99 58 15      STA.W $1558,Y             
CODE_01EA13:        20 21 EA      JSR.W CODE_01EA21         
Return01EA16:       60            RTS                       ; Return 


DATA_01EA17:                      .db $10,$F0

CODE_01EA19:        8B            PHB                       ; Wrapper 
CODE_01EA1A:        4B            PHK                       
CODE_01EA1B:        AB            PLB                       
CODE_01EA1C:        20 21 EA      JSR.W CODE_01EA21         
CODE_01EA1F:        AB            PLB                       
Return01EA20:       6B            RTL                       ; Return 

CODE_01EA21:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_01EA25:        30 48         BMI Return01EA6F          ; / 
CODE_01EA27:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_01EA29:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01EA2C:        AD AE 14      LDA.W RAM_SilverPowTimer  
CODE_01EA2F:        C9 01         CMP.B #$01                
CODE_01EA31:        A9 14         LDA.B #$14                
CODE_01EA33:        90 02         BCC CODE_01EA37           
CODE_01EA35:        A9 21         LDA.B #$21                
CODE_01EA37:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_01EA3A:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01EA3C:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_01EA3F:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01EA42:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_01EA45:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01EA47:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_01EA4A:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01EA4D:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_01EA50:        DA            PHX                       
CODE_01EA51:        BB            TYX                       
CODE_01EA52:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_01EA56:        A9 D8         LDA.B #$D8                
CODE_01EA58:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01EA5A:        20 30 AD      JSR.W SubHorizPos         
CODE_01EA5D:        B9 17 EA      LDA.W DATA_01EA17,Y       
CODE_01EA60:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01EA62:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01EA64:        C9 21         CMP.B #$21                
CODE_01EA66:        D0 05         BNE CODE_01EA6D           
CODE_01EA68:        A9 02         LDA.B #$02                
CODE_01EA6A:        9D F6 15      STA.W RAM_SpritePal,X     
CODE_01EA6D:        9B            TXY                       
CODE_01EA6E:        FA            PLX                       
Return01EA6F:       60            RTS                       ; Return 

CODE_01EA70:        AE E2 18      LDX.W $18E2               
CODE_01EA73:        F0 19         BEQ Return01EA8E          
CODE_01EA75:        9C 8B 18      STZ.W $188B               
CODE_01EA78:        9C 1C 19      STZ.W $191C               
CODE_01EA7B:        AD E9 15      LDA.W $15E9               
CODE_01EA7E:        48            PHA                       
CODE_01EA7F:        CA            DEX                       
CODE_01EA80:        8E E9 15      STX.W $15E9               
CODE_01EA83:        8B            PHB                       
CODE_01EA84:        4B            PHK                       
CODE_01EA85:        AB            PLB                       
CODE_01EA86:        20 8F EA      JSR.W CODE_01EA8F         
CODE_01EA89:        AB            PLB                       
CODE_01EA8A:        68            PLA                       
CODE_01EA8B:        8D E9 15      STA.W $15E9               
Return01EA8E:       6B            RTL                       ; Return 

CODE_01EA8F:        AD E8 18      LDA.W $18E8               
CODE_01EA92:        0D C6 13      ORA.W $13C6               
CODE_01EA95:        F0 03         BEQ CODE_01EA9A           
CODE_01EA97:        4C 48 EB      JMP.W CODE_01EB48         

CODE_01EA9A:        9C DC 18      STZ.W $18DC               
CODE_01EA9D:        B5 C2         LDA RAM_SpriteState,X     
CODE_01EA9F:        C9 02         CMP.B #$02                
CODE_01EAA1:        90 04         BCC CODE_01EAA7           
CODE_01EAA3:        A9 30         LDA.B #$30                
CODE_01EAA5:        80 0B         BRA CODE_01EAB2           

CODE_01EAA7:        A0 00         LDY.B #$00                
CODE_01EAA9:        A5 7B         LDA RAM_MarioSpeedX       ; \ Branch if Mario X speed == 0 
CODE_01EAAB:        F0 32         BEQ CODE_01EADF           ; / 
CODE_01EAAD:        10 03         BPL CODE_01EAB2           ; \ If Mario X speed is positive, 
CODE_01EAAF:        49 FF         EOR.B #$FF                ;  | invert it 
CODE_01EAB1:        1A            INC A                     ; / 
CODE_01EAB2:        4A            LSR                       ; \ Y = Upper 4 bits of X speed 
CODE_01EAB3:        4A            LSR                       ;  | 
CODE_01EAB4:        4A            LSR                       ;  | 
CODE_01EAB5:        4A            LSR                       ;  | 
CODE_01EAB6:        A8            TAY                       ; / 
CODE_01EAB7:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01EAB9:        D0 15         BNE CODE_01EAD0           ; / 
CODE_01EABB:        DE 70 15      DEC.W $1570,X             ; \ If time to change frame... 
CODE_01EABE:        10 10         BPL CODE_01EAD0           ;  | 
CODE_01EAC0:        B9 F5 ED      LDA.W DATA_01EDF5,Y       ;  | Set time to display new frame (based on Mario's X speed) 
CODE_01EAC3:        9D 70 15      STA.W $1570,X             ;  | 
CODE_01EAC6:        CE AD 18      DEC.W $18AD               ;  | Set index to new frame, $18AD = ($18AD-1) % 3 
CODE_01EAC9:        10 05         BPL CODE_01EAD0           ;  | 
CODE_01EACB:        A9 02         LDA.B #$02                ;  | 
CODE_01EACD:        8D AD 18      STA.W $18AD               ; / 
CODE_01EAD0:        AC AD 18      LDY.W $18AD               ; \ Y = frame to show 
CODE_01EAD3:        B9 EE ED      LDA.W YoshiWalkFrames,Y   ;  | 
CODE_01EAD6:        A8            TAY                       ; / 
CODE_01EAD7:        B5 C2         LDA RAM_SpriteState,X     
CODE_01EAD9:        C9 02         CMP.B #$02                
CODE_01EADB:        B0 51         BCS CODE_01EB2E           
CODE_01EADD:        80 03         BRA CODE_01EAE2           

CODE_01EADF:        9E 70 15      STZ.W $1570,X             
CODE_01EAE2:        A5 72         LDA RAM_IsFlying          
CODE_01EAE4:        F0 0A         BEQ CODE_01EAF0           
CODE_01EAE6:        A0 02         LDY.B #$02                
CODE_01EAE8:        A5 7D         LDA RAM_MarioSpeedY       
CODE_01EAEA:        10 04         BPL CODE_01EAF0           
CODE_01EAEC:        A0 05         LDY.B #$05                
CODE_01EAEE:        80 00         BRA CODE_01EAF0           

CODE_01EAF0:        BD AC 15      LDA.W $15AC,X             
CODE_01EAF3:        F0 02         BEQ CODE_01EAF7           
CODE_01EAF5:        A0 03         LDY.B #$03                
CODE_01EAF7:        A5 72         LDA RAM_IsFlying          
CODE_01EAF9:        D0 26         BNE CODE_01EB21           
CODE_01EAFB:        BD 1C 15      LDA.W $151C,X             
CODE_01EAFE:        F0 0C         BEQ CODE_01EB0C           
CODE_01EB00:        A0 07         LDY.B #$07                
CODE_01EB02:        A5 15         LDA RAM_ControllerA       
CODE_01EB04:        29 08         AND.B #$08                
CODE_01EB06:        F0 02         BEQ CODE_01EB0A           
CODE_01EB08:        A0 06         LDY.B #$06                
CODE_01EB0A:        80 15         BRA CODE_01EB21           

CODE_01EB0C:        AD AF 18      LDA.W $18AF               
CODE_01EB0F:        F0 05         BEQ CODE_01EB16           
CODE_01EB11:        CE AF 18      DEC.W $18AF               
CODE_01EB14:        80 06         BRA CODE_01EB1C           

CODE_01EB16:        A5 15         LDA RAM_ControllerA       
CODE_01EB18:        29 04         AND.B #$04                
CODE_01EB1A:        F0 05         BEQ CODE_01EB21           
CODE_01EB1C:        A0 04         LDY.B #$04                
CODE_01EB1E:        EE DC 18      INC.W $18DC               
CODE_01EB21:        B5 C2         LDA RAM_SpriteState,X     
CODE_01EB23:        C9 01         CMP.B #$01                
CODE_01EB25:        F0 07         BEQ CODE_01EB2E           
CODE_01EB27:        BD 1C 15      LDA.W $151C,X             
CODE_01EB2A:        D0 02         BNE CODE_01EB2E           
CODE_01EB2C:        A0 04         LDY.B #$04                
CODE_01EB2E:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01EB31:        F0 11         BEQ CODE_01EB44           
CODE_01EB33:        AD 19 14      LDA.W RAM_YoshiInPipe     
CODE_01EB36:        C9 01         CMP.B #$01                
CODE_01EB38:        D0 0A         BNE CODE_01EB44           
CODE_01EB3A:        A5 13         LDA RAM_FrameCounter      
CODE_01EB3C:        29 08         AND.B #$08                
CODE_01EB3E:        4A            LSR                       
CODE_01EB3F:        4A            LSR                       
CODE_01EB40:        4A            LSR                       
CODE_01EB41:        69 08         ADC.B #$08                
CODE_01EB43:        A8            TAY                       
CODE_01EB44:        98            TYA                       
CODE_01EB45:        9D 02 16      STA.W $1602,X             
CODE_01EB48:        B5 C2         LDA RAM_SpriteState,X     
CODE_01EB4A:        C9 01         CMP.B #$01                
CODE_01EB4C:        D0 49         BNE CODE_01EB97           
CODE_01EB4E:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01EB51:        A5 94         LDA RAM_MarioXPos         
CODE_01EB53:        18            CLC                       
CODE_01EB54:        79 F1 ED      ADC.W YoshiPositionX,Y    
CODE_01EB57:        95 E4         STA RAM_SpriteXLo,X       
CODE_01EB59:        A5 95         LDA RAM_MarioXPosHi       
CODE_01EB5B:        79 F3 ED      ADC.W DATA_01EDF3,Y       
CODE_01EB5E:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01EB61:        BC 02 16      LDY.W $1602,X             
CODE_01EB64:        A5 96         LDA RAM_MarioYPos         
CODE_01EB66:        18            CLC                       
CODE_01EB67:        69 10         ADC.B #$10                
CODE_01EB69:        95 D8         STA RAM_SpriteYLo,X       
CODE_01EB6B:        A5 97         LDA RAM_MarioYPosHi       
CODE_01EB6D:        69 00         ADC.B #$00                
CODE_01EB6F:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01EB72:        B9 E4 ED      LDA.W DATA_01EDE4,Y       
CODE_01EB75:        8D 8B 18      STA.W $188B               
CODE_01EB78:        A9 01         LDA.B #$01                
CODE_01EB7A:        BC 02 16      LDY.W $1602,X             
CODE_01EB7D:        C0 03         CPY.B #$03                
CODE_01EB7F:        D0 01         BNE BackOnYoshi           
CODE_01EB81:        1A            INC A                     
BackOnYoshi:        8D 7A 18      STA.W RAM_OnYoshi         
CODE_01EB85:        A9 01         LDA.B #$01                
CODE_01EB87:        8D C1 0D      STA.W RAM_OWHasYoshi      
CODE_01EB8A:        BD F6 15      LDA.W RAM_SpritePal,X     ; \ $13C7 = Yoshi palette 
CODE_01EB8D:        8D C7 13      STA.W RAM_YoshiColor      ; / 
CODE_01EB90:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01EB93:        49 01         EOR.B #$01                
CODE_01EB95:        85 76         STA RAM_MarioDirection    
CODE_01EB97:        A5 64         LDA $64                   
CODE_01EB99:        48            PHA                       
CODE_01EB9A:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01EB9D:        F0 0E         BEQ CODE_01EBAD           
CODE_01EB9F:        AD 19 14      LDA.W RAM_YoshiInPipe     
CODE_01EBA2:        F0 09         BEQ CODE_01EBAD           
CODE_01EBA4:        AD 05 14      LDA.W $1405               
CODE_01EBA7:        D0 07         BNE CODE_01EBB0           
CODE_01EBA9:        A9 10         LDA.B #$10                
CODE_01EBAB:        85 64         STA $64                   
CODE_01EBAD:        20 61 EE      JSR.W HandleOffYoshi      
CODE_01EBB0:        68            PLA                       
CODE_01EBB1:        85 64         STA $64                   
Return01EBB3:       60            RTS                       ; Return 


DATA_01EBB4:                      .db $01,$FF,$01,$00,$FF,$00,$20,$E0
                                  .db $0A,$0E

DATA_01EBBE:                      .db $E8,$18

DATA_01EBC0:                      .db $10,$F0

GrowingAniSequence:               .db $0C,$0B,$0C,$0B,$0A,$0B,$0A,$0B

Yoshi:              9C FB 13      STZ.W $13FB               
CODE_01EBCD:        AD 1E 14      LDA.W RAM_YoshiHasWings   ; \ $1410 = winged Yoshi flag 
CODE_01EBD0:        8D 10 14      STA.W RAM_YoshiHasWingsB  ; / 
CODE_01EBD3:        9C 1E 14      STZ.W RAM_YoshiHasWings   ; Clear real winged Yoshi flag 
CODE_01EBD6:        9C E7 18      STZ.W RAM_YoshiHasStomp   ; Clear stomp Yoshi flag 
CODE_01EBD9:        9C 1B 19      STZ.W $191B               
CODE_01EBDC:        BD C8 14      LDA.W $14C8,X             ; \ Branch if normal Yoshi status 
CODE_01EBDF:        C9 08         CMP.B #$08                ;  | 
CODE_01EBE1:        F0 06         BEQ CODE_01EBE9           ; / 
CODE_01EBE3:        9C C1 0D      STZ.W RAM_OWHasYoshi      ; Mario won't have Yoshi when returning to OW 
CODE_01EBE6:        4C 61 EE      JMP.W HandleOffYoshi      

CODE_01EBE9:        8A            TXA                       
CODE_01EBEA:        1A            INC A                     
CODE_01EBEB:        8D DF 18      STA.W $18DF               
CODE_01EBEE:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01EBF1:        D0 11         BNE CODE_01EC04           
CODE_01EBF3:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01EBF6:        BD C8 14      LDA.W $14C8,X             
CODE_01EBF9:        D0 09         BNE CODE_01EC04           
CODE_01EBFB:        AD 95 1B      LDA.W $1B95               
CODE_01EBFE:        D0 03         BNE Return01EC03          
CODE_01EC00:        9C C1 0D      STZ.W RAM_OWHasYoshi      
Return01EC03:       60            RTS                       ; Return 

CODE_01EC04:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01EC07:        F0 05         BEQ CODE_01EC0E           
CODE_01EC09:        AD 19 14      LDA.W RAM_YoshiInPipe     
CODE_01EC0C:        D0 53         BNE CODE_01EC61           
CODE_01EC0E:        AD DE 18      LDA.W $18DE               
CODE_01EC11:        D0 4E         BNE CODE_01EC61           
CODE_01EC13:        AD E8 18      LDA.W $18E8               
CODE_01EC16:        F0 34         BEQ CODE_01EC4C           
CODE_01EC18:        CE E8 18      DEC.W $18E8               
CODE_01EC1B:        85 9D         STA RAM_SpritesLocked     
CODE_01EC1D:        8D FB 13      STA.W $13FB               
CODE_01EC20:        C9 01         CMP.B #$01                
CODE_01EC22:        D0 1C         BNE CODE_01EC40           
CODE_01EC24:        64 9D         STZ RAM_SpritesLocked     
CODE_01EC26:        9C FB 13      STZ.W $13FB               
CODE_01EC29:        AC B3 0D      LDY.W $0DB3               
CODE_01EC2C:        B9 11 1F      LDA.W $1F11,Y             
CODE_01EC2F:        3A            DEC A                     
CODE_01EC30:        0D F8 0E      ORA.W $0EF8               
CODE_01EC33:        0D 09 01      ORA.W $0109               
CODE_01EC36:        D0 08         BNE CODE_01EC40           
CODE_01EC38:        EE F8 0E      INC.W $0EF8               
CODE_01EC3B:        A9 03         LDA.B #$03                
CODE_01EC3D:        8D 26 14      STA.W $1426               
CODE_01EC40:        3A            DEC A                     
CODE_01EC41:        4A            LSR                       
CODE_01EC42:        4A            LSR                       
CODE_01EC43:        4A            LSR                       
CODE_01EC44:        A8            TAY                       
CODE_01EC45:        B9 C2 EB      LDA.W GrowingAniSequence,Y ; \ Set image to appropriate frame 
CODE_01EC48:        9D 02 16      STA.W $1602,X             ; / 
Return01EC4B:       60            RTS                       ; Return 

CODE_01EC4C:        A5 9D         LDA RAM_SpritesLocked     
CODE_01EC4E:        F0 11         BEQ CODE_01EC61           
CODE_01EC50:        AC 7A 18      LDY.W RAM_OnYoshi         
CODE_01EC53:        F0 05         BEQ Return01EC5A          
CODE_01EC55:        A0 06         LDY.B #$06                
CODE_01EC57:        8C 8B 18      STY.W $188B               
Return01EC5A:       60            RTS                       ; Return 


DATA_01EC5B:                      .db $F0,$10

DATA_01EC5D:                      .db $FA,$06

DATA_01EC5F:                      .db $FF,$00

CODE_01EC61:        A5 72         LDA RAM_IsFlying          
CODE_01EC63:        D0 05         BNE CODE_01EC6A           
CODE_01EC65:        AD DE 18      LDA.W $18DE               
CODE_01EC68:        D0 03         BNE CODE_01EC6D           
CODE_01EC6A:        4C E1 EC      JMP.W CODE_01ECE1         

CODE_01EC6D:        CE DE 18      DEC.W $18DE               
CODE_01EC70:        C9 01         CMP.B #$01                
CODE_01EC72:        D0 04         BNE CODE_01EC78           
CODE_01EC74:        64 9D         STZ RAM_SpritesLocked     
CODE_01EC76:        80 F2         BRA CODE_01EC6A           

CODE_01EC78:        EE FB 13      INC.W $13FB               
CODE_01EC7B:        20 50 EC      JSR.W CODE_01EC50         
CODE_01EC7E:        84 9D         STY RAM_SpritesLocked     
CODE_01EC80:        C9 02         CMP.B #$02                
CODE_01EC82:        D0 06         BNE Return01EC8A          
CODE_01EC84:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_01EC88:        10 01         BPL CODE_01EC8B           ;  | 
Return01EC8A:       60            RTS                       ; / 

CODE_01EC8B:        A9 09         LDA.B #$09                ; \ Sprite status = Carryable 
CODE_01EC8D:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01EC90:        A9 2C         LDA.B #$2C                
CODE_01EC92:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_01EC95:        5A            PHY                       
CODE_01EC96:        5A            PHY                       
CODE_01EC97:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01EC9A:        84 0F         STY $0F                   
CODE_01EC9C:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01EC9E:        18            CLC                       
CODE_01EC9F:        79 5D EC      ADC.W DATA_01EC5D,Y       
CODE_01ECA2:        7A            PLY                       
CODE_01ECA3:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_01ECA6:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01ECA9:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01ECAC:        79 5F EC      ADC.W DATA_01EC5F,Y       
CODE_01ECAF:        7A            PLY                       
CODE_01ECB0:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_01ECB3:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01ECB5:        18            CLC                       
CODE_01ECB6:        69 08         ADC.B #$08                
CODE_01ECB8:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_01ECBB:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01ECBE:        69 00         ADC.B #$00                
CODE_01ECC0:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_01ECC3:        DA            PHX                       
CODE_01ECC4:        BB            TYX                       
CODE_01ECC5:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_01ECC9:        A4 0F         LDY $0F                   
CODE_01ECCB:        B9 5B EC      LDA.W DATA_01EC5B,Y       
CODE_01ECCE:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01ECD0:        A9 F0         LDA.B #$F0                
CODE_01ECD2:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01ECD4:        A9 10         LDA.B #$10                
CODE_01ECD6:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_01ECD9:        AD DA 18      LDA.W $18DA               
CODE_01ECDC:        9D 1C 15      STA.W $151C,X             
CODE_01ECDF:        FA            PLX                       
Return01ECE0:       60            RTS                       ; Return 

CODE_01ECE1:        B5 C2         LDA RAM_SpriteState,X     
CODE_01ECE3:        C9 01         CMP.B #$01                
CODE_01ECE5:        D0 03         BNE CODE_01ECEA           
CODE_01ECE7:        4C 70 ED      JMP.W CODE_01ED70         

CODE_01ECEA:        20 32 90      JSR.W SubUpdateSprPos     
CODE_01ECED:        20 0E 80      JSR.W IsOnGround          
CODE_01ECF0:        F0 0F         BEQ CODE_01ED01           
CODE_01ECF2:        20 04 9A      JSR.W SetSomeYSpeed??     
CODE_01ECF5:        B5 C2         LDA RAM_SpriteState,X     
CODE_01ECF7:        C9 02         CMP.B #$02                
CODE_01ECF9:        B0 06         BCS CODE_01ED01           
CODE_01ECFB:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_01ECFD:        A9 F0         LDA.B #$F0                
CODE_01ECFF:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01ED01:        20 15 9A      JSR.W UpdateDirection     
CODE_01ED04:        20 08 80      JSR.W IsTouchingObjSide   
CODE_01ED07:        F0 03         BEQ CODE_01ED0C           
CODE_01ED09:        20 A2 90      JSR.W CODE_0190A2         
CODE_01ED0C:        A9 04         LDA.B #$04                
CODE_01ED0E:        18            CLC                       
CODE_01ED0F:        75 E4         ADC RAM_SpriteXLo,X       
CODE_01ED11:        85 04         STA $04                   
CODE_01ED13:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01ED16:        69 00         ADC.B #$00                
CODE_01ED18:        85 0A         STA $0A                   
CODE_01ED1A:        A9 13         LDA.B #$13                
CODE_01ED1C:        18            CLC                       
CODE_01ED1D:        75 D8         ADC RAM_SpriteYLo,X       
CODE_01ED1F:        85 05         STA $05                   
CODE_01ED21:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01ED24:        69 00         ADC.B #$00                
CODE_01ED26:        85 0B         STA $0B                   
CODE_01ED28:        A9 08         LDA.B #$08                
CODE_01ED2A:        85 07         STA $07                   
CODE_01ED2C:        85 06         STA $06                   
CODE_01ED2E:        22 64 B6 03   JSL.L GetMarioClipping    
CODE_01ED32:        22 2B B7 03   JSL.L CheckForContact     
CODE_01ED36:        90 38         BCC CODE_01ED70           
CODE_01ED38:        A5 72         LDA RAM_IsFlying          
CODE_01ED3A:        F0 34         BEQ CODE_01ED70           
CODE_01ED3C:        AD 70 14      LDA.W $1470               ; \ Branch if carrying an enemy... 
CODE_01ED3F:        0D 7A 18      ORA.W RAM_OnYoshi         ;  | ...or if on Yoshi 
CODE_01ED42:        D0 2C         BNE CODE_01ED70           ; / 
CODE_01ED44:        A5 7D         LDA RAM_MarioSpeedY       ; \ Branch if upward speed 
CODE_01ED46:        30 28         BMI CODE_01ED70           ; / 
SetOnYoshi:         A0 01         LDY.B #$01                
CODE_01ED4A:        20 CE ED      JSR.W CODE_01EDCE         
CODE_01ED4D:        64 7B         STZ RAM_MarioSpeedX       ; \ Mario's speed = 0 
CODE_01ED4F:        64 7D         STZ RAM_MarioSpeedY       ; / 
CODE_01ED51:        A9 0C         LDA.B #$0C                
CODE_01ED53:        8D AF 18      STA.W $18AF               
CODE_01ED56:        A9 01         LDA.B #$01                
CODE_01ED58:        95 C2         STA RAM_SpriteState,X     
CODE_01ED5A:        A9 02         LDA.B #$02                ; \ Play sound effect 
CODE_01ED5C:        8D FA 1D      STA.W $1DFA               ; / 
CODE_01ED5F:        A9 1F         LDA.B #$1F                ; \ Play sound effect 
CODE_01ED61:        8D FC 1D      STA.W $1DFC               ; / 
CODE_01ED64:        22 B0 8B 02   JSL.L DisabledAddSmokeRt  
CODE_01ED68:        A9 20         LDA.B #$20                
CODE_01ED6A:        9D 3E 16      STA.W $163E,X             
CODE_01ED6D:        EE 97 16      INC.W $1697               
CODE_01ED70:        B5 C2         LDA RAM_SpriteState,X     
CODE_01ED72:        C9 01         CMP.B #$01                
CODE_01ED74:        D0 55         BNE Return01EDCB          
CODE_01ED76:        20 22 F6      JSR.W CODE_01F622         
CODE_01ED79:        A5 15         LDA RAM_ControllerA       
CODE_01ED7B:        29 03         AND.B #$03                
CODE_01ED7D:        F0 16         BEQ CODE_01ED95           
CODE_01ED7F:        3A            DEC A                     
CODE_01ED80:        DD 7C 15      CMP.W RAM_SpriteDir,X     
CODE_01ED83:        F0 10         BEQ CODE_01ED95           
CODE_01ED85:        BD AC 15      LDA.W $15AC,X             
CODE_01ED88:        1D 1C 15      ORA.W $151C,X             
CODE_01ED8B:        0D DC 18      ORA.W $18DC               
CODE_01ED8E:        D0 05         BNE CODE_01ED95           
CODE_01ED90:        A9 10         LDA.B #$10                ; \ Set turning timer 
CODE_01ED92:        9D AC 15      STA.W $15AC,X             ; / 
CODE_01ED95:        AD F3 13      LDA.W $13F3               
CODE_01ED98:        D0 04         BNE CODE_01ED9E           
CODE_01ED9A:        24 18         BIT $18                   
CODE_01ED9C:        10 2D         BPL Return01EDCB          
CODE_01ED9E:        A9 02         LDA.B #$02                
CODE_01EDA0:        9D E2 1F      STA.W $1FE2,X             
CODE_01EDA3:        74 C2         STZ RAM_SpriteState,X     
CODE_01EDA5:        A9 03         LDA.B #$03                ; \ Play sound effect 
CODE_01EDA7:        8D FA 1D      STA.W $1DFA               ; / 
CODE_01EDAA:        9C C1 0D      STZ.W RAM_OWHasYoshi      
CODE_01EDAD:        A5 7B         LDA RAM_MarioSpeedX       
CODE_01EDAF:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01EDB1:        A9 A0         LDA.B #$A0                
CODE_01EDB3:        A4 72         LDY RAM_IsFlying          
CODE_01EDB5:        D0 0A         BNE CODE_01EDC1           
CODE_01EDB7:        20 30 AD      JSR.W SubHorizPos         
CODE_01EDBA:        B9 C0 EB      LDA.W DATA_01EBC0,Y       
CODE_01EDBD:        85 7B         STA RAM_MarioSpeedX       
CODE_01EDBF:        A9 C0         LDA.B #$C0                
CODE_01EDC1:        85 7D         STA RAM_MarioSpeedY       
CODE_01EDC3:        9C 7A 18      STZ.W RAM_OnYoshi         
CODE_01EDC6:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_01EDC8:        20 CC ED      JSR.W CODE_01EDCC         
Return01EDCB:       60            RTS                       ; Return 

CODE_01EDCC:        A0 00         LDY.B #$00                
CODE_01EDCE:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01EDD0:        38            SEC                       
CODE_01EDD1:        F9 E2 ED      SBC.W DATA_01EDE2,Y       
CODE_01EDD4:        85 96         STA RAM_MarioYPos         
CODE_01EDD6:        85 D3         STA $D3                   
CODE_01EDD8:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01EDDB:        E9 00         SBC.B #$00                
CODE_01EDDD:        85 97         STA RAM_MarioYPosHi       
CODE_01EDDF:        85 D4         STA $D4                   
Return01EDE1:       60            RTS                       ; Return 


DATA_01EDE2:                      .db $04,$10

DATA_01EDE4:                      .db $06,$05,$05,$05,$0A,$05,$05,$0A
                                  .db $0A,$0B

YoshiWalkFrames:                  .db $02,$01,$00

YoshiPositionX:                   .db $02,$FE

DATA_01EDF3:                      .db $00,$FF

DATA_01EDF5:                      .db $03,$02,$01,$00

YoshiHeadTiles:                   .db $00,$01,$02,$03,$02,$10,$04,$05
                                  .db $00,$00,$FF,$FF,$00

YoshiBodyTiles:                   .db $06,$07,$08,$09,$0A,$0B,$06,$0C
                                  .db $0A,$0D,$0E,$0F,$0C

YoshiHeadDispX:                   .db $0A,$09,$0A,$06,$0A,$0A,$0A,$10
                                  .db $0A,$0A,$00,$00,$0A,$F6,$F7,$F6
                                  .db $FA,$F6,$F6,$F6,$F0,$F6,$F6,$00
                                  .db $00,$F6

DATA_01EE2D:                      .db $00,$00,$00,$00,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$00,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00
                                  .db $00,$FF

YoshiPositionY:                   .db $00,$01,$01,$00,$04,$00,$00,$04
                                  .db $03,$03,$00,$00,$04

YoshiHeadDispY:                   .db $00,$00,$01,$00,$00,$00,$00,$08
                                  .db $00,$00,$00,$00,$05

HandleOffYoshi:     BD 02 16      LDA.W $1602,X             
CODE_01EE64:        48            PHA                       
CODE_01EE65:        BC AC 15      LDY.W $15AC,X             
CODE_01EE68:        C0 08         CPY.B #$08                
CODE_01EE6A:        D0 11         BNE CODE_01EE7D           
CODE_01EE6C:        AD 19 14      LDA.W RAM_YoshiInPipe     
CODE_01EE6F:        05 9D         ORA RAM_SpritesLocked     
CODE_01EE71:        D0 0A         BNE CODE_01EE7D           
CODE_01EE73:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01EE76:        85 76         STA RAM_MarioDirection    
CODE_01EE78:        49 01         EOR.B #$01                
CODE_01EE7A:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01EE7D:        AD 19 14      LDA.W RAM_YoshiInPipe     
CODE_01EE80:        30 08         BMI CODE_01EE8A           
CODE_01EE82:        C9 02         CMP.B #$02                
CODE_01EE84:        D0 04         BNE CODE_01EE8A           
CODE_01EE86:        1A            INC A                     
CODE_01EE87:        9D 02 16      STA.W $1602,X             
CODE_01EE8A:        20 18 EF      JSR.W CODE_01EF18         
CODE_01EE8D:        A4 0E         LDY $0E                   
CODE_01EE8F:        B9 02 03      LDA.W OAM_Tile,Y          
CODE_01EE92:        85 00         STA $00                   
CODE_01EE94:        64 01         STZ $01                   
CODE_01EE96:        A9 06         LDA.B #$06                
CODE_01EE98:        99 02 03      STA.W OAM_Tile,Y          
CODE_01EE9B:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01EE9E:        B9 02 03      LDA.W OAM_Tile,Y          
CODE_01EEA1:        85 02         STA $02                   
CODE_01EEA3:        64 03         STZ $03                   
CODE_01EEA5:        A9 08         LDA.B #$08                
CODE_01EEA7:        99 02 03      STA.W OAM_Tile,Y          
CODE_01EEAA:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01EEAC:        A5 00         LDA $00                   
CODE_01EEAE:        0A            ASL                       
CODE_01EEAF:        0A            ASL                       
CODE_01EEB0:        0A            ASL                       
CODE_01EEB1:        0A            ASL                       
CODE_01EEB2:        0A            ASL                       
CODE_01EEB3:        18            CLC                       
CODE_01EEB4:        69 00 85      ADC.W #$8500              
CODE_01EEB7:        8D 8B 0D      STA.W $0D8B               
CODE_01EEBA:        18            CLC                       
CODE_01EEBB:        69 00 02      ADC.W #$0200              
CODE_01EEBE:        8D 95 0D      STA.W $0D95               
CODE_01EEC1:        A5 02         LDA $02                   
CODE_01EEC3:        0A            ASL                       
CODE_01EEC4:        0A            ASL                       
CODE_01EEC5:        0A            ASL                       
CODE_01EEC6:        0A            ASL                       
CODE_01EEC7:        0A            ASL                       
CODE_01EEC8:        18            CLC                       
CODE_01EEC9:        69 00 85      ADC.W #$8500              
CODE_01EECC:        8D 8D 0D      STA.W $0D8D               
CODE_01EECF:        18            CLC                       
CODE_01EED0:        69 00 02      ADC.W #$0200              
CODE_01EED3:        8D 97 0D      STA.W $0D97               
CODE_01EED6:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01EED8:        68            PLA                       
CODE_01EED9:        9D 02 16      STA.W $1602,X             
CODE_01EEDC:        20 A2 F0      JSR.W CODE_01F0A2         
CODE_01EEDF:        AD 10 14      LDA.W RAM_YoshiHasWingsB  ; \ Return if Yoshi doesn't have wings 
CODE_01EEE2:        C9 02         CMP.B #$02                ;  | 
CODE_01EEE4:        90 31         BCC Return01EF17          ; / 
CODE_01EEE6:        AD 7A 18      LDA.W RAM_OnYoshi         
CODE_01EEE9:        F0 28         BEQ CODE_01EF13           
CODE_01EEEB:        A5 72         LDA RAM_IsFlying          
CODE_01EEED:        D0 11         BNE CODE_01EF00           
CODE_01EEEF:        A5 7B         LDA RAM_MarioSpeedX       
CODE_01EEF1:        10 03         BPL CODE_01EEF6           
CODE_01EEF3:        49 FF         EOR.B #$FF                
CODE_01EEF5:        1A            INC A                     
CODE_01EEF6:        C9 28         CMP.B #$28                
CODE_01EEF8:        A9 01         LDA.B #$01                
CODE_01EEFA:        B0 17         BCS CODE_01EF13           
CODE_01EEFC:        A9 00         LDA.B #$00                
CODE_01EEFE:        80 13         BRA CODE_01EF13           

CODE_01EF00:        A5 14         LDA RAM_FrameCounterB     
CODE_01EF02:        4A            LSR                       
CODE_01EF03:        4A            LSR                       
CODE_01EF04:        A4 7D         LDY RAM_MarioSpeedY       
CODE_01EF06:        30 02         BMI CODE_01EF0A           
CODE_01EF08:        4A            LSR                       
CODE_01EF09:        4A            LSR                       
CODE_01EF0A:        29 01         AND.B #$01                
CODE_01EF0C:        D0 05         BNE CODE_01EF13           
CODE_01EF0E:        A0 21         LDY.B #$21                ; \ Play sound effect 
CODE_01EF10:        8C FC 1D      STY.W $1DFC               ; / 
CODE_01EF13:        22 23 BB 02   JSL.L CODE_02BB23         
Return01EF17:       60            RTS                       ; Return 

CODE_01EF18:        BC 02 16      LDY.W $1602,X             
CODE_01EF1B:        8C 5E 18      STY.W $185E               
CODE_01EF1E:        B9 F9 ED      LDA.W YoshiHeadTiles,Y    
CODE_01EF21:        9D 02 16      STA.W $1602,X             
CODE_01EF24:        85 0F         STA $0F                   
CODE_01EF26:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01EF28:        48            PHA                       
CODE_01EF29:        18            CLC                       
CODE_01EF2A:        79 47 EE      ADC.W YoshiPositionY,Y    
CODE_01EF2D:        95 D8         STA RAM_SpriteYLo,X       
CODE_01EF2F:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01EF32:        48            PHA                       
CODE_01EF33:        69 00         ADC.B #$00                
CODE_01EF35:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01EF38:        98            TYA                       
CODE_01EF39:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01EF3C:        F0 03         BEQ CODE_01EF41           
CODE_01EF3E:        18            CLC                       
CODE_01EF3F:        69 0D         ADC.B #$0D                
CODE_01EF41:        A8            TAY                       
CODE_01EF42:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01EF44:        48            PHA                       
CODE_01EF45:        18            CLC                       
CODE_01EF46:        79 13 EE      ADC.W YoshiHeadDispX,Y    
CODE_01EF49:        95 E4         STA RAM_SpriteXLo,X       
CODE_01EF4B:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01EF4E:        48            PHA                       
CODE_01EF4F:        79 2D EE      ADC.W DATA_01EE2D,Y       
CODE_01EF52:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01EF55:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_01EF58:        48            PHA                       
CODE_01EF59:        BD AC 15      LDA.W $15AC,X             
CODE_01EF5C:        0D 19 14      ORA.W RAM_YoshiInPipe     
CODE_01EF5F:        F0 05         BEQ CODE_01EF66           
CODE_01EF61:        A9 04         LDA.B #$04                
CODE_01EF63:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_01EF66:        BD EA 15      LDA.W RAM_SprOAMIndex,X   
CODE_01EF69:        85 0E         STA $0E                   
CODE_01EF6B:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01EF6E:        DA            PHX                       
CODE_01EF6F:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01EF72:        AE 5E 18      LDX.W $185E               
CODE_01EF75:        B9 01 03      LDA.W OAM_DispY,Y         
CODE_01EF78:        18            CLC                       
CODE_01EF79:        7D 54 EE      ADC.W YoshiHeadDispY,X    
CODE_01EF7C:        99 01 03      STA.W OAM_DispY,Y         
CODE_01EF7F:        FA            PLX                       
CODE_01EF80:        68            PLA                       
CODE_01EF81:        18            CLC                       
CODE_01EF82:        69 04         ADC.B #$04                
CODE_01EF84:        9D EA 15      STA.W RAM_SprOAMIndex,X   
CODE_01EF87:        68            PLA                       
CODE_01EF88:        9D E0 14      STA.W RAM_SpriteXHi,X     
CODE_01EF8B:        68            PLA                       
CODE_01EF8C:        95 E4         STA RAM_SpriteXLo,X       
CODE_01EF8E:        AC 5E 18      LDY.W $185E               
CODE_01EF91:        B9 06 EE      LDA.W YoshiBodyTiles,Y    
CODE_01EF94:        9D 02 16      STA.W $1602,X             
CODE_01EF97:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01EF99:        18            CLC                       
CODE_01EF9A:        69 10         ADC.B #$10                
CODE_01EF9C:        95 D8         STA RAM_SpriteYLo,X       
CODE_01EF9E:        90 03         BCC CODE_01EFA3           
CODE_01EFA0:        FE D4 14      INC.W RAM_SpriteYHi,X     
CODE_01EFA3:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01EFA6:        68            PLA                       
CODE_01EFA7:        9D D4 14      STA.W RAM_SpriteYHi,X     
CODE_01EFAA:        68            PLA                       
CODE_01EFAB:        95 D8         STA RAM_SpriteYLo,X       
CODE_01EFAD:        A4 0E         LDY $0E                   
CODE_01EFAF:        A5 0F         LDA $0F                   
CODE_01EFB1:        10 05         BPL CODE_01EFB8           
CODE_01EFB3:        A9 F0         LDA.B #$F0                
CODE_01EFB5:        99 01 03      STA.W OAM_DispY,Y         
CODE_01EFB8:        B5 C2         LDA RAM_SpriteState,X     
CODE_01EFBA:        D0 0A         BNE CODE_01EFC6           
CODE_01EFBC:        A5 14         LDA RAM_FrameCounterB     
CODE_01EFBE:        29 30         AND.B #$30                
CODE_01EFC0:        D0 19         BNE CODE_01EFDB           
CODE_01EFC2:        A9 2A         LDA.B #$2A                
CODE_01EFC4:        80 34         BRA CODE_01EFFA           

CODE_01EFC6:        C9 02         CMP.B #$02                
CODE_01EFC8:        D0 11         BNE CODE_01EFDB           
CODE_01EFCA:        BD 1C 15      LDA.W $151C,X             
CODE_01EFCD:        0D C6 13      ORA.W $13C6               
CODE_01EFD0:        D0 09         BNE CODE_01EFDB           
CODE_01EFD2:        A5 14         LDA RAM_FrameCounterB     
CODE_01EFD4:        29 10         AND.B #$10                
CODE_01EFD6:        F0 25         BEQ CODE_01EFFD           
CODE_01EFD8:        80 1E         BRA CODE_01EFF8           

Return01EFDA:       60            RTS                       ; Return 

CODE_01EFDB:        BD 94 15      LDA.W $1594,X             
CODE_01EFDE:        C9 03         CMP.B #$03                
CODE_01EFE0:        F0 0C         BEQ CODE_01EFEE           
CODE_01EFE2:        BD 1C 15      LDA.W $151C,X             
CODE_01EFE5:        F0 0C         BEQ CODE_01EFF3           
CODE_01EFE7:        B9 02 03      LDA.W OAM_Tile,Y          
CODE_01EFEA:        C9 24         CMP.B #$24                
CODE_01EFEC:        F0 05         BEQ CODE_01EFF3           
CODE_01EFEE:        A9 2A         LDA.B #$2A                
CODE_01EFF0:        99 02 03      STA.W OAM_Tile,Y          
CODE_01EFF3:        AD AE 18      LDA.W $18AE               
CODE_01EFF6:        F0 05         BEQ CODE_01EFFD           
CODE_01EFF8:        A9 0C         LDA.B #$0C                
CODE_01EFFA:        99 02 03      STA.W OAM_Tile,Y          
CODE_01EFFD:        BD 64 15      LDA.W $1564,X             
CODE_01F000:        AC AC 18      LDY.W $18AC               
CODE_01F003:        F0 0A         BEQ CODE_01F00F           
CODE_01F005:        C0 26         CPY.B #$26                
CODE_01F007:        B0 2F         BCS CODE_01F038           
CODE_01F009:        A5 14         LDA RAM_FrameCounterB     
CODE_01F00B:        29 18         AND.B #$18                
CODE_01F00D:        D0 29         BNE CODE_01F038           
CODE_01F00F:        BD 64 15      LDA.W $1564,X             
CODE_01F012:        C9 00         CMP.B #$00                
CODE_01F014:        F0 C4         BEQ Return01EFDA          
CODE_01F016:        A0 00         LDY.B #$00                
CODE_01F018:        C9 0F         CMP.B #$0F                
CODE_01F01A:        90 1E         BCC CODE_01F03A           
CODE_01F01C:        C9 1C         CMP.B #$1C                
CODE_01F01E:        90 18         BCC CODE_01F038           
CODE_01F020:        D0 0D         BNE CODE_01F02F           
CODE_01F022:        A5 0E         LDA $0E                   
CODE_01F024:        48            PHA                       
CODE_01F025:        22 F3 D1 02   JSL.L SetTreeTile         
CODE_01F029:        20 D3 F0      JSR.W CODE_01F0D3         
CODE_01F02C:        68            PLA                       
CODE_01F02D:        85 0E         STA $0E                   
CODE_01F02F:        EE FB 13      INC.W $13FB               
CODE_01F032:        A9 00         LDA.B #$00                
CODE_01F034:        A0 2A         LDY.B #$2A                
CODE_01F036:        80 02         BRA CODE_01F03A           

CODE_01F038:        A0 04         LDY.B #$04                
CODE_01F03A:        48            PHA                       
CODE_01F03B:        98            TYA                       
CODE_01F03C:        A4 0E         LDY $0E                   
CODE_01F03E:        99 02 03      STA.W OAM_Tile,Y          
CODE_01F041:        68            PLA                       
CODE_01F042:        C9 0F         CMP.B #$0F                
CODE_01F044:        B0 5A         BCS Return01F0A0          
CODE_01F046:        C9 05         CMP.B #$05                
CODE_01F048:        90 56         BCC Return01F0A0          
CODE_01F04A:        E9 05         SBC.B #$05                
CODE_01F04C:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01F04F:        F0 03         BEQ CODE_01F054           
CODE_01F051:        18            CLC                       
CODE_01F052:        69 0A         ADC.B #$0A                
CODE_01F054:        BC 02 16      LDY.W $1602,X             
CODE_01F057:        C0 0A         CPY.B #$0A                
CODE_01F059:        D0 03         BNE CODE_01F05E           
CODE_01F05B:        18            CLC                       
CODE_01F05C:        69 14         ADC.B #$14                
CODE_01F05E:        85 02         STA $02                   
CODE_01F060:        20 CB 80      JSR.W IsSprOffScreen      
CODE_01F063:        D0 3B         BNE Return01F0A0          
CODE_01F065:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01F067:        38            SEC                       
CODE_01F068:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01F06A:        85 00         STA $00                   
CODE_01F06C:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01F06E:        38            SEC                       
CODE_01F06F:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01F071:        85 01         STA $01                   
CODE_01F073:        DA            PHX                       
CODE_01F074:        A6 02         LDX $02                   
CODE_01F076:        A5 00         LDA $00                   
CODE_01F078:        18            CLC                       
CODE_01F079:        7F 76 C1 03   ADC.L DATA_03C176,X       
CODE_01F07D:        8D 00 03      STA.W OAM_DispX           
CODE_01F080:        A5 01         LDA $01                   
CODE_01F082:        18            CLC                       
CODE_01F083:        7F 9E C1 03   ADC.L DATA_03C19E,X       
CODE_01F087:        8D 01 03      STA.W OAM_DispY           
CODE_01F08A:        A9 3F         LDA.B #$3F                
CODE_01F08C:        8D 02 03      STA.W OAM_Tile            
CODE_01F08F:        FA            PLX                       
CODE_01F090:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01F093:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_01F096:        09 01         ORA.B #$01                
CODE_01F098:        8D 03 03      STA.W OAM_Prop            
CODE_01F09B:        A9 00         LDA.B #$00                
CODE_01F09D:        8D 60 04      STA.W OAM_TileSize        
Return01F0A0:       60            RTS                       ; Return 

Return01F0A1:       60            RTS                       ; Return 

CODE_01F0A2:        B5 C2         LDA RAM_SpriteState,X     
CODE_01F0A4:        C9 01         CMP.B #$01                
CODE_01F0A6:        D0 04         BNE CODE_01F0AC           
CODE_01F0A8:        22 D4 D0 02   JSL.L CODE_02D0D4         
CODE_01F0AC:        AD 10 14      LDA.W RAM_YoshiHasWingsB  ; \ Branch if $1410 == #$01 
CODE_01F0AF:        C9 01         CMP.B #$01                ;  | This never happens 
CODE_01F0B1:        F0 EE         BEQ Return01F0A1          ; / (fireball on Yoshi ability) 
CODE_01F0B3:        AD A3 14      LDA.W $14A3               
CODE_01F0B6:        C9 10         CMP.B #$10                
CODE_01F0B8:        D0 0A         BNE CODE_01F0C4           
CODE_01F0BA:        AD AE 18      LDA.W $18AE               
CODE_01F0BD:        D0 05         BNE CODE_01F0C4           
CODE_01F0BF:        A9 06         LDA.B #$06                
CODE_01F0C1:        8D AE 18      STA.W $18AE               
CODE_01F0C4:        BD 94 15      LDA.W $1594,X             
CODE_01F0C7:        22 DF 86 00   JSL.L ExecutePtr          

Ptrs01F0CB:            4B F1      .dw CODE_01F14B           
                       14 F3      .dw CODE_01F314           
                       32 F3      .dw CODE_01F332           
                       2E F1      .dw CODE_01F12E           

CODE_01F0D3:        A9 06         LDA.B #$06                ; \ Play sound effect 
CODE_01F0D5:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01F0D8:        22 4A B3 05   JSL.L CODE_05B34A         
CODE_01F0DC:        AD D6 18      LDA.W $18D6               
CODE_01F0DF:        F0 4C         BEQ Return01F12D          
CODE_01F0E1:        9C D6 18      STZ.W $18D6               
CODE_01F0E4:        C9 01         CMP.B #$01                
CODE_01F0E6:        D0 11         BNE CODE_01F0F9           
CODE_01F0E8:        EE D4 18      INC.W $18D4               
CODE_01F0EB:        AD D4 18      LDA.W $18D4               
CODE_01F0EE:        C9 0A         CMP.B #$0A                
CODE_01F0F0:        D0 3B         BNE Return01F12D          
CODE_01F0F2:        9C D4 18      STZ.W $18D4               
CODE_01F0F5:        A9 74         LDA.B #$74                
CODE_01F0F7:        80 2C         BRA CODE_01F125           

CODE_01F0F9:        C9 03         CMP.B #$03                
CODE_01F0FB:        D0 19         BNE CODE_01F116           
CODE_01F0FD:        A9 29         LDA.B #$29                ; \ Play sound effect 
CODE_01F0FF:        8D FC 1D      STA.W $1DFC               ; / 
CODE_01F102:        AD 32 0F      LDA.W $0F32               
CODE_01F105:        18            CLC                       
CODE_01F106:        69 02         ADC.B #$02                
CODE_01F108:        C9 0A         CMP.B #$0A                
CODE_01F10A:        90 05         BCC CODE_01F111           
ADDR_01F10C:        E9 0A         SBC.B #$0A                
ADDR_01F10E:        EE 31 0F      INC.W $0F31               
CODE_01F111:        8D 32 0F      STA.W $0F32               
CODE_01F114:        80 17         BRA Return01F12D          

CODE_01F116:        EE D5 18      INC.W $18D5               
CODE_01F119:        AD D5 18      LDA.W $18D5               
CODE_01F11C:        C9 02         CMP.B #$02                
CODE_01F11E:        D0 0D         BNE Return01F12D          
ADDR_01F120:        9C D5 18      STZ.W $18D5               
ADDR_01F123:        A9 6A         LDA.B #$6A                
CODE_01F125:        8D DA 18      STA.W $18DA               
CODE_01F128:        A0 20         LDY.B #$20                
CODE_01F12A:        8C DE 18      STY.W $18DE               
Return01F12D:       60            RTS                       ; Return 

CODE_01F12E:        BD 58 15      LDA.W $1558,X             
CODE_01F131:        D0 03         BNE Return01F136          
CODE_01F133:        9E 94 15      STZ.W $1594,X             
Return01F136:       60            RTS                       ; Return 


YoshiShellAbility:                .db $00,$00,$01,$02,$00,$00,$01,$02
                                  .db $01,$01,$01,$03,$02,$02

YoshiAbilityIndex:                .db $03,$02,$02,$03,$01,$00

CODE_01F14B:        AD 95 1B      LDA.W $1B95               
CODE_01F14E:        F0 05         BEQ CODE_01F155           
CODE_01F150:        A9 02         LDA.B #$02                ; \ Set Yoshi wing ability 
CODE_01F152:        8D 1E 14      STA.W RAM_YoshiHasWings   ; / 
CODE_01F155:        AD AC 18      LDA.W $18AC               
CODE_01F158:        F0 48         BEQ CODE_01F1A2           
CODE_01F15A:        BC 0E 16      LDY.W $160E,X             
CODE_01F15D:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01F160:        C9 80         CMP.B #$80                
CODE_01F162:        D0 03         BNE CODE_01F167           
CODE_01F164:        EE 1C 19      INC.W $191C               
CODE_01F167:        C9 0D         CMP.B #$0D                
CODE_01F169:        B0 37         BCS CODE_01F1A2           
CODE_01F16B:        5A            PHY                       
CODE_01F16C:        B9 7B 18      LDA.W $187B,Y             
CODE_01F16F:        C9 01         CMP.B #$01                
CODE_01F171:        A9 03         LDA.B #$03                
CODE_01F173:        B0 20         BCS CODE_01F195           
CODE_01F175:        BD F6 15      LDA.W RAM_SpritePal,X     ; \ Set yoshi stomp/wing ability, 
CODE_01F178:        4A            LSR                       ;  | based on palette of sprite and Yoshi 
CODE_01F179:        29 07         AND.B #$07                ;  | 
CODE_01F17B:        A8            TAY                       ;  | 
CODE_01F17C:        B9 45 F1      LDA.W YoshiAbilityIndex,Y ;  | 
CODE_01F17F:        0A            ASL                       ;  | 
CODE_01F180:        0A            ASL                       ;  | 
CODE_01F181:        85 00         STA $00                   ;  | 
CODE_01F183:        7A            PLY                       ;  | 
CODE_01F184:        5A            PHY                       ;  | 
CODE_01F185:        B9 F6 15      LDA.W RAM_SpritePal,Y     ;  | 
CODE_01F188:        4A            LSR                       ;  | 
CODE_01F189:        29 07         AND.B #$07                ;  | 
CODE_01F18B:        A8            TAY                       ;  | 
CODE_01F18C:        B9 45 F1      LDA.W YoshiAbilityIndex,Y ;  | 
CODE_01F18F:        05 00         ORA $00                   ;  | 
CODE_01F191:        A8            TAY                       ;  | 
CODE_01F192:        B9 37 F1      LDA.W YoshiShellAbility,Y ; / 
CODE_01F195:        48            PHA                       ; \ Set yoshi wing ability 
CODE_01F196:        29 02         AND.B #$02                ;  | ($141E = #$02) 
CODE_01F198:        8D 1E 14      STA.W RAM_YoshiHasWings   ; / 
CODE_01F19B:        68            PLA                       ; \ If Yoshi gets stomp ability, 
CODE_01F19C:        29 01         AND.B #$01                ;  | $18E7 = #$01 
CODE_01F19E:        8D E7 18      STA.W RAM_YoshiHasStomp   ; / 
CODE_01F1A1:        7A            PLY                       
CODE_01F1A2:        A5 14         LDA RAM_FrameCounterB     
CODE_01F1A4:        29 03         AND.B #$03                
CODE_01F1A6:        D0 1E         BNE CODE_01F1C6           
CODE_01F1A8:        AD AC 18      LDA.W $18AC               
CODE_01F1AB:        F0 19         BEQ CODE_01F1C6           
CODE_01F1AD:        CE AC 18      DEC.W $18AC               
CODE_01F1B0:        D0 14         BNE CODE_01F1C6           
CODE_01F1B2:        BC 0E 16      LDY.W $160E,X             
CODE_01F1B5:        A9 00         LDA.B #$00                
CODE_01F1B7:        99 C8 14      STA.W $14C8,Y             
CODE_01F1BA:        3A            DEC A                     
CODE_01F1BB:        9D 0E 16      STA.W $160E,X             
CODE_01F1BE:        A9 1B         LDA.B #$1B                
CODE_01F1C0:        9D 64 15      STA.W $1564,X             
CODE_01F1C3:        4C D3 F0      JMP.W CODE_01F0D3         

CODE_01F1C6:        AD AE 18      LDA.W $18AE               
CODE_01F1C9:        F0 14         BEQ CODE_01F1DF           
CODE_01F1CB:        CE AE 18      DEC.W $18AE               
CODE_01F1CE:        D0 0E         BNE Return01F1DE          
CODE_01F1D0:        FE 94 15      INC.W $1594,X             
CODE_01F1D3:        9E 1C 15      STZ.W $151C,X             
CODE_01F1D6:        A9 FF         LDA.B #$FF                
CODE_01F1D8:        9D 0E 16      STA.W $160E,X             
CODE_01F1DB:        9E 64 15      STZ.W $1564,X             
Return01F1DE:       60            RTS                       ; Return 

CODE_01F1DF:        B5 C2         LDA RAM_SpriteState,X     
CODE_01F1E1:        C9 01         CMP.B #$01                
CODE_01F1E3:        D0 F9         BNE Return01F1DE          
CODE_01F1E5:        24 16         BIT $16                   
CODE_01F1E7:        50 F5         BVC Return01F1DE          
CODE_01F1E9:        AD AC 18      LDA.W $18AC               
CODE_01F1EC:        D0 03         BNE CODE_01F1F1           
CODE_01F1EE:        4C 09 F3      JMP.W CODE_01F309         

CODE_01F1F1:        9C AC 18      STZ.W $18AC               
CODE_01F1F4:        BC 0E 16      LDY.W $160E,X             
CODE_01F1F7:        5A            PHY                       
CODE_01F1F8:        5A            PHY                       
CODE_01F1F9:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01F1FC:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01F1FE:        18            CLC                       
CODE_01F1FF:        79 05 F3      ADC.W DATA_01F305,Y       
CODE_01F202:        7A            PLY                       
CODE_01F203:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_01F206:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01F209:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01F20C:        79 07 F3      ADC.W DATA_01F307,Y       
CODE_01F20F:        7A            PLY                       
CODE_01F210:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_01F213:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01F215:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_01F218:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01F21B:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_01F21E:        A9 00         LDA.B #$00                
CODE_01F220:        99 C2 00      STA.W RAM_SpriteState,Y   
CODE_01F223:        99 D0 15      STA.W $15D0,Y             
CODE_01F226:        99 26 16      STA.W $1626,Y             
CODE_01F229:        AD DC 18      LDA.W $18DC               
CODE_01F22C:        C9 01         CMP.B #$01                
CODE_01F22E:        A9 0A         LDA.B #$0A                
CODE_01F230:        90 02         BCC CODE_01F234           
CODE_01F232:        A9 09         LDA.B #$09                ; \ Sprite status = Carryable 
CODE_01F234:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01F237:        DA            PHX                       
CODE_01F238:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01F23B:        99 7C 15      STA.W RAM_SpriteDir,Y     
CODE_01F23E:        AA            TAX                       
CODE_01F23F:        90 02         BCC CODE_01F243           
CODE_01F241:        E8            INX                       
CODE_01F242:        E8            INX                       
CODE_01F243:        BD 01 F3      LDA.W DATA_01F301,X       
CODE_01F246:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_01F249:        A9 00         LDA.B #$00                
CODE_01F24B:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_01F24E:        FA            PLX                       
CODE_01F24F:        A9 10         LDA.B #$10                
CODE_01F251:        9D 58 15      STA.W $1558,X             
CODE_01F254:        A9 03         LDA.B #$03                
CODE_01F256:        9D 94 15      STA.W $1594,X             
CODE_01F259:        A9 FF         LDA.B #$FF                
CODE_01F25B:        9D 0E 16      STA.W $160E,X             
CODE_01F25E:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01F261:        C9 0D         CMP.B #$0D                
CODE_01F263:        B0 7A         BCS CODE_01F2DF           
CODE_01F265:        B9 7B 18      LDA.W $187B,Y             
CODE_01F268:        D0 12         BNE CODE_01F27C           
CODE_01F26A:        B9 F6 15      LDA.W RAM_SpritePal,Y     
CODE_01F26D:        29 0E         AND.B #$0E                
CODE_01F26F:        C9 08         CMP.B #$08                
CODE_01F271:        F0 09         BEQ CODE_01F27C           
CODE_01F273:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01F276:        29 0E         AND.B #$0E                
CODE_01F278:        C9 08         CMP.B #$08                
CODE_01F27A:        D0 63         BNE CODE_01F2DF           
CODE_01F27C:        DA            PHX                       
CODE_01F27D:        BB            TYX                       
CODE_01F27E:        9E C8 14      STZ.W $14C8,X             
CODE_01F281:        A9 02         LDA.B #$02                
CODE_01F283:        85 00         STA $00                   
CODE_01F285:        20 95 F2      JSR.W CODE_01F295         
CODE_01F288:        20 95 F2      JSR.W CODE_01F295         
CODE_01F28B:        20 95 F2      JSR.W CODE_01F295         
CODE_01F28E:        FA            PLX                       
CODE_01F28F:        A9 17         LDA.B #$17                ; \ Play sound effect 
CODE_01F291:        8D FC 1D      STA.W $1DFC               ; / 
Return01F294:       60            RTS                       ; Return 

CODE_01F295:        20 EF 8E      JSR.W CODE_018EEF         
CODE_01F298:        A9 11         LDA.B #$11                ; \ Extended sprite = Yoshi fireball 
CODE_01F29A:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_01F29D:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01F29F:        99 1F 17      STA.W RAM_ExSpriteXLo,Y   
CODE_01F2A2:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01F2A5:        99 33 17      STA.W RAM_ExSpriteXHi,Y   
CODE_01F2A8:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01F2AA:        99 15 17      STA.W RAM_ExSpriteYLo,Y   
CODE_01F2AD:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01F2B0:        99 29 17      STA.W RAM_ExSpriteYHi,Y   
CODE_01F2B3:        A9 00         LDA.B #$00                
CODE_01F2B5:        99 79 17      STA.W $1779,Y             
CODE_01F2B8:        DA            PHX                       
CODE_01F2B9:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01F2BC:        4A            LSR                       
CODE_01F2BD:        A6 00         LDX $00                   
CODE_01F2BF:        BD D9 F2      LDA.W DATA_01F2D9,X       
CODE_01F2C2:        90 03         BCC CODE_01F2C7           
CODE_01F2C4:        49 FF         EOR.B #$FF                
CODE_01F2C6:        1A            INC A                     
CODE_01F2C7:        99 47 17      STA.W RAM_ExSprSpeedX,Y   
CODE_01F2CA:        BD DC F2      LDA.W DATA_01F2DC,X       
CODE_01F2CD:        99 3D 17      STA.W RAM_ExSprSpeedY,Y   
CODE_01F2D0:        A9 A0         LDA.B #$A0                
CODE_01F2D2:        99 6F 17      STA.W $176F,Y             
CODE_01F2D5:        FA            PLX                       
CODE_01F2D6:        C6 00         DEC $00                   
Return01F2D8:       60            RTS                       ; Return 


DATA_01F2D9:                      .db $28,$24,$24

DATA_01F2DC:                      .db $00,$F8,$08

CODE_01F2DF:        A9 20         LDA.B #$20                ; \ Play sound effect 
CODE_01F2E1:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01F2E4:        B9 86 16      LDA.W RAM_Tweaker1686,Y   ; \ Return if sprite doesn't spawn a new one 
CODE_01F2E7:        29 40         AND.B #$40                ;  | 
CODE_01F2E9:        F0 13         BEQ Return01F2FE          ; / 
CODE_01F2EB:        DA            PHX                       ; \ Load sprite to spawn and store it 
CODE_01F2EC:        BE 9E 00      LDX.W RAM_SpriteNum,Y     ;  | 
CODE_01F2EF:        BF C9 A7 01   LDA.L SpriteToSpawn,X     ;  | 
CODE_01F2F3:        FA            PLX                       ;  | 
CODE_01F2F4:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
CODE_01F2F7:        DA            PHX                       ; \ Load Tweaker bytes 
CODE_01F2F8:        BB            TYX                       ;  | 
CODE_01F2F9:        22 8B F7 07   JSL.L LoadSpriteTables    ;  | 
CODE_01F2FD:        FA            PLX                       ; / 
Return01F2FE:       60            RTS                       ; Return 


DATA_01F2FF:                      .db $20,$E0

DATA_01F301:                      .db $30,$D0,$10,$F0

DATA_01F305:                      .db $10,$F0

DATA_01F307:                      .db $00,$FF

CODE_01F309:        A9 12         LDA.B #$12                
CODE_01F30B:        8D A3 14      STA.W $14A3               
CODE_01F30E:        A9 21         LDA.B #$21                ; \ Play sound effect 
CODE_01F310:        8D FC 1D      STA.W $1DFC               ; / 
Return01F313:       60            RTS                       ; Return 

CODE_01F314:        BD 1C 15      LDA.W $151C,X             
CODE_01F317:        18            CLC                       
CODE_01F318:        69 03         ADC.B #$03                
CODE_01F31A:        9D 1C 15      STA.W $151C,X             
CODE_01F31D:        C9 20         CMP.B #$20                
CODE_01F31F:        B0 07         BCS CODE_01F328           
CODE_01F321:        20 FE F3      JSR.W CODE_01F3FE         
CODE_01F324:        20 B2 F4      JSR.W CODE_01F4B2         
Return01F327:       60            RTS                       ; Return 

CODE_01F328:        A9 08         LDA.B #$08                
CODE_01F32A:        9D 58 15      STA.W $1558,X             
CODE_01F32D:        FE 94 15      INC.W $1594,X             
CODE_01F330:        80 EF         BRA CODE_01F321           

CODE_01F332:        BD 58 15      LDA.W $1558,X             
CODE_01F335:        D0 EA         BNE CODE_01F321           
CODE_01F337:        BD 1C 15      LDA.W $151C,X             
CODE_01F33A:        38            SEC                       
CODE_01F33B:        E9 04         SBC.B #$04                
CODE_01F33D:        30 05         BMI CODE_01F344           
CODE_01F33F:        9D 1C 15      STA.W $151C,X             
CODE_01F342:        80 DD         BRA CODE_01F321           

CODE_01F344:        9E 1C 15      STZ.W $151C,X             
CODE_01F347:        9E 94 15      STZ.W $1594,X             
CODE_01F34A:        BC 0E 16      LDY.W $160E,X             
CODE_01F34D:        30 21         BMI CODE_01F370           
CODE_01F34F:        B9 86 16      LDA.W RAM_Tweaker1686,Y   
CODE_01F352:        29 02         AND.B #$02                
CODE_01F354:        F0 1D         BEQ CODE_01F373           
CODE_01F356:        A9 07         LDA.B #$07                ; \ Sprite status = Unused (todo: look here) 
CODE_01F358:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01F35B:        A9 FF         LDA.B #$FF                
CODE_01F35D:        8D AC 18      STA.W $18AC               
CODE_01F360:        B9 9E 00      LDA.W RAM_SpriteNum,Y     ; \ Branch if not a Koopa 
CODE_01F363:        C9 0D         CMP.B #$0D                ;  | (sprite number >= #$0D) 
CODE_01F365:        B0 09         BCS CODE_01F370           ; / 
CODE_01F367:        DA            PHX                       
CODE_01F368:        AA            TAX                       
CODE_01F369:        BD C9 A7      LDA.W SpriteToSpawn,X     
CODE_01F36C:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_01F36F:        FA            PLX                       
CODE_01F370:        4C FA F3      JMP.W CODE_01F3FA         

CODE_01F373:        A9 00         LDA.B #$00                
CODE_01F375:        99 C8 14      STA.W $14C8,Y             
CODE_01F378:        A9 1B         LDA.B #$1B                
CODE_01F37A:        9D 64 15      STA.W $1564,X             
CODE_01F37D:        A9 FF         LDA.B #$FF                
CODE_01F37F:        9D 0E 16      STA.W $160E,X             
CODE_01F382:        84 00         STY $00                   
CODE_01F384:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01F387:        C9 9D         CMP.B #$9D                
CODE_01F389:        D0 14         BNE CODE_01F39F           
ADDR_01F38B:        B9 C2 00      LDA.W RAM_SpriteState,Y   
ADDR_01F38E:        C9 03         CMP.B #$03                
ADDR_01F390:        D0 0D         BNE CODE_01F39F           
ADDR_01F392:        A9 74         LDA.B #$74                ; \ Sprite = Mushroom 
ADDR_01F394:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
ADDR_01F397:        B9 7A 16      LDA.W RAM_Tweaker167A,Y   ; \ Set "Gives powerup when eaten" bit 
ADDR_01F39A:        09 40         ORA.B #$40                ;  | 
ADDR_01F39C:        99 7A 16      STA.W RAM_Tweaker167A,Y   ; / 
CODE_01F39F:        B9 9E 00      LDA.W RAM_SpriteNum,Y     ; \ Branch if not Changing Item 
CODE_01F3A2:        C9 81         CMP.B #$81                ;  | 
CODE_01F3A4:        D0 14         BNE CODE_01F3BA           ; / 
ADDR_01F3A6:        B9 7B 18      LDA.W $187B,Y             
ADDR_01F3A9:        4A            LSR                       
ADDR_01F3AA:        4A            LSR                       
ADDR_01F3AB:        4A            LSR                       
ADDR_01F3AC:        4A            LSR                       
ADDR_01F3AD:        4A            LSR                       
ADDR_01F3AE:        4A            LSR                       
ADDR_01F3AF:        29 03         AND.B #$03                
ADDR_01F3B1:        A8            TAY                       
ADDR_01F3B2:        B9 13 C3      LDA.W ChangingItemSprite,Y 
ADDR_01F3B5:        A4 00         LDY $00                   
ADDR_01F3B7:        99 9E 00      STA.W RAM_SpriteNum,Y     
CODE_01F3BA:        48            PHA                       
CODE_01F3BB:        A4 00         LDY $00                   
CODE_01F3BD:        B9 7A 16      LDA.W RAM_Tweaker167A,Y   
CODE_01F3C0:        0A            ASL                       
CODE_01F3C1:        0A            ASL                       
CODE_01F3C2:        68            PLA                       
CODE_01F3C3:        90 16         BCC CODE_01F3DB           
CODE_01F3C5:        DA            PHX                       
CODE_01F3C6:        BB            TYX                       
CODE_01F3C7:        74 C2         STZ RAM_SpriteState,X     
CODE_01F3C9:        20 BF C4      JSR.W CODE_01C4BF         
CODE_01F3CC:        FA            PLX                       
CODE_01F3CD:        AC DC 18      LDY.W $18DC               
CODE_01F3D0:        B9 D9 F3      LDA.W DATA_01F3D9,Y       
CODE_01F3D3:        9D 02 16      STA.W $1602,X             
CODE_01F3D6:        4C 21 F3      JMP.W CODE_01F321         


DATA_01F3D9:                      .db $00,$04

CODE_01F3DB:        C9 7E         CMP.B #$7E                
CODE_01F3DD:        D0 18         BNE CODE_01F3F7           
ADDR_01F3DF:        B9 C2 00      LDA.W RAM_SpriteState,Y   
ADDR_01F3E2:        F0 13         BEQ CODE_01F3F7           
ADDR_01F3E4:        C9 02         CMP.B #$02                
ADDR_01F3E6:        D0 09         BNE ADDR_01F3F1           
ADDR_01F3E8:        A9 08         LDA.B #$08                
ADDR_01F3EA:        85 71         STA RAM_MarioAnimation    
ADDR_01F3EC:        A9 03         LDA.B #$03                ; \ Play sound effect 
ADDR_01F3EE:        8D FC 1D      STA.W $1DFC               ; / 
ADDR_01F3F1:        20 CD F6      JSR.W CODE_01F6CD         
ADDR_01F3F4:        4C 21 F3      JMP.W CODE_01F321         

CODE_01F3F7:        20 D3 F0      JSR.W CODE_01F0D3         
CODE_01F3FA:        4C 21 F3      JMP.W CODE_01F321         

Return01F3FD:       60            RTS                       ; Return 

CODE_01F3FE:        BD A0 15      LDA.W RAM_OffscreenHorz,X ; \ Branch if sprite off screen... 
CODE_01F401:        1D 6C 18      ORA.W RAM_OffscreenVert,X ;  | 
CODE_01F404:        0D 19 14      ORA.W RAM_YoshiInPipe     ;  | ...or going down pipe 
CODE_01F407:        D0 F4         BNE Return01F3FD          ; / 
CODE_01F409:        BC 02 16      LDY.W $1602,X             
CODE_01F40C:        B9 1A F6      LDA.W DATA_01F61A,Y       
CODE_01F40F:        8D 5E 18      STA.W $185E               
CODE_01F412:        18            CLC                       
CODE_01F413:        75 D8         ADC RAM_SpriteYLo,X       
CODE_01F415:        38            SEC                       
CODE_01F416:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01F418:        85 01         STA $01                   
CODE_01F41A:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01F41D:        D0 05         BNE CODE_01F424           
CODE_01F41F:        98            TYA                       
CODE_01F420:        18            CLC                       
CODE_01F421:        69 08         ADC.B #$08                
CODE_01F423:        A8            TAY                       
CODE_01F424:        B9 0A F6      LDA.W DATA_01F60A,Y       
CODE_01F427:        85 0D         STA $0D                   
CODE_01F429:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01F42B:        38            SEC                       
CODE_01F42C:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01F42E:        18            CLC                       
CODE_01F42F:        65 0D         ADC $0D                   
CODE_01F431:        85 00         STA $00                   
CODE_01F433:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01F436:        D0 04         BNE CODE_01F43C           
CODE_01F438:        B0 C3         BCS Return01F3FD          
CODE_01F43A:        80 02         BRA CODE_01F43E           

CODE_01F43C:        90 BF         BCC Return01F3FD          
CODE_01F43E:        BD 1C 15      LDA.W $151C,X             
CODE_01F441:        8D 05 42      STA.W $4205               ; Dividend (High-Byte)
CODE_01F444:        9C 04 42      STZ.W $4204               ; Dividend (Low Byte)
CODE_01F447:        A9 04         LDA.B #$04                
CODE_01F449:        8D 06 42      STA.W $4206               ; Divisor B
CODE_01F44C:        EA            NOP                       
CODE_01F44D:        EA            NOP                       
CODE_01F44E:        EA            NOP                       
CODE_01F44F:        EA            NOP                       
CODE_01F450:        EA            NOP                       
CODE_01F451:        EA            NOP                       
CODE_01F452:        EA            NOP                       
CODE_01F453:        EA            NOP                       
CODE_01F454:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01F457:        85 07         STA $07                   
CODE_01F459:        4A            LSR                       
CODE_01F45A:        AD 15 42      LDA.W $4215               ; Quotient of Divide Result (High Byte)
CODE_01F45D:        90 03         BCC CODE_01F462           
CODE_01F45F:        49 FF         EOR.B #$FF                
CODE_01F461:        1A            INC A                     
CODE_01F462:        85 05         STA $05                   
CODE_01F464:        A9 04         LDA.B #$04                
CODE_01F466:        85 06         STA $06                   
CODE_01F468:        A0 0C         LDY.B #$0C                
CODE_01F46A:        A5 00         LDA $00                   
CODE_01F46C:        99 00 02      STA.W OAM_ExtendedDispX,Y 
CODE_01F46F:        18            CLC                       
CODE_01F470:        65 05         ADC $05                   
CODE_01F472:        85 00         STA $00                   
CODE_01F474:        A5 05         LDA $05                   
CODE_01F476:        10 04         BPL CODE_01F47C           
CODE_01F478:        90 37         BCC Return01F4B1          
CODE_01F47A:        80 02         BRA CODE_01F47E           

CODE_01F47C:        B0 33         BCS Return01F4B1          
CODE_01F47E:        A5 01         LDA $01                   
CODE_01F480:        99 01 02      STA.W OAM_ExtendedDispY,Y 
CODE_01F483:        A5 06         LDA $06                   
CODE_01F485:        C9 01         CMP.B #$01                
CODE_01F487:        A9 76         LDA.B #$76                
CODE_01F489:        B0 02         BCS CODE_01F48D           
CODE_01F48B:        A9 66         LDA.B #$66                
CODE_01F48D:        99 02 02      STA.W OAM_ExtendedTile,Y  
CODE_01F490:        A5 07         LDA $07                   
CODE_01F492:        4A            LSR                       
CODE_01F493:        A9 09         LDA.B #$09                
CODE_01F495:        B0 02         BCS CODE_01F499           
CODE_01F497:        09 40         ORA.B #$40                
CODE_01F499:        05 64         ORA $64                   
CODE_01F49B:        99 03 02      STA.W OAM_ExtendedProp,Y  
CODE_01F49E:        5A            PHY                       
CODE_01F49F:        98            TYA                       
CODE_01F4A0:        4A            LSR                       
CODE_01F4A1:        4A            LSR                       
CODE_01F4A2:        A8            TAY                       
CODE_01F4A3:        A9 00         LDA.B #$00                
CODE_01F4A5:        99 20 04      STA.W $0420,Y             
CODE_01F4A8:        7A            PLY                       
CODE_01F4A9:        C8            INY                       
CODE_01F4AA:        C8            INY                       
CODE_01F4AB:        C8            INY                       
CODE_01F4AC:        C8            INY                       
CODE_01F4AD:        C6 06         DEC $06                   
CODE_01F4AF:        10 B9         BPL CODE_01F46A           
Return01F4B1:       60            RTS                       ; Return 

CODE_01F4B2:        BD 0E 16      LDA.W $160E,X             
CODE_01F4B5:        30 6D         BMI CODE_01F524           
CODE_01F4B7:        A0 00         LDY.B #$00                
CODE_01F4B9:        A5 0D         LDA $0D                   
CODE_01F4BB:        30 06         BMI CODE_01F4C3           
CODE_01F4BD:        18            CLC                       
CODE_01F4BE:        7D 1C 15      ADC.W $151C,X             
CODE_01F4C1:        80 09         BRA CODE_01F4CC           

CODE_01F4C3:        BD 1C 15      LDA.W $151C,X             
CODE_01F4C6:        49 FF         EOR.B #$FF                
CODE_01F4C8:        1A            INC A                     
CODE_01F4C9:        18            CLC                       
CODE_01F4CA:        65 0D         ADC $0D                   
CODE_01F4CC:        38            SEC                       
CODE_01F4CD:        E9 04         SBC.B #$04                
CODE_01F4CF:        10 01         BPL CODE_01F4D2           
CODE_01F4D1:        88            DEY                       
CODE_01F4D2:        5A            PHY                       
CODE_01F4D3:        18            CLC                       
CODE_01F4D4:        75 E4         ADC RAM_SpriteXLo,X       
CODE_01F4D6:        BC 0E 16      LDY.W $160E,X             
CODE_01F4D9:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_01F4DC:        7A            PLY                       
CODE_01F4DD:        98            TYA                       
CODE_01F4DE:        7D E0 14      ADC.W RAM_SpriteXHi,X     
CODE_01F4E1:        BC 0E 16      LDY.W $160E,X             
CODE_01F4E4:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_01F4E7:        A9 FC         LDA.B #$FC                
CODE_01F4E9:        85 00         STA $00                   
CODE_01F4EB:        B9 62 16      LDA.W RAM_Tweaker1662,Y   
CODE_01F4EE:        29 40         AND.B #$40                
CODE_01F4F0:        D0 0B         BNE CODE_01F4FD           
CODE_01F4F2:        B9 0F 19      LDA.W RAM_Tweaker190F,Y   ; \ Branch if "Death frame 2 tiles high" 
CODE_01F4F5:        29 20         AND.B #$20                ;  | is NOT set 
CODE_01F4F7:        F0 04         BEQ CODE_01F4FD           ; / 
CODE_01F4F9:        A9 F8         LDA.B #$F8                
CODE_01F4FB:        85 00         STA $00                   
CODE_01F4FD:        64 01         STZ $01                   
CODE_01F4FF:        A5 00         LDA $00                   
CODE_01F501:        18            CLC                       
CODE_01F502:        6D 5E 18      ADC.W $185E               
CODE_01F505:        10 02         BPL CODE_01F509           
ADDR_01F507:        C6 01         DEC $01                   
CODE_01F509:        18            CLC                       
CODE_01F50A:        75 D8         ADC RAM_SpriteYLo,X       
CODE_01F50C:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_01F50F:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01F512:        65 01         ADC $01                   
CODE_01F514:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_01F517:        A9 00         LDA.B #$00                
CODE_01F519:        99 AA 00      STA.W RAM_SpriteSpeedY,Y  
CODE_01F51C:        99 B6 00      STA.W RAM_SpriteSpeedX,Y  
CODE_01F51F:        1A            INC A                     
CODE_01F520:        99 D0 15      STA.W $15D0,Y             
Return01F523:       60            RTS                       ; Return 

CODE_01F524:        5A            PHY                       
CODE_01F525:        A0 00         LDY.B #$00                
CODE_01F527:        A5 0D         LDA $0D                   
CODE_01F529:        30 06         BMI CODE_01F531           
CODE_01F52B:        18            CLC                       
CODE_01F52C:        7D 1C 15      ADC.W $151C,X             
CODE_01F52F:        80 09         BRA CODE_01F53A           

CODE_01F531:        BD 1C 15      LDA.W $151C,X             
CODE_01F534:        49 FF         EOR.B #$FF                
CODE_01F536:        1A            INC A                     
CODE_01F537:        18            CLC                       
CODE_01F538:        65 0D         ADC $0D                   
CODE_01F53A:        18            CLC                       
CODE_01F53B:        69 00         ADC.B #$00                
CODE_01F53D:        10 01         BPL CODE_01F540           
CODE_01F53F:        88            DEY                       
CODE_01F540:        18            CLC                       
CODE_01F541:        75 E4         ADC RAM_SpriteXLo,X       
CODE_01F543:        85 00         STA $00                   
CODE_01F545:        98            TYA                       
CODE_01F546:        7D E0 14      ADC.W RAM_SpriteXHi,X     
CODE_01F549:        85 08         STA $08                   
CODE_01F54B:        7A            PLY                       
CODE_01F54C:        AD 5E 18      LDA.W $185E               
CODE_01F54F:        18            CLC                       
CODE_01F550:        69 02         ADC.B #$02                
CODE_01F552:        18            CLC                       
CODE_01F553:        75 D8         ADC RAM_SpriteYLo,X       
CODE_01F555:        85 01         STA $01                   
CODE_01F557:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01F55A:        69 00         ADC.B #$00                
CODE_01F55C:        85 09         STA $09                   
CODE_01F55E:        A9 08         LDA.B #$08                
CODE_01F560:        85 02         STA $02                   
CODE_01F562:        A9 04         LDA.B #$04                
CODE_01F564:        85 03         STA $03                   
CODE_01F566:        A0 0B         LDY.B #$0B                ; Loop over spites: 
CODE_01F568:        8C 95 16      STY.W $1695               
CODE_01F56B:        CC E9 15      CPY.W $15E9               
CODE_01F56E:        F0 16         BEQ CODE_01F586           
CODE_01F570:        BD 0E 16      LDA.W $160E,X             
CODE_01F573:        10 11         BPL CODE_01F586           
CODE_01F575:        B9 C8 14      LDA.W $14C8,Y             ; \ Skip sprite if sprite status < 8 
CODE_01F578:        C9 08         CMP.B #$08                ;  | 
CODE_01F57A:        90 0A         BCC CODE_01F586           ; / 
CODE_01F57C:        B9 32 16      LDA.W RAM_SprBehindScrn,Y ; \ Skip sprite if behind scenery 
CODE_01F57F:        D0 05         BNE CODE_01F586           ; / 
CODE_01F581:        5A            PHY                       
CODE_01F582:        20 8E F5      JSR.W TryEatSprite        
CODE_01F585:        7A            PLY                       
CODE_01F586:        88            DEY                       
CODE_01F587:        10 DF         BPL CODE_01F568           
CODE_01F589:        22 FA B9 02   JSL.L CODE_02B9FA         
Return01F58D:       60            RTS                       ; Return 

TryEatSprite:       DA            PHX                       
CODE_01F58F:        BB            TYX                       
CODE_01F590:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_01F594:        FA            PLX                       
CODE_01F595:        22 2B B7 03   JSL.L CheckForContact     
CODE_01F599:        90 6E         BCC Return01F609          
CODE_01F59B:        B9 86 16      LDA.W RAM_Tweaker1686,Y   ; \ If sprite inedible 
CODE_01F59E:        4A            LSR                       ;  | 
CODE_01F59F:        90 06         BCC EatSprite             ;  | 
CODE_01F5A1:        A9 01         LDA.B #$01                ;  | Play sound effect 
CODE_01F5A3:        8D F9 1D      STA.W $1DF9               ;  | 
Return01F5A6:       60            RTS                       ; / Return 

EatSprite:          B9 9E 00      LDA.W RAM_SpriteNum,Y     ; \ Branch if sprite being eaten not Pokey 
CODE_01F5AA:        C9 70         CMP.B #$70                ;  | 
CODE_01F5AC:        D0 4D         BNE CODE_01F5FB           ; / 
SpltPokeyInto2Sprs: 8C 5E 18      STY.W $185E               ; $185E = Index of sprite being eaten 
CODE_01F5B1:        A5 01         LDA $01                   
CODE_01F5B3:        38            SEC                       
CODE_01F5B4:        F9 D8 00      SBC.W RAM_SpriteYLo,Y     
CODE_01F5B7:        18            CLC                       
CODE_01F5B8:        69 00         ADC.B #$00                
CODE_01F5BA:        DA            PHX                       
CODE_01F5BB:        BB            TYX                       ; X = Index of sprite being eaten 
CODE_01F5BC:        22 1C B8 02   JSL.L RemovePokeySegment  
CODE_01F5C0:        FA            PLX                       
CODE_01F5C1:        22 E4 A9 02   JSL.L FindFreeSprSlot     ; \ Return if no free slots 
CODE_01F5C5:        30 42         BMI Return01F609          ; / 
CODE_01F5C7:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_01F5C9:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01F5CC:        A9 70         LDA.B #$70                ; \ Sprite = Pokey 
CODE_01F5CE:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
CODE_01F5D1:        A5 00         LDA $00                   
CODE_01F5D3:        99 E4 00      STA.W RAM_SpriteXLo,Y     
CODE_01F5D6:        A5 08         LDA $08                   
CODE_01F5D8:        99 E0 14      STA.W RAM_SpriteXHi,Y     
CODE_01F5DB:        A5 01         LDA $01                   
CODE_01F5DD:        99 D8 00      STA.W RAM_SpriteYLo,Y     
CODE_01F5E0:        A5 09         LDA $09                   
CODE_01F5E2:        99 D4 14      STA.W RAM_SpriteYHi,Y     
CODE_01F5E5:        DA            PHX                       
CODE_01F5E6:        BB            TYX                       ; X = Index of new sprite 
CODE_01F5E7:        22 D2 F7 07   JSL.L InitSpriteTables    ; Reset sprite tables 
CODE_01F5EB:        AE 5E 18      LDX.W $185E               ; X = Index of sprite being eaten 
CODE_01F5EE:        B5 C2         LDA RAM_SpriteState,X     
CODE_01F5F0:        25 0D         AND $0D                   
CODE_01F5F2:        99 C2 00      STA.W RAM_SpriteState,Y   ; y = index of new sptr here?? 
CODE_01F5F5:        A9 01         LDA.B #$01                
CODE_01F5F7:        99 34 15      STA.W $1534,Y             
CODE_01F5FA:        FA            PLX                       
CODE_01F5FB:        98            TYA                       ; \ $160E,x = Index of sprite being eaten 
CODE_01F5FC:        9D 0E 16      STA.W $160E,X             ; / 
CODE_01F5FF:        A9 02         LDA.B #$02                
CODE_01F601:        9D 94 15      STA.W $1594,X             
CODE_01F604:        A9 0A         LDA.B #$0A                
CODE_01F606:        9D 58 15      STA.W $1558,X             
Return01F609:       60            RTS                       ; Return 


DATA_01F60A:                      .db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F0
                                  .db $13,$13,$13,$13,$13,$13,$13,$18
DATA_01F61A:                      .db $08,$08,$08,$08,$08,$08,$08,$13

CODE_01F622:        BD 3E 16      LDA.W $163E,X             
CODE_01F625:        05 9D         ORA RAM_SpritesLocked     
CODE_01F627:        D0 3E         BNE Return01F667          
CODE_01F629:        A0 0B         LDY.B #$0B                
CODE_01F62B:        8C 95 16      STY.W $1695               
CODE_01F62E:        98            TYA                       
CODE_01F62F:        45 13         EOR RAM_FrameCounter      
CODE_01F631:        29 01         AND.B #$01                
CODE_01F633:        D0 2C         BNE CODE_01F661           
CODE_01F635:        98            TYA                       
CODE_01F636:        DD 0E 16      CMP.W $160E,X             
CODE_01F639:        F0 26         BEQ CODE_01F661           
CODE_01F63B:        CC E9 15      CPY.W $15E9               
CODE_01F63E:        F0 21         BEQ CODE_01F661           
CODE_01F640:        B9 C8 14      LDA.W $14C8,Y             
CODE_01F643:        C9 08         CMP.B #$08                
CODE_01F645:        90 1A         BCC CODE_01F661           
CODE_01F647:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01F64A:        B9 C8 14      LDA.W $14C8,Y             
CODE_01F64D:        C9 09         CMP.B #$09                
CODE_01F64F:        F0 10         BEQ CODE_01F661           
CODE_01F651:        B9 7A 16      LDA.W RAM_Tweaker167A,Y   
CODE_01F654:        29 02         AND.B #$02                
CODE_01F656:        19 D0 15      ORA.W $15D0,Y             
CODE_01F659:        19 32 16      ORA.W RAM_SprBehindScrn,Y 
CODE_01F65C:        D0 03         BNE CODE_01F661           
CODE_01F65E:        20 68 F6      JSR.W CODE_01F668         
CODE_01F661:        AC 95 16      LDY.W $1695               
CODE_01F664:        88            DEY                       
CODE_01F665:        10 C4         BPL CODE_01F62B           
Return01F667:       60            RTS                       ; Return 

CODE_01F668:        DA            PHX                       
CODE_01F669:        BB            TYX                       
CODE_01F66A:        22 E5 B6 03   JSL.L GetSpriteClippingB  
CODE_01F66E:        FA            PLX                       
CODE_01F66F:        22 9F B6 03   JSL.L GetSpriteClippingA  
CODE_01F673:        22 2B B7 03   JSL.L CheckForContact     
CODE_01F677:        90 EE         BCC Return01F667          
CODE_01F679:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01F67C:        C9 9D         CMP.B #$9D                
CODE_01F67E:        F0 E7         BEQ Return01F667          
CODE_01F680:        C9 15         CMP.B #$15                
CODE_01F682:        F0 1A         BEQ CODE_01F69E           
CODE_01F684:        C9 16         CMP.B #$16                
CODE_01F686:        F0 16         BEQ CODE_01F69E           
CODE_01F688:        C9 04         CMP.B #$04                
CODE_01F68A:        B0 17         BCS CODE_01F6A3           
CODE_01F68C:        C9 02         CMP.B #$02                
CODE_01F68E:        F0 13         BEQ CODE_01F6A3           
ADDR_01F690:        B9 3E 16      LDA.W $163E,Y             
ADDR_01F693:        10 0E         BPL CODE_01F6A3           
CODE_01F695:        5A            PHY                       
CODE_01F696:        DA            PHX                       
CODE_01F697:        BB            TYX                       
CODE_01F698:        20 2A B1      JSR.W CODE_01B12A         
CODE_01F69B:        FA            PLX                       
CODE_01F69C:        7A            PLY                       
Return01F69D:       60            RTS                       ; Return 

CODE_01F69E:        B9 4A 16      LDA.W $164A,Y             
CODE_01F6A1:        F0 F2         BEQ CODE_01F695           
CODE_01F6A3:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01F6A6:        C9 BF         CMP.B #$BF                
CODE_01F6A8:        D0 0A         BNE CODE_01F6B4           
CODE_01F6AA:        A5 96         LDA RAM_MarioYPos         
CODE_01F6AC:        38            SEC                       
CODE_01F6AD:        F9 D8 00      SBC.W RAM_SpriteYLo,Y     
CODE_01F6B0:        C9 E8         CMP.B #$E8                
CODE_01F6B2:        30 28         BMI Return01F6DC          
CODE_01F6B4:        B9 9E 00      LDA.W RAM_SpriteNum,Y     
CODE_01F6B7:        C9 7E         CMP.B #$7E                
CODE_01F6B9:        D0 22         BNE CODE_01F6DD           
CODE_01F6BB:        B9 C2 00      LDA.W RAM_SpriteState,Y   
CODE_01F6BE:        F0 1C         BEQ Return01F6DC          
CODE_01F6C0:        C9 02         CMP.B #$02                
CODE_01F6C2:        D0 09         BNE CODE_01F6CD           
CODE_01F6C4:        A9 08         LDA.B #$08                
CODE_01F6C6:        85 71         STA RAM_MarioAnimation    
CODE_01F6C8:        A9 03         LDA.B #$03                ; \ Play sound effect 
CODE_01F6CA:        8D FC 1D      STA.W $1DFC               ; / 
CODE_01F6CD:        A9 40         LDA.B #$40                
CODE_01F6CF:        8D AA 14      STA.W $14AA               
CODE_01F6D2:        A9 02         LDA.B #$02                ; \ Set Yoshi wing ability 
CODE_01F6D4:        8D 1E 14      STA.W RAM_YoshiHasWings   ; / 
CODE_01F6D7:        A9 00         LDA.B #$00                
CODE_01F6D9:        99 C8 14      STA.W $14C8,Y             
Return01F6DC:       60            RTS                       ; Return 

CODE_01F6DD:        C9 4E         CMP.B #$4E                
CODE_01F6DF:        F0 04         BEQ CODE_01F6E5           
CODE_01F6E1:        C9 4D         CMP.B #$4D                
CODE_01F6E3:        D0 07         BNE CODE_01F6EC           
CODE_01F6E5:        B9 C2 00      LDA.W RAM_SpriteState,Y   
CODE_01F6E8:        C9 02         CMP.B #$02                
CODE_01F6EA:        90 F0         BCC Return01F6DC          
CODE_01F6EC:        A5 05         LDA $05                   
CODE_01F6EE:        18            CLC                       
CODE_01F6EF:        69 0D         ADC.B #$0D                
CODE_01F6F1:        C5 01         CMP $01                   
CODE_01F6F3:        30 56         BMI Return01F74B          
CODE_01F6F5:        B9 C8 14      LDA.W $14C8,Y             
CODE_01F6F8:        C9 0A         CMP.B #$0A                
CODE_01F6FA:        D0 12         BNE CODE_01F70E           
CODE_01F6FC:        DA            PHX                       
CODE_01F6FD:        BB            TYX                       
CODE_01F6FE:        20 30 AD      JSR.W SubHorizPos         
CODE_01F701:        84 00         STY $00                   
CODE_01F703:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01F705:        FA            PLX                       
CODE_01F706:        0A            ASL                       
CODE_01F707:        2A            ROL                       
CODE_01F708:        29 01         AND.B #$01                
CODE_01F70A:        C5 00         CMP $00                   
CODE_01F70C:        D0 3D         BNE Return01F74B          
CODE_01F70E:        AD 90 14      LDA.W $1490               ; \ Branch if Mario has star 
CODE_01F711:        D0 38         BNE Return01F74B          ; / 
CODE_01F713:        A9 10         LDA.B #$10                
CODE_01F715:        9D 3E 16      STA.W $163E,X             
CODE_01F718:        A9 03         LDA.B #$03                ; \ Play sound effect 
CODE_01F71A:        8D FA 1D      STA.W $1DFA               ; / 
CODE_01F71D:        A9 13         LDA.B #$13                ; \ Play sound effect 
CODE_01F71F:        8D FC 1D      STA.W $1DFC               ; / 
CODE_01F722:        A9 02         LDA.B #$02                
CODE_01F724:        95 C2         STA RAM_SpriteState,X     
CODE_01F726:        9C 7A 18      STZ.W RAM_OnYoshi         
CODE_01F729:        A9 C0         LDA.B #$C0                
CODE_01F72B:        85 7D         STA RAM_MarioSpeedY       
CODE_01F72D:        64 7B         STZ RAM_MarioSpeedX       
CODE_01F72F:        20 30 AD      JSR.W SubHorizPos         
CODE_01F732:        B9 BE EB      LDA.W DATA_01EBBE,Y       
CODE_01F735:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01F737:        9E 94 15      STZ.W $1594,X             
CODE_01F73A:        9E 1C 15      STZ.W $151C,X             
CODE_01F73D:        9C AE 18      STZ.W $18AE               
CODE_01F740:        9C C1 0D      STZ.W RAM_OWHasYoshi      
CODE_01F743:        A9 30         LDA.B #$30                ; \ Mario invincible timer = #$30 
CODE_01F745:        8D 97 14      STA.W $1497               ; / 
CODE_01F748:        20 CC ED      JSR.W CODE_01EDCC         
Return01F74B:       60            RTS                       ; Return 

CODE_01F74C:        A9 08         LDA.B #$08                ; \ Sprite status = Normal 
CODE_01F74E:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01F751:        A9 20         LDA.B #$20                
CODE_01F753:        9D 40 15      STA.W $1540,X             
CODE_01F756:        A9 0A         LDA.B #$0A                ; \ Play sound effect 
CODE_01F758:        8D FC 1D      STA.W $1DFC               ; / 
Return01F75B:       6B            RTL                       ; Return 


DATA_01F75C:                      .db $00,$01,$01,$01

YoshiEggTiles:                    .db $62,$02,$02,$00

YoshiEgg:           BD 7B 18      LDA.W $187B,X             
CODE_01F767:        F0 30         BEQ CODE_01F799           
CODE_01F769:        20 CB 80      JSR.W IsSprOffScreen      
CODE_01F76C:        D0 1F         BNE CODE_01F78D           
CODE_01F76E:        20 30 AD      JSR.W SubHorizPos         
CODE_01F771:        A5 0F         LDA $0F                   
CODE_01F773:        18            CLC                       
CODE_01F774:        69 20         ADC.B #$20                
CODE_01F776:        C9 40         CMP.B #$40                
CODE_01F778:        B0 13         BCS CODE_01F78D           
CODE_01F77A:        9E 7B 18      STZ.W $187B,X             
CODE_01F77D:        22 51 F7 01   JSL.L CODE_01F751         
CODE_01F781:        A9 2D         LDA.B #$2D                
CODE_01F783:        AC E2 18      LDY.W $18E2               
CODE_01F786:        F0 02         BEQ CODE_01F78A           
CODE_01F788:        A9 78         LDA.B #$78                
CODE_01F78A:        9D 1C 15      STA.W $151C,X             
CODE_01F78D:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01F790:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01F793:        A9 00         LDA.B #$00                
CODE_01F795:        99 02 03      STA.W OAM_Tile,Y          
Return01F798:       60            RTS                       ; Return 

CODE_01F799:        BD 40 15      LDA.W $1540,X             
CODE_01F79C:        F0 24         BEQ CODE_01F7C2           
CODE_01F79E:        4A            LSR                       
CODE_01F79F:        4A            LSR                       
CODE_01F7A0:        4A            LSR                       
CODE_01F7A1:        A8            TAY                       
CODE_01F7A2:        B9 60 F7      LDA.W YoshiEggTiles,Y     
CODE_01F7A5:        48            PHA                       
CODE_01F7A6:        B9 5C F7      LDA.W DATA_01F75C,Y       
CODE_01F7A9:        48            PHA                       
CODE_01F7AA:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01F7AD:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01F7B0:        68            PLA                       
CODE_01F7B1:        85 00         STA $00                   
CODE_01F7B3:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_01F7B6:        29 FE         AND.B #$FE                
CODE_01F7B8:        05 00         ORA $00                   
CODE_01F7BA:        99 03 03      STA.W OAM_Prop,Y          
CODE_01F7BD:        68            PLA                       
CODE_01F7BE:        99 02 03      STA.W OAM_Tile,Y          
Return01F7C1:       60            RTS                       ; Return 

CODE_01F7C2:        20 C8 F7      JSR.W CODE_01F7C8         
CODE_01F7C5:        4C 3D F8      JMP.W CODE_01F83D         

CODE_01F7C8:        20 CB 80      JSR.W IsSprOffScreen      
CODE_01F7CB:        D0 5F         BNE Return01F82C          
CODE_01F7CD:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01F7CF:        85 00         STA $00                   
CODE_01F7D1:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01F7D3:        85 02         STA $02                   
CODE_01F7D5:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01F7D8:        85 03         STA $03                   
CODE_01F7DA:        DA            PHX                       
CODE_01F7DB:        A0 03         LDY.B #$03                
CODE_01F7DD:        A2 0B         LDX.B #$0B                
CODE_01F7DF:        BD F0 17      LDA.W $17F0,X             
CODE_01F7E2:        F0 10         BEQ CODE_01F7F4           
CODE_01F7E4:        CA            DEX                       
CODE_01F7E5:        10 F8         BPL CODE_01F7DF           
CODE_01F7E7:        CE 5D 18      DEC.W $185D               
CODE_01F7EA:        10 05         BPL CODE_01F7F1           
CODE_01F7EC:        A9 0B         LDA.B #$0B                
CODE_01F7EE:        8D 5D 18      STA.W $185D               
CODE_01F7F1:        AE 5D 18      LDX.W $185D               
CODE_01F7F4:        A9 03         LDA.B #$03                
CODE_01F7F6:        9D F0 17      STA.W $17F0,X             
CODE_01F7F9:        A5 00         LDA $00                   
CODE_01F7FB:        18            CLC                       
CODE_01F7FC:        79 31 F8      ADC.W DATA_01F831,Y       
CODE_01F7FF:        9D 08 18      STA.W $1808,X             
CODE_01F802:        A5 02         LDA $02                   
CODE_01F804:        18            CLC                       
CODE_01F805:        79 2D F8      ADC.W DATA_01F82D,Y       
CODE_01F808:        9D FC 17      STA.W $17FC,X             
CODE_01F80B:        A5 03         LDA $03                   
CODE_01F80D:        9D 14 18      STA.W $1814,X             
CODE_01F810:        B9 35 F8      LDA.W DATA_01F835,Y       
CODE_01F813:        9D 20 18      STA.W $1820,X             
CODE_01F816:        B9 39 F8      LDA.W DATA_01F839,Y       
CODE_01F819:        9D 2C 18      STA.W $182C,X             
CODE_01F81C:        98            TYA                       
CODE_01F81D:        0A            ASL                       
CODE_01F81E:        0A            ASL                       
CODE_01F81F:        0A            ASL                       
CODE_01F820:        0A            ASL                       
CODE_01F821:        0A            ASL                       
CODE_01F822:        0A            ASL                       
CODE_01F823:        09 28         ORA.B #$28                
CODE_01F825:        9D 50 18      STA.W $1850,X             
CODE_01F828:        88            DEY                       
CODE_01F829:        10 B9         BPL CODE_01F7E4           
CODE_01F82B:        FA            PLX                       
Return01F82C:       60            RTS                       ; Return 


DATA_01F82D:                      .db $00,$00,$08,$08

DATA_01F831:                      .db $00,$08,$00,$08

DATA_01F835:                      .db $E8,$E8,$F4,$F4

DATA_01F839:                      .db $FA,$06,$FD,$03

CODE_01F83D:        BD 1C 15      LDA.W $151C,X             
CODE_01F840:        95 9E         STA RAM_SpriteNum,X       
CODE_01F842:        C9 35         CMP.B #$35                
CODE_01F844:        F0 26         BEQ CODE_01F86C           
CODE_01F846:        C9 2D         CMP.B #$2D                
CODE_01F848:        D0 1D         BNE CODE_01F867           
CODE_01F84A:        A9 09         LDA.B #$09                ; \ Sprite status = Carryable 
CODE_01F84C:        9D C8 14      STA.W $14C8,X             ; / 
CODE_01F84F:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01F852:        29 0E         AND.B #$0E                
CODE_01F854:        48            PHA                       
CODE_01F855:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_01F859:        68            PLA                       
CODE_01F85A:        85 00         STA $00                   
CODE_01F85C:        BD F6 15      LDA.W RAM_SpritePal,X     
CODE_01F85F:        29 F1         AND.B #$F1                
CODE_01F861:        05 00         ORA $00                   
CODE_01F863:        9D F6 15      STA.W RAM_SpritePal,X     
Return01F866:       60            RTS                       ; Return 

CODE_01F867:        22 D2 F7 07   JSL.L InitSpriteTables    
Return01F86B:       60            RTS                       ; Return 

CODE_01F86C:        22 D2 F7 07   JSL.L InitSpriteTables    
CODE_01F870:        4C B5 A2      JMP.W CODE_01A2B5         


DATA_01F873:                      .db $08,$F8

UnusedInit:         20 7C 85      JSR.W FaceMario           
ADDR_01F878:        9D 34 15      STA.W $1534,X             
Return01F87B:       60            RTS                       ; Return 

InitEerie:          20 30 AD      JSR.W SubHorizPos         
CODE_01F87F:        B9 8C F8      LDA.W EerieSpeedX,Y       
CODE_01F882:        95 B6         STA RAM_SpriteSpeedX,X    
InitBigBoo:         22 F9 AC 01   JSL.L GetRand             
CODE_01F888:        9D 70 15      STA.W $1570,X             
Return01F88B:       60            RTS                       ; Return 


EerieSpeedX:                      .db $10,$F0

EerieSpeedY:                      .db $18,$E8

Eerie:              BD C8 14      LDA.W $14C8,X             
CODE_01F893:        C9 08         CMP.B #$08                
CODE_01F895:        D0 32         BNE CODE_01F8C9           
CODE_01F897:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01F899:        D0 2E         BNE CODE_01F8C9           ; / 
CODE_01F89B:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01F89E:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01F8A0:        C9 39         CMP.B #$39                
CODE_01F8A2:        D0 1C         BNE CODE_01F8C0           
CODE_01F8A4:        B5 C2         LDA RAM_SpriteState,X     
CODE_01F8A6:        29 01         AND.B #$01                
CODE_01F8A8:        A8            TAY                       
CODE_01F8A9:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01F8AB:        18            CLC                       
CODE_01F8AC:        79 B4 EB      ADC.W DATA_01EBB4,Y       
CODE_01F8AF:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01F8B1:        D9 8E F8      CMP.W EerieSpeedY,Y       
CODE_01F8B4:        D0 02         BNE CODE_01F8B8           
CODE_01F8B6:        F6 C2         INC RAM_SpriteState,X     
CODE_01F8B8:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01F8BB:        20 21 AC      JSR.W SubOffscreen3Bnk1   
CODE_01F8BE:        80 03         BRA CODE_01F8C3           

CODE_01F8C0:        20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01F8C3:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01F8C6:        20 5F 8E      JSR.W SetAnimationFrame   
CODE_01F8C9:        20 15 9A      JSR.W UpdateDirection     
CODE_01F8CC:        4C 0D 9F      JMP.W SubSprGfx2Entry1    


DATA_01F8CF:                      .db $08,$F8

DATA_01F8D1:                      .db $01,$02,$02,$01

BigBoo:             20 2B AC      JSR.W SubOffscreen1Bnk1   
CODE_01F8D8:        A9 20         LDA.B #$20                
CODE_01F8DA:        80 05         BRA CODE_01F8E1           

Boo+BooBlock:       20 31 AC      JSR.W SubOffscreen0Bnk1   
CODE_01F8DF:        A9 10         LDA.B #$10                
CODE_01F8E1:        8D B6 18      STA.W $18B6               
CODE_01F8E4:        BD C8 14      LDA.W $14C8,X             
CODE_01F8E7:        C9 08         CMP.B #$08                
CODE_01F8E9:        D0 04         BNE CODE_01F8EF           
CODE_01F8EB:        A5 9D         LDA RAM_SpritesLocked     
CODE_01F8ED:        F0 03         BEQ CODE_01F8F2           
CODE_01F8EF:        4C CE F9      JMP.W CODE_01F9CE         

CODE_01F8F2:        20 30 AD      JSR.W SubHorizPos         
CODE_01F8F5:        BD 40 15      LDA.W $1540,X             
CODE_01F8F8:        D0 1A         BNE CODE_01F914           
CODE_01F8FA:        A9 20         LDA.B #$20                
CODE_01F8FC:        9D 40 15      STA.W $1540,X             
CODE_01F8FF:        B5 C2         LDA RAM_SpriteState,X     
CODE_01F901:        F0 09         BEQ CODE_01F90C           
CODE_01F903:        A5 0F         LDA $0F                   
CODE_01F905:        18            CLC                       
CODE_01F906:        69 0A         ADC.B #$0A                
CODE_01F908:        C9 14         CMP.B #$14                
CODE_01F90A:        90 23         BCC CODE_01F92F           
CODE_01F90C:        74 C2         STZ RAM_SpriteState,X     
CODE_01F90E:        C4 76         CPY RAM_MarioDirection    
CODE_01F910:        D0 02         BNE CODE_01F914           
CODE_01F912:        F6 C2         INC RAM_SpriteState,X     
CODE_01F914:        A5 0F         LDA $0F                   
CODE_01F916:        18            CLC                       
CODE_01F917:        69 0A         ADC.B #$0A                
CODE_01F919:        C9 14         CMP.B #$14                
CODE_01F91B:        90 12         BCC CODE_01F92F           
CODE_01F91D:        BD AC 15      LDA.W $15AC,X             
CODE_01F920:        D0 4F         BNE CODE_01F971           
CODE_01F922:        98            TYA                       
CODE_01F923:        DD 7C 15      CMP.W RAM_SpriteDir,X     
CODE_01F926:        F0 07         BEQ CODE_01F92F           
CODE_01F928:        A9 1F         LDA.B #$1F                ; \ Set turning timer 
CODE_01F92A:        9D AC 15      STA.W $15AC,X             ; / 
CODE_01F92D:        80 42         BRA CODE_01F971           

CODE_01F92F:        9E 02 16      STZ.W $1602,X             
CODE_01F932:        B5 C2         LDA RAM_SpriteState,X     
CODE_01F934:        F0 53         BEQ CODE_01F989           
CODE_01F936:        A9 03         LDA.B #$03                
CODE_01F938:        9D 02 16      STA.W $1602,X             
CODE_01F93B:        B4 9E         LDY RAM_SpriteNum,X       
CODE_01F93D:        C0 28         CPY.B #$28                
CODE_01F93F:        F0 07         BEQ CODE_01F948           
CODE_01F941:        A9 00         LDA.B #$00                
CODE_01F943:        C0 AF         CPY.B #$AF                
CODE_01F945:        F0 01         BEQ CODE_01F948           
CODE_01F947:        1A            INC A                     
CODE_01F948:        25 13         AND RAM_FrameCounter      
CODE_01F94A:        D0 23         BNE CODE_01F96F           
CODE_01F94C:        FE 70 15      INC.W $1570,X             
CODE_01F94F:        BD 70 15      LDA.W $1570,X             
CODE_01F952:        D0 05         BNE CODE_01F959           
CODE_01F954:        A9 20         LDA.B #$20                
CODE_01F956:        9D 58 15      STA.W $1558,X             
CODE_01F959:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01F95B:        F0 05         BEQ CODE_01F962           
CODE_01F95D:        10 02         BPL CODE_01F961           
CODE_01F95F:        1A            INC A                     
CODE_01F960:        1A            INC A                     
CODE_01F961:        3A            DEC A                     
CODE_01F962:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01F964:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01F966:        F0 05         BEQ CODE_01F96D           
CODE_01F968:        10 02         BPL CODE_01F96C           
CODE_01F96A:        1A            INC A                     
CODE_01F96B:        1A            INC A                     
CODE_01F96C:        3A            DEC A                     
CODE_01F96D:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01F96F:        80 57         BRA CODE_01F9C8           

CODE_01F971:        C9 10         CMP.B #$10                
CODE_01F973:        D0 0A         BNE CODE_01F97F           
CODE_01F975:        48            PHA                       
CODE_01F976:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01F979:        49 01         EOR.B #$01                
CODE_01F97B:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01F97E:        68            PLA                       
CODE_01F97F:        4A            LSR                       
CODE_01F980:        4A            LSR                       
CODE_01F981:        4A            LSR                       
CODE_01F982:        A8            TAY                       
CODE_01F983:        B9 D1 F8      LDA.W DATA_01F8D1,Y       
CODE_01F986:        9D 02 16      STA.W $1602,X             
CODE_01F989:        9E 70 15      STZ.W $1570,X             
CODE_01F98C:        A5 13         LDA RAM_FrameCounter      
CODE_01F98E:        29 07         AND.B #$07                
CODE_01F990:        D0 36         BNE CODE_01F9C8           
CODE_01F992:        20 30 AD      JSR.W SubHorizPos         
CODE_01F995:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01F997:        D9 CF F8      CMP.W DATA_01F8CF,Y       
CODE_01F99A:        F0 06         BEQ CODE_01F9A2           
CODE_01F99C:        18            CLC                       
CODE_01F99D:        79 B4 EB      ADC.W DATA_01EBB4,Y       
CODE_01F9A0:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01F9A2:        A5 D3         LDA $D3                   
CODE_01F9A4:        48            PHA                       
CODE_01F9A5:        38            SEC                       
CODE_01F9A6:        ED B6 18      SBC.W $18B6               
CODE_01F9A9:        85 D3         STA $D3                   
CODE_01F9AB:        A5 D4         LDA $D4                   
CODE_01F9AD:        48            PHA                       
CODE_01F9AE:        E9 00         SBC.B #$00                
CODE_01F9B0:        85 D4         STA $D4                   
CODE_01F9B2:        20 42 AD      JSR.W CODE_01AD42         
CODE_01F9B5:        68            PLA                       
CODE_01F9B6:        85 D4         STA $D4                   
CODE_01F9B8:        68            PLA                       
CODE_01F9B9:        85 D3         STA $D3                   
CODE_01F9BB:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01F9BD:        D9 CF F8      CMP.W DATA_01F8CF,Y       
CODE_01F9C0:        F0 06         BEQ CODE_01F9C8           
CODE_01F9C2:        18            CLC                       
CODE_01F9C3:        79 B4 EB      ADC.W DATA_01EBB4,Y       
CODE_01F9C6:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01F9C8:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01F9CB:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01F9CE:        B5 9E         LDA RAM_SpriteNum,X       
CODE_01F9D0:        C9 AF         CMP.B #$AF                
CODE_01F9D2:        D0 69         BNE CODE_01FA3D           
CODE_01F9D4:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01F9D6:        10 03         BPL CODE_01F9DB           
CODE_01F9D8:        49 FF         EOR.B #$FF                
CODE_01F9DA:        1A            INC A                     
CODE_01F9DB:        A0 00         LDY.B #$00                
CODE_01F9DD:        C9 08         CMP.B #$08                
CODE_01F9DF:        B0 28         BCS CODE_01FA09           
CODE_01F9E1:        48            PHA                       
CODE_01F9E2:        BD 62 16      LDA.W RAM_Tweaker1662,X   
CODE_01F9E5:        48            PHA                       
CODE_01F9E6:        BD 7A 16      LDA.W RAM_Tweaker167A,X   
CODE_01F9E9:        48            PHA                       
CODE_01F9EA:        09 80         ORA.B #$80                
CODE_01F9EC:        9D 7A 16      STA.W RAM_Tweaker167A,X   
CODE_01F9EF:        A9 0C         LDA.B #$0C                
CODE_01F9F1:        9D 62 16      STA.W RAM_Tweaker1662,X   
CODE_01F9F4:        20 57 B4      JSR.W CODE_01B457         
CODE_01F9F7:        68            PLA                       
CODE_01F9F8:        9D 7A 16      STA.W RAM_Tweaker167A,X   
CODE_01F9FB:        68            PLA                       
CODE_01F9FC:        9D 62 16      STA.W RAM_Tweaker1662,X   
CODE_01F9FF:        68            PLA                       
CODE_01FA00:        A0 01         LDY.B #$01                
CODE_01FA02:        C9 04         CMP.B #$04                
CODE_01FA04:        B0 0F         BCS CODE_01FA15           
CODE_01FA06:        C8            INY                       
CODE_01FA07:        80 0C         BRA CODE_01FA15           

CODE_01FA09:        BD C8 14      LDA.W $14C8,X             
CODE_01FA0C:        C9 08         CMP.B #$08                
CODE_01FA0E:        D0 05         BNE CODE_01FA15           
CODE_01FA10:        5A            PHY                       
CODE_01FA11:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01FA14:        7A            PLY                       
CODE_01FA15:        98            TYA                       
CODE_01FA16:        9D 02 16      STA.W $1602,X             
CODE_01FA19:        20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01FA1C:        BD 02 16      LDA.W $1602,X             
CODE_01FA1F:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01FA22:        DA            PHX                       
CODE_01FA23:        AA            TAX                       
CODE_01FA24:        BD 37 FA      LDA.W BooBlockTiles,X     
CODE_01FA27:        99 02 03      STA.W OAM_Tile,Y          
CODE_01FA2A:        B9 03 03      LDA.W OAM_Prop,Y          
CODE_01FA2D:        29 F1         AND.B #$F1                
CODE_01FA2F:        1D 3A FA      ORA.W BooBlockGfxProp,X   
CODE_01FA32:        99 03 03      STA.W OAM_Prop,Y          
CODE_01FA35:        FA            PLX                       
Return01FA36:       60            RTS                       ; Return 


BooBlockTiles:                    .db $8C,$C8,$CA

BooBlockGfxProp:                  .db $0E,$02,$02

CODE_01FA3D:        BD C8 14      LDA.W $14C8,X             
CODE_01FA40:        C9 08         CMP.B #$08                
CODE_01FA42:        D0 03         BNE CODE_01FA47           
CODE_01FA44:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01FA47:        22 98 83 03   JSL.L CODE_038398         
Return01FA4B:       60            RTS                       ; Return 


DATA_01FA4C:                      .db $40,$00

IggyBallTiles:                    .db $4A,$4C,$4A,$4C

DATA_01FA52:                      .db $35,$35,$F5,$F5

DATA_01FA56:                      .db $10,$F0

Iggy'sBall:         20 0D 9F      JSR.W SubSprGfx2Entry1    
CODE_01FA5B:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01FA5E:        B9 4C FA      LDA.W DATA_01FA4C,Y       
CODE_01FA61:        85 00         STA $00                   
CODE_01FA63:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01FA66:        A5 14         LDA RAM_FrameCounterB     
CODE_01FA68:        4A            LSR                       
CODE_01FA69:        4A            LSR                       
CODE_01FA6A:        29 03         AND.B #$03                
CODE_01FA6C:        DA            PHX                       
CODE_01FA6D:        AA            TAX                       
CODE_01FA6E:        BD 4E FA      LDA.W IggyBallTiles,X     
CODE_01FA71:        99 02 03      STA.W OAM_Tile,Y          
CODE_01FA74:        BD 52 FA      LDA.W DATA_01FA52,X       
CODE_01FA77:        45 00         EOR $00                   
CODE_01FA79:        99 03 03      STA.W OAM_Prop,Y          
CODE_01FA7C:        FA            PLX                       
CODE_01FA7D:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01FA7F:        D0 32         BNE Return01FAB3          ; / 
CODE_01FA81:        BC 7C 15      LDY.W RAM_SpriteDir,X     
CODE_01FA84:        B9 56 FA      LDA.W DATA_01FA56,Y       
CODE_01FA87:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01FA89:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01FA8C:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01FA8F:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01FA91:        C9 40         CMP.B #$40                
CODE_01FA93:        10 05         BPL CODE_01FA9A           
CODE_01FA95:        18            CLC                       
CODE_01FA96:        69 04         ADC.B #$04                
CODE_01FA98:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01FA9A:        20 98 FF      JSR.W CODE_01FF98         
CODE_01FA9D:        90 04         BCC CODE_01FAA3           
CODE_01FA9F:        A9 F0         LDA.B #$F0                
CODE_01FAA1:        95 AA         STA RAM_SpriteSpeedY,X    
CODE_01FAA3:        20 E4 A7      JSR.W MarioSprInteractRt  
CODE_01FAA6:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01FAA8:        C9 44         CMP.B #$44                
CODE_01FAAA:        90 07         BCC Return01FAB3          
CODE_01FAAC:        C9 50         CMP.B #$50                
CODE_01FAAE:        B0 03         BCS Return01FAB3          
CODE_01FAB0:        20 CB 9A      JSR.W CODE_019ACB         
Return01FAB3:       60            RTS                       ; Return 


DATA_01FAB4:                      .db $FF,$01,$00,$80,$60,$A0,$40,$D0
                                  .db $D8,$C0,$C8,$0C,$F4

KoopaKid:           B5 C2         LDA RAM_SpriteState,X     
CODE_01FAC3:        22 DF 86 00   JSL.L ExecutePtr          ; 00 - Morton 

KoopaKidPtrs:          AB CD      .dw WallKoopaKids         ; 02 - Ludwig 
                       AB CD      .dw WallKoopaKids         ; 03 - Iggy   
                       AB CD      .dw WallKoopaKids         ; 04 - Larry  
                       F5 FA      .dw PlatformKoopaKids     ; 05 - Lemmy  
                       F5 FA      .dw PlatformKoopaKids     ; 06 - Wendy  
                       2A CD      .dw PipeKoopaKids         
                       2A CD      .dw PipeKoopaKids         

DATA_01FAD5:                      .db $00,$FC,$F8,$F8,$F8,$F8,$F8,$F8
DATA_01FADD:                      .db $F8,$F8,$F8,$F4,$F0,$F0,$EC,$EC
DATA_01FAE5:                      .db $00,$01,$02,$00,$01,$02,$00,$01
                                  .db $02,$00,$01,$02,$00,$01,$02,$01

PlatformKoopaKids:  A5 9D         LDA RAM_SpritesLocked     
CODE_01FAF7:        1D 4C 15      ORA.W RAM_DisableInter,X  
CODE_01FAFA:        D0 1E         BNE CODE_01FB1A           
CODE_01FAFC:        20 30 AD      JSR.W SubHorizPos         
CODE_01FAFF:        84 00         STY $00                   
CODE_01FB01:        A5 36         LDA $36                   
CODE_01FB03:        0A            ASL                       
CODE_01FB04:        2A            ROL                       
CODE_01FB05:        29 01         AND.B #$01                
CODE_01FB07:        C5 00         CMP $00                   
CODE_01FB09:        D0 0F         BNE CODE_01FB1A           
CODE_01FB0B:        FE 34 15      INC.W $1534,X             
CODE_01FB0E:        BD 34 15      LDA.W $1534,X             
CODE_01FB11:        29 7F         AND.B #$7F                
CODE_01FB13:        D0 05         BNE CODE_01FB1A           
CODE_01FB15:        A9 7F         LDA.B #$7F                ; \ Set time to go in shell 
CODE_01FB17:        9D 64 15      STA.W $1564,X             ; / 
CODE_01FB1A:        9E A0 15      STZ.W RAM_OffscreenHorz,X 
CODE_01FB1D:        BD 3E 16      LDA.W $163E,X             
CODE_01FB20:        F0 14         BEQ CODE_01FB36           
CODE_01FB22:        3A            DEC A                     
CODE_01FB23:        D0 10         BNE Return01FB35          
CODE_01FB25:        EE C6 13      INC.W $13C6               
CODE_01FB28:        A9 FF         LDA.B #$FF                
CODE_01FB2A:        8D 93 14      STA.W $1493               
CODE_01FB2D:        A9 0B         LDA.B #$0B                
CODE_01FB2F:        8D FB 1D      STA.W $1DFB               ; / Change music 
CODE_01FB32:        9E C8 14      STZ.W $14C8,X             
Return01FB35:       60            RTS                       ; Return 

CODE_01FB36:        22 A0 F7 07   JSL.L LoadTweakerBytes    
CODE_01FB3A:        A5 9D         LDA RAM_SpritesLocked     
CODE_01FB3C:        F0 03         BEQ CODE_01FB41           
CODE_01FB3E:        4C 08 FC      JMP.W CODE_01FC08         

CODE_01FB41:        BD 0E 16      LDA.W $160E,X             
CODE_01FB44:        F0 35         BEQ CODE_01FB7B           
CODE_01FB46:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01FB49:        20 D8 AB      JSR.W SubSprYPosNoGrvty   
CODE_01FB4C:        B5 AA         LDA RAM_SpriteSpeedY,X    
CODE_01FB4E:        C9 40         CMP.B #$40                
CODE_01FB50:        10 04         BPL CODE_01FB56           
CODE_01FB52:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_01FB54:        F6 AA         INC RAM_SpriteSpeedY,X    
CODE_01FB56:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01FB58:        C9 58         CMP.B #$58                
CODE_01FB5A:        90 12         BCC CODE_01FB6E           
CODE_01FB5C:        C9 80         CMP.B #$80                
CODE_01FB5E:        B0 0E         BCS CODE_01FB6E           
CODE_01FB60:        A9 20         LDA.B #$20                ; \ Play sound effect 
CODE_01FB62:        8D FC 1D      STA.W $1DFC               ; / 
CODE_01FB65:        A9 50         LDA.B #$50                
CODE_01FB67:        9D 3E 16      STA.W $163E,X             
CODE_01FB6A:        22 C8 A6 03   JSL.L KillMostSprites     ; Kill all sprites 
CODE_01FB6E:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01FB70:        8D B8 14      STA.W $14B8               
CODE_01FB73:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01FB75:        8D BA 14      STA.W $14BA               
CODE_01FB78:        4C 0E FC      JMP.W CODE_01FC0E         

CODE_01FB7B:        20 CC AB      JSR.W SubSprXPosNoGrvty   
CODE_01FB7E:        A5 13         LDA RAM_FrameCounter      
CODE_01FB80:        29 1F         AND.B #$1F                
CODE_01FB82:        1D 64 15      ORA.W $1564,X             
CODE_01FB85:        D0 12         BNE CODE_01FB99           
CODE_01FB87:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01FB8A:        48            PHA                       
CODE_01FB8B:        20 7C 85      JSR.W FaceMario           
CODE_01FB8E:        68            PLA                       
CODE_01FB8F:        DD 7C 15      CMP.W RAM_SpriteDir,X     
CODE_01FB92:        F0 05         BEQ CODE_01FB99           
CODE_01FB94:        A9 10         LDA.B #$10                
CODE_01FB96:        9D AC 15      STA.W $15AC,X             
CODE_01FB99:        74 AA         STZ RAM_SpriteSpeedY,X    ; Sprite Y Speed = 0 
CODE_01FB9B:        74 B6         STZ RAM_SpriteSpeedX,X    ; Sprite X Speed = 0 
CODE_01FB9D:        A5 36         LDA $36                   
CODE_01FB9F:        10 03         BPL CODE_01FBA4           
CODE_01FBA1:        18            CLC                       
CODE_01FBA2:        69 08         ADC.B #$08                
CODE_01FBA4:        4A            LSR                       
CODE_01FBA5:        4A            LSR                       
CODE_01FBA6:        4A            LSR                       
CODE_01FBA7:        4A            LSR                       
CODE_01FBA8:        A8            TAY                       
CODE_01FBA9:        84 00         STY $00                   
CODE_01FBAB:        49 FF         EOR.B #$FF                
CODE_01FBAD:        1A            INC A                     
CODE_01FBAE:        29 0F         AND.B #$0F                
CODE_01FBB0:        85 01         STA $01                   
CODE_01FBB2:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_01FBB5:        D0 22         BNE CODE_01FBD9           
CODE_01FBB7:        A5 37         LDA $37                   
CODE_01FBB9:        D0 0E         BNE CODE_01FBC9           
CODE_01FBBB:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01FBBD:        C9 78         CMP.B #$78                
CODE_01FBBF:        90 04         BCC CODE_01FBC5           
CODE_01FBC1:        A9 FF         LDA.B #$FF                
CODE_01FBC3:        80 29         BRA CODE_01FBEE           

CODE_01FBC5:        A9 01         LDA.B #$01                
CODE_01FBC7:        80 25         BRA CODE_01FBEE           

CODE_01FBC9:        A4 01         LDY $01                   
CODE_01FBCB:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01FBCD:        C9 78         CMP.B #$78                
CODE_01FBCF:        B0 04         BCS CODE_01FBD5           
CODE_01FBD1:        A9 01         LDA.B #$01                
CODE_01FBD3:        80 19         BRA CODE_01FBEE           

CODE_01FBD5:        A9 FF         LDA.B #$FF                
CODE_01FBD7:        80 15         BRA CODE_01FBEE           

CODE_01FBD9:        A5 37         LDA $37                   
CODE_01FBDB:        D0 0A         BNE CODE_01FBE7           
CODE_01FBDD:        A4 00         LDY $00                   
CODE_01FBDF:        B9 DD FA      LDA.W DATA_01FADD,Y       
CODE_01FBE2:        49 FF         EOR.B #$FF                
CODE_01FBE4:        1A            INC A                     
CODE_01FBE5:        80 05         BRA CODE_01FBEC           

CODE_01FBE7:        A4 01         LDY $01                   
CODE_01FBE9:        B9 DD FA      LDA.W DATA_01FADD,Y       
CODE_01FBEC:        0A            ASL                       
CODE_01FBED:        0A            ASL                       
CODE_01FBEE:        95 B6         STA RAM_SpriteSpeedX,X    
CODE_01FBF0:        FE 70 15      INC.W $1570,X             
CODE_01FBF3:        B5 B6         LDA RAM_SpriteSpeedX,X    
CODE_01FBF5:        F0 03         BEQ CODE_01FBFA           
CODE_01FBF7:        FE 70 15      INC.W $1570,X             
CODE_01FBFA:        BD 70 15      LDA.W $1570,X             
CODE_01FBFD:        4A            LSR                       
CODE_01FBFE:        4A            LSR                       
CODE_01FBFF:        29 0F         AND.B #$0F                
CODE_01FC01:        A8            TAY                       
CODE_01FC02:        B9 E5 FA      LDA.W DATA_01FAE5,Y       
CODE_01FC05:        9D 02 16      STA.W $1602,X             
CODE_01FC08:        20 50 FD      JSR.W CODE_01FD50         
CODE_01FC0B:        20 62 FC      JSR.W CODE_01FC62         
CODE_01FC0E:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_01FC11:        D0 3B         BNE CODE_01FC4E           
CODE_01FC13:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01FC16:        48            PHA                       
CODE_01FC17:        BC AC 15      LDY.W $15AC,X             
CODE_01FC1A:        F0 0E         BEQ CODE_01FC2A           
CODE_01FC1C:        C0 08         CPY.B #$08                
CODE_01FC1E:        90 05         BCC CODE_01FC25           
CODE_01FC20:        49 01         EOR.B #$01                
CODE_01FC22:        9D 7C 15      STA.W RAM_SpriteDir,X     
CODE_01FC25:        A9 06         LDA.B #$06                
CODE_01FC27:        9D 02 16      STA.W $1602,X             
CODE_01FC2A:        BD 64 15      LDA.W $1564,X             
CODE_01FC2D:        F0 17         BEQ CODE_01FC46           
CODE_01FC2F:        48            PHA                       
CODE_01FC30:        4A            LSR                       
CODE_01FC31:        4A            LSR                       
CODE_01FC32:        4A            LSR                       
CODE_01FC33:        A8            TAY                       
CODE_01FC34:        B9 95 FD      LDA.W DATA_01FD95,Y       
CODE_01FC37:        9D 02 16      STA.W $1602,X             
CODE_01FC3A:        68            PLA                       
CODE_01FC3B:        C9 28         CMP.B #$28                
CODE_01FC3D:        D0 07         BNE CODE_01FC46           
CODE_01FC3F:        A5 9D         LDA RAM_SpritesLocked     ; \ Branch if sprites locked 
CODE_01FC41:        D0 03         BNE CODE_01FC46           ; / 
CODE_01FC43:        20 A7 FD      JSR.W ThrowBall           ; Throw ball 
CODE_01FC46:        20 BC FE      JSR.W CODE_01FEBC         
CODE_01FC49:        68            PLA                       
CODE_01FC4A:        9D 7C 15      STA.W RAM_SpriteDir,X     
Return01FC4D:       60            RTS                       ; Return 

CODE_01FC4E:        C9 10         CMP.B #$10                
CODE_01FC50:        90 08         BCC CODE_01FC5A           
CODE_01FC52:        A9 03         LDA.B #$03                
CODE_01FC54:        9D 02 16      STA.W $1602,X             
CODE_01FC57:        4C BC FE      JMP.W CODE_01FEBC         

CODE_01FC5A:        C9 08         CMP.B #$08                
CODE_01FC5C:        90 F4         BCC CODE_01FC52           
CODE_01FC5E:        20 5B FF      JSR.W CODE_01FF5B         
Return01FC61:       60            RTS                       ; Return 

CODE_01FC62:        A5 71         LDA RAM_MarioAnimation    
CODE_01FC64:        C9 01         CMP.B #$01                
CODE_01FC66:        B0 F9         BCS Return01FC61          
CODE_01FC68:        BD 0E 16      LDA.W $160E,X             
CODE_01FC6B:        D0 F4         BNE Return01FC61          
CODE_01FC6D:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01FC6F:        C9 20         CMP.B #$20                
CODE_01FC71:        90 04         BCC CODE_01FC77           
CODE_01FC73:        C9 D8         CMP.B #$D8                
CODE_01FC75:        90 0D         BCC CODE_01FC84           
CODE_01FC77:        AD B8 14      LDA.W $14B8               
CODE_01FC7A:        95 E4         STA RAM_SpriteXLo,X       
CODE_01FC7C:        AD BA 14      LDA.W $14BA               
CODE_01FC7F:        95 D8         STA RAM_SpriteYLo,X       
CODE_01FC81:        FE 0E 16      INC.W $160E,X             
CODE_01FC84:        AD B8 14      LDA.W $14B8               
CODE_01FC87:        38            SEC                       
CODE_01FC88:        E9 08         SBC.B #$08                
CODE_01FC8A:        85 00         STA $00                   
CODE_01FC8C:        AD BA 14      LDA.W $14BA               
CODE_01FC8F:        18            CLC                       
CODE_01FC90:        69 60         ADC.B #$60                
CODE_01FC92:        85 01         STA $01                   
CODE_01FC94:        A9 0F         LDA.B #$0F                
CODE_01FC96:        85 02         STA $02                   
CODE_01FC98:        A9 0C         LDA.B #$0C                
CODE_01FC9A:        85 03         STA $03                   
CODE_01FC9C:        64 08         STZ $08                   
CODE_01FC9E:        64 09         STZ $09                   
CODE_01FCA0:        A5 7E         LDA $7E                   
CODE_01FCA2:        18            CLC                       
CODE_01FCA3:        69 02         ADC.B #$02                
CODE_01FCA5:        85 04         STA $04                   
CODE_01FCA7:        A5 80         LDA $80                   
CODE_01FCA9:        18            CLC                       
CODE_01FCAA:        69 10         ADC.B #$10                
CODE_01FCAC:        85 05         STA $05                   
CODE_01FCAE:        A9 0C         LDA.B #$0C                
CODE_01FCB0:        85 06         STA $06                   
CODE_01FCB2:        A9 0E         LDA.B #$0E                
CODE_01FCB4:        85 07         STA $07                   
CODE_01FCB6:        64 0A         STZ $0A                   
CODE_01FCB8:        64 0B         STZ $0B                   
CODE_01FCBA:        22 2B B7 03   JSL.L CheckForContact     
CODE_01FCBE:        90 4A         BCC CODE_01FD0A           
CODE_01FCC0:        BD 58 15      LDA.W $1558,X             
CODE_01FCC3:        D0 44         BNE Return01FD09          
CODE_01FCC5:        A9 08         LDA.B #$08                
CODE_01FCC7:        9D 58 15      STA.W $1558,X             
CODE_01FCCA:        A5 72         LDA RAM_IsFlying          
CODE_01FCCC:        F0 37         BEQ CODE_01FD05           
CODE_01FCCE:        A9 28         LDA.B #$28                ; \ Play sound effect 
CODE_01FCD0:        8D FC 1D      STA.W $1DFC               ; / 
CODE_01FCD3:        22 33 AA 01   JSL.L BoostMarioSpeed     
CODE_01FCD7:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01FCD9:        48            PHA                       
CODE_01FCDA:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01FCDC:        48            PHA                       
CODE_01FCDD:        AD B8 14      LDA.W $14B8               
CODE_01FCE0:        38            SEC                       
CODE_01FCE1:        E9 08         SBC.B #$08                
CODE_01FCE3:        95 E4         STA RAM_SpriteXLo,X       
CODE_01FCE5:        AD BA 14      LDA.W $14BA               
CODE_01FCE8:        38            SEC                       
CODE_01FCE9:        E9 10         SBC.B #$10                
CODE_01FCEB:        95 D8         STA RAM_SpriteYLo,X       
CODE_01FCED:        9E A0 15      STZ.W RAM_OffscreenHorz,X 
CODE_01FCF0:        22 99 AB 01   JSL.L DisplayContactGfx   
CODE_01FCF4:        68            PLA                       
CODE_01FCF5:        95 D8         STA RAM_SpriteYLo,X       
CODE_01FCF7:        68            PLA                       
CODE_01FCF8:        95 E4         STA RAM_SpriteXLo,X       
CODE_01FCFA:        BD 4C 15      LDA.W RAM_DisableInter,X  
CODE_01FCFD:        D0 0A         BNE Return01FD09          
CODE_01FCFF:        A9 18         LDA.B #$18                
CODE_01FD01:        9D 4C 15      STA.W RAM_DisableInter,X  
Return01FD04:       60            RTS                       ; Return 

CODE_01FD05:        22 B7 F5 00   JSL.L HurtMario           
Return01FD09:       60            RTS                       ; Return 

CODE_01FD0A:        A0 0A         LDY.B #$0A                
CODE_01FD0C:        8C 95 16      STY.W $1695               
CODE_01FD0F:        B9 0B 17      LDA.W RAM_ExSpriteNum,Y   
CODE_01FD12:        C9 05         CMP.B #$05                
CODE_01FD14:        D0 34         BNE CODE_01FD4A           
CODE_01FD16:        B9 1F 17      LDA.W RAM_ExSpriteXLo,Y   
CODE_01FD19:        38            SEC                       
CODE_01FD1A:        E5 1A         SBC RAM_ScreenBndryXLo    
CODE_01FD1C:        85 04         STA $04                   
CODE_01FD1E:        64 0A         STZ $0A                   
CODE_01FD20:        B9 15 17      LDA.W RAM_ExSpriteYLo,Y   
CODE_01FD23:        38            SEC                       
CODE_01FD24:        E5 1C         SBC RAM_ScreenBndryYLo    
CODE_01FD26:        85 05         STA $05                   
CODE_01FD28:        64 0B         STZ $0B                   
CODE_01FD2A:        A9 08         LDA.B #$08                
CODE_01FD2C:        85 06         STA $06                   
CODE_01FD2E:        85 07         STA $07                   
CODE_01FD30:        22 2B B7 03   JSL.L CheckForContact     
CODE_01FD34:        90 14         BCC CODE_01FD4A           
CODE_01FD36:        A9 01         LDA.B #$01                ; \ Extended sprite = Smoke puff 
CODE_01FD38:        99 0B 17      STA.W RAM_ExSpriteNum,Y   ; / 
CODE_01FD3B:        A9 0F         LDA.B #$0F                
CODE_01FD3D:        99 6F 17      STA.W $176F,Y             
CODE_01FD40:        A9 01         LDA.B #$01                ; \ Play sound effect 
CODE_01FD42:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01FD45:        A9 10         LDA.B #$10                
CODE_01FD47:        9D 4C 15      STA.W RAM_DisableInter,X  
CODE_01FD4A:        88            DEY                       
CODE_01FD4B:        C0 07         CPY.B #$07                
CODE_01FD4D:        D0 BD         BNE CODE_01FD0C           
Return01FD4F:       60            RTS                       ; Return 

CODE_01FD50:        B5 E4         LDA RAM_SpriteXLo,X       
CODE_01FD52:        18            CLC                       
CODE_01FD53:        69 08         ADC.B #$08                
CODE_01FD55:        8D B4 14      STA.W $14B4               
CODE_01FD58:        BD E0 14      LDA.W RAM_SpriteXHi,X     
CODE_01FD5B:        69 00         ADC.B #$00                
CODE_01FD5D:        8D B5 14      STA.W $14B5               
CODE_01FD60:        B5 D8         LDA RAM_SpriteYLo,X       
CODE_01FD62:        18            CLC                       
CODE_01FD63:        69 2F         ADC.B #$2F                
CODE_01FD65:        8D B6 14      STA.W $14B6               
CODE_01FD68:        BD D4 14      LDA.W RAM_SpriteYHi,X     
CODE_01FD6B:        69 00         ADC.B #$00                
CODE_01FD6D:        8D B7 14      STA.W $14B7               
CODE_01FD70:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01FD72:        A5 36         LDA $36                   
CODE_01FD74:        49 FF 01      EOR.W #$01FF              
CODE_01FD77:        1A            INC A                     
CODE_01FD78:        29 FF 01      AND.W #$01FF              
CODE_01FD7B:        85 36         STA $36                   
CODE_01FD7D:        E2 20         SEP #$20                  ; Accum (8 bit) 
CODE_01FD7F:        DA            PHX                       
CODE_01FD80:        22 9D CC 01   JSL.L CODE_01CC9D         
CODE_01FD84:        FA            PLX                       
CODE_01FD85:        C2 20         REP #$20                  ; Accum (16 bit) 
CODE_01FD87:        A5 36         LDA $36                   
CODE_01FD89:        49 FF 01      EOR.W #$01FF              
CODE_01FD8C:        1A            INC A                     
CODE_01FD8D:        29 FF 01      AND.W #$01FF              
CODE_01FD90:        85 36         STA $36                   
CODE_01FD92:        E2 20         SEP #$20                  ; Accum (8 bit) 
Return01FD94:       60            RTS                       ; Return 


DATA_01FD95:                      .db $04,$0B,$0B,$0B,$0B,$0A,$0A,$09
                                  .db $09,$08,$08,$07,$04,$05,$05,$05
BallPositionDispX:                .db $08,$F8

ThrowBall:          A0 05         LDY.B #$05                ; \ Find an open sprite index 
CODE_01FDA9:        B9 C8 14      LDA.W $14C8,Y             ;  | 
CODE_01FDAC:        F0 04         BEQ GenerateBall          ;  | 
CODE_01FDAE:        88            DEY                       ;  | 
CODE_01FDAF:        10 F8         BPL CODE_01FDA9           ; / 
Return01FDB1:       60            RTS                       ; Return 

GenerateBall:       A9 20         LDA.B #$20                ; \ Play sound effect 
CODE_01FDB4:        8D F9 1D      STA.W $1DF9               ; / 
CODE_01FDB7:        A9 08         LDA.B #$08                ; \ Sprite status = normal 
CODE_01FDB9:        99 C8 14      STA.W $14C8,Y             ; / 
CODE_01FDBC:        A9 A7         LDA.B #$A7                ; \ Sprite to throw = Ball 
CODE_01FDBE:        99 9E 00      STA.W RAM_SpriteNum,Y     ; / 
CODE_01FDC1:        DA            PHX                       ; \ Before: X must have index of sprite being generated 
CODE_01FDC2:        BB            TYX                       ;  | Routine clears *all* old sprite values... 
CODE_01FDC3:        22 D2 F7 07   JSL.L InitSpriteTables    ;  | ...and loads in new values for the 6 main sprite tables 
CODE_01FDC7:        FA            PLX                       ; / 
CODE_01FDC8:        DA            PHX                       ; Push Iggy's sprite index 
CODE_01FDC9:        BD 7C 15      LDA.W RAM_SpriteDir,X     ; \ Ball's direction = Iggy'direction 
CODE_01FDCC:        99 7C 15      STA.W RAM_SpriteDir,Y     ; / 
CODE_01FDCF:        AA            TAX                       ; X = Ball's direction 
CODE_01FDD0:        AD B8 14      LDA.W $14B8               ; \ Set Ball X position 
CODE_01FDD3:        38            SEC                       ;  | 
CODE_01FDD4:        E9 08         SBC.B #$08                ;  | 
CODE_01FDD6:        7D A5 FD      ADC.W BallPositionDispX,X ;  | 
CODE_01FDD9:        99 E4 00      STA.W RAM_SpriteXLo,Y     ;  | 
CODE_01FDDC:        A9 00         LDA.B #$00                ;  | 
CODE_01FDDE:        99 E0 14      STA.W RAM_SpriteXHi,Y     ; / 
CODE_01FDE1:        AD BA 14      LDA.W $14BA               ; \ Set Ball Y position 
CODE_01FDE4:        38            SEC                       ;  | 
CODE_01FDE5:        E9 18         SBC.B #$18                ;  | 
CODE_01FDE7:        99 D8 00      STA.W RAM_SpriteYLo,Y     ;  | 
CODE_01FDEA:        A9 00         LDA.B #$00                ;  | 
CODE_01FDEC:        E9 00         SBC.B #$00                ;  | 
CODE_01FDEE:        99 D4 14      STA.W RAM_SpriteYHi,Y     ; / 
CODE_01FDF1:        FA            PLX                       ; X = Iggy's sprite index 
Return01FDF2:       60            RTS                       ; Return 


DATA_01FDF3:                      .db $F7,$FF,$00,$F8,$F7,$FF,$00,$F8
                                  .db $F8,$00,$00,$F8,$FB,$03,$00,$F8
                                  .db $F8,$00,$00,$F8,$FA,$02,$00,$F8
                                  .db $00,$00,$F8,$00,$00,$F8,$00,$F8
                                  .db $00,$00,$00,$00,$FB,$F8,$00,$F8
                                  .db $F4,$F8,$00,$F8,$00,$F8,$00,$F8
                                  .db $09,$09,$00,$10,$09,$09,$00,$10
                                  .db $08,$08,$00,$10,$05,$05,$00,$10
                                  .db $08,$08,$00,$10,$06,$06,$00,$10
                                  .db $00,$08,$08,$08,$00,$10,$00,$10
                                  .db $00,$08,$00,$08,$05,$10,$00,$10
                                  .db $0C,$10,$00,$10,$00,$10,$00,$10
DATA_01FE53:                      .db $FA,$F2,$00,$09,$F9,$F1,$00,$08
                                  .db $F8,$F0,$00,$08,$FE,$F6,$00,$08
                                  .db $FC,$F4,$00,$08,$FF,$F7,$00,$08
                                  .db $00,$F0,$F8,$F0,$00,$00,$00,$00
                                  .db $00,$00,$00,$00,$FC,$00,$00,$00
                                  .db $F9,$00,$00,$00,$00,$08,$00,$08
DATA_01FE83:                      .db $00,$0C,$02,$0A,$00,$0C,$22,$0A
                                  .db $00,$0C,$20,$0A,$00,$0C,$20,$0A
                                  .db $00,$0C,$20,$0A,$00,$0C,$20,$0A
                                  .db $24,$1C,$04,$1C,$0E,$0D,$0E,$0D
                                  .db $0E,$1D,$0E,$1D,$4A,$0D,$0E,$0D
                                  .db $4A,$0D,$0E,$0D,$20,$0A,$20,$0A
DATA_01FEB3:                      .db $06,$02,$08

DATA_01FEB6:                      .db $02

DATA_01FEB7:                      .db $00,$02,$00,$37,$3B

CODE_01FEBC:        B4 C2         LDY RAM_SpriteState,X     
CODE_01FEBE:        B9 B7 FE      LDA.W DATA_01FEB7,Y       
CODE_01FEC1:        85 0D         STA $0D                   
CODE_01FEC3:        84 05         STY $05                   
CODE_01FEC5:        BC EA 15      LDY.W RAM_SprOAMIndex,X   ; Y = Index into sprite OAM 
CODE_01FEC8:        BD 7C 15      LDA.W RAM_SpriteDir,X     
CODE_01FECB:        4A            LSR                       
CODE_01FECC:        6A            ROR                       
CODE_01FECD:        4A            LSR                       
CODE_01FECE:        29 40         AND.B #$40                
CODE_01FED0:        49 40         EOR.B #$40                
CODE_01FED2:        85 02         STA $02                   
CODE_01FED4:        BD 02 16      LDA.W $1602,X             
CODE_01FED7:        0A            ASL                       
CODE_01FED8:        0A            ASL                       
CODE_01FED9:        85 03         STA $03                   
CODE_01FEDB:        DA            PHX                       
CODE_01FEDC:        A2 03         LDX.B #$03                
CODE_01FEDE:        DA            PHX                       
CODE_01FEDF:        8A            TXA                       
CODE_01FEE0:        18            CLC                       
CODE_01FEE1:        65 03         ADC $03                   
CODE_01FEE3:        AA            TAX                       
CODE_01FEE4:        DA            PHX                       
CODE_01FEE5:        A5 02         LDA $02                   
CODE_01FEE7:        F0 05         BEQ CODE_01FEEE           
CODE_01FEE9:        8A            TXA                       
CODE_01FEEA:        18            CLC                       
CODE_01FEEB:        69 30         ADC.B #$30                
CODE_01FEED:        AA            TAX                       
CODE_01FEEE:        AD B8 14      LDA.W $14B8               
CODE_01FEF1:        38            SEC                       
CODE_01FEF2:        E9 08         SBC.B #$08                
CODE_01FEF4:        18            CLC                       
CODE_01FEF5:        7D F3 FD      ADC.W DATA_01FDF3,X       
CODE_01FEF8:        99 00 03      STA.W OAM_DispX,Y         
CODE_01FEFB:        FA            PLX                       
CODE_01FEFC:        AD BA 14      LDA.W $14BA               
CODE_01FEFF:        18            CLC                       
CODE_01FF00:        69 60         ADC.B #$60                
CODE_01FF02:        18            CLC                       
CODE_01FF03:        7D 53 FE      ADC.W DATA_01FE53,X       
CODE_01FF06:        99 01 03      STA.W OAM_DispY,Y         
CODE_01FF09:        BD 83 FE      LDA.W DATA_01FE83,X       
CODE_01FF0C:        99 02 03      STA.W OAM_Tile,Y          
CODE_01FF0F:        DA            PHX                       
CODE_01FF10:        A6 05         LDX $05                   
CODE_01FF12:        E0 03         CPX.B #$03                
CODE_01FF14:        D0 0C         BNE CODE_01FF22           
CODE_01FF16:        C9 05         CMP.B #$05                
CODE_01FF18:        B0 08         BCS CODE_01FF22           
CODE_01FF1A:        4A            LSR                       
CODE_01FF1B:        AA            TAX                       
CODE_01FF1C:        BD B3 FE      LDA.W DATA_01FEB3,X       
CODE_01FF1F:        99 02 03      STA.W OAM_Tile,Y          
CODE_01FF22:        B9 02 03      LDA.W OAM_Tile,Y          
CODE_01FF25:        C9 4A         CMP.B #$4A                
CODE_01FF27:        A5 0D         LDA $0D                   
CODE_01FF29:        90 02         BCC CODE_01FF2D           
CODE_01FF2B:        A9 35         LDA.B #$35                ;  Iggy ball palette 
CODE_01FF2D:        05 02         ORA $02                   
CODE_01FF2F:        99 03 03      STA.W OAM_Prop,Y          
CODE_01FF32:        68            PLA                       
CODE_01FF33:        29 03         AND.B #$03                
CODE_01FF35:        AA            TAX                       
CODE_01FF36:        5A            PHY                       
CODE_01FF37:        98            TYA                       
CODE_01FF38:        4A            LSR                       
CODE_01FF39:        4A            LSR                       
CODE_01FF3A:        A8            TAY                       
CODE_01FF3B:        BD B6 FE      LDA.W DATA_01FEB6,X       
CODE_01FF3E:        99 60 04      STA.W OAM_TileSize,Y      
CODE_01FF41:        7A            PLY                       
CODE_01FF42:        C8            INY                       
CODE_01FF43:        C8            INY                       
CODE_01FF44:        C8            INY                       
CODE_01FF45:        C8            INY                       
CODE_01FF46:        FA            PLX                       
CODE_01FF47:        CA            DEX                       
CODE_01FF48:        10 94         BPL CODE_01FEDE           
CODE_01FF4A:        FA            PLX                       
CODE_01FF4B:        A0 FF         LDY.B #$FF                
CODE_01FF4D:        A9 03         LDA.B #$03                
CODE_01FF4F:        20 BB B7      JSR.W FinishOAMWriteRt    
Return01FF52:       60            RTS                       ; Return 


DATA_01FF53:                      .db $2C,$2E,$2C,$2E

DATA_01FF57:                      .db $00,$00,$40,$00

CODE_01FF5B:        DA            PHX                       
CODE_01FF5C:        B4 C2         LDY RAM_SpriteState,X     
CODE_01FF5E:        B9 B7 FE      LDA.W DATA_01FEB7,Y       
CODE_01FF61:        85 0D         STA $0D                   
CODE_01FF63:        A0 70         LDY.B #$70                
CODE_01FF65:        AD B8 14      LDA.W $14B8               
CODE_01FF68:        38            SEC                       
CODE_01FF69:        E9 08         SBC.B #$08                
CODE_01FF6B:        99 00 03      STA.W OAM_DispX,Y         
CODE_01FF6E:        AD BA 14      LDA.W $14BA               
CODE_01FF71:        18            CLC                       
CODE_01FF72:        69 60         ADC.B #$60                
CODE_01FF74:        99 01 03      STA.W OAM_DispY,Y         
CODE_01FF77:        A5 14         LDA RAM_FrameCounterB     
CODE_01FF79:        4A            LSR                       
CODE_01FF7A:        29 03         AND.B #$03                
CODE_01FF7C:        AA            TAX                       
CODE_01FF7D:        BD 53 FF      LDA.W DATA_01FF53,X       
CODE_01FF80:        99 02 03      STA.W OAM_Tile,Y          
CODE_01FF83:        A9 30         LDA.B #$30                
CODE_01FF85:        1D 57 FF      ORA.W DATA_01FF57,X       
CODE_01FF88:        05 0D         ORA $0D                   
CODE_01FF8A:        99 03 03      STA.W OAM_Prop,Y          
CODE_01FF8D:        98            TYA                       
CODE_01FF8E:        4A            LSR                       
CODE_01FF8F:        4A            LSR                       
CODE_01FF90:        A8            TAY                       
CODE_01FF91:        A9 02         LDA.B #$02                
CODE_01FF93:        99 60 04      STA.W OAM_TileSize,Y      
CODE_01FF96:        FA            PLX                       
Return01FF97:       60            RTS                       ; Return 

CODE_01FF98:        B5 E4         LDA RAM_SpriteXLo,X       ; \ $14B4,$14B5 = Sprite X position + #$08 
CODE_01FF9A:        18            CLC                       ;  | 
CODE_01FF9B:        69 08         ADC.B #$08                ;  | 
CODE_01FF9D:        8D B4 14      STA.W $14B4               ;  | 
CODE_01FFA0:        BD E0 14      LDA.W RAM_SpriteXHi,X     ;  | 
CODE_01FFA3:        69 00         ADC.B #$00                ;  | 
CODE_01FFA5:        8D B5 14      STA.W $14B5               ; / 
CODE_01FFA8:        B5 D8         LDA RAM_SpriteYLo,X       ; \ $14B6,$14B7 = Sprite Y position + #$0F 
CODE_01FFAA:        18            CLC                       ;  | 
CODE_01FFAB:        69 0F         ADC.B #$0F                ;  | 
CODE_01FFAD:        8D B6 14      STA.W $14B6               ;  | 
CODE_01FFB0:        BD D4 14      LDA.W RAM_SpriteYHi,X     ;  | 
CODE_01FFB3:        69 00         ADC.B #$00                ;  | 
CODE_01FFB5:        8D B7 14      STA.W $14B7               ; / 
CODE_01FFB8:        DA            PHX                       
CODE_01FFB9:        22 9D CC 01   JSL.L CODE_01CC9D         
CODE_01FFBD:        FA            PLX                       
Return01FFBE:       60            RTS                       ; Return 


DATA_01FFBF:                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                  .db $FF