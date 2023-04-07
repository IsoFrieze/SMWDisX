    ORG $018000

DATA_018000:
    db $80,$40,$20,$10,$08,$04,$02,$01

IsTouchingObjSide:
    LDA.W SpriteBlockedDirs,X                 ; \ Set A to lower two bits of
    AND.B #$03                                ; / current sprite's Position Status
    RTS

IsOnGround:
    LDA.W SpriteBlockedDirs,X                 ; \ Set A to bit 2 of
    AND.B #$04                                ; / current sprite's Position Status
    RTS

IsTouchingCeiling:
    LDA.W SpriteBlockedDirs,X                 ; \ Set A to bit 3 of
    AND.B #$08                                ; / current sprite's Position Status
    RTS

UpdateYPosNoGvtyW:
    PHB
    PHK
    PLB
    JSR SubSprYPosNoGrvty
    PLB
    RTL

UpdateXPosNoGvtyW:
    PHB
    PHK
    PLB
    JSR SubSprXPosNoGrvty
    PLB
    RTL

UpdateSpritePos:
    PHB
    PHK
    PLB
    JSR SubUpdateSprPos
    PLB
    RTL

SprSprInteract:
    PHB
    PHK
    PLB
    JSR SubSprSprInteract
    PLB
    RTL

SprSpr_MarioSprRts:
    PHB
    PHK
    PLB
    JSR SubSprSpr_MarioSpr
    PLB
    RTL

GenericSprGfxRt0:
    PHB
    PHK
    PLB
    JSR SubSprGfx0Entry0
    PLB
    RTL

InvertAccum:
    EOR.B #$FF                                ; \ Set A to -A
    INC A                                     ; /
    RTS

CODE_01804E:
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if in air
    BEQ Return018072                          ; /
    LDA.B TrueFrame
    AND.B #$03
    ORA.B LevelIsSlippery
    BNE Return018072
    LDA.B #$04
    STA.B _0
    LDA.B #$0A
    STA.B _1
CODE_018063:
    JSR IsSprOffScreen
    BNE Return018072
    LDY.B #$03
CODE_01806A:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_018073
    DEY
    BPL CODE_01806A
Return018072:
    RTS

CODE_018073:
    LDA.B #$03
    STA.W SmokeSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    ADC.B _0
    STA.W SmokeSpriteXPos,Y
    LDA.B SpriteYPosLow,X
    ADC.B _1
    STA.W SmokeSpriteYPos,Y
    LDA.B #$13
    STA.W SmokeSpriteTimer,Y
    RTS

CODE_01808C:
    PHB
    PHK
    PLB
    LDA.W IsCarryingItem
    STA.W CarryingFlag                        ; Reset carrying enemy flag
    STZ.W IsCarryingItem
    STZ.W StandOnSolidSprite
    STZ.W PlayerInCloud
    LDA.W CurrentYoshiSlot
    STA.W YoshiIsLoose
    STZ.W CurrentYoshiSlot
    LDX.B #$0B
  - STX.W CurSpriteProcess
    JSR CODE_0180D2
    JSR HandleSprite
    DEX
    BPL -
    LDA.W ActivateClusterSprite
    BEQ +
    JSL CODE_02F808
  + LDA.W CurrentYoshiSlot
    BNE +
    STZ.W PlayerRidingYoshi
    STZ.W ScrShakePlayerYOffset
  + PLB
    RTL

IsSprOffScreen:
    LDA.W SpriteOffscreenX,X                  ; \ A = Current sprite is offscreen
    ORA.W SpriteOffscreenVert,X               ; /
    RTS

CODE_0180D2:
    PHX                                       ; In all sprite routines, X = current sprite
    TXA
    LDX.W SpriteMemorySetting                 ; $1692 = Current Sprite memory settings
    CLC                                       ; \
    ADC.L DATA_07F0B4,X                       ; |Add $07:F0B4,$1692 to sprite index.  i.e. minimum one tile allotted to each sprite
    TAX                                       ; |the bytes read go straight to the OAM indexes
    LDA.L DATA_07F000,X                       ; |
    PLX                                       ; /
    STA.W SpriteOAMIndex,X                    ; Current sprite's OAM index
    LDA.W SpriteStatus,X                      ; If  (something related to current sprite) is 0
    BEQ Return018126                          ; do not decrement these counters
    LDA.B SpriteLock                          ; Lock sprites timer
    BNE Return018126                          ; if sprites locked, do not decrement counters
    LDA.W SpriteMisc1540,X                    ; \ Decrement a bunch of sprite counter tables
    BEQ +                                     ; |
    DEC.W SpriteMisc1540,X                    ; |Do not decrement any individual counter if it's already at zero
  + LDA.W SpriteMisc154C,X                    ; |
    BEQ +                                     ; |
    DEC.W SpriteMisc154C,X                    ; |
  + LDA.W SpriteMisc1558,X                    ; |
    BEQ +                                     ; |
    DEC.W SpriteMisc1558,X                    ; |
  + LDA.W SpriteMisc1564,X                    ; |
    BEQ +                                     ; |
    DEC.W SpriteMisc1564,X                    ; |
  + LDA.W SpriteMisc1FE2,X                    ; |
    BEQ +                                     ; |
    DEC.W SpriteMisc1FE2,X                    ; |
  + LDA.W SpriteMisc15AC,X                    ; |
    BEQ +                                     ; |
    DEC.W SpriteMisc15AC,X                    ; |
  + LDA.W SpriteMisc163E,X                    ; |
    BEQ Return018126                          ; |
    DEC.W SpriteMisc163E,X                    ; |
Return018126:
    RTS                                       ; /

HandleSprite:
    LDA.W SpriteStatus,X                      ; Call a routine based on the sprite's status
    BEQ EraseSprite                           ; Routine for status 0 hardcoded, maybe for performance
    CMP.B #$08
    BNE +                                     ; Routine for status 8 hardcoded, maybe for preformance
    JMP CallSpriteMain

  + JSL ExecutePtr

    dw EraseSprite                            ; 0 - Non-existant (Bypassed above)
    dw CallSpriteInit                         ; 1 - Initialization
    dw HandleSprKilled                        ; 2 - Falling off screen (hit by star, shell, etc)
    dw HandleSprSmushed                       ; 3 - Smushed
    dw HandleSprSpinJump                      ; 4 - Spin Jumped
    dw CODE_019A7B                            ; 5
    dw HandleSprLvlEnd                        ; 6 - End of level turn to coin
    dw Return018156                           ; 7 - Unused
    dw Return0185C2                           ; 8 - Normal (Bypassed above)
    dw HandleSprStunned                       ; 9 - Stationary (Carryable, flipped, stunned)
    dw HandleSprKicked                        ; A - Kicked
    dw HandleSprCarried                       ; B - Carried
    dw HandleGoalPowerup                      ; C - Power up from carrying a sprite past the goal tape

EraseSprite:
    LDA.B #$FF                                ; \ Permanently erase sprite:
    STA.W SpriteLoadIndex,X                   ; | By changing the sprite's index into the level tables
Return018156:
    RTS                                       ; / the actual sprite won't get marked for reloading

HandleGoalPowerup:
    JSR CallSpriteMain
    JSR SubOffscreen0Bnk1
    JSR SubUpdateSprPos
    DEC.B SpriteYSpeed,X
    DEC.B SpriteYSpeed,X
    JSR IsOnGround
    BEQ +
    JSR SetSomeYSpeed__
  + RTS

HandleSprLvlEnd:
    JSL LvlEndSprCoins
    RTS

CallSpriteInit:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B SpriteNumber,X
    JSL ExecutePtr

    dw InitStandardSprite                     ; 00 - Green Koopa, no shell
    dw InitStandardSprite                     ; 01 - Red Koopa, no shell
    dw InitStandardSprite                     ; 02 - Blue Koopa, no shell
    dw InitStandardSprite                     ; 03 - Yellow Koopa, no shell
    dw InitStandardSprite                     ; 04 - Green Koopa
    dw InitStandardSprite                     ; 05 - Red Koopa
    dw InitStandardSprite                     ; 06 - Blue Koopa
    dw InitStandardSprite                     ; 07 - Yellow Koopa
    dw InitStandardSprite                     ; 08 - Green Koopa, flying left
    dw InitGrnBounceKoopa                     ; 09 - Green bouncing Koopa
    dw InitStandardSprite                     ; 0A - Red vertical flying Koopa
    dw InitStandardSprite                     ; 0B - Red horizontal flying Koopa
    dw InitStandardSprite                     ; 0C - Yellow Koopa with wings
    dw InitBomb                               ; 0D - Bob-omb
    dw InitKeyHole                            ; 0E - Keyhole
    dw InitStandardSprite                     ; 0F - Goomba
    dw InitStandardSprite                     ; 10 - Bouncing Goomba with wings
    dw InitStandardSprite                     ; 11 - Buzzy Beetle
    dw UnusedInit                             ; 12 - Unused
    dw InitStandardSprite                     ; 13 - Spiny
    dw InitStandardSprite                     ; 14 - Spiny falling
    dw Return01B011                           ; 15 - Fish, horizontal
    dw InitVerticalFish                       ; 16 - Fish, vertical
    dw InitFish                               ; 17 - Fish, created from generator
    dw InitFish                               ; 18 - Surface jumping fish
    dw InitMsg_SideExit                       ; 19 - Display text from level Message Box #1
    dw InitPiranha                            ; 1A - Classic Piranha Plant
    dw Return0185C2                           ; 1B - Bouncing football in place
    dw InitBulletBill                         ; 1C - Bullet Bill
    dw InitStandardSprite                     ; 1D - Hopping flame
    dw InitLakitu                             ; 1E - Lakitu
    dw InitMagikoopa                          ; 1F - Magikoopa
    dw Return018583                           ; 20 - Magikoopa's magic
    dw FaceMario                              ; 21 - Moving coin
    dw InitVertNetKoopa                       ; 22 - Green vertical net Koopa
    dw InitVertNetKoopa                       ; 23 - Red vertical net Koopa
    dw InitHorzNetKoopa                       ; 24 - Green horizontal net Koopa
    dw InitHorzNetKoopa                       ; 25 - Red horizontal net Koopa
    dw InitThwomp                             ; 26 - Thwomp
    dw Return01AEA2                           ; 27 - Thwimp
    dw InitBigBoo                             ; 28 - Big Boo
    dw InitKoopaKid                           ; 29 - Koopa Kid
    dw InitDownPiranha                        ; 2A - Upside down Piranha Plant
    dw Return0185C2                           ; 2B - Sumo Brother's fire lightning
    dw InitYoshiEgg                           ; 2C - Yoshi egg
    dw InitKey_BabyYoshi                      ; 2D - Baby green Yoshi
    dw InitSpikeTop                           ; 2E - Spike Top
    dw Return0185C2                           ; 2F - Portable spring board
    dw FaceMario                              ; 30 - Dry Bones, throws bones
    dw FaceMario                              ; 31 - Bony Beetle
    dw FaceMario                              ; 32 - Dry Bones, stay on ledge
    dw InitFireball                           ; 33 - Fireball
    dw Return0185C2                           ; 34 - Boss fireball
    dw InitYoshi                              ; 35 - Green Yoshi
    dw Return0185C2                           ; 36 - Unused
    dw InitBigBoo                             ; 37 - Boo
    dw InitEerie                              ; 38 - Eerie
    dw InitEerie                              ; 39 - Eerie, wave motion
    dw InitUrchin                             ; 3A - Urchin, fixed
    dw InitUrchin                             ; 3B - Urchin, wall detect
    dw InitUrchinWallFllw                     ; 3C - Urchin, wall follow
    dw InitRipVanFish                         ; 3D - Rip Van Fish
    dw InitPSwitch                            ; 3E - POW
    dw Return0185C2                           ; 3F - Para-Goomba
    dw Return0185C2                           ; 40 - Para-Bomb
    dw Return01843D                           ; 41 - Dolphin, horizontal
    dw Return01843D                           ; 42 - Dolphin2, horizontal
    dw Return01843D                           ; 43 - Dolphin, vertical
    dw Return01843D                           ; 44 - Torpedo Ted
    dw Return0185C2                           ; 45 - Directional coins
    dw InitDigginChuck                        ; 46 - Diggin' Chuck
    dw Return0183EE                           ; 47 - Swimming/Jumping fish
    dw Return0183EE                           ; 48 - Diggin' Chuck's rock
    dw InitGrowingPipe                        ; 49 - Growing/shrinking pipe end
    dw Return0183EE                           ; 4A - Goal Point Question Sphere
    dw InitPiranha                            ; 4B - Pipe dwelling Lakitu
    dw InitExplodingBlk                       ; 4C - Exploding Block
    dw InitMontyMole                          ; 4D - Ground dwelling Monty Mole
    dw InitMontyMole                          ; 4E - Ledge dwelling Monty Mole
    dw InitPiranha                            ; 4F - Jumping Piranha Plant
    dw InitPiranha                            ; 50 - Jumping Piranha Plant, spit fire
    dw FaceMario                              ; 51 - Ninji
    dw InitMovingLedge                        ; 52 - Moving ledge hole in ghost house
    dw Return0185C2                           ; 53 - Throw block sprite
    dw InitClimbingDoor                       ; 54 - Climbing net door
    dw InitChckbrdPlat                        ; 55 - Checkerboard platform, horizontal
    dw Return01B25D                           ; 56 - Flying rock platform, horizontal
    dw InitChckbrdPlat                        ; 57 - Checkerboard platform, vertical
    dw Return01B25D                           ; 58 - Flying rock platform, vertical
    dw Return01B267                           ; 59 - Turn block bridge, horizontal and vertical
    dw Return01B267                           ; 5A - Turn block bridge, horizontal
    dw InitFloatingPlat                       ; 5B - Brown platform floating in water
    dw InitFallingPlat                        ; 5C - Checkerboard platform that falls
    dw InitFloatingPlat                       ; 5D - Orange platform floating in water
    dw InitOrangePlat                         ; 5E - Orange platform, goes on forever
    dw InitBrwnChainPlat                      ; 5F - Brown platform on a chain
    dw Return01AE90                           ; 60 - Flat green switch palace switch
    dw InitFloatingSkull                      ; 61 - Floating skulls
    dw InitLineBrwnPlat                       ; 62 - Brown platform, line-guided
    dw InitLinePlat                           ; 63 - Checker/brown platform, line-guided
    dw InitLineRope                           ; 64 - Rope mechanism, line-guided
    dw InitLineGuidedSpr                      ; 65 - Chainsaw, line-guided
    dw InitLineGuidedSpr                      ; 66 - Upside down chainsaw, line-guided
    dw InitLineGuidedSpr                      ; 67 - Grinder, line-guided
    dw InitLineGuidedSpr                      ; 68 - Fuzz ball, line-guided
    dw Return01D6C3                           ; 69 - Unused
    dw Return0185C2                           ; 6A - Coin game cloud
    dw Return01843D                           ; 6B - Spring board, left wall
    dw InitPeaBouncer                         ; 6C - Spring board, right wall
    dw Return0185C2                           ; 6D - Invisible solid block
    dw InitDinos                              ; 6E - Dino Rhino
    dw InitDinos                              ; 6F - Dino Torch
    dw InitPokey                              ; 70 - Pokey
    dw InitSuperKoopa                         ; 71 - Super Koopa, red cape
    dw InitSuperKoopa                         ; 72 - Super Koopa, yellow cape
    dw InitSuperKoopaFthr                     ; 73 - Super Koopa, feather
    dw InitPowerUp                            ; 74 - Mushroom
    dw InitPowerUp                            ; 75 - Flower
    dw InitPowerUp                            ; 76 - Star
    dw InitPowerUp                            ; 77 - Feather
    dw InitPowerUp                            ; 78 - 1-Up
    dw Return018583                           ; 79 - Growing Vine
    dw Return018583                           ; 7A - Firework
    dw InitGoalTape                           ; 7B - Goal Point
    dw Return0185C2                           ; 7C - Princess Peach
    dw Return0185C2                           ; 7D - Balloon
    dw Return0185C2                           ; 7E - Flying Red coin
    dw Return0185C2                           ; 7F - Flying yellow 1-Up
    dw InitKey_BabyYoshi                      ; 80 - Key
    dw InitChangingItem                       ; 81 - Changing item from translucent block
    dw InitBonusGame                          ; 82 - Bonus game sprite
    dw InitFlying_Block                       ; 83 - Left flying question block
    dw InitFlying_Block                       ; 84 - Flying question block
    dw Return0185C2                           ; 85 - Unused (Pretty sure)
    dw InitWiggler                            ; 86 - Wiggler
    dw Return0185C2                           ; 87 - Lakitu's cloud
    dw InitWingedCage                         ; 88 - Unused (Winged cage sprite)
    dw Return01843D                           ; 89 - Layer 3 smash
    dw Return0185C2                           ; 8A - Bird from Yoshi's house
    dw Return0185C2                           ; 8B - Puff of smoke from Yoshi's house
    dw InitMsg_SideExit                       ; 8C - Fireplace smoke/exit from side screen
    dw Return0185C2                           ; 8D - Ghost house exit sign and door
    dw Return0185C2                           ; 8E - Invisible "Warp Hole" blocks
    dw InitScalePlats                         ; 8F - Scale platforms
    dw FaceMario                              ; 90 - Large green gas bubble
    dw Return018869                           ; 91 - Chargin' Chuck
    dw InitChuck                              ; 92 - Splittin' Chuck
    dw InitChuck                              ; 93 - Bouncin' Chuck
    dw InitWhistlinChuck                      ; 94 - Whistlin' Chuck
    dw InitClappinChuck                       ; 95 - Clapin' Chuck
    dw Return018869                           ; 96 - Unused (Chargin' Chuck clone)
    dw InitPuntinChuck                        ; 97 - Puntin' Chuck
    dw InitPitchinChuck                       ; 98 - Pitchin' Chuck
    dw Return0183EE                           ; 99 - Volcano Lotus
    dw InitSumoBrother                        ; 9A - Sumo Brother
    dw InitHammerBrother                      ; 9B - Hammer Brother
    dw Return0185C2                           ; 9C - Flying blocks for Hammer Brother
    dw InitBubbleSpr                          ; 9D - Bubble with sprite
    dw InitBallNChain                         ; 9E - Ball and Chain
    dw InitBanzai                             ; 9F - Banzai Bill
    dw InitBowserScene                        ; A0 - Activates Bowser scene
    dw Return0185C2                           ; A1 - Bowser's bowling ball
    dw Return0185C2                           ; A2 - MechaKoopa
    dw InitGreyChainPlat                      ; A3 - Grey platform on chain
    dw InitFloatSpkBall                       ; A4 - Floating Spike ball
    dw InitFuzzBall_Spark                     ; A5 - Fuzzball/Sparky, ground-guided
    dw InitFuzzBall_Spark                     ; A6 - HotHead, ground-guided
    dw Return0185C2                           ; A7 - Iggy's ball
    dw Return0185C2                           ; A8 - Blargg
    dw InitReznor                             ; A9 - Reznor
    dw InitFishbone                           ; AA - Fishbone
    dw FaceMario                              ; AB - Rex
    dw InitWoodSpike                          ; AC - Wooden Spike, moving down and up
    dw InitWoodSpike2                         ; AD - Wooden Spike, moving up/down first
    dw Return0185C2                           ; AE - Fishin' Boo
    dw Return0185C2                           ; AF - Boo Block
    dw InitDiagBouncer                        ; B0 - Reflecting stream of Boo Buddies
    dw InitCreateEatBlk                       ; B1 - Creating/Eating block
    dw Return0185C2                           ; B2 - Falling Spike
    dw InitBowsersFire                        ; B3 - Bowser statue fireball
    dw FaceMario                              ; B4 - Grinder, non-line-guided
    dw Return0185C2                           ; B5 - Sinking fireball used in boss battles
    dw InitDiagBouncer                        ; B6 - Reflecting fireball
    dw Return0185C2                           ; B7 - Carrot Top lift, upper right
    dw Return0185C2                           ; B8 - Carrot Top lift, upper left
    dw Return0185C2                           ; B9 - Info Box
    dw InitTimedPlat                          ; BA - Timed lift
    dw Return0185C2                           ; BB - Grey moving castle block
    dw InitBowserStatue                       ; BC - Bowser statue
    dw InitSlidingKoopa                       ; BD - Sliding Koopa without a shell
    dw Return0185C2                           ; BE - Swooper bat
    dw FaceMario                              ; BF - Mega Mole
    dw InitGreyLavaPlat                       ; C0 - Grey platform on lava
    dw InitMontyMole                          ; C1 - Flying grey turnblocks
    dw FaceMario                              ; C2 - Blurp fish
    dw FaceMario                              ; C3 - Porcu-Puffer fish
    dw Return0185C2                           ; C4 - Grey platform that falls
    dw FaceMario                              ; C5 - Big Boo Boss
    dw Return018313                           ; C6 - Dark room with spot light
    dw Return0185C2                           ; C7 - Invisible mushroom
    dw Return0185C2                           ; C8 - Light switch block for dark room

InitGreyLavaPlat:
    INC.B SpriteYPosLow,X
    INC.B SpriteYPosLow,X
Return018313:
    RTS

InitBowserStatue:
    INC.W SpriteMisc157C,X
    JSR InitExplodingBlk
    STY.B SpriteTableC2,X
    CPY.B #$02
    BNE +
    LDA.B #$01
    STA.W SpriteOBJAttribute,X
  + RTS

InitTimedPlat:
    LDY.B #$3F
    LDA.B SpriteXPosLow,X
    AND.B #$10
    BNE +
    LDY.B #$FF
  + TYA
    STA.W SpriteMisc1570,X
    RTS


YoshiPal:
    db $09,$07,$05,$07

InitYoshiEgg:
    LDA.B SpriteXPosLow,X
    LSR A
    LSR A
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W YoshiPal,Y
    STA.W SpriteOBJAttribute,X
    INC.W SpriteMisc187B,X
    RTS


DATA_01834C:
    db $10,$F0

InitDiagBouncer:
    JSR FaceMario
    LDA.W DATA_01834C,Y
    STA.B SpriteXSpeed,X
    LDA.B #$F0
    STA.B SpriteYSpeed,X
    RTS

InitWoodSpike:
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$40
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    RTS

InitWoodSpike2:
    JMP InitMontyMole

InitBowserScene:
    JSL CODE_03A0F1
    RTS

InitSumoBrother:
    LDA.B #$03
    STA.B SpriteTableC2,X
    LDA.B #$70
  - STA.W SpriteMisc1540,X
    RTS

InitSlidingKoopa:
    LDA.B #$04
    BRA -

InitGrowingPipe:
    LDA.B #$40
    STA.W SpriteMisc1534,X
    RTS

InitBanzai:
    JSR SubHorizPos
    TYA
    BNE +
    JMP OffScrEraseSprite

  + LDA.B #!SFX_KAPOW
    STA.W SPCIO3                              ; / Play sound effect
    RTS

InitBallNChain:
    LDA.B #$38
    BRA +

InitGreyChainPlat:
    LDA.B #$30
  + STA.W SpriteMisc187B,X
    RTS


ExplodingBlkSpr:
    db $15,$0F,$00,$04

InitExplodingBlk:
    LDA.B SpriteXPosLow,X
    LSR A
    LSR A
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W ExplodingBlkSpr,Y
    STA.B SpriteTableC2,X
    RTS


DATA_0183B3:
    db $80,$40

InitScalePlats:
    LDA.B SpriteYPosLow,X
    STA.W SpriteMisc1534,X
    LDA.W SpriteYPosHigh,X
    STA.W SpriteMisc151C,X
    LDA.B SpriteXPosLow,X
    AND.B #$10
    LSR A
    LSR A
    LSR A
    LSR A
    TAY
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_0183B3,Y
    STA.B SpriteTableC2,X
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteMisc1602,X
    RTS

InitMsg_SideExit:
    LDA.B #$28                                ; \ Set current sprite's "disable contact with other sprites" timer to x28
    STA.W SpriteMisc1564,X                    ; /
    RTS

InitYoshi:
    DEC.W SpriteMisc160E,X
    INC.W SpriteMisc157C,X
    LDA.W CarryYoshiThruLvls
    BEQ Return0183EE
    STZ.W SpriteStatus,X
Return0183EE:
    RTS


DATA_0183EF:
    db $08

DATA_0183F0:
    db $00,$08

InitSpikeTop:
    JSR SubHorizPos
    TYA
    EOR.B #$01
    ASL A
    ASL A
    ASL A
    ASL A
    JSR CODE_01841D
    STZ.W SpriteInLiquid,X
    BRA CODE_01840E

InitUrchinWallFllw:
    INC.B SpriteYPosLow,X
    BNE InitFuzzBall_Spark
    INC.W SpriteYPosHigh,X
InitFuzzBall_Spark:
    JSR InitUrchin
CODE_01840E:
    LDA.W SpriteMisc151C,X
    EOR.B #$10
    STA.W SpriteMisc151C,X
    LSR A
    LSR A
    STA.B SpriteTableC2,X
    RTS

InitUrchin:
    LDA.B SpriteXPosLow,X
CODE_01841D:
    LDY.B #$00
    AND.B #$10
    STA.W SpriteMisc151C,X
    BNE +
    INY
  + LDA.W DATA_0183EF,Y
    STA.B SpriteXSpeed,X
    LDA.W DATA_0183F0,Y
    STA.B SpriteYSpeed,X
InitRipVanFish:
    INC.W SpriteInLiquid,X
    RTS

InitKey_BabyYoshi:
    LDA.B #$09                                ; \ Sprite status = Carryable
    STA.W SpriteStatus,X                      ; /
    RTS

InitChangingItem:
    INC.B SpriteTableC2,X
Return01843D:
    RTS

InitPeaBouncer:
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B #$08
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    SBC.B #$00
    STA.W SpriteXPosHigh,X
    RTS

InitPSwitch:
    LDA.B SpriteXPosLow,X                     ; \ $151C,x = Blue/Silver,
    LSR A                                     ; | depending on initial X position
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    AND.B #$01                                ; |
    STA.W SpriteMisc151C,X                    ; /
    TAY                                       ; \ Store appropriate palette to RAM
    LDA.W PSwitchPal,Y                        ; |
    STA.W SpriteOBJAttribute,X                ; /
    LDA.B #$09                                ; \ Sprite status = Carryable
    STA.W SpriteStatus,X                      ; /
    RTS


PSwitchPal:
    db $06,$02

ADDR_018468:
    JMP OffScrEraseSprite

InitLakitu:
    LDY.B #$09
CODE_01846D:
    CPY.W CurSpriteProcess
    BEQ CODE_018484
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BNE CODE_018484
    LDA.W SpriteNumber,Y
    CMP.B #$87
    BEQ ADDR_018468
    CMP.B #$1E
    BEQ ADDR_018468
CODE_018484:
    DEY
    BPL CODE_01846D
    STZ.W SpriteRespawnTimer
    STZ.W SpriteWillAppear
    STZ.W CurrentGenerator
    LDA.B SpriteYPosLow,X
    STA.W SpriteRespawnYPos
    LDA.W SpriteYPosHigh,X
    STA.W SpriteRespawnYPos+1
    JSL FindFreeSprSlot
    BMI InitMontyMole
    STY.W LakituCloudSlot
    LDA.B #$87                                ; \ Sprite = Lakitu Cloud
    STA.W SpriteNumber,Y                      ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    PLX
    STZ.W LakituCloudTimer
InitMontyMole:
    LDA.B SpriteXPosLow,X
    AND.B #$10
    STA.W SpriteMisc151C,X
    RTS

InitCreateEatBlk:
    LDA.B #$FF
    STA.W BlockSnakeActive
    BRA InitMontyMole

InitBulletBill:
    JSR SubHorizPos
    TYA
    STA.B SpriteTableC2,X
    LDA.B #$10
    STA.W SpriteMisc1540,X
    RTS

InitClappinChuck:
    LDA.B #$08
    BRA +

InitPitchinChuck:
    LDA.B SpriteXPosLow,X
    AND.B #$30
    LSR A
    LSR A
    LSR A
    LSR A
    STA.W SpriteMisc187B,X
    LDA.B #$0A
    BRA +

InitPuntinChuck:
    LDA.B #$09
    BRA +

InitWhistlinChuck:
    LDA.B #$0B
    BRA +

InitChuck:
    LDA.B #$05
    BRA +

InitDigginChuck:
    LDA.B #$30
    STA.W SpriteMisc1540,X
    LDA.B SpriteXPosLow,X
    AND.B #$10
    LSR A
    LSR A
    LSR A
    LSR A
    STA.W SpriteMisc157C,X
    LDA.B #$04
  + STA.B SpriteTableC2,X
    JSR FaceMario
    LDA.W DATA_018526,Y
    STA.W SpriteMisc151C,X
    RTS


DATA_018526:
    db $00,$04

InitSuperKoopa:
    LDA.B #$28
    STA.B SpriteYSpeed,X
    BRA FaceMario

InitSuperKoopaFthr:
    JSR FaceMario
    LDA.B SpriteXPosLow,X
    AND.B #$10
    BEQ +
    LDA.B #$10                                ; \ Can be jumped on
    STA.W SpriteTweakerA,X                    ; /
    LDA.B #$80
    STA.W SpriteTweakerB,X
    LDA.B #$10
    STA.W SpriteTweakerE,X
    RTS

  + INC.W SpriteMisc1534,X
    RTS

InitPokey:
    LDA.B #$1F                                ; \ If on Yoshi, $C2,x = #$1F
    LDY.W PlayerRidingYoshi                   ; | (5 segments, 1 bit each)
    BNE +                                     ; |
    LDA.B #$07                                ; | If not on Yoshi, $C2,x = #$07
  + STA.B SpriteTableC2,X                     ; /   (3 segments, 1 bit each)
    BRA FaceMario

InitDinos:
    LDA.B #$04
    STA.W SpriteMisc151C,X
InitBomb:
    LDA.B #$FF
    STA.W SpriteMisc1540,X
    BRA FaceMario

InitBubbleSpr:
    JSR InitExplodingBlk
    STY.B SpriteTableC2,X
    DEC.W SpriteMisc1534,X
    BRA FaceMario

InitGrnBounceKoopa:
    LDA.B SpriteYPosLow,X
    AND.B #$10
    STA.W SpriteMisc160E,X
InitStandardSprite:
    JSL GetRand
    STA.W SpriteMisc1570,X
FaceMario:
    JSR SubHorizPos
    TYA
    STA.W SpriteMisc157C,X
Return018583:
    RTS

InitBowsersFire:
    LDA.B #!SFX_FIRESPIT
    STA.W SPCIO3                              ; / Play sound effect
    BRA FaceMario

InitPowerUp:
    INC.B SpriteTableC2,X
    RTS

InitFishbone:
    JSL GetRand
    AND.B #$1F
    STA.W SpriteMisc1540,X
    JMP FaceMario

InitDownPiranha:
    ASL.W SpriteOBJAttribute,X
    SEC
    ROR.W SpriteOBJAttribute,X
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$10
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,X
InitPiranha:
    LDA.B SpriteXPosLow,X                     ; \ Center sprite between two tiles
    CLC                                       ; |
    ADC.B #$08                                ; |
    STA.B SpriteXPosLow,X                     ; /
    DEC.B SpriteYPosLow,X
    LDA.B SpriteYPosLow,X
    CMP.B #$FF
    BNE Return0185C2
    DEC.W SpriteYPosHigh,X
Return0185C2:
    RTS

CallSpriteMain:
    STZ.W SpriteXMovement                     ; CallSpriteMain
    LDA.B SpriteNumber,X
    JSL ExecutePtr

    dw ShellessKoopas                         ; 00 - Green Koopa, no shell
    dw ShellessKoopas                         ; 01 - Red Koopa, no shell
    dw ShellessKoopas                         ; 02 - Blue Koopa, no shell
    dw ShellessKoopas                         ; 03 - Yellow Koopa, no shell
    dw Spr0to13Start                          ; 04 - Green Koopa
    dw Spr0to13Start                          ; 05 - Red Koopa
    dw Spr0to13Start                          ; 06 - Blue Koopa
    dw Spr0to13Start                          ; 07 - Yellow Koopa
    dw GreenParaKoopa                         ; 08 - Green Koopa, flying left
    dw GreenParaKoopa                         ; 09 - Green bouncing Koopa
    dw RedVertParaKoopa                       ; 0A - Red vertical flying Koopa
    dw RedHorzParaKoopa                       ; 0B - Red horizontal flying Koopa
    dw Spr0to13Start                          ; 0C - Yellow Koopa with wings
    dw Bobomb                                 ; 0D - Bob-omb
    dw Keyhole                                ; 0E - Keyhole
    dw Spr0to13Start                          ; 0F - Goomba
    dw WingedGoomba                           ; 10 - Bouncing Goomba with wings
    dw Spr0to13Start                          ; 11 - Buzzy Beetle
    dw Return01F87B                           ; 12 - Unused
    dw Spr0to13Start                          ; 13 - Spiny
    dw SpinyEgg                               ; 14 - Spiny falling
    dw Fish                                   ; 15 - Fish, horizontal
    dw Fish                                   ; 16 - Fish, vertical
    dw GeneratedFish                          ; 17 - Fish, created from generator
    dw JumpingFish                            ; 18 - Surface jumping fish
    dw PSwitch                                ; 19 - Display text from level Message Box #1
    dw ClassicPiranhas                        ; 1A - Classic Piranha Plant
    dw Bank3SprHandler                        ; 1B - Bouncing football in place
    dw BulletBill                             ; 1C - Bullet Bill
    dw HoppingFlame                           ; 1D - Hopping flame
    dw Lakitu                                 ; 1E - Lakitu
    dw Magikoopa                              ; 1F - Magikoopa
    dw MagikoopasMagic                        ; 20 - Magikoopa's magic
    dw PowerUpRt                              ; 21 - Moving coin
    dw ClimbingKoopa                          ; 22 - Green vertical net Koopa
    dw ClimbingKoopa                          ; 23 - Red vertical net Koopa
    dw ClimbingKoopa                          ; 24 - Green horizontal net Koopa
    dw ClimbingKoopa                          ; 25 - Red horizontal net Koopa
    dw Thwomp                                 ; 26 - Thwomp
    dw Thwimp                                 ; 27 - Thwimp
    dw BigBoo                                 ; 28 - Big Boo
    dw KoopaKid                               ; 29 - Koopa Kid
    dw ClassicPiranhas                        ; 2A - Upside down Piranha Plant
    dw SumosLightning                         ; 2B - Sumo Brother's fire lightning
    dw YoshiEgg                               ; 2C - Yoshi egg
    dw Return0185C2                           ; 2D - Baby green Yoshi
    dw WallFollowers                          ; 2E - Spike Top
    dw SpringBoard                            ; 2F - Portable spring board
    dw DryBonesAndBeetle                      ; 30 - Dry Bones, throws bones
    dw DryBonesAndBeetle                      ; 31 - Bony Beetle
    dw DryBonesAndBeetle                      ; 32 - Dry Bones, stay on ledge
    dw Fireballs                              ; 33 - Fireball
    dw BossFireball                           ; 34 - Boss fireball
    dw Yoshi                                  ; 35 - Green Yoshi
    dw DATA_01E41F                            ; 36 - Unused
    dw Boo_BooBlock                           ; 37 - Boo
    dw Eerie                                  ; 38 - Eerie
    dw Eerie                                  ; 39 - Eerie, wave motion
    dw WallFollowers                          ; 3A - Urchin, fixed
    dw WallFollowers                          ; 3B - Urchin, wall detect
    dw WallFollowers                          ; 3C - Urchin, wall follow
    dw RipVanFish                             ; 3D - Rip Van Fish
    dw PSwitch                                ; 3E - POW
    dw ParachuteSprites                       ; 3F - Para-Goomba
    dw ParachuteSprites                       ; 40 - Para-Bomb
    dw Dolphin                                ; 41 - Dolphin, horizontal
    dw Dolphin                                ; 42 - Dolphin2, horizontal
    dw Dolphin                                ; 43 - Dolphin, vertical
    dw TorpedoTed                             ; 44 - Torpedo Ted
    dw DirectionalCoins                       ; 45 - Directional coins
    dw DigginChuck                            ; 46 - Diggin' Chuck
    dw SwimJumpFish                           ; 47 - Swimming/Jumping fish
    dw DigginChucksRock                       ; 48 - Diggin' Chuck's rock
    dw GrowingPipe                            ; 49 - Growing/shrinking pipe end
    dw GoalSphere                             ; 4A - Goal Point Question Sphere
    dw PipeLakitu                             ; 4B - Pipe dwelling Lakitu
    dw ExplodingBlock                         ; 4C - Exploding Block
    dw MontyMole                              ; 4D - Ground dwelling Monty Mole
    dw MontyMole                              ; 4E - Ledge dwelling Monty Mole
    dw JumpingPiranha                         ; 4F - Jumping Piranha Plant
    dw JumpingPiranha                         ; 50 - Jumping Piranha Plant, spit fire
    dw Bank3SprHandler                        ; 51 - Ninji
    dw MovingLedge                            ; 52 - Moving ledge hole in ghost house
    dw Return0185C2                           ; 53 - Throw block sprite
    dw ClimbingDoor                           ; 54 - Climbing net door
    dw Platforms                              ; 55 - Checkerboard platform, horizontal
    dw Platforms                              ; 56 - Flying rock platform, horizontal
    dw Platforms                              ; 57 - Checkerboard platform, vertical
    dw Platforms                              ; 58 - Flying rock platform, vertical
    dw TurnBlockBridge                        ; 59 - Turn block bridge, horizontal and vertical
    dw HorzTurnBlkBridge                      ; 5A - Turn block bridge, horizontal
    dw Platforms2                             ; 5B - Brown platform floating in water
    dw Platforms2                             ; 5C - Checkerboard platform that falls
    dw Platforms2                             ; 5D - Orange platform floating in water
    dw OrangePlatform                         ; 5E - Orange platform, goes on forever
    dw BrownChainedPlat                       ; 5F - Brown platform on a chain
    dw PalaceSwitch                           ; 60 - Flat green switch palace switch
    dw FloatingSkulls                         ; 61 - Floating skulls
    dw LineFuzzy_Plats                        ; 62 - Brown platform, line-guided
    dw LineFuzzy_Plats                        ; 63 - Checker/brown platform, line-guided
    dw LineRope_Chainsaw                      ; 64 - Rope mechanism, line-guided
    dw LineRope_Chainsaw                      ; 65 - Chainsaw, line-guided
    dw LineRope_Chainsaw                      ; 66 - Upside down chainsaw, line-guided
    dw LineGrinder                            ; 67 - Grinder, line-guided
    dw LineFuzzy_Plats                        ; 68 - Fuzz ball, line-guided
    dw Return01D6C3                           ; 69 - Unused
    dw CoinCloud                              ; 6A - Coin game cloud
    dw PeaBouncer                             ; 6B - Spring board, left wall
    dw PeaBouncer                             ; 6C - Spring board, right wall
    dw InvisSolid_Dinos                       ; 6D - Invisible solid block
    dw InvisSolid_Dinos                       ; 6E - Dino Rhino
    dw InvisSolid_Dinos                       ; 6F - Dino Torch
    dw Pokey                                  ; 70 - Pokey
    dw RedSuperKoopa                          ; 71 - Super Koopa, red cape
    dw YellowSuperKoopa                       ; 72 - Super Koopa, yellow cape
    dw FeatherSuperKoopa                      ; 73 - Super Koopa, feather
    dw PowerUpRt                              ; 74 - Mushroom
    dw FireFlower                             ; 75 - Flower
    dw PowerUpRt                              ; 76 - Star
    dw Feather                                ; 77 - Feather
    dw PowerUpRt                              ; 78 - 1-Up
    dw GrowingVine                            ; 79 - Growing Vine
    dw Bank3SprHandler                        ; 7A - Firework
    dw GoalTape                               ; 7B - Goal Point
    dw Bank3SprHandler                        ; 7C - Princess Peach
    dw BalloonKeyFlyObjs                      ; 7D - Balloon
    dw BalloonKeyFlyObjs                      ; 7E - Flying Red coin
    dw BalloonKeyFlyObjs                      ; 7F - Flying yellow 1-Up
    dw BalloonKeyFlyObjs                      ; 80 - Key
    dw ChangingItem                           ; 81 - Changing item from translucent block
    dw BonusGame                              ; 82 - Bonus game sprite
    dw Flying_Block                           ; 83 - Left flying question block
    dw Flying_Block                           ; 84 - Flying question block
    dw InitFlying_Block                       ; 85 - Unused (Pretty sure)
    dw Wiggler                                ; 86 - Wiggler
    dw LakituCloud                            ; 87 - Lakitu's cloud
    dw WingedCage                             ; 88 - Unused (Winged cage sprite)
    dw Layer3Smash                            ; 89 - Layer 3 smash
    dw YoshisHouseBirds                       ; 8A - Bird from Yoshi's house
    dw YoshisHouseSmoke                       ; 8B - Puff of smoke from Yoshi's house
    dw SideExit                               ; 8C - Fireplace smoke/exit from side screen
    dw GhostHouseExit                         ; 8D - Ghost house exit sign and door
    dw WarpBlocks                             ; 8E - Invisible "Warp Hole" blocks
    dw ScalePlatforms                         ; 8F - Scale platforms
    dw GasBubble                              ; 90 - Large green gas bubble
    dw Chucks                                 ; 91 - Chargin' Chuck
    dw Chucks                                 ; 92 - Splittin' Chuck
    dw Chucks                                 ; 93 - Bouncin' Chuck
    dw Chucks                                 ; 94 - Whistlin' Chuck
    dw Chucks                                 ; 95 - Clapin' Chuck
    dw Chucks                                 ; 96 - Unused (Chargin' Chuck clone)
    dw Chucks                                 ; 97 - Puntin' Chuck
    dw Chucks                                 ; 98 - Pitchin' Chuck
    dw VolcanoLotus                           ; 99 - Volcano Lotus
    dw SumoBrother                            ; 9A - Sumo Brother
    dw HammerBrother                          ; 9B - Hammer Brother
    dw FlyingPlatform                         ; 9C - Flying blocks for Hammer Brother
    dw BubbleWithSprite                       ; 9D - Bubble with sprite
    dw BanzaiBnCGrayPlat                      ; 9E - Ball and Chain
    dw BanzaiBnCGrayPlat                      ; 9F - Banzai Bill
    dw Bank3SprHandler                        ; A0 - Activates Bowser scene
    dw Bank3SprHandler                        ; A1 - Bowser's bowling ball
    dw Bank3SprHandler                        ; A2 - MechaKoopa
    dw BanzaiBnCGrayPlat                      ; A3 - Grey platform on chain
    dw FloatingSpikeBall                      ; A4 - Floating Spike ball
    dw WallFollowers                          ; A5 - Fuzzball/Sparky, ground-guided
    dw WallFollowers                          ; A6 - HotHead, ground-guided
    dw IggysBall                              ; A7 - Iggy's ball
    dw Bank3SprHandler                        ; A8 - Blargg
    dw Bank3SprHandler                        ; A9 - Reznor
    dw Bank3SprHandler                        ; AA - Fishbone
    dw Bank3SprHandler                        ; AB - Rex
    dw Bank3SprHandler                        ; AC - Wooden Spike, moving down and up
    dw Bank3SprHandler                        ; AD - Wooden Spike, moving up/down first
    dw Bank3SprHandler                        ; AE - Fishin' Boo
    dw Boo_BooBlock                           ; AF - Boo Block
    dw Bank3SprHandler                        ; B0 - Reflecting stream of Boo Buddies
    dw Bank3SprHandler                        ; B1 - Creating/Eating block
    dw Bank3SprHandler                        ; B2 - Falling Spike
    dw Bank3SprHandler                        ; B3 - Bowser statue fireball
    dw Grinder                                ; B4 - Grinder, non-line-guided
    dw Fireballs                              ; B5 - Sinking fireball used in boss battles
    dw Bank3SprHandler                        ; B6 - Reflecting fireball
    dw Bank3SprHandler                        ; B7 - Carrot Top lift, upper right
    dw Bank3SprHandler                        ; B8 - Carrot Top lift, upper left
    dw Bank3SprHandler                        ; B9 - Info Box
    dw Bank3SprHandler                        ; BA - Timed lift
    dw Bank3SprHandler                        ; BB - Grey moving castle block
    dw Bank3SprHandler                        ; BC - Bowser statue
    dw Bank3SprHandler                        ; BD - Sliding Koopa without a shell
    dw Bank3SprHandler                        ; BE - Swooper bat
    dw Bank3SprHandler                        ; BF - Mega Mole
    dw Bank3SprHandler                        ; C0 - Grey platform on lava
    dw Bank3SprHandler                        ; C1 - Flying grey turnblocks
    dw Bank3SprHandler                        ; C2 - Blurp fish
    dw Bank3SprHandler                        ; C3 - Porcu-Puffer fish
    dw Bank3SprHandler                        ; C4 - Grey platform that falls
    dw Bank3SprHandler                        ; C5 - Big Boo Boss
    dw Bank3SprHandler                        ; C6 - Dark room with spot light
    dw Bank3SprHandler                        ; C7 - Invisible mushroom
    dw Bank3SprHandler                        ; C8 - Light switch block for dark room

InvisSolid_Dinos:
    JSL InvisBlk_DinosMain
    RTS

GoalSphere:
    JSR SubSprGfx2Entry1
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    LDA.B TrueFrame
    AND.B #$1F
    ORA.B SpriteLock
    JSR CODE_01B152
    JSR MarioSprInteractRt
    BCC +
    STZ.W SpriteStatus,X
    LDA.B #$FF
    STA.W EndLevelTimer
    STA.W MusicBackup
    LDA.B #!BGM_BOSSCLEAR
    STA.W SPCIO2                              ; / Change music
  + RTS

InitReznor:
    JSL ReznorInit
    RTS

Bank3SprHandler:
    JSL Bnk3CallSprMain
    RTS

BanzaiBnCGrayPlat:
    JSL Banzai_Rotating
    RTS

BubbleWithSprite:
    JSL BubbleSpriteMain
    RTS

HammerBrother:
    JSL HammerBrotherMain
    RTS

FlyingPlatform:
    JSL FlyingPlatformMain
    RTS

InitHammerBrother:
    JSL Return02DA59                          ; Do nothing at all (Might as well be NOPs)
    RTS

VolcanoLotus:
    JSL VolcanoLotusMain
    RTS

SumoBrother:
    JSL SumoBrotherMain
    RTS

SumosLightning:
    JSL SumosLightningMain
    RTS

JumpingPiranha:
    JSL JumpingPiranhaMain
    RTS

GasBubble:
    JSL GasBubbleMain
    RTS

    JSL SumoBrotherMain                       ; Unused call to main Sumo Brother routine
    RTS

DirectionalCoins:
    JSL DirectionCoinsMain
    RTS

ExplodingBlock:
    JSL ExplodingBlkMain
    RTS

ScalePlatforms:
    JSL ScalePlatformMain
    RTS

InitFloatingSkull:
    JSL FloatingSkullInit
    RTS

FloatingSkulls:
    JSL FloatingSkullMain
    RTS

GhostHouseExit:
    JSL GhostExitMain
    RTS

WarpBlocks:
    JSL WarpBlocksMain
    RTS

Pokey:
    JSL PokeyMain
    RTS

RedSuperKoopa:
    JSL SuperKoopaMain
    RTS

YellowSuperKoopa:
    JSL SuperKoopaMain
    RTS

FeatherSuperKoopa:
    JSL SuperKoopaMain
    RTS

PipeLakitu:
    JSL PipeLakituMain
    RTS

DigginChuck:
    JSL ChucksMain
    RTS

SwimJumpFish:
    JSL SwimJumpFishMain
    RTS

DigginChucksRock:
    JSL ChucksRockMain
    RTS

GrowingPipe:
    JSL GrowingPipeMain
    RTS

YoshisHouseBirds:
    JSL BirdsMain
    RTS

YoshisHouseSmoke:
    JSL SmokeMain
    RTS

SideExit:
    JSL SideExitMain
    RTS

InitWiggler:
    JSL WigglerInit
    RTS

Wiggler:
    JSL WigglerMain
    RTS

CoinCloud:
    JSL CoinCloudMain
    RTS

TorpedoTed:
    JSL TorpedoTedMain
    RTS

Layer3Smash:
    PHB
    LDA.B #$02
    PHA
    PLB
    JSL Layer3SmashMain
    PLB
    RTS

PeaBouncer:
    PHB
    LDA.B #$02
    PHA
    PLB
    JSL PeaBouncerMain
    PLB
    RTS

RipVanFish:
    PHB
    LDA.B #$02
    PHA
    PLB
    JSL RipVanFishMain
    PLB
    RTS

WallFollowers:
    PHB
    LDA.B #$02
    PHA
    PLB
    JSL WallFollowersMain
    PLB
    RTS

Return018869:
    RTS

Chucks:
    JSL ChucksMain
    RTS

InitWingedCage:
    PHB                                       ; \ Do nothing at all
    LDA.B #$02                                ; | (Might as well be NOPs)
    PHA                                       ; |
    PLB                                       ; |
    JSL Return02CBFD                          ; |
    PLB                                       ; /
    RTS

WingedCage:
    PHB
    LDA.B #$02
    PHA
    PLB
    JSL WingedCageMain
    PLB
    RTS

Dolphin:
    PHB
    LDA.B #$02
    PHA
    PLB
    JSL DolphinMain
    PLB
    RTS

InitMovingLedge:
    DEC.B SpriteYPosLow,X
    RTS

MovingLedge:
    JSL MovingLedgeMain
    RTS

JumpOverShells:
    TXA                                       ; \ Process every 4 frames
    EOR.B TrueFrame                           ; |
    AND.B #$03                                ; |
    BNE Return0188AB                          ; /
    LDY.B #$09                                ; \ Loop over sprites:
JumpLoopStart:
    LDA.W SpriteStatus,Y                      ; |
    CMP.B #$0A                                ; | If sprite status = kicked, try to jump it
    BEQ HandleJumpOver                        ; |
JumpLoopNext:
    DEY                                       ; |
    BPL JumpLoopStart                         ; /
Return0188AB:
    RTS

HandleJumpOver:
    LDA.W SpriteXPosLow,Y
    SEC
    SBC.B #$1A
    STA.B _0
    LDA.W SpriteXPosHigh,Y
    SBC.B #$00
    STA.B _8
    LDA.B #$44
    STA.B _2
    LDA.W SpriteYPosLow,Y
    STA.B _1
    LDA.W SpriteYPosHigh,Y
    STA.B _9
    LDA.B #$10
    STA.B _3
    JSL GetSpriteClippingA
    JSL CheckForContact
    BCC JumpLoopNext                          ; If not close to shell, go back to main loop
    JSR IsOnGround                            ; \ If sprite not on ground, go back to main loop
    BEQ JumpLoopNext                          ; /
    LDA.W SpriteMisc157C,Y                    ; \ If sprite not facing shell, don't jump
    CMP.W SpriteMisc157C,X                    ; |
    BEQ +                                     ; /
    LDA.B #$C0                                ; \ Finally set jump speed
    STA.B SpriteYSpeed,X                      ; /
    STZ.W SpriteMisc163E,X
  + RTS


Spr0to13SpeedX:
    db $08,$F8,$0C,$F4

Spr0to13Prop:
    db $00,$02,$03,$0D,$40,$42,$43,$45
    db $50,$50,$50,$5C,$DD,$05,$00,$20
    db $20,$00,$00,$00

ShellessKoopas:
    LDA.B SpriteLock                          ; \ If sprites aren't locked,
    BEQ CODE_018952                           ; / branch to $8952
CODE_018908:
    LDA.W SpriteMisc163E,X                    ;COME BACK HERE ON NOT STATIONARY BRANCH
    CMP.B #$80
    BCC +
    LDA.B SpriteLock                          ; \ If sprites are locked,
    BNE +                                     ; / branch to $891F
CODE_018913:
    JSR SetAnimationFrame
    LDA.W SpriteMisc1602,X                    ; \
    CLC                                       ; |Increase sprite's image by x05
    ADC.B #$05                                ; |
    STA.W SpriteMisc1602,X                    ; /
  + JSR CODE_018931
    JSR SubUpdateSprPos
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    JSR IsOnGround                            ; \ If sprite is on edge (on ground),
    BEQ +                                     ; |Sprite Y Speed = 0
    STZ.B SpriteYSpeed,X                      ; /
  + JMP CODE_018B03

CODE_018931:
    LDA.B SpriteNumber,X                      ; \
    CMP.B #$02                                ; |If sprite isn't Blue shelless Koopa,
    BNE CODE_01893C                           ; / branch to $893C
    JSR MarioSprInteractRt
    BRA Return018951

CODE_01893C:
    ASL.W SpriteTweakerD,X
    SEC
    ROR.W SpriteTweakerD,X
    JSR MarioSprInteractRt
    BCC +
    JSR CODE_01B12A
  + ASL.W SpriteTweakerD,X
    LSR.W SpriteTweakerD,X
Return018951:
    RTS

CODE_018952:
    LDA.W SpriteMisc163E,X                    ;CODE RUNA T START?
    BEQ CODE_0189B4                           ;SKIP IF $163E IS ZERO FOR SPRITE.  IS KICKING SHELL TIMER / GENREAL TIME
    CMP.B #$80
    BNE CODE_01896B
    JSR FaceMario
    LDA.B SpriteNumber,X                      ; \
    CMP.B #$02                                ; |If sprite is Blue shelless Koopa,
    BEQ +                                     ; |Set Y speed to xE0
    LDA.B #$E0                                ; |
    STA.B SpriteYSpeed,X                      ; /
  + STZ.W SpriteMisc163E,X                    ;ZERO KICKING SHELL TIMER
CODE_01896B:
    CMP.B #$01
    BNE CODE_018908
    LDY.W SpriteMisc160E,X                    ;IT KICKS THIS? !@#
    LDA.W SpriteStatus,Y
    CMP.B #$09                                ;IF NOT STATIONARY, BRANCH
    BNE CODE_018908
    LDA.B SpriteXPosLow,X                     ;KOOPA BLUE KICK SHELL!
    SEC
    SBC.W SpriteXPosLow,Y
    CLC
    ADC.B #$12
    CMP.B #$24
    BCS CODE_018908
    JSR PlayKickSfx
    JSR CODE_01A755
    LDY.W SpriteMisc157C,X
    LDA.W DATA_01A6D7,Y
    LDY.W SpriteMisc160E,X
    STA.W SpriteXSpeed,Y
    LDA.B #$0A                                ; \ Sprite status = Kicked
    STA.W SpriteStatus,Y                      ; /
    LDA.W SpriteMisc1540,Y
    STA.W SpriteTableC2,Y
    LDA.B #$08
    STA.W SpriteMisc1564,Y
    LDA.W SpriteTweakerD,Y
    AND.B #$10
    BEQ CODE_0189B4
    LDA.B #$E0
    STA.W SpriteYSpeed,Y
CODE_0189B4:
    LDA.W SpriteMisc1528,X
    BEQ CODE_018A15
    JSR IsTouchingObjSide
    BEQ +
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
  + JSR IsOnGround
    BEQ CODE_0189E6
    LDA.B LevelIsSlippery
    CMP.B #$01
    LDA.B #$02
    BCC +
    LSR A
  + STA.B _0
    LDA.B SpriteXSpeed,X
    CMP.B #$02
    BCC CODE_0189FD
    BPL +
    CLC
    ADC.B _0
    CLC
    ADC.B _0
  + SEC
    SBC.B _0
    STA.B SpriteXSpeed,X
    JSR CODE_01804E
CODE_0189E6:
    STZ.W SpriteMisc1570,X
    JSR CODE_018B43
    LDA.B #$E6
    LDY.B SpriteNumber,X                      ; \ Branch if Blue shelless
    CPY.B #$02                                ; |
    BEQ +                                     ; /
    LDA.B #$86
  + LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    STA.W OAMTileNo+$100,Y
    RTS

CODE_0189FD:
    JSR IsOnGround                            ;KOOPA CODE
    BEQ CODE_018A0F
    LDA.B #$FF
    LDY.B SpriteNumber,X
    CPY.B #$02
    BNE +
    LDA.B #$A0
  + STA.W SpriteMisc163E,X
CODE_018A0F:
    STZ.W SpriteMisc1528,X
    JMP CODE_018913

CODE_018A15:
    LDA.W SpriteMisc1534,X
    BEQ CODE_018A88
    LDY.W SpriteMisc160E,X
    LDA.W SpriteStatus,Y
    CMP.B #$0A
    BEQ CODE_018A29
    STZ.W SpriteMisc1534,X
    BRA CODE_018A62

CODE_018A29:
    STA.W SpriteMisc1528,Y
    JSR IsTouchingObjSide
    BEQ +
    LDA.B #$00
    STA.W SpriteXSpeed,Y
    STA.B SpriteXSpeed,X
  + JSR IsOnGround
    BEQ CODE_018A62
    LDA.B LevelIsSlippery
    CMP.B #$01
    LDA.B #$02
    BCC +
    LSR A
  + STA.B _0
    LDA.W SpriteXSpeed,Y
    CMP.B #$02
    BCC CODE_018A69
    BPL +
    CLC
    ADC.B _0
    CLC
    ADC.B _0
  + SEC
    SBC.B _0
    STA.W SpriteXSpeed,Y
    STA.B SpriteXSpeed,X
    JSR CODE_01804E
CODE_018A62:
    STZ.W SpriteMisc1570,X
    JSR CODE_018B43
    RTS

CODE_018A69:
    LDA.B #$00
    STA.B SpriteXSpeed,X
    STA.W SpriteXSpeed,Y
    STZ.W SpriteMisc1534,X
    LDA.B #$09                                ; \ Sprite status = Carryable
    STA.W SpriteStatus,Y                      ; /
    PHX
    TYX
    JSR CODE_01AA0B
    LDA.W SpriteMisc1540,X
    BEQ +
    LDA.B #$FF
    STA.W SpriteMisc1540,X
  + PLX
CODE_018A88:
    LDA.B SpriteTableC2,X
    BEQ CODE_018A9B
    DEC.B SpriteTableC2,X
    CMP.B #$08
    LDA.B #$04
    BCS +
    LDA.B #$00
  + STA.W SpriteMisc1602,X
    BRA CODE_018B00

CODE_018A9B:
    LDA.W SpriteMisc1558,X
    CMP.B #$01
    BNE Spr0to13Main
    LDY.W SpriteMisc1594,X                    ;SHELL TO INTERACT WITH???
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BCC +
    LDA.W SpriteYSpeed,Y
    BMI +
    LDA.W SpriteNumber,Y                      ; \ Return if Coin sprite
    CMP.B #$21                                ; |
    BEQ +                                     ; /
    JSL GetSpriteClippingA
    PHX
    TYX
    JSL GetSpriteClippingB
    PLX
    JSL CheckForContact
    BCC +
    JSR OffScrEraseSprite
    LDY.W SpriteMisc1594,X
    LDA.B #$10
    STA.W SpriteMisc1558,Y
    LDA.B SpriteNumber,X
    STA.W SpriteMisc160E,Y                    ;SPRITE NUMBER TO DEAL WITH ?
  + RTS

  - PHB                                       ; \ Change Bob-omb into explosion
    LDA.B #$02                                ; |
    PHA                                       ; |
    PLB                                       ; |
    JSL ExplodeBombRt                         ; |
    PLB                                       ; |
    RTS                                       ; /

Bobomb:
    LDA.W SpriteMisc1534,X                    ; \ Branch if exploding
    BNE -                                     ; /
    LDA.W SpriteMisc1540,X                    ; \ Branch if not set to explode
    BNE Spr0to13Start                         ; /
    LDA.B #$09                                ; \ Sprite status = Stunned
    STA.W SpriteStatus,X                      ; /
    LDA.B #$40                                ; \ Time until explosion = #$40
    STA.W SpriteMisc1540,X                    ; /
    JMP SubSprGfx2Entry1                      ; Draw sprite

Spr0to13Start:
    LDA.B SpriteLock                          ; \ If sprites locked...
    BEQ Spr0to13Main                          ; |
CODE_018B00:
    JSR MarioSprInteractRt                    ; | ...interact with Mario
CODE_018B03:
    JSR SubSprSprInteract                     ; | ...interact with sprites
    JSR Spr0to13Gfx                           ; | ...draw sprite
    RTS                                       ; / Return

Spr0to13Main:
    JSR IsOnGround                            ; \ If sprite on ground...
    BEQ CODE_018B2E                           ; |
    LDY.B SpriteNumber,X                      ; |
    LDA.W Spr0to13Prop,Y                      ; | Set sprite X speed
    LSR A                                     ; |
    LDY.W SpriteMisc157C,X                    ; |
    BCC +                                     ; |
    INY                                       ; | Increase index if sprite set to go fast
    INY                                       ; |
  + LDA.W Spr0to13SpeedX,Y                    ; |
    EOR.W SpriteSlope,X                       ; | what does $15B8,x do?
    ASL A                                     ; |
    LDA.W Spr0to13SpeedX,Y                    ; |
    BCC +                                     ; |
    CLC                                       ; |
    ADC.W SpriteSlope,X                       ; |
  + STA.B SpriteXSpeed,X                      ; /
CODE_018B2E:
    LDY.W SpriteMisc157C,X                    ; \ If touching an object in the direction
    TYA                                       ; | that Mario is moving...
    INC A                                     ; |
    AND.W SpriteBlockedDirs,X                 ; |
    AND.B #$03                                ; |
    BEQ +                                     ; |
    STZ.B SpriteXSpeed,X                      ; / ...Sprite X Speed = 0
  + JSR IsTouchingCeiling                     ; \ If touching ceiling...
    BEQ CODE_018B43                           ; |
    STZ.B SpriteYSpeed,X                      ; / ...Sprite Y Speed = 0
CODE_018B43:
    JSR SubOffscreen0Bnk1
    JSR SubUpdateSprPos                       ; Apply speed to position
    JSR SetAnimationFrame                     ; Set the animation frame
    JSR IsOnGround                            ; \ Branch if not on ground
    BEQ SpriteInAir                           ; /
    JSR SetSomeYSpeed__
    STZ.W SpriteMisc151C,X
    LDY.B SpriteNumber,X                      ; \
    LDA.W Spr0to13Prop,Y                      ; | If follow Mario is set...
    PHA                                       ; |
    AND.B #$04                                ; |
    BEQ +                                     ; |
    LDA.W SpriteMisc1570,X                    ; | ...and time until turn == 0...
    AND.B #$7F                                ; |
    BNE +                                     ; |
    LDA.W SpriteMisc157C,X                    ; |
    PHA                                       ; |
    JSR FaceMario                             ; | ...face Mario
    PLA                                       ; | If was facing the other direction...
    CMP.W SpriteMisc157C,X                    ; |
    BEQ +                                     ; |
    LDA.B #$08                                ; | ...set turning timer
    STA.W SpriteMisc15AC,X                    ; /
  + PLA                                       ; \ If jump over shells is set call routine
    AND.B #$08                                ; |
    BEQ +                                     ; |
    JSR JumpOverShells                        ; |
  + BRA CODE_018BB0                           ; /

SpriteInAir:
    LDY.B SpriteNumber,X
    LDA.W Spr0to13Prop,Y                      ; \ If flutter wings is set...
    BPL CODE_018B90                           ; |
    JSR SetAnimationFrame                     ; | ...set frame...
    BRA +                                     ; | ...and don't zero out $1570,x

CODE_018B90:
    STZ.W SpriteMisc1570,X                    ; /
  + LDA.W Spr0to13Prop,Y                      ; \ If stay on ledges is set...
    AND.B #$02                                ; |
    BEQ CODE_018BB0                           ; |
    LDA.W SpriteMisc151C,X                    ; | todo: what are all these?
    ORA.W SpriteMisc1558,X                    ; |
    ORA.W SpriteMisc1528,X                    ; |
    ORA.W SpriteMisc1534,X                    ; |
    BNE CODE_018BB0                           ; |
    JSR FlipSpriteDir                         ; | ...change sprite direction
    LDA.B #$01                                ; |
    STA.W SpriteMisc151C,X                    ; /
CODE_018BB0:
    LDA.W SpriteMisc1528,X
    BEQ CODE_018BBA
    JSR CODE_018931
    BRA +

CODE_018BBA:
    JSR MarioSprInteractRt                    ; Interact with Mario
  + JSR SubSprSprInteract                     ; Interact with other sprites
    JSR FlipIfTouchingObj                     ; Change direction if touching an object
Spr0to13Gfx:
    LDA.W SpriteMisc157C,X                    ; \ Store sprite direction
    PHA                                       ; /
    LDY.W SpriteMisc15AC,X                    ; \ If turning timer is set...
    BEQ CODE_018BDE                           ; |
    LDA.B #$02                                ; | ...set turning image
    STA.W SpriteMisc1602,X                    ; |
    LDA.B #$00                                ; |
    CPY.B #$05                                ; | If turning timer >= 5...
    BCC +                                     ; |
    INC A                                     ; | ...flip sprite direction (temporarily)
  + EOR.W SpriteMisc157C,X                    ; |
    STA.W SpriteMisc157C,X                    ; /
CODE_018BDE:
    LDY.B SpriteNumber,X                      ; \ Branch if sprite is 2 tiles high
    LDA.W Spr0to13Prop,Y                      ; |
    AND.B #$40                                ; |
    BNE CODE_018BEC                           ; /
    JSR SubSprGfx2Entry1                      ; \ Draw 1 tile high sprite and return
    BRA +                                     ; /

CODE_018BEC:
    LDA.W SpriteMisc1602,X                    ; \ Nothing?
    LSR A                                     ; /
    LDA.B SpriteYPosLow,X                     ; \ Y position -= #$0F (temporarily)
    PHA                                       ; |
    SBC.B #$0F                                ; |
    STA.B SpriteYPosLow,X                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    PHA                                       ; |
    SBC.B #$00                                ; |
    STA.W SpriteYPosHigh,X                    ; /
    JSR SubSprGfx1                            ; Draw sprite
    PLA                                       ; \ Restore Y position
    STA.W SpriteYPosHigh,X                    ; |
    PLA                                       ; |
    STA.B SpriteYPosLow,X                     ; /
    LDA.B SpriteNumber,X                      ; \ Add wings if sprite number > #$08
    CMP.B #$08                                ; |
    BCC +                                     ; |
    JSR KoopaWingGfxRt                        ; /
  + PLA                                       ; \ Restore sprite direction
    STA.W SpriteMisc157C,X                    ; /
    RTS

SpinyEgg:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_018C44                           ; /
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE CODE_018C44
    JSR SetAnimationFrame
    JSR SubUpdateSprPos
    DEC.B SpriteYSpeed,X
    JSR IsOnGround
    BEQ +
    LDA.B #$13                                ; \ Sprite = Spiny
    STA.B SpriteNumber,X                      ; /
    JSL InitSpriteTables                      ; Reset sprite tables
    JSR FaceMario
    JSR CODE_0197D5
  + JSR FlipIfTouchingObj
    JSR SubSprSpr_MarioSpr
CODE_018C44:
    JSR SubOffscreen0Bnk1
    LDA.B #$02
    JSR SubSprGfx0Entry0
    RTS

GreenParaKoopa:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_018CB7                           ; /
    LDY.W SpriteMisc157C,X
    LDA.W Spr0to13SpeedX,Y
    EOR.W SpriteSlope,X
    ASL A
    LDA.W Spr0to13SpeedX,Y
    BCC +
    CLC
    ADC.W SpriteSlope,X
  + STA.B SpriteXSpeed,X
    TYA
    INC A
    AND.W SpriteBlockedDirs,X                 ; \ If touching object,
    AND.B #$03                                ; |
    BEQ +                                     ; |
    STZ.B SpriteXSpeed,X                      ; / Sprite X Speed = 0
  + LDA.B SpriteNumber,X                      ; \ If flying left Green Koopa...
    CMP.B #$08                                ; |
    BNE CODE_018C8C                           ; |
    JSR SubSprXPosNoGrvty                     ; | Update X position
    LDY.B #$FC                                ; |
    LDA.W SpriteMisc1570,X                    ; | Y speed = #$FC or #$04,
    AND.B #$20                                ; | depending on 1570,x
    BEQ +                                     ; |
    LDY.B #$04                                ; |
  + STY.B SpriteYSpeed,X                      ; |
    JSR SubSprYPosNoGrvty                     ; / Update Y position
    BRA +

CODE_018C8C:
    JSR SubUpdateSprPos
    DEC.B SpriteYSpeed,X
  + JSR SubSprSpr_MarioSpr
    JSR IsTouchingCeiling
    BEQ +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + JSR IsOnGround
    BEQ CODE_018CAE
    JSR SetSomeYSpeed__
    LDA.B #$D0
    LDY.W SpriteMisc160E,X
    BNE +
    LDA.B #$B0
  + STA.B SpriteYSpeed,X
CODE_018CAE:
    JSR FlipIfTouchingObj
    JSR SetAnimationFrame
    JSR SubOffscreen0Bnk1
CODE_018CB7:
    JMP Spr0to13Gfx


DATA_018CBA:
    db $FF,$01

DATA_018CBC:
    db $F0,$10

RedHorzParaKoopa:
    JSR SubOffscreen1Bnk1
    BRA +

RedVertParaKoopa:
    JSR SubOffscreen0Bnk1
  + LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_018D2A                           ; /
    LDA.W SpriteMisc157C,X
    PHA
    JSR UpdateDirection
    PLA
    CMP.W SpriteMisc157C,X
    BEQ +
    LDA.B #$08                                ; \ Set turning timer
    STA.W SpriteMisc15AC,X                    ; /
  + JSR SetAnimationFrame
    LDA.B SpriteNumber,X
    CMP.B #$0A
    BNE CODE_018CEA
    JSR SubSprYPosNoGrvty
    BRA CODE_018CFD

CODE_018CEA:
    LDY.B #$FC
    LDA.W SpriteMisc1570,X
    AND.B #$20
    BEQ +
    LDY.B #$04
  + STY.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty
    JSR SubSprXPosNoGrvty
CODE_018CFD:
    LDA.W SpriteMisc1540,X
    BNE +
    INC.B SpriteTableC2,X
    LDA.B SpriteTableC2,X
    AND.B #$03
    BNE +
    LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X
    CLC
    ADC.W DATA_018CBA,Y
    STA.B SpriteYSpeed,X
    STA.B SpriteXSpeed,X
    CMP.W DATA_018CBC,Y
    BNE +
    INC.W SpriteMisc151C,X
    LDA.B #$30
    STA.W SpriteMisc1540,X
  + JSR SubSprSpr_MarioSpr
CODE_018D2A:
    JSR CODE_018CB7
    RTS

WingedGoomba:
    JSR SubOffscreen0Bnk1
    LDA.B SpriteLock
    BEQ +
    JSR CODE_018DAC
    RTS

  + JSR CODE_018DBB
    JSR SubUpdateSprPos
    DEC.B SpriteYSpeed,X
    LDA.B SpriteTableC2,X
    LSR A
    LSR A
    LSR A
    AND.B #$01
    STA.W SpriteMisc1602,X
    JSR CODE_018DAC
    INC.B SpriteTableC2,X
    LDA.W SpriteMisc151C,X
    BNE +
    LDA.B SpriteYSpeed,X
    BPL +
    INC.W SpriteMisc1570,X
    INC.W SpriteMisc1570,X
  + INC.W SpriteMisc1570,X
    JSR IsTouchingCeiling
    BEQ +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + JSR IsOnGround
    BEQ CODE_018DA5
    LDA.B SpriteTableC2,X
    AND.B #$3F
    BNE +
    JSR FaceMario
  + JSR SetSomeYSpeed__
    LDA.W SpriteMisc151C,X
    BNE +
    STZ.W SpriteMisc1570,X
  + LDA.W SpriteMisc1540,X
    BNE CODE_018DA5
    INC.W SpriteMisc151C,X
    LDY.B #$F0
    LDA.W SpriteMisc151C,X
    CMP.B #$04
    BNE +
    STZ.W SpriteMisc151C,X
    JSL GetRand
    AND.B #$3F
    ORA.B #$50
    STA.W SpriteMisc1540,X
    LDY.B #$D0
  + STY.B SpriteYSpeed,X
CODE_018DA5:
    JSR FlipIfTouchingObj
    JSR SubSprSpr_MarioSpr
    RTS

CODE_018DAC:
    JSR GoombaWingGfxRt
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    JMP SubSprGfx2Entry1

CODE_018DBB:
    LDA.B #$F8
    LDY.W SpriteMisc157C,X
    BNE +
    LDA.B #$08
  + STA.B SpriteXSpeed,X
    RTS


DATA_018DC7:
    db $F7,$0B,$F6,$0D,$FD,$0C,$FC,$0D
    db $0B,$F5,$0A,$F3,$0B,$FC,$0C,$FB
DATA_018DD7:
    db $F7,$F7,$F8,$F8,$01,$01,$02,$02
GoombaWingGfxProp:
    db $46,$06

GoombaWingTiles:
    db $C6,$C6,$5D,$5D

GoombaWingTileSize:
    db $02,$02,$00,$00

GoombaWingGfxRt:
    JSR GetDrawInfoBnk1
    LDA.W SpriteMisc1570,X
    LSR A
    LSR A
    AND.B #$02
    CLC
    ADC.W SpriteMisc1602,X
    STA.B _5
    ASL A
    STA.B _2
    LDA.W SpriteMisc157C,X
    STA.B _4
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    LDX.B #$01
CODE_018E07:
    STX.B _3
    TXA
    CLC
    ADC.B _2
    PHA
    LDX.B _4
    BNE +
    CLC
    ADC.B #$08
  + TAX
    LDA.B _0
    CLC
    ADC.W DATA_018DC7,X
    STA.W OAMTileXPos+$100,Y
    PLX
    LDA.B _1
    CLC
    ADC.W DATA_018DD7,X
    STA.W OAMTileYPos+$100,Y
    LDX.B _5
    LDA.W GoombaWingTiles,X
    STA.W OAMTileNo+$100,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W GoombaWingTileSize,X
    STA.W OAMTileSize+$40,Y
    PLY
    LDX.B _3
    LDA.B _4
    LSR A
    LDA.W GoombaWingGfxProp,X
    BCS +
    EOR.B #$40
  + ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    TYA
    CLC
    ADC.B #$08
    TAY
    DEX
    BPL CODE_018E07
    PLX
    LDY.B #$FF
    LDA.B #$02
    JSR FinishOAMWriteRt
    RTS

SetAnimationFrame:
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X                    ; \ Change animation image every 8 cycles
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    AND.B #$01                                ; |
    STA.W SpriteMisc1602,X                    ; /
    RTS


PiranhaSpeed:
    db $00,$F0,$00,$10

PiranTimeInState:
    db $20,$30,$20,$30

ClassicPiranhas:
    LDA.W SpriteMisc1594,X                    ; \ Don't draw the sprite if in pipe and Mario naerby
    BNE CODE_018E9A                           ; /
    LDA.B SpriteProperties                    ; \ Set sprite to go behind objects
    PHA                                       ; | for the graphics routine
    LDA.W SpriteOnYoshiTongue,X               ; |
    BNE +                                     ; |
    LDA.B #!OBJ_Priority1                     ; |
    STA.B SpriteProperties                    ; /
  + JSR SubSprGfx1                            ; Draw the sprite
    LDY.W SpriteOAMIndex,X                    ; \ Modify the palette and page of the stem
    LDA.W OAMTileAttr+$108,Y                  ; |
    AND.B #$F1                                ; |
    ORA.B #$0B                                ; |
    STA.W OAMTileAttr+$108,Y                  ; /
    PLA                                       ; \ Restore value of $64
    STA.B SpriteProperties                    ; /
CODE_018E9A:
    JSR SubOffscreen0Bnk1
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return018EC7                          ; /
    JSR SetAnimationFrame
    LDA.W SpriteMisc1594,X                    ; \ Don't don't process interactions if in pipe and Mario nearby
    BNE +                                     ; |
    JSR SubSprSpr_MarioSpr                    ; /
  + LDA.B SpriteTableC2,X                     ; \ Y = Piranha state
    AND.B #$03                                ; |
    TAY                                       ; /
    LDA.W SpriteMisc1540,X                    ; \ Change state if it's time
    BEQ ChangePiranhaState                    ; /
    LDA.W PiranhaSpeed,Y                      ; Load Y speed
    LDY.B SpriteNumber,X                      ; \ Invert speed if upside-down piranha
    CPY.B #$2A                                ; |
    BNE +                                     ; |
    EOR.B #$FF                                ; |
    INC A                                     ; /
  + STA.B SpriteYSpeed,X                      ; Store Y Speed
    JSR SubSprYPosNoGrvty                     ; Update position based on speed
Return018EC7:
    RTS

ChangePiranhaState:
    LDA.B SpriteTableC2,X                     ; \ $00 = Sprite state (00 - 03)
    AND.B #$03                                ; |
    STA.B _0                                  ; /
    BNE CODE_018EE1                           ; \ If the piranha is in the pipe (State 0)...
    JSR SubHorizPos                           ; | ...check if Mario is nearby...
    LDA.B _F                                  ; |
    CLC                                       ; |
    ADC.B #$1B                                ; |
    CMP.B #$37                                ; |
    LDA.B #$01                                ; |
    STA.W SpriteMisc1594,X                    ; | ...and set $1594,x if so
    BCC +                                     ; |
CODE_018EE1:
    STZ.W SpriteMisc1594,X                    ; /
    LDY.B _0                                  ; \ Set time in state
    LDA.W PiranTimeInState,Y                  ; |
    STA.W SpriteMisc1540,X                    ; /
    INC.B SpriteTableC2,X                     ; Go to next state
  + RTS

CODE_018EEF:
    LDY.B #$07                                ; \ Find a free extended sprite slot
CODE_018EF1:
    LDA.W ExtSpriteNumber,Y
    BEQ CODE_018F07
    DEY
    BPL CODE_018EF1
    DEC.W ExtSpriteSlotIdx
    BPL +
    LDA.B #$07
    STA.W ExtSpriteSlotIdx
  + LDY.W ExtSpriteSlotIdx
  - RTS

CODE_018F07:
    LDA.W SpriteOffscreenX,X
    BNE -
    RTS

HoppingFlame:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_018F49                           ; /
    INC.W SpriteMisc1602,X
    JSR SetAnimationFrame
    JSR SubUpdateSprPos
    DEC.B SpriteYSpeed,X
    JSR CODE_018DBB
    ASL.B SpriteXSpeed,X
    JSR IsOnGround
    BEQ CODE_018F43
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    JSR SetSomeYSpeed__
    LDA.W SpriteMisc1540,X
    BEQ CODE_018F38
    DEC A
    BNE CODE_018F43
    JSR CODE_018F50
    BRA CODE_018F43

CODE_018F38:
    JSL GetRand
    AND.B #$1F
    ORA.B #$20
    STA.W SpriteMisc1540,X
CODE_018F43:
    JSR FlipIfTouchingObj
    JSR MarioSprInteractRt
CODE_018F49:
    JSR SubOffscreen0Bnk1
    JSR SubSprGfx2Entry1
    RTS

CODE_018F50:
    JSL GetRand
    AND.B #$0F
    ORA.B #$D0
    STA.B SpriteYSpeed,X
    LDA.W RandomNumber
    AND.B #$03
    BNE +
    JSR FaceMario
  + JSR IsSprOffScreen
    BNE +
    JSR CODE_018EEF
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W ExtSpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$08
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W ExtSpriteYPosHigh,Y
    LDA.B #$03                                ; \ Extended sprite = Hopping flame's flame
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B #$FF
    STA.W ExtSpriteMisc176F,Y
  + RTS

Lakitu:
    LDY.B #$00
    LDA.W SpriteMisc1558,X
    BEQ +
    LDY.B #$02
  + TYA
    STA.W SpriteMisc1602,X
    JSR SubSprGfx1
    LDA.W SpriteMisc1558,X
    BEQ +
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileYPos+$104,Y
    SEC
    SBC.B #$03
    STA.W OAMTileYPos+$104,Y
  + LDA.W SpriteMisc151C,X
    BEQ SubSprSpr_MarioSpr
    JSL CODE_02E672
SubSprSpr_MarioSpr:
    JSR SubSprSprInteract
    JMP MarioSprInteractRt


BulletGfxProp:
    db $42,$02,$03,$83,$03,$43,$03,$43
DATA_018FCF:
    db $00,$00,$01,$01,$02,$03,$03,$02
BulletSpeedX:
    db $20,$E0,$00,$00,$18,$18,$E8,$E8
BulletSpeedY:
    db $00,$00,$E0,$20,$E8,$18,$18,$E8

BulletBill:
    LDA.B #$01
    STA.W SpriteMisc157C,X
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    LDY.B SpriteTableC2,X
    LDA.W BulletGfxProp,Y                     ; \ Store gfx properties into palette byte
    STA.W SpriteOBJAttribute,X                ; /
    LDA.W DATA_018FCF,Y
    STA.W SpriteMisc1602,X
    LDA.W BulletSpeedX,Y                      ; \ Set X speed
    STA.B SpriteXSpeed,X                      ; /
    LDA.W BulletSpeedY,Y                      ; \ Set Y speed
    STA.B SpriteYSpeed,X                      ; /
    JSR SubSprXPosNoGrvty                     ; \ Update position
    JSR SubSprYPosNoGrvty                     ; /
    JSR CODE_019140
    JSR SubSprSpr_MarioSpr                    ; Interact with Mario and sprites
  + JSR SubOffscreen0Bnk1
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$F0
    BCC +
    STZ.W SpriteStatus,X
  + LDA.W SpriteMisc1540,X
    BEQ +
    JMP CODE_019546

  + JMP SubSprGfx2Entry1


DATA_01902E:
    db $40,$10

DATA_019030:
    db $03,$01

SubUpdateSprPos:
    JSR SubSprYPosNoGrvty
    LDY.B #$00
    LDA.W SpriteInLiquid,X
    BEQ +
    INY
    LDA.B SpriteYSpeed,X
    BPL +
    CMP.B #$E8
    BCS +
    LDA.B #$E8
    STA.B SpriteYSpeed,X
  + LDA.B SpriteYSpeed,X
    CLC
    ADC.W DATA_019030,Y
    STA.B SpriteYSpeed,X
    BMI +
    CMP.W DATA_01902E,Y
    BCC +
    LDA.W DATA_01902E,Y
    STA.B SpriteYSpeed,X
  + LDA.B SpriteXSpeed,X
    PHA
    LDY.W SpriteInLiquid,X
    BEQ +
    ASL A
    ROR.B SpriteXSpeed,X
    LDA.B SpriteXSpeed,X
    PHA
    STA.B _0
    ASL A
    ROR.B _0
    PLA
    CLC
    ADC.B _0
    STA.B SpriteXSpeed,X
  + JSR SubSprXPosNoGrvty
    PLA
    STA.B SpriteXSpeed,X
    LDA.W SpriteDisableObjInt,X
    BNE +
    JSR CODE_019140
    RTS

  + STZ.W SpriteBlockedDirs,X
    RTS

FlipIfTouchingObj:
    LDA.W SpriteMisc157C,X                    ; \ If touching an object in the direction
    INC A                                     ; | that the sprite is moving...
    AND.W SpriteBlockedDirs,X                 ; |
    AND.B #$03                                ; |
    BEQ +                                     ; |
    JSR FlipSpriteDir                         ; | ...flip direction
  + RTS                                       ; /

FlipSpriteDir:
    LDA.W SpriteMisc15AC,X                    ; \ Return if turning timer is set
    BNE +                                     ; /
    LDA.B #$08                                ; \ Set turning timer
    STA.W SpriteMisc15AC,X                    ; /
CODE_0190A2:
    LDA.B SpriteXSpeed,X                      ; \ Invert speed
    EOR.B #$FF                                ; |
    INC A                                     ; |
    STA.B SpriteXSpeed,X                      ; /
    LDA.W SpriteMisc157C,X                    ; \ Flip sprite direction
    EOR.B #$01                                ; |
    STA.W SpriteMisc157C,X                    ; /
  + RTS

GenericSprGfxRt2:
    PHB
    PHK
    PLB
    JSR SubSprGfx2Entry1
    PLB
    RTL


SpriteObjClippingX:
    db $0E,$02,$08,$08,$0E,$02,$07,$07
    db $07,$07,$07,$07,$0E,$02,$08,$08
    db $10,$00,$08,$08,$0D,$02,$08,$08
    db $07,$00,$04,$04,$1F,$01,$10,$10
    db $0F,$00,$08,$08,$10,$00,$08,$08
    db $0D,$02,$08,$08,$0E,$02,$08,$08
    db $0D,$02,$08,$08,$10,$00,$08,$08
    db $1F,$00,$10,$10,$08

SpriteObjClippingY:
    db $08,$08,$10,$02,$12,$12,$20,$02
    db $07,$07,$07,$07,$10,$10,$20,$0B
    db $12,$12,$20,$02,$18,$18,$20,$10
    db $04,$04,$08,$00,$10,$10,$1F,$01
    db $08,$08,$0F,$00,$08,$08,$10,$00
    db $48,$48,$50,$42,$04,$04,$08,$00
    db $00,$00,$00,$00,$08,$08,$10,$00
    db $08,$08,$10,$00,$04

DATA_019134:
    db $01,$02,$04,$08

CODE_019138:
    PHB
    PHK
    PLB
    JSR CODE_019140
    PLB
    RTL

CODE_019140:
    STZ.W SpriteBlockOffset
    STZ.W SpriteBlockedDirs,X                 ; Set sprite's position status to 0 (in air)
    STZ.W SpriteSlope,X
    STZ.W TileGenerateTrackA
    LDA.W SpriteInLiquid,X
    STA.W SpriteInterIndex
    STZ.W SpriteInLiquid,X
    JSR CODE_019211
    LDA.B ScreenMode                          ; Vertical level flag
    BPL CODE_0191BE
    INC.W TileGenerateTrackA
    LDA.B SpriteXPosLow,X                     ; \ Sprite's X position += $26
    CLC                                       ; | for call to below routine
    ADC.B Layer23XRelPos                      ; |
    STA.B SpriteXPosLow,X                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    ADC.B Layer23XRelPos+1                    ; |
    STA.W SpriteXPosHigh,X                    ; /
    LDA.B SpriteYPosLow,X                     ; \ Sprite's Y position += $28
    CLC                                       ; | for call to below routine
    ADC.B Layer23YRelPos                      ; |
    STA.B SpriteYPosLow,X                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    ADC.B Layer23YRelPos+1                    ; |
    STA.W SpriteYPosHigh,X                    ; /
    JSR CODE_019211
    LDA.B SpriteXPosLow,X                     ; \ Restore sprite's original position
    SEC                                       ; |
    SBC.B Layer23XRelPos                      ; |
    STA.B SpriteXPosLow,X                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    SBC.B Layer23XRelPos+1                    ; |
    STA.W SpriteXPosHigh,X                    ; |
    LDA.B SpriteYPosLow,X                     ; |
    SEC                                       ; |
    SBC.B Layer23YRelPos                      ; |
    STA.B SpriteYPosLow,X                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    SBC.B Layer23YRelPos+1                    ; |
    STA.W SpriteYPosHigh,X                    ; /
    LDA.W SpriteBlockedDirs,X
    BPL CODE_0191BE
    AND.B #$03
    BNE CODE_0191BE
    LDY.B #$00
    LDA.W Layer2DXPos                         ; \ A = -$17BF
    EOR.B #$FF                                ; |
    INC A                                     ; |
    BPL +
    DEY
  + CLC
    ADC.B SpriteXPosLow,X
    STA.B SpriteXPosLow,X
    TYA
    ADC.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,X
CODE_0191BE:
    LDA.W SpriteTweakerF,X                    ; \ Branch if "Don't get stuck in walls" is not set
    BPL +                                     ; /
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
    TAY
    LDA.W SpriteOnYoshiTongue,X
    BNE +
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W Return019283,Y
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_019285,Y
    STA.W SpriteXPosHigh,X
    LDA.B SpriteXSpeed,X
    BNE +
    LDA.W SpriteBlockedDirs,X
    AND.B #$FC
    STA.W SpriteBlockedDirs,X
  + LDA.W SpriteInLiquid,X
    EOR.W SpriteInterIndex
    BEQ Return019210
if ver_is_lores(!_VER)                        ;\================= J, U, SS, & E0 ==============
    ASL A                                     ;!
    LDA.W SpriteTweakerC,X                    ;! \ TODO: Unknown Bit A...
    AND.B #$40                                ;! | ... may be related to cape
    ORA.W SpriteMisc1FE2,X                    ;!
    BNE Return019210                          ;!
    BCS +                                     ;!
else                                          ;<======================= E1 ====================
    TAY                                       ;!
    LDA.W SpriteTweakerC,X                    ;!
    AND.B #$40                                ;!
    ORA.W SpriteMisc1FE2,X                    ;!
    BNE Return019210                          ;!
    LDA.W SpriteYPosLow,X                     ;!
    SEC                                       ;!
    SBC.W Layer1YPos                          ;!
    CMP.B #$D2                                ;!
    BCS Return019210                          ;!
    TYA                                       ;!
    BMI +                                     ;!
endif                                         ;/===============================================
    BIT.W IRQNMICommand
    BMI +
    JSL CODE_0284C0
    RTS

  + JSL CODE_028528
Return019210:
    RTS

CODE_019211:
    LDA.W SpriteBuoyancy
    BEQ CODE_01925B
    LDA.B LevelIsWater
    BNE CODE_019258
    LDY.B #$3C
    JSR CODE_01944D
    BEQ CODE_019233
    LDA.W Map16TileNumber
    CMP.B #$6E
    BCC CODE_01925B
    JSL CODE_00F04D
    LDA.W Map16TileNumber
    BCC CODE_01925B
    BCS CODE_01923A
CODE_019233:
    LDA.W Map16TileNumber
    CMP.B #$06
    BCS CODE_01925B
CODE_01923A:
    TAY
    LDA.W SpriteInLiquid,X
    ORA.B #$01
    CPY.B #$04
    BNE CODE_019258
    PHA
    LDA.B SpriteNumber,X                      ; \ Branch if Yoshi
    CMP.B #$35                                ; |
    BEQ CODE_019252                           ; /
    LDA.W SpriteTweakerD,X                    ; \ Branch if "Process interaction every frame"
    AND.B #$02                                ; | is set
    BNE +                                     ; /
CODE_019252:
    JSR CODE_019330
  + PLA
    ORA.B #$80
CODE_019258:
    STA.W SpriteInLiquid,X
CODE_01925B:
    LDA.W SpriteTweakerE,X
    BMI Return019210
    LDA.W TileGenerateTrackA
    BEQ CODE_01926F
    BIT.W SpriteBuoyancy
    BVS Return0192C0
    LDA.W SpriteTweakerC,X                    ; \ TODO: Return if Unknown Bit B is set
    BMI Return0192C0                          ; /
CODE_01926F:
    JSR CODE_0192C9
    LDA.W SpriteTweakerF,X                    ; \ Branch if "Don't get stuck in walls" is not set
    BPL +                                     ; /
    LDA.B SpriteXSpeed,X                      ; \ Branch if sprite has X speed...
    ORA.W SpriteMisc15AC,X                    ; | ...or sprite is turning
    BNE +                                     ; /
    LDA.B TrueFrame
    JSR CODE_01928E
Return019283:
    RTS


    db $FC

DATA_019285:
    db $04,$FF,$00

  + LDA.B SpriteXSpeed,X
    BEQ Return0192C0
    ASL A
    ROL A
CODE_01928E:
    AND.B #$01
    TAY
    JSR CODE_019441
    STA.W SprMap16TouchHorizHigh
    BEQ +
    LDA.W Map16TileNumber
    CMP.B #$11
    BCC +
    CMP.B #$6E
    BCS +
    JSR CODE_019425
    LDA.W Map16TileNumber
    STA.W Map16TileDestroy
    LDA.W TileGenerateTrackA
    BEQ +
    LDA.W SpriteBlockedDirs,X
    ORA.B #$40
    STA.W SpriteBlockedDirs,X
  + LDA.W Map16TileNumber
    STA.W SprMap16TouchHorizLow
Return0192C0:
    RTS


    db $FE,$02,$FF,$00

DATA_0192C5:
    db $01,$FF

DATA_0192C7:
    db $00,$FF

CODE_0192C9:
    LDY.B #$02
    LDA.B SpriteYSpeed,X
    BPL +
    INY
  + JSR CODE_019441
    STA.W SprMap16TouchVertHigh
    PHP
    LDA.W Map16TileNumber
    STA.W SprMap16TouchVertLow
    PLP
    BEQ Return01930F
    LDA.W Map16TileNumber
    CPY.B #$02
    BEQ CODE_019310
    CMP.B #$11
    BCC Return01930F
    CMP.B #$6E
    BCC CODE_0192F9
    CMP.W SolidTileStart
    BCC Return01930F
    CMP.W SolidTileEnd
    BCS Return01930F
CODE_0192F9:
    JSR CODE_019425
    LDA.W Map16TileNumber
    STA.W Map16TileHittable
    LDA.W TileGenerateTrackA
    BEQ Return01930F
    LDA.W SpriteBlockedDirs,X
    ORA.B #$20
    STA.W SpriteBlockedDirs,X
Return01930F:
    RTS

CODE_019310:
    CMP.B #$59
    BCC CODE_01933B
    CMP.B #$5C
    BCS CODE_01933B
    LDY.W ObjectTileset
    CPY.B #$0E
    BEQ CODE_019323
    CPY.B #$03
    BNE CODE_01933B
CODE_019323:
    LDA.B SpriteNumber,X                      ; \ Branch if sprite == Yoshi
    CMP.B #$35                                ; |
    BEQ CODE_019330                           ; /
    LDA.W SpriteTweakerD,X                    ; \ Branch if "Process interaction every frame"
    AND.B #$02                                ; | is set
    BNE CODE_01933B                           ; /
CODE_019330:
    LDA.B #$05                                ; \ Sprite status = #$05 ???
    STA.W SpriteStatus,X                      ; /
    LDA.B #$40
    STA.W SpriteMisc1558,X
    RTS

CODE_01933B:
    CMP.B #$11
    BCC CODE_0193B0
    CMP.B #$6E
    BCC CODE_0193B8
    CMP.B #$D8
    BCS CODE_019386
    JSL CODE_00FA19
    LDA.B [_5],Y
    CMP.B #$10
    BEQ Return0193AF
    BCS CODE_019386
    LDA.B _0
    CMP.B #$0C
    BCS CODE_01935D
    CMP.B [_5],Y
    BCC Return0193AF
CODE_01935D:
    LDA.B [_5],Y
    STA.W SpriteBlockOffset
    PHX
    LDX.B _8
    LDA.L DATA_00E53D,X
    PLX
    STA.W SpriteSlope,X
    CMP.B #$04
    BEQ CODE_019375
    CMP.B #$FC
    BNE CODE_019384
CODE_019375:
    EOR.B SpriteXSpeed,X
    BPL +
    LDA.B SpriteXSpeed,X
    BEQ +
    JSR FlipSpriteDir
  + JSL CODE_03C1CA
CODE_019384:
    BRA CODE_0193B8

CODE_019386:
    LDA.B _C
    AND.B #$0F
    CMP.B #$05
    BCS Return0193AF
    LDA.W SpriteStatus,X                      ; \ Return if sprite status == Killed
    CMP.B #$02                                ; |
    BEQ Return0193AF                          ; /
    CMP.B #$05                                ; \ Return if sprite status == #$05
    BEQ Return0193AF                          ; /
    CMP.B #$0B                                ; \ Return if sprite status == Carried
    BEQ Return0193AF                          ; /
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$01
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    JSR CODE_0192C9
Return0193AF:
    RTS

CODE_0193B0:
    LDA.B _C
    AND.B #$0F
    CMP.B #$05
    BCS Return019424
CODE_0193B8:
    LDA.W SpriteTweakerE,X
    AND.B #$04
    BNE CODE_019414
    LDA.W SpriteStatus,X                      ; \ Return if sprite status == Killed
    CMP.B #$02                                ; |
    BEQ Return019424                          ; /
    CMP.B #$05                                ; \ Return if sprite status == #$05
    BEQ Return019424                          ; /
    CMP.B #$0B                                ; \ Return if sprite status == Carried
    BEQ Return019424                          ; /
    LDY.W Map16TileNumber
    CPY.B #$0C
    BEQ CODE_0193D9
    CPY.B #$0D
    BNE CODE_019405
CODE_0193D9:
    LDA.B TrueFrame
    AND.B #$03
    BNE CODE_019405
    JSR IsTouchingObjSide
    BNE CODE_019405
    LDA.W ObjectTileset
    CMP.B #$02
    BEQ ADDR_0193EF
    CMP.B #$08
    BNE CODE_019405
ADDR_0193EF:
    TYA
    SEC
    SBC.B #$0C
    TAY
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_0192C5,Y
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_0192C7,Y
    STA.W SpriteXPosHigh,X
CODE_019405:
    LDA.W SpriteOnYoshiTongue,X
    BNE CODE_019414
    LDA.B SpriteYPosLow,X
    AND.B #$F0
    CLC
    ADC.W SpriteBlockOffset
    STA.B SpriteYPosLow,X
CODE_019414:
    JSR CODE_019435
    LDA.W TileGenerateTrackA
    BEQ Return019424
    LDA.W SpriteBlockedDirs,X
    ORA.B #$80
    STA.W SpriteBlockedDirs,X
Return019424:
    RTS

CODE_019425:
    LDA.B _A
    STA.B TouchBlockXPos
    LDA.B _B
    STA.B TouchBlockXPos+1
    LDA.B _C
    STA.B TouchBlockYPos
    LDA.B _D
    STA.B TouchBlockYPos+1
CODE_019435:
    LDY.B _F
    LDA.W SpriteBlockedDirs,X
    ORA.W DATA_019134,Y
    STA.W SpriteBlockedDirs,X
    RTS

CODE_019441:
    STY.B _F                                  ; Can be 00-03
    LDA.W SpriteTweakerA,X                    ; \ Y = $1656,x (Upper 4 bits) + $0F (Lower 2 bits)
    AND.B #$0F                                ; |
    ASL A                                     ; |
    ASL A                                     ; |
    ADC.B _F                                  ; |
    TAY                                       ; /
CODE_01944D:
    LDA.W TileGenerateTrackA
    INC A
    AND.B ScreenMode
    BEQ CODE_0194BF
    LDA.B SpriteYPosLow,X
    CLC
    ADC.W SpriteObjClippingY,Y
    STA.B _C
    AND.B #$F0
    STA.B _0
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    CMP.B LevelScrLength
    BCS CODE_0194B4
    STA.B _D
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W SpriteObjClippingX,Y
    STA.B _A
    STA.B _1
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    CMP.B #$02
    BCS CODE_0194B4
    STA.B _B
    LDA.B _1
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _D
    LDA.L DATA_00BA80,X
    LDY.W TileGenerateTrackA
    BEQ +
    LDA.L DATA_00BA8E,X
  + CLC
    ADC.B _0
    STA.B _5
    LDA.L DATA_00BABC,X
    LDY.W TileGenerateTrackA
    BEQ +
    LDA.L DATA_00BACA,X
  + ADC.B _B
    STA.B _6
    JSR CODE_019523
    RTS

CODE_0194B4:
    LDY.B _F
    LDA.B #$00
    STA.W Map16TileNumber
    STA.W SpriteBlockOffset
    RTS

CODE_0194BF:
    LDA.B SpriteYPosLow,X
    CLC
    ADC.W SpriteObjClippingY,Y
    STA.B _C
    AND.B #$F0
    STA.B _0
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _D
    REP #$20                                  ; A->16
    LDA.B _C
    CMP.W #$01B0
    SEP #$20                                  ; A->8
    BCS CODE_0194B4
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W SpriteObjClippingX,Y
    STA.B _A
    STA.B _1
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.B _B
    BMI CODE_0194B4
    CMP.B LevelScrLength
    BCS CODE_0194B4
    LDA.B _1
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _0
    STA.B _0
    LDX.B _B
    LDA.L DATA_00BA60,X
    LDY.W TileGenerateTrackA
    BEQ +
    LDA.L DATA_00BA70,X
  + CLC
    ADC.B _0
    STA.B _5
    LDA.L DATA_00BA9C,X
    LDY.W TileGenerateTrackA
    BEQ +
    LDA.L DATA_00BAAC,X
  + ADC.B _D
    STA.B _6
CODE_019523:
    LDA.B #$7E
    STA.B _7
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B [_5]
    STA.W Map16TileNumber
    INC.B _7
    LDA.B [_5]
    JSL CODE_00F545
    LDY.B _F
    CMP.B #$00
    RTS

HandleSprStunned:
    LDA.B SpriteNumber,X                      ; \ Branch if not Yoshi shell
    CMP.B #$2C                                ; /
    BNE CODE_019554
    LDA.B SpriteTableC2,X
    BEQ CODE_01956A
CODE_019546:
    LDA.B SpriteProperties                    ; \ Temporarily set $64 = #$10...
    PHA                                       ; |
    LDA.B #!OBJ_Priority1                     ; |
    STA.B SpriteProperties                    ; |
    JSR SubSprGfx2Entry1                      ; | ...and call gfx routine
    PLA                                       ; |
    STA.B SpriteProperties                    ; /
    RTS

CODE_019554:
    CMP.B #$2F                                ; \ If Spring Board...
    BEQ SetNormalStatus2                      ; | ...Unused Sprite 85...
    CMP.B #$85                                ; | ...or Balloon,
    BEQ SetNormalStatus2                      ; | Set Status = Normal...
    CMP.B #$7D                                ; |  ...and jump to $01A187
    BNE CODE_01956A                           ; |
    STZ.B SpriteYSpeed,X                      ; | Balloon Y Speed = 0
SetNormalStatus2:
    LDA.B #$08                                ; |
    STA.W SpriteStatus,X                      ; |
    JMP CODE_01A187                           ; /

CODE_01956A:
    LDA.B SpriteLock                          ; \ If sprites locked,
    BEQ +                                     ; | jump to $0195F5
    JMP CODE_0195F5                           ; /

  + JSR CODE_019624
    JSR SubUpdateSprPos
    JSR IsOnGround
    BEQ CODE_019598
    JSR CODE_0197D5
    LDA.B SpriteNumber,X
    CMP.B #$16                                ; \ If Vertical or Horizontal Fish,
    BEQ ADDR_019589                           ; |
    CMP.B #$15                                ; | jump to $019562
    BNE +                                     ; |
ADDR_019589:
    JMP SetNormalStatus2                      ; /

  + CMP.B #$2C                                ; \ Branch if not Yoshi Egg
    BNE CODE_019598                           ; /
    LDA.B #$F0                                ; \ Set upward speed
    STA.B SpriteYSpeed,X                      ; /
    JSL CODE_01F74C
CODE_019598:
    JSR IsTouchingCeiling
    BEQ +
    LDA.B #$10                                ; \ Set downward speed
    STA.B SpriteYSpeed,X                      ; /
    JSR IsTouchingObjSide
    BNE +
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position + #$08
    CLC                                       ; |
    ADC.B #$08                                ; |
    STA.B TouchBlockXPos                      ; |
    LDA.W SpriteXPosHigh,X                    ; |
    ADC.B #$00                                ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ $9A = Sprite X position
    AND.B #$F0                                ; | (Rounded down to nearest #$10)
    STA.B TouchBlockYPos                      ; |
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B TouchBlockYPos+1                    ; /
    LDA.W SpriteBlockedDirs,X
    AND.B #$20
    ASL A
    ASL A
    ASL A
    ROL A
    AND.B #$01
    STA.W LayerProcessing
    LDY.B #$00
    LDA.W Map16TileHittable
    JSL CODE_00F160
    LDA.B #$08
    STA.W SpriteMisc1FE2,X
  + JSR IsTouchingObjSide
    BEQ CODE_0195F2
    LDA.B SpriteNumber,X                      ; \ Call $0195E9 if sprite number < #$0D
    CMP.B #$0D                                ; | (Koopa Troopas)
    BCC +                                     ; |
    JSR CODE_01999E                           ; /
  + LDA.B SpriteXSpeed,X
    ASL A
    PHP
    ROR.B SpriteXSpeed,X
    PLP
    ROR.B SpriteXSpeed,X
CODE_0195F2:
    JSR SubSprSpr_MarioSpr
CODE_0195F5:
    JSR CODE_01A187
    JSR SubOffscreen0Bnk1
    RTS


    db $00,$00,$00,$00,$04,$05,$06,$07
    db $00,$00,$00,$00,$04,$05,$06,$07
    db $00,$00,$00,$00,$04,$05,$06,$07
    db $00,$00,$00,$00,$04,$05,$06,$07
SpriteKoopasSpawn:
    db $00,$00,$00,$00,$00,$01,$02,$03

CODE_019624:
    LDA.B SpriteNumber,X                      ; \ Branch away if sprite isn't a Bob-omb
    CMP.B #$0D                                ; |
    BNE CODE_01965C                           ; /
    LDA.W SpriteMisc1540,X                    ; \ Branch away if it's not time to explode
    CMP.B #$01                                ; |
    BNE +                                     ; /
    LDA.B #!SFX_KAPOW                         ; \ Bomb sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$01
    STA.W SpriteMisc1534,X
    LDA.B #$40                                ; \ Set explosion timer
    STA.W SpriteMisc1540,X                    ; /
    LDA.B #$08                                ; \ Set normal status
    STA.W SpriteStatus,X                      ; /
    LDA.W SpriteTweakerE,X                    ; \ Set to interact with other sprites
    AND.B #$F7                                ; |
    STA.W SpriteTweakerE,X                    ; /
    RTS

  + CMP.B #$40
    BCS +
    ASL A
    AND.B #$0E
    EOR.W SpriteOBJAttribute,X
    STA.W SpriteOBJAttribute,X
  + RTS

CODE_01965C:
    LDA.W SpriteMisc1540,X
    ORA.W SpriteMisc1558,X
    STA.B SpriteTableC2,X
    LDA.W SpriteMisc1558,X
    BEQ CODE_01969C
    CMP.B #$01
    BNE CODE_01969C
    LDY.W SpriteMisc1594,X
    LDA.W SpriteOnYoshiTongue,Y
    BNE CODE_01969C
    JSL LoadSpriteTables
    JSR FaceMario
    ASL.W SpriteOBJAttribute,X
    LSR.W SpriteOBJAttribute,X
    LDY.W SpriteMisc160E,X
    LDA.B #$08
    CPY.B #$03
    BNE +
    INC.W SpriteMisc187B,X
    LDA.W SpriteTweakerC,X                    ; \ Disable fireball/cape killing
    ORA.B #$30                                ; |
    STA.W SpriteTweakerC,X                    ; /
    LDA.B #$0A                                ; \ Sprite status = Kicked
  + STA.W SpriteStatus,X                      ; /
  - RTS

CODE_01969C:
    LDA.W SpriteMisc1540,X                    ; \ Return if stun timer == 0
    BEQ -                                     ; /
    CMP.B #$03                                ; \ If stun timer == 3, un-stun the sprite
    BEQ UnstunSprite                          ; /
    CMP.B #$01                                ; \ Every other frame, increment the stall timer
    BNE IncrmntStunTimer                      ; /  to emulates a slower timer
UnstunSprite:
    LDA.B SpriteNumber,X                      ; \ Branch if Buzzy Beetle
    CMP.B #$11                                ; |
    BEQ SetNormalStatus                       ; /
    CMP.B #$2E                                ; \ Branch if Spike Top
    BEQ SetNormalStatus                       ; /
    CMP.B #$2D                                ; \ Return if Baby Yoshi
    BEQ Return0196CA                          ; /
    CMP.B #$A2                                ; \ Branch if MechaKoopa
    BEQ SetNormalStatus                       ; /
    CMP.B #$0F                                ; \ Branch if Goomba
    BEQ SetNormalStatus                       ; /
    CMP.B #$2C                                ; \ Branch if Yoshi Egg
    BEQ Return0196CA                          ; /
    CMP.B #$53                                ; \ Branch if not Throw Block
    BNE GeneralResetSpr                       ; /
    JSR CODE_019ACB                           ; Set throw block to vanish
Return0196CA:
    RTS

SetNormalStatus:
    LDA.B #$08                                ; \ Sprite Status = Normal
    STA.W SpriteStatus,X                      ; /
    ASL.W SpriteOBJAttribute,X                ; \ Clear vertical flip bit
    LSR.W SpriteOBJAttribute,X                ; /
    RTS

IncrmntStunTimer:
    LDA.B TrueFrame                           ; \ Increment timer every other frame
    AND.B #$01                                ; |
    BNE +                                     ; |
    INC.W SpriteMisc1540,X                    ; |
  + RTS                                       ; /

GeneralResetSpr:
    JSL FindFreeSprSlot                       ; \ Return if no free sprite slot found
    BMI Return0196CA                          ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B SpriteNumber,X                      ; \ Store sprite number for shelless koopa
    TAX                                       ; |
    LDA.W SpriteKoopasSpawn,X                 ; |
    STA.W SpriteNumber,Y                      ; /
    TYX                                       ; \ Reset sprite tables
    JSL InitSpriteTables                      ; |
    LDX.W CurSpriteProcess                    ; /
    LDA.B SpriteXPosLow,X                     ; \ Shelless Koopa position = Koopa position
    STA.W SpriteXPosLow,Y                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    STA.W SpriteXPosHigh,Y                    ; |
    LDA.B SpriteYPosLow,X                     ; |
    STA.W SpriteYPosLow,Y                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    STA.W SpriteYPosHigh,Y                    ; /
    LDA.B #$00                                ; \ Direction = 0
    STA.W SpriteMisc157C,Y                    ; /
    LDA.B #$10
    STA.W SpriteMisc1564,Y
    LDA.W SpriteInLiquid,X
    STA.W SpriteInLiquid,Y
    LDA.W SpriteMisc1540,X
    STZ.W SpriteMisc1540,X
    CMP.B #$01
    BEQ +
    LDA.B #$D0                                ; \ Set upward speed
    STA.W SpriteYSpeed,Y                      ; /
    PHY                                       ; \ Make Shelless Koopa face away from Mario
    JSR SubHorizPos                           ; |
    TYA                                       ; |
    EOR.B #$01                                ; |
    PLY                                       ; |
    STA.W SpriteMisc157C,Y                    ; /
    PHX                                       ; \ Set Shelless X speed
    TAX                                       ; |
    LDA.W Spr0to13SpeedX,X                    ; |
    STA.W SpriteXSpeed,Y                      ; |
    PLX                                       ; /
    RTS

  + PHY
    JSR SubHorizPos
    LDA.W DATA_0197AD,Y
    STY.B _0
    PLY
    STA.W SpriteXSpeed,Y
    LDA.B _0
    EOR.B #$01
    STA.W SpriteMisc157C,Y
    STA.B _1
    LDA.B #$10
    STA.W SpriteMisc154C,Y
    STA.W SpriteMisc1528,Y
    LDA.B SpriteNumber,X                      ; \ If Yellow Koopa...
    CMP.B #$07                                ; |
    BNE Return019775                          ; |
    LDY.B #$08                                ; | ...find free sprite slot...
CODE_01976D:
    LDA.W SpriteStatus,Y                      ; |
    BEQ SpawnMovingCoin                       ; | ...and spawn moving coin
    DEY                                       ; |
    BPL CODE_01976D                           ; /
Return019775:
    RTS

SpawnMovingCoin:
    LDA.B #$08                                ; \ Sprite status = normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$21                                ; \ Sprite = Moving Coin
    STA.W SpriteNumber,Y                      ; /
    LDA.B SpriteXPosLow,X                     ; \ Copy X position to coin
    STA.W SpriteXPosLow,Y                     ; |
    LDA.W SpriteXPosHigh,X                    ; |
    STA.W SpriteXPosHigh,Y                    ; /
    LDA.B SpriteYPosLow,X                     ; \ Copy Y position to coin
    STA.W SpriteYPosLow,Y                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    STA.W SpriteYPosHigh,Y                    ; /
    PHX                                       ; \
    TYX                                       ; |
    JSL InitSpriteTables                      ; | Clear all sprite tables, and load new values
    PLX                                       ; /
    LDA.B #$D0                                ; \ Set Y speed
    STA.W SpriteYSpeed,Y                      ; /
    LDA.B _1                                  ; \ Set direction
    STA.W SpriteMisc157C,Y                    ; /
    LDA.B #$20
    STA.W SpriteMisc154C,Y
    RTS


DATA_0197AD:
    db $C0,$40

DATA_0197AF:
    db $00,$00,$00,$F8,$F8,$F8,$F8,$F8
    db $F8,$F7,$F6,$F5,$F4,$F3,$F2,$E8
    db $E8,$E8,$E8,$00,$00,$00,$00,$FE
    db $FC,$F8,$EC,$EC,$EC,$E8,$E4,$E0
    db $DC,$D8,$D4,$D0,$CC,$C8

CODE_0197D5:
    LDA.B SpriteXSpeed,X
    PHP
    BPL +
    JSR InvertAccum
  + LSR A
    PLP
    BPL +
    JSR InvertAccum
  + STA.B SpriteXSpeed,X
    LDA.B SpriteYSpeed,X
    PHA
    JSR SetSomeYSpeed__
    PLA
    LSR A
    LSR A
    TAY
    LDA.B SpriteNumber,X                      ; \ If Goomba, Y += #$13
    CMP.B #$0F                                ; |
    BNE +                                     ; |
    TYA                                       ; |
    CLC                                       ; |
    ADC.B #$13                                ; |
    TAY                                       ; /
  + LDA.W DATA_0197AF,Y
    LDY.W SpriteBlockedDirs,X
    BMI +
    STA.B SpriteYSpeed,X
  + RTS

CODE_019806:
    LDA.B #$06
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    BNE CODE_01980F
    LDA.B #$08
CODE_01980F:
    STA.W SpriteMisc1602,X
    LDA.W SpriteOAMIndex,X
    PHA
    BEQ +
    CLC
    ADC.B #$08
  + STA.W SpriteOAMIndex,X
    JSR SubSprGfx2Entry1
    PLA
    STA.W SpriteOAMIndex,X
    LDA.W OWLevelTileSettings+$49
    BMI Return0198A6
    LDA.W SpriteMisc1602,X
    CMP.B #$06
    BNE Return0198A6
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc1558,X
    BNE CODE_019842
    LDA.W SpriteMisc1540,X
    BEQ Return0198A6
    CMP.B #$30
    BCS +
CODE_019842:
    LSR A
    LDA.W OAMTileXPos+$108,Y
    ADC.B #$00
    BCS +
    STA.W OAMTileXPos+$108,Y
  + LDA.B SpriteNumber,X                      ; \ Branch away if a Buzzy Beetle
    CMP.B #$11                                ; |
    BEQ Return0198A6                          ; /
    JSR IsSprOffScreen
    BNE Return0198A6
    LDA.W SpriteOBJAttribute,X
    ASL A
    LDA.B #$08
    BCC +
    LDA.B #$00
  + STA.B _0
    LDA.W OAMTileXPos+$108,Y
    CLC
    ADC.B #$02
    STA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$04
    STA.W OAMTileXPos+$104,Y
    LDA.W OAMTileYPos+$108,Y
    CLC
    ADC.B _0
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    PHY
    LDY.B #$64
    LDA.B EffFrame
    AND.B #$F8
    BNE +
    LDY.B #$4D
  + TYA
    PLY
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$104,Y
    LDA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
Return0198A6:
    RTS


    db $E0,$20

CODE_0198A9:
    LDA.B SpriteLock
    BEQ +
    JMP CODE_019A2A

  + JSR SubUpdateSprPos
    LDA.W SpriteMisc151C,X
    AND.B #$1F
    BNE +
    JSR FaceMario
  + LDA.B SpriteXSpeed,X
    LDY.W SpriteMisc157C,X
    CPY.B #$00
    BNE CODE_0198D0
    CMP.B #$20
    BPL +
    INC.B SpriteXSpeed,X
    INC.B SpriteXSpeed,X
    BRA +

CODE_0198D0:
    CMP.B #$E0
    BMI +
    DEC.B SpriteXSpeed,X
    DEC.B SpriteXSpeed,X
  + JSR IsTouchingObjSide
    BEQ +
    PHA
    JSR CODE_01999E
    PLA
    AND.B #$03
    TAY
    LDA.W Return0198A6,Y
    STA.B SpriteXSpeed,X
  + JSR IsOnGround
    BEQ +
    JSR SetSomeYSpeed__
    LDA.B #$10
    STA.B SpriteYSpeed,X
  + JSR IsTouchingCeiling
    BEQ +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.B TrueFrame
    AND.B #$01
    BNE +
    LDA.W SpriteOBJAttribute,X
    INC A
    INC A
    AND.B #$CF
    STA.W SpriteOBJAttribute,X
  + JMP CODE_01998C


    db $F0,$EE,$EC

HandleSprKicked:
    LDA.W SpriteMisc187B,X
    BEQ +
    JMP CODE_0198A9

  + LDA.W SpriteTweakerD,X
    AND.B #$10
    BEQ +
    JSR CODE_01AA0B
    JMP CODE_01A187

  + LDA.W SpriteMisc1528,X
    BNE +
    LDA.B SpriteXSpeed,X
    CLC
    ADC.B #$20
    CMP.B #$40
    BCS +
    JSR CODE_01AA0B
  + STZ.W SpriteMisc1528,X
    LDA.B SpriteLock
    ORA.W SpriteMisc163E,X
    BEQ +
    JMP CODE_01998F

  + JSR UpdateDirection
    LDA.W SpriteSlope,X
    PHA
    JSR SubUpdateSprPos
    PLA
    BEQ CODE_019969
    STA.B _0
    LDY.W SpriteInLiquid,X
    BNE CODE_019969
    CMP.W SpriteSlope,X
    BEQ CODE_019969
    EOR.B SpriteXSpeed,X
    BMI CODE_019969
    LDA.B #$F8                                ; \ Set upward speed
    STA.B SpriteYSpeed,X                      ; /
    BRA CODE_019975

CODE_019969:
    JSR IsOnGround
    BEQ CODE_019984
    JSR SetSomeYSpeed__
    LDA.B #$10                                ; \ Set downward speed
    STA.B SpriteYSpeed,X                      ; /
CODE_019975:
    LDA.W SprMap16TouchHorizLow
    CMP.B #$B5
    BEQ CODE_019980
    CMP.B #$B4
    BNE CODE_019984
CODE_019980:
    LDA.B #$B8
    STA.B SpriteYSpeed,X
CODE_019984:
    JSR IsTouchingObjSide
    BEQ CODE_01998C
    JSR CODE_01999E
CODE_01998C:
    JSR SubSprSpr_MarioSpr
CODE_01998F:
    JSR SubOffscreen0Bnk1
    LDA.B SpriteNumber,X                      ; \ Branch if throw block sprite
    CMP.B #$53                                ; |
    BEQ +                                     ; /
    JMP CODE_019A2A

  + JMP StunThrowBlock

CODE_01999E:
    LDA.B #!SFX_BONK
    STA.W SPCIO0                              ; / Play sound effect
    JSR CODE_0190A2
    LDA.W SpriteOffscreenX,X
    BNE +
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.B #$14
    CMP.B #$1C
    BCC +
    LDA.W SpriteBlockedDirs,X
    AND.B #$40
    ASL A
    ASL A
    ROL A
    AND.B #$01
    STA.W LayerProcessing
    LDY.B #$00
    LDA.W Map16TileDestroy
    JSL CODE_00F160
    LDA.B #$05
    STA.W SpriteMisc1FE2,X
  + LDA.B SpriteNumber,X                      ; \ If Throw Block, break it
    CMP.B #$53                                ; |
    BNE +                                     ; |
    JSR BreakThrowBlock                       ; /
  + RTS

BreakThrowBlock:
    STZ.W SpriteStatus,X                      ; Free up sprite slot
    LDY.B #$FF                                ; Is this for the shatter routine??
CODE_0199E1:
    JSR IsSprOffScreen                        ; \ Return if off screen
    BNE +                                     ; /
    LDA.B SpriteXPosLow,X                     ; \ Store Y position in $9A-$9B
    STA.B TouchBlockXPos                      ; |
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ Store X position in $98-$99
    STA.B TouchBlockYPos                      ; |
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B TouchBlockYPos+1                    ; /
    PHB                                       ; \ Shatter the brick
    LDA.B #$02                                ; |
    PHA                                       ; |
    PLB                                       ; |
    TYA                                       ; |
    JSL ShatterBlock                          ; |
    PLB                                       ; /
  + RTS

SetSomeYSpeed__:
    LDA.W SpriteBlockedDirs,X
    BMI CODE_019A10
    LDA.B #$00                                ; \ Sprite Y speed = #$00 or #$18
    LDY.W SpriteSlope,X                       ; | Depending on 15B8,x ???
    BEQ +                                     ; |
CODE_019A10:
    LDA.B #$18                                ; |
  + STA.B SpriteYSpeed,X                      ; /
    RTS

UpdateDirection:
    LDA.B #$00                                ; \ Subroutine: Set direction from speed value
    LDY.B SpriteXSpeed,X                      ; |
    BEQ Return019A21                          ; |
    BPL +                                     ; |
    INC A                                     ; |
  + STA.W SpriteMisc157C,X                    ; |
Return019A21:
    RTS                                       ; /


ShellAniTiles:
    db $06,$07,$08,$07

ShellGfxProp:
    db $00,$00,$00,$40

CODE_019A2A:
    LDA.B SpriteTableC2,X
    STA.W SpriteMisc1558,X
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03
    TAY
    PHY
    LDA.W ShellAniTiles,Y
    JSR CODE_01980F
    STZ.W SpriteMisc1558,X
    PLY
    LDA.W ShellGfxProp,Y
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    EOR.W OAMTileAttr+$108,Y
    STA.W OAMTileAttr+$108,Y
    RTS


SpinJumpSmokeTiles:
    db $64,$62,$60,$62

HandleSprSpinJump:
    LDA.W SpriteMisc1540,X                    ; \ Erase sprite if time up
    BEQ SpinJumpEraseSpr                      ; /
    JSR SubSprGfx2Entry1                      ; Call generic gfx routine
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc1540,X                    ; \ Load tile based on timer
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    AND.B #$03                                ; |
    PHX                                       ; |
    TAX                                       ; |
    LDA.W SpinJumpSmokeTiles,X                ; |
    PLX                                       ;  /
    STA.W OAMTileNo+$100,Y                    ; Overwrite tile
    STA.W OAMTileAttr+$100,Y                  ; \ Overwrite properties
    AND.B #$30                                ; |
    STA.W OAMTileAttr+$100,Y                  ; /
    RTS

SpinJumpEraseSpr:
    JSR OffScrEraseSprite                     ; Permanently kill the sprite
    RTS

CODE_019A7B:
    LDA.W SpriteMisc1558,X
    BEQ SpinJumpEraseSpr
    LDA.B #$04
    STA.B SpriteYSpeed,X
    ASL.W SpriteTweakerF,X
    LSR.W SpriteTweakerF,X
    LDA.B SpriteXSpeed,X
    BEQ CODE_019A9D
    BPL CODE_019A94
    INC.B SpriteXSpeed,X
    BRA CODE_019A9D

CODE_019A94:
    DEC.B SpriteXSpeed,X
    JSR IsTouchingObjSide
    BEQ CODE_019A9D
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
CODE_019A9D:
    LDA.B #$01
    STA.W SpriteBehindScene,X
HandleSprKilled:
    LDA.B SpriteNumber,X                      ; \ If Wiggler, call main sprite routine
    CMP.B #$86                                ; |
    BNE +                                     ; |
    JMP CallSpriteMain                        ; /

  + CMP.B #$1E                                ; \ If Lakitu, $18E0 = #$FF
    BNE +                                     ; |
    LDY.B #$FF                                ; |
    STY.W LakituCloudTimer                    ; /
  + CMP.B #$53                                ; \ If Throw Block sprite...
    BNE +                                     ; |
    JSR BreakThrowBlock                       ; | ...break block...
    RTS                                       ; / ...and return

  + CMP.B #$4C                                ; \ If Exploding Block Enemy
    BNE +                                     ; |
    JSL CODE_02E463                           ; /
  + LDA.W SpriteTweakerA,X                    ; \ If "disappears in puff of smoke" is set...
    AND.B #$80                                ; |
    BEQ +                                     ; |
CODE_019ACB:
    LDA.B #$04                                ; | ...Sprite status = Spin Jump Killed...
    STA.W SpriteStatus,X                      ; |
    LDA.B #$1F                                ; | ...Set Time to show smoke cloud...
    STA.W SpriteMisc1540,X                    ; |
    RTS                                       ; / ... and return

  + LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    JSR SubUpdateSprPos
  + JSR SubOffscreen0Bnk1
    JSR HandleSpriteDeath
    RTS

HandleSprSmushed:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_019AFE                           ; /
    LDA.W SpriteMisc1540,X                    ; \ Free sprite slot when timer runs out
    BNE +                                     ; |
    STZ.W SpriteStatus,X                      ; /
    RTS

  + JSR SubUpdateSprPos
    JSR IsOnGround
    BEQ CODE_019AFE
    JSR SetSomeYSpeed__
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
CODE_019AFE:
    LDA.B SpriteNumber,X                      ; \ If Dino Torch...
    CMP.B #$6F                                ; |
    BNE +                                     ; |
    JSR SubSprGfx2Entry1                      ; | ...call standard gfx routine...
    LDY.W SpriteOAMIndex,X                    ; |
    LDA.B #$AC                                ; | ...and replace the tile with #$AC
    STA.W OAMTileNo+$100,Y                    ; |
    RTS                                       ; / Return

  + JMP SmushedGfxRt                          ; Call smushed gfx routine

HandleSpriteDeath:
    LDA.W SpriteTweakerD,X                    ; \ If the main routine handles the death state...
    AND.B #$01                                ; |
    BEQ +                                     ; |
    JMP CallSpriteMain                        ; / ...jump to the main routine

  + STZ.W SpriteMisc1602,X
    LDA.W SpriteTweakerF,X                    ; \ Branch if "Death frame 2 tiles high"
    AND.B #$20                                ; | is NOT set
    BEQ CODE_019B64                           ; /
    LDA.W SpriteTweakerB,X                    ; \ Branch if "Use shell as death frame"
    AND.B #$40                                ; | is set
    BNE CODE_019B5F                           ; /
    LDA.B SpriteNumber,X                      ; \ Branch if Lakitu
    CMP.B #$1E                                ; |
    BEQ CODE_019B3D                           ; /
    CMP.B #$4B                                ; \ If Pipe Lakitu,
    BNE CODE_019B44                           ; |
    LDA.B #$01                                ; | set behind scenery flag
    STA.W SpriteBehindScene,X                 ; /
CODE_019B3D:
    LDA.B #$01
    STA.W SpriteMisc1602,X
    BRA +

CODE_019B44:
    LDA.W SpriteOBJAttribute,X                ; \ Set to flip tiles vertically
    ORA.B #$80                                ; |
    STA.W SpriteOBJAttribute,X                ; /
  + LDA.B SpriteProperties                    ; \ If sprite is behind scenery,
    PHA                                       ; |
    LDY.W SpriteBehindScene,X                 ; |
    BEQ +                                     ; |
    LDA.B #!OBJ_Priority1                     ; | temorarily set layer priority for gfx routine
  + STA.B SpriteProperties                    ; |
    JSR SubSprGfx1                            ; | Draw sprite
    PLA                                       ; |
    STA.B SpriteProperties                    ; /
    RTS

CODE_019B5F:
    LDA.B #$06
    STA.W SpriteMisc1602,X
CODE_019B64:
    LDA.B #$00
    CPY.B #$1C
    BEQ +
    LDA.B #$80
  + STA.B _0
    LDA.B SpriteProperties                    ; \ If sprite is behind scenery,
    PHA                                       ; |
    LDY.W SpriteBehindScene,X                 ; |
    BEQ +                                     ; |
    LDA.B #!OBJ_Priority1                     ; | temorarily set layer priority for gfx routine
  + STA.B SpriteProperties                    ; |
    LDA.B _0
    JSR SubSprGfx2Entry0                      ; | Draw sprite
    PLA                                       ; |
    STA.B SpriteProperties                    ; /
    RTS


SprTilemap:
    db $82,$A0,$82,$A2,$84,$A4,$8C,$8A
    db $8E,$C8,$CA,$CA,$CE,$CC,$86,$4E
    db $E0,$E2,$E2,$CE,$E4,$E0,$E0,$A3
    db $A3,$B3,$B3,$E9,$E8,$F9,$F8,$E8
    db $E9,$F8,$F9,$E2,$E6,$AA,$A8,$A8
    db $AA,$A2,$A2,$B2,$B2,$C3,$C2,$D3
    db $D2,$C2,$C3,$D2,$D3,$E2,$E6,$CA
    db $CC,$CA,$AC,$CE,$AE,$CE,$83,$83
    db $C4,$C4,$83,$83,$C5,$C5,$8A,$A6
    db $A4,$A6,$A8,$80,$82,$80,$84,$84
    db $84,$84,$94,$94,$94,$94,$A0,$B0
    db $A0,$D0,$82,$80,$82,$00,$00,$00
    db $86,$84,$88,$EC,$8C,$A8,$AA,$8E
    db $AC,$AE,$8E,$EC,$EE,$CE,$EE,$A8
    db $EE,$40,$40,$A0,$C0,$A0,$C0,$A4
    db $C4,$A4,$C4,$A0,$C0,$A0,$C0,$40
    db $07,$27,$4C,$29,$4E,$2B,$82,$A0
    db $84,$A4,$67,$69,$88,$CE,$8E,$AE
    db $A2,$A2,$B2,$B2,$00,$40,$44,$42
    db $2C,$42,$28,$28,$28,$28,$4C,$4C
    db $4C,$4C,$83,$83,$6F,$6F,$AC,$BC
    db $AC,$A6,$8C,$AA,$86,$84,$DC,$EC
    db $DE,$EE,$06,$06,$16,$16,$07,$07
    db $17,$17,$16,$16,$06,$06,$17,$17
    db $07,$07,$84,$86,$00,$00,$00,$0E
    db $2A,$24,$02,$06,$0A,$20,$22,$28
    db $26,$2E,$40,$42,$0C,$04,$2B,$6A
    db $ED,$88,$8C,$A8,$8E,$AA,$AE,$8C
    db $88,$A8,$AE,$AC,$8C,$8E,$CE,$EE
    db $C4,$C6,$82,$84,$86,$8C,$CE,$CE
    db $88,$89,$CE,$CE,$89,$88,$F3,$CE
    db $F3,$CE,$A7,$A9

SprTilemapOffset:
    db $09,$09,$10,$09,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$37,$00,$25
    db $25,$5A,$00,$4B,$4E,$8A,$8A,$8A
    db $8A,$56,$3A,$46,$47,$69,$6B,$73
    db $00,$00,$80,$80,$80,$80,$8E,$90
    db $00,$00,$3A,$F6,$94,$95,$63,$9A
    db $A6,$AA,$AE,$B2,$C2,$C4,$D5,$D9
    db $D7,$D7,$E6,$E6,$E6,$E2,$99,$17
    db $29,$E6,$E6,$E6,$00,$E8,$00,$8A
    db $E8,$00,$ED,$EA,$7F,$EA,$EA,$3A
    db $3A,$FA,$71,$7F

GeneralSprDispX:
    db $00,$08,$00,$08

GeneralSprDispY:
    db $00,$00,$08,$08

GeneralSprGfxProp:
    db $00,$00,$00,$00,$00,$40,$00,$40
    db $00,$40,$80,$C0,$40,$40,$00,$00
    db $40,$00,$C0,$80,$40,$40,$40,$40

SubSprGfx0Entry0:
    LDY.B #$00
SubSprGfx0Entry1:
    STA.B _5
    STY.B _F
    JSR GetDrawInfoBnk1
    LDY.B _F
    TYA
    CLC
    ADC.B _1
    STA.B _1
    LDY.B SpriteNumber,X
    LDA.W SpriteMisc1602,X
    ASL A
    ASL A
    ADC.W SprTilemapOffset,Y
    STA.B _2
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties
    STA.B _3
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$03
    STA.B _4
    PHX
  - LDX.B _4
    LDA.B _0
    CLC
    ADC.W GeneralSprDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W GeneralSprDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.B _2
    CLC
    ADC.B _4
    TAX
    LDA.W SprTilemap,X
    STA.W OAMTileNo+$100,Y
    LDA.B _5
    ASL A
    ASL A
    ADC.B _4
    TAX
    LDA.W GeneralSprGfxProp,X
    ORA.B _3
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEC.B _4
    BPL -
    PLX
    LDA.B #$03
    LDY.B #$00
    JSR FinishOAMWriteRt
    RTS

GenericSprGfxRt1:
    PHB
    PHK
    PLB
    JSR SubSprGfx1
    PLB
    RTL

SubSprGfx1:
    LDA.W SpriteOBJAttribute,X
    BPL +
    JSR SubSprGfx1Hlpr1
    RTS

  + JSR GetDrawInfoBnk1
    LDA.W SpriteMisc157C,X
    STA.B _2
    TYA
    LDY.B SpriteNumber,X
    CPY.B #$0F
    BCS +
    ADC.B #$04
  + TAY
    PHY
    LDY.B SpriteNumber,X
    LDA.W SpriteMisc1602,X
    ASL A
    CLC
    ADC.W SprTilemapOffset,Y
    TAX
    PLY
    LDA.W SprTilemap,X
    STA.W OAMTileNo+$100,Y
    LDA.W SprTilemap+1,X
    STA.W OAMTileNo+$104,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    CLC
    ADC.B #$10
    STA.W OAMTileYPos+$104,Y
CODE_019DA9:
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    LDA.W SpriteMisc157C,X
    LSR A
    LDA.B #$00
    ORA.W SpriteOBJAttribute,X
    BCS +
    ORA.B #!OBJ_XFlip
  + ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    ORA.W SpriteOffscreenX,X
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
    JSR CODE_01A3DF
    RTS

SubSprGfx1Hlpr1:
    JSR GetDrawInfoBnk1
    LDA.W SpriteMisc157C,X
    STA.B _2
    TYA
    CLC
    ADC.B #$08
    TAY
    PHY
    LDY.B SpriteNumber,X
    LDA.W SpriteMisc1602,X
    ASL A
    CLC
    ADC.W SprTilemapOffset,Y
    TAX
    PLY
    LDA.W SprTilemap,X
    STA.W OAMTileNo+$104,Y
    LDA.W SprTilemap+1,X
    STA.W OAMTileNo+$100,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    CLC
    ADC.B #$10
    STA.W OAMTileYPos+$104,Y
    JMP CODE_019DA9


KoopaWingDispXLo:
    db $FF,$F7,$09,$09

KoopaWingDispXHi:
    db $FF,$FF,$00,$00

KoopaWingDispY:
    db $FC,$F4,$FC,$F4

KoopaWingTiles:
    db $5D,$C6,$5D,$C6

KoopaWingGfxProp:
    db $46,$46,$06,$06

KoopaWingTileSize:
    db $00,$02,$00,$02

KoopaWingGfxRt:
    LDY.B #$00                                ; \ If not on ground, $02 = animation frame (00 or 01)
    JSR IsOnGround                            ; | else, $02 = 0
    BNE CODE_019E35                           ; |
    LDA.W SpriteMisc1602,X                    ; |
    AND.B #$01                                ; |
    TAY                                       ; |
CODE_019E35:
    STY.B _2                                  ; /
CODE_019E37:
    LDA.W SpriteOffscreenVert,X               ; \ Return if offscreen vertically
    BNE Return019E94                          ; /
    LDA.B SpriteXPosLow,X                     ; \ $00 = X position low
    STA.B _0                                  ; /
    LDA.W SpriteXPosHigh,X                    ; \ $04 = X position high
    STA.B _4                                  ; /
    LDA.B SpriteYPosLow,X                     ; \ $01 = Y position low
    STA.B _1                                  ; /
    LDY.W SpriteOAMIndex,X                    ; Y = index to OAM
    PHX
    LDA.W SpriteMisc157C,X                    ; \ X = index into tables
    ASL A                                     ; |
    ADC.B _2                                  ; |
    TAX                                       ; /
    LDA.B _0                                  ; \ Store X position (relative to screen)
    CLC                                       ; |
    ADC.W KoopaWingDispXLo,X                  ; |
    STA.B _0                                  ; |
    LDA.B _4                                  ; |
    ADC.W KoopaWingDispXHi,X                  ; |
    PHA                                       ; |
    LDA.B _0                                  ; |
    SEC                                       ; |
    SBC.B Layer1XPos                          ; |
    STA.W OAMTileXPos+$100,Y                  ; /
    PLA                                       ; \ Return if off screen horizontally
    SBC.B Layer1XPos+1                        ; |
    BNE +                                     ; /
    LDA.B _1                                  ; \ Store Y position (relative to screen)
    SEC                                       ; |
    SBC.B Layer1YPos                          ; |
    CLC                                       ; |
    ADC.W KoopaWingDispY,X                    ; |
    STA.W OAMTileYPos+$100,Y                  ; /
    LDA.W KoopaWingTiles,X                    ; \ Store tile
    STA.W OAMTileNo+$100,Y                    ; /
    LDA.B SpriteProperties                    ; \ Store tile properties
    ORA.W KoopaWingGfxProp,X                  ; |
    STA.W OAMTileAttr+$100,Y                  ; /
    TYA
    LSR A
    LSR A
    TAY
    LDA.W KoopaWingTileSize,X                 ; \ Store tile size
    STA.W OAMTileSize+$40,Y                   ; /
  + PLX
Return019E94:
    RTS

CODE_019E95:
    LDA.B SpriteYPosLow,X
    PHA
    CLC
    ADC.B #$02
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B SpriteXPosLow,X
    PHA
    SEC
    SBC.B #$02
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.W SpriteOAMIndex,X
    PHA
    CLC
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    LDA.W SpriteMisc157C,X
    PHA
    STZ.W SpriteMisc157C,X
    LDA.W SpriteMisc1570,X
    LSR A
    LSR A
    LSR A
    AND.B #$01
    TAY
    JSR CODE_019E35
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$04
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    INC.W SpriteMisc157C,X
    JSR CODE_019E37
    PLA
    STA.W SpriteMisc157C,X
    PLA
    STA.W SpriteOAMIndex,X
    PLA
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    RTS

SubSprGfx2Entry0:
    STA.B _4
    BRA +

SubSprGfx2Entry1:
    STZ.B _4
  + JSR GetDrawInfoBnk1
    LDA.W SpriteMisc157C,X
    STA.B _2
    LDY.B SpriteNumber,X
    LDA.W SpriteMisc1602,X
    CLC
    ADC.W SprTilemapOffset,Y
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    TAX
    LDA.W SprTilemap,X
    STA.W OAMTileNo+$100,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.W SpriteMisc157C,X
    LSR A
    LDA.B #$00
    ORA.W SpriteOBJAttribute,X
    BCS +
    EOR.B #!OBJ_XFlip
  + ORA.B _4
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    ORA.W SpriteOffscreenX,X
    STA.W OAMTileSize+$40,Y
    JSR CODE_01A3DF
    RTS


DATA_019F5B:
    db $0B,$F5,$04,$FC,$04,$00

DATA_019F61:
    db $00,$FF,$00,$FF,$00,$00

DATA_019F67:
    db $F3,$0D

DATA_019F69:
    db $FF,$00

if ver_is_ntsc(!_VER)                         ;\================== J, U, & SS =================
ShellSpeedX:                                  ;!
    db $D2,$2E,$CC,$34                        ;!
else                                          ;<==================== E0 & E1 ==================
ShellSpeedX:                                  ;!
    db $C9,$37,$C2,$3E                        ;!
endif                                         ;/===============================================

DATA_019F6F:
    db $00,$10

HandleSprCarried:
    JSR CODE_019F9B
    LDA.W PlayerTurningPose
    BNE CODE_019F83
    LDA.W YoshiInPipeSetting                  ; \ Branch if Yoshi going down pipe
    BNE CODE_019F83                           ; /
    LDA.W FaceScreenTimer                     ; \ Branch if Mario facing camera
    BEQ +                                     ; /
CODE_019F83:
    STZ.W SpriteOAMIndex,X
  + LDA.B SpriteProperties
    PHA
    LDA.W YoshiInPipeSetting
    BEQ +
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
  + JSR CODE_01A187
    PLA
    STA.B SpriteProperties
    RTS


DATA_019F99:
    db $FC,$04

CODE_019F9B:
    LDA.B SpriteNumber,X                      ; \ Branch if not Balloon
    CMP.B #$7D                                ; |
    BNE CODE_019FE0                           ; /
    LDA.B TrueFrame
    AND.B #$03
    BNE CODE_019FBE
    DEC.W PBalloonTimer
    BEQ CODE_019FC4
    LDA.W PBalloonTimer
    CMP.B #$30
    BCS CODE_019FBE
    LDY.B #$01
    AND.B #$04
    BEQ +
    LDY.B #$09
  + STY.W PBalloonInflating
CODE_019FBE:
    LDA.B PlayerAnimation                     ; \ Branch if no Mario animation sequence in progress
    CMP.B #$01                                ; |
    BCC +                                     ; /
CODE_019FC4:
    STZ.W PBalloonInflating
    JMP OffScrEraseSprite

  + PHB
    LDA.B #$02
    PHA
    PLB
    JSL CODE_02D214
    PLB
    JSR CODE_01A0B1
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$F0
    STA.W OAMTileYPos+$100,Y
    RTS

CODE_019FE0:
    JSR CODE_019140
    LDA.B PlayerAnimation                     ; \ Branch if no Mario animation sequence in progress
    CMP.B #$01                                ; |
    BCC +                                     ; /
    LDA.W YoshiInPipeSetting                  ; \ Branch if in pipe
    BNE +                                     ; /
    LDA.B #$09                                ; \ Sprite status = Stunned
    STA.W SpriteStatus,X                      ; /
    RTS

  + LDA.W SpriteStatus,X                      ; \ Return if sprite status == Normal
    CMP.B #$08                                ; |
    BEQ Return01A014                          ; /
    LDA.B SpriteLock                          ; \ Jump if sprites locked
    BEQ +                                     ; |
    JMP CODE_01A0B1                           ; /

  + JSR CODE_019624
    JSR SubSprSprInteract
    LDA.W YoshiInPipeSetting
    BNE CODE_01A011
    BIT.B byetudlrHold
    BVC +
CODE_01A011:
    JSR CODE_01A0B1
Return01A014:
    RTS

  + STZ.W SpriteMisc1626,X
    LDY.B #$00
    LDA.B SpriteNumber,X                      ; \ Branch if not Goomba
    CMP.B #$0F                                ; |
    BNE +                                     ; /
    LDA.B PlayerInAir
    BNE +
    LDY.B #$EC
  + STY.B SpriteYSpeed,X
    LDA.B #$09                                ; \ Sprite status = Carryable
    STA.W SpriteStatus,X                      ; /
    LDA.B byetudlrHold
    AND.B #$08
    BNE CODE_01A068
    LDA.B SpriteNumber,X                      ; \ Branch if sprite >= #$15
    CMP.B #$15                                ; |
    BCS CODE_01A041                           ; /
    LDA.B byetudlrHold
    AND.B #$04
    BEQ CODE_01A079
    BRA CODE_01A047

CODE_01A041:
    LDA.B byetudlrHold
    AND.B #$03
    BNE CODE_01A079
CODE_01A047:
    LDY.B PlayerDirection
    LDA.B PlayerXPosNow
    CLC
    ADC.W DATA_019F67,Y
    STA.B SpriteXPosLow,X
    LDA.B PlayerXPosNow+1
    ADC.W DATA_019F69,Y
    STA.W SpriteXPosHigh,X
    JSR SubHorizPos
    LDA.W DATA_019F99,Y
    CLC
    ADC.B PlayerXSpeed+1
    STA.B SpriteXSpeed,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    BRA CODE_01A0A6

CODE_01A068:
    JSL CODE_01AB6F
    LDA.B #$90
    STA.B SpriteYSpeed,X
    LDA.B PlayerXSpeed+1
    STA.B SpriteXSpeed,X
    ASL A
    ROR.B SpriteXSpeed,X
    BRA CODE_01A0A6

CODE_01A079:
    JSL CODE_01AB6F
    LDA.W SpriteMisc1540,X
    STA.B SpriteTableC2,X
    LDA.B #$0A                                ; \ Sprite status = Kicked
    STA.W SpriteStatus,X                      ; /
    LDY.B PlayerDirection
    LDA.W PlayerRidingYoshi
    BEQ +
    INY
    INY
  + LDA.W ShellSpeedX,Y
    STA.B SpriteXSpeed,X
    EOR.B PlayerXSpeed+1
    BMI CODE_01A0A6
    LDA.B PlayerXSpeed+1
    STA.B _0
    ASL.B _0
    ROR A
    CLC
    ADC.W ShellSpeedX,Y
    STA.B SpriteXSpeed,X
CODE_01A0A6:
    LDA.B #$10
    STA.W SpriteMisc154C,X
    LDA.B #$0C
    STA.W KickingTimer
    RTS

CODE_01A0B1:
    LDY.B #$00
    LDA.B PlayerDirection                     ; \ Y = Mario's direction
    BNE +                                     ; |
    INY                                       ; /
  + LDA.W FaceScreenTimer
    BEQ +
    INY
    INY
    CMP.B #$05
    BCC +
    INY
  + LDA.W YoshiInPipeSetting
    BEQ CODE_01A0CD
    CMP.B #$02
    BEQ CODE_01A0D4
CODE_01A0CD:
    LDA.W PlayerTurningPose
    ORA.B PlayerIsClimbing
    BEQ +
CODE_01A0D4:
    LDY.B #$05
  + PHY
    LDY.B #$00
    LDA.W StandOnSolidSprite
    CMP.B #$03
    BEQ +
    LDY.B #$3D
  + LDA.W PlayerXPosNext,Y                    ; \ $00 = Mario's X position
    STA.B _0                                  ; |
    LDA.W PlayerXPosNext+1,Y                  ; |
    STA.B _1                                  ; /
    LDA.W PlayerYPosNext,Y                    ; \ $02 = Mario's Y position
    STA.B _2                                  ; |
    LDA.W PlayerYPosNext+1,Y                  ; |
    STA.B _3                                  ; /
    PLY
    LDA.B _0
    CLC
    ADC.W DATA_019F5B,Y
    STA.B SpriteXPosLow,X
    LDA.B _1
    ADC.W DATA_019F61,Y
    STA.W SpriteXPosHigh,X
    LDA.B #$0D
    LDY.B PlayerIsDucking                     ; \ Branch if ducking
    BNE CODE_01A111                           ; /
    LDY.B Powerup                             ; \ Branch if Mario isn't small
    BNE +                                     ; /
CODE_01A111:
    LDA.B #$0F
  + LDY.W PickUpItemTimer
    BEQ +
    LDA.B #$0F
  + CLC
    ADC.B _2
    STA.B SpriteYPosLow,X
    LDA.B _3
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B #$01
    STA.W IsCarryingItem
    STA.W CarryingFlag                        ; Set carrying enemy flag
    RTS

StunGoomba:
    LDA.B EffFrame
    LSR A
    LSR A
    LDY.W SpriteMisc1540,X
    CPY.B #$30
    BCC +
    LSR A
  + AND.B #$01
    STA.W SpriteMisc1602,X
    CPY.B #$08
    BNE +
    JSR IsOnGround
    BEQ +
    LDA.B #$D8
    STA.B SpriteYSpeed,X
  + LDA.B #$80
    JMP SubSprGfx2Entry0

StunMechaKoopa:
    LDA.B Layer1XPos
    PHA
    LDA.W SpriteMisc1540,X
    CMP.B #$30
    BCS +
    AND.B #$01
    EOR.B Layer1XPos
    STA.B Layer1XPos
  + JSL CODE_03B307
    PLA
    STA.B Layer1XPos
CODE_01A169:
    LDA.W SpriteStatus,X                      ; \ If sprite status == Carried,
    CMP.B #$0B                                ; |
    BNE +                                     ; |
    LDA.B PlayerDirection                     ; | Sprite direction = Opposite direction of Mario
    EOR.B #$01                                ; |
    STA.W SpriteMisc157C,X                    ; /
  + RTS

StunFish:
    JSR SetAnimationFrame
    LDA.W SpriteOBJAttribute,X
    ORA.B #$80
    STA.W SpriteOBJAttribute,X
    JSR SubSprGfx2Entry1
    RTS

CODE_01A187:
    LDA.W SpriteTweakerD,X                    ; \ Branch if sprite changes into a shell
    AND.B #$08                                ; |
    BEQ CODE_01A1D0                           ; /
    LDA.B SpriteNumber,X
    CMP.B #$A2
    BEQ StunMechaKoopa
    CMP.B #$15
    BEQ StunFish
    CMP.B #$16
    BEQ StunFish
    CMP.B #$0F
    BEQ StunGoomba
    CMP.B #$53
    BEQ StunThrowBlock
    CMP.B #$2C
    BEQ StunYoshiEgg
    CMP.B #$80
    BEQ StunKey
    CMP.B #$7D
    BEQ Return01A1D3
    CMP.B #$3E
    BEQ StunPow
    CMP.B #$2F
    BEQ StunSpringBoard
    CMP.B #$0D
    BEQ StunBomb
    CMP.B #$2D
    BEQ StunBabyYoshi
    CMP.B #$85
    BNE CODE_01A1D0
    JSR SubSprGfx2Entry1                      ; \ Handle unused sprite 85
    LDY.W SpriteOAMIndex,X                    ; |
    LDA.B #$47                                ; | Set OAM with tile #$47
    STA.W OAMTileNo+$100,Y                    ; /
    RTS

CODE_01A1D0:
    JSR CODE_019806
Return01A1D3:
    RTS

StunThrowBlock:
    LDA.W SpriteMisc1540,X
    CMP.B #$40
    BCS CODE_01A1DE
    LSR A
    BCS StunYoshiEgg
CODE_01A1DE:
    LDA.W SpriteOBJAttribute,X
    INC A
    INC A
    AND.B #$0F
    STA.W SpriteOBJAttribute,X
StunYoshiEgg:
    JSR SubSprGfx2Entry1
    RTS

StunBomb:
    JSR SubSprGfx2Entry1
    LDA.B #$CA
    BRA CODE_01A222

StunKey:
    JSR CODE_01A169
    JSR SubSprGfx2Entry1
    LDA.B #$EC
    BRA CODE_01A222

StunPow:
    LDY.W SpriteMisc163E,X
    BEQ CODE_01A218
    CPY.B #$01
    BNE +
    JMP CODE_019ACB

  + JSR SmushedGfxRt
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileAttr+$100,Y
    AND.B #$FE
    STA.W OAMTileAttr+$100,Y
    RTS

CODE_01A218:
    LDA.B #$01
    STA.W SpriteMisc157C,X
    JSR SubSprGfx2Entry1
    LDA.B #$42
CODE_01A222:
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    STA.W OAMTileNo+$100,Y
    RTS

StunSpringBoard:
    JMP CODE_01E6F0

StunBabyYoshi:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01A27B                           ; /
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$08
    STA.B _0
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.B _8
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$08
    STA.B _1
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _9
    JSL CODE_02B9FA
    JSL CODE_02EA4E
    LDA.W SpriteMisc163E,X
    BNE CODE_01A27E
    DEC A
    STA.W SpriteMisc160E,X
    LDA.W SpriteStatus,X                      ; \ Branch if sprite status != Stunned
    CMP.B #$09                                ; |
    BNE +                                     ; /
    JSR IsOnGround
    BEQ +
    LDA.B #$F0
    STA.B SpriteYSpeed,X
  + LDY.B #$00
    LDA.B EffFrame
    AND.B #$18
    BNE +
    LDY.B #$03
  + TYA
    STA.W SpriteMisc1602,X
CODE_01A27B:
    JMP CODE_01A34F

CODE_01A27E:
    STZ.W SpriteOAMIndex,X
    CMP.B #$20
    BEQ +
    JMP CODE_01A30A

  + LDY.W SpriteMisc160E,X
    LDA.B #$00                                ; \ Clear sprite status
    STA.W SpriteStatus,Y                      ; /
    LDA.B #!SFX_GULP
    STA.W SPCIO0                              ; / Play sound effect
    LDA.W SpriteMisc160E,Y
    BNE CODE_01A2F4
    LDA.W SpriteNumber,Y                      ; \ Branch if not Changing power up
    CMP.B #$81                                ; |
    BNE +                                     ; /
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W ChangingItemSprite,Y
  + CMP.B #$74
    BCC CODE_01A2F4
    CMP.B #$78
    BCS CODE_01A2F4
CODE_01A2B5:
    STZ.W YoshiSwallowTimer
    STZ.W YoshiHasWingsEvt                    ; No Yoshi wings
    LDA.B #$35                                ; \ Sprite = Yoshi
    STA.W SpriteNumber,X                      ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #!SFX_YOSHI
    STA.W SPCIO3                              ; / Play sound effect
    LDA.B SpriteYPosLow,X
    SBC.B #$10
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.W SpriteOBJAttribute,X
    PHA                                       ; \ Reset sprite tables
    JSL InitSpriteTables                      ; |
    PLA                                       ; /
    AND.B #$FE
    STA.W SpriteOBJAttribute,X
    LDA.B #$0C
    STA.W SpriteMisc1602,X
    DEC.W SpriteMisc160E,X
    LDA.B #$40
    STA.W YoshiGrowingTimer
    RTS

CODE_01A2F4:
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    CMP.B #$05
    BNE CODE_01A300
    BRA CODE_01A2B5

CODE_01A300:
    JSL CODE_05B34A
    LDA.B #$01
    JSL GivePoints
CODE_01A30A:
    LDA.W SpriteMisc163E,X
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_01A35A,Y
    STA.W SpriteMisc1602,X
    STZ.B _1
    LDA.W SpriteMisc163E,X
    CMP.B #$20
    BCC CODE_01A34F
    SBC.B #$10
    LSR A
    LSR A
    LDY.W SpriteMisc157C,X
    BEQ +
    EOR.B #$FF
    INC A
    DEC.B _1
  + LDY.W SpriteMisc160E,X
    CLC
    ADC.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    ADC.B _1
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$02
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,Y
CODE_01A34F:
    JSR CODE_01A169
    JSR SubSprGfx2Entry1
    JSL CODE_02EA25
    RTS


DATA_01A35A:
    db $00,$03,$02,$02,$01,$01,$01

DATA_01A361:
    db $10,$20

DATA_01A363:
    db $01,$02

GetDrawInfoBnk1:
    STZ.W SpriteOffscreenVert,X
    STZ.W SpriteOffscreenX,X
    LDA.B SpriteXPosLow,X
    CMP.B Layer1XPos
    LDA.W SpriteXPosHigh,X
    SBC.B Layer1XPos+1
    BEQ +
    INC.W SpriteOffscreenX,X
  + LDA.W SpriteXPosHigh,X
    XBA
    LDA.B SpriteXPosLow,X
    REP #$20                                  ; A->16
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.W #$0040
    CMP.W #$0180
    SEP #$20                                  ; A->8
    ROL A
    AND.B #$01
    STA.W SpriteWayOffscreenX,X
    BNE CODE_01A3CB
    LDY.B #$00
    LDA.W SpriteStatus,X                      ; \ Branch if sprite status == Stunned
    CMP.B #$09                                ; |
    BEQ CODE_01A3A6                           ; /
    LDA.W SpriteTweakerF,X                    ; \ Branch if "Death frame 2 tiles high"
    AND.B #$20                                ; | is NOT set
    BEQ CODE_01A3A6                           ; /
    INY
CODE_01A3A6:
    LDA.B SpriteYPosLow,X
    CLC
    ADC.W DATA_01A361,Y
    PHP
    CMP.B Layer1YPos
    ROL.B _0
    PLP
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    LSR.B _0
    SBC.B Layer1YPos+1
    BEQ +
    LDA.W SpriteOffscreenVert,X
    ORA.W DATA_01A363,Y
    STA.W SpriteOffscreenVert,X
  + DEY
    BPL CODE_01A3A6
    BRA +

CODE_01A3CB:
    PLA
    PLA
  + LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    RTS

CODE_01A3DF:
    LDA.W SpriteOffscreenVert,X
    BEQ Return01A40A
    PHX
    LSR A
    BCC +
    PHA
    LDA.B #$01
    STA.W OAMTileSize+$40,Y
    TYA
    ASL A
    ASL A
    TAX
    LDA.B #$80
    STA.W OAMTileXPos+$100,X
    PLA
  + LSR A
    BCC +
    LDA.B #$01
    STA.W OAMTileSize+$41,Y
    TYA
    ASL A
    ASL A
    TAX
    LDA.B #$80
    STA.W OAMTileXPos+$104,X
  + PLX
Return01A40A:
    RTS


DATA_01A40B:
    db $02,$0A

SubSprSprInteract:
    TXA
    BEQ Return01A40A
    TAY
    EOR.B TrueFrame                           ; \ Return every other frame
    LSR A                                     ; |
    BCC Return01A40A                          ; /
    DEX
CODE_01A417:
    LDA.W SpriteStatus,X                      ; \ Jump to $01A4B0 if
    CMP.B #$08                                ; | sprite status < 8
    BCS +                                     ; |
    JMP CODE_01A4B0                           ; /

  + LDA.W SpriteTweakerE,X
    ORA.W SpriteTweakerE,Y
    AND.B #$08
    ORA.W SpriteMisc1564,X
    ORA.W SpriteMisc1564,Y
    ORA.W SpriteOnYoshiTongue,X
    ORA.W SpriteBehindScene,X
    EOR.W SpriteBehindScene,Y
    BNE CODE_01A4B0
    STX.W SpriteInterIndex
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    LDA.W SpriteXPosLow,Y
    STA.B _2
    LDA.W SpriteXPosHigh,Y
    STA.B _3
    REP #$20                                  ; A->16
    LDA.B _0
    SEC
    SBC.B _2
    CLC
    ADC.W #$0010
    CMP.W #$0020
    SEP #$20                                  ; A->8
    BCS CODE_01A4B0
    LDY.B #$00
    LDA.W SpriteTweakerB,X
    AND.B #$0F
    BEQ +
    INY
  + LDA.B SpriteYPosLow,X
    CLC
    ADC.W DATA_01A40B,Y
    STA.B _0
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _1
    LDY.W CurSpriteProcess                    ; Y = Sprite index
    LDX.B #$00
    LDA.W SpriteTweakerB,Y
    AND.B #$0F
    BEQ +
    INX
  + LDA.W SpriteYPosLow,Y
    CLC
    %LorW_X(ADC,DATA_01A40B)
    STA.B _2
    LDA.W SpriteYPosHigh,Y
    ADC.B #$00
    STA.B _3
    LDX.W SpriteInterIndex
    REP #$20                                  ; A->16
    LDA.B _0
    SEC
    SBC.B _2
    CLC
    ADC.W #$000C
    CMP.W #$0018
    SEP #$20                                  ; A->8
    BCS CODE_01A4B0
    JSR CODE_01A4BA
CODE_01A4B0:
    DEX
    BMI +
    JMP CODE_01A417

  + LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_01A4BA:
    LDA.W SpriteStatus,Y                      ; \ Branch if sprite 2 status == Normal
    CMP.B #$08                                ; |
    BEQ CODE_01A4CE                           ; /
    CMP.B #$09                                ; \ Branch if sprite 2 status == Carryable
    BEQ CODE_01A4E2                           ; /
    CMP.B #$0A                                ; \ Branch if sprite 2 status == Kicked
    BEQ CODE_01A506                           ; /
    CMP.B #$0B                                ; \ Branch if sprite 2 status == Carried
    BEQ CODE_01A51A                           ; /
    RTS

CODE_01A4CE:
    LDA.W SpriteStatus,X                      ; \ Branch if sprite status == Normal
    CMP.B #$08                                ; |
    BEQ CODE_01A53D                           ; /
    CMP.B #$09                                ; \ Branch if sprite status == Carryable
    BEQ CODE_01A540                           ; /
    CMP.B #$0A                                ; \ Branch if sprite status == Kicked
    BEQ CODE_01A537                           ; /
    CMP.B #$0B                                ; \ Branch if sprite status == Carried
    BEQ CODE_01A534                           ; /
    RTS

CODE_01A4E2:
    LDA.W SpriteBlockedDirs,Y                 ; \ Branch if on ground
    AND.B #$04                                ; |
    BNE CODE_01A4F2                           ; /
    LDA.W SpriteNumber,Y                      ; \ Branch if Goomba
    CMP.B #$0F                                ; |
    BEQ CODE_01A534                           ; /
    BRA CODE_01A506

CODE_01A4F2:
    LDA.W SpriteStatus,X                      ; \ Branch if sprite status == Normal
    CMP.B #$08                                ; |
    BEQ CODE_01A540                           ; /
    CMP.B #$09                                ; \ Branch if sprite status == Carryable
    BEQ CODE_01A555                           ; /
    CMP.B #$0A                                ; \ Branch if sprite status == Kicked
    BEQ ADDR_01A53A                           ; /
    CMP.B #$0B                                ; \ Branch if sprite status == Carried
    BEQ CODE_01A534                           ; /
    RTS

CODE_01A506:
    LDA.W SpriteStatus,X                      ; \ Branch if sprite status == Normal
    CMP.B #$08                                ; |
    BEQ CODE_01A52E                           ; /
    CMP.B #$09                                ; \ Branch if sprite status == Carryable
    BEQ CODE_01A531                           ; /
    CMP.B #$0A                                ; \ Branch if sprite status == Kicked
    BEQ CODE_01A534                           ; /
    CMP.B #$0B                                ; \ Branch if sprite status == Carried
    BEQ CODE_01A534                           ; /
    RTS

CODE_01A51A:
    LDA.W SpriteStatus,X                      ; \ Branch if sprite status == Normal
    CMP.B #$08                                ; |
    BEQ CODE_01A534                           ; /
    CMP.B #$09                                ; \ Branch if sprite status == Carryable
    BEQ CODE_01A534                           ; /
    CMP.B #$0A                                ; \ Branch if sprite status == Kicked
    BEQ CODE_01A534                           ; /
    CMP.B #$0B                                ; \ Branch if sprite status == Carried
    BEQ CODE_01A534                           ; /
    RTS

CODE_01A52E:
    JMP CODE_01A625

CODE_01A531:
    JMP CODE_01A642

CODE_01A534:
    JMP CODE_01A685

CODE_01A537:
    JMP CODE_01A5C4

ADDR_01A53A:
    JMP CODE_01A5C4

CODE_01A53D:
    JMP CODE_01A56D

CODE_01A540:
    JSR CODE_01A6D9
    PHX
    PHY
    TYA
    TXY
    TAX
    JSR CODE_01A6D9
    PLY
    PLX
    LDA.W SpriteMisc1558,X
    ORA.W SpriteMisc1558,Y
    BNE Return01A5C3
CODE_01A555:
    LDA.W SpriteStatus,X
    CMP.B #$09
    BNE CODE_01A56D
    JSR IsOnGround
    BNE CODE_01A56D
    LDA.B SpriteNumber,X                      ; \ Branch if not Goomba
    CMP.B #$0F                                ; |
    BNE +                                     ; /
    JMP CODE_01A685

  + JMP CODE_01A5C4

CODE_01A56D:
    LDA.B SpriteXPosLow,X
    SEC
    SBC.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    SBC.W SpriteXPosHigh,Y
    ROL A
    AND.B #$01
    STA.B _0
    LDA.W SpriteTweakerE,Y
    AND.B #$10
    BNE +
    LDY.W CurSpriteProcess                    ; Y = Sprite index
    LDA.W SpriteMisc157C,Y
    PHA
    LDA.B _0
    STA.W SpriteMisc157C,Y
    PLA
    CMP.W SpriteMisc157C,Y
    BEQ +
    LDA.W SpriteMisc15AC,Y
    BNE +
    LDA.B #$08                                ; \ Set turning timer
    STA.W SpriteMisc15AC,Y                    ; /
  + LDA.W SpriteTweakerE,X
    AND.B #$10
    BNE Return01A5C3
    LDA.W SpriteMisc157C,X
    PHA
    LDA.B _0
    EOR.B #$01
    STA.W SpriteMisc157C,X
    PLA
    CMP.W SpriteMisc157C,X
    BEQ Return01A5C3
    LDA.W SpriteMisc15AC,X
    BNE Return01A5C3
    LDA.B #$08                                ; \ Set turning timer
    STA.W SpriteMisc15AC,X                    ; /
Return01A5C3:
    RTS

CODE_01A5C4:
    LDA.W SpriteNumber,Y
    SEC
    SBC.B #$83
    CMP.B #$02
    BCS +
    JSR FlipSpriteDir
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
CODE_01A5D3:
    PHX
    TYX
    JSR CODE_01B4E2
    PLX
    RTS

  + LDX.W CurSpriteProcess                    ; X = Sprite index
    LDY.W SpriteInterIndex
    JSR CODE_01A77C
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,Y                      ; /
    PHX
    TYX
    JSL CODE_01AB72
    PLX
    LDA.B SpriteXSpeed,X
    ASL A
    LDA.B #$10
    BCC +
    LDA.B #$F0
  + STA.W SpriteXSpeed,Y
    LDA.B #$D0
    STA.W SpriteYSpeed,Y
    PHY
    INC.W SpriteMisc1626,X
    LDY.W SpriteMisc1626,X
    CPY.B #$08
    BCS +
    LDA.W StompSFX-1,Y
    STA.W SPCIO0                              ; / Play sound effect
  + TYA
    CMP.B #$08
    BCC +
    LDA.B #$08
  + PLY
    JSL CODE_02ACE1
Return01A61D:
    RTS

StompSFX:
    db !SFX_STOMP1
    db !SFX_STOMP2
    db !SFX_STOMP3
    db !SFX_STOMP4
    db !SFX_STOMP5
    db !SFX_STOMP6
    db !SFX_STOMP7

CODE_01A625:
    LDA.B SpriteNumber,X
    SEC
    SBC.B #$83
    CMP.B #$02
    BCS +
    PHX
    TYX
    JSR FlipSpriteDir
    PLX
    LDA.B #$00
    STA.W SpriteYSpeed,Y
    JSR CODE_01B4E2
    RTS

  + JSR CODE_01A77C
    BRA +

CODE_01A642:
    JSR IsOnGround
    BNE +
    JMP CODE_01A685

  + PHX
    LDA.W SpriteMisc1626,Y
    INC A
    STA.W SpriteMisc1626,Y
    LDX.W SpriteMisc1626,Y
    CPX.B #$08
    BCS +
    %LorW_X(LDA,StompSFX-1)
    STA.W SPCIO0                              ; / Play sound effect
  + TXA
    CMP.B #$08
    BCC +
    LDA.B #$08
  + PLX
    JSL GivePoints
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,X                      ; /
    JSL CODE_01AB72
    LDA.W SpriteXSpeed,Y
    ASL A
    LDA.B #$10
    BCC +
    LDA.B #$F0
  + STA.B SpriteXSpeed,X
    LDA.B #$D0
    STA.B SpriteYSpeed,X
    RTS

CODE_01A685:
    LDA.B SpriteNumber,X                      ; \ Branch if Flying Question Block
    CMP.B #$83                                ; |
    BEQ ADDR_01A69A                           ; |
    CMP.B #$84                                ; |
    BEQ ADDR_01A69A                           ; /
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,X                      ; /
    LDA.B #$D0
    STA.B SpriteYSpeed,X
    BRA +

ADDR_01A69A:
    JSR CODE_01B4E2
  + LDA.W SpriteNumber,Y                      ; \ Branch if Flying Question Block or Key
    CMP.B #$80                                ; |
    BEQ CODE_01A6BB                           ; |
    CMP.B #$83                                ; |
    BEQ ADDR_01A6B8                           ; |
    CMP.B #$84                                ; |
    BEQ ADDR_01A6B8                           ; /
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$D0
    STA.W SpriteYSpeed,Y
    BRA CODE_01A6BB

ADDR_01A6B8:
    JSR CODE_01A5D3
CODE_01A6BB:
    JSL CODE_01AB6F
    LDA.B #$04
    JSL GivePoints
    LDA.B SpriteXSpeed,X
    ASL A
    LDA.B #$10
    BCS +
    LDA.B #$F0
  + STA.B SpriteXSpeed,X
    EOR.B #$FF
    INC A
    STA.W SpriteXSpeed,Y
    RTS


DATA_01A6D7:
    db $30,$D0

CODE_01A6D9:
    STY.B _0
    JSR IsOnGround
    BEQ Return01A72D
    LDA.W SpriteBlockedDirs,Y                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ Return01A72D                          ; /
    LDA.W SpriteTweakerA,X                    ; \ Return if doesn't kick/hop into shells
    AND.B #$40                                ; |
    BEQ Return01A72D                          ; /
    LDA.W SpriteMisc1558,Y
    ORA.W SpriteMisc1558,X
    BNE Return01A72D
    STZ.B _2
    LDA.B SpriteXPosLow,X
    SEC
    SBC.W SpriteXPosLow,Y
    BMI +
    INC.B _2
  + CLC
    ADC.B #$08
    CMP.B #$10
    BCC Return01A72D
    LDA.W SpriteMisc157C,X
    CMP.B _2
    BNE Return01A72D
    LDA.B SpriteNumber,X                      ; \ Branch if not Blue Shelless
    CMP.B #$02                                ; |
    BNE +                                     ; /
    LDA.B #$20
    STA.W SpriteMisc163E,X
    STA.W SpriteMisc1558,X
    LDA.B #$23
    STA.W SpriteMisc1564,X
    TYA
    STA.W SpriteMisc160E,X
    RTS

PlayKickSfx:
    LDA.B #!SFX_KICK                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
Return01A72D:
    RTS

  + LDA.W SpriteMisc1540,Y                    ; \ Return if timer is set
    BNE Return01A777                          ; /
    LDA.W SpriteNumber,Y                      ; \ Return if sprite >= #$0F
    CMP.B #$0F                                ; |
    BCS Return01A777                          ; /
    LDA.W SpriteBlockedDirs,Y                 ; \ Return if not on ground
    AND.B #$04                                ; |
    BEQ Return01A777                          ; /
    LDA.W SpriteOBJAttribute,Y                ; \ Branch if $15F6,y positive...
    BPL +                                     ; /
    AND.B #$7F                                ; \ ...otherwise make it positive
    STA.W SpriteOBJAttribute,Y                ; /
    LDA.B #$E0                                ; \ Set upward speed
    STA.W SpriteYSpeed,Y                      ; /
    LDA.B #$20                                ; \ $1564,y = #$20
    STA.W SpriteMisc1564,Y                    ; /
CODE_01A755:
    LDA.B #$20                                ; \ C2,x and 1558,x = #$20
    STA.B SpriteTableC2,X                     ; | (These are for the shell sprite)
    STA.W SpriteMisc1558,X                    ; /
    RTS

  + LDA.B #$E0                                ; \ Set upward speed
    STA.B SpriteYSpeed,X                      ; /
    LDA.W SpriteInLiquid,X
    CMP.B #$01
    LDA.B #$18
    BCC +
    LDA.B #$2C
  + STA.W SpriteMisc1558,X
    TXA
    STA.W SpriteMisc1594,Y
    TYA
    STA.W SpriteMisc1594,X
Return01A777:
    RTS


DATA_01A778:
    db $10,$F0

DATA_01A77A:
    db $00,$FF

CODE_01A77C:
    LDA.B SpriteNumber,X
    CMP.B #$02
    BNE CODE_01A7C2
    LDA.W SpriteMisc187B,Y
    BNE CODE_01A7C2
    LDA.W SpriteMisc157C,X
    CMP.W SpriteMisc157C,Y
    BEQ CODE_01A7C2
    STY.B _1
    LDY.W SpriteMisc1534,X
    BNE +
    STZ.W SpriteMisc1528,X
    STZ.W SpriteMisc163E,X
    TAY
    STY.B _0
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_01A778,Y
    LDY.B _1
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    LDY.B _0
    ADC.W DATA_01A77A,Y
    LDY.B _1
    STA.W SpriteXPosHigh,Y
    TYA
    STA.W SpriteMisc160E,X
    LDA.B #$01
    STA.W SpriteMisc1534,X
  + PLA
    PLA
CODE_01A7C2:
    LDX.W SpriteInterIndex
    LDY.W CurSpriteProcess                    ; Y = Sprite index
    RTS


SpriteToSpawn:
    db $00,$01,$02,$03,$04,$05,$06,$07
    db $04,$04,$05,$05,$07,$00,$00,$0F
    db $0F,$0F

SpriteToSpawn2:
    db $0D

MarioSprInteract:
    PHB
    PHK
    PLB
    JSR MarioSprInteractRt
    PLB
    RTL

MarioSprInteractRt:
    LDA.W SpriteTweakerD,X                    ; \ Branch if "Process interaction every frame" is set
    AND.B #$20                                ; |
    BNE ProcessInteract                       ; /
    TXA                                       ; \ Otherwise, return every other frame
    EOR.B TrueFrame                           ; |
    AND.B #$01                                ; |
    ORA.W SpriteOffscreenX,X                  ; |
    BEQ ProcessInteract                       ; |
  - CLC                                       ; |
    RTS                                       ; /

ProcessInteract:
    JSR SubHorizPos
    LDA.B _F
    CLC
    ADC.B #$50
    CMP.B #$A0
    BCS -                                     ; No contact, return
    JSR CODE_01AD42
    LDA.B _E
    CLC
    ADC.B #$60
    CMP.B #$C0
    BCS -                                     ; No contact, return
CODE_01A80F:
    LDA.B PlayerAnimation                     ; \ If animation sequence activated...
    CMP.B #$01                                ; |
    BCS -                                     ; / ...no contact, return
    LDA.B #$00                                ; \ Branch if bit 6 of $0D9B set?
    BIT.W IRQNMICommand                       ; |
    BVS +                                     ; /
    LDA.W PlayerBehindNet                     ; \ If Mario and Sprite not on same side of scenery...
    EOR.W SpriteBehindScene,X                 ; |
  + BNE ReturnNoContact2                      ; / ...no contact, return
    JSL GetMarioClipping
    JSL GetSpriteClippingA
    JSL CheckForContact
    BCC ReturnNoContact2                      ; No contact, return
    LDA.W SpriteTweakerD,X                    ; \ Branch if sprite uses default Mario interaction
    BPL +                                     ; /
    SEC                                       ; Contact, return
    RTS


DATA_01A839:
    db $F0,$10

  + LDA.W InvinsibilityTimer                  ; \ Branch if Mario doesn't have star
    BEQ CODE_01A87E                           ; /
    LDA.W SpriteTweakerD,X                    ; \ Branch if "Process interaction every frame" is set
    AND.B #$02                                ; |
    BNE CODE_01A87E                           ; /
CODE_01A847:
    JSL CODE_01AB6F
    INC.W StarKillCounter
    LDA.W StarKillCounter
    CMP.B #$08
    BCC +
    LDA.B #$08
    STA.W StarKillCounter
  + JSL GivePoints
    LDY.W StarKillCounter
    CPY.B #$08
    BCS +
    LDA.W StompSFX-1,Y
    STA.W SPCIO0                              ; / Play sound effect
  + LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,X                      ; /
    LDA.B #$D0
    STA.B SpriteYSpeed,X
    JSR SubHorizPos
    LDA.W DATA_01A839,Y
    STA.B SpriteXSpeed,X
ReturnNoContact2:
    CLC
    RTS

CODE_01A87E:
    STZ.W StarKillCounter
    LDA.W SpriteMisc154C,X
    BNE CODE_01A895
    LDA.B #$08
    STA.W SpriteMisc154C,X
    LDA.W SpriteStatus,X
    CMP.B #$09
    BNE +
    JSR CODE_01AA42
CODE_01A895:
    CLC
    RTS

  + LDA.B #$14
    STA.B _1
    LDA.B _5
    SEC
    SBC.B _1
    ROL.B _0
    CMP.B PlayerYPosNow
    PHP
    LSR.B _0
    LDA.B _B
    SBC.B #$00
    PLP
    SBC.B PlayerYPosNow+1
    BMI CODE_01A8E6
    LDA.B PlayerYSpeed+1
    BPL CODE_01A8C0
    LDA.W SpriteTweakerF,X                    ; \ TODO: Branch if Unknown Bit 11 is set
    AND.B #$10                                ; |
    BNE CODE_01A8C0                           ; /
    LDA.W SpriteStompCounter
    BEQ CODE_01A8E6
CODE_01A8C0:
    JSR IsOnGround
    BEQ CODE_01A8C9
    LDA.B PlayerInAir
    BEQ CODE_01A8E6
CODE_01A8C9:
    LDA.W SpriteTweakerA,X                    ; \ Branch if can be jumped on
    AND.B #$10                                ; |
    BNE CODE_01A91C                           ; /
    LDA.W SpinJumpFlag
    ORA.W PlayerRidingYoshi
    BEQ CODE_01A8E6
CODE_01A8D8:
    LDA.B #!SFX_SPLAT
    STA.W SPCIO0                              ; / Play sound effect
    JSL BoostMarioSpeed
    JSL DisplayContactGfx
    RTS

CODE_01A8E6:
    LDA.W PlayerSlopePose
    BEQ +
    LDA.W SpriteTweakerF,X                    ; \ Branch if "Takes 5 fireballs to kill"...
    AND.B #$04                                ; | ...is set
    BNE +                                     ; /
    JSR PlayKickSfx
    JSR CODE_01A847
    RTS

  + LDA.W IFrameTimer                         ; \ Return if Mario is invincible
    BNE Return01A91B                          ; /
    LDA.W PlayerRidingYoshi
    BNE Return01A91B
    LDA.W SpriteTweakerE,X
    AND.B #$10
    BNE +
    JSR SubHorizPos
    TYA
    STA.W SpriteMisc157C,X
  + LDA.B SpriteNumber,X
    CMP.B #$53
    BEQ Return01A91B
    JSL HurtMario
Return01A91B:
    RTS

CODE_01A91C:
    LDA.W SpinJumpFlag
    ORA.W PlayerRidingYoshi
    BEQ CODE_01A947
CODE_01A924:
    JSL DisplayContactGfx
    LDA.B #$F8
    STA.B PlayerYSpeed+1
    LDA.W PlayerRidingYoshi
    BEQ +
    JSL BoostMarioSpeed
  + JSR CODE_019ACB
    JSL CODE_07FC3B
    JSR CODE_01AB46
    LDA.B #!SFX_SPINKILL
    STA.W SPCIO0                              ; / Play sound effect
    JMP CODE_01A9F2

CODE_01A947:
    JSR CODE_01A8D8
    LDA.W SpriteMisc187B,X
    BEQ CODE_01A95D
    JSR SubHorizPos
    LDA.B #$18
    CPY.B #$00
    BEQ +
    LDA.B #$E8
  + STA.B PlayerXSpeed+1
    RTS

CODE_01A95D:
    JSR CODE_01AB46
    LDY.B SpriteNumber,X
    LDA.W SpriteTweakerE,X
    AND.B #$40
    BEQ CODE_01A9BE
    CPY.B #$72
    BCC CODE_01A979
    PHX
    PHY
    JSL CODE_02EAF2
    PLY
    PLX
    LDA.B #$02
    BRA CODE_01A99B

CODE_01A979:
    CPY.B #$6E
    BNE CODE_01A98A
    LDA.B #$02
    STA.B SpriteTableC2,X
    LDA.B #$FF
    STA.W SpriteMisc1540,X
    LDA.B #$6F                                ;DINO TORCH SPRITE NUM
    BRA CODE_01A99B

CODE_01A98A:
    CPY.B #$3F
    BCC CODE_01A998
    LDA.B #$80
    STA.W SpriteMisc1540,X
    LDA.W SpriteToSpawn2-$40,Y                ; Hey, this label might be wrong!
    BRA CODE_01A99B

CODE_01A998:
    LDA.W SpriteToSpawn,Y
CODE_01A99B:
    STA.B SpriteNumber,X
    LDA.W SpriteOBJAttribute,X
    AND.B #$0E
    STA.B _F
    JSL LoadSpriteTables
    LDA.W SpriteOBJAttribute,X
    AND.B #$F1
    ORA.B _F
    STA.W SpriteOBJAttribute,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.B SpriteNumber,X
    CMP.B #$02
    BNE +
    INC.W SpriteMisc151C,X
  + RTS

CODE_01A9BE:
    LDA.B SpriteNumber,X
    SEC
    SBC.B #$04
    CMP.B #$0D
    BCS CODE_01A9CC
    LDA.W FlightPhase
    BNE CODE_01A9D3
CODE_01A9CC:
    LDA.W SpriteTweakerA,X                    ; \ Branch if doesn't die when jumped on
    AND.B #$20                                ; |
    BEQ +                                     ; /
CODE_01A9D3:
    LDA.B #$03                                ; \ Sprite status = Smushed
    STA.W SpriteStatus,X                      ; /
    LDA.B #$20
    STA.W SpriteMisc1540,X
    STZ.B SpriteXSpeed,X                      ; \ Sprite Speed = 0
    STZ.B SpriteYSpeed,X                      ; /
    RTS

  + LDA.W SpriteTweakerB,X                    ; \ Branch if Tweaker bit...
    AND.B #$80                                ; | ..."Falls straight down when killed"...
    BEQ CODE_01AA01                           ; / ...is NOT set.
    LDA.B #$02                                ; \ Sprite status = Falling off screen
    STA.W SpriteStatus,X                      ; /
    STZ.B SpriteXSpeed,X                      ; \ Sprite Speed = 0
    STZ.B SpriteYSpeed,X                      ; /
CODE_01A9F2:
    LDA.B SpriteNumber,X                      ; \ Return if NOT Lakitu
    CMP.B #$1E                                ; |
    BNE +                                     ; /
    LDY.W LakituCloudSlot
    LDA.B #$1F
    STA.W SpriteMisc1540,Y
  + RTS

CODE_01AA01:
    LDY.W SpriteStatus,X
    STZ.W SpriteMisc1626,X
    CPY.B #$08
    BEQ SetStunnedTimer
CODE_01AA0B:
    LDA.B SpriteTableC2,X
    BNE SetStunnedTimer
    STZ.W SpriteMisc1540,X
    BRA SetAsStunned

SetStunnedTimer:
    LDA.B #$02                                ; \
    LDY.B SpriteNumber,X                      ; |
    CPY.B #$0F                                ; | Set stunnned timer with:
    BEQ CODE_01AA28                           ; |
    CPY.B #$11                                ; | #$FF for Goomba, Buzzy Beetle, Mechakoopa, or Bob-omb...
    BEQ CODE_01AA28                           ; | #$02 for others
    CPY.B #$A2                                ; |
    BEQ CODE_01AA28                           ; |
    CPY.B #$0D                                ; |
    BNE +                                     ; |
CODE_01AA28:
    LDA.B #$FF                                ; |
  + STA.W SpriteMisc1540,X                    ; /
SetAsStunned:
    LDA.B #$09                                ; \ Status = stunned
    STA.W SpriteStatus,X                      ; /
    RTS

BoostMarioSpeed:
    LDA.B PlayerIsClimbing                    ; \ Return if climbing
    BNE Return01AA41                          ; /
    LDA.B #$D0
    BIT.B byetudlrHold
    BPL +
    LDA.B #$A8
  + STA.B PlayerYSpeed+1
Return01AA41:
    RTL

CODE_01AA42:
    LDA.W SpinJumpFlag
    ORA.W PlayerRidingYoshi
    BEQ +
    LDA.B PlayerYSpeed+1
    BMI +
    LDA.W SpriteTweakerA,X                    ; \ Branch if can't be jumped on
    AND.B #$10                                ; |
    BEQ +                                     ; /
    JMP CODE_01A924

  + %WorB(LDA,byetudlrHold)
    AND.B #$40
    BEQ +
    LDA.W CarryingFlag                        ; \ Branch if carrying an enemy...
    ORA.W PlayerRidingYoshi                   ; | ...or on Yoshi
    BNE +                                     ; /
    LDA.B #$0B                                ; \ Sprite status = Being carried
    STA.W SpriteStatus,X                      ; /
    INC.W CarryingFlag                        ; Set carrying enemy flag
    LDA.B #$08
    STA.W PickUpItemTimer
    RTS

  + LDA.B SpriteNumber,X                      ; \ Branch if Key
    CMP.B #$80                                ; |
    BEQ CODE_01AAB7                           ; /
    CMP.B #$3E                                ; \ Branch if P Switch
    BEQ CODE_01AAB2                           ; /
    CMP.B #$0D                                ; \ Branch if Bobomb
    BEQ CODE_01AA97                           ; /
    CMP.B #$2D                                ; \ Branch if Baby Yoshi
    BEQ CODE_01AA97                           ; /
    CMP.B #$A2                                ; \ Branch if MechaKoopa
    BEQ CODE_01AA97                           ; /
    CMP.B #$0F                                ; \ Branch if not Goomba
    BNE CODE_01AA94                           ; /
    LDA.B #$F0
    STA.B SpriteYSpeed,X
    BRA CODE_01AA97

CODE_01AA94:
    JSR CODE_01AB46
CODE_01AA97:
    JSR PlayKickSfx
    LDA.W SpriteMisc1540,X
    STA.B SpriteTableC2,X
    LDA.B #$0A                                ; \ Sprite status = Kicked
    STA.W SpriteStatus,X                      ; /
    LDA.B #$10
    STA.W SpriteMisc154C,X
    JSR SubHorizPos
    LDA.W ShellSpeedX,Y
    STA.B SpriteXSpeed,X
    RTS

CODE_01AAB2:
    LDA.W SpriteMisc163E,X
    BNE Return01AB2C
CODE_01AAB7:
    STZ.W SpriteMisc154C,X
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B PlayerYPosNow
    CLC
    ADC.B #$08
    CMP.B #$20
    BCC CODE_01AB31
    BPL +
    LDA.B #$10
    STA.B PlayerYSpeed+1
    RTS

  + LDA.B PlayerYSpeed+1
    BMI Return01AB2C
    STZ.B PlayerYSpeed+1
    STZ.B PlayerInAir
    INC.W StandOnSolidSprite
    LDA.B #$1F
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$2F
  + STA.B _0
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B _0
    STA.B PlayerYPosNext
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.B PlayerYPosNext+1
    LDA.B SpriteNumber,X
    CMP.B #$3E
    BNE Return01AB2C
    ASL.W SpriteTweakerD,X
    LSR.W SpriteTweakerD,X
    LDA.B #!SFX_SWITCH
    STA.W SPCIO0                              ; / Play sound effect
    LDA.W MusicBackup
    BMI +
    LDA.B #!BGM_PSWITCH
    STA.W SPCIO2                              ; / Change music
  + LDA.B #$20
    STA.W SpriteMisc163E,X
    LSR.W SpriteOBJAttribute,X
    ASL.W SpriteOBJAttribute,X
    LDY.W SpriteMisc151C,X
    LDA.B #$B0
    STA.W BluePSwitchTimer,Y
    LDA.B #$20                                ; \ Set ground shake timer
    STA.W ScreenShakeTimer                    ; /
    CPY.B #$01
    BNE Return01AB2C
    JSL CODE_02B9BD
Return01AB2C:
    RTS


DATA_01AB2D:
    db $01,$00,$FF,$FF

CODE_01AB31:
    STZ.B PlayerXSpeed+1
    JSR SubHorizPos
    TYA
    ASL A
    TAY
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    CLC
    ADC.W DATA_01AB2D,Y
    STA.B PlayerXPosNext
    SEP #$20                                  ; A->8
    RTS

CODE_01AB46:
    PHY
    LDA.W SpriteStompCounter
    CLC
    ADC.W SpriteMisc1626,X
    INC.W SpriteStompCounter
    TAY
    INY
    CPY.B #$08
    BCS +
    LDA.W StompSFX-1,Y
    STA.W SPCIO0                              ; / Play sound effect
  + TYA
    CMP.B #$08
    BCC +
    LDA.B #$08
  + JSL GivePoints
    PLY
    RTS


    db $0C,$FC,$EC,$DC,$CC

CODE_01AB6F:
    JSR PlayKickSfx
CODE_01AB72:
    JSR IsSprOffScreen
    BNE Return01AB98
    PHY
    LDY.B #$03
CODE_01AB7A:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_01AB83
    DEY
    BPL CODE_01AB7A
    INY
CODE_01AB83:
    LDA.B #$02
    STA.W SmokeSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SmokeSpriteXPos,Y
    LDA.B SpriteYPosLow,X
    STA.W SmokeSpriteYPos,Y
    LDA.B #$08
    STA.W SmokeSpriteTimer,Y
    PLY
Return01AB98:
    RTL

DisplayContactGfx:
    JSR IsSprOffScreen
    BNE Return01ABCB
    PHY
    LDY.B #$03
CODE_01ABA1:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_01ABAA
    DEY
    BPL CODE_01ABA1
    INY
CODE_01ABAA:
    LDA.B #$02
    STA.W SmokeSpriteNumber,Y
    LDA.B PlayerXPosNext
    STA.W SmokeSpriteXPos,Y
    LDA.W PlayerRidingYoshi
    CMP.B #$01
    LDA.B #$14
    BCC +
    LDA.B #$1E
  + CLC
    ADC.B PlayerYPosNext
    STA.W SmokeSpriteYPos,Y
    LDA.B #$08
    STA.W SmokeSpriteTimer,Y
    PLY
Return01ABCB:
    RTL

SubSprXPosNoGrvty:
    TXA
    CLC
    ADC.B #$0C
    TAX
    JSR SubSprYPosNoGrvty
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

SubSprYPosNoGrvty:
    LDA.B SpriteYSpeed,X                      ; Load current sprite's Y speed
    BEQ CODE_01AC09                           ; If speed is 0, branch to $AC09
    ASL A                                     ; \
    ASL A                                     ; |Multiply speed by 16
    ASL A                                     ; |
    ASL A                                     ; /
    CLC                                       ; \
    ADC.W SpriteYPosSpx,X                     ; |Increase (unknown sprite table) by that value
    STA.W SpriteYPosSpx,X                     ; /
    PHP
    PHP
    LDY.B #$00
    LDA.B SpriteYSpeed,X                      ; Load current sprite's Y speed
    LSR A                                     ; \
    LSR A                                     ; |Multiply speed by 16
    LSR A                                     ; |
    LSR A                                     ; /
    CMP.B #$08
    BCC +
    ORA.B #$F0
    DEY
  + PLP
    PHA
    ADC.B SpriteYPosLow,X                     ; \ Add value to current sprite's Y position
    STA.B SpriteYPosLow,X                     ; /
    TYA
    ADC.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,X
    PLA
    PLP
    ADC.B #$00
CODE_01AC09:
    STA.W SpriteXMovement
    RTS


SpriteOffScreen1:
    db $40,$B0

SpriteOffScreen2:
    db $01,$FF

SpriteOffScreen3:
    db $30,$C0,$A0,$C0,$A0,$F0,$60,$90
SpriteOffScreen4:
    db $01,$FF,$01,$FF,$01,$FF,$01,$FF

SubOffscreen3Bnk1:
    LDA.B #$06                                ; \ Entry point of routine determines value of $03
    STA.B _3                                  ; |
    BRA +                                     ; |

SubOffscreen2Bnk1:
    LDA.B #$04                                ; |
    BRA +                                     ; |

SubOffscreen1Bnk1:
    LDA.B #$02                                ; |
  + STA.B _3                                  ; |
    BRA +                                     ; |

SubOffscreen0Bnk1:
    STZ.B _3                                  ; /
  + JSR IsSprOffScreen                        ; \ if sprite is not off screen, return
    BEQ Return01ACA4                          ; /
    LDA.B ScreenMode                          ; \  vertical level
    AND.B #!ScrMode_Layer1Vert                ; |
    BNE VerticalLevel                         ; /
    LDA.B SpriteYPosLow,X                     ; \
    CLC                                       ; |
    ADC.B #$50                                ; | if the sprite has gone off the bottom of the level...
    LDA.W SpriteYPosHigh,X                    ; | (if adding 0x50 to the sprite y position would make the high byte >= 2)
    ADC.B #$00                                ; |
    CMP.B #$02                                ; |
    BPL OffScrEraseSprite                     ; /    ...erase the sprite
    LDA.W SpriteTweakerD,X                    ; \ if "process offscreen" flag is set, return
    AND.B #$04                                ; |
    BNE Return01ACA4                          ; /
    LDA.B TrueFrame
    AND.B #$01
    ORA.B _3
    STA.B _1
    TAY
    LDA.B Layer1XPos
    CLC
    ADC.W SpriteOffScreen3,Y
    ROL.B _0
    CMP.B SpriteXPosLow,X
    PHP
    LDA.B Layer1XPos+1
    LSR.B _0
    ADC.W SpriteOffScreen4,Y
    PLP
    SBC.W SpriteXPosHigh,X
    STA.B _0
    LSR.B _1
    BCC +
    EOR.B #$80
    STA.B _0
  + LDA.B _0
    BPL Return01ACA4
OffScrEraseSprite:
    LDA.B SpriteNumber,X                      ; \ If MagiKoopa...
    CMP.B #$1F                                ; |
    BNE +                                     ; | Sprite to respawn = MagiKoopa
    STA.W SpriteRespawnNumber                 ; |
    LDA.B #$FF                                ; | Set timer until respawn
    STA.W SpriteRespawnTimer                  ; /
  + LDA.W SpriteStatus,X                      ; \ If sprite status < 8, permanently erase sprite
    CMP.B #$08                                ; |
    BCC +                                     ; /
    LDY.W SpriteLoadIndex,X                   ; \ Branch if should permanently erase sprite
    CPY.B #$FF                                ; |
    BEQ +                                     ; /
    LDA.B #$00                                ; \ Allow sprite to be reloaded by level loading routine
    STA.W SpriteLoadStatus,Y                  ; /
  + STZ.W SpriteStatus,X                      ; Erase sprite
Return01ACA4:
    RTS

VerticalLevel:
    LDA.W SpriteTweakerD,X                    ; \ If "process offscreen" flag is set, return
    AND.B #$04                                ; |
    BNE Return01ACA4                          ; /
    LDA.B TrueFrame                           ; \ Return every other frame
    LSR A                                     ; |
    BCS Return01ACA4                          ; /
    LDA.B SpriteXPosLow,X                     ; \
    CMP.B #$00                                ; | If the sprite has gone off the side of the level...
    LDA.W SpriteXPosHigh,X                    ; |
    SBC.B #$00                                ; |
    CMP.B #$02                                ; |
    BCS OffScrEraseSprite                     ; /  ...erase the sprite
    LDA.B TrueFrame
    LSR A
    AND.B #$01
    STA.B _1
    TAY
    BEQ CODE_01ACD2
    LDA.B SpriteNumber,X                      ; \ Return if Green Net Koopa
    CMP.B #$22                                ; |
    BEQ Return01ACA4                          ; |
    CMP.B #$24                                ; |
    BEQ Return01ACA4                          ; /
CODE_01ACD2:
    LDA.B Layer1YPos
    CLC
    ADC.W SpriteOffScreen1,Y
    ROL.B _0
    CMP.B SpriteYPosLow,X
    PHP
    LDA.W Layer1YPos+1
    LSR.B _0
    ADC.W SpriteOffScreen2,Y
    PLP
    SBC.W SpriteYPosHigh,X
    STA.B _0
    LDY.B _1
    BEQ +
    EOR.B #$80
    STA.B _0
  + LDA.B _0
    BPL Return01ACA4
    BMI OffScrEraseSprite
GetRand:
    PHY
    LDY.B #$01
    JSL CODE_01AD07
    DEY
    JSL CODE_01AD07
    PLY
    RTL

CODE_01AD07:
    LDA.W RNGCalc
    ASL A
    ASL A
    SEC
    ADC.W RNGCalc
    STA.W RNGCalc
    ASL.W RNGCalc+1
    LDA.B #$20
    BIT.W RNGCalc+1
    BCC CODE_01AD21
    BEQ CODE_01AD26
    BNE CODE_01AD23
CODE_01AD21:
    BNE CODE_01AD26
CODE_01AD23:
    INC.W RNGCalc+1
CODE_01AD26:
    LDA.W RNGCalc+1
    EOR.W RNGCalc
    STA.W RandomNumber,Y
    RTL

SubHorizPos:
    LDY.B #$00
    LDA.B PlayerXPosNow
    SEC
    SBC.B SpriteXPosLow,X
    STA.B _F
    LDA.B PlayerXPosNow+1
    SBC.W SpriteXPosHigh,X
    BPL +
    INY
  + RTS

CODE_01AD42:
    LDY.B #$00
    LDA.B PlayerYPosNow
    SEC
    SBC.B SpriteYPosLow,X
    STA.B _E
    LDA.B PlayerYPosNow+1
    SBC.W SpriteYPosHigh,X
    BPL +
    INY
  + RTS

    %insert_empty($02,$05,$05,$05,$00)

InitFlying_Block:
    LDA.B SpriteXPosLow,X
    LSR A
    LSR A
    LSR A
    LSR A
    AND.B #$03
    STA.W SpriteMisc151C,X
    INC.W SpriteMisc157C,X
    RTS


DATA_01AD68:
    db $FF,$01

DATA_01AD6A:
    db $F4,$0C

DATA_01AD6C:
    db $F0,$10

Flying_Block:
    LDA.W SpriteMisc163E,X
    BEQ +
    STZ.W SpriteOAMIndex,X
    LDA.W PlayerRidingYoshi
    BNE +
    LDA.B #$04
    STA.W SpriteOAMIndex,X
  + JSR SubSprGfx2Entry1
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileYPos+$100,Y
    DEC A
    STA.W OAMTileYPos+$100,Y
    STZ.W SpriteMisc1528,X
    LDA.B SpriteTableC2,X
    BNE CODE_01ADF8
    JSR CODE_019E95
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01ADF8                           ; /
    LDA.B TrueFrame
    AND.B #$01
    BNE +
    LDA.W SpriteMisc1594,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W DATA_01AD68,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_01AD6A,Y
    BNE +
    INC.W SpriteMisc1594,X
  + JSR SubSprYPosNoGrvty
    LDA.B SpriteNumber,X
    CMP.B #$83
    BEQ CODE_01ADE8
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B TrueFrame
    AND.B #$03
    BNE +
    LDA.W SpriteMisc1534,X
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X
    CLC
    ADC.W DATA_01AD68,Y
    STA.B SpriteXSpeed,X
    CMP.W DATA_01AD6C,Y
    BNE +
    INC.W SpriteMisc1534,X
    LDA.B #$20
    STA.W SpriteMisc1540,X
  + BRA +

CODE_01ADE8:
    LDA.B #$F4
    STA.B SpriteXSpeed,X
  + JSR SubSprXPosNoGrvty
    LDA.W SpriteXMovement
    STA.W SpriteMisc1528,X
    INC.W SpriteMisc1570,X
CODE_01ADF8:
    JSR SubSprSprInteract
    JSR CODE_01B457
    JSR SubOffscreen0Bnk1
    LDA.W SpriteMisc1558,X
    CMP.B #$08
    BNE CODE_01AE5E
    LDY.B SpriteTableC2,X
    CPY.B #$02
    BEQ CODE_01AE5E
    PHA
    INC.B SpriteTableC2,X
    LDA.B #$50
    STA.W SpriteMisc163E,X
    LDA.B SpriteXPosLow,X
    STA.B TouchBlockXPos
    LDA.W SpriteXPosHigh,X
    STA.B TouchBlockXPos+1
    LDA.B SpriteYPosLow,X
    STA.B TouchBlockYPos
    LDA.W SpriteYPosHigh,X
    STA.B TouchBlockYPos+1
    LDA.B #$FF                                ; \ Set to permanently erase sprite
    STA.W SpriteLoadIndex,X                   ; /
    LDY.W SpriteMisc151C,X
    LDA.B Powerup
    BNE +
    INY
    INY
    INY
    INY
  + LDA.W DATA_01AE88,Y
    STA.B _5
    PHB
    LDA.B #$02
    PHA
    PLB
    PHX
    JSL CODE_02887D
    PLX
    LDY.W TileGenerateTrackA
    LDA.B #$01
    STA.W SpriteMisc1528,Y
    LDA.W SpriteNumber,Y
    CMP.B #$75
    BNE +
    LDA.B #$FF
    STA.W SpriteTableC2,Y
  + PLB
    PLA
CODE_01AE5E:
    LSR A
    TAY
    LDA.W DATA_01AE7F,Y
    STA.B _0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileYPos+$100,Y
    SEC
    SBC.B _0
    STA.W OAMTileYPos+$100,Y
    LDA.B SpriteTableC2,X
    CMP.B #$01
    LDA.B #$2A
    BCC +
    LDA.B #$2E
  + STA.W OAMTileNo+$100,Y
    RTS


DATA_01AE7F:
    db $00,$03,$05,$07,$08,$08,$07,$05
    db $03

DATA_01AE88:
    db $06,$02,$04,$05,$06,$01,$01,$05

Return01AE90:
    RTS

PalaceSwitch:
    JSL CODE_02CD2D
    RTS

InitThwomp:
    LDA.B SpriteYPosLow,X
    STA.W SpriteMisc151C,X
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$08
    STA.B SpriteXPosLow,X
Return01AEA2:
    RTS

Thwomp:
    JSR ThwompGfx
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return01AEA2
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return01AEA2                          ; /
    JSR SubOffscreen0Bnk1
    JSR MarioSprInteractRt
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_01AEC3
    dw CODE_01AEFA
    dw CODE_01AF24

CODE_01AEC3:
    LDA.W SpriteOffscreenVert,X
    BNE CODE_01AEEE
    LDA.W SpriteOffscreenX,X
    BNE Return01AEF9
    JSR SubHorizPos
    TYA
    STA.W SpriteMisc157C,X
    STZ.W SpriteMisc1528,X
    LDA.B _F
    CLC
    ADC.B #$40
    CMP.B #$80
    BCS +
    LDA.B #$01
    STA.W SpriteMisc1528,X
  + LDA.B _F
    CLC
    ADC.B #$24
    CMP.B #$50
    BCS Return01AEF9
CODE_01AEEE:
    LDA.B #$02
    STA.W SpriteMisc1528,X
    INC.B SpriteTableC2,X
    LDA.B #$00
    STA.B SpriteYSpeed,X
Return01AEF9:
    RTS

CODE_01AEFA:
    JSR SubSprYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CMP.B #$3E
    BCS +
    ADC.B #$04
    STA.B SpriteYSpeed,X
  + JSR CODE_019140
    JSR IsOnGround
    BEQ +
    JSR SetSomeYSpeed__
    LDA.B #$18                                ; \ Set ground shake timer
    STA.W ScreenShakeTimer                    ; /
    LDA.B #!SFX_KAPOW
    STA.W SPCIO3                              ; / Play sound effect
    LDA.B #$40
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + RTS

CODE_01AF24:
    LDA.W SpriteMisc1540,X
    BNE Return01AF3F
    STZ.W SpriteMisc1528,X
    LDA.B SpriteYPosLow,X
    CMP.W SpriteMisc151C,X
    BNE +
    LDA.B #$00
    STA.B SpriteTableC2,X
    RTS

  + LDA.B #$F0
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty
Return01AF3F:
    RTS


ThwompDispX:
    db $FC,$04,$FC,$04,$00

ThwompDispY:
    db $00,$00,$10,$10,$08

ThwompTiles:
    db $8E,$8E,$AE,$AE,$C8

ThwompGfxProp:
    db $03,$43,$03,$43,$03

ThwompGfx:
    JSR GetDrawInfoBnk1
    LDA.W SpriteMisc1528,X
    STA.B _2
    PHX
    LDX.B #$03
    CMP.B #$00
    BEQ CODE_01AF64
    INX
CODE_01AF64:
    LDA.B _0
    CLC
    ADC.W ThwompDispX,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W ThwompDispY,X
    STA.W OAMTileYPos+$100,Y
    LDA.W ThwompGfxProp,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDA.W ThwompTiles,X
    CPX.B #$04
    BNE CODE_01AF8F
    PHX
    LDX.B _2
    CPX.B #$02
    BNE +
    LDA.B #$CA
  + PLX
CODE_01AF8F:
    STA.W OAMTileNo+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_01AF64
    PLX
    LDA.B #$04
    JMP CODE_01B37E

Thwimp:
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE CODE_01B006
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01B006                           ; /
    JSR SubOffscreen0Bnk1
    JSR MarioSprInteractRt
    JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
    JSR CODE_019140
    LDA.B SpriteYSpeed,X
    BMI CODE_01AFC3
    CMP.B #$40
    BCS CODE_01AFC8
    ADC.B #$05
CODE_01AFC3:
    CLC
    ADC.B #$03
    BRA +

CODE_01AFC8:
    LDA.B #$40
  + STA.B SpriteYSpeed,X
    JSR IsTouchingCeiling                     ; \ If touching ceiling,
    BEQ +                                     ; |
    LDA.B #$10                                ; | Y speed = #$10
    STA.B SpriteYSpeed,X                      ; /
  + JSR IsOnGround
    BEQ CODE_01B006
    JSR SetSomeYSpeed__
    STZ.B SpriteXSpeed,X                      ; \ Sprite Speed = 0
    STZ.B SpriteYSpeed,X                      ; /
    LDA.W SpriteMisc1540,X
    BEQ CODE_01AFFC
    DEC A
    BNE CODE_01B006
    LDA.B #$A0
    STA.B SpriteYSpeed,X
    INC.B SpriteTableC2,X
    LDA.B SpriteTableC2,X
    LSR A
    LDA.B #$10
    BCC +
    LDA.B #$F0
  + STA.B SpriteXSpeed,X
    BRA CODE_01B006

CODE_01AFFC:
    LDA.B #!SFX_BONK
    STA.W SPCIO0                              ; / Play sound effect
    LDA.B #$40
    STA.W SpriteMisc1540,X
CODE_01B006:
    LDA.B #$01
    JMP SubSprGfx0Entry0

InitVerticalFish:
    JSR FaceMario
    INC.W SpriteMisc151C,X
Return01B011:
    RTS


DATA_01B012:
    db $10,$F0

InitFish:
    JSR SubHorizPos
    LDA.W DATA_01B012,Y
    STA.B SpriteXSpeed,X
    RTS


DATA_01B01D:
    db $08,$F8

DATA_01B01F:
    db $00,$00,$08,$F8

DATA_01B023:
    db $F0,$10

DATA_01B025:
    db $E0,$E8,$D0,$D8

DATA_01B029:
    db $08,$F8,$10,$F0,$04,$FC,$14,$EC
DATA_01B031:
    db $03,$0C

Fish:
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE CODE_01B03E
    LDA.B SpriteLock
    BEQ +
CODE_01B03E:
    JMP CODE_01B10A

  + JSR SetAnimationFrame
    LDA.W SpriteInLiquid,X
    BNE CODE_01B0A7
    JSR SubUpdateSprPos
    JSR IsTouchingObjSide
    BEQ +
    JSR FlipSpriteDir
  + JSR IsOnGround
    BEQ CODE_01B09C
    LDA.W SpriteBuoyancy
    BEQ +
    JSL CODE_0284BC
  + JSL GetRand
    ADC.B TrueFrame
    AND.B #$07
    TAY
    LDA.W DATA_01B029,Y
    STA.B SpriteXSpeed,X
    JSL GetRand
    LDA.W RandomNumber+1
    AND.B #$03
    TAY
    LDA.W DATA_01B025,Y
    STA.B SpriteYSpeed,X
    LDA.W RandomNumber
    AND.B #$40
    BNE +
    LDA.W SpriteOBJAttribute,X
    EOR.B #$80
    STA.W SpriteOBJAttribute,X
  + JSL GetRand
    LDA.W RandomNumber
    AND.B #$80
    BNE CODE_01B09C
    JSR UpdateDirection
CODE_01B09C:
    LDA.W SpriteMisc1602,X
    CLC
    ADC.B #$02
    STA.W SpriteMisc1602,X
    BRA CODE_01B0EA

CODE_01B0A7:
    JSR CODE_019140
    JSR UpdateDirection
    ASL.W SpriteOBJAttribute,X
    LSR.W SpriteOBJAttribute,X
    LDA.W SpriteBlockedDirs,X
    LDY.W SpriteMisc151C,X
    AND.W DATA_01B031,Y
    BNE CODE_01B0C3
    LDA.W SpriteMisc1540,X
    BNE +
CODE_01B0C3:
    LDA.B #$80
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
  + LDA.B SpriteTableC2,X
    AND.B #$01
    TAY
    LDA.W SpriteMisc151C,X
    BEQ +
    INY
    INY
  + LDA.W DATA_01B01D,Y
    STA.B SpriteXSpeed,X
    LDA.W DATA_01B01F,Y
    STA.B SpriteYSpeed,X
    JSR SubSprXPosNoGrvty
    AND.B #$0C
    BNE CODE_01B0EA
    JSR SubSprYPosNoGrvty
CODE_01B0EA:
    JSR SubSprSprInteract
    JSR MarioSprInteractRt
    BCC CODE_01B10A
    LDA.W SpriteInLiquid,X
    BEQ CODE_01B107
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario has star
    BNE CODE_01B107                           ; /
    LDA.W PlayerRidingYoshi
    BNE CODE_01B10A
    JSL HurtMario
    BRA CODE_01B10A

CODE_01B107:
    JSR CODE_01B12A
CODE_01B10A:
    LDA.W SpriteMisc1602,X
    LSR A
    EOR.B #$01
    STA.B _0
    LDA.W SpriteOBJAttribute,X
    AND.B #$FE
    ORA.B _0
    STA.W SpriteOBJAttribute,X
    JSR SubSprGfx2Entry1
    JSR SubOffscreen0Bnk1
    LSR.W SpriteOBJAttribute,X
    SEC
    ROL.W SpriteOBJAttribute,X
    RTS

CODE_01B12A:
    LDA.B #$10
    STA.W KickingTimer
    LDA.B #!SFX_KICK
    STA.W SPCIO0                              ; / Play sound effect
    JSR SubHorizPos
    LDA.W DATA_01B023,Y
    STA.B SpriteXSpeed,X
    LDA.B #$E0
    STA.B SpriteYSpeed,X
    LDA.B #$02                                ; \ Sprite status = Killed
    STA.W SpriteStatus,X                      ; /
    STY.B PlayerDirection
    LDA.B #$01
    JSL GivePoints
    RTS

CODE_01B14E:
    LDA.B TrueFrame
    AND.B #$03
CODE_01B152:
    ORA.W SpriteOffscreenVert,X
    ORA.B SpriteLock
    BNE Return01B191
    JSL GetRand
    AND.B #$0F
    CLC
    LDY.B #$00
    ADC.B #$FC
    BPL +
    DEY
  + CLC
    ADC.B SpriteXPosLow,X
    STA.B _2
    TYA
    ADC.W SpriteXPosHigh,X
    PHA
    LDA.B _2
    CMP.B Layer1XPos
    PLA
    SBC.B Layer1XPos+1
    BNE Return01B191
    LDA.W RandomNumber+1
    AND.B #$0F
    CLC
    ADC.B #$FE
    ADC.B SpriteYPosLow,X
    STA.B _0
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _1
    JSL CODE_0285BA
Return01B191:
    RTS

GeneratedFish:
    JSR CODE_01B209
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return01B1B0                          ; /
    JSR SetAnimationFrame
    JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
    JSR CODE_019140
    LDA.B SpriteYSpeed,X
    CMP.B #$20
    BPL +
    CLC
    ADC.B #$01
  + STA.B SpriteYSpeed,X
Return01B1B0:
    RTS


DATA_01B1B1:
    db $D0,$D0,$B0

JumpingFish:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01B209                           ; /
    LDA.W SpriteInLiquid,X
    STA.W SpriteMisc151C,X
    JSR SubUpdateSprPos
    LDA.W SpriteInLiquid,X
    BEQ CODE_01B1EA
    LDA.B SpriteTableC2,X
    CMP.B #$03
    BEQ CODE_01B1DE
    INC.B SpriteTableC2,X
    TAY
    LDA.W DATA_01B1B1,Y
    STA.B SpriteYSpeed,X
    LDA.B #$10
    STA.W SpriteMisc1540,X
    STZ.W SpriteInLiquid,X
    BRA CODE_01B206

CODE_01B1DE:
    DEC.B SpriteYSpeed,X
    LDA.B TrueFrame
    AND.B #$03
    BNE +
    DEC.B SpriteYSpeed,X
  + BRA CODE_01B206

CODE_01B1EA:
    INC.W SpriteMisc1570,X
    INC.W SpriteMisc1570,X
    CMP.W SpriteMisc151C,X
    BEQ CODE_01B206
    LDA.B #$10
    STA.W SpriteMisc1540,X
    LDA.B SpriteTableC2,X
    CMP.B #$03
    BNE CODE_01B206
    STZ.B SpriteTableC2,X
    LDA.B #$D0
    STA.B SpriteYSpeed,X
CODE_01B206:
    JSR SetAnimationFrame
CODE_01B209:
    JSR SubSprSpr_MarioSpr
    JSR UpdateDirection
    JMP CODE_01B10A


DATA_01B212:
    db $08,$F8,$10,$F0

InitFloatSpkBall:
    JSR FaceMario
    LDY.W SpriteMisc157C,X
    LDA.B SpriteXPosLow,X
    AND.B #$10
    BEQ +
    INY
    INY
  + LDA.W DATA_01B212,Y
    STA.B SpriteXSpeed,X
    BRA InitFloatingPlat

InitFallingPlat:
    INC.W SpriteMisc1602,X
InitOrangePlat:
    LDA.W SpriteBuoyancy
    BNE InitFloatingPlat
    INC.B SpriteTableC2,X
    RTS

InitFloatingPlat:
    LDA.B #$03
    STA.W SpriteMisc151C,X
CODE_01B23B:
    JSR CODE_019140
    LDA.W SpriteInLiquid,X
    BNE Return01B25D
    DEC.W SpriteMisc151C,X
    BMI CODE_01B262
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$08
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    CMP.B #$02
    BCS Return01B25D
    BRA CODE_01B23B

Return01B25D:
    RTS

InitChckbrdPlat:
    INC.W SpriteMisc1602,X
    RTS

CODE_01B262:
    LDA.B #$01                                ; \ Sprite status = Initialization
    STA.W SpriteStatus,X                      ; /
Return01B267:
    RTS


DATA_01B268:
    db $FF,$01

DATA_01B26A:
    db $F0,$10

Platforms:
    JSR CODE_01B2D1
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return01B2C2                          ; /
    LDA.W SpriteMisc1540,X
    BNE CODE_01B2A5
    INC.B SpriteTableC2,X
    LDA.B SpriteTableC2,X
    AND.B #$03
    BNE CODE_01B2A5
    LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W DATA_01B268,Y
    STA.B SpriteYSpeed,X
    STA.B SpriteXSpeed,X
    CMP.W DATA_01B26A,Y
    BNE CODE_01B2A5
    INC.W SpriteMisc151C,X
    LDA.B #$18
    LDY.B SpriteNumber,X
    CPY.B #$55
    BNE +
    LDA.B #$08
  + STA.W SpriteMisc1540,X
CODE_01B2A5:
    LDA.B SpriteNumber,X
    CMP.B #$57
    BCS CODE_01B2B0
    JSR SubSprXPosNoGrvty
    BRA +

CODE_01B2B0:
    JSR SubSprYPosNoGrvty
    STZ.W SpriteXMovement
  + LDA.W SpriteXMovement
    STA.W SpriteMisc1528,X
    JSR CODE_01B457
    JSR SubOffscreen1Bnk1
Return01B2C2:
    RTS


DATA_01B2C3:
    db $00,$01,$00,$01,$00,$00,$00,$00
    db $01,$01,$00,$00,$00,$00

CODE_01B2D1:
    LDA.B SpriteNumber,X
    SEC
    SBC.B #$55
    TAY
    LDA.W DATA_01B2C3,Y
    BEQ CODE_01B2DF
    JMP CODE_01B395

CODE_01B2DF:
    JSR GetDrawInfoBnk1
    LDA.W SpriteMisc1602,X
    STA.B _1
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    STA.W OAMTileYPos+$108,Y
    LDX.B _1
    BEQ +
    STA.W OAMTileYPos+$10C,Y
    STA.W OAMTileYPos+$110,Y
  + LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$104,Y
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$108,Y
    LDX.B _1
    BEQ +
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$10C,Y
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$110,Y
  + LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _1
    BEQ CODE_01B344
    LDA.B #$EA
    STA.W OAMTileNo+$100,Y
    LDA.B #$EB
    STA.W OAMTileNo+$104,Y
    STA.W OAMTileNo+$108,Y
    STA.W OAMTileNo+$10C,Y
    LDA.B #$EC
    STA.W OAMTileNo+$110,Y
    BRA +

CODE_01B344:
    LDA.B #$60
    STA.W OAMTileNo+$100,Y
    LDA.B #$61
    STA.W OAMTileNo+$104,Y
    STA.W OAMTileNo+$108,Y
    STA.W OAMTileNo+$10C,Y
    LDA.B #$62
    STA.W OAMTileNo+$110,Y
  + LDA.B SpriteProperties
    ORA.W SpriteOBJAttribute,X
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y
    STA.W OAMTileAttr+$10C,Y
    STA.W OAMTileAttr+$110,Y
    LDA.B _1
    BNE +
    LDA.B #$62
    STA.W OAMTileNo+$108,Y
  + LDA.B #$04
    LDY.B _1
    BNE CODE_01B37E
    LDA.B #$02
CODE_01B37E:
    LDY.B #$02
    JMP FinishOAMWriteRt


DiagPlatTiles:
    db $CB,$E4,$CC,$E5,$CC,$E5,$CC,$E4
    db $CB

    db $85,$88,$86,$89,$86,$89,$86,$88
    db $85

CODE_01B395:
    JSR GetDrawInfoBnk1
    PHY
    LDY.B #$00
    LDA.B SpriteNumber,X
    CMP.B #$5E
    BNE +
    INY
  + STY.B _0
    PLY
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$108,Y
    STA.W OAMTileYPos+$110,Y
    LDX.B _0
    BEQ +
    STA.W OAMTileYPos+$118,Y
    STA.W OAMTileYPos+$120,Y
  + CLC
    ADC.B #$10
    STA.W OAMTileYPos+$104,Y
    STA.W OAMTileYPos+$10C,Y
    LDX.B _0
    BEQ +
    STA.W OAMTileYPos+$114,Y
    STA.W OAMTileYPos+$11C,Y
  + LDA.B #$08
    LDX.B _0
    BNE +
    LDA.B #$04
  + STA.B _1
    DEC A
    STA.B _2
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.W SpriteOBJAttribute,X
    STA.B _3
    LDA.B SpriteNumber,X
    CMP.B #$5B
    LDA.B #$00
    BCS +
    LDA.B #$09
  + PHA
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    PLX
CODE_01B3F6:
    STA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$08
    PHA
    %LorW_X(LDA,DiagPlatTiles)
    STA.W OAMTileNo+$100,Y
    LDA.B SpriteProperties
    ORA.B _3
    PHX
    LDX.B _1
    CPX.B _2
    PLX
    BCS +
    ORA.B #$40
  + STA.W OAMTileAttr+$100,Y
    PLA
    INY
    INY
    INY
    INY
    INX
    DEC.B _1
    BPL CODE_01B3F6
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B _0
    BNE CODE_01B444
    LDA.B SpriteNumber,X
    CMP.B #$5B
    BCS CODE_01B43A
    LDA.B #$85
    STA.W OAMTileNo+$110,Y
    LDA.B #$88
    STA.W OAMTileNo+$10C,Y
    BRA CODE_01B444

CODE_01B43A:
    LDA.B #$CB
    STA.W OAMTileNo+$110,Y
    LDA.B #$E4
    STA.W OAMTileNo+$10C,Y
CODE_01B444:
    LDA.B #$08
    LDY.B _0
    BNE +
    LDA.B #$04
  + JMP CODE_01B37E

InvisBlkMainRt:
    PHB
    PHK
    PLB
    JSR CODE_01B457
    PLB
    RTL

CODE_01B457:
    JSR ProcessInteract
    BCC CODE_01B4B2
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _0
    LDA.B PlayerYPosScrRel
    CLC
    ADC.B #$18
    CMP.B _0
    BPL CODE_01B4B4
    LDA.B PlayerYSpeed+1
    BMI CODE_01B4B2
    LDA.B PlayerBlockedDir
    AND.B #$08
    BNE CODE_01B4B2
    LDA.B #$10
    STA.B PlayerYSpeed+1
    LDA.B #$01
    STA.W StandOnSolidSprite
    LDA.B #$1F
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$2F
  + STA.B _1
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B _1
    STA.B PlayerYPosNext
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.B PlayerYPosNext+1
    LDA.B PlayerBlockedDir
    AND.B #$03
    BNE CODE_01B4B0
    LDY.B #$00
    LDA.W SpriteMisc1528,X
    BPL +
    DEY
  + CLC
    ADC.B PlayerXPosNext
    STA.B PlayerXPosNext
    TYA
    ADC.B PlayerXPosNext+1
    STA.B PlayerXPosNext+1
CODE_01B4B0:
    SEC
    RTS

CODE_01B4B2:
    CLC
    RTS

CODE_01B4B4:
    LDA.W SpriteTweakerF,X                    ; \ Branch if "Make Platform Passable" is set
    LSR A                                     ; |
    BCS CODE_01B4B2                           ; /
    LDA.B #$00
    LDY.B PlayerIsDucking
    BNE CODE_01B4C4
    LDY.B Powerup
    BNE +
CODE_01B4C4:
    LDA.B #$08
  + LDY.W PlayerRidingYoshi
    BEQ +
    ADC.B #$08
  + CLC
    ADC.B PlayerYPosScrRel
    CMP.B _0
    BCC CODE_01B505
    LDA.B PlayerYSpeed+1
    BPL CODE_01B4F7
    LDA.B #$10
    STA.B PlayerYSpeed+1
    LDA.B SpriteNumber,X
    CMP.B #$83
    BCC +
CODE_01B4E2:
    LDA.B #$0F
    STA.W SpriteMisc1564,X
    LDA.B SpriteTableC2,X
    BNE +
    INC.B SpriteTableC2,X
    LDA.B #$10
    STA.W SpriteMisc1558,X
  + LDA.B #!SFX_BONK
    STA.W SPCIO0                              ; / Play sound effect
CODE_01B4F7:
    CLC
    RTS


DATA_01B4F9:
    db $0E,$F1,$10,$E0,$1F,$F1

DATA_01B4FF:
    db $00,$FF,$00,$FF,$00,$FF

CODE_01B505:
    JSR SubHorizPos
    LDA.B SpriteNumber,X
    CMP.B #$A9
    BEQ CODE_01B520
    CMP.B #$9C
    BEQ CODE_01B51E
    CMP.B #$BB
    BEQ CODE_01B51E
    CMP.B #$60
    BEQ CODE_01B51E
    CMP.B #$49
    BNE +
CODE_01B51E:
    INY
    INY
CODE_01B520:
    INY
    INY
  + LDA.W DATA_01B4F9,Y
    CLC
    ADC.B SpriteXPosLow,X
    STA.B PlayerXPosNext
    LDA.W DATA_01B4FF,Y
    ADC.W SpriteXPosHigh,X
    STA.B PlayerXPosNext+1
    STZ.B PlayerXSpeed+1
    CLC
    RTS

OrangePlatform:
    LDA.B SpriteTableC2,X
    BEQ Platforms2
    JSR CODE_01B2D1
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    JSR SubSprXPosNoGrvty
    LDA.W SpriteXMovement
    STA.W SpriteMisc1528,X
    JSR CODE_01B457
    BCC +
    LDA.B #$01
    STA.W BGFastScrollActive
    LDA.B #$08
    STA.B SpriteXSpeed,X
  + RTS

FloatingSpikeBall:
    LDA.W SpriteStatus,X
    CMP.B #$08
    BEQ Platforms2
    JMP CODE_01B666

Platforms2:
    LDA.B SpriteLock
    BEQ +
    JMP CODE_01B64E

  + LDA.W SpriteBlockedDirs,X
    AND.B #$0C
    BNE +
    JSR SubSprYPosNoGrvty
  + STZ.W SpriteXMovement
    LDA.B SpriteNumber,X
    CMP.B #$A4
    BNE +
    JSR SubSprXPosNoGrvty
  + LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +
    INC.B SpriteYSpeed,X
  + LDA.W SpriteInLiquid,X
    BEQ CODE_01B5A6
    LDY.B #$F8
    LDA.B SpriteNumber,X
    CMP.B #$5D
    BCC +
    LDY.B #$FC
  + STY.B _0
    LDA.B SpriteYSpeed,X
    BPL CODE_01B5A1
    CMP.B _0
    BCC CODE_01B5A6
CODE_01B5A1:
    SEC
    SBC.B #$02
    STA.B SpriteYSpeed,X
CODE_01B5A6:
    LDA.B PlayerYSpeed+1
    PHA
    LDA.B SpriteNumber,X
    CMP.B #$A4
    BNE CODE_01B5B5
    JSR MarioSprInteractRt
    CLC
    BRA +

CODE_01B5B5:
    JSR CODE_01B457
  + PLA
    STA.B _0
    STZ.W TileGenerateTrackA
    BCC CODE_01B5E7
    LDA.B SpriteNumber,X
    CMP.B #$5D
    BCC CODE_01B5DA
    LDY.B #$03
    LDA.B Powerup
    BNE +
    DEY
  + STY.B _0
    LDA.B SpriteYSpeed,X
    CMP.B _0
    BPL CODE_01B5DA
    CLC
    ADC.B #$02
    STA.B SpriteYSpeed,X
CODE_01B5DA:
    INC.W TileGenerateTrackA
    LDA.B _0
    CMP.B #$20
    BCC CODE_01B5E7
    LSR A
    LSR A
    STA.B SpriteYSpeed,X
CODE_01B5E7:
    LDA.W TileGenerateTrackA
    CMP.W SpriteMisc151C,X
    STA.W SpriteMisc151C,X
    BEQ CODE_01B610
    LDA.W TileGenerateTrackA
    BNE CODE_01B610
    LDA.B PlayerYSpeed+1
    BPL CODE_01B610
    LDY.B #$08
    LDA.B Powerup
    BNE +
    LDY.B #$06
  + STY.B _0
    LDA.B SpriteYSpeed,X
    CMP.B #$20
    BPL CODE_01B610
    CLC
    ADC.B _0
    STA.B SpriteYSpeed,X
CODE_01B610:
    LDA.B #$01
    AND.B TrueFrame
    BNE CODE_01B64E
    LDA.B SpriteYSpeed,X
    BEQ CODE_01B624
    BPL +
    CLC
    ADC.B #$02
  + SEC
    SBC.B #$01
    STA.B SpriteYSpeed,X
CODE_01B624:
    LDY.W TileGenerateTrackA
    BEQ +
    LDY.B #$05
    LDA.B Powerup
    BNE +
    LDY.B #$02
  + STY.B _0
    LDA.B SpriteYPosLow,X
    PHA
    SEC
    SBC.B _0
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    JSR CODE_019140
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
CODE_01B64E:
    JSR SubOffscreen0Bnk1
    LDA.B SpriteNumber,X
    CMP.B #$A4
    BEQ CODE_01B666
    JMP CODE_01B2D1


DATA_01B65A:
    db $F8,$08,$F8,$08

DATA_01B65E:
    db $F8,$F8,$08,$08

FloatMineGfxProp:
    db $31,$71,$A1,$F1

CODE_01B666:
    JSR GetDrawInfoBnk1
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC
    ADC.W DATA_01B65A,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_01B65E,X
    STA.W OAMTileYPos+$100,Y
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$04
    LSR A
    ADC.B #$AA
    STA.W OAMTileNo+$100,Y
    LDA.W FloatMineGfxProp,X
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
    PLX
    LDY.B #$02
    LDA.B #$03
    JMP FinishOAMWriteRt


BlkBridgeLength:
    db $20,$00

TurnBlkBridgeSpeed:
    db $01,$FF

BlkBridgeTiming:
    db $40,$40

TurnBlockBridge:
    JSR SubOffscreen0Bnk1
    JSR CODE_01B710
    JSR CODE_01B852
    JSR CODE_01B6B2
    RTS

CODE_01B6B2:
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY
    LDA.W SpriteMisc151C,X
    CMP.W BlkBridgeLength,Y
    BEQ CODE_01B6D1
    LDA.W SpriteMisc1540,X
    ORA.B SpriteLock
    BNE +
    LDA.W SpriteMisc151C,X
    CLC
    ADC.W TurnBlkBridgeSpeed,Y
    STA.W SpriteMisc151C,X
  + RTS

CODE_01B6D1:
    LDA.W BlkBridgeTiming,Y
    STA.W SpriteMisc1540,X
    INC.B SpriteTableC2,X
    RTS

HorzTurnBlkBridge:
    JSR SubOffscreen0Bnk1
    JSR CODE_01B710
    JSR CODE_01B852
    JSR CODE_01B6E7
    RTS

CODE_01B6E7:
    LDY.B SpriteTableC2,X
    LDA.W SpriteMisc151C,X
    CMP.W BlkBridgeLength,Y
    BEQ CODE_01B703
    LDA.W SpriteMisc1540,X
    ORA.B SpriteLock
    BNE +
    LDA.W SpriteMisc151C,X
    CLC
    ADC.W TurnBlkBridgeSpeed,Y
    STA.W SpriteMisc151C,X
  + RTS

CODE_01B703:
    LDA.W BlkBridgeTiming,Y
    STA.W SpriteMisc1540,X
    LDA.B SpriteTableC2,X
    EOR.B #$01
    STA.B SpriteTableC2,X
    RTS

CODE_01B710:
    JSR GetDrawInfoBnk1
    STZ.B _0
    STZ.B _1
    STZ.B _2
    STZ.B _3
    LDA.B SpriteTableC2,X
    AND.B #$02
    TAY
    LDA.W SpriteMisc151C,X
    STA.W _0,Y
    LSR A
    STA.W _1,Y
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$110,Y
    PHA
    PHA
    PHA
    SEC
    SBC.B _2
    STA.W OAMTileYPos+$108,Y
    PLA
    SEC
    SBC.B _3
    STA.W OAMTileYPos+$10C,Y
    PLA
    CLC
    ADC.B _2
    STA.W OAMTileYPos+$100,Y
    PLA
    CLC
    ADC.B _3
    STA.W OAMTileYPos+$104,Y
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$110,Y
    PHA
    PHA
    PHA
    SEC
    SBC.B _0
    STA.W OAMTileXPos+$108,Y
    PLA
    SEC
    SBC.B _1
    STA.W OAMTileXPos+$10C,Y
    PLA
    CLC
    ADC.B _0
    STA.W OAMTileXPos+$100,Y
    PLA
    CLC
    ADC.B _1
    STA.W OAMTileXPos+$104,Y
    LDA.B SpriteTableC2,X
    LSR A
    LSR A
    LDA.B #$40
    STA.W OAMTileNo+$104,Y
    STA.W OAMTileNo+$10C,Y
    STA.W OAMTileNo+$110,Y
    STA.W OAMTileNo+$108,Y
    STA.W OAMTileNo+$100,Y
    LDA.B SpriteProperties
    STA.W OAMTileAttr+$10C,Y
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y
    STA.W OAMTileAttr+$110,Y
    ORA.B #$60
    STA.W OAMTileAttr+$100,Y
    LDA.B _0
    PHA
    LDA.B _2
    PHA
    LDA.B #$04
    JSR CODE_01B37E
    PLA
    STA.B _2
    PLA
    STA.B _0
    RTS

FinishOAMWrite:
    PHB                                       ; Wrapper
    PHK
    PLB
    JSR FinishOAMWriteRt
    PLB
    RTL

FinishOAMWriteRt:
    STY.B _B
    STA.B _8
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B SpriteYPosLow,X
    STA.B _0
    SEC
    SBC.B Layer1YPos
    STA.B _6
    LDA.W SpriteYPosHigh,X
    STA.B _1
    LDA.B SpriteXPosLow,X
    STA.B _2
    SEC
    SBC.B Layer1XPos
    STA.B _7
    LDA.W SpriteXPosHigh,X
    STA.B _3
CODE_01B7DE:
    TYA
    LSR A
    LSR A
    TAX
    LDA.B _B
    BPL CODE_01B7F0
    LDA.W OAMTileSize+$40,X
    AND.B #$02
    STA.W OAMTileSize+$40,X
    BRA +

CODE_01B7F0:
    STA.W OAMTileSize+$40,X
  + LDX.B #$00
    LDA.W OAMTileXPos+$100,Y
    SEC
    SBC.B _7
    BPL +
    DEX
  + CLC
    ADC.B _2
    STA.B _4
    TXA
    ADC.B _3
    STA.B _5
    JSR CODE_01B844
    BCC +
    TYA
    LSR A
    LSR A
    TAX
    LDA.W OAMTileSize+$40,X
    ORA.B #$01
    STA.W OAMTileSize+$40,X
  + LDX.B #$00
    LDA.W OAMTileYPos+$100,Y
    SEC
    SBC.B _6
    BPL +
    DEX
  + CLC
    ADC.B _0
    STA.B _9
    TXA
    ADC.B _1
    STA.B _A
    JSR CODE_01C9BF
    BCC +
    LDA.B #$F0
    STA.W OAMTileYPos+$100,Y
  + INY
    INY
    INY
    INY
    DEC.B _8
    BPL CODE_01B7DE
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

CODE_01B844:
    REP #$20                                  ; A->16
    LDA.B _4
    SEC
    SBC.B Layer1XPos
    CMP.W #$0100
    SEP #$20                                  ; A->8
    RTS

    RTS

CODE_01B852:
    LDA.W SpriteWayOffscreenX,X
    BNE Return01B8B1
    LDA.B PlayerAnimation
    CMP.B #$01
    BCS Return01B8B1
    JSR CODE_01B8FF
    BCC Return01B8B1
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _2
    SEC
    SBC.B _D
    STA.B _9
    LDA.B PlayerYPosScrRel
    CLC
    ADC.B #$18
    CMP.B _9
    BCS ADDR_01B8B2
    LDA.B PlayerYSpeed+1
    BMI Return01B8B1
    STZ.B PlayerYSpeed+1
    LDA.B #$01
    STA.W StandOnSolidSprite
    LDA.B _D
    CLC
    ADC.B #$1F
    LDY.W PlayerRidingYoshi
    BEQ +
    CLC
    ADC.B #$10
  + STA.B _0
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B _0
    STA.B PlayerYPosNext
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.B PlayerYPosNext+1
    LDY.B #$00
    LDA.W SpriteXMovement
    BPL +
    DEY
  + CLC
    ADC.B PlayerXPosNext
    STA.B PlayerXPosNext
    TYA
    ADC.B PlayerXPosNext+1
    STA.B PlayerXPosNext+1
Return01B8B1:
    RTS

ADDR_01B8B2:
    LDA.B _2
    CLC
    ADC.B _D
    STA.B _2
    LDA.B #$FF
    LDY.B PlayerIsDucking
    BNE ADDR_01B8C3
    LDY.B Powerup
    BNE +
ADDR_01B8C3:
    LDA.B #$08
  + CLC
    ADC.B PlayerYPosScrRel
    CMP.B _2
    BCC ADDR_01B8D5
    LDA.B PlayerYSpeed+1
    BPL +
    LDA.B #$10
    STA.B PlayerYSpeed+1
  + RTS

ADDR_01B8D5:
    LDA.B _E
    CLC
    ADC.B #$10
    STA.B _0
    LDY.B #$00
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CMP.B PlayerXPosScrRel
    BCC +
    LDA.B _0
    EOR.B #$FF
    INC A
    STA.B _0
    DEY
  + LDA.B SpriteXPosLow,X
    CLC
    ADC.B _0
    STA.B PlayerXPosNext
    TYA
    ADC.W SpriteXPosHigh,X
    STA.B PlayerXPosNext+1
    STZ.B PlayerXSpeed+1
    RTS

CODE_01B8FF:
    LDA.B _0
    STA.B _E
    LDA.B _2
    STA.B _D
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B _0
    STA.B _4
    LDA.W SpriteXPosHigh,X
    SBC.B #$00
    STA.B _A
    LDA.B _0
    ASL A
    CLC
    ADC.B #$10
    STA.B _6
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B _2
    STA.B _5
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.B _B
    LDA.B _2
    ASL A
    CLC
    ADC.B #$10
    STA.B _7
    JSL GetMarioClipping
    JSL CheckForContact
    RTS


HorzNetKoopaSpeed:
    db $08,$F8

InitHorzNetKoopa:
    JSR SubHorizPos
    LDA.W HorzNetKoopaSpeed,Y
    STA.B SpriteXSpeed,X
    BRA +

InitVertNetKoopa:
    INC.B SpriteTableC2,X
    INC.B SpriteXSpeed,X
    LDA.B #$F8
    STA.B SpriteYSpeed,X
  + LDA.B SpriteXPosLow,X
    LDY.B #$00
    AND.B #$10
    BNE +
    INY
  + TYA
    STA.W SpriteBehindScene,X
    LDA.W SpriteOBJAttribute,X
    AND.B #$02
    BNE +
    ASL.B SpriteXSpeed,X
    ASL.B SpriteYSpeed,X
  + RTS


DATA_01B969:
    db $02,$02,$03,$04,$03,$02,$02,$02
    db $01,$02

DATA_01B973:
    db $01,$01,$00,$00,$00,$01,$01,$01
    db $01,$01

DATA_01B97D:
    db $03,$0C

ClimbingKoopa:
    LDA.W SpriteMisc1540,X
    BEQ CODE_01B9FB
    CMP.B #$30
    BCC CODE_01B9A0
    CMP.B #$40
    BCC CODE_01B9A3
    BNE CODE_01B9A0
    LDY.B SpriteLock
    BNE CODE_01B9A0
    LDA.W SpriteBehindScene,X
    EOR.B #$01
    STA.W SpriteBehindScene,X
    JSR FlipSpriteDir
    JSR CODE_01BA7F
CODE_01B9A0:
    JMP CODE_01BA37

CODE_01B9A3:
    LDY.B SpriteYPosLow,X
    PHY
    LDY.W SpriteYPosHigh,X
    PHY
    LDY.B #$00
    CMP.B #$38
    BCC +
    INY
  + LDA.B SpriteTableC2,X
    BEQ +
    INY
    INY
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$0C
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.W SpriteBehindScene,X
    BEQ +
    INY
  + LDA.W OWLevelTileSettings+$49
    BPL +
    INY
    INY
    INY
    INY
    INY
  + LDA.W DATA_01B969,Y
    STA.W SpriteMisc1602,X
    LDA.W DATA_01B973,Y
    STA.B _0
    LDA.W SpriteOBJAttribute,X
    PHA
    AND.B #$FE
    ORA.B _0
    STA.W SpriteOBJAttribute,X
    JSR SubSprGfx1
    PLA
    STA.W SpriteOBJAttribute,X
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    RTS

CODE_01B9FB:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01BA53                           ; /
    JSR CODE_019140
    LDY.B SpriteTableC2,X
    LDA.W SpriteBlockedDirs,X
    AND.W DATA_01B97D,Y
    BEQ CODE_01BA14
CODE_01BA0C:
    JSR FlipSpriteDir
    JSR CODE_01BA7F
    BRA CODE_01BA37

CODE_01BA14:
    LDA.W SprMap16TouchVertLow
    LDY.B SpriteYSpeed,X
    BEQ CODE_01BA27
    BPL CODE_01BA1F
    BMI CODE_01BA2A
CODE_01BA1F:
    CMP.B #$07
    BCC CODE_01BA0C
    CMP.B #$1D
    BCS CODE_01BA0C
CODE_01BA27:
    LDA.W SprMap16TouchHorizLow
CODE_01BA2A:
    CMP.B #$07
    BCC CODE_01BA32
    CMP.B #$1D
    BCC CODE_01BA37
CODE_01BA32:
    LDA.B #$50
    STA.W SpriteMisc1540,X
CODE_01BA37:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01BA53                           ; /
    INC.W SpriteMisc1570,X
    JSR UpdateDirection
    LDA.B SpriteTableC2,X
    BNE CODE_01BA4A
    JSR SubSprXPosNoGrvty
    BRA +

CODE_01BA4A:
    JSR SubSprYPosNoGrvty
  + JSR MarioSprInteractRt
    JSR SubOffscreen0Bnk1
CODE_01BA53:
    LDA.W SpriteMisc157C,X
    PHA
    LDA.W SpriteMisc1570,X
    AND.B #$08
    LSR A
    LSR A
    LSR A
    STA.W SpriteMisc157C,X
    LDA.B SpriteProperties
    PHA
    LDA.W SpriteBehindScene,X
    STA.W SpriteMisc1602,X
    LDA.W SpriteBehindScene,X
    BEQ +
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
  + JSR SubSprGfx1
    PLA
    STA.B SpriteProperties
    PLA
    STA.W SpriteMisc157C,X
    RTS

CODE_01BA7F:
    LDA.B SpriteYSpeed,X
    EOR.B #$FF
    INC A
    STA.B SpriteYSpeed,X
    RTS

InitClimbingDoor:
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$08
    STA.B SpriteXPosLow,X
    LDA.B SpriteYPosLow,X
    ADC.B #$07
    STA.B SpriteYPosLow,X
    RTS


    db $30,$54

DATA_01BA97:
    db $00,$01,$02,$04,$06,$09,$0C,$0D
    db $14,$0D,$0C,$09,$06,$04,$02,$01
DATA_01BAA7:
    db $00,$00,$00,$00,$00,$01,$01,$01
    db $02,$01,$01,$01,$00,$00,$00,$00
DATA_01BAB7:
    db $00,$10,$00,$00,$10,$00,$01,$11
    db $01,$05,$15,$05,$05,$15,$05,$00
    db $00,$00,$03,$13,$03

Return01BACC:
    RTS

ClimbingDoor:
    JSR SubOffscreen0Bnk1
    LDA.W SpriteMisc154C,X
    CMP.B #$01
    BNE +
    LDA.B #!SFX_FLYHIT                        ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.B #$19
    JSL GenTileFromSpr2
    LDA.B #$1F
    STA.W SpriteMisc1540,X
    STA.W NetDoorTimer
    LDA.B PlayerXPosNext
    SEC
    SBC.B #$10
    SEC
    SBC.B SpriteXPosLow,X
    STA.W NetDoorPlayerXOffset
  + LDA.W SpriteMisc1540,X
    ORA.W SpriteMisc154C,X
    BNE +
    JSL GetSpriteClippingA
    JSR CODE_01BC1D
    JSL CheckForContact
    BCC +
    LDA.W PunchNetTimer
    CMP.B #$01
    BNE +
    LDA.B #$06
    STA.W SpriteMisc154C,X
  + LDA.W SpriteMisc1540,X
    BEQ Return01BACC
    CMP.B #$01
    BNE +
    PHA
    LDA.B #$1A
    JSL GenTileFromSpr2
    PLA
  + CMP.B #$10
    BNE +
    LDA.W PlayerBehindNet
    EOR.B #$01
    STA.W PlayerBehindNet
  + LDA.B #$30
    STA.W SpriteOAMIndex,X
    STA.B _3
    TAY
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    LDA.W SpriteMisc1540,X
    LSR A
    STA.B _2
    TAX
    %LorW_X(LDA,DATA_01BAA7)
    STA.B _6
    LDA.B _0
    CLC
    %LorW_X(ADC,DATA_01BA97)
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    STA.W OAMTileXPos+$108,Y
    LDA.B _6
    CMP.B #$02
    BEQ +
    LDA.B _0
    CLC
    ADC.B #$20
    SEC
    %LorW_X(SBC,DATA_01BA97)
    STA.W OAMTileXPos+$10C,Y
    STA.W OAMTileXPos+$110,Y
    STA.W OAMTileXPos+$114,Y
    LDA.B _6
    BNE +
    LDA.B _0
    CLC
    ADC.B #$10
    STA.W OAMTileXPos+$118,Y
    STA.W OAMTileXPos+$11C,Y
    STA.W OAMTileXPos+$120,Y
  + LDA.B _1
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$10C,Y
    STA.W OAMTileYPos+$118,Y
    CLC
    ADC.B #$10
    STA.W OAMTileYPos+$104,Y
    STA.W OAMTileYPos+$110,Y
    STA.W OAMTileYPos+$11C,Y
    CLC
    ADC.B #$10
    STA.W OAMTileYPos+$108,Y
    STA.W OAMTileYPos+$114,Y
    STA.W OAMTileYPos+$120,Y
    LDA.B #$08
    STA.B _7
    LDA.B _6
    ASL A
    ASL A
    ASL A
    ADC.B _6
    TAX
  - %LorW_X(LDA,DATA_01BAB7)
    STA.W OAMTileNo+$100,Y
    INY
    INY
    INY
    INY
    INX
    DEC.B _7
    BPL -
    LDY.B _3
    LDX.B #$08
CODE_01BBD0:
    LDA.B SpriteProperties
    ORA.B #$09
    CPX.B #$06
    BCS +
    ORA.B #$40
  + CPX.B #$00
    BEQ CODE_01BBE6
    CPX.B #$03
    BEQ CODE_01BBE6
    CPX.B #$06
    BNE +
CODE_01BBE6:
    ORA.B #$80
  + STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_01BBD0
    LDA.B _6
    PHA
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B #$08
    JSR CODE_01B37E
    LDY.B #$0C
    PLA
    BEQ Return01BC1C
    CMP.B #$02
    BNE +
    LDA.B #$03
    STA.W OAMTileSize+$43,Y
    STA.W OAMTileSize+$44,Y
    STA.W OAMTileSize+$45,Y
  + LDA.B #$03
    STA.W OAMTileSize+$46,Y
    STA.W OAMTileSize+$47,Y
    STA.W OAMTileSize+$48,Y
Return01BC1C:
    RTS

CODE_01BC1D:
    LDA.B PlayerXPosNext                      ; \ $00 = Mario X Low
    STA.B _0                                  ; /
    LDA.B PlayerYPosNext                      ; \ $01 = Mario Y Low
    STA.B _1                                  ; /
    LDA.B #$10                                ; \ $02 = $03 = #$10
    STA.B _2                                  ; |
    STA.B _3                                  ; /
    LDA.B PlayerXPosNext+1                    ; \ $08 = Mario X High
    STA.B _8                                  ; /
    LDA.B PlayerYPosNext+1                    ; \ $09 = Mario Y High
    STA.B _9                                  ; /
    RTS


MagiKoopasMagicPals:
    db $05,$07,$09,$0B

MagikoopasMagic:
    LDA.B SpriteLock
    BEQ +
    JMP CODE_01BCBD

  + JSR CODE_01B14E
    JSR SubSprYPosNoGrvty
    JSR SubSprXPosNoGrvty
    LDA.B SpriteYSpeed,X
    PHA
    LDA.B #$FF
    STA.B SpriteYSpeed,X
    JSR CODE_019140
    PLA
    STA.B SpriteYSpeed,X
    JSR IsTouchingCeiling
    BEQ CODE_01BCBD
    LDA.W SpriteOffscreenX,X
    BNE CODE_01BCBD
    LDA.B #!SFX_BONK                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    STZ.W SpriteStatus,X
    LDA.W SprMap16TouchVertLow
    SEC
    SBC.B #$11
    CMP.B #$1D
    BCS CODE_01BCB9
    JSL GetRand
    ADC.W RandomNumber+1
    ADC.B PlayerXSpeed+1
    ADC.B TrueFrame
    LDY.B #$78
    CMP.B #$35
    BEQ +
    LDY.B #$21
    CMP.B #$08
    BCC +
    LDY.B #$27
    CMP.B #$F7
    BCS +
    LDY.B #$07
  + STY.B SpriteNumber,X
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    JSL InitSpriteTables
    LDA.B TouchBlockXPos+1                    ; \ Sprite X position = block X position
    STA.W SpriteXPosHigh,X                    ; |
    LDA.B TouchBlockXPos                      ; |
    AND.B #$F0                                ; |
    STA.B SpriteXPosLow,X                     ; |
    LDA.B TouchBlockYPos+1                    ; /
    STA.W SpriteYPosHigh,X                    ; \ Sprite Y position = block Y position
    LDA.B TouchBlockYPos                      ; |
    AND.B #$F0                                ; |
    STA.B SpriteYPosLow,X                     ; /
    LDA.B #$02                                ; \ Block to generate = #$02
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile
CODE_01BCB9:
    JSR CODE_01BD98
    RTS

CODE_01BCBD:
    JSR SubSprSpr_MarioSpr
    LDA.B TrueFrame
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W MagiKoopasMagicPals,Y
    STA.W SpriteOBJAttribute,X
    JSR MagiKoopasMagicGfx
    JSR SubOffscreen0Bnk1
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B #$E0
    BCC +
    STZ.W SpriteStatus,X
  + RTS


MagiKoopasMagicDisp:
    db $00,$01,$02,$05,$08,$0B,$0E,$0F
    db $10,$0F,$0E,$0B,$08,$05,$02,$01

MagiKoopasMagicGfx:
    JSR GetDrawInfoBnk1
    LDA.B EffFrame
    LSR A
    AND.B #$0F
    STA.B _3
    CLC
    ADC.B #$0C
    AND.B #$0F
    STA.B _2
    LDA.B _1
    SEC
    SBC.B #$04
    STA.B _1
    LDA.B _0
    SEC
    SBC.B #$04
    STA.B _0
    LDX.B _2
    LDA.B _1
    CLC
    %LorW_X(ADC,MagiKoopasMagicDisp)
    STA.W OAMTileYPos+$100,Y
    LDX.B _3
    LDA.B _0
    CLC
    %LorW_X(ADC,MagiKoopasMagicDisp)
    STA.W OAMTileXPos+$100,Y
    LDA.B _2
    CLC
    ADC.B #$05
    AND.B #$0F
    STA.B _2
    TAX
    LDA.B _1
    CLC
    %LorW_X(ADC,MagiKoopasMagicDisp)
    STA.W OAMTileYPos+$104,Y
    LDA.B _3
    CLC
    ADC.B #$05
    AND.B #$0F
    STA.B _3
    TAX
    LDA.B _0
    CLC
    %LorW_X(ADC,MagiKoopasMagicDisp)
    STA.W OAMTileXPos+$104,Y
    LDA.B _2
    CLC
    ADC.B #$05
    AND.B #$0F
    STA.B _2
    TAX
    LDA.B _1
    CLC
    %LorW_X(ADC,MagiKoopasMagicDisp)
    STA.W OAMTileYPos+$108,Y
    LDA.B _3
    CLC
    ADC.B #$05
    AND.B #$0F
    STA.B _3
    TAX
    LDA.B _0
    CLC
    %LorW_X(ADC,MagiKoopasMagicDisp)
    STA.W OAMTileXPos+$108,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y
    LDA.B #$88
    STA.W OAMTileNo+$100,Y
    LDA.B #$89
    STA.W OAMTileNo+$104,Y
    LDA.B #$98
    STA.W OAMTileNo+$108,Y
    LDY.B #$00                                ; \ 3 8x8 tiles
    LDA.B #$02                                ; |
    JMP FinishOAMWriteRt

CODE_01BD98:
    LDY.B #$03
CODE_01BD9A:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_01BDA3
    DEY
    BPL CODE_01BD9A
    RTS

CODE_01BDA3:
    LDA.B #$01
    STA.W SmokeSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SmokeSpriteXPos,Y
    LDA.B SpriteYPosLow,X
    STA.W SmokeSpriteYPos,Y
    LDA.B #$1B
    STA.W SmokeSpriteTimer,Y
    RTS

InitMagikoopa:
    LDY.B #$09
CODE_01BDBA:
    CPY.W CurSpriteProcess
    BEQ +
    LDA.W SpriteStatus,Y
    BEQ +
    LDA.W SpriteNumber,Y
    CMP.B #$1F
    BNE +
    STZ.W SpriteStatus,X
    RTS

  + DEY
    BPL CODE_01BDBA
    STZ.W SpriteWillAppear
    RTS

Magikoopa:
    LDA.B #$01
    STA.W SpriteOnYoshiTongue,X
    LDA.W SpriteOffscreenX,X
    BEQ +
    STZ.B SpriteTableC2,X
  + LDA.B SpriteTableC2,X
    AND.B #$03
    JSL ExecutePtr

    dw CODE_01BDF2
    dw CODE_01BE5F
    dw CODE_01BE6E
    dw CODE_01BF16

CODE_01BDF2:
    LDA.W SpriteWillAppear
    BEQ +
    STZ.W SpriteStatus,X
    RTS

  + LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    LDY.B #$24
    STY.B ColorSettings
    LDA.W SpriteMisc1540,X
    BNE +
    JSL GetRand
    CMP.B #$D1
    BCS +
    CLC
    ADC.B Layer1YPos
    AND.B #$F0
    STA.B SpriteYPosLow,X
    LDA.B Layer1YPos+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    JSL GetRand
    CLC
    ADC.B Layer1XPos
    AND.B #$F0
    STA.B SpriteXPosLow,X
    LDA.B Layer1XPos+1
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    JSR SubHorizPos
    LDA.B _F
    CLC
    ADC.B #$20
    CMP.B #$40
    BCC +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.B #$01
    STA.B SpriteXSpeed,X
    JSR CODE_019140
    JSR IsOnGround
    BEQ +
    LDA.W SprMap16TouchHorizHigh
    BNE +
    INC.B SpriteTableC2,X
    STZ.W SpriteMisc1570,X
    JSR CODE_01BE82
    JSR SubHorizPos
    TYA
    STA.W SpriteMisc157C,X
  + RTS

CODE_01BE5F:
    JSR CODE_01C004
    STZ.W SpriteMisc1602,X
    JSR SubSprGfx1
    RTS


DATA_01BE69:
    db $04,$02,$00

DATA_01BE6C:
    db $10,$F8

CODE_01BE6E:
    STZ.W SpriteOnYoshiTongue,X
    JSR SubSprSpr_MarioSpr
    JSR SubHorizPos
    TYA
    STA.W SpriteMisc157C,X
    LDA.W SpriteMisc1540,X
    BNE +
    INC.B SpriteTableC2,X
CODE_01BE82:
    LDY.B #$34
    STY.B ColorSettings
  + CMP.B #$40
    BNE CODE_01BE96
    PHA
    LDA.B SpriteLock
    ORA.W SpriteOffscreenX,X
    BNE +
    JSR CODE_01BF1D                           ;JUMP TO GENERATE MAGIC
  + PLA
CODE_01BE96:
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    TAY
    PHY
    LDA.W SpriteMisc1540,X
    LSR A
    LSR A
    LSR A
    AND.B #$01
    ORA.W DATA_01BE69,Y
    STA.W SpriteMisc1602,X
    JSR SubSprGfx1
    LDA.W SpriteMisc1602,X
    SEC
    SBC.B #$02
    CMP.B #$02
    BCC +
    LSR A
    BCC +
    LDA.W SpriteOAMIndex,X
    TAX
    INC.W OAMTileYPos+$100,X
    LDX.W CurSpriteProcess                    ; X = Sprite index
  + PLY
    CPY.B #$01
    BNE +
    JSR CODE_01B14E
  + LDA.W SpriteMisc1602,X
    CMP.B #$04
    BCC Return01BF15
    LDY.W SpriteMisc157C,X
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_01BE6C,Y
    SEC
    SBC.B Layer1XPos
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    STA.W OAMTileXPos+$108,Y
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CLC
    ADC.B #$10
    STA.W OAMTileYPos+$108,Y
    LDA.W SpriteMisc157C,X
    LSR A
    LDA.B #$00
    BCS +
    ORA.B #!OBJ_XFlip
  + ORA.B SpriteProperties
    ORA.W SpriteOBJAttribute,X
    STA.W OAMTileAttr+$108,Y
    LDA.B #$99
    STA.W OAMTileNo+$108,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    ORA.W SpriteOffscreenX,X
    STA.W OAMTileSize+$42,Y
Return01BF15:
    RTS

CODE_01BF16:
    JSR CODE_01BFE3
    JSR SubSprGfx1
    RTS

CODE_01BF1D:
    LDY.B #$09
CODE_01BF1F:
    LDA.W SpriteStatus,Y
    BEQ CODE_01BF28
    DEY
    BPL CODE_01BF1F
    RTS

CODE_01BF28:
    LDA.B #!SFX_MAGIC                         ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$20                                ;GENERATES MAGIC HERE!   !@#
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$0A
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    TYX
    JSL InitSpriteTables
    LDA.B #$20
    JSR CODE_01BF6A
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B _0                                  ;PULLS SPEED FROM RAM HERE?
    STA.W SpriteYSpeed,Y
    LDA.B _1
    STA.W SpriteXSpeed,Y
    RTS

CODE_01BF6A:
    STA.B _1                                  ;FILLS OUT RAM TO USE FOR SPEED?
    PHX
    PHY
    JSR CODE_01AD42
    STY.B _2
    LDA.B _E
    BPL +
    EOR.B #$FF
    CLC
    ADC.B #$01
  + STA.B _C
    JSR SubHorizPos
    STY.B _3
    LDA.B _F
    BPL +
    EOR.B #$FF
    CLC
    ADC.B #$01
  + STA.B _D
    LDY.B #$00
    LDA.B _D
    CMP.B _C
    BCS +
    INY
    PHA
    LDA.B _C
    STA.B _D
    PLA
    STA.B _C
  + LDA.B #$00
    STA.B _B
    STA.B _0
    LDX.B _1
CODE_01BFA7:
    LDA.B _B
    CLC
    ADC.B _C
    CMP.B _D
    BCC +
    SBC.B _D
    INC.B _0
  + STA.B _B
    DEX
    BNE CODE_01BFA7
    TYA
    BEQ +
    LDA.B _0
    PHA
    LDA.B _1
    STA.B _0
    PLA
    STA.B _1
  + LDA.B _0
    LDY.B _2
    BEQ +
    EOR.B #$FF
    CLC
    ADC.B #$01
    STA.B _0
  + LDA.B _1
    LDY.B _3
    BEQ +
    EOR.B #$FF
    CLC
    ADC.B #$01
    STA.B _1
  + PLY
    PLX
    RTS

CODE_01BFE3:
    LDA.W SpriteMisc1540,X
    BNE Return01C000
    LDA.B #$02
    STA.W SpriteMisc1540,X
    DEC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    CMP.B #$00
    BNE +
    INC.B SpriteTableC2,X
    LDA.B #$10
    STA.W SpriteMisc1540,X
    PLA
    PLA
Return01C000:
    RTS

  + JMP CODE_01C028

CODE_01C004:
    LDA.W SpriteMisc1540,X
    BNE CODE_01C05E
    LDA.B #$04
    STA.W SpriteMisc1540,X
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    CMP.B #$09
    BNE +
    LDY.B #$24
    STY.B ColorSettings
  + CMP.B #$09
    BNE CODE_01C028
    INC.B SpriteTableC2,X
    LDA.B #$70
    STA.W SpriteMisc1540,X
    RTS

CODE_01C028:
    LDA.W SpriteMisc1570,X
    DEC A
    ASL A
    ASL A
    ASL A
    ASL A
    TAX
    STZ.B _0
    LDY.W DynPaletteIndex
  - LDA.L MagiKoopaPals,X
    STA.W DynPaletteTable+2,Y
    INY
    INX
    INC.B _0
    LDA.B _0
    CMP.B #$10
    BNE -
    LDX.W DynPaletteIndex
    LDA.B #$10
    STA.W DynPaletteTable,X
    LDA.B #$F0
    STA.W DynPaletteTable+1,X
    STZ.W DynPaletteTable+$12,X
    TXA
    CLC
    ADC.B #$12
    STA.W DynPaletteIndex
CODE_01C05E:
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS

    JSR InitGoalTape                          ; \ Unreachable
    LDA.B SpriteYPosLow,X                     ; | Call Goal Tape INIT, then
    SEC                                       ; | Sprite Y position -= #$4C
    SBC.B #$4C                                ; |
    STA.B SpriteYPosLow,X                     ; |
    LDA.W SpriteYPosHigh,X                    ; |
    SBC.B #$00                                ; |
    STA.W SpriteYPosHigh,X                    ; |
    RTS                                       ; /

InitGoalTape:
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B #$08
    STA.B SpriteTableC2,X
    LDA.W SpriteXPosHigh,X
    SBC.B #$00
    STA.W SpriteMisc151C,X
    LDA.B SpriteYPosLow,X
    STA.W SpriteMisc1528,X
    LDA.W SpriteYPosHigh,X                    ; \ Save extra bits into $187B,x
    STA.W SpriteMisc187B,X                    ; /
    AND.B #$01                                ; \ Clear extra bits out of position
    STA.W SpriteYPosHigh,X                    ; /
    STA.W SpriteMisc1534,X
    RTS

GoalTape:
    JSR CODE_01C12D
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return01C0A4                          ; /
    LDA.W SpriteMisc1602,X
    BEQ +
Return01C0A4:
    RTS


DATA_01C0A5:
    db $10,$F0

  + LDA.W SpriteMisc1540,X
    BNE +
    LDA.B #$7C
    STA.W SpriteMisc1540,X
    INC.W SpriteBlockedDirs,X
  + LDA.W SpriteBlockedDirs,X
    AND.B #$01
    TAY
    LDA.W DATA_01C0A5,Y
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty
    LDA.B SpriteTableC2,X
    STA.B _0
    LDA.W SpriteMisc151C,X
    STA.B _1
    REP #$20                                  ; A->16
    LDA.B PlayerXPosNext
    SEC
    SBC.B _0
    CMP.W #$0010
    SEP #$20                                  ; A->8
    BCS Return01C12C
    LDA.W SpriteMisc1528,X
    CMP.B PlayerYPosNext
    LDA.W SpriteMisc1534,X
    AND.B #$01
    SBC.B PlayerYPosNext+1
    BCC Return01C12C
    LDA.W SpriteMisc187B,X                    ; \ $141C = #01 if Goal Tape triggers secret exit
    LSR A                                     ; |
    LSR A                                     ; |
    STA.W SecretGoalTape                      ; /
    LDA.B #!BGM_LEVELCLEAR
    STA.W SPCIO2                              ; / Change music
    LDA.B #$FF
    STA.W MusicBackup
    LDA.B #$FF
    STA.W EndLevelTimer
    STZ.W InvinsibilityTimer                  ; Zero out star timer
    INC.W SpriteMisc1602,X
    JSR MarioSprInteractRt
    BCC CODE_01C125
    LDA.B #!SFX_KAPOW                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
    INC.W SpriteMisc160E,X
    LDA.W SpriteMisc1528,X
    SEC
    SBC.B SpriteYPosLow,X
    STA.W SpriteMisc1594,X
    LDA.B #$80
    STA.W SpriteMisc1540,X
    JSL CODE_07F252
    BRA +

CODE_01C125:
    STZ.W SpriteTweakerE,X
  + JSL TriggerGoalTape
Return01C12C:
    RTS

CODE_01C12D:
    LDA.W SpriteMisc160E,X
    BNE +
    JSR GetDrawInfoBnk1
    LDA.B _0
    SEC
    SBC.B #$08
    STA.W OAMTileXPos+$100,Y
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$104,Y
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$108,Y
    LDA.B _1
    CLC
    ADC.B #$08
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    STA.W OAMTileYPos+$108,Y
    LDA.B #$D4
    STA.W OAMTileNo+$100,Y
    INC A
    STA.W OAMTileNo+$104,Y
    STA.W OAMTileNo+$108,Y
    LDA.B #$32
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y
    LDY.B #$00
    LDA.B #$02
    JMP FinishOAMWriteRt

  + LDA.W SpriteMisc1540,X
    BEQ +
    JSL CODE_07F1CA
    RTS

  + STZ.W SpriteStatus,X
    RTS

GrowingVine:
    LDA.B SpriteProperties
    PHA
    LDA.W SpriteMisc1540,X
    CMP.B #$20
    BCC +
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
  + JSR SubSprGfx2Entry1
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    LSR A
    LDA.B #$AC
    BCC +
    LDA.B #$AE
  + STA.W OAMTileNo+$100,Y
    PLA
    STA.B SpriteProperties
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return01C1ED                          ; /
    LDA.B #$F0
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty
    LDA.W SpriteMisc1540,X
    CMP.B #$20
    BCS CODE_01C1CB
    JSR CODE_019140
    LDA.W SpriteBlockedDirs,X
    BNE CODE_01C1C8
    LDA.W SpriteYPosHigh,X
    BPL CODE_01C1CB
CODE_01C1C8:
    JMP OffScrEraseSprite

CODE_01C1CB:
    LDA.B SpriteYPosLow,X
    AND.B #$0F
    CMP.B #$00
    BNE Return01C1ED
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position
    STA.B TouchBlockXPos                      ; | for block creation
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ $98 = Sprite Y position
    STA.B TouchBlockYPos                      ; | for block creation
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B TouchBlockYPos+1                    ; /
    LDA.B #$03                                ; \ Block to generate = Vine
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile                          ; Generate the tile
Return01C1ED:
    RTS


DATA_01C1EE:
    db $FF,$01

DATA_01C1F0:
    db $F0,$10

BalloonKeyFlyObjs:
    LDA.W SpriteStatus,X
    CMP.B #$0C
    BEQ CODE_01C255
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01C255                           ; /
    LDA.B SpriteNumber,X
    CMP.B #$7D
    BNE +
    LDA.W SpriteMisc1540,X
    BEQ +
    LDA.B SpriteProperties
    PHA
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
    JSR CODE_01C61A
    PLA
    STA.B SpriteProperties
    LDA.B #$F8
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty
    RTS

  + LDA.B TrueFrame
    AND.B #$01
    BNE +
    LDA.W SpriteMisc151C,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W DATA_01C1EE,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_01C1F0,Y
    BNE +
    INC.W SpriteMisc151C,X
  + LDA.B #$0C
    STA.B SpriteXSpeed,X
    JSR SubSprXPosNoGrvty
    LDA.B SpriteYSpeed,X
    PHA
    CLC
    SEC
    SBC.B #$02
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty
    PLA
    STA.B SpriteYSpeed,X
    JSR SubOffscreen0Bnk1
    INC.W SpriteMisc1570,X
CODE_01C255:
    LDA.B SpriteNumber,X
    CMP.B #$7D
    BNE CODE_01C262
    LDA.B #$01
    STA.W SpriteMisc157C,X
    BRA CODE_01C27F

CODE_01C262:
    LDA.B SpriteTableC2,X
    CMP.B #$02
    BNE CODE_01C27C
    LDA.B TrueFrame
    AND.B #$03
    BNE +
    JSR CODE_01B14E
  + LDA.B EffFrame
    LSR A
    AND.B #$0E
    EOR.W SpriteOBJAttribute,X
    STA.W SpriteOBJAttribute,X
CODE_01C27C:
    JSR CODE_019E95
CODE_01C27F:
    LDA.B SpriteTableC2,X
    BEQ +
    JSR GetDrawInfoBnk1
    RTS

  + JSR CODE_01C61A
    JSR MarioSprInteractRt
    BCC Return01C2D2
    LDA.B SpriteNumber,X
    CMP.B #$7E
    BNE CODE_01C2A6
    JSR CODE_01C4F0
    LDA.B #$05
    JSL ADDR_05B329
    LDA.B #$03
    JSL GivePoints
    BRA ADDR_01C30F

CODE_01C2A6:
    CMP.B #$7F
    BNE CODE_01C2AF
    JSR GiveMario1Up
    BRA ADDR_01C30F

CODE_01C2AF:
    CMP.B #$80
    BNE CODE_01C2CE
    LDA.B PlayerYSpeed+1
    BMI Return01C2D2
    LDA.B #$09                                ; \ Sprite status = Carryable
    STA.W SpriteStatus,X                      ; /
    LDA.B #$D0
    STA.B PlayerYSpeed+1
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    STZ.W SpriteMisc1540,X
    LDA.W SpriteTweakerD,X                    ; \ Use default interation with Mario
    AND.B #$7F                                ; |
    STA.W SpriteTweakerD,X                    ; /
    RTS

CODE_01C2CE:
    CMP.B #$7D
    BEQ +
Return01C2D2:
    RTS

  + LDY.B #$0B
CODE_01C2D5:
    LDA.W SpriteStatus,Y
    CMP.B #$0B
    BNE +
    LDA.W SpriteNumber,Y
    CMP.B #$7D
    BEQ +
    LDA.B #$09                                ; \ Sprite status = Carryable
    STA.W SpriteStatus,Y                      ; /
  + DEY
    BPL CODE_01C2D5
    LDA.B #$00
    LDY.W PBalloonInflating
    BNE +
    LDA.B #$0B                                ; \ Sprite status = Being carried
  + STA.W SpriteStatus,X                      ; /
    LDA.B PlayerYSpeed+1
    STA.B SpriteYSpeed,X
    LDA.B PlayerXSpeed+1
    STA.B SpriteXSpeed,X
    LDA.B #$09
    STA.W PBalloonInflating
    LDA.B #$FF
    STA.W PBalloonTimer
    LDA.B #!SFX_PBALLOON                      ; \ Play sound effect
    STA.W SPCIO0                              ; /
    RTS

ADDR_01C30F:
    STZ.W SpriteStatus,X
    RTS


ChangingItemSprite:
    db $74,$75,$77,$76

ChangingItem:
    LDA.B #$01
    STA.W SpriteMisc151C,X
    LDA.W SpriteOnYoshiTongue,X
    BNE +
if ver_is_pal(!_VER)                          ;\=================== E0 & E1 ===================
    INC.W SpriteMisc187B,X                    ;!
endif                                         ;/===============================================
    INC.W SpriteMisc187B,X
  + LDA.W SpriteMisc187B,X                    ; \ Determine which power-up to act like
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    AND.B #$03                                ; |
    TAY                                       ; |
    LDA.W ChangingItemSprite,Y                ;  /
    STA.B SpriteNumber,X                      ; \ Change into the appropriate power up
    JSL LoadSpriteTables                      ; /
    JSR PowerUpRt                             ; Run the power up code
    LDA.B #$81                                ; \ Change it back to the turning item
    STA.B SpriteNumber,X                      ; |
    JSL LoadSpriteTables                      ; /
    RTS


EatenBerryGfxProp:
    db $02,$02,$04,$06

FireFlower:
    LDA.B EffFrame                            ; \ Flip flower every 8 frames
    AND.B #$08                                ; |
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; | ($157C,x = 0 or 1)
    STA.W SpriteMisc157C,X                    ; /
PowerUpRt:
    LDA.W SpriteMisc160E,X
    BEQ +
    JSR SubSprGfx2Entry1
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$80                                ; \ Set berry tile to OAM
    STA.W OAMTileNo+$100,Y                    ; /
    PHX                                       ; \ Set gfx properties of berry
    LDX.W EatenBerryType                      ; | X = type of berry being eaten
    %LorW_X(LDA,EatenBerryGfxProp)            ; |
    ORA.B SpriteProperties                    ; |
    STA.W OAMTileAttr+$100,Y                  ; /
    PLX                                       ; X = sprite index
    RTS

  + LDA.B SpriteProperties
    PHA
    JSR CODE_01C4AC
    LDA.W SpriteMisc1534,X
    BEQ CODE_01C38F
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    LDA.B #$10
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty
  + LDA.B EffFrame
    AND.B #$0C
    BNE CODE_01C3AB
    PLA
    RTS

CODE_01C38F:
    LDA.W SpriteMisc1540,X
    BEQ CODE_01C3AE
    JSR CODE_019140
    LDA.W SpriteMisc1528,X
    BNE +
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
  + LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01C3AB                           ; /
    LDA.B #$FC
    STA.B SpriteYSpeed,X
    JSR SubSprYPosNoGrvty
CODE_01C3AB:
    JMP CODE_01C48D

CODE_01C3AE:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01C3AB                           ; /
    LDA.W SpriteStatus,X
    CMP.B #$0C
    BEQ CODE_01C3AB
    LDA.B SpriteNumber,X
    CMP.B #$76                                ; \ Useless code, branch nowhere if not a star
    BNE +                                     ; /
  + INC.W SpriteMisc1570,X
    JSR CODE_018DBB
    LDA.B SpriteNumber,X
    CMP.B #$75                                ; flower
    BNE +
    LDA.W SpriteMisc151C,X
    BNE +
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
  + CMP.B #$76                                ; star
    BEQ +
    CMP.B #$21                                ; sprite coin
    BEQ +
    LDA.W SpriteMisc151C,X
    BNE +
    ASL.B SpriteXSpeed,X
  + LDA.B SpriteTableC2,X
    BEQ CODE_01C3F3
    BMI +
    JSR CODE_019140
    LDA.W SpriteBlockedDirs,X
    BNE +
    STZ.B SpriteTableC2,X
  + BRA CODE_01C437

CODE_01C3F3:
    LDA.W IRQNMICommand
    CMP.B #$C1
    BEQ CODE_01C42C
    BIT.W IRQNMICommand
    BVC CODE_01C42C
    STZ.W SpriteBlockedDirs,X
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    LDA.W SpriteYPosHigh,X
    BNE +
    LDA.B SpriteYPosLow,X
    CMP.B #$A0
    BCC +
    AND.B #$F0
    STA.B SpriteYPosLow,X
    LDA.W SpriteBlockedDirs,X
    ORA.B #$04
    STA.W SpriteBlockedDirs,X
    JSR CODE_018DBB
  + JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
    INC.B SpriteYSpeed,X
    INC.B SpriteYSpeed,X
    INC.B SpriteYSpeed,X
    BRA +

CODE_01C42C:
    JSR SubUpdateSprPos
  + LDA.B TrueFrame
    AND.B #$03
    BEQ CODE_01C437
    DEC.B SpriteYSpeed,X
CODE_01C437:
    JSR SubOffscreen0Bnk1
    JSR IsTouchingCeiling
    BEQ +
    LDA.B #$00
    STA.B SpriteYSpeed,X
  + JSR IsOnGround
    BNE CODE_01C44A
    BRA CODE_01C47E

CODE_01C44A:
    LDA.B SpriteNumber,X
    CMP.B #$21                                ; sprite coin
    BNE CODE_01C46C
    JSR CODE_018DBB
    LDA.B SpriteYSpeed,X
    INC A
    PHA
    JSR SetSomeYSpeed__
    PLA
    LSR A
    JSR CODE_01CCEC
    CMP.B #$FC
    BCS +
    LDY.W SpriteBlockedDirs,X
    BMI +
    STA.B SpriteYSpeed,X
  + BRA CODE_01C47E

CODE_01C46C:
    JSR SetSomeYSpeed__
    LDA.W SpriteMisc151C,X
    BNE CODE_01C47A
    LDA.B SpriteNumber,X
    CMP.B #$76                                ; star
    BNE CODE_01C47E
CODE_01C47A:
    LDA.B #$C8
    STA.B SpriteYSpeed,X
CODE_01C47E:
    LDA.W SpriteMisc1558,X
    ORA.B SpriteTableC2,X
    BNE CODE_01C48D
    JSR IsTouchingObjSide
    BEQ CODE_01C48D
    JSR FlipSpriteDir
CODE_01C48D:
    LDA.W SpriteMisc1540,X
    CMP.B #$36
    BCS CODE_01C4A8
    LDA.B SpriteTableC2,X
    BEQ CODE_01C49C
    CMP.B #$FF
    BNE CODE_01C4A1
CODE_01C49C:
    LDA.W SpriteBehindScene,X
    BEQ +
CODE_01C4A1:
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
  + JSR CODE_01C61A
CODE_01C4A8:
    PLA
    STA.B SpriteProperties
  - RTS

CODE_01C4AC:
    JSR CODE_01A80F
    BCC -
    LDA.W SpriteMisc151C,X
    BEQ CODE_01C4BA
    LDA.B SpriteTableC2,X
    BNE Return01C4FA
CODE_01C4BA:
    LDA.W SpriteMisc154C,X
    BNE Return01C4FA
CODE_01C4BF:
    LDA.W SpriteMisc1540,X
    CMP.B #$18
    BCS Return01C4FA
    STZ.W SpriteStatus,X
    LDA.B SpriteNumber,X
    CMP.B #$21
    BNE TouchedPowerUp
    JSL CODE_05B34A
    LDA.W SpriteOBJAttribute,X
    AND.B #$0E
    CMP.B #$02
    BEQ CODE_01C4E0
    LDA.B #$01
    BRA +

CODE_01C4E0:
    LDA.W SilverCoinsCollected
    INC.W SilverCoinsCollected
    CMP.B #$0A
    BCC +
    LDA.B #$0A
  + JSL GivePoints
CODE_01C4F0:
    LDY.B #$03
CODE_01C4F2:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_01C4FB
    DEY
    BPL CODE_01C4F2
Return01C4FA:
    RTS

CODE_01C4FB:
    LDA.B #$05
    STA.W SmokeSpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SmokeSpriteXPos,Y
    LDA.B SpriteYPosLow,X
    STA.W SmokeSpriteYPos,Y
    LDA.B #$10
    STA.W SmokeSpriteTimer,Y
    RTS


ItemBoxSprite:
    db $00,$01,$01,$01,$00,$01,$04,$02
    db $00,$00,$00,$00,$00,$01,$04,$02
    db $00,$00,$00,$00

GivePowerPtrIndex:
    db $00,$01,$01,$01,$04,$04,$04,$01
    db $02,$02,$02,$02,$03,$03,$01,$03
    db $05,$05,$05,$05

TouchedPowerUp:
    SEC                                       ; \ Index created from...
    SBC.B #$74                                ; | ... powerup touched (upper 2 bits)
    ASL A                                     ; |
    ASL A                                     ; |
    ORA.B Powerup                             ; | ... Mario's status (lower 3 bits)
    TAY                                       ; /
    LDA.W ItemBoxSprite,Y                     ; \ Put appropriate item in item box
    BEQ +                                     ; |
    STA.W PlayerItembox                       ; /
    LDA.B #!SFX_ITEMRESERVED                  ; \
    STA.W SPCIO3                              ; / Play sound effect
  + LDA.W GivePowerPtrIndex,Y                 ; \ Call routine to change Mario's status
    JSL ExecutePtr                            ; /

    dw GiveMarioMushroom                      ; 0 - Big
    dw CODE_01C56F                            ; 1 - No change
    dw GiveMarioStar                          ; 2 - Star
    dw GiveMarioCape                          ; 3 - Cape
    dw GiveMarioFire                          ; 4 - Fire
    dw GiveMario1Up                           ; 5 - 1Up 13

    RTS

GiveMarioMushroom:
    LDA.B #$02                                ; \ Set growing action
    STA.B PlayerAnimation                     ; /
    LDA.B #$2F                                ; \
if ver_is_japanese(!_VER)                     ;\======================== J ====================
    STA.W PlayerAniTimer                      ;! | Set animation timer
else                                          ;<================ U, SS, E0, & E1 ==============
    STA.W PlayerAniTimer,Y                    ;! | Set animation timer
endif                                         ;/===============================================
    STA.B SpriteLock                          ; / Set lock sprites timer
    JMP CODE_01C56F                           ; JMP to next instruction?

CODE_01C56F:
    LDA.B #$04
    LDY.W SpriteMisc1534,X
    BNE +
    JSL GivePoints
  + LDA.B #!SFX_MUSHROOM                      ; \
    STA.W SPCIO0                              ; /
    RTS

CODE_01C580:
    LDA.B #$FF                                ; \ Set star timer
    STA.W InvinsibilityTimer                  ; /
    LDA.B #!BGM_STARPOWER
    STA.W SPCIO2                              ; / Change music
    ASL.W MusicBackup
    SEC
    ROR.W MusicBackup
    RTL

GiveMarioStar:
    JSL CODE_01C580
    BRA CODE_01C56F

GiveMarioCape:
    LDA.B #$02
    STA.B Powerup
    LDA.B #!SFX_FEATHER                       ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.B #$04
    JSL GivePoints
    JSL CODE_01C5AE
    INC.B SpriteLock
    RTS

CODE_01C5AE:
    LDA.B PlayerYPosScrRel+1
    ORA.B PlayerXPosScrRel+1
    BNE Return01C5EB
    LDA.B #$03
    STA.B PlayerAnimation
    LDA.B #$18
    STA.W PlayerAniTimer
    LDY.B #$03
CODE_01C5BF:
    LDA.W SmokeSpriteNumber,Y
    BEQ CODE_01C5D4
    DEY
    BPL CODE_01C5BF
    DEC.W SmokeSpriteSlotIdx
    BPL +
    LDA.B #$03
    STA.W SmokeSpriteSlotIdx
  + LDY.W SmokeSpriteSlotIdx
CODE_01C5D4:
    LDA.B #$81
    STA.W SmokeSpriteNumber,Y
    LDA.B #$1B
    STA.W SmokeSpriteTimer,Y
    LDA.B PlayerYPosNext
    CLC
    ADC.B #$08
    STA.W SmokeSpriteYPos,Y
    LDA.B PlayerXPosNext
    STA.W SmokeSpriteXPos,Y
Return01C5EB:
    RTL

GiveMarioFire:
    LDA.B #$20
    STA.W CyclePaletteTimer
    STA.B SpriteLock
    LDA.B #$04
    STA.B PlayerAnimation
    LDA.B #$03
    STA.B Powerup
    JMP CODE_01C56F

GiveMario1Up:
    LDA.B #$08
    CLC
    ADC.W SpriteMisc1594,X
    JSL GivePoints
    RTS


PowerUpTiles:
    db $24,$26,$48,$0E,$24,$00,$00,$00
    db $00,$E4,$E8,$24,$EC

StarPalValues:
    db $00,$04,$08,$04

CODE_01C61A:
    JSR GetDrawInfoBnk1
    STZ.B _A
    LDA.W ReznorOAMIndex
    BNE +
    LDA.W IRQNMICommand
    CMP.B #$C1
    BEQ +
    BIT.W IRQNMICommand
    BVC +
    LDA.B #$D8
    STA.W SpriteOAMIndex,X
    TAY
  + LDA.B SpriteNumber,X
    CMP.B #$21                                ; sprite coin
    BNE PowerUpGfxRt
    JSL CoinSprGfx
    RTS

CoinSprGfx:
    JSR CoinSprGfxSub
    RTL

CoinSprGfxSub:
    JSR GetDrawInfoBnk1
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    LDA.B #$E8
    STA.W OAMTileNo+$100,Y
    LDA.W SpriteOBJAttribute,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    TXA
    CLC
    ADC.B EffFrame
    LSR A
    LSR A
    AND.B #$03
    BNE CODE_01C670
    LDY.B #$02
    BRA +


MovingCoinTiles:
    db $EA,$FA,$EA

CODE_01C670:
    PHX
    TAX
    LDA.B _0
    CLC
    ADC.B #$04
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    CLC
    ADC.B #$08
    STA.W OAMTileYPos+$104,Y
    LDA.L MovingCoinTiles-1,X
    STA.W OAMTileNo+$100,Y
    STA.W OAMTileNo+$104,Y
    LDA.W OAMTileAttr+$100,Y
    ORA.B #$80
    STA.W OAMTileAttr+$104,Y
    PLX
    LDY.B #$00
  + LDA.B #$01
    JSL FinishOAMWrite
    RTS

PowerUpGfxRt:
    CMP.B #$76                                ; \ Setup flashing palette for star
    BNE +                                     ; |
    LDA.B TrueFrame                           ; |
    LSR A                                     ; |
    AND.B #$03                                ; |
    PHY                                       ; |
    TAY                                       ; |
    LDA.W StarPalValues,Y                     ; |
    PLY                                       ; |
    STA.B _A                                  ; / $0A contains palette info, will be applied later
  + LDA.B _0                                  ; \ Set tile x position
    STA.W OAMTileXPos+$100,Y                  ; /
    LDA.B _1                                  ; \ Set tile y position
    DEC A                                     ; |
    STA.W OAMTileYPos+$100,Y                  ; /
    LDA.W SpriteMisc157C,X                    ; \ Flip flower/cape if 157C,x is set
    LSR A                                     ; |
    LDA.B #$00                                ; |
    BCS +                                     ; |
    ORA.B #!OBJ_XFlip                         ; /
  + ORA.B SpriteProperties                    ; \ Add in level priority information
    ORA.W SpriteOBJAttribute,X                ; | Add in palette/gfx page
    EOR.B _A                                  ; | Adjust palette for star
    STA.W OAMTileAttr+$100,Y                  ; / Set property byte
    LDA.B SpriteNumber,X                      ; \ Set powerup tile
    SEC                                       ; |
    SBC.B #$74                                ; |
    TAX                                       ; | X = Sprite number - #$74
    LDA.W PowerUpTiles,X                      ; |
    STA.W OAMTileNo+$100,Y                    ; /
    LDX.W CurSpriteProcess                    ; X = sprite index
    LDA.B #$00
    JSR CODE_01B37E
    RTS


DATA_01C6E6:
    db $02,$FE

DATA_01C6E8:
    db $20,$E0

DATA_01C6EA:
    db $0A,$F6,$08

Feather:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01C744                           ; /
    LDA.B SpriteTableC2,X
    BEQ CODE_01C701
    JSR CODE_019140
    LDA.W SpriteBlockedDirs,X
    BNE +
    STZ.B SpriteTableC2,X
  + BRA CODE_01C741

CODE_01C701:
    LDA.W SpriteStatus,X
    CMP.B #$0C
    BEQ CODE_01C744
    LDA.W SpriteMisc154C,X
    BEQ +
    JSR SubSprYPosNoGrvty
    INC.B SpriteYSpeed,X
    JMP CODE_01C741

  + LDA.W SpriteMisc1528,X
    AND.B #$01
    TAY
    LDA.B SpriteXSpeed,X
    CLC
    ADC.W DATA_01C6E6,Y
    STA.B SpriteXSpeed,X
    CMP.W DATA_01C6E8,Y
    BNE +
    INC.W SpriteMisc1528,X
  + LDA.B SpriteXSpeed,X
    BPL +
    INY
  + LDA.W DATA_01C6EA,Y
    CLC
    ADC.B #$06
    STA.B SpriteYSpeed,X
    JSR SubOffscreen0Bnk1
    JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
CODE_01C741:
    JSR UpdateDirection
CODE_01C744:
    JSR CODE_01C4AC
    JMP CODE_01C61A

InitBrwnChainPlat:
    LDA.B #$80
    STA.W SpriteMisc151C,X
    LDA.B #$01
    STA.W SpriteMisc1528,X
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$78
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$68
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    RTS

BrownChainedPlat:
    JSR SubOffscreen2Bnk1
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01C795                           ; /
    LDA.B TrueFrame
    AND.B #$03
    ORA.W SpriteMisc1602,X
    BNE CODE_01C795
    LDA.B #$01
    LDY.W SpriteMisc1504,X
    BEQ CODE_01C795
    BMI +
    LDA.B #$FF
  + CLC
    ADC.W SpriteMisc1504,X
    STA.W SpriteMisc1504,X
CODE_01C795:
    LDA.W SpriteMisc151C,X
    PHA
    LDA.W SpriteMisc1528,X
    PHA
    LDA.B #$00
    SEC
    SBC.W SpriteMisc151C,X
    STA.W SpriteMisc151C,X
    LDA.B #$02
    SBC.W SpriteMisc1528,X
    AND.B #$01
    STA.W SpriteMisc1528,X
    JSR CODE_01CACB
    JSR CODE_01CB20
    JSR CODE_01CB53
    PLA
    STA.W SpriteMisc1528,X
    PLA
    STA.W SpriteMisc151C,X
    LDA.W BrSwingPlatXPos
    PHA
    SEC
    SBC.B SpriteTableC2,X
    STA.W SpriteXMovement
    PLA
    STA.B SpriteTableC2,X
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W BrSwingPlatYPos
    SEC
    SBC.B Layer1YPos
    SEC
    SBC.B #$08
    STA.W OAMTileYPos+$100,Y
    LDA.W BrSwingPlatXPos
    SEC
    SBC.B Layer1XPos
    SEC
    SBC.B #$08
    STA.W OAMTileXPos+$100,Y
    LDA.B #$A2
    STA.W OAMTileNo+$100,Y
    LDA.B #$31
    STA.W OAMTileAttr+$100,Y
    LDY.B #$00
    LDA.W BrSwingPlatYPos
    SEC
    SBC.W BrSwingCenterYPos
    BPL +
    EOR.B #$FF
    INC A
    INY
  + STY.B _0
    STA.W HW_WRDIV+1
    STZ.W HW_WRDIV
    LDA.B #$05
    STA.W HW_WRDIV+2
    JSR DoNothing
    LDA.W HW_RDDIV
    STA.B _2
    STA.B _6
    LDA.W HW_RDDIV+1
    STA.B _3
    STA.B _7
    LDY.B #$00
    LDA.W BrSwingPlatXPos
    SEC
    SBC.W BrSwingCenterXPos
    BPL +
    EOR.B #$FF
    INC A
    INY
  + STY.B _1
    STA.W HW_WRDIV+1
    STZ.W HW_WRDIV
    LDA.B #$05
    STA.W HW_WRDIV+2
    JSR DoNothing
    LDA.W HW_RDDIV
    STA.B _4
    STA.B _8
    LDA.W HW_RDDIV+1
    STA.B _5
    STA.B _9
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    INY
    INY
    INY
    INY
    LDA.W BrSwingCenterYPos
    SEC
    SBC.B Layer1YPos
    SEC
    SBC.B #$08
    STA.B _A
    STA.W OAMTileYPos+$100,Y
    LDA.W BrSwingCenterXPos
    SEC
    SBC.B Layer1XPos
    SEC
    SBC.B #$08
    STA.B _B
    STA.W OAMTileXPos+$100,Y
    LDA.B #$A2
    STA.W OAMTileNo+$100,Y
    LDA.B #$31
    STA.W OAMTileAttr+$100,Y
    LDX.B #$03
CODE_01C87C:
    INY
    INY
    INY
    INY
    LDA.B _0
    BNE CODE_01C88E
    LDA.B _A
    CLC
    ADC.B _7
    STA.W OAMTileYPos+$100,Y
    BRA +

CODE_01C88E:
    LDA.B _A
    SEC
    SBC.B _7
    STA.W OAMTileYPos+$100,Y
  + LDA.B _6
    CLC
    ADC.B _2
    STA.B _6
    LDA.B _7
    ADC.B _3
    STA.B _7
    LDA.B _1
    BNE CODE_01C8B1
    LDA.B _B
    CLC
    ADC.B _9
    STA.W OAMTileXPos+$100,Y
    BRA +

CODE_01C8B1:
    LDA.B _B
    SEC
    SBC.B _9
    STA.W OAMTileXPos+$100,Y
  + LDA.B _8
    CLC
    ADC.B _4
    STA.B _8
    LDA.B _9
    ADC.B _5
    STA.B _9
    LDA.B #$A2
    STA.W OAMTileNo+$100,Y
    LDA.B #$31
    STA.W OAMTileAttr+$100,Y
    DEX
    BPL CODE_01C87C
    LDX.B #$03
  - STX.B _2
    INY
    INY
    INY
    INY
    LDA.W BrSwingPlatYPos
    SEC
    SBC.B Layer1YPos
    SEC
    SBC.B #$10
    STA.W OAMTileYPos+$100,Y
    LDA.W BrSwingPlatXPos
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.W DATA_01C9B7,X
    STA.W OAMTileXPos+$100,Y
    LDA.W BrwnChainPlatTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.B #$31
    STA.W OAMTileAttr+$100,Y
    DEX
    BPL -
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B #$09
    STA.B _8
    LDA.W BrSwingCenterYPos
    SEC
    SBC.B #$08
    STA.B _0
    LDA.W BrSwingCenterYPos+1
    SBC.B #$00
    STA.B _1
    LDA.W BrSwingCenterXPos
    SEC
    SBC.B #$08
    STA.B _2
    LDA.W BrSwingCenterXPos+1
    SBC.B #$00
    STA.B _3
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileYPos+$104,Y
    STA.B _6
    LDA.W OAMTileXPos+$104,Y
    STA.B _7
CODE_01C934:
    TYA
    LSR A
    LSR A
    TAX
    LDA.B #$02
    STA.W OAMTileSize+$40,X
    LDX.B #$00
    LDA.W OAMTileXPos+$100,Y
    SEC
    SBC.B _7
    BPL +
    DEX
  + CLC
    ADC.B _2
    STA.B _4
    TXA
    ADC.B _3
    STA.B _5
    JSR CODE_01B844
    BCC +
    TYA
    LSR A
    LSR A
    TAX
    LDA.B #$03
    STA.W OAMTileSize+$40,X
  + LDX.B #$00
    LDA.W OAMTileYPos+$100,Y
    SEC
    SBC.B _6
    BPL +
    DEX
  + CLC
    ADC.B _0
    STA.B _9
    TXA
    ADC.B _1
    STA.B _A
    JSR CODE_01C9BF
    BCC +
    LDA.B #$F0
    STA.W OAMTileYPos+$100,Y
  + LDA.B _8
    CMP.B #$09
    BNE +
    LDA.B _4
    STA.W BrSwingPlatXPos
    LDA.B _5
    STA.W BrSwingPlatXPos+1
    LDA.B _9
    STA.W BrSwingPlatYPos
    LDA.B _A
    STA.W BrSwingPlatYPos+1
  + INY
    INY
    INY
    INY
    DEC.B _8
    BPL CODE_01C934
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$F0
    STA.W OAMTileYPos+$104,Y
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    JSR CODE_01CCF0
    JMP CODE_01C9EC

  + RTS


DATA_01C9B7:
    db $E0,$F0,$00,$10

BrwnChainPlatTiles:
    db $60,$61,$61,$62

CODE_01C9BF:
    REP #$20                                  ; A->16
    LDA.B _9
    PHA
    CLC
    ADC.W #$0010
    STA.B _9
    SEC
    SBC.B Layer1YPos
    CMP.W #$0100
    PLA
    STA.B _9
    SEP #$20                                  ; A->8
Return01C9D5:
    RTS


DATA_01C9D6:
    db $01,$FF

DATA_01C9D8:
    db $40,$C0

CODE_01C9DA:
    LDA.W SpriteMisc160E,X
    BEQ +
    STZ.W SpriteMisc160E,X
CODE_01C9E2:
    PHX
    JSL DrawMarioAndYoshi
    PLX
    STX.W CurSpriteProcess
  + RTS

CODE_01C9EC:
    LDA.W BrSwingPlatXPos+1
    XBA
    LDA.W BrSwingPlatXPos
    REP #$20                                  ; A->16
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.W #$0010
    CMP.W #$0120
    SEP #$20                                  ; A->8
    ROL A
    AND.B #$01
    ORA.B SpriteLock
    STA.W SpriteWayOffscreenX,X
    BNE Return01C9D5
    JSR CODE_01CA9C
    STZ.W SpriteMisc1602,X
    BCC CODE_01C9DA
    LDA.B #$01
    STA.W SpriteMisc160E,X
    LDA.W BrSwingPlatYPos
    SEC
    SBC.B Layer1YPos
    STA.B _3
    SEC
    SBC.B #$08
    STA.B _E
    LDA.B PlayerYPosScrRel
    CLC
    ADC.B #$18
    CMP.B _E
    BCS Return01CA9B
    LDA.B PlayerYSpeed+1
    BMI CODE_01C9E2
    STZ.B PlayerYSpeed+1
    LDA.B #$03
    STA.W StandOnSolidSprite
    STA.W SpriteMisc1602,X
    LDA.B #$28
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$38
  + STA.B _F
    LDA.W BrSwingPlatYPos
    SEC
    SBC.B _F
    STA.B PlayerYPosNext
    LDA.W BrSwingPlatYPos+1
    SBC.B #$00
    STA.B PlayerYPosNext+1
    LDA.B PlayerBlockedDir
    AND.B #$03
    BNE CODE_01CA6E
    LDY.B #$00
    LDA.W SpriteXMovement
    BPL +
    DEY
  + CLC
    ADC.B PlayerXPosNext
    STA.B PlayerXPosNext
    TYA
    ADC.B PlayerXPosNext+1
    STA.B PlayerXPosNext+1
CODE_01CA6E:
    JSR CODE_01C9E2
    LDA.B byetudlrFrame
    BMI +
    LDA.B #$FF
    STA.B PlayerHiddenTiles
if ver_is_ntsc(!_VER)                         ;\=================== J, U, & SS ================
  + LDA.B TrueFrame                           ;!
    LSR A                                     ;!
    BCC Return01CA9B                          ;!
    LDA.W SpriteMisc151C,X                    ;!
    CLC                                       ;!
    ADC.B #$80                                ;!
    LDA.W SpriteMisc1528,X                    ;!
    ADC.B #$00                                ;!
    AND.B #$01                                ;!
    TAY                                       ;!
else                                          ;<===================== E0 & E1 =================
  + LDA.W SpriteMisc151C,X                    ;!
    CLC                                       ;!
    ADC.B #$80                                ;!
    LDA.W SpriteMisc1528,X                    ;!
    ADC.B #$00                                ;!
    AND.B #$01                                ;!
    TAY                                       ;!
    LDA.W SpriteMisc1504,X                    ;!
    BEQ +                                     ;!
    EOR.W DATA_01C9D8,Y                       ;!
    BPL +                                     ;!
    LDA.B TrueFrame                           ;!
    LSR A                                     ;!
    BCC Return01CA9B                          ;!
endif                                         ;/===============================================
  + LDA.W SpriteMisc1504,X
    CMP.W DATA_01C9D8,Y
    BEQ Return01CA9B
    CLC
    ADC.W DATA_01C9D6,Y
    STA.W SpriteMisc1504,X
Return01CA9B:
    RTS

CODE_01CA9C:
    LDA.W BrSwingPlatXPos
    SEC
    SBC.B #$18
    STA.B _4
    LDA.W BrSwingPlatXPos+1
    SBC.B #$00
    STA.B _A
    LDA.B #$40
    STA.B _6
    LDA.W BrSwingPlatYPos
    SEC
    SBC.B #$0C
    STA.B _5
    LDA.W BrSwingPlatYPos+1
    SBC.B #$00
    STA.B _B
    LDA.B #$13
    STA.B _7
    JSL GetMarioClipping
    JSL CheckForContact
    RTS

CODE_01CACB:
    LDA.B #$50
    STA.W BrSwingRadiusX
    STZ.W BrSwingRadiusY
    STZ.W BrSwingRadiusX+1
    STZ.W BrSwingRadiusY+1
    LDA.B SpriteXPosLow,X
    STA.W BrSwingXDist
    LDA.W SpriteXPosHigh,X
    STA.W BrSwingXDist+1
    LDA.W BrSwingXDist
    SEC
    SBC.W BrSwingRadiusX
    STA.W BrSwingCenterXPos
    LDA.W BrSwingXDist+1
    SBC.W BrSwingRadiusX+1
    STA.W BrSwingCenterXPos+1
    LDA.B SpriteYPosLow,X
    STA.W BrSwingYDist
    LDA.W SpriteYPosHigh,X
    STA.W BrSwingYDist+1
    LDA.W BrSwingYDist
    SEC
    SBC.W BrSwingRadiusY
    STA.W BrSwingCenterYPos
    LDA.W BrSwingYDist+1
    SBC.W BrSwingRadiusY+1
    STA.W BrSwingCenterYPos+1
    LDA.W SpriteMisc151C,X
    STA.B Mode7Angle
    LDA.W SpriteMisc1528,X
    STA.B Mode7Angle+1
    RTS

CODE_01CB20:
    LDA.B Mode7Angle+1
    STA.W BrSwingAngleParity
    PHX
    REP #$30                                  ; AXY->16
    LDA.B Mode7Angle
    ASL A
    AND.W #$01FF
    TAX
    LDA.L CircleCoords,X
    STA.W BrSwingSine
    LDA.B Mode7Angle
    CLC
    ADC.W #$0080
    STA.B _0
    ASL A
    AND.W #$01FF
    TAX
    LDA.L CircleCoords,X
    STA.W BrSwingCosine
    SEP #$30                                  ; AXY->8
    LDA.B _1
    STA.W BrSwingAngleParity+1
    PLX
    RTS

CODE_01CB53:
    REP #$20                                  ; A->16
    LDA.W BrSwingCosine
    STA.B _2
    LDA.W BrSwingRadiusX
    STA.B _0
    SEP #$20                                  ; A->8
    JSR CODE_01CC28
    LDA.W BrSwingAngleParity+1
    LSR A
    REP #$20                                  ; A->16
    LDA.B _4
    BCC +
    EOR.W #$FFFF
    INC A
  + STA.B _8
    LDA.B _6
    BCC +
    EOR.W #$FFFF
    INC A
  + STA.B _A
    LDA.W BrSwingSine
    STA.B _2
    LDA.W BrSwingRadiusY
    STA.B _0
    SEP #$20                                  ; A->8
    JSR CODE_01CC28
    LDA.W BrSwingAngleParity
    LSR A
    REP #$20                                  ; A->16
    LDA.B _4
    BCC +
    EOR.W #$FFFF
    INC A
  + STA.B _4
    LDA.B _6
    BCC +
    EOR.W #$FFFF
    INC A
  + STA.B _6
    LDA.B _4
    CLC
    ADC.B _8
    STA.B _4
    LDA.B _6
    ADC.B _A
    STA.B _6
    LDA.B _5
    CLC
    ADC.W BrSwingCenterXPos
    STA.W BrSwingPlatXPos
    LDA.W BrSwingCosine
    STA.B _2
    LDA.W BrSwingRadiusY
    STA.B _0
    SEP #$20                                  ; A->8
    JSR CODE_01CC28
    LDA.W BrSwingAngleParity+1
    LSR A
    REP #$20                                  ; A->16
    LDA.B _4
    BCC +
    EOR.W #$FFFF
    INC A
  + STA.B _8
    LDA.B _6
    BCC +
    EOR.W #$FFFF
    INC A
  + STA.B _A
    LDA.W BrSwingSine
    STA.B _2
    LDA.W BrSwingRadiusX
    STA.B _0
    SEP #$20                                  ; A->8
    JSR CODE_01CC28
    LDA.W BrSwingAngleParity
    LSR A
    REP #$20                                  ; A->16
    LDA.B _4
    BCC +
    EOR.W #$FFFF
    INC A
  + STA.B _4
    LDA.B _6
    BCC +
    EOR.W #$FFFF
    INC A
  + STA.B _6
    LDA.B _4
    SEC
    SBC.B _8
    STA.B _4
    LDA.B _6
    SBC.B _A
    STA.B _6
    LDA.W BrSwingCenterYPos
    SEC
    SBC.B _5
    STA.W BrSwingPlatYPos
    SEP #$20                                  ; A->8
    RTS

CODE_01CC28:
    LDA.B _0
    STA.W HW_WRMPYA
    LDA.B _2
    STA.W HW_WRMPYB
    JSR DoNothing
    LDA.W HW_RDMPY
    STA.B _4
    LDA.W HW_RDMPY+1
    STA.B _5
    LDA.B _0
    STA.W HW_WRMPYA
    LDA.B _3
    STA.W HW_WRMPYB
    JSR DoNothing
    LDA.W HW_RDMPY
    CLC
    ADC.B _5
    STA.B _5
    LDA.W HW_RDMPY+1
    ADC.B #$00
    STA.B _6
    LDA.B _1
    STA.W HW_WRMPYA
    LDA.B _2
    STA.W HW_WRMPYB
    JSR DoNothing
    LDA.W HW_RDMPY
    CLC
    ADC.B _5
    STA.B _5
    LDA.W HW_RDMPY+1
    ADC.B _6
    STA.B _6
    LDA.B _1
    STA.W HW_WRMPYA
    LDA.B _3
    STA.W HW_WRMPYB
    JSR DoNothing
    LDA.W HW_RDMPY
    CLC
    ADC.B _6
    STA.B _6
    LDA.W HW_RDMPY+1
    ADC.B #$00
    STA.B _7
    RTS

DoNothing:
    NOP                                       ; \ Do nothing at all
    NOP                                       ; |
    NOP                                       ; |
    NOP                                       ; |
    NOP                                       ; |
    NOP                                       ; |
    NOP                                       ; |
    NOP                                       ; |
    RTS                                       ; /

CODE_01CC9D:
    LDA.W IggyLarryPlatIntXPos+1
    ORA.W IggyLarryPlatIntYPos+1
    BNE +
    JSR CODE_01CCC7
    JSR CODE_01CB20
    JSR CODE_01CB53
    LDA.W IggyLarryTempYPos
    AND.B #$F0
    STA.B _0
    LDA.W IggyLarryTempXPos
    LSR A
    LSR A
    LSR A
    LSR A
    ORA.B _0
    TAY
    LDA.W IggyLarryPlatInteract,Y
    CMP.B #$15
    RTL

  + CLC
    RTL

CODE_01CCC7:
    REP #$20                                  ; A->16
    LDA.B Mode7CenterX
    STA.W IggyLarryRotCenterX
    LDA.B Mode7CenterY
    STA.W IggyLarryRotCenterY
    LDA.W IggyLarryPlatIntXPos
    SEC
    SBC.W IggyLarryRotCenterX
    STA.W BrSwingRadiusX
    LDA.W IggyLarryPlatIntYPos
    SEC
    SBC.W IggyLarryRotCenterY
    STA.W BrSwingRadiusY
    SEP #$20                                  ; A->8
    RTS

    RTS

    RTS

CODE_01CCEC:
    EOR.B #$FF
    INC A
    RTS

CODE_01CCF0:
    LDA.W SpriteMisc1504,X
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.W SpriteMisc1510,X
    STA.W SpriteMisc1510,X
    PHP
    LDY.B #$00
    LDA.W SpriteMisc1504,X
    LSR A
    LSR A
    LSR A
    LSR A
    CMP.B #$08
    BCC +
    ORA.B #$F0
    DEY
  + PLP
    ADC.W SpriteMisc151C,X
    STA.W SpriteMisc151C,X
    TYA
    ADC.W SpriteMisc1528,X
    STA.W SpriteMisc1528,X
    RTS

    %insert_empty($00,$0C,$0C,$06,$06)

PipeKoopaKids:
    JSL CODE_03CC09
    RTS

InitKoopaKid:
    LDA.B SpriteYPosLow,X
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B SpriteTableC2,X
    CMP.B #$05
    BCC +
    LDA.B #$78
    STA.B SpriteXPosLow,X
    LDA.B #$40
    STA.B SpriteYPosLow,X
    LDA.B #$01
    STA.W SpriteYPosHigh,X
    LDA.B #$80
    STA.W SpriteMisc1540,X
    RTS

  + LDY.B #$90
    STY.B SpriteYPosLow,X
    CMP.B #$03
    BCC +
    JSL CODE_00FCF5
    JSR FaceMario
    RTS

  + LDA.B #$01
    STA.W SpriteMisc157C,X
    LDA.B #$20
    STA.B Mode7XScale
    STA.B Mode7YScale
    JSL CODE_03DD7D
    LDY.B SpriteTableC2,X
    LDA.W DATA_01CD92,Y
    STA.W SpriteMisc187B,X
    CMP.B #$01
    BEQ CODE_01CD87
    CMP.B #$00
    BNE +
    LDA.B #$70
    STA.B SpriteXPosLow,X
  + LDA.B #$01
    STA.W SpriteXPosHigh,X
    RTS

CODE_01CD87:
    LDA.B #$26
    STA.W SpriteMisc1534,X
    LDA.B #$D8
    STA.W SpriteMisc160E,X
    RTS


DATA_01CD92:
    db $01,$01,$00,$02,$02,$03,$03

DATA_01CD99:
    db $00,$09,$12

DATA_01CD9C:
    db $00,$01,$02,$03,$04,$05,$06,$07
    db $08

DATA_01CDA5:
    db $00,$80

CODE_01CDA7:
    JSR GetDrawInfoBnk1
    RTS

WallKoopaKids:
    STZ.W PlayerIsFrozen
    LDA.W SpriteMisc1602,X
    CMP.B #$1B
    BCS CODE_01CDD5
    LDA.W SpriteMisc15AC,X
    CMP.B #$08
    LDY.W SpriteMisc157C,X
    LDA.W DATA_01CDA5,Y
    BCS +
    EOR.B #$80
  + STA.B _0
    LDY.B SpriteTableC2,X
    LDA.W DATA_01CD99,Y
    LDY.W SpriteMisc1602,X
    CLC
    ADC.W DATA_01CD9C,Y
    CLC
    ADC.B _0
CODE_01CDD5:
    STA.W Mode7TileIndex
    JSL CODE_03DEDF
    JSR CODE_01CDA7
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return01CE3D                          ; /
    JSR CODE_01D2A8
    JSR CODE_01D3B1
    LDA.W SpriteMisc187B,X
    CMP.B #$01
    BEQ +
    LDA.W SpriteMisc163E,X
    BNE +
    LDA.W SpriteMisc157C,X
    PHA
    JSR SubHorizPos
    TYA
    STA.W SpriteMisc157C,X
    PLA
    CMP.W SpriteMisc157C,X
    BEQ +
    LDA.B #$10                                ; \ Set turning timer
    STA.W SpriteMisc15AC,X                    ; /
  + LDA.W SpriteMisc151C,X
    JSL ExecutePtr

    dw CODE_01CE1E
    dw CODE_01CE3E
    dw CODE_01CE5F
    dw CODE_01CF7D
    dw CODE_01CFE0
    dw CODE_01D043

CODE_01CE1E:
    LDA.W SpriteMisc187B,X
    CMP.B #$01
    BNE +
    STZ.W HorizLayer1Setting
    INC.W BossPillarFalling
    STZ.W BossPillarYPos
    INC.B SpriteLock
    INC.W SpriteMisc151C,X
    RTS

  + LDA.B Layer1XPos
    CMP.B #$7E
    BCC Return01CE3D
    INC.W SpriteMisc151C,X
Return01CE3D:
    RTS

CODE_01CE3E:
    STZ.B PlayerXSpeed+1
    JSR SubSprYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +
    CLC
    ADC.B #$03
  + STA.B SpriteYSpeed,X
    JSR CODE_01D0C0
    BCC Return01CE3D
    INC.W SpriteMisc151C,X
    LDA.B SpriteTableC2,X
    CMP.B #$02
    BCC Return01CE3D
    JMP CODE_01CEA8

CODE_01CE5F:
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_01D116
    dw CODE_01D116
    dw CODE_01CE6B

CODE_01CE6B:
    LDA.W SpriteMisc1528,X
    JSL ExecutePtr

    dw CODE_01CE78
    dw CODE_01CEB6
    dw CODE_01CEFD

CODE_01CE78:
    STZ.B Mode7Angle
    STZ.B Mode7Angle+1
    LDA.W SpriteMisc1540,X
    BEQ CODE_01CEA5
    LDY.B #$03
    AND.B #$30
    BNE +
    INY
  + TYA
    LDY.W SpriteMisc15AC,X
    BEQ +
    LDA.B #$05
  + STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    AND.B #$3F
    CMP.B #$2E
    BNE +
    LDA.B #$30
    STA.W SpriteMisc163E,X
    JSR CODE_01D059
  + RTS

CODE_01CEA5:
    INC.W SpriteMisc1528,X
CODE_01CEA8:
    LDA.B #$FF
    STA.W SpriteMisc1540,X
    RTS


DATA_01CEAE:
    db $30,$D0

DATA_01CEB0:
    db $1B,$1C,$1D,$1B

DATA_01CEB4:
    db $14,$EC

CODE_01CEB6:
    LDA.W SpriteMisc1540,X
    BNE +
    JSR SubHorizPos
    TYA
    CMP.W SpriteXPosHigh,X
    BNE +
    INC.W SpriteMisc1528,X
    LDA.W DATA_01CEB4,Y
    STA.W SpriteMisc160E,X
    LDA.B #$30
    STA.W SpriteMisc1540,X
    LDA.B #$60
    STA.W SpriteMisc1558,X
    LDA.B #$D8
    STA.B SpriteYSpeed,X
    RTS

  + JSR SubHorizPos
    LDA.B SpriteXSpeed,X
    CMP.W DATA_01CEAE,Y
    BEQ +
    CLC
    ADC.W DATA_01D4E7,Y
    STA.B SpriteXSpeed,X
  + JSR SubSprXPosNoGrvty
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W DATA_01CEB0,Y
    STA.W SpriteMisc1602,X
    RTS

CODE_01CEFD:
    LDA.W SpriteMisc1540,X
    BEQ CODE_01CF1C
    DEC A
    BNE +
    LDA.W SpriteMisc160E,X
    STA.B SpriteXSpeed,X
    LDA.B #!SFX_SPRING                        ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + LDA.B SpriteXSpeed,X
    BEQ Return01CF1B
    BPL +
    INC.B SpriteXSpeed,X
    INC.B SpriteXSpeed,X
  + DEC.B SpriteXSpeed,X
Return01CF1B:
    RTS

CODE_01CF1C:
    JSR CODE_01D0C0
    BCC +
    LDA.B SpriteYSpeed,X
    BMI +
    STZ.B SpriteXSpeed,X                      ; \ Sprite Speed = 0
    STZ.B SpriteYSpeed,X                      ; /
    STZ.W SpriteMisc1528,X
    JMP CODE_01CEA8

  + JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
    LDA.B TrueFrame
    LSR A
    BCS CODE_01CF44
    LDA.B SpriteYSpeed,X
    BMI CODE_01CF42
    CMP.B #$70
    BCS CODE_01CF44
CODE_01CF42:
    INC.B SpriteYSpeed,X
CODE_01CF44:
    LDA.W SpriteMisc1558,X
    BNE CODE_01CF4F
    LDA.B Mode7Angle
    ORA.B Mode7Angle+1
    BEQ CODE_01CF67
CODE_01CF4F:
    LDA.B SpriteXSpeed,X
    ASL A
    LDA.B #$04
    LDY.B #$00
    BCC +
    LDA.B #$FC
    DEY
  + CLC
    ADC.B Mode7Angle
    STA.B Mode7Angle
    TYA
    ADC.B Mode7Angle+1
    AND.B #$01
    STA.B Mode7Angle+1
CODE_01CF67:
    LDA.B #$06
    LDY.B SpriteYSpeed,X
    BMI +
    CPY.B #$08
    BCC +
    LDA.B #$05
    CPY.B #$10
    BCC +
    LDA.B #$02
  + STA.W SpriteMisc1602,X
    RTS

CODE_01CF7D:
    JSR SubSprYPosNoGrvty
    INC.B SpriteYSpeed,X
    JSR CODE_01D0C0
    LDA.W SpriteMisc1540,X
    BEQ CODE_01CFB7
    CMP.B #$40
    BCC CODE_01CF9E
    BEQ CODE_01CFC6
    LDY.B #$06
    LDA.B EffFrame
    AND.B #$04
    BEQ +
    INY
  + TYA
    STA.W SpriteMisc1602,X
    RTS

CODE_01CF9E:
    LDY.W Empty18A6
    LDA.B Mode7XScale
    CMP.B #$20
    BEQ +
    INC.B Mode7XScale
  + LDA.B Mode7YScale
    CMP.B #$20
    BEQ +
    DEC.B Mode7YScale
  + LDA.B #$07
    STA.W SpriteMisc1602,X
    RTS

CODE_01CFB7:
    LDA.B #$02
    STA.W SpriteMisc151C,X
    LDA.B SpriteTableC2,X
    BEQ +
    LDA.B #$20
    STA.W SpriteInLiquid,X
  + RTS

CODE_01CFC6:
    INC.W SpriteMisc1626,X
    LDA.W SpriteMisc1626,X
    CMP.B #$03
    BCC +
CODE_01CFD0:
    LDA.B #!SFX_BOSSDEAD                      ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.B #$04
    STA.W SpriteMisc151C,X
    LDA.B #$13
    STA.W SpriteMisc1540,X
  + RTS

CODE_01CFE0:
    LDY.W SpriteMisc1540,X
    BEQ CODE_01CFFC
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B #$01
    STA.B SpriteYPosLow,X
    BCS +
    DEC.W SpriteYPosHigh,X
  + DEC.B Mode7YScale
    TYA
    AND.B #$03
    BEQ +
    DEC.B Mode7XScale
  + BRA +

CODE_01CFFC:
    LDA.B Mode7Angle
    CLC
    ADC.B #$06
    STA.B Mode7Angle
    LDA.B Mode7Angle+1
    ADC.B #$00
    AND.B #$01
    STA.B Mode7Angle+1
    INC.B Mode7XScale
    INC.B Mode7YScale
  + LDA.B Mode7YScale
    CMP.B #con($A0,$A0,$A0,$80,$80)
    BCC Return01D042
    LDA.W SpriteOffscreenX,X
    BNE +
    LDA.B #$01
    STA.W SmokeSpriteNumber
    LDA.B SpriteXPosLow,X
    SBC.B #$08
    STA.W SmokeSpriteXPos
    LDA.B SpriteYPosLow,X
    ADC.B #$08
    STA.W SmokeSpriteYPos
    LDA.B #$1B
    STA.W SmokeSpriteTimer
  + LDA.B #$D0
    STA.B SpriteYPosLow,X
    JSL CODE_03DEDF
    INC.W SpriteMisc151C,X
    LDA.B #$30
    STA.W SpriteMisc1540,X
Return01D042:
    RTS

CODE_01D043:
    LDA.W SpriteMisc1540,X
    BNE +
    INC.W CutsceneID
    DEC.W EndLevelTimer
    LDA.B #!BGM_BOSSCLEAR
    STA.W SPCIO2                              ; / Change music
    STZ.W SpriteStatus,X
  + RTS


DATA_01D057:
    db $FF,$F1

CODE_01D059:
    LDA.B #!SFX_FIRESPIT                      ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDY.B #$04
CODE_01D060:
    LDA.W SpriteStatus,Y
    BEQ CODE_01D069
    DEY
    BPL CODE_01D060
    RTS

CODE_01D069:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$34
    STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.W SpriteXPosHigh,X
    STA.B _1
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$03
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    LDA.W SpriteMisc157C,X
    PHX
    TAX
    LDA.B _0
    CLC
    ADC.W DATA_01D057,X
    STA.W SpriteXPosLow,Y
    LDA.B _1
    ADC.B #$FF
    STA.W SpriteXPosHigh,Y
    PLX
    PHX
    TYX
    JSL InitSpriteTables
    PLX
    PHX
    LDA.W SpriteMisc157C,X
    STA.W SpriteMisc157C,Y
    TAX
    LDA.W DATA_01D0BE,X
    STA.W SpriteXSpeed,Y
    LDA.B #$30
    STA.W SpriteMisc1540,Y
    PLX
    RTS


DATA_01D0BE:
    db $20,$E0

CODE_01D0C0:
    LDA.B SpriteYSpeed,X
    BMI +
    LDA.W SpriteYPosHigh,X
    BNE +
    LDA.B Mode7YScale
    LSR A
    TAY
    LDA.B SpriteYPosLow,X
    CMP.W DATA_01D0DE-8,Y
    BCC +
    LDA.W DATA_01D0DE-8,Y
    STA.B SpriteYPosLow,X
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    RTS

  + CLC
    RTS


DATA_01D0DE:
    db $80,$83,$85,$88,$8A,$8B,$8D,$8F
    db $90,$91,$91,$92,$92,$93,$93,$94
    db $94,$95,$95,$96,$96,$97,$97,$98
    db $98,$98,$99,$99,$9A,$9A,$9B,$9B
    db $9C,$9C,$9C,$9C,$9D,$9D,$9D,$9D
    db $9E,$9E,$9E,$9E,$9E,$9F,$9F,$9F
    db $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F

CODE_01D116:
    LDA.W SpriteMisc1528,X
    JSL ExecutePtr

    dw CODE_01D146
    dw CODE_01D23F

    RTS


DATA_01D122:
    db $F0,$00,$10,$00,$F0,$00,$10,$00
    db $E8,$00,$18,$00

DATA_01D12E:
    db $00,$F0,$00,$10,$00,$F0,$00,$10
    db $00,$E8,$00,$18,$26,$26,$D8,$D8
DATA_01D13E:
    db $90,$30,$30,$90

DATA_01D142:
    db $00,$01,$02,$01

CODE_01D146:
    LDA.B EffFrame
    LSR A
    LDY.W SpriteMisc1626,X
    CPY.B #$02
    BCS +
    LSR A
  + AND.B #$03
    TAY
    LDA.W DATA_01D142,Y
    LDY.W SpriteMisc15AC,X
    BEQ +
    LDA.B #$05
  + STA.W SpriteMisc1602,X
    LDA.W SpriteInLiquid,X
    BEQ +
    LDY.B SpriteXPosLow,X
    CPY.B #$50
    BCC +
    CPY.B #$80
    BCS +
    DEC.W SpriteInLiquid,X
    LSR A
    BCS +
    INC.W SpriteMisc1534,X
    DEC.W SpriteMisc160E,X
  + LDA.W SpriteMisc1534,X
    STA.B _5
    STA.B _6
    STA.B _B
    STA.B _C
    LDA.W SpriteMisc160E,X
    STA.B _7
    STA.B _8
    STA.B _9
    STA.B _A
    LDA.B Mode7Angle
    ASL A
    BEQ +
    JMP CODE_01D224

  + LDY.W SpriteMisc1594,X
    TYA
    LSR A
    BCS CODE_01D1B5
    LDA.B SpriteXPosLow,X
    CPY.B #$00
    BNE CODE_01D1AE
    CMP.W SpriteMisc1534,X
    BCC CODE_01D215
    BRA CODE_01D1D8

CODE_01D1AE:
    CMP.W SpriteMisc160E,X
    BCS CODE_01D215
    BRA CODE_01D1D8

CODE_01D1B5:
    LDA.W SpriteMisc157C,X
    BNE +
    INY
    INY
    INY
    INY
  + LDA.W _5,Y
    STA.B SpriteXPosLow,X
    LDY.W SpriteMisc1594,X
    LDA.B SpriteYPosLow,X
    CPY.B #$03
    BEQ ADDR_01D1D3
    CMP.W DATA_01D13E,Y
    BCC CODE_01D215
    BRA CODE_01D1D8

ADDR_01D1D3:
    CMP.W DATA_01D13E,Y
    BCS CODE_01D215
CODE_01D1D8:
    LDA.W SpriteMisc1626,X
    CMP.B #$02
    BCC +
    LDA.B #$02
  + ASL A
    ASL A
    ADC.W SpriteMisc1594,X
    TAY
    LDA.W DATA_01D122,Y
    STA.B SpriteXSpeed,X
    LDA.W DATA_01D12E,Y
    STA.B SpriteYSpeed,X
    JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
    LDA.W SpriteMisc1594,X
    LDY.W SpriteMisc157C,X
    BNE +
    EOR.B #$02
  + CMP.B #$02
    BNE +
    JSR SubHorizPos
    LDA.B _F
    CLC
    ADC.B #$10
    CMP.B #$20
    BCS +
    INC.W SpriteMisc1528,X
  + RTS

CODE_01D215:
    LDY.W SpriteMisc157C,X
    LDA.W SpriteMisc1594,X
    CLC
    ADC.W DATA_01D23D,Y
    AND.B #$03
    STA.W SpriteMisc1594,X
CODE_01D224:
    LDY.W SpriteMisc157C,X
    LDA.B Mode7Angle
    CLC
    ADC.W DATA_01D239,Y
    STA.B Mode7Angle
    LDA.B Mode7Angle+1
    ADC.W DATA_01D23B,Y
    AND.B #$01
    STA.B Mode7Angle+1
    RTS


DATA_01D239:
    db $FC,$04

DATA_01D23B:
    db $FF,$00

DATA_01D23D:
    db $FF,$01

CODE_01D23F:
    LDA.W SpriteMisc1540,X
    BEQ CODE_01D25E
    CMP.B #$01
    BNE Return01D2A7
    STZ.W SpriteMisc1528,X
    JSR SubHorizPos
    TYA
    STA.W SpriteMisc157C,X
    ASL A
    EOR.B #$02
    STA.W SpriteMisc1594,X
    LDA.B #$0A                                ; \ Set turning timer
    STA.W SpriteMisc15AC,X                    ; /
    RTS

CODE_01D25E:
    LDA.B #$06
    STA.W SpriteMisc1602,X
    JSR SubSprYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CMP.B #$70
    BCS +
    CLC
    ADC.B #$04
    STA.B SpriteYSpeed,X
  + LDA.B Mode7Angle
    ORA.B Mode7Angle+1
    BEQ +
    LDA.B Mode7Angle
    CLC
    ADC.B #$08
    STA.B Mode7Angle
    LDA.B Mode7Angle+1
    ADC.B #$00
    AND.B #$01
    STA.B Mode7Angle+1
  + JSR CODE_01D0C0
    BCC Return01D2A7
    LDA.B #$20                                ; \ Set ground shake timer
    STA.W ScreenShakeTimer                    ; /
    LDA.B PlayerInAir
    BNE +
    LDA.B #$28                                ; \ Lock Mario in place
    STA.W PlayerStunnedTimer                  ; /
  + LDA.B #!SFX_KAPOW                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$28
    STA.W SpriteMisc1540,X
    STZ.B Mode7Angle
    STZ.B Mode7Angle+1
Return01D2A7:
    RTS

CODE_01D2A8:
    LDA.W SpriteMisc151C,X
    CMP.B #$03
    BCS Return01D318
    LDA.W SpriteMisc187B,X
    CMP.B #$03
    BNE CODE_01D2BD
    LDA.W SpriteMisc1528,X
    CMP.B #$03
    BCS Return01D318
CODE_01D2BD:
    JSL GetMarioClipping
    JSR CODE_01D40B
    JSL CheckForContact
    BCC Return01D318
    LDA.W SpriteMisc1FE2,X
    BNE Return01D318
    LDA.B #$08
    STA.W SpriteMisc1FE2,X
    LDA.B PlayerInAir
    BEQ CODE_01D319
    LDA.W SpriteMisc1602,X
    CMP.B #$10
    BCS CODE_01D2E3
    CMP.B #$06
    BCS ADDR_01D31E
CODE_01D2E3:
    LDA.B PlayerYPosNext
    CLC
    ADC.B #$08
    CMP.B SpriteYPosLow,X
    BCS ADDR_01D31E
    LDA.W SpriteMisc1594,X
    LSR A
    BCS CODE_01D334
    LDA.B PlayerYSpeed+1
    BMI Return01D31D
    JSR CODE_01D351
    LDA.B #$D0
    STA.B PlayerYSpeed+1
    LDA.B #!SFX_SPLAT                         ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.W SpriteMisc1602,X
    CMP.B #$1B
    BCC CODE_01D379
ADDR_01D309:
    LDY.B #$20
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B #$08
    CMP.B PlayerXPosNext
    BMI +
    LDY.B #$E0
  + STY.B PlayerXSpeed+1
Return01D318:
    RTS

CODE_01D319:
    JSL HurtMario
Return01D31D:
    RTS

ADDR_01D31E:
    LDA.B #!SFX_BONK                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.B PlayerYSpeed+1
    BPL +
    LDA.B #$10
    STA.B PlayerYSpeed+1
    RTS

  + JSR ADDR_01D309
    LDA.B #$D0
    STA.B PlayerYSpeed+1
    RTS

CODE_01D334:
    LDA.B #!SFX_BONK                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.B PlayerYSpeed+1
    BPL +
    LDA.B #$20
    STA.B PlayerYSpeed+1
    RTS

  + LDY.B #$20
    LDA.B SpriteXPosLow,X
    BPL +
    LDY.B #$E0
  + STY.B PlayerXSpeed+1
    LDA.B #$B0
    STA.B PlayerYSpeed+1
    RTS

CODE_01D351:
    LDA.B SpriteXPosLow,X
    PHA
    SEC
    SBC.B #$08
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B SpriteYPosLow,X
    PHA
    CLC
    ADC.B #$08
    STA.B SpriteYPosLow,X
    JSL DisplayContactGfx
    PLA
    STA.B SpriteYPosLow,X
    PLA
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X
    RTS

CODE_01D379:
    LDA.B #$18
    STA.B Mode7XScale
    PHX
    LDA.B Mode7YScale
    LSR A
    TAX
    LDA.B #$28
    STA.B Mode7YScale
    LSR A
    TAY
    LDA.W DATA_01D0DE-8,Y
    SEC
    SBC.W DATA_01D0DE-8,X
    PLX
    CLC
    ADC.B SpriteYPosLow,X
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    STZ.B SpriteXSpeed,X                      ; \ Sprite Speed = 0
    STZ.B SpriteYSpeed,X                      ; /
    LDA.B #$80
    STA.W SpriteMisc1540,X
    LDA.B #$03
    STA.W SpriteMisc151C,X
    LDA.B #!SFX_ENEMYHURT                     ; \ Play sound effect
    STA.W SPCIO3                              ; /
    RTS

CODE_01D3B1:
    LDA.W SpriteMisc151C,X
    CMP.B #$03
    BCS Return01D40A
    LDY.B #$0A
CODE_01D3BA:
    STY.W SpriteInterIndex
    LDA.W ExtSpriteNumber,Y
    CMP.B #$05
    BNE +
    LDA.W ExtSpriteXPosLow,Y
    STA.B _0
    LDA.W ExtSpriteXPosHigh,Y
    STA.B _8
    LDA.W ExtSpriteYPosLow,Y
    STA.B _1
    LDA.W ExtSpriteYPosHigh,Y
    STA.B _9
    LDA.B #$08
    STA.B _2
    STA.B _3
    PHY
    JSR CODE_01D40B
    PLY
    JSL CheckForContact
    BCC +
    LDA.B #$01                                ; \ Extended sprite = Smoke puff
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B #$0F
    STA.W ExtSpriteMisc176F,Y
    LDA.B #!SFX_BONK                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    INC.W SpriteMisc1626,X
    LDA.W SpriteMisc1626,X
    CMP.B #$0C
    BCC +
    JSR CODE_01CFD0
  + DEY
    CPY.B #$07
    BNE CODE_01D3BA
Return01D40A:
    RTS

CODE_01D40B:
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B #$08
    STA.B _4
    LDA.W SpriteXPosHigh,X
    SBC.B #$00
    STA.B _A
    LDA.B #$10
    STA.B _6
    LDA.B #$10
    STA.B _7
    LDA.W SpriteMisc1602,X
    CMP.B #$69
    LDA.B #$08
    BCC +
    ADC.B #$0A
  + CLC
    ADC.B SpriteYPosLow,X
    STA.B _5
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _B
    RTS


DATA_01D439:
    db $A8,$B0,$B8,$C0,$C8

    STZ.W SpriteStatus,X                      ; \ Unreachable
    RTS                                       ; / Erase sprite


DATA_01D442:
    db $00,$F0,$00,$10

LudwigFireTiles:
    db $4A,$4C,$6A,$6C

DATA_01D44A:
    db $45,$45,$05,$05

BossFireball:
    LDA.B SpriteLock
    ORA.W PlayerIsFrozen
    BNE CODE_01D487
    LDA.W SpriteMisc1540,X
    CMP.B #$10
    BCS CODE_01D487
    TAY
    BNE +
    JSR SetAnimationFrame
    JSR SetAnimationFrame
    JSR MarioSprInteractRt
  + JSR SubSprXPosNoGrvty
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$20
    STA.B _0
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.B _1
    REP #$20                                  ; A->16
    LDA.B _0
    CMP.W #$0230
    SEP #$20                                  ; A->8
    BCC CODE_01D487
    STZ.W SpriteStatus,X
CODE_01D487:
    JSR GetDrawInfoBnk1
    LDA.W SpriteMisc1602,X
    ASL A
    STA.B _3
    LDA.W SpriteMisc157C,X
    ASL A
    STA.B _2
    %LorW_X(LDA,DATA_01D439)
    STA.W SpriteOAMIndex,X
    TAY
    PHX
    LDA.W SpriteMisc1540,X
    LDX.B #$01
    CMP.B #$08
    BCC CODE_01D4A8
    DEX
CODE_01D4A8:
    PHX
    PHX
    TXA
    CLC
    ADC.B _2
    TAX
    LDA.B _0
    CLC
    ADC.W DATA_01D442,X
    STA.W OAMTileXPos+$100,Y
    LDA.B EffFrame
    LSR A
    LSR A
    ROR A
    AND.B #$80
    ORA.W DATA_01D44A,X
    STA.W OAMTileAttr+$100,Y
    LDA.B _1
    INC A
    INC A
    STA.W OAMTileYPos+$100,Y
    PLA
    CLC
    ADC.B _3
    TAX
    LDA.W LudwigFireTiles,X
    STA.W OAMTileNo+$100,Y
    PLX
    INY
    INY
    INY
    INY
    DEX
    BPL CODE_01D4A8
    PLX
    LDY.B #$02
    LDA.B #$01
    JMP FinishOAMWriteRt


DATA_01D4E7:
    db $01,$FF

DATA_01D4E9:
    db $0F,$00

DATA_01D4EB:
    db $00,$02,$04,$06,$08,$0A,$0C,$0E
    db $0E,$0C,$0A,$08,$06,$04,$02,$00

ParachuteSprites:
    LDA.W SpriteStatus,X
    CMP.B #$08
    BEQ +
    JMP CODE_01D671

  + LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01D558                           ; /
    LDA.W SpriteMisc1540,X
    BNE CODE_01D558
    LDA.B TrueFrame
    LSR A
    BCC +
    INC.B SpriteYPosLow,X
    BNE +
    INC.W SpriteYPosHigh,X
  + LDA.W SpriteMisc151C,X
    BNE CODE_01D558
    LDA.B TrueFrame
    LSR A
    BCC +
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY
    LDA.W SpriteMisc1570,X
    CLC
    ADC.W DATA_01D4E7,Y
    STA.W SpriteMisc1570,X
    CMP.W DATA_01D4E9,Y
    BNE +
    INC.B SpriteTableC2,X
  + LDA.B SpriteXSpeed,X
    PHA
    LDY.W SpriteMisc1570,X
    LDA.B SpriteTableC2,X
    LSR A
    LDA.W DATA_01D4EB,Y
    BCC +
    EOR.B #$FF
    INC A
  + CLC
    ADC.B SpriteXSpeed,X
    STA.B SpriteXSpeed,X
    JSR SubSprXPosNoGrvty
    PLA
    STA.B SpriteXSpeed,X
    BRA CODE_01D558

CODE_01D558:
    JSR SubOffscreen0Bnk1
    JMP CODE_01D5B3


DATA_01D55E:
    db $0D,$0D,$0D,$0D,$0C,$0C,$0C,$0C
    db $0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D
DATA_01D56E:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $01,$01,$01,$01,$01,$01,$01,$01
DATA_01D57E:
    db $F8,$F8,$FA,$FA,$FC,$FC,$FE,$FE
    db $02,$02,$04,$04,$06,$06,$08,$08
DATA_01D58E:
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    db $00,$00,$00,$00,$00,$00,$00,$00
DATA_01D59E:
    db $0E,$0E,$0F,$0F,$10,$10,$10,$10
    db $10,$10,$10,$10,$0F,$0F,$0E,$0E
DATA_01D5AE:
    db $0F,$0D

DATA_01D5B0:
    db $01,$05,$00

CODE_01D5B3:
    STZ.W TileGenerateTrackA
    LDY.B #$F0
    LDA.W SpriteMisc1540,X
    BEQ +
    LSR A
    EOR.B #$0F
    STA.W TileGenerateTrackA
    CLC
    ADC.B #$F0
    TAY
  + STY.B _0
    LDA.B SpriteYPosLow,X
    PHA
    CLC
    ADC.B _0
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    ADC.B #$FF
    STA.W SpriteYPosHigh,X
    LDA.W SpriteOBJAttribute,X
    PHA
    AND.B #$F1
    ORA.B #$06
    STA.W SpriteOBJAttribute,X
    LDY.W SpriteMisc1570,X
    LDA.W DATA_01D55E,Y
    STA.W SpriteMisc1602,X
    LDA.W DATA_01D56E,Y
    STA.W SpriteMisc157C,X
    JSR SubSprGfx2Entry1
    PLA
    STA.W SpriteOBJAttribute,X
    LDA.W SpriteOAMIndex,X
    CLC
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    LDY.W SpriteMisc1570,X
    LDA.B SpriteXPosLow,X
    PHA
    CLC
    ADC.W DATA_01D57E,Y
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    PHA
    ADC.W DATA_01D58E,Y
    STA.W SpriteXPosHigh,X
    STZ.B _0
    LDA.W DATA_01D59E,Y
    SEC
    SBC.W TileGenerateTrackA
    BPL +
    DEC.B _0
  + CLC
    ADC.B SpriteYPosLow,X
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    ADC.B _0
    STA.W SpriteYPosHigh,X
    LDA.W SpriteMisc1602,X
    SEC
    SBC.B #$0C
    CMP.B #$01
    BNE +
    CLC
    ADC.W SpriteMisc157C,X
  + STA.W SpriteMisc1602,X
    LDA.W SpriteMisc1540,X
    BEQ +
    STZ.W SpriteMisc1602,X
  + LDY.W SpriteMisc1602,X
    LDA.W DATA_01D5B0,Y
    JSR SubSprGfx0Entry0
    JSR SubSprSpr_MarioSpr
    LDA.W SpriteMisc1540,X
    BEQ CODE_01D693
    DEC A
    BNE +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    PLA
    PLA
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    LDA.B #$80
    STA.W SpriteMisc1540,X
CODE_01D671:
    LDA.B SpriteNumber,X
    SEC
    SBC.B #$3F
    TAY
    LDA.W DATA_01D5AE,Y
    STA.B SpriteNumber,X
    JSL LoadSpriteTables
    RTS

  + JSR CODE_019140
    JSR IsOnGround
    BEQ +
    JSR SetSomeYSpeed__
  + JSR SubSprYPosNoGrvty
    INC.B SpriteYSpeed,X
    BRA CODE_01D6B5

CODE_01D693:
    TXA
    EOR.B TrueFrame
    LSR A
    BCC CODE_01D6B5
    JSR CODE_019140
    JSR IsTouchingObjSide
    BEQ +
    LDA.B #$01
    STA.W SpriteMisc151C,X
    LDA.B #$07
    STA.W SpriteMisc1570,X
  + JSR IsOnGround
    BEQ CODE_01D6B5
    LDA.B #$20
    STA.W SpriteMisc1540,X
CODE_01D6B5:
    PLA
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
Return01D6C3:
    RTS

InitLineRope:
    CPX.B #$06
    BCC +
    LDA.W SpriteMemorySetting
    BEQ +
    INC.W SpriteTweakerB,X
    BRA +

InitLinePlat:
    LDA.B SpriteXPosLow,X
    AND.B #$10
    EOR.B #$10
    STA.W SpriteMisc1602,X
    BEQ +
    INC.W SpriteTweakerB,X
  + INC.W SpriteMisc1540,X
    JSR LineFuzzy_Plats
    JSR LineFuzzy_Plats
    INC.W SpriteMisc1626,X
Return01D6EC:
    RTS

InitLineGuidedSpr:
    INC.W SpriteMisc187B,X
    LDA.B SpriteXPosLow,X
    AND.B #$10
    BNE CODE_01D707
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B #$40
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    SBC.B #$01
    STA.W SpriteXPosHigh,X
    BRA InitLineBrwnPlat

CODE_01D707:
    INC.W SpriteMisc157C,X
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$0F
    STA.B SpriteXPosLow,X
InitLineBrwnPlat:
    LDA.B #$02
    STA.W SpriteMisc1540,X
    RTS


DATA_01D717:
    db $F8,$00

LineRope_Chainsaw:
    TXA
    ASL A
    ASL A
    EOR.B EffFrame
    STA.B _2
    AND.B #$07
    ORA.B SpriteLock
    BNE LineGrinder
    LDA.B _2
    LSR A
    LSR A
    LSR A
    AND.B #$01
    TAY
    LDA.W DATA_01D717,Y
    STA.B _0
    LDA.B #$F2
    STA.B _1
    JSR CODE_018063
LineGrinder:
    LDA.B TrueFrame
    AND.B #$07
    ORA.W SpriteMisc1626,X
    ORA.B SpriteLock
    BNE LineFuzzy_Plats
    LDA.B #!SFX_BLOCKSNAKE                    ; \ Play sound effect
    STA.W SPCIO1                              ; /
LineFuzzy_Plats:
    JMP CODE_01D9A7

CODE_01D74D:
    JSR SubOffscreen1Bnk1
    LDA.W SpriteMisc1540,X
    BNE CODE_01D75C
    LDA.B SpriteLock
    ORA.W SpriteMisc1626,X
    BNE Return01D6EC
CODE_01D75C:
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_01D7F4
    dw CODE_01D768
    dw CODE_01DB44

CODE_01D768:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return01D791                          ; /
    LDA.W SpriteMisc157C,X
    BNE CODE_01D792
    LDY.W SpriteMisc1534,X
    JSR CODE_01D7B0
    INC.W SpriteMisc1534,X
    LDA.W SpriteMisc187B,X
    BEQ +
    LDA.B TrueFrame
    LSR A
    BCC +
    INC.W SpriteMisc1534,X
  + LDA.W SpriteMisc1534,X
    CMP.W SpriteMisc1570,X
    BCC Return01D791
    STZ.B SpriteTableC2,X
Return01D791:
    RTS

CODE_01D792:
    LDY.W SpriteMisc1570,X
    DEY
    JSR CODE_01D7B0
    DEC.W SpriteMisc1570,X
    BEQ CODE_01D7AD
    LDA.W SpriteMisc187B,X
    BEQ +
    LDA.B TrueFrame
    LSR A
    BCC +
    DEC.W SpriteMisc1570,X
    BNE +
CODE_01D7AD:
    STZ.B SpriteTableC2,X
  + RTS

CODE_01D7B0:
    PHB                                       ; Sprites calling this routine must be modified
    LDA.B #$07                                ; to set $151C,x and $1528,x to a location in
    PHA                                       ; LineTable instead of $07/F9DB+something
    PLB
    LDA.W SpriteMisc151C,X
    STA.B _4
    LDA.W SpriteMisc1528,X
    STA.B _5
    LDA.B (_4),Y
    AND.B #$0F
    STA.B _6
    LDA.B (_4),Y
    PLB
    LSR A
    LSR A
    LSR A
    LSR A
    STA.B _7
    LDA.B SpriteYPosLow,X
    AND.B #$F0
    CLC
    ADC.B _7
    STA.B SpriteYPosLow,X
    LDA.B SpriteXPosLow,X
    AND.B #$F0
    CLC
    ADC.B _6
    STA.B SpriteXPosLow,X
    RTS


DATA_01D7E1:
    db $FC,$04,$FC,$04

DATA_01D7E5:
    db $FF,$00,$FF,$00

DATA_01D7E9:
    db $FC,$FC,$04,$04

DATA_01D7ED:
    db $FF,$FF,$00,$00

CODE_01D7F1:
    JMP CODE_01D89F

CODE_01D7F4:
    LDY.B #$03
CODE_01D7F6:
    STY.W SpriteInterIndex
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_01D7E1,Y
    STA.B _2
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_01D7E5,Y
    STA.B _3
    LDA.B SpriteYPosLow,X
    CLC
    ADC.W DATA_01D7E9,Y
    STA.B _0
    LDA.W SpriteYPosHigh,X
    ADC.W DATA_01D7ED,Y
    STA.B _1
    LDA.W SpriteMisc1540,X
    BNE CODE_01D83A
    LDA.B _0
    AND.B #$F0
    STA.B _4
    LDA.B SpriteYPosLow,X
    AND.B #$F0
    CMP.B _4
    BNE CODE_01D83A
    LDA.B _2
    AND.B #$F0
    STA.B _5
    LDA.B SpriteXPosLow,X
    AND.B #$F0
    CMP.B _5
    BEQ CODE_01D861
CODE_01D83A:
    JSR CODE_01D94D                           ;WIERD ROUTINE INVOLVING POSITIONS.  ALL VARIABLES SET ABOVE...
    BNE CODE_01D7F1
    LDA.W Map16TileNumber                     ;"# OF CUSTOM BLOCK???"
    CMP.B #$94
    BEQ CODE_01D851
    CMP.B #$95
    BNE CODE_01D856
    LDA.W OnOffSwitch
    BEQ CODE_01D861
    BNE CODE_01D856
CODE_01D851:
    LDA.W OnOffSwitch
    BNE CODE_01D861
CODE_01D856:
    LDA.W Map16TileNumber
    CMP.B #$76
    BCC CODE_01D861
    CMP.B #$9A
    BCC CODE_01D895
CODE_01D861:
    LDY.W SpriteInterIndex
    DEY
    BPL CODE_01D7F6
    LDA.B SpriteTableC2,X
    CMP.B #$02                                ; ?? #00 - platforms stop at end rather than fall off
    BEQ Return01D894
    LDA.B #$02
    STA.B SpriteTableC2,X
    LDY.W SpriteMisc160E,X
    LDA.W SpriteMisc157C,X
    BEQ +
    TYA
    CLC
    ADC.B #$20
    TAY
  + LDA.W DATA_01DD11,Y
    BPL +
    ASL A
  + PHY
    ASL A
    STA.B SpriteYSpeed,X                      ;SPEED SETTINGS!
    PLY
    LDA.W DATA_01DD51,Y
    ASL A
    STA.B SpriteXSpeed,X
    LDA.B #$10
    STA.W SpriteMisc1540,X
Return01D894:
    RTS

CODE_01D895:
    PHA
    SEC
    SBC.B #$76
    TAY
    PLA
    CMP.B #$96
    BCC CODE_01D8A4
CODE_01D89F:
    LDY.W SpriteMisc160E,X
    BRA +

CODE_01D8A4:
    LDA.B SpriteYPosLow,X
    STA.B _8
    LDA.W SpriteYPosHigh,X
    STA.B _9
    LDA.B SpriteXPosLow,X
    STA.B _A
    LDA.W SpriteXPosHigh,X
    STA.B _B
    LDA.B _0
    STA.B SpriteYPosLow,X
    LDA.B _1
    STA.W SpriteYPosHigh,X
    LDA.B _2
    STA.B SpriteXPosLow,X
    LDA.B _3
    STA.W SpriteXPosHigh,X
  + PHB
    LDA.B #$07
    PHA
    PLB
    LDA.W DATA_07FBF3,Y
    STA.W SpriteMisc151C,X
    LDA.W DATA_07FC13,Y
    STA.W SpriteMisc1528,X
    PLB
    LDA.W DATA_01DCD1,Y
    STA.W SpriteMisc1570,X
    STZ.W SpriteMisc1534,X
    TYA
    STA.W SpriteMisc160E,X
    LDA.W SpriteMisc1540,X
    BNE CODE_01D933
    STZ.W SpriteMisc157C,X
    LDA.W DATA_01DCF1,Y
    BEQ CODE_01D8FF
    TAY
    LDA.B SpriteYPosLow,X
    CPY.B #$01
    BNE +
    EOR.B #$0F
  + BRA +

CODE_01D8FF:
    LDA.B SpriteXPosLow,X
  + AND.B #$0F
    CMP.B #$0A
    BCC +
    LDA.B SpriteTableC2,X
    CMP.B #$02
    BEQ +
    INC.W SpriteMisc157C,X
  + LDA.B SpriteYPosLow,X
    STA.B _C
    LDA.B SpriteXPosLow,X
    STA.B _D
    JSR CODE_01D768
    LDA.B _C
    SEC
    SBC.B SpriteYPosLow,X
    CLC
    ADC.B #$08
    CMP.B #$10
    BCS +
    LDA.B _D
    SEC
    SBC.B SpriteXPosLow,X
    CLC
    ADC.B #$08
    CMP.B #$10
    BCS +
CODE_01D933:
    LDA.B #$01
    STA.B SpriteTableC2,X
    RTS

  + LDA.B _8
    STA.B SpriteYPosLow,X
    LDA.B _9
    STA.W SpriteYPosHigh,X
    LDA.B _A
    STA.B SpriteXPosLow,X
    LDA.B _B
    STA.W SpriteXPosHigh,X
    JMP CODE_01D861

CODE_01D94D:
    LDA.B _0
    AND.B #$F0
    STA.B _6
    LDA.B _2
    LSR A
    LSR A
    LSR A
    LSR A
    PHA
    ORA.B _6
    PHA
    LDA.B ScreenMode
    AND.B #!ScrMode_Layer1Vert
    BEQ CODE_01D977
    PLA
    LDX.B _1
    CLC
    ADC.L DATA_00BA80,X
    STA.B _5
    LDA.L DATA_00BABC,X
    ADC.B _3
    STA.B _6
    BRA +

CODE_01D977:
    PLA
    LDX.B _3
    CLC
    ADC.L DATA_00BA60,X
    STA.B _5
    LDA.L DATA_00BA9C,X
    ADC.B _1
    STA.B _6
  + LDA.B #$7E
    STA.B _7
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B [_5]
    STA.W Map16TileNumber
    INC.B _7
    LDA.B [_5]
    PLY
    STY.B _5
    PHA
    LDA.B _5
    AND.B #$07
    TAY
    PLA
    AND.W DATA_018000,Y
    RTS

CODE_01D9A7:
    LDA.B SpriteNumber,X                      ;LINE GUIDE PLATFORM FUZZY
    CMP.B #$64                                ;DETERMINE SPRITE ITS DEALING WITH
    BEQ CODE_01D9D3
    CMP.B #$65
    BCC CODE_01D9D0                           ;PLATFORM!
    CMP.B #$68
    BNE CODE_01D9BA
    JSR CODE_01DBD4
    BRA CODE_01D9C1

CODE_01D9BA:
    CMP.B #$67
    BNE CODE_01D9C6
    JSR CODE_01DC0B
CODE_01D9C1:
    JSR MarioSprInteractRt
    BRA +

CODE_01D9C6:
    JSR MarioSprInteractRt
    JSL CODE_03C263
  + JMP CODE_01D74D

CODE_01D9D0:
    JMP CODE_01DAA2

CODE_01D9D3:
    JSR CODE_01DC54
    LDA.B SpriteXPosLow,X
    PHA
    LDA.B SpriteYPosLow,X
    PHA
    JSR CODE_01D74D
    PLA
    SEC
    SBC.B SpriteYPosLow,X
    EOR.B #$FF
    INC A
    STA.W TileGenerateTrackA
    PLA
    SEC
    SBC.B SpriteXPosLow,X
    EOR.B #$FF
    INC A
    STA.W TileGenerateTrackB
    LDA.B PlayerBlockedDir
    AND.B #$03
    BNE Return01DA09
    JSR CODE_01A80F
    BCS CODE_01DA0A
CODE_01D9FE:
    LDA.W SpriteMisc163E,X
    BEQ Return01DA09
    STZ.W SpriteMisc163E,X
    STZ.W PlayerClimbingRope
Return01DA09:
    RTS

CODE_01DA0A:
    LDA.W SpriteStatus,X
    BEQ CODE_01DA37
    LDA.W CarryingFlag                        ; \ Branch if carrying an enemy...
    ORA.W PlayerRidingYoshi                   ; | ...or if on Yoshi
    BNE CODE_01D9FE                           ; /
    LDA.B #$03
    STA.W SpriteMisc163E,X
    LDA.W SpriteMisc154C,X
    BNE Return01DA8F
    LDA.W PlayerClimbingRope
    BNE CODE_01DA2F
    LDA.B byetudlrHold
    AND.B #$08
    BEQ Return01DA8F
    STA.W PlayerClimbingRope
CODE_01DA2F:
    BIT.B byetudlrFrame
    BPL +
    LDA.B #$B0
    STA.B PlayerYSpeed+1
CODE_01DA37:
    STZ.W PlayerClimbingRope
    LDA.B #$10
    STA.W SpriteMisc154C,X
  + LDY.B #$00
    LDA.W TileGenerateTrackA
    BPL +
    DEY
  + CLC
    ADC.B PlayerYPosNext
    STA.B PlayerYPosNext
    TYA
    ADC.B PlayerYPosNext+1
    STA.B PlayerYPosNext+1
    LDA.B SpriteYPosLow,X
    STA.B _0
    LDA.W SpriteYPosHigh,X
    STA.B _1
    REP #$20                                  ; A->16
    LDA.B PlayerYPosNext
    SEC
    SBC.B _0
    CMP.W #$0000
    BPL +
    INC.B PlayerYPosNext
  + SEP #$20                                  ; A->8
    LDA.W TileGenerateTrackB
    JSR CODE_01DA90
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B #$08
    CMP.B PlayerXPosNext
    BEQ CODE_01DA84
    BPL CODE_01DA7F
    LDA.B #$FF
    BRA +

CODE_01DA7F:
    LDA.B #$01
  + JSR CODE_01DA90
CODE_01DA84:
    LDA.W SpriteMisc1626,X
    BEQ Return01DA8F
    STZ.W SpriteMisc1626,X
    STZ.W SpriteMisc1540,X
Return01DA8F:
    RTS

CODE_01DA90:
    LDY.B #$00
    CMP.B #$00
    BPL +
    DEY
  + CLC
    ADC.B PlayerXPosNext
    STA.B PlayerXPosNext
    TYA
    ADC.B PlayerXPosNext+1
    STA.B PlayerXPosNext+1
    RTS

CODE_01DAA2:
    LDY.B #$18                                ;LINE GUIDED PLATFORM CODE
    LDA.W SpriteMisc1602,X
    BEQ +
    LDY.B #$28                                ;CONDITIONAL DEPENDING ON PLATFORM TYPE?
  + STY.B _0
    LDA.B SpriteXPosLow,X
    PHA
    SEC
    SBC.B _0
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B SpriteYPosLow,X
    PHA
    SEC
    SBC.B #$08
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    JSR CODE_01B2DF                           ;DRAW GFX  .  RELIES ON NEW POSITIONS MADE UP THERE.
    PLA                                       ;RESTORE POSITIONS
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    PLA
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X
    LDA.B SpriteXPosLow,X
    PHA
    JSR CODE_01D74D                           ;LINE GUIDE HANDLER???
    PLA
    SEC
    SBC.B SpriteXPosLow,X
    LDY.W SpriteMisc1528,X
    PHY
    EOR.B #$FF
    INC A
    STA.W SpriteMisc1528,X
    LDY.B #$18
    LDA.W SpriteMisc1602,X
    BEQ +
    LDY.B #$28
  + STY.B _0
    LDA.B SpriteXPosLow,X
    PHA
    SEC
    SBC.B _0
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteXPosHigh,X
    LDA.B SpriteYPosLow,X
    PHA
    SEC
    SBC.B #$08
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    SBC.B #$00
    STA.W SpriteYPosHigh,X
    JSR CODE_01B457                           ;CUSTOM INTERACTION HANDLER
    BCC +
    LDA.W SpriteMisc1626,X
    BEQ +
    STZ.W SpriteMisc1626,X
    STZ.W SpriteMisc1540,X
  + PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    PLA
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X
    PLA
    STA.W SpriteMisc1528,X
    RTS

CODE_01DB44:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    JSR SubUpdateSprPos
    LDA.W SpriteMisc1540,X
    BNE +
    LDA.B SpriteYSpeed,X
    CMP.B #$20
    BMI +
    JSR CODE_01D7F4
  + RTS


DATA_01DB5A:
    db $18,$E8

Grinder:
    JSR CODE_01DBA2
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE Return01DB95
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return01DB95                          ; /
    LDA.B TrueFrame
    AND.B #$03
    BNE +
    LDA.B #!SFX_BLOCKSNAKE                    ; \ Play sound effect
    STA.W SPCIO1                              ; /
  + JSR SubOffscreen0Bnk1
    JSR MarioSprInteractRt
    LDY.W SpriteMisc157C,X
    LDA.W DATA_01DB5A,Y
    STA.B SpriteXSpeed,X
    JSR SubUpdateSprPos
    JSR IsOnGround
    BEQ +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + JSR IsTouchingObjSide
    BEQ Return01DB95
    JSR FlipSpriteDir
Return01DB95:
    RTS


DATA_01DB96:
    db $F8,$08,$F8,$08

DATA_01DB9A:
    db $00,$00,$10,$10

DATA_01DB9E:
    db $03,$43,$83,$C3

CODE_01DBA2:
    JSR GetDrawInfoBnk1
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC
    ADC.W DATA_01DB96,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_01DB9A,X
    STA.W OAMTileYPos+$100,Y
    LDA.B EffFrame
    AND.B #$02
    ORA.B #$6C
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_01DB9E,X
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
CODE_01DBD0:
    LDA.B #$03
    BRA +

CODE_01DBD4:
    JSR SubSprGfx2Entry1
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileXPos+$100,Y
    SEC
    SBC.B #$08
    STA.W OAMTileXPos+$100,Y
    LDA.W OAMTileYPos+$100,Y
    SEC
    SBC.B #$08
    STA.W OAMTileYPos+$100,Y
    PHX
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$01
    TAX
    LDA.B #$C8
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_01DC09,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    LDA.B #$00
  + PLX
CODE_01DC04:
    LDY.B #$02
    JMP FinishOAMWriteRt


DATA_01DC09:
    db $05,$45

CODE_01DC0B:
    JSR GetDrawInfoBnk1
    PHX
    LDX.B #$03
  - LDA.B _0
    CLC
    ADC.W DATA_01DC3B,X
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    CLC
    ADC.W DATA_01DC3F,X
    STA.W OAMTileYPos+$100,Y
    LDA.B EffFrame
    AND.B #$02
    ORA.B #$6C
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_01DC43,X
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEX
    BPL -
    BRA CODE_01DBD0


DATA_01DC3B:
    db $F0,$00,$F0,$00

DATA_01DC3F:
    db $F0,$F0,$00,$00

DATA_01DC43:
    db $33,$73,$B3,$F3

RopeMotorTiles:
    db $C0,$C2,$E0,$C2

LineGuideRopeTiles:
    db $C0,$CE,$CE,$CE,$CE,$CE,$CE,$CE
    db $CE

CODE_01DC54:
    JSR GetDrawInfoBnk1
    LDA.B _0
    SEC
    SBC.B #$08
    STA.B _0
    LDA.B _1
    SEC
    SBC.B #$08
    STA.B _1
    TXA
    ASL A
    ASL A
    EOR.B EffFrame
    LSR A
    LSR A
    LSR A
    AND.B #$03
    STA.B _2
    LDA.B #$05
    CPX.B #$06
    BCC +
    LDY.W SpriteMemorySetting
    BEQ +
    LDA.B #$09
  + STA.B _3
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDX.B #$00
CODE_01DC85:
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    CLC
    ADC.B #$10
    STA.B _1
    %LorW_X(LDA,LineGuideRopeTiles)
    CPX.B #$00
    BNE +
    PHX
    LDX.B _2
    %LorW_X(LDA,RopeMotorTiles)
    PLX
  + STA.W OAMTileNo+$100,Y
    LDA.B #$37
    CPX.B #$01
    BCC +
    LDA.B #$31
  + STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    INX
    CPX.B _3
    BNE CODE_01DC85
    LDA.B #$DE
    STA.W OAMTileNo+$FC,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B #$04
    CPX.B #$06
    BCC +
    LDY.W SpriteMemorySetting
    BEQ +
    LDA.B #$08
  + JMP CODE_01DC04


DATA_01DCD1:
    db $15,$15,$15,$15,$0C,$10,$10,$10
    db $10,$0C,$0C,$10,$10,$10,$10,$0C
    db $15,$15,$10,$10,$10,$10,$10,$10
    db $10,$10,$10,$10,$10,$10,$15,$15
DATA_01DCF1:
    db $00,$00,$00,$00,$00,$00,$01,$02
    db $00,$00,$00,$00,$02,$01,$00,$00
    db $00,$00,$01,$02,$01,$02,$00,$00
    db $00,$00,$02,$02,$00,$00,$00,$00
DATA_01DD11:
    db $00,$10,$00,$F0,$F4,$FC,$F0,$10
    db $04,$0C,$0C,$00,$10,$F0,$FC,$F4
    db $F0,$10,$F0,$10,$F0,$10,$F8,$F8
    db $08,$08,$10,$10,$00,$00,$F0,$10
    db $10,$00,$F0,$F0,$0C,$04,$10,$F0
    db $00,$F4,$F4,$FC,$F0,$10,$00,$0C
    db $10,$F0,$10,$00,$10,$F0,$08,$08
    db $F8,$F8,$F0,$F0,$00,$00,$10,$F0
DATA_01DD51:
    db $10,$00,$10,$00,$0C,$10,$04,$00
    db $10,$0C,$0C,$10,$04,$00,$10,$0C
    db $10,$10,$08,$08,$08,$08,$10,$10
    db $10,$10,$00,$00,$10,$10,$10,$10
    db $00,$F0,$00,$F0,$F4,$F0,$00,$FC
    db $F0,$F4,$F4,$F0,$00,$FC,$F0,$F4
    db $F0,$F0,$F8,$F8,$F8,$F8,$F0,$F0
    db $F0,$F0,$00,$00,$F0,$F0,$F0

DATA_01DD90:
    db $F0

DATA_01DD91:
    db $50,$78,$A0,$A0,$A0,$78,$50,$50
DATA_01DD99:
    db $78

DATA_01DD9A:
    db $F0,$F0,$F0,$18,$40,$40,$40,$18
DATA_01DDA2:
    db $18,$03,$00,$00,$01,$01,$02,$02
    db $03,$FF

InitBonusGame:
    LDA.W DisableBonusSprite
    BEQ +
    STZ.W SpriteStatus,X
    RTS

  + LDX.B #$09
CODE_01DDB7:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
    LDA.B #$82
    STA.W SpriteNumber,X
    %LorW_X(LDA,DATA_01DD90)
    STA.B SpriteXPosLow,X
    LDA.B #$00
    STA.W SpriteXPosHigh,X
    %LorW_X(LDA,DATA_01DD99)
    STA.B SpriteYPosLow,X
    ASL A
    LDA.B #$00
    BCS +
    INC A
  + STA.W SpriteYPosHigh,X
    JSL InitSpriteTables
    %LorW_X(LDA,DATA_01DDA2)
    STA.W SpriteMisc157C,X
    TXA
    CLC
    ADC.B TrueFrame
    AND.B #$07
    STA.W SpriteMisc1570,X
    DEX
    BNE CODE_01DDB7
    STZ.W BonusGameComplete
    STZ.W BonusGame1UpCount
    JSL GetRand
    EOR.B TrueFrame
    ADC.B EffFrame
    AND.B #$07
    TAY
    LDA.W DATA_01DE21,Y
    STA.W SpriteMisc1570+9
    LDA.B #$01
    STA.B SpriteTableC2+9
    INC.W DisableBonusSprite
    LDX.W CurSpriteProcess                    ; X = Sprite index
    RTS


DATA_01DE11:
    db $10,$00,$F0,$00

DATA_01DE15:
    db $00,$10,$00,$F0

DATA_01DE19:
    db $A0,$A0,$50,$50

DATA_01DE1D:
    db $F0,$40,$40,$F0

DATA_01DE21:
    db $01,$01,$01,$04,$04,$04,$07,$07
    db $07

BonusGame:
    STZ.W SpriteOffscreenX,X
    CPX.B #$01
    BNE +
    JSR CODE_01E26A
  + JSR CODE_01DF19
    LDA.B SpriteLock                          ; \ Return if sprites locked
    BNE Return01DE40                          ; /
    LDA.W BonusGameComplete
    BEQ +
Return01DE40:
    RTS

  + LDA.B SpriteTableC2,X
    BNE CODE_01DE8C
    LDA.B EffFrame
    AND.B #$03
    BNE +
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    CMP.B #$09
    BNE +
    STZ.W SpriteMisc1570,X
  + JSR MarioSprInteractRt
    BCC CODE_01DE8C
    LDA.B PlayerYSpeed+1
    BPL CODE_01DE8C
    LDA.B #$F4
    LDY.B Powerup
    BEQ +
    LDA.B #con($00,$00,$00,$FC,$FC)
  + CLC
    ADC.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    CMP.B PlayerYPosScrRel
    BCS CODE_01DE8C
    LDA.B #$10
    STA.B PlayerYSpeed+1
    LDA.B #!SFX_SWITCH                        ; \ Play sound effect
    STA.W SPCIO0                              ; /
    INC.B SpriteTableC2,X
    LDY.W SpriteMisc1570,X
    LDA.W DATA_01DE21,Y
    STA.W SpriteMisc1570,X
    LDA.B #$10
    STA.W SpriteMisc1540,X
CODE_01DE8C:
    LDY.W SpriteMisc157C,X
    BMI Return01DEAF
    LDA.B SpriteXPosLow,X
    CMP.W DATA_01DE19,Y
    BNE CODE_01DE9F
    LDA.B SpriteYPosLow,X
    CMP.W DATA_01DE1D,Y
    BEQ +
CODE_01DE9F:
    LDA.W DATA_01DE11,Y
    STA.B SpriteXSpeed,X
    LDA.W DATA_01DE15,Y
    STA.B SpriteYSpeed,X
    JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
Return01DEAF:
    RTS

  + LDY.B #$09
CODE_01DEB2:
    LDA.W SpriteTableC2,Y
    BEQ CODE_01DED7
    LDA.W SpriteYPosLow,Y
    CLC
    ADC.B #$04
    AND.B #$F8
    STA.W SpriteYPosLow,Y
    LDA.W SpriteXPosLow,Y
    CLC
    ADC.B #$04
    AND.B #$F8
    STA.W SpriteXPosLow,Y
    DEY
    BNE CODE_01DEB2
    INC.W BonusGameComplete
    JSR CODE_01DFD9
    RTS

CODE_01DED7:
    LDA.W SpriteMisc157C,X
    INC A
    AND.B #$03
    TAY
    STA.W SpriteMisc157C,X
    BRA CODE_01DE9F


DATA_01DEE3:
    db $58

DATA_01DEE4:
    db $59

DATA_01DEE5:
    db $83

DATA_01DEE6:
    db $83,$48,$49,$58,$59,$83,$83,$48
    db $49,$34,$35,$83,$83,$24,$25,$34
    db $35,$83,$83,$24,$25,$36,$37,$83
    db $83,$26,$27,$36,$37,$83,$83,$26
    db $27

DATA_01DF07:
    db $04,$04,$04,$08,$08,$08,$0A,$0A
    db $0A

DATA_01DF10:
    db $00,$03,$05,$07,$08,$08,$07,$05
    db $03

CODE_01DF19:
    LDA.W SpriteMisc1540,X
    LSR A
    TAY
    LDA.W DATA_01DF10,Y
    STA.B _0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.W OAMTileXPos+$110,Y
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$108,Y
    CLC
    ADC.B #$08
    STA.W OAMTileXPos+$104,Y
    STA.W OAMTileXPos+$10C,Y
    LDA.W SpriteMisc154C,X
    CLC
    BEQ CODE_01DF4E
    LSR A
    LSR A
    LSR A
    LSR A
    BRA +

    CLC                                       ; \ Unreachable instructions
    ADC.W CurSpriteProcess                    ; /
  + LSR A
CODE_01DF4E:
    PHP
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B _0
    SEC
    SBC.B Layer1YPos
    STA.W OAMTileYPos+$110,Y
    PLP
    BCS +
    STA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    CLC
    ADC.B #$08
    STA.W OAMTileYPos+$108,Y
    STA.W OAMTileYPos+$10C,Y
  + LDA.W SpriteMisc1570,X
    PHX
    PHA
    ASL A
    ASL A
    TAX
    %LorW_X(LDA,DATA_01DEE3)
    STA.W OAMTileNo+$100,Y
    %LorW_X(LDA,DATA_01DEE4)
    STA.W OAMTileNo+$104,Y
    %LorW_X(LDA,DATA_01DEE5)
    STA.W OAMTileNo+$108,Y
    %LorW_X(LDA,DATA_01DEE6)
    STA.W OAMTileNo+$10C,Y
    LDA.B #$E4
    STA.W OAMTileNo+$110,Y
    PLX
    LDA.B SpriteProperties
    %LorW_X(ORA,DATA_01DF07)
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    STA.W OAMTileAttr+$108,Y
    STA.W OAMTileAttr+$10C,Y
    ORA.B #$01
    STA.W OAMTileAttr+$110,Y
    PLX
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize+$40,Y
    STA.W OAMTileSize+$41,Y
    STA.W OAMTileSize+$42,Y
    STA.W OAMTileSize+$43,Y
    LDA.B #$02
    STA.W OAMTileSize+$44,Y
    RTS


DATA_01DFC1:
    db $00,$01,$02,$02,$03,$04,$04,$05
    db $06,$06,$07,$00,$00,$08,$04,$02
    db $08,$06,$03,$08,$07,$01,$08,$05

CODE_01DFD9:
    LDA.B #$07
    STA.B _0
CODE_01DFDD:
    LDX.B #$02
CODE_01DFDF:
    STX.B _1
    LDA.B _0
    ASL A
    ADC.B _0
    CLC
    ADC.B _1
    TAY
    LDA.W DATA_01DFC1,Y
    TAY
    LDA.W DATA_01DD9A,Y
    STA.B _2
    LDA.W DATA_01DD91,Y
    STA.B _3
    LDY.B #$09
CODE_01DFFA:
    LDA.W SpriteYPosLow,Y
    CMP.B _2
    BNE CODE_01E008
    LDA.W SpriteXPosLow,Y
    CMP.B _3
    BEQ CODE_01E00D
CODE_01E008:
    DEY
    CPY.B #$01
    BNE CODE_01DFFA
CODE_01E00D:
    LDA.W SpriteMisc1570,Y
    STA.B _4,X
    STY.B _7,X
    DEX
    BPL CODE_01DFDF
    LDA.B _4
    CMP.B _5
    BNE +
    CMP.B _6
    BNE +
    INC.W BonusGame1UpCount
    LDA.B #$70
    LDY.B _7
    STA.W SpriteMisc154C,Y
    LDY.B _8
    STA.W SpriteMisc154C,Y
    LDY.B _9
    STA.W SpriteMisc154C,Y
  + DEC.B _0
    BPL CODE_01DFDD
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDY.B #!SFX_CORRECT
    LDA.W BonusGame1UpCount
    STA.W BonusOneUpsRemain
    BNE +
    LDA.B #$58
    STA.W BonusFinishTimer
    INY
  + STY.W SPCIO3                              ; / Play sound effect
    RTS

InitFireball:
    LDA.B SpriteYPosLow,X
    STA.W SpriteMisc1528,X
    LDA.W SpriteYPosHigh,X
    STA.W SpriteMisc151C,X
  - LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$10
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    JSR CODE_019140
    LDA.W SpriteInLiquid,X
    BEQ -
    JSR CODE_01E0E2
    LDA.B #$20
    STA.W SpriteMisc1540,X
    RTS


DATA_01E07B:
    db $F0,$DC,$D0,$C8,$C0,$B8,$B2,$AC
    db $A6,$A0,$9A,$96,$92,$8C,$88,$84
    db $80,$04,$08,$0C,$10,$14

DATA_01E091:
    db $70,$20

Fireballs:
    STZ.W SpriteOnYoshiTongue,X
    LDA.W SpriteMisc1540,X
    BEQ CODE_01E0A7
    STA.W SpriteOnYoshiTongue,X
    DEC A
    BNE +
    LDA.B #!SFX_PODOBOO                       ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + RTS

CODE_01E0A7:
    LDA.B SpriteLock
    BEQ +
    JMP CODE_01E12D

  + JSR MarioSprInteractRt
    JSR SetAnimationFrame
    JSR SetAnimationFrame
    LDA.W SpriteOBJAttribute,X
    AND.B #$7F
    LDY.B SpriteYSpeed,X
    BMI +
    INC.W SpriteMisc1602,X
    INC.W SpriteMisc1602,X
    ORA.B #$80
  + STA.W SpriteOBJAttribute,X
    JSR CODE_019140
    LDA.W SpriteInLiquid,X
    BEQ CODE_01E106
    LDA.B SpriteYSpeed,X
    BMI CODE_01E106
    JSL GetRand
    AND.B #$3F
    ADC.B #$60
    STA.W SpriteMisc1540,X
CODE_01E0E2:
    LDA.B SpriteYPosLow,X
    SEC
    SBC.W SpriteMisc1528,X
    STA.B _0
    LDA.W SpriteYPosHigh,X
    SBC.W SpriteMisc151C,X
    LSR A
    ROR.B _0
    LDA.B _0
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_01E07B,Y
    BMI +
    STA.W SpriteMisc1564,X
    LDA.B #$80
  + STA.B SpriteYSpeed,X
    RTS

CODE_01E106:
    JSR SubSprYPosNoGrvty
    LDA.B EffFrame
    AND.B #$07
    ORA.B SpriteTableC2,X
    BNE +
    JSL CODE_0285DF
  + LDA.W SpriteMisc1564,X
    BNE CODE_01E12A
    LDA.B SpriteYSpeed,X
    BMI CODE_01E125
    LDY.B SpriteTableC2,X
    CMP.W DATA_01E091,Y
    BCS CODE_01E12A
CODE_01E125:
    CLC
    ADC.B #$02
    STA.B SpriteYSpeed,X
CODE_01E12A:
    JSR SubOffscreen0Bnk1
CODE_01E12D:
    LDA.B SpriteTableC2,X
    BEQ CODE_01E198
    LDY.B SpriteLock
    BNE CODE_01E164
    LDA.W SpriteBlockedDirs,X                 ; \ Branch if not on ground
    AND.B #$04                                ; |
    BEQ CODE_01E151                           ; /
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    LDA.W SpriteMisc1558,X
    BEQ CODE_01E14A
    CMP.B #$01
    BNE +
    JMP CODE_019ACB

CODE_01E14A:
    LDA.B #$80
    STA.W SpriteMisc1558,X
  + BRA CODE_01E164

CODE_01E151:
    TXA
    ASL A
    ASL A
    CLC
    ADC.B TrueFrame
    LDY.B #$F0
    AND.B #$04
    BEQ +
    LDY.B #$10
  + STY.B SpriteXSpeed,X
    JSR SubSprXPosNoGrvty
CODE_01E164:
    LDA.B SpriteYPosLow,X
    CMP.B #$F0
    BCC +
    STZ.W SpriteStatus,X
  + JSR SubSprGfx2Entry1
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    LDA.B EffFrame
    AND.B #$0C
    LSR A
    ADC.W CurSpriteProcess
    LSR A
    AND.B #$03
    TAX
    LDA.W BowserFlameTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_01E194,X
    ORA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    PLX
    RTS


BowserFlameTiles:
    db $2A,$2C,$2A,$2C

DATA_01E194:
    db $05,$05,$45,$45

CODE_01E198:
    LDA.B #$01
    JSR SubSprGfx0Entry0
    REP #$20                                  ; A->16
    LDA.W #$0008
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.W #$8500
    STA.W DynGfxTilePtr+6
    CLC
    ADC.W #$0200
    STA.W DynGfxTilePtr+$10
    SEP #$20                                  ; A->8
    RTS

InitKeyHole:
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$08
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W SpriteXPosHigh,X
    RTS

Keyhole:
    LDY.B #$0B
CODE_01E1CA:
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BCC CODE_01E1D8
    LDA.W SpriteNumber,Y
    CMP.B #$80
    BEQ CODE_01E1DB
CODE_01E1D8:
    DEY
    BPL CODE_01E1CA
CODE_01E1DB:
    LDA.W PlayerRidingYoshi
    BEQ CODE_01E1E5
    LDA.W YoshiHasKey
    BNE CODE_01E1ED
CODE_01E1E5:
    TYA
    STA.W SpriteMisc151C,X
    BMI CODE_01E23A
    BRA CODE_01E1F3

CODE_01E1ED:
    JSL GetMarioClipping
    BRA CODE_01E201

CODE_01E1F3:
    LDA.W SpriteStatus,Y
    CMP.B #$0B
    BNE CODE_01E23A
    PHX
    TYX
    JSL GetSpriteClippingB
    PLX
CODE_01E201:
    JSL GetSpriteClippingA
    JSL CheckForContact
    BCC CODE_01E23A
    LDA.W SpriteMisc154C,X
    BNE CODE_01E23A
    LDA.B #$30
    STA.W KeyholeTimer
    LDA.B #!BGM_KEYHOLE2
    STA.W SPCIO2                              ; / Change music
    INC.W PlayerIsFrozen
    INC.B SpriteLock
    LDA.W SpriteXPosHigh,X
    STA.W KeyholeXPos+1
    LDA.B SpriteXPosLow,X
    STA.W KeyholeXPos
    LDA.W SpriteYPosHigh,X
    STA.W KeyholeYPos+1
    LDA.B SpriteYPosLow,X
    STA.W KeyholeYPos
    LDA.B #$30
    STA.W SpriteMisc154C,X
CODE_01E23A:
    JSR GetDrawInfoBnk1
    LDA.B _0
    STA.W OAMTileXPos+$100,Y
    STA.W OAMTileXPos+$104,Y
    LDA.B _1
    STA.W OAMTileYPos+$100,Y
    CLC
    ADC.B #$08
    STA.W OAMTileYPos+$104,Y
    LDA.B #$EB
    STA.W OAMTileNo+$100,Y
    LDA.B #$FB
    STA.W OAMTileNo+$104,Y
    LDA.B #$30
    STA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    LDY.B #$00
    LDA.B #$01
    JSR FinishOAMWriteRt
    RTS

CODE_01E26A:
    LDA.B TrueFrame
    AND.B #$3F
    BNE +
    LDA.W BonusGame1UpCount
    BEQ +
    DEC.W BonusGame1UpCount
    JSR CODE_01E281
  + LDA.B #$01
    STA.W ActivateClusterSprite
    RTS

CODE_01E281:
    LDY.B #$07
CODE_01E283:
    LDA.W ClusterSpriteNumber,Y
    BEQ CODE_01E28C
    DEY
    BPL CODE_01E283
    RTS

CODE_01E28C:
    LDA.B #$01
    STA.W ClusterSpriteNumber,Y
    LDA.B #$00
    STA.W ClusterSpriteYPosLow,Y
    LDA.B #$01
    STA.W ClusterSpriteYPosHigh,Y
    LDA.B #$18
    STA.W ClusterSpriteXPosLow,Y
    LDA.B #$00
    STA.W ClusterSpriteXPosHigh,Y
    LDA.B #$01
    STA.W ClusterSpriteMisc1E66,Y
    LDA.B #$10
    STA.W ClusterSpriteMisc1E52,Y
    RTS

    %insert_empty($0D,$18,$18,$11,$0A)

    db $13,$14,$15,$16,$17,$18,$19

MontyMole:
    JSR SubOffscreen0Bnk1
    LDA.B SpriteTableC2,X
    JSL ExecutePtr

    dw CODE_01E2E0
    dw CODE_01E309
    dw CODE_01E37F
    dw CODE_01E393

CODE_01E2E0:
    JSR SubHorizPos
    LDA.B _F
    CLC
    ADC.B #$60
    CMP.B #$C0
    BCS CODE_01E305
    LDA.W SpriteOffscreenX,X
    BNE CODE_01E305
    INC.B SpriteTableC2,X
    LDY.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,Y
    TAY
    LDA.B #$68
    CPY.B #$01
    BEQ +
    LDA.B #$20
  + STA.W SpriteMisc1540,X
CODE_01E305:
    JSR GetDrawInfoBnk1
    RTS

CODE_01E309:
    LDA.W SpriteMisc1540,X
    ORA.W SpriteOnYoshiTongue,X
    BNE CODE_01E343
    INC.B SpriteTableC2,X
    LDA.B #$B0
    STA.B SpriteYSpeed,X
    JSR IsSprOffScreen
    BNE +
    TAY
    JSR CODE_0199E1
  + JSR FaceMario
    LDA.B SpriteNumber,X
    CMP.B #$4E
    BNE CODE_01E343
    LDA.B SpriteXPosLow,X                     ; \ $9A = Sprite X position
    STA.B TouchBlockXPos                      ; | for block creation
    LDA.W SpriteXPosHigh,X                    ; |
    STA.B TouchBlockXPos+1                    ; /
    LDA.B SpriteYPosLow,X                     ; \ $98 = Sprite Y position
    STA.B TouchBlockYPos                      ; | for block creation
    LDA.W SpriteYPosHigh,X                    ; |
    STA.B TouchBlockYPos+1                    ; /
    LDA.B #$08                                ; \ Block to generate = Mole hole
    STA.B Map16TileGenerate                   ; /
    JSL GenerateTile
CODE_01E343:
    LDA.B SpriteNumber,X
    CMP.B #$4D
    BNE +
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    LSR A
    AND.B #$01
    TAY
    LDA.W DATA_01E35F,Y
    STA.W SpriteMisc1602,X
    LDA.W DATA_01E361,Y
    JSR SubSprGfx0Entry0
    RTS


DATA_01E35F:
    db $01,$02

DATA_01E361:
    db $00,$05

  + LDA.B EffFrame
    ASL A
    ASL A
    AND.B #$C0
    ORA.B #$31
    STA.W SpriteOBJAttribute,X
    LDA.B #$03
    STA.W SpriteMisc1602,X
    JSR SubSprGfx2Entry1
    LDA.W SpriteOBJAttribute,X
    AND.B #$3F
    STA.W SpriteOBJAttribute,X
    RTS

CODE_01E37F:
    JSR CODE_01E3EF
    LDA.B #$02
    STA.W SpriteMisc1602,X
    JSR IsOnGround
    BEQ +
    INC.B SpriteTableC2,X
  + RTS


DATA_01E38F:
    db $10,$F0

DATA_01E391:
    db $18,$E8

CODE_01E393:
    JSR CODE_01E3EF
    LDA.W SpriteMisc151C,X
    BNE CODE_01E3C7
    JSR SetAnimationFrame
    JSR SetAnimationFrame
    JSL GetRand
    AND.B #$01
    BNE +
    JSR FaceMario
    LDA.B SpriteXSpeed,X
    CMP.W DATA_01E391,Y
    BEQ +
    CLC
    ADC.W DATA_01EBB4,Y
    STA.B SpriteXSpeed,X
    TYA
    LSR A
    ROR A
    EOR.B SpriteXSpeed,X
    BPL +
    JSR CODE_01804E
    JSR SetAnimationFrame
  + RTS

CODE_01E3C7:
    JSR IsOnGround
    BEQ CODE_01E3E9
    JSR SetAnimationFrame
    JSR SetAnimationFrame
    LDY.W SpriteMisc157C,X
    LDA.W DATA_01E38F,Y
    STA.B SpriteXSpeed,X
    LDA.W SpriteMisc1558,X
    BNE +
    LDA.B #$50
    STA.W SpriteMisc1558,X
    LDA.B #$D8
    STA.B SpriteYSpeed,X
  + RTS

CODE_01E3E9:
    LDA.B #$01
    STA.W SpriteMisc1602,X
    RTS

CODE_01E3EF:
    LDA.B SpriteProperties
    PHA
    LDA.W SpriteMisc1540,X
    BEQ +
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
  + JSR SubSprGfx2Entry1
    PLA
    STA.B SpriteProperties
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01E41C                           ; /
    JSR SubSprSpr_MarioSpr
    JSR SubUpdateSprPos
    JSR IsOnGround
    BEQ +
    JSR SetSomeYSpeed__
  + JSR IsTouchingObjSide
    BEQ +
    JSR FlipSpriteDir
  + RTS

CODE_01E41C:
    PLA
    PLA
    RTS


DATA_01E41F:
    db $08,$F8,$02,$03,$04,$04,$04,$04
    db $04,$04,$04,$04

DryBonesAndBeetle:
    LDA.W SpriteStatus,X
    CMP.B #$08
    BEQ +
    ASL.W SpriteOBJAttribute,X
    SEC
    ROR.W SpriteOBJAttribute,X
    JMP CODE_01E5BF


DATA_01E43C:
    db $08,$F8

  + LDA.W SpriteMisc1534,X
    BEQ CODE_01E4C0
    JSR SubSprGfx2Entry1
    LDY.W SpriteMisc1540,X
    BNE +
    STZ.W SpriteMisc1534,X
    PHY
    JSR FaceMario
    PLY
  + LDA.B #$48
    CPY.B #$10
    BCC +
    CPY.B #$F0
    BCS +
    LDA.B #$2E
  + LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    STA.W OAMTileNo+$100,Y
    TYA
    CLC
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    PHX
    LDA.W SpriteMisc157C,X
    TAX
    LDA.W OAMTileXPos+$100,Y
    CLC
    ADC.W DATA_01E43C,X
    PLX
    STA.W OAMTileXPos+$104,Y
    LDA.W OAMTileYPos+$100,Y
    STA.W OAMTileYPos+$104,Y
    LDA.W OAMTileAttr+$100,Y
    STA.W OAMTileAttr+$104,Y
    LDA.W OAMTileNo+$100,Y
    DEC A
    STA.W OAMTileNo+$104,Y
    LDA.W SpriteMisc1540,X
    BEQ +
    CMP.B #$40
    BCS +
    LSR A
    LSR A
    PHP
    LDA.W OAMTileXPos+$100,Y
    ADC.B #$00
    STA.W OAMTileXPos+$100,Y
    PLP
    LDA.W OAMTileXPos+$104,Y
    ADC.B #$00
    STA.W OAMTileXPos+$104,Y
  + LDY.B #$02
    LDA.B #$01
    JSR FinishOAMWriteRt
    JSR SubUpdateSprPos
    JSR IsOnGround
    BEQ +
    STZ.B SpriteYSpeed,X                      ; \ Sprite Speed = 0
    STZ.B SpriteXSpeed,X                      ; /
  + RTS

CODE_01E4C0:
    LDA.B SpriteLock
    ORA.W SpriteMisc163E,X
    BEQ +
    JMP CODE_01E5B6

  + LDY.W SpriteMisc157C,X
    LDA.W DATA_01E41F,Y
    EOR.W SpriteSlope,X
    ASL A
    LDA.W DATA_01E41F,Y
    BCC +
    CLC
    ADC.W SpriteSlope,X
  + STA.B SpriteXSpeed,X
    LDA.W SpriteMisc1540,X
    BNE CODE_01E4ED
    TYA
    INC A
    AND.W SpriteBlockedDirs,X                 ; \ Branch if not touching object
    AND.B #$03                                ; |
    BEQ +                                     ; /
CODE_01E4ED:
    STZ.B SpriteXSpeed,X
  + JSR IsTouchingCeiling
    BEQ +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + JSR SubOffscreen0Bnk1
    JSR SubUpdateSprPos
    LDA.B SpriteNumber,X
    CMP.B #$31
    BNE CODE_01E51E
    LDA.W SpriteMisc1540,X
    BEQ CODE_01E542
    LDY.B #$00
    CMP.B #$70
    BCS +
    INY
    INY
    CMP.B #$08
    BCC +
    CMP.B #$68
    BCS +
    INY
  + TYA
    STA.W SpriteMisc1602,X
    BRA CODE_01E563

CODE_01E51E:
    CMP.B #$30
    BEQ CODE_01E52D
    CMP.B #$32
    BNE CODE_01E542
    LDA.W TranslevelNo
    CMP.B #$31
    BNE CODE_01E542
CODE_01E52D:
    LDA.W SpriteMisc1540,X
    BEQ CODE_01E542
    CMP.B #$01
    BNE +
    JSL CODE_03C44E
  + LDA.B #$02
    STA.W SpriteMisc1602,X
    JMP CODE_01E5B6

CODE_01E542:
    JSR IsOnGround
    BEQ CODE_01E563
    JSR SetSomeYSpeed__
    JSR SetAnimationFrame
    LDA.B SpriteNumber,X
    CMP.B #$32
    BNE CODE_01E557
    STZ.B SpriteTableC2,X
    BRA +

CODE_01E557:
    LDA.W SpriteMisc1570,X
    AND.B #$7F
    BNE +
    JSR FaceMario
  + BRA +

CODE_01E563:
    STZ.W SpriteMisc1570,X
    LDA.B SpriteNumber,X
    CMP.B #$32
    BNE +
    LDA.B SpriteTableC2,X
    BNE +
    INC.B SpriteTableC2,X
    JSR FlipSpriteDir
    JSR SubSprXPosNoGrvty
    JSR SubSprXPosNoGrvty
  + LDA.B SpriteNumber,X
    CMP.B #$31
    BNE CODE_01E598
    LDA.B TrueFrame
    LSR A
    BCC +
    INC.W SpriteMisc1528,X
  + LDA.W SpriteMisc1528,X
    BNE CODE_01E5B6
    INC.W SpriteMisc1528,X
    LDA.B #$A0
    STA.W SpriteMisc1540,X
    BRA CODE_01E5B6

CODE_01E598:
    CMP.B #$30
    BEQ CODE_01E5A7
    CMP.B #$32
    BNE CODE_01E5B6
    LDA.W TranslevelNo
    CMP.B #$31
    BNE CODE_01E5B6
CODE_01E5A7:
    LDA.W SpriteMisc1570,X
    CLC
    ADC.B #$40
    AND.B #$7F
    BNE CODE_01E5B6
    LDA.B #$3F
    STA.W SpriteMisc1540,X
CODE_01E5B6:
    JSR CODE_01E5C4
    JSR SubSprSprInteract
    JSR FlipIfTouchingObj
CODE_01E5BF:
    JSL CODE_03C390
    RTS

CODE_01E5C4:
    JSR MarioSprInteractRt
    BCC Return01E610
    LDA.B PlayerYPosNow
    CLC
    ADC.B #$14
    CMP.B SpriteYPosLow,X
    BPL CODE_01E604
    LDA.W SpriteStompCounter
    BNE CODE_01E5DB
    LDA.B PlayerYSpeed+1
    BMI CODE_01E604
CODE_01E5DB:
    LDA.B SpriteNumber,X
    CMP.B #$31
    BNE CODE_01E5EB
    LDA.W SpriteMisc1540,X
    SEC
    SBC.B #$08
    CMP.B #$60
    BCC CODE_01E604
CODE_01E5EB:
    JSR CODE_01AB46
    JSL DisplayContactGfx
    LDA.B #!SFX_BONES                         ; \ Play sound effect
    STA.W SPCIO0                              ; /
    JSL BoostMarioSpeed
    INC.W SpriteMisc1534,X
    LDA.B #$FF
    STA.W SpriteMisc1540,X
    RTS

CODE_01E604:
    JSL HurtMario
    LDA.W IFrameTimer                         ; \ Return if Mario is invincible
    BNE Return01E610                          ; /
    JSR FaceMario
Return01E610:
    RTS


DATA_01E611:
    db $00,$01,$02,$02,$02,$01,$01,$00
    db $00

DATA_01E61A:
    db $1E,$1B,$18,$18,$18,$1A,$1C,$1D
    db $1E

SpringBoard:
    LDA.B SpriteLock
    BEQ +
    JMP CODE_01E6F0

  + JSR SubOffscreen0Bnk1
    JSR SubUpdateSprPos
    JSR IsOnGround
    BEQ +
    JSR CODE_0197D5
  + JSR IsTouchingObjSide
    BEQ +
    JSR FlipSpriteDir
    LDA.B SpriteXSpeed,X
    ASL A
    PHP
    ROR.B SpriteXSpeed,X
    PLP
    ROR.B SpriteXSpeed,X
  + JSR IsTouchingCeiling
    BEQ +
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
  + LDA.W SpriteMisc1540,X
    BEQ CODE_01E6B0
    LSR A
    TAY
    LDA.W PlayerRidingYoshi
    CMP.B #$01
    LDA.W DATA_01E61A,Y
    BCC +
    CLC
    ADC.B #$12
  + STA.B _0
    LDA.W DATA_01E611,Y
    STA.W SpriteMisc1602,X
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B _0
    STA.B PlayerYPosNext
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.B PlayerYPosNext+1
    STZ.B PlayerInAir
    STZ.B PlayerXSpeed+1
    LDA.B #$02
    STA.W StandOnSolidSprite
    LDA.W SpriteMisc1540,X
    CMP.B #$07
    BCS CODE_01E6AE
    STZ.W StandOnSolidSprite
    LDY.B #$B0
    LDA.B axlr0000Hold
    BPL CODE_01E69A
    LDA.B #$01
    STA.W SpinJumpFlag
    BRA CODE_01E69E

CODE_01E69A:
    LDA.B byetudlrHold
    BPL +
CODE_01E69E:
    LDA.B #$0B
    STA.B PlayerInAir
    LDY.B #$80
    STY.W BouncingOnBoard
  + STY.B PlayerYSpeed+1
    LDA.B #!SFX_SPRING                        ; \ Play sound effect
    STA.W SPCIO3                              ; /
CODE_01E6AE:
    BRA CODE_01E6F0

CODE_01E6B0:
    JSR ProcessInteract
    BCC CODE_01E6F0
    STZ.W SpriteMisc154C,X
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B PlayerYPosNext
    CLC
    ADC.B #$04
    CMP.B #$1C
    BCC CODE_01E6CE
    BPL CODE_01E6E7
    LDA.B PlayerYSpeed+1
    BPL CODE_01E6F0
    STZ.B PlayerYSpeed+1
    BRA CODE_01E6F0

CODE_01E6CE:
    BIT.B byetudlrHold
    BVC +
    LDA.W CarryingFlag                        ; \ Branch if carrying an enemy...
    ORA.W PlayerRidingYoshi                   ; | ...or if on Yoshi
    BNE +                                     ; /
    LDA.B #$0B                                ; \ Sprite status = carried
    STA.W SpriteStatus,X                      ; /
    STZ.W SpriteMisc1602,X
  + JSR CODE_01AB31
    BRA CODE_01E6F0

CODE_01E6E7:
    LDA.B PlayerYSpeed+1
    BMI CODE_01E6F0
    LDA.B #$11
    STA.W SpriteMisc1540,X
CODE_01E6F0:
    LDY.W SpriteMisc1602,X
    LDA.W DATA_01E6FD,Y
    TAY
    LDA.B #$02
    JSR SubSprGfx0Entry1
    RTS


DATA_01E6FD:
    db $00,$02,$00

SmushedGfxRt:
    JSR GetDrawInfoBnk1
    JSR IsSprOffScreen
    BNE Return01E75A
    LDA.B _0                                  ; \ Set X displacement for both tiles
    STA.W OAMTileXPos+$100,Y                  ; | (Sprite position + #$00/#$08)
    CLC                                       ; |
    ADC.B #$08                                ; |
    STA.W OAMTileXPos+$104,Y                  ; /
    LDA.B _1                                  ; \ Set Y displacement for both tiles
    CLC                                       ; | (Sprite position + #$08)
    ADC.B #$08                                ; |
    STA.W OAMTileYPos+$100,Y                  ; |
    STA.W OAMTileYPos+$104,Y                  ; /
    PHX
    LDA.B SpriteNumber,X
    TAX
    LDA.B #$FE                                ; \ If P Switch, tile = #$FE
    CPX.B #$3E                                ; |
    BEQ +                                     ; /
    LDA.B #$EE                                ; \ If Sliding Koopa...
    CPX.B #$BD                                ; |
    BEQ +                                     ; |
    CPX.B #$04                                ; | ...or a shelless, tile = #$EE
    BCC +                                     ; /
    LDA.B #$C7                                ; \ If sprite num >= #$0F, tile = #$C7 (is this used?)
    CPX.B #$0F                                ; |
    BCS +                                     ; /
    LDA.B #$4D                                ; If #$04 <= sprite num < #$0F, tile = #$4D (Koopas)
  + STA.W OAMTileNo+$100,Y                    ; \ Same value for both tiles
    STA.W OAMTileNo+$104,Y                    ; /
    PLX
    LDA.B SpriteProperties                    ; \ Store the first tile's properties
    ORA.W SpriteOBJAttribute,X                ; |
    STA.W OAMTileAttr+$100,Y                  ; /
    ORA.B #!OBJ_XFlip                         ; \ Horizontally flip the second tile and store it
    STA.W OAMTileAttr+$104,Y                  ; /
    TYA                                       ; \ Y = index to size table
    LSR A                                     ; |
    LSR A                                     ; |
    TAY                                       ; /
    LDA.B #$00                                ; \ Two 8x8 tiles
    STA.W OAMTileSize+$40,Y                   ; |
    STA.W OAMTileSize+$41,Y                   ; /
Return01E75A:
    RTS

PSwitch:
    LDA.W SpriteMisc1564,X
    CMP.B #$01
    BNE +
    STA.W OWPlayerSubmap
    STA.W SaveDataBufferSubmap
    STZ.W SpriteStatus,X
    INC.W MessageBoxTrigger
  + RTS


DATA_01E76F:
    db $FC,$04,$FE,$02,$FB,$05,$FD,$03
    db $FA,$06,$FC,$04,$FB,$05,$FD,$03
DATA_01E77F:
    db $00,$FF,$03,$04,$FF,$FE,$04,$03
    db $FE,$FF,$03,$03,$FF,$00,$03,$03
    db $F8,$FC,$00,$04

DATA_01E793:
    db $0E,$0F,$10,$11,$12,$11,$10,$0F
    db $1A,$1B,$1C,$1D,$1E,$1D,$1C,$1B
    db $1A

LakituCloud:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BEQ +                                     ; /
CODE_01E7A8:
    JMP LakituCloudGfx

  + LDY.W LakituCloudTimer
    BEQ +
    LDA.B EffFrame
    AND.B #$03
    BNE +
    LDA.W LakituCloudTimer
    BEQ +
    DEC.W LakituCloudTimer
    BNE +
    LDA.B #$1F
    STA.W SpriteMisc1540,X
  + LDA.W SpriteMisc1540,X
    BEQ CODE_01E7DB
    DEC A
    BNE CODE_01E7A8
    STZ.W SpriteStatus,X
    LDA.B #$FF                                ; \ Set time until respawn
    STA.W SpriteRespawnTimer                  ; |
    LDA.B #$1E                                ; | Sprite to respawn = Lakitu
    STA.W SpriteRespawnNumber                 ; /
    RTS

CODE_01E7DB:
    LDY.B #$09
CODE_01E7DD:
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BNE +
    LDA.W SpriteNumber,Y
    CMP.B #$1E
    BNE +
    TYA
    STA.W SpriteMisc160E,X
    JMP CODE_01E898

  + DEY
    BPL CODE_01E7DD
    LDA.B SpriteTableC2,X
    BNE CODE_01E840
    LDA.W SpriteMisc151C,X
    BEQ +
    JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
  + LDA.W SpriteMisc154C,X
    BNE CODE_01E83D
    JSR ProcessInteract
    BCC CODE_01E83D
    LDA.B PlayerYSpeed+1
    BMI CODE_01E83D
    INC.B SpriteTableC2,X
    LDA.B #$11
    LDY.W PlayerRidingYoshi
    BEQ +
    LDA.B #$22
  + CLC
    ADC.B PlayerYPosNow
    STA.B SpriteYPosLow,X
    LDA.B PlayerYPosNow+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.B PlayerXPosNow
    STA.B SpriteXPosLow,X
    LDA.B PlayerXPosNow+1
    STA.W SpriteXPosHigh,X
    LDA.B #$10
    STA.B SpriteYSpeed,X
    STA.W SpriteMisc151C,X
    LDA.B PlayerXSpeed+1
    STA.B SpriteXSpeed,X
CODE_01E83D:
    JMP LakituCloudGfx

CODE_01E840:
    JSR LakituCloudGfx
    PHB
    LDA.B #$02
    PHA
    PLB
    JSL CODE_02D214
    PLB
    LDA.B SpriteYSpeed,X
    CLC
    ADC.B #$03
    STA.B PlayerYSpeed+1
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    AND.B #$07
    TAY
    LDA.W PlayerRidingYoshi
    BEQ +
    TYA
    CLC
    ADC.B #$08
    TAY
  + LDA.B PlayerXPosNow
    STA.B SpriteXPosLow,X
    LDA.B PlayerXPosNow+1
    STA.W SpriteXPosHigh,X
    LDA.B PlayerYPosNow
    CLC
    ADC.W DATA_01E793,Y
    STA.B SpriteYPosLow,X
    LDA.B PlayerYPosNow+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    STZ.B PlayerInAir
    INC.W StandOnSolidSprite
    INC.W PlayerInCloud
    LDA.B byetudlrFrame
    AND.B #$80
    BEQ Return01E897
    LDA.B #$C0
    STA.B PlayerYSpeed+1
    LDA.B #$10
    STA.W SpriteMisc154C,X
    STZ.B SpriteTableC2,X
Return01E897:
    RTS

CODE_01E898:
    PHY
    JSR CODE_01E98D
    LDA.B EffFrame
    LSR A
    LSR A
    LSR A
    AND.B #$07
    TAY
    LDA.W DATA_01E793,Y
    STA.B _0
    PLY
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B _0
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.W SpriteYPosHigh,Y
    LDA.B #$10
    STA.W SpriteMisc154C,X
LakituCloudGfx:
    JSR GetDrawInfoBnk1
    LDA.W SpriteOffscreenVert,X
    BNE Return01E897
    LDA.B #$F8
    STA.B _C
    LDA.B #$FC
    STA.B _D
    LDA.B #$00
    LDY.B SpriteTableC2,X
    BNE +
    LDA.B #$30
  + STA.B _E
    STA.W TileGenerateTrackB
    ORA.B #$04
    STA.B _F
    LDA.B _0
    STA.W LakituCloudTempXPos
    LDA.B _1
    STA.W LakituCloudTempYPos
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$0C
    STA.B _2
    LDA.B #$03
    STA.B _3
CODE_01E901:
    LDA.B _3
    TAX
    LDY.B _C,X
    CLC
    ADC.B _2
    TAX
    %LorW_X(LDA,DATA_01E76F)
    CLC
    ADC.W LakituCloudTempXPos
    STA.W OAMTileXPos+$100,Y
    %LorW_X(LDA,DATA_01E77F)
    CLC
    ADC.W LakituCloudTempYPos
    STA.W OAMTileYPos+$100,Y
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B #$60
    STA.W OAMTileNo+$100,Y
    LDA.W SpriteMisc1540,X
    BEQ +
    LSR A
    LSR A
    LSR A
    TAX
    LDA.W CloudTiles,X
    STA.W OAMTileNo+$100,Y
  + LDA.B SpriteProperties
    STA.W OAMTileAttr+$100,Y
    INY
    INY
    INY
    INY
    DEC.B _3
    BPL CODE_01E901
    LDX.W CurSpriteProcess                    ; X = Sprite index
    LDA.B #$F8
    STA.W SpriteOAMIndex,X
    LDY.B #$02
    LDA.B #$01
    JSR FinishOAMWriteRt
    LDA.W TileGenerateTrackB
    STA.W SpriteOAMIndex,X
    LDY.B #$02
    LDA.B #$01
    JSR FinishOAMWriteRt
    LDA.W SpriteOffscreenX,X
    BNE Return01E984
    LDA.W LakituCloudTempXPos
    CLC
    ADC.B #$04
    STA.W OAMTileXPos+8
    LDA.W LakituCloudTempYPos
    CLC
    ADC.B #$07
    STA.W OAMTileYPos+8
    LDA.B #$4D
    STA.W OAMTileNo+8
    LDA.B #$39
    STA.W OAMTileAttr+8
    LDA.B #$00
    STA.W OAMTileSize+2
Return01E984:
    RTS


CloudTiles:
    db $66,$64,$62,$60

DATA_01E989:
    db $20,$E0

DATA_01E98B:
    db $10,$F0

CODE_01E98D:
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return01E984                          ; /
    JSR SubHorizPos
    TYA
    LDY.W SpriteMisc160E,X
    STA.W SpriteMisc157C,Y
    STA.B _0
    LDY.B _0
    LDA.W SpriteWillAppear
    BEQ CODE_01E9BD
    PHY
    PHX
    LDA.W SpriteMisc160E,X
    TAX
    JSR SubOffscreen0Bnk1
    LDA.W SpriteStatus,X
    PLX
    CMP.B #$00
    BNE +
    STZ.W SpriteStatus,X
  + PLY
    TYA
    EOR.B #$01
    TAY
CODE_01E9BD:
    LDA.B TrueFrame
    AND.B #$01
    BNE CODE_01E9E6
    LDA.B SpriteXSpeed,X
    CMP.W DATA_01E989,Y
    BEQ +
    CLC
    ADC.W DATA_01EBB4,Y
    STA.B SpriteXSpeed,X
  + LDA.W SpriteMisc1534,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W DATA_01EBB4,Y
    STA.B SpriteYSpeed,X
    CMP.W DATA_01E98B,Y
    BNE CODE_01E9E6
    INC.W SpriteMisc1534,X
CODE_01E9E6:
    LDA.B SpriteXSpeed,X
    PHA
    LDY.W SpriteWillAppear
    BNE +
    LDA.W Layer1DXPos
    ASL A
    ASL A
    ASL A
    CLC
    ADC.B SpriteXSpeed,X
    STA.B SpriteXSpeed,X
  + JSR SubSprXPosNoGrvty
    PLA
    STA.B SpriteXSpeed,X
    JSR SubSprYPosNoGrvty
    LDY.W SpriteMisc160E,X
    LDA.B TrueFrame
    AND.B #$7F
    ORA.W SpriteMisc151C,Y
    BNE +
    LDA.B #$20
    STA.W SpriteMisc1558,Y
    JSR CODE_01EA21
  + RTS


DATA_01EA17:
    db $10,$F0

CODE_01EA19:
    PHB                                       ; Wrapper
    PHK
    PLB
    JSR CODE_01EA21
    PLB
    RTL

CODE_01EA21:
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BMI Return01EA6F                          ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.W SilverPSwitchTimer
    CMP.B #$01
    LDA.B #$14
    BCC +
    LDA.B #$21
  + STA.W SpriteNumber,Y
    LDA.B SpriteXPosLow,X
    STA.W SpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    LDA.B #$D8
    STA.B SpriteYSpeed,X
    JSR SubHorizPos
    LDA.W DATA_01EA17,Y
    STA.B SpriteXSpeed,X
    LDA.B SpriteNumber,X
    CMP.B #$21
    BNE +
    LDA.B #$02
    STA.W SpriteOBJAttribute,X
  + TXY
    PLX
Return01EA6F:
    RTS

CODE_01EA70:
    LDX.W YoshiIsLoose
    BEQ +
    STZ.W ScrShakePlayerYOffset
    STZ.W YoshiHasKey
    LDA.W CurSpriteProcess
    PHA
    DEX
    STX.W CurSpriteProcess
    PHB
    PHK
    PLB
    JSR CODE_01EA8F
    PLB
    PLA
    STA.W CurSpriteProcess
  + RTL

CODE_01EA8F:
    LDA.W YoshiGrowingTimer
    ORA.W CutsceneID
    BEQ +
    JMP CODE_01EB48

  + STZ.W PlayerDuckingOnYoshi
    LDA.B SpriteTableC2,X
    CMP.B #$02
    BCC CODE_01EAA7
    LDA.B #$30
    BRA CODE_01EAB2

CODE_01EAA7:
    LDY.B #$00
    LDA.B PlayerXSpeed+1                      ; \ Branch if Mario X speed == 0
    BEQ CODE_01EADF                           ; /
    BPL CODE_01EAB2                           ; \ If Mario X speed is positive,
    EOR.B #$FF                                ; | invert it
    INC A                                     ; /
CODE_01EAB2:
    LSR A                                     ; \ Y = Upper 4 bits of X speed
    LSR A                                     ; |
    LSR A                                     ; |
    LSR A                                     ; |
    TAY                                       ; /
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    DEC.W SpriteMisc1570,X                    ; \ If time to change frame...
    BPL +                                     ; |
    LDA.W DATA_01EDF5,Y                       ; | Set time to display new frame (based on Mario's X speed)
    STA.W SpriteMisc1570,X                    ; |
    DEC.W YoshiWalkingTimer                   ; | Set index to new frame, $18AD = ($18AD-1) % 3
    BPL +                                     ; |
    LDA.B #$02                                ; |
    STA.W YoshiWalkingTimer                   ; /
  + LDY.W YoshiWalkingTimer                   ; \ Y = frame to show
    LDA.W YoshiWalkFrames,Y                   ; |
    TAY                                       ; /
    LDA.B SpriteTableC2,X
    CMP.B #$02
    BCS CODE_01EB2E
    BRA +

CODE_01EADF:
    STZ.W SpriteMisc1570,X
  + LDA.B PlayerInAir
    BEQ +
    LDY.B #$02
    LDA.B PlayerYSpeed+1
    BPL +
    LDY.B #$05
    BRA +

  + LDA.W SpriteMisc15AC,X
    BEQ +
    LDY.B #$03
  + LDA.B PlayerInAir
    BNE CODE_01EB21
    LDA.W SpriteMisc151C,X
    BEQ CODE_01EB0C
    LDY.B #$07
    LDA.B byetudlrHold
    AND.B #$08
    BEQ +
    LDY.B #$06
  + BRA CODE_01EB21

CODE_01EB0C:
    LDA.W YoshiDuckTimer
    BEQ CODE_01EB16
    DEC.W YoshiDuckTimer
    BRA CODE_01EB1C

CODE_01EB16:
    LDA.B byetudlrHold
    AND.B #$04
    BEQ CODE_01EB21
CODE_01EB1C:
    LDY.B #$04
    INC.W PlayerDuckingOnYoshi
CODE_01EB21:
    LDA.B SpriteTableC2,X
    CMP.B #$01
    BEQ CODE_01EB2E
    LDA.W SpriteMisc151C,X
    BNE CODE_01EB2E
    LDY.B #$04
CODE_01EB2E:
    LDA.W PlayerRidingYoshi
    BEQ +
    LDA.W YoshiInPipeSetting
    CMP.B #$01
    BNE +
    LDA.B TrueFrame
    AND.B #$08
    LSR A
    LSR A
    LSR A
    ADC.B #$08
    TAY
  + TYA
    STA.W SpriteMisc1602,X
CODE_01EB48:
    LDA.B SpriteTableC2,X
    CMP.B #$01
    BNE CODE_01EB97
    LDY.W SpriteMisc157C,X
    LDA.B PlayerXPosNext
    CLC
    ADC.W YoshiPositionX,Y
    STA.B SpriteXPosLow,X
    LDA.B PlayerXPosNext+1
    ADC.W DATA_01EDF3,Y
    STA.W SpriteXPosHigh,X
    LDY.W SpriteMisc1602,X
    LDA.B PlayerYPosNext
    CLC
    ADC.B #$10
    STA.B SpriteYPosLow,X
    LDA.B PlayerYPosNext+1
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    LDA.W DATA_01EDE4,Y
    STA.W ScrShakePlayerYOffset
    LDA.B #$01
    LDY.W SpriteMisc1602,X
    CPY.B #$03
    BNE +
    INC A
  + STA.W PlayerRidingYoshi
    LDA.B #$01
    STA.W CarryYoshiThruLvls
    LDA.W SpriteOBJAttribute,X                ; \ $13C7 = Yoshi palette
    STA.W YoshiColor                          ; /
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.B PlayerDirection
CODE_01EB97:
    LDA.B SpriteProperties
    PHA
    LDA.W PlayerRidingYoshi
    BEQ CODE_01EBAD
    LDA.W YoshiInPipeSetting
    BEQ CODE_01EBAD
    LDA.W DrawYoshiInPipe
    BNE +
    LDA.B #!OBJ_Priority1
    STA.B SpriteProperties
CODE_01EBAD:
    JSR HandleOffYoshi
  + PLA
    STA.B SpriteProperties
    RTS


DATA_01EBB4:
    db $01,$FF,$01,$00,$FF,$00,$20,$E0
    db $0A,$0E

DATA_01EBBE:
    db $E8,$18

DATA_01EBC0:
    db $10,$F0

GrowingAniSequence:
    db $0C,$0B,$0C,$0B,$0A,$0B,$0A,$0B

Yoshi:
    STZ.W PlayerIsFrozen
    LDA.W YoshiHasWingsEvt                    ; \ $1410 = winged Yoshi flag
    STA.W YoshiHasWingsGfx                    ; /
    STZ.W YoshiHasWingsEvt                    ; Clear real winged Yoshi flag
    STZ.W YoshiCanStomp                       ; Clear stomp Yoshi flag
    STZ.W Empty191B
    LDA.W SpriteStatus,X                      ; \ Branch if normal Yoshi status
    CMP.B #$08                                ; |
    BEQ +                                     ; /
    STZ.W CarryYoshiThruLvls                  ; Mario won't have Yoshi when returning to OW
    JMP HandleOffYoshi

  + TXA
    INC A
    STA.W CurrentYoshiSlot
    LDA.W PlayerRidingYoshi
    BNE CODE_01EC04
    JSR SubOffscreen0Bnk1
    LDA.W SpriteStatus,X
    BNE CODE_01EC04
    LDA.W YoshiHeavenFlag
    BNE +
    STZ.W CarryYoshiThruLvls
  + RTS

CODE_01EC04:
    LDA.W PlayerRidingYoshi
    BEQ CODE_01EC0E
    LDA.W YoshiInPipeSetting
    BNE CODE_01EC61
CODE_01EC0E:
    LDA.W EggLaidTimer
    BNE CODE_01EC61
    LDA.W YoshiGrowingTimer
    BEQ CODE_01EC4C
    DEC.W YoshiGrowingTimer
    STA.B SpriteLock
    STA.W PlayerIsFrozen
    CMP.B #$01
    BNE +
    STZ.B SpriteLock
    STZ.W PlayerIsFrozen
    LDY.W PlayerTurnLvl
    LDA.W OWPlayerSubmap,Y
    DEC A
    ORA.W YoshiSavedFlag
    ORA.W OverworldOverride
    BNE +
    INC.W YoshiSavedFlag
    LDA.B #$03
    STA.W MessageBoxTrigger
  + DEC A
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W GrowingAniSequence,Y                ; \ Set image to appropriate frame
    STA.W SpriteMisc1602,X                    ; /
    RTS

CODE_01EC4C:
    LDA.B SpriteLock
    BEQ CODE_01EC61
CODE_01EC50:
    LDY.W PlayerRidingYoshi
    BEQ +
    LDY.B #$06
    STY.W ScrShakePlayerYOffset
  + RTS


DATA_01EC5B:
    db $F0,$10

DATA_01EC5D:
    db $FA,$06

DATA_01EC5F:
    db $FF,$00

CODE_01EC61:
    LDA.B PlayerInAir
    BNE CODE_01EC6A
    LDA.W EggLaidTimer
    BNE +
CODE_01EC6A:
    JMP CODE_01ECE1

  + DEC.W EggLaidTimer
    CMP.B #$01
    BNE CODE_01EC78
    STZ.B SpriteLock
    BRA CODE_01EC6A

CODE_01EC78:
    INC.W PlayerIsFrozen
    JSR CODE_01EC50
    STY.B SpriteLock
    CMP.B #$02
    BNE Return01EC8A
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BPL +                                     ; |
Return01EC8A:
    RTS                                       ; /

  + LDA.B #$09                                ; \ Sprite status = Carryable
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$2C
    STA.W SpriteNumber,Y
    PHY
    PHY
    LDY.W SpriteMisc157C,X
    STY.B _F
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_01EC5D,Y
    PLY
    STA.W SpriteXPosLow,Y
    LDY.W SpriteMisc157C,X
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_01EC5F,Y
    PLY
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$08
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W SpriteYPosHigh,Y
    PHX
    TYX
    JSL InitSpriteTables
    LDY.B _F
    LDA.W DATA_01EC5B,Y
    STA.B SpriteXSpeed,X
    LDA.B #$F0
    STA.B SpriteYSpeed,X
    LDA.B #$10
    STA.W SpriteMisc154C,X
    LDA.W YoshiEggSpriteHatch
    STA.W SpriteMisc151C,X
    PLX
    RTS

CODE_01ECE1:
    LDA.B SpriteTableC2,X
    CMP.B #$01
    BNE +
    JMP CODE_01ED70

  + JSR SubUpdateSprPos
    JSR IsOnGround
    BEQ +
    JSR SetSomeYSpeed__
    LDA.B SpriteTableC2,X
    CMP.B #$02
    BCS +
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    LDA.B #$F0
    STA.B SpriteYSpeed,X
  + JSR UpdateDirection
    JSR IsTouchingObjSide
    BEQ +
    JSR CODE_0190A2
  + LDA.B #$04
    CLC
    ADC.B SpriteXPosLow,X
    STA.B _4
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.B _A
    LDA.B #$13
    CLC
    ADC.B SpriteYPosLow,X
    STA.B _5
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _B
    LDA.B #$08
    STA.B _7
    STA.B _6
    JSL GetMarioClipping
    JSL CheckForContact
    BCC CODE_01ED70
    LDA.B PlayerInAir
    BEQ CODE_01ED70
    LDA.W CarryingFlag                        ; \ Branch if carrying an enemy...
    ORA.W PlayerRidingYoshi                   ; | ...or if on Yoshi
    BNE CODE_01ED70                           ; /
    LDA.B PlayerYSpeed+1                      ; \ Branch if upward speed
    BMI CODE_01ED70                           ; /
    LDY.B #$01
    JSR CODE_01EDCE
    STZ.B PlayerXSpeed+1                      ; \ Mario's speed = 0
    STZ.B PlayerYSpeed+1                      ; /
    LDA.B #$0C
    STA.W YoshiDuckTimer
    LDA.B #$01
    STA.B SpriteTableC2,X
    LDA.B #!SFX_YOSHIDRUMON                   ; \ Play sound effect
    STA.W SPCIO1                              ; /
    LDA.B #!SFX_YOSHI                         ; \ Play sound effect
    STA.W SPCIO3                              ; /
    JSL DisabledAddSmokeRt
    LDA.B #$20
    STA.W SpriteMisc163E,X
    INC.W SpriteStompCounter
CODE_01ED70:
    LDA.B SpriteTableC2,X
    CMP.B #$01
    BNE Return01EDCB
    JSR CODE_01F622
    LDA.B byetudlrHold
    AND.B #$03
    BEQ +
    DEC A
    CMP.W SpriteMisc157C,X
    BEQ +
    LDA.W SpriteMisc15AC,X
    ORA.W SpriteMisc151C,X
    ORA.W PlayerDuckingOnYoshi
    BNE +
    LDA.B #$10                                ; \ Set turning timer
    STA.W SpriteMisc15AC,X                    ; /
  + LDA.W PBalloonInflating
    BNE CODE_01ED9E
    BIT.B axlr0000Frame
    BPL Return01EDCB
CODE_01ED9E:
    LDA.B #$02
    STA.W SpriteMisc1FE2,X
    STZ.B SpriteTableC2,X
    LDA.B #!SFX_YOSHIDRUMOFF                  ; \ Play sound effect
    STA.W SPCIO1                              ; /
    STZ.W CarryYoshiThruLvls
    LDA.B PlayerXSpeed+1
    STA.B SpriteXSpeed,X
    LDA.B #$A0
    LDY.B PlayerInAir
    BNE +
    JSR SubHorizPos
    LDA.W DATA_01EBC0,Y
    STA.B PlayerXSpeed+1
    LDA.B #$C0
  + STA.B PlayerYSpeed+1
    STZ.W PlayerRidingYoshi
    STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    JSR CODE_01EDCC
Return01EDCB:
    RTS

CODE_01EDCC:
    LDY.B #$00
CODE_01EDCE:
    LDA.B SpriteYPosLow,X
    SEC
    SBC.W DATA_01EDE2,Y
    STA.B PlayerYPosNext
    STA.B PlayerYPosNow
    LDA.W SpriteYPosHigh,X
    SBC.B #$00
    STA.B PlayerYPosNext+1
    STA.B PlayerYPosNow+1
    RTS


DATA_01EDE2:
    db $04,$10

DATA_01EDE4:
    db $06,$05,$05,$05,$0A,$05,$05,$0A
    db $0A,$0B

YoshiWalkFrames:
    db $02,$01,$00

YoshiPositionX:
    db $02,$FE

DATA_01EDF3:
    db $00,$FF

DATA_01EDF5:
    db $03,$02,$01,$00

YoshiHeadTiles:
    db $00,$01,$02,$03,$02,$10,$04,$05
    db $00,$00,$FF,$FF,$00

YoshiBodyTiles:
    db $06,$07,$08,$09,$0A,$0B,$06,$0C
    db $0A,$0D,$0E,$0F,$0C

YoshiHeadDispX:
    db $0A,$09,$0A,$06,$0A,$0A,$0A,$10
    db $0A,$0A,$00,$00,$0A,$F6,$F7,$F6
    db $FA,$F6,$F6,$F6,$F0,$F6,$F6,$00
    db $00,$F6

DATA_01EE2D:
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$FF,$FF,$FF
    db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00
    db $00,$FF

YoshiPositionY:
    db $00,$01,$01,$00,$04,$00,$00,$04
    db $03,$03,$00,$00,$04

YoshiHeadDispY:
    db $00,$00,$01,$00,$00,$00,$00,$08
    db $00,$00,$00,$00,$05

HandleOffYoshi:
    LDA.W SpriteMisc1602,X
    PHA
    LDY.W SpriteMisc15AC,X
    CPY.B #$08
    BNE +
    LDA.W YoshiInPipeSetting
    ORA.B SpriteLock
    BNE +
    LDA.W SpriteMisc157C,X
    STA.B PlayerDirection
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + LDA.W YoshiInPipeSetting
    BMI +
    CMP.B #$02
    BNE +
    INC A
    STA.W SpriteMisc1602,X
  + JSR CODE_01EF18
    LDY.B _E
    LDA.W OAMTileNo+$100,Y
    STA.B _0
    STZ.B _1
    LDA.B #$06
    STA.W OAMTileNo+$100,Y
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileNo+$100,Y
    STA.B _2
    STZ.B _3
    LDA.B #$08
    STA.W OAMTileNo+$100,Y
    REP #$20                                  ; A->16
    LDA.B _0
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.W #$8500
    STA.W DynGfxTilePtr+6
    CLC
    ADC.W #$0200
    STA.W DynGfxTilePtr+$10
    LDA.B _2
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC.W #$8500
    STA.W DynGfxTilePtr+8
    CLC
    ADC.W #$0200
    STA.W DynGfxTilePtr+$12
    SEP #$20                                  ; A->8
    PLA
    STA.W SpriteMisc1602,X
    JSR CODE_01F0A2
    LDA.W YoshiHasWingsGfx                    ; \ Return if Yoshi doesn't have wings
    CMP.B #$02                                ; |
    BCC Return01EF17                          ; /
    LDA.W PlayerRidingYoshi
    BEQ CODE_01EF13
    LDA.B PlayerInAir
    BNE CODE_01EF00
    LDA.B PlayerXSpeed+1
    BPL +
    EOR.B #$FF
    INC A
  + CMP.B #$28
    LDA.B #$01
    BCS CODE_01EF13
    LDA.B #$00
    BRA CODE_01EF13

CODE_01EF00:
    LDA.B EffFrame
    LSR A
    LSR A
    LDY.B PlayerYSpeed+1
    BMI +
    LSR A
    LSR A
  + AND.B #$01
    BNE CODE_01EF13
    LDY.B #!SFX_YOSHITONGUE                   ; \ Play sound effect
    STY.W SPCIO3                              ; /
CODE_01EF13:
    JSL CODE_02BB23
Return01EF17:
    RTS

CODE_01EF18:
    LDY.W SpriteMisc1602,X
    STY.W TileGenerateTrackA
    LDA.W YoshiHeadTiles,Y
    STA.W SpriteMisc1602,X
    STA.B _F
    LDA.B SpriteYPosLow,X
    PHA
    CLC
    ADC.W YoshiPositionY,Y
    STA.B SpriteYPosLow,X
    LDA.W SpriteYPosHigh,X
    PHA
    ADC.B #$00
    STA.W SpriteYPosHigh,X
    TYA
    LDY.W SpriteMisc157C,X
    BEQ +
    CLC
    ADC.B #$0D
  + TAY
    LDA.B SpriteXPosLow,X
    PHA
    CLC
    ADC.W YoshiHeadDispX,Y
    STA.B SpriteXPosLow,X
    LDA.W SpriteXPosHigh,X
    PHA
    ADC.W DATA_01EE2D,Y
    STA.W SpriteXPosHigh,X
    LDA.W SpriteOAMIndex,X
    PHA
    LDA.W SpriteMisc15AC,X
    ORA.W YoshiInPipeSetting
    BEQ +
    LDA.B #$04
    STA.W SpriteOAMIndex,X
  + LDA.W SpriteOAMIndex,X
    STA.B _E
    JSR SubSprGfx2Entry1
    PHX
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDX.W TileGenerateTrackA
    LDA.W OAMTileYPos+$100,Y
    CLC
    %LorW_X(ADC,YoshiHeadDispY)
    STA.W OAMTileYPos+$100,Y
    PLX
    PLA
    CLC
    ADC.B #$04
    STA.W SpriteOAMIndex,X
    PLA
    STA.W SpriteXPosHigh,X
    PLA
    STA.B SpriteXPosLow,X
    LDY.W TileGenerateTrackA
    LDA.W YoshiBodyTiles,Y
    STA.W SpriteMisc1602,X
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$10
    STA.B SpriteYPosLow,X
    BCC +
    INC.W SpriteYPosHigh,X
  + JSR SubSprGfx2Entry1
    PLA
    STA.W SpriteYPosHigh,X
    PLA
    STA.B SpriteYPosLow,X
    LDY.B _E
    LDA.B _F
    BPL +
    LDA.B #$F0
    STA.W OAMTileYPos+$100,Y
  + LDA.B SpriteTableC2,X
    BNE CODE_01EFC6
    LDA.B EffFrame
    AND.B #$30
    BNE CODE_01EFDB
    LDA.B #$2A
    BRA CODE_01EFFA

CODE_01EFC6:
    CMP.B #$02
    BNE CODE_01EFDB
    LDA.W SpriteMisc151C,X
    ORA.W CutsceneID
    BNE CODE_01EFDB
    LDA.B EffFrame
    AND.B #$10
    BEQ CODE_01EFFD
    BRA CODE_01EFF8

Return01EFDA:
    RTS

CODE_01EFDB:
    LDA.W SpriteMisc1594,X
    CMP.B #$03
    BEQ CODE_01EFEE
    LDA.W SpriteMisc151C,X
    BEQ +
    LDA.W OAMTileNo+$100,Y
    CMP.B #$24
    BEQ +
CODE_01EFEE:
    LDA.B #$2A
    STA.W OAMTileNo+$100,Y
  + LDA.W YoshiStartEatTimer
    BEQ CODE_01EFFD
CODE_01EFF8:
    LDA.B #$0C
CODE_01EFFA:
    STA.W OAMTileNo+$100,Y
CODE_01EFFD:
    LDA.W SpriteMisc1564,X
    LDY.W YoshiSwallowTimer
    BEQ CODE_01F00F
    CPY.B #$26
    BCS CODE_01F038
    LDA.B EffFrame
    AND.B #$18
    BNE CODE_01F038
CODE_01F00F:
    LDA.W SpriteMisc1564,X
    CMP.B #$00
    BEQ Return01EFDA
    LDY.B #$00
    CMP.B #$0F
    BCC CODE_01F03A
    CMP.B #$1C
    BCC CODE_01F038
    BNE +
    LDA.B _E
    PHA
    JSL SetTreeTile
    JSR CODE_01F0D3
    PLA
    STA.B _E
  + INC.W PlayerIsFrozen
    LDA.B #$00
    LDY.B #$2A
    BRA CODE_01F03A

CODE_01F038:
    LDY.B #$04
CODE_01F03A:
    PHA
    TYA
    LDY.B _E
    STA.W OAMTileNo+$100,Y
    PLA
    CMP.B #$0F
    BCS Return01F0A0
    CMP.B #$05
    BCC Return01F0A0
    SBC.B #$05
    LDY.W SpriteMisc157C,X
    BEQ +
    CLC
    ADC.B #$0A
  + LDY.W SpriteMisc1602,X
    CPY.B #$0A
    BNE +
    CLC
    ADC.B #$14
  + STA.B _2
    JSR IsSprOffScreen
    BNE Return01F0A0
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    STA.B _0
    LDA.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    PHX
    LDX.B _2
    LDA.B _0
    CLC
    ADC.L DATA_03C176,X
    STA.W OAMTileXPos+$100
    LDA.B _1
    CLC
    ADC.L DATA_03C19E,X
    STA.W OAMTileYPos+$100
    LDA.B #$3F
    STA.W OAMTileNo+$100
    PLX
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W OAMTileAttr+$100,Y
    ORA.B #$01
    STA.W OAMTileAttr+$100
    LDA.B #$00
    STA.W OAMTileSize+$40
Return01F0A0:
    RTS

Return01F0A1:
    RTS

CODE_01F0A2:
    LDA.B SpriteTableC2,X
    CMP.B #$01
    BNE +
    JSL CODE_02D0D4
  + LDA.W YoshiHasWingsGfx                    ; \ Branch if $1410 == #$01
    CMP.B #$01                                ; | This never happens
    BEQ Return01F0A1                          ; / (fireball on Yoshi ability)
    LDA.W YoshiTongueTimer
    CMP.B #$10
    BNE +
    LDA.W YoshiStartEatTimer
    BNE +
    LDA.B #$06
    STA.W YoshiStartEatTimer
  + LDA.W SpriteMisc1594,X
    JSL ExecutePtr

    dw CODE_01F14B
    dw CODE_01F314
    dw CODE_01F332
    dw CODE_01F12E

CODE_01F0D3:
    LDA.B #!SFX_GULP                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    JSL CODE_05B34A
    LDA.W EatenBerryType
    BEQ Return01F12D
    STZ.W EatenBerryType
    CMP.B #$01
    BNE CODE_01F0F9
    INC.W RedBerriesEaten
    LDA.W RedBerriesEaten
    CMP.B #$0A
    BNE Return01F12D
    STZ.W RedBerriesEaten
    LDA.B #$74
    BRA CODE_01F125

CODE_01F0F9:
    CMP.B #$03
    BNE CODE_01F116
    LDA.B #!SFX_CORRECT                       ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.W InGameTimerTens
    CLC
    ADC.B #$02
    CMP.B #$0A
    BCC +
    SBC.B #$0A
    INC.W InGameTimerHundreds
  + STA.W InGameTimerTens
    BRA Return01F12D

CODE_01F116:
    INC.W PinkBerriesEaten
    LDA.W PinkBerriesEaten
    CMP.B #$02
    BNE Return01F12D
    STZ.W PinkBerriesEaten
    LDA.B #$6A
CODE_01F125:
    STA.W YoshiEggSpriteHatch
    LDY.B #$20
    STY.W EggLaidTimer
Return01F12D:
    RTS

CODE_01F12E:
    LDA.W SpriteMisc1558,X
    BNE +
    STZ.W SpriteMisc1594,X
  + RTS


YoshiShellAbility:
    db $00,$00,$01,$02,$00,$00,$01,$02
    db $01,$01,$01,$03,$02,$02

YoshiAbilityIndex:
    db $03,$02,$02,$03,$01,$00

CODE_01F14B:
    LDA.W YoshiHeavenFlag
    BEQ +
    LDA.B #$02                                ; \ Set Yoshi wing ability
    STA.W YoshiHasWingsEvt                    ; /
  + LDA.W YoshiSwallowTimer
    BEQ CODE_01F1A2
    LDY.W SpriteMisc160E,X
    LDA.W SpriteNumber,Y
    CMP.B #$80
    BNE +
    INC.W YoshiHasKey
  + CMP.B #$0D
    BCS CODE_01F1A2
    PHY
    LDA.W SpriteMisc187B,Y
    CMP.B #$01
    LDA.B #$03
    BCS +
    LDA.W SpriteOBJAttribute,X                ; \ Set yoshi stomp/wing ability,
    LSR A                                     ; | based on palette of sprite and Yoshi
    AND.B #$07                                ; |
    TAY                                       ; |
    LDA.W YoshiAbilityIndex,Y                 ; |
    ASL A                                     ; |
    ASL A                                     ; |
    STA.B _0                                  ; |
    PLY                                       ; |
    PHY                                       ; |
    LDA.W SpriteOBJAttribute,Y                ; |
    LSR A                                     ; |
    AND.B #$07                                ; |
    TAY                                       ; |
    LDA.W YoshiAbilityIndex,Y                 ; |
    ORA.B _0                                  ; |
    TAY                                       ; |
    LDA.W YoshiShellAbility,Y                 ; /
  + PHA                                       ; \ Set yoshi wing ability
    AND.B #$02                                ; | ($141E = #$02)
    STA.W YoshiHasWingsEvt                    ; /
    PLA                                       ; \ If Yoshi gets stomp ability,
    AND.B #$01                                ; | $18E7 = #$01
    STA.W YoshiCanStomp                       ; /
    PLY
CODE_01F1A2:
    LDA.B EffFrame
    AND.B #$03
    BNE +
    LDA.W YoshiSwallowTimer
    BEQ +
    DEC.W YoshiSwallowTimer
    BNE +
    LDY.W SpriteMisc160E,X
    LDA.B #$00
    STA.W SpriteStatus,Y
    DEC A
    STA.W SpriteMisc160E,X
    LDA.B #$1B
    STA.W SpriteMisc1564,X
    JMP CODE_01F0D3

  + LDA.W YoshiStartEatTimer
    BEQ CODE_01F1DF
    DEC.W YoshiStartEatTimer
    BNE Return01F1DE
    INC.W SpriteMisc1594,X
    STZ.W SpriteMisc151C,X
    LDA.B #$FF
    STA.W SpriteMisc160E,X
    STZ.W SpriteMisc1564,X
Return01F1DE:
    RTS

CODE_01F1DF:
    LDA.B SpriteTableC2,X
    CMP.B #$01
    BNE Return01F1DE
    BIT.B byetudlrFrame
    BVC Return01F1DE
    LDA.W YoshiSwallowTimer
    BNE +
    JMP CODE_01F309

  + STZ.W YoshiSwallowTimer
    LDY.W SpriteMisc160E,X
    PHY
    PHY
    LDY.W SpriteMisc157C,X
    LDA.B SpriteXPosLow,X
    CLC
    ADC.W DATA_01F305,Y
    PLY
    STA.W SpriteXPosLow,Y
    LDY.W SpriteMisc157C,X
    LDA.W SpriteXPosHigh,X
    ADC.W DATA_01F307,Y
    PLY
    STA.W SpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W SpriteYPosHigh,Y
    LDA.B #$00
    STA.W SpriteTableC2,Y
    STA.W SpriteOnYoshiTongue,Y
    STA.W SpriteMisc1626,Y
    LDA.W PlayerDuckingOnYoshi
    CMP.B #$01
    LDA.B #$0A
    BCC +
    LDA.B #$09                                ; \ Sprite status = Carryable
  + STA.W SpriteStatus,Y                      ; /
    PHX
    LDA.W SpriteMisc157C,X
    STA.W SpriteMisc157C,Y
    TAX
    BCC +
    INX
    INX
  + LDA.W DATA_01F301,X
    STA.W SpriteXSpeed,Y
    LDA.B #$00
    STA.W SpriteYSpeed,Y
    PLX
    LDA.B #$10
    STA.W SpriteMisc1558,X
    LDA.B #$03
    STA.W SpriteMisc1594,X
    LDA.B #$FF
    STA.W SpriteMisc160E,X
    LDA.W SpriteNumber,Y
    CMP.B #$0D
    BCS CODE_01F2DF
    LDA.W SpriteMisc187B,Y
    BNE CODE_01F27C
    LDA.W SpriteOBJAttribute,Y
    AND.B #$0E
    CMP.B #$08
    BEQ CODE_01F27C
    LDA.W SpriteOBJAttribute,X
    AND.B #$0E
    CMP.B #$08
    BNE CODE_01F2DF
CODE_01F27C:
    PHX
    TYX
    STZ.W SpriteStatus,X
    LDA.B #$02
    STA.B _0
    JSR CODE_01F295
    JSR CODE_01F295
    JSR CODE_01F295
    PLX
    LDA.B #!SFX_FIRESPIT                      ; \ Play sound effect
    STA.W SPCIO3                              ; /
    RTS

CODE_01F295:
    JSR CODE_018EEF
    LDA.B #$11                                ; \ Extended sprite = Yoshi fireball
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B SpriteXPosLow,X
    STA.W ExtSpriteXPosLow,Y
    LDA.W SpriteXPosHigh,X
    STA.W ExtSpriteXPosHigh,Y
    LDA.B SpriteYPosLow,X
    STA.W ExtSpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    STA.W ExtSpriteYPosHigh,Y
    LDA.B #$00
    STA.W ExtSpritePriority,Y
    PHX
    LDA.W SpriteMisc157C,X
    LSR A
    LDX.B _0
    LDA.W DATA_01F2D9,X
    BCC +
    EOR.B #$FF
    INC A
  + STA.W ExtSpriteXSpeed,Y
    LDA.W DATA_01F2DC,X
    STA.W ExtSpriteYSpeed,Y
    LDA.B #$A0
    STA.W ExtSpriteMisc176F,Y
    PLX
    DEC.B _0
    RTS


DATA_01F2D9:
    db $28,$24,$24

DATA_01F2DC:
    db $00,$F8,$08

CODE_01F2DF:
    LDA.B #!SFX_SPIT                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.W SpriteTweakerE,Y                    ; \ Return if sprite doesn't spawn a new one
    AND.B #$40                                ; |
    BEQ +                                     ; /
    PHX                                       ; \ Load sprite to spawn and store it
    LDX.W SpriteNumber,Y                      ; |
    LDA.L SpriteToSpawn,X                     ; |
    PLX                                       ; |
    STA.W SpriteNumber,Y                      ; /
    PHX                                       ; \ Load Tweaker bytes
    TYX                                       ; |
    JSL LoadSpriteTables                      ; |
    PLX                                       ; /
  + RTS


    db $20,$E0

DATA_01F301:
    db $30,$D0,$10,$F0

DATA_01F305:
    db $10,$F0

DATA_01F307:
    db $00,$FF

CODE_01F309:
    LDA.B #$12
    STA.W YoshiTongueTimer
    LDA.B #!SFX_YOSHITONGUE                   ; \ Play sound effect
    STA.W SPCIO3                              ; /
    RTS

CODE_01F314:
    LDA.W SpriteMisc151C,X
    CLC
    ADC.B #$03
    STA.W SpriteMisc151C,X
    CMP.B #$20
    BCS +
CODE_01F321:
    JSR CODE_01F3FE
    JSR CODE_01F4B2
    RTS

  + LDA.B #$08
    STA.W SpriteMisc1558,X
    INC.W SpriteMisc1594,X
    BRA CODE_01F321

CODE_01F332:
    LDA.W SpriteMisc1558,X
    BNE CODE_01F321
    LDA.W SpriteMisc151C,X
    SEC
    SBC.B #$04
    BMI CODE_01F344
    STA.W SpriteMisc151C,X
    BRA CODE_01F321

CODE_01F344:
    STZ.W SpriteMisc151C,X
    STZ.W SpriteMisc1594,X
    LDY.W SpriteMisc160E,X
    BMI CODE_01F370
    LDA.W SpriteTweakerE,Y
    AND.B #$02
    BEQ CODE_01F373
    LDA.B #$07                                ; \ Sprite status = Unused (todo: look here)
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$FF
    STA.W YoshiSwallowTimer
    LDA.W SpriteNumber,Y                      ; \ Branch if not a Koopa
    CMP.B #$0D                                ; | (sprite number >= #$0D)
    BCS CODE_01F370                           ; /
    PHX
    TAX
    LDA.W SpriteToSpawn,X
    STA.W SpriteNumber,Y
    PLX
CODE_01F370:
    JMP CODE_01F3FA

CODE_01F373:
    LDA.B #$00
    STA.W SpriteStatus,Y
    LDA.B #$1B
    STA.W SpriteMisc1564,X
    LDA.B #$FF
    STA.W SpriteMisc160E,X
    STY.B _0
    LDA.W SpriteNumber,Y
    CMP.B #$9D
    BNE +
    LDA.W SpriteTableC2,Y
    CMP.B #$03
    BNE +
    LDA.B #$74                                ; \ Sprite = Mushroom
    STA.W SpriteNumber,Y                      ; /
    LDA.W SpriteTweakerD,Y                    ; \ Set "Gives powerup when eaten" bit
    ORA.B #$40                                ; |
    STA.W SpriteTweakerD,Y                    ; /
  + LDA.W SpriteNumber,Y                      ; \ Branch if not Changing Item
    CMP.B #$81                                ; |
    BNE +                                     ; /
    LDA.W SpriteMisc187B,Y
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    LSR A
    AND.B #$03
    TAY
    LDA.W ChangingItemSprite,Y
    LDY.B _0
    STA.W SpriteNumber,Y
  + PHA
    LDY.B _0
    LDA.W SpriteTweakerD,Y
    ASL A
    ASL A
    PLA
    BCC +
    PHX
    TYX
    STZ.B SpriteTableC2,X
    JSR CODE_01C4BF
    PLX
    LDY.W PlayerDuckingOnYoshi
    LDA.W DATA_01F3D9,Y
    STA.W SpriteMisc1602,X
    JMP CODE_01F321


DATA_01F3D9:
    db $00,$04

  + CMP.B #$7E
    BNE CODE_01F3F7
    LDA.W SpriteTableC2,Y
    BEQ CODE_01F3F7
    CMP.B #$02
    BNE +
    LDA.B #$08
    STA.B PlayerAnimation
    LDA.B #!SFX_VINEBLOCK                     ; \ Play sound effect
    STA.W SPCIO3                              ; /
  + JSR CODE_01F6CD
    JMP CODE_01F321

CODE_01F3F7:
    JSR CODE_01F0D3
CODE_01F3FA:
    JMP CODE_01F321

Return01F3FD:
    RTS

CODE_01F3FE:
    LDA.W SpriteOffscreenX,X                  ; \ Branch if sprite off screen...
    ORA.W SpriteOffscreenVert,X               ; |
    ORA.W YoshiInPipeSetting                  ; | ...or going down pipe
    BNE Return01F3FD                          ; /
    LDY.W SpriteMisc1602,X
    LDA.W DATA_01F61A,Y
    STA.W TileGenerateTrackA
    CLC
    ADC.B SpriteYPosLow,X
    SEC
    SBC.B Layer1YPos
    STA.B _1
    LDA.W SpriteMisc157C,X
    BNE +
    TYA
    CLC
    ADC.B #$08
    TAY
  + LDA.W DATA_01F60A,Y
    STA.B _D
    LDA.B SpriteXPosLow,X
    SEC
    SBC.B Layer1XPos
    CLC
    ADC.B _D
    STA.B _0
    LDA.W SpriteMisc157C,X
    BNE CODE_01F43C
    BCS Return01F3FD
    BRA CODE_01F43E

CODE_01F43C:
    BCC Return01F3FD
CODE_01F43E:
    LDA.W SpriteMisc151C,X
    STA.W HW_WRDIV+1
    STZ.W HW_WRDIV
    LDA.B #$04
    STA.W HW_WRDIV+2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDA.W SpriteMisc157C,X
    STA.B _7
    LSR A
    LDA.W HW_RDDIV+1
    BCC +
    EOR.B #$FF
    INC A
  + STA.B _5
    LDA.B #$04
    STA.B _6
    LDY.B #$0C
CODE_01F46A:
    LDA.B _0
    STA.W OAMTileXPos,Y
    CLC
    ADC.B _5
    STA.B _0
    LDA.B _5
    BPL CODE_01F47C
    BCC Return01F4B1
    BRA CODE_01F47E

CODE_01F47C:
    BCS Return01F4B1
CODE_01F47E:
    LDA.B _1
    STA.W OAMTileYPos,Y
    LDA.B _6
    CMP.B #$01
    LDA.B #$76
    BCS +
    LDA.B #$66
  + STA.W OAMTileNo,Y
    LDA.B _7
    LSR A
    LDA.B #$09
    BCS +
    ORA.B #!OBJ_XFlip
  + ORA.B SpriteProperties
    STA.W OAMTileAttr,Y
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$00
    STA.W OAMTileSize,Y
    PLY
    INY
    INY
    INY
    INY
    DEC.B _6
    BPL CODE_01F46A
Return01F4B1:
    RTS

CODE_01F4B2:
    LDA.W SpriteMisc160E,X
    BMI CODE_01F524
    LDY.B #$00
    LDA.B _D
    BMI CODE_01F4C3
    CLC
    ADC.W SpriteMisc151C,X
    BRA +

CODE_01F4C3:
    LDA.W SpriteMisc151C,X
    EOR.B #$FF
    INC A
    CLC
    ADC.B _D
  + SEC
    SBC.B #$04
    BPL +
    DEY
  + PHY
    CLC
    ADC.B SpriteXPosLow,X
    LDY.W SpriteMisc160E,X
    STA.W SpriteXPosLow,Y
    PLY
    TYA
    ADC.W SpriteXPosHigh,X
    LDY.W SpriteMisc160E,X
    STA.W SpriteXPosHigh,Y
    LDA.B #$FC
    STA.B _0
    LDA.W SpriteTweakerB,Y
    AND.B #$40
    BNE +
    LDA.W SpriteTweakerF,Y                    ; \ Branch if "Death frame 2 tiles high"
    AND.B #$20                                ; | is NOT set
    BEQ +                                     ; /
    LDA.B #$F8
    STA.B _0
  + STZ.B _1
    LDA.B _0
    CLC
    ADC.W TileGenerateTrackA
    BPL +
    DEC.B _1
  + CLC
    ADC.B SpriteYPosLow,X
    STA.W SpriteYPosLow,Y
    LDA.W SpriteYPosHigh,X
    ADC.B _1
    STA.W SpriteYPosHigh,Y
    LDA.B #$00
    STA.W SpriteYSpeed,Y
    STA.W SpriteXSpeed,Y
    INC A
    STA.W SpriteOnYoshiTongue,Y
    RTS

CODE_01F524:
    PHY
    LDY.B #$00
    LDA.B _D
    BMI CODE_01F531
    CLC
    ADC.W SpriteMisc151C,X
    BRA +

CODE_01F531:
    LDA.W SpriteMisc151C,X
    EOR.B #$FF
    INC A
    CLC
    ADC.B _D
  + CLC
    ADC.B #$00
    BPL +
    DEY
  + CLC
    ADC.B SpriteXPosLow,X
    STA.B _0
    TYA
    ADC.W SpriteXPosHigh,X
    STA.B _8
    PLY
    LDA.W TileGenerateTrackA
    CLC
    ADC.B #$02
    CLC
    ADC.B SpriteYPosLow,X
    STA.B _1
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.B _9
    LDA.B #$08
    STA.B _2
    LDA.B #$04
    STA.B _3
    LDY.B #$0B                                ; Loop over spites:
CODE_01F568:
    STY.W SpriteInterIndex
    CPY.W CurSpriteProcess
    BEQ +
    LDA.W SpriteMisc160E,X
    BPL +
    LDA.W SpriteStatus,Y                      ; \ Skip sprite if sprite status < 8
    CMP.B #$08                                ; |
    BCC +                                     ; /
    LDA.W SpriteBehindScene,Y                 ; \ Skip sprite if behind scenery
    BNE +                                     ; /
    PHY
    JSR TryEatSprite
    PLY
  + DEY
    BPL CODE_01F568
    JSL CODE_02B9FA
    RTS

TryEatSprite:
    PHX
    TYX
    JSL GetSpriteClippingA
    PLX
    JSL CheckForContact
    BCC Return01F609
    LDA.W SpriteTweakerE,Y                    ; \ If sprite inedible
    LSR A                                     ; |
    BCC +                                     ; |
    LDA.B #!SFX_BONK                          ; | Play sound effect
    STA.W SPCIO0                              ; |
    RTS                                       ; / Return

  + LDA.W SpriteNumber,Y                      ; \ Branch if sprite being eaten not Pokey
    CMP.B #$70                                ; |
    BNE CODE_01F5FB                           ; /
    STY.W TileGenerateTrackA                  ; $185E = Index of sprite being eaten
    LDA.B _1
    SEC
    SBC.W SpriteYPosLow,Y
    CLC
    ADC.B #$00
    PHX
    TYX                                       ; X = Index of sprite being eaten
    JSL RemovePokeySegment
    PLX
    JSL FindFreeSprSlot                       ; \ Return if no free slots
    BMI Return01F609                          ; /
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$70                                ; \ Sprite = Pokey
    STA.W SpriteNumber,Y                      ; /
    LDA.B _0
    STA.W SpriteXPosLow,Y
    LDA.B _8
    STA.W SpriteXPosHigh,Y
    LDA.B _1
    STA.W SpriteYPosLow,Y
    LDA.B _9
    STA.W SpriteYPosHigh,Y
    PHX
    TYX                                       ; X = Index of new sprite
    JSL InitSpriteTables                      ; Reset sprite tables
    LDX.W TileGenerateTrackA                  ; X = Index of sprite being eaten
    LDA.B SpriteTableC2,X
    AND.B _D
    STA.W SpriteTableC2,Y                     ; y = index of new sptr here??
    LDA.B #$01
    STA.W SpriteMisc1534,Y
    PLX
CODE_01F5FB:
    TYA                                       ; \ $160E,x = Index of sprite being eaten
    STA.W SpriteMisc160E,X                    ; /
    LDA.B #$02
    STA.W SpriteMisc1594,X
    LDA.B #$0A
    STA.W SpriteMisc1558,X
Return01F609:
    RTS


DATA_01F60A:
    db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F0
    db $13,$13,$13,$13,$13,$13,$13,$18
DATA_01F61A:
    db $08,$08,$08,$08,$08,$08,$08,$13

CODE_01F622:
    LDA.W SpriteMisc163E,X
    ORA.B SpriteLock
    BNE Return01F667
    LDY.B #$0B
CODE_01F62B:
    STY.W SpriteInterIndex
    TYA
    EOR.B TrueFrame
    AND.B #$01
    BNE +
    TYA
    CMP.W SpriteMisc160E,X
    BEQ +
    CPY.W CurSpriteProcess
    BEQ +
    LDA.W SpriteStatus,Y
    CMP.B #$08
    BCC +
    LDA.W SpriteNumber,Y
    LDA.W SpriteStatus,Y
    CMP.B #$09
    BEQ +
    LDA.W SpriteTweakerD,Y
    AND.B #$02
    ORA.W SpriteOnYoshiTongue,Y
    ORA.W SpriteBehindScene,Y
    BNE +
    JSR CODE_01F668
  + LDY.W SpriteInterIndex
    DEY
    BPL CODE_01F62B
Return01F667:
    RTS

CODE_01F668:
    PHX
    TYX
    JSL GetSpriteClippingB
    PLX
    JSL GetSpriteClippingA
    JSL CheckForContact
    BCC Return01F667
    LDA.W SpriteNumber,Y
    CMP.B #$9D
    BEQ Return01F667
    CMP.B #$15
    BEQ CODE_01F69E
    CMP.B #$16
    BEQ CODE_01F69E
    CMP.B #$04
    BCS CODE_01F6A3
    CMP.B #$02
    BEQ CODE_01F6A3
    LDA.W SpriteMisc163E,Y
    BPL CODE_01F6A3
  - PHY
    PHX
    TYX
    JSR CODE_01B12A
    PLX
    PLY
    RTS

CODE_01F69E:
    LDA.W SpriteInLiquid,Y
    BEQ -
CODE_01F6A3:
    LDA.W SpriteNumber,Y
    CMP.B #$BF
    BNE CODE_01F6B4
    LDA.B PlayerYPosNext
    SEC
    SBC.W SpriteYPosLow,Y
    CMP.B #$E8
    BMI Return01F6DC
CODE_01F6B4:
    LDA.W SpriteNumber,Y
    CMP.B #$7E
    BNE CODE_01F6DD
    LDA.W SpriteTableC2,Y
    BEQ Return01F6DC
    CMP.B #$02
    BNE CODE_01F6CD
    LDA.B #$08
    STA.B PlayerAnimation
    LDA.B #!SFX_VINEBLOCK                     ; \ Play sound effect
    STA.W SPCIO3                              ; /
CODE_01F6CD:
    LDA.B #$40
    STA.W YoshiWingGrabTimer
    LDA.B #$02                                ; \ Set Yoshi wing ability
    STA.W YoshiHasWingsEvt                    ; /
    LDA.B #$00
    STA.W SpriteStatus,Y
Return01F6DC:
    RTS

CODE_01F6DD:
    CMP.B #$4E
    BEQ CODE_01F6E5
    CMP.B #$4D
    BNE CODE_01F6EC
CODE_01F6E5:
    LDA.W SpriteTableC2,Y
    CMP.B #$02
    BCC Return01F6DC
CODE_01F6EC:
    LDA.B _5
    CLC
    ADC.B #$0D
    CMP.B _1
    BMI Return01F74B
    LDA.W SpriteStatus,Y
    CMP.B #$0A
    BNE CODE_01F70E
    PHX
    TYX
    JSR SubHorizPos
    STY.B _0
    LDA.B SpriteXSpeed,X
    PLX
    ASL A
    ROL A
    AND.B #$01
    CMP.B _0
    BNE Return01F74B
CODE_01F70E:
    LDA.W InvinsibilityTimer                  ; \ Branch if Mario has star
    BNE Return01F74B                          ; /
    LDA.B #$10
    STA.W SpriteMisc163E,X
    LDA.B #!SFX_YOSHIDRUMOFF                  ; \ Play sound effect
    STA.W SPCIO1                              ; /
    LDA.B #!SFX_YOSHIHURT                     ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$02
    STA.B SpriteTableC2,X
    STZ.W PlayerRidingYoshi
    LDA.B #$C0
    STA.B PlayerYSpeed+1
    STZ.B PlayerXSpeed+1
    JSR SubHorizPos
    LDA.W DATA_01EBBE,Y
    STA.B SpriteXSpeed,X
    STZ.W SpriteMisc1594,X
    STZ.W SpriteMisc151C,X
    STZ.W YoshiStartEatTimer
    STZ.W CarryYoshiThruLvls
    LDA.B #$30                                ; \ Mario invincible timer = #$30
    STA.W IFrameTimer                         ; /
    JSR CODE_01EDCC
Return01F74B:
    RTS

CODE_01F74C:
    LDA.B #$08                                ; \ Sprite status = Normal
    STA.W SpriteStatus,X                      ; /
CODE_01F751:
    LDA.B #$20
    STA.W SpriteMisc1540,X
    LDA.B #!SFX_EGGHATCH                      ; \ Play sound effect
    STA.W SPCIO3                              ; /
    RTL


DATA_01F75C:
    db $00,$01,$01,$01

YoshiEggTiles:
    db $62,$02,$02,$00

YoshiEgg:
    LDA.W SpriteMisc187B,X
    BEQ CODE_01F799
    JSR IsSprOffScreen
    BNE CODE_01F78D
    JSR SubHorizPos
    LDA.B _F
    CLC
    ADC.B #$20
    CMP.B #$40
    BCS CODE_01F78D
    STZ.W SpriteMisc187B,X
    JSL CODE_01F751
    LDA.B #$2D
    LDY.W YoshiIsLoose
    BEQ +
    LDA.B #$78
  + STA.W SpriteMisc151C,X
CODE_01F78D:
    JSR SubSprGfx2Entry1
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B #$00
    STA.W OAMTileNo+$100,Y
    RTS

CODE_01F799:
    LDA.W SpriteMisc1540,X
    BEQ +
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W YoshiEggTiles,Y
    PHA
    LDA.W DATA_01F75C,Y
    PHA
    JSR SubSprGfx2Entry1
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PLA
    STA.B _0
    LDA.W OAMTileAttr+$100,Y
    AND.B #$FE
    ORA.B _0
    STA.W OAMTileAttr+$100,Y
    PLA
    STA.W OAMTileNo+$100,Y
    RTS

  + JSR CODE_01F7C8
    JMP CODE_01F83D

CODE_01F7C8:
    JSR IsSprOffScreen
    BNE Return01F82C
    LDA.B SpriteXPosLow,X
    STA.B _0
    LDA.B SpriteYPosLow,X
    STA.B _2
    LDA.W SpriteYPosHigh,X
    STA.B _3
    PHX
    LDY.B #$03
    LDX.B #$0B
CODE_01F7DF:
    LDA.W MinExtSpriteNumber,X
    BEQ CODE_01F7F4
CODE_01F7E4:
    DEX
    BPL CODE_01F7DF
    DEC.W MinExtSpriteSlotIdx
    BPL +
    LDA.B #$0B
    STA.W MinExtSpriteSlotIdx
  + LDX.W MinExtSpriteSlotIdx
CODE_01F7F4:
    LDA.B #$03
    STA.W MinExtSpriteNumber,X
    LDA.B _0
    CLC
    ADC.W DATA_01F831,Y
    STA.W MinExtSpriteXPosLow,X
    LDA.B _2
    CLC
    ADC.W DATA_01F82D,Y
    STA.W MinExtSpriteYPosLow,X
    LDA.B _3
    STA.W MinExtSpriteYPosHigh,X
    LDA.W DATA_01F835,Y
    STA.W MinExtSpriteYSpeed,X
    LDA.W DATA_01F839,Y
    STA.W MinExtSpriteXSpeed,X
    TYA
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    ORA.B #$28
    STA.W MinExtSpriteTimer,X
    DEY
    BPL CODE_01F7E4
    PLX
Return01F82C:
    RTS


DATA_01F82D:
    db $00,$00,$08,$08

DATA_01F831:
    db $00,$08,$00,$08

DATA_01F835:
    db $E8,$E8,$F4,$F4

DATA_01F839:
    db $FA,$06,$FD,$03

CODE_01F83D:
    LDA.W SpriteMisc151C,X
    STA.B SpriteNumber,X
    CMP.B #$35
    BEQ CODE_01F86C
    CMP.B #$2D
    BNE +
    LDA.B #$09                                ; \ Sprite status = Carryable
    STA.W SpriteStatus,X                      ; /
    LDA.W SpriteOBJAttribute,X
    AND.B #$0E
    PHA
    JSL InitSpriteTables
    PLA
    STA.B _0
    LDA.W SpriteOBJAttribute,X
    AND.B #$F1
    ORA.B _0
    STA.W SpriteOBJAttribute,X
    RTS

  + JSL InitSpriteTables
    RTS

CODE_01F86C:
    JSL InitSpriteTables
    JMP CODE_01A2B5


    db $08,$F8

UnusedInit:
    JSR FaceMario
    STA.W SpriteMisc1534,X
Return01F87B:
    RTS

InitEerie:
    JSR SubHorizPos
    LDA.W EerieSpeedX,Y
    STA.B SpriteXSpeed,X
InitBigBoo:
    JSL GetRand
    STA.W SpriteMisc1570,X
    RTS


EerieSpeedX:
    db $10,$F0

EerieSpeedY:
    db $18,$E8

Eerie:
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE CODE_01F8C9
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE CODE_01F8C9                           ; /
    JSR SubSprXPosNoGrvty
    LDA.B SpriteNumber,X
    CMP.B #$39
    BNE CODE_01F8C0
    LDA.B SpriteTableC2,X
    AND.B #$01
    TAY
    LDA.B SpriteYSpeed,X
    CLC
    ADC.W DATA_01EBB4,Y
    STA.B SpriteYSpeed,X
    CMP.W EerieSpeedY,Y
    BNE +
    INC.B SpriteTableC2,X
  + JSR SubSprYPosNoGrvty
    JSR SubOffscreen3Bnk1
    BRA +

CODE_01F8C0:
    JSR SubOffscreen0Bnk1
  + JSR MarioSprInteractRt
    JSR SetAnimationFrame
CODE_01F8C9:
    JSR UpdateDirection
    JMP SubSprGfx2Entry1


DATA_01F8CF:
    db $08,$F8

DATA_01F8D1:
    db $01,$02,$02,$01

BigBoo:
    JSR SubOffscreen1Bnk1
    LDA.B #$20
    BRA +

Boo_BooBlock:
    JSR SubOffscreen0Bnk1
    LDA.B #$10
  + STA.W TileGenerateTrackB
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE CODE_01F8EF
    LDA.B SpriteLock
    BEQ +
CODE_01F8EF:
    JMP CODE_01F9CE

  + JSR SubHorizPos
    LDA.W SpriteMisc1540,X
    BNE CODE_01F914
    LDA.B #$20
    STA.W SpriteMisc1540,X
    LDA.B SpriteTableC2,X
    BEQ CODE_01F90C
    LDA.B _F
    CLC
    ADC.B #$0A
    CMP.B #$14
    BCC CODE_01F92F
CODE_01F90C:
    STZ.B SpriteTableC2,X
    CPY.B PlayerDirection
    BNE CODE_01F914
    INC.B SpriteTableC2,X
CODE_01F914:
    LDA.B _F
    CLC
    ADC.B #$0A
    CMP.B #$14
    BCC CODE_01F92F
    LDA.W SpriteMisc15AC,X
    BNE CODE_01F971
    TYA
    CMP.W SpriteMisc157C,X
    BEQ CODE_01F92F
    LDA.B #$1F                                ; \ Set turning timer
    STA.W SpriteMisc15AC,X                    ; /
    BRA CODE_01F971

CODE_01F92F:
    STZ.W SpriteMisc1602,X
    LDA.B SpriteTableC2,X
    BEQ CODE_01F989
    LDA.B #$03
    STA.W SpriteMisc1602,X
    LDY.B SpriteNumber,X
    CPY.B #$28
    BEQ +
    LDA.B #$00
    CPY.B #$AF
    BEQ +
    INC A
  + AND.B TrueFrame
    BNE CODE_01F96F
    INC.W SpriteMisc1570,X
    LDA.W SpriteMisc1570,X
    BNE +
    LDA.B #$20
    STA.W SpriteMisc1558,X
  + LDA.B SpriteXSpeed,X
    BEQ CODE_01F962
    BPL +
    INC A
    INC A
  + DEC A
CODE_01F962:
    STA.B SpriteXSpeed,X
    LDA.B SpriteYSpeed,X
    BEQ CODE_01F96D
    BPL +
    INC A
    INC A
  + DEC A
CODE_01F96D:
    STA.B SpriteYSpeed,X
CODE_01F96F:
    BRA CODE_01F9C8

CODE_01F971:
    CMP.B #$10
    BNE +
    PHA
    LDA.W SpriteMisc157C,X
    EOR.B #$01
    STA.W SpriteMisc157C,X
    PLA
  + LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_01F8D1,Y
    STA.W SpriteMisc1602,X
CODE_01F989:
    STZ.W SpriteMisc1570,X
    LDA.B TrueFrame
    AND.B #$07
    BNE CODE_01F9C8
    JSR SubHorizPos
    LDA.B SpriteXSpeed,X
    CMP.W DATA_01F8CF,Y
    BEQ +
    CLC
    ADC.W DATA_01EBB4,Y
    STA.B SpriteXSpeed,X
  + LDA.B PlayerYPosNow
    PHA
    SEC
    SBC.W TileGenerateTrackB
    STA.B PlayerYPosNow
    LDA.B PlayerYPosNow+1
    PHA
    SBC.B #$00
    STA.B PlayerYPosNow+1
    JSR CODE_01AD42
    PLA
    STA.B PlayerYPosNow+1
    PLA
    STA.B PlayerYPosNow
    LDA.B SpriteYSpeed,X
    CMP.W DATA_01F8CF,Y
    BEQ CODE_01F9C8
    CLC
    ADC.W DATA_01EBB4,Y
    STA.B SpriteYSpeed,X
CODE_01F9C8:
    JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
CODE_01F9CE:
    LDA.B SpriteNumber,X
    CMP.B #$AF
    BNE CODE_01FA3D
    LDA.B SpriteXSpeed,X
    BPL +
    EOR.B #$FF
    INC A
  + LDY.B #$00
    CMP.B #$08
    BCS CODE_01FA09
    PHA
    LDA.W SpriteTweakerB,X
    PHA
    LDA.W SpriteTweakerD,X
    PHA
    ORA.B #$80
    STA.W SpriteTweakerD,X
    LDA.B #$0C
    STA.W SpriteTweakerB,X
    JSR CODE_01B457
    PLA
    STA.W SpriteTweakerD,X
    PLA
    STA.W SpriteTweakerB,X
    PLA
    LDY.B #$01
    CMP.B #$04
    BCS +
    INY
    BRA +

CODE_01FA09:
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE +
    PHY
    JSR MarioSprInteractRt
    PLY
  + TYA
    STA.W SpriteMisc1602,X
    JSR SubSprGfx2Entry1
    LDA.W SpriteMisc1602,X
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    PHX
    TAX
    LDA.W BooBlockTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W OAMTileAttr+$100,Y
    AND.B #$F1
    ORA.W BooBlockGfxProp,X
    STA.W OAMTileAttr+$100,Y
    PLX
    RTS


BooBlockTiles:
    db $8C,$C8,$CA

BooBlockGfxProp:
    db $0E,$02,$02

CODE_01FA3D:
    LDA.W SpriteStatus,X
    CMP.B #$08
    BNE +
    JSR MarioSprInteractRt
  + JSL CODE_038398
    RTS


DATA_01FA4C:
    db $40,$00

IggyBallTiles:
    db $4A,$4C,$4A,$4C

DATA_01FA52:
    db $35,$35,$F5,$F5

DATA_01FA56:
    db $10,$F0

IggysBall:
    JSR SubSprGfx2Entry1
    LDY.W SpriteMisc157C,X
    LDA.W DATA_01FA4C,Y
    STA.B _0
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.B EffFrame
    LSR A
    LSR A
    AND.B #$03
    PHX
    TAX
    LDA.W IggyBallTiles,X
    STA.W OAMTileNo+$100,Y
    LDA.W DATA_01FA52,X
    EOR.B _0
    STA.W OAMTileAttr+$100,Y
    PLX
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE Return01FAB3                          ; /
    LDY.W SpriteMisc157C,X
    LDA.W DATA_01FA56,Y
    STA.B SpriteXSpeed,X
    JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +
    CLC
    ADC.B #$04
    STA.B SpriteYSpeed,X
  + JSR CODE_01FF98
    BCC +
    LDA.B #$F0
    STA.B SpriteYSpeed,X
  + JSR MarioSprInteractRt
    LDA.B SpriteYPosLow,X
    CMP.B #$44
    BCC Return01FAB3
    CMP.B #$50
    BCS Return01FAB3
    JSR CODE_019ACB
Return01FAB3:
    RTS


    db $FF,$01,$00,$80,$60,$A0,$40,$D0
    db $D8,$C0,$C8,$0C,$F4

KoopaKid:
    LDA.B SpriteTableC2,X
    JSL ExecutePtr                            ; 00 - Morton

    dw WallKoopaKids                          ; 02 - Ludwig
    dw WallKoopaKids                          ; 03 - Iggy
    dw WallKoopaKids                          ; 04 - Larry
    dw PlatformKoopaKids                      ; 05 - Lemmy
    dw PlatformKoopaKids                      ; 06 - Wendy
    dw PipeKoopaKids
    dw PipeKoopaKids

    db $00,$FC,$F8,$F8,$F8,$F8,$F8,$F8
DATA_01FADD:
    db $F8,$F8,$F8,$F4,$F0,$F0,$EC,$EC
DATA_01FAE5:
    db $00,$01,$02,$00,$01,$02,$00,$01
    db $02,$00,$01,$02,$00,$01,$02,$01

PlatformKoopaKids:
    LDA.B SpriteLock
    ORA.W SpriteMisc154C,X
    BNE +
    JSR SubHorizPos
    STY.B _0
    LDA.B Mode7Angle
    ASL A
    ROL A
    AND.B #$01
    CMP.B _0
    BNE +
    INC.W SpriteMisc1534,X
    LDA.W SpriteMisc1534,X
    AND.B #$7F
    BNE +
    LDA.B #$7F                                ; \ Set time to go in shell
    STA.W SpriteMisc1564,X                    ; /
  + STZ.W SpriteOffscreenX,X
    LDA.W SpriteMisc163E,X
    BEQ CODE_01FB36
    DEC A
    BNE +
    INC.W CutsceneID
    LDA.B #$FF
    STA.W EndLevelTimer
    LDA.B #!BGM_BOSSCLEAR
    STA.W SPCIO2                              ; / Change music
    STZ.W SpriteStatus,X
  + RTS

CODE_01FB36:
    JSL LoadTweakerBytes
    LDA.B SpriteLock
    BEQ +
    JMP CODE_01FC08

  + LDA.W SpriteMisc160E,X
    BEQ CODE_01FB7B
    JSR SubSprXPosNoGrvty
    JSR SubSprYPosNoGrvty
    LDA.B SpriteYSpeed,X
    CMP.B #$40
    BPL +
    INC.B SpriteYSpeed,X
    INC.B SpriteYSpeed,X
  + LDA.B SpriteYPosLow,X
    CMP.B #$58
    BCC +
    CMP.B #$80
    BCS +
    LDA.B #!SFX_BOSSINLAVA                    ; \ Play sound effect
    STA.W SPCIO3                              ; /
    LDA.B #$50
    STA.W SpriteMisc163E,X
    JSL KillMostSprites                       ; Kill all sprites
  + LDA.B SpriteXPosLow,X
    STA.W IggyLarryTempXPos
    LDA.B SpriteYPosLow,X
    STA.W IggyLarryTempYPos
    JMP CODE_01FC0E

CODE_01FB7B:
    JSR SubSprXPosNoGrvty
    LDA.B TrueFrame
    AND.B #$1F
    ORA.W SpriteMisc1564,X
    BNE +
    LDA.W SpriteMisc157C,X
    PHA
    JSR FaceMario
    PLA
    CMP.W SpriteMisc157C,X
    BEQ +
    LDA.B #$10
    STA.W SpriteMisc15AC,X
  + STZ.B SpriteYSpeed,X                      ; Sprite Y Speed = 0
    STZ.B SpriteXSpeed,X                      ; Sprite X Speed = 0
    LDA.B Mode7Angle
    BPL +
    CLC
    ADC.B #$08
  + LSR A
    LSR A
    LSR A
    LSR A
    TAY
    STY.B _0
    EOR.B #$FF
    INC A
    AND.B #$0F
    STA.B _1
    LDA.W SpriteMisc154C,X
    BNE CODE_01FBD9
    LDA.B Mode7Angle+1
    BNE CODE_01FBC9
    LDA.B SpriteXPosLow,X
    CMP.B #$78
    BCC CODE_01FBC5
    LDA.B #$FF
    BRA CODE_01FBEE

CODE_01FBC5:
    LDA.B #$01
    BRA CODE_01FBEE

CODE_01FBC9:
    LDY.B _1
    LDA.B SpriteXPosLow,X
    CMP.B #$78
    BCS CODE_01FBD5
    LDA.B #$01
    BRA CODE_01FBEE

CODE_01FBD5:
    LDA.B #$FF
    BRA CODE_01FBEE

CODE_01FBD9:
    LDA.B Mode7Angle+1
    BNE CODE_01FBE7
    LDY.B _0
    LDA.W DATA_01FADD,Y
    EOR.B #$FF
    INC A
    BRA +

CODE_01FBE7:
    LDY.B _1
    LDA.W DATA_01FADD,Y
  + ASL A
    ASL A
CODE_01FBEE:
    STA.B SpriteXSpeed,X
    INC.W SpriteMisc1570,X
    LDA.B SpriteXSpeed,X
    BEQ +
    INC.W SpriteMisc1570,X
  + LDA.W SpriteMisc1570,X
    LSR A
    LSR A
    AND.B #$0F
    TAY
    LDA.W DATA_01FAE5,Y
    STA.W SpriteMisc1602,X
CODE_01FC08:
    JSR CODE_01FD50
    JSR CODE_01FC62
CODE_01FC0E:
    LDA.W SpriteMisc154C,X
    BNE CODE_01FC4E
    LDA.W SpriteMisc157C,X
    PHA
    LDY.W SpriteMisc15AC,X
    BEQ CODE_01FC2A
    CPY.B #$08
    BCC +
    EOR.B #$01
    STA.W SpriteMisc157C,X
  + LDA.B #$06
    STA.W SpriteMisc1602,X
CODE_01FC2A:
    LDA.W SpriteMisc1564,X
    BEQ +
    PHA
    LSR A
    LSR A
    LSR A
    TAY
    LDA.W DATA_01FD95,Y
    STA.W SpriteMisc1602,X
    PLA
    CMP.B #$28
    BNE +
    LDA.B SpriteLock                          ; \ Branch if sprites locked
    BNE +                                     ; /
    JSR ThrowBall                             ; Throw ball
  + JSR CODE_01FEBC
    PLA
    STA.W SpriteMisc157C,X
    RTS

CODE_01FC4E:
    CMP.B #$10
    BCC +
  - LDA.B #$03
    STA.W SpriteMisc1602,X
    JMP CODE_01FEBC

  + CMP.B #$08
    BCC -
    JSR CODE_01FF5B
  - RTS

CODE_01FC62:
    LDA.B PlayerAnimation
    CMP.B #$01
    BCS -
    LDA.W SpriteMisc160E,X
    BNE -
    LDA.B SpriteXPosLow,X
    CMP.B #$20
    BCC CODE_01FC77
    CMP.B #$D8
    BCC +
CODE_01FC77:
    LDA.W IggyLarryTempXPos
    STA.B SpriteXPosLow,X
    LDA.W IggyLarryTempYPos
    STA.B SpriteYPosLow,X
    INC.W SpriteMisc160E,X
  + LDA.W IggyLarryTempXPos
    SEC
    SBC.B #$08
    STA.B _0
    LDA.W IggyLarryTempYPos
    CLC
    ADC.B #$60
    STA.B _1
    LDA.B #$0F
    STA.B _2
    LDA.B #$0C
    STA.B _3
    STZ.B _8
    STZ.B _9
    LDA.B PlayerXPosScrRel
    CLC
    ADC.B #$02
    STA.B _4
    LDA.B PlayerYPosScrRel
    CLC
    ADC.B #$10
    STA.B _5
    LDA.B #$0C
    STA.B _6
    LDA.B #$0E
    STA.B _7
    STZ.B _A
    STZ.B _B
    JSL CheckForContact
    BCC CODE_01FD0A
    LDA.W SpriteMisc1558,X
    BNE Return01FD09
    LDA.B #$08
    STA.W SpriteMisc1558,X
    LDA.B PlayerInAir
    BEQ CODE_01FD05
    LDA.B #!SFX_ENEMYHURT                     ; \ Play sound effect
    STA.W SPCIO3                              ; /
    JSL BoostMarioSpeed
    LDA.B SpriteXPosLow,X
    PHA
    LDA.B SpriteYPosLow,X
    PHA
    LDA.W IggyLarryTempXPos
    SEC
    SBC.B #$08
    STA.B SpriteXPosLow,X
    LDA.W IggyLarryTempYPos
    SEC
    SBC.B #$10
    STA.B SpriteYPosLow,X
    STZ.W SpriteOffscreenX,X
    JSL DisplayContactGfx
    PLA
    STA.B SpriteYPosLow,X
    PLA
    STA.B SpriteXPosLow,X
    LDA.W SpriteMisc154C,X
    BNE Return01FD09
    LDA.B #$18
    STA.W SpriteMisc154C,X
    RTS

CODE_01FD05:
    JSL HurtMario
Return01FD09:
    RTS

CODE_01FD0A:
    LDY.B #$0A
CODE_01FD0C:
    STY.W SpriteInterIndex
    LDA.W ExtSpriteNumber,Y
    CMP.B #$05
    BNE +
    LDA.W ExtSpriteXPosLow,Y
    SEC
    SBC.B Layer1XPos
    STA.B _4
    STZ.B _A
    LDA.W ExtSpriteYPosLow,Y
    SEC
    SBC.B Layer1YPos
    STA.B _5
    STZ.B _B
    LDA.B #$08
    STA.B _6
    STA.B _7
    JSL CheckForContact
    BCC +
    LDA.B #$01                                ; \ Extended sprite = Smoke puff
    STA.W ExtSpriteNumber,Y                   ; /
    LDA.B #$0F
    STA.W ExtSpriteMisc176F,Y
    LDA.B #!SFX_BONK                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.B #$10
    STA.W SpriteMisc154C,X
  + DEY
    CPY.B #$07
    BNE CODE_01FD0C
    RTS

CODE_01FD50:
    LDA.B SpriteXPosLow,X
    CLC
    ADC.B #$08
    STA.W IggyLarryPlatIntXPos
    LDA.W SpriteXPosHigh,X
    ADC.B #$00
    STA.W IggyLarryPlatIntXPos+1
    LDA.B SpriteYPosLow,X
    CLC
    ADC.B #$2F
    STA.W IggyLarryPlatIntYPos
    LDA.W SpriteYPosHigh,X
    ADC.B #$00
    STA.W IggyLarryPlatIntYPos+1
    REP #$20                                  ; A->16
    LDA.B Mode7Angle
    EOR.W #$01FF
    INC A
    AND.W #$01FF
    STA.B Mode7Angle
    SEP #$20                                  ; A->8
    PHX
    JSL CODE_01CC9D
    PLX
    REP #$20                                  ; A->16
    LDA.B Mode7Angle
    EOR.W #$01FF
    INC A
    AND.W #$01FF
    STA.B Mode7Angle
    SEP #$20                                  ; A->8
    RTS


DATA_01FD95:
    db $04,$0B,$0B,$0B,$0B,$0A,$0A,$09
    db $09,$08,$08,$07,$04,$05,$05,$05
BallPositionDispX:
    db $08,$F8

ThrowBall:
    LDY.B #$05                                ; \ Find an open sprite index
CODE_01FDA9:
    LDA.W SpriteStatus,Y                      ; |
    BEQ GenerateBall                          ; |
    DEY                                       ; |
    BPL CODE_01FDA9                           ; /
    RTS

GenerateBall:
    LDA.B #!SFX_SPIT                          ; \ Play sound effect
    STA.W SPCIO0                              ; /
    LDA.B #$08                                ; \ Sprite status = normal
    STA.W SpriteStatus,Y                      ; /
    LDA.B #$A7                                ; \ Sprite to throw = Ball
    STA.W SpriteNumber,Y                      ; /
    PHX                                       ; \ Before: X must have index of sprite being generated
    TYX                                       ; | Routine clears *all* old sprite values...
    JSL InitSpriteTables                      ; | ...and loads in new values for the 6 main sprite tables
    PLX                                       ; /
    PHX                                       ; Push Iggy's sprite index
    LDA.W SpriteMisc157C,X                    ; \ Ball's direction = Iggy'direction
    STA.W SpriteMisc157C,Y                    ; /
    TAX                                       ; X = Ball's direction
    LDA.W IggyLarryTempXPos                    ; \ Set Ball X position
    SEC                                       ; |
    SBC.B #$08                                ; |
    ADC.W BallPositionDispX,X                 ; |
    STA.W SpriteXPosLow,Y                     ; |
    LDA.B #$00                                ; |
    STA.W SpriteXPosHigh,Y                    ; /
    LDA.W IggyLarryTempYPos                   ; \ Set Ball Y position
    SEC                                       ; |
    SBC.B #$18                                ; |
    STA.W SpriteYPosLow,Y                     ; |
    LDA.B #$00                                ; |
    SBC.B #$00                                ; |
    STA.W SpriteYPosHigh,Y                    ; /
    PLX                                       ; X = Iggy's sprite index
    RTS


DATA_01FDF3:
    db $F7,$FF,$00,$F8,$F7,$FF,$00,$F8
    db $F8,$00,$00,$F8,$FB,$03,$00,$F8
    db $F8,$00,$00,$F8,$FA,$02,$00,$F8
    db $00,$00,$F8,$00,$00,$F8,$00,$F8
    db $00,$00,$00,$00,$FB,$F8,$00,$F8
    db $F4,$F8,$00,$F8,$00,$F8,$00,$F8
    db $09,$09,$00,$10,$09,$09,$00,$10
    db $08,$08,$00,$10,$05,$05,$00,$10
    db $08,$08,$00,$10,$06,$06,$00,$10
    db $00,$08,$08,$08,$00,$10,$00,$10
    db $00,$08,$00,$08,$05,$10,$00,$10
    db $0C,$10,$00,$10,$00,$10,$00,$10
DATA_01FE53:
    db $FA,$F2,$00,$09,$F9,$F1,$00,$08
    db $F8,$F0,$00,$08,$FE,$F6,$00,$08
    db $FC,$F4,$00,$08,$FF,$F7,$00,$08
    db $00,$F0,$F8,$F0,$00,$00,$00,$00
    db $00,$00,$00,$00,$FC,$00,$00,$00
    db $F9,$00,$00,$00,$00,$08,$00,$08
DATA_01FE83:
    db $00,$0C,$02,$0A,$00,$0C,$22,$0A
    db $00,$0C,$20,$0A,$00,$0C,$20,$0A
    db $00,$0C,$20,$0A,$00,$0C,$20,$0A
    db $24,$1C,$04,$1C,$0E,$0D,$0E,$0D
    db $0E,$1D,$0E,$1D,$4A,$0D,$0E,$0D
    db $4A,$0D,$0E,$0D,$20,$0A,$20,$0A
DATA_01FEB3:
    db $06,$02,$08

DATA_01FEB6:
    db $02

DATA_01FEB7:
    db $00,$02,$00,$37,$3B

CODE_01FEBC:
    LDY.B SpriteTableC2,X
    LDA.W DATA_01FEB7,Y
    STA.B _D
    STY.B _5
    LDY.W SpriteOAMIndex,X                    ; Y = Index into sprite OAM
    LDA.W SpriteMisc157C,X
    LSR A
    ROR A
    LSR A
    AND.B #$40
    EOR.B #$40
    STA.B _2
    LDA.W SpriteMisc1602,X
    ASL A
    ASL A
    STA.B _3
    PHX
    LDX.B #$03
CODE_01FEDE:
    PHX
    TXA
    CLC
    ADC.B _3
    TAX
    PHX
    LDA.B _2
    BEQ +
    TXA
    CLC
    ADC.B #$30
    TAX
  + LDA.W IggyLarryTempXPos
    SEC
    SBC.B #$08
    CLC
    ADC.W DATA_01FDF3,X
    STA.W OAMTileXPos+$100,Y
    PLX
    LDA.W IggyLarryTempYPos
    CLC
    ADC.B #$60
    CLC
    ADC.W DATA_01FE53,X
    STA.W OAMTileYPos+$100,Y
    LDA.W DATA_01FE83,X
    STA.W OAMTileNo+$100,Y
    PHX
    LDX.B _5
    CPX.B #$03
    BNE +
    CMP.B #$05
    BCS +
    LSR A
    TAX
    LDA.W DATA_01FEB3,X
    STA.W OAMTileNo+$100,Y
  + LDA.W OAMTileNo+$100,Y
    CMP.B #$4A
    LDA.B _D
    BCC +
    LDA.B #$35                                ;  Iggy ball palette
  + ORA.B _2
    STA.W OAMTileAttr+$100,Y
    PLA
    AND.B #$03
    TAX
    PHY
    TYA
    LSR A
    LSR A
    TAY
    LDA.W DATA_01FEB6,X
    STA.W OAMTileSize+$40,Y
    PLY
    INY
    INY
    INY
    INY
    PLX
    DEX
    BPL CODE_01FEDE
    PLX
    LDY.B #$FF
    LDA.B #$03
    JSR FinishOAMWriteRt
    RTS


DATA_01FF53:
    db $2C,$2E,$2C,$2E

DATA_01FF57:
    db $00,$00,$40,$00

CODE_01FF5B:
    PHX
    LDY.B SpriteTableC2,X
    LDA.W DATA_01FEB7,Y
    STA.B _D
    LDY.B #$70
    LDA.W IggyLarryTempXPos
    SEC
    SBC.B #$08
    STA.W OAMTileXPos+$100,Y
    LDA.W IggyLarryTempYPos
    CLC
    ADC.B #$60
    STA.W OAMTileYPos+$100,Y
    LDA.B EffFrame
    LSR A
    AND.B #$03
    TAX
    LDA.W DATA_01FF53,X
    STA.W OAMTileNo+$100,Y
    LDA.B #$30
    ORA.W DATA_01FF57,X
    ORA.B _D
    STA.W OAMTileAttr+$100,Y
    TYA
    LSR A
    LSR A
    TAY
    LDA.B #$02
    STA.W OAMTileSize+$40,Y
    PLX
    RTS

CODE_01FF98:
    LDA.B SpriteXPosLow,X                     ; \ $14B4,$14B5 = Sprite X position + #$08
    CLC                                       ; |
    ADC.B #$08                                ; |
    STA.W IggyLarryPlatIntXPos                ; |
    LDA.W SpriteXPosHigh,X                    ; |
    ADC.B #$00                                ; |
    STA.W IggyLarryPlatIntXPos+1              ; /
    LDA.B SpriteYPosLow,X                     ; \ $14B6,$14B7 = Sprite Y position + #$0F
    CLC                                       ; |
    ADC.B #$0F                                ; |
    STA.W IggyLarryPlatIntYPos                ; |
    LDA.W SpriteYPosHigh,X                    ; |
    ADC.B #$00                                ; |
    STA.W IggyLarryPlatIntYPos+1              ; /
    PHX
    JSL CODE_01CC9D
    PLX
    RTS

    %insert_empty($3E,$41,$41,$41,$41)